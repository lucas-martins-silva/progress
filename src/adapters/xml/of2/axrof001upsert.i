 
 /* axrof001Upsert.i INCLUS«O/ALTERAÄ«O DE CLASSIFICAÄÂES FISCAIS  ->>  */
  EMPTY TEMP-TABLE RowErrors NO-ERROR.

      IF SEARCH("cdp/cdapi603.r":U) <> ? OR SEARCH("cdp/cdapi603.p":U) <> ? THEN DO: 

        /* pExpItem - Exporta informaá‰es para os itens 1- Exporta p/ todos os itens; 2- Exporta conforme al°quota anterior; 3- N∆o exporta */
        IF cTranAction = "add":U THEN  ASSIGN pExpItem = 3. 

        IF cTranAction = "upd":U THEN DO:

           ASSIGN pExpItem = IF entry(1, replace(cTranEvent,";",",")) = "ExportToItens=1":U THEN 1 
                                ELSE IF entry(1, replace(cTranEvent,";",",")) = "ExportToItens=2":U THEN 2 ELSE 3.
        END.

        /* pExpPedEmAberto - Exporta informaá‰es para os pedidos em aberto */
        IF cTranAction = "add":U THEN ASSIGN pExpPedEmAberto = FALSE. 
        IF cTranAction = "upd":U THEN 
           ASSIGN pExpPedEmAberto = IF entry(2, replace(cTranEvent,";",",")) = "ExportToOpenedOrderLines=YES":U THEN TRUE 
                                    ELSE FALSE.

        /* pExpPedAtendParc - Exporta informaá‰es para os pedidos atendidos parcialmente */
        IF cTranAction = "add":U THEN ASSIGN pExpPedAtendParc = FALSE. 
        IF cTranAction = "upd":U THEN 
           ASSIGN pExpPedAtendParc = IF entry(3, replace(cTranEvent,";",",")) = "ExportToPartialProcessedOrderLines=YES":U THEN TRUE 
                                     ELSE FALSE.

        IF CAN-FIND(FIRST tt-classif-fisc) THEN
        /* API de efetivaá∆o */
        RUN cdp/cdapi603.p (INPUT  cTranAction,
                            INPUT  TABLE tt-classif-fisc,
                            INPUT  pExpItem,
                            INPUT  pExpPedEmAberto, 
                            INPUT  pExpPedAtendParc,
                            OUTPUT TABLE RowErrors) .


        IF ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execuá∆o do programa */
          DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:

             cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
          END.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Erro_de_integraá∆o._Erro_ao_executar_o_programa_'cdp/cdapi603.p'_pelo_programa_adapters/xml/of2/axrof001.p._Durante_sua_execuá∆o_ocorreu_o(s)_seguinte(s)_erro(s)_Progress" *}
          RUN setError IN hMessageHandler (INPUT 0,
                                           INPUT "enviroment_error":U,
                                           INPUT RETURN-VALUE + ': ' + cErrorText).
        END.

      END. /* search */
      ELSE /* Programa de efetivaá∆o n∆o localizado */ 
          /* Inicio -- Projeto Internacional */
          DO:
          {utp/ut-liter.i "Erro_de_integraá∆o._N∆o_foi_poss°vel_localizar_o_programa_'cdp/cdapi603.p'_a_ser_executado_pelo_programa_adapters/xml/of2/axrof001.p" *}
          RUN setError IN hMessageHandler (INPUT 0,
                                           INPUT "enviroment_error":U,
                                           INPUT RETURN-VALUE + '.').
          END. 
