
     /* ********* EXECUÇÃO DAS PI - BEGIN ********* */
     IF (cTranAction = "add":U) OR (cTranAction = "upd":U) THEN 
          RUN PIUpsert.
     IF (cTranAction = "del":U) THEN 
          RUN PIDelete.

     IF CAN-FIND (FIRST RowErrors) OR CAN-FIND(FIRST tt_log_erro) THEN DO:
           FOR EACH RowErrors:
                 CREATE tt_log_erro.
                 ASSIGN tt_log_erro.ttv_num_cod_erro = RowErrors.ErrorNumber
                        tt_log_erro.ttv_des_msg_erro = RowErrors.ErrorDescription.
    
                 RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                  INPUT "business_error":U, 
                                                  INPUT RowErrors.ErrorDescription).
           END.
     END.
     ELSE DO:
            /* Operacional Textil - Publicando Numero da Ordem */
            FIND FIRST tt-ordem-compra NO-ERROR.
            IF AVAIL tt-ordem-compra AND
               hMessageHandler:GET-SIGNATURE("setExtraInformation":U) <> "":U AND 
               tt-ordem-compra.numero-ordem <> 0 THEN DO:
        
        /*         RUN setExtraInformation IN hMessageHandler ("POLineNumber":U, tt-ordem-compra.numero-ordem). */
                IF NOT VALID-HANDLE(h-axnsu002) THEN
                    run adapters/xml/su2/axnsu002.p persistent set  h-axnsu002 (output table tt_log_erro).
        
                run PITransUpsert in h-axnsu002 (input table tt-ordem-compra,
                                                 input i-ordem-externa, 
                                                 input "ntf":U, 
                                                 output table tt_log_erro ).
                for each tt_log_erro no-lock:
                    run utp/ut-msgs.p (input "msg", 
                                       input 17006,
                                       input tt_log_erro.ttv_des_msg_erro  ).
        
                    RUN setError IN hMessageHandler (INPUT 17009,
                                                     INPUT "business_error":U, 
                                                     INPUT tt_log_erro.ttv_des_msg_erro).
                end.
                IF VALID-HANDLE(h-axnsu002) THEN
                    DELETE PROCEDURE h-axnsu002.
            END.
     END.

    /* --- Knupp - Seta para o Adapter que a transacao contem Erro --- */
    IF CAN-FIND(FIRST tt_log_erro) THEN 
            ASSIGN lSuccessProcess = NO
                   cReturnValue   = "NOK".

    /* Obt‚m mensagem de retorno (erro ou confirma‡Æo) */
    RUN getReturnMessage IN hMessageHandler (OUTPUT hOUTPUTXML). 
    
