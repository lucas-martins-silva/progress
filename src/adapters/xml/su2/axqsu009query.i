

    
    CREATE tt-proj-inv.
    ASSIGN tt-proj-inv.ep-codigo      = &IF "{&mguni_version}" >= "2.071" &THEN ttListOfParameters.CompanyCode &else int(ttListOfParameters.CompanyCode)&ENDIF
           tt-proj-inv.cod-est-exec   = ttListOfParameters.ExecutorSite 
           tt-proj-inv.num-projeto    = ttListOfParameters.ProjectNumber
           tt-proj-inv.num-ordem      = ttListOfParameters.ProjectPhase
           tt-proj-inv.num-ord-magnus = ttListOfParameters.ProjectPhaseEMS
           tt-proj-inv.cod-id-solum   = ttListOfParameters.IDTask
           tt-proj-inv.cod-sigla      = ttListOfParameters.IDProject
           tt-proj-inv.nr-requisicao  = IF ttListOfParameters.RequisitionNumber = ? THEN 0 ELSE ttListOfParameters.RequisitionNumber.

    
    
        FOR EACH tt-proj-inv:
            IF (&IF "{&bf_mat_versao_ems}" >= "2.071" &THEN tt-proj-inv.ep-codigo = ""
                &else tt-proj-inv.ep-codigo = 0 &endif OR tt-proj-inv.ep-codigo = ?) and
               (tt-proj-inv.cod-est-exec = "" or tt-proj-inv.cod-est-exec = ?) and
               (tt-proj-inv.num-projeto  = 0  or tt-proj-inv.num-projeto  = ?) and
               (tt-proj-inv.num-ordem    = 0  or tt-proj-inv.num-ordem    = ?) and 
               (tt-proj-inv.cod-sigla    = "" OR tt-proj-inv.cod-sigla    = ?) THEN DO:
    
                ASSIGN l-erro = YES.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "NÆo_foram_informados_os_parƒmetros_necess rios_para_a_busca_dos_movimentos_das_ordens_de_investimentos" *}
                RUN setError IN hMessageHandler (INPUT 17006,
                                                 INPUT "business_error":U,  
                                                 INPUT RETURN-VALUE + ".").
    
            END.
        END.   
   
                                                                           
    IF NOT(l-erro) THEN DO:
    
        FOR EACH  ttListOfTransactions:
             DELETE  ttListOfTransactions.
        END.
        
        
        RUN cdp/cdapi035.p (INPUT  TABLE tt-proj-inv,
                            OUTPUT TABLE tt-it-doc-fisico, 
                            OUTPUT TABLE tt-it-requisicao,
                            OUTPUT TABLE tt-item-doc-est,
                            OUTPUT TABLE tt-movto-estoq,
                            OUTPUT TABLE tt-movto-ggf,
                            OUTPUT TABLE tt-movto-mat,
                            OUTPUT TABLE tt-ord-prod,
                            OUTPUT TABLE tt-ordem-compra).
        
    
        ASSIGN i-cont = 0.  
        FOR EACH tt-it-doc-fisico:
            ASSIGN i-cont = i-cont + 1. 

            CREATE ttListOfTransactions.
            FIND moeda
                WHERE moeda.mo-codigo = 0 NO-LOCK NO-ERROR.
            IF AVAIL moeda THEN
                ASSIGN ttListOfTransactions.CompanyId                = tt-it-doc-fisico.ep-codigo
                       ttListOfTransactions.CurrencyId               = moeda.mo-codigo
                       ttListOfTransactions.CurrencyDescription      = moeda.descricao
                       ttListOfTransactions.CurrencySign             = moeda.sigla    
                       ttListOfTransactions.ExecutorSite             = tt-it-doc-fisico.cod-est-exec
                       ttListOfTransactions.IDProject                = trim(tt-it-doc-fisico.cod-sigla)   
                       ttListOfTransactions.IDTask                   = trim(tt-it-doc-fisico.cod-id-solum)
                       ttListOfTransactions.ProjectNumber            = tt-it-doc-fisico.num-projeto
                       ttListOfTransactions.ProjectPhase             = tt-it-doc-fisico.num-ordem
                       ttListOfTransactions.ProjectPhaseEMS          = tt-it-doc-fisico.num-ord-magnus  
                       ttListOfTransactions.Quantity                 = tt-it-doc-fisico.quantidade
                       ttListOfTransactions.Situacao                 = 0  
                       ttListOfTransactions.TransactionDescription   = "Itens do Documento Fiscal"  
                       ttListOfTransactions.TransactionName          = "it-doc-fisico"  
                       ttListOfTransactions.TransactionValue         = tt-it-doc-fisico.preco-total[1]
                       ttListOfTransactions.cont                     = i-cont.
                       FIND FIRST tab-unidade
                            WHERE tab-unidade.un = tt-it-doc-fisico.un NO-LOCK NO-ERROR.
                       IF AVAIL tab-unidade THEN
                           ASSIGN ttListOfTransactions.UnitOfMeasureCode        = tab-unidade.un
                                  ttListOfTransactions.UnitOfMeasureDescription = tab-unidade.descricao.
    
            /*carrega a ttTransactionKey com os campos da(s) chave(s)*/
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "serie-docto"
                   ttTransactionKey.FieldDescription = "S‚rie Documento"
                   ttTransactionKey.ContentType      = 1
                   ttTransactionKey.FieldContent     = tt-it-doc-fisico.serie-docto
                   ttTransactionKey.cont             = i-cont.
    
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "nro-docto"
                   ttTransactionKey.FieldDescription = "N£mero Documento"
                   ttTransactionKey.ContentType      = 1
                   ttTransactionKey.FieldContent     = tt-it-doc-fisico.nro-docto
                   ttTransactionKey.cont             = i-cont.
    
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "cod-emitente"
                   ttTransactionKey.FieldDescription = "C¢digo Emitente"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-it-doc-fisico.cod-emitente)
                   ttTransactionKey.cont             = i-cont.
    
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "tipo-nota"
                   ttTransactionKey.FieldDescription = "Tipo Nota"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-it-doc-fisico.tipo-nota)
                   ttTransactionKey.cont             = i-cont.
    
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "sequencia"
                   ttTransactionKey.FieldDescription = "Sequˆncia"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-it-doc-fisico.sequencia)
                   ttTransactionKey.cont             = i-cont.
                                    
        END.

        
        FOR EACH tt-it-requisicao:
            
            ASSIGN i-cont = i-cont + 1. 
            
            CREATE ttListOfTransactions.
            FIND moeda
                WHERE moeda.mo-codigo = 0 NO-LOCK NO-ERROR.
            IF AVAIL moeda THEN
                ASSIGN ttListOfTransactions.CompanyId                = tt-it-requisicao.ep-codigo
                       ttListOfTransactions.CurrencyId               = moeda.mo-codigo
                       ttListOfTransactions.CurrencyDescription      = moeda.descricao  
                       ttListOfTransactions.CurrencySign             = moeda.sigla      
                       ttListOfTransactions.ExecutorSite             = tt-it-requisicao.cod-est-exec
                       ttListOfTransactions.IDProject                = trim(tt-it-requisicao.cod-sigla)   
                       ttListOfTransactions.IDTask                   = trim(tt-it-requisicao.cod-id-solum)
                       ttListOfTransactions.ProjectNumber            = tt-it-requisicao.num-projeto
                       ttListOfTransactions.ProjectPhase             = tt-it-requisicao.num-ordem  
                       ttListOfTransactions.ProjectPhaseEMS          = tt-it-requisicao.num-ord-magnus
                       ttListOfTransactions.Quantity                 = tt-it-requisicao.qt-requisitada
                       ttListOfTransactions.Situacao                 = tt-it-requisicao.situacao
                       ttListOfTransactions.desc-situacao            = tt-it-requisicao.desc-situacao
                       ttListOfTransactions.TransactionName          = "it-requisicao"
                       ttListOfTransactions.TransactionValue         = ROUND((tt-it-requisicao.preco-unit * tt-it-requisicao.qt-requisitada),2)
                       ttListOfTransactions.CustCenterCod            = tt-it-requisicao.sc-codigo
                       ttListOfTransactions.DeliveryDate             = tt-it-requisicao.dt-entrega
                       ttListOfTransactions.EmissionDate             = tt-it-requisicao.dt-emissao
                       ttListOfTransactions.ItemCode                 = tt-it-requisicao.it-codigo
                       ttListOfTransactions.cont                     = i-cont
                       ttListOfTransactions.TransactionOriginCode    = tt-it-requisicao.transacaoOrigemCodigo
                       ttListOfTransactions.TransactionOriginDescription = tt-it-requisicao.transacaoOrigem.

                       FIND FIRST tab-unidade
                            WHERE tab-unidade.un = tt-it-requisicao.un NO-LOCK NO-ERROR.
                       IF AVAIL tab-unidade THEN
                           ASSIGN ttListOfTransactions.UnitOfMeasureCode        = tab-unidade.un
                                  ttListOfTransactions.UnitOfMeasureDescription = tab-unidade.descricao.
                       
                       FIND FIRST requisicao WHERE requisicao.nr-requisicao = tt-it-requisicao.nr-requisicao NO-LOCK NO-ERROR.
                       IF AVAIL requisicao THEN DO:
                           CASE requisicao.tp-requis:
                               WHEN 1 THEN
                                   ASSIGN ttListOfTransactions.TransactionDescription = "Requisi‡Æo".
                               WHEN 2 THEN
                                   ASSIGN ttListOfTransactions.TransactionDescription = "Solicita‡Æo de Compra".
                           END CASE.
                       END.
                           
            
            /*carrega a ttTransactionKey com os campos da(s) chave(s)*/
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "nr-requisicao"
                   ttTransactionKey.FieldDescription = "N£mero Requisi‡Æo"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-it-requisicao.nr-requisicao)
                   ttTransactionKey.cont             = i-cont.
    
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "sequencia"
                   ttTransactionKey.FieldDescription = "Sequˆncia"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-it-requisicao.sequencia)
                   ttTransactionKey.cont             = i-cont.
    
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "it-codigo"
                   ttTransactionKey.FieldDescription = "C¢digo Item"
                   ttTransactionKey.ContentType      = 1
                   ttTransactionKey.FieldContent     = tt-it-requisicao.it-codigo
                   ttTransactionKey.cont             = i-cont.
            
                 
        END.
                                                                                
        
        FOR EACH tt-item-doc-est:
            ASSIGN i-cont = i-cont + 1.
            CREATE ttListOfTransactions.
            FIND moeda
               WHERE moeda.mo-codigo = 0 NO-LOCK NO-ERROR.
               IF AVAIL moeda THEN
                    ASSIGN ttListOfTransactions.CompanyId                = tt-item-doc-est.ep-codigo
                           ttListOfTransactions.CurrencyId               = moeda.mo-codigo 
                           ttListOfTransactions.CurrencyDescription      = moeda.descricao  
                           ttListOfTransactions.CurrencySign             = moeda.sigla      
                           ttListOfTransactions.ExecutorSite             = tt-item-doc-est.cod-est-exec
                           ttListOfTransactions.IDProject                = trim(tt-item-doc-est.cod-sigla)   
                           ttListOfTransactions.IDTask                   = trim(tt-item-doc-est.cod-id-solum)
                           ttListOfTransactions.ProjectNumber            = tt-item-doc-est.num-projeto
                           ttListOfTransactions.ProjectPhase             = tt-item-doc-est.num-ordem  
                           ttListOfTransactions.ProjectPhaseEMS          = tt-item-doc-est.num-ord-magnus
                           ttListOfTransactions.Quantity                 = tt-item-doc-est.quantidade
                           ttListOfTransactions.Situacao                 = tt-item-doc-est.sit-item
                           ttListOfTransactions.desc-situacao            = tt-item-doc-est.desc-sit-item
                           ttListOfTransactions.TransactionDescription   = "Itens NF Movimentadas para Estoque"
                           ttListOfTransactions.TransactionName          = "item-doc-est"
                           ttListOfTransactions.TransactionValue         = tt-item-doc-est.pr-total[1]
                           ttListOfTransactions.cont                     = i-cont.
                           FIND FIRST tab-unidade
                                WHERE tab-unidade.un = tt-item-doc-est.un NO-LOCK NO-ERROR.
                           IF AVAIL tab-unidade THEN
                               ASSIGN ttListOfTransactions.UnitOfMeasureCode        = tab-unidade.un
                                      ttListOfTransactions.UnitOfMeasureDescription = tab-unidade.descricao.
    
            /*carrega a ttTransactionKey com os campos da(s) chave(s)*/
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "serie-docto"
                   ttTransactionKey.FieldDescription = "S‚rie Documento"
                   ttTransactionKey.ContentType      = 1
                   ttTransactionKey.FieldContent     = tt-item-doc-est.serie-docto
                   ttTransactionKey.cont             = i-cont.

            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "nr-docto"
                   ttTransactionKey.FieldDescription = "N£mero Documento"
                   ttTransactionKey.ContentType      = 1
                   ttTransactionKey.FieldContent     = tt-item-doc-est.nro-docto
                   ttTransactionKey.cont             = i-cont.

            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "cod-emitente"
                   ttTransactionKey.FieldDescription = "C¢digo Emitente"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-item-doc-est.cod-emitente)
                   ttTransactionKey.cont             = i-cont.

            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "nat-operacao"
                   ttTransactionKey.FieldDescription = "Natureza Opera‡Æo"
                   ttTransactionKey.ContentType      = 1
                   ttTransactionKey.FieldContent     = tt-item-doc-est.nat-operacao
                   ttTransactionKey.cont             = i-cont.
    
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "sequencia"
                   ttTransactionKey.FieldDescription = "Sequˆncia"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-item-doc-est.sequencia)
                   ttTransactionKey.cont             = i-cont.
        END.

        
        FOR EACH tt-movto-estoq:
           
            ASSIGN i-cont = i-cont + 1.
            CREATE ttListOfTransactions.
            FIND moeda
                WHERE moeda.mo-codigo = 0 NO-LOCK NO-ERROR.
            IF AVAIL moeda THEN
                ASSIGN ttListOfTransactions.CompanyId                = tt-movto-estoq.ep-codigo
                       ttListOfTransactions.CurrencyId               = moeda.mo-codigo
                       ttListOfTransactions.CurrencyDescription      = moeda.descricao 
                       ttListOfTransactions.CurrencySign             = moeda.sigla     
                       ttListOfTransactions.ExecutorSite             = tt-movto-estoq.cod-est-exec
                       ttListOfTransactions.IDProject                = trim(tt-movto-estoq.cod-sigla)   
                       ttListOfTransactions.IDTask                   = trim(tt-movto-estoq.cod-id-solum)
                       ttListOfTransactions.ProjectNumber            = tt-movto-estoq.num-projeto
                       ttListOfTransactions.ProjectPhase             = tt-movto-estoq.num-ordem  
                       ttListOfTransactions.ProjectPhaseEMS          = tt-movto-estoq.num-ord-magnus  
                       ttListOfTransactions.Quantity                 = tt-movto-estoq.quantidade
                       ttListOfTransactions.desc-situacao            = tt-movto-estoq.situacao
                       ttListOfTransactions.TransactionName          = "movto-estoq"
                       ttListOfTransactions.TransactionValue         = tt-movto-estoq.valor-mat-m[1] + tt-movto-estoq.valor-ggf-m[1] + tt-movto-estoq.valor-mob-m[1]
                       ttListOfTransactions.CustCenterCod            = tt-movto-estoq.sc-codigo
                       ttListOfTransactions.DeliveryDate             = tt-movto-estoq.dt-trans
                       ttListOfTransactions.EmissionDate             = tt-movto-estoq.dt-trans
                       ttListOfTransactions.ItemCode                 = tt-movto-estoq.it-codigo
                       ttListOfTransactions.cont                     = i-cont
                       ttListOfTransactions.TransactionOriginCode    = tt-movto-estoq.transacaoOrigemCodigo 
                       ttListOfTransactions.TransactionOriginDescription = tt-movto-estoq.transacaoOrigem.

            CASE tt-movto-estoq.esp-docto:
                WHEN 21 THEN
                    ASSIGN ttListOfTransactions.TransactionDescription   = "Nota Fiscal de Entrada".
                WHEN 7 THEN
                    ASSIGN ttListOfTransactions.TransactionDescription   = "Devolu‡Æo Requisi‡Æo".
                WHEN 30 THEN
                    ASSIGN ttListOfTransactions.TransactionDescription   = "Atendimento Requisi‡Æo".
                OTHERWISE 
                    ASSIGN ttListOfTransactions.TransactionDescription   = "Movimento de Estoque".
            END CASE.

                       FIND FIRST tab-unidade
                            WHERE tab-unidade.un = tt-movto-estoq.un NO-LOCK NO-ERROR.
                       IF AVAIL tab-unidade THEN
                           ASSIGN ttListOfTransactions.UnitOfMeasureCode        = tab-unidade.un
                                  ttListOfTransactions.UnitOfMeasureDescription = tab-unidade.descricao.
            
            /*carrega a ttTransactionKey com os campos da(s) chave(s)*/
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "it-codigo"
                   ttTransactionKey.FieldDescription = "C¢digo Item"
                   ttTransactionKey.ContentType      = 1
                   ttTransactionKey.FieldContent     = tt-movto-estoq.it-codigo
                   ttTransactionKey.cont             = i-cont.
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "cod-estabel"
                   ttTransactionKey.FieldDescription = "C¢digo Estabelecimento"
                   ttTransactionKey.ContentType      = 1
                   ttTransactionKey.FieldContent     = tt-movto-estoq.cod-estabel
                   ttTransactionKey.cont             = i-cont.
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "dt-trans"
                   ttTransactionKey.FieldDescription = "Data Transa‡Æo"
                   ttTransactionKey.ContentType      = 5
                   ttTransactionKey.FieldContent     = STRING(tt-movto-estoq.dt-trans)
                   ttTransactionKey.cont             = i-cont.
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "nr-trans"
                   ttTransactionKey.FieldDescription = "N£mero Transa‡Æo"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-movto-estoq.nr-trans)
                   ttTransactionKey.cont             = i-cont.

            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "serie-docto"
                   ttTransactionKey.FieldDescription = "S‚rie Documento"
                   ttTransactionKey.ContentType      = 1
                   ttTransactionKey.FieldContent     = tt-movto-estoq.serie-docto
                   ttTransactionKey.cont             = i-cont.

            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "nr-docto"
                   ttTransactionKey.FieldDescription = "N£mero Documento"
                   ttTransactionKey.ContentType      = 1
                   ttTransactionKey.FieldContent     = tt-movto-estoq.nro-docto
                   ttTransactionKey.cont             = i-cont.

            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "cod-emitente"
                   ttTransactionKey.FieldDescription = "C¢digo Emitente"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-movto-estoq.cod-emitente)
                   ttTransactionKey.cont             = i-cont.

            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "nat-operacao"
                   ttTransactionKey.FieldDescription = "Natureza Opera‡Æo"
                   ttTransactionKey.ContentType      = 1
                   ttTransactionKey.FieldContent     = tt-movto-estoq.nat-operacao
                   ttTransactionKey.cont             = i-cont.
        END.
        
        
        FOR EACH tt-movto-ggf:
            ASSIGN i-cont = i-cont + 1.
            CREATE ttListOfTransactions.
            FIND moeda
                WHERE moeda.mo-codigo = 0 NO-LOCK NO-ERROR.
            IF AVAIL moeda THEN
                ASSIGN ttListOfTransactions.CompanyId                = tt-movto-ggf.ep-codigo
                       ttListOfTransactions.CurrencyId               = moeda.mo-codigo
                       ttListOfTransactions.CurrencyDescription      = moeda.descricao
                       ttListOfTransactions.CurrencySign             = moeda.sigla    
                       ttListOfTransactions.ExecutorSite             = tt-movto-ggf.cod-est-exec
                       ttListOfTransactions.IDProject                = trim(tt-movto-ggf.cod-sigla)   
                       ttListOfTransactions.IDTask                   = trim(tt-movto-ggf.cod-id-solum)
                       ttListOfTransactions.ProjectNumber            = tt-movto-ggf.num-projeto
                       ttListOfTransactions.ProjectPhase             = tt-movto-ggf.num-ordem  
                       ttListOfTransactions.ProjectPhaseEMS          = tt-movto-ggf.num-ord-magnus  
                       ttListOfTransactions.Quantity                 = 0
                       ttListOfTransactions.Situacao                 = 0
                       ttListOfTransactions.TransactionDescription   = "Movimenta‡Æo de GGF"
                       ttListOfTransactions.TransactionName          = "movto-ggf"
                       ttListOfTransactions.TransactionValue         = tt-movto-ggf.valor-ggf-1-m[1] 
                       ttListOfTransactions.UnitOfMeasureCode        = ""
                       ttListOfTransactions.UnitOfMeasureDescription = ""
                       ttListOfTransactions.cont                     = i-cont.
    
            /*carrega a ttTransactionKey com os campos da(s) chave(s)*/
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "nr-ord-produ"
                   ttTransactionKey.FieldDescription = "N£mero Ordem Produ‡Æo"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-movto-ggf.nr-ord-produ)
                   ttTransactionKey.cont             = i-cont.
    
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "dt-trans"
                   ttTransactionKey.FieldDescription = "Data Transa‡Æo"
                   ttTransactionKey.ContentType      = 5
                   ttTransactionKey.FieldContent     = STRING(tt-movto-ggf.dt-trans)
                   ttTransactionKey.cont             = i-cont.
    
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "cc-codigo"
                   ttTransactionKey.FieldDescription = "C¢digo Centro Custo"
                   ttTransactionKey.ContentType      = 1
                   ttTransactionKey.FieldContent     = tt-movto-ggf.cc-codigo
                   ttTransactionKey.cont             = i-cont.
    
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "num-id-movto-ggf"
                   ttTransactionKey.FieldDescription = "N£mero ID Movto GGF"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-movto-ggf.num-id-movto-ggf)
                   ttTransactionKey.cont             = i-cont.
        END.
        
        
        FOR EACH tt-movto-mat:
            ASSIGN i-cont = i-cont + 1.
            CREATE ttListOfTransactions.
            FIND moeda
                WHERE moeda.mo-codigo = 0 NO-LOCK NO-ERROR.
            IF AVAIL moeda THEN
                ASSIGN ttListOfTransactions.CompanyId                = tt-movto-mat.ep-codigo
                       ttListOfTransactions.CurrencyId               = moeda.mo-codigo
                       ttListOfTransactions.CurrencyId               = moeda.mo-codigo
                       ttListOfTransactions.CurrencyDescription      = moeda.descricao 
                       ttListOfTransactions.CurrencySign             = moeda.sigla     
                       ttListOfTransactions.ExecutorSite             = tt-movto-mat.cod-est-exec
                       ttListOfTransactions.IDProject                = trim(tt-movto-mat.cod-sigla)   
                       ttListOfTransactions.IDTask                   = trim(tt-movto-mat.cod-id-solum)
                       ttListOfTransactions.ProjectNumber            = tt-movto-mat.num-projeto
                       ttListOfTransactions.ProjectPhase             = tt-movto-mat.num-ordem  
                       ttListOfTransactions.ProjectPhaseEMS          = tt-movto-mat.num-ord-magnus  
                       ttListOfTransactions.Quantity                 = tt-movto-mat.quantidade
                       ttListOfTransactions.Situacao                 = 0
                       ttListOfTransactions.TransactionDescription   = "Movimento de Material"
                       ttListOfTransactions.TransactionName          = "movto-mat"
                       ttListOfTransactions.TransactionValue         = tt-movto-mat.valor-ggf-1-m[1]
                       ttListOfTransactions.cont                     = i-cont.
                       FIND FIRST tab-unidade
                            WHERE tab-unidade.un = tt-movto-mat.un NO-LOCK NO-ERROR.
                       IF AVAIL tab-unidade THEN
                           ASSIGN ttListOfTransactions.UnitOfMeasureCode        = tab-unidade.un
                                  ttListOfTransactions.UnitOfMeasureDescription = tab-unidade.descricao.
    
            /*carrega a ttTransactionKey com os campos da(s) chave(s)*/
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "nr-ord-produ"
                   ttTransactionKey.FieldDescription = "N£mero Ordem Produ‡Æo"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-movto-mat.nr-ord-produ)
                   ttTransactionKey.cont             = i-cont.
    
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "num-sequen"
                   ttTransactionKey.FieldDescription = "Sequˆncia"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-movto-mat.num-sequen)
                   ttTransactionKey.cont             = i-cont.
    
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "it-codigo"
                   ttTransactionKey.FieldDescription = "C¢digo Item"
                   ttTransactionKey.ContentType      = 1
                   ttTransactionKey.FieldContent     = tt-movto-mat.it-codigo
                   ttTransactionKey.cont             = i-cont.
            
        END.
    
        
        FOR EACH tt-ord-prod:
            ASSIGN i-cont = i-cont + 1.
            CREATE ttListOfTransactions.
            FIND moeda
                WHERE moeda.mo-codigo = 0 NO-LOCK NO-ERROR.
            IF AVAIL moeda THEN
                ASSIGN ttListOfTransactions.CompanyId                = tt-ord-prod.ep-codigo
                       ttListOfTransactions.CurrencyId               = moeda.mo-codigo
                       ttListOfTransactions.CurrencyDescription      = moeda.descricao 
                       ttListOfTransactions.CurrencySign             = moeda.sigla     
                       ttListOfTransactions.ExecutorSite             = tt-ord-prod.cod-est-exec
                       ttListOfTransactions.IDProject                = trim(tt-ord-prod.cod-sigla)
                       ttListOfTransactions.IDTask                   = trim(tt-ord-prod.cod-id-solum)   
                       ttListOfTransactions.ProjectNumber            = tt-ord-prod.num-projeto
                       ttListOfTransactions.ProjectPhase             = tt-ord-prod.num-ordem  
                       ttListOfTransactions.ProjectPhaseEMS          = tt-ord-prod.num-ord-magnus  
                       ttListOfTransactions.Quantity                 = tt-ord-prod.qt-ordem
                       ttListOfTransactions.Situacao                 = tt-ord-prod.estado
                       ttListOfTransactions.desc-situacao            = tt-ord-prod.desc-estado
                       ttListOfTransactions.TransactionDescription   = "Ordem de Produ‡Æo"
                       ttListOfTransactions.TransactionName          = "ord-prod"
                       ttListOfTransactions.TransactionValue         = 0
                       ttListOfTransactions.cont                     = i-cont.
                       FIND FIRST tab-unidade
                            WHERE tab-unidade.un = tt-ord-prod.un NO-LOCK NO-ERROR.
                       IF AVAIL tab-unidade THEN
                           ASSIGN ttListOfTransactions.UnitOfMeasureCode        = tab-unidade.un
                                  ttListOfTransactions.UnitOfMeasureDescription = tab-unidade.descricao.
    
             /*carrega a ttTransactionKey com os campos da(s) chave(s)*/
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "nr-ord-produ"
                   ttTransactionKey.FieldDescription = "N£mero Ordem Produ‡Æo"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-ord-prod.nr-ord-produ)
                   ttTransactionKey.cont             = i-cont.
    
        END.
    
        
        FOR EACH tt-ordem-compra:
            ASSIGN i-cont = i-cont + 1.
            CREATE ttListOfTransactions.
            FIND moeda
                WHERE moeda.mo-codigo = tt-ordem-compra.mo-codigo NO-LOCK NO-ERROR.
            IF AVAIL moeda THEN
                ASSIGN ttListOfTransactions.CompanyId                = tt-ordem-compra.ep-codigo
                       ttListOfTransactions.CurrencyId               = moeda.mo-codigo
                       ttListOfTransactions.CurrencyDescription      = moeda.descricao
                       ttListOfTransactions.CurrencySign             = moeda.sigla
                       ttListOfTransactions.ExecutorSite             = tt-ordem-compra.cod-est-exec
                       ttListOfTransactions.IDProject                = trim(tt-ordem-compra.cod-sigla)  
                       ttListOfTransactions.IDTask                   = trim(tt-ordem-compra.cod-id-solum)   
                       ttListOfTransactions.ProjectNumber            = tt-ordem-compra.num-projeto
                       ttListOfTransactions.ProjectPhase             = tt-ordem-compra.num-ordem  
                       ttListOfTransactions.ProjectPhaseEMS          = tt-ordem-compra.num-ord-magnus  
                       ttListOfTransactions.Quantity                 = tt-ordem-compra.qt-solic
                       ttListOfTransactions.Situacao                 = tt-ordem-compra.situacao
                       ttListOfTransactions.desc-situacao            = tt-ordem-compra.desc-situacao
                       ttListOfTransactions.TransactionDescription   = "Ordem de Compra"
                       ttListOfTransactions.TransactionName          = "ordem-compra"
                       ttListOfTransactions.TransactionValue         = tt-ordem-compra.preco-unit * tt-ordem-compra.qt-solic
                       ttListOfTransactions.CustCenterCod            = tt-ordem-compra.sc-codigo 
                       ttListOfTransactions.DeliveryDate             = tt-ordem-compra.dt-entrega
                       ttListOfTransactions.EmissionDate             = tt-ordem-compra.dt-emissao
                       ttListOfTransactions.ItemCode                 = tt-ordem-compra.it-codigo
                       ttListOfTransactions.cont                     = i-cont
                       ttListOfTransactions.TransactionOriginCode    = tt-ordem-compra.transacaoOrigemCodigo
                       ttListOfTransactions.TransactionOriginDescription = tt-ordem-compra.transacaoOrigem.     
                       FIND FIRST prazo-compra
                            WHERE prazo-compra.numero-ordem = tt-ordem-compra.num-ordem NO-LOCK NO-ERROR.
                       IF AVAIL prazo-compra THEN
                           FIND FIRST tab-unidade
                                WHERE tab-unidade.un = prazo-compra.un NO-LOCK NO-ERROR.
                           IF AVAIL tab-unidade THEN
                               ASSIGN ttListOfTransactions.UnitOfMeasureCode        = tab-unidade.un
                                      ttListOfTransactions.UnitOfMeasureDescription = tab-unidade.descricao.
    
             /*carrega a ttTransactionKey com os campos da(s) chave(s)*/
            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "numero-ordem"
                   ttTransactionKey.FieldDescription = "N£mero Ordem"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-ordem-compra.numero-ordem)
                   ttTransactionKey.cont             = i-cont.

            CREATE ttTransactionKey.
            ASSIGN ttTransactionKey.FieldName        = "num-pedido"
                   ttTransactionKey.FieldDescription = "N£mero Pedido"
                   ttTransactionKey.ContentType      = 2
                   ttTransactionKey.FieldContent     = STRING(tt-ordem-compra.num-pedido)
                   ttTransactionKey.cont             = i-cont.
        END.
    END.


