
     /* FAZER AQUI TRATAMENTO DE CONTROLE DE VERS홒 ADEQUADO! */

     /* ********* EXECU플O DAS PI - BEGIN ********* */
     IF (cTranAction = "add") OR (cTranAction = "mod") THEN DO:
          RUN PIUpsert.
     /* AQUI!! IMPLEMENTAR A CHAMADA A API DE EFETIVA플O */
     END.
     IF (cTranAction = "del") THEN DO:
          RUN PIDelete.
     /* AQUI!! IMPLEMENTAR A CHAMADA A API DE EFETIVA플O */
     END.



     /*ALIMENTA플O DOS ERROS OCORRIDOS NA EFETIVA플O*/
     /*FOR EACH tt_log_erro:
          /* INFORMA AO MESSAGE HANDLER UM ERRO QUE DEVE ESTAR PRESENTE NA MENSAGEM DE RETORNO */
          RUN setError IN hMessageHandler (INPUT tt_log_erro.ttv_num_cod_erro, INPUT "", INPUT tt_log_erro.ttv_des_msg_erro).
     END.*/


     /* OBTEM UMA MENSAGEM DE RETORNO - SENDO ELA DE ERRO OU DE CONFIRMA플O */
     RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML).
     /* ********* EXECU플O DAS PI - END ********* */
