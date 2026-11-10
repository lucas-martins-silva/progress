PROCEDURE PITransUpsert:

    EMPTY TEMP-TABLE tt-erro NO-ERROR.

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM pTranAction          AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgName            AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgVersion         AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-matriz-reduc-prepar.
    DEFINE INPUT  PARAM de-val-refer-atualiz AS DEC NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.
    /*PARAMETERS - END*/
    
    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    IF NOT CAN-FIND (FIRST tt-matriz-reduc-prepar) THEN DO: 
        
        {utp/ut-liter.i Matriz_Redu‡Æo_de_Setup_para_integra‡Æo_EAI * r}
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
     FOR EACH tt-matriz-reduc-prepar NO-LOCK:
         
         CREATE ttSetupReductionMatrixDBR.  
         ASSIGN iContTool                                           = iContTool + 1
                ttSetupReductionMatrixDBR.ttSetupReductionMatrixDBRID = iContTool
                ttSetupReductionMatrixDBR.SourceReductionCode         = tt-matriz-reduc-prepar.cod-reduc-orig
                ttSetupReductionMatrixDBR.DestinationReductionCode    = tt-matriz-reduc-prepar.cod-reduc-dest
                ttSetupReductionMatrixDBR.WorkCenterCode              = tt-matriz-reduc-prepar.gm-codigo
                ttSetupReductionMatrixDBR.ReductionHourQuantity       = tt-matriz-reduc-prepar.qtd-hora-reduc
                ttSetupReductionMatrixDBR.ReductionPercentageQuantity = tt-matriz-reduc-prepar.qtd-perc-reduc.
     END.

    /* Envia informa‡äes p/ cria‡Æo do XML no adapter principal  */
    RUN PIUpsert (INPUT pTranAction,
                  INPUT pProgName,
                  INPUT pProgVersion,
                  INPUT TABLE ttSetupReductionMatrixDBR,
                  INPUT de-val-refer-atualiz,
                  OUTPUT TABLE tt-erro).
    
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.



