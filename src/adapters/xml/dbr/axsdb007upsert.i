PROCEDURE PITransUpsert:

    EMPTY TEMP-TABLE tt-erro NO-ERROR.

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM pTranAction          AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgName            AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgVersion         AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM table FOR tt-ctrab-dbr.
    DEFINE INPUT  PARAM de-val-refer-atualiz AS DEC NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.
    /*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
     IF NOT CAN-FIND (FIRST tt-ctrab-dbr) THEN DO: 
        
        {utp/ut-liter.i Centro_de_Trabalho_para_integra‡Æo_EAI * r}
        RUN utp/ut-msgs.p("msg":U,5561,trim(RETURN-VALUE)).
        CREATE tt-erro.
        ASSIGN iContErro        = iContErro + 1
                tt-erro.cd-erro  = 5561
                tt-erro.mensagem = RETURN-VALUE
                tt-erro.i-sequen = iContErro. 
        RETURN "NOK":U.
     
     end.
       
       /* Cria temp-table's do adapter com base nas temp-table's enviadas pelo EMS. 
       O adapter ir  considerar valores branco e zero, pois o default dos campos j  foi setado */
        
     FOR EACH tt-ctrab-dbr NO-LOCK:
         
         CREATE ttWorkCenter.
         ASSIGN ttWorkCenter.WorkCenterCode                = tt-ctrab-dbr.cod-ctrab
                ttWorkCenter.WorkCenterDescription         = tt-ctrab-dbr.des-ctrab
                ttWorkCenter.MachineGroupCode              = tt-ctrab-dbr.gm-codigo
                ttWorkCenter.NumberOfWorkCenterOperations  = tt-ctrab-dbr.num-operador-ctrab.
         

     end.
    /* Envia informa‡äes p/ cria‡Æo do XML no adapter principal  */
    RUN  PIUpsert (INPUT pTranAction,
                   INPUT pProgName,
                   INPUT pProgVersion,
                   INPUT TABLE ttWorkCenter,
                   INPUT de-val-refer-atualiz,
                   OUTPUT TABLE tt-erro).
                                                                                        
                                                                                        
                                                                                        
/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */
END PROCEDURE.



