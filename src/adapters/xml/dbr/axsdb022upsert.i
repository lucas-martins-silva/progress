PROCEDURE PITransUpsert:

    EMPTY TEMP-TABLE tt-erro NO-ERROR.

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM pTranAction          AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgName            AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgVersion         AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-reduc-prepar-dbr.
    DEFINE INPUT  PARAM de-val-refer-atualiz AS DEC NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.
    /*PARAMETERS - END*/


    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */

    IF  NOT CAN-FIND (FIRST tt-reduc-prepar-dbr) THEN DO: 

        {utp/ut-liter.i Redutor_de_Setup_para_integra‡Æo_EAI * r}
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
     FOR EACH tt-reduc-prepar-dbr NO-LOCK:
         
         CREATE ttSetupReductionDBR.  
         ASSIGN iContTool                                     = iContTool + 1
                ttSetupReductionDBR.ttSetupReductionDBRID     = iContTool 
                ttSetupReductionDBR.SetupReductorCode         = tt-reduc-prepar-dbr.cod-reduc-prepar
                ttSetupReductionDBR.SetupReductionDescription = tt-reduc-prepar-dbr.des-reduc-prepar
                ttSetupReductionDBR.SetupReductionComments    = tt-reduc-prepar-dbr.dsl-reduc-prepar.
     END.


     RUN PIUpsert(INPUT pTranAction,
                  INPUT pProgName,
                  INPUT pProgVersion,
                  INPUT TABLE ttSetupReductionDBR,
                  INPUT de-val-refer-atualiz,
                  OUTPUT TABLE tt-erro).

     /* ******************************************* */
     /* *************** BODY - END   ************** */
     /* ******************************************* */

END PROCEDURE.



