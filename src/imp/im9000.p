/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9000 2.00.00.006} /*** "010006" 10/03/2026 13:21:51  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9000 MIM}
&ENDIF

/*****************************************************************************
**
** IM9000 - Integra‡Æo entre Importa‡Æo e Recebimento (EMS)
**
** Objetivo: Valor do ICMS no total do nota.
**
******************************************************************************/

{imp/im9000.i}      /** C¢digo Fonte da im9000 **/ 
