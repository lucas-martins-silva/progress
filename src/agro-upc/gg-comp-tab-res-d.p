/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-COMP-TAB-RES-D 2.00.00.003 } /*** 010003 ***/

/***********************************************************************
**  Programa...: agro-upc/gg-comp-tab-res-d.p
**  Descricao..: Upc utilizada na Exclus∆o da tabela comp-tab-res
**  data.......: Agosto/2003
************************************************************************/
define param buffer b-comp-tab-res     for comp-tab-res.

FIND FIRST gg-ext-comp-tab-res exclusive-lock
     where gg-ext-comp-tab-res.nr-tabela = b-comp-tab-res.nr-tabela
      AND  gg-ext-comp-tab-res.seq-comp  = b-comp-tab-res.seq-comp NO-ERROR.
IF AVAIL gg-ext-comp-tab-res THEN
     delete gg-ext-comp-tab-res.

return "OK".              
/*****************************************************************************/                  

