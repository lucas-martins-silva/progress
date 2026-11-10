PROCEDURE PITransUpsert:

    EMPTY TEMP-TABLE tt-erro NO-ERROR.

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM pTranAction          AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgName            AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgVersion         AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-det-turno-excec.
    DEFINE INPUT  PARAM TABLE FOR tt-turno-excec-cenar.
    DEFINE INPUT  PARAM de-val-refer-atualiz AS DEC NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.
    /*PARAMETERS - END*/


    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    IF NOT CAN-FIND (FIRST tt-det-turno-excec) THEN DO:
        {utp/ut-liter.i Turno_de_Exce‡Æo_para_integra‡Æo_EAI * r}
        RUN utp/ut-msgs.p("msg":U,5561,TRIM(RETURN-VALUE)).
        CREATE tt-erro.
        ASSIGN iContErro        = iContErro + 1
               tt-erro.cd-erro  = 5561
               tt-erro.mensagem = RETURN-VALUE
               tt-erro.i-sequen = iContErro. 
        RETURN "NOK":U.
    END.

    /* Cria temp-table's do adapter com base nas temp-table's enviadas pelo EMS. 
       O adapter ir  considerar valores branco e zero, pois o default dos campos j  foi setado */
     FOR EACH tt-det-turno-excec NO-LOCK:
         
         CREATE ttExceptionTurnDetailDBR.  
         ASSIGN iContTool                                           = iContTool + 1
                ttExceptionTurnDetailDBR.ttExceptionTurnDetailDBRID = iContTool 
                ttExceptionTurnDetailDBR.ScenarioCode               = tt-det-turno-excec.cod-cenario
                ttExceptionTurnDetailDBR.WorkCenterCode             = tt-det-turno-excec.gm-codigo
                ttExceptionTurnDetailDBR.WorkCenterUnitCode         = tt-det-turno-excec.cod-ctrab
                ttExceptionTurnDetailDBR.ExceptionDate              = tt-det-turno-excec.dat-excec
                ttExceptionTurnDetailDBR.InitialHour                = tt-det-turno-excec.val-hora-inic
                ttExceptionTurnDetailDBR.FinalHourd                 = tt-det-turno-excec.val-hora-fim
                ttExceptionTurnDetailDBR.Comments                   = tt-det-turno-excec.des-coment.
     END.     

     FOR EACH tt-turno-excec-cenar NO-LOCK:

         CREATE ttExceptionPartScenario.
         ASSIGN ttExceptionPartScenario.ScenarioCode                = tt-turno-excec-cenar.cod-cenario
                ttExceptionPartScenario.MachineGroup                = tt-turno-excec-cenar.gm-codigo  
                ttExceptionPartScenario.WorkCenter                  = tt-turno-excec-cenar.cod-ctrab  
                ttExceptionPartScenario.Comment                     = tt-turno-excec-cenar.des-coment 
                ttExceptionPartScenario.ttExceptionPartScenarioID   = iContTool2
                iContTool2                                          = iContTool2 + 1.
                
     END.
    /* Envia informa‡äes p/ cria‡Æo do XML no adapter principal  */
    RUN  PIUpsert (INPUT pTranAction,
                   INPUT pProgName,
                   INPUT pProgVersion,
                   INPUT TABLE ttExceptionTurnDetailDBR,
                   INPUT TABLE ttExceptionPartScenario,
                   INPUT de-val-refer-atualiz,
                   OUTPUT TABLE tt-erro).
    
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.



