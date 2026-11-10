IF ConfirmStatus = "500":U THEN DO:
    IF ConfirmType = "order":U THEN DO:
      
        EMPTY TEMP-TABLE tt-ordem-compra.
        EMPTY TEMP-TABLE tt-cotacao-item.

        FIND pedido-compr WHERE pedido-compr.num-pedido = NumberERP EXCLUSIVE-LOCK NO-ERROR.
    
        IF AVAIL pedido-compr THEN DO:

            IF NOT l-integra-portal-paradigma THEN DO:
                &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                    ASSIGN OVERLAY(pedido-compr.char-1,1, 1) = "N":U.
                &ELSE
                    ASSIGN pedido-compr.log-intregr-portal = NO.
                &ENDIF
            END.
            ELSE DO:
                &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                    ASSIGN SUBSTRING(pedido-compr.char-1,54,1) = "S":U.
                &ELSE
                    ASSIGN pedido-compr.log-erro-integr = YES.
                &ENDIF
            END.

            &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                ASSIGN OVERLAY(pedido-compr.char-1,2, 1)   = "N":U.
            &ELSE
                ASSIGN pedido-compr.log-congela-ped = NO.
            &ENDIF

            RELEASE pedido-compr.
            FOR EACH ordem-compra
               WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-LOCK:
                  CREATE tt-ordem-compra.
                  ASSIGN tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem.
            END.

            FOR EACH tt-ordem-compra:
                FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL ordem-compra THEN DO:
                    IF NOT l-integra-portal-paradigma THEN DO:
                        &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                            ASSIGN OVERLAY(ordem-compra.char-1, 90, 1) = "N":U.
                        &ELSE
                            ASSIGN ordem-compra.log-intregr-portal = NO.
                        &ENDIF
                    END.
                    ELSE DO:
                        &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                            ASSIGN substring(ordem-compra.char-1,192,1) = "S":U.
                        &ELSE
                            ASSIGN ordem-compra.log-erro-integr = YES.
                        &ENDIF
                    END.
                    
                    &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                        ASSIGN OVERLAY(ordem-compra.char-1, 91, 1)  = "N":U.
                    &ELSE
                        ASSIGN ordem-compra.log-congela-ord = NO.
                    &ENDIF

                    FOR EACH cotacao-item
                       WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                         AND cotacao-item.cod-emitente = ordem-compra.cod-emitente 
                         AND cotacao-item.it-codigo    = ordem-compra.it-codigo NO-LOCK:
                        CREATE tt-cotacao-item.
                        ASSIGN tt-cotacao-item.numero-ordem = cotacao-item.numero-ordem
                               tt-cotacao-item.cod-emitente = cotacao-item.cod-emitente
                               tt-cotacao-item.it-codigo    = cotacao-item.it-codigo
                               tt-cotacao-item.seq-cotac    = cotacao-item.seq-cotac.
                    END.

                    RELEASE ordem-compra.    

                    FOR EACH tt-cotacao-item:
                        FIND FIRST cotacao-item
                             WHERE cotacao-item.numero-ordem  = tt-cotacao-item.numero-ordem AND
                                   cotacao-item.cod-emitente  = tt-cotacao-item.cod-emitente AND
                                   cotacao-item.it-codigo     = tt-cotacao-item.it-codigo    AND
                                   cotacao-item.seq-cotac     = tt-cotacao-item.seq-cotac EXCLUSIVE-LOCK NO-ERROR.
                        IF AVAIL cotacao-item THEN DO:
                            IF NOT l-integra-portal-paradigma THEN DO:
                                &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                                    ASSIGN OVERLAY(cotacao-item.char-2, 102,1)  = "N":U.
                                &ELSE
                                    ASSIGN cotacao-item.log-intregr-portal = NO.
                                &ENDIF
                            END.
                            &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                                ASSIGN OVERLAY(cotacao-item.char-2,101,1)  = "N":U
                                       OVERLAY(cotacao-item.char-2,157,17) = "":U.
                            &ELSE
                                assign cotacao-item.val-preco-liq-item = 0
                                       cotacao-item.log-congela-cotac  = NO.
                            &ENDIF

                            RELEASE cotacao-item.
                        END.
                    END.
                END.
            END.
        END.
        ELSE DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "NÆo_encontrado_pedido_de_compra_com_o_n£mero_recebido" *}
            RUN setError IN hMessageHandler (INPUT 2,
                                             INPUT "business_error":U,
                                             INPUT RETURN-VALUE).
             CREATE tt_log_erro.
             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "NÆo_encontrado_pedido_de_compra_com_o_n£mero_recebido" *}
             ASSIGN tt_log_erro.ttv_num_cod_erro = 2
                    tt_log_erro.ttv_des_msg_erro = RETURN-VALUE.
        END.

        IF NOT l-integra-portal-paradigma THEN DO:
            FOR EACH ttErrors:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-criacao-do-pedido AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Cria‡Æo_do_pedido" *}
                ASSIGN c-lbl-liter-criacao-do-pedido = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-no-portal-de-compras AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "no_portal_de_compras" *}
                ASSIGN c-lbl-liter-no-portal-de-compras = TRIM(RETURN-VALUE).
                RUN setError IN hMessageHandler (INPUT 1,
                                                 INPUT "business_warning":U,
                                                 INPUT c-lbl-liter-criacao-do-pedido + " " + string(NumberERP) + " " + c-lbl-liter-no-portal-de-compras + ": " + ttErrors.desc-error).
                CREATE tt_log_erro.
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-criacao-do-pedido-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Cria‡Æo_do_pedido" *}
                ASSIGN c-lbl-liter-criacao-do-pedido-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-no-portal-de-compras-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "no_portal_de_compras" *}
                ASSIGN c-lbl-liter-no-portal-de-compras-2 = TRIM(RETURN-VALUE).
                ASSIGN tt_log_erro.ttv_num_cod_erro = 1
                       tt_log_erro.ttv_des_msg_erro = c-lbl-liter-criacao-do-pedido-2 + " " + string(NumberERP) + " " + c-lbl-liter-no-portal-de-compras-2 + ": " + ttErrors.desc-error.
            END.
        END.
    END.
    ELSE IF ConfirmType = "requisition":U THEN DO:
        
        FIND ordem-compra WHERE ordem-compra.numero-ordem = NumberERP EXCLUSIVE-LOCK NO-ERROR.
    
        IF AVAIL ordem-compra THEN DO:

            IF NOT l-integra-portal-paradigma THEN DO:
                &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                    ASSIGN OVERLAY(ordem-compra.char-1,91,1) = "N":U.
                &ELSE    
                    ASSIGN ordem-compra.log-integr-portal = NO.                  
                &ENDIF
            END.

            &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                ASSIGN OVERLAY(ordem-compra.char-1,90,1) = "N":U.
            &ELSE    
                ASSIGN ordem-compra.log-congela-ord   = NO.                  
            &ENDIF

            &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                ASSIGN substring(ordem-compra.char-1,192,1) = "S":U.
            &ELSE
                ASSIGN ordem-compra.log-erro-integr = YES.
            &ENDIF
        END.
        ELSE DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "NÆo_encontrada_ordem_de_compra_com_o_n£mero_recebido" *}
            RUN setError IN hMessageHandler (INPUT 3,
                                             INPUT "business_error":U,
                                             INPUT RETURN-VALUE).
             CREATE tt_log_erro.
             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "NÆo_encontrada_ordem_de_compra_com_o_n£mero_recebido" *}
             ASSIGN tt_log_erro.ttv_num_cod_erro = 3
                    tt_log_erro.ttv_des_msg_erro = RETURN-VALUE.
        END.

        IF NOT l-integra-portal-paradigma THEN DO:
            FOR EACH ttErrors:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-criacao-da-ordem AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Cria‡Æo_da_ordem" *}
                ASSIGN c-lbl-liter-criacao-da-ordem = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-no-portal-de-compras-3 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "no_portal_de_compras" *}
                ASSIGN c-lbl-liter-no-portal-de-compras-3 = TRIM(RETURN-VALUE).
                RUN setError IN hMessageHandler (INPUT 1,
                                                 INPUT "business_warning":U,
                                                 INPUT c-lbl-liter-criacao-da-ordem + " " + string(NumberERP) + " " + c-lbl-liter-no-portal-de-compras-3 + ": " + ttErrors.desc-error).
                CREATE tt_log_erro.
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-criacao-da-ordem-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Cria‡Æo_da_ordem" *}
                ASSIGN c-lbl-liter-criacao-da-ordem-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-no-portal-de-compras-4 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "no_portal_de_compras" *}
                ASSIGN c-lbl-liter-no-portal-de-compras-4 = TRIM(RETURN-VALUE).
                ASSIGN tt_log_erro.ttv_num_cod_erro = 1
                       tt_log_erro.ttv_des_msg_erro = c-lbl-liter-criacao-da-ordem-2 + " " + string(NumberERP) + " " + c-lbl-liter-no-portal-de-compras-4 + ": " + ttErrors.desc-error.  
    
            END.
        END.
    END.
END.
ELSE DO:
    IF ConfirmStatus = "200":U THEN DO:
        IF ConfirmType = "requisition":U THEN DO:
            
            FIND FIRST ordem-compra
                 WHERE ordem-compra.numero-ordem = NumberERP EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL ordem-compra THEN DO:

                IF l-integra-portal-paradigma THEN DO:
                    &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                        ASSIGN substring(ordem-compra.char-1, 91,1) = "S":U
                               substring(ordem-compra.char-1,192,1) = "N":U.
                    &ELSE    
                        ASSIGN ordem-compra.log-intregr-portal = YES
                               ordem-compra.log-erro-integr    = NO.
                    &ENDIF
                END.
                ELSE DO:
                    &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                        ASSIGN OVERLAY(ordem-compra.char-1, 142,50) = NumberPortal.
                    &ELSE    
                        ASSIGN ordem-compra.cod-ord-pai-portal = NumberPortal.                  
                    &ENDIF
                END.
                RELEASE ordem-compra.
            END.
            ELSE DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "NÆo_encontrada_ordem_de_compra_com_o_n£mero_recebido" *}
                RUN setError IN hMessageHandler (INPUT 3,
                                                 INPUT "business_error":U,
                                                 INPUT RETURN-VALUE).
                 CREATE tt_log_erro.
                 /* Inicio -- Projeto Internacional */
                 {utp/ut-liter.i "NÆo_encontrada_ordem_de_compra_com_o_n£mero_recebido" *}
                 ASSIGN tt_log_erro.ttv_num_cod_erro = 3
                        tt_log_erro.ttv_des_msg_erro = RETURN-VALUE.
            END.
        END.
        ELSE DO:
            IF ConfirmType = "order":U AND l-integra-portal-paradigma THEN DO:
                EMPTY TEMP-TABLE tt-ordem-compra.
                EMPTY TEMP-TABLE tt-cotacao-item.

                FIND FIRST pedido-compr
                     WHERE pedido-compr.num-pedido = NumberERP EXCLUSIVE-LOCK NO-ERROR.
    
                IF AVAIL pedido-compr THEN DO:
                    &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                        ASSIGN OVERLAY(pedido-compr.char-1,1,1)    = "S":U
                               SUBSTRING(pedido-compr.char-1,54,1) = "N":U
                               substring(pedido-compr.char-1,57,1) = "S":U.
                    &ELSE    
                        ASSIGN pedido-compr.log-intregr-portal     = YES
                               pedido-compr.log-erro-integr        = NO
                               pedido-compr.log-pend-aceite-fornec = YES.
                    &ENDIF

                    FOR EACH ordem-compra NO-LOCK
                       WHERE ordem-compra.num-pedido = pedido-compr.num-pedido:
                          CREATE tt-ordem-compra.
                          ASSIGN tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem.
                    END.

                    RELEASE pedido-compr.

                    FOR EACH tt-ordem-compra:
                        FIND FIRST ordem-compra EXCLUSIVE-LOCK
                             WHERE ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem NO-ERROR.
                        IF AVAIL ordem-compra THEN DO:
                            &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                                ASSIGN OVERLAY(ordem-compra.char-1,91,1)    = "S":U
                                       OVERLAY(ordem-compra.char-1,90, 1)   = "S":U
                                       substring(ordem-compra.char-1,192,1) = "N":U.
                            &ELSE
                                ASSIGN ordem-compra.log-intregr-portal = YES
                                       ordem-compra.log-congela-ord    = YES
                                       ordem-compra.log-erro-integr    = NO.
                            &ENDIF

                            FOR EACH cotacao-item NO-LOCK
                               WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                                 AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                                 AND cotacao-item.it-codigo    = ordem-compra.it-codigo:
                                CREATE tt-cotacao-item.
                                ASSIGN tt-cotacao-item.numero-ordem = cotacao-item.numero-ordem
                                       tt-cotacao-item.cod-emitente = cotacao-item.cod-emitente
                                       tt-cotacao-item.it-codigo    = cotacao-item.it-codigo
                                       tt-cotacao-item.seq-cotac    = cotacao-item.seq-cotac.
                            END.

                            RELEASE ordem-compra.

                            FOR EACH tt-cotacao-item:
                                FIND FIRST cotacao-item EXCLUSIVE-LOCK
                                     WHERE cotacao-item.numero-ordem  = tt-cotacao-item.numero-ordem
                                       AND cotacao-item.cod-emitente  = tt-cotacao-item.cod-emitente
                                       AND cotacao-item.it-codigo     = tt-cotacao-item.it-codigo
                                       AND cotacao-item.seq-cotac     = tt-cotacao-item.seq-cotac NO-ERROR.
                                IF AVAIL cotacao-item THEN DO:
                                    &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                                        ASSIGN OVERLAY(cotacao-item.char-2,102,1) = "S":U
                                               OVERLAY(cotacao-item.char-2,101,1) = "S":U.
                                    &ELSE
                                        ASSIGN cotacao-item.log-intregr-portal = YES
                                               cotacao-item.log-congela-cotac  = YES.
                                    &ENDIF

                                    RELEASE cotacao-item.
                                END.
                            END.
                        END.
                    END.
                END.
                ELSE DO:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "NÆo_encontrado_pedido_de_compra_com_o_n£mero_recebido" *}
                    RUN setError IN hMessageHandler (INPUT 2,
                                                     INPUT "business_error":U,
                                                     INPUT RETURN-VALUE).
                     CREATE tt_log_erro.
                     /* Inicio -- Projeto Internacional */
                     {utp/ut-liter.i "NÆo_encontrado_pedido_de_compra_com_o_n£mero_recebido" *}
                     ASSIGN tt_log_erro.ttv_num_cod_erro = 2
                            tt_log_erro.ttv_des_msg_erro = RETURN-VALUE.
                END.
            END.
        END.
    END.
END.
    

