/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-COMP-EXAME-D 2.00.00.003 } /*** 010003 ***/



/***********************************************************************
**  Programa...: agro-upc/gg-comp-exame-d.p
**  Descricao..: Upc utilizada na Exclus∆o da tabela comp-exame
**  data.......: Agosto/2003
************************************************************************/
define param buffer b-comp-exame for comp-exame.


FIND FIRST gg-ext-comp-exame exclusive-lock
     where gg-ext-comp-exame.cod-exame = b-comp-exame.cod-exame 
       AND gg-ext-comp-exame.cod-comp = b-comp-exame.cod-comp NO-ERROR.
IF AVAIL gg-ext-comp-exame THEN
     delete gg-ext-comp-exame.


return "OK"              
/*****************************************************************************/                  

