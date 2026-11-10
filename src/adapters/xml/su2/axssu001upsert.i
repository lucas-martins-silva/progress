PROCEDURE PITransUpsert:
/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAMETER cEvent      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER cTranAction AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER r-docum-est AS ROWID      NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
DEFINE VARIABLE i-cont  AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-cont2 AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-redespachantes AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont-re AS INTEGER    NO-UNDO.

DEFINE VARIABLE h-cdapi995    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE de-pc-pis    AS DECIMAL FORMAT ">9.9999" NO-UNDO.
DEFINE VARIABLE de-pc-cofins AS DECIMAL FORMAT ">9.9999" NO-UNDO.
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

FIND docum-est WHERE ROWID(docum-est) = r-docum-est NO-LOCK NO-ERROR.

FIND FIRST emitente
     WHERE emitente.cod-emitente = docum-est.cod-emitente 
     NO-LOCK NO-ERROR.

FIND FIRST moeda
     WHERE moeda.mo-codigo = docum-est.mo-codigo 
     NO-LOCK NO-ERROR.

FIND FIRST natur-oper
     WHERE natur-oper.nat-operacao = docum-est.nat-operacao 
     NO-LOCK NO-ERROR.

/* Estabelecimento principal */
FIND FIRST estabelec 
     WHERE estabelec.cod-estabel = docum-est.cod-estabel 
     NO-LOCK NO-ERROR.

/* Estabelecimento fiscal */
DEFINE BUFFER bf-estab-fisc FOR estabelec.
FIND FIRST bf-estab-fisc   
     WHERE bf-estab-fisc.cod-estabel = docum-est.estab-fisc 
     NO-LOCK NO-ERROR.

/* Estabelecimento origem */
DEFINE BUFFER bf-estab-orig FOR estabelec.
FIND FIRST bf-estab-orig   
     WHERE bf-estab-orig.cod-estabel = docum-est.estab-de-or 
     NO-LOCK NO-ERROR.

EMPTY TEMP-TABLE ttReceiptDocument.
EMPTY TEMP-TABLE ttDocumentItem.
EMPTY TEMP-TABLE ttDocumentBill.
EMPTY TEMP-TABLE ttInventoryUpdate.
EMPTY TEMP-TABLE ttPurchaseOrder.
EMPTY TEMP-TABLE ttReceiptLocation.
EMPTY TEMP-TABLE ttValidationMessage.
EMPTY TEMP-TABLE ttAccessoryExpense.
EMPTY TEMP-TABLE ttBillTax.
EMPTY TEMP-TABLE ttDocumentForFreightDistr_00.

CREATE  ttReceiptDocument.
ASSIGN  ttReceiptDocument.VendorID                         = docum-est.cod-emitente                                     /*C¢digo interno de identifica‡Æo do fornecedor. (Uso interno: Campo = movind.docum-est.cod-emitente)*/
        ttReceiptDocument.VendorShortName                  = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""         /*Nome abreviado do fornecedor. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
        ttReceiptDocument.VendorTaxID                      = IF AVAIL emitente THEN emitente.cgc ELSE ""                /*CGC do fornecedor. (Uso interno: Campo = mgadm.emitente.cgc)*/
        ttReceiptDocument.AccountNumber                    = docum-est.ct-transit                                       /*N£mero da conta transit¢ria. (Uso interno: Campo = movind.docum-est.ct-transit)*/
        ttReceiptDocument.Comments                         = docum-est.cod-observa                                      /*C¢digo de observação do documento. Valores: 1 - Indústria, 2 - Comércio, 3 - Devolu‡Æo Cliente, 4 - Serviços (Uso interno: Campo = movind.docum-est.cod-observa - Include = ininc/i03in090.i)*/
        ttReceiptDocument.CurrencySign                     = IF AVAIL moeda THEN moeda.sigla ELSE ""                    /*Sigla padrÆo da moeda (Uso interno: Campo = mguni.moeda.sigla)*/
        ttReceiptDocument.CurrencyDescription              = IF AVAIL moeda THEN moeda.descricao ELSE ""                /*Descri‡Æo da moeda (Uso interno: Campo = mguni.moeda.descricao)*/
        ttReceiptDocument.CurrencyID                       = docum-est.mo-codigo                                        /*C¢digo da moeda. (Uso interno: Campo = movind.docum-est.mo-codigo)*/
        ttReceiptDocument.CurrentRate                      = docum-est.cotacao-dia                                      /*Cota‡Æo atual moeda. (Uso interno: Campo = movind.docum-est.cotacao-dia)*/
        ttReceiptDocument.DocumentAPStatus                 = docum-est.sit-docum                                        /*Situa‡Æo do Ötem em rela‡Æo a entrada da fatura no Contas Pagar. Valores: 1 - OK, 2 - Aguardando Fatura/Remito, 3 - Com problemas, 4 - Parcialmente Atendido, 5 - Aguardando Concilia‡Æo Batch. (Uso interno: Campo = movind.docum-est.sit-docum - Include = ininc/i06in090.i)*/
        ttReceiptDocument.DocumentFiscalClass              = docum-est.esp-fiscal                                       /*Esp‚cie fiscal do documento (Uso interno: Campo = movind.docum-est.esp-fiscal)*/
        ttReceiptDocument.DocumentNarrative                = docum-est.observacao                                       /*Narrativa / Observa‡äes. (Uso interno: Campo = movind.docum-est.observacao)*/
        ttReceiptDocument.DocumentNumber                   = docum-est.nro-docto                                        /*Numero do documento. (Uso interno: Campo = movind.docum-est.nro-docto)*/
        ttReceiptDocument.DocumentQualityControlStatus     = docum-est.estado                                           /*Estado do documento com rela‡Æo ao controle de Qualidade. Valores: 1 - Liberado, 2 - Controle de Qualidade, 3 - Devolu‡Æo. (Uso interno: Campo = movind.docum-est.estado)*/
        ttReceiptDocument.DocumentSeries                   = docum-est.serie-docto                                      /*Serie do documento. (Uso interno: Campo = movind.docum-est.serie-docto)*/
        ttReceiptDocument.DocumentSource                   = docum-est.origem                                           /*Origem do documento. (Uso interno: Campo = movind.docum-est.origem)*/
        ttReceiptDocument.DocumentTotalValue               = docum-est.tot-valor                                        /*Valor total do documento (Uso interno: Campo = movind.docum-est.tot-valor)*/
        ttReceiptDocument.DocumentTotalValue_00            = docum-est.tot-vl-fasb[1]                                   /*Valor total do documento (Uso interno: Campo = movind.docum-est.tot-vl-fasb[1])*/
        ttReceiptDocument.DocumentTotalValue_01            = docum-est.tot-vl-fasb[2]                                   /*Valor total do documento (Uso interno: Campo = movind.docum-est.tot-vl-fasb[2])*/
        ttReceiptDocument.DocumentTotalValue_02            = docum-est.tot-valor-me                                     /*Valor total do documento (Uso interno: Campo = movind.docum-est.tot-valor-me)*/
        ttReceiptDocument.DocumentTotalWeight              = docum-est.tot-peso                                         /*Peso total dos itens do documento. (Uso interno: Campo = movind.docum-est.tot-peso)*/
        ttReceiptDocument.DocumentType                     = docum-est.esp-docto                                        /*Especie do documento que originou o movimento de estoque, indentificada por um conjunto de indicadores (siglas) interno EMS2. Valores: 1 - ACA, 2 - ACT, 3 - NU1, 4 - DD, 5 - DEV, 6 - DIV, 7 - DRM, 8 - EAC, 9 - EGF, 10 - BEM, 11 - NU2, 12 - NU3, 13 - NU4, 14 - ICM, 15 - INV, 16 - IPL, 17 - MOB, 18 - NC, 19 - NF, 20 - NFD, 21 - NFE, 22 - NFS, 23 - NFT, 24 - NU5, 25 - REF, 26 - RCS, 27 - RDD, 28 - REQ, 29 - RFS, 30 - RM, 31 - RRQ, 32 - STR, 33 - TRA, 34 - ZZZ, 35 - SOB, 36 - EDD, 37 - VAR, 38 - ROP. (Uso interno: Campo = movind.docum-est.esp-docto - Include = ininc/i03in218.i)*/
        ttReceiptDocument.ExpenseValue                     = docum-est.despesa-nota                                     /*Valor total despesas acessorias do documento. (Uso interno: Campo = movind.docum-est.despesa-nota)*/
        ttReceiptDocument.ExpenseValue_00                  = docum-est.desp-fasb[1]                                     /*Valor total despesas acessorias do documento. (Uso interno: Campo = movind.docum-est.desp-fasb[1])*/
        ttReceiptDocument.ExpenseValue_01                  = docum-est.desp-fasb[2]                                     /*Valor total despesas acessorias do documento. (Uso interno: Campo = movind.docum-est.desp-fasb[2])*/
        ttReceiptDocument.ExpenseValue_02                  = docum-est.despesa-nota-me                                  /*Valor total despesas acessorias do documento. (Uso interno: Campo = movind.docum-est.despesa-nota-me)*/
        ttReceiptDocument.FASBCurrentRate                  = docum-est.cotacao-fasb                                     /*Cota‡Æo atual moeda FASB. (Uso interno: Campo = movind.docum-est.cotacao-fasb)*/
        ttReceiptDocument.FiscalOperationCode              = docum-est.nat-operacao                                     /*C¢digo natureza de opera‡Æo. (Uso interno: Campo = movind.docum-est.nat-operacao)*/
        ttReceiptDocument.FiscalOperationDescription       = IF AVAIL natur-oper THEN natur-oper.denominacao ELSE ""    /*Descri‡Æo da natureza de opera‡Æo. (Uso interno: Campo = mgind.natur-oper.denominacao)*/
      &if "{&bf_dis_versao_ems}" >=  "2.08" &then
        /*novos campos */
        ttReceiptDocument.EndConsumer                      = IF AVAIL natur-oper THEN natur-oper.consum-final ELSE NO
        ttReceiptDocument.Type_00                          = IF AVAIL natur-oper THEN natur-oper.tipo         ELSE 1
        ttReceiptDocument.Transfer                         = IF AVAIL natur-oper THEN natur-oper.transf       ELSE NO
        ttReceiptDocument.Kind_00                          = IF AVAIL natur-oper THEN natur-oper.especie-doc  ELSE ""
        /*end novos campos*/
      &endif
        ttReceiptDocument.FreightDistributionMethod        = docum-est.rateia-frete                                     /*Tipo de rateio do frete. Valores: 1 - Peso, 2 - Valor. (Uso interno: Campo = movind.docum-est.rateia-frete - Include = ininc/i04in292.i)*/
        ttReceiptDocument.FreightModality                  = docum-est.mod-frete                                        /*Modalidade de frete. Valores: 1 - CIF, 2 - FOB (Uso interno: Campo = movind.docum-est.mod-frete - Include = diinc/i01di037.i)*/
        ttReceiptDocument.FreightTax                       = docum-est.icm-fonte                                        /*ICMS substituto, referente ao frete constante da nota fiscal. (Uso interno: Campo = movind.docum-est.icm-fonte)*/
        ttReceiptDocument.FreightTax_00                    = docum-est.icm-fnt-fasb[1]                                  /*ICMS substituto, referente ao frete constante da nota fiscal. (Uso interno: Campo = movind.docum-est.icm-fnt-fasb[1])*/
        ttReceiptDocument.FreightTax_01                    = docum-est.icm-fnt-fasb[2]                                  /*ICMS substituto, referente ao frete constante da nota fiscal. (Uso interno: Campo = movind.docum-est.icm-fnt-fasb[2])*/
        ttReceiptDocument.FreightValue                     = docum-est.valor-frete                                      /*Valor total despesas com frete. (Uso interno: Campo = movind.docum-est.valor-frete)*/
        ttReceiptDocument.FreightValue_00                  = docum-est.vl-fre-fasb[1]                                   /*Valor total despesas com frete. (Uso interno: Campo = movind.docum-est.vl-fre-fasb[1])*/
        ttReceiptDocument.FreightValue_01                  = docum-est.vl-fre-fasb[2]                                   /*Valor total despesas com frete. (Uso interno: Campo = movind.docum-est.vl-fre-fasb[2])*/
        ttReceiptDocument.FreightValue_02                  = docum-est.valor-frete-me                                   /*Valor total despesas com frete. (Uso interno: Campo = movind.docum-est.valor-frete-me)*/
        ttReceiptDocument.GoodsValue                       = docum-est.valor-mercad                                     /*Valor total das mercadorias. (Uso interno: Campo = movind.docum-est.valor-mercad)*/
        ttReceiptDocument.GoodsValue_00                    = docum-est.vl-merc-fasb[1]                                  /*Valor total das mercadorias. (Uso interno: Campo = movind.docum-est.vl-merc-fasb[1])*/
        ttReceiptDocument.GoodsValue_01                    = docum-est.vl-merc-fasb[2]                                  /*Valor total das mercadorias. (Uso interno: Campo = movind.docum-est.vl-merc-fasb[2])*/
        ttReceiptDocument.GoodsValue_02                    = docum-est.valor-mercad-me                                  /*Valor total das mercadorias. (Uso interno: Campo = movind.docum-est.valor-mercad-me)*/
        ttReceiptDocument.ImportationStatement             = docum-est.declaracao-import                                /*Declara‡Æo de importa‡Æo.(Uso interno: Campo = movind.docum-est.declaracao-import)*/
        ttReceiptDocument.InsuranceValue                   = docum-est.valor-seguro                                     /*Valor total de seguro. (Uso interno: Campo = movind.docum-est.valor-seguro)*/
        ttReceiptDocument.InsuranceValue_00                = docum-est.vl-seg-fasb[1]                                   /*Valor total de seguro. (Uso interno: Campo = movind.docum-est.vl-seg-fasb[1])*/
        ttReceiptDocument.InsuranceValue_01                = docum-est.vl-seg-fasb[2]                                   /*Valor total de seguro. (Uso interno: Campo = movind.docum-est.vl-seg-fasb[2])*/
        ttReceiptDocument.InsuranceValue_02                = docum-est.valor-seguro-me                                  /*Valor total de seguro. (Uso interno: Campo = movind.docum-est.valor-seguro-me)*/
        ttReceiptDocument.InvoiceDocumentType              = docum-est.tipo-nota                                        /*Tipo de nota fiscal. Valores: 1 - Compra, 2 - Beneficiamento, 3 - Devolu‡Æo, 4 - Consigna‡Æo,5 - Transferˆncia. (Uso iNterno: Campo = movind.docum-est.tipo-nota)*/
        ttReceiptDocument.IsDistributionDocument           = docum-est.ind-rateio                                       /*Nota fiscal de rateio. (Uso interno: Campo = movind.docum-est.ind-rateio)*/
        ttReceiptDocument.IsDocumentIssuedByPostSite       = docum-est.nf-emitida-est                                   /*Nota fiscal emitida pelo pr¢prio estabelecimento. (Uso interno: Campo = movind.docum-est.nf-emitida-est)*/
        ttReceiptDocument.IsInvoiceDocument                = docum-est.nff                                              /*Indicador de nota fiscal de fatura. (Uso interno: Campo = movind.docum-est.nff)*/
        ttReceiptDocument.IsRepresentativeComissionCanc_00 = docum-est.estorn-comis                                     /*Efetua estorno da comissÆo dos representantes. (Uso interno: Campo = movind.docum-est.estorn-comis)*/
        ttReceiptDocument.NotTaxedValue                    = docum-est.ipi-nao-trib                                     /*Valor da base de c lculo do IPI nÆo tributado. (Uso interno: Campo = movind.docum-est.ipi-nao-trib)*/
        ttReceiptDocument.NotTaxedValue_00                 = docum-est.iss-nao-trib                                     /*Valor da base de c lculo do ISS nÆo tributado. (Uso interno: Campo = movind.docum-est.iss-nao-trib)*/
        ttReceiptDocument.NotTaxedValue_01                 = docum-est.icm-nao-trib                                     /*Valor da base de c lculo do ICMS nÆo tributado. (Uso interno: Campo = movind.docum-est.icm-nao-trib)*/
        ttReceiptDocument.NotTaxedValue_02                 = docum-est.ipi-ntr-fasb[1]                                  /*Valor da base de c lculo do IPI nÆo tributado. (Uso interno: Campo = movind.docum-est.ipi-ntr-fasb[1])*/
        ttReceiptDocument.NotTaxedValue_03                 = docum-est.iss-ntr-fasb[1]                                  /*Valor da base de c lculo do ISS nÆo tributado. (Uso interno: Campo = movind.docum-est.iss-ntr-fasb[1])*/
        ttReceiptDocument.NotTaxedValue_04                 = docum-est.icm-ntr-fasb[1]                                  /*Valor da base de c lculo do ICMS nÆo tributado. (Uso interno: Campo = movind.docum-est.icm-ntr-fasb[1])*/
        ttReceiptDocument.NotTaxedValue_05                 = docum-est.ipi-ntr-fasb[2]                                  /*Valor da base de c lculo do IPI nÆo tributado. (Uso interno: Campo = movind.docum-est.ipi-ntr-fasb[2])*/
        ttReceiptDocument.NotTaxedValue_06                 = docum-est.iss-ntr-fasb[2]                                  /*Valor da base de c lculo do ISS nÆo tributado. (Uso interno: Campo = movind.docum-est.iss-ntr-fasb[2])*/
        ttReceiptDocument.NotTaxedValue_07                 = docum-est.icm-ntr-fasb[2]                                  /*Valor da base de c lculo do ICMS nÆo tributado. (Uso interno: Campo = movind.docum-est.icm-ntr-fasb[2])*/
        ttReceiptDocument.OtherExpensesValue               = docum-est.valor-outras                                     /*Valor total de outras despesas aplicadas a nota fiscal, al‚m do frete, seguro e embalagem. (Uso interno: Campo = movind.docum-est.valor-outras)*/
        ttReceiptDocument.OtherExpensesValue_00            = docum-est.vl-out-fasb[1]                                   /*Valor total de outras despesas aplicadas a nota fiscal, al‚m do frete, seguro e embalagem. (Uso interno: Campo = movind.docum-est.vl-out-fasb[1])*/
        ttReceiptDocument.OtherExpensesValue_01            = docum-est.vl-out-fasb[2]                                   /*Valor total de outras despesas aplicadas a nota fiscal, al‚m do frete, seguro e embalagem. (Uso interno: Campo = movind.docum-est.vl-out-fasb[2])*/
        ttReceiptDocument.OtherExpensesValue_02            = docum-est.valor-outras-me                                  /*Valor total de outras despesas aplicadas a nota fiscal, al‚m do frete, seguro e embalagem. (Uso interno: Campo = movind.docum-est.valor-outras-me)*/
        ttReceiptDocument.PackagingValue                   = docum-est.valor-embal                                      /*Valor total despesas com embalagem. (Uso interno: Campo = movind.docum-est.valor-embal)*/
        ttReceiptDocument.PackagingValue_00                = docum-est.vl-emb-fasb[1]                                   /*Valor total despesas com embalagem. (Uso interno: Campo = movind.docum-est.vl-emb-fasb[1])*/
        ttReceiptDocument.PackagingValue_01                = docum-est.vl-emb-fasb[2]                                   /*Valor total despesas com embalagem. (Uso interno: Campo = movind.docum-est.vl-emb-fasb[2])*/
        ttReceiptDocument.PackagingValue_02                = docum-est.valor-embal-me                                   /*Valor total despesas com embalagem. (Uso interno: Campo = movind.docum-est.valor-embal-me)*/
        ttReceiptDocument.PrintDate                        = docum-est.dt-emissao                                       /*Data de emissão do documento. (Uso interno: Campo = movind.docum-est.dt-emissao)*/
        ttReceiptDocument.ShipmentNumber                   = docum-est.embarque                                         /*N£mero do embarque. (Uso interno: Campo = movind.docum-est.embarque)*/
        ttReceiptDocument.ShippingMethod                   = docum-est.via-transp                                       /*Via de transporte recebimento. Valores: 1 - Rodoviario, 2 - Aeroviario, 3 - Maritimo, 4 - Ferroviario, 5 - Rodoferroviario, 6 - Rodofluvial, 7 - Rodoaeroviario, 8 - Outros. (Uso interno: Campo = movind.docum-est.via-transp - Include = adinc/i01ad268.i)*/
        ttReceiptDocument.SiteID                           = docum-est.cod-estabel                                      /*C¢digo do estabelecimento. (Uso interno: Campo = movind.docum-est.cod-estabel)*/
        ttReceiptDocument.SiteID_00                        = docum-est.estab-fisc                                       /*C¢digo do estabelecimento origem. (Uso interno: Campo = movind.docum-est.estab-fisc)*/
        ttReceiptDocument.SiteID_01                        = docum-est.estab-de-or                                      /*C¢digo do estabelecimento origem. (Uso interno: Campo = movind.docum-est.estab-de-or)*/
        ttReceiptDocument.SiteDescription_00               = IF AVAIL bf-estab-fisc THEN bf-estab-fisc.nome ELSE ""     /*Descri‡Æo do estabelecimento. (Uso interno: Campo = mgadm.estabelec.nome)*/
        ttReceiptDocument.SiteDescription_01               = IF AVAIL bf-estab-orig THEN bf-estab-orig.nome ELSE ""     /*Descri‡Æo do estabelecimento. (Uso interno: Campo = mgadm.estabelec.nome)*/        
        ttReceiptDocument.SourceState                      = docum-est.uf                                               /*Unidade da federação. (Uso interno: Campo = movind.docum-est.uf)*/
        ttReceiptDocument.SubAccountNumber                 = docum-est.sc-transit                                       /*N£mero da subconta transit¢ria. (Uso interno: Campo = movind.docum-est.sc-transit)*/
        ttReceiptDocument.SupplementaryTax                 = docum-est.icm-complem                                      /*ICMS complementar, referente à notas fiscais de compra para consumo final oriund                              =e outros estados. (Uso interno: Campo = movind.docum-est.icm-complem)*/
        ttReceiptDocument.SupplementaryTax_00              = docum-est.icm-cpl-fasb[1]                                  /*ICMS complementar, referente à notas fiscais de compra para consumo final oriund                              =e outros estados. (Uso interno: Campo = movind.docum-est.icm-cpl-fasb[1])*/
        ttReceiptDocument.SupplementaryTax_01              = docum-est.icm-cpl-fasb[2]                                  /*ICMS complementar, referente à notas fiscais de compra para consumo final oriund                              =e outros estados. (Uso interno: Campo = movind.docum-est.icm-cpl-fasb[2])*/
        ttReceiptDocument.TaxCalculationBasis              = docum-est.base-ipi                                         /*Base de c lculo de IPI. (Uso interno: Campo = movind.docum-est.base-ipi)*/
        ttReceiptDocument.TaxCalculationBasis_00           = docum-est.base-iss                                         /*Base de c lculo de ISS. (Uso interno: Campo = movind.docum-est.base-iss)*/
        ttReceiptDocument.TaxCalculationBasis_01           = docum-est.base-icm                                         /*Base de c lculo de ICMS. (Uso interno: Campo = movind.docum-est.base-icm)*/
        ttReceiptDocument.TaxCalculationBasis_02           = docum-est.base-ipi-fas[1]                                  /*Base de c lculo de IPI. (Uso interno: Campo = movind.docum-est.base-ipi-fas[1])*/
        ttReceiptDocument.TaxCalculationBasis_03           = docum-est.base-iss-fas[1]                                  /*Base de c lculo de ISS. (Uso interno: Campo = movind.docum-est.base-iss-fas[1])*/
        ttReceiptDocument.TaxCalculationBasis_04           = docum-est.base-icm-fas[1]                                  /*Base de c lculo de ICMS. (Uso interno: Campo = movind.docum-est.base-icm-fas[1])*/
        ttReceiptDocument.TaxCalculationBasis_05           = docum-est.base-ipi-fas[2]                                  /*Base de c lculo de IPI. (Uso interno: Campo = movind.docum-est.base-ipi-fas[2])*/
        ttReceiptDocument.TaxCalculationBasis_06           = docum-est.base-iss-fas[2]                                  /*Base de c lculo de ISS. (Uso interno: Campo = movind.docum-est.base-iss-fas[2])*/
        ttReceiptDocument.TaxCalculationBasis_07           = docum-est.base-icm-fas[2]                                  /*Base de c lculo de ICMS. (Uso interno: Campo = movind.docum-est.base-icm-fas[2])*/
        ttReceiptDocument.TaxDueDate                       = docum-est.dt-venc-ipi                                      /*Data de vencimento do IPI. (Uso interno: Campo = movind.docum-est.dt-venc-ipi)*/
        ttReceiptDocument.TaxDueDate_00                    = docum-est.dt-venc-iss                                      /*Data de vencimento do ISS. (Uso interno: Campo = movind.docum-est.dt-venc-iss)*/
        ttReceiptDocument.TaxDueDate_01                    = docum-est.dt-venc-icm                                      /*Data de vencimento do ICMS. (Uso interno: Campo = movind.docum-est.dt-venc-icm)*/
        ttReceiptDocument.TaxOnExpenses                    = docum-est.ipi-despesa                                      /*Valor de IPI sobre despesas documento. (Uso interno: Campo = movind.docum-est.ipi-despesa)*/
        ttReceiptDocument.TaxOtherValue                    = docum-est.ipi-outras                                       /*Valor da base de c lculo do IPI Outras. (Uso interno: Campo = movind.docum-est.ipi-outras)*/
        ttReceiptDocument.TaxOtherValue_00                 = docum-est.iss-outras                                       /*Valor da base de c lculo do ISS Outras. (Uso interno: Campo = movind.docum-est.iss-outras)*/
        ttReceiptDocument.TaxOtherValue_01                 = docum-est.icm-outras                                       /*Valor da base de c lculo do ICMS Outras. (Uso interno: Campo = movind.docum-est.icm-outras)*/
        ttReceiptDocument.TaxOtherValue_02                 = docum-est.ipi-out-fasb[1]                                  /*Valor da base de c lculo do IPI Outras. (Uso interno: Campo = movind.docum-est.ipi-out-fasb[1])*/
        ttReceiptDocument.TaxOtherValue_03                 = docum-est.iss-out-fasb[1]                                  /*Valor da base de c lculo do ISS Outras. (Uso interno: Campo = movind.docum-est.iss-out-fasb[1])*/
        ttReceiptDocument.TaxOtherValue_04                 = docum-est.icm-out-fasb[1]                                  /*Valor da base de c lculo do ICMS Outras. (Uso interno: Campo = movind.docum-est.icm-out-fasb[1])*/
        ttReceiptDocument.TaxOtherValue_05                 = docum-est.ipi-out-fasb[2]                                  /*Valor da base de c lculo do IPI Outras. (Uso interno: Campo = movind.docum-est.ipi-out-fasb[2])*/
        ttReceiptDocument.TaxOtherValue_06                 = docum-est.iss-out-fasb[2]                                  /*Valor da base de c lculo do ISS Outras. (Uso interno: Campo = movind.docum-est.iss-out-fasb[2])*/
        ttReceiptDocument.TaxOtherValue_07                 = docum-est.icm-out-fasb[2]                                  /*Valor da base de c lculo do ICMS Outras. (Uso interno: Campo = movind.docum-est.icm-out-fasb[2])*/
        ttReceiptDocument.TaxPercentage                    = docum-est.aliquota-iss                                     /*Aliquota ISS. (Uso interno: Campo = movind.docum-est.aliquota-iss)*/
        ttReceiptDocument.TaxPercentage_00                 = docum-est.aliquota-icm                                     /*Aliquota ICMS. (Uso interno: Campo = movind.docum-est.aliquota-icm)*/
        ttReceiptDocument.TaxValue                         = docum-est.ipi-deb-cre                                      /*Valor total de IPI. (Uso interno: Campo = movind.docum-est.ipi-deb-cre)*/
        ttReceiptDocument.TaxValue_00                      = docum-est.iss-deb-cre                                      /*Valor total de ISS. (Uso interno: Campo = movind.docum-est.iss-deb-cre)*/
        ttReceiptDocument.TaxValue_01                      = docum-est.icm-deb-cre                                      /*Valor total do ICMS das mercadorias da nota fiscal, dos itens e o valor da diferença entre o total da nota e total dos itens. (Uso interno: Campo = movind.docum-est.icm-deb-cre)*/
        ttReceiptDocument.TaxValue_02                      = docum-est.ipi-dc-fasb[1]                                   /*Valor total de IPI. (Uso interno: Campo = movind.docum-est.ipi-dc-fasb[1])*/
        ttReceiptDocument.TaxValue_03                      = docum-est.iss-dc-fasb[1]                                   /*Valor total de ISS. (Uso interno: Campo = movind.docum-est.iss-dc-fasb[1])*/
        ttReceiptDocument.TaxValue_04                      = docum-est.icm-dc-fasb[1]                                   /*Valor total do ICMS das mercadorias da nota fiscal, dos itens e o valor da diferença entre o total da nota e total dos itens. (Uso interno: Campo = movind.docum-est.icm-dc-fasb[1])*/
        ttReceiptDocument.TaxValue_05                      = docum-est.ipi-dc-fasb[2]                                   /*Valor total de IPI. (Uso interno: Campo = movind.docum-est.ipi-dc-fasb[2])*/
        ttReceiptDocument.TaxValue_06                      = docum-est.icm-dc-fasb[2]                                   /*Valor total de ISS. (Uso interno: Campo = movind.docum-est.iss-dc-fasb[2])*/
        ttReceiptDocument.TaxValue_07                      = docum-est.icm-dc-fasb[2]                                   /*Valor total do ICMS das mercadorias da nota fiscal, dos itens e o valor da diferença entre o total da nota e total dos itens. (Uso interno: Campo = movind.docum-est.icm-dc-fasb[2])*/
        ttReceiptDocument.TotalDiscountValue               = docum-est.tot-desconto                                     /*Total de descontos da Nota Fiscal. (Uso interno: Campo = movind.docum-est.tot-desconto)*/
        ttReceiptDocument.TotalDiscountValue_00            = docum-est.tot-des-fasb[1]                                  /*Total de descontos da Nota Fiscal. (Uso interno: Campo = movind.docum-est.tot-des-fasb[1]*/
        ttReceiptDocument.TotalDiscountValue_01            = docum-est.tot-des-fasb[2]                                  /*Total de descontos da Nota Fiscal. (Uso interno: Campo = movind.docum-est.tot-des-fasb[2]*/
        ttReceiptDocument.TotalDiscountValue_02            = docum-est.tot-desconto-me                                  /*Total de descontos da Nota Fiscal. (Uso interno: Campo = movind.docum-est.tot-desconto-me)*/
        ttReceiptDocument.TotalTaxValue                    = docum-est.tot-taxa                                         /*Valor total dos impostos do documento. (Uso interno: Campo = movind.docum-est.tot-taxa)*/
        ttReceiptDocument.TotalTaxValue_00                 = docum-est.tot-taxa-me                                      /*Valor total dos impostos do documento. (Uso interno: Campo = movind.docum-est.tot-taxa-me)*/
        ttReceiptDocument.TransactionDate                  = docum-est.dt-trans                                         /*Data da transa‡Æo. (Uso interno: Campo = movind.docum-est.dt-trans)*/
        ttReceiptDocument.TransactionType                  = docum-est.tipo-docto                                       /*Tipo do documento. Valores: 1 - Entrada, 2 - Saida. (Uso interno: Campo = movind.docum-est.tipo-docto - Include = ininc/i01in218.i)*/
        ttReceiptDocument.TributarySubstitutionBasis       = docum-est.base-subs                                        /*Base de c lculo para o ICMS por regime de Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.docum-est.base-subs)*/
        ttReceiptDocument.TributarySubstitutionBasis_00    = docum-est.base-pis-subs                                    /*Base de c lculo para o PIS por regime de Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.docum-est.base-pis-subs)*/
        ttReceiptDocument.TributarySubstitutionBasis_01    = docum-est.base-cofins-subs                                 /*Base de c lculo para o COFINS por regime de Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.docum-est.base-cofins-subs)*/
        ttReceiptDocument.TributarySubstitutionBasis_02    = docum-est.base-subs-fasb[1]                                /*Base de c lculo para o ICMS por regime de Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.docum-est.base-subs-fasb[1])*/
        ttReceiptDocument.TributarySubstitutionBasis_03    = docum-est.base-subs-fasb[2]                                /*Base de c lculo para o ICMS por regime de Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.docum-est.base-subs-fasb[2])*/
        ttReceiptDocument.TributarySubstitutionValue       = docum-est.vl-subs                                          /*Valor do ICMS recolhido por Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.docum-est.vl-subs)*/
        ttReceiptDocument.TributarySubstitutionValue_00    = docum-est.vl-pis-subs                                      /*Valor do PIS recolhido por Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.docum-est.vl-pis-subs)*/
        ttReceiptDocument.TributarySubstitutionValue_01    = docum-est.vl-cofins-subs                                   /*Valor do COFINS recolhido por Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.docum-est.vl-cofins-subs)*/
        ttReceiptDocument.TributarySubstitutionValue_02    = docum-est.vl-subs-fasb[1]                                  /*Valor do ICMS recolhido por Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.docum-est.vl-subs-fasb[1])*/
        ttReceiptDocument.TributarySubstitutionValue_03    = docum-est.vl-subs-fasb[2]                                  /*Valor do ICMS recolhido por Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.docum-est.vl-subs-fasb[2])*/
        ttReceiptDocument.ServiceID                        = IF SUBSTRING(docum-est.char-2,90,5) <> ? AND SUBSTRING(docum-est.char-2,90,5) <> "" THEN INT(SUBSTRING(docum-est.char-2,90,5)) ELSE 0 /*C¢digo do servi‡o de frete do item. (Uso interno: Atributo Livre EMS2.04 = movind.docum-est.char-2, posi‡Æo inicial = 90, posi‡Æo final = 94, N£mero de posi‡äes = 05 - Campo EMS2.05 = movind.docum-est.cod-servico)*/
        ttReceiptDocument.VendorsRestokingPercentage       = 0
        ttReceiptDocument.VendorsRestokingValue            = 0
        ttReceiptDocument.IsOtherExpensesInvoice           = FALSE.

    &if '{&bf_mat_versao_ems}' > '2.04' &then
        ASSIGN  ttReceiptDocument.VendorsRestokingPercentage   = docum-est.val-perc-restocagem                           /*Percentual de restocagem praticado pelo fornecedor. (Uso interno: Campo = movind.docum-est.val-perc-restocagem)*/
                ttReceiptDocument.VendorsRestokingValue        = docum-est.val-restocagem                                /*Valor de restocagem praticado pelo fornecedor. (Uso interno: Campo = movind.docum-est.val-restocagem)*/
                ttReceiptDocument.IsOtherExpensesInvoice       = docum-est.fat-despesa                                   /*Fatura de outras despesas. (Uso interno: Campo = movind.docum-est.fat-despesa)*/
                ttReceiptDocument.DocumentValidityDate         = docum-est.dat-validade                                  /*Data de validade do documento. (Uso interno: Campo = movind.docum-est.dat-validade)*/
                ttReceiptDocument.RMANumber                    = docum-est.cod-rma.                                      /*N£mero da RMA. (Uso interno: Campo = movind.docum-est.cod-rma)*/

        /* Informa‡äes Contato */
        FIND FIRST cont-emit
             WHERE cont-emit.cod-emitente      = docum-est.cod-emitente
             AND   cont-emit.sequencia         = docum-est.num-seq-cont-emit
             NO-LOCK NO-ERROR.
        IF   AVAIL cont-emit THEN 
             ASSIGN ttReceiptDocument.ContactSequence              = cont-emit.sequencia                                 /*Sequencia contato. (Uso interno: Campo = mgadm.cont-emit.sequencia)*/ 
                    ttReceiptDocument.ContactName                  = cont-emit.nome                                      /*Nome do contato. (Uso interno: Campo = mgadm.cont-emit.nome)*/                   
                    ttReceiptDocument.PhoneNumber                  = cont-emit.telefone                                  /*Telefone do contato. (Uso interno: Campo = mgadm.cont-emit.telefone)*/         
                    ttReceiptDocument.EmailAddress                 = cont-emit.e-mail.                                   /*E-mail do contato. (Uso interno: Campo = mgadm.cont-emit.e-mail)*/              
    &endif 
   
    /*Altera‡Æo projeto 1006*/
    &IF '{&BF_DIS_VERSAO_EMS}' >= '2.08' &THEN
    
        if  not valid-handle(h-boad123a) then
            run adbo/boad123a.p persistent set h-boad123a.

        run openQueryStatic in h-boad123a ('main').
        run goToKey         in h-boad123a ('SPP_TOTVSGFE').
        if  return-value = "NOK" then
            assign l-func-totvsgfe = no.
        else
            run getLogField in h-boad123a (input  'ativo',
                                           output l-func-totvsgfe).
        IF l-func-totvsgfe THEN DO:      
            FIND FIRST tab-generica
                WHERE tab-generica.utilizacao = "SETUP" NO-LOCK NO-ERROR.
            IF AVAIL tab-generica AND SUBSTRING(tab-generica.char-2,120,1) = "1" THEN DO:
            
                run adapters/xml/trp/axstr006.p (input 1,
                                                 input docum-est.serie-docto,
                                                 input docum-est.nro-docto,
                                                 input docum-est.cod-emitente,
                                                 input docum-est.nat-operacao,
                                                 input 0,
                                                 input-output table ttReceiptDocument,
                                                 input-output table ttDocumentItem,
                                                 input-output table ttAgent,
                                                 INPUT-OUTPUT TABLE ttFreightSimulation).
    
                find first ttReceiptDocument exclusive-lock no-error.
            END.
        end.

         IF VALID-HANDLE (h-boad123a) THEN
            RUN destroy IN h-boad123a.
    &ENDIF
    
    /* Informa‡äes Estabelecimento Principal */    
    IF  AVAIL estabelec THEN DO:
        ASSIGN ttReceiptDocument.SiteDescription  = estabelec.nome.           /*Descri‡Æo do estabelecimento. (Uso interno: Campo = mgadm.estabelec.nome)*/
        /* Localiza o emitente relacionado ao estabelecimento principal */

        
      &if "{&bf_dis_versao_ems}" >=  "2.08" &then   
         FIND FIRST emitente NO-LOCK
              WHERE emitente.cgc  = estabelec.cgc NO-ERROR.
         IF   AVAIL emitente THEN
             ASSIGN ttReceiptDocument.SiteShortName = emitente.nome-abrev     /*Nome do estabelecimento. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
                    ttReceiptDocument.SiteTaxID     = emitente.cgc            /*CGC do estabelecimento. (Uso interno: Campo = mgadm.emitente.cgc)*/
                    ttReceiptDocument.RelatedVendor = emitente.cod-emitente.
      &else
         FIND FIRST emitente NO-LOCK
              WHERE emitente.cod-emitente  = estabelec.cod-emitente NO-ERROR.
         IF   AVAIL emitente THEN
              ASSIGN ttReceiptDocument.SiteShortName            = emitente.nome-abrev                                      /*Nome do estabelecimento. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
                     ttReceiptDocument.SiteTaxID                = emitente.cgc.                                            /*CGC do estabelecimento. (Uso interno: Campo = mgadm.emitente.cgc)*/
      &endif
    END.

/* Leitura dos itens do documento */
IF NOT VALID-HANDLE(h-cdapi995) THEN
    RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.

ASSIGN i-cont = 0.

FOR EACH  item-doc-est NO-LOCK
    WHERE item-doc-est.serie-docto  = docum-est.serie-docto 
    AND   item-doc-est.nro-docto    = docum-est.nro-docto   
    AND   item-doc-est.nat-operacao = docum-est.nat-operacao
    AND   item-doc-est.cod-emitente = docum-est.cod-emitente:

    /* Localiza‡Æo */
    FIND FIRST localizacao 
         WHERE localizacao.cod-localiz = item-doc-est.cod-localiz 
         NO-LOCK NO-ERROR.

    /* Dep¢sito */
    FIND FIRST deposito 
         WHERE deposito.cod-depos = item-doc-est.cod-depos 
         NO-LOCK NO-ERROR.

    /* Emitente */
    FIND FIRST emitente
         WHERE emitente.cod-emitente = item-doc-est.cod-emit-terc 
         NO-LOCK NO-ERROR.

    /* Emitente Beneficiamento */
    DEFINE BUFFER bf-emit-benef FOR emitente.
    FIND FIRST bf-emit-benef
         WHERE bf-emit-benef.cod-emitente = item-doc-est.cod-emit-benef 
         NO-LOCK NO-ERROR.

    /* Classifica‡Æo Fiscal */
    FIND FIRST classif-fisc 
         WHERE classif-fisc.class-fiscal = item-doc-est.class-fiscal 
         NO-LOCK NO-ERROR.

    /* Natureza de Opera‡Æo */
    FIND FIRST natur-oper
         WHERE natur-oper.nat-operacao = item-doc-est.nat-comp 
         NO-LOCK NO-ERROR.
    
    /* Natureza de Opera‡Æo Terceiros */
    DEFINE BUFFER bf-nat-op-terc FOR natur-oper.
    FIND FIRST bf-nat-op-terc 
         WHERE bf-nat-op-terc.nat-operacao = item-doc-est.nat-terc 
         NO-LOCK NO-ERROR.

    /* Item */
    FIND FIRST ITEM 
         WHERE ITEM.it-codigo = item-doc-est.it-codigo 
         NO-LOCK NO-ERROR.

    /* Roteiro Fabrica‡Æo */
    FIND FIRST rot-fabric 
         WHERE rot-fabric.cod-roteiro = item-doc-est.cod-roteiro 
         NO-LOCK NO-ERROR.

    /* Estabelecimento */
    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = item-doc-est.est-cob 
         NO-LOCK NO-ERROR.

    /* Unidade de Medida */
    FIND FIRST tab-unidade 
         WHERE tab-unidade.un = item-doc-est.un 
         NO-LOCK NO-ERROR.

    /* --- Knupp - Alteracoes para envio data do pedido na chave do SGT --- */
    FIND FIRST pedido-compr 
         WHERE pedido-compr.num-pedido = item-doc-est.num-pedido
         NO-LOCK NO-ERROR.

    FIND FIRST ordem-compra
         WHERE ordem-compra.numero-ordem = item-doc-est.numero-ordem 
        NO-LOCK NO-ERROR.
    IF AVAIL ordem-compra THEN DO:
        /*Requisi‡Æo */
        FIND FIRST requisicao
             WHERE requisicao.nr-requisicao =  ordem-compra.nr-requisicao
             NO-LOCK NO-ERROR.
    
        /*itens da requisi‡Æo*/
          FIND FIRST it-requisicao
               WHERE it-requisicao.nr-requisicao = ordem-compra.nr-requisicao
               AND   it-requisicao.sequencia     = ordem-compra.sequencia
               NO-LOCK NO-ERROR.

    END.

         
    ASSIGN i-cont = i-cont + 1.

    CREATE  ttDocumentItem.
    ASSIGN  ttDocumentItem.ttDocumentItemID                 = i-cont
            ttDocumentItem.AccountNumber                    = item-doc-est.ct-codigo                                            /*N£mero da conta. (Uso interno: Campo = movind.item-doc-est.ct-codigo)*/
            ttDocumentItem.APStatus                         = item-doc-est.sit-item                                             /*Situa‡Æo do Ötem em rela‡Æo a entrada da fatura no Contas Pagar. Valores: 1 - OK, 2 - Aguardando Fatura/Remito, 3 - Com problemas, 4 - Parcialmente Atendido, 5 - Aguardando Concilia‡Æo Batch. (Uso interno: Campo = movind.item-doc-est.sit-item - Include = ininc/i01in176.i)*/
            ttDocumentItem.BalanceQuantity                  = item-doc-est.qt-saldo                                             /*Quatidade saldo. (Uso interno: Campo = movind.item-doc-est.qt-saldo)*/
            ttDocumentItem.BinLocationID                    = item-doc-est.cod-localiz                                          /*C¢digo da localiza‡Æo do material. (Uso interno: Campo = movind.item-doc-est.cod-localiz)*/
            ttDocumentItem.BinLocationDescription           = IF AVAIL localizacao THEN localizacao.descricao ELSE ""           /*Descri‡Æo da localiza‡Æo do material. (Uso interno: Campo = mgind.localizacao.descricao)*/
            ttDocumentItem.CheckedQuantity                  = item-doc-est.quant-conf                                           /*Quantidade conferida. (Uso interno: Campo = movind.item-doc-est.quant-conf)*/
            ttDocumentItem.CMCACCurrentRate                 = item-doc-est.cotacao-cmi                                          /*Cota‡Æo atual moeda CMCAC. (Uso interno: Campo = movind.item-doc-est.cotacao-cmi)*/
            ttDocumentItem.CustomerOrderNumber              = item-doc-est.nr-pedcli                                            /*N£mero do pedido do cliente. (Uso interno: Campo = movind.item-doc-est.nr-pedcli)*/
            ttDocumentItem.CustomerVendorID                 = item-doc-est.cod-emit-terc                                        /*C¢digo interno de identifica‡Æo do emitente. (Uso interno: Campo = movind.item-doc-est.cod-emit-terc)*/
            ttDocumentItem.CustomerVendorShortName          = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""                /*Nome abreviado do fornecedor. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
            ttDocumentItem.CustomerVendorTaxID              = IF AVAIL emitente THEN emitente.cgc        ELSE ""                /*CGC do fornecedor. (Uso interno: Campo = mgadm.emitente.cgc)*/
            ttDocumentItem.DeliverySequence                 = item-doc-est.nr-pd-ent                                            /*Numero da sequencia de entrega do pedido do cliente. (Uso interno: Campo = movind.item-doc-est.nr-pd-ent)*/
            ttDocumentItem.DiscountValue                    = item-doc-est.desconto[1]                                          /*Valor total dos descontos concedidos ao item. (Uso interno: Campo = movind.item-doc-est.desconto[1])*/
            ttDocumentItem.DiscountValue_00                 = item-doc-est.desconto[2]                                          /*Valor total dos descontos concedidos ao item. (Uso interno: Campo = movind.item-doc-est.desconto[2])*/
            ttDocumentItem.DiscountValue_01                 = item-doc-est.desconto-cmi                                         /*Valor total dos descontos concedidos ao item. (Uso interno: Campo = movind.item-doc-est.desconto-cmi)*/
            ttDocumentItem.DiscountValue_02                 = item-doc-est.desconto-me                                          /*Valor total dos descontos concedidos ao item. (Uso interno: Campo = movind.item-doc-est.desconto-me)*/
            ttDocumentItem.DocumentNumber                   = item-doc-est.nro-comp                                             /*N£mero do documento origem. (Uso interno: Campo = movind.item-doc-est.nro-comp)*/
            ttDocumentItem.DocumentNumber_00                = item-doc-est.nro-docto-terc                                       /*N£mero da nota fiscal de entrega das mercadorias. (Uso interno: Campo = movind.item-doc-est.nro-docto-terc)*/
            ttDocumentItem.DocumentSeries                   = item-doc-est.serie-comp                                           /*S‚rie do documento origem. (Uso interno: Campo = movind.item-doc-est.serie-comp)*/
            ttDocumentItem.DocumentSeries_00                = item-doc-est.serie-terc                                           /*S‚rie da nota fiscal de entrega das mercadorias. (Uso interno: Campo = movind.item-doc-est.serie-terc)*/
            ttDocumentItem.ExpenseValue                     = item-doc-est.despesas[1]                                          /*Valor total das despesas do item. (Uso interno: Campo = movind.item-doc-est.despesas[1])*/
            ttDocumentItem.ExpenseValue_00                  = item-doc-est.despesas[2]                                          /*Valor total das despesas do item. (Uso interno: Campo = movind.item-doc-est.despesas[2])*/
            ttDocumentItem.ExpenseValue_01                  = item-doc-est.despesas-cmi                                         /*Valor total das despesas do item. (Uso interno: Campo = movind.item-doc-est.despesas-cmi)*/
            ttDocumentItem.ExpenseValue_02                  = item-doc-est.despesas-me[1]                                       /*Valor total das despesas do item. (Uso interno: Campo = movind.item-doc-est.despesas-me)*/
            ttDocumentItem.FASBCurrentRate                  = item-doc-est.cotacao-fasb                                         /*Cota‡Æo atual moeda FASB. (Uso interno: Campo = movind.item-doc-est.cotacao-fasb)*/
            ttDocumentItem.FiscalClassificationID           = item-doc-est.class-fiscal                                         /*C¢digo da classifica‡Æo fiscal. (Uso interno: Campo = movind.item-doc-est.class-fiscal)*/
            ttDocumentItem.FiscalClassificationDescription  = IF AVAIL classif-fisc THEN classif-fisc.descricao ELSE ""         /*Descri‡Æo da classifica‡Æo fiscal. (Uso interno: Campo = mgind.classif-fisc.descricao)*/    
            ttDocumentItem.FiscalOperationCode              = item-doc-est.nat-comp                                             /*C¢digo natureza de opera‡Æo. (Uso interno: Campo = movind.item-doc-est.nat-comp)*/
            ttDocumentItem.FiscalOperationDescription       = IF AVAIL natur-oper THEN natur-oper.denominacao ELSE ""           /*Descri‡Æo da natureza de opera‡Æo. (Uso interno: Campo = mgind.natur-oper.denominacao)*/
            ttDocumentItem.FiscalOperationCode_00           = item-doc-est.nat-terc                                             /*C¢digo natureza de opera‡Æo. (Uso interno: Campo = movind.item-doc-est.nat-terc)*/
            ttDocumentItem.FiscalOperationDescription_00    = IF AVAIL bf-nat-op-terc THEN bf-nat-op-terc.denominacao ELSE ""   /*Descri‡Æo da natureza de opera‡Æo. (Uso interno: Campo = mgind.natur-oper.denominacao)*/
            ttDocumentItem.ForecastDeliveryDate             = item-doc-est.dt-ent-prev                                          /*Data de entrega prevista. (Uso interno: Campo = movind.item-doc-est.dt-ent-prev)*/
            /*ttDocumentItem.FreightValue                     = item-doc-est.valor-frete                                        /*Valor total das despesas com frete. (Uso interno: Campo = movind.item-doc-est.valor-frete)*/*/
            ttDocumentItem.FreightValue_00                  = item-doc-est.valor-frete-me                                       /*Valor total das despesas com frete. (Uso interno: Campo = movind.item-doc-est.valor-frete-me)*/
            ttDocumentItem.ImportationStatement             = item-doc-est.declaracao-import                                    /*Declara‡Æo de importa‡Æo.(Uso interno: Campo = movind.item-doc-est.declaracao-import)*/
            ttDocumentItem.ImportLicenseNumber              = item-doc-est.i-nr-gi                                              /*Informe o N£mero da guia de importa‡Æo. (Uso interno: Campo = movind.item-doc-est.i-nr-gi)*/
            ttDocumentItem.ImportProcessNumber              = item-doc-est.nr-proc-imp                                          /*N£mero do processo de importa‡Æo. (Uso interno: Campo = movind.item-doc-est.nr-proc-imp)*/
            ttDocumentItem.InspectionRouteNumber            = item-doc-est.nr-ficha                                             /*N£mero do roteiro de inspeção de qualidade. (Uso interno: Campo = movind.item-doc-est.nr-ficha)*/
            ttDocumentItem.InvoiceNumber                    = item-doc-est.c-nr-invoice                                         /*N£mero invoice. (Uso interno: Campo = movind.item-doc-est.c-nr-invoice)*/
            ttDocumentItem.InvoiceSequence                  = item-doc-est.i-seq-inv                                            /*Sequˆncia Invoice. (Uso interno: Campo = movind.item-doc-est.i-seq-inv)*/
            ttDocumentItem.IsComponent                      = item-doc-est.componente                                           /*Indica, no beneficiamento, se o item ‚ componente ou nao. (Uso interno: Campo = movind.item-doc-est.componente)*/
            ttDocumentItem.IsCustomerOrderReopenedByDocu_00 = item-doc-est.reabre-pd                                            /*Indica se o pedido do cliente deve ou nÆo ser reaberto. (Uso interno: Campo = movind.item-doc-est.reabre-pd)*/
            ttDocumentItem.IsFIFOAppliedToPurchaseRequis_00 = item-doc-est.log-fifo-oc                                          /*Indica se as quantidades do item do documento serão alocadas para as parcelas das ordens de compra do fornecedor, da mais antiga para a mais recente at‚ completar a quantidade recebida. (Uso interno: Campo = movind.item-doc-est.log-fifo-oc)*/
            ttDocumentItem.IssueDocumentDate                = item-doc-est.data-comp                                            /*Data de emissão da nota fiscal de venda ou de envio para beneficiamento / consiguina‡Æo, que deu origem ao documento. (Uso interno: Campo = movind.item-doc-est.data-comp)*/
            ttDocumentItem.IsTaxWithholded                  = item-doc-est.log-icm-retido                                       /*ICMS retido na fonte. (Uso interno: Campo = movind.item-doc-est.log-icm-retido)*/
            ttDocumentItem.ItemCode                         = item-doc-est.it-codigo                                            /*C¢digo do item. (Uso interno: Campo = movind.item-doc-est.it-codigo)*/
            ttDocumentItem.ItemDescription                  = IF AVAIL ITEM THEN ITEM.desc-item ELSE ""                         /*Descri‡Æo do item. (Uso interno: Campo = mgind.item.desc-item)*/
            ttDocumentItem.ItemReferenceCode                = item-doc-est.cod-refer                                            /*C¢digo de Referência do item. (Uso interno: Campo = movind.item-doc-est.cod-refer)*/
            ttDocumentItem.LaborValue                       = item-doc-est.pre-unit-mob[1]                                      /*Pre‡o de mÆo-de-obra. (Uso interno: Campo = movind.item-doc-est.pre-unit-mob[1])*/
            ttDocumentItem.LaborValue_00                    = item-doc-est.pre-unit-mob[2]                                      /*Pre‡o de mÆo-de-obra. (Uso interno: Campo = movind.item-doc-est.pre-unit-mob[2])*/
            ttDocumentItem.LaborValue_01                    = item-doc-est.pr-mob-cmi                                           /*Pre‡o de mÆo-de-obra. (Uso interno: Campo = movind.item-doc-est.pr-mob-cmi)*/
            ttDocumentItem.LotOrSerialNumber                = item-doc-est.lote                                                 /*N£mero do lote ou N£mero de S‚rie do item. Elemento obigatório para itens controlados por lote, referencia ou N£mero de S‚rie. (Uso interno: Campo = movind.item-doc-est.lote)*/
            ttDocumentItem.LotValidityDate                  = item-doc-est.dt-vali-lote                                         /*Data de validade do lote informado. (Uso interno: Campo = movind.item-doc-est.dt-vali-lote)*/
            &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                      ttDocumentItem.Manufacturer = item-doc-est.cdn-fabrican
            &ELSE
                      ttDocumentItem.Manufacturer = int(substring(item-doc-est.char-2,600,9))
            &endif
            ttDocumentItem.ManufacturingOrderNumber         = item-doc-est.nr-ord-produ                                         /*N£mero da ordem de produ‡Æo que originou a solicitação de compra do item. (Uso interno: Campo = movind.item-doc-est.nr-ord-produ)*/
            ttDocumentItem.Narrative                        = item-doc-est.narrativa                                            /*Narrativa / Observa‡äes. (Uso interno: Campo = movind.item-doc-est.narrativa)*/
            ttDocumentItem.NetWeight                        = item-doc-est.peso-liquido                                         /*Peso liquido do item. (Uso interno: Campo = movind.item-doc-est.peso-liquido)*/
            ttDocumentItem.NotTaxedValue                    = item-doc-est.ipi-ntrib[1]                                         /*Valor da base de c lculo do IPI nÆo tributado. (Uso interno: Campo = movind.item-doc-est.ipi-ntrib[1])*/
            ttDocumentItem.NotTaxedValue_00                 = item-doc-est.iss-ntrib[1]                                         /*Valor da base de c lculo do ISS nÆo tributado. (Uso interno: Campo = movind.item-doc-est.iss-ntrib[1])*/
            ttDocumentItem.NotTaxedValue_01                 = item-doc-est.icm-ntrib[1]                                         /*Valor da base de c lculo do ICMS nÆo tributado. (Uso interno: Campo = movind.item-doc-est.icm-ntrib[1])*/
            ttDocumentItem.NotTaxedValue_02                 = item-doc-est.ipi-ntrib[2]                                         /*Valor da base de c lculo do IPI nÆo tributado. (Uso interno: Campo = movind.item-doc-est.ipi-ntrib[2])*/
            ttDocumentItem.NotTaxedValue_03                 = item-doc-est.iss-ntrib[2]                                         /*Valor da base de c lculo do ISS nÆo tributado. (Uso interno: Campo = movind.item-doc-est.iss-ntrib[2])*/
            ttDocumentItem.NotTaxedValue_04                 = item-doc-est.icm-ntrib[2]                                         /*Valor da base de c lculo do ICMS nÆo tributado. (Uso interno: Campo = movind.item-doc-est.icm-ntrib[2])*/
            ttDocumentItem.NotTaxedValue_05                 = item-doc-est.ipi-ntr-cm                                           /*Valor da base de c lculo do IPI nÆo tributado. (Uso interno: Campo = movind.item-doc-est.ipi-ntr-cmi*/
            ttDocumentItem.NotTaxedValue_06                 = item-doc-est.iss-ntr-cmi                                          /*Valor da base de c lculo do ISS nÆo tributado. (Uso interno: Campo = movind.item-doc-est.iss-ntr-cmi)*/
            ttDocumentItem.NotTaxedValue_07                 = item-doc-est.icm-ntr-cmi                                          /*Valor da base de c lculo do ICMS nÆo tributado. (Uso interno: Campo = movind.item-doc-est.icm-ntr-cmi)*/
            ttDocumentItem.OrderLine                        = item-doc-est.nr-pd-seq                                            /*Numero sequencial do item no pedido do cliente. (Uso interno: Campo = movind.item-doc-est.nr-pd-seq)*/
            ttDocumentItem.OrderOperationCode               = item-doc-est.op-codigo                                            /*C¢digo da opera‡Æo. (Uso interno: Campo = movind.item-doc-est.op-codigo)*/
            ttDocumentItem.ParentItemCode                   = item-doc-est.item-pai                                             /*C¢digo do item pai. (Uso interno: Campo = movind.item-doc-est.item-pai)*/
            ttDocumentItem.ParentItemDescription            = item.desc-item                                                    /*Descri‡Æo do item pai. (Uso interno: Campo = mgind.item.desc-item)*/
            ttDocumentItem.ProjectControlOrderNumber        = item-doc-est.num-ord-inv                                          /*Numero da ordem de investimento, referente ao módulo de Controle de Investimentos (Uso interno: Campo = movind.item-doc-est.num-ord-inv)*/
            ttDocumentItem.PurchaseOrderNumber              = item-doc-est.num-pedido                                           /*N£mero do pedido de compra que est  sendo recebido. (Uso interno: Campo = movind.item-doc-est.num-pedido)*/
                    /* --- Knupp - Alteracoes para envio da data do pedido na chave do SGT --- */
            ttDocumentItem.PurchaseDate                     = IF AVAIL pedido-compr THEN pedido-compr.data-pedido ELSE ?
            ttDocumentItem.Emergency                        = IF AVAIL pedido-compr AND pedido-compr.emergencial THEN 1 ELSE 0
                    /* --- Knupp - Alteracoes para envio da data do pedido na chave do SGT --- */
            ttDocumentItem.PurchaseRequisitionNumber        = item-doc-est.numero-ordem                                         /*N£mero da ordem de compra do item. (Uso interno: Campo = movind.item-doc-est.numero-ordem)*/
            ttDocumentItem.PurchaseRequisitionScheduleID    = item-doc-est.parcela                                              /*Identificador da parcela da ordem de compra. (Uso interno: Campo = movind.item-doc-est.parcela)*/
            ttDocumentItem.Quantity                         = item-doc-est.quantidade                                           /*Quantidade do item, expressa na unidade de medida interna do item. (Uso interno: Campo = movind.item-doc-est.quantidade)*/
            ttDocumentItem.ReceivedQuantity                 = item-doc-est.qt-real                                              /*Quantidade real recebida. (Uso interno: Campo = movind.item-doc-est.qt-real)*/
            ttDocumentItem.RestitutionLevel                 = item-doc-est.nivel-restituicao                                    /*N¡vel de restitui‡Æo para a Zona Franca de Manaus. (Uso interno: Campo = movind.item-doc-est.nivel-restituicao)*/
            ttDocumentItem.RestitutionPercentage            = item-doc-est.pc-restituicao                                       /*Percentual de restitui‡Æo. (Uso interno: Campo = movind.item-doc-est.pc-restituicao)*/
            ttDocumentItem.RouteID                          = item-doc-est.cod-roteiro                                          /*C¢digo do roteiro de fabrica‡Æo. (Uso interno: Campo = movind.item-doc-est.cod-roteiro)*/
            ttDocumentItem.RouteDescription                 = IF AVAIL rot-fabric THEN rot-fabric.descricao ELSE ""             /*Descri‡Æo do roteiro de fabrica‡Æo. (Uso interno: Campo = mgind.rot-fabric.descricao)*/
            ttDocumentItem.Sequence                         = item-doc-est.sequencia                                            /*N£mero sequencial do item no documento. (Uso interno: Campo = movind.item-doc-est.sequencia)*/
            ttDocumentItem.Sequence_00                      = item-doc-est.seq-comp                                             /*Sequencia do item no documento de origem. (Uso interno: Campo = movind.item-doc-est.seq-comp)*/
            ttDocumentItem.Sequence_01                      = item-doc-est.seq-terc                                             /*Sequˆncia do item na nota fiscal de entrega das mercadorias. (Uso interno: Campo = movind.item-doc-est.seq-terc)*/
            ttDocumentItem.SiteID                           = item-doc-est.est-cob                                              /*C¢digo do estabelecimento. (Uso interno: Campo = movind.item-doc-est.est-cob)*/
            ttDocumentItem.SiteDescription                  = IF AVAIL estabelec THEN estabelec.nome ELSE ""                    /*Descri‡Æo do estabelecimento. (Uso interno: Campo = mgadm.estabelec.nome)*/
            ttDocumentItem.SubAccountNumber                 = item-doc-est.sc-codigo                                            /*N£mero da subconta. (Uso interno: Campo = movind.item-doc-est.sc-codigo)*/
            ttDocumentItem.SubContractVendorID              = item-doc-est.cod-emit-benef                                       /*C¢digo do emitente de beneficiamento. (Uso interno: Campo = movind.item-doc-est.cod-emit-benef)*/
            ttDocumentItem.SubContractShortName             = IF AVAIL bf-emit-benef THEN bf-emit-benef.nome-abrev ELSE ""      /*Nome abreviado do fornecedor. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
            ttDocumentItem.SubContractTaxID                 = IF AVAIL bf-emit-benef THEN bf-emit-benef.cgc ELSE ""             /*CGC do fornecedor. (Uso interno: Campo = mgadm.emitente.cgc)*/
            ttDocumentItem.SupplementaryDocumentDate        = item-doc-est.dt-nota-comp                                         /*Data da nota fiscal complementar. (Uso interno: Campo = movind.item-doc-est.dt-nota-comp)*/
            ttDocumentItem.SupplementaryTax                 = item-doc-est.icm-complem[1]                                       /*ICMS complementar, referente a notas fiscais de compra para consumo final oriundas de outros estados. (Uso interno: Campo = movind.item-doc-est.icm-complem[1])*/
            ttDocumentItem.SupplementaryTax_00              = item-doc-est.icm-complem[2]                                       /*ICMS complementar, referente a notas fiscais de compra para consumo final oriundas de outros estados. (Uso interno: Campo = movind.item-doc-est.icm-complem[2])*/
            ttDocumentItem.SupplementaryTax_01              = item-doc-est.icm-comp-cmi                                         /*ICMS complementar, referente a notas fiscais de compra para consumo final oriundas de outros estados. (Uso interno: Campo = movind.item-doc-est.icm-comp-cmi)*/
            ttDocumentItem.TaxCalculationBasis              = item-doc-est.base-ipi[1]                                          /*Base de c lculo de IPI. (Uso interno: Campo = movind.item-doc-est.base-ipi[1])  */
            ttDocumentItem.TaxCalculationBasis_00           = item-doc-est.base-iss[1]                                          /*Base de c lculo de ISS. (Uso interno: Campo = movind.item-doc-est.base-iss[1])*/
            ttDocumentItem.TaxCalculationBasis_01           = item-doc-est.base-icm[1]                                          /*Base de c lculo de ICMS. (Uso interno: Campo = movind.item-doc-est.base-icm[1])*/
            ttDocumentItem.TaxCalculationBasis_04           = item-doc-est.base-ipi[2]                                          /*Base de c lculo de IPI. (Uso interno: Campo = movind.item-doc-est.base-ipi[2])  */
            ttDocumentItem.TaxCalculationBasis_05           = item-doc-est.base-iss[2]                                          /*Base de c lculo de ISS. (Uso interno: Campo = movind.item-doc-est.base-iss[2])*/
            ttDocumentItem.TaxCalculationBasis_06           = item-doc-est.base-icm[2]                                          /*Base de c lculo de ICMS. (Uso interno: Campo = movind.item-doc-est.base-icm[2])*/
            ttDocumentItem.TaxCalculationBasis_07           = item-doc-est.base-ipi-cmi                                         /*Base de c lculo de IPI. (Uso interno: Campo = movind.item-doc-est.base-ipi-cmi)  */
            ttDocumentItem.TaxCalculationBasis_08           = item-doc-est.base-iss-cmi                                         /*Base de c lculo de ISS. (Uso interno: Campo = movind.item-doc-est.base-iss-cmi)*/
            ttDocumentItem.TaxCalculationBasis_09           = item-doc-est.base-icm-cmi                                         /*Base de c lculo de ICMS. (Uso interno: Campo = movind.item-doc-est.base-icm-cmi)*/
            ttDocumentItem.TaxCode                          = item-doc-est.cd-trib-ipi                                          /*Tipo de tratamento de IPI em rela‡Æo ao item. Valores: 1 - Tributado, 2 - Isento, 3 - Outros, 4 - Reduzido. (Uso interno: Campo = movind.item-doc-est.cd-trib-ipi - Include = ininc/i10in172.i)*/
            ttDocumentItem.TaxCode_00                       = item-doc-est.cd-trib-iss                                          /*Tipo de tratamento de ISS em rela‡Æo ao item. Valores: 1 - Tributado, 2 - Isento, 3 - Outros, 4 - Reduzido. (Uso interno: Campo = movind.item-doc-est.cd-trib-iss - Include = ininc/i11in172.i)*/
            ttDocumentItem.TaxCode_01                       = item-doc-est.cd-trib-icm                                          /*Tipo de tratamento do ICMS em rela‡Æo ao item. Valores: 1 - Tributado, 2 - Isento, 3 - Outros, 4 - Reduzido, 5 - Diferido. (Uso interno: Campo = movind.item-doc-est.cd-trib-icm - Include = ininc/i07in122.i)*/
            ttDocumentItem.TaxOtherValue                    = item-doc-est.ipi-outras[1]                                        /*Valor da base de c lculo do IPI Outras. (Uso interno: Campo = movind.item-doc-est.ipi-outras[1])*/
            ttDocumentItem.TaxOtherValue_00                 = item-doc-est.iss-outras[1]                                        /*Valor da base de c lculo do ISS Outras. (Uso interno: Campo = movind.item-doc-est.iss-outras[1])*/
            ttDocumentItem.TaxOtherValue_01                 = item-doc-est.icm-outras[1]                                        /*Valor da base de c lculo do ICMS Outras. (Uso interno: Campo = movind.item-doc-est.icm-outras[1])*/
            ttDocumentItem.TaxOtherValue_02                 = item-doc-est.ipi-outras[2]                                        /*Valor da base de c lculo do IPI Outras. (Uso interno: Campo = movind.item-doc-est.ipi-outras[2])*/
            ttDocumentItem.TaxOtherValue_03                 = item-doc-est.iss-outras[2]                                        /*Valor da base de c lculo do ISS Outras. (Uso interno: Campo = movind.item-doc-est.iss-outras[2])*/
            ttDocumentItem.TaxOtherValue_04                 = item-doc-est.icm-outras[2]                                        /*Valor da base de c lculo do ICMS Outras. (Uso interno: Campo = movind.item-doc-est.icm-outras[2])*/
            ttDocumentItem.TaxOtherValue_05                 = item-doc-est.ipi-out-cmi                                          /*Valor da base de c lculo do IPI Outras. (Uso interno: Campo = movind.item-doc-est.ipi-out-cmi)*/
            ttDocumentItem.TaxOtherValue_06                 = item-doc-est.iss-out-cmi                                          /*Valor da base de c lculo do ISS Outras. (Uso interno: Campo = movind.item-doc-est.iss-out-cmi)*/
            ttDocumentItem.TaxOtherValue_07                 = item-doc-est.icm-out-cmi                                          /*Valor da base de c lculo do ICMS Outras. (Uso interno: Campo = movind.item-doc-est.icm-out-cmi)*/
            ttDocumentItem.TaxPercentage                    = item-doc-est.aliquota-ipi                                         /*Aliquota IPI. (Uso interno: Campo = movind.item-doc-est.aliquota-ipi)*/
            ttDocumentItem.TaxPercentage_00                 = item-doc-est.aliquota-iss                                         /*Aliquota ISS. (Uso interno: Campo = movind.item-doc-est.aliquota-iss)*/
            ttDocumentItem.TaxPercentage_01                 = item-doc-est.aliquota-icm                                         /*Aliquota ICMS. (Uso interno: Campo = movind.item-doc-est.aliquota-icm[1])*/
            ttDocumentItem.TaxValue                         = item-doc-est.valor-ipi[1]                                         /*Valor total de IPI. (Uso interno: Campo = movind.item-doc-est.valor-ipi[1])*/
            ttDocumentItem.TaxValue_00                      = item-doc-est.valor-iss[1]                                         /*Valor total de ISS. (Uso interno: Campo = movind.item-doc-est.valor-iss[1])*/
            ttDocumentItem.TaxValue_01                      = item-doc-est.valor-icm[1]                                         /*Valor total de ICMS. (Uso interno: Campo = movind.item-doc-est.valor-icm[1])*/
            ttDocumentItem.TaxValue_04                      = item-doc-est.vl-imp-impor[1]                                      /*Valor dos impostos de importa‡Æo (Uso interno: Campo = movind.item-doc-est.vl-imp-impor[1])*/
            ttDocumentItem.TaxValue_05                      = item-doc-est.valor-ipi[2]                                         /*Valor total de IPI. (Uso interno: Campo = movind.item-doc-est.valor-ipi[2])*/
            ttDocumentItem.TaxValue_06                      = item-doc-est.valor-iss[2]                                         /*Valor total de ISS. (Uso interno: Campo = movind.item-doc-est.valor-iss[2])*/
            ttDocumentItem.TaxValue_07                      = item-doc-est.valor-icm[2]                                         /*Valor total de ICMS. (Uso interno: Campo = movind.item-doc-est.valor-icm[2])*/
            ttDocumentItem.TaxValue_10                      = item-doc-est.vl-imp-impor[2]                                      /*Valor dos impostos de importa‡Æo (Uso interno: Campo = movind.item-doc-est.vl-imp-impor[2])*/
            ttDocumentItem.TaxValue_11                      = item-doc-est.vl-ipi-cm                                            /*Valor total de IPI. (Uso interno: Campo = movind.item-doc-est.vl-ipi-cmi*/
            ttDocumentItem.TaxValue_12                      = item-doc-est.vl-iss-cmi                                           /*Valor total de ISS. (Uso interno: Campo = movind.item-doc-est.vl-iss-cmi)*/
            ttDocumentItem.TaxValue_13                      = item-doc-est.vl-icm-cmi                                           /*Valor total de ICMS. (Uso interno: Campo = movind.item-doc-est.vl-icm-cmi)*/
            ttDocumentItem.TaxValue_16                      = item-doc-est.vl-imp-cmi                                           /*Valor dos impostos de importa‡Æo (Uso interno: Campo = movind.item-doc-est.vl-imp-cmi)*/
            ttDocumentItem.TotalPrice                       = item-doc-est.preco-total[1]                                       /*Pre‡o total. (Uso interno: Campo = movind.item-doc-est.preco-total[1])*/
            ttDocumentItem.TotalPrice_00                    = item-doc-est.preco-total[2]                                       /*Pre‡o total. (Uso interno: Campo = movind.item-doc-est.preco-total[2])*/
            ttDocumentItem.TotalPrice_01                    = item-doc-est.pr-total-cmi                                         /*Pre‡o total. (Uso interno: Campo = movind.item-doc-est.pr-total-cmi)*/
            ttDocumentItem.TotalPrice_02                    = item-doc-est.preco-total-me                                       /*Pre‡o total. (Uso interno: Campo = movind.item-doc-est.preco-total-me)*/
            ttDocumentItem.TransactionDate                  = item-doc-est.data                                                 /*Data movimento. (Uso interno: Campo = movind.item-doc-est.data)*/
            ttDocumentItem.TributarySubstitutionBasis       = item-doc-est.base-subs[1]                                         /*Base de c lculo para o ICMS por regime de Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.item-doc-est.base-subs[1])*/
            ttDocumentItem.TributarySubstitutionBasis_00    = item-doc-est.base-pis-subs                                        /*Base de c lculo para o PIS por regime de Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.item-doc-est.base-pis-subs)*/
            ttDocumentItem.TributarySubstitutionBasis_01    = item-doc-est.base-cofins-subs                                     /*Base de c lculo para o COFINS por regime de Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.item-doc-est.base-cofins-subs)*/
            ttDocumentItem.TributarySubstitutionBasis_02    = item-doc-est.base-subs[2]                                         /*Base de c lculo para o ICMS por regime de Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.item-doc-est.base-subs[2])*/
            ttDocumentItem.TributarySubstitutionBasis_03    = item-doc-est.base-subs-cmi                                        /*Base de c lculo para o ICMS por regime de Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.item-doc-est.base-subs-cmi)*/
            ttDocumentItem.TributarySubstitutionValue       = item-doc-est.vl-subs[1]                                           /*Valor do ICMS recolhido por Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.item-doc-est.vl-subs[1])*/
            ttDocumentItem.TributarySubstitutionValue_00    = item-doc-est.vl-pis-subs                                          /*Valor do PIS recolhido por Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.item-doc-est.vl-pis-subs)*/
            ttDocumentItem.TributarySubstitutionValue_01    = item-doc-est.vl-cofins-subs                                       /*Valor do COFINS recolhido por Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.item-doc-est.vl-cofins-subs)*/
            ttDocumentItem.TributarySubstitutionValue_02    = item-doc-est.vl-subs[2]                                           /*Valor do ICMS recolhido por Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.item-doc-est.vl-subs[2])*/
            ttDocumentItem.TributarySubstitutionValue_03    = item-doc-est.vl-subs-cmi                                          /*Valor do ICMS recolhido por Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.item-doc-est.vl-subs-cmi)*/
            ttDocumentItem.UnitOfMeasureCode                = item-doc-est.un                                                   /*C¢digo da Unidade de Medida. (Uso interno: Campo = movind.item-doc-est.un)*/
            ttDocumentItem.UnitOfMeasureDescription         = IF AVAIL tab-unidade THEN tab-unidade.descricao ELSE ""           /*Descri‡Æo da Unidade de Medida. (Uso interno: Campo = mgind.tab-unidade.desc)*/
            ttDocumentItem.UnitPrice                        = item-doc-est.preco-unit[1]                                        /*Pre‡o unitário. (Uso interno: Campo = movind.item-doc-est.preco-unit[1])*/
            ttDocumentItem.UnitPrice_00                     = item-doc-est.preco-unit[2]                                        /*Pre‡o unitário. (Uso interno: Campo = movind.item-doc-est.preco-unit[2])*/
            ttDocumentItem.UnitPrice_01                     = item-doc-est.pr-unit-cmi                                          /*Pre‡o unitário. (Uso interno: Campo = movind.item-doc-est.pr-unit-cmi)*/
            ttDocumentItem.UnitPrice_02                     = item-doc-est.preco-unit-me                                        /*Pre‡o unitário. (Uso interno: Campo = movind.item-doc-est.preco-unit-me)*/
            ttDocumentItem.VendorID                         = docum-est.cod-emitente                                            /*C¢digo interno de identifica‡Æo do fornecedor. (Uso interno: Campo = movind.docum-est.emite-comp)*/
            ttDocumentItem.VendorQuantity                   = item-doc-est.qt-do-forn                                           /*Quantidade do item, expressa na unidade de medida adotada pelo emitente. (Uso interno: Campo = movind.item-doc-est.qt-do-forn)*/
            ttDocumentItem.WarehouseID                      = item-doc-est.cod-depos                                            /*C¢digo dep¢sito. (Uso interno: Campo = movind.item-doc-est.cod-depos)*/
            ttDocumentItem.WarehouseDescription             = IF AVAIL deposito THEN deposito.nome ELSE ""                      /*Descri‡Æo do dep¢sito. (Uso interno: Campo = mgind.deposito.nome)*/
            ttDocumentItem.RequisitionNumber                = IF AVAIL requisicao    THEN requisicao.nr-requisicao ELSE 0       /*N£mero da requisi‡Æo*/
            ttDocumentItem.RequisitionLineSequence          = IF AVAIL it-requisicao THEN it-requisicao.sequencia  ELSE 0.      /*Sequˆncia do item da Requisi‡Æo*/
            
               /* colocamos esse if pois no re1001 nao existe esse campo valor-frete. e gravado sempre o pr-total-cmi para o frete. por seguranca vamos manter 
               essa logica, isto eh, se o valor estiver  informado no valor-frete sera enviado para o xml. se nao estiver, verifica se tem algum valor
               no pr-total-cmi. esperamos assim nao impactar o produto (nao sabemos todos os lugares que o campo valor-frete eh usado) e corrigir o erro 
               para quem usa o re1001.*/
            IF item-doc-est.valor-frete <> 0 THEN
               ASSIGN ttDocumentItem.FreightValue           = item-doc-est.valor-frete. /*Valor total das despesas com frete. (Uso interno: Campo = movind.item-doc-est.valor-frete)*/
            ELSE 
               ASSIGN ttDocumentItem.FreightValue           = item-doc-est.pr-total-cmi.  

     ASSIGN de-pc-pis    = 0
            de-pc-cofins = 0.

     RUN recupera-aliquotas IN h-cdapi995 (INPUT "item-doc-est",
                                          INPUT item-doc-est.serie-docto + "/" + 
                                                item-doc-est.nro-docto + "/" + 
                                                string(item-doc-est.cod-emitente) + "/" + 
                                                item-doc-est.nat-operacao + "/" + 
                                                string(item-doc-est.sequencia), 
                                                output de-pc-pis, 
                                                output de-pc-cofins).
     &if '{&bf_dis_versao_ems}' >= '2.06' &then
     
        IF de-pc-pis    = 0 THEN ASSIGN de-pc-pis   = item-doc-est.val-aliq-pis.
        IF de-pc-cofins = 0 THEN ASSIGN de-pc-cofins = item-doc-est.val-aliq-cofins.

        ASSIGN  ttDocumentItem.TaxCalculationBasis_02           = item-doc-est.base-pis
                ttDocumentItem.TaxCalculationBasis_03           = item-doc-est.val-base-calc-cofins
                ttDocumentItem.TaxCode_02                       = item-doc-est.idi-tributac-pis 
                ttDocumentItem.TaxCode_03                       = item-doc-est.idi-tributac-cofins
                ttDocumentItem.TaxPercentage_02                 = de-pc-pis
                ttDocumentItem.TaxPercentage_03                 = de-pc-cofins
                ttDocumentItem.TaxValue_02                      = item-doc-est.valor-pis 
                ttDocumentItem.TaxValue_03                      = item-doc-est.val-cofins
                ttDocumentItem.TaxValue_08                      = item-doc-est.valor-pis-fasb
                ttDocumentItem.TaxValue_09                      = item-doc-est.val-cofins-fasb      
                ttDocumentItem.TaxValue_14                      = item-doc-est.valor-pis-cmi
                ttDocumentItem.TaxValue_15                      = item-doc-est.val-cofins-cmi.
     &else
        IF de-pc-pis    = 0 THEN ASSIGN de-pc-pis    = DEC(SUBSTRING(item-doc-est.char-2,22,5)).
        IF de-pc-cofins = 0 THEN ASSIGN de-pc-cofins = DEC(SUBSTRING(item-doc-est.char-2,84,5)).

        ASSIGN  ttDocumentItem.TaxCalculationBasis_02           = IF SUBSTRING(item-doc-est.char-2,27,14)  <> ? AND SUBSTRING(item-doc-est.char-2,27,14)  <> '' THEN INT(SUBSTRING(item-doc-est.char-2,27,14))  ELSE 0     /*Base de c lculo PIS. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posi‡Æo inicial = 27, posi‡Æo final = 40, N£mero de posi‡äes = 14)*/
                ttDocumentItem.TaxCalculationBasis_03           = IF SUBSTRING(item-doc-est.char-2,89,14)  <> ? AND SUBSTRING(item-doc-est.char-2,89,14)  <> '' THEN INT(SUBSTRING(item-doc-est.char-2,89,14))  ELSE 0     /*Base de c lculo COFINS. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posi‡Æo inicial = 89, posi‡Æo final = 102, N£mero de posi‡äes = 14)*/
                ttDocumentItem.TaxCode_02                       = IF SUBSTRING(item-doc-est.char-2,21,1)   <> ? AND SUBSTRING(item-doc-est.char-2,21,1)   <> '' THEN INT(SUBSTRING(item-doc-est.char-2,21,1))   ELSE 0     /*Tributa‡Æo PIS. Valores: 1 - Tributado, 2 - Isento. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posi‡Æo inicial = 21, posi‡Æo final = 21, N£mero de posi‡äes = 1)*/ 
                ttDocumentItem.TaxCode_03                       = IF SUBSTRING(item-doc-est.char-2,83,1)   <> ? AND SUBSTRING(item-doc-est.char-2,83,1)   <> '' THEN INT(SUBSTRING(item-doc-est.char-2,83,1))   ELSE 0     /*Tributa‡Æo COFINS. Valores: 1 - Tributado, 2 - Isento. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posi‡Æo inicial = 83, posi‡Æo final = 83, N£mero de posi‡äes = 1)*/
                ttDocumentItem.TaxPercentage_02                 = de-pc-pis
                ttDocumentItem.TaxPercentage_03                 = de-pc-cofins
                ttDocumentItem.TaxValue_02                      = IF SUBSTRING(item-doc-est.char-2,41,14)  <> ? AND SUBSTRING(item-doc-est.char-2,41,14)  <> '' THEN INT(SUBSTRING(item-doc-est.char-2,41,14))  ELSE 0     /*Valor PIS a recuperar. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posi‡Æo inicial = 41, posi‡Æo final = 54, N£mero de posi‡äes = 14)*/      
                ttDocumentItem.TaxValue_03                      = IF SUBSTRING(item-doc-est.char-2,103,14) <> ? AND SUBSTRING(item-doc-est.char-2,103,14) <> '' THEN INT(SUBSTRING(item-doc-est.char-2,103,14)) ELSE 0     /*Valor COFINS a recuperar. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posi‡Æo inicial = 103, posi‡Æo final = 116, N£mero de posi‡äes = 14)*/ 
                ttDocumentItem.TaxValue_08                      = IF SUBSTRING(item-doc-est.char-2,55,14)  <> ? AND SUBSTRING(item-doc-est.char-2,55,14)  <> '' THEN INT(SUBSTRING(item-doc-est.char-2,55,14))  ELSE 0     /*Valor PIS a recuperar. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posi‡Æo inicial = 55, posi‡Æo final = 68, N£mero de posi‡äes = 14)*/      
                ttDocumentItem.TaxValue_09                      = IF SUBSTRING(item-doc-est.char-2,117,14) <> ? AND SUBSTRING(item-doc-est.char-2,117,14) <> '' THEN INT(SUBSTRING(item-doc-est.char-2,117,14)) ELSE 0     /*Valor COFINS a recuperar. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posi‡Æo inicial = 117, posi‡Æo final = 130, N£mero de posi‡äes = 14)*/ 
                ttDocumentItem.TaxValue_14                      = IF SUBSTRING(item-doc-est.char-2,69,14)  <> ? AND SUBSTRING(item-doc-est.char-2,69,14)  <> '' THEN INT(SUBSTRING(item-doc-est.char-2,69,14))  ELSE 0     /*Valor PIS a recuperar. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posi‡Æo inicial = 69, posi‡Æo final = 82, N£mero de posi‡äes = 14)*/
                ttDocumentItem.TaxValue_15                      = IF SUBSTRING(item-doc-est.char-2,131,14) <> ? AND SUBSTRING(item-doc-est.char-2,131,14) <> '' THEN INT(SUBSTRING(item-doc-est.char-2,131,14)) ELSE 0.    /*Valor COFINS a recuperar. (Uso interno: Atributo Livre = movind.item-doc-est.char-2, posi‡Æo inicial = 131, posi‡Æo final = 144, N£mero de posi‡äes = 14)*/ 
     &ENDif.
            
    &if '{&bf_mat_versao_ems}' > '2.04' &then
        ASSIGN ttDocumentItem.VendorsRestokingPercentage    = item-doc-est.val-perc-restocagem                                  /*Percentual de restocagem praticado pelo fornecedor. (Uso interno: Campo = movind.item-doc-est.val-perc-restocagem)*/
               ttDocumentItem.VendorsRestokingValue         = item-doc-est.val-restocagem                                       /*Valor de restocagem praticado pelo fornecedor. (Uso interno: Campo = movind.item-doc-est.val-restocagem)*/
               ttDocumentItem.RMASequenceNumber             = STRING(item-doc-est.num-seq-rma).                                 /*N£mero Sequˆncia RMA. (Uso interno: Campo = movind.item-doc-est.num-seq-rma)*/

        &if '{&bf_mat_versao_ems}' = '2.05' &then
            ASSIGN ttDocumentItem.TaxReductionPercentage    = item-doc-est.val-perc-rep-ipi                                     /*Percentual de redu‡Æo de IPI. (Uso interno: Atributo Livre EMS 2.04 = movind.item-doc-est.char-2, posi‡Æo inicial = 1, posi‡Æo final = 6, N£mero de posi‡äes = 6 - Campo EMS 2.05 = movind.item-doc-est.val-perc-rep-ipi)*/
                   ttDocumentItem.TaxReductionPercentage_00 = item-doc-est.val-perc-red-icms.                                   /*Percentual de redu‡Æo de ICMS. (Uso interno: Atributo Livre EMS 2.04 = movind.item-doc-est.char-2, posi‡Æo inicial = 7, posi‡Æo final = 12, N£mero de posi‡äes = 6 - Campo EMS 2.05 = movind.item-doc-est.val-perc-red-icms)*/
        &endif
        
        &if '{&bf_mat_versao_ems}' = '2.042' &then
            ASSIGN ttDocumentItem.IsCreditDocumentCreatedInAP   = item-doc-est.log-geracao-nrc-ap.                              /*Indica a gera‡Æo de nota de cr‚dito no contas a pagar. (Uso interno: Campo = movind.item-doc-est.log-geracao-ncr-ap)*/
        &else
            ASSIGN ttDocumentItem.IsCreditDocumentCreatedInAP   = item-doc-est.log-geracao-ncr-ap.                              /*Indica a gera‡Æo de nota de cr‚dito no contas a pagar. (Uso interno: Campo = movind.item-doc-est.log-geracao-ncr-ap)*/
        &endif
    &else
        ASSIGN ttDocumentItem.VendorsRestokingPercentage    = 0
               ttDocumentItem.VendorsRestokingValue         = 0
               ttDocumentItem.TaxReductionPercentage        = IF item-doc-est.val-perc-rep-ipi <> 0 THEN item-doc-est.val-perc-rep-ipi ELSE IF SUBSTRING(item-doc-est.char-2,1,6) <> ? AND SUBSTRING(item-doc-est.char-2,1,6) <> '' THEN INT(SUBSTRING(item-doc-est.char-2,1,6)) ELSE 0   /*Percentual de redu‡Æo de IPI. (Uso interno: Atributo Livre EMS 2.04 = movind.item-doc-est.char-2, posi‡Æo inicial = 1, posi‡Æo final = 6, N£mero de posi‡äes = 6 - Campo EMS 2.05 = movind.item-doc-est.val-perc-rep-ipi)*/ 
               ttDocumentItem.TaxReductionPercentage_00     = IF item-doc-est.val-perc-red-icms <> 0 THEN item-doc-est.val-perc-red-icms ELSE IF SUBSTRING(item-doc-est.char-2,7,6) <> ? AND SUBSTRING(item-doc-est.char-2,7,6) <> '' THEN INT(SUBSTRING(item-doc-est.char-2,7,6)) ELSE 0.  /*Percentual de redu‡Æo de ICMS. (Uso interno: Atributo Livre EMS 2.04 = movind.item-doc-est.char-2, posi‡Æo inicial = 7, posi‡Æo final = 12, N£mero de posi‡äes = 6 - Campo EMS 2.05 = movind.item-doc-est.val-perc-red-icms)*/
    &endif
    
     /*Altera‡Æo projeto 1006*/
    &IF '{&BF_DIS_VERSAO_EMS}' >= '2.08' &THEN
    
        if  not valid-handle(h-boad123a) then
            run adbo/boad123a.p persistent set h-boad123a.

        run openQueryStatic in h-boad123a ('main').
        run goToKey         in h-boad123a ('SPP_TOTVSGFE').
        if  return-value = "NOK" then
            assign l-func-totvsgfe = no.
        else
            run getLogField in h-boad123a (input  'ativo',
                                           output l-func-totvsgfe).
        IF l-func-totvsgfe THEN DO:      
            FIND FIRST tab-generica
                WHERE tab-generica.utilizacao = "SETUP" NO-LOCK NO-ERROR.
            IF AVAIL tab-generica AND SUBSTRING(tab-generica.char-2,120,1) = "1" THEN DO:
                run adapters/xml/trp/axstr006.p (input 2,
                                                 input docum-est.serie-docto,
                                                 input docum-est.nro-docto,
                                                 input docum-est.cod-emitente,
                                                 input docum-est.nat-operacao,
                                                 input item-doc-est.sequencia,
                                                 input-output table ttReceiptDocument,
                                                 input-output table ttDocumentItem,
                                                 input-output table ttAgent,
                                                 INPUT-OUTPUT TABLE ttFreightSimulation).
    
                find first ttDocumentItem where ttDocumentItem.Sequence = item-doc-est.sequencia exclusive-lock no-error.
                find first ttReceiptDocument exclusive-lock no-error.
            END.
        END.
         IF VALID-HANDLE (h-boad123a) THEN
            RUN destroy IN h-boad123a.
    
    &ENDIF
    
    create ttInventoryUpdate.
    assign ttInventoryUpdate.nro-docto    = ttDocumentItem.DocumentNumber
           ttInventoryUpdate.serie        = ttDocumentItem.DocumentSeries
           ttInventoryUpdate.nat-operacao = ttDocumentItem.FiscalOperationCode
           ttInventoryUpdate.cod-emitente = ttDocumentItem.CustomerVendorID
           ttInventoryUpdate.sequencia    = ttDocumentItem.Sequence.

    IF item-doc-est.baixa-ce = YES 
    AND (   ITEM.tipo-contr = 1 /* físico */ 
         OR ITEM.tipo-contr = 2 /* total */) THEN
	    assign ttInventoryUpdate.InventoryUpdate = 1.
    ELSE
        assign  ttInventoryUpdate.InventoryUpdate = 0.
    /* Emitente */
    FIND FIRST emitente 
         WHERE emitente.cod-emitente = ttDocumentItem.VendorID 
         NO-LOCK NO-ERROR.
    IF  AVAIL emitente THEN DO:
        ASSIGN ttDocumentItem.VendorShortName       = emitente.nome-abrev                                               /*Nome abreviado do fornecedor. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
               ttDocumentItem.VendorTaxID           = emitente.cgc.                                                     /*CGC do fornecedor. (Uso interno: Campo = mgadm.emitente.cgc)*/
    END.

    


    /*ASSIGN ttDocumentItem.ContactSequence                  = cont-emit.sequencia. /*Sequencia contato. (Uso interno: Campo = mgadm.cont-emit.sequencia)*/ */
    /*ASSIGN ttDocumentItem.ContactSequence_00               = cont-emit.sequencia. /*Sequencia contato. (Uso interno: Campo = mgadm.cont-emit.sequencia)*/ */
    /*ASSIGN ttDocumentItem.ContactSequence_01               = cont-emit.sequencia. /*Sequencia contato. (Uso interno: Campo = mgadm.cont-emit.sequencia)*/ */
    /*ASSIGN ttDocumentItem.ContactName                      = cont-emit.nome. /*Nome do contato. (Uso interno: Campo = mgadm.cont-emit.nome)*/                             */
    /*ASSIGN ttDocumentItem.ContactName_00                   = cont-emit.nome. /*Nome do contato. (Uso interno: Campo = mgadm.cont-emit.nome)*/                             */
    /*ASSIGN ttDocumentItem.ContactName_01                   = cont-emit.nome. /*Nome do contato. (Uso interno: Campo = mgadm.cont-emit.nome)*/                             */
    /*ASSIGN ttDocumentItem.EmailAddress                     = cont-emit.e-mail. /*E-mail do contato. (Uso interno: Campo = mgadm.cont-emit.e-mail)*/ */
    /*ASSIGN ttDocumentItem.EmailAddress_00                  = cont-emit.e-mail. /*E-mail do contato. (Uso interno: Campo = mgadm.cont-emit.e-mail)*/ */
    /*ASSIGN ttDocumentItem.EmailAddress_01                  = cont-emit.e-mail. /*E-mail do contato. (Uso interno: Campo = mgadm.cont-emit.e-mail)*/ */
    /*ASSIGN ttDocumentItem.PhoneNumber                      = cont-emit.telefone. /*Telefone do contato. (Uso interno: Campo = mgadm.cont-emit.telefone)*/ */
    /*ASSIGN ttDocumentItem.PhoneNumber_00                   = cont-emit.telefone. /*Telefone do contato. (Uso interno: Campo = mgadm.cont-emit.telefone)*/ */
    /*ASSIGN ttDocumentItem.PhoneNumber_01                   = cont-emit.telefone. /*Telefone do contato. (Uso interno: Campo = mgadm.cont-emit.telefone)*/ */

    /* Rateio Ordem de Compra */

    ASSIGN i-cont2 = 0.

    FOR EACH  rat-ordem NO-LOCK
        WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
        AND   rat-ordem.nro-docto    = item-doc-est.nro-docto
        AND   rat-ordem.nat-operacao = item-doc-est.nat-operacao
        AND   rat-ordem.serie-docto  = item-doc-est.serie-docto
        AND   rat-ordem.sequencia    = item-doc-est.sequencia:

        ASSIGN i-cont2 = i-cont2 + 1.

         FIND FIRST ordem-compra
             WHERE ordem-compra.numero-ordem = rat-ordem.numero-ordem 
            NO-LOCK NO-ERROR.
         IF AVAIL ordem-compra THEN DO:

            /*Requisi‡Æo */
            FIND FIRST requisicao
                 WHERE requisicao.nr-requisicao =  ordem-compra.nr-requisicao
                 NO-LOCK NO-ERROR.
        
            /*itens da requisi‡Æo*/
              FIND FIRST it-requisicao
                   WHERE it-requisicao.nr-requisicao = ordem-compra.nr-requisicao
                   AND   it-requisicao.sequencia     = ordem-compra.sequencia
                   NO-LOCK NO-ERROR.
         END.

        CREATE  ttPurchaseOrder.
        ASSIGN  ttPurchaseOrder.ttPurchaseOrderID        = i-cont2
                ttPurchaseOrder.ttDocumentItemID         = ttDocumentItem.ttDocumentItemID
                ttPurchaseOrder.IsOrderClosed            = rat-ordem.encerrada      /*Indica se a ordem de compra est  encerrada. (Uso interno: Campo = movind.rat-ordem.encerrada)*/
                ttPurchaseOrder.OrderNumber              = rat-ordem.num-pedido     /*N£mero do pedido de compra que est  sendo recebido. (Uso interno: Campo = movind.rat-ordem.num-pedido)*/
                ttPurchaseOrder.PurchaseOrderNumber      = rat-ordem.numero-ordem   /*N£mero da ordem de compra do item. (Uso interno: Campo = movind.rat-ordem.numero-ordem)*/
                ttPurchaseOrder.PurchaseOrderScheduleID  = rat-ordem.parcela        /*Identificador da parcela da ordem de compra. (Uso interno: Campo = movind.rat-ordem.parcela)*/
                ttPurchaseOrder.Quantity                 = rat-ordem.quantidade     /*Quantidade do item, expressa na unidade de medida interna do item. (Uso interno: Campo = movind.rat-ordem.quantidade)*/
                ttPurchaseOrder.VendorQuantity           = rat-ordem.qtidade-forn   /*Quantidade do item, expressa na unidade de medida adotada pelo emitente. (Uso interno: Campo = movind.rat-ordem.qtidade-forn)*/
                ttPurchaseOrder.RequisitionNumber        = IF AVAIL requisicao    THEN requisicao.nr-requisicao ELSE 0       /*N£mero da requisi‡Æo*/              
                ttPurchaseOrder.RequisitionLineSequence  = IF AVAIL it-requisicao THEN it-requisicao.sequencia  ELSE 0.      /*Sequˆncia do item da Requisi‡Æo*/   
              /*ttPurchaseOrder.Sequence                 = INITIAL ? .              /*Sequencial num‚rico da ordem de compra*/*/

    END.

    /* Rateio Lote */

    ASSIGN i-cont2 = 0.

    FOR EACH rat-lote NO-LOCK
       WHERE rat-lote.cod-emitente = item-doc-est.cod-emitente
         AND rat-lote.nro-docto    = item-doc-est.nro-docto
         AND rat-lote.nat-operacao = item-doc-est.nat-operacao
         AND rat-lote.serie-docto  = item-doc-est.serie-docto
         AND rat-lote.sequencia    = item-doc-est.sequencia:

        /* Localiza‡Æo */
        FIND FIRST localizacao
             WHERE localizacao.cod-localiz = rat-lote.cod-localiz 
             NO-LOCK NO-ERROR.

        /* Dep¢sito */
        FIND FIRST deposito 
             WHERE deposito.cod-depos = item-doc-est.cod-depos 
             NO-LOCK NO-ERROR.

        ASSIGN i-cont2 = i-cont2 + 1.

        CREATE  ttReceiptLocation.
        ASSIGN  ttReceiptLocation.ttReceiptLocationID       = i-cont2
                ttReceiptLocation.ttDocumentItemID          = ttDocumentItem.ttDocumentItemID
                ttReceiptLocation.BinLocationID             = rat-lote.cod-localiz                                    /*C¢digo da localiza‡Æo do material. (Uso interno: Campo = movind.rat-lote.cod-localiz)*/
                ttReceiptLocation.BinLocationDescription    = IF AVAIL localizacao THEN localizacao.descricao ELSE "" /*Descri‡Æo da localiza‡Æo do material. (Uso interno: Campo = mgind.localizacao.descricao)*/
                ttReceiptLocation.InspectionRouteNumber     = rat-lote.nr-ficha                                       /*N£mero do roteiro de inspeção de qualidade. (Uso interno: Campo = movind.rat-lote.nr-ficha)*/
                ttReceiptLocation.LotOrSerialNumber         = rat-lote.lote                                           /*N£mero do lote ou N£mero de S‚rie do item. Elemento obigatório para itens controlados por lote, referencia ou N£mero de S‚rie. (Uso interno: Campo = movind.rat-lote.lote)*/
                ttReceiptLocation.LotValidityDate           = rat-lote.dt-vali-lote                                   /*Data de validade do lote informado. (Uso interno: Campo = movind.rat-lote.dt-vali-lote)*/
                &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                      ttReceiptLocation.Manufacturer = rat-lote.cdn-fabrican
                &ELSE
                      ttReceiptLocation.Manufacturer = int(substring(rat-lote.char-2,71,9))
                &endif
                ttReceiptLocation.Quantity                  = rat-lote.quantidade                                     /*Quantidade do item, expressa na unidade de medida interna do item. (Uso interno: Campo = movind.rat-lote.quantidade)*/
                ttReceiptLocation.WarehouseID               = rat-lote.cod-depos                                      /*C¢digo dep¢sito. (Uso interno: Campo = movind.rat-lote.cod-depos)*/
                ttReceiptLocation.WarehouseDescription      = IF AVAIL deposito THEN deposito.nome ELSE "".           /*Descri‡Æo do dep¢sito. (Uso interno: Campo = mgind.deposito.nome)*/
              /*ttReceiptLocation.Sequence                  = INITIAL ? .                                             /*Sequencial num‚rico do local de recebimento*/*/

    END. /* fim leitura RAT-LOTE */

    /* Unidade de Neg¢cio */
    ASSIGN i-cont2 = 0.

    FOR EACH unid-neg-nota
        WHERE unid-neg-nota.cod-emitente = item-doc-est.cod-emitente
          AND unid-neg-nota.serie-docto  = item-doc-est.serie-docto
          AND unid-neg-nota.nro-docto    = item-doc-est.nro-docto
          AND unid-neg-nota.nat-operacao = item-doc-est.nat-operacao
          AND unid-neg-nota.sequencia    = item-doc-est.sequencia:

          ASSIGN i-cont2 = i-cont2 + 1.
          
          CREATE  ttBusinessUnitItem.
          ASSIGN  ttBusinessUnitItem.ttBusinessUnitID     = string(item-doc-est.sequencia) + string(i-cont2)
                  ttBusinessUnitItem.ttDocumentItemID     = ttDocumentItem.ttDocumentItemID
                  ttBusinessUnitItem.BusinessUnit         = unid-neg-nota.cod_unid_negoc           
                  ttBusinessUnitItem.RatePercentage       = unid-neg-nota.perc-unid-neg / 100.            

    END.
    IF i-cont2 = 0 OR item-doc-est.cod-unid-negoc <> "" THEN DO:
         ASSIGN i-cont2 = i-cont2 + 1.
         CREATE ttBusinessUnitItem.
         ASSIGN ttBusinessUnitItem.ttBusinessUnitID     = string(item-doc-est.sequencia) + string(i-cont2)
                ttBusinessUnitItem.ttDocumentItemID     = ttDocumentItem.ttDocumentItemID
                ttBusinessUnitItem.BusinessUnit         = item-doc-est.cod-unid-negoc           
                ttBusinessUnitItem.RatePercentage       = 1.   
    END.
    /* FIM Unidade de Neg¢cio */    
END. /* fim leitura ITEM-DOC-EST */

/* Leitura CONSIST-NOTA */

ASSIGN i-cont = 0.

FOR EACH  consist-nota NO-LOCK
    WHERE consist-nota.cod-emitente = docum-est.cod-emitente
    AND   consist-nota.nat-operacao = docum-est.nat-operacao
    AND   consist-nota.serie-docto  = docum-est.serie-docto 
    AND   consist-nota.nro-docto    = docum-est.nro-docto:  

    ASSIGN i-cont = i-cont + 1.

    &if '{&bf_dis_versao_ems}' > '2.062' &then
        FIND FIRST cadast_msg 
             WHERE cadast_msg.cdn_msg = consist-nota.mensagem NO-LOCK NO-ERROR.
    &ELSE
        FIND FIRST cad-msgs 
             WHERE cad-msgs.cd-msg = consist-nota.mensagem NO-LOCK NO-ERROR.
    &ENDIF

    CREATE  ttValidationMessage.
    ASSIGN  ttValidationMessage.ttValidationMessageID = i-cont
            ttValidationMessage.CalculatedValue       = consist-nota.calculado                            /*Valor calculado. (Uso interno: Campo = movind.consist-nota.calculado)*/
            ttValidationMessage.ComponentSequence     = consist-nota.sequencia                            /*Sequˆncia do componente. (Uso interno: Campo = movind.consist-nota.sequencia)*/
            ttValidationMessage.EnteredValue          = consist-nota.informado                            /*Valor informado. (Uso interno: Campo = movind.consist-nota.informado)*/
            &if '{&bf_dis_versao_ems}' > '2.062' &then    
            ttValidationMessage.MessageDescription    = IF AVAIL cadast_msg THEN cadast_msg.des_text_msg ELSE "" /*Texto da mensagem. (Uso interno: Campo = mguni.cadast_msg.des_text_msg)*/
            &ELSE
            ttValidationMessage.MessageDescription    = IF AVAIL cad-msgs THEN cad-msgs.texto-msg ELSE "" /*Texto da mensagem. (Uso interno: Campo = mguni.cad-msgs.texto-msg)*/
            &endif
            ttValidationMessage.MessageID             = consist-nota.mensagem                             /*Identificador da mensagem de consistência. (Uso interno: Campo = movind.consist-nota.mensagem)*/
            ttValidationMessage.MessageType           = consist-nota.tipo                                 /*Tipo da mensagem de consistência. Valores: 1 - Erro, 2 - Advertência, 3 - Correção Automática. (Uso interno: Campo = movind.consist-nota.tipo - Include = ininc/i01in060.i)*/
            ttValidationMessage.iStatus               = consist-nota.situacao.                            /*Situa‡Æo das consistências da nota. (Uso interno: Campo = movind.consist-nota.situacao)*/
    
END.

/* Leitura DESPESA-ACES */

ASSIGN i-cont = 0.

FOR EACH  despesa-aces NO-LOCK
    WHERE despesa-aces.cod-emitente = docum-est.cod-emitente
    AND   despesa-aces.nat-operacao = docum-est.nat-operacao
    AND   despesa-aces.serie-docto  = docum-est.serie-docto
    AND   despesa-aces.nro-docto    = docum-est.nro-docto:
    
    ASSIGN i-cont = i-cont + 1.

    /* Moeda */
    FIND FIRST moeda
         WHERE moeda.mo-codigo = despesa-aces.mo-codigo 
         NO-LOCK NO-ERROR.

    /* Esp‚cie Documento */
    FIND FIRST espec-ap
         WHERE espec-ap.cod-esp = despesa-aces.cod-esp
         NO-LOCK NO-ERROR.

    /* Tipo Receita Despesa */
    FIND FIRST tipo-rec-desp 
         WHERE tipo-rec-desp.tp-codigo = ttAccessoryExpense.ExpenseRevenueCode 
         NO-LOCK NO-ERROR.

    /* Natureza Opera‡Æo */
    FIND FIRST natur-oper  
         WHERE natur-oper.nat-operacao = despesa-aces.nat-oper-ac 
         NO-LOCK NO-ERROR.

    /* Emitente */
    FIND FIRST emitente
         WHERE emitente.cod-emitente = despesa-aces.cod-forn-ac 
         NO-LOCK NO-ERROR.

    CREATE  ttAccessoryExpense.
    ASSIGN  ttAccessoryExpense.ttAccessoryExpenseID          = i-cont
            ttAccessoryExpense.Sequence                      = i-cont                                                        /*Sequencial num‚rico da despesa acess¢ria*/
            ttAccessoryExpense.AccountNumber                 = despesa-aces.ct-tr-fornec                                     /*N£mero da conta transit¢ria. (Uso interno: Campo = movind.despesa-aces.ct-tr-fornec)*/
            ttAccessoryExpense.CurrencyID                    = despesa-aces.mo-codigo                                        /*C¢digo da moeda. (Uso interno: Campo = movind.despesa-aces.mo-codigo)*/
            ttAccessoryExpense.CurrencyDescription           = IF AVAIL moeda THEN moeda.descricao ELSE ""                   /*Descri‡Æo da moeda (Uso interno: Campo = mguni.moeda.descricao)*/
            ttAccessoryExpense.CurrencySign                  = IF AVAIL moeda THEN moeda.sigla     ELSE ""                   /*Sigla padrÆo da moeda (Uso interno: Campo = mguni.moeda.sigla)*/
            ttAccessoryExpense.CurrentRate                   = despesa-aces.cotacao-dia                                      /*Cota‡Æo atual moeda. (Uso interno: Campo = movind.despesa-aces.cotacao-dia)*/
            ttAccessoryExpense.DocumentClassDescription      = IF AVAIL espec-ap THEN espec-ap.descricao ELSE ""             /*Descri‡Æo da Esp‚cie do documento. (Uso interno: Campo = mgadm.espec-ap.descricao)*/
            ttAccessoryExpense.DocumentClassID               = despesa-aces.cod-esp                                          /*Identificador da Esp‚cie de documento. (Uso interno: Campo = movind.despesa-aces.cod-esp)*/
            ttAccessoryExpense.DocumentNarrative             = despesa-aces.observacao                                       /*Narrativa / Observa‡äes. (Uso interno: Campo = movind.despesa-aces.observacao)*/
            ttAccessoryExpense.DocumentNumber                = despesa-aces.nro-docto-ac                                     /*N£mero do documento da despesa acessória. (Uso interno: Campo = movind.despesa-aces.nro-docto-ac)*/
            ttAccessoryExpense.DocumentSeries                = despesa-aces.ser-docto-ac                                     /*S‚rie do documento da despesa acessória. (Uso interno: Campo = movind.despesa-aces.ser-docto-ac)*/
            ttAccessoryExpense.DocumentTotalValue            = despesa-aces.valor                                            /*Valor total do documento (Uso interno: Campo = movind.despesa-aces.valor)*/
            ttAccessoryExpense.DocumentTotalValue_00         = despesa-aces.valor-fasb[1]                                    /*Valor total do documento (Uso interno: Campo = movind.despesa-aces.valor-fasb[1])*/
            ttAccessoryExpense.DocumentTotalValue_01         = despesa-aces.valor-fasb[2]                                    /*Valor total do documento (Uso interno: Campo = movind.despesa-aces.valor-fasb[2])*/
            ttAccessoryExpense.DocumentTotalValue_02         = despesa-aces.valor-me                                         /*Valor total do documento (Uso interno: Campo = movind.despesa-aces.valor-me)*/
            ttAccessoryExpense.DueDate                       = despesa-aces.dt-vencto                                        /*Data de vencimento do documento. (Uso interno: Campo = movind.despesa-aces.dt-vencto)*/
            ttAccessoryExpense.ExpenseRevenueCode            = despesa-aces.tp-despesa                                       /*C¢digo do tipo de despesa. (Uso interno: Campo = movind.despesa-aces.tp-despesa)*/
            ttAccessoryExpense.ExpenseRevenueDescription     = IF AVAIL tipo-rec-desp THEN tipo-rec-desp.descricao ELSE ""   /*Descri‡Æo do tipo de despesa. (Uso interno: Campo = mgadm.tipo-rec-desp.decricao)*/
            ttAccessoryExpense.FiscalOperationCode           = despesa-aces.nat-oper-ac                                      /*C¢digo natureza de opera‡Æo. (Uso interno: Campo = movind.despesa-aces.nat-oper-ac)*/
            ttAccessoryExpense.FiscalOperationDescription    = IF AVAIL natur-oper THEN natur-oper.denominacao ELSE ""       /*Descri‡Æo da natureza de opera‡Æo. (Uso interno: Campo = mgind.natur-oper.denominacao)*/
            ttAccessoryExpense.IsDocumentFinancialIncreased  = despesa-aces.acresc-financ                                    /*Indica se o documento possui acréscimo financeiro. (Uso interno: Campo = movind.despesa-aces.acresc-financ)*/
            ttAccessoryExpense.NotTaxedValue                 = despesa-aces.icm-nao-trib                                     /*Valor da base de c lculo do ICMS nÆo tributado. (Uso interno: Campo = movind.despesa-aces.icm-nao-trib)*/
            ttAccessoryExpense.NotTaxedValue_00              = despesa-aces.icm-ntr-fasb[1]                                  /*Valor da base de c lculo do ICMS nÆo tributado. (Uso interno: Campo = movind.despesa-aces.icm-ntr-fasb[1])*/
            ttAccessoryExpense.NotTaxedValue_01              = despesa-aces.icm-ntr-fasb[2]                                  /*Valor da base de c lculo do ICMS nÆo tributado. (Uso interno: Campo = movind.despesa-aces.icm-ntr-fasb[2])*/
            ttAccessoryExpense.PrintDate                     = despesa-aces.dt-emissao                                       /*Data de emissão do documento. (Uso interno: Campo = movind.despesa-aces.dt-emissao)*/
            ttAccessoryExpense.SubAccountNumber              = despesa-aces.sc-tr-fornec                                     /*N£mero da subconta transit¢ria. (Uso interno: Campo = movind.despesa-aces.sc-tr-fornec)*/
            ttAccessoryExpense.SupplementaryTax              = despesa-aces.icm-complem                                      /*ICMS complementar, referente a notas fiscais de compra para consumo final oriundas de outros estados. (Uso interno: Campo = movind.despesa-aces.icm-complem)*/
            ttAccessoryExpense.SupplementaryTax_00           = despesa-aces.icm-comp-fasb[1]                                 /*ICMS complementar, referente a notas fiscais de compra para consumo final oriundas de outros estados. (Uso interno: Campo = movind.despesa-aces.icm-comp-fasb[1])*/
            ttAccessoryExpense.SupplementaryTax_01           = despesa-aces.icm-comp-fasb[2]                                 /*ICMS complementar, referente à notas fiscais de compra para consumo final oriundas de outros estados. (Uso interno: Campo = movind.despesa-aces.icm-comp-fasb[2])*/
            ttAccessoryExpense.TaxCalculationBasis           = despesa-aces.base-icm                                         /*Base de c lculo de ICMS. (Uso interno: Campo = movind.despesa-aces.base-icm)*/
            ttAccessoryExpense.TaxCalculationBasis_02        = despesa-aces.base-icm-fas[1]                                  /*Base de c lculo de ICMS. (Uso interno: Campo = movind.despesa-aces.base-icm-fas[1])*/
            ttAccessoryExpense.TaxCalculationBasis_03        = despesa-aces.base-icm-fas[2]                                  /*Base de c lculo de ICMS. (Uso interno: Campo = movind.despesa-aces.base-icm-fas[2])*/
            ttAccessoryExpense.TaxCode                       = despesa-aces.cd-trib-icm                                      /*Tipo de tratamento do ICMS em rela‡Æo ao item. Valores: 1 - Tributado, 2 - Isento, 3 - Outros, 4 - Reduzido, 5 - Diferido. (Uso interno: Campo = movind.despesa-aces.cd-trib-icm - Include = ininc/i07in122.i)*/
            ttAccessoryExpense.TaxOtherValue                 = despesa-aces.icm-outras                                       /*Valor da base de c lculo do ICMS Outras. (Uso interno: Campo = movind.despesa-aces.icm-outras)*/
            ttAccessoryExpense.TaxOtherValue_00              = despesa-aces.icm-out-fasb[1]                                  /*Valor da base de c lculo do ICMS Outras. (Uso interno: Campo = movind.despesa-aces.icm-out-fasb[1])*/
            ttAccessoryExpense.TaxOtherValue_01              = despesa-aces.icm-out-fasb[2]                                  /*Valor da base de c lculo do ICMS Outras. (Uso interno: Campo = movind.despesa-aces.icm-out-fasb[2])*/
            ttAccessoryExpense.TaxPercentage                 = despesa-aces.aliquota-icm                                     /*Aliquota ICMS. (Uso interno: Campo = movind.despesa-aces.aliquota-icm)*/
            ttAccessoryExpense.TaxValue                      = despesa-aces.icm-deb-cre                                      /*Valor total do ICMS das mercadorias da nota fiscal, dos itens e o valor da diferença entre o total da nota e total dos itens. (Uso interno: Campo = movind.despesa-aces.icm-deb-cre)*/
            ttAccessoryExpense.TaxValue_02                   = despesa-aces.icm-dc-fasb[1]                                   /*Valor total do ICMS das mercadorias da nota fiscal, dos itens e o valor da diferença entre o total da nota e total dos itens. (Uso interno: Campo = movind.despesa-aces.icm-dc-fasb[1])*/
            ttAccessoryExpense.TaxValue_03                   = despesa-aces.icm-dc-fasb[2]                                   /*Valor total do ICMS das mercadorias da nota fiscal, dos itens e o valor da diferença entre o total da nota e total dos itens. (Uso interno: Campo = movind.despesa-aces.icm-dc-fasb[2])*/
            ttAccessoryExpense.TotalTaxValue                 = despesa-aces.vl-taxa                                          /*Valor total dos impostos do documento. (Uso interno: Campo = movind.despesa-aces.vl-taxa)*/
            ttAccessoryExpense.TotalTaxValue_00              = despesa-aces.vl-taxa-me                                       /*Valor total dos impostos do documento. (Uso interno: Campo = movind.despesa-aces.vl-taxa-me)*/
            ttAccessoryExpense.TributarySubstitutionBasis    = despesa-aces.base-subs                                        /*Base de c lculo para o ICMS por regime de Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.despesa-aces.base-subs)*/
            ttAccessoryExpense.TributarySubstitutionBasis_00 = despesa-aces.base-subs-fasb[1]                                /*Base de c lculo para o ICMS por regime de Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.despesa-aces.base-subs-fasb[1])*/
            ttAccessoryExpense.TributarySubstitutionBasis_01 = despesa-aces.base-subs-fasb[2]                                /*Base de c lculo para o ICMS por regime de Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.despesa-aces.base-subs-fasb[2])*/
            ttAccessoryExpense.TributarySubstitutionValue    = despesa-aces.vl-subs                                          /*Valor do ICMS recolhido por Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.despesa-aces.vl-subs)*/
            ttAccessoryExpense.TributarySubstitutionValue_00 = despesa-aces.vl-subs-fasb[1]                                  /*Valor do ICMS recolhido por Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.despesa-aces.vl-subs-fasb[1])*/
            ttAccessoryExpense.TributarySubstitutionValue_01 = despesa-aces.vl-subs-fasb[2]                                  /*Valor do ICMS recolhido por Substitui‡Æo Tribut ria. (Uso interno: Campo = movind.despesa-aces.vl-subs-fasb[2])*/
            ttAccessoryExpense.VendorID                      = despesa-aces.cod-forn-ac.                                     /*C¢digo interno de identifica‡Æo do fornecedor. (Uso interno: Campo = movind.despesa-aces.cod-forn-ac)*/
            IF  AVAIL emitente THEN DO:
                ASSIGN  ttAccessoryExpense.VendorShortName   = emitente.nome-abrev                                           /*Nome abreviado do fornecedor. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
                        ttAccessoryExpense.VendorTaxID       = emitente.cgc.                                                 /*CGC do fornecedor. (Uso interno: Campo = mgadm.emitente.cgc)*/
            END.
            /*ASSIGN ttAccessoryExpense.TaxCalculationBasis_00 = INITIAL ? . /*Base de c lculo PIS. (Uso interno: Atributo Livre = movind.despesa-aces.char-2, posi‡Æo inicial = 7, posi‡Æo final = 19, N£mero de posi‡äes = 14)*/*/
            /*ASSIGN ttAccessoryExpense.TaxCalculationBasis_01 = INITIAL ? . /*Base de c lculo COFINS. (Uso interno: Atributo Livre = movind.despesa-aces.char-2, posi‡Æo inicial = 41, posi‡Æo final = 54, N£mero de posi‡äes = 14)*/*/
            /*ASSIGN ttAccessoryExpense.TaxCode_00 = INITIAL ? . /*Tributa‡Æo PIS. Valores: 1 - Tributado, 2 - Isento. (Uso interno: Atributo Livre = movind.despesa-aces.char-2, posi‡Æo inicial = 1, posi‡Æo final = 1, N£mero de posi‡äes = 1)*/*/
            /*ASSIGN ttAccessoryExpense.TaxCode_01 = INITIAL ? . /*Tributa‡Æo COFINS. Valores: 1 - Tributado, 2 - Isento. (Uso interno: Atributo Livre = movind.despesa-aces.char-2, posi‡Æo inicial = 35, posi‡Æo final = 35, N£mero de posi‡äes = 1)*/*/
            /*ASSIGN ttAccessoryExpense.TaxPercentage_00 = INITIAL ? . /*Aliquota PIS. (Uso interno: Atributo Livre = movind.despesa-aces.char-2, posi‡Æo inicial = 2, posi‡Æo final = 6, N£mero de posi‡äes = 5)*/*/
            /*ASSIGN ttAccessoryExpense.TaxPercentage_01 = INITIAL ? . /*Aliquota COFINS. (Uso interno: Atributo Livre = movind.despesa-aces.char-2, posi‡Æo inicial = 36, posi‡Æo final = 40, N£mero de posi‡äes = 5)*/*/
            /*ASSIGN ttAccessoryExpense.TaxValue_00 = INITIAL ? . /*Valor PIS a recuperar. (Uso interno: Atributo Livre = movind.despesa-aces.char-2, posi‡Æo inicial = 20, posi‡Æo final = 32, N£mero de posi‡äes = 14)*/*/
            /*ASSIGN ttAccessoryExpense.TaxValue_01 = INITIAL ? . /*Valor COFINS a recuperar. (Uso interno: Atributo Livre = movind.despesa-aces.char-2, posi‡Æo inicial = 55, posi‡Æo final = 68, N£mero de posi‡äes = 14)*/*/
END.

/* Leitura Dupli-Apagar */

ASSIGN i-cont = 0.
ASSIGN i-cont2 = 0.

FOR EACH  dupli-apagar NO-LOCK 
    WHERE dupli-apagar.cod-emitente = docum-est.cod-emitente 
    AND   dupli-apagar.nat-operacao = docum-est.nat-operacao 
    AND   dupli-apagar.serie-docto  = docum-est.serie-docto  
    AND   dupli-apagar.nro-docto    = docum-est.nro-docto:

    ASSIGN i-cont = i-cont + 1.

    /* Esp‚cie Documento */
    FIND FIRST espec-ap 
         WHERE espec-ap.cod-esp = dupli-apagar.cod-esp 
         NO-LOCK NO-ERROR. 

    /* Tipo Receita Despesa */
    FIND FIRST tipo-rec-desp 
         WHERE tipo-rec-desp.tp-codigo = dupli-apagar.tp-despesa 
         NO-LOCK NO-ERROR.
         
    CREATE  ttDocumentBill.
    ASSIGN  ttDocumentBill.ttDocumentBillID             = i-cont
            ttDocumentBill.BillNumber                   = dupli-apagar.nr-duplic                                        /*N£mero da duplicata. (Uso interno: Campo = movind.dupli-apagar.nr-duplic)*/
            ttDocumentBill.CMCACValue                   = dupli-apagar.vl-ap-fasb[2]                                    /*Valor da duplicata, expresso em moeda CMCAC. (Uso interno: Campo = movind.dupli-apagar.vl-ap-fasb[2])*/
            ttDocumentBill.Comments                     = dupli-apagar.observacao                                       /*Observa‡äes e comentários. (Uso interno: Campo = movind.dupli-apagar.observacao)*/
            ttDocumentBill.CurrentCurrencyValue         = dupli-apagar.vl-a-pagar                                       /*Valor da duplicata, expresso na moeda corrente do sistema. (Uso interno: Campo = movind.dupli-apagar.vl-a-pagar)*/
            ttDocumentBill.DaysLate                     = dupli-apagar.dias-atraso                                      /*A partir de quantos dias de atraso sera cobrado juros/mora. (Uso interno: Campo = movind.dupli-apagar.dias-atraso)*/
            ttDocumentBill.DebitOrCredit                = dupli-apagar.esp-movto                                        /*T¡tulo lançado a d‚bito ou cr‚dito. Valores: 1 - cr‚dito, 2 - d‚bito. (Uso interno: Campo = movind.dupli-apagar.esp-movto - Include = ininc/i01in088.i)*/
            ttDocumentBill.DiscountDueDate              = dupli-apagar.dt-venc-desc                                     /*Data de vencimento da duplicata, para pagamento com desconto. (Uso interno: Campo = movind.dupli-apagar.dt-venc-desc)*/
            ttDocumentBill.DiscountPercentage           = dupli-apagar.desconto                                         /*Percentual de desconto da duplicata. (Uso interno: Campo = movind.dupli-apagar.desconto)*/
            ttDocumentBill.DiscountValue                = dupli-apagar.vl-desconto                                      /*Valor de desconto para a duplicata. (Uso interno: Campo = movind.dupli-apagar.vl-desconto)*/
            ttDocumentBill.DocumentClassID              = dupli-apagar.cod-esp                                          /*Identificador da Esp‚cie de documento. (Uso interno: Campo = movind.dupli-apagar.cod-esp)*/
            ttDocumentBill.DocumentClassDescription     = IF AVAIL espec-ap THEN espec-ap.descricao ELSE ""             /*Descri‡Æo da Esp‚cie do documento. (Uso interno: Campo = mgadm.espec-ap.descricao)*/
            ttDocumentBill.DueDate                      = dupli-apagar.dt-vencim                                        /*Data de vencimento da duplicata. (Uso interno: Campo = movind.dupli-apagar.dt-vencim)*/
            ttDocumentBill.ExpenseRevenueCode           = dupli-apagar.tp-despesa                                       /*C¢digo do tipo de despesa. (Uso interno: Campo = movind.dupli-apagar.tp-despesa)*/
            ttDocumentBill.ExpenseRevenueDescription    = IF AVAIL tipo-rec-desp THEN tipo-rec-desp.descricao ELSE ""   /*Descri‡Æo do tipo de despesa. (Uso interno: Campo = mgadm.tipo-rec-desp.decricao)*/
            ttDocumentBill.FASBValue                    = dupli-apagar.vl-ap-fasb[1]                                    /*Valor da duplicata, expresso em moeda FASB. (Uso interno: Campo = movind.dupli-apagar.vl-ap-fasb[1])*/
            ttDocumentBill.FinePercentage               = dupli-apagar.perc-mora                                        /*Percentual de multa. (Uso interno: Campo = movind.dupli-apagar.perc-mora)*/
            ttDocumentBill.ForeignValue                 = dupli-apagar.valor-a-pagar-me                                 /*Valor da duplicata, expresso em moeda estrangeira. (Uso interno: Campo = movind.dupli-apagar.valor-a-pagar-me)*/
            ttDocumentBill.InstallmentNumber            = dupli-apagar.parcela                                          /*N£mero parcela da duplicata da nota fiscal. (Uso interno: Campo = movind.dupli-apagar.parcela)*/
            ttDocumentBill.InterestPercentage           = dupli-apagar.perc-juros                                       /*Percentual de juros diário por atraso (Uso interno: Campo = movind.dupli-apagar.perc-juros)*/
            ttDocumentBill.PrintDate                    = dupli-apagar.dt-emissao                                       /*Data de emissão da duplicata. (Uso interno: Campo = movind.dupli-apagar.dt-emissao)*/
            ttDocumentBill.TaxRetentionCode             = dupli-apagar.cod-ret-irf                                      /*C¢digo de retenção de imposto. (Uso interno: Campo = movind.dupli-apagar.cod-ret-irf)*/
            ttDocumentBill.TransactionDate              = dupli-apagar.dt-trans                                         /*Data da transa‡Æo. (Uso interno: Campo = movind.dupli-apagar.dt-trans)*/
            i-cont2                                     = 0.

    FOR EACH  dupli-imp NO-LOCK
        WHERE dupli-imp.cod-emitente = dupli-apagar.cod-emitente
        AND   dupli-imp.serie-docto  = dupli-apagar.serie-docto
        AND   dupli-imp.nro-docto    = dupli-apagar.nro-docto
        AND   dupli-imp.cod-emitente = dupli-apagar.cod-emitente
        AND   dupli-imp.parcela      = dupli-apagar.parcela:

        ASSIGN i-cont2 = i-cont2 + 1.

        /* Esp‚cie Documento */
        FIND FIRST espec-ap 
             WHERE espec-ap.cod-esp = dupli-imp.cod-esp 
             NO-LOCK NO-ERROR. 

        /* Tipo Receita Despesa */
        FIND FIRST tipo-rec-desp 
             WHERE tipo-rec-desp.tp-codigo = dupli-imp.tp-codigo 
             NO-LOCK NO-ERROR.

        /* Tipo Imposto */
        FIND FIRST tipo-tax 
             WHERE tipo-tax.cod-tax = dupli-imp.int-1 
             NO-LOCK NO-ERROR.

        /* Emitente */
        FIND FIRST emitente 
             WHERE emitente.cod-emitente = dupli-imp.cod-forn-imp 
             NO-LOCK NO-ERROR.

        CREATE  ttBillTax.
        ASSIGN  ttBillTax.ttBillTaxID                       = i-cont2
                ttBillTax.ttDocumentBillID                  = ttDocumentBill.ttDocumentBillID
                ttBillTax.DocumentClassID                   = dupli-imp.cod-esp                                             /*Identificador da Esp‚cie de documento. (Uso interno: Campo = movind.dupli-imp.cod-esp)*/
                ttBillTax.DocumentClassDescription          = IF AVAIL espec-ap THEN espec-ap.descricao ELSE ""             /*Descri‡Æo da Esp‚cie do documento. (Uso interno: Campo = mgadm.espec-ap.descricao)*/
                ttBillTax.ExpenseRevenueCode                = dupli-imp.tp-codigo                                           /*C¢digo do tipo de despesa. (Uso interno: Campo = movind.dupli-imp.tp-codigo)*/
                ttBillTax.ExpenseRevenueDescription         = IF AVAIL tipo-rec-desp THEN tipo-rec-desp.descricao ELSE ""   /*Descri‡Æo do tipo de despesa. (Uso interno: Campo = mgadm.tipo-rec-desp.decricao)*/
                ttBillTax.TaxableIncome                     = dupli-imp.rend-trib                                           /*Rendimentos tributados. (Uso interno: Campo = movind.dupli-imp.rend-trib)*/
                ttBillTax.TaxCode                           = dupli-imp.int-1                                               /*C¢digo do imposto. (Uso interno: Campo = movind.dupli-imp.int-1)*/
                ttBillTax.TaxDescription                    = IF AVAIL tipo-tax THEN tipo-tax.descricao ELSE ""             /*Descri‡Æo do imposto. (Uso interno: Campo = mgdis.tipo-tax.descricao)*/
                ttBillTax.TaxDocumentNumber                 = dupli-imp.nro-docto-imp                                       /*N£mero do documento do imposto. (Uso interno: Campo = movind.dupli-imp.nro-docto-imp)*/
                ttBillTax.TaxDueDate                        = dupli-imp.dt-venc-imp                                         /*Data de vencimento do imposto. (Uso interno: Campo = movind.dupli-imp.dt-venc-imp)*/
                ttBillTax.TaxInstallmentNumber              = dupli-imp.parcela-imp                                         /*Parcela do imposto. (Uso interno: Campo = movind.dupli-imp.parcela-imp)*/
                ttBillTax.TaxPercentage                     = dupli-imp.aliquota                                            /*Aliquota do imposto. (Uso interno: Campo = movind.dupli-imp.aliquota)*/
                ttBillTax.TaxRetentionCode                  = dupli-imp.cod-retencao                                        /*C¢digo de retenção de imposto. (Uso interno: Campo = movind.dupli-imp.cod-retencao)*/
                ttBillTax.TaxType                           = dupli-imp.tp-imposto                                          /*Tipo de imposto. (Uso interno: Campo = movind.dupli-imp.tp-imposto)*/
                ttBillTax.TaxValue                          = dupli-imp.vl-imposto                                          /*Valor do imposto. (Uso interno: Campo = movind.dupli-imp.vl-imposto)*/
                ttBillTax.VendorID                          = dupli-imp.cod-forn-imp.                                       /*C¢digo interno de identifica‡Æo do fornecedor. (Uso interno: Campo = movind.dupli-imp.cod-forn-imp)*/
                IF  AVAIL emitente THEN DO:
                    ASSIGN ttBillTax.VendorShortName        = emitente.nome-abrev                                           /*Nome abreviado do fornecedor. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
                           ttBillTax.VendorTaxID            = emitente.cgc.                                                 /*CGC do fornecedor. (Uso interno: Campo = mgadm.emitente.cgc)*/
                END.
    END.
END.

/* Leitura RAT-DOCUM */

ASSIGN i-cont = 0.

FOR EACH  rat-docum NO-LOCK
    WHERE rat-docum.cod-emitente = docum-est.cod-emitente
    AND   rat-docum.nat-operacao = docum-est.nat-operacao
    AND   rat-docum.serie-docto  = docum-est.serie-docto
    AND   rat-docum.nro-docto    = docum-est.nro-docto:

    ASSIGN i-cont = i-cont + 1.

    /* Natureza Opera‡Æo */
    FIND FIRST natur-oper 
         WHERE natur-oper.nat-operacao = rat-docum.nf-nat-oper 
         NO-LOCK NO-ERROR.
    
    /* Emitente */
    FIND FIRST emitente 
         WHERE emitente.cod-emitente = rat-docum.nf-emitente 
         NO-LOCK NO-ERROR.
         
    CREATE  ttDocumentForFreightDistr_00.
    ASSIGN  ttDocumentForFreightDistr_00.ttDocumentForFreightDistr_00ID = i-cont
            ttDocumentForFreightDistr_00.DocumentNumber                 = rat-docum.nf-nro                                          /*N£mero do documento. (Uso interno: Campo = movind.rat-docum.nf-nro)*/
            ttDocumentForFreightDistr_00.DocumentSeries                 = rat-docum.nf-serie                                        /*S‚rie do documento. (Uso interno: Campo = movind.rat-docum.nf-serie)*/
            ttDocumentForFreightDistr_00.FiscalOperationCode            = rat-docum.nf-nat-oper                                     /*C¢digo natureza de opera‡Æo. (Uso interno: Campo = movind.rat-docum.nf-nat-oper)*/
            ttDocumentForFreightDistr_00.FiscalOperationDescription     = IF AVAIL natur-oper THEN natur-oper.denominacao ELSE ""   /*Descri‡Æo da natureza de opera‡Æo. (Uso interno: Campo = mgind.natur-oper.denominacao)*/
            ttDocumentForFreightDistr_00.InvoiceDocumentType            = rat-docum.tipo-nota                                       /*Tipo de nota fiscal. Valores: 1 - Compra, 2 - Beneficiamento, 3 - Devolu‡Æo, 4 - Consigna‡Æo,5 - Transferˆncia. (Uso interno: Campo = movind.rat-docum.tipo-nota)*/
            ttDocumentForFreightDistr_00.VendorID                       = rat-docum.nf-emitente.                                    /*C¢digo interno de identifica‡Æo do fornecedor. (Uso interno: Campo = movind.rat-docum.nf-emitente)*/
            IF  AVAIL emitente THEN DO:
                ASSIGN ttDocumentForFreightDistr_00.VendorShortName     = emitente.nome-abrev                                       /*Nome abreviado do fornecedor. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
                        ttDocumentForFreightDistr_00.VendorTaxID        = emitente.cgc.                                             /*CGC do fornecedor. (Uso interno: Campo = mgadm.emitente.cgc)*/
    END.
    /*ASSIGN ttDocumentForFreightDistr_00.DocumentSource = rat-docum.ind-origem-nf. /*Origem do documento. (Uso interno: Campo = movind.rat-docum.ind-origem-nf)*/*/
    /*ASSIGN ttDocumentForFreightDistr_00.Sequence = INITIAL ? . /*Sequencial num‚rico do documento para rateio de frete*/*/
END.


IF VALID-HANDLE(h-cdapi995) THEN DO:
    RUN pi-finalizar in h-cdapi995.
    ASSIGN h-cdapi995 = ?.
END.


RUN PIUpsert (INPUT cEvent,
              INPUT cTranAction,
              INPUT TABLE ttReceiptDocument,
              INPUT TABLE ttDocumentItem,
              INPUT TABLE ttDocumentBill,
              INPUT TABLE ttBillTax,
              INPUT TABLE ttAccessoryExpense,
              INPUT TABLE ttDocumentForFreightDistr_00,
              INPUT TABLE ttPurchaseOrder,
              INPUT TABLE ttReceiptLocation,
              INPUT TABLE ttValidationMessage,
              INPUT TABLE ttInventoryUpdate,
              OUTPUT TABLE tt_log_erro).

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.

