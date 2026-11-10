/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSMA003 2.00.00.023 } /*** 010023 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i axsma003 MAX}
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
    File        : AXSMA004.p
    Purpose     : ADAPTER DE ENVIO DE ITENS

    Syntax      :

    Description : ADAPTER DE ENVIO DE ITENS
    CREATEd     : 29/12/2003 10:00
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */

/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlTranName      Item
&GLOBAL-DEFINE XmlTranVersion   204.000
&GLOBAL-DEFINE XmlProdName      EMS2
&GLOBAL-DEFINE XmlProdVersion   204
&GLOBAL-DEFINE XmlApp           MA2 
&GLOBAL-DEFINE XmlMod           ENP

{cdp/cdcfgdis.i}

/** Unifica‡Æo de conceito **/
{cdp/cdunif001.i}

DEFINE TEMP-TABLE tt-item-eai NO-UNDO LIKE ITEM.


/* Defini‡Æo temp-table RowErrors */
{cdp/cd9043.i}
{cdp/cd9043.i1}

/*Parƒmetros de entrada*/
DEF INPUT PARAM pTranAction  AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgName    AS CHAR    NO-UNDO.
DEF INPUT PARAM pProgVersion AS CHAR    NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-item-eai.
DEF OUTPUT PARAM TABLE FOR RowErrors.

/* Vari veis Globais */
DEF VAR hGenXml          AS HANDLE NO-UNDO.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.

/* Variaveis da constru‡Æo do BusinessContent Utilizando APIXML */
DEF VAR iId         AS INT NO-UNDO.
DEF VAR iFirstId    AS INT NO-UNDO. 
DEF VAR iIdFamily   AS INT NO-UNDO.
DEF VAR iIdInventoryGroup AS INT NO-UNDO.
DEF VAR iIdUnitOfMeasure  AS INT NO-UNDO.
DEF VAR iIdDefaultSite    AS INT NO-UNDO.
DEF VAR iIdCommercial     AS INT NO-UNDO.

/* Vari veis para armazenar valores da inicializa‡Æo do loalMessageHandler */
DEF VAR hMessageHandler AS HANDLE NO-UNDO.
DEF VAR cReturnValue    AS CHAR   NO-UNDO.

find first param-global no-lock no-error.



/*Vari veis locais*/
DEF VAR pSendSuccess  AS LOG INITIAL YES NO-UNDO.
DEF VAR lCREATEMsg    AS LOG             NO-UNDO.
DEF VAR pTotalErrors  AS INT             NO-UNDO.
DEF VAR pErrorNumber  AS INT             NO-UNDO.
DEF VAR pErrorType    AS CHAR            NO-UNDO.
DEF VAR pErrorDesc    AS CHAR            NO-UNDO.
DEF VAR iCount        AS INT             NO-UNDO.
DEF VAR i-cont-err    AS INT             NO-UNDO.
DEF VAR l-logical     AS LOG             NO-UNDO.
DEFINE VARIABLE h-boin172      AS HANDLE    NO-UNDO.
DEFINE VARIABLE de-preco-medio AS DECIMAL   NO-UNDO.

{include/i-epc200.i axsma003}

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
{cdp/cdcfgman.i} 

/* Verifica se h  registros na temp-table */
IF NOT CAN-FIND(FIRST tt-item-eai) THEN DO:

    {utp/ut-liter.i Item_para_Integra‡Æo_EAI * r}
    run piCriaErro (5561,
                    'EMS':U, 
                    TRIM(return-value)).
     RETURN "NOK":U.
     LEAVE.
END.

FOR EACH tt-item-eai NO-LOCK:

    /* Verifica se MessageHandler.p está  na mem¢ria */
    {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

    /* Verifica se o MessageHandler foi executado corretamente */
    IF cReturnValue <> "OK":U THEN DO:
         IF cReturnValue <> ? AND cReturnValue <> " " THEN DO:
             run piCriaErro (17006,
                             'EMS':U, 
                             cReturnValue).
                 RETURN "NOK":U.
                 LEAVE.
         END.
    END.

    /* Verifica se h  programas inscritos */
    RUN isSubscribed IN hMessageHandler (INPUT "{&XmlProdName}",
                                         INPUT "{&XmlApp}",
                                         INPUT "{&XmlTranName}",
                                         INPUT "{&XmlTranVersion}",
                                         INPUT "Item":U,
                                         INPUT pTranAction,
                                         OUTPUT lCREATEMsg).

   /*Verifica se a transa‡Æo ‚ assinada*/
      IF NOT lCREATEMsg THEN
         RETURN "OK":U.


    /*---[ integra‡Æo EMSxNeogrid ]---------------------------------------------------------------------------------*/
    &IF '{&BF_DIS_VERSAO_EMS}' >= '2.062' &THEN
        FIND FIRST config-tip-operac NO-LOCK
            WHERE  config-tip-operac.cod-tip-operac = 'axsma003' NO-ERROR.
        IF  AVAIL config-tip-operac THEN DO:
            EMPTY TEMP-TABLE tt-variavel.
        
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper = 'ctransaction'
                   tt-variavel.cod-val-var  = pTranAction.
        
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper = 'it-codigo'
                   tt-variavel.cod-val-var  = tt-item-eai.it-codigo.

            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper = 'fm-codigo'
                   tt-variavel.cod-val-var  = tt-item-eai.fm-codigo.
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
                                INPUT 'axsma003',
                                INPUT TABLE tt-variavel,
                                OUTPUT i-cod-regra-utilizada,
                                OUTPUT TABLE tt-retorno,
                                OUTPUT TABLE RowErrors).
        
            IF  CAN-FIND(FIRST tt-retorno
                         WHERE tt-retorno.campo-retorno = 'axsma003'
                         AND   tt-retorno.valor-retorno = 'no') THEN RETURN 'NOK'.
        
            for each tt-retorno:
                IF  tt-retorno.campo-retorno = "it-codigo" THEN ASSIGN tt-item-eai.it-codigo = tt-retorno.valor-retorno.
                IF  tt-retorno.campo-retorno = "fm-codigo" THEN ASSIGN tt-item-eai.fm-codigo = tt-retorno.valor-retorno.
            end. /* for each tt-retorno: */

            IF  CAN-FIND(FIRST RowErrors) THEN DO:
                FOR EACH RowErrors:
                    run piCriaErro (RowErrors.ErrorNumber,
                                    'EMS':U, 
                                    RowErrors.ErrorDescription)).
                END.
                RETURN 'NOK'.
            END.
        END.
    &ENDIF
    /*---------------------------------------------------------------------------------[ integra‡Æo EMSxNeogrid ]---*/

      /* Preenche o valor do elemento Comment de TransactionId */
    RUN setTransInfoComment IN hMessageHandler ("Program:" + pProgName + "-" +
                                                "Version:" + pProgVersion). 

    /*Seta SystemID*/
    RUN setSystemId IN hMessageHandler ( "{&pXmlMod}" ,       /* Nome do modulo */
                                        "{&XmlProdVersion}"). /* Versao do Programa */

    /* Indica valor da chave prim ria da transa‡Æo */
    RUN setKeyFields IN hMessageHandler ("item.it-codigo",
                                         STRING(tt-item-eai.it-codigo)). 

    /* Seta a empresa e o estabelecimento */
    RUN setCompanyId IN hMessageHandler (STRING(v_cdn_empres_usuar), ""). 

    /* Verifica se API est  na mem¢ria */
    {xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}

    /* Verifica se o ut-genxml foi executado corretamente */
    IF cReturnValue <> "OK":U THEN DO:
         IF cReturnValue <> ? AND cReturnValue <> "" THEN DO:
             run piCriaErro (17006,
                             'EMS':U, 
                             cReturnValue).
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

            /* Nà PRINCIPAL UPSERT */
            RUN addNode IN hGenXml (0,
                                    "Upsert",
                                    "",
                                    OUTPUT iFirstId).

            RUN addNode IN hGenXml (iFirstId, "ItemCode":U, tt-item-eai.it-codigo, OUTPUT iId).
            RUN addNode IN hGenXml (iFirstId,"ItemDescription":U, SUBSTRING(tt-item-eai.desc-item, 1,60), OUTPUT iId).
            RUN addNode IN hGenXml (iFirstId,"ItemComment":U, tt-item-eai.narrativa, OUTPUT iId).

            &IF DEFINED (bf_man_206) &THEN 
                RUN addNode IN hGenXml (iFirstId, "ItemClassification":U, STRING(tt-item-eai.idi-classif-item), OUTPUT iId).
            &ELSE 

              FIND FIRST ITEM WHERE ITEM.it-codigo = tt-item-eai.it-codigo NO-LOCK NO-ERROR.
              IF AVAIL ITEM THEN DO:  
                 IF SUBSTRING(item.char-1,19,1) <> "" THEN
                    RUN addNode IN hGenXml (iFirstId, "ItemClassification":U, SUBSTRING(item.char-1,19,1), OUTPUT iId).  
              END.
            &ENDIF

            /* Adiciona informacoes da Familia de Materiais */
            RUN addNode IN hGenXml (iFirstId, "MaterialFamily":U, "", OUTPUT iId).
            RUN addNode IN hGenXml (iId, "MaterialFamilyCode":U, tt-item-eai.fm-codigo, OUTPUT iIdFamily).
            FIND FIRST familia WHERE familia.fm-codigo = tt-item-eai.fm-codigo NO-LOCK NO-ERROR.
            IF AVAIL familia THEN DO:
                RUN addNode IN hGenXml (iId, "MaterialFamilyDescription":U, SUBSTRING(familia.descricao, 1,30), OUTPUT iIdFamily).
                &IF DEFINED (bf_man_206) &THEN 
                    RUN addNode IN hGenXml (iId, "FamilyClassification":U, STRING(familia.idi-classif-item), OUTPUT iIdFamily).
                &ELSE 
                    RUN addNode IN hGenXml (iId, "FamilyClassification":U, SUBSTRING(familia.char-1,19,1), OUTPUT iIdFamily).  
                &ENDIF
            END.
            RUN addNodeDec IN hGenXml (iId, "MaterialFamilyConversionFactor":U, tt-item-eai.ft-conversao, OUTPUT iIdFamily).
            RUN addNodeDec IN hGenXml (iId, "DecimalsMaterialFamilyConversionFactor":U, tt-item-eai.dec-ftcon, OUTPUT iIdFamily).

            /* Adiciona informacoes do Grupo de Estoque */
            RUN addNode IN hGenXml (iFirstId, "InventoryGroup":U, "", OUTPUT iId).
            RUN addNodeDec IN hGenXml (iId, "InventoryGroupCode":U, tt-item-eai.ge-codigo, OUTPUT iIdInventoryGroup).
            FIND FIRST grup-estoque WHERE grup-estoque.ge-codigo = tt-item-eai.ge-codigo NO-LOCK NO-ERROR.
            IF AVAIL grup-estoque THEN
            RUN addNode IN hGenXml (iId, "InventoryGroupDescription":U, grup-estoque.descricao, OUTPUT iIdInventoryGroup).

            /* Adiciona informacoes da Unidade de Medida */
            FIND FIRST tab-unidade WHERE tab-unidade.un = tt-item-eai.un NO-LOCK NO-ERROR.
            IF AVAIL tab-unidade THEN DO:
                ASSIGN tt-item-eai.un = tab-unidade.un.
            END.

            RUN addNode IN hGenXml (iFirstId, "UnitOfMeasure":U, "", OUTPUT iId).
            RUN addNode IN hGenXml (iId, "UnitOfMeasureCode":U, tt-item-eai.un, OUTPUT iIdUnitOfMeasure).
            FIND FIRST tab-unidade WHERE tab-unidade.un = tt-item-eai.un  NO-LOCK NO-ERROR. 
            IF AVAIL tab-unidade THEN
               RUN addNode IN hGenXml (iId, "UnitOfMeasureDescription":U, SUBSTRING(tab-unidade.descricao,1,15), OUTPUT iIdUnitOfMeasure).

            /* Adiciona informa‡oes da Grupo de Estoque */
            RUN addNode IN hGenXml (iFirstId, "DefaultSite":U, "", OUTPUT iId).
            RUN addNode IN hGenXml (iId, "DefaultSiteCode":U, tt-item-eai.cod-estabel, OUTPUT iIdDefaultSite).
            FIND FIRST estabelec WHERE estabelec.cod-estabel = tt-item-eai.cod-estabel  NO-LOCK NO-ERROR. 
            IF AVAIL estabelec THEN
               RUN addNode IN hGenXml (iId, "DefaultSiteDescription":U, estabelec.nome, OUTPUT iIdDefaultSite).

            RUN addNodeDate IN hGenXml (iFirstId, "DateAddition":U, tt-item-eai.data-implant, OUTPUT iId).
            RUN addNodeDate IN hGenXml (iFirstId, "ReleaseDate":U, tt-item-eai.data-liberac, OUTPUT iId).            
            RUN addNodeDec  IN hGenXml (iFirstId, "ItemStatus":U, tt-item-eai.cod-obsoleto, OUTPUT iId).
            RUN addNodeLog  IN hGenXml (iFirstId, "IsIssueInventory":U, tt-item-eai.baixa-estoq, OUTPUT iId).

            /* Adiciona informa‡oes da Familia Comercial */
            RUN addNode IN hGenXml (iFirstId, "CommercialFamily":U, "", OUTPUT iId).           
            RUN addNode IN hGenXml (iId, "CommercialFamilyCode":U, tt-item-eai.fm-cod-com, OUTPUT iIdCommercial).
            FIND FIRST fam-comerc WHERE fam-comerc.fm-cod-com = tt-item-eai.fm-cod-com NO-LOCK NO-ERROR.
            IF AVAIL fam-comerc THEN
            RUN addNode IN hGenXml (iId, "CommercialFamilyDescription":U, fam-comerc.descricao, OUTPUT iIdCommercial).
            RUN addNodeDec IN hGenXml (iId, "CommercialFamilyConversionFactor":U, tt-item-eai.ft-conv-fmcoml, OUTPUT iIdCommercial).

            RUN addNode IN hGenXml (iFirstId, "SupplementaryCode":U, tt-item-eai.codigo-refer, OUTPUT iId).
            
            {adapters/xml/ma2/axsma003.i02} /*Include Manufatura*/

            {adapters/xml/ma2/axsma003.i01} /*Include Logistica*/

      END.
        ELSE IF pTranAction = "DEL" THEN DO:
            /* no principal delete */
            RUN addNode IN hGenXml (0, "Delete":U, "", OUTPUT iFirstId).
            RUN addNode IN hGenXml (iFirstId, "ItemCode":U, tt-item-eai.it-codigo, OUTPUT iId).
            RUN addNode IN hGenXml (iFirstId, "ItemDescription":U,tt-item-eai.desc-item, OUTPUT iId).
            RUN addNode IN hGenXml (iFirstId, "ItemComment":U, tt-item-eai.narrativa, OUTPUT iId).
       END.

    END.

    /* Obt‚m XMl na variavel handle */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).
    /*hBusinessContent:SAVE("FILE", "C:~\Item.xml").*/

    /* Passa handle do BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

    /* Elimina handle */
    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Envia XML para ControlBroker */
    RUN sendMessage IN hMessageHandler (INPUT "ma2/Item_204_001.xsd").
    
    /*Verifica se a mensagem foi enviada com sucesso */
    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess,
                                            OUTPUT pTotalErrors).

    IF NOT pSendSuccess THEN DO:
      REPEAT iCount = 1 TO pTotalErrors:
          RUN getError IN hMessageHandler (iCount,
                                             OUTPUT pErrorNumber,
                                             OUTPUT pErrorType,
                                             OUTPUT pErrorDesc ).
          run piCriaErro (17006,
                             pErrorType, 
                             pErrorDesc).


     END.
     RETURN "NOK":U.
     LEAVE.

   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


