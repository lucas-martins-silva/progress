/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCD0401B-Z01 2.00.00.004 } /*** 010004 ***/


/****************************************************************************
 * Nome.....: ggcd0401b-z01
 * Objetivo.: Programa para chamada de zoom da upc ggcd0401b.
 * Data.....: Novembro/2006
 ***************************************************************************/

{utp/ut-glob.i}
DEFINE VARIABLE wh-pesquisa    AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-estado-cd0401b    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v-wgh-object         AS HANDLE        NO-UNDO.

   {include/zoomvar.i &prog-zoom   = "unzoom/z01un007.w"
                      &campohandle = wh-estado-cd0401b
                      &campozoom   = estado
                      &proghandle  = v-wgh-object}  





