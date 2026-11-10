     
     /* ********* EXECUÇÃO DAS PI - BEGIN ********* */
    
    IF (cTranAction = "add":U) OR (cTranAction = "upd":U) THEN 
         RUN PIUpsert.

     IF (cTranAction = "del":U) THEN 
         RUN PIDelete.

     IF CAN-FIND (FIRST RowErrors) THEN /* Erros ocorridos durante efetiva‡Æo do registro */
        FOR EACH RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U : 

            IF RowErrors.ErrorSubType = "ERROR":U THEN
               RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                INPUT "business_error":U, 
                                                INPUT RowErrors.ErrorDescription).

            ELSE IF RowErrors.ErrorSubType = "WARNING":U THEN
                 RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                  INPUT "business_warning":U,
                                                  INPUT RowErrors.ErrorDescription).

            ELSE IF RowErrors.ErrorSubType = "INFORMATION":U THEN
                 RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                  INPUT "business_information":U,  
                                                  INPUT RowErrors.ErrorDescription).
        END.

    /* Obt‚m mensagem de retorno (erro ou confirma‡Æo) */
    FIND FIRST ttReturnInvoiceDocument NO-ERROR.
    IF AVAIL ttReturnInvoiceDocument AND
       hMessageHandler:GET-SIGNATURE("setExtraInformation":U) <> "":U THEN DO:

        RUN setExtraInformation IN hMessageHandler ("chNFe":U,ttReturnInvoiceDocument.chNFe).
        RUN setExtraInformation IN hMessageHandler ("dhRecbto":U,ttReturnInvoiceDocument.dhRecbto).
        RUN setExtraInformation IN hMessageHandler ("nProt":U,ttReturnInvoiceDocument.nProt).
        RUN setExtraInformation IN hMessageHandler ("cStat":U,ttReturnInvoiceDocument.digVal). 
        RUN setExtraInformation IN hMessageHandler ("cStat":U,ttReturnInvoiceDocument.cStat). 
    END.
    
    RUN getReturnMessage IN hMessageHandler (OUTPUT hOUTPUTXML). 
