
     /* FAZER AQUI TRATAMENTO DE CONTROLE DE VERSÇO ADEQUADO! */

     /* ********* EXECU€ÇO DAS PI - BEGIN ********* */
     IF (cTranAction = "add") or (cTranAction = "upd") THEN DO:
          RUN PIUpsert.
     /* AQUI!! IMPLEMENTAR A CHAMADA A API DE EFETIVA€ÇO */
     END.

     /* OBTEM UMA MENSAGEM DE RETORNO - SENDO ELA DE ERRO OU DE CONFIRMA€ÇO */
     RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML).
     /* ********* EXECU€ÇO DAS PI - END ********* */


