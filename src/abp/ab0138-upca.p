/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0138-UPCA 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138-upca MAB}
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
/* **    Programa.:  ab0138-upca.p                                          **                                                 */
/* **    Objetivo.:  Validar o formato do c¢digo do  equipamento e          **                                                 */
/* **                o c¢digo da placa                                      **                                                 */
/* **    Data.....:  Fevereiro/2005                                         **                                                 */
/* ***************************************************************************/                                                */
/*                                                                                                                             */
/* /**************************************************************************                                                 */
/* Este programa deve ser chamado pelo programa ab0138-upc                                                                     */
/* **************************************************************************/                                                 */

{include/i-epc200.i}       /****** Defini‡Æo tt-EPC *******/
{frbo/bofr007.i tt-eqpto} /******* Defini‡Æo Temp-table DBO do Equipamento *******/

DEFINE INPUT PARAMETER p-ind-event   AS CHARACTER     NO-UNDO.

DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VARIABLE i-teste AS INTEGER  NO-UNDO.
DEFINE VARIABLE c-liter AS CHARACTER  NO-UNDO.

IF  p-ind-event = "valida-campos":U THEN DO:
/*buscando na tt--epc qual ‚ a a‡Æo para a validacao - add, upd ou del*/
    FIND FIRST tt-epc WHERE tt-epc.cod-event = p-ind-event AND
                            tt-epc.cod-parameter = "acao":U.
    IF AVAIL tt-epc THEN DO:
        CASE tt-epc.val-parameter:

            WHEN "add":U THEN DO:
            /***Busca todos os registrso criados na tt-epc para validar o formato dos campos quando a‡Æo = add*****/
                FIND FIRST tt-epc WHERE tt-epc.cod-event = p-ind-event AND
                                        tt-epc.cod-parameter = "bofr007a.p" NO-LOCK NO-ERROR.
                IF AVAIL tt-epc THEN DO:
                    /***** Validar o c¢digo do Equipamento ***/
                    IF LENGTH(trim(tt-epc.val-parameter)) > 8 THEN DO: 
                        /* Valida c¢digo do  equipamento com 8 posi‡äes */
                        CREATE tt-epc.
                        {utp/ut-liter.i O_C¢digo_do_Equipamento_deve_ser_num‚rico_com_no_m ximo_8_posi‡äes. * }
                        ASSIGN c-liter = trim(RETURN-VALUE).
                        {utp/ut-liter.i Para_atender_…s_integra‡äes_EAI_com_Agroind£stria,_o_C¢digo_do_Equipamento_deve_ser_num‚rico_com_no_m ximo_8_posi‡äes. *}
                        ASSIGN tt-epc.cod-event = "ERROR":U
                               tt-epc.cod-parameter = "EPC-ERROR":U 
                               tt-epc.val-parameter = c-liter + "~~" + RETURN-VALUE.
                        RETURN "NOK":U.
                    END. /*IF LENGTH(trim(tt-epc.val-parameter)) > 8*/
                    ELSE do:
                        ASSIGN i-teste = INT(tt-epc.val-parameter) NO-ERROR.
                        /* Valida se o c¢digo do equipamento ‚ num‚rico */
                        IF ERROR-STATUS:ERROR = TRUE THEN DO:
                            CREATE tt-epc.
                            {utp/ut-liter.i O_C¢digo_do_Equipamento_deve_ser_num‚rico. * }
                            ASSIGN c-liter = trim(RETURN-VALUE).
                            {utp/ut-liter.i Para_atender_…s_integra‡äes_EAI_com_Agroind£stria,_o_C¢digo_do_Equipamento_deve_ser_num‚rico. *}
                            ASSIGN tt-epc.cod-event = "ERROR":U
                                   tt-epc.cod-parameter = "EPC-ERROR":U 
                                   tt-epc.val-parameter = c-liter + "~~" + RETURN-VALUE.
                            RETURN "NOK":U.
                        END.
                    END. /*ELSE do:*/
                END. /*IF AVAIL tt-epc*/
                FIND FIRST tt-epc WHERE tt-epc.cod-event = p-ind-event AND
                                        tt-epc.cod-parameter = "bofr007b.p" NO-LOCK NO-ERROR.
                IF AVAIL tt-epc THEN DO:
                    /***** Validar o c¢digo da placa ****/
                    IF LENGTH(trim(tt-epc.val-parameter)) > 7 THEN DO: 
                        /* Valida c¢digo da Placa com 7 posi‡äes */
                        CREATE tt-epc.
                        {utp/ut-liter.i O_C¢digo_da_Placa_deve_ter_no_m ximo_7_posi‡äes. * }
                        ASSIGN c-liter = trim(RETURN-VALUE).
                        {utp/ut-liter.i Para_atender_…s_integra‡äes_EAI_com_Agroind£stria,_o_C¢digo_da_Placa_deve_ter_no_m ximo_7_posi‡äes. *}
                        ASSIGN tt-epc.cod-event = "ERROR":U
                               tt-epc.cod-parameter = "EPC-ERROR":U 
                               tt-epc.val-parameter = c-liter + "~~" + RETURN-VALUE.
                        RETURN "NOK":U.
                    END.
                end. /*IF AVAIL tt-epc*/
            END. /*WHEN "add" */

            WHEN "upd":U THEN DO:
            /***Busca todos os registrso criados na tt-epc para validar o formato dos campos quando a‡Æo = upd *****/
                FIND FIRST tt-epc WHERE tt-epc.cod-event = p-ind-event AND
                                        tt-epc.cod-parameter = "bofr007b.p" NO-LOCK NO-ERROR.
                IF AVAIL tt-epc THEN DO:
                    /***** Validar o c¢digo da placa ****/
                    IF LENGTH(trim(tt-epc.val-parameter)) > 7 THEN DO: 
                        /* Valida c¢digo da Placa com 7 posi‡äes */
                        CREATE tt-epc.
                        {utp/ut-liter.i O_C¢digo_da_Placa_deve_ter_no_m ximo_7_posi‡äes. * }
                        ASSIGN c-liter = trim(RETURN-VALUE).
                        {utp/ut-liter.i Para_atender_…s_integra‡äes_EAI_com_Agroind£stria,_o_C¢digo_da_Placa_deve_ter_no_m ximo_7_posi‡äes. *}
                        ASSIGN tt-epc.cod-event = "ERROR":U
                               tt-epc.cod-parameter = "EPC-ERROR":U 
                               tt-epc.val-parameter = c-liter + "~~" + RETURN-VALUE.
                        RETURN "NOK":U.
                    END.
                end. /*IF AVAIL tt-epc*/
            END. /*WHEN "upd"*/

            WHEN "del":U THEN DO:
            /***Busca todos os registrso criados na tt-epc para validar o formato dos campos quando a‡Æo = del *****/
                FIND FIRST tt-epc WHERE tt-epc.cod-event = p-ind-event AND
                                        tt-epc.cod-parameter = "bofr007a.p" NO-LOCK NO-ERROR.
                IF AVAIL tt-epc THEN DO:
                    /***** Validar o c¢digo do Equipamento ***/
                    IF LENGTH(trim(tt-epc.val-parameter)) > 8 THEN DO: 
                        /* Valida c¢digo do  equipamento com 8 posi‡äes */
                        CREATE tt-epc.
                        {utp/ut-liter.i O_C¢digo_do_Equipamento_deve_ser_num‚rico_com_no_m ximo_8_posi‡äes. * }
                        ASSIGN c-liter = trim(RETURN-VALUE).
                        {utp/ut-liter.i Para_atender_…s_integra‡äes_EAI_com_Agroind£stria,_o_C¢digo_do_Equipamento_deve_ser_num‚rico_com_no_m ximo_8_posi‡äes. *}
                        ASSIGN tt-epc.cod-event = "ERROR":U
                               tt-epc.cod-parameter = "EPC-ERROR":U 
                               tt-epc.val-parameter = c-liter + "~~" + RETURN-VALUE.
                        RETURN "NOK":U.
                    END. /*IF LENGTH(trim(tt-epc.val-parameter)) > 8*/
                    ELSE do:
                        ASSIGN i-teste = INT(tt-epc.val-parameter) NO-ERROR.
                        /* Valida se o c¢digo do equipamento ‚ num‚rico */
                        IF ERROR-STATUS:ERROR = TRUE THEN DO:
                            CREATE tt-epc.
                            {utp/ut-liter.i O_C¢digo_do_Equipamento_deve_ser_num‚rico. * }
                            ASSIGN c-liter = trim(RETURN-VALUE).
                            {utp/ut-liter.i Para_atender_…s_integra‡äes_EAI_com_Agroind£stria,_o_C¢digo_do_Equipamento_deve_ser_num‚rico. *}
                            ASSIGN tt-epc.cod-event = "ERROR":U
                                   tt-epc.cod-parameter = "EPC-ERROR":U 
                                   tt-epc.val-parameter = c-liter + "~~" + RETURN-VALUE.
                            RETURN "NOK":U.
                        END.
                    END. /*ELSE do:*/
                END. /*IF AVAIL tt-epc*/
            END. /*WHEN "del"*/
        END CASE.
    
    END. /*IF AVAIL tt-epc*/
        
END. /*IF  p-ind-event = "valida-campos"*/

RETURN "OK":U.

    
