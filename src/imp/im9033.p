/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9033 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9033 MIM}
&ENDIF

/*******************************************************************************
**
** IM9033.P - Aprovacao Mapa Cotacao - Alteracao Pedidos/Ordens
**
*******************************************************************************/

/*
**
** Quando for executado pelo CC0308 - Alteracao Pedidos/Ordens, 
** o programa deixa aprovar um mapa para uma cotacao j  aprovada
**
*/

{imp/im9033.i}      /** C¢digo Fonte da im9033 **/



