/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXRVD005 2.00.00.002}  /*** 010002 ***/


/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */
&GLOBAL-DEFINE XmlApp            VD2
&GLOBAL-DEFINE XmlMod            MPD  
&GLOBAL-DEFINE XmlProdName       EMS2 
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       ProductComposition
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 204.999
&GLOBAL-DEFINE XmlListOfAction   qry
/* DEFINICAO DE PRE-PROCESSADORES - END */

/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR hGenXml          AS HANDLE              NO-UNDO.
DEFINE VAR cTranAction      AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cTranEvent       AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cReturnValue     AS CHARACTER           NO-UNDO.
DEFINE VAR cTranVersion     AS CHARACTER INITIAL ? NO-UNDO.   
DEFINE VAR hBusinessContent AS HANDLE              NO-UNDO.
DEFINE VAR hMessagehandler  AS HANDLE              NO-UNDO.
DEFINE VAR lSuccessProcess  AS LOGICAL   INITIAL ? NO-UNDO.
DEFINE VAR cErrorText       AS CHAR                NO-UNDO.

/* Variaveis utilizadas na leitura da mensagem de consulta */
DEF VAR c-it-codigo-ini   AS CHAR  NO-UNDO INITIAL ?.
DEF VAR c-it-codigo-fim   AS CHAR  NO-UNDO INITIAL ?.
DEF VAR c-desc-item-ini   AS CHAR  NO-UNDO INITIAL ?.
DEF VAR c-desc-item-fim   AS CHAR  NO-UNDO INITIAL ?.

/* Variaveis utilizadas na construá∆o da mensagem de retorno */
DEF VAR iId                AS INT  NO-UNDO INITIAL ?.
DEF VAR pSendSuccess       AS LOG  NO-UNDO INITIAL YES.
DEF VAR pTotalErrors       AS INT  NO-UNDO.
DEF VAR pErrorNumber       AS INT  NO-UNDO.
DEF VAR pErrorType         AS CHAR NO-UNDO.
DEF VAR pErrorDesc         AS CHAR NO-UNDO.
DEF VAR iCount             AS INT  NO-UNDO.
DEF VAR iErrorCount        AS INT  NO-UNDO.

/*LOCAL VARIABLES - END*/

DEF BUFFER b-item FOR ITEM.

{method/dbotterr.i} 

{xmlinc/xmlloadmessagehandlerrecdef.i}
{xmlinc/xmlloadgenxmlrecdef.i}
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

PROCEDURE piQuery: 


    EMPTY TEMP-TABLE RowErrors NO-ERROR.

    RUN getBusinessContent IN hMessagehandler (OUTPUT hBusinessContent).
    RUN reset              IN hGenXml.
    RUN loadXml            IN hGenXml (hBusinessContent).

    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Là mensagem enviada que contÇm as faixas/parÉmetros de seleá∆o da consulta */
    RUN getFirstSonId IN hGenXml (INPUT getStack(), OUTPUT iId). /* Query */
    addStack(iId). 

          RUN searchTag IN hGenXml (INPUT "ItemCode":U, INPUT getStack(), OUTPUT iId). 
          IF iId <> ? THEN DO:
             addStack(iId).
              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialCode":U, OUTPUT c-it-codigo-ini).

              RUN searchTag IN hGenXml (INPUT "FinalCode":U, INPUT getStack(), OUTPUT iId).
              IF iId <> ? THEN
                 RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalCode":U, OUTPUT c-it-codigo-fim).
             delStack().
          END.

          RUN searchTag IN hGenXml (INPUT "ItemDescription":U, INPUT getStack(), OUTPUT iId).
          IF iId <> ? THEN DO:
             addStack(iId).
                RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialDescription":U, OUTPUT c-desc-item-ini).

                RUN searchTag IN hGenXml (INPUT "FinalDescription":U, INPUT getStack(), OUTPUT iId).
                IF iId <> ? THEN
                   RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalDescription":U, OUTPUT c-desc-item-fim).
             delStack().
          END.

    delStack(). /* Query */   

    IF c-it-codigo-ini  = ? THEN ASSIGN c-it-codigo-ini = ""
                                        c-it-codigo-fim = "ZZZZZZZZZZZZZZZZ":U.

    IF c-desc-item-ini  = ? THEN ASSIGN c-desc-item-ini = ""
                                        c-desc-item-fim = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ":U.

    /* Se elemento final n∆o for enviado, considera-se faixa inicial */
    IF c-it-codigo-fim  = ? THEN ASSIGN c-it-codigo-fim = c-it-codigo-ini. 
    IF c-desc-item-fim  = ? THEN ASSIGN c-desc-item-fim = c-desc-item-ini.

    /* Cria mensagem com os pedidos encontrados */
    RUN reset       IN hGenXml.
    RUN setEncoding IN hGenXml ("UTF-8":U).

    RUN addNode     IN hGenXml (0, "ListOfItens":U, "":U, OUTPUT iId). 
    addStack(iId).

        FOR EACH item FIELDS (it-codigo desc-item un) NO-LOCK WHERE
                 item.it-codigo       >= c-it-codigo-ini
             AND item.it-codigo       <= c-it-codigo-fim
             AND item.desc-item       >= c-desc-item-ini
             AND item.desc-item       <= c-desc-item-fim
             AND item.politica         = 6 /* item composto */  :

          RUN addNode IN hGenXml (getStack(), "Item":U, "", OUTPUT iId).
          addStack(iId).

              RUN addNode IN hGenXml (getStack(), "ItemCode":U, ITEM.it-codigo, OUTPUT iId).
              RUN addNode IN hGenXml (getStack(), "ItemDescription":U, ITEM.desc-item, OUTPUT iId).
              RUN addNode IN hGenXml (getStack(), "UnitOfMeasure":U, "":U, OUTPUT iId).
              addStack(iId).

                   RUN addNode IN hGenXml (getStack(), "UnitOfMeasureCode":U, ITEM.un, OUTPUT iId).

                   FOR FIRST tab-unidade FIELDS (descricao) WHERE tab-unidade.un = ITEM.un NO-LOCK: END.
                    IF AVAIL tab-unidade THEN
                       RUN addNode IN hGenXml (getStack(), "UnitOfMeasureDescription":U, tab-unidade.descricao, OUTPUT iId).
              delStack().

              IF CAN-FIND (FIRST prod-composto 
                           WHERE prod-composto.it-codigo-pai = ITEM.it-codigo NO-LOCK) THEN DO:

                  RUN addNode IN hGenXml (getStack(), "ListOfProductComposition":U, "":U, OUTPUT iId).
                  addStack(iId).

                       FOR EACH prod-composto FIELDS (it-codigo-filho qt-filho) 
                          WHERE prod-composto.it-codigo-pai = ITEM.it-codigo NO-LOCK :

                            FOR FIRST b-item FIELDS (desc-item un)
                                WHERE b-item.it-codigo = prod-composto.it-codigo-filho NO-LOCK: END.

                            RUN addNode IN hGenXml (getStack(), "Component":U, "":U, OUTPUT iId).
                            addStack(iId).

                                  RUN addNode IN hGenXml (getStack(), "ItemCode":U, prod-composto.it-codigo-filho, OUTPUT iId).

                                  IF AVAIL b-item THEN DO:

                                     RUN addNode IN hGenXml (getStack(), "ItemDescription":U, b-item.desc-item, OUTPUT iId).
                                     RUN addNode IN hGenXml (getStack(), "ItemReferenceCode":U, prod-composto.cod-refer, OUTPUT iId).
                                     RUN addNode IN hGenXml (getStack(), "UnitOfMeasure":U, "":U, OUTPUT iId).
                                     addStack(iId).

                                        RUN addNode IN hGenXml (getStack(), "UnitOfMeasureCode":U, b-item.un, OUTPUT iId).

                                        FOR FIRST tab-unidade FIELDS (descricao) WHERE tab-unidade.un = b-item.un NO-LOCK: END.
                                         IF AVAIL tab-unidade THEN
                                            RUN addNode IN hGenXml (getStack(), "UnitOfMeasureDescription":U, tab-unidade.descricao, OUTPUT iId).
                                     delStack().
                                  END.

                                 RUN addNodeDec IN hGenXml (getStack(), "Quantity":U, prod-composto.qt-filho, OUTPUT iId).

                            delStack().
                       END. /* each prod-composto */
                  delStack(). /* ListOfProductComposition */

              END.

          delStack(). /* Item */
        END. /* each item */

    delStack(). /* ListOfItens */

    RUN generateXML        IN hGenXml (OUTPUT hBusinessContent). /* gera XML com os itens ncontrados */
    RUN sendMessage        IN hMessageHandler (INPUT "vd2/ProductComposition_204_000.xsd":U). 
    RUN getReturnStatus    IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).

    IF NOT pSendSuccess THEN DO: /* Erro na geraá∆o da mensagem de retorno */
       REPEAT iCount = 1 TO pTotalErrors:

          RUN getError IN hMessageHandler (iCount, OUTPUT pErrorNumber, OUTPUT pErrorType, OUTPUT pErrorDesc ).
          CREATE RowErrors.
          ASSIGN RowErrors.ErrorSequence     = iErrorCount + 1
                 RowErrors.ErrorNumber       = pErrorNumber
                 RowErrors.ErrorType         = pErrorType
                 RowErrors.ErrorSubType      = "Error":U
                 RowErrors.ErrorDescription  = SUBSTRING(pErrorDesc,1,2000)
                 RowErrors.ErrorHelp         = SUBSTRING(pErrorDesc,1,20000)
                 iErrorCount                 = iErrorCount + 1.
       END.
    END.

END PROCEDURE.


PROCEDURE receiveMessage:

/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAM hInputXML  AS HANDLE NO-UNDO.
DEFINE OUTPUT PARAM hOutputXML AS HANDLE NO-UNDO.
/*PARAMETERS - END*/

     {xmlinc/xmlloadmessagehandlerrec.i &Messagehandler="hMessagehandler" &MHReturnValue="cReturnValue" &MHReturnError="hOutputXML"}

     IF  cReturnValue <> "OK":U THEN 
      IF cReturnValue <> ? AND cReturnValue <> "" THEN 
        RUN setError IN hMessagehandler (INPUT 0,
                                         INPUT "enviroment_error":U,
                                         INPUT cReturnValue).

     RUN parseMessage IN hMessagehandler (INPUT  hInputXml, INPUT "{&XmlTranName}":U, 
                                          INPUT "{&XmlMaxTranVersion}":U, 
                                          INPUT "{&XmlMinTranVersion}":U, 
                                          INPUT "{&XmlListOfEvents}":U,
                                          OUTPUT lSuccessProcess,
                                          OUTPUT cTranAction, 
                                          OUTPUT cTranEvent,
                                          OUTPUT cTranVersion,
                                          OUTPUT hOutputXML ).

     IF NOT lSuccessProcess OR RETURN-VALUE <> "OK":U THEN 
        IF cReturnValue <> ? AND cReturnValue <> " " THEN
          RUN setError IN hMessagehandler (INPUT 0,
                                           INPUT "enviroment_error":U,
                                           INPUT cReturnValue).

     {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="hOutputXML"}

      IF cReturnValue <> "OK":U THEN 
        IF cReturnValue <> ? AND cReturnValue <> "" THEN DO:

          /* ELIMINA A MENSAGEM OBTIDA NO MêTODO getBusinessContent */
          DELETE OBJECT hBusinessContent NO-ERROR.

          RUN setError IN hMessagehandler (INPUT 0,
                                           INPUT "enviroment_error":U,
                                           INPUT cReturnValue).
        END.

      IF cTranAction = "qry":U THEN RUN piQuery.

      RUN setQueryReturnContent IN hMessageHandler (INPUT hBusinessContent).
      RUN getReturnMessage      IN hMessageHandler (OUTPUT hOutputXML). 


END PROCEDURE.

/****** INTERNAL PROCEDURES - END*/




