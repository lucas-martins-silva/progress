/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9023 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9023 MIM}
&ENDIF

/*********************************************************************************
**
**   IM9023.P - Integracao Importacao Compras
**
**   Objetivo: Impress∆o das Despesas de Importaá∆o (Mapa Comparativo de Precos). 
**
*********************************************************************************/

{imp/im9023.i}      /** C¢digo Fonte da im9023 **/

