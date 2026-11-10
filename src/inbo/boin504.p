/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN504 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN504 MUT}
&ENDIF

/*
**  BOIN536.P
**
**  rep-oper-ctrab - Reporte Opera‡Æo
**
**  Ultima altera‡Æo : 28/07/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY ind-vis-man
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME ind-vis-man

{include/boini.i}
 
{inbo/boin504.i RowObject}


{inbo/boin504.i1}
{inbo/boin504.i2} 
