
EMPTY TEMP-TABLE tt-erro.
EMPTY TEMP-TABLE tt-tarefa.
EMPTY TEMP-TABLE tt-projeto.

FOR EACH ttProjects:
   
    CREATE tt-projeto.
    ASSIGN tt-projeto.Id-projeto-atual = ttProjects.ActualProjectID 
           tt-projeto.id-projeto-novo  = ttProjects.NewProjectID
           tt-projeto.id-tt-projeto    = ttProjects.ttProjectsID
           tt-projeto.ep-codigo        = &IF "{&mguni_version}" >= "2.071" &THEN ttProjects.CompanyCod &else int(ttProjects.CompanyCod) &ENDIF.
END.

FIND FIRST tt-projeto NO-ERROR.

FOR EACH ttTasks:
    IF CAN-FIND(FIRST tt-tarefa) THEN DO:
        FIND FIRST tt-tarefa
             WHERE tt-tarefa.id-solum-atual = ttTasks.ActualTaskID NO-ERROR.
        IF AVAIL tt-tarefa THEN DO:
            ASSIGN l-erro-encontrado = YES.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-id-tarefa AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "ID_Tarefa" *}
            ASSIGN c-lbl-liter-id-tarefa = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-ja-existe-para-id-projeto AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "j _existe_para_ID_Projeto" *}
            ASSIGN c-lbl-liter-ja-existe-para-id-projeto = TRIM(RETURN-VALUE).
            RUN setError IN hMessageHandler (INPUT 17006,
                                             input "business_error":U,
                                             INPUT c-lbl-liter-id-tarefa + ": " + ttTasks.ActualTaskID + " " + c-lbl-liter-ja-existe-para-id-projeto + ": " + tt-projeto.Id-projeto-atual).
        END.
        ELSE DO:
            CREATE tt-tarefa.
            ASSIGN tt-tarefa.id-solum-atual = ttTasks.ActualTaskID 
                   tt-tarefa.id-solum-novo  = ttTasks.NewTaskID 
                   tt-tarefa.id-tt-projeto  = ttTasks.ttProjectsID 
                   tt-tarefa.id-tt-task     = ttTasks.ttTasksID.
        END.

    END.
    ELSE DO:
        CREATE tt-tarefa.
        ASSIGN tt-tarefa.id-solum-atual = ttTasks.ActualTaskID 
               tt-tarefa.id-solum-novo  = ttTasks.NewTaskID 
               tt-tarefa.id-tt-projeto  = ttTasks.ttProjectsID 
               tt-tarefa.id-tt-task     = ttTasks.ttTasksID.
    END.

END.


IF NOT(l-erro-encontrado) THEN DO:
    RUN cdp/cdapi037.p (INPUT TABLE tt-projeto,
                        INPUT TABLE tt-tarefa,
                        OUTPUT TABLE tt-erro).
END.

if can-find(first tt-erro) then do:
    for each tt-erro:
        create tt_log_erro.
        assign tt_log_erro.ttv_num_cod_erro = tt-erro.cd-erro
               tt_log_erro.ttv_des_msg_ajuda = tt-erro.mensagem 
               tt_log_erro.ttv_des_msg_erro  = tt-erro.mensagem.
        RUN setError IN hMessageHandler (INPUT tt_log_erro.ttv_num_cod_erro,
                                         INPUT "business_error":U,
                                         INPUT tt_log_erro.ttv_des_msg_erro).
              
    end.
end.
