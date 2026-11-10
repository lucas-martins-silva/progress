PROCEDURE PITransUpsert:

    EMPTY TEMP-TABLE tt-erro NO-ERROR.

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM pTranAction          AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgName            AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgVersion         AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-gm-altern-dbr.
    DEFINE INPUT  PARAM de-val-refer-atualiz AS DEC NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.
    /*PARAMETERS - END*/


    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    IF NOT CAN-FIND (FIRST tt-gm-altern-dbr) THEN DO:
        {utp/ut-liter.i GM_Alternativo_para_integra‡Æo_EAI * r}
        RUN utp/ut-msgs.p("msg":U,5561,TRIM(RETURN-VALUE)).
        CREATE tt-erro.
        ASSIGN iContErro        = iContErro + 1
               tt-erro.cd-erro  = 5561
               tt-erro.mensagem = RETURN-VALUE
               tt-erro.i-sequen = iContErro. 
        RETURN "NOK":U.
    END.

    /* Cria temp-table's do adapter com base nas temp-table's enviadas pelo EMS. 
       O adapter irá considerar valores branco e zero, pois o default dos campos já foi setado */
     FOR EACH tt-gm-altern-dbr NO-LOCK:
         
         CREATE ttAlternativeMachineGroup.  
         ASSIGN iContTool                                             = iContTool + 1
                ttAlternativeMachineGroup.ttAlternativeMachineGroupID = iContTool 
                ttAlternativeMachineGroup.AlternativeMachineGroupCode = tt-gm-altern-dbr.gm-altern
                ttAlternativeMachineGroup.MachineGroupCode            = tt-gm-altern-dbr.gm-codigo
                ttAlternativeMachineGroup.PercentageEfficiency        = tt-gm-altern-dbr.val-perc-eficien
                ttAlternativeMachineGroup.SequenceNumber              = tt-gm-altern-dbr.num-sequencia.
     END.     

    /* Envia informações p/ criação do XML no adapter principal  */
    RUN  PIUpsert (INPUT pTranAction,
                   INPUT pProgName,
                   INPUT pProgVersion,
                   INPUT TABLE ttAlternativeMachineGroup,
                   INPUT de-val-refer-atualiz,
                   OUTPUT TABLE tt-erro).
    
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.
