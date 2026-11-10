DEF VAR l-func-totvsgfe AS LOGICAL INIT NO.
DEF VAR h-boad123a AS HANDLE.

DEF BUFFER bf-item-embal FOR item-embal.
DEF BUFFER bf-item FOR ITEM.
DEF BUFFER bf-nota-embal FOR nota-embal.
    
DEFINE TEMP-TABLE tt-rateio-emb-aux NO-UNDO  /*Criado para parte de rateio de volumes da embal. no item*/
    FIELD nr-seq-fat   AS INT
    FIELD nr-embalagem AS INT
    FIELD it-codigo    AS CHAR
    FIELD tot-peso     AS DECIMAL
    FIELD tot-valor    AS DECIMAL
    FIELD tot-m3       AS DECIMAL
    FIELD tot-qt       AS DECIMAL.

DEFINE TEMP-TABLE tt-it-nota-fisc-volume NO-UNDO
       FIELD nr-seq-fat LIKE it-nota-fisc.nr-seq-fat
       FIELD it-codigo  LIKE it-nota-fisc.it-codigo 
       FIELD volume-rat AS DECIMAL
       FIELD peso-embal AS DECIMAL
       field l-embal-detalha as log.

DEFINE VARIABLE h-cdapi995    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE de-pc-pis    AS DECIMAL FORMAT ">9.9999" NO-UNDO.
DEFINE VARIABLE de-pc-cofins AS DECIMAL FORMAT ">9.9999" NO-UNDO.


PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/

DEF INPUT PARAM pTranAction            AS CHAR  NO-UNDO . /* add/upd */
DEF INPUT PARAM pTranEvent             AS CHAR  NO-UNDO . /* UpdateDocument/UndoUpdateDocument */
DEF INPUT PARAM pInvoiceDocumentRowID  AS ROWID NO-UNDO  .  
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*DEF VAR h-boad123a AS HANDLE.*/
/*DEF VAR l-func-totvsgfe AS LOGICAL INIT NO.*/
DEF VAR i-codigo-orig   AS INTEGER NO-UNDO.
DEF VAR dtPrevEntrega AS DATE NO-UNDO.


/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro                     NO-ERROR.
EMPTY TEMP-TABLE ttInvoiceDocument               NO-ERROR.
EMPTY TEMP-TABLE ttInvoiceDocumentAux            NO-ERROR.
EMPTY TEMP-TABLE ttDocumentTax                   NO-ERROR.
EMPTY TEMP-TABLE ttDevolutionDocument            NO-ERROR.
EMPTY TEMP-TABLE ttDocumentBill                  NO-ERROR.
EMPTY TEMP-TABLE ttDocumentBillItem              NO-ERROR.
EMPTY TEMP-TABLE ttPackaging                     NO-ERROR.
EMPTY TEMP-TABLE ttPackingSlip                   NO-ERROR.
&IF '{&BF_DIS_VERSAO_EMS}' >= '2.08' &THEN
EMPTY TEMP-TABLE ttRedispatchCarrier             NO-ERROR.
EMPTY TEMP-TABLE ttFreightSimulation             NO-ERROR.
EMPTY TEMP-TABLE ttFreightInformations           NO-ERROR.
&ENDIF
EMPTY TEMP-TABLE ttRepresentative                NO-ERROR.
EMPTY TEMP-TABLE ttTerm                          NO-ERROR.
EMPTY TEMP-TABLE ttDocumentItem                  NO-ERROR.
EMPTY TEMP-TABLE ttDiscount                      NO-ERROR.
EMPTY TEMP-TABLE ttDiscountTableValue            NO-ERROR.
EMPTY TEMP-TABLE ttIssuedLocation                NO-ERROR.
EMPTY TEMP-TABLE ttDocumentItemTax               NO-ERROR.
EMPTY TEMP-TABLE ttBusinessUnit                  NO-ERROR.
EMPTY TEMP-TABLE ttImportDocument                NO-ERROR.
EMPTY TEMP-TABLE ttImportDocumentAdd             NO-ERROR.
EMPTY TEMP-TABLE ttDocumentItemVehicle           NO-ERROR.
EMPTY TEMP-TABLE ttDocumentItemMedicine          NO-ERROR.
EMPTY TEMP-TABLE ttDocumentItemFuel              NO-ERROR.
EMPTY TEMP-TABLE ttInvoiceDocumentAddInformation NO-ERROR.
EMPTY TEMP-TABLE ttAddInformationTaxPayer        NO-ERROR.
EMPTY TEMP-TABLE ttAddInformationTaxComment      NO-ERROR.
EMPTY TEMP-TABLE ttReferencedProcess             NO-ERROR.

/* Zera totalizadores */
ASSIGN d-total-base-icms                = 0
       d-total-icms                     = 0
       d-total-base-icms-sub            = 0
       d-total-icms-sub                 = 0
       d-total-base-ipi                 = 0
       d-total-base-iss                 = 0  
       d-total-iss                      = 0  
       d-total-csll                     = 0  
       d-total-base-pis                 = 0  
       d-total-pis                      = 0  
       d-total-pis-ret                  = 0  
       d-total-base-cofins              = 0  
       d-total-cofins                   = 0  
       d-total-cofins-ret               = 0  
       d-total-base-vl-ir-adic          = 0  
       d-total-vl-ir-adic               = 0  
       d-total-vl-irf-it                = 0  
       d-total-base-vl-irf-it           = 0  
       d-total-base-ii                  = 0  
       d-total-ii                       = 0  
       de-perc-pis-subst                = 0   
       de-vl-pis-subst                  = 0  
       de-perc-cofins-subst             = 0  
       de-vl-cofins-subst               = 0  
       de-taxa-pis                      = 0  
       de-taxa-cofins                   = 0
       de-vl-total-pis-por-unidade      = 0
       de-vl-total-cofins-por-unidade   = 0.


FIND FIRST nota-fiscal WHERE ROWID(nota-fiscal) = pInvoiceDocumentRowID NO-LOCK NO-ERROR.

IF AVAIL nota-fiscal THEN DO:

    

    IF CAN-FIND(FIRST funcao
                WHERE funcao.cd-funcao = "spp-nfe"
                AND   funcao.ativo     ) THEN DO:
            
           assign c-serie = nota-fiscal.serie.
            
            /* TrataSerieNfe: EPC para retirar letras da s‚rie */
            FOR EACH  tt-epc
                WHERE tt-epc.cod-event = "TrataSerieNfe":U:
               DELETE tt-epc.
            END.
            
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "TrataSerieNfe":U
                   tt-epc.cod-parameter = "serie":U
                   tt-epc.val-parameter =  c-serie.
                   
            {include/i-epc201.i "TrataSerieNfe"}
            
            FOR FIRST tt-epc
                WHERE tt-epc.cod-event     = "TrataSerieNfe":U AND 
                      tt-epc.cod-parameter = "serie-nfe":U :
               
                ASSIGN c-serie = tt-epc.val-parameter.
            END.
            /* TrataSerieNfe */
            
    END.

    
    FIND FIRST param-global NO-LOCK NO-ERROR.
    ASSIGN l-vendor = NO.
    IF param-global.modulo-05 = YES THEN
        ASSIGN l-vendor = YES.

    FOR FIRST emitente FIELDS (cod-entrega cgc cgc-cob ins-estadual ins-est-cob endereco endereco-cob cod-suframa 
                               bairro bairro-cob cidade cidade-cob estado estado-cob pais pais-cob
                               cep cep-cob contato[1] telefone[1] e-mail end-cobranca char-1 nome-emit &if '{&bf_dis_versao_ems}' >= '2.07':U &then nom-fantasia &ENDIF
                                &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &THEN cod-inscr-inss &ELSE char-2 &ENDIF natureza contrib-icms) NO-LOCK 
        WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli: END.

    FOR FIRST natur-oper NO-LOCK 
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao: END.

     IF AVAIL natur-oper THEN
        &if '{&bf_dis_versao_ems}' >= '2.05':U &then
            FOR FIRST cfop-natur FIELDS(des-cfop) NO-LOCK
                WHERE cfop-natur.cod-cfop = &if defined(bf_dis_formato_CFOP) &then natur-oper.cod-cfop &else SUBSTR(natur-oper.char-1,45,10) &endif: END.
        &else
           FOR FIRST ped-curva FIELDS(nome) NO-LOCK
                WHERE ped-curva.it-codigo = &if defined(bf_dis_formato_CFOP) &then natur-oper.cod-cfop &else SUBSTR(natur-oper.char-1,45,10) &endif AND
                      ped-curva.vl-aberto = 620: END.
        &endif

    FOR FIRST estabelec FIELDS (nome cod-emitente char-1 ins-estadual endereco conta-pis-rec     
                                bairro cidade estado pais cep cgc conta-fin-pag cod-estabel) NO-LOCK 
        WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel: END.

    FOR FIRST canal-venda FIELDS (descricao) NO-LOCK 
        WHERE canal-venda.cod-canal-venda = nota-fiscal.cod-canal-venda: END.

    FOR FIRST rota FIELDS (descricao roteiro) NO-LOCK 
        WHERE rota.cod-rota = nota-fiscal.cod-rota: END.

    FOR FIRST mensagem FIELDS (texto-mensag) NO-LOCK 
        WHERE mensagem.cod-mensagem = nota-fiscal.cod-mensagem: END.

    FOR FIRST transporte FIELDS (cod-transp cgc ins-estadual nome-abrev via-transp contato telefone e-mail endereco bairro cidade estado pais cep nome) NO-LOCK 
        WHERE transporte.nome-abrev = nota-fiscal.nome-transp: END.

    FOR FIRST portador FIELDS (cod-portador nome) NO-LOCK 
        WHERE portador.cod-portador = nota-fiscal.cod-portador: END.

    FOR FIRST cond-pagto FIELDS (descricao cod-vencto) NO-LOCK 
        WHERE cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag: END.

    FOR FIRST nota-trans FIELDS (vl-servico aliquota-icm vl-bicms perc-red-base vl-icms ind-cobranca cod-mensagem) NO-LOCK 
        WHERE nota-trans.serie       = nota-fiscal.serie        
          AND nota-trans.nr-nota-fis = nota-fiscal.nr-nota-fis  
          AND nota-trans.cod-estabel = nota-fiscal.cod-estabel: END.

    FOR FIRST moeda FIELDS (descricao sigla) NO-LOCK 
        WHERE moeda.mo-codigo = int(substr(nota-fiscal.mo-codigo,1,2)): END.

    FOR FIRST tb-preco FIELDS (descricao) NO-LOCK 
        WHERE tb-preco.nr-tabpre = nota-fiscal.nr-tabpre: END.

    FOR FIRST funcao NO-LOCK
        WHERE funcao.cd-funcao = "SPP-NFE":U
          AND funcao.ativo     = YES: END.
          ASSIGN l-nfe = AVAIL funcao.

    RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.

    RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.

    CREATE ttInvoiceDocument.

    IF c-serie <> "" THEN
        ASSIGN ttInvoiceDocument.DocumentSeries  = c-serie .
    ELSE 
    IF nota-fiscal.serie <> "" THEN 
        ASSIGN ttInvoiceDocument.DocumentSeries  = nota-fiscal.serie .
    ELSE 
        ASSIGN ttInvoiceDocument.DocumentSeries  =  "000". 



    FOR FIRST ped-venda NO-LOCK WHERE ped-venda.nome-abrev = nota-fiscal.nome-abrev 
                                  AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli:
    END.
    IF AVAIL ped-venda THEN
        ASSIGN dtPrevEntrega = ped-venda.dt-entrega.
    ELSE
        ASSIGN dtPrevEntrega = ?.
    


    ASSIGN cTranAction  = pTranAction
           cTranEvent   = pTranEvent
           iContItem    = 0
           ttInvoiceDocument.DocumentNumber                     = nota-fiscal.nr-nota-fis
           ttInvoiceDocument.DocumentType                       = nota-fiscal.esp-docto
           ttInvoiceDocument.IsPrinted                          = IF nota-fiscal.ind-sit-nota > 1  THEN TRUE ELSE FALSE
           ttInvoiceDocument.IsInventoryUpdated                 = IF nota-fiscal.dt-confirm   <> ? THEN TRUE ELSE FALSE
           ttInvoiceDocument.IsCanceled                         = IF nota-fiscal.dt-cancela   <> ? THEN TRUE ELSE FALSE
           ttInvoiceDocument.IsAccountsReceivableUpdated        = IF nota-fiscal.dt-atual-cr  <> ? THEN TRUE ELSE FALSE
           ttInvoiceDocument.IsTaxManagementUpdated             = IF nota-fiscal.dt-at-ofest  <> ? THEN TRUE ELSE FALSE
           ttInvoiceDocument.IsStatisticsUpdated                = IF nota-fiscal.dt-at-est    <> ? THEN TRUE ELSE FALSE
           ttInvoiceDocument.IsPosted                           = IF nota-fiscal.ind-contabil      THEN TRUE ELSE FALSE
           ttInvoiceDocument.CustomerShortName                  = nota-fiscal.nome-ab-cli
           ttInvoiceDocument.CustomerTaxID                      = nota-fiscal.cgc
           ttInvoiceDocument.CustomerStateTaxID                 = CAPS(nota-fiscal.ins-estadual)
           ttInvoiceDocument.CustomerStateTaxID                 = &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &THEN 
                                                                     IF emitente.cod-inscr-inss <> "" AND emitente.natureza = 1 THEN emitente.cod-inscr-inss ELSE CAPS(nota-fiscal.ins-estadual)
                                                                  &ELSE 
                                                                      IF num-entries(emitente.char-2,chr(10)) > 1 AND entry(2,emitente.char-2,chr(10)) <> "" AND emitente.natureza = 1 THEN entry(2,emitente.char-2,chr(10)) 
                                                                        ELSE CAPS(nota-fiscal.ins-estadual)
                                                                  &ENDIF
           ttInvoiceDocument.CustomerID                         = nota-fiscal.cod-emitente
           ttInvoiceDocument.CustomerOrderNumber                = nota-fiscal.nr-pedcli
           ttInvoiceDocument.ConsumerName                       = substr(nota-fiscal.char-2,136,40)
           ttInvoiceDocument.ConfirmationDate                   = nota-fiscal.dt-confirma
           ttInvoiceDocument.CancellationDate                   = nota-fiscal.dt-cancela
           ttInvoiceDocument.CancellationReason                 = nota-fiscal.desc-cancela
           ttInvoiceDocument.GoodsIssueDate                     = nota-fiscal.dt-saida
           ttInvoiceDocument.DeliveryDate                       = dtPrevEntrega /**/
           ttInvoiceDocument.VolumeType                         = nota-fiscal.marca-volume /**/
           ttInvoiceDocument.VolumeNumber                       = nota-fiscal.nr-volumes  /**/
           ttInvoiceDocument.CommercialArea                     = nota-fiscal.nome-ab-reg   /**/             
           ttInvoiceDocument.GoodsTarget                        = nota-fiscal.cod-des-merc
           ttInvoiceDocument.IsDocumentReleasedWithoutBalance   = nota-fiscal.ind-lib-nota
           ttInvoiceDocument.IsDocumentInvoiced                 = nota-fiscal.emite-duplic
           ttInvoiceDocument.InvoiceNumber                      = nota-fiscal.nr-fatura
           ttInvoiceDocument.InvoiceDocumentType                = nota-fiscal.ind-tip-nota
           ttInvoiceDocument.InvoicingType                      = nota-fiscal.tipo-fat
           ttInvoiceDocument.DocumentGrossWeight                = nota-fiscal.peso-bru-tot
           ttInvoiceDocument.DocumentNetWeight                  = nota-fiscal.peso-liq-tot
           ttInvoiceDocument.LocationID                         = nota-fiscal.cod-entrega
           ttInvoiceDocument.LicensePlateStateID                = nota-fiscal.uf-placa
           ttInvoiceDocument.LicensePlateID                     = nota-fiscal.placa
           ttInvoiceDocument.FreightType                        = IF nota-fiscal.cidade-cif <> "" THEN 1 ELSE 2 /* 1- CIF, 2- FOB */
           ttInvoiceDocument.CollectionModality                 = nota-fiscal.modalidade
           ttInvoiceDocument.ExportProcessNumber                = nota-fiscal.nr-proc-exp
           ttInvoiceDocument.FinancialTableNumber               = nota-fiscal.nr-tab-finan
           ttInvoiceDocument.FinancialIndexNumber               = nota-fiscal.nr-ind-finan
           ttInvoiceDocument.EnteredDiscounts                   = nota-fiscal.des-pct-desconto-inform
           ttInvoiceDocument.CustomerDiscountPercentage         = nota-fiscal.perc-desco1
           ttInvoiceDocument.DiscountAmount                     = nota-fiscal.vl-desconto
           ttInvoiceDocument.DocumentDiscountPercentage         = nota-fiscal.perc-desco2
           ttInvoiceDocument.DiscountPerValuePercentage         = nota-fiscal.val-pct-desconto-valor
           ttInvoiceDocument.FreightValue                       = nota-fiscal.vl-frete
           ttInvoiceDocument.FreightTaxPercentage               = nota-fiscal.perc-tax-fre
           ttInvoiceDocument.InsuranceValue_00                  = nota-fiscal.vl-seguro
           ttInvoiceDocument.InsuranceTaxPercentage             = nota-fiscal.perc-tax-seg
           ttInvoiceDocument.InsuranceTaxValue                  = nota-fiscal.tax-seg
           ttInvoiceDocument.CommissionValue                    = nota-fiscal.vl-comis-nota
           ttInvoiceDocument.ExportTax                          = nota-fiscal.vl-taxa-exp
           ttInvoiceDocument.AccumulatedBillsValue              = nota-fiscal.vl-acum-dup
           ttInvoiceDocument.InvoiceValue                       = nota-fiscal.vl-fatura
           ttInvoiceDocument.GoodsValue                         = nota-fiscal.vl-mercad
           ttInvoiceDocument.InvoicedGoodsValue                 = nota-fiscal.vl-merc-tot-fat
           ttInvoiceDocument.InvoicedItensValue                 = nota-fiscal.vl-tot-itens-fat
           ttInvoiceDocument.DocumentTotalPrice                 = nota-fiscal.vl-tot-nota
           /* Natureza de Opera»’o */
           ttInvoiceDocument.FiscalOperationCode                = nota-fiscal.nat-operacao
           ttInvoiceDocument.FiscalOperationDescription         = &if '{&bf_dis_versao_ems}' >= '2.05':U &then 
                                                                    IF AVAIL cfop-natur THEN cfop-natur.des-cfop
                                                                       ELSE natur-oper.denominacao WHEN AVAIL natur-oper
                                                                  &else
                                                                     IF AVAIL ped-curva THEN ped-curva.nome 
                                                                       ELSE natur-oper.denominacao WHEN AVAIL natur-oper
                                                                  &endif
           /* Canal Venda */
           ttInvoiceDocument.DistributionChannelCode            = nota-fiscal.cod-canal-venda
           ttInvoiceDocument.DistributionChannelDescription     = canal-venda.descricao  WHEN AVAIL canal-venda
           /* Mensagem */
           ttInvoiceDocument.MessageID                          = nota-fiscal.cod-mensagem
           ttInvoiceDocument.MessageDescription                 = mensagem.texto-mensag  WHEN AVAIL mensagem
           /* Portador */
           ttInvoiceDocument.CollectorID                        = nota-fiscal.cod-portador
           ttInvoiceDocument.CollectorName                      = portador.nome          WHEN AVAIL portador
           /* Moeda */
           ttInvoiceDocument.CurrencyID                         = int(substr(nota-fiscal.mo-codigo,1,2))
           ttInvoiceDocument.CurrencyDescription                = moeda.descricao        WHEN AVAIL moeda
           ttInvoiceDocument.CurrencySign                       = moeda.sigla            WHEN AVAIL moeda
          &IF "{&BF_DIS_VERSAO_EMS}" >= "2.08" &THEN
           ttInvoiceDocument.DocumentClass                      = natur-oper.especie-doc 
           ttInvoiceDocument.IsFinalConsumer                    = natur-oper.consum-final
           ttInvoiceDocument.TransferOperation                  = natur-oper.transf
           ttInvoiceDocument.TYPE                               = natur-oper.tipo
          &ENDIF                                                                 
           .
                
    IF  estabelec.estado = "PR"
    AND ttInvoiceDocument.CustomerStateTaxID = "isento":U
    AND NOT emitente.contrib-icms
    AND (   emitente.natureza = 1
         OR emitente.natureza = 2 ) THEN
        ASSIGN ttInvoiceDocument.CustomerStateTaxID = "".

    CREATE ttInvoiceDocumentAux.
    ASSIGN ttInvoiceDocumentAux.PrintDate                          = nota-fiscal.dt-emis-nota
           ttInvoiceDocumentAux.OverdueAverageTerm                 = nota-fiscal.nr-praz-med
           ttInvoiceDocumentAux.Narrative                          = nota-fiscal.observ-nota 
           ttInvoiceDocumentAux.ShipmentNumber                     = &IF '{&product_version}' >= '11.5.3' &THEN
                                                                        nota-fiscal.cdd-embarq
                                                                     &ELSE
                                                                        nota-fiscal.nr-embarque
                                                                     &ENDIF
           ttInvoiceDocumentAux.ShipmentSummaryNumber              = nota-fiscal.nr-resumo
           ttInvoiceDocumentAux.ShipmentDate                       = nota-fiscal.dt-embarque
           ttInvoiceDocumentAux.PaidFreightCity                    = nota-fiscal.cidade-cIF
           ttInvoiceDocumentAux.PriceTableDiscountPercentage       = nota-fiscal.val-pct-desconto-tab-preco
           ttInvoiceDocumentAux.PriceType                          = nota-fiscal.tp-preco
           ttInvoiceDocumentAux.ReshipmentTerms                    = nota-fiscal.cond-redespa
           ttInvoiceDocumentAux.TotalPercentageOfDocumentDisc_00   = nota-fiscal.val-pct-desconto-total
           ttInvoiceDocumentAux.PackagingValue                     = nota-fiscal.vl-embalagem
           ttInvoiceDocumentAux.PackagingTaxPercentage             = nota-fiscal.perc-tax-emb
           /* Rota */
           ttInvoiceDocumentAux.RouteID                            = nota-fiscal.cod-rota
           ttInvoiceDocumentAux.RouteDescription                   = rota.descricao         WHEN AVAIL rota
           ttInvoiceDocumentAux.RoutingSpecification               = rota.roteiro           WHEN AVAIL rota
            /* Condi»’o de Pagamento */
           ttInvoiceDocumentAux.PaymentPlanCode                    = nota-fiscal.cod-cond-pag
           ttInvoiceDocumentAux.PaymentPlanDescription             = cond-pagto.descricao   WHEN AVAIL cond-pagto
            /* Tabela de Pre»o */
           ttInvoiceDocumentAux.PriceTableNumber                   = nota-fiscal.nr-tabpre
           ttInvoiceDocumentAux.PriceTableDescription              = tb-preco.descricao     WHEN AVAIL tb-preco
           .
            
           IF  CAN-FIND (funcao WHERE funcao.cd-funcao = "SPP-DESCONTO-NFE":U AND funcao.ativo) 
               AND INT(SUBSTRING(natur-oper.char-2,11,5)) = 2 THEN 
               ASSIGN ttInvoiceDocumentAux.TotalDiscountAmount     = 0.
           ELSE 
               ASSIGN ttInvoiceDocumentAux.TotalDiscountAmount     = IF NOT l-nfe THEN nota-fiscal.val-desconto-total ELSE 0.  
                
    &IF  '{&bf_dis_sgt}' = 'yes':U &THEN
         IF  l-funcao-SGT THEN DO:
             &IF '{&bf_dis_versao_ems}':U >= '2.08':U &THEN
             for first roman-item-nf no-lock
                 where roman-item-nf.cod-estab      = nota-fiscal.cod-estabel
                 and   roman-item-nf.cod-serie      = nota-fiscal.serie
                 and   roman-item-nf.nr-nota-fis    = nota-fiscal.nr-nota-fis:
                 assign ttInvoiceDocumentAux.PickingListNumber = string(roman-item-nf.nr-romaneio). /* N£mero Romaneio */
             end.
             &else
             for first tab-ocor no-lock
                 where tab-ocor.cod-tab    = 600
                 and   tab-ocor.c-campo[1] = nota-fiscal.cod-estabel
                 and   tab-ocor.c-campo[2] = nota-fiscal.serie
                 and   tab-ocor.c-campo[3] = nota-fiscal.nr-nota-fis:
                 assign ttInvoiceDocumentAux.PickingListNumber = string(tab-ocor.int-1). /* N£mero Romaneio */
             end. /* for first tab-ocor */
             &ENDIF
         END. /* IF  l-funcao-SGT THEN DO: */
    &ENDIF        
                
     /* Cod Vencto Condicao Pagto */
     ASSIGN ttInvoiceDocumentAux.PaymentPlanDueCode = cond-pagto.cod-vencto WHEN AVAIL cond-pagto.

            FOR FIRST ser-estab FIELDS (&if '{&bf_dis_versao_ems}' >= '2.07':U &then log-nf-eletro idi-format-emis-danfe nom-model-danfe &else char-1 &ENDIF) NO-LOCK
                WHERE ser-estab.serie = nota-fiscal.serie
                  AND ser-estab.cod-estabel = nota-fiscal.cod-estabel: END.
    
            &IF '{&product_version}' >= '11.5.3' &THEN
                FOR FIRST embarque FIELDS (&if '{&bf_dis_versao_ems}' >= '2.07':U &then uf-placa &else char-1 &ENDIF) NO-LOCK
                    WHERE embarque.cdd-embarq = nota-fiscal.cdd-embarq: END.
            &ELSE
                FOR FIRST embarque FIELDS (&if '{&bf_dis_versao_ems}' >= '2.07':U &then uf-placa &else char-1 &ENDIF) NO-LOCK
                    WHERE embarque.nr-embarque = nota-fiscal.nr-embarque: END.
            &ENDIF
    
            IF CONNECTED("mgcex":U) THEN DO:
                FOR FIRST proc-nota-fiscal NO-LOCK
                    WHERE proc-nota-fiscal.cod-estabel = nota-fiscal.cod-estab-proces-export
                      AND proc-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
                      AND proc-nota-fiscal.nr-proc-exp = nota-fiscal.nr-proc-exp
                      and proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel
                      AND proc-nota-fiscal.serie = nota-fiscal.serie,
                    FIRST processo-exp NO-LOCK
                    WHERE processo-exp.cod-estabel = proc-nota-fiscal.cod-estabel
                      AND processo-exp.nr-proc-exp = proc-nota-fiscal.nr-proc-exp,
                    FIRST historico-proc-exp NO-LOCK
                    WHERE historico-proc-exp.cod-estabel = processo-exp.cod-estabel
                      AND historico-proc-exp.nr-proc-exp = processo-exp.nr-proc-exp
                      AND historico-proc-exp.cod-itiner = processo-exp.cod-itiner
                      AND historico-proc-exp.cod-pto-contr = processo-exp.pto-embarque,
                    FIRST itinerario OF historico-proc-exp NO-LOCK,
                    FIRST pto-contr FIELDS(descricao char-1 &if '{&bf_dis_versao_ems}' >= '2.07':U &then cod-uf &ENDIF) NO-LOCK
                    WHERE pto-contr.cod-pto-contr = itinerario.pto-embarque:

                        /* UF Ponto Controle*/
                        ASSIGN ttInvoiceDocumentAux.CountPointStateId = 
                            IF historico-proc-exp.cod-uf <> "":U THEN historico-proc-exp.cod-uf ELSE STRING(pto-contr.cod-uf).

                        ASSIGN ttInvoiceDocumentAux.CountPointDescription = 
                            IF historico-proc-exp.descricao <> "":U THEN historico-proc-exp.descricao ELSE pto-contr.descricao.
                END.
            END.


     ASSIGN ttInvoiceDocumentAux.PatternInvoiceId = string(natur-oper.cd-situacao) when avail natur-oper
            ttInvoiceDocumentAux.CustomerName     = emitente.nome-emit WHEN AVAIL emitente
            ttInvoiceDocumentAux.SUFRAMACode      = emitente.cod-suframa WHEN AVAIL emitente.

            &if '{&bf_dis_versao_ems}' >= '2.04':U AND '{&bf_dis_versao_ems}' <= '2.062':U &then
                ASSIGN
                &if '{&bf_dis_versao_ems}' = '2.062':U &then
                ttInvoiceDocument.LicensePlateStateID       = substring(embarque.char-1,15,2) WHEN AVAIL embarque
                &ELSE
                ttInvoiceDocument.LicensePlateStateID       = substring(embarque.char-1,14,2) WHEN AVAIL embarque
                &ENDIF
                       /* Nome Fantasia*/
                ttInvoiceDocumentAux.FantasyName               = substring(emitente.char-1,39,60) WHEN AVAIL emitente
                /* Emite NF-e*/
                ttInvoiceDocumentAux.EletronicInvoice          = substring(ser-estab.char-1,1,3) WHEN AVAIL ser-estab
                /* DANFE*/
                ttInvoiceDocumentAux.DanfeFormat               = substring(ser-estab.char-1,4,1) WHEN AVAIL ser-estab
                ttInvoiceDocumentAux.DanfeNamePattern          = substring(ser-estab.char-1,5,60) WHEN AVAIL ser-estab
                /* Modelo NF-e*/
                ttInvoiceDocumentAux.PatternEletronicInvoice   = substring(natur-oper.char-2,120,2) WHEN AVAIL natur-oper
                /* NF-e */
                ttInvoiceDocumentAux.AcessKeyEletronicInvoice  = substring(nota-fiscal.char-2,3,60)
                ttInvoiceDocumentAux.KindPrinted               = substring(nota-fiscal.char-2,65,2)
                ttInvoiceDocumentAux.PackageClassDescription   = substring(nota-fiscal.char-2,67,60)
                /* UF Ponto Controle*/
                ttInvoiceDocumentAux.CountPointStateId         = substring(pto-contr.char-1,1,2) WHEN AVAIL pto-contr. 
            &endif.
                 
            &if '{&bf_dis_versao_ems}' >= '2.07':U &then
         ASSIGN ttInvoiceDocument.LicensePlateStateID          = embarque.uf-placa WHEN AVAIL embarque
                ttInvoiceDocumentAux.FantasyName               = emitente.nom-fantasia WHEN AVAIL emitente
                ttInvoiceDocumentAux.EletronicInvoice          = string(ser-estab.log-nf-eletro) WHEN AVAIL ser-estab
                ttInvoiceDocumentAux.DanfeFormat               = string(ser-estab.idi-format-emis-danfe) WHEN AVAIL ser-estab
                ttInvoiceDocumentAux.DanfeNamePattern          = ser-estab.nom-model-danfe WHEN AVAIL ser-estab
                ttInvoiceDocumentAux.PatternEletronicInvoice   = string(natur-oper.cod-model-nf-eletro) WHEN AVAIL natur-oper
                ttInvoiceDocumentAux.AcessKeyEletronicInvoice  = string(nota-fiscal.cod-chave-aces-nf-eletro)
                ttInvoiceDocumentAux.KindPrinted               = string(nota-fiscal.idi-forma-emis-nf-eletro)
                ttInvoiceDocumentAux.PackageClassDescription   = nota-fiscal.des-espec-volum
                ttInvoiceDocumentAux.CountPointStateId         = string(pto-contr.cod-uf) WHEN AVAIL pto-contr.
            &endif.

     /* A chamada UPC abaixo foi inserida para que seja possivel enviar as informaoces de embarque gravadas em tabela especifica (quando o modulo de Exportacao nao est  implantado) */
     IF l-nfe THEN DO:
         
         FOR EACH  tt-epc
             WHERE tt-epc.cod-event = "TrataExportacao":U:
            DELETE tt-epc.
         END.
         
         CREATE tt-epc.
         ASSIGN tt-epc.cod-event     = "TrataExportacao":U
                tt-epc.cod-parameter = "nota-fiscal":U
                tt-epc.val-parameter =  STRING(ROWID(nota-fiscal)).
                
         {include/i-epc201.i "TrataExportacao"}
         
         FOR FIRST tt-epc
             WHERE tt-epc.cod-event     = "TrataExportacao":U AND 
                   tt-epc.cod-parameter = "embarque":U :
            
             ASSIGN ttInvoiceDocumentAux.CountPointStateId     = ENTRY(1,tt-epc.val-parameter,";") /* Sigla UF Embarque */
                    ttInvoiceDocumentAux.CountPointDescription = ENTRY(2,tt-epc.val-parameter,";") /* Local Embarque    */.
         END.
    END.

    /* Localiza‡Æo de Entrega do Cliente */
    IF AVAIL emitente
    AND (emitente.cgc          <> nota-fiscal.cgc          OR
         emitente.ins-estadual <> nota-fiscal.ins-estadual OR
         emitente.endereco     <> nota-fiscal.endereco     OR
         emitente.bairro       <> nota-fiscal.bairro       OR
         emitente.cidade       <> nota-fiscal.cidade       OR
         emitente.estado       <> nota-fiscal.estado       OR
         emitente.pais         <> nota-fiscal.pais         OR
         emitente.cep          <> nota-fiscal.cep)
    AND nota-fiscal.endereco <> "" THEN DO:
         
       ASSIGN ttInvoiceDocument.LocationTaxID      = nota-fiscal.cgc
              ttInvoiceDocument.LocationStateTaxID = CAPS(nota-fiscal.ins-estadual)
              ttInvoiceDocument.LocationStateTaxID = &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &THEN 
                                                      IF emitente.cod-inscr-inss <> "" AND emitente.natureza = 1 THEN emitente.cod-inscr-inss ELSE CAPS(nota-fiscal.ins-estadual)
                                                     &ELSE 
                                                      IF num-entries(emitente.char-2,chr(10)) > 1 AND entry(2,emitente.char-2,chr(10)) <> "" AND emitente.natureza = 1 THEN entry(2,emitente.char-2,chr(10)) 
                                                        ELSE CAPS(nota-fiscal.ins-estadual)
                                                     &ENDIF
              ttInvoiceDocument.Address            = nota-fiscal.endereco
              ttInvoiceDocument.DistrictName       = trim(nota-fiscal.bairro)
              ttInvoiceDocument.CityName           = nota-fiscal.cidade
              ttInvoiceDocumentAux.StateCode       = nota-fiscal.estado
              ttInvoiceDocument.CountryName        = nota-fiscal.pais
              ttInvoiceDocumentAux.ZipCode         = IF  nota-fiscal.cep <> "" THEN (FILL("0", 8 - LENGTH(nota-fiscal.cep)) + string(nota-fiscal.cep) ) ELSE nota-fiscal.cep.

    END.
    ELSE DO:
         IF AVAIL emitente 
         AND (emitente.cgc          <> nota-fiscal.cgc          OR
              emitente.ins-estadual <> nota-fiscal.ins-estadual OR
              emitente.endereco     <> nota-fiscal.endereco     OR
              emitente.bairro       <> nota-fiscal.bairro       OR
              emitente.cidade       <> nota-fiscal.cidade       OR
              emitente.estado       <> nota-fiscal.estado       OR
              emitente.pais         <> nota-fiscal.pais         OR
              emitente.cep          <> nota-fiscal.cep)         THEN
         
             ASSIGN ttInvoiceDocument.LocationTaxID      = emitente.cgc
                    ttInvoiceDocument.LocationStateTaxID = CAPS(emitente.ins-estadual)
                    ttInvoiceDocument.LocationStateTaxID = &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &THEN 
                                                            IF emitente.cod-inscr-inss <> "" AND emitente.natureza = 1 THEN emitente.cod-inscr-inss ELSE CAPS(emitente.ins-estadual)
                                                           &ELSE
                                                            IF num-entries(emitente.char-2,chr(10)) > 1 AND entry(2,emitente.char-2,chr(10)) <> "" AND emitente.natureza = 1 THEN entry(2,emitente.char-2,chr(10)) 
                                                               ELSE CAPS(emitente.ins-estadual)
                                                           &ENDIF
                    ttInvoiceDocument.Address            = emitente.endereco
                    ttInvoiceDocument.DistrictName       = emitente.bairro
                    ttInvoiceDocument.CityName           = emitente.cidade
                    ttInvoiceDocumentAux.StateCode       = emitente.estado
                    ttInvoiceDocument.CountryName        = emitente.pais
                    ttInvoiceDocumentAux.ZipCode         = IF  emitente.cep <> "" THEN (FILL("0", 8 - LENGTH(emitente.cep)) + string(emitente.cep) ) ELSE emitente.cep.

    END.
        
    IF  estabelec.estado = "PR"
    AND ttInvoiceDocument.LocationStateTaxID = "ISENTO":U
    AND NOT emitente.contrib-icms
    AND (   emitente.natureza = 1
         OR emitente.natureza = 2 ) THEN
        ASSIGN ttInvoiceDocument.LocationStateTaxID = "".

    IF ttInvoiceDocument.Address <> ? THEN DO:
        RUN pi-trata-endereco IN h-cdapi704 (INPUT ttInvoiceDocument.Address, OUTPUT c-rua, OUTPUT c-nro, OUTPUT c-comp).

        ASSIGN ttInvoiceDocumentAux.StreetAddress_04     = c-rua
               ttInvoiceDocumentAux.AddressNumber_04     = c-nro
               ttInvoiceDocumentAux.AddressSupplement_04 = SUBSTRING(c-comp,1,60).
    END.
    /* Localiza‡Æo de Entrega do Cliente */
    /* IF  ttInvoiceDocument.CountryName = "Brasil":U THEN DO: */ /* NÆo deve-se restringir …s cidades nacionais */

        FOR FIRST cidade FIELDS(&IF '{&BF_DIS_VERSAO_EMS}' >= "2.07":U &THEN cdn-munpio-ibge &ELSE int-2 &ENDIF) 
            WHERE cidade.cidade = ttInvoiceDocument.CityName    
            AND   cidade.estado = ttInvoiceDocumentAux.StateCode 
            AND   cidade.pais   = ttInvoiceDocument.CountryName NO-LOCK: 
        END.

        FOR FIRST unid-feder FIELDS (&if '{&bf_dis_versao_ems}' >= '2.07':U &then cod-uf-ibge &else char-1 &ENDIF) NO-LOCK
            WHERE unid-feder.pais   = ttInvoiceDocument.CountryName   
            AND   unid-feder.estado = ttInvoiceDocumentAux.StateCode: 
        END.

        ASSIGN ttInvoiceDocumentAux.CityId_02           = &IF '{&BF_DIS_VERSAO_EMS}' >= "2.07":U &THEN 
                                                           cidade.cdn-munpio-ibge 
                                                         &ELSE cidade.int-2 &ENDIF WHEN AVAIL cidade
              ttInvoiceDocumentAux.StateId             = &IF '{&BF_DIS_VERSAO_EMS}' >= "2.07":U &THEN 
                                                           int(unid-feder.cod-uf-ibge) 
                                                         &ELSE int(substring(unid-feder.char-1,1,2)) &ENDIF WHEN AVAIL unid-feder.
    /* END.
    ELSE  */
    IF   ttInvoiceDocumentAux.CityId_02 = 0 THEN
         ASSIGN ttInvoiceDocumentAux.CityId_02 = 9999999
                ttInvoiceDocumentAux.StateId   = 99
                ttInvoiceDocument.CityName     = "Exterior":U.

    IF  AVAIL emitente THEN DO: /* Informacoes do Destinatario */

        ASSIGN ttInvoiceDocumentAux.LocationTaxID_01       = IF  (emitente.pais <> "Brasil" AND l-nfe) THEN "00000000000000"
                                                             ELSE emitente.cgc /* Pessoa Juridica */
               ttInvoiceDocumentAux.LocationStateTaxID_01  = CAPS(emitente.ins-estadual)
               ttInvoiceDocumentAux.LocationStateTaxID_01  = &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &THEN 
                                                              IF emitente.cod-inscr-inss <> "" AND emitente.natureza = 1 THEN emitente.cod-inscr-inss ELSE CAPS(emitente.ins-estadual)
                                                             &ELSE
                                                               IF num-entries(emitente.char-2,chr(10)) > 1 AND entry(2,emitente.char-2,chr(10)) <> "" AND emitente.natureza = 1 THEN entry(2,emitente.char-2,chr(10)) 
                                                                ELSE CAPS(emitente.ins-estadual)
                                                             &ENDIF
               ttInvoiceDocumentAux.Address_01             = emitente.endereco
               ttInvoiceDocumentAux.DistrictName_01        = trim(emitente.bairro)
               ttInvoiceDocumentAux.CityName_01            = emitente.cidade
               ttInvoiceDocumentAux.StateCode_01           = emitente.estado
               ttInvoiceDocumentAux.CountryName_01         = emitente.pais
               ttInvoiceDocumentAux.ZipCode_01             = IF  emitente.cep <> "" THEN (FILL("0", 8 - LENGTH(emitente.cep)) + string(emitente.cep) ) ELSE emitente.cep.
    
        IF  estabelec.estado = "PR"
        AND ttInvoiceDocumentAux.LocationStateTaxID_01 = "isento":U
        AND NOT emitente.contrib-icms
        AND (   emitente.natureza = 1
             OR emitente.natureza = 2 ) THEN
            ASSIGN ttInvoiceDocumentAux.LocationStateTaxID_01 = "".

        RUN pi-trata-endereco IN h-cdapi704 (INPUT ttInvoiceDocumentAux.Address_01, OUTPUT c-rua, OUTPUT c-nro, OUTPUT c-comp).

        ASSIGN ttInvoiceDocumentAux.StreetAddress_01     = c-rua
               ttInvoiceDocumentAux.AddressNumber_01     = c-nro
               ttInvoiceDocumentAux.AddressSupplement_01 = SUBSTRING(c-comp,1,60).

        /* IF  ttInvoiceDocumentAux.CountryName_01 = "Brasil":U THEN DO: */

            FOR FIRST cidade FIELDS(&IF '{&BF_DIS_VERSAO_EMS}' >= "2.07":U &THEN cdn-munpio-ibge &ELSE int-2 &ENDIF) 
                WHERE cidade.cidade = emitente.cidade 
                AND   cidade.estado = emitente.estado 
                AND   cidade.pais   = emitente.pais   NO-LOCK: 
            END.

            FOR FIRST unid-feder FIELDS (&if '{&bf_dis_versao_ems}' >= '2.07':U &then cod-uf-ibge &else char-1 &ENDIF) NO-LOCK
                WHERE unid-feder.pais   = emitente.pais
                AND  unid-feder.estado = emitente.estado:
            END.

            ASSIGN ttInvoiceDocumentAux.CityId_01  = &IF '{&BF_DIS_VERSAO_EMS}' >= "2.07":U &THEN 
                                                          cidade.cdn-munpio-ibge 
                                                    &ELSE cidade.int-2 &ENDIF WHEN AVAIL cidade
                   ttInvoiceDocumentAux.StateId_01 = &IF '{&BF_DIS_VERSAO_EMS}' >= "2.07":U &THEN 
                                                          int(unid-feder.cod-uf-ibge) 
                                                    &ELSE int(substring(unid-feder.char-1,1,2)) &ENDIF WHEN AVAIL unid-feder.
        /* END.
        ELSE */
        IF  ttInvoiceDocumentAux.CityId_01 = 0 THEN
           ASSIGN ttInvoiceDocumentAux.CityId_01   = 9999999
                  ttInvoiceDocumentAux.StateId_01  = 99
                  ttInvoiceDocumentAux.CityName_01 = "Exterior":U.
     
    END.

    /* Localiza»’o de Cobran»a do Cliente */
    IF AVAIL emitente THEN DO:

        ASSIGN ttInvoiceDocument.LocationTaxID_00      = IF  (emitente.pais <> "Brasil" AND l-nfe) THEN "00000000000000" ELSE emitente.cgc-cob
               ttInvoiceDocument.LocationStateTaxID_00 = CAPS(emitente.ins-est-cob)
               ttInvoiceDocument.Address_00            = emitente.endereco-cob
               ttInvoiceDocument.DistrictName_00       = trim(emitente.bairro-cob)
               ttInvoiceDocument.CityName_00           = emitente.cidade-cob
               ttInvoiceDocumentAux.StateCode_00       = emitente.estado-cob
               ttInvoiceDocument.CountryName_00        = emitente.pais-cob
               ttInvoiceDocumentAux.ZipCode_00         = IF  emitente.cep-cob <> "" THEN (FILL("0", 8 - LENGTH(emitente.cep-cob)) + string(emitente.cep-cob) ) ELSE emitente.cep-cob
               ttInvoiceDocument.ContactName           = emitente.contato[1]
               ttInvoiceDocumentAux.PhoneNumber        = emitente.telefone[1]
               ttInvoiceDocument.EmailAddress          = emitente.e-mail
               ttInvoiceDocument.CustomerCollectionID  = emitente.end-cobranca. 

                IF ttInvoiceDocument.ContactName = ? OR ttInvoiceDocument.ContactName = "" THEN DO:
                   {utp/ut-liter.i "NÆo Informado" *}
                   ASSIGN ttInvoiceDocument.ContactName = RETURN-VALUE.
                END.
                
                RUN pi-trata-endereco IN h-cdapi704 (INPUT ttInvoiceDocument.Address_00, OUTPUT c-rua, OUTPUT c-nro, OUTPUT c-comp).
            
        ASSIGN ttInvoiceDocumentAux.StreetAddress_00     = c-rua
               ttInvoiceDocumentAux.AddressNumber_00     = c-nro
               ttInvoiceDocumentAux.AddressSupplement_00 = SUBSTRING(c-comp,1,60).   

        IF  ttInvoiceDocument.CountryName_00 <> "Brasil":U THEN
            ASSIGN ttInvoiceDocument.CityName_00 = "Exterior".
    END.

    /* Estabelecimento */
    ASSIGN ttInvoiceDocument.SiteID = nota-fiscal.cod-estabel.
    IF AVAIL estabelec THEN DO:

       ASSIGN ttInvoiceDocument.SiteDescription = estabelec.nome.
       FOR FIRST emitente NO-LOCK 
           WHERE emitente.cod-emitente = estabelec.cod-emitente: END.
       IF AVAIL emitente THEN  
          ASSIGN ttInvoiceDocument.SiteShortName      = emitente.nome-abrev
                 ttInvoiceDocument.SiteTaxID          = emitente.cgc.
          
          ASSIGN ttInvoiceDocument.SiteTaxID           = estabelec.cgc
                 ttInvoiceDocumentAux.SiteStateTaxID   = estabelec.ins-estadual
                 ttInvoiceDocumentAux.SiteAddress      = estabelec.endereco
                 ttInvoiceDocumentAux.SiteDistrictName = trim(estabelec.bairro)
                 ttInvoiceDocumentAux.SiteCityName     = estabelec.cidade
                 ttInvoiceDocumentAux.SiteStateCode    = estabelec.estado
                 ttInvoiceDocumentAux.SiteCountryName  = estabelec.pais
                 ttInvoiceDocumentAux.SiteZipCode      = IF  estabelec.cep <> 0 THEN FILL("0", 8 - LENGTH(string(estabelec.cep))) + string(estabelec.cep) ELSE string(estabelec.cep)
                 ttInvoiceDocumentAux.SitePhoneNumber  = emitente.telefone[1] WHEN AVAIL emitente
                 ttInvoiceDocumentAux.EnvironmentID    = int(substring(estabelec.char-1,168,1))
                 ttInvoiceDocumentAux.ProcessIssue     = 0
                 ttInvoiceDocumentAux.ProcessVersion   = STRING({&bf_dis_versao_ems}).

                &IF "{&BF_DIS_VERSAO_EMS}" >= "2.08" &THEN
                  FIND FIRST bf-estabelec WHERE bf-estabelec.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.
                  IF AVAIL bf-estabelec THEN DO:
                      FIND FIRST bf-emitente WHERE bf-emitente.cgc = bf-estabelec.cgc NO-LOCK NO-ERROR.
                      IF AVAIL bf-emitente THEN DO:
                          ASSIGN ttInvoiceDocumentAux.CustomerID_00    = bf-emitente.cod-emitente.
                      END.
                  END.
                &ENDIF

           RUN pi-trata-endereco IN h-cdapi704 (INPUT ttInvoiceDocumentAux.SiteAddress, OUTPUT c-rua, OUTPUT c-nro, OUTPUT c-comp).
          
           ASSIGN ttInvoiceDocumentAux.SiteStreetAddress     = c-rua
                  ttInvoiceDocumentAux.SiteAddressNumber     = c-nro
                  ttInvoiceDocumentAux.SiteAddressSupplement = SUBSTRING(c-comp,1,60).
      
           /* IF ttInvoiceDocumentAux.SiteCountryName = "Brasil":U THEN DO: */
        
              FOR FIRST cidade FIELDS(&IF '{&BF_DIS_VERSAO_EMS}' >= "2.07":U &THEN cdn-munpio-ibge &ELSE int-2 &ENDIF) WHERE
                        cidade.cidade = estabelec.cidade AND 
                        cidade.estado = estabelec.estado AND
                        cidade.pais   = estabelec.pais   NO-LOCK: END.

              FOR FIRST unid-feder FIELDS (&if '{&bf_dis_versao_ems}' >= '2.07':U &then cod-uf-ibge &else char-1 &endif) NO-LOCK
                  WHERE unid-feder.pais   = estabelec.pais
                    AND unid-feder.estado = estabelec.estado: END.

              ASSIGN ttInvoiceDocumentAux.SiteCityId  = &if '{&bf_dis_versao_ems}' >= '2.07':U  &then 
                                                             cidade.cdn-munpio-ibge 
                                                        &else cidade.int-2 &endif WHEN AVAIL cidade
                     ttInvoiceDocumentAux.SiteStateId = &if '{&bf_dis_versao_ems}' >= '2.07':U  &then 
                                                             int(unid-feder.cod-uf-ibge)
                                                        &else int(substring(unid-feder.char-1,1,2)) &endif WHEN AVAIL unid-feder.
           /* END.
           ELSE DO: */
           IF  ttInvoiceDocumentAux.SiteCityId = 0 THEN DO:
                ASSIGN ttInvoiceDocumentAux.SiteCityId   = 9999999
                       ttInvoiceDocumentAux.SiteStateId  = 99
                       ttInvoiceDocumentAux.SiteCityName = "Exterior":U.
           END.
    END.

    /* Transportador de Despacho */
    IF AVAIL transporte THEN DO:
   
        ASSIGN ttInvoiceDocument.CarrierID       = transporte.cod-transp
               ttInvoiceDocument.CarrierName     = transporte.nome-abrev   
               ttInvoiceDocumentAux.ShippingMethod = transporte.via-transp
               ttInvoiceDocument.ContactName_00  = transporte.contato
               ttInvoiceDocumentAux.PhoneNumber_00 = transporte.telefone
               ttInvoiceDocument.EmailAddress_00 = transporte.e-mail.

                   IF ttInvoiceDocument.ContactName_00 = ? OR ttInvoiceDocument.ContactName_00 = "" THEN DO:
                       {utp/ut-liter.i "NÆo Informado" *}
                       ASSIGN ttInvoiceDocument.ContactName_00 = RETURN-VALUE.
                   END.

                   ASSIGN ttInvoiceDocumentAux.CarrierTaxID      = transporte.cgc
                          ttInvoiceDocumentAux.CarrierStateTaxID = transporte.ins-estadual
                          ttInvoiceDocumentAux.CarrierFullName   = transporte.nome
                          ttInvoiceDocumentAux.Address_02        = transporte.endereco
                          ttInvoiceDocumentAux.DistrictName_02   = TRIM(transporte.bairro)
                          ttInvoiceDocumentAux.CityName_02       = transporte.cidade
                          ttInvoiceDocumentAux.StateCode_02      = CAPS(transporte.estado)
                          ttInvoiceDocumentAux.CountryName_02    = transporte.pais
                          ttInvoiceDocumentAux.ZipCode_02        = IF  transporte.cep <> "" THEN (FILL("0", 8 - LENGTH(transporte.cep)) + string(transporte.cep) ) ELSE transporte.cep.
                  &IF "{&BF_DIS_VERSAO_EMS}" >= "2.08" &THEN
                  find first emitente where emitente.cgc = transporte.cgc no-lock no-error.
                  if avail emitente then
                      assign ttInvoiceDocumentAux.CustomerID_01  = emitente.cod-emitente.
                  &ENDIF

                  RUN pi-trata-endereco IN h-cdapi704 (INPUT ttInvoiceDocumentAux.Address_02, OUTPUT c-rua, OUTPUT c-nro, OUTPUT c-comp).
                
                  ASSIGN ttInvoiceDocumentAux.StreetAddress_02    = c-rua
                         ttInvoiceDocumentAux.AddressNumber_02    = c-nro
                         ttInvoiceDocumentAux.AddressSupplement_02 = SUBSTRING(c-comp,1,60).
            
    END.

    /* Transportador de Re-despacho */
    FOR FIRST transporte FIELDS (cod-transp cgc ins-estadual nome-abrev via-transp contato telefone e-mail endereco bairro cidade estado pais cep nome) NO-LOCK 
        WHERE transporte.nome-abrev = nota-fiscal.nome-tr-red: END.
    IF AVAIL transporte THEN DO:
        ASSIGN ttInvoiceDocument.CarrierID_00      = transporte.cod-transp
               ttInvoiceDocument.CarrierName_00    = transporte.nome-abrev 
               ttInvoiceDocumentAux.ShippingMethod_00 = transporte.via-transp
               ttInvoiceDocument.ContactName_01    = transporte.contato
               ttInvoiceDocumentAux.PhoneNumber_01    = transporte.telefone
               ttInvoiceDocument.EmailAddress_01   = transporte.e-mail.

                   IF ttInvoiceDocument.ContactName_01 = ? OR ttInvoiceDocument.ContactName_01 = "" THEN DO:
                       {utp/ut-liter.i "NÆo Informado" *}
                       ASSIGN ttInvoiceDocument.ContactName_01 = RETURN-VALUE.
                   END.

                   ASSIGN ttInvoiceDocumentAux.CarrierTaxID_00      = transporte.cgc
                          ttInvoiceDocumentAux.CarrierStateTaxID_00 = transporte.ins-estadual
                          ttInvoiceDocumentAux.CarrierFullName_00   = transporte.nome
                          ttInvoiceDocumentAux.Address_03           = transporte.endereco
                          ttInvoiceDocumentAux.DistrictName_03      = TRIM(transporte.bairro)
                          ttInvoiceDocumentAux.CityName_03          = transporte.cidade
                          ttInvoiceDocumentAux.StateCode_03         = CAPS(transporte.estado)
                          ttInvoiceDocumentAux.CountryName_03       = transporte.pais
                          ttInvoiceDocumentAux.ZipCode_03           = IF  transporte.cep <> "" THEN (FILL("0", 8 - LENGTH(transporte.cep)) + string(transporte.cep) ) ELSE transporte.cep.
                          &IF "{&BF_DIS_VERSAO_EMS}" >= "2.08" &THEN
                          find emitente where emitente.cgc = transporte.cgc no-lock no-error.
                          IF avail emitente then
                              assign ttInvoiceDocumentAux.CustomerID_02 = emitente.cod-emitente.
                          &ENDIF

                  RUN pi-trata-endereco IN h-cdapi704 (INPUT ttInvoiceDocumentAux.Address_03, OUTPUT c-rua, OUTPUT c-nro, OUTPUT c-comp).
                
                  ASSIGN ttInvoiceDocumentAux.StreetAddress_03     = c-rua
                         ttInvoiceDocumentAux.AddressNumber_03     = c-nro
                         ttInvoiceDocumentAux.AddressSupplement_03 = SUBSTRING(c-comp,1,60).
    END.

    /* Nota de Frete Aut“nomo */
    IF AVAIL nota-trans THEN DO:
        ASSIGN ttInvoiceDocument.InsuranceValue            = nota-trans.vl-servico
               ttInvoiceDocumentAux.TaxPercentage          = nota-trans.aliquota-icm
               ttInvoiceDocumentAux.TaxCalculationBasis    = nota-trans.vl-bicms
               ttInvoiceDocumentAux.TaxReductionPercentage = nota-trans.perc-red-base
               ttInvoiceDocumentAux.TaxValue               = nota-trans.vl-icms
               ttInvoiceDocument.FreightResponsible        = nota-trans.ind-cobranca
               ttInvoiceDocument.MessageID_00              = nota-trans.cod-mensagem.

        /* Mensagem da Nota de Frete AutËnomo */
        FOR FIRST mensagem FIELDS (cod-mensagem texto-mensag) NO-LOCK 
            WHERE mensagem.cod-mensagem = nota-trans.cod-mensagem: END.
        IF AVAIL mensagem THEN
            ASSIGN ttInvoiceDocument.MessageDescription_00 = mensagem.texto-mensag.
    END.

    /* Vendor */
    IF l-vendor THEN DO:
        ASSIGN i-cod-cond-cli    = 0
               i-dias-base       = 0
               da-base           = ?
               de-tx-cli         = 0.

        RUN pdp/pd2023.p (INPUT  pInvoiceDocumentRowID,
                          OUTPUT i-cod-cond-cli,
                          OUTPUT i-dias-base,
                          OUTPUT da-base,
                          OUTPUT de-tx-cli).
        
        ASSIGN de-tx-cli = de-tx-cli * 100
               ttInvoiceDocument.CustomerPaymentPlanCode           = i-cod-cond-cli
               ttInvoiceDocument.GraceDaysForVendorContractClo_00  = i-dias-base
               ttInvoiceDocument.BaseDate                          = da-base
               ttInvoiceDocument.FinancialRate                     = de-tx-cli.
    END.


    /* Devolu»„es */
    FOR EACH devol-cli NO-LOCK
        WHERE devol-cli.cod-estabel = nota-fiscal.cod-estabel 
          AND devol-cli.serie       = nota-fiscal.serie       
          AND devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis:

        FOR FIRST natur-oper NO-LOCK 
            WHERE natur-oper.nat-operacao = devol-cli.nat-operacao: END.

        IF AVAIL natur-oper THEN
            &if '{&bf_dis_versao_ems}' >= '2.05':U &then
                FOR FIRST cfop-natur FIELDS(des-cfop) NO-LOCK
                    WHERE cfop-natur.cod-cfop = &if defined(bf_dis_formato_CFOP) &then natur-oper.cod-cfop &else SUBSTR(natur-oper.char-1,45,10) &endif: END.
            &else
               FOR FIRST ped-curva FIELDS(nome) NO-LOCK
                    WHERE ped-curva.it-codigo = &if defined(bf_dis_formato_CFOP) &then natur-oper.cod-cfop &else SUBSTR(natur-oper.char-1,45,10) &endif AND
                          ped-curva.vl-aberto = 620: END.
            &endif

        FOR FIRST ITEM FIELDS (desc-item) NO-LOCK 
            WHERE ITEM.it-codigo = devol-cli.it-codigo: END.

        CREATE ttDevolutionDocument.
        ASSIGN ttDevolutionDocument.DocumentSeries             = ttInvoiceDocument.DocumentSeries
               ttDevolutionDocument.DocumentNumber             = devol-cli.nro-docto
               ttDevolutionDocument.FiscalOperationCode        = devol-cli.nat-operacao
               ttDevolutionDocument.FiscalOperationDescription = &if '{&bf_dis_versao_ems}' >= '2.05':U &then 
                                                                   IF AVAIL cfop-natur THEN cfop-natur.des-cfop
                                                                      ELSE natur-oper.denominacao WHEN AVAIL natur-oper
                                                                 &else
                                                                    IF AVAIL ped-curva THEN ped-curva.nome 
                                                                      ELSE natur-oper.denominacao WHEN AVAIL natur-oper
                                                                 &endif
               ttDevolutionDocument.ItemCode                   = devol-cli.it-codigo
               ttDevolutionDocument.ItemDescription            = item.desc-item         WHEN AVAIL ITEM
               ttDevolutionDocument.ItemReferenceCode          = devol-cli.cod-refer
               ttDevolutionDocument.DevolutionDate             = devol-cli.dt-devol
               ttDevolutionDocument.DevolutionQuantity         = devol-cli.qt-devolvida
              &IF "{&BF_DIS_VERSAO_EMS}" >= "2.08" &THEN
               ttDevolutionDocument.DocumentClass              = natur-oper.especie-doc 
               ttDevolutionDocument.IsFinalConsumer            = natur-oper.consum-final
               ttDevolutionDocument.TransferOperation          = natur-oper.transf
               ttDevolutionDocument.TYPE                       = natur-oper.tipo
              &ENDIF   
               .
    END.
                                                            
    /* Duplicatas */
    FOR EACH fat-duplic NO-LOCK
        WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel 
          AND fat-duplic.serie       = nota-fiscal.serie       
          AND fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:

        FOR FIRST espec-ap FIELDS (descricao) NO-LOCK 
            WHERE espec-ap.cod-esp = fat-duplic.cod-esp: END.

        FOR FIRST tipo-rec-desp FIELDS (descricao) NO-LOCK 
            WHERE tipo-rec-desp.tp-codigo = fat-duplic.tp-receita: END.

        CREATE ttDocumentBill.
        ASSIGN ttDocumentBill.InstallmentNumber        = fat-duplic.parcela
               ttDocumentBill.BillNumber               = fat-duplic.nr-fatura
               ttDocumentBill.DocumentClassID          = fat-duplic.cod-esp
               ttDocumentBill.DocumentClassDescription = espec-ap.descricao      WHEN AVAIL espec-ap
               ttDocumentBill.RevenueCode              = fat-duplic.tp-receita
               ttDocumentBill.RevenueDescription       = tipo-rec-desp.descricao WHEN AVAIL tipo-rec-desp
               ttDocumentBill.PrintDate                = fat-duplic.dt-emissao
               ttDocumentBill.DueDate                  = fat-duplic.dt-venciment
               ttDocumentBill.DiscountValue            = fat-duplic.vl-desconto
               ttDocumentBill.InstallmentNetValue      = fat-duplic.vl-parcela
               ttDocumentBill.CommissionValue          = fat-duplic.vl-comis
               ttDocumentBill.SiteID                   = fat-duplic.cod-estabel
               ttDocumentBill.DocumentSeries           = ttInvoiceDocument.DocumentSeries.

        FOR EACH rateio-it-duplic FIELDS ( cod-estabel serie nr-fatura parcela nr-seq-fat it-codigo valor-rateio ) NO-LOCK
            WHERE rateio-it-duplic.cod-estabel = fat-duplic.cod-estabel 
              AND rateio-it-duplic.serie       = fat-duplic.serie       
              AND rateio-it-duplic.nr-fatura   = fat-duplic.nr-fatura   
              AND rateio-it-duplic.parcela     = fat-duplic.parcela:

            CREATE ttDocumentBillItem.
            ASSIGN ttDocumentBillItem.SiteID            = rateio-it-duplic.cod-estabel
                   ttDocumentBillItem.DocumentSeries    = ttInvoiceDocument.DocumentSeries
                   ttDocumentBillItem.BillNumber        = rateio-it-duplic.nr-fatura
                   ttDocumentBillItem.InstallmentNumber = rateio-it-duplic.parcela
                   ttDocumentBillItem.Sequence          = rateio-it-duplic.nr-seq-fat
                   ttDocumentBillItem.ItemCode          = rateio-it-duplic.it-codigo
                   ttDocumentBillItem.ItemValue         = rateio-it-duplic.valor-rateio.
        END.
    END.

    /* Embalagens */
    ASSIGN i-cont = 0.
    FOR EACH nota-embal NO-LOCK
        WHERE nota-embal.cod-estabel = nota-fiscal.cod-estabel 
          AND nota-embal.serie       = nota-fiscal.serie       
          AND nota-embal.nr-nota-fis = nota-fiscal.nr-nota-fis:

        FOR FIRST embalag FIELDS (embalagem) NO-LOCK 
            WHERE embalag.sigla-emb = nota-embal.sigla-emb: END.

        CREATE ttPackaging.
        ASSIGN ttPackaging.Sequence                 = i-cont + 1
               ttPackaging.PackagingID              = nota-embal.sigla-emb
               ttPackaging.PackagingDescription     = embalag.embalagem     WHEN AVAIL embalag
               ttPackaging.PackagingQuantity        = nota-embal.qt-volumes
               ttPackaging.PackagingContent         = nota-embal.desc-vol.
    END.

    /* Remitos */
    IF i-pais-impto-usuario <> 1 THEN DO:
        FOR EACH it-nota-fisc FIELDS(cod-estabel serie nr-remito) OF nota-fiscal NO-LOCK,
            EACH remito NO-LOCK
                WHERE remito.cod-estabel = it-nota-fisc.cod-estabel
                  AND remito.serie       = it-nota-fisc.serie-docum
                  AND remito.nr-remito   = it-nota-fisc.nr-remito
                  AND remito.cod-origem  = 1:

            IF NOT CAN-FIND(FIRST ttPackingSlip WHERE
                                  ttPackingSlip.SiteID            = remito.cod-estabel AND 
                                  ttPackingSlip.PackingSlipNumber = remito.nr-remito   AND
                                  ttPackingSlip.DocumentSeries    = remito.serie)      THEN DO:

                FOR FIRST loc-entr FIELDS (cgc ins-estadual endereco bairro cidade estado pais caixa-postal cep) NO-LOCK
                      WHERE loc-entr.cod-entrega = remito.cod-entrega: END.

                FOR FIRST estabelec FIELDS (nome cod-emitente char-1 ins-estadual endereco conta-pis-rec     
                                            bairro cidade estado pais cep cgc conta-fin-pag cod-estabel) NO-LOCK 
                    WHERE estabelec.cod-estabel = remito.cod-estabel: END.

                CREATE ttPackingSlip.
                ASSIGN ttPackingSlip.SiteID              = remito.cod-estabel
                       ttPackingSlip.DocumentSeries      = remito.serie
                       ttPackingSlip.PackingSlipNumber   = remito.nr-remito
                       ttPackingSlip.ShortName           = remito.nome-abrev
                       ttPackingSlip.ShipmentNumber      = remito.cdd-embarq
                       ttPackingSlip.LocationID          = remito.cod-entrega.

                IF AVAIL estabelec THEN DO:

                    FOR FIRST emitente FIELDS (nome-abrev cgc) NO-LOCK 
                        WHERE emitente.cod-emitente = estabelec.cod-emitente: END.

                        ASSIGN  ttPackingSlip.SiteDescription = estabelec.nome
                                ttPackingSlip.SiteShortName   = emitente.nome-abrev WHEN AVAIL emitente
                                ttPackingSlip.SiteTaxID       = emitente.cgc        WHEN AVAIL emitente.
                END.

                IF AVAIL loc-entr THEN
                    ASSIGN ttPackingSlip.LocationTaxID      = loc-entr.cgc
                           ttPackingSlip.LocationStateTaxID = CAPS(loc-entr.ins-estadual)
                           ttPackingSlip.Address            = loc-entr.endereco
                           ttPackingSlip.DistrictName       = trim(loc-entr.bairro)
                           ttPackingSlip.CityName           = loc-entr.cidade
                           ttPackingSlip.StateCode          = loc-entr.estado
                           ttPackingSlip.CountryName        = loc-entr.pais
                           ttPackingSlip.ZipCode            = IF  loc-entr.cep <> "" THEN (FILL("0", 8 - LENGTH(loc-entr.cep)) + string(loc-entr.cep) ) ELSE loc-entr.cep.
            END.
        END.
    END.
    
    /* Representantes */
    IF CAN-FIND (FIRST fat-repre WHERE fat-repre.cod-estabel = nota-fiscal.cod-estabel  AND
                                       fat-repre.serie       = nota-fiscal.serie        AND
                                       fat-repre.nr-fatura   = nota-fiscal.nr-fatura    AND
                                       fat-repre.nome-ab-rep = nota-fiscal.no-ab-reppr) THEN DO:
        FOR EACH fat-repre NO-LOCK
            WHERE fat-repre.cod-estabel = nota-fiscal.cod-estabel 
              AND fat-repre.serie       = nota-fiscal.serie       
              AND fat-repre.nr-fatura   = nota-fiscal.nr-fatura   :

            FOR FIRST emitente FIELDS (cgc cod-rep) NO-LOCK 
                WHERE emitente.nome-abrev = fat-repre.nome-ab-rep: END.

            CREATE ttRepresentative.
            ASSIGN ttRepresentative.RepresentativeShortName       = fat-repre.nome-ab-rep
                   ttRepresentative.RepresentativeTaxID           = emitente.cgc          WHEN AVAIL emitente
                   ttRepresentative.RepresentativeID              = emitente.cod-rep      WHEN AVAIL emitente
                   ttRepresentative.IsMainRepresentative          = IF fat-repre.nome-ab-rep = nota-fiscal.no-ab-reppri THEN YES ELSE NO
                   ttRepresentative.CommissionPercentage          = fat-repre.perc-comis
                   ttRepresentative.PrintingCommissionPercentage  = fat-repre.comis-emis
                   ttRepresentative.ClassifierCode                = fat-repre.cod-classificador.
        END.
    END.
    ELSE DO:  /* Representante principal default */
        FOR FIRST emitente FIELDS (cgc cod-rep) NO-LOCK 
            WHERE emitente.nome-abrev = nota-fiscal.no-ab-reppri: END.

        CREATE ttRepresentative.
        ASSIGN ttRepresentative.RepresentativeShortName       = nota-fiscal.no-ab-reppri
               ttRepresentative.RepresentativeTaxID           = emitente.cgc             WHEN AVAIL emitente
               ttRepresentative.RepresentativeID              = emitente.cod-rep         WHEN AVAIL emitente
               ttRepresentative.IsMainRepresentative          = YES.
    END.

    /* Codi»„es de Pagamento */
    IF nota-fiscal.cod-cond-pag = 0 THEN DO:

        FOR FIRST ped-venda NO-LOCK 
            WHERE ped-venda.nome-abrev = nota-fiscal.nome-abrev 
              AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli: END.
        IF AVAIL ped-venda THEN DO:
            
            FOR EACH cond-ped WHERE cond-ped.nr-pedido = ped-venda.nr-pedido NO-LOCK:

                CREATE ttTerm.
                ASSIGN ttTerm.TermSequence          = cond-ped.nr-sequencia
                       ttTerm.TermComments          = cond-ped.observacoes
                       ttTerm.TermDueDate           = cond-ped.data-pagto
                       ttTerm.TermPaymentPercentage = cond-ped.perc-pagto
                       ttTerm.TermAmount            = cond-ped.vl-pagto
                       ttTerm.TermDueDays           = cond-ped.nr-dias-venc
                       ttTerm.TermDueCode           = cond-ped.cod-vencto.
            END.
        END.
    END.
  
    /*Modulo de Importa‡Æo Implantado*/
    IF param-global.modulo-07 THEN DO:

         /*--- Informa‡äes DI ---*/
         FOR FIRST embarque-imp
             WHERE embarque-imp.cod-estabel = nota-fiscal.cod-estabel
               AND embarque-imp.embarque    = TRIM(SUBSTR(nota-fiscal.char-1,1,20)) NO-LOCK:

              CREATE ttImportDocument.
              ASSIGN ttImportDocument.ImportDocumentNumber = embarque-imp.declaracao-import
                     ttImportDocument.ImportDocumentDate   = embarque-imp.data-di.

              ASSIGN ttImportDocument.ImportDocumentNumber = REPLACE(ttImportDocument.ImportDocumentNumber,"-","")
                     ttImportDocument.ImportDocumentNumber = REPLACE(ttImportDocument.ImportDocumentNumber,".","")
                     ttImportDocument.ImportDocumentNumber = REPLACE(ttImportDocument.ImportDocumentNumber,"/","")
                     ttImportDocument.ImportDocumentNumber = REPLACE(ttImportDocument.ImportDocumentNumber,"~\","")
                     ttImportDocument.ImportDocumentNumber = REPLACE(ttImportDocument.ImportDocumentNumber,",","").

              FOR FIRST ordens-embarque NO-LOCK
                   WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                     AND ordens-embarque.embarque    = embarque-imp.embarque: END.
              IF AVAIL ordens-embarque THEN

              FOR FIRST ordem-compra NO-LOCK
                   WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem: END.
              IF AVAIL ordem-compra THEN

              FOR FIRST processo-imp NO-LOCK
                   WHERE processo-imp.num-pedido = ordem-compra.num-pedido: END.
              IF AVAIL processo-imp THEN

              FOR FIRST itinerario NO-LOCK
                   WHERE itinerario.cod-itiner = processo-imp.cod-itiner: END.
              IF AVAIL itinerario THEN

              FOR FIRST historico-embarque NO-LOCK
                     WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                       AND historico-embarque.embarque      = embarque-imp.embarque
                       AND historico-embarque.cod-itiner    = itinerario.cod-itiner
                       AND historico-embarque.cod-pto-contr = itinerario.pto-desembarque:

              IF historico-embarque.dt-efetiva <> ? THEN
                  ASSIGN ttImportDocument.ImportDocumentClearanceDate = historico-embarque.dt-efetiva.
              ELSE
                  ASSIGN ttImportDocument.ImportDocumentClearanceDate = historico-embarque.dt-ult-prev.

              END.

              FOR FIRST pto-contr NO-LOCK
                  WHERE pto-contr.cod-pto-contr = itinerario.pto-desembarque:
                  ASSIGN ttImportDocument.ImportDocumentClearanceLocation = pto-contr.descricao
                         ttImportDocument.ImportDocumentClearanceState    = &if '{&bf_dis_versao_ems}' >= '2.07':U &then
                                                                            pto-contr.cod-uf
                                                                            &ELSE
                                                                            substring(pto-contr.char-1,1,2)
                                                                            &ENDIF  .
              END.

              ASSIGN ttImportDocument.ImportDocumentExporterCode = STRING(processo-imp.cod-exportador).
         END.
    END.

    /* Itens */
    RUN pi-item.

    /* Impostos do Brasil: Totais da Nota */ 
    IF i-pais-impto-usuario = 1 THEN DO:

        CREATE ttDocumentTax.  /* ICMS */
        ASSIGN ttDocumentTax.TaxCode                    =  1
               ttDocumentTax.TaxDescription             = "ICMS":U
               ttDocumentTax.TaxDiscountPercentage      =  nota-fiscal.per-des-icms
               ttDocumentTax.TaxValue                   = d-total-icms          WHEN d-total-icms > 0 
               ttDocumentTax.TaxCalculationBasis        = d-total-base-icms     WHEN d-total-base-icms > 0
               ttDocumentTax.TributarySubstitutionBasis = d-total-base-icms-sub WHEN d-total-base-icms-sub > 0    
               ttDocumentTax.TributarySubstitutionValue = d-total-icms-sub      WHEN d-total-icms-sub  > 0.   

        CREATE ttDocumentTax.  /* IPI */
        ASSIGN ttDocumentTax.TaxCode               =  2
               ttDocumentTax.TaxDescription        = "IPI":U
               ttDocumentTax.TaxValue              = d-total-ipi      WHEN d-total-ipi > 0
               ttDocumentTax.TaxCalculationBasis   = d-total-base-ipi WHEN d-total-base-ipi > 0.

        IF d-total-iss > 0 THEN DO:
            CREATE ttDocumentTax.  /* ISS */
            ASSIGN ttDocumentTax.TaxCode               =  3
                   ttDocumentTax.TaxDescription        = "ISS":U
                   ttDocumentTax.TaxValue              = d-total-iss      WHEN d-total-iss  > 0 
                   ttDocumentTax.TaxCalculationBasis   = d-total-base-iss WHEN d-total-base-iss > 0.   
        END.

        IF d-total-csll > 0 THEN DO:
            CREATE ttDocumentTax.  /* CSLL */
            ASSIGN ttDocumentTax.TaxCode               =  4
                   ttDocumentTax.TaxDescription        = "CSLL":U
                   ttDocumentTax.TaxValue              = d-total-csll      WHEN d-total-csll > 0.   
        END.

        IF d-total-pis > 0 OR d-total-pis-ret > 0 THEN DO:
            CREATE ttDocumentTax.  /* PIS */
            ASSIGN ttDocumentTax.TaxCode               =  5
                   ttDocumentTax.TaxDescription        = "PIS":U
                   ttDocumentTax.TaxValue              = d-total-pis       WHEN d-total-pis  > 0 
                   ttDocumentTax.TaxCalculationBasis   = d-total-base-pis  WHEN d-total-base-pis > 0
                   ttDocumentTax.TaxPercentage         = de-taxa-pis * 100 WHEN de-taxa-pis > 0
                   ttDocumentTax.TaxRetentionValue     = d-total-pis-ret   WHEN d-total-pis-ret > 0.   
        END.

        IF d-total-cofins > 0 OR d-total-cofins-ret > 0 THEN DO:
            CREATE ttDocumentTax.  /* COFINS */
            ASSIGN ttDocumentTax.TaxCode               =  6
                   ttDocumentTax.TaxDescription        = "COFINS":U
                   ttDocumentTax.TaxValue              = d-total-cofins       WHEN d-total-cofins  > 0 
                   ttDocumentTax.TaxCalculationBasis   = d-total-base-cofins  WHEN d-total-base-cofins > 0
                   ttDocumentTax.TaxPercentage         = de-taxa-cofins * 100 WHEN de-taxa-cofins > 0
                   ttDocumentTax.TaxRetentionValue     = d-total-cofins-ret   WHEN d-total-cofins-ret > 0.   
        END.

        IF d-total-vl-ir-adic > 0 THEN DO:
            CREATE ttDocumentTax.  /* INSS */
            ASSIGN ttDocumentTax.TaxCode               = 7
                   ttDocumentTax.TaxDescription        = "INSS":U
                   ttDocumentTax.TaxCalculationBasis   = d-total-base-vl-ir-adic WHEN d-total-base-vl-ir-adic > 0
                   ttDocumentTax.TaxValue              = d-total-vl-ir-adic      WHEN d-total-vl-ir-adic > 0.   
        END.

        IF d-total-vl-irf-it > 0 THEN DO:
            CREATE ttDocumentTax.  /* IRF */
            ASSIGN ttDocumentTax.TaxCode               = 8
                   ttDocumentTax.TaxDescription        = "IRF":U
                   ttDocumentTax.TaxCalculationBasis   = d-total-base-vl-irf-it WHEN d-total-base-vl-irf-it > 0
                   ttDocumentTax.TaxValue              = d-total-vl-irf-it      WHEN d-total-vl-irf-it > 0.   
        END.

        IF d-total-ii > 0 THEN DO:
            CREATE ttDocumentTax.  /* II */
            ASSIGN ttDocumentTax.TaxCode               = 9
                   ttDocumentTax.TaxDescription        = "II":U
                   ttDocumentTax.TaxCalculationBasis   = d-total-base-ii WHEN d-total-base-ii > 0
                   ttDocumentTax.TaxValue              = d-total-ii      WHEN d-total-ii > 0.  
        END.
    
    END.
    IF VALID-HANDLE(h-cdapi704) THEN DO:
       DELETE PROCEDURE h-cdapi704.
       ASSIGN h-cdapi704 = ?.
    END.

    IF VALID-HANDLE(h-cdapi995) THEN DO:
        RUN pi-finalizar in h-cdapi995.
        ASSIGN h-cdapi995 = ?.
    END.

    IF VALID-HANDLE(h-cd9500) THEN DO:
       DELETE PROCEDURE h-cd9500.
       ASSIGN h-cd9500 = ?.
    END.
    /*** EPC - Trata Informa‡äes Adicionais ***/
    IF  CAN-FIND(FIRST funcao
                 WHERE funcao.cd-funcao = "spp-nfe"
                 AND   funcao.ativo     ) THEN DO:
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "TrataInfAdicionaisNfe":U
               tt-epc.cod-parameter = "rowid-nota-fiscal":U
               tt-epc.val-parameter =  string(ROWID (nota-fiscal)).
        
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "TrataInfAdicionaisNfe":U
               tt-epc.cod-parameter = "handle-object":U
               tt-epc.val-parameter =  string(THIS-PROCEDURE).

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "TrataInfAdicionaisNfe":U
               tt-epc.cod-parameter = "ttDocumentItemTax":U
               tt-epc.val-parameter =  STRING(TEMP-TABLE ttDocumentItemTax:HANDLE).

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "TrataInfAdicionaisNfe":U
               tt-epc.cod-parameter = "ttDocumentTax":U
               tt-epc.val-parameter =  STRING(TEMP-TABLE ttDocumentTax:HANDLE).

        {include/i-epc201.i "TrataInfAdicionaisNfe"}
    END.
    /*** EPC - Trata Informa‡äes Adicionais ***/

    /*** EPC - Trata Descri»’o Item ***/
    IF  CAN-FIND(FIRST funcao
                 WHERE funcao.cd-funcao = "spp-nfe"
                 AND   funcao.ativo     ) THEN DO:
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "TrataDescricaoItemNfe":U
               tt-epc.cod-parameter = "rowid-nota-fiscal":U
               tt-epc.val-parameter =  string(ROWID(nota-fiscal)).

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "TrataDescricaoItemNfe":U
               tt-epc.cod-parameter = "ttDocumentItem":U
               tt-epc.val-parameter =  STRING(TEMP-TABLE ttDocumentItem:HANDLE).
    
        {include/i-epc201.i "TrataDescricaoItemNfe"}
    end.

    /*** EPC - Trata Descri»’o Item ***/

    /* Redespacho e Simul Frete, testa se o FRT Embarcador est  ativo no cd0101 */
    &IF '{&BF_DIS_VERSAO_EMS}' >= '2.08' &THEN
    
/*         if  not valid-handle(h-boad123a) then                       */
/*             run adbo/boad123a.p persistent set h-boad123a.          */
/*                                                                     */
/*         run openQueryStatic in h-boad123a ('main').                 */
/*         run goToKey         in h-boad123a ('SPP_TOTVSGFE').         */
/*         if  return-value = "NOK" then                               */
/*             assign l-func-totvsgfe = no.                            */
/*         else                                                        */
/*             run getLogField in h-boad123a (input  'ativo',          */
/*                                            output l-func-totvsgfe). */
        IF l-func-totvsgfe THEN DO:
            FIND FIRST tab-generica
                WHERE tab-generica.utilizacao = "SETUP" NO-LOCK NO-ERROR.
            IF AVAIL tab-generica AND SUBSTRING(tab-generica.char-2,120,1) = "1" THEN
                RUN adapters/xml/trp/axstr005redes.p (INPUT nota-fiscal.cod-estabel,  
                                                      INPUT nota-fiscal.serie,      
                                                      INPUT nota-fiscal.nr-nota-fis,
                                                      INPUT-OUTPUT TABLE ttRedispatchCarrier,
                                                      INPUT-OUTPUT TABLE ttFreightSimulation,
                                                      INPUT-OUTPUT TABLE ttFreightInformations).
        END.

         IF VALID-HANDLE (h-boad123a) THEN
            RUN destroy IN h-boad123a.
    &ENDIF

    RUN PIUpsert ( INPUT cTranAction,                             /* add / upd                         */
                   INPUT cTranEvent,                              /* UpdateDocument/UndoUpdateDocument */
                   INPUT  TABLE ttInvoiceDocument,                /* Dados da nota fiscal              */
                   INPUT  TABLE ttInvoiceDocumentAux,             /* Dados da nota fiscal              */
                   INPUT  TABLE ttDevolutionDocument,             /* Devolu»„es                        */
                   INPUT  TABLE ttDiscount,                       /* Descontos do Item                 */
                   INPUT  TABLE ttDiscountTableValue,             /* Valores dos Descontos             */
                   INPUT  TABLE ttDocumentBill,                   /* Duplicatas                        */
                   INPUT  TABLE ttDocumentBillItem,               /* Rateio do Item na Duplicata       */
                   INPUT  TABLE ttDocumentItem,                   /* Itens                             */
                   INPUT  TABLE ttDocumentItemTax,                /* Impostos do Item                  */
                   INPUT  TABLE ttBusinessUnit,                   /* Unidades de Neg¢cio               */
                   INPUT  TABLE ttDocumentTax,                    /* Impostos do Brasil                */
                   INPUT  TABLE ttIssuedLocation,                 /* Localiza»„es de Sa­da no Estoque  */
                   INPUT  TABLE ttTagCode,                        /* Etiquetas do Item                 */
                   INPUT  TABLE ttPackaging,                      /* Embalagens                        */
                   INPUT  TABLE ttPackingSlip,                    /* Remitos                           */
                   &IF "{&BF_DIS_VERSAO_EMS}" >= "2.08" &THEN                                            
                   INPUT  TABLE ttRedispatchCarrier,              /* Redespacho  */                      
                   INPUT  TABLE ttFreightSimulation,              /* Simul Frete  */                     
                   INPUT  TABLE ttFreightInformations,            /* Informa‡äes Adicionais de Frete   */
                   &ENDIF                                                                                
                   INPUT  TABLE ttRepresentative,                 /* Representantes                    */
                   INPUT  TABLE ttTerm,                           /* Condi»„es de Pagamento            */
                   INPUT  TABLE ttImportDocument,                 /* Documento Importa‡Æo              */
                   INPUT  TABLE ttImportDocumentAdd,              /* Documento Importa‡Æo Add          */
                   INPUT  TABLE ttDocumentItemVehicle,            /* Ve¡culos                          */
                   INPUT  TABLE ttDocumentItemMedicine,           /* Medicamentos                      */
                   INPUT  TABLE ttDocumentItemFuel,               /* Combust¡veis                      */
                   INPUT  TABLE ttInvoiceDocumentAddInformation,  /* Adicionais                        */
                   INPUT  TABLE ttAddInformationTaxPayer,         /* Uso Livre Contribuinte            */
                   INPUT  TABLE ttAddInformationTaxComment,       /* Uso Livre Fisco                   */
                   INPUT  TABLE ttReferencedProcess,              /* Processo Referenciado             */
                   OUTPUT TABLE tt_log_erro ).

END. /*  nota fiscal  */

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */


END PROCEDURE.


PROCEDURE pi-item:
    
DEF VAR c-desc-prod                  AS CHARACTER FORMAT "x(60)"  NO-UNDO.
DEF VAR c-info-onu                   AS CHARACTER FORMAT "x(256)" NO-UNDO.
DEF VAR i-num-ord-import             AS INTEGER                   NO-UNDO.
DEF VAR i-parcela                    AS INTEGER                   NO-UNDO.
DEF VAR deVolumeRatEmbal             AS DEC                       NO-UNDO.
DEF VAR deVolumeEmbal                AS DEC                       NO-UNDO.
DEF VAR deVolumeItem                 AS DEC                       NO-UNDO.
DEF VAR dePercRateio                 AS DEC                       NO-UNDO.
DEF VAR i-codigo-orig                AS INTEGER                   NO-UNDO.
DEF VAR i-codigo-orig-item-uni-estab AS INTEGER INITIAL ?         NO-UNDO.

  if  not valid-handle(h-boad123a) then
      run adbo/boad123a.p persistent set h-boad123a.
        
    run openQueryStatic in h-boad123a ('main').
    run goToKey         in h-boad123a ('SPP_TOTVSGFE').
    if  return-value = "NOK" then
        assign l-func-totvsgfe = no.
    else
        run getLogField in h-boad123a (input  'ativo',
                                       output l-func-totvsgfe).
    
    IF  l-func-totvsgfe THEN DO:
       
        EMPTY TEMP-TABLE tt-it-nota-fisc-volume.

        FIND FIRST tab-generica
            WHERE tab-generica.utilizacao = "SETUP":U NO-LOCK NO-ERROR.
        IF  AVAILABLE tab-generica AND
            SUBSTRING(tab-generica.char-2,640,1) = "s":U THEN
            RUN pi-volume-item (INPUT  nota-fiscal.cod-estabel,
                                INPUT  nota-fiscal.serie,
                                INPUT  nota-fiscal.nr-nota-fis,
                                OUTPUT TABLE tt-it-nota-fisc-volume).
          
    END.  

    FOR EACH it-nota-fisc 
        WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel 
          AND it-nota-fisc.serie       = nota-fiscal.serie       
          AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK:

        FOR FIRST ITEM  NO-LOCK 
            WHERE ITEM.it-codigo = it-nota-fisc.it-codigo: END.


        FOR FIRST natur-oper NO-LOCK 
            WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao: END.

        IF AVAIL natur-oper THEN
            &if '{&bf_dis_versao_ems}' >= '2.05':U &then
                FOR FIRST cfop-natur FIELDS(des-cfop) NO-LOCK
                    WHERE cfop-natur.cod-cfop = &if defined(bf_dis_formato_CFOP) &then natur-oper.cod-cfop &else SUBSTR(natur-oper.char-1,45,10) &endif: END.
            &else
               FOR FIRST ped-curva FIELDS(nome) NO-LOCK
                    WHERE ped-curva.it-codigo = &if defined(bf_dis_formato_CFOP) &then natur-oper.cod-cfop &else SUBSTR(natur-oper.char-1,45,10) &endif AND
                          ped-curva.vl-aberto = 620: END.
            &endif

        FOR FIRST classif-fisc FIELDS (descricao cod-ncm) NO-LOCK 
            WHERE classif-fisc.class-fiscal = it-nota-fisc.class-fiscal: END.

        FOR FIRST nar-it-nota FIELDS (narrativa) NO-LOCK 
            WHERE nar-it-nota.serie        = it-nota-fisc.serie       
              AND nar-it-nota.nr-nota-fis  = it-nota-fisc.nr-nota-fis
              AND nar-it-nota.cod-estabel  = it-nota-fisc.cod-estabel 
              AND nar-it-nota.nr-sequencia = it-nota-fisc.nr-seq-fat: END.

        
        RUN pi-calc-zona-franca.

        FIND FIRST tt-it-nota-fisc-volume NO-LOCK
             WHERE tt-it-nota-fisc-volume.nr-seq-fat = it-nota-fisc.nr-seq-fat
               AND tt-it-nota-fisc-volume.it-codigo  = it-nota-fisc.it-codigo NO-ERROR.

        CREATE ttDocumentItem.
        ASSIGN iContItem                                            = iContItem  + 1
               ttDocumentItem.ttDocumentItemID                      = iContItem
               ttDocumentItem.Sequence                              = it-nota-fisc.nr-seq-fat
               ttDocumentItem.InventoryControlType                  = item.tipo-con-est         WHEN AVAIL item
               ttDocumentItem.ItemDescriptionType                   = it-nota-fisc.ind-imp-desc
               ttDocumentItem.ComponentType                         = it-nota-fisc.ind-componen
               ttDocumentItem.AttendanceType                        = it-nota-fisc.tipo-atend
               ttDocumentItem.CustomerOrderNumber                   = it-nota-fisc.nr-pedcli
               ttDocumentItem.OrderNumber                           = it-nota-fisc.nr-pedido
               ttDocumentItem.PurchaseOrderID                       = it-nota-fisc.cod-ord-compra
               ttDocumentItem.PurchaseOrderInstallment              = it-nota-fisc.parcela
               ttDocumentItem.CustomerOrderLine                     = it-nota-fisc.nr-seq-ped
               ttDocumentItem.IsInventoryIssued                     = it-nota-fisc.baixa-estoq
               ttDocumentItem.ManufacturingOrderNumber              = it-nota-fisc.nr-ord-prod
               /*QUANTIDADES TRIBUTµVEIS*/
               ttDocumentItem.InvoicedQuantity                      = it-nota-fisc.qt-faturada[1]
               /*QUANTIDADES COMERCIAIS*/
               ttDocumentItem.CustomerInvoicedQuantity              = (IF NOT it-nota-fisc.ind-fat-qtfam  
                                                                       THEN it-nota-fisc.qt-faturada[1]
                                                                       ELSE it-nota-fisc.qt-faturada[2])
               ttDocumentItem.InvoicedGrossWeight                   = (IF AVAILABLE tab-generica AND
                                                                          SUBSTRING(tab-generica.char-2,640,1) = "s" AND
                                                                          AVAILABLE tt-it-nota-fisc-volume 
                                                                          THEN it-nota-fisc.peso-bruto + tt-it-nota-fisc-volume.peso-embal
                                                                          ELSE it-nota-fisc.peso-bruto)
               ttDocumentItem.InvoicedNetWeight                     = it-nota-fisc.peso-liq-fat
               ttDocumentItem.InvoicedVolume                        = (IF AVAILABLE tab-generica AND
                                                                          SUBSTRING(tab-generica.char-2,640,1) = "s" AND 
                                                                          AVAILABLE tt-it-nota-fisc-volume
                                                                          THEN ROUND(tt-it-nota-fisc-volume.volume-rat,5)
                                                                          ELSE ROUND(  (((ITEM.altura * ITEM.largura * ITEM.comprim) / 1000000 ) * ttDocumentItem.CustomerInvoicedQuantity) ,5)) /* deVolumeRatEmbal  Pedro*/
               ttDocumentItem.ItemReferenceCode                     = it-nota-fisc.cod-refer
               ttDocumentItem.SoldProductsCostAccount               = it-nota-fisc.ct-cusven
               ttDocumentItem.GeneralLedgerCostAccount              = it-nota-fisc.ct-cuscon
               ttDocumentItem.EnteredDiscounts                      = it-nota-fisc.des-pct-desconto-inform
               ttDocumentItem.DiscountValue                         = it-nota-fisc.val-desconto-inform
               ttDocumentItem.DiscountPercentage                    = it-nota-fisc.per-des-item
               ttDocumentItem.PriceTableDiscountPercentage          = it-nota-fisc.val-pct-desconto-tab-preco
               ttDocumentItem.TotalPercentageOfDocumentItem_00      = it-nota-fisc.val-pct-desconto-total
               ttDocumentItem.PeriodDiscountPercentage              = it-nota-fisc.val-pct-desconto-periodo
               ttDocumentItem.DiscountPercentageLinkedToPay_00      = it-nota-fisc.val-pct-desconto-prazo
               ttDocumentItem.IsDiscountTableUsedInThisItem         = it-nota-fisc.log-usa-tabela-desconto
               ttDocumentItem.FreightValue                          = it-nota-fisc.vl-frete-it
               ttDocumentItem.ExpensesValue                         = it-nota-fisc.vl-despes-it
               ttDocumentItem.GeneralLedgerCostValue                = it-nota-fisc.vl-cuscontab
               ttDocumentItem.SalesPrice                            = it-nota-fisc.vl-precon
               ttDocumentItem.TablePrice                            = it-nota-fisc.vl-pretab
               ttDocumentItem.OriginalPrice                         = it-nota-fisc.vl-preori
               ttDocumentItem.NetPrice                              = IF de-vl-unit <> ? AND de-vl-unit <> 0 THEN  de-vl-unit ELSE it-nota-fisc.vl-preuni
               ttDocumentItem.TablePrice_00                         = it-nota-fisc.vl-merc-tab
               ttDocumentItem.OriginalPrice_00                      = it-nota-fisc.vl-merc-ori
               ttDocumentItem.NetPrice_00                           = IF de-vl-total <> ? AND de-vl-total <> 0 THEN de-vl-total ELSE it-nota-fisc.vl-merc-liq
               ttDocumentItem.PriceWithoutTax                       = it-nota-fisc.vl-merc-sicm
               ttDocumentItem.TotalPrice                            = it-nota-fisc.vl-tot-item
               ttDocumentItem.ItemCode                              = it-nota-fisc.it-codigo
               ttDocumentItem.ItemDescription                       = IF (nota-fiscal.ind-tip-nota = 4 
                                                                      AND it-nota-fisc.qt-faturada[1] = 0) THEN "Complementar de Imposto" ELSE item.desc-item WHEN AVAIL ITEM
               ttDocumentItem.ItemDescription                       = IF (nota-fiscal.ind-tip-nota = 8 
                                                                      AND it-nota-fisc.qt-faturada[1] = 0 
                                                                      AND natur-oper.nota-rateio) THEN "Complementar" ELSE ttDocumentItem.ItemDescription
               /* Natureza de Opera»’o */
               ttDocumentItem.FiscalOperationCode                   = it-nota-fisc.nat-operacao
               ttDocumentItem.FiscalOperationDescription            = &if '{&bf_dis_versao_ems}' >= '2.05':U &then 
                                                                        IF AVAIL cfop-natur THEN cfop-natur.des-cfop
                                                                           ELSE natur-oper.denominacao WHEN AVAIL natur-oper
                                                                      &else
                                                                         IF AVAIL ped-curva THEN ped-curva.nome 
                                                                           ELSE natur-oper.denominacao WHEN AVAIL natur-oper
                                                                      &endif
                   ttDocumentItem.FiscalOperationCFOP               = &IF DEFINED(bf_dis_formato_CFOP) &THEN 
                                                                       natur-oper.cod-cfop
                                                                      &ELSE
                                                                       SUBSTR(natur-oper.char-1,45,10)
                                                                      &ENDIF WHEN AVAIL natur-oper
               
               /* Classifica»’o Fiscal */
               ttDocumentItem.FiscalClassificationID                = it-nota-fisc.class-fiscal
               ttDocumentItem.FiscalClassificationDescription       = classif-fisc.descricao    WHEN AVAIL classif-fisc
               /* Narrativa */
               ttDocumentItem.Narrative                             = nar-it-nota.narrativa     WHEN AVAIL nar-it-nota
               /* Documento de Origem */
               ttDocumentItem.DocumentSeries_00                     = it-nota-fisc.serie-ant
               ttDocumentItem.DocumentNumber_00                     = it-nota-fisc.nr-nota-ant
               &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN
               ttDocumentItem.BusinessUnitID                        = it-nota-fisc.cod-unid-negoc
               &ELSE
               ttDocumentItem.SiteID                                = it-nota-fisc.cod-estabel
               ttDocumentItem.DocumentSeries_01                     = ttInvoiceDocument.DocumentSeries
               ttDocumentItem.DocumentNumber_01                     = it-nota-fisc.nr-nota-fis
               &ENDIF
               &IF "{&BF_DIS_VERSAO_EMS}" >= "2.08" &THEN
               ttDocumentItem.DocumentClass                         = natur-oper.especie-doc 
               ttDocumentItem.IsFinalConsumer                       = natur-oper.consum-final
               ttDocumentItem.TransferOperation                     = natur-oper.transf
               ttDocumentItem.TYPE                                  = natur-oper.tipo
               &ENDIF   
               ttDocumentItem.GroupStock                            = ITEM.ge-codigo
               ttDocumentItem.familyBusiness                        = ITEM.fm-cod-com
               ttDocumentItem.familyMaterials                       = ITEM.fm-codigo
               .

        IF l-nfe THEN DO: 
            IF  nota-fiscal.perc-desco1   <> 0
            OR  nota-fiscal.perc-desco2   <> 0
            OR  nota-fiscal.per-des-icms  <> 0
            OR  it-nota-fisc.per-des-item <> 0 THEN
                ASSIGN ttDocumentItem.TotalDiscountAmount       = it-nota-fisc.vl-merc-ori - it-nota-fisc.vl-merc-liq
                       ttInvoiceDocumentAux.TotalDiscountAmount = ttInvoiceDocumentAux.TotalDiscountAmount + ttDocumentItem.TotalDiscountAmount.
            ELSE
                ASSIGN ttDocumentItem.TotalDiscountAmount       = 0
                       ttInvoiceDocumentAux.TotalDiscountAmount = 0.

        END.

        IF  CAN-FIND (funcao WHERE funcao.cd-funcao = "SPP-DESCONTO-NFE":U AND funcao.ativo) 
            AND INT(SUBSTRING(natur-oper.char-2,11,5)) = 2 THEN 
            ASSIGN ttDocumentItem.DiscountAmount                    = 0
                   ttDocumentItem.TotalDiscountAmount               = 0
                   ttInvoiceDocumentAux.TotalDiscountAmount         = 0.
        ELSE 
            ASSIGN ttDocumentItem.DiscountAmount                    = it-nota-fisc.vl-desconto.
                   
        
       /*------  PESQUISA A DESCRICAO DO PRODUTO  ------ */
              
              if it-nota-fisc.ind-imp-desc = 1 then /* Descri‡Æo */
                  assign c-desc-prod = ttDocumentItem.ItemDescription.

              if  it-nota-fisc.ind-imp-desc = 2           /* Descri‡Æo + Narrativa */
              or  it-nota-fisc.ind-imp-desc = 5           /* Narrativa Item */
              or  it-nota-fisc.ind-imp-desc = 6           /* Uma Linha Narrativa */
              or  it-nota-fisc.ind-imp-desc = 10 then do: /* Descri‡Æo + 24 Narrativa Item */
        
                  if  it-nota-fisc.ind-imp-desc = 2
                  or  it-nota-fisc.ind-imp-desc = 10 then
                      assign c-desc-prod = ttDocumentItem.ItemDescription + " ".
                  else 
                      assign c-desc-prod = "".

                  find narrativa of item no-lock no-error.
        
                  if avail narrativa then 
                     assign c-desc-prod = c-desc-prod +
                                          if  it-nota-fisc.ind-imp-desc = 6 then
                                              trim(entry(1,substring(narrativa.descricao,1,76),chr(10)))
                                          else if it-nota-fisc.ind-imp-desc = 10 then
                                              trim(entry(1,substring(narrativa.descricao,1,24),chr(10)))
                                          else                        
                                              narrativa.descricao.
              end.
        
              if  it-nota-fisc.ind-imp-desc = 3          /* Descri‡Æo + Narrativa Item/Cliente */
              or  it-nota-fisc.ind-imp-desc = 8 then do: /* Descri‡Æo + 24 Narrativa Item/Cliente */
                  find item-cli
                       where item-cli.nome-abrev = nota-fiscal.nome-ab-cli
                       and   item-cli.it-codigo  = it-nota-fisc.it-codigo
                       no-lock no-error.
        
                  assign c-desc-prod = ttDocumentItem.ItemDescription + " ".
        
                  if  avail item-cli then
                      assign c-desc-prod = c-desc-prod +
                                           if it-nota-fisc.ind-imp-desc = 3 then          
                                              item-cli.narrativa
                                           else
                                              trim(entry(1,substring(item-cli.narrativa,1,24),chr(10))).
              end.

              if  it-nota-fisc.ind-imp-desc = 4            /* Descri‡Æo + Narrativa Informada */
              or  it-nota-fisc.ind-imp-desc = 7            /* Narrativa Informada */
              or  it-nota-fisc.ind-imp-desc = 9 then do:   /* Descri‡Æo + 24 Narrativa Informada */
        
                  if  it-nota-fisc.ind-imp-desc = 4
                  or  it-nota-fisc.ind-imp-desc = 9 then
                      assign c-desc-prod = ttDocumentItem.ItemDescription + " ".
                  else 
                      assign c-desc-prod = "".
        
                  find nar-it-nota
                       where nar-it-nota.cod-estabel  = it-nota-fisc.cod-estabel
                       and   nar-it-nota.serie        = it-nota-fisc.serie
                       and   nar-it-nota.nr-nota-fis  = it-nota-fisc.nr-nota-fis
                       and   nar-it-nota.nr-sequencia = it-nota-fisc.nr-seq-fat
                       and   nar-it-nota.it-codigo    = it-nota-fisc.it-codigo
                       no-lock no-error.
        
                  if avail nar-it-nota then 
                     assign c-desc-prod = c-desc-prod +
                                          if it-nota-fisc.ind-imp-desc = 9 then
                                             trim(entry(1,substring(nar-it-nota.narrativa,1,24),chr(10)))
                                          else
                                             nar-it-nota.narrativa.
              end.

              FOR FIRST item-dist                                                                                                       
                  WHERE item-dist.it-codigo = item.it-codigo NO-LOCK:                                                                                                                                                                                                           
                  IF item-dist.cdn-onu <> 0 THEN                                                                                        
                      ASSIGN c-info-onu = c-info-onu + " ONU " + STRING(item-dist.cdn-onu).
                  IF item-dist.nom-apropdo-embal <> "" THEN
                      ASSIGN c-info-onu = c-info-onu + " " + item-dist.nom-apropdo-embal.
                  IF item-dist.cod-class-risco <> "" THEN
                      ASSIGN c-info-onu = c-info-onu + " " + item-dist.cod-class-risco.
                  IF item-dist.cod-grp-embal <> "" THEN
                      ASSIGN c-info-onu = c-info-onu + " " + item-dist.cod-grp-embal.
                  IF item-dist.des-pto-fulgor <> "" THEN
                      ASSIGN c-info-onu = c-info-onu + " " + item-dist.des-pto-fulgor.
              END.

              IF c-info-onu <> "" THEN
                  ASSIGN c-desc-prod = c-desc-prod + " (" + TRIM(c-info-onu) + ") ".



        /* Narrativa */
        ASSIGN ttDocumentItem.Narrative       = c-desc-prod
               ttDocumentItem.ItemDescription = IF  length(c-desc-prod) > 120 THEN SUBSTR(c-desc-prod,1,120) 
                                                ELSE IF TRIM(c-desc-prod) <> "":U THEN c-desc-prod ELSE ttDocumentItem.ItemDescription.

                &IF '{&BF_DIS_VERSAO_EMS}' >= "2.05":U &THEN
                  FOR FIRST item-mat FIELDS(cod-ean) WHERE
                            item-mat.it-codigo = it-nota-fisc.it-codigo NO-LOCK: END.
                   IF AVAIL item-mat THEN
                      ASSIGN ttDocumentItem.EANCode = SUBSTR(item-mat.cod-ean,1,14). /* SEFAZ -> mÿx 14 posi»„es */
                &ELSE
                     ASSIGN ttDocumentItem.EANCode = SUBSTR(ITEM.char-1,133,14).
                &ENDIF

                IF c-nom-prog-upc-mg97 <> ""  THEN DO:
                    EMPTY TEMP-TABLE tt-epc.
                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "TrataCodigoEAN":U
                           tt-epc.cod-parameter = "handle-ttDocumentItem":U
                           tt-epc.val-parameter =  STRING(TEMP-TABLE ttDocumentItem:HANDLE).
                    {include/i-epc201.i "TrataCodigoEAN"}
                END.
                RUN ftp/ft0515a.p (INPUT  ROWID(it-nota-fisc), 
                                  OUTPUT iStatusTaxIcms,      
                                  OUTPUT l-sub).              

                /*Origem no Relacionamento Item x Estab Fat - CD0147*/
                FOR FIRST item-uni-estab NO-LOCK
                    WHERE item-uni-estab.it-codigo   = it-nota-fisc.it-codigo
                      AND item-uni-estab.cod-estabel = nota-fiscal.cod-estabel:

                    IF &IF "{&bf_dis_versao_ems}" >= "2.09"
                       &THEN TRIM(STRING(item-uni-estab.num-origem))
                       &ELSE TRIM(SUBSTRING(item-uni-estab.char-2,18,3)) &ENDIF
                    <> "":U THEN DO:

                        &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN
                            ASSIGN i-codigo-orig-item-uni-estab = item-uni-estab.num-origem.
                        &ELSE
                            ASSIGN i-codigo-orig-item-uni-estab = INT(TRIM(SUBSTRING(item-uni-estab.char-2,18,3))).
                        &ENDIF
                    END.
                END.

                &IF "{&bf_dis_versao_ems}":U >= "2.09":U &THEN
                    ASSIGN i-codigo-orig = IF  it-nota-fisc.num-origem <> ? THEN  
                                               it-nota-fisc.num-origem.  
                                           ELSE IF i-codigo-orig-item-uni-estab <> ?
                                                THEN i-codigo-orig-item-uni-estab
                                                ELSE ITEM.codigo-orig.
                &ELSE
                    IF  SUBSTRING(it-nota-fisc.char-1,180,3) <> "" THEN
                    ASSIGN i-codigo-orig = INT(SUBSTRING(it-nota-fisc.char-1,180,3)).
                ELSE
                    ASSIGN i-codigo-orig = IF i-codigo-orig-item-uni-estab <> ?
                                           THEN i-codigo-orig-item-uni-estab
                                           ELSE ITEM.codigo-orig.
                &ENDIF
                
                /* CST -> Codigo da Situacao Tributaria (conforme DANFE): Codigo Origem + Nivel Tributacao ICMS */
                ASSIGN iStatusTaxIcms               = INT(STRING(i-codigo-orig) + STRING(iStatusTaxIcms, "99")) WHEN AVAIL item
                       ttDocumentItem.StatusTaxIcms = string(iStatusTaxIcms,"999").

                &if '{&bf_dis_versao_ems}' >= '2.04':U AND '{&bf_dis_versao_ems}' <= '2.062':U &then
                    ASSIGN /* C½digo Tributa»’o*/
                           ttDocumentItem.StatusTaxIpi                     = substring(it-nota-fisc.char-1,75,2) 
                           ttDocumentItem.StatusTaxPis                     = substring(it-nota-fisc.char-1,77,2) 
                           ttDocumentItem.StatusTaxCofins                  = substring(it-nota-fisc.char-1,79,2) 
                           /* Modalidade Base */ 
                           ttDocumentItem.CalculationBasisIcmsModality     = trim(substring(it-nota-fisc.char-1,81,2)) 
                           ttDocumentItem.CalculationBasisIpiModality      = trim(substring(it-nota-fisc.char-1,83,2)) 
                           ttDocumentItem.CalculationBasisIcmsStModality   = trim(substring(it-nota-fisc.char-1,85,2)).
                &endif.
                     
                &if '{&bf_dis_versao_ems}' >= '2.07':U &then
                    ASSIGN ttDocumentItem.StatusTaxIpi                    = string(it-nota-fisc.cod-sit-tributar-ipi)
                           ttDocumentItem.StatusTaxPis                    = string(it-nota-fisc.cod-sit-tributar-pis)
                           ttDocumentItem.StatusTaxCofins                 = string(it-nota-fisc.cod-sit-tributar-cofins) 
                           ttDocumentItem.CalculationBasisIcmsModality    = string(it-nota-fisc.idi-modalid-base-icms)
                           ttDocumentItem.CalculationBasisIpiModality     = string(it-nota-fisc.idi-modalid-base-ipi)
                           ttDocumentItem.CalculationBasisIcmsStModality  = string(it-nota-fisc.idi-modalid-base-icms-st).
                &endif.
               
                IF l-sub AND ttInvoiceDocumentAux.TributarySubstituteStateTaxID = ? THEN
                   FOR FIRST estab-uf
                       WHERE estab-uf.cod-estabel = nota-fiscal.cod-estabel
                        AND  estab-uf.estado      = nota-fiscal.estado  NO-LOCK:

                      ASSIGN ttInvoiceDocumentAux.TributarySubstituteStateTaxID = estab-uf.ins-estadual.
                   END.
        
        /* Documento de Entrada */
        FOR FIRST b-natur-oper NO-LOCK 
            WHERE b-natur-oper.nat-operacao = it-nota-fisc.nat-docum: END.
        
        ASSIGN ttDocumentItem.DocumentSeries                = it-nota-fisc.serie-docum
               ttDocumentItem.DocumentNumber                = it-nota-fisc.nr-docum
               ttDocumentItem.FiscalOperationCode_00        = it-nota-fisc.nat-docum
               ttDocumentItem.FiscalOperationDescription_00 = b-natur-oper.denominacao WHEN AVAIL b-natur-oper
               &IF "{&BF_DIS_VERSAO_EMS}" >= "2.08" &THEN
               ttDocumentItem.DocumentClass                 = b-natur-oper.especie-doc WHEN AVAIL b-natur-oper
               ttDocumentItem.IsFinalConsumer               = b-natur-oper.consum-final WHEN AVAIL b-natur-oper
               ttDocumentItem.TransferOperation             = b-natur-oper.transf WHEN AVAIL b-natur-oper
               ttDocumentItem.TYPE                          = b-natur-oper.tipo WHEN AVAIL b-natur-oper
               &ENDIF  
               .
        
        /* Unidade de Medida do Item */
        FOR FIRST tab-unidade FIELDS (descricao) NO-LOCK 
            WHERE tab-unidade.un = it-nota-fisc.un-fatur[1]: END.

        ASSIGN ttDocumentItem.UnitOfMeasureCode        = it-nota-fisc.un-fatur[1]
               ttDocumentItem.UnitOfMeasureDescription = tab-unidade.descricao WHEN AVAIL tab-unidade.

        /* Quantidade Pacote */
        ASSIGN ttDocumentItem.PackageQuantity = ITEM.quant-pacote.

        /* Unidade de Medida do Cliente */
        FOR FIRST tab-unidade FIELDS (descricao) NO-LOCK 
            WHERE tab-unidade.un = (IF NOT it-nota-fisc.ind-fat-qtfam 
                                   THEN it-nota-fisc.un-fatur[1]
                                   ELSE it-nota-fisc.un-fatur[2]): END.

        ASSIGN ttDocumentItem.UnitOfMeasureCode_00        = (IF NOT it-nota-fisc.ind-fat-qtfam 
                                                            THEN it-nota-fisc.un-fatur[1]
                                                            ELSE it-nota-fisc.un-fatur[2])
               ttDocumentItem.UnitOfMeasureDescription_00 = tab-unidade.descricao WHEN AVAIL tab-unidade.

        &IF  '{&bf_dis_sgt}' = 'yes':U &THEN
             IF  l-funcao-SGT THEN DO:
                &IF '{&bf_dis_versao_ems}':U >= '2.08':U &THEN
                for first roman-item-nf no-lock
                    where roman-item-nf.cod-estab               = it-nota-fisc.cod-estabel
                    and   roman-item-nf.cod-serie               = it-nota-fisc.serie
                    and   roman-item-nf.nr-nota-fis             = it-nota-fisc.nr-nota-fis
                    and   roman-item-nf.nr-seq-fat              = it-nota-fisc.nr-seq-fat
                    and   roman-item-nf.it-codigo               = it-nota-fisc.it-codigo
                    and   roman-item-nf.num-seq-ped-vda         = it-nota-fisc.nr-seq-ped
                    and   roman-item-nf.des-nom-abrevi-clien    = it-nota-fisc.nome-ab-cli
                    and   roman-item-nf.nr-pedcli               = it-nota-fisc.nr-pedcli:
                    assign ttDocumentItem.PickingListNumber = string(roman-item-nf.nr-romaneio). /* N£mero Romaneio */
                end.
                &else
                for first tab-ocor no-lock
                    where tab-ocor.cod-tab    = 600
                    and   tab-ocor.c-campo[1] = it-nota-fisc.cod-estabel
                    and   tab-ocor.c-campo[2] = it-nota-fisc.serie
                    and   tab-ocor.c-campo[3] = it-nota-fisc.nr-nota-fis
                    and   tab-ocor.i-campo[1] = it-nota-fisc.nr-seq-fat
                    and   tab-ocor.c-campo[4] = it-nota-fisc.it-codigo
                    and   tab-ocor.i-campo[2] = it-nota-fisc.nr-seq-ped
                    and   tab-ocor.char-1     = it-nota-fisc.nome-ab-cli
                    and   tab-ocor.char-2     = it-nota-fisc.nr-pedcli:
                    assign ttDocumentItem.PickingListNumber = string(tab-ocor.int-1). /* N£mero Romaneio */
                end. /* for first tab-ocor */
                &ENDIF
             END. /* IF  l-funcao-SGT THEN DO: */
        &ENDIF 
   
        ASSIGN ttDocumentItem.EX_TIPIID = STRING(item.dec-1)
               ttDocumentItem.NCMID     = STRING(classif-fisc.cod-ncm).
        
        /* Descontos */
        FOR EACH desc-it-nota-fisc NO-LOCK
           WHERE desc-it-nota-fisc.cod-estabel     = it-nota-fisc.cod-estabel 
             AND desc-it-nota-fisc.cod-serie       = it-nota-fisc.serie       
             AND desc-it-nota-fisc.cod-nota-fiscal = it-nota-fisc.nr-nota-fis 
             AND desc-it-nota-fisc.cod-item        = it-nota-fisc.it-codigo   
             AND desc-it-nota-fisc.num-sequencia   = it-nota-fisc.nr-seq-fat:

            CREATE ttDiscount.
            ASSIGN iContDiscount                               = iContDiscount + 1
                   ttDiscount.ttDiscountID                     = iContDiscount
                   ttDiscount.ttDocumentItemID                 = ttDocumentItem.ttDocumentItemID
                   ttDiscount.DiscountNumber                   = desc-it-nota-fisc.num-desconto
                   ttDiscount.PeriodDiscountPercentage         = desc-it-nota-fisc.val-pct-desconto-periodo
                   ttDiscount.DiscountPercentageLinkedToPay_00 = desc-it-nota-fisc.val-pct-desconto-prazo
                   ttDiscount.IsBonusGrantedOnQuantity         = desc-it-nota-fisc.log-concede-bonif-qtd.

            /* Valores do Desconto */
            DO iValue = 1 TO 5:
                IF desc-it-nota-fisc.val-desconto[iValue] <> 0 THEN DO:
                    CREATE ttDiscountTableValue.
                    ASSIGN ttDiscountTableValue.ttDocumentItemID    = ttDocumentItem.ttDocumentItemID
                           ttDiscountTableValue.ttDiscountID        = ttDiscount.ttDiscountID
                           ttDiscountTableValue.Sequence            = iValue
                           ttDiscountTableValue.TableValue          = desc-it-nota-fisc.val-desconto[iValue].
                END.
            END.
        END.

        /* Localiza»„es de Sa­da no Estoque */
        ASSIGN i-cont = 0.
        FOR EACH fat-ser-lote NO-LOCK
            WHERE fat-ser-lote.cod-estabel = it-nota-fisc.cod-estabel 
              AND fat-ser-lote.serie       = it-nota-fisc.serie       
              AND fat-ser-lote.nr-nota-fis = it-nota-fisc.nr-nota-fis 
              AND fat-ser-lote.nr-seq-fat  = it-nota-fisc.nr-seq-fat:
        
            FOR FIRST deposito FIELDS (nome) NO-LOCK 
                WHERE deposito.cod-depos = fat-ser-lote.cod-depos: END.

            FOR FIRST localizacao FIELDS (descricao) NO-LOCK 
                WHERE localizacao.cod-localiz = fat-ser-lote.cod-localiz: END.

            CREATE ttIssuedLocation.
            ASSIGN i-cont                                  = i-cont + 1
                   ttIssuedLocation.Sequence               = i-cont
                   ttIssuedLocation.ttDocumentItemID       = ttDocumentItem.ttDocumentItemID
                   ttIssuedLocation.WarehouseID            = fat-ser-lote.cod-depos
                   ttIssuedLocation.WarehouseDescription   = deposito.nome         WHEN AVAIL deposito
                   ttIssuedLocation.BinLocationID          = fat-ser-lote.cod-localiz
                   ttIssuedLocation.BinLocationDescription = localizacao.descricao WHEN AVAIL localizacao
                   ttIssuedLocation.LotOrSerialNumber      = fat-ser-lote.nr-serlote
                   ttIssuedLocation.LotValidityDate        = fat-ser-lote.dt-vali-lote
                   ttIssuedLocation.Quantity               = fat-ser-lote.qt-baixada[1].
        END.

        /*-----------------------------------------------------------------------------[ Etiquetas do Item  |  EDI Mercantil com Montadoras ]---*/
        &if '{&bf_dis_versao_ems}':U < '2.06':U &then
            find first ped-curva no-lock
                where  substring(ped-curva.nome,01,03) = it-nota-fisc.cod-estabel
                and    substring(ped-curva.nome,04,05) = it-nota-fisc.serie
                and    substring(ped-curva.nome,09,16) = it-nota-fisc.nr-nota-fis
                and    ped-curva.it-codigo             = it-nota-fisc.it-codigo no-error.
            if  avail  ped-curva then do:
                create ttTagCode.
                assign ttTagCode.TagCode_XML      = ped-curva.regiao
                       ttTagCode.TagQuantity_XML  = ped-curva.quantidade
                       ttTagCode.ttDocumentItemID = ttDocumentItem.ttDocumentItemID.
            end. /* if  avail  ped-curva */
        &else
            find first prog-entreg-cham no-lock
                where  prog-entreg-cham.cod-estabel = it-nota-fisc.cod-estabel
                and    prog-entreg-cham.serie       = it-nota-fisc.serie
                and    prog-entreg-cham.nr-nota-fis = it-nota-fisc.nr-nota-fis 
                and    prog-entreg-cham.it-codigo   = it-nota-fisc.it-codigo no-error.
            if  avail  prog-entreg-cham then do:
                create ttTagCode.
                assign ttTagCode.TagCode_XML      = prog-entreg-cham.cod-cham
                       ttTagCode.TagQuantity_XML  = prog-entreg-cham.qtd-cham
                       ttTagCode.ttDocumentItemID = ttDocumentItem.ttDocumentItemID.
            end. /* if  avail  prog-entreg-cham */
        &endif
        /*-----------------------------------------------------------------------------[ Etiquetas do Item  |  EDI Mercantil com Montadoras ]---*/
        
        /* Impostos */
        IF i-pais-impto-usuario <> 1 THEN DO: /* Internacional */
            FOR EACH it-nota-imp NO-LOCK
                WHERE it-nota-imp.cod-estabel = it-nota-fisc.cod-estabel 
                  AND it-nota-imp.serie       = it-nota-fisc.serie       
                  AND it-nota-imp.nr-nota-fis = it-nota-fisc.nr-nota-fis 
                  AND it-nota-imp.nr-seq-fat  = it-nota-fisc.nr-seq-fat:

                FOR FIRST tipo-tax FIELDS (descricao) NO-LOCK 
                    WHERE tipo-tax.cod-tax = it-nota-imp.cod-taxa: END.

                &if '{&bf_dis_versao_ems}' > '2.04':U &then
                    FOR FIRST jurisdicao FIELDS (nm-jurisdic) NO-LOCK 
                        WHERE jurisdicao.cd-jurisdicao = it-nota-imp.cd-jurisdicao: END.
                &endif

                CREATE ttDocumentItemTax.
                ASSIGN ttDocumentItemTax.ttDocumentItemID        = ttDocumentItem.ttDocumentItemID
                       ttDocumentItemTax.Sequence                = it-nota-imp.nr-seq-imp
                       ttDocumentItemTax.TaxCode                 = it-nota-imp.cod-taxa
                       ttDocumentItemTax.TaxDescription          = tipo-tax.descricao     WHEN AVAIL tipo-tax
                       ttDocumentItemTax.TaxPercentage           = it-nota-imp.aliquota
                       ttDocumentItemTax.TaxCalculationBasis     = it-nota-imp.vl-base-imp
                       ttDocumentItemTax.TaxReductionPercentage  = it-nota-imp.perc-redimp
                       ttDocumentItemTax.TaxValue                = it-nota-imp.vl-imposto
                       ttDocumentItemTax.TaxAccount              = it-nota-imp.conta-tax
                       &if '{&bf_dis_versao_ems}' > '2.04':U &then
                       ttDocumentItemTax.TaxPercentageOnBasis    = it-nota-imp.perc-base 
                       ttDocumentItemTax.JurisdictionID          = it-nota-imp.cd-jurisdicao
                       ttDocumentItemTax.JurisdictionDescription = jurisdicao.nm-jurisdic WHEN AVAIL jurisdicao
                       ttDocumentItemTax.ExemptCertificate       = it-nota-imp.cod-certif-isencao
                       &endif . 
            END.
        END.
        ELSE  DO: /* Brasil */

            CREATE ttDocumentItemTax.  /* ICMS */
            ASSIGN ttDocumentItemTax.ttDocumentItemID           = ttDocumentItem.ttDocumentItemID
                   ttDocumentItemTax.TaxCode                    = 1
                   ttDocumentItemTax.TaxDescription             = "ICMS":U
                   ttDocumentItemTax.TaxPercentage              = it-nota-fisc.aliquota-icm
                   ttDocumentItemTax.TaxCalculationBasis        = it-nota-fisc.vl-bicms-it
                   d-total-base-icms                            = d-total-base-icms + it-nota-fisc.vl-bicms-it
                   d-total-icms                                 = d-total-icms + if it-nota-fisc.cd-trib-icm = 1 /*Tributado*/
                                                                                 or it-nota-fisc.cd-trib-icm = 4 /*Reduzido  */
                                                                                 then it-nota-fisc.vl-icms-it
                                                                                 else 0
                   ttDocumentItemTax.NotTaxedCalculationBasis   = it-nota-fisc.vl-icmsnt-it
                   ttDocumentItemTax.TaxReductionPercentage     = it-nota-fisc.perc-red-icm
                   ttDocumentItemTax.TaxDiscountPercentage      = it-nota-fisc.per-des-icms
                   ttDocumentItemTax.TaxOtherValue              = it-nota-fisc.vl-icmsou-it
                   ttDocumentItemTax.TaxationType               = it-nota-fisc.cd-trib-icm
                   ttDocumentItemTax.TaxValue                   = it-nota-fisc.vl-icms-it
                   ttDocumentItemTax.TributarySubstitutionBasis = it-nota-fisc.vl-bsubs-it
                   ttDocumentItemTax.TributarySubstitutionValue = it-nota-fisc.vl-icmsub-it
                   d-total-base-icms-sub                        = d-total-base-icms-sub + it-nota-fisc.vl-bsubs-it
                   d-total-icms-sub                             = d-total-icms-sub      + it-nota-fisc.vl-icmsub-it   
                   ttDocumentItemTax.TaxSupplementaryValue      = it-nota-fisc.vl-icmscomp-it
                   ttDocumentItemTax.IPIFrameworkID             = STRING(item.enquad-beb). 

            CREATE ttDocumentItemTax.  /* IPI */
            ASSIGN ttDocumentItemTax.ttDocumentItemID         = ttDocumentItem.ttDocumentItemID
                   ttDocumentItemTax.TaxCode                  = 2
                   ttDocumentItemTax.TaxDescription           = "IPI":U
                   ttDocumentItemTax.TaxPercentage            = it-nota-fisc.aliquota-ipi
                   ttDocumentItemTax.TaxCalculationBasis      = it-nota-fisc.vl-bipi-it
                   ttDocumentItemTax.NotTaxedCalculationBasis = it-nota-fisc.vl-ipint-it
                   ttDocumentItemTax.TaxReductionPercentage   = it-nota-fisc.perc-red-ipi
                   ttDocumentItemTax.TaxOtherValue            = it-nota-fisc.vl-ipiou-it
                   ttDocumentItemTax.TaxationType             = it-nota-fisc.cd-trib-ipi
                   ttDocumentItemTax.TaxValue                 = IF it-nota-fisc.cd-trib-ipi <> 3 
                                                                THEN it-nota-fisc.vl-ipi-it
                                                                ELSE 0
                   d-total-ipi                                = d-total-ipi + IF it-nota-fisc.cd-trib-ipi <> 3 
                                                                              THEN it-nota-fisc.vl-ipi-it
                                                                              ELSE 0
                   d-total-base-ipi                           = d-total-base-ipi + it-nota-fisc.vl-bipi-it.
                   

            CREATE ttDocumentItemTax.  /* ISS */
            ASSIGN ttDocumentItemTax.ttDocumentItemID         = ttDocumentItem.ttDocumentItemID
                   ttDocumentItemTax.TaxCode                  = 3
                   ttDocumentItemTax.TaxDescription           = "ISS":U
                   ttDocumentItemTax.TaxPercentage            = it-nota-fisc.aliquota-iss
                   ttDocumentItemTax.TaxCalculationBasis      = it-nota-fisc.vl-biss-it
                   ttDocumentItemTax.NotTaxedCalculationBasis = it-nota-fisc.vl-issnt-it
                   ttDocumentItemTax.TaxReductionPercentage   = it-nota-fisc.perc-red-iss
                   ttDocumentItemTax.TaxOtherValue            = it-nota-fisc.vl-issou-it
                   ttDocumentItemTax.TaxationType             = it-nota-fisc.cd-trib-iss
                   ttDocumentItemTax.TaxValue                 = it-nota-fisc.vl-iss-it
                   d-total-base-iss                           = d-total-base-iss + it-nota-fisc.vl-biss-it
                   d-total-iss                                = d-total-iss + if it-nota-fisc.cd-trib-iss = 1 /*Tributado*/
                                                                              or it-nota-fisc.cd-trib-iss = 4 /*Reduzido  */
                                                                              then it-nota-fisc.vl-iss-it
                                                                              else 0.

            CREATE ttDocumentItemTax.  /* CSLL */
            ASSIGN ttDocumentItemTax.ttDocumentItemID    = ttDocumentItem.ttDocumentItemID
                   ttDocumentItemTax.TaxCode             = 4
                   ttDocumentItemTax.TaxDescription      = "CSLL":U
                   ttDocumentItemTax.TaxRetentionValue   = &if '{&bf_dis_versao_ems}' <= '2.05':U &then
                                                                 dec(substring(it-nota-fisc.char-2,98,14))
                                                           &else it-nota-fisc.val-retenc-csll &endif 
                   d-total-csll                          = d-total-csll + ttDocumentItemTax.TaxRetentionValue.                                                          

            FOR FIRST item-cli FIELDS (char-1 item-do-cli)
                WHERE item-cli.nome-abrev = it-nota-fisc.nome-ab-cli
                 AND  item-cli.it-codigo  = it-nota-fisc.it-codigo NO-LOCK:

                ASSIGN de-perc-pis-subst               = DEC(TRIM(SUBSTRING(item-cli.char-1,31,5))) / 100
                       de-vl-pis-subst                 = DEC(TRIM(SUBSTRING(item-cli.char-1,1,15))) / 10000
                       de-perc-cofins-subst            = DEC(TRIM(SUBSTRING(item-cli.char-1,36,5))) / 100
                       de-vl-cofins-subst              = DEC(TRIM(SUBSTRING(item-cli.char-1,16,15))) / 10000
                       ttDocumentItem.CustomerItemCode = item-cli.item-do-cli.
            END.

            IF l-nfe THEN DO:

               IF nota-fiscal.ind-tip-nota = 8 AND nota-fiscal.esp-docto = 20 THEN DO: /* busca nota de origem */
                  
                  FOR FIRST b-item-doc-est NO-LOCK
                      WHERE b-item-doc-est.cod-emitente = nota-fiscal.cod-emitente 
                        AND b-item-doc-est.serie-docto  = nota-fiscal.serie 
                        AND b-item-doc-est.nro-docto    = nota-fiscal.nr-nota-fis 
                        AND b-item-doc-est.nat-operacao = it-nota-fisc.nat-operacao
                        AND b-item-doc-est.sequencia    = it-nota-fisc.nr-seq-ped
                        AND b-item-doc-est.it-codigo    = it-nota-fisc.it-codigo:    
                  END.

                  IF  NOT AVAIL b-item-doc-est
                  AND nota-fiscal.nr-nota-ant <> "" THEN
                      FOR FIRST b-item-doc-est NO-LOCK
                          WHERE b-item-doc-est.cod-emitente = nota-fiscal.cod-emitente 
                            AND b-item-doc-est.serie-docto  = nota-fiscal.serie 
                            AND b-item-doc-est.nro-docto    = nota-fiscal.nr-nota-ant
                            AND b-item-doc-est.nat-operacao = it-nota-fisc.nat-operacao
                            AND b-item-doc-est.sequencia    = it-nota-fisc.nr-seq-ped
                            AND b-item-doc-est.it-codigo    = it-nota-fisc.it-codigo:    
                      END.
                  IF  AVAIL b-item-doc-est THEN
                      FOR FIRST b-nota-fiscal NO-LOCK
                          WHERE b-nota-fiscal.cod-estabel   = nota-fiscal.cod-estabel 
                            AND b-nota-fiscal.serie         = b-item-doc-est.serie-comp 
                            AND b-nota-fiscal.nr-nota-fis   = b-item-doc-est.nro-comp: 
                      END.

                   IF  AVAIL b-nota-fiscal THEN
                       FOR FIRST b-it-nota-fisc NO-LOCK 
                           WHERE b-it-nota-fisc.cod-estabel  = b-nota-fiscal.cod-estabel
                             AND b-it-nota-fisc.serie        = b-nota-fiscal.serie
                             AND b-it-nota-fisc.nr-nota-fis  = b-nota-fiscal.nr-nota-fis 
                             AND b-it-nota-fisc.nr-seq-fat   = b-item-doc-est.seq-comp
                             AND b-it-nota-fisc.it-codigo    = b-item-doc-est.it-codigo: 
                       END.

                   IF  AVAIL b-it-nota-fisc THEN DO:
                       FOR FIRST b-it-nota-fisc-aux 
                           WHERE ROWID(b-it-nota-fisc-aux) = ROWID(it-nota-fisc) EXCLUSIVE-LOCK:
                       
                           ASSIGN b-it-nota-fisc-aux.char-2 = b-it-nota-fisc.char-2.
                           
                           &IF '{&bf_dis_versao_ems}' >= '2.06' &THEN
                               FOR FIRST item-dist WHERE
                                         item-dist.it-codigo = b-it-nota-fisc.it-codigo NO-LOCK: END.
                           &ENDIF
                       END.

                       RELEASE b-it-nota-fisc-aux.
                    
                   END.
               END.
               ELSE DO:
                    FOR FIRST b-nota-fiscal NO-LOCK
                        WHERE ROWID(b-nota-fiscal) = ROWID(nota-fiscal): END.

                    FOR FIRST b-it-nota-fisc
                        WHERE ROWID(b-it-nota-fisc) = ROWID(it-nota-fisc) : END.
               END.

               &if '{&bf_dis_versao_ems}' >= '2.04':U AND '{&bf_dis_versao_ems}' <= '2.062':U &then
                    ASSIGN /* C½digo Tributa»’o*/
                           ttDocumentItem.StatusTaxIpi                     = substring(it-nota-fisc.char-1,75,2)
                           ttDocumentItem.StatusTaxPis                     = substring(it-nota-fisc.char-1,77,2)
                           ttDocumentItem.StatusTaxCofins                  = substring(it-nota-fisc.char-1,79,2)
                           /* Modalidade Base */ 
                           ttDocumentItem.CalculationBasisIcmsModality     = substring(it-nota-fisc.char-1,81,2) 
                           ttDocumentItem.CalculationBasisIpiModality      = substring(it-nota-fisc.char-1,83,2) 
                           ttDocumentItem.CalculationBasisIcmsStModality   = substring(it-nota-fisc.char-1,85,2).
                &endif.
                     
                &if '{&bf_dis_versao_ems}' >= '2.07':U &then
                    ASSIGN ttDocumentItem.StatusTaxIpi                    = string(it-nota-fisc.cod-sit-tributar-ipi)
                           ttDocumentItem.StatusTaxPis                    = string(it-nota-fisc.cod-sit-tributar-pis)
                           ttDocumentItem.StatusTaxCofins                 = string(it-nota-fisc.cod-sit-tributar-cofins) 
                           ttDocumentItem.CalculationBasisIcmsModality    = string(it-nota-fisc.idi-modalid-base-icms)
                           ttDocumentItem.CalculationBasisIpiModality     = string(it-nota-fisc.idi-modalid-base-ipi)
                           ttDocumentItem.CalculationBasisIcmsStModality  = string(it-nota-fisc.idi-modalid-base-icms-st).
                &endif.

                IF NOT VALID-HANDLE(h-cd9500) THEN
                   RUN cdp/cd9500.p PERSISTENT SET h-cd9500.
            
                IF AVAIL b-nota-fiscal AND
                   AVAIL b-it-nota-fisc THEN DO :                  
                    FOR FIRST b-emitente FIELDS (cod-gr-cli) NO-LOCK 
                        WHERE b-emitente.nome-abrev = b-nota-fiscal.nome-ab-cli: END.
                   
                    FOR FIRST b-natur-oper NO-LOCK 
                        WHERE b-natur-oper.nat-operacao = b-nota-fiscal.nat-operacao: END.
                   
                    IF  AVAIL b-emitente THEN
                        RUN pi-cd9500 IN h-cd9500(b-nota-fiscal.cod-estabel,
                                                  b-emitente.cod-gr-cli,
                                                  ROWID(item),
                                                  b-it-nota-fisc.nat-operacao,
                                                  (IF lContaFtPorCliente THEN STRING(b-nota-fiscal.cod-emitente) ELSE b-it-nota-fisc.serie),
                                                  b-it-nota-fisc.cod-depos,
                                                  b-nota-fiscal.cod-canal-venda,
                                                  OUTPUT r-conta-ft).
                END.
                /* PIS */
                CREATE ttDocumentItemTax.
                ASSIGN ttDocumentItemTax.ttDocumentItemID = ttDocumentItem.ttDocumentItemID
                       ttDocumentItemTax.TaxCode          = 5.
    
                 /* COFINS */
                CREATE ttDocumentItemTax.
                ASSIGN ttDocumentItemTax.ttDocumentItemID = ttDocumentItem.ttDocumentItemID
                       ttDocumentItemTax.TaxCode          = 6.

                FIND conta-ft WHERE ROWID(conta-ft) = r-conta-ft NO-LOCK NO-ERROR.

                /* Calculo PIS/COFINS */
                IF nota-fiscal.ind-tip-nota = 8 THEN DO:

                    /* Documentos de Entrada */
                    FOR FIRST item-doc-est NO-LOCK
                        WHERE item-doc-est.serie-docto  = it-nota-fisc.serie
                        AND   item-doc-est.nro-docto    = nota-fiscal.nr-nota-ant 
                        AND   item-doc-est.cod-emitente = nota-fiscal.cod-emitente
                        AND   item-doc-est.nat-operacao = it-nota-fisc.nat-operacao
                        AND   item-doc-est.sequencia    = it-nota-fisc.nr-seq-ped
                        AND   item-doc-est.it-codigo    = it-nota-fisc.it-codigo: END.

                    /* PIS */
                    FIND FIRST ttDocumentItemTax EXCLUSIVE-LOCK 
                        WHERE ttDocumentItemTax.TaxCode          = 5 
                        AND   ttDocumentItemTax.ttDocumentItemID = ttDocumentItem.ttDocumentItemID NO-ERROR.
                   
                        IF AVAIL ttDocumentItemTax AND AVAIL item-doc-est THEN
                            &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
                                ASSIGN ttDocumentItemTax.TaxValue = item-doc-est.valor-pis
                                       d-total-base-pis           = d-total-base-pis + item-doc-est.base-pis.
                            &ELSE
                                ASSIGN ttDocumentItemTax.TaxValue = DEC(SUBSTR(item-doc-est.char-2,41,14))
                                       d-total-base-pis           = d-total-base-pis + DEC(SUBSTR(item-doc-est.char-2,27,14)).
                            &ENDIF
                   
                    /* COFINS */
                    FIND FIRST ttDocumentItemTax EXCLUSIVE-LOCK 
                        WHERE ttDocumentItemTax.TaxCode          = 6
                        AND   ttDocumentItemTax.ttDocumentItemID = ttDocumentItem.ttDocumentItemID NO-ERROR.
                    
                       IF AVAIL ttDocumentItemTax AND AVAIL item-doc-est THEN
                            &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
                                ASSIGN ttDocumentItemTax.TaxValue = item-doc-est.val-cofins 
                                       d-total-base-cofins        = d-total-base-cofins + item-doc-est.base-cofins.
                            &ELSE
                                ASSIGN ttDocumentItemTax.TaxValue = DEC(SUBSTR(item-doc-est.char-2,103,14))                                    
                                       d-total-base-cofins        = d-total-base-cofins + DEC(substr(item-doc-est.char-2,89,14)).
                            &ENDIF
                END.
                ELSE DO:

                    IF AVAIL conta-ft THEN DO:
                        ASSIGN de-aliq-pis        = 0
                               de-val-base-pis    = 0
                               de-val-pis         = 0
                               de-aliq-cofins     = 0
                               de-val-base-cofins = 0
                               de-val-cofins      = 0.

                        RUN piBuscaPisCofins IN h-cdapi995 (INPUT  "it-nota-fisc",
                                                            INPUT  ROWID(b-it-nota-fisc),
                                                            INPUT  NO, /* nÆo for‡ar recalcular, s¢ recalcula se nÆo existir registro ext-it-nota-fisc */
                                                            INPUT  l-integr-tms,
                                                            OUTPUT de-aliq-pis,
                                                            OUTPUT de-val-base-pis,
                                                            OUTPUT de-val-pis,
                                                            OUTPUT de-aliq-cofins,
                                                            OUTPUT de-val-base-cofins,
                                                            OUTPUT de-val-cofins).

                        /* PIS */
                        FOR EACH tt-ped-curva:
                            DELETE tt-ped-curva.
                        END.

                        IF  b-it-nota-fisc.vl-tot-item > 0      
                        AND conta-ft.ct-pis-ft <> "" THEN DO:

                            ASSIGN d-total-base-pis = d-total-base-pis + de-val-base-pis.
                            
                            if  de-val-pis > 0 then do:
                                RUN pi-ped-curva(INPUT estabelec.conta-pis-rec, INPUT de-val-pis). /*"estabelec.ct-pis"*/
                    
                                ASSIGN de-val-pis = de-val-pis * (-1).
                                RUN pi-ped-curva(INPUT conta-ft.ct-pis-ft, INPUT de-val-pis).
                    
                            end.
                        END.
                        
                        IF AVAIL b-nota-fiscal THEN DO :                      
                            for each tt-ped-curva where
                                     tt-ped-curva.it-codigo = b-nota-fiscal.cod-estabel and
                                     tt-ped-curva.serie     = b-nota-fiscal.serie       and
                                     tt-ped-curva.nr-nota   = b-nota-fiscal.nr-nota-fis break by tt-ped-curva.codigo:
                                
                                ASSIGN d-total-pis = d-total-pis + tt-ped-curva.vl-debito.
                                
                                FIND FIRST ttDocumentItemTax EXCLUSIVE-LOCK 
                                    WHERE ttDocumentItemTax.TaxCode          = 5 
                                    AND   ttDocumentItemTax.ttDocumentItemID = ttDocumentItem.ttDocumentItemID NO-ERROR.
                                IF AVAIL ttDocumentItemTax
                                AND tt-ped-curva.vl-debito <> 0 THEN
                                    ASSIGN ttDocumentItemTax.TaxValue = tt-ped-curva.vl-debito. /* valor por item */                        
                            END.
                        END.
                    
                        /* COFINS */
                        FOR EACH tt-ped-curva:
                            DELETE tt-ped-curva.
                        END.
                    
                        if  b-it-nota-fisc.vl-tot-item > 0
                        and conta-ft.ct-cofins-ft     <> "" THEN DO:
                    
                            ASSIGN d-total-base-cofins = d-total-base-cofins + de-val-base-cofins.
                                                           
                            if  de-val-cofins > 0 then do:
                                RUN pi-ped-curva(INPUT estabelec.conta-fin-pag, INPUT de-val-cofins). /*"estabelec.ct-ir-ret"*/

                                ASSIGN de-vl-contab = de-val-cofins * (-1).
                                RUN pi-ped-curva(INPUT conta-ft.ct-cofins-ft, INPUT de-val-cofins).
                            end.
                        END.
                        
                        IF AVAIL b-nota-fiscal THEN DO:                      
                            for each tt-ped-curva where
                                     tt-ped-curva.it-codigo = b-nota-fiscal.cod-estabel and
                                     tt-ped-curva.serie     = b-nota-fiscal.serie       and
                                     tt-ped-curva.nr-nota   = b-nota-fiscal.nr-nota-fis break by tt-ped-curva.codigo:
                            
                                ASSIGN d-total-cofins = d-total-cofins + tt-ped-curva.vl-debito.
                            
                                FIND FIRST ttDocumentItemTax EXCLUSIVE-LOCK 
                                    WHERE ttDocumentItemTax.TaxCode          = 6 
                                    AND   ttDocumentItemTax.ttDocumentItemID = ttDocumentItem.ttDocumentItemID NO-ERROR.
                                IF AVAIL ttDocumentItemTax 
                                AND tt-ped-curva.vl-debito <> 0 THEN
                                    ASSIGN ttDocumentItemTax.TaxValue = tt-ped-curva.vl-debito. /* valor por item */
                            END.
                        END.
                    END.  /* conta-ft */
                END.
            END. /* l-nfe */

            FOR EACH ttDocumentItemTax WHERE ttDocumentItemTax.ttDocumentItemID = ttDocumentItem.ttDocumentItemID :

                IF  ttDocumentItemTax.TaxCode <> 5 
                AND ttDocumentItemTax.TaxCode <> 6 THEN NEXT.

                ASSIGN de-pc-pis    = 0   
                       de-pc-cofins = 0.

                IF nota-fiscal.ind-tip-nota = 8 AND 
                   AVAILABLE item-doc-est THEN DO:

                    RUN recupera-aliquotas IN h-cdapi995 (INPUT "item-doc-est",
                                                         INPUT item-doc-est.serie-docto + "/" + 
                                                               item-doc-est.nro-docto + "/" + 
                                                               string(item-doc-est.cod-emitente) + "/" + 
                                                               item-doc-est.nat-operacao + "/" + 
                                                               string(item-doc-est.sequencia), 
                                                               output de-pc-pis, 
                                                               output de-pc-cofins).

                    &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
                        IF de-pc-pis    = 0 THEN ASSIGN de-pc-pis    = item-doc-est.val-aliq-pis.
                        IF de-pc-cofins = 0 THEN ASSIGN de-pc-cofins = item-doc-est.val-aliq-cofins.
                    &ELSE
                        IF de-pc-pis    = 0 THEN ASSIGN de-pc-pis    = DEC(SUBSTR(item-doc-est.char-2,22,5))
                        IF de-pc-cofins = 0 THEN ASSIGN de-pc-cofins = DEC(SUBSTR(item-doc-est.char-2,84,5))
                    &ENDIF
                END.
                ELSE DO:
                    
                    RUN recupera-aliquotas IN h-cdapi995 (INPUT "it-nota-fisc",
                                                         INPUT it-nota-fisc.cod-estabel + "/" +
                                                               it-nota-fisc.serie  + "/" + 
                                                               it-nota-fisc.nr-nota-fis + "/" +
                                                               STRING(it-nota-fisc.nr-seq-fat) + "/" +
                                                               it-nota-fisc.it-codigo,
                                                         OUTPUT de-pc-pis,
                                                         OUTPUT de-pc-cofins).

                    IF de-pc-pis    = 0 THEN ASSIGN de-pc-pis    = DEC(SUBSTRING(it-nota-fisc.char-2,76,5)).
                    IF de-pc-cofins = 0 THEN ASSIGN de-pc-cofins = DEC(SUBSTRING(it-nota-fisc.char-2,81,5)).


                END.


                /* PIS */
                IF  ttDocumentItemTax.TaxCode = 5
                AND ttDocumentItemTax.ttDocumentItemID = ttDocumentItem.ttDocumentItemID THEN DO: 
                    ASSIGN ttDocumentItemTax.TaxDescription             = "PIS / PASEP":U
                           ttDocumentItemTax.TaxPercentage              = de-pc-pis
                           ttDocumentItemTax.TaxReductionPercentage     = dec(substring(it-nota-fisc.char-2,86,5))
                           ttDocumentItemTax.TaxationType               = dec(substring(it-nota-fisc.char-2,96,1))
                           ttDocumentItemTax.TributarySubstitutionValue = it-nota-fisc.vl-pis 
                           ttDocumentItemTax.TaxRetentionValue          = &IF '{&bf_dis_versao_ems}' >= '2.06' &THEN 
                                                                            it-nota-fisc.val-retenc-pis
                                                                          &ELSE
                                                                            dec(substring(it-nota-fisc.char-2,112,14))  
                                                                          &ENDIF
                           d-total-pis-ret                              = d-total-pis-ret  + ttDocumentItemTax.TaxRetentionValue .
        
                    ASSIGN ttDocumentItemTax.TaxUnitaryValue            = &IF '{&bf_dis_versao_ems}' >= '2.06':U &THEN
                                                                           it-nota-fisc.val-unit-pis.
                                                                          &ELSE
                                                                           dec(substring(it-nota-fisc.char-2,141,10)).
                                                                          &ENDIF
                END.
    
                /* COFINS */
                IF  ttDocumentItemTax.TaxCode = 6 
                AND ttDocumentItemTax.ttDocumentItemID = ttDocumentItem.ttDocumentItemID THEN DO: 
                    ASSIGN ttDocumentItemTax.TaxDescription             = "COFINS":U
                           ttDocumentItemTax.TaxPercentage              = de-pc-cofins
                           ttDocumentItemTax.TaxReductionPercentage     = dec(substring(it-nota-fisc.char-2,91,5))
                           ttDocumentItemTax.TaxationType               = dec(substring(it-nota-fisc.char-2,97,1))
                           ttDocumentItemTax.TributarySubstitutionValue = it-nota-fisc.vl-finsocial 
                           ttDocumentItemTax.TaxRetentionValue          = &if '{&bf_dis_versao_ems}' <= '2.05':U &then
                                                                                dec(substring(it-nota-fisc.char-2,126,14))
                                                                          &else it-nota-fisc.val-retenc-cofins   &endif
                          d-total-cofins-ret                            = d-total-cofins-ret  + ttDocumentItemTax.TaxRetentionValue .
        
                    ASSIGN ttDocumentItemTax.TaxUnitaryValue            = &IF '{&bf_dis_versao_ems}' >= '2.06':U &THEN
                                                                           it-nota-fisc.val-unit-cofins.
                                                                          &ELSE
                                                                           dec(substring(it-nota-fisc.char-2,152,10)).
                                                                          &ENDIF    
                END.
            END.
            
            IF NOT AVAIL para-fat THEN
               FOR FIRST para-fat NO-LOCK: END.

            CREATE ttDocumentItemTax.  /* INSS */
            ASSIGN ttDocumentItemTax.ttDocumentItemID    = ttDocumentItem.ttDocumentItemID
                   ttDocumentItemTax.TaxCode             = 7
                   ttDocumentItemTax.TaxDescription      = "INSS":U
                   ttDocumentItemTax.TaxRetentionValue   = it-nota-fisc.vl-ir-adic
                   d-total-base-vl-ir-adic               = d-total-base-vl-ir-adic + it-nota-fisc.vl-merc-liq
                   d-total-vl-ir-adic                    = d-total-vl-ir-adic + ttDocumentItemTax.TaxRetentionValue .

            CREATE ttDocumentItemTax.  /* IRF */
            ASSIGN ttDocumentItemTax.ttDocumentItemID    = ttDocumentItem.ttDocumentItemID
                   ttDocumentItemTax.TaxCode             = 8
                   ttDocumentItemTax.TaxDescription      = "IRF":U
                   ttDocumentItemTax.TaxRetentionValue   = it-nota-fisc.vl-irf-it
                   d-total-vl-irf-it                     = d-total-vl-irf-it + ttDocumentItemTax.TaxRetentionValue .

            /* Calcula base IRF: conforme dibo~\bodi317im1br.m25 */
            IF it-nota-fisc.vl-ir-adic > 0  THEN DO:

              ASSIGN d-total-base-vl-irf-it = d-total-base-vl-irf-it + it-nota-fisc.vl-merc-liq .
                                  
              if  it-nota-fisc.cd-trib-ipi <> 3
              &if '{&bf_dis_versao_ems}':U = '2.042':U &then  
              and substr(natur-oper.char-1,100,1) = "S":U then       
              &else        
                  &if '{&bf_dis_versao_ems}':U >= '2.062':U &then
                  and natur-oper.log-ipi-contrib-retid THEN
                  &else
                  and substr(natur-oper.char-1,105,1) = "S":U then 
                  &endif
              &endif
                  assign d-total-base-vl-irf-it = d-total-base-vl-irf-it + it-nota-fisc.vl-ipi-it.

              if  it-nota-fisc.cd-trib-ipi = 3
               and substring(natur-oper.char-2,16,1) = "1":U
               &if '{&bf_dis_versao_ems}':U = '2.042':U &then
               and substr(natur-oper.char-1,101,1) = "S":U then 
               &else
                    &if '{&bf_dis_versao_ems}':U >= '2.062':U &then
                    and natur-oper.log-ipi-outras-contrib-retid then
                    &else
                    and substr(natur-oper.char-1,106,1) = "S":U then 
                    &endif
               &endif
                   assign d-total-base-vl-irf-it = d-total-base-vl-irf-it + it-nota-fisc.vl-ipi-it.
                                            
              &if '{&bf_dis_versao_ems}':U >= '2.04':U AND  '{&bf_dis_versao_ems}':U < '2.07':U  &then
                  IF substr(natur-oper.char-1,139,1) = "1"  then
                      assign d-total-base-vl-irf-it = d-total-base-vl-irf-it + it-nota-fisc.vl-icmsub-it.
              &endif
              &if '{&bf_dis_versao_ems}':U >= '2.07':U  &then
                   IF natur-oper.log-icms-substto-base-irf-retid = yes  then
                      assign d-total-base-vl-irf-it = d-total-base-vl-irf-it + it-nota-fisc.vl-icmsub-it.
              &endif                                 

            END.

            /* II */
            IF CONNECTED("mgcex") THEN DO:
                 
                    IF NOT AVAIL param-imp THEN
                       FOR FIRST param-imp 
                           WHERE param-imp.cod-estabel = nota-fiscal.cod-estabel no-lock: end.

                    IF AVAIL param-imp THEN
                      FOR FIRST  item-doc-est-cex  NO-LOCK
                           WHERE item-doc-est-cex.serie-docto  = it-nota-fisc.serie
                             AND item-doc-est-cex.nro-docto    = it-nota-fisc.nr-nota-fis
                             AND item-doc-est-cex.cod-emitente = nota-fiscal.cod-emitente
                             AND item-doc-est-cex.nat-operacao = it-nota-fisc.nat-operacao
                             AND item-doc-est-cex.sequencia    = it-nota-fisc.nr-seq-ped
                             AND item-doc-est-cex.cod-desp     = INT(SUBSTR(param-imp.char-1,21,20)): END.
    
                          IF AVAIL item-doc-est-cex THEN DO:

                             CREATE ttDocumentItemTax.
                             ASSIGN ttDocumentItemTax.ttDocumentItemID       = ttDocumentItem.ttDocumentItemID
                                    ttDocumentItemTax.TaxCode                = 9
                                    ttDocumentItemTax.TaxDescription         = "II":U
                                    ttDocumentItemTax.TaxCalculationBasis    = it-nota-fisc.vl-merc-ori
                                    ttDocumentItemTax.TaxValue               = item-doc-est-cex.val-desp.
                                 
                             FOR EACH desp-imp NO-LOCK
                                WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp AND 
                                      desp-imp.log-2: /* Incide II */
    
                                ASSIGN ttDocumentItemTax.TaxCalculationBasis = ttDocumentItemTax.TaxCalculationBasis + desp-imp.val-desp. /* Base II: Vl Mercadoria + Vl Despesas */
                             END.

                             ASSIGN d-total-base-ii = d-total-base-ii + ttDocumentItemTax.TaxCalculationBasis                                                           
                                    d-total-ii      = d-total-ii      + ttDocumentItemTax.TaxValue.

                             ASSIGN ttDocumentItem.ExpensesValue        = ttDocumentItem.ExpensesValue - ttDocumentItemTax.TaxValue
                                    ttInvoiceDocumentAux.PackagingValue = ttInvoiceDocumentAux.PackagingValue  - ttDocumentItemTax.TaxValue.

                          END.
                END.
            
        END.

        &IF '{&bf_dis_versao_ems}' < '2.062' &THEN
            /* Unidades de Neg¢cio */
            FOR EACH unid-neg-fat FIELDS ( cod-estabel serie nr-nota-fis nr-seq-fat it-codigo 
                                        cod_unid_negoc perc-unid-neg qtd-unid-neg val-unid-neg ) NO-LOCK
                WHERE unid-neg-fat.cod-estabel = it-nota-fisc.cod-estabel
                  AND unid-neg-fat.serie       = it-nota-fisc.serie
                  AND unid-neg-fat.nr-nota-fis = it-nota-fisc.nr-nota-fis
                  AND unid-neg-fat.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                  AND unid-neg-fat.it-codigo   = it-nota-fisc.it-codigo:

                CREATE ttBusinessUnit.
                ASSIGN ttBusinessUnit.SiteID                 = unid-neg-fat.cod-estabel
                       ttBusinessUnit.DocumentSeries         = ttInvoiceDocument.DocumentSeries
                       ttBusinessUnit.DocumentNumber         = unid-neg-fat.nr-nota-fis
                       ttBusinessUnit.Sequence               = unid-neg-fat.nr-seq-fat
                       ttBusinessUnit.ItemCode               = unid-neg-fat.it-codigo
                       ttBusinessUnit.BusinessUnitID         = unid-neg-fat.cod_unid_negoc
                       ttBusinessUnit.BusinessUnitPercentage = unid-neg-fat.perc-unid-neg
                       ttBusinessUnit.BusinessUnitQuantity   = unid-neg-fat.qtd-unid-neg
                       ttBusinessUnit.BusinessUnitValue      = unid-neg-fat.val-unid-neg.
            END.
        &ELSE
            CREATE ttBusinessUnit.
            ASSIGN ttBusinessUnit.BusinessUnitID = it-nota-fisc.cod-unid-negoc
                   ttBusinessUnit.Sequence       = it-nota-fisc.nr-seq-fat.
        &ENDIF
        
        /*--- Adi‡äes ---*/

        IF  NOT AVAIL param-global THEN
            FIND FIRST param-global NO-LOCK NO-ERROR.

        /*Modulo de Importa‡Æo Implantado*/
        IF  param-global.modulo-07 THEN DO:

            IF  NOT AVAIL docum-est
            AND nota-fiscal.nr-nota-ant <> "" THEN
                FIND FIRST docum-est
                    WHERE docum-est.serie-docto  = nota-fiscal.serie
                      AND docum-est.nro-docto    = nota-fiscal.nr-nota-ant
                      AND docum-est.cod-emitente = nota-fiscal.cod-emitente
                      AND docum-est.nat-operacao = it-nota-fisc.nat-operacao NO-LOCK NO-ERROR.

            IF AVAIL docum-est THEN DO:
                FIND FIRST item-doc-est
                       WHERE item-doc-est.serie-docto  = it-nota-fisc.serie
                         AND item-doc-est.nro-docto    = nota-fiscal.nr-nota-ant
                         AND item-doc-est.cod-emitente = nota-fiscal.cod-emitente
                         AND item-doc-est.nat-operacao = it-nota-fisc.nat-operacao 
                         AND item-doc-est.sequencia    = it-nota-fisc.nr-seq-ped  NO-LOCK NO-ERROR.
                
                IF AVAIL item-doc-est THEN DO:
                    ASSIGN i-num-ord-import = &if "{&bf_dis_versao_ems}" >= "2.06" &then
                                                  if docum-est.idi-nf-simples-remes = 1 then
                                                      item-doc-est.num-ord-import
                                              &else
                                                  if int(substring(docum-est.char-2,101,1)) = 1 then
                                                     int(substring(item-doc-est.char-2,145,8))
                                              &endif
                                                  else int(it-nota-fisc.cod-ord-compra) no-error.

                    ASSIGN i-parcela = &if "{&bf_dis_versao_ems}" >= "2.06" &then 
                                            if docum-est.idi-nf-simples-remes = 1 then
                                                item-doc-est.num-parc-import
                                       &else
                                            if int(substring(docum-est.char-2,101,1)) = 1 then 
                                                int(substring(item-doc-est.char-2,154,5)) 
                                       &endif
                                            else item-doc-est.parcela.

                    FOR FIRST ordens-embarque NO-LOCK
                        WHERE ordens-embarque.cod-estabel  = nota-fiscal.cod-estabel              
                          AND ordens-embarque.embarque     = TRIM(SUBSTR(nota-fiscal.char-1,1,20))
                          AND ordens-embarque.numero-ordem = i-num-ord-import
                          AND ordens-embarque.parcela      = i-parcela:

                        /* CAMPOS NOVOS LIBERADOS NO PRODUTO
                        adi‡Æo    -> ordens-embarque.char-1,60,4
                        sequencia -> ordens-embarque.char-1,80,4
                        */
        
                        FIND FIRST cotacao-item
                             WHERE cotacao-item.numero-ordem = ordens-embarque.numero-ordem
                               AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.
        
                        CREATE ttImportDocumentAdd.
                        ASSIGN ttImportDocumentAdd.ImportDocumentAddNumber      = INT(SUBSTR(ordens-embarque.char-1,60,4))  /*nr adicao */
                               ttImportDocumentAdd.ImportDocumentAddSequence    = INT(SUBSTR(ordens-embarque.char-1,80,4))  /*sequencia */
                               ttImportDocumentAdd.ImportDocumentManufacturerID = SUBSTRING(cotacao-item.char-2,41,20) WHEN AVAIL cotacao-item.
        
                        /* Chave EMS */
                        ASSIGN ttImportDocumentAdd.ImportDocumentSiteID        = it-nota-fisc.cod-estabel
                               ttImportDocumentAdd.ImportDocumentSeries        = it-nota-fisc.serie
                               ttImportDocumentAdd.ImportDocumentInvoiceNumber = it-nota-fisc.nr-nota-fis
                               ttImportDocumentAdd.ImportDocumentItemCode      = ttDocumentItem.ItemCode
                               ttImportDocumentAdd.ImportDocumentItemSequence  = ttDocumentItem.Sequence.
                    END.
                END.
            END. /* FOR EACH ordens-embarque OF embarque-imp NO-LOCK */
        END.
        /*--- fim Adi‡äes ---*/
    END. /* it-nota-fisc */

    IF VALID-HANDLE (h-boad123a) THEN DO:
       DELETE PROCEDURE h-boad123a.
       ASSIGN h-boad123a = ?.
    END.


END PROCEDURE.

PROCEDURE pi-volume-item: /*Borchardt*/

DEFINE VARIABLE deRatear      AS DECIMAL NO-UNDO.
DEFINE VARIABLE deTotalRateio AS DECIMAL NO-UNDO.

DEFINE BUFFER b-item-embal FOR item-embal.

DEFINE INPUT PARAMETER p-cod-estabel LIKE it-nota-fisc.cod-estabel NO-UNDO.
DEFINE INPUT PARAMETER p-serie       LIKE it-nota-fisc.serie       NO-UNDO.
DEFINE INPUT PARAMETER p-nr-nota-fis LIKE it-nota-fisc.nr-nota-fis NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-it-nota-fisc-volume.
   
   FOR EACH it-nota-fisc NO-LOCK
      WHERE it-nota-fisc.cod-estabel = p-cod-estabel
        AND it-nota-fisc.serie       = p-serie      
        AND it-nota-fisc.nr-nota-fis = p-nr-nota-fis:
       
/*        CREATE tt-it-nota-fisc-volume.                                     */
/*        ASSIGN tt-it-nota-fisc-volume.nr-seq-fat = it-nota-fisc.nr-seq-fat */
/*               tt-it-nota-fisc-volume.it-codigo  = it-nota-fisc.it-codigo  */
/*               tt-it-nota-fisc-volume.volume-rat = 0.                      */


       FOR EACH item-embal NO-LOCK
           WHERE item-embal.cod-estabel = it-nota-fisc.cod-estabel          
             AND item-embal.serie       = it-nota-fisc.serie     
             AND item-embal.nr-nota-fis = it-nota-fisc.nr-nota-fis
             AND item-embal.nr-seq-fat  = it-nota-fisc.nr-seq-fat
             AND item-embal.it-codigo   = it-nota-fisc.it-codigo:


           CREATE tt-it-nota-fisc-volume.                                    
           ASSIGN tt-it-nota-fisc-volume.nr-seq-fat = it-nota-fisc.nr-seq-fat
                  tt-it-nota-fisc-volume.it-codigo  = it-nota-fisc.it-codigo 
                  tt-it-nota-fisc-volume.volume-rat = 0
                  tt-it-nota-fisc-volume.peso-embal = 0.
       
           ASSIGN deRatear     = 0
                 deTotalRateio = 0.
           
           FOR FIRST ITEM  NO-LOCK 
               WHERE ITEM.it-codigo = item-embal.it-codigo:
           END.
       
           CASE SUBSTRING(tab-generica.char-2,641,1):
               WHEN "1" /*volume*/     THEN ASSIGN deRatear = ITEM.altura * ITEM.largura * ITEM.comprim. /* Não precisa converter pois será usado apenas para ratear */
               WHEN "2" /*peso*/       THEN ASSIGN deRatear = ITEM.peso-bruto.
               WHEN "3" /*quantidade*/ THEN ASSIGN deRatear = item-embal.dec-1.
               OTHERWISE                    ASSIGN deRatear = item-embal.dec-1.
           END CASE.

           FOR EACH b-item-embal NO-LOCK 
              WHERE b-item-embal.cod-estabel  = item-embal.cod-estabel          
                AND b-item-embal.serie        = item-embal.serie     
                AND b-item-embal.nr-nota-fis  = item-embal.nr-nota-fis
                AND b-item-embal.sigla-emb    = item-embal.sigla-emb
                AND b-item-embal.int-1        = item-embal.int-1:

               FOR FIRST ITEM  NO-LOCK 
                   WHERE ITEM.it-codigo = item-embal.it-codigo:
               END.

               CASE SUBSTRING(tab-generica.char-2,641,1):
               WHEN "1" THEN ASSIGN deTotalRateio = deTotalRateio + (ITEM.altura * ITEM.largura * ITEM.comprim).  /* Não precisa converter pois será usado apenas para ratear */
               WHEN "2" THEN ASSIGN deTotalRateio = deTotalRateio + ITEM.peso-bruto.
               WHEN "3" THEN ASSIGN deTotalRateio = deTotalRateio + b-item-embal.dec-1.
                   OTHERWISE ASSIGN deTotalRateio = deTotalRateio + b-item-embal.dec-1.
               END CASE.

           END. /* for each b-item-embal */

           FOR FIRST embalag 
               WHERE embalag.sigla-emb = item-embal.sigla-emb NO-LOCK:
                                                                  
               ASSIGN tt-it-nota-fisc-volume.volume-rat = tt-it-nota-fisc-volume.volume-rat + ((embalag.volume / 1000000) * (deRatear / deTotalRateio)). /* conversão para metros cúbicos */


               if substring(tab-generica.char-2,642,1) = "Y" then
                  ASSIGN tt-it-nota-fisc-volume.peso-embal = tt-it-nota-fisc-volume.peso-embal + (embalag.peso-embal * (deRatear / deTotalRateio)).

           END.
                    
       END. /* for each item-embal */
       
    END.    /* for each it-nota-fisc */


    FOR EACH it-nota-fisc NO-LOCK
       WHERE it-nota-fisc.cod-estabel = p-cod-estabel
         AND it-nota-fisc.serie       = p-serie      
         AND it-nota-fisc.nr-nota-fis = p-nr-nota-fis:
    
       IF NOT CAN-FIND (FIRST tt-it-nota-fisc-volume NO-LOCK 
                        WHERE tt-it-nota-fisc-volume.nr-seq-fat = it-nota-fisc.nr-seq-fat  
                        AND   tt-it-nota-fisc-volume.it-codigo  = it-nota-fisc.it-codigo) THEN DO:


           FOR EACH nota-embal NO-LOCK WHERE
                    nota-embal.cod-estabel = it-nota-fisc.cod-estabel AND
                    nota-embal.serie       = it-nota-fisc.serie       AND
                    nota-embal.nr-nota-fis = it-nota-fisc.nr-nota-fis:

              FIND FIRST embalag NO-LOCK WHERE 
                         embalag.sigla = nota-embal.sigla-emb NO-ERROR.
              IF embalag.ind-detemb = 2 THEN NEXT.


               CREATE tt-it-nota-fisc-volume.                                    
               ASSIGN tt-it-nota-fisc-volume.nr-seq-fat = it-nota-fisc.nr-seq-fat
                      tt-it-nota-fisc-volume.it-codigo  = it-nota-fisc.it-codigo 
                      tt-it-nota-fisc-volume.volume-rat = 0
                       tt-it-nota-fisc-volume.peso-embal = 0. 

              ASSIGN deRatear = 0 
                     deTotalRateio = 0.
 
           
              FOR FIRST ITEM  NO-LOCK 
                WHERE ITEM.it-codigo = it-nota-fisc.it-codigo:
              END.

              CASE SUBSTRING(tab-generica.char-2,641,1):
                   WHEN "1" /*volume*/     THEN ASSIGN deRatear = ITEM.altura * ITEM.largura * ITEM.comprim. /* Não precisa converter pois será usado apenas para ratear */
                   WHEN "2" /*peso*/       THEN ASSIGN deRatear = ITEM.peso-bruto.
                   WHEN "3" /*quantidade*/ THEN ASSIGN deRatear = 0.
                   OTHERWISE                    ASSIGN deRatear = 0.
              END CASE.

             FOR EACH bf-nota-embal NO-LOCK WHERE
                      bf-nota-embal.cod-estabel = nota-embal.cod-estabel AND
                      bf-nota-embal.serie       = nota-embal.serie       AND
                      bf-nota-embal.nr-nota-fis = nota-embal.nr-nota-fis and
                      bf-nota-embal.sigla-emb   = nota-embal.sigla-emb:

                  CASE SUBSTRING(tab-generica.char-2,641,1):
                       WHEN "1" THEN ASSIGN deTotalRateio = deTotalRateio + (ITEM.altura * ITEM.largura * ITEM.comprim).  /* Não precisa converter pois será usado apenas para ratear */
                       WHEN "2" THEN ASSIGN deTotalRateio = deTotalRateio + ITEM.peso-bruto.
                       WHEN "3" THEN ASSIGN deTotalRateio = deTotalRateio + b-item-embal.dec-1.
                       OTHERWISE ASSIGN deTotalRateio = deTotalRateio + b-item-embal.dec-1.
                  END CASE. 
    
                  ASSIGN tt-it-nota-fisc-volume.volume-rat = tt-it-nota-fisc-volume.volume-rat + ((embalag.volume / 1000000) * (deRatear / deTotalRateio)). /* conversão para metros cúbicos */ 

                  if substring(tab-generica.char-2,642,1) = "Y" then
                    ASSIGN tt-it-nota-fisc-volume.peso-embal = tt-it-nota-fisc-volume.peso-embal + (embalag.peso-embal * (deRatear / deTotalRateio)).

             END.
           END.
       END.  /* if not can-find */  

    END. /* for each it-nota-fisc */

/*     IF  tt-it-nota-fisc-volume.volume-rat = 0  THEN DO:                                                                                            */
/*         FOR  FIRST ITEM  NO-LOCK                                                                                                                   */
/*              WHERE ITEM.it-codigo = item-embal.it-codigo:                                                                                          */
/*                                                                                                                                                    */
/*              ASSIGN tt-it-nota-fisc-volume.volume-rat = (ITEM.altura * ITEM.largura * ITEM.comprim) / 1000000. /* conversão para metros cúbicos */ */
/*                                                                                                                                                    */
/*         END.                                                                                                                                       */
/*                                                                                                                                                    */
/*     END.                                                                                                                                           */

END PROCEDURE.

PROCEDURE pi-ped-curva:

    DEFINE INPUT PARAMETER c-conta  AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER de-valor AS DECIMAL NO-UNDO.

    /*{ftp/ft0904l.i "c-conta" "de-valor" "it-nota-fisc.cod-unid-negoc"}*/
    IF NOT AVAIL param-global THEN
      find first param-global no-lock no-error.

    &if "{&bf_dis_versao_ems}" >= "2.062" &then
    /*** Se a fun‡Æo de unidade de neg¢cio estiver ativa, gera tt-ped-curva com base na unidade de negocio. ***/
    IF  l-unidade-negocio  AND AVAIL b-nota-fiscal THEN
        FIND tt-ped-curva
            WHERE tt-ped-curva.it-codigo      = b-nota-fiscal.cod-estabel 
              AND tt-ped-curva.serie          = b-nota-fiscal.serie
              AND tt-ped-curva.nr-nota-fis    = b-nota-fiscal.nr-nota-fis
              AND tt-ped-curva.codigo         = c-conta
              AND tt-ped-curva.cod-unid-negoc = b-it-nota-fisc.cod-unid-negoc NO-LOCK NO-ERROR.
    ELSE
    &endif
    
    IF AVAIL b-nota-fiscal THEN DO: 
        find tt-ped-curva where 
             tt-ped-curva.it-codigo    = b-nota-fiscal.cod-estabel  
         and tt-ped-curva.serie        = b-nota-fiscal.serie                
         and tt-ped-curva.nr-nota-fis  = b-nota-fiscal.nr-nota-fis 
         and tt-ped-curva.codigo       = c-conta no-lock no-error.
        if not avail tt-ped-curva then do: 
           create tt-ped-curva.
           assign tt-ped-curva.it-codigo   = b-nota-fiscal.cod-estabel
                  tt-ped-curva.serie       = b-nota-fiscal.serie
                  tt-ped-curva.nr-nota-fis = b-nota-fiscal.nr-nota-fis
                  tt-ped-curva.codigo      = c-conta
                  i-empresa = param-global.empresa-prin.
        
            &if "{&bf_dis_versao_ems}" >= "2.062" &then
            /*** Se a fun‡Æo de unidade de neg¢cio estiver ativa, gera tt-ped-curva com base na unidade de negocio. ***/
            IF  l-unidade-negocio THEN
                ASSIGN tt-ped-curva.cod-unid-negoc = b-it-nota-fisc.cod-unid-negoc .
            &endif
        
           &if defined (bf_dis_consiste_conta) &then
              IF NOT AVAIL estabelec OR
                           estabelec.cod-estabel <> b-nota-fiscal.cod-estabel THEN
              find first estabelec where estabelec.cod-estabel = b-nota-fiscal.cod-estabel no-lock no-error.
              run cdp/cd9970.p (input rowid(estabelec), output i-empresa). 
           &endif
           find conta-contab where
                conta-contab.ep-codigo      = i-empresa and
                conta-contab.conta-contabil = c-conta no-lock no-error.
           assign tt-ped-curva.desc-conta = if not avail conta-contab then c-desc-conta 
                                            else conta-contab.titulo.  
        end.
    END.
    IF AVAIL tt-ped-curva THEN DO:
        assign tt-ped-curva.dec-1 = tt-ped-curva.dec-1 + de-valor.
        if tt-ped-curva.dec-1 < 0 then
            assign tt-ped-curva.vl-debito  = -(tt-ped-curva.dec-1)
                   tt-ped-curva.vl-credito = 0.
        else 
            assign tt-ped-curva.vl-credito = tt-ped-curva.dec-1
                   tt-ped-curva.vl-debito  = 0.
    END.

    /* FT0904l.I */


END PROCEDURE.

PROCEDURE piSendInvoiceDocument:
    DEF INPUT PARAM TABLE FOR ttInvoiceDocument.
END PROCEDURE.

PROCEDURE piSendInvoiceDocumentAux:
    DEF INPUT PARAM TABLE FOR ttInvoiceDocumentAux.
END PROCEDURE.

procedure pisendinvoicedocumentitem:
    DEF INPUT PARAM TABLE FOR ttDocumentItem.
END PROCEDURE.

PROCEDURE piSendDocumentTax:
    DEF INPUT PARAM TABLE FOR ttDocumentTax.
END PROCEDURE.

PROCEDURE piSendDevolutionDocument:
    DEF INPUT PARAM TABLE FOR ttDevolutionDocument.
END PROCEDURE.

PROCEDURE piSendDocumentBill:
    DEF INPUT PARAM TABLE FOR ttDocumentBill.
END PROCEDURE.

PROCEDURE piSendPackaging:
    DEF INPUT PARAM TABLE FOR ttPackaging.
END PROCEDURE.

PROCEDURE piSendPackingSlip:
    DEF INPUT PARAM TABLE FOR ttPackingSlip.
END PROCEDURE.

PROCEDURE piSendRepresentative:
    DEF INPUT PARAM TABLE FOR ttRepresentative.
END PROCEDURE.

PROCEDURE piSendTerm:
    DEF INPUT PARAM TABLE FOR ttTerm.
END PROCEDURE.

PROCEDURE piSendDiscount:
    DEF INPUT PARAM TABLE FOR ttDiscount.
END PROCEDURE.

PROCEDURE piSendDiscountTableValue:
    DEF INPUT PARAM TABLE FOR ttDiscountTableValue.
END PROCEDURE.

PROCEDURE piSendIssuedLocation:
    DEF INPUT PARAM TABLE FOR ttIssuedLocation.
END PROCEDURE.

PROCEDURE piSendBusinessUnit:
    DEF INPUT PARAM TABLE FOR ttBusinessUnit.
END PROCEDURE.

PROCEDURE piSendDocumentAddInformation:
    DEF INPUT PARAM TABLE FOR ttInvoiceDocumentAddInformation.
END PROCEDURE.

PROCEDURE piSendImportDocument:
    DEF INPUT PARAM TABLE FOR ttImportDocument.
END PROCEDURE.

PROCEDURE piSendImportDocumentAdd:
    DEF INPUT PARAM TABLE FOR ttImportDocumentAdd.
END PROCEDURE.

PROCEDURE piSendDocumentItemVehicle:
    DEF INPUT PARAM TABLE FOR ttDocumentItemVehicle.
END PROCEDURE.  

PROCEDURE piSendDocumentItemMedicine:
    DEF INPUT PARAM TABLE FOR ttDocumentItemMedicine.
END PROCEDURE.  

PROCEDURE piSendDocumentItemFuel:
    DEF INPUT PARAM TABLE FOR ttDocumentItemFuel.
END PROCEDURE. 
               
PROCEDURE piSendInvoiceDocumentAddInformation:
    DEF INPUT PARAM TABLE FOR ttInvoiceDocumentAddInformation.
END PROCEDURE.

PROCEDURE piSendAddInformationTaxPayer:
    DEF INPUT PARAM TABLE FOR ttAddInformationTaxPayer.
END PROCEDURE. 

PROCEDURE piSendAddInformationTaxComment:
    DEF INPUT PARAM TABLE FOR ttAddInformationTaxComment.
END PROCEDURE. 

PROCEDURE piSendReferencedProcess:
    DEF INPUT PARAM TABLE FOR ttReferencedProcess.
END PROCEDURE.            

/***/

PROCEDURE pireturninvoicedocumentitem:
    DEF OUTPUT PARAM TABLE FOR ttDocumentItem.
END PROCEDURE.
PROCEDURE pi-calc-zona-franca.

    ASSIGN de-vl-unit  = 0
           de-vl-total = 0.

    
    ASSIGN  de-qt-fatur = if   it-nota-fisc.ind-fat-qtfam = no 
                          then it-nota-fisc.qt-faturada[1]
                          else it-nota-fisc.qt-faturada[2].


       find first cidade-zf where cidade-zf.cidade = nota-fiscal.cidade
            and   cidade-zf.estado = nota-fiscal.estado no-lock no-error.

       IF AVAIL cidade-zf AND AVAIL natur-oper THEN DO:
        
           ASSIGN r-cidade-zf = ROWID(cidade-zf).
           
           IF trim(substr(it-nota-fisc.char-1,461,5)) <> "" THEN
               ASSIGN de-conv = (100 - dec(substr(it-nota-fisc.char-1,461,5))) / 100.
           ELSE
               ASSIGN de-conv = (100 - dec(substr(natur-oper.char-2,66,5))) / 100.

       END.
      
        IF AVAIL natur-oper THEN DO:

            &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
                
                        if  avail cidade-zf 
                         and (dec(substr(it-nota-fisc.char-1,461,5)) > 0 OR 
                             natur-oper.val-perc-desc-pis-zfm    > 0 OR
                             natur-oper.val-perc-desc-cofins-zfm > 0) THEN
                            
                             assign de-conv-total = (100 - (dec(substr(it-nota-fisc.char-1,461,5)) +
                                                           natur-oper.val-perc-desc-pis-zfm    +
                                                           natur-oper.val-perc-desc-cofins-zfm)) / 100.
            &ELSE
                         
                        if  avail cidade-zf 
                        and (dec(substr(it-nota-fisc.char-1,461,5)) > 0 OR 
                             dec(substr(natur-oper.char-1,110,8)) > 0 OR
                             dec(substr(natur-oper.char-1,118,8)) > 0) THEN
                            
                             assign de-conv-total = (100 - (dec(substr(it-nota-fisc.char-1,461,5))  + 
                                                           dec(substr(natur-oper.char-1,110,8)) + 
                                                           dec(substr(natur-oper.char-1,118,8)))) / 100.
                
            &ENDIF
        END.
                
        /*inicio zfm*/    
        IF  r-cidade-zf <> ? THEN DO: 
                &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
                    IF  natur-oper.log-deduz-desc-zfm-tot-nf THEN
                        ASSIGN de-vl-unit  = DEC(STRING(it-nota-fisc.vl-preuni / de-conv-total, ">>>,>>>,>>9.99"))
                               de-vl-total = DEC(STRING((it-nota-fisc.vl-preuni / de-conv-total * de-qt-fatur), ">>>>>,>>>,>>9.99")).
                    ELSE
                        ASSIGN de-vl-unit  = DEC(STRING(it-nota-fisc.vl-preuni   / de-conv, ">>>,>>>,>>9.99"))  
                               de-vl-total = DEC(STRING(it-nota-fisc.vl-merc-liq / de-conv, ">>>>>,>>>,>>9.99")).
                &ELSE
                    IF  SUBSTRING(natur-oper.char-1,109,1) = "S" THEN
                        ASSIGN de-vl-unit  = it-nota-fisc.vl-preuni / de-conv-total
                               de-vl-total = ROUND((it-nota-fisc.vl-preuni / de-conv-total),2) * de-qt-fatur.
                    ELSE
                        ASSIGN de-vl-unit  = it-nota-fisc.vl-preuni   / de-conv
                               de-vl-total = it-nota-fisc.vl-merc-liq / de-conv.
                &ENDIF
                   
                IF  it-nota-fisc.aliquota-ipi <> 0  OR it-nota-fisc.vl-ipi-it    <> 0  OR  nota-fiscal.esp-docto     <> 20 THEN
                    IF  it-nota-fisc.vl-despes-it > 0 AND 
                        it-nota-fisc.vl-ipi-it    > 0 AND 
                        it-nota-fisc.cd-trib-ipi <> 3 THEN DO:

                        {ftp/ft0513.i1}  /* Determina valor do IPI */

                        &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
                             
                              IF  natur-oper.log-deduz-desc-zfm-tot-nf THEN
                                  ASSIGN de-vl-ipi-it = de-vl-ipi-it / de-conv-total.
                              ELSE
                                  ASSIGN de-vl-ipi-it = de-vl-ipi-it / de-conv.

                        &ELSE
                              IF  SUBSTRING(natur-oper.char-1,109,1) = "S" THEN
                                  ASSIGN de-vl-ipi-it = de-vl-ipi-it / de-conv-total.
                              ELSE
                                  ASSIGN de-vl-ipi-it = de-vl-ipi-it / de-conv.
                        &ENDIF
                    END.
                    ELSE
                        IF it-nota-fisc.cd-trib-ipi <> 3 THEN DO:
                           &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
                           
                                 IF  natur-oper.log-deduz-desc-zfm-tot-nf THEN
                                     ASSIGN de-vl-ipi-it = it-nota-fisc.vl-ipi-it / de-conv-total.
                                 ELSE
                                     ASSIGN de-vl-ipi-it = it-nota-fisc.vl-ipi-it / de-conv.
                           &ELSE
                                 IF  SUBSTRING(natur-oper.char-1,109,1) = "S" THEN
                                     ASSIGN de-vl-ipi-it = it-nota-fisc.vl-ipi-it / de-conv-total.
                                 ELSE
                                     ASSIGN de-vl-ipi-it = it-nota-fisc.vl-ipi-it / de-conv.
                           &ENDIF
                END.

                
        END. /*Fim ZFM*/

END PROCEDURE.

/*
PROCEDURE pi-retorna-perc-item-emb: /*Percentuais do item na embalagem*/

    DEF INPUT PARAM iTpRateio AS INT NO-UNDO.
    DEF INPUT PARAM cCod-item AS CHAR NO-UNDO.
    DEF OUTPUT PARAM dePercRateio AS DEC NO-UNDO.

    DEF VAR decVolumeItem AS DEC NO-UNDO.
    DEF VAR deTotalVolumeItem AS DEC NO-UNDO.
    DEF VAR decTotalPeso       as dec no-undo.
    DEF VAR decTotalQuantidade as dec no-undo.

    DEF VAR dAuxVolume AS DEC NO-UNDO.
    DEF VAR dAuxPeso   AS DEC NO-UNDO.
    DEF VAR dAuxQuant  AS DEC NO-UNDO.

    DEF VAR i-tot-vol AS INT NO-UNDO.

    
    /* it-nota-fisc */
    /* item */

    /* item-embal.dec-1 -> qtde. embalada */

 
   FOR EACH bf-item-embal NO-LOCK WHERE
            bf-item-embal.cod-estabel = it-nota-fisc.cod-estabel  and
            bf-item-embal.serie       = it-nota-fisc.serie        and
            bf-item-embal.nr-nota-fis = it-nota-fisc.nr-nota-fis  
            BREAK BY bf-item-embal.it-codigo
                  BY bf-item-embal.int-1: /*número da embalagem*/

       FOR FIRST bf-ITEM  NO-LOCK 
            WHERE bf-ITEM.it-codigo = bf-item-embal.it-codigo: END.

       IF FIRST-OF(bf-item-embal.int-1) THEN DO:
           EMPTY TEMP-TABLE tt-rateio-emb-aux.
           ASSIGN decTotalPeso        = 0
                  decTotalQuantidade  = 0
                  decVolumeItem       = 0
                  deTotalVolumeItem   = 0
                  dAuxVolume          = 0  
                  dAuxPeso            = 0
                  dAuxQuant           = 0.
       END.

       /*Quantidade de volumes - item*/
       if first-of(bf-item-embal.it-codigo) then
           assign i-tot-vol = 1. 
       else
           assign i-tot-vol = i-tot-vol + 1. 
  
       IF NOT CAN-FIND(FIRST tt-rateio-emb-aux NO-LOCK WHERE
                             tt-rateio-emb-aux.nr-seq-fat = bf-item-embal.nr-seq-fat AND       
                             tt-rateio-emb-aux.it-codigo  = bf-item-embal.it-codigo  AND 
                             tt-rateio-emb-aux.nr-embalagem = bf-item-embal.int-1) THEN DO:

           /*tt-rateio*/
           CREATE tt-rateio-emb-aux.
           ASSIGN tt-rateio-emb-aux.nr-seq-fat = bf-item-embal.nr-seq-fat
                  tt-rateio-emb-aux.it-codigo  = bf-item-embal.it-codigo
                  tt-rateio-emb-aux.nr-embalagem = bf-item-embal.int-1
                  tt-rateio-emb-aux.tot-peso     = bf-item-embal.dec-1 * bf-ITEM.peso-bruto
                  tt-rateio-emb-aux.tot-valor    = bf-item-embal.dec-1 * bf-ITEM.valor
                  tt-rateio-emb-aux.tot-qt       = bf-item-embal.dec-1  /* dec-1 -> qt-embalada */
                  tt-rateio-emb-aux.tot-m3       = bf-item-embal.dec-1 * bf-ITEM.altura * bf-ITEM.largura * bf-ITEM.comprim / 1000000 .
       END.
       ELSE DO:
           ASSIGN tt-rateio-emb-aux.tot-peso     = tt-rateio-emb-aux.tot-peso  + (bf-item-embal.dec-1 * bf-ITEM.peso-bruto)
                  tt-rateio-emb-aux.tot-valor    = tt-rateio-emb-aux.tot-valor + (bf-item-embal.dec-1 * bf-ITEM.valor)
                  tt-rateio-emb-aux.tot-qt       = tt-rateio-emb-aux.tot-qt    + (bf-item-embal.dec-1)  /* dec-1 -> qt-embalada */
                  tt-rateio-emb-aux.tot-m3       = tt-rateio-emb-aux.tot-m3    + (bf-item-embal.dec-1 * bf-ITEM.altura * bf-ITEM.largura * bf-ITEM.comprim / 1000000) .
       END.

       /*Peso, volume e quantidade de itens na embalaquem*/
       ASSIGN decTotalPeso       = decTotalPeso       + (item-embal.dec-1 * bf-ITEM.peso-bruto)
              decTotalQuantidade = decTotalQuantidade + bf-item-embal.dec-1.

       ASSIGN decVolumeItem = (bf-ITEM.altura * bf-ITEM.largura * bf-ITEM.comprim) / 1000000.
                                      
       ASSIGN deTotalVolumeItem =  deTotalVolumeItem + (item-embal.dec-1 * decVolumeItem).
       /*Peso, volume e quantidade de itens na embalaquem*/

       IF LAST-OF(bf-item-embal.int-1) THEN DO:
           /* rateia para os itens na mesma embalagem */
           FOR EACH tt-rateio-emb-aux
               BREAK BY tt-rateio-emb-aux.nr-embalagem:
    
               ASSIGN dAuxVolume = dAuxVolume + tt-rateio-emb-aux.tot-m3
                      dAuxPeso   = dAuxPeso   + tt-rateio-emb-aux.tot-peso
                      dAuxQuant  = dAuxQuant  + tt-rateio-emb-aux.tot-qt.
    
               IF LAST-OF(tt-rateio-emb-aux.nr-embalagem) THEN DO:
                   IF iTpRateio = 1 THEN   /*volume*/                                                  
                       ASSIGN dePercRateio = dAuxVolume /  deTotalVolumeItem.          
                   ELSE IF iTpRateio = 2 THEN       /*peso*/                                         
                       ASSIGN dePercRateio = dAuxPeso / decTotalPeso.       
                   ELSE IF iTpRateio = 3 THEN      /*quantidade*/                                       
                       ASSIGN dePercRateio = dAuxQuant / decTotalQuantidade.
    
               END.
    
           END.
       END.

       /*Quantidade de volumes - item*/
       if last-of(bf-item-embal.it-codigo) then do:
           ASSIGN dePercRateio = dePercRateio * i-tot-vol. /*multiplica o percentual pela quantidade de volumes do item*/
       end.

   END.

   RETURN 'ok'.

END.*/


