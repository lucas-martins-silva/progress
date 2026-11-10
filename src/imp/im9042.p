/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9042 2.00.00.003} /*** "010003" 09/07/2026 16:01:59  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9042 MIM}
&ENDIF


/*
** Aliquota do Imposto de Importacao
*/
DEF INPUT  PARAMETER p-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
DEF OUTPUT PARAMETER p-aliq-ii      AS DECIMAL FORMAT ">>9.9999" NO-UNDO.

{cdp/cdcfgmat.i} /* include pre-processadores */

{cdp/cd4300.i3}
{ccp/cc9019.i50}

FOR FIRST cotacao-item FIELDS (char-1)
    WHERE cotacao-item.numero-ordem = p-numero-ordem
       AND cotacao-item.cot-aprovada NO-LOCK:

    RUN pi-retorna-aliquota-ii(INPUT ROWID(cotacao-item),
                               OUTPUT p-aliq-ii).
END.


PROCEDURE pi-retorna-aliquota-ii:

    DEF INPUT  PARAM pr-rowid-cotacao AS ROWID.
    DEF OUTPUT PARAM p-aliq-ii AS DEC FORMAT ">>9.9999".

    FOR FIRST cotacao-item
        WHERE ROWID(cotacao-item) = pr-rowid-cotacao NO-LOCK:
    
        &if defined(bf-mat-comex) &then
            assign p-aliq-ii = decimal(trim(substring(cotacao-item.char-1,17,6))).
        &else
            {cdp/cd4300.i4 "yes" cotacao-item.char-1}
            {ccp/cc9019.i51 "yes"}
            ASSIGN p-aliq-ii = de-aliq-ii-i50.
        &endif
    
    END.

END PROCEDURE.

