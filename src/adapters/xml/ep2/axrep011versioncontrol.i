
     /* FAZER AQUI TRATAMENTO DE CONTROLE DE VERS홒 ADEQUADO! */

     /* ********* EXECU플O DAS PI - BEGIN ********* */
     IF (cTranAction = "add") or (cTranAction = "mod") THEN
          RUN PIUpsert.
     /* AQUI!! IMPLEMENTAR A CHAMADA A API DE EFETIVA플O */
     

     IF  CAN-FIND (FIRST RowErrors) THEN /* Erros ocorridos durante efetiva눯o do registro */
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

     /*ALIMENTA플O DOS ERROS OCORRIDOS NA EFETIVA플O*/
     /*FOR EACH tt_log_erro:
          /* INFORMA AO MESSAGE HANDLER UM ERRO QUE DEVE ESTAR PRESENTE NA MENSAGEM DE RETORNO */
          RUN setError IN hMessageHandler (INPUT tt_log_erro.ttv_num_cod_erro, INPUT "", INPUT tt_log_erro.ttv_des_msg_erro).
     END.*/


     /* OBTEM UMA MENSAGEM DE RETORNO - SENDO ELA DE ERRO OU DE CONFIRMA플O */
     RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML).
     /* ********* EXECU플O DAS PI - END ********* */


