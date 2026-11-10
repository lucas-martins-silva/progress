{cdp/cdcfgdis.i}

DEFINE TEMP-TABLE ttDocumentItem NO-UNDO
     FIELD AccountNumber                    AS CHARACTER INITIAL ?  /*Número da conta. (Uso interno: Campo = movind.item-doc-est.ct-codigo)*/
     FIELD APStatus                         AS integer INITIAL ?  /*Situação do ítem em relação a entrada da fatura no Contas Pagar. Valores: 1 - OK, 2 - Aguardando Fatura/Remito, 3 - Com problemas, 4 - Parcialmente Atendido, 5 - Aguardando Conciliação Batch. (Uso interno: Campo = movind.item-doc-est.sit-item - Include = ininc/i01in176.i)*/
     FIELD BalanceQuantity                  AS decimal INITIAL ?  /*Quatidade saldo. (Uso interno: Campo = movind.item-doc-est.qt-saldo)*/
     FIELD BinLocationDescription           AS CHARACTER INITIAL ?  /*Descrição da localização do material. (Uso interno: Campo = mgind.localizacao.descricao)*/
     FIELD BinLocationID                    AS CHARACTER INITIAL ?  /*Código da localização do material. (Uso interno: Campo = movind.item-doc-est.cod-localiz)*/
     FIELD CheckedQuantity                  AS decimal INITIAL ?  /*Quantidade conferida. (Uso interno: Campo = movind.item-doc-est.quant-conf)*/
     FIELD CMCACCurrentRate                 AS decimal INITIAL ?  /*Cotação atual moeda CMCAC. (Uso interno: Campo = movind.item-doc-est.cotacao-cmi)*/
     FIELD ContactName                      AS CHARACTER INITIAL ?  /*Nome do contato. (Uso interno: Campo = mgadm.cont-emit.nome)*/
     FIELD ContactName_00                   AS CHARACTER INITIAL ?  /*Nome do contato. (Uso interno: Campo = mgadm.cont-emit.nome)*/
     FIELD ContactName_01                   AS CHARACTER INITIAL ?  /*Nome do contato. (Uso interno: Campo = mgadm.cont-emit.nome)*/
     FIELD ContactSequence                  AS integer INITIAL ?  /*Sequencia contato. (Uso interno: Campo = mgadm.cont-emit.num-seq-cont-emit)*/
     FIELD ContactSequence_00               AS integer INITIAL ?  /*Sequencia contato. (Uso interno: Campo = mgadm.cont-emit.num-seq-cont-emit)*/
     FIELD ContactSequence_01               AS integer INITIAL ?  /*Sequencia contato. (Uso interno: Campo = mgadm.cont-emit.num-seq-cont-emit)*/
     FIELD CustomerOrderNumber              AS CHARACTER INITIAL ?  /*Número do pedido do cliente. (Uso interno: Campo = movind.item-doc-est.nr-pedcli)*/
     FIELD CustomerVendorID                 AS integer INITIAL ?  /*Código interno de identificação do emitente. (Uso interno: Campo = movind.item-doc-est.cod-emit-terc)*/
     FIELD CustomerVendorShortName          AS CHARACTER INITIAL ?  /*Nome abreviado do fornecedor. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
     FIELD CustomerVendorTaxID              AS CHARACTER INITIAL ?  /*CGC do fornecedor. (Uso interno: Campo = mgadm.emitente.cgc)*/
     FIELD DeliverySequence                 AS integer INITIAL ?  /*Numero da sequencia de entrega do pedido do cliente. (Uso interno: Campo = movind.item-doc-est.nr-pd-ent)*/
     FIELD DiscountValue                    AS decimal INITIAL ?  /*Valor total dos descontos concedidos ao item. (Uso interno: Campo = movind.item-doc-est.desconto[1])*/
     FIELD DiscountValue_00                 AS decimal INITIAL ?  /*Valor total dos descontos concedidos ao item. (Uso interno: Campo = movind.item-doc-est.desconto[2])*/
     FIELD DiscountValue_01                 AS decimal INITIAL ?  /*Valor total dos descontos concedidos ao item. (Uso interno: Campo = movind.item-doc-est.desconto-cmi)*/
     FIELD DiscountValue_02                 AS decimal INITIAL ?  /*Valor total dos descontos concedidos ao item. (Uso interno: Campo = movind.item-doc-est.desconto-me)*/
     FIELD DocumentNumber                   AS CHARACTER INITIAL ?  /*Número do documento origem. (Uso interno: Campo = movind.item-doc-est.nro-comp)*/
     FIELD DocumentNumber_00                AS CHARACTER INITIAL ?  /*Número da nota fiscal de entrega das mercadorias. (Uso interno: Campo = movind.item-doc-est.nro-docto-terc)*/
     FIELD DocumentSeries                   AS CHARACTER INITIAL ?  /*Série do documento origem. (Uso interno: Campo = movind.item-doc-est.serie-comp)*/
     FIELD DocumentSeries_00                AS CHARACTER INITIAL ?  /*Série da nota fiscal de entrega das mercadorias. (Uso interno: Campo = movind.item-doc-est.serie-terc)*/
     FIELD EmailAddress                     AS CHARACTER INITIAL ?  /*E-mail do contato. (Uso interno: Campo = mgadm.cont-emit.e-mail)*/
     FIELD EmailAddress_00                  AS CHARACTER INITIAL ?  /*E-mail do contato. (Uso interno: Campo = mgadm.cont-emit.e-mail)*/
     FIELD EmailAddress_01                  AS CHARACTER INITIAL ?  /*E-mail do contato. (Uso interno: Campo = mgadm.cont-emit.e-mail)*/
     FIELD ExpenseValue                     AS decimal INITIAL ?  /*Valor total das despesas do item. (Uso interno: Campo = movind.item-doc-est.despesas[1])*/
     FIELD ExpenseValue_00                  AS decimal INITIAL ?  /*Valor total das despesas do item. (Uso interno: Campo = movind.item-doc-est.despesas[2])*/
     FIELD ExpenseValue_01                  AS decimal INITIAL ?  /*Valor total das despesas do item. (Uso interno: Campo = movind.item-doc-est.despesas-cmi)*/
     FIELD ExpenseValue_02                  AS decimal INITIAL ?  /*Valor total das despesas do item. (Uso interno: Campo = movind.item-doc-est.despesas-me)*/
     FIELD FASBCurrentRate                  AS decimal INITIAL ?  /*Cotação atual moeda FASB. (Uso interno: Campo = movind.item-doc-est.cotacao-fasb)*/
     FIELD FiscalClassificationDescription  AS CHARACTER INITIAL ?  /*Descrição da classificação fiscal. (Uso interno: Campo = mgind.classif-fisc.descricao)*/
     FIELD FiscalClassificationID           AS CHARACTER INITIAL ?  /*Código da classificação fiscal. (Uso interno: Campo = movind.item-doc-est.class-fiscal)*/
     FIELD FiscalOperationCode              AS CHARACTER INITIAL ?  /*Código natureza de operação. (Uso interno: Campo = movind.item-doc-est.nat-comp)*/
     FIELD FiscalOperationCode_00           AS CHARACTER INITIAL ?  /*Código natureza de operação. (Uso interno: Campo = movind.item-doc-est.nat-terc)*/
     FIELD FiscalOperationDescription       AS CHARACTER INITIAL ?  /*Descrição da natureza de operação. (Uso interno: Campo = mgind.natur-oper.denominacao)*/
     FIELD FiscalOperationDescription_00    AS CHARACTER INITIAL ?  /*Descrição da natureza de operação. (Uso interno: Campo = mgind.natur-oper.denominacao)*/
     FIELD ForecastDeliveryDate             AS date INITIAL ?  /*Data de entrega prevista. (Uso interno: Campo = movind.item-doc-est.dt-ent-prev)*/
     FIELD FreightValue                     AS decimal INITIAL ?  /*Valor total das despesas com frete. (Uso interno: Campo = movind.item-doc-est.valor-frete)*/
     FIELD FreightValue_00                  AS decimal INITIAL ?  /*Valor total das despesas com frete. (Uso interno: Campo = movind.item-doc-est.valor-frete-me)*/
     FIELD ImportationStatement             AS CHARACTER INITIAL ?  /*Declaração de importação.(Uso interno: Campo = movind.item-doc-est.declaracao-import)*/
     FIELD ImportLicenseNumber              AS integer INITIAL ?  /*Informe o número da guia de importação. (Uso interno: Campo = movind.item-doc-est.i-nr-gi)*/
     FIELD ImportProcessNumber              AS CHARACTER INITIAL ?  /*Número do processo de importação. (Uso interno: Campo = movind.item-doc-est.nr-proc-imp)*/
     FIELD InspectionRouteNumber            AS integer INITIAL ?  /*Número do roteiro de inspeção de qualidade. (Uso interno: Campo = movind.item-doc-est.nr-ficha)*/
     FIELD InvoiceNumber                    AS CHARACTER INITIAL ?  /*Número invoice. (Uso interno: Campo = movind.item-doc-est.c-nr-invoice)*/
     FIELD InvoiceSequence                  AS integer INITIAL ?  /*Seqüência Invoice. (Uso interno: Campo = movind.item-doc-est.i-seq-inv)*/
     FIELD IsComponent                      AS LOGICAL INITIAL ?  /*Indica, no beneficiamento, se o item é componente ou nao. (Uso interno: Campo = movind.item-doc-est.componente)*/
     FIELD IsCreditDocumentCreatedInAP      AS LOGICAL INITIAL ?  /*Indica a geração de nota de crédito no contas a pagar. (Uso interno: Campo = movind.item-doc-est.log-geracao-ncr-ap)*/
     FIELD IsCustomerOrderReopenedByDocu_00 AS LOGICAL INITIAL ?  /*Indica se o pedido do cliente deve ou não ser reaberto. (Uso interno: Campo = movind.item-doc-est.reabre-pd)*/
     FIELD IsFIFOAppliedToPurchaseRequis_00 AS LOGICAL INITIAL ?  /*Indica se as quantidades do item do documento serão alocadas para as parcelas das ordens de compra do fornecedor, da mais antiga para a mais recente até completar a quantidade recebida. (Uso interno: Campo = movind.item-doc-est.log-fifo-oc)*/
     FIELD IssueDocumentDate                AS date INITIAL ?  /*Data de emissão da nota fiscal de venda ou de envio para beneficiamento / consiguinação, que deu origem ao documento. (Uso interno: Campo = movind.item-doc-est.data-comp)*/
     FIELD IsTaxWithholded                  AS LOGICAL INITIAL ?  /*ICMS retido na fonte. (Uso interno: Campo = movind.item-doc-est.log-icm-retido)*/
     FIELD ItemCode                         AS CHARACTER INITIAL ?  /*Código do item. (Uso interno: Campo = movind.item-doc-est.it-codigo)*/
     FIELD ItemDescription                  AS CHARACTER INITIAL ?  /*Descrição do item. (Uso interno: Campo = mgind.item.desc-item)*/
     FIELD ItemReferenceCode                AS CHARACTER INITIAL ?  /*Código de Referência do item. (Uso interno: Campo = movind.item-doc-est.cod-refer)*/
     FIELD LaborValue                       AS decimal INITIAL ?  /*Preço de mão-de-obra. (Uso interno: Campo = movind.item-doc-est.pre-unit-mob[1])*/
     FIELD LaborValue_00                    AS decimal INITIAL ?  /*Preço de mão-de-obra. (Uso interno: Campo = movind.item-doc-est.pre-unit-mob[2])*/
     FIELD LaborValue_01                    AS decimal INITIAL ?  /*Preço de mão-de-obra. (Uso interno: Campo = movind.item-doc-est.pr-mob-cmi)*/
     FIELD LotOrSerialNumber                AS CHARACTER INITIAL ?  /*Número do lote ou número de série do item. Elemento obigatório para itens controlados por lote, referencia ou número de série. (Uso interno: Campo = movind.item-doc-est.lote)*/
     FIELD LotValidityDate                  AS date INITIAL ?  /*Data de validade do lote informado. (Uso interno: Campo = movind.item-doc-est.dt-vali-lote)*/
     FIELD Manufacturer                     AS INTEGER INITIAL ? /*C¢digo do Fabricante de Medicamento*/
     FIELD ManufacturingOrderNumber         AS integer INITIAL ?  /*Número da ordem de produção que originou a solicitação de compra do item. (Uso interno: Campo = movind.item-doc-est.nr-ord-produ)*/
     FIELD Narrative                        AS CHARACTER INITIAL ?  /*Narrativa / Observações. (Uso interno: Campo = movind.item-doc-est.narrativa)*/
     FIELD NetWeight                        AS decimal INITIAL ?  /*Peso liquido do item. (Uso interno: Campo = movind.item-doc-est.peso-liquido)*/
     FIELD NotTaxedValue                    AS decimal INITIAL ?  /*Valor da base de cálculo do IPI não tributado. (Uso interno: Campo = movind.item-doc-est.ipi-ntrib[1])*/
     FIELD NotTaxedValue_00                 AS decimal INITIAL ?  /*Valor da base de cálculo do ISS não tributado. (Uso interno: Campo = movind.item-doc-est.iss-ntrib[1])*/
     FIELD NotTaxedValue_01                 AS decimal INITIAL ?  /*Valor da base de cálculo do ICMS não tributado. (Uso interno: Campo = movind.item-doc-est.icm-ntrib[1])*/
     FIELD NotTaxedValue_02                 AS decimal INITIAL ?  /*Valor da base de cálculo do IPI não tributado. (Uso interno: Campo = movind.item-doc-est.ipi-ntrib[2])*/
     FIELD NotTaxedValue_03                 AS decimal INITIAL ?  /*Valor da base de cálculo do ISS não tributado. (Uso interno: Campo = movind.item-doc-est.iss-ntrib[2])*/
     FIELD NotTaxedValue_04                 AS decimal INITIAL ?  /*Valor da base de cálculo do ICMS não tributado. (Uso interno: Campo = movind.item-doc-est.icm-ntrib[2])*/
     FIELD NotTaxedValue_05                 AS decimal INITIAL ?  /*Valor da base de cálculo do IPI não tributado. (Uso interno: Campo = movind.item-doc-est.ipi-ntr-cmi*/
     FIELD NotTaxedValue_06                 AS decimal INITIAL ?  /*Valor da base de cálculo do ISS não tributado. (Uso interno: Campo = movind.item-doc-est.iss-ntr-cmi)*/
     FIELD NotTaxedValue_07                 AS decimal INITIAL ?  /*Valor da base de cálculo do ICMS não tributado. (Uso interno: Campo = movind.item-doc-est.icm-ntr-cmi)*/
     FIELD OrderLine                        AS integer INITIAL ?  /*Numero sequencial do item no pedido do cliente. (Uso interno: Campo = movind.item-doc-est.nr-pd-seq)*/
     FIELD OrderOperationCode               AS integer INITIAL ?  /*Código da operação. (Uso interno: Campo = movind.item-doc-est.op-codigo)*/
     FIELD ParentItemCode                   AS CHARACTER INITIAL ?  /*Código do item pai. (Uso interno: Campo = movind.item-doc-est.item-pai)*/
     FIELD ParentItemDescription            AS CHARACTER INITIAL ?  /*Descrição do item pai. (Uso interno: Campo = mgind.item.desc-item)*/
     FIELD PhoneNumber                      AS CHARACTER INITIAL ?  /*Telefone do contato. (Uso interno: Campo = mgadm.cont-emit.telefone)*/
     FIELD PhoneNumber_00                   AS CHARACTER INITIAL ?  /*Telefone do contato. (Uso interno: Campo = mgadm.cont-emit.telefone)*/
     FIELD PhoneNumber_01                   AS CHARACTER INITIAL ?  /*Telefone do contato. (Uso interno: Campo = mgadm.cont-emit.telefone)*/
     FIELD ProjectControlOrderNumber        AS integer INITIAL ?  /*Numero da ordem de investimento, referente ao módulo de Controle de Investimentos (Uso interno: Campo = movind.item-doc-est.num-ord-inv)*/
     FIELD PurchaseOrderNumber              AS integer INITIAL ?  /*Número do pedido de compra que está sendo recebido. (Uso interno: Campo = movind.item-doc-est.num-pedido)*/
     FIELD PurchaseRequisitionNumber        AS integer INITIAL ?  /*Número da ordem de compra do item. (Uso interno: Campo = movind.item-doc-est.numero-ordem)*/
     FIELD PurchaseRequisitionScheduleID    AS integer INITIAL ?  /*Identificador da parcela da ordem de compra. (Uso interno: Campo = movind.item-doc-est.parcela)*/
     FIELD RequisitionNumber                AS INTEGER INITIAL ? /*N£mero da Requisi‡Æo*/
     FIELD RequisitionLineSequence          AS INTEGER INITIAL ? /*Sequˆncia dos itens da requisi‡Æo*/
     FIELD Quantity                         AS decimal INITIAL ?  /*Quantidade do item, expressa na unidade de medida interna do item. (Uso interno: Campo = movind.item-doc-est.quantidade)*/
     FIELD ReceivedQuantity                 AS decimal INITIAL ?  /*Quantidade real recebida. (Uso interno: Campo = movind.item-doc-est.qt-real)*/
     FIELD RestitutionLevel                 AS CHARACTER INITIAL ?  /*Nível de restituição para a Zona Franca de Manaus. (Uso interno: Campo = movind.item-doc-est.nivel-restituicao)*/
     FIELD RestitutionPercentage            AS decimal INITIAL ?  /*Percentual de restituição. (Uso interno: Campo = movind.item-doc-est.pc-restituicao)*/
     FIELD RMASequenceNumber                AS CHARACTER INITIAL ?  /*Número seqüência RMA. (Uso interno: Campo = movind.item-doc-est.num-seq-rma)*/
     FIELD RouteDescription                 AS CHARACTER INITIAL ?  /*Descrição do roteiro de fabricação. (Uso interno: Campo = mgind.rot-fabric.descricao)*/
     FIELD RouteID                          AS CHARACTER INITIAL ?  /*Código do roteiro de fabricação. (Uso interno: Campo = movind.item-doc-est.cod-roteiro)*/
     FIELD Sequence                         AS integer INITIAL ?  /*Número sequencial do item no documento. (Uso interno: Campo = movind.item-doc-est.sequencia)*/
     FIELD Sequence_00                      AS integer INITIAL ?  /*Sequencia do item no documento de origem. (Uso interno: Campo = movind.item-doc-est.seq-comp)*/
     FIELD Sequence_01                      AS integer INITIAL ?  /*Seqüência do item na nota fiscal de entrega das mercadorias. (Uso interno: Campo = movind.item-doc-est.seq-terc)*/
     FIELD SiteDescription                  AS CHARACTER INITIAL ?  /*Descrição do estabelecimento. (Uso interno: Campo = mgadm.estabelec.nome)*/
     FIELD SiteID                           AS CHARACTER INITIAL ?  /*Código do estabelecimento. (Uso interno: Campo = movind.item-doc-est.est-cob)*/
     FIELD SubAccountNumber                 AS CHARACTER INITIAL ?  /*Número da subconta. (Uso interno: Campo = movind.item-doc-est.sc-codigo)*/
     FIELD SubContractShortName             AS CHARACTER INITIAL ?  /*Nome abreviado do fornecedor. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
     FIELD SubContractTaxID                 AS CHARACTER INITIAL ?  /*CGC do fornecedor. (Uso interno: Campo = mgadm.emitente.cgc)*/
     FIELD SubContractVendorID              AS integer INITIAL ?  /*Código do emitente de beneficiamento. (Uso interno: Campo = movind.item-doc-est.cod-emit-benef)*/
     FIELD SupplementaryDocumentDate        AS date INITIAL ?  /*Data da nota fiscal complementar. (Uso interno: Campo = movind.item-doc-est.dt-nota-comp)*/
     FIELD SupplementaryTax                 AS decimal INITIAL ?  /*ICMS complementar, referente à notas fiscais de compra para consumo final oriundas de outros estados. (Uso interno: Campo = movind.item-doc-est.icm-complem[1])*/
     FIELD SupplementaryTax_00              AS decimal INITIAL ?  /*ICMS complementar, referente à notas fiscais de compra para consumo final oriundas de outros estados. (Uso interno: Campo = movind.item-doc-est.icm-complem[2])*/
     FIELD SupplementaryTax_01              AS decimal INITIAL ?  /*ICMS complementar, referente à notas fiscais de compra para consumo final oriundas de outros estados. (Uso interno: Campo = movind.item-doc-est.icm-comp-cmi)*/
     FIELD TaxCalculationBasis              AS decimal INITIAL ?  /*Base de cálculo de IPI. (Uso interno: Campo = movind.item-doc-est.base-ipi[1])  */
     FIELD TaxCalculationBasis_00           AS decimal INITIAL ?  /*Base de cálculo de ISS. (Uso interno: Campo = movind.item-doc-est.base-iss[1])*/
     FIELD TaxCalculationBasis_01           AS decimal INITIAL ?  /*Base de cálculo de ICMS. (Uso interno: Campo = movind.item-doc-est.base-icm[1])*/
     FIELD TaxCalculationBasis_02           AS decimal INITIAL ?  /*Base de cálculo PIS. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posição inicial = 27, posição final = 40, número de posições = 14)*/
     FIELD TaxCalculationBasis_03           AS decimal INITIAL ?  /*Base de cálculo COFINS. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posição inicial = 89, posição final = 102, número de posições = 14)*/
     FIELD TaxCalculationBasis_04           AS decimal INITIAL ?  /*Base de cálculo de IPI. (Uso interno: Campo = movind.item-doc-est.base-ipi[2])  */
     FIELD TaxCalculationBasis_05           AS decimal INITIAL ?  /*Base de cálculo de ISS. (Uso interno: Campo = movind.item-doc-est.base-iss[2])*/
     FIELD TaxCalculationBasis_06           AS decimal INITIAL ?  /*Base de cálculo de ICMS. (Uso interno: Campo = movind.item-doc-est.base-icm[2])*/
     FIELD TaxCalculationBasis_07           AS decimal INITIAL ?  /*Base de cálculo de IPI. (Uso interno: Campo = movind.item-doc-est.base-ipi-cmi)  */
     FIELD TaxCalculationBasis_08           AS decimal INITIAL ?  /*Base de cálculo de ISS. (Uso interno: Campo = movind.item-doc-est.base-iss-cmi)*/
     FIELD TaxCalculationBasis_09           AS decimal INITIAL ?  /*Base de cálculo de ICMS. (Uso interno: Campo = movind.item-doc-est.base-icm-cmi)*/
     FIELD TaxCode                          AS integer INITIAL ?  /*Tipo de tratamento de IPI em relação ao item. Valores: 1 - Tributado, 2 - Isento, 3 - Outros, 4 - Reduzido. (Uso interno: Campo = movind.item-doc-est.cd-trib-ipi - Include = ininc/i10in172.i)*/
     FIELD TaxCode_00                       AS integer INITIAL ?  /*Tipo de tratamento de ISS em relação ao item. Valores: 1 - Tributado, 2 - Isento, 3 - Outros, 4 - Reduzido. (Uso interno: Campo = movind.item-doc-est.cd-trib-iss - Include = ininc/i11in172.i)*/
     FIELD TaxCode_01                       AS integer INITIAL ?  /*Tipo de tratamento do ICMS em relação ao item. Valores: 1 - Tributado, 2 - Isento, 3 - Outros, 4 - Reduzido, 5 - Diferido. (Uso interno: Campo = movind.item-doc-est.cd-trib-icm - Include = ininc/i07in122.i)*/
     FIELD TaxCode_02                       AS integer INITIAL ?  /*Tribuação PIS. Valores: 1 - Tributado, 2 - Isento. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posição inicial = 21, posição final = 21, número de posições = 1)*/
     FIELD TaxCode_03                       AS integer INITIAL ?  /*Tribuação COFINS. Valores: 1 - Tributado, 2 - Isento. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posição inicial = 83, posição final = 83, número de posições = 1)*/
     FIELD TaxOtherValue                    AS decimal INITIAL ?  /*Valor da base de cálculo do IPI Outras. (Uso interno: Campo = movind.item-doc-est.ipi-outras[1])*/
     FIELD TaxOtherValue_00                 AS decimal INITIAL ?  /*Valor da base de cálculo do ISS Outras. (Uso interno: Campo = movind.item-doc-est.iss-outras[1])*/
     FIELD TaxOtherValue_01                 AS decimal INITIAL ?  /*Valor da base de cálculo do ICMS Outras. (Uso interno: Campo = movind.item-doc-est.icm-outras[1])*/
     FIELD TaxOtherValue_02                 AS decimal INITIAL ?  /*Valor da base de cálculo do IPI Outras. (Uso interno: Campo = movind.item-doc-est.ipi-outras[2])*/
     FIELD TaxOtherValue_03                 AS decimal INITIAL ?  /*Valor da base de cálculo do ISS Outras. (Uso interno: Campo = movind.item-doc-est.iss-outras[2])*/
     FIELD TaxOtherValue_04                 AS decimal INITIAL ?  /*Valor da base de cálculo do ICMS Outras. (Uso interno: Campo = movind.item-doc-est.icm-outras[2])*/
     FIELD TaxOtherValue_05                 AS decimal INITIAL ?  /*Valor da base de cálculo do IPI Outras. (Uso interno: Campo = movind.item-doc-est.ipi-out-cmi)*/
     FIELD TaxOtherValue_06                 AS decimal INITIAL ?  /*Valor da base de cálculo do ISS Outras. (Uso interno: Campo = movind.item-doc-est.iss-out-cmi)*/
     FIELD TaxOtherValue_07                 AS decimal INITIAL ?  /*Valor da base de cálculo do ICMS Outras. (Uso interno: Campo = movind.item-doc-est.icm-out-cmi)*/
     FIELD TaxPercentage                    AS decimal INITIAL ?  /*Aliquota IPI. (Uso interno: Campo = movind.item-doc-est.aliquota-ipi)*/
     FIELD TaxPercentage_00                 AS decimal INITIAL ?  /*Aliquota ISS. (Uso interno: Campo = movind.item-doc-est.aliquota-iss)*/
     FIELD TaxPercentage_01                 AS decimal INITIAL ?  /*Aliquota ICMS. (Uso interno: Campo = movind.item-doc-est.aliquota-icm[1])*/
     FIELD TaxPercentage_02                 AS decimal INITIAL ?  /*Aliquota PIS. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posição inicial = 22, posição final = 26, número de posições = 5)*/
     FIELD TaxPercentage_03                 AS decimal INITIAL ?  /*Aliquota COFINS. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posição inicial = 84, posição final = 88, número de posições = 5)*/
     FIELD TaxReductionPercentage           AS decimal INITIAL ?  /*Percentual de redução de IPI. (Uso interno: Atributo Livre EMS 2.04 = movind.item-doc-est.char-2, posição inicial = 1, posição final = 6, número de posições = 6 - Campo EMS 2.05 = movind.item-doc-est.val-perc-rep-ipi)*/
     FIELD TaxReductionPercentage_00        AS decimal INITIAL ?  /*Percentual de redução de ICMS. (Uso interno: Atributo Livre EMS 2.04 = movind.item-doc-est.char-2, posição inicial = 7, posição final = 12, número de posições = 6 - Campo EMS 2.05 = movind.item-doc-est.val-perc-red-icms)*/
     FIELD TaxValue                         AS decimal INITIAL ?  /*Valor total de IPI. (Uso interno: Campo = movind.item-doc-est.valor-ipi[1])*/
     FIELD TaxValue_00                      AS decimal INITIAL ?  /*Valor total de ISS. (Uso interno: Campo = movind.item-doc-est.valor-iss[1])*/
     FIELD TaxValue_01                      AS decimal INITIAL ?  /*Valor total de ICMS. (Uso interno: Campo = movind.item-doc-est.valor-icm[1])*/
     FIELD TaxValue_02                      AS decimal INITIAL ?  /*Valor PIS a recuperar. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posição inicial = 41, posição final = 54, número de posições = 14)*/
     FIELD TaxValue_03                      AS decimal INITIAL ?  /*Valor COFINS a recuperar. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posição inicial = 103, posição final = 116, número de posições = 14)*/
     FIELD TaxValue_04                      AS decimal INITIAL ?  /*Valor dos impostos de importação (Uso interno: Campo = movind.item-doc-est.vl-imp-impor[1])*/
     FIELD TaxValue_05                      AS decimal INITIAL ?  /*Valor total de IPI. (Uso interno: Campo = movind.item-doc-est.valor-ipi[2])*/
     FIELD TaxValue_06                      AS decimal INITIAL ?  /*Valor total de ISS. (Uso interno: Campo = movind.item-doc-est.valor-iss[2])*/
     FIELD TaxValue_07                      AS decimal INITIAL ?  /*Valor total de ICMS. (Uso interno: Campo = movind.item-doc-est.valor-icm[2])*/
     FIELD TaxValue_08                      AS decimal INITIAL ?  /*Valor PIS a recuperar. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posição inicial = 55, posição final = 68, número de posições = 14)*/
     FIELD TaxValue_09                      AS decimal INITIAL ?  /*Valor COFINS a recuperar. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posição inicial = 117, posição final = 130, número de posições = 14)*/
     FIELD TaxValue_10                      AS decimal INITIAL ?  /*Valor dos impostos de importação (Uso interno: Campo = movind.item-doc-est.vl-imp-impor[2])*/
     FIELD TaxValue_11                      AS decimal INITIAL ?  /*Valor total de IPI. (Uso interno: Campo = movind.item-doc-est.vl-ipi-cmi*/
     FIELD TaxValue_12                      AS decimal INITIAL ?  /*Valor total de ISS. (Uso interno: Campo = movind.item-doc-est.vl-iss-cmi)*/
     FIELD TaxValue_13                      AS decimal INITIAL ?  /*Valor total de ICMS. (Uso interno: Campo = movind.item-doc-est.vl-icm-cmi)*/
     FIELD TaxValue_14                      AS decimal INITIAL ?  /*Valor PIS a recuperar. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posição inicial = 69, posição final = 82, número de posições = 14)*/
     FIELD TaxValue_15                      AS decimal INITIAL ?  /*Valor COFINS a recuperar. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posição inicial = 131, posição final = 144, número de posições = 14)*/
     FIELD TaxValue_16                      AS decimal INITIAL ?  /*Valor dos impostos de importação (Uso interno: Campo = movind.item-doc-est.vl-imp-cmi)*/
     FIELD TotalPrice                       AS decimal INITIAL ?  /*Preço total. (Uso interno: Campo = movind.item-doc-est.preco-total[1])*/
     FIELD TotalPrice_00                    AS decimal INITIAL ?  /*Preço total. (Uso interno: Campo = movind.item-doc-est.preco-total[2])*/
     FIELD TotalPrice_01                    AS decimal INITIAL ?  /*Preço total. (Uso interno: Campo = movind.item-doc-est.pr-total-cmi)*/
     FIELD TotalPrice_02                    AS decimal INITIAL ?  /*Preço total. (Uso interno: Campo = movind.item-doc-est.preco-total-me)*/
     FIELD TransactionDate                  AS date INITIAL ?  /*Data movimento. (Uso interno: Campo = movind.item-doc-est.data)*/
     FIELD TributarySubstitutionBasis       AS decimal INITIAL ?  /*Base de cálculo para o ICMS por regime de Substituição Tributária. (Uso interno: Campo = movind.item-doc-est.base-subs[1])*/
     FIELD TributarySubstitutionBasis_00    AS decimal INITIAL ?  /*Base de cálculo para o PIS por regime de Substituição Tributária. (Uso interno: Campo = movind.item-doc-est.base-pis-subs)*/
     FIELD TributarySubstitutionBasis_01    AS decimal INITIAL ?  /*Base de cálculo para o COFINS por regime de Substituição Tributária. (Uso interno: Campo = movind.item-doc-est.base-cofins-subs)*/
     FIELD TributarySubstitutionBasis_02    AS decimal INITIAL ?  /*Base de cálculo para o ICMS por regime de Substituição Tributária. (Uso interno: Campo = movind.item-doc-est.base-subs[2])*/
     FIELD TributarySubstitutionBasis_03    AS decimal INITIAL ?  /*Base de cálculo para o ICMS por regime de Substituição Tributária. (Uso interno: Campo = movind.item-doc-est.base-subs-cmi)*/
     FIELD TributarySubstitutionValue       AS decimal INITIAL ?  /*Valor do ICMS recolhido por Substituição Tributária. (Uso interno: Campo = movind.item-doc-est.vl-subs[1])*/
     FIELD TributarySubstitutionValue_00    AS decimal INITIAL ?  /*Valor do PIS recolhido por Substituição Tributária. (Uso interno: Campo = movind.item-doc-est.vl-pis-subs)*/
     FIELD TributarySubstitutionValue_01    AS decimal INITIAL ?  /*Valor do COFINS recolhido por Substituição Tributária. (Uso interno: Campo = movind.item-doc-est.vl-cofins-subs)*/
     FIELD TributarySubstitutionValue_02    AS decimal INITIAL ?  /*Valor do ICMS recolhido por Substituição Tributária. (Uso interno: Campo = movind.item-doc-est.vl-subs[2])*/
     FIELD TributarySubstitutionValue_03    AS decimal INITIAL ?  /*Valor do ICMS recolhido por Substituição Tributária. (Uso interno: Campo = movind.item-doc-est.vl-subs-cmi)*/
     FIELD ttDocumentItemID                 AS INTEGER INITIAL ?
     FIELD UnitOfMeasureCode                AS CHARACTER INITIAL ?  /*Código da Unidade de Medida. (Uso interno: Campo = movind.item-doc-est.un)*/
     FIELD UnitOfMeasureDescription         AS CHARACTER INITIAL ?  /*Descrição da Unidade de Medida. (Uso interno: Campo = mgind.tab-unidade.desc)*/
     FIELD UnitPrice                        AS decimal INITIAL ?  /*Preço unitário. (Uso interno: Campo = movind.item-doc-est.preco-unit[1])*/
     FIELD UnitPrice_00                     AS decimal INITIAL ?  /*Preço unitário. (Uso interno: Campo = movind.item-doc-est.preco-unit[2])*/
     FIELD UnitPrice_01                     AS decimal INITIAL ?  /*Preço unitário. (Uso interno: Campo = movind.item-doc-est.pr-unit-cmi)*/
     FIELD UnitPrice_02                     AS decimal INITIAL ?  /*Preço unitário. (Uso interno: Campo = movind.item-doc-est.preco-unit-me)*/
     FIELD VendorID                         AS integer INITIAL ?  /*Código interno de identificação do fornecedor. (Uso interno: Campo = movind.docum-est.emite-comp)*/
     FIELD VendorQuantity                   AS decimal INITIAL ?  /*Quantidade do item, expressa na unidade de medida adotada pelo emitente. (Uso interno: Campo = movind.item-doc-est.qt-do-forn)*/
     FIELD VendorShortName                  AS CHARACTER INITIAL ?  /*Nome abreviado do fornecedor. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
     FIELD VendorsRestokingPercentage       AS decimal INITIAL ?  /*Percentual de restocagem praticado pelo fornecedor. (Uso interno: Campo = movind.item-doc-est.val-perc-restocagem)*/
     FIELD VendorsRestokingValue            AS decimal INITIAL ?  /*Valor de restocagem praticado pelo fornecedor. (Uso interno: Campo = movind.item-doc-est.val-restocagem)*/
     FIELD VendorTaxID                      AS CHARACTER INITIAL ?  /*CGC do fornecedor. (Uso interno: Campo = mgadm.emitente.cgc)*/
     FIELD WarehouseDescription             AS CHARACTER INITIAL ?  /*Descrição do depósito. (Uso interno: Campo = mgind.deposito.nome)*/
     FIELD WarehouseID                      AS CHARACTER INITIAL ?  /*Código depósito. (Uso interno: Campo = movind.item-doc-est.cod-depos)*/
     FIELD PurchaseDate                     AS DATE INITIAL ?
     FIELD Emergency                        AS INTEGER INITIAL ?
   &if "{&bf_dis_versao_ems}" >=  "2.08" &then
     field GrossWeight                      as decimal initial ?
     field CubicMeter                       as decimal initial ?
     field CubedWeight                      as decimal initial ?
     FIELD FreightPisCofinsCode             AS INTEGER INITIAL ?
   &endif
     INDEX ixttDocumentItemID IS PRIMARY UNIQUE ttDocumentItemID ASCENDING
.

DEFINE TEMP-TABLE ttReceiptDocument NO-UNDO
FIELD VendorID AS integer INITIAL ?   /*Código interno de identificação do fornecedor. (Uso interno: Campo = movind.docum-est.cod-emitente)*/
FIELD VendorShortName AS CHARACTER INITIAL ?   /*Nome abreviado do fornecedor. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
FIELD VendorsRestokingPercentage AS decimal INITIAL ?   /*Percentual de restocagem praticado pelo fornecedor. (Uso interno: Campo = movind.docum-est.val-perc-restocagem)*/
FIELD VendorsRestokingValue AS decimal INITIAL ?   /*Valor de restocagem praticado pelo fornecedor. (Uso interno: Campo = movind.docum-est.val-restocagem)*/
FIELD VendorTaxID AS CHARACTER INITIAL ?   /*CGC do fornecedor. (Uso interno: Campo = mgadm.emitente.cgc)*/
FIELD AccountNumber AS CHARACTER INITIAL ?   /*Número da conta transitória. (Uso interno: Campo = movind.docum-est.ct-transit)*/
FIELD Comments AS integer INITIAL ?   /*Código de observação do documento. Valores: 1 - Indústria, 2 - Comércio, 3 - Devolução Cliente, 4 - Serviços (Uso interno: Campo = movind.docum-est.cod-observa - Include = ininc/i03in090.i)*/
FIELD ContactName AS CHARACTER INITIAL ?   /*Nome do contato. (Uso interno: Campo = mgadm.cont-emit.nome)*/
FIELD ContactSequence AS integer INITIAL ?   /*Sequencia contato. (Uso interno: Campo = mgadm.cont-emit.num-seq-cont-emit)*/
FIELD CurrencyDescription AS CHARACTER INITIAL ?   /*Descrição da moeda (Uso interno: Campo = mguni.moeda.descricao)*/
FIELD CurrencyID AS integer INITIAL ?   /*Código da moeda. (Uso interno: Campo = movind.docum-est.mo-codigo)*/
FIELD CurrencySign AS CHARACTER INITIAL ?   /*Sigla padrão da moeda (Uso interno: Campo = mguni.moeda.sigla)*/
FIELD CurrentRate AS decimal INITIAL ?   /*Cotação atual moeda. (Uso interno: Campo = movind.docum-est.cotacao-dia)*/
FIELD DocumentAPStatus AS integer INITIAL ?   /*Situação do ítem em relação a entrada da fatura no Contas Pagar. Valores: 1 - OK, 2 - Aguardando Fatura/Remito, 3 - Com problemas, 4 - Parcialmente Atendido, 5 - Aguardando Conciliação Batch. (Uso interno: Campo = movind.docum-est.sit-docum - Include = ininc/i06in090.i)*/
FIELD DocumentFiscalClass AS CHARACTER INITIAL ?   /*Espécie fiscal do documento (Uso interno: Campo = movind.docum-est.esp-fiscal)*/
FIELD DocumentNarrative AS CHARACTER INITIAL ?   /*Narrativa / Observações. (Uso interno: Campo = movind.docum-est.observacao)*/
FIELD DocumentNumber AS CHARACTER INITIAL ?   /*Número do documento. (Uso interno: Campo = movind.docum-est.nro-docto)*/
FIELD DocumentQualityControlStatus AS integer INITIAL ?   /*Estado do documento com relação ao controle de Qualidade. Valores: 1 - Liberado, 2 - Controle de Qualidade, 3 - Devolução. (Uso interno: Campo = movind.docum-est.estado)*/
FIELD DocumentSeries AS CHARACTER INITIAL ?   /*Série do documento. (Uso interno: Campo = movind.docum-est.serie-docto)*/
FIELD DocumentSource AS CHARACTER INITIAL ?   /*Origem do documento. (Uso interno: Campo = movind.docum-est.origem)*/
FIELD DocumentTotalValue AS decimal INITIAL ?   /*Valor total do documento (Uso interno: Campo = movind.docum-est.tot-valor)*/
FIELD DocumentTotalValue_00 AS decimal INITIAL ?   /*Valor total do documento (Uso interno: Campo = movind.docum-est.tot-vl-fasb[1])*/
FIELD DocumentTotalValue_01 AS decimal INITIAL ?   /*Valor total do documento (Uso interno: Campo = movind.docum-est.tot-vl-fasb[2])*/
FIELD DocumentTotalValue_02 AS decimal INITIAL ?   /*Valor total do documento (Uso interno: Campo = movind.docum-est.tot-valor-me)*/
FIELD DocumentTotalWeight AS decimal INITIAL ?   /*Peso total dos itens do documento. (Uso interno: Campo = movind.docum-est.tot-peso)*/
FIELD DocumentType AS integer INITIAL ?   /*Espécie do documento que originou o movimento de estoque, indentificada por um conjunto de indicadores (siglas) intenas do EMS2. Valores: 1 - ACA, 2 - ACT, 3 - NU1, 4 - DD, 5 - DEV, 6 - DIV, 7 - DRM, 8 - EAC, 9 - EGF, 10 - BEM, 11 - NU2, 12 - NU3, 13 - NU4, 14 - ICM, 15 - INV, 16 - IPL, 17 - MOB, 18 - NC, 19 - NF, 20 - NFD, 21 - NFE, 22 - NFS, 23 - NFT, 24 - NU5, 25 - REF, 26 - RCS, 27 - RDD, 28 - REQ, 29 - RFS, 30 - RM, 31 - RRQ, 32 - STR, 33 - TRA, 34 - ZZZ, 35 - SOB, 36 - EDD, 37 - VAR, 38 - ROP. (Uso interno: Campo = movind.docum-est.esp-docto - Include = ininc/i03in218.i)*/
FIELD DocumentValidityDate AS date INITIAL ?   /*Data de validade do documento. (Uso interno: Campo = movind.docum-est.dat-validade)*/
FIELD EmailAddress AS CHARACTER INITIAL ?   /*E-mail do contato. (Uso interno: Campo = mgadm.cont-emit.e-mail)*/
FIELD ExpenseValue AS decimal INITIAL ?   /*Valor total das despesas acessórias do documento. (Uso interno: Campo = movind.docum-est.despesa-nota)*/
FIELD ExpenseValue_00 AS decimal INITIAL ?   /*Valor total das despesas acessórias do documento. (Uso interno: Campo = movind.docum-est.desp-fasb[1])*/
FIELD ExpenseValue_01 AS decimal INITIAL ?   /*Valor total das despesas acessórias do documento. (Uso interno: Campo = movind.docum-est.desp-fasb[2])*/
FIELD ExpenseValue_02 AS decimal INITIAL ?   /*Valor total das despesas acessórias do documento. (Uso interno: Campo = movind.docum-est.despesa-nota-me)*/
FIELD FASBCurrentRate AS decimal INITIAL ?   /*Cotação atual moeda FASB. (Uso interno: Campo = movind.docum-est.cotacao-fasb)*/
FIELD FiscalOperationCode AS CHARACTER INITIAL ?   /*Código natureza de operação. (Uso interno: Campo = movind.docum-est.nat-operacao)*/
FIELD FiscalOperationDescription AS CHARACTER INITIAL ?   /*Descrição da natureza de operação. (Uso interno: Campo = mgind.natur-oper.denominacao)*/

&if "{&bf_dis_versao_ems}" >=  "2.08" &then
  FIELD EndConsumer                      AS LOGICAL   INITIAL ?
  FIELD Type_00                          AS INTEGER   INITIAL ?
  FIELD Transfer                         AS LOGICAL   INITIAL ?
  FIELD Kind_00                          AS CHARACTER INITIAL ?    
&endif

FIELD FreightDistributionMethod AS integer INITIAL ?   /*Tipo de rateio do frete. Valores: 1 - Peso, 2 - Valor. (Uso interno: Campo = movind.docum-est.rateia-frete - Include = ininc/i04in292.i)*/
FIELD FreightModality AS integer INITIAL ?   /*Modalidade de frete. Valores: 1 - CIF, 2 - FOB (Uso interno: Campo = movind.docum-est.mod-frete - Include = diinc/i01di037.i)*/
FIELD FreightTax AS decimal INITIAL ?   /*ICMS substituto, referente ao frete constante da nota fiscal. (Uso interno: Campo = movind.docum-est.icm-fonte)*/
FIELD FreightTax_00 AS decimal INITIAL ?   /*ICMS substituto, referente ao frete constante da nota fiscal. (Uso interno: Campo = movind.docum-est.icm-fnt-fasb[1])*/
FIELD FreightTax_01 AS decimal INITIAL ?   /*ICMS substituto, referente ao frete constante da nota fiscal. (Uso interno: Campo = movind.docum-est.icm-fnt-fasb[2])*/
FIELD FreightValue AS decimal INITIAL ?   /*Valor total das despesas com frete. (Uso interno: Campo = movind.docum-est.valor-frete)*/
FIELD FreightValue_00 AS decimal INITIAL ?   /*Valor total das despesas com frete. (Uso interno: Campo = movind.docum-est.vl-fre-fasb[1])*/
FIELD FreightValue_01 AS decimal INITIAL ?   /*Valor total das despesas com frete. (Uso interno: Campo = movind.docum-est.vl-fre-fasb[2])*/
FIELD FreightValue_02 AS decimal INITIAL ?   /*Valor total das despesas com frete. (Uso interno: Campo = movind.docum-est.valor-frete-me)*/
FIELD GoodsValue AS decimal INITIAL ?   /*Valor total das mercadorias. (Uso interno: Campo = movind.docum-est.valor-mercad)*/
FIELD GoodsValue_00 AS decimal INITIAL ?   /*Valor total das mercadorias. (Uso interno: Campo = movind.docum-est.vl-merc-fasb[1])*/
FIELD GoodsValue_01 AS decimal INITIAL ?   /*Valor total das mercadorias. (Uso interno: Campo = movind.docum-est.vl-merc-fasb[2])*/
FIELD GoodsValue_02 AS decimal INITIAL ?   /*Valor total das mercadorias. (Uso interno: Campo = movind.docum-est.valor-mercad-me)*/
FIELD ImportationStatement AS CHARACTER INITIAL ?   /*Declaração de importação.(Uso interno: Campo = movind.docum-est.declaracao-import)*/
FIELD InsuranceValue AS decimal INITIAL ?   /*Valor total de seguro. (Uso interno: Campo = movind.docum-est.valor-seguro)*/
FIELD InsuranceValue_00 AS decimal INITIAL ?   /*Valor total de seguro. (Uso interno: Campo = movind.docum-est.vl-seg-fasb[1])*/
FIELD InsuranceValue_01 AS decimal INITIAL ?   /*Valor total de seguro. (Uso interno: Campo = movind.docum-est.vl-seg-fasb[2])*/
FIELD InsuranceValue_02 AS decimal INITIAL ?   /*Valor total de seguro. (Uso interno: Campo = movind.docum-est.valor-seguro-me)*/
FIELD InvoiceDocumentType AS integer INITIAL ?   /*Tipo de nota fiscal. Valores: 1 - Compra, 2 - Beneficiamento, 3 - Devolução, 4 - Consignação,
5 - Transferência. (Uso interno: Campo = movind.docum-est.tipo-nota)*/
FIELD IsDistributionDocument AS LOGICAL INITIAL ?   /*Nota fiscal de rateio. (Uso interno: Campo = movind.docum-est.ind-rateio)*/
FIELD IsDocumentIssuedByPostSite AS LOGICAL INITIAL ?   /*Nota fiscal emitida pelo próprio estabelecimento. (Uso interno: Campo = movind.docum-est.nf-emitida-est)*/
FIELD IsInvoiceDocument AS LOGICAL INITIAL ?   /*Indicador de nota fiscal de fatura. (Uso interno: Campo = movind.docum-est.nff)*/
FIELD IsOtherExpensesInvoice AS LOGICAL INITIAL ?   /*Fatura é de outras despesas. (Uso interno: Campo = movind.docum-est.fat-despesa)*/
FIELD IsRepresentativeComissionCanc_00 AS LOGICAL INITIAL ?   /*Efetua estorno da comissão dos representantes. (Uso interno: Campo = movind.docum-est.estorn-comis)
*/
FIELD NotTaxedValue AS decimal INITIAL ?   /*Valor da base de cálculo do IPI não tributado. (Uso interno: Campo = movind.docum-est.ipi-nao-trib)*/
FIELD NotTaxedValue_00 AS decimal INITIAL ?   /*Valor da base de cálculo do ISS não tributado. (Uso interno: Campo = movind.docum-est.iss-nao-trib)*/
FIELD NotTaxedValue_01 AS decimal INITIAL ?   /*Valor da base de cálculo do ICMS não tributado. (Uso interno: Campo = movind.docum-est.icm-nao-trib)*/
FIELD NotTaxedValue_02 AS decimal INITIAL ?   /*Valor da base de cálculo do IPI não tributado. (Uso interno: Campo = movind.docum-est.ipi-ntr-fasb[1])*/
FIELD NotTaxedValue_03 AS decimal INITIAL ?   /*Valor da base de cálculo do ISS não tributado. (Uso interno: Campo = movind.docum-est.iss-ntr-fasb[1])*/
FIELD NotTaxedValue_04 AS decimal INITIAL ?   /*Valor da base de cálculo do ICMS não tributado. (Uso interno: Campo = movind.docum-est.icm-ntr-fasb[1])*/
FIELD NotTaxedValue_05 AS decimal INITIAL ?   /*Valor da base de cálculo do IPI não tributado. (Uso interno: Campo = movind.docum-est.ipi-ntr-fasb[2])*/
FIELD NotTaxedValue_06 AS decimal INITIAL ?   /*Valor da base de cálculo do ISS não tributado. (Uso interno: Campo = movind.docum-est.iss-ntr-fasb[2])*/
FIELD NotTaxedValue_07 AS decimal INITIAL ?   /*Valor da base de cálculo do ICMS não tributado. (Uso interno: Campo = movind.docum-est.icm-ntr-fasb[2])*/
FIELD OtherExpensesValue AS decimal INITIAL ?   /*Valor total de outras despesas aplicadas a nota fiscal, além do frete, seguro e embalagem. (Uso interno: Campo = movind.docum-est.valor-outras)*/
FIELD OtherExpensesValue_00 AS decimal INITIAL ?   /*Valor total de outras despesas aplicadas a nota fiscal, além do frete, seguro e embalagem. (Uso interno: Campo = movind.docum-est.vl-out-fasb[1])*/
FIELD OtherExpensesValue_01 AS decimal INITIAL ?   /*Valor total de outras despesas aplicadas a nota fiscal, além do frete, seguro e embalagem. (Uso interno: Campo = movind.docum-est.vl-out-fasb[2])*/
FIELD OtherExpensesValue_02 AS decimal INITIAL ?   /*Valor total de outras despesas aplicadas a nota fiscal, além do frete, seguro e embalagem. (Uso interno: Campo = movind.docum-est.valor-outras-me)*/
FIELD PackagingValue AS decimal INITIAL ?   /*Valor total das despesas com embalagem. (Uso interno: Campo = movind.docum-est.valor-embal)*/
FIELD PackagingValue_00 AS decimal INITIAL ?   /*Valor total das despesas com embalagem. (Uso interno: Campo = movind.docum-est.vl-emb-fasb[1])*/
FIELD PackagingValue_01 AS decimal INITIAL ?   /*Valor total das despesas com embalagem. (Uso interno: Campo = movind.docum-est.vl-emb-fasb[2])*/
FIELD PackagingValue_02 AS decimal INITIAL ?   /*Valor total das despesas com embalagem. (Uso interno: Campo = movind.docum-est.valor-embal-me)*/
FIELD PhoneNumber AS CHARACTER INITIAL ?   /*Telefone do contato. (Uso interno: Campo = mgadm.cont-emit.telefone)*/
FIELD PrintDate AS date INITIAL ?   /*Data de emissão do documento. (Uso interno: Campo = movind.docum-est.dt-emissao)*/
FIELD RMANumber AS CHARACTER INITIAL ?   /*Número da RMA. (Uso interno: Campo = movind.docum-est.cod-rma)*/
FIELD ServiceDescription AS CHARACTER INITIAL ?   /*Descrição do serviço de frete do item. (Uso interno: mgscm.servico-tf.descricao)*/
FIELD ServiceID AS integer INITIAL ?   /*Código do serviço de frete do item. (Uso interno: Atributo Livre EMS2.04 = movind.docum-est.char-2, posição inicial = 90, posição final = 94, número de posições = 05 - Campo EMS2.05 = movind.docum-est.cod-servico)*/
FIELD ShipmentNumber AS CHARACTER INITIAL ?   /*Número do embarque. (Uso interno: Campo = movind.docum-est.embarque)*/
FIELD ShippingMethod AS integer INITIAL ?   /*Via de transporte recebimento. Valores: 1 - Rodoviario, 2 - Aeroviario, 3 - Maritimo, 4 - Ferroviario, 5 - Rodoferroviario, 6 - Rodofluvial, 7 - Rodoaeroviario, 8 - Outros. (Uso interno: Campo = movind.docum-est.via-transp - Include = adinc/i01ad268.i)*/
FIELD SiteDescription AS CHARACTER INITIAL ?   /*Descrição do estabelecimento. (Uso interno: Campo = mgadm.estabelec.nome)*/
FIELD SiteDescription_00 AS CHARACTER INITIAL ?   /*Descrição do estabelecimento. (Uso interno: Campo = mgadm.estabelec.nome)*/
FIELD SiteDescription_01 AS CHARACTER INITIAL ?   /*Descrição do estabelecimento. (Uso interno: Campo = mgadm.estabelec.nome)*/
FIELD SiteID AS CHARACTER INITIAL ?   /*Código do estabelecimento. (Uso interno: Campo = movind.docum-est.cod-estabel)*/
FIELD SiteID_00 AS CHARACTER INITIAL ?   /*Código do estabelecimento origem. (Uso interno: Campo = movind.docum-est.estab-fisc)*/
FIELD SiteID_01 AS CHARACTER INITIAL ?   /*Código do estabelecimento origem. (Uso interno: Campo = movind.docum-est.estab-de-or)*/
FIELD SiteShortName AS CHARACTER INITIAL ?   /*Nome do estabelecimento. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
FIELD SiteTaxID AS CHARACTER INITIAL ?   /*CGC do estabelecimento. (Uso interno: Campo = mgadm.emitente.cgc)*/
FIELD SourceState AS CHARACTER INITIAL ?   /*Unidade da federação. (Uso interno: Campo = movind.docum-est.uf)*/
FIELD SubAccountNumber AS CHARACTER INITIAL ?   /*Número da subconta transitória. (Uso interno: Campo = movind.docum-est.sc-transit)*/
FIELD SupplementaryTax AS decimal INITIAL ?   /*ICMS complementar, referente à notas fiscais de compra para consumo final oriundas de outros estados. (Uso interno: Campo = movind.docum-est.icm-complem)*/
FIELD SupplementaryTax_00 AS decimal INITIAL ?   /*ICMS complementar, referente à notas fiscais de compra para consumo final oriundas de outros estados. (Uso interno: Campo = movind.docum-est.icm-cpl-fasb[1])*/
FIELD SupplementaryTax_01 AS decimal INITIAL ?   /*ICMS complementar, referente à notas fiscais de compra para consumo final oriundas de outros estados. (Uso interno: Campo = movind.docum-est.icm-cpl-fasb[2])*/
FIELD TaxCalculationBasis AS decimal INITIAL ?   /*Base de cálculo de IPI. (Uso interno: Campo = movind.docum-est.base-ipi)*/
FIELD TaxCalculationBasis_00 AS decimal INITIAL ?   /*Base de cálculo de ISS. (Uso interno: Campo = movind.docum-est.base-iss)*/
FIELD TaxCalculationBasis_01 AS decimal INITIAL ?   /*Base de cálculo de ICMS. (Uso interno: Campo = movind.docum-est.base-icm)*/
FIELD TaxCalculationBasis_02 AS decimal INITIAL ?   /*Base de cálculo de IPI. (Uso interno: Campo = movind.docum-est.base-ipi-fas[1])*/
FIELD TaxCalculationBasis_03 AS decimal INITIAL ?   /*Base de cálculo de ISS. (Uso interno: Campo = movind.docum-est.base-iss-fas[1])*/
FIELD TaxCalculationBasis_04 AS decimal INITIAL ?   /*Base de cálculo de ICMS. (Uso interno: Campo = movind.docum-est.base-icm-fas[1])*/
FIELD TaxCalculationBasis_05 AS decimal INITIAL ?   /*Base de cálculo de IPI. (Uso interno: Campo = movind.docum-est.base-ipi-fas[2])*/
FIELD TaxCalculationBasis_06 AS decimal INITIAL ?   /*Base de cálculo de ISS. (Uso interno: Campo = movind.docum-est.base-iss-fas[2])*/
FIELD TaxCalculationBasis_07 AS decimal INITIAL ?   /*Base de cálculo de ICMS. (Uso interno: Campo = movind.docum-est.base-icm-fas[2])*/
FIELD TaxDueDate AS date INITIAL ?   /*Data de vencimento do IPI. (Uso interno: Campo = movind.docum-est.dt-venc-ipi)*/
FIELD TaxDueDate_00 AS date INITIAL ?   /*Data de vencimento do ISS. (Uso interno: Campo = movind.docum-est.dt-venc-iss)*/
FIELD TaxDueDate_01 AS date INITIAL ?   /*Data de vencimento do ICMS. (Uso interno: Campo = movind.docum-est.dt-venc-icm)*/
FIELD TaxOnExpenses AS decimal INITIAL ?   /*Valor de IPI sobre as despesas documento. (Uso interno: Campo = movind.docum-est.ipi-despesa)*/
FIELD TaxOtherValue AS decimal INITIAL ?   /*Valor da base de cálculo do IPI Outras. (Uso interno: Campo = movind.docum-est.ipi-outras)*/
FIELD TaxOtherValue_00 AS decimal INITIAL ?   /*Valor da base de cálculo do ISS Outras. (Uso interno: Campo = movind.docum-est.iss-outras)*/
FIELD TaxOtherValue_01 AS decimal INITIAL ?   /*Valor da base de cálculo do ICMS Outras. (Uso interno: Campo = movind.docum-est.icm-outras)*/
FIELD TaxOtherValue_02 AS decimal INITIAL ?   /*Valor da base de cálculo do IPI Outras. (Uso interno: Campo = movind.docum-est.ipi-out-fasb[1])*/
FIELD TaxOtherValue_03 AS decimal INITIAL ?   /*Valor da base de cálculo do ISS Outras. (Uso interno: Campo = movind.docum-est.iss-out-fasb[1])*/
FIELD TaxOtherValue_04 AS decimal INITIAL ?   /*Valor da base de cálculo do ICMS Outras. (Uso interno: Campo = movind.docum-est.icm-out-fasb[1])*/
FIELD TaxOtherValue_05 AS decimal INITIAL ?   /*Valor da base de cálculo do IPI Outras. (Uso interno: Campo = movind.docum-est.ipi-out-fasb[2])*/
FIELD TaxOtherValue_06 AS decimal INITIAL ?   /*Valor da base de cálculo do ISS Outras. (Uso interno: Campo = movind.docum-est.iss-out-fasb[2])*/
FIELD TaxOtherValue_07 AS decimal INITIAL ?   /*Valor da base de cálculo do ICMS Outras. (Uso interno: Campo = movind.docum-est.icm-out-fasb[2])*/
FIELD TaxPercentage AS decimal INITIAL ?   /*Aliquota ISS. (Uso interno: Campo = movind.docum-est.aliquota-iss)*/
FIELD TaxPercentage_00 AS decimal INITIAL ?   /*Aliquota ICMS. (Uso interno: Campo = movind.docum-est.aliquota-icm)*/
FIELD TaxValue AS decimal INITIAL ?   /*Valor total de IPI. (Uso interno: Campo = movind.docum-est.ipi-deb-cre)*/
FIELD TaxValue_00 AS decimal INITIAL ?   /*Valor total de ISS. (Uso interno: Campo = movind.docum-est.iss-deb-cre)*/
FIELD TaxValue_01 AS decimal INITIAL ?   /*Valor total do ICMS das mercadorias da nota fiscal, dos itens e o valor da diferença entre o total da nota e total dos itens. (Uso interno: Campo = movind.docum-est.icm-deb-cre)*/
FIELD TaxValue_02 AS decimal INITIAL ?   /*Valor total de IPI. (Uso interno: Campo = movind.docum-est.ipi-dc-fasb[1])*/
FIELD TaxValue_03 AS decimal INITIAL ?   /*Valor total de ISS. (Uso interno: Campo = movind.docum-est.iss-dc-fasb[1])*/
FIELD TaxValue_04 AS decimal INITIAL ?   /*Valor total do ICMS das mercadorias da nota fiscal, dos itens e o valor da diferença entre o total da nota e total dos itens. (Uso interno: Campo = movind.docum-est.icm-dc-fasb[1])*/
FIELD TaxValue_05 AS decimal INITIAL ?   /*Valor total de IPI. (Uso interno: Campo = movind.docum-est.ipi-dc-fasb[2])*/
FIELD TaxValue_06 AS decimal INITIAL ?   /*Valor total de ISS. (Uso interno: Campo = movind.docum-est.iss-dc-fasb[2])*/
FIELD TaxValue_07 AS decimal INITIAL ?   /*Valor total do ICMS das mercadorias da nota fiscal, dos itens e o valor da diferença entre o total da nota e total dos itens. (Uso interno: Campo = movind.docum-est.icm-dc-fasb[2])*/
FIELD TotalDiscountValue AS decimal INITIAL ?   /*Total de descontos da Nota Fiscal. (Uso interno: Campo = movind.docum-est.tot-desconto)*/
FIELD TotalDiscountValue_00 AS decimal INITIAL ?   /*Total de descontos da Nota Fiscal. (Uso interno: Campo = movind.docum-est.tot-des-fasb[1]*/
FIELD TotalDiscountValue_01 AS decimal INITIAL ?   /*Total de descontos da Nota Fiscal. (Uso interno: Campo = movind.docum-est.tot-des-fasb[2]*/
FIELD TotalDiscountValue_02 AS decimal INITIAL ?   /*Total de descontos da Nota Fiscal. (Uso interno: Campo = movind.docum-est.tot-desconto-me)*/
FIELD TotalTaxValue AS decimal INITIAL ?   /*Valor total dos impostos do documento. (Uso interno: Campo = movind.docum-est.tot-taxa)*/
FIELD TotalTaxValue_00 AS decimal INITIAL ?   /*Valor total dos impostos do documento. (Uso interno: Campo = movind.docum-est.tot-taxa-me)*/
FIELD TransactionDate AS date INITIAL ?   /*Data da transação. (Uso interno: Campo = movind.docum-est.dt-trans)*/
FIELD TransactionType AS integer INITIAL ?   /*Tipo do documento. Valores: 1 - Entrada, 2 - Saida. (Uso interno: Campo = movind.docum-est.tipo-docto - Include = ininc/i01in218.i)*/
FIELD TributarySubstitutionBasis AS decimal INITIAL ?   /*Base de cálculo para o ICMS por regime de Substituição Tributária. (Uso interno: Campo = movind.docum-est.base-subs)*/
FIELD TributarySubstitutionBasis_00 AS decimal INITIAL ?   /*Base de cálculo para o PIS por regime de Substituição Tributária. (Uso interno: Campo = movind.docum-est.base-pis-subs)*/
FIELD TributarySubstitutionBasis_01 AS decimal INITIAL ?   /*Base de cálculo para o COFINS por regime de Substituição Tributária. (Uso interno: Campo = movind.docum-est.base-cofins-subs)*/
FIELD TributarySubstitutionBasis_02 AS decimal INITIAL ?   /*Base de cálculo para o ICMS por regime de Substituição Tributária. (Uso interno: Campo = movind.docum-est.base-subs-fasb[1])*/
FIELD TributarySubstitutionBasis_03 AS decimal INITIAL ?   /*Base de cálculo para o ICMS por regime de Substituição Tributária. (Uso interno: Campo = movind.docum-est.base-subs-fasb[2])*/
FIELD TributarySubstitutionValue AS decimal INITIAL ?   /*Valor do ICMS recolhido por Substituição Tributária. (Uso interno: Campo = movind.docum-est.vl-subs)*/
FIELD TributarySubstitutionValue_00 AS decimal INITIAL ?   /*Valor do PIS recolhido por Substituição Tributária. (Uso interno: Campo = movind.docum-est.vl-pis-subs)*/
FIELD TributarySubstitutionValue_01 AS decimal INITIAL ?   /*Valor do COFINS recolhido por Substituição Tributária. (Uso interno: Campo = movind.docum-est.vl-cofins-subs)*/
FIELD TributarySubstitutionValue_02 AS decimal INITIAL ?   /*Valor do ICMS recolhido por Substituição Tributária. (Uso interno: Campo = movind.docum-est.vl-subs-fasb[1])*/
FIELD TributarySubstitutionValue_03 AS decimal INITIAL ?   /*Valor do ICMS recolhido por Substituição Tributária. (Uso interno: Campo = movind.docum-est.vl-subs-fasb[2])*/

&if "{&bf_dis_versao_ems}" >=  "2.08" &then
  field TotalGrossWeight              as decimal initial ?
  field TotalCubedWeight              as decimal initial ?
  field TotalVolumeM3                 as decimal initial ?
  field VehicleType                   as character initial ?
  field OperationType                 as integer initial ?
  field Product                       as integer initial ?
  field Shipment                      as integer initial ?
  field Independent                   as logical initial ?
  field VehicleFrontPlate             as character initial ?
  field VehicleRearPlate              as character initial ?
  field Driver                        as integer initial ?
  field RouteSite                     as character initial ?
  field Route                         as integer initial ?
  field DepartureKM                   as decimal initial ?
  field ArrivalKM                     as decimal initial ?
  field PayDispatch                   as logical initial ?
  field ReshipmentCarrier             as character initial ?
  field RelatedVendor                 as integer initial ?
&endif
.

&if "{&bf_dis_versao_ems}" >=  "2.08" &then
  DEF TEMP-TABLE ttAgent NO-UNDO
      FIELD Sequence                         AS INTEGER   INITIAL ?
      FIELD AgentCode                        AS INTEGER   INITIAL ?
      FIELD AgentCityCode                    AS INTEGER   INITIAL ?.

  DEFINE TEMP-TABLE ttFreightSimulation NO-UNDO
     FIELD SiteID             AS CHARACTER INITIAL ?  /*Estabelecimento */
     FIELD DocumentSeries     AS CHARACTER INITIAL ?   /* S‚rie. */        
     FIELD DocumentNumber     AS CHARACTER INITIAL ?  /* N£mero do documento de nota fiscal. */     
     FIELD CargoRouteNumber   AS INTEGER   INITIAL ?   /* N£mero do Percurso. */        
     FIELD CustomerTaxID      AS CHARACTER INITIAL ?   /* N£mero do Percurso. */     
     FIELD FreightTableNumber AS INTEGER   INITIAL ?   /* N£mero da Tabela de Frete. */     
     FIELD Product            AS INTEGER   INITIAL ?   /* Produto. */       
     FIELD ValidityDate       AS DATE      INITIAL ?   /* Data de Validade. */         
     FIELD RouteNumber        AS INTEGER   INITIAL ?   /* Numero da Rota. */          
     FIELD TermNumber         AS INTEGER   INITIAL ?   /* Prazo. */         
     FIELD AgreedValue        AS DECIMAL   INITIAL ?   /* Valor Combinado com o Cliente. */  
     FIELD FreightUnitValue   AS DECIMAL   INITIAL ?   /* Valor Unitario do Frete. */    
     FIELD FreightValue       AS DECIMAL   INITIAL ?   /* Valor do frete por valor. */     
     FIELD DaryValue          AS DECIMAL   INITIAL ?   /* Valor da Di ria. */        
     FIELD ADEMEValue         AS DECIMAL   INITIAL ?   /* Valor de ADEME do conhecimento. */         
     FIELD DispatchValue      AS DECIMAL   INITIAL ?   /* movtrp.simul-nota-fisc.val-despch. */        
     FIELD ITRValue           AS DECIMAL   INITIAL ?   /* Valor do ITR. */           
     FIELD OthersValue        AS DECIMAL   INITIAL ?   /* Valor Outros. */        
     FIELD TollValue          AS DECIMAL   INITIAL ?   /* Valor do Ped gio. */       
     FIELD InsuranceValue     AS DECIMAL   INITIAL ?   /* Valor do Seguro. */        
     FIELD SUFRAMAValue       AS DECIMAL   INITIAL ?   /* Valor Suframa. */       
     FIELD CollectionRate     AS DECIMAL   INITIAL ?   /* Taxa de Coleta. */    
     FIELD DeliveryRate       AS DECIMAL   INITIAL ?   /* Taxa de entrega. */  
     FIELD DispatchRateValue  AS DECIMAL   INITIAL ?   /* Taxa de Conhecimento. */  
     FIELD Comments           AS CHARACTER INITIAL ?   /* Informa‡äes Adicionais. */
     FIELD ttFreightSimulationID AS INTEGER INITIAL ?
     INDEX ixttFreightSimulation IS PRIMARY UNIQUE ttFreightSimulationID ASCENDING.     
&endif                                                                                  


DEF TEMP-TABLE tt-tributa-item NO-UNDO
    FIELD rTab-generica AS ROWID 
    FIELD peso AS DEC INITIAL 0.



def input        param pTipoAlter     as int   no-undo.
def input        param pSerieDocto    as char format "x(5)"      no-undo.
def input        param pNroDocto      as char format "x(16)"     no-undo.
def input        param pCodEmitente   as int  format ">>>>>>>>9" no-undo.
def input        param pNatOperacao   as char format "x(6)"      no-undo.
def input        param pSequencia     as int  format ">>>>9"     no-undo.
def input-output param table for ttReceiptDocument.
def input-output param table for ttDocumentItem.
def input-output param table for ttAgent.
DEF INPUT-OUTPUT PARAM TABLE FOR ttFreightSimulation.

def var i-cont-re        as int no-undo.
def var i-redespachantes as int no-undo.
DEF VAR l-redesp         AS LOG INIT NO.
DEF VAR i-cont           AS INT NO-UNDO.
DEFINE BUFFER tr-docum-est FOR docum-est.
DEFINE BUFFER tr-transporte FOR transporte.
DEFINE BUFFER tr-emitente FOR emitente.
DEFINE BUFFER tr-estabelec FOR estabelec.

   
if pTipoAlter = 1 then do:

    /* Gravar o primeiro trecho que ‚ o proprio transportador */
    FIND FIRST tr-docum-est
        WHERE tr-docum-est.serie-docto  = pSerieDocto
          AND tr-docum-est.nro-docto    = pNroDocto
          AND tr-docum-est.nat-operacao = pNatOperacao 
          AND tr-docum-est.cod-emitente = pCodEmitente  NO-LOCK NO-ERROR.
    IF AVAIL tr-docum-est THEN DO:
    
         FOR FIRST tr-transporte FIELDS (cod-transp cgc nome-abrev) NO-LOCK 
            WHERE tr-transporte.nome-abrev = tr-docum-est.nome-transp: END.

         FOR FIRST tr-estabelec FIELDS (cgc cidade estado pais)
             WHERE tr-estabelec.cod-estabel = tr-docum-est.cod-estabel NO-LOCK: END.

         FIND FIRST cidade NO-LOCK
             WHERE cidade.cidade  = tr-estabelec.cidade
               AND cidade.estado  = tr-estabelec.estado
               AND cidade.pais    = tr-estabelec.pais NO-ERROR.

         find first tr-emitente where tr-emitente.cgc = tr-transporte.cgc no-lock no-error.

         
          create ttAgent.
          ASSIGN ttAgent.Sequence      = 1
                 ttAgent.AgentCode     = IF AVAIL tr-emitente THEN tr-emitente.cod-emitente
                                         ELSE IF AVAIL tr-transporte THEN tr-transporte.cod-transp ELSE 0
                 ttAgent.AgentCityCode = IF AVAIL cidade THEN cidade.cdn-munpio-ibge ELSE 0.

                                                                                         

          /* A cidade ser  a cidade do estabelecimento, qdo tiver somente 1 trecho. Caso tenha mais, ser  sobreposta com a cidade do pr¢ximo Redespacho */
          FIND FIRST tab-generica NO-LOCK
               WHERE tab-generica.utilizacao = "nfEntrad":u
               AND   tab-generica.char-1     = pSerieDocto + ";" + 
                                               pNroDocto + ";" + 
                                               STRING(pCodEmitente) + ";" + 
                                               pNatOperacao NO-ERROR.
          IF AVAIL tab-generica THEN
               ASSIGN ttAgent.AgentCityCode = int(substring(tab-generica.char-2,7,7)).

         
    END.

    /*Grava os Redespachos */
    FIND FIRST tab-generica NO-LOCK
         WHERE tab-generica.utilizacao = "nfEntrad":u
         AND   tab-generica.char-1     = pSerieDocto + ";" + 
                                         pNroDocto + ";" + 
                                         STRING(pCodEmitente) + ";" + 
                                         pNatOperacao NO-ERROR.
    IF AVAIL tab-generica THEN DO:

        ASSIGN i-cont-re  = 1.

        DO i-redespachantes = 1 TO 5:

            if substring(tab-generica.char-2,i-cont-re,6) <> "" and
               substring(tab-generica.char-2,i-cont-re,6) <> "0" then do:

                create ttAgent.
                ASSIGN ttAgent.Sequence      = i-redespachantes + 1
                       ttAgent.AgentCode     = int(substring(tab-generica.char-2,i-cont-re,6))
                       ttAgent.AgentCityCode = int(substring(tab-generica.char-2,i-cont-re + 19,7)).

                IF substring(tab-generica.char-2,i-cont-re + 13,6) = "" OR 
                   substring(tab-generica.char-2,i-cont-re + 13,6) = "0" OR i-cont-re = 53 THEN
                    ASSIGN ttAgent.AgentCityCode = IF AVAIL cidade THEN cidade.cdn-munpio-ibge ELSE 0.
            end.

            ASSIGN i-cont-re  = i-cont-re + 13
                   l-redesp = YES.
        END.
    END.

    FIND FIRST tab-generica NO-LOCK
         WHERE tab-generica.utilizacao = "documest":u
         AND   tab-generica.char-1     = pSerieDocto + ";" + 
                                         pNroDocto + ";" + 
                                         STRING(pCodEmitente) + ";" + 
                                         pNatOperacao NO-ERROR.
    IF AVAIL tab-generica THEN DO:

        find first ttReceiptDocument exclusive-lock no-error.
        if avail ttReceiptDocument then
            assign ttReceiptDocument.TotalGrossWeight  = tab-generica.dec-1 / 1000
                   ttReceiptDocument.TotalCubedWeight  = tab-generica.dec-2 / 1000
                   ttReceiptDocument.TotalVolumeM3     = dec(substring(tab-generica.char-2,124,6)) / 1000
                   ttReceiptDocument.VehicleType       = substring(tab-generica.char-2,1,2)
                   ttReceiptDocument.OperationType     = int(substring(tab-generica.char-2,130,3))
                   ttReceiptDocument.Product           = tab-generica.int-1
                 &IF '{&bf_dis_versao_tms}':U <> '4.02':U &THEN
                   ttReceiptDocument.Shipment          = tab-generica.int-2
                 &ELSE
                   ttReceiptDocument.Shipment          = int(SUBSTRING(tab-generica.char-2,104,20))
                 &ENDIF
                   ttReceiptDocument.PayDispatch       = tab-generica.log-1
                   ttReceiptDocument.VehicleFrontPlate = substring(tab-generica.char-2,133,12)
                   ttReceiptDocument.VehicleRearPlate  = substring(tab-generica.char-2,145,12)
                   ttReceiptDocument.Independent       = ((ttReceiptDocument.VehicleFrontPlate <> "") or
                                                          (ttReceiptDocument.VehicleRearPlate <> ""))
                   ttReceiptDocument.Driver            = int(substring(tab-generica.char-2,157,5))
                   ttReceiptDocument.RouteSite         = substring(tab-generica.char-2,162,3)
                   ttReceiptDocument.Route             = int(substring(tab-generica.char-2,165,6))
                   ttReceiptDocument.DepartureKM       = dec(substring(tab-generica.char-2,182,11))
                   ttReceiptDocument.ArrivalKM         = dec(substring(tab-generica.char-2,171,11))
                   ttReceiptDocument.ReshipmentCarrier = substring(tab-generica.char-2,3,12)
                   ttReceiptDocument.FreightModality   = IF l-redesp THEN 4 ELSE ttReceiptDocument.FreightModality.

    end.

    /* Le todos os trechos de simula‡Æo. Podem existir at‚ 6 trechos. */
    DO  i-cont = 1 TO 6:

        FOR FIRST tab-generica NO-LOCK
            WHERE tab-generica.utilizacao = "SimuNfEn":U
              AND tab-generica.char-1     = pSerieDocto + ";" + pNroDocto + ";" + STRING(pCodEmitente) + ";" + pNatOperacao + ";" + STRING(i-cont):

            CREATE ttFreightSimulation.
            ASSIGN ttFreightSimulation.DocumentSeries       = ENTRY(1,tab-generica.char-1,";")
                   ttFreightSimulation.DocumentNumber       = ENTRY(2,tab-generica.char-1,";")
                   ttFreightSimulation.CargoRouteNumber     = int(ENTRY(5,tab-generica.char-1,";"))
                   ttFreightSimulation.FreightTableNumber   = int(SUBSTRING(tab-generica.char-2,504,4))
                   ttFreightSimulation.Product              = int(SUBSTRING(tab-generica.char-2,508,4))
                   ttFreightSimulation.ValidityDate         = date(SUBSTRING(tab-generica.char-2,512,10))  
                   ttFreightSimulation.RouteNumber          = int(SUBSTRING(tab-generica.char-2,522,4))
/*                    ttFreightSimulation.TermNumber */
                   ttFreightSimulation.AgreedValue          = DEC(SUBSTRING(tab-generica.char-2,209,16)) 
                   ttFreightSimulation.FreightUnitValue     = DEC(SUBSTRING(tab-generica.char-2,1,16))
                   ttFreightSimulation.FreightValue         = DEC(SUBSTRING(tab-generica.char-2,17,16))
                   ttFreightSimulation.DaryValue            = DEC(SUBSTRING(tab-generica.char-2,33,16))    
                   ttFreightSimulation.ADEMEValue           = DEC(SUBSTRING(tab-generica.char-2,49,16))               
                   ttFreightSimulation.DispatchValue        = DEC(SUBSTRING(tab-generica.char-2,65,16))    
                   ttFreightSimulation.ITRValue             = DEC(SUBSTRING(tab-generica.char-2,81,16))
                   ttFreightSimulation.OthersValue          = DEC(SUBSTRING(tab-generica.char-2,193,16))
                   ttFreightSimulation.TollValue            = DEC(SUBSTRING(tab-generica.char-2,97,16))
                   ttFreightSimulation.InsuranceValue       = DEC(SUBSTRING(tab-generica.char-2,113,16))
                   ttFreightSimulation.SUFRAMAValue         = DEC(SUBSTRING(tab-generica.char-2,129,16))
                   ttFreightSimulation.CollectionRate       = DEC(SUBSTRING(tab-generica.char-2,145,16))
                   ttFreightSimulation.DeliveryRate         = DEC(SUBSTRING(tab-generica.char-2,161,16))
                   ttFreightSimulation.DispatchRateValue    = DEC(SUBSTRING(tab-generica.char-2,177,16))
                   ttFreightSimulation.Comments             = SUBSTRING(tab-generica.char-2,229,256).
            
            
        END.
    END.

end.
else do:

    FIND FIRST tab-generica NO-LOCK
         WHERE tab-generica.utilizacao = "item-nfe":u
         AND   tab-generica.char-1     = pSerieDocto + ";" + 
                                         pNroDocto + ";" + 
                                         STRING(pCodEmitente) + ";" + 
                                         pNatOperacao + ";" + 
                                         string(pSequencia) NO-ERROR.
    IF AVAIL tab-generica THEN DO:
        
        find first ttDocumentItem where ttDocumentItem.Sequence = pSequencia exclusive-lock no-error.
        if avail ttDocumentItem then
            assign ttDocumentItem.GrossWeight = tab-generica.dec-1
                   ttDocumentItem.CubicMeter  = DEC(SUBSTRING(tab-generica.char-2,1,6))
                   ttDocumentItem.CubedWeight = tab-generica.dec-2.
    end.

    /* Credito Pis e Cofins */
    /* Inicia com c¢digo tributa‡Æo do item da nota */
    find first ttDocumentItem where ttDocumentItem.Sequence = pSequencia exclusive-lock no-error.
    if avail ttDocumentItem THEN DO:

        IF ttDocumentItem.TaxCode_02 = 1 OR ttDocumentItem.TaxCode_03 = 1 THEN
            ASSIGN ttDocumentItem.FreightPisCofinsCode = 1.  /* tributado */
        ELSE ttDocumentItem.FreightPisCofinsCode = 2.  /* nÆo tributado */

        /* Busca exce‡äes e sobrepäe se for o caso */
        FOR EACH TAB-GENERICA NO-LOCK WHERE
                 TAB-GENERICA.UTILIZACAO = "CreditoPISCOFINS":

          
            FIND FIRST tr-docum-est
                 WHERE tr-docum-est.serie-docto  = pSerieDocto
                   AND tr-docum-est.nro-docto    = pNroDocto
                   AND tr-docum-est.nat-operacao = pNatOperacao 
                   AND tr-docum-est.cod-emitente = pCodEmitente  NO-LOCK NO-ERROR.
            IF NOT AVAIL tr-docum-est THEN NEXT.


            IF SUBSTRING(TAB-GENERICA.CHAR-1,1,3) = tr-docum-est.cod-estabel OR SUBSTRING(TAB-GENERICA.CHAR-1,40,5) = tr-docum-est.cod-estabel THEN DO:
               CREATE tt-tributa-item.
               ASSIGN tt-tributa-item.rTab-generica = ROWID(tab-generica)
                      tt-tributa-item.peso  = 10.
            END.
            ELSE IF SUBSTRING(TAB-GENERICA.CHAR-1,1,3) = "*" OR SUBSTRING(TAB-GENERICA.CHAR-1,40,5) = "*" THEN DO:
               CREATE tt-tributa-item.
               ASSIGN tt-tributa-item.rTab-generica = ROWID(tab-generica)
                      tt-tributa-item.peso  = 1.
            END.
            ELSE NEXT.
            
            IF SUBSTRING(TAB-GENERICA.CHAR-1,4,6) = tr-docum-est.nat-operacao THEN DO:
               
               IF AVAIL tt-tributa-item THEN
                   ASSIGN tt-tributa-item.peso  = tt-tributa-item.peso + 20.
               
            END.
            ELSE IF SUBSTRING(TAB-GENERICA.CHAR-1,4,6) = "*" THEN DO:
              
               IF AVAIL tt-tributa-item THEN
                   ASSIGN tt-tributa-item.peso  = tt-tributa-item.peso + 2.
              
            END.
            ELSE DO:
               IF AVAIL tt-tributa-item THEN
                   DELETE tt-tributa-item.
            END.


            IF SUBSTRING(TAB-GENERICA.CHAR-1,10,16) = ttDocumentItem.ItemCode THEN DO:
               
               IF AVAIL tt-tributa-item THEN
                   ASSIGN tt-tributa-item.peso  = tt-tributa-item.peso + 30.
               
            END.
            ELSE IF SUBSTRING(TAB-GENERICA.CHAR-1,10,16) = "*" THEN DO:
               
               IF AVAIL tt-tributa-item THEN
                   ASSIGN tt-tributa-item.peso  = tt-tributa-item.peso + 3.
               
            END.
            ELSE DO:
                IF AVAIL tt-tributa-item THEN
                   DELETE tt-tributa-item.
            END.
                        
        END.


        FOR EACH tt-tributa-item NO-LOCK 
            BREAK BY tt-tributa-item.peso DESCENDING:
               
            FIND FIRST tab-generica NO-LOCK WHERE
                 rowid(tab-generica) = tt-tributa-item.rtab-generica NO-ERROR.
            IF AVAIL tab-generica THEN
               ASSIGN ttDocumentItem.FreightPisCofinsCode = IF tab-generica.log-1 THEN 1 ELSE 2.
           
            LEAVE.
        END.    
    END.
end.
