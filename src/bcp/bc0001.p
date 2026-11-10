/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0001 2.00.00.021 } /*** 010021 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0001 MBC}
&ENDIF


/*******************************************************************************
**
**   Programa..: bc0001.p
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Programa de Inicializaá∆o do Coleta de Dados
**
*********************************************************************************/

/*Parametro incluido para que ocorra erro se o bc0001.p for executado direto*/
DEFINE INPUT PARAMETER pl-n-executa  AS LOGICAL     NO-UNDO.

find first param-bc no-lock no-error.

if  not avail param-bc
then run bcp/bc0001a.p. /* EMS 2.0x    */
else do:
    &if '{&mgcld_version}' <= '2.04' &then
        if param-bc.int-2 <= 1  /* EMS */
    &else
        if param-bc.ind-sistema <= 1  /* EMS */
    &endif
        then run bcp/bc0001a.p. /* EMS 2.0x    */
        else run bcp/bc0001b.p. /* Magnus I.00 */
end.
