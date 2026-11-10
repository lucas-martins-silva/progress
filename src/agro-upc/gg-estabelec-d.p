/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-ESTABELEC-D 2.00.00.004 } /*** 010004 ***/


/***********************************************************************
**  Programa...: agro-upc/gg-estabelec-d.p
**  Descricao..: Upc utilizada na Exclus’o da tabela estabelec
**  data.......: Agosto/2003
************************************************************************/
define param buffer b-estabelec     for estabelec.


FIND FIRST gg-ext-estabelec exclusive-lock
     where gg-ext-estabelec.cod-estabel = b-estabelec.cod-estabel NO-ERROR.
IF AVAIL gg-ext-estabelec THEN
     delete gg-ext-estabelec.

return "OK"              
/*****************************************************************************/                  




