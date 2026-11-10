/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSMF006 2.00.00.003 } /*** 010003 ***/


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
    File        : AXSMF006.P
    Purpose     : ADAPTER DE ENVIO DE ABASTECIMENTOS E LUBRIFICA€åES

    Syntax      :

    Description : ADAPTER DE ENVIO DE ABASTECIMENTOS E LUBRIFICA€åES
    Author(s)   : Sandro K de Carvalho - its0121
    CREATEd     : FEV/2005 
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/
{cdp/cdcfgmnt.i}

/* **********************  Definitions  *********************** */
/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlTranName      Refueling
&GLOBAL-DEFINE XmlTranVersion   204.000
&GLOBAL-DEFINE XmlProdName      EMS2
&GLOBAL-DEFINE XmlProdVersion   204
&GLOBAL-DEFINE XmlApp           MN2 
&GLOBAL-DEFINE XmlMod           MFO 


/* Defini‡Æo temp-table RowErrors */
{cdp/cd9043.i}
{cdp/cd9043.i1}

/*Parƒmetros de entrada*/
DEF INPUT PARAM pTranAction  AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgName    AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgVersion AS CHAR    NO-UNDO.      

{frbo/bofr055.i tt-mab-abastec-lubrific-eai}
DEFINE TEMP-TABLE tt-mab-item-lubrific NO-UNDO LIKE mab-item-lubrific.

DEF INPUT PARAM TABLE FOR tt-mab-abastec-lubrific-eai.
DEF OUTPUT PARAM TABLE FOR RowErrors.


/* Vari veis Globais */
DEF VAR hGenXml          AS HANDLE NO-UNDO.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.

/* Variaveis da constru‡Æo do BusinessContent Utilizando APIXML */
DEF VAR iId         AS INT NO-UNDO.
DEF VAR iId2        AS INT NO-UNDO.
DEF VAR iId3        AS INT NO-UNDO.
DEF VAR iIdLubrific    AS INT NO-UNDO.
DEF VAR iIdLubrificSon AS INT NO-UNDO.
DEF VAR iFirstId    AS INT NO-UNDO. 
DEF VAR iListTerms  AS INT NO-UNDO.
DEF VAR iTerms      AS INT NO-UNDO. 
DEF VAR iFinTable   AS INT NO-UNDO. 
DEFINE VARIABLE iIdCompartment AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-gerou-itens AS LOGICAL  INITIAL NO  NO-UNDO.

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
IF NOT CAN-FIND(FIRST tt-mab-abastec-lubrific-eai) THEN DO:

    {utp/ut-liter.i Abastecimentos_e_Lubrifica‡äes_para_Integra‡Æo_EAI *}
    run piCriaErro (5561,
                    'EMS':U, 
                    TRIM(return-value)).
     RETURN "NOK":U.
     LEAVE.
END.

FOR EACH tt-mab-abastec-lubrific-eai:

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
                                         INPUT "Refueling",
                                         INPUT pTranAction,
                                         OUTPUT lCREATEMsg).

   /*Verifica se a transa‡Æo ‚ assinada*/
      IF NOT lCREATEMsg THEN
         RETURN "OK":U.

    /* Preenche o valor do elemento Comment de TransactionId */
    RUN setTransInfoComment IN hMessageHandler ("Program:" + pProgName + "-" +
                                                "Version:" + pProgVersion). 

    /*Seta SystemID*/
    RUN setSystemId IN hMessageHandler ("{&XmlMod}",  /*Nome do modulo */
                                        "{&XmlProdVersion}"). /* Versao do Programa*/

    /* Indica valor da chave prim ria da transa‡Æo */
    RUN setKeyFields IN hMessageHandler ("mab-abastec-lubrific.num-docto",
                                         STRING(tt-mab-abastec-lubrific-eai.num-docto)). 

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
        
        /* criando e populando tt para gerar os itens de lubrifica‡Æo*/
        /* verificando se o equipamento da ficha ‚ uma colhedora. */
        FIND FIRST mab-eqpto WHERE mab-eqpto.ep-codigo = tt-mab-abastec-lubrific-eai.ep-codigo
                             AND   mab-eqpto.cod-eqpto = tt-mab-abastec-lubrific-eai.cod-eqpto NO-LOCK NO-ERROR.
        IF AVAIL mab-eqpto THEN DO:
            FIND FIRST mab-model WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK NO-ERROR.
            IF AVAIL mab-model THEN
                IF mab-model.log-integr-agro THEN
                    FOR EACH mab-item-lubrific WHERE
                        mab-item-lubrific.num-docto = tt-mab-abastec-lubrific-eai.num-docto NO-LOCK:
                        /** Verifica se o evento ‚ uma troca de ¢leo ou remonta de ¢leo **/
                        IF CAN-FIND (FIRST mab-param WHERE (mab-param.cdn-param = 17  OR
                                                            mab-param.cdn-param = 18) AND
                                                            mab-param.des-valor = mab-item-lubrific.cod-event) THEN DO:
                             CREATE tt-mab-item-lubrific.  /*gravando dados na tt que vai gerar a mensagem xml*/
                             BUFFER-COPY mab-item-lubrific TO tt-mab-item-lubrific.
                             ASSIGN l-gerou-itens = YES.
                        END.
                    END. 
        END.
        /*verificando se h  itens de abastecimento para a ficha*/
        IF CAN-FIND (FIRST mab-item-abastec WHERE mab-item-abastec.num-docto = tt-mab-abastec-lubrific-eai.num-docto NO-LOCK) THEN
            ASSIGN l-gerou-itens = YES.
        /*caso nÆo hajam itens de abastecimento ou itens de lubrifica‡Æo v lidos para a ficha, a gera‡Æo da mensagem ‚ abortada*/
        IF l-gerou-itens = NO THEN DO:
            RETURN "NOK":U.
        END.

        IF pTranAction = "ADD" OR pTranAction = "UPD" THEN DO:

            /* Nà PRINCIPAL UPSERT */
            RUN addNode IN hGenXml (0, "Upsert", "", OUTPUT iFirstId).
              RUN addNodeDec IN hGenXml  (iFirstId, "DocumentNumber", tt-mab-abastec-lubrific-eai.num-docto, OUTPUT iId).
              RUN addNodeDec IN hGenXml  (iFirstId, "CompanyCode", tt-mab-abastec-lubrific-eai.ep-codigo, OUTPUT iId).
              RUN addNode IN hGenXml     (iFirstId, "EquipmentCode", tt-mab-abastec-lubrific-eai.cod-eqpto, OUTPUT iId).
              RUN addNodeDate IN hGenXml (iFirstId, "MovimentDate", tt-mab-abastec-lubrific-eai.dat-movto, OUTPUT iId).
              RUN addNode IN hGenXml     (iFirstId, "InitialHour", tt-mab-abastec-lubrific-eai.hra-inicial, OUTPUT iId).
              RUN addNode IN hGenXml     (iFirstId, "FinalHour", tt-mab-abastec-lubrific-eai.hra-final, OUTPUT iId).
              RUN addNodeDec IN hGenXml  (iFirstId, "InvertedHourDate", tt-mab-abastec-lubrific-eai.val-dat-hora-invrtda, OUTPUT iId).
              /** busca o codigo do estabelecimento no £ltimo registro pertinente da mab-histor-ativid **/
              FIND FIRST mab-histor-ativid WHERE mab-histor-ativid.ep-codigo = tt-mab-abastec-lubrific-eai.ep-codigo
                                             AND mab-histor-ativid.cod-eqpto = tt-mab-abastec-lubrific-eai.cod-eqpto
                                             AND mab-histor-ativid.dat-cadastro <= tt-mab-abastec-lubrific-eai.dat-movto NO-LOCK NO-ERROR.
              IF AVAIL mab-histor-ativid THEN DO:
              RUN addNode IN hGenXml     (iFirstId, "SiteCode", mab-histor-ativid.cod-estabel, OUTPUT iId).
              RUN addNodeDec IN hGenXml  (iFirstId, "DriverCompanyCode", tt-mab-abastec-lubrific-eai.ep-codigo-matr, OUTPUT iId).
              RUN addNode IN hGenXml     (iFirstId, "DriverSiteCode", tt-mab-abastec-lubrific-eai.cod-estabel-matr, OUTPUT iId).
              RUN addNode IN hGenXml     (iFirstId, "DriverCode", tt-mab-abastec-lubrific-eai.cod-matr, OUTPUT iId).
              RUN addNode IN hGenXml     (iFirstId, "StationRefuelingCode", tt-mab-abastec-lubrific-eai.cod-posto, OUTPUT iId).
              RUN addNode IN hGenXml     (iFirstId, "ActivityCode", tt-mab-abastec-lubrific-eai.cod-ativid, OUTPUT iId).
              RUN addNode IN hGenXml     (iFirstId, "RouteCode", tt-mab-abastec-lubrific-eai.cod-rota, OUTPUT iId).
              RUN addNodeDec IN hGenXml  (iFirstId, "VehicleAccountant", tt-mab-abastec-lubrific-eai.val-hodom-horim, OUTPUT iId).
              RUN addNodeDec IN hGenXml  (iFirstId, "CustomerVendorCode", tt-mab-abastec-lubrific-eai.cod-emitente, OUTPUT iId).
              RUN addNode IN hGenXml     (iFirstId, "FiscalInformations", "", OUTPUT iId).
                RUN addNode IN hGenXml     (iId, "AccountCode", tt-mab-abastec-lubrific-eai.ct-codigo, OUTPUT iId2).
                RUN addNode IN hGenXml     (iId, "CostCenterCode", tt-mab-abastec-lubrific-eai.cc-codigo, OUTPUT iId2).
                RUN addNode IN hGenXml     (iId, "FiscalDocument", tt-mab-abastec-lubrific-eai.nr-nota-fis, OUTPUT iId2).
                RUN addNode IN hGenXml     (iId, "SerieOfFiscalDocument", tt-mab-abastec-lubrific-eai.serie, OUTPUT iId2).
            &IF DEFINED(bf_mnt_ems206b) &THEN
                RUN addNode IN hGenXml     (iFirstId, "BusinessUnit", tt-mab-abastec-lubrific-eai.cod-unid-negoc, OUTPUT iId).
            &ELSE
                RUN addNode IN hGenXml     (iFirstId, "BusinessUnit", tt-mab-abastec-lubrific-eai.cod_unid_negoc, OUTPUT iId).
            &ENDIF
               END.
              IF tt-mab-abastec-lubrific-eai.log-consist <> ? THEN
                RUN addNodeLog IN hGenXml  (iFirstId, "IsConsistedDocument", tt-mab-abastec-lubrific-eai.log-consist, OUTPUT iId).
              RUN addNode IN hGenXml     (iFirstId, "OperationType", tt-mab-abastec-lubrific-eai.nat-operacao, OUTPUT iId).
              RUN addNode IN hGenXml     (iFirstId, "SourceDocument", "", OUTPUT iId).
                RUN addNode IN hGenXml     (iId, "DocumentSourceNumber", tt-mab-abastec-lubrific-eai.num-docto-orig, OUTPUT iId2).
                RUN addNode IN hGenXml     (iId, "SequenceDocumentSource", tt-mab-abastec-lubrific-eai.sequencia, OUTPUT iId2).

              /*** Verifica se h  itens de abastecimento para a ficha ****/  
              IF CAN-FIND (FIRST mab-item-abastec WHERE mab-item-abastec.num-docto = tt-mab-abastec-lubrific-eai.num-docto) THEN DO:
                  RUN addNode IN hGenXml     (iFirstId, "ListOfRefueling", "", OUTPUT iId).
                  /*** gerando ListOfRefueling - atributos da mab-item-abastec ***/
                    FOR EACH mab-item-abastec WHERE mab-item-abastec.num-docto = tt-mab-abastec-lubrific-eai.num-docto NO-LOCK:
                       RUN addNode IN hGenXml     (iId, "Refueling", "", OUTPUT iId2).
                           RUN addNode IN hGenXml     (iId2, "FuelBombCode", mab-item-abastec.cod-bomba, OUTPUT iId3).
                           RUN addNode IN hGenXml     (iId2, "ItemCode", mab-item-abastec.it-codigo, OUTPUT iId3).
                           RUN addNode IN hGenXml     (iId2, "ReferenceCode", mab-item-abastec.cod-refer, OUTPUT iId3).
                           RUN addNode IN hGenXml     (iId2, "LocalizationCode", mab-item-abastec.cod-localiz, OUTPUT iId3).
                           RUN addNode IN hGenXml     (iId2, "LotCode", mab-item-abastec.lote, OUTPUT iId3).
                           RUN addNodeDec IN hGenXml  (iId2, "FuelQuantity", mab-item-abastec.val-quant, OUTPUT iId3).
                           RUN addNodeDec IN hGenXml  (iId2, "MaterialValue", mab-item-abastec.val-mater-1, OUTPUT iId3).
                           IF mab-item-abastec.log-abastec-prim <> ? THEN
                              RUN addNodeLog IN hGenXml  (iId2, "IsPrimaryFuel", mab-item-abastec.log-abastec-prim, OUTPUT iId3).
                    END. /*for each mab-item-abastec*/
              END. /*if can-find*/

              /*caso hajam itens na tt gravada no processamento acima, criar a mensagem de lista de lubrifica‡Æo: */
              IF CAN-FIND (FIRST tt-mab-item-lubrific) THEN DO:
                  RUN addNode IN hGenXml     (iFirstId, "ListOfLubrification", "", OUTPUT iId).
                  FOR EACH tt-mab-item-lubrific NO-LOCK:
                      RUN addNode IN hGenXml     (iId, "Lubrification", "", OUTPUT iIdLubrific).
                          RUN addNode IN hGenXml     (iIdLubrific, "ItemCode", tt-mab-item-lubrific.it-codigo, OUTPUT iIdLubrificSon).
                          RUN addNode IN hGenXml     (iIdLubrific, "Compartment", "", OUTPUT iIdLubrificSon).
                            RUN addNode IN hGenXml     (iIdLubrificSon, "CompartmentCode", tt-mab-item-lubrific.cod-comptmento, OUTPUT iIdCompartment).
                            FIND FIRST mab-comptmento WHERE mab-comptmento.cod-comptmento = tt-mab-item-lubrific.cod-comptmento NO-LOCK NO-ERROR.
                            IF AVAIL mab-comptmento THEN
                                RUN addNode IN hGenXml     (iIdLubrificSon, "CompartmentDescription", mab-comptmento.des-comptmento, OUTPUT iIdCompartment).
                          RUN addNode IN hGenXml     (iIdLubrific, "LotCode", tt-mab-item-lubrific.lote, OUTPUT iIdLubrificSon).
                          RUN addNodeDec IN hGenXml  (iIdLubrific, "FuelQuantity", tt-mab-item-lubrific.val-quant, OUTPUT iIdLubrificSon).
                          RUN addNodeDec IN hGenXml  (iIdLubrific, "MaterialValue", tt-mab-item-lubrific.val-mater-1, OUTPUT iIdLubrificSon).
                          RUN addNode IN hGenXml     (iIdLubrific, "LocalizationCode", tt-mab-item-lubrific.cod-localiz, OUTPUT iIdLubrificSon).
                          RUN addNode IN hGenXml     (iIdLubrific, "ReferenceCode", tt-mab-item-lubrific.cod-refer, OUTPUT iIdLubrificSon).
                          RUN addNode IN hGenXml     (iIdLubrific, "EventCode", tt-mab-item-lubrific.cod-evento, OUTPUT iIdLubrificSon).
                          RUN addNodeDec IN hGenXml  (iIdLubrific, "MaintenanceTypeCode", tt-mab-item-lubrific.cd-tipo, OUTPUT iIdLubrificSon).
                          RUN addNode IN hGenXml     (iIdLubrific, "MaterialTypeCode", tt-mab-item-lubrific.cod-tip-mater, OUTPUT iIdLubrificSon).
                          IF tt-mab-item-lubrific.log-gera-amostra-oleo <> ? THEN
                             RUN addNodeLog IN hGenXml  (iIdLubrific, "IsGenerateOilPhysicalSample", tt-mab-item-lubrific.log-gera-amostra-oleo, OUTPUT iIdLubrificSon).
                          RUN addNode IN hGenXml     (iIdLubrific, "PhysicalSampleCode", tt-mab-item-lubrific.cod-amostra-fisic, OUTPUT iIdLubrificSon).
                  END.  /*for each tt-mab-item-lubrific*/
              END. /*if can-find first tt-mab-item-lubrific*/        
        END. /*a‡Æo ADD ou UPD*/

        ELSE IF pTranAction = "DEL":U THEN DO:
            /* no principal delete */
            RUN addNode IN hGenXml (0, "Delete", "", OUTPUT iFirstId).
                RUN addNodeDec IN hGenXml (iFirstId, "DocumentNumber", tt-mab-abastec-lubrific-eai.num-docto, OUTPUT iId).
                RUN addNodeDate IN hGenXml (iFirstId, "MovimentDate", tt-mab-abastec-lubrific-eai.dat-movto, OUTPUT iId).
                FIND FIRST mab-histor-ativid WHERE mab-histor-ativid.ep-codigo = tt-mab-abastec-lubrific-eai.ep-codigo
                                 AND mab-histor-ativid.cod-eqpto = tt-mab-abastec-lubrific-eai.cod-eqpto
                                 AND mab-histor-ativid.dat-cadastro <= tt-mab-abastec-lubrific-eai.dat-movto NO-LOCK NO-ERROR.
                IF AVAIL mab-histor-ativid THEN DO:
                   RUN addNode IN hGenXml     (iFirstId, "SiteCode", mab-histor-ativid.cod-estabel, OUTPUT iId).
                END.
        END. /*a‡Æo DEL*/

    END. /*transa‡Æo create-business-xml*/

    /* Obt‚m XMl na variavel handle */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).

    /* Passa handle do BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

    /* Elimina handle */
    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Envia XML para ControlBroker */                                       
    RUN sendMessage IN hMessageHandler (INPUT "mn2/Refueling_204_000.xsd").

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
