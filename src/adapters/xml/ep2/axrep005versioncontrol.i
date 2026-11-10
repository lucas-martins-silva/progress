     
     /* ********* EXECU€ÇO DAS PI - BEGIN ********* */
     
     IF (cTranAction = "add":U) OR (cTranAction = "upd":U) THEN 
          RUN PIUpsert.

     IF (cTranAction = "del":U) THEN 
          RUN PIDelete.


     IF hMessageHandler:GET-SIGNATURE("setExtraInformation":U) <> "":U THEN 
        FOR EACH ttRetornaCliente NO-LOCK:
            RUN setExtraInformation IN hMessageHandler (ttRetornaCliente.XMLElementName,
                                                        ttRetornaCliente.FieldValue).
        END.

     IF CAN-FIND (FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN /* Erros ocorridos durante efetiva‡Æo do registro */
        FOR EACH RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U : 

            IF RowErrors.ErrorSubType = "ERROR":U THEN
               RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                INPUT "business_error":U,
                                                INPUT RowErrors.ErrorDescription + " - " + RowErrors.ErrorHelp).

            ELSE IF RowErrors.ErrorSubType = "WARNING":U THEN
                 RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                  INPUT "business_warning":U,
                                                  INPUT RowErrors.ErrorDescription + " - " + RowErrors.ErrorHelp).

            ELSE IF RowErrors.ErrorSubType = "INFORMATION":U THEN
                 RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                  INPUT "business_information":U,
                                                  INPUT RowErrors.ErrorDescription + " - " + RowErrors.ErrorHelp).
        END.
          
    /* Obt‚m mensagem de retorno (erro ou confirma‡Æo) */
    RUN getReturnMessage IN hMessageHandler (OUTPUT hOUTPUTXML). 
       

