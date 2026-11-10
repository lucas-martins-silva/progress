/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0103-UPCA 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0103-upca MAB}
&ENDIF


/* /********************************************************************************                                           */
/* ** Copyright DATASUL S.A. (2005)                                                                                            */
/* ** Todos os Direitos Reservados.                                                                                            */
/* **                                                                                                                          */
/* ** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao                                                         */
/* ** parcial ou total por qualquer meio, so podera ser feita mediante                                                         */
/* ** autorizacao expressa.                                                                                                    */
/* *******************************************************************************/                                            */
/* /**************************************************************************                                                 */
/* **    Programa.:  ab0103-upca.p                                          **                                                 */
/* **    Objetivo.:  Validar o formato do c¢digo de Marcas                  **                                                 */
/* **    Data.....:  Fevereiro/2005                                         **                                                 */
/* ***************************************************************************/                                                */
/*                                                                                                                             */
/* /**************************************************************************                                                 */
/* Este programa deve ser chamado pelo programa ab0103-upc                                                                     */
/* **************************************************************************/                                                 */

{include/i-epc200.i} /*Defini‡Æo tt-EPC*/
{frbo/bofr015.i tt-mab-marca-eai} /*Defini‡Æo Temp-table*/

DEFINE INPUT PARAMETER p-ind-event   AS CHARACTER     NO-UNDO.

DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VARIABLE i-teste AS INTEGER  NO-UNDO.
DEFINE VARIABLE c-liter AS CHARACTER  NO-UNDO.

IF  p-ind-event = "validate-EAI" THEN DO:
    FIND FIRST tt-epc WHERE 
         tt-epc.cod-event = p-ind-event AND
         tt-epc.cod-parameter = "table-key" NO-LOCK NO-ERROR.
    IF  AVAIL tt-epc THEN DO:
        IF LENGTH(trim(tt-epc.val-parameter)) > 5 THEN DO: 
            /* Valida c¢digo da marca com 5 posi‡äes */
            CREATE tt-epc.
            {utp/ut-liter.i O_C¢digo_da_Marca_deve_ser_num‚rico_com_no_m ximo_5_posi‡äes. *}
            ASSIGN c-liter = RETURN-VALUE.
            {utp/ut-liter.i Para_atender_…s_integra‡äes_EAI_com_Agroind£stria,_o_C¢digo_da_Marca_deve_ser_num‚rico_com_no_m ximo_5_posi‡äes. *}
            ASSIGN tt-epc.cod-event = "ERROR"
                   tt-epc.cod-parameter = "EPC-ERROR" 
                   tt-epc.val-parameter = c-liter + "~~" + RETURN-VALUE.
            RETURN "NOK":U.
        END.
        ELSE do:
            ASSIGN i-teste = INT(tt-epc.val-parameter) NO-ERROR.
            /* Valida c¢digo da marca num‚rico */
            IF ERROR-STATUS:ERROR = TRUE THEN DO:
                CREATE tt-epc.
                {utp/ut-liter.i O_C¢digo_da_Marca_deve_ser_num‚rico. *}
                ASSIGN c-liter = RETURN-VALUE.
                {utp/ut-liter.i Para_atender_…s_integra‡äes_EAI_com_Agroind£stria,_o_C¢digo_da_Marca_deve_ser_num‚rico. *}
                ASSIGN tt-epc.cod-event = "ERROR"
                       tt-epc.cod-parameter = "EPC-ERROR" 
                       tt-epc.val-parameter =  c-liter + "~~" + RETURN-VALUE.
                RETURN "NOK":U.
            END.
            ELSE 
                RETURN "OK":U.
        END.
    END.
END.
