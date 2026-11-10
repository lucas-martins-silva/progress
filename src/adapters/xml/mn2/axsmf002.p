/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSMF002 2.00.00.001}  /*** 010001 ***/




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
    File        : AXSMF003.P
    Purpose     : ADAPTER DE ENVIO DE ESTRUTURA MECANICA

    Syntax      :

    Description : ADAPTER DE ENVIO DE ESTRUTURA MECANICA
    Author(s)   : Leonardo B. Lazarini - ksm701
    CREATEd     : FEV/2005 
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */
/* Pr²-Processadores*/
&GLOBAL-DEFINE XmlTranName      MechanicsStructure
&GLOBAL-DEFINE XmlTranVersion   204.000
&GLOBAL-DEFINE XmlProdName      EMS2
&GLOBAL-DEFINE XmlProdVersion   204
&GLOBAL-DEFINE XmlApp           MN2 
&GLOBAL-DEFINE XmlMod           MFO

{frbo/bofr009.i tt-mab-estrut-mec-eai}

/* Defini»’o temp-table RowErrors */
{cdp/cd9043.i}
{cdp/cd9043.i1}

/*Par³metros de entrada*/
DEF INPUT PARAM pTranAction  AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgName    AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgVersion AS CHAR    NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-mab-estrut-mec-eai.
DEF OUTPUT PARAM TABLE FOR RowErrors.

/* Variÿveis Globais */
DEF VAR hGenXml          AS HANDLE NO-UNDO.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.

/* Variaveis da constru»’o do BusinessContent Utilizando APIXML */
DEF VAR iId         AS INT NO-UNDO.
DEF VAR iId2        AS INT NO-UNDO.
DEF VAR iFirstId    AS INT NO-UNDO. 
DEF VAR iListTerms  AS INT NO-UNDO.
DEF VAR iTerms      AS INT NO-UNDO. 
DEF VAR iFinTable   AS INT NO-UNDO. 

/* Variÿveis para armazenar valores da inicializa»’o do loalMessageHandler */
DEF VAR hMessageHandler AS HANDLE NO-UNDO.
DEF VAR cReturnValue    AS CHAR   NO-UNDO.

/*Variÿveis locais*/
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


/* Verifica se hÿ registros na temp-table */
IF NOT CAN-FIND(FIRST tt-mab-estrut-mec-eai) THEN DO:

    {utp/ut-liter.i Estrutura_Mecanica_Integra‡Æo_EAI *}
    run piCriaErro (5561,
                    'EMS':U, 
                    TRIM(return-value)).
     RETURN "NOK":U.
     LEAVE.
END.

FOR EACH tt-mab-estrut-mec-eai:

    /* Verifica se MessageHandler.p est ÿ na mem½ria */
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

    /* Verifica se hÿ programas inscritos */
    RUN isSubscribed IN hMessageHandler (INPUT "{&XmlProdName}",
                                         INPUT "{&XmlApp}",
                                         INPUT "{&XmlTranName}",
                                         INPUT "{&XmlTranVersion}",
                                         INPUT "MechanicsStructure",
                                         INPUT pTranAction,
                                         OUTPUT lCREATEMsg).
    
   /*Verifica se a transa»’o ² assinada                   */

    IF NOT lCREATEMsg THEN                              
        RETURN "OK":U.    

    /* Preenche o valor do elemento Comment de TransactionId */
    RUN setTransInfoComment IN hMessageHandler ("Program:" + pProgName + "-" +
                                                "Version:" + pProgVersion). 

    /*Seta SystemID*/
    RUN setSystemId IN hMessageHandler ("{&XmlMod}",  /*Nome do modulo */
                                        "{&XmlProdVersion}"). /* Versao do Programa*/

    /* Indica valor da chave primÿria da transa»’o */
    RUN setKeyFields IN hMessageHandler ("mab-estrut-mec.cod-estrut-mec",
                                         STRING(tt-mab-estrut-mec-eai.cod-estrut-mec)). 

    /* Seta a empresa e o estabelecimento */
    RUN setCompanyId IN hMessageHandler (STRING(v_cdn_empres_usuar), ""). 

    /* Verifica se API estÿ na mem½ria */
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

    /* Cria mensagem do BusinessContent atrav²s da API*/
    CREATE-BUSINESS-XML:
    DO:
        /* RESETA OS VALORES */
        RUN reset IN hGenXml.

        /* SETA VALOR DE ENCODING */
        RUN setEncoding IN hGenXml ("UTF-8").

        IF pTranAction = "ADD" OR pTranAction = "UPD" THEN DO:

            /* N… PRINCIPAL UPSERT */
            RUN addNode IN hGenXml (0, 
                                    "Upsert", 
                                    "", 
                                    OUTPUT iFirstId).
            
            RUN addNode IN hGenXml (iFirstId, 
                                    "MechanicsStructureCode", 
                                    tt-mab-estrut-mec-eai.cod-estrut-mec, 
                                    OUTPUT iId).
            
            RUN addNode IN hGenXml (iFirstId, 
                                    "MechanicsStructureDescription", 
                                    tt-mab-estrut-mec-eai.des-estrut-mec, 
                                    OUTPUT iId).

        END.
        ELSE IF pTranAction = "DEL" THEN DO:
            /* no principal delete */
            RUN addNode IN hGenXml (0, 
                                    "Delete", 
                                    "", 
                                    OUTPUT iFirstId).
                
            RUN addNode IN hGenXml (iFirstId, 
                                    "MechanicsStructureCode", 
                                    tt-mab-estrut-mec-eai.cod-estrut-mec, 
                                    OUTPUT iId).
                
            RUN addNode IN hGenXml (iFirstId, 
                                    "MechanicsStructureDescription", 
                                    tt-mab-estrut-mec-eai.des-estrut-mec, 
                                    OUTPUT iId).          

       END.

    END.

    /* Obt²m XMl na variavel handle */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).
    /*hBusinessContent:SAVE("FILE", "C:~\EquipmentGroups.xml").*/

    /* Passa handle do BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

    /* Elimina handle */
    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Envia XML para ControlBroker */                                       
    RUN sendMessage IN hMessageHandler (INPUT "mn2/MechanicsStructure_204_000.xsd").

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
