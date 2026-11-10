/* axrsu002Upsert.i INCLUS«O/ALTERAÄ«O DE ORDENS DE COMPRA ->>  */

  FIND FIRST param-compra NO-LOCK NO-ERROR.

  IF l-integra-portal THEN DO:

    &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
       IF SUBSTRING(param-compra.CHAR-2,102,1) = "s":U AND
            CAN-FIND(FIRST ttDestinationPartner
                        WHERE ttDestinationPartner.CodDestination = "Webb":U) THEN DO:
						
           FIND FIRST  ordem-compra 
                 WHERE ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem EXCLUSIVE-LOCK NO-ERROR.
           IF AVAIL ordem-compra THEN
               ASSIGN overlay(ordem-compra.char-1,92,50) = substring(tt-ordem-compra.char-1,92,50).
               RELEASE ordem-compra.
           LEAVE.
       END.
      &ELSE
       IF param-compra.log-integr-portal AND
            CAN-FIND(FIRST ttDestinationPartner
                        WHERE ttDestinationPartner.CodDestination = "Webb":U) THEN DO:
           FIND FIRST  ordem-compra 
                 WHERE ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem EXCLUSIVE-LOCK NO-ERROR.
           IF AVAIL ordem-compra THEN
               ASSIGN ordem-compra.cod-ord-portal = tt-ordem-compra.cod-ord-portal.
               RELEASE ordem-compra.
           LEAVE.
       END.
      &ENDIF
  END.
  

  EMPTY TEMP-TABLE ttErrors NO-ERROR.

  IF SEARCH("ccp/ccapi331.r":U) <> ? THEN DO:  

      /* --- Knupp - Validaá∆o do Item --- */
      FOR EACH tt-prazo-compra:
          for first item fields(it-codigo) where 
              item.it-codigo = tt-prazo-compra.it-codigo no-lock: end.
          if  not avail item then do:
              run utp/ut-msgs.p (input "msg":U,
                                 input 6806,
                                 input "":U).
              CREATE tt_log_erro.
              ASSIGN tt_log_erro.ttv_num_cod_erro = 6806
                     tt_log_erro.ttv_des_msg_erro = return-value.
              RUN setError IN hMessageHandler (INPUT 6806,
                                               INPUT "business_error":U, 
                                               INPUT return-value).
          end.
      END.

      /* --- Busca pela Unidade de Medida --- */
        FOR FIRST param-mat NO-LOCK:
            IF param-mat.ind-sit-un = 2 THEN DO:
                FOR EACH tt-prazo-compra:
                    /* UN Default */
                    for first item fields(it-codigo un) where 
                        item.it-codigo = tt-prazo-compra.it-codigo no-lock: end.
                    if  avail item 
                        then assign tt-prazo-compra.un = item.un.
                        else assign tt-prazo-compra.un = "".
                END.
            END.
        END.

        IF NOT VALID-HANDLE(h-ccapi331) THEN
            RUN ccp/ccapi331.p PERSISTEN SET h-ccapi331    (INPUT  cTranAction,
                                                            INPUT  TABLE tt-ordem-compra,
                                                            INPUT  TABLE tt-prazo-compra,
                                                            OUTPUT TABLE ttErrors ) NO-ERROR. 

        IF ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execuá∆o do programa */
          DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
             cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
          END.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Erro_de_integraá∆o._Erro_ao_executar_o_programa_'ccp/ccapi331.p'_pelo_programa_adapters/xml/su2/axrsu002.p._Durante_sua_execuá∆o_ocorreu_o(s)_seguinte(s)_erro(s)_Progress" *}
          RUN setError IN hMessageHandler (INPUT 0,
                                           INPUT "enviroment_error":U,
                                           INPUT RETURN-VALUE + ': ' + cErrorText).
          CREATE tt_log_erro.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Erro_de_integraá∆o._Erro_ao_executar_o_programa_'ccp/ccapi331.p'_pelo_programa_adapters/xml/su2/axrsu002.p._Durante_sua_execuá∆o_ocorreu_o(s)_seguinte(s)_erro(s)_Progress" *}
          ASSIGN tt_log_erro.ttv_num_cod_erro = 0
                 tt_log_erro.ttv_des_msg_erro = RETURN-VALUE + ': ' + cErrorText.
        END.
        ELSE DO: /* Erros ocorridos durante efetivaá∆o do registro */
            FOR EACH ttErrors WHERE ttErrors.errorSubType = "ERROR":U :
                 RUN setError IN hMessageHandler (INPUT ttErrors.errorNumber,
                                                  INPUT "business_error":U,  /* Erro de neg¢cio */
                                                  INPUT ttErrors.errorDescription).
                 CREATE tt_log_erro.
                 ASSIGN tt_log_erro.ttv_num_cod_erro = ttErrors.errorNumber
                        tt_log_erro.ttv_des_msg_erro = ttErrors.errorDescription.
            END.
        END.

        IF VALID-HANDLE(h-ccapi331) THEN DO:
            RUN pi-retorna-ordem-compra IN h-ccapi331 (OUTPUT TABLE tt-ordem-compra) NO-ERROR. 
            DELETE PROCEDURE h-ccapi331.
            ASSIGN h-ccapi331 = ?.
        END.
  END.
  ELSE DO: /* Programa de efetivaá∆o n∆o localizado */
       CREATE tt_log_erro.
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Erro_de_integraá∆o._N∆o_foi_poss°vel_localizar_o_programa_'ccp/ccapi331.p'_a_ser_executado_pelo_programa_adapters/xml/su2/axrsu002.p" *}
       ASSIGN tt_log_erro.ttv_num_cod_erro = 0
              tt_log_erro.ttv_des_msg_erro = RETURN-VALUE + '.'.

       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Erro_de_integraá∆o._N∆o_foi_poss°vel_localizar_o_programa_'ccp/ccapi331.p'_a_ser_executado_pelo_programa_adapters/xml/su2/axrsu002.p" *}
       RUN setError IN hMessageHandler (INPUT 0,
                                        INPUT "enviroment_error":U,
                                        INPUT RETURN-VALUE + '.').
  END.


    /* --- Knupp - Seta para o Adapter que a transacao contem Erro --- */
    FOR EACH ttErrors:
         CREATE tt_log_erro.
         ASSIGN tt_log_erro.ttv_num_cod_erro = ttErrors.errorNumber
                tt_log_erro.ttv_des_msg_erro = ttErrors.errorDescription.

        RUN setError IN hMessageHandler (INPUT ttErrors.errorNumber,
                                         INPUT "business_error":U,  /* Erro de neg¢cio */
                                         INPUT ttErrors.errorDescription).
    END.

    /* --- Knupp - Seta para o Adapter que a transacao contem Erro --- */
    IF CAN-FIND(FIRST tt_log_erro) THEN 
            ASSIGN lSuccessProcess = NO
                   cReturnValue   = "NOK".
