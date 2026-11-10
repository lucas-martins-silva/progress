FIND FIRST pedido-compr
     WHERE pedido-compr.num-pedido = PoNumber EXCLUSIVE-LOCK NO-ERROR.
IF  NOT AVAIL pedido-compr THEN DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Pedido_de_Compra" *}
    run utp/ut-msgs.p (INPUT 'msg',
                       INPUT 2,
                       INPUT RETURN-VALUE).

    CREATE RowErrors.
    ASSIGN RowErrors.ErrorSequence    = i-cont-err + 1
           RowErrors.ErrorNumber      = 2
           RowErrors.ErrorType        = "EMS"
           RowErrors.ErrorSubType     = "Error":U
           RowErrors.ErrorDescription = RETURN-VALUE
           i-cont-err                 = i-cont-err + 1.

    RETURN 'NOK'.
END.
ELSE DO:
    
    /* Cria mensagem com o pedido encontrado */
        RUN reset       IN hGenXml.
        RUN setEncoding IN hGenXml ("UTF-8":U).


        IF iStatus = 99 THEN DO:

            FIND FIRST ext-ped-compra-eai
                 WHERE ext-ped-compra-eai.num-pedido = PONumber EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL ext-ped-compra-eai THEN
                ASSIGN ext-ped-compra-eai.cdn-sit = iStatus.
            ELSE DO:

                CREATE ext-ped-compra-eai.
                ASSIGN ext-ped-compra-eai.num-pedido = PONumber
                       ext-ped-compra-eai.cdn-sit   = iStatus.

            END.

        END.
        ELSE DO:

            ASSIGN pedido-compr.situacao = iStatus.

            FIND FIRST ext-ped-compra-eai
                 WHERE ext-ped-compra-eai.num-pedido = PONumber EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL ext-ped-compra-eai THEN
                DELETE ext-ped-compra-eai.

        END.
        
END.


IF CAN-FIND (FIRST RowErrors) THEN do: /* Erros ocorridos durante efetiva‡Æo do registro */
    FOR EACH RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U : 
        IF RowErrors.ErrorSubType = "ERROR":U THEN
           RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                            INPUT "business_error":U,
                                            INPUT RowErrors.ErrorDescription + " - " + RowErrors.ErrorHelp).

        ELSE IF RowErrors.ErrorSubType = "WARNING":U THEN
             RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                              INPUT "business_warning":U,
                                              INPUT RowErrors.ErrorDescription + " - " + RowErrors.ErrorHelp).

        ELSE IF RowErrors.ErrorSubType = "INFORMATION":U THEN
             RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                              INPUT "business_information":U,
                                              INPUT RowErrors.ErrorDescription + " - " + RowErrors.ErrorHelp).
    END.

END.




