/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0401RP 2.00.00.022 } /*** "010022" 10/09/2026 16:19:29 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0401rp MIM}
&ENDIF

{include/i_fnctrad.i}
/********************************************************************************
**
**  IM0401RP.P - Relat¢rio Entradas de Importa‡Æo
**
**  Objetivo: Listagem Notas Fiscais de Importa‡Æo Atualizadas ou nÆo no Estoque (Embarque)
**
*********************************************************************************/

{utp/ut-glob.i}
{cdp/cdcfgmat.i}
{cdp/cd4300.i3}    
{cxbo/bocx225e.i1} 
{rep/re1001.i09} /* V riaveis referentes ao novo tratamento dos itens do M¢dulo de Recebimento */
{imp/im0401.i} /* Definicao de temp-tables e vari veis */

ASSIGN l-spp-NT2024002 = CAN-FIND(FIRST funcao NO-LOCK
                                  WHERE funcao.cd-funcao = "spp-NT2024002"
                                  AND   funcao.ativo).
                                  
{imp/im0401.i2} /*Definicao de Frames*/
{cdp/cd4400.i}

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

DEFINE BUFFER bf2-historico-embarque FOR historico-embarque.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN imp/im9014.p   PERSISTENT SET h-im9014.
RUN imp/im9014a.p  PERSISTENT SET h-im9014a.
RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.

/* Handle da API Conta Cont bil */
run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
/* Handle da API Centro Custo */
run prgint/utb/utb742za.py persistent set h_api_ccusto.

{include/i-rpvar.i}
{include/i-rpcab.i}

{utp/ut-liter.i "LISTAGEM_DE_ENTRADAS_DE_IMPORTACAO" *}

ASSIGN c-programa     = "im00401"
       c-versao       = "2.00"
       c-revisao      = "000"
       c-titulo-relat = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Com‚rcio_Exterior" *}
ASSIGN c-sistema = TRIM(RETURN-VALUE).

find first tt-param     no-lock no-error.
find first param-global no-lock no-error.

find first empresa
     where empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
if  avail empresa then
    assign c-empresa = empresa.razao-social.
else do:
    run utp/ut-msgs.p (input "show", input 16, input "").
    return error.
end.

ASSIGN l-primeiro = YES.

{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN pi-inicializar IN h-acomp (INPUT "Preparando Dados...").

FOR EACH docum-est NO-LOCK
   WHERE docum-est.serie-docto  >= tt-param.c-serie-ini
     AND docum-est.serie-docto  <= tt-param.c-serie-fim
     AND docum-est.nro-docto    >= tt-param.c-docto-ini
     AND docum-est.nro-docto    <= tt-param.c-docto-fim
     AND docum-est.cod-emitente >= tt-param.i-emitente-ini
     AND docum-est.cod-emitente <= tt-param.i-emitente-fim
     AND docum-est.nat-operacao >= tt-param.c-nat-operacao-ini
     AND docum-est.nat-operacao <= tt-param.c-nat-operacao-fim:

    IF docum-est.cod-estabel < tt-param.c-cod-estabel-ini 
    OR docum-est.cod-estabel > tt-param.c-cod-estabel-fim THEN NEXT.

    IF docum-est.dt-emissao < tt-param.dt-emis-ini
    OR docum-est.dt-emissao > tt-param.dt-emis-fim THEN NEXT.

    IF docum-est.declaracao-import < tt-param.c-di-siscomex-ini
    OR docum-est.declaracao-import > tt-param.c-di-siscomex-fim THEN NEXT.
      
    {rep/re1001a.i50}
    {cdp/cd4300.i4 "yes" docum-est.char-1}
    {rep/re1001a.i51 "yes"}

    IF c-embarque = "" THEN NEXT.

    IF c-embarque < tt-param.c-embarque-ini 
    OR c-embarque > tt-param.c-embarque-fim THEN NEXT.

    FOR FIRST natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = docum-est.nat-operacao:
    END.
    IF NOT AVAIL natur-oper THEN NEXT.

    FOR FIRST emitente NO-LOCK 
        WHERE emitente.cod-emitente = docum-est.cod-emitente:
    END.
    IF NOT AVAIL emitente THEN NEXT.
    /*IF emitente.natureza <> 3 AND emitente.natureza <> 4 THEN NEXT.*/ /*notas de rateio??*/

    IF  tt-param.l-somente-ce-atual
    AND NOT docum-est.ce-atual THEN NEXT.
    /*verificar ponto de nacionaliza‡Æo*/

    FOR FIRST embarque-imp
        WHERE embarque-imp.cod-estabel = docum-est.cod-estabel
          AND embarque-imp.embarque    = c-embarque NO-LOCK:
    END.
    IF NOT AVAIL embarque-imp THEN NEXT.

    {utp/ut-liter.i "Embarque" *}
    run pi-acompanhar in h-acomp (input RETURN-VALUE + ": " + string(embarque-imp.embarque)).

    FOR FIRST historico-embarque
        WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
          AND historico-embarque.embarque    = embarque-imp.embarque NO-LOCK:
    END.
    IF NOT AVAIL historico-embarque THEN NEXT.

    FOR FIRST itinerario 
        WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK:
    END.
    IF NOT AVAIL itinerario THEN NEXT.

    FOR FIRST b-historico-embarque 
        WHERE b-historico-embarque.cod-estabel    = embarque-imp.cod-estabel
          AND b-historico-embarque.embarque       = embarque-imp.embarque
          AND b-historico-embarque.cod-itiner     = itinerario.cod-itiner
          AND b-historico-embarque.cod-pto-contr  = embarque-imp.cdn-pto-desembar
          AND b-historico-embarque.dt-previsao   >= tt-param.dt-nacionalizacao-ini
          AND b-historico-embarque.dt-previsao   <= tt-param.dt-nacionalizacao-fim NO-LOCK:
    END.
    IF NOT AVAIL b-historico-embarque THEN NEXT.

     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
           DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
           ASSIGN cAuxTraducao004 = {cxinc/i01cx220.i 04 embarque-imp.situacao}.
           run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao004)," ","_"),
                               INPUT "",
                               INPUT "").
           ASSIGN c-situacao-embarque   = RETURN-VALUE.
       &else
           ASSIGN c-situacao-embarque   = {cxinc/i01cx220.i 04 embarque-imp.situacao}.
       &endif
       
    /*ponto embarque*/
    FOR FIRST bf2-historico-embarque FIELDS(descricao)
        WHERE bf2-historico-embarque.cod-estabel    = embarque-imp.cod-estabel
          AND bf2-historico-embarque.embarque       = embarque-imp.embarque
          AND bf2-historico-embarque.cod-itiner     = itinerario.cod-itiner
          AND bf2-historico-embarque.cod-pto-contr  = embarque-imp.cdn-pto-embarq:
        assign c-pto-emb = bf2-historico-embarque.descricao.
    END.

    IF c-pto-emb = "":U THEN DO:
        FOR FIRST pto-contr FIELDS (descricao) 
            WHERE pto-contr.cod-pto-contr = embarque-imp.cdn-pto-embarq NO-LOCK:
            assign c-pto-emb = pto-contr.descricao.
        END.
    END.

    /*ponto desembarque*/
    FOR FIRST bf2-historico-embarque FIELDS(descricao)
        WHERE bf2-historico-embarque.cod-estabel    = embarque-imp.cod-estabel
          AND bf2-historico-embarque.embarque       = embarque-imp.embarque
          AND bf2-historico-embarque.cod-itiner     = itinerario.cod-itiner
          AND bf2-historico-embarque.cod-pto-contr  = embarque-imp.cdn-pto-desembar:
        assign c-pto-emb = bf2-historico-embarque.descricao.
    END.

    IF c-pto-emb = "":U THEN DO:
        FOR FIRST pto-contr FIELDS (descricao)
            WHERE pto-contr.cod-pto-contr = embarque-imp.cdn-pto-desembar NO-LOCK:
            assign c-pto-des = pto-contr.descricao.
        END.
    END.

    /*ponto LI*/
    FIND FIRST b-historico-embarque 
         WHERE b-historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
           AND b-historico-embarque.embarque      = embarque-imp.embarque 
           AND b-historico-embarque.cod-itiner    = itinerario.cod-itiner
           AND b-historico-embarque.cod-pto-contr = itinerario.cdn-pto-solic-licenciam-import NO-LOCK NO-ERROR.
    IF AVAIL b-historico-embarque THEN DO:
        ASSIGN i-pto-solic-li = b-historico-embarque.cod-pto-contr.

        IF b-historico-embarque.descricao <> "":U THEN DO:
            ASSIGN c-pto-solic-li = b-historico-embarque.descricao.
        END.
        ELSE DO:
            FOR FIRST pto-contr FIELDS (descricao) 
                WHERE pto-contr.cod-pto-contr = i-pto-solic-li NO-LOCK:
                ASSIGN c-pto-solic-li = pto-contr.descricao.
            END.
        END.
    END.
    ELSE 
        assign i-pto-solic-li = 0.

    FOR FIRST ordens-embarque
        WHERE ordens-embarque.cod-estabel  = embarque-imp.cod-estabel
          AND ordens-embarque.embarque     = embarque-imp.embarque NO-LOCK:
        FOR FIRST ordem-compra NO-LOCK
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem:
        END.
        IF NOT AVAIL ordem-compra THEN
            ASSIGN i-cod-exportador = 0
                   c-nome-abrev     = emitente.nome-abrev.
        ELSE DO:
            ASSIGN i-cod-exportador = ordem-compra.cod-emitente.
            FOR first emitente no-lock
                where emitente.cod-emitente = ordem-compra.cod-emitente:
                ASSIGN c-nome-abrev = emitente.nome-abrev.
            END.
            IF AVAIL emitente THEN
                ASSIGN c-nome-abrev = emitente.nome-abrev.
            ELSE
                ASSIGN c-nome-abrev = "".
        END.
    END.
    IF NOT AVAIL ordens-embarque THEN
        ASSIGN i-cod-exportador = 0
               c-nome-abrev     = emitente.nome-abrev.
    
    FOR FIRST cotacao-item 
        WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
          AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
          AND cotacao-item.data-cotacao = ordem-compra.data-cotacao
          AND cotacao-item.cot-aprovada = YES NO-LOCK: 
        ASSIGN i-mo-codigo = cotacao-item.mo-codigo.
    END.
    FIND FIRST cotacao 
         WHERE cotacao.mo-codigo   = i-mo-codigo 
           AND cotacao.ano-periodo = STRING(YEAR(embarque-imp.data-1)) + STRING(MONTH(embarque-imp.data-1),"99") 
           AND cotacao.cotacao[INT(DAY(embarque-imp.data-1))] <> 0 NO-LOCK NO-ERROR.
    
    ASSIGN de-cotacao-dia = IF AVAIL cotacao then cotacao.cotacao[int(day(embarque-imp.data-1))] 
                            ELSE 1.

    /*encerra faixa de sele‡Æo e inicia impressao dos dados*/
    ASSIGN c-embarque-orig = trim(substring(embarque-imp.char-1,61,20))
           c-embarque-imp  = embarque-imp.embarque.

    if not l-primeiro then page.
    assign l-primeiro = no.

    disp embarque-imp.cod-estabel
         embarque-imp.embarque
         i-cod-exportador 
         c-nome-abrev
         embarque-imp.cod-incoterm
         i-pto-solic-li
         c-pto-solic-li
         c-situacao-embarque
         embarque-imp.cdn-pto-embarq
         c-pto-emb
         historico-embarque.cod-itiner
         itinerario.descricao
         embarque-imp.cdn-pto-desembar
         c-pto-des
         embarque-imp.declaracao-import
         embarque-imp.cod-conhecto-master
         with frame f-cab-embarque.

    disp embarque-imp.data-di    
         embarque-imp.cod-conhecto-house
         embarque-imp.data-1
         de-cotacao-dia
         with frame f-cab-embarque-aux.

    IF tt-param.l-itinerario THEN DO:
        RUN pi-imprime-det-itiner.
    END.

    PUT SKIP(1).
    DISP c-lb-tit-docs WITH frame f-tit-docs.
    PUT SKIP(1).

    /*------------------------ Impressao dos dados do cabe‡alho da nota fiscal -----------------------*/
    
    IF docum-est.idi-nf-simples-remes = 1  THEN DO:
        {utp/ut-liter.i "Nota_MÆe" *}
    END.
    ELSE
        IF docum-est.idi-nf-simples-remes = 2  THEN DO:
            {utp/ut-liter.i "Nota_Filha" *}
        END.
        ELSE DO:
            {utp/ut-liter.i "NÆo" *}
        END.
    ASSIGN c-nota-simples-remessa = TRIM(RETURN-VALUE).

    /*************** Documentos ***************/
    
    /* Brasil */
    IF i-pais-impto-usuario = 1 THEN DO:

        /*Gera Primeira Remessa com NF MÆe*/
        IF TRIM(SUBSTRING(docum-est.char-1,209,1)) = "S":U THEN DO:
            {utp/ut-liter.i Sim * r}
            ASSIGN c-gera-nf-mae-filha = TRIM(RETURN-VALUE).
        END.
        ELSE DO:
            {utp/ut-liter.i NÆo * r}
            ASSIGN c-gera-nf-mae-filha = TRIM(RETURN-VALUE).
        END.

        DISP docum-est.cod-emitente
             docum-est.serie-docto
             c-embarque-imp
             emitente.nome-abrev    WHEN AVAIL emitente
             docum-est.nro-docto
             docum-est.nat-operacao
             emitente.cgc           
             c-nota-simples-remessa
             c-gera-nf-mae-filha
             natur-oper.especie-doc WHEN AVAIL natur-oper
             c-embarque-orig
             WITH FRAME f-nota-bra.
    END.
    ELSE DO: /*Internacional*/
        DISP docum-est.cod-emitente
             docum-est.serie-docto
             c-embarque-imp
             emitente.nome-abrev    WHEN AVAIL emitente
             docum-est.nro-docto
             docum-est.nat-operacao
             emitente.cgc           
             c-nota-simples-remessa
             natur-oper.especie-doc WHEN AVAIL natur-oper
             c-embarque-orig
             WITH FRAME f-nota.
    END.


    /*prepara‡Æo dados f-corpo-rel*/
    {imp/im0401.i3 "docum-est"}

    if l-spp-NT2024002 then do:
        disp c-esp-docto
             c-especie[lookup(string(docum-est.esp-docto),"20,21,22,23")]
                       when can-do("20,21,22,23", string(docum-est.esp-docto)) @ c-especie[1]
             docum-est.cod-observa    c-observa
             docum-est.cod-estabel    da-ven-icm
             docum-est.estab-fisc     da-ven-ipi
             docum-est.base-iss       da-ven-iss
             docum-est.dt-emissao     c-transp
             docum-est.iss-deb-cre    l-compras
             docum-est.dt-trans       l-of-online when l-of-online <> ?
             docum-est.base-ipi       l-ap-online when l-ap-online <> ?
             l-cr-online when l-cr-online <> ?
             docum-est.ipi-deb-cre
             l-docto-imp
             l-memorando-exportacao
             docum-est.usuario
             docum-est.via-transp
             docum-est.icm-fonte
             docum-est.ce-atual
             c-ct-transit
             c-sc-transit
             docum-est.base-subs
             docum-est.despesa-nota
             docum-est.vl-subs
             docum-est.of-atual
             docum-est.tot-peso
             docum-est.base-icm
             docum-est.ap-atual
             docum-est.tot-desconto
             docum-est.icm-deb-cre
             docum-est.peso-bruto-tot
             de-base-pis
             docum-est.cr-atual
             docum-est.valor-mercad
             de-pis 
             docum-est.tot-valor
             de-base-cofins 
             de-cofins   
             docum-est.vl-pis-subs
             docum-est.vl-cofins-subs
             docum-est.log-sumar
             docum-est.log-ctbl-atual
       /*====================== Impostos Reforma Tribut ria ============================*/             
             de-base-cbs
             de-base-ibs-uf
             de-base-ibs-mun
             de-valor-cbs
             de-valor-ibs-uf
             de-valor-ibs-mun
             de-base-cbs-reg
             de-base-ibs-uf-reg
             de-base-ibs-mun-reg
             de-valor-cbs-reg
             de-valor-ibs-uf-reg
             de-valor-ibs-mun-reg             
             de-base-is
             de-valor-is          
             docum-est.valor-tot-nf-rt   
       /*===============================================================================*/             
             with frame f-corpo-rel-RT.
    END.
    ELSE DO:            
        disp c-esp-docto
             c-especie[lookup(string(docum-est.esp-docto),"20,21,22,23")]
                       when can-do("20,21,22,23", string(docum-est.esp-docto)) @ c-especie[1]
             docum-est.cod-observa    c-observa
             docum-est.cod-estabel    da-ven-icm
             docum-est.estab-fisc     da-ven-ipi
             docum-est.base-iss       da-ven-iss
             docum-est.dt-emissao     c-transp
             docum-est.iss-deb-cre    l-compras
             docum-est.dt-trans       l-of-online when l-of-online <> ?
             docum-est.base-ipi       l-ap-online when l-ap-online <> ?
             l-cr-online when l-cr-online <> ?
             docum-est.ipi-deb-cre
             l-docto-imp
             l-memorando-exportacao
             docum-est.usuario
             docum-est.via-transp
             docum-est.icm-fonte
             docum-est.ce-atual
             c-ct-transit
             c-sc-transit
             docum-est.base-subs
             docum-est.despesa-nota
             docum-est.vl-subs
             docum-est.of-atual
             docum-est.tot-peso
             docum-est.base-icm
             docum-est.ap-atual
             docum-est.tot-desconto
             docum-est.icm-deb-cre
             docum-est.peso-bruto-tot
             de-base-pis
             docum-est.cr-atual
             docum-est.valor-mercad
             de-pis 
             docum-est.tot-valor
             de-base-cofins 
             de-cofins   
             docum-est.vl-pis-subs
             docum-est.vl-cofins-subs           
             with frame f-corpo-rel.
    END.

    DISP c-lb-tit-end WITH FRAME f-tit-end.

    DISP docum-est.cod-entrega
         docum-est.endereco
         docum-est.bairro
         docum-est.cep
         docum-est.cidade FORMAT 'x(30)'
         docum-est.uf
         docum-est.pais
         docum-est.log-consid-ender-nf-saida
         WITH FRAME f-endereco.

        
    /*Detalhamento das despesas*/
    IF tt-param.l-despesa THEN DO:
        CREATE tt-doc.
        ASSIGN tt-doc.serie-docto  = docum-est.serie-docto
               tt-doc.nro-docto    = docum-est.nro-docto
               tt-doc.cod-emitente = docum-est.cod-emitente
               tt-doc.nat-operacao = docum-est.nat-operacao
               tt-doc.tipo         = 1.
        RUN docum_desp_imp_detalhe IN h-im9014 (INPUT TABLE tt-doc).
        DELETE tt-doc.
    END.

    /*Detalhamento dos itens*/
    IF tt-param.l-item THEN DO:
        RUN pi-detalha-item (INPUT docum-est.serie-docto,
                             INPUT docum-est.nro-docto,
                             INPUT docum-est.cod-emitente,
                             INPUT docum-est.nat-operacao,
                             INPUT docum-est.cod-estabel).
    END.
    
    /*Detalhamento das duplicatas*/
    if  tt-param.l-duplicatas then do: 
        for each item-doc-est
           WHERE item-doc-est.serie-docto  = docum-est.serie-docto
             AND item-doc-est.nro-docto    = docum-est.nro-docto
             AND item-doc-est.cod-emitente = docum-est.cod-emitente
             AND item-doc-est.nat-operacao = docum-est.nat-operacao NO-LOCK:  
    
            if  item-doc-est.num-pedido <> 0 then do:                 
                find first tt-pedidos
                    where tt-pedidos.num-pedido = item-doc-est.num-pedido
                    no-error.
                if  not avail tt-pedidos then do:
                    create tt-pedidos.
                    assign tt-pedidos.num-pedido = item-doc-est.num-pedido.
                end.
                assign tt-pedidos.quantidade = tt-pedidos.quantidade + 1.
            end.
        end.

        {imp/im0401.i4 "docum-est"} /*tratamento de valores docum-est*/

        RUN pi-detalha-duplicata (INPUT docum-est.serie-docto,
                                  INPUT docum-est.nro-docto,
                                  INPUT docum-est.cod-emitente,
                                  INPUT docum-est.nat-operacao,
                                  INPUT docum-est.cod-estabel,
                                  INPUT docum-est.pais).

    END.
            
    /*Detalha Nota Fiscal Complementar*/
    IF tt-param.l-detalha-nfc THEN DO: 
        RUN pi-detalha-nfc.
    END.


END.

/* imprime parƒmetros*/
IF  tt-param.l-imprime-param THEN DO:
    PAGE.

    PUT c-lb-sel            skip(1)
        c-lb-estabel        AT 21 ": " tt-param.c-cod-estabel-ini         "|< >| " AT 75 tt-param.c-cod-estabel-fim
        c-lb-embarque       AT 28 ": " tt-param.c-embarque-ini            "|< >| " AT 75 tt-param.c-embarque-fim
        c-lb-di-siscomex    AT 25 ": " tt-param.c-di-siscomex-ini         "|< >| " AT 75 tt-param.c-di-siscomex-fim
        c-lb-dt-nacionaliza AT 14 ": " tt-param.dt-nacionalizacao-ini     "|< >| " AT 75 tt-param.dt-nacionalizacao-fim
        c-lb-emite          AT 28 ": " tt-param.i-emitente-ini            "|< >| " AT 75 tt-param.i-emitente-fim
        c-lb-serie          AT 31 ": " tt-param.c-serie-ini               "|< >| " AT 75 tt-param.c-serie-fim
        c-lb-docto          AT 27 ": " tt-param.c-docto-ini               "|< >| " AT 75 tt-param.c-docto-fim
        c-lb-natur          AT 24 ": " tt-param.c-nat-operacao-ini        "|< >| " AT 75 tt-param.c-nat-operacao-fim
        c-lb-dt-emissao     AT 21 ": " tt-param.dt-emis-ini               "|< >| " AT 75 tt-param.dt-emis-fim skip(1).

    PUT c-lb-par    SKIP(2).

    PUT c-lb-imprime    AT 29 ":" SKIP
        c-lb-despesa    AT 50 ": " tt-param.l-despesa             
        c-lb-duplicata  AT 48 ": " tt-param.l-duplicatas          
        c-lb-itiner     AT 36 ": " tt-param.l-itinerario          
        c-lb-item       AT 45 ": " tt-param.l-item                
        c-lb-desp-item  AT 40 ": " tt-param.l-despesas-item       
        c-lb-nfe-ce     AT 04 ": " tt-param.l-somente-ce-atual    
        c-lb-nfc        AT 35 ": " tt-param.l-detalha-nfc         
        c-lb-nfc-ce     AT 03 ": " tt-param.l-somente-nfc-ce-atual.
		
    PUT SKIP (2)
        c-lb-imp    skip(1)
        c-lb-dest   at 28 ": " tt-param.destino " - " tt-param.arquivo
        c-lb-usu    at 28 ": " tt-param.usuario.
END.

DELETE OBJECT h_api_cta_ctbl.
DELETE OBJECT h_api_ccusto.

IF  VALID-HANDLE(h-im9014) THEN DO:
    DELETE PROCEDURE h-im9014.
    ASSIGN h-im9014 = ?.
END.

IF  VALID-HANDLE(h-im9014a) THEN DO:
    DELETE PROCEDURE h-im9014a.
    ASSIGN h-im9014a = ?.
END.

IF  VALID-HANDLE(h-cdapi995) THEN DO:
    DELETE PROCEDURE h-cdapi995.
    ASSIGN h-cdapi995 = ?.
END.

run pi-finalizar in h-acomp.


{include/i-rpclo.i}

PROCEDURE pi-atualiza-item-doc-est:

    assign c-situacao   = "".

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        ASSIGN cAuxTraducao023 = {ininc/i07in122.i 04 item-doc-est.cd-trib-icm}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao023)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN c-trib-icm   = RETURN-VALUE.
    
        ASSIGN cAuxTraducao024 = {ininc/i10in172.i 04 item-doc-est.cd-trib-ipi}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao024)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN c-trib-ipi   = RETURN-VALUE.

        ASSIGN cAuxTraducao025 = {ininc/i11in172.i 04 item-doc-est.cd-trib-iss}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao025)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN c-trib-iss   = RETURN-VALUE.
    &else
        ASSIGN c-trib-icm   = {ininc/i07in122.i 04 item-doc-est.cd-trib-icm}.
        ASSIGN c-trib-ipi   = {ininc/i10in172.i 04 item-doc-est.cd-trib-ipi}.
        ASSIGN c-trib-iss   = {ininc/i11in172.i 04 item-doc-est.cd-trib-iss}.
    &endif

    RUN recupera-aliquotas in h-cdapi995 (INPUT "item-doc-est", 
                                          INPUT item-doc-est.serie-docto + "/" + 
                                                item-doc-est.nro-docto + "/" + 
                                                string(item-doc-est.cod-emitente) + "/" + 
                                                item-doc-est.nat-operacao + "/" + 
                                                string(item-doc-est.sequencia), 
                                          output de-pc-pis, 
                                          output de-pc-cofins).

    IF de-pc-pis    = 0 THEN ASSIGN de-pc-pis    = item-doc-est.val-aliq-pis.
    IF de-pc-cofins = 0 THEN ASSIGN de-pc-cofins = item-doc-est.val-aliq-cofins.

    ASSIGN c-trib-pis          = if item-doc-est.idi-tributac-pis = 1 then "T"
                                 else IF item-doc-est.idi-tributac-pis = 4 THEN "R"
                                 else IF item-doc-est.idi-tributac-pis = 3 THEN "O"
                                 ELSE "I"
           de-aliq-pis         = de-pc-pis
           de-base-calc-pis    = item-doc-est.base-pis
           de-valor-pis        = item-doc-est.valor-pis
           c-trib-cofins       = if item-doc-est.idi-tributac-cofins = 1 then "T"
                                 else IF item-doc-est.idi-tributac-cofins = 4 THEN "R"
                                 else IF item-doc-est.idi-tributac-cofins = 3 THEN "O"
                                 ELSE "I"
           de-aliq-cofins      = de-pc-cofins
           de-base-calc-cofins = dec(item-doc-est.val-base-calc-cofins)
           de-valor-cofins     = dec(item-doc-est.val-cofins).


    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-detalha-nfc:

    for each rat-docum no-lock
       where rat-docum.nf-serie    = docum-est.serie-docto
         and rat-docum.nf-nro      = docum-est.nro-docto
         and rat-docum.nf-emitente = docum-est.cod-emitente
         and rat-docum.nf-nat-oper = docum-est.nat-operacao:          

        for each bf-docum-est 
            where bf-docum-est.serie-docto  = rat-docum.serie-docto
              and bf-docum-est.nro-docto    = rat-docum.nro-docto
              and bf-docum-est.cod-emitente = rat-docum.cod-emitente
              and bf-docum-est.nat-operacao = rat-docum.nat-operacao no-lock:

            /*Considera Somente notas fiscais complementares atualizadas no estoque*/
            IF tt-param.l-somente-nfc-ce-atual 
            AND NOT bf-docum-est.ce-atual THEN NEXT.

            FOR FIRST bf-emitente NO-LOCK 
                WHERE bf-emitente.cod-emitente = bf-docum-est.cod-emitente:
            END.
            IF NOT AVAIL bf-emitente THEN NEXT.

            FOR FIRST bf-natur-oper NO-LOCK
                WHERE bf-natur-oper.nat-operacao = bf-docum-est.nat-operacao:
            END.
            IF NOT AVAIL bf-natur-oper THEN NEXT.

            disp c-lb-tit-nfc with frame f-tit-nfc.

            DISP bf-docum-est.cod-emitente
                 bf-docum-est.serie-docto
                 c-embarque-imp
                 bf-emitente.nome-abrev    WHEN AVAIL emitente
                 bf-docum-est.nro-docto
                 bf-docum-est.nat-operacao
                 bf-natur-oper.especie-doc WHEN AVAIL natur-oper
                 WITH FRAME f-nota-complementar.

            /*prepara‡Æo dados f-corpo-nfc*/
            {imp/im0401.i3 "bf-docum-est"}

            /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-2671) */
            IF  l-spp-NT2024002 THEN DO:
                disp c-esp-docto
                     c-especie[lookup(string(bf-docum-est.esp-docto),"20,21,22,23")]
                               when can-do("20,21,22,23", string(bf-docum-est.esp-docto)) @ c-especie[1]
                     bf-docum-est.cod-observa    c-observa
                     bf-docum-est.cod-estabel    da-ven-icm
                     bf-docum-est.estab-fisc     da-ven-ipi
                     bf-docum-est.base-iss       da-ven-iss
                     bf-docum-est.dt-emissao     c-transp
                     bf-docum-est.iss-deb-cre    l-compras
                     bf-docum-est.dt-trans       l-of-online when l-of-online <> ?
                     bf-docum-est.base-ipi       l-ap-online when l-ap-online <> ?
                     l-cr-online when l-cr-online <> ?
                     bf-docum-est.ipi-deb-cre
                     l-docto-imp
                     l-memorando-exportacao
                     bf-docum-est.usuario
                     bf-docum-est.via-transp
                     bf-docum-est.icm-fonte
                     bf-docum-est.ce-atual
                     c-ct-transit
                     c-sc-transit
                     bf-docum-est.base-subs
                     bf-docum-est.despesa-nota
                     bf-docum-est.vl-subs
                     bf-docum-est.of-atual
                     bf-docum-est.tot-peso
                     bf-docum-est.base-icm
                     bf-docum-est.ap-atual
                     bf-docum-est.tot-desconto
                     bf-docum-est.icm-deb-cre
                     bf-docum-est.peso-bruto-tot
                     de-base-pis
                     bf-docum-est.cr-atual
                     bf-docum-est.valor-mercad
                     de-pis 
                     bf-docum-est.tot-valor
                     de-base-cofins 
                     de-cofins   
                     bf-docum-est.vl-pis-subs
                     bf-docum-est.vl-cofins-subs
                     docum-est.log-sumar
                     docum-est.log-ctbl-atual
                     /*====================== Impostos Reforma Tribut ria ============================*/
                     de-base-cbs
                     de-base-ibs-uf
                     de-base-ibs-mun
                     de-valor-cbs
                     de-valor-ibs-uf
                     de-valor-ibs-mun
                     de-base-cbs-reg
                     de-base-ibs-uf-reg
                     de-base-ibs-mun-reg
                     de-valor-cbs-reg
                     de-valor-ibs-uf-reg
                     de-valor-ibs-mun-reg                     
                     de-base-is
                     de-valor-is  
                     bf-docum-est.valor-tot-nf-rt                   
                    /*================================================================================*/
                     with frame f-corpo-nfc-RT.
            END.
            /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-2671) */
            ELSE DO:
                disp c-esp-docto
                     c-especie[lookup(string(bf-docum-est.esp-docto),"20,21,22,23")]
                               when can-do("20,21,22,23", string(bf-docum-est.esp-docto)) @ c-especie[1]
                     bf-docum-est.cod-observa    c-observa
                     bf-docum-est.cod-estabel    da-ven-icm
                     bf-docum-est.estab-fisc     da-ven-ipi
                     bf-docum-est.base-iss       da-ven-iss
                     bf-docum-est.dt-emissao     c-transp
                     bf-docum-est.iss-deb-cre    l-compras
                     bf-docum-est.dt-trans       l-of-online when l-of-online <> ?
                     bf-docum-est.base-ipi       l-ap-online when l-ap-online <> ?
                     l-cr-online when l-cr-online <> ?
                     bf-docum-est.ipi-deb-cre
                     l-docto-imp
                     l-memorando-exportacao
                     bf-docum-est.usuario
                     bf-docum-est.via-transp
                     bf-docum-est.icm-fonte
                     bf-docum-est.ce-atual
                     c-ct-transit
                     c-sc-transit
                     bf-docum-est.base-subs
                     bf-docum-est.despesa-nota
                     bf-docum-est.vl-subs
                     bf-docum-est.of-atual
                     bf-docum-est.tot-peso
                     bf-docum-est.base-icm
                     bf-docum-est.ap-atual
                     bf-docum-est.tot-desconto
                     bf-docum-est.icm-deb-cre
                     bf-docum-est.peso-bruto-tot
                     de-base-pis
                     bf-docum-est.cr-atual
                     bf-docum-est.valor-mercad
                     de-pis 
                     bf-docum-est.tot-valor
                     de-base-cofins 
                     de-cofins   
                     bf-docum-est.vl-pis-subs
                     bf-docum-est.vl-cofins-subs
                     with frame f-corpo-nfc.
            END.
            
            DISP c-lb-tit-end WITH FRAME f-tit-end.

            DISP bf-docum-est.cod-entrega
                 bf-docum-est.endereco
                 bf-docum-est.bairro
                 bf-docum-est.cep
                 bf-docum-est.cidade  FORMAT 'x(30)'
                 bf-docum-est.uf
                 bf-docum-est.pais
                 bf-docum-est.log-consid-ender-nf-saida
                 WITH FRAME f-endereco-nfc.

            /*Detalhamento das despesas*/
            IF tt-param.l-despesa THEN DO:
                CREATE tt-doc.
                ASSIGN tt-doc.serie-docto  = bf-docum-est.serie-docto
                       tt-doc.nro-docto    = bf-docum-est.nro-docto
                       tt-doc.cod-emitente = bf-docum-est.cod-emitente
                       tt-doc.nat-operacao = bf-docum-est.nat-operacao
                       tt-doc.tipo         = 1.
                RUN docum_desp_imp_detalhe IN h-im9014 (INPUT TABLE tt-doc).
                DELETE tt-doc.
            END.

             /*Detalhamento dos itens*/
            IF tt-param.l-item THEN DO:
                RUN pi-detalha-item (INPUT bf-docum-est.serie-docto,
                                     INPUT bf-docum-est.nro-docto,
                                     INPUT bf-docum-est.cod-emitente,
                                     INPUT bf-docum-est.nat-operacao,
                                     INPUT bf-docum-est.cod-estabel).
            END.

            if  tt-param.l-duplicatas then do: 
        
                for each item-doc-est
                   WHERE item-doc-est.serie-docto  = bf-docum-est.serie-docto
                     AND item-doc-est.nro-docto    = bf-docum-est.nro-docto
                     AND item-doc-est.cod-emitente = bf-docum-est.cod-emitente
                     AND item-doc-est.nat-operacao = bf-docum-est.nat-operacao NO-LOCK:  
            
                    if  item-doc-est.num-pedido <> 0 then do: 
                        find first tt-pedidos
                            where tt-pedidos.num-pedido = item-doc-est.num-pedido
                            no-error.
                        if  not avail tt-pedidos then do:
                            create tt-pedidos.
                            assign tt-pedidos.num-pedido = item-doc-est.num-pedido.
                        end.
                        assign tt-pedidos.quantidade = tt-pedidos.quantidade + 1.
                    end.
                end.

                {imp/im0401.i4 "bf-docum-est"} /*tratamento de valores docum-est*/
        
                RUN pi-detalha-duplicata (INPUT bf-docum-est.serie-docto,
                                          INPUT bf-docum-est.nro-docto,
                                          INPUT bf-docum-est.cod-emitente,
                                          INPUT bf-docum-est.nat-operacao,
                                          INPUT bf-docum-est.cod-estabel,
                                          INPUT bf-docum-est.pais).
        
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
        

PROCEDURE pi-imprime-det-itiner:
    put skip(1).
    for each bf-historico-embarque 
        where bf-historico-embarque.cod-estabel = historico-embarque.cod-estabel and 
              bf-historico-embarque.cod-itiner  = historico-embarque.cod-itiner  and
              bf-historico-embarque.embarque    = historico-embarque.embarque    no-lock         
              break by historico-embarque.sequencia:

        disp bf-historico-embarque.sequencia
             bf-historico-embarque.cod-pto-contr 
             with frame f-det-embarque.
        IF bf-historico-embarque.descricao <> "":U THEN DO:
            ASSIGN c-descricao = bf-historico-embarque.descricao.
        END.
        ELSE DO:
            FOR FIRST pto-contr FIELDS(descricao cod-pto-contr) NO-LOCK
                WHERE pto-contr.cod-pto-contr = bf-historico-embarque.cod-pto-contr:
                ASSIGN c-descricao = pto-contr.descricao.
            END.
        END.

        /* Diferenca */                        
        if bf-historico-embarque.dt-efetiva <> ? then 
            assign i-diferenca-pto = bf-historico-embarque.dt-efetiva - bf-historico-embarque.dt-previsao.     
        else 
            assign i-diferenca-pto = bf-historico-embarque.dt-ult-previsao - bf-historico-embarque.dt-previsao.
        /* Historico */                        
        disp c-descricao
             bf-historico-embarque.dt-previsao
             bf-historico-embarque.dt-ult-previsao
             bf-historico-embarque.dt-efetiva
             i-diferenca-pto
             bf-historico-embarque.id-meio-transp 
             with frame f-det-embarque.
        down with frame f-det-embarque.
    end. 

    PUT SKIP(1).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-detalha-item:
    DEFINE INPUT PARAMETER pc-serie-docto  LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pc-nro-docto    LIKE docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pc-nat-operacao LIKE docum-est.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel  LIKE docum-est.cod-estabel  NO-UNDO.

    ASSIGN l-mostra = YES.

    ASSIGN de-peso-bruto = 0.

    FOR EACH item-doc-est
       WHERE item-doc-est.serie-docto  = pc-serie-docto
         AND item-doc-est.nro-docto    = pc-nro-docto
         AND item-doc-est.cod-emitente = pi-cod-emitente
         AND item-doc-est.nat-operacao = pc-nat-operacao NO-LOCK:  
        
        /* Verifica se item sera impresso na mesma p gina */
        assign i-diferenca = page-size - line-counter.
        if i-diferenca < 18 then page.                    
        if  l-mostra then do:
            assign l-mostra = no.
            disp c-lb-tit-it with frame f-tit-it.
        end.

        find item
            where item.it-codigo = item-doc-est.it-codigo
            no-lock no-error.
        IF AVAIL ITEM THEN DO:
            ASSIGN  de-var-val-re-maior = 0
                    de-var-qtd-re       = 0 .

            /* Buca a variacao por familia ou item-uni estab de acordo com ver EMS.*/
            {rep/re1001.i10 pc-cod-estabel}

            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
                ASSIGN cAuxTraducao005 = {ininc/i09in122.i 04 item.tipo-contr}.
                run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao005)," ","_"),
                                    INPUT "",
                                    INPUT "").
                ASSIGN  c-tipo-contr = RETURN-VALUE.
            &else
                ASSIGN c-tipo-contr = {ininc/i09in122.i 04 item.tipo-contr}.
            &endif
        end.

        RUN pi-atualiza-item-doc-est.
        
        IF i-pais-impto-usuario = 1 AND l-spp-NT2024002 THEN DO:
            ASSIGN de-base-cbs          = 0
                   de-base-ibs-uf       = 0
                   de-base-ibs-mun      = 0
                   de-valor-cbs         = 0
                   de-valor-ibs-uf      = 0
                   de-valor-ibs-mun     = 0
                   de-aliq-efet-cbs     = 0
                   de-aliq-efet-ibs-uf  = 0
                   de-aliq-efet-ibs-mun = 0
                   de-base-cbs-reg      = 0
                   de-base-ibs-uf-reg   = 0
                   de-base-ibs-mun-reg  = 0
                   de-valor-cbs-reg     = 0
                   de-valor-ibs-uf-reg  = 0
                   de-valor-ibs-mun-reg = 0
                   de-aliq-reg-cbs      = 0
                   de-aliq-reg-ibs-uf   = 0
                   de-aliq-reg-ibs-mun  = 0
                   de-base-is           = 0
                   de-valor-is          = 0
                   de-aliq-efet-is      = 0.

            FOR EACH  item-doc-est-tribut NO-LOCK
                WHERE item-doc-est-tribut.cod-serie-docto  = item-doc-est.serie-docto
                AND   item-doc-est-tribut.cod-num-docto    = item-doc-est.nro-docto
                AND   item-doc-est-tribut.cdn-emitente     = item-doc-est.cod-emitente
                AND   item-doc-est-tribut.cod-natur-operac = item-doc-est.nat-operacao
                AND   item-doc-est-tribut.num-seq          = item-doc-est.sequencia:

                IF (item-doc-est-tribut.nom-trib <> "CBS":U
                AND item-doc-est-tribut.nom-trib <> "IBS UF":U
                AND item-doc-est-tribut.nom-trib <> "IBS MUN":U
                AND item-doc-est-tribut.nom-trib <> "IS":U)
                OR (item-doc-est-tribut.cod-campo <> "BASE":U
                AND item-doc-est-tribut.cod-campo <> "VALOR":U
                AND item-doc-est-tribut.cod-campo <> "ALIQ EFETIVA":U
                AND item-doc-est-tribut.cod-campo <> "ALIQUOTA REG":U
                AND item-doc-est-tribut.cod-campo <> "BASE REG":U
                AND item-doc-est-tribut.cod-campo <> "VALOR REG":U) THEN NEXT.

                CASE item-doc-est-tribut.cod-campo:
                    WHEN "BASE":U THEN DO:
                        IF item-doc-est-tribut.nom-trib = "CBS":U THEN
                            ASSIGN de-base-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                            ASSIGN de-base-ibs-uf = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                            ASSIGN de-base-ibs-mun = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IS":U THEN
                            ASSIGN de-base-is = DEC(item-doc-est-tribut.cod-conteudo).
                    END.
                    WHEN "VALOR":U THEN DO:
                        IF item-doc-est-tribut.nom-trib = "CBS":U THEN
                            ASSIGN de-valor-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                            ASSIGN de-valor-ibs-uf = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                            ASSIGN de-valor-ibs-mun = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IS":U THEN
                            ASSIGN de-valor-is = DEC(item-doc-est-tribut.cod-conteudo).
                    END.
                    WHEN "ALIQ EFETIVA":U THEN DO:
                        IF item-doc-est-tribut.nom-trib = "CBS":U THEN
                            ASSIGN de-aliq-efet-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                            ASSIGN de-aliq-efet-ibs-uf = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                            ASSIGN de-aliq-efet-ibs-mun = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IS":U THEN
                            ASSIGN de-aliq-efet-is = DEC(item-doc-est-tribut.cod-conteudo).
                    END.
                    WHEN "BASE REG":U THEN DO:
                        IF item-doc-est-tribut.nom-trib = "CBS":U THEN
                            ASSIGN de-base-cbs-reg = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                            ASSIGN de-base-ibs-uf-reg = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                            ASSIGN de-base-ibs-mun-reg = DEC(item-doc-est-tribut.cod-conteudo).
                    END.
                    WHEN "VALOR REG":U THEN DO:
                        IF item-doc-est-tribut.nom-trib = "CBS":U THEN
                            ASSIGN de-valor-cbs-reg = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                            ASSIGN de-valor-ibs-uf-reg = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                            ASSIGN de-valor-ibs-mun-reg = DEC(item-doc-est-tribut.cod-conteudo).
                    END.
                    WHEN "ALIQUOTA REG":U THEN DO:
                        IF item-doc-est-tribut.nom-trib = "CBS":U THEN
                            ASSIGN de-aliq-reg-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                            ASSIGN de-aliq-reg-ibs-uf = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                            ASSIGN de-aliq-reg-ibs-mun = DEC(item-doc-est-tribut.cod-conteudo).
                    END.
                END CASE.
            END.            
        END.

        IF docum-est.idi-nf-simples-remes = 1 THEN
            FIND FIRST prazo-compra
                 WHERE prazo-compra.numero-ordem = item-doc-est.num-ord-import
                   AND prazo-compra.parcela      = item-doc-est.num-parc-import NO-LOCK NO-ERROR.
        ELSE
            FIND FIRST prazo-compra
                 WHERE prazo-compra.numero-ordem = item-doc-est.numero-ordem
                   AND prazo-compra.parcela      = item-doc-est.parcela NO-LOCK NO-ERROR.

        if  avail prazo-compra THEN DO:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                DEFINE VARIABLE cAuxTraducao006 AS CHARACTER NO-UNDO.
                ASSIGN cAuxTraducao006 = {ininc/i02in274.i 04 prazo-compra.situacao}.
                run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao006)," ","_"),
                                    INPUT "",
                                    INPUT "").
                ASSIGN  c-situacao = RETURN-VALUE.
            &else
                ASSIGN c-situacao = {ininc/i02in274.i 04 prazo-compra.situacao}.
            &endif
        END.
        FIND FIRST classif-fisc 
             WHERE classif-fisc.class-fiscal = item-doc-est.class-fiscal  no-lock no-error.
        assign c-perc-red-ipi = STRING(item-doc-est.val-perc-rep-ipi)
               c-perc-red-icm = STRING(item-doc-est.val-perc-red-icms)
               c-classif-desc = if avail classif-fisc then classif-fisc.descricao
                                else "".
        find first bf-natur-oper where bf-natur-oper.nat-operacao = item-doc-est.nat-of no-lock no-error.
        assign c-nat-of-desc = if avail bf-natur-oper then bf-natur-oper.denominacao
                               else "".

        /* Formatando conta e centro de custo */
        if c-formato-conta <> "" then
            assign c-ct-codigo = string(item-doc-est.ct-codigo, c-formato-conta).
        else
            assign c-ct-codigo = item-doc-est.ct-codigo.
        if c-formato-ccusto <> "" then
            assign c-sc-codigo = string(item-doc-est.sc-codigo, c-formato-ccusto).
        else
            assign c-sc-codigo = item-doc-est.sc-codigo. 

        IF docum-est.idi-nf-simples-remes = 1 THEN
            FIND first ordens-embarque 
                 WHERE ordens-embarque.cod-estabel  = embarque-imp.cod-estabel
                   AND ordens-embarque.embarque     = embarque-imp.embarque
                   AND ordens-embarque.numero-ordem = item-doc-est.num-ord-import
                   AND ordens-embarque.parcela      = item-doc-est.num-parc-import  NO-LOCK NO-ERROR.

        ELSE
            FIND FIRST ordens-embarque 
                 WHERE ordens-embarque.cod-estabel  = embarque-imp.cod-estabel
                   AND ordens-embarque.embarque     = embarque-imp.embarque
                   AND ordens-embarque.numero-ordem = item-doc-est.numero-ordem
                   AND ordens-embarque.parcela      = item-doc-est.parcela  NO-LOCK NO-ERROR.

        IF AVAIL ordens-embarque THEN DO:
            ASSIGN de-peso-bruto = ordens-embarque.peso-bruto.

            {cxbo/bocx225e.i4 no ordens-embarque} /* busca valores atributos livres */
            ASSIGN l-gravado = l-ja-gravado.
    
            FOR FIRST cotacao-item 
                WHERE cotacao-item.numero-ordem = ordens-embarque.numero-ordem 
                  AND cotacao-item.cod-emitente = item-doc-est.cod-emitente 
                  AND cotacao-item.it-codigo    = item-doc-est.it-codigo    
                  AND cotacao-item.cot-aprovada NO-LOCK:
            END.
            IF AVAIL cotacao-item THEN DO:
                IF TRIM(SUBSTRING(cotacao-item.char-1,148,1)) = "1":U THEN DO:
                   {utp/ut-liter.i Sim * r}
                   ASSIGN c-ex-tarifario = TRIM(RETURN-VALUE).
               END.
               ELSE DO:
                   {utp/ut-liter.i NÆo * r}
                   ASSIGN c-ex-tarifario = TRIM(RETURN-VALUE).
               END.
            END.

            IF NOT l-gravado THEN DO:
               IF AVAIL cotacao-item THEN DO:
                   {ccp/cc9019.i50} /* include tratamento atributo livre cotacao-item.char-1 */
                   {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                   {ccp/cc9019.i51 "yes"}
               END.
               ASSIGN i-trib-ii-i1  = INTEGER(SUBSTRING(ITEM.char-2,20,2))
                      de-aliq-ii-i1 = de-aliq-ii-i50.
            END.
        END.
        CASE i-trib-ii-i1:
             WHEN 1 THEN
                 ASSIGN c-trib-ii = "T".
             WHEN 2 THEN
                 ASSIGN c-trib-ii = "I".
             WHEN 3 THEN
                 ASSIGN c-trib-ii = "O".
             WHEN 4 THEN
                 ASSIGN c-trib-ii = "R".
         END CASE.

        /* Brasil */
        IF i-pais-impto-usuario = 1 THEN DO:

            /*Gera Primeira Remessa com NF MÆe*/
            IF TRIM(SUBSTRING(item-doc-est.char-2,940,1)) = "S":U THEN DO:
                {utp/ut-liter.i Sim * r}
                ASSIGN c-item-gera-nf-mae-filha = TRIM(RETURN-VALUE).
            END.
            ELSE DO:
                {utp/ut-liter.i NÆo * r}
                ASSIGN c-item-gera-nf-mae-filha = TRIM(RETURN-VALUE).
            END.

            IF l-spp-NT2024002 THEN DO:
                disp item-doc-est.it-codigo      item.desc-item            when avail item
                     item-doc-est.un             de-var-val-re-maior      
                     item-doc-est.cod-refer      de-var-qtd-re
                     item-doc-est.cod-depos      natur-oper.aliq-icm-com   when avail natur-oper
                     item-doc-est.num-pedido     classif-fisc.aliquota-ipi when avail classif-fisc
                     item-doc-est.numero-ordem   c-classif-desc
                     item-doc-est.parcela        c-tipo-contr
                     item-doc-est.preco-total[1] c-situacao
                     item-doc-est.baixa-ce       c-trib-icm  
                     c-item-gera-nf-mae-filha
                     de-peso-bruto
                     item-doc-est.despesas[1]    c-trib-ipi
                     item-doc-est.qt-do-forn     c-trib-iss
                     item-doc-est.encerra-pa
                     item-doc-est.reabre-pd
                     item-doc-est.desconto[1]
                     item-doc-est.quantidade
                     item-doc-est.peso-liquido
                     item-doc-est.aliquota-icm
                     item-doc-est.aliquota-ipi
                     item-doc-est.log-2
                     item-doc-est.aliquota-iss
                     item-doc-est.valor-icm[1]
                     item-doc-est.valor-ipi[1]
                     item-doc-est.valor-iss[1]
                     item-doc-est.icm-complem[1]
                     item-doc-est.class-fiscal
                     c-perc-red-icm
                     item-doc-est.nr-ord-prod
                     c-ct-codigo
                     c-sc-codigo
                     item-doc-est.cod-unid-negoc
                     c-perc-red-ipi
                     item-doc-est.nro-comp
                     item-doc-est.serie-comp
                     item-doc-est.nat-comp
                     item-doc-est.log-1
                     item-doc-est.pr-total-cmi
                     item-doc-est.nat-of         c-nat-of-desc
                     c-trib-pis
                     de-aliq-pis
                     de-base-calc-pis
                     de-valor-pis
                     c-trib-cofins
                     de-aliq-cofins
                     de-base-calc-cofins
                     de-valor-cofins
                     de-aliq-ii-i1
                     c-trib-ii    
                     c-ex-tarifario
                     de-lim-var-valor
                     de-lim-var-qtd   
                     de-peso-bruto
                /*====================== Impostos Reforma Tribut ria ============================*/
                     de-base-cbs
                     de-aliq-efet-cbs
                     de-valor-cbs
                     de-base-ibs-uf
                     de-aliq-efet-ibs-uf
                     de-valor-ibs-uf
                     de-base-ibs-mun     
                     de-aliq-efet-ibs-mun
                     de-valor-ibs-mun    
                     de-base-cbs-reg     
                     de-aliq-reg-cbs     
                     de-valor-cbs-reg    
                     de-base-ibs-uf-reg  
                     de-aliq-reg-ibs-uf  
                     de-valor-ibs-uf-reg 
                     de-base-ibs-mun-reg 
                     de-aliq-reg-ibs-mun 
                     de-valor-ibs-mun-reg
                     de-base-is
                     de-aliq-efet-is
                     de-valor-is
                /* ==============================================================================*/
                     with frame f-item-bra-RT.
            END.
            ELSE DO:
                disp item-doc-est.it-codigo      item.desc-item            when avail item
                     item-doc-est.un             de-var-val-re-maior      
                     item-doc-est.cod-refer      de-var-qtd-re
                     item-doc-est.cod-depos      natur-oper.aliq-icm-com   when avail natur-oper
                     item-doc-est.num-pedido     classif-fisc.aliquota-ipi when avail classif-fisc
                     item-doc-est.numero-ordem   c-classif-desc
                     item-doc-est.parcela        c-tipo-contr
                     item-doc-est.preco-total[1] c-situacao
                     item-doc-est.baixa-ce       c-trib-icm  
                     c-item-gera-nf-mae-filha
                     de-peso-bruto
                     item-doc-est.despesas[1]    c-trib-ipi
                     item-doc-est.qt-do-forn     c-trib-iss
                     item-doc-est.encerra-pa
                     item-doc-est.reabre-pd
                     item-doc-est.desconto[1]
                     item-doc-est.quantidade
                     item-doc-est.peso-liquido
                     item-doc-est.aliquota-icm
                     item-doc-est.aliquota-ipi
                     item-doc-est.log-2
                     item-doc-est.aliquota-iss
                     item-doc-est.valor-icm[1]
                     item-doc-est.valor-ipi[1]
                     item-doc-est.valor-iss[1]
                     item-doc-est.icm-complem[1]
                     item-doc-est.class-fiscal
                     c-perc-red-icm
                     item-doc-est.nr-ord-prod
                     c-ct-codigo
                     c-sc-codigo
                     item-doc-est.cod-unid-negoc
                     c-perc-red-ipi
                     item-doc-est.nro-comp
                     item-doc-est.serie-comp
                     item-doc-est.nat-comp
                     item-doc-est.log-1
                     item-doc-est.pr-total-cmi
                     item-doc-est.nat-of         c-nat-of-desc
                     c-trib-pis
                     de-aliq-pis
                     de-base-calc-pis
                     de-valor-pis
                     c-trib-cofins
                     de-aliq-cofins
                     de-base-calc-cofins
                     de-valor-cofins
                     de-aliq-ii-i1
                     c-trib-ii    
                     c-ex-tarifario
                     de-lim-var-valor
                     de-lim-var-qtd   
                     de-peso-bruto
                     with frame f-item-bra.
            END.
        END.
        /* Internacional */
        ELSE DO:
            disp item-doc-est.it-codigo      item.desc-item            when avail item
                 item-doc-est.un             de-var-val-re-maior      
                 item-doc-est.cod-refer      de-var-qtd-re
                 item-doc-est.cod-depos      natur-oper.aliq-icm-com   when avail natur-oper
                 item-doc-est.num-pedido     classif-fisc.aliquota-ipi when avail classif-fisc
                 item-doc-est.numero-ordem   c-classif-desc
                 item-doc-est.parcela        c-tipo-contr
                 item-doc-est.preco-total[1] c-situacao
                 item-doc-est.baixa-ce       c-trib-icm  
                 de-peso-bruto
                 item-doc-est.despesas[1]    c-trib-ipi
                 item-doc-est.qt-do-forn     c-trib-iss
                 item-doc-est.encerra-pa
                 item-doc-est.reabre-pd
                 item-doc-est.desconto[1]
                 item-doc-est.quantidade
                 item-doc-est.peso-liquido
                 item-doc-est.aliquota-icm
                 item-doc-est.aliquota-ipi
                 item-doc-est.log-2
                 item-doc-est.aliquota-iss
                 item-doc-est.valor-icm[1]
                 item-doc-est.valor-ipi[1]
                 item-doc-est.valor-iss[1]
                 item-doc-est.icm-complem[1]
                 item-doc-est.class-fiscal
                 c-perc-red-icm
                 item-doc-est.nr-ord-prod
                 c-ct-codigo
                 c-sc-codigo
                 item-doc-est.cod-unid-negoc
                 c-perc-red-ipi
                 item-doc-est.nro-comp
                 item-doc-est.serie-comp
                 item-doc-est.nat-comp
                 item-doc-est.log-1
                 item-doc-est.pr-total-cmi
                 item-doc-est.nat-of         c-nat-of-desc
                 c-trib-pis
                 de-aliq-pis
                 de-base-calc-pis
                 de-valor-pis
                 c-trib-cofins
                 de-aliq-cofins
                 de-base-calc-cofins
                 de-valor-cofins
                 de-aliq-ii-i1
                 c-trib-ii    
                 de-lim-var-valor
                 de-lim-var-qtd   
                 de-peso-bruto
                 with frame f-item.
        END.

        put skip(1).
        
        /********** Itens - Despesas de importa‡Æo *********/
        IF  tt-param.l-despesa
        AND tt-param.l-despesas-item THEN DO:
            create tt-doc.
            assign tt-doc.serie-docto  = pc-serie-docto 
                   tt-doc.nro-docto    = pc-nro-docto   
                   tt-doc.cod-emitente = pi-cod-emitente
                   tt-doc.nat-operacao = pc-nat-operacao
                   tt-doc.sequencia    = item-doc-est.sequencia
                   tt-doc.tipo         = 2.
            RUN item_desp_importacao in h-im9014 (input TABLE tt-doc).
            DELETE tt-doc.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-detalha-duplicata:
    DEFINE INPUT PARAMETER pc-serie-docto   LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pc-nro-docto     LIKE docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-emitente  LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pc-nat-operacao  LIKE docum-est.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel   LIKE docum-est.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pc-pais          LIKE docum-est.pais         NO-UNDO.


    assign l-mostra = yes.
    for each dupli-apagar
       WHERE dupli-apagar.serie-docto  = pc-serie-docto 
         AND dupli-apagar.nro-docto    = pc-nro-docto   
         AND dupli-apagar.cod-emitente = pi-cod-emitente
         AND dupli-apagar.nat-operacao = pc-nat-operacao no-lock:
        assign de-valor-pagar = 0.
        if  l-mostra then do:
            /* verifica se cabecalho sera impresso na mesma pagina */
            assign i-diferenca = page-size - line-counter.
            if i-diferenca < 6 then page.
            disp c-lb-tit-dup
                 c-lb-titulo[1] with frame f-tit-dup.
            assign l-mostra = no.
        end.

        /*--- Traducao empresa, estabelecimento e pais, conforme
              matriz de traducao do ems 5 ---*/
        IF  CAN-FIND(FIRST dupli-imp 
                     WHERE dupli-imp.serie        = dupli-apagar.serie-docto  
                       AND dupli-imp.nro-docto    = dupli-apagar.nro-docto    
                       AND dupli-imp.parcela      = dupli-apagar.parcela      
                       AND dupli-imp.cod-emitente = dupli-apagar.cod-emitente 
                       AND dupli-imp.nat-operacao = dupli-apagar.nat-operacao) THEN DO:

            IF  NOT AVAIL estabelec
            OR  estabelec.cod-estabel <> pc-cod-estabel THEN
                FIND FIRST estabelec 
                     WHERE estabelec.cod-estabel = pc-cod-estabel NO-LOCK NO-ERROR.

            ASSIGN c-pais        = pc-pais
                   c-cod-empresa = STRING(i-empresa)
                   c-cod-estabel = pc-cod-estabel.

            RUN pi-traduz-empresa-estab-pais(INPUT-OUTPUT c-cod-empresa,
                                             INPUT-OUTPUT c-cod-estabel,
                                             INPUT-OUTPUT c-pais).

            FOR EACH  dupli-imp FIELDS(int-1 vl-imposto) 
                WHERE dupli-imp.serie        = dupli-apagar.serie-docto  
                  AND dupli-imp.nro-docto    = dupli-apagar.nro-docto    
                  AND dupli-imp.parcela      = dupli-apagar.parcela      
                  AND dupli-imp.cod-emitente = dupli-apagar.cod-emitente 
                  AND dupli-imp.nat-operacao = dupli-apagar.nat-operacao NO-LOCK:

                RUN pi-busca-tipo-imposto(INPUT c-pais, 
                                          INPUT STRING(dupli-imp.int-1), 
                                          OUTPUT i-tipo-impto).		  

                IF   i-tipo-impto  = 1  /* retencao */ THEN 
                     ASSIGN de-valor-pagar = de-valor-pagar +
                                             dupli-imp.vl-imposto.

            END.

        END.

        assign de-valor-pagar = dupli-apagar.vl-a-pagar - de-valor-pagar.

        if  de-valor-pagar < 0 then
            assign de-valor-pagar = 0.

        assign i-cont      = i-cont + 1
        .
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao011 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao011 = {ininc/i01in088.i 04 dupli-apagar.esp-movto}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao011)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN c-esp-movto = RETURN-VALUE.
        &else
            ASSIGN c-esp-movto = {ininc/i01in088.i 04 dupli-apagar.esp-movto}.
        &endif

        disp dupli-apagar.parcela      de-valor-pagar
             dupli-apagar.cod-esp      c-esp-movto
             dupli-apagar.tp-despesa
             dupli-apagar.nr-duplic
             dupli-apagar.dt-emissao
             dupli-apagar.dt-trans
             dupli-apagar.dt-vencim
             dupli-apagar.desconto
             dupli-apagar.dt-venc-desc
             da-data[i-cont]  when i-cont < 12 @ da-data[1]
             de-valor[i-cont] when i-cont < 12
                              and de-valor[i-cont] <> 0
                              @ de-valor[1]
             with frame f-dupli-apagar.
        down with frame f-dupli-apagar.
        if  i-cond-pagto <> 0 and i-cont = i-num-parc then
            assign de-valor = 0
                   da-data  = ?.
        for each  dupli-imp no-lock
            where dupli-imp.serie        = dupli-apagar.serie-docto
            and   dupli-imp.nro-docto    = dupli-apagar.nro-docto
            and   dupli-imp.parcela      = dupli-apagar.parcela
            and   dupli-imp.nat-operacao = dupli-apagar.nat-operacao
            and   dupli-imp.cod-emitente = dupli-apagar.cod-emitente:

            assign dt-vencto = dupli-imp.dt-venc-imp.
            disp dupli-apagar.dt-emissao
                 dupli-apagar.dt-trans
                 dupli-imp.parcela-imp   @ dupli-apagar.parcela
                 dupli-imp.cod-esp       @ dupli-apagar.cod-esp
                 dupli-imp.tp-codigo     @ dupli-apagar.tp-despesa
                 dupli-imp.nro-docto-imp @ dupli-apagar.nr-duplic
                 dupli-imp.vl-imposto    @ de-valor-pagar
                 dt-vencto               @ dupli-apagar.dt-vencim
                 with frame f-dupli-apagar.
            down with frame f-dupli-apagar.

        end.
    end.

    do  i-cont = i-cont to i-num-parc:
        if  l-mostra then do:
            disp c-lb-tit-dup
                 c-lb-titulo[1] with frame f-tit-dup.
            assign l-mostra = no.
        end.
        assign i-cont = i-cont + 1.
        disp da-data[i-cont]  when i-cont < 12 @ da-data[1]
             de-valor[i-cont] when i-cont < 12
                              and de-valor[i-cont] <> 0
                              @ de-valor[1]
             with frame f-dupli-apagar.
        down with frame f-dupli-apagar.
    end.

    create tt-doc.
    assign tt-doc.serie-docto  = pc-serie-docto
           tt-doc.nro-docto    = pc-nro-docto
           tt-doc.cod-emitente = pi-cod-emitente
           tt-doc.nat-operacao = pc-nat-operacao
           tt-doc.num-pedido   = i-pedido
           tt-doc.tipo         = 3.

    run dupli_desp_importacao in h-im9014 (input TABLE tt-doc).
    delete tt-doc.

    RETURN "OK":U.
END PROCEDURE.
