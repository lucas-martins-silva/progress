IF  (cTranAction = "add") or (cTranAction = "mod") THEN
    RUN PIUpsert.
                                                                 
IF  CAN-FIND (FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN
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
  
RUN getReturnMessage IN hMessageHandler (OUTPUT hOUTPUTXML). 
