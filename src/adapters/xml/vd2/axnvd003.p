/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXNVD003 2.00.00.003}  /*** 010003 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i axnvd003 MAX}
&ENDIF

/*****************************************************************************/
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : AXNVD003
    Purpose     : PEDIDO DE VENDA ::: ENVIO DE NOTIFICA€ÇO

    Syntax      :

    Description : ADAPTER DE ENVIO DE NOTIFICA€¶O (Atualiza‡Æo Pedido de Venda)
    Author(s)   : Eliza Fernandes Corrˆa - its0061
    CREATED     : 09/08/2005 08:00
    Notes       :
  ----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */

/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlTranName      SalesOrderNotify
&GLOBAL-DEFINE XmlTranVersion   204.000
&GLOBAL-DEFINE XmlProdName      EMS2
&GLOBAL-DEFINE XmlProdVersion   204
&GLOBAL-DEFINE XmlApp           VD2 
&GLOBAL-DEFINE XmlMod           MPD

{method/dbotterr.i}
{cdp/cd9043.i1}
{dibo/bodi159.i tt-ped-venda}

/* Parƒmetros */
DEFINE INPUT  PARAM pRowidPedVenda AS ROWID NO-UNDO.
DEFINE INPUT  PARAM TABLE FOR tt-ped-venda.
DEFINE OUTPUT PARAM TABLE FOR RowErrors.

/* Vari veis */
DEF VAR iId              AS INT    NO-UNDO.
DEF VAR hGenXml          AS HANDLE NO-UNDO.
DEF VAR hBusinessContent AS HANDLE NO-UNDO.

DEF VAR hMessageHandler  AS HANDLE NO-UNDO.
DEF VAR cReturnValue     AS CHAR   NO-UNDO.

DEF VAR pSendSuccess     AS LOG INIT YES NO-UNDO.
DEF VAR lCreateMsg       AS LOG          NO-UNDO.
DEF VAR pTotalErrors     AS INT          NO-UNDO.
DEF VAR pErrorNumber     AS INT          NO-UNDO.
DEF VAR pErrorType       AS CHAR         NO-UNDO.
DEF VAR pErrorDesc       AS CHAR         NO-UNDO.
DEF VAR iCount           AS INT          NO-UNDO.

/* Fun‡äes p/ leitura do XML */
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
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  CREATE Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

/* ***************************  Main Block  *************************** */
{utp/ut-glob.i}
{cdp/cdcfgdis.i}

  &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    EMPTY TEMP-TABLE RowErrors NO-ERROR.
  &ELSE
    FOR EACH RowErrors:
        DELETE RowErrors.
    END.
  &ENDIF

  FOR FIRST tt-ped-venda NO-LOCK: END.
   IF NOT AVAIL tt-ped-venda THEN DO:
       {utp/ut-liter.i "NÆo encontrado pedido de venda do sistema de origem"}
       RUN  piCriaErro (17006, "ERROR":U, RETURN-VALUE).
       RETURN "NOK":U.
   END.

  FOR FIRST ped-venda WHERE ROWID(ped-venda) = pRowidPedVenda NO-LOCK: END.
   IF NOT AVAIL ped-venda THEN DO:
       {utp/ut-liter.i "NÆo encontrado pedido de venda processado pelo EMS"}
       RUN  piCriaErro (17006, "ERROR":U, RETURN-VALUE).
       RETURN "NOK":U.
   END.

  /* Verifica se MessageHandler.p est  na mem¢ria */
  {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

  /* Verifica se o MessageHandler foi executado corretamente */
  IF cReturnValue <> "OK":U THEN 
     IF cReturnValue <> ? AND cReturnValue <> " " THEN DO:
        RUN  piCriaErro (17006, "ERROR":U, SUBSTRING(cReturnValue,1,2000)).
        RETURN "NOK":U.
     END.

  /* Verifica se h  programas inscritos */
  RUN isSubscribed IN hMessageHandler (INPUT "{&XmlProdName}", INPUT "{&XmlApp}", INPUT "{&XmlTranName}", INPUT "{&XmlTranVersion}",
                                       INPUT "", INPUT "ntf":U, OUTPUT lCreateMsg).

  IF NOT lCreateMsg OR
     RETURN-VALUE <> "OK":U THEN
     RETURN "OK":U.

  /* Preenche o valor do elemento Comment de TransactionId */
  RUN setTransInfoComment IN hMessageHandler ("Comment"). 

  /*Seta SystemID*/
  RUN setSystemId IN hMessageHandler ("{&XmlMod}", "{&XmlProdVersion}"). 

  /* Indica valor da chave prim ria da transa‡Æo */
  RUN setKeyFields IN hMessageHandler ("ped-venda.nr-pedido", STRING(ped-venda.nr-pedido)). 

  /* Seta a empresa e o estabelecimento */
  RUN setCompanyId IN hMessageHandler (STRING(v_cdn_empres_usuar), ""). 

  /* Verifica se API est  na mem¢ria */
  {xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}

  /* Verifica se o ut-genxml foi executado corretamente */
  IF cReturnValue <> "OK":U THEN 
     IF cReturnValue <> ? AND cReturnValue <> "" THEN DO:
        RUN  piCriaErro (17006, "ERROR":U, SUBSTRING(cReturnValue,1,2000)).
        RETURN "NOK":U.
     END.

  /* Cria mensagem do BusinessContent atrav‚s da API*/
  CREATE-BUSINESS-XML:
  DO:
    /* RESETA OS VALORES */
    RUN reset IN hGenXml.

    /* SETA VALOR DE ENCODING */
    RUN setEncoding IN hGenXml ("UTF-8").


    RUN addNode IN hGenXml (getStack(), "Notify":U, "":U, OUTPUT iId).
      addStack(iId).

           RUN addNode IN hGenXml (getStack(), "TransactionName":U, "SalesOrder":U, OUTPUT iId).

           /* Informa‡äes do sistema de origem ::: tt-ped-venda */
           RUN addNode IN hGenXml (getStack(), "KeyFieldsOfOriginalSystem":U, "":U, OUTPUT iId).
           addStack(iId).

             RUN addNode IN hGenXml (getStack(), "OrderNumber":U, tt-ped-venda.nr-pedido, OUTPUT iId).

             &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
                 RUN addNode IN hGenXml (getStack(), "ExternalOrderNumber":U, tt-ped-venda.nr-pedido-crm, OUTPUT iId).
             &ELSE
                 RUN addNode IN hGenXml (getStack(), "ExternalOrderNumber":U, substring(tt-ped-venda.char-2,1,9), OUTPUT iId).
             &ENDIF

             RUN addNode IN hGenXml (getStack(), "CustomerOrderNumber":U, tt-ped-venda.nr-pedcli, OUTPUT iId).
             RUN addNode IN hGenXml (getStack(), "CustomerNumber":U, tt-ped-venda.cod-emitente, OUTPUT iId).
             RUN addNode IN hGenXml (getStack(), "CustomerShortName":U, tt-ped-venda.nome-abrev, OUTPUT iId).

             /*--- Conforme engenharia Integ EAI EMS2 x Wise Neogrid -------------------------------------------------------*/
             FIND FIRST emitente WHERE
                        emitente.nome-abrev = tt-ped-venda.nome-abrev NO-LOCK NO-ERROR.
             IF AVAIL emitente THEN
             RUN addNode IN hGenXml (getStack(), "CustomerTaxID":U, emitente.cgc, OUTPUT iId).

             RUN addNode IN hGenXml (getStack(), "MainSiteID":U, tt-ped-venda.cod-estabel, OUTPUT iId).

             FOR FIRST estabelec fields(cod-estab cgc) WHERE estabelec.cod-estab = tt-ped-venda.cod-estabel NO-LOCK:
                 RUN addNode IN hGenXml (getStack(), "SiteTaxID":U, estabelec.cgc, OUTPUT iId).
             END.

             /*-------------------------------------------------------------------------------------------------------------*/

           delStack().

           /* Informa‡äes do pedido processado pelo EMS ::: ped-venda */
           RUN addNode IN hGenXml (getStack(), "KeyFieldsOfDestinationSystem":U, "", OUTPUT iId).
           addStack(iId).

             RUN addNode IN hGenXml (getStack(), "OrderNumber":U, ped-venda.nr-pedido, OUTPUT iId).

             &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
                 RUN addNode IN hGenXml (getStack(), "ExternalOrderNumber":U, ped-venda.nr-pedido-crm, OUTPUT iId).
             &ELSE
                 RUN addNode IN hGenXml (getStack(), "ExternalOrderNumber":U, substring(ped-venda.char-2,1,9), OUTPUT iId).
             &ENDIF

             RUN addNode IN hGenXml (getStack(), "CustomerOrderNumber":U, ped-venda.nr-pedcli, OUTPUT iId).
             RUN addNode IN hGenXml (getStack(), "CustomerNumber":U, ped-venda.cod-emitente, OUTPUT iId).
             RUN addNode IN hGenXml (getStack(), "CustomerShortName":U, ped-venda.nome-abrev, OUTPUT iId).

             /*--- Conforme engenharia Integ EAI EMS2 x Wise Neogrid -------------------------------------------------------*/
             FIND FIRST emitente WHERE
                        emitente.nome-abrev = ped-venda.nome-abrev NO-LOCK NO-ERROR.
             IF AVAIL emitente THEN
             RUN addNode IN hGenXml (getStack(), "CustomerTaxID":U, emitente.cgc, OUTPUT iId).

             RUN addNode IN hGenXml (getStack(), "MainSiteID":U, ped-venda.cod-estabel, OUTPUT iId).

             FOR FIRST estabelec fields(cod-estab cgc) WHERE estabelec.cod-estab = ped-venda.cod-estabel NO-LOCK:
                 RUN addNode IN hGenXml (getStack(), "SiteTaxID":U, estabelec.cgc, OUTPUT iId).
             END.

             /*-------------------------------------------------------------------------------------------------------------*/
            
           delStack().

           RUN addNode IN hGenXml (getStack(), "OthersFields":U, "", OUTPUT iId).
           addStack(iId).

             RUN addNode IN hGenXml (getStack(), "OrderItemOpenedAmount":U, ped-venda.vl-liq-abe, OUTPUT iId).
             RUN addNode IN hGenXml (getStack(), "OrderTotalNetAmount":U, ped-venda.vl-liq-ped, OUTPUT iId).
             RUN addNode IN hGenXml (getStack(), "OrderTotalAmount":U, ped-venda.vl-tot-ped, OUTPUT iId).
             RUN addNode IN hGenXml (getStack(), "TotalDiscountAmount":U, ped-venda.val-desconto-total, OUTPUT iId).

             IF ped-venda.cod-sit-ped >= 1 AND ped-venda.cod-sit-ped <= 7 THEN
                RUN addNode IN hGenXml (getStack(), "CurrentOrderStatus":U, ped-venda.cod-sit-ped, OUTPUT iId).
             ELSE
                RUN addNode IN hGenXml (getStack(), "CurrentOrderStatus":U, 1, OUTPUT iId).

             IF ped-venda.cod-sit-aval >= 1 AND ped-venda.cod-sit-aval <= 5 THEN
                RUN addNode IN hGenXml (getStack(), "CreditApprovalCurrentStatus":U, ped-venda.cod-sit-aval, OUTPUT iId).
             ELSE
                RUN addNode IN hGenXml (getStack(), "CreditApprovalCurrentStatus":U, 1, OUTPUT iId).

             IF ped-venda.cod-sit-preco >= 1 AND ped-venda.cod-sit-preco <= 4 THEN
                RUN addNode IN hGenXml (getStack(), "PriceApprovalCurrentStatus":U, ped-venda.cod-sit-preco, OUTPUT iId).
             ELSE
                RUN addNode IN hGenXml (getStack(), "PriceApprovalCurrentStatus":U, 1, OUTPUT iId).

             IF ped-venda.ind-sit-desconto >= 1 AND ped-venda.ind-sit-desconto <= 3  THEN
                RUN addNode IN hGenXml (getStack(), "DiscountApprovalCurrentStatus":U, ped-venda.ind-sit-desconto, OUTPUT iId).
             ELSE
                RUN addNode IN hGenXml (getStack(), "DiscountApprovalCurrentStatus":U, 1, OUTPUT iId).

             /* Itens do pedido */
             RUN addNode IN hGenXml (getStack(), "ListOfOrderItens":U, "":U, OUTPUT iId).
             addStack(iId).

                 FOR EACH ped-item OF ped-venda NO-LOCK:

                     RUN addNode IN hGenXml (getStack(), "OrderItem":U, "":U, OUTPUT iId).
                     addStack(iId).

                         RUN addNode IN hGenXml (getStack(), "OrderLine":U, ped-item.nr-sequencia, OUTPUT iId).
                         RUN addNode IN hGenXml (getStack(), "ItemCode":U, ped-item.it-codigo, OUTPUT iId).

                         RUN addNode IN hGenXml (getStack(), "OrderItemOpenedAmount":U, ped-item.vl-liq-abe, OUTPUT iId).
                         RUN addNode IN hGenXml (getStack(), "OrderItemTotalNetAmount":U, ped-item.vl-liq-it, OUTPUT iId).
                         RUN addNode IN hGenXml (getStack(), "OrderItemTotalAmount":U, ped-item.vl-tot-it, OUTPUT iId).
                         RUN addNode IN hGenXml (getStack(), "TotalDiscountAmount":U, ped-item.val-desconto-total, OUTPUT iId).

                         IF ped-item.cod-sit-item >= 1 AND ped-item.cod-sit-item <= 7 THEN
                            RUN addNode IN hGenXml (getStack(), "CurrentOrderItemStatus":U, ped-item.cod-sit-item, OUTPUT iId).
                         ELSE
                            RUN addNode IN hGenXml (getStack(), "CurrentOrderStatus":U, 1, OUTPUT iId).

                         IF ped-item.cod-sit-preco >= 1 AND ped-item.cod-sit-preco <= 4 THEN
                            RUN addNode IN hGenXml (getStack(), "PriceApprovalCurrentStatus":U, ped-item.cod-sit-preco, OUTPUT iId).
                         ELSE
                            RUN addNode IN hGenXml (getStack(), "PriceApprovalCurrentStatus":U, 1, OUTPUT iId).
                     delStack().

                 END. /* ped-item */
             delStack().

           delStack().

      delStack().

    /* Obt‚m XMl na variavel handle */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).

    /* Passa handle do BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

    /* Elimina handle */
    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Envia XML para ControlBroker */                                       
    RUN sendMessage IN hMessageHandler (INPUT "vd2/SalesOrderNotify_204_000.xsd").

    /*Verifica se a mensagem foi enviada com sucesso */
    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).

    IF NOT pSendSuccess THEN DO:
      REPEAT iCount = 1 TO pTotalErrors:
          RUN getError IN hMessageHandler (iCount, OUTPUT pErrorNumber, OUTPUT pErrorType, OUTPUT pErrorDesc ).
          RUN  piCriaErro (17006, "ERROR":U, SUBSTRING(pErrorDesc,1,2000)).
      END.
      RETURN "NOK":U.
    END.


  END.

  /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

