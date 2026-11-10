/* ********* EXECUÇÃO DAS PI - BEGIN ********* */
IF (cTranAction = "add":U) 
OR (cTranAction = "upd":U) THEN RUN PIUpsert.

IF (cTranAction = "del":U) THEN RUN PIDelete.

IF CAN-FIND (FIRST RowErrors) THEN /* Erros ocorridos durante efetiva‡Æo do registro */
   FOR EACH RowErrors 
    WHERE RowErrors.ErrorType <> "INTERNAL":U :
    
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

   FIND FIRST ttConsultationDocument NO-ERROR.
   IF AVAIL ttConsultationDocument AND
      hMessageHandler:GET-SIGNATURE("setExtraInformation":U) <> "":U THEN DO:

      RUN setExtraInformation IN hMessageHandler ("cStat":U,ttConsultationDocument.cStat). 
      RUN setExtraInformation IN hMessageHandler ("dhRecbto":U,ttConsultationDocument.dhRecbto).
      RUN setExtraInformation IN hMessageHandler ("nProt":U,ttConsultationDocument.nProt).
      RUN setExtraInformation IN hMessageHandler ("digVal":U,ttConsultationDocument.digVal).
   END.


/* Obt‚m mensagem de retorno (erro ou confirma‡Æo) */
RUN getReturnMessage IN hMessageHandler (OUTPUT hOUTPUTXML). 
