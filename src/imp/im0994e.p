/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0994E 2.00.00.002 } /*** "010002" 21/03/2025 09:24:36  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0994e MIM}
&ENDIF



DEF INPUT  PARAM pRowID             AS ROWID NO-UNDO.
DEF INPUT  PARAM pMoCodigo        LIKE docum-est.mo-codigo         NO-UNDO.
DEF OUTPUT PARAM pPrecoTotal      LIKE item-doc-est.preco-total[1] NO-UNDO.
DEF OUTPUT PARAM pPrecoTotalLocal LIKE item-doc-est.preco-total[1] NO-UNDO.

DEF BUFFER b-item-doc-est-cex FOR item-doc-est-cex.

FIND FIRST item-doc-est NO-LOCK
     WHERE ROWID(item-doc-est) = pRowID NO-ERROR.

FOR EACH  item-doc-est-cex NO-LOCK
    WHERE item-doc-est-cex.serie-docto        = item-doc-est.serie-docto
      AND item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
      AND item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
      AND item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
      AND item-doc-est-cex.sequencia    = item-doc-est.sequencia:
    
    FIND FIRST b-item-doc-est-cex NO-LOCK
         WHERE b-item-doc-est-cex.cod-emitente = item-doc-est.fornec-comp
           AND b-item-doc-est-cex.serie-docto  = item-doc-est.serie-comp
           AND b-item-doc-est-cex.nro-docto    = item-doc-est.nro-comp
           AND b-item-doc-est-cex.nat-operacao = item-doc-est.nat-comp
           AND b-item-doc-est-cex.sequencia    = item-doc-est.seq-comp
           AND b-item-doc-est-cex.cod-desp     = item-doc-est-cex.cod-desp NO-ERROR.
    IF  AVAIL b-item-doc-est-cex THEN
        ASSIGN pPrecoTotal = pPrecoTotal + b-item-doc-est-cex.val-desp.
END.

IF  pPrecoTotal <> 0 THEN
    RUN cdp/cd0812.p (INPUT  pMoCodigo,
                      INPUT  0,
                      INPUT  pPrecoTotal,
                      INPUT  TODAY,
                      OUTPUT pPrecoTotalLocal).

RETURN "OK".
