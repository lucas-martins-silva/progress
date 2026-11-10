EMPTY TEMP-TABLE RowErrors NO-ERROR.

FOR EACH ttCustomerScheduling:
    if  ttCustomerScheduling.customerID <> 0 
    then find first emitente no-lock where emitente.cod-emitente = ttCustomerScheduling.customerID no-error.
    else find first emitente no-lock where emitente.cgc = ttCustomerScheduling.customertaxID no-error.
    
    if  avail  emitente then do:
        ASSIGN i-idi-confir-programac-entreg = 1.
        FOR FIRST dist-emitente FIELDS(cod-emitente &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN idi-confir-programac-entreg &ELSE char-1 &ENDIF)
            WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK :
            ASSIGN i-idi-confir-programac-entreg = &IF "{&bf_dis_versao_ems}" >= "2.06" 
                                                   &THEN dist-emitente.idi-confir-programac-entreg
                                                   &ELSE INT(SUBSTR(dist-emitente.char-1,22,1))
                                                   &ENDIF.
        END. /* FOR FIRST dist-emitente */

        find first tt-prog-cli 
            where  tt-prog-cli.nome-abrev   = emitente.nome-abrev
            and    tt-prog-cli.cod-emitente = emitente.cod-emitente
            and    tt-prog-cli.nr-progcli   = ttCustomerScheduling.CustomerSchedulingNumber no-error.
        if  not avail tt-prog-cli then do:
            create tt-prog-cli.
            assign tt-prog-cli.cod-emitente = emitente.cod-emitente 
                   tt-prog-cli.nome-abrev   = emitente.nome-abrev
                   tt-prog-cli.nr-progcli   = ttCustomerScheduling.CustomerSchedulingNumber.

            run PI-DELJIT("PROG-CLI").
        end. /* if  not avail tt-prog-cli */

        assign tt-prog-cli.dt-emissao     = ttCustomerScheduling.registerDate
               tt-prog-cli.cd-situacao    = 2 /* ATIVO */
               tt-prog-cli.cd-origem      = 2
               tt-prog-cli.ind-tipo-movto = 1
               .
    end. /* if  avail  emitente then do: */

    FOR EACH ttItemScheduling OF ttCustomerScheduling:
        if  ttItemScheduling.CustomerItemCode <> "" then 
            find item-cli no-lock
                where item-cli.nome-abrev  = tt-prog-cli.nome-abrev
                and   item-cli.item-do-cli = ttItemScheduling.CustomerItemCode no-error. 

        create tt-prog-item.
        assign tt-prog-item.nome-abrev  = tt-prog-cli.nome-abrev
               tt-prog-item.nr-progcli  = tt-prog-cli.nr-progcli
               tt-prog-item.cod-entrega = ttItemScheduling.DeliveryLocationID
               tt-prog-item.it-codigo   = if avail item-cli then item-cli.it-codigo
                                                            else if ttItemScheduling.ItemCode <> "" 
                                                                 then ttItemScheduling.ItemCode
                                                                 else ttItemScheduling.CustomerItemCode
               tt-prog-item.cod-refer    = ttItemScheduling.ItemReferenceCode
               tt-prog-item.nr-pedcli    = ttItemScheduling.CustomerOrderNumber
               tt-prog-item.indicador    = 1.
        
        run PI-DELJIT("PROG-ITEM").

        assign tt-prog-item.cd-freq      = ttItemScheduling.FrequencyCode
               tt-prog-item.nr-nota-fis  = ttItemScheduling.DocumentNumber         
               tt-prog-item.serie        = ttItemScheduling.DocumentSeries         
               tt-prog-item.dt-ult-nf    = ttItemScheduling.LastDocumentNumberDate 
               tt-prog-item.loc-descarga = ttItemScheduling.DischargeLocation
               tt-prog-item.cd-situacao  = 2 /* ATIVO */ 
               tt-prog-item.dt-ult-ent   = ttItemScheduling.LastDeliveryDate
               tt-prog-item.contato      = ttItemScheduling.ContactName
               tt-prog-item.cd-origem    = 2
               tt-prog-item.erro-consist = no.

               overlay(tt-prog-item.char-1,100,1)  = if avail item-cli then "1" /* ITEM */
                                                                       else if ttItemScheduling.ItemCode <> "" 
                                                                            then "1"  /* ITEM */
                                                                            else "2". /* ITEM DO CLIENTE */

        assign tt-prog-item.qt-lote-min = ttItemScheduling.MinimumLotQuantity
               tt-prog-item.qt-nec-acum = ttItemScheduling.QuantityAccumNeed
               tt-prog-item.qt-ent-acum = ttItemScheduling.DeliveryQuantityAccum
               tt-prog-item.qt-ult-ent  = ttItemScheduling.LastDeliveryQuantity.
        
        FOR EACH ttDeliveryScheduling OF ttItemScheduling:

            if  ttDeliveryScheduling.DeliveryDate = '222222'
            or  ttDeliveryScheduling.DeliveryDate = '333333' 
            or  ttDeliveryScheduling.DeliveryDate = '444444' 
            or  ttDeliveryScheduling.DeliveryDate = '555555' 
            then assign c_dat_aux = ttDeliveryScheduling.DeliveryDate.
            else assign c_dat_aux = /* Dia */ substring(ttDeliveryScheduling.DeliveryDate, 9, 2) + 
                                    /* MÍs */ substring(ttDeliveryScheduling.DeliveryDate, 6, 2) + 
                                    /* Ano */ substring(ttDeliveryScheduling.DeliveryDate, 1, 4).
            
            run PI-VERIFICA-DATAS-ESPECIAIS (input-output c_dat_aux). 

            CASE ttDeliveryScheduling.DeliveryDate:
                WHEN '222222' THEN assign d-qt-pedida = 0.
                WHEN '555555' THEN assign d-qt-pedida = 0.
                OTHERWISE assign d-qt-pedida = ttDeliveryScheduling.OrderedQuantity.
            END CASE.

            assign ttDeliveryScheduling.DeliveryDate-aux = date(c_dat_aux) no-error.
            if  error-status:error then assign ttDeliveryScheduling.DeliveryDate-aux = ?.

            create tt-prog-ent.
            assign r-rowid-prog-ent        = ROWID(tt-prog-ent)
                   tt-prog-ent.nome-abrev  = tt-prog-cli.nome-abrev
                   tt-prog-ent.nr-progcli  = tt-prog-cli.nr-progcli
                   tt-prog-ent.cod-refer   = tt-prog-item.cod-refer
                   tt-prog-ent.cd-freq     = tt-prog-item.cd-freq
                   tt-prog-ent.nr-pedcli   = tt-prog-item.nr-pedcli
                   tt-prog-ent.cod-entrega = tt-prog-item.cod-entrega
                   tt-prog-ent.nr-entrega  = ttDeliveryScheduling.DeliverySequence
                   tt-prog-ent.dt-entrega  = ttDeliveryScheduling.DeliveryDate-aux
                   tt-prog-ent.tp-entrega  = ttItemScheduling.DeliveryType
                   tt-prog-ent.hr-entrega  = ttDeliveryScheduling.DeliveryTime
                   tt-prog-ent.cd-situacao = 2 /* ATIVO */
                   tt-prog-ent.qt-pedida   = d-qt-pedida.

            IF  ttItemScheduling.ItemCode <> "" 
            THEN ASSIGN tt-prog-ent.it-codigo = ttItemScheduling.ItemCode.
            ELSE 
                IF  ttItemScheduling.EANCode <> "" AND ttItemScheduling.EANCode <> ? THEN DO:
                    &if '{&bf_dis_versao_ems}' >= '2.05' &then
                        FIND FIRST item-mat NO-LOCK
                            WHERE  item-mat.cod-ean = ttItemScheduling.EANCode NO-ERROR.
                        IF  AVAIL  item-mat THEN ASSIGN tt-prog-ent.it-codigo = item-mat.it-codigo.
                    &endif
                END. /* IF  ttItemScheduling.EANCode <> "" THEN DO: */
                ELSE 
                    IF  ttItemScheduling.CustomerItemCode <> "" THEN DO:
                        FIND FIRST item-cli NO-LOCK
                            WHERE  item-cli.nome-abrev  = tt-prog-cli.nome-abrev
                            AND    item-cli.item-do-cli = ttItemScheduling.CustomerItemCode NO-ERROR.
                        IF  AVAIL  item-cli THEN ASSIGN tt-prog-ent.it-codigo = item-cli.it-codigo.
                    END. /* IF  ttItemScheduling.CustomerItemCode <> "" THEN DO: */
            
            FOR EACH ttDeliverySchedulingTag OF ttDeliveryScheduling:
                for first emitente no-lock
                    where emitente.nome-abrev = tt-prog-cli.nome-abrev:
                
                &IF '{&BF_DIS_VERSAO_EMS}' < '2.09' &THEN
                    IF  substring(emitente.char-1, 101, 1) = 's' THEN DO:
                &ELSE
                    IF  emitente.log-gera-chamado THEN DO:
                &ENDIF
                        assign i-nr-ord-cham = i-nr-ord-cham + 10.

                        create tt-prog-entreg-cham.
                        assign tt-prog-entreg-cham.nr-programa    = tt-prog-cli.nr-programa
                               tt-prog-entreg-cham.it-codigo      = tt-prog-item.it-codigo
                               tt-prog-entreg-cham.cod-refer      = tt-prog-item.cod-refer
                               tt-prog-entreg-cham.cod-entrega    = tt-prog-item.cod-entrega
                               tt-prog-entreg-cham.nr-pedcli      = tt-prog-item.nr-pedcli
                               tt-prog-entreg-cham.nr-entrega     = tt-prog-ent.nr-entrega
                               tt-prog-entreg-cham.rowid-prog-ent = r-rowid-prog-ent
                               tt-prog-entreg-cham.cod-cham       = ttDeliverySchedulingTag.TagCode
                               tt-prog-entreg-cham.num-ord-cham   = i-nr-ord-cham
                               tt-prog-entreg-cham.qtd-cham       = ttDeliverySchedulingTag.TagQuantity.
                    END. /* Gera Chamado Montadora */
                END. /* for first emitente no-lock */
            END. /* FOR EACH ttDeliverySchedulingTag OF ttDeliveryScheduling: */
        END. /* FOR EACH ttDeliveryScheduling OF ttItemScheduling: */
    END. /* FOR EACH ttItemScheduling OF ttCustomerScheduling: */
END. /* FOR EACH ttCustomerScheduling: */

RUN PI-DELJIT("RECRIAR-PROGRAMA"). /* Entregas Firmes */

&IF "{&bf_dis_versao_ems}" >= "2.02" &THEN
    /* Considera entregas existentes entre today e a primeira data que veio no arquivo. */
    /* Se a funcao estiver ativa ser∆o eliminadas todas as entregas existentes e 
       n∆o ser∆o recriadas as entregas existentes entre hoje e a primeira data que veio no arquivo (DELFOR)
       FO 146360.300 - SIVEF */

    IF  NOT CAN-FIND(FIRST funcao 
                     WHERE funcao.cd-funcao = "spp-elimina-delfor":U 
                     AND funcao.ativo) THEN DO:
        RUN pi-programa.
    END.
&ENDIF

create tt_versao_efetiv_edi.
assign tt_versao_efetiv_edi.tta_cdn_versao_integracao = 001.

/***********************************************************************************/
IF  SEARCH("pdp/pdapi156.r":U) <> ? 
OR  SEARCH("pdp/pdapi156.p":U) <> ? THEN DO:
    FOR EACH tt_erros_modulo: DELETE tt_erros_modulo. END.

    run pdp/pdapi156.p (input  table tt-prog-cli,
                        input  table tt-prog-item,
                        input  table tt-prog-ent,  
                        &if "{&bf_dis_versao_ems}" >= "2.02" &then
                            input table tt-prog-entreg-cham,
                        &endif
                        input  table tt_versao_efetiv_edi,
                        output table tt_erros_modulo).

    IF  CAN-FIND(FIRST tt_erros_modulo) THEN
    FOR EACH tt_erros_modulo:
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorNumber      = tt_erros_modulo.cod-erro
               RowErrors.ErrorDescription = tt_erros_modulo.des-erro
               RowErrors.ErrorSubtype     = 'Error':U
               RowErrors.ErrorType        = 'EMS':U.
    END. /* FOR EACH tt_erros_modulo: */
END.

/***********************************************************************************/
