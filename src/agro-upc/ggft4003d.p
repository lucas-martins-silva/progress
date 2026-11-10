/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT4003D 2.00.00.005 } /*** 010005 ***/


/*************************************************************************
**    Programa.:  GGFT4003d
**    Objetivo.:  UPC para Rodar o GGFT4003c.w
**    Data.....:  Agosto/2003
*************************************************************************/
DEF NEW GLOBAL SHARED VAR wh-btpeso-ft4003b          AS WIDGET-HANDLE NO-UNDO.

DEF INPUT PARAM wh-wt-docto AS ROWID.
/********/

if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 

run agro-upc/ggft4003c.w ( INPUT wh-wt-docto) .


