/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSMA002 2.00.00.007}  /*** 010007 ***/



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
    File        : AXSDI001.p
    Purpose     : ADAPTER DE ENVIO DE UNIDADE DE MEDIDA

    Syntax      :

    Description : ADAPTER DE ENVIO DE UNIDADE DE MEDIDA
    Author(s)   : Vanessa H - ksm15154
    CREATEd     : 11/12/2003 10:00
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */

/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlTranName      UnitOfMeasure
&GLOBAL-DEFINE XmlTranVersion   204.000
&GLOBAL-DEFINE XmlProdName      EMS2
&GLOBAL-DEFINE XmlProdVersion   204
&GLOBAL-DEFINE XmlApp           MA2 
&GLOBAL-DEFINE XmlMod           CDP

DEFINE TEMP-TABLE tt-un-medida NO-UNDO LIKE tab-unidade.

/* Defini‡Æo temp-table RowErrors */
{cdp/cd9043.i}
{cdp/cd9043.i1}

/*Parƒmetros de entrada*/
DEF INPUT PARAM pTranAction  AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgName    AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgVersion AS CHAR    NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-un-medida.
DEF OUTPUT PARAM TABLE FOR RowErrors.

/* Vari veis Globais */
DEF VAR hGenXml          AS HANDLE NO-UNDO.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.

/* Variaveis da constru‡Æo do BusinessContent Utilizando APIXML */
DEF VAR iId         AS INT NO-UNDO.
DEF VAR iFirstId    AS INT NO-UNDO. 
DEF VAR iListTerms  AS INT NO-UNDO.
DEF VAR iTerms      AS INT NO-UNDO. 
DEF VAR iFinTable   AS INT NO-UNDO. 

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
IF NOT CAN-FIND(FIRST tt-un-medida) THEN DO:

    {utp/ut-liter.i Unidade_de_Medida_para_Integracao_EAI * r}
    run piCriaErro (5561,
                    'EMS':U, 
                    TRIM(return-value)).
     RETURN "NOK":U.
     LEAVE.
END.

FOR EACH tt-un-medida:

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
                                         INPUT "UnitsOfMeasure",
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
    RUN setKeyFields IN hMessageHandler ("tab-unidade.un",
                                         STRING(tt-un-medida.un)). 

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
            RUN addNode IN hGenXml (0, "Upsert", "", OUTPUT iFirstId).
            RUN addNode IN hGenXml (iFirstId, "UnitOfMeasureCode", tt-un-medida.un, OUTPUT iId).
            RUN addNode IN hGenXml (iFirstId, "UnitOfMeasureDescription", tt-un-medida.descricao, OUTPUT iId).

            /* Valores definidos conforme include ininc~\i01in417.i Default 1 */
            &IF DEFINED (bf_man_205) &THEN
                IF tt-un-medida.dimensao >= 1 AND tt-un-medida.dimensao <= 5 THEN
                RUN addNodeDec IN hGenXml (iFirstId, "Dimension", tt-un-medida.dimensao, OUTPUT iId).
                ELSE 
                RUN addNodeDec IN hGenXml (iFirstId, "Dimension", 1, OUTPUT iId).
            &ENDIF


        END.
        ELSE IF pTranAction = "DEL" THEN DO:

            /* no principal delete */
            RUN addNode IN hGenXml (0, "Delete", "", OUTPUT iFirstId).
            RUN addNode IN hGenXml (iFirstId, "UnitOfMeasureCode", tt-un-medida.un, OUTPUT iId).
            RUN addNode IN hGenXml (iFirstId, "UnitOfMeasureDescription", tt-un-medida.descricao, OUTPUT iId).          

       END.

    END.

    /* Obt‚m XMl na variavel handle */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).
    /*hBusinessContent:SAVE("FILE", "C:~\UnitOfMeasure.xml").*/

    /* Passa handle do BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

    /* Elimina handle */
    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Envia XML para ControlBroker */                                       
    RUN sendMessage IN hMessageHandler (INPUT "ma2/UnitsOfMeasure_204_001.xsd").
    
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
