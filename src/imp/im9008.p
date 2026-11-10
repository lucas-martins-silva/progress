/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9008 2.00.00.016}  /*** "010016" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9008 MIM}
&ENDIF

/*****************************************************************************
**
** IM9008 - Integra‡Æo entre os m¢dulos Caixa e Bancos e Importa‡Æo. (EMS)
**
** Objetivo: Gerar fluxo de caixa das despesas da importa‡Æo - fluxo gerencial.
**
******************************************************************************/

{cdp/cdcfgmat.i} /* Definicao Pre-Processador */

{cbp/cbapi001.i} /* defini‡Æo da temp-table tt-erro  */
{cdp/cd1204.i}   /* Defini‡Æo da temp-table tt-param */
{ccp/ccapi011.i} /* Defini‡Æo tt-movto-fluxo */
{imp/im9040.i} /*definicao tt-despesas-importacao */

def input  parameter rw-ordem-compra as rowid no-undo.
def input  parameter rw-prazo-compra as rowid no-undo.
def input  parameter table for tt-param.
def output parameter table for tt-erro.

run pi-fluxo-caixa-imp-im9040-im9008 (input "").

{imp/im9008.i}      /** C¢digo Fonte da im9008 **/


