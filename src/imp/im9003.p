/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9003 2.00.00.007} /*** "010007" 10/03/2026 13:21:52  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9003 MIM}
&ENDIF

/*****************************************************************************
**
** IM9003 - Integra‡Æo entre Importa‡Æo e Obriga‡äes Fiscais (EMS)
**
** Objetivo: Ajustar valores em OF conforme uma nota de Importa‡Æo
**           
******************************************************************************/

{imp/im9003.i} /* utilizada pelos produtos Magnus e EMS */

/* fim do programa */

