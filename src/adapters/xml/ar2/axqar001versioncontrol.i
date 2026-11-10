
     /* FAZER AQUI TRATAMENTO DE CONTROLE DE VERS«O ADEQUADO! */

     /* ********* EXECUÄ«O DAS PI - BEGIN ********* */
     
     IF (cTranAction = "qry") THEN DO:
          RUN PIQuery.
         /* AQUI!! IMPLEMENTAR A CHAMADA A API DE EFETIVAÄ«O */

          /* AQUI!! IMPLEMENTAR O TRATAMENTO DA CONSULTA SOLICITADA E AP‡S EXECUTAR O MêTODO PARA PREPARAÄ«O DA MENSAGEM DE ENVIO*/
          /*CHAMADA A PI DE MONTAGEM DO ENVIO DA MENSAGEM */
          RUN PIQueryReturnType ( INPUT TABLE  tt-parametros,
                                  INPUT TABLE tt-item,
                                  INPUT TABLE tt-item-estab,  
                                  INPUT TABLE tt-saldo-custo).
                                  

          /*ENVIO DO RETORNO DA CONSULTA */
          RUN setQueryReturnContent IN hMessageHandler (INPUT hQueryReturnContent).
     END.


     /*ALIMENTAÄ«O DOS ERROS OCORRIDOS NA EFETIVAÄ«O*/
     FOR EACH tt_log_erro:
          /* INFORMA AO MESSAGE HANDLER UM ERRO QUE DEVE ESTAR PRESENTE NA MENSAGEM DE RETORNO */
          RUN setError IN hMessageHandler (INPUT tt_log_erro.ttv_num_cod_erro, 
                                           INPUT "business_error", 
                                           INPUT tt_log_erro.ttv_des_msg_erro).
     END.


     /* OBTEM UMA MENSAGEM DE RETORNO - SENDO ELA DE ERRO OU DE CONFIRMAÄ«O */
     RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML).
     /* ********* EXECUÄ«O DAS PI - END ********* */
