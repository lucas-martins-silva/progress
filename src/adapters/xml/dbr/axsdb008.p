
/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */
&GLOBAL-DEFINE XmlApp            MA2
&GLOBAL-DEFINE XmlMod            SFC
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       ShiftOfMachineGroupDBR
&GLOBAL-DEFINE XmlTranVersion    204.000

/* LOCAL VARIABLES */
DEFINE VAR cReturnValue     AS CHARACTER INITIAL ?     NO-UNDO.
DEFINE VAR hMessageHandler  AS HANDLE                  NO-UNDO.
DEFINE VAR lCreateMsg       AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VAR pSendSuccess     AS LOGICAL   INITIAL YES   NO-UNDO.
DEFINE VAR pTotalErrors     AS INTEGER   INITIAL ?     NO-UNDO.

DEFINE TEMP-TABLE ttShiftOfMachineGroup NO-UNDO
     FIELD EndDate                 AS DATE      INITIAL ?  /*Data de termino (Uso interno: campo= mgind. gm-turno-crp.dt-termino)*/
     FIELD MachineGroupCode        AS CHARACTER INITIAL ?  /*Codigo do Grupo de Maquina (Uso interno: campo=mgind.gm-turno-crp.gm-codigo)*/
     FIELD ShiftModelCode          AS CHARACTER INITIAL ?  /*Codigo do modelo de turno. (Uso interno: campo=mgind. gm-turno-crp.cod-model-turno)*/
     FIELD StartDate               AS DATE      INITIAL ?  /*Data de inicio (Uso interno: campo= mgind. gm-turno-crp.dt-inicio)*/
     FIELD ttShiftOfMachineGroupID AS INTEGER   INITIAL ?
     INDEX ixttShiftOfMachineGroupID IS PRIMARY UNIQUE 
           ttShiftOfMachineGroupID ASCENDING.

{adapters/xml/dbr/axsdb008ExtraDeclarations.i}

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
DEFINE VAR hBusinessContent AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hBusinessContent.

/* VARIABEL PARA ARMAZENAR OS VALORES OBTIDOS NA INICIALIZACAO DO loalGenXml */
DEFINE VAR hGenXml          AS HANDLE NO-UNDO.

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
    ASSIGN ttStack.ttID  = id
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
    DEFINE INPUT  PARAM TABLE FOR ttShiftOfMachineGroup.
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
                                         "":U, 
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
    RUN setTransInfoComment IN hMessageHandler ("Programa: " + cProgName + " - " + "VersÆo: " + cProgVersion).
    
    /* SETA SystemId */
    RUN setSystemId IN hMessageHandler ("{&XmlMod}",  "{&XmlProdVersion}").

    FOR EACH ttShiftOfMachineGroup:
        RUN setKeyFields IN hMessageHandler ("tt-turno-grp-dbr.gm-codigo":U, ttShiftOfMachineGroup.MachineGroupCode).
        RUN setKeyFields IN hMessageHandler ("tt-turno-grp-dbr.dt-inicio":U, string(ttShiftOfMachineGroup.StartDate)).
    END.

    /* INFORMA A EMPRESA E O ESTABELECIMENTO */
    RUN setCompanyId IN hMessageHandler (STRING(v_cdn_empres_usuar), "":U).

    /* RESETA OS VALORES */
    RUN reset IN hGenXml.

    /* SETA VALOR DE ENCODING */
    RUN setEncoding IN hGenXml ("UTF-8":U).

    RUN addNode IN hGenXml (getStack(), "Upsert":U, "":U, OUTPUT iId).
    addStack(iId).

        RUN addNode IN hGenXml (getStack(), "ListOfShiftOfMachineGroup":U, "":U, OUTPUT iId).
        addStack(iId).

            FOR EACH ttShiftOfMachineGroup:

                RUN addNode IN hGenXml (getStack(), "ShiftOfMachineGroup":U, "":U, OUTPUT iId).
                addStack(iId).

                    RUN addNode IN hGenXml (getStack(), "MachineGroupCode":U, ttShiftOfMachineGroup.MachineGroupCode, OUTPUT iId).
                    IF ttShiftOfMachineGroup.StartDate <> ? THEN
                    RUN addNodeDate IN hGenXml (getStack(), "StartDate":U, ttShiftOfMachineGroup.StartDate, OUTPUT iId).
                    IF ttShiftOfMachineGroup.EndDate <> ? THEN
                    RUN addNodeDate IN hGenXml (getStack(), "EndDate":U, ttShiftOfMachineGroup.EndDate, OUTPUT iId).

                    RUN addNode IN hGenXml (getStack(), "ShiftModelCode":U, ttShiftOfMachineGroup.ShiftModelCode, OUTPUT iId).

                delStack().
            END.

        delStack().

        RUN addNodeDec IN hGenXml (getStack(), "ReferenceValue":U, de-val-refer-atualiz, OUTPUT iId).

    delStack().


    /* OBTEM O XML NUMA HANDLE */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).

    /* DEFINE O CONTEÚDO DO ELEMENTO BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

    /* LIBERA MEMÓRIA ALOCADA PARA O OBJETO */
    DELETE OBJECT hBusinessContent NO-ERROR.

    /*CONTRÓI A MENSAGEM XML E ENVIA PARA O ControlBroker */
    RUN sendMessage IN hMessageHandler (INPUT "dbr/ShiftOfMachineGroupDBR_204_000.xsd":U). 

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

{adapters/xml/dbr/axsdb008Upsert.i}


