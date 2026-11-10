/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-ITEM-DOC-EST-D 2.00.00.005 } /*** 010005 ***/



/********************************************************************** 
** Programa: gg-item-doc-est-d.p 
** Autor...: Andr‚ Gunther 06/2007
***********************************************************************/

DEFINE PARAM BUFFER b-item-doc-est FOR item-doc-est.

FOR EACH gg-ext-item-doc-est OF b-item-doc-est EXCLUSIVE-LOCK:
    DELETE gg-ext-item-doc-est.
END.


/*fim*/
