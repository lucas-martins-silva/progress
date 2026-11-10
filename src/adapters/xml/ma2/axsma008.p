/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSMA008 2.00.00.006}  /*** 010006 ***/



/********************************************************************************/
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : AXSMA006.p
    Description : ADAPTER DE ENVIO DO ESTORNO DO REPORTE DE PRODU€ÇO 
    CREATEd     : 02/04/2004 10:00
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */

/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlTranName      ReportProductionReversal
&GLOBAL-DEFINE XmlTranVersion   204.000
&GLOBAL-DEFINE XmlProdName      EMS2
&GLOBAL-DEFINE XmlProdVersion   204
&GLOBAL-DEFINE XmlApp           MA2 
&GLOBAL-DEFINE XmlMod           CPP

/* Defini‡Æo das temp-table do reporte por item */
{cpp/cpapi009.i}

/* Defini‡Æo temp-table RowErrors */
{cdp/cd9043.i}
{cdp/cd9043.i1}

/*Parƒmetros de entrada*/
DEF INPUT PARAM pTranAction  AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgName    AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgVersion AS CHAR    NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-rep-prod.
DEF OUTPUT PARAM TABLE FOR RowErrors.

/* Vari veis Globais */
DEF VAR hGenXml          AS HANDLE NO-UNDO.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.

/* Variaveis da constru‡Æo do BusinessContent Utilizando APIXML */
DEF VAR iId            AS INT NO-UNDO.
DEF VAR iFirstId       AS INT NO-UNDO. 
DEF VAR iIdRepProd     AS INT NO-UNDO. 
DEF VAR iIdItem        AS INT NO-UNDO. 
DEF VAR iIdReference   AS INT NO-UNDO. 
DEF VAR iIdItemSerial  AS INT NO-UNDO. 
DEF VAR iIdItemSerialInf AS INT NO-UNDO. 
DEF VAR iIdSite          AS INT NO-UNDO. 
DEF VAR iIdQtdProdReport AS INT NO-UNDO. 
DEF VAR iIdScrapAccount  AS INT NO-UNDO. 
DEF VAR iIdDocument      AS INT NO-UNDO. 
DEF VAR iIdEntrance      AS INT NO-UNDO. 
DEF VAR iIdIssue         AS INT NO-UNDO. 

DEF VAR iIdWareHouse     AS INT NO-UNDO.
DEF VAR iIdLocation      AS INT NO-UNDO.


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
IF NOT CAN-FIND(FIRST tt-rep-prod) THEN DO:

    {utp/ut-liter.i Estorno_Reporte_de_Produ‡Æo_para_Integra‡Æo_EAI * r}
    run piCriaErro (5561,
                    'EMS':U, 
                    TRIM(return-value)).
     RETURN "NOK":U.
END.

FOR EACH tt-rep-prod NO-LOCK:

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
                                         INPUT "ReportProductionReversal",
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
    RUN setKeyFields IN hMessageHandler ("rep-prod.nr-reporte",
                                         STRING(tt-rep-prod.nr-reporte)). 

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

        IF pTranAction = "add" THEN DO:

            /* Nà PRINCIPAL UPSERT */

            RUN addNode IN hGenXml (0,
                                    "Upsert",
                                    "",
                                    OUTPUT iFirstId).

            /* Adiciona informacoes do Movimento do Reporte */
                RUN addNodeDec IN hGenXml  (iFirstId, "ReportNumber", tt-rep-prod.nr-reporte, OUTPUT iId).
                RUN addNode IN hGenXml  (iFirstId, "ApplicationAccountNumber", tt-rep-prod.cod-cta-unif, OUTPUT iId).
                RUN addNode IN hGenXml  (iFirstId, "ApplicationSubAccountNumber", tt-rep-prod.cod-ccusto-unif, OUTPUT iId).
                RUN addNodeDate IN hGenXml (iFirstId, "ReportDate", tt-rep-prod.data, OUTPUT iId).
                RUN addNode IN hGenXml  (iFirstId, "ReportHour", tt-rep-prod.hora, OUTPUT iId).
                RUN addNode IN hGenXml  (iFirstId, "UserID", tt-rep-prod.usuario, OUTPUT iId).
                RUN addNode IN hGenXml  (iFirstId, "ProductionReportType", tt-rep-prod.rep-prod, OUTPUT iId).

            /* Adiciona informacoes do Item */
            RUN addNode IN hGenXml (iFirstId, "Item", "", OUTPUT iId).

            FOR FIRST item FIELDS (it-codigo desc-item tipo-con-est) WHERE item.it-codigo = tt-rep-prod.it-codigo  NO-LOCK: END. 
            IF AVAIL item THEN
               RUN addNode IN hGenXml (iId, "ItemDescription", SUBSTRING(item.desc-item,1,60), OUTPUT iIdItem).
            RUN addNode IN hGenXml (iId, "ItemCode", tt-rep-prod.it-codigo, OUTPUT iIdItem).

            /* Adiciona informa‡oes referentes aos itens com Controle por Referencia */
            IF AVAIL item AND item.tipo-con-est = 4 THEN DO:
                RUN addNode IN hGenXml (iId, "Reference":U, "", OUTPUT iIdItem). 
                RUN addNode IN hGenXml (iIdItem, "ReferenceCode":U, tt-rep-prod.cod-refer, OUTPUT iIdReference).
                FOR FIRST referencia WHERE referencia.cod-refer = tt-rep-prod.cod-refer NO-LOCK: END.
                IF AVAIL referencia THEN 
                   RUN addNode IN hGenXml (iIdItem, "ReferenceDescription":U, SUBSTRING(referencia.descricao, 1,32), OUTPUT iIdReference).
            END.

            /* Adiciona informa‡oes do Estabelecimento */
            RUN addNode IN hGenXml (iFirstId, "Site":U, "", OUTPUT iId).
            RUN addNode IN hGenXml (iId, "SiteID":U, tt-rep-prod.cod-estabel, OUTPUT iIdSite).
            FOR FIRST estabelec WHERE estabelec.cod-estabel = tt-rep-prod.cod-estabel  NO-LOCK: END. 
            IF AVAIL estabelec THEN
               RUN addNode IN hGenXml (iId, "SiteDescription":U, estabelec.nome, OUTPUT iIdSite).

            /* Adiciona informa‡oes quantitativas do Reporte */
            RUN addNode IN hGenXml (iFirstId, "QuantityProductionReport":U, "", OUTPUT iId).
            RUN addNodeDec IN hGenXml (iId, "QuantityOfReport":U, tt-rep-prod.qt-reporte, OUTPUT iIdQtdProdReport).
            RUN addNodeDec IN hGenXml (iId, "QuantityOfScrap":U, tt-rep-prod.qt-refugo, OUTPUT iIdQtdProdReport).

            /* A quantidade estornada sempre sera o equivalente a quantidade total reportada, visto que nao e permitido 
               realizar estorno parciais */
            RUN addNodeDec IN hGenXml (iId, "QuantityOfReversal":U, tt-rep-prod.qt-estorno, OUTPUT iIdQtdProdReport).

            RUN addNodeDec IN hGenXml (iId, "QuantityApprovedConditionallyAndInvalidated":U, tt-rep-prod.qt-est-aprov, OUTPUT iIdQtdProdReport).
            RUN addNodeDec IN hGenXml (iId, "QuantityOfInvalidatedScrap":U, tt-rep-prod.qt-est-refugo, OUTPUT iIdQtdProdReport).
            RUN addNodeDec IN hGenXml (iId, "OrderQuantityApprovedConditionally":U, tt-rep-prod.qt-apr-cond, OUTPUT iIdQtdProdReport).

            /* Adiciona informa‡oes do Conta do Refugo */
            RUN addNode IN hGenXml (iFirstId, "ScrapAccount":U, "", OUTPUT iId).
            RUN addNode IN hGenXml (iId, "AccountNumber":U, tt-rep-prod.ct-refugo, OUTPUT iIdScrapAccount).
            RUN addNode IN hGenXml (iId, "SubAccountNumber":U, tt-rep-prod.sc-refugo, OUTPUT iIdScrapAccount).
            
            /* Adiciona informa‡oes do Documento */
            RUN addNode IN hGenXml (iFirstId, "Document":U, "", OUTPUT iId).
            RUN addNode IN hGenXml (iId, "DocumentNumber":U, tt-rep-prod.nro-docto, OUTPUT iIdDocument).
            RUN addNode IN hGenXml (iId, "DocumentSeries":U, tt-rep-prod.serie-docto, OUTPUT iIdDocument).

            /* Entrada de Materiais */
            RUN addNode IN hGenXml (iFirstId, "MaterialEntranceLocation":U, "", OUTPUT iId).

            /* Adiciona informacoes do Deposito de Entrada */
            RUN addNode IN hGenXml (iId, "WareHouse", "", OUTPUT iIdEntrance).
            RUN addNode IN hGenXml (iIdEntrance, "WareHouseCode", tt-rep-prod.cod-depos, OUTPUT iIdWareHouse).
            FOR FIRST deposito WHERE deposito.cod-depos = tt-rep-prod.cod-depos NO-LOCK: END. 
            IF AVAIL deposito THEN
               RUN addNode IN hGenXml (iIdEntrance, "WareHouseDescription", SUBSTRING(deposito.nome,1,40), OUTPUT iIdWareHouse).

            /* Adiciona informacoes da Localizacao de Entrada */
            RUN addNode IN hGenXml (iId, "Location", "", OUTPUT iIdEntrance).
            RUN addNode IN hGenXml (iIdEntrance, "LocationCode", tt-rep-prod.cod-localiz, OUTPUT iIdLocation).
            FOR FIRST localizacao WHERE localizacao.cod-localiz = tt-rep-prod.cod-localiz NO-LOCK: END.
            IF AVAIL localizacao THEN
               RUN addNode IN hGenXml (iIdEntrance, "LocationDescription", SUBSTRING(localizacao.descricao,1,30), OUTPUT iIdLocation).
            IF tt-rep-prod.dt-vali-lote <> ? THEN
               RUN addNodeDate IN hGenXml (iId, "LotValidityDate", tt-rep-prod.dt-vali-lote, OUTPUT iIdEntrance).
            RUN addNode IN hGenXml (iId, "LotOrSerialNumber", tt-rep-prod.lote, OUTPUT iIdEntrance).

            /* Saida de Materiais */
            RUN addNode IN hGenXml (iFirstId, "MaterialIssueLocation":U, "", OUTPUT iId).

            /* Adiciona informacoes do Deposito de Saida */
            RUN addNode IN hGenXml (iId, "WareHouse", "", OUTPUT iIdIssue).
            RUN addNode IN hGenXml (iIdIssue, "WareHouseCode", tt-rep-prod.cod-depos-sai, OUTPUT iIdWareHouse).
            FOR FIRST deposito WHERE deposito.cod-depos = tt-rep-prod.cod-depos-sai NO-LOCK: END. 
            IF AVAIL deposito THEN
               RUN addNode IN hGenXml (iIdIssue, "WareHouseDescription", SUBSTRING(deposito.nome,1,40), OUTPUT iIdWareHouse).

            /* Adiciona informacoes da Localizacao de Saida */
            RUN addNode IN hGenXml (iId, "Location", "", OUTPUT iIdIssue).
            RUN addNode IN hGenXml (iIdIssue, "LocationCode", tt-rep-prod.cod-local-sai, OUTPUT iIdLocation).
            FOR FIRST localizacao WHERE localizacao.cod-localiz = tt-rep-prod.cod-local-sai NO-LOCK: END.
            IF AVAIL localizacao THEN
               RUN addNode IN hGenXml (iIdIssue, "LocationDescription", SUBSTRING(localizacao.descricao,1,30), OUTPUT iIdLocation).
            RUN addNodeLog IN hGenXml (iIdIssue, "IsComponentsExitLocalizationUnique", tt-rep-prod.dt-vali-lote, OUTPUT iIdLocation).

        END.
        ELSE IF pTranAction = "DEL" THEN DO:
                /* no principal delete */
                RUN addNode IN hGenXml (0, "Delete", "", OUTPUT iFirstId).
                RUN addNode IN hGenXml (iFirstId, "ReportNumber", tt-rep-prod.nr-reporte, OUTPUT iId).
        END.

    END.

    /* Obt‚m XMl na variavel handle */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).
    /*hBusinessContent:SAVE("FILE", "y:/temp/Estorno.xml").*/

    /* Passa handle do BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

    /* Elimina handle */
    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Envia XML para ControlBroker */                                       
    &IF "{&mguni_version}" >= "2.071" &THEN
        RUN sendMessage IN hMessageHandler (INPUT "ma2/ReportProductionReversal_204_001.xsd").
    &ELSE
        RUN sendMessage IN hMessageHandler (INPUT "ma2/ReportProductionReversal_204_000.xsd").
    &ENDIF

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
                          pErrorDesc).
      END.
      RETURN "NOK":U.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
