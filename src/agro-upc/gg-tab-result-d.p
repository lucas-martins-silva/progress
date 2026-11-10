/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-TAB-RESULT-D 2.00.00.003 } /*** 010003 ***/


/***********************************************************************
**  Programa...: agro-upc/gg-tab-result-d.p
**  Descricao..: Upc utilizada na Exclus∆o da tabela tab-result
**  data.......: Agosto/2003
************************************************************************/
define param buffer b-tab-result     for tab-result.


FIND FIRST gg-ext-tab-result exclusive-lock
     where gg-ext-tab-result.nr-tabela = b-tab-result.nr-tabela NO-ERROR.
IF AVAIL gg-ext-tab-result THEN
     delete gg-ext-tab-result.


return "OK"              
/*****************************************************************************/                  

