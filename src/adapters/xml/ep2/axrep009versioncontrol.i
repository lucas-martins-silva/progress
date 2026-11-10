
     /* FAZER AQUI TRATAMENTO DE CONTROLE DE VERSÃO ADEQUADO! */

     /* ********* EXECU€ÇO DAS PI - BEGIN ********* */
     IF (cTranAction = "add") or (cTranAction = "mod") THEN
        RUN PIUpsert.
     
     
     /*ALIMENTA€ÇO DOS ERROS OCORRIDOS NA EFETIVA€ÇO*/
     /*FOR EACH tt_log_erro:
          /* INFORMA AO MESSAGE HANDLER UM ERRO QUE DEVE ESTAR PRESENTE NA MENSAGEM DE RETORNO */
          RUN setError IN hMessageHandler (INPUT tt_log_erro.ttv_num_cod_erro, INPUT "", INPUT tt_log_erro.ttv_des_msg_erro).
     END.*/

     IF  CAN-FIND (FIRST RowErrors) THEN /* Erros ocorridos durante efetiva‡Æo do registro */
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

     
     /* OBTEM UMA MENSAGEM DE RETORNO - SENDO ELA DE ERRO OU DE CONFIRMA€ÇO */
     RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML).
     /* ********* EXECU€ÇO DAS PI - END ********* */


