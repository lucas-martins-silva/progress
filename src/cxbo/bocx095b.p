/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX095B 2.00.00.010}  /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX095B MUT}
&ENDIF


/**********************************************************************************
**
** BOCX095B.P - Antiga CDAPI700A - tranformada para bocx095b.p para expedicao 
**              Magnus x EMS - Comercio Exterior, pois nao poderia haver nenhum
**              programa do tipo CDP que fosse exclusivo de Com‚rcio Exterior para
**              que nao fosse necessario filtrar os programas que serÆo expedidos 
**              pelo CDP
**            - Calculo despesas adicionais de importacao
**
**********************************************************************************/

{cxbo/bocx095b.i1}      /** C¢digo Fonte da BOCX095B **/

