/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************
**
**       Programa: AQAPI004
**
**       Objetivo: Gera‡Æo de Nota Fiscal
**        Cria‡Æo: 12/12/2016
**
*****************************************************************************/

{include/i-prgvrs.i AQAPI004 2.00.00.037 } /*** "010037" 06/08/2026 17:40:48 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQAPI004 MAQ}
&ENDIF

DEFINE TEMP-TABLE ttRowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

{inbo/boin090.i tt-docum-est}
{inbo/boin090.i tt-docum-est-aux}
{inbo/boin366.i tt-rat-docum}
{inbo/boin176.i tt-item-doc-est}    
{inbo/boin176.i tt-item-doc-est-aux}
{inbo/boin092.i tt-dupli-apagar}
{inbo/boin567.i tt-dupli-imp}
{cdp/cd9701.i}
{aqp/aqapi004.i}
{aqp/aqapi004.i1} /* Definicao  tt-retorno-nota tt-erro-imp tt-fechto-docto Shared */
{method/dbotterr.i}  /*--- Include com defini‡Æo da temp-table RowErrors ---*/

{cdp/cdcfgdis.i}
{utp/ut-glob.i}
{cdp/cdcfgmat.i}

{cdp/cd4400.i} /* pi-traduz-empresa-estab-pais */ /* pi-busca-tipo-imposto */

DEFINE SHARED VARIABLE h-acomp AS HANDLE NO-UNDO.

DEFINE VARIABLE l-erro                AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE c-nat-operacao        AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-val-despesa         AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE h-cdapi034            AS HANDLE                     NO-UNDO.
DEFINE VARIABLE i-cod-regra-utilizada AS INTEGER                    NO-UNDO.
DEFINE VARIABLE l-achou-tt-retorno    AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE c-msg-obs             AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-cod-entrega         LIKE tt-docum-est.cod-entrega NO-UNDO.
DEFINE VARIABLE c-endereco            LIKE tt-docum-est.endereco    NO-UNDO.
DEFINE VARIABLE c-bairro              LIKE tt-docum-est.bairro      NO-UNDO.
DEFINE VARIABLE c-cep                 LIKE tt-docum-est.cep         NO-UNDO.
DEFINE VARIABLE c-cidade              LIKE tt-docum-est.cidade      NO-UNDO.
DEFINE VARIABLE c-pais-end            LIKE tt-docum-est.pais        NO-UNDO.
DEFINE VARIABLE c-estado              LIKE tt-docum-est.uf          NO-UNDO.
DEFINE VARIABLE c-nf-credito          AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-qtde-1              AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-qtde-2              AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-val-desconto        AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-var-preco-total     AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-val_preco-unit      AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-val_ajuste          AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-cod-evento          AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-nat-oper-1          AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-nat-oper-2          AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-nat-oper-comp-1     AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-nat-oper-comp-2     AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-agrupa_item         AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE de-perc-icentivo      AS DECIMAL                    NO-UNDO.
DEFINE VARIABLE i-nr-docto            AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE i-nr-docto-2          AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-formato             AS CHARACTER FORMAT "x(16)":U NO-UNDO. /*Utilizado no pre-processador {&bf_libera_15_posicoes}*/
DEFINE VARIABLE i-casas               AS INTEGER                    NO-UNDO.
DEFINE VARIABLE i-tipo-nf             AS INTEGER                    NO-UNDO.

&if '{&bf_libera_15_posicoes}' = 'yes' &then
    assign c-formato = ">>>>>>>>9999999". /* Formato de 15 posi»„es */
&else
    assign c-formato = ">>>9999999". /* Formato de 10 posi»„es */
&endif

DEFINE BUFFER bf-fechto-produt-period FOR fechto-produt-period.

PROCEDURE pi-execute:

    DEFINE INPUT PARAM p-tipo AS INT NO-UNDO.
    DEFINE INPUT PARAM TABLE FOR tt-param.
    DEFINE INPUT PARAM TABLE FOR tt-digita.
    DEFINE OUTPUT PARAM TABLE FOR tt-retorno-nota.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro-imp.
    
    /* 0 - NF PadrÆo
       1 - NF Complementar */
    ASSIGN i-tipo-nf = p-tipo.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND FIRST tt-param NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-param THEN
        LEAVE.

    FIND FIRST param-re WHERE param-re.usuario = tt-param.usuario NO-LOCK NO-ERROR.

    IF CAN-FIND(FIRST tt-digita) THEN DO:
    
        FOR EACH tt-digita:

            FOR EACH fechto-produt-period NO-LOCK
               WHERE fechto-produt-period.cod-period       = tt-param.cod-periodo
                 AND fechto-produt-period.cdn-produt-rural = tt-digita.cdn-produt
                 AND fechto-produt-period.cod-propried     = tt-digita.cod-propried
                 AND fechto-produt-period.it-codigo        = tt-param.it-codigo
                 AND fechto-produt-period.cod-estabel      = tt-param.cod-estabel
                 AND fechto-produt-period.idi-situacao     = IF i-tipo-nf = 1 THEN 3 ELSE 2: /*Se for NF Complementar usar situa‡Æo 3(NF Gerada) senÆo usa 2(Confirmado)*/

                ASSIGN l-erro = NO.    

                RUN pi-cria-tt-documento.
    
                IF RETURN-VALUE = "NOK":U THEN
                    UNDO,NEXT.
    
            END.
    
        END.
    
    END.
    ELSE DO: /*percorre registros com base na aba sele‡Æo*/
    
        FOR EACH produt-rural FIELDS (cdn-produt-rural log-optan-incent)
           WHERE produt-rural.cdn-produt-rural >= tt-param.prod-rural-ini
             AND produt-rural.cdn-produt-rural <= tt-param.prod-rural-fim
             AND produt-rural.cdn-grp-produt   >= tt-param.grp-prod-ini
             AND produt-rural.cdn-grp-produt   <= tt-param.grp-prod-fim NO-LOCK:
    
            FOR EACH fechto-produt-period NO-LOCK
               WHERE fechto-produt-period.cod-period       = tt-param.cod-periodo
                 AND fechto-produt-period.cdn-produt-rural = produt-rural.cdn-produt-rural
                 AND fechto-produt-period.it-codigo        = tt-param.it-codigo
                 AND fechto-produt-period.cod-estabel      = tt-param.cod-estabel
                 AND fechto-produt-period.cod-regiao       >= tt-param.regiao-ini 
                 AND fechto-produt-period.cod-regiao       <= tt-param.regiao-fim
                 AND fechto-produt-period.cod-rota         >= tt-param.rota-ini
                 AND fechto-produt-period.cod-rota         <= tt-param.rota-fim
                 AND fechto-produt-period.idi-situacao      = 2: /*confirmado*/
    
                ASSIGN l-erro = NO.    
    
                RUN pi-cria-tt-documento.
                IF RETURN-VALUE = "NOK":U THEN
                    UNDO,NEXT.
    
            END.
            
        
        END.
    
    END.

    IF  CAN-FIND(FIRST tt-docum-est) THEN
        RUN pi-efetiva-documentos.

    run pi-finalizar in h-acomp.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-tt-documento: /*cria as tt-docum-est para todas as fechto (seguindo as faixas da tela)*/

    {utp/ut-liter.i Produtor *}
    RUN pi-acompanhar in h-acomp (INPUT RETURN-VALUE + ": ":U + string(fechto-produt-period.cdn-produt-rural)).

    ASSIGN de-perc-icentivo = 0
           c-val-despesa    = "".

    /*vai até o engine trazer os dados conforme regras e volume do produtor*/
    RUN pi-engine-regras.
    IF RETURN-VALUE = "NOK":U THEN
      RETURN "NOK":U.


    /* monta tt-docum-est-aux e tt-item-doc-est-aux que serão usadas para */
    /* criar tt-docum-est e tt-item-doc-est para enviar à REAPI316        */
    RUN pi-monta-TT-aux.

    /*     cria tt-docum-est e tt-item-doc-est    */
    /* que serão efetivadas na base pela reapi316 */
    RUN pi-prepara-TT-docum.
    IF RETURN-VALUE = "NOK":U THEN
      RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

PROCEDURE pi-engine-regras:

    DEF VAR de-qtd-acum-compl LIKE quant-fornec-produt.qtd-fornec  NO-UNDO.
    DEF VAR de-vol-mes-compl  LIKE fechto-produt-period.qtd-period NO-UNDO.
    
    /*Busca dados no Engine de Regras para tratamento de incentivo*/
    FOR FIRST produt-rural FIELDS(cdn-produt-rural log-optan-incent) NO-LOCK
        WHERE produt-rural.cdn-produt-rural = fechto-produt-period.cdn-produt-rural:
    END.

    IF NOT AVAIL produt-rural THEN
        RETURN "NOK":U.
        
    /*
	FOR FIRST emitente FIELDS(nome-abrev natureza)
        WHERE emitente.cod-emitente = produt-rural.cdn-produt-rural NO-LOCK: 
       
        IF emitente.natureza = 2 THEN DO: /* PESSOA JURIDICA */         
            RUN utp/ut-msgs.p (INPUT "MSG", 
                               INPUT 55000, /* Fornecedor &1 é pessoa Jurídica - Nota Fiscal não foi gerada */
                               INPUT STRING(produt-rural.cdn-produt-rural)).
            CREATE tt-erro-imp.
            ASSIGN tt-erro-imp.cdn-produt-rural = produt-rural.cdn-produt-rural
                   tt-erro-imp.nom-produt-rural = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""
                   tt-erro-imp.cd-erro          = 55000
                   tt-erro-imp.desc-erro        = RETURN-VALUE
                   l-erro                       = YES.  
            RETURN "NOK":U.
        END.
    END.
    */
	
    /*controle de quantidade entregue pelo produtor*/
    FOR FIRST quant-fornec-produt FIELDS(qtd-fornec) NO-LOCK
        WHERE quant-fornec-produt.cdn-produt-rural = produt-rural.cdn-produt-rural
          AND quant-fornec-produt.it-codigo        = tt-param.it-codigo
          AND quant-fornec-produt.dat-inic         <= tt-param.dt-emissao
          AND quant-fornec-produt.dat-fim          >= tt-param.dt-emissao:
    END.

    /*Se nÆo achou, cria default*/
    IF NOT AVAIL quant-fornec-produt THEN DO:
        
        {utp/ut-liter.i Inclu¡do_automaticamente_pelo_AQ0311 *}
        CREATE quant-fornec-produt.
        ASSIGN quant-fornec-produt.cdn-produt-rural = produt-rural.cdn-produt-rural
               quant-fornec-produt.it-codigo        = tt-param.it-codigo
               quant-fornec-produt.dat-inic         = date("01/01/" + STRING(YEAR(tt-param.dt-emissao)))
               quant-fornec-produt.dat-fim          = date("31/12/" + STRING(YEAR(tt-param.dt-emissao)))
               quant-fornec-produt.qtd-fornec       = 0
               quant-fornec-produt.cod-obs          = RETURN-VALUE.

    END.

    /*Nota Complementar - Calcula Quantidade Descontada para enviar para o engine de regras*/
    IF i-tipo-nf = 1 THEN
        RUN calculaQuantidadeDescontada (INPUT tt-param.cod-periodo,
                                         INPUT tt-digita.cdn-produt,
                                         INPUT tt-digita.cod-propried,
                                         INPUT tt-param.cod-estabel,
                                         INPUT tt-param.it-codigo,
                                         INPUT tt-param.cod-periodo,
                                         INPUT tt-param.dt-emissao,
                                         OUTPUT de-qtd-acum-compl,
                                         OUTPUT de-vol-mes-compl).

    IF CAN-FIND(FIRST config-operac 
                WHERE config-operac.cdn-empresa    = i-ep-codigo-usuario
                  AND config-operac.cod-estab      = tt-param.cod-estabel
                  AND config-operac.cod-tip-operac = "AQR-NF-Produtor":U) THEN DO:

        EMPTY TEMP-TABLE tt-variavel.

        /*Carrega variaveis para o engine de regras*/
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "optante":U
               tt-variavel.valor-variavel    = IF AVAIL produt-rural THEN string(produt-rural.log-optan-incent) ELSE "No" /*Verificar campo*/.

        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "item":U
               tt-variavel.valor-variavel    = fechto-produt-period.it-codigo.
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "preco-base":U
               tt-variavel.valor-variavel    = STRING(fechto-produt-period.val-preco-base,">>>>>,>>>,>>9.9999").
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "var-volume":U
               tt-variavel.valor-variavel    = string(fechto-produt-period.val-var-volum,"->>>,>>9.99999").
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "bonus-fix-inf":U
               tt-variavel.valor-variavel    = string(fechto-produt-period.val-bonus-fix-inf,"->>>,>>9.99999").
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "var-qualid":U
               tt-variavel.valor-variavel    = string(fechto-produt-period.val-var-qualid,"->>>,>>9.99999").

        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "vol-acum-ano":U.
        /*Se for nota complementar grava quantidade descontada*/
        IF i-tipo-nf = 1 THEN
            ASSIGN tt-variavel.valor-variavel    = string(de-qtd-acum-compl,">>>,>>>>,>>>,>>9.9999"). 
        ELSE
            ASSIGN tt-variavel.valor-variavel    = IF AVAIL quant-fornec-produt THEN string(quant-fornec-produt.qtd-fornec,">>>,>>>>,>>>,>>9.9999") ELSE "0".
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "vol-mes":U
               tt-variavel.valor-variavel    = string(fechto-produt-period.qtd-period,"->>>,>>>,>>9.99999").
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "vol-ano-mes":U.
        IF i-tipo-nf = 1 THEN
            ASSIGN tt-variavel.valor-variavel = string(de-qtd-acum-compl + fechto-produt-period.qtd-period,">>>,>>>>,>>>,>>9.9999").
        ELSE
            ASSIGN tt-variavel.valor-variavel = IF AVAIL quant-fornec-produt THEN 
                                                    string(quant-fornec-produt.qtd-fornec + fechto-produt-period.qtd-period,">>>,>>>>,>>>,>>9.9999") 
                                                ELSE 
                                                    string(fechto-produt-period.qtd-period,"->>>,>>>,>>9.99999").

        /*Se for nota complementar envia o pre‡o unitario informado*/
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "preco-final-inf":U.
        IF i-tipo-nf = 1 THEN
            ASSIGN tt-variavel.valor-variavel = IF AVAIL tt-digita THEN STRING(tt-digita.val-unit,">>>>>,>>>,>>9.9999") ELSE "0".
        ELSE
            ASSIGN tt-variavel.valor-variavel = string(fechto-produt-period.val-preco-final-inf,">>>>>,>>>,>>9.9999").
    
        RUN cdp/cdapi034.p  (INPUT i-ep-codigo-usuario,
                             INPUT tt-param.cod-estabel,
                             INPUT "AQR-NF-Produtor":U,
                             INPUT TABLE tt-variavel,
                             OUTPUT i-cod-regra-utilizada,
                             OUTPUT TABLE tt-retorno,
                             OUTPUT TABLE RowErrors).

        FOR EACH RowErrors:

            /*desconsidera erro de regra nÆo encontrada, neste caso ele ir  gerar as notas com os parametros informados em tela*/
            IF RowErrors.ErrorNumber = 25997 THEN
                NEXT.

            CREATE tt-erro-imp.
            ASSIGN tt-erro-imp.cdn-produt-rural = fechto-produt-period.cdn-produt-rural
                   tt-erro-imp.nom-produt-rural = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""
                   tt-erro-imp.cd-erro          = RowErrors.ErrorNumber
                   tt-erro-imp.desc-erro        = RowErrors.ErrorDescription
                   l-erro                       = YES.

        END.

        IF l-erro THEN
            RETURN "NOK":U.

        /*Elimina conte£do das Variaveis*/
        ASSIGN c-nf-credito      = ""
               c-qtde-1          = ""
               c-qtde-2          = ""
               c-val-despesa     = ""
               c-val-desconto    = ""
               c-var-preco-total = ""
               c-val_preco-unit  = ""
               c-val_ajuste      = ""
               c-cod-evento      = ""
               c-nat-oper-1      = ""
               c-nat-oper-2      = ""
               c-nat-oper-comp-1 = ""
               c-nat-oper-comp-2 = ""
               c-agrupa_item     = ""
               de-perc-icentivo  = 0.
        
        /*passa os retornos do engine para as variaveis apropriadas*/
        ASSIGN l-achou-tt-retorno = NO.
        FOR EACH tt-retorno:
            
            ASSIGN l-achou-tt-retorno = YES.
    
            IF tt-retorno.campo-retorno = "NF-Credito" THEN
                ASSIGN c-nf-credito = tt-retorno.valor-retorno.

            IF tt-retorno.campo-retorno = "Qtde-1" THEN
                ASSIGN c-qtde-1 = tt-retorno.valor-retorno.
    
            IF tt-retorno.campo-retorno = "Qtde-2" THEN
                ASSIGN c-qtde-2 = tt-retorno.valor-retorno.

            IF tt-retorno.campo-retorno = "Val-Despesa" THEN
                ASSIGN c-val-despesa = tt-retorno.valor-retorno.
    
            IF tt-retorno.campo-retorno = "Val-Desconto" THEN
                ASSIGN c-val-desconto = tt-retorno.valor-retorno.
    
            IF tt-retorno.campo-retorno = "Val-Preco-Total" THEN
                ASSIGN c-var-preco-total = tt-retorno.valor-retorno.
    
            IF tt-retorno.campo-retorno = "Val-Preco-Unit" THEN
                ASSIGN c-val_preco-unit = tt-retorno.valor-retorno.

            IF tt-retorno.campo-retorno = "Val-ajuste" THEN
                ASSIGN c-val_ajuste = tt-retorno.valor-retorno.
            
            IF tt-retorno.campo-retorno = "Cod-evento" THEN
                ASSIGN c-cod-evento = tt-retorno.valor-retorno.

            IF tt-retorno.campo-retorno = "Nat-Oper-1" THEN
                IF CAN-FIND (FIRST natur-oper WHERE natur-oper.nat-operacao = tt-retorno.valor-retorno) THEN
                    ASSIGN c-nat-oper-1 = tt-retorno.valor-retorno.
    
            IF tt-retorno.campo-retorno = "Nat-Oper-2" THEN
                IF CAN-FIND (FIRST natur-oper WHERE natur-oper.nat-operacao = tt-retorno.valor-retorno) THEN
                    ASSIGN c-nat-oper-2 = tt-retorno.valor-retorno.

            IF tt-retorno.campo-retorno = "Nat-Oper-comp-1" THEN
                IF CAN-FIND (FIRST natur-oper WHERE natur-oper.nat-operacao = tt-retorno.valor-retorno) THEN
                    ASSIGN c-nat-oper-comp-1 = tt-retorno.valor-retorno.

            IF tt-retorno.campo-retorno = "Nat-Oper-comp-2" THEN
                IF CAN-FIND (FIRST natur-oper WHERE natur-oper.nat-operacao = tt-retorno.valor-retorno) THEN
                    ASSIGN c-nat-oper-comp-2 = tt-retorno.valor-retorno.
    
            IF tt-retorno.campo-retorno = "Agrupa-Item" THEN
                ASSIGN c-agrupa_item = tt-retorno.valor-retorno.
    
            IF tt-retorno.campo-retorno = "Perc-Incentivo" THEN
                ASSIGN de-perc-icentivo = dec(tt-retorno.valor-retorno) * 100.

            
        END.

        /*Se nÆo retornou o pre‡o unit rio busca informado em tela*/
        IF c-val_preco-unit = "" THEN
            ASSIGN c-val_preco-unit = IF AVAIL tt-digita THEN STRING(tt-digita.val-unit) ELSE "0".
        
    END.

    RETURN "OK":U.    

END PROCEDURE.

PROCEDURE pi-monta-TT-aux:

    /*Monta temp-tables com o tratamento de incentivo conforme retorno do engine de regras*/

    EMPTY TEMP-TABLE tt-docum-est-aux.
    EMPTY TEMP-TABLE tt-item-doc-est-aux.

    DEF VAR de-val-preco  LIKE fechto-produt-period.val-preco-final-inf NO-UNDO.
    DEF VAR de-val-ajuste AS DEC NO-UNDO.

    
    IF i-tipo-nf = 1 THEN /*NF Complementar*/
        ASSIGN de-val-preco  = dec(c-val_preco-unit) /*Pre‡o unit rio retornado pelo engine de regras ou informado em tela*/
               de-val-ajuste = DEC(c-val_ajuste). /*valor ajuste retornado do engine de regras*/
    ELSE
        ASSIGN de-val-preco = fechto-produt-period.val-preco-final-inf /*Pre‡o Final no AQ0315*/
               de-val-ajuste = DEC(fechto-produt-period.val-livre-1). /*valor do ajuste no AQ0315*/

    /*Credito Sim ou NÆo*/
    IF c-nf-credito = "SIM":U THEN DO:

        ASSIGN c-nat-operacao = IF i-tipo-nf = 1 THEN c-nat-oper-comp-2 ELSE c-nat-oper-2.
        RUN pi-buscaNroDocto (OUTPUT i-nr-docto).

        CREATE tt-docum-est-aux.
        ASSIGN tt-docum-est-aux.nro-docto    = i-nr-docto
               tt-docum-est-aux.nat-operacao = c-nat-operacao
               tt-docum-est-aux.valor-outras = IF dec(c-val-despesa) > 0 THEN dec(c-val-despesa) ELSE 0.


        IF c-nf-credito = "SIM":U THEN DO:

            CREATE tt-item-doc-est-aux.
            ASSIGN tt-item-doc-est-aux.nro-docto      = tt-docum-est-aux.nro-docto
                   tt-item-doc-est-aux.nat-operacao   = tt-docum-est-aux.nat-operacao 
                   tt-item-doc-est-aux.sequencia      = IF AVAIL param-re THEN param-re.seq-item-um ELSE 1
                   tt-item-doc-est-aux.nat-of         = tt-docum-est-aux.nat-operacao
                   tt-item-doc-est-aux.despesas[1]    = IF dec(c-val-despesa) > 0 THEN dec(c-val-despesa) ELSE 0
                   tt-item-doc-est-aux.preco-total[1] = IF i-tipo-nf = 1 THEN 
                                                          IF DEC(c-var-preco-total) > 0 THEN DEC(c-var-preco-total)
                                                                                        ELSE tt-digita.val-total
                                                        ELSE
                                                          IF DEC(c-var-preco-total) > 0 THEN DEC(c-var-preco-total) 
                                                                                        ELSE fechto-produt-period.qtd-period * (de-val-preco + de-val-ajuste) /*ajuste*/.
            IF i-tipo-nf = 1 THEN
                ASSIGN tt-item-doc-est-aux.quantidade = 0
                       tt-item-doc-est-aux.quant-conf = 0.
            ELSE
                ASSIGN tt-item-doc-est-aux.quantidade = IF dec(c-qtde-2) > 0 THEN dec(c-qtde-2) ELSE fechto-produt-period.qtd-period
                       tt-item-doc-est-aux.quant-conf = IF dec(c-qtde-2) > 0 THEN (dec(c-qtde-2) / fechto-produt-period.qtd-period * fechto-produt-period.qtd-aferid) ELSE fechto-produt-period.qtd-aferid.

        END.
        
    END.
    ELSE IF c-nf-credito = "PARCIAL":U THEN DO: /*Credito Sim_Parcial*/

        IF c-agrupa_item = "SIM":U AND l-mult-natur-receb THEN DO:

            ASSIGN c-nat-operacao = IF i-tipo-nf = 1 THEN c-nat-oper-comp-2 ELSE c-nat-oper-2.
            RUN pi-buscaNroDocto (OUTPUT i-nr-docto).

            /* Item 1 */
            CREATE tt-docum-est-aux.
            ASSIGN tt-docum-est-aux.nro-docto    = i-nr-docto
                   tt-docum-est-aux.nat-operacao = c-nat-operacao
                   tt-docum-est-aux.valor-outras = IF dec(c-val-despesa) > 0 THEN dec(c-val-despesa) ELSE 0.

            CREATE tt-item-doc-est-aux.
            ASSIGN tt-item-doc-est-aux.nro-docto      = tt-docum-est-aux.nro-docto
                   tt-item-doc-est-aux.nat-operacao   = tt-docum-est-aux.nat-operacao
                   tt-item-doc-est-aux.sequencia      = IF AVAIL param-re THEN param-re.seq-item-um ELSE 1
                   tt-item-doc-est-aux.nat-of         = IF i-tipo-nf = 1 THEN c-nat-oper-comp-1 ELSE c-nat-oper-1
                   tt-item-doc-est-aux.despesas[1]    = 0
                   tt-item-doc-est-aux.preco-total[1] = IF DEC(c-var-preco-total) > 0 THEN DEC(c-var-preco-total)
                                                                                      ELSE DEC(c-qtde-1) * (de-val-preco + de-val-ajuste). /* Quantidade sem incentivo */
            IF i-tipo-nf = 1 THEN
                ASSIGN tt-item-doc-est-aux.quantidade = 0
                       tt-item-doc-est-aux.quant-conf = 0.
            ELSE
                ASSIGN tt-item-doc-est-aux.quantidade = IF dec(c-qtde-1) > 0 THEN dec(c-qtde-1) ELSE fechto-produt-period.qtd-period
                       tt-item-doc-est-aux.quant-conf = IF dec(c-qtde-1) > 0 THEN (dec(c-qtde-1) / fechto-produt-period.qtd-period * fechto-produt-period.qtd-aferid) ELSE fechto-produt-period.qtd-aferid.
    
            /* Item 2 */
            CREATE tt-item-doc-est-aux.
            ASSIGN tt-item-doc-est-aux.nro-docto      = tt-docum-est-aux.nro-docto
                   tt-item-doc-est-aux.nat-operacao   = tt-docum-est-aux.nat-operacao
                   tt-item-doc-est-aux.sequencia      = IF AVAIL param-re THEN param-re.seq-item-um + param-re.inc-seq ELSE 2
                   tt-item-doc-est-aux.nat-of         = IF i-tipo-nf = 1 THEN c-nat-oper-comp-2 ELSE c-nat-oper-2
                   tt-item-doc-est-aux.despesas[1]    = IF dec(c-val-despesa) > 0 THEN dec(c-val-despesa) ELSE 0

                   tt-item-doc-est-aux.preco-total[1] = IF DEC(c-var-preco-total) > 0 THEN DEC(c-var-preco-total)
                                                                                      ELSE DEC(c-qtde-2) * (de-val-preco + de-val-ajuste). /* Quantidade com incentivo */
                                                        
            IF i-tipo-nf = 1 THEN
                ASSIGN tt-item-doc-est-aux.quantidade = 0
                       tt-item-doc-est-aux.quant-conf = 0.
            ELSE
                ASSIGN tt-item-doc-est-aux.quantidade = IF dec(c-qtde-2) > 0 THEN dec(c-qtde-2) ELSE fechto-produt-period.qtd-period
                       tt-item-doc-est-aux.quant-conf = IF dec(c-qtde-2) > 0 THEN (dec(c-qtde-2) / fechto-produt-period.qtd-period * fechto-produt-period.qtd-aferid) ELSE fechto-produt-period.qtd-aferid.

        END.
        ELSE DO:
            ASSIGN c-nat-operacao = IF i-tipo-nf = 1 THEN c-nat-oper-comp-1 ELSE c-nat-oper-1.
            RUN pi-buscaNroDocto (OUTPUT i-nr-docto).

            /*Documento 1*/
            CREATE tt-docum-est-aux.
            ASSIGN tt-docum-est-aux.nro-docto    = i-nr-docto
                   tt-docum-est-aux.nat-operacao = c-nat-operacao.

            CREATE tt-item-doc-est-aux.
            ASSIGN tt-item-doc-est-aux.nro-docto      = tt-docum-est-aux.nro-docto
                   tt-item-doc-est-aux.nat-operacao   = tt-docum-est-aux.nat-operacao
                   tt-item-doc-est-aux.sequencia      = IF AVAIL param-re THEN param-re.seq-item-um ELSE 1
                   tt-item-doc-est-aux.nat-of         = tt-docum-est-aux.nat-operacao
                   tt-item-doc-est-aux.preco-total[1] = IF DEC(c-var-preco-total) > 0 THEN DEC(c-var-preco-total) 
                                                                                      ELSE DEC(c-qtde-1) * (de-val-preco + de-val-ajuste) /* Quantidade sem incentivo */.
            IF i-tipo-nf = 1 THEN
                ASSIGN tt-item-doc-est-aux.quantidade = 0
                       tt-item-doc-est-aux.quant-conf = 0.
            ELSE
                ASSIGN tt-item-doc-est-aux.quantidade = IF dec(c-qtde-1) > 0 THEN dec(c-qtde-1) ELSE fechto-produt-period.qtd-period
                       tt-item-doc-est-aux.quant-conf = IF dec(c-qtde-1) > 0 THEN (dec(c-qtde-1) / fechto-produt-period.qtd-period * fechto-produt-period.qtd-aferid) ELSE fechto-produt-period.qtd-aferid.

            /*Documento 2*/
            ASSIGN c-nat-operacao = IF i-tipo-nf = 1 THEN c-nat-oper-comp-2 ELSE c-nat-oper-2.
            RUN pi-buscaNroDocto (OUTPUT i-nr-docto-2).

            IF i-tipo-nf = 1 THEN
                ASSIGN i-nr-docto = IF c-nat-oper-comp-2 = c-nat-oper-comp-1 THEN string(int(i-nr-docto) + 1) ELSE i-nr-docto-2.
            ELSE
                ASSIGN i-nr-docto = IF c-nat-oper-2 = c-nat-oper-1 THEN string(int(i-nr-docto) + 1) ELSE i-nr-docto-2.

            ASSIGN i-nr-docto = left-trim(string(DEC(i-nr-docto), c-formato)).

            CREATE tt-docum-est-aux.
            ASSIGN tt-docum-est-aux.nro-docto    = i-nr-docto
                   tt-docum-est-aux.nat-operacao = c-nat-operacao
                   tt-docum-est-aux.valor-outras = IF dec(c-val-despesa) > 0 THEN dec(c-val-despesa) ELSE 0.

            CREATE tt-item-doc-est-aux.
            ASSIGN tt-item-doc-est-aux.nro-docto      = tt-docum-est-aux.nro-docto
                   tt-item-doc-est-aux.nat-operacao   = tt-docum-est-aux.nat-operacao
                   tt-item-doc-est-aux.sequencia      = IF AVAIL param-re THEN param-re.seq-item-um ELSE 1
                   tt-item-doc-est-aux.nat-of         = tt-docum-est-aux.nat-operacao
                   tt-item-doc-est-aux.despesas[1]    = IF dec(c-val-despesa) > 0 THEN dec(c-val-despesa) ELSE 0
                   tt-item-doc-est-aux.preco-total[1] = IF DEC(c-var-preco-total) > 0 THEN DEC(c-var-preco-total) 
                                                                                      ELSE DEC(c-qtde-2) * (de-val-preco + de-val-ajuste) /* Quantidade com incentivo */.
            IF i-tipo-nf = 1 THEN
                ASSIGN tt-item-doc-est-aux.quantidade     = 0
                       tt-item-doc-est-aux.quant-conf     = 0.
            ELSE
                ASSIGN tt-item-doc-est-aux.quantidade     = IF dec(c-qtde-2) > 0 THEN dec(c-qtde-2) ELSE fechto-produt-period.qtd-period
                       tt-item-doc-est-aux.quant-conf     = IF dec(c-qtde-2) > 0 THEN (dec(c-qtde-2) / fechto-produt-period.qtd-period * fechto-produt-period.qtd-aferid) ELSE fechto-produt-period.qtd-aferid.
                

        END.

    END.

    /*NÆo achou regra*/
    IF NOT l-achou-tt-retorno OR (c-nf-credito = "NAO":U OR c-nf-credito = "":U) THEN DO:

        IF c-nf-credito = "NAO":U THEN
            ASSIGN c-nat-operacao = IF i-tipo-nf = 1 THEN c-nat-oper-comp-1 ELSE c-nat-oper-1.
        ELSE
            ASSIGN c-nat-operacao = tt-param.nat-operacao.

        RUN pi-buscaNroDocto (OUTPUT i-nr-docto).
        
        CREATE tt-docum-est-aux.
        ASSIGN tt-docum-est-aux.nro-docto    = i-nr-docto
               tt-docum-est-aux.nat-operacao = c-nat-operacao.

        CREATE tt-item-doc-est-aux.
        ASSIGN tt-item-doc-est-aux.nro-docto      = tt-docum-est-aux.nro-docto
               tt-item-doc-est-aux.nat-operacao   = tt-docum-est-aux.nat-operacao 
               tt-item-doc-est-aux.sequencia      = IF AVAIL param-re THEN param-re.seq-item-um ELSE 1
               tt-item-doc-est-aux.nat-of         = tt-docum-est-aux.nat-operacao
               tt-item-doc-est-aux.preco-total[1] = IF i-tipo-nf = 1 THEN tt-digita.val-total
                                                                     ELSE fechto-produt-period.qtd-period * (de-val-preco + de-val-ajuste) /*ajuste*/.
        IF i-tipo-nf = 1 THEN
            ASSIGN tt-item-doc-est-aux.quantidade = 0
                   tt-item-doc-est-aux.quant-conf = 0.
        ELSE
            ASSIGN tt-item-doc-est-aux.quantidade = fechto-produt-period.qtd-period
                   tt-item-doc-est-aux.quant-conf = fechto-produt-period.qtd-aferid.


    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-prepara-TT-docum:

    DEFINE VARIABLE cConta AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCusto AS CHARACTER NO-UNDO.

    FOR FIRST param-aquis-rural FIELDS(cod-cta-aquis-rural cod-ccusto-aquis-rural) 
        WHERE param-aquis-rural.cod-estabel = tt-param.cod-estabel NO-LOCK: 

       ASSIGN cConta = param-aquis-rural.cod-cta-aquis-rural
              cCusto = param-aquis-rural.cod-ccusto-aquis-rural.
    END.
    
    FOR FIRST item FIELDS(tipo-con-est fraciona)
        WHERE item.it-codigo = tt-param.it-codigo NO-LOCK:
    END.

    /*--- Gera registros na tt-docum-est que serao passados para a 
          reapi316 para efetivar o docum-est ---*/
    FOR EACH tt-docum-est-aux:

        ASSIGN c-msg-obs     = ""
               c-cod-entrega = ""
               c-endereco    = ""
               c-bairro      = ""
               c-cep         = ""
               c-cidade      = ""
               c-pais-end    = ""
               c-estado      = "".

        IF cConta = "":U THEN DO:

          FOR FIRST emitente FIELDS(nome-abrev)
              WHERE emitente.cod-emitente = fechto-produt-period.cdn-produt-rural NO-LOCK: END.

          RUN utp/ut-msgs.p (INPUT "help":U, 
                             INPUT 55439,
                             INPUT tt-param.cod-estabel).

          CREATE tt-erro-imp.
          ASSIGN tt-erro-imp.cdn-produt-rural = fechto-produt-period.cdn-produt-rural
                 tt-erro-imp.nom-produt-rural = IF AVAIL emitente THEN emitente.nome-abrev ELSE "":U
                 tt-erro-imp.cd-erro          = 55439
                 tt-erro-imp.desc-erro        = TRIM(RETURN-VALUE).
          RETURN "NOK":U.
        END.


        RUN piObsNota (INPUT tt-docum-est-aux.nat-operacao,
                       OUTPUT c-msg-obs).

        RUN piBuscarEnderecoPropriedade IN THIS-PROCEDURE (INPUT fechto-produt-period.cdn-produt-rural,
                                                           INPUT fechto-produt-period.cod-propried,
                                                           OUTPUT c-cod-entrega,
                                                           OUTPUT c-endereco,
                                                           OUTPUT c-bairro,
                                                           OUTPUT c-cep,
                                                           OUTPUT c-cidade,
                                                           OUTPUT c-pais-end,
                                                           OUTPUT c-estado).

        CREATE tt-docum-est.
        ASSIGN tt-docum-est.nro-docto    = tt-docum-est-aux.nro-docto
               tt-docum-est.nat-operacao = tt-docum-est-aux.nat-operacao 
               tt-docum-est.serie-docto  = tt-param.cod-serie
               tt-docum-est.cod-emitente = fechto-produt-period.cdn-produt-rural
               tt-docum-est.cod-estabel  = tt-param.cod-estabel
               tt-docum-est.cod-observa  = 1 /*(ind£stria)*/
               tt-docum-est.dt-trans     = tt-param.dt-emissao 
               tt-docum-est.via-transp   = 1 /* Rodoviario */
               tt-docum-est.usuario      = tt-param.usuario 
               tt-docum-est.dt-emissao   = tt-param.dt-emissao
               tt-docum-est.origem       = "AQR" /* Servir  para nÆo alterar numero da nota na cria‡Æo */
               tt-docum-est.nome-transp  = fechto-produt-period.nome-transp
               tt-docum-est.cod-placa[1] = SUBSTRING(fechto-produt-period.cod-livre-1,1,12)
               tt-docum-est.observacao   = c-msg-obs
               tt-docum-est.valor-outras = tt-docum-est-aux.valor-outras /*Exibir mensagem cadastrada na natureza de opera‡Æo (ver detalhes em t¢pico abaixo)*/
               tt-docum-est.cod-entrega  = c-cod-entrega
               tt-docum-est.endereco     = c-endereco
               tt-docum-est.bairro       = c-bairro
               tt-docum-est.cep          = c-cep
               tt-docum-est.cidade       = c-cidade
               tt-docum-est.pais         = c-pais-end
               tt-docum-est.uf           = c-estado.

        /*Setar a finalidade se nota for complementar */
        IF i-tipo-nf = 1 THEN
           ASSIGN tt-docum-est.cod-finalidade = "3". /*NF-e de Ajuste*/

        /*--- cria tabela que relaciona dados da fechto-produt-period com a docum-est.
              Utilizada na procedure pi-efetiva-documentos ---*/
        IF  NOT CAN-FIND(FIRST tt-fechto-docto
                         WHERE tt-fechto-docto.serie-docto  = tt-docum-est.serie-docto
                           AND tt-fechto-docto.cod-emitente = tt-docum-est.cod-emitente
                           AND tt-fechto-docto.nat-operacao = tt-docum-est.nat-operacao
                           AND tt-fechto-docto.nro-docto    = tt-docum-est.nro-docto
                           AND tt-fechto-docto.cod-propried = fechto-produt-period.cod-propried) THEN DO:

            CREATE tt-fechto-docto.
            ASSIGN tt-fechto-docto.serie-docto  = tt-docum-est.serie-docto
                   tt-fechto-docto.cod-emitente = tt-docum-est.cod-emitente
                   tt-fechto-docto.nat-operacao = tt-docum-est.nat-operacao
                   tt-fechto-docto.nro-docto    = tt-docum-est.nro-docto
                   tt-fechto-docto.cod-propried = fechto-produt-period.cod-propried
                   tt-fechto-docto.qtd-period   = fechto-produt-period.qtd-period
                   tt-fechto-docto.nf-credito   = c-nf-credito
                   tt-fechto-docto.rw-fechto    = ROWID(fechto-produt-period)
                   tt-fechto-docto.cod-evento   = c-cod-evento
                   tt-fechto-docto.it-codigo    = tt-param.it-codigo
                   tt-fechto-docto.cod-period   = tt-param.cod-period.
        END.

        FOR EACH tt-item-doc-est-aux 
           WHERE tt-item-doc-est-aux.nro-docto    = tt-docum-est-aux.nro-docto
             AND tt-item-doc-est-aux.nat-operacao = tt-docum-est-aux.nat-operacao:

            IF AVAIL ITEM THEN
                ASSIGN i-casas = IF item.fraciona THEN 4 ELSE 0.

            CREATE tt-item-doc-est.
            ASSIGN tt-item-doc-est.cod-emitente   = fechto-produt-period.cdn-produt-rural
                   tt-item-doc-est.nat-operacao   = tt-item-doc-est-aux.nat-operacao
                   tt-item-doc-est.nro-docto      = tt-item-doc-est-aux.nro-docto
                   tt-item-doc-est.serie-docto    = tt-param.cod-serie
                   tt-item-doc-est.it-codigo      = tt-param.it-codigo
                   tt-item-doc-est.preco-total[1] = tt-item-doc-est-aux.preco-total[1]
                   tt-item-doc-est.quantidade     = trunc(tt-item-doc-est-aux.quantidade, i-casas)
                   tt-item-doc-est.quant-conf     = trunc(tt-item-doc-est-aux.quant-conf, i-casas)
                   tt-item-doc-est.sequencia      = tt-item-doc-est-aux.sequencia
                   tt-item-doc-est.nat-of         = tt-item-doc-est-aux.nat-of
                   tt-item-doc-est.lote           = IF AVAIL ITEM AND ITEM.tipo-con-est = 3 THEN tt-param.cod-estabel ELSE "" /*Se item controlado por lote*/
                   tt-item-doc-est.dt-vali-lote   = IF AVAIL ITEM AND ITEM.tipo-con-est = 3 THEN 12/31/2999 ELSE ?
                   tt-item-doc-est.cd-trib-icm    = 0 
                   tt-item-doc-est.cd-trib-ipi    = 0
                   tt-item-doc-est.despesas[1]    = tt-item-doc-est-aux.despesas[1].

            IF i-tipo-nf = 1 THEN
                ASSIGN tt-item-doc-est.preco-unit[1]  = dec(c-val_preco-unit).
            ELSE /*nÆo grava a conta-contabil quando ‚ NF Complementar para nÆo gerar movimento de REQ no estoque*/
                ASSIGN tt-item-doc-est.ct-codigo      = cConta
                       tt-item-doc-est.sc-codigo      = cCusto.
            
            /*trata itens do tipo referencia*/
            IF AVAIL ITEM AND item.tipo-con-est = 4 THEN DO:

                ASSIGN tt-item-doc-est.lote         = tt-param.cod-estabel
                       tt-item-doc-est.dt-vali-lote = 12/31/2999.
                
                /*busca referencia da saldo estoq caso nÆo encontre busca a primeira referencia do item na ref-item */
                FOR FIRST saldo-estoq FIELDS (cod-refer)
                    WHERE saldo-estoq.it-codigo   = tt-item-doc-est.it-codigo 
                      AND saldo-estoq.cod-estabel = tt-param.cod-estabel 
                      AND saldo-estoq.lote        = tt-item-doc-est.lote NO-LOCK:
                END.
                
                IF AVAIL saldo-estoq THEN DO:
                    ASSIGN tt-item-doc-est.cod-refer = saldo-estoq.cod-refer.
                END.
                ELSE DO:

                    FOR FIRST ref-item FIELDS(cod-refer)
                        WHERE ref-item.it-codigo = tt-item-doc-est.it-codigo NO-LOCK: 
                        ASSIGN tt-item-doc-est.cod-refer = ref-item.cod-refer.
                    END.

                END.

            END.
            
        END. /*tt-item-doc-est-aux*/

    END. /*tt-docum-est-aux*/

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-buscaNroDocto:

    DEF OUTPUT PARAM p-nr-docto LIKE tt-docum-est.nro-docto NO-UNDO.
    
    DEF VAR l-ok AS LOG INITIAL NO NO-UNDO.
    DEF BUFFER bf-tt-docum-est FOR tt-docum-est.
    DEF BUFFER bf-tt-docum-est-aux FOR tt-docum-est-aux.

    DO WHILE NOT l-ok:

        IF p-nr-docto = "" THEN DO:
            FOR LAST docum-est FIELDS(nro-docto)
               where docum-est.serie-docto  = tt-param.cod-serie
                 AND docum-est.cod-emitente = fechto-produt-period.cdn-produt-rural
                 AND docum-est.nat-operacao = c-nat-operacao NO-LOCK:
            END.
            ASSIGN p-nr-docto = IF AVAIL docum-est THEN string(int(docum-est.nro-docto) + 1) ELSE "1"
                   p-nr-docto = left-trim(string(DEC(p-nr-docto), c-formato)).
        END.
    
        FOR FIRST bf-tt-docum-est 
           where bf-tt-docum-est.serie-docto  = tt-param.cod-serie
             AND bf-tt-docum-est.nro-docto    = p-nr-docto
             AND bf-tt-docum-est.cod-emitente = fechto-produt-period.cdn-produt-rural
             AND bf-tt-docum-est.nat-operacao = c-nat-operacao NO-LOCK:
        END.

        FOR FIRST docum-est FIELDS()
            where docum-est.serie-docto  = tt-param.cod-serie
              AND docum-est.nro-docto    = p-nr-docto
              AND docum-est.cod-emitente = fechto-produt-period.cdn-produt-rural
              AND docum-est.nat-operacao = c-nat-operacao NO-LOCK:
        END.

        ASSIGN p-nr-docto = IF  NOT AVAIL docum-est 
                            AND NOT AVAIL bf-tt-docum-est 
                            AND NOT AVAIL bf-tt-docum-est-aux THEN 
                                p-nr-docto 
                            ELSE 
                                STRING(INT(p-nr-docto) + 1)
               p-nr-docto = LEFT-TRIM(STRING(DEC(p-nr-docto), c-formato)).
        
        IF NOT AVAIL docum-est
       AND NOT AVAIL bf-tt-docum-est 
       AND NOT AVAIL bf-tt-docum-est-aux THEN
            ASSIGN l-ok = YES.
        ELSE
            ASSIGN l-ok = NO
                   p-nr-docto = string(int(p-nr-docto) + 1)
                   p-nr-docto = left-trim(string(DEC(p-nr-docto), c-formato)).
        
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piObsNota:

    DEF INPUT  PARAMETER p-nat-oper LIKE natur-oper.nat-operacao NO-UNDO.
    DEF OUTPUT PARAMETER p-msg AS CHAR                           NO-UNDO.

    DEF VAR c-vl-substituir AS CHAR NO-UNDO.
    DEF VAR c-tag           AS CHAR NO-UNDO.

    FOR FIRST natur-oper FIELDS(cod-mensagem)
        WHERE natur-oper.nat-operacao = p-nat-oper NO-LOCK:
        
        FOR FIRST mensagem FIELDS(texto-mensag)
            WHERE mensagem.cod-mensagem = natur-oper.cod-mensagem no-lock:
            
            ASSIGN p-msg = mensagem.texto-mensag.

        END.

        /* Formata as observa‡äes adicionais */
        DO  WHILE INDEX(p-msg, "##") > 0:

            ASSIGN c-vl-substituir = ""
                   c-tag           = substr(p-msg, index(p-msg, "##"), 4).

            case substr(p-msg, index(p-msg, "##"), 4):
                
                when "##19" THEN
                    ASSIGN c-vl-substituir = string(TODAY, "99/99/9999")
                           p-msg           = REPLACE(p-msg,"##19",c-vl-substituir). 
                when "##38" THEN
                    ASSIGN c-vl-substituir = string(de-perc-icentivo, ">>9.99":U)
                           p-msg           = REPLACE(p-msg,"##38",c-vl-substituir). 
                when "##39" THEN
                    ASSIGN c-vl-substituir = string(dec(c-val-despesa), ">>>>>,>>>,>>9.99") 
                           p-msg           = REPLACE(p-msg,"##39",c-vl-substituir).
                 
            END.

            IF c-tag <> "##19" AND c-tag <> "##39" AND c-tag <> "##38" THEN
                ASSIGN p-msg = REPLACE(p-msg,c-tag,"").
            
        END.

    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-efetiva-documentos:

    {utp/ut-liter.i Efetivando_notas... *}
    RUN pi-acompanhar in h-acomp (INPUT RETURN-VALUE).


    RUN rep/reapi316a.p (INPUT  TABLE tt-docum-est,
                         INPUT  TABLE tt-rat-docum,
                         INPUT  TABLE tt-item-doc-est,
                         INPUT  TABLE tt-dupli-apagar,
                         INPUT  TABLE tt-dupli-imp,
                         OUTPUT TABLE tt-erro).

    /*--- transfere os erros que ocorreram na efetivacao para a temp-table que mostra os erros ---*/
    FOR EACH tt-erro,
        FIRST tt-docum-est
        WHERE tt-docum-est.serie-docto  = ENTRY(1,tt-erro.identif-segment,CHR(24))
          AND tt-docum-est.nro-docto    = ENTRY(2,tt-erro.identif-segment,CHR(24))
          AND tt-docum-est.cod-emitente = INT(ENTRY(3,tt-erro.identif-segment,CHR(24)))
          AND tt-docum-est.nat-operacao = ENTRY(4,tt-erro.identif-segment,CHR(24)):

        FOR FIRST emitente FIELDS(nome-abrev)
            WHERE emitente.cod-emitente = tt-docum-est.cod-emitente NO-LOCK: END.

        CREATE tt-erro-imp.
        ASSIGN tt-erro-imp.cdn-produt-rural = tt-docum-est.cod-emitente
               tt-erro-imp.nom-produt-rural = IF  AVAIL emitente THEN emitente.nome-abrev ELSE ""
               tt-erro-imp.cd-erro          = tt-erro.cd-erro
               tt-erro-imp.desc-erro        = tt-erro.desc-erro.
    END.


    RETURN "OK":U.

END PROCEDURE.

PROCEDURE calculaQuantidadeDescontada:

    /******************************************************************************* 
    OBJETIVO: Retorna a quantidade acumulada no periodo da gera‡Æo da nota de origem
    ********************************************************************************/

    DEFINE INPUT  PARAMETER pCodPeriodo  LIKE nf-produt-propried.cod-period       NO-UNDO.
    DEFINE INPUT  PARAMETER pCodProdutor LIKE nf-produt-propried.cdn-produt-rural NO-UNDO.
    DEFINE INPUT  PARAMETER pCodPropried LIKE nf-produt-propried.cod-propried     NO-UNDO.
    DEFINE INPUT  PARAMETER pCodEstabel  LIKE nf-produt-propried.cod-estabel      NO-UNDO.
    DEFINE INPUT  PARAMETER pCodItem     LIKE nf-produt-propried.it-codigo        NO-UNDO.
    DEFINE INPUT  PARAMETER pCodPeriod   LIKE fechto-produt-period.cod-period     NO-UNDO.
    DEFINE INPUT  PARAMETER pDtEmissao   LIKE quant-fornec-produt.dat-inic        NO-UNDO.
    DEFINE OUTPUT PARAMETER pQtdFornec   LIKE quant-fornec-produt.qtd-fornec      NO-UNDO.
    DEFINE OUTPUT PARAMETER pQtdFechto   LIKE fechto-produt-period.qtd-period     NO-UNDO.
    
    DEF VAR c-period-fech LIKE fechto-produt-period.cod-period NO-UNDO.

    /*Verifica o ultimo periodo fechado*/
    FOR FIRST param-aquis-rural FIELDS(cod-estabel cod-periodo) NO-LOCK
        WHERE param-aquis-rural.cod-estabel = pCodEstabel:
        ASSIGN c-period-fech = param-aquis-rural.cod-periodo.
    END.  
    
    /*Busca a nota fiscal de origem*/
    FOR FIRST nf-produt-propried FIELDS(cdn-produt-rural it-codigo cod-estabel) NO-LOCK
        WHERE nf-produt-propried.cod-period       = pCodPeriodo
          AND nf-produt-propried.cdn-produt-rural = pCodProdutor
          AND nf-produt-propried.cod-propried     = pCodPropried
          AND nf-produt-propried.it-codigo        = pCodItem
          AND nf-produt-propried.cod-estabel      = pCodEstabel:

        /*Busca o volume acumulado atual entregue pelo produtor no ano para o item da nota*/
        FOR FIRST quant-fornec-produt FIELDS(qtd-fornec) NO-LOCK
            WHERE quant-fornec-produt.cdn-produt-rural = nf-produt-propried.cdn-produt-rural
              AND quant-fornec-produt.it-codigo        = nf-produt-propried.it-codigo 
              AND quant-fornec-produt.dat-inic         <= pDtEmissao
              AND quant-fornec-produt.dat-fim          >= pDtEmissao:
            
            ASSIGN pQtdFornec = quant-fornec-produt.qtd-fornec.

        END.

        /*Desconta do volume acumulado os volumes entregues at‚ o per¡odo para o qual se deseja emitir nota complementar.*/
        FOR EACH bf-fechto-produt-period FIELDS(qtd-period cod-period) NO-LOCK
           WHERE bf-fechto-produt-period.cdn-produt-rural = nf-produt-propried.cdn-produt-rural
             AND bf-fechto-produt-period.it-codigo        = nf-produt-propried.it-codigo
             AND bf-fechto-produt-period.cod-estabel      = nf-produt-propried.cod-estabel
             AND bf-fechto-produt-period.cod-period      <= c-period-fech
             AND bf-fechto-produt-period.cod-period      >= pCodPeriod:
             
             ASSIGN pQtdFornec = pQtdFornec - bf-fechto-produt-period.qtd-period.

             IF bf-fechto-produt-period.cod-period = pCodPeriod THEN
                ASSIGN pQtdFechto = bf-fechto-produt-period.qtd-period.

        END.

    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE piBuscarEnderecoPropriedade:
/*buscar endereco da propriedade que entregou o produto rural para completar info de endereco na docum-est*/
    DEFINE INPUT PARAMETER  p-cdn-produt-rural LIKE fechto-produt-period.cdn-produt-rural NO-UNDO.
    DEFINE INPUT PARAMETER  p-cod-propried     LIKE fechto-produt-period.cod-propried     NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-entrega      LIKE docum-est.cod-entrega                 NO-UNDO.
    DEFINE OUTPUT PARAMETER p-endereco         LIKE docum-est.endereco                    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-bairro           LIKE docum-est.bairro                      NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cep              LIKE docum-est.cep                         NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cidade           LIKE docum-est.cidade                      NO-UNDO.
    DEFINE OUTPUT PARAMETER p-pais             LIKE docum-est.pais                        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-estado           LIKE docum-est.uf                          NO-UNDO.

    FOR FIRST emitente FIELDS(nome-abrev) NO-LOCK
        WHERE emitente.cod-emitente = p-cdn-produt-rural: END.

    IF NOT AVAILABLE emitente THEN
        RETURN "NOK":U.

    FOR FIRST propried-rural FIELDS(cod-entrega) NO-LOCK
        WHERE propried-rural.cod-propried = p-cod-propried:

        FOR FIRST loc-entr FIELDS(cod-entrega endereco bairro cep cidade pais estado) NO-LOCK
            WHERE loc-entr.nome-abrev  = emitente.nome-abrev
              AND loc-entr.cod-entrega = propried-rural.cod-entrega:

            ASSIGN p-cod-entrega = loc-entr.cod-entrega
                   p-endereco    = loc-entr.endereco
                   p-bairro      = loc-entr.bairro
                   p-cep         = loc-entr.cep
                   p-cidade      = loc-entr.cidade
                   p-pais        = loc-entr.pais
                   p-estado      = loc-entr.estado.

        END.

    END.

    RETURN "OK":U.

END PROCEDURE.

