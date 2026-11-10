/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX095A 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX095A MUT}
&ENDIF


/**********************************************************************************
**
** BOCX095A.P - Antiga CDAPI700 - tranformada para bocx095a.p para expedicao 
**              Magnus x EMS - Comercio Exterior, pois nao poderia haver nenhum
**              programa do tipo CDP que fosse exclusivo de Com‚rcio Exterior para
**              que nao fosse necessario filtrar os programas que serÆo expedidos 
**              pelo CDP
**
**            - calculo despesas adicionais de importacao
**
**********************************************************************************/

{cxbo/bocx095a.i1} /** Codigo Fonte da BOCX095A **/
