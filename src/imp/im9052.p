/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9052 2.00.00.002}  /*** 010002 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9052 MIM}
&ENDIF

DEFINE INPUT  PARAMETER pc-table AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pr-table AS ROWID      NO-UNDO.

{cdp/cd4300.i3}  /* include tratamento atributo livre */
{cxbo/bocx250.i50} /* include tratamento atributo livre */
{cxbo/bocx085.i tt-cotacao-item-cex}
{imp/imapi006.i}

DEF BUFFER bfcotacao-item     FOR cotacao-item.

DEF VAR h-bocx085        AS HANDLE              NO-UNDO.
DEF VAR de-valor-despesa LIKE desp-imp.val-desp NO-UNDO.

IF  pc-table = "cotacao-item":U THEN DO:

    FIND bfcotacao-item WHERE 
         ROWID(bfcotacao-item) = pr-table NO-LOCK NO-ERROR.

    FIND ordem-compra WHERE 
         ordem-compra.numero-ordem = bfcotacao-item.numero-ordem NO-LOCK NO-ERROR.

    IF  AVAIL ordem-compra THEN DO:
        FIND FIRST param-imp 
             WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

        /*--- le as despesas da cotacao ---*/
        IF  AVAIL param-imp THEN DO:

            {cdp/cd4300.i4 "yes" param-imp.char-1}

            /*--- busca despesa de importacao ---*/
            {cxbo/bocx250.i51 "yes"}

            RUN cxbo/bocx085.p PERSISTENT SET h-bocx085.

            FOR EACH  cotacao-item-cex
                WHERE cotacao-item-cex.numero-ordem = bfcotacao-item.numero-ordem
                  AND cotacao-item-cex.cod-emitente = bfcotacao-item.cod-emitente
                  AND cotacao-item-cex.it-codigo    = bfcotacao-item.it-codigo
                  AND cotacao-item-cex.seq-cotac    = bfcotacao-item.seq-cotac
                  AND cotacao-item-cex.data-cotacao = bfcotacao-item.data-cotacao EXCLUSIVE-LOCK:

                  FOR FIRST desp-imp FIELDS (tipo cod-desp)
                      WHERE desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK: END.
                      IF  NOT AVAIL desp-imp THEN
                          NEXT.

                  IF  desp-imp.tipo = 7 /* Adicional sobre valor */
                  OR  desp-imp.cod-desp = i-desp-ii-i50                     /* Despesa p/ o II */ 
                  OR  desp-imp.cod-desp = param-imp.cdn-despes-impto-pis    /* Despesa p/ o PIS */    
                  OR  desp-imp.cod-desp = param-imp.cdn-despes-impto-cofins /* Despesa p/ o COFINS */ 
                  OR  desp-imp.cod-desp = param-imp.cdn-despes-impto-ipi    /* Despesa p/ o IPI */ 
                  OR  desp-imp.cod-desp = param-imp.cdn-despes-impto-icms   /* Despesa p/ o ICMS */ THEN DO:   

                      /* Recalcula o valor da despesa caso o mapa e a cotacao         **
                      ** estiverem aprovados, do contrario marca para ser recalculada */
                      run imp/imapi006.p(input "cotacao-item-cex-boin082i":U,  
                                         input rowid(cotacao-item-cex),
                                         input cotacao-item-cex.cod-desp,
                                         input 0,
                                         input table tt-cotacao-item-cex,
                                         input-output table tt-desp-ja-recalc).

                  END.
            END.                          
        END.

        DELETE PROCEDURE h-bocx085 NO-ERROR.
        ASSIGN h-bocx085 = ?.

    END.
END.

