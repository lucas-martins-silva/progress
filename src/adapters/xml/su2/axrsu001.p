/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXRSU001 2.00.00.018 } /*** 010018 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axrsu001 MUT}
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
    File        : AXSRAR001.p
    Purpose     : RECEBIMENTO NOTA FISCAL ENTRADA

    Syntax      :

    Description : ADAPTER DE RECEBIMENTO DE NOTAS FISCAIS DE ENTRADA
    Author(s)   : Eliza Fernandes Corràa - its0061  
    CREATED     : 26/05/2004 11:30
    Notes       :
----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */
/* PrÇ-Processadores*/
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlApp            SU2 
&GLOBAL-DEFINE XmlTranName       ReceiptDocument
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 299.999
&GLOBAL-DEFINE XmlListOfAction   add,upd,del

/* Variaveis para uso do xmlloadmessagehandlerrec */
{xmlinc/xmlloadmessagehandlerrecdef.i}

/* Variaveis para uso do xmlLoadGenXmlRec */
{xmlinc/xmlloadgenxmlrecdef.i}

/* Temp-table's */
{inbo/boin090.i tt-docum-est}       
{inbo/boin176.i tt-item-doc-est}    
{inbo/boin092.i tt-dupli-apagar}    
{inbo/boin567.i tt-dupli-imp}       
{inbo/boin366.i tt-rat-docum}    

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{method/dbotterr.i}


def temp-table tt-erro-re0402 no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD identif-segment AS CHAR
    FIELD cd-erro         AS INTEGER
    FIELD desc-erro       AS CHAR FORMAT "x(80)".

DEF VAR hGenXml          AS HANDLE                  NO-UNDO. 
DEF VAR cTranAction      AS CHAR                    NO-UNDO.

/* Vari†veis utilizadas na leitura do XML  */
DEF VAR c-cgc            LIKE emitente.cgc          NO-UNDO.
DEF VAR c-nome-abrev     LIKE emitente.nome-abrev   NO-UNDO.
DEF VAR i-emitente       LIKE emitente.cod-emitente NO-UNDO.

def new global shared var i-ep-codigo-usuario   like mguni.empresa.ep-codigo          no-undo.
DEF VAR i-cod-regra-utilizada LIKE config-var-operac-regra.cdn-regra-operac.

DEF VAR iBillValueId                     AS INT     NO-UNDO.  
DEF VAR iBrazilianTaxesId                AS INT     NO-UNDO.
DEF VAR iCMCACValuesAndTaxesId           AS INT     NO-UNDO.
DEF VAR iDiscountId                      AS INT     NO-UNDO.
DEF VAR iDocumentBillId                  AS INT     NO-UNDO. 
DEF VAR iDocumentClassId                 AS INT     NO-UNDO.  
DEF VAR iExpenseRevenueTypeId            AS INT     NO-UNDO.  
DEF VAR iFASBValuesAndTaxesId            AS INT     NO-UNDO.
DEF VAR iFiscalOperationId               AS INT     NO-UNDO.
DEF VAR iForeignValuesAndTaxesId         AS INT     NO-UNDO.
DEF VAR iIndustrializedProductTaxId      AS INT     NO-UNDO.
DEF VAR iRestokingId                     AS INT     NO-UNDO.
DEF VAR iServicesAndProductsTaxId        AS INT     NO-UNDO.
DEF VAR iServiceTaxId                    AS INT     NO-UNDO.
DEF VAR iSocialIntegrationProgramTaxId   AS INT     NO-UNDO.
DEF VAR iSocialSecurityContributionTaxId AS INT     NO-UNDO.
DEF VAR iTaxesId                         AS INT     NO-UNDO.
DEF VAR iVendorId                        AS INT     NO-UNDO.
DEF VAR c-ativo                          AS CHAR    NO-UNDO.
DEF VAR l-erro                           AS LOG     NO-UNDO.

DEFINE TEMP-TABLE tt-variavel NO-UNDO
    FIELD cod-var-oper LIKE config-var-operac-regra-cond.cod-variavel
    FIELD cod-val-var  LIKE config-var-operac-regra-cond.cod-val-var.

DEFINE TEMP-TABLE tt-retorno NO-UNDO
    FIELD valor-retorno LIKE config-var-operac-regra-ret.cod-val-ret
    FIELD campo-retorno LIKE config-var-operac-regra-ret.cod-campo-ret
    FIELD perc-rateio   LIKE config-var-operac-regra-ret.cdd-perc-rat.   

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro AS integer INITIAL ?
     FIELD ttv_des_msg_ajuda AS character INITIAL ?
     FIELD ttv_des_msg_erro AS character INITIAL ? .

&if "{&bf_mat_versao_ems}" >=  "2.08" &then
    def var l-att-automaticamente as log init ? no-undo.
    def new global shared var l-erro-att as log init yes no-undo.
    
    define temp-table tt-param 
        field destino            as integer
        field arquivo            as char
        field usuario            as char
        field data-exec          as date
        field hora-exec          as integer
        field classifica         as integer
        field c-cod-estabel-ini  as char
        field c-cod-estabel-fim  as char
        field i-cod-emitente-ini as integer
        field i-cod-emitente-fim as integer
        field c-nro-docto-ini    as char
        field c-nro-docto-fim    as char
        field c-serie-docto-ini  as char
        field c-serie-docto-fim  as char
        field c-nat-operacao-ini as char
        field c-nat-operacao-fim as char
        field da-dt-trans-ini    as date
        field da-dt-trans-fim    as date.
    
    define temp-table tt-digita
        field r-docum-est        as rowid.
    
    def var raw-param        as raw no-undo.
    
    def temp-table tt-raw-digita
       field raw-digita   as raw.
&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

/* ***************************  Main Block  *************************** */

{xmlinc/xmlgettranssubsinfo.i} /* Procedure getTransSubsInfo  */
{cdp/cdcfgdis.i}               
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveMessage Procedure 
PROCEDURE receiveMessage :
/*------------------------------------------------------------------------------
  Purpose: Recebe mensagem do ControlBroker, processa e entrega ao destino
  Parameters: pINPUTXml, pOUTPUTXml
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM hINPUTXML  AS HANDLE NO-UNDO.
    DEF OUTPUT PARAM hOUTPUTXML AS HANDLE NO-UNDO.

    DEF VAR hMessageHandler  AS HANDLE NO-UNDO.
    DEF VAR hBusinessContent AS HANDLE NO-UNDO.
    DEF VAR lSuccessProcess  AS LOG    NO-UNDO.
    DEF VAR iCount           AS INT    NO-UNDO.
    DEF VAR cReturnValue     AS CHAR   NO-UNDO.
    DEF VAR cTranEvent       AS CHAR   NO-UNDO.
    DEF VAR cTranVersion     AS CHAR   NO-UNDO.
    DEF VAR cErrorText       AS CHAR   NO-UNDO.

    /* Verfica se MessageHandler.p est† na mem¢ria */
    {xmlinc/xmlloadmessagehandlerrec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="hOUTPUTXML"}

    /* Verifica se o MessageHandler foi executado corretamente */
    IF  cReturnValue <> "OK":U THEN 
     IF cReturnValue <> ? AND cReturnValue <> "" THEN 
        RUN setError IN hMessageHandler (INPUT 0,
                                         INPUT "enviroment_error":U,
                                         INPUT cReturnValue).

    /* Armazena e valida a mensagem */
    RUN parseMessage IN hMessageHandler (INPUT  hINPUTXml,
                                         INPUT "{&XmlTranName}",
                                         INPUT "{&XmlMaxTranVersion}",
                                         INPUT "{&XmlMinTranVersion}",
                                         INPUT 
                                          &IF DEFINED(XmlListOfEvents) <> 0
                                           &THEN "{&XmlListOfEvents}",
                                          &ELSE "",
                                           &ENDIF
                                         OUTPUT lSuccessProcess,
                                         OUTPUT cTranAction,
                                         OUTPUT cTranEvent,
                                         OUTPUT cTranVersion,
                                         OUTPUT hOUTPUTXML ).

    RUN getBusinessContent IN hMessageHandler (OUTPUT hBusinessContent).

    /* Verifica se APIXml est† na mem¢ria */
    {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="hOUTPUTXML"}

    /* Verifica se o ut-genxml foi iniciado corretamente */
    IF  cReturnValue <> "OK":U THEN 
     IF cReturnValue <> ? AND cReturnValue <> "" THEN DO:
        DELETE OBJECT hBusinessContent NO-ERROR.
        RUN setError IN hMessageHandler (INPUT 0,
                                         INPUT "enviroment_error":U,
                                         INPUT cReturnValue).
    END.

    RUN reset IN hGenXml.

    RUN loadXml IN hGenXml (hBusinessContent).

    DELETE OBJECT hBusinessContent   NO-ERROR.

    EMPTY TEMP-TABLE tt-docum-est    NO-ERROR.
    EMPTY TEMP-TABLE tt-item-doc-est NO-ERROR.
    EMPTY TEMP-TABLE tt-dupli-apagar NO-ERROR.
    EMPTY TEMP-TABLE tt-dupli-imp    NO-ERROR.
    EMPTY TEMP-TABLE tt-rat-docum    NO-ERROR.
    EMPTY TEMP-TABLE tt-erro         NO-ERROR.

    RUN pi-cria-tt-docum-est.

    IF CAN-FIND (FIRST tt-erro) THEN
       FOR EACH tt-erro:
           RUN setError IN hMessageHandler (INPUT tt-erro.cd-erro,
                                            INPUT "business_error":U,  /* Erro na criaá∆o das temp-table's */
                                            INPUT tt-erro.desc-erro).
       END.

    ELSE DO:

     IF SEARCH("rep/reapi316b.r":U) <> ? THEN DO:  

        for each tt-docum-est no-lock:
            if can-find(first docum-est 
                 where docum-est.serie-docto  = tt-docum-est.serie-docto
                 and   docum-est.nro-docto    = tt-docum-est.nro-docto
                 and   docum-est.cod-emitente = tt-docum-est.cod-emitente
                 and   docum-est.nat-operacao = tt-docum-est.nat-operacao
                 AND   cTranAction            = "ADD") then 
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-registro AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "registro" *}
                ASSIGN c-lbl-liter-registro = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-serie AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "SÇrie" *}
                ASSIGN c-lbl-liter-serie = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-documento AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Documento" *}
                ASSIGN c-lbl-liter-documento = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-emitente AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Emitente" *}
                ASSIGN c-lbl-liter-emitente = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-natoperacao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Nat.Operaá∆o" *}
                ASSIGN c-lbl-liter-natoperacao = TRIM(RETURN-VALUE).
                RUN setError IN hMessageHandler (INPUT 66665,
                                                 INPUT c-lbl-liter-registro,  /* Erro na criaá∆o das temp-table's */
                                                 INPUT c-lbl-liter-serie + ':' + tt-docum-est.serie-docto  +
                                                       ' - ' + c-lbl-liter-documento + ':' + tt-docum-est.nro-docto    +
                                                       ' - ' + c-lbl-liter-emitente + ':' + string(tt-docum-est.cod-emitente) +
                                                       ' - ' + c-lbl-liter-natoperacao + ':' + tt-docum-est.nat-operacao).
                END. 
        end.

        RUN rep/reapi316b.p (INPUT  cTranAction,
                             INPUT  TABLE tt-docum-est,
                             INPUT  TABLE tt-rat-docum,
                             INPUT  TABLE tt-item-doc-est,
                             INPUT  TABLE tt-dupli-apagar,
                             INPUT  TABLE tt-dupli-imp,
                             OUTPUT TABLE tt-erro ) NO-ERROR. 

        IF ERROR-STATUS:ERROR THEN DO: /* Erros ocorridos durante execuá∆o do programa */
          DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
             cErrorText = cErrorText + ERROR-STATUS:GET-MESSAGE(iCount).
          END.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Erro_de_integraá∆o._Erro_ao_executar_o_programa_'rep/reapi316b.p'_pelo_programa_adapters/xml/su2/axrsu001.p._Durante_sua_execuá∆o_ocorreu_o(s)_seguinte(s)_erro(s)_Progress" *}
          RUN setError IN hMessageHandler (INPUT 0,
                                           INPUT "enviroment_error":U,
                                           INPUT RETURN-VALUE + ': ' + cErrorText).
        END.
        ELSE do: /* Erros ocorridos durante efetivaá∆o do registro */

            if can-find(first tt-erro) then do:
                FOR EACH tt-erro:
                    RUN setError IN hMessageHandler (INPUT tt-erro.cd-erro,
                                                     INPUT "business_error":U,  /* Erro de neg¢cio */
                                                     INPUT tt-erro.desc-erro).
                END.
            end.
          &if "{&bf_mat_versao_ems}" >=  "2.08" &then
            else do:

                if l-att-automaticamente then do:

                    for each tt-docum-est:
    
                        find first docum-est where docum-est.serie-docto  = tt-docum-est.serie-docto  and 
                                                   docum-est.nro-docto    = tt-docum-est.nro-docto    and
                                                   docum-est.cod-emitente = tt-docum-est.cod-emitente and 
                                                   docum-est.nat-operacao = tt-docum-est.nat-operacao no-lock no-error.
        
                        def buffer b-docto for docum-est.
        
                        empty temp-table tt-digita.
                        empty temp-table tt-param.
                        
                        create tt-param.
                        assign tt-param.usuario         = c-seg-usuario
                               tt-param.destino         = 2
                               tt-param.data-exec       = today
                               tt-param.hora-exec       = time
                               tt-param.arquivo         = session:temp-directory 
                                                        + "RE1005":U
                                                        + ".tmp":U.
        
                        empty temp-table tt-raw-digita.
                        
                        create tt-digita.
                        assign tt-digita.r-docum-est = rowid(docum-est).
                        
                        for each movto-pend 
                            fields ( serie-comp   nro-comp  nat-comp     tipo
                                     serie-docto  nro-docto nat-operacao cod-emitente)
                                 {cdp/cd8900.i movto-pend docum-est}
                             and movto-pend.tipo = 2 no-lock: /* Material Agregado */
                    
                            find first b-docto
                                where b-docto.serie-docto  = movto-pend.serie-comp
                                  and b-docto.nro-docto    = movto-pend.nro-comp 
                                  and b-docto.cod-emitente = movto-pend.cod-emitente
                                  and b-docto.nat-operacao = movto-pend.nat-comp no-lock no-error.
                                  
                    
                            if  avail b-docto 
                            and not b-docto.ce-atual then do:
                                create tt-digita.
                                assign tt-digita.r-docum-est = rowid(b-docto).
                            end.
                        end.
                        
                        raw-transfer tt-param  to raw-param.
                    
                        for each tt-digita:
                            create tt-raw-digita.
                            raw-transfer tt-digita to tt-raw-digita.raw-digita.
                        end.
                        
                    
                        if  session:set-wait-state("GENERAL":U) then .
                        
                    
                        run rep/re1005rp.p (input raw-param, input table tt-raw-digita).

                        if l-erro-att then 
                             /* Inicio -- Projeto Internacional */
                             DO:
                             {utp/ut-liter.i "Documento_criado/atualizado_com_sucesso_mas_n∆o_foi_realizada_atualizaá∆o_no_recebimento" *}
                             RUN setError IN hMessageHandler (INPUT 0,
                                                              INPUT "business_warning":U,
                                                              INPUT RETURN-VALUE + "." ).
                             END. 
                    
                        {include/i-rptrm.i}
                    
                        if  session:set-wait-state("":U) then .            
                    end.
                end.
            end.
          &endif

        end.
     END.
     ELSE 
         /* Programa de efetivaá∆o n∆o localizado */
         /* Inicio -- Projeto Internacional */
         DO:
         {utp/ut-liter.i "Erro_de_integraá∆o._N∆o_foi_poss°vel_localizar_o_programa_'rep/reapi316b.p'_a_ser_executado_pelo_programa_adapters/xml/su2/axrsu001.p" *}
         RUN setError IN hMessageHandler (INPUT 0,
                                          INPUT "enviroment_error":U,
                                          INPUT RETURN-VALUE + '.').
         END. 

    END.
         /* ObtÇm mensagem de retorno (erro ou confirmaá∆o) */
    RUN getReturnMessage IN hMessageHandler (OUTPUT hOUTPUTXML). 


END PROCEDURE.


PROCEDURE pi-cria-tt-docum-est: /*  Cria registro na temp-table tt-docum-est  */

 DEF VAR iCurrencyId               AS INT NO-UNDO.
 DEF VAR iDocumentValuesAndTaxesId AS INT NO-UNDO.
 DEF VAR iFiscalSiteId             AS INT NO-UNDO.
 DEF VAR iFreightServiceId         AS INT NO-UNDO.
 DEF VAR iServiceTaxValuesId       AS INT NO-UNDO.
 DEF VAR iSiteId                   AS INT NO-UNDO.
 DEF VAR iSourceSiteId             AS INT NO-UNDO.
 DEF VAR iSourceStateId            AS INT NO-UNDO.
 DEF VAR iSuspenseAccountId        AS INT NO-UNDO.
 DEF VAR iSuspenseAccountNumberId  AS INT NO-UNDO.
 DEF VAR cDocumentoAlte            AS CHAR NO-UNDO.
 DEF VAR c-servico                 AS CHAR NO-UNDO.

 FIND FIRST param-estoq NO-LOCK NO-ERROR.

 CREATE tt-docum-est.

    /*** Campos Chave ***/
    RUN getSonVal IN hGenXml (INPUT 1, INPUT "DocumentSeries":U, OUTPUT tt-docum-est.serie-docto).
    RUN getSonVal IN hGenXml (INPUT 1, INPUT "DocumentNumber":U, OUTPUT tt-docum-est.nro-docto).

    IF LENGTH(tt-docum-est.nro-docto) < 7 THEN
        ASSIGN cDocumentoAlte         = FILL("0",7 - (LENGTH(tt-docum-est.nro-docto))) + tt-docum-est.nro-docto
               tt-docum-est.nro-docto = cDocumentoAlte.

    RUN searchTag IN hGenXml ("FiscalOperation":U, 1, OUTPUT iFiscalOperationId).
     IF iFiscalOperationId <> ? THEN 
        RUN getSonVal IN hGenXml (INPUT iFiscalOperationId, INPUT "FiscalOperationCode":U, OUTPUT tt-docum-est.nat-operacao).

    RUN searchTag IN hGenXml ("Vendor":U, 1, OUTPUT iVendorId).
    RUN getSonDec IN hGenXml (INPUT iVendorId, INPUT "VendorID":U, OUTPUT tt-docum-est.cod-emitente).
     IF tt-docum-est.cod-emitente = ? THEN DO:
        RUN getSonVal IN hGenXml (INPUT iVendorId, INPUT "VendorShortName":U, OUTPUT c-nome-abrev).
        RUN getSonVal IN hGenXml (INPUT iVendorId, INPUT "VendorTaxID":U, OUTPUT c-cgc).

         RUN pi-procura-emitente (c-cgc,
                                  c-nome-abrev,
                                  OUTPUT tt-docum-est.cod-emitente).
     END.
    /*********************/

    ASSIGN tt-docum-est.usuario = c-seg-usuario.

    RUN getSonDec IN hGenXml (INPUT 1, INPUT "DocumentType":U, OUTPUT tt-docum-est.esp-docto).
     IF tt-docum-est.esp-docto = ? THEN ASSIGN tt-docum-est.esp-docto = 21. /* NFE */

    RUN searchTag IN hGenXml ("Site":U, 1, OUTPUT iSiteId).
    RUN getSonVal IN hGenXml (INPUT iSiteId, INPUT "SiteID":U, OUTPUT tt-docum-est.cod-estabel).
     IF  tt-docum-est.cod-estabel = ? THEN DO:
        RUN getSonVal IN hGenXml (INPUT iSiteId, INPUT "SiteShortName":U, OUTPUT c-nome-abrev).
        RUN getSonVal IN hGenXml (INPUT iSiteId, INPUT "SiteTaxID":U, OUTPUT c-cgc).

        RUN pi-procura-emitente (c-cgc,
                                 c-nome-abrev,
                                 OUTPUT i-emitente).
        &IF "{&bf_dis_versao_ems}" >=  "2.08" &THEN
          if i-emitente = ? then
              ASSIGN i-emitente =  tt-docum-est.cod-emitente.
         
          IF CONNECTED("mgtrp") AND 
             CONNECTED("movtrp") THEN DO:
              assign tt-docum-est.cod-estabel = param-estoq.estabel-pad.
          end.
          else
        &endif
             FIND FIRST estabelec WHERE
                       estabelec.cod-emitente = i-emitente NO-LOCK NO-ERROR.    
                ASSIGN tt-docum-est.cod-estabel = IF AVAIL estabelec THEN estabelec.cod-estabel
                                                  ELSE  param-estoq.estabel-pad.
     END.   

    IF cTranAction = "add":U OR cTranAction = "upd":U THEN DO: /*  Inclus∆o/Alteraá∆o */

        RUN searchTag  IN hGenXml ("FiscalSite":U, 1, OUTPUT iFiscalSiteId).
         IF iFiscalSiteId <> ? THEN 
            RUN getSonVal  IN hGenXml (INPUT iFiscalSiteId, INPUT "SiteID":U, OUTPUT tt-docum-est.estab-fisc).

        RUN searchTag  IN hGenXml ("SourceSite":U, 1, OUTPUT iSourceSiteId).
         IF iSourceSiteId <> ? THEN 
            RUN getSonVal  IN hGenXml (INPUT iSourceSiteId, INPUT "SiteID":U, OUTPUT tt-docum-est.estab-de-or).

        RUN getSonDec  IN hGenXml (INPUT 1, INPUT "TransactionType":U, OUTPUT tt-docum-est.tipo-docto).
         IF tt-docum-est.tipo-docto = ? THEN ASSIGN tt-docum-est.tipo-docto = 1. 
        RUN getSonDate IN hGenXml (INPUT 1, INPUT "TransactionDate":U, OUTPUT tt-docum-est.dt-trans).
         IF tt-docum-est.dt-trans = ? THEN ASSIGN tt-docum-est.dt-trans = TODAY. 
        RUN getSonDate IN hGenXml (INPUT 1, INPUT "PrintDate":U, OUTPUT tt-docum-est.dt-emissao).
         IF tt-docum-est.dt-emissao = ? THEN ASSIGN tt-docum-est.dt-emissao = TODAY. 

        RUN searchTag  IN hGenXml ("SuspenseAccount":U, 1, OUTPUT iSuspenseAccountId).
         IF iSuspenseAccountId <> ? THEN DO:
            RUN getSonVal  IN hGenXml (INPUT iSuspenseAccountId,INPUT "AccountNumber":U, OUTPUT tt-docum-est.ct-transit).
            RUN getSonVal  IN hGenXml (INPUT iSuspenseAccountId,INPUT "SubAccountNumber":U, OUTPUT tt-docum-est.sc-transit).
            /* Verifica existencia do elemento -> validaá∆o Conta Contabil - boin090 */
            RUN searchTag  IN hGenXml ("SuspenseAccountNumber":U, iSuspenseAccountId, OUTPUT iSuspenseAccountNumberId).
             IF iSuspenseAccountNumberId <> ? THEN
                RUN getSonVal  IN hGenXml (INPUT iSuspenseAccountId,INPUT "SuspenseAccountNumber":U, OUTPUT tt-docum-est.conta-transit). 
         END.

        RUN getSonDec  IN hGenXml (INPUT 1, INPUT "Comments":U, OUTPUT tt-docum-est.cod-observa). 
         IF tt-docum-est.cod-observa = ? THEN ASSIGN tt-docum-est.cod-observa = 1.

        /* Verifica existencia do elemento -> validaá∆o UF - boin090 */
        RUN searchTag  IN hGenXml ("SourceState":U, 1, OUTPUT iSourceStateId).
         IF iSourceStateId <> ? THEN
            RUN getSonVal  IN hGenXml (INPUT 1, INPUT "SourceState":U, OUTPUT tt-docum-est.uf). 

        RUN getSonDec  IN hGenXml (INPUT 1, INPUT "ShippingMethod":U, OUTPUT tt-docum-est.via-transp). 
         IF tt-docum-est.via-transp = ? THEN ASSIGN tt-docum-est.via-transp = 1. 
        RUN getSonVal  IN hGenXml (INPUT 1, INPUT "ShipmentNumber":U, OUTPUT tt-docum-est.embarque).
         IF tt-docum-est.embarque = ? THEN ASSIGN tt-docum-est.embarque = "". 
        RUN getSonDec  IN hGenXml (INPUT 1, INPUT "FreightModality":U, OUTPUT tt-docum-est.mod-frete).
         IF tt-docum-est.mod-frete = ? THEN ASSIGN tt-docum-est.mod-frete = 1. 
        RUN getSonDec  IN hGenXml (INPUT 1, INPUT "FreightDistributionMethod":U, OUTPUT tt-docum-est.rateia-frete).
         IF tt-docum-est.rateia-frete = ? THEN ASSIGN tt-docum-est.rateia-frete = 1. 

        RUN searchTag  IN hGenXml ("FreightService":U, 1, OUTPUT iFreightServiceId).
         IF iFreightServiceId <> ? THEN DO:
            RUN getSonVal  IN hGenXml (INPUT iFreightServiceId, INPUT "ServiceID":U, OUTPUT c-servico).
            &IF '{&BF_DIS_VERSAO_EMS}' < "2.05":U &THEN
              ASSIGN overlay(tt-docum-est.char-2,90,5) = c-servico.
            &ELSE
              ASSIGN tt-docum-est.cod-servico = int(c-servico).
            &ENDIF  
         END.

        RUN getSonDec  IN hGenXml (INPUT 1, INPUT "DocumentQualityControlStatus":U, OUTPUT tt-docum-est.estado).
         IF tt-docum-est.estado = ? THEN ASSIGN tt-docum-est.estado = 1. 
        RUN getSonDec  IN hGenXml (INPUT 1, INPUT "DocumentAPStatus":U, OUTPUT tt-docum-est.sit-docum).
         IF tt-docum-est.sit-docum = ? THEN ASSIGN tt-docum-est.sit-docum = 1. 
        RUN getSonVal  IN hGenXml (INPUT 1, INPUT "DocumentSource":U, OUTPUT tt-docum-est.origem).
         IF tt-docum-est.origem = ? THEN ASSIGN tt-docum-est.origem = "".  
        RUN getSonVal  IN hGenXml (INPUT 1, INPUT "DocumentFiscalClass":U, OUTPUT tt-docum-est.esp-fiscal).
         IF tt-docum-est.esp-fiscal = ? THEN ASSIGN tt-docum-est.esp-fiscal = "".  
        RUN getSonDec  IN hGenXml (INPUT 1, INPUT "DocumentTotalWeight":U, OUTPUT tt-docum-est.tot-peso).
         IF tt-docum-est.tot-peso = ? THEN ASSIGN tt-docum-est.tot-peso = 0.  

        &IF '{&BF_DIS_VERSAO_EMS}' > "2.04":U &THEN
          RUN getSonDate IN hGenXml (INPUT 1, INPUT "DocumentValidityDate":U, OUTPUT tt-docum-est.dat-validade).
           IF tt-docum-est.dat-validade = ? THEN ASSIGN tt-docum-est.dat-validade = 12/31/9999.
          RUN getSonLog  IN hGenXml (INPUT 1, INPUT "IsOtherExpensesInvoice":U, OUTPUT tt-docum-est.fat-despesa).
           IF tt-docum-est.fat-despesa = ? THEN ASSIGN tt-docum-est.fat-despesa = FALSE.                            
          RUN searchTag  IN hGenXml ("Restoking":U, 1, OUTPUT iRestokingId).
           IF iRestokingId <> ? THEN DO:
              RUN getSonDec  IN hGenXml (INPUT iRestokingId, INPUT "VendorsRestokingPercentage":U, OUTPUT tt-docum-est.val-perc-restocagem).
              RUN getSonDec  IN hGenXml (INPUT iRestokingId, INPUT "VendorsRestokingValue":U, OUTPUT tt-docum-est.val-restocagem).
           END.
        &ENDIF

        &IF '{&BF_DIS_VERSAO_EMS}' >= "2.042":U &THEN
          RUN getSonVal  IN hGenXml (INPUT 1, INPUT "RMANumber":U, OUTPUT tt-docum-est.cod-rma). 
           IF tt-docum-est.cod-rma = ? THEN ASSIGN tt-docum-est.cod-rma = "".  
        &ENDIF
        
        &if "{&bf_mat_versao_ems}" >=  "2.08" &then  
              
        RUN getSonLog IN hGenXml (INPUT 1, INPUT "UpdateAutomatically":u , OUTPUT l-att-automaticamente). 

        &endif
        
        RUN getSonVal  IN hGenXml (INPUT 1, INPUT "DocumentNarrative":U, OUTPUT tt-docum-est.observacao).
         IF tt-docum-est.observacao = ? THEN ASSIGN tt-docum-est.observacao = "".  
        RUN getSonDec  IN hGenXml (INPUT 1, INPUT "InvoiceDocumentType":U, OUTPUT tt-docum-est.tipo-nota).
         IF tt-docum-est.tipo-nota = ? THEN ASSIGN tt-docum-est.tipo-nota = 1.  
        RUN getSonLog  IN hGenXml (INPUT 1, INPUT "IsInvoiceDocument":U, OUTPUT tt-docum-est.nff).
         IF tt-docum-est.nff = ? THEN ASSIGN tt-docum-est.nff = FALSE.  
        RUN getSonLog  IN hGenXml (INPUT 1, INPUT "IsRepresentativeComissionCanceled":U, OUTPUT tt-docum-est.estorn-comis).
         IF tt-docum-est.estorn-comis = ? THEN ASSIGN tt-docum-est.estorn-comis = FALSE.  
        RUN getSonLog  IN hGenXml (INPUT 1, INPUT "IsDocumentIssuedByPostSite":U, OUTPUT tt-docum-est.nf-emitida-est).
         IF tt-docum-est.nf-emitida-est = ? THEN ASSIGN tt-docum-est.nf-emitida-est = FALSE.  
        RUN getSonLog  IN hGenXml (INPUT 1, INPUT "IsDistributionDocument":U, OUTPUT tt-docum-est.ind-rateio).
         IF tt-docum-est.ind-rateio = ? THEN ASSIGN tt-docum-est.ind-rateio = FALSE.  
        RUN getSonVal  IN hGenXml (INPUT 1, INPUT "ImportationStatement":U, OUTPUT tt-docum-est.declaracao-import).
         IF tt-docum-est.declaracao-import = ? THEN ASSIGN tt-docum-est.declaracao-import = "".  

        RUN searchTag  IN hGenXml ("DocumentValuesAndTaxes":U, 1, OUTPUT iDocumentValuesAndTaxesId).

            RUN searchTag  IN hGenXml ("Currency":U, iDocumentValuesAndTaxesId, OUTPUT iCurrencyId).
             IF iCurrencyId <> ? THEN DO:
                RUN getSonDec  IN hGenXml (INPUT iCurrencyId, INPUT "CurrencyID":U, OUTPUT tt-docum-est.mo-codigo). 
                 IF tt-docum-est.mo-codigo = ? THEN ASSIGN tt-docum-est.mo-codigo = 0. /* Moeda padr∆o */
                RUN getSonDec  IN hGenXml (INPUT iCurrencyId, INPUT "CurrencyRate":U, OUTPUT tt-docum-est.cotacao-dia).
                 IF tt-docum-est.cotacao-dia = ? THEN ASSIGN tt-docum-est.cotacao-dia = 0.
             END.

             RUN getSonDec  IN hGenXml (INPUT iDocumentValuesAndTaxesId, INPUT "DocumentTotalValue":U, OUTPUT tt-docum-est.tot-valor).
              IF tt-docum-est.tot-valor = ? THEN ASSIGN tt-docum-est.tot-valor = 0.
             RUN getSonDec  IN hGenXml (INPUT iDocumentValuesAndTaxesId, INPUT "PackagingValue":U, OUTPUT tt-docum-est.valor-embal).
              IF tt-docum-est.valor-embal = ? THEN ASSIGN tt-docum-est.valor-embal = 0.
             RUN getSonDec  IN hGenXml (INPUT iDocumentValuesAndTaxesId, INPUT "FreightValue":U, OUTPUT tt-docum-est.valor-frete).
              IF tt-docum-est.valor-frete = ? THEN ASSIGN tt-docum-est.valor-frete = 0.
             RUN getSonDec  IN hGenXml (INPUT iDocumentValuesAndTaxesId, INPUT "GoodsValue":U, OUTPUT tt-docum-est.valor-mercad).
              IF tt-docum-est.valor-mercad = ? THEN ASSIGN tt-docum-est.valor-mercad = 0.
             RUN getSonDec  IN hGenXml (INPUT iDocumentValuesAndTaxesId, INPUT "InsuranceValue":U, OUTPUT tt-docum-est.valor-seguro).
              IF tt-docum-est.valor-seguro = ? THEN ASSIGN tt-docum-est.valor-seguro = 0.
             RUN getSonDec  IN hGenXml (INPUT iDocumentValuesAndTaxesId, INPUT "ExpenseValue":U, OUTPUT tt-docum-est.despesa-nota).
              IF tt-docum-est.despesa-nota = ? THEN ASSIGN tt-docum-est.despesa-nota = 0.
             RUN getSonDec  IN hGenXml (INPUT iDocumentValuesAndTaxesId, INPUT "OtherExpensesValue":U, OUTPUT tt-docum-est.valor-outras).
              IF tt-docum-est.valor-outras = ? THEN ASSIGN tt-docum-est.valor-outras = 0.
             RUN getSonDec  IN hGenXml (INPUT iDocumentValuesAndTaxesId, INPUT "TotalDiscountValue":U, OUTPUT tt-docum-est.tot-desconto).
              IF tt-docum-est.tot-desconto = ? THEN ASSIGN tt-docum-est.tot-desconto = 0.

             RUN searchTag  IN hGenXml ("Taxes":U, iDocumentValuesAndTaxesId, OUTPUT iTaxesId).
              IF iTaxesId <> ? THEN DO:
                 RUN searchTag  IN hGenXml ("BrazilianTaxes":U, iTaxesId, OUTPUT iBrazilianTaxesId).
                  IF iBrazilianTaxesId <> ? THEN DO:

                   RUN searchTag  IN hGenXml ("IndustrializedProductTax":U, iBrazilianTaxesId, OUTPUT iIndustrializedProductTaxId).
                    IF iIndustrializedProductTaxId <> ? THEN DO:
                       RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-docum-est.base-ipi).
                        IF tt-docum-est.base-ipi = ? THEN ASSIGN tt-docum-est.base-ipi = 0.
                       RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxValue":U, OUTPUT tt-docum-est.ipi-deb-cre).
                        IF tt-docum-est.ipi-deb-cre = ? THEN ASSIGN tt-docum-est.ipi-deb-cre = 0.
                       RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-docum-est.ipi-nao-trib).
                        IF tt-docum-est.ipi-nao-trib = ? THEN ASSIGN tt-docum-est.ipi-nao-trib = 0.
                       RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-docum-est.ipi-outras).
                        IF tt-docum-est.ipi-outras = ? THEN ASSIGN tt-docum-est.ipi-outras = 0.
                       RUN getSonDate IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxDueDate":U, OUTPUT tt-docum-est.dt-venc-ipi).
                       RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxOnExpenses":U, OUTPUT tt-docum-est.ipi-despesa).
                        IF tt-docum-est.ipi-despesa = ? THEN ASSIGN tt-docum-est.ipi-despesa = 0.
                    END. /* IndustrializedProductTax */

                   RUN searchTag  IN hGenXml ("ServiceTax":U, iBrazilianTaxesId, OUTPUT iServiceTaxId).
                    IF iServiceTaxId <> ? THEN DO:
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxPercentage":U, OUTPUT tt-docum-est.aliquota-iss).
                        IF tt-docum-est.aliquota-iss = ? THEN ASSIGN aliquota-iss = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-docum-est.base-iss).
                        IF tt-docum-est.base-iss = ? THEN ASSIGN base-iss = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxValue":U, OUTPUT tt-docum-est.iss-deb-cre).
                        IF tt-docum-est.iss-deb-cre = ? THEN ASSIGN tt-docum-est.iss-deb-cre = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-docum-est.iss-nao-trib).
                        IF tt-docum-est.iss-nao-trib = ? THEN ASSIGN tt-docum-est.iss-nao-trib = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-docum-est.iss-outras).
                        IF tt-docum-est.iss-outras = ? THEN ASSIGN tt-docum-est.iss-outras = 0.
                       RUN getSonDate IN hGenXml (INPUT iServiceTaxId, INPUT "TaxDueDate":U, OUTPUT tt-docum-est.dt-venc-iss).
                    END. /* ServiceTax */

                   RUN searchTag  IN hGenXml ("ServicesAndProductsCirculationTax":U, iBrazilianTaxesId, OUTPUT iServicesAndProductsTaxId).
                    IF iServicesAndProductsTaxId <> ? THEN DO:
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxPercentage":U, OUTPUT tt-docum-est.aliquota-icm).
                        IF tt-docum-est.aliquota-icm = ? THEN ASSIGN aliquota-icm = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-docum-est.base-icm).
                        IF tt-docum-est.base-icm = ? THEN ASSIGN base-icm = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxValue":U, OUTPUT tt-docum-est.icm-deb-cre).
                        IF tt-docum-est.icm-deb-cre = ? THEN ASSIGN tt-docum-est.icm-deb-cre = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-docum-est.icm-nao-trib).
                        IF tt-docum-est.icm-nao-trib = ? THEN ASSIGN tt-docum-est.icm-nao-trib = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-docum-est.icm-outras).
                        IF tt-docum-est.icm-outras = ? THEN ASSIGN tt-docum-est.icm-outras = 0.
                       RUN getSonDate IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxDueDate":U, OUTPUT tt-docum-est.dt-venc-icm).
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "FreightTax":U, OUTPUT tt-docum-est.icm-fonte).
                        IF tt-docum-est.icm-fonte = ? THEN ASSIGN tt-docum-est.icm-fonte = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "SupplementaryTax":U, OUTPUT tt-docum-est.icm-complem).
                        IF tt-docum-est.icm-complem = ? THEN ASSIGN tt-docum-est.icm-complem = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TributarySubstitutionBasis":U, OUTPUT tt-docum-est.base-subs).
                        IF tt-docum-est.base-subs = ? THEN ASSIGN tt-docum-est.base-subs = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TributarySubstitutionValue":U, OUTPUT tt-docum-est.vl-subs).
                        IF tt-docum-est.vl-subs = ? THEN ASSIGN tt-docum-est.vl-subs = 0.
                    END. /* ServicesAndProductsCirculationTax */

                   RUN searchTag  IN hGenXml ("SocialIntegrationProgramTax":U, iBrazilianTaxesId, OUTPUT iSocialIntegrationProgramTaxId).
                    IF iSocialIntegrationProgramTaxId <> ? THEN DO:
                       RUN getSonDec  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TributarySubstitutionBasis":U, OUTPUT tt-docum-est.base-pis-subs).
                        IF tt-docum-est.base-pis-subs = ? THEN ASSIGN tt-docum-est.base-pis-subs = 0.
                       RUN getSonDec  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TributarySubstitutionValue":U, OUTPUT tt-docum-est.vl-pis-subs).
                        IF tt-docum-est.vl-pis-subs = ? THEN ASSIGN tt-docum-est.vl-pis-subs = 0.
                    END. /* SocialIntegrationProgramTax */

                   RUN searchTag  IN hGenXml ("SocialSecurityContributionTax":U, iBrazilianTaxesId, OUTPUT iSocialSecurityContributionTaxId).
                    IF iSocialSecurityContributionTaxId <> ? THEN DO:
                       RUN getSonDec  IN hGenXml (INPUT iSocialSecurityContributionTaxId, INPUT "TributarySubstitutionBasis":U, OUTPUT tt-docum-est.base-cofins-subs).
                        IF tt-docum-est.base-cofins-subs = ? THEN ASSIGN tt-docum-est.base-cofins-subs = 0.
                       RUN getSonDec  IN hGenXml (INPUT iSocialSecurityContributionTaxId, INPUT "TributarySubstitutionValue":U, OUTPUT tt-docum-est.vl-cofins-subs).
                        IF tt-docum-est.vl-cofins-subs = ? THEN ASSIGN tt-docum-est.vl-cofins-subs = 0.
                    END. /* SocialSecurityContributionTax */

                   RUN getSonDec  IN hGenXml (INPUT iBrazilianTaxesId, INPUT "TotalTaxValue":U, OUTPUT tt-docum-est.tot-taxa).
                    IF tt-docum-est.tot-taxa = ? THEN ASSIGN tt-docum-est.tot-taxa = 0.

                  END. /* BrazilianTaxes */

              END. /* Taxes */

              RUN searchTag  IN hGenXml ("FASBValuesAndTaxes":U, iDocumentValuesAndTaxesId, OUTPUT iFASBValuesAndTaxesId).
               IF iFASBValuesAndTaxesId <> ? THEN DO:
                  RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "FASBCurrentRate":U, OUTPUT tt-docum-est.cotacao-fasb).
                   IF tt-docum-est.cotacao-fasb = ? THEN ASSIGN tt-docum-est.cotacao-fasb = 0.
                  RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "DocumentTotalValue":U, OUTPUT tt-docum-est.tot-vl-fasb[1]).
                   IF tt-docum-est.tot-vl-fasb[1] = ? THEN ASSIGN tt-docum-est.tot-vl-fasb[1] = 0.
                  RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "PackagingValue":U, OUTPUT tt-docum-est.vl-emb-fasb[1]).
                   IF tt-docum-est.vl-emb-fasb[1] = ? THEN ASSIGN tt-docum-est.vl-emb-fasb[1] = 0.
                  RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "FreigthValue":U, OUTPUT tt-docum-est.vl-fre-fasb[1]).
                   IF tt-docum-est.vl-fre-fasb[1] = ? THEN ASSIGN tt-docum-est.vl-fre-fasb[1] = 0.
                  RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "GoodsValue":U, OUTPUT tt-docum-est.vl-merc-fasb[1]).
                   IF tt-docum-est.vl-merc-fasb[1] = ? THEN ASSIGN tt-docum-est.vl-merc-fasb[1] = 0.
                  RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "InsuranceValue":U, OUTPUT tt-docum-est.vl-seg-fasb[1]).
                   IF tt-docum-est.vl-seg-fasb[1] = ? THEN ASSIGN tt-docum-est.vl-seg-fasb[1] = 0.
                  RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "ExpenseValue":U, OUTPUT tt-docum-est.desp-fasb[1]).
                   IF tt-docum-est.desp-fasb[1] = ? THEN ASSIGN tt-docum-est.desp-fasb[1] = 0.
                  RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "OtherExpensesValue":U, OUTPUT tt-docum-est.vl-out-fasb[1]).
                   IF tt-docum-est.vl-out-fasb[1] = ? THEN ASSIGN tt-docum-est.vl-out-fasb[1] = 0.
                  RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "TotalDiscountValues":U, OUTPUT tt-docum-est.tot-des-fasb[1]).
                   IF tt-docum-est.tot-des-fasb[1] = ? THEN ASSIGN tt-docum-est.tot-des-fasb[1] = 0.

                  RUN searchTag  IN hGenXml ("Taxes":U, iFASBValuesAndTaxesId, OUTPUT iTaxesId).
                   IF iTaxesId <> ? THEN DO:
                      RUN searchTag  IN hGenXml ("BrazilianTaxes":U, iTaxesId, OUTPUT iBrazilianTaxesId).
                       IF iBrazilianTaxesId <> ? THEN DO:

                          RUN searchTag  IN hGenXml ("IndustrializedProductTax":U, iBrazilianTaxesId, OUTPUT iIndustrializedProductTaxId).
                           IF iIndustrializedProductTaxId <> ? THEN DO:
                              RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-docum-est.base-ipi-fas[1]).
                               IF tt-docum-est.base-ipi-fas[1] = ? THEN ASSIGN tt-docum-est.base-ipi-fas[1] = 0.
                              RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxValue":U, OUTPUT tt-docum-est.ipi-dc-fasb[1]).
                               IF tt-docum-est.ipi-dc-fasb[1] = ? THEN ASSIGN tt-docum-est.ipi-dc-fasb[1] = 0.
                              RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-docum-est.ipi-ntr-fasb[1]).
                               IF tt-docum-est.ipi-ntr-fasb[1] = ? THEN ASSIGN tt-docum-est.ipi-ntr-fasb[1] = 0.
                              RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-docum-est.ipi-out-fasb[1]).
                               IF tt-docum-est.ipi-out-fasb[1] = ? THEN ASSIGN tt-docum-est.ipi-out-fasb[1] = 0.
                           END. /* IndustrializedProductTax */

                          RUN searchTag  IN hGenXml ("ServiceTax":U, iBrazilianTaxesId, OUTPUT iServiceTaxId).
                           IF iServiceTaxId <> ? THEN DO:
                              RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-docum-est.base-iss-fas[1]).
                               IF tt-docum-est.base-iss-fas[1] = ? THEN ASSIGN base-iss-fas[1] = 0.
                              RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxValue":U, OUTPUT tt-docum-est.iss-dc-fas[1]).
                               IF tt-docum-est.iss-dc-fas[1] = ? THEN ASSIGN tt-docum-est.iss-dc-fas[1] = 0.
                              RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-docum-est.iss-ntr-fas[1]).
                               IF tt-docum-est.iss-ntr-fas[1] = ? THEN ASSIGN tt-docum-est.iss-ntr-fas[1] = 0.
                               RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-docum-est.iss-out-fas[1]).
                               IF tt-docum-est.iss-out-fas[1] = ? THEN ASSIGN tt-docum-est.iss-out-fas[1] = 0.
                          END. /* ServiceTax */

                          RUN searchTag  IN hGenXml ("ServicesAndProductsCirculationTax":U, iBrazilianTaxesId, OUTPUT iServicesAndProductsTaxId).
                            IF iServicesAndProductsTaxId <> ? THEN DO:
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-docum-est.base-icm-fas[1]).
                                IF tt-docum-est.base-icm-fas[1] = ? THEN ASSIGN base-icm-fas[1] = 0.
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxValue":U, OUTPUT tt-docum-est.icm-dc-fas[1]).
                                IF tt-docum-est.icm-dc-fas[1] = ? THEN ASSIGN tt-docum-est.icm-dc-fas[1] = 0.
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-docum-est.icm-ntr-fas[1]).
                                IF tt-docum-est.icm-ntr-fas[1] = ? THEN ASSIGN tt-docum-est.icm-ntr-fas[1] = 0.
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-docum-est.icm-out-fas[1]).
                                IF tt-docum-est.icm-out-fas[1] = ? THEN ASSIGN tt-docum-est.icm-out-fas[1] = 0.
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "FreightTax":U, OUTPUT tt-docum-est.icm-fnt-fas[1]).
                                IF tt-docum-est.icm-fnt-fas[1] = ? THEN ASSIGN tt-docum-est.icm-fnt-fas[1]= 0.
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "SupplementaryTax":U, OUTPUT tt-docum-est.icm-cpl-fas[1]).
                                IF tt-docum-est.icm-cpl-fas[1] = ? THEN ASSIGN tt-docum-est.icm-cpl-fas[1] = 0.
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TributarySubstitutionBasis":U, OUTPUT tt-docum-est.base-subs-fas[1]).
                                IF tt-docum-est.base-subs-fas[1] = ? THEN ASSIGN tt-docum-est.base-subs-fas[1] = 0.
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TributarySubstitutionValue":U, OUTPUT tt-docum-est.vl-subs-fas[1]).
                                IF tt-docum-est.vl-subs-fas[1] = ? THEN ASSIGN tt-docum-est.vl-subs-fas[1] = 0.
                            END. /* ServicesAndProductsCirculationTax */

                       END. /* BrazilianTaxes */

                   END. /* Taxes */

               END. /* FASBValuesAndTaxes */

              RUN searchTag  IN hGenXml ("CMCACValuesAndTaxes":U, iDocumentValuesAndTaxesId, OUTPUT iCMCACValuesAndTaxesId).
               IF iCMCACValuesAndTaxesId <> ? THEN DO:
                  RUN getSonDec  IN hGenXml (INPUT iCMCACValuesAndTaxesId, INPUT "DocumentTotalValue":U, OUTPUT tt-docum-est.tot-vl-fasb[2]).
                   IF tt-docum-est.tot-vl-fasb[2] = ? THEN ASSIGN tt-docum-est.tot-vl-fasb[2] = 0.
                  RUN getSonDec  IN hGenXml (INPUT iCMCACValuesAndTaxesId, INPUT "PackagingValue":U, OUTPUT tt-docum-est.vl-emb-fasb[2]).
                   IF tt-docum-est.vl-emb-fasb[2] = ? THEN ASSIGN tt-docum-est.vl-emb-fasb[2] = 0.
                  RUN getSonDec  IN hGenXml (INPUT iCMCACValuesAndTaxesId, INPUT "FreigthValue":U, OUTPUT tt-docum-est.vl-fre-fasb[2]).
                   IF tt-docum-est.vl-fre-fasb[2] = ? THEN ASSIGN tt-docum-est.vl-fre-fasb[2] = 0.
                  RUN getSonDec  IN hGenXml (INPUT iCMCACValuesAndTaxesId, INPUT "GoodsValue":U, OUTPUT tt-docum-est.vl-merc-fasb[2]).
                   IF tt-docum-est.vl-merc-fasb[2] = ? THEN ASSIGN tt-docum-est.vl-merc-fasb[2] = 0.
                  RUN getSonDec  IN hGenXml (INPUT iCMCACValuesAndTaxesId, INPUT "InsuranceValue":U, OUTPUT tt-docum-est.vl-seg-fasb[2]).
                   IF tt-docum-est.vl-seg-fasb[2] = ? THEN ASSIGN tt-docum-est.vl-seg-fasb[2] = 0.
                  RUN getSonDec  IN hGenXml (INPUT iCMCACValuesAndTaxesId, INPUT "ExpenseValue":U, OUTPUT tt-docum-est.desp-fasb[2]).
                   IF tt-docum-est.desp-fasb[2] = ? THEN ASSIGN tt-docum-est.desp-fasb[2] = 0.
                  RUN getSonDec  IN hGenXml (INPUT iCMCACValuesAndTaxesId, INPUT "OtherExpensesValue":U, OUTPUT tt-docum-est.vl-out-fasb[2]).
                   IF tt-docum-est.vl-out-fasb[2] = ? THEN ASSIGN tt-docum-est.vl-out-fasb[2] = 0.
                  RUN getSonDec  IN hGenXml (INPUT iCMCACValuesAndTaxesId, INPUT "TotalDiscountValues":U, OUTPUT tt-docum-est.tot-des-fasb[2]).
                   IF tt-docum-est.tot-des-fasb[2] = ? THEN ASSIGN tt-docum-est.tot-des-fasb[2] = 0.

                  RUN searchTag  IN hGenXml ("Taxes":U, iCMCACValuesAndTaxesId, OUTPUT iTaxesId).
                   IF iTaxesId <> ? THEN DO:
                      RUN searchTag  IN hGenXml ("BrazilianTaxes":U, iTaxesId, OUTPUT iBrazilianTaxesId).
                       IF iBrazilianTaxesId <> ? THEN DO:

                          RUN searchTag  IN hGenXml ("IndustrializedProductTax":U, iBrazilianTaxesId, OUTPUT iIndustrializedProductTaxId).
                           IF iIndustrializedProductTaxId <> ? THEN DO:
                              RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-docum-est.base-ipi-fas[2]).
                               IF tt-docum-est.base-ipi-fas[2] = ? THEN ASSIGN tt-docum-est.base-ipi-fas[2] = 0.
                              RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxValue":U, OUTPUT tt-docum-est.ipi-dc-fasb[2]).
                               IF tt-docum-est.ipi-dc-fasb[2] = ? THEN ASSIGN tt-docum-est.ipi-dc-fasb[2] = 0.
                              RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-docum-est.ipi-ntr-fasb[2]).
                               IF tt-docum-est.ipi-ntr-fasb[2] = ? THEN ASSIGN tt-docum-est.ipi-ntr-fasb[2] = 0.
                              RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-docum-est.ipi-out-fasb[2]).
                               IF tt-docum-est.ipi-out-fasb[2] = ? THEN ASSIGN tt-docum-est.ipi-out-fasb[2] = 0.
                           END. /* IndustrializedProductTax */

                          RUN searchTag  IN hGenXml ("ServiceTax":U, iBrazilianTaxesId, OUTPUT iServiceTaxId).
                           IF iServiceTaxId <> ? THEN DO:
                              RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-docum-est.base-iss-fas[2]).
                               IF tt-docum-est.base-iss-fas[2] = ? THEN ASSIGN base-iss-fas[2] = 0.
                              RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxValue":U, OUTPUT tt-docum-est.iss-dc-fas[2]).
                               IF tt-docum-est.iss-dc-fas[2] = ? THEN ASSIGN tt-docum-est.iss-dc-fas[2] = 0.
                              RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-docum-est.iss-ntr-fas[2]).
                               IF tt-docum-est.iss-ntr-fas[2] = ? THEN ASSIGN tt-docum-est.iss-ntr-fas[2] = 0.
                               RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-docum-est.iss-out-fas[2]).
                               IF tt-docum-est.iss-out-fas[2] = ? THEN ASSIGN tt-docum-est.iss-out-fas[2] = 0.
                          END. /* ServiceTax */

                          RUN searchTag  IN hGenXml ("ServicesAndProductsCirculationTax":U, iBrazilianTaxesId, OUTPUT iServicesAndProductsTaxId).
                            IF iServicesAndProductsTaxId <> ? THEN DO:
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-docum-est.base-icm-fas[2]).
                                IF tt-docum-est.base-icm-fas[2] = ? THEN ASSIGN base-icm-fas[2] = 0.
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxValue":U, OUTPUT tt-docum-est.icm-dc-fas[2]).
                                IF tt-docum-est.icm-dc-fas[2] = ? THEN ASSIGN tt-docum-est.icm-dc-fas[2] = 0.
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-docum-est.icm-ntr-fas[2]).
                                IF tt-docum-est.icm-ntr-fas[2] = ? THEN ASSIGN tt-docum-est.icm-ntr-fas[2] = 0.
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-docum-est.icm-out-fas[2]).
                                IF tt-docum-est.icm-out-fas[2] = ? THEN ASSIGN tt-docum-est.icm-out-fas[2] = 0.
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "FreightTax":U, OUTPUT tt-docum-est.icm-fnt-fas[2]).
                                IF tt-docum-est.icm-fnt-fas[2] = ? THEN ASSIGN tt-docum-est.icm-fnt-fas[2]= 0.
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "SupplementaryTax":U, OUTPUT tt-docum-est.icm-cpl-fas[2]).
                                IF tt-docum-est.icm-cpl-fas[2] = ? THEN ASSIGN tt-docum-est.icm-cpl-fas[2] = 0.
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TributarySubstitutionBasis":U, OUTPUT tt-docum-est.base-subs-fas[2]).
                                IF tt-docum-est.base-subs-fas[2] = ? THEN ASSIGN tt-docum-est.base-subs-fas[2] = 0.
                               RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TributarySubstitutionValue":U, OUTPUT tt-docum-est.vl-subs-fas[2]).
                                IF tt-docum-est.vl-subs-fas[2] = ? THEN ASSIGN tt-docum-est.vl-subs-fas[2] = 0.
                            END. /* ServicesAndProductsCirculationTax */

                       END. /*  BrazilianTaxes */

                   END. /* Taxes */

               END. /* CMCACValuesAndTaxes */

              RUN searchTag  IN hGenXml ("ForeignValuesAndTaxes":U, iDocumentValuesAndTaxesId, OUTPUT iForeignValuesAndTaxesId).
               IF iForeignValuesAndTaxesId <> ? THEN DO:
                  RUN getSonDec  IN hGenXml (INPUT iForeignValuesAndTaxesId, INPUT "DocumentTotalValue":U, OUTPUT tt-docum-est.tot-valor-me).
                   IF tt-docum-est.tot-valor-me = ? THEN ASSIGN tt-docum-est.tot-valor-me = 0.
                  RUN getSonDec  IN hGenXml (INPUT iForeignValuesAndTaxesId, INPUT "PackagingValue":U, OUTPUT tt-docum-est.valor-embal-me).
                   IF tt-docum-est.valor-embal-me = ? THEN ASSIGN tt-docum-est.valor-embal-me = 0.
                  RUN getSonDec  IN hGenXml (INPUT iForeignValuesAndTaxesId, INPUT "FreigthValue":U, OUTPUT tt-docum-est.valor-frete-me).
                   IF tt-docum-est.valor-frete-me = ? THEN ASSIGN tt-docum-est.valor-frete-me = 0.
                  RUN getSonDec  IN hGenXml (INPUT iForeignValuesAndTaxesId, INPUT "GoodsValue":U, OUTPUT tt-docum-est.valor-mercad-me).
                   IF tt-docum-est.valor-mercad-me = ? THEN ASSIGN tt-docum-est.valor-mercad-me = 0.
                  RUN getSonDec  IN hGenXml (INPUT iForeignValuesAndTaxesId, INPUT "InsuranceValue":U, OUTPUT tt-docum-est.valor-seguro-me).
                   IF tt-docum-est.valor-seguro-me= ? THEN ASSIGN tt-docum-est.valor-seguro-me = 0.
                  RUN getSonDec  IN hGenXml (INPUT iForeignValuesAndTaxesId, INPUT "ExpenseValue":U, OUTPUT tt-docum-est.despesa-nota-me).
                   IF tt-docum-est.despesa-nota-me = ? THEN ASSIGN tt-docum-est.despesa-nota-me = 0.
                  RUN getSonDec  IN hGenXml (INPUT iForeignValuesAndTaxesId, INPUT "OtherExpensesValue":U, OUTPUT tt-docum-est.valor-outras-me).
                   IF tt-docum-est.valor-outras-me = ? THEN ASSIGN tt-docum-est.valor-outras-me = 0.
                  RUN getSonDec  IN hGenXml (INPUT iForeignValuesAndTaxesId, INPUT "TotalDiscountValues":U, OUTPUT tt-docum-est.tot-desconto-me).
                   IF tt-docum-est.tot-desconto-me = ? THEN ASSIGN tt-docum-est.tot-desconto-me = 0.

                  RUN searchTag  IN hGenXml ("Taxes":U, iForeignValuesAndTaxesId, OUTPUT iTaxesId).
                   IF iTaxesId <> ? THEN 
                      RUN getSonDec  IN hGenXml (INPUT iTaxesId, INPUT "TotalTaxValues":U, OUTPUT tt-docum-est.tot-taxa-me).
                       IF tt-docum-est.tot-taxa-me = ? THEN ASSIGN tt-docum-est.tot-taxa-me = 0.

               END. /* ForeignValuesAndTaxes*/

        RUN pi-verificarNaturezaAtivo (OUTPUT c-ativo).
        RUN PIEngineRegras (INPUT cTranAction).
        IF RETURN-VALUE <> "OK" THEN RETURN RETURN-VALUE. 

        RUN pi-cria-tt-item-doc-est (INPUT tt-docum-est.cod-emitente,
                                     INPUT tt-docum-est.nro-docto,
                                     INPUT tt-docum-est.serie-docto,
                                     INPUT tt-docum-est.nat-operacao).  

        RUN pi-cria-tt-dupli-apagar (INPUT tt-docum-est.cod-emitente,
                                     INPUT tt-docum-est.nro-docto,
                                     INPUT tt-docum-est.serie-docto,
                                     INPUT tt-docum-est.nat-operacao).


        RUN pi-cria-tt-rat-docum   (INPUT tt-docum-est.cod-emitente,
                                    INPUT tt-docum-est.nro-docto,
                                    INPUT tt-docum-est.serie-docto,
                                    INPUT tt-docum-est.nat-operacao,
                                    INPUT tt-docum-est.valor-mercad).

    END.  /*  add/upd  */

    IF cTranAction = "del":U THEN DO: /* del */

       RUN PIEngineRegras (INPUT cTranAction).
       IF RETURN-VALUE <> "OK" THEN RETURN RETURN-VALUE. 

       /* rotina para desatualizar estoque do documento*/
       FOR FIRST docum-est WHERE  
                 docum-est.serie-docto  = tt-docum-est.serie-docto  AND  
                 docum-est.nro-docto    = tt-docum-est.nro-docto    AND 
                 docum-est.cod-emitente = tt-docum-est.cod-emitente AND  
                 docum-est.nat-operacao = tt-docum-est.nat-operacao NO-LOCK :
          IF docum-est.ce-atual THEN DO:

             EMPTY TEMP-TABLE tt-erro-re0402.
             RUN rep/re0402a.p (INPUT ROWID(docum-est),
                                INPUT NO,
                                INPUT NO,
                                INPUT NO,
                                INPUT NO,
                                INPUT NO,
                                INPUT 1,
                                INPUT NO,
                                INPUT NO,
                                INPUT NO,
                                INPUT NO,
                                OUTPUT l-erro,
                                OUTPUT TABLE tt-erro-re0402).
             FOR EACH tt-erro-re0402 NO-LOCK:
                 CREATE tt_log_erro. 
                 ASSIGN tt_log_erro.ttv_num_cod_erro  = tt-erro-re0402.cd-erro    
                        tt_log_erro.ttv_des_msg_ajuda = "business_error"
                        tt_log_erro.ttv_des_msg_erro  = tt-erro-re0402.mensagem.                                        
    
             END.
             IF l-erro THEN RETURN "NOK".
          END.
       END.
    END. /*del*/

END PROCEDURE.


PROCEDURE pi-cria-tt-item-doc-est: /*  Cria registro na temp-table tt-item-doc-est  */


 DEF INPUT PARAM i-cod-emitente LIKE tt-docum-est.cod-emitente NO-UNDO.
 DEF INPUT PARAM c-nro-docto    LIKE tt-docum-est.nro-docto    NO-UNDO.
 DEF INPUT PARAM c-serie-docto  LIKE tt-docum-est.serie-docto  NO-UNDO.
 DEF INPUT PARAM c-nat-operacao LIKE tt-docum-est.nat-operacao NO-UNDO.

 DEF VAR iBinLocationId                  AS INT NO-UNDO.
 DEF VAR iCollectionSiteId               AS INT NO-UNDO.
 DEF VAR iCustomerVendorId               AS INT NO-UNDO.
 DEF VAR iDocumentItemId                 AS INT NO-UNDO.
 DEF VAR iFiscalClassificationId         AS INT NO-UNDO.
 DEF VAR iGeneralLedgerAccountId         AS INT NO-UNDO.
 DEF VAR iGoodsDeliveryId                AS INT NO-UNDO.
 DEF VAR iImportationTaxesId             AS INT NO-UNDO.
 DEF VAR iImportInformationId            AS INT NO-UNDO.
 DEF VAR iItemId                         AS INT NO-UNDO.
 DEF VAR iItemValuesAndTaxesId           AS INT NO-UNDO.
 DEF VAR iListOfDocumentItensId          AS INT NO-UNDO.
 DEF VAR iLocationId                     AS INT NO-UNDO.
 DEF VAR iManufacturingOrderNumberId     AS INT NO-UNDO.
 DEF VAR iManufactureRouteId             AS INT NO-UNDO.
 DEF VAR iNextDocumentItemId             AS INT NO-UNDO.
 DEF VAR iOrderOperationId               AS INT NO-UNDO.
 DEF VAR iParentItemId                   AS INT NO-UNDO.
 DEF VAR iPurchaseOrderId                AS INT NO-UNDO.
 DEF VAR iSalesOrderId                   AS INT NO-UNDO.
 DEF VAR iSourceDocumentId               AS INT NO-UNDO.
 DEF VAR iSubContractId                  AS INT NO-UNDO.
 DEF VAR iSubContractVendorId            AS INT NO-UNDO.
 DEF VAR iSupplementaryFiscalOperationId AS INT NO-UNDO.
 DEF VAR iUnitOfMeasureId                AS INT NO-UNDO.
 DEF VAR iWarehouseId                    AS INT NO-UNDO.

 DEF VAR c-tax-code     AS CHAR NO-UNDO.
 DEF VAR c-tax-perc     AS CHAR NO-UNDO.
 DEF VAR c-tax-basis    AS CHAR NO-UNDO.
 DEF VAR c-tax-value    AS CHAR NO-UNDO.
 DEF VAR c-tax-red-perc AS CHAR NO-UNDO.
 DEF VAR i-sequencia    AS INT  NO-UNDO.


 RUN searchTag IN hGenXml ("ListOfDocumentItens":U, 1, OUTPUT iListOfDocumentItensId).
  IF iListOfDocumentItensId <> ? THEN DO:

   RUN getFirstSonId IN hGenXml (iListOfDocumentItensId, OUTPUT iDocumentItemId).
    DO WHILE iDocumentItemId <> ?:

      RUN getSonDec IN hGenXml (INPUT iDocumentItemId, INPUT "Sequence":U, OUTPUT i-sequencia).

      IF CAN-FIND (FIRST tt-item-doc-est WHERE
                         tt-item-doc-est.cod-emitente = i-cod-emitente  AND
                         tt-item-doc-est.nro-docto    = c-nro-docto     AND
                         tt-item-doc-est.serie-docto  = c-serie-docto   AND
                         tt-item-doc-est.nat-operacao = c-nat-operacao  AND
                         tt-item-doc-est.sequencia    = i-sequencia )   THEN DO:

             CREATE tt-erro.
             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "J†_existe_Item_da_Nota_Fiscal_com_a_chave_informada" *}
             ASSIGN tt-erro.identif-segment = ""
                    tt-erro.cd-erro         = 7
                    tt-erro.desc-erro       = RETURN-VALUE.

             UNDO, LEAVE.
      END.

      CREATE tt-item-doc-est.

      /*** Campos Chave ***/
      ASSIGN tt-item-doc-est.cod-emitente = i-cod-emitente
             tt-item-doc-est.nro-docto    = c-nro-docto
             tt-item-doc-est.serie-docto  = c-serie-docto
             tt-item-doc-est.nat-operacao = c-nat-operacao
             tt-item-doc-est.sequencia    = i-sequencia .
      /***********************/

      RUN searchTag IN hGenXml ("Item":U, iDocumentItemId, OUTPUT iItemId).
      RUN getSonVal IN hGenXml (INPUT iItemId, INPUT "ItemCode":U, OUTPUT tt-item-doc-est.it-codigo).
      RUN getSonVal IN hGenXml (INPUT iItemId, INPUT "ItemReferenceCode":U, OUTPUT tt-item-doc-est.cod-refer).

      RUN searchTag IN hGenXml ("UnitOfMeasure":U, iItemId, OUTPUT iUnitOfMeasureId).
       IF iUnitOfMeasureId <> ? THEN 
          RUN getSonVal IN hGenXml (INPUT iUnitOfMeasureId, INPUT "UnitOfMeasureCode":U, OUTPUT tt-item-doc-est.un).

      RUN searchTag IN hGenXml ("Location":U, iDocumentItemId, OUTPUT iLocationId).
       IF iLocationId <> ? THEN DO:

          RUN searchTag IN hGenXml ("Warehouse":U, iLocationId, OUTPUT iWarehouseId).
           IF iWarehouseId <> ? THEN
              RUN getSonVal IN hGenXml (INPUT iWarehouseId, INPUT "WarehouseID":U, OUTPUT tt-item-doc-est.cod-depos).

          RUN searchTag IN hGenXml ("BinLocation":U, iLocationId, OUTPUT iBinLocationId).
           IF iBinLocationId <> ? THEN 
              RUN getSonVal IN hGenXml (INPUT iBinLocationId, INPUT "BinLocationID":U, OUTPUT tt-item-doc-est.cod-localiz).

          RUN getSonVal  IN hGenXml (INPUT iLocationId, INPUT "LotOrSerialNumber":U, OUTPUT tt-item-doc-est.lote).       
          RUN getSonDate IN hGenXml (INPUT iLocationId, INPUT "LotValidityDate":U, OUTPUT tt-item-doc-est.dt-vali-lote).

       END. /* Location */

      RUN searchTag IN hGenXml ("FiscalClassification":U, iDocumentItemId, OUTPUT iFiscalClassificationId).
       IF iFiscalClassificationId <> ? THEN 
          RUN getSonVal  IN hGenXml (INPUT iFiscalClassificationId, INPUT "FiscalClassificationID":U, OUTPUT tt-item-doc-est.class-fiscal).       

      RUN searchTag IN hGenXml ("GeneralLedgerAccount":U, iDocumentItemId, OUTPUT iGeneralLedgerAccountId).
       IF iGeneralLedgerAccountId <> ? THEN DO:
          RUN getSonVal IN hGenXml (INPUT iGeneralLedgerAccountId, INPUT "AccountNumber":U,    OUTPUT tt-item-doc-est.ct-codigo).
          RUN getSonVal IN hGenXml (INPUT iGeneralLedgerAccountId, INPUT "SubAccountNumber":U, OUTPUT tt-item-doc-est.sc-codigo).
       END. /*  GeneralLedgerAccount */

      RUN searchTag IN hGenXml ("PurchaseOrder":U, iDocumentItemId, OUTPUT iPurchaseOrderId).
       IF iPurchaseOrderId <> ? THEN DO:
          RUN getSonDec IN hGenXml (INPUT iPurchaseOrderId, INPUT "PurchaseOrderNumber":U, OUTPUT tt-item-doc-est.num-pedido).
           IF tt-item-doc-est.num-pedido = ? THEN ASSIGN tt-item-doc-est.num-pedido = 0.
          RUN getSonDec IN hGenXml (INPUT iPurchaseOrderId, INPUT "PurchaseRequisitionNumber":U, OUTPUT tt-item-doc-est.numero-ordem).
           IF tt-item-doc-est.numero-ordem = ? THEN ASSIGN tt-item-doc-est.numero-ordem = 0.
          RUN getSonDec IN hGenXml (INPUT iPurchaseOrderId, INPUT "PurchaseRequisitionScheduleID":U, OUTPUT tt-item-doc-est.parcela).    
           IF tt-item-doc-est.parcela = ? THEN ASSIGN tt-item-doc-est.parcela = 0.
          RUN getSonLog IN hGenXml (INPUT iPurchaseOrderId, INPUT "IsFIFOAppliedToPurchaseRequisitions":U, OUTPUT tt-item-doc-est.log-fifo-oc).    
           IF tt-item-doc-est.log-fifo-oc = ? THEN ASSIGN tt-item-doc-est.log-fifo-oc = FALSE.
          RUN getSonLog IN hGenXml (INPUT iPurchaseOrderId, INPUT "IsFIFOAppliedToPurchaseRequisitions":U, OUTPUT tt-item-doc-est.log-1).    
           IF tt-item-doc-est.log-1 = ? THEN ASSIGN tt-item-doc-est.log-1 = FALSE.
       END. /* PurchaseOrder */

      RUN searchTag  IN hGenXml ("ManufacturingOrderNumber":U, iDocumentItemId, OUTPUT iManufacturingOrderNumberId).
      RUN getSonDec  IN hGenXml (INPUT iDocumentItemId, INPUT "ManufacturingOrderNumber":U, OUTPUT tt-item-doc-est.nr-ord-produ).
        IF tt-item-doc-est.nr-ord-produ = ? THEN ASSIGN tt-item-doc-est.nr-ord-produ = 0.

      RUN searchTag  IN hGenXml ("OrderOperation":U, iDocumentItemId, OUTPUT iOrderOperationId).
       IF iOrderOperationId <> ? THEN DO:
          RUN getSonDec IN hGenXml (INPUT iOrderOperationId, INPUT "OrderOperationCode":U, OUTPUT tt-item-doc-est.op-codigo).
           IF tt-item-doc-est.op-codigo = ? THEN ASSIGN tt-item-doc-est.op-codigo = 0.

          RUN searchTag IN hGenXml ("ManufactureRoute":U, iOrderOperationId, OUTPUT iManufactureRouteId).
           IF iManufactureRouteId <> ? THEN
              RUN getSonVal IN hGenXml (INPUT iManufactureRouteId, INPUT "RouteID":U, OUTPUT tt-item-doc-est.cod-roteiro).
               IF tt-item-doc-est.cod-roteiro = ? THEN ASSIGN tt-item-doc-est.cod-roteiro = "".

          RUN searchTag IN hGenXml ("ParentItem":U, iOrderOperationId, OUTPUT iParentItemId).
           IF iParentItemId <> ? THEN
              RUN getSonVal IN hGenXml (INPUT iParentItemId, INPUT "ParentItemCode":U, OUTPUT tt-item-doc-est.item-pai).
       END. /* OrderOperation */

      RUN searchTag  IN hGenXml ("SalesOrder":U, iDocumentItemId, OUTPUT iSalesOrderId).
       IF iSalesOrderId <> ? THEN DO:
          RUN getSonVal IN hGenXml (INPUT iSalesOrderId, INPUT "CustomerOrderNumber":U, OUTPUT tt-item-doc-est.nr-pedcli).
          RUN getSonDec IN hGenXml (INPUT iSalesOrderId, INPUT "OrderLine":U, OUTPUT tt-item-doc-est.nr-pd-seq).
          RUN getSonDec IN hGenXml (INPUT iSalesOrderId, INPUT "DeliverySequence":U, OUTPUT tt-item-doc-est.nr-pd-ent).
          RUN getSonDec IN hGenXml (INPUT iSalesOrderId, INPUT "OrderLine":U, OUTPUT tt-item-doc-est.nr-pd-seq).
          RUN getSonLog IN hGenXml (INPUT iSalesOrderId, INPUT "IsCustomerOrderReopenedByDocumentItem":U, OUTPUT tt-item-doc-est.reabre-pd).
            IF tt-item-doc-est.reabre-pd = ? THEN ASSIGN tt-item-doc-est.reabre-pd = FALSE.
       END. /* SalesOrder */

      RUN getSonDec IN hGenXml (INPUT iDocumentItemId, INPUT "InspectionRouteNumber":U, OUTPUT tt-item-doc-est.nr-ficha).
       IF tt-item-doc-est.nr-ficha = ? THEN ASSIGN tt-item-doc-est.nr-ficha = 0.
      RUN getSonDec IN hGenXml (INPUT iDocumentItemId, INPUT "ProjectControlOrderNumber":U, OUTPUT tt-item-doc-est.num-ord-inv).
       IF tt-item-doc-est.num-ord-inv = ? THEN ASSIGN tt-item-doc-est.num-ord-inv = 0.
      RUN getSonVal IN hGenXml (INPUT iDocumentItemId, INPUT "Narrative":U, OUTPUT tt-item-doc-est.narrativa).
        IF tt-item-doc-est.narrativa = ? THEN ASSIGN tt-item-doc-est.narrativa = "".
      RUN getSonLog IN hGenXml (INPUT iDocumentItemId, INPUT "IsComponent":U, OUTPUT tt-item-doc-est.componente).
        IF tt-item-doc-est.componente = ? THEN ASSIGN tt-item-doc-est.componente = FALSE.

      RUN searchTag  IN hGenXml ("SourceDocument":U, iDocumentItemId, OUTPUT iSourceDocumentId).
       IF iSourceDocumentId <> ? THEN DO:
          RUN getSonVal IN hGenXml (INPUT iSourceDocumentId, INPUT "DocumentNumber":U, OUTPUT tt-item-doc-est.nro-comp).
          RUN getSonVal IN hGenXml (INPUT iSourceDocumentId, INPUT "DocumentSeries":U, OUTPUT tt-item-doc-est.serie-comp).

          RUN searchTag IN hGenXml ("Vendor":U, iSourceDocumentId, OUTPUT iVendorId).
          RUN getSonDec IN hGenXml (INPUT iVendorId, INPUT "VendorID":U, OUTPUT  tt-item-doc-est.emite-comp).
            IF  tt-item-doc-est.emite-comp = ? THEN DO:

               RUN getSonVal IN hGenXml (INPUT iVendorId, INPUT "VendorShortName":U, OUTPUT c-nome-abrev).
               RUN getSonVal IN hGenXml (INPUT iVendorId, INPUT "VendorTaxID":U, OUTPUT c-cgc).

               RUN pi-procura-emitente (c-cgc,
                                        c-nome-abrev,
                                        OUTPUT  tt-item-doc-est.emite-comp).
            END.

           RUN getSonDec IN hGenXml (INPUT iSourceDocumentId, INPUT "Sequence":U, OUTPUT tt-item-doc-est.seq-comp).           
       END. /* SourceDocument */

      RUN searchTag  IN hGenXml ("SubContract":U, iDocumentItemId, OUTPUT iSubContractId).
       IF iSubContractId <> ? THEN DO:

          RUN searchTag IN hGenXml ("SubContractVendor":U, iSubContractId, OUTPUT iSubContractVendorId).
           IF iSubContractVendorId <> ? THEN DO:
              RUN getSonDec IN hGenXml (INPUT iSubContractVendorId, INPUT "SubContractVendorID":U, OUTPUT tt-item-doc-est.cod-emit-benef).           
               IF tt-item-doc-est.cod-emit-benef = ? THEN DO:
                RUN getSonVal IN hGenXml (INPUT iSubContractVendorId, INPUT "SubContractVendorShortName":U, OUTPUT c-nome-abrev).
                RUN getSonVal IN hGenXml (INPUT iSubContractVendorId, INPUT "SubContractVendorTaxID":U, OUTPUT c-cgc).

                RUN pi-procura-emitente (c-cgc,
                                         c-nome-abrev,
                                         OUTPUT tt-item-doc-est.cod-emit-benef).
               END.
           END. /* SubContractVendor */

          RUN getSonDec IN hGenXml (INPUT iSubContractId, INPUT "SubContractDispatchSource":U, OUTPUT tt-item-doc-est.origem).
       END. /* SubContract */

      RUN getSonDate IN hGenXml (INPUT iDocumentItemId, INPUT "IssueDocumentDate":U, OUTPUT tt-item-doc-est.data-comp).
      RUN getSonDate IN hGenXml (INPUT iDocumentItemId, INPUT "ForecastDeliveryDate":U, OUTPUT tt-item-doc-est.dt-ent-prev).
      RUN getSonDate IN hGenXml (INPUT iDocumentItemId, INPUT "SupplementaryDocumentDate":U, OUTPUT tt-item-doc-est.dt-nota-comp).

      RUN searchTag  IN hGenXml ("SupplementaryFiscalOperation":U, iDocumentItemId, OUTPUT iSupplementaryFiscalOperationId).
       IF iSupplementaryFiscalOperationId <> ? THEN 
          RUN getSonVal IN hGenXml (INPUT iSupplementaryFiscalOperationId, INPUT "FiscalOperationCode":U, OUTPUT tt-item-doc-est.nat-comp).  

      RUN searchTag  IN hGenXml ("ImportInformation":U, iDocumentItemId, OUTPUT iImportInformationId).
       IF iImportInformationId <> ? THEN DO:
          RUN getSonDec IN hGenXml (INPUT iImportInformationId, INPUT "ImportLicenseNumber":U, OUTPUT tt-item-doc-est.i-nr-gi).  
          RUN getSonVal IN hGenXml (INPUT iImportInformationId, INPUT "InvoiceNumber":U, OUTPUT tt-item-doc-est.c-nr-invoice).  
          RUN getSonDec IN hGenXml (INPUT iImportInformationId, INPUT "InvoiceSequence":U, OUTPUT tt-item-doc-est.i-seq-inv).  
          RUN getSonVal IN hGenXml (INPUT iImportInformationId, INPUT "ImportationStatement":U, OUTPUT tt-item-doc-est.declaracao-import).  
          RUN getSonVal IN hGenXml (INPUT iImportInformationId, INPUT "ImportProcessNumber":U, OUTPUT tt-item-doc-est.nr-proc-imp).  
       END. /* ImportInformation */

      RUN getSonDec IN hGenXml (INPUT iDocumentItemId, INPUT "RestituitionPercentage":U, OUTPUT tt-item-doc-est.pc-restituicao).  
       IF tt-item-doc-est.pc-restituicao = ? THEN ASSIGN tt-item-doc-est.pc-restituicao  = 0.
      RUN getSonVal IN hGenXml (INPUT iDocumentItemId, INPUT "RestituitionLevel":U, OUTPUT tt-item-doc-est.nivel-restituicao).  
       IF tt-item-doc-est.nivel-restituicao = ? THEN ASSIGN tt-item-doc-est.nivel-restituicao = "".

      RUN searchTag  IN hGenXml ("CollectionSite":U, iDocumentItemId, OUTPUT iCollectionSiteId).
       IF iCollectionSiteId <> ? THEN 
          RUN getSonVal IN hGenXml (INPUT iCollectionSiteId, INPUT "SiteID":U, OUTPUT tt-item-doc-est.est-cob).  

      RUN getSonDec  IN hGenXml (INPUT iDocumentItemId, INPUT "APStatus":U, OUTPUT tt-item-doc-est.sit-item).  
       IF tt-item-doc-est.sit-item = ? THEN ASSIGN tt-item-doc-est.sit-item = 1.

      &IF '{&BF_DIS_VERSAO_EMS}' >= "2.042":U &THEN
         RUN getSonVal  IN hGenXml (INPUT iDocumentItemId, INPUT "RMASequenceNumber":U, OUTPUT tt-item-doc-est.num-seq-rma).
      &ENDIF

      &IF '{&BF_DIS_VERSAO_EMS}' > "2.04":U &THEN
         RUN searchTag  IN hGenXml ("Restoking":U, iDocumentItemId, OUTPUT iRestokingId).
          IF iRestokingId <> ? THEN DO:
             RUN getSonDec IN hGenXml (INPUT iRestokingId, INPUT "VendorsRestokingPercentage":U, OUTPUT tt-item-doc-est.val-perc-restocagem).
             RUN getSonDec IN hGenXml (INPUT iRestokingId, INPUT "VendorRestokingValue":U, OUTPUT tt-item-doc-est.val-restocagem).
          END. /* Restoking */
      &ENDIF

      &IF '{&BF_DIS_VERSAO_EMS}' >= "2.05":U &THEN
         RUN getSonLog  IN hGenXml (INPUT iDocumentItemId, INPUT "IsCreditDocumentCreatedInAP":U, OUTPUT tt-item-doc-est.log-geracao-ncr-ap).
      &ENDIF

      RUN searchTag  IN hGenXml ("GoodsDelivery":U, iDocumentItemId, OUTPUT iGoodsDeliveryId).
        IF iGoodsDeliveryId <> ? THEN DO:
           RUN getSonVal IN hGenXml (INPUT iGoodsDeliveryId, INPUT "DocumentSeries":U, OUTPUT tt-item-doc-est.serie-terc).  
           RUN getSonVal IN hGenXml (INPUT iGoodsDeliveryId, INPUT "DocumentNumber":U, OUTPUT tt-item-doc-est.nro-docto-terc).  

           RUN searchTag IN hGenXml ("CustomerVendor":U, iGoodsDeliveryId, OUTPUT iCustomerVendorId).
           RUN getSonDec IN hGenXml (INPUT iCustomerVendorId, INPUT "CustomerVendorID":U, OUTPUT tt-item-doc-est.cod-emit-terc).           
            IF tt-item-doc-est.cod-emit-terc = ? THEN DO:
             RUN getSonVal IN hGenXml (INPUT iCustomerVendorId, INPUT "CustomerVendorShortName":U, OUTPUT c-nome-abrev).
             RUN getSonVal IN hGenXml (INPUT iCustomerVendorId, INPUT "CustomerVendorTaxID":U, OUTPUT c-cgc).

                RUN pi-procura-emitente (c-cgc,
                                         c-nome-abrev,
                                         OUTPUT tt-item-doc-est.cod-emit-terc).
            END.

           RUN searchTag IN hGenXml ("FiscalOperation":U, iGoodsDeliveryId, OUTPUT iFiscalOperationId).
            IF iFiscalOperationId <> ? THEN 
               RUN getSonVal IN hGenXml (INPUT iFiscalOperationId, INPUT "FiscalOperationCode":U, OUTPUT tt-item-doc-est.nat-terc).

           RUN getSonDec IN hGenXml (INPUT iGoodsDeliveryId, INPUT "Sequence":U, OUTPUT tt-item-doc-est.seq-terc).
        END. /* GoodsDelivery */

      RUN getSonDec IN hGenXml (INPUT iDocumentItemId, INPUT "NetWeight":U, OUTPUT tt-item-doc-est.peso-liquido).
       IF tt-item-doc-est.peso-liquido = ? THEN ASSIGN tt-item-doc-est.peso-liquido = 0.
        RUN getSonDec IN hGenXml (INPUT iDocumentItemId, INPUT "Quantity":U, OUTPUT tt-item-doc-est.quantidade).
       IF tt-item-doc-est.quantidade = ? THEN ASSIGN tt-item-doc-est.quantidade = 0.
        RUN getSonDec IN hGenXml (INPUT iDocumentItemId, INPUT "VendorQuantity":U, OUTPUT tt-item-doc-est.qt-do-forn).
       IF tt-item-doc-est.qt-do-forn = ? THEN ASSIGN tt-item-doc-est.qt-do-forn = 0.
        RUN getSonDec IN hGenXml (INPUT iDocumentItemId, INPUT "ReceivedQuantity":U, OUTPUT tt-item-doc-est.qt-real).
       IF tt-item-doc-est.qt-real = ? THEN ASSIGN tt-item-doc-est.qt-real = 0.
        RUN getSonDec IN hGenXml (INPUT iDocumentItemId, INPUT "BalanceQuantity":U, OUTPUT tt-item-doc-est.qt-saldo).
       IF tt-item-doc-est.qt-saldo = ? THEN ASSIGN tt-item-doc-est.qt-saldo = 0.
        RUN getSonDec IN hGenXml (INPUT iDocumentItemId, INPUT "CheckedQuantity":U, OUTPUT tt-item-doc-est.quant-conf).
       IF tt-item-doc-est.quant-conf = ? THEN ASSIGN tt-item-doc-est.quant-conf = 0.

      RUN searchTag  IN hGenXml ("ItemValuesAndTaxes":U, iDocumentItemId, OUTPUT iItemValuesAndTaxesId).

      RUN getSonDec IN hGenXml (INPUT iItemValuesAndTaxesId, INPUT "UnitPrice":U, OUTPUT tt-item-doc-est.preco-unit[1]).  
      RUN getSonDec IN hGenXml (INPUT iItemValuesAndTaxesId, INPUT "TotalPrice":U, OUTPUT tt-item-doc-est.preco-total[1]).  
      RUN getSonDec IN hGenXml (INPUT iItemValuesAndTaxesId, INPUT "ExpenseValue":U, OUTPUT tt-item-doc-est.despesas[1]).  
       IF tt-item-doc-est.despesas[1] =  ? THEN ASSIGN tt-item-doc-est.despesas[1] = 0.
      RUN getSonDec IN hGenXml (INPUT iItemValuesAndTaxesId, INPUT "DiscountValue":U, OUTPUT tt-item-doc-est.desconto[1]).  
       IF tt-item-doc-est.desconto[1] =  ? THEN ASSIGN tt-item-doc-est.desconto[1] = 0.
      RUN getSonDec IN hGenXml (INPUT iItemValuesAndTaxesId, INPUT "LaborValue":U, OUTPUT tt-item-doc-est.pre-unit-mob[1]).  
       IF tt-item-doc-est.pre-unit-mob[1] =  ? THEN ASSIGN tt-item-doc-est.pre-unit-mob[1] = 0.
      RUN getSonDec IN hGenXml (INPUT iItemValuesAndTaxesId, INPUT "FreightValue":U, OUTPUT tt-item-doc-est.valor-frete).  
       IF tt-item-doc-est.valor-frete =  ? THEN ASSIGN tt-item-doc-est.valor-frete = 0.

      RUN searchTag  IN hGenXml ("Taxes":U, iItemValuesAndTaxesId, OUTPUT iTaxesId).
       IF iTaxesId <> ? THEN DO:
          RUN searchTag  IN hGenXml ("BrazilianTaxes":U, iTaxesId, OUTPUT iBrazilianTaxesId).
           IF iBrazilianTaxesId <> ? THEN DO:

                  RUN searchTag  IN hGenXml ("IndustrializedProductTax":U, iBrazilianTaxesId, OUTPUT iIndustrializedProductTaxId).
                   IF iIndustrializedProductTaxId <> ? THEN DO:
                      RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxCode":U, OUTPUT tt-item-doc-est.cd-trib-ipi).
                       IF tt-item-doc-est.cd-trib-ipi = ? THEN ASSIGN tt-item-doc-est.cd-trib-ipi = 1.
                      RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxPercentage":U, OUTPUT tt-item-doc-est.aliquota-ipi).
                       IF tt-item-doc-est.aliquota-ipi = ? THEN ASSIGN tt-item-doc-est.aliquota-ipi = 0.
                      RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-item-doc-est.base-ipi[1]).
                       IF tt-item-doc-est.base-ipi[1] = ? THEN ASSIGN tt-item-doc-est.base-ipi[1] = 0.
                      RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxValue":U, OUTPUT tt-item-doc-est.valor-ipi[1]).
                       IF tt-item-doc-est.valor-ipi[1] = ? THEN ASSIGN tt-item-doc-est.valor-ipi[1]= 0.
                      RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-item-doc-est.ipi-ntrib[1]).
                       IF tt-item-doc-est.ipi-ntrib[1] = ? THEN ASSIGN tt-item-doc-est.ipi-ntrib[1] = 0.
                      RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-item-doc-est.ipi-outras[1]).
                       IF tt-item-doc-est.ipi-outras[1] = ? THEN ASSIGN tt-item-doc-est.ipi-outras[1] = 0.
                      RUN getSonVal  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxReductionPercentage":U, OUTPUT c-tax-red-perc).
                          &IF '{&BF_DIS_VERSAO_EMS}' < '2.05' &THEN
                             ASSIGN overlay(tt-item-doc-est.char-2,1,6) = IF c-tax-red-perc <> ? THEN c-tax-red-perc ELSE "".
                          &ELSE
                             ASSIGN tt-item-doc-est.val-perc-rep-ipi = IF c-tax-red-perc <> ? THEN dec(c-tax-red-perc) ELSE 0.
                          &ENDIF
                   END. /* IndustrializedProductTax */

                   RUN searchTag  IN hGenXml ("ServiceTax":U, iBrazilianTaxesId, OUTPUT iServiceTaxId).
                    IF iServiceTaxId <> ? THEN DO:
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxCode":U, OUTPUT tt-item-doc-est.cd-trib-iss).
                        IF tt-item-doc-est.cd-trib-iss = ? THEN ASSIGN cd-trib-iss = 1.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxPercentage":U, OUTPUT tt-item-doc-est.aliquota-iss).
                        IF tt-item-doc-est.aliquota-iss = ? THEN ASSIGN tt-item-doc-est.aliquota-iss = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-item-doc-est.base-iss[1]).
                        IF tt-item-doc-est.base-iss[1] = ? THEN ASSIGN tt-item-doc-est.base-iss[1] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxValue":U, OUTPUT tt-item-doc-est.valor-iss[1]).
                        IF tt-item-doc-est.valor-iss[1] = ? THEN ASSIGN tt-item-doc-est.valor-iss[1] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-item-doc-est.iss-ntrib[1]).
                        IF tt-item-doc-est.iss-ntrib[1] = ? THEN ASSIGN tt-item-doc-est.iss-ntrib[1] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-item-doc-est.iss-outras[1]).
                        IF tt-item-doc-est.iss-outras[1] = ? THEN ASSIGN tt-item-doc-est.iss-outras[1] = 0.
                    END. /* ServiceTax */

                   RUN searchTag  IN hGenXml ("ServicesAndProductsCirculationTax":U, iBrazilianTaxesId, OUTPUT iServicesAndProductsTaxId).
                    IF iServicesAndProductsTaxId <> ? THEN DO:
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxCode":U, OUTPUT tt-item-doc-est.cd-trib-icm).
                        IF tt-item-doc-est.cd-trib-icm = ? THEN ASSIGN tt-item-doc-est.cd-trib-icm = 1.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxPercentage":U, OUTPUT tt-item-doc-est.aliquota-icm).
                        IF tt-item-doc-est.aliquota-icm = ? THEN ASSIGN tt-item-doc-est.aliquota-icm = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-item-doc-est.base-icm[1]).
                        IF tt-item-doc-est.base-icm[1] = ? THEN ASSIGN tt-item-doc-est.base-icm[1] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxValue":U, OUTPUT tt-item-doc-est.valor-icm[1]).
                        IF tt-item-doc-est.valor-icm[1] = ? THEN ASSIGN tt-item-doc-est.valor-icm[1] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-item-doc-est.icm-ntrib[1]).
                        IF tt-item-doc-est.icm-ntrib[1] = ? THEN ASSIGN tt-item-doc-est.icm-ntrib[1] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-item-doc-est.icm-outras[1]).
                        IF tt-item-doc-est.icm-outras[1] = ? THEN ASSIGN tt-item-doc-est.icm-outras[1] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "SupplementaryTax":U, OUTPUT tt-item-doc-est.icm-complem[1]).
                        IF tt-item-doc-est.icm-complem[1] = ? THEN ASSIGN tt-item-doc-est.icm-complem[1] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TributarySubstitutionBasis":U, OUTPUT tt-item-doc-est.base-subs[1]).
                        IF tt-item-doc-est.base-subs[1] = ? THEN ASSIGN tt-item-doc-est.base-subs[1] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TributarySubstitutionValue":U, OUTPUT tt-item-doc-est.vl-subs[1]).
                        IF tt-item-doc-est.vl-subs[1] = ? THEN ASSIGN tt-item-doc-est.vl-subs[1] = 0.
                       RUN getSonLog  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "IsTaxWithholded":U, OUTPUT tt-item-doc-est.log-icm-retido).
                        IF tt-item-doc-est.log-icm-retido = ? THEN ASSIGN tt-item-doc-est.log-icm-retido = FALSE.
                       RUN getSonVal  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxReductionPercentage":U, OUTPUT c-tax-red-perc).
                           &IF '{&BF_DIS_VERSAO_EMS}' < '2.05' &THEN   
                             ASSIGN overlay(tt-item-doc-est.char-2,7,6) = IF c-tax-red-perc <> ? THEN c-tax-red-perc ELSE "".
                           &ELSE
                             ASSIGN tt-item-doc-est.val-perc-red-icm = IF c-tax-red-perc <> ? THEN dec(c-tax-red-perc) ELSE 0.
                           &ENDIF
                    END. /* ServicesAndProductsCirculationTax */

                    RUN searchTag  IN hGenXml ("SocialIntegrationProgramTax":U, iBrazilianTaxesId, OUTPUT iSocialIntegrationProgramTaxId).
                     IF iSocialIntegrationProgramTaxId <> ? THEN DO:
                         RUN getSonVal  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TaxCode":U, OUTPUT c-tax-code).
                          ASSIGN overlay(tt-item-doc-est.char-2,21,1) = IF c-tax-code <> ? THEN c-tax-code
                                                                       ELSE "1".
                         RUN getSonVal  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TaxPercentage":U, OUTPUT c-tax-perc).
                          ASSIGN overlay(tt-item-doc-est.char-2,22,5) = IF c-tax-perc <> ? THEN c-tax-perc
                                                                       ELSE "".
                         RUN getSonVal  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TaxCalculationBasis":U, OUTPUT c-tax-basis).
                          ASSIGN overlay(tt-item-doc-est.char-2,27,14) = IF c-tax-basis <> ? THEN c-tax-basis
                                                                        ELSE "".
                         RUN getSonVal  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TaxValue":U, OUTPUT c-tax-value).
                          ASSIGN overlay(tt-item-doc-est.char-2,41,14) = IF c-tax-value <> ? THEN c-tax-value
                                                                        ELSE "".
                         RUN getSonDec  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TributarySubstitutionBasis":U, OUTPUT tt-item-doc-est.base-pis-subs).
                          IF tt-item-doc-est.base-pis-subs = ? THEN ASSIGN tt-item-doc-est.base-pis-subs = 0.
                         RUN getSonDec  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TributarySubstitutionValue":U, OUTPUT tt-item-doc-est.vl-pis-subs).
                          IF tt-item-doc-est.vl-pis-subs = ? THEN ASSIGN tt-item-doc-est.vl-pis-subs = 0.
                     END. /* SocialIntegrationProgramTax */

                    RUN searchTag  IN hGenXml ("SocialSecurityContributionTax":U, iBrazilianTaxesId, OUTPUT iSocialSecurityContributionTaxId).
                     IF iSocialSecurityContributionTaxId <> ? THEN DO:
                        RUN getSonVal  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TaxCode":U, OUTPUT c-tax-code).
                         ASSIGN overlay(tt-item-doc-est.char-2,83,1) = IF c-tax-code <> ? THEN c-tax-code
                                                                      ELSE "1".
                        RUN getSonVal  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TaxPercentage":U, OUTPUT c-tax-perc).
                         ASSIGN overlay(tt-item-doc-est.char-2,84,5) = IF c-tax-perc <> ? THEN c-tax-perc
                                                                      ELSE "".
                        RUN getSonVal  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TaxCalculationBasis":U, OUTPUT c-tax-basis).
                         ASSIGN overlay(tt-item-doc-est.char-2,89,14) = IF c-tax-basis <> ? THEN c-tax-basis
                                                                       ELSE "".
                        RUN getSonVal  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TaxValue":U, OUTPUT c-tax-value).
                         ASSIGN overlay(tt-item-doc-est.char-2,103,14) = IF c-tax-value <> ? THEN c-tax-value
                                                                        ELSE "".
                        RUN getSonDec  IN hGenXml (INPUT iSocialSecurityContributionTaxId, INPUT "TributarySubstitutionBasis":U, OUTPUT tt-item-doc-est.base-cofins-subs).
                         IF tt-item-doc-est.base-cofins-subs = ? THEN ASSIGN tt-item-doc-est.base-cofins-subs = 0.
                        RUN getSonDec  IN hGenXml (INPUT iSocialSecurityContributionTaxId, INPUT "TributarySubstitutionValue":U, OUTPUT tt-item-doc-est.vl-cofins-subs).
                         IF tt-item-doc-est.vl-cofins-subs = ? THEN ASSIGN tt-item-doc-est.vl-cofins-subs = 0.
                     END. /* SocialSecurityContributionTax */

           END.  /* Brazilian Taxes */

           RUN searchTag  IN hGenXml ("ImportationTaxes":U, iTaxesId, OUTPUT iImportationTaxesId).
            IF iImportationTaxesId <> ? THEN DO:
               RUN getSonDec  IN hGenXml (INPUT iImportationTaxesId, INPUT "TaxValue":U, OUTPUT tt-item-doc-est.vl-imp-impor[1]).
                IF tt-item-doc-est.vl-imp-impor[1] = ? THEN ASSIGN tt-item-doc-est.vl-imp-impor[1] = 0.
            END.

       END.    /* Taxes */

      RUN searchTag  IN hGenXml ("FASBValuesAndTaxes":U, iItemValuesAndTaxesId, OUTPUT iFASBValuesAndTaxesId).
       IF iFASBValuesAndTaxesId <> ? THEN DO:

          RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "FASBCurrentRate":U, OUTPUT tt-item-doc-est.cotacao-fasb).
           IF tt-item-doc-est.cotacao-fasb = ? THEN ASSIGN tt-item-doc-est.cotacao-fasb = 0.
          RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "UnitPrice":U, OUTPUT tt-item-doc-est.preco-unit[2]).
           IF tt-item-doc-est.preco-unit[2] = ? THEN ASSIGN tt-item-doc-est.preco-unit[2] = 0.
          RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "TotalPrice":U, OUTPUT tt-item-doc-est.preco-total[2]).
           IF tt-item-doc-est.preco-total[2] = ? THEN ASSIGN tt-item-doc-est.preco-total[2] = 0.
          RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "ExpenseValue":U, OUTPUT tt-item-doc-est.despesas[2]).
           IF tt-item-doc-est.despesas[2] = ? THEN ASSIGN tt-item-doc-est.despesas[2] = 0.
          RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "DiscountValue":U, OUTPUT tt-item-doc-est.desconto[2]).
           IF tt-item-doc-est.desconto[2] = ? THEN ASSIGN tt-item-doc-est.desconto[2] = 0.
          RUN getSonDec  IN hGenXml (INPUT iFASBValuesAndTaxesId, INPUT "LaborValues":U, OUTPUT tt-item-doc-est.pre-unit-mob[2]).
           IF tt-item-doc-est.pre-unit-mob[2] = ? THEN ASSIGN tt-item-doc-est.pre-unit-mob[2] = 0.

          RUN searchTag  IN hGenXml ("Taxes":U, iFASBValuesAndTaxesId, OUTPUT iTaxesId).
           IF iTaxesId <> ? THEN DO:
              RUN searchTag  IN hGenXml ("BrazilianTaxes":U, iTaxesId, OUTPUT iBrazilianTaxesId).
               IF iBrazilianTaxesId <> ? THEN DO:

                  RUN searchTag  IN hGenXml ("IndustrializedProductTax":U, iBrazilianTaxesId, OUTPUT iIndustrializedProductTaxId).
                   IF iIndustrializedProductTaxId <> ? THEN DO:
                      RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-item-doc-est.base-ipi[2]).
                       IF tt-item-doc-est.base-ipi[2] = ? THEN ASSIGN tt-item-doc-est.base-ipi[2] = 0.
                      RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxValue":U, OUTPUT tt-item-doc-est.valor-ipi[2]).
                       IF tt-item-doc-est.valor-ipi[2] = ? THEN ASSIGN tt-item-doc-est.valor-ipi[2]= 0.
                      RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-item-doc-est.ipi-ntrib[2]).
                       IF tt-item-doc-est.ipi-ntrib[2] = ? THEN ASSIGN tt-item-doc-est.ipi-ntrib[2] = 0.
                      RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-item-doc-est.ipi-outras[2]).
                       IF tt-item-doc-est.ipi-outras[2] = ? THEN ASSIGN tt-item-doc-est.ipi-outras[2] = 0.
                   END. /* IndustrializedProductTax */

                   RUN searchTag  IN hGenXml ("ServiceTax":U, iBrazilianTaxesId, OUTPUT iServiceTaxId).
                    IF iServiceTaxId <> ? THEN DO:
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-item-doc-est.base-iss[2]).
                        IF tt-item-doc-est.base-iss[2] = ? THEN ASSIGN tt-item-doc-est.base-iss[2] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxValue":U, OUTPUT tt-item-doc-est.valor-iss[2]).
                        IF tt-item-doc-est.valor-iss[2] = ? THEN ASSIGN tt-item-doc-est.valor-iss[2] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-item-doc-est.iss-ntrib[2]).
                        IF tt-item-doc-est.iss-ntrib[2] = ? THEN ASSIGN tt-item-doc-est.iss-ntrib[2] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-item-doc-est.iss-outras[2]).
                        IF tt-item-doc-est.iss-outras[2] = ? THEN ASSIGN tt-item-doc-est.iss-outras[2] = 0.
                    END. /* ServiceTax */

                   RUN searchTag  IN hGenXml ("ServicesAndProductsCirculationTax":U, iBrazilianTaxesId, OUTPUT iServicesAndProductsTaxId).
                    IF iServicesAndProductsTaxId <> ? THEN DO:
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-item-doc-est.base-icm[2]).
                        IF tt-item-doc-est.base-icm[2] = ? THEN ASSIGN tt-item-doc-est.base-icm[2] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxValue":U, OUTPUT tt-item-doc-est.valor-icm[2]).
                        IF tt-item-doc-est.valor-icm[2] = ? THEN ASSIGN tt-item-doc-est.valor-icm[2] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-item-doc-est.icm-ntrib[2]).
                        IF tt-item-doc-est.icm-ntrib[2] = ? THEN ASSIGN tt-item-doc-est.icm-ntrib[2] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-item-doc-est.icm-outras[2]).
                        IF tt-item-doc-est.icm-outras[2] = ? THEN ASSIGN tt-item-doc-est.icm-outras[2] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "SupplementaryTax":U, OUTPUT tt-item-doc-est.icm-complem[2]).
                        IF tt-item-doc-est.icm-complem[2] = ? THEN ASSIGN tt-item-doc-est.icm-complem[2] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TributarySubstitutionBasis":U, OUTPUT tt-item-doc-est.base-subs[2]).
                        IF tt-item-doc-est.base-subs[2] = ? THEN ASSIGN tt-item-doc-est.base-subs[1] = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TributarySubstitutionValue":U, OUTPUT tt-item-doc-est.vl-subs[2]).
                        IF tt-item-doc-est.vl-subs[2] = ? THEN ASSIGN tt-item-doc-est.vl-subs[2] = 0.
                    END. /* ServicesAndProductsCirculationTax */

                    RUN searchTag  IN hGenXml ("SocialIntegrationProgramTax":U, iBrazilianTaxesId, OUTPUT iSocialIntegrationProgramTaxId).
                     IF iSocialIntegrationProgramTaxId <> ? THEN DO:
                         RUN getSonVal  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TaxValue":U, OUTPUT c-tax-value).
                          ASSIGN overlay(tt-item-doc-est.char-2,55,14) = IF c-tax-value <> ? THEN c-tax-value
                                                                        ELSE "".
                     END.

                    RUN searchTag  IN hGenXml ("SocialSecurityContributionTax":U, iBrazilianTaxesId, OUTPUT iSocialSecurityContributionTaxId).
                     IF iSocialSecurityContributionTaxId <> ? THEN DO:
                        RUN getSonVal  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TaxValue":U, OUTPUT c-tax-value).
                         ASSIGN overlay(tt-item-doc-est.char-2,117,14) = IF c-tax-value <> ? THEN c-tax-value
                                                                         ELSE "".
                     END.

               END. /* BrazilianTaxes */

               RUN searchTag  IN hGenXml ("ImportationTaxes":U, iTaxesId, OUTPUT iImportationTaxesId).
                IF iImportationTaxesId <> ? THEN DO:
                   RUN getSonDec  IN hGenXml (INPUT iImportationTaxesId, INPUT "TaxValue":U, OUTPUT tt-item-doc-est.vl-imp-impor[2]).
                    IF tt-item-doc-est.vl-imp-impor[2] = ? THEN ASSIGN tt-item-doc-est.vl-imp-impor[2] = 0.
                END.

           END. /* Taxes */

       END. /* FASBValuesAndTaxes */

      RUN searchTag  IN hGenXml ("CMCACValuesAndTaxes":U, iItemValuesAndTaxesId, OUTPUT iCMCACValuesAndTaxesId).
       IF iCMCACValuesAndTaxesId <> ? THEN DO:

          RUN getSonDec  IN hGenXml (INPUT iCMCACValuesAndTaxesId, INPUT "CMCACCurrentRate":U, OUTPUT tt-item-doc-est.cotacao-cmi).
           IF tt-item-doc-est.cotacao-cmi = ? THEN ASSIGN tt-item-doc-est.cotacao-cmi = 0.
          RUN getSonDec  IN hGenXml (INPUT iCMCACValuesAndTaxesId, INPUT "UnitPrice":U, OUTPUT tt-item-doc-est.pr-unit-cmi).
           IF tt-item-doc-est.pr-unit-cmi = ? THEN ASSIGN tt-item-doc-est.pr-unit-cmi = 0.
          RUN getSonDec  IN hGenXml (INPUT iCMCACValuesAndTaxesId, INPUT "TotalPrice":U, OUTPUT tt-item-doc-est.pr-total-cmi).
           IF tt-item-doc-est.pr-total-cmi = ? THEN ASSIGN tt-item-doc-est.pr-total-cmi = 0.
          RUN getSonDec  IN hGenXml (INPUT iCMCACValuesAndTaxesId, INPUT "ExpenseValue":U, OUTPUT tt-item-doc-est.despesas-cmi).
           IF tt-item-doc-est.despesas-cmi = ? THEN ASSIGN tt-item-doc-est.despesas-cmi = 0.
          RUN getSonDec  IN hGenXml (INPUT iCMCACValuesAndTaxesId, INPUT "DiscountValue":U, OUTPUT tt-item-doc-est.desconto-cmi).
           IF tt-item-doc-est.desconto-cmi = ? THEN ASSIGN tt-item-doc-est.desconto-cmi = 0.
          RUN getSonDec  IN hGenXml (INPUT iCMCACValuesAndTaxesId, INPUT "LaborValues":U, OUTPUT tt-item-doc-est.pr-mob-cmi).
           IF tt-item-doc-est.pr-mob-cmi = ? THEN ASSIGN tt-item-doc-est.pr-mob-cmi = 0.

          RUN searchTag  IN hGenXml ("Taxes":U, iCMCACValuesAndTaxesId, OUTPUT iTaxesId).
           IF iTaxesId <> ? THEN DO:
              RUN searchTag  IN hGenXml ("BrazilianTaxes":U, iTaxesId, OUTPUT iBrazilianTaxesId).
               IF iBrazilianTaxesId <> ? THEN DO:

                  RUN searchTag  IN hGenXml ("IndustrializedProductTax":U, iBrazilianTaxesId, OUTPUT iIndustrializedProductTaxId).
                   IF iIndustrializedProductTaxId <> ? THEN DO:
                      RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-item-doc-est.base-ipi-cmi).
                       IF tt-item-doc-est.base-ipi-cmi = ? THEN ASSIGN tt-item-doc-est.base-ipi-cmi = 0.
                      RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxValue":U, OUTPUT tt-item-doc-est.vl-ipi-cmi).
                       IF tt-item-doc-est.vl-ipi-cmi = ? THEN ASSIGN tt-item-doc-est.vl-ipi-cmi= 0.
                      RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-item-doc-est.ipi-ntr-cmi).
                       IF tt-item-doc-est.ipi-ntr-cmi = ? THEN ASSIGN tt-item-doc-est.ipi-ntr-cmi = 0.
                      RUN getSonDec  IN hGenXml (INPUT iIndustrializedProductTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-item-doc-est.ipi-out-cmi).
                       IF tt-item-doc-est.ipi-out-cmi = ? THEN ASSIGN tt-item-doc-est.ipi-out-cmi = 0.
                   END. /* IndustrializedProductTax */

                   RUN searchTag  IN hGenXml ("ServiceTax":U, iBrazilianTaxesId, OUTPUT iServiceTaxId).
                    IF iServiceTaxId <> ? THEN DO:
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-item-doc-est.base-iss-cmi).
                        IF tt-item-doc-est.base-iss-cmi = ? THEN ASSIGN tt-item-doc-est.base-iss-cmi = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxValue":U, OUTPUT tt-item-doc-est.vl-iss-cmi).
                        IF tt-item-doc-est.vl-iss-cmi = ? THEN ASSIGN tt-item-doc-est.vl-iss-cmi = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-item-doc-est.iss-ntr-cmi).
                        IF tt-item-doc-est.iss-ntr-cmi = ? THEN ASSIGN tt-item-doc-est.iss-ntr-cmi = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServiceTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-item-doc-est.iss-out-cmi).
                        IF tt-item-doc-est.iss-out-cmi = ? THEN ASSIGN tt-item-doc-est.iss-out-cmi = 0.
                    END. /* ServiceTax */

                   RUN searchTag  IN hGenXml ("ServicesAndProductsCirculationTax":U, iBrazilianTaxesId, OUTPUT iServicesAndProductsTaxId).
                    IF iServicesAndProductsTaxId <> ? THEN DO:
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxCalculationBasis":U, OUTPUT tt-item-doc-est.base-icm-cmi).
                        IF tt-item-doc-est.base-icm-cmi = ? THEN ASSIGN tt-item-doc-est.base-icm-cmi = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxValue":U, OUTPUT tt-item-doc-est.vl-icm-cmi).
                        IF tt-item-doc-est.vl-icm-cmi = ? THEN ASSIGN tt-item-doc-est.vl-icm-cmi = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "NotTaxedValue":U, OUTPUT tt-item-doc-est.icm-ntr-cmi).
                        IF tt-item-doc-est.icm-ntr-cmi = ? THEN ASSIGN tt-item-doc-est.icm-ntr-cmi = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TaxOtherValue":U, OUTPUT tt-item-doc-est.icm-out-cmi).
                        IF tt-item-doc-est.icm-out-cmi = ? THEN ASSIGN tt-item-doc-est.icm-out-cmi = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "SupplementaryTax":U, OUTPUT tt-item-doc-est.icm-comp-cmi).
                        IF tt-item-doc-est.icm-comp-cmi = ? THEN ASSIGN tt-item-doc-est.icm-comp-cmi = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TributarySubstitutionBasis":U, OUTPUT tt-item-doc-est.base-subs-cmi).
                        IF tt-item-doc-est.base-subs-cmi = ? THEN ASSIGN tt-item-doc-est.base-subs-cmi = 0.
                       RUN getSonDec  IN hGenXml (INPUT iServicesAndProductsTaxId, INPUT "TributarySubstitutionValue":U, OUTPUT tt-item-doc-est.vl-subs-cmi).
                        IF tt-item-doc-est.vl-subs-cmi = ? THEN ASSIGN tt-item-doc-est.vl-subs-cmi = 0.
                    END. /* ServicesAndProductsCirculationTax */

                    RUN searchTag  IN hGenXml ("SocialIntegrationProgramTax":U, iBrazilianTaxesId, OUTPUT iSocialIntegrationProgramTaxId).
                     IF iSocialIntegrationProgramTaxId <> ? THEN DO:
                         RUN getSonVal  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TaxValue":U, OUTPUT c-tax-value).
                          ASSIGN overlay(tt-item-doc-est.char-2,69,14) = IF c-tax-value <> ? THEN c-tax-value
                                                                        ELSE "".
                     END.

                    RUN searchTag  IN hGenXml ("SocialSecurityContributionTax":U, iBrazilianTaxesId, OUTPUT iSocialSecurityContributionTaxId).
                     IF iSocialSecurityContributionTaxId <> ? THEN DO:
                        RUN getSonVal  IN hGenXml (INPUT iSocialIntegrationProgramTaxId, INPUT "TaxValue":U, OUTPUT c-tax-value).
                         ASSIGN overlay(tt-item-doc-est.char-2,131,14) = IF c-tax-value <> ? THEN c-tax-value
                                                                         ELSE "".
                     END.

               END. /* BrazilianTaxes */

              RUN searchTag  IN hGenXml ("ImportationTaxes":U, iTaxesId, OUTPUT iImportationTaxesId).
                IF iImportationTaxesId <> ? THEN
                   RUN getSonDec  IN hGenXml (INPUT iImportationTaxesId, INPUT "TaxValue":U, OUTPUT tt-item-doc-est.vl-imp-cmi).

           END. /* Taxes */

       END. /* CMCACValuesAndTaxes */

      RUN searchTag  IN hGenXml ("ForeignValuesAndTaxes":U, iItemValuesAndTaxesId, OUTPUT iForeignValuesAndTaxesId).
       IF iForeignValuesAndTaxesId <> ? THEN DO:
          RUN getSonDec  IN hGenXml (INPUT iForeignValuesAndTaxesId, INPUT "UnitPrice":U, OUTPUT tt-item-doc-est.preco-unit-me).
           IF tt-item-doc-est.preco-unit-me = ? THEN ASSIGN tt-item-doc-est.preco-unit-me = 0.
          RUN getSonDec  IN hGenXml (INPUT iForeignValuesAndTaxesId, INPUT "TotalPrice":U, OUTPUT tt-item-doc-est.preco-total-me).
           IF tt-item-doc-est.preco-total-me = ? THEN ASSIGN tt-item-doc-est.preco-total-me = 0.
          RUN getSonDec  IN hGenXml (INPUT iForeignValuesAndTaxesId, INPUT "ExpenseValue":U, OUTPUT tt-item-doc-est.despesas-me[1]).
           IF tt-item-doc-est.despesas-me[1] = ? THEN ASSIGN tt-item-doc-est.despesas-me[1] = 0.  
          RUN getSonDec  IN hGenXml (INPUT iForeignValuesAndTaxesId, INPUT "DiscountValue":U, OUTPUT tt-item-doc-est.desconto-me).
           IF tt-item-doc-est.desconto-me = ? THEN ASSIGN tt-item-doc-est.desconto-me = 0.
          RUN getSonDec  IN hGenXml (INPUT iForeignValuesAndTaxesId, INPUT "FreightValue":U, OUTPUT tt-item-doc-est.valor-frete-me).
           IF tt-item-doc-est.valor-frete-me = ? THEN ASSIGN tt-item-doc-est.valor-frete-me = 0.
       END. /* ForeignValuesAndTaxes */


      ASSIGN iNextDocumentItemId = iDocumentItemId.

      /* Busca pr¢ximo item */
      RUN GetNextSonId IN hGenXml (iListOfDocumentItensId, iNextDocumentItemId, OUTPUT iDocumentItemId).

    END. /* iDocumentItemId */

  END. /* ListOfDocumentItens */

END PROCEDURE.


PROCEDURE pi-cria-tt-dupli-apagar: /* Cria registro na temp-table tt-dupli-apagar */


 DEF INPUT PARAM i-cod-emitente LIKE tt-dupli-apagar.cod-emitente NO-UNDO.
 DEF INPUT PARAM c-nro-docto    LIKE tt-dupli-apagar.nro-docto    NO-UNDO.
 DEF INPUT PARAM c-serie-docto  LIKE tt-dupli-apagar.serie-docto  NO-UNDO.
 DEF INPUT PARAM c-nat-operacao LIKE tt-dupli-apagar.nat-operacao NO-UNDO.

 DEF VAR c-parcela              LIKE tt-dupli-apagar.parcela      NO-UNDO.

 DEF VAR iListOfDocumentBillsId AS INT NO-UNDO.  
 DEF VAR iNextDocumentBillId    AS INT NO-UNDO.  
 DEF VAR iOverdueId             AS INT NO-UNDO.  


 RUN searchTag IN hGenXml ("ListOfDocumentBills":U, 1, OUTPUT iListOfDocumentBillsId).
  IF iListOfDocumentBillsId <> ? THEN DO:

   RUN getFirstSonId IN hGenXml (iListOfDocumentBillsId, OUTPUT iDocumentBillId).
     DO WHILE iDocumentBillId <> ?:

       RUN getSonVal  IN hGenXml (INPUT iDocumentBillId, INPUT "InstallmentNumber":U, OUTPUT c-parcela).

       IF CAN-FIND (FIRST tt-dupli-apagar WHERE
                          tt-dupli-apagar.cod-emitente = i-cod-emitente  AND
                          tt-dupli-apagar.nro-docto    = c-nro-docto     AND
                          tt-dupli-apagar.serie-docto  = c-serie-docto   AND
                          tt-dupli-apagar.nat-operacao = c-nat-operacao  AND
                          tt-dupli-apagar.parcela      = c-parcela )     THEN DO:

             CREATE tt-erro.
             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "J†_existe_Duplicata_com_a_chave_informada" *}
             ASSIGN tt-erro.identif-segment = ""
                    tt-erro.cd-erro         = 7
                    tt-erro.desc-erro       = RETURN-VALUE.

             UNDO, LEAVE.
      END.

       CREATE tt-dupli-apagar.

       /*** Campos Chave ***/
       ASSIGN tt-dupli-apagar.cod-emitente = i-cod-emitente
              tt-dupli-apagar.nro-docto    = c-nro-docto
              tt-dupli-apagar.serie-docto  = c-serie-docto
              tt-dupli-apagar.nat-operacao = c-nat-operacao 
              tt-dupli-apagar.parcela      = c-parcela .
       /***********************/

       RUN getSonVal  IN hGenXml (INPUT iDocumentBillId, INPUT "BillNumber":U, OUTPUT tt-dupli-apagar.nr-duplic).

       RUN searchTag  IN hGenXml ("DocumentClass":U, iDocumentBillId, OUTPUT iDocumentClassId).
       RUN getSonVal  IN hGenXml (INPUT iDocumentClassId, INPUT "DocumentClassID":U, OUTPUT tt-dupli-apagar.cod-esp). 

       RUN searchTag  IN hGenXml ("ExpenseRevenueType":U, iDocumentBillId, OUTPUT iExpenseRevenueTypeId).
       RUN getSonDec  IN hGenXml (INPUT iExpenseRevenueTypeId, INPUT "ExpenseRevenueCode":U, OUTPUT tt-dupli-apagar.tp-despesa).

       RUN getSonDate IN hGenXml (INPUT iDocumentBillId, INPUT "PrintDate":U, OUTPUT tt-dupli-apagar.dt-emissao).
       RUN getSonDate IN hGenXml (INPUT iDocumentBillId, INPUT "TransactionDate":U, OUTPUT tt-dupli-apagar.dt-trans).
       RUN getSonDate IN hGenXml (INPUT iDocumentBillId, INPUT "DueDate":U, OUTPUT tt-dupli-apagar.dt-vencim).
       RUN getSonDec  IN hGenXml (INPUT iDocumentBillId, INPUT "DebitOrCredit":U, OUTPUT tt-dupli-apagar.esp-movto).
        IF tt-dupli-apagar.esp-movto = ? THEN ASSIGN tt-dupli-apagar.esp-movto = 1.
       RUN getSonDec  IN hGenXml (INPUT iDocumentBillId, INPUT "TaxRetentionCode":U, OUTPUT tt-dupli-apagar.cod-ret-irf).
        IF tt-dupli-apagar.cod-ret-irf = ? THEN ASSIGN tt-dupli-apagar.cod-ret-irf = 0.
       RUN getSonVal  IN hGenXml (INPUT iDocumentBillId, INPUT "Comments":U, OUTPUT tt-dupli-apagar.observacao).
        IF tt-dupli-apagar.observacao = ? THEN ASSIGN tt-dupli-apagar.observacao = "".

       RUN searchTag  IN hGenXml ("BillValue":U, iDocumentBillId, OUTPUT iBillValueId).
       RUN getSonDec  IN hGenXml (INPUT iBillValueId, INPUT "CurrentCurrencyValue":U, OUTPUT tt-dupli-apagar.vl-a-pagar).
       RUN getSonDec  IN hGenXml (INPUT iBillValueId, INPUT "FASBValue":U, OUTPUT tt-dupli-apagar.vl-ap-fasb[1]).
        IF tt-dupli-apagar.vl-ap-fasb[1] = ? THEN ASSIGN tt-dupli-apagar.vl-ap-fasb[1] = 0.
       RUN getSonDec  IN hGenXml (INPUT iBillValueId, INPUT "CMCACValue":U, OUTPUT tt-dupli-apagar.vl-ap-fasb[2]).
        IF tt-dupli-apagar.vl-ap-fasb[2] = ? THEN ASSIGN tt-dupli-apagar.vl-ap-fasb[2] = 0.
       RUN getSonDec  IN hGenXml (INPUT iBillValueId, INPUT "ForeignValue":U, OUTPUT tt-dupli-apagar.valor-a-pagar-me).
        IF tt-dupli-apagar.valor-a-pagar-me= ? THEN ASSIGN tt-dupli-apagar.valor-a-pagar-me = 0.

       RUN searchTag  IN hGenXml ("Discount":U, iDocumentBillId, OUTPUT iDiscountId).
        IF iDiscountId <> ? THEN DO:
           RUN getSonDec  IN hGenXml (INPUT iDiscountId, INPUT "DiscountPercentage":U, OUTPUT tt-dupli-apagar.desconto).
            IF tt-dupli-apagar.desconto = ? THEN ASSIGN tt-dupli-apagar.desconto = 0.
           RUN getSonDec  IN hGenXml (INPUT iDiscountId, INPUT "DiscountValue":U, OUTPUT tt-dupli-apagar.vl-desconto).
            IF tt-dupli-apagar.vl-desconto =  ? THEN ASSIGN tt-dupli-apagar.vl-desconto = 0.
           RUN getSonDate IN hGenXml (INPUT iDiscountId, INPUT "DiscountDueDate":U, OUTPUT tt-dupli-apagar.dt-venc-desc).
        END.  /* Discount */

       RUN searchTag  IN hGenXml ("Overdue":U, iDocumentBillId, OUTPUT iOverdueId).
        IF iOverdueId <> ? THEN DO:
           RUN getSonDec  IN hGenXml (INPUT iOverdueId, INPUT "InterestPercentage":U, OUTPUT tt-dupli-apagar.perc-juros).
            IF tt-dupli-apagar.perc-juros = ? THEN ASSIGN  tt-dupli-apagar.perc-juros = 0.
           RUN getSonDec  IN hGenXml (INPUT iOverdueId, INPUT "FinePercentage":U, OUTPUT tt-dupli-apagar.perc-mora).
            IF tt-dupli-apagar.perc-mora = ? THEN ASSIGN  tt-dupli-apagar.perc-mora = 0.
           RUN getSonDec  IN hGenXml (INPUT iOverdueId, INPUT "DaysLate":U, OUTPUT tt-dupli-apagar.dias-atraso).
            IF tt-dupli-apagar.dias-atraso = ? THEN ASSIGN  tt-dupli-apagar.dias-atraso = 0.
        END. /* Overdue */

       RUN pi-cria-tt-dupli-imp (INPUT tt-dupli-apagar.cod-emitente,
                                 INPUT tt-dupli-apagar.nro-docto,
                                 INPUT tt-dupli-apagar.serie-docto,
                                 INPUT tt-dupli-apagar.nat-operacao,
                                 INPUT tt-dupli-apagar.parcela ).

       ASSIGN iNextDocumentBillId = iDocumentBillId.

       /*  Busca pr¢xima duplicata */
       RUN GetNextSonId IN hGenXml (iListOfDocumentBillsId, iNextDocumentBillId, OUTPUT iDocumentBillId).

     END. /* DocumentBill */

  END.  /* ListOfDocumentBillsId */

END PROCEDURE.


PROCEDURE pi-cria-tt-dupli-imp: /* Cria registro na temp-table tt-dupli-imp */


 DEF INPUT PARAM i-cod-emitente LIKE tt-dupli-imp.cod-emitente NO-UNDO.
 DEF INPUT PARAM c-nro-docto    LIKE tt-dupli-imp.nro-docto    NO-UNDO.
 DEF INPUT PARAM c-serie-docto  LIKE tt-dupli-imp.serie-docto  NO-UNDO.
 DEF INPUT PARAM c-nat-operacao LIKE tt-dupli-imp.nat-operacao NO-UNDO.
 DEF INPUT PARAM c-parcela      LIKE tt-dupli-imp.parcela      NO-UNDO.

 DEF VAR c-parcela-imp          LIKE tt-dupli-imp.parcela-imp  NO-UNDO.
 DEF VAR c-cod-esp              LIKE tt-dupli-imp.cod-esp      NO-UNDO.

 DEF VAR iBillTaxId             AS INT NO-UNDO.  
 DEF VAR iListOfBillsTaxesId    AS INT NO-UNDO.  
 DEF VAR iNextBillTaxId         AS INT NO-UNDO.  
 DEF VAR iTaxId                 AS INT NO-UNDO.
 DEF VAR iTaxVendorId           AS INT NO-UNDO.


 RUN searchTag IN hGenXml ("ListOfBillTaxes":U, iDocumentBillId, OUTPUT iListOfBillsTaxesId).
  IF iListOfBillsTaxesId <> ? THEN DO:

   RUN getFirstSonId IN hGenXml (iListOfBillsTaxesId, OUTPUT iBillTaxId).
     DO WHILE iBillTaxId <> ?:

       RUN getSonVal  IN hGenXml (INPUT iBillTaxId, INPUT "TaxInstallmentNumber":U, OUTPUT c-parcela-imp).

       RUN searchTag  IN hGenXml ("DocumentClass":U, iBillTaxId, OUTPUT iDocumentClassId).
       RUN getSonVal  IN hGenXml (INPUT iDocumentClassId, INPUT "DocumentClassID":U, OUTPUT c-cod-esp).

       IF CAN-FIND (FIRST tt-dupli-imp WHERE
                          tt-dupli-imp.cod-emitente  = i-cod-emitente     AND
                          tt-dupli-imp.nro-docto     = c-nro-docto        AND
                          tt-dupli-imp.serie-docto   = c-serie-docto      AND
                          tt-dupli-imp.nat-operacao  = c-nat-operacao     AND
                          tt-dupli-imp.parcela       = c-parcela          AND
                          tt-dupli-imp.parcela-imp   = c-parcela-imp      AND
                          tt-dupli-imp.cod-esp       = c-cod-esp )        THEN DO:

             CREATE tt-erro.
             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "Impostos_da_Duplicata" *}
             ASSIGN tt-erro.identif-segment = ""
                    tt-erro.cd-erro         = 7
                    tt-erro.desc-erro       = RETURN-VALUE.

             UNDO, LEAVE.
      END.

       CREATE tt-dupli-imp.

       /*** Campos Chave ***/
       ASSIGN tt-dupli-imp.cod-emitente  = i-cod-emitente
              tt-dupli-imp.nro-docto     = c-nro-docto
              tt-dupli-imp.serie-docto   = c-serie-docto
              tt-dupli-imp.nat-operacao  = c-nat-operacao
              tt-dupli-imp.parcela       = c-parcela      
              tt-dupli-imp.parcela-imp   = c-parcela-imp
              tt-dupli-imp.cod-esp       = c-cod-esp .
       /***********************/

       RUN getSonVal  IN hGenXml (INPUT iBillTaxId, INPUT "TaxDocumentNumber":U, OUTPUT tt-dupli-imp.nro-docto-imp).

       RUN searchTag  IN hGenXml ("ExpenseRevenueType":U, iBillTaxId, OUTPUT iExpenseRevenueTypeId).
       RUN getSonDec  IN hGenXml (INPUT iExpenseRevenueTypeId, INPUT "ExpenseRevenueCode":U, OUTPUT tt-dupli-imp.tp-codigo).

       RUN searchTag  IN hGenXml ("Tax":U, iBillTaxId, OUTPUT iTaxId).
       RUN getSonDec  IN hGenXml (INPUT iTaxId, INPUT "TaxCode":U, OUTPUT tt-dupli-imp.int-1).

       RUN getSonDec  IN hGenXml (INPUT iBillTaxId, INPUT "TaxValue":U, OUTPUT tt-dupli-imp.vl-imposto).
        IF tt-dupli-imp.vl-imposto = ? THEN ASSIGN tt-dupli-imp.vl-imposto = 0.
       RUN getSonDec  IN hGenXml (INPUT iBillTaxId, INPUT "TaxRetentionCode":U, OUTPUT tt-dupli-imp.cod-retencao).
        IF tt-dupli-imp.cod-retencao = ? THEN ASSIGN tt-dupli-imp.cod-retencao = 0.
       RUN getSonDec  IN hGenXml (INPUT iBillTaxId, INPUT "TaxPercentage":U, OUTPUT tt-dupli-imp.aliquota).
        IF tt-dupli-imp.aliquota = ? THEN ASSIGN tt-dupli-imp.aliquota= 0.

       RUN searchTag IN hGenXml ("TaxVendor":U, iBillTaxId, OUTPUT iTaxVendorId).
        IF iTaxVendorId <> ? THEN DO:
           RUN getSonDec IN hGenXml (INPUT iTaxVendorId, INPUT "VendorId":U, OUTPUT tt-dupli-imp.cod-forn-imp).
            IF tt-dupli-imp.cod-forn-imp = ? THEN DO:
             RUN getSonVal IN hGenXml (INPUT iTaxVendorId, INPUT "VendorShortName":U, OUTPUT c-nome-abrev).
             RUN getSonVal IN hGenXml (INPUT iTaxVendorId, INPUT "VendorTaxID":U, OUTPUT c-cgc).

             RUN pi-procura-emitente (c-cgc,
                                      c-nome-abrev,
                                      OUTPUT tt-dupli-imp.cod-forn-imp).
            END.
        END. /* TaxVendor */

       RUN getSonDate IN hGenXml (INPUT iBillTaxId, INPUT "TaxDueDate":U, OUTPUT tt-dupli-imp.dt-venc-imp).
       RUN getSonDec  IN hGenXml (INPUT iBillTaxId, INPUT "TaxType":U, OUTPUT tt-dupli-imp.tp-imposto).
       RUN getSonDec  IN hGenXml (INPUT iBillTaxId, INPUT "TaxableIncome":U, OUTPUT tt-dupli-imp.rend-trib).

       ASSIGN iNextBillTaxId = iBillTaxId.

       /*  Busca pr¢ximo imposto da duplicata */
       RUN GetNextSonId IN hGenXml (iListOfBillsTaxesId, iNextBillTaxId, OUTPUT iBillTaxId).

     END. /* BillTax */

  END.  /* ListOfBillsTaxes  */ 

END PROCEDURE.


PROCEDURE pi-cria-tt-rat-docum: /* Cria registro na temp-table tt-rat-docum */


 DEF INPUT PARAM i-cod-emitente LIKE tt-rat-docum.cod-emitente NO-UNDO.
 DEF INPUT PARAM c-nro-docto    LIKE tt-rat-docum.nro-docto    NO-UNDO.
 DEF INPUT PARAM c-serie-docto  LIKE tt-rat-docum.serie-docto  NO-UNDO.
 DEF INPUT PARAM c-nat-operacao LIKE tt-rat-docum.nat-operacao NO-UNDO.
 DEF INPUT PARAM d-valor-mercad LIKE tt-docum-est.valor-mercad NO-UNDO.

 DEF VAR i-nf-emitente          LIKE tt-rat-docum.nf-emitente  NO-UNDO.
 DEF VAR c-nf-nro               LIKE tt-rat-docum.nf-nro       NO-UNDO.
 DEF VAR c-nf-nat-oper          LIKE tt-rat-docum.nf-nat-oper  NO-UNDO.
 DEF VAR c-nf-serie             LIKE tt-rat-docum.nf-serie     NO-UNDO.

 DEF VAR iDocumentForFreightDistId     AS INT NO-UNDO.  
 DEF VAR iListOfDocumentsFreightDistId AS INT NO-UNDO.  
 DEF VAR iNextDocumentForFreightDistId AS INT NO-UNDO.  


 RUN searchTag IN hGenXml ("ListOfDocumentsForFreightDistribution":U, 1, OUTPUT iListOfDocumentsFreightDistId).
  IF iListOfDocumentsFreightDistId <> ? THEN DO:

   RUN getFirstSonId IN hGenXml ( iListOfDocumentsFreightDistId, OUTPUT iDocumentForFreightDistId).
    DO WHILE iDocumentForFreightDistId <> ? :

      RUN getSonVal  IN hGenXml (INPUT iDocumentForFreightDistId, INPUT "DocumentSeries":U, OUTPUT c-nf-serie).
      RUN getSonVal  IN hGenXml (INPUT iDocumentForFreightDistId, INPUT "DocumentNumber":U, OUTPUT c-nf-nro).

      RUN searchTag IN hGenXml ("Vendor":U, iDocumentForFreightDistId, OUTPUT iVendorId).
      RUN getSonDec IN hGenXml (INPUT iVendorId, INPUT "VendorId":U, OUTPUT i-nf-emitente).
       IF i-nf-emitente = ? THEN DO:
             RUN getSonVal IN hGenXml (INPUT iVendorId, INPUT "VendorShortName":U, OUTPUT c-nome-abrev).
             RUN getSonVal IN hGenXml (INPUT iVendorId, INPUT "VendorTaxID":U, OUTPUT c-cgc).

             RUN pi-procura-emitente (c-cgc,
                                      c-nome-abrev,
                                      OUTPUT i-nf-emitente).
       END.

      RUN searchTag  IN hGenXml ("FiscalOperation":U, iDocumentForFreightDistId, OUTPUT iFiscalOperationId).
      RUN getSonVal  IN hGenXml (INPUT iFiscalOperationId, INPUT "FiscalOperationCode":U, OUTPUT c-nf-nat-oper).

      IF CAN-FIND (FIRST tt-rat-docum WHERE
                         tt-rat-docum.cod-emitente = i-cod-emitente  AND
                         tt-rat-docum.nro-docto    = c-nro-docto     AND
                         tt-rat-docum.serie-docto  = c-serie-docto   AND
                         tt-rat-docum.nat-operacao = c-nat-operacao  AND
                         tt-rat-docum.nf-emitente  = i-nf-emitente   AND
                         tt-rat-docum.nf-nro       = c-nf-nro        AND
                         tt-rat-docum.nf-serie     = c-nf-serie      AND
                         tt-rat-docum.nf-nat-oper  = c-nf-nat-oper ) THEN DO:

             CREATE tt-erro.
             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "Rateio_do_Documento" *}
             ASSIGN tt-erro.identif-segment = ""
                    tt-erro.cd-erro         = 7
                    tt-erro.desc-erro       = RETURN-VALUE.

             UNDO, LEAVE.
      END.

      CREATE tt-rat-docum.

      /*** Campos Chave ***/
      ASSIGN tt-rat-docum.cod-emitente = i-cod-emitente
             tt-rat-docum.nro-docto    = c-nro-docto
             tt-rat-docum.serie-docto  = c-serie-docto
             tt-rat-docum.nat-operacao = c-nat-operacao
             tt-rat-docum.nf-emitente  = i-nf-emitente  
             tt-rat-docum.nf-nro       = c-nf-nro       
             tt-rat-docum.nf-serie     = c-nf-serie     
             tt-rat-docum.nf-nat-oper  = c-nf-nat-oper .
      /***********************/

      ASSIGN tt-rat-docum.dec-1 = d-valor-mercad.

      RUN getSonDec  IN hGenXml (INPUT iDocumentForFreightDistId, INPUT "InvoiceDocumentType":U, OUTPUT tt-rat-docum.tipo-nota).
       IF tt-rat-docum.tipo-nota = ? THEN ASSIGN tt-rat-docum.tipo-nota = 1.

      &IF '{&BF_DIS_VERSAO_EMS}' >= "2.05":U &THEN
        RUN getSonDec IN hGenXml (INPUT iDocumentForFreightDistId, INPUT "DocumentSource":U, OUTPUT tt-rat-docum.ind-origem-nf).
         IF tt-rat-docum.ind-origem-nf = ? THEN ASSIGN tt-rat-docum.ind-origem-nf = 1.                                                    
      &ENDIF

      ASSIGN iNextDocumentForFreightDistId = iDocumentForFreightDistId.

      /*  Busca pr¢ximo imposto da duplicata */
      RUN GetNextSonId IN hGenXml (iListOfDocumentsFreightDistId, iNextDocumentForFreightDistId, OUTPUT iDocumentForFreightDistId).

    END. /* DocumentForFreightDist */

  END. /* ListOfDocumentsFreightDist */

END PROCEDURE.


PROCEDURE pi-procura-emitente:

   DEF INPUT  PARAM pi-cgc          LIKE emitente.cgc           NO-UNDO.
   DEF INPUT  PARAM pi-nome-abrev   LIKE emitente.nome-abrev    NO-UNDO.
   DEF OUTPUT PARAM pi-cod-emitente LIKE emitente.cod-emitente  NO-UNDO.    

   ASSIGN pi-cgc = REPLACE(REPLACE(REPLACE(pi-cgc,"/",""),".",""),"-","").

   FOR FIRST emitente
       FIELDS ( cod-emitente identific )
        WHERE emitente.cgc = pi-cgc 
          AND (   emitente.identific = 2             /* Fornecedor */ 
               OR emitente.identific = 3 )  no-lock: /* Ambos      */
   END.

   IF NOT AVAIL emitente THEN
      FOR FIRST emitente
          FIELDS ( cod-emitente )
           WHERE emitente.cgc = pi-cgc NO-LOCK:
        END.

   IF  NOT AVAIL emitente THEN 
       FOR FIRST emitente
           FIELDS ( cod-emitente )
            WHERE emitente.nome-abrev = pi-nome-abrev NO-LOCK:
        END.                

   ASSIGN pi-cod-emitente = IF AVAIL emitente THEN emitente.cod-emitente 
                               ELSE ? .

END PROCEDURE.

PROCEDURE PIEngineRegras:

&IF '{&BF_DIS_VERSAO_EMS}' >= "2.08":U &THEN
DEFINE INPUT  PARAM pTranAction AS CHAR NO-UNDO.
/*DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.*/

/*---[ integraá∆o EMSxNeogrid ]---------------------------------------------------------------------------------*/
FIND FIRST config-tip-operac NO-LOCK
     WHERE config-tip-operac.cod-tip-operac = 'AXRSU001' NO-ERROR.
IF   AVAIL config-tip-operac THEN DO:
    EMPTY TEMP-TABLE tt-variavel.

    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = 'transaction'
           tt-variavel.cod-val-var  = pTranAction.
    /*---[ PAI ]------------------------------------------------------------------------------*/

    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = 'nat-operacao'
           tt-variavel.cod-val-var  = tt-docum-est.nat-operacao.
    
    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = 'cod-servico'
           tt-variavel.cod-val-var  = string(tt-docum-est.cod-servico).

    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = 'aliquota-icm'
           tt-variavel.cod-val-var  = string(tt-docum-est.aliquota-icm).

    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper = 'ativo' /* possui nota fiscal de entrada de ativo*/
           tt-variavel.cod-val-var  = c-ativo.

    RUN cdp/cdapi034.p (INPUT i-ep-codigo-usuario,
                        INPUT tt-docum-est.cod-estabel,
                        INPUT 'AXRSU001',
                        INPUT TABLE tt-variavel,
                        OUTPUT i-cod-regra-utilizada,
                        OUTPUT TABLE tt-retorno,
                        OUTPUT TABLE RowErrors).
   
    IF  CAN-FIND(FIRST tt-retorno
                 WHERE tt-retorno.campo-retorno = 'AXRSU001'
                 AND   tt-retorno.valor-retorno = 'no') THEN DO: 
        RUN PI_gera_tt_log_erro.
        RETURN 'NOK'.
    END.

     for each tt-retorno:
             CASE tt-retorno.campo-retorno:
                 WHEN "nat-operacao" THEN
                     ASSIGN tt-docum-est.nat-operacao = tt-retorno.valor-retorno.
             END CASE.
     end. /* for each tt-retorno: */    

     
     RETURN 'OK'.
END. /* IF  AVAIL  config-tip-operac */
/*---------------------------------------------------------------------------------[ integraá∆o EMSxNeogrid ]---*/
&ENDIF

RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-verificarNaturezaAtivo: /* Verificar se as notas de origem s∆o de ativo imobilizado */

     DEF OUTPUT PARAMETER p-ativo AS CHAR INITIAL "N".
    
     DEF VAR c-nf-nat-oper AS CHAR.
     DEF VAR iDocumentForFreightDistId     AS INT NO-UNDO.  
     DEF VAR iListOfDocumentsFreightDistId AS INT NO-UNDO.  
     
     RUN searchTag IN hGenXml ("ListOfDocumentsForFreightDistribution":U, 1, OUTPUT iListOfDocumentsFreightDistId).
     IF iListOfDocumentsFreightDistId <> ? THEN DO:
    
          RUN getFirstSonId IN hGenXml ( iListOfDocumentsFreightDistId, OUTPUT iDocumentForFreightDistId).
          DO WHILE iDocumentForFreightDistId <> ? :
          
             RUN searchTag  IN hGenXml ("FiscalOperation":U, iDocumentForFreightDistId, OUTPUT iFiscalOperationId).
             RUN getSonVal  IN hGenXml (INPUT iFiscalOperationId, INPUT "FiscalOperationCode":U, OUTPUT c-nf-nat-oper).
    
             FIND FIRST natur-oper WHERE natur-oper.nat-operacao = c-nf-nat-oper NO-LOCK NO-ERROR.
             IF AVAIL natur-oper AND
                natur-oper.venda-ativo = YES THEN DO:
                ASSIGN  p-ativo = "S".
                RETURN "ok".
             END.
          END. /* DocumentForFreightDist */
    
     END. /* ListOfDocumentsFreightDist */
    
END PROCEDURE.

PROCEDURE PI_gera_tt_log_erro:

IF  CAN-FIND(FIRST RowErrors) THEN DO:
    FOR EACH RowErrors 
       WHERE RowErrors.ErrorNumber <> 10 AND
             RowErrors.ErrorType <> "INTERNAL":

        CREATE tt_log_erro. 
        ASSIGN tt_log_erro.ttv_num_cod_erro  = RowErrors.errorNumber    
               tt_log_erro.ttv_des_msg_ajuda = IF RowErrors.errorSubType = "ERROR":U THEN "business_error":U ELSE "business_information":U   
               tt_log_erro.ttv_des_msg_erro  = RowErrors.errorDescription.                                        
    END.
    RETURN 'NOK'.
END. /* IF  CAN-FIND(FIRST RowErrors) */

END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
