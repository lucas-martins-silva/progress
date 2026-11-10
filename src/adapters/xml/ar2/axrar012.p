/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXRAR012 2.00.00.001 } /*** 010001 ***/


/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */
&GLOBAL-DEFINE XmlApp            AR2
&GLOBAL-DEFINE XmlMod            MCE
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    208
&GLOBAL-DEFINE XmlTranName       InventoryCounting
&GLOBAL-DEFINE XmlMinTranVersion 208.000
&GLOBAL-DEFINE XmlMaxTranVersion 999.000
&GLOBAL-DEFINE XmlListOfAction   upd,ADD

/* DEFINICAO DE PRE-PROCESSADORES - END */

/*LOCAL VARIABLES - BEGIN*/

DEFINE VAR hBusinessContent AS HANDLE NO-UNDO.
DEFINE VAR hGenXml AS HANDLE NO-UNDO.
DEFINE VAR hMessageHandler AS HANDLE NO-UNDO.
DEFINE VAR lSuccessProcess AS LOGICAL INITIAL ? NO-UNDO.
DEFINE VAR cReturnValue AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cTranEvent AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cTranVersion AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR h-boin157q01 AS HANDLE NO-UNDO.
DEFINE VAR h-boin157fx AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-inventario NO-UNDO LIKE inventario
       field r-rowid as rowid.

DEFINE TEMP-TABLE ttCount NO-UNDO
     FIELD LecturerUser AS CHARACTER INITIAL ?  /*Conferente da contagem. (Uso interno:              Tabela = mgind.inventario.   Campos = cod-confte-contag-1 ou cod-confte-contag-2 ou cod-confte-contag-3)*/
     FIELD Quantity AS decimal INITIAL ?  /*Quantidade da contagem. (Uso interno: Campo = mgind.inventario.val-apurado[1..3])*/
     FIELD Sequence AS integer INITIAL ?  /*Identificador sequencial da contagem. De 1 a 3*/
     FIELD ttCountID AS INTEGER INITIAL ?
     INDEX ixttCountID IS PRIMARY UNIQUE ttCountID ASCENDING.

{method/dbotterr.i}

/*LOCAL VARIABLES - END*/

/*PARAMETERS - BEGIN*/
/*PARAMETERS - END*/

{adapters/xml/ar2/axrar012ExtraDeclarations.i}

/* DEF. VARIµVEIS USADAS EM xmlLoadMessageHandlerRec.i */
{xmlinc/xmlLoadMessageHandlerRecDef.i}

/* DEFINE AS VARAIVEIS PARA USO DO xmlLoadGenXmlRec.i */
{xmlinc/xmlLoadGenXmlRecDef.i}

/* DEFINE AS VARIAVEIS PARA USO DO xmlgettranssubsinfo */
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

/*PARAMETERS - BEGIN*/
/*PARAMETERS - END*/

/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR iId AS INTEGER INITIAL ? NO-UNDO.
/*LOCAL VARIABLES - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

     /* OBTEM A PARTE DA MENSAGEM QUE ESTÊ ABAIXO DO ELEMENTO BusinessContent */
     RUN getBusinessContent IN hMessageHandler (OUTPUT hBusinessContent).

     /* LIMPA AS TEMP-TABLES INTERNAS DA API XML */
     RUN reset IN hGenXml.

     /* CARREGA A ESTRUTURA FILHA DE BusinessContent */
     RUN loadXml IN hGenXml (hBusinessContent).

     /* ELIMINA A MENSAGEM OBTIDA NO MêTODO getBusinessContent */
     DELETE OBJECT hBusinessContent NO-ERROR.

     /* ********* LEITURA DA MENSAGEM - BEGIN ********* */
     addStack(1).
          CREATE tt-inventario.

          RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "CountingSheetNumber", OUTPUT tt-inventario.nr-ficha).
          RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "InventoryDate", OUTPUT tt-inventario.dt-saldo).
          RUN searchTag IN hGenXml (INPUT "Item", INPUT getStack(), OUTPUT iId).
          if (iId <> ?) THEN DO:
               addStack(iId).

                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "ItemCode", OUTPUT tt-inventario.it-codigo).
                    RUN searchTag IN hGenXml (INPUT "Reference", INPUT getStack(), OUTPUT iId).
                    if (iId <> ?) THEN DO:
                         addStack(iId).

                              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "ReferenceCode", OUTPUT tt-inventario.cod-refer).
                         delStack().
                    END.

               delStack().
          END.

          RUN searchTag IN hGenXml (INPUT "Location", INPUT getStack(), OUTPUT iId).
          if (iId <> ?) THEN DO:
               addStack(iId).

                    RUN searchTag IN hGenXml (INPUT "Site", INPUT getStack(), OUTPUT iId).
                    if (iId <> ?) THEN DO:
                         addStack(iId).

                              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "SiteID", OUTPUT tt-inventario.cod-estabel).
                         delStack().
                    END.

                    RUN searchTag IN hGenXml (INPUT "Warehouse", INPUT getStack(), OUTPUT iId).
                    if (iId <> ?) THEN DO:
                         addStack(iId).

                              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "WarehouseID", OUTPUT tt-inventario.cod-depos).
                         delStack().
                    END.

                    RUN searchTag IN hGenXml (INPUT "BinLocation", INPUT getStack(), OUTPUT iId).
                    if (iId <> ?) THEN DO:
                         addStack(iId).

                              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "BinLocationID", OUTPUT tt-inventario.cod-localiz).
                         delStack().
                    END.

                    RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "LotOrSerialNumber", OUTPUT tt-inventario.lote).
               delStack().
          END.

          RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "BalanceAccounting", OUTPUT tt-inventario.valor-contab).
          RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "Situation", OUTPUT tt-inventario.situacao).
          RUN searchTag IN hGenXml (INPUT "Counts", INPUT getStack(), OUTPUT iId).
          if (iId <> ?) THEN DO:
               addStack(iId).

                    RUN searchTag IN hGenXml (INPUT "Count", INPUT getStack(), OUTPUT iId).
                    if (iId <> ?) THEN DO:
                         addStack(iId).

                              /*Criacao de valores para manter as relacoes*/
                              CREATE ttCount.
                              ASSIGN ttCount.ttCountID = iId.

                              RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "Sequence", OUTPUT ttCount.Sequence).
                              RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "Quantity", OUTPUT ttCount.Quantity).
                              RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "LecturerUser", OUTPUT ttCount.LecturerUser).

                         delStack().

                    END.
               delStack().
          END.

          RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "UpdateDate", OUTPUT tt-inventario.dt-atualiza).
          RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "LastEntryDate", OUTPUT tt-inventario.dt-ult-entra).
          RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "LastOutputDate", OUTPUT tt-inventario.dt-ult-saida).
          RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "CurrentQuantity", OUTPUT tt-inventario.qtidade-atu).
          RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "FinalQuantity", OUTPUT tt-inventario.valor-final).
          RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "PrintStatus", OUTPUT tt-inventario.impressa).
          RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "SituationWMS", OUTPUT tt-inventario.ind-sit-invent-wms).
     delStack().
     /* ********* LEITURA DA MENSAGEM - END   ********* */


     /* ********* EFETIVAÄ«O - BEGIN ********* */

{adapters/xml/ar2/axrar012Upsert.i}

     /* ********* EFETIVAÄ«O - END   ********* */

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.

PROCEDURE receiveMessage:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAM hInputXML AS HANDLE NO-UNDO.
DEFINE OUTPUT PARAM hOutputXML AS HANDLE NO-UNDO.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

     /* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
     {xmlinc/xmlLoadMessageHandlerRec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="hOutputXML"}

     IF cReturnValue <> "OK" THEN DO:
          RETURN cReturnValue.
     END.

     /* INTERPRETA, ARMAZENA E VALIDA A MENSAGEM QUE RECEBE */
     RUN parseMessage IN hMessageHandler (
          INPUT  hInputXml, INPUT "{&XmlTranName}", 
          INPUT "{&XmlMaxTranVersion}", 
          INPUT "{&XmlMinTranVersion}", 
          INPUT "{&XmlListOfEvents}",
          OUTPUT lSuccessProcess,
          OUTPUT cTranAction, 
          OUTPUT cTranEvent,
          OUTPUT cTranVersion,
          OUTPUT hOutputXML ).

     /* SE N«O PROCESSOU CORRETAMENTE RETORNA ERRO */
     IF NOT lSuccessProcess OR RETURN-VALUE <> "OK" THEN 
     /* DAR TRATAMENTO CONVENIENTE ANTES DE RETORNAR */
          RETURN RETURN-VALUE.

     /* VERIFICA SE APIXML ESTA NA MEMORIA */
     {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="hOutputXML"}

     /* VERIFICA SE O ut-genxml FOI INICIADO CORRETAMENTE */
     IF cReturnValue <> "OK"
     THEN DO:
          /* ELIMINA A MENSAGEM OBTIDA NO M?TODO getBusinessContent */
          DELETE OBJECT hBusinessContent NO-ERROR.

          RETURN cReturnValue.
     END.

{adapters/xml/ar2/axrar012VersionControl.i}

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.

/****** INTERNAL PROCEDURES - END*/
