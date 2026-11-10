/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9028 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9028 MIM}
&ENDIF

/*******************************************************************************
**
** IM9028.P - API Importacao
**
** Objetivo: Rateio do valor das despesas do documento (docum-est-cex) entre os
**           itens do documento(item-doc-est-cex)
**
********************************************************************************/

{imp/im9028.i} /* C¢digo Fonte IM9028 */

