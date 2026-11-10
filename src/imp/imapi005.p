/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMAPI005 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IMAPI005 MUT}
&ENDIF

/*******************************************************************************
**
** IMAPI005.P - API Importacao
**
** Objetivo: Atualiza‡Æo Item-doc-est-cex,
**           atualiza os relacionamentos do Item-doc-est-cex com Docum-est-cex,
**           Docum-est, Item-doc-est
**
*********************************************************************************/

{imp/imapi005.i} /* C¢digo Fonte IMAPI005 */

