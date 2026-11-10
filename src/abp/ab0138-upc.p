/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0138-UPC 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138-upc MAB}
&ENDIF



/*****************************************************************************
Dentro deste programa devem ser feitas as chamadas UPC's para o programa de 
Manuten‡Æo do  Equipamento - ab0138.
*****************************************************************************/

/*********************** Defini‡Æo de Parƒmetros ************************/
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
{include/i-epc200.i} /*Defini‡Æo tt-EPC*/
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VARIABLE c-return AS CHARACTER  NO-UNDO.

{utp/ut-glob.i}

/***Busca pelo programa de valida‡Æo do formato dos campos *****
 ******* C¢digo do Equipamento e c¢digo da placa           ****/
if search("abp/ab0138-upca.p") <> ? OR
   search("abp/ab0138-upca.r") <> ?   THEN DO:
   RUN abp/ab0138-upca.p (INPUT p-ind-event, 
                          INPUT-OUTPUT TABLE tt-epc).
 ASSIGN c-return = trim(RETURN-VALUE).
END.
/******************************************************************************/
Return c-return.
