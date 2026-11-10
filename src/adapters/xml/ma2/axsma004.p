/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSMA004 2.00.00.012 } /*** 010012 ***/



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
    File        : AXSMA004.p
    Purpose     : ADAPTER DE ENVIO DE FAMILIA MATERIAIS

    Syntax      :

    Description : ADAPTER DE ENVIO DE FAMILIA MATERIAIS
    Author(s)   : Vanessa Hermesdorff - ksm15154
    CREATEd     : 29/12/2003 10:00
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */

/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlTranName      MaterialFamily
&GLOBAL-DEFINE XmlTranVersion   204.000
&GLOBAL-DEFINE XmlProdName      EMS2
&GLOBAL-DEFINE XmlProdVersion   204
&GLOBAL-DEFINE XmlApp           MA2 
&GLOBAL-DEFINE XmlMod           ENP

DEFINE TEMP-TABLE tt-familia NO-UNDO LIKE familia.

/* Defini‡Æo temp-table RowErrors */
{cdp/cd9043.i}
{cdp/cd9043.i1}


/*Parƒmetros de entrada*/
DEF INPUT PARAM pTranAction  AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgName    AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgVersion AS CHAR    NO-UNDO.
DEF INPUT PARAM pXmlMod      AS CHAR    NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-familia.
DEF OUTPUT PARAM TABLE FOR RowErrors.

/* Vari veis Globais */
DEF VAR hGenXml          AS HANDLE NO-UNDO.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.

/* Variaveis da constru‡Æo do BusinessContent Utilizando APIXML */
DEF VAR iId         AS INT NO-UNDO.
DEF VAR iFirstId    AS INT NO-UNDO. 
DEF VAR iIdWareHouse  AS INT NO-UNDO.
DEF VAR iIdCurr       AS INT NO-UNDO.
DEF VAR iIdBuyer      AS INT NO-UNDO.
DEF VAR iIdUnitOfMeasure  AS INT NO-UNDO.
DEF VAR iIdFamilyMaint    AS INT NO-UNDO.
DEF VAR iIdLocation       AS INT NO-UNDO.
DEF VAR iIdPlanner        AS INT NO-UNDO.
DEF VAR iIdProdLine       AS INT NO-UNDO.
DEF VAR iIdSeasonality    AS INT NO-UNDO.
DEF VAR iIdTargetList     AS INT NO-UNDO.
DEF VAR iIdApLevel        AS INT NO-UNDO.
DEF VAR iIdScrapItem      AS INT NO-UNDO.
DEF VAR iIdQuality        AS INT NO-UNDO.
DEF VAR iIdInventory      AS INT NO-UNDO.
DEF VAR iIdSecurity       AS INT NO-UNDO.
DEF VAR iIdCount          AS INT NO-UNDO.
DEF VAR iIdWeightFactor   AS INT NO-UNDO.
DEF VAR iIdPurchase       AS INT NO-UNDO.
DEF VAR iIdFiscal         AS INT NO-UNDO.
DEF VAR iIdPurchaseGroupStandard AS INT NO-UNDO.
DEF VAR iIdPurchaseGroupOnLine   AS INT NO-UNDO.
DEF VAR iIdService   AS INT NO-UNDO.
DEF VAR iIdRate      AS INT NO-UNDO.
DEF VAR iIdManufacture  AS INT NO-UNDO.
DEF VAR iIdUser  AS INT NO-UNDO.
DEF VAR iIdPurchaseGroup AS INT NO-UNDO.
DEF VAR iIdFiscalClassification AS INT NO-UNDO.
DEF VAR iIdSalesTax AS INT NO-UNDO.


DEFINE VARIABLE iIdValue AS INTEGER    NO-UNDO.

/* Vari veis para armazenar valores da inicializa‡Æo do loalMessageHandler */
DEF VAR hMessageHandler AS HANDLE NO-UNDO.
DEF VAR cReturnValue    AS CHAR   NO-UNDO.

/*Vari veis locais*/
DEF VAR pSendSuccess  AS LOG INITIAL YES NO-UNDO.
DEF VAR lCREATEMsg    AS LOG             NO-UNDO.
DEF VAR pTotalErrors  AS INT             NO-UNDO.
DEF VAR pErrorNumber  AS INT             NO-UNDO.
DEF VAR pErrorType    AS CHAR            NO-UNDO.
DEF VAR pErrorDesc    AS CHAR            NO-UNDO.
DEF VAR iCount        AS INT             NO-UNDO.
DEF VAR i-cont-err    AS INT             NO-UNDO.
DEF VAR l-logical     AS LOG             NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

/* _UIB-CODE-BLOCK-END */
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

/* *************************  CREATE Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 25.46
         WIDTH              = 36.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
{utp/ut-glob.i}
{cdp/cdcfgman.i} 

/* Verifica se h  registros na temp-table */
IF NOT CAN-FIND(FIRST tt-familia) THEN DO:

    {utp/ut-liter.i Fam¡lia_de_Materiais_para_Integra‡Æo_EAI * r}
    run piCriaErro (5561,
                    'EMS':U, 
                    TRIM(return-value)).
     RETURN "NOK":U.
     LEAVE.
END.

FOR EACH tt-familia NO-LOCK:

    /* Verifica se MessageHandler.p está  na mem¢ria */
    {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

    /* Verifica se o MessageHandler foi executado corretamente */
    IF cReturnValue <> "OK":U THEN DO:
         IF cReturnValue <> ? AND cReturnValue <> " " THEN DO:
             run piCriaErro (17006,
                             'EMS':U, 
                             cReturnValue).
                 RETURN "NOK":U.
                 LEAVE.
         END.
    END.

    /* Verifica se h  programas inscritos */
    RUN isSubscribed IN hMessageHandler (INPUT "{&XmlProdName}",
                                         INPUT "{&XmlApp}",
                                         INPUT "{&XmlTranName}",
                                         INPUT "{&XmlTranVersion}",
                                         INPUT "MaterialFamily",
                                         INPUT pTranAction,
                                         OUTPUT lCREATEMsg).

   /*Verifica se a transa‡Æo ‚ assinada*/
      IF NOT lCREATEMsg THEN
         RETURN "OK":U.

    /* Preenche o valor do elemento Comment de TransactionId */
    RUN setTransInfoComment IN hMessageHandler ("Program:" + pProgName + "-" +
                                                "Version:" + pProgVersion). 

    /*Seta SystemID*/
    RUN setSystemId IN hMessageHandler (pXmlMod,              /* Nome do modulo */
                                        "{&XmlProdVersion}"). /* Versao do Programa */

    /* Indica valor da chave prim ria da transa‡Æo */
    RUN setKeyFields IN hMessageHandler ("familia.fm-codigo",
                                         STRING(tt-familia.fm-codigo)). 

    /* Seta a empresa e o estabelecimento */
    RUN setCompanyId IN hMessageHandler (STRING(v_cdn_empres_usuar), ""). 

    /* Verifica se API est  na mem¢ria */
    {xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}

    /* Verifica se o ut-genxml foi executado corretamente */
    IF cReturnValue <> "OK":U THEN DO:
         IF cReturnValue <> ? AND cReturnValue <> "" THEN DO:
             run piCriaErro (17006,
                             'EMS':U, 
                             cReturnValue).
          RETURN "NOK":U.
          LEAVE.
         END.
     END.

    /* Cria mensagem do BusinessContent atrav‚s da API*/
    CREATE-BUSINESS-XML:
    DO:
        /* RESETA OS VALORES */
        RUN reset IN hGenXml.

        /* SETA VALOR DE ENCODING */
        RUN setEncoding IN hGenXml ("UTF-8").

        IF pTranAction = "ADD" OR pTranAction = "UPD" THEN DO:

            /* Nà PRINCIPAL UPSERT */
            RUN addNode IN hGenXml (0,
                                    "Upsert",
                                    "",
                                    OUTPUT iFirstId).

            RUN addNode IN hGenXml (iFirstId, "MaterialFamilyCode", tt-familia.fm-codigo, OUTPUT iId).

            RUN addNode IN hGenXml (iFirstId,"MaterialFamilyDescription", SUBSTRING(tt-familia.descricao, 1,30), OUTPUT iId).

            &IF DEFINED (bf_man_206) &THEN 
                RUN addNode IN hGenXml (iFirstId, "FamilyClassification", STRING(tt-familia.idi-classif-item), OUTPUT iId).
            &ELSE
                IF   pTranAction = "UPD" THEN DO:
                     FIND FIRST familia WHERE familia.fm-codigo = tt-familia.fm-codigo NO-LOCK NO-ERROR.
                     IF AVAIL familia THEN DO:
                        RUN addNode IN hGenXml (iFirstId, "FamilyClassification", SUBSTRING(tt-familia.char-1,19,1), OUTPUT iId).  
                     END.
                END.
                ELSE RUN addNode IN hGenXml (iFirstId, "FamilyClassification", SUBSTRING(tt-familia.char-1,19,1), OUTPUT iId).
            &ENDIF

            /* Adiciona informacoes da Unidade de Medida */
            RUN addNode IN hGenXml (iFirstId, "UnitOfMeasure", "", OUTPUT iId).
            RUN addNode IN hGenXml (iId, "UnitOfMeasureCode", tt-familia.un, OUTPUT iIdUnitOfMeasure).
            FIND FIRST tab-unidade WHERE tab-unidade.un = tt-familia.un  NO-LOCK NO-ERROR. 
            IF AVAIL tab-unidade THEN
               RUN addNode IN hGenXml (iId, "UnitOfMeasureDescription", SUBSTRING(tab-unidade.descricao,1,15), OUTPUT iIdUnitOfMeasure).

            /*************************************************/
            /* Adiciona informacoes da Manuten‡Æo da Familia */
            /*************************************************/
            RUN addNode IN hGenXml (iFirstId, "FamilyMaintenance", "", OUTPUT iId).

            /* Adiciona informacoes do Deposito */
            RUN addNode IN hGenXml (iId, "WareHouse", "", OUTPUT iIdFamilyMaint).
            RUN addNode IN hGenXml (iIdFamilyMaint, "WareHouseCode", tt-familia.deposito-pad, OUTPUT iIdWareHouse).
            FIND FIRST deposito WHERE deposito.cod-depos = tt-familia.deposito-pad  NO-LOCK NO-ERROR. 
            IF AVAIL deposito THEN
               RUN addNode IN hGenXml (iIdFamilyMaint, "WareHouseDescription", SUBSTRING(deposito.nome,1,40), OUTPUT iIdWareHouse).

            RUN addNodeLog IN hGenXml (iId,"IsUniquePhysicalLocation",tt-familia.loc-unica,OUTPUT iIdFamilyMaint).

            /* Adiciona informacoes da Localiza‡Æo */
            RUN addNode IN hGenXml (iId, "Location", "", OUTPUT iIdFamilyMaint).
            RUN addNode IN hGenXml (iIdFamilyMaint, "LocationCode", tt-familia.cod-localiz, OUTPUT iIdLocation).
            FIND FIRST localizacao WHERE localizacao.cod-localiz = tt-familia.cod-localiz NO-LOCK NO-ERROR.
            IF AVAIL localizacao THEN
               RUN addNode IN hGenXml (iIdFamilyMaint, "LocationDescription", SUBSTRING(localizacao.descricao,1,30), OUTPUT iIdLocation).

            /* Adiciona informacoes do Planejador */
            RUN addNode IN hGenXml (iId, "Planner", "", OUTPUT iIdFamilyMaint).
            RUN addNode IN hGenXml (iIdFamilyMaint, "PlannerCode", tt-familia.cd-planejado, OUTPUT iIdPlanner).
            FIND FIRST planejad WHERE planejad.cd-planejado = tt-familia.cd-planejado NO-LOCK NO-ERROR.
            IF AVAIL planejad THEN
               RUN addNode IN hGenXml (iIdFamilyMaint, "PlannerDescription", SUBSTRING(planejad.nome,1,12), OUTPUT iIdPlanner).

            /* Politica dos Itens da Familia - Valores validos conforme include ininc~\i04in122.i [Default 1]*/
            IF tt-familia.politica >= 1 AND tt-familia.politica <= 6 THEN
                RUN addNodeDec IN hGenXml (iId, "Policy", tt-familia.politica, OUTPUT iIdFamilyMaint).
            ELSE RUN addNodeDec IN hGenXml (iId, "Policy", 1, OUTPUT iIdFamilyMaint).

            RUN addNodeDec IN hGenXml (iId, "EconomicLot", tt-familia.lote-economi, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "MultipleBatch", tt-familia.lote-multipl, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "MinimumLot", tt-familia.lote-minimo,     OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "FixedPeriod", tt-familia.periodo-fixo,   OUTPUT iIdFamilyMaint).

            /* Adiciona informacoes da Moeda Padrao */
            RUN addNode IN hGenXml (iId, "StandardCurr", "", OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iIdFamilyMaint, "StandardCurrCode", tt-familia.moeda-padrao, OUTPUT iIdCurr).
            FIND FIRST moeda WHERE moeda.mo-codigo = tt-familia.moeda-padrao  NO-LOCK NO-ERROR. 
            IF AVAIL moeda THEN
               RUN addNode IN hGenXml (iIdFamilyMaint, "StandardCurrDescription", SUBSTRING(moeda.descricao,1,12), OUTPUT iIdCurr).

            RUN addNodeDec IN hGenXml (iId, "PurchaseLeadTime", tt-familia.res-int-comp, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "VendorLeadTime", tt-familia.res-for-comp, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "ManufacturingLeadTime", tt-familia.ressup-fabri, OUTPUT iIdFamilyMaint).

            /* Valores validos conforme include ininc~\i06in122.i [Default 1]*/
            IF tt-familia.classe-repro >= 1 AND tt-familia.classe-repro <= 6 THEN
               RUN addNodeDec IN hGenXml (iId, "ReschedulingClass", tt-familia.classe-repro, OUTPUT iIdFamilyMaint).
            ELSE RUN addNodeDec IN hGenXml (iId, "ReschedulingClass", 1, OUTPUT iIdFamilyMaint).

            /* Codigo Origem - Valores validos conforme include ininc~\i18in122.i [Default 1]*/
            IF tt-familia.codigo-orig >= 1 AND tt-familia.codigo-orig <= 99 THEN
               RUN addNodeDec IN hGenXml (iId, "SourceCode", tt-familia.codigo-orig, OUTPUT iIdFamilyMaint).
               ELSE RUN addNodeDec IN hGenXml (iId, "SourceCode", 1, OUTPUT iIdFamilyMaint).

            RUN addNodeDec IN hGenXml (iId, "ConversionFactor", tt-familia.fator-conver, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "IssueType", tt-familia.tipo-requis, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "ForecastConsumptionIndex", tt-familia.ind-cons-prv, OUTPUT iIdFamilyMaint). 

            /* Adiciona informacoes da Linha de Producao */
            RUN addNode IN hGenXml (iId, "ProductionLine", "", OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iIdFamilyMaint, "ProductionLineCode", tt-familia.nr-linha, OUTPUT iIdProdLine).
            FIND FIRST lin-prod WHERE lin-prod.nr-linha = tt-familia.nr-linha  NO-LOCK NO-ERROR. 
            IF AVAIL lin-prod THEN
               RUN addNode IN hGenXml (iIdFamilyMaint, "ProductionLineDescription", SUBSTRING(lin-prod.descricao,1,30), OUTPUT iIdProdLine). 

            RUN addNodeDec IN hGenXml (iId, "ReportLabor", tt-familia.reporte-mob, OUTPUT iIdFamilyMaint).

            /* Tipo Controle - Valores validos conforme include ininc~\i09in122.i [Default 2]*/
            IF tt-familia.tipo-contr >= 1 AND tt-familia.tipo-contr <= 4 THEN
               RUN addNodeDec IN hGenXml (iId, "ControlType", tt-familia.tipo-contr, OUTPUT iIdFamilyMaint).
            ELSE RUN addNodeDec IN hGenXml (iId, "ControlType", 2, OUTPUT iIdFamilyMaint).

            RUN addNodeDec IN hGenXml (iId, "ItemDescType", tt-familia.ind-imp-desc, OUTPUT iIdFamilyMaint).
            RUN addNodeLog IN hGenXml (iId, "IsFamilyQuantityInvoice", tt-familia.ind-inf-qtf, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "MaxStorageCapacityPlant", tt-familia.cap-est-fabr, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "VariationQuantityReceipt", tt-familia.var-quant, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "CostVariation", tt-familia.var-preco, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "OrderDivision", tt-familia.div-ordem, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "AllowedQuantityVariation", tt-familia.var-qtd-perm, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "AllowedPriceVariation", tt-familia.var-pre-perm, OUTPUT iIdFamilyMaint).

            /*Verifica se ha informacoes da Sazonalidade e adiciona [Extent 12]*/
            Add-ListOfSeasonality:
            DO iCount = 1 TO 12:
              IF tt-familia.sazonalidade[iCount] <> 0 THEN DO:
                 RUN addNode IN hGenXml (iId, "ListOfSeasonality", "", OUTPUT iIdFamilyMaint).
                  DO iCount = 1 TO 12:
                     IF tt-familia.sazonalidade[iCount] <> 0 THEN DO:
                         RUN addNode IN hGenXml (iIdFamilyMaint, "Seasonality", "", OUTPUT iIdValue).
                         RUN addNodeDec IN hGenXml (iIdValue, "SeasonalityCode", tt-familia.sazonalidade[iCount], OUTPUT iIdSeasonality).
                     END.
                  END.
                  LEAVE Add-ListOfSeasonality.
              END.
            END.

            RUN addNodeDec IN hGenXml (iId, "ProductionReport", tt-familia.rep-prod, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "FormulationCode", tt-familia.cd-formula, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "CodeSource", tt-familia.cd-origem, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "TypeConsumptionoverSalesForecasting", tt-familia.tp-cons-prev, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "PoliticsLotAdministration", tt-familia.tp-adm-lote, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "Priority", tt-familia.prioridade, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "Scheduling", tt-familia.tipo-sched, OUTPUT iIdFamilyMaint).
            RUN addNodeLog IN hGenXml (iId, "IsConfigUpdate", tt-familia.atu-conf, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "FixedHorizon", tt-familia.horiz-fixo, OUTPUT iIdFamilyMaint).

            &IF DEFINED (bf_man_205) &THEN
                 RUN addNode IN hGenXml (iId, "ReleaseHorizon", SUBSTRING(tt-familia.char-1,129,3), OUTPUT iIdFamilyMaint).
            &ENDIF

            RUN addNodeDec IN hGenXml (iId, "VariationOfQuantityRequestLower", tt-familia.var-req-menor, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "VariationOfQuantityRequestOver", tt-familia.var-req-maior, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "VariationQuantityReport", tt-familia.var-rep, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "VariationQuantityTransfered", tt-familia.var-transf, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "QuantityMaximumOrder", tt-familia.qt-max-ordem, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "LaborVariationOver", tt-familia.var-mob-maior, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "LaborVariationUnder", tt-familia.var-mob-menor, OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iId, "TypeAllot", tt-familia.sit-aloc, OUTPUT iIdFamilyMaint).                   

            /* Adiciona informacoes da Lista Destino */
            IF CONNECTED("mgmp") THEN DO:
                RUN adapters/xml/ma2/axsma004a.p (INPUT TABLE   tt-familia,
                                                  input-output  hGenXml,
                                                  input         iId,
                                                  input         iIdFamilyMaint).
            END.
            /*RUN addNode IN hGenXml (iId, "TargetList", "", OUTPUT iIdFamilyMaint).
            RUN addNode IN hGenXml (iIdFamilyMaint, "TargetListCode", tt-familia.cod-lista-destino, OUTPUT iIdTargetList).
            FIND FIRST lista-destino WHERE lista-destino.cd-lista-destino = tt-familia.cod-lista-destino NO-LOCK NO-ERROR. 
            IF AVAIL lista-destino THEN
               RUN addNode IN hGenXml (iIdFamilyMaint, "TargetListDescription", SUBSTRING(lista-destino.desc-lista-dest,1,30), OUTPUT iIdTargetList). */

            RUN addNodeLog IN hGenXml (iId, "IsUpdatedViaMultiPlant", tt-familia.log-atualiz-via-mmp, OUTPUT iIdFamilyMaint).
            RUN addNodeLog IN hGenXml (iId, "IsConvertInsuranceTime", tt-familia.conv-tempo-seg, OUTPUT iIdFamilyMaint).

            /* Adiciona informacoes do Nivel de Aprovacao */
            RUN addNode IN hGenXml (iId, "ApprovalLevel", "", OUTPUT iIdFamilyMaint).
            RUN addNodeDec IN hGenXml (iIdFamilyMaint, "EletronicApprovalRequisition", tt-familia.nivel-apr-requis, OUTPUT iIdApLevel).
            RUN addNodeDec IN hGenXml (iIdFamilyMaint, "EletronicApprovalRequest", tt-familia.nivel-apr-solic, OUTPUT iIdApLevel). 
            RUN addNodeDec IN hGenXml (iIdFamilyMaint, "MaintenanceEletronicApproval", tt-familia.nivel-apr-manut, OUTPUT iIdApLevel). 
            RUN addNodeDec IN hGenXml (iIdFamilyMaint, "OrdersEletronicApproval", tt-familia.nivel-apr-compra, OUTPUT iIdApLevel). 

            RUN addNodeDec IN hGenXml (iId, "ForecastDemand", tt-familia.ind-prev-demanda, OUTPUT iIdFamilyMaint).                   
            RUN addNodeDec IN hGenXml (iId, "ProductionTargetCalculateCriteria", tt-familia.ind-calc-meta, OUTPUT iIdFamilyMaint).  
            RUN addNodeLog IN hGenXml (iId, "IsUseBatchStandard", tt-familia.log-utiliza-batch-padrao, OUTPUT iIdFamilyMaint).  
            RUN addNodeDec IN hGenXml (iId, "StandardBatchSize", tt-familia.qtd-batch-padrao, OUTPUT iIdFamilyMaint).  
            RUN addNodeDec IN hGenXml (iId, "MfactureGeneralExpensesReport", tt-familia.reporte-ggf, OUTPUT iIdFamilyMaint).  
            RUN addNodeDec IN hGenXml (iId, "ListForRequirementsScheduling", tt-familia.ind-lista-mrp, OUTPUT iIdFamilyMaint).  
            RUN addNodeDec IN hGenXml (iId, "FamilyIdentify", tt-familia.num-id-familia, OUTPUT iIdFamilyMaint).  
            &IF DEFINED (bf_man_205) &THEN
                RUN addNode IN hGenXml (iId, "FreightClassCode", tt-familia.cod-classe-frete, OUTPUT iIdFamilyMaint).  
            &ENDIF
            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeDec IN hGenXml (iId, "ReorderPoint", tt-familia.pto-repos, OUTPUT iIdFamilyMaint).  
            &ENDIF
            &IF DEFINED (bf_man_205) &THEN
                RUN addNode IN hGenXml (iId, "Replenishment", tt-familia.pto-repos, OUTPUT iIdFamilyMaint).  
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeDec IN hGenXml (iId, "MinimumReplenishment", tt-familia.qtd-min-reabast, OUTPUT iIdFamilyMaint).  
            &ELSE RUN addNodeDec IN hGenXml (iId, "MinimumReplenishment", DECIMAL(SUBSTRING(tt-familia.char-1,20,12)), OUTPUT iIdFamilyMaint).  
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNode IN hGenXml (iId, "LeadTimeVariance", tt-familia.cod-var-tempo-res, OUTPUT iIdFamilyMaint).  
            &ELSE RUN addNode IN hGenXml (iId, "LeadTimeVariance", SUBSTRING(tt-familia.char-1,15,4), OUTPUT iIdFamilyMaint).  
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeDec IN hGenXml (iId, "ReplenishmentQuantity", tt-familia.qtd-var-ressup, OUTPUT iIdFamilyMaint).  
            &ELSE RUN addNodeDec IN hGenXml (iId, "ReplenishmentQuantity", DECIMAL(SUBSTRING(tt-familia.char-1,35,12)), OUTPUT iIdFamilyMaint).  
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeDec IN hGenXml (iId, "RevenueExpenseType", tt-familia.cdn-tipo-rec-desp, OUTPUT iIdFamilyMaint).  
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeDec IN hGenXml (iId, "ExpenseType", tt-familia.cdn-nat-desp, OUTPUT iIdFamilyMaint).  
            &ENDIF

            /* Politica APS - Valores validos conforme include ininc~\i21in122.i */
            &IF DEFINED (bf_man_205) &THEN
                IF tt-familia.politica-aps >= 1 AND tt-familia.politica-aps <= 9 THEN
                   RUN addNodeDec IN hGenXml (iId, "PolicyAdvancedPlanningSchedule", tt-familia.politica-aps, OUTPUT iIdFamilyMaint).  
            &ELSE 
                IF INTEGER(SUBSTRING(tt-familia.char-1,60,2)) >= 1 AND INTEGER(SUBSTRING(tt-familia.char-1,60,2)) <= 9 THEN
                   RUN addNodeDec IN hGenXml (iId, "PolicyAdvancedPlanningSchedule", INTEGER(SUBSTRING(tt-familia.char-1,60,2)), OUTPUT iIdFamilyMaint).  
            &ENDIF

            /* Geracao de Ordem - Valores validos conforme include ininc~\i01in521.i */
            &IF DEFINED (bf_man_205) &THEN
                IF tt-familia.geracao-ordem >= 1 AND tt-familia.geracao-ordem <= 7 THEN
                   RUN addNodeDec IN hGenXml (iId, "OrderGeneration", tt-familia.geracao-ordem, OUTPUT iIdFamilyMaint).  
            &ELSE 
                IF INTEGER(SUBSTRING(tt-familia.char-1,62,1)) >= 1 AND INTEGER(SUBSTRING(tt-familia.char-1,62,1)) <= 7 THEN            
                   RUN addNodeDec IN hGenXml (iId, "OrderGeneration", INTEGER(SUBSTRING(tt-familia.char-1,62,1)), OUTPUT iIdFamilyMaint).  
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeLog IN hGenXml (iId, "IsUsageProduct", tt-familia.cons-produto, OUTPUT iIdFamilyMaint).  
            &ENDIF                                                                

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeLog IN hGenXml (iId, "IsIncludeOn-HandBalance", tt-familia.cons-saldo, OUTPUT iIdFamilyMaint).  
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeLog IN hGenXml (iId, "IsRestrictedRawMaterial", tt-familia.mp-restrit, OUTPUT iIdFamilyMaint).
            &ELSE
                 IF SUBSTRING(tt-familia.char-1,65,1) = "1" THEN ASSIGN l-logical = YES. ELSE ASSIGN l-logical = NO.
                 RUN addNodeLog IN hGenXml (iId, "IsRestrictedRawMaterial", l-logical, OUTPUT iIdFamilyMaint).
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeDec IN hGenXml (iId, "QuantityMaximum", tt-familia.qtde-max, OUTPUT iIdFamilyMaint).  
            &ELSE RUN addNodeDec IN hGenXml (iId, "QuantityMaximum", DECIMAL(SUBSTRING(tt-familia.char-1,117,11)), OUTPUT iIdFamilyMaint).  
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeDec IN hGenXml (iId, "FixedMaximum", tt-familia.qtde-fixa, OUTPUT iIdFamilyMaint).  
            &ELSE RUN addNodeDec IN hGenXml (iId, "FixedMaximum", DECIMAL(SUBSTRING(tt-familia.char-1,66,11)), OUTPUT iIdFamilyMaint).  
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeDec IN hGenXml (iId, "ReplacedLot", tt-familia.lote-repos, OUTPUT iIdFamilyMaint).  
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeLog IN hGenXml (iId, "IsIncludeForecastUsage", tt-familia.cons-consumo, OUTPUT iIdFamilyMaint).  
            &ELSE 
                IF SUBSTRING(tt-familia.char-1,77,1) = "1" THEN ASSIGN l-logical = YES. ELSE ASSIGN l-logical = NO.
                RUN addNodeLog IN hGenXml (iId, "IsIncludeForecastUsage", l-logical, OUTPUT iIdFamilyMaint).  
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNode IN hGenXml (iId, "ProduceNetworkCode", tt-familia.cod-malha, OUTPUT iIdFamilyMaint).  
            &ELSE 
                RUN addNode IN hGenXml (iId, "ProduceNetworkCode", SUBSTRING(tt-familia.char-1,78,5), OUTPUT iIdFamilyMaint).  
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNode IN hGenXml (iId, "BufferCode", tt-familia.cod-pulmao, OUTPUT iIdFamilyMaint).  
            &ELSE 
                RUN addNode IN hGenXml (iId, "BufferCode", SUBSTRING(tt-familia.char-1,83,5), OUTPUT iIdFamilyMaint).  
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeDec IN hGenXml (iId, "FormulationType", tt-familia.tipo-formula, OUTPUT iIdFamilyMaint).  
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeDec IN hGenXml (iId, "PartsForMilion", tt-familia.per-ppm, OUTPUT iIdFamilyMaint).  
            &ENDIF

            /* Adiciona informacoes do Item Refugo */
             RUN addNode IN hGenXml (iId, "ScrapItem", "", OUTPUT iIdFamilyMaint).

             &IF DEFINED (bf_man_205) &THEN
                RUN addNode IN hGenXml (iIdFamilyMaint, "ScrapItemCode", tt-familia.cod-item-refugo, OUTPUT iIdScrapItem).
                FIND FIRST ITEM WHERE ITEM.it-codigo = tt-familia.cod-item-refugo NO-LOCK NO-ERROR. 
                IF AVAIL ITEM THEN
                   RUN addNode IN hGenXml (iIdFamilyMaint, "ScrapItemDescription", SUBSTRING(ITEM.desc-item,1,60), OUTPUT iIdScrapItem).
                RUN addNodeDec IN hGenXml (iIdFamilyMaint, "ScrapItemLink", tt-familia.val-relac-refugo-item, OUTPUT iIdScrapItem).
             &ENDIF

                RUN addNodeDec IN hGenXml (iIdFamilyMaint, "ScrapFactor", tt-familia.fator-refugo, OUTPUT iIdScrapItem).
                RUN addNodeDec IN hGenXml (iIdFamilyMaint, "HandlingScrap", tt-familia.ind-refugo, OUTPUT iIdScrapItem).

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeLog IN hGenXml (iIdFamilyMaint, "IsScrapInventoryControl", tt-familia.log-control-estoq-refugo, OUTPUT iIdScrapItem).
                RUN addNodeLog IN hGenXml (iIdFamilyMaint, "IsScrapFiscalPrice", tt-familia.log-refugo-preco-fisc, OUTPUT iIdScrapItem).
            &ENDIF

            &IF DEFINED (bf_man_205) &THEN
                RUN addNodeLog IN hGenXml (iId, "IsMultiNetwork", tt-familia.log-multi-malha, OUTPUT iIdFamilyMaint).  
            &ENDIF

            /*************************************************/
            /* Adiciona informacoes de Inventario da Familia */
            /*************************************************/
            RUN addNode IN hGenXml (iFirstId, "InventoryFamily", "", OUTPUT iId).
            RUN addNodeLog IN hGenXml (iId, "IsIssueInventory", tt-familia.baixa-estoq, OUTPUT iIdInventory).

            /* EmissÆo Ordem - Valores validos conforme include ininc~\i03in122.i [Default 1] */
            IF tt-familia.emissao-ord = 1 OR tt-familia.emissao-ord = 2 THEN
               RUN addNodeDec IN hGenXml (iId, "OrderPrinting", tt-familia.emissao-ord, OUTPUT iIdInventory).
            ELSE RUN addNodeDec IN hGenXml (iId, "OrderPrinting", 1, OUTPUT iIdInventory).

            /* Demanda - Valores validos conforme include ininc~\i03in122.i [Default 1] */
            IF tt-familia.tipo-lote-ec = 1 OR tt-familia.tipo-lote-ec = 2 THEN
               RUN addNodeDec IN hGenXml (iId, "EconomicLotType", tt-familia.tipo-lote-ec, OUTPUT iIdInventory).
            ELSE RUN addNodeDec IN hGenXml (iId, "EconomicLotType", 1, OUTPUT iIdInventory).

            /* Demanda - Valores validos conforme include ininc~\i02in122.i [Default 1] */
            IF tt-familia.demanda = 1 OR tt-familia.demanda = 2 THEN
               RUN addNodeDec IN hGenXml (iId, "DemandType", tt-familia.demanda, OUTPUT iIdInventory).
            ELSE RUN addNodeDec IN hGenXml (iId, "DemandType", 1, OUTPUT iIdInventory).

            /* Tipo de controle de estoque - Valores validos conforme include ininc~\i01in122.i [Default 1] */
            IF tt-familia.tipo-con-est >= 1 AND tt-familia.tipo-con-est <= 4 THEN
               RUN addNodeDec IN hGenXml (iId, "InventoryControlType", tt-familia.tipo-con-est, OUTPUT iIdInventory).
            ELSE RUN addNodeDec IN hGenXml (iId, "InventoryControlType", 1, OUTPUT iIdInventory).

            RUN addNodeLog IN hGenXml (iId, "IsFractionizedQuantity", tt-familia.fraciona, OUTPUT iIdInventory).
            RUN addNodeLog IN hGenXml (iId,"IsABCPrinting", tt-familia.curva-abc, OUTPUT iIdInventory).

            /* Adiciona informacoes de Controle de Qualidade */
            RUN addNode IN hGenXml (iId, "QualityControl", "", OUTPUT iIdInventory).
            RUN addNodeLog IN hGenXml (iIdInventory, "IsQualityControl", tt-familia.contr-qualid, OUTPUT iIdQuality).
            RUN addNodeDec IN hGenXml (iIdInventory, "PurchasingQualityControl", tt-familia.res-cq-comp, OUTPUT iIdQuality).
            RUN addNodeDec IN hGenXml (iIdInventory, "ManufacturingQualityControl", tt-familia.res-cq-fabri, OUTPUT iIdQuality).

            /* Criticidade - Valores validos conforme include ininc~\i06in095.i [Default 1] */
            IF tt-familia.criticidade >= 1 AND tt-familia.criticidade <= 3 THEN
               RUN addNodeDec IN hGenXml (iIdInventory, "Criticality", tt-familia.criticidade, OUTPUT iIdQuality).
            ELSE RUN addNodeDec IN hGenXml (iIdInventory, "Criticality", 1, OUTPUT iIdQuality).

            RUN addNodeDec IN hGenXml (iIdInventory, "InspectionLevel", tt-familia.nivel, OUTPUT iIdQuality).
            RUN addNodeDec IN hGenXml (iIdInventory, "TypeInspect", tt-familia.tipo-insp, OUTPUT iIdQuality).
            RUN addNodeDec IN hGenXml (iIdInventory, "AcceptanceQualityLevel", tt-familia.perc-nqa, OUTPUT iIdQuality).

            /* Adiciona informacoes de Seguranca */
            RUN addNode IN hGenXml (iId, "Security", "", OUTPUT iIdInventory).
            RUN addNodeDec IN hGenXml (iIdInventory, "NegativeBal", tt-familia.perm-saldo-neg, OUTPUT iIdSecurity).

            /* Tipo de Controle Estoque Seguranca - Valores validos conforme include ininc~\i05in122.i [Default 1] */
            IF tt-familia.tipo-est-seg = 1 OR tt-familia.tipo-est-seg = 2 THEN
               RUN addNodeDec IN hGenXml (iIdInventory, "SafetyStockControlType", tt-familia.tipo-est-seg, OUTPUT iIdSecurity).
            ELSE RUN addNodeDec IN hGenXml (iIdInventory, "SafetyStockControlType", 1, OUTPUT iIdSecurity).

            RUN addNodeDec IN hGenXml (iIdInventory, "SafetyTime", tt-familia.tempo-segur, OUTPUT iIdSecurity).
            RUN addNodeDec IN hGenXml (iIdInventory, "SafetyQuantity", tt-familia.quant-segur, OUTPUT iIdSecurity).
            RUN addNodeDec IN hGenXml (iIdInventory, "WasteQuantity", tt-familia.quant-perda, OUTPUT iIdSecurity).

            /* Adiciona informacoes de Contagem Inventario */
            RUN addNode IN hGenXml (iId, "InventoryCount", "", OUTPUT iIdInventory).
            RUN addNodeLog IN hGenXml (iIdInventory, "IsCountClassA", tt-familia.invent-cla-a, OUTPUT iIdCount).
            RUN addNodeLog IN hGenXml (iIdInventory, "IsCountClassB", tt-familia.invent-cla-b, OUTPUT iIdCount).
            RUN addNodeLog IN hGenXml (iIdInventory, "IsCountClassC", tt-familia.invent-cla-c, OUTPUT iIdCount).
            RUN addNodeDec IN hGenXml (iIdInventory, "CountingCicle", tt-familia.ciclo-contag, OUTPUT iIdCount).

            /* Verifica se ha informacoes de Fator e adiciona [Extent 12] */
            Add-ListOfWeightFactor:
            DO iCount = 1 TO 12:
               IF tt-familia.fator-ponder[iCount] <> 0 THEN DO:
                  RUN addNode IN hGenXml (iIdInventory, "ListOfWeightFactor", "", OUTPUT iIdCount).
                  DO iCount = 1 TO 12:
                  IF tt-familia.fator-ponder[iCount] <> 0 THEN
                      RUN addNodeDec IN hGenXml (iIdCount, "WeightFactor", "", OUTPUT iIdValue).
                     RUN addNodeDec IN hGenXml (iIdValue, "WeightFactorCode", tt-familia.fator-ponder[iCount], OUTPUT iIdWeightFactor).
                  END.
                  LEAVE Add-ListOfWeightFactor.
               END.
            END.
            RUN addNodeDec IN hGenXml (iIdInventory, "MinValueToCount", tt-familia.vl-min-inv, OUTPUT iIdCount).
            RUN addNodeDec IN hGenXml (iIdInventory, "MaxValueToCount", tt-familia.vl-max-inv, OUTPUT iIdCount).

            /*************************************************/
            /* Adiciona informacoes de Familia Compras       */
            /*************************************************/
            RUN addNode IN hGenXml (iFirstId, "PurchaseFamily", "", OUTPUT iId).

            /* Adiciona informacoes de Comprador  */
            RUN addNode IN hGenXml (iId, "Buyer", "", OUTPUT iIdPurchase).
            RUN addNode IN hGenXml (iIdPurchase, "BuyerCode", tt-familia.cod-comprado, OUTPUT iIdBuyer).
            FIND FIRST comprador WHERE comprador.cod-comprado = tt-familia.cod-comprado NO-LOCK NO-ERROR. 
            IF AVAIL comprador THEN
               RUN addNode IN hGenXml (iIdPurchase, "BuyerDescription", SUBSTRING(comprador.nome,1,30), OUTPUT iIdBuyer).

            /* Adiciona informacoes de Grupo de Compra  */
            RUN addNode IN hGenXml (iId, "PurchaseGroup", "", OUTPUT iIdPurchase).

            /* Adiciona informacoes de Grupo de Compra Padrao */
            &IF DEFINED (bf_man_205) &THEN
                RUN addNode IN hGenXml (iIdPurchase, "PurchaseGroupStandard", "", OUTPUT iIdPurchaseGroup).
                RUN addNode IN hGenXml (iIdPurchaseGroup, "PurchaseGroupStandardCode", tt-familia.cod-grupo-compra-p, OUTPUT iIdPurchaseGroupStandard).
                FIND FIRST grupo-compra WHERE grupo-compra.cod-grp-compra = tt-familia.cod-grupo-compra-p NO-LOCK NO-ERROR. 
                IF AVAIL grupo-compra THEN
                   RUN addNode IN hGenXml (iIdPurchaseGroup, "PurchaseGroupStandardDescription", SUBSTRING(grupo-compra.des-grp-compra,1,40), OUTPUT iIdPurchaseGroupStandard).

               /* Adiciona informacoes de Grupo de Compra On-line */
                RUN addNode IN hGenXml (iIdPurchase, "PurchaseGroupOnLine", "", OUTPUT iIdPurchaseGroup).
                RUN addNode IN hGenXml (iIdPurchaseGroup, "PurchaseGroupOnLineCode", tt-familia.cod-grupo-compra-o, OUTPUT iIdPurchaseGroupOnLine).
                FIND FIRST grupo-compra WHERE grupo-compra.cod-grp-compra = tt-familia.cod-grupo-compra-o NO-LOCK NO-ERROR. 
                IF AVAIL grupo-compra THEN
                   RUN addNode IN hGenXml (iIdPurchaseGroup, "PurchaseGroupOnLineDesc", SUBSTRING(grupo-compra.des-grp-compra,1,40), OUTPUT iIdPurchaseGroupOnLine).
            &ENDIF

            /*************************************************/
            /* Adiciona informacoes Fiscais da Familia       */
            /*************************************************/
            RUN addNode IN hGenXml (iFirstId, "FiscalInformation", "", OUTPUT iId).
            RUN addNode IN hGenXml (iId, "FiscalClassification", tt-familia.class-fiscal, OUTPUT iIdFiscal).
                RUN addNode IN hGenXml (iIdFiscal, "FiscalSortKeyCode", tt-familia.class-fiscal, OUTPUT iIdFiscalClassification).
                FIND FIRST classif-fisc WHERE classif-fisc.class-fiscal = tt-familia.class-fiscal NO-LOCK NO-ERROR. 
                IF AVAIL classif-fisc THEN
                    RUN addNode IN hGenXml (iIdFiscal, "FiscalSortKeyDescription", SUBSTRING(classif-fisc.descricao,1,35), OUTPUT iIdFiscalClassification).

            /* Adiciona informacoes de Servico  */
            RUN addNode IN hGenXml (iId, "Service", "", OUTPUT iIdFiscal).
            RUN addNodeDec IN hGenXml (iIdFiscal, "ServiceCode", tt-familia.cod-servico, OUTPUT iIdService).
            FIND FIRST tab-codser WHERE tab-codser.cod-servico = tt-familia.cod-servico NO-LOCK NO-ERROR. 
            IF AVAIL tab-codser THEN
                RUN addNode IN hGenXml (iIdFiscal, "ServiceDescription", SUBSTRING(tab-codser.descricao,1,30), OUTPUT iIdService).

            /* Adiciona informacoes de ICMS  */
            RUN addNode IN hGenXml (iId, "SalesTax", "", OUTPUT iIdFiscal).
                RUN addNodeDec IN hGenXml (iIdFiscal, "SalesTaxCode", tt-familia.cd-trib-icm, OUTPUT iIdSalesTax).
                RUN addNodeDec IN hGenXml (iIdFiscal, "SalesTaxRestitucion", tt-familia.per-rest-icms, OUTPUT iIdSalesTax).
                RUN addNode IN hGenXml (iIdFiscal, "SalesTaxRestitucionLevel", tt-familia.niv-rest-icms, OUTPUT iIdSalesTax).

            RUN addNodeDec IN hGenXml (iId, "IndustrializedProductTaxCode", tt-familia.cd-trib-ipi, OUTPUT iIdFiscal).
            RUN addNodeDec IN hGenXml (iId, "ServiceTaxCode", tt-familia.cd-trib-iss, OUTPUT iIdFiscal).

            /* Adiciona informacoes de Taxas  */
            RUN addNode IN hGenXml (iId, "Rate", "", OUTPUT iIdFiscal).
            RUN addNodeDec IN hGenXml (iIdFiscal, "RateCode", tt-familia.cod-taxa, OUTPUT iIdRate).
            FIND FIRST tipo-tax WHERE tipo-tax.cod-tax = tt-familia.cod-taxa NO-LOCK NO-ERROR. 
            IF AVAIL tipo-tax THEN
                RUN addNode IN hGenXml (iIdFiscal, "RateDescription", SUBSTRING(tipo-tax.descricao,1,30), OUTPUT iIdRate).

            /**********************************************************/
            /* Adiciona informacoes complement da Familia Manufatura  */
            /**********************************************************/
            FIND FIRST familia-man WHERE familia-man.fm-codigo = tt-familia.fm-codigo NO-LOCK NO-ERROR. 
            IF AVAIL familia-man THEN DO:

               RUN addNode IN hGenXml (iFirstId, "Manufacture", "", OUTPUT iId).
               RUN addNodeLog IN hGenXml (iId, "IsUpdateRequestReference", familia-man.alt-refer, OUTPUT iIdManufacture).
               RUN addNodeDec IN hGenXml (iId, "FamilyPlanControled", familia-man.contr-plan, OUTPUT iIdManufacture).
               RUN addNodeDec IN hGenXml (iId, "ProcessCost", familia-man.ind-lista-csp, OUTPUT iIdManufacture).
               RUN addNodeLog IN hGenXml (iId, "IsEvaluateConsumeSwitch", familia-man.log-ad-consumo, OUTPUT iIdManufacture).
               RUN addNodeLog IN hGenXml (iId, "IsAutomaticApproveStructut", familia-man.log-aprov-estrut, OUTPUT iIdManufacture).
               RUN addNodeLog IN hGenXml (iId, "IsAutomaticApproveRoute", familia-man.log-aprov-rot, OUTPUT iIdManufacture).
               RUN addNodeLog IN hGenXml (iId, "IsReportFinalizeOrder", familia-man.log-finaliz-op, OUTPUT iIdManufacture).
               RUN addNodeDec IN hGenXml (iId, "LowerLevel", familia-man.niv-mais-bai, OUTPUT iIdManufacture).
               RUN addNodeDec IN hGenXml (iId, "ManufactureFamilyIdentify", familia-man.num-id-familia-man, OUTPUT iIdManufacture).
               RUN addNodeDec IN hGenXml (iId, "FamilyBacklogPoint", familia-man.ponto-encomenda, OUTPUT iIdManufacture).
               RUN addNodeDec IN hGenXml (iId, "QuantityReference", familia-man.qtd-refer-custo-dis, OUTPUT iIdManufacture).
               RUN addNodeDec IN hGenXml (iId, "QuantityMinResuppliment", familia-man.qt-min-res-fabr, OUTPUT iIdManufacture).
               RUN addNodeDec IN hGenXml (iId, "ReplenishmentType", familia-man.tp-ressup, OUTPUT iIdManufacture).

                /* Adiciona informacoes de Usuario  */
                RUN addNode IN hGenXml (iId, "User", "", OUTPUT iIdManufacture).
                RUN addNode IN hGenXml (iIdManufacture, "ReleaseUser", familia-man.user-lib, OUTPUT iIdUser).
                RUN addNode IN hGenXml (iIdManufacture, "UserReleaseStructure", familia-man.user-lib-estrut, OUTPUT iIdUser).
                RUN addNode IN hGenXml (iIdManufacture, "UserReleaseRouting", familia-man.user-lib-rot, OUTPUT iIdUser).

                RUN addNodeDec IN hGenXml (iId, "CostFactorDistribution", familia-man.val-fator-custo-dis, OUTPUT iIdManufacture).
                RUN addNodeDec IN hGenXml (iId, "RessuplimentQuantityVariance", familia-man.var-qtd-res-fabr, OUTPUT iIdManufacture).
                RUN addNodeDec IN hGenXml (iId, "VariationTimeRessupliment", familia-man.var-tempo-res-fabr, OUTPUT iIdManufacture).
                RUN addNodeDec IN hGenXml (iId, "PreviousMaterialValue", familia-man.vl-mat-ant, OUTPUT iIdManufacture).
                RUN addNodeDec IN hGenXml (iId, "PreviousLaborForce", familia-man.vl-mob-ant, OUTPUT iIdManufacture).
                RUN addNodeDec IN hGenXml (iId, "MaximumVarianceValue", familia-man.vl-var-max, OUTPUT iIdManufacture).
                RUN addNodeDec IN hGenXml (iId, "VarianceMinimumValue", familia-man.vl-var-min, OUTPUT iIdManufacture).

             END. /* familia-man */
        END.
        ELSE IF pTranAction = "DEL" THEN DO:
            /* no principal delete */
            RUN addNode IN hGenXml (0, "Delete", "", OUTPUT iFirstId).

            RUN addNode IN hGenXml (iFirstId, "MaterialFamilyCode", tt-familia.fm-codigo, OUTPUT iId).

            RUN addNode IN hGenXml (iFirstId, "MaterialFamilyDescription",tt-familia.descricao, OUTPUT iId).          
       END.

    END.

    /* Obt‚m XMl na variavel handle */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).
    /*hBusinessContent:SAVE("FILE", "C:~\MaterialFamily.xml").*/

    /* Passa handle do BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

    /* Elimina handle */
    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Envia XML para ControlBroker */
    RUN sendMessage IN hMessageHandler (INPUT "ma2/MaterialFamily_204_001.xsd").

    /*Verifica se a mensagem foi enviada com sucesso */
    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess,
                                            OUTPUT pTotalErrors).

    IF NOT pSendSuccess THEN DO:
      REPEAT iCount = 1 TO pTotalErrors:
          RUN getError IN hMessageHandler (iCount,
                                             OUTPUT pErrorNumber,
                                             OUTPUT pErrorType,
                                             OUTPUT pErrorDesc ).
          run piCriaErro (17006,
                             pErrorType, 
                             pErrorDesc).


     END.
     RETURN "NOK":U.
     LEAVE.

   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
