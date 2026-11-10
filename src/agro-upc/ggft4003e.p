/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT4003E 2.00.00.005 } /*** 010005 ***/



/*************************************************************************
**    Programa.:  GGFT4003e
**    Objetivo.:  UPC Classifica‡Æo
**    Data.....:  Agosto/2003
*************************************************************************/
DEFINE NEW GLOBAL SHARED VAR p-row-table2      as rowid no-undo.

if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 

run agro-upc/ggft4003f.w (INPUT "wt-docto":U,
                          INPUT YES,
                          INPUT p-row-table2) .
