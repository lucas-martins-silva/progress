/******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9037 2.00.00.003} /*** "010003" 13/12/2024 17:02:43 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im9037 MIM}
&ENDIF


/*******************************************************************************
**   Programa: IM9037.p
**   Objetivo: Integra‡Æo entre os m¢dulos de Importa‡Æo e Recebimento.
**             Altera o n£mero da nota fiscal nas tabelas do Importa‡Æo. 
****************************************************************************/

{imp/im9037.i}  /** C¢digo Fonte da im9037 **/
