/* Upsert.i */
IF  SEARCH ("adbo/boad268.r":U) <> ? OR ("adbo/boad268.p":U) <> ? THEN DO:

    RUN adbo/boad268.p PERSISTENT SET h-boad268 NO-ERROR.

    RUN validateCreate IN h-boad268 (INPUT TABLE tt-transporte, OUTPUT TABLE tt-bo-erro, OUTPUT r-chave).

    IF  ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execu‡Æo do programa */
        DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
           cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
        END.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-erro-de-integracao   AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE c-pelo-programa        AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE c-durante-sua-execucao AS CHARACTER   NO-UNDO.

        {utp/ut-liter.i "Erro_de_integra‡Æo._Erro_ao_executar_o_programa" *}
        ASSIGN c-erro-de-integracao = RETURN-VALUE.
        {utp/ut-liter.i "pelo_programa" *}
        ASSIGN c-pelo-programa = RETURN-VALUE.
        {utp/ut-liter.i "Durante_sua_execu‡Æo_ocorreu_o(s)_seguinte(s)_erro(s)_de_Progress" *}
        ASSIGN c-durante-sua-execucao = RETURN-VALUE.

        RUN setError IN hMessageHandler (INPUT 0,
                                         INPUT "enviroment_error":U,
                                         INPUT c-Erro-de-integracao + ' adbo/boad268.p ' + c-pelo-programa + ' adapters/xml/ar2/axrvd007.p ' + '.' + c-durante-sua-execucao +  ': ' + cErrorText).
    END.

    FOR EACH tt-bo-erro:
        RUN setError IN hMessageHandler (INPUT tt-bo-erro.cd-erro,
                                         INPUT "business_error":U,  /* Erro de neg¢cio */
                                         INPUT tt-bo-erro.mensagem).
    END.
    IF VALID-HANDLE(h-boad268) THEN DO:
        DELETE PROCEDURE h-boad268.
        ASSIGN h-boad268 = ?.
    END.
END.
ELSE DO: /* Inicio -- Projeto Internacional */

    DEFINE VARIABLE c-nao-foi-possivel-localizar-o-programa AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-a-ser-executado-pelo-programa         AS CHARACTER   NO-UNDO.

    {utp/ut-liter.i "Erro_de_integra‡Æo._NÆo_foi_poss¡vel_localizar_o_programa" *}
    ASSIGN c-nao-foi-possivel-localizar-o-programa = RETURN-VALUE. 
    {utp/ut-liter.i "a_ser_executado_pelo_programa" *}
    ASSIGN c-a-ser-executado-pelo-programa = RETURN-VALUE.

    RUN setError IN hMessageHandler (INPUT 0,
                                     INPUT "enviroment_error":U,
                                     INPUT c-nao-foi-possivel-localizar-o-programa + ' adbo/boad268.p ' + c-a-ser-executado-pelo-programa + ' adapters/xml/ar2/axrvd007.p.').
END.
