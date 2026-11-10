/* FAZER AQUI TRATAMENTO DE CONTROLE DE VERSÇO ADEQUADO! */

/* ********* EXECU€ÇO DAS PI - BEGIN ********* */
IF  (cTranAction = "add") or (cTranAction = "upd") THEN DO:
    RUN PIUpsert.
    /* AQUI!! IMPLEMENTAR A CHAMADA A API DE EFETIVA€ÇO */
END.
IF  (cTranAction = "del") THEN DO:
    RUN PIDelete.
    /* AQUI!! IMPLEMENTAR A CHAMADA A API DE EFETIVA€ÇO */
END.

IF  CAN-FIND (FIRST RowErrors) THEN /* Erros ocorridos durante efetiva‡Æo do registro */
    FOR EACH RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U :
    
        IF  RowErrors.ErrorSubType = "ERROR":U 
        THEN RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                              INPUT "business_error":U, 
                                              INPUT RowErrors.ErrorDescription + " " + RowErrors.ErrorHelp).
        ELSE IF  RowErrors.ErrorSubType = "WARNING":U 
             THEN RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                   INPUT "business_warning":U,
                                                   INPUT RowErrors.ErrorDescription + " " + RowErrors.ErrorHelp).
             ELSE IF  RowErrors.ErrorSubType = "INFORMATION":U 
                  THEN RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                        INPUT "business_information":U,  
                                                        INPUT RowErrors.ErrorDescription + " " + RowErrors.ErrorHelp).
    END. /* FOR EACH RowErrors */

/* OBTEM UMA MENSAGEM DE RETORNO - SENDO ELA DE ERRO OU DE CONFIRMA€ÇO */
RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML).
/* ********* EXECU€ÇO DAS PI - END ********* */


