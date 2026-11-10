/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0107-UPC 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0107-upc MAB}
&ENDIF



/*****************************************************************************
Dentro deste programa devem ser feitas as chamadas UPC's para o programa de 
Manuten‡Æo de Grupos de Equipamento - ab0107.
*****************************************************************************/

/*********************** Defini¯Êo de Parümetros ************************/
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.

{include/i-epc200.i} /*Defini‡Æo tt-EPC*/
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VARIABLE c-return AS CHARACTER  NO-UNDO.

{utp/ut-glob.i}

if search("abp~\ab0107-upca.p") <> ? OR
   search("abp~\ab0107-upca.r") <> ?   THEN DO:
   RUN abp/ab0107-upca.p (INPUT p-ind-event, 
                          INPUT-OUTPUT TABLE tt-epc).
 ASSIGN c-return = RETURN-VALUE.
END.

Return c-return.
