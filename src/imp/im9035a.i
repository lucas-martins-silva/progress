/********************************************************************************
**
**  IM9035A.I - C lculo despesas Importacao x Compras (CC0406/CC0407)
**
*********************************************************************************/

{cdp/cdcfgmat.i} /* Include preprocessadores */
{cdp/cd4300.i3}  /* Include tratamento atributo livre */
{ccp/cc9019.i50} /* Include tratamento atributo livre cotacao-item.char-1 */
{imp/im9035a1.i} /* Defini‡äes de temp-table, labels e forms */

PROCEDURE pi-calcula-despesas:
/*------------------------------------------------------------------------------------------------------------------------------------------------------------**
**  Purpose:    Calcular despesas                                                                                                                             **
**  Parameters: Input  - p-num-pedido  : N£mero do pedido de compra                                                                                           **
**              Input  - p-numero-ordem: N£mero da ordem de compra                                                                                            **
**              Input  - p-parcela     : N£mero da parcela de compra                                                                                          **
**              Input  - p-mo-codigo   : C¢digo da moeda                                                                                                      **
**              Input  - p-despesas-pag:                                                                                           **
**              Input  - p-despesas-inc:                                                                                           **
**              Output - p-val-desp    : Valor da despesa                                                                                                     **
**  Notes:                                                                                                                                                    **
--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-pedido   LIKE pedido-compr.num-pedido    NO-UNDO.
    DEF INPUT  PARAM p-numero-ordem LIKE ordem-compra.numero-ordem  NO-UNDO.
    DEF INPUT  PARAM p-parcela      LIKE prazo-compra.parcela       NO-UNDO.
    DEF INPUT  PARAM p-mo-codigo    LIKE moeda.mo-codigo            NO-UNDO.
    DEF INPUT  PARAM p-despesas-pag AS INTEGER                      NO-UNDO. 
    DEF INPUT  PARAM p-despesas-inc AS LOGICAL                      NO-UNDO.
    DEF OUTPUT PARAM p-val-desp     LIKE cotacao-item-cex.val-desp  NO-UNDO.

    DEF VAR de-val-desp     LIKE cotacao-item-cex.val-desp NO-UNDO.
    DEF VAR de-quantidade   LIKE prazo-compra.quantidade   NO-UNDO.

    EMPTY TEMP-TABLE tt-desp.

    FOR EACH ordem-compra NO-LOCK
        WHERE ordem-compra.num-pedido = p-num-pedido:

        ASSIGN de-quantidade = 0.

        IF  p-numero-ordem <> ? 
        AND p-numero-ordem <> ordem-compra.numero-ordem THEN
            NEXT.

        FOR EACH prazo-compra no-lock
            WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:
            
            IF  p-parcela <> ? 
            AND p-parcela <> prazo-compra.parcela THEN 
                NEXT.
            
            ASSIGN de-quantidade = de-quantidade + prazo-compra.quantidade.            
        END.

        &IF DEFINED(bf-mat-comex) &THEN
        FOR EACH cotacao-item FIELDS (cot-aprovada char-1 data-cotacao)
        &ELSE
        FOR EACH cotacao-item FIELDS (cot-aprovada char-1 seq-cotac)
        &ENDIF  
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
              AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
              AND cotacao-item.data-cotacao = ordem-compra.data-cotacao NO-LOCK:
            
            IF cotacao-item.cot-aprovada THEN DO:
                
                {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                {ccp/cc9019.i51 "yes"}
                
                FOR EACH cotacao-item-cex NO-LOCK
                    WHERE cotacao-item-cex.numero-ordem = ordem-compra.numero-ordem
                      AND cotacao-item-cex.cod-emitente = ordem-compra.cod-emitente
                      AND cotacao-item-cex.it-codigo    = ordem-compra.it-codigo
                      &IF DEFINED(bf-mat-comex) &THEN
                      &ELSE
                      AND cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
                      &ENDIF
                      AND cotacao-item-cex.data-cotacao = ordem-compra.data-cotacao
                      AND cotacao-item-cex.mapa-cotacao = i-mapa-cotacao-i50
                      AND cotacao-item-cex.cod-incoterm = c-cod-incoterm-i50:
                    
                    /* 1 - Pagas ao fornecedor. **
                    ** 2 - Todas as despesas.   */
                    IF  p-despesas-pag = 1 
                    AND ordem-compra.cod-emitente <> cotacao-item-cex.cod-emitente-desp THEN 
                        NEXT.

                    FIND FIRST tt-desp 
                        WHERE tt-desp.cod-desp = cotacao-item-cex.cod-desp NO-ERROR.
                    IF NOT AVAIL tt-desp THEN DO:                    
                        CREATE tt-desp.
                        ASSIGN tt-desp.cod-desp = cotacao-item-cex.cod-desp.
                        
                        FIND FIRST desp-imp NO-LOCK
                            WHERE desp-imp.cod-desp = tt-desp.cod-desp NO-ERROR.
                        IF AVAIL desp-imp THEN
                            ASSIGN tt-desp.descricao = desp-imp.descricao.
                    END.
                    
                    RUN cdp/cd0812.p (INPUT cotacao-item-cex.mo-codigo,
                                      INPUT p-mo-codigo,
                                      INPUT cotacao-item-cex.val-desp,
                                      INPUT TODAY,
                                      OUTPUT de-val-desp).

                    IF de-val-desp = 0 
                    OR de-val-desp = ? THEN
                        ASSIGN de-val-desp = cotacao-item-cex.val-desp.

                    ASSIGN tt-desp.val-desp = tt-desp.val-desp + (de-val-desp * de-quantidade)
                           p-val-desp       = p-val-desp + (de-val-desp * de-quantidade).
                END.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-retorna-despesa:
/*------------------------------------------------------------------------------------------------------------------------------------------------------------**
**  Purpose:    Retorna a temp-table tt-desp para o programa chamador.                                                                                        **                                        **
**  Parameters: Output - tt-desp    : Temp-table de despesas                                                                                                  **
**  Notes:                                                                                                                                                    **
--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM TABLE FOR tt-desp.

    RETURN "OK":U.
        
END PROCEDURE.


PROCEDURE pi-imprime-despesa:
/*------------------------------------------------------------------------------------------------------------------------------------------------------------**
**  Purpose:    Permite imprimir a tt-desp da mesma forma que o im9035.                                                                                       **                                        **
**  Parameters:                                                                                                                                               **
**  Notes:                                                                                                                                                    **
--------------------------------------------------------------------------------------------------------------------------------------------------------------*/    
    IF CAN-FIND(FIRST tt-desp) THEN DO:
        PUT c-lb-despesas-imp AT 5 ":" SKIP.
        DISP c-lb-cod-desp
             c-lb-descricao
             c-lb-val-desp
            WITH FRAME f-despesas-cab.
    END.
    FOR EACH tt-desp:
        DISP tt-desp.cod-desp
             tt-desp.descricao
             tt-desp.val-desp
            WITH FRAME f-despesas.
        DOWN WITH FRAME f-despesas.
    END.

    RETURN "OK":U.

END PROCEDURE.
