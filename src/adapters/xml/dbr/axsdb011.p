/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */
&GLOBAL-DEFINE XmlApp            MA2
&GLOBAL-DEFINE XmlMod            CDP
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       InventoryGroupDBR
&GLOBAL-DEFINE XmlTranVersion    204.000

/* LOCAL VARIABLES - BEGIN */
DEFINE VAR cReturnValue    AS CHARACTER INITIAL ?   NO-UNDO.
DEFINE VAR hMessageHandler AS HANDLE                NO-UNDO.
DEFINE VAR lCreateMsg      AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VAR pSendSuccess    AS LOGICAL INITIAL YES   NO-UNDO.
DEFINE VAR pTotalErrors    AS INTEGER INITIAL ?     NO-UNDO.
DEFINE VAR iSeqErro        AS INTEGER               NO-UNDO.

/*** Variaveis globais ***/
{utp/ut-glob.i}

/* Defini‡Æo de temp-tables */
/*** tt-erro ***/
{cdg/cdg0666.i}

DEFINE TEMP-TABLE ttInventoryGroup NO-UNDO
     FIELD InventoryGroupCode            AS INTEGER   /*Grupo de Estoque do Item */
     FIELD InventoryGroupDescription     AS CHARACTER /*Descrição do Grupo de Estoque*/
     FIELD ttInventoryGroupID            AS INTEGER   INITIAL ?     
     INDEX ixttInventoryGroupID IS PRIMARY UNIQUE
           ttInventoryGroupID ASCENDING.

DEFINE TEMP-TABLE tt-grp-estoq-dbr NO-UNDO
     FIELD cdn-grp-estoq     AS INTEGER   FORMAT ">9"     /*Grupo de Estoque do Item */
     FIELD des-grp-estoq     AS CHARACTER FORMAT "x(40)"  /*Descrição do Grupo de Estoque*/     
     INDEX codigo IS PRIMARY UNIQUE cdn-grp-estoq.

DEFINE TEMP-TABLE ttStack NO-UNDO
     FIELD ttID AS INTEGER
     FIELD ttPos AS INTEGER
     INDEX tt_id IS PRIMARY UNIQUE
           ttID  ASCENDING.

/* Defini‡Æo de functions */
FUNCTION addStack RETURN INTEGER (INPUT val AS INTEGER).
     DEFINE VAR id AS INTEGER INITIAL 1 NO-UNDO.
     FIND LAST ttStack NO-ERROR.
     IF AVAIL(ttStack) THEN
          id = ttStack.ttID + 1.

     CREATE ttStack.
    ASSIGN ttStack.ttID  = id
           ttStack.ttPos = val.
END FUNCTION.

FUNCTION delStack RETURN INTEGER.
     FIND LAST ttStack NO-ERROR.
     IF AVAIL(ttStack) THEN
          DELETE ttStack.

     FIND LAST ttStack NO-ERROR.
END FUNCTION.

FUNCTION getStack RETURN INTEGER.
     IF AVAIL(ttStack) THEN
          RETURN ttStack.ttPos.
     ELSE
          RETURN 0.
END FUNCTION.

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
           
    RETURN "NOK".
END.

/* Handle do BusinessContent */
DEFINE VAR hBusinessContent AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hBusinessContent.

/* VARIAVEL PARA ARMAZENAR OS VALORES OBTIDOS NA INICIALIZACAO DO loalGenXml */
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
    RETURN "NOK".
END.

/* PROCEDURES INTERNAS */
PROCEDURE PIUpsert:

    /* PARAMETERS*/
    DEFINE INPUT  PARAM cTranAction           AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM cProgName             AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM cProgVersion          AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR ttInventoryGroup.
    DEFINE INPUT  PARAM de-val-refer-atualiz  AS DECIMAL   INITIAL ? NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.

    DEFINE VAR iCount               AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR iId                  AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR pErrorId             AS INTEGER   INITIAL ? NO-UNDO.
    DEFINE VAR pErrorType           AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE VAR pTotalErrors         AS INTEGER   INITIAL ? NO-UNDO.    

    /* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
    {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

    IF  cReturnValue <> "OK":U THEN DO:                      
        {utp/ut-liter.i Erro_ao_executar_MessageHandle:_ *}  
        CREATE tt-erro.                                      
        ASSIGN tt-erro.i-sequen = iSeqErro                   
               tt-erro.cd-erro  = 17006                      
               tt-erro.mensagem = RETURN-VALUE + cReturnValue
               iSeqErro         = iSeqErro + 1.              
        RETURN "NOK".                                 
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
        RETURN "NOK".
    END.

    IF  NOT lCreateMsg THEN DO:        
        RETURN "OK":U.
    END.
    
    /* PREENCHE O VALOR DO ELEM. Comment DE TransactionId */
    RUN setTransInfoComment IN hMessageHandler ("Programa: " + cProgName + " - " + "VersÆo: " + cProgVersion).

    /* SETA SystemId */
    RUN setSystemId IN hMessageHandler ("{&XmlMod}",  "{&XmlProdVersion}").

    FOR EACH ttInventoryGroup:
        RUN setKeyFields IN hMessageHandler ("tt-grp-estoq-dbr.cdn-grp-estoq", STRING(ttInventoryGroup.InventoryGroupCode)).
    END.

    /* INFORMA A EMPRESA E O ESTABELECIMENTO */
    RUN setCompanyId IN hMessageHandler ( String(v_cdn_empres_usuar) , " " ).  

     /* RESETA OS VALORES */
     RUN reset IN hGenXml.

     /* SETA VALOR DE ENCODING */
     RUN setEncoding IN hGenXml ("UTF-8").

     RUN addNode IN hGenXml (getStack(), "Upsert":U, "", OUTPUT iId).
     addStack(iId).

          RUN addNode IN hGenXml (getStack(), "ListOfInventoryGroup":U, "", OUTPUT iId).
          addStack(iId).

               FOR EACH ttInventoryGroup:

                    RUN addNode IN hGenXml (getStack(), "InventoryGroup":U, "", OUTPUT iId).
                    addStack(iId).

                        RUN addNode IN hGenXml (getStack(), "InventoryGroupCode":U, ttInventoryGroup.InventoryGroupCode, OUTPUT iId).
                        IF ttInventoryGroup.InventoryGroupDescription <> ? THEN                          
                           RUN addNode IN hGenXml (getStack(), "InventoryGroupDescription":U, ttInventoryGroup.InventoryGroupDescription, OUTPUT iId).

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
    RUN sendMessage IN hMessageHandler (INPUT "dbr/InventoryGroupDBR_204_000.xsd":U). 

    /* VERIFICA SE OCORREU ALGUM ERRO */
    IF  RETURN-VALUE <> "OK":U THEN DO:
        ASSIGN cReturnValue = RETURN-VALUE.
        {utp/ut-liter.i Erro_no_envio_da_Mensagem:_ *}
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = iSeqErro
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = RETURN-VALUE + cReturnValue
               iSeqErro         = iSeqErro + 1.
        RETURN "NOK".
    END.

    /* VERIFICA SE A MENSAGEM FOI PROCESSADA COM SUCESSO */
    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).

    /* SE NAO ENVIO COM SUCESSO */
    IF NOT pSendSuccess THEN DO:
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

END PROCEDURE.

{adapters/xml/dbr/axsdb011Upsert.i}

/* EOF */
