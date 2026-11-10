/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9041 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9041 MIM}
&ENDIF

/*
** Calcula tributacao do Imposto de Importacao
**
** 1 - Tributado
** 2 - Isento
*/
DEF INPUT PARAMETER i-trib-ii-item AS INTEGER NO-UNDO.
DEF INPUT PARAMETER i-trib-ii-nat  AS INTEGER NO-UNDO.
DEF OUTPUT PARAMETER i-trib-ii     AS INTEGER NO-UNDO.

IF i-trib-ii-nat = 2 THEN 
    ASSIGN i-trib-ii = 2. 
ELSE
    ASSIGN i-trib-ii = i-trib-ii-item.

IF i-trib-ii <> 1 AND 
   i-trib-ii <> 2 THEN
    ASSIGN i-trib-ii = 1.

/* IM9041 */

