/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9045 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9045 MIM}
&ENDIF

/*****************************************************************************
**
**       PROGRAMA: IM9045
**
**       AUTOR...: DATASUL S.A.
**
**       OBJETIVO: PROCESSO DE IMPORTAÄ«O
**
******************************************************************************/
/* Include com as definiá‰es de prÇ-processadores                       */
{cdp/cdcfgmat.i}
    
/* In°cio do subprograa chamado pelo CC0311RP.P (Nome par esse programa: IM9045.P) */
{method/dbotterr.i} /* Definiá∆o da temp-table RowErrors */

/* Temp-table necess†ria para criaá∆o dos registro de processo de importaá∆o */
DEF TEMP-TABLE tt-processo-imp NO-UNDO LIKE mgcex.processo-imp
    FIELD r-rowid AS ROWID.

/* Definiá∆o de parÉmetros */
DEF INPUT  PARAM p-i-num-pedido   LIKE pedido-compr.num-pedido NO-UNDO.
DEF INPUT  PARAM p-r-ordem-compra AS ROWID                     NO-UNDO.
DEF OUTPUT PARAM TABLE            FOR RowErrors.
DEF OUTPUT PARAM TABLE            FOR tt-processo-imp.

/* Vari†veis gerais */
DEF VAR h-bocx140    AS HANDLE  NO-UNDO.
DEF VAR i-aux        AS INT     NO-UNDO.
DEF VAR r-rowid      AS ROWID   NO-UNDO.
DEF VAR l-ok         AS LOG     NO-UNDO.
DEF VAR i-cod-itiner AS INTEGER NO-UNDO.
{cdp/cd4300.i3}
{ccp/cc9019.i50}

/* Para o pedido de compra gerado, dever† ser criado o processo de importaá∆o (nas condiá‰es abaixo) */
FOR FIRST pedido-compr NO-LOCK WHERE
          pedido-compr.num-pedido = p-i-num-pedido:
    /* Verificar se todas as cotaá‰es aprovadas do item possuem incoterm informada */
    ASSIGN l-ok = YES.
    FOR FIRST ordem-compra NO-LOCK WHERE
        ROWID(ordem-compra) = p-r-ordem-compra,
        EACH cotacao-item NO-LOCK WHERE
             cotacao-item.numero-ordem = ordem-compra.numero-ordem AND
             cotacao-item.cot-aprovada:
        /* Se uma das cotaá‰es aprovadas n∆o tiver Incoterm, n∆o pode continuar */
        IF SUBSTR(cotacao-item.char-1,21,20) = "":U THEN DO:
            ASSIGN l-ok = NO.
            LEAVE.
        END.
        ASSIGN i-cod-itiner = cotacao-item.int-1.
        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
        {ccp/cc9019.i51 "yes"}
    END.
    /* Se possui Incoterm, significa que est† ok para gerar o processo de importaá∆o */
    IF l-ok THEN DO:
        /* Inicializa a BO de processo de importaá∆o */
        IF NOT VALID-HANDLE(h-bocx140) THEN
            RUN cxbo/bocx140.p PERSISTENT SET h-bocx140.
        /* Apenas abre a query principal */
        IF VALID-HANDLE(h-bocx140) THEN DO:
            RUN openQuery              IN  h-bocx140 (INPUT 1).
            /* Verifica se j† n∆o existe outro processo com esse pedido de compra */
            RUN verificaPedidoprocesso IN  h-bocx140 (INPUT  pedido-compr.num-pedido, 
                                                      OUTPUT i-aux, 
                                                      OUTPUT r-rowid).
        END.
        /* Zero significa que n∆o existem processos de importaá∆o para esse pedido de compra */
        IF  i-aux = 0 THEN DO:
            /* Localiza o emitente internacional */
            FOR FIRST emitente-cex NO-LOCK WHERE
                      emitente-cex.cod-emitente = pedido-compr.cod-emitente:
            END.
            /* Cria os dados com defaults na tabela tempor†ria de processo de importaá∆o */
            CREATE tt-processo-imp.
            ASSIGN tt-processo-imp.cod-estabel       = pedido-compr.end-entrega
                   tt-processo-imp.cod-exportador    = pedido-compr.cod-emitente
                   tt-processo-imp.cod-fabricante    = pedido-compr.cod-emitente
                   tt-processo-imp.cod-idioma        = IF AVAIL emitente-cex THEN emitente-cex.cod-idioma ELSE ""
                   tt-processo-imp.cod-incoterm      = IF AVAIL emitente-cex AND emitente-cex.cod-incoterm-imp <> "" THEN emitente-cex.cod-incoterm-imp ELSE TRIM(c-cod-incoterm-i50)
                   tt-processo-imp.cod-itiner        = IF AVAIL emitente-cex AND emitente-cex.cod-itiner-imp <> 0 THEN emitente-cex.cod-itiner-imp ELSE i-cod-itiner
                   tt-processo-imp.cod-transportador = pedido-compr.cod-transp
                   tt-processo-imp.dt-emissao        = pedido-compr.data-pedido
                   tt-processo-imp.estab-fisc        = pedido-compr.end-entrega
                   tt-processo-imp.nr-proc-imp       = STRING(pedido-compr.num-pedido)
                   tt-processo-imp.num-pedido        = pedido-compr.num-pedido
                   tt-processo-imp.situacao          = 1 /* N∆o Embarcado */
                   tt-processo-imp.via-transp        = pedido-compr.via-transp.

            &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
                  ASSIGN tt-processo-imp.cdn-corretor-cambio-import = IF AVAIL emitente-cex THEN emitente-cex.cdn-corretor-cambio-import ELSE 0
                         tt-processo-imp.cdn-despa-exter-import     = IF AVAIL emitente-cex THEN emitente-cex.cdn-despa-exter-import     ELSE 0
                         tt-processo-imp.cdn-segurad-import         = IF AVAIL emitente-cex THEN emitente-cex.cdn-segurad-import         ELSE 0
                         tt-processo-imp.cdn-corretor-import        = IF AVAIL emitente-cex THEN emitente-cex.cdn-corretor-import        ELSE 0.
            &ENDIF
            /* Efetua as validaá‰es e cria o registro */
            RUN validateCreate IN h-bocx140 (INPUT  TABLE tt-processo-imp,
                                             OUTPUT TABLE RowErrors,
                                             OUTPUT r-rowid).
            /* Elimina o BO de importaá∆o da mem¢ria */
            IF VALID-HANDLE(h-bocx140) THEN DO:
                DELETE PROCEDURE h-bocx140 NO-ERROR.
                ASSIGN h-bocx140 = ?.
            END.
        END.
        ELSE DO:
            /* Mensagem de processo j† existe com esse numero de pedido de compra */
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Processo_j†_existe_com_esse_numero_de_pedido_de_compra" *}
            RUN utp/ut-msgs.p(INPUT "msg":U,
                              INPUT 17006,
                              INPUT RETURN-VALUE + ".").
            CREATE RowErrors.
            ASSIGN RowErrors.ErrorSequence    =  p-i-num-pedido
                   RowErrors.ErrorDescription =  RETURN-VALUE
                   RowErrors.ErrorNumber      =  17006
                   RowErrors.ErrorParameters  = "ERROR".
        END.
    END.
    ELSE DO:
        /* Mensagem de existir cotaá∆o aprovada sem c¢digo de incoterm */
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Existe_cotaá∆o_aprovada_sem_c¢digo_de_incoterm" *}
        RUN utp/ut-msgs.p(INPUT "msg":U,
                          INPUT 17006,
                          INPUT RETURN-VALUE + ".").
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    =  p-i-num-pedido
               RowErrors.ErrorDescription =  RETURN-VALUE
               RowErrors.ErrorNumber      =  17006
               RowErrors.ErrorParameters  = "ERROR".
    END.
END.
