
    EMPTY TEMP-TABLE tt-integra-fornecedor.

    FIND FIRST ttCustomerVendorIDInforma_00 NO-LOCK NO-ERROR.

    FIND FIRST ttCustomerVendorAddressIn_00 NO-LOCK NO-ERROR.

    FIND FIRST ttCustomerVendorCommunica_00 NO-LOCK NO-ERROR.

    /* Criando Temp-table auxiliar para agrupar os dados */
    CREATE tt-integra-fornecedor.

    IF AVAIL ttCustomerVendorIDInforma_00 THEN DO:
        ASSIGN tt-integra-fornecedor.cgc           = ttCustomerVendorIDInforma_00.TaxID
               tt-integra-fornecedor.nome-emit     = ttCustomerVendorIDInforma_00.CustomerVendorName
               tt-integra-fornecedor.ins-estadual  = ttCustomerVendorIDInforma_00.TaxExemptionNumber
               tt-integra-fornecedor.ins-municipal = ttCustomerVendorIDInforma_00.Registration.
    END.

    IF AVAIL ttCustomerVendorAddressIn_00 THEN DO:
        ASSIGN tt-integra-fornecedor.endereco      = ttCustomerVendorAddressIn_00.ShipToLocationDescription
               tt-integra-fornecedor.bairro        = ttCustomerVendorAddressIn_00.District
               tt-integra-fornecedor.cidade        = ttCustomerVendorAddressIn_00.City
               tt-integra-fornecedor.estado        = ttCustomerVendorAddressIn_00.State
               tt-integra-fornecedor.pais          = ttCustomerVendorAddressIn_00.Country
               tt-integra-fornecedor.cep           = ttCustomerVendorAddressIn_00.ZipCode.
    END.

    IF AVAIL ttCustomerVendorCommunica_00 THEN DO:
        ASSIGN tt-integra-fornecedor.telefone      = ttCustomerVendorCommunica_00.PhoneNumber
               tt-integra-fornecedor.email         = ttCustomerVendorCommunica_00.EMail
               tt-integra-fornecedor.homepage      = ttCustomerVendorCommunica_00.HomePage.
    END.

    IF AVAIL tt-integra-fornecedor THEN DO:
        IF LENGTH(tt-integra-fornecedor.cgc) > 11 THEN  /* 1 - Pessoa F¡sica, 2 - Pessoa Juridica */
            ASSIGN tt-integra-fornecedor.natureza-EMS2 = 2.
        ELSE
            ASSIGN tt-integra-fornecedor.natureza-EMS2 = 1.
    END.

    ASSIGN l-log-error = NO.

    FOR EACH emitente NO-LOCK
       WHERE emitente.cgc = tt-integra-fornecedor.cgc:

        /*verifica se existe fornecedor ativo com este cgc*/
        FIND FIRST dist-emitente NO-LOCK
             WHERE dist-emitente.cod-emitente   = emitente.cod-emitente
               AND dist-emitente.idi-sit-fornec = 1 /* Ativo */ NO-ERROR. 
        IF AVAIL dist-emitente THEN DO:
            ASSIGN c-cod-fornecedor    = emitente.cod-emitente
                   l-existe-fornecedor = YES.
            LEAVE.
        END.
        ELSE DO: /*verifica se existe fornecedor com estado diferente de inativo com este cgc*/
            FIND FIRST dist-emitente NO-LOCK
                 WHERE dist-emitente.cod-emitente   = emitente.cod-emitente
                   AND dist-emitente.idi-sit-fornec <> 1 /* Ativo */ NO-ERROR.
            IF AVAIL dist-emitente THEN DO:
                ASSIGN c-cod-fornecedor    = emitente.cod-emitente
                       l-existe-fornecedor = YES.
                LEAVE.
            END.
        END.
    END.

    /* Se nÆo existe fornecedor com este CPF/CNPJ cadastrado dever  efetuar a cria‡Æo do mesmo no ERP */
    IF NOT l-existe-fornecedor THEN DO:

        RUN pi-integra-ems2. /* Usa api cdapi366b.p para criar o fornecedor */

        /* Ap¢s a cria‡Æo, tratar os erros e integrar no portal o fornecedor com o c¢digo do EMS */
        /* ALIMENTA€ÇO DOS ERROS OCORRIDOS NA EFETIVA€ÇO */
        FOR EACH tt_retorno_clien_fornec:

            FIND FIRST cadast_msg NO-LOCK
                 WHERE cadast_msg.cdn_msg = tt_retorno_clien_fornec.ttv_num_mensagem NO-ERROR.
            IF AVAIL cadast_msg THEN DO:
                IF cadast_msg.idi_tip_msg = 1 /*Erro*/ THEN DO:

                    /* INFORMA AO MESSAGE HANDLER UM ERRO QUE DEVE ESTAR PRESENTE NA MENSAGEM DE RETORNO */
                    RUN setError IN hMessageHandler (INPUT tt_retorno_clien_fornec.ttv_num_mensagem,
                                                     INPUT "business_error",
                                                     INPUT tt_retorno_clien_fornec.ttv_des_ajuda).

                    ASSIGN l-log-error = YES.

                    DELETE tt_retorno_clien_fornec.
                END.
                ELSE DO: /*Aviso*/

                    /* INFORMA AO MESSAGE HANDLER UM ERRO QUE DEVE ESTAR PRESENTE NA MENSAGEM DE RETORNO */
                    RUN setError IN hMessageHandler (INPUT tt_retorno_clien_fornec.ttv_num_mensagem,
                                                     INPUT "business_warning",
                                                     INPUT tt_retorno_clien_fornec.ttv_des_ajuda).

                    DELETE tt_retorno_clien_fornec.
                END.
            END.
            ELSE DO: /*caso a mensagem nÆo esteja cadastrada no EMS 2*/
                RUN setError IN hMessageHandler (INPUT tt_retorno_clien_fornec.ttv_num_mensagem,
                                                 INPUT "business_warning",
                                                 INPUT tt_retorno_clien_fornec.ttv_des_ajuda).
    
                DELETE tt_retorno_clien_fornec.
            END.
        END.
        
        FOR FIRST emitente EXCLUSIVE-LOCK
            WHERE emitente.cod-emitente = c-cod-fornecedor:

            /* Indica que fornecedor teve sua origem no portal paradigma */
            &if '{&BF_DIS_VERSAO_EMS}' >= '2.09' &then
                ASSIGN emitente.log-orig-portal-paradigma = YES.
            &else
                ASSIGN OVERLAY(emitente.char-2,77,1) = "S":U.
            &endif
        END.

        FOR FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = c-cod-fornecedor:
            FOR FIRST dist-emitente EXCLUSIVE-LOCK
                WHERE dist-emitente.cod-emitente    = emitente.cod-emitente:
                ASSIGN dist-emitente.idi-sit-fornec = 4. /*Inativo*/
            END.
        END.
    END.
    ELSE DO:
        {utp/ut-liter.i Fornecedor_j _est _cadastrado_no_ERP!_O_fornecedor_ *}
        ASSIGN c-auxliter = RETURN-VALUE.

        {utp/ut-liter.i _j _existe_no_ERP.}
        ASSIGN c-auxliter = c-auxliter + String(c-cod-fornecedor) + RETURN-VALUE.

        RUN setError IN hMessageHandler (INPUT 1,
                                         INPUT "business_warning",
                                         INPUT c-auxliter).
    END.

    /* Parametro: Integra com Portal de Compras */
    FOR FIRST emitente EXCLUSIVE-LOCK
        WHERE emitente.cod-emitente = c-cod-fornecedor:
        &if '{&BF_DIS_VERSAO_EMS}' >= '2.09' &then
            ASSIGN emitente.log-portal-paradigma = YES.
        &else
            ASSIGN OVERLAY(emitente.char-2,76,1) = "S":U.
        &endif
    END.

    RELEASE emitente.

    IF NOT l-log-error THEN DO:
        find first emitente
             where emitente.cod-emitente = c-cod-fornecedor no-lock no-error.
        if avail emitente then do:
    
            run adapters/xml/fi2/axsfi001.p persistent set h_axsfi001 (OUTPUT TABLE tt_log_erro).
            if valid-handle(h_axsfi001) then do:
                run PITransUpsert in h_axsfi001(input  ROWID(emitente),
                                                INPUT  "upd":U,
                                                OUTPUT TABLE tt_log_erro).
            END.
    
            delete procedure h_axsfi001.
            ASSIGN h_axsfi001 = ?.
    
            IF CAN-FIND(FIRST tt_log_erro WHERE tt_log_erro.ttv_num_cod_erro <> 60 NO-LOCK) THEN DO:
                         
                FOR EACH tt_log_erro WHERE tt_log_erro.ttv_num_cod_erro <> 60 NO-LOCK:
                    FIND FIRST cadast_msg NO-LOCK
                         WHERE cadast_msg.cdn_msg = tt_log_erro.ttv_num_cod_erro NO-ERROR.
                    IF AVAIL cadast_msg THEN DO:
                        IF cadast_msg.idi_tip_msg = 1 /*Erro*/ THEN
                            /* INFORMA AO MESSAGE HANDLER UM ERRO QUE DEVE ESTAR PRESENTE NA MENSAGEM DE RETORNO */
                            RUN setError IN hMessageHandler (INPUT tt_log_erro.ttv_num_cod_erro,
                                                             INPUT "business_error",
                                                             INPUT tt_log_erro.ttv_des_msg_erro).
                        ELSE DO:
                            IF cadast_msg.idi_tip_msg = 2 /*Aviso*/      OR
                               cadast_msg.idi_tip_msg = 4 /*Informa‡Æo*/ THEN
                                /* INFORMA AO MESSAGE HANDLER UM ERRO QUE DEVE ESTAR PRESENTE NA MENSAGEM DE RETORNO */
                                RUN setError IN hMessageHandler (INPUT tt_log_erro.ttv_num_cod_erro,
                                                                 INPUT "business_warning",
                                                                 INPUT tt_log_erro.ttv_des_msg_erro).
                        END.
                    END.
                END.
            END.
        end.
    END.
