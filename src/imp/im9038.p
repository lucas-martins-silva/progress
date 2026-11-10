/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9038 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9038 MIM}
&ENDIF

/*******************************************************************************
**   Programa: IM9038.p
**   Objetivo: Integra‡Æo entre os m¢dulos de Importa‡Æo e Recebimento.
**             Retorna a data de cota‡Æo do embarque. 
****************************************************************************/

{imp/im9038.i}  /** C¢digo Fonte da im9038 **/

