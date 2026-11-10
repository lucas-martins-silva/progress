PROCEDURE PITransUpsert:

    DEFINE INPUT PARAMETER rw-docum-est AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER c-transacao  AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER i-num-pedido AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erro.

    DEFINE VARIABLE c-situacao AS CHARACTER   NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST empresa 
         WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK NO-ERROR.

    FIND FIRST docum-est 
         WHERE ROWID(docum-est) = rw-docum-est NO-LOCK NO-ERROR.
    IF AVAIL docum-est THEN DO:


        IF CAN-FIND(FIRST item-doc-est WHERE item-doc-est.serie-docto  = docum-est.serie-docto  AND
                                             item-doc-est.nro-docto    = docum-est.nro-docto    AND
                                             item-doc-est.nat-operacao = docum-est.nat-operacao AND
                                             item-doc-est.cod-emitente = docum-est.cod-emitente AND
                                             item-doc-est.num-pedido   = i-num-pedido) THEN DO:

            FOR EACH item-doc-est
               WHERE item-doc-est.serie-docto  = docum-est.serie-docto  AND
                     item-doc-est.nro-docto    = docum-est.nro-docto    AND
                     item-doc-est.nat-operacao = docum-est.nat-operacao AND
                     item-doc-est.cod-emitente = docum-est.cod-emitente AND
                     item-doc-est.num-pedido   = i-num-pedido NO-LOCK:
    
                FIND FIRST ordem-compra 
                     WHERE ordem-compra.numero-ordem = item-doc-est.numero-ordem NO-LOCK NO-ERROR.
                IF AVAIL ordem-compra THEN DO:
                    FIND FIRST pedido-compr
                        WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.
                    &if "{&bf_mat_versao_ems}":U < "2.09":U &then
                       IF SUBSTRING(pedido-compr.char-1,2,1) <> "S":U THEN
                    &ELSE
                       IF NOT pedido-compr.log-integr-portal THEN
                    &ENDIF
                           NEXT. /*Se o pedido n∆o estiver integrado com o portal, vai para o proximo registro*/                         
    
                    IF ordem-compra.situacao = 6 THEN
                        ASSIGN c-situacao = "total":U.
                    ELSE
                        ASSIGN c-situacao = "partial":U.
    
                    FIND FIRST ttPurchaseOrderLine WHERE ttPurchaseOrderLine.POLineNumber = ordem-compra.numero-ordem NO-LOCK NO-ERROR.

                    IF AVAIL ttPurchaseOrderLine THEN DO:
                        ASSIGN ttPurchaseOrderLine.Quantity = ttPurchaseOrderLine.Quantity + item-doc-est.quantidade
                               ttPurchaseOrderLine.Action   = c-situacao.
                    END.
                    ELSE DO:
                        CREATE ttPurchaseOrderLine.
                        ASSIGN ttPurchaseOrderLine.Action           = c-situacao
                               ttPurchaseOrderLine.Authority        = docum-est.usuario
                               ttPurchaseOrderLine.ItemCode         = ordem-compra.it-codigo
                               ttPurchaseOrderLine.POLineNumber     = ordem-compra.numero-ordem
                               ttPurchaseOrderLine.PONumber         = ordem-compra.num-pedido
                               ttPurchaseOrderLine.Quantity         = item-doc-est.quantidade
                               ttPurchaseOrderLine.POLineNumberWebb = &IF  "{&bf_mat_versao_ems}" < "2.09"  &THEN SUBSTRING(ordem-compra.CHAR-1,92,50) 
                                                                      &ELSE string(ordem-compra.cod-ord-portal) &ENDIF.
                    END.    
                END.

                ASSIGN BuyerTaxID     = empresa.cgc
                       PONumber       = item-doc-est.num-pedido
                       PONumberWebb   = &IF  "{&bf_mat_versao_ems}" < "2.09"  &THEN SUBSTRING(pedido-compr.CHAR-1,3,50)
                                        &ELSE string(pedido-compr.cod-ped-portal) &ENDIF                           
                       Comments       = docum-est.observacao
                       ReceiptDate    = docum-est.dt-atualiza
                       Identity       = pedido-compr.responsavel.
    
            END.
        END. 
        ELSE DO:

            FOR EACH item-doc-est
               WHERE item-doc-est.serie-docto  = docum-est.serie-docto  AND
                     item-doc-est.nro-docto    = docum-est.nro-docto    AND
                     item-doc-est.nat-operacao = docum-est.nat-operacao AND
                     item-doc-est.cod-emitente = docum-est.cod-emitente NO-LOCK:

                if item-doc-est.log-1 then do:

                    for each rat-ordem {cdp/cd8900.i rat-ordem item-doc-est} and rat-ordem.sequencia = item-doc-est.sequencia no-lock:
                        find FIRST ordem-compra where ordem-compra.numero-ordem = rat-ordem.numero-ordem AND 
                                                      ordem-compra.num-pedido = i-num-pedido no-lock no-error. 
    
                        IF AVAIL ordem-compra THEN DO:
                            FIND FIRST pedido-compr
                                WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.

                            &if "{&bf_mat_versao_ems}":U < "2.09":U &then
                               IF SUBSTRING(pedido-compr.char-1,2,1) <> "S":U THEN
                            &ELSE
                               IF NOT pedido-compr.log-integr-portal THEN
                            &ENDIF
                                   NEXT. /*Se o pedido n∆o estiver integrado com o portal, vai para o proximo registro*/                         
                        
                            IF ordem-compra.situacao = 6 THEN
                                ASSIGN c-situacao = "total":U.
                            ELSE
                                ASSIGN c-situacao = "partial":U.

                            FIND FIRST ttPurchaseOrderLine WHERE ttPurchaseOrderLine.POLineNumber = ordem-compra.numero-ordem NO-LOCK NO-ERROR.

                            IF NOT AVAIL ttPurchaseOrderLine THEN DO:
                            
                                CREATE ttPurchaseOrderLine.
                                ASSIGN ttPurchaseOrderLine.Action           = c-situacao
                                       ttPurchaseOrderLine.Authority        = docum-est.usuario
                                       ttPurchaseOrderLine.ItemCode         = ordem-compra.it-codigo
                                       ttPurchaseOrderLine.POLineNumber     = ordem-compra.numero-ordem
                                       ttPurchaseOrderLine.PONumber         = ordem-compra.num-pedido
                                       ttPurchaseOrderLine.Quantity         = rat-ordem.quantidade
                                       ttPurchaseOrderLine.POLineNumberWebb = &IF  "{&bf_mat_versao_ems}" < "2.09"  &THEN SUBSTRING(ordem-compra.CHAR-1,92,50) 
                                                                              &ELSE string(ordem-compra.cod-ord-portal) &ENDIF.                                                                        
                           END.
                           ELSE DO:
                               ASSIGN ttPurchaseOrderLine.Quantity         = ttPurchaseOrderLine.Quantity + rat-ordem.quantidade
                                      ttPurchaseOrderLine.Action           = c-situacao.
                           END.
                        
                        END.
                        ELSE DO:
                            NEXT.
                        END.
                    END.
                END.
                ASSIGN BuyerTaxID     = empresa.cgc
                       PONumber       = i-num-pedido
                       PONumberWebb   = &IF  "{&bf_mat_versao_ems}" < "2.09"  &THEN SUBSTRING(pedido-compr.CHAR-1,3,50)
                                        &ELSE string(pedido-compr.cod-ped-portal) &ENDIF                           
                       Comments       = docum-est.observacao
                       ReceiptDate    = docum-est.dt-atualiza
                       Identity       = IF AVAIL pedido-compr THEN pedido-compr.responsavel ELSE "".
            END.
        END.
    END.
    ELSE DO:
        CREATE tt_log_erro.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-nao-foi-encontrada-ocorrencia AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "N∆o_foi_encontrada_ocorrància_em_docum-est_com_a_chave_informada" *}
        ASSIGN c-lbl-liter-nao-foi-encontrada-ocorrencia = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-nao-encontradoa-docum-est-para AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "N∆o_encontrado(a)_docum-est_para_chave_informada" *}
        ASSIGN c-lbl-liter-nao-encontradoa-docum-est-para = TRIM(RETURN-VALUE).
        ASSIGN tt_log_erro.ttv_num_cod_erro  = 2
               tt_log_erro.ttv_des_msg_ajuda = c-lbl-liter-nao-foi-encontrada-ocorrencia + "."
               tt_log_erro.ttv_des_msg_erro  = c-lbl-liter-nao-encontradoa-docum-est-para.

        RETURN "NOK":U.
    END.
    
    FIND FIRST ttPurchaseOrderLine NO-LOCK NO-ERROR.

    IF AVAIL ttPurchaseOrderLine THEN DO:
        RUN piUpsert(INPUT BuyerTaxID  ,
                     INPUT Identity    ,
                     INPUT PONumber    ,
                     INPUT PONumberWebb,
                     INPUT Comments    ,
                     INPUT ReceiptDate ,
                     INPUT "":U        ,
                     INPUT c-transacao ,
                     OUTPUT TABLE tt_log_erro,
                     INPUT TABLE ttPurchaseOrderLine).
     END.   

END PROCEDURE.




