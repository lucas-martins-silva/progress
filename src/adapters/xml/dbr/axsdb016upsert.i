PROCEDURE PITransUpsert:

    EMPTY TEMP-TABLE tt-erro         NO-ERROR.
    EMPTY TEMP-TABLE ttUnitOfMeasure NO-ERROR.

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM pTranAction          AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgName            AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgVersion         AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-unid-medid-dbr.
    DEFINE INPUT  PARAM de-val-refer-atualiz AS DEC NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.
    /*PARAMETERS - END*/

    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */

    IF NOT CAN-FIND (FIRST tt-unid-medid-dbr) THEN DO: 
        
        {utp/ut-liter.i Unidade_de_Medida_para_integra‡Æo_EAI * r}
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
     FOR EACH tt-unid-medid-dbr NO-LOCK:
         
         CREATE ttUnitOfMeasure.  
         ASSIGN iContUn                                  = iContUn + 1
                ttUnitOfMeasure.ttUnitOfMeasureID        = iContUn 
                ttUnitOfMeasure.UnitOfMeasureCode        = tt-unid-medid-dbr.cod-unid-medid
                ttUnitOfMeasure.UnitOfMeasureDescription = tt-unid-medid-dbr.des-unid.
     END.     

    /* Envia informa‡äes p/ cria‡Æo do XML no adapter principal  */
    RUN  PIUpsert (INPUT pTranAction,
                   INPUT pProgName,
                   INPUT pProgVersion,
                   INPUT TABLE ttUnitOfMeasure,
                   INPUT de-val-refer-atualiz,
                   OUTPUT TABLE tt-erro).

    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */
END PROCEDURE.






