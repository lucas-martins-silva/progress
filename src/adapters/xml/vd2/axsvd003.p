/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSVD003 2.00.00.011 } /*** 010011 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i axsvd003 MAX}
&ENDIF

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
    File        : AXSVD003.p
    Purpose     : ENVIO DE PEDIDO DE VENDA

    Syntax      :

    Description : ADAPTER DE ENVIO DE PEDIDO DE VENDA
    Author(s)   : Eliza Fernandes Corrˆa - log1465
    CREATED     : 17/12/2003 08:00
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */
{cdp/cdcfgdis.i}
{include/i_dbtype.i}

/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlTranName      SalesOrder
&IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
&GLOBAL-DEFINE XmlTranVersion   206.000
&GLOBAL-DEFINE XmlProdVersion   206
&ELSE
&GLOBAL-DEFINE XmlTranVersion   204.000
&GLOBAL-DEFINE XmlProdVersion   204
&ENDIF                             
&GLOBAL-DEFINE XmlProdName      EMS2
&GLOBAL-DEFINE XmlApp           VD2 
&GLOBAL-DEFINE XmlMod           MCD

/* Parƒmetros de entrada */
DEF INPUT PARAM pTranAction    AS CHAR  NO-UNDO.
DEF INPUT PARAM pProgName      AS CHAR  NO-UNDO.
DEF INPUT PARAM pProgVersion   AS CHAR  NO-UNDO.
DEF INPUT PARAM pRowidPedVenda AS ROWID NO-UNDO.

/* Defini‡Æo temp-table RowErrors */
{method/dbotterr.i}

DEF OUTPUT PARAM TABLE FOR RowErrors.

{utp/ut-glob.i}

/* Vari veis Globais */
DEF NEW GLOBAL SHARED VAR hGenXml AS HANDLE NO-UNDO.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.

/* Variaveis da constru‡Æo do BusinessContent Utilizando APIXML */
def new global shared var iFirstId    as int no-undo.
def new global shared var iId         as int no-undo.
/* Vendor */
def new global shared var iListPaymentCodes as int no-undo.
def new global shared var iVendorInfo       as int no-undo.
/* Comex */
def new global shared var iArrival           as int no-undo.
def new global shared var iConsignee         as int no-undo.
def new global shared var iControlPoint      as int no-undo.
def new global shared var iCurrency          as int no-undo.
def new global shared var iDeclaration       as int no-undo.
def new global shared var iDispatch          as int no-undo.
def new global shared var iExpense           as int no-undo.
def new global shared var iExpensePriceTable as int no-undo.
def new global shared var iExpenseType       as int no-undo.
def new global shared var iExpenseVendor     as int no-undo.
def new global shared var iExportInfo        as int no-undo.
def new global shared var iItinerary         as int no-undo.
def new global shared var iMark              as int no-undo.
def new global shared var iLanding           as int no-undo.
def new global shared var iListExpenses      as int no-undo.
def new global shared var iListMarks         as int no-undo.
def new global shared var iNotifying         as int no-undo.
def new global shared var iOrderExport       as int no-undo.
def new global shared var iPaymentPlan       as int no-undo.
def new global shared var iShipment          as int no-undo.

def var iAddition           as int no-undo.
def var iAdditionUser       as int no-undo.
def var iCancellationUser   as int no-undo.
def var iCustomer           as int no-undo.
def var iCurrency           as int no-undo.
def var iDeliveryLocation   as int no-undo.
def var iDeliveryAddress    as int no-undo.
def var iDiscount           as int no-undo.
def var iFiscalOperation    as int no-undo.
def var iLastUpdUser        as int no-undo.
def var iListDiscounts      as int no-undo.
def var iPrice              as int no-undo.
def var iPriceAppUser       as int no-undo.
def var iReactivationUser   as int no-undo.
def var iSalesTax           as int no-undo.
def var iSuspensionUser     as int no-undo.
def var iTaxes              as int no-undo.

def var i-cont              as int no-undo.
def var i-ind-fat-qtfam     as int no-undo.

def var l-cancel            as log init no no-undo.
def var l-devol             as log init no no-undo.
def var l-last-upd          as log init no no-undo.
def var l-reativ            as log init no no-undo.
def var l-susp              as log init no no-undo.
def var l-val-desc          as log init no no-undo.

def var c-msg-dsp-pre       as char init no no-undo.

/* Vari veis para armazenar valores da inicializa‡Æo do loalMessageHandler */
DEF VAR hMessageHandler AS HANDLE NO-UNDO.
DEF VAR cReturnValue    AS CHAR     NO-UNDO.

/* Vari veis locais */
def var i-seq-parcela AS INT             NO-UNDO.
DEF VAR pSendSuccess  AS LOG INITIAL YES NO-UNDO.
DEF VAR lCREATEMsg    AS LOG             NO-UNDO.
DEF VAR pTotalErrors  AS INT             NO-UNDO.
DEF VAR pErrorNumber  AS INT             NO-UNDO.
DEF VAR pErrorType    AS CHAR            NO-UNDO.
DEF VAR pErrorDesc    AS CHAR            NO-UNDO.
def var iCount        AS INT             NO-UNDO.
def var i-cont-err    AS INT             NO-UNDO.

{include/i-epc200.i axsvd003}

DEFINE TEMP-TABLE tt-variavel NO-UNDO
    FIELD cod-var-oper LIKE config-var-operac-regra-cond.cod-variavel
    FIELD cod-val-var  LIKE config-var-operac-regra-cond.cod-val-var.

DEFINE TEMP-TABLE tt-retorno NO-UNDO
    FIELD valor-retorno LIKE config-var-operac-regra-ret.cod-val-ret
    FIELD campo-retorno LIKE config-var-operac-regra-ret.cod-campo-ret
    FIELD perc-rateio   LIKE config-var-operac-regra-ret.cdd-perc-rat.   

DEF VAR i-cod-regra-utilizada LIKE config-var-operac-regra.cdn-regra-operac.

{adapters/xml/vd2/axsvd003.i}

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

FIND ped-venda WHERE rowid(ped-venda) = pRowidPedVenda NO-LOCK NO-ERROR.
  IF AVAIL ped-venda THEN DO:

    /* Verifica se MessageHandler.p est  na mem¢ria */
  {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

  /* Verifica se o MessageHandler foi executado corretamente */
  IF cReturnValue <> "OK":U THEN DO:
     IF cReturnValue <> ? AND cReturnValue <> " " THEN DO:
      CREATE RowErrors.
      ASSIGN RowErrors.ErrorSequence     = i-cont-err + 1
             RowErrors.ErrorNumber       = 17006
             RowErrors.ErrorSubType      = "Error":U
             RowErrors.ErrorDescription  = SUBSTRING(cReturnValue,1,2000)
             RowErrors.ErrorHelp         = SUBSTRING(cReturnValue,1,20000)
             i-cont-err                  = i-cont-err + 1.
             RETURN "NOK":U.
             LEAVE.
     END.
  END.

  /* Verifica se h  programas inscritos */
  RUN isSubscribed IN hMessageHandler (INPUT "{&XmlProdName}",
                                         INPUT "{&XmlApp}",
                                         INPUT "{&XmlTranName}",
                                         INPUT "{&XmlTranVersion}",
                                         INPUT "",
                                         INPUT pTranAction,
                                         OUTPUT lCREATEMsg).

  
  IF lCREATEMsg = NO OR
     RETURN-VALUE <> "OK":U THEN
     RETURN "OK":U.

  /*---[ integra‡Æo EMSxNeogrid ]---------------------------------------------------------------------------------*/
  FIND FIRST config-tip-operac NO-LOCK
      WHERE  config-tip-operac.cod-tip-operac = 'axsvd003' NO-ERROR.
  IF  AVAIL  config-tip-operac THEN DO:
      EMPTY TEMP-TABLE tt-variavel.

      CREATE tt-variavel.
      ASSIGN tt-variavel.cod-var-oper = 'ctransaction'
             tt-variavel.cod-val-var  = pTranAction.

      CREATE tt-variavel.
      ASSIGN tt-variavel.cod-var-oper = 'cod-estabel'
             tt-variavel.cod-val-var  = ped-venda.cod-estabel.

      CREATE tt-variavel.
      ASSIGN tt-variavel.cod-var-oper = 'cod-emitente'
             tt-variavel.cod-val-var  = string(ped-venda.cod-emitente).

      CREATE tt-variavel.
      ASSIGN tt-variavel.cod-var-oper = 'nome-abrev'
             tt-variavel.cod-val-var  = ped-venda.nome-abrev.

      CREATE tt-variavel.
      ASSIGN tt-variavel.cod-var-oper = 'nat-operacao'
             tt-variavel.cod-val-var  = ped-venda.nat-operacao.

      CREATE tt-variavel.
      ASSIGN tt-variavel.cod-var-oper = 'esp-ped'
             tt-variavel.cod-val-var  = string(ped-venda.esp-ped).

      CREATE tt-variavel.
      ASSIGN tt-variavel.cod-var-oper = 'cod-gr-cli'
             tt-variavel.cod-val-var  = string(ped-venda.cod-gr-cli).

      CREATE tt-variavel.
      ASSIGN tt-variavel.cod-var-oper = 'cod-cond-pag'
             tt-variavel.cod-val-var  = string(ped-venda.cod-cond-pag).

      CREATE tt-variavel.
      ASSIGN tt-variavel.cod-var-oper = 'cod-sit-ped'
             tt-variavel.cod-val-var  = string(ped-venda.cod-sit-ped).

      CREATE tt-variavel.
      ASSIGN tt-variavel.cod-var-oper = 'cidade-cif'
             tt-variavel.cod-val-var  = ped-venda.cidade-cif.

      CREATE tt-variavel.
      ASSIGN tt-variavel.cod-var-oper = 'cod-portador'
             tt-variavel.cod-val-var  = string(ped-venda.cod-portador).

      CREATE tt-variavel.
      ASSIGN tt-variavel.cod-var-oper = 'nome-transp'
             tt-variavel.cod-val-var  = ped-venda.nome-transp.

      CREATE tt-variavel.
      ASSIGN tt-variavel.cod-var-oper = 'cod-canal-venda'
             tt-variavel.cod-val-var  = string(ped-venda.cod-canal-venda).

      CREATE tt-variavel.
      ASSIGN tt-variavel.cod-var-oper = 'tp-pedido'
             tt-variavel.cod-val-var  = ped-venda.tp-pedido.

      RUN cdp/cdapi034.p (INPUT i-ep-codigo-usuario,
                          INPUT ped-venda.cod-estabel,
                          INPUT 'axsvd003',
                          INPUT TABLE tt-variavel,
                          OUTPUT i-cod-regra-utilizada,
                          OUTPUT TABLE tt-retorno,
                          OUTPUT TABLE RowErrors).

      IF  CAN-FIND(FIRST tt-retorno
                   WHERE tt-retorno.campo-retorno = 'axsvd003'
                   AND   tt-retorno.valor-retorno = 'no') THEN RETURN 'NOK'.

      IF  CAN-FIND(FIRST RowErrors) THEN RETURN 'NOK'.
  END. /* IF  AVAIL config-tip-operac */
  /*---------------------------------------------------------------------------------[ integra‡Æo EMSxNeogrid ]---*/
  
  /* Preenche o valor do elemento Comment de TransactionId */
  RUN setTransInfoComment IN hMessageHandler ("Programa:" + pProgName + "-" +
                                              "VersÆo:"   + pProgVersion). 

  /*Seta SystemID*/
  RUN setSystemId IN hMessageHandler ("{&XmlMod}",          /*Nome do modulo */
                                      "{&XmlProdVersion}"). /* Versao do Programa*/

  /* Indica valor da chave prim ria da transa‡Æo */
  RUN setKeyFields IN hMessageHandler ("ped-venda.nr-pedido",
                                        STRING(ped-venda.nr-pedido)). 

  /* Seta a empresa e o estabelecimento */
  RUN setCompanyId IN hMessageHandler (STRING(v_cdn_empres_usuar), ""). 

  /* Verifica se API est  na mem¢ria */
  {xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}

  /* Verifica se o ut-genxml foi executado corretamente */
  IF cReturnValue <> "OK":U THEN DO:
         IF cReturnValue <> ? AND cReturnValue <> "" THEN DO:
          CREATE RowErrors.
          ASSIGN RowErrors.ErrorSequence     = i-cont-err + 1
                 RowErrors.ErrorNumber       = 17006
                 RowErrors.ErrorSubType      = "Error":U
                 RowErrors.ErrorDescription  = SUBSTRING(cReturnValue,1,2000)
                 RowErrors.ErrorHelp         = SUBSTRING(cReturnValue,1,20000)
                 i-cont-err                  = i-cont-err + 1.
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

    IF pTranAction = "ADD":U OR pTranAction = "UPD":U THEN DO:

         /* Nà PRINCIPAL UPSERT */
         RUN addNode IN hGenXml (0, "Upsert":U, "", OUTPUT iFirstId).
         RUN pi-informacoes-pedido. /* axsvd003.i */

    END. 
    ELSE IF pTranAction = "DEL":U THEN DO:

         /* Nà PRINCIPAL DELETE */
         RUN addNode IN hGenXml (0, "Delete":U, "", OUTPUT iFirstId).
         RUN addNode IN hGenXml (iFirstId, "OrderNumber":U, ped-venda.nr-pedido, OUTPUT iId).

         /* Customer */
         RUN addNode IN hGenXml (iFirstId, "Customer":U, "", OUTPUT iCustomer).
         RUN addNode IN hGenXml (iCustomer, "CustomerNumber":U, ped-venda.cod-emitente, OUTPUT iId).
         RUN addNode IN hGenXml (iCustomer, "CustomerShortName":U, ped-venda.nome-abrev, OUTPUT iId).

         FIND FIRST emitente WHERE
                    emitente.nome-abrev = ped-venda.nome-abrev NO-LOCK NO-ERROR.
           IF AVAIL emitente THEN
            RUN addNode IN hGenXml (iCustomer, "CustomerTaxID":U, emitente.cgc, OUTPUT iId).

         RUN addNode IN hGenXml (iCustomer, "CustomerOrderNumber":U, ped-venda.nr-pedcli, OUTPUT iId).
         RUN addNodeDec IN hGenXml (iFirstId, "ExternalOrderNumber":U,
                                     &if '{&BF_DIS_VERSAO_EMS}' BEGINS "2.04"
                                         &then dec(SUBSTR(ped-venda.char-2,1,9))
                                     &else
                                         &if '{&BF_DIS_VERSAO_EMS}' >= "2.05"
                                             &then ped-venda.nr-pedido-crm
                                         &else ""
                                         &endif
                                     &endif,
                                     OUTPUT iId).
    END. 

    /* Obt‚m XMl na variavel handle */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).

    /* Passa handle do BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

    /* Elimina handle */
    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Envia XML para ControlBroker */      
    &IF "{&mguni_version}" >= "2.071" &THEN
        RUN sendMessage IN hMessageHandler (INPUT "vd2/SalesOrder_206_001.xsd").
    &ELSE
        RUN sendMessage IN hMessageHandler (INPUT "vd2/SalesOrder_206_100.xsd"). /* Conforme Integra‡Æo EAI EMS x Wise Neogrid, troca de XSD */
    &ENDIF    

    /*Verifica se a mensagem foi enviada com sucesso */
    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess,
                                            OUTPUT pTotalErrors).
    IF NOT pSendSuccess THEN DO:
      REPEAT iCount = 1 TO pTotalErrors:
          RUN getError IN hMessageHandler (iCount,
                                             OUTPUT pErrorNumber,
                                             OUTPUT pErrorType,
                                             OUTPUT pErrorDesc ).
          CREATE RowErrors.
          ASSIGN RowErrors.ErrorSequence    = i-cont-err + 1
                 RowErrors.ErrorNumber      = pErrorNumber
                 RowErrors.ErrorType        = pErrorType
                 RowErrors.ErrorSubType     = "Error":U
                 RowErrors.ErrorDescription  = SUBSTRING(pErrorDesc,1,2000)
                 RowErrors.ErrorHelp         = SUBSTRING(pErrorDesc,1,20000)
                 i-cont-err                 = i-cont-err + 1.
     END.

     RETURN "NOK":U.
     LEAVE.

  END. 
  END. 


  END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

