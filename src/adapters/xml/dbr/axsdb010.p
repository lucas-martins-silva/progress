/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSDB010 2.00.01.000}  /*** 010100 ***/


/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */
&GLOBAL-DEFINE XmlApp            MA2
&GLOBAL-DEFINE XmlMod            CDP
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       MaterialFamilyDBR
&GLOBAL-DEFINE XmlTranVersion    204.200

/* DEFINICAO DE PRE-PROCESSADORES - END */

/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR cReturnValue AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR hMessageHandler AS HANDLE NO-UNDO.
DEFINE VAR lCreateMsg AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VAR pSendSuccess AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VAR pTotalErrors AS INTEGER INITIAL ? NO-UNDO.

DEFINE TEMP-TABLE ttMaterialFamily NO-UNDO
     FIELD MaterialFamilyCode AS CHARACTER INITIAL ?  /*Codigo da Familia de Materiais (Uso interno: campo=familia.fm-codigo)*/
     FIELD MaterialFamilyDescription AS CHARACTER INITIAL ?  /*Descricao da Familia de Materiais. (Uso interno:campo =familia.descricao)*/
     FIELD ttMaterialFamilyID AS INTEGER INITIAL ?
     FIELD Policy AS INTEGER
     INDEX ixttMaterialFamilyID IS PRIMARY UNIQUE ttMaterialFamilyID ASCENDING
.

{adapters/xml/dbr/axsdb010ExtraDeclarations.i}


/* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
{xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

IF cReturnValue <> "OK":U THEN DO:
   {utp/ut-liter.i Erro_ao_executar_MessageHandler * r}
   CREATE tt-erro.
   ASSIGN iContErro        = iContErro + 1
          tt-erro.cd-erro  = 17006
          tt-erro.mensagem = trim(RETURN-VALUE) + ": ":U + cReturnValue
          tt-erro.i-sequen = iContErro. 
   RETURN "NOK":U.
END.


/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hBusinessContent.


/* VARIABEL PARA ARMAZENAR OS VALORES OBTIDOS NA INICIALIZACAO DO loalGenXml */
DEF VAR hGenXml AS HANDLE NO-UNDO.

/* VERIFICA SE APIXML ESTA NA MEMORIA */
{xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}

IF cReturnValue <> "OK":U THEN DO:

   {utp/ut-liter.i Erro_ao_carregar_a_API_XML * r}
   CREATE tt-erro.
   ASSIGN iContErro        = iContErro + 1
          tt-erro.cd-erro  = 17006
          tt-erro.mensagem = trim(RETURN-VALUE) + ": ":U + cReturnValue
          tt-erro.i-sequen = iContErro. 
   RETURN "NOK":U.
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
PROCEDURE PIUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT PARAM cProgName    AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT PARAM cProgVersion AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT PARAM TABLE FOR ttMaterialFamily.
DEFINE INPUT PARAM de-val-refer-atualiz AS DEC         NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt-erro.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR iCount AS INTEGER INITIAL ? NO-UNDO.
DEFINE VAR iId AS INTEGER INITIAL ? NO-UNDO.
DEFINE VAR pErrorId AS INTEGER INITIAL ? NO-UNDO.
DEFINE VAR pErrorType AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR pTotalErrors AS INTEGER INITIAL ? NO-UNDO.
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

/* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
{xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

IF cReturnValue <> "OK":U THEN DO:
    {utp/ut-liter.i Erro_ao_executar_MessageHandler * r}
    CREATE tt-erro.
    ASSIGN iContErro        = iContErro + 1
           tt-erro.cd-erro  = 17006
           tt-erro.mensagem = trim(RETURN-VALUE) + ": ":U + cReturnValue
           tt-erro.i-sequen = iContErro. 
    RETURN "NOK":U.
END.

RUN isSubscribed IN hMessageHandler ("{&XmlProdName}", 
     "{&XmlApp}":U, 
     "{&XmlTranName}":U, 
     "{&XmlTranVersion}":U, 
     " ":U, 
     cTranAction, 
     OUTPUT lCreateMsg).

IF RETURN-VALUE <> "OK":U THEN DO:
    ASSIGN cReturnValue = RETURN-VALUE.
    {utp/ut-liter.i Erro_ao_executar_m‚todo* r}
    CREATE tt-erro.
    ASSIGN iContErro        = iContErro + 1
           tt-erro.cd-erro  = 17006
           tt-erro.mensagem = trim(RETURN-VALUE) + "isSubscribed: ":U + cReturnValue
           tt-erro.i-sequen = iContErro. 
    RETURN "NOK":U.
END.

IF NOT lCreateMsg THEN RETURN "OK":U.
     
/* PREENCHE O VALOR DO ELEM. Comment DE TransactionId */

RUN setTransInfoComment IN hMessageHandler ("Programa: " +  cProgName + " - "  +  "VersÆo: "     +  cProgVersion ). 

/* SETA SystemId */
RUN setSystemId IN hMessageHandler ("{&XmlMod}":U,  "{&XmlProdVersion}").

 FOR EACH ttMaterialFamily NO-LOCK:  
     IF ttMaterialFamily.MaterialFamilyCode = "":U THEN
        RUN setKeyFields IN hMessageHandler ("tt-familia-dbr.fm-codigo":U, "*":U). 
     ELSE
        RUN setKeyFields IN hMessageHandler ("tt-familia-dbr.fm-codigo":U, string(ttMaterialFamily.MaterialFamilyCode)). 
 END. 


/* INFORMA A EMPRESA E O ESTABELECIMENTO */
RUN setCompanyId IN hMessageHandler ( String(v_cdn_empres_usuar) , " " ).  

     /* RESETA OS VALORES */
     RUN reset IN hGenXml.

     /* SETA VALOR DE ENCODING */
     RUN setEncoding IN hGenXml ("UTF-8":U).


     RUN addNode IN hGenXml (getStack(), "Upsert":U, "":U, OUTPUT iId).
     addStack(iId).

          RUN addNode IN hGenXml (getStack(), "ListOfMaterialFamily":U, "":U, OUTPUT iId).
          addStack(iId).

               FOR EACH ttMaterialFamily:
                    
                   RUN addNode IN hGenXml (getStack(), "MaterialFamily":U, "":U, OUTPUT iId).
                    addStack(iId).

                         RUN addNode IN hGenXml (getStack(), "MaterialFamilyCode":U, ttMaterialFamily.MaterialFamilyCode, OUTPUT iId).
                         IF ttMaterialFamily.MaterialFamilyDescription <> ? THEN
                         DO: /*Test LOGIC*/
                              RUN addNode IN hGenXml (getStack(), "MaterialFamilyDescription":U, ttMaterialFamily.MaterialFamilyDescription, OUTPUT iId).
                         END. /*Test LOGIC*/
                         IF ttMaterialFamily.Policy = ? OR 
                            ttMaterialFamily.Policy < 1 or
                            ttMaterialFamily.Policy > 6 THEN
                            ASSIGN ttMaterialFamily.Policy = 1.

                         RUN addNodeDec IN hGenXml (getStack(), "Policy":U, ttMaterialFamily.Policy, OUTPUT iId).
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
RUN sendMessage IN hMessageHandler (INPUT "dbr/MaterialFamilyDBR_204_200.xsd":U). 

/* VERIFICA SE OCORREU ALGUM ERRO */
IF RETURN-VALUE <> "OK":U THEN DO:
    {utp/ut-liter.i Erro_no_envio_da_mensagem * r}
    CREATE tt-erro.
    ASSIGN iContErro        = iContErro + 1
           tt-erro.cd-erro  = 17006
           tt-erro.mensagem = trim(RETURN-VALUE) 
           tt-erro.i-sequen = iContErro. 
    RETURN "NOK":U.
END.



/* VERIFICA SE A MENSAGEM FOI PROCESSADA COM SUCESSO */
RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).

/* SE NAO ENVIO COM SUCESSO */
IF NOT pSendSuccess THEN DO:
     REPEAT iCount = 1 TO pTotalErrors:
         CREATE tt-erro.
         ASSIGN iContErro        = iContErro + 1
                tt-erro.i-sequen = iContErro. 

         RUN getError IN hMessageHandler (iCount, OUTPUT tt-erro.cd-erro, OUTPUT pErrorType, OUTPUT tt-erro.mensagem).
     END.
     RETURN "NOK".
END.
ELSE RETURN "OK".

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.


/****** INTERNAL PROCEDURES - END*/


{adapters/xml/dbr/axsdb010Upsert.i}





