IF l-integra-webb THEN DO:
    IF cTranAction = "add":U THEN DO:
        FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = ttPurchaseOrderLine.POLineNumber NO-LOCK NO-ERROR.
                      
        IF NOT AVAIL ordem-compra THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Ordem_de_compra_inv lida" *}
            run utp/ut-msgs.p (INPUT 'msg':U,
                               INPUT 6364,
                               INPUT RETURN-VALUE).
        
            CREATE tt_log_erro.                  
            ASSIGN tt_log_erro.ttv_num_cod_erro = 6364
                   tt_log_erro.ttv_des_msg_erro = trim(RETURN-VALUE).
            
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Ordem_de_compra_inv lida" *}
            RUN setError IN hMessageHandler (INPUT 6364,
                                             INPUT "business_error":U,
                                             INPUT RETURN-VALUE).
            
            RETURN "NOK":U.
        END.
        
        IF i-natureza <> 0 THEN DO:
            IF i-natureza <> ordem-compra.natureza THEN DO:
                run utp/ut-msgs.p (INPUT 'msg':U,
                                   INPUT 51530,
                                   INPUT "").
              
                CREATE tt_log_erro.                  
                ASSIGN tt_log_erro.ttv_num_cod_erro = 51530
                       tt_log_erro.ttv_des_msg_erro = trim(RETURN-VALUE).
                
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "As_ordens_de_compra_do_pedido_devem_possuir_a_mesma_natureza" *}
                RUN setError IN hMessageHandler (INPUT 51530,
                                                 INPUT "business_error":U,
                                                 INPUT RETURN-VALUE).  
                RETURN "NOK":U.          
            END.
            ELSE DO:
                ASSIGN i-natureza = ordem-compra.natureza.
            END.
        END.
        ELSE DO:
            ASSIGN i-natureza = ordem-compra.natureza
                   tt-pedido-compr.natureza = i-natureza.
        END.
    END.
    ELSE DO:
    
        FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = ttPurchaseOrderLine.POLineNumber NO-LOCK NO-ERROR.
     
        IF AVAIL ordem-compra THEN DO:
            ASSIGN ttPurchaseOrderLine.POLineNumber = ordem-compra.numero-ordem.    
        END.
        ELSE DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Ordem_de_compra_inv lida" *}
            run utp/ut-msgs.p (INPUT 'msg':U,
                               INPUT 6364,
                               INPUT RETURN-VALUE).
    
            CREATE tt_log_erro.                  
            ASSIGN tt_log_erro.ttv_num_cod_erro = 6364
                   tt_log_erro.ttv_des_msg_erro = trim(RETURN-VALUE).
    
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Ordem_de_compra_inv lida" *}
            RUN setError IN hMessageHandler (INPUT 6364,
                                 INPUT "business_error":U,
                                 INPUT RETURN-VALUE).
    
            RETURN "NOK":U.
        END.
    END.
END.
