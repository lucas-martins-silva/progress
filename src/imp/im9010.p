/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9010 2.00.00.004}  /*** "010004" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9010 MIM}
&ENDIF

/*****************************************************************************
**
** IM9010 - Integra‡Æo entre Importa‡Æo e Contas … Pagar 
**
** Objetivo: Concilia‡Æo dos valores das duplicatas de despesas.
**
******************************************************************************/

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */
{include/i-epc200.i im9010} /** Upc **/

{imp/im9010.i2}.





