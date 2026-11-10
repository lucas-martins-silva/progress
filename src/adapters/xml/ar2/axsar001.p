/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSAR001 2.00.00.015 } /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axsar001 MUT}
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
    File        : AXSAR001.p
    Purpose     : ADAPTER DE ENVIO DE MOVIMENTOS DE ESTOQUE

    Syntax      :

    Description : ADAPTER DE ENVIO DE MOVIMENTOS DE ESTOQUE
    CREATEd     : 29/12/2003 10:00
    Notes       :
  ----------------------------------------------------------------------**/

/** **********************  Definitions  *********************** **/
/** Pr‚-Processadores**/
&GLOBAL-DEFinE XmlTranName      InventoryTransaction /** Nome Padrao da Transacao **/
&GLOBAL-DEFinE XmlTranVersion   204.000              /** Versao da Transacao      **/
&GLOBAL-DEFinE XmlProdName      EMS2                 /** Nome do Produto          **/
&GLOBAL-DEFinE XmlProdVersion   204                  /** Versao do Produto        **/
&GLOBAL-DEFinE XmlApp           AR2                  /** Codigo do Aplicativo     **/
&GLOBAL-DEFinE XmlMod           MCE                  /** Modulo Resp. Transacao   **/
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 299.999

/** Temp-table RowErrors **/
{cdp/cdcfgmat.i} /*pre processador de versÆo*/
{cdp/cd9043.i}
{cdp/cd9043.i1}

/** Parametros de Entrada **/
define input  parameter pProgName            as character no-undo. /** Programa que originou a acao           **/
define input  parameter pProgVersion         as character no-undo. /** Versao do pProgName                    **/
define input  parameter pTranAction          as character no-undo. /** Acao a ser efetuada pelo adapter       **/
define input  parameter pRowidMovtoEstoq     as rowid     no-undo. /** Rowid do registro que sera considerado **/
define output parameter table for RowErrors.                       /** Retorno dos erros gerados pelo adapter **/

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
define variable iProjectPhaseId              as int       no-undo.
define variable iIDSolumRMId                 as int       no-undo.
define variable iRequisitionNumberId         as int       no-undo.
define variable iSequenceId                  as int       no-undo.
define variable iTotalPriceId                as int       no-undo.
define variable iTypeTransactionId           as int       no-undo.
define variable iIDTaskId                    as int       no-undo.
define variable iIDProjectId                 as int       no-undo.
define variable iUnitPriceId                 as int       no-undo.
define variable cCodIDSolum                  as char      no-undo.
define variable cSigla                       as char      no-undo.
define variable deValorPreco                 as dec       no-undo.
define variable deValorUnitPreco             as dec       no-undo.

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
    {cdp/cd9905.i} /* Operacional Textil */
    {include/i-epc200.i axsar001}

    IF  l-funcao-spp-sgt = YES   /* Operacional Textil */
    AND ( pProgName = "RE0402A" OR pProgName = "ft2100") 
    THEN 
        RETURN "OK":U. 

    /** Verifica se exite o registro **/
    find movto-estoq
        where rowid(movto-estoq) = pRowidMovtoEstoq exclusive-lock no-error.
    if  not avail movto-estoq then do:

        {utp/ut-liter.i Movimento_de_Estoque_para_integra‡Æo_EAI * r}
        run piCriaErro (5561,
                        'EMS':U, 
                        trim(return-value)).
        return "NOK":U.
    end.

    if can-find(first funcao
                where funcao.cd-funcao = "spp-integra-ems-his"
                  and funcao.ativo) then do:

        for first item no-lock
            where item.it-codigo = movto-estoq.it-codigo:

            &if '{&bf_mat_versao_ems}' >= '2.08' &then
                if not item.log-orig-ext then 
                    return "OK":U. /* item nao controlado no HIS, sua movimentacao nao devera ir para o WEBSERVICE */
            &else 
                if substring(item.char-1,267,1) <> "S" then
                    return "OK":U. /* item nao controlado no HIS, sua movimentacao nao devera ir para o WEBSERVICE */
            &endif
                else if movto-estoq.quantidade = 0 then /* para o caso de item controlado no HIS, com geracao de div de valor */
                    return "OK":U.
        end.
    end.

    /*SPETO - Comentado devido a testes dno cliente que deu erro...
    IF CAN-FIND( FIRST funcao
             WHERE funcao.cd-funcao = "spp-integra-ems-his"
             AND   funcao.ativo     = YES) THEN DO:
        FOR FIRST nota-fiscal FIELDS(dt-confirm) NO-LOCK
            WHERE nota-fiscal.serie       = movto-estoq.serie-docto
              AND nota-fiscal.nr-nota-fis = movto-estoq.nro-docto
              AND nota-fiscal.cod-estabel = movto-estoq.cod-estabel:
            IF nota-fiscal.dt-confirm = ? THEN
               RETURN "NOK":U.
        END.
    END.
    */

    FOR EACH tt-epc EXCLUSIVE-LOCK
       WHERE tt-epc.cod-event = "inicio-adapter":
        DELETE tt-epc.
    END.
    
    IF c-nom-prog-dpc-mg97  <> ""
    OR c-nom-prog-upc-mg97  <> ""
    OR c-nom-prog-appc-mg97 <> "" THEN DO:

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "inicio-adapter"
               tt-epc.cod-parameter = "prog-orig"
               tt-epc.val-parameter = pProgName.

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "inicio-adapter"
               tt-epc.cod-parameter = "rowid-movto-estoq"
               tt-epc.val-parameter = STRING(ROWID(movto-estoq)).

        {include/i-epc201.i  "inicio-adapter" }
        
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "OK":U.
    END.
    
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

        {adapters/xml/ar2/axsar001.i1}




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
            {adapters/xml/ar2/axsar001.i "1-m" "iListOfBatchAverageValuesId"}
        end.
        else if  iCustoContab = 2 then do:

            /** OverHeadValues -  ListOfOnLineAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

            /** ListOfOnLineAverageValuesId - Values **/
            {adapters/xml/ar2/axsar001.i "1-o" "iListOfOnLineAverageValuesId"}
        end.
        &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
        else do:

            /** OverHeadValues - ListOfStandardCostValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

            /** ListOfStandardCostValuesId - Values **/
            {adapters/xml/ar2/axsar001.i "1-p" "iListOfStandardCostValuesId"}
        end.
        &endif

        run addNodeDec in hGenXml (iOverHeadValuesId, "Sequence":U, 2, output iId).
        if  iCustoContab = 1 then do:

            /** OverHeadValues -  ListOfBatchAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfBatchAverageValues":U, "", output iListOfBatchAverageValuesId).

            /** ListOfBatchAverageValues - Values **/
            {adapters/xml/ar2/axsar001.i "2-m" "iListOfBatchAverageValuesId"}
        end.
        else if  iCustoContab = 2 then do:

            /** OverHeadValues -  ListOfOnLineAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

            /** ListOfOnLineAverageValuesId - Values **/
            {adapters/xml/ar2/axsar001.i "2-o" "iListOfOnLineAverageValuesId"}
        end.
        &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
        else do:

            /** OverHeadValues - ListOfStandardCostValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

            /** ListOfStandardCostValuesId - Values **/
            {adapters/xml/ar2/axsar001.i "2-p" "iListOfStandardCostValuesId"}
        end.
        &endif

        run addNodeDec in hGenXml (iOverHeadValuesId, "Sequence":U, 3, output iId).
        if  iCustoContab = 1 then do:

            /** OverHeadValues -  ListOfBatchAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfBatchAverageValues":U, "", output iListOfBatchAverageValuesId).

            /** ListOfBatchAverageValues - Values **/
            {adapters/xml/ar2/axsar001.i "3-m" "iListOfBatchAverageValuesId"}
        end.
        else if  iCustoContab = 2 then do:

            /** OverHeadValues -  ListOfOnLineAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

            /** ListOfOnLineAverageValuesId - Values **/
            {adapters/xml/ar2/axsar001.i "3-o" "iListOfOnLineAverageValuesId"}
        end.
        &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
        else do:

            /** OverHeadValues - ListOfStandardCostValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

            /** ListOfStandardCostValuesId - Values **/
            {adapters/xml/ar2/axsar001.i "3-p" "iListOfStandardCostValuesId"}
        end.
        &endif

        run addNodeDec in hGenXml (iOverHeadValuesId, "Sequence":U, 4, output iId).
        if  iCustoContab = 1 then do:

            /** OverHeadValues -  ListOfBatchAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfBatchAverageValues":U, "", output iListOfBatchAverageValuesId).

            /** ListOfBatchAverageValues - Values **/
            {adapters/xml/ar2/axsar001.i "4-m" "iListOfBatchAverageValuesId"}
        end.
        else if  iCustoContab = 2 then do:

            /** OverHeadValues -  ListOfOnLineAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

            /** iListOfOnLineAverageValuesId - Values **/
            {adapters/xml/ar2/axsar001.i "4-o" "iListOfOnLineAverageValuesId"}
        end.
        &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
        else do:

            /** OverHeadValues - ListOfStandardCostValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

            /** ListOfStandardCostValuesId - Values **/
            {adapters/xml/ar2/axsar001.i "4-p" "iListOfStandardCostValuesId"}
        end.
        &endif

        run addNodeDec in hGenXml (iOverHeadValuesId, "Sequence":U, 5, output iId).
        if  iCustoContab = 1 then do:

            /** OverHeadValues -  ListOfBatchAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfBatchAverageValues":U, "", output iListOfBatchAverageValuesId).

            /** ListOfBatchAverageValues - Values **/
            {adapters/xml/ar2/axsar001.i "5-m" "iListOfBatchAverageValuesId"}
        end.
        else if  iCustoContab = 2 then do:

            /** OverHeadValues -  ListOfOnLineAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

            /** iListOfOnLineAverageValuesId - Values **/
            {adapters/xml/ar2/axsar001.i "5-o" "iListOfOnLineAverageValuesId"}
        end.
        &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
        else do:

            /** OverHeadValues - ListOfStandardCostValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

            /** ListOfStandardCostValuesId - Values **/
            {adapters/xml/ar2/axsar001.i "5-p" "iListOfStandardCostValuesId"} 
        end.
        &endif

        run addNodeDec in hGenXml (iOverHeadValuesId, "Sequence":U, 6, output iId).
        if  iCustoContab = 1 then do:

            /** OverHeadValues -  ListOfBatchAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfBatchAverageValues":U, "", output iListOfBatchAverageValuesId).

            /** ListOfBatchAverageValues - Values **/
            {adapters/xml/ar2/axsar001.i "6-m" "iListOfBatchAverageValuesId"}
        end.
        else if  iCustoContab = 2 then do:

            /** OverHeadValues -  ListOfOnLineAverageValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfOnLineAverageValues":U, "", output iListOfOnLineAverageValuesId).

            /** iListOfOnLineAverageValuesId - Values **/
            {adapters/xml/ar2/axsar001.i "6-o" "iListOfOnLineAverageValuesId"}
        end.
        &if "{&bf_dis_versao_ems}":U <= "2.04":U &then
        else do:

            /** OverHeadValues - ListOfStandardCostValues **/
            run addNode in hGenXml (iOverHeadValuesId, "ListOfStandardCostValues":U, "", output iListOfStandardCostValuesId).

            /** ListOfStandardCostValuesId - Values **/
            {adapters/xml/ar2/axsar001.i "6-p" "iListOfStandardCostValuesId"}
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
