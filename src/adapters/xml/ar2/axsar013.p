/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSAR013 2.00.00.007 } /*** 010007 ***/


/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */
&GLOBAL-DEFINE XmlApp            AR2
&GLOBAL-DEFINE XmlMod            MCE
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    208
&GLOBAL-DEFINE XmlTranName       TransactionLockWarehouseItem
&GLOBAL-DEFINE XmlTranVersion    208.000

/* DEFINICAO DE PRE-PROCESSADORES - END */

/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR cReturnValue AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR hMessageHandler AS HANDLE NO-UNDO.
DEFINE VAR lCreateMsg AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VAR pSendSuccess AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VAR pTotalErrors AS INTEGER INITIAL ? NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro AS integer INITIAL ?
     FIELD ttv_des_msg_ajuda AS character INITIAL ?
     FIELD ttv_des_msg_erro AS character INITIAL ?
.


    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-erro_ao_executar_messagehandle AS CHARACTER FORMAT "X(32)" NO-UNDO.
    {utp/ut-liter.i "Erro ao executar MessageHandle: " *}
    ASSIGN c-erro_ao_executar_messagehandle = TRIM(RETURN-VALUE).

    DEFINE VARIABLE c-erro_ao_carregar_a_api_xml AS CHARACTER FORMAT "X(28)" NO-UNDO.
    {utp/ut-liter.i "Erro ao carregar a API XML: " *}
    ASSIGN c-erro_ao_carregar_a_api_xml = TRIM(RETURN-VALUE).

/*LOCAL VARIABLES - END*/

/*PARAMETERS - BEGIN*/
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/



{adapters/xml/ar2/axsar013ExtraDeclarations.i}



/* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
{xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}


IF cReturnValue <> "OK" THEN DO:
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 0.
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = c-erro_ao_executar_messagehandle + cReturnValue.
     RETURN cReturnValue.
END.


/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hBusinessContent.


/* VARIABEL PARA ARMAZENAR OS VALORES OBTIDOS NA INICIALIZACAO DO loalGenXml */
DEF VAR hGenXml AS HANDLE NO-UNDO.

/* VERIFICA SE APIXML ESTA NA MEMORIA */
{xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}



IF cReturnValue <> "OK"
THEN DO:
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 0.
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = c-erro_ao_carregar_a_api_xml + cReturnValue.
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
     IF AVAIL(ttStack) THEN
          id = ttStack.ttID + 1.

     CREATE ttStack.
     ASSIGN ttStack.ttID = id.
     ASSIGN ttStack.ttPos = val.
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




/****** INTERNAL PROCEDURES - BEGIN*/
PROCEDURE PIDelete:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAM cEvent AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT PARAM InitialDate_00 AS date INITIAL ? NO-UNDO.  /*Data inicial do bloqueio. (Uso interno: Campo = bloq-movto-item-depos.dat-inic-bloq)*/
DEFINE INPUT PARAM InitialTime_00 AS CHARACTER INITIAL ? FORMAT "99:99:99" NO-UNDO.  /*Hor†rio inicial do bloqueio (Uso interno: Campo = bloq-movto-item-depos.hra-inic-bloq)*/
DEFINE INPUT PARAM ItemCode_00 AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo do item. (Uso interno: Campo = bloq-movto-item-depos.it-codigo)*/
DEFINE INPUT PARAM ItemDescription_00 AS CHARACTER INITIAL ? NO-UNDO.  /*Descriá∆o do item. (Uso interno: Campo = mgind.item.desc-item)*/
DEFINE INPUT PARAM SiteDescription_00 AS CHARACTER INITIAL ? NO-UNDO.  /*Descriá∆o do estabelecimento. (Uso interno: Campo = mgadm.estabelec.nome)*/
DEFINE INPUT PARAM SiteID_00 AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo do estabelecimento. (Uso interno: Campo = bloq-movto-item-depos.cod-estabel)*/
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
DEFINE INPUT PARAM WarehouseDescription_00 AS CHARACTER INITIAL ? NO-UNDO.  /*Descriá∆o do dep¢sito. (Uso interno: Campo = mgind.deposito.nome)*/
DEFINE INPUT PARAM WarehouseID_00 AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo dep¢sito. (Uso interno: Campo = bloq-movto-item-depos.cod-depos)*/
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR iCount AS INTEGER INITIAL ? NO-UNDO.
DEFINE VAR iId AS INTEGER INITIAL ? NO-UNDO.
DEFINE VAR pErrorId AS INTEGER INITIAL ? NO-UNDO.
DEFINE VAR pErrorType AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR pTotalErrors AS INTEGER INITIAL ? NO-UNDO.

    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-erro_ao_executar_messagehandle_inter AS CHARACTER FORMAT "X(32)" NO-UNDO.
    {utp/ut-liter.i "Erro ao executar MessageHandle: " *}
    ASSIGN c-erro_ao_executar_messagehandle_inter = TRIM(RETURN-VALUE).

    DEFINE VARIABLE c-erro_ao_executar_issubscribed_no_messagehandle AS CHARACTER FORMAT "X(48)" NO-UNDO.
    {utp/ut-liter.i "Erro ao executar isSubscribed no MessageHandle: " *}
    ASSIGN c-erro_ao_executar_issubscribed_no_messagehandle = TRIM(RETURN-VALUE).

    DEFINE VARIABLE c-erro_no_envio_de_mensagem AS CHARACTER FORMAT "X(27)" NO-UNDO.
    {utp/ut-liter.i "Erro no envio da Mensagem: " *}
    ASSIGN c-erro_no_envio_de_mensagem = TRIM(RETURN-VALUE).



/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

/* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
{xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}


IF cReturnValue <> "OK" THEN DO:
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 0.
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = c-erro_ao_executar_messagehandle_inter + cReturnValue.
     RETURN cReturnValue.
END.

RUN isSubscribed IN hMessageHandler ("{&XmlProdName}", 
     "{&XmlApp}", 
     "{&XmlTranName}", 
     "{&XmlTranVersion}", 
     cEvent, 
     cTranAction, 
     OUTPUT lCreateMsg).




IF RETURN-VALUE <> "OK" THEN DO:
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 0.
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = c-erro_ao_executar_issubscribed_no_messagehandle + RETURN-VALUE.
     RETURN RETURN-VALUE.
END.



IF NOT lCreateMsg THEN DO:
     RETURN "OK".
END.



/* PREENCHE O VALOR DO ELEM. Comment DE TransactionId */
RUN setTransInfoComment IN hMessageHandler ("Delete bloq-movto-item-depos").



/* SETA SystemId */
RUN setSystemId IN hMessageHandler ("{&XmlMod}",  "{&XmlProdVersion}").



/*INDICA O VALOR DA CHAVE PRIMµRIA DA TRANSAÄ«O */
RUN setKeyFields IN hMessageHandler ("Empty", "-").



/* INFORMA A EMPRESA E O ESTABELECIMENTO */
/*RUN setCompanyId IN hMessageHandler ("cCodEmp", "cCodEstab").*/



     /* RESETA OS VALORES */
     RUN reset IN hGenXml.

     /* SETA VALOR DE ENCODING */
     RUN setEncoding IN hGenXml ("UTF-8").


     RUN addNode IN hGenXml (getStack(), "Delete", "", OUTPUT iId).
     addStack(iId).

          RUN addNode IN hGenXml (getStack(), "Site", "", OUTPUT iId).
          addStack(iId).

               RUN addNode IN hGenXml (getStack(), "SiteID", SiteID_00, OUTPUT iId).
               RUN addNode IN hGenXml (getStack(), "SiteDescription", SiteDescription_00, OUTPUT iId).
          delStack().

          RUN addNode IN hGenXml (getStack(), "Item", "", OUTPUT iId).
          addStack(iId).

               RUN addNode IN hGenXml (getStack(), "ItemCode", ItemCode_00, OUTPUT iId).
               RUN addNode IN hGenXml (getStack(), "ItemDescription", ItemDescription_00, OUTPUT iId).
          delStack().

          RUN addNode IN hGenXml (getStack(), "Warehouse", "", OUTPUT iId).
          addStack(iId).

               RUN addNode IN hGenXml (getStack(), "WarehouseID", WarehouseID_00, OUTPUT iId).
               RUN addNode IN hGenXml (getStack(), "WarehouseDescription", WarehouseDescription_00, OUTPUT iId).
          delStack().

          RUN addNodeDate IN hGenXml (getStack(), "InitialDate", InitialDate_00, OUTPUT iId).
          RUN addNode IN hGenXml (getStack(), "InitialTime", String(InitialTime_00, "99:99:99"), OUTPUT iId).

     delStack().


/* OBTEM O XML NUMA HANDLE */
RUN generateXML IN hGenXml (OUTPUT hBusinessContent).


/* DEFINE O CONTEÈDO DO ELEMENTO BusinessContent */
RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

/* LIBERA MEM‡RIA ALOCADA PARA O OBJETO */
DELETE OBJECT hBusinessContent NO-ERROR.



/*CONTR‡I A MENSAGEM XML E ENVIA PARA O ControlBroker */
RUN sendMessage IN hMessageHandler (INPUT "xmlschema/ar2/TransactionLockWarehouseItem_208_000.xsd"). 



/* VERIFICA SE OCORREU ALGUM ERRO */
IF RETURN-VALUE <> "OK" THEN DO:
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 0.
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = c-erro_no_envio_de_mensagem + RETURN-VALUE.
     RETURN RETURN-VALUE.
END.



/* VERIFICA SE A MENSAGEM FOI PROCESSADA COM SUCESSO */
RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).



/* SE NAO ENVIO COM SUCESSO */
IF NOT pSendSuccess THEN DO:
     REPEAT iCount = 1 TO pTotalErrors:
          CREATE TT_LOG_ERRO.
          RUN getError IN hMessageHandler (iCount, OUTPUT TT_LOG_ERRO.TTV_NUM_COD_ERRO, OUTPUT pErrorType, OUTPUT TT_LOG_ERRO.TTV_DES_MSG_ERRO).
     END.
     RETURN "NOK".
END.
ELSE RETURN "OK".

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.


PROCEDURE PIUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAM cEvent AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT PARAM InitialDate AS date INITIAL ? NO-UNDO.  /*Data inicial do bloqueio. (Uso interno: Campo = bloq-movto-item-depos.dat-inic-bloq)*/
DEFINE INPUT PARAM InitialTime AS CHARACTER INITIAL ? FORMAT "99:99:99" NO-UNDO.  /*Hor†rio inicial do bloqueio (Uso interno: Campo = bloq-movto-item-depos.hra-inic-bloq)*/
DEFINE INPUT PARAM ItemCode AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo do item. (Uso interno: Campo = bloq-movto-item-depos.it-codigo)*/
DEFINE INPUT PARAM ItemDescription AS CHARACTER INITIAL ? NO-UNDO.  /*Descriá∆o do item. (Uso interno: Campo = mgind.item.desc-item)*/
DEFINE INPUT PARAM SiteDescription AS CHARACTER INITIAL ? NO-UNDO.  /*Descriá∆o do estabelecimento. (Uso interno: Campo = mgadm.estabelec.nome)*/
DEFINE INPUT PARAM SiteID AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo do estabelecimento. (Uso interno: Campo = bloq-movto-item-depos.cod-estabel)*/
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
DEFINE INPUT PARAM WarehouseDescription AS CHARACTER INITIAL ? NO-UNDO.  /*Descriá∆o do dep¢sito. (Uso interno: Campo = mgind.deposito.nome)*/
DEFINE INPUT PARAM WarehouseID AS CHARACTER INITIAL ? NO-UNDO.  /*C¢digo dep¢sito. (Uso interno: Campo = bloq-movto-item-depos.cod-depos)*/
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR iCount AS INTEGER INITIAL ? NO-UNDO.
DEFINE VAR iId AS INTEGER INITIAL ? NO-UNDO.
DEFINE VAR pErrorId AS INTEGER INITIAL ? NO-UNDO.
DEFINE VAR pErrorType AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR pTotalErrors AS INTEGER INITIAL ? NO-UNDO.

/* Inicio -- Projeto Internacional */
DEFINE VARIABLE c-erro_ao_executar_messagehandle_internacionalizacao AS CHARACTER FORMAT "X(32)" NO-UNDO.
{utp/ut-liter.i "Erro ao executar MessageHandle: " *}
ASSIGN c-erro_ao_executar_messagehandle_internacionalizacao = TRIM(RETURN-VALUE).

/* Inicio -- Projeto Internacional */
DEFINE VARIABLE c-erro_ao_executar_issubscribed_no_messagehandle AS CHARACTER FORMAT "X(48)" NO-UNDO.
{utp/ut-liter.i "Erro ao executar isSubscribed no MessageHandle: " *}
ASSIGN c-erro_ao_executar_issubscribed_no_messagehandle = TRIM(RETURN-VALUE).

/* Inicio -- Projeto Internacional */
DEFINE VARIABLE c-erro_no_envio_da_mensagem AS CHARACTER FORMAT "X(27)" NO-UNDO.
{utp/ut-liter.i "Erro no envio da Mensagem: " *}
ASSIGN c-erro_no_envio_da_mensagem = TRIM(RETURN-VALUE).


/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

/* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
{xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}


IF cReturnValue <> "OK" THEN DO:
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 0.
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = c-erro_ao_executar_messagehandle_internacionalizacao + cReturnValue.
     RETURN cReturnValue.
END.

RUN isSubscribed IN hMessageHandler ("{&XmlProdName}", 
     "{&XmlApp}", 
     "{&XmlTranName}", 
     "{&XmlTranVersion}", 
     cEvent, 
     cTranAction, 
     OUTPUT lCreateMsg)
.


IF RETURN-VALUE <> "OK" THEN DO:
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 0.
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = c-erro_ao_executar_issubscribed_no_messagehandle + RETURN-VALUE.
     RETURN RETURN-VALUE.
END.



IF NOT lCreateMsg THEN DO:
     RETURN "OK".
END.


/* PREENCHE O VALOR DO ELEM. Comment DE TransactionId */
RUN setTransInfoComment IN hMessageHandler ("Create bloq-movto-item-depos").



/* SETA SystemId */
RUN setSystemId IN hMessageHandler ("{&XmlMod}",  "{&XmlProdVersion}").



/*INDICA O VALOR DA CHAVE PRIMµRIA DA TRANSAÄ«O */
RUN setKeyFields IN hMessageHandler ("Empty", "-").



/* INFORMA A EMPRESA E O ESTABELECIMENTO */
/*RUN setCompanyId IN hMessageHandler ("cCodEmp", "cCodEstab").*/



     /* RESETA OS VALORES */
     RUN reset IN hGenXml.

     /* SETA VALOR DE ENCODING */
     RUN setEncoding IN hGenXml ("UTF-8").


     RUN addNode IN hGenXml (getStack(), "Upsert", "", OUTPUT iId).
     addStack(iId).

          RUN addNode IN hGenXml (getStack(), "Site", "", OUTPUT iId).
          addStack(iId).

               RUN addNode IN hGenXml (getStack(), "SiteID", SiteID, OUTPUT iId).
               RUN addNode IN hGenXml (getStack(), "SiteDescription", SiteDescription, OUTPUT iId).
          delStack().

          RUN addNode IN hGenXml (getStack(), "Item", "", OUTPUT iId).
          addStack(iId).

               RUN addNode IN hGenXml (getStack(), "ItemCode", ItemCode, OUTPUT iId).
               RUN addNode IN hGenXml (getStack(), "ItemDescription", ItemDescription, OUTPUT iId).
          delStack().

          RUN addNode IN hGenXml (getStack(), "Warehouse", "", OUTPUT iId).
          addStack(iId).

               RUN addNode IN hGenXml (getStack(), "WarehouseID", WarehouseID, OUTPUT iId).
               RUN addNode IN hGenXml (getStack(), "WarehouseDescription", WarehouseDescription, OUTPUT iId).
          delStack().

          RUN addNodeDate IN hGenXml (getStack(), "InitialDate", InitialDate, OUTPUT iId).
          RUN addNode IN hGenXml (getStack(), "InitialTime", String(InitialTime, "99:99:99"), OUTPUT iId).

     delStack().


/* OBTEM O XML NUMA HANDLE */
RUN generateXML IN hGenXml (OUTPUT hBusinessContent).


/* DEFINE O CONTEÈDO DO ELEMENTO BusinessContent */
RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

/* LIBERA MEM‡RIA ALOCADA PARA O OBJETO */
DELETE OBJECT hBusinessContent NO-ERROR.



/*CONTR‡I A MENSAGEM XML E ENVIA PARA O ControlBroker */
RUN sendMessage IN hMessageHandler (INPUT "xmlschema/ar2/TransactionLockWarehouseItem_208_000.xsd"). 


/* VERIFICA SE OCORREU ALGUM ERRO */
IF RETURN-VALUE <> "OK" THEN DO:
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 0.
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = c-erro_no_envio_da_mensagem + RETURN-VALUE.
     RETURN RETURN-VALUE.
END.



/* VERIFICA SE A MENSAGEM FOI PROCESSADA COM SUCESSO */
RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).



/* SE NAO ENVIO COM SUCESSO */
IF NOT pSendSuccess THEN DO:
     REPEAT iCount = 1 TO pTotalErrors:
          CREATE TT_LOG_ERRO.
          RUN getError IN hMessageHandler (iCount, OUTPUT TT_LOG_ERRO.TTV_NUM_COD_ERRO, OUTPUT pErrorType, OUTPUT TT_LOG_ERRO.TTV_DES_MSG_ERRO).
     END.
     RETURN "NOK".
END.
ELSE RETURN "OK".

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.


/****** INTERNAL PROCEDURES - END*/




{adapters/xml/ar2/axsar013Upsert.i}


{adapters/xml/ar2/axsar013Delete.i}


