/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMAPI001A 2.00.00.012}  /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IMAPI001A MUT}
&ENDIF

/*****************************************************************************
**
**  IMAPI001A.P - API do m¢dulo de Importacao
**
**  Objetivo: Criacao automatica das despesas para a cotacao do item das
**            despesas com tipo 8 - Formula 
** 
******************************************************************************/

{imp/imapi001a.i1} /* C¢digo Fonte IMAPI001A */

