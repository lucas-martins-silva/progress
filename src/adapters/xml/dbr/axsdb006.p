
/* DEFINICAO DE PRE-PROCESSADORES */
&GLOBAL-DEFINE XmlApp            MA2
&GLOBAL-DEFINE XmlMod            SFC
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       ProductionAreaDBR
&GLOBAL-DEFINE XmlTranVersion    204.000

/* LOCAL VARIABLES */
DEFINE VAR cReturnValue     AS CHARACTER INITIAL ?     NO-UNDO.
DEFINE VAR hMessageHandler  AS HANDLE                  NO-UNDO.
DEFINE VAR lCreateMsg       AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VAR pSendSuccess     AS LOGICAL   INITIAL YES   NO-UNDO.
DEFINE VAR pTotalErrors     AS INTEGER   INITIAL ?     NO-UNDO.

DEFINE TEMP-TABLE ttProductionArea NO-UNDO
    FIELD ProductionAreaCode        AS CHARACTER INITIAL ?  /*Codigo da area de producao    (Uso interno: campo=mgmfg.area-produc.cod-area-produc)*/
    FIELD ProductionAreaDescription AS CHARACTER INITIAL ?  /*Descricao da Area de producao (Uso interno: campo=mgmfg.area-produc.des-area-produc)*/
    FIELD ttProductionAreaID        AS INTEGER   INITIAL ?
    INDEX ixttProductionAreaID IS PRIMARY UNIQUE ttProductionAreaID ASCENDING.

{adapters/xml/dbr/axsdb006ExtraDeclarations.i}

/* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
{xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

IF  cReturnValue <> "OK":U THEN DO:
    {utp/ut-liter.i Erro_ao_executar_MessageHandle:_ *}
    RUN utp/ut-msgs.p(INPUT "msg":U,
                      INPUT 17006,
                      RETURN-VALUE + cReturnValue + "~~":U +
                      RETURN-VALUE + cReturnValue).
    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = iSeqErro
           tt-erro.cd-erro  = 17006
           tt-erro.mensagem = RETURN-VALUE
           iSeqErro         = iSeqErro + 1.

    RETURN cReturnValue.
END.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hBusinessContent.

/* VARIABEL PARA ARMAZENAR OS VALORES OBTIDOS NA INICIALIZACAO DO loalGenXml */
DEF VAR hGenXml          AS HANDLE NO-UNDO.

/* VERIFICA SE APIXML ESTA NA MEMORIA */
{xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}

IF  cReturnValue <> "OK":U THEN DO:
    {utp/ut-liter.i Erro_ao_carregar_a_API_XML:_ *}
    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = iSeqErro
           tt-erro.cd-erro  = 17006
           tt-erro.mensagem = RETURN-VALUE + cReturnValue
           iSeqErro         = iSeqErro + 1.
    RETURN cReturnValue.
END.

DEFINE TEMP-TABLE ttStack NO-UNDO
    FIELD ttID AS INTEGER
    FIELD ttPos AS INTEGER
    INDEX tt_id IS PRIMARY UNIQUE
          ttID  ASCENDING.

FUNCTION addStack RETURN INTEGER (INPUT val AS INTEGER).
    DEFINE VAR id AS INTEGER INITIAL 1 NO-UNDO.

    FIND LAST ttStack NO-ERROR.
    IF  AVAIL(ttStack) THEN
        id = ttStack.ttID + 1.

    CREATE ttStack.
    ASSIGN ttStack.ttID = id
           ttStack.ttPos = val.

END FUNCTION.

FUNCTION delStack RETURN INTEGER.

     FIND LAST ttStack NO-ERROR.
     IF  AVAIL(ttStack) THEN
         DELETE ttStack.

     FIND LAST ttStack NO-ERROR.

END FUNCTION.

FUNCTION getStack RETURN INTEGER.

     IF  AVAIL(ttStack) THEN
         RETURN ttStack.ttPos.
     ELSE
         RETURN 0.

END FUNCTION.

/* INTERNAL PROCEDURES */
PROCEDURE PIUpsert:

    /* PARAMETERS*/
    DEFINE INPUT  PARAM cTranAction           AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM cProgName             AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM cProgVersion          AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR ttProductionArea.
    DEFINE INPUT  PARAM de-val-refer-atualiz  AS DECIMAL   INITIAL ? NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.
    
    /* LOCAL VARIABLES */
    DEFINE VAR iCount       AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR iId          AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR pErrorId     AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR pErrorType   AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE VAR pTotalErrors AS INTEGER   INITIAL ? NO-UNDO.
    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */

    /* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
    {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

    IF  cReturnValue <> "OK":U THEN DO:                          
        {utp/ut-liter.i Erro_ao_executar_MessageHandle:_ *}  
        CREATE tt-erro.                                      
        ASSIGN tt-erro.i-sequen = iSeqErro                   
               tt-erro.cd-erro  = 17006                      
               tt-erro.mensagem = RETURN-VALUE + cReturnValue
               iSeqErro         = iSeqErro + 1.              
        RETURN cReturnValue.                                 
    END.                                                     
    
    RUN isSubscribed IN hMessageHandler ("{&XmlProdName}", 
                                         "{&XmlApp}", 
                                         "{&XmlTranName}", 
                                         "{&XmlTranVersion}", 
                                         "", 
                                         cTranAction, 
                                         OUTPUT lCreateMsg).
    
    IF  RETURN-VALUE <> "OK":U THEN DO:
        ASSIGN cReturnValue = RETURN-VALUE.
        {utp/ut-liter.i Erro_ao_executar_isSubscribed_no_MessageHandle:_ *}
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = iSeqErro
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = RETURN-VALUE + cReturnValue
               iSeqErro         = iSeqErro + 1.
        RETURN cReturnValue.
    END.
    
    IF  NOT lCreateMsg THEN 
        RETURN "OK":U.
    
    /* PREENCHE O VALOR DO ELEM. Comment DE TransactionId */
    RUN setTransInfoComment IN hMessageHandler ("Programa: " + cProgName + " - " + "Vers∆o: " + cProgVersion).
    
    /* SETA SystemId */
    RUN setSystemId IN hMessageHandler ("{&XmlMod}", "{&XmlProdVersion}").
    
    FOR EACH ttProductionArea:
        RUN setKeyFields IN hMessageHandler ("tt-area-produc-dbr.cod-area-produc":U, ttProductionArea.ProductionAreaCode).
    END.
    
    /* INFORMA A EMPRESA E O ESTABELECIMENTO */
    RUN setCompanyId IN hMessageHandler (STRING(v_cdn_empres_usuar), "").
    
    /* RESETA OS VALORES */
    RUN reset IN hGenXml.
    
    /* SETA VALOR DE ENCODING */
    RUN setEncoding IN hGenXml ("UTF-8":U).
    
    RUN addNode IN hGenXml (getStack(), "Upsert":U, "":U, OUTPUT iId).
    addStack(iId).
    
         RUN addNode IN hGenXml (getStack(), "ListOfProductionArea":U, "":U, OUTPUT iId).
         addStack(iId).
    
              FOR EACH ttProductionArea:
                   RUN addNode IN hGenXml (getStack(), "ProductionArea":U, "":U, OUTPUT iId).
                   addStack(iId).
    
                        RUN addNode IN hGenXml (getStack(), "ProductionAreaCode":U, ttProductionArea.ProductionAreaCode, OUTPUT iId).
                        RUN addNode IN hGenXml (getStack(), "ProductionAreaDescription":U, ttProductionArea.ProductionAreaDescription, OUTPUT iId).
                   delStack().
              END.

         delStack().
         RUN addNodeDec IN hGenXml (getStack(), "ReferenceValue":U, de-val-refer-atualiz, OUTPUT iId).
    
    delStack().
    
    /* OBTEM O XML NUMA HANDLE */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).
    
    /* DEFINE O CONTEUDO DO ELEMENTO BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).
    
    /* LIBERA MEMORIA ALOCADA PARA O OBJETO */
    DELETE OBJECT hBusinessContent NO-ERROR.
    
    /* CONTR”I A MENSAGEM XML E ENVIA PARA O ControlBroker */
    RUN sendMessage IN hMessageHandler (INPUT "dbr/ProductionAreaDBR_204_000.xsd":U). 
    
    /* VERIFICA SE OCORREU ALGUM ERRO */
    IF  RETURN-VALUE <> "OK":U THEN DO:
        ASSIGN cReturnValue = RETURN-VALUE.
        {utp/ut-liter.i Erro_no_envio_da_Mensagem:_ *}
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = iSeqErro
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = RETURN-VALUE + cReturnValue
               iSeqErro         = iSeqErro + 1.
        RETURN cReturnValue.
    END.
    
    /* VERIFICA SE A MENSAGEM FOI PROCESSADA COM SUCESSO */
    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).
    
    /* SE NAO ENVIO COM SUCESSO */
    IF  NOT pSendSuccess THEN DO:
        REPEAT iCount = 1 TO pTotalErrors:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = iSeqErro
                   iSeqErro         = iSeqErro + 1.

            RUN getError IN hMessageHandler (INPUT  iCount,
                                             OUTPUT tt-erro.cd-erro,
                                             OUTPUT pErrorType,
                                             OUTPUT tt-erro.mensagem).
        END.
        RETURN "NOK":U.
    END.
    ELSE
        RETURN "OK":U.
    
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.

{adapters/xml/dbr/axsdb006Upsert.i}


