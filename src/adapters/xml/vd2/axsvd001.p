/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSVD001 2.00.00.007 } /*** 010007 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i axsvd001 MAX}
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
    File        : AXSVD001.p
    Purpose     : ADAPTER DE ENVIO DE CONDI€åES DE PAGAMENTO

    Syntax      :

    Description : ADAPTER DE ENVIO DE CONDI€åES DE PAGAMENTO
    Author(s)   : Eliza Fernandes Corrˆa - log1465
    CREATEd     : 03/11/2003 15:00
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */

/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlTranName      PaymentPlan
&GLOBAL-DEFINE XmlTranVersion   204.000
&GLOBAL-DEFINE XmlProdName      EMS2
&GLOBAL-DEFINE XmlProdVersion   204
&GLOBAL-DEFINE XmlApp           VD2 
&GLOBAL-DEFINE XmlMod           MCD

DEFINE TEMP-TABLE tt-cond-pag NO-UNDO LIKE cond-pagto.

/*Parƒmetros de entrada*/
DEF INPUT PARAM pTranAction  AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgName    AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgVersion AS CHAR    NO-UNDO.
DEF INPUT  PARAM TABLE FOR tt-cond-pag.
/* Defini‡Æo temp-table RowErrors */
{method/dbotterr.i}
DEF OUTPUT PARAM TABLE FOR RowErrors. 

/* Vari veis Globais */
DEF VAR hGenXml          AS HANDLE NO-UNDO.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.

/* Variaveis da constru‡Æo do BusinessContent Utilizando APIXML */
DEF VAR iId         AS INT NO-UNDO.
DEF VAR iFirstId    AS INT NO-UNDO. 
DEF VAR iListTerms  AS INT NO-UNDO.
DEF VAR iTerms      AS INT NO-UNDO. 
DEF VAR iFinTable   AS INT NO-UNDO. 

/* Vari veis para armazenar valores da inicializa‡Æo do loalMessageHandler */
DEF VAR hMessageHandler AS HANDLE NO-UNDO.
DEF VAR cReturnValue    AS CHAR     NO-UNDO.

/*Vari veis locais*/
DEF VAR i-seq-parcela AS INT             NO-UNDO.
DEF VAR pSendSuccess  AS LOG INITIAL YES NO-UNDO.
DEF VAR lCREATEMsg    AS LOG             NO-UNDO.
DEF VAR pTotalErrors  AS INT             NO-UNDO.
DEF VAR pErrorNumber  AS INT             NO-UNDO.
DEF VAR pErrorType    AS CHAR            NO-UNDO.
DEF VAR pErrorDesc    AS CHAR            NO-UNDO.
DEF VAR iCount        AS INT             NO-UNDO.
DEF VAR i-cont-err    AS INT             NO-UNDO.
DEF VAR vSiteCode     AS CHAR            NO-UNDO.

{include/i-epc200.i axsvd001}
{cdp/cdcfgdis.i}

&IF '{&BF_DIS_VERSAO_EMS}' >= '2.062' &THEN
    DEFINE TEMP-TABLE tt-variavel NO-UNDO
        FIELD cod-var-oper LIKE config-var-operac-regra-cond.cod-variavel
        FIELD cod-val-var  LIKE config-var-operac-regra-cond.cod-val-var.

    DEFINE TEMP-TABLE tt-retorno NO-UNDO
        FIELD valor-retorno LIKE config-var-operac-regra-ret.cod-val-ret
        FIELD campo-retorno LIKE config-var-operac-regra-ret.cod-campo-ret
        FIELD perc-rateio   LIKE config-var-operac-regra-ret.cdd-perc-rat.   

    DEF VAR i-cod-regra-utilizada LIKE config-var-operac-regra.cdn-regra-operac.
&ENDIF

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
{utp/ut-glob.i}

/* Verifica se h  registros na temp-table */
FOR EACH tt-cond-pag:

    /* Verifica se MessageHandler.p está  na mem¢ria */
  {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

    /* Verifica se o MessageHandler foi executado corretamente */
    IF cReturnValue <> "OK":U THEN DO:
         IF cReturnValue <> ? AND cReturnValue <> " " THEN DO:

          CREATE RowErrors.
          ASSIGN RowErrors.ErrorSequence     = i-cont-err + 1
                 RowErrors.ErrorNumber       = 17006
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
    &IF '{&BF_DIS_VERSAO_EMS}' >= '2.062' &THEN
        FIND FIRST config-tip-operac NO-LOCK
            WHERE  config-tip-operac.cod-tip-operac = 'axsvd001' NO-ERROR.
        IF  AVAIL config-tip-operac THEN DO:
            EMPTY TEMP-TABLE tt-variavel.
    
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper = 'ctransaction'
                   tt-variavel.cod-val-var  = pTranAction.
    
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper = 'cod-cond-pag'
                   tt-variavel.cod-val-var  = string(tt-cond-pag.cod-cond-pag).
        END.
    
        IF  c-nom-prog-dpc-mg97 <> "" 
        OR  c-nom-prog-appc-mg97 <> "" 
        OR  c-nom-prog-upc-mg97 <> "" THEN DO:
    
            FOR EACH tt-epc WHERE tt-epc.cod-event = "EngineRegras": DELETE tt-epc. END.
    
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "EngineRegras":U
                   tt-epc.cod-parameter = "tt-variavel":U
                   tt-epc.val-parameter = STRING(TEMP-TABLE tt-variavel:HANDLE).
    
            {include/i-epc201.i "EngineRegras"}
    
            FOR FIRST para-ped NO-LOCK. END.
    
            RUN cdp/cdapi034.p (INPUT i-ep-codigo-usuario,
                                INPUT para-ped.estab-padrao,
                                INPUT 'axsvd001',
                                INPUT TABLE tt-variavel,
                                OUTPUT i-cod-regra-utilizada,
                                OUTPUT TABLE tt-retorno,
                                OUTPUT TABLE RowErrors).
    
             IF  CAN-FIND(FIRST tt-retorno
                         WHERE  tt-retorno.campo-retorno = 'axsvd001'
                         AND    tt-retorno.valor-retorno = 'no') THEN RETURN 'NOK'.

             for each tt-retorno:
                 IF tt-retorno.campo-retorno = "cod-cond-pag" THEN ASSIGN tt-cond-pag.cod-cond-pag = int(tt-retorno.valor-retorno).
             end. /* for each tt-retorno: */

            IF  CAN-FIND(FIRST RowErrors) THEN RETURN 'NOK'.

        END.
    &ENDIF
    /*---------------------------------------------------------------------------------[ integra‡Æo EMSxNeogrid ]---*/

    /* Preenche o valor do elemento Comment de TransactionId */
    RUN setTransInfoComment IN hMessageHandler ("Programa:" + pProgName + "-" +
                                                "VersÆo:"   + pProgVersion). 

    /*Seta SystemID*/
    RUN setSystemId IN hMessageHandler ("{&XmlMod}",  /*Nome do modulo */
                                        "{&XmlProdVersion}"). /* Versao do Programa*/

    /* Indica valor da chave prim ria da transa‡Æo */
    RUN setKeyFields IN hMessageHandler ("cond-pagto.cod-cond-pag",
                                         STRING(tt-cond-pag.cod-cond-pag)). 

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

        IF pTranAction = "ADD" OR pTranAction = "UPD" THEN DO:
		
            Find first param-global no-lock no-error.
            Find first empresa no-lock
                 where empresa.ep-codigo = param-global.empresa-prin no-error.

            Find first estabelec
                 where estabelec.cgc = empresa.cgc no-lock no-error.
            IF not avail estabelec then do:
                Find first estabelec
                     where estabelec.ep-codigo = empresa.ep-codigo no-lock no-error.
            End.

            Assign vSiteCode = estabelec.cod-estabel.

            /* Nà PRINCIPAL UPSERT */
            RUN addNode IN hGenXml (0,
                                    "Upsert",
                                    "",
                                    OUTPUT iFirstId).

            RUN addNodeDec IN hGenXml (iFirstId,
                                       "PaymentPlanCode",
                                       tt-cond-pag.cod-cond-pag,
                                       OUTPUT iId).

            RUN addNode IN hGenXml (iFirstId,
                                    "PaymentPlanDescription",
                                     tt-cond-pag.descricao,
                                     OUTPUT iId).

            RUN addNodeDec IN hGenXml (iFirstId,
                                       "DueCode",
                                        tt-cond-pag.cod-vencto,
                                       OUTPUT iId).

            RUN addNodeDec IN hGenXml (iFirstId,
                                       "BaseMonthDay",
                                       tt-cond-pag.dia-mes-base,
                                       OUTPUT iId).

             RUN addNodeDec IN hGenXml (iFirstId,
                                        "BaseWeekDay",
                                        tt-cond-pag.dia-sem-base,
                                        OUTPUT iId).

             RUN addNodeDec IN hGenXml (iFirstId,
                                        "DueMonthDay",
                                        tt-cond-pag.dia-mes-venc,
                                        OUTPUT iId).

             RUN addNodeDec IN hGenXml (iFirstId,
                                        "DueWeekDay",
                                         tt-cond-pag.dia-sem-venc,
                                         OUTPUT iId).

             RUN addNodeDec IN hGenXml (iFirstId,
                                        "AdvancedPaymentDayNumbers",
                                         tt-cond-pag.nr-dias-ante,
                                         OUTPUT iId).

             RUN addNodeDec IN hGenXml (iFirstId,
                                        "InvoiceWithDiscount",
                                         tt-cond-pag.nr-dupdes,
                                         OUTPUT iId).

             RUN addNodeDec IN hGenXml (iFirstId,
                                        "Discount",
                                         tt-cond-pag.per-des-pgan,
                                         OUTPUT iId).
             /* FinancialTable */
             RUN addNodeDec IN hGenXml (iFirstId,
                                        "FinancialTable",
                                        "",
                                         OUTPUT iFinTable).


                 RUN addNodeDec IN hGenXml (iFinTable,
                                            "FinancialTableNumber",
                                             tt-cond-pag.nr-tab-finan,
                                             OUTPUT iId).

                 RUN addNodeDec IN hGenXml (iFinTable,
                                             "FinancialIndexNumber",
                                             tt-cond-pag.nr-ind-finan,
                                             OUTPUT iId).

                 FIND tab-finan WHERE tab-finan.nr-tab-finan = tt-cond-pag.nr-tab-finan NO-LOCK NO-ERROR.
                 IF tt-cond-pag.nr-ind-finan <> 0 THEN
                    RUN addNodeDec IN hGenXml (iFinTable,
                                                "Tax",
                                                tab-finan.tab-ind-fin[tt-cond-pag.nr-ind-finan],
                                                OUTPUT iId).

             RUN addNodeDec IN hGenXml (iFirstId,
                                         "NumberOFTerms",
                                          tt-cond-pag.num-parcelas,
                                          OUTPUT iId).

           /* ListOfTerms */
           IF tt-cond-pag.num-parcelas <> 0 THEN DO:

               RUN addNodeDec IN hGenXml (iFirstId,
                                                "ListOfTerms",
                                                "",
                                                OUTPUT iListTerms).

               ASSIGN i-seq-parcela = 1.
               DO WHILE i-seq-parcela <= tt-cond-pag.num-parcelas :
                   IF tt-cond-pag.per-pg-dup[i-seq-parcela] <> 0 THEN DO:

                     RUN addNodeDec IN hGenXml (iListTerms,
                                                "Term",
                                                "",
                                                OUTPUT iTerms).

                     RUN addNodeDec IN hGenXml (iTerms,
                                                "TermSequence",
                                                i-seq-parcela,
                                                OUTPUT iId).

                     RUN addNodeDec IN hGenXml (iTerms,
                                                 "TermPayment",
                                                 tt-cond-pag.prazos[i-seq-parcela],
                                                 OUTPUT iId).

                     RUN addNode    IN hGenXml (iTerms,
                                                "TermDueCode",
                                                tt-cond-pag.cod-ven-par[i-seq-parcela],
                                                OUTPUT iId).

                     RUN addNodeDec IN hGenXml (iTerms,
                                                 "TermPaymentPercentage",
                                                 tt-cond-pag.per-pg-dup[i-seq-parcela],
                                                OUTPUT iId).
                    

                     
               END.
                ASSIGN i-seq-parcela = i-seq-parcela + 1.
               
           END.
          
           RUN addNodeDec IN hGenXml (iFirstId,
                                      "DaysOfAveragePaymentTerm",
                                      tt-cond-pag.qtd-dias-prazo-medio,
                                      OUTPUT iId).

           RUN addNodeDec IN hGenXml (iFirstId,
                                      "Status",
                                      tt-cond-pag.ind-situacao,
                                      OUTPUT iId).
									  
            RUN addNode IN hGenXml (iFirstId,
                                    "SiteCode",
                                    vSiteCode,
                                    OUTPUT iId).

        END.
        END.
        ELSE IF pTranAction = "DEL" THEN DO:

            /* Nà PRINCIPAL DELETE */
            RUN addNode IN hGenXml (0,
                                    "Delete",
                                    "",
                                    OUTPUT iFirstId).

            RUN addNodeDec IN hGenXml (iFirstId,
                                       "PaymentPlanCode",
                                        tt-cond-pag.cod-cond-pag,
                                        OUTPUT iId).

            RUN addNode IN hGenXml (iFirstId,
                                    "PaymentPlanDescription",
                                     tt-cond-pag.descricao,
                                     OUTPUT iId).          
       END.
    END.

    /* Obt‚m XMl na variavel handle */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).

    /* Passa handle do BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

    /* Elimina handle */
    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Envia XML para ControlBroker */                                       
    RUN sendMessage IN hMessageHandler (INPUT "vd2/PaymentPlan_204_000.xsd").

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
                 RowErrors.ErrorDescription = SUBSTRING(pErrorDesc,1,2000)
                 RowErrors.ErrorHelp        = SUBSTRING(pErrorDesc,1,20000)
                 i-cont-err                 = i-cont-err + 1.
     END.

     RETURN "NOK":U.
     LEAVE.

   END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




