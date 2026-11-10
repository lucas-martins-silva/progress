
     /* FAZER AQUI TRATAMENTO DE CONTROLE DE VERSÇO ADEQUADO! */

     /* ********* EXECU€ÇO DAS PI - BEGIN ********* */
     IF (cTranAction = "upd" or
         cTranAction = "add":U) THEN DO:
          RUN PIUpsert.
     END.
     
     /*ALIMENTA€ÇO DOS ERROS OCORRIDOS NA EFETIVA€ÇO*/
     FOR EACH RowErrors:
         FIND FIRST cadast_msg NO-LOCK
              WHERE cadast_msg.cdn_msg = RowErrors.ErrorNumber NO-ERROR.
         IF AVAIL cadast_msg THEN DO:
             IF cadast_msg.idi_tip_msg = 1 /*Erro*/ THEN
                 /* INFORMA AO MESSAGE HANDLER UM ERRO QUE DEVE ESTAR PRESENTE NA MENSAGEM DE RETORNO */
                 RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                  INPUT "business_error",
                                                  INPUT ErrorDescription).
             ELSE DO:
                 IF cadast_msg.idi_tip_msg = 2 /*Aviso*/      OR
                    cadast_msg.idi_tip_msg = 4 /*Informa‡Æo*/ THEN
                     /* INFORMA AO MESSAGE HANDLER UM ERRO QUE DEVE ESTAR PRESENTE NA MENSAGEM DE RETORNO */
                     RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                      INPUT "business_warning",
                                                      INPUT ErrorDescription).
             END.
         END.
     END.
     
     /* Retorno da API de Efetiva‡Æo */
     IF hMessageHandler:GET-SIGNATURE("setExtraInformation":U) <> "":U THEN DO:
        FOR EACH tt-edital:
            RUN setExtraInformation IN hMessageHandler ("Status Edital ":U + tt-edital.cod-edital + " - Lote ":U + STRING(tt-edital.numero-ordem),
                                                        IF tt-edital.i-status = 2 THEN "OK":U ELSE "NOK":U).
        END.
     END.
           
     /* OBTEM UMA MENSAGEM DE RETORNO - SENDO ELA DE ERRO OU DE CONFIRMA€ÇO */
     RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML).
     /* ********* EXECU€ÇO DAS PI - END ********* */


