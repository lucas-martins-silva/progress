/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-TIPO-TAX-D 2.00.00.003 } /*** 010003 ***/



/***********************************************************************
**  Programa...: agro-upc/gg-tipo-tax-d.p
**  Descricao..: Upc utilizada na Exclus∆o da tabela tipo-tax
**  data.......: Agosto/2003
************************************************************************/
define param buffer b-tipo-tax  for tipo-tax.


FIND FIRST gg-ext-tipo-tax EXCLUSIVE-LOCK
     WHERE gg-ext-tipo-tax.cod-tax = b-tipo-tax.cod-tax NO-ERROR.
IF AVAIL gg-ext-tipo-tax THEN
   DELETE gg-ext-tipo-tax.

FOR EACH gg-tipo-tax exclusive-lock
    where gg-tipo-tax.cod-tax = b-tipo-tax.cod-tax:
    delete gg-tipo-tax.
end.

return "OK"              
/*****************************************************************************/                  

