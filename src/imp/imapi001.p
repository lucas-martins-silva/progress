/*******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMAPI001 2.00.00.015} /*** "010015" 04/11/2025 09:02:01 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IMAPI001 MUT}
&ENDIF

/*******************************************************************************
**
**  IMAPI001.P - Cria automaticamente despesas para o mapa de cotacao(cotacao-item-cex) de 
**               acordo com as despesas cadastradas para o item, itinerario e
**               incoterm
**
********************************************************************************/

{imp/imapi001.i1} /* C¢digo Fonte IMAPI001 */
