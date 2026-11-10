/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGRE0701C 2.00.00.004 } /*** 010004 ***/


/*************************************************************************
**    Programa.:  GGRE0701c.p
**    Objetivo.:  Consulta Pesagem~\Classifica‡Æo
**    Data.....:  Setembro/2003
*************************************************************************/
DEFINE NEW GLOBAL SHARED VAR p-row-table2        AS ROWID          NO-UNDO.

RUN agro-upc/ggre0701b.w (INPUT p-row-table2). 
