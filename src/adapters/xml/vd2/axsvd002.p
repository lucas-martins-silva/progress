/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSVD002 2.00.00.003}  /*** 010003 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i axsvd002 MAX}
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
    File        : AXSVD002.p
    Purpose     : ENVIO NATUREZA DE OPERA€ÇO

    Syntax      :

    Description : ADAPTER DE ENVIO DE NATUREZA DE OPERA€ÇO
    Author(s)   : Eliza Fernandes Corrˆa - log1465
    CREATED     : 12/11/2003 10:00
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */

/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlTranName      FiscalOperation
&GLOBAL-DEFINE XmlTranVersion   204.000
&GLOBAL-DEFINE XmlProdName      EMS2
&GLOBAL-DEFINE XmlProdVersion   204
&GLOBAL-DEFINE XmlApp           VD2 
&GLOBAL-DEFINE XmlMod           MCD

def temp-table tt-natur-oper-eai no-undo like natur-oper.

/*Parƒmetros de entrada*/
DEF INPUT PARAM pTranAction  AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgName    AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgVersion AS CHAR    NO-UNDO.
DEF INPUT  PARAM TABLE FOR tt-natur-oper-eai.
/* Defini‡Æo temp-table RowErrors */
{method/dbotterr.i}
DEF OUTPUT PARAM TABLE FOR RowErrors. 

/* Vari veis Globais */
DEF VAR hGenXml          AS HANDLE NO-UNDO.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.

/* Variaveis da constru‡Æo do BusinessContent Utilizando APIXML */
DEF VAR iId                  AS INT NO-UNDO.
DEF VAR iFirstId             AS INT NO-UNDO. 
DEF VAR iBrazilianTaxes      AS INT NO-UNDO. 
DEF VAR iContribTax          AS INT NO-UNDO. 
DEF VAR iDistChannel         AS INT NO-UNDO.
DEF VAR iExpRev              AS INT NO-UNDO. 
DEF VAR iIndProdTax          AS INT NO-UNDO. 
DEF VAR iMessage             AS INT NO-UNDO. 
DEF VAR iServiceTax          AS INT NO-UNDO. 
DEF VAR iServicesProductsTax AS INT NO-UNDO. 
DEF VAR iProgramTax          AS INT NO-UNDO. 

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

DEF VAR h-boin245            AS HANDLE NO-UNDO.
DEF VAR i-ind-entreg-futur   AS INT    NO-UNDO.
DEF VAR i-oper-entrega-fatur AS INT    NO-UNDO.
DEF VAR l-ind-entfut         AS LOG    NO-UNDO.
DEF VAR l-ind-est-qtd        AS LOG    NO-UNDO.
DEF VAR d-des-red            AS DEC    NO-UNDO.

{include/i-epc200.i axsvd002}
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
{cdp/cdcfgdis.i}

/* Verifica se h  registros na temp-table */
FOR EACH tt-natur-oper-eai:

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
            WHERE  config-tip-operac.cod-tip-operac = 'axsvd002' NO-ERROR.
        IF  AVAIL config-tip-operac THEN DO:
            EMPTY TEMP-TABLE tt-variavel.
        
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper = 'ctransaction'
                   tt-variavel.cod-val-var  = pTranAction.
        
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper = 'cod-operacao'
                   tt-variavel.cod-val-var  = tt-natur-oper-eai.nat-operacao.
    
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper = 'cod-cfop'
                   tt-variavel.cod-val-var  = tt-natur-oper-eai.cod-cfop.
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
                                INPUT 'axsvd002',
                                INPUT TABLE tt-variavel,
                                OUTPUT i-cod-regra-utilizada,
                                OUTPUT TABLE tt-retorno,
                                OUTPUT TABLE RowErrors).
        
            IF  CAN-FIND(FIRST tt-retorno
                         WHERE tt-retorno.campo-retorno = 'axsvd002'
                         AND   tt-retorno.valor-retorno = 'no') THEN RETURN 'NOK'.
        
            for each tt-retorno:
                IF  tt-retorno.campo-retorno = 'cod-operacao' THEN assign tt-natur-oper-eai.nat-operacao = tt-retorno.valor-retorno.
                IF  tt-retorno.campo-retorno = 'cod-cfop'     THEN assign tt-natur-oper-eai.cod-cfop     = tt-retorno.valor-retorno.
            end.

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
    RUN setKeyFields IN hMessageHandler ("natur-oper.nat-operacao",
                                         STRING(tt-natur-oper-eai.nat-operacao)). 

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

        IF NOT VALID-HANDLE (h-boin245) THEN
            RUN inbo/boin245.p PERSISTEN SET h-boin245.

        IF pTranAction = "ADD" OR pTranAction = "UPD" THEN DO:

            /* Nà PRINCIPAL UPSERT */
            RUN addNode IN hGenXml (0,
                                     "Upsert",
                                     "",
                                     OUTPUT iFirstId).

            RUN addNode IN hGenXml (iFirstId,
                                     "FiscalOperation",
                                     tt-natur-oper-eai.nat-operacao,
                                     OUTPUT iId).

            RUN addNode IN hGenXml (iFirstId,
                                     "FiscalOperationDescription",
                                     tt-natur-oper-eai.denominacao,
                                     OUTPUT iId).

            RUN addNode IN hGenXml (iFirstId,
                                     "FiscalOperationType",
                                      STRING(tt-natur-oper-eai.tipo),
                                      OUTPUT iId).

            RUN addNodeLog IN hGenXml (iFirstId,
                                        "IsActive",
                                         tt-natur-oper-eai.nat-ativa,
                                         OUTPUT iId).

            RUN addNode IN hGenXml (iFirstId,
                                     "DocumentClass",
                                     STRING(tt-natur-oper-eai.especie-doc),
                                     OUTPUT iId).

            RUN addNode IN hGenXml (iFirstId,
                                     "MarketType",
                                     STRING(tt-natur-oper-eai.mercado),
                                     OUTPUT iId).
            /* DistributionChannel */
            RUN addNode IN hGenXml (iFirstId,
                                     "DistributionChannel",
                                     "",
                                     OUTPUT iDistChannel).

                RUN addNodeDec IN hGenXml (iDistChannel,
                                            "DistributionChannelCode",
                                             tt-natur-oper-eai.cod-canal-venda,
                                             OUTPUT iId).

                FIND FIRST canal-venda WHERE canal-venda.cod-canal-venda
                                             = tt-natur-oper-eai.cod-canal-venda NO-LOCK NO-ERROR.
                IF AVAIL canal-venda THEN
                    RUN addNode IN hGenXml (iDistChannel,
                                             "DistributionChannelDescription",
                                              canal-venda.descricao,
                                              OUTPUT iId).
             /* Message */
             FIND FIRST mensagem WHERE mensagem.cod-mensagem
                                 = tt-natur-oper-eai.cod-mensagem NO-LOCK NO-ERROR.
             IF AVAIL mensagem AND mensagem.texto-mensag <> "" THEN DO:

                    RUN addNode IN hGenXml (iFirstId,
                                     "Message",
                                     "",
                                     OUTPUT iMessage).

                    RUN addNode IN hGenXml (iMessage,
                                         "MessageID",
                                         tt-natur-oper-eai.cod-mensagem,
                                         OUTPUT iId).

                    RUN addNode IN hGenXml (iMessage,
                                             "MessageDescription",
                                              mensagem.texto-mensag,
                                              OUTPUT iId).
             END.
             IF pProgName <> "cd0609" THEN DO:
                 &if '{&BF_DIS_VERSAO_EMS}' >= '2.05' &then 
                    IF tt-natur-oper-eai.cod-cfop <> "" THEN
                     RUN addNode IN hGenXml (iFirstId,
                                             "TypeFormat",
                                              tt-natur-oper-eai.cod-cfop,
                                              OUTPUT iId).
                &else
                    IF substr(tt-natur-oper-eai.char-1,45,10) <> "" THEN
                     RUN addNode IN hGenXml (iFirstId,
                                             "TypeFormat",
                                              substr(tt-natur-oper-eai.char-1,45,10),
                                              OUTPUT iId).

                &endif

               RUN addNodeDec IN hGenXml (iFirstId,
                                          "TaxManagementDocumentModel",
                                           tt-natur-oper-eai.cd-situacao,
                                          OUTPUT iId).
             END.

            RUN addNode IN hGenXml (iFirstId,
                                    "DocumentType",
                                    tt-natur-oper-eai.cod-esp,
                                    OUTPUT iId).
            /* ExpenseRevenue */
            RUN addNode IN hGenXml (iFirstId,
                                    "ExpenseRevenue",
                                    "",
                                    OUTPUT iExpRev).

               RUN addNodeDec IN hGenXml (iExpRev,
                                          "ExpenseRevenueCode",
                                          tt-natur-oper-eai.tp-rec-desp,
                                          OUTPUT iId).

               FIND FIRST tipo-rec-desp WHERE tipo-rec-desp.tp-codigo
                                        = tt-natur-oper-eai.tp-rec-desp NO-LOCK NO-ERROR.
               IF AVAIL tipo-rec-desp THEN  DO:
                   RUN addNode IN hGenXml (iExpRev,
                                            "ExpenseRevenueDescription",
                                            tipo-rec.descricao,
                                            OUTPUT iId).

                   RUN addNode IN hGenXml (iExpRev,
                                            "ExpenseRevenueType",
                                            tipo-rec.tipo,
                                            OUTPUT iId).
               END.

            RUN addNodeLog IN hGenXml (iFirstId,
                                       "IsTransferOperation",
                                        tt-natur-oper-eai.transf,
                                        OUTPUT iId).

            IF pProgName <> "cd0609" THEN DO:
               RUN addNodeLog IN hGenXml (iFirstId,
                                            "IsOwnDocument",
                                            IF tt-natur-oper-eai.int-1 = 1 THEN
                                                TRUE 
                                            ELSE 
                                                FALSE,
                                            OUTPUT iId).

               RUN addNodeLog IN hGenXml (iFirstId,
                                           "IsTradeDocument",
                                            tt-natur-oper-eai.log-2,
                                            OUTPUT iId).
            END.

            RUN addNodeLog IN hGenXml (iFirstId,
                                       "IsAssetSale",
                                        tt-natur-oper-eai.venda-ativo,
                                        OUTPUT iId).

            IF pProgName <> "cd0609" THEN DO:
              RUN addNodeLog IN hGenXml (iFirstId,
                                       "IsMoveSales",
                                        IF tt-natur-oper-eai.int-2 = 1 THEN
                                            TRUE 
                                        ELSE 
                                            FALSE,
                                        OUTPUT iId).

             RUN addNodeLog IN hGenXml (iFirstId,
                                       "IsTriangularTransaction",
                                        tt-natur-oper-eai.log-oper-triang,
                                        OUTPUT iId).
            END.

            RUN addNodeLog IN hGenXml (iFirstId,
                                       "IsBonusOperationType",
                                        tt-natur-oper-eai.log-natureza-bonif,
                                        OUTPUT iId).

            IF  tt-natur-oper-eai.cod-natur-oper-bonif <> "" THEN
             RUN addNode IN hGenXml (iFirstId,
                                     "BonusOperationType",
                                     tt-natur-oper-eai.cod-natur-oper-bonif,
                                     OUTPUT iId).

            RUN addNode IN hGenXml (iFirstId,
                                    "ThirdPartyOperationType",
                                    tt-natur-oper-eai.tp-oper-terc,
                                    OUTPUT iId).

            IF pProgName <> "cd0609" THEN DO:
             RUN addNode IN hGenXml (iFirstId,
                                     "PurchaseType",
                                      tt-natur-oper-eai.tipo-compra,
                                      OUTPUT iId).

            /* Opera‡äes de entrega futura/faturamento antecipado */
               assign i-ind-entreg-futur = if  substr(tt-natur-oper-eai.char-1,1,5) = "1":U
                                                then 1
                                                else 2
                    l-ind-entfut       = tt-natur-oper-eai.ind-entfut
                    l-ind-est-qtd      = tt-natur-oper-eai.ind-est-qtd.

                run convertOperationType in h-boin245 (input 2,
                                                       input-output i-oper-entrega-fatur,
                                                       input-output i-ind-entreg-futur,
                                                       input-output l-ind-entfut,
                                                       input-output l-ind-est-qtd).

                      RUN addNodeDec IN hGenXml (iFirstId,
                                                  "FutureDeliveryOperation",
                                                   i-oper-entrega-fatur,
                                                   OUTPUT iId).
            END.

            RUN addNodeLog IN hGenXml (iFirstId,
                                       "IsInvoiceGenerator",
                                       tt-natur-oper-eai.emite-duplic,
                                       OUTPUT iId).

           IF pProgName <> "cd0609" THEN DO:
            /* BrazilianTaxes */
            RUN addNode IN hGenXml (iFirstId,
                                    "BrazilianTaxes",
                                     "",
                                     OUTPUT iBrazilianTaxes).

            /* IndustralizedProductType */
            RUN addNode IN hGenXml (iBrazilianTaxes,
                                    "IndustrializedProductTax",
                                     "",
                                     OUTPUT iIndProdTax).

                RUN addNode IN hGenXml (iIndProdTax,
                                            "BaseType",
                                             substr(tt-natur-oper-eai.char-2,11,1),
                                             OUTPUT iId).

                RUN addNodeLog IN hGenXml (iIndProdTax,
                                            "IsFreightIncludedInBaseTax",
                                             IF substr(tt-natur-oper-eai.char-2,6,5) = "1" THEN
                                                 TRUE
                                             ELSE
                                                 FALSE,
                                             OUTPUT iId).

                IF tt-natur-oper-eai.cd-vinc-ipi <> "" AND tt-natur-oper-eai.cd-vinc-ipi <> ? THEN 
                    RUN addNode IN hGenXml (iIndProdTax,
                                             "LinkCode",
                                              tt-natur-oper-eai.cd-vinc-ipi,
                                              OUTPUT iId).

                RUN addNode IN hGenXml (iIndProdTax,
                                        "TaxCode",
                                         tt-natur-oper-eai.cd-trib-ipi,
                                         OUTPUT iId).

                RUN addNodeDec IN hGenXml (iIndProdTax,
                                           "TaxReductionPercentage",
                                            tt-natur-oper-eai.perc-red-ipi,
                                            OUTPUT iId).

                RUN addNodeLog IN hGenXml (iIndProdTax,
                                            "IsTaxIncludedInSalesTaxColumn",
                                             IF substr(tt-natur-oper-eai.char-2,1,5) = "1" THEN
                                                TRUE
                                             ELSE
                                                FALSE,
                                             OUTPUT iId).

                RUN addNodeLog IN hGenXml (iIndProdTax,
                                               "IsTaxIncludedInSalesTaxOtherColumn",
                                                tt-natur-oper-eai.ipi-icm-out,
                                                OUTPUT iId).

                RUN addNodeLog IN hGenXml (iIndProdTax,
                                              "IsTaxOtherIncludedInInvoiceTotal",
                                              IF substr(tt-natur-oper-eai.char-2,16,5) = "1" THEN
                                                  TRUE
                                              ELSE
                                                  FALSE,
                                              OUTPUT iId).

                RUN addNodeLog IN hGenXml (iIndProdTax,
                                           "IsTaxOtherIncludedInSubstitutionBase",
                                            IF substr(tt-natur-oper-eai.char-2,46,5) = "1" THEN
                                                TRUE
                                            ELSE
                                                FALSE,
                                            OUTPUT iId).

                RUN addNodeLog IN hGenXml (iIndProdTax,
                                           "IsTaxPostedInFreightWayBills",
                                            tt-natur-oper-eai.usa-pick,
                                           OUTPUT iId).

                RUN addNodeLog IN hGenXml (iIndProdTax,
                                            "IsTaxVoidable",
                                             tt-natur-oper-eai.manut-ipi, 
                                             OUTPUT iId).
            /* ServiceTax */
            RUN addNode IN hGenXml (iBrazilianTaxes,
                                    "ServiceTax",
                                    "",
                                    OUTPUT iServiceTax).

                      RUN addNodeDec IN hGenXml (iServiceTax,
                                               "BaseType",
                                               dec(SUBSTR(tt-natur-oper-eai.char-2,21,5)),
                                               OUTPUT iId).

                      RUN addNodeDec IN hGenXml (iServiceTax,
                                                    "TaxCode",
                                                     tt-natur-oper-eai.cd-trib-iss,
                                                     OUTPUT iId).

                      IF tt-natur-oper-eai.perc-red-iss <> 0 THEN
                        RUN addNodeDec IN hGenXml (iServiceTax,
                                                    "ServiceTaxReductionPercentage",
                                                     tt-natur-oper-eai.perc-red-iss,
                                                     OUTPUT iId).

                   IF tt-natur-oper-eai.nat-vinculada <> "" AND tt-natur-oper-eai.nat-vinculada <> ? THEN
                      RUN addNode IN hGenXml (iServiceTax,
                                               "LinkedFiscalOperation",
                                               tt-natur-oper-eai.nat-vinculada,
                                               OUTPUT iId).
            /* ServicesAndProductsCirculationTax */
            RUN addNode IN hGenXml (iBrazilianTaxes,
                                    "ServicesAndProductsCirculationTax",
                                    "",
                                    OUTPUT iServicesProductsTax).

                   RUN addNode IN hGenXml (iServicesProductsTax,
                                            "TaxCode",
                                            tt-natur-oper-eai.cd-trib-icm,
                                            OUTPUT iId).

                   RUN addNodeDec IN hGenXml (iServicesProductsTax,
                                               "Percentage",
                                               tt-natur-oper-eai.aliquota-icm,
                                               OUTPUT iId).

                   RUN addNodeDec IN hGenXml (iServicesProductsTax,
                                               "SupplementPercentage",
                                               tt-natur-oper-eai.aliq-icm-com,
                                               OUTPUT iId).

                   RUN addNode IN hGenXml (iServicesProductsTax,
                                            "BaseType",
                                            tt-natur-oper-eai.merc-base-icms,
                                            OUTPUT iId).

                   RUN addNode IN hGenXml (iServicesProductsTax,
                                            "BaseTypeForTaxCalculation",
                                            tt-natur-oper-eai.tp-base-icm,
                                            OUTPUT iId).

                   RUN addNodeLog IN hGenXml (iServicesProductsTax,
                                               "IsTaxVoidable",
                                               tt-natur-oper-eai.manut-icm,
                                               OUTPUT iId).

                   RUN addNodeDec IN hGenXml (iServicesProductsTax,
                                               "DiscountPercentage",
                                               tt-natur-oper-eai.per-des-icms,
                                               OUTPUT iId).

                   RUN addNodeDec IN hGenXml (iServicesProductsTax,
                                               "FreeZoneDiscountPercentage",
                                               substr(tt-natur-oper-eai.char-2,66,5),
                                               OUTPUT iId).

                   RUN addNodeDec IN hGenXml (iServicesProductsTax,
                                               "TaxReduction",
                                                tt-natur-oper-eai.perc-red-icm,
                                                OUTPUT iId).

                    IF tt-natur-oper-eai.dec-2 = 1 THEN
                        ASSIGN d-des-red = 1.
                    ELSE  IF tt-natur-oper-eai.dec-2 = 0 OR tt-natur-oper-eai.dec-2 = 2 THEN
                        ASSIGN d-des-red = 2.

                    RUN addNodeDec IN hGenXml (iServicesProductsTax,
                                                "ReductionDestination",
                                                 d-des-red,
                                                 OUTPUT iId).

                   RUN addNodeLog IN hGenXml (iServicesProductsTax,
                                               "IsTaxReplacement",
                                               tt-natur-oper-eai.subs-trib,
                                               OUTPUT iId).

                   RUN addNodeDec IN hGenXml (iServicesProductsTax,
                                               "TaxReplacementPercentage",
                                               tt-natur-oper-eai.icms-subs-trib,
                                               OUTPUT iId).

                   RUN addNodeLog IN hGenXml (iServicesProductsTax,
                                               "IsTaxReplacementItemAlreadyCollected",
                                               tt-natur-oper-eai.ind-it-icms,
                                               OUTPUT iId).

                   RUN addNodeLog IN hGenXml (iServicesProductsTax,
                                               "IsTaxOtherValueReplacement",
                                               IF substr(tt-natur-oper-eai.char-2,51,5) = "1" THEN
                                                   TRUE
                                               ELSE
                                                   FALSE,
                                               OUTPUT iId).

                   RUN addNodeLog IN hGenXml (iServicesProductsTax,
                                               "IsTaxReplacementCreditGenerator",
                                               IF substr(tt-natur-oper-eai.char-2,56,5) = "1" THEN
                                                   TRUE
                                               ELSE
                                                   FALSE,
                                               OUTPUT iId).

                   RUN addNodeLog IN hGenXml (iServicesProductsTax,
                                               "IsDecreaseFreightTotalReplacement",
                                               tt-natur-oper-eai.usa-nota-ent,
                                               OUTPUT iId).

                   RUN addNodeLog IN hGenXml (iServicesProductsTax,
                                               "IsEndUser",
                                               tt-natur-oper-eai.consum-final,
                                               OUTPUT iId).

                   RUN addNodeLog IN hGenXml (iServicesProductsTax,
                                               "IsTaxItemSuspended",
                                               tt-natur-oper-eai.ind-it-sub-dif,
                                               OUTPUT iId).

                   RUN addNodeLog IN hGenXml (iServicesProductsTax,
                                               "IsTaxItemDiffered",
                                               IF tt-natur-oper-eai.ind-it-sub-dif = ? THEN
                                                   TRUE
                                               ELSE
                                                   FALSE,
                                               OUTPUT iId).

                    RUN addNodeLog IN hGenXml (iServicesProductsTax,
                                                "IsNotApplied",
                                                tt-natur-oper-eai.ind-tipo-vat,
                                                OUTPUT iId).

                   IF tt-natur-oper-eai.credito-ciap THEN
                    RUN addNodeLog IN hGenXml (iServicesProductsTax,
                                                "IsCIAPCreditMaintenance",
                                                tt-natur-oper-eai.credito-ciap,
                                                OUTPUT iId).

                   IF tt-natur-oper-eai.log-acum-ciap THEN
                    RUN addNodeLog IN hGenXml (iServicesProductsTax,
                                                "IsInvoiceConsideredForCIAP",
                                                tt-natur-oper-eai.log-acum-ciap,
                                                OUTPUT iId).


            RUN addNodeLog IN hGenXml (iBrazilianTaxes,
                                        "IsIncomeTaxRestrainedOnSource",
                                        tt-natur-oper-eai.ind-imprenda,
                                        OUTPUT iId).

            RUN addNodeLog IN hGenXml (iBrazilianTaxes,
                                        "IsSocialSecurityTaxRestrainedOnSource",
                                        IF substr(tt-natur-oper-eai.char-2,71,5) = "1" THEN
                                            TRUE
                                        ELSE
                                            FALSE,
                                        OUTPUT iId).

            IF substr(tt-natur-oper-eai.char-1,10,2) <> " " AND
               substr(tt-natur-oper-eai.char-1,10,2) <> "00" THEN
                RUN addNodeDec IN hGenXml (iBrazilianTaxes,
                                            "TaxationCode",
                                            substr(tt-natur-oper-eai.char-1,10,2),
                                            OUTPUT iId).

            RUN addNodeDec IN hGenXml (iBrazilianTaxes,
                                        "SocialSecurityTaxPercentage",
                                        substr(tt-natur-oper-eai.char-1,40,5),
                                        OUTPUT iId).

            /* SocialIntegrationProgramTax */
            RUN addNode IN hGenXml (iBrazilianTaxes,
                                     "SocialIntegrationProgramTax",
                                     "",
                                     OUTPUT iProgramTax).

                    RUN addNodeDec IN hGenXml (iProgramTax,
                                                "InternalPercentage",
                                                tt-natur-oper-eai.perc-PIS[1],
                                                OUTPUT iId).

                    RUN addNodeDec IN hGenXml (iProgramTax,
                                                "ExternalPercentage",
                                                tt-natur-oper-eai.perc-PIS[2],
                                                OUTPUT iId).

                    IF substr(tt-natur-oper-eai.char-1,86,1) <> "" AND
                       substr(tt-natur-oper-eai.char-1,86,1) <> "0" THEN
                       RUN addNode IN hGenXml (iProgramTax,
                                                 "TaxationCode",
                                                 substr(tt-natur-oper-eai.char-1,86,1),
                                                 OUTPUT iId).

                    &if '{&BF_DIS_VERSAO_EMS}' >= '2.06' &then 
                     IF tt-natur-oper-eai.cdd-perc-retenc-pis <> 0 THEN
                      RUN addNodeDec IN hGenXml (iProgramTax,
                                                 "TaxRetentionPercentage",
                                                  tt-natur-oper-eai.cdd-perc-retenc-pis,
                                                  OUTPUT iId).
                    &else
                     IF dec(SUBSTR(tt-natur-oper-eai.char-2,110,5)) <> 0 THEN
                      RUN addNodeDec IN hGenXml (iProgramTax,
                                                 "TaxRetentionPercentage",
                                                 dec(substring(tt-natur-oper-eai.char-2,110,5)),
                                                 OUTPUT iId).

                    &endif

            /* SocialSecurityContributionTax */
            RUN addNodeDec IN hGenXml (iBrazilianTaxes,
                                        "SocialSecurityContributionTax",
                                        "",
                                        OUTPUT iContribTax).

                RUN addNodeDec IN hGenXml (iContribTax,
                                            "InternalPercentage",
                                            tt-natur-oper-eai.per-fin-soc[1],
                                            OUTPUT iId).

                RUN addNodeDec IN hGenXml (iContribTax,
                                            "ExternalPercentage",
                                            tt-natur-oper-eai.per-fin-soc[2],
                                            OUTPUT iId).
               RUN addNode IN hGenXml (iContribTax,
                                         "TaxationCode",
                                         substr(tt-natur-oper-eai.char-1,87,1),
                                         OUTPUT iId).

               &if '{&BF_DIS_VERSAO_EMS}' >= '2.06' &then 
                IF tt-natur-oper-eai.cdd-perc-retenc-cofins <> 0 THEN
                  RUN addNodeDec IN hGenXml (iContribTax,
                                              "TaxRetentionPercentage",
                                               tt-natur-oper-eai.cdd-perc-retenc-cofins,
                                               OUTPUT iId).
               &else
                 IF dec(substr(tt-natur-oper-eai.char-2,115,5)) <> 0 THEN
                  RUN addNodeDec IN hGenXml (iContribTax,
                                              "TaxRetentionPercentage",
                                               dec(substring(tt-natur-oper-eai.char-2,115,5)),
                                               OUTPUT iId).

               &endif

            &if '{&BF_DIS_VERSAO_EMS}' >= '2.06' &then 
                IF tt-natur-oper-eai.cdd-perc-retenc-csll <> 0 THEN
                  RUN addNodeDec IN hGenXml (iBrazilianTaxes,
                                              "SocialContributionOverTheNetProfitsTaxRetentionPercentage",
                                               tt-natur-oper-eai.cdd-perc-retenc-csll,
                                               OUTPUT iId).
            &else
                 IF dec(substring(tt-natur-oper-eai.char-2,105,5)) <> 0 THEN
                  RUN addNodeDec IN hGenXml (iBrazilianTaxes,
                                              "SocialContributionOverTheNetProfitsTaxRetentionPercentage",
                                               dec(substring(tt-natur-oper-eai.char-2,105,5)),
                                               OUTPUT iId).

            &endif

           END.

        IF tt-natur-oper-eai.narrativa <> "" THEN
                RUN addNode IN hGenXml (iFirstId,
                                        "Text",
                                         tt-natur-oper-eai.narrativa,
                                         OUTPUT iId).


        END.
        ELSE IF pTranAction = "DEL" THEN DO:

            /* Nà PRINCIPAL DELETE */
            RUN addNode IN hGenXml (0,
                                    "Delete",
                                    "",
                                    OUTPUT iFirstId).

            RUN addNode IN hGenXml (iFirstId,
                                      "FiscalOperation",
                                       tt-natur-oper-eai.nat-operacao,
                                       OUTPUT iId).

            RUN addNode IN hGenXml (iFirstId,
                                    "FiscalOperationDescription",
                                     tt-natur-oper-eai.denominacao,
                                     OUTPUT iId).          
        END.

        DELETE PROCEDURE h-boin245.
    END.

    /* Obt‚m XMl na variavel handle */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).

    /* Passa handle do BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

    /* Elimina handle */
    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Envia XML para ControlBroker */                                       
    RUN sendMessage IN hMessageHandler (INPUT "vd2/FiscalOperation_204_000.xsd").

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

