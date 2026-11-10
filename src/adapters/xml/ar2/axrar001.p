/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXRAR001 2.00.00.005 } /*** "010005" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i axrar001 MAX}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : AXSRAR001.p
    Purpose     : RECEBIMENTO MOVIMENTO ESTOQUE

    Syntax      :

    Description : ADAPTER DE RECEBIMENTO MOVIMENTO DE ESTOQUE
    Author(s)   : Eliza Fernandes Corrˆa - log1465
    CREATED     : 17/02/2004 09:00
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */

/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlApp            AR2 
&GLOBAL-DEFINE XmlTranName       InventoryTransaction
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 299.999
&GLOBAL-DEFINE XmlListOfAction   add

/* Variaveis para uso do xmlloadmessagehandlerrec */
{xmlinc/xmlloadmessagehandlerrecdef.i}

/* Variaveis para uso do xmlLoadGenXmlRec */
{xmlinc/xmlloadgenxmlrecdef.i}

{cep/ceapi001k.i} /* Temp-table tt-movto */
DEF VAR h-ceapi001k AS HANDLE NO-UNDO.
{cdp/cd0666.i}   /* Temp-table tt-erro */
{cdp/cdcfgmat.i}

/* ---  Knupp - Retorno da mensagem dos Movtos de Estoque  --- */
DEFINE VARIABLE h-axnar001                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE i-TransactionNumberExternal AS INT        NO-UNDO.
DEFINE VARIABLE l-ft2100                    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE level                       AS INTEGER    NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_des_msg_ajuda AS CHARACTER INITIAL ?
     FIELD ttv_des_msg_erro  AS CHARACTER INITIAL ?
     FIELD ttv_num_cod_erro  AS INTEGER   INITIAL ?
.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 30.5
         WIDTH              = 58.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

/* ***************************  Main Block  *************************** */

/* Procedure getTransSubsInfo  */
{xmlinc/xmlgettranssubsinfo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveMessage Procedure 
PROCEDURE receiveMessage :
/*------------------------------------------------------------------------------
  Purpose: RECEBE A MENSAGEM DO CONTROL BROKER E PROCESSA A MESMA PARA ENTREGAR AO DESTINO
  Parameters: pInputXml, pOutputXml
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM hInputXML  AS HANDLE NO-UNDO.
    DEF OUTPUT PARAM hOutputXML AS HANDLE NO-UNDO.

    DEF VAR hGenXml          AS HANDLE NO-UNDO. 
    DEF VAR hMessageHandler  AS HANDLE NO-UNDO.
    DEF VAR hBusinessContent AS HANDLE NO-UNDO.
    DEF VAR lSuccessProcess  AS LOG    NO-UNDO.
    DEF VAR iCount           AS INT    NO-UNDO.
    DEF VAR cReturnValue     AS CHAR   NO-UNDO.
    DEF VAR cTranAction      AS CHAR   NO-UNDO.
    DEF VAR cTranEvent       AS CHAR   NO-UNDO.
    DEF VAR cTranVersion     AS CHAR   NO-UNDO.
    DEF VAR cErrorText       AS CHAR   NO-UNDO.

    DEF VAR iFirstId               AS INT NO-UNDO.
    DEF VAR iId                    AS INT NO-UNDO.
    DEF VAR iLocationId            AS INT NO-UNDO.
    DEF VAR iItemId                AS INT NO-UNDO.
    DEF VAR iDocumentId            AS INT NO-UNDO.
    DEF VAR iOrderOperationId      AS INT NO-UNDO.
    DEF VAR iTargetTransactionId   AS INT NO-UNDO.
    DEF VAR iTransactionValuesId   AS INT NO-UNDO.
    DEF VAR iValuesId              AS INT NO-UNDO.
    DEF VAR iBatchAverageValuesId  AS INT NO-UNDO.
    DEF VAR iOnLineAverageValuesId AS INT NO-UNDO.
    DEF VAR iStandardCostValuesId  AS INT NO-UNDO.

    DEF VAR l-integra-ems-his      AS LOG    NO-UNDO.
    /*DEF VAR h-ceapi001j            AS HANDLE NO-UNDO.*/

    ASSIGN l-integra-ems-his = NO.
    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    
          IF CAN-FIND (FIRST funcao 
                       WHERE funcao.cd-funcao = "spp-integra-ems-his"
                       AND   funcao.ativo     = yes) THEN DO:
    
              ASSIGN l-integra-ems-his = YES.
    
          END.
    
    &ENDIF

    /* Verfica se MessageHandler.p est  na memoria */
    {xmlinc/xmlloadmessagehandlerrec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="hOutputXML"}

    /* Verifica se o MessageHandler foi executado corretamente */
    IF  cReturnValue <> "OK":U THEN 
     IF cReturnValue <> ? AND cReturnValue <> "" THEN 
        RUN setError IN hMessageHandler (INPUT 0,
                                         INPUT "enviroment_error":U,
                                         INPUT cReturnValue).

    /* Armazena e valida a mensagem */
    RUN parseMessage IN hMessageHandler (INPUT  hInputXml,
                                         INPUT "{&XmlTranName}",
                                         INPUT "{&XmlMaxTranVersion}",
                                         INPUT "{&XmlMinTranVersion}",
                                         INPUT 
                                          &IF DEFINED(XmlListOfEvents) <> 0
                                           &THEN "{&XmlListOfEvents}",
                                          &ELSE "",
                                           &ENDIF
                                         OUTPUT lSuccessProcess,
                                         OUTPUT cTranAction,
                                         OUTPUT cTranEvent,
                                         OUTPUT cTranVersion,
                                         OUTPUT hOutputXML ).

    RUN getBusinessContent IN hMessageHandler (OUTPUT hBusinessContent).

    /* Verifica se APIXml est  na memoria */
    {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="hOutputXML"}

    /* Verofica se o ut-genxml foi iniciado corretamente */
    IF  cReturnValue <> "OK":U THEN 
     IF cReturnValue <> ? AND cReturnValue <> "" THEN DO:
        DELETE OBJECT hBusinessContent NO-ERROR.
        RUN setError IN hMessageHandler (INPUT 0,
                                         INPUT "enviroment_error":U,
                                         INPUT cReturnValue).
    END.

    RUN reset IN hGenXml.

    RUN loadXml IN hGenXml (hBusinessContent).

    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Cria o registro na temp-table */
    CREATE tt-movto.
    RUN searchTag IN hGenXml ("TransactionInformation":U, 1, OUTPUT iFirstId).
      IF iFirstId <> ? THEN DO:
         RUN getSonDec  IN hGenXml (INPUT iFirstId, INPUT "TransactionType":U, OUTPUT tt-movto.tipo-trans).
           IF tt-movto.tipo-trans <> 1 AND tt-movto.tipo-trans <> 2 THEN
              ASSIGN tt-movto.tipo-trans = 1.

         /* ------   Busca o Numero Externo da Solicitacao de Compras vindo do SGT   ----- */
         RUN getSonDec IN hGenXml (INPUT iFirstId, INPUT "TransactionNumberExternal":U, OUTPUT i-TransactionNumberExternal).

         RUN getSonDate IN hGenXml (INPUT iFirstId, INPUT "TransactionDate":U, OUTPUT tt-movto.dt-trans).
           IF tt-movto.dt-trans = ? OR STRING(tt-movto.dt-trans) = "" THEN
              ASSIGN tt-movto.dt-trans = TODAY.
      END.

    RUN searchTag IN hGenXml ("Location":U, 1, OUTPUT iLocationId).
    RUN searchTag IN hGenXml ("Site":U, iLocationId, OUTPUT iId).
    RUN getSonVal IN hGenXml (INPUT iId, INPUT "SiteID":U, OUTPUT tt-movto.cod-estabel).

    RUN searchTag IN hGenXml ("Warehouse":U, iLocationId, OUTPUT iId).
    RUN getSonVal IN hGenXml (INPUT iId, INPUT "WarehouseID":U, OUTPUT tt-movto.cod-depos).

    RUN searchTag IN hGenXml ("BinLocation":U, iLocationId, OUTPUT iId).
    RUN getSonVal IN hGenXml (INPUT iId, INPUT "BinLocationID":U, OUTPUT tt-movto.cod-localiz).
      IF tt-movto.cod-localiz = ? THEN ASSIGN tt-movto.cod-localiz = "".

    RUN getSonVal IN hGenXml (INPUT iLocationId, INPUT "LotORSerialNumber":U, OUTPUT tt-movto.lote).
      IF tt-movto.lote = ? THEN ASSIGN tt-movto.lote = "".

    RUN getSonDate IN hGenXml (INPUT iLocationId, INPUT "LotValidityDate":U, OUTPUT tt-movto.dt-vali-lote).

    RUN searchTag IN hGenXml ("Item":U, 1, OUTPUT iItemId).
    RUN getSonVal IN hGenXml (INPUT iItemId, INPUT "ItemCode":U, OUTPUT tt-movto.it-codigo).
    RUN getSonVal IN hGenXml (INPUT iItemId, INPUT "DirectDebitItemDescription":U, OUTPUT tt-movto.descricao-db).
      IF tt-movto.descricao-db = ? THEN ASSIGN tt-movto.descricao-db = "".

    RUN searchTag IN hGenXml ("Reference":U, iItemId, OUTPUT iId).
      IF iId <> ? then do:
          find first item no-lock
               where item.it-codigo = tt-movto.it-codigo no-error.
          if avail item then do:
              if item.tipo-con-est = 4 THEN
                  RUN getSonVal IN hGenXml (INPUT iId, INPUT "ReferenceCode":U, OUTPUT tt-movto.cod-refer).
              else
                  assign tt-movto.cod-refer = "".
          end.
      end.

    RUN searchTag IN hGenXml ("Vendor":U, 1, OUTPUT iFirstId).
      IF iFirstId <> ? THEN
         RUN getSonDec IN hGenXml (INPUT iFirstId, INPUT "VendorID":U, OUTPUT tt-movto.cod-emitente).

    RUN searchTag IN hGenXml ("GeneralLedgerAccount":U, 1, OUTPUT iFirstId).
    RUN getSonVal IN hGenXml (INPUT iFirstId, INPUT "AccountNumber":U, OUTPUT tt-movto.ct-codigo).
    RUN getSonVal IN hGenXml (INPUT iFirstId, INPUT "SubAccountNumber":U, OUTPUT tt-movto.sc-codigo).
    RUN getSonVal IN hGenXml (INPUT iFirstId, INPUT "BusinessUnitCode":U, OUTPUT tt-movto.cod-unid-negoc).

    RUN searchTag IN hGenXml ("ApplicationAccount":U, 1, OUTPUT iFirstId).
      IF iFirstId <> ? THEN DO:
         RUN getSonVal IN hGenXml (INPUT iFirstId, INPUT "AccountNumber":U, OUTPUT tt-movto.ct-db).
         RUN getSonVal IN hGenXml (INPUT iFirstId, INPUT "SubAccountNumber":U, OUTPUT tt-movto.sc-db).
      END.

    RUN searchTag IN hGenXml ("FiscalOperation":U, 1, OUTPUT iFirstId).
      IF iFirstId <> ? THEN
         RUN getSonVal IN hGenXml (INPUT iFirstId, INPUT "FiscalOperationCode":U, OUTPUT tt-movto.nat-operacao).

    RUN searchTag IN hGenXml ("UnitOfMeasure":U, 1, OUTPUT iFirstId).
    RUN getSonVal IN hGenXml (INPUT iFirstId, INPUT "UnitOfMeasureID":U, OUTPUT tt-movto.un).

    IF tt-movto.un = "" OR tt-movto.un = ? THEN DO:
        FOR FIRST ITEM FIELDS(un) WHERE ITEM.it-codigo = tt-movto.it-codigo NO-LOCK :
            ASSIGN tt-movto.un = ITEM.un.
        END.
    END.
        

    RUN getSonDec IN hGenXml (INPUT 1, INPUT "Quantity":U, OUTPUT tt-movto.quantidade).
      IF tt-movto.quantidade = ? THEN ASSIGN tt-movto.quantidade = 0.

    RUN getSonDec IN hGenXml (INPUT 1, INPUT "NetWeight":U, OUTPUT tt-movto.peso-liquido).
      IF tt-movto.peso-liquido = ? THEN ASSIGN tt-movto.peso-liquido = 0.

    RUN getSonDec IN hGenXml (INPUT 1, INPUT "ValueType":U, OUTPUT tt-movto.tipo-valor).
      IF tt-movto.tipo-valor <> 1 AND tt-movto.tipo-valor <> 2 THEN 
         ASSIGN tt-movto.tipo-valor = 1.

    RUN searchTag IN hGenXml ("Document":U, 1, OUTPUT iDocumentId).
      IF iDocumentId <> ? THEN DO:
         RUN getSonDec IN hGenXml (INPUT iDocumentId, INPUT "DocumentType":U, OUTPUT tt-movto.esp-docto).
           IF tt-movto.esp-docto = ? THEN ASSIGN tt-movto.esp-docto = 6.
         RUN getSonVal IN hGenXml (INPUT iDocumentId, INPUT "DocumentSeries":U, OUTPUT tt-movto.serie-docto).
           IF tt-movto.serie-docto = ? THEN ASSIGN tt-movto.serie-docto = "".
         RUN getSonVal IN hGenXml (INPUT iDocumentId, INPUT "DocumentNumber":U, OUTPUT tt-movto.nro-docto).
           IF tt-movto.nro-docto = ? THEN ASSIGN tt-movto.nro-docto = "".
         RUN getSonDec IN hGenXml (INPUT iDocumentId, INPUT "DocumentSequence":U, OUTPUT tt-movto.sequen-nf).
           IF tt-movto.sequen-nf = ? THEN ASSIGN tt-movto.sequen-nf = 0.

         RUN searchTag IN hGenXml ("CurrentCurrencyDocumentValuesAndTaxes":U, iDocumentId, OUTPUT iId).
           IF iId <> ? THEN DO:
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "DocumentValue":U, OUTPUT tt-movto.valor-nota).
                IF tt-movto.valor-nota = ? THEN ASSIGN tt-movto.valor-nota = 0.
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "ServicesAndProductsCirculationTaxValue":U, OUTPUT tt-movto.valor-icm).
                IF tt-movto.valor-icm  = ? THEN ASSIGN tt-movto.valor-icm = 0.
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "IndustrializedProductTaxValue":U, OUTPUT tt-movto.valor-ipi).
                IF tt-movto.valor-ipi  = ? THEN ASSIGN tt-movto.valor-ipi = 0.
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "ServiceTaxValue":U, OUTPUT tt-movto.valor-iss).
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "SocialSecurityContributionTaxValue":U, OUTPUT tt-movto.valor-ggf-p[1]).
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "SocialIntegrationProgramTaxValue":U, OUTPUT tt-movto.valor-mob-p[1]).
           END.

         RUN searchTag IN hGenXml ("FASBDocumentValuesAndTaxes":U, iDocumentId, OUTPUT iId).
           IF iId <> ? THEN DO:
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "DocumentValue":U, OUTPUT tt-movto.vl-nota-fasb[1]).
                IF tt-movto.vl-nota-fasb[1] = ? THEN ASSIGN  tt-movto.vl-nota-fasb[1] = 0.
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "ServicesAndProductsCirculationTaxValue":U, OUTPUT tt-movto.vl-icm-fasb[1]).
                IF tt-movto.vl-icm-fasb[1] = ? THEN ASSIGN  tt-movto.vl-icm-fasb[1] = 0.
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "IndustrializedProductTaxValue":U, OUTPUT tt-movto.vl-ipi-fasb[1]).
                IF tt-movto.vl-ipi-fasb[1] = ? THEN ASSIGN  tt-movto.vl-ipi-fasb[1] = 0.
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "ServiceTax":U, OUTPUT tt-movto.vl-iss-fasb[1]).
                IF tt-movto.vl-iss-fasb[1] = ? THEN ASSIGN  tt-movto.vl-iss-fasb[1] = 0.
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "SocialSecurityContributionTaxValue":U, OUTPUT tt-movto.valor-ggf-p[2]).
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "SocialIntegrationProgramTaxValue":U, OUTPUT tt-movto.valor-mob-p[2]).
           END.

         RUN searchTag IN hGenXml ("CMIDocumentValuesAndTaxes":U, iDocumentId, OUTPUT iId).
           IF iId <> ? THEN DO:
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "DocumentValue":U, OUTPUT tt-movto.vl-nota-fasb[2]).
                IF tt-movto.vl-nota-fasb[2] = ? THEN ASSIGN  tt-movto.vl-nota-fasb[2] = 0.
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "ServicesAndProductsCirculationTaxValue":U, OUTPUT tt-movto.vl-icm-fasb[2]).
                IF tt-movto.vl-icm-fasb[2] = ? THEN ASSIGN  tt-movto.vl-icm-fasb[2] = 0.
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "IndustrializedProductTaxValue":U, OUTPUT tt-movto.vl-ipi-fas[2]).
                IF tt-movto.vl-ipi-fasb[2] = ? THEN ASSIGN  tt-movto.vl-ipi-fasb[2] = 0.
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "ServiceTax":U, OUTPUT tt-movto.vl-iss-fasb[2]).
                IF tt-movto.vl-iss-fasb[2] = ? THEN ASSIGN  tt-movto.vl-iss-fasb[2] = 0.
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "SocialSecurityContributionTaxValue":U, OUTPUT tt-movto.valor-ggf-p[3]).
              RUN getSonDec IN hGenXml (INPUT iId, INPUT "SocialIntegrationProgramTaxValue":U, OUTPUT tt-movto.valor-mob-p[3]).
           END.

      END.  /* iDocumentId */

    RUN getSonDec IN hGenXml (INPUT 1, INPUT "PurchaseOrderNumber":U, OUTPUT tt-movto.numero-ordem).

    RUN searchTag IN hGenXml ("ManufacturingOrder":U, 1, OUTPUT iFirstId).
      IF iFirstId <> ? THEN DO:
         RUN getSonDec  IN hGenXml (INPUT iFirstId, INPUT "ManufacturingOrderNumber":U, OUTPUT tt-movto.nr-ord-produ).
           IF tt-movto.nr-ord-produ = ? THEN ASSIGN  tt-movto.nr-ord-produ = 0.
         RUN getSonDec IN hGenXml (INPUT iFirstId, INPUT "ReportNumber":U, OUTPUT tt-movto.nr-report).
           IF tt-movto.nr-report = ? THEN ASSIGN tt-movto.nr-report = 0.
      END. 

    RUN searchTag  IN hGenXml ("OrderOperation":U, 1, OUTPUT iOrderOperationId).
      IF iOrderOperationId <> ? THEN DO:
         RUN getSonDec IN hGenXml (INPUT iOrderOperationId, INPUT "OrderOperationCode":U, OUTPUT tt-movto.op-codigo).
         RUN getSonDec IN hGenXml (INPUT iOrderOperationId, INPUT "OrderOperationSequenceNumber":U, OUTPUT tt-movto.op-seq).

         RUN searchTag IN hGenXml ("ManufactureRoute":U, iOrderOperationId, OUTPUT iId).
           IF iId <> ? THEN
              RUN getSonVal IN hGenXml (INPUT iId, INPUT "RouteID":U, OUTPUT tt-movto.cod-roteiro).

         RUN searchTag IN hGenXml ("ParentItem":U, iOrderOperationId, OUTPUT iId).
           IF iId <> ? THEN
              RUN getSonVal IN hGenXml (INPUT iId, INPUT "ParentItemCode":U, OUTPUT tt-movto.item-pai).
      END. /* iOrderOperation */

     RUN getSonDec IN hGenXml (INPUT 1, INPUT "ReferenceOrderNumber":U, OUTPUT tt-movto.nr-ord-refer).
     RUN getSonDec IN hGenXml (INPUT 1, INPUT "ProjectControlOrderNumber":U, OUTPUT tt-movto.num-ord-inv).
       if tt-movto.num-ord-inv = ? then assign tt-movto.num-ord-inv = 0.
     RUN getSonDec IN hGenXml (INPUT 1, INPUT "SummarizedRequisitionNumber":U, OUTPUT tt-movto.nr-req-sum).

     RUN searchTag  IN hGenXml ("TargetTransaction":U, 1, OUTPUT iTargetTransactionId).
       IF iTargetTransactionId <> ? THEN DO:
          RUN searchTag IN hGenXml ("TargetSite":U, iTargetTransactionId, OUTPUT iId).
          RUN getSonVal IN hGenXml (INPUT iId, INPUT "SiteID":U, OUTPUT tt-movto.cod-estabel-des).
          RUN getSonDec IN hGenXml (INPUT iTargetTransactionId, INPUT "TargetOrderNumber":U, OUTPUT tt-movto.num-ord-des).
          RUN getSonDec IN hGenXml (INPUT iTargetTransactionId, INPUT "TargetSequenceNumber":U, OUTPUT tt-movto.num-seq-des).
       END.

     RUN getSonDate IN hGenXml (INPUT 1, INPUT "IssueDocumentDate":U, OUTPUT tt-movto.dt-nf-saida).

     RUN searchTag IN hGenXml ("TransactionValues":U, 1, OUTPUT iTransactionValuesId).
       IF iTransactionValuesId <> ? THEN DO:     
          ASSIGN iCount = 1.

          RUN searchTag IN hGenXml ("ListOfBatchAverageValues":U, iTransactionValuesId, OUTPUT iBatchAverageValuesId).
            IF iBatchAverageValuesId <> ? THEN DO:
               RUN getFirstSonId IN hGenXml (iBatchAverageValuesId, OUTPUT iValuesId).
               DO WHILE iValuesId <> ?:

                  RUN getSonDec IN hGenXml (INPUT iValuesId, INPUT "MaterialValue":U, OUTPUT tt-movto.valor-mat-m[iCount]).
                    IF tt-movto.valor-mat-m[iCount] = ? THEN ASSIGN tt-movto.valor-mat-m[iCount] = 0.
                  RUN getSonDec IN hGenXml (INPUT iValuesId, INPUT "LaborValue":U, OUTPUT tt-movto.valor-mob-m[iCount]).
                    IF tt-movto.valor-mob-m[iCount] = ? THEN ASSIGN tt-movto.valor-mob-m[iCount] = 0.
                  RUN getSonDec IN hGenXml (INPUT iValuesId, INPUT "OverHeadValue":U, OUTPUT tt-movto.valor-ggf-m[iCount]).
                    IF tt-movto.valor-ggf-m[iCount] = ? THEN ASSIGN tt-movto.valor-ggf-m[iCount] = 0.

                  ASSIGN iId = iValuesId.

                  ASSIGN iCount = iCount + 1.

                  RUN GetNextSonId IN hGenXml (iBatchAverageValuesId, iId, OUTPUT iValuesId).
               END.
            END. /* iBatchAverageValuesId */

            ELSE DO:
              RUN searchTag IN hGenXml ("ListOfOnLineAverageValues":U, iTransactionValuesId, OUTPUT iOnLineAverageValuesId).
              IF iOnLineAverageValuesId <> ? THEN DO:
                 RUN getFirstSonId IN hGenXml (iOnLineAverageValuesId, OUTPUT iValuesId).
                 DO WHILE iValuesId <> ?:

                    RUN getSonDec IN hGenXml (INPUT iValuesId, INPUT "MaterialValue":U, OUTPUT tt-movto.valor-mat-m[iCount]).
                      IF tt-movto.valor-mat-m[iCount] = ? THEN ASSIGN tt-movto.valor-mat-m[iCount] = 0.
                    RUN getSonDec IN hGenXml (INPUT iValuesId, INPUT "LaborValue":U, OUTPUT tt-movto.valor-mob-m[iCount]).
                      IF tt-movto.valor-mob-m[iCount] = ? THEN ASSIGN tt-movto.valor-mob-m[iCount] = 0.
                    RUN getSonDec IN hGenXml (INPUT iValuesId, INPUT "OverHeadValue":U, OUTPUT tt-movto.valor-ggf-m[iCount]).
                      IF tt-movto.valor-ggf-m[iCount] = ? THEN ASSIGN tt-movto.valor-ggf-m[iCount] = 0.

                    ASSIGN iId = iValuesId.

                    ASSIGN iCount = iCount + 1.

                    RUN GetNextSonId IN hGenXml (iOnLineAverageValuesId, iId, OUTPUT iValuesId).
                 END.
            END. /* iOnLineAverageValuesId */

            ELSE DO:
                RUN searchTag IN hGenXml ("ListOfStandardCostValues":U, iTransactionValuesId, OUTPUT iStandardCostValuesId).
                IF iStandardCostValuesId <> ? THEN DO:
                   RUN getFirstSonId IN hGenXml (iStandardCostValuesId, OUTPUT iValuesId).
                   DO WHILE iValuesId <> ?:

                      RUN getSonDec IN hGenXml (INPUT iValuesId, INPUT "MaterialValue":U, OUTPUT tt-movto.valor-mat-m[iCount]).
                        IF tt-movto.valor-mat-m[iCount] = ? THEN ASSIGN tt-movto.valor-mat-m[iCount] = 0.
                      RUN getSonDec IN hGenXml (INPUT iValuesId, INPUT "LaborValue":U, OUTPUT tt-movto.valor-mob-m[iCount]).
                        IF tt-movto.valor-mob-m[iCount] = ? THEN ASSIGN tt-movto.valor-mob-m[iCount] = 0.
                      RUN getSonDec IN hGenXml (INPUT iValuesId, INPUT "OverHeadValue":U, OUTPUT tt-movto.valor-ggf-m[iCount]).
                        IF tt-movto.valor-ggf-m[iCount] = ? THEN ASSIGN tt-movto.valor-ggf-m[iCount] = 0.

                      ASSIGN iId = iValuesId.

                      ASSIGN iCount = iCount + 1.

                      RUN GetNextSonId IN hGenXml (iStandardCostValuesId, iId, OUTPUT iValuesId).
                   END.
                END. /* iStandardCostValuesId */
            END.

            END.
       END. /* iTransactionValuesId */

       
 IF cTranAction = "add":U THEN DO:

     ASSIGN tt-movto.cod-versao-integracao = 1
     	    tt-movto.cod-prog-orig         = "AXRAR001":U.

    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    
        IF CAN-FIND (FIRST funcao 
                     WHERE funcao.cd-funcao = "spp-integra-ems-his"
                     AND   funcao.ativo     = yes) THEN DO:
            
            RUN cep/ceapi304.p (INPUT-OUTPUT TABLE tt-movto,
                                INPUT-OUTPUT TABLE tt-erro) NO-ERROR.
            
            IF NOT CAN-FIND(first tt-erro) AND ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execu‡Æo do programa */
                DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                   cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
                END.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Erro_de_integra‡Æo._Erro_ao_executar_o_programa_'cep/ceapi304.p'_pelo_programa_adapters/xml/ar2/axrar001.p._Durante_sua_execu‡Æo_ocorreu_o(s)_seguinte(s)_erro(s)_de_Progress" *}
                RUN setError IN hMessageHandler (INPUT 0,
                                                 INPUT "enviroment_error":U,
                                                 INPUT RETURN-VALUE + ': ' + cErrorText).
                CREATE tt_log_erro.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Erro_de_integra‡Æo._Erro_ao_executar_o_programa_'cep/ceapi304.p'_pelo_programa_adapters/xml/ar2/axrar001.p._Durante_sua_execu‡Æo_ocorreu_o(s)_seguinte(s)_erro(s)_de_Progress" *}
                ASSIGN tt_log_erro.ttv_num_cod_erro = 0
                       tt_log_erro.ttv_des_msg_erro = RETURN-VALUE + ': ' + cErrorText.
            END.
            ELSE DO: /* Erros ocorridos durante efetiva‡Æo do registro */
               FOR EACH tt-erro:
                    RUN setError IN hMessageHandler (INPUT tt-erro.cd-erro,
                                                     INPUT "business_error":U,  /* Erro de neg¢cio */
                       	                           INPUT tt-erro.mensagem).
                    CREATE tt_log_erro.
                    ASSIGN tt_log_erro.ttv_num_cod_erro = tt-erro.cd-erro
                           tt_log_erro.ttv_des_msg_erro = tt-erro.mensagem.
               END.
            END.
        END.
    &ENDIF
    

    /* valida‡Æo inclu¡da */
    REPEAT WHILE PROGRAM-NAME(level) <> ?.
        IF  PROGRAM-NAME(level) matches("*ft2100*") OR 
            PROGRAM-NAME(level) matches("*ft2010*") THEN DO:
            ASSIGN l-ft2100 = YES.                        
            LEAVE.
        END.
        level = level + 1.
    END.
    
    IF NOT l-ft2100 THEN   /*valida‡Æo inclu¡da at‚ aqui */
        IF SEARCH("cep/ceapi001k.r":U) <> ? THEN DO:
          
          IF l-integra-ems-his THEN DO:
            
              RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k. /*ceapi001j*/

              RUN pi-execute-cod-barras  IN h-ceapi001k (INPUT-OUTPUT TABLE tt-movto,
                                                         INPUT-OUTPUT TABLE tt-erro,
                                                         INPUT YES).

              delete procedure h-ceapi001k.
          END.
          ELSE DO:

              RUN cep/ceapi001k.p persistent set h-ceapi001k.
              run pi-execute IN h-ceapi001k (input-output table tt-movto,
                                             input-output table tt-erro,
                                             input yes) no-error.

              if can-find(first tt-erro) or return-value = "NOK":U then do:
                        
                            RUN setError IN hMessageHandler  (INPUT 0,
                                                              INPUT "business_warning":U,
                                                              INPUT RETURN-VALUE + "." ).
              end.
                                           
              if  valid-handle (h-ceapi001k) then do: 
                  delete procedure h-ceapi001k.
                  assign h-ceapi001k = ?.
              end.
          end.
    
          IF NOT CAN-FIND(first tt-erro) AND ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execu‡Æo do programa */
              DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
                 cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
              END.
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Erro_de_integra‡Æo._Erro_ao_executar_o_programa_'cep/ceapi001k.p'_pelo_programa_adapters/xml/ar2/axrar001.p._Durante_sua_execu‡Æo_ocorreu_o(s)_seguinte(s)_erro(s)_de_Progress" *}
              RUN setError IN hMessageHandler (INPUT 0,
                                               INPUT "enviroment_error":U,
                                               INPUT RETURN-VALUE + ': ' + cErrorText).
              CREATE tt_log_erro.
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Erro_de_integra‡Æo._Erro_ao_executar_o_programa_'cep/ceapi001k.p'_pelo_programa_adapters/xml/ar2/axrar001.p._Durante_sua_execu‡Æo_ocorreu_o(s)_seguinte(s)_erro(s)_de_Progress" *}
              ASSIGN tt_log_erro.ttv_num_cod_erro = 0
                     tt_log_erro.ttv_des_msg_erro = RETURN-VALUE + ': ' + cErrorText.
          END.
          ELSE DO: /* Erros ocorridos durante efetiva‡Æo do registro */
             FOR EACH tt-erro:
                  RUN setError IN hMessageHandler (INPUT tt-erro.cd-erro,
                                                   INPUT "business_error":U,  /* Erro de neg¢cio */
                     	                           INPUT tt-erro.mensagem).
                  CREATE tt_log_erro.
                  ASSIGN tt_log_erro.ttv_num_cod_erro = tt-erro.cd-erro
                         tt_log_erro.ttv_des_msg_erro = tt-erro.mensagem.
             END.
          END.
    
        END.
        ELSE DO: /* Programa de efetiva‡Æo nÆo localizado */
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Erro_de_integra‡Æo._NÆo_foi_poss¡vel_localizar_o_programa_'cep/ceapi001k.p'_a_ser_executado_pelo_programa_adapters/xml/ar2/axrar001.p" *}
              RUN setError IN hMessageHandler (INPUT 0,
                                               INPUT "enviroment_error":U,
                                               INPUT RETURN-VALUE + '.').
              CREATE tt_log_erro.
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Erro_de_integra‡Æo._NÆo_foi_poss¡vel_localizar_o_programa_'cep/ceapi001k.p'_a_ser_executado_pelo_programa_adapters/xml/ar2/axrar001.p" *}
              ASSIGN tt_log_erro.ttv_num_cod_erro = 0
                     tt_log_erro.ttv_des_msg_erro = RETURN-VALUE + '.'.
        END.

  END.

/*   if hMessageHandler:GET-SIGNATURE("setExtraInformation":U) <> "":U then do:            */
/*       for each tt-movto:                                                                */
/*           RUN setExtraInformation IN hMessageHandler ("nr-trans":U, tt-movto.nr-trans). */
/*       end.                                                                              */
/*   END.                                                                                  */

  /* ---  Knupp - Mensagem de retorno das movimentacoes de Estoque  --- */
  if hMessageHandler:GET-SIGNATURE("setExtraInformation":U) <> "":U and 
     CAN-FIND(FIRST tt-movto WHERE tt-movto.nr-trans <> 0) then do:
        run adapters/xml/ar2/axnar001.p persistent set  h-axnar001  (input table tt-movto,
                                                                     input "axnar001",
                                                                     input "001",
                                                                     input "ADD",
                                                                     input i-TransactionNumberExternal,
                                                                     output table tt_log_erro).
        
        for each tt_log_erro no-lock:
            run utp/ut-msgs.p (input "msg", 
                               input 17006  ,
                               input tt_log_erro.ttv_des_msg_erro  ).
    
            RUN setError IN hMessageHandler (INPUT 17009,
                                             INPUT "business_error":U, 
                                             INPUT tt_log_erro.ttv_des_msg_erro).
        end.
        IF VALID-HANDLE(h-axnar001) THEN
            DELETE PROCEDURE h-axnar001.
  END.

    /* --- Knupp - Seta para o Adapter que a transacao contem Erro --- */
    IF CAN-FIND(FIRST tt_log_erro) THEN 
            ASSIGN lSuccessProcess = NO
                   cReturnValue   = "NOK".

  /* Obtem mensagem de retorno (erro ou confirmacao) */
  RUN getReturnMessage IN hMessageHandler (OUTPUT hOutputXML). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
