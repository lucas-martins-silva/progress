/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT0904C 2.00.00.005 } /*** 010005 ***/


/*************************************************************************
**    Programa.:  GGft0904c
**    Objetivo.:  Solicitar Bot∆o Consulta de Pesagem~\Classificaá∆o
**    Data.....:  Setenbro/2003
*************************************************************************/

DEFINE NEW GLOBAL SHARED VAR p-row-table2-ft0904 AS ROWID          NO-UNDO.

if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 

RUN agro-upc/ggft0904b.w (INPUT p-row-table2-ft0904 ) .
