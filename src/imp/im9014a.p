/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9014A 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9014A MIM}
&ENDIF


/***************************************************************************
**
**       Programa: IM9014a.P - Integração com RE0401 - Listagem Conferência de Documentos
**
**       Data....: Outubro de 2000
**
**       Objetivo: Retorna valor total das duplicatas e data de partida
**
****************************************************************************/

{imp/im9014a.i1}      /** C¢digo Fonte da im9014 **/
