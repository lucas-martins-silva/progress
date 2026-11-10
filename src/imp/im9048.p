/*******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9048 2.00.00.039 } /*** "010039" 09/07/2026 16:01:59 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im9048 MIM}
&ENDIF

/*** 010000 ****/
/* 
**
** IM9048.P - Integracao Importacao para calculo PIS/COFINS (cd4337)
**            Tratamento das informa‡äes para o c lculo do PIS/COFINS
**
*/

{imp/im9048.i1} /* include contendo fonte para nao duplicacao em ambiente magnus */




/* IM9048.P */
