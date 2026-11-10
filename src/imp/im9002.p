/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9002 2.00.00.008 } /*** "010008" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im9002 MIM}
&ENDIF
 
/*****************************************************************************
**
** IM9002 - Integra‡Æo entre Importa‡Æo e Recebimento (EMS)
**
** Objetivo: Eliminar as despesas de importa‡Æo relacionada a nota do 
**           recebimento e suas respectivas duplicatas.
**           
******************************************************************************/

{imp/im9002.i} /* C¢digo Fonte IM9002 */
    
