PROCEDURE pi-cria-processo-compra:

    /* Se vier informaá‰es do processo de compra na mensagem */
    IF AVAIL ttPurchaseProcess THEN DO:
       EMPTY TEMP-TABLE tt-proc-compra.

        CREATE tt-proc-compra.
        ASSIGN tt-proc-compra.nr-processo  = ttPurchaseProcess.PurchaseProcessNumber
               tt-proc-compra.descricao    = ttPurchaseProcess.ProcessDescription 
               tt-proc-compra.cod-comprado = ttQuotationLine.BuyerID
               tt-proc-compra.dt-inicio    = TODAY  
               tt-proc-compra.narrativa    = ttPurchaseProcess.ProcessText.

        FIND FIRST proc-compra where proc-compra.descricao = ttPurchaseProcess.ProcessDescription no-lock no-error.

        RUN inbo/boin358.p   PERSISTENT SET h-boin358.
        RUN inbo/boin274vl.p PERSISTENT SET h-boin274vl.
        RUN inbo/boin359.p   PERSISTENT SET h-boin359.
    
        RUN openQueryStatic IN h-boin358 (INPUT "main":U).

        /* Se o processo ainda n∆o existir Ç necess†rio criar */
        IF NOT AVAIL proc-compra THEN DO:
            RUN emptyRowErrors   in h-boin358.
            RUN setdefaults      IN h-boin358 (OUTPUT tt-proc-compra.nr-processo).
            RUN setRecord        IN h-boin358 (INPUT TABLE tt-proc-compra).
            RUN createRecord     IN h-boin358.
    	    RUN getRowErrors     in h-boin358 (OUTPUT TABLE RowErrors).
        END.
        ELSE DO:
            ASSIGN tt-proc-compra.nr-processo = proc-compra.nr-processo.
        END.

        IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
            FOR FIRST ordem-compra FIELDS (numero-ordem nr-processo) no-lock where 
                       ordem-compra.numero-ordem = ttQuotationLine.POLineNumber  and 
                       ordem-compra.nr-processo  = 0:
                /* V°nculo de ordem de compra ao processo */   	
                RUN emptyRowErrors   in h-boin274vl.
                
                RUN SetaIntegracaoParadigma in h-boin274vl (INPUT YES). /* Indica que o processo foi criado na Paradigma */
                
                run validateProcesso in h-boin274vl(input tt-proc-compra.nr-processo,
                                                    input ttQuotationLine.POLineNumber,
                                                    output table rowErrors).
            END.
        END.

        IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
	 
            FIND FIRST proc-fornec WHERE
                       proc-fornec.nr-processo  = tt-proc-compra.nr-processo AND
                       proc-fornec.cod-emitente = ttQuotationLine.VendorNumber NO-LOCK NO-ERROR.

            /* V°nculo de fornecedor ao processo */
            IF NOT AVAIL proc-fornec THEN DO:
                RUN openQueryStatic IN h-boin359 (INPUT "main":U).
                
                EMPTY TEMP-TABLE tt-proc-fornec.

            	CREATE tt-proc-fornec.
            	ASSIGN tt-proc-fornec.cod-emitente = ttQuotationLine.VendorNumber
                       tt-proc-fornec.nr-processo  = tt-proc-compra.nr-processo.
    
            	RUN emptyRowErrors in h-boin359.
    	        RUN setRecord      IN h-boin359 (INPUT TABLE tt-proc-fornec).
    	        RUN createRecord   IN h-boin359.
    	        RUN getRowErrors   in h-boin359 (OUTPUT TABLE RowErrors).
            END.
        END.
    END.

    IF VALID-HANDLE(h-boin358)        AND
       h-boin358:TYPE = "PROCEDURE":U AND
       h-boin358:FILE-NAME = "inbo/boin358.p" THEN DO:
        DELETE PROCEDURE h-boin358.
        ASSIGN h-boin358 = ?.
    END.

    IF VALID-HANDLE(h-boin274vl)        AND
       h-boin274vl:TYPE = "PROCEDURE":U AND
       h-boin274vl:FILE-NAME = "inbo/boin274vl.p" THEN DO:
        DELETE PROCEDURE h-boin274vl.
        ASSIGN h-boin274vl = ?.
    END.

    IF VALID-HANDLE(h-boin359)        AND
       h-boin359:TYPE = "PROCEDURE":U AND
       h-boin359:FILE-NAME = "inbo/boin359.p" THEN DO:
        DELETE PROCEDURE h-boin359.
        ASSIGN h-boin359 = ?.
    END.

    RETURN "OK":U.
END.
