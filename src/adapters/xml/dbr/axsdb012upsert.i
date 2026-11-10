
procedure PITransUpsert:

    EMPTY TEMP-TABLE tt-erro NO-ERROR.

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM pTranAction          AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgName            AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgVersion         AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-estab-dbr.
    DEFINE INPUT  PARAM de-val-refer-atualiz AS dec NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.
    /*PARAMETERS - END*/


    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */

    IF NOT CAN-FIND (FIRST tt-estab-dbr) THEN DO: 
        {utp/ut-liter.i Estabelecimento_para_integra‡Æo_EAI * r}
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
        
     FOR EACH tt-estab-dbr NO-LOCK:
         CREATE ttListOfSite.
         ASSIGN iContEStab                                         = iContEStab + 1
                ttListOfSite.ttListOfSiteID                        = iContEStab
                ttListOfSite.DefaultSiteCode                       = tt-estab-dbr.cod-estabel
                ttListOfSite.DefaultSiteDescription                = tt-estab-dbr.des-estab.
     END.     /* ttListOfSite  */

    /* Envia informa‡äes p/ cria‡Æo do XML no adapter principal  */

    RUN  PIUpsert (INPUT pTranAction,
                   INPUT pProgName,
                   INPUT pProgVersion,
                   INPUT TABLE ttListOfSite,
                   INPUT de-val-refer-atualiz,
                   OUTPUT TABLE tt-erro).

    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */
END PROCEDURE.







