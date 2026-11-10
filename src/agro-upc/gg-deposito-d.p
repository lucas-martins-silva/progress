/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-DEPOSITO-D 2.00.00.003 } /*** 010003 ***/


/***********************************************************************
**  Programa...: agro-upc/gg-deposito-d.p
**  Descricao..: Upc utilizada na Exclus∆o da tabela deposito
**  data.......: Agosto/2003
************************************************************************/
define param buffer b-deposito     for deposito.


FIND FIRST gg-ext-deposito exclusive-lock
     where gg-ext-deposito.cod-depos = b-deposito.cod-depos NO-ERROR.
IF AVAIL gg-ext-deposito THEN
     delete gg-ext-deposito.


return "OK"              
/*****************************************************************************/                  

