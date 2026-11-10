/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9020 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9020 MIM}
&ENDIF


/********************************************************************************
** 
** im9020.p - eliminacao das despesas adicionais de importacao da cotacao do item
**
** Ultima alteracao: 06/09/1999 - bre18074
** 
********************************************************************************/

{imp/im9020.i} /* C¢digo fonte im9020.p */
