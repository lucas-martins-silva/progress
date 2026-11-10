 
/* axrof001Delete.i ELIMINAÄ«O DE CLASSIFICAÄÂES FISCAIS ->>  */

  EMPTY TEMP-TABLE RowErrors NO-ERROR.

      IF SEARCH("cdp/cdapi603.r":U) <> ? OR SEARCH("cdp/cdapi603.p":U) <> ? THEN DO:

        IF CAN-FIND(FIRST tt-classif-fisc) THEN                    
        /* API de efetivaá∆o */
        RUN cdp/cdapi603.p (INPUT  cTranAction,
                            INPUT  TABLE tt-classif-fisc,
                            INPUT  ?, /* pExpItem */
                            INPUT  ?, /* pExpPedEmAberto*/
                            INPUT  ?, /* pExpPedAtendParc*/
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
      END.
      ELSE /* Programa de efetivaá∆o n∆o localizado */
           /* Inicio -- Projeto Internacional */
           DO:
           {utp/ut-liter.i "Erro_de_integraá∆o._N∆o_foi_poss°vel_localizar_o_programa_'cdp/cdapi603.p'_a_ser_executado_pelo_programa_adapters/xml/of2/axrof001.p" *}
           RUN setError IN hMessageHandler (INPUT 0,
                                            INPUT "enviroment_error":U,
                                            INPUT RETURN-VALUE + '.').
           END. 

