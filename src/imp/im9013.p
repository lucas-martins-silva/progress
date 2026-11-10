/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9013 2.00.00.028 } /*** "010028" 13/10/2026 11:13:21 ***/
 
&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9013 MIM}
&ENDIF
 
/****************************************************************************
**
** IM9013 - Integra‡Æo entre Importa‡Æo e Recebimento (EMS)
**
** Objetivo: Achar total das duplicatas.
**
*****************************************************************************/

{imp/im9013.i}      /** C¢digo Fonte da im9013 **/
 


