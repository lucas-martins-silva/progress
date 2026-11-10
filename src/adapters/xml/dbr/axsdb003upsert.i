PROCEDURE PITransUpsert:

    DEFINE INPUT PARAM pcTranAction          AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT PARAM pcProgName            AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT PARAM pcProgVersion         AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT PARAM TABLE FOR tt-model-turno-dbr.
    DEFINE INPUT PARAM TABLE FOR tt-turno-dia-dbr.
    DEFINE INPUT PARAM pde-val-refer-atualiz AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.    

    /* LOCAL VARIABLES */
    DEFINE VARIABLE iId   AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE iCont AS INTEGER           NO-UNDO.

    EMPTY TEMP-TABLE tt-erro                  NO-ERROR.
    EMPTY TEMP-TABLE ttListOfDayShift         NO-ERROR.
    EMPTY TEMP-TABLE ttListOfShiftInformation NO-ERROR.

    IF  NOT CAN-FIND (FIRST tt-model-turno-dbr) THEN DO: 
         
        /* Registro Turno nao encontrado */
        {utp/ut-liter.i Turno_para_Integracao_EAI *}
        RUN utp/ut-msgs.p("msg":U,
                          5561,
                          RETURN-VALUE).
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = iSeqErro
               tt-erro.cd-erro  = 5561
               tt-erro.mensagem = RETURN-VALUE
               iSeqErro         = iSeqErro + 1.
        RETURN "NOK":U.
    END.

    /* Cria temp-tables do adapter com base nas temp-tables enviadas pelo EMS               */
    /* O adapter ir  considerar valores branco/zero pois o default dos campos j  foi setado */

    FOR EACH tt-model-turno-dbr:

        CREATE ttListOfShiftInformation.    
        ASSIGN ttListOfShiftInformation.ShiftModelCode             = tt-model-turno-dbr.cod-model-turno
               ttListOfShiftInformation.ShiftModelDescription      = tt-model-turno-dbr.des-model-turno         
               ttListOfShiftInformation.UsefulWeeklyTime           = tt-model-turno-dbr.qtd-tempo-util-sem       
               ttListOfShiftInformation.WeeklyInterruptionTime     = tt-model-turno-dbr.qtd-tempo-interrup-sem                   
               ttListOfShiftInformation.ttListOfShiftInformationID = iId                                             
               iId                                                 = iId + 1.

               DO iCont = 1 TO 7:
                  ASSIGN ttListOfShiftInformation.QtdDayInterruptionTime[iCont] = tt-model-turno-dbr.qtd-tempo-interrup-dia[iCont]
                         ttListOfShiftInformation.QtdUsefulDayTime[iCont]       = tt-model-turno-dbr.qtd-tempo-util-dia[iCont].
               END.

        FOR EACH tt-turno-dia-dbr OF tt-model-turno-dbr:
            CREATE ttListOfDayShift.
            ASSIGN ttListOfDayShift.ttListOfShiftInformationID =  ttListOfShiftInformation.ttListOfShiftInformationID
                   ttListOfDayShift.DayNumber                  = tt-turno-dia-dbr.num-dia         
                   ttListOfDayShift.SeqShift                   = tt-turno-dia-dbr.num-turno
                   ttListOfDayShift.EndTime                    = tt-turno-dia-dbr.qtd-hra-fim
                   ttListOfDayShift.StartTime                  = tt-turno-dia-dbr.qtd-hra-inicio
                   ttListOfDayShift.StopTime                   = tt-turno-dia-dbr.qtd-tempo-interrup.
        END.
    END.



    /* Envia informa‡äes p/ cria‡Æo do XML no adapter principal  */
    RUN PIUpsert (INPUT pcTranAction,
                  INPUT pcProgName,
                  INPUT pcProgVersion,
                  INPUT TABLE ttListOfShiftInformation,
                  INPUT TABLE ttListOfDayShift,
                  INPUT pde-val-refer-atualiz,
                  OUTPUT TABLE tt-erro).

END PROCEDURE.
/* EOF */
