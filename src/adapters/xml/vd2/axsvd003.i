
/**********************************************************************/
/******
        AXSVD003.I - INCLUDE GERAÄ«O DAS TAGS DO PEDIDO DE VENDA    
                                                                 ******/
/**********************************************************************/

PROCEDURE pi-informacoes-pedido. /* INFORMAÄÂES PRINCIPAIS DO PEDIDO */ 

   DEF VAR iBillingInfo        AS INT NO-UNDO.
   DEF VAR iBillingAddress     AS INT NO-UNDO. 
   DEF VAR iBlanketOrder       AS INT NO-UNDO.
   DEF VAR iCarrierInfo        AS INT NO-UNDO.
   DEF VAR iCarrierContact     AS INT NO-UNDO.
   DEF VAR iCreditStatus       AS INT NO-UNDO.
   DEF VAR iCreditAppUser      AS INT NO-UNDO.
   DEF VAR iContactInfo        AS INT NO-UNDO.
   DEF VAR iCustomer           AS INT NO-UNDO.
   DEF VAR iDeliveryRoute      AS INT NO-UNDO.
   DEF VAR iDiscountAppUser    AS INT NO-UNDO.
   DEF VAR iDiscountStatus     AS INT NO-UNDO.
   DEF VAR iDistChannel        AS INT NO-UNDO.
   DEF VAR iLicensePlate       AS INT NO-UNDO.
   DEF VAR iListReps           AS INT NO-UNDO.
   DEF VAR iMessage            AS INT NO-UNDO.
   DEF VAR iOrderAppUser       AS INT NO-UNDO.
   DEF VAR iOrderLastUpd       AS INT NO-UNDO.
   DEF VAR iOrderStatus        AS INT NO-UNDO.
   DEF VAR iOrderStatusUpd     AS INT NO-UNDO.
   DEF VAR iOrderStatusUpdUser AS INT NO-UNDO.
   DEF VAR iOrderCancel        AS INT NO-UNDO.
   DEF VAR iOrderSuspension    AS INT NO-UNDO.
   DEF VAR iOrderReactivation  AS INT NO-UNDO.
   DEF VAR iPreInvoicing       AS INT NO-UNDO.
   DEF VAR iPreInvoicingReason AS INT NO-UNDO.
   DEF VAR iPriceAppStatus     AS INT NO-UNDO.
   DEF VAR iRepresentative     AS INT NO-UNDO.
   DEF VAR iReshipment         AS INT NO-UNDO.
   DEF VAR iReshipmentInfo     AS INT NO-UNDO.
   DEF VAR iShipment           AS INT NO-UNDO.
   DEF VAR iSite               AS INT NO-UNDO.


    RUN addNodeDec IN hGenXml (iFirstId, "OrderNumber":U, ped-venda.nr-pedido,OUTPUT iId).

    /* Customer */
    RUN addNode    IN hGenXml (iFirstId, "Customer":U, "", OUTPUT iCustomer).
    RUN addNodeDec IN hGenXml (iCustomer, "CustomerNumber":U, ped-venda.cod-emitente, OUTPUT iId).
    RUN addNode    IN hGenXml (iCustomer, "CustomerShortName":U, ped-venda.nome-abrev, OUTPUT iId).

    FIND FIRST emitente WHERE
               emitente.nome-abrev = ped-venda.nome-abrev NO-LOCK NO-ERROR.
      IF AVAIL emitente THEN
         RUN addNode IN hGenXml (iCustomer, "CustomerTaxID":U, emitente.cgc, OUTPUT iId).

    RUN addNode IN hGenXml (iCustomer, "CustomerOrderNumber":U, ped-venda.nr-pedcli, OUTPUT iId).
    RUN addNode IN hGenXml (iCustomer, "CustomerBonusOrderNumber":U, ped-venda.num-pedido-bonif, OUTPUT iId).
    RUN addNode IN hGenXml (iCustomer, "OriginalCustomerOrderNumber":U, ped-venda.num-pedido-origem, OUTPUT iId).
    RUN addNode IN hGenXml (iCustomer, "Contact":U, ped-venda.contato, OUTPUT iId).

    /* DeliveryLocation */
    RUN addNode IN hGenXml (iCustomer, "DeliveryLocation":U, "", OUTPUT iDeliveryLocation).
    RUN addNode IN hGenXml (iDeliveryLocation, "DeliveryLocationID":U, ped-venda.cod-entrega, OUTPUT iId).

    FIND FIRST loc-entr WHERE
               loc-entr.cod-entrega = ped-venda.cod-entrega AND
               loc-entr.nome-abrev  = ped-venda.nome-abrev  NO-LOCK NO-ERROR.
      IF AVAIL loc-entr THEN DO:
        RUN addNode IN hGenXml (iDeliveryLocation, "DeliveryLocationTaxID":U, loc-entr.cgc, OUTPUT iId).
        RUN addNode IN hGenXml (iDeliveryLocation, "DeliveryLocationStateTaxID":U, loc-entr.ins-estadual, OUTPUT iId).

        /* DeliveryLocationPhysicalAddress */
        RUN addNode IN hGenXml (iDeliveryLocation, "DeliveryLocationPhysicalAddress":U, "", OUTPUT iDeliveryAddress).
        RUN addNode IN hGenXml (iDeliveryAddress, "Address":U, loc-entr.endereco, OUTPUT iId).
        RUN addNode IN hGenXml (iDeliveryAddress, "DistrictName":U, loc-entr.bairro, OUTPUT iId).
        RUN addNode IN hGenXml (iDeliveryAddress, "CityName":U,loc-entr.cidade, OUTPUT iId).
        RUN addNode IN hGenXml (iDeliveryAddress, "StateCode":U, loc-entr.estado, OUTPUT iId).
        RUN addNode IN hGenXml (iDeliveryAddress, "CountryName":U, loc-entr.pais, OUTPUT iId).
        RUN addNode IN hGenXml (iDeliveryAddress, "POBox":U, loc-entr.caixa-postal, OUTPUT iId).
        RUN addNode IN hGenXml (iDeliveryAddress, "ZipCode":U, loc-entr.cep, OUTPUT iId).

        &if '{&BF_DIS_VERSAO_EMS}' >= '2.05':U &then
            RUN addNode IN hGenXml (iDeliveryAddress, "FullAddress":U, loc-entr.endereco_text, OUTPUT iId).
        &endif
      END.

    /* BillingInformation */
    RUN addNode IN hGenXml (iCustomer, "BillingInformation":U, "", OUTPUT iBillingInfo).

    FIND FIRST emitente WHERE
               emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.
      IF AVAIL emitente THEN DO:
        RUN addNode IN hGenXml (iBillingInfo, "CustomerCollectionID":U, emitente.end-cobranca, OUTPUT iId).
        RUN addNode IN hGenXml (iBillingInfo, "BillingLocationTaxID":U, emitente.cgc-cob, OUTPUT iId).
        RUN addNode IN hGenXml (iBillingInfo, "BillingLocationStateTaxID":U, emitente.ins-est-cob, OUTPUT iId).

        /* BillingLocationPhysicalAddress */
        RUN addNode IN hGenXml (iBillingInfo, "BillingLocationPhysicalAddress":U, "", OUTPUT iBillingAddress).
        RUN addNode IN hGenXml (iBillingAddress, "Address":U, emitente.endereco-cob, OUTPUT iId).
        RUN addNode IN hGenXml (iBillingAddress, "DistrictName":U, emitente.bairro-cob, OUTPUT iId).
        RUN addNode IN hGenXml (iBillingAddress, "CityName":U, emitente.cidade-cob, OUTPUT iId).
        RUN addNode IN hGenXml (iBillingAddress, "StateCode":U, emitente.estado-cob, OUTPUT iId).
        RUN addNode IN hGenXml (iBillingAddress, "CountryName":U, emitente.pais-cob, OUTPUT iId).
        RUN addNode IN hGenXml (iBillingAddress, "ZipCode":U, emitente.cep-cob, OUTPUT iId).

        /* ContactInformation */
        RUN addNode IN hGenXml (iBillingInfo, "ContactInformation":U, "", OUTPUT iContactInfo).
        RUN addNode IN hGenXml (iContactInfo, "ContactName":U, emitente.contato[1], OUTPUT iId).
        RUN addNode IN hGenXml (iContactInfo, "PhoneNumber":U, emitente.telefone[1], OUTPUT iId).
        RUN addNode IN hGenXml (iContactInfo, "EmailAddress":U, emitente.e-mail, OUTPUT iId).
      END.

    RUN addNodeDec IN hGenXml (iFirstId, "ExternalOrderNumber":U,
                                 &if '{&BF_DIS_VERSAO_EMS}' BEGINS "2.04":U
                                     &then dec(SUBSTR(ped-venda.char-2,1,9))
                                 &else
                                     &if '{&BF_DIS_VERSAO_EMS}' >= "2.05":U
                                         &then ped-venda.nr-pedido-crm
                                     &else ""
                                     &endif
                                 &endif,
                                 OUTPUT iId).

    /* Addition */
    RUN addNode     IN hGenXml (iFirstID, "Addition":U, "", OUTPUT iAddition).
    RUN addNodeDate IN hGenXml (iAddition, "AdditionDate":U, ped-venda.dt-implant, OUTPUT iId).

    /* AdditionUser */
    RUN addNode IN hGenXml (iAddition, "AdditionUser":U, "", OUTPUT iAdditionUser).
    RUN addNode IN hGenXml (iAdditionUser, "UserID":U, ped-venda.user-impl, OUTPUT iId).

    FIND FIRST usuar_mestre WHERE
               usuar_mestre.cod_usuario= ped-venda.user-impl NO-LOCK NO-ERROR.
      IF AVAIL usuar_mestre then
         RUN addNode IN hGenXml (iAdditionUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).

    RUN addNode     IN hGenXml (iFirstId, "OrderType":U, ped-venda.esp-ped, OUTPUT iId).
    RUN addNode     IN hGenXml (iFirstId, "UserOrderType":U, ped-venda.tp-pedido, OUTPUT iId).
    RUN addNodeDate IN hGenXml (iFirstId, "RegisterDate":U, ped-venda.dt-emissao, OUTPUT iId).
    RUN addNodeDate IN hGenXml (iFirstId, "DeliveryDate":U, ped-venda.dt-entrega, OUTPUT iId).

    RUN addNodeDate IN hGenXml (iFirstId, "RequestedDeliveryDate":U, ped-venda.dt-entorig, OUTPUT iId).
    RUN addNodeDate IN hGenXml (iFirstId, "FirstRequestedDeliveryDate":U, ped-venda.dt-entrega-prim, OUTPUT iId).

    IF ped-venda.dt-minfat <> ? THEN
       RUN addNodeDate IN hGenXml (iFirstId, "MinimumAttendanceDate":U, ped-venda.dt-minfat, OUTPUT iId).

    IF ped-venda.dt-lim-fat <> ? THEN RUN addNodeDate IN hGenXml (iFirstId, "AttendanceDeadline":U, ped-venda.dt-lim-fat, OUTPUT iId).

    IF ped-venda.dt-inivig <> ? AND
       ped-venda.dt-fimvig <> ? THEN DO:

        /* BlanketOrder */
        RUN addNode     IN hGenXml (iFirstId, "BlanketOrder":U, "", OUTPUT iBlanketOrder).
        RUN addNodeDate IN hGenXml (iBlanketOrder, "ValidityStartDate":U, ped-venda.dt-inivig, OUTPUT iId).
        RUN addNodeDate IN hGenXml (iBlanketOrder, "ValidityEndDate":U, ped-venda.dt-fimvig, OUTPUT iId).
    END.
    IF ped-venda.observacoes <> "" THEN
       RUN addNode IN hGenXml (iFirstId, "Comment":U, ped-venda.observacoes, OUTPUT iId).

    FIND FIRST natur-oper WHERE
               natur-oper.nat-operacao = ped-venda.nat-operacao NO-LOCK NO-ERROR.
      IF AVAIL natur-oper THEN DO:

        /* FiscalOperation */
        RUN addNode IN hGenXml (iFirstId, "FiscalOperation":U, "", OUTPUT iFiscalOperation).
        RUN addNode IN hGenXml (iFiscalOperation, "FiscalOperationCode":U, ped-venda.nat-operacao, OUTPUT iId).
        RUN addNode IN hGenXml (iFiscalOperation, "FiscalOperationDescription":U, natur-oper.denominacao, OUTPUT iId).
    END.

    FIND FIRST canal-venda WHERE
               canal-venda.cod-canal-venda = ped-venda.cod-canal-venda NO-LOCK NO-ERROR.
      IF AVAIL canal-venda THEN DO:

        /* DistributionChannel */
        RUN addNode    IN hGenXml (iFirstId, "DistributionChannel":U, "", OUTPUT iDistChannel).
        RUN addNodeDec IN hGenXml (iDistChannel, "DistributionChannelCode":U, ped-venda.cod-canal-venda, OUTPUT iId).
        RUN addNode    IN hGenXml (iDistChannel, "DistributionChannelDescription":U, canal-venda.descricao, OUTPUT iId).
      END.

    IF ped-venda.nome-abrev-tri <> "" THEN
       RUN addNode IN hGenXml (iFirstId, "ThirdPartyOperationDispatchCustomerID":U, ped-venda.nome-abrev-tri, OUTPUT iId).

    IF ped-venda.cod-des-merc <> 0 THEN
        RUN addNodeDec IN hGenXml (iFirstId, "GoodsTarget":U, ped-venda.cod-des-merc, OUTPUT iId).

    IF  ped-venda.nome-transp <> "" OR
        ped-venda.cod-rota    <> "" OR
        ped-venda.uf-placa    <> "" OR
        ped-venda.placa       <> "" OR
        ped-venda.cidade-cif  <> "" THEN DO:

        /* Shipment */
        RUN addNode IN hGenXml (iFirstId, "Shipment":U, "", OUTPUT iShipment).

        IF ped-venda.nome-transp <> "" THEN DO:
           FIND FIRST transporte WHERE
                      transporte.nome-abrev = ped-venda.nome-transp NO-LOCK NO-ERROR.
             IF AVAIL transporte THEN DO:

                /* CarrierInformation */
                RUN addNode    IN hGenXml (iShipment, "CarrierInformation":U, "",OUTPUT iCarrierInfo).
                RUN addNodeDec IN hGenXml (iCarrierInfo, "CarrierID":U, transporte.cod-transp, OUTPUT iId).
                RUN addNode    IN hGenXml (iCarrierInfo, "CarrierName":U, ped-venda.nome-transp, OUTPUT iId).

                IF transporte.via-transp <> 0 THEN
                    RUN addNodeDec IN hGenXml (iCarrierInfo, "CarrierShippingMethod":U, transporte.via-transp, OUTPUT iId).

                /* CarrierContactInformation */
                RUN addNode IN hGenXml (iCarrierInfo, "CarrierContactInformation":U, "", OUTPUT iCarrierContact).
                RUN addNode IN hGenXml (iCarrierContact, "ContactName":U, transporte.contato, OUTPUT iId).
                RUN addNode IN hGenXml (iCarrierContact, "PhoneNumber":U, transporte.telefone, OUTPUT iId).

                IF transporte.e-mail <> "" THEN
                   RUN addNode IN hGenXml (iCarrierContact, "EmailAddress":U, transporte.e-mail, OUTPUT iId).
             END.
        END.

        IF ped-venda.cod-rota <> "" THEN DO:
            FIND FIRST rota WHERE
                       rota.cod-rota = ped-venda.cod-rota NO-LOCK NO-ERROR.
              IF AVAIL rota THEN DO:

                 /* DeliveryRoute */
                 RUN addNode IN hGenXml (iShipment, "DeliveryRoute":U, "", OUTPUT iDeliveryRoute).
                 RUN addNode IN hGenXml (iDeliveryRoute, "RouteID":U, ped-venda.cod-rota,OUTPUT iId).

                 IF rota.descricao <> "" THEN
                     RUN addNode IN hGenXml (iDeliveryRoute, "RouteDescription":U, rota.descricao, OUTPUT iId).

                 IF rota.roteiro <> "" THEN
                     RUN addNode IN hGenXml (iDeliveryRoute, "RoutingSpecification":U, rota.roteiro, OUTPUT iId).
              END.
        END.

        IF ped-venda.uf-placa <> "" AND
           ped-venda.placa    <> "" THEN DO:

            /* LicensePlateOfTransportVehicle */
            RUN addNode IN hGenXml (iShipment, "LicensePlateOfTransportVehicle":U, "", OUTPUT iLicensePlate).
            RUN addNode IN hGenXml (iLicensePlate, "LicensePlateStateID":U, ped-venda.uf-placa, OUTPUT iId).
            RUN addNode IN hGenXml (iLicensePlate, "LicensePlateID":U, ped-venda.placa, OUTPUT iId).
        END.

        IF ped-venda.ind-tp-frete <> 0 THEN
           RUN addNodeDec IN hGenXml (iShipment, "FreightType":U, ped-venda.ind-tp-frete, OUTPUT iId).

        IF ped-venda.cidade-cif <> "" THEN
            RUN addNode IN hGenXml (iShipment, "PaidFreightCity":U, ped-venda.cidade-cif, OUTPUT iId).

    END. /* shipment*/

    IF  ped-venda.nome-tr-red  <> "" OR
        ped-venda.cond-redespa <> "" THEN DO:

        /* Reshipment */
        RUN addNode IN hGenXml (iFirstId, "Reshipment":U, "", OUTPUT iReshipment).

        IF ped-venda.nome-tr-red <> "" THEN DO:
         FIND FIRST transporte WHERE
                    transporte.nome-abrev = ped-venda.nome-tr-red NO-LOCK NO-ERROR.
           IF AVAIL transporte THEN DO:

            /* ReshipmentCarrierInformation */
            RUN addNode    IN hGenXml (iReshipment, "ReshipmentCarrierInformation":U, "", OUTPUT iReshipmentInfo).
            RUN addNodeDec IN hGenXml (iReshipmentInfo, "CarrierID":U, transporte.cod-transp, OUTPUT iId).
            RUN addNode    IN hGenXml (iReshipmentInfo, "CarrierName":U, ped-venda.nome-tr-red, OUTPUT iId).
            RUN addNode    IN hGenXml (iReshipmentInfo, "CarrierShippingMethod":U, transporte.via-transp, OUTPUT iId).

            /* CarrierContactInformation */
            RUN addNode IN hGenXml (iReshipmentInfo, "CarrierContactInformation":U, "", OUTPUT iCarrierContact).
            RUN addNode IN hGenXml (iCarrierContact, "ContactName":U, transporte.contato, OUTPUT iId).
            RUN addNode IN hGenXml (iCarrierContact, "PhoneNumber":U, transporte.telefone, OUTPUT iId).
            RUN addNode IN hGenXml (iCarrierContact, "EmailAddress":U, transporte.e-mail, OUTPUT iId).
           END.
        END.

        IF ped-venda.cond-redespa <> "" THEN
           RUN addNode IN hGenXml (iReshipment, "ReshipmentTerms":U, ped-venda.cond-redespa, OUTPUT iId).
    END. /* reshipment */

    IF ped-venda.cod-mensagem <> 0 THEN DO:
     FIND FIRST mensagem WHERE
                mensagem.cod-mensagem = ped-venda.cod-mensagem NO-LOCK NO-ERROR.
       IF AVAIL mensagem THEN DO:

        /* Message */
        RUN addNode    IN hGenXml (iFirstID, "Message":U, "", OUTPUT iMessage).
        RUN addNodeDec IN hGenXml (iMessage, "MessageID":U, ped-venda.cod-mensagem, OUTPUT iId).

        IF mensagem.texto-mensag <> "" THEN
           RUN addNode IN hGenXml (iMessage, "MessageDescription":U, mensagem.texto-mensag, OUTPUT iId).
       END.
    END.

    /* Site */
    RUN addNode IN hGenXml (iFirstID, "Site":U, "", OUTPUT iSite).
    RUN addNode IN hGenXml (iSite, "MainSiteID":U, ped-venda.cod-estabel, OUTPUT iId).
    RUN addNode IN hGenXml (iSite, "ControlSiteID":U, ped-venda.estab-central, OUTPUT iId).
    RUN addNode IN hGenXml (iSite, "AttendanceSiteID":U, ped-venda.estab-atend, OUTPUT iId).

    IF ped-venda.cod-priori <> 0 THEN
       RUN addNodeDec IN hGenXml (iFirstID, "Priority":U, ped-venda.cod-priori, OUTPUT iId).

    /* PreInvoicing */
    RUN addNode    IN hGenXml (iFirstID, "PreInvoicing":U, "", OUTPUT iPreInvoicing).
    RUN addNodeLog IN hGenXml (iPreInvoicing, "IsOrderAvailableForPreInvoicing":U, ped-venda.dsp-pre-fat, OUTPUT iId).

    IF ped-venda.dsp-pre-fat = NO THEN
        /* NonAvailabilityForPreInvoicingReason */
        RUN addNode IN hGenXml (iPreInvoicing, "NonAvailabilityForPreInvoicingReason":U,  "", OUTPUT iPreInvoicingReason).

        IF ped-venda.cod-message-aler <> 0 THEN DO:
         RUN addNodeDec IN hGenXml (iPreInvoicingReason, "ReasonCode":U, ped-venda.cod-message-aler, OUTPUT iId).

         IF ped-venda.cod-message-alerta = 1 then do:
           {utp/ut-liter.i Situaá∆o_de_Atendimento_do_pedido_n∆o_permite_alocaá∆o *}
           assign c-msg-dsp-pre = Return-value.
         END.
          ELSE  IF ped-venda.cod-message-alerta = 2 then do:
           {utp/ut-liter.i Situaá∆o_de_prÇ-faturamento_n∆o_permite_alocaá∆o *}
           assign c-msg-dsp-pre = Return-value.
          END.
           ELSE IF ped-venda.cod-message-alerta = 3 then do:
            {utp/ut-liter.i Situaá∆o_de_crÇdito_do_pedido_n∆o_permite_alocaá∆o *}
            assign c-msg-dsp-pre = Return-value.
           END.
            ELSE IF ped-venda.cod-message-alerta = 4 then do:
             run utp/ut-msgs.p (input "help",
                                input 17246,
                                input "").
             assign c-msg-dsp-pre = trim(Return-value).
            END.
             ELSE IF ped-venda.cod-message-alerta = 5 then do:
              {utp/ut-liter.i Indicador_de_CrÇdito_do_Emitente_n∆o_permite_alocaá∆o *}
              assign c-msg-dsp-pre = Return-value.
             END.
              ELSE IF ped-venda.cod-message-alerta = 6 then do:
               {utp/ut-liter.i Pedido_j†_foi_atendimento *}
               assign c-msg-dsp-pre = Return-value.
              END.
               ELSE IF ped-venda.cod-message-alerta = 7 then do:
                {utp/ut-liter.i Pedido_possui_apenas_itens_com_qtde_pedida_igual_a_zero *}
                assign c-msg-dsp-pre = Return-value.
               END.
                ELSE IF  ped-venda.cod-message-alerta = ? then do:
                  if ped-venda.completo = no then do:
                   {utp/ut-liter.i Pedido_n∆o_est†_completo MPD}
                   assign c-msg-dsp-pre = Return-value.
                  end.
                  if ped-venda.cod-sit-aval = 4 then
                   assign c-msg-dsp-pre = ped-venda.desc-bloq-cr.
                END.
                  ELSE IF ped-venda.cod-message-alerta = 8 then do:
                   run utp/ut-msgs.p (input "help",
                                      input 18815,
                                      input "").
                   assign c-msg-dsp-pre = trim(Return-value).
                  END.
                   ELSE IF ped-venda.cod-message-alerta = 9 then do:
                    run utp/ut-msgs.p (input "msg",
                                       input 19005,
                                       input "").
                    assign c-msg-dsp-pre = trim(Return-value).
                   END.
                    ELSE IF ped-venda.cod-message-alerta = 10 then do:
                     run utp/ut-msgs.p (input "msg",
                                        input 17644,
                                        input "").
                     assign c-msg-dsp-pre = trim(Return-value).
                    END.

         RUN addNode IN hGenXml (iPreInvoicingReason, "ReasonDescription":U, c-msg-dsp-pre, OUTPUT iId).
        END.

    RUN addNodeLog IN hGenXml (iFirstId, "IsInvoicingDocumentReleasedWithoutBalanceInSupply":U, ped-venda.ind-lib-nota, OUTPUT iId).
    RUN addNodeLog IN hGenXml (iFirstId, "IsPartialInvoicingAccepted":U, ped-venda.ind-fat-par, OUTPUT iId).

    IF ped-venda.per-max-canc <> 0 THEN
        RUN addNodeDec IN hGenXml (iFirstId, "MaximumPercentageForCancellationOfOpenedAmounts":U, ped-venda.per-max-canc, OUTPUT iId).

    IF ped-venda.nr-ped-cot-orig <> "" THEN
        RUN addNode IN hGenXml (iFirstId, "QuotationNumber":U, ped-venda.nr-ped-cot-orig, OUTPUT iId).

    IF ped-venda.cond-espec <> "" THEN
        RUN addNode IN hGenXml (iFirstId, "SpecialTerms":U, ped-venda.cond-espec, OUTPUT iId).

    IF ped-venda.user-aprov <> "" THEN DO:
     FIND FIRST usuar_mestre WHERE
                usuar_mestre.cod_usuario = ped-venda.user-aprov NO-LOCK NO-ERROR.
       IF AVAIL usuar_mestre THEN DO:

         /* OrderApprovalUser */
         RUN addNode IN hGenXml (iFirstId, "OrderApprovalUser":U, "", OUTPUT iOrderAppUser).
         RUN addNode IN hGenXml (iOrderAppUser, "UserID":U, ped-venda.user-aprov, OUTPUT iId).
         RUN addNode IN hGenXml (iOrderAppUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).
       END.
    END.

    IF ped-venda.cod-sit-ped     <> 0  OR
       ped-venda.cod-usu-alt-sit <> "" THEN DO:

        /* OrderStatus */
        RUN addNode    IN hGenXml (iFirstId, "OrderStatus":U, "", OUTPUT iOrderStatus).
        RUN addNodeDec IN hGenXml (iOrderStatus, "CurrentOrderStatus":U, ped-venda.cod-sit-ped, OUTPUT iId).

        IF ped-venda.dat-alter-sit   <> ?  OR
           ped-venda.cod-usu-alt-sit <> "" THEN DO:

            /* OrderStatusLastUpdate */
            RUN addNode     IN hGenXml (iOrderStatus, "OrderStatusLastUpdate":U, "", OUTPUT iOrderStatusUpd).
            RUN addNodeDate IN hGenXml (iOrderStatusUpd, "OrderStatusLastUpdateDate":U, ped-venda.dat-alter-sit, OUTPUT iId).

            /* OrderStatusLastUpdateUser */
            RUN addNode IN hGenXml (iOrderStatusUpd, "OrderStatusLastUpdateUser":U, "", OUTPUT iOrderStatusUpdUser).
            RUN addNode IN hGenXml (iOrderStatusUpdUser, "UserID":U, ped-venda.cod-usu-alt-sit, OUTPUT iId).

           FIND FIRST usuar_mestre WHERE
                      usuar_mestre.cod_usuario = ped-venda.user-alte NO-LOCK NO-ERROR.
             IF AVAIL usuar_mestre THEN
                RUN addNode IN hGenXml (iOrderStatusUpdUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).
        END.

        IF ped-venda.cod-sit-ped = 6    AND
           ped-venda.desc-cancela <> "" AND
           ped-venda.dt-cancela   <> ?  AND string(ped-venda.dt-cancela) <> "" AND
           ped-venda.user-canc    <> "" THEN DO:

            /* OrderCancellation */
            RUN addNode     IN hGenXml (iOrderStatus, "OrderCancellation":U, "", OUTPUT iOrderCancel).
            RUN addNodeDec  IN hGenXml (iOrderCancel, "CancellationReasonCode":U, ped-venda.cod-mot-canc-cot,OUTPUT iId).
            RUN addNode     IN hGenXml (iOrderCancel, "CancellationReasonDescription":U, ped-venda.desc-cancela, OUTPUT iId).
            RUN addNodeDate IN hGenXml (iOrderCancel, "CancellationDate":U, ped-venda.dt-cancela, OUTPUT iId).

            /* CancellationUser */
            RUN addNode IN hGenXml (iOrderCancel, "CancellationUser":U, "", OUTPUT iCancellationUser).
            RUN addNode IN hGenXml (iCancellationUser, "UserID":U, ped-venda.user-canc, OUTPUT iId).

            FIND FIRST usuar_mestre WHERE
                       usuar_mestre.cod_usuario = ped-venda.user-canc NO-LOCK NO-ERROR.
              IF AVAIL usuar_mestre THEN
                RUN addNode IN hGenXml (iCancellationUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).
        END.

        IF ped-venda.cod-sit-ped  = 5    AND
           ped-venda.desc-suspend  <> "" AND
           ped-venda.dt-suspensao  <> ?  AND string(ped-venda.dt-suspensao) <> "" AND
           ped-venda.user-suspen   <> "" THEN DO:

           /* OrderSuspension */
           RUN addNode     IN hGenXml (iOrderStatus, "OrderSuspension":U, "", OUTPUT iOrderSuspension).
           RUN addNode     IN hGenXml (iOrderSuspension, "SuspensionReasonDescription":U, ped-venda.desc-suspend, OUTPUT iId).
           RUN addNodeDate IN hGenXml (iOrderSuspension, "SuspensionDate":U, ped-venda.dt-suspensao, OUTPUT iId).

           /* SuspensionUser */
           RUN addNode IN hGenXml (iOrderSuspension, "SuspensionUser":U, "", OUTPUT iSuspensionUser).
           RUN addNode IN hGenXml (iSuspensionUser, "UserID":U, ped-venda.user-suspen, OUTPUT iId).

           FIND FIRST usuar_mestre WHERE
                      usuar_mestre.cod_usuario = ped-venda.user-suspen NO-LOCK NO-ERROR.
             IF AVAIL usuar_mestre THEN
               RUN addNode IN hGenXml (iSuspensionUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).
        END.

        IF ped-venda.cod-sit-ped  = 1   AND
           ped-venda.desc-reativa <> "" AND
           ped-venda.dt-userrea   <> ?  AND string(ped-venda.dt-userrea) <> "" AND
           ped-venda.user-reat    <> "" THEN DO:

           /* OrderReactivation */
           RUN addNode     IN hGenXml (iOrderStatus,  "OrderReactivation":U, "", OUTPUT iOrderReactivation).
           RUN addNode     IN hGenXml (iOrderReactivation, "ReactivationReasonDescription":U, ped-venda.desc-reativa, OUTPUT iId).
           RUN addNodeDate IN hGenXml (iOrderReactivation, "ReactivationDate":U, ped-venda.dt-userrea, OUTPUT iId).

           /* ReactivationUser */
           RUN addNode IN hGenXml (iOrderReactivation, "ReactivationUser":U, "", OUTPUT iReactivationUser).
           RUN addNode IN hGenXml (iReactivationUser, "UserID":U, ped-venda.user-reat, OUTPUT iId).

           FIND FIRST usuar_mestre WHERE
                      usuar_mestre.cod_usuario = ped-venda.user-reat NO-LOCK NO-ERROR.
             IF AVAIL usuar_mestre THEN
                RUN addNode IN hGenXml (iReactivationUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).
        END.
    END. /* order status */

    IF ped-venda.cod-sit-aval <> 0 THEN DO:

        /* CreditApprovalStatus */
        RUN addNode    IN hGenXml (iFirstId, "CreditApprovalStatus":U, "", OUTPUT iCreditStatus).
        RUN addNodeDec IN hGenXml (iCreditStatus, "CreditApprovalCurrentStatus":U, ped-venda.cod-sit-aval, OUTPUT iId).

       IF ped-venda.dt-apr-cred <> ? AND string(ped-venda.dt-apr-cred) <> "" THEN
        RUN addNodeDate IN hGenXml (iCreditStatus, "CreditApprovalDate":U, ped-venda.dt-apr-cred, OUTPUT iId).

        IF ped-venda.desc-forc-cr <> "" THEN                   /* Motivo Aprovaá∆o */
            RUN addNode IN hGenXml (iCreditStatus, "CreditApprovalReason":U, ped-venda.desc-forc-cr,  OUTPUT iId).

         ELSE IF ped-venda.desc-bloq-cr <> "" THEN             /* Motivo Reprovaá∆o */
             RUN addNode IN hGenXml (iCreditStatus, "CreditApprovalReason":U, ped-venda.desc-bloq-cr, OUTPUT iId).

        IF ped-venda.quem-aprovou <> "" THEN DO:

         /* CreditApprovalUser */
         RUN addNode IN hGenXml (iCreditStatus, "CreditApprovalUser":U, "", OUTPUT iCreditAppUser).
         RUN addNode IN hGenXml (iCreditAppUser, "UserID":U, ped-venda.quem-aprovou, OUTPUT iId).

         FIND FIRST usuar_mestre WHERE
                    usuar_mestre.cod_usuario = ped-venda.quem-aprovou NO-LOCK NO-ERROR.
           IF AVAIL usuar_mestre THEN
            RUN addNode IN hGenXml (iCreditAppUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).
        END.
    END.

    IF ped-venda.ind-sit-desconto <> 0 THEN DO:

        /* DiscountApprovalStatus */
        RUN addNode    IN hGenXml (iFirstId, "DiscountApprovalStatus":U, "", OUTPUT iDiscountStatus).
        RUN addNodeDec IN hGenXml (iDiscountStatus, "DiscountApprovalCurrentStatus":U, ped-venda.ind-sit-desconto, OUTPUT iId).

        IF ped-venda.dat-sit-desconto <> ? AND string(ped-venda.dat-sit-desconto) <> "" THEN
           RUN addNodeDate IN hGenXml (iDiscountStatus, "DiscountApprovalDate":U, ped-venda.dat-sit-desconto, OUTPUT iId).

        IF ped-venda.desc-lib-desconto <> "" THEN
           RUN addNode IN hGenXml (iDiscountStatus,"DiscountApprovalReason":U, ped-venda.desc-lib-desconto, OUTPUT iId).

        IF ped-venda.cod-usu-lib-desconto <> "" THEN DO:

         /* DiscountApprovalUser */
         RUN addNode IN hGenXml (iDiscountStatus, "DiscountApprovalUser":U, "", OUTPUT iDiscountAppUser).
         RUN addNode IN hGenXml (iDiscountAppUser, "UserID":U, ped-venda.cod-usu-lib-desconto, OUTPUT iId).
         FIND FIRST usuar_mestre WHERE
                    usuar_mestre.cod_usuario = ped-venda.cod-usu-lib-desconto NO-LOCK NO-ERROR.
           IF AVAIL usuar_mestre THEN
            RUN addNode IN hGenXml (iDiscountAppUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).
        END.
    END.

    IF ped-venda.cod-sit-preco <> 0 THEN DO:

        /* PriceAppStatus */
        RUN addNode    IN hGenXml (iFirstId, "PriceApprovalStatus":U, "", OUTPUT iPriceAppStatus).
        RUN addNodeDec IN hGenXml (iPriceAppStatus, "PriceApprovalCurrentStatus":U, ped-venda.cod-sit-preco, OUTPUT iId).

        IF ped-venda.dat-aprov-preco <> ? AND string(ped-venda.dat-aprov-preco) <> "" THEN
           RUN addNodeDate IN hGenXml (iPriceAppStatus, "PriceApprovalDate":U, ped-venda.dat-aprov-preco, OUTPUT iId).

        IF ped-venda.desc-lib-preco <> "" THEN
           RUN addNode IN hGenXml (iPriceAppStatus, "PriceApprovalReason":U, ped-venda.desc-lib-preco, OUTPUT iId).

        IF ped-venda.user-preco <> "" THEN DO:
          FIND FIRST usuar_mestre WHERE
                     usuar_mestre.cod_usuario = ped-venda.user-preco NO-LOCK NO-ERROR.
            IF AVAIL usuar_mestre THEN DO:

               /* PriceAppStatusUser */
               RUN addNode IN hGenXml (iPriceAppStatus, "PriceApprovalUser":U, "", OUTPUT iPriceAppUser).
               RUN addNode IN hGenXml (iPriceAppUser, "UserID":U, ped-venda.user-preco, OUTPUT iId).

               RUN addNode IN hGenXml (iPriceAppUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).
            END.
        END.
    END.

    IF ped-venda.cod-sit-com <> 0 THEN
        RUN addNodeDec IN hGenXml (iFirstID, "CommercialApprovalStatus":U, ped-venda.cod-sit-com,OUTPUT iId).

    IF ped-venda.cod-sit-pre <> 0 THEN
        RUN addNodeDec IN hGenXml (iFirstID, "InventoryAllocationStatus":U, ped-venda.cod-sit-pre, OUTPUT iId).

    IF ped-venda.motivo-alt-sit-quota <> "" THEN
        RUN addNode IN hGenXml (iFirstID, "QuoteStatusUpdateReason":U, ped-venda.motivo-alt-sit-quota, OUTPUT iId).

    IF ped-venda.dt-useralt  <> ?  AND string(ped-venda.dt-useralt) <> "" AND
       ped-venda.user-alte   <> "" THEN DO:

        /* OrderLastUpdate */
        RUN addNode     IN hGenXml (iFirstId, "OrderLastUpdate":U, "", OUTPUT iOrderLastUpd).
        RUN addNodeDate IN hGenXml (iOrderLastUpd, "OrderLastUpdateDate":U, ped-venda.dt-useralt, OUTPUT iId).

        /* OrderLastUpdateUser */
        RUN addNode IN hGenXml (iOrderLastUpd, "OrderLastUpdateUser":U, "", OUTPUT iLastUpdUser).
        RUN addNode IN hGenXml (iLastUpdUser, "UserID":U, ped-venda.user-alte, OUTPUT iId).

        FIND FIRST usuar_mestre WHERE
                   usuar_mestre.cod_usuario = ped-venda.user-alte NO-LOCK NO-ERROR.
          IF AVAIL usuar_mestre THEN
           RUN addNode IN hGenXml (iLastUpdUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).
        END.

    FIND FIRST ped-repre WHERE
               ped-repre.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.
      IF AVAIL ped-repre THEN DO:

        /* ListOfRepresentatives */
        RUN addNode IN hGenXml (iFirstId, "ListOfRepresentatives":U, "", OUTPUT iListReps).

        FOR EACH ped-repre OF ped-venda NO-LOCK:

            /* Representative */
            RUN addNode    IN hGenXml (iListReps, "Representative":U, "", OUTPUT iRepresentative).
            RUN addNode    IN hGenXml (iRepresentative, "RepresentativeShortName":U, ped-repre.nome-ab-rep, OUTPUT iId).
            RUN addNodeLog IN hGenXml (iRepresentative, "IsMainRepresentative":U, ped-repre.ind-repbase, OUTPUT iId).
            RUN addNodeDec IN hGenXml (iRepresentative, "CommissionPercentage":U, ped-repre.perc-comis, OUTPUT iId).
            RUN addNodeDec IN hGenXml (iRepresentative, "PrintingCommissionPercentage":U, ped-repre.comis-emis, OUTPUT iId).

            IF ped-repre.ind-repbase AND
               ped-venda.nr-pedrep <> "" THEN
                RUN addNode IN hGenXml (iRepresentative, "RepresentativeOrderNumber":U, ped-venda.nr-pedrep, OUTPUT iId).

            RUN addNode IN hGenXml (iRepresentative, "ClassifierCode":U, ped-repre.cod-classificador, OUTPUT iId).
        END.
    END.

    RUN pi-informacoes-itens.

END PROCEDURE.


PROCEDURE pi-informacoes-itens. /*  INFORMAÄÂES REFERENTES AOS ITENS DO PEDIDO  */

    DEF VAR iBonification      AS INT NO-UNDO.
    DEF VAR iBusinessUnit      AS INT NO-UNDO.
    DEF VAR iDelivery          AS INT NO-UNDO.
    DEF VAR iDeliveryAddress   AS INT NO-UNDO.
    DEF VAR iDeliveryCancel    AS INT NO-UNDO.
    DEF VAR iDeliveryInfo      AS INT NO-UNDO.
    DEF VAR iDeliveryLocation  AS INT NO-UNDO.
    DEF VAR iDeliveryQtInfo    AS INT NO-UNDO.
    DEF VAR iDeliveryReativ    AS INT NO-UNDO.
    DEF VAR iDeliveryStatus    AS INT NO-UNDO.
    DEF VAR iDeliverySusp      AS INT NO-UNDO.
    DEF VAR iDeliveryUpd       AS INT NO-UNDO.
    DEF VAR iDeliveryUpdUser   AS INT NO-UNDO.
    DEF VAR iDevolution        AS INT NO-UNDO.
    DEF VAR iDevolutionUser    AS INT NO-UNDO.
    DEF VAR iDirectDebitInfo   AS INT NO-UNDO.
    DEF VAR iDiscountsBonif    AS INT NO-UNDO.
    DEF VAR iDiscountTable     AS INT NO-UNDO.
    DEF VAR iItemLastUpd       AS INT NO-UNDO.
    DEF VAR iItemPriceApproval AS INT NO-UNDO.
    DEF VAR iItemUpdUser       AS INT NO-UNDO. 
    DEF VAR iItemValueInfo     AS INT NO-UNDO. 
    DEF VAR iListItens         AS INT NO-UNDO.
    DEF VAR iListOfBusiness    AS INT NO-UNDO.
    DEF VAR iListOfDeliveries  AS INT NO-UNDO.
    DEF VAR iListOfDiscounts   AS INT NO-UNDO.
    DEF VAR iOrderItem         AS INT NO-UNDO.
    DEF VAR iOrderItemCancel   AS INT NO-UNDO.
    DEF VAR iOrderItemReativ   AS INT NO-UNDO.
    DEF VAR iOrderItemStatus   AS INT NO-UNDO.
    DEF VAR iOrderItemSusp     AS INT NO-UNDO. 
    DEF VAR iOrderItemUpd      AS INT NO-UNDO. 
    DEF VAR iProgramInfo       AS INT NO-UNDO.
    DEF VAR iPurchaseOrder     AS INT NO-UNDO.
    DEF VAR iQuantityInfo      AS INT NO-UNDO.
    DEF VAR iQuantityInOrder   AS INT NO-UNDO.

    FIND FIRST ped-item WHERE 
               ped-item.nr-pedcli  = ped-venda.nr-pedcli  AND 
               ped-item.nome-abrev = ped-venda.nome-abrev NO-LOCK NO-ERROR.
    IF AVAIL ped-item THEN DO:

    /* ListOfOrderItens */
    RUN addNode IN hGenXml (iFirstId, "ListOfOrderItens":U, "", OUTPUT iListItens).

    FOR EACH ped-item OF ped-venda NO-LOCK:

        /* OrderItem */
        RUN addNode    IN hGenXml (iListItens, "OrderItem":U, "", OUTPUT iOrderItem).
        RUN addNodeDec IN hGenXml (iOrderItem, "OrderLine":U, ped-item.nr-sequencia, OUTPUT iId).
        RUN addNode    IN hGenXml (iOrderItem, "ItemCode":U, ped-item.it-codigo, OUTPUT iId).

        IF ped-item.cod-refer <> ""  THEN
           RUN addNode IN hGenXml (iOrderItem, "ItemReferenceCode":U, ped-item.cod-refer, OUTPUT iId).

        FIND ITEM WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
         IF AVAIL ITEM THEN
            RUN addNode IN hGenXml (iOrderItem, "ItemDescription":U, item.desc-item, OUTPUT iId).

        /*---[ EAI EMS x Wise Neogrid ]--------------------------------------------------------------------------------------*/
        &IF '{&BF_DIS_VERSAO_EMS}' < '2.05' &THEN
            IF  AVAIL item THEN 
                RUN addNode IN hGenXml (iOrderItem, "EANCode":U, SUBSTRING(ITEM.char-1,133,14), OUTPUT iId).
        &ELSE
            FIND FIRST item-mat NO-LOCK
                WHERE  item-mat.it-codigo = ped-item.it-codigo NO-ERROR.
            IF  AVAIL  item-mat THEN
                RUN addNode IN hGenXml (iOrderItem, "EANCode":U, item-mat.cod-ean, OUTPUT iId).
        &ENDIF
        
        FIND FIRST item-cli NO-LOCK
            WHERE  item-cli.it-codigo  = ped-item.it-codigo
            AND    item-cli.nome-abrev = ped-item.nome-abrev NO-ERROR.
        IF  AVAIL  item-cli THEN
            RUN addNode IN hGenXml (iOrderItem, "CustomerItemCode":U, item-cli.item-do-cli, OUTPUT iId).
        /*--------------------------------------------------------------------------------------[ EAI EMS x Wise Neogrid ]---*/

        RUN addNodeDec IN hGenXml (iOrderItem, "ComponentType":U, ped-item.ind-componen, OUTPUT iId).

        IF ped-item.dt-userimp  <> ?  AND string(ped-item.dt-userimp) <> "" AND
           ped-item.user-impl   <> "" THEN DO:

            /* Addition */
            RUN addNode     IN hGenXml (iOrderItem, "Addition":U, "", OUTPUT iAddition).
            RUN addNodeDate IN hGenXml (iAddition, "AdditionDate":U, ped-item.dt-userimp, OUTPUT iId).

            /* AdditionUser */
            RUN addNode IN hGenXml (iAddition, "AdditionUser":U, "", OUTPUT iAdditionUser).
            RUN addNode IN hGenXml (iAdditionUser, "UserID":U, ped-item.user-impl, OUTPUT iId).

            FIND FIRST usuar_mestre WHERE
                       usuar_mestre.cod_usuario = ped-venda.user-imp NO-LOCK NO-ERROR.
              IF AVAIL usuar_mestre THEN                                                                
               RUN addNode IN hGenXml (iAdditionUser,
                                        "UserName":U,
                                         usuar_mestre.nom_usuario,
                                         OUTPUT iId).
        END.

        IF  ped-item.dt-min-fat <> ? THEN
            RUN addNodeDate IN hGenXml (iOrderItem, "MinimumInvoiceDate":U, ped-item.dt-min-fat, OUTPUT iId).

        IF ped-item.dt-max-fat <> ? THEN
            RUN addNodeDate IN hGenXml (iOrderItem, "InvoiceDeadline":U, ped-item.dt-max-fat, OUTPUT iId).

        IF ped-item.dt-entrega <> ? THEN
            RUN addNodeDate IN hGenXml (iOrderItem, "DeliveryDate":U, ped-item.dt-entrega, OUTPUT iId).

        IF ped-item.dt-entorig <> ? THEN
            RUN addNodeDate IN hGenXml (iOrderItem, "RequestedDeliveryDate":U, ped-item.dt-entorig, OUTPUT iId).

        FIND FIRST natur-oper WHERE
                   natur-oper.nat-operacao = ped-item.nat-operacao NO-LOCK NO-ERROR.
          IF AVAIL natur-oper THEN DO:

              /* FiscalOperation */
              RUN addNode IN hGenXml (iOrderItem, "FiscalOperation":U, "", OUTPUT iFiscalOperation).
              RUN addNode IN hGenXml (iFiscalOperation, "FiscalOperationCode":U, ped-venda.nat-operacao, OUTPUT iId).
              RUN addNode IN hGenXml (iFiscalOperation, "FiscalOperationDescription":U, natur-oper.denominacao, OUTPUT iId).
          END.

          IF ped-item.tipo-atend <> 0 THEN
              RUN addNodeDec IN hGenXml (iOrderItem, "AttendanceType":U, ped-item.tipo-atend, OUTPUT iId).

          IF ped-item.per-minfat <> 0 THEN
              RUN addNodeDec IN hGenXml (iOrderItem, "PartialInvoicingMinimumPercentage":U, ped-item.per-minfat, OUTPUT iId).

          IF ped-item.observacao <> "" THEN
              RUN addNode IN hGenXml (iOrderItem, "OrderItemComments":U, ped-item.observacao, OUTPUT iId).

          FIND ITEM WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
           IF AVAIL ITEM THEN
               RUN addNodeDec IN hGenXml (iOrderItem, "TotalOrderItemNetWeigh":U, ITEM.peso-liquido * ped-item.qt-pedida, OUTPUT iId).

          IF ped-item.dat-alter-sit   <> ?  AND string(ped-item.dat-alter-sit) <> "" AND
             ped-item.cod-usu-alt-sit <> "" THEN
             ASSIGN l-last-upd = YES.           /* OrderItemStatusLastUpdate */

          IF ped-item.cod-sit-item = 6   AND
             ped-item.dt-canseq    <> ?  AND string(ped-item.dt-canseq) <> "" AND
             ped-item.desc-cancela <> "" AND
             ped-item.user-canc    <> "" THEN
             ASSIGN l-cancel = YES.             /* OrderItemCancellation */

          IF  ped-item.cod-sit-item = 5   AND
              ped-item.dt-suspensao <> ?  AND string(ped-item.dt-suspensao) <> "" AND
              ped-item.user-susp    <> "" THEN
              ASSIGN l-susp = YES.              /* OrderItemSuspension */

          IF  ped-item.cod-sit-item = 1  AND
              ped-item.dt-reativ  <> ?   AND string(ped-item.dt-reativ) <> "" AND
              ped-item.user-reat  <> ""  THEN
              ASSIGN l-reativ = YES.            /* OrderItemReactivation */

          IF ped-item.cod-sit-item <> 0 OR
             l-last-upd                 OR
             l-cancel                   OR
             l-susp                     OR
             l-reativ                   THEN DO:

             /* OrderItemStatus */
             RUN addNode IN hGenXml (iOrderItem, "OrderItemStatus":U, "", OUTPUT iOrderItemStatus).

             IF ped-item.cod-sit-item <> 0 THEN
                RUN addNodeDec IN hGenXml (iOrderItemStatus, "CurrentOrderItemStatus":U, ped-item.cod-sit-item, OUTPUT iId).

             /* OrderItemStatusLastUpdate */
             IF l-last-upd THEN DO: 

                RUN addNode     IN hGenXml (iOrderItemStatus, "OrderItemStatusLastUpdate":U, "",OUTPUT iOrderItemUpd).
                RUN addNodeDate IN hGenXml (iOrderItemUpd, "OrderItemStatusLastUpdateDate":U, ped-item.dat-alter-sit, OUTPUT iId).

               /* OrderItemStatusLastUpdateUser */
               RUN addNode IN hGenXml (iOrderItemUpd, "OrderItemStatusLastUpdateUser":U, "", OUTPUT iItemUpdUser).
               RUN addNode IN hGenXml (iItemUpdUser, "UserID":U, ped-item.cod-usu-alt-sit, OUTPUT iId).

               FIND FIRST usuar_mestre WHERE
                          usuar_mestre.cod_usuario = ped-item.cod-usu-alt-sit NO-LOCK NO-ERROR.
                 IF AVAIL usuar_mestre THEN
                  RUN addNode IN hGenXml (iItemUpdUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).

              ASSIGN l-last-upd = NO.
             END.

             /* OrderItemCancellation */
             IF l-cancel THEN DO:

                RUN addNode     IN hGenXml (iOrderItemStatus, "OrderItemCancellation":U, "", OUTPUT iOrderItemCancel).
                RUN addNodeDec  IN hGenXml (iOrderItemCancel, "CancellationReasonCode":U, ped-item.cod-mot-canc-cot, OUTPUT iId).
                RUN addNode     IN hGenXml (iOrderItemCancel, "CancellationReasonDescription":U, ped-item.desc-cancela, OUTPUT iId).
                RUN addNodeDate IN hGenXml (iOrderItemCancel, "CancellationDate":U, ped-item.dt-canseq, OUTPUT iId).

                /* CancellationUser */
                RUN addNode IN hGenXml (iOrderItemCancel, "CancellationUser":U, "", OUTPUT iCancellationUser).
                RUN addNode IN hGenXml (iCancellationUser, "UserID":U, ped-item.user-canc, OUTPUT iId).

                FIND FIRST usuar_mestre WHERE
                            usuar_mestre.cod_usuario = ped-item.user-canc NO-LOCK NO-ERROR.
                  IF AVAIL usuar_mestre THEN
                   RUN addNode IN hGenXml (iCancellationUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).

               ASSIGN l-cancel = NO.
             END.

             /* OrderItemSuspension */
             IF l-susp THEN DO:

                RUN addNode     IN hGenXml (iOrderItemStatus, "OrderItemSuspension":U, "", OUTPUT iOrderItemSusp).
                RUN addNodeDate IN hGenXml (iOrderItemSusp, "SuspensionDate":U, ped-item.dt-suspensao, OUTPUT iId).

                 /* SuspensionUser */
                 RUN addNode IN hGenXml (iOrderItemSusp, "SuspensionUser":U, "", OUTPUT iSuspensionUser).
                 RUN addNode IN hGenXml (iSuspensionUser, "UserID":U, ped-item.user-susp, OUTPUT iId).

                 FIND FIRST usuar_mestre WHERE
                            usuar_mestre.cod_usuario = ped-item.user-susp NO-LOCK NO-ERROR.
                   IF AVAIL usuar_mestre THEN
                    RUN addNode IN hGenXml (iSuspensionUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).

                ASSIGN l-susp = NO.
             END.

             /* OrderItemReactivation */
             IF l-reativ THEN DO:

                RUN addNode     IN hGenXml (iOrderItemStatus, "OrderItemReactivation":U, "", OUTPUT iOrderItemReativ).
                RUN addNodeDate IN hGenXml (iOrderItemReativ, "ReactivationDate":U, ped-item.dt-reativ, OUTPUT iId).

                 /* ReactivationUser */
                 RUN addNode IN hGenXml (iOrderItemReativ, "ReactivationUser":U, "", OUTPUT iReactivationUser).
                 RUN addNode IN hGenXml (iReactivationUser, "UserID":U, ped-item.user-reat, OUTPUT iId).

                 FIND FIRST usuar_mestre WHERE
                            usuar_mestre.cod_usuario = ped-item.user-reat NO-LOCK NO-ERROR.
                   IF AVAIL usuar_mestre THEN
                    RUN addNode IN hGenXml (iReactivationUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).

                ASSIGN l-reativ = NO.
             END.

          END. /* OrderItemStatus */

          IF ped-item.cod-sit-preco <> 0 THEN DO:

              /* PriceAprrovalStatus */
              RUN addNode    IN hGenXml (iOrderItem, "PriceApprovalStatus":U, "", OUTPUT iItemPriceApproval).
              RUN addNodeDec IN hGenXml (iItemPriceApproval, "PriceApprovalCurrentStatus":U, ped-item.cod-sit-preco, OUTPUT iId).

              IF ped-item.dat-aprov-preco <> ? AND string(ped-item.dat-aprov-preco) <> "" THEN
               RUN addNodeDate IN hGenXml (iItemPriceApproval, "PriceApprovalDate":U, ped-item.dat-aprov-preco, OUTPUT iId).

              IF ped-item.desc-lib-preco <> "" THEN
                 RUN addNode IN hGenXml (iItemPriceApproval, "PriceApprovalReason":U, ped-item.desc-lib-preco, OUTPUT iId).

              IF ped-item.user-preco <> "" THEN DO:
               FIND FIRST  usuar_mestre where
                           usuar_mestre.cod_usuario = ped-venda.user-preco NO-LOCK NO-ERROR.
                  IF AVAIL usuar_mestre THEN DO:

                     /* PriceApprovalUser */
                     RUN addNode IN hGenXml (iItemPriceApproval, "PriceApprovalUser":U, "", OUTPUT iPriceAppUser).
                     RUN addNode IN hGenXml (iPriceAppUser, "UserID":U, ped-item.user-preco, OUTPUT iId).
                     RUN addNode IN hGenXml (iPriceAppUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).
                  END.
              END.
          END.

          IF ped-item.cod-sit-com <> 0 THEN
              RUN addNodeDec IN hGenXml (iOrderItem, "CommercialApprovalStatus":U, ped-item.cod-sit-com, OUTPUT iId).

          IF ped-item.cod-sit-pre <> 0 THEN
              RUN addNodeDec IN hGenXml (iOrderItem, "InventoryAllocationStatus":U, ped-item.cod-sit-pre, OUTPUT iId).

          IF ped-item.motivo-alt-sit-quota <> "" THEN
              RUN addNode IN hGenXml (iOrderItem, "QuoteStatusUpdateReason":U, ped-item.motivo-alt-sit-quota, OUTPUT iId).

          IF ped-item.dt-useralt <> ?  AND string(ped-item.dt-useralt) <> "" AND
             ped-item.user-alt   <> "" THEN DO:

              /* OrderItemLastUpdate */
              RUN addNode     IN hGenXml (iOrderItem, "OrderItemLastUpdate":U, "", OUTPUT iItemLastUpd).
              RUN addNodeDate IN hGenXml (iItemLastUpd, "OrderItemLastUpdateDate":U, ped-item.dt-useralt, OUTPUT iId).
              RUN addNode     IN hGenXml (iItemLastUpd, "OrderItemLastUpdateUser":U, "", OUTPUT iLastUpdUser).
              RUN addNode     IN hGenXml (iLastUpdUser, "UserID":U, ped-item.user-alte, OUTPUT iId).

              FIND FIRST usuar_mestre WHERE 
                         usuar_mestre.cod_usuario = ped-item.user-alte NO-LOCK NO-ERROR.
                IF AVAIL usuar_mestre THEN
                    RUN addNode IN hGenXml (iLastUpdUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).
          END.
          IF ped-item.cod-ord-compra <> ""  AND
             ped-item.cod-ord-compra <> "0" AND
             ped-item.parcela        <> 0   THEN DO:

             /* PurchaseOrder */
             RUN addNode    IN hGenXml (iOrderItem, "PurchaseOrder":U, "", OUTPUT iPurchaseOrder).
             RUN addNode    IN hGenXml (iPurchaseOrder, "PurchaseOrderID":U, ped-item.cod-ord-compra, OUTPUT iId).
             RUN addNodeDec IN hGenXml (iPurchaseOrder, "PurchaseOrderInstallment":U, ped-item.parcela, OUTPUT iId).
          END.

          IF ped-item.nr-programa <> 0  AND
             ped-item.nr-progcli  <> "" AND 
             ped-item.nr-versao   <> 0  THEN DO:

              /* ProgramInformation */
              RUN addNode    IN hGenXml (iOrderItem, "ProgramInformation":U, "", OUTPUT iProgramInfo).
              RUN addNodeDec IN hGenXml (iProgramInfo, "ProgramNumber":U, ped-item.nr-programa, OUTPUT iId).
              RUN addNode    IN hGenXml (iProgramInfo, "CustomerProgram":U, ped-item.nr-progcli, OUTPUT iId).
              RUN addNodeDec IN hGenXml (iProgramInfo, "ProgramVersion":U, ped-item.nr-versao, OUTPUT iId).
          END.

          /* DeliveryInformation */
          RUN addNode IN hGenXml (iOrderItem, "DeliveryInformation":U, "", OUTPUT iDeliveryInfo).

          /* DeliveryLocation */
          RUN addNode IN hGenXml (iDeliveryInfo, "DeliveryLocation":U, "", OUTPUT iDeliveryLocation).
          RUN addNode IN hGenXml (iDeliveryLocation, "DeliveryLocationID":U, ped-item.cod-entrega, OUTPUT iId).

          FIND FIRST loc-entr WHERE
                     loc-entr.cod-entrega = ped-item.cod-entrega AND
                     loc-entr.nome-abrev  = ped-item.nome-abrev  NO-LOCK NO-ERROR.
            IF AVAIL loc-entr AND
                     ped-item.cod-entrega <> ped-venda.cod-entrega THEN DO:

                RUN addNode IN hGenXml (iDeliveryLocation, "DeliveryLocationTaxID":U, loc-entr.cgc, OUTPUT iId).
                RUN addNode IN hGenXml (iDeliveryLocation, "DeliveryLocationStateTaxID":U, loc-entr.ins-estadual, OUTPUT iId).

                /* DeliveryLocationPhysicalAddress */
                RUN addNode IN hGenXml (iDeliveryLocation, "DeliveryLocationPhysicalAddress":U, "", OUTPUT iDeliveryAddress).
                RUN addNode IN hGenXml (iDeliveryAddress, "Address":U, loc-entr.endereco, OUTPUT iId).
                RUN addNode IN hGenXml (iDeliveryAddress, "DistrictName":U, loc-entr.bairro, OUTPUT iId).
                RUN addNode IN hGenXml (iDeliveryAddress, "CityName":U, loc-entr.cidade, OUTPUT iId).
                RUN addNode IN hGenXml (iDeliveryAddress, "StateCode":U, loc-entr.estado, OUTPUT iId).
                RUN addNode IN hGenXml (iDeliveryAddress, "CountryName":U, loc-entr.pais, OUTPUT iId).
                RUN addNode IN hGenXml (iDeliveryAddress, "POBox":U, loc-entr.caixa-postal, OUTPUT iId).
                RUN addNode IN hGenXml (iDeliveryAddress, "ZipCode":U, loc-entr.cep, OUTPUT iId).

                &if '{&BF_DIS_VERSAO_EMS}' >= '2.05':U &then 
                    RUN addNode IN hGenXml (iDeliveryAddress, "FullAddress":U, loc-entr.endereco_text,OUTPUT iId).
                &endif                                                                               
            END.

          FIND FIRST ped-ent WHERE
                     ped-ent.nome-abrev   = ped-item.nome-abrev   AND
                     ped-ent.nr-pedcli    = ped-item.nr-pedcli    AND
                     ped-ent.nr-sequencia = ped-item.nr-sequencia AND
                     ped-ent.it-codigo    = ped-item.it-codigo    AND
                     ped-ent.cod-refer    = ped-item.cod-refer    NO-LOCK NO-ERROR.
            IF AVAIL ped-ent THEN DO:

             /* ListOfDeliveries */
             RUN addNode IN hGenXml (iDeliveryInfo, "ListOfDeliveries":U, "", OUTPUT iListOfDeliveries).

             FOR EACH ped-ent OF ped-item NO-LOCK:             

              /* Deliveries */
              RUN addNode    IN hGenXml (iListOfDeliveries, "Delivery":U, "", OUTPUT iDelivery).
              RUN addNodeDec IN hGenXml (iDelivery, "DeliverySequence":U, ped-ent.nr-entrega, OUTPUT iId).
              RUN addNodeDec IN hGenXml (iDelivery, "DeliveryType":U, ped-ent.tp-entrega, OUTPUT iId).

              IF ped-ent.dt-userimp <> ?  AND string(ped-ent.dt-userimp) <> "" AND
                 ped-ent.user-impl  <> "" THEN DO:

                /* Addition */
                RUN addNode     IN hGenXml (iDelivery, "Addition":U, "", OUTPUT iAddition).
                RUN addNodeDate IN hGenXml (iAddition, "AdditionDate":U, ped-ent.dt-userimp, OUTPUT iId).

                /* AdditionUser */
                RUN addNode IN hGenXml (iAddition, "AdditionUser":U, "", OUTPUT iAdditionUser).
                RUN addNode IN hGenXml (iAdditionUser, "UserID":U, ped-ent.user-impl, OUTPUT iId).

                FIND FIRST usuar_mestre WHERE
                           usuar_mestre.cod_usuario= ped-ent.user-impl NO-LOCK NO-ERROR.
                    RUN addNode IN hGenXml (iAdditionUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).
              END.

              IF ped-ent.cod-sit-pre <> 0 THEN
               RUN addNodeDec IN hGenXml (iDelivery, "InventoryAllocationStatus":U, ped-ent.cod-sit-pre, OUTPUT iId).

              RUN addNodeDate IN hGenXml (iDelivery, "DeliveryDate":U, ped-ent.dt-entrega, OUTPUT iId).
              RUN addNodeDate IN hGenXml (iDelivery, "RequestedDeliveryDate":U, ped-ent.dt-entorig, OUTPUT iId).

              IF ped-ent.dt-entrega-prim <> ?  AND string(ped-ent.dt-entrega-prim) <> "" THEN
               RUN addNodeDate IN hGenXml (iDelivery, "FirstRequestedDeliveryDate":U, ped-ent.dt-entrega-prim, OUTPUT iId).

              RUN addNode IN hGenXml (iDelivery, "DeliveryTime":U, ped-ent.hr-entrega, OUTPUT iId).
              RUN addNode IN hGenXml (iDelivery, "RequestedDeliveryTime":U, ped-ent.hr-entorig, OUTPUT iId).

              RUN addNodeDec IN hGenXml (iDelivery, "ProgramDeliverySequenceNumber":U, ped-ent.nr-ent-prog, OUTPUT iId).
              RUN addNodeDec IN hGenXml (iDelivery, "AttendanceType":U, ped-ent.tipo-atend, OUTPUT iId).
              RUN addNode    IN hGenXml (iDelivery, "DeliveryComments":U, ped-ent.observacao, OUTPUT iId).

              /* DeliveryStatus */
              RUN addNode    IN hGenXml (iDelivery, "DeliveryStatus":U, "", OUTPUT iDeliveryStatus).
              RUN addNodeDec IN hGenXml (iDeliveryStatus, "CurrentDeliveryStatus":U, ped-ent.cod-sit-ent, OUTPUT iId).

              IF ped-ent.dt-useralt <>  ? AND string(ped-ent.dt-useralt) <> "" AND
                 ped-ent.user-alt   <> "" THEN
                 ASSIGN l-last-upd = YES.         /* DeliveryLastUpdate */

              IF ped-ent.cod-sit-ent = 6    AND
                 ped-ent.dt-canent    <> ?  AND string(ped-ent.dt-canent) <> "" AND
                 ped-ent.desc-cancela <> "" AND
                 ped-ent.user-canc    <> "" THEN
                 ASSIGN l-cancel = YES.       /* DeliveryCancellation */

              IF  ped-ent.cod-sit-ent  = 5   AND
                  ped-ent.dt-suspensao  <> ?  AND string(ped-ent.dt-suspensao) <> "" AND 
                  ped-ent.user-susp     <> "" THEN
                  ASSIGN l-susp = YES.            /* DeliverySuspension */

              IF  ped-ent.cod-sit-ent  = 1  AND
                  ped-item.dt-reativ  <> ?  AND string(ped-item.dt-reativ) <> ""  AND 
                  ped-item.user-reat  <> "" THEN
                  ASSIGN l-reativ = YES.       /* DeliveryReactivation */

              IF  ped-ent.qt-devolvida  <> 0  AND
                  ped-item.dt-devolucao <> ?  AND string(ped-item.dt-devolucao) <> "" AND
                  ped-item.user-devol   <> "" THEN
                  ASSIGN l-devol = YES.       /* Devolution */

              /* DeliveryCancellation */
              IF l-cancel THEN DO:

                RUN addNode     IN hGenXml (iDeliveryStatus, "DeliveryCancellation":U, "", OUTPUT iDeliveryCancel).
                RUN addNode     IN hGenXml (iDeliveryCancel, "CancellationReasonDescription":U, ped-ent.desc-cancela, OUTPUT iId).
                RUN addNodeDate IN hGenXml (iDeliveryCancel, "CancellationDate":U, ped-ent.dt-canent, OUTPUT iId).

                /* CancellationUser */
                RUN addNode IN hGenXml (iDeliveryCancel, "CancellationUser":U, "", OUTPUT iCancellationUser).
                RUN addNode IN hGenXml (iCancellationUser, "UserID":U, ped-ent.user-canc, OUTPUT iId).

                FIND FIRST usuar_mestre WHERE
                            usuar_mestre.cod_usuario = ped-ent.user-canc NO-LOCK NO-ERROR.
                  IF AVAIL usuar_mestre THEN
                   RUN addNode IN hGenXml (iCancellationUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).
               ASSIGN l-cancel = NO.

              END.

              /* DeliverySuspension */
              IF l-susp THEN DO:

                RUN addNode     IN hGenXml (iDeliveryStatus, "DeliverySuspension":U, "", OUTPUT iDeliverySusp).
                RUN addNodeDate IN hGenXml (iDeliverySusp, "SuspensionDate":U, ped-ent.dt-suspensao, OUTPUT iId).

                 /* SuspensionUser */
                 RUN addNode IN hGenXml (iDeliverySusp, "SuspensionUser":U, "", OUTPUT iSuspensionUser).
                 RUN addNode IN hGenXml (iSuspensionUser, "UserID":U, ped-ent.user-susp, OUTPUT iId).

                 FIND FIRST usuar_mestre WHERE
                            usuar_mestre.cod_usuario = ped-ent.user-susp NO-LOCK NO-ERROR.
                   IF AVAIL usuar_mestre THEN
                    RUN addNode IN hGenXml (iSuspensionUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).

                ASSIGN l-susp = NO.
              END.

              /* DeliveryReactivation */
              IF l-reativ THEN DO:

                RUN addNode     IN hGenXml (iDeliveryStatus, "DeliveryReactivation":U, "", OUTPUT iDeliveryReativ).
                RUN addNodeDate IN hGenXml (iDeliveryReativ, "ReactivationDate":U, ped-ent.dt-reativ, OUTPUT iId).

                 /* ReactivationUser */
                 RUN addNode IN hGenXml (iDeliveryReativ, "ReactivationUser":U, "", OUTPUT iReactivationUser).
                 RUN addNode IN hGenXml (iReactivationUser, "UserID":U, ped-ent.user-reat, OUTPUT iId).

                 FIND FIRST usuar_mestre WHERE
                            usuar_mestre.cod_usuario = ped-ent.user-reat NO-LOCK NO-ERROR.
                   IF AVAIL usuar_mestre THEN
                    RUN addNode IN hGenXml (iReactivationUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).

                ASSIGN l-reativ = NO.
              END.

              /* DeliveryLastUpdate */
              IF l-last-upd THEN DO:

                RUN addNode     IN hGenXml (iDelivery, "DeliveryLastUpdate":U, "", OUTPUT iDeliveryUpd).
                RUN addNodeDate IN hGenXml (iDeliveryUpd, "DeliveryLastUpdateDate":U, ped-ent.dt-useralt, OUTPUT iId).

               /* DeliveryLastUpdateUser */
               RUN addNode IN hGenXml (iDeliveryUpd, "DeliveryLastUpdateUser":U, "", OUTPUT iDeliveryUpdUser).
               RUN addNode IN hGenXml (iDeliveryUpdUser, "UserID":U, ped-ent.user-alte, OUTPUT iId).

               FIND FIRST usuar_mestre WHERE
                          usuar_mestre.cod_usuario = ped-ent.user-alte NO-LOCK NO-ERROR.
                 IF AVAIL usuar_mestre THEN
                  RUN addNode IN hGenXml (iDeliveryUpdUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).

              ASSIGN l-last-upd = NO.
              END.

              /* DeliveryQuantityInformation */
              RUN addNodeDec IN hGenXml (iDelivery, "DeliveryQuantityInformation":U, "", OUTPUT iDeliveryQtInfo).
              RUN addNodeDec IN hGenXml (iDeliveryQtInfo, "OrderedQuantity":U, ped-ent.qt-pedida, OUTPUT iId).
              RUN addNodeDec IN hGenXml (iDeliveryQtInfo, "InvoicedQuantity":U, ped-ent.qt-atendida, OUTPUT iId).
              RUN addNode    IN hGenXml (iDeliveryQtInfo, "ItemUnitOfMeasure":U,  ITEM.un, OUTPUT iId).
              RUN addNodeDec IN hGenXml (iDeliveryQtInfo, "QuantityConverted":U, ped-ent.qt-un-fat, OUTPUT iId).

              /* Devolution */
              IF l-devol THEN DO:

                RUN addNode     IN hGenXml (iDelivery, "Devolution":U, "", OUTPUT iDevolution).
                RUN addNodeDate IN hGenXml (iDevolution, "DevolutionDate":U, ped-ent.dt-userdev, OUTPUT iId).

               /* DevolutionUser */
               RUN addNode IN hGenXml (iDevolution, "DevolutionUser":U, "", OUTPUT iDevolutionUser).
               RUN addNode IN hGenXml (iDevolutionUser, "UserID":U, ped-ent.user-devol, OUTPUT iId).

               FIND FIRST usuar_mestre WHERE
                          usuar_mestre.cod_usuario = ped-ent.user-devol NO-LOCK NO-ERROR.
                 IF AVAIL usuar_mestre THEN
                  RUN addNode IN hGenXml (iDevolutionUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).

               RUN addNodeDec IN hGenXml (iDevolution, "ReturnedAmount":U, ped-ent.qt-devolvida, OUTPUT iId).

               ASSIGN l-devol = NO.
              END.

              RUN addNode IN hGenXml (iDelivery, "ExportProcessNumber":U, ped-ent.nr-proc-exp, OUTPUT iId).

             END. /* for each ped-ent */
            END. /*if avail ped-ent */

        IF SUBSTR(ped-item.char-2,11,17) <> "" AND 
           SUBSTR(ped-item.char-2,29,12) <> "" AND
           SUBSTR(ped-item.char-2,1,8)   <> "" THEN DO:

              /* DirectDebitItemInformation */
              RUN addNode IN hGenXml (iOrderItem, "DirectDebitItemInformation":U, "", OUTPUT iDirectDebitInfo).
              RUN addNode IN hGenXml (iDirectDebitInfo, "Account":U, substr(ped-item.char-2,11,17), OUTPUT iId).
              RUN addNode IN hGenXml (iDirectDebitInfo, "AccountingCostAmount":U, substr(ped-item.char-2,29,12), OUTPUT iId).
              RUN addNode IN hGenXml (iDirectDebitInfo, "FiscalClassification":U, substr(ped-item.char-2,1,8), OUTPUT iId).
        END.

        /* OrderItemQuantityInforamtion */
        RUN addNode    IN hGenXml (iOrderItem, "OrderItemQuantityInformation":U, "", OUTPUT iQuantityInfo).
        RUN addNodeDec IN hGenXml (iQuantityInfo, "OrderedQuantity":U, ped-item.qt-pedida, OUTPUT iId).
        RUN addNodeDec IN hGenXml (iQuantityInfo, "InvoicedQuantity":U, ped-item.qt-atendida, OUTPUT iId).
        RUN addNodeDec IN hGenXml (iQuantityInfo, "AllocatedQuantity":U, ped-item.qt-alocada, OUTPUT iId).
        RUN addNodeDec IN hGenXml (iQuantityInfo, "LogicalAllocatedQuantity":U, ped-item.qt-log-aloca, OUTPUT iId).
        RUN addNodeDec IN hGenXml (iQuantityInfo, "InvoicedQuantityForFutureDelivery":U, ped-item.qt-fatenf, OUTPUT iId).

        FIND ITEM WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
          IF AVAIL ITEM THEN
           RUN addNode IN hGenXml (iQuantityInfo, "ItemUnitOfMeasure":U, ITEM.un, OUTPUT iId).

        &if '{&BF_DIS_VERSAO_EMS}' >= '2.05':U &then
            RUN addNode IN hGenXml (iQuantityInfo, "OrderItemUnitOfMeasure":U, ped-item.des-un-medida, OUTPUT iId).
        &endif

         IF ped-item.ind-fat-qtfam THEN ASSIGN i-ind-fat-qtfam = 1.
            ELSE IF ped-item.ind-fat-qtfam = NO THEN ASSIGN i-ind-fat-qtfam = 2.
                 ELSE IF ped-item.ind-fat-qtfam = ? THEN ASSIGN i-ind-fat-qtfam = 3.

          RUN addNodeDec IN hGenXml (iQuantityInfo, "InvoicingUnitOfMeasureInformation":U, i-ind-fat-qtfam, OUTPUT iId).

        &if '{&BF_DIS_VERSAO_EMS}' >= '2.05':U &then
    
          /* QuantityInOrderItemUnitOfMeasure */  
          RUN addNode    IN hGenXml (iQuantityInfo, "QuantityInOrderItemUnitOfMeasure":U, "", OUTPUT iQuantityInOrder).
          RUN addNodeDec IN hGenXml (iQuantityInOrder, "ConversionFactor":U, ped-item.dec-ftconv-unest, OUTPUT iId).
          RUN addNodeDec IN hGenXml (iQuantityInOrder, "ConversionFactorFractionDigits":U, ped-item.num-casa-dec-unest, OUTPUT iId).
          RUN addNodeDec IN hGenXml (iQuantityInOrder, "ConversionFactorType":U, ped-item.ind-origem-fator, OUTPUT iId).
          RUN addNodeDec IN hGenXml (iQuantityInOrder, "QuantityConverted":U, ped-item.qt-un-fat, OUTPUT iId).
        &endif

        /* OrderItemValueInformation */
        RUN addNode IN hGenXml (iOrderItem, "OrderItemValueInformation":U, "", OUTPUT iItemValueInfo).

        IF  ped-item.des-pct-desconto-inform <> ""   OR
            ped-item.val-desconto-inform <> 0        OR
            ped-item.per-des-item <> 0               OR
            ped-item.val-pct-desconto-tab-preco <> 0 OR
            ped-item.vl-desconto <> 0                OR
            ped-item.val-desconto-total <> 0         OR
            ped-item.val-pct-desconto-total <> 0     OR
            ped-item.desc-txt <> ""                  OR
            ped-item.val-pct-desconto-periodo <> 0   OR
            ped-item.val-pct-desconto-prazo  <> 0 THEN DO:

          /* DiscountsAndBonification */
          RUN addNode IN hGenXml (iItemValueInfo, "DiscountsAndBonification":U, "", OUTPUT iDiscountsBonif).

          IF ped-item.des-pct-desconto-inform <> "" THEN
           RUN addNode    IN hGenXml (iDiscountsBonif, "EnteredDiscount":U, ped-item.des-pct-desconto-inform, OUTPUT iId).
          IF ped-item.val-desconto-inform <> 0 THEN
           RUN addNodeDec IN hGenXml (iDiscountsBonif, "DiscountValue":U, ped-item.val-desconto-inform, OUTPUT iId).
          IF ped-item.per-des-item <> 0 THEN
           RUN addNodeDec IN hGenXml (iDiscountsBonif, "DiscountPercentage":U, ped-item.per-des-item, OUTPUT iId).
          IF ped-item.val-pct-desconto-tab-preco <> 0 THEN
           RUN addNodeDec IN hGenXml (iDiscountsBonif, "PriceTableDiscountPercentage":U, ped-item.val-pct-desconto-tab-preco,  OUTPUT iId).
          IF ped-item.vl-desconto <> 0 THEN
           RUN addNodeDec IN hGenXml (iDiscountsBonif, "DiscountAmount":U, ped-item.vl-desconto, OUTPUT iId).
          IF ped-item.val-desconto-total <> 0 THEN
           RUN addNodeDec IN hGenXml (iDiscountsBonif, "TotalDiscountAmount":U, ped-item.val-desconto-total, OUTPUT iId).
          IF ped-item.val-pct-desconto-total <> 0 THEN
           RUN addNodeDec IN hGenXml (iDiscountsBonif, "TotalPercentageOfOrderItemDiscount":U, ped-item.val-pct-desconto-total, OUTPUT iId).
          IF ped-item.desc-txt <> "" THEN
           RUN addNode IN hGenXml (iDiscountsBonif, "OrderItemDiscountsDescription":U, ped-item.desc-txt, OUTPUT iId).
          IF ped-item.val-pct-desconto-periodo <> 0 THEN
           RUN addNodeDec IN hGenXml (iDiscountsBonif, "PeriodDiscountPercentage":U, ped-item.val-pct-desconto-periodo, OUTPUT iId).
          IF ped-item.val-pct-desconto-periodo <> 0 THEN
           RUN addNodeDec IN hGenXml (iDiscountsBonif, "DiscountPercentageLinkedToPaymentTerm":U, ped-item.val-pct-desconto-prazo, OUTPUT iId).

          IF ped-item.log-usa-tabela-desconto THEN DO:

            /* DiscountTable */
            RUN addNode    IN hGenXml (iDiscountsBonif, "DiscountTable":U, "", OUTPUT iDiscountTable).
            RUN addNodeLog IN hGenXml (iDiscountTable, "IsDiscountTableUsedInThisItem":U, ped-item.log-usa-tabela-desconto, OUTPUT iId).

            DO i-cont = 1 TO 5:
              IF ped-item.val-desconto[i-cont] <> 0 THEN
                 ASSIGN l-val-desc = YES.
            END.

            IF l-val-desc THEN DO:

             /* ListOfDiscountTableValues */
             RUN addNode IN hGenXml (iDiscountTable, "ListOfDiscountTableValues":U, "", OUTPUT iListDiscounts).

                 ASSIGN i-cont = 1.
                 DO WHILE i-cont <= 5:

                  RUN addNodeDec IN hGenXml (iListDiscounts, "DiscountTableValue":U, ped-item.val-desconto[i-cont], OUTPUT iId).
                  ASSIGN i-cont = i-cont + 1.

                 END.

              ASSIGN l-val-desc = NO.
            END.

            FIND FIRST desc-ped-item WHERE
                       desc-ped-item.nom-abrev-cliente  = ped-item.nome-abrev   AND
                       desc-ped-item.cod-pedido-cliente = ped-item.nr-pedcli    AND
                       desc-ped-item.num-sequencia      = ped-item.nr-sequencia AND
                       desc-ped-item.cod-item           = ped-item.it-codigo    AND
                       desc-ped-item.cod-refer          = ped-item.cod-refer    NO-LOCK NO-ERROR.
              IF AVAIL desc-ped-item THEN DO:

               /* ListOfDiscounts */
               RUN addNodeDec IN hGenXml (iDiscountTable, "ListOfDiscounts":U, "", OUTPUT iListOfDiscounts).

               FOR EACH desc-ped-item WHERE
                        desc-ped-item.nom-abrev-cliente  = ped-item.nome-abrev   AND
                        desc-ped-item.cod-pedido-cliente = ped-item.nr-pedcli    AND
                        desc-ped-item.num-sequencia      = ped-item.nr-sequencia AND
                        desc-ped-item.cod-item           = ped-item.it-codigo    AND
                        desc-ped-item.cod-refer          = ped-item.cod-refer    NO-LOCK:

                 /* Discount */
                 RUN addNodeDec IN hGenXml (iListOfDiscounts, "Discount":U, "", OUTPUT iDiscount).
                 RUN addNodeDec IN hGenXml (iDiscount, "DiscountNumber":U, desc-ped-item.num-desconto, OUTPUT iId).

                 IF desc-ped-item.val-pct-desconto-period <> 0 THEN
                  RUN addNodeDec IN hGenXml (iDiscount, "PeriodDiscountPercentage":U, desc-ped-item.val-pct-desconto-period,OUTPUT iId).
                 IF desc-ped-item.val-pct-desconto-prazo <> 0 THEN
                  RUN addNodeDec IN hGenXml (iDiscount, "DiscountPercentageLinkedToPaymentTerm":U, desc-ped-item.val-pct-desconto-prazo, OUTPUT iId).
                 RUN addNodeLog IN hGenXml (iDiscount, "IsBonusGrantedOnQuantity":U, desc-ped-item.log-concede-bonif-qtd, OUTPUT iId).

                 DO i-cont = 1 TO 5:
                    IF ped-item.val-desconto[i-cont] <> 0 THEN
                     ASSIGN l-val-desc = YES.
                 END.

                 IF l-val-desc THEN DO:

                  /* ListOfDiscountTableValues */
                  RUN addNode IN hGenXml (iDiscount, "ListOfDiscountTableValues":U, "", OUTPUT iListDiscounts).

                      ASSIGN i-cont = 1.
                      DO WHILE i-cont <= 5:
                       RUN addNodeDec IN hGenXml (iListDiscounts, "DiscountTableValue":U, desc-ped-item.val-desconto[i-cont], OUTPUT iId).
                       ASSIGN i-cont = i-cont + 1.
                      END.

                   ASSIGN l-val-desc = NO.
                 END.

               END.
              END. 
          END. 

          IF ped-item.log-concede-bonif-qtd   OR
             ped-item.num-sequencia-boni <> 0 OR
             ped-item.val-desconto-bonif <> 0 OR
             ped-item.val-pct-bonif <> 0 THEN DO:

             /* Bonification */
             RUN addNode IN hGenXml (iDiscountsBonif, "Bonification":U, "", OUTPUT iBonification).
             RUN addNodeLog IN hGenXml (iBonification, "IsBonusGrantedOnQuantity":U, ped-item.log-concede-bonif-qtd, OUTPUT iId).

             IF ped-item.num-sequencia-boni <> 0 THEN
              RUN addNodeDec IN hGenXml (iBonification, "BonusSequence":U, ped-item.num-sequencia-bonif, OUTPUT iId).
             IF ped-item.val-desconto-boni <> 0 THEN
              RUN addNodeDec IN hGenXml (iBonification, "BonusDiscountValue":U, ped-item.val-desconto-bonif, OUTPUT iId).
             IF ped-item.val-pct-bonif <> 0 THEN
              RUN addNodeDec IN hGenXml (iBonification, "BonusPercentage":U,
                                          ped-item.val-pct-bonif, OUTPUT iId).
          END.
        END. 

        /* Taxes */
        RUN addNode    IN hGenXml (iItemValueInfo, "Taxes":U, "", OUTPUT iTaxes).
        RUN addNodeDec IN hGenXml (iTaxes, "IndustrializedProductTaxPercentage":U, ped-item.aliquota-ipi, OUTPUT iId).

        IF ped-item.dec-2 <> 0 THEN
         RUN addNodeDec IN hGenXml (iTaxes, "ServiceTaxPercentage":U, ped-item.dec-2, OUTPUT iId).

        IF ped-item.ind-icm-ret OR
           ped-item.per-des-icms <> 0 THEN DO:

           /* SalesTax */
           RUN addNode IN hGenXml (iTaxes, "SalesTax":U, "", OUTPUT iSalesTax).
           RUN addNodeLog IN hGenXml (iSalesTax, "IsSalesTaxRestrainedOnSource":U, ped-item.ind-icm-ret, OUTPUT iId).
           RUN addNodeDec IN hGenXml (iSalesTax, "DiscountPercentage":U, ped-item.per-des-icms, OUTPUT iId).
        END.

        /* Price */
        RUN addNode IN hGenXml (iItemValueInfo, "Price":U, "", OUTPUT iPrice).
        RUN addNode IN hGenXml (iPrice, "PriceTableNumber":U, ped-item.nr-tabpre, OUTPUT iId).

        FIND FIRST tb-preco WHERE
                   tb-preco.nr-tabpre = ped-item.nr-tabpre NO-LOCK NO-ERROR.
          IF AVAIL tb-preco AND
                   tb-preco.descricao <> "" THEN
            RUN addNode IN hGenXml (iPrice, "PriceTableDescription":U, tb-preco.descricao, OUTPUT iId).

        RUN addNodeDec IN hGenXml (iPrice, "PriceTableValue":U, dec(string(ped-item.vl-pretab,"999999999.99999":U)), OUTPUT iId).
        RUN addNodeDec IN hGenXml (iPrice, "OriginalPrice":U, dec(string(ped-item.vl-preori,"999999999.99999":U)), OUTPUT iId).
        RUN addNodeDec IN hGenXml (iPrice, "NetUnitaryPrice":U, dec(string(ped-item.vl-preuni,"999999999.99999":U)), OUTPUT iId).
        RUN addNodeDec IN hGenXml (iPrice, "OpenedGoodsNetAmount":U, ped-item.vl-merc-abe, OUTPUT iId).
        RUN addNodeDec IN hGenXml (iPrice, "OrderItemOpenedAmount":U, ped-item.vl-liq-abe, OUTPUT iId).
        RUN addNodeDec IN hGenXml (iPrice, "OrderItemTotalAmount":U, dec(string(ped-item.vl-tot-it,"9999999999.99":U)), OUTPUT iId).
        RUN addNodeDec IN hGenXml (iPrice, "OrderItemTotalNetAmount":U, dec(string(ped-item.vl-liq-it, "9999999999.99":U)), OUTPUT iId).
        RUN addNodeDec IN hGenXml (iPrice, "PriceInOriginalInvoicingUnitOfMeasure":U, ped-item.vl-preori-un-fat, OUTPUT iId).

        IF ped-item.dt-devolucao   <> ?  AND string(ped-item.dt-devolucao) <> "" AND
           ped-item.desc-devol     <> "" AND
           ped-item.user-devol     <> "" AND
           ped-item.qt-devolvida   <> 0  THEN DO:

           /* Devolution */
           RUN addNodeDec  IN hGenXml (iOrderItem, "Devolution":U, "", OUTPUT iDevolution).
           RUN addNode     IN hGenXml (iDevolution, "DevolutionReasonDescription":U, ped-item.desc-devol, OUTPUT iId).
           RUN addNodeDate IN hGenXml (iDevolution, "DevolutionDate":U, ped-item.dt-devolucao, OUTPUT iId).

           /* DevolutionUser */
           RUN addNode IN hGenXml (iDevolution, "DevolutionUser":U, "", OUTPUT iDevolutionUser).
           RUN addNode IN hGenXml (iDevolutionUser, "UserID":U, ped-item.user-devol, OUTPUT iId).

           FIND FIRST usuar_mestre WHERE
                      usuar_mestre.cod_usuario = ped-item.user-devol NO-LOCK NO-ERROR.
             IF AVAIL usuar_mestre THEN
                RUN addNode IN hGenXml (iDevolutionUser, "UserName":U, usuar_mestre.nom_usuario, OUTPUT iId).
        END.

        /* ListOfBusinessUnits */
        FIND FIRST unid-neg-ped WHERE
                   unid-neg-ped.nome-abrev   = ped-item.nome-abrev   AND
                   unid-neg-ped.nr-pedcli    = ped-item.nr-pedcli    AND
                   unid-neg-ped.nr-sequencia = ped-item.nr-sequencia AND
                   &IF "{&ems_dbtype}" <> "PROGRESS":U &THEN  
                   unid-neg-ped.char-1       =  ped-item.it-codigo   AND
                   &ELSE
                   unid-neg-ped.it-codigo    =  ped-item.it-codigo   AND
                   &ENDIF    
                   unid-neg-ped.cod-refer    = ped-item.cod-refer    NO-LOCK NO-ERROR.
          IF AVAIL unid-neg-ped THEN
              RUN addNode IN hGenXml (iOrderItem, "ListOfBusinessUnits":U, "", OUTPUT iListOfBusiness).

            FOR EACH unid-neg-ped OF ped-item NO-LOCK:

              /* BusinessUnit */
              RUN addNode    IN hGenXml (iListOfBusiness, "BusinessUnit":U, "", OUTPUT iBusinessUnit).
              RUN addNode    IN hGenXml (iBusinessUnit, "BusinessUnitID":U,  unid-neg-ped.cod_unid_negoc, OUTPUT iId).
              RUN addNodeDec IN hGenXml (iBusinessUnit, "BusinessUnitPercentage":U, unid-neg-ped.perc-unid-neg, OUTPUT iId).
              RUN addNodeDec IN hGenXml (iBusinessUnit, "BusinessUnitQuantity":U, unid-neg-ped.qtd-unid-neg, OUTPUT iId).
              RUN addNodeDec IN hGenXml (iBusinessUnit, "BusinessUnitValue":U, unid-neg-ped.val-unid-neg, OUTPUT iId).
            END.

        END.

    END.

    RUN pi-detalhes-pedido.

END PROCEDURE. 


PROCEDURE pi-detalhes-pedido.  /*  DESCONTOS, EXPORTAÄ«O */

    DEF VAR iCollection     AS INT NO-UNDO.
    DEF VAR iFinancialTable AS INT NO-UNDO.
    DEF VAR iOrderValueInfo AS INT NO-UNDO.

    RUN addNode    IN hGenXml (iFirstID, "Currency":U, "", OUTPUT iCurrency).
    RUN addNodeDec IN hGenXml (iCurrency, "CurrencyID":U, ped-venda.mo-codigo, OUTPUT iId).

    FIND FIRST moeda WHERE moeda.mo-codigo = ped-venda.mo-codigo NO-LOCK NO-ERROR.
      IF AVAIL moeda THEN DO:
         RUN addNode IN hGenXml (iCurrency, "CurrencyDescription":U, moeda.descricao,OUTPUT iId).
         RUN addNode IN hGenXml (iCurrency, "CurrencySign":U, moeda.sigla, OUTPUT iId).
      END.

    /* Informaá‰es Vendor */
    FIND FIRST param-global NO-LOCK NO-ERROR.      
         IF param-global.modulo-05 THEN 
            RUN adapters/xml/vd2/axsvd003a.p(input rowid(ped-venda)).

    IF ped-venda.tip-cob-desp <> 0 OR
       ped-venda.cod-portador <> 0  OR
       ped-venda.modalidade   <> 0 THEN DO:

          /* Collection */
          RUN addNode IN hGenXml (iFirstId, "Collection":U, "", OUTPUT iCollection).

          IF ped-venda.tip-cob-desp <> 0 THEN
           RUN addNodeDec IN hGenXml (iCollection, "CollectExpensesType":U, ped-venda.tip-cob-desp, OUTPUT iId).
          IF ped-venda.cod-portador <> 0 THEN
           RUN addNodeDec IN hGenXml (iCollection, "CollectorID":U, ped-venda.cod-portador, OUTPUT iId).
          IF ped-venda.modalidade <> 0 THEN
           RUN addNodeDec IN hGenXml (iCollection, "CollectionModality":U, ped-venda.modalidade, OUTPUT iId).
    END.

    RUN pi-informacoes-pagamento.

    IF ped-venda.nr-tab-finan <> 0 AND
       ped-venda.nr-ind-finan <> 0 THEN DO:

      /* FinancialTable*/
      RUN addNode    IN hGenXml (iFirstId, "FinancialTable":U, "", OUTPUT iFinancialTable).
      RUN addNodeDec IN hGenXml (iFinancialTable, "FinancialTableNumber":U, ped-venda.nr-tab-finan, OUTPUT iId).
      RUN addNodeDec IN hGenXml (iFinancialTable, "FinancialIndexNumber":U, ped-venda.nr-ind-finan, OUTPUT iId).
      RUN addNodeDec IN hGenXml (iFinancialTable, "OrderTax":U, ped-venda.tab-ind-fin, OUTPUT iId).
    END.

    /*OrderValueInformation*/
    RUN addNode IN hGenXml (iFirstId, "OrderValueInformation":U, "", OUTPUT iOrderValueInfo).

    IF  ped-venda.log-usa-tabela-desconto         OR
        ped-venda.des-pct-desconto-inform <> ""   OR
        ped-venda.perc-desco1 <> 0                OR
        ped-venda.perc-desco2 <> 0                OR
        ped-venda.val-pct-desconto-tab-preco <> 0 OR
        ped-venda.vl-desconto <> 0                OR
        ped-venda.val-desconto-total <> 0         OR
        ped-venda.val-pct-desconto-total <> 0     OR
        ped-venda.desc-txt <> ""                  OR
        ped-venda.val-pct-desconto-valor <> 0     OR
        ped-venda.inc-desc-txt
        &if '{&BF_DIS_VERSAO_EMS}' >= '2.05':U &then
            OR  ped-venda.desc-valor-ped <> 0
        &endif                                    THEN DO:

        RUN addNode    IN hGenXml (iOrderValueInfo, "Discount":U, "", OUTPUT iDiscount).
        RUN addNodeLog IN hGenXml (iDiscount, "IsDiscountTableUsedInThisOrder":U, ped-venda.log-usa-tabela-desconto, OUTPUT iId).

        IF ped-venda.des-pct-desconto-inform <> "" THEN
         RUN addNode IN hGenXml (iDiscount, "EnteredDiscount":U, ped-venda.des-pct-desconto-inform, OUTPUT iId).
        IF ped-venda.perc-desco1 <> 0 THEN
         RUN addNodeDec IN hGenXml (iDiscount, "CustomerDiscount":U, ped-venda.perc-desco1, OUTPUT iId).
        IF ped-venda.perc-desco2 <> 0 THEN
         RUN addNodeDec IN hGenXml (iDiscount, "DiscountPercentage":U, ped-venda.perc-desco2, OUTPUT iId).
        IF ped-venda.val-pct-desconto-tab-preco <> 0 THEN
         RUN addNodeDec IN hGenXml (iDiscount, "PriceTableDiscountPercentage":U, ped-venda.val-pct-desconto-tab-preco, OUTPUT iId).
        IF ped-venda.vl-desconto <> 0 THEN
         RUN addNodeDec IN hGenXml (iDiscount, "DiscountAmount":U, ped-venda.vl-desconto, OUTPUT iId).
        IF ped-venda.val-desconto-total <> 0 THEN
         RUN addNodeDec IN hGenXml (iDiscount, "TotalDiscountAmount":U, ped-venda.val-desconto-total,OUTPUT iId).
        IF ped-venda.val-pct-desconto-total <> 0 THEN
         RUN addNodeDec IN hGenXml (iDiscount, "TotalPercentageOfOrderDiscount":U, ped-venda.val-pct-desconto-total, OUTPUT iId).
        IF ped-venda.desc-txt <> "" THEN
         RUN addNode IN hGenXml (iDiscount, "OrderDiscountsDescription":U, ped-venda.desc-txt, OUTPUT iId).
        IF ped-venda.val-pct-desconto-valor <> 0 THEN
         RUN addNodeDec IN hGenXml (iDiscount, "DiscountPerValuePercentage":U, ped-venda.val-pct-desconto-valor, OUTPUT iId).

        &if '{&BF_DIS_VERSAO_EMS}' >= '2.05':U &then
            IF ped-venda.desc-valor-ped <> 0 THEN
             RUN addNodeDec IN hGenXml (iDiscount, "DiscountPerValueGrantedOnInvoicingDocumentLevel":U, ped-venda.desc-valor-ped,OUTPUT iId).
        &endif

        RUN addNodeLog IN hGenXml (iDiscount, "IsExtraDiscountAppliedOverSalesPrice":U, ped-venda.inc-desc-txt, OUTPUT iId).
    END.

    IF ped-venda.per-des-icms <> 0 THEN DO:

       /* Taxes */
       RUN addNode IN hGenXml (iOrderValueInfo, "Taxes":U, "", OUTPUT iTaxes).

       /* SalesTax */
       RUN addNode    IN hGenXml (iTaxes, "SalesTax":U, "", OUTPUT iSalesTax).
       RUN addNodeDec IN hGenXml (iSalesTax, "DiscountPercentage":U, ped-venda.per-des-icms, OUTPUT iId).
    END.

    /* Price */
    RUN addNode IN hGenXml (iOrderValueInfo, "Price":U, "", OUTPUT iPrice).

    IF ped-venda.tp-preco <> 0 THEN
       RUN addNodeDec IN hGenXml (iPrice, "OrderPriceType":U, ped-venda.tp-preco, OUTPUT iId).

    RUN addNode IN hGenXml (iPrice, "PriceTableNumber":U, ped-venda.nr-tabpre, OUTPUT iId).

    FIND FIRST tb-preco WHERE
               tb-preco.nr-tabpre = ped-venda.nr-tabpre NO-LOCK NO-ERROR.
      IF AVAIL tb-preco THEN
        RUN addNode IN hGenXml (iPrice,
                                "PriceTableDescription":U,
                                 tb-preco.descricao,
                                 OUTPUT iId).

    IF ped-venda.pct-min-rentab <> 0 THEN
     RUN addNodeDec IN hGenXml (iPrice, "ProfitMinimumPercentage":U, ped-venda.pct-min-rentab, OUTPUT iId).

    RUN addNodeDec IN hGenXml (iPrice, "OpenedGoodsNetAmount":U, ped-venda.vl-mer-abe, OUTPUT iId).
    RUN addNodeDec IN hGenXml (iPrice, "OrderItemOpenedAmount":U, ped-venda.vl-liq-abe, OUTPUT iId).
    RUN addNodeDec IN hGenXml (iPrice, "OrderTotalAmount":U, dec(string(ped-venda.vl-tot-ped,"9999999999.99":U)), OUTPUT iId).

    IF ped-venda.vl-liq-ped <> 0 THEN
     RUN addNodeDec IN hGenXml (iPrice, "OrderTotalNetAmount":U, dec(string(ped-venda.vl-liq-ped, "9999999999.99":U)), OUTPUT iId).

    IF ped-venda.nr-proc-exp <> "" OR
       ped-venda.nr-invoice  <> "" THEN DO:

       /* ExportInformation */
       RUN addNode IN hGenXml (iFirstId, "ExportInformation":U, "", OUTPUT iExportInfo).
       RUN addNode IN hGenXml (iExportInfo, "ExportProcessNumber":U, ped-venda.nr-proc-exp, OUTPUT iId).
       RUN addNode IN hGenXml (iExportInfo, "InvoiceNumber":U, ped-venda.nr-invoice, OUTPUT iId).

     /* Informaá‰es COMEX */
      FIND FIRST param-global NO-LOCK NO-ERROR.
       IF param-global.modulo-ex AND CONNECTED("mgcex") THEN 
        RUN adapters/xml/vd2/axsvd003b.p (input rowid(ped-venda)).

    END.

END PROCEDURE. 


PROCEDURE pi-informacoes-pagamento. /* INFORMAÄÂES REFERENTES AO PAGAMENTO */

DEF VAR iPaymentPlan       AS INT NO-UNDO.
DEF VAR iListPaymentTerms  AS INT NO-UNDO.
DEF VAR iTerm              AS INT NO-UNDO.
DEF VAR iPrepaymentInfo    AS INT NO-UNDO.
DEF VAR iListOfPrepayments AS INT NO-UNDO.
DEF VAR iPrepayment        AS INT NO-UNDO.

    RUN addNode    IN hGenXml (iFirstId, "PaymentPlan":U, "", OUTPUT iPaymentPlan).
    RUN addNodeDec IN hGenXml (iPaymentPlan, "PaymentPlanCode":U, ped-venda.cod-cond-pag, OUTPUT iId).

    FIND FIRST cond-pagto WHERE
               cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-LOCK NO-ERROR.
      IF AVAIL cond-pagto THEN
        RUN addNode IN hGenXml (iPaymentPlan, "PaymentPlanDescription":U, cond-pagto.descricao, OUTPUT iId).

    FIND FIRST cond-ped WHERE
               cond-ped.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.
      IF AVAIL cond-ped THEN DO:

            /* ListOfSpecialPaymentPlanTerms */
            RUN addNode IN hGenXml (iPaymentPlan, "ListOfSpecialPaymentPlanTerms":U, "", OUTPUT iListPaymentTerms).

            FOR EACH cond-ped OF ped-venda NO-LOCK:

                /* Term */
                RUN addNode    IN hGenXml (iListPaymentTerms, "Term":U, "", OUTPUT iTerm).
                RUN addNodeDec IN hGenXml (iTerm, "TermSequence":U, cond-ped.nr-sequencia, OUTPUT iId).
                RUN addNodeDec IN hGenXml (iTerm, "TermDueCode":U, cond-ped.cod-vencto, OUTPUT iId).

                IF cond-ped.data-pagto <> ? THEN
                 RUN addNodeDate IN hGenXml (iTerm, "TermDueDate":U, cond-ped.data-pagto, OUTPUT iId).

                RUN addNodeDec IN hGenXml (iTerm, "TermDueDays":U, cond-ped.nr-dias-venc, OUTPUT iId).

                IF cond-ped.observacoes <> "" THEN
                 RUN addNode IN hGenXml (iTerm, "TermComments":U, cond-ped.observacoes, OUTPUT iId).

                RUN addNodeDec IN hGenXml (iTerm, "TermPaymentPercentage":U, cond-ped.perc-pagto, OUTPUT iId).
                RUN addNodeDec IN hGenXml (iTerm, "TermAmount":U, cond-ped.vl-pagto, OUTPUT iId).
            END. /* for each cond-ped */
      END. /*  if avail cond-ped */

      IF ped-venda.ind-antecip THEN
       FIND FIRST ped-antecip WHERE
                  ped-antecip.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.
         IF AVAIL ped-antecip THEN DO:

             /* PrepaymentInformation */
             RUN addNode    IN hGenXml (iFirstId, "PrepaymentInformation":U, "",OUTPUT iPrepaymentInfo).
             RUN addNodeLog IN hGenXml (iPrepaymentInfo, "IsPrepaymentAvaiable":U, ped-venda.ind-antecip, OUTPUT iId).

             /* ListOfPrepayments */
             RUN addNode IN hGenXml (iPrepaymentInfo, "ListOfPrepayments":U, "", OUTPUT iListOfPrepayments).

             ASSIGN i-cont = 1.
             DO WHILE i-cont <= 6:

                 IF ped-antecip.data-antecip[i-cont] <> ? THEN DO:

                   /* Prepayment */
                   RUN addNode     IN hGenXml (iListOfPrepayments, "Prepayment":U, "", OUTPUT iPrepayment).
                   RUN addNodeDec  IN hGenXml (iPrepayment, "PrepaymentSequence":U, i-cont, OUTPUT iId).
                   RUN addNodeDate IN hGenXml (iPrepayment, "PrepaymentDate":U, ped-antecip.data-antecip[i-cont], OUTPUT iId).
                   IF ped-antecip.vl-antecip[i-cont] <> 0 THEN
                    RUN addNodeDec IN hGenXml (iPrepayment, "PrepaymentAmount":U, ped-antecip.vl-antecip[i-cont], OUTPUT iId).
                   ELSE
                    RUN addNodeDec IN hGenXml (iPrepayment, "PrepaymentAmount":U, 0, OUTPUT iId).
                 END.
                 ASSIGN i-cont = i-cont + 1.
             END.

             IF ped-antecip.observacoes <> "" THEN
                RUN addNode IN hGenXml (iPrepaymentInfo, "PrepaymentComments":U, ped-antecip.observacoes, OUTPUT iId).
         END.

END PROCEDURE. 

