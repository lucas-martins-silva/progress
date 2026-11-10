/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-PARAM-RE-D 2.00.00.003 } /*** 010003 ***/


/***********************************************************************
**  Programa...: agro-upc/gg-param-re-d.p
**  Descricao..: Upc utilizada na Exclus∆o da tabela param-re
**  data.......: Agosto/2003
************************************************************************/
define param buffer b-param-re     for param-re.


FIND FIRST gg-ext-param-re exclusive-lock
     where gg-ext-param-re.usuario = b-param-re.usuario NO-ERROR.
IF AVAIL gg-ext-param-re THEN
     delete gg-ext-param-re.

return "OK"              
/*****************************************************************************/                  

