/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXREP004 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axrep004 MUT}
&ENDIF




{cdp/cdcfgdis.i}
&IF DEFINED(bf_dis_nfe) &THEN

/******************           INTEGRA€ÇO EAI:             *********************/
/**********  ADAPTER RECEBIMENTO NOTA FISCAL ELETRONICA - AXREP002  ***********/
/* Cria‡Æo: 13/03/2007                                            
   Samanta Rosalina Cunha                                                     */

/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */
&GLOBAL-DEFINE XmlApp            VD2
&GLOBAL-DEFINE XmlMod            MFT
&GLOBAL-DEFINE XmlProdName       EMS
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       ConsultationDocument
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 204.999
&GLOBAL-DEFINE XmlListOfAction   upd
/* DEFINICAO DE PRE-PROCESSADORES - END */

/*LOCAL VARIABLES - BEGIN*/
DEF VAR hBusinessContent AS HANDLE           NO-UNDO.
DEF VAR lSuccessProcess  AS LOG    INITIAL ? NO-UNDO.
DEF VAR cTranEvent       AS CHAR   INITIAL ? NO-UNDO.
DEF VAR cTranVersion     AS CHAR   INITIAL ? NO-UNDO.
DEF VAR hGenXml          AS HANDLE           NO-UNDO. 
DEF VAR hMessageHandler  AS HANDLE           NO-UNDO.
DEF VAR cReturnValue     AS CHAR   INITIAL ? NO-UNDO.
DEF VAR cTranAction      AS CHAR   INITIAL ? NO-UNDO.
/*LOCAL VARIABLES - END*/

/* DEFINI€ÇO TABELA TEMPORARIA */
DEFINE TEMP-TABLE ttConsultationDocument no-undo
    FIELD versao     AS DECIMAL   INITIAL ? 
    FIELD id         AS CHARACTER INITIAL ?
    FIELD tpAmb      AS CHARACTER INITIAL ? 
    FIELD verAplic   AS CHARACTER INITIAL ?
    FIELD cStat      AS CHARACTER INITIAL ?
    FIELD xMotivo    AS CHARACTER INITIAL ? 
    FIELD dhRecbto   AS CHARACTER INITIAL ?
    FIELD nProt      AS CHARACTER INITIAL ?
    FIELD digVal     AS CHARACTER INITIAL ? .

{method/dbotterr.i} /* Defini‡Æo row errors*/

/* DEFINE AS VARIµVEIS USADAS EM xmlloadmessagehandlerrec.i */
{xmlinc/xmlloadmessagehandlerrecdef.i}

/* DEFINE AS VARIµVEIS PARA USO DO xmlLoadGenXmlRec.i */
{xmlinc/xmlloadgenxmlrecdef.i}

/* DEFINE AS VARIµVEIS PARA USO DO xmlgettranssubsinfo */
{xmlinc/xmlgettranssubsinfo.i}

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

    DEFINE VAR iretConsSitNFe AS INTEGER INITIAL ? NO-UNDO.
    DEFINE VAR iinfProt       AS INTEGER INITIAL ? NO-UNDO.

    RUN getBusinessContent IN hMessageHandler (OUTPUT hBusinessContent).
    RUN reset              IN hGenXml.
    RUN loadXml            IN hGenXml (hBusinessContent).

    DELETE OBJECT hBusinessContent NO-ERROR.

    /* ********* LEITURA DA MENSAGEM - BEGIN ********* */
    addStack(1).

    EMPTY TEMP-TABLE ttConsultationDocument NO-ERROR.
    CREATE ttConsultationDocument.

    RUN searchTag IN hGenXml (INPUT "retConsSitNFe":U, 
                              INPUT getStack(), 
                              OUTPUT iretConsSitNFe).

    IF iretConsSitNFe <> ? THEN DO:
        addStack(iretConsSitNFe).

        RUN getSonVal IN hGenXml (INPUT iretConsSitNFe, 
                                  INPUT "versao":U, 
                                  OUTPUT ttConsultationDocument.versao).

        RUN searchTag IN hGenXml (INPUT "infProt":U, 
                                  INPUT iretConsSitNFe, 
                                  OUTPUT iinfProt).

        IF iinfProt <> ? THEN DO:
            addStack(iinfProt).

            RUN getSonVal IN hGenXml (INPUT iinfProt, INPUT "id":U, OUTPUT ttConsultationDocument.id).
            RUN getSonVal IN hGenXml (INPUT iinfProt, INPUT "tpAmb":U, OUTPUT ttConsultationDocument.tpAmb).
            RUN getSonVal IN hGenXml (INPUT iinfProt, INPUT "verAplic":U, OUTPUT ttConsultationDocument.verAplic).
            RUN getSonVal IN hGenXml (INPUT iinfProt, INPUT "cStat":U, OUTPUT ttConsultationDocument.cStat).
            RUN getSonVal IN hGenXml (INPUT iinfProt, INPUT "xMotivo":U, OUTPUT ttConsultationDocument.xMotivo).
            RUN getSonVal IN hGenXml (INPUT iinfProt, INPUT "dhRecbto":U, OUTPUT ttConsultationDocument.dhRecbto).
            RUN getSonVal IN hGenXml (INPUT iinfProt, INPUT "nProt":U, OUTPUT ttConsultationDocument.nProt).
            RUN getSonVal IN hGenXml (INPUT iinfProt, INPUT "digVal":U, OUTPUT ttConsultationDocument.digVal).
        END.                                                   

        delStack().
    END.
    /* ********* LEITURA DA MENSAGEM - END   ********* */

    /* ********* EFETIVA€ÇO - BEGIN ********* */
    {adapters/xml/ep2/axrep004upsert.i}
    /* ********* EFETIVA€ÇO - END   ********* */

END PROCEDURE.

PROCEDURE receiveMessage:

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM hInputXML  AS HANDLE NO-UNDO.
    DEFINE OUTPUT PARAM hOutputXML AS HANDLE NO-UNDO.
    /*PARAMETERS - END*/

    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */

    EMPTY TEMP-TABLE RowErrors NO-ERROR.
    
    {xmlinc/xmlloadmessagehandlerrec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="hOutputXML"}
    IF  cReturnValue <> "OK":U THEN 
        IF cReturnValue <> ? AND cReturnValue <> "" THEN 
            RUN setError IN hMessageHandler (INPUT 17006,
                                             INPUT "enviroment_error":U,
                                             INPUT cReturnValue).

    RUN parseMessage IN hMessageHandler (INPUT  hInputXml,
                                         INPUT "{&XmlTranName}", 
                                         INPUT "{&XmlMaxTranVersion}", 
                                         INPUT "{&XmlMinTranVersion}", 
                                         INPUT "{&XmlListOfEvents}",
                                         OUTPUT lSuccessProcess,
                                         OUTPUT cTranAction, 
                                         OUTPUT cTranEvent,
                                         OUTPUT cTranVersion,
                                         OUTPUT hOutputXML ).

     IF NOT lSuccessProcess 
     OR RETURN-VALUE <> "OK":U THEN
         RUN setError IN hMessageHandler (INPUT 17006,
                                          INPUT "enviroment_error":U,
                                          INPUT RETURN-VALUE).

     {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="hOutputXML"}

     IF cReturnValue <> "OK":U THEN DO:

        DELETE OBJECT hBusinessContent NO-ERROR.
        RUN setError IN hMessageHandler (INPUT 17006,
                                         INPUT "enviroment_error":U,
                                         INPUT cReturnValue).
        RETURN cReturnValue.
     END.

    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

    {adapters/xml/ep2/axrep004versioncontrol.i}

END PROCEDURE.
/****** INTERNAL PROCEDURES - END*/
&endif
