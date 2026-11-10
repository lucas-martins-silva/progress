/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCQ0107A 2.00.00.003 } /*** 010003 ***/


{utp/ut-glob.i}

DEFINE VARIABLE wh-pesquisa                       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-ex-melhoria      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE p-wgh-object    AS HANDLE        NO-UNDO.

{include/zoomvar.i &prog-zoom    = "inzoom/z01in114.w"
                   &campohandle  = wh-ex-melhoria
                   &campozoom    = cod-exame
                   &proghandle   = p-wgh-object}
                   

    
    

