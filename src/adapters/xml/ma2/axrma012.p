&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXRMA012 2.00.62.003 } /*** 0106203 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axrma012 MUT}
&ENDIF





/*------------------------------------------------------------------------
    File        : axrma012.p
    Purpose     : Recebimento de deposito
    Syntax      :
    Description :
    Author(s)   :
    Created     : 15/05/2009
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* DEFINE PRE-PROCESSADORES */
&GLOBAL-DEFINE XmlApp            MA2
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       Warehouse
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 299.999
&GLOBAL-DEFINE XmlListOfAction   add,upd,del


{xmlinc/xmlloadmessagehandlerrecdef.i}
{xmlinc/xmlloadgenxmlrecdef.i}
{utp/ut-glob.i} /* Vari†veis Globais          */
{cdp/cd0666.i}  /* Temp-table de erros padr∆o */
{cdp/cdcfgman.i}
{cdp/cdcfgmat.i}

{method/dbotterr.i}
{inbo/boin084.i ttDeposito}


def var hDBODeposito  as handle               no-undo.               
def var i-sequencia   as int                  no-undo.
def var c-cod-erro    as char format "x(500)" no-undo.
def var i-dimensao    as int                  no-undo.
def var iWarehouse    as int                  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS
-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.92
         WIDTH              = 39.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* DEFINE A PROCEDURE getTransSubsInfo  */
{xmlinc/xmlgettranssubsinfo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-receiveMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveMessage Procedure 
PROCEDURE receiveMessage :
/*------------------------------------------------------------------------------
  Purpose: RECEBE A MENSAGEM DO CONTROL BROKER E PROCESSA A MESMA PARA ENTREGAR AO DESTinO
  Parameters: pinputXml, poutputXml
  Notes:       
------------------------------------------------------------------------------*/

    /* ParÉmetros de entrada e de sa°da */
    def input  param hinputXML  as handle no-undo.
    def output param houtputXML as handle no-undo.

    /* Vari†veis locais */
    def var hGenXml          as handle no-undo.
    def var cReturnValue     as char   no-undo.
    def var hBusinessContent as handle no-undo.
    def var lSuccessProcess  as log    no-undo.
    def var cValue           as char   no-undo.
    def var cNodeName        as char   no-undo.
    def var iIdList          as int    no-undo.
    def var iIdLine          as int    no-undo.
    def var iIdNext          as int    no-undo.
    def var cTranEvent       as char   no-undo.
    def var cTranVersion     as char   no-undo.
    def var cErrorText       as char   no-undo.
    def var iCount           as int    no-undo.
    def var cListRootSon     as char   no-undo.
    def var iContRootSon     as int    no-undo.
    def var hMessageHandler  as handle no-undo.
    def var cTranAction      as char   no-undo.

    /* Verifica se MessageHandler.p est† na mem¢ria */
    {xmlinc/xmlloadmessagehandlerrec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="houtputXML"}

    /* Verifica se o MessageHandler foi executado corretamente */
    if cReturnValue <> "OK":U then  
        if cReturnValue <> ? and  
           cReturnValue <> "" then  
            run setError in hMessageHandler (input 0,
                                             input "enviroment_error":U,
                                             input cReturnValue).

    /* Faz a interpretaá∆o e alguns processos na mensagem que recebe */
    run parseMessage in hMessageHandler (input  hinputXml,
                                         input "{&XmlTranName}",
                                         input "{&XmlMaxTranVersion}",
                                         input "{&XmlMinTranVersion}",
                                         input 
                                         &if defined (XmlListOfEvents) <> 0 &then
                                             "{&XmlListOfEvents}",
                                         &else
                                             "",
                                         &endif
                                         output lSuccessProcess,
                                         output cTranAction,
                                         output cTranEvent,
                                         output cTranVersion,
                                         output houtputXML ).

    /* Se n∆o processou corretamente, retorna erro */
    if not lSuccessProcess or 
        return-value <> "OK" then do:

        if cReturnValue <> ? and 
           cReturnValue <> " " then do:
            run setError in hMessageHandler (input 0,
                                             input "enviroment_error":U,
                                             input cReturnValue).
        end.

    end.
    else do:

        /* Obtem a parte da mensagem que est† abaixo do elemento BusinessContent */
        run getBusinessContent in hMessageHandler (output hBusinessContent).

        /* Verifica se XMLAPI est† na mem¢ria */
        {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="houtputXML"}
       
        /* Verifica se o ut-genxml foi iniciado corretamente */
        if cReturnValue <> "OK":U then  
            if cReturnValue <> ? and  
               cReturnValue <> "" then do:
                delete object hBusinessContent no-error.
                run setError in hMessageHandler (input 0,
                                                 input "enviroment_error":U,
                                                 input cReturnValue).
            end.

        /* Limpa as temp-tables internas da API XML */
        run reset in hGenXml.

        /* Carrega a estrutura filha de BusinessContent */
        run loadXml in hGenXml (hBusinessContent).

        /* Elimina a mensagem obtida no mÇtodo getBusinessContent */
        delete object hBusinessContent no-error.

        /* Cria um registro para receber os valores dos filhos do elemento raiz (Upsert ou Delete) */
        empty temp-table tt-erro.

        create ttDeposito.
        assign i-sequencia = 0.

        run getSonVal in hGenXml (input 1, input "WarehouseCode":U,        output ttDeposito.cod-depos).
        run getSonVal in hGenXml (input 1, input "WarehouseDescription":U, output ttDeposito.nome).
        run getSonLog in hGenXml (input 1, input "IncAvailableBalance":U, output ttDeposito.cons-saldo).
        run getSonLog in hGenXml (input 1, input "IncMRPOrderBalance":U, output ttDeposito.log-ordens-mrp).
        run getSonLog in hGenXml (input 1, input "IncAllocationBalance":U, output ttDeposito.alocado).
        run getSonLog in hGenXml (input 1, input "QualityControlWarehouse":U, output ttDeposito.ind-dep-cq).
        run getSonLog in hGenXml (input 1, input "FinishedGoodsWarehouse":U, output ttDeposito.ind-acabado).
        run getSonLog in hGenXml (input 1, input "ProcessDepot":U, output ttDeposito.ind-processo).
        run getSonLog in hGenXml (input 1, input "RecycledDepot":U, output ttDeposito.log-reciclagem).
        run getSonLog in hGenXml (input 1, input "ScrapDepot":U, output ttDeposito.ind-dep-rej).
        
        &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
            run getSonLog in hGenXml (input 1, input "WMSWarehouse":U, output ttDeposito.log-gera-wms).
        &ELSE
            run getSonLog in hGenXml (input 1, input "WMSWarehouse":U, output ttDeposito.log-2).
        &ENDIF
        
        run getSonVal in hGenXml (input 1, input "WarehouseType":U, output ttDeposito.ind-tipo-dep).
        run getSonVal in hGenXml (input 1, input "ConsigneeShortName":U, output ttDeposito.nome-abrev).

        IF ttDeposito.nome-abrev = ? THEN
           ASSIGN ttDeposito.nome-abrev = "":U.
       
        RUN cep/ceapi305o.p (INPUT cTranAction,
                             INPUT TABLE ttDeposito,
                             INPUT-OUTPUT TABLE tt-erro).

    end.

  
    for each tt-erro no-lock:

        {utp/ut-liter.i "Erro de integraá∆o. Durante sua execuá∆o ocorreu o(s) seguinte(s) erro(s) de Progress:"}
        run setError in hMessageHandler (input tt-erro.cd-erro,
                                         input "business_error":U,  /* Erro de neg¢cio */
                                         input return-value + tt-erro.mensagem).
    end.

    /* Obtem mensagem de retorno (erro ou confirmacao) */
    run getReturnMessage in hMessageHandler (output houtputXML). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

