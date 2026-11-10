/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9018 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9018 MIM}
&ENDIF

/********************************************************************************
**
** IM9018.P
**
** Objetivo  : Respons vel pelas integra‡äes do m¢dulo de importa‡Æo
**             verifica se a cotacao requisitada para a aprova‡Æo possui um mapa
**             de despesas de importa‡Æo cadastrado ou informado.                  
********************************************************************************/       

{imp/im9018.i} /* C¢digo Fonte IM9018 */

/* IM9018.P */

