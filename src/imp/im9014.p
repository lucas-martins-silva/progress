/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao 
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9014 2.00.00.045 } /*** "010045" 16/09/2025 16:13:58 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im9014 MIM}
&ENDIF


/***************************************************************************
**
**       Programa: IM9014.P - Integração com RE0401 - Listagem Conferência de Documentos
**
**       Data....: Maio de 1999
**
**       Objetivo: Imprime as informa‡äes referente a importa‡Æo
**                 Docum-est-cex
**                 Item-doc-est-cex
**                 Dupli-apagar-cex
**
****************************************************************************/

{imp/im9014.i1}      /** C¢digo Fonte da im9014 **/

