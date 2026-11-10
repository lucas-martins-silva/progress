/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSMA007 2.00.00.005}  /*** 010005 ***/


/********************************************************************************/
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : AXSMA007.p
    Purpose     : ADAPTER DE ENVIO DA ORDEM DE PRODU€ÇO 

    Syntax      :

    Description : ADAPTER DE ENVIO DA ORDEM DE PRODU€ÇO 
    CREATEd     : 19/03/2004 09:00
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */

/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlTranName      ProductionOrder
&GLOBAL-DEFINE XmlTranVersion   204.000
&GLOBAL-DEFINE XmlProdName      EMS2
&GLOBAL-DEFINE XmlProdVersion   204
&GLOBAL-DEFINE XmlApp           MA2 
&GLOBAL-DEFINE XmlMod           CPP

/* Defini‡Æo das temp-table do reporte por item */
{cpp/cpapi009.i}

/* Defini‡Æo das informacoes referentes a reserva */
{adapters/xml/ma2/axsma006.i01} 

/* Defini‡Æo temp-table RowErrors */
{utp/ut-glob.i}
{cdp/cdcfgman.i} 
{cdp/cd9043.i}
{cdp/cd9043.i1}
{cpp/cpapi301.i}



/*Parƒmetros de entrada*/
DEF INPUT PARAM pTranAction  AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgName    AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgVersion AS CHAR    NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-ord-prod.
DEF OUTPUT PARAM TABLE FOR RowErrors.




/* Vari veis Globais */
DEF VAR hGenXml          AS HANDLE NO-UNDO.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.

/* Variaveis da constru‡Æo do BusinessContent Utilizando APIXML */
DEFINE VARIABLE iFirstId                AS INTEGER    NO-UNDO.
DEFINE VARIABLE iProductionOrderId      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iItemId                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iId                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iReferenceId            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iUnitOfMeasureId        AS INTEGER    NO-UNDO.
DEFINE VARIABLE iSiteId                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iProductionLineId       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iStructureId            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iCustomerId             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iManufactureRouteId     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iOrderDatesId           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iQuantityId             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPlannerId              AS INTEGER    NO-UNDO.
DEFINE VARIABLE iWarehouseId            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iOrderAccountId         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iExpenseAccountId       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iDeactiveAccountId      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iCostId                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLaborId                AS INTEGER    NO-UNDO.
DEFINE VARIABLE iOverHeadId             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLastChangeId           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iRequisitionId          AS INTEGER    NO-UNDO.
DEFINE VARIABLE iSalesContractId        AS INTEGER    NO-UNDO.
DEFINE VARIABLE iAPSId                  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iIdInfReserves          AS INTEGER    NO-UNDO. 
DEFINE VARIABLE iInspectionId           AS INTEGER    NO-UNDO. 

DEFINE VARIABLE iOperationOrderId       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iOperationId            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iOperId                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPertOrderId            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPOId                   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPertId                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iAveragePriceId         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iIdValue                AS INTEGER    NO-UNDO.

&IF DEFINED(bf_man_205) &THEN
   DEFINE VARIABLE iScrapId                AS INTEGER    NO-UNDO.
&endif
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
DEF VAR l-logical     AS LOG             NO-UNDO.
DEF VAR r_reserva     AS ROWID           NO-UNDO.

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
/* Verifica se h  registros na temp-table */
IF NOT CAN-FIND(FIRST tt-ord-prod) THEN DO:

    {utp/ut-liter.i Ordem_de_Produ‡Æo_Integra‡Æo_EAI * r}
    run piCriaErro (5561,
                    'EMS':U, 
                    TRIM(return-value)).
     RETURN "NOK":U.
END.

FOR EACH tt-ord-prod NO-LOCK:
    /* Verifica se MessageHandler.p está  na mem¢ria */
    {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

    /* Verifica se o MessageHandler foi executado corretamente */
    IF cReturnValue <> "OK":U THEN DO:
       IF cReturnValue <> ? AND cReturnValue <> " " THEN DO:
          run piCriaErro (17006,
                          'EMS':U, 
                          cReturnValue).
          RETURN "NOK":U.
      END.
    END.
    /* Verifica se h  programas inscritos */

    RUN isSubscribed IN hMessageHandler (INPUT "{&XmlProdName}",
                                         INPUT "{&XmlApp}",
                                         INPUT "{&XmlTranName}",
                                         INPUT "{&XmlTranVersion}",
                                         INPUT "ProductionOrder",
                                         INPUT pTranAction,
                                         OUTPUT lCREATEMsg).



       /*Verifica se a transa‡Æo ‚ assinada*/
    IF NOT lCREATEMsg THEN
       RETURN "OK":U.

    /* Preenche o valor do elemento Comment de TransactionId */
    RUN setTransInfoComment IN hMessageHandler ("Program:" + pProgName + "-" +
                                                "Version:" + pProgVersion). 
        /*Seta SystemID*/



    RUN setSystemId IN hMessageHandler ("{&XmlMod}",          /* Nome do modulo */
                                        "{&XmlProdVersion}"). /* Versao do Programa */
    /* Indica valor da chave prim ria da transa‡Æo */



    RUN setKeyFields IN hMessageHandler ("ord-prod.nr-ord-produ",
                                         STRING(tt-ord-prod.nr-ord-produ)). 


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
         END.
     END.
    /* Cria mensagem do BusinessContent atrav‚s da API*/
    CREATE-BUSINESS-XML:
    DO:

        /* RESETA OS VALORES */
        RUN reset IN hGenXml.
        /* SETA VALOR DE ENCODING */
        RUN setEncoding IN hGenXml ("UTF-8").
        IF pTranAction = "add" OR
           pTranAction = "upd"  THEN DO:

            /* Nà PRINCIPAL UPSERT */
            RUN addNode IN hGenXml (0, "Upsert":U, "":U, OUTPUT iFirstId).

            /* Adiciona informa‡äes da Ordem de Produ‡Æo */
            RUN addNode IN hGenXml (iFirstId, "ProductionOrder":U, "":U, OUTPUT iId).

                RUN addNodeDec IN hGenXml  (iId, "ProductionOrderNumber":U, tt-ord-prod.nr-ord-produ, OUTPUT iProductionOrderId).
                IF  tt-ord-prod.rep-prod  < 1 OR
                    tt-ord-prod.rep-prod > NUM-ENTRIES({ininc/i07in271.i 03}) THEN
                    RUN addNodeDec IN hGenXml  (iId, "ReportProductionType":U, 1, OUTPUT iProductionOrderId).
                ELSE 
                    RUN addNodeDec IN hGenXml  (iId, "ReportProductionType":U, tt-ord-prod.rep-prod, OUTPUT iProductionOrderId).

                IF tt-ord-prod.estado < 1 OR
                   tt-ord-prod.estado > NUM-ENTRIES({ininc/i01in271.i 03})  THEN
                   RUN addNodeDec IN hGenXml  (iId, "Status":U, 1, OUTPUT iProductionOrderId).
                ELSE 
                   RUN addNodeDec IN hGenXml  (iId, "Status":U, tt-ord-prod.estado, OUTPUT iProductionOrderId).

                IF tt-ord-prod.tipo < 1 OR
                   tt-ord-prod.tipo >  NUM-ENTRIES({ininc/i01in271.i 03})  THEN
                   RUN addNodeDec IN hGenXml  (iId, "ProductionOrderType":U, 1, OUTPUT iProductionOrderId).
                ELSE
                   RUN addNodeDec IN hGenXml  (iId, "ProductionOrderType":U, tt-ord-prod.tipo, OUTPUT iProductionOrderId).

                /* Adiciona informa‡äes do Item da Ordem*/
                RUN addNode IN hGenXml (iId, "Item":U, "":U, OUTPUT iProductionOrderId).

                    RUN addNode IN hGenXml (iProductionOrderId, "ItemCode":U, tt-ord-prod.it-codigo, OUTPUT iItemId).
                    FOR FIRST ITEM FIELDS(it-codigo desc-item)  WHERE 
                              ITEM.it-codigo = tt-ord-prod.it-codigo NO-LOCK: END.
                    IF AVAIL ITEM THEN
                       RUN addNode IN hGenXml (iProductionOrderId, "ItemDescription":U, ITEM.desc-item, OUTPUT iItemId).

                    RUN addNode IN hGenXml (iProductionOrderId, "ComponentCode":U, substr(tt-ord-prod.es-codigo,1,16), OUTPUT iItemId).
                    RUN addNodeDec IN hGenXml (iProductionOrderId, "SequenceNumber":U, tt-ord-prod.sequencia, OUTPUT iItemId).
                    RUN addNodeDec IN hGenXml (iProductionOrderId, "DeliveryNumber":U, tt-ord-prod.nr-entrega, OUTPUT iItemId).

                    /* Adiciona informa‡äes referente a referencias do item */
                    RUN addNode IN hGenXml (iProductionOrderId, "Reference":U, "":U, OUTPUT iItemId).
                        RUN addNode IN hGenXml (iItemId, "ReferenceCode":U, substr(tt-ord-prod.cod-refer,1,8), OUTPUT iReferenceId).
                        FOR FIRST referencia FIELDS(cod-refer descricao) WHERE 
                                  referencia.cod-refer = tt-ord-prod.cod-refer NO-LOCK: END. 
                        IF AVAIL referencia THEN
                           RUN addNode IN hGenXml (iItemId, "ReferenceDescription":U, substr(referencia.descricao,1,8), OUTPUT iReferenceId).                         

                    /* Adiciona informa‡äes referente a Unidade de Medida */
                    RUN addNode IN hGenXml (iProductionOrderId, "UnitOfMeasure":U, "":U, OUTPUT iItemId).
                        RUN addNode IN hGenXml (iItemId, "UnitOfMeasureCode":U, tt-ord-prod.un, OUTPUT iUnitOfMeasureId).
                        FOR FIRST tab-unidade FIELDS(un descricao) WHERE 
                                  tab-unidade.un = tt-ord-prod.un NO-LOCK: END.
                        IF AVAIL tab-unidade THEN
                           RUN addNode IN hGenXml (iItemId, "UnitOfMeasureDescription":U, tab-unidade.descricao, OUTPUT iUnitOfMeasureId).                         

                    /* Adiciona informa‡äes referente a Estabelecimento */
                    RUN addNode IN hGenXml (iProductionOrderId, "Site":U, "":U, OUTPUT iItemId).
                        RUN addNode IN hGenXml (iItemId, "SiteID":U, tt-ord-prod.cod-estabel, OUTPUT iSiteId).
                        FOR FIRST estabelec FIELDS(cod-estabel nome) WHERE 
                                  estabelec.cod-estabel = tt-ord-prod.cod-estabel NO-LOCK: END. 
                        IF AVAIL estabelec THEN
                           RUN addNode IN hGenXml (iItemId, "SiteDescription":U, estabelec.nome, OUTPUT iSiteId).                         


                    /* Adiciona informa‡äes referente a Linha de Produ‡Æo */
                    RUN addNode IN hGenXml (iProductionOrderId, "ProductionLine":U, "":U, OUTPUT iItemId).
                        RUN addNodeDec IN hGenXml (iItemId, "ProductionLineNumber":U, tt-ord-prod.nr-linha, OUTPUT iProductionLineId).
                        FOR FIRST lin-prod FIELDS(nr-linha descricao) WHERE 
                                  lin-prod.nr-linha = tt-ord-prod.nr-linha NO-LOCK: END. 
                        IF AVAIL lin-prod THEN
                           RUN addNode IN hGenXml (iItemId, "ProductionLineDescription":U, lin-prod.descricao, OUTPUT iProductionLineId).  

                   /* Adiciona informa‡äes referente a Estrutura */
                   RUN addNode IN hGenXml (iProductionOrderId, "StructureInformations":U, "":U, OUTPUT iItemId).
                       RUN addNodeDec IN hGenXml (iItemId, "StructureNumber":U, tt-ord-prod.nr-estrut, OUTPUT iStructureId).
                       RUN addNodeDec IN hGenXml (iItemId, "ChildStructure":U, tt-ord-prod.nr-estrut-filha, OUTPUT iStructureId).  

                  /* Informa‡äes referente a Ordem de Produ‡Æo  */
                  RUN addNode IN hGenXml  (iId, "Narrative":U, tt-ord-prod.narrativa, OUTPUT iProductionOrderId).
                  RUN addNodeLog IN hGenXml  (iId, "IsPrintOrder":U, tt-ord-prod.emite-ordem, OUTPUT iProductionOrderId).
                  RUN addNode IN hGenXml  (iId, "SerialNumber":U, tt-ord-prod.lote-serie, OUTPUT iProductionOrderId).
                  RUN addNodeDec IN hGenXml  (iId, "PriorityProductionOrder":U, tt-ord-prod.prioridade, OUTPUT iProductionOrderId).

                  IF  tt-ord-prod.sit-aloc < 1 OR
                      tt-ord-prod.sit-aloc > NUM-ENTRIES({ininc/i09in271.i 03}) THEN
                      RUN addNodeDec IN hGenXml  (iId, "SituationAllocationOrder":U, 1, OUTPUT iProductionOrderId).
                  ELSE 
                      RUN addNodeDec IN hGenXml  (iId, "SituationAllocationOrder":U, tt-ord-prod.sit-aloc, OUTPUT iProductionOrderId).
                  RUN addNodeLog IN hGenXml  (iId, "IsMonthClosing":U, tt-ord-prod.enc-mensal, OUTPUT iProductionOrderId).
                  RUN addNodeLog IN hGenXml  (iId, "IsPrototype":U, tt-ord-prod.prototipo, OUTPUT iProductionOrderId).
                  RUN addNodeDec IN hGenXml  (iId, "ReferenceOrderNumber":U, tt-ord-prod.nr-ord-refer, OUTPUT iProductionOrderId).  

                  /* Informa‡äes referentes a Roteiro */
                  RUN addNode IN hGenXml  (iId, "ManufactureRoute":U, "":U, OUTPUT iProductionOrderId).  
                      RUN addNode IN hGenXml  (iProductionOrderId, "RouteID":U, tt-ord-prod.cod-roteiro , OUTPUT iManufactureRouteId).  
                      FOR FIRST rot-fabric FIELDS(cod-roteiro descricao) WHERE 
                                rot-fabric.cod-roteiro = tt-ord-prod.cod-roteiro NO-LOCK: END.
                      IF AVAIL rot-fabric THEN
                         RUN addNode IN hGenXml  (iProductionOrderId, "RouteDescription":U, rot-fabric.descricao, OUTPUT iManufactureRouteId).

                  /* Informa‡äes referentes a Datas */
                  RUN addNode IN hGenXml  (iId, "OrderDates":U, "":U, OUTPUT iProductionOrderId).  
                  IF tt-ord-prod.dt-inicio <> ? THEN 
                      RUN addNodeDate IN hGenXml  (iProductionOrderId, "StartDate":U, tt-ord-prod.dt-inicio, OUTPUT iOrderDatesId).   
                  IF tt-ord-prod.dt-termino <> ? THEN 
                      RUN addNodeDate IN hGenXml  (iProductionOrderId, "EndDate":U, tt-ord-prod.dt-termino, OUTPUT iOrderDatesId).   
                  IF tt-ord-prod.dt-emissao <> ? THEN 
                      RUN addNodeDate IN hGenXml  (iProductionOrderId, "PrintDate":U, tt-ord-prod.dt-emissao, OUTPUT iOrderDatesId).       
                  IF tt-ord-prod.dt-orig <> ? THEN 
                      RUN addNodeDate IN hGenXml  (iProductionOrderId, "OriginalTerminalDate":U, tt-ord-prod.dt-orig, OUTPUT iOrderDatesId).       

                  /* Informa‡äes referentes a Quantidades */
                  RUN addNode IN hGenXml  (iId, "QuantityInformations":U, "":U, OUTPUT iProductionOrderId).  
                      RUN addNodeDec IN hGenXml  (iProductionOrderId, "QuantityOfOrder":U, tt-ord-prod.qt-ordem, OUTPUT iQuantityId).
                      RUN addNodeDec IN hGenXml  (iProductionOrderId, "QuantityProduced":U, tt-ord-prod.qt-produzida, OUTPUT iQuantityId).
                      RUN addNodeDec IN hGenXml  (iProductionOrderId, "QuantityOfScrap":U, tt-ord-prod.qt-refugada, OUTPUT iQuantityId).
                      RUN addNodeDec IN hGenXml  (iProductionOrderId, "QuantityOfReport":U, tt-ord-prod.qt-reportada, OUTPUT iQuantityId).
                      RUN addNodeDec IN hGenXml  (iProductionOrderId, "QuantityOfRequisit":U, tt-ord-prod.qt-requisita, OUTPUT iQuantityId).
                      RUN addNodeDec IN hGenXml  (iProductionOrderId, "OrderQuantityApprovedConditionally":U, tt-ord-prod.qt-apr-cond, OUTPUT iQuantityId).
                      RUN addNodeDec IN hGenXml  (iProductionOrderId, "QuantityOfWaste":U, tt-ord-prod.qt-perda, OUTPUT iQuantityId).
                      RUN addNodeDec IN hGenXml  (iProductionOrderId, "StartQuantity":U, tt-ord-prod.qt-inicial, OUTPUT iQuantityId).

                  /* Informa‡äes referentes a Planejador */
                  RUN addNode IN hGenXml  (iId, "Planner":U, "":U, OUTPUT iProductionOrderId).  
                      RUN addNode IN hGenXml (iProductionOrderId, "PlannerCode":U, tt-ord-prod.cd-planejado , OUTPUT iPlannerId).
                      FOR FIRST planejad FIELDS (cd-planejado nome) WHERE 
                                planejad.cd-planejado = tt-ord-prod.cd-planejado NO-LOCK: END.
                       IF AVAIL planejad THEN
                          RUN addNode IN hGenXml (iProductionOrderId, "PlannerDescription":U, planejad.nome , OUTPUT iPlannerId).


                  /* Informa‡äes referentes a Dep¢sito */
                  RUN addNode IN hGenXml  (iId, "Warehouse":U, "":U, OUTPUT iProductionOrderId).  
                      RUN addNode IN hGenXml  (iProductionOrderId, "WarehouseID":U, tt-ord-prod.cod-depos , OUTPUT iWarehouseId).
                      FOR FIRST deposito FIELDS (cod-depos nome) WHERE 
                                deposito.cod-depos = tt-ord-prod.cod-depos NO-LOCK: END.
                       IF AVAIL deposito THEN
                          RUN addNode IN hGenXml  (iProductionOrderId, "WarehouseDescription":U, deposito.nome , OUTPUT iWarehouseId).

                  &IF DEFINED(bf_man_205) &THEN
                    /* Informa‡äes referentes a Refugo */
                    RUN addNode IN hGenXml  (iId, "ScrapItemInformations":U, "":U, OUTPUT iProductionOrderId).  
                      RUN addNode IN hGenXml  (iProductionOrderId, "ScrapItemCode":U, tt-ord-prod.cod-item-refugo , OUTPUT iScrapId).
                      FOR FIRST ITEM FIELDS (it-codigo desc-item) WHERE 
                                ITEM.it-codigo = tt-ord-prod.cod-item-refugo NO-LOCK: END.
                       IF AVAIL ITEM THEN
                          RUN addNode IN hGenXml (iProductionOrderId, "ScrapItemDescription":U, SUBSTRING(item.desc-item, 1,60) , OUTPUT iScrapId).
                      RUN addNodeLog IN hGenXml (iProductionOrderId, "IsScrapFiscalPrice":U, tt-ord-prod.log-refugo-preco-fis, OUTPUT iScrapId). 
                      RUN addNodeDec IN hGenXml (iProductionOrderId, "ScrapItemLink":U, tt-ord-prod.val-relac-refugo-item, OUTPUT iScrapId). 
                  &ENDIF

                  /* Adiciona a conta da ordem */ 
                  RUN addNode IN hGenXml  (iId, "OrderAccount":U, "":U, OUTPUT iProductionOrderId).  
                    RUN addNode IN hGenXml  (iProductionOrderId, "AccountNumber":U, tt-ord-prod.ct-codigo, OUTPUT iOrderAccountId).  
                    RUN addNode IN hGenXml  (iProductionOrderId, "SubAccountNumber":U, tt-ord-prod.sc-codigo, OUTPUT iOrderAccountId).  
                    
                  /* Adiciona a conta de despesa */ 
                  RUN addNode IN hGenXml  (iId, "ExpenseAccount":U, "":U, OUTPUT iProductionOrderId).  
                    RUN addNode IN hGenXml  (iProductionOrderId, "AccountNumber":U, tt-ord-prod.ct-desp, OUTPUT iExpenseAccountId).  
                    RUN addNode IN hGenXml  (iProductionOrderId, "SubAccountNumber":U, tt-ord-prod.sc-desp, OUTPUT iExpenseAccountId).  
                    
                  /* Adiciona a conta do imobilizado */ 
                  RUN addNode IN hGenXml  (iId, "DeactiveAccount":U, "":U, OUTPUT iProductionOrderId).  
                    RUN addNode IN hGenXml  (iProductionOrderId, "AccountNumber":U, tt-ord-prod.ct-imob, OUTPUT iDeactiveAccountId).  
                    RUN addNode IN hGenXml  (iProductionOrderId, "SubAccountNumber":U, tt-ord-prod.sc-imob, OUTPUT iDeactiveAccountId).  
                    
                  /* Adiciona informacoes de custeio */ 
                  RUN addNode IN hGenXml  (iId, "CostInformations":U, "":U, OUTPUT iProductionOrderId).  
                    RUN addNodeLog IN hGenXml  (iProductionOrderId, "IsValuedOrder":U, tt-ord-prod.valorizada, OUTPUT iCostId).  

                    IF tt-ord-prod.calc-cs-mat < 1 OR tt-ord-prod.calc-cs-mat > NUM-ENTRIES({ininc/i02in271.i 03}) THEN
                        RUN addNodeDec IN hGenXml  (iProductionOrderId, "MaterialCostCalculation":U, 1, OUTPUT iCostId).
                    ELSE RUN addNodeDec IN hGenXml  (iProductionOrderId, "MaterialCostCalculation":U, tt-ord-prod.calc-cs-mat, OUTPUT iCostId).

                    IF tt-ord-prod.custeio-prop-mat < 1 OR tt-ord-prod.custeio-prop-mat > NUM-ENTRIES({ininc/i03in271.i 03}) THEN
                      RUN addNodeDec IN hGenXml  (iProductionOrderId, "ProportionalCostMaterial":U, 1, OUTPUT iCostId).
                    ELSE RUN addNodeDec IN hGenXml  (iProductionOrderId, "ProportionalCostMaterial":U, tt-ord-prod.custeio-prop-mat, OUTPUT iCostId).

                  /* Adiciona informacoes de mao-de-obra */ 
                  RUN addNode IN hGenXml  (iProductionOrderId, "LaborInformations":U, "":U, OUTPUT iCostId).  
                  IF tt-ord-prod.reporte-mob < 1 OR tt-ord-prod.reporte-mob > NUM-ENTRIES({ininc/i06in271.i 03}) THEN  
                     RUN addNodeDec IN hGenXml  (iCostId, "ReportLabor":U, 1, OUTPUT iLaborId). 
                  ELSE 
                     RUN addNodeDec IN hGenXml  (iCostId, "ReportLabor":U, tt-ord-prod.reporte-mob, OUTPUT iLaborId).  

                  IF tt-ord-prod.custeio-prop-mob < 1 OR tt-ord-prod.custeio-prop-mob > NUM-ENTRIES({ininc/i04in271.i 03}) THEN
                     RUN addNodeDec IN hGenXml  (iCostId, "ProportionalCostLabor":U, 1, OUTPUT iLaborId).
                  ELSE RUN addNodeDec IN hGenXml  (iCostId, "ProportionalCostLabor":U, tt-ord-prod.custeio-prop-mob, OUTPUT iLaborId).

                  IF tt-ord-prod.calc-cs-mob < 1 OR tt-ord-prod.calc-cs-mob > NUM-ENTRIES({ininc/i02in284.i 03}) THEN
                     RUN addNodeDec IN hGenXml  (iCostId, "LaborCostType":U, 1, OUTPUT iLaborId).
                  ELSE RUN addNodeDec IN hGenXml  (iCostId, "LaborCostType":U, tt-ord-prod.calc-cs-mob, OUTPUT iLaborId).

                  /* Adiciona informacoes de Gastos Gerais de Fabricacao */ 
                  RUN addNode IN hGenXml  (iProductionOrderId, "OverheadInformations":U, "":U, OUTPUT iCostId).  

                  IF tt-ord-prod.custeio-prop-ggf < 1 OR tt-ord-prod.custeio-prop-ggf > NUM-ENTRIES({ininc/i03in271.i 03}) THEN
                     RUN addNodeDec IN hGenXml  (iCostId, "ProportionalCostOverhead":U, 1, OUTPUT iOverHeadId).
                  ELSE RUN addNodeDec IN hGenXml  (iCostId, "ProportionalCostOverhead":U, tt-ord-prod.custeio-prop-ggf, OUTPUT iOverHeadId).

                  IF tt-ord-prod.calc-cs-ggf < 1 OR tt-ord-prod.calc-cs-ggf > NUM-ENTRIES({ininc/i02in284.i 03}) THEN
                     RUN addNodeDec IN hGenXml  (iCostId, "OverheadCostType":U, 1, OUTPUT iOverHeadId).
                  ELSE RUN addNodeDec IN hGenXml  (iCostId, "OverheadCostType":U, tt-ord-prod.calc-cs-ggf, OUTPUT iOverHeadId).

                  IF tt-ord-prod.reporte-ggf < 1 OR tt-ord-prod.reporte-ggf > NUM-ENTRIES({ininc/i06in172.i 03}) THEN
                     RUN addNodeDec IN hGenXml  (iCostId, "OverheadReport":U, 1, OUTPUT iOverHeadId).
                  ELSE RUN addNodeDec IN hGenXml  (iCostId, "OverheadReport":U, tt-ord-prod.reporte-ggf, OUTPUT iOverHeadId).

                  /* Adiciona informacoes referentes … ultima alteracao */ 
                  RUN addNode IN hGenXml  (iId, "LastChange":U, "":U, OUTPUT iProductionOrderId).  
                  IF tt-ord-prod.data-alt <> ? THEN
                     RUN addNodeDate IN hGenXml  (iProductionOrderId, "LastChangeDate":U, tt-ord-prod.data-alt, OUTPUT iLastChangeId).  
                     RUN addNode IN hGenXml  (iProductionOrderId, "UserLastChange":U, substr(tt-ord-prod.usuario-alt,1,12), OUTPUT iLastChangeId).  

                  /* Adiciona informacoes referentes … requisicao */ 
                  RUN addNode IN hGenXml  (iId, "Requisition":U, "":U, OUTPUT iProductionOrderId).  
                  IF tt-ord-prod.data-alt <> ? THEN
                     RUN addNodeLog IN hGenXml (iProductionOrderId, "IsPrintRequisition":U, tt-ord-prod.emite-requis, OUTPUT iRequisitionId).  
                     RUN addNodeDec IN hGenXml (iProductionOrderId, "SummarizedRequisition":U, tt-ord-prod.nr-req-sum, OUTPUT iRequisitionId). 
                     RUN addNodeLog IN hGenXml (iProductionOrderId, "IsPrintedRequisition":U, tt-ord-prod.req-emitida, OUTPUT iRequisitionId).  

                  /* Adiciona informa‡äes referentes ao Cliente */
                  RUN addNode IN hGenXml  (iId, "CustomerInformations":U, "":U, OUTPUT iProductionOrderId).
                      RUN addNode IN hGenXml  (iProductionOrderId, "CustomerName":U, tt-ord-prod.nome-abrev, OUTPUT iCustomerId).
                      RUN addNodeDec IN hGenXml  (iProductionOrderId, "CustomerGroupCode":U, tt-ord-prod.cod-gr-cli, OUTPUT iCustomerId). 
                      FOR FIRST gr-cli FIELDS(cod-gr-cli descricao) WHERE 
                                gr-cli.cod-gr-cli = tt-ord-prod.cod-gr-cli NO-LOCK: END.
                      IF AVAIL gr-cli THEN
                         RUN addNode IN hGenXml  (iProductionOrderId, "CustomerGroupDescription":U, gr-cli.descricao, OUTPUT iCustomerId).  
                      RUN addNode IN hGenXml (iProductionOrderId, "CustomerOrder":U, tt-ord-prod.nr-pedido, OUTPUT iCustomerId). 
                      RUN addNodeDec IN hGenXml (iProductionOrderId, "CustomerOrderSequence":U, tt-ord-prod.nr-sequencia, OUTPUT iCustomerId).


                  &IF DEFINED(bf_man_205) &THEN 

                      /* Adiciona informacoes referentes ao contrato de venda */ 
                      RUN addNode IN hGenXml  (iId, "ContractInformation":U, "":U, OUTPUT iProductionOrderId).  
                      RUN addNodeDec IN hGenXml (iProductionOrderId, "SalesContract":U, tt-ord-prod.nr-contrato-venda, OUTPUT iSalesContractId).  
                      RUN addNodeDec IN hGenXml (iProductionOrderId, "ContractItemSequence":U, tt-ord-prod.nr-seq-contr-it, OUTPUT iSalesContractId).  

                      /* Adiciona informa‡oes do Estabelecimento */
                      RUN addNode IN hGenXml (iProductionOrderId, "Site":U, "":U, OUTPUT iSalesContractId).
                      RUN addNode IN hGenXml (iSalesContractId, "SiteID":U, tt-ord-prod.cod-estab-ctr, OUTPUT iSiteId).
                      FOR FIRST estabelec WHERE estabelec.cod-estabel = tt-ord-prod.cod-estab-ctr  NO-LOCK: END. 
                      IF AVAIL estabelec THEN
                         RUN addNode IN hGenXml (iSalesContractId, "SiteDescription":U, substr(estabelec.nome,1,40), OUTPUT iSiteId).

                    /* Adiciona informa‡oes do Planejamento APS */
                      RUN addNode IN hGenXml  (iId, "AdvancedPlanningSchedule":U, "":U, OUTPUT iProductionOrderId).  

                      IF tt-ord-prod.cdn-orig-aps < 1 OR tt-ord-prod.cdn-orig-aps > NUM-ENTRIES({ininc/i11in271.i 03}) THEN
                        RUN addNodeDec IN hGenXml  (iProductionOrderId, "APSSource":U, 1, OUTPUT iAPSId).
                      ELSE RUN addNodeDec IN hGenXml  (iProductionOrderId, "APSSource":U, tt-ord-prod.cdn-orig-aps, OUTPUT iAPSId).
                      RUN addNodeLog IN hGenXml (iProductionOrderId, "IsAPSExportedOrder":U, tt-ord-prod.log-ord-export-aps, OUTPUT iAPSId). 

                  &ENDIF

                  RUN addNode IN hGenXml  (iId, "InspectionInformations":U, "":U, OUTPUT iProductionOrderId).  
                  RUN addNodeDec IN hGenXml (iProductionOrderId, "InspectionRoutingNumber":U, tt-ord-prod.nr-ficha, OUTPUT iInspectionId).  
                  RUN addNode IN hGenXml (iProductionOrderId, "InspectionItem":U, substr(tt-ord-prod.it-inspec,1,16), OUTPUT iInspectionId).  

                  RUN addNodeDec IN hGenXml  (iId, "LastSequence":U, tt-ord-prod.nr-ult-seq, OUTPUT iProductionOrderId).  
                  RUN addNodeDec IN hGenXml  (iId, "ReserveLink":U, tt-ord-prod.nr-ord-aber, OUTPUT iProductionOrderId).  
                  RUN addNodeLog IN hGenXml  (iId, "IsRepetitiveProduction":U, tt-ord-prod.prod-repet, OUTPUT iProductionOrderId).  
                  RUN addNodeLog IN hGenXml  (iId, "IsIncludeMRP":U, tt-ord-prod.cons-mrp, OUTPUT iProductionOrderId).  
                  RUN addNodeLog IN hGenXml  (iId, "IsIncludePMP":U, tt-ord-prod.cons-pmp, OUTPUT iProductionOrderId).  
                  RUN addNode IN hGenXml  (iId, "Source":U, tt-ord-prod.origem, OUTPUT iProductionOrderId).  
                  RUN addNodeDec IN hGenXml  (iId, "InvestimentOrderNumber":U, tt-ord-prod.num-ord-inv, OUTPUT iProductionOrderId).  
                  IF tt-ord-prod.dest-manut < 1 OR tt-ord-prod.dest-manut > NUM-ENTRIES({ininc/i05in271.i 03}) THEN
                     RUN addNodeDec IN hGenXml  (iId, "MaintenanceTarget":U, 1, OUTPUT iProductionOrderId).
                  ELSE RUN addNodeDec IN hGenXml  (iId, "MaintenanceTarget":U, tt-ord-prod.dest-manut, OUTPUT iProductionOrderId).
                  RUN addNode IN hGenXml  (iId, "QuotationItem":U, tt-ord-prod.item-cotacao, OUTPUT iProductionOrderId).  

                  IF CAN-FIND (FIRST reservas WHERE reservas.nr-ord-produ = tt-ord-prod.nr-ord-produ) THEN DO:
                       RUN addNode IN hGenXml (iId, "ListOfReservesInformation":U, "":U, OUTPUT iProductionOrderId).

                       FOR EACH reservas WHERE reservas.nr-ord-produ = tt-ord-prod.nr-ord-produ NO-LOCK:

                            ASSIGN r_reserva = ROWID(reserva).
                            /* Inserir a include com as informacoes referentes a reserva */
                            run pi-processa-xml-reservas (input hGenXml,
                                                          input iProductionOrderId,
                                                          input iIdInfReserves,
                                                          input r_reserva).
                      END. /* each reservas */
                  END. /* can-find */    


                /* Adiciona a Lista de Opera‡äes da Ordem */ 
                IF CAN-FIND (FIRST oper-ord WHERE oper-ord.nr-ord-produ = tt-ord-prod.nr-ord-produ) THEN DO:
                     RUN addNode IN hGenXml  (iId, "ListOfOperationOrderInformation":U, "", OUTPUT iProductionOrderId).  

                  FOR EACH oper-ord WHERE 
                           oper-ord.nr-ord-prod = tt-ord-prod.nr-ord-prod NO-LOCK:
                        RUN addNode IN hGenXml  (iProductionOrderId, "OperationOrderInformation":U, "", OUTPUT iOperationOrderId).  
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "OperationOrderCode":U, oper-ord.op-codigo, OUTPUT iOperationId).  
                            RUN addNode IN hGenXml  (iOperationOrderId, "OperationOrderDescription":U, substr(oper-ord.descricao,1,34), OUTPUT iOperationId).  
                            IF oper-ord.tipo-oper < 1 OR 
                               oper-ord.tipo-oper > NUM-ENTRIES({ininc/i05in271.i 03})  THEN
                               RUN addNodeDec IN hGenXml  (iOperationOrderId, "OperationType":U, 1 , OUTPUT iOperationId).  
                            ELSE
                               RUN addNodeDec IN hGenXml  (iOperationOrderId, "OperationType":U, oper-ord.tipo-oper, OUTPUT iOperationId).  
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "Units":U, oper-ord.nr-unidades, OUTPUT iOperationId).  
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "OverlapFactor":U, oper-ord.fator-sobrep, OUTPUT iOperationId).  
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "Proportion":U, oper-ord.proporcao, OUTPUT iOperationId).  
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "NumberOfMen":U, oper-ord.numero-homem, OUTPUT iOperationId).  
                            RUN addNodeLog IN hGenXml  (iOperationOrderId, "IsPrintRecord":U, oper-ord.emite-ficha, OUTPUT iOperationId).  
                            RUN addNodeLog IN hGenXml  (iOperationOrderId, "IsQualityControl":U, oper-ord.oper-cq, OUTPUT iOperationId).  

                            /* Informa‡äes referente aos tempos das Opera‡äes */
                            RUN addNode IN hGenXml  (iOperationOrderId, "TimeOperationInformations":U, "":U, OUTPUT iOperationId).  
                                RUN addNodeDec IN hGenXml  (iOperationId, "TimeUnit":U, oper-ord.un-med-tempo, OUTPUT iOperId).  
                                RUN addNodeDec IN hGenXml  (iOperationId, "SetupTime":U, oper-ord.tempo-prepar, OUTPUT iOperId).   
                                RUN addNodeDec IN hGenXml  (iOperationId, "ManHours":U, oper-ord.tempo-homem, OUTPUT iOperId).

                                RUN addNodeDec IN hGenXml  (iOperationId, "MachineHours":U, oper-ord.tempo-maquin, OUTPUT iOperId).

                                RUN addNodeDec IN hGenXml  (iOperationId, "StartTimeEarlierOfTheOperation":U, oper-ord.qtd-segs-imc-operac, OUTPUT iOperId).
                                RUN addNodeDec IN hGenXml  (iOperationId, "EndTimeLaterOfTheOperation":U, oper-ord.qtd-segs-fmt-operac, OUTPUT iOperId).
                                RUN addNodeDec IN hGenXml  (iOperationId, "PostProcessTime":U, oper-ord.qtd-tempo-pos-proces, OUTPUT iOperId).
                                RUN addNodeDec IN hGenXml  (iOperationId, "SecondsForOperationRelease":U, oper-ord.qtd-segs-liber-operac, OUTPUT iOperId).
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "ScrapFactor":U, oper-ord.refugo-op, OUTPUT iOperationId).  
                            RUN addNode IN hGenXml  (iOperationOrderId, "RoutingCode":U, substr(oper-ord.cod-roteiro,1,16), OUTPUT iOperationId).  
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "AlternativeOperation":U, oper-ord.op-altern, OUTPUT iOperationId).  
                            RUN addNode IN hGenXml  (iOperationOrderId, "Revision":U, oper-ord.revisao, OUTPUT iOperationId).  
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "ProcessSheet":U, oper-ord.fi-codigo, OUTPUT iOperationId).  
                            RUN addNode IN hGenXml  (iOperationOrderId, "Tool":U, oper-ord.ferramenta, OUTPUT iOperationId).  
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "ControlPoint":U, oper-ord.pto-controle, OUTPUT iOperationId).  
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "Sequence":U, oper-ord.sequencia, OUTPUT iOperationId).  

                            IF oper-ord.estado < 1 OR 
                               oper-ord.estado > NUM-ENTRIES({ininc/i01in260.i 03})  THEN
                               RUN addNodeDec IN hGenXml  (iOperationOrderId, "OperationStatus":U, 1, OUTPUT iOperationId).  
                            ELSE
                               RUN addNodeDec IN hGenXml  (iOperationOrderId, "OperationStatus":U, oper-ord.estado, OUTPUT iOperationId).  

                            RUN addNode IN hGenXml  (iOperationOrderId, "RealStartTime":U, oper-ord.h-inireal, OUTPUT iOperationId).  
                            RUN addNode IN hGenXml  (iOperationOrderId, "RealEndTime":U, oper-ord.h-fimreal, OUTPUT iOperationId).
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "ManHoursCalculation":U, oper-ord.form-hom, OUTPUT iOperationId).
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "MachineHoursCalculation":U, oper-ord.form-maq, OUTPUT iOperationId).
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "SetupTimeCalculation":U, oper-ord.form-prep, OUTPUT iOperationId).

                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "NumberOfStandardUnit":U, oper-ord.nr-ups, OUTPUT iOperationId).
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "StandardUnitReported":U, oper-ord.nr-up-rep, OUTPUT iOperationId).
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "SummarizedRequisition":U, oper-ord.nr-req-sum, OUTPUT iOperationId).
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "ReferenceOrder":U, oper-ord.nr-ord-refer, OUTPUT iOperationId).
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "OperationID":U, oper-ord.num-id-operacao, OUTPUT iOperationId).

                            RUN addNode IN hGenXml  (iOperationOrderId, "DirectiveLaborCode":U, oper-ord.cd-mob-dir, OUTPUT iOperationId).
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "Structure":U, oper-ord.nr-estrut, OUTPUT iOperationId).
                            RUN addNodeLog IN hGenXml  (iOperationOrderId, "IsFirstOperation":U, oper-ord.log-operac-inic, OUTPUT iOperationId).
                            RUN addNodeLog IN hGenXml  (iOperationOrderId, "IsLastOperation":U, oper-ord.log-operac-final, OUTPUT iOperationId).
                            RUN addNodeLog IN hGenXml  (iOperationOrderId, "IsRestrictedOperation":U, oper-ord.log-restric-operac, OUTPUT iOperationId).
                            RUN addNodeLog IN hGenXml  (iOperationOrderId, "IsRestrictedPert":U, oper-ord.log-restric-pert, OUTPUT iOperationId).
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "OperationBreak":U, oper-ord.val-perc-avanco, OUTPUT iOperationId).
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "InternalPriority":U, oper-ord.val-priorid-int, OUTPUT iOperationId).
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "ExternalPriority":U, oper-ord.val-priorid-ext, OUTPUT iOperationId).
                            RUN addNode IN hGenXml  (iOperationOrderId, "UnitOfMeasureOperation":U, oper-ord.cod-un-operac, OUTPUT iOperationId).
                            RUN addNode IN hGenXml  (iOperationOrderId, "SetupGroup":U, oper-ord.cod-grp-setup, OUTPUT iOperationId).
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "OperationItemLink":U, oper-ord.val-operac-item, OUTPUT iOperationId).
                            RUN addNodeDec IN hGenXml  (iOperationOrderId, "OperationComponentLink":U, oper-ord.val-compon-item, OUTPUT iOperationId).
                            IF oper-ord.ind-tempo-operac < 1 OR 
                               oper-ord.ind-tempo-operac > NUM-ENTRIES({ininc/i06in144.i 03})  THEN
                               RUN addNodeDec IN hGenXml  (iOperationOrderId, "HandlingTime":U, 1, OUTPUT iOperationId).  
                            ELSE
                               RUN addNodeDec IN hGenXml  (iOperationOrderId, "HandlingTime":U, oper-ord.ind-tempo-operac, OUTPUT iOperationId).  

                            RUN addNodeLog IN hGenXml  (iOperationOrderId, "IsEndedOperation":U, oper-ord.log-operac-finaliz, OUTPUT iOperationId).      

                            &IF DEFINED (bf_man_205) &THEN
                                RUN addNode IN hGenXml  (iOperationOrderId, "SetupReductionTime":U, oper-ord.cod-prepar, OUTPUT iOperationId).      
                                RUN addNode IN hGenXml  (iOperationOrderId, "WorkCenterAdvancedPlanningSchedule":U, oper-ord.centro-aps, OUTPUT iOperationId).      
                                RUN addNodeLog IN hGenXml  (iOperationOrderId, "IsSignificantTime":U, oper-ord.tempo-sig, OUTPUT iOperationId).      
                                RUN addNodeDec IN hGenXml  (iOperationOrderId, "AdvanceFactor":U, oper-ord.fator-ant, OUTPUT iOperationId).      
                                RUN addNodeDec IN hGenXml  (iOperationOrderId, "NumberOfPartsTool":U, oper-ord.nr-pc-ferram, OUTPUT iOperationId).      
                                RUN addNode IN hGenXml  (iOperationOrderId, "SetupReductionTool":U, oper-ord.red-prepar-ferram, OUTPUT iOperationId).      
                                RUN addNode IN hGenXml  (iOperationOrderId, "Tooling":U, oper-ord.cod-ferram, OUTPUT iOperationId).      
                                RUN addNode IN hGenXml  (iOperationOrderId, "ResourceCode":U, oper-ord.cod-recurso, OUTPUT iOperationId). 

                                /* Informa‡äes referente a refugo */
                                RUN addNode IN hGenXml  (iOperationOrderId, "ScrapInformations":U, "":U, OUTPUT  iOperationId).      
                                    RUN addNode IN hGenXml  (iOperationId, "ScrapItemCode":U, oper-ord.cod-item-refugo, OUTPUT iOperId).
                                    FOR FIRST ITEM FIELDS(it-codigo desc-item) WHERE
                                              ITEM.it-codigo = oper-ord.cod-item-refugo NO-LOCK: END.
                                    IF AVAIL ITEM THEN
                                       RUN addNode IN hGenXml  (iOperationId, "ScrapItemDescription":U, substring(item.desc-item,1,60) , OUTPUT  iOperId).
                                    RUN addNodeDec IN hGenXml  (iOperationId, "ScrapItemLink":U, oper-ord.val-relac-refugo-item, OUTPUT iOperId).

                                /* Informa‡äes referente a Lote*/     
                                RUN addNode IN hGenXml  (iOperationOrderId, "LotInformations":U, "":U, OUTPUT iOperationId).     
                                    RUN addNodeDec IN hGenXml  (iOperationId, "MultiplicationLot":U, oper-ord.lote-multiplo, OUTPUT iOperId). 
                                    RUN addNodeDec IN hGenXml  (iOperationId, "StandardLot":U, oper-ord.lote-padrao, OUTPUT iOperId). 
                                    RUN addNodeDec IN hGenXml  (iOperationId, "MinimumLot":U, oper-ord.lote-min, OUTPUT iOperId). 
                             &ENDIF

                             /* Informa‡äes referente a Reporte */
                             RUN addNode IN hGenXml  (iOperationOrderId, "ReportInformations":U, "":U, OUTPUT iOperationId).     
                                 RUN addNodeDec IN hGenXml  (iOperationId, "ReportManHours":U, oper-ord.tempo-hom-rep, OUTPUT iOperId). 
                                 RUN addNodeDec IN hGenXml  (iOperationId, "ReportMachineHours":U, oper-ord.tempo-maq-rep, OUTPUT iOperId). 
                                 RUN addNodeDec IN hGenXml  (iOperationId, "ReportSetupTime":U, oper-ord.tempo-prep-rep, OUTPUT iOperId). 
                             IF oper-ord.ind-reporte-cq < 1 OR 
                                oper-ord.ind-reporte-cq > NUM-ENTRIES({ininc/i07in144.i 03})  THEN
                                RUN addNodeDec IN hGenXml  (iOperationId, "ReportQualityControl":U, 1 , OUTPUT iOperId).  
                             ELSE
                                RUN addNodeDec IN hGenXml  (iOperationId, "ReportQualityControl":U, oper-ord.ind-reporte-cq, OUTPUT iOperId).  
                             RUN addNodeLog IN hGenXml  (iOperationId, "IsReportOperationClose":U, oper-ord.log-fecha-operac, OUTPUT iOperId).  
                             RUN addNodeLog IN hGenXml  (iOperationId, "IsReportedByProductionControl":U, oper-ord.log-reporte-cp, OUTPUT iOperId).  

                             /* Informa‡äes referente ao ChÆo de F brica */
                             RUN addNode IN hGenXml  (iOperationOrderId, "ShopFloorControlInformations":U, "":U, OUTPUT iOperationId).     
                                 RUN addNodeDec IN hGenXml  (iOperationId, "ShopFloorControlOperationID":U, oper-ord.num-operac-sfc, OUTPUT iOperId).     
                                 RUN addNodeDec IN hGenXml  (iOperationId, "ApprovedQuantity":U, oper-ord.qtd-aprov-sfc, OUTPUT iOperId).     
                                 RUN addNodeDec IN hGenXml  (iOperationId, "ReworkQuantity":U, oper-ord.qtd-retrab-sfc, OUTPUT iOperId).     
                                 RUN addNodeDec IN hGenXml  (iOperationId, "ScrappedQuantity":U, oper-ord.qtd-refgda-sfc, OUTPUT iOperId).     
                                 RUN addNodeDec IN hGenXml  (iOperationId, "ReportedQuantity":U, oper-ord.qtd-reptda-sfc, OUTPUT iOperId).     

                            /* Informa‡äes referente a Grupo de M quina */
                             RUN addNode IN hGenXml  (iOperationOrderId, "WorkCenterInformations":U, "":U, OUTPUT iOperationId).     
                                 RUN addNode IN hGenXml  (iOperationId, "WorkCenterCode":U, substr(oper-ord.gm-codigo,1,9), OUTPUT iOperId).     
                                 FOR FIRST grup-maquina FIELDS(gm-codigo descricao) WHERE 
                                           grup-maquina.gm-codigo = oper-ord.gm-codigo NO-LOCK: END.
                                 IF AVAIL grup-maquina THEN
                                     RUN addNode IN hGenXml  (iOperationId, "WorkCenterDescription":U, substr(grup-maquina.descricao,1,32), OUTPUT iOperId).

                             /* Informa‡äes referente a quantidades por operacao */
                             RUN addNode IN hGenXml  (iOperationOrderId, "QuantityInformations":U, "":U, OUTPUT iOperationId).     
                                 RUN addNodeDec IN hGenXml  (iOperationId, "ProducedQuantity":U, oper-ord.qt-produzida, OUTPUT iOperId).     
                                 RUN addNodeDec IN hGenXml  (iOperationId, "ScrapQuantity":U, oper-ord.qt-refugada, OUTPUT iOperId).     
                                 RUN addNodeDec IN hGenXml  (iOperationId, "QuantityApprovedConditionally":U, oper-ord.qt-apr-cond, OUTPUT iOperId).     
                                 RUN addNodeDec IN hGenXml  (iOperationId, "ForecastQuantity":U, oper-ord.qtd-previs-operac, OUTPUT iOperId).
                                 RUN addNodeDec IN hGenXml  (iOperationId, "BatchQuantity":U, oper-ord.qtd-carga-batch, OUTPUT iOperId).
                                 RUN addNodeDec IN hGenXml  (iOperationId, "ProductPalletQuantity":U, oper-ord.qtd-pallet-produt, OUTPUT iOperId).
                                 RUN addNodeDec IN hGenXml  (iOperationId, "CapacityQuantity":U, oper-ord.qtd-capac-operac, OUTPUT iOperId).

                             /* Informa‡äes referente a Pre‡o */
                             RUN addNode IN hGenXml  (iOperationOrderId, "PriceInformations":U, "":U, OUTPUT iOperationId).     
                                 RUN addNodeDec IN hGenXml  (iOperationId, "BasePrice":U, oper-ord.preco-base, OUTPUT iOperId).     
                                 RUN addNodeDec IN hGenXml  (iOperationId, "RepositionPrice":U, oper-ord.preco-repos, OUTPUT iOperId).     

                                 RUN addNodeDec IN hGenXml  (iOperationId, "LastReceptionPrice":U, oper-ord.preco-ul-ent, OUTPUT iOperId).     

                                /*Verifica se ha informacoes da Preco Medio e adiciona [Extent 3]*/
                                Add-ListOfAveragePrice:
                                DO iCount = 1 TO 3:
                                  IF oper-ord.preco-medio[iCount] <> 0 THEN DO:
                                     RUN addNode IN hGenXml (iOperationId, "ListOfAveragePrice":U, "":U, OUTPUT iOperId).
                                      DO iCount = 1 TO 3:
                                         IF oper-ord.preco-medio[iCount] <> 0 THEN DO:
                                             RUN addNode IN hGenXml (iOperId, "AveragePrice":U, "":U, OUTPUT iIdValue).
                                             RUN addNodeDec IN hGenXml (iIdValue, "AveragePriceValue":U, oper-ord.preco-medio[iCount], OUTPUT iAveragePriceId).
                                         END.
                                      END.
                                      LEAVE Add-ListOfAveragePrice.
                                  END.
                                END.

                            /* Informa‡äes referente a Pre‡o */
                             RUN addNode IN hGenXml  (iOperationOrderId, "DateInformations":U, "":U, OUTPUT iOperationId).     
                                 IF oper-ord.data-ult-ent <> ?  THEN
                                    RUN addNodeDate IN hGenXml  (iOperationId, "LastReceptionDate":U, oper-ord.data-ult-ent, OUTPUT iOperId).     
                                 IF oper-ord.data-ult-rep <> ?  THEN
                                    RUN addNodeDate IN hGenXml  (iOperationId, "LastRepositionDate":U, oper-ord.data-ult-rep, OUTPUT iOperId).     
                                 IF oper-ord.dt-reporte <> ?  THEN
                                    RUN addNodeDate IN hGenXml  (iOperationId, "ReportDate":U, oper-ord.dt-reporte, OUTPUT iOperId).     
                                 IF oper-ord.dt-inireal <> ?  THEN
                                    RUN addNodeDate IN hGenXml  (iOperationId, "RealStartDate":U, oper-ord.dt-inireal, OUTPUT iOperId).     
                                 IF oper-ord.dt-fimreal <> ?  THEN
                                    RUN addNodeDate IN hGenXml  (iOperationId, "RealEndtDate":U, oper-ord.dt-fimreal, OUTPUT iOperId).     
                                 IF oper-ord.dat-imc-operac <> ?  THEN
                                    RUN addNodeDate IN hGenXml  (iOperationId, "StartTimeEarlierOperation":U, oper-ord.dat-imc-operac, OUTPUT iOperId).       
                                 IF oper-ord.dat-fmt-operac <> ?  THEN
                                    RUN addNodeDate IN hGenXml  (iOperationId, "LatestPossibleOperationEnd":U, oper-ord.dat-fmt-operac, OUTPUT iOperId).       
                                 IF oper-ord.dat-liber-operac <> ?  THEN
                                    RUN addNodeDate IN hGenXml  (iOperationId, "ReleaseDate":U, oper-ord.dat-liber-operac, OUTPUT iOperId).        

                             /* Informa‡äes referente aos tempos das Opera‡äes */
                             RUN addNode IN hGenXml  (iOperationOrderId, "GanttInformations":U, "":U, OUTPUT iOperationId).  
                                 IF oper-ord.dat-inic-gantt <> ? THEN
                                    RUN addNodeDate IN hGenXml  (iOperationId, "GanttDiagramStartDate":U, oper-ord.dat-inic-gantt, OUTPUT iOperId).  
                                    RUN addNodeDec IN hGenXml  (iOperationId, "GanttDiagramStartTime":U, oper-ord.qtd-hora-inic-gantt, OUTPUT iOperId).  
                                 IF oper-ord.dat-fim-gantt <> ? THEN
                                    RUN addNodeDate IN hGenXml  (iOperationId, "GanttDiagramEndDate":U, oper-ord.dat-fim-gantt, OUTPUT iOperId).  
                                    RUN addNodeDec IN hGenXml  (iOperationId, "GanttDiagramEndTime":U, oper-ord.qtd-hora-fim-gantt, OUTPUT iOperId).  
                  END.
                END.

                 /* Informa‡äes referente a Rede-Pert*/
                IF CAN-FIND (FIRST pert-ordem WHERE pert-ordem.nr-ord-produ = tt-ord-prod.nr-ord-produ) THEN 
                   RUN addNode IN hGenXml  (iId, "ListOfPertOrderInformation":U, "":U, OUTPUT iProductionOrderId).  


                  FOR EACH pert-ordem WHERE 
                           pert-ordem.nr-ord-prod = tt-ord-prod.nr-ord-prod NO-LOCK:
                        RUN addNode IN hGenXml  (iProductionOrderId, "PertOrderInformation":U, "":U, OUTPUT iPertOrderId).  
                            RUN addNode IN hGenXml  (iPertOrderId, "RouteID":U, pert-ordem.cod-roteiro, OUTPUT iPertId).  
                            RUN addNodeDec IN hGenXml  (iPertOrderId, "OperationCode":U, pert-ordem.op-codigo, OUTPUT iPertId).  

                            RUN addNode IN hGenXml  (iPertOrderId, "PreviousItem":U, "":U, OUTPUT iPertId).      
                                RUN addNode IN hGenXml  (iPertId, "PreviousItemCode":U, pert-ordem.it-predec, OUTPUT iPOId).    
                                FOR FIRST ITEM FIELDS(it-codigo desc-item) WHERE 
                                          item.it-codigo = pert-ordem.it-predec NO-LOCK: END.
                                IF AVAIL ITEM THEN
                                   RUN addNode IN hGenXml  (iPertId, "PreviousItemDescription":U, item.desc-item, OUTPUT iPOId).    

                            RUN addNode IN hGenXml  (iPertOrderId, "PreviousRouteID":U, pert-ordem.rot-predec, OUTPUT iPertId).  
                            RUN addNode IN hGenXml  (iPertOrderId, "PreviousOperationCode":U, pert-ordem.op-predec, OUTPUT iPertId).  
                            RUN addNodeDec IN hGenXml  (iPertOrderId, "Overlap":U, pert-ordem.overlap, OUTPUT iPertId).  
                            RUN addNodeDec IN hGenXml  (iPertOrderId, "OverlapQuantity":U, pert-ordem.qtd-overlap, OUTPUT iPertId).  
                            RUN addNodeDec IN hGenXml  (iPertOrderId, "Transport":U, pert-ordem.transporte, OUTPUT iPertId).  
                            RUN addNodeDec IN hGenXml  (iPertOrderId, "ProcessingOperation":U, pert-ordem.num-operac-predec, OUTPUT iPertId).  
                            RUN addNodeDec IN hGenXml  (iPertOrderId, "FollowingOperation":U, pert-ordem.num-operac-suces, OUTPUT iPertId).  
                            RUN addNodeLog IN hGenXml  (iPertOrderId, "IsActive":U, pert-ordem.log-ativo , OUTPUT iPertId).  
                  END.


        END.
        ELSE IF pTranAction = "DEL" THEN DO:
                /* no principal delete */
                RUN addNode IN hGenXml (0, "Delete":U, "":U, OUTPUT iFirstId).
                RUN addNode IN hGenXml (iFirstId, "ProductionOrderNumber":U, tt-ord-prod.nr-ord-produ, OUTPUT iId).
        END.

    END.

    /* Obt‚m XMl na variavel handle */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).
    /*hBusinessContent:SAVE("FILE", "C:~\ProductionOrder.xml").*/
    /* Passa handle do BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).
    /* Elimina handle */
    DELETE OBJECT hBusinessContent NO-ERROR.
    /* Envia XML para ControlBroker */
    RUN sendMessage IN hMessageHandler (INPUT "ma2/ProductionOrder_204_000.xsd").

    /*Verifica se a mensagem foi enviada com sucesso */
    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess,
                                            OUTPUT pTotalErrors).
    IF NOT pSendSuccess THEN DO:
      REPEAT iCount = 1 TO pTotalErrors:
          RUN getError IN hMessageHandler (iCount,
                                             OUTPUT pErrorNumber,
                                             OUTPUT pErrorType,
                                             OUTPUT pErrorDesc).
          IF pErrorType <> "business_error" THEN ASSIGN pErrorNumber = 17006.
          run piCriaErro (pErrorNumber,
                          pErrorType, 
                          substring(pErrorDesc,1,800)).

      END.
      RETURN "NOK":U.

   END.

END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
