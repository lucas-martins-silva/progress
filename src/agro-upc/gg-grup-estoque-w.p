/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-GRUP-ESTOQUE-W 2.00.00.004 } /*** "010004" 29/05/2025 09:23:32  ***/


/***********************************************************************
**  Programa...: agro-upc/gg-grup-estoque-w
**  Descricao..: Upc utilizada na atualizar a tabela gg-Ext-grup-estoque
**  data.......: Agosto/2003
************************************************************************/
DEFINE PARAM BUFFER b-grupo-estoque     FOR grup-estoque.
DEFINE PARAM BUFFER b-old-grupo-estoque FOR grup-estoque.

FIND FIRST gg-Ext-grup-estoque EXCLUSIVE-LOCK
     WHERE gg-Ext-grup-estoque.ge-codigo   = b-grupo-estoque.ge-codigo NO-ERROR.
IF  NOT AVAIL gg-Ext-grup-estoque THEN DO:
    create gg-Ext-grup-estoque.
    ASSIGN gg-Ext-grup-estoque.ge-codigo = b-grupo-estoque.ge-codigo.
END.
  


