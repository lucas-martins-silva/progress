    /* ********* EXECU€ÇO DAS PI - BEGIN ********* */
    IF (cTranAction = "add") or (cTranAction = "upd") THEN DO:
        RUN PIUpsert.
    END.

    IF  CAN-FIND (FIRST RowErrors) THEN /* Erros ocorridos durante efetiva‡Æo do registro */
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
 
        END. /* FOR EACH RowErrors */
    /* Obt‚m mensagem de retorno (erro ou confirma‡Æo) */
    RUN getReturnMessage IN hMessageHandler (OUTPUT hOUTPUTXML). 
       
    /* Envia mensagam de notifica‡Æo :: integra‡Æo ass¡ncrona */
    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).
    
    /*--- NÆo retirar esta l¢gica. Procedimento necess rio para a integra‡Æo com Neogrid --*/
    IF  CAN-FIND(FIRST funcao
                 WHERE funcao.cd-funcao = 'spp-neogrid':U
                 AND   funcao.ativo     = TRUE) THEN DO:
        ASSIGN pSendSuccess = TRUE.
    END. /* IF  CAN-FIND(FIRST funcao */
    /*- NÆo retirar a l¢gica acima. Procedimento necess rio para a integra‡Æo com Neogrid -*/
