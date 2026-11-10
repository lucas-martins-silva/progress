/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXNAR001 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axnar001 MUT}
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFinITIONS Procedure 
/**------------------------------------------------------------------------
    File        : axnar001.p
    Purpose     : ADAPTER DE ENVIO DE MOVIMENTOS DE ESTOQUE

    Syntax      :

    Description : ADAPTER DE ENVIO DE MOVIMENTOS DE ESTOQUE
    CREATEd     : 29/12/2003 10:00
    Notes       :
  ----------------------------------------------------------------------**/


/** **********************  Definitions  *********************** **/
/** Pr‚-Processadores**/
&GLOBAL-DEFinE XmlTranName       InventoryTransactionNotify  /** Nome Padrao da Transacao **/
&GLOBAL-DEFinE XmlTranVersion    204.000                     /** Versao da Transacao      **/
&GLOBAL-DEFinE XmlProdName       EMS2                        /** Nome do Produto          **/
&GLOBAL-DEFinE XmlProdVersion    204                         /** Versao do Produto        **/
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 299.999
&GLOBAL-DEFinE XmlApp            AR2                         /** Codigo do Aplicativo     **/
&GLOBAL-DEFinE XmlMod            MCE                         /** Modulo Resp. Transacao   **/

/** Temp-table RowErrors **/
{cdp/cd9043.i}
{cdp/cd9043.i1}

/* ---  Knupp - Retorno da mensagem dos Movtos de Estoque  --- */
{cep/ceapi001k.i} /* Temp-table tt-movto */

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_des_msg_ajuda AS CHARACTER INITIAL ?
     FIELD ttv_des_msg_erro  AS CHARACTER INITIAL ?
     FIELD ttv_num_cod_erro  AS INTEGER   INITIAL ?
.


/** Parametros de Entrada **/
define input  parameter table for tt-movto.
define input  parameter pProgName            as character no-undo. /** Programa que originou a acao           **/
define input  parameter pProgVersion         as character no-undo. /** Versao do pProgName                    **/
define input  parameter pTranAction          as character no-undo. /** Acao a ser efetuada pelo adapter       **/
define input  parameter i-TransactionNumberExternal  as int       no-undo. /** Valor a ser enviado pelo adapter       **/
define output parameter table for tt_log_erro.                     /** Retorno dos erros gerados pelo adapter **/



define variable hMessageHandler              as handle    no-undo.
define variable cReturnValue                 as character no-undo.
define variable lCreateMsg                   as logical   no-undo.
define variable hGenXml                      as handle    no-undo.
define variable hBusinessContent             as handle    no-undo.
define variable pSendSuccess                 as log       no-undo initial yes.
define variable pTotalErrors                 as int       no-undo.
define variable pErrorNumber                 as int       no-undo.
define variable pErrorType                   as character no-undo.
define variable pErrorDesc                   as character no-undo.
define variable iCount                       as int       no-undo.
define variable iCustoContab                 as int       no-undo.
define variable lUsaPadrao                   as log       no-undo.
define variable lUsaOnline                   as log       no-undo.
define variable iId                          as int       no-undo.
define variable iFirstId                     as int       no-undo. 
define variable iTransactionInfId            as int       no-undo.
define variable iLocationId                  as int       no-undo.
define variable iSiteId                      as int       no-undo.
define variable iWarehouseId                 as int       no-undo.
define variable iBinLocationId               as int       no-undo.
define variable iItemId                      as int       no-undo.
define variable iReferenceId                 as int       no-undo.
define variable iVendorId                    as int       no-undo.
define variable iGeneralLAId                 as int       no-undo.
define variable iBalanceAccId                as int       no-undo.
define variable iFiscalOpId                  as int       no-undo.
define variable iUnitId                      as int       no-undo.
define variable iDocumentId                  as int       no-undo.
define variable iDocValuesId                 as int       no-undo.
define variable iDocValuesIdFASB             as int       no-undo.
define variable iDocValuesIdCMI              as int       no-undo.
define variable iManufactOrderId             as int       no-undo.
define variable iOrderOpId                   as int       no-undo.
define variable iManufactRouteId             as int       no-undo.
define variable iParentItemId                as int       no-undo.
define variable iTargetTransId               as int       no-undo.
define variable iTargetSiteId                as int       no-undo.
define variable iTransactionValuesId         as int       no-undo.
define variable iListOfBatchAverageValuesId  as int       no-undo.
define variable iValuesId                    as int       no-undo.
define variable iListOfOnLineAverageValuesId as int       no-undo.
define variable iListOfStandardCostValuesId  as int       no-undo.
define variable iMaterialTransactionValuesId as int       no-undo.
define variable iListOfOverHeadValuesId      as int       no-undo.
define variable iOverHeadValuesId            as int       no-undo.
define variable iComponentValuesId           as int       no-undo.
define variable iListOfCostSequencesId       as int       no-undo.
define variable iCostSequenceId              as int       no-undo.
define variable iListOfSequenceValuesId      as int       no-undo.


/** _UIB-CODE-BLOCK-END **/
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSor-BLOCK 

/** ********************  Preprocessor Definitions  ******************** **/

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/** _UIB-PREPROCESSor-BLOCK-END **/
&ANALYZE-RESUME


/** ************************  Function Prototypes ********************** **/

/** _UIB-CODE-BLOCK-END **/
&ANALYZE-RESUME

/** *********************** Procedure Settings ************************ **/

&ANALYZE-SUSPEND _PROCEDURE-SETTinGS
/** Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 **/
&ANALYZE-RESUME _END-PROCEDURE-SETTinGS

/** *************************  CREATE Window  ************************** **/

&ANALYZE-SUSPEND _CREATE-WindoW
/** DESIGN Window definition (used by the UIB) 
  CREATE WindoW Procedure ASSIGN
         HEIGHT             = 25.46
         WIDTH              = 36.57.
/** END WindoW DEFinITION **/
                                                                        **/
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAin-BLOCK Procedure 


/** ***************************  Main Block  *************************** **/
{utp/ut-glob.i}
{cdp/cdcfgman.i} 
{cdp/cdcfgdis.i}

FOR FIRST tt-movto NO-LOCK:

    /** Verifica se exite o registro **/
    find movto-estoq
        where movto-estoq.nr-trans = tt-movto.nr-trans exclusive-lock no-error.
    if  not avail movto-estoq then do:
        {utp/ut-liter.i Movimento_de_Estoque_para_integra‡Æo_EAI * r}
        run piCriaErro (5561,
                        'EMS':U, 
                        trim(return-value)).
        return "NOK":U.
    end.

    for first param-estoq fields (tem-moeda1 tem-moeda2) no-lock: end.
    if  not avail param-estoq then do:
        {utp/ut-liter.i Parƒmetros_de_Estoque * r}
        run piCriaErro (5561,
                        'EMS':U, 
                        trim(return-value)).
        return "NOK":U.
    end.

    /** Verifica se MessageHandler.p esta na memoria **/
    {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

    /** Verifica se o MessageHandler foi executado corretamente **/
    if  cReturnValue <> "OK":U then do:
        if  cReturnValue <> ? 
        and cReturnValue <> " " then do:
            run piCriaErro (17006,
                            'EMS':U, 
                            cReturnValue).
            return "NOK":U.
        end.
    end.

    /** Verifica se ha programas inscritos **/
    run isSubscribed in hMessageHandler (input "{&XmlProdName}",
                                         input "{&XmlApp}",
                                         input "{&XmlTranName}",
                                         input "{&XmlTranVersion}",
                                         input "":U,
                                         input  LC(pTranAction),
                                         output lCreateMsg).

    /** Verifica se a transacao e assinada **/
    if  not lCreateMsg
    or  return-value <> "OK":U then
        return "OK":U.

    /** Preenche o valor do elemento Comment de TransactionId **/
    run setTransinfoComment in hMessageHandler ("Program:" + pProgName + "-" +
                                                "Version:" + pProgVersion). 

    /** Seta SystemID **/
    run setSystemId in hMessageHandler ("{&pXmlMod}" ,        /** Nome do modulo     **/
                                        "{&XmlProdVersion}"). /** Versao do Programa **/

    /** indica valor da chave prim ria da transa‡Æo **/
    run setKeyFields in hMessageHandler ("movto-estoq.nr-trans",
                                         string(movto-estoq.nr-trans)). 

    /** Seta a empresa e o estabelecimento **/
    run setCompanyId in hMessageHandler (string(v_cdn_empres_usuar), ""). 

    /** Verifica se API est  na mem¢ria **/
    {xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}

    /** Verifica se o ut-genxml foi executado corretamente **/
    if  cReturnValue <> "OK":U then do:
        if  cReturnValue <> ? 
        and cReturnValue <> "" then do:
            run piCriaErro (17006,
                            'EMS':U, 
                            cReturnValue).
            return "NOK":U.
        end.
     end.

    /** Cria mensagem do BusinessContent atrav‚s da API **/
    CREATE-BUSINESS-XML:
    do:
        /** Reseta os Valores **/
        run reset in hGenXml.

        /** Seta Valor de Encoding **/
        run setEncoding in hGenXml ("UTF-8").

        if  pTranAction = "add":U then
            /**-------------------------------- No principal Upsert --------------------------------------- **/
            run addNode in hGenXml (0, "Upsert", "", output iFirstId).

        if pTranAction = "del":U then
            /**-------------------------------- No principal Delete --------------------------------------- **/
            run addNode in hGenXml (0, "Delete":U, "", output iFirstId).
        /**-------------------------------- TransactionInformation ------------------------------------ **/
        run addNode     in hGenXml (iFirstId, "TransactionInformation":U, "", output iTransactionInfId).

        run addNodeDec  in hGenXml (iTransactionInfId, "TransactionType":U        , movto-estoq.tipo-trans, output iId).
        run addNodeDec  in hGenXml (iTransactionInfId, "TransactionNumber":U      , movto-estoq.nr-trans  , output iId).
        run addNodeDec  in hGenXml (iTransactionInfId, "TransactionNumberExternal":U, i-TransactionNumberExternal  , output iId).
        run addNodeDate in hGenXml (iTransactionInfId, "TransactionDate":U        , movto-estoq.dt-trans  , output iId).
        if  movto-estoq.hr-trans <> "" then
            run addNode     in hGenXml (iTransactionInfId, "TransactionTime":U    , movto-estoq.hr-trans  , output iId).
        run addNodeDate in hGenXml (iTransactionInfId, "TransactionCreationDate":U, movto-estoq.dt-criacao, output iId).

        /**------------------------------------ Location ---------------------------------------------- **/
        run addNode in hGenXml (iFirstId, "Location":U, "", output iLocationId).

        for first estabelec fields (nome custo-contab usa-padrao usa-on-line)
            where estabelec.cod-estabel = movto-estoq.cod-estabel no-lock: end.
        if  avail estabelec then do:
            /** Location - Site **/
            run addNode in hGenXml (iLocationId, "Site":U, "", output iSiteId).

            run addNode in hGenXml (iSiteId, "SiteID":U         , movto-estoq.cod-estabel, output iId).
            run addNode in hGenXml (iSiteId, "SiteDescription":U, estabelec.nome         , output iId).
            assign iCustoContab = estabelec.custo-contab
                   lUsaPadrao   = estabelec.usa-padrao
                   lUsaOnline   = estabelec.usa-on-line.
        end.
        else do: 
            {utp/ut-liter.i Estabelecimento * r}
            assign cReturnValue = return-value + " " + movto-estoq.cod-estabel.
            run piCriaErro (47,
                            'EMS':U, 
                            trim(cReturnValue)).
            return "NOK":U.
        end.

        for first deposito fields (nome)
            where deposito.cod-depos = movto-estoq.cod-depos no-lock: end.
        if  avail deposito then do:
            /** Location - Warehouse */
            run addNode in hGenXml (iLocationId, "Warehouse":U, "", output iWarehouseId).

            run addNode in hGenXml (iWarehouseId, "WarehouseID":U         , movto-estoq.cod-depos, output iId).        
            run addNode in hGenXml (iWarehouseId, "WarehouseDescription":U, deposito.nome        , output iId).
        end.
        else do: 
            {utp/ut-liter.i Dep¢sito * r}
            assign cReturnValue = return-value + " " + movto-estoq.cod-depos.
            run piCriaErro (47,
                            'EMS':U, 
                            trim(cReturnValue)).
            return "NOK":U.
        end.

        for first localizacao fields (descricao)
            where localizacao.cod-localiz = movto-estoq.cod-localiz no-lock: end.
        if  avail localizacao then do:
            /** Location - BinLocation **/
            run addNode in hGenXml (iLocationId   , "BinLocation":U           , ""                     , output iBinLocationId).

            run addNode in hGenXml (iBinLocationId, "BinLocationID":U         , movto-estoq.cod-localiz, output iId).
            run addNode in hGenXml (iBinLocationId, "BinLocationDescription":U, localizacao.descricao  , output iId).
        end.

        if  movto-estoq.lote <> "" then
            /** Location - LotOrSerialNumber **/
            run addNode     in hGenXml (iLocationId, "LotOrSerialNumber":U, movto-estoq.lote, output iId).

        /** Location - LotValidityDate **/
        for first saldo-estoq fields (dt-vali-lote)
            where saldo-estoq.cod-estabel = movto-estoq.cod-estabel
            and   saldo-estoq.cod-depos   = movto-estoq.cod-depos
            and   saldo-estoq.cod-localiz = movto-estoq.cod-localiz
            and   saldo-estoq.lote        = movto-estoq.lote
            and   saldo-estoq.it-codigo   = movto-estoq.it-codigo
            and   saldo-estoq.cod-refer   = movto-estoq.cod-refer no-lock: end.
        if  avail saldo-estoq 
        and saldo-estoq.dt-vali-lote <> ? then
            run addNodeDate in hGenXml (iLocationId, "LotValidityDate":U, saldo-estoq.dt-vali-lote, output iId).

        /**--------------------------------------- Item ----------------------------------------------- **/
        run addNode in hGenXml (iFirstId, "Item":U, "", output iItemId).

        for first item fields (desc-item)
            where item.it-codigo = movto-estoq.it-codigo no-lock: end.
        if  avail item then do:
            run addNode in hGenXml (iItemId, "ItemCode":U       , movto-estoq.it-codigo, output iId).
            run addNode in hGenXml (iItemId, "ItemDescription":U, item.desc-item       , output iId).
        end.
        else do:
            {utp/ut-liter.i Item * r}
            assign cReturnValue = return-value + " " + movto-estoq.it-codigo.
            run piCriaErro (47,
                            'EMS':U, 
                            trim(cReturnValue)).
            return "NOK":U.
        end.

        if  movto-estoq.descricao-db <> "" then
            run addNode in hGenXml (iItemId, "DirectDebitItemDescription":U, movto-estoq.descricao-db, output iId).

        if  movto-estoq.cod-refer <> "" then do:
            for first referencia fields (descricao)
                where referencia.cod-refer = movto-estoq.cod-refer no-lock: end.
            if  avail referencia then do:
                /** Item - Reference **/
                run addNode in hGenXml (iItemId     , "Reference":U           , ""                   , output iReferenceId).

                run addNode in hGenXml (iReferenceId, "ReferenceCode":U       , movto-estoq.cod-refer, output iId).
                run addNode in hGenXml (iReferenceId, "ReferenceDescription":U, referencia.descricao , output iId).
            end.
        end.

        for first emitente fields (nome-abrev cgc)
            where emitente.cod-emitente = movto-estoq.cod-emitente no-lock: end.
        if  avail emitente then do:
            /**-------------------------------------- Vendor ----------------------------------------------- **/
            run addNode    in hGenXml (iFirstId, "Vendor":U, "", output iVendorId).

            run addNodeDec in hGenXml (iVendorId, "VendorID":U       , movto-estoq.cod-emitente, output iId).
            run addNode    in hGenXml (iVendorId, "VendorShortName":U, emitente.nome-abrev     , output iId).
            run addNode    in hGenXml (iVendorId, "VendorTaxID":U    , emitente.cgc            , output iId).
        end.

        /**---------------------------------- GeneralLedgerAccount ------------------------------------- **/
        run addNode in hGenXml (iFirstId, "GeneralLedgerAccount":U, "", output iGeneralLAId).

        if  movto-estoq.ct-codigo <> "" then
            run addNode in hGenXml (iGeneralLAId, "AccountNumber":U         , movto-estoq.ct-codigo     , output iId).
        if  movto-estoq.sc-codigo <> "" then
            run addNode in hGenXml (iGeneralLAId, "SubAccountNumber":U      , movto-estoq.sc-codigo     , output iId).
        run addNode in hGenXml (iGeneralLAId, "GeneralLedgerAccountNumber":U, movto-estoq.conta-contabil, output iId).
        if  movto-estoq.cod-unid-negoc <> "" then
            run addNode in hGenXml (iGeneralLAId, "BusinessUnitCode":U      , movto-estoq.cod-unid-negoc, output iId).
        /**------------------------------------ AplicationAccount -------------------------------------- **/
        /**---------------------------- Elemento nao considerados no envio ----------------------------- **/

        /**------------------------------------- BalanceAccount ---------------------------------------- **/
        if  movto-estoq.ct-saldo <> "":U then do:
            run addNode in hGenXml (iFirstId, "BalanceAccount":U, "", output iBalanceAccId).

            run addNode in hGenXml (iBalanceAccId, "AccountNumber":U       , movto-estoq.ct-saldo   , output iId).
            run addNode in hGenXml (iBalanceAccId, "SubAccountNumber":U    , movto-estoq.sc-saldo   , output iId).
            run addNode in hGenXml (iBalanceAccId, "BalanceAccountNumber":U, movto-estoq.conta-saldo, output iId).
            if movto-estoq.cod-unid-negoc-sdo <> "" then
                run addNode in hGenXml (iBalanceAccId, "BalanceBusinessUnitCode":U, movto-estoq.cod-unid-negoc-sdo, output iId).
        end.
        if  movto-estoq.nat-operacao <> "" then do:
            for first natur-oper fields (denominacao)
                where natur-oper.nat-operacao = movto-estoq.nat-operacao no-lock: end.
            if  avail natur-oper then do:
                /**------------------------------------- FiscalOperation -------------------------------------- **/
                run addNode in hGenXml (iFirstId, "FiscalOperation":U, "", output iFiscalOpId).

                run addNode in hGenXml (iFiscalOpId, "FiscalOperationCode":U       , movto-estoq.nat-operacao, output iId).
                run addNode in hGenXml (iFiscalOpId, "FiscalOperationDescription":U, natur-oper.denominacao  , output iId).
            end.
        end.

        /**-------------------------------------- UnitOfMeasure --------------------------------------- **/
        run addNode in hGenXml (iFirstId, "UnitOfMeasure":U, "", output iUnitId).

        if  movto-estoq.un = "" then do:
            for first item fields (un)
                where item.it-codigo = movto-estoq.it-codigo no-lock: end.
            if  avail item then 
                assign movto-estoq.un = item.un.
        end.

        for first tab-unidade fields (descricao)
            where tab-unidade.un = movto-estoq.un no-lock: end.
        if  avail tab-unidade then do:
            run addNode in hGenXml (iUnitId, "UnitOfMeasureID":U         , movto-estoq.un       , output iId).
            run addNode in hGenXml (iUnitId, "UnitOfMeasureDescription":U, tab-unidade.descricao, output iId).
        end.
        else do:
            {utp/ut-liter.i Unidade_de_medida * r}
            assign cReturnValue = return-value + " " + movto-estoq.un.
            run piCriaErro (47,
                            'EMS':U, 
                            trim(cReturnValue)).
            return "NOK":U.
        end.

        /**----------------------------------------- Quantity ----------------------------------------- **/
        run addNodeDec in hGenXml (iFirstId, "Quantity":U , movto-estoq.quantidade  , output iId).

        /**---------------------------------------- NetWeight ----------------------------------------- **/
        run addNodeDec in hGenXml (iFirstId, "NetWeight":U, movto-estoq.peso-liquido, output iId).

        /**---------------------------------------- ValueType ----------------------------------------- **/
        run addNodeDec in hGenXml (iFirstId, "ValueType":U, movto-estoq.tipo-valor  , output iId).

        /**----------------------------------------- Document ----------------------------------------- **/
        run addNode    in hGenXml (iFirstId, "Document":U, "", output iDocumentId).

        run addNodeDec in hGenXml (iDocumentId, "DocumentType":U, movto-estoq.esp-docto, output iId).
        if  movto-estoq.serie-docto <> "" then
            run addNode    in hGenXml (iDocumentId, "DocumentSeries":U, movto-estoq.serie-docto, output iId).
        if  movto-estoq.nro-docto <> "" then
            run addNode    in hGenXml (iDocumentId, "DocumentNumber":U, movto-estoq.nro-docto, output iId).
        run addNodeDec in hGenXml (iDocumentId, "DocumentSequence":U, movto-estoq.sequen-nf,   output iId).

        /** Document - CurrentCurrencyDocumentValuesAndTaxes **/
        run addNode    in hGenXml (iDocumentId, "CurrentCurrencyDocumentValuesAndTaxes":U, "", output iDocValuesId).

        run addNodeDec in hGenXml (iDocValuesId, "DocumentValue":U                         , movto-estoq.valor-nota    , output iId).
        run addNodeDec in hGenXml (iDocValuesId, "ServicesAndProductsCirculationTaxValue":U, movto-estoq.valor-icm     , output iId).
        run addNodeDec in hGenXml (iDocValuesId, "IndustrializedProductTaxValue":U         , movto-estoq.valor-ipi     , output iId).
        run addNodeDec in hGenXml (iDocValuesId, "ServiceTaxValue":U                       , movto-estoq.valor-iss     , output iId).
        &if "{&bf_dis_versao_ems}":U >= "2.06":U &then
        run addNodeDec in hGenXml (iDocValuesId, "SocialSecurityContributionTaxValue":U    , movto-estoq.val-cofins, output iId).
        run addNodeDec in hGenXml (iDocValuesId, "SocialIntegrationProgramTaxValue":U      , movto-estoq.valor-pis , output iId).        
        &else
        run addNodeDec in hGenXml (iDocValuesId, "SocialSecurityContributionTaxValue":U    , dec(substr(movto-estoq.char-1,43,14)), output iId).
        run addNodeDec in hGenXml (iDocValuesId, "SocialIntegrationProgramTaxValue":U      , dec(substr(movto-estoq.char-1,29,14)), output iId).
        &endif

        /** Document - FASBDocumentValuesAndTaxes **/
        run addNode    in hGenXml (iDocumentId, "FASBDocumentValuesAndTaxes":U, "", output iDocValuesIdFASB).

        run addNodeDec in hGenXml (iDocValuesIdFASB, "DocumentValue":U                     , movto-estoq.vl-nota-fasb[1], output iId).
        run addNodeDec in hGenXml (iDocValuesIdFASB, "ServicesAndProductsCirculationTax":U , movto-estoq.vl-icm-fasb[1] , output iId).
        run addNodeDec in hGenXml (iDocValuesIdFASB, "IndustrializedProductTax":U          , movto-estoq.vl-ipi-fasb[1] , output iId).
        run addNodeDec in hGenXml (iDocValuesIdFASB, "ServiceTax":U                        , movto-estoq.vl-iss-fasb[1] , output iId).
        &if "{&bf_dis_versao_ems}":U >= "2.06":U &then
        run addNodeDec in hGenXml (iDocValuesIdFASB, "SocialSecurityContributionTaxValue":U, movto-estoq.val-cofins-fasb, output iId).
        run addNodeDec in hGenXml (iDocValuesIdFASB, "SocialIntegrationProgramTaxValue":U  , movto-estoq.vl-pis-fasb    , output iId).
        &else
        run addNodeDec in hGenXml (iDocValuesIdFASB, "SocialSecurityContributionTaxValue":U, dec(substr(movto-estoq.char-1,71,14)), output iId).
        run addNodeDec in hGenXml (iDocValuesIdFASB, "SocialIntegrationProgramTaxValue":U  , dec(substr(movto-estoq.char-1,1,14)) , output iId).
        &endif

        /** Document - CMiDocumentIdValuesAndTaxes **/
        run addNode    in hGenXml (iDocumentId, "CMIDocumentValuesAndTaxes":U, "", output iDocValuesIdCMI).

        run addNodeDec in hGenXml (iDocValuesIdCMI, "DocumentValue":U                     , movto-estoq.vl-nota-fasb[2], output iId).
        run addNodeDec in hGenXml (iDocValuesIdCMI, "ServicesAndProductsCirculationTax":U , movto-estoq.vl-icm-fasb[2] , output iId).
        run addNodeDec in hGenXml (iDocValuesIdCMI, "IndustrializedProductTax":U          , movto-estoq.vl-ipi-fasb[2] , output iId).
        run addNodeDec in hGenXml (iDocValuesIdCMI, "ServiceTax":U                        , movto-estoq.vl-iss-fasb[2] , output iId).
        &if "{&bf_dis_versao_ems}":U >= "2.06":U &then
        run addNodeDec in hGenXml (iDocValuesIdCMI, "SocialSecurityContributionTaxValue":U, movto-estoq.val-cofins-cmi, output iId).
        run addNodeDec in hGenXml (iDocValuesIdCMI, "SocialIntegrationProgramTaxValue":U  , movto-estoq.vl-pis-cmi    , output iId).
        &else
        run addNodeDec in hGenXml (iDocValuesIdCMI, "SocialSecurityContributionTaxValue":U, dec(substr(movto-estoq.char-1,57,14)), output iId).
        run addNodeDec in hGenXml (iDocValuesIdCMI, "SocialIntegrationProgramTaxValue":U  , dec(substr(movto-estoq.char-1,15,14)), output iId).
        &endif

        /**-------------------------------- PurchaseOrderNumber --------------------------------------- **/
        run addNodeDec in hGenXml (iFirstId, "PurchaseOrderNumber":U, movto-estoq.numero-ordem, output iId).

        /**-------------------------------- ManufacturingOrder --------------------------------------- **/
        run addNode    in hGenXml (iFirstId, "ManufacturingOrder":U, "", output iManufactOrderId).

        run addNodeDec in hGenXml (iManufactOrderId, "ManufacturingOrderNumber":U  , movto-estoq.nr-ord-produ, output iId).
        run addNodeDec in hGenXml (iManufactOrderId, "ManufacturingOrderSequence":U, movto-estoq.num-sequen  , output iId).
        if  movto-estoq.nr-reporte <> 0 then
            run addNodeDec in hGenXml (iManufactOrderId, "ReportNumber":U, movto-estoq.nr-reporte, output iId).

        /**----------------------------------- OrderOperation ---------------------------------------- **/
        if  movto-estoq.op-codigo <> 0 then do:

            run addNode    in hGenXml (iFirstId, "OrderOperation":U, "", output iOrderOpId).

            run addNodeDec in hGenXml (iOrderOpId, "OrderOperationCode":U          , movto-estoq.op-codigo, output iId).
            run addNodeDec in hGenXml (iOrderOpId, "OrderOperationSequenceNumber":U, movto-estoq.op-seq   , output iId).

            if  movto-estoq.cod-roteiro <> "" then do:

                for first rot-fabric fields (descricao)
                    where rot-fabric.cod-roteiro = movto-estoq.cod-roteiro no-lock: end.
                if  not avail rot-fabric then do:
                    {utp/ut-liter.i Roteiro * r}
                    assign cReturnValue = return-value + " " + movto-estoq.cod-roteiro.
                    run piCriaErro (47,
                                    'EMS':U, 
                                    trim(cReturnValue)).
                    return "NOK":U.
                end.

                /** OrderOperation - ManufactureRoute **/
                run addNode in hGenXml (iOrderOpId, "ManufactureRoute":U, "", output iManufactRouteId).

                run addNode in hGenXml (iManufactRouteId, "RouteID":U         , movto-estoq.cod-roteiro, output iId).
                run addNode in hGenXml (iManufactRouteId, "RouteDescription":U, rot-fabric.descricao   , output iId).
            end.

            if  movto-estoq.item-pai <> "" then do:

                for first item fields (desc-item)
                    where item.it-codigo = movto-estoq.item-pai no-lock: end.
                if  not avail item then do:
                    {utp/ut-liter.i Item-pai * r}
                    assign cReturnValue = return-value + " " + movto-estoq.item-pai.
                    run piCriaErro (47,
                                    'EMS':U, 
                                    trim(cReturnValue)).
                    return "NOK":U.
                end.

                /** OrderOperation - ParentItem **/
                run addNode in hGenXml (iOrderOpId, "ParentItem":U, "", output iParentItemId).

                run addNode in hGenXml (iParentItemId, "ParentItemCode":U       , movto-estoq.item-pai, output iId).
                run addNode in hGenXml (iParentItemId, "ParentItemDescription":U, item.desc-item      , output iId).
            end.

            /**--------------------------------- ReferenceOrderNumber ------------------------------------ **/
            run addNodeDec in hGenXml (iFirstId, "ReferenceOrderNumber":U, movto-estoq.nr-ord-refer, output iId).

            /**------------------------------ ProjectControlOrderNumber ---------------------------------- **/
            run addNodeDec in hGenXml (iFirstId, "ProjectControlOrderNumber":U, movto-estoq.num-ord-inv, output iId).

            /**----------------------------- SummarizedRequisitionNumber --------------------------------- **/
            run addNodeDec in hGenXml (iFirstId, "SummarizedRequisitionNumber":U, movto-estoq.nr-req-sum, output iId).
        end.

        for first estabelec fields (nome)
            where estabelec.cod-estabel = movto-estoq.cod-estabel-des no-lock: end.
        if  avail estabelec then do:
            /**---------------------------------- TargetTransaction -------------------------------------- **/
            run addNode    in hGenXml (iFirstId, "TargetTransaction":U, "", output iTargetTransId).

            /** TargetTransaction - TargetSite **/
            run addNode    in hGenXml (iTargetTransId, "TargetSite":U, "", output iTargetSiteId).

            run addNode    in hGenXml (iTargetSiteId, "SiteID":U         , movto-estoq.cod-estabel-des, output iId).
            run addNode    in hGenXml (iTargetSiteId, "SiteDescription":U, estabelec.nome             , output iId).

            /** TargetTransaction - TargetOrderNumber **/
            run addNodeDec in hGenXml (iTargetTransId, "TargetOrderNumber":U, movto-estoq.num-ord-des, output iId).

            /** TargetTransaction - TargetSequenceNumber **/
            run addNodeDec in hGenXml (iTargetTransId, "TargetSequenceNumber":U, movto-estoq.num-seq-des, output iId).
        end.

        if  movto-estoq.dt-nf-saida <> ? then
            /**---------------------------------- IssueDocumentDate -------------------------------------- **/
            run addNodeDate in hGenXml (iFirstId, "IssueDocumentDate":U, movto-estoq.dt-nf-saida, output iId).

        /**-------------------------------------- TaxAmount ------------------------------------------ **/
        run addNodeDec  in hGenXml (iFirstId, "TaxAmount":U, movto-estoq.vl-taxa, output iId).

        &if "{&bf_dis_versao_ems}":U > "2.04":U &then
            /**----------------------------------- TaxAmount ----------------------------------------- **/
            run addNodeDec in hGenXml (iFirstId, "RequisitionBalance":U, movto-estoq.saldo-req, output iId).
        &endif

        /**---------------------------------- TransactionValues -------------------------------------- **/
        run addNode     in hGenXml (iFirstId, "TransactionValues":U, "", output iTransactionValuesId).

        if  iCustoContab = 1 then do:

            /** TransactionValues - ListOfBatchAverageValues **/
            run addNode in hGenXml (iTransactionValuesId, "ListOfBatchAverageValues":U, "", output iListOfBatchAverageValuesId).

            /** ListOfBatchAverageValues - Values **/
            run addNode in hGenXml (iListOfBatchAverageValuesId, "Values":U, "", output iValuesId).

            run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 1                         , output iId).
            run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-m[1], output iId).
            run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-m[1], output iId).
            run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-m[1], output iId).

            if  param-estoq.tem-moeda1 then do:
                /** ListOfBatchAverageValues - Values **/
                run addNode in hGenXml (iListOfBatchAverageValuesId, "Values":U, "", output iValuesId).

                run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 2                         , output iId).
                run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-m[2], output iId).
                run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-m[2], output iId).
                run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-m[2], output iId).
            end.

            if  param-estoq.tem-moeda2 then do:
                /** ListOfBatchAverageValues - Values **/
                run addNode in hGenXml (iListOfBatchAverageValuesId, "Values":U, "", output iValuesId).

                run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 3                         , output iId).
                run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-m[3], output iId).
                run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-m[3], output iId).
                run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-m[3], output iId).
            end.

            if  lUsaOnline then do:
                /** TransactionValues - ListOfOnLineAverageValues **/
                run addNode in hGenXml (iTransactionValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

                /** ListOfOnLineAverageValuesId - Values **/
                run addNode in hGenXml (iListOfOnLineAverageValuesId, "Values":U, "", output iValuesId).

                run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 1                         , output iId).
                run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-o[1], output iId).
                run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-o[1], output iId).
                run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-o[1], output iId).

                if  param-estoq.tem-moeda1 then do:
                    /** ListOfOnLineAverageValuesId - Values **/
                    run addNode in hGenXml (iListOfOnLineAverageValuesId, "Values":U, "", output iValuesId).

                    run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 2                         , output iId).
                    run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-o[2], output iId).
                    run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-o[2], output iId).
                    run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-o[2], output iId).
                end.

                if  param-estoq.tem-moeda2 then do:
                    /** ListOfOnLineAverageValuesId - Values **/
                    run addNode in hGenXml (iListOfOnLineAverageValuesId, "Values":U, "", output iValuesId).

                    run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 3                         , output iId).
                    run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-o[3], output iId).
                    run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-o[3], output iId).
                    run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-o[3], output iId).
                end.
            end.

            &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
                if  lUsaPadrao then do:

                    /** TransactionValues - ListOfStandardCostValues **/
                    run addNode in hGenXml (iTransactionValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

                    /** ListOfStandardCostValuesId - Values **/
                    run addNode in hGenXml (iListOfStandardCostValuesId, "Values":U, "", output iValuesId).

                    run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 1                         , output iId).
                    run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-p[1], output iId).
                    run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-p[1], output iId).
                    run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-p[1], output iId).

                    if  param-estoq.tem-moeda1 then do:
                        /** ListOfStandardCostValuesId - Values **/
                        run addNode in hGenXml (iListOfStandardCostValuesId, "Values":U, "", output iValuesId).

                        run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 2                         , output iId).
                        run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-p[2], output iId).
                        run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-p[2], output iId).
                        run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-p[2], output iId).
                    end.

                    if  param-estoq.tem-moeda2 then do:
                        /** ListOfStandardCostValuesId - Values **/
                        run addNode in hGenXml (iListOfStandardCostValuesId, "Values":U, "", output iValuesId).

                        run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 3                         , output iId).
                        run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-p[3], output iId).
                        run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-p[3], output iId).
                        run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-p[3], output iId).
                    end.
                end.
            &endif

        end.
        else if  iCustoContab = 2 then do:

            /** TransactionValues - ListOfOnLineAverageValues **/
            run addNode in hGenXml (iTransactionValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

            /** ListOfOnLineAverageValuesId - Values **/
            run addNode in hGenXml (iListOfOnLineAverageValuesId, "Values":U, "", output iValuesId).

            run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 1                         , output iId).
            run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-o[1], output iId).
            run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-o[1], output iId).
            run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-o[1], output iId).

            if  param-estoq.tem-moeda1 then do:
                /** ListOfOnLineAverageValuesId - Values **/
                run addNode in hGenXml (iListOfOnLineAverageValuesId, "Values":U, "", output iValuesId).

                run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 2                         , output iId).
                run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-o[2], output iId).
                run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-o[2], output iId).
                run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-o[2], output iId).
            end.

            if  param-estoq.tem-moeda2 then do:
                /** ListOfOnLineAverageValuesId - Values **/
                run addNode in hGenXml (iListOfOnLineAverageValuesId, "Values":U, "", output iValuesId).

                run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 3                         , output iId).
                run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-o[3], output iId).
                run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-o[3], output iId).
                run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-o[3], output iId).
            end.

            &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
                if  lUsaPadrao then do:

                    /** TransactionValues - ListOfStandardCostValues **/
                    run addNode in hGenXml (iTransactionValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

                    /** ListOfStandardCostValuesId - Values **/
                    run addNode in hGenXml (iListOfStandardCostValuesId, "Values":U, "", output iValuesId).

                    run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 1                         , output iId).
                    run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-p[1], output iId).
                    run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-p[1], output iId).
                    run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-p[1], output iId).

                    if  param-estoq.tem-moeda1 then do:
                        /** ListOfStandardCostValuesId - Values **/
                        run addNode in hGenXml (iListOfStandardCostValuesId, "Values":U, "", output iValuesId).

                        run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 2                         , output iId).
                        run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-p[2], output iId).
                        run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-p[2], output iId).
                        run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-p[2], output iId).
                    end.

                    if  param-estoq.tem-moeda2 then do:
                        /** ListOfStandardCostValuesId - Values **/
                        run addNode in hGenXml (iListOfStandardCostValuesId, "Values":U, "", output iValuesId).

                        run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 3                         , output iId).
                        run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-p[3], output iId).
                        run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-p[3], output iId).
                        run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-p[3], output iId).
                    end.
                end.
            &endif

        end.
        &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
        else do:

            /** TransactionValues - ListOfStandardCostValues **/
            run addNode in hGenXml (iTransactionValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

            /** ListOfStandardCostValuesId - Values **/
            run addNode in hGenXml (iListOfStandardCostValuesId, "Values":U, "", output iValuesId).

            run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 1                         , output iId).
            run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-p[1], output iId).
            run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-p[1], output iId).
            run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-p[1], output iId).

            if  param-estoq.tem-moeda1 then do:
                /** ListOfStandardCostValuesId - Values **/
                run addNode in hGenXml (iListOfStandardCostValuesId, "Values":U, "", output iValuesId).

                run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 2                         , output iId).
                run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-p[2], output iId).
                run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-p[2], output iId).
                run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-p[2], output iId).
            end.

            if  param-estoq.tem-moeda2 then do:
                /** ListOfStandardCostValuesId - Values **/
                run addNode in hGenXml (iListOfStandardCostValuesId, "Values":U, "", output iValuesId).

                run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 3                         , output iId).
                run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-p[3], output iId).
                run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-p[3], output iId).
                run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-p[3], output iId).
            end.

            if  lUsaOnline then do:
                /** TransactionValues - ListOfOnLineAverageValues **/
                run addNode in hGenXml (iTransactionValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

                /** ListOfOnLineAverageValuesId - Values **/
                run addNode in hGenXml (iListOfOnLineAverageValuesId, "Values":U, "", output iValuesId).

                run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 1                         , output iId).
                run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-o[1], output iId).
                run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-o[1], output iId).
                run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-o[1], output iId).

                if  param-estoq.tem-moeda1 then do:
                    /** ListOfOnLineAverageValuesId - Values **/
                    run addNode in hGenXml (iListOfOnLineAverageValuesId, "Values":U, "", output iValuesId).

                    run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 2                         , output iId).
                    run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-o[2], output iId).
                    run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-o[2], output iId).
                    run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-o[2], output iId).
                end.

                if  param-estoq.tem-moeda2 then do:
                    /** ListOfOnLineAverageValuesId - Values **/
                    run addNode in hGenXml (iListOfOnLineAverageValuesId, "Values":U, "", output iValuesId).

                    run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 3                         , output iId).
                    run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, movto-estoq.valor-mat-o[3], output iId).
                    run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , movto-estoq.valor-mob-o[3], output iId).
                    run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-estoq.valor-ggf-o[3], output iId).
                end.
            end.
        end.
        &endif

        run CreateTagsValues in this-procedure.
    end.

    /** Obt‚m XMl na variavel handle **/
    run generateXML in hGenXml (output hBusinessContent).

    /** Passa handle do BusinessContent **/
    run setBusinessContent in hMessageHandler (input hBusinessContent).

    /** Elimina handle **/
    if  valid-handle (hBusinessContent) then
        delete object hBusinessContent no-error.

    /** Envia XML para ControlBroker **/                                       
    run sendMessage in hMessageHandler (input "ar2/InventoryTransaction_204_000.xsd").

    /**Verifica se a mensagem foi enviada com sucesso **/
    run getReturnStatus in hMessageHandler (output pSendSuccess,
                                            output pTotalErrors).
    if  not pSendSuccess then do:

        repeat iCount = 1 to pTotalErrors:
            run getError in hMessageHandler (iCount,
                                             output pErrorNumber,
                                             output pErrorType,
                                             output pErrorDesc ).
            run piCriaErro (17006,
                            pErrorType, 
                            pErrorDesc).
        end.
        return "NOK":U.
    end.

END. /* for first tt-movto */

/** _UIB-CODE-BLOCK-END **/
&ANALYZE-RESUME

procedure CreateTagsValues:

    for first movto-mat 
        where movto-mat.nr-ord-prod = movto-estoq.nr-ord-produ
        and   movto-mat.esp-docto   = movto-estoq.esp-docto
        and   movto-mat.num-sequen  = movto-estoq.num-sequen no-lock: end.
    if  avail movto-mat then do:

        /**------------------------------- MaterialTransactionValues --------------------------------- **/
        run addNode    in hGenXml (iFirstId, "MaterialTransactionValues":U, "", output iMaterialTransactionValuesId).

        /** MaterialTransactionValues - ListOfOverHeadValues **/
        run addNode    in hGenXml (iMaterialTransactionValuesId, "ListOfOverHeadValues":U, "", output iListOfOverHeadValuesId).

        /** ListOfOverHeadValues - OverHeadValues **/
        run addNode    in hGenXml (iListOfOverHeadValuesId, "OverHeadValues":U, "", output iOverHeadValuesId).

        run addNodeDec in hGenXml (iOverHeadValuesId, "Sequence":U, 1, output iId).
        if  iCustoContab = 1 then do:

            /** OverHeadValues -  ListOfBatchAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfBatchAverageValues":U, "", output iListOfBatchAverageValuesId).

            /** ListOfBatchAverageValues - Values **/
            {adapters/xml/ar2/axnar001.i "1-m" "iListOfBatchAverageValuesId"}
        end.
        else if  iCustoContab = 2 then do:

            /** OverHeadValues -  ListOfOnLineAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

            /** ListOfOnLineAverageValuesId - Values **/
            {adapters/xml/ar2/axnar001.i "1-o" "iListOfOnLineAverageValuesId"}
        end.
        &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
        else do:

            /** OverHeadValues - ListOfStandardCostValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

            /** ListOfStandardCostValuesId - Values **/
            {adapters/xml/ar2/axnar001.i "1-p" "iListOfStandardCostValuesId"}
        end.
        &endif

        run addNodeDec in hGenXml (iOverHeadValuesId, "Sequence":U, 2, output iId).
        if  iCustoContab = 1 then do:

            /** OverHeadValues -  ListOfBatchAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfBatchAverageValues":U, "", output iListOfBatchAverageValuesId).

            /** ListOfBatchAverageValues - Values **/
            {adapters/xml/ar2/axnar001.i "2-m" "iListOfBatchAverageValuesId"}
        end.
        else if  iCustoContab = 2 then do:

            /** OverHeadValues -  ListOfOnLineAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

            /** ListOfOnLineAverageValuesId - Values **/
            {adapters/xml/ar2/axnar001.i "2-o" "iListOfOnLineAverageValuesId"}
        end.
        &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
        else do:

            /** OverHeadValues - ListOfStandardCostValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

            /** ListOfStandardCostValuesId - Values **/
            {adapters/xml/ar2/axnar001.i "2-p" "iListOfStandardCostValuesId"}
        end.
        &endif

        run addNodeDec in hGenXml (iOverHeadValuesId, "Sequence":U, 3, output iId).
        if  iCustoContab = 1 then do:

            /** OverHeadValues -  ListOfBatchAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfBatchAverageValues":U, "", output iListOfBatchAverageValuesId).

            /** ListOfBatchAverageValues - Values **/
            {adapters/xml/ar2/axnar001.i "3-m" "iListOfBatchAverageValuesId"}
        end.
        else if  iCustoContab = 2 then do:

            /** OverHeadValues -  ListOfOnLineAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

            /** ListOfOnLineAverageValuesId - Values **/
            {adapters/xml/ar2/axnar001.i "3-o" "iListOfOnLineAverageValuesId"}
        end.
        &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
        else do:

            /** OverHeadValues - ListOfStandardCostValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

            /** ListOfStandardCostValuesId - Values **/
            {adapters/xml/ar2/axnar001.i "3-p" "iListOfStandardCostValuesId"}
        end.
        &endif

        run addNodeDec in hGenXml (iOverHeadValuesId, "Sequence":U, 4, output iId).
        if  iCustoContab = 1 then do:

            /** OverHeadValues -  ListOfBatchAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfBatchAverageValues":U, "", output iListOfBatchAverageValuesId).

            /** ListOfBatchAverageValues - Values **/
            {adapters/xml/ar2/axnar001.i "4-m" "iListOfBatchAverageValuesId"}
        end.
        else if  iCustoContab = 2 then do:

            /** OverHeadValues -  ListOfOnLineAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

            /** iListOfOnLineAverageValuesId - Values **/
            {adapters/xml/ar2/axnar001.i "4-o" "iListOfOnLineAverageValuesId"}
        end.
        &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
        else do:

            /** OverHeadValues - ListOfStandardCostValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

            /** ListOfStandardCostValuesId - Values **/
            {adapters/xml/ar2/axnar001.i "4-p" "iListOfStandardCostValuesId"}
        end.
        &endif

        run addNodeDec in hGenXml (iOverHeadValuesId, "Sequence":U, 5, output iId).
        if  iCustoContab = 1 then do:

            /** OverHeadValues -  ListOfBatchAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfBatchAverageValues":U, "", output iListOfBatchAverageValuesId).

            /** ListOfBatchAverageValues - Values **/
            {adapters/xml/ar2/axnar001.i "5-m" "iListOfBatchAverageValuesId"}
        end.
        else if  iCustoContab = 2 then do:

            /** OverHeadValues -  ListOfOnLineAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

            /** iListOfOnLineAverageValuesId - Values **/
            {adapters/xml/ar2/axnar001.i "5-o" "iListOfOnLineAverageValuesId"}
        end.
        &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
        else do:

            /** OverHeadValues - ListOfStandardCostValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

            /** ListOfStandardCostValuesId - Values **/
            {adapters/xml/ar2/axnar001.i "5-p" "iListOfStandardCostValuesId"} 
        end.
        &endif

        run addNodeDec in hGenXml (iOverHeadValuesId, "Sequence":U, 6, output iId).
        if  iCustoContab = 1 then do:

            /** OverHeadValues -  ListOfBatchAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfBatchAverageValues":U, "", output iListOfBatchAverageValuesId).

            /** ListOfBatchAverageValues - Values **/
            {adapters/xml/ar2/axnar001.i "6-m" "iListOfBatchAverageValuesId"}
        end.
        else if  iCustoContab = 2 then do:

            /** OverHeadValues -  ListOfOnLineAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

            /** iListOfOnLineAverageValuesId - Values **/
            {adapters/xml/ar2/axnar001.i "6-o" "iListOfOnLineAverageValuesId"}
        end.
        &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
        else do:

            /** OverHeadValues - ListOfStandardCostValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

            /** ListOfStandardCostValuesId - Values **/
            {adapters/xml/ar2/axnar001.i "6-p" "iListOfStandardCostValuesId"}
        end.
        &endif

        /** MaterialTransactionValues - ComponentValues **/
        run addNode in hGenXml (iMaterialTransactionValuesId, "ComponentValues":U, "", output iComponentValuesId).

        if  iCustoContab = 1 then do:

            /** ComponentValues - ListOfBatchAverageValues **/
            run addNode    in hGenXml (iComponentValuesId, "ListOfBatchAverageValues":U, "", output iListOfBatchAverageValuesId).

            /** ListOfBatchAverageValues - Values **/
            run addNode    in hGenXml (iListOfBatchAverageValuesId, "Values":U, "", output iId).

            run addNodeDec in hGenXml (iId, "Sequence":U     , 1                      , output iId).
            run addNodeDec in hGenXml (iId, "LaborValue":U   , movto-mat.vl-mob-c-m[1], output iId).
            run addNodeDec in hGenXml (iId, "OverHeadValue":U, movto-mat.vl-ggf-c-m[1], output iId).

            if  param-estoq.tem-moeda1 then do:
                /** ListOfBatchAverageValues - Values **/
                run addNode    in hGenXml (iListOfBatchAverageValuesId, "Values":U, "", output iId).

                run addNodeDec in hGenXml (iListOfBatchAverageValuesId, "Sequence":U     , 2                      , output iId).
                run addNodeDec in hGenXml (iListOfBatchAverageValuesId, "LaborValue":U   , movto-mat.vl-mob-c-m[2], output iId).
                run addNodeDec in hGenXml (iListOfBatchAverageValuesId, "OverHeadValue":U, movto-mat.vl-ggf-c-m[2], output iId).
            end.

            if  param-estoq.tem-moeda2 then do:
                /** ListOfBatchAverageValues - Values **/
                run addNode    in hGenXml (iListOfBatchAverageValuesId, "Values":U, "", output iId).

                run addNodeDec in hGenXml (iListOfBatchAverageValuesId, "Sequence":U     , 3                      , output iId).
                run addNodeDec in hGenXml (iListOfBatchAverageValuesId, "LaborValue":U   , movto-mat.vl-mob-c-m[3], output iId).
                run addNodeDec in hGenXml (iListOfBatchAverageValuesId, "OverHeadValue":U, movto-mat.vl-ggf-c-m[3], output iId).
            end.
        end.
        else if iCustoContab = 2 then do:

            /** ComponentValues - ListOfOnLineAverageValues **/
            run addNode    in hGenXml (iComponentValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

            /** ListOfOnLineAverageValues - Values **/
            run addNode    in hGenXml (iListOfOnLineAverageValuesId, "Values":U, "", output iId).

            run addNodeDec in hGenXml (iId, "Sequence":U     , 1                      , output iId).
            run addNodeDec in hGenXml (iId, "LaborValue":U   , movto-mat.vl-mob-c-o[1], output iId).
            run addNodeDec in hGenXml (iId, "OverHeadValue":U, movto-mat.vl-ggf-c-o[1], output iId).

            if  param-estoq.tem-moeda1 then do:
                /** ListOfOnLineAverageValues - Values **/
                run addNode    in hGenXml (iListOfOnLineAverageValuesId, "Values":U, "", output iId).

                run addNodeDec in hGenXml (iId, "Sequence":U     , 2                      , output iId).
                run addNodeDec in hGenXml (iId, "LaborValue":U   , movto-mat.vl-mob-c-o[2], output iId).
                run addNodeDec in hGenXml (iId, "OverHeadValue":U, movto-mat.vl-ggf-c-o[2], output iId).
            end.

            if  param-estoq.tem-moeda2 then do:
                /** ListOfOnLineAverageValues - Values **/
                run addNode    in hGenXml (iListOfOnLineAverageValuesId, "Values":U, "", output iId).

                run addNodeDec in hGenXml (iId, "Sequence":U     , 3                      , output iId).
                run addNodeDec in hGenXml (iId, "LaborValue":U   , movto-mat.vl-mob-c-o[3], output iId).
                run addNodeDec in hGenXml (iId, "OverHeadValue":U, movto-mat.vl-ggf-c-o[3], output iId).
            end.
        end.
        &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
        else do:

            /** ComponentValues - ListOfStandardCostValues **/
            run addNode    in hGenXml (iComponentValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

            /** ListOfStandardCostValues - Values **/
            run addNode    in hGenXml (iListOfStandardCostValuesId, "Values":U, "", output iId).

            run addNodeDec in hGenXml (iId, "Sequence":U     , 1                      , output iId).
            run addNodeDec in hGenXml (iId, "LaborValue":U   , movto-mat.vl-mob-c-p[1], output iId).
            run addNodeDec in hGenXml (iId, "OverHeadValue":U, movto-mat.vl-ggf-c-p[1], output iId).

            if  param-estoq.tem-moeda1 then do:
                /** ListOfStandardCostValues - Values **/
                run addNode    in hGenXml (iListOfStandardCostValuesId, "Values":U, "", output iId).

                run addNodeDec in hGenXml (iListOfStandardCostValuesId, "Sequence":U     , 2                      , output iId).
                run addNodeDec in hGenXml (iListOfStandardCostValuesId, "LaborValue":U   , movto-mat.vl-mob-c-p[2], output iId).
                run addNodeDec in hGenXml (iListOfStandardCostValuesId, "OverHeadValue":U, movto-mat.vl-ggf-c-p[2], output iId).
            end.

            if  param-estoq.tem-moeda2 then do:
                /** ListOfStandardCostValues - Values **/
                run addNode    in hGenXml (iListOfStandardCostValuesId, "Values":U, "", output iId).

                run addNodeDec in hGenXml (iListOfStandardCostValuesId, "Sequence":U     , 3                      , output iId).
                run addNodeDec in hGenXml (iListOfStandardCostValuesId, "LaborValue":U   , movto-mat.vl-mob-c-p[3], output iId).
                run addNodeDec in hGenXml (iListOfStandardCostValuesId, "OverHeadValue":U, movto-mat.vl-ggf-c-p[3], output iId).
            end.
        end.
        &endif
    end.

    &if "{&bf_dis_versao_ems}":U > "2.04":U &then
    
        for each saldo-custo
            where saldo-custo.it-codigo   = movto-estoq.it-codigo
            and   saldo-custo.cod-estabel = movto-estoq.cod-estabel no-lock:

            find ext-movto-estoq
                where ext-movto-estoq.nr-trans    = movto-estoq.nr-trans
                and   ext-movto-estoq.seq-custeio = saldo-custo.seq-custeio no-lock no-error.
            if  avail ext-movto then do:

                /**------------------------------- ListOfCostSequences --------------------------------- **/
                run addNode    in hGenXml (iFirstId, "ListOfCostSequences":U, "", output iListOfCostSequencesId).

                /** ListOfCostSequences - CostSequence **/
                run addNode    in hGenXml (iListOfCostSequencesId, "CostSequence":U, "", output iCostSequenceId).

                run addNodeDec in hGenXml (iCostSequenceId, "CostSequenceNumber":U, ext-movto-estoq.seq-custeio, output iId).
                run addNodeDec in hGenXml (iCostSequenceId, "SequenceQuantity":U  , ext-movto-estoq.quantidade , output iId).

                /** ListOfCostSequences - ListOfSequenceValues **/
                run addNode    in hGenXml (iCostSequenceId, "ListOfSequenceValues":U, "", output iListOfSequenceValuesId).

                /** ListOfSequenceValues - Values **/
                run addNode    in hGenXml (iListOfSequenceValuesId, "Values":U, "", output iValuesId).

                &if "{&bf_dis_versao_ems}":U >= "2.05":U &then
                    run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 1                           , output iId).
                    run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, ext-movto-estoq.val-mater[1], output iId).
                    run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , ext-movto-estoq.val-mob[1]  , output iId).
                    run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, ext-movto-estoq.val-ggf[1]  , output iId).

                    if  param-estoq.tem-moeda1 then do:
                        /** ListOfSequenceValues - Values **/
                        run addNode    in hGenXml (iListOfSequenceValuesId, "Values":U, "", output iValuesId).

                        run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 2                           , output iId).
                        run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, ext-movto-estoq.val-mater[2], output iId).
                        run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , ext-movto-estoq.val-mob[2]  , output iId).
                        run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, ext-movto-estoq.val-ggf[2]  , output iId).
                    end.

                    if  param-estoq.tem-moeda2 then do:
                        /** ListOfSequenceValues - Values **/
                        run addNode    in hGenXml (iListOfSequenceValuesId, "Values":U, "", output iValuesId).

                        run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 3                           , output iId).
                        run addNodeDec in hGenXml (iValuesId, "MaterialValue":U, ext-movto-estoq.val-mater[2], output iId).
                        run addNodeDec in hGenXml (iValuesId, "LaborValue":U   , ext-movto-estoq.val-mob[2]  , output iId).
                        run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, ext-movto-estoq.val-ggf[2]  , output iId).
                    end.
                &endif
            end.
        end.
    &endif
end.
