
     /* FAZER AQUI TRATAMENTO DE CONTROLE DE VERSÇO ADEQUADO! */

     /* ********* EXECU€ÇO DAS PI - BEGIN ********* */
     IF (cTranAction = "add") or (cTranAction = "upd") THEN DO:
          RUN PIUpsert.
     /* AQUI!! IMPLEMENTAR A CHAMADA A API DE EFETIVA€ÇO */
     END.
     IF (cTranAction = "del") THEN DO:
          RUN PIDelete.
     /* AQUI!! IMPLEMENTAR A CHAMADA A API DE EFETIVA€ÇO */
     END.



     /*ALIMENTA€ÇO DOS ERROS OCORRIDOS NA EFETIVA€ÇO*/
     /*FOR EACH tt_log_erro:
          /* INFORMA AO MESSAGE HANDLER UM ERRO QUE DEVE ESTAR PRESENTE NA MENSAGEM DE RETORNO */
          RUN setError IN hMessageHandler (INPUT tt_log_erro.ttv_num_cod_erro, INPUT "business_error", INPUT tt_log_erro.ttv_des_msg_erro).
     END.*/
     
     IF CAN-FIND(FIRST tt_log_erro) THEN DO:
       IF NOT(l-transacao) THEN DO:
           FOR EACH tt_log_erro:
               RUN setError IN hMessageHandler (INPUT tt_log_erro.ttv_num_cod_erro,
                                                INPUT tt_log_erro.ttv_des_msg_ajuda,
                                                INPUT tt_log_erro.ttv_des_msg_erro).
           END.
       END.
       ELSE DO:
           FOR EACH tt_log_erro
              WHERE tt_log_erro.ttv_des_msg_ajuda = "business_error":U:
               RUN setError IN hMessageHandler (INPUT tt_log_erro.ttv_num_cod_erro,
                                                INPUT tt_log_erro.ttv_des_msg_ajuda,
                                                INPUT tt_log_erro.ttv_des_msg_erro).
           END.
       END.

     END.
         
           
     IF NOT CAN-FIND(FIRST tt_log_erro WHERE tt_log_erro.ttv_des_msg_ajuda = "business_error":U) THEN DO:
         IF hMessageHandler:GET-SIGNATURE("setExtraInformation":U) <> "" THEN DO:
             RUN setExtraInformation IN hMessageHandler("RequisitionNumber":U,i-nr-requisicao).
             /*Empresa e IDMovimento apenas para RM Solum*/
             IF l-funcao-rm THEN DO:
                 RUN setExtraInformation IN hMessageHandler("CompanyCode":U,CompanyCode_00).
                 RUN setExtraInformation IN hMessageHandler("IDMov":U,IDMov_00).
             END.
             FOR EACH tt-r-it-requisicao:
                 RUN setExtraInformation IN hMessageHandler("ItemCode":U,tt-r-it-requisicao.it-codigo).
                 RUN setExtraInformation IN hMessageHandler("Sequence":U,tt-r-it-requisicao.sequencia).
             END.
            
         END.
     END.
           
    
     /* OBTEM UMA MENSAGEM DE RETORNO - SENDO ELA DE ERRO OU DE CONFIRMA€ÇO */
     RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML).
     /* ********* EXECU€ÇO DAS PI - END ********* */


