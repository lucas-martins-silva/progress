/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9029 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9029 MIM}
&ENDIF

/********************************************************************************
** 
** IM9029.P - Valor Despesas + Valor Material
**
** Objetivo : Respons vel pelas integra‡äes do m¢dulo de importa‡Æo
**             Adiciona o valor das despesas de importa‡Æo ao valor do material
********************************************************************************/

{imp/im9029.i} /* C¢digo Fonte IM9029 */
