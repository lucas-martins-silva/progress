&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducão
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN082FX 2.00.00.048 } /*** "010048" 18/03/2026 14:31:06 ***/
/*
&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN082FX MUT}
&ENDIF
*/
/*--------------------------------------------------------------------------
    File       :
    Purpose    : O DBO (Datasul Business Objects) Â² um programa PROGRESS
                 que contÂ²m a lÂ½gica de negÂ½cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      : BO utilizado apenas para navega‡Ã†o default e openQueries
                 com apenas uma tabela.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiÂ»â€™o ---*/
&GLOBAL-DEFINE DBOName cotacao-item
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableLabel cotacao-item
&GLOBAL-DEFINE QueryName qr{&TableName}
&GLOBAL-DEFINE TableName cotacao-item

/*--- Include com definiÂ»â€™o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diretÂ½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idÂ¼ntico ao nome do DBO mas com
      extensâ€™o .i ---*/
{inbo/boin082.i RowObject}

/*--- Include com definiÂ»â€™o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraÂ»â€™o da definiÂ»â€™o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiÂ»â€™o
      manual da query ---*/
{method/dboqry.i}

/** NÃ†o elimine a linha abaixo, â€š a chamada EPC **/
{include/i-epc200.i "boin082fx"}

/*Includes FLEX*/
{fch/fchmat/fchmatlastpurchaseofitem.i ttLastPurchaseOfItem}
{fch/fchmat/fchmatlastpurchaseofitem.i ttNumLastPurchaseOfItem}
{fch/fchmat/fchmatquotation.i ttQuotation}
{fch/fchmat/fchmatstringvo.i ttStringVO}
{fch/fchmat/fchmatpurchaserequisition.i ttPurchaseRequisition}
{fch/fchmat/fchmatpurchaserequisitionfilter.i ttPurchaseRequisitionFilter}
{fch/fchmat/fchmatsupplierinfo.i ttSupplierInformation}
{fch/fchmat/fchmatsuppliercontact.i ttSupplierContact}
{fch/fchmat/fchmatenterquotations.i} /*ttQuotations*/
{fch/fchmat/fchmataddpurchaserequisitions.i1} /* ttDeliverySchedule */
{fch/fchmat/fchmatquotationdetails.i ttQuotationDetails} /*ttQuotationDetails*/
{fch/fchmat/fchmatquotationreportdelivery.i ttQuotationReportDelivery}
{fch/fchmat/fchmatquotationreport.i ttQuotationReport}
{fch/fchmat/fchmatpackagevendorcontact.i ttPackageVendorContact}
{fch/fchmat/fchmatpackagequotationreport.i ttPackageQuotationReport}
{fch/fchmat/fchmatpackquotationreportreq.i ttPackageQuotationReportRequest}
{fch/fchmat/fchmatdetailquotations.i} /* ttSummaryQuotation */
{inbo/boin00886.i tt-fornec-clicbusiness} /*tt-fornec-clicbusiness*/
{ccp/ccapi344.i} /* tt-empresa-usuario-logado */
{ccp/ccapi099.i4} /*ttPurchRequisPrint*/

DEFINE TEMP-TABLE tt-cotacoes-lidas NO-UNDO
    FIELD nr-ordem     AS INTEGER
    FIELD cod-emitente AS INTEGER
    FIELD un           AS CHARACTER
    FIELD cdn-fabrican LIKE fab-medic.cdn-fabrican.

DEFINE TEMP-TABLE ttLastPurchaseOfItemAux NO-UNDO LIKE ttLastPurchaseOfItem
    FIELD currencyCode AS INTEGER.

DEFINE BUFFER b-ordem        FOR ordem-compra.
DEFINE BUFFER b-cotacao-item FOR cotacao-item.
DEFINE BUFFER bttLastPurchaseOfItemAux FOR ttLastPurchaseOfItemAux.

DEFINE VARIABLE h-cd0812              AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-boin00885           AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-boin839             AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-boun005             AS HANDLE  NO-UNDO.
DEFINE VARIABLE de-ultimo-menor-valor AS DECIMAL NO-UNDO.
DEFINE VARIABLE icont                 AS INTEGER NO-UNDO.
DEFINE VARIABLE inum-pedido           AS INTEGER NO-UNDO.

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ).
 Se estiver definida a variavel bf-mat-comex
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se nÃ†o, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */
{include/i_dbvers.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-cgc DBOProgram 
FUNCTION fn-cgc RETURNS CHARACTER
  ( INPUT i-cod-emitente AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnAveragePayment DBOProgram 
FUNCTION fnAveragePayment RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCurrencyShorthand DBOProgram 
FUNCTION fnCurrencyShorthand RETURNS CHARACTER
  ( INPUT iCurrency AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnExpenses DBOProgram 
FUNCTION fnExpenses RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnFreightPrice DBOProgram 
FUNCTION fnFreightPrice RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItemPrice DBOProgram 
FUNCTION fnItemPrice RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnManufacturerName DBOProgram 
FUNCTION fnManufacturerName RETURNS CHARACTER
  ( INPUT i-fab-medic AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPaymentTerm DBOProgram 
FUNCTION fnPaymentTerm RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTotalPrice DBOProgram 
FUNCTION fnTotalPrice RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnVendorPrice DBOProgram 
FUNCTION fnVendorPrice RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 28.54
         WIDTH              = 41.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE approvePurchaseRequisitions DBOProgram 
PROCEDURE approvePurchaseRequisitions :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  comment   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  TABLE FOR ttStringVO.
    DEFINE INPUT PARAMETER  supplierId AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE h-facade AS HANDLE NO-UNDO.

    RUN fch/fchmat/fchmatenterquotations.p PERSISTENT SET h-facade.
    FOR EACH ttStringVO:
        EMPTY TEMP-TABLE ttQuotations.

        FIND FIRST cotacao-item
             WHERE cotacao-item.numero-ordem = int(ttStringVO.stringName)
               AND cotacao-item.cod-emitente = int(supplierId) NO-LOCK NO-ERROR.
        IF AVAIL cotacao-item THEN DO:

            RUN getDeliverySchedule IN h-facade (INPUT cotacao-item.numero-ordem,
                                                 OUTPUT TABLE ttDeliverySchedule).
            CREATE ttQuotations.
            BUFFER-COPY cotacao-item TO ttQuotations NO-ERROR.
            ASSIGN ttQuotations.motivo-apr = comment.

            RUN aproveQuotation IN h-facade(INPUT  TABLE ttQuotations,
                                            INPUT  TABLE ttDeliverySchedule,
                                            OUTPUT TABLE RowErrors).
        END.
    END.

    DELETE PROCEDURE h-facade.
    ASSIGN h-facade = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE approveSuggestedQuotations DBOProgram 
PROCEDURE approveSuggestedQuotations :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER  comment AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER  TABLE FOR ttQuotation.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE h-facade AS HANDLE NO-UNDO.

    RUN fch/fchmat/fchmatenterquotations.p PERSISTENT SET h-facade.
    FOR EACH ttQuotation:
        EMPTY TEMP-TABLE ttQuotations.
        FIND FIRST cotacao-item
             WHERE cotacao-item.numero-ordem = int(ttQuotation.purchaseRequisitionId)
               AND cotacao-item.cod-emitente = int(ttQuotation.supplierId)
               AND cotacao-item.seq-cotac    = sequence NO-LOCK NO-ERROR.
        IF AVAIL cotacao-item THEN DO:
            RUN getDeliverySchedule IN h-facade (INPUT cotacao-item.numero-ordem,
                                                 OUTPUT TABLE ttDeliverySchedule).
            CREATE ttQuotations.
            BUFFER-COPY cotacao-item TO ttQuotations NO-ERROR.
            ASSIGN ttQuotations.motivo-apr = comment.

        END.
        RUN aproveQuotation IN h-facade(INPUT  TABLE ttQuotations,
                                        INPUT  TABLE ttDeliverySchedule,
                                        OUTPUT TABLE RowErrors).
    END.

    DELETE PROCEDURE h-facade.
    ASSIGN h-facade = ?.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createNumLastPurchaseOfItem DBOProgram 
PROCEDURE createNumLastPurchaseOfItem :
/*------------------------------------------------------------------------------
  Purpose: Cria a temp-table com o n£mero de ultimas compras da Cota‡Æo da Listagem
  Parameters:  bh-cotacao-item (input): handle do buffer da cota‡Æo a ser gerada na temp-table
               bh-ordem-compra (input): handle do buffer da ordem de compra da cota‡Æo a ser gerada na temp-table
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER bh-cotacao-item AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER bh-ordem-compra AS HANDLE NO-UNDO.

    IF NOT VALID-HANDLE(bh-cotacao-item) 
    OR NOT VALID-HANDLE(bh-ordem-compra) THEN
        RETURN "NOK":U.

    IF NOT CAN-FIND(FIRST ttNumLastPurchaseOfItem
                    WHERE ttNumLastPurchaseOfItem.purchaseRequisitionId = STRING(bh-cotacao-item:BUFFER-FIELD("numero-ordem":U):BUFFER-VALUE)) THEN DO:
        
        CREATE ttNumLastPurchaseOfItem.
        ASSIGN ttNumLastPurchaseOfItem.itemId                 = item.it-codigo
               ttNumLastPurchaseOfItem.itemDescription        = item.desc-item
               ttNumLastPurchaseOfItem.purchaseDate           = bh-cotacao-item:BUFFER-FIELD("data-cotacao":U):BUFFER-VALUE
               ttNumLastPurchaseOfItem.price                  = bh-cotacao-item:BUFFER-FIELD("preco-fornec":U):BUFFER-VALUE
               ttNumLastPurchaseOfItem.purchaseRequisitionId  = STRING(bh-cotacao-item:BUFFER-FIELD("numero-ordem":U):BUFFER-VALUE)
               icont                                          = icont + 1.
    
        FOR FIRST tab-unidade FIELDS (un descricao) WHERE tab-unidade.un = bh-cotacao-item:BUFFER-FIELD("un":U):BUFFER-VALUE NO-LOCK:
            ASSIGN ttNumLastPurchaseOfItem.unitOfMeasure            = tab-unidade.un
                   ttNumLastPurchaseOfItem.unitOfMeasureDescription = tab-unidade.descricao.
        END.

        FOR FIRST cond-pagto FIELDS(descricao) WHERE cond-pagto.cod-cond-pag = bh-ordem-compra:BUFFER-FIELD("cod-cond-pag":U):BUFFER-VALUE NO-LOCK:
           ASSIGN ttNumLastPurchaseOfItem.paymentCondition      = cond-pagto.descricao.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-emit natureza cgc) WHERE emitente.cod-emitente = bh-ordem-compra:BUFFER-FIELD("cod-emitente":U):BUFFER-VALUE NO-LOCK:
          ASSIGN ttNumLastPurchaseOfItem.supplierId          = string(emitente.cod-emitente)
                 ttNumLastPurchaseOfItem.supplierDescription = emitente.nome-emit
                 ttNumLastPurchaseOfItem.supplierCNPJ        = fn-cgc(emitente.cod-emitente).
        END.
        /*Busca sigla da moeda da ordem de compra*/
        ASSIGN ttNumLastPurchaseOfItem.currencyShorthand = fnCurrencyShorthand(bh-ordem-compra:BUFFER-FIELD("mo-codigo":U):BUFFER-VALUE).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createQuotationDetails DBOProgram 
PROCEDURE createQuotationDetails :
/*------------------------------------------------------------------------------
  Purpose: Cria a temp-table com as cota‡äes
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-fab-medic LIKE fab-medic.cdn-fabrican NO-UNDO.

    CREATE ttQuotationDetails.
    ASSIGN ttQuotationDetails.purchaseRequisitionId = STRING(ordem-compra.numero-ordem)
           ttQuotationDetails.supplierId            = ttSupplierInformation.supplierId
           ttQuotationDetails.supplierName          = ttSupplierInformation.supplierName
           ttQuotationDetails.sequence              = cotacao-item.seq-cotac
           ttQuotationDetails.totalValue            = string(fnTotalPrice(), ">>>>>,>>>,>>9.9999")         /* Pre‡o Total */
           ttQuotationDetails.unitPrice             = ROUND(fnItemPrice(),4)                               /* Pre‡o UnitÂ rio */
           ttQuotationDetails.discountPerc          = cotacao-item.perc-descto                             /* % Desconto */
           ttQuotationDetails.deliveryTime          = cotacao-item.prazo-entreg                            /* Prazo Entrega */
           ttQuotationDetails.paymentCondition      = fnPaymentTerm()                                      /* Condi‡Æo de Pagto */
           ttQuotationDetails.finantialTaxValue     = cotacao-item.valor-taxa                              /* Taxa Financeira */
           ttQuotationDetails.freightValue          = fnFreightPrice()                                     /* Valor Frete Fornecedor */
           ttQuotationDetails.ipiPerc               = TRUNC(cotacao-item.aliquota-ipi,2)                   /* IPI */
           ttQuotationDetails.ipiIncluded           = cotacao-item.codigo-ipi                              /* IPI Incluso */
           ttQuotationDetails.icmsPerc              = TRUNC(cotacao-item.aliquota-icm,2)                   /* ICMS */
           ttQuotationDetails.averagePayment        = int(fnAveragePayment())                              /* Prazo MÃ©dio de Pagamento */
           ttQuotationDetails.vendorPrice           = ROUND(fnVendorPrice(),4)
           ttQuotationDetails.unitOfMeasure         = cotacao-item.un.

   FOR FIRST tab-unidade FIELDS(descricao) WHERE tab-unidade.un = cotacao-item.un NO-LOCK.
       ASSIGN ttQuotationDetails.unitOfMeasureDescription = tab-unidade.descricao.
   END.

   /*Busca fabricante de medicamento da cota‡Æo*/
   IF CAN-FIND (FIRST funcao 
                WHERE funcao.cd-funcao = "spp-integra-ems-his" 
                  AND funcao.ativo = YES) THEN DO:

       &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
            ASSIGN i-fab-medic = cotacao-item.cdn-fab-medic.
       &ELSE
           /*C¢digo do Fabricante de medicamentos na cota‡Æo*/
            ASSIGN i-fab-medic = int(trim(substring(cotacao-item.char-1,127,9))) NO-ERROR.
       &ENDIF

       assign ttQuotationDetails.manufacturer = i-fab-medic
              ttQuotationDetails.activeHisFunction = YES
              ttQuotationDetails.manufacturerDescription = fnManufacturerName(INPUT i-fab-medic).
   END. /*Fim IF fun‡Æo spp-integra-ems-his*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTTPurchaseRequisition DBOProgram 
PROCEDURE createTTPurchaseRequisition :
/*------------------------------------------------------------------------------
  Objetivo: Criar o registro na temp-table ttPurchaseRequisition.                       
  Parameters:  
  Notas: Apenas os campos comuns sÆo preenchidos nesta procedure, os campos particulares 
         devem ser preenchidos abaixo da chamada desta procedure.
------------------------------------------------------------------------------*/
    CREATE ttPurchaseRequisition.
    ASSIGN ttPurchaseRequisition.purchaseRequisitionId = STRING(ordem-compra.numero-ordem)
           ttPurchaseRequisition.itemId                = ordem-compra.it-codigo
           ttPurchaseRequisition.itemDescription       = IF AVAIL ITEM THEN ITEM.it-codigo ELSE ""
           ttPurchaseRequisition.quantity              = ordem-compra.qt-solic
           ttPurchaseRequisition.referencePrice        = STRING(0, ">>>>>>>>>,>>>,>>9.99").

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTTQuotation DBOProgram 
PROCEDURE createTTQuotation :
/*------------------------------------------------------------------------------
  Objetivo: Criar o registro na temp-table ttQuotation.
  Parameters:  
  Notas: 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER comparationValue  AS INTEGER NO-UNDO.

    CASE comparationValue:
        WHEN 1 THEN DO:
                ASSIGN ttQuotation.quotationValue = STRING(fnTotalPrice(), ">>>>>>>>>,>>>,>>9.99").
        END.
    
        WHEN 2 THEN DO:
                ASSIGN ttQuotation.quotationValue = IF fnAveragePayment() = ? THEN "0" ELSE STRING(fnAveragePayment(), ">>>9.99").
        END.
    
        WHEN 3 THEN DO:
                ASSIGN ttQuotation.quotationValue = STRING(fnItemPrice(), ">>>>>>>>>,>>>,>>9.99").
        END.
    
    END CASE.
    
    ASSIGN ttQuotation.quotationTotalValue = string(fnTotalPrice(), ">>>>>>>>>,>>>,>>9.99")
           ttQuotation.approved            = cotacao-item.cot-aprovada
           ttQuotation.sequence            = cotacao-item.seq-cotac
           ttQuotation.unitPrice           = ROUND(fnItemPrice(),4)                               /* Pre‡o UnitÂ rio */
           ttQuotation.discountPerc        = cotacao-item.perc-descto                             /* % Desconto */
           ttQuotation.deliveryTime        = cotacao-item.prazo-entreg                            /* Prazo Entrega */
           ttQuotation.paymentCondition    = fnPaymentTerm()                                      /* Condi‡Ã†o de Pagto */
           ttQuotation.finantialTaxValue   = cotacao-item.valor-taxa                              /* Taxa Financeira */
           ttQuotation.freightValue        = fnFreightPrice()                                     /* Valor Frete Fornecedor */
           ttQuotation.ipiPerc             = TRUNC(cotacao-item.aliquota-ipi,2)                   /* IPI */
           ttQuotation.ipiIncluded         = cotacao-item.codigo-ipi                              /* IPI Incluso */
           ttQuotation.icmsPerc            = TRUNC(cotacao-item.aliquota-icm,2)                   /* ICMS */
           ttQuotation.averagePayment      = int(fnAveragePayment())                              /* Prazo MÃ©dio de Pagamento */
           ttQuotation.vendorPrice         = ROUND(fnVendorPrice(),4)
           ttQuotation.unitOfMeasure       = cotacao-item.un.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAmountOrder DBOProgram 
PROCEDURE getAmountOrder :
/*------------------------------------------------------------------------------
  Purpose: Retornar valores pedido aberto e pedido em atraso
  Parameters:  pNrPedido: nÂ£mero do pedido que se deseja buscar os valores
               pAmountDelayed: Valor aberto
               pAmountOrdered: Valor em atraso
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNrPedido      LIKE pedido-compr.num-pedido NO-UNDO.
    DEFINE OUTPUT PARAMETER pAmountDelayed AS DECIMAL                   NO-UNDO.
    DEFINE OUTPUT PARAMETER pAmountOrdered AS DECIMAL                   NO-UNDO.

    DEFINE VARIABLE de-preco-unit  AS DECIMAL NO-UNDO.

    blockGetAmountDelayedOrder:
    DO  ON ERROR UNDO blockGetAmountDelayedOrder, LEAVE blockGetAmountDelayedOrder
        ON STOP  UNDO blockGetAmountDelayedOrder, LEAVE blockGetAmountDelayedOrder
        ON QUIT  UNDO blockGetAmountDelayedOrder, LEAVE blockGetAmountDelayedOrder:

        /* ParÆ’metros nÃ†o influenciam, passados apenas para rodar o programa persistente */
        RUN cdp/cd0812.p PERSISTENT SET h-cd0812(INPUT  0,
                                                 INPUT  0,
                                                 INPUT  0,
                                                 INPUT  01/01/0001,
                                                 OUTPUT de-preco-unit).
        {cdp/findpedidocompr.i pNrPedido}

        IF  AVAIL pedido-compr THEN DO:

            FOR EACH ordem-compra
                WHERE ordem-compra.num-pedido = pedido-compr.num-pedido
                AND   ordem-compra.situacao <> 4 NO-LOCK:

                /* Inicializa‡Æo variÂ vel */
                ASSIGN de-preco-unit  = 0.

                RUN pi-executa in h-cd0812 (INPUT  ordem-compra.mo-codigo,
                                            INPUT  0, /* moeda destino */
                                            INPUT  ordem-compra.preco-unit,
                                            INPUT  TODAY,
                                            OUTPUT de-preco-unit).
                IF  de-preco-unit = ? THEN
                    ASSIGN de-preco-unit = 0.

                FOR EACH prazo-compra
                    WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                      AND prazo-compra.situacao <> 4
                      AND prazo-compra.situacao <> 6 NO-LOCK:

                    IF  prazo-compra.quant-saldo > 0 THEN DO:
                            ASSIGN pAmountOrdered = pAmountOrdered + (prazo-compra.quant-saldo * de-preco-unit).

                        if prazo-compra.data-entrega < TODAY AND prazo-compra.situacao = 2 THEN
                            ASSIGN pAmountDelayed = pAmountDelayed + (prazo-compra.quant-saldo * de-preco-unit).
                    END.
                END.
            END.
        END.

        DELETE PROCEDURE h-cd0812.
        ASSIGN h-cd0812 = ?.
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLastPurchaseOfItem DBOProgram 
PROCEDURE getLastPurchaseOfItem :
/*--------------------------------------------------------------------------------------
  Purpose:    Busca dados da £ltima compra do item
  Parameters: purchaseRequisitionId (input) - N£mero da ordem de compra
              siteId (input) - C¢digo do estabelecimento
              cItem (input)  - C¢digo do item
              ttLastPurchaseOfItem (output) - Temp-table com os dados da £ltima compra
              RowErrors (output) - Temp-table de erros
  Notes:
---------------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER purchaseRequisitionId AS CHARACTER                  NO-UNDO.
    DEFINE INPUT  PARAMETER siteId                LIKE ordem-compra.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER cItem                 LIKE ordem-compra.it-codigo   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttLastPurchaseOfItem.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEF VAR c-cod-estabel LIKE ordem-compra.cod-estabel NO-UNDO.

    /*Se for passado o c¢digo de estabelecimento utiliza este, senÆo busca da ordem*/
    if siteId <> "" THEN DO:
      ASSIGN c-cod-estabel = siteId.
    END.
    ELSE DO: 
        FOR FIRST ordem-compra FIELDS(cod-estabel)
          WHERE ordem-compra.numero-ordem = INT(purchaseRequisitionId) NO-LOCK:
          ASSIGN c-cod-estabel = ordem-compra.cod-estabel.
        END.
        RELEASE ordem-compra.
    END.
    IF c-cod-estabel = "" THEN
      RETURN "NOK":U.
       
    FOR FIRST ITEM FIELDS(it-codigo desc-item data-ult-rep preco-repos un)
        WHERE ITEM.it-codigo = cItem NO-LOCK:

        IF NOT VALID-HANDLE(h-boun005)     OR
           h-boun005:TYPE <> "PROCEDURE":U OR
           h-boun005:FILE-NAME <> "unbo/boun005.p" THEN
           RUN unbo/boun005.p PERSISTENT SET h-boun005.

        CREATE ttLastPurchaseOfItem.
        ASSIGN ttLastPurchaseOfItem.itemId          = item.it-codigo
               ttLastPurchaseOfItem.itemDescription = item.desc-item
               ttLastPurchaseOfItem.currencyShorthand = fnCurrencyShorthand(0). /*Busca sigla da moeda 0, pois o pre‡o de reposi‡Æo sempre est  nessa moeda*/
    
        FOR FIRST item-uni-estab FIELDS(cod-estabel it-codigo data-ult-rep preco-repos &IF '{&bf_mat_versao_ems}' < '2.09' &THEN int-2 &ELSE num-ordem &ENDIF)
            WHERE item-uni-estab.cod-estabel = c-cod-estabel
              AND item-uni-estab.it-codigo   = ITEM.it-codigo NO-LOCK: END.
        IF AVAIL item-uni-estab THEN DO:
            ASSIGN ttLastPurchaseOfItem.purchaseDate    = item-uni-estab.data-ult-rep
                   ttLastPurchaseOfItem.price           = item-uni-estab.preco-repos.
            &IF '{&bf_mat_versao_ems}' < '2.09' &THEN
                ASSIGN ttLastPurchaseOfItem.purchaseRequisitionId = string(item-uni-estab.int-2).
            &ELSE
                ASSIGN ttLastPurchaseOfItem.purchaseRequisitionId = string(item-uni-estab.num-ordem).
            &ENDIF
            FOR FIRST ordem-compra FIELDS(numero-ordem cod-cond-pag cod-emitente)
                 WHERE ordem-compra.numero-ordem = INT(ttLastPurchaseOfItem.purchaseRequisitionId) NO-LOCK: END.
        END.
        ELSE DO:
          ASSIGN ttLastPurchaseOfItem.purchaseDate    = item.data-ult-rep
                 ttLastPurchaseOfItem.price           = item.preco-repos.
        END.
        IF AVAIL ordem-compra THEN DO:
            FOR FIRST prazo-compra fields(un) WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
                FOR FIRST tab-unidade WHERE tab-unidade.un = prazo-compra.un NO-LOCK:
                    ASSIGN ttLastPurchaseOfItem.unitOfMeasure            = tab-unidade.un
                           ttLastPurchaseOfItem.unitOfMeasureDescription = tab-unidade.descricao.
                END.
            END.
            FOR FIRST cond-pagto FIELDS(descricao) WHERE cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag NO-LOCK:
                ASSIGN ttLastPurchaseOfItem.paymentCondition      = cond-pagto.descricao.
            END.
            FOR FIRST emitente FIELDS(cod-emitente nome-emit natureza cgc) WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK:
                ASSIGN ttLastPurchaseOfItem.supplierId          = string(emitente.cod-emitente)
                       ttLastPurchaseOfItem.supplierDescription = emitente.nome-emit
                       ttLastPurchaseOfItem.supplierCNPJ        = fn-cgc(emitente.cod-emitente).
            END.
        END.
        ELSE DO:
            FOR FIRST tab-unidade WHERE tab-unidade.un = ITEM.un NO-LOCK:
                ASSIGN ttLastPurchaseOfItem.unitOfMeasure            = tab-unidade.un
                       ttLastPurchaseOfItem.unitOfMeasureDescription = tab-unidade.descricao.
            END.
        END.

        IF VALID-HANDLE(h-boun005) THEN DO:
           DELETE PROCEDURE h-boun005.
           ASSIGN h-boun005 = ?.
        end.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLastPurchaseOfItemVendor DBOProgram 
PROCEDURE getLastPurchaseOfItemVendor :
/*--------------------------------------------------------------------------------------
  Purpose:    Busca dados da £ltima compra do Item/Fornecedor
  Parameters: purchaseRequisitionId (input) - N£mero da ordem de compra
              siteId (input) - C¢digo do estabelecimento
              cItem (input)  - C¢digo do item
              unitOfMeasure (input) - C¢digo da unidade de medida
              vendorId (input) - C¢digo do fornecedor
              ttLastPurchaseOfItem (output) - Temp-table com os dados da £ltima compra
              RowErrors (output) - Temp-table de erros
  Notes:
---------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER purchaseRequisitionId AS CHARACTER                  NO-UNDO.
    DEFINE INPUT  PARAMETER siteId                LIKE ordem-compra.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER cItem                 LIKE ordem-compra.it-codigo   NO-UNDO.
    DEFINE INPUT  PARAMETER unitOfMeasure         AS CHARACTER                  NO-UNDO.
    DEFINE INPUT  PARAMETER vendorId              AS INTEGER                    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttLastPurchaseOfItem.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE c-cod-estabel LIKE ordem-compra.cod-estabel NO-UNDO.
    DEFINE VARIABLE r-rowid-cotacao AS ROWID NO-UNDO.
    DEFINE VARIABLE r-rowid-ordem   AS ROWID NO-UNDO.

    /*Se for passado o c¢digo de estabelecimento utiliza este, senÆo busca da ordem*/
    if siteId <> "" THEN DO:
      assign c-cod-estabel = siteId.
    END.
    ELSE DO: 
        FOR FIRST ordem-compra FIELDS(cod-estabel)
          WHERE ordem-compra.numero-ordem = INT(purchaseRequisitionId) NO-LOCK:
          ASSIGN c-cod-estabel = ordem-compra.cod-estabel.
        END.
    END.
    
    IF vendorId = 0 THEN DO:
        /*Se nÆo for informado o fornecedor ir  buscar pre‡o de reposi‡Æo do item*/
        RUN getLastPurchaseOfItem (INPUT purchaseRequisitionId,
                                   INPUT siteId,
                                   INPUT cItem,
                                   OUTPUT TABLE ttLastPurchaseOfItem,
                                   OUTPUT TABLE RowErrors).
    END.
    ELSE DO: 
        FOR FIRST ITEM FIELDS(it-codigo desc-item un)
             WHERE ITEM.it-codigo = cItem NO-LOCK:
                   
            /*Procura a £ltima cota‡Æo do item/fornecedor na unidade informada*/
            FIND LAST cotacao-item NO-LOCK
               WHERE cotacao-item.it-codigo = cItem
                 AND cotacao-item.cod-emitente = vendorId
                 AND cotacao-item.un = unitOfMeasure
                 AND cotacao-item.cot-aprovada NO-ERROR.
                        REPEAT:
                                IF NOT AVAIL cotacao-item THEN LEAVE.
                                FOR FIRST ordem-compra fields(numero-ordem) NO-LOCK
                                        WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem
                                          AND ordem-compra.cod-estabel = c-cod-estabel
                                          and ordem-compra.natureza = 1 /*Compra*/
                                          and ordem-compra.num-pedido <> 0: END.
                                IF AVAIL ordem-compra THEN DO:
                                        ASSIGN r-rowid-cotacao = ROWID(cotacao-item)
                                                   r-rowid-ordem   = ROWID(ordem-compra).
                                        LEAVE.
                                END.
                                ELSE DO:
                                        FIND PREV cotacao-item 
                                                WHERE cotacao-item.it-codigo = cItem
                                                  AND cotacao-item.cod-emitente = vendorId
                                                  AND cotacao-item.un = unitOfMeasure
                                                  AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.
                                END.
                        END.
            
            IF r-rowid-cotacao = ? THEN DO:
                /*Procura a £ltima cota‡Æo do item/fornecedor na unidade do item*/
                FIND LAST cotacao-item NO-LOCK
                   WHERE cotacao-item.it-codigo = cItem
                     AND cotacao-item.cod-emitente = vendorId
                     AND cotacao-item.un = ITEM.un
                     AND cotacao-item.cot-aprovada NO-ERROR.
                                REPEAT:
                                        IF NOT AVAIL cotacao-item THEN LEAVE.
                                        FOR FIRST ordem-compra fields(numero-ordem) NO-LOCK
                                                WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem
                                                  AND ordem-compra.cod-estabel = c-cod-estabel
                                                  and ordem-compra.natureza = 1 /*Compra*/
                                                  and ordem-compra.num-pedido <> 0: END.
                                        IF AVAIL ordem-compra THEN DO:
                                                ASSIGN r-rowid-cotacao = ROWID(cotacao-item)
                                                           r-rowid-ordem   = ROWID(ordem-compra).
                                                LEAVE.
                                        END.
                                        ELSE DO:
                                                FIND PREV cotacao-item 
                                                        WHERE cotacao-item.it-codigo = cItem
                                                          AND cotacao-item.cod-emitente = vendorId
                                                          AND cotacao-item.un = ITEM.un
                                                          AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.
                                        END.
                                END.
            END.
            IF r-rowid-cotacao = ? THEN DO:
                /*Procura a £ltima cota‡Æo do item/fornecedor em qualquer unidade*/
                FIND LAST cotacao-item NO-LOCK
                   WHERE cotacao-item.it-codigo = cItem
                     AND cotacao-item.cod-emitente = vendorId
                     AND cotacao-item.cot-aprovada NO-ERROR.
                REPEAT:
                    IF NOT AVAIL cotacao-item THEN LEAVE.
                    FOR FIRST ordem-compra fields(numero-ordem) NO-LOCK
                        WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem
                          AND ordem-compra.cod-estabel = c-cod-estabel
                          and ordem-compra.natureza = 1 /*Compra*/
                          and ordem-compra.num-pedido <> 0: END.
                    IF AVAIL ordem-compra THEN DO:
                        ASSIGN r-rowid-cotacao = ROWID(cotacao-item)
                               r-rowid-ordem   = ROWID(ordem-compra).
                        LEAVE.
                    END.
                    ELSE DO:
                        FIND PREV cotacao-item 
                            WHERE cotacao-item.it-codigo = cItem
                              AND cotacao-item.cod-emitente = vendorId
                              AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.
                    END.
                END.
            END.
    
            IF r-rowid-cotacao = ? THEN DO:
                /*Se nÆo for encontrada cotacao para o item/fornecedor ir  buscar o pre‡o de reposi‡Æo do item*/
                RUN getLastPurchaseOfItem (INPUT purchaseRequisitionId,
                                           INPUT siteId,
                                           INPUT cItem,
                                           OUTPUT TABLE ttLastPurchaseOfItem,
                                           OUTPUT TABLE RowErrors).
            END.
            ELSE DO:
                if not valid-handle(h-boun005) or
                    h-boun005:type <> "PROCEDURE":U or
                    h-boun005:file-name <> "unbo/boun005.p" then
                    RUN unbo/boun005.p PERSISTENT SET h-boun005.

                FOR FIRST cotacao-item FIELDS(numero-ordem data-cotacao preco-fornec un)
                    WHERE rowid(cotacao-item) = r-rowid-cotacao NO-LOCK: END.

                FOR FIRST ordem-compra FIELDS(numero-ordem cod-cond-pag cod-emitente mo-codigo)
                    WHERE rowid(ordem-compra) = r-rowid-ordem NO-LOCK: END.

                CREATE ttLastPurchaseOfItem.
                ASSIGN ttLastPurchaseOfItem.itemId          = ITEM.it-codigo
                       ttLastPurchaseOfItem.itemDescription = item.desc-item
                       ttLastPurchaseOfItem.purchaseDate    = cotacao-item.data-cotacao
                       ttLastPurchaseOfItem.price           = cotacao-item.preco-fornec
                       ttLastPurchaseOfItem.purchaseRequisitionId = string(cotacao-item.numero-ordem).

                FOR FIRST tab-unidade WHERE tab-unidade.un = cotacao-item.un NO-LOCK:
                    ASSIGN ttLastPurchaseOfItem.unitOfMeasure            = tab-unidade.un
                           ttLastPurchaseOfItem.unitOfMeasureDescription = tab-unidade.descricao.
                END.
                IF AVAIL ordem-compra THEN DO:
                    FOR FIRST cond-pagto FIELDS(descricao) WHERE cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag NO-LOCK:
                      ASSIGN ttLastPurchaseOfItem.paymentCondition      = cond-pagto.descricao.
                    END.
                    FOR FIRST emitente FIELDS(cod-emitente nome-emit natureza cgc) WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK:
                      ASSIGN ttLastPurchaseOfItem.supplierId          = string(emitente.cod-emitente)
                             ttLastPurchaseOfItem.supplierDescription = emitente.nome-emit
                             ttLastPurchaseOfItem.supplierCNPJ        = fn-cgc(emitente.cod-emitente).
                    END.
                    /*Busca sigla da moeda da ordem de compra*/
                    ASSIGN ttLastPurchaseOfItem.currencyShorthand = fnCurrencyShorthand(ordem-compra.mo-codigo). 
                END.
                
                if valid-handle(h-boun005) then do:
                   delete procedure h-boun005.
                   assign h-boun005 = ?.
                end. 

            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNumLastPurchaseOfItem DBOProgram 
PROCEDURE getNumLastPurchaseOfItem :
/*--------------------------------------------------------------------------------------
  Purpose:    Busca dados da £ltima compra do Item
  Parameters: pc-ordem-compra (input char)  - N£mero da ordem de compra
              pc-cod-estabel (input char)   - C¢digo do estabelecimento
              pc-it-codigo (input char)     - C¢digo do item
              ttLastPurchaseOfItemAux (output) - Temp-table com os dados da £ltima compra
              RowErrors (output)            - Temp-table de erros
  Notes:
---------------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pc-ordem-compra AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-estabel  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo    AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttLastPurchaseOfItemAux.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE c-cod-estabel   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-msg-erro      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-it-codigo     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-cont          AS INTEGER   NO-UNDO.
    DEFINE VARIABLE qh-cotacao-item AS HANDLE    NO-UNDO.
    DEFINE VARIABLE bh-cotacao-item AS HANDLE    NO-UNDO.

    EMPTY TEMP-TABLE ttLastPurchaseOfItemAux.

    IF NOT AVAIL param-compra THEN
        FOR FIRST param-compra FIELDS(num-ult-compra) NO-LOCK: END.

    ASSIGN c-cod-estabel = trim(pc-cod-estabel)
           c-it-codigo   = trim(pc-it-codigo).

    FOR FIRST ordem-compra WHERE ordem-compra.numero-ordem = INT(pc-ordem-compra) NO-LOCK:
        ASSIGN inum-pedido   = ordem-compra.num-pedido.
    END.
    
    /*Se for passado o c¢digo de estabelecimento ou item utiliza este, senÆo busca da ordem*/
    IF c-cod-estabel = "" OR c-it-codigo = "" THEN DO:
        INT(pc-ordem-compra) NO-ERROR.
        
        /*Caso aconteca erro na conversao para inteiro acontecera erro progress 76 = Invalid character in numeric input a. (76) */
        IF ERROR-STATUS:GET-NUMBER(1) = 76 THEN DO:
            {utp/ut-liter.i Ordem_de_Compra}
            ASSIGN c-msg-erro = RETURN-VALUE.
            {utp/ut-liter.i "Apenas_n£meros_sÆo_valores_v lidos_para_o_campo,_e_o_valor_recebido_foi: "}
            ASSIGN c-msg-erro = c-msg-erro + '~~' + RETURN-VALUE + pc-ordem-compra.

            {method/svc/errors/inserr.i
                          &ErrorNumber="55900"
                          &ErrorType="EMS"
                          &ErrorParameters="c-msg-erro"}
            
            RETURN "NOK":U.
        END.
    
        FOR FIRST ordem-compra FIELDS(cod-estabel it-codigo)
           WHERE ordem-compra.numero-ordem = INT(pc-ordem-compra) NO-LOCK:
            
            ASSIGN c-cod-estabel = ordem-compra.cod-estabel WHEN pc-cod-estabel = ""
                   c-it-codigo   = ordem-compra.it-codigo   WHEN pc-it-codigo   = ""
                   inum-pedido   = ordem-compra.num-pedido.
            
        END.
    END.
    
    IF NOT VALID-HANDLE(h-boun005) THEN
       RUN unbo/boun005.p PERSISTENT SET h-boun005.

    FOR FIRST item FIELDS(it-codigo desc-item data-ult-rep preco-repos un)
        WHERE item.it-codigo = c-it-codigo NO-LOCK:

        CREATE BUFFER bh-cotacao-item FOR TABLE "cotacao-item":U.
        CREATE QUERY qh-cotacao-item.
        qh-cotacao-item:SET-BUFFERS(bh-cotacao-item).
        qh-cotacao-item:QUERY-PREPARE( "FOR EACH cotacao-item NO-LOCK WHERE cotacao-item.it-codigo = " + "'" + c-it-codigo + "'"
                                     + "AND cotacao-item.data-cotacao <> ? "
                                     + "AND cotacao-item.numero-ordem <> 0 "
                                     + "AND cotacao-item.cot-aprovada "
                                     + "BY cotacao-item.data-cotacao DESCENDING").


        DO i-cont = 1 TO param-compra.num-ult-compra:
            CREATE ttLastPurchaseOfItemAux.
            ASSIGN ttLastPurchaseOfItemAux.itemId            = item.it-codigo
                   ttLastPurchaseOfItemAux.itemDescription   = item.desc-item
                   ttLastPurchaseOfItemAux.currencyCode      = 0
                   ttLastPurchaseOfItemAux.currencyShorthand = fnCurrencyShorthand(0). /*Busca sigla da moeda 0, pois o pre‡o de reposi‡Æo sempre est  nessa moeda*/

            /*Primeiro busca da ultima compra, depois das ordens*/
            IF i-cont = 1 THEN DO:
                IF  c-cod-estabel = "" THEN DO:
                    /* Est  usando for each com leave, pois o for first apresentou diferentes registros entre a execu‡Æo progress e execu‡Æo HTML */
                    FOR EACH item-uni-estab FIELDS(cod-estabel it-codigo data-ult-rep preco-repos &IF '{&bf_mat_versao_ems}' < '2.09' &THEN int-2 &ELSE num-ordem &ENDIF)
                        WHERE item-uni-estab.it-codigo = item.it-codigo NO-LOCK: 
                        LEAVE.
                    END.
                END.
                ELSE DO:
                    /* Est  usando for each com leave, pois o for first apresentou diferentes registros entre a execu‡Æo progress e execu‡Æo HTML */
                    FOR FIRST item-uni-estab FIELDS(cod-estabel it-codigo data-ult-rep preco-repos &IF '{&bf_mat_versao_ems}' < '2.09' &THEN int-2 &ELSE num-ordem &ENDIF)
                        WHERE item-uni-estab.cod-estabel = c-cod-estabel
                        AND item-uni-estab.it-codigo   = item.it-codigo NO-LOCK: 
                    END.
                END.

                IF AVAIL item-uni-estab THEN DO:
                    ASSIGN ttLastPurchaseOfItemAux.purchaseDate    = item-uni-estab.data-ult-rep
                           ttLastPurchaseOfItemAux.price           = item-uni-estab.preco-repos.
                    
                    &IF '{&bf_mat_versao_ems}' < '2.09' &THEN
                        ASSIGN ttLastPurchaseOfItemAux.purchaseRequisitionId = string(item-uni-estab.int-2).
                    &ELSE
                        ASSIGN ttLastPurchaseOfItemAux.purchaseRequisitionId = string(item-uni-estab.num-ordem).
                    &ENDIF
                    
                    FOR FIRST ordem-compra FIELDS(numero-ordem num-pedido cod-cond-pag cod-emitente)
                         WHERE ordem-compra.numero-ordem = INT(ttLastPurchaseOfItemAux.purchaseRequisitionId) NO-LOCK: END.
						 
						     IF AVAIL ordem-compra
								AND inum-pedido > 0
								AND ordem-compra.num-pedido = inum-pedido THEN DO:
									ASSIGN ttLastPurchaseOfItemAux.purchaseRequisitionId = ""
										   ttLastPurchaseOfItemAux.purchaseDate          = ?
										   ttLastPurchaseOfItemAux.price                 = 0
										   ttLastPurchaseOfItemAux.currencyCode          = 0
										   ttLastPurchaseOfItemAux.currencyShorthand     = fnCurrencyShorthand(0).
									
									RELEASE ordem-compra.
								END.
                END.
                ELSE DO:
                  ASSIGN ttLastPurchaseOfItemAux.purchaseDate    = item.data-ult-rep
                         ttLastPurchaseOfItemAux.price           = item.preco-repos.
                END.
            END.

            IF i-cont > 1 OR ttLastPurchaseOfItemAux.price = 0 THEN DO:
                
                IF NOT qh-cotacao-item:IS-OPEN THEN
                    qh-cotacao-item:QUERY-OPEN().

                REPEAT WHILE NOT AVAIL ordem-compra AND NOT qh-cotacao-item:QUERY-OFF-END:
                    
                    qh-cotacao-item:GET-NEXT(NO-LOCK).
                    IF qh-cotacao-item:QUERY-OFF-END THEN NEXT. /*Para quando nao tem nenhum registro na query*/

                    FIND FIRST bttLastPurchaseOfItemAux NO-LOCK
                        WHERE bttLastPurchaseOfItemAux.purchaseRequisitionId = bh-cotacao-item:BUFFER-FIELD("numero-ordem":U):BUFFER-VALUE NO-ERROR.
                    IF  AVAIL bttLastPurchaseOfItemAux THEN NEXT.

                    FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = int(pc-ordem-compra) NO-LOCK NO-ERROR.
                    IF AVAIL ordem-compra THEN DO:
                        FIND FIRST pedido-compr WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.
                        IF AVAIL pedido-compr THEN
                            ASSIGN inum-pedido = pedido-compr.num-pedido.
                    END.

                            FOR FIRST ordem-compra
                                 WHERE ordem-compra.numero-ordem = bh-cotacao-item:BUFFER-FIELD("numero-ordem":U):BUFFER-VALUE
                                   AND (IF c-cod-estabel = "" THEN ordem-compra.cod-estabel <> c-cod-estabel ELSE ordem-compra.cod-estabel = c-cod-estabel)
                                   AND ordem-compra.natureza     =  1 /*Compra*/ 
                                   AND ordem-compra.num-pedido   <> 0
                                   AND ordem-compra.num-pedido   <> inum-pedido NO-LOCK :
                                   
                                ASSIGN ttLastPurchaseOfItemAux.purchaseRequisitionId = string(ordem-compra.numero-ordem)
                                       ttLastPurchaseOfItemAux.purchaseDate          = bh-cotacao-item:BUFFER-FIELD("data-cotacao":U):BUFFER-VALUE
                                       ttLastPurchaseOfItemAux.price                 = bh-cotacao-item:BUFFER-FIELD("preco-unit":U):BUFFER-VALUE
                                       ttLastPurchaseOfItemAux.currencyCode          = bh-cotacao-item:BUFFER-FIELD("mo-codigo":U):BUFFER-VALUE
                                       ttLastPurchaseOfItemAux.currencyShorthand     = fnCurrencyShorthand(ttLastPurchaseOfItemAux.currencyCode).
                            END.
                        
                    
                END.
            END.
            
            IF AVAIL ordem-compra THEN DO:
                FOR FIRST prazo-compra fields(un) WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
                    FOR FIRST tab-unidade WHERE tab-unidade.un = prazo-compra.un NO-LOCK:
                        ASSIGN ttLastPurchaseOfItemAux.unitOfMeasure            = tab-unidade.un
                               ttLastPurchaseOfItemAux.unitOfMeasureDescription = tab-unidade.descricao.
                    END.
                END.
                FOR FIRST cond-pagto fields(descricao) WHERE cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag NO-LOCK:
                    ASSIGN ttLastPurchaseOfItemAux.paymentCondition      = cond-pagto.descricao.
                END.
                FOR FIRST emitente fields(cod-emitente nome-emit natureza cgc) WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK:
                    ASSIGN ttLastPurchaseOfItemAux.supplierId          = string(emitente.cod-emitente)
                           ttLastPurchaseOfItemAux.supplierDescription = emitente.nome-emit
                           ttLastPurchaseOfItemAux.supplierCNPJ        = fn-cgc(emitente.cod-emitente).
                END.
            END.
            ELSE DO:
                FOR FIRST tab-unidade WHERE tab-unidade.un = item.un NO-LOCK:
                    ASSIGN ttLastPurchaseOfItemAux.unitOfMeasure            = tab-unidade.un
                           ttLastPurchaseOfItemAux.unitOfMeasureDescription = tab-unidade.descricao.
                END.
            END.

            IF inum-pedido > 0 THEN
                FOR EACH ordem-compra WHERE ordem-compra.num-pedido = inum-pedido NO-LOCK:
                    IF AVAIL ttLastPurchaseOfItemAux THEN
                        IF int(ttLastPurchaseOfItemAux.purchaseRequisitionId) = ordem-compra.numero-ordem THEN DO:
                            DELETE ttLastPurchaseOfItemAux.
                            LEAVE.
                        END.
                END.

            RELEASE ordem-compra.
            IF AVAIL ttLastPurchaseOfItemAux THEN
                IF ttLastPurchaseOfItemAux.price = 0 THEN DO:
                    DELETE ttLastPurchaseOfItemAux.
                    LEAVE.
                END.
        END.
    END.

    IF VALID-HANDLE(qh-cotacao-item) AND qh-cotacao-item:IS-OPEN THEN DO:
        qh-cotacao-item:QUERY-CLOSE().
        DELETE OBJECT qh-cotacao-item  NO-ERROR.
    END.

    IF VALID-HANDLE(bh-cotacao-item) THEN DELETE OBJECT bh-cotacao-item NO-ERROR.

    IF VALID-HANDLE(h-boun005) THEN DO:
       DELETE PROCEDURE h-boun005.
       ASSIGN h-boun005 = ?.
    END.

    IF NOT AVAIL ITEM THEN DO:
        {method/svc/errors/inserr.i
                  &ErrorNumber="90"
                  &ErrorType="EMS"
                  &ErrorParameters="c-it-codigo"}
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNumLastPurchaseOfItemVendor DBOProgram 
PROCEDURE getNumLastPurchaseOfItemVendor :
/*--------------------------------------------------------------------------------------
  Purpose:    Busca dados do N£mero de £ltimas compras do Fornecedor de acordo com o 
              parƒmetro "N£mero de éltimas Compras" dos Parƒmetros de Compras (CC0104)
  Parameters: purchaseRequisitionId (input) - N£mero da ordem de compra
              cItem (input)  - C¢digo do item
              unitOfMeasure (input) - C¢digo da unidade de medida
              vendorId (input) - C¢digo do fornecedor
              ttNumLastPurchaseOfItem (output) - Temp-table com os dados da £ltima compra
              RowErrors (output) - Temp-table de erros
  Notes:
---------------------------------------------------------------------------------------*/
    DEF INPUT  PARAMETER purchaseRequisitionId AS   CHARACTER              NO-UNDO.
    DEF INPUT  PARAMETER cItem                 LIKE ordem-compra.it-codigo NO-UNDO.
    DEF INPUT  PARAMETER unitOfMeasure         AS   CHARACTER              NO-UNDO.
    DEF INPUT  PARAMETER vendorId              AS   INTEGER                NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR ttNumLastPurchaseOfItem.
    DEF OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE c-cod-estabel   LIKE ordem-compra.cod-estabel NO-UNDO.
    DEFINE VARIABLE r-rowid-cotacao AS ROWID                      NO-UNDO.
    DEFINE VARIABLE r-rowid-ordem   AS ROWID                      NO-UNDO.
    DEFINE VARIABLE qh-cotacao-item AS HANDLE                     NO-UNDO.
    DEFINE VARIABLE bh-cotacao-item AS HANDLE                     NO-UNDO.
    DEFINE VARIABLE bh-ordem-compra AS HANDLE                     NO-UNDO.

    EMPTY TEMP-TABLE ttNumLastPurchaseOfItem.
    
    IF NOT AVAIL param-compra THEN
        FOR FIRST param-compra FIELDS(num-ult-compra) NO-LOCK: END.

    ASSIGN c-cod-estabel = "":U.
    FOR FIRST ordem-compra FIELDS(cod-estabel)
        WHERE ordem-compra.numero-ordem = INT(purchaseRequisitionId) NO-LOCK:
        FIND FIRST pedido-compr WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.
        IF AVAIL pedido-compr THEN DO:
            ASSIGN inum-pedido = pedido-compr.num-pedido.
        END.

      ASSIGN c-cod-estabel = ordem-compra.cod-estabel.
    END.

    IF NOT VALID-HANDLE(h-boun005) 
    OR h-boun005:TYPE      <> "PROCEDURE":U 
    OR h-boun005:FILE-NAME <> "unbo/boun005.p" THEN
        RUN unbo/boun005.p PERSISTENT SET h-boun005.
    
    FOR FIRST item FIELDS(it-codigo desc-item un)
        WHERE item.it-codigo = cItem NO-LOCK:

        ASSIGN icont = 1.

        CREATE BUFFER bh-cotacao-item FOR TABLE "cotacao-item":U.
        CREATE BUFFER bh-ordem-compra FOR TABLE "ordem-compra":U.
        CREATE QUERY qh-cotacao-item.
        qh-cotacao-item:SET-BUFFERS(bh-cotacao-item, bh-ordem-compra).

        IF c-cod-estabel = "":U THEN
            qh-cotacao-item:QUERY-PREPARE("FOR EACH cotacao-item NO-LOCK WHERE cotacao-item.cod-emitente = " + STRING(vendorId) 
                                          + " AND cotacao-item.it-codigo = " + QUOTER(cItem)
                                          + " AND cotacao-item.un = " + QUOTER(unitOfMeasure)
                                          + " AND cotacao-item.cot-aprovada, "
                                          + " FIRST ordem-compra FIELDS(numero-ordem cod-cond-pag cod-emitente mo-codigo) NO-LOCK "
                                          + " WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem "
                                          + " AND ordem-compra.natureza = 1 "
                                          + " AND ordem-compra.num-pedido <> 0 "
                                          + " AND ordem-compra.num-pedido <> " + quoter(inum-pedido)
                                          + " BY cotacao-item.data-cotacao DESCENDING ").
        ELSE
            qh-cotacao-item:QUERY-PREPARE("FOR EACH cotacao-item NO-LOCK WHERE cotacao-item.cod-emitente = " + STRING(vendorId) 
                                          + " AND cotacao-item.it-codigo = " + QUOTER(cItem)
                                          + " AND cotacao-item.un = " + QUOTER(unitOfMeasure)
                                          + " AND cotacao-item.cot-aprovada, "
                                          + " FIRST ordem-compra FIELDS(numero-ordem cod-cond-pag cod-emitente mo-codigo) NO-LOCK "
                                          + " WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem "
                                          + " AND ordem-compra.cod-estabel = " + QUOTER(c-cod-estabel) 
                                          + " AND ordem-compra.natureza = 1 "
                                          + " AND ordem-compra.num-pedido <> 0 "
                                          + " AND ordem-compra.num-pedido <> " + quoter(inum-pedido)
                                          + " BY cotacao-item.data-cotacao DESCENDING ").

        IF NOT qh-cotacao-item:IS-OPEN THEN
	        qh-cotacao-item:QUERY-OPEN().

        REPEAT WHILE param-compra.num-ult-compra >= icont AND NOT qh-cotacao-item:QUERY-OFF-END:

            qh-cotacao-item:GET-NEXT(NO-LOCK).
            IF qh-cotacao-item:QUERY-OFF-END THEN NEXT. /*Para quando nao tem nenhum registro na query*/
                
            RUN createNumLastPurchaseOfItem IN THIS-PROCEDURE (INPUT bh-cotacao-item, INPUT bh-ordem-compra). 
            
        END.

        IF VALID-HANDLE(qh-cotacao-item) AND qh-cotacao-item:IS-OPEN THEN
            qh-cotacao-item:QUERY-CLOSE().

        IF  icont         <= param-compra.num-ult-compra 
        AND unitOfMeasure <> item.un THEN DO:

            /*Procura a £ltima cota‡Æo do item/fornecedor na unidade do item*/
            IF c-cod-estabel = "":U THEN
                qh-cotacao-item:QUERY-PREPARE("FOR EACH cotacao-item NO-LOCK WHERE cotacao-item.cod-emitente = " + STRING(vendorId) 
                                              + " AND cotacao-item.it-codigo = " + QUOTER(cItem)
                                              + " AND cotacao-item.un = " + QUOTER(item.un)
                                              + " AND cotacao-item.cot-aprovada, "
                                              + " FIRST ordem-compra FIELDS(numero-ordem cod-cond-pag cod-emitente mo-codigo) NO-LOCK "
                                              + " WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem "
                                              + " AND ordem-compra.natureza = 1 "
                                              + " AND ordem-compra.num-pedido <> 0 "
                                              + " AND ordem-compra.num-pedido <> " + quoter(inum-pedido)
                                              + " BY cotacao-item.data-cotacao DESCENDING ").
            ELSE
                qh-cotacao-item:QUERY-PREPARE("FOR EACH cotacao-item NO-LOCK WHERE cotacao-item.cod-emitente = " + STRING(vendorId) 
                                              + " AND cotacao-item.it-codigo = " + QUOTER(cItem)
                                              + " AND cotacao-item.un = " + QUOTER(item.un)
                                              + " AND cotacao-item.cot-aprovada, "
                                              + " FIRST ordem-compra FIELDS(numero-ordem cod-cond-pag cod-emitente mo-codigo) NO-LOCK "
                                              + " WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem "
                                              + " AND ordem-compra.cod-estabel = " + QUOTER(c-cod-estabel) 
                                              + " AND ordem-compra.natureza = 1 "
                                              + " AND ordem-compra.num-pedido <> 0 "
                                              + " AND ordem-compra.num-pedido <> " + quoter(inum-pedido)
                                              + " BY cotacao-item.data-cotacao DESCENDING ").

            IF NOT qh-cotacao-item:IS-OPEN THEN
	            qh-cotacao-item:QUERY-OPEN().

            REPEAT WHILE param-compra.num-ult-compra >= icont AND NOT qh-cotacao-item:QUERY-OFF-END:
                
                qh-cotacao-item:GET-NEXT(NO-LOCK).
                IF qh-cotacao-item:QUERY-OFF-END THEN NEXT. /*Para quando nao tem nenhum registro na query*/
                
                
                RUN createNumLastPurchaseOfItem IN THIS-PROCEDURE (INPUT bh-cotacao-item, INPUT bh-ordem-compra).
                
            END.
        END.

        IF VALID-HANDLE(qh-cotacao-item) AND qh-cotacao-item:IS-OPEN THEN
            qh-cotacao-item:QUERY-CLOSE().

        IF icont <= param-compra.num-ult-compra THEN DO:

            /*Procura a £ltima cota‡Æo do item/fornecedor em qualquer unidade*/
            IF c-cod-estabel = "":U THEN
                qh-cotacao-item:QUERY-PREPARE("FOR EACH cotacao-item NO-LOCK WHERE cotacao-item.cod-emitente = " + STRING(vendorId) 
                                              + " AND cotacao-item.it-codigo = " + QUOTER(cItem)
                                              + " AND cotacao-item.cot-aprovada, "
                                              + " FIRST ordem-compra FIELDS(numero-ordem cod-cond-pag cod-emitente mo-codigo) NO-LOCK "
                                              + " WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem "
                                              + " AND ordem-compra.natureza = 1 "
                                              + " AND ordem-compra.num-pedido <> 0 "
                                              + " AND ordem-compra.num-pedido <> " + quoter(inum-pedido)
                                              + " BY cotacao-item.data-cotacao DESCENDING ").
            ELSE
                qh-cotacao-item:QUERY-PREPARE("FOR EACH cotacao-item NO-LOCK WHERE cotacao-item.cod-emitente = " + STRING(vendorId) 
                                              + " AND cotacao-item.it-codigo = " + QUOTER(cItem)
                                              + " AND cotacao-item.cot-aprovada, "
                                              + " FIRST ordem-compra FIELDS(numero-ordem cod-cond-pag cod-emitente mo-codigo) NO-LOCK "
                                              + " WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem "
                                              + " AND ordem-compra.cod-estabel = " + QUOTER(c-cod-estabel) 
                                              + " AND ordem-compra.natureza = 1 "
                                              + " AND ordem-compra.num-pedido <> 0 "
                                              + " AND ordem-compra.num-pedido <> " + quoter(inum-pedido)
                                              + " BY cotacao-item.data-cotacao DESCENDING ").

            IF NOT qh-cotacao-item:IS-OPEN THEN
	            qh-cotacao-item:QUERY-OPEN().

            REPEAT WHILE param-compra.num-ult-compra >= icont AND NOT qh-cotacao-item:QUERY-OFF-END:
                
                qh-cotacao-item:GET-NEXT(NO-LOCK).
                IF qh-cotacao-item:QUERY-OFF-END THEN NEXT. /*Para quando nao tem nenhum registro na query*/

                RUN createNumLastPurchaseOfItem IN THIS-PROCEDURE (INPUT bh-cotacao-item, INPUT bh-ordem-compra).
                
            END.
        END.
        IF VALID-HANDLE(qh-cotacao-item) AND qh-cotacao-item:IS-OPEN THEN
            qh-cotacao-item:QUERY-CLOSE().
    END.

    IF VALID-HANDLE(qh-cotacao-item) THEN DELETE OBJECT qh-cotacao-item NO-ERROR.
    IF VALID-HANDLE(bh-cotacao-item) THEN DELETE OBJECT bh-cotacao-item NO-ERROR.
    IF VALID-HANDLE(bh-ordem-compra) THEN DELETE OBJECT bh-ordem-compra NO-ERROR.

    IF VALID-HANDLE(h-boun005) THEN DO:
       DELETE PROCEDURE h-boun005.
       ASSIGN h-boun005 = ?.
    END. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPackageQuotationReport DBOProgram 
PROCEDURE getPackageQuotationReport :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER packageId AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttPackageQuotationReport.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    DEFINE VARIABLE c-comp-ender AS CHAR NO-UNDO.

    FOR FIRST ordem-compra WHERE ordem-compra.nr-processo = INT(packageid) NO-LOCK:
        
        FOR FIRST empresa FIELDS(e-mail telefone[1] nome endereco)
            WHERE empresa.ep-codigo =  ordem-compra.ep-codigo NO-LOCK:
            
            IF c-nom-prog-upc-mg97 <> "" THEN DO:
                
                FOR EACH tt-epc
                   WHERE tt-epc.cod-event = "getPackageQuotationReport":U:
                   DELETE tt-epc.
                END.
        
                {include/i-epc200.i2 &CodEvent='"getPackageQuotationReport"'
                                                         &CodParameter='"Rowid-empresa"'
                                                         &ValueParameter="string(rowid(empresa))"}
                                                                
                {include/i-epc201.i "getPackageQuotationReport"}
        
                FOR FIRST tt-epc
                        WHERE tt-epc.cod-event     = "getPackageQuotationReport"
                        AND   tt-epc.cod-parameter = "RetornoUPC" NO-LOCK:
                        
                        ASSIGN c-comp-ender = tt-epc.val-parameter.
                END.
            END.                             
            
            CREATE ttPackageQuotationReport.
            ASSIGN ttPackageQuotationReport.companyEmail   = empresa.e-mail
                   ttPackageQuotationReport.companyPhone   = empresa.telefone[1]
                   ttPackageQuotationReport.companyName    = empresa.nome
                   ttPackageQuotationReport.companyAddress = empresa.endereco
                   ttPackageQuotationReport.packageNumber  = packageid
                   ttPackageQuotationReport.epcValue       = c-comp-ender.
    
            /*FOR FIRST proc-fornec
                    WHERE proc-fornec.nr-processo = INT(packageId) NO-LOCK:
                    assign ttPackageQuotationReport.pacageDescription = proc-fornec.desc.
            END.*/
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPackageQuotationReportRequests DBOProgram 
PROCEDURE getPackageQuotationReportRequests :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER packageid AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttPackageQuotationReportRequest.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    for each ordem-compra where ordem-compra.nr-processo = INT(packageid) no-lock:
        
        RUN getQuotationReport (INPUT STRING(ordem-compra.numero-ordem),
                                OUTPUT TABLE ttQuotationReport,
                                OUTPUT TABLE RowErrors).

        FOR EACH ttQuotationReport:

            IF CAN-FIND (FIRST ttPackageQuotationReportRequest
                    WHERE ttPackageQuotationReportRequest.purchaseRequisition = ttQuotationReport.purchaseRequisition) THEN NEXT.

            CREATE ttPackageQuotationReportRequest.
            ASSIGN ttPackageQuotationReportRequest.supplierItemDescription         = ttQuotationReport.supplierItemDescription
                   ttPackageQuotationReportRequest.itemType                        = ttQuotationReport.itemType
                   ttPackageQuotationReportRequest.itemDate                        = ttQuotationReport.itemDate
                   ttPackageQuotationReportRequest.purchaseRequisitionDescription  = ttQuotationReport.purchaseRequisitionDescription
                   ttPackageQuotationReportRequest.purchaseRequisitionDate         = ttQuotationReport.purchaseRequisitionDate
                   ttPackageQuotationReportRequest.itemDescription                 = ttQuotationReport.itemDescription
                   ttPackageQuotationReportRequest.itemId                          = ttQuotationReport.itemId
                   ttPackageQuotationReportRequest.itemUnitOfMeasure               = ttQuotationReport.itemUnitOfMeasure
                   ttPackageQuotationReportRequest.itemQuantity                    = ttQuotationReport.itemQuantity
                   ttPackageQuotationReportRequest.purchaseRequisition             = ttQuotationReport.purchaseRequisition.


        END.
    END.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPackageVendorContacts DBOProgram 
PROCEDURE getPackageVendorContacts :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER packageId AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttPackageVendorContact.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.


    IF NOT AVAIL param-compra THEN
        FIND FIRST param-compra NO-LOCK NO-ERROR.

    RUN ccp/ccapi344.p (OUTPUT TABLE tt-empresa-usuario-logado).
    FIND FIRST tt-empresa-usuario-logado NO-LOCK NO-ERROR.

        FOR EACH proc-fornec
           WHERE proc-fornec.nr-processo = INT(packageId) NO-LOCK:

            FOR FIRST emitente /*fornecedor*/ WHERE emitente.cod-emitente = proc-fornec.cod-emitente NO-LOCK:
                CREATE ttPackageVendorContact.
                ASSIGN ttPackageVendorContact.vendorId          = STRING(emitente.cod-emitente)
                       ttPackageVendorContact.shortName         = emitente.nome-abrev
                       ttPackageVendorContact.email             = emitente.e-mail
                       ttPackageVendorContact.taxId             = emitente.cgc
                       ttPackageVendorContact.l-fornec-clic     = NO
                       ttPackageVendorContact.purchaseRequestId = int(packageId).
                   /*ttPackageVendorContact.status-integracao = TRUE WHEN SUBSTRING(param-compra.char-2,104,1) <> "N":U AND SUBSTRING(param-compra.char-2,105,1) = "S":U
                   ttPackageVendorContact.status-integracao = FALSE WHEN SUBSTRING(param-compra.char-2,104,1) = "N":U AND SUBSTRING(param-compra.char-2,105,1) <> "S":U
                   ttPackageVendorContact.ambiente          = SUBSTRING(param-compra.char-2,107,1).*/

            /* dados da empresa/usuario logados 
            IF AVAIL tt-empresa-usuario-logado THEN
                ASSIGN ttPackageVendorContact.eul-cnpj             = tt-empresa-usuario-logado.cnpj            
                       ttPackageVendorContact.eul-razao-social     = tt-empresa-usuario-logado.razao-social    
                       ttPackageVendorContact.eul-email-empresa    = tt-empresa-usuario-logado.email-empresa   
                       ttPackageVendorContact.eul-telefone-empresa = tt-empresa-usuario-logado.telefone-empresa
                       ttPackageVendorContact.eul-endereco-empresa = tt-empresa-usuario-logado.endereco-empresa
                       ttPackageVendorContact.eul-usuario          = tt-empresa-usuario-logado.usuario         
                       ttPackageVendorContact.eul-nome-usuario     = tt-empresa-usuario-logado.nome-usuario    
                       ttPackageVendorContact.eul-email-usuario    = tt-empresa-usuario-logado.email-usuario   
                       ttPackageVendorContact.eul-telefone-usuario = tt-empresa-usuario-logado.telefone-usuario.*/
        END.
    END.

    /* buscar fornecedores do clicbusiness */
    IF AVAIL param-compra THEN DO: /*Verifica se a integra‡Æo com o clicbusiness est  ativa e o termo de aceite est  aceito respectivamente*/
        IF SUBSTRING(param-compra.char-2,104,1) <> "N":U THEN DO:

            FIND FIRST ordem-compra NO-LOCK
                WHERE ordem-compra.nr-processo = proc-fornec.nr-processo NO-ERROR.

            IF NOT VALID-HANDLE(h-boin00885) THEN
                RUN inbo/boin00885.p PERSISTENT SET h-boin00885.
    
            RUN pi-retorna-fornecedores-pacote IN h-boin00885 (INPUT INT(packageId),
                                                               OUTPUT TABLE tt-fornec-clicbusiness).


            FOR EACH tt-fornec-clicbusiness:
                IF NOT CAN-FIND(FIRST ttPackageVendorContact
                                    WHERE ttPackageVendorContact.taxId = tt-fornec-clicbusiness.cod-cgc) THEN DO:
    
                    FIND FIRST familia NO-LOCK
                            WHERE familia.fm-codigo = tt-fornec-clicbusiness.cod-familia NO-ERROR.

                    CREATE ttPackageVendorContact.
                    ASSIGN /*ttPackageVendorContact.requisitions  = p-ordem*/
                           ttPackageVendorContact.vendorId          = "0"
                           ttPackageVendorContact.itemId            = ordem-compra.it-codigo WHEN AVAIL ordem-compra
                           ttPackageVendorContact.shortName         = tt-fornec-clicbusiness.nom-razao-social
                           ttPackageVendorContact.email             = tt-fornec-clicbusiness.des-e-mail
                           ttPackageVendorContact.taxId             = tt-fornec-clicbusiness.cod-cgc
                           ttPackageVendorContact.l-fornec-clic     = YES
                           ttPackageVendorContact.fm-codigo         = tt-fornec-clicbusiness.cod-familia
                           ttPackageVendorContact.desc-familia      = familia.descricao WHEN AVAIL familia
                           ttPackageVendorContact.reputacao         = tt-fornec-clicbusiness.cdd-reputacao
                           ttPackageVendorContact.purchaseRequestId = int(packageId).
                END.
                ELSE DO:
                    /* editar fornecedor ems */
                    FOR FIRST ttPackageVendorContact EXCLUSIVE-LOCK
                        WHERE ttPackageVendorContact.taxId = tt-fornec-clicbusiness.cod-cgc:
                        ASSIGN ttPackageVendorContact.reputacao = tt-fornec-clicbusiness.cdd-reputacao.
                    END.
                END.
            END.

            IF VALID-HANDLE(h-boin00885) THEN DO:
                DELETE PROCEDURE h-boin00885.
                ASSIGN h-boin00885 = ?.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPurchaseRequisitions DBOProgram 
PROCEDURE getPurchaseRequisitions :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttPurchaseRequisitionFilter.
    DEFINE OUTPUT PARAMETER TABLE FOR ttPurchaseRequisition.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE l-todos-fornec       AS LOGICAL INITIAL YES      NO-UNDO.
    DEFINE VARIABLE l-aprovada           AS LOGICAL INITIAL NO       NO-UNDO.
    DEFINE VARIABLE l-cotacao-fornecedor AS LOGICAL INITIAL NO       NO-UNDO.
    DEFINE VARIABLE c-un                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE c-un-int             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE c-des-un             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE c-list-un            AS CHARACTER EXTENT 100     NO-UNDO.
    DEFINE VARIABLE c-list-fabr          AS CHARACTER EXTENT 100     NO-UNDO.
    DEFINE VARIABLE i-num-entry          AS INTEGER INITIAL 1        NO-UNDO.
    DEFINE VARIABLE i-num-entry-aux      AS INTEGER INITIAL 1        NO-UNDO.
    DEFINE VARIABLE l-possui-un          AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE l-possui-fabr        AS LOGICAL                  NO-UNDO.
    DEFINE varIABLE l-multipleUnits      AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE l-integra-ems-his    AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE i-fab-medic          LIKE fab-medic.cdn-fabrican NO-UNDO.

    /*Fun‡Æo HIS - Sistema Hospitalar*/
    ASSIGN l-integra-ems-his = CAN-FIND (FIRST funcao 
                                  WHERE funcao.cd-funcao = "spp-integra-ems-his" 
                                    AND funcao.ativo = YES).

    find first param-compra no-lock no-error.
    assign l-multipleUnits = avail param-compra and param-compra.log-multi-unid-medid.

    run inbo/boin839.p persistent set h-boin839.
    run openQueryStatic in h-boin839(input "Main":U) .

    FIND FIRST ttPurchaseRequisitionFilter NO-ERROR.
    IF AVAIL ttPurchaseRequisitionFilter THEN DO:
        /*Busca fornecedores do processo de compras*/
        FOR EACH proc-fornec
           WHERE proc-fornec.nr-processo = INT(ttPurchaseRequisitionFilter.packageId) NO-LOCK:
            FOR FIRST emitente WHERE emitente.cod-emitente = proc-fornec.cod-emitente NO-LOCK:
                CREATE ttSupplierInformation.
                ASSIGN ttSupplierInformation.supplierName = emitente.nome-abrev
                       ttSupplierInformation.supplierId   = STRING(emitente.cod-emitente).
            END.
        END.
        FOR EACH ordem-compra
            WHERE ordem-compra.nr-processo = int(ttPurchaseRequisitionFilter.packageId)
            AND ordem-compra.situacao <> 4
            AND ordem-compra.situacao <> 6 NO-LOCK:
            assign l-cotacao-fornecedor = NO.

            DO i-num-entry-aux = 1 TO i-num-entry:
                ASSIGN c-list-un[i-num-entry-aux] = ""
                       c-list-fabr[i-num-entry-aux]="".
            END.

            ASSIGN i-num-entry = 1
                   l-possui-un = NO
                   l-possui-fabr = NO.

            IF (ttPurchaseRequisitionFilter.itemId <> "all":U and
               ordem-compra.it-codigo <> ttPurchaseRequisitionFilter.itemId) THEN NEXT.

            ASSIGN l-aprovada = NO.
            FOR EACH ttSupplierInformation:
                IF CAN-FIND (FIRST cotacao-item
                             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                               AND cotacao-item.cod-emitente = int(ttSupplierInformation.supplierId)
                               AND cotacao-item.cot-aprovada) THEN
                    ASSIGN l-aprovada = YES.
                ELSE do:
                    for each cotacao-item where cotacao-item.cod-emitente = int(ttSupplierInformation.supplierId) and
                                                cotacao-item.numero-ordem = ordem-compra.numero-ordem no-lock:
                        if (cotacao-item.preco-fornec <> 0) then do:
                            l-cotacao-fornecedor = true.
                            leave.
                        end.
                    end.
                end.
            END.
            IF l-aprovada THEN DO:
                IF NOT ttPurchaseRequisitionFilter.returnApproved THEN NEXT.
            END.
            ELSE DO:
                IF (NOT ttPurchaseRequisitionFilter.returnNotQuoted AND NOT l-cotacao-fornecedor) THEN NEXT.
            END.
            FIND FIRST ITEM WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

            IF AVAIL ITEM THEN DO:
                FIND FIRST tab-unidade WHERE tab-unidade.un = item.un NO-LOCK NO-ERROR.
                IF AVAIL tab-unidade THEN
                    assign c-un-int = tab-unidade.un + " - " + tab-unidade.descricao.
            END.


            if not l-multipleUnits AND NOT l-integra-ems-his then do:
                RUN createTTPurchaseRequisition.
                ASSIGN ttPurchaseRequisition.unitOfMeasure = c-un-int
                       ttPurchaseRequisition.quotationId = string(ordem-compra.numero-ordem) + lower(item.un).

                RUN getReferencePrice(OUTPUT ttPurchaseRequisition.referencePrice).
            end.
            else do:
                /*Se estiver marcado para mostrar ordens sem cota‡Æo e nÆo existir cota‡Æo para a ordem
                 dever  ser criado o registro da ordem e passar para a pr¢xima ordem de compra*/
                IF (ttPurchaseRequisitionFilter.returnNotQuoted AND NOT l-cotacao-fornecedor)THEN DO:
                    RUN createTTPurchaseRequisition.
                    ASSIGN ttPurchaseRequisition.unitOfMeasure = c-un-int
                           ttPurchaseRequisition.quotationId = string(ordem-compra.numero-ordem) + lower(item.un).

                    IF l-multipleUnits THEN
                        ASSIGN ttPurchaseRequisition.unitOfMeasure = ""
                               ttPurchaseRequisition.internalUnitOfMeasure = c-un-int.
    
                    RUN getReferencePrice(OUTPUT ttPurchaseRequisition.referencePrice).

                    NEXT.
                END.

                IF not l-multipleUnits THEN DO: /*NÆo tem multiplas unidades mas fun‡Æo HIS est  ativa*/
                    FOR EACH ttSupplierInformation:
                        FOR FIRST item-fornec FIELDS (unid-med-for)
                            WHERE item-fornec.it-codigo    = ordem-compra.it-codigo
                              AND item-fornec.cod-emitente = INT(ttSupplierInformation.supplierId) NO-LOCK: END.

                        /* Verifica se existe cota‡Æo na unidade do item-fornecedor, se tiver, como HIS est  ativa, busca todas as cota‡äes nessa unidade. 
                        SenÆo existir cota‡Æo para a unidade do item busca todas as cota‡äes com mesma UM da ultima cota‡Æo encontrada  */
                        ASSIGN c-un = "".
                        IF CAN-FIND(FIRST cotacao-item
                                    WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                                      AND cotacao-item.cod-emitente = int(ttSupplierInformation.supplierId)
                                      AND cotacao-item.un = item-fornec.unid-med-for
                                      AND cotacao-item.data-cotacao <> &if "{&ems_dbtype}":U = "MSS":U &then 01/01/1800 &else 11/11/1111 &endif) THEN
                            ASSIGN c-un = item-fornec.unid-med-for.
                        ELSE DO:
                            FOR LAST cotacao-item FIELDS(un)
                                    WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                                      AND cotacao-item.cod-emitente = int(ttSupplierInformation.supplierId)
                                      AND cotacao-item.data-cotacao <> &if "{&ems_dbtype}":U = "MSS":U &then 01/01/1800 &else 11/11/1111 &endif NO-LOCK: 
                                ASSIGN c-un = cotacao-item.un.
                            END.
                        END.

                        FOR EACH cotacao-item NO-LOCK
                            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                            AND cotacao-item.cod-emitente = int(ttSupplierInformation.supplierId)
                            AND cotacao-item.un = c-un
                            BREAK BY cotacao-item.seq-cotac DESC:

                            &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                                ASSIGN i-fab-medic = cotacao-item.cdn-fab-medic.
                           &ELSE
                               /*C¢digo do Fabricante de medicamentos na cota‡Æo*/
                                ASSIGN i-fab-medic = int(trim(substring(cotacao-item.char-1,127,9))) NO-ERROR.
                           &ENDIF
                            
                            ASSIGN l-possui-fabr = NO.
                            DO i-num-entry-aux = 1 TO i-num-entry:
        
                                IF c-list-fabr[i-num-entry-aux] <> "" AND c-list-fabr[i-num-entry-aux] = string(i-fab-medic) THEN DO:
                                    ASSIGN l-possui-fabr = YES.
                                END.
                            END.
        
                            IF NOT l-possui-fabr THEN DO:
                                FIND FIRST tab-unidade WHERE tab-unidade.un = cotacao-item.un NO-LOCK NO-ERROR.
                                IF AVAIL tab-unidade THEN
                                    ASSIGN c-un     = tab-unidade.un
                                           c-des-un = tab-unidade.descricao.
                                ELSE
                                    ASSIGN c-un     = ""
                                           c-des-un = "".
        
        
                                RUN createTTPurchaseRequisition.
                                ASSIGN ttPurchaseRequisition.unitOfMeasure = c-un + " - " + c-des-un
                                       ttPurchaseRequisition.quotationId = string(ordem-compra.numero-ordem) + lower(c-un) + STRING(i-fab-medic)
                                       ttPurchaseRequisition.internalUnitOfMeasure = c-un-int
                                       ttPurchaseRequisition.enableFunctionMultipleUnits = NO
                                       ttPurchaseRequisition.manufacturer = i-fab-medic
                                                           ttPurchaseRequisition.activeHisFunction = YES
                                       ttPurchaseRequisition.manufacturerDescription = fnManufacturerName(i-fab-medic).
        
                                RUN getReferencePrice(OUTPUT ttPurchaseRequisition.referencePrice).
        
                                ASSIGN c-list-fabr[i-num-entry] = STRING(i-fab-medic)
                                       i-num-entry = i-num-entry + 1.
                            END.
                        END.
                    END.

                END.
                ELSE DO:
                    FOR EACH ttSupplierInformation,
                        EACH cotacao-item
                            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                            AND cotacao-item.cod-emitente = int(ttSupplierInformation.supplierId)
                            BREAK BY cotacao-item.seq-cotac DESC:
                       
                        IF l-integra-ems-his THEN DO:
                           &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                                ASSIGN i-fab-medic = cotacao-item.cdn-fab-medic.
                           &ELSE
                               /*C¢digo do Fabricante de medicamentos na cota‡Æo*/
                                ASSIGN i-fab-medic = int(trim(substring(cotacao-item.char-1,127,9))) NO-ERROR.
                           &ENDIF
                        END.
    
                        ASSIGN l-possui-un = NO.
                        DO i-num-entry-aux = 1 TO i-num-entry:
                            IF l-integra-ems-his THEN DO:
                                IF (c-list-un[i-num-entry-aux] <> "" AND c-list-un[i-num-entry-aux] = cotacao-item.un) AND
                                    c-list-fabr[i-num-entry-aux] <> "" AND c-list-fabr[i-num-entry-aux] = string(i-fab-medic) THEN DO:
                                    ASSIGN l-possui-un = YES.
                                END.
                            END.
                            ELSE DO:
                                IF c-list-un[i-num-entry-aux] <> "" AND c-list-un[i-num-entry-aux] = cotacao-item.un THEN DO:
                                    ASSIGN l-possui-un = YES.
                                END.
                            END.
                            
                        END.
    
                        IF NOT l-possui-un THEN DO:
                            FIND FIRST tab-unidade WHERE tab-unidade.un = cotacao-item.un NO-LOCK NO-ERROR.
                            IF AVAIL tab-unidade THEN
                                ASSIGN c-un     = tab-unidade.un
                                       c-des-un = tab-unidade.descricao.
                            ELSE
                                ASSIGN c-un     = ""
                                       c-des-un = "".
    
    
                            RUN createTTPurchaseRequisition.
                            ASSIGN ttPurchaseRequisition.unitOfMeasure = c-un + " - " + c-des-un
                                   ttPurchaseRequisition.quotationId = string(ordem-compra.numero-ordem) + lower(c-un)
                                   ttPurchaseRequisition.internalUnitOfMeasure = c-un-int
                                   ttPurchaseRequisition.enableFunctionMultipleUnits = yes.

                            IF l-integra-ems-his THEN
                                ASSIGN ttPurchaseRequisition.quotationId = string(ordem-compra.numero-ordem) + lower(c-un) + STRING(i-fab-medic)
                                       ttPurchaseRequisition.manufacturer = i-fab-medic
                                                           ttPurchaseRequisition.activeHisFunction = YES
                                       ttPurchaseRequisition.manufacturerDescription = fnManufacturerName(i-fab-medic).
    
                            RUN getReferencePrice(OUTPUT ttPurchaseRequisition.referencePrice).
    
                            ASSIGN c-list-un[i-num-entry] = c-un
                                   c-list-fabr[i-num-entry] = string(i-fab-medic)
                                   i-num-entry = i-num-entry + 1.
                        END.
                    END.
                END. /*FIM l-multipleUnits */
            end.
        END.
    END.
    IF  VALID-HANDLE(h-boin839) THEN DO:
        DELETE OBJECT h-boin839.
        ASSIGN h-boin839 = ?.
    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuotationDetails DBOProgram 
PROCEDURE getQuotationDetails :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER packageNumber AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR ttStringVO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttQuotationDetails.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE i-fornec          AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE i-num-lin         AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE i-num-col         AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE c-un              AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE l-integra-ems-his AS LOG INIT NO              NO-UNDO.
    DEFINE VARIABLE i-fab-medic       LIKE fab-medic.cdn-fabrican NO-UNDO.
    DEFINE VARIABLE i-fab-medic-ant   LIKE fab-medic.cdn-fabrican NO-UNDO.

    DEFINE BUFFER bf-cotacao-item FOR cotacao-item.

    RUN inbo/boin839.p PERSISTENT SET h-boin839.
    RUN openQueryStatic IN h-boin839(INPUT "Main":U) .

        blockgetQuotationDetails:
    do  on error undo blockgetQuotationDetails, leave blockgetQuotationDetails
        on stop  undo blockgetQuotationDetails, leave blockgetQuotationDetails
        on quit  undo blockgetQuotationDetails, leave blockgetQuotationDetails:
        {cdp/findparamcompra.i}
        FOR EACH proc-fornec
           WHERE  proc-fornec.nr-processo = INT(packageNumber) NO-LOCK:
            FOR FIRST emitente WHERE emitente.cod-emitente = proc-fornec.cod-emitente NO-LOCK:
                CREATE ttSupplierInformation.
                ASSIGN ttSupplierInformation.supplierName = emitente.nome-abrev
                       ttSupplierInformation.supplierId   = STRING(emitente.cod-emitente).
            END.
        END.
        FIND FIRST ttStringVO NO-ERROR.
        IF AVAIL ttStringVO THEN DO:
             {cdp/findordemcompra.i int(ttStringVO.stringName)}
        END.

        /*FuncÆo HIS (Sistema Hospitalar) ativo*/
        ASSIGN l-integra-ems-his = CAN-FIND (FIRST funcao 
                                             WHERE funcao.cd-funcao = "spp-integra-ems-his" 
                                               AND funcao.ativo = YES).

                if  avail ordem-compra then do:
            FOR EACH ttSupplierInformation:

                 IF NOT CAN-FIND(FIRST cotacao-item
                                 where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                                   and cotacao-item.it-codigo    = ordem-compra.it-codigo
                                   AND cotacao-item.cod-emitente = INT(ttSupplierInformation.supplierId)
                                   and cotacao-item.data-cotacao <> &if "{&ems_dbtype}":U = "MSS":U &then 01/01/1800 &else 11/11/1111 &endif) THEN DO:
                    CREATE ttQuotationDetails.
                    ASSIGN ttQuotationDetails.purchaseRequisitionId = STRING(ordem-compra.numero-ordem)
                           ttQuotationDetails.supplierId            = ttSupplierInformation.supplierId
                           ttQuotationDetails.supplierName          = ttSupplierInformation.supplierName
                           ttQuotationDetails.totalValue            = "withoutQuotation":U.        /* Caso nÃ†o haja cota‡Ã†o passa "Sem Cota‡Ã†o" para o valor total */
                 END.
                 ELSE DO:
                    IF AVAIL param-compra AND param-compra.log-multi-unid-medid THEN DO: /*Se Multiplas Unidades de medida, busca todas as cota‡Ã¤es do fornecedor*/
                        ASSIGN c-un = ""
                               i-fab-medic-ant = 0.
                        FOR EACH cotacao-item
                           where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                             and cotacao-item.it-codigo    = ordem-compra.it-codigo
                             AND cotacao-item.cod-emitente = INT(ttSupplierInformation.supplierId)
                             and cotacao-item.data-cotacao <> &if "{&ems_dbtype}":U = "MSS":U &then 01/01/1800 &else 11/11/1111 &endif
                             NO-LOCK  BREAK BY cotacao-item.un
                             &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                                BY cotacao-item.cdn-fab-medic
                            &ELSE
                               /*C¢digo do Fabricante de medicamentos na cota‡Æo*/
                                BY trim(substring(cotacao-item.char-1,127,9))
                            &ENDIF :

                            IF l-integra-ems-his THEN DO:
                                &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                                    ASSIGN i-fab-medic = cotacao-item.cdn-fab-medic.
                                &ELSE
                                   /*C¢digo do Fabricante de medicamentos na cota‡Æo*/
                                    ASSIGN i-fab-medic = int(trim(substring(cotacao-item.char-1,127,9))) NO-ERROR.
                                &ENDIF
                                IF cotacao-item.un = c-un AND i-fab-medic-ant = i-fab-medic THEN NEXT.
                            END.
                            ELSE
                                IF cotacao-item.un = c-un THEN NEXT.

                            ASSIGN c-un = cotacao-item.un.

                            RUN createQuotationDetails.
                           
                        END.
                    END.
                    ELSE DO: 
                        FOR FIRST item-fornec FIELDS (unid-med-for)
                            WHERE item-fornec.it-codigo    = ordem-compra.it-codigo
                              AND item-fornec.cod-emitente = INT(ttSupplierInformation.supplierId) NO-LOCK: END.


                        IF l-integra-ems-his THEN DO:
                            /*Se nÆo Multiplas Unidades de medida mas HIS estiver ativa busca todas as cota‡Æo na unidade de medida principal do fornecedor. 
                              Caso nÆo ache busca todas as cota‡äes com primeira unidade de medida que encontrar*/
                            ASSIGN i-fab-medic-ant = 0.
                            IF CAN-FIND(FIRST cotacao-item
                                        where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                                          and cotacao-item.it-codigo    = ordem-compra.it-codigo
                                          AND cotacao-item.cod-emitente = INT(ttSupplierInformation.supplierId)
                                          and cotacao-item.data-cotacao <> &if "{&ems_dbtype}":U = "MSS":U &then 01/01/1800 &else 11/11/1111 &endif
                                          AND cotacao-item.un = item-fornec.unid-med-for) THEN DO:
                                FOR EACH cotacao-item
                                   where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                                     and cotacao-item.it-codigo    = ordem-compra.it-codigo
                                     AND cotacao-item.cod-emitente = INT(ttSupplierInformation.supplierId)
                                     and cotacao-item.data-cotacao <> &if "{&ems_dbtype}":U = "MSS":U &then 01/01/1800 &else 11/11/1111 &endif
                                     AND cotacao-item.un = item-fornec.unid-med-for
                                     NO-LOCK BREAK 
                                    &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                                        BY cotacao-item.cdn-fab-medic
                                    &ELSE
                                       /*C¢digo do Fabricante de medicamentos na cota‡Æo*/
                                        BY trim(substring(cotacao-item.char-1,127,9))
                                    &ENDIF:
                                    

                                    &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                                        ASSIGN i-fab-medic = cotacao-item.cdn-fab-medic.
                                    &ELSE
                                       /*C¢digo do Fabricante de medicamentos na cota‡Æo*/
                                        ASSIGN i-fab-medic = int(trim(substring(cotacao-item.char-1,127,9))) NO-ERROR.
                                    &ENDIF
                                    IF i-fab-medic-ant = i-fab-medic THEN NEXT.

                                    RUN createQuotationDetails.
                                END.
                            END.
                            ELSE DO:
                                /*Se nÆo achar cota‡Æo com a principal unidade de medida do fornecedor busca a primeira cota‡Æo que houver e 
                                consulta todas as cota‡Æo que houver para a mesma unidade de medida do registro encontrado*/
                                FIND FIRST bf-cotacao-item
                                        where bf-cotacao-item.numero-ordem = ordem-compra.numero-ordem
                                          and bf-cotacao-item.it-codigo    = ordem-compra.it-codigo
                                          AND bf-cotacao-item.cod-emitente = INT(ttSupplierInformation.supplierId)
                                          and bf-cotacao-item.data-cotacao <> &if "{&ems_dbtype}":U = "MSS":U &then 01/01/1800 &else 11/11/1111 &endif
                                          NO-LOCK NO-ERROR.
                                IF AVAIL bf-cotacao-item THEN DO:
                                    FOR EACH cotacao-item
                                       where cotacao-item.numero-ordem = bf-cotacao-item.numero-ordem
                                         and cotacao-item.it-codigo    = bf-cotacao-item.it-codigo
                                         AND cotacao-item.cod-emitente = bf-cotacao-item.cod-emitente
                                         and cotacao-item.data-cotacao <> &if "{&ems_dbtype}":U = "MSS":U &then 01/01/1800 &else 11/11/1111 &endif
                                         AND cotacao-item.un = bf-cotacao-item.un
                                         NO-LOCK BREAK 
                                        &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                                            BY cotacao-item.cdn-fab-medic
                                        &ELSE
                                           /*C¢digo do Fabricante de medicamentos na cota‡Æo*/
                                            BY trim(substring(cotacao-item.char-1,127,9))
                                        &ENDIF:
                                        
    
                                        &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                                            ASSIGN i-fab-medic = cotacao-item.cdn-fab-medic.
                                        &ELSE
                                           /*C¢digo do Fabricante de medicamentos na cota‡Æo*/
                                            ASSIGN i-fab-medic = int(trim(substring(cotacao-item.char-1,127,9))) NO-ERROR.
                                        &ENDIF
                                        IF i-fab-medic-ant = i-fab-medic THEN NEXT.
    
                                        RUN createQuotationDetails.
                                    END.
                                END.

                            END.
                        END.
                        ELSE DO:
                            /*Se nÆo Multiplas Unidades de medida e nÆo estiver ativa a fun‡Æo HIS(Sistema Hospitalar), b
                            usca apenas cota‡Æo com unidade de medida igual a unidade principal do fornecedor,
                               caso nÃ†o haja essa cota‡Æo busca a primeira que encontrar*/
                            FIND FIRST cotacao-item
                                 where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                                   and cotacao-item.it-codigo    = ordem-compra.it-codigo
                                   AND cotacao-item.cod-emitente = INT(ttSupplierInformation.supplierId)
                                   and cotacao-item.data-cotacao <> &if "{&ems_dbtype}":U = "MSS":U &then 01/01/1800 &else 11/11/1111 &endif
                                   AND cotacao-item.un = item-fornec.unid-med-for NO-LOCK NO-ERROR.
                            IF NOT AVAIL cotacao-item THEN
                                FIND FIRST cotacao-item
                                     where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                                       and cotacao-item.it-codigo    = ordem-compra.it-codigo
                                       AND cotacao-item.cod-emitente = INT(ttSupplierInformation.supplierId)
                                       and cotacao-item.data-cotacao <> &if "{&ems_dbtype}":U = "MSS":U &then 01/01/1800 &else 11/11/1111 &endif NO-LOCK NO-ERROR.
                            IF AVAIL cotacao-item THEN DO:
                                RUN createQuotationDetails.
                            END.
                        END.
                    END.
                 END.
            END.
                end.
        end.
    IF  VALID-HANDLE(h-boin839) THEN DO:
        DELETE OBJECT h-boin839.
        ASSIGN h-boin839 = ?.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuotationOfRequis DBOProgram 
PROCEDURE getQuotationOfRequis :
/*------------------------------------------------------------------------------
  Objetivo: Retornar informa‡äes de fabricante de medicamentos das cota‡äes 
            aprovadas das ordens de compra.                     
  Parameters:  ttPurchRequisPrint: temp-table com as ordens de compra
               ttSummaryQuotation: temp-table com as cota‡äes
  Notas: Utilizado no relat¢rio de impressÆo do pedido de compra Flex       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttPurchRequisPrint.
    DEFINE OUTPUT PARAMETER TABLE FOR ttSummaryQuotation.
 
    DEFINE VARIABLE i-fab-medic LIKE fab-medic.cdn-fabrican NO-UNDO.
    
    RUN inbo/boin839.p PERSISTENT SET h-boin839.
    RUN openQueryStatic IN h-boin839(INPUT "Main":U) .

    FOR EACH ttPurchRequisPrint:
        FOR FIRST cotacao-item 
           FIELDS(seq-cotac char-1 numero-ordem cot-aprovada
                  &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                                        cdn-fab-medic
                                  &ENDIF) 
            WHERE cotacao-item.numero-ordem = ttPurchRequisPrint.numero-ordem
              AND cotacao-item.cot-aprovada NO-LOCK:
            
            CREATE ttSummaryQuotation.
            ASSIGN ttSummaryQuotation.seq-cotac    = cotacao-item.seq-cotac
                   ttSummaryQuotation.numero-ordem = cotacao-item.numero-ordem
                   ttSummaryQuotation.cot-aprovada = cotacao-item.cot-aprovada.
    
            /*Busca fabricante de medicamento da cota‡Æo*/
            IF CAN-FIND (FIRST funcao 
                              WHERE funcao.cd-funcao = "spp-integra-ems-his" 
                                    AND funcao.ativo = YES) THEN DO:
                    &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                            ASSIGN i-fab-medic = cotacao-item.cdn-fab-medic.
                    &ELSE
                        /*C¢digo do Fabricante de medicamentos na cota‡Æo*/
                            ASSIGN i-fab-medic = int(trim(substring(cotacao-item.char-1,127,9))) NO-ERROR.
                    &ENDIF
                    
                    assign ttSummaryQuotation.manufacturer            = i-fab-medic
                           ttSummaryQuotation.activeHisFunction       = YES
                           ttSummaryQuotation.manufacturerDescription = fnManufacturerName(i-fab-medic).
            END.
        END.
    END.

    IF  VALID-HANDLE(h-boin839) THEN DO:
        DELETE OBJECT h-boin839.
        assign h-boin839 = ?.
    END.
                
        RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuotationReport DBOProgram 
PROCEDURE getQuotationReport :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER purchaseRequisitionId AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttQuotationReport.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE ttQuotationReport.
    FOR FIRST ordem-compra
        WHERE ordem-compra.numero-ordem = int(purchaseRequisitionId) NO-LOCK:
        
        CREATE ttQuotationReport.

        ASSIGN ttQuotationReport.purchaseRequisitionDate        = ordem-compra.data-emissao
               ttQuotationReport.itemQuantity                   = ordem-compra.qt-solic
               ttQuotationReport.purchaseRequisitionDescription = ordem-compra.narrativa
               ttQuotationReport.purchaseRequisition            = string(ordem-compra.numero-ordem).
               ttQuotationReport.itemType                       = {ininc/i01in274.i 04 ordem-compra.natureza}.
    
    
        FOR FIRST empresa FIELDS(e-mail telefone[1] nome endereco)
             WHERE empresa.ep-codigo                = ordem-compra.ep-codigo NO-LOCK:
            ASSIGN ttQuotationReport.companyEmail   = empresa.e-mail
                   ttQuotationReport.companyPhone   = empresa.telefone[1]
                   ttQuotationReport.companyName    = empresa.nome
                   ttQuotationReport.companyAddress = empresa.endereco.
        END.
    
        FOR FIRST item FIELDS(it-codigo desc-item un)
            WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK:
            ASSIGN ttQuotationReport.itemId            = item.it-codigo
                   ttQuotationReport.itemDescription   = item.desc-item
                   ttQuotationReport.itemUnitOfMeasure = item.un.
        END.
        FOR FIRST item-fornec FIELDS(item-do-forn)
            WHERE item-fornec.cod-emitente = ordem-compra.cod-emitente
              AND item-fornec.it-codigo    = ordem-compra.it-codigo NO-LOCK:
            ASSIGN ttQuotationReport.supplierItemDescription = item-fornec.item-do-forn.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuotationReportDelivery DBOProgram 
PROCEDURE getQuotationReportDelivery :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER purchaseRequisitionId AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttQuotationReportDelivery.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE ttQuotationReportDelivery.
    FOR EACH prazo-compra WHERE prazo-compra.numero-ordem = INT(purchaseRequisitionId) NO-LOCK:
        CREATE ttQuotationReportDelivery.
        ASSIGN ttQuotationReportDelivery.deliveryDate       = prazo-compra.data-entrega
               ttQuotationReportDelivery.deleveryQuantity   = prazo-compra.quantidade
               ttQuotationReportDelivery.deliverySequence   = prazo-compra.sequencia.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuotations DBOProgram 
PROCEDURE getQuotations :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR ttPurchaseRequisitionFilter.
    DEFINE INPUT  PARAMETER TABLE FOR ttStringVO.
    DEFINE INPUT  PARAMETER packageNumber AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttQuotation.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE de-menor-valor       AS DECIMAL                     NO-UNDO.
    DEFINE VARIABLE rw-menor-valor       AS ROWID                       NO-UNDO.
    DEFINE VARIABLE l-prim-cotacao-ordem AS LOGICAL INITIAL NO          NO-UNDO.
    DEFINE VARIABLE l-multipleUnits      AS LOGICAL INITIAL NO          NO-UNDO.
    DEFINE VARIABLE c-un                 AS CHARACTER                   NO-UNDO.
    DEFINE VARIABLE c-list-units         AS CHARACTER                   NO-UNDO.
    DEFINE VARIABLE unid-med-fornecedor  AS CHARACTER                   NO-UNDO.
    DEFINE VARIABLE de-preco-unit        LIKE cotacao-item.preco-unit   NO-UNDO.
    DEFINE VARIABLE i-fab-medic          LIKE fab-medic.cdn-fabrican    NO-UNDO.
    DEFINE VARIABLE l-integra-ems-his    AS LOGICAL                     NO-UNDO.

    {cdp/findparamcompra.i}
    FIND FIRST ttPurchaseRequisitionFilter NO-ERROR.

   find first param-compra no-lock no-error.
   assign l-multipleUnits = avail param-compra and param-compra.log-multi-unid-medid
          l-integra-ems-his = CAN-FIND (FIRST funcao 
                                        WHERE funcao.cd-funcao = "spp-integra-ems-his" 
                                          AND funcao.ativo = YES).

    FOR EACH proc-fornec
       WHERE  proc-fornec.nr-processo = INT(packageNumber) NO-LOCK:
        FOR FIRST emitente WHERE emitente.cod-emitente = proc-fornec.cod-emitente NO-LOCK:
            CREATE ttSupplierInformation.
            ASSIGN ttSupplierInformation.supplierName = emitente.nome-abrev
                   ttSupplierInformation.supplierId   = STRING(emitente.cod-emitente).
        END.
       
    END.

    EMPTY TEMP-TABLE tt-cotacoes-lidas.
    
    run inbo/boin839.p persistent set h-boin839.
    run openQueryStatic in h-boin839(input "Main":U) .

    FOR EACH ttSupplierInformation:

          FOR EACH ttStringVO NO-LOCK:
            FIND FIRST ordem-compra
                 WHERE ordem-compra.numero-ordem = INT(ttStringVO.stringName) NO-LOCK NO-ERROR.

            IF AVAIL ordem-compra THEN DO:

                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.

                IF AVAIL ITEM THEN DO:
                    FOR FIRST item-fornec FIELDS(unid-med-for)
                        WHERE item-fornec.cod-emitente = INT(ttSupplierInformation.supplierId)
                          AND item-fornec.it-codigo    = ITEM.it-codigo NO-LOCK: END.

                    if avail item-fornec then
                      assign unid-med-fornecedor = item-fornec.unid-med-for.
                    else
                      assign unid-med-fornecedor = item.un.

                    CREATE ttQuotation.
                    ASSIGN ttQuotation.supplierId = ttSupplierInformation.supplierId
                           ttQuotation.supplierName = ttSupplierInformation.supplierName
                           ttQuotation.purchaseRequisitionId = string(ordem-compra.numero-ordem)
                           ttQuotation.quotationId = string(ordem-compra.numero-ordem) + lower(item.un).

                    /*Prioridade para cotacao aprovada*/
                    /*Se nÃ†o estiver parametrizado como multiplas unidades busca cota‡Ã†o com unidade principal do fornecedor*/
                    IF NOT l-multipleUnits THEN
                        FIND FIRST cotacao-item
                             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                               AND cotacao-item.cod-emitente = INT(ttSupplierInformation.supplierId)
                               AND cotacao-item.un           = unid-med-fornecedor
                               AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.

                    IF NOT AVAIL cotacao-item THEN
                        FIND FIRST cotacao-item
                             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                               AND cotacao-item.cod-emitente = INT(ttSupplierInformation.supplierId)
                               AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.

                    /*caso nÃ†o esteja parametrizado multiplas unidades de medida e
                      nÃ†o encontra cota‡Ã†o aprovada busca a Â£ltima cota‡Ã†o do fornecedor*/
                    IF NOT AVAIL cotacao-item AND
                             NOT l-multipleUnits THEN
                        FIND LAST cotacao-item
                             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                               AND cotacao-item.cod-emitente = INT(ttSupplierInformation.supplierId)
                               AND cotacao-item.un           = unid-med-fornecedor
                               AND cotacao-item.data-cotacao <> &if "{&ems_dbtype}":U = "MSS":U &then 01/01/1800 &else 11/11/1111 &endif NO-LOCK NO-ERROR.

                    IF NOT AVAIL cotacao-item THEN
                         FIND LAST cotacao-item
                             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                               AND cotacao-item.cod-emitente = INT(ttSupplierInformation.supplierId)
                               AND cotacao-item.data-cotacao <> &if "{&ems_dbtype}":U = "MSS":U &then 01/01/1800 &else 11/11/1111 &endif NO-LOCK NO-ERROR.

                    IF AVAIL cotacao-item THEN DO:
                         
                        if l-multipleUnits then DO:
                             assign ttQuotation.quotationId = string(ordem-compra.numero-ordem) + lower(cotacao-item.un)
                                    c-un = cotacao-item.un.
                        END.

                        /*Busca fabricante de medicamento da cota‡Æo*/
                       IF l-integra-ems-his THEN DO:
                           &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                                ASSIGN i-fab-medic = cotacao-item.cdn-fab-medic.
                           &ELSE
                               /*C¢digo do Fabricante de medicamentos na cota‡Æo*/
                                ASSIGN i-fab-medic = int(trim(substring(cotacao-item.char-1,127,9))) NO-ERROR.
                           &ENDIF
                           
                           assign ttQuotation.quotationId = string(ordem-compra.numero-ordem) + lower(cotacao-item.un) + STRING(i-fab-medic).
                       END.

                        IF NOT CAN-FIND(FIRST tt-cotacoes-lidas
                                        WHERE tt-cotacoes-lidas.nr-ordem     = cotacao-item.numero-ordem
                                        AND   tt-cotacoes-lidas.cod-emitente = cotacao-item.cod-emitente
                                        AND   tt-cotacoes-lidas.un           = ITEM.un
                                        AND   tt-cotacoes-lidas.cdn-fabrican = i-fab-medic) THEN DO:

                           RUN createTTQuotation (INPUT ttPurchaseRequisitionFilter.comparisonAttribute).

                           FOR FIRST tab-unidade FIELDS(descricao) WHERE tab-unidade.un = cotacao-item.un NO-LOCK.
                               ASSIGN ttQuotation.unitOfMeasureDescription = tab-unidade.descricao.
                           END.

                           /*Fun‡Æo HIS*/
                           IF l-integra-ems-his THEN DO:
                              assign ttQuotation.manufacturer = i-fab-medic
                                      ttQuotation.activeHisFunction = YES
                                      ttQuotation.manufacturerDescription = fnManufacturerName(i-fab-medic).
                              
                           END. /*Fim IF fun‡Æo spp-integra-ems-his*/


                            CREATE tt-cotacoes-lidas.
                            ASSIGN tt-cotacoes-lidas.nr-ordem     = cotacao-item.numero-ordem
                                   tt-cotacoes-lidas.cod-emitente = cotacao-item.cod-emitente
                                   tt-cotacoes-lidas.un           = cotacao-item.un
                                   tt-cotacoes-lidas.cdn-fabrican = i-fab-medic.

                            /*grava as unidades difrerentes das cota‡Ã¤es para
                              montar a sugestÃ†o*/
                            if lookup(cotacao-item.un,c-list-units) = 0 then do:
                                if c-list-units = "" then
                                    assign c-list-units = cotacao-item.un.
                                else
                                    assign c-list-units = c-list-units + "," + cotacao-item.un.
                            end.
                        END.
                    END.
                    ELSE DO:
                        ASSIGN ttQuotation.quotationValue = "withoutQuotation":U.
                    END.

                    if l-multipleUnits OR l-integra-ems-his then
                        FOR EACH cotacao-item NO-LOCK
                            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                            AND   cotacao-item.cod-emitente = INT(ttSupplierInformation.supplierId)
                            BY cotacao-item.cod-emitente
                            BY cotacao-item.seq-cotac DESC:

                            IF l-integra-ems-his THEN DO:
                               &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                                    ASSIGN i-fab-medic = cotacao-item.cdn-fab-medic.
                               &ELSE
                                   /*C¢digo do Fabricante de medicamentos na cota‡Æo*/
                                    ASSIGN i-fab-medic = int(trim(substring(cotacao-item.char-1,127,9))) NO-ERROR.
                               &ENDIF
                            END.
                            IF NOT CAN-FIND(FIRST tt-cotacoes-lidas
                                            WHERE tt-cotacoes-lidas.nr-ordem     = cotacao-item.numero-ordem
                                            AND   tt-cotacoes-lidas.cod-emitente = cotacao-item.cod-emitente
                                            AND   tt-cotacoes-lidas.un           = cotacao-item.un
                                            AND   tt-cotacoes-lidas.cdn-fabrican = i-fab-medic) THEN DO:

                                CREATE ttQuotation.

                                ASSIGN ttQuotation.supplierId = ttSupplierInformation.supplierId
                                       ttQuotation.supplierName = ttSupplierInformation.supplierName
                                       ttQuotation.purchaseRequisitionId = string(ordem-compra.numero-ordem)
                                       ttQuotation.quotationId = string(ordem-compra.numero-ordem) + lower(cotacao-item.un).

                                IF l-integra-ems-his THEN
                                   assign ttQuotation.quotationId = string(ordem-compra.numero-ordem) + lower(cotacao-item.un) + STRING(i-fab-medic).

                               RUN createTTQuotation (INPUT ttPurchaseRequisitionFilter.comparisonAttribute).
    
                               FOR FIRST tab-unidade FIELDS(descricao) WHERE tab-unidade.un = cotacao-item.un NO-LOCK.
                                   ASSIGN ttQuotation.unitOfMeasureDescription = tab-unidade.descricao.
                               END.
    
                               /*Busca fabricante de medicamento da cota‡Æo*/
                               IF l-integra-ems-his THEN DO:
                                   &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                                        ASSIGN i-fab-medic = cotacao-item.cdn-fab-medic.
                                   &ELSE
                                       /*C¢digo do Fabricante de medicamentos na cota‡Æo*/
                                        ASSIGN i-fab-medic = int(trim(substring(cotacao-item.char-1,127,9))).
                                   &ENDIF
                                    
                                   assign ttQuotation.manufacturer = i-fab-medic
                                          ttQuotation.activeHisFunction = YES
                                          ttQuotation.manufacturerDescription = fnManufacturerName(i-fab-medic).
                                   
                               END. /*Fim IF fun‡Æo spp-integra-ems-his*/

                                CREATE tt-cotacoes-lidas.
                                ASSIGN tt-cotacoes-lidas.nr-ordem     = cotacao-item.numero-ordem
                                       tt-cotacoes-lidas.cod-emitente = cotacao-item.cod-emitente
                                       tt-cotacoes-lidas.un           = cotacao-item.un
                                       tt-cotacoes-lidas.cdn-fabrican = i-fab-medic.
                                /*grava as unidades difrerentes das cota‡Ã¤es para
                                  montar a sugestÃ†o*/
                                if lookup(cotacao-item.un,c-list-units) = 0 then do:
                                    if c-list-units = "" then
                                        assign c-list-units = cotacao-item.un.
                                    else
                                        assign c-list-units = c-list-units + "," + cotacao-item.un.
                                end.

                            END.
                        end.
                END.
            END.
        END.
    END.

    IF  VALID-HANDLE(h-boin839) THEN DO:
        DELETE OBJECT h-boin839.
        assign h-boin839 = ?.
    END.

    FOR EACH ttQuotation:

        IF ttQuotation.quotationValue <> "withoutQuotation":U AND DECIMAL(ttQuotation.quotationValue) = 0 THEN
            ASSIGN ttQuotation.quotationValue = "withoutQuotation":U.

        IF NOT ttPurchaseRequisitionFilter.returnNotQuoted AND ttQuotation.quotationValue = "withoutQuotation":U
        THEN
            DELETE ttQuotation.
    END.

    FOR EACH ttStringVO NO-LOCK:
                ASSIGN de-ultimo-menor-valor = 0.
        FOR FIRST ordem-compra
            WHERE ordem-compra.numero-ordem = INT(ttStringVO.stringName) NO-LOCK:
            ASSIGN de-menor-valor = ?
                   rw-menor-valor = ?.
            FOR EACH ttQuotation WHERE int(ttQuotation.purchaseRequisitionId) = ordem-compra.numero-ordem:
                IF ttQuotation.quotationValue = "withoutQuotation":U THEN
                    NEXT.
                IF de-menor-valor = ? THEN
                    ASSIGN de-menor-valor = DECIMAL(ttQuotation.quotationValue)
                           rw-menor-valor = ROWID(ttQuotation).
                ELSE
                    IF decimal(ttQuotation.quotationValue) <= de-menor-valor THEN do:
                        ASSIGN de-ultimo-menor-valor = de-menor-valor
                                                           de-menor-valor = DECIMAL(ttQuotation.quotationValue)
                               rw-menor-valor = ROWID(ttQuotation).
                    end.
            END.
            IF rw-menor-valor <> ? THEN DO:
                FIND FIRST ttQuotation WHERE ROWID(ttQuotation) = rw-menor-valor NO-ERROR.
                IF AVAIL ttQuotation THEN
                    ASSIGN ttQuotation.suggested = YES.
            END.
        END.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getReferencePrice DBOProgram 
PROCEDURE getReferencePrice :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM c-reference-price AS CHARACTER NO-UNDO.
    
    FIND FIRST item-uni-estab
        WHERE item-uni-estab.it-codigo   = ordem-compra.it-codigo   
          AND item-uni-estab.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

    IF AVAIL item-uni-estab THEN DO:
        
        IF ttPurchaseRequisitionFilter.priceRefType = 0 THEN DO:

            find last  b-ordem use-index compra-item
                 where b-ordem.it-codigo    = ordem-compra.it-codigo
                 and   b-ordem.data-pedido <> ?
                 no-lock no-error.
            IF AVAIL b-ordem THEN
                ASSIGN c-reference-price = string(b-ordem.preco-unit * ordem-compra.qt-solic, ">>>>>>>>>,>>>,>>9.99").

        END.

        IF ttPurchaseRequisitionFilter.priceRefType = 1 THEN
            ASSIGN c-reference-price = string(item-uni-estab.preco-base * ordem-compra.qt-solic, ">>>>>>>>>,>>>,>>9.99").

        IF ttPurchaseRequisitionFilter.priceRefType = 2 THEN DO:

            FIND FIRST tb-pr-cc WHERE ROWID(tb-pr-cc) = TO-ROWID(ttPurchaseRequisitionFilter.priceTableRowid) NO-LOCK NO-ERROR.
            IF AVAIL tb-pr-cc THEN DO:

                find first item-tab 
                    where  item-tab.cod-emitente = emitente.cod-emitente and
                           item-tab.nr-tab       = tb-pr-cc.nr-tab       and
                           item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag and
                           item-tab.it-codigo    = ordem-compra.it-codigo no-lock no-error.
                IF AVAIL item-tab AND item-tab.situacao = 1  THEN
                    ASSIGN c-reference-price = string(item-tab.pr-item * ordem-compra.qt-solic, ">>>>>>>>>,>>>,>>9.99").


            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSupplierContacts DBOProgram 
PROCEDURE getSupplierContacts :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER supplierId AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttSupplierContact.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FOR EACH cont-emit
       WHERE cont-emit.cod-emitente = int(supplierId) NO-LOCK:
       CREATE ttSupplierContact.
       ASSIGN ttSupplierContact.email       = cont-emit.e-mail
              ttSupplierContact.phone       = cont-emit.telefone
              ttSupplierContact.contactName = cont-emit.nome.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSupplierInformation DBOProgram 
PROCEDURE getSupplierInformation :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER supplierId AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttSupplierInformation.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE ttSupplierInformation.
    FIND FIRST emitente
         WHERE emitente.cod-emitente = INT(supplierId) NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:
        CREATE ttSupplierInformation.
        ASSIGN ttSupplierInformation.supplierId    = string(emitente.cod-emitente)
               ttSupplierInformation.supplierName  = emitente.nome-emit
               ttSupplierInformation.cnpj          = fn-cgc(emitente.cod-emitente)
               ttSupplierInformation.amountDelayed = 0
               ttSupplierInformation.amountOrdered = 0.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSupplierValues DBOProgram 
PROCEDURE getSupplierValues :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER supplierId AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttSupplierInformation.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE deAmountDelayed AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE deAmountOrdered AS DECIMAL     NO-UNDO.

    CREATE ttSupplierInformation.
    ASSIGN ttSupplierInformation.supplierId = supplierId.
    
    FOR EACH pedido-compr
       WHERE pedido-compr.cod-emitente = int(supplierId)
         AND pedido-compr.data-pedido >= (TODAY - 365) NO-LOCK:

         RUN getAmountOrder(INPUT  pedido-compr.num-pedido,
                            OUTPUT deAmountDelayed,
                            OUTPUT deAmountOrdered).
         ASSIGN ttSupplierInformation.amountDelayed = ttSupplierInformation.amountDelayed + deAmountDelayed
                ttSupplierInformation.amountOrdered = ttSupplierInformation.amountOrdered + deAmountOrdered.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-cgc DBOProgram 
FUNCTION fn-cgc RETURNS CHARACTER
  ( INPUT i-cod-emitente AS INT) :

  DEF VAR c-format AS CHAR FORMAT "X(20)" NO-UNDO.
  DEF VAR c-cgc    AS CHAR FORMAT "X(20)" NO-UNDO.

  ASSIGN c-format = "X(19)".
  IF NOT AVAIL param-global THEN
     FIND FIRST param-global NO-LOCK NO-ERROR.

  IF NOT AVAIL emitente OR
        (AVAIL emitente AND emitente.cod-emitente <>  i-cod-emitente )THEN
      FIND FIRST emitente
            WHERE emitente.cod-emitente = i-cod-emitente NO-LOCK NO-ERROR.

   IF AVAIL emitente AND AVAIL param-global THEN DO:
      IF emitente.natureza = 1 THEN
          ASSIGN c-format = param-global.formato-id-pessoal.
      ELSE
          IF emitente.natureza = 2 THEN
             ASSIGN c-format = param-global.formato-id-federal.
      ASSIGN c-cgc = STRING(emitente.cgc, c-format).
   END.

  RETURN c-cgc.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnAveragePayment DBOProgram 
FUNCTION fnAveragePayment RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Pre‡o total da cota‡Æo convertido .
    Notes:
------------------------------------------------------------------------------*/

    def var de-prazo-medio        AS DECIMAL      no-undo.
    DEF VAR i-cont                AS INT          NO-UNDO.


    blockAveragePayment:
    do  on error undo blockAveragePayment, leave blockAveragePayment
        on stop  undo blockAveragePayment, leave blockAveragePayment
        on quit  undo blockAveragePayment, leave blockAveragePayment:

        FIND FIRST cond-pagto WHERE cond-pagto.cod-cond-pag = cotacao-item.cod-cond-pag NO-LOCK NO-ERROR.

        DO i-cont = 1 TO 12:
            de-prazo-medio = de-prazo-medio + cond-pagto.prazos[i-cont].
        END.

        ASSIGN de-prazo-medio = de-prazo-medio / cond-pagto.num-parcelas.

        RETURN de-prazo-medio.

    end.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCurrencyShorthand DBOProgram 
FUNCTION fnCurrencyShorthand RETURNS CHARACTER
  ( INPUT iCurrency AS INT ) :
/*------------------------------------------------------------------------------
  Purpose: Busca sigla da Moeda
    Notes: i-currency - C¢digo da Moeda
------------------------------------------------------------------------------*/
    
  DEFINE VARIABLE cCurrencyShorthand AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cReturn AS CHARACTER   NO-UNDO.

  blockCurrencyShorthand:
    do  on error undo blockCurrencyShorthand, leave blockCurrencyShorthand
        on stop  undo blockCurrencyShorthand, leave blockCurrencyShorthand
        on quit  undo blockCurrencyShorthand, leave blockCurrencyShorthand:
      assign cCurrencyShorthand = "".
    
      run findCodigo in h-boun005(input iCurrency, output cReturn).
      if cReturn = "" then
        run getCharfield in h-boun005(input "sigla":U, output cCurrencyShorthand).      
    
      RETURN cCurrencyShorthand.   /* Function return value. */
    END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnExpenses DBOProgram 
FUNCTION fnExpenses RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Total das despesas convertido.
    Notes:
------------------------------------------------------------------------------*/

    def var de-total-despesa        as dec      no-undo.
    def var h-boin706               as handle   no-undo.

    blockExpenses:
    do  on error undo blockExpenses, leave blockExpenses
        on stop  undo blockExpenses, leave blockExpenses
        on quit  undo blockExpenses, leave blockExpenses:

        if AVAIL param-compra AND param-compra.log-despesa then do:

            RUN inbo/boin706.p PERSISTENT SET h-boin706.
            run calculaTotalDespesas in h-boin706 (input rowid(cotacao-item),
                                                   output de-total-despesa).

            /* ConversÃ†o do valor para outra moeda */
             if  cotacao-item.mo-codigo <> 0 then
                run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                  input 0,
                                  input de-total-despesa,
                                  input TODAY,
                                  output de-total-despesa).

             DELETE PROCEDURE h-boin706.
                    ASSIGN h-boin706 = ?.
        end.

        return de-total-despesa.
    end.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnFreightPrice DBOProgram 
FUNCTION fnFreightPrice RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    def var de-valor-frete      like cotacao-item.valor-frete     no-undo.


    blockFreightPrice:
    do  on error undo blockFreightPrice, leave blockFreightPrice
        on stop  undo blockFreightPrice, leave blockFreightPrice
        on quit  undo blockFreightPrice, leave blockFreightPrice:

        assign de-valor-frete = cotacao-item.valor-frete.

        /* ConversÃ†o do valor para outra moeda */
        if  cotacao-item.mo-codigo <> 0 then
             run cdp/cd0812.p (input cotacao-item.mo-codigo,
                               input 0,
                               input de-valor-frete,
                               input TODAY,
                               output de-valor-frete).

        return de-valor-frete.
    end.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnItemPrice DBOProgram 
FUNCTION fnItemPrice RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Pre‡o unitÂ rio convertido
    Notes:
------------------------------------------------------------------------------*/

    def var de-preco-unit like cotacao-item.preco-unit    no-undo.

    blockItemPrice:
    do  on error undo blockItemPrice, leave blockItemPrice
        on stop  undo blockItemPrice, leave blockItemPrice
        on quit  undo blockItemPrice, leave blockItemPrice:


        ASSIGN de-preco-unit = cotacao-item.preco-unit.

        /* ConversÃ†o do valor para outra moeda */
        if  cotacao-item.mo-codigo <> 0 then
            run cdp/cd0812.p (input cotacao-item.mo-codigo,
                              input 0,
                              input de-preco-unit,
                              input TODAY,
                              output de-preco-unit).
        return de-preco-unit.

    end.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnManufacturerName DBOProgram 
FUNCTION fnManufacturerName RETURNS CHARACTER
  ( INPUT i-fab-medic AS INT ) :
/*------------------------------------------------------------------------------
  Purpose: Busca nome do fabricante
    Notes: i-fab-medic - C¢digo do fabricante
------------------------------------------------------------------------------*/
    DEF VAR c-nome-fab-medic LIKE fab-medic.nom-fabrican NO-UNDO.

    blockManufacturerName:
    do  on error undo blockManufacturerName, leave blockManufacturerName
        on stop  undo blockManufacturerName, leave blockManufacturerName
        on quit  undo blockManufacturerName, leave blockManufacturerName:

       /*Busca nome do fabricante*/
       RUN goToKey      IN h-boin839 (INPUT i-fab-medic).
       IF RETURN-VALUE = "OK":U THEN DO:
            RUN getCharField IN h-boin839 (INPUT "nom-fabrican",
                                           OUTPUT c-nome-fab-medic).
       END.
        
       return c-nome-fab-medic.
    end.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPaymentTerm DBOProgram 
FUNCTION fnPaymentTerm RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/


    blockPaymentTerm:
    do  on error undo blockPaymentTerm, leave blockPaymentTerm
        on stop  undo blockPaymentTerm, leave blockPaymentTerm
        on quit  undo blockPaymentTerm, leave blockPaymentTerm:

        {cdp/findcondpagto.i cotacao-item.cod-cond-pag}

        if  avail cond-pagto then
            return cond-pagto.descricao.
                else if cotacao-item.cod-cond-pag = 0 then
                        return "Condi‡Æo Espec¡fica".

        return "".
    end.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTotalPrice DBOProgram 
FUNCTION fnTotalPrice RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Pre‡o total da cota‡Æo convertido .
    Notes:
------------------------------------------------------------------------------*/

    def var de-total-cotacao        like cotacao-item.preco-unit      no-undo.


    blockTotalPrice:
    do  on error undo blockTotalPrice, leave blockTotalPrice
        on stop  undo blockTotalPrice, leave blockTotalPrice
        on quit  undo blockTotalPrice, leave blockTotalPrice:

        assign de-total-cotacao = cotacao-item.preco-unit * ordem-compra.qt-solic.
        /* ConversÃ†o do valor para outra moeda */
        if  cotacao-item.mo-codigo <> 0 then
            run cdp/cd0812.p (input cotacao-item.mo-codigo,
                              input 0,
                              input de-total-cotacao,
                              input TODAY,
                              output de-total-cotacao).
        /* Despesas da cota‡Æo */
        if  AVAIL param-compra AND param-compra.log-despesa then
            assign de-total-cotacao = de-total-cotacao + fnExpenses().
        return de-total-cotacao.
    end.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnVendorPrice DBOProgram 
FUNCTION fnVendorPrice RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Pre‡o unitÂ rio convertido
    Notes:
------------------------------------------------------------------------------*/

    def var de-preco-unit-for like cotacao-item.pre-unit-for  no-undo.

    blockItemPrice:
    do  on error undo blockItemPrice, leave blockItemPrice
        on stop  undo blockItemPrice, leave blockItemPrice
        on quit  undo blockItemPrice, leave blockItemPrice:


        ASSIGN de-preco-unit-for = cotacao-item.pre-unit-for.

        /* ConversÃ†o do valor para outra moeda */
        if  cotacao-item.mo-codigo <> 0 then
            run cdp/cd0812.p (input cotacao-item.mo-codigo,
                              input 0,
                              input de-preco-unit-for,
                              input TODAY,
                              output de-preco-unit-for).
        return de-preco-unit-for.

    end.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

