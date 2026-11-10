             empty temp-table tt-sub-div-ordem.

             for each ttListOfProjectPhases:
                 IF CAN-FIND(FIRST tt-sub-div-ordem) THEN DO:
                     FIND FIRST tt-sub-div-ordem
                          WHERE tt-sub-div-ordem.cod-id-solum = ttListOfProjectPhases.IdTask NO-ERROR.
                     IF AVAIL tt-sub-div-ordem THEN DO:
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
                                                          INPUT c-lbl-liter-id-tarefa + ": " + tt-sub-div-ordem.cod-id-solum + " " + c-lbl-liter-ja-existe-para-id-projeto + ": " + ProjectID).
    
                     END.
                     ELSE DO:
                         create tt-sub-div-ordem.
                         assign tt-sub-div-ordem.cod-id-solum = IF ttListOfProjectPhases.IdTask = ? THEN "" ELSE ttListOfProjectPhases.IdTask 
                                tt-sub-div-ordem.cod-sigla    = IF ttListOfProjectPhases.IdProject = ? THEN "" ELSE ttListOfProjectPhases.IdProject
                                tt-sub-div-ordem.num-ordem    = IF ttListOfProjectPhases.OrderNumber = ? THEN 0 ELSE ttListOfProjectPhases.OrderNumber
                                tt-sub-div-ordem.descricao    = IF ttListOfProjectPhases.DESCRIPTION = ? THEN "" ELSE ttListOfProjectPhases.Description.
                     END.
                 END.
                 ELSE DO:
                     create tt-sub-div-ordem.
                     assign tt-sub-div-ordem.cod-id-solum = IF ttListOfProjectPhases.IdTask = ? THEN "" ELSE ttListOfProjectPhases.IdTask 
                            tt-sub-div-ordem.cod-sigla    = IF ttListOfProjectPhases.IdProject = ? THEN "" ELSE ttListOfProjectPhases.IdProject
                            tt-sub-div-ordem.num-ordem    = IF ttListOfProjectPhases.OrderNumber = ? THEN 0 ELSE ttListOfProjectPhases.OrderNumber
                            tt-sub-div-ordem.descricao    = IF ttListOfProjectPhases.DESCRIPTION = ? THEN "" ELSE ttListOfProjectPhases.Description.
                 END.
             end.

            
             create tt-proj-inv.
             assign tt-proj-inv.ep-codigo         = CompanyCode
                    tt-proj-inv.cod-est-exec      = ExecutorSite
                    tt-proj-inv.num-projeto       = IF ProjectNumber = ? THEN 0 ELSE ProjectNumber
                    tt-proj-inv.sigla             = ProjectID
                    tt-proj-inv.descricao         = description
                    tt-proj-inv.cod-est-gestor    = ManagerSite
                    tt-proj-inv.cod-divisao       = IF DivisionCod = ? THEN 0 ELSE DivisionCod
                    tt-proj-inv.desc-divisao      = IF DivisionDescription = ? THEN "" ELSE DivisionDescription
                    tt-proj-inv.cod-ccusto        = IF CustCenterCod = ? THEN "" ELSE CustCenterCod
                    tt-proj-inv.desc-ccusto       = IF CustCenterDescription = ? THEN "" ELSE CustCenterDescription
                    tt-proj-inv.tp-projeto        = IF ProjectTypeCod = ? THEN 0 ELSE ProjectTypeCod
                    tt-proj-inv.desc-tp-projeto   = IF ProjectTypeDescription = ? THEN "" ELSE ProjectTypeDescription
                    tt-proj-inv.num-projeto-ant   = IF OldProject = ? THEN "" ELSE OldProject
                    tt-proj-inv.cod-situacao-proj = IF ProjectStatus = ? THEN 1 ELSE ProjectStatus
                    tt-proj-inv.dt-cadastro       = RegisterDate
                    tt-proj-inv.dt-atualizacao    = IF LastUpdate = ? THEN TODAY ELSE LastUpdate
                    tt-proj-inv.dt-prev-ini       = IF ForecastedStart = ? THEN TODAY ELSE ForecastedStart
                    tt-proj-inv.dt-prev-fim       = IF ForecastedEnd = ? THEN TODAY ELSE ForecastedEnd
                    tt-proj-inv.dt-trc-real       = IF RealROCDate = ? THEN TODAY ELSE RealROCDate
                    tt-proj-inv.trc-real          = IF RealROC = ? THEN 0 ELSE RealROC
                    tt-proj-inv.trc-previsto      = IF ROCForecast = ? THEN 0 ELSE ROCForecast
                    tt-proj-inv.cons-proj-modelo  = (UseProjectModel = "Yes")
                    tt-proj-inv.num-proj-modelo   = int(ProjectModelNumber)
                    tt-proj-inv.sigla-proj-modelo = IF ProjectModelId = ? THEN "" ELSE ProjectModelId
                    tt-proj-inv.usuario-atu       = IF UpdateUser = ? THEN "" ELSE UpdateUser.
                   /* tt-proj-inv.usuario-resp      = IF cUserID = ? THEN "" ELSE cUserID.*/
             


             
             if cTranAction = "add" then 
                  assign tt-proj-inv.ind-transacao = 1.
             else assign tt-proj-inv.ind-transacao = 2.

             for last tt-sub-div-ordem:
                 assign tt-proj-inv.cod-id-solum = tt-sub-div-ordem.cod-id-solum.
             end.
             
             IF NOT(l-erro-encontrado) THEN DO:
                 run cdp/cdapi036.p (input table tt-proj-inv,
                                     input table tt-sub-div-ordem,
                                     output table tt-erro,
                                     output table tt-retorno-efetiv).
             END.
             if can-find(first tt-erro) then do:
                for each tt-erro:
                    create tt_log_erro.
                    assign tt_log_erro.ttv_num_cod_erro = tt-erro.cd-erro
                           tt_log_erro.ttv_des_msg_ajuda = tt-erro.mensagem 
                           tt_log_erro.ttv_des_msg_erro  = tt-erro.mensagem.

                    RUN setError IN hMessageHandler (INPUT tt_log_erro.ttv_num_cod_erro,
                                                     input "enviroment_error":U,
                                                     INPUT tt_log_erro.ttv_des_msg_erro).
                          
                end.
             end.

