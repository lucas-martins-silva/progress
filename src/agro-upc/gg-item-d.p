/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-ITEM-D 2.00.00.003 } /*** 010003 ***/

/***********************************************************************
**  Programa.: gg-item-d.p
**  Descricao: UPC - item - Delete
**  Vers∆o...: 2.04.00.001
**  Objetivo.: Valida relacionamento do item
**             Elimina a tabela de extens∆o (gg-ext-item).
************************************************************************/
def param buffer b-item for ITEM.


/**Elimina a tabela gg-ext-item extená∆o **/
FIND FIRST gg-ext-item 
    WHERE gg-ext-item.it-codigo = b-item.it-codigo EXCLUSIVE-LOCK NO-ERROR.
IF AVAIL gg-ext-item THEN DO:
   
   DELETE gg-ext-item.
END.
   
