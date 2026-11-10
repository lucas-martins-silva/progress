/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-GRUP-ESTOQUE-D 2.00.00.003 } /*** 010003 ***/


/***********************************************************************
**  Programa...: agro-upc/gg-grup-estoque-d.p
**  Descricao..: Upc utilizada na Exclus∆o da tabela grup-estoque
**  data.......: Agosto/2003
************************************************************************/
define param buffer b-grup-estoque     for grup-estoque.

FIND FIRST gg-Ext-grup-estoque exclusive-lock
     where gg-Ext-grup-estoque.ge-codigo = b-grup-estoque.ge-codigo NO-ERROR.
IF  AVAIL gg-Ext-grup-estoque THEN
    delete gg-Ext-grup-estoque.

return "OK"              
/*****************************************************************************/                  

