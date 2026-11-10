&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSMF008 2.00.00.002}  /*** 010002 ***/


/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlTranName      FleetOrder
&GLOBAL-DEFINE XmlTranVersion   204.000
&GLOBAL-DEFINE XmlProdName      EMS2
&GLOBAL-DEFINE XmlProdVersion   204
&GLOBAL-DEFINE XmlApp           MN2 
&GLOBAL-DEFINE XmlMod           MFO


/* Defini‡Æo das temp-table do Equipmento */
def temp-table tt-mmv-ord-manut no-undo like mmv-ord-manut
    field r-rowid as rowid.

/* Defini‡Æo temp-table RowErrors */
{cdp/cd9043.i}
{cdp/cd9043.i1}

/*** Bibliotecas padräes ***/
{utp/ut-glob.i}

/*Parƒmetros de entrada*/
DEF INPUT PARAM pTranAction  AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgName    AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgVersion AS CHAR    NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-mmv-ord-manut.
DEF OUTPUT PARAM TABLE FOR RowErrors.

/* Vari veis Globais */
DEF VAR hGenXml          AS HANDLE NO-UNDO.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.

/* Variaveis da constru‡Æo do BusinessContent Utilizando APIXML */
DEFINE VARIABLE iId         AS INTEGER NO-UNDO.
DEFINE VARIABLE iFirstId    AS INTEGER NO-UNDO. 

DEFINE VARIABLE iIdDates                  AS INTEGER NO-UNDO.
DEFINE VARIABLE iIdAccounts               AS INTEGER NO-UNDO.
DEFINE VARIABLE iIdEquipment             AS INTEGER NO-UNDO.
DEFINE VARIABLE iIdComponent              AS INTEGER NO-UNDO.
DEFINE VARIABLE iIdMaintenanceType        AS INTEGER NO-UNDO.
DEFINE VARIABLE iIdMechanicWorkShop       AS INTEGER NO-UNDO.
DEFINE VARIABLE iIdPlanner                 AS INTEGER NO-UNDO.
DEFINE VARIABLE iIdSite                   AS INTEGER NO-UNDO.
DEFINE VARIABLE iIdMechanicWorkShopSector AS INTEGER NO-UNDO.


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

DEFINE VARIABLE cEstado AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTip    AS CHARACTER  NO-UNDO.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Verifica se h  registros na temp-table */
IF NOT CAN-FIND(FIRST tt-mmv-ord-manut) THEN DO:
    {utp/ut-liter.i Movimentos_da_Ordem * r}
    run piCriaErro (5561,
                    'EMS':U, 
                    TRIM(return-value)).
     RETURN "NOK":U.
     LEAVE.
END.


FOR EACH tt-mmv-ord-manut NO-LOCK:
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
                                         INPUT "FleetOrder",
                                         INPUT  pTranAction,
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

    /* Indica valor da chave prim ria da transa‡Æo */
    RUN setKeyFields IN hMessageHandler ("mmv-ord-manut.nr-ord-prod":U,
                                         STRING(tt-mmv-ord-manut.nr-ord-prod)). 

    /* Cria mensagem do BusinessContent atrav‚s da API*/
    CREATE-BUSINESS-XML:
    DO:
         /* RESETA OS VALORES */
       RUN reset IN hGenXml.
       /* SETA VALOR DE ENCODING */
       RUN setEncoding IN hGenXml ("UTF-8").
       IF pTranAction = "add":U OR pTranAction = "upd":U THEN DO:
           /* Nà PRINCIPAL UPSERT */
           RUN addNode IN hGenXml (0, "Upsert" , "", OUTPUT iFirstId).
           /* Adiciona informa‡äes da Ordem */

           /*{ininc/i01in271.i 04 tt-mmv-ord-manut.estado       }     
             {frinc/i00fr072.i 04 tt-mmv-ord-manut.idi-tip-ord}*/
           if iFirstId <> ? then do:
                RUN addNodeDec IN hGenXml (iFirstId, "OrderNumber", tt-mmv-ord-manut.nr-ord-produ, OUTPUT iId).
                RUN addNodeDec IN hGenXml (iFirstId, "OrderStatus",tt-mmv-ord-manut.estado      , OUTPUT iId).
                RUN addNodeDec IN hGenXml (iFirstId, "OrderType",  tt-mmv-ord-manut.idi-tip-ord ,OUTPUT iId).
                
                RUN addNode IN hGenXml (iFirstId, "Dates", "", OUTPUT iIdDates).
                IF iIdDates <> ? THEN DO:
                     RUN addNodeDate IN hGenXml (iIdDates, "OpeningDate", tt-mmv-ord-manut.dat-abert, OUTPUT iId).
                     RUN addNode     IN hGenXml (iIdDates, "OpeningHour", tt-mmv-ord-manut.hra-abert, OUTPUT iId).
                     RUN addNodeDec  IN hGenXml (iIdDates, "OpeningInvertedHourDate", tt-mmv-ord-manut.val-dat-invrtda-abert, OUTPUT iId).
                     IF tt-mmv-ord-manut.dat-entr <> ?  THEN
                         RUN addNodeDate IN hGenXml (iIdDates, "EntranceDate", tt-mmv-ord-manut.dat-entr, OUTPUT iId).
                     RUN addNode     IN hGenXml (iIdDates, "EntranceHour", tt-mmv-ord-manut.hra-entr, OUTPUT iId).
                     IF tt-mmv-ord-manut.val-dat-invrtda-entr <> ? AND tt-mmv-ord-manut.val-dat-invrtda-entr > 0 THEN
                        RUN addNodeDec     IN hGenXml (iIdDates, "EntranceInvertedHourDate", tt-mmv-ord-manut.val-dat-invrtda-entr, OUTPUT iId).
                     IF tt-mmv-ord-manut.dat-prev-term <> ?  THEN
                         RUN addNodeDate IN hGenXml (iIdDates, "ForecasEndingDate", tt-mmv-ord-manut.dat-prev-term, OUTPUT iId).
                     RUN addNode     IN hGenXml (iIdDates, "ForecasEndingHour", tt-mmv-ord-manut.hra-prev-term, OUTPUT iId).
                     IF tt-mmv-ord-manut.val-dat-invrtda-prev <> ? AND tt-mmv-ord-manut.val-dat-invrtda-prev > 0 THEN
                        RUN addNodeDec  IN hGenXml (iIdDates, "ForecasEndingInvertedHourDate", tt-mmv-ord-manut.val-dat-invrtda-prev, OUTPUT iId).
                     IF tt-mmv-ord-manut.dat-term <> ?  THEN
                         RUN addNodeDate IN hGenXml (iIdDates, "EndingDate", tt-mmv-ord-manut.dat-term, OUTPUT iId).
                     RUN addNode     IN hGenXml (iIdDates, "EndingHour", tt-mmv-ord-manut.hra-term, OUTPUT iId).
                     IF tt-mmv-ord-manut.val-dat-invrtda-term <> ? AND tt-mmv-ord-manut.val-dat-invrtda-term > 0 THEN
                        RUN addNodeDec  IN hGenXml (iIdDates, "EndingInvertedHourDate", tt-mmv-ord-manut.val-dat-invrtda-term, OUTPUT iId).
                     IF tt-mmv-ord-manut.dat-criacao <> ?  THEN
                        RUN addNodeDate IN hGenXml (iIdDates, "CreateDate", tt-mmv-ord-manut.dat-criacao, OUTPUT iId).
                     RUN addNode     IN hGenXml (iIdDates, "CreateHour", tt-mmv-ord-manut.hra-criacao, OUTPUT iId).
                END.
                
                RUN addNode IN hGenXml (iFirstId, "Accounts", "", OUTPUT iIdAccounts).
                IF iIdAccounts <> ? THEN DO:
                    RUN addNodeDec IN hGenXml (iIdAccounts, "OrderCompanyCode", tt-mmv-ord-manut.ep-codigo-ordem, OUTPUT iId).
                    RUN addNode    IN hGenXml (iIdAccounts, "OrderAccountCode", tt-mmv-ord-manut.ct-ordem, OUTPUT iId).
                    RUN addNode    IN hGenXml (iIdAccounts, "OrderCostCenterCode", tt-mmv-ord-manut.cc-ordem, OUTPUT iId).
                    RUN addNodeDec IN hGenXml (iIdAccounts, "ExpenseCompanyCode", tt-mmv-ord-manut.ep-codigo-despe, OUTPUT iId).
                    RUN addNode    IN hGenXml (iIdAccounts, "ExpenseAccountCode", tt-mmv-ord-manut.ct-codigo, OUTPUT iId).
                    RUN addNode    IN hGenXml (iIdAccounts, "ExpenseCostCenterCode", tt-mmv-ord-manut.cc-codigo, OUTPUT iId).
                END.
                IF tt-mmv-ord-manut.idi-tip-ord = 1 THEN DO:
                    RUN addNode IN hGenXml (iFirstId, "Equipment", "", OUTPUT iIdEquipment).
                    IF iIdEquipment <> ? THEN DO:
                        FOR FIRST mab-eqpto WHERE mab-eqpto.ep-codigo = tt-mmv-ord-manut.ep-codigo
                                              AND mab-eqpto.cod-eqpto = tt-mmv-ord-manut.cod-eqpto NO-LOCK:
                            FOR FIRST mab-model WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
                            END.
                        END.
                        IF AVAIL mab-eqpto AND AVAIL mab-model THEN DO:
                            RUN addNodeDec IN hGenXml (iIdEquipment, "CompanyCode", tt-mmv-ord-manut.ep-codigo, OUTPUT iId).
                            RUN addNode    IN hGenXml (iIdEquipment, "EquipmentCode", tt-mmv-ord-manut.cod-eqpto, OUTPUT iId).
                            RUN addNode    IN hGenXml (iIdEquipment, "ModelDescription", mab-model.des-model, OUTPUT iId).
                            RUN addNode    IN hGenXml (iIdEquipment, "Accountant", tt-mmv-ord-manut.val-hodom-horim, OUTPUT iId).
                        END.
    
                    END.
                END.
                ELSE IF tt-mmv-ord-manut.idi-tip-ord = 2 THEN DO:
                    RUN addNode IN hGenXml (iFirstId, "Component", "", OUTPUT iIdComponent).
                    IF iIdComponent <> ? THEN DO:
                        FOR FIRST mco-compon WHERE mco-compon.cod-sub-sist = tt-mmv-ord-manut.cod-sub-sist
                                               AND mco-compon.cod-compon = tt-mmv-ord-manut.cod-compon NO-LOCK:
                        END.
                        IF AVAIL mco-compon THEN DO:
                            RUN addNode    IN hGenXml (iIdComponent, "SubSystemCode", tt-mmv-ord-manut.cod-sub-sist, OUTPUT iId).
                            RUN addNode    IN hGenXml (iIdComponent, "ComponentCode", tt-mmv-ord-manut.cod-compon, OUTPUT iId).
                            RUN addNodeDec IN hGenXml (iIdComponent, "Sequential", tt-mmv-ord-manut.num-seqcial, OUTPUT iId).
                            RUN addNode    IN hGenXml (iIdComponent, "ComponentModelDescription", mco-compon.des-model, OUTPUT iId).
                        END.
                    END.
                END.
                
                RUN addNode IN hGenXml (iFirstId, "MaintenanceType", "", OUTPUT iIdMaintenanceType).
                IF iIdMaintenanceType <> ? THEN DO:
                    FOR FIRST tipo-manut WHERE tipo-manut.cd-tipo = tt-mmv-ord-manut.cd-tipo NO-LOCK:
                    END.
                    IF AVAIL tipo-manut THEN DO:
                        RUN addNodeDec IN hGenXml (iIdMaintenanceType, "MaintenanceTypeCode", tt-mmv-ord-manut.cd-tipo, OUTPUT iId).
                        RUN addNode    IN hGenXml (iIdMaintenanceType, "MaintenanceTypeDescription", tipo-manut.descricao, OUTPUT iId).
                    END.
                END.

                RUN addNode IN hGenXml (iFirstId, "MechanicWorkshop", "", OUTPUT iIdMechanicWorkShop).
                IF iIdMechanicWorkShop <> ? THEN DO:
                    FOR FIRST mmv-ofici WHERE mmv-ofici.cod-ofici = tt-mmv-ord-manut.cod-ofici NO-LOCK:
                    END.
                    IF AVAIL mmv-ofici THEN DO:
                        RUN addNode IN hGenXml (iIdMechanicWorkShop, "MechanicWorkshopCode", tt-mmv-ord-manut.cod-ofici, OUTPUT iId).
                        RUN addNode IN hGenXml (iIdMechanicWorkShop, "MechanicWorkshopDescription", mmv-ofici.des-ofici, OUTPUT iId).
                    END.
                END.
                RUN addNode IN hGenXml (iFirstId, "Planner", "", OUTPUT iIdPlanner).
                IF iIdPlanner <> ? THEN DO:
                    FOR FIRST mmv-plandor WHERE mmv-plandor.cod-plandor = tt-mmv-ord-manut.cod-plandor NO-LOCK:
                    END.
                    IF AVAIL mmv-plandor THEN DO:
                        RUN addNode IN hGenXml (iIdPlanner, "PlannerCode", tt-mmv-ord-manut.cod-plandor, OUTPUT iId).
                        RUN addNode IN hGenXml (iIdPlanner, "PlannerName", mmv-plandor.nom-plandor, OUTPUT iId).
                    END.
                END.

                RUN addNode IN hGenXml (iFirstId, "Site", "", OUTPUT iIdSite).
                IF iIdSite <> ? THEN DO:
                    FOR FIRST estabelec WHERE estabelec.cod-estabel = tt-mmv-ord-manut.cod-estabel NO-LOCK:
                    END.
                    IF AVAIL estabelec THEN DO:
                        RUN addNode IN hGenXml (iIdSite, "SiteCode", tt-mmv-ord-manut.cod-estabel, OUTPUT iId).
                        RUN addNode IN hGenXml (iIdSite, "SiteDescription", estabelec.nome, OUTPUT iId).
                    END.
                END.

                RUN addNode IN hGenXml (iFirstId, "MechanicWorkshopSector", "", OUTPUT iIdMechanicWorkshopSector).
                IF iIdMechanicWorkshopSector <> ? THEN DO:
                    FOR FIRST mmv-setor-ofici WHERE mmv-setor-ofici.cod-setor-ofici = tt-mmv-ord-manut.cod-setor-ofici NO-LOCK:
                    END.
                    IF AVAIL mmv-setor-ofici THEN DO:
                        RUN addNode    IN hGenXml (iIdMechanicWorkshopSector, "MechanicWorkshopSectorCode", tt-mmv-ord-manut.cod-setor-ofici, OUTPUT iId).
                        RUN addNode    IN hGenXml (iIdMechanicWorkshopSector, "MechanicWorkshopSectorDescription", mmv-setor-ofici.des-setor-ofici, OUTPUT iId).
                        RUN addNode    IN hGenXml (iIdMechanicWorkshopSector, "UserCode", tt-mmv-ord-manut.cod-usuar, OUTPUT iId).
                        RUN addNodeDec IN hGenXml (iIdMechanicWorkshopSector, "OriginDocument", tt-mmv-ord-manut.num-docto-orig, OUTPUT iId).
                        RUN addNodeDec IN hGenXml (iIdMechanicWorkshopSector, "InvestmentOrder", tt-mmv-ord-manut.num-ord-invest, OUTPUT iId).
                        RUN addNode    IN hGenXml (iIdMechanicWorkshopSector, "Comments", tt-mmv-ord-manut.dsl-obs, OUTPUT iId).
                    END.
                END.
           END.
       END.
       ELSE IF pTranAction = "DEL":U THEN DO:
            /* n¢ principal delete */
            RUN addNode IN hGenXml (0, "Delete", "", OUTPUT iFirstId).
            RUN addNode IN hGenXml (iFirstId, "OrderNumber", tt-mmv-ord-manut.nr-ord-produ, OUTPUT iId).
       END.
                
       /* Obt‚m XMl na variavel handle */
       RUN generateXML IN hGenXml (OUTPUT hBusinessContent).
        
       /* Passa handle do BusinessContent */
       RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).
        
       /* Elimina handle */
       DELETE OBJECT hBusinessContent NO-ERROR.
        

       /* Envia XML para ControlBroker */                                       
       RUN sendMessage IN hMessageHandler (INPUT "mn2/FleetOrder_204_000.xsd":U).
        
       
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
           IF CAN-FIND(FIRST rowerrors WHERE rowerrors.errortype = "business_error":U) THEN DO:
                RETURN "NOK":U.
                LEAVE.
           END.
       END.
      
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


