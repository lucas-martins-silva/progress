/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9032 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9032 MIM}
&ENDIF

/*
**
** IM9032.P - Integracao Importacao para calculo IPI/ICMS
**            Retorna o valor das despesas de importacao incidente no valor do IPI e valor do ICMS
**
*/

{imp/im9032.i1} /* include contendo fonte para nao duplicacao em ambiente magnus */

/* IM9032.P */
