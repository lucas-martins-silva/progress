    DEFINE BUFFER bf-nota-fiscal FOR nota-fiscal.
    
    EMPTY TEMP-TABLE RowErrors NO-ERROR.

    ERROR-STATUS:ERROR = FALSE.

    RUN ftp/ftapi500a.p PERSISTENT SET h-ftapi500a.

    IF  NOT AVAIL tt-docto-adapter THEN
        FIND FIRST tt-docto-adapter NO-LOCK NO-ERROR.

    ASSIGN c-id-duplic = STRING(tt-docto-adapter.num-cx-financ) + "|" + STRING(tt-docto-adapter.num-process-negoc).
    
    IF c-id-pedido <> "" THEN DO:
        FIND FIRST nota-fisc-adc 
             WHERE nota-fisc-adc.cod-estab = tt-docto-adapter.cod-estabel
               AND nota-fisc-adc.cod-serie = "32"                        
               AND nota-fisc-adc.cod-nota-fisc = c-id-pedido             
               AND nota-fisc-adc.cdn-emitente = 32                       
               AND nota-fisc-adc.cod-natur-operac = "32"                 
               AND nota-fisc-adc.idi-tip-dado = 32
               AND nota-fisc-adc.num-seq = 1 NO-LOCK NO-ERROR.
     
        IF AVAIL nota-fisc-adc THEN DO:
            /* Pedido de execu‡Æo em andamento */  
            {utp/ut-liter.i J _existe_um_pedido_de_execu‡Æo_para_essa_nota_fiscal}
            RUN setError IN hMessageHandler (INPUT 17006,
                                             INPUT "enviroment_error":U,
                                             INPUT RETURN-VALUE).
            ASSIGN l-error = YES.
        END.
        ELSE DO:
            FIND FIRST nota-fisc-adc 
                 WHERE nota-fisc-adc.cod-estab    = tt-docto-adapter.cod-estabel
                   AND nota-fisc-adc.idi-tip-dado = 32   
                   AND nota-fisc-adc.cod-area     = c-id-duplic
                   AND nota-fisc-adc.cod-terminal = c-id-pedido NO-LOCK NO-ERROR.

            IF AVAIL nota-fisc-adc THEN DO:
                /* Pedido de execu‡Æo finalizado */
                CREATE ttRetornaCliente.
                ASSIGN ttRetornaCliente.XMLElementName = "nr-nota-fiscal"
                       ttRetornaCliente.FieldValue     = DEC(nota-fisc-adc.cod-nota-fisc)
                       l-error = YES.
            END.
            ELSE DO:
                CREATE nota-fisc-adc.
                ASSIGN nota-fisc-adc.cod-estab = tt-docto-adapter.cod-estabel
                       nota-fisc-adc.cod-serie = "32"                        
                       nota-fisc-adc.cod-nota-fisc = c-id-pedido             
                       nota-fisc-adc.cdn-emitente = 32                       
                       nota-fisc-adc.cod-natur-operac = "32"                 
                       nota-fisc-adc.idi-tip-dado = 32
                       nota-fisc-adc.num-seq = 1.                 
            END.
        END.                                                                             
    END.

    IF l-error = NO THEN DO:
    
    	/* Inicio -- Projeto Internacional */
    	{utp/ut-liter.i "chamar_pi-execucao" *}
        RUN pi-execucao IN h-ftapi500a (INPUT TABLE tt-docto-adapter,
                                        INPUT TABLE tt-fat-repre-adapter,
                                        INPUT TABLE tt-it-docto-adapter,
                                        INPUT TABLE tt-it-docto-imp-adapter,
                                        INPUT TABLE tt-fat-duplic-adapter,
                                        INPUT TABLE tt-nota-embal-adapter,
                                        INPUT TABLE tt-item-embal-adapter,
                                        INPUT TABLE tt-saldo-estoq-adapter,
                                        OUTPUT TABLE tt-notas-geradas,
                                        OUTPUT TABLE rowErrors).
    
        IF NOT CAN-FIND(tt-notas-geradas) OR CAN-FIND(rowErrors) THEN DO:
            FOR EACH rowErrors:
                RUN setError IN hMessageHandler (INPUT rowErrors.errorNumber,
                                                 INPUT "enviroment_error":U,
                                                 INPUT RowErrors.errorDescription).
            END.

            FOR FIRST nota-fisc-adc EXCLUSIVE-LOCK
                WHERE nota-fisc-adc.cod-estab = tt-docto-adapter.cod-estabel
                  AND nota-fisc-adc.cod-serie = "32" 
                  AND nota-fisc-adc.cod-nota-fisc = c-id-pedido
                  AND nota-fisc-adc.cdn-emitente = 32
                  AND nota-fisc-adc.cod-natur-operac = "32"  
                  AND nota-fisc-adc.idi-tip-dado = 32
                  AND nota-fisc-adc.num-seq = 1:
                DELETE nota-fisc-adc.
            END.
        END.
    END.

    FOR EACH tt-notas-geradas:

        CREATE ttRetornaCliente.
        ASSIGN ttRetornaCliente.XMLElementName = "nr-nota-fiscal"
               ttRetornaCliente.FieldValue     = dec(tt-notas-geradas.nr-nota).

        /*--- PRJ 1066 Integra‡Æo Farm cia x EMS - gravar n£mero do cupom final na tabela nota-fiscal ---*/
        IF  NOT AVAIL tt-docto-adapter THEN
            FIND FIRST tt-docto-adapter NO-LOCK NO-ERROR.

        FOR FIRST bf-nota-fiscal EXCLUSIVE-LOCK
            WHERE ROWID(bf-nota-fiscal) = tt-notas-geradas.rw-nota-fiscal:

            IF  AVAIL tt-docto-adapter
            AND tt-docto-adapter.cod-cf-final <> "" THEN DO:
                &if '{&bf_dis_versao_ems}' >= '2.09' &then
                    ASSIGN bf-nota-fiscal.cod-cf-final           = tt-docto-adapter.cod-cf-final.
                &else
                    ASSIGN OVERLAY(bf-nota-fiscal.char-2,184,16) = tt-docto-adapter.cod-cf-final.
                &endif          
            END.
            
            /* Gravar as tags CashierNumber e TradingProcessNumber na nota-fiscal */
            IF  AVAIL tt-docto-adapter 
                AND (tt-docto-adapter.num-cx-financ     > 0 OR
                     tt-docto-adapter.num-process-negoc > 0) THEN DO:
                ASSIGN bf-nota-fiscal.num-cx-financ     = tt-docto-adapter.num-cx-financ  
                       bf-nota-fiscal.num-process-negoc = tt-docto-adapter.num-process-negoc.    
            END.
            
            FOR FIRST nota-fisc-adc EXCLUSIVE-LOCK
                WHERE nota-fisc-adc.cod-estab        = bf-nota-fiscal.cod-estabel
                  AND nota-fisc-adc.cod-serie        = "32"                         
                  AND nota-fisc-adc.cod-nota-fisc    = c-id-pedido              
                  AND nota-fisc-adc.cdn-emitente     = 32                        
                  AND nota-fisc-adc.cod-natur-operac = "32"                  
                  AND nota-fisc-adc.idi-tip-dado     = 32                        
                  AND nota-fisc-adc.cod-area         = c-id-duplic
                  AND nota-fisc-adc.num-seq          = 1:                  
                  
                  DELETE nota-fisc-adc.
            END.

            CREATE nota-fisc-adc.
            ASSIGN nota-fisc-adc.cod-estab        = bf-nota-fiscal.cod-estabel
                   nota-fisc-adc.cod-serie        = bf-nota-fiscal.serie
                   nota-fisc-adc.cod-nota-fisc    = bf-nota-fiscal.nr-nota-fis
                   nota-fisc-adc.cdn-emitente     = bf-nota-fiscal.cod-emitente
                   nota-fisc-adc.cod-natur-operac = bf-nota-fiscal.nat-operacao
                   nota-fisc-adc.idi-tip-dado     = 32                        
                   nota-fisc-adc.num-seq          = 1
                   nota-fisc-adc.cod-area         = c-id-duplic
                   nota-fisc-adc.cod-terminal     = c-id-pedido.
        END.
    END.

    IF  VALID-HANDLE (h-ftapi500a) THEN DO:
        DELETE PROCEDURE h-ftapi500a.
        ASSIGN h-ftapi500a = ?.
    END.

    /*IF ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execu‡Æo do programa */
      DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
         cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
      END.
      RUN setError IN hMessageHandler (INPUT 0,
                                       INPUT "enviroment_error":U,
                                       INPUT "Erro de integra‡Æo. Erro ao executar o programa 'ftp/ftapi500.p' pelo programa adapters/xml/ep2/axrep005.p. Durante sua execu‡Æo ocorreu o(s) seguinte(s) erro(s) Progress: " + cErrorText).
    END.
    */
