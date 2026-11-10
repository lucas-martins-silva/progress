
     /* FAZER AQUI TRATAMENTO DE CONTROLE DE VERS«O ADEQUADO! */

     /* ********* EXECUÄ«O DAS PI - BEGIN ********* */
     IF (cTranAction = "add") or (cTranAction = "Upd") THEN DO:
         RUN PIUpsert.

         IF NOT AVAIL tt-inventario THEN
             FIND FIRST tt-inventario NO-ERROR.

         FOR EACH ttCount:
             CASE ttCount.Sequence:
                 WHEN 1 THEN
                      ASSIGN tt-inventario.val-apurado[1] = ttCount.Quantity
                             tt-inventario.cod-confte-contag-1 = ttCount.LecturerUser.
                 WHEN 2 THEN
                      ASSIGN tt-inventario.val-apurado[2] = ttCount.Quantity
                             tt-inventario.cod-confte-contag-2 = ttCount.LecturerUser.
                 WHEN 3 THEN
                      ASSIGN tt-inventario.val-apurado[3] = ttCount.Quantity
                             tt-inventario.cod-confte-contag-3 = ttCount.LecturerUser.
             END CASE.      
         END.

         IF NOT VALID-HANDLE(h-boin157fx) THEN 
             RUN inbo/boin157fx.p PERSISTENT SET h-boin157fx.

         RUN createUpdateCount IN h-boin157fx (INPUT TABLE tt-inventario,
                                               OUTPUT TABLE RowErrors).

         FOR EACH RowErrors:
            RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber, INPUT "business_error", INPUT RowErrors.ErrorDescription).
         END.
     END.

     IF (cTranAction = "del") THEN DO:
         {utp/ut-liter.i "Para_esta_integraá∆o_n∆o_Ç_permitido_excluir_registros" *}
         RUN setError IN hMessageHandler (INPUT 17006, INPUT "business_error", INPUT RETURN-VALUE).
     END.

     /* OBTEM UMA MENSAGEM DE RETORNO - SENDO ELA DE ERRO OU DE CONFIRMAÄ«O */
     RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML).
     /* ********* EXECUÄ«O DAS PI - END ********* */


