/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT4003BA 2.00.00.007 } /*** 010007 ***/



/****************************************************************************
 * Nome.....: ggap0501ba.p
 * Objetivo.: Programa para chamada de zoom da upc ggft4003b.p.
 * Data.....: Agosto/2003
 ***************************************************************************/

{utp/ut-glob.i}
DEFINE VARIABLE wh-pesquisa    AS WIDGET-HANDLE NO-UNDO.


DEF NEW GLOBAL SHARED VAR wh-cod-contrato-ft4003b   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v-wgh-object      AS HANDLE        NO-UNDO.

if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 

{include/zoomvar.i &prog-zoom    = ggp/gg1001-z01.w
                   &campohandle  = wh-cod-contrato-ft4003b
                   &campozoom    = cod-contrato
                   &proghandle   = v-wgh-object}

