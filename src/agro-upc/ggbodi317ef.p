/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGBODI317EF 2.00.00.042 } /*** "010042" 29/05/2025 09:23:33  ***/

/*************************************************************************
**  Programa.: agbodi317ef.p
**  Objetivo.: BO da tabela "wt-docto".
*************************************************************************/

{include/i-epc200.i bodi317ef}

/* Definicao de Parametros */
DEF INPUT        PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc. 

/* Definicao de Variaveis */
DEF VAR h-bodi317ef         AS HANDLE  NO-UNDO.
DEF VAR i-emis              AS INT     NO-UNDO.
DEF VAR i-nivel             AS INT     NO-UNDO.
DEF VAR lDevolFatur         AS LOG     NO-UNDO.
DEF var i-seq-wt-docto      AS INT     NO-UNDO.
DEF VAR i-num-seq-mov       AS INT     NO-UNDO.
DEF VAR l-ok                AS LOG     NO-UNDO.
DEF VAR h-bogg00757         AS HANDLE  NO-UNDO.
DEF VAR h-bogg00759         AS HANDLE  NO-UNDO.

{utp/ut-glob.i}
{ggp/tt-erro.i}
{utp/utapi019.i}
{ggbo/bogg00757.i ttLote}
{ggbo/bogg00759.i ttLoteMov} 

DEF TEMP-TABLE tt-notas    NO-UNDO
    FIELD rw-nota-fiscal   AS ROWID
    FIELD nr-nota        LIKE nota-fiscal.nr-nota-fis
    FIELD seq-wt-docto   LIKE wt-docto.seq-wt-docto.

FIND FIRST gg-param NO-LOCK NO-ERROR.
IF NOT AVAIL gg-param THEN
    RETURN "OK":U.

/*--------------------------------------------------------------------------------------------------------------------*/
IF  p-ind-event = "afterEfetivaNota":U THEN DO:

    /* Grava o wt-docto.seq-wt-docto */
    FIND tt-epc WHERE tt-epc.cod-parameter = "table-rowid":U NO-ERROR.

    IF  AVAIL tt-epc THEN DO:
        FIND wt-docto NO-LOCK WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
        IF  AVAIL wt-docto THEN
            ASSIGN i-seq-wt-docto = wt-docto.seq-wt-docto.
    END.

    /* Atualiza tabelas extensao */
    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = p-ind-event
           AND tt-epc.cod-parameter = "object-handle":U NO-LOCK NO-ERROR.
    IF  AVAIL tt-epc AND i-seq-wt-docto <> 0 THEN DO:
        ASSIGN h-bodi317ef = WIDGET-HANDLE(tt-epc.val-parameter).

        RUN buscaTTNotasGeradas IN h-bodi317ef(OUTPUT l-ok,
                                               OUTPUT TABLE tt-notas).
        FIND LAST tt-notas NO-LOCK NO-ERROR.
        IF  AVAIL tt-notas THEN DO:

            FIND nota-fiscal WHERE ROWID(nota-fiscal) = tt-notas.rw-nota-fiscal NO-LOCK NO-ERROR.

            IF  AVAIL nota-fiscal THEN DO:
                /* Pesagem */
                FIND FIRST gg-ext-wt-docto NO-LOCK
                     WHERE gg-ext-wt-docto.seq-wt-docto = i-seq-wt-docto NO-ERROR.  
                IF  AVAIL gg-ext-wt-docto THEN DO:

                    ASSIGN i-emis = 0. 
                    FOR FIRST estabelec FIELDS(cod-emitente ep-codigo) 
                        WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-LOCK:
                        ASSIGN i-emis = estabelec.cod-emitente.
                    END.
                
                    FIND FIRST gg-ext-nota-fiscal EXCLUSIVE-LOCK
                         WHERE gg-ext-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                           AND gg-ext-nota-fiscal.serie       = nota-fiscal.serie      
                           AND gg-ext-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.

                    IF  NOT AVAIL gg-ext-nota-fiscal THEN DO:
                        CREATE gg-ext-nota-fiscal.
                        ASSIGN gg-ext-nota-fiscal.cod-estabel    = nota-fiscal.cod-estabel
                               gg-ext-nota-fiscal.serie          = nota-fiscal.serie      
                               gg-ext-nota-fiscal.nr-nota-fis    = nota-fiscal.nr-nota-fis
                               gg-ext-nota-fiscal.ep-codigo      = IF AVAIL estabelec THEN estabelec.ep-codigo ELSE "":U
                               gg-ext-nota-fiscal.cod-contrato   = gg-ext-wt-docto.cod-contrato.
                    END.
                    
                    ASSIGN gg-ext-nota-fiscal.qtd-peso-bruto = gg-ext-wt-docto.qtd-peso-bruto
                           gg-ext-nota-fiscal.qtd-peso-liq   = gg-ext-wt-docto.qtd-peso-liq 
                           gg-ext-nota-fiscal.qtd-peso-tara  = gg-ext-wt-docto.qtd-peso-tara
                           gg-ext-nota-fiscal.log-liq        = gg-ext-wt-docto.log-liq 
                           gg-ext-nota-fiscal.log-tara       = gg-ext-wt-docto.log-tara
                           gg-ext-nota-fiscal.log-transito   = gg-ext-wt-docto.log-transito
                           gg-ext-nota-fiscal.cod-emissor    = i-emis.
                    FIND CURRENT gg-ext-nota-fiscal NO-LOCK NO-ERROR.
                END.

                /* Originacao */
                FOR EACH gg-classifica EXCLUSIVE-LOCK                        
                   WHERE gg-classifica.des-tipo-docto = "wt-docto":U
                     AND gg-classifica.num-docto      = STRING(i-seq-wt-docto):
          
                    {utp/ut-liter.i "nota-fiscal" * R}
                    ASSIGN gg-classifica.des-tipo-docto = RETURN-VALUE 
                           gg-classifica.cod-estabel    = nota-fiscal.cod-estabel  
                           gg-classifica.num-docto      = nota-fiscal.nr-nota-fis
                           gg-classifica.serie          = nota-fiscal.serie.            
                END.
                FIND CURRENT gg-classifica NO-LOCK NO-ERROR.

                /* entregas X fixaá∆o de componente */
                IF  nota-fiscal.esp-docto = 20 /* devoluá∆o */ THEN DO:

                    ASSIGN i-nivel     = 2
                           lDevolFatur = NO.
                    REPEAT WHILE PROGRAM-NAME(i-nivel) <> ?.

                        IF  STRING(TRIM (PROGRAM-NAME(i-nivel))) MATCHES "*FT4003*" THEN DO:
                            ASSIGN lDevolFatur = YES.
                            LEAVE.
                        END.
                        ASSIGN i-nivel = i-nivel + 1.
                    END.

                 /* Devoluá‰es efetuadas atraves de romaneio. As fixaá‰es ser∆o atualizadas na GGAPI025 */
                    IF  lDevolFatur THEN DO:
                        RUN ggp/ggapi076.p (INPUT "nota-fiscal",
                                            INPUT ROWID(nota-fiscal),
                                            INPUT 6, /* devolucao */
                                            INPUT YES, /* vai associar a uma fixaá∆o */
                                            INPUT-OUTPUT TABLE tt-erro). 
                    END.
                END.
                ELSE DO: 
                    IF  nota-fiscal.ind-tip-nota <> 3 /* diferente de complemento */ THEN DO: 

                        RUN piAtualizaLotes. 

                    END. /* IF  nota-fiscal.ind-tip-nota <> 3 THEN DO: */
                END. /* ELSE */
            END. /* IF  AVAIL nota-fiscal THEN DO: */

        END. /* IF  AVAIL tt-notas THEN DO: */

    END. /* IF  AVAIL tt-epc THEN DO: */

END.

RETURN "OK":U.



/*--------------------------------------------------------------------------------------------------------------------*/
PROCEDURE pi-envia-email:
    DEFINE VARIABLE c-email-remetente    AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE c-email-destino      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE c-email-copia        AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE c-cadencia           AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE c-tip-pagto          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE c-tip-preco          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE c-corpo-email        AS CHARACTER                NO-UNDO.

    DEFINE VARIABLE c-mes2               AS CHARACTER FORMAT "x(10)" NO-UNDO.
    DEFINE VARIABLE c-cliente            AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-inscricao          AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-contrato           AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-safra              AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-estabel            AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-forma-pagto        AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-prazo-entrega      AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-frete              AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-produto            AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-seq                AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-local-entrega      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE c-lbl-entrega        AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE c-volume-original    AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-volume-contratado  AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-volume-entregue    AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-saldo-entregue     AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-volume-programado  AS CHARACTER FORMAT "x(19)" NO-UNDO.
    DEFINE VARIABLE c-mes4               AS CHARACTER FORMAT "x(44)" NO-UNDO.

    {utp/ut-liter.i "#### CONTRATO VENDAS COMPLETOU CADENCIA PARA COBRANCA " * R}
    ASSIGN c-mes4 = RETURN-VALUE.

    {utp/ut-liter.i "Fixo,Fixar" * R}          ASSIGN c-mes2 = RETURN-VALUE.
    {utp/ut-liter.i "Cliente:" * R}            ASSIGN c-cliente = RETURN-VALUE.
    {utp/ut-liter.i "Inscriá∆o:" * R}          ASSIGN c-inscricao = RETURN-VALUE.
    {utp/ut-liter.i "Contrato:" * R}           ASSIGN c-contrato = RETURN-VALUE.
    {utp/ut-liter.i "Safra:" * R}              ASSIGN c-safra = RETURN-VALUE.
    {utp/ut-liter.i "Estabelecimento:" * R}    ASSIGN c-estabel = RETURN-VALUE.
    {utp/ut-liter.i "Forma Pagto:" * R}        ASSIGN c-forma-pagto = RETURN-VALUE.
    {utp/ut-liter.i "Prazo Entrega:" * R}      ASSIGN c-prazo-entrega = RETURN-VALUE.
    {utp/ut-liter.i "Frete:" * R}              ASSIGN c-frete = RETURN-VALUE.
    {utp/ut-liter.i "Produto:" * R}            ASSIGN c-produto = RETURN-VALUE.
    {utp/ut-liter.i "Seq:" * R}                ASSIGN c-seq = RETURN-VALUE.
    {utp/ut-liter.i "Local Entrega:" * R}      ASSIGN c-lbl-entrega = RETURN-VALUE.
    {utp/ut-liter.i "Qt Original:" * R}        ASSIGN c-volume-original = RETURN-VALUE.
    {utp/ut-liter.i "Qt Contratada:" * R}      ASSIGN c-volume-contratado = RETURN-VALUE.
    {utp/ut-liter.i "Qt Entregue:" * R}        ASSIGN c-volume-entregue = RETURN-VALUE.
    {utp/ut-liter.i "Sld a Entregar:" * R}     ASSIGN c-saldo-entregue = RETURN-VALUE.
    {utp/ut-liter.i "Qt Prog. Cobranáa:" * R}  ASSIGN c-volume-programado = RETURN-VALUE.


    FIND FIRST param_email NO-LOCK NO-ERROR.

    ASSIGN c-email-remetente = ""
           c-email-copia     = ""
           c-email-destino   = "".

    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.
    IF  NOT AVAIL usuar_mestre THEN
        RETURN "OK":U.
    ELSE
        ASSIGN c-email-remetente = usuar_mestre.cod_e_mail_local.

    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuario = gg-contrato.cod-comprado NO-ERROR.
    IF  NOT AVAIL usuar_mestre THEN
        RETURN "OK":U.
    ELSE
        ASSIGN c-email-destino = usuar_mestre.cod_e_mail_local.

    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_grp_usuar = gg-param.cod-grupo-fat:
        FOR FIRST usuar_mestre NO-LOCK
            WHERE usuar_mestre.cod_usuario = usuar_grp_usuar.cod_usuario:
            ASSIGN c-email-copia = c-email-copia + "," + usuar_mestre.cod_e_mail_local.
        END.
    END.

    FIND FIRST gg-inscricao NO-LOCK 
         WHERE gg-inscricao.cod-emitente  = gg-contrato.cod-emitente
           AND gg-inscricao.cod-inscricao = gg-contrato.cod-inscricao NO-ERROR.


    FIND FIRST gg-forma-pagto NO-LOCK
        WHERE  gg-forma-pagto.cdn-forma-pagto = gg-contrato.ind-tipo-pagto NO-ERROR.
    IF  AVAIL  gg-forma-pagto THEN DO:

        IF  gg-forma-pagto.log-livre-1 = YES /* Cadància */ THEN
            ASSIGN c-cadencia = STRING(gg-contrato.qtd-cadencia).
        ELSE DO:
            IF  gg-forma-pagto.idi-control-troca = 3 /* Contrato de Vendas */ THEN
                ASSIGN c-cadencia = STRING(gg-contrato.cod-contrato).
            ELSE DO:
                FOR FIRST cond-pagto FIELDS(descricao)
                    WHERE cond-pagto.cod-cond-pag = gg-contrato.cod-cond-pag NO-LOCK. END.
                ASSIGN c-cadencia = cond-pagto.descricao.
            END.
        END.

        ASSIGN c-tip-pagto = gg-forma-pagto.des-forma-pagto.
    END.


    FOR FIRST ITEM FIELDS(desc-item)
        WHERE ITEM.it-codigo = gg-contrato-prod.it-codigo NO-LOCK.
    END.

    FOR FIRST emitente FIELDS(nome-abrev nome-emit)
        WHERE emitente.cod-emitente = gg-contrato.cod-emitente NO-LOCK.
    END.

    FOR FIRST estabelec FIELDS(nome)
        WHERE estabelec.cod-estabel = gg-contrato.cod-estabel NO-LOCK.
    END.

    FOR FIRST gg-tip-frete FIELDS(nom-abrev-tip-frete) 
        WHERE gg-tip-frete.cdn-tip-frete = gg-contrato.ind-frete NO-LOCK.
    END.

    FIND FIRST loc-entr
         WHERE loc-entr.nome-abrev  = emitente.nome-abrev
           AND loc-entr.cod-entrega = gg-contrato-prod.local-ent NO-LOCK NO-ERROR.
    IF AVAIL loc-entr THEN
       ASSIGN c-local-entrega = loc-entr.endereco + " " + loc-entr.cidade + " " + loc-entr.estado.

    ASSIGN c-tip-preco = ENTRY(gg-contrato.ind-tip-preco,c-mes2).

    /*  ***  Preprarar a geraá∆o do Email ***  */
    ASSIGN c-corpo-email = ' <HTML><BODY LINK="#0000ff" VLINK="#800080"> <P ALIGN=JUSTIFY><TABLE BORDER CELLSPACING=0 CELLPADDING=0>'.

    ASSIGN c-corpo-email = c-corpo-email + '
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-cliente + '</B></FONT></TD>
                           <TD COLSPAN=5>   <FONT SIZE=2 FACE="Arial">&nbsp;' + STRING(gg-contrato.cod-emitente) + ' - ' + emitente.nome-emit + '</B></FONT></TD>
                           </TR> 
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-inscricao + '</B></FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + STRING(gg-contrato.cod-inscricao) + ' - ' + gg-inscricao.nom-inscricao + '</B></FONT></TD>
                           </TR> 
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-contrato + '</FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + STRING(gg-contrato.cod-contrato) + '</B></FONT></TD>
                           </TR> 
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-safra + '</FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + string(gg-contrato.des-safra, "9999/9999") + '</B></FONT></TD>
                           </TR> 
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-estabel + '</FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + gg-contrato.cod-estabel  + " - " + estabelec.nome + '</B></FONT></TD>
                           </TR>
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-forma-pagto + '</FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + c-tip-preco + "/" + c-tip-pagto + " (" + c-cadencia + ")"  + '</B></FONT></TD>
                           </TR>
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial"></B></FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;</FONT></TD>
                           </TR>
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-prazo-entrega + '</B></FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + STRING(gg-contrato.dat-ini-embarque) + " - ":U + STRING(gg-contrato.dat-entrega-final) + '</FONT></TD>
                           </TR>
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-frete + '</B></FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + gg-tip-frete.nom-abrev-tip-frete +  '</FONT></TD>
                           </TR>
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial"></B></FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;</FONT></TD>
                           </TR>
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-produto + '</B></FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + gg-contrato-prod.it-codigo + " - " + item.desc-item +  '</FONT></TD>
                           </TR>
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-seq + '</B></FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + STRING(gg-contrato-prod.num-seq-prod) +  '</FONT></TD>
                           </TR>
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-lbl-entrega + '</B></FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + c-local-entrega +  '</FONT></TD>
                           </TR>
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-volume-original + '</B></FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + STRING(gg-contrato-prod.qtd-orig    , ">>>>,>>>,>>9.9999") + "/" + gg-contrato-prod.des-un +  '</FONT></TD>
                           </TR>
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-volume-contratado + '</B></FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + STRING(gg-contrato-prod.qtd-contrato, ">>>>,>>>,>>9.9999") +  '</FONT></TD>
                           </TR>
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-volume-entregue + '</B></FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + STRING(gg-contrato-prod.qtd-entrega , ">>>>,>>>,>>9.9999") +  '</FONT></TD>
                           </TR>
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-saldo-entregue  + '</B></FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + STRING(gg-contrato-prod.qtd-saldo   , ">>>>,>>>,>>9.9999") +  '</FONT></TD>
                           </TR>
                           <TR>
                           <TD WIDTH="25%"><B><FONT SIZE=2 FACE="Arial">&nbsp;' + c-volume-programado + '</B></FONT></TD>
                           <TD COLSPAN=5>     <FONT SIZE=2 FACE="Arial">&nbsp;' + STRING(gg-contrato-prod.qtd-pago    , ">>>>,>>>,>>9.9999") +  '</FONT></TD>
                           </TR>
                           </TABLE>
                           </P>
                           <br>'.

    ASSIGN c-corpo-email = c-corpo-email + '</BODY>
                                            </HTML>'.


    EMPTY TEMP-TABLE tt-envio2   NO-ERROR.
    EMPTY TEMP-TABLE tt-mensagem NO-ERROR.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.remetente         = c-email-remetente
           tt-envio2.destino           = c-email-destino
           tt-envio2.copia             = c-email-copia
           tt-envio2.assunto           = c-mes4 + TRIM(emitente.nome-emit) + " (" + gg-contrato.cod-contrato + ")"
           tt-envio2.formato           = "HTML":U
           tt-envio2.exchange          = param_email.log_servid_exchange
           tt-envio2.servidor          = param_email.cod_servid_e_mail
           tt-envio2.porta             = param_email.num_porta.


    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = c-corpo-email.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    DELETE PROCEDURE h-utapi019.

    RETURN "OK":U.
END PROCEDURE. 


PROCEDURE piAtualizaLotes: 
    DEFINE VARIABLE i-idi-trans     AS INTEGER     NO-UNDO.

    IF (CAN-FIND(FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
                   AND natur-oper.transf  /* Nota Fiscal Transferencia */ 
                   AND  natur-oper.especie-doc = "NFT"))
    THEN
        ASSIGN i-idi-trans = 14. /* transferància*/

    /*** Atualizar Lotes ***/
    IF  NOT VALID-HANDLE(h-bogg00757) THEN
        RUN ggbo/bogg00757.p PERSISTENT SET h-bogg00757.

    IF  NOT VALID-HANDLE (h-bogg00759) THEN
        RUN ggbo/bogg00759.p PERSISTENT SET h-bogg00759. /* LOTE-MOV */

    RUN openQueryStatic IN h-bogg00757 ( "Main":U ) NO-ERROR.
    RUN openQueryStatic IN h-bogg00759 ( "Main":U ) NO-ERROR.
    
    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK,
       FIRST natur-oper NO-LOCK
       WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao:
    
        IF  CAN-FIND(FIRST gg-param-item
                     WHERE gg-param-item.it-codigo = it-nota-fisc.it-codigo
                       AND gg-param-item.log-utiliza-caract-lote) THEN DO:

            FOR EACH  fat-ser-lote NO-LOCK
                WHERE fat-ser-lote.cod-estabel = it-nota-fisc.cod-estabel
                  AND fat-ser-lote.serie       = it-nota-fisc.serie
                  AND fat-ser-lote.nr-nota-fis = it-nota-fisc.nr-nota-fis
                  AND fat-ser-lote.it-codigo   = it-nota-fisc.it-codigo
                  AND fat-ser-lote.nr-seq-fat  = it-nota-fisc.nr-seq-fat,
                FIRST gg-lote NO-LOCK
                WHERE gg-lote.cod-lote       = fat-ser-lote.nr-serlote
                  AND gg-lote.it-codigo      = fat-ser-lote.it-codigo  
                  AND gg-lote.cod-refer-item = fat-ser-lote.cod-refer,
                FIRST gg-libera-embarq OF gg-lote NO-LOCK:  

                /* 1  Remessa Beneficiamento   */
                /* 3  Remessa Consignaá∆o      */
                /* 8  Remessa DepΩsito Fechado */
                /* 10 Remessa ArmazÇm Geral    */  

                IF  i-idi-trans <> 14 /* transferància */ THEN
                    ASSIGN i-idi-trans = IF (gg-libera-embarq.idi-instruc                              = 2 /* remessa */ 
                                         AND it-nota-fisc.nr-pedcli                                   <> gg-lote.nr-pedcli
                                         AND LOOKUP(TRIM(STRING(natur-oper.tp-oper-terc)),"1,3,8,10")  > 0
                                         AND natur-oper.terceiros                                       = YES) THEN 
                                             6 /* Remetido */
                                         ELSE
                                         IF  it-nota-fisc.nr-pedcli                                    = gg-lote.nr-pedcli THEN 
                                             5 /* Faturado */
                                         ELSE 
                                             0. /* N∆o faz nada */

                IF  i-idi-trans <> 0 THEN DO: 

                    /*Ajusta Instrucao*/
                    IF   i-idi-trans = 6 /* remetido */
                    OR  (i-idi-trans = 5 /* faturado */  AND gg-libera-embarq.idi-instruc <> 2 /* remessa */) THEN DO: 
                        FOR FIRST  gg-libera-embarq-contrat EXCLUSIVE-LOCK
                             WHERE gg-libera-embarq-contrat.ep-codigo    = gg-lote.ep-codigo
                               AND gg-libera-embarq-contrat.num-instruc  = gg-lote.num-instruc
                               AND gg-libera-embarq-contrat.cod-contrato = gg-lote.cod-contrato
                               AND gg-libera-embarq-contrat.num-seq-produt = gg-lote.num-seq-prod:
                             ASSIGN gg-libera-embarq-contrat.qtd-exped = gg-libera-embarq-contrat.qtd-exped + fat-ser-lote.qt-baixada[1].
                        END.
                    END.
    
                    IF  i-idi-trans = 6 /* remetido */ OR  i-idi-trans = 5 /* faturado */ THEN DO:
                        EMPTY TEMP-TABLE ttLote.
                        RUN emptyRowErrors  IN h-bogg00757.
                        RUN goToKey         IN h-bogg00757 ( INPUT gg-lote.num-id-lote ).
                        RUN getRecord       IN h-bogg00757 ( OUTPUT TABLE ttLote).
                        FOR FIRST ttLote :   
                            ASSIGN ttLote.idi-status = i-idi-trans.   /* neste caso o status e movimento tem o mesmo numero 5 ou 6 */
                        END.
                        RUN setRecord       IN h-bogg00757 ( INPUT TABLE ttLote ).
                        RUN updateRecord    IN h-bogg00757.
                    END.
    
                    /* *** Os movimentos para faturamento ou remessa n∆o criam o mov autom†tico, pois faltam campos a serem atualizados. *** */
                    EMPTY TEMP-TABLE ttLoteMov.
    
                    RUN piRetornaUltSeq IN h-bogg00759 ( INPUT gg-lote.num-id-lote, OUTPUT i-num-seq-mov).
    
                    CREATE ttLoteMov.
                    ASSIGN ttLoteMov.num-id-lote     = gg-lote.num-id-lote
                           ttLoteMov.num-seq         = i-num-seq-mov + 1
                           ttLoteMov.ep-codigo       = gg-lote.ep-codigo 
                           ttLoteMov.cod-estabel     = gg-lote.cod-estabel
                           ttLoteMov.it-codigo       = gg-lote.it-codigo
                           ttLoteMov.cod-refer-item  = gg-lote.cod-refer-item
                           ttLoteMov.cod-tip-comerc  = gg-lote.cod-tip-comerc
                           ttLoteMov.cod-bloco       = gg-lote.cod-bloco
                           ttLoteMov.cod-contrato    = gg-lote.cod-contrato
                           ttLoteMov.num-seq-prod    = gg-lote.num-seq-prod
                           ttLoteMov.num-reserva     = gg-lote.num-reserva
                           ttLoteMov.num-instruc     = gg-lote.num-instruc
                           ttLoteMov.num-romaneio    = gg-lote.num-romaneio
                           ttLoteMov.num-seq-pre     = gg-lote.num-seq-pre
                           ttLoteMov.nome-abrev      = gg-lote.nom-abrev
                           ttLoteMov.nr-pedcli       = gg-lote.nr-pedcli
                           ttLoteMov.idi-trans       = i-idi-trans   /* 14 - transf  6 - remetido   5 - faturado  */  
                           ttLoteMov.qtd-movto-item  = fat-ser-lote.qt-baixada[1]
                           ttLoteMov.cod-emitente    = it-nota-fisc.cd-emitente
                           ttLoteMov.num-seq-nf      = it-nota-fisc.nr-seq-fat                                    
                           ttLoteMov.cod-usuario     = c-seg-usuario
                           ttLoteMov.dat-atualiz     = it-nota-fisc.dt-emis-nota
                           ttLoteMov.hra-atualiz     = STRING(TIME, "HH:MM:SS")
                           ttLoteMov.nro-docto       = it-nota-fisc.nr-nota-fis
                           ttLoteMov.serie-docto     = it-nota-fisc.serie
                           ttLoteMov.nat-operacao    = nota-fiscal.nat-operacao.
    
                    {utp/ut-liter.i SÇrie *}
                    ASSIGN ttLoteMov.des-obs  = RETURN-VALUE + ":" + ttLoteMov.serie-docto.
                    {utp/ut-liter.i Documento_/_Seq *}
                    ASSIGN ttLoteMov.des-obs  = ttLoteMov.des-obs  + " , " + RETURN-VALUE + " : " +  ttLoteMov.nro-docto + " / " + STRING(ttLoteMov.num-seq-nf).
                    {utp/ut-liter.i Natureza *}
                    ASSIGN ttLoteMov.des-obs  = ttLoteMov.des-obs  + " , " + RETURN-VALUE + " : " +  ttLoteMov.nat-operacao.
    
                    // Dados referentes a integraá∆o com o Beneficiamento
                    ASSIGN ttLoteMov.num-livre-1                = 0 /* Sem Integraá∆o */
                           ttLoteMov.dat-livre-1                = ?
                           OVERLAY(ttLoteMov.cod-livre-1,1,8)   = "00:00:00":U
                           OVERLAY(ttLoteMov.cod-livre-1,9,200) = "":U.
    
                    // Verifica se a integraá∆o est† ativa
                    IF  CAN-FIND(FIRST gg-param-integr NO-LOCK
                                 WHERE gg-param-integr.cdn-integr = 4 /* Totvs Agro Beneficiamento */
                                 AND   gg-param-integr.log-ativo) THEN DO:
                        IF  ttLoteMov.idi-trans = 5 /* Faturamento */ OR
                            ttLoteMov.idi-trans = 6 /* Remessa     */ THEN
                            ASSIGN ttLoteMov.num-livre-1 = 2. /* N∆o Integrado */
                    END.
    
                    /* quando forem criados os campos na tabela, somente retirar essa parte de coment†rio
                    // Dados referentes a integraá∆o com o Beneficiamento
                    ASSIGN ttLoteMov.idi-integracao  = 0 /* Sem Integraá∆o */
                           ttLoteMov.dat-integracao  = ?
                           ttLoteMov.hra-integracao  = "":U
                           ttLoteMov.erro-integracao = "":U.
    
                    // Verifica se a integraá∆o est† ativa
                    IF  CAN-FIND(FIRST gg-param-integr NO-LOCK
                                 WHERE gg-param-integr.cdn-integr = 4 /* Totvs Agro Beneficiamento */
                                 AND   gg-param-integr.log-ativo) THEN DO:
                        IF  ttLoteMov.idi-trans = 5 /* Faturamento */ OR
                            ttLoteMov.idi-trans = 6 /* Remessa */     THEN
                            ASSIGN ttLoteMov.idi-integracao = 2. /* N∆o Integrado */
                    END.
                    */
                    
                    RUN emptyRowErrors  IN h-bogg00759.
                    RUN setRecord       IN h-bogg00759 ( INPUT TABLE ttLoteMov ).
                    RUN createRecord    IN h-bogg00759.
                END.

            END. //fat-ser-lote
        END. //param-item
        

        IF  gg-param.cod-grupo-fat <> "" AND 
            it-nota-fisc.nr-pedcli <> "" /* somente saidas com pedido */ THEN DO: 

            FOR FIRST gg-contrato-prod NO-LOCK
                WHERE gg-contrato-prod.nome-abrev   = it-nota-fisc.nome-ab-cli
                  AND gg-contrato-prod.nr-pedcli    = it-nota-fisc.nr-pedcli
                  AND gg-contrato-prod.nr-sequencia = it-nota-fisc.nr-seq-ped
                  AND gg-contrato-prod.it-codigo    = it-nota-fisc.it-codigo:


                /* verificar se atingiu a cadància e mandar e-mail */
                FOR FIRST gg-contrato OF gg-contrato-prod NO-LOCK
                    WHERE gg-contrato.qtd-cadencia   > 0:
                    FIND FIRST gg-forma-pagto NO-LOCK /* cadencia */
                        WHERE  gg-forma-pagto.cdn-forma-pagto = gg-contrato.ind-tipo-pagto
                        AND    gg-forma-pagto.log-livre-1     = YES /* Cadància */ NO-ERROR.
                    IF  AVAIL  gg-forma-pagto THEN DO:

                        IF  TRUNCATE( ( gg-contrato-prod.qtd-entrega - it-nota-fisc.qt-faturada[1] ) / gg-contrato.qtd-cadencia,0) < TRUNCATE(gg-contrato-prod.qtd-entrega / gg-contrato.qtd-cadencia,0 ) THEN DO:
                            RUN pi-envia-email.
                        END.
                    END.
                END. /* --- FOR FIRST gg-contrato OF gg-contrato-prod NO-LOCK - */
            END.
        END.
    END. /* FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK */

    IF  VALID-HANDLE(h-bogg00757) THEN DO:
        RUN destroy IN h-bogg00757.
        ASSIGN h-bogg00757 = ?.
    END.
    
    IF  VALID-HANDLE(h-bogg00759) THEN DO:
        RUN destroy IN h-bogg00759.
        ASSIGN h-bogg00759 = ?.
    END.
    RETURN "OK":U.

END PROCEDURE. 
