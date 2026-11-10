

 /* axrvd003Delete.i ELIMINAÄ«O DE PEDIDOS DE VENDA ->>  */

  EMPTY TEMP-TABLE RowErrors NO-ERROR.

      IF SEARCH("pdp/pdapi500.r":U) <> ? THEN DO:

        RUN pdp/pdapi500.p (INPUT  cTranAction,
                            input  0,
                            INPUT  TABLE tt-ped-venda,
                            INPUT  TABLE tt-ped-item,
                            INPUT  TABLE tt-desc-ped-item,
                            INPUT  TABLE tt-ped-ent,
                            INPUT  TABLE tt-unid-neg-ped,
                            INPUT  TABLE tt-cond-ped,
                            INPUT  TABLE tt-ped-repre,
                            INPUT  TABLE tt-ped-pag-antecipado,
                            INPUT  TABLE tt-pd-vendor,
                            OUTPUT TABLE RowErrors, 
                            OUTPUT TABLE ReturnOrderValues,
                            OUTPUT TABLE ReturnItemValues) .

        IF ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execuá∆o do programa */
          DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
             cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
          END.

          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-erro-ao-executar-o-programa  AS CHARACTER   NO-UNDO.
          DEFINE VARIABLE c-pelo-programa                AS CHARACTER   NO-UNDO.
          DEFINE VARIABLE c-durante-sua-execucao-ocorreu AS CHARACTER   NO-UNDO.
          {utp/ut-liter.i "Erro_de_integraá∆o._Erro_ao_executar_o_programa" *}
          ASSIGN c-erro-ao-executar-o-programa = RETURN-VALUE.
          {utp/ut-liter.i "pelo_programa" *}
          ASSIGN c-pelo-programa = RETURN-VALUE. 
          {utp/ut-liter.i "Durante_sua_execuá∆o_ocorreu_o(s)_seguinte(s)_erro(s)_Progress:" *}
          ASSIGN c-durante-sua-execucao-ocorreu = RETURN-VALUE.

          RUN setError IN hMessageHandler (INPUT 0,
                                           INPUT "enviroment_error":U,
                                           INPUT c-erro-ao-executar-o-programa + ' pdp/pdapi500.p ' + c-pelo-programa +  ' adapters/xml/vd2/axrvd003.p. ' + c-durante-sua-execucao-ocorreu + cErrorText).
        END.
  END.
  ELSE DO:
       /* Programa de efetivaá∆o n∆o localizado */
      /* Inicio -- Projeto Internacional */

      DEFINE VARIABLE c-nao-foi-possivel-localizar-o-programa AS CHARACTER   NO-UNDO.
      DEFINE VARIABLE c-a-ser-executado-pelo-programa         AS CHARACTER   NO-UNDO.

      {utp/ut-liter.i "Erro_de_integraá∆o._Nío_foi_poss°vel_localizar_o_programa" *}
      ASSIGN c-nao-foi-possivel-localizar-o-programa = RETURN-VALUE.
      {utp/ut-liter.i "a_ser_executado_pelo_programa" *}
      ASSIGN c-a-ser-executado-pelo-programa = RETURN-VALUE.
      
      RUN setError IN hMessageHandler (INPUT 0,
                                       INPUT "enviroment_error":U,
                                       INPUT  c-nao-foi-possivel-localizar-o-programa + " pdp/pdapi500.p " + c-a-ser-executado-pelo-programa + " adapters/xml/vd2/axrvd003.p.").
  END.







