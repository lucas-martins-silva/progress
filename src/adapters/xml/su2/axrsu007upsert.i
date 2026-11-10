    EMPTY TEMP-TABLE RowErrors NO-ERROR.
    EMPTY TEMP-TABLE tt_log_erro NO-ERROR.
    
    ASSIGN l-erro = NO.
    
    
    /*Verifica funá∆o RM Solum*/
    FIND FIRST funcao 
            WHERE funcao.cd-funcao = "spp-rm-solum" NO-LOCK NO-ERROR.
    IF AVAIL funcao THEN DO:
        IF funcao.ativo = YES THEN
            ASSIGN l-funcao-rm = YES.
    END.

    FOR EACH ttPurchaseRequestLine:
       /*Validaá‰es apenas para RM Solum*/
       IF l-funcao-rm THEN DO:
               
                FIND FIRST empresa
                     WHERE empresa.ep-codigo = ttPurchaseRequestLine.CompanyCode NO-LOCK NO-ERROR.
                IF NOT AVAIL empresa THEN DO:
                    ASSIGN l-erro = YES.
                    CREATE tt_log_erro.
                    ASSIGN ttv_num_cod_erro  = 31768    
                           ttv_des_msg_ajuda = "business_error":U       
                           ttv_des_msg_erro  = "Empresa " + string(ttPurchaseRequestLine.CompanyCode) + " n∆o cadastrada.".
                END.
    
                IF ttPurchaseRequestLine.IDTask = "" OR ttPurchaseRequestLine.IDTask = ? THEN DO:
                    ASSIGN l-erro = YES.
                    CREATE tt_log_erro.
                    ASSIGN ttv_num_cod_erro  = 265    
                           ttv_des_msg_ajuda = "business_error":U     
                           ttv_des_msg_erro  = "ID Tarefa deve ser informada.".
                END.
    
                IF ttPurchaseRequestLine.IDProject = ""  OR ttPurchaseRequestLine.IDProject = ? THEN DO:
                    ASSIGN l-erro = YES.
                    CREATE tt_log_erro.
                    ASSIGN ttv_num_cod_erro  = 265    
                           ttv_des_msg_ajuda = "business_error":U       
                           ttv_des_msg_erro  = "ID Projeto deve ser informado.".
                END.

                 /* Tratamento RM Solum - Quando data for menor que today, assume today*/
                 IF cTranAction = "upd" THEN DO:
                    IF ttPurchaseRequestLine.DeliveryDate < TODAY THEN
                      ASSIGN ttPurchaseRequestLine.DeliveryDate = TODAY. 
                 END.
       END.

    END.
    IF NOT l-erro THEN DO:
        RUN inbo/boin168.p PERSISTENT SET h-boin168.
        RUN pi-carrega-temp-tables.
        
        IF NOT l-erro THEN DO:
            CASE cTranAction:
               WHEN "add" THEN DO:
                   
                 SOLICITACAO:
                 DO TRANSACTION ON ERROR UNDO, LEAVE:
                 
                    /*Bo validaá∆o requisiá∆o*/
                    RUN inbo/boin385.p PERSISTENT SET h-boin385.
                    RUN openQueryStatic IN h-boin385 (INPUT "Main").
                    /*retorna n£mero da pr¢xima requisiá∆o*/
                    RUN proximaRequisicao IN h-boin385(OUTPUT i-nr-requisicao).
                    ASSIGN tt-requisicao.nr-requisicao = i-nr-requisicao.
                    FOR EACH tt-it-requisicao:
                        ASSIGN tt-it-requisicao.nr-requisicao = i-nr-requisicao.  
                    END.
                    
                    RUN setRecord    in h-boin385(input table tt-requisicao).
                    RUN createRecord in h-boin385.
                    RUN getRowErrors IN h-boin385(OUTPUT TABLE RowErrors).
                    IF CAN-FIND(FIRST RowErrors) THEN
                        RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                    ELSE DO:
                        RUN getRecord IN h-boin385(OUTPUT TABLE tt-r-requisicao).
                        FIND FIRST tt-r-requisicao NO-ERROR.
                        IF AVAIL tt-r-requisicao THEN
                            ASSIGN i-nr-req = tt-r-requisicao.nr-requisicao.
                        
                        
                        RUN inbo/boin168.p PERSISTENT SET h-boin168.
                        RUN openQueryStatic    IN h-boin168 (INPUT "Main").
        
                        FOR EACH tt-it-requisicao: 
                            EMPTY TEMP-TABLE tt-it-requisicao-aux.
        
                            CREATE tt-it-requisicao-aux.
                            BUFFER-COPY tt-it-requisicao TO tt-it-requisicao-aux.

                            /*Matriz unidade de neg¢cio*/
                            FOR EACH ttBusinessUnit WHERE ttBusinessUnit.ttPurchaseRequestLineID = tt-it-requisicao.ttPurchaseRequestLineID:
                                IF ttBusinessUnit.BusinessUnitID <> "" AND ttBusinessUnit.BusinessUnitID <> ? THEN DO:
                                    ASSIGN tt-it-requisicao-aux.cod-unid-negoc = "".
                                    CREATE tt-matriz.
                                    ASSIGN tt-matriz.cod-unid-neg = ttBusinessUnit.BusinessUnitID
                                           tt-matriz.perc-rateio  = ttBusinessUnit.BusinessUnitPercentage.
                                END.
                            END.

                            RUN emptyRowErrors     IN h-boin168.
                            RUN newRecord  IN h-boin168.
                            RUN setRecord  IN h-boin168(input table tt-it-requisicao-aux).
                            RUN pi-sugere-ct-contabil IN h-boin168(INPUT tt-it-requisicao-aux.it-codigo,INPUT tt-it-requisicao-aux.nome-abrev,
                                                                   INPUT tt-it-requisicao-aux.cod-estabel,INPUT tt-it-requisicao-aux.num-ord-inv,OUTPUT c-ct-contabil).

                            RUN validate-record-rm IN h-boin168(INPUT "CREATE":U,
                                                                INPUT TABLE tt-matriz).
                            RUN getRowErrors  IN h-boin168(OUTPUT TABLE RowErrors).
                            IF CAN-FIND(FIRST RowErrors) THEN
                                RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).

                            IF NOT l-erro THEN DO:
                                RUN createRecord IN h-boin168.
                                RUN getRowErrors  IN h-boin168(OUTPUT TABLE RowErrors).
                                RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                                IF NOT l-erro THEN DO:
                                    RUN getRecord IN h-boin168 (OUTPUT TABLE tt-it-requisicao-aux).
                                    FIND FIRST tt-it-requisicao-aux NO-LOCK.
                                    RUN pi-aprovacao-eletronica IN h-boin168 (INPUT tt-it-requisicao-aux.r-rowid).
                                    RUN pi-unidade-negocio-matriz IN h-boin168 (INPUT tt-it-requisicao-aux.r-rowid,
                                                                                INPUT TABLE tt-matriz).

                                    EMPTY TEMP-TABLE tt-matriz.
                                    RUN pi-invest    IN h-boin168(INPUT "CREATE":U).
                                    RUN getRowErrors  IN h-boin168(OUTPUT TABLE RowErrors).
                                    RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                                    IF NOT l-erro THEN DO:
                                        RUN getRecord    IN h-boin168(OUTPUT TABLE tt-it-requisicao-aux).
                                        FIND FIRST tt-it-requisicao-aux.
                                        IF AVAIL tt-it-requisicao-aux THEN DO:
                                            CREATE tt-r-it-requisicao.
                                            BUFFER-COPY tt-it-requisicao-aux TO tt-r-it-requisicao.
                                        END.
                                    END.
                                END.
                            END.
                        
                        END.
                        IF NOT l-erro THEN DO:
                            IF AVAIL tt-it-requisicao-aux THEN DO:
                                RUN pi-aprovacao-eletronica-total IN h-boin168 (INPUT tt-it-requisicao-aux.r-rowid).
                                RUN getRowErrors  IN h-boin168(OUTPUT TABLE RowErrors).
                                IF CAN-FIND(FIRST RowErrors) THEN
                                    RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                            END.
                        END.

                    END.
                    DELETE PROCEDURE h-boin168.
                    IF CAN-FIND(FIRST tt_log_erro WHERE tt_log_erro.ttv_des_msg_ajuda = "business_error":U) THEN DO:
                        ASSIGN l-transacao = YES.
                        UNDO SOLICITACAO, LEAVE.
                        
                    END.
                 END.
               END.
               WHEN "upd" THEN DO:
                    FIND FIRST requisicao
                         WHERE requisicao.nr-requisicao = RequisitionNumber EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAIL requisicao THEN DO:
                        CREATE tt_log_erro.
                        ASSIGN ttv_num_cod_erro  = 2    
                               ttv_des_msg_ajuda = "business_error":U       
                               ttv_des_msg_erro  = "N∆o encontrada Requisiá∆o para a chave informada.".
                    END.
                    ELSE DO:
                        ASSIGN i-nr-requisicao = RequisitionNumber.
                        RUN inbo/boin385.p PERSISTENT SET h-boin385.
                        RUN openQueryStatic IN h-boin385 (INPUT "Main").
                        RUN goToKeyRequisicao IN h-boin385(INPUT tt-requisicao.nr-requisicao).
                        RUN setRecord    in h-boin385(input table tt-requisicao).
                        RUN updateRecord in h-boin385.
                        RUN getRowErrors IN h-boin385(OUTPUT TABLE RowErrors).
                        IF CAN-FIND(FIRST RowErrors) THEN
                            RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                        
                        IF NOT l-erro THEN DO:
                            RUN getRecord IN h-boin385(OUTPUT TABLE tt-r-requisicao).
                            /*FIND FIRST tt-it-requisicao NO-LOCK.
                            RUN pi-aprovacao-eletronica IN h-boin168 (INPUT tt-it-requisicao.r-rowid).
                            RUN getRowErrors IN h-boin385(OUTPUT TABLE RowErrors).
                            RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).*/
                        END.

                        FIND FIRST ttPurchaseRequestLine NO-ERROR.
                        /*situaá∆o desenvolvida para RM*/
                        IF l-funcao-rm THEN DO:
                                   
                                
                                
                                /*busca centro de custo*/
                                FIND FIRST ttPurchaseRequestLine NO-ERROR.
                                IF AVAIL ttPurchaseRequestLine THEN DO:
                                    run cdp/cdapi036a.p (input int(ttPurchaseRequestLine.CompanyCode),
                                                         INPUT ttPurchaseRequestLine.Site,
                                                         INPUT ttPurchaseRequestLine.IDProject,
                                                         OUTPUT c-centro-custo).
                                END.

                                

                                RUN inbo/boin168.p PERSISTENT SET h-boin168.
                                RUN openQueryStatic    IN h-boin168 (INPUT "Main").
        
                                FOR EACH tt-it-requisicao: 
                                    
                                    EMPTY TEMP-TABLE tt-it-requisicao-aux.
                
                                    CREATE tt-it-requisicao-aux.
                                    BUFFER-COPY tt-it-requisicao TO tt-it-requisicao-aux.
                                    ASSIGN tt-it-requisicao-aux.sc-codigo = c-centro-custo.
                                    
                                    /*Matriz unidade de neg¢cio*/
                                    FOR EACH ttBusinessUnit WHERE ttBusinessUnit.ttPurchaseRequestLineID = tt-it-requisicao.ttPurchaseRequestLineID:
                                        IF ttBusinessUnit.BusinessUnitID <> "" AND ttBusinessUnit.BusinessUnitID <> ? THEN DO:
                                            ASSIGN tt-it-requisicao-aux.cod-unid-negoc = "".
                                            CREATE tt-matriz.
                                            ASSIGN tt-matriz.cod-unid-neg = ttBusinessUnit.BusinessUnitID
                                                   tt-matriz.perc-rateio  = ttBusinessUnit.BusinessUnitPercentage.
                                        END.
                                    END.
        
                                    RUN emptyRowErrors     IN h-boin168.
                                    RUN newRecord  IN h-boin168.
                                    RUN setRecord  IN h-boin168(input table tt-it-requisicao-aux).
                                    RUN pi-sugere-ct-contabil IN h-boin168(INPUT tt-it-requisicao-aux.it-codigo,INPUT tt-it-requisicao-aux.nome-abrev,
                                                                           INPUT tt-it-requisicao-aux.cod-estabel,INPUT tt-it-requisicao-aux.num-ord-inv,OUTPUT c-ct-contabil).

                                    
                                    RUN validate-record-rm IN h-boin168(INPUT "CREATE":U,
                                                                        INPUT TABLE tt-matriz).
                                    RUN getRowErrors  IN h-boin168(OUTPUT TABLE RowErrors).
                                    IF CAN-FIND(FIRST RowErrors) THEN
                                        RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
        
                                    IF NOT l-erro THEN DO:
                                        RUN createRecord IN h-boin168.
                                        RUN getRowErrors  IN h-boin168(OUTPUT TABLE RowErrors).
                                        RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                                        IF NOT l-erro THEN DO:
                                            RUN getRecord IN h-boin168 (OUTPUT TABLE tt-it-requisicao-aux).
                                            FIND FIRST tt-it-requisicao-aux NO-LOCK.
                                            RUN pi-aprovacao-eletronica IN h-boin168 (INPUT tt-it-requisicao-aux.r-rowid).
                                            RUN pi-unidade-negocio-matriz IN h-boin168 (INPUT tt-it-requisicao-aux.r-rowid,
                                                                                        INPUT TABLE tt-matriz).
        
                                            EMPTY TEMP-TABLE tt-matriz.
                                            RUN pi-invest    IN h-boin168(INPUT "CREATE":U).
                                            RUN getRowErrors  IN h-boin168(OUTPUT TABLE RowErrors).
                                            RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                                            IF NOT l-erro THEN DO:
                                                RUN getRecord    IN h-boin168(OUTPUT TABLE tt-it-requisicao-aux).
                                                FIND FIRST tt-it-requisicao-aux.
                                                IF AVAIL tt-it-requisicao-aux THEN DO:
                                                    CREATE tt-r-it-requisicao.
                                                    BUFFER-COPY tt-it-requisicao-aux TO tt-r-it-requisicao.
                                                END.
                                            END.
                                        END.
                                    END.
                                
                                END.
                                IF NOT l-erro THEN DO:
                                    IF AVAIL tt-it-requisicao-aux THEN DO:
                                        RUN pi-aprovacao-eletronica-total IN h-boin168 (INPUT tt-it-requisicao-aux.r-rowid).
                                        RUN getRowErrors  IN h-boin168(OUTPUT TABLE RowErrors).
                                        IF CAN-FIND(FIRST RowErrors) THEN
                                            RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                                    END.
                                END.
        
                            /*END.*/
                            DELETE PROCEDURE h-boin168.
                        END.
                        ELSE DO:
                            FOR EACH tt-it-requisicao:
                                FIND FIRST it-requisicao
                                     WHERE it-requisicao.nr-requisicao = tt-it-requisicao.nr-requisicao
                                       AND it-requisicao.sequencia     = tt-it-requisicao.sequencia 
                                       AND it-requisicao.it-codigo     = tt-it-requisicao.it-codigo EXCLUSIVE-LOCK NO-ERROR. 
                                IF NOT AVAIL it-requisicao THEN DO:
                                    
                                    EMPTY TEMP-TABLE tt-it-requisicao-aux.
        
                                    CREATE tt-it-requisicao-aux.
                                    BUFFER-COPY tt-it-requisicao TO tt-it-requisicao-aux.

                                    /*Matriz unidade de neg¢cio*/
                                    FOR EACH ttBusinessUnit WHERE ttBusinessUnit.ttPurchaseRequestLineID = tt-it-requisicao.ttPurchaseRequestLineID:
                                        IF ttBusinessUnit.BusinessUnitID <> "" AND ttBusinessUnit.BusinessUnitID <> ? THEN DO:
                                            ASSIGN tt-it-requisicao-aux.cod-unid-negoc = "".
                                            CREATE tt-matriz.
                                            ASSIGN tt-matriz.cod-unid-neg = ttBusinessUnit.BusinessUnitID
                                                   tt-matriz.perc-rateio  = ttBusinessUnit.BusinessUnitPercentage.
                                        END.
                                    END.
    
                                    RUN inbo/boin168.p PERSISTENT SET h-boin168.
                                    RUN openQueryStatic    IN h-boin168 (INPUT "Main").
                                    RUN setRecord          IN h-boin168(input table tt-it-requisicao-aux).
                                    RUN pi-sugere-ct-contabil IN h-boin168(INPUT tt-it-requisicao-aux.it-codigo,INPUT tt-it-requisicao-aux.nome-abrev,
                                                                           INPUT tt-it-requisicao-aux.cod-estabel,INPUT tt-it-requisicao-aux.num-ord-inv,OUTPUT c-ct-contabil).

                                    RUN validate-record-rm IN h-boin168(INPUT "CREATE":U,
                                                                        INPUT TABLE tt-matriz).
                                    RUN getRowErrors       IN h-boin168(OUTPUT TABLE RowErrors).
                                    IF CAN-FIND(FIRST RowErrors) THEN
                                        RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                                    IF NOT l-erro THEN DO:
                                        RUN createRecord IN h-boin168.
                                        RUN getRecord    IN h-boin168(OUTPUT TABLE tt-r-it-requisicao).
                                        RUN pi-invest    IN h-boin168(INPUT "CREATE":U).
                                        RUN getRowErrors IN h-boin168(OUTPUT TABLE RowErrors).
                                        IF CAN-FIND(FIRST RowErrors) THEN
                                            RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                                        IF NOT l-erro THEN DO:
                                            RUN getRecord IN h-boin168(OUTPUT TABLE tt-it-requisicao-aux).
                                            FIND FIRST tt-it-requisicao-aux NO-LOCK.
                                            RUN pi-aprovacao-eletronica IN h-boin168 (INPUT tt-it-requisicao-aux.r-rowid).
                                            RUN getRowErrors IN h-boin168(OUTPUT TABLE RowErrors).
                                            RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                                        END.
                                    END.
                                END.
                                ELSE DO:
                                    EMPTY TEMP-TABLE tt-it-requisicao-aux.
        
                                    CREATE tt-it-requisicao-aux.
                                    BUFFER-COPY tt-it-requisicao TO tt-it-requisicao-aux.

                                    /*Matriz unidade de neg¢cio*/
                                    FOR EACH ttBusinessUnit WHERE ttBusinessUnit.ttPurchaseRequestLineID = tt-it-requisicao.ttPurchaseRequestLineID:
                                        IF ttBusinessUnit.BusinessUnitID <> "" AND ttBusinessUnit.BusinessUnitID <> ? THEN DO:
                                            ASSIGN tt-it-requisicao-aux.cod-unid-negoc = "".
                                            CREATE tt-matriz.
                                            ASSIGN tt-matriz.cod-unid-neg = ttBusinessUnit.BusinessUnitID
                                                   tt-matriz.perc-rateio  = ttBusinessUnit.BusinessUnitPercentage.
                                        END.
                                    END.
                                    
                                    RUN inbo/boin168.p PERSISTENT SET h-boin168.
                                    RUN openQueryStatic IN h-boin168 (INPUT "Main").
                                    RUN goToKey IN h-boin168(INPUT tt-it-requisicao-aux.nr-requisicao,INPUT tt-it-requisicao-aux.sequencia,INPUT tt-it-requisicao-aux.it-codigo).
                                    IF RETURN-VALUE <> "NOK" THEN DO:
                                        run setRecord in h-boin168(input table tt-it-requisicao-aux).
                                        RUN validate-record-rm IN h-boin168(INPUT "UPDATE":U,
                                                                            INPUT TABLE tt-matriz).
                                        IF CAN-FIND(FIRST RowErrors) THEN
                                            RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                                        ELSE DO:
                                            RUN updateRecord in h-boin168.
                                            RUN getRowErrors IN h-boin168(OUTPUT TABLE RowErrors). 
                                            IF CAN-FIND(FIRST RowErrors) THEN 
                                                RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                                            IF NOT l-erro THEN DO:
                                                RUN getRecord IN h-boin168(OUTPUT TABLE tt-it-requisicao-aux).
                                                FIND FIRST tt-it-requisicao-aux NO-LOCK.
                                                RUN pi-aprovacao-eletronica IN h-boin168 (INPUT tt-it-requisicao-aux.r-rowid).
                                                RUN getRowErrors IN h-boin168(OUTPUT TABLE RowErrors).
                                                RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                                            END.
                                        END.
                                    END.
                                    ELSE DO:
                                        CREATE tt_log_erro.
                                        ASSIGN ttv_num_cod_erro  = 2    
                                               ttv_des_msg_ajuda = "business_error":U       
                                               ttv_des_msg_erro  = "N∆o encontrada it-requisiá∆o para a chave informada.".
                                    END.
                                END.
                                EMPTY TEMP-TABLE tt-matriz.
                            END.
                            IF NOT l-erro THEN DO:
                                IF AVAIL tt-it-requisicao-aux THEN DO:
                                    RUN pi-aprovacao-eletronica-total IN h-boin168 (INPUT tt-it-requisicao-aux.r-rowid).
                                    RUN getRowErrors  IN h-boin168(OUTPUT TABLE RowErrors).
                                    IF CAN-FIND(FIRST RowErrors) THEN
                                        RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
                                END.
                        END.
                        END.
                    END.
               END.
            END CASE.
        END.
    END.

    if valid-handle(h-boin385) then
        delete object h-boin385.
    



           
