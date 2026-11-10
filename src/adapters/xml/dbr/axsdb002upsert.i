PROCEDURE PITransUpsert:

    EMPTY TEMP-TABLE tt-erro NO-ERROR.

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM pTranAction          AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgName            AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgVersion         AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-calend-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-dat-calend.
    DEFINE INPUT  PARAM de-val-refer-atualiz AS DEC NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.
    /*PARAMETERS - END*/

    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    IF NOT CAN-FIND (FIRST tt-calend-dbr) THEN DO: 
        {utp/ut-liter.i Calend rios_para_integra‡Æo_EAI * r}
        RUN utp/ut-msgs.p("msg":U,5561,trim(RETURN-VALUE)).
        CREATE tt-erro.
        ASSIGN iContErro        = iContErro + 1
               tt-erro.cd-erro  = 5561
               tt-erro.mensagem = RETURN-VALUE
               tt-erro.i-sequen = iContErro. 
       RETURN "NOK":U.
     END.

    /* Cria temp-table's do adapter com base nas temp-table's enviadas pelo EMS. 
       O adapter ir  considerar valores branco e zero, pois o default dos campos j  foi setado */
    for each tt-calend-dbr no-lock:
        create ttCalendar.
        assign iContCalendar                    = iContCalendar + 1
               ttCalendar.ttCalendarID          = iContCalendar
               ttCalendar.CalendarCode          = tt-calend-dbr.cod-calend
               ttCalendar.CalendarDescription   = tt-calend-dbr.des-calend.

        for each tt-dat-calend where tt-dat-calend.cod-calend = tt-calend-dbr.cod-calend no-lock:
            create ttCalendarDateInformation.
            assign iContCalInfor                                            = iContCalInfor + 1
                   ttCalendarDateInformation.ttCalendarDateInformationID    = iContCalInfor
                   ttCalendarDateInformation.ttCalendarID                   = ttCalendar.ttCalendarID
                   ttCalendarDateInformation.CalendarDate                   = tt-dat-calend.data
                   ttCalendarDateInformation.DayType                        = tt-dat-calend.tipo-dia.
        end.

    end.
    /* Envia informa‡äes p/ cria‡Æo do XML no adapter principal  */
    RUN  PIUpsert (INPUT pTranAction,
                   INPUT pProgName,
                   INPUT pProgVersion,
                   INPUT TABLE ttCalendar,
                   INPUT TABLE ttCalendarDateInformation,
                   INPUT de-val-refer-atualiz,
                   OUTPUT TABLE tt-erro).

    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */
END procedure.




