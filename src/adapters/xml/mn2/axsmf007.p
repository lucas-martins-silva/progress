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
{include/i-prgvrs.i AXSMF007 2.00.00.003 } /*** 010003 ***/


/*------------------------------------------------------------------------
    File        : axSmf007.p
    Purpose     :   Envio dos Custos do Equipamento
    Syntax      :
    Description :
    Author(s)   : Carlos Alberto Valentini
    Created     : 07/03/2005
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

   

/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlTranName      EquipmentsCost
&GLOBAL-DEFINE XmlTranVersion   204.000
&GLOBAL-DEFINE XmlProdName      EMS2
&GLOBAL-DEFINE XmlProdVersion   204
&GLOBAL-DEFINE XmlApp           MN2 
&GLOBAL-DEFINE XmlMod           MFO

/*** temp-table de exporta‡Æo da XML ***/
def temp-table ttIntegr-eqpto-cust-event no-undo
    field ep-codigo   like mab-eqpto.ep-codigo
    field cod-eqpto   like mab-eqpto.cod-eqpto
    field dat-movto   like mgf-eqpto-cust-event.dat-movto
    field cod-estabel like mmv-movto-ord.cod-estabel 
    field cod-evento  like mab-event.cod-evento
    field des-evento  like mab-event.des-evento
    field valor       like mgf-cust-eqpto.val-combust-corren 
    field quantidade  like mgf-cust-eqpto.val-quant-combust
    index id is primary unique ep-codigo
                               cod-eqpto
                               dat-movto
                               cod-estabel
                               cod-evento.
{cdp/cdcfgmnt.i}
{cdp/cdcfgman.i}
{cdp/cdcfgmnt.i}
{cdp/cdcfgmat.i}
{gfp/gf0404.i tt-param}
def buffer  bfIntegrCust1 for ttIntegr-eqpto-cust-event.
def buffer  bfIntegrCust2 for ttIntegr-eqpto-cust-event.

/* Defini‡Æo temp-table RowErrors */
{cdp/cd9043.i}
{cdp/cd9043.i1}

/*** Bibliotecas padräes ***/
{utp/ut-glob.i}

/*Parƒmetros de entrada*/
DEF INPUT PARAM pTranAction  AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgName    AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgVersion AS CHAR    NO-UNDO.
DEF INPUT PARAM TABLE FOR ttIntegr-eqpto-cust-event.
DEF INPUT PARAM TABLE FOR tt-param.
DEF OUTPUT PARAM TABLE FOR RowErrors.

/* Vari veis Globais */
DEF VAR hGenXml          AS HANDLE NO-UNDO.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.

/* Variaveis da constru‡Æo do BusinessContent Utilizando APIXML */
DEF VAR iId                 AS INT NO-UNDO.
DEF VAR iIdS                AS INT NO-UNDO.
DEF VAR iIdP                AS INT NO-UNDO.
DEF VAR iFirstId            AS INT NO-UNDO. 
DEF VAR iIdGrpEqpto         AS INT NO-UNDO. 
DEF VAR iIdModel            AS INT NO-UNDO. 
DEF VAR iIdEstrut           AS INT NO-UNDO. 
DEF VAR iIdListSite         AS INT NO-UNDO. 
DEF VAR iIdListEvents       AS INT NO-UNDO.
DEF VAR iIdSite             AS INT NO-UNDO. 
DEF VAR iIdEvent            AS INT NO-UNDO. 
DEF VAR iIdEqpto            AS INT NO-UNDO. 
DEF VAR iIdEventSite        AS INT NO-UNDO.
DEF VAR iIdSiteDescription  AS INT NO-UNDO.
DEF VAR iIdSiteCode         AS INT NO-UNDO.

/* Variaveis de Parametriza‡Æo */
DEF VAR iIdParameters       AS INT NO-UNDO.
DEF VAR iIdSelection        AS INT NO-UNDO.
DEF VAR iIdAccunt           AS INT NO-UNDO.


/* Vari veis para armazenar valores da inicializa‡Æo do loalMessageHandler */
DEF VAR hMessageHandler     AS HANDLE NO-UNDO.
DEF VAR cReturnValue        AS CHAR   NO-UNDO.

/*Vari veis locais*/
DEF VAR pSendSuccess  AS LOG INITIAL YES NO-UNDO.
DEF VAR lCREATEMsg    AS LOG             NO-UNDO.
DEF VAR pTotalErrors  AS INT             NO-UNDO.
DEF VAR pErrorNumber  AS INT             NO-UNDO.
DEF VAR pErrorType    AS CHAR            NO-UNDO.
DEF VAR pErrorDesc    AS CHAR            NO-UNDO.
DEF VAR iCount        AS INT             NO-UNDO.
DEF VAR l-logical     AS LOG             NO-UNDO.
DEF VAR I-Cont        AS DEC             NO-UNDO.

/**** variaveis de controle***/
&IF "{&mguni_version}" >= "2.071" &THEN
    DEFINE VARIABLE iEmp     LIKE empresa.ep-codigo NO-UNDO.
&ELSE
    DEFINE VARIABLE iEmp     AS INTEGER    NO-UNDO.
&ENDIF
DEFINE VARIABLE cEqpto   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dDate    AS DATE       NO-UNDO.
DEFINE VARIABLE cEstab   AS CHARACTER  NO-UNDO.
&IF "{&mguni_version}" >= "2.071" &THEN
    DEFINE VARIABLE cEmpresa LIKE empresa.ep-codigo NO-UNDO.
&ELSE
    DEFINE VARIABLE cEmpresa AS INTEGER    NO-UNDO.
&ENDIF
DEFINE VARIABLE cEqpato  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dData    AS DATE       NO-UNDO.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.92
         WIDTH              = 35.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
assign cEstab   = "":U.
ASSIGN I-Cont = 1.

/* Verifica se h  registros na temp-table */
IF NOT CAN-FIND(FIRST ttIntegr-eqpto-cust-event) THEN DO:
    {utp/ut-liter.i Equipamentos_da_frota_para_Integra‡Æo_EAI * r}
    run piCriaErro (5561,
                    'EMS':U, 
                    TRIM(return-value)).
     RETURN "NOK":U.
     LEAVE.
END.

&IF "{&mguni_version}" >= "2.071" &THEN
    ASSIGN cEmpresa = "".
&ELSE
    ASSIGN cEmpresa = 0.
&ENDIF
ASSIGN cEqpato  = "".
ASSIGN dData    = ?.

FOR EACH ttIntegr-eqpto-cust-event NO-LOCK:
      IF cEmpresa <> ttIntegr-eqpto-cust-event.ep-codigo OR
         cEqpato  <> ttIntegr-eqpto-cust-event.cod-eqpto OR
         dData    <> ttIntegr-eqpto-cust-event.dat-movto THEN DO:
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
                                              INPUT "Equipments",
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
         /* Indica valor da chave prim ria da transa‡Æo */
         RUN setKeyFields IN hMessageHandler ("mab-eqpto.ep-codigo":U,
                                              STRING(ttIntegr-eqpto-cust-event.ep-codigo)). 
         /* Indica valor da chave prim ria da transa‡Æo */
         RUN setKeyFields IN hMessageHandler ("mab-eqpto.cod-eqpto":U,
                                              string(ttIntegr-eqpto-cust-event.cod-eqpto)). 
         /* Indica valor da chave prim ria da transa‡Æo */
         RUN setKeyFields IN hMessageHandler ("mgf-cust-eqpto.dat-movto":U,
                                              string(ttIntegr-eqpto-cust-event.dat-movto)). 
    
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
             if pTranAction = "upd":U THEN DO:
               FIND FIRST tt-param.
                 /* Nà PRINCIPAL UPSERT */
                 RUN addNode IN hGenXml (0, "Upsert" , "", OUTPUT iFirstId).
                 /* Adiciona informa‡äes do Equipamento */
    
                 if iFirstId <> ? then do:
                    RUN addNodeDec  IN hGenXml (iFirstId, "CompanyCode",   ttIntegr-eqpto-cust-event.ep-codigo, OUTPUT iId).
                    RUN addNode     IN hGenXml (iFirstId, "EquipmentCode", ttIntegr-eqpto-cust-event.cod-eqpto, OUTPUT iId).
                    RUN addNodeDate IN hGenXml (iFirstId, "MovementDate",  ttIntegr-eqpto-cust-event.dat-movto, OUTPUT iId).
                    run addNode     IN hGenXml (iFirstId, "Selection", "", OUTPUT  iIdSelection).
                      run addNode   IN hGenXml (iIdSelection, "MonthInitial",     tt-param.c-mes-ini,       OUTPUT  iIdS).
                      run addNode   IN hGenXml (iIdSelection, "MonthEnd",         tt-param.c-mes-fim,       OUTPUT  iIdS).
                      run addNode   IN hGenXml (iIdSelection, "InitialCompany",   tt-param.i-ep-codigo-ini, OUTPUT  iIdS).
                      run addNode   IN hGenXml (iIdSelection, "EndCompany",       tt-param.i-ep-codigo-fim, OUTPUT  iIdS).
                      run addNode   IN hGenXml (iIdSelection, "InitialEquipment", tt-param.c-cod-eqpto-ini, OUTPUT  iIdS).
                      run addNode   IN hGenXml (iIdSelection, "EndEquipment",     tt-param.c-cod-eqpto-fim, OUTPUT  iIdS).
                      run addNode   IN hGenXml (iIdSelection, "InitialSite",      tt-param.c-cod-estab-ini, OUTPUT  iIdS).
                      run addNode   IN hGenXml (iIdSelection, "EndSite",          tt-param.c-cod-estab-fim, OUTPUT  iIdS).
    
                    run addNode     IN hGenXml (iFirstId, "Parameters", "", OUTPUT  iIdParameters).
                      run addNodeLog   IN hGenXml (iIdParameters, "IsFuel",         tt-param.l-combustiveis,    OUTPUT  iIdP).
                      run addNodeLog   IN hGenXml (iIdParameters, "IsLubrificant",  tt-param.l-lubrificantes,   OUTPUT  iIdP).
                      run addNodeLog   IN hGenXml (iIdParameters, "IsFilter",       tt-param.l-filtro,          OUTPUT  iIdP).
                      run addNodeLog   IN hGenXml (iIdParameters, "IsItem",         tt-param.l-itens,        OUTPUT  iIdP).
                      run addNodeLog   IN hGenXml (iIdParameters, "IsFormaBillofSaleMaterial", tt-param.l-nf-material,  OUTPUT  iIdP).
                      run addNodeLog   IN hGenXml (iIdParameters, "IsFormaBillofSaleService",  tt-param.l-nf-servico,   OUTPUT  iIdP).
                      run addNodeLog   IN hGenXml (iIdParameters, "IsManPower",     tt-param.l-MOB,             OUTPUT  iIdP).
                      run addNodeLog   IN hGenXml (iIdParameters, "IsOverHead",     tt-param.l-ggf,  OUTPUT  iIdP).
                      run addNodeLog   IN hGenXml (iIdParameters, "IsTire",         tt-param.l-pneu,            OUTPUT  iIdP).
                      run addNodeLog   IN hGenXml (iIdParameters, "IsDepreciation", tt-param.l-depreciacao,     OUTPUT  iIdP).
                      run addNodeLog   IN hGenXml (iIdParameters, "IsEvent",        tt-param.l-eventos,         OUTPUT  iIdP).
                                                                                             
                    run addNode     IN hGenXml (iFirstId, "ListOfSites", "", OUTPUT  iIdListSite). 
                    RUN addNodeDec  IN hGenXml (iFirstId, "Accountant", I-Cont, OUTPUT iIdAccunt).
    
                    ASSIGN cEstab = "".
    
                    for each bfIntegrCust1
                        where bfIntegrCust1.ep-codigo   = ttIntegr-eqpto-cust-event.ep-codigo
                        and   bfIntegrCust1.cod-eqpto   = ttIntegr-eqpto-cust-event.cod-eqpto
                        and   bfIntegrCust1.dat-movto   = ttIntegr-eqpto-cust-event.dat-movto NO-LOCK:
                        if cEstab <> bfIntegrCust1.cod-estabel then do:
    
                            /*** Adiciona as informa‡äes referentes ao Estabelecimento ****/
                            RUN addNode     IN hGenXml (iIdListSite, "Site", "", OUTPUT iIdSite).
                            RUN addNode     IN hGenXml (iIdSite, "SiteCode", bfIntegrCust1.cod-estabel , OUTPUT iIdSiteCode).
                            /***Informa‡äes do Estabelecimento**/
                            FOR FIRST estabelec FIELDS (cod-estabel nome ) 
                                WHERE estabelec.cod-estabel = bfIntegrCust1.cod-estabel  NO-LOCK: 
                            END. 
                            IF AVAIL estabelec then do:
                               RUN addNode IN hGenXml (iIdSite, "SiteDescription", SUBSTRING(estabelec.nome,1,40), OUTPUT iIdSiteDescription).
                            end.
                            run addNode IN hGenXml (iIdSite, "ListOfEvents", "",   OUTPUT  iIdListEvents).
                            for each bfIntegrCust2
                                where bfIntegrCust2.ep-codigo   = bfIntegrCust1.ep-codigo
                                and   bfIntegrCust2.cod-eqpto   = bfIntegrCust1.cod-eqpto
                                and   bfIntegrCust2.dat-movto   = bfIntegrCust1.dat-movto
                                and   bfIntegrCust2.cod-estabel = bfIntegrCust1.cod-estabel NO-LOCK:
                                /*** Adiciona as informa‡äes referentes aos Eventos ****/
                                RUN addNode     IN hGenXml (iIdListEvents, "Event", "", OUTPUT iIdEvent).
                                RUN addNode     IN hGenXml (iIdEvent, "EventCode", bfIntegrCust2.cod-evento , OUTPUT iIdEventSite).
                                RUN addNode     IN hGenXml (iIdEvent, "EventDescription", SUBSTRING(bfIntegrCust2.des-evento,1,40), OUTPUT iIdEventSite).
                                RUN addNodeDec  IN hGenXml (iIdEvent, "ConsumptionValue",    bfIntegrCust2.valor,      OUTPUT iIdEventSite).
                                RUN addNodeDec  IN hGenXml (iIdEvent, "ConsumptionQuantity", bfIntegrCust2.quantidade, OUTPUT iIdEventSite).
                            end. /*** for each buffer 2***/
                            
                            assign cEstab = bfIntegrCust1.cod-estabel. 
                        end.
                    end. /*** for each buffer 1 ***/
                    
                 end. /*** if iFirstId <> ? ***/
             END.
         END.
         /* Obt‚m XMl na variavel handle */
         RUN generateXML IN hGenXml (OUTPUT hBusinessContent).
         /* Passa handle do BusinessContent */
         RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).
         /* Elimina handle */
         DELETE OBJECT hBusinessContent NO-ERROR.
         /* Envia XML para ControlBroker */                                       
         RUN sendMessage IN hMessageHandler (INPUT "mn2/EquipmentsCost_204_000.xsd":U).
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
           LEAVE.
         end.
         ASSIGN I-Cont   = I-Cont + 1
                cEmpresa = ttIntegr-eqpto-cust-event.ep-codigo
                cEqpato  = ttIntegr-eqpto-cust-event.cod-eqpto
                dData    = ttIntegr-eqpto-cust-event.dat-movto.
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


