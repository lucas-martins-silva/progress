    &ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN274VL 2.00.00.095 } /*** "010095" 15/07/2026 13:10:58 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin274vl MCC}
&ENDIF

/*--------------------------------------------------------------------------
    File       : inbo/boin274vl.p
    Purpose    : Bo com finalidade de validar registros de ordem de compra
    Parameters :
    Notes      :
--------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName ordem-compra
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ordem-compra
&GLOBAL-DEFINE TableLabel ordem-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin274.p) est† com as funá‰es de inclui (createRecord),
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas,
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0

&GLOBAL-DEFINE excludeFrameDefinition YES 

/* Local Preprocessors Definitions ---   */
{cdp/cdcfgmat.i}  /* Include com prÇ-processadores que indicam mudanáas na base */
{cdp/cdcfgdis.i}  /* Definiá∆o dos prÇ-processadores que diferenciam releases*/
{include/i_dbvers.i}

/* Global's Definitions ---                                      */
DEFINE NEW GLOBAL SHARED VARIABLE gr-ordem-compra       AS ROWID    NO-UNDO. /* Indica permiss∆o do usu†rio para manutená∆o de pedidos no programa cc0300 */
DEFINE NEW GLOBAL SHARED VARIABLE gl-bt-despesas-cc0300 AS LOGICAL  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gl-prog-cc9019        AS LOGICAL  NO-UNDO. /*--- Melhorias aprov eletrìnica ---*/
{utp/ut-glob.i} /* Variaveis globais */

/* Local Temp-Table's Definitions ---                                            */

/*--- Include com definiá∆o da temptable RowObject ---*/
{inbo/boin274.i RowObject} 
/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
{method/dboqry.i} 

{cdp/cd0669.i}                      /* tt-erro                                              */
{mpp/mpapi011.i}                    /* tt-param-maq-ep-est                                  */
{adapters/xml/su2/axssu012.i}       /* ttPurchaseOrderLine012, tt_log_erro, tt-pedido-compr */
{inbo/boin178.i tt-item-fornec}
{cxbo/bocx315.i tt-pedido-drb-item} 

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DEFINE TEMP-TABLE tt-erro-aux NO-UNDO /* Compatibilidade CD0666.i */
        FIELD i-sequen AS INTEGER
        FIELD cd-erro  AS INTEGER
        FIELD mensagem AS CHARACTER FORMAT "x(255)":U.

DEFINE TEMP-TABLE tt-erro-mp NO-UNDO
    FIELD i-sequen AS INTEGER
    FIELD cd-erro  AS INTEGER
    FIELD mensagem AS CHARACTER FORMAT "x(255)":U.

DEFINE TEMP-TABLE tt-matriz NO-UNDO
    FIELD cod-unid-neg AS CHARACTER
    FIELD perc-rateio  AS DECIMAL.

DEFINE TEMP-TABLE tt-matriz-om NO-UNDO LIKE unid-negoc-om
    FIELD r-Rowid AS ROWID.

{cdp/cd7300.i1} /* Multiplanta */
{include/i-epc200.i boin274vl}

/* Local Variable's Definitions ---                                            */
DEFINE VARIABLE c-un-anterior           AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-un                    AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-seg-usuario           AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-comp-aux              AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-literal-obs           AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-cod-comprador         AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-ct-codigo             AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-sc-codigo             AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-deposito              AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE i-tp-desp               AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-aux-ordem             AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-lista-alt-ped         AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-estado                AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE v_cod_cta_ctbl          AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE v_des_cta_ctbl          AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE v_des_ccusto            AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE v_num_tip_cta_ctbl      AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE v_num_sit_cta_ctbl      AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE v_ind_finalid_cta       AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE v_cod_finalid           AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE cErroAux                AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-lbl-traducao          AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE da-entrega-ant          AS   DATE                       NO-UNDO.
DEFINE VARIABLE de-preco-unit           AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE de-qtd-ant              AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE de-valor-item           AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE de-valor-total          AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE de-cotacao              AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE h-boin274sd             AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-boin178               AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-bocx341               AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-boin356               AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-boin082               AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-boin841               AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-boin274               AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-boin762               AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-boiv028               AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-boiv037               AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-boiv011               AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h_api_ccusto            AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h_api_cta_ctbl          AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-cdapi024              AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-boiv029               AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-bomn250               AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE hMMVUnidNegoc           AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE apiHandler              AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE iNumPedido              AS   INTEGER                    NO-UNDO. /* N£mero pedido */
DEFINE VARIABLE i-seq-erro              AS   INTEGER INITIAL 0          NO-UNDO.
DEFINE VARIABLE i-tipo-movto            AS   INTEGER                    NO-UNDO.
DEFINE VARIABLE i-seq-aux               AS   INTEGER                    NO-UNDO.
DEFINE VARIABLE i-length                AS   INTEGER                    NO-UNDO.
DEFINE VARIABLE i-sequencia             AS   INTEGER                    NO-UNDO.
DEFINE VARIABLE i-num-ordem-parc        AS   INTEGER                    NO-UNDO.
DEFINE VARIABLE i-estoque               AS   INTEGER                    NO-UNDO.
DEFINE VARIABLE ind                     AS   INTEGER                    NO-UNDO.
DEFINE VARIABLE l-cc0308                AS   LOGICAL                    NO-UNDO.
DEFINE VARIABLE l-erro                  AS   LOGICAL                    NO-UNDO.
DEFINE VARIABLE l-erro-mp               AS   LOGICAL                    NO-UNDO.
DEFINE VARIABLE lErroCo                 AS   LOGICAL                    NO-UNDO. /* Controle de erro */
DEFINE VARIABLE lConsiste               AS   LOGICAL                    NO-UNDO. /* Executa Consistàncias */
DEFINE VARIABLE l-seg-cc0300            AS   LOGICAL INITIAL NO         NO-UNDO.
DEFINE VARIABLE l-cria                  AS   LOGICAL                    NO-UNDO.
DEFINE VARIABLE l-unid-negoc-mi         AS   LOGICAL                    NO-UNDO.
DEFINE VARIABLE l-utiliza-ccusto        AS   LOGICAL                    NO-UNDO.
DEFINE VARIABLE l-unid-neg              AS   LOGICAL INITIAL NO         NO-UNDO.
DEFINE VARIABLE l-processo-paradigma    AS   LOGICAL INITIAL NO         NO-UNDO.
DEFINE VARIABLE l-integra-mla           AS   LOGICAL                    NO-UNDO.
DEFINE VARIABLE rChave-aux              AS   ROWID                      NO-UNDO.
DEFINE VARIABLE de-qt-saldo             LIKE prazo-compra.quant-saldo   NO-UNDO.
DEFINE VARIABLE iEmpresa                LIKE param-global.empresa-prin  NO-UNDO.
DEFINE VARIABLE cCodEstabelec           LIKE pedido-compr.end-entrega   NO-UNDO.
DEFINE VARIABLE de-qtde-parcela         LIKE prazo-compra.quantidade    NO-UNDO.
DEFINE VARIABLE c-it-codigo             LIKE ordem-compra.it-codigo     NO-UNDO.
DEFINE VARIABLE l-existe-op             AS   LOGICAL                    NO-UNDO.

/*  Vari†veis de validaá∆o pedidos integrados ME   */
DEFINE VARIABLE isOrderIntegrMe                  AS LOGICAL NO-UNDO.
DEFINE VARIABLE h-ccPedidoCompraValidaIntegraMe  AS HANDLE  NO-UNDO.

{cdp/cd9590.i}    /*Include verificaá∆o Unidade Neg¢cio - l-unidade-negocio, l-dis-unid-negoc, l-mat-unid-negoc*/
{cdp/cd9731.i6}   /* l-min-mmi                                                                                 */
{inbo/boin841.i tt-item-fornec-umd}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName}     FOR {&TableName}.
DEFINE BUFFER bf-ordem           FOR ordem-compra.
DEFINE BUFFER bPrazoCompra       FOR prazo-compra.     
DEFINE BUFFER b-Ordem-Compra     FOR ordem-compra.     
DEFINE BUFFER bf-prazo-compra    FOR prazo-compra.     
DEFINE BUFFER bf-pedido-drb-item FOR pedido-drb-item.  
DEFINE BUFFER bMatrizItem        FOR matriz-rat-item.  
DEFINE BUFFER bMatrizContr       FOR matriz-rat-contr. 
DEFINE BUFFER b-prazo-compra     FOR prazo-compra.

/* Local Boot Informations ---                                            */
ASSIGN l-integra-mla = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "Integra_MLA_EMS":U AND funcao.ativo).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow:
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB)
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 24.38
         WIDTH              = 45.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram


{method/svc/autentic/autentic.i &vUserName="c-seg-usuario"}

FIND FIRST param-estoq   NO-LOCK NO-ERROR.
FIND FIRST param-compra  NO-LOCK NO-ERROR.
FIND FIRST param-global  NO-LOCK NO-ERROR.
FIND FIRST param-contrat NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AlteraComentarioOrdem DBOProgram
PROCEDURE AlteraComentarioOrdem :
/*------------------------------------------------------------------------------
  Purpose:     Passa a Ordem Compra de n∆o cotada (1) p/ cotada (2).
  Parameters:  ipar1 : r-ordem-compra : rowid da ordem-compra
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prOrdemCompra AS ROWID       NO-UNDO.
    DEFINE INPUT PARAMETER pComentario   AS CHARACTER   NO-UNDO.

    FIND FIRST ordem-compra 
         WHERE ROWID(ordem-compra) = prOrdemCompra EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL ordem-compra THEN
       ASSIGN ordem-compra.comentarios = pComentario.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alteraCompradorEDepositoOrdem DBOProgram
PROCEDURE alteraCompradorEDepositoOrdem :
/*------------------------------------------------------------------------------
  Purpose: Valida e altera o comprador e o dep¢sito das ordens selecionadas.
  Parameters:
             ipar1 : prOrdemCompra  : rowid da ordem de compra
             ipar2 : pcCodDepos     : c¢digo do dep¢sito
             ipar3 : pcCodComprado  : c¢digo do comprador
             ipar4 : plCodDepos     : indica se o dep¢sito dever† ser alterado
             ipar5 : plCodComprado  : indica se o comprador dever† ser alterado
             opar6 : rowErrors      : tabela de erros
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prOrdemCompra  AS ROWID         NO-UNDO.
    DEFINE INPUT  PARAMETER pcCodDepos     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER pcCodComprado  AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER plCodDepos     AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER plCodComprado  AS LOGICAL       NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FOR FIRST comprador FIELDS(cod-comprado) 
        WHERE comprador.cod-comprado = pcCodComprado NO-LOCK: END.

    IF plCodComprado THEN DO:

        IF NOT AVAIL comprador THEN DO:
            
            {utp/ut-liter.i "Comprador" *}
            {method/svc/errors/inserr.i &ErrorNumber="47"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    END.

    FOR FIRST deposito FIELDS(cod-depos)
        WHERE deposito.cod-depos = pcCodDepos NO-LOCK: END.

    IF plCodDepos THEN DO:

        IF NOT AVAIL deposito THEN DO:
            
            {utp/ut-liter.i "Deposito" *}
            {method/svc/errors/inserr.i &ErrorNumber="47"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    ELSE DO:

        IF plCodDepos OR plCodComprado THEN DO:

            FIND FIRST ordem-compra
                 WHERE ROWID(ordem-compra) = prOrdemCompra EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL ordem-compra THEN DO:

                IF plCodDepos THEN
                    ASSIGN ordem-compra.dep-almoxar  = pcCodDepos.

                IF plCodComprado THEN
                    ASSIGN ordem-compra.cod-comprado = pcCodComprado.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aprovaAddOrdemCompraPedidos DBOProgram
PROCEDURE aprovaAddOrdemCompraPedidos :
/*------------------------------------------------------------------------------
  Purpose:   Faz a aprovaá∆o eletrìnica das ordens
  Parameters:  ipar1 : prOrdemCompra : rowid da ordem de compra
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prOrdemCompra AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors .
    
    DEFINE VARIABLE l-elimina-pend    AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-exibe-msg-aprov AS LOGICAL INITIAL YES NO-UNDO.

    IF NOT AVAIL param-aprov THEN
        FIND FIRST param-aprov NO-LOCK NO-ERROR.
    
    FOR FIRST ordem-compra FIELDS(numero-ordem num-pedido cod-estabel) 
        WHERE ROWID(ordem-compra)     = prOrdemCompra NO-LOCK: END.

    FOR FIRST pedido-compr FIELDS(num-pedido emergencial) 
        WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.

    IF AVAIL param-aprov AND param-compra.log-1 AND AVAIL ordem-compra AND AVAIL pedido-compr THEN DO:
        
        assign cCodEstabelec = pedido-compr.end-entrega.
        
        /* Verifica se dever† gerar pendància de aprovaá∆o. */
        IF param-aprov.aprov-total-pedido THEN DO:

            FIND FIRST bf-ordem 
                 WHERE bf-ordem.num-pedido   =  pedido-compr.num-pedido
                   AND bf-ordem.situacao     <> 4 NO-LOCK NO-ERROR. /* Eliminada */

            IF NOT AVAIL bf-ordem THEN 
               ASSIGN l-elimina-pend = YES.
        END.
        ELSE DO:
            IF ordem-compra.situacao = 4 THEN /* Eliminada */
               ASSIGN l-elimina-pend = YES.
        END.

        IF l-elimina-pend THEN DO:
            
            IF pedido-compr.emergencial THEN
                RUN cdp/cdapi171.p (6,3,ROWID(ordem-compra)).
            ELSE
                RUN cdp/cdapi171.p (4,3,ROWID(ordem-compra)).
        END.
        ELSE DO:
            
            IF CAN-FIND(FIRST cotacao-item
                        WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem AND cotacao-item.cot-aprovada) THEN DO:
                
                RUN lap/mlaapi099.p (INPUT 6). /* Verifica se ha excecao de aprovacao */

                IF pedido-compr.emergencial and param-aprov.aprova-emerg THEN DO:
                    
                    IF  l-integra-mla AND RETURN-VALUE <> "NOK":U THEN DO:

                        FIND FIRST mla-param-aprov
                             WHERE mla-param-aprov.ep-codigo   = i-ep-codigo-usuario
                               AND mla-param-aprov.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
                        
                        /* Tratamento realizado para o envio de e-mail quando se tem o parametro cond pagto e valor marcado*/
                        IF  c-estado = "Add":U 
                        AND AVAIL mla-param-aprov 
                        AND mla-param-aprov.log-cond-pagto
                        AND param-aprov.aprov-total-pedido THEN
                            RUN cdp/cdapi171.p (6,1,prOrdemCompra) NO-ERROR.
                        ELSE
                            RUN cdp/cdapi171.p (6,2,prOrdemCompra) NO-ERROR.
                    END.
                    ELSE
                        RUN cdp/cdapi171.p (6,2,prOrdemCompra) NO-ERROR.    /* Emergencial */

                    IF c-estado = "Update":U THEN
                        RUN pi-valida-exibe-msg-aprov-eletr (INPUT  prOrdemCompra,
                                                             OUTPUT l-exibe-msg-aprov).

                    IF l-exibe-msg-aprov THEN   
                        RUN mensagemAprEletrOrdemCompra (prOrdemCompra, 6). /* retorna RowErrors */
                END.
                ELSE DO:
                    IF NOT pedido-compr.emergencial and param-aprov.aprova-pedido THEN DO:
                        
                        RUN lap/mlaapi099.p (INPUT 4). /* Verifica se ha excecao de aprovacao */

                        IF l-integra-mla AND RETURN-VALUE <> "NOK":U THEN DO:

                            FIND FIRST mla-param-aprov
                                 WHERE mla-param-aprov.ep-codigo   = i-ep-codigo-usuario
                                   AND mla-param-aprov.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
                            
                            /* Tratamento realizado para o envio de e-mail quando se tem o parametro cond pagto e valor marcado*/
                            IF c-estado = "Add":U 
                            AND AVAIL mla-param-aprov 
                            AND mla-param-aprov.log-cond-pagto 
                            AND param-aprov.aprov-total-pedido THEN
                                RUN cdp/cdapi171.p (4,1,prOrdemCompra) NO-ERROR.
                            ELSE
                                RUN cdp/cdapi171.p (4,2,prOrdemCompra) NO-ERROR.
    
                        END.
                        ELSE
                            RUN cdp/cdapi171.p (4,2,prOrdemCompra) NO-ERROR.
                            
                        IF c-estado = "Update":U THEN
                            RUN pi-valida-exibe-msg-aprov-eletr (INPUT  prOrdemCompra,
                                                                 OUTPUT l-exibe-msg-aprov).

                        IF l-exibe-msg-aprov THEN
                            RUN mensagemAprEletrOrdemCompra (prOrdemCompra, 4).
                    END.
                    ELSE DO:
                        {method/svc/errors/inserr.i &ErrorNumber="16760" &ErrorType="EMS" &ErrorSubType="ERROR"}
                    END.
                END.
            END.
        END. /* NOT l-elimina-pend */
        
        RUN piEnviaPortalCompras. /* Integraá∆o EMS x Webb */
    END.
    ELSE DO:
        {method/svc/errors/inserr.i &ErrorNumber="16760" &ErrorType="EMS" &ErrorSubType="ERROR"}
    END.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDadosOrdemCompraPedEmerg DBOProgram
PROCEDURE atualizaDadosOrdemCompraPedEmerg :
/*------------------------------------------------------------------------------
  Purpose: Converte o valor da cotaá∆o para a moeda desejada,
           Atualiza estat°stica,
           Atualiza £ltima reposiá∆o do item e seu preáo correspondente.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc-erro-help AS  CHARACTER              NO-UNDO.
    DEFINE VARIABLE lRetorno        AS   LOGICAL                NO-UNDO.
    DEFINE VARIABLE lModuloGe       AS   LOGICAL                NO-UNDO.
    DEFINE VARIABLE c-ct-codigo-inp LIKE ordem-compra.ct-codigo NO-UNDO.
    DEFINE VARIABLE c-sc-codigo-inp LIKE ordem-compra.sc-codigo NO-UNDO.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-ERROR.

    ASSIGN iEmpresa = estabelec.ep-codigo WHEN AVAIL estabelec.

    ASSIGN ordem-compra.ep-codigo = iEmpresa.

    FOR FIRST pedido-compr FIELDS(num-pedido cod-emitente data-pedido gera-edi natureza cod-cond-pag nr-processo)
        WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.

    FOR FIRST item NO-LOCK
        WHERE item.it-codigo = ordem-compra.it-codigo : END.

    FOR FIRST emitente FIELDS(cod-emitente cod-gr-forn)
        WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK: END.

    IF AVAIL pedido-compr THEN DO:

        ASSIGN ordem-compra.cod-emitente = pedido-compr.cod-emitente
               ordem-compra.natureza     = pedido-compr.natureza
               ordem-compra.cod-cond-pag = pedido-compr.cod-cond-pag
               ordem-compra.num-pedido   = pedido-compr.num-pedido
               ordem-compra.data-pedido  = pedido-compr.data-pedido
               ordem-compra.nr-processo  = pedido-compr.nr-processo.
    END.

    RUN ccp/ccapi001.p (INPUT ROWID(ordem-compra)).

    /*--- MIN X MMI - Preenche num-ord-inv a partir de uma ordem de manutená∆o */
    IF  l-min-mmi
    AND param-global.modulo-in
    AND ordem-compra.ordem-servic <> 0
    AND ordem-compra.num-ord-inv   = 0 THEN DO:

        RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.
        RUN BuscaOrdemInvOrdProd IN h-boiv028 (INPUT ordem-compra.ordem-servic, INPUT-OUTPUT ordem-compra.num-ord-inv).
        DELETE PROCEDURE h-boiv028.
    END.

    /* ---------- Modulo Investimento -------------------------------------*/
    IF param-global.modulo-in THEN DO:
        
        IF ordem-compra.num-ord-inv <> 0 AND ordem-compra.ordem-servic = 0 THEN DO:

            IF AVAIL estabelec THEN
                ASSIGN ordem-compra.ep-codigo = estabelec.ep-codigo.
    
            RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.
            RUN ContaContabilInvestimento IN h-boiv028 (INPUT  ROWID(ordem-compra),
                                                        OUTPUT c-ct-codigo-inp,
                                                        OUTPUT c-sc-codigo-inp,
                                                        INPUT-OUTPUT TABLE RowErrors).
    
            ASSIGN ordem-compra.ct-codigo = c-ct-codigo-inp
                   ordem-compra.sc-codigo = c-sc-codigo-inp.
    
            DELETE PROCEDURE h-boiv028.
            ASSIGN h-boiv028 = ?.
        END.

        IF ordem-compra.ct-codigo <> "":U THEN DO:

            {inp/inapi060.i ordem-compra.cod-estabel ordem-compra.ct-codigo ordem-compra.sc-codigo ordem-compra.num-ord-inv NO tt-erro}

            /* conforme help dp IN0101 para ordem de producao/MI n„o deve ser validado a conta */
            IF  ordem-compra.num-ord-inv  <> 0
            AND ordem-compra.ordem-servic <> 0 THEN DO:
                FIND FIRST tt-erro
                    WHERE tt-erro.cd-erro = 28723
                       OR tt-erro.cd-erro = 28722 NO-ERROR.
                IF AVAIL tt-erro THEN
                    DELETE tt-erro.
            END.            

            FOR EACH tt-erro:

                RUN utp/ut-msgs.p (INPUT "help", INPUT 28723, INPUT tt-erro.c-param). 

                CREATE RowErrors.
                ASSIGN RowErrors.ErrorSequence    = tt-erro.i-sequen
                       RowErrors.ErrorNumber      = tt-erro.cd-erro
                       RowErrors.ErrorType        = "EMS":U
                       RowErrors.ErrorSubType     = "ERROR":U
                       RowErrors.ErrorDescription = tt-erro.mensagem
                       RowErrors.ErrorHelp        = RETURN-VALUE.
            END.
        END.
    END. /* param-global.modulo-in */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AtualizaDadosOrdemCompraSemPedido DBOProgram
PROCEDURE AtualizaDadosOrdemCompraSemPedido :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE PARAMETER BUFFER b-ordem-compra FOR ordem-compra.

    IF AVAIL b-ordem-compra THEN DO:

        FOR FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel = b-ordem-compra.cod-estabel: 

            ASSIGN iEmpresa = estabelec.ep-codigo.
        END.

        ASSIGN b-ordem-compra.ep-codigo = iEmpresa.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuscaRowidAltPed DBOProgram
PROCEDURE BuscaRowidAltPed :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-lista-alt-ped AS CHARACTER.

    ASSIGN p-lista-alt-ped = c-lista-alt-ped.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cotaOrdemCompra DBOProgram
PROCEDURE cotaOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     Passa a Ordem Compra de n∆o cotada (1) p/ cotada (2).
  Parameters:  ipar1 : r-ordem-compra : rowid da ordem-compra
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prOrdemCompra AS ROWID NO-UNDO.

    FIND FIRST ordem-compra
         WHERE ROWID(ordem-compra) = prOrdemCompra EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL ordem-compra THEN
       ASSIGN ordem-compra.cota-ordem =  2 .

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteOrdemCompraAndParcelas DBOProgram
PROCEDURE deleteOrdemCompraAndParcelas :
/*------------------------------------------------------------------------------
  Purpose:  elimina a ordem de compra e suas parcelas
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER prOrdemCompra AS ROWID NO-UNDO.
    DEFINE OUTPUT       PARAMETER TABLE FOR RowErrors.

    DISABLE TRIGGERS FOR LOAD OF PRAZO-COMPRA.
    DISABLE TRIGGERS FOR LOAD OF COTACAO-ITEM.

    /** Copiado da trigger de ordem-compra - pois estava causando problemas para deletar a ordem.**/

    DEFINE VARIABLE l-invest    AS   LOGICAL                 NO-UNDO.
    DEFINE VARIABLE l-ord-inv   AS   LOGICAL                 NO-UNDO.
    DEFINE VARIABLE l-erro      AS   LOGICAL                 NO-UNDO.
    DEFINE VARIABLE de-tot-req  LIKE prazo-compra.quantidade NO-UNDO.
    
    DEFINE VARIABLE h-ccOrdemCompraValidaIntegraMe AS HANDLE NO-UNDO.
    DEFINE VARIABLE l-ordem-integrada-me           AS LOGICAL NO-UNDO.
    
    //Valida OC integrada com o Mercado Eletronico
    IF NOT VALID-HANDLE(h-ccOrdemCompraValidaIntegraMe) THEN
        RUN ccp/ccOrdemCompraValidaIntegraMe.p PERSISTENT SET h-ccOrdemCompraValidaIntegraMe.
               
    RUN verifica-ordem-compra IN h-ccOrdemCompraValidaIntegraMe (INPUT  RowObject.numero-ordem,
                                                                 OUTPUT l-ordem-integrada-me).

    IF VALID-HANDLE(h-ccOrdemCompraValidaIntegraMe) THEN DO:
        DELETE PROCEDURE h-ccOrdemCompraValidaIntegraMe.
        ASSIGN h-ccOrdemCompraValidaIntegraMe = ?.
    END.
                                                                   
    IF l-ordem-integrada-me THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="58000"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters= RowObject.numero-ordem}
        RETURN "NOK":U.   
    END. 
    
    //Fim valida OC integrada com ME
    
    FOR FIRST ordem-compra FIELDS(cod-comprado situacao nr-contrato int-1 it-codigo cod-estabel num-ord-inv numero-ordem nr-requisicao)
        WHERE ROWID(ordem-compra) = prOrdemCompra NO-LOCK: END.

    IF param-global.modulo-in THEN
        ASSIGN l-invest = YES.
    ELSE
        ASSIGN l-invest = NO.

    IF ordem-compra.situacao <> 1 AND ordem-compra.situacao <> 5 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="5987" &ErrorType="EMS" &ErrorSubType="ERROR" }
        RETURN "NOK":U.
    END.

    IF ordem-compra.nr-contrato <> 0 THEN DO:
        /* mensagem: Ordem possui numero de contrato. */
        {method/svc/errors/inserr.i &ErrorNumber="6686" &ErrorType="EMS" &ErrorSubType="ERROR" }
        RETURN "NOK":U.
    END.

    RUN ccp/ccapi199.p(INPUT "Ordem-compra":U, ROWID(ordem-compra), OUTPUT l-erro).

    /* TIJUCAS */
    IF l-erro THEN DO:
        /*Ordem so pode ser alterada no estabelecimento gestor.*/
        {utp/ut-liter.i "Ordem_Compra" *}
        ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "Gestor" *}
        
        {method/svc/errors/inserr.i &ErrorNumber="18200"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-traducao + '~~~~' + TRIM(RETURN-VALUE)"}
        RETURN "NOK":U.
    END.

    IF param-global.modulo-pl OR param-global.modulo-pi AND AVAIL ordem-compra THEN
        RUN cdp/cd7000.p (INPUT 0, ordem-compra.it-codigo, ordem-compra.cod-estabel). /* usado p/planejamento */

    /* ---------- Moduto Investimento -----------*/
    IF param-global.modulo-in AND ordem-compra.num-ord-inv <> 0 THEN DO:

        RUN ivbo/boiv037.p PERSISTENT SET h-boiv037.
        FOR EACH prazo-compra FIELDS(numero-ordem)
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:

            RUN DeleteProgEntr IN h-boiv037 (INPUT ROWID(prazo-compra), INPUT-OUTPUT TABLE RowErrors).
        END.
        DELETE PROCEDURE h-boiv037.
        ASSIGN h-boiv037 = ?.

        RUN ivbo/boiv011.p PERSISTENT SET h-boiv011.

        FOR EACH cotacao-item FIELDS(numero-ordem)
           WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
            
            RUN DeleteCotacaoInv IN h-boiv011 (INPUT ROWID(cotacao-item), INPUT-OUTPUT TABLE RowErrors).

        END.
        DELETE PROCEDURE h-boiv011.
        ASSIGN h-boiv011 = ?.

        RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.
        RUN DeleteOrdPed IN h-boiv028 (INPUT ROWID(ordem-compra), INPUT-OUTPUT TABLE RowErrors).

        DELETE PROCEDURE h-boiv028.
        ASSIGN h-boiv028 = ?.
    END.

    /* Tratamento Requisiá∆o/Solicitaá∆o de compra */
    IF AVAIL ordem-compra AND ordem-compra.nr-requisicao <> 0 THEN
        RUN ccp/ccapi020a.p (ordem-compra.numero-ordem).

    /** Multiplanta **/
    IF AVAIL param-global AND param-global.modulo-mp THEN
        RUN ccp/ccapi200.p(INPUT "Ordem-compra":U, INPUT ROWID(ordem-compra), INPUT 3, INPUT-OUTPUT TABLE tt-erro-mp).

    /**  Elimina cotacoes **/

    RUN inbo/boin082.p PERSISTENT SET h-boin082.
    FOR EACH cotacao-item FIELDS(numero-ordem)
       WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
        
        RUN setConstraintNumOrdem IN h-boin082 (input cotacao-item.numero-ordem).
        /** Delete cotacao-item. **/
        ASSIGN rChave-aux = rowid(cotacao-item).
        RUN openQueryStatic IN h-boin082 (INPUT "ByCotacao":U).
        RUN validateDelete  IN h-boin082 (INPUT-OUTPUT rChave-aux, OUTPUT TABLE RowErrors).
    END.

    DELETE PROCEDURE h-boin082.
    ASSIGN h-boin082 = ?.

    /**  Elimina pendencias **/
    FOR EACH doc-pend-aprov
       WHERE doc-pend-aprov.ind-tip-doc  = 3
         AND doc-pend-aprov.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:
        DELETE doc-pend-aprov.
    END.

    /**  Elimina parcelas **/
    RUN inbo/boin356.p PERSISTENT SET h-boin356.

    FOR EACH prazo-compra FIELDS(quantidade numero-ordem)
       WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:

        ASSIGN de-tot-req = de-tot-req + prazo-compra.quantidade.
        /** delete prazo-compra. **/
        ASSIGN rChave-aux = ROWID(prazo-compra).
        RUN setConstraintNumOrdem IN h-boin356 (INPUT prazo-compra.numero-ordem).
        RUN openQueryStatic       IN h-boin356 (INPUT "byOrdem":U).
        RUN validateDelete        IN h-boin356 (INPUT-OUTPUT rChave-aux, OUTPUT TABLE RowErrors).
    END.
    DELETE PROCEDURE h-boin356.
    ASSIGN h-boin356 = ?.

    FIND FIRST RowErrors NO-LOCK NO-ERROR.
    IF NOT AVAIL RowErrors THEN DO:

        RUN inbo/boin274.p PERSISTENT SET h-boin274.

        RUN setConstraintNumPedido IN h-boin274 (INPUT ordem-compra.num-pedido).
        RUN openQueryStatic        IN h-boin274 ("ByPedido":U).
        RUN validateDelete         IN h-boin274 (INPUT-OUTPUT prOrdemCompra, OUTPUT TABLE RowErrors).

        DELETE PROCEDURE h-boin274.
        ASSIGN h-boin274 = ?.

        RETURN "OK":U.
    END.
    ELSE
        RETURN "NOK":U.

 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Atualiza tabela de Integraá∆o com Mercado Eletronico*/
    IF NOT VALID-HANDLE(apiHandler) THEN DO:
        RUN ccp/ccOrdemCompraValidaIntegraMe.p PERSISTENT SET apiHandler.
    END.
    
    RUN altera-status-oc-integr-me IN apiHandler (INPUT ordem-compra.numero-ordem,
                                                  INPUT 3,
                                                  INPUT 1,
                                                  INPUT v_cod_usuar_corren).
    
    FINALLY:
        DELETE PROCEDURE apiHandler NO-ERROR.
    END FINALLY.
    
END PROCEDURE. 
 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE devolveOrdensGrpCompraOrdemCompra DBOProgram
PROCEDURE devolveOrdensGrpCompraOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: Desfaz o Relacionamento das ordens do grupo de compra com  as ordens do comprador.
  Parameters:  ipar1 : rw-row-1         : rowid da tabela gr-cmp-comprad
               ipar2 : rw-row-2         : rowid da tabela ordem-compra
               ipar3 : c-usuario-corren : codigo do usuario corrente
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER rw-row-1         AS ROWID        NO-UNDO.
    DEFINE INPUT PARAMETER rw-row-2         AS ROWID        NO-UNDO.
    DEFINE INPUT PARAMETER c-usuario-corren AS CHARACTER    NO-UNDO.

    ASSIGN c-seg-usuario = c-usuario-corren.

    FOR FIRST gr-cmp-comprad FIELDS(cod-grp-compra)
        WHERE ROWID(gr-cmp-comprad) = rw-row-1 NO-LOCK: END.

    IF AVAIL gr-cmp-comprad THEN DO:

        FIND FIRST ordem-compra
             WHERE ROWID(ordem-compra) = rw-row-2 EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL(ordem-compra) THEN DO:

            ASSIGN c-comp-aux                         = ordem-compra.cod-comprado
                   ordem-compra.cod-comprado          = "".

            &if "{&DBType}" <> "oracle" &then
            ASSIGN OVERLAY(ordem-compra.char-2,188,12) = gr-cmp-comprad.cod-grp-compra.
            &else
            ASSIGN OVERLAY(ordem-compra.char-2,88,12)  = gr-cmp-comprad.cod-grp-compra.
            &endif

            IF ordem-compra.situacao = 5 THEN DO:

                FOR FIRST cotacao-item FIELDS(numero-ordem log-1)
                    WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                      AND cotacao-item.log-1 NO-LOCK: 
                    
                    RUN cdp/cdapi171.p(3,3,ROWID(cotacao-item)).
                END.
            end.

            IF ordem-compra.situacao = 3 THEN DO: /* Cotada */

                ASSIGN ordem-compra.situacao = 5. /* Em Cotacao */

                FOR FIRST cotacao-item FIELDS(numero-ordem cot-aprovada)
                    WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                      AND cotacao-item.cot-aprovada NO-LOCK: 

                    RUN cdp/cdapi171.p(3,3,ROWID(cotacao-item)).
                END.
            END.

            /*---------------------- Multi-Planta ----------------------*/
            ASSIGN c-transacao = "MAT002":U.
            {cdp/cd7300.i5 "001" c-transacao}

            IF param-global.modulo-mp AND tt-replica-msg.log-replica-msg THEN DO:
                
                FOR FIRST comprador FIELDS(cod-comprado corporativo)
                    WHERE comprador.cod-comprado = c-comp-aux NO-LOCK: 

                    IF comprador.corporativo THEN DO:
                        
                        /** Eliminaá∆o das Parcelas **/
                        FOR EACH prazo-compra NO-LOCK
                           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:

                            IF param-global.modulo-mp AND tt-replica-msg.log-replica-msg THEN DO:
                                
                                CREATE tt-dados-env.
                                ASSIGN tt-dados-env.num-sequencia  = i-seq
                                      tt-dados-env.cod-tipo-reg   = 65
                                      tt-dados-env.ind-tipo-movto = 3
                                      tt-dados-env.identif-msg    = STRING(prazo-compra.numero-ordem) + " , ":U + STRING(prazo-compra.parcela).

                               RAW-TRANSFER prazo-compra TO tt-dados-env.conteudo-msg.
                               ASSIGN i-seq = i-seq + 1.
                           END.
                        END.
                        
                        /** Eliminaá∆o da Ordem **/
                        CREATE tt-dados-env.
                        ASSIGN tt-dados-env.num-sequencia  = i-seq
                               tt-dados-env.cod-tipo-reg   = 64
                               tt-dados-env.ind-tipo-movto = 3
                               tt-dados-env.identif-msg    = STRING(ordem-compra.numero-ordem).

                        RAW-TRANSFER ordem-compra TO tt-dados-env.conteudo-msg.
                        ASSIGN i-seq = i-seq + 1.
                    END.
                END.
            END.
        END. /* AVAIL(ordem-compra) */
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaOrdensCompraComMultiPlanta DBOProgram
PROCEDURE eliminaOrdensCompraComMultiPlanta :
/*------------------------------------------------------------------------------
  Purpose:    Elimina ordens de compra do pedido de compra.
  Parameters: ipar1 : rOrdemCompra  : rowid da tabela ordem-compra
              ipar2 : c-seg-usuario : usuario corrente
              ipar3 : c-motivo      : motivo
              ipar3 : l-elimina     : yes - elimina / no - desvincula apenas
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER rOrdemCompra    AS ROWID         NO-UNDO.
    DEFINE INPUT PARAMETER p-c-seg-usuario AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER c-motivo        AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER l-elimina       AS LOGICAL       NO-UNDO.

    DEFINE VARIABLE c-elimina           AS CHARACTER FORMAT "x(2000)":U NO-UNDO.
    DEFINE VARIABLE l-eliminado         AS LOGICAL                      NO-UNDO.
    DEFINE VARIABLE i-num-pedido        AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE l-portal-paradigma  AS LOGICAL                      NO-UNDO.

    ASSIGN c-seg-usuario = IF  p-c-seg-usuario <> "":U THEN p-c-seg-usuario ELSE c-seg-usuario.

    EMPTY TEMP-TABLE RowErrors.

    /*Teste funcao paradigma */
    IF CAN-FIND(FIRST funcao NO-LOCK
                WHERE funcao.cd-funcao = "spp-portal-paradigma":U
                  AND funcao.ativo) THEN DO:

        IF NOT AVAIL param-compra THEN
            FIND FIRST param-compra NO-LOCK NO-ERROR.

        IF AVAIL param-compra AND
        &IF '{&bf_mat_versao_ems}' < '2.09' &THEN
            SUBSTRING(param-compra.char-2,103,1) = "S":U
        &ELSE
            param-compra.log-portal-paradigma
        &ENDIF THEN DO:
            ASSIGN l-portal-paradigma = YES.
        END.
    END.

    FIND FIRST ordem-compra
         WHERE ROWID(ordem-compra) = rOrdemCompra  EXCLUSIVE-LOCK NO-ERROR.

    IF c-nom-prog-dpc-mg97  <> ""
    OR c-nom-prog-appc-mg97 <> ""
    OR c-nom-prog-upc-mg97  <> "" THEN DO:
        
        FOR EACH tt-epc
            WHERE tt-epc.cod-event = "before_delete_ordem-compra":
            DELETE tt-epc.
        END.

        {include/i-epc200.i2 &CodEvent="'before_delete_ordem-compra'"
                             &CodParameter="'TABLE-ROWID'"
                             &ValueParameter=STRING(ROWID(ordem-compra))}

        {include/i-epc200.i2 &CodEvent="'before_delete_ordem-compra'"
                             &CodParameter="'OBJECT-HANDLE'"
                             &ValueParameter=STRING(THIS-PROCEDURE)}

        {include/i-epc201.i "before_delete_ordem-compra"}

        IF  RETURN-VALUE = "NOK":U THEN
            RETURN.
    END.

    ASSIGN ordem-compra.usuario      = {cdp/cd7777.i}
           ordem-compra.data-atualiz = TODAY
           ordem-compra.hora-atualiz = STRING(TIME,"hh:mm:ss":U)
           ordem-compra.comentarios  = c-motivo.

    IF l-elimina THEN DO:     /* eliminaá∆o */
       
        ASSIGN ordem-compra.situacao = 4.  /* Eliminada */
        
        /* Atualiza tabela de Integraá∆o com Mercado Eletronico*/
        IF NOT VALID-HANDLE(apiHandler) THEN DO:
            RUN ccp/ccOrdemCompraValidaIntegraMe.p PERSISTENT SET apiHandler.
        END.
    
        RUN altera-status-oc-integr-me IN apiHandler (INPUT ordem-compra.numero-ordem,
                                                      INPUT 3,
                                                      INPUT 1,
                                                      INPUT v_cod_usuar_corren).
    
    

        run cdp/cdapi197.p (INPUT ROWID(ordem-compra), 
                            INPUT ?,
                            INPUT 1,                         /*funcao: 1*/
                            OUTPUT TABLE RowErrors APPEND).  
       
    END.
    ELSE /* Desvinculaá∆o */                  
        ASSIGN ordem-compra.situacao = 3. /* Cotada */

    FOR EACH prazo-compra
       WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:

        ASSIGN prazo-compra.situacao    = ordem-compra.situacao
               prazo-compra.usuario-alt = {cdp/cd7777.i}
               prazo-compra.data-alter  = TODAY.
    END.

    FOR FIRST emitente FIELDS(cod-emitente nome-abrev)
        WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK: END.
    
    {utp/ut-liter.i Eliminaá∆o_de_Ordens mcc R}
    ASSIGN c-literal-obs = TRIM(RETURN-VALUE).

    CREATE alt-ped.
    ASSIGN alt-ped.data         = TODAY
           alt-ped.hora         = STRING(TIME,"HH:MM:SS":U)
           alt-ped.usuario      = {cdp/cd7777.i}
           alt-ped.num-pedido   = ordem-compra.num-pedido
           alt-ped.nome-abrev   = emitente.nome-abrev
           alt-ped.numero-ordem = ordem-compra.numero-ordem
           alt-ped.cod-cond-pag = ?
           alt-ped.observacao   = "# ":U + c-literal-obs.

    FIND FIRST pedido-compr 
         WHERE pedido-compr.num-pedido = ordem-compra.num-pedido EXCLUSIVE-LOCK NO-ERROR.

    ASSIGN c-elimina = pedido-compr.mot-elimina + CHR(10) + CHR(10) 
                     + "== ":U + "Usu†rio":U         + ": ":U                     + c-seg-usuario 
                     + " = ":U + "Ordem Eliminada":U + ": ":U                     + STRING(ordem-compra.numero-ordem) 
                     + " = ":U + "Data:":U + ": ":U  + string(today,"99/99/9999") + " =======":U
                     + CHR(10) + c-motivo.

    ASSIGN pedido-compr.mot-elimina  = substring(c-elimina,1,2000).

    IF param-global.modulo-pl OR param-global.modulo-pi AND AVAIL ordem-compra THEN
        RUN cdp/cd7000.p (INPUT 0, ordem-compra.it-codigo, ordem-compra.cod-estabel).  /*usado p/planejamento*/

    ASSIGN i-num-pedido = ordem-compra.num-pedido.

    IF CAN-FIND(FIRST pedido-compr 
                WHERE pedido-compr.num-pedido = ordem-compra.num-pedido) AND
        NOT CAN-FIND(FIRST b-ordem-compra WHERE
                     b-ordem-compra.num-pedido = ordem-compra.num-pedido AND
                     b-ordem-compra.situacao <> 4) /* Eliminada */  THEN DO:

        FIND FIRST pedido-compr
             WHERE pedido-compr.num-pedido = ordem-compra.num-pedido EXCLUSIVE-LOCK NO-ERROR.

        ASSIGN pedido-compr.situacao = 3. /* Eliminado */

        /* Chamar api do Paradigma */
        IF l-portal-paradigma THEN DO:

            RUN ccp/ccapi342.p (INPUT  "pedido-compr":U, INPUT  ROWID(pedido-compr), OUTPUT TABLE RowErrors).
            IF RETURN-VALUE = "NOK":U THEN
                UNDO, RETURN "NOK":U.
        END.

        {utp/ut-liter.i Eliminaá∆o_de_Pedidos mcc R}
        ASSIGN c-literal-obs = RETURN-VALUE.
        
        CREATE alt-ped.
        ASSIGN alt-ped.data       = TODAY
               alt-ped.hora       = STRING(TIME,"HH:MM:SS":U)
               alt-ped.usuario    = {cdp/cd7777.i}
               alt-ped.num-pedido = pedido-compr.num-pedido
               alt-ped.nome-abrev = emitente.nome-abrev
               alt-ped.cod-cond-pag = ?
               alt-ped.observacao = "# ":U + c-literal-obs.

        FIND FIRST pedido-compr 
                 WHERE pedido-compr.num-pedido = ordem-compra.num-pedido EXCLUSIVE-LOCK NO-ERROR.

        IF ("{&mgadm_dbtype}" <> "PROGRESS") THEN DO:

            ASSIGN c-elimina = pedido-compr.mot-elimina + CHR(10) + CHR(10) 
                             + "== ":U + "Usu†rio":U            + ": ":U + c-seg-usuario
                             + " = ":U + "Pedido Eliminado":U 
                             + " = ":U + "Data":U               + ": ":U + STRING(TODAY,"99/99/9999":U)
                             + " ==":U + CHR(10)                + c-motivo.

            ASSIGN pedido-compr.mot-elimina  = SUBSTRING(c-elimina,1,2000).

        END.
        ELSE DO:
            ASSIGN pedido-compr.mot-elimina  = pedido-compr.mot-elimina + CHR(10) + CHR(10)
                                             + "== ":U + "Usu†rio":U          + ": ":U + c-seg-usuario
                                             + " = ":U + "Pedido Eliminado":U
                                             + " = ":U + "Data":U             + ": ":U + STRING(TODAY,"99/99/9999":U)
                                             + " ==":U + CHR(10) + c-motivo.
        END.
    END.

    IF NOT AVAIL pedido-compr THEN
        FIND FIRST pedido-compr
             WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.
    
    /** Aprovaá∆o Eletrìnica - elimina pendàncias **/
    IF  param-compra.log-1
    AND (NOT gl-prog-cc9019 OR SUBSTRING(param-compra.char-2, 7, 3) = "nao":U)
    AND AVAIL ordem-compra THEN DO:
        
        IF pedido-compr.emergencial THEN
            RUN cdp/cdapi171.p (6,3,ROWID(ordem-compra)).
        ELSE
            RUN cdp/cdapi171.p (4,3,ROWID(ordem-compra)).
    END.

    /* Para aprovaá∆o total gera novamente pendencia com o restante das ordens. */
    IF NOT gl-prog-cc9019 OR SUBSTRING(param-compra.char-2, 7, 3) = "nao":U THEN DO:

        IF NOT AVAIL param-aprov THEN FIND FIRST param-aprov  NO-LOCK NO-ERROR.

        IF AVAIL param-aprov AND param-aprov.aprov-total-pedido THEN DO:

            FIND FIRST bf-ordem
                 WHERE bf-ordem.num-pedido   =  pedido-compr.num-pedido
                   AND bf-ordem.numero-ordem <> ordem-compra.numero-ordem
                   AND bf-ordem.situacao     <> 4 NO-LOCK NO-ERROR.  /* Eliminada */

            IF AVAIL bf-ordem THEN DO:

                IF pedido-compr.emergencial THEN DO:

                    RUN cdp/cdapi171.p (6,2,ROWID(bf-ordem)).
                    RUN mensagemAprEletrOrdemCompra (ROWID(bf-ordem), 6). /* retorna RowErrors */
                END.
                ELSE DO:

                    RUN cdp/cdapi171.p (4,2,ROWID(bf-ordem)).
                    RUN mensagemAprEletrOrdemCompra (ROWID(bf-ordem), 4). /* retorna RowErrors */
                END.
            END.
        END.
    END.

    /** Multiplanta **/
    IF AVAIL pedido-compr AND param-global.modulo-mp THEN DO:

        RUN ccp/ccapi200.p (INPUT "Pedido-compr":U, INPUT ROWID(pedido-compr), INPUT  2, INPUT-OUTPUT TABLE tt-erro-mp).

        FOR EACH tt-erro-mp EXCLUSIVE-LOCK:

            ASSIGN i-seq-erro = i-seq-erro + 10.
            CREATE RowErrors.
            ASSIGN RowErrors.ErrorSequence    = i-seq-erro
                   RowErrors.ErrorNumber      = tt-erro-mp.cd-erro
                   RowErrors.ErrorParameters  = "":U
                   RowErrors.ErrorType        = "":U
                   RowErrors.ErrorSubType     = "ERROR":U
                   RowErrors.ErrorDescription = tt-erro-mp.mensagem
                   RowErrors.ErrorHelp        = tt-erro-mp.mensagem.
            DELETE tt-erro-mp.
        END.
    END.

    IF NOT l-elimina THEN /* Desvinculaá∆o */
        ASSIGN ordem-compra.num-pedido   = 0.
    

    /* ---------- Modulo Investimento -----------*/
    IF param-global.modulo-in AND ordem-compra.num-ord-inv <> 0 THEN DO:

        RUN ivbo/boiv037.p PERSISTENT SET h-boiv037.

        FOR EACH prazo-compra FIELDS(numero-ordem)
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:

            RUN DeleteProgEntr IN h-boiv037 (INPUT ROWID(prazo-compra), INPUT-OUTPUT TABLE RowErrors).
        END.
        DELETE PROCEDURE h-boiv037.
        ASSIGN h-boiv037 = ?.
        
        RUN ivbo/boiv011.p PERSISTENT SET h-boiv011.

        FOR EACH cotacao-item FIELDS(numero-ordem)
           WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
            
            RUN DeleteCotacaoInv IN h-boiv011 (INPUT ROWID(cotacao-item), INPUT-OUTPUT TABLE RowErrors).
        END.

        DELETE PROCEDURE h-boiv011.
        ASSIGN h-boiv011 = ?.
        
        RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.
        RUN DeleteOrdPed IN h-boiv028 (INPUT ROWID(ordem-compra), INPUT-OUTPUT TABLE RowErrors).

        DELETE PROCEDURE h-boiv028.
        ASSIGN h-boiv028 = ?.
    END.
    
    FIND FIRST emitente
         WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK NO-ERROR.

    IF param-global.modulo-07 AND (emitente.natureza = 3 OR emitente.natureza = 4) THEN DO:

        RUN cxbo/bocx341.p PERSISTENT SET h-bocx341.

        RUN atualizaDespesasPedido IN h-bocx341(INPUT 3, INPUT ROWID(ordem-compra), INPUT pedido-compr.num-pedido).
        RUN getRowErrors           IN h-bocx341(OUTPUT TABLE RowErrors).

        DELETE PROCEDURE h-bocx341.
    END.
    
    DELETE PROCEDURE apiHandler NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaPendAprov DBOProgram
PROCEDURE eliminaPendAprov :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-ordem-compra AS ROWID      NO-UNDO.
    DEFINE INPUT PARAMETER l-emergencial  AS LOGICAL    NO-UNDO.

    IF NOT AVAIL param-compra THEN
        FIND FIRST param-compra NO-LOCK NO-ERROR.

    IF  AVAIL param-compra
    AND SUBSTRING(param-compra.char-2, 7, 3) = "sim":U THEN DO:
        
        IF l-emergencial THEN
            RUN cdp/cdapi171.p (6,3,r-ordem-compra).
        ELSE
            RUN cdp/cdapi171.p (4,3,r-ordem-compra).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EnviaMultiplanta DBOProgram
PROCEDURE EnviaMultiplanta :
/*------------------------------------------------------------------------------
  Purpose:     Alteraá∆o de pedidos impressos.
  Parameters:  <none>
  Notes:       Procedure chamada no programa CC0300b - SaveAndOk
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prOrdemCompra AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER p-tipo-movto  AS INTEGER    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors .
    
    RUN emptyRowErrors IN THIS-PROCEDURE.
    
    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.
    
    IF AVAIL param-global AND param-global.modulo-mp THEN DO:

        /* Envia log apenas com o pedido impresso */
        FOR FIRST ordem-compra FIELDS (num-pedido)
            WHERE ROWID(ordem-compra) = prOrdemCompra NO-LOCK: END.

        IF AVAIL ordem-compra AND
           CAN-FIND (FIRST pedido-compr
                     WHERE pedido-compr.num-pedido = ordem-compra.num-pedido AND pedido-compr.situacao = 1) /* Impresso */ THEN DO:

            RUn ccp/ccapi200.p(INPUT "Altera-ordem":U, INPUT prOrdemCompra,
                               INPUT  p-tipo-movto, INPUT-OUTPUT TABLE tt-erro-mp).
    
            FOR EACH tt-erro EXCLUSIVE-LOCK:

                ASSIGN i-seq-erro = i-seq-erro + 10.

                CREATE RowErrors.
                ASSIGN RowErrors.ErrorSequence    = i-seq-erro
                       RowErrors.ErrorNumber      = tt-erro-mp.cd-erro
                       RowErrors.ErrorParameters  = "":U
                       RowErrors.ErrorType        = "":U
                       RowErrors.ErrorSubType     = "ERROR":U
                       RowErrors.ErrorDescription = tt-erro-mp.mensagem
                       RowErrors.ErrorHelp        = tt-erro-mp.mensagem.
                DELETE tt-erro.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executeCreateManutOrdCompra DBOProgram
PROCEDURE executeCreateManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose: Executa a criaá∆o de registros para registros provenientes da manutená∆o de ordens de compra
  Parameters: ipar1 : plNormal  : Ordem normal ou m£ltipla?
              opar2 : rChave     : Rowid do registro criado
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER plNormal AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER rChave   AS ROWID   NO-UNDO.

    RUN inbo/boin274.p PERSISTENT SET h-boin274.

    RUN setConstraintNumPedido IN h-boin274 (INPUT rowObject.num-pedido).
    RUN openQueryStatic        IN h-boin274 ("ByPedido":U).
    RUN validateCreate         IN h-boin274 (INPUT TABLE rowObject, OUTPUT TABLE RowErrors, OUTPUT rChave).

    DELETE PROCEDURE h-boin274.
    ASSIGN h-boin274 = ?.

    IF rChave <> ? THEN
       FIND FIRST ordem-compra
            WHERE ROWID(ordem-compra) = rChave EXCLUSIVE-LOCK NO-ERROR.

    RUN AtualizaDadosOrdemCompraSemPedido(BUFFER ordem-compra).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executeCreatePedEmerg DBOProgram
PROCEDURE executeCreatePedEmerg :
/*------------------------------------------------------------------------------
  Purpose: Efetiva a criaá∆o do registro e executa procedure de atualizaá∆o
           para registros provenientes do programa de pedidos emergenciais
  Parameters:  opar1 : rChave : Rowid do registro criado
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER rChave AS ROWID NO-UNDO.

    ASSIGN rChave = ?.

    RUN inbo/boin274.p PERSISTENT SET h-boin274.

    RUN setConstraintNumPedido IN h-boin274 (INPUT rowObject.num-pedido).
    RUN openQueryStatic        IN h-boin274 ("ByPedido":U).
    RUN validateCreate         IN h-boin274 (INPUT TABLE rowObject, OUTPUT TABLE RowErrors, OUTPUT rChave).

    DELETE PROCEDURE h-boin274.
    ASSIGN h-boin274 = ?.
    
    FOR EACH tt-epc WHERE tt-epc.cod-event = "afterValidateCreate":
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"afterValidateCreate"'
                         &CodParameter='"OBJECT-HANDLE"'
                         &ValueParameter="string(this-procedure)"}
                         
    {include/i-epc200.i2 &CodEvent='"afterValidateCreate"'
                         &CodParameter='"rChave"'
                         &ValueParameter="string(rChave)"}
                         
    {include/i-epc201.i "afterValidateCreate"}

    IF RETURN-VALUE = "NOK":U THEN 
        RETURN "NOK":U.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.

    FIND FIRST {&TableName} WHERE ROWID({&TableName}) = rChave EXCLUSIVE-LOCK NO-ERROR.

    RUN atualizaDadosOrdemCompraPedEmerg.
    
    /* Somente valida integracao com investimentos, quando nao passar pelo botao despesas do cc0300 */
    IF  NOT gl-bt-despesas-cc0300 THEN DO:
        RUN piIntegraInvestimentos IN THIS-PROCEDURE(INPUT ROWID(ordem-compra)).
    END.

    FOR FIRST pedido-compr FIELDS(num-pedido situacao)
        WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.
    
    IF INT(pedido-compr.situacao) = 1 THEN /* Impresso */
        RUN geraAltPedIncluiOrdens.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executeUpdatePedEmerg DBOProgram
PROCEDURE executeUpdatePedEmerg :
/*------------------------------------------------------------------------------
  Purpose: Efetiva a atualizaá∆o do registro e executa procedure de atualizaá∆o
           para registros provenientes do programa de pedidos emergenciais
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    FIND FIRST rowObject EXCLUSIVE-LOCK NO-ERROR.

        IF rowObject.narrativa = ? THEN ASSIGN rowObject.narrativa = "".

    RUN inbo/boin274.p PERSISTENT SET h-boin274.

    RUN setConstraintNumPedido IN h-boin274 (INPUT rowObject.num-pedido).
    RUN openQueryStatic        IN h-boin274 ("ByPedido":U).
    RUN validateUpdate         IN h-boin274 (INPUT TABLE rowObject, INPUT rowObject.r-rowid, OUTPUT TABLE RowErrors).

    FOR EACH RowErrors WHERE RowErrors.ErrorType = "Internal":U:
                DELETE RowErrors.
    END.                                                                         
                                                                         
    DELETE PROCEDURE h-boin274.
    ASSIGN h-boin274 = ?.
    
    FIND FIRST {&TableName} WHERE ROWID({&TableName}) = rowObject.r-rowid EXCLUSIVE-LOCK NO-ERROR.
    RUN atualizaDadosOrdemCompraPedEmerg.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formaOrdensCompradorOrdemCompra DBOProgram 
PROCEDURE formaOrdensCompradorOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:    Faz Relacionamento das ordens do grupo de compra com as ordens do comprador.
  Parameters: ipar1 : rw-row-1         : rowid da tabela gr-cmp-comprad
              ipar2 : rw-row-2         : rowid da tabela ordem-compra
              ipar3 : c-usuario-corren : codigo do usuario corrente
              opar4 : rowrErrors       : tabela de erros
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER rw-row-1         AS ROWID       NO-UNDO.
    DEFINE INPUT  PARAMETER rw-row-2         AS ROWID       NO-UNDO.
    DEFINE INPUT  PARAMETER c-usuario-corren AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors.

    DEFINE VARIABLE h-boin082vl    AS HANDLE    NO-UNDO.
    DEFINE VARIABLE l-retorno      AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE r-cotacao-item AS ROWID     NO-UNDO.

    ASSIGN c-seg-usuario = c-usuario-corren.

    FOR FIRST gr-cmp-comprad FIELDS(cod-comprado)
        WHERE ROWID(gr-cmp-comprad) = rw-row-1 NO-LOCK:
        
        FIND FIRST ordem-compra
             WHERE ROWID(ordem-compra) = rw-row-2 EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL ordem-compra THEN DO:

            ASSIGN ordem-compra.cod-comprado = gr-cmp-comprad.cod-comprado.

            &IF "{&DBtype}" <> "oracle" &THEN
            ASSIGN OVERLAY(ordem-compra.char-2,188,12) = "".
            &ELSE
            ASSIGN OVERLAY(ordem-compra.char-2,88,12)  = "".
            &ENDIF

            IF ordem-compra.situacao = 5 THEN DO: /* Em CotaÁ„o */

                FIND FIRST cotacao-item
                     WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                       AND cotacao-item.log-1 EXCLUSIVE-LOCK NO-ERROR.
                
                IF AVAIL cotacao-item THEN DO:
    
                    ASSIGN cotacao-item.cod-comprado = gr-cmp-comprad.cod-comprado
                           l-retorno = NO
                           gr-ordem-compra = ROWID(ordem-compra).
                    
                    IF param-compra.log-1 THEN 
                        RUN cdp/cdapi173.p (INPUT 3, cotacao-item.it-codigo, INPUT cotacao-item.cod-comprado, OUTPUT l-retorno).
                    ELSE
                        ASSIGN l-retorno = YES.
    
                    IF l-retorno THEN DO:
    
                        ASSIGN r-cotacao-item = ROWID(cotacao-item).
    
                        RUN inbo/boin082vl.p PERSISTENT SET h-boin082vl.
    
                        RUN setConstraintNumOrdem  IN h-boin082vl (INPUT cotacao-item.numero-ordem).
                        RUN openQueryStatic        IN h-boin082vl (INPUT "Byordem":U).
                        RUN aprovaEletrCotacaoItem IN h-boin082vl (INPUT rw-row-2,
                                                                   INPUT r-cotacao-item,
                                                                   INPUT c-seg-usuario,
                                                                   INPUT cotacao-item.narrativa,
                                                                   INPUT cotacao-item.cod-emitente).
                        RUN getRowErrors IN h-boin082vl (OUTPUT TABLE RowErrors).
    
                        DELETE PROCEDURE h-boin082vl.
                        ASSIGN h-boin082vl = ?.
    
                        IF NOT AVAIL cotacao-item THEN
                            FIND FIRST cotacao-item
                                 WHERE ROWID(cotacao-item) = r-cotacao-item NO-LOCK NO-ERROR.
    
                        IF param-compra.log-1 AND AVAIL cotacao-item THEN DO:
                            
                            RUN setConstraintNumOrdem IN h-boin082vl (INPUT cotacao-item.numero-ordem).
    
                            RUN inbo/boin082vl.p PERSISTENT SET h-boin082vl.
    
                            RUN openQueryStatic              IN h-boin082vl (INPUT "Byordem":U).
                            RUN retornaMensaAprovCotacaoItem IN h-boin082vl (r-cotacao-item, OUTPUT TABLE RowErrors).
                            
                            DELETE PROCEDURE h-boin082vl.
                            ASSIGN h-boin082vl = ?.
                        END.
                    END.
                    ELSE DO:
                        {method/svc/errors/inserr.i &ErrorNumber="15661" &ErrorType="EMS" &ErrorSubType="ERROR"}
                    END.
                END.
            END. /* ordem-compra.situacao = 5 */

            /*---------------------- Multi-Planta ----------------------*/
            ASSIGN c-transacao = "MAT002":U.
            {cdp/cd7300.i5 "001" c-transacao}

            IF param-global.modulo-mp AND tt-replica-msg.log-replica-msg THEN DO:

                FOR FIRST comprador FIELDS (cod-comprado corporativo)
                    WHERE comprador.cod-comprado = ordem-compra.cod-comprado NO-LOCK: END.

                IF AVAIL comprador AND comprador.corporativo THEN DO:

                    CREATE tt-dados-env.
                    ASSIGN tt-dados-env.num-sequencia  = i-seq
                           tt-dados-env.cod-tipo-reg   = 64
                           tt-dados-env.ind-tipo-movto = 1
                           tt-dados-env.identif-msg    = STRING(ordem-compra.numero-ordem).

                    RAW-TRANSFER ordem-compra TO tt-dados-env.conteudo-msg.
                    ASSIGN i-seq = i-seq + 1.
                    
                    /** Envio das Parcelas **/
                    FOR EACH prazo-compra
                       WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:

                        IF param-global.modulo-mp AND tt-replica-msg.log-replica-msg THEN DO:

                            CREATE tt-dados-env.
                            ASSIGN tt-dados-env.num-sequencia  = i-seq
                                   tt-dados-env.cod-tipo-reg   = 65
                                   tt-dados-env.ind-tipo-movto = 1
                                   tt-dados-env.identif-msg    = STRING(prazo-compra.numero-ordem) + " , ":U + STRING(prazo-compra.parcela).
                            
                            RAW-TRANSFER prazo-compra TO tt-dados-env.conteudo-msg.
                            ASSIGN i-seq = i-seq + 1.
                        END.
                    END.
                END.
            END.
        END. /* Avail ordem-compra */
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraAltPedIncluiOrdens DBOProgram
PROCEDURE geraAltPedIncluiOrdens :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       tem que estar posicionada a ordem, o pedido e informado o usu†rio.
------------------------------------------------------------------------------*/

      {utp/ut-liter.i Inclus∆o_de_Ordens mcc R}
      ASSIGN c-literal-obs = TRIM(RETURN-VALUE).

      CREATE alt-ped.
      ASSIGN alt-ped.data         = TODAY
             alt-ped.hora         = STRING(TIME,"HH:MM:SS":U)
             alt-ped.usuario      = {cdp/cd7777.i}
             alt-ped.num-pedido   = pedido-compr.num-pedido
             alt-ped.numero-ordem = ordem-compra.numero-ordem
             alt-ped.cod-cond-pag = ?
             alt-ped.observacao   = "# ":U + c-literal-obs.

      RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraAltPedModParcelaCotacao DBOProgram
PROCEDURE geraAltPedModParcelaCotacao :
/*------------------------------------------------------------------------------
  Purpose:    Geraá∆o alt-ped
  Parameters: 
  Notes:     Tem que estar posicionadas ordem-compra e prazo-compra, e as vari†veis
             c-seg-usuario, de-preco-unit, de-qtd-ant e da-entrega-ant precisam estar informadas
------------------------------------------------------------------------------*/

    IF c-literal-obs = "":U THEN DO:
        
        IF de-preco-unit <> ? AND de-preco-unit <> cotacao-item.pre-unit-for /* ordem-compra.pre-unit-for */ THEN DO:
            {utp/ut-liter.i Alterado(s):_Preáo_Unit†rio}
            ASSIGN c-literal-obs = TRIM(RETURN-VALUE).
        END.

        IF de-qtd-ant <> ? AND de-qtd-ant <> prazo-compra.qtd-sal-forn THEN DO:
            IF c-literal-obs = "" THEN DO:
                {utp/ut-liter.i Alterado(s):_Quantidade_Saldo}
                ASSIGN c-literal-obs = TRIM(RETURN-VALUE).
            END.
            ELSE DO:
                {utp/ut-liter.i Quantidade_Saldo}
                ASSIGN c-literal-obs = c-literal-obs + ", ":U + TRIM(RETURN-VALUE).
            END.
        END.

        IF da-entrega-ant <> ? AND da-entrega-ant <> prazo-compra.data-entrega THEN DO:

            IF c-literal-obs = "":U THEN DO:
                {utp/ut-liter.i Alterado(s):_Data_Entrega}
                ASSIGN c-literal-obs = TRIM(RETURN-VALUE).
            END.
            ELSE DO:
                {utp/ut-liter.i Data_Entrega}
                ASSIGN c-literal-obs = c-literal-obs + ", ":U + TRIM(RETURN-VALUE).
            END.
        END.
    END.

    CREATE alt-ped.
    ASSIGN alt-ped.data           = TODAY
           alt-ped.hora           = STRING(TIME,"HH:MM:SS":U)
           alt-ped.usuario        = {cdp/cd7777.i}
           alt-ped.num-pedido     = ordem-compra.num-pedido
           alt-ped.numero-ordem   = ordem-compra.numero-ordem
           alt-ped.parcela        = prazo-compra.parcela
           alt-ped.cod-cond-pag   = ?
           alt-ped.observacao     = c-literal-obs.

    /* Utiliza na WEB para gravaá∆o da motivo da alteraá∆o */
    IF c-lista-alt-ped <> "":U THEN ASSIGN c-lista-alt-ped = c-lista-alt-ped + ",":U.
    
    ASSIGN c-lista-alt-ped = c-lista-alt-ped + STRING(ROWID(alt-ped)).

    IF AVAIL emitente THEN
        ASSIGN alt-ped.nome-abrev = emitente.nome-abrev.

    IF de-preco-unit <> cotacao-item.pre-unit-for THEN
        ASSIGN alt-ped.preco = de-preco-unit.

    IF de-qtd-ant <> prazo-compra.qtd-sal-forn THEN
        ASSIGN alt-ped.quantidade = de-qtd-ant.

    IF da-entrega-ant <> prazo-compra.data-entrega THEN
        ASSIGN alt-ped.data-entrega = da-entrega-ant.

    /* Grava dados atuais */
    IF de-preco-unit <> cotacao-item.pre-unit-for THEN
        ASSIGN alt-ped.char-1 = STRING(cotacao-item.pre-unit-for).
    ELSE
        ASSIGN alt-ped.char-1 = "0":U.

    IF de-qtd-ant <> prazo-compra.qtd-sal-forn THEN
        ASSIGN alt-ped.char-1 = alt-ped.char-1 + "|":U + STRING(prazo-compra.qtd-sal-forn).
    ELSE
        ASSIGN alt-ped.char-1 = alt-ped.char-1 + "|":U + "0":U.

    IF da-entrega-ant <> prazo-compra.data-entrega THEN
        ASSIGN alt-ped.char-1 = alt-ped.char-1 + "|":U + STRING(prazo-compra.data-entrega,"99/99/9999":U).
    ELSE
        ASSIGN alt-ped.char-1 = alt-ped.char-1 + "|":U + "?":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraAltPedPedidoImpresso DBOProgram
PROCEDURE geraAltPedPedidoImpresso :
/*------------------------------------------------------------------------------
  Purpose:     executado no wcc0310b
               Os valores abaixo s∆o da situaá∆o inicial (da parcela e cotaá∆o)
               e ser∆o comparados com a situaá∆o final para gerar alt-ped.

  Parameters:  r-parcela           : rowid da parcela
               c-usuario-corren    : usu†rio corrente
               p-de-preco-unit-ant : da cotaá∆o ou ordem antes da alteraá∆o
               p-de-qtd-ant        : da parcela antes da alteraá∆o
               p-da-entrega-ant    : da parcela antes da alteraá∆o
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-parcela           AS ROWID         NO-UNDO.
    DEFINE INPUT PARAMETER c-usuario-corren    AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER p-de-preco-unit-ant AS DECIMAL       NO-UNDO.
    DEFINE INPUT PARAMETER p-de-qtd-ant        AS DECIMAL       NO-UNDO.
    DEFINE INPUT PARAMETER p-da-entrega-ant    AS DATE          NO-UNDO.
    DEFINE INPUT PARAMETER p-c-literal-obs     AS CHARACTER     NO-UNDO.

    ASSIGN c-literal-obs = p-c-literal-obs
           c-seg-usuario = IF c-usuario-corren <> "":U THEN c-usuario-corren ELSE c-seg-usuario.

    FOR FIRST prazo-compra FIELDS(parcela numero-ordem)
        WHERE ROWID(prazo-compra) = r-parcela NO-LOCK: END.

    IF NOT AVAIL prazo-compra THEN
        RETURN "NOK":U.

    FOR FIRST ordem-compra FIELDS(numero-ordem cod-emitente it-codigo num-pedido pre-unit-for)
        WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK: END.

    IF NOT AVAIL ordem-compra THEN
        RETURN "NOK":U.

    FOR FIRST cotacao-item
        WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
          AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
          AND cotacao-item.it-codigo    = ordem-compra.it-codigo
          AND cotacao-item.cot-aprovada NO-LOCK: END.

    IF NOT AVAIL cotacao-item THEN
        RETURN "NOK":U.

    FOR FIRST pedido-compr FIELDS(num-pedido situacao)
        WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.

    IF NOT AVAIL pedido-compr THEN
        RETURN "OK":U.

    IF INT(pedido-compr.situacao) = 1 THEN /* Impresso */
        ASSIGN l-cc0308 = YES.
    ELSE
        ASSIGN l-cc0308 = NO.

    /* Modificaá∆o de Parcelas - cc0308c */
    IF l-cc0308 THEN DO:

        /* RECEBE O VALOR ANTERIOR */
        ASSIGN da-entrega-ant = p-da-entrega-ant
               de-preco-unit  = p-de-preco-unit-ant
               de-qtd-ant     = p-de-qtd-ant.

        IF de-preco-unit  <> cotacao-item.pre-unit-for 
        OR de-qtd-ant     <> prazo-compra.qtd-sal-forn
        OR da-entrega-ant <> prazo-compra.data-entrega THEN
            RUN geraAltPedModParcelaCotacao.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraAprovEletronica DBOProgram
PROCEDURE geraAprovEletronica :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-rowid-pedido AS ROWID  NO-UNDO.
    DEFINE INPUT PARAMETER ph-boin295     AS HANDLE NO-UNDO.

    /* Vari·vel para capturar o retorno do boin295 */
    DEFINE VARIABLE c-retorno-aux AS CHARACTER NO-UNDO.

    IF NOT AVAIL param-compra THEN FIND FIRST param-compra NO-LOCK NO-ERROR.
    IF NOT AVAIL param-aprov  THEN FIND FIRST param-aprov  NO-LOCK NO-ERROR.

    FIND FIRST pedido-compr WHERE ROWID(pedido-compr) = r-rowid-pedido NO-LOCK NO-ERROR.

    RUN emptyRowErrors IN THIS-PROCEDURE.
    RUN emptyRowErrors IN ph-boin295.

    IF AVAIL pedido-compr AND AVAIL param-compra AND AVAIL param-aprov THEN DO:
        
        /*--- Gera novas pendÍncias para aprovaÁ„o total ---*/
        FOR EACH ordem-compra
           WHERE ordem-compra.num-pedido = pedido-compr.num-pedido
             AND ordem-compra.situacao  <> 4 NO-LOCK  /* Eliminada */
           BREAK BY ordem-compra.num-pedido
                 BY ordem-compra.numero-ordem:

            IF SUBSTRING(param-compra.char-2, 7, 3) = "sim":U THEN DO:
                
                IF LAST(ordem-compra.numero-ordem) THEN DO:

                    IF pedido-compr.situacao = 2 THEN DO:
                        RUN aprovacaoEletronica IN ph-boin295 (ROWID(Ordem-compra)).
                        ASSIGN c-retorno-aux = RETURN-VALUE. 
                    END.
                    ELSE DO:
                        IF pedido-compr.situacao = 1 THEN DO:
                            RUN geraMsgPendAprovEletronica IN THIS-PROCEDURE (ROWID(ordem-compra),4).
                            ASSIGN c-retorno-aux = RETURN-VALUE.
                        END.
                    END.
                                                        
                    RUN getRowErrors IN ph-boin295(OUTPUT TABLE RowErrors APPEND).

                    IF c-retorno-aux = "NOK":U OR CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                        RETURN "NOK":U.
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraMsgPendAprovEletronica DBOProgram
PROCEDURE geraMsgPendAprovEletronica :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-ordem-compra   AS ROWID    NO-UNDO.
    DEFINE INPUT PARAMETER i-tipo-docto     AS INTEGER  NO-UNDO.

    IF NOT AVAIL param-compra THEN FIND FIRST param-compra NO-LOCK NO-ERROR.

    FIND FIRST ordem-compra
         WHERE ROWID(ordem-compra) = r-ordem-compra NO-LOCK NO-ERROR.

    IF AVAIL ordem-compra AND ordem-compra.num-pedido > 0 THEN
        FIND FIRST pedido-compr WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.

    IF AVAIL pedido-compr THEN DO:

        IF pedido-compr.emergencial THEN
            RUN cdp/cdapi171.p (6,2,ROWID(ordem-compra)). /* Emergencial */
        ELSE
            RUN cdp/cdapi171.p (4,2,ROWID(ordem-compra)).

        IF SUBSTR(param-compra.char-2,7,3) = "sim":U AND gl-prog-cc9019 THEN
            RUN mensagemAprEletrOrdemCompra (ROWID(ordem-compra),4).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitaBotaoBrowserTTOrdemCompra DBOProgram
PROCEDURE habilitaBotaoBrowserTTOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: Verifica se o bot∆o clicado est† dispon¢vel para o registro
           selecionado. E encontra o rowid de tabelas relacionadas a ordem-compra
           para abrir consultas relacionadas.
  Parameters: ipar1 : rOrdemCompra : Rowid da tabela ordem-compra
              opar2 : cPedido      : Habilita bot∆o de Pedidos?
              opar3 : cCotacao     : Habilita bot∆o de CotaÖ‰es?
              opar4 : rItem        : Rowid da tabela item
              opar5 : rPedidoCompr : Rowid da tabela pedido-compr
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER rOrdemCompra AS ROWID       NO-UNDO.
    DEFINE OUTPUT PARAMETER cPedido      AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER cCotacao     AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER rItem        AS ROWID       NO-UNDO.
    DEFINE OUTPUT PARAMETER rPedidoCompr AS ROWID       NO-UNDO.

    FOR FIRST ordem-compra FIELDS(cod-emitente num-pedido it-codigo)
        WHERE ROWID(ordem-compra) = rOrdemCompra NO-LOCK: END.

    FOR FIRST item FIELDS(it-codigo)
        WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK: END.

    IF AVAILABLE item THEN
        ASSIGN rItem = ROWID(item).

    FOR FIRST pedido-compr FIELDS(num-pedido)
        WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK:
        
        IF pedido-compr.num-pedido > 0 THEN
           ASSIGN cPedido = "yes":U.
        ELSE
           ASSIGN cPedido = "no":U.

        ASSIGN rPedidoCompr = ROWID(pedido-compr).
    END.

    IF AVAILABLE ordem-compra THEN DO:

        IF ordem-compra.cod-emitente > 0 THEN
            ASSIGN cCotacao = "yes":U.
        ELSE
            ASSIGN cCotacao = "no":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE incluiOrdensPedidoOrdemCompra DBOProgram
PROCEDURE incluiOrdensPedidoOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:
    Inclui ordens de compra para o pedido de compra quando existem aprovadores
    relacionados a "este" item ou fam°lia que possam aprovar "este" documento.
  Parameters:  <none>
    ipar1 : r-rowid-ordem   : rowid da tabela ordem-compra
    ipar2 : i-pedido        : numero do pedido corrente
    ipar3 : c-seg-usuario   : usuario corrente
    ipar4 : l-retorno-aprov : opá∆o de aprovaá∆o
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER r-rowid-ordem   AS ROWID        NO-UNDO.
    DEFINE INPUT  PARAMETER i-pedido        AS INTEGER      NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-seg-usuario AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER l-retorno-aprov AS LOGICAL      NO-UNDO.

    DEFINE VARIABLE h-bocx150        AS HANDLE             NO-UNDO.
    DEFINE VARIABLE l-acesso-bocx150 AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE l-acompanhamento AS LOGICAL INITIAL NO NO-UNDO.

    /* cria rowErrors para ser retornado pela procedure getErrors */
    ASSIGN c-seg-usuario = IF p-c-seg-usuario <> "":U THEN p-c-seg-usuario ELSE c-seg-usuario.

    FIND FIRST ordem-compra
         WHERE ROWID(ordem-compra) = r-rowid-ordem EXCLUSIVE-LOCK NO-ERROR.

    IF l-retorno-aprov THEN DO:

        IF CAN-FIND(FIRST cotacao-item
                    WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                      AND cotacao-item.data-cotacao = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF) THEN DO:

            RUN inbo/boin082.p PERSISTENT SET h-boin082.

            FOR EACH cotacao-item FIELDS(numero-ordem data-cotacao)
               WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                 AND cotacao-item.data-cotacao = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF NO-LOCK:
                
                /** delete cotacao-item. **/
                ASSIGN rChave-aux = ROWID(cotacao-item).

                RUN setConstraintNumOrdem IN h-boin082 (INPUT cotacao-item.numero-ordem).
                RUN openQueryStatic       IN h-boin082 (INPUT "ByCotacao":U).
                RUN validateDelete        IN h-boin082 (INPUT-OUTPUT rChave-aux, OUTPUT TABLE RowErrors).
            END.

            FOR EACH RowErrors WHERE RowErrors.ErrorType = "Internal":U:
                DELETE RowErrors.
            END.

            DELETE PROCEDURE h-boin082.
            ASSIGN h-boin082 = ?.
        END.

        IF NOT AVAIL pedido-compr THEN
            FIND FIRST pedido-compr
                 WHERE pedido-compr.num-pedido = i-pedido NO-LOCK NO-ERROR.

        ASSIGN ordem-compra.num-pedido       = pedido-compr.num-pedido
               ordem-compra.situacao         = 2
               ordem-compra.data-pedido      = pedido-compr.data-pedido
               ordem-compra.cod-estabel      = pedido-compr.end-entrega
               ordem-compra.cod-estab-gestor = pedido-compr.cod-estab-gestor.

        FOR EACH prazo-compra
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:
            
            ASSIGN prazo-compra.situacao = ordem-compra.situacao.

            /****************************************************************
            ** Integracao Compras - Importacao x MRP                       **
            ** Verifica se a ordem de compra esta vinculada a um processo  **
            ** de importacao com acompanhamento. Caso estiver, as parcelas **
            ** envolvidas serao setadas para nao serem reprogramadas MRP   **
            ****************************************************************/
            IF NOT AVAIL param-global THEN FIND FIRST param-global NO-LOCK NO-ERROR.

            IF  CONNECTED("mgcex":U) AND (AVAIL param-global AND param-global.modulo-07) THEN DO:
                {inbo/boin274vl.i01}
            END.
        END.

        RUN geraAltPedIncluiOrdens.

        RUN ccp/ccapi001.p (INPUT ROWID(ordem-compra)).

        FIND FIRST emitente
            WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK NO-ERROR.

        IF param-global.modulo-07 AND (emitente.natureza = 3 OR emitente.natureza = 4) THEN DO:

            RUN cxbo/bocx341.p PERSISTENT SET h-bocx341.

            RUN atualizaDespesasPedido IN h-bocx341 (INPUT 1,
                                                     INPUT ROWID(ordem-compra),
                                                     INPUT pedido-compr.num-pedido).
            RUN getRowErrors           IN h-bocx341(OUTPUT TABLE rowErrors).

            DELETE PROCEDURE h-bocx341.
        END.
        
        /*--- MIN X MMI - Preenche num-ord-inv a partir de uma ordem de manutená∆o */
        IF l-min-mmi AND param-global.modulo-in AND ordem-compra.ordem-servic <> 0 THEN DO:

            RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.
            RUN BuscaOrdemInvOrdProd IN h-boiv028 (INPUT ordem-compra.ordem-servic, INPUT-OUTPUT ordem-compra.num-ord-inv).
            DELETE PROCEDURE h-boiv028.
        END.

        /* ---------- Modulo Investimento -----------*/
        IF param-global.modulo-in AND ordem-compra.num-ord-inv <> 0 THEN DO:
            RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.

            RUN UpdateOrdPed IN h-boiv028 (INPUT ROWID(ordem-compra), INPUT-OUTPUT TABLE RowErrors).
            
            DELETE PROCEDURE h-boiv028.
            ASSIGN h-boiv028 = ?.
        END.

        /** Multiplanta **/
        IF AVAIL pedido-compr AND param-global.modulo-mp THEN DO:

            RUN ccp/ccapi200.p (INPUT "Pedido-compr":U, INPUT ROWID(pedido-compr),
                                INPUT  2, INPUT-OUTPUT TABLE tt-erro-mp).

            FOR EACH tt-erro EXCLUSIVE-LOCK:

                ASSIGN i-seq-erro = i-seq-erro + 10.

                CREATE RowErrors.
                ASSIGN RowErrors.ErrorSequence    = i-seq-erro
                       RowErrors.ErrorNumber      = tt-erro-mp.cd-erro
                       RowErrors.ErrorParameters  = "":U
                       RowErrors.ErrorType        = "":U
                       RowErrors.ErrorSubType     = "ERROR":U
                       RowErrors.ErrorDescription = tt-erro-mp.mensagem
                       RowErrors.ErrorHelp        = tt-erro-mp.mensagem.
                DELETE tt-erro.
            END.
        END.

        /** Aprovaá∆o Eletrìnica **/
        IF NOT AVAIL param-compra THEN FIND FIRST param-compra NO-LOCK NO-ERROR.

        IF  param-compra.log-1 
        AND AVAIL ordem-compra 
        AND AVAIL pedido-compr 
        AND (NOT gl-prog-cc9019 OR SUBSTRING(param-compra.char-2,7,3) = "nao":U) THEN DO:
            
            RUN geraMsgPendAprovEletronica (ROWID(ordem-compra),4).

            IF NOT gl-prog-cc9019 THEN
                RUN mensagemAprEletrOrdemCompra (ROWID(ordem-compra),4).
        END.
    END. /** if l-retorno-aprov then do: **/

    FOR EACH tt-epc WHERE tt-epc.cod-event = "relacionaOrdemCompraPedido":U:
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"relacionaOrdemCompraPedido"'
                         &CodParameter='"OBJECT-HANDLE"'
                         &ValueParameter="string(this-procedure)"}

    {include/i-epc200.i2 &CodEvent='"relacionaOrdemCompraPedido"'
                         &CodParameter='"rowid-ordem-compra"'
                         &ValueParameter="string(rowid(ordem-compra))"}

    /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i "relacionaOrdemCompraPedido"}

    IF RETURN-VALUE = "NOK":U THEN DO:
        UNDO, RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inputTable DBOProgram
PROCEDURE inputTable :
/*------------------------------------------------------------------------------
  Purpose: MÇtodo de proxy que permite a entrada da tabela de dados no DBO
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR rowObject.

    RUN setRecord IN THIS-PROCEDURE (INPUT TABLE rowObject).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IntegraElimParcelasMP DBOProgram
PROCEDURE IntegraElimParcelasMP :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes: Procedure desenvolvida para ser utilizada inicialmente pelo programa
         CC0301, na eliminaá∆o de parcelas.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-ordem      AS ROWID    NO-UNDO.
    DEFINE INPUT PARAMETER p-tipo-movto AS INTEGER  NO-UNDO.
    
    RUN ccp/ccapi200.p(INPUT "Prazo-compra":U,
                       INPUT p-ordem,
                       INPUT p-tipo-movto,
                       INPUT-OUTPUT TABLE tt-erro-mp).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IntegraManutOrdensMultiplanta DBOProgram
PROCEDURE IntegraManutOrdensMultiplanta :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes: Procedure desenvolvida para ser utilizada inicialmente pelo programa
         CC0301, na criaá∆o/modificaá∆o/eliminaá∆o de ordens.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-ordem      AS ROWID    NO-UNDO.
    DEFINE INPUT PARAMETER p-tipo-movto AS INTEGER  NO-UNDO.

    RUN ccp/ccapi200.p(INPUT "Ordem-compra":U,
                       INPUT p-ordem,
                       INPUT p-tipo-movto,
                       INPUT-OUTPUT TABLE tt-erro-mp).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mensagemAprEletrOrdemCompra DBOProgram
PROCEDURE mensagemAprEletrOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: Retorna informaá∆o se o Documento esta pendente de aprovaá∆o.
           Com as informaá‰es: Moeda Convers∆o  : *****
                               Limite Aprovaá∆o : *****
                               Valor Documento  : *****
  Parameters:  ipar1 : r-ordem-compra : rowid registro ordem-compra
               ipar2 : i-tipo-docto   : tipo do documento
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-ordem-compra AS ROWID      NO-UNDO.
    DEFINE INPUT PARAMETER i-tipo-docto   AS INTEGER    NO-UNDO.

    DEFINE VARIABLE c-tipo-moeda   AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE c-moeda-lim    AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE c-numero-ordem AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE de-valor-doc   AS DECIMAL       NO-UNDO.
    DEFINE VARIABLE de-valor-lim   AS DECIMAL       NO-UNDO.
    DEFINE VARIABLE i-moeda-lim    AS INTEGER       NO-UNDO.
    DEFINE VARIABLE i-tipo-moeda   AS INTEGER       NO-UNDO.
    DEFINE VARIABLE l-pendente     AS LOGICAL       NO-UNDO.

    FOR EACH tt-epc WHERE tt-epc.cod-event = "mensagemAprEletrOrdemCompra":U:
      DELETE tt-epc.
    END.
    
    {include/i-epc200.i2 &CodEvent='"mensagemAprEletrOrdemCompra"'
                       &CodParameter='"r-ordem-compra"'
                       &ValueParameter="string(r-ordem-compra)"}
                       
    {include/i-epc200.i2 &CodEvent='"mensagemAprEletrOrdemCompra"'
                       &CodParameter='"i-tipo-docto"'
                       &ValueParameter="string(i-tipo-docto)"}
                       
    
    {include/i-epc201.i "mensagemAprEletrOrdemCompra"}
    IF  RETURN-VALUE = "NOK":U THEN DO:
      RETURN "NOK":U.
    END.

    IF NOT AVAIL param-aprov THEN FIND FIRST param-aprov NO-LOCK NO-ERROR.

    /** Mensagem de Aprovaá∆o  **/
    IF  param-compra.log-1 AND (param-compra.int-1 = 2 or param-compra.int-1 = 3) THEN DO:

        RUN cdp/cdapi174.p (INPUT  i-tipo-docto,
                            INPUT  r-ordem-compra,
                            OUTPUT i-moeda-lim,
                            OUTPUT i-tipo-moeda,
                            OUTPUT de-valor-doc,
                            OUTPUT de-valor-lim) NO-ERROR.

        FOR FIRST moeda FIELDS(mo-codigo descricao)
            WHERE moeda.mo-codigo = i-moeda-lim NO-LOCK: END.

        ASSIGN c-moeda-lim  = STRING(i-moeda-lim,"99":U) + " - ":U + moeda.descricao.

        CASE i-tipo-moeda:
            WHEN 1 THEN DO:
                {utp/ut-liter.i (Usuˇrio) * r}
                ASSIGN c-tipo-moeda = RETURN-VALUE.
            END.
            WHEN 2 THEN DO:
                {utp/ut-liter.i (Aprovador) * r}
                ASSIGN c-tipo-moeda = RETURN-VALUE.
            END.
            WHEN 3 THEN DO:
                {utp/ut-liter.i (Fam°lia) * r}
                ASSIGN c-tipo-moeda = RETURN-VALUE.
            END.
            WHEN 4 THEN DO:
                {utp/ut-liter.i (Mestre) * r}
                ASSIGN c-tipo-moeda = RETURN-VALUE.
            END.
        END CASE.
        
        IF pedido-compr.emergencial THEN
            RUN cdp/cdapi172.p (INPUT 6, INPUT r-ordem-compra, OUTPUT l-pendente).
        ELSE
            RUN cdp/cdapi172.p (INPUT 4, INPUT r-ordem-compra, OUTPUT l-pendente).

        IF AVAIL param-aprov AND NOT param-aprov.aprov-total-pedido THEN DO:

            FIND FIRST ordem-compra
                 WHERE ROWID(ordem-compra) = r-ordem-compra NO-LOCK NO-ERROR.
            
            IF AVAIL ordem-compra THEN
                ASSIGN c-numero-ordem = STRING(ordem-compra.numero-ordem,"zzzzz9,99":U).
        END.
        ELSE
            ASSIGN c-numero-ordem = "":U.

        IF l-pendente = NO THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="16725"
                                        &ErrorType="EMS"
                                        &ErrorSubType="INFORMATION"
                                        &ErrorParameters="c-moeda-lim + '  --  ' + '~~~~' +
                                                          TRIM(STRING(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99')) +
                                                          c-tipo-moeda + '  --  ' + '~~~~' +
                                                          TRIM(STRING(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')) +
                                                          '~~~~' + c-numero-ordem"}
        END.
        ELSE DO:

            {method/svc/errors/inserr.i &ErrorNumber="16724"
                                        &ErrorType="INFORMATION"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-moeda-lim + '  --  ' + '~~~~' +
                                                          TRIM(STRING(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99')) +
                                                          c-tipo-moeda + '  --  ' + '~~~~' +
                                                          TRIM(STRING(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')) +
                                                          '~~~~' + c-numero-ordem"}
        END.
    END.
    ELSE DO:
            {method/svc/errors/inserr.i &ErrorNumber="16760" &ErrorType="EMS" &ErrorSubType="ERROR"}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH ordem-compra NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-estado DBOProgram 
PROCEDURE pi-seta-estado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-estado AS CHARACTER NO-UNDO.

    ASSIGN c-estado = p-estado.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEfetivaPedidoDrbItem DBOProgram 
PROCEDURE piEfetivaPedidoDrbItem :
/*------------------------------------------------------------------------------
  Purpose:     Realizar a efetivaá∆o da tabela pedido-drb-item
  Parameters:  Entrada: handle j† instanciado da bocx315.p atravÇs da procedure
               ValidateAtoConcessorio
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER ph-bocx315 AS HANDLE NO-UNDO.

    IF  CAN-FIND(FIRST tt-pedido-drb-item) THEN DO:

        RUN openQueryStatic IN ph-bocx315 (INPUT "Main":U).
        RUN goToKey         IN ph-bocx315 (INPUT tt-pedido-drb-item.cod-estabel,
                                           INPUT tt-pedido-drb-item.nr-pedido-drb,
                                           INPUT tt-pedido-drb-item.it-codigo).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN emptyRowErrors  IN ph-bocx315.
            RUN emptyRowObject  IN ph-bocx315.
            RUN setRecord       IN ph-bocx315 (INPUT TABLE tt-pedido-drb-item).
            RUN updateRecord    IN ph-bocx315.
        END.
        DELETE tt-pedido-drb-item.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaPortalCompras DBOProgram 
PROCEDURE piEnviaPortalCompras :
/*------------------------------------------------------------------------------
  Purpose: Envia mensagem de aprovaá∆o para o portal de compras
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dt-delivery-date AS DATE INIT 01/01/1900 NO-UNDO.
    DEFINE VARIABLE l-pendente       AS LOGICAL              NO-UNDO.

    DEFINE BUFFER bf-integracao-ordem-compra FOR ordem-compra.
    DEFINE BUFFER bf-integracao-pedido       FOR pedido-compr.

    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "SPP-INTEGRA-PORTAL-COMPRA":U AND funcao.ativo) THEN DO:

        IF NOT AVAIL param-compra THEN
            FIND FIRST param-compra NO-LOCK NO-ERROR.

        IF AVAIL param-compra AND
        &IF '{&bf_mat_versao_ems}' < '2.09' &THEN
            SUBSTRING(param-compra.char-2,102,1) = "S":U
        &ELSE
            param-compra.log-integr-portal
        &ENDIF THEN DO:

            FIND FIRST bf-integracao-pedido WHERE bf-integracao-pedido.num-pedido = pedido-compr.num-pedido EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL bf-integracao-pedido AND
            &IF "{&bf_mat_versao_ems}"  <  "2.09" &THEN
                SUBSTRING(bf-integracao-pedido.char-1,2,1) = "s":U
            &ELSE
                bf-integracao-pedido.log-integr-portal &ENDIF THEN DO:

                EMPTY TEMP-TABLE ttPurchaseOrderLine012.

                FOR EACH bf-integracao-ordem-compra WHERE bf-integracao-ordem-compra.num-pedido = bf-integracao-pedido.num-pedido NO-LOCK:

                    IF bf-integracao-pedido.emergencial THEN
                        RUN cdp/cdapi172.p (6,ROWID(bf-integracao-ordem-compra),OUTPUT l-pendente).
                    ELSE
                        RUN cdp/cdapi172.p (4,ROWID(bf-integracao-ordem-compra),OUTPUT l-pendente).

                    IF l-pendente THEN RETURN.

                    FIND FIRST item WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

                    FOR EACH prazo-compra WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
                        
                        IF dt-delivery-date < prazo-compra.data-entrega THEN
                            ASSIGN dt-delivery-date = prazo-compra.data-entrega.
                    END.

                    FIND FIRST ttPurchaseOrderLine012 WHERE ttPurchaseOrderLine012.POLineNumber = bf-integracao-ordem-compra.numero-ordem NO-ERROR.

                    IF NOT AVAIL ttPurchaseOrderLine012 THEN DO:
                        
                        CREATE ttPurchaseOrderLine012.
                        ASSIGN ttPurchaseOrderLine012.DeliveryDate          = dt-delivery-date
                               ttPurchaseOrderLine012.ItemCode              = bf-integracao-ordem-compra.it-codigo
                               ttPurchaseOrderLine012.ItemDescription       = IF AVAIL item THEN item.desc-item ELSE ""
                               ttPurchaseOrderLine012.POLineNumber          = bf-integracao-ordem-compra.numero-ordem
                               ttPurchaseOrderLine012.PriceVendor           = bf-integracao-ordem-compra.preco-fornec
                               ttPurchaseOrderLine012.Quantity              = bf-integracao-ordem-compra.qt-solic
                               ttPurchaseOrderLine012.ttPurchaseOrderLineID = bf-integracao-ordem-compra.numero-ordem
                               ttPurchaseOrderLine012.UnitPrice             = bf-integracao-ordem-compra.preco-unit
                               ttPurchaseOrderLine012.UnitPriceVendor       = bf-integracao-ordem-compra.pre-unit-for
                               ttPurchaseOrderLine012.CurrencyID            = bf-integracao-ordem-compra.mo-codigo
                               ttPurchaseOrderLine012.POLineNumberWebb      = &IF '{&bf_mat_versao_ems}' < '2.09' &THEN
                                                                                SUBSTRING(bf-integracao-ordem-compra.char-1,92,50)
                                                                              &ELSE
                                                                                bf-integracao-ordem-compra.cod-ord-portal
                                                                              &ENDIF.

                        FIND FIRST cotacao-item WHERE cotacao-item.numero-ordem = bf-integracao-ordem-compra.numero-ordem AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.

                        IF AVAIL cotacao-item THEN DO:

                            &IF '{&bf_mat_versao_ems}' < '2.09' &THEN
                                ASSIGN ttPurchaseOrderLine012.UnitPrice = DECIMAL(SUBSTRING(cotacao-item.char-2, 157, 17)).
                            &else
                                ASSIGN ttPurchaseOrderLine012.UnitPrice = cotacao-item.val-preco-liq-item.
                            &ENDIF
                        END.
                    END.
                END.

                EMPTY TEMP-TABLE tt-pedido-compr.
                CREATE tt-pedido-compr.
                BUFFER-COPY bf-integracao-pedido TO tt-pedido-compr.

                IF CAN-FIND(FIRST ttPurchaseOrderLine012) THEN DO:
                    
                    IF &IF "{&bf_mat_versao_ems}"  <  "2.09" &THEN
                           SUBSTRING(bf-integracao-pedido.char-1, 53, 1) <> "s":U
                      &ELSE
                           bf-integracao-pedido.log-envda-aprovac-portal = NO
                      &ENDIF
                    THEN DO:
                        
                        RUN adapters/xml/su2/axssu012.p (INPUT  'add':U,
                                                         INPUT  'boin295.p':U,
                                                         INPUT  ('approve':U),
                                                         INPUT  "Aprovado automaticamente":U,
                                                         INPUT  TABLE tt-pedido-compr,
                                                         INPUT  TABLE ttPurchaseOrderLine012,
                                                         OUTPUT TABLE tt_log_erro).

                        &IF "{&bf_mat_versao_ems}"  <  "2.09" &THEN
                            ASSIGN OVERLAY(bf-integracao-pedido.char-1, 53, 1) = "s":U.
                        &ELSE
                            ASSIGN bf-integracao-pedido.log-envda-aprovac-portal = YES.
                        &ENDIF

                        RELEASE bf-integracao-pedido.
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIntegraInvestimentos DBOProgram
PROCEDURE piIntegraInvestimentos :
/*------------------------------------------------------------------------------
  Parameters: recebe o rowid da ordem de compra
  Notes: Esta procedure e executadada pela "executeCreatePedEmerg" desta BO e
         tambÇm pela procedure "piIntegraInvestimentos" do cc0300b.w.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-ordem-compra AS ROWID NO-UNDO.

    IF  NOT AVAIL ordem-compra
    OR  ROWID(ordem-compra) <> r-ordem-compra THEN
        FIND FIRST ordem-compra
             WHERE ROWID(ordem-compra) = r-ordem-compra NO-LOCK NO-ERROR.

    IF NOT AVAIL param-global THEN FIND FIRST param-global NO-LOCK NO-ERROR.

    IF param-global.modulo-in AND ordem-compra.num-ord-inv <> 0 THEN DO:
        
        RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.
        RUN CreateOrdPed IN h-boiv028 (INPUT r-ordem-compra, INPUT-OUTPUT TABLE RowErrors).
        
        DELETE PROCEDURE h-boiv028.
        ASSIGN h-boiv028 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repassaEstabGestorOC DBOProgram
PROCEDURE repassaEstabGestorOC :
/*------------------------------------------------------------------------------
  Notes: Repassa o estabelecimento gestor do pedido de compra para as ordens do
         pedido. Procedure executada quando altera pedido no cc0300a.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-pedido AS INTEGER NO-UNDO.

    FOR FIRST pedido-compr FIELDS(cod-estab-gestor)
        WHERE pedido-compr.num-pedido = p-num-pedido NO-LOCK,
         EACH bfordem-compra
        WHERE bfordem-compra.num-pedido = pedido-compr.num-pedido EXCLUSIVE-LOCK:

        ASSIGN bfordem-compra.cod-estab-gestor = pedido-compr.cod-estab-gestor.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaErroNaoAprov DBOProgram
PROCEDURE retornaErroNaoAprov :
/*------------------------------------------------------------------------------
  Purpose: Retorna erro quando n∆o existem aprovadores relacionados a
           ao item ou fam°lia que possam aprovar o documento.
  Parameters: ipar1 : rOrdem              : Rowid do registro de ordem-compra
              opar2 : lRetornoAprov       : Retorna se o docto pode ser aprovado
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER rOrdem        AS ROWID    NO-UNDO.
    DEFINE OUTPUT PARAMETER lRetornoAprov AS LOGICAL  NO-UNDO.
 

    FOR FIRST ordem-compra FIELDS(it-codigo cod-comprado ct-codigo sc-codigo cod-emitente cod-estabel)
        WHERE ROWID(ordem-compra) = rOrdem NO-LOCK: END.
    
    /** Aprovaá∆o Eletrìnica **/
    IF AVAILABLE ordem-compra AND AVAILABLE param-compra AND param-compra.log-1 THEN DO:
        
        ASSIGN gr-ordem-compra = ROWID(ordem-compra).

        RUN cdp/cdapi173.p (INPUT  4,
                            INPUT  ordem-compra.it-codigo,
                            INPUT  ordem-compra.cod-comprado,
                            OUTPUT lRetornoAprov).
        
        IF NOT lRetornoAprov THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="15661" &ErrorType="EMS" &ErrorSubType="ERROR"}
        END.
    END.
    ELSE
        ASSIGN lRetornoAprov = YES.
    

    RETURN (IF NOT (CAN-FIND (FIRST RowErrors)) THEN "OK" ELSE "NOK":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnAprovTotal DBOProgram
PROCEDURE returnAprovTotal :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER l-aprov-total AS LOGICAL NO-UNDO.

    IF NOT AVAIL param-compra THEN FIND FIRST param-compra NO-LOCK NO-ERROR.

    ASSIGN l-aprov-total = AVAIL param-compra AND SUBSTRING(param-compra.char-2, 7, 3) = "sim":U.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnRowidOrdem DBOProgram
PROCEDURE returnRowidOrdem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-num-ordem   LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pr-rowid-ordem AS ROWID                       NO-UNDO.

    FOR FIRST bfordem-compra FIELDS(numero-ordem)
        WHERE bfordem-compra.numero-ordem = pi-num-ordem NO-LOCK: END.

    ASSIGN pr-rowid-ordem = IF AVAIL bfordem-compra THEN ROWID(bfordem-compra) ELSE ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetaIntegracaoParadigma DBOProgram
PROCEDURE SetaIntegracaoParadigma :
/*------------------------------------------------------------------------------
  Purpose: Indica que o processo de compra foi criado na paradigma
  Parameters:  <none>
  Notes:       Alimentar variavel que define integraáao com o portal paradigma
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-processo-paradigma AS LOGICAL NO-UNDO.

    ASSIGN l-processo-paradigma = pl-processo-paradigma.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetaRowidAltPed DBOProgram
PROCEDURE SetaRowidAltPed :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-lista-alt-ped AS CHARACTER NO-UNDO.
    
    ASSIGN c-lista-alt-ped = p-lista-alt-ped.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsOrdemCompra DBOProgram
PROCEDURE setDefaultsOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: Setar os valores default para os campos: c¢digo do comprador, dep¢sito,
           conta cont†bil e tipo de despesa padr∆o do item.
  Parameters:
  Notes: Ser† executada a partir da include AXRSU002UPSERT.I, antes da execuá∆o
         das seguintes procedures:
         - validateCreatePedEmerg    e
         - validateCreateManutOrdCompra
------------------------------------------------------------------------------*/
    RUN inbo/boin274sd.p PERSISTENT SET h-boin274sd.

    RUN buscaInfOrdemLeaveItem IN h-boin274sd (INPUT  RowObject.it-codigo,
                                               INPUT  RowObject.cod-estabel,
                                               INPUT  RowObject.num-pedido,
                                               OUTPUT c-cod-comprador,
                                               OUTPUT c-ct-codigo,
                                               OUTPUT c-sc-codigo,
                                               OUTPUT c-deposito,
                                               OUTPUT i-tp-desp).
    DELETE PROCEDURE h-boin274sd.
    ASSIGN h-boin274sd = ?.

    IF RowObject.cod-refer = ? THEN
        ASSIGN RowObject.cod-refer = "".

    IF RowObject.data-atualiz = ? OR STRING(RowObject.data-atualiz) = "" THEN
        ASSIGN RowObject.data-atualiz = TODAY.

    IF RowObject.hora-atualiz = ? OR RowObject.hora-atualiz = "" THEN
        ASSIGN RowObject.hora-atualiz = STRING(TIME,"HH:MM:SS":U).

    IF RowObject.data-emissao = ? OR STRING(RowObject.data-emissao) = "" THEN
        ASSIGN RowObject.data-emissao = TODAY.

    IF RowObject.nr-ord-orig = ? THEN
        ASSIGN RowObject.nr-ord-orig = 0.

    IF RowObject.prazo-entreg = ? THEN
        ASSIGN RowObject.prazo-entreg = 0.

    IF RowObject.nr-processo = ? THEN
        ASSIGN RowObject.nr-processo = 0.

    IF RowObject.cod-comprado = ? OR RowObject.cod-comprado = "" THEN
        ASSIGN RowObject.cod-comprado = c-cod-comprador.

    IF RowObject.dep-almoxar = ? OR RowObject.dep-almoxar = "" THEN
        ASSIGN RowObject.dep-almoxar = c-deposito.

    IF RowObject.tp-despesa = ? OR RowObject.tp-despesa = 0 THEN
        ASSIGN RowObject.tp-despesa = int(i-tp-desp).

    IF RowObject.ct-codigo = ? OR RowObject.ct-codigo = "" THEN
        ASSIGN RowObject.ct-codigo = c-ct-codigo.

    IF RowObject.sc-codigo = ? OR RowObject.sc-codigo = "" THEN
        ASSIGN RowObject.sc-codigo = c-sc-codigo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLSegcc0300 DBOProgram 
PROCEDURE setLSegcc0300 :
/*------------------------------------------------------------------------------
  Purpose: Modifica o status da vari†vel l-seg-cc0300. Indica se o usu†rio ser† validado
           ou n∆o em relaá∆o a sua permiss∆o para inserir, alterar ou remover pedidos na
           tela cc0300.
  Parameters:
  Notes: PARA SER EXECUTADA SOMENTE DO PROGRAMA CC0300 OU DAS TELAS FILHO
         PARA CONTROLAR SEGURANÄA POR USUµRIO PARA AÄÂES(INSERÄ«O, ALTERAÄ«O OU REMOÄ«O)
         SOB PEDIDO DE COMPRA
------------------------------------------------------------------------------*/
    {cdp/cd9731.i5}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateOrdemCompra DBOProgram
PROCEDURE updateOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:    executaUpdateOrdemCompra
              Executa a alteraá∆o defenitivamente e retorna mensagem de aprovacao eletronica.
  Parameters: 
  Notes:      antes de executar esse mÇtodo precisa-se executar
              run repositionRecord  in h-boin274vl (input r-chave).
              run setRecord         in h-boin274vl (input table tt-ordem-compra).
              ser† retornada temp-table de erros atravÇs do mÇtodo getRowErrors 
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-perc-descto-aux AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE r-chave            AS ROWID     NO-UNDO.

    IF AVAIL {&TableName} THEN ASSIGN r-chave = ROWID({&TableName}).

    FIND FIRST RowErrors NO-LOCK NO-ERROR.

    IF NOT AVAIL RowErrors THEN DO:
        
       FOR FIRST b-prazo-compra FIELDS(numero-ordem situacao)
           WHERE b-prazo-compra.numero-ordem = RowObject.numero-ordem
             AND b-prazo-compra.situacao <> 4 /* Eliminada */
             AND b-prazo-compra.situacao <> 6 /* Recebida */ NO-LOCK: END.

       IF NOT AVAIL b-prazo-compra AND RowObject.situacao <> 6 AND RowObject.nr-contrato = 0 THEN
           ASSIGN RowObject.situacao = 6.

       IF AVAIL b-prazo-compra AND RowObject.situacao = 6 THEN
           ASSIGN RowObject.situacao = 2.

       FOR FIRST cotacao-item FIELDS(numero-ordem cot-aprovada preco-fornec)
           WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
             AND cotacao-item.cot-aprovada NO-LOCK: END.

       IF RowObject.valor-descto <> ordem-compra.valor-descto AND AVAIL cotacao-item THEN DO:

           ASSIGN de-perc-descto-aux = (RowObject.valor-descto * 100) / cotacao-item.preco-fornec .

           IF de-perc-descto-aux > 100 THEN
               ASSIGN RowObject.perc-descto = 99.99999.
           ELSE
               ASSIGN RowObject.perc-descto = de-perc-descto-aux.
       END.

       IF RETURN-VALUE = "OK":U THEN DO:
           
           RUN inbo/boin274.p PERSISTENT SET h-boin274.

           RUN setConstraintNumPedido IN h-boin274 (INPUT rowObject.num-pedido).
           RUN openQueryStatic        IN h-boin274 ("ByPedido":U).
           RUN validateUpdate         IN h-boin274 (INPUT TABLE rowObject,
                                                    INPUT r-chave,
                                                    OUTPUT TABLE RowErrors).
           DELETE PROCEDURE h-boin274.
           ASSIGN h-boin274 = ?.
       END.

        /** Multiplanta **/
        FIND FIRST pedido-compr
             WHERE pedido-compr.num-pedido = RowObject.num-pedido NO-LOCK NO-ERROR.

        IF AVAIL pedido-compr AND param-global.modulo-mp THEN DO:

            RUN ccp/ccapi200.p (INPUT "Pedido-compr":U, INPUT ROWID(pedido-compr),
                                INPUT  2, INPUT-OUTPUT TABLE tt-erro-mp).

            FOR EACH tt-erro EXCLUSIVE-LOCK:

                ASSIGN i-seq-erro = i-seq-erro + 10.

                CREATE RowErrors.
                ASSIGN RowErrors.ErrorSequence    = i-seq-erro
                       RowErrors.ErrorNumber      = tt-erro-mp.cd-erro
                       RowErrors.ErrorParameters  = "":U
                       RowErrors.ErrorType        = "":U
                       RowErrors.ErrorSubType     = "ERROR":U
                       RowErrors.ErrorDescription = tt-erro-mp.mensagem
                       RowErrors.ErrorHelp        = tt-erro-mp.mensagem.

                DELETE tt-erro.
            END.
        END.

        /** Aprovaá∆o Eletrìnica **/
        IF param-compra.log-1 AND AVAIL RowObject AND AVAIL pedido-compr THEN DO:

            IF pedido-compr.emergencial THEN
                RUN cdp/cdapi171.p (6,2,r-chave). /* Emergencial */
            ELSE
                RUN cdp/cdapi171.p (4,2,r-chave)).

            RUN mensagemAprEletrOrdemCompra (r-chave, 4). /* cria temp-table de erros */
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valAtivCamposOrdemAddManutOrdCompra DBOProgram
PROCEDURE valAtivCamposOrdemAddManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose: Valida a ativaá∆o de campos na tela no modo de adiá∆o.
  Parameters: ipar1 : plNormal         : Tipo da Ordem (Normal/M£ltipla)
              opar2 : plEnblNrContrato : Status do nr-contrato
              opar3 : plEnblNumSeqItem : Status do num-seq-item
              opar4 : plEnblSequencia  : Status da sequencia
              opar5 : plEnblOrdem      : Status da ordem
              opar6 : plEnblNrProcesso : Status do nr-processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER plNormal         AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnblNrContrato AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnblNumSeqItem AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnblSequencia  AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnblOrdem      AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnblNrProcesso AS LOGICAL NO-UNDO.

    ASSIGN plEnblNrContrato  = param-global.modulo-cn
           plEnblNumSeqItem = param-global.modulo-cn
           plEnblNrProcesso  = param-global.modulo-cn.
    
    IF AVAIL param-compra THEN DO:
        
        IF SUBSTRING(param-compra.char-2,14,1,"character")  = "Y":U THEN
            ASSIGN plEnblOrdem = YES
                   plEnblSequencia = NOT(plNormal).
        ELSE
            ASSIGN plEnblOrdem = NO
                   plEnblSequencia = NO.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valAtivCamposOrdemModifManutOrdCompra DBOProgram
PROCEDURE valAtivCamposOrdemModifManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose: Gera o status de ativaá∆o dos campos na tela no modo de modificaá∆o
           no programa de manutená∆o de ordens de compra.
  Parameters: ipar1 : table for rowObject : Registro a ser modificado
              opar2 : plEnablNrProcesso   : Status do nr-processo
              opar3 : plEnblNrContrato    : Status do nr-contrato
              opar4 : plEnblNumSeqItem    : Status do num-seq-item
              opar5 : plEnblConta         : Status da ct-codigo
              opar6 : plEnblOpCodigo      : Status do op-codigo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE             FOR rowObject.
    DEFINE OUTPUT PARAMETER plEnablNrProcesso AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnblNrContrato  AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnblNumSeqItem  AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnblConta       AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnblOpCodigo    AS LOGICAL NO-UNDO.

    FIND FIRST rowObject NO-ERROR.
    
    ASSIGN plEnablNrProcesso = IF (rowObject.nr-contrato <> 0 OR NOT param-compra.usa-proc) THEN NO ELSE YES.

    IF rowObject.nr-processo > 0 OR NOT param-global.modulo-cn THEN
        ASSIGN plEnblNrContrato  = NO
               plEnblNumSeqItem  = NO.
    ELSE
        ASSIGN plEnblNrContrato  = YES
               plEnblNumSeqItem  = YES.

    ASSIGN plEnblConta    = NOT(param-global.modulo-cp = YES AND rowObject.ordem-servic > 0)
           plEnblOpCodigo = param-global.modulo-en.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valAtivGeracaoItFornec DBOProgram
PROCEDURE valAtivGeracaoItFornec :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER plEnblGeracaoAutomatica AS LOGICAL NO-UNDO.

    ASSIGN plEnblGeracaoAutomatica = NO.

    IF AVAIL param-compra THEN
        ASSIGN plEnblGeracaoAutomatica = param-compra.gera-item-for.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valExecSplitOCManutOrdCompra DBOProgram
PROCEDURE valExecSplitOCManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose: Valida a execuá∆o do split de ordem de compra ap¢s a inclus∆o
           de um novo registro
  Parameters: opar1 : plExecutaSplitOC : Executa split?
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER plExecutaSplitOC AS LOGICAL NO-UNDO.

    IF rowObject.nr-contrato = 0 THEN DO:
        
        IF CAN-FIND (FIRST item-fornec
                     WHERE item-fornec.it-codigo = rowObject.it-codigo
                       AND item-fornec.ativo) THEN DO:

            IF rowObject.nr-processo = 000.000 THEN
                ASSIGN plExecutaSplitOC = YES.
            ELSE DO:

                ASSIGN plExecutaSplitOC = NO.
                RUN cdp/cd9400a.p (INPUT rowObject.r-rowid).
            END.
        END.
    END.

    RETURN (IF NOT (CAN-FIND (FIRST RowErrors)) THEN "OK":U ELSE "NOK":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaAtivacaoCamposPedEmerg DBOProgram
PROCEDURE validaAtivacaoCamposPedEmerg :
/*------------------------------------------------------------------------------
  Purpose: Valida a ativaá∆o dos campos no programa de Pedidos Emergenciais.
  Parameters: ipar1 : piNumPedido          : N£mero do pedido a ser validado
              ipar2 : piNumOrdem           : N£mero da ordem
              ipar3 : pcAction             : add, update ou copy?
              opar4 : plEnableNumeroOrdem  : Habilita n£mero da ordem?
              opar5 : plEnableOrdemServic  : Habilita ordem de serviáo
              opar6 : plEnableOpCodigo     : Habilita c¢digo da operaá∆o
              opar7 : pc-CodComprado       : Retorna o c¢digo do comprador
              opar8 : plQtSolicSensitive   : Habilita qt-solic
              opar9 : plNumOrdInvSensitive : Habilita num-ord-inv
              opar10: plImprFichaChecked   : Marca Imprime Ficha?
              opar11: plImprFichaSensitive : Habilita Imprime Ficha
              opar12: plItemFornSensitive  : Habilita Geraá∆o Item Fornec.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piNumPedido          AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piNumOrdem           AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER pcAction             AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnableNumeroOrdem  AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnableOrdemServic  AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnableOpCodigo     AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-CodComprado       AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER plQtSolicSensitive   AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER plNumOrdInvSensitive AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER plImprFichaChecked   AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER plImprFichaSensitive AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER plItemFornSensitive  AS LOGICAL     NO-UNDO.

    IF NOT AVAIL param-compra THEN FIND FIRST param-compra NO-LOCK NO-ERROR. 

    FOR FIRST pedido-compr FIELDS(num-pedido natureza nr-processo)
        WHERE pedido-compr.num-pedido = piNumPedido NO-LOCK: END.

    IF AVAIL param-compra THEN
        ASSIGN plEnableNumeroOrdem  = (IF SUBSTRING(param-compra.char-2,14,1,"character":U) = "Y":U THEN YES ELSE NO).
    ELSE
        ASSIGN plEnableNumeroOrdem  = NO.

    ASSIGN plEnableOrdemServic  = YES.

    ASSIGN plEnableNumeroOrdem = (pcAction <> "Update":U AND plEnableNumeroOrdem = YES).

    ASSIGN plEnableOpCodigo = (pedido-compr.natureza = 3).

    IF pcAction = "Update":U THEN DO:
        
        FOR FIRST ordem-compra FIELDS(cod-comprado)
            WHERE ordem-compra.numero-ordem = piNumOrdem NO-LOCK:

            ASSIGN pc-CodComprado = ordem-compra.cod-comprado.
       END.

       ASSIGN plQtSolicSensitive   = NO
              plNumOrdInvSensitive = NO
              plImprFichaChecked   = ordem-compra.impr-ficha.
    END.
    ELSE DO:

        FOR FIRST proc-compra FIELDS(nr-processo cod-comprado)
            WHERE proc-compra.nr-processo = pedido-compr.nr-processo NO-LOCK: END.

        IF AVAIL proc-compra AND pedido-compr.nr-processo > 0 THEN
            ASSIGN pc-CodComprado = proc-compra.cod-comprado.

       ASSIGN plQtSolicSensitive   = YES
              plNumOrdInvSensitive = param-global.modulo-in
              plImprFichaChecked   = NO.
    END.

    ASSIGN plImprFichaSensitive = NO
           plItemFornSensitive  = YES.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaContratosOrdemCompra DBOProgram
PROCEDURE validaContratosOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: Relaciona ordens ao contrato, ou seja, verifica se a ordem pode
           ser inclu°da no contrato. Valida inconsistàncias no contrato.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    
    FOR FIRST prazo-compra FIELDS(numero-ordem data-entrega)
        WHERE prazo-compra.numero-ordem = rowObject.numero-ordem NO-LOCK: END.
    
    IF rowObject.nr-contrato <> 0 THEN DO:

        IF NOT AVAIL contrato-for THEN
            FOR FIRST contrato-for FIELDS(nr-contrato dt-ini-validade dt-ter-validade)
                WHERE contrato-for.nr-contrato = rowObject.nr-contrato NO-LOCK: END.

        IF AVAIL contrato-for THEN DO:

            FOR FIRST bPrazoCompra FIELDS(numero-ordem data-entrega)
                WHERE bPrazoCompra.numero-ordem = rowObject.numero-ordem
                  AND (bPrazoCompra.data-entrega < contrato-for.dt-ini-validade OR bPrazoCompra.data-entrega > contrato-for.dt-ter-validade) NO-LOCK: END.

            IF  NOT AVAIL bPrazoCompra THEN DO:
                RUN cnp/cn9080.p (INPUT rowObject.numero-ordem,
                                  INPUT 0,
                                  INPUT 0,
                                  INPUT prazo-compra.data-entrega,
                                  OUTPUT lErroCo).
                /* Tratamento de contratos na divis∆o da ordem */
            END.

            IF lErroCo OR AVAIL bPrazoCompra THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17275" &ErrorType="EMS" &ErrorSubType="ERROR"}

                /* O Contrato informado possui inconsistencias.
                   Favor verificar:
                   - data de validade do contrato
                   - situaÖ∆o do contrato e item do contrato
                   - se o contrato prev« o estabelecimento informado na ordem de compra
                   - o tipo de controle do item no contrato: ordem, programaÖ∆o ou mediÖ∆o
                   - saldo do contrato (por item ou estabelecimento): n∆o h† mais saldo em
                   quantidade/valor a ser consumido no contrato
                 */
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaDataNatureza DBOProgram
PROCEDURE validaDataNatureza :
/*------------------------------------------------------------------------------
  Purpose: Valida data inicial e final do pedido, e natureza da operaá∆o.
  Parameters: ipar1  : plCompra   : Natureza da Operaá∆o.
              ipar2  : plServico  : Ordem de serviáo
              ipar3  : plBenefic  : Beeficiamento
              ipar4  : pdaInicial : Data Inicial do Pedido.
              ipar5  : pdaFinal   : Data Final do Pedido.
              opar6  : rowErrors  : Temp-table de Erros Retornados.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER plCompra   AS LOGICAL   NO-UNDO.
    DEFINE INPUT  PARAMETER plServico  AS LOGICAL   NO-UNDO.
    DEFINE INPUT  PARAMETER plBenefic  AS LOGICAL   NO-UNDO.
    DEFINE INPUT  PARAMETER pdaInicial AS DATE      NO-UNDO.
    DEFINE INPUT  PARAMETER pdaFinal   AS DATE      NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE daInicial AS DATE       NO-UNDO.
    DEFINE VARIABLE daFinal   AS DATE       NO-UNDO.
    DEFINE VARIABLE lCompra   AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lServico  AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lBenefic  AS LOGICAL    NO-UNDO.

    assign lCompra   = plCompra
           lServico  = plServico
           lBenefic  = plBenefic
           daInicial = pdaInicial
           daFinal   = pdaFinal.

    IF daInicial > daFinal THEN DO:
        
        {utp/ut-liter.i "Data_Inicial_+" *}
        ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "+_Data_Final" *}
        ASSIGN c-lbl-traducao = c-lbl-traducao + ' ' + "~~" + ' ' + TRIM(RETURN-VALUE).
    
        {method/svc/errors/inserr.i &ErrorNumber="89"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-traducao"}
    END.

    IF lCompra  = NO AND lServico = NO AND lBenefic = NO THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="2171" &ErrorType="EMS" &ErrorSubType="ERROR"}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEliminacaoOrdemCompra DBOProgram
PROCEDURE validaEliminacaoOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: Retorna informaá∆o antes de eliminar as ordens de compra do pedido de compra
           se o Pedido de Compra informado possui Ordem de Compra recebida ou a Ordem de Compra
           que est† para ser eliminada possui parcela recebida e n∆o deixa eliminar.
  Parameters: ipar1 : rOrdem    : rowid da tabela ordem-compra
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER rOrdem AS ROWID NO-UNDO.
    
    DEFINE VARIABLE l-proces-pregao AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE l-usuar-pregao  AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE c-lbl-liter1    AS CHARACTER    NO-UNDO.
    
    DEFINE VARIABLE h-ccOrdemCompraValidaIntegraMe AS HANDLE  NO-UNDO.
    DEFINE VARIABLE l-ordem-integrada-me           AS LOGICAL NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.
    //Valida OC integrada com o Mercado Eletronico
    IF NOT VALID-HANDLE(h-ccOrdemCompraValidaIntegraMe) THEN
        RUN ccp/ccOrdemCompraValidaIntegraMe.p PERSISTENT SET h-ccOrdemCompraValidaIntegraMe.

    FOR FIRST ordem-compra FIELDS(situacao ep-codigo cod-estabel num-ord-inv numero-ordem)
        WHERE ROWID(ordem-compra) = rOrdem NO-LOCK: END.
        
    IF NOT AVAIL ordem-compra THEN DO:
       RETURN "NOK".
    END.
    
    RUN verifica-ordem-compra IN h-ccOrdemCompraValidaIntegraMe (INPUT  ordem-compra.numero-ordem,
                                                                 OUTPUT l-ordem-integrada-me).

    IF VALID-HANDLE(h-ccOrdemCompraValidaIntegraMe) THEN DO:
        DELETE PROCEDURE h-ccOrdemCompraValidaIntegraMe.
        ASSIGN h-ccOrdemCompraValidaIntegraMe = ?.
    END.
                                                                     
    IF l-ordem-integrada-me THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="58000"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters= ordem-compra.numero-ordem}
        RETURN "NOK":U.   
    END.
    
    //Fim valida OC integrada com ME


    IF ordem-compra.situacao = 4 THEN DO: /* Eliminada */
        
        {method/svc/errors/inserr.i &ErrorNumber="3138" &ErrorType="EMS" &ErrorSubType="ERROR"}
    END.

    FOR FIRST recebimento FIELDS(numero-ordem)
        WHERE recebimento.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
        
        {method/svc/errors/inserr.i &ErrorNumber="3106" &ErrorType="EMS" &ErrorSubType="ERROR"}
    END.

    /* Investimentos */
    if AVAIL ordem-compra AND param-global.modulo-in AND ordem-compra.num-ord-inv <> 0 THEN DO:
        
        /* Validaá‰es eliminaá∆o ordem de compra X Investimento */
        RUN inp/inapi410.p(INPUT ROWID(ordem-compra), OUTPUT TABLE tt-erro).

        IF RETURN-VALUE = "NOK":U THEN DO:

            FIND FIRST tt-erro NO-ERROR.
            
            IF AVAIL tt-erro THEN DO:
                
                {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="tt-erro.c-param"}
            END.
        END.
    END.

    FIND FIRST pedido-compr WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.

    FIND FIRST proc-compra NO-LOCK
         WHERE proc-compra.nr-processo = ordem-compra.nr-processo NO-ERROR.

    IF AVAIL proc-compra THEN
        ASSIGN l-proces-pregao = proc-compra.log-proces-pregao.
    
    IF l-proces-pregao THEN DO:

        FIND FIRST usuar-mater NO-LOCK
             WHERE usuar-mater.cod-usuario = c-seg-usuario NO-ERROR.

        IF AVAIL usuar-mater THEN
            ASSIGN l-usuar-pregao = usuar-mater.log-usuar-pregao.
        
        IF NOT l-usuar-pregao AND pedido-compr.situacao <> 2 THEN DO: /* Nao Impresso */
            
            {utp/ut-liter.i "pregoeiro" *}
            ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "eliminar_este_registro" *}
            

            {method/svc/errors/inserr.i &ErrorNumber="33085"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="Error":U
                                        &ErrorParameters="c-seg-usuario + '~~~~' + c-lbl-traducao + '~~~~' + TRIM(RETURN-VALUE)"}
        END.
    END.

    IF CAN-FIND (FIRST prazo-compra
                 WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                   AND (prazo-compra.quant-receb > 0 OR prazo-compra.dec-1 > 0)) THEN DO:

        {utp/ut-liter.i Ordem_de_Compra *}
        {method/svc/errors/inserr.i &ErrorNumber="34324"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="return-value + '~~~~~' + string(ordem-compra.numero-ordem, 'zzzzz9,99')"}
    END.
    
    IF NOT AVAIL param-global THEN FIND FIRST param-global NO-LOCK NO-ERROR.
    
    /*Drawback*/
    IF param-global.log-modul-draw THEN DO:

        IF CAN-FIND(FIRST prazo-compra
                    WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                      AND &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN 
                         prazo-compra.cod-ato-concessor <> ""
                     &ELSE
                         TRIM(SUBSTRING(prazo-compra.char-2,11,30)) <> ""
                     &ENDIF) THEN DO:
                     
                    {utp/ut-liter.i Ordem_de_Compra *}
                    ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i Ato_Concess¢rio(Drawback) * r} 

                    {method/svc/errors/inserr.i &ErrorNumber="5"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-lbl-traducao + '~~~~~' + trim(return-value)"}          
        END.
    END.

    FOR EACH tt-epc WHERE tt-epc.cod-event = "valEliminaRelacOrdemPedido":U:
        DELETE tt-epc.
    END.
    
    {include/i-epc200.i2 &CodEvent='"valEliminaRelacOrdemPedido"'
                         &CodParameter='"OBJECT-HANDLE"'
                         &ValueParameter="string(this-procedure)"}
                         
    {include/i-epc200.i2 &CodEvent='"valEliminaRelacOrdemPedido"'
                         &CodParameter='"rowid-ordem-compra"'
                         &ValueParameter="string(rowid(ordem-compra))"}
                         
    
    {include/i-epc201.i "valEliminaRelacOrdemPedido"}
    IF  RETURN-VALUE = "NOK":U THEN DO:
        UNDO, RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEliminacaoPedidoCompra DBOProgram
PROCEDURE validaEliminacaoPedidoCompra :
/*------------------------------------------------------------------------------
  purpose: retorna informaá∆o antes de eliminar as ordens de compra do pedido de compra
           se o pedido de compra informado possui ordem de compra recebida ou a ordem de compra
           que est† para ser eliminada possui parcela recebida e n∆o deixa eliminar.
  parameters: ipar1 : rPedido    : rowid da tabela pedido-compr
  notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER rPedido AS ROWID NO-UNDO.

    DEFINE VARIABLE l-proces-pregao AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-usuar-pregao  AS LOGICAL NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.

    FOR FIRST pedido-compr FIELDS (num-pedido situacao) NO-LOCK
        WHERE ROWID(pedido-compr) = rPedido:
        
        FOR EACH ordem-compra FIELDS(situacao ep-codigo cod-estabel num-ord-inv num-pedido numero-ordem nr-processo)
           WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-LOCK
        BREAK BY ordem-compra.numero-ordem:
            
            IF CAN-FIND(FIRST RowErrors  WHERE RowErrors.ErrorNumber = 3138)
            AND ordem-compra.situacao = 4 THEN DO: /* Eliminada */

                {method/svc/errors/inserr.i &ErrorNumber="3138" &ErrorType="EMS" &ErrorSubType="ERROR"}
            END.

            IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorNumber = 3106) THEN DO:

                FOR FIRST recebimento FIELDS(numero-ordem)
                    WHERE recebimento.numero-ordem = ordem-compra.numero-ordem NO-LOCK:

                    {method/svc/errors/inserr.i &errornumber="3106" &errortype="ems" &errorsubtype="error"}
                END.
            END.

            /* investimentos */
            IF AVAIL ordem-compra AND param-global.modulo-in AND ordem-compra.num-ord-inv <> 0 THEN DO:
                
                /* validaá‰es eliminaá∆o ordem de compra x investimento */
                RUN inp/inapi410.p(INPUT ROWID(ordem-compra), OUTPUT TABLE tt-erro).
                
                IF RETURN-VALUE = "NOK":U THEN DO:

                    FIND FIRST tt-erro NO-ERROR.
                    
                    IF AVAIL tt-erro THEN DO:

                        {method/svc/errors/inserr.i &errornumber="tt-erro.cd-erro"
                                                    &errortype="ems"
                                                    &errorsubtype="error"
                                                    &errorparameters="tt-erro.c-param"}
                    END.
                END.
            END.

            IF CAN-FIND (FIRST prazo-compra
                         WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                           AND (prazo-compra.quant-receb > 0 OR prazo-compra.dec-1 > 0)) THEN DO:

                {utp/ut-liter.i Ordem_de_Compra *}
                
                {method/svc/errors/inserr.i &ErrorNumber="34324"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="return-value + '~~~~~' + string(ordem-compra.numero-ordem, 'zzzzz9,99')"}
            END.

            IF CAN-FIND (FIRST prazo-compra
                         WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                           AND (prazo-compra.quant-receb > 0 OR prazo-compra.dec-1 > 0)) THEN DO:

                {utp/ut-liter.i Ordem_de_Compra *}
                
                {method/svc/errors/inserr.i &ErrorNumber="34324"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="return-value + '~~~~~' + string(ordem-compra.numero-ordem, 'zzzzz9,99')"}
            END.

            FOR FIRST proc-compra NO-LOCK
                WHERE proc-compra.nr-processo = ordem-compra.nr-processo:
                
                ASSIGN l-proces-pregao = proc-compra.log-proces-pregao.
            END.

            IF l-proces-pregao THEN DO:

                FOR FIRST usuar-mater NO-LOCK
                    WHERE usuar-mater.cod-usuario = c-seg-usuario:
                    
                    ASSIGN l-usuar-pregao = usuar-mater.log-usuar-pregao.
                END.

                IF NOT l-usuar-pregao AND pedido-compr.situacao <> 2 THEN DO: /* Nao Impresso */

                    {utp/ut-liter.i "pregoeiro" *}
                    ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i "eliminar_este_registro" *}

                    {method/svc/errors/inserr.i &errornumber="33085"
                                                &errortype="ems":u
                                                &errorsubtype="error":u
                                                &errorparameters="c-seg-usuario + '~~~~' + c-lbl-traducao + '~~~~' + TRIM(RETURN-VALUE)"}
                END.
            END.

            FOR EACH tt-epc WHERE tt-epc.cod-event = "valeliminaordempedido":U:
                DELETE tt-epc.
            END.
            
            {include/i-epc200.i2 &codevent='"valeliminaordempedido"'
                                 &codparameter='"object-handle"'
                                 &valueparameter="string(this-procedure)"}
                                 
            {include/i-epc200.i2 &codevent='"valeliminaordempedido"'
                                 &codparameter='"rowid-ordem-compra"'
                                 &valueparameter="string(rowid(ordem-compra))"}
            
            {include/i-epc201.i "valeliminaordempedido"}

            IF  RETURN-VALUE = "NOK":U THEN
                UNDO, RETURN "NOK":U.
        END. /* Ordem Compra */

        RETURN "OK":U.
    END. /* Pedido Compra */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaModificacaoOrdemCompra DBOProgram
PROCEDURE validaModificacaoOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     Valida se a situacao da Ordem permite modificaá∆o
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER rOrdem AS ROWID NO-UNDO.
    
    EMPTY TEMP-TABLE RowErrors.
    
    FOR FIRST ordem-compra FIELDS(situacao)
        WHERE ROWID(ordem-compra) = rOrdem NO-LOCK: END.

    IF AVAIL ordem-compra THEN DO:
        
        IF ordem-compra.situacao = 4 THEN DO: /* Eliminada */

            {method/svc/errors/inserr.i &ErrorNumber="3138" &ErrorType="EMS" &ErrorSubType="ERROR"}
        END.

        FOR EACH tt-epc WHERE tt-epc.cod-event = "validaModificacaoOrdemCompra":U:
            DELETE tt-epc.
        END.

        {include/i-epc200.i2 &CodEvent='"validaModificacaoOrdemCompra"'
                             &CodParameter='"OBJECT-HANDLE"'
                             &ValueParameter="string(this-procedure)"}
                             
        {include/i-epc200.i2 &CodEvent='"validaModificacaoOrdemCompra"'
                             &CodParameter='"rowid-ordem"'
                             &ValueParameter="string(rowid(ordem-compra))"}

        {include/i-epc201.i "validaModificacaoOrdemCompra"}

        IF RETURN-VALUE = "NOK":U THEN DO:
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaMultiplanta DBOProgram
PROCEDURE ValidaMultiplanta :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prOrdemCompra AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors .

    DEFINE VARIABLE l-erro-mp AS LOGICAL NO-UNDO.

    RUN emptyRowErrors IN THIS-PROCEDURE.

    /* Valida apenas com o pedido impresso */
    FOR FIRST ordem-compra FIELDS (num-pedido)
        WHERE ROWID(ordem-compra) = prOrdemCompra NO-LOCK: END.

    IF AVAIL ordem-compra AND 
    CAN-FIND (FIRST pedido-compr
              WHERE pedido-compr.num-pedido = ordem-compra.num-pedido
                AND pedido-compr.situacao   = 1 /* Impresso */ ) THEN DO:

        RUN ccp/ccapi199.p ("Altera-ordem":U, prOrdemCompra, OUTPUT l-erro-mp).
    
        IF l-erro-mp THEN DO:
            
            {utp/ut-liter.i "Pedido_de_Compra" *}
            {method/svc/errors/inserr.i &ErrorNumber="7193"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaMultiplantaPedido DBOProgram
PROCEDURE ValidaMultiplantaPedido :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prPedidoCompra AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors .

    DEFINE VARIABLE l-erro-mp AS LOGICAL INITIAL NO NO-UNDO.

    RUN emptyRowErrors IN THIS-PROCEDURE.

    FOR FIRST pedido-compr FIELDS(num-pedido)
        WHERE ROWID(pedido-compr) = prPedidoCompra NO-LOCK:

        FOR FIRST ordem-compra FIELDS(num-pedido)
            WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-LOCK: END.
    END.
    
    IF AVAIL ordem-compra THEN DO:

        IF ordem-compra.num-pedido = 0
        OR CAN-FIND(FIRST pedido-compr
                    WHERE pedido-compr.num-pedido = ordem-compra.num-pedido
                      AND pedido-compr.situacao   = 1 /*Impresso*/ ) THEN DO:
            
            RUN ccp/ccapi199.p ("Altera-ordem":U, ROWID(ordem-compra), OUTPUT l-erro-mp).
    
            IF l-erro-mp THEN DO:
                
                {utp/ut-liter.i "Pedido_de_Compra" *}
                {method/svc/errors/inserr.i &ErrorNumber="7193"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaOrdemCompraPedImp DBOProgram
PROCEDURE validaOrdemCompraPedImp :
/*------------------------------------------------------------------------------
  Purpose:  (validaParcelaOrdemCompra)
            Valida existencia de cotaá∆o para a ordem de compra
            Valida a Unidades de Medida.
            Valida Conta Cont†bil
  Parameters: ipar1  : pNumero-ordem : n£mero da ordem-compra
              ipar4  : cContaContabil: Conta contabil
              ipar5  : cCodComprado  : Codigo do comprador
              ipar7  : iOrdemServic  : Numero da ordem do serviáo
              ipar14 : cComentarios  : Motivo
              gera RowErrors
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNumero-ordem   AS INTEGER       NO-UNDO.
    DEFINE INPUT PARAMETER c-ct-codigo     AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER c-sc-codigo     AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER cCodComprado    AS CHARACTER     NO-UNDO.
    DEFINE INPUT PARAMETER iOrdemServic    AS INTEGER       NO-UNDO.
    DEFINE INPUT PARAMETER cComentarios    AS CHARACTER     NO-UNDO.

    FOR FIRST ordem-compra NO-LOCK
        WHERE ordem-compra.numero-ordem = pNumero-ordem: END.
    
    FOR FIRST item NO-LOCK
        WHERE item.it-codigo = ordem-compra.it-codigo: END.

    IF ordem-compra.nr-contrato = 0 THEN DO:
        
        IF item.tipo-contr = 4 OR ordem-compra.ct-codigo <> c-ct-codigo THEN DO:

            IF item.tipo-contr <> 2 AND c-ct-codigo = "" THEN DO:

                FIND FIRST estabelec NO-LOCK
                      WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-ERROR.

                ASSIGN iEmpresa = estabelec.ep-codigo WHEN AVAIL estabelec.

                RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

                RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        iEmpresa,                 /* EMPRESA EMS2 */
                                                               INPUT        "",                       /* PLANO DE CONTAS */
                                                               INPUT-OUTPUT c-ct-codigo,              /* CONTA */
                                                               INPUT        ordem-compra.data-atualiz,/* DATA TRANSACAO */
                                                               OUTPUT       v_des_cta_ctbl,           /* DESCRICAO CONTA */
                                                               OUTPUT       v_num_tip_cta_ctbl,       /* TIPO DA CONTA */
                                                               OUTPUT       v_num_sit_cta_ctbl,       /* SITUAÄ«O DA CONTA */
                                                               OUTPUT       v_ind_finalid_cta,        /* FINALIDADES DA CONTA */
                                                               OUTPUT TABLE tt_log_erro).             /* ERROS */
                IF VALID-HANDLE(h_api_cta_ctbl) THEN
                    DELETE OBJECT h_api_cta_ctbl.

                FOR FIRST tt_log_erro:

                    {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro)"}
                END.

                IF (INT(v_num_tip_cta_ctbl) <> 1 AND
                    INT(v_num_tip_cta_ctbl) <> 4 AND
                    INT(v_num_tip_cta_ctbl) <> 5) OR
                    INT(v_num_sit_cta_ctbl) <> 3 THEN DO:

                    {method/svc/errors/inserr.i &ErrorNumber="1576" &ErrorType="EMS" &ErrorSubType="ERROR"}
                END.
            END.
        END.
    END.

    IF AVAIL ordem-compra THEN DO:

        IF ordem-compra.natureza <> 3 THEN DO:
            FIND CURRENT ordem-compra EXCLUSIVE-LOCK.
            ASSIGN ordem-compra.op-codigo = 0.
        END.

        IF ordem-compra.nr-contrato <> 0 OR (ordem-compra.num-ord-inv <> 0 AND param-global.modulo-in) THEN DO:
            
            FIND CURRENT ordem-compra EXCLUSIVE-LOCK.
            ASSIGN ordem-compra.ordem-servic = 0.
        END.
    END.

    RUN validateComumOC-OCdePedido.

    RETURN (IF NOT (CAN-FIND (FIRST RowErrors)) THEN "OK":U ELSE "NOK":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaSegUsuarioPedCompra DBOProgram
PROCEDURE validaSegUsuarioPedCompra :
/*------------------------------------------------------------------------------
  Purpose: Validar a permiss∆o do usu†rio logado quanto Ö inserá∆o, alteraá∆o e remoá∆o de
           um pedido de compra.
  Parameters:
  Notes: VALIDAÄ«O PARA SER EXECUTADA DO PROGRAMA CC0300 OU DAS TELAS FILHO
         PARA CONTROLAR SEGURANÄA POR USUµRIO PARA AÄÂES(INSERÄ«O, ALTERAÄ«O OU REMOÄ«O)
         SOBRE PEDIDO DE COMPRA
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-pedido  LIKE ordem-compra.num-pedido NO-UNDO.
    DEFINE INPUT PARAMETER pr-ordem     AS   ROWID                   NO-UNDO.
    DEFINE INPUT PARAMETER pi-tipo      AS   INTEGER                 NO-UNDO.

    DEFINE VARIABLE i-num-pedido LIKE ordem-compra.num-pedido NO-UNDO.

    IF pr-ordem <> ? THEN DO:

       FOR FIRST ordem-compra FIELDS(num-pedido)
           WHERE ROWID(ordem-compra) = pr-ordem NO-LOCK:

           ASSIGN i-num-pedido = ordem-compra.num-pedido.
        END.
    END.
    ELSE
        ASSIGN i-num-pedido = pnum-pedido.

    RUN setLSegcc0300.

    /* VALIDAÄ«O DO PROGRAMA CC0300 PARA CONTROLAR SEGURANÄA POR USUµRIO PARA PEDIDO DE COMPRA */
    IF l-seg-cc0300 THEN
        RUN validateSegCC0300 (INPUT pi-tipo, INPUT i-num-pedido).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateAtoConcessorio DBOProgram 
PROCEDURE validateAtoConcessorio :
/*------------------------------------------------------------------------------
  Purpose:     Realizar validaá‰es do ato concess¢rio informado para a parcela
  Parameters:  c-nr-ato-concessorio: N£mero do Ato Concess¢rio
               pcAction            : Aá∆o do usu†rio (ADD, UPDATE, DELETE)
               pi-numero-ordem     : N£mero de Ordem de compra;
               pde-quant-parcela   : Quantidade total da parcela na ordem de compra
               RowErrors (Sa°da)   : Temp-table contendo erros de validaá∆o;
  Notes:       Executado pelos programas CC0300B e BOIN295.p
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-nr-ato-concessorio AS   CHARACTER                 NO-UNDO.
    DEFINE INPUT  PARAMETER pcAction             AS   CHARACTER                 NO-UNDO.
    DEFINE INPUT  PARAMETER pi-numero-ordem      LIKE prazo-compra.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAMETER pde-quant-parcela    LIKE prazo-compra.quantidade   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE h-bocx315           AS   HANDLE                  NO-UNDO.
    DEFINE VARIABLE de-quant-sdo        AS   DECIMAL                 NO-UNDO.
    DEFINE VARIABLE c-msg               AS   CHARACTER               NO-UNDO.
    DEFINE VARIABLE l-emitente-nacional AS   LOGICAL                 NO-UNDO.
    DEFINE VARIABLE c-nr-ato            AS   CHARACTER               NO-UNDO.
    DEFINE VARIABLE de-quantidade       LIKE prazo-compra.quantidade NO-UNDO.
    DEFINE VARIABLE i-cod-emitente      LIKE emitente.cod-emitente   NO-UNDO.

    FIND FIRST RowObject NO-ERROR.

    IF NOT VALID-HANDLE(h-bocx315) THEN
        RUN cxbo/bocx315.p PERSISTENT SET h-bocx315.

    IF NOT AVAIL prazo-compra THEN
        FOR FIRST prazo-compra FIELDS(&IF "{&bf_mat_versao_ems}" >= "2.09" &THEN cod-ato-concessor &ELSE char-2 &ENDIF)
            WHERE prazo-compra.numero-ordem = pi-numero-ordem NO-LOCK:
        END.

    IF NOT AVAIL RowObject THEN
        FOR FIRST ordem-compra 
            WHERE ordem-compra.numero-ordem = pi-numero-ordem NO-LOCK:
            ASSIGN i-cod-emitente = ordem-compra.cod-emitente.
        END.
    ELSE
        ASSIGN i-cod-emitente = RowObject.cod-emitente.

    ASSIGN de-quantidade = 0. /*ficara com quantidade 0 na criaá∆o do registro*/
    FOR EACH bf-prazo-compra NO-LOCK
       WHERE bf-prazo-compra.numero-ordem = RowObject.numero-ordem
         AND bf-prazo-compra.situacao <> 4 /*eliminada*/
         AND bf-prazo-compra.situacao <> 6 /*recebida*/ :

         ASSIGN de-quantidade = de-quantidade + bf-prazo-compra.quantidade
                c-nr-ato      = &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN bf-prazo-compra.cod-ato-concessor
                                &ELSE trim(SUBSTRING(bf-prazo-compra.char-2,11,30))
                                &ENDIF .
    END.

    /*Calcula o valor a ser atualizado no ato concess¢rio*/
    IF c-nr-ato <> c-nr-ato-concessorio THEN
        ASSIGN de-quantidade = pde-quant-parcela.
    ELSE DO:
        IF  de-quantidade <> 0 
        AND de-quantidade <> pde-quant-parcela THEN DO: /*se est† diferente Ç porque alterou*/
            IF de-quantidade > pde-quant-parcela THEN
                ASSIGN de-quantidade = pde-quant-parcela - de-quantidade.
            ELSE
            ASSIGN de-quantidade = pde-quant-parcela - de-quantidade.
        END.
        ELSE
            IF de-quantidade = pde-quant-parcela THEN /*modificou qq outra alteraá∆o que n∆o tenha sido a quantidade da parcela, n∆o deve atualizar drawback*/
                ASSIGN de-quantidade = 0. 
            ELSE
                IF de-quantidade = 0 THEN
                   ASSIGN de-quantidade = pde-quant-parcela.
    END.

    FIND FIRST emitente 
         WHERE emitente.cod-emitente = i-cod-emitente NO-LOCK NO-ERROR.

    IF AVAIL emitente THEN DO:
       IF emitente.natureza = 1 OR emitente.natureza = 2 OR (emitente.natureza = 4 AND emitente.pais = estabelec.pais) THEN /*fornecedor apenas nacional*/
           ASSIGN l-emitente-nacional = YES.
       ELSE
           ASSIGN l-emitente-nacional = NO.
    END.

    IF  pcAction <> "DELETE":U
    AND (c-nr-ato-concessorio <> "" AND c-nr-ato-concessorio <> ?) THEN DO:

        FIND FIRST pedido-drb
             WHERE pedido-drb.nr-ato-concessorio = c-nr-ato-concessorio NO-LOCK NO-ERROR.

        IF NOT AVAIL pedido-drb THEN DO:
            {utp/ut-liter.i Ato_Concess¢rio * r}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorParameters="return-value"}
                                                
        END.
        ELSE DO:
             IF  l-emitente-nacional
             AND NOT pedido-drb.log-draw-integrad THEN DO:
                 {utp/ut-liter.i Ato_concess¢rio_n∆o_utiliza_Drawback_integrado *}
                 {method/svc/errors/inserr.i &ErrorNumber="17006"
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"
                                             &ErrorParameters="return-value"}

             END.
             IF pedido-drb.data-validade-ato < TODAY THEN DO:
                {utp/ut-liter.i Ato_Concess¢rio_informado_encontra-se_vencido *}
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
             END.
             IF pedido-drb.cod-sit-ped-drb <> 2 THEN DO:
                 {utp/ut-liter.i Ato_Concess¢rio_n∆o_est†_aprovado. *}
                 {method/svc/errors/inserr.i &ErrorNumber="17006"
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"
                                             &ErrorParameters="RETURN-VALUE"}

             END.
             
             &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                 IF  AVAIL prazo-compra
                 AND pedido-drb.nr-ato-concessorio <> prazo-compra.cod-ato-concessor THEN DO:
             &ELSE
                 IF  AVAIL prazo-compra
                 AND pedido-drb.nr-ato-concessorio <> trim(SUBSTRING(prazo-compra.char-2,11,30)) THEN DO:
             &ENDIF
                     IF CAN-FIND (FIRST item-doc-est
                                  WHERE item-doc-est.num-pedido   = RowObject.num-pedido
                                    AND item-doc-est.numero-ordem = prazo-compra.numero-ordem
                                    AND item-doc-est.parcela      = prazo-compra.parcela) THEN DO:
    
                         {utp/ut-liter.i "Pedido de Compra relacionado com Nota Fiscal de Entrada!" *}
                         ASSIGN c-msg = RETURN-VALUE.
                         {utp/ut-liter.i "N∆o Ç permitida a alteraá∆o do Ato Concess¢rio, pois o Pedido de Compra encontra-se vinculado a uma Nota Fiscal de Entrada." *}
                         ASSIGN c-msg = c-msg + "~~" + RETURN-VALUE.
                         {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                     &ErrorType="EMS"
                                                     &ErrorSubType="ERROR"
                                                     &ErrorParameters="c-msg"}
                     END.
                 END.
        END.

        FOR FIRST pedido-drb-item
            WHERE pedido-drb-item.nr-pedido-drb = pedido-drb.nr-pedido-drb
              AND pedido-drb-item.cod-estabel   = RowObject.cod-estabel
              AND pedido-drb-item.it-codigo     = RowObject.it-codigo
              AND pedido-drb-item.idi-reg = 1 NO-LOCK: 
        END.
        IF AVAIL pedido-drb-item THEN DO:
            RUN retornaQuantidadeSaldoDrb IN h-bocx315 (INPUT IF l-emitente-nacional THEN 2 ELSE 1,
                                                        INPUT pedido-drb.modalidade,
                                                        INPUT pedido-drb-item.cod-estabel,
                                                        INPUT pedido-drb-item.it-codigo,
                                                        INPUT pedido-drb-item.nr-pedido-drb,
                                                        OUTPUT de-quant-sdo).
            IF l-emitente-nacional THEN DO:
                IF  de-quant-sdo <> 0 
                AND de-quant-sdo >= (pedido-drb-item.qtd-alocada-nac + de-quantidade) THEN DO:
                    CREATE tt-pedido-drb-item.
                    BUFFER-COPY pedido-drb-item TO tt-pedido-drb-item.
                    ASSIGN tt-pedido-drb-item.qtd-alocada-nac = pedido-drb-item.qtd-alocada-nac + de-quantidade
                           tt-pedido-drb-item.r-rowid         = ROWID(pedido-drb-item).
                    RUN piEfetivaPedidoDrbItem (INPUT h-bocx315).
                END.
                ELSE DO:
                  {utp/ut-liter.i Ato_concess¢rio_n∆o_possui_saldo_suficiente. *}
                  {method/svc/errors/inserr.i &ErrorNumber="17006"
                                              &ErrorType="EMS"
                                              &ErrorSubType="ERROR"
                                              &ErrorParameters="RETURN-VALUE"}
                END.
            END.
            ELSE DO:
                IF  de-quant-sdo <> 0
                AND de-quant-sdo >= (pedido-drb-item.qtd-alocada-import + de-quantidade) THEN DO:
                    CREATE tt-pedido-drb-item.
                    BUFFER-COPY pedido-drb-item TO tt-pedido-drb-item.
                    ASSIGN tt-pedido-drb-item.qtd-alocada-import = pedido-drb-item.qtd-alocada-import + de-quantidade
                           tt-pedido-drb-item.r-rowid         = ROWID(pedido-drb-item).
                    RUN piEfetivaPedidoDrbItem (INPUT h-bocx315).
                END.
                ELSE DO:
                    {utp/ut-liter.i Ato_concess¢rio_n∆o_possui_saldo_suficiente. *}
                    {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="RETURN-VALUE"}
                END.
            END.
         END.
         ELSE DO:
            {utp/ut-liter.i Ato_concess¢rio_n∆o_possui_item_de_entrada. *}
            ASSIGN c-msg = RETURN-VALUE.
            {utp/ut-liter.i O_ato_concess¢rio_informado_n∆o_possui_item_de_entrada_correspondente_ao_item_informado_na_ordem_de_compra. *}
            assign c-msg = c-msg + "~~" + RETURN-VALUE.
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-msg"}
         END.
    END.
    
    IF pcAction = "DELETE":U
    OR (c-nr-ato-concessorio = "" AND c-nr-ato-concessorio <> c-nr-ato)
    OR (c-nr-ato <> "" AND c-nr-ato-concessorio <> c-nr-ato) THEN DO:
        IF AVAIL RowObject THEN 
            ASSIGN c-it-codigo = RowObject.it-codigo.
        ELSE 
            IF AVAIL ordem-compra THEN
                ASSIGN c-it-codigo = ordem-compra.it-codigo.

        IF AVAIL prazo-compra THEN DO:
            FIND FIRST pedido-drb
                 WHERE pedido-drb.nr-ato-concessorio = &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                                                           prazo-compra.cod-ato-concessor
                                                       &ELSE
                                                           TRIM(SUBSTRING(prazo-compra.char-2,11,30))
                                                       &ENDIF NO-LOCK NO-ERROR.
            IF AVAIL pedido-drb THEN DO:
                 FOR FIRST bf-pedido-drb-item
                     WHERE bf-pedido-drb-item.cod-estabel   = pedido-drb.cod-estabel
                       AND bf-pedido-drb-item.nr-pedido-drb = pedido-drb.nr-pedido-drb
                       AND bf-pedido-drb-item.it-codigo     = c-it-codigo
                       AND bf-pedido-drb-item.idi-reg       = 1 NO-LOCK:

                     CREATE tt-pedido-drb-item.
                     IF l-emitente-nacional THEN DO:
                         BUFFER-COPY bf-pedido-drb-item TO tt-pedido-drb-item.
                         ASSIGN tt-pedido-drb-item.qtd-alocada-nac = bf-pedido-drb-item.qtd-alocada-nac - de-quantidade
                                tt-pedido-drb-item.r-rowid         = ROWID(pedido-drb-item).
                         RUN piEfetivaPedidoDrbItem (INPUT h-bocx315).
                     END.
                     ELSE DO:
                         BUFFER-COPY bf-pedido-drb-item TO tt-pedido-drb-item.
                         ASSIGN tt-pedido-drb-item.qtd-alocada-import = bf-pedido-drb-item.qtd-alocada-import - de-quantidade
                                tt-pedido-drb-item.r-rowid            = ROWID(pedido-drb-item).
                         RUN piEfetivaPedidoDrbItem (INPUT h-bocx315).
                     END.
                 END.
            END.
        END.
    END.
    
    IF VALID-HANDLE(h-bocx315) THEN DO:
        DELETE PROCEDURE h-bocx315.
        ASSIGN h-bocx315 = ?.
    END.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateComumOC-OCdePedido DBOProgram
PROCEDURE validateComumOC-OCdePedido :
/*------------------------------------------------------------------------------
  Purpose:     validateComumOC-OCdePedido
               Validaá‰es da ordem comuns entre ordens normais (cc0301) e ordens em pedido (cc0300).
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

   IF param-global.modulo-cp AND rowObject.ordem-servic > 0 THEN DO:

       FIND FIRST ord-prod
            WHERE ord-prod.nr-ord-produ = rowObject.ordem-servic NO-LOCK NO-ERROR.

       IF NOT AVAIL ord-prod THEN DO:
           
           {utp/ut-field.i mgind ordem-compra ordem-servic 1}
           {method/svc/errors/inserr.i &ErrorNumber="2"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters=RETURN-VALUE}
       END.
       ELSE DO:

           IF ord-prod.estado = 7 THEN DO:     /* Finalizada - 3818 */
               
               {method/svc/errors/inserr.i &ErrorNumber="1882" &ErrorType="EMS" &ErrorSubType="ERROR"}
           END.

           IF ord-prod.estado = 8 THEN DO:     /* Terminada */
               
               IF c-estado = "update":U THEN DO:

                   {method/svc/errors/inserr.i &ErrorNumber="32612" &ErrorType="EMS" &ErrorSubType="WARNING"}
               END.
               ELSE DO:
                   
                   {method/svc/errors/inserr.i &ErrorNumber="1380" &ErrorType="EMS" &ErrorSubType="ERROR"}
               END.
           END.
       END.
   END.

   IF rowObject.op-codigo <> 0 AND param-global.modulo-en THEN DO:
       
       IF NOT CAN-FIND(FIRST operacao
                       WHERE operacao.op-codigo   = rowObject.op-codigo
                         AND operacao.it-codigo   = rowObject.it-codigo 
                         AND operacao.cod-roteiro = "") THEN DO:
           ASSIGN l-existe-op = NO.
           FOR EACH rot-item FIELDS(cod-roteiro)
              WHERE rot-item.it-codigo = rowObject.it-codigo NO-LOCK:

               IF CAN-FIND(FIRST operacao 
                           WHERE operacao.cod-roteiro = rot-item.cod-roteiro
                             AND operacao.op-codigo   = rowObject.op-codigo) THEN
                   ASSIGN l-existe-op = YES.
           END.
       
           IF NOT l-existe-op THEN DO:
               {method/svc/errors/inserr.i &ErrorNumber="26866" &ErrorType="EMS" &ErrorSubType="INFORMATION"}

               IF rowObject.narrativa = "" THEN DO:
                   
                   {method/svc/errors/inserr.i &ErrorNumber="1414" &ErrorType="EMS" &ErrorSubType="ERROR"}
               END.
           END.
        END.
    END.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateMainLogicManutOrdCompra DBOProgram
PROCEDURE validateCreateMainLogicManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose: Procedure com as validaá‰es de neg¢cio principais para atualizaá‰es
           de registros provenientes da Manutená∆o de ordens de compra
  Parameters: ipar1 : plNormal : Ordem normal ou m£ltipla?
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER plNormal AS LOGICAL NO-UNDO.

    IF param-global.modulo-bh AND
    CAN-FIND (FIRST his-ord-compra
              WHERE his-ord-compra.numero-ordem = rowObject.numero-ordem) THEN DO:
        
        {utp/ut-liter.i "Ordem_Compra" *}
        
        {method/svc/errors/inserr.i &ErrorNumber="4521"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.
    
    IF rowObject.numero-ordem < param-compra.prim-ord-man 
    OR rowObject.numero-ordem > param-compra.ult-ord-man THEN DO:
        
        {method/svc/errors/inserr.i &ErrorNumber="842" &ErrorType="EMS" &ErrorSubType="ERROR"}
    END.
    
    RUN validateUpdateMainLogicManutOrdCompra.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateMainLogicPedEmerg DBOProgram
PROCEDURE validateCreateMainLogicPedEmerg :
/*------------------------------------------------------------------------------
  Purpose: Procedure com as validaá‰es de neg¢cio principais para criaá∆o de
           novos registros provenientes do programa de pedidos emergenciais
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER plGeraRelItFornec    AS LOGICAL  NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-manut-item-fornec AS LOGICAL  NO-UNDO.

    ASSIGN pl-manut-item-fornec = NO.

    IF RowObject.numero-ordem = 0 THEN DO:
        
        {utp/ut-liter.i "Ordem" *}
        {method/svc/errors/inserr.i &ErrorNumber="7965" /* Ordem deve ser diferente de 0 */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    FIND FIRST his-ord-compra 
         WHERE his-ord-compra.numero-ordem = rowObject.numero-ordem NO-LOCK NO-ERROR.

    IF AVAIL his-ord-compra THEN DO:
        {utp/ut-liter.i "Ordem_Compra" *}
        {method/svc/errors/inserr.i &ErrorNumber="4521"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    FIND FIRST item
         WHERE item.it-codigo = rowObject.it-codigo NO-LOCK NO-ERROR.

    IF AVAIL item THEN DO:

       IF item.cod-obsoleto = 3 OR item.cod-obsoleto = 4 THEN DO:
           
           FOR FIRST item-uni-estab FIELDS(cod-obsoleto)
               WHERE item-uni-estab.cod-estabel = rowObject.cod-estabel
                 AND item-uni-estab.it-codigo   = item.it-codigo NO-LOCK: END.

           IF NOT AVAIL item-uni-estab THEN DO:
               
               IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorNumber = 563) THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="563" &ErrorType="EMS" &ErrorSubType="ERROR"}
               END.
           END.
           ELSE DO:

               IF item-uni-estab.cod-obsoleto = 3 OR item-uni-estab.cod-obsoleto = 4 THEN DO:
                   
                   IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorNumber = 563) THEN DO:
                   
                       {method/svc/errors/inserr.i &ErrorNumber="563" &ErrorType="EMS" &ErrorSubType="ERROR"}
                   END.
               END.
           END.
       END.

       /* Valida geraá∆o autom†tica da relaá∆o item/fornecedor */
       IF AVAILABLE item AND item.tipo-contr <> 4 THEN DO:
           
           FIND FIRST item-fornec
                WHERE item-fornec.it-codigo    = item.it-codigo
                  AND item-fornec.cod-emitente = rowObject.cod-emitente NO-LOCK NO-ERROR.

           IF NOT AVAILABLE item-fornec THEN DO:

               IF param-compra.gera-item-for = NO THEN DO:
                   
                   ASSIGN pl-manut-item-fornec = YES.
                   {method/svc/errors/inserr.i &ErrorNumber="3306" &ErrorType="EMS" &ErrorSubType="ERROR"}
               END.
               ELSE DO:
                   
                   IF NOT plGeraRelItFornec THEN DO:
                       
                       ASSIGN pl-manut-item-fornec = YES.
                       {method/svc/errors/inserr.i &ErrorNumber="3306" &ErrorType="EMS" &ErrorSubType="ERROR"}
                   END.
               END.
           END.
           ELSE DO:
               
               FIND FIRST item-fornec-estab
                    WHERE item-fornec-estab.it-codigo    = item.it-codigo
                      AND item-fornec-estab.cod-emitente = rowObject.cod-emitente
                      AND item-fornec-estab.cod-estabel  = rowObject.cod-estabel NO-LOCK NO-ERROR.
               
               IF AVAIL item-fornec-estab AND item-fornec-estab.ativo = NO AND param-compra.perm-cot-for = NO THEN DO:
                   
                   {method/svc/errors/inserr.i &ErrorNumber="3296" &ErrorType="EMS" &ErrorSubType="ERROR"}
               END.

               IF NOT AVAIL item-fornec-estab THEN DO:

                   IF AVAIL item-fornec AND item-fornec.ativo = NO AND param-compra.perm-cot-for = NO THEN DO:

                       {method/svc/errors/inserr.i &ErrorNumber="3296" &ErrorType="EMS" &ErrorSubType="ERROR"}
                   END.
               END.
           END.
           
           /* Valida opá∆o do usu†rio */
           IF plGeraRelItFornec AND AVAIL param-compra AND param-compra.gera-item-for THEN DO:

               FIND FIRST item-fornec-estab
                    WHERE item-fornec-estab.it-codigo    = item.it-codigo
                      AND item-fornec-estab.cod-emitente = rowObject.cod-emitente
                      AND item-fornec-estab.cod-estabel  = rowObject.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
               
               IF AVAILABLE item-fornec-estab THEN
                   ASSIGN item-fornec-estab.ativo = YES.

               FIND FIRST item-fornec WHERE item-fornec.it-codigo    = item.it-codigo
                                      AND   item-fornec.cod-emitente = rowObject.cod-emitente
                                      EXCLUSIVE-LOCK NO-ERROR.
               IF AVAILABLE item-fornec THEN DO:
                   /* Valida se unidade item-fornec È a mesma da cotacao: */
                   FOR EACH cotacao-item WHERE cotacao-item.numero-ordem = rowObject.numero-ordem
                                         AND   cotacao-item.it-codigo    = rowObject.it-codigo
                                         NO-LOCK:
                       IF cotacao-item.un <> item-fornec.unid-med-for THEN DO:
                           /* Verifica se Utiliza Multiplas Unidades de Medida */
                           IF param-compra.log-multi-unid-medid THEN DO:
                               FIND FIRST item-fornec-umd WHERE item-fornec-umd.it-codigo    = ITEM.it-codigo
                                                          AND   item-fornec-umd.cod-emitente = rowObject.cod-emitente
                                                          AND   item-fornec-umd.unid-med-for = cotacao-item.un NO-LOCK NO-ERROR.
                               IF AVAIL item-fornec-umd AND NOT item-fornec-umd.log-ativo THEN
                                   ASSIGN item-fornec-umd.log-ativo = YES.
                               IF NOT AVAIL item-fornec-umd THEN DO:
                                   FIND FIRST pedido-compr WHERE pedido-compr.num-pedido = rowObject.num-pedido
                                                           NO-LOCK NO-ERROR.
                                   IF AVAIL pedido-compr THEN DO:
                                       IF  NOT VALID-HANDLE(h-boin841) THEN
                                           RUN inbo/boin841.p PERSISTENT SET h-boin841.
                                       RUN openQueryStatic IN h-boin841("main":U).
                                       RUN emptyRowErrors  IN h-boin841.

                                       EMPTY TEMP-TABLE tt-item-fornec-umd.
                                       CREATE tt-item-fornec-umd.
                                       ASSIGN tt-item-fornec-umd.it-codigo    = item.it-codigo
                                              tt-item-fornec-umd.cod-emitente = rowObject.cod-emitente
                                              tt-item-fornec-umd.unid-med-for = cotacao-item.un
                                              tt-item-fornec-umd.fator-conver = 1
                                              tt-item-fornec-umd.num-casa-dec = 0
                                              tt-item-fornec-umd.lote-mul-for = 1
                                              tt-item-fornec-umd.lote-minimo  = 0
                                              tt-item-fornec-umd.log-ativo    = YES.
                                       RUN setExecCC0106 IN h-boin841.
                                       RUN setRecord IN h-boin841(INPUT TABLE tt-item-fornec-umd).
                                       RUN createRecord IN h-boin841.
                                       RUN getRowErrors IN h-boin841 (OUTPUT TABLE RowErrorsAux APPEND).
                                   
                                       IF VALID-HANDLE(h-boin841) THEN DO:
                                           DELETE PROCEDURE h-boin841.
                                           ASSIGN h-boin841 = ?.
                                       END.
                                   END.
                               END.
                           END.
                       END.
                       ELSE
                           IF NOT item-fornec.ativo THEN
                               ASSIGN item-fornec.ativo = YES.
                   END.
               END.
               ELSE
                   IF AVAIL item AND AVAIL rowObject THEN DO:
                       FOR FIRST pedido-compr
                           WHERE pedido-compr.num-pedido = rowObject.num-pedido NO-LOCK: END.
                        
                        IF AVAIL pedido-compr THEN DO:

                            EMPTY TEMP-TABLE tt-item-fornec.
                            
                            CREATE tt-item-fornec.
                            ASSIGN tt-item-fornec.it-codigo           = item.it-codigo
                                   tt-item-fornec.cod-emitente        = rowObject.cod-emitente
                                   tt-item-fornec.item-do-forn        = item.it-codigo
                                   tt-item-fornec.unid-med-for        = item.un
                                   tt-item-fornec.fator-conver        = 1
                                   tt-item-fornec.num-casa-dec        = 0
                                   tt-item-fornec.ativo               = YES
                                   tt-item-fornec.cod-cond-pag        = pedido-compr.cod-cond-pag /* emitente.cod-cond-pag */
                                   tt-item-fornec.classe-repro        = 3
                                   tt-item-fornec.aval-insp           = 5
                                   tt-item-fornec.idi-tributac-pis    = 2    /* Tributacao PIS Isento    */
                                   tt-item-fornec.idi-tributac-cofins = 2.   /* Tributacao COFINS Isento */

                            /* necess†rio chamar essa BO para geraá∆o do Log Multiplanta */
                            RUN inbo/boin178.p PERSISTENT SET h-boin178.

                            RUN openQueryStatic IN h-boin178 ("Main").
                            RUN setRecord       IN h-boin178 (INPUT TABLE tt-item-fornec).
                            RUN emptyRowErrors  IN h-boin178.
                            RUN createRecord    IN h-boin178.
                            RUN getRowErrors    IN h-boin178 (OUTPUT TABLE RowErrors APPEND).

                            DELETE PROCEDURE h-boin178.
                            ASSIGN h-boin178 = ?.
                        END.
                   END.
           END.
       END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateManutOrdCompra DBOProgram
PROCEDURE validateCreateManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose: Valida criaá∆o da tabela/duplicidade de registros provenientes da
           manutená∆o de ordens de compra.
  Parameters: ipar1 : table for rowObject : Tabela de dados
              ipar2 : plNormal            : Ordem normal ou m£ltipla?
              opar3 : table for rowErrors : Temp-table de erro
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE    FOR RowObject.
    DEFINE INPUT  PARAMETER plNormal AS LOGICAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE    FOR RowErrors.

    DEFINE VARIABLE iOrdem AS INTEGER NO-UNDO.

    DEFINE VARIABLE h-ccOrdemCompraValidaIntegraMe AS HANDLE NO-UNDO.
    DEFINE VARIABLE l-ordem-integrada-me           AS LOGICAL NO-UNDO.

    FIND FIRST rowObject NO-LOCK NO-ERROR.

    RUN emptyRowErrors IN THIS-PROCEDURE.
        
    //Valida OC integrada com o Mercado Eletronico
    IF NOT VALID-HANDLE(h-ccOrdemCompraValidaIntegraMe) THEN
        RUN ccp/ccOrdemCompraValidaIntegraMe.p PERSISTENT SET h-ccOrdemCompraValidaIntegraMe.
               
    RUN verifica-ordem-compra IN h-ccOrdemCompraValidaIntegraMe (INPUT  RowObject.numero-ordem,
                                                                 OUTPUT l-ordem-integrada-me).

    IF VALID-HANDLE(h-ccOrdemCompraValidaIntegraMe) THEN DO:
        DELETE PROCEDURE h-ccOrdemCompraValidaIntegraMe.
        ASSIGN h-ccOrdemCompraValidaIntegraMe = ?.
    END.                                                             
                                                                     
    IF l-ordem-integrada-me THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="58000"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters= RowObject.numero-ordem}
        RETURN "NOK":U.   
    END.
    
    //Fim valida OC integrada com ME

    RUN validateFieldsMainLogicManutOrdCompra.

    RUN validateCreateMainLogicManutOrdCompra (INPUT plNormal).

    IF CAN-FIND(FIRST ordem-compra
                WHERE ordem-compra.numero-ordem = rowObject.numero-ordem) THEN DO:
        
        {utp/ut-liter.i "Ordem_Compra" *}
        {method/svc/errors/inserr.i &ErrorNumber="35818"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE) + ' ' + string(rowObject.numero-ordem)"}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateNumOrdem DBOProgram
PROCEDURE validateCreateNumOrdem :
/*------------------------------------------------------------------------------
  Purpose: Valida duplicidade de registros de ordens
  Parameters: ipar1 : pi-num-ordem-atual  : traz n£mero da ordem a ser criada
              opar2 : pi-num-ordem-new    : retorna n£mero da ordem dispon°vel para sugerir
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-num-ordem-atual  LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-num-ordem-new    LIKE ordem-compra.numero-ordem NO-UNDO.

    IF CAN-FIND(FIRST ordem-compra
                WHERE ordem-compra.numero-ordem = pi-num-ordem-atual) THEN DO:
        
        {utp/ut-liter.i "Ordem_Compra" *}
        {method/svc/errors/inserr.i &ErrorNumber="35818"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE) + ' ' + string(pi-num-ordem-atual)"}

       RUN inbo/boin274sd.p PERSISTENT SET h-boin274sd.
       RUN geraNumeroOrdemPedEmerg IN h-boin274sd (OUTPUT pi-num-ordem-new, OUTPUT TABLE RowErrorsAux).

       DELETE PROCEDURE h-boin274sd.
       ASSIGN h-boin274sd = ?.
    END.

    RETURN (IF NOT (CAN-FIND (FIRST RowErrors)) THEN "OK":U ELSE "NOK":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreatePedEmerg DBOProgram
PROCEDURE validateCreatePedEmerg :
/*------------------------------------------------------------------------------
  Purpose: Valida criaá∆o da tabela/duplicidade de registros provenientes
           do programa de Pedidos Emergenciais
  Parameters: ipar1 : table for rowObject  : Tabela de dados
              ipar2 : plGeraRelItFornec    : gera item X fornec?
              opar3 : pl-manut-item-fornec : chama o cc0105?
              opar4 : table for RowErrors  : Temp-table de controle de erros
              opar5 : pi-num-ordem         : retorna n£mero da ordem a ser criada
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE                FOR RowObject.
    DEFINE INPUT  PARAMETER plGeraRelItFornec    AS   LOGICAL                   NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-manut-item-fornec AS   LOGICAL                   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE                FOR RowErrors.
    DEFINE OUTPUT PARAMETER pi-num-ordem         LIKE ordem-compra.numero-ordem NO-UNDO.

    DEFINE VARIABLE l-achou AS LOGICAL NO-UNDO.

    DEFINE VARIABLE h-ccOrdemCompraValidaIntegraMe AS HANDLE NO-UNDO.
    DEFINE VARIABLE l-ordem-integrada-me           AS LOGICAL NO-UNDO.

    FIND FIRST RowObject    NO-ERROR.
    
    RUN emptyRowErrors IN THIS-PROCEDURE.
    
    //Valida OC integrada com o Mercado Eletronico
    IF NOT VALID-HANDLE(h-ccOrdemCompraValidaIntegraMe) THEN
        RUN ccp/ccOrdemCompraValidaIntegraMe.p PERSISTENT SET h-ccOrdemCompraValidaIntegraMe.
               
    RUN verifica-ordem-compra IN h-ccOrdemCompraValidaIntegraMe (INPUT  RowObject.numero-ordem,
                                                                 OUTPUT l-ordem-integrada-me).

    IF VALID-HANDLE(h-ccOrdemCompraValidaIntegraMe) THEN DO:
        DELETE PROCEDURE h-ccOrdemCompraValidaIntegraMe.
        ASSIGN h-ccOrdemCompraValidaIntegraMe = ?.
    END.                                                             
                                                                     
    IF l-ordem-integrada-me THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="58000"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters= RowObject.numero-ordem}
        RETURN "NOK":U.   
    END.
    
    //Fim valida OC integrada com ME
        
    IF param-global.modulo-in AND rowobject.num-ord-inv <> 0 THEN DO:
        
        FIND FIRST estabelec
             WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
        
        ASSIGN iEmpresa = estabelec.ep-codigo WHEN AVAIL estabelec.
        
        RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.
        RUN validaSituacaoProjInvestimento IN h-boiv028 (INPUT iEmpresa, INPUT rowobject.num-ord-inv, INPUT "ADD":U ).
        RUN getRowErrors                   IN h-boiv028 (OUTPUT TABLE RowErrors).

        DELETE PROCEDURE h-boiv028.
        ASSIGN h-boiv028 = ?.
  END.
  run validateFieldsMainLogicPedEmerg.

  /* VALIDAÄ«O DO PROGRAMA CC0300 PARA CONTROLAR SEGURANÄA POR USUµRIO PARA PEDIDO DE COMPRA */
  IF l-seg-cc0300 = YES THEN DO:
      RUN validateSegCC0300 (INPUT 1, INPUT rowobject.num-pedido).
  END.

  RUN validateCreateMainLogicPedEmerg (INPUT plGeraRelItFornec, OUTPUT pl-manut-item-fornec).

  RUN validateCreateNumOrdem (INPUT rowObject.numero-ordem, OUTPUT pi-num-ordem).

  FOR EACH tt-epc WHERE tt-epc.cod-event = "validateCreatePedEmerg":U:
      DELETE tt-epc.
  END.

  {include/i-epc200.i2 &CodEvent='"validateCreatePedEmerg"'
                       &CodParameter='"OBJECT-HANDLE"'
                       &ValueParameter="string(this-procedure)"}
                       
  {include/i-epc200.i2 &CodEvent='"validateCreatePedEmerg"'
                       &CodParameter='"i-num-ordem"'
                       &ValueParameter="string(pi-num-ordem)"}
                       
  
  {include/i-epc201.i "validateCreatePedEmerg"}
  IF  RETURN-VALUE = "NOK":U THEN DO:
      RETURN "NOK":U.
  END.
  
  RETURN (IF NOT (CAN-FIND (FIRST RowErrors)) THEN "OK":U ELSE "NOK":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldsMainLogicManutOrdCompra DBOProgram
PROCEDURE validateFieldsMainLogicManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose: Validaá‰es de neg¢cio (modificaá∆o e criaá∆o) para registros
           provenientes da Manutená∆o de ordens de compra
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF NOT AVAIL param-global THEN FIND FIRST param-global NO-LOCK NO-ERROR.
    IF NOT AVAIL param-compra THEN FIND FIRST param-compra NO-LOCK NO-ERROR.
    
    IF RowObject.numero-ordem = 0 THEN DO:
        
        {utp/ut-liter.i "Ordem" *}
        {method/svc/errors/inserr.i &ErrorNumber="7965" /* Ordem deve ser diferente de 0 */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = rowObject.cod-estabel NO-LOCK NO-ERROR.

    IF NOT AVAIL estabelec THEN DO:
        
        {utp/ut-liter.i "Estabelecimento" *}
        {method/svc/errors/inserr.i &ErrorNumber="47"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    FIND FIRST deposito
         WHERE deposito.cod-depos = rowObject.dep-almoxar NO-LOCK NO-ERROR.

    IF NOT AVAIL deposito THEN DO:
        
        {utp/ut-liter.i "Dep¢sito" *}
        {method/svc/errors/inserr.i &ErrorNumber="47"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    FIND FIRST item
         WHERE item.it-codigo = rowObject.it-codigo NO-LOCK NO-ERROR.

    IF NOT AVAIL item THEN DO:
        
        {utp/ut-liter.i "Item" *}
        {method/svc/errors/inserr.i &ErrorNumber="47"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.
    ELSE DO:
        
        IF item.cod-obsoleto = 3 OR item.cod-obsoleto = 4 THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="1568" &ErrorType="EMS" &ErrorSubType="ERROR"}
        END.

        IF item.fraciona = NO AND rowObject.qt-solic - INTEGER(rowObject.qt-solic) > 0 THEN DO:
            
            {method/svc/errors/inserr.i &ErrorNumber="847" &ErrorType="EMS" &ErrorSubType="ERROR"}
        END.

        FOR FIRST item-mat FIELDS(it-codigo log-1)
            WHERE item-mat.it-codigo = item.it-codigo NO-LOCK: END.

        IF AVAIL item-mat AND item-mat.log-1 = YES AND item.it-codigo <> "" AND rowObject.narrativa = "" THEN DO:
            
            {method/svc/errors/inserr.i &ErrorNumber="1414" &ErrorType="EMS" &ErrorSubType="ERROR"}
        END.

        IF item.it-codigo = "" AND rowObject.narrativa = "" THEN DO:
            
            {method/svc/errors/inserr.i &ErrorNumber="1414" &ErrorType="EMS" &ErrorSubType="ERROR"}
        END.
    END.

    IF rowObject.nr-contrato <> 0 THEN DO:
        
        FIND FIRST contrato-for
             WHERE contrato-for.nr-contrato = rowObject.nr-contrato NO-LOCK NO-ERROR.
         
        IF NOT AVAIL contrato-for THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="15522" &ErrorType="EMS" &ErrorSubType="ERROR"}
        END.
         
        FIND FIRST item-contrat
             WHERE item-contrat.nr-contrato  = contrato-for.nr-contrato
               AND item-contrat.num-seq-item = rowObject.num-seq-item NO-LOCK NO-ERROR.
         
        IF NOT AVAIL item-contrat THEN DO:
            
            {method/svc/errors/inserr.i &ErrorNumber="15520" &ErrorType="EMS" &ErrorSubType="ERROR"}
        END.
        ELSE DO:
            
            IF item-contrat.ind-tipo-control = 3 THEN DO:
                
                {method/svc/errors/inserr.i &ErrorNumber="15519" &ErrorType="EMS" &ErrorSubType="ERROR"}
            END.
             
            IF item-contrat.ind-sit-item <> 2 THEN DO:
                
                {method/svc/errors/inserr.i &ErrorNumber="15896" &ErrorType="EMS" &ErrorSubType="ERROR"}
            END.

            IF NOT item-contrat.log-libera THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="7838" &ErrorType="EMS" &ErrorSubType="ERROR"}
            END.
        END.
    END. /* rowObject.nr-contrato <> 0 */

    FIND FIRST requisitante
         WHERE requisitante.nome-abrev = rowObject.requisitante NO-LOCK NO-ERROR.

    IF NOT AVAIL requisitante THEN DO:
        
        {utp/ut-liter.i "Requisitante" *}
        {method/svc/errors/inserr.i &ErrorNumber="47"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    FIND FIRST comprador
         WHERE comprador.cod-comprado = rowObject.cod-comprado NO-LOCK NO-ERROR.

    IF NOT AVAIL comprador THEN DO:
        
        {method/svc/errors/inserr.i &ErrorNumber="5936" &ErrorType="EMS" &ErrorSubType="ERROR"}
    END.

    RUN validateComumOC-OCdePedido.

    /* -----  Tratamento para Contratos: qdo. nao informada conta de aplicacao, assume a matriz de rateio do item. ------------*/
    ASSIGN lConsiste  = YES.

    IF param-global.modulo-cn AND RowObject.nr-contrato <> 0 AND AVAIL item THEN DO:
        
        IF item.tipo-contr = 4 THEN DO:
            
            ASSIGN lConsiste = NO
                   lErroCo   = NO.
            
            RUN verificaMatrizRateioOrdemCompra.

            IF lErroCo THEN DO:
                IF rowObject.ct-codigo = "" OR rowObject.ct-codigo = "0" THEN DO:
                    
                    {utp/ut-liter.i "Conta_cont†bil" *}
                    {method/svc/errors/inserr.i &ErrorNumber="158"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="TRIM(RETURN-VALUE)"}
                END.

                IF rowObject.ct-codigo <> "0":U AND rowObject.ct-codigo <> "" THEN DO:
                    
                    {method/svc/errors/inserr.i &ErrorNumber="17715" &ErrorType="EMS" &ErrorSubType="ERROR"}
                END.
            END.

            IF lErroCo = NO THEN
                IF rowObject.ct-codigo = "" OR rowObject.ct-codigo = "0":U THEN DO:
                    
                    {method/svc/errors/inserr.i &ErrorNumber="15221" &ErrorType="EMS" &ErrorSubType="ERROR"}
                END.

            IF lErroCo = ?  THEN ASSIGN lConsiste = YES.
        END.
        ELSE
            ASSIGN lConsiste = YES.
    END.

    FIND FIRST tipo-rec-desp
         WHERE tipo-rec-desp.tp-codigo = rowObject.tp-despesa  NO-LOCK NO-ERROR.

    IF NOT AVAIL tipo-rec-desp THEN DO:
        
        {utp/ut-liter.i "Tipos_de_Receita/Despesa" *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
     END.
     ELSE DO:
         IF tipo-rec-desp.tipo = 1 THEN DO:
             
             {method/svc/errors/inserr.i &ErrorNumber="146" &ErrorType="EMS" &ErrorSubType="ERROR"}
         END.
     END.

     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldsMainLogicPedEmerg DBOProgram
PROCEDURE validateFieldsMainLogicPedEmerg :
/*------------------------------------------------------------------------------
  Purpose: Validaá‰es de neg¢cio tanto para inclus∆o de ordens quanto para
           modificaá∆o de registros provenientes do programa de pedidos
           emergenciais
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    /* Validaá∆o do movimento X conta cont†bil de investimento */
    IF rowObject.ct-codigo <> "" AND param-global.modulo-in THEN DO:
        
        {inp/inapi060.i rowObject.cod-estabel rowObject.ct-codigo rowObject.sc-codigo rowObject.num-ord-inv NO tt-erro}

        /* conforme help dp IN0101 para ordem de producao/MI n„o deve ser validado a conta */
        IF  rowObject.num-ord-inv  <> 0
        AND rowObject.ordem-servic <> 0 THEN DO:

            FIND FIRST tt-erro
                WHERE tt-erro.cd-erro = 28723
                    OR tt-erro.cd-erro = 28722 NO-ERROR.
            IF AVAIL tt-erro THEN
                DELETE tt-erro.
        END.            

        IF RETURN-VALUE = "NOK":U THEN DO:
            
            FIND FIRST tt-erro NO-ERROR.
            IF AVAIL tt-erro THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="tt-erro.c-param"}
            END.
        END.
    END.
    
    IF NOT CAN-FIND(FIRST estabelec
                    WHERE estabelec.cod-estabel = rowObject.cod-estabel) THEN DO:
        
        {utp/ut-liter.i "Estabelecimento" *}
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    /* Alteraá∆o realizada pois quando o cliente trabalha com multiplanta,  */
    /* n∆o se faz obrigat¢rio o relacionamento do item com o estabelecimento*/
    IF NOT AVAIL param-global THEN FIND FIRST param-global NO-LOCK NO-ERROR.
    
    IF param-global.modulo-mp = NO THEN DO: /*multiplanta*/

        IF NOT CAN-FIND(FIRST item-uni-estab
                        WHERE item-uni-estab.it-codigo   = rowObject.it-codigo
                          AND item-uni-estab.cod-estabel = rowObject.cod-estabel) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="25904"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="RowObject.it-codigo + '~~~~' + RowObject.cod-estabel"}
        END.
    END.

    FOR FIRST requisitante FIELDS(nome-abrev)
        WHERE requisitante.nome-abrev = rowObject.requisitante NO-LOCK: END.

    IF NOT AVAIL requisitante THEN DO:

        {utp/ut-liter.i "Requisitante" *}
        {method/svc/errors/inserr.i &ErrorNumber="47"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    FOR FIRST comprador FIELDS(cod-comprado)
        WHERE comprador.cod-comprado = rowObject.cod-comprado NO-LOCK: END.

    IF NOT AVAIL comprador THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="5936" &ErrorType="EMS" &ErrorSubType="ERROR"}
    END.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = rowObject.cod-estabel NO-ERROR.

    ASSIGN iEmpresa = estabelec.ep-codigo WHEN AVAIL estabelec.

    FOR FIRST item FIELDS(it-codigo tipo-contr)
        WHERE item.it-codigo = rowObject.it-codigo NO-LOCK: END.

    /* Validaá∆o do Item */
    IF NOT AVAILABLE item THEN DO: /* erros 7 ou 56 */
        
        {utp/ut-liter.i "Item" *}
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.
    ELSE DO:
        /*Validaá∆o da Narrativa*/
        FIND FIRST item-mat WHERE item-mat.it-codigo = item.it-codigo NO-LOCK NO-ERROR.
        
        IF AVAIL item-mat AND item-mat.log-1 AND rowObject.it-codigo <> "" AND trim(rowObject.narrativa) = "" THEN DO:
            
            {utp/ut-liter.i "Narrativa" *}
            {method/svc/errors/inserr.i &ErrorNumber="164"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        IF item.tipo-contr = 4 AND rowObject.it-codigo = "" AND TRIM(rowObject.narrativa) = "" THEN DO:
            
            {utp/ut-liter.i "Narrativa" *}
            {method/svc/errors/inserr.i &ErrorNumber="164"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        /* validaá∆o conta */
        IF (item.tipo-contr = 1 OR item.tipo-contr = 4) 
        OR  rowObject.ct-codigo <> "":U 
        OR  rowObject.sc-codigo <> "":U
        OR  rowObject.ordem-servic > 0 THEN DO:
            
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = rowobject.cod-estabel NO-ERROR.

            ASSIGN iEmpresa = estabelec.ep-codigo WHEN AVAIL estabelec.

            RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

            ASSIGN c-ct-codigo = rowObject.ct-codigo.

            RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        iEmpresa,                   /* EMPRESA EMS2 */
                                                           INPUT        "",                         /* PLANO DE CONTAS */
                                                           INPUT-OUTPUT c-ct-codigo,                /* CONTA */
                                                           INPUT        rowObject.data-atualiz,     /* DATA TRANSACAO */
                                                           OUTPUT       v_des_cta_ctbl,             /* DESCRICAO CONTA */
                                                           OUTPUT       v_num_tip_cta_ctbl,         /* TIPO DA CONTA */
                                                           OUTPUT       v_num_sit_cta_ctbl,         /* SITUAÄ«O DA CONTA */
                                                           OUTPUT       v_ind_finalid_cta,          /* FINALIDADES DA CONTA */
                                                           OUTPUT TABLE tt_log_erro).               /* ERROS */
            IF VALID-HANDLE(h_api_cta_ctbl) THEN
                DELETE OBJECT h_api_cta_ctbl.

            FOR EACH tt_log_erro NO-LOCK:

                {utp/ut-liter.i "C¢digo Erro Financeiro: "}
                ASSIGN cErroAux = RETURN-VALUE + CHR(01) + STRING(tt_log_erro.ttv_num_cod_erro).

                {method/svc/errors/inserr.i &ErrorNumber="52046"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters= "tt_log_erro.ttv_des_msg_erro + '~~~~' + tt_log_erro.ttv_des_msg_ajuda + '~~~~' + cErroAux"}
            END.

            IF INT(v_num_sit_cta_ctbl) <> 3 THEN DO:
                
                {utp/ut-liter.i "Conta" *}
                {method/svc/errors/inserr.i &ErrorNumber="3297"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.

            /* Verifica Estoque */
            ASSIGN ind       = 1
                   i-estoque = 0.

            DO WHILE ind <= 10:

                ASSIGN v_cod_finalid = {adinc/i05ad049.i 4 ind}.

                IF LOOKUP(v_cod_finalid, v_ind_finalid_cta) > 0 THEN DO:
                    ASSIGN i-estoque = ind.
                    LEAVE.
                END.

                ASSIGN ind = ind + 1.
            END.

            IF i-estoque = 0
            OR (i-estoque <> 1 AND i-estoque <> 2 AND i-estoque <> 3 AND i-estoque <> 5 AND i-estoque <> 6) THEN DO:
                
                {utp/ut-liter.i "Conta" *}
                {method/svc/errors/inserr.i &ErrorNumber="3298"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.

            RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

            IF RowObject.sc-codigo = "" THEN DO:
                
                RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT iEmpresa,
                                                                   INPUT RowObject.cod-estabel,
                                                                   INPUT "",
                                                                   INPUT c-ct-codigo,
                                                                   INPUT TODAY,
                                                                   OUTPUT l-utiliza-ccusto,
                                                                   OUTPUT TABLE tt_log_erro).
                IF CAN-FIND(tt_log_erro) THEN DO:

                    FOR EACH tt_log_erro NO-LOCK:

                        {utp/ut-liter.i "C¢digo Erro Financeiro: "}
                        ASSIGN cErroAux = RETURN-VALUE + CHR(01) + STRING(tt_log_erro.ttv_num_cod_erro).

                        {method/svc/errors/inserr.i &ErrorNumber="52046"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters= "tt_log_erro.ttv_des_msg_erro + '~~~~' + tt_log_erro.ttv_des_msg_ajuda + '~~~~' + cErroAux"}
                    END.
                END.
                ELSE DO:

                    IF l-utiliza-ccusto THEN DO:

                        {utp/ut-liter.i "Centro de Custo"}
                        {method/svc/errors/inserr.i &ErrorNumber="688"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="return-value"}
                    END.
                END.
            END.
            ELSE DO:

                RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT iEmpresa,
                                                           INPUT "",
                                                           INPUT RowObject.sc-codigo,
                                                           INPUT TODAY,
                                                           OUTPUT v_des_ccusto,
                                                           OUTPUT TABLE tt_log_erro).
                IF CAN-FIND(tt_log_erro) THEN DO:

                    FOR EACH tt_log_erro NO-LOCK:

                        {utp/ut-liter.i "C¢digo Erro Financeiro: "}
                        ASSIGN cErroAux = RETURN-VALUE + CHR(01) + STRING(tt_log_erro.ttv_num_cod_erro).

                        {method/svc/errors/inserr.i &ErrorNumber="52046"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters= "tt_log_erro.ttv_des_msg_erro + '~~~~' + tt_log_erro.ttv_des_msg_ajuda + '~~~~' + cErroAux"}
                    END.
                END.
            END.
            IF VALID-HANDLE(h_api_ccusto) THEN
                DELETE OBJECT h_api_ccusto.
        END. /* validaá∆o conta */

        /* Reposiona no pedido-compr para retirar a cl†usula fields(). O pedido posicionado anteriormente possuia a clausula fields(). */
        FOR FIRST pedido-compr NO-LOCK
            WHERE pedido-compr.num-pedido = rowObject.num-pedido: 

            FOR FIRST item-uni-estab FIELDS(cod-estabel it-codigo cod-obsoleto)
                WHERE item-uni-estab.cod-estabel = pedido-compr.end-entrega
                  AND item-uni-estab.it-codigo   = item.it-codigo NO-LOCK: 
                
                IF (item-uni-estab.cod-obsoleto = 3 or item-uni-estab.cod-obsoleto = 4) THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="563" &ErrorType="EMS" &ErrorSubType="ERROR"}
                END.
            END.
        END.
    END. /* Avail item */

    FOR FIRST tipo-rec-desp NO-LOCK
        WHERE tipo-rec-desp.tp-codigo = rowObject.tp-despesa: END.

    IF NOT AVAILABLE tipo-rec-desp THEN DO:
        
        {method/svc/errors/inserr.i &ErrorNumber="3299" &ErrorType="EMS" &ErrorSubType="ERROR"}
    END.
    ELSE DO:
        
        IF tipo-rec-desp.tipo = 1 THEN DO:
            
            {method/svc/errors/inserr.i &ErrorNumber="3300" &ErrorType="EMS" &ErrorSubType="ERROR"}
        END.
    END.

    /* integracao Investimento x MMI */
    IF NOT l-min-mmi THEN DO:

        IF rowObject.ordem-servic <> 0 AND rowObject.num-ord-inv <> 0 AND param-global.modulo-in THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="26543" &ErrorType="EMS" &ErrorSubType="ERROR"}
        END.
    END.

    RUN validateComumOC-OCdePedido.

    IF NOT CAN-FIND(FIRST deposito
                    WHERE deposito.cod-depos = rowObject.dep-almoxar) THEN DO:

        {utp/ut-liter.i "Dep¢sito" *}
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    /***********************UNIDADE DE NEG‡CIO************************/
    /*ParÉmetro de materiais - UTILIZA UN*/
    IF  l-mat-unid-negoc THEN DO:

        ASSIGN l-unid-negoc-mi = NO.

        FOR FIRST ord-prod FIELDS(nr-ord-produ origem)
            WHERE ord-prod.nr-ord-produ = RowObject.ordem-servic NO-LOCK:
        END.

        EMPTY TEMP-TABLE tt-matriz-om.
        
        IF RowObject.ordem-servic > 0 AND AVAIL ord-prod AND l-unidade-negocio THEN DO:
            
            IF ord-prod.origem = "MI":U AND /* Manutená∆o Industrial */
            CAN-FIND(FIRST unid-negoc-om
                     WHERE unid-negoc-om.num-ord-manut =  ord-prod.nr-ord-produ NO-LOCK) THEN DO:

                    ASSIGN l-unid-negoc-mi = YES.

                    IF  NOT VALID-HANDLE(h-bomn250) THEN
                        RUN mnbo/bomn250.p PERSISTENT SET h-bomn250.

                RUN criattMatrizUnidNegoc IN h-bomn250 (INPUT RowObject.ordem-servic, OUTPUT TABLE tt-matriz-om).
            END.
            ELSE DO:
                
                IF ord-prod.origem = "MV":U THEN DO: /* FROTAS */

                    IF NOT VALID-HANDLE(hMMVUnidNegoc) THEN
                        RUN frbo/bofr134.p PERSISTENT SET hMmvUnidNegoc.

                    RUN canFindMatrizMMV IN hMMVUnidNegoc (INPUT RowObject.ordem-servic).

                    IF RETURN-VALUE = "OK":U THEN
                        ASSIGN l-unid-negoc-mi = YES.

                    RUN criattMatrizUnidNegoc IN hMMVUnidNegoc (INPUT RowObject.ordem-servic, OUTPUT TABLE tt-matriz-om).

                    DELETE OBJECT hMMVUnidNegoc.
                END.
            END.

            FOR FIRST tt-matriz-om NO-LOCK: END.

            IF NOT VALID-HANDLE(h-cdapi024) THEN
                RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.

            FOR EACH tt-matriz-om NO-LOCK:

                RUN ValidaUnidadeNegocioEstabel IN h-cdapi024 (INPUT RowObject.cod-estabel,
                                                               INPUT TODAY,
                                                               INPUT tt-matriz-om.cod-unid-negoc,
                                                               OUTPUT table tt-erro-aux).
                FOR EACH tt-erro-aux:

                    RUN _insertErrorManual IN THIS-PROCEDURE (INPUT tt-erro-aux.cd-erro,
                                                              INPUT "EMS":U,
                                                              INPUT "Error":U,
                                                              INPUT tt-erro-aux.mensagem,
                                                              INPUT "",
                                                              INPUT "").
                END.

                EMPTY TEMP-TABLE tt-erro-aux.

                RUN ValidaUnidadeNegocioUsuario IN h-cdapi024 (INPUT RowObject.requisitante,
                                                               INPUT tt-matriz-om.cod-unid-negoc,
                                                               OUTPUT TABLE tt-erro-aux).
                FOR EACH tt-erro-aux:

                    RUN _insertErrorManual IN THIS-PROCEDURE (INPUT tt-erro-aux.cd-erro,
                                                              INPUT "EMS":U,
                                                              INPUT "Error":U,
                                                              INPUT tt-erro-aux.mensagem,
                                                              INPUT "",
                                                              INPUT "").
                END.
            END.

            FOR EACH unid-neg-ordem
               WHERE unid-neg-ordem.numero-ordem = RowObject.numero-ordem EXCLUSIVE-LOCK:
                DELETE unid-neg-ordem.
            END.

            FOR EACH tt-matriz-om:

                CREATE unid-neg-ordem.
                ASSIGN unid-neg-ordem.cod_unid_negoc  = tt-matriz-om.cod-unid-negoc
                       unid-neg-ordem.numero-ordem  = RowObject.numero-ordem
                       unid-neg-ordem.perc-unid-neg = tt-matriz-om.val-perc-unid-negoc.
            END.

            IF VALID-HANDLE(h-cdapi024) THEN
                RUN pi-finalizar IN h-cdapi024.

            IF VALID-HANDLE(h-bomn250) THEN
                DELETE PROCEDURE h-bomn250.

            IF CAN-FIND(FIRST unid-neg-ordem
                        WHERE unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem NO-LOCK) THEN
                ASSIGN RowObject.cod-unid-negoc = "".
        END.

        IF l-unid-negoc-mi = NO THEN DO:

            IF  RowObject.num-ord-inv <> 0 AND param-global.modulo-in THEN DO:

                RUN ivbo/boiv029.p PERSISTENT SET h-boiv029.

                RUN recebeEmpresa          IN h-boiv029 (INPUT estabelec.ep-codigo).
                RUN retornaMatrizUnidNegoc IN h-boiv029 (INPUT RowObject.num-ord-inv,
                                                         OUTPUT TABLE tt-matriz,
                                                         OUTPUT TABLE tt-erro-aux).
                DELETE PROCEDURE h-boiv029.

                FIND FIRST tt-erro-aux NO-LOCK NO-ERROR.

                IF  AVAIL tt-erro-aux THEN DO:

                    FOR EACH tt-erro-aux:

                        ASSIGN i-seq-erro = i-seq-erro + 10.

                        CREATE RowErrors.
                        ASSIGN RowErrors.ErrorSequence    = i-seq-erro
                               RowErrors.ErrorNumber      = tt-erro-aux.cd-erro
                               RowErrors.ErrorParameters  = ""
                               RowErrors.ErrorType        = ""
                               RowErrors.ErrorSubType     = "ERROR":U
                               RowErrors.ErrorDescription = tt-erro-aux.mensagem
                               RowErrors.ErrorHelp        = tt-erro-aux.mensagem.
                    END.
                END.
                ELSE DO:

                    FOR EACH unid-neg-ordem EXCLUSIVE-LOCK
                       WHERE unid-neg-ordem.numero-ordem = RowObject.numero-ordem:
                        DELETE unid-neg-ordem.
                    END.

                    FOR EACH tt-matriz:

                        FIND FIRST unid-neg-ordem EXCLUSIVE-LOCK
                             WHERE unid-neg-ordem.numero-ordem = RowObject.numero-ordem
                               AND unid-neg-ordem.cod_unid_negoc = tt-matriz.cod-unid-neg NO-ERROR.

                        IF NOT AVAIL unid-neg-ordem THEN DO:

                            CREATE unid-neg-ordem.
                            ASSIGN unid-neg-ordem.cod_unid_negoc = tt-matriz.cod-unid-neg
                                   unid-neg-ordem.numero-ordem = RowObject.numero-ordem.
                        END.
                        ASSIGN unid-neg-ordem.perc-unid-neg = tt-matriz.perc-rateio.
                    END.
                    ASSIGN RowObject.cod-unid-negoc = "".
                END.
            END.

            /* Unidade de Neg¢cio tem que ser informada */
            IF  RowObject.cod-unid-negoc = "" THEN DO:

                IF NOT CAN-FIND(FIRST unid-neg-ordem
                                WHERE unid-neg-ordem.numero-ordem = RowObject.numero-ordem NO-LOCK) THEN DO:
                    
                    {utp/ut-liter.i "Unidade_de_Neg¢cio" *}
                    {method/svc/errors/inserr.i &ErrorNumber="265"
                                                &ErrorType="EMS"
                                                &ErrorParameters="TRIM(RETURN-VALUE)"}
                END.
            END.
            ELSE DO:
                
                IF NOT CAN-FIND(FIRST unid-negoc
                                WHERE unid-negoc.cod-unid-negoc = RowObject.cod-unid-negoc NO-LOCK) THEN DO:

                    {utp/ut-liter.i "Unidade_de_Neg¢cio" *}
                    {method/svc/errors/inserr.i &ErrorNumber="2"
                                                &ErrorType="EMS"
                                                &ErrorParameters="TRIM(RETURN-VALUE)"}
                END.

                IF NOT VALID-HANDLE(h-cdapi024) THEN
                    RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.

                /* Valida UN x Estabelecimento */
                EMPTY TEMP-TABLE tt-erro-aux.
                RUN ValidaUnidadeNegocioEstabel IN h-cdapi024 (INPUT RowObject.cod-estabel,
                                                               INPUT RowObject.data-emissao,
                                                               INPUT RowObject.cod-unid-negoc,
                                                               OUTPUT TABLE tt-erro-aux).
                FOR EACH tt-erro-aux:

                    RUN _insertErrorManual IN THIS-PROCEDURE (INPUT tt-erro-aux.cd-erro,  /* pErrorNumber      */
                                                              INPUT "EMS":U,                /* pErrorType        */
                                                              INPUT "Error":U,              /* pErrorSubType     */
                                                              INPUT tt-erro-aux.mensagem, /* pErrorDescription */
                                                              INPUT "",                   /* pErrorHelp        */
                                                              INPUT "").                  /* pErrorParameters  */
                END.

                /* Valida UN x grupo do usu†rio */
                EMPTY TEMP-TABLE tt-erro-aux.

                RUN ValidaUnidadeNegocioUsuario IN h-cdapi024 (INPUT RowObject.requisitante,
                                                               INPUT RowObject.cod-unid-negoc,
                                                               OUTPUT TABLE tt-erro-aux).

                FOR EACH tt-erro-aux:

                    RUN _insertErrorManual IN THIS-PROCEDURE (INPUT tt-erro-aux.cd-erro,  /* pErrorNumber      */
                                                              INPUT "EMS":U,                /* pErrorType        */
                                                              INPUT "Error":U,              /* pErrorSubType     */
                                                              INPUT tt-erro-aux.mensagem, /* pErrorDescription */
                                                              INPUT "",                   /* pErrorHelp        */
                                                              INPUT "").                  /* pErrorParameters  */
                END.

                /*Valida UN x Centro de Custo*/
                EMPTY TEMP-TABLE tt_log_erro.

                IF RowObject.ct-codigo <> "" THEN DO:
                    
                    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

                    /* Valida a conta e centro de custo e verifica se o centro de custo informado pertence ao Mapa da conta */
                    RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT  iEmpresa,                 /* EMPRESA EMS2 */
                                                                    INPUT  RowObject.cod-estabel,    /* ESTABELECIMENTO EMS2 */
                                                                    INPUT  RowObject.cod-unid-negoc, /* UNIDADE NEG‡CIO */
                                                                    INPUT  "",                       /* PLANO CONTAS */
                                                                    INPUT  RowObject.ct-codigo,      /* CONTA */
                                                                    INPUT  "",                       /* PLANO CCUSTO */
                                                                    INPUT  RowObject.sc-codigo,      /* CCUSTO */
                                                                    INPUT  TODAY,                    /* DATA ATUAL */
                                                                    OUTPUT TABLE tt_log_erro).       /* ERROS */

                    IF CAN-FIND(tt_log_erro) THEN DO:

                        FOR EACH tt_log_erro NO-LOCK:

                            {utp/ut-liter.i "C¢digo Erro Financeiro: "}
                            ASSIGN cErroAux = RETURN-VALUE + CHR(01) + STRING(tt_log_erro.ttv_num_cod_erro).

                            {method/svc/errors/inserr.i &ErrorNumber="52046"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters= "tt_log_erro.ttv_des_msg_erro + '~~~~' + tt_log_erro.ttv_des_msg_ajuda + '~~~~' + cErroAux"}
                        END.
                    END.

                    DELETE PROCEDURE h_api_cta_ctbl.
                END.

                RUN pi-finalizar IN h-cdapi024.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateProcesso DBOProgram
PROCEDURE validateProcesso :
/*------------------------------------------------------------------------------
  Purpose: Valida o numero do processo e o numero da ordem,
           e retorna erro caso possua um registro inv†lido.

  Parameters: ipar1 : piProcesso : numero do processo corrente
              ipar2 : piOrdem    : numero da ordem corrente
              opar3 : rowErrors  : tabela que retorna erro
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piProcesso AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER piOrdem    AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE rRowid AS ROWID NO-UNDO.

    IF piOrdem = 0 THEN DO: /* ordem de compra n∆o pode ser zero */
      
      {utp/ut-liter.i "Ordem_de_Compra" *}
      {method/svc/errors/inserr.i &ErrorNumber="1491"
                                  &ErrorType="EMS"
                                  &ErrorParameters="' ' + TRIM(RETURN-VALUE) + ' '"}
        RETURN "NOK":U.
    END.

    /*Integraá∆o Portal Compra - Maylon*/
    IF CAN-FIND(funcao WHERE funcao.cd-funcao = "SPP-INTEGRA-PORTAL-COMPRA":U AND funcao.ativo) THEN DO:

        &IF  "{&bf_mat_versao_ems}"  <  "2.09":U  &THEN
        IF (AVAIL param-compra AND substring(param-compra.char-2,102,1) = "S":U) THEN DO:
        &ELSE
        IF (AVAIL param-compra AND param-compra.log-integr-portal) THEN DO:
        &ENDIF

            FIND FIRST ordem-compra
                 WHERE ordem-compra.numero-ordem = piOrdem NO-LOCK NO-ERROR.

            IF AVAIL ordem-compra THEN DO:

                &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                   IF substring(ordem-compra.CHAR-1,91,1) = "S":U THEN DO:
                &ELSE
                   IF ordem-compra.log-integr-portal THEN DO:
                &ENDIF
                       /*Ordem de compra j† integrada ao portal compra*/
                       {method/svc/errors/inserr.i &ErrorNumber="36678" &ErrorType="EMS" &ErrorParameters="ordem-compra.numero-ordem"}
                       RETURN "NOK":U.
                END.
            END.
        END.
    END.
    /*Integraá∆o Portal Paradigma */
    ELSE IF CAN-FIND(FIRST funcao
                     WHERE funcao.cd-funcao = "spp-portal-paradigma":U
                       AND funcao.ativo) AND NOT l-processo-paradigma THEN DO:
        
        IF &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
               (AVAIL param-compra AND substring(param-compra.char-2,102,1) = "S":U)
           &ELSE
               (AVAIL param-compra AND param-compra.log-integr-portal)
           &ENDIF
        THEN DO:

            FIND FIRST ordem-compra
                 WHERE ordem-compra.numero-ordem = piOrdem NO-LOCK NO-ERROR.

            IF AVAIL ordem-compra THEN DO:
                IF &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
                       substring(ordem-compra.char-1,193,1) = "S":U
                   &ELSE
                       ordem-compra.log-envdo-integr
                   &ENDIF
                THEN DO:
                       /*Ordem de compra j† integrada ao portal compra*/
                       {method/svc/errors/inserr.i &ErrorNumber="36678" &ErrorType="EMS" &ErrorParameters="ordem-compra.numero-ordem"}
                       RETURN "NOK":U.
                END.
            END.
        END.
    END.

    /********validaá∆o de pedido*********/
    FIND FIRST ordem-compra
         WHERE ordem-compra.numero-ordem = piOrdem NO-LOCK NO-ERROR.

    IF AVAIL ordem-compra AND ordem-compra.num-pedido <> 0 THEN DO:
        FIND FIRST pedido-compr
             WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.

        IF AVAIL pedido-compr AND pedido-compr.nr-processo <> piProcesso THEN DO:

            IF pedido-compr.nr-processo > 0 THEN DO: /* Ordem pertence πa um pedido de outro processo. */
                
                {utp/ut-liter.i "Pedido_de_Compra" *}
                {method/svc/errors/inserr.i &ErrorNumber="18267"
                                            &ErrorType="EMS"
                                            &ErrorParameters="' ' + TRIM(RETURN-VALUE) + ' '"}
                RETURN "NOK":U.
            END.
            ELSE DO:
                /* Pedido de compras n∆o pertence a nenhum processo. */
                
                {utp/ut-liter.i "Pedido_de_Compra" *}
                {method/svc/errors/inserr.i &ErrorNumber="18328"
                                            &ErrorType="EMS"
                                            &ErrorParameters="' ' + TRIM(RETURN-VALUE) + ' '"}
                RETURN "NOK":U.
            END.
        END.
    END.

    IF NOT CAN-FIND(FIRST ordem-compra
                    WHERE ordem-compra.numero-ordem = piOrdem) THEN DO: /* ordem de compra inv†lida */
        
        {method/svc/errors/inserr.i &ErrorNumber="6349" &ErrorType="EMS" &ErrorParameters="''"}
        RETURN "NOK":U.
    END.

    FOR FIRST ordem-compra FIELDS(numero-ordem nr-processo int-1)
        WHERE ordem-compra.numero-ordem = piOrdem
          AND ordem-compra.nr-processo  = 0 NO-LOCK: END.

    IF NOT AVAIL ordem-compra THEN DO: /* ordem de compra j† atribu°da a um processo */

        {utp/ut-liter.i "Ordem_Compra" *}
        {method/svc/errors/inserr.i &ErrorNumber="15086"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
        RETURN "NOK":U.
    END.
    ELSE DO:

        IF param-global.modulo-mp 
        AND (ordem-compra.num-pedido = 0 OR
             CAN-FIND(FIRST pedido-compr WHERE pedido-compr.num-pedido = ordem-compra.num-pedido AND pedido-compr.situacao = 1) ) THEN DO:
            
            RUN ccp/ccapi199.p(INPUT "Ordem-compra":U, ROWID(ordem-compra), OUTPUT l-erro).

            IF l-erro THEN DO: /*Ordem so pode ser alterada no estabelecimento gestor.*/
                
                
                {utp/ut-liter.i "Ordem_Compra" *}
                ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
                {utp/ut-liter.i "Gestor" *}
                {method/svc/errors/inserr.i &ErrorNumber="18200"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-traducao + '~~~~' + TRIM(RETURN-VALUE)"}
                RETURN "NOK":U.
            END.
        END.

        FIND CURRENT ordem-compra EXCLUSIVE-LOCK.
        ASSIGN ordem-compra.nr-processo = piProcesso.
        
        FOR EACH tt-epc WHERE tt-epc.cod-event = "afterRelacOrdemProcesso":U:
            DELETE tt-epc.
        END.

        ASSIGN rRowid = ROWID(ordem-compra).

        {include/i-epc200.i2 &CodEvent='"afterRelacOrdemProcesso"'
                             &CodParameter='"rRowid"'
                             &ValueParameter="string(rRowid)"}

        
        {include/i-epc201.i "afterRelacOrdemProcesso"}
        IF RETURN-VALUE = "NOK":U THEN DO:
            FIND CURRENT ordem-compra NO-LOCK NO-ERROR.
            RETURN "NOK":U.
        END.

        IF AVAIL param-global AND param-global.modulo-mp AND ordem-compra.cod-estab-gestor <> "" AND 
        (ordem-compra.num-pedido = 0 OR
         CAN-FIND(FIRST pedido-compr WHERE pedido-compr.num-pedido = ordem-compra.num-pedido AND pedido-compr.situacao = 1) ) THEN DO:

            RUN ccp/ccapi200.p(INPUT "Ordem-compra":U, INPUT ROWID(ordem-compra),
                               INPUT 2, INPUT-OUTPUT TABLE tt-erro-mp).
        END.

        FIND CURRENT ordem-compra NO-LOCK NO-ERROR.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram
PROCEDURE beforeCreateRecord :
    RUN ccp/ccPedidoCompraValidaIntegraMe.p PERSISTENT SET h-ccPedidoCompraValidaIntegraMe.
    
    RUN verifica-pedido-compra-me IN h-ccPedidoCompraValidaIntegraMe (INPUT RowObject.num-pedido, OUTPUT isOrderIntegrMe).
    
    IF isOrderIntegrMe THEN DO:
        {method/svc/errors/inserr.i
                          &ErrorNumber="57880"
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR"}

        RETURN "NOK":U.
    END.

    RETURN "OK":U.
    
    FINALLY:
        DELETE PROCEDURE h-ccPedidoCompraValidaIntegraMe NO-ERROR.
        ASSIGN h-ccPedidoCompraValidaIntegraMe = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram
PROCEDURE beforeDeleteRecord :

    RUN ccp/ccPedidoCompraValidaIntegraMe.p PERSISTENT SET h-ccPedidoCompraValidaIntegraMe.
    
    RUN verifica-pedido-compra-me IN h-ccPedidoCompraValidaIntegraMe (INPUT RowObject.num-pedido, OUTPUT isOrderIntegrMe).
    
    IF isOrderIntegrMe THEN DO:
        {method/svc/errors/inserr.i
                          &ErrorNumber="57882"
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR" 
                          &ErrorParameters="string({&TableName}.numero-ordem)"}

        RETURN "NOK":U.
    END.

    RETURN "OK":U.
    
    FINALLY:
        DELETE PROCEDURE h-ccPedidoCompraValidaIntegraMe NO-ERROR.
        ASSIGN h-ccPedidoCompraValidaIntegraMe = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE pi-desp-importacao-msg:
/*------------------------------------------------------------------------------
  Purpose: Acrescenta ao valor da cotaá∆o do material os valores das despesas,
           seguindo a mesma regra do cdapi171.i3
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prCotacaoItem      AS ROWID                        NO-UNDO.
    DEFINE INPUT  PARAMETER pdQtSolic          LIKE ordem-compra.qt-solic      NO-UNDO.
    DEFINE INPUT  PARAMETER piMoedaDestino     LIKE moeda.mo-codigo            NO-UNDO.
    DEFINE OUTPUT PARAMETER pdValorDocDesp     AS DECIMAL INITIAL 0            NO-UNDO.

    DEFINE VARIABLE l-importacao-msg AS LOGICAL NO-UNDO.
    DEFINE VARIABLE de-val-despesas  AS DECIMAL NO-UNDO.

    RUN pi-verifica-importacao-msg (OUTPUT l-importacao-msg).

    FIND FIRST cotacao-item
         WHERE ROWID(cotacao-item) = prCotacaoItem
         NO-LOCK NO-ERROR.

    IF l-importacao-msg AND AVAIL cotacao-item THEN DO:
        FIND FIRST emitente
             WHERE emitente.cod-emitente = cotacao-item.cod-emitente
             NO-LOCK NO-ERROR.

        IF AVAIL emitente
        AND (emitente.natureza = 3 OR emitente.natureza = 4) THEN DO:
            RUN imp/im9029.p (INPUT prCotacaoItem,
                              OUTPUT de-val-despesas).

            ASSIGN pdValorDocDesp = de-val-despesas.

            IF pdValorDocDesp = ? THEN
                ASSIGN pdValorDocDesp = (pdQtSolic * de-val-despesas).
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE pi-valida-exibe-msg-aprov-eletr:
/*------------------------------------------------------------------------------
  Purpose: Determina se deve exibir a mensagem de aprovaá∆o eletrìnica ap¢s
           a execuá∆o da cdapi171 para:
           1 - Pedido emergencial + param-aprov.aprova-emerg
           2 - Pedido normal + param-aprov.aprova-pedido
           tratando internamente Pedido Total e Pedido Item.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prOrdemCompra   AS ROWID   NO-UNDO.
    DEFINE OUTPUT PARAMETER plExibeMensagem AS LOGICAL NO-UNDO.

    ASSIGN plExibeMensagem = YES.

    FIND FIRST ordem-compra
         WHERE ROWID(ordem-compra) = prOrdemCompra
         NO-LOCK NO-ERROR.
    IF NOT AVAIL ordem-compra THEN
        RETURN.

    FIND FIRST pedido-compr
         WHERE pedido-compr.num-pedido = ordem-compra.num-pedido
         NO-LOCK NO-ERROR.
    IF NOT AVAIL pedido-compr THEN
        RETURN.

    FIND estabelec WHERE
         estabelec.cod-estabel = cCodEstabelec  NO-LOCK NO-ERROR.
    
    if avail estabelec then
       run cdp/cd9970.p (input  rowid(estabelec),
                         output iEmpresa).
    
    /* Cen†rio 1 - Pedido emergencial */
    IF pedido-compr.emergencial THEN DO:
        IF NOT AVAIL param-aprov OR NOT param-aprov.aprova-emerg THEN
            RETURN.
        
        IF AVAIL param-aprov THEN do: //AND param-aprov.aprov-total-pedido
        
        
            find first mla-tipo-doc-aprov
                 where mla-tipo-doc-aprov.ep-codigo   = iEmpresa 
                   and mla-tipo-doc-aprov.cod-estabel = cCodEstabelec 
                   and mla-tipo-doc-aprov.cod-tip-doc = 8 no-lock no-error.

            if avail mla-tipo-doc-aprov 
                 and mla-tipo-doc-aprov.apr-tip-doc then do: /*Pedido Emergencial - Total*/
                
                RUN pi-valida-msg-aprov-total (INPUT  prOrdemCompra,
                                               input  8,
                                               OUTPUT plExibeMensagem).
            end.
            ELSE DO: /*Pedido Emergencial - Item*/
        
                find first mla-tipo-doc-aprov 
                     where mla-tipo-doc-aprov.ep-codigo   = iEmpresa 
                       and mla-tipo-doc-aprov.cod-estabel = cCodEstabelec 
                       and mla-tipo-doc-aprov.cod-tip-doc = 19 no-lock no-error.

                if avail mla-tipo-doc-aprov 
                     and mla-tipo-doc-aprov.apr-tip-doc then do:
        
                    RUN pi-valida-msg-aprov-item (INPUT  prOrdemCompra,
                                                  input  19,
                                                  OUTPUT plExibeMensagem).
                end.
            end.
        end.
    END.
    ELSE DO:
        /* Cen†rio 2 - Pedido normal */
        IF NOT AVAIL param-aprov OR NOT param-aprov.aprova-pedido THEN
            RETURN.
        IF AVAIL param-aprov then do: //AND param-aprov.aprov-total-pedido 
        
            /**  Item
            **/
            FIND FIRST mla-tipo-doc-aprov 
                 WHERE mla-tipo-doc-aprov.ep-codigo   = iEmpresa 
                   AND mla-tipo-doc-aprov.cod-estabel = cCodEstabelec 
                   AND mla-tipo-doc-aprov.cod-tip-doc = 6 NO-LOCK NO-ERROR.

            IF AVAIL mla-tipo-doc-aprov AND mla-tipo-doc-aprov.apr-tip-doc THEN DO:
            
                RUN pi-valida-msg-aprov-item (INPUT  prOrdemCompra,
                                              input  19,
                                              OUTPUT plExibeMensagem).
            end.
        
            /**  Total **/
            ELSE DO:
        
                FIND FIRST mla-tipo-doc-aprov 
                     WHERE mla-tipo-doc-aprov.ep-codigo   = iEmpresa 
                       AND mla-tipo-doc-aprov.cod-estabel = cCodEstabelec 
                       and mla-tipo-doc-aprov.cod-tip-doc = 7 NO-LOCK NO-ERROR.

                IF AVAIL mla-tipo-doc-aprov AND mla-tipo-doc-aprov.apr-tip-doc THEN DO:
                    RUN pi-valida-msg-aprov-total (INPUT  prOrdemCompra,
                                                   input  7,
                                                   OUTPUT plExibeMensagem).
                END.
            end.
        end.
    end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

 PROCEDURE pi-valida-msg-aprov-total:
/*------------------------------------------------------------------------------
  Purpose: Valida exibiá∆o da mensagem para aprovaá∆o total de pedido.
           Pedido normal  -> tipo MLA 7
           Pedido emerg   -> tipo MLA 8
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prOrdemCompra   AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER plTipoDoc       AS integer NO-UNDO.
    DEFINE OUTPUT PARAMETER plExibeMensagem AS LOGICAL NO-UNDO.

    DEFINE VARIABLE de-cotacao          AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-despesa          AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-val-despesas-aux AS DECIMAL NO-UNDO.
    DEFINE VARIABLE da-cotacao          AS DATE    NO-UNDO.
    DEFINE VARIABLE i-mo-codigo-msg     AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-tipo-doc-mla      AS INTEGER NO-UNDO.
    DEFINE VARIABLE h-boin706-msg       AS HANDLE  NO-UNDO.
    DEFINE VARIABLE l-importacao-msg    AS LOGICAL NO-UNDO.

    DEFINE BUFFER bf-ordem-msg      FOR ordem-compra.
    DEFINE BUFFER bf-ordem-total    FOR ordem-compra.
    DEFINE BUFFER bf-pedido-msg     FOR pedido-compr.
    DEFINE BUFFER bf-cotacao-msg    FOR cotacao-item.
    DEFINE BUFFER bf-estabel-msg    FOR estabelec.
    DEFINE BUFFER bf-mla-param      FOR mla-param-aprov.
    DEFINE BUFFER bf-mla-tipo-doc   FOR mla-tipo-doc-aprov.
    DEFINE BUFFER bf-mla-doc-pend   FOR mla-doc-pend-aprov.

    ASSIGN plExibeMensagem     = YES
           de-valor-total      = 0
           de-val-despesas-aux = 0
           i-tipo-doc-mla      = plTipoDoc.

    FIND FIRST bf-ordem-msg
         WHERE ROWID(bf-ordem-msg) = prOrdemCompra
         NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-ordem-msg THEN
        RETURN.
    FIND FIRST bf-pedido-msg
         WHERE bf-pedido-msg.num-pedido = bf-ordem-msg.num-pedido
         NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-pedido-msg THEN
        RETURN.
    FIND FIRST bf-estabel-msg
         WHERE bf-estabel-msg.cod-estabel = bf-ordem-msg.cod-estab-gestor
         NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-estabel-msg THEN
        FIND FIRST bf-estabel-msg
             WHERE bf-estabel-msg.cod-estabel = bf-pedido-msg.end-entrega
             NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-estabel-msg THEN
        RETURN.

    RUN cdp/cd9970.p (INPUT  ROWID(bf-estabel-msg),
                      OUTPUT iEmpresa).
    FIND FIRST bf-mla-param
         WHERE bf-mla-param.ep-codigo   = iEmpresa
           AND bf-mla-param.cod-estabel = bf-estabel-msg.cod-estabel
         NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-mla-param OR NOT bf-mla-param.log-cond-pagto THEN
        RETURN.
    FIND FIRST bf-mla-tipo-doc
         WHERE bf-mla-tipo-doc.ep-codigo   = iEmpresa
           AND bf-mla-tipo-doc.cod-estabel = bf-estabel-msg.cod-estabel
           AND bf-mla-tipo-doc.cod-tip-doc = i-tipo-doc-mla
         NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-mla-tipo-doc THEN
        RETURN.

    RUN pi-verifica-importacao-msg (OUTPUT l-importacao-msg).

    IF param-compra.log-despesa THEN
        RUN inbo/boin706.p PERSISTENT SET h-boin706-msg.
    FOR EACH bf-ordem-total NO-LOCK
       WHERE bf-ordem-total.num-pedido = bf-pedido-msg.num-pedido
         AND (bf-ordem-total.situacao = 2 OR bf-ordem-total.situacao = 6):

        FIND FIRST bf-cotacao-msg
             WHERE bf-cotacao-msg.numero-ordem = bf-ordem-total.numero-ordem
               AND bf-cotacao-msg.cot-aprovada = YES
             NO-LOCK NO-ERROR.

        IF AVAIL bf-cotacao-msg THEN
            ASSIGN da-cotacao      = bf-cotacao-msg.data-cotacao
                   i-mo-codigo-msg = bf-cotacao-msg.mo-codigo.
        ELSE
            ASSIGN da-cotacao      = TODAY
                   i-mo-codigo-msg = 0.

        IF i-mo-codigo-msg = 0 THEN
            ASSIGN de-cotacao = 1.
        ELSE DO:
            RUN cdp/cd0812.p (INPUT  i-mo-codigo-msg,
                              INPUT  0,
                              INPUT  1,
                              INPUT  da-cotacao,
                              OUTPUT de-cotacao).
            IF de-cotacao = ? THEN
                ASSIGN de-cotacao = 1.
        END.

        IF AVAIL bf-cotacao-msg THEN DO:
            IF l-importacao-msg THEN DO:
                ASSIGN de-val-despesas-aux = 0.
                RUN pi-desp-importacao-msg (INPUT  ROWID(bf-cotacao-msg),
                                            INPUT  bf-ordem-total.qt-solic,
                                            INPUT  0,
                                            OUTPUT de-val-despesas-aux).
            END.
            ELSE
                ASSIGN de-val-despesas-aux = 0.
        END.
        ELSE
            ASSIGN de-val-despesas-aux = 0.

        ASSIGN de-valor-total = de-valor-total
                              + (bf-ordem-total.pre-unit-for * bf-ordem-total.qt-solic * de-cotacao)
                              + de-val-despesas-aux.
    END.

    IF VALID-HANDLE(h-boin706-msg) THEN DO:
        DELETE PROCEDURE h-boin706-msg.
        ASSIGN h-boin706-msg = ?.
    END.
    
    FIND FIRST bf-mla-doc-pend
         WHERE bf-mla-doc-pend.ep-codigo   = iEmpresa
           AND bf-mla-doc-pend.cod-estabel = bf-estabel-msg.cod-estabel
           AND bf-mla-doc-pend.cod-tip-doc = i-tipo-doc-mla
           AND bf-mla-doc-pend.chave-doc   = STRING(bf-pedido-msg.num-pedido)
           AND bf-mla-doc-pend.historico   = NO
         NO-LOCK NO-ERROR.
    IF AVAIL bf-mla-doc-pend THEN DO:
        if string(bf-mla-doc-pend.ind-situacao) = "1" then //situacao = pendente
            RETURN.
        IF NOT bf-mla-tipo-doc.log-excec-val
        AND ROUND(bf-mla-doc-pend.valor-doc,2) = ROUND(de-valor-total,2)
        AND (TRIM(SUBSTRING(bf-mla-doc-pend.char-1,25,4)) = "":U
             OR TRIM(SUBSTRING(bf-mla-doc-pend.char-1,25,4)) = STRING(bf-pedido-msg.cod-cond-pag)) THEN
            ASSIGN plExibeMensagem = NO.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE pi-valida-msg-aprov-item:
/*------------------------------------------------------------------------------
  Purpose: Valida exibiá∆o da mensagem para aprovaá∆o por item de pedido.
           Pedido normal  -> tipo MLA 6
           Pedido emerg   -> tipo MLA 19
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prOrdemCompra   AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER plTipoDoc       AS integer NO-UNDO.
    DEFINE OUTPUT PARAMETER plExibeMensagem AS LOGICAL NO-UNDO.

    DEFINE VARIABLE de-cotacao          AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE de-despesa-pedido   AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE de-val-despesas-aux AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE da-cotacao          AS DATE      NO-UNDO.
    DEFINE VARIABLE i-mo-codigo-msg     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-tipo-doc-mla      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-chave             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-importacao-msg    AS LOGICAL   NO-UNDO.

    DEFINE BUFFER bf-ordem-msg      FOR ordem-compra.
    DEFINE BUFFER bf-pedido-msg     FOR pedido-compr.
    DEFINE BUFFER bf-cotacao-msg    FOR cotacao-item.
    DEFINE BUFFER bf-estabel-msg    FOR estabelec.
    DEFINE BUFFER bf-mla-param      FOR mla-param-aprov.
    DEFINE BUFFER bf-mla-tipo-doc   FOR mla-tipo-doc-aprov.
    DEFINE BUFFER bf-mla-doc-pend   FOR mla-doc-pend-aprov.

    ASSIGN plExibeMensagem     = YES
           de-valor-total      = 0
           de-val-despesas-aux = 0
           de-despesa-pedido   = 0
           i-tipo-doc-mla      = plTipoDoc.

    FIND FIRST bf-ordem-msg
         WHERE ROWID(bf-ordem-msg) = prOrdemCompra
         NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-ordem-msg THEN DO:
        RETURN.
    END.

    FIND FIRST bf-pedido-msg
         WHERE bf-pedido-msg.num-pedido = bf-ordem-msg.num-pedido
         NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-pedido-msg THEN DO:
        RETURN.
    END.

    FIND FIRST bf-estabel-msg
         WHERE bf-estabel-msg.cod-estabel = bf-pedido-msg.cod-estab-gestor
         NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-estabel-msg THEN
        FIND FIRST bf-estabel-msg
             WHERE bf-estabel-msg.cod-estabel = bf-pedido-msg.end-entrega
             NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-estabel-msg THEN DO:
        RETURN.
    END.

    RUN cdp/cd9970.p (INPUT  ROWID(bf-estabel-msg),
                      OUTPUT iEmpresa).

    FIND FIRST bf-mla-param
         WHERE bf-mla-param.ep-codigo   = iEmpresa
           AND bf-mla-param.cod-estabel = bf-estabel-msg.cod-estabel
         NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-mla-param OR NOT bf-mla-param.log-cond-pagto THEN DO:
        RETURN.
    END.

    FIND FIRST bf-mla-tipo-doc
         WHERE bf-mla-tipo-doc.ep-codigo   = iEmpresa
           AND bf-mla-tipo-doc.cod-estabel = bf-estabel-msg.cod-estabel
           AND bf-mla-tipo-doc.cod-tip-doc = i-tipo-doc-mla
         NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-mla-tipo-doc THEN DO:
        RETURN.
    END.

    FIND FIRST bf-cotacao-msg
         WHERE bf-cotacao-msg.numero-ordem = bf-ordem-msg.numero-ordem
           AND bf-cotacao-msg.cot-aprovada = YES
         NO-LOCK NO-ERROR.

    IF AVAIL bf-cotacao-msg THEN
        ASSIGN da-cotacao      = bf-cotacao-msg.data-cotacao
               i-mo-codigo-msg = bf-cotacao-msg.mo-codigo.
    ELSE
        ASSIGN da-cotacao      = TODAY
               i-mo-codigo-msg = 0.

    IF i-mo-codigo-msg = 0 THEN
        ASSIGN de-cotacao = 1.
    ELSE DO:
        RUN cdp/cd0812.p (INPUT  i-mo-codigo-msg,
                          INPUT  0,
                          INPUT  1,
                          INPUT  da-cotacao,
                          OUTPUT de-cotacao).
        IF de-cotacao = ? THEN
            ASSIGN de-cotacao = 1.
    END.

    RUN pi-verifica-importacao-msg (OUTPUT l-importacao-msg).

    /* Soma despesas do pedido, como a cdapi171 */
    IF param-compra.log-despesa THEN DO:
        DEFINE VARIABLE h-boin706-msg AS HANDLE NO-UNDO.

        RUN inbo/boin706.p PERSISTENT SET h-boin706-msg.

        RUN calculaTotalDespesas IN h-boin706-msg (
            INPUT  ROWID(bf-cotacao-msg),
            OUTPUT de-despesa-pedido
        ).

        IF VALID-HANDLE(h-boin706-msg) THEN DO:
            DELETE PROCEDURE h-boin706-msg.
            ASSIGN h-boin706-msg = ?.
        END.
    END.

    /* Despesa de importaá∆o */
    IF AVAIL bf-cotacao-msg AND l-importacao-msg THEN DO:
        ASSIGN de-val-despesas-aux = 0.
        RUN pi-desp-importacao-msg (INPUT  ROWID(bf-cotacao-msg),
                                    INPUT  bf-ordem-msg.qt-solic,
                                    INPUT  0,
                                    OUTPUT de-val-despesas-aux).
    END.
    ELSE
        ASSIGN de-val-despesas-aux = 0.

    ASSIGN de-valor-total = ((bf-ordem-msg.qt-solic * bf-cotacao-msg.preco-unit) + de-despesa-pedido + de-val-despesas-aux) * de-cotacao.

    ASSIGN OVERLAY(c-chave,1,8) = STRING(bf-pedido-msg.num-pedido) 
           OVERLAY(c-chave,9,8) = STRING(bf-ordem-msg.numero-ordem).
    FIND FIRST bf-mla-doc-pend
         WHERE bf-mla-doc-pend.ep-codigo   = STRING(iEmpresa)
           AND bf-mla-doc-pend.cod-estabel = bf-estabel-msg.cod-estabel
           AND bf-mla-doc-pend.cod-tip-doc = i-tipo-doc-mla
           AND bf-mla-doc-pend.chave-doc   = c-chave
           AND bf-mla-doc-pend.historico   = NO
         NO-LOCK NO-ERROR.

    IF AVAIL bf-mla-doc-pend THEN DO:
        if string(bf-mla-doc-pend.ind-situacao) = "1" then //situacao = pendente
            RETURN.
        
        IF NOT bf-mla-tipo-doc.log-excec-val
        AND ROUND(bf-mla-doc-pend.valor-doc,2) = ROUND(de-valor-total,2)
        AND (TRIM(SUBSTRING(bf-mla-doc-pend.char-1,25,4)) = "":U
             OR TRIM(SUBSTRING(bf-mla-doc-pend.char-1,25,4)) = STRING(bf-pedido-msg.cod-cond-pag)) THEN
            ASSIGN plExibeMensagem = NO.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE pi-verifica-importacao-msg:
/*------------------------------------------------------------------------------
  Purpose: Verifica se o m¢dulo de importaá∆o est† implantado,
           seguindo a mesma regra do cdapi171.i3
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pl-importacao AS LOGICAL INITIAL NO NO-UNDO.

    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    IF AVAIL param-global AND param-global.modulo-07 THEN
        ASSIGN pl-importacao = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem executadas ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    RUN ccp/ccPedidoCompraValidaIntegraMe.p PERSISTENT SET h-ccPedidoCompraValidaIntegraMe.
    
    RUN verifica-pedido-compra-me IN h-ccPedidoCompraValidaIntegraMe (INPUT RowObject.num-pedido, OUTPUT isOrderIntegrMe).
        
    IF pType = "Create":U THEN DO:
        IF isOrderIntegrMe THEN DO:
            {method/svc/errors/inserr.i
                              &ErrorNumber="57880"
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR"}

            RETURN "NOK":U.
        END.        
    END.
    IF pType = "Delete":U THEN DO:
        IF isOrderIntegrMe THEN DO:
            {method/svc/errors/inserr.i
                              &ErrorNumber="57882"
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR" 
                              &ErrorParameters="string({&TableName}.numero-ordem)"}

            RETURN "NOK":U.
        END.
    END.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
    FINALLY:
        DELETE PROCEDURE h-ccPedidoCompraValidaIntegraMe NO-ERROR.
        ASSIGN h-ccPedidoCompraValidaIntegraMe = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateSegcc0300 DBOProgram
PROCEDURE validateSegcc0300 :
/*------------------------------------------------------------------------------
  Purpose: Configura mensagem de erro a ser mostrada para o usu†rio logado quanto Ö inserá∆o,
           alteraá∆o e remoá∆o de um pedido de compra caso este n∆o tenha acesso.
  Parameters:
  Notes: VALIDAÄ«O PARA SER EXECUTADA DO PROGRAMA CC0300 OU DAS TELAS FILHO
         PARA CONTROLAR SEGURANÄA POR USUµRIO PARA AÄÂES(INSERÄ«O, ALTERAÄ«O OU REMOÄ«O)
         SOBRE PEDIDO DE COMPRA
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-permissao  AS   INTEGER                    NO-UNDO.
    DEFINE INPUT PARAMETER i-num-pedido LIKE ordem-compra.num-pedido    NO-UNDO.

    DEFINE VARIABLE c-param1     AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE c-param2     AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE c-param3     AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE i-tipo-docum AS INTEGER             NO-UNDO.
    DEFINE VARIABLE l-permissao  AS LOGICAL INITIAL YES NO-UNDO.

    FIND FIRST pedido-compr WHERE pedido-compr.num-pedido = i-num-pedido NO-LOCK NO-ERROR.

    IF AVAIL pedido-compr THEN
        ASSIGN i-tipo-docum = IF pedido-compr.emergencial = NO THEN 
                                (IF pedido-compr.situacao = 2 THEN 5 ELSE 6)
                              ELSE 
                                  (IF pedido-compr.situacao = 2 THEN 7 ELSE 8).

    RUN cdp/cdapi181.p (INPUT  c-seg-usuario,
                        INPUT  i-tipo-docum,
                        INPUT  i-permissao,
                        OUTPUT l-permissao).

    IF l-permissao = NO THEN DO:

        IF i-tipo-docum = 5 THEN DO:
            {utp/ut-liter.i Ordens_de_Compra_em_Pedidos_Normais_N∆o_Emitidos mcc R}
            ASSIGN c-param2 = TRIM(RETURN-VALUE).
        END.
        ELSE
            IF i-tipo-docum = 6 THEN DO:
                {utp/ut-liter.i Ordens_de_Compra_em_Pedidos_Normais_Emitidos mcc R}
                ASSIGN c-param2 = TRIM(RETURN-VALUE).
            END.
            ELSE
                IF i-tipo-docum = 7 THEN DO:
                    {utp/ut-liter.i Ordens_de_Compra_em_Pedidos_Emergenciais_N∆o_Emitidos mcc R}
                    ASSIGN c-param2 = TRIM(RETURN-VALUE).
                END.
                ELSE
                    IF i-tipo-docum = 8 THEN DO:
                        {utp/ut-liter.i Ordens_de_Compra_em_Pedidos_Emergenciais_Emitidos mcc R}
                        ASSIGN c-param2 = TRIM(RETURN-VALUE).
                    END.

        IF i-permissao = 1 THEN DO:
            {utp/ut-liter.i incluir mcc R}
            ASSIGN c-param1 = TRIM(RETURN-VALUE).
        END.
        ELSE
            IF i-permissao = 2 THEN DO:
                {utp/ut-liter.i alterar mcc R}
                ASSIGN c-param1 = TRIM(RETURN-VALUE).
            END.
            ELSE DO:
                {utp/ut-liter.i eliminar mcc R}
                ASSIGN c-param1 = TRIM(RETURN-VALUE).
            END.
        
        IF c-seg-usuario <> ordem-compra.cod-comprado THEN DO: /* Quando usuario corrente for diferente, apresenta na mensagem */

            ASSIGN c-param3 = c-param1 + " " + c-param2.
            {method/svc/errors/inserr.i &ErrorNumber="25729"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-seg-usuario + '~~~~' + c-param3"}
        END.
        ELSE DO:
            
            {method/svc/errors/inserr.i &ErrorNumber="18728"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters= "c-param1 + '~~~~'  + c-param2"}
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdateMainLogicManutOrdCompra DBOProgram
PROCEDURE validateUpdateMainLogicManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose: Validaá‰es de neg¢cio para alteraá∆o de registros provenientes
           da Manutená∆o de ordens de compra
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

  /* Validaá∆o do movimento X conta cont†bil de investimento */
  IF rowObject.ct-codigo <> "" AND param-global.modulo-in    THEN DO:
      
      {inp/inapi060.i rowObject.cod-estabel rowObject.ct-codigo rowObject.sc-codigo rowObject.num-ord-inv NO tt-erro}

      /* conforme help dp IN0101 para ordem de producao/MI n„o deve ser validado a conta */
      IF  rowObject.num-ord-inv  <> 0
      AND rowObject.ordem-servic <> 0 THEN DO:
  
          FIND FIRST tt-erro
              WHERE tt-erro.cd-erro = 28723
                 OR tt-erro.cd-erro = 28722 NO-ERROR.
          IF AVAIL tt-erro THEN
              DELETE tt-erro.
      END.  

      IF  RETURN-VALUE = "NOK":U THEN DO:

          FOR FIRST tt-erro:

              {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                          &ErrorType="EMS"
                                          &ErrorSubType="ERROR"
                                          &ErrorParameters="tt-erro.c-param"}
          END.
      END.
  END.

  ASSIGN lConsiste  = YES.
  
  IF param-global.modulo-cn AND rowObject.nr-contrato <> 0 AND AVAIL item THEN DO:

      IF item.tipo-contr = 4 THEN DO:
          
          ASSIGN lConsiste = NO
                 lErroCo   = NO.

         RUN verificaMatrizRateioOrdemCompra.

         IF lErroCo = ?  THEN ASSIGN lConsiste = YES.
      END.
      ELSE
          ASSIGN lConsiste = YES.
  END.
  
  IF lConsiste AND AVAIL ITEM AND AVAIL ordem-compra THEN
      IF item.tipo-contr = 1 OR item.tipo-contr = 4 OR ordem-compra.ct-codigo <> rowObject.ct-codigo THEN DO:
          
          IF item.tipo-contr <> 1 AND item.tipo-contr <> 4 AND rowObject.ct-codigo = "" THEN LEAVE.
          
          FIND FIRST estabelec NO-LOCK
               WHERE estabelec.cod-estabel = rowObject.cod-estabel NO-ERROR.
          
          ASSIGN iEmpresa = estabelec.ep-codigo WHEN AVAIL estabelec.
          
          RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

          ASSIGN c-ct-codigo = rowObject.ct-codigo.

          RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        iEmpresa,                   /* EMPRESA EMS2 */
                                                         INPUT        "",                         /* PLANO DE CONTAS */
                                                         INPUT-OUTPUT c-ct-codigo,                /* CONTA */
                                                         INPUT        rowObject.data-atualiz,     /* DATA TRANSACAO */
                                                         OUTPUT       v_des_cta_ctbl,             /* DESCRICAO CONTA */
                                                         OUTPUT       v_num_tip_cta_ctbl,         /* TIPO DA CONTA */
                                                         OUTPUT       v_num_sit_cta_ctbl,         /* SITUAÄ«O DA CONTA */
                                                         OUTPUT       v_ind_finalid_cta,          /* FINALIDADES DA CONTA */
                                                         OUTPUT TABLE tt_log_erro).               /* ERROS */
         IF VALID-HANDLE(h_api_cta_ctbl) THEN
             DELETE OBJECT h_api_cta_ctbl.

         FOR FIRST tt_log_erro:
             
             {method/svc/errors/inserr.i &ErrorNumber="17006"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro)"}
         END.
         
         IF NOT CAN-FIND(tt_log_erro) THEN DO:

             IF (INT(v_num_tip_cta_ctbl) <> 1 AND INT(v_num_tip_cta_ctbl) <> 2 AND INT(v_num_tip_cta_ctbl) <> 4 AND INT(v_num_tip_cta_ctbl) <> 5) 
             OR  INT(v_num_sit_cta_ctbl) <> 3 THEN DO:
                 
                 {method/svc/errors/inserr.i &ErrorNumber="1071" &ErrorType="EMS" &ErrorSubType="ERROR"}
             END.

             /* Verifica Estoque */
             ASSIGN ind       = 1
                    i-estoque = 0.

             DO WHILE ind <= 10:
                 
                 ASSIGN v_cod_finalid = {adinc/i05ad049.i 4 ind}.
                
                 IF LOOKUP(v_cod_finalid, v_ind_finalid_cta) > 0 THEN DO:
                     ASSIGN i-estoque = ind.
                     LEAVE.
                 END.
                 ASSIGN ind = ind + 1.
             END.

             IF  param-global.modulo-ce 
             AND (i-estoque = 10 OR (i-estoque <> 1 AND i-estoque <> 2 AND i-estoque <> 3 AND i-estoque <> 5 AND i-estoque <> 6)) THEN DO:
                 
                 {method/svc/errors/inserr.i &ErrorNumber="445" &ErrorType="EMS" &ErrorSubType="ERROR"}
             END.
          END.
      END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdateManutOrdCompra DBOProgram
PROCEDURE validateUpdateManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose: Validar atualizaá‰es de registros procedentes do programa
           de manutená∆o de ordens de compra
  Parameters: ipar1 : table for rowObject : Tabela de dados a ser validada
              ipar2 : r-chave             : Rowid do registro a ser validado
              opar3 : table for rowErrors : Tabela de controle de errros
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE   FOR RowObject.
    DEFINE INPUT  PARAMETER r-chave AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE   FOR RowErrors.
    
    DEFINE VARIABLE h-ccOrdemCompraValidaIntegraMe AS HANDLE NO-UNDO.
    DEFINE VARIABLE l-ordem-integrada-me           AS LOGICAL NO-UNDO.

    FIND FIRST rowObject NO-LOCK NO-ERROR.

    RUN emptyRowErrors IN THIS-PROCEDURE. /* Limpa a tabela de controle de erros */
        
    //Valida OC integrada com o Mercado Eletronico
    IF NOT VALID-HANDLE(h-ccOrdemCompraValidaIntegraMe) THEN
        RUN ccp/ccOrdemCompraValidaIntegraMe.p PERSISTENT SET h-ccOrdemCompraValidaIntegraMe.
               
    RUN verifica-ordem-compra IN h-ccOrdemCompraValidaIntegraMe (INPUT  RowObject.numero-ordem,
                                                                 OUTPUT l-ordem-integrada-me).

    IF VALID-HANDLE(h-ccOrdemCompraValidaIntegraMe) THEN DO:
        DELETE PROCEDURE h-ccOrdemCompraValidaIntegraMe.
        ASSIGN h-ccOrdemCompraValidaIntegraMe = ?.
    END.

                                                                     
    IF l-ordem-integrada-me THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="58000"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters= RowObject.numero-ordem}
        RETURN "NOK":U.   
    END.
    
    //Fim valida OC integrada com ME

    RUN validateFieldsMainLogicManutOrdCompra.

    FIND FIRST {&TableName} 
         WHERE ROWID({&TableName}) = r-chave NO-LOCK NO-ERROR.

    RUN validateUpdateMainLogicManutOrdCompra.
    
    FIND FIRST {&TableName} WHERE ROWID({&TableName}) = r-chave EXCLUSIVE-LOCK NO-ERROR.
    
    IF NOT (CAN-FIND (FIRST RowErrors)) THEN DO:

        RUN inbo/boin274.p PERSISTENT SET h-boin274.

        RUN setConstraintNumPedido IN h-boin274 (INPUT rowObject.num-pedido).
        RUN openQueryStatic        IN h-boin274 ("ByPedido":U).
        RUN validateUpdate         IN h-boin274 (INPUT  TABLE rowObject,
                                                 INPUT  r-chave,
                                                 OUTPUT TABLE RowErrors).
        DELETE PROCEDURE h-boin274.
        ASSIGN h-boin274 = ?.
    END.

    RUN AtualizaDadosOrdemCompraSemPedido (BUFFER ordem-compra).

    RETURN (IF NOT (CAN-FIND (FIRST RowErrors)) THEN "OK":U ELSE "NOK":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdatePedEmerg DBOProgram
PROCEDURE validateUpdatePedEmerg :
/*------------------------------------------------------------------------------
  Purpose: Validaá∆o para alteraá∆o de registros provenientes do programa
           de pedidos emergenciais
  Parameters: ipar1 : table for RowObject : Tabela de dados
              ipar2 : rChave              : Rowid do registro a ser alterado
              opar3 : table for rowErrors : Tabela de controle de erros
  Notes:
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER TABLE      FOR RowObject.
   DEFINE INPUT  PARAMETER rChave     AS ROWID NO-UNDO.
   DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

   DEFINE VARIABLE lretornoaprov AS LOGICAL NO-UNDO.

   DEFINE VARIABLE h-ccOrdemCompraValidaIntegraMe AS HANDLE NO-UNDO.
   DEFINE VARIABLE l-ordem-integrada-me           AS LOGICAL NO-UNDO.
  
   FIND FIRST rowobject NO-LOCK NO-ERROR.

   RUN emptyRowErrors IN THIS-PROCEDURE.  
   IF param-global.modulo-in AND rowobject.num-ord-inv <> 0 THEN DO:

       FIND FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-ERROR.

       ASSIGN iEmpresa = estabelec.ep-codigo WHEN AVAIL estabelec.

       RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.

       RUN validaSituacaoProjInvestimento IN h-boiv028 (INPUT iEmpresa,
                                                        INPUT rowobject.num-ord-inv,
                                                        INPUT "UPDATE":U ).

       RUN getRowErrors IN h-boiv028 ( OUTPUT TABLE RowErrors).

       DELETE PROCEDURE h-boiv028.
       ASSIGN h-boiv028 = ?.
   END.

   RUN validateFieldsMainLogicPedEmerg.
   
   /* VALIDAÄ«O DO PROGRAMA CC0300 PARA CONTROLAR SEGURANÄA POR USUµRIO PARA PEDIDO DE COMPRA */
   IF l-seg-cc0300 = YES THEN DO:
       RUN validateSegCC0300 (INPUT 2, INPUT rowobject.num-pedido).
   END.

   /* se n∆o existir ordem-compra ent∆o Ç inclus∆o e n∆o precisa fazer a validaá∆o abaixo */
   IF CAN-FIND(FIRST ordem-compra
               WHERE ordem-compra.numero-ordem = RowObject.numero-ordem) THEN DO:

       FOR FIRST pedido-compr FIELDS(num-pedido situacao)
           WHERE pedido-compr.num-pedido = RowObject.num-pedido NO-LOCK: 

           IF pedido-compr.situacao = 1 THEN /* Impresso */
               ASSIGN l-cc0308 = YES.
           ELSE
               ASSIGN l-cc0308 = NO.

           IF l-cc0308 THEN
               RUN validaOrdemCompraPedImp (INPUT RowObject.numero-ordem,
                                            INPUT RowObject.ct-codigo,
                                            INPUT RowObject.sc-codigo,
                                            INPUT RowObject.cod-comprado,
                                            INPUT RowObject.ordem-servic,
                                            INPUT RowObject.comentarios).
       END.
   END.

   IF NOT(CAN-FIND (FIRST RowErrors)) AND rChave <> ? THEN DO:
       
       FIND FIRST {&TableName} WHERE ROWID({&TableName}) = rChave EXCLUSIVE-LOCK NO-ERROR.
       RUN executeUpdatePedEmerg.
   END.

   FIND CURRENT ordem-compra NO-LOCK NO-ERROR.

   RETURN (IF NOT (CAN-FIND (FIRST RowErrors)) THEN "OK":U ELSE "NOK":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaEstabelOCxOS DBOProgram
PROCEDURE verificaEstabelOCxOS :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF RowObject.ordem-servic > 0 AND param-global.modulo-cp THEN DO:

        FIND FIRST ord-prod
             WHERE ord-prod.nr-ord-produ = RowObject.ordem-servic NO-LOCK NO-ERROR.

        IF AVAIL ord-prod THEN DO:
            
            IF ord-prod.cod-estabel <> RowObject.cod-estabel THEN DO:

                {method/svc/errors/inserr.i &ErrorNumber="15189"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                 RETURN "NOK":U.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaMatrizRateioOrdemCompra DBOProgram
PROCEDURE verificaMatrizRateioOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: Verifica a existància de matriz de rateio da Ordem de compra
           na atualizaá∆o/criaá∆o do registro.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    IF param-contrat.controle-rateio THEN DO:

        FOR FIRST contrato-for NO-LOCK
            WHERE contrato-for.nr-contrato = rowObject.nr-contrato:
            
            FOR FIRST item-contrat NO-LOCK
                WHERE item-contrat.nr-contrato   = rowObject.nr-contrato
                  AND item-contrat.num-seq-item = rowObject.num-seq-item:
                
                IF contrato-for.ind-control-rec = 2 THEN DO:
                    
                    IF rowObject.ct-codigo = "" OR rowObject.ct-codigo = "0" THEN DO:
                        
                        IF  NOT CAN-FIND(FIRST matriz-rat-item
                                         WHERE matriz-rat-item.nr-contrato  = item-contrat.nr-contrato
                                           AND matriz-rat-item.num-seq-item = item-contrat.num-seq-item
                                           AND matriz-rat-item.perc-rateio  > 0) THEN DO:
                            
                            IF  NOT CAN-FIND(FIRST matriz-rat-contr
                                             WHERE matriz-rat-contr.nr-contrato = item-contrat.nr-contrato
                                               AND matriz-rat-contr.perc-rateio > 0) THEN
                                ASSIGN lErroCo = YES.
                        END.
                    END.
                    ELSE DO:
                        
                        IF NOT CAN-FIND(FIRST matriz-rat-item
                                        WHERE matriz-rat-item.nr-contrato   = item-contrat.nr-contrato
                                          AND matriz-rat-item.num-seq-item = item-contrat.num-seq-item
                                          AND matriz-rat-item.ct-codigo    = rowObject.ct-codigo
                                          AND matriz-rat-item.sc-codigo    = rowObject.sc-codigo) THEN DO:
                            
                            IF NOT CAN-FIND(FIRST matriz-rat-contr
                                            WHERE matriz-rat-contr.nr-contrato = item-contrat.nr-contrato
                                              AND matriz-rat-contr.ct-codigo  = rowObject.ct-codigo
                                              AND matriz-rat-contr.sc-codigo  = rowObject.sc-codigo) THEN DO:
                                
                                FOR FIRST bMatrizItem FIELDS(nr-contrato num-seq-item)
                                    WHERE bMatrizItem.nr-contrato   = item-contrat.nr-contrato
                                      AND bMatrizItem.num-seq-item = item-contrat.num-seq-item NO-LOCK: END.
    
                                FOR FIRST bMatrizContr FIELDS(nr-contrato)
                                    WHERE bMatrizContr.nr-contrato = item-contrat.nr-contrato NO-LOCK: END.
    
                                IF AVAIL bMatrizItem OR AVAIL bMatrizContr THEN
                                    ASSIGN lErroCo = YES.
    
                                IF NOT AVAIL bMatrizItem AND NOT AVAIL bMatrizContr THEN
                                    ASSIGN lErroCo = ?.
                            END.
                        END.
                    END. 
                END. /* contrato-for.ind-control-rec = 2  */
                
                
                IF contrato-for.ind-control-rec = 1 THEN DO:
                    
                    IF rowObject.ct-codigo = "" OR rowObject.ct-codigo = "0":U OR rowObject.sc-codigo = "" OR rowObject.sc-codigo = "0":U THEN DO:

                        IF NOT CAN-FIND(FIRST matriz-rat-contr
                                        WHERE matriz-rat-contr.nr-contrato = item-contrat.nr-contrato
                                          AND matriz-rat-contr.perc-rateio > 0) THEN
                            ASSIGN lErroCo = YES.
                    END.
                    ELSE DO:

                        IF CAN-FIND(FIRST matriz-rat-contr
                                    WHERE matriz-rat-contr.nr-contrato = item-contrat.nr-contrato
                                      AND matriz-rat-contr.ct-codigo  = rowObject.ct-codigo
                                      AND matriz-rat-contr.sc-codigo  = rowObject.sc-codigo) THEN DO:
                            
                            IF CAN-FIND(FIRST bMatrizContr
                                        WHERE bMatrizContr.nr-contrato = item-contrat.nr-contrato) THEN
                                ASSIGN lErroCo = YES.
                            ELSE
                                ASSIGN lErroCo = ?.
                        END.
                    END.
                END. /* contrato-for.ind-control-rec = 1 */
            END. /* FOR FIRST item-contrat */
        END. /* FOR FIRST contrato-for */
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificCentralOrdemCompra DBOProgram
PROCEDURE verificCentralOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-ordem  AS ROWID NO-UNDO.

    RUN ccp/ccapi199.p(INPUT "Ordem-compra":U, INPUT p-ordem, OUTPUT l-erro-mp).
    
    IF l-erro-mp THEN DO:
        
        {utp/ut-liter.i "Ordem_de_Compra" *}
        {method/svc/errors/inserr.i &ErrorNumber="7193"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE zeraNrProcessoOrdemCompra DBOProgram
PROCEDURE zeraNrProcessoOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     Zera o N£mero do Processo da Ordem Compra.
  Parameters:  ipar1   : prOrdemCompra  : rowid da Ordem Compra.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prOrdemCompra AS ROWID NO-UNDO.
    
    FOR FIRST ordem-compra FIELDS(numero-ordem num-pedido int-1)
        WHERE ROWID(ordem-compra) = prOrdemCompra NO-LOCK: END.

    IF AVAIL ordem-compra THEN DO:

        IF ordem-compra.num-pedido > 0  THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="18893"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameter="trim(return-value)"}
            RETURN "NOK":U.
        END.

        FOR FIRST pedido-compr FIELDS(num-pedido nr-processo)
            WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.

        IF AVAIL pedido-compr AND pedido-compr.nr-processo <> 0 THEN DO:
            
            {method/svc/errors/inserr.i &ErrorNumber="18254"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameter="ordem-compra.numero-ordem"}
            RETURN "NOK":U.
        END.

        IF  param-global.modulo-mp 
        AND (ordem-compra.num-pedido = 0 OR 
             CAN-FIND(FIRST pedido-compr WHERE pedido-compr.num-pedido = ordem-compra.num-pedido AND pedido-compr.situacao = 1)) THEN DO:

            RUN ccp/ccapi199.p(INPUT "Ordem-compra":U, ROWID(ordem-compra), OUTPUT l-erro).
            
            IF l-erro THEN DO: /*Ordem so pode ser alterada no estabelecimento gestor.*/
                
                {utp/ut-liter.i "Ordem_Compra" *}
                ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
                {utp/ut-liter.i "Gestor" *}
                
                {method/svc/errors/inserr.i &ErrorNumber="18200"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-traducao + '~~~~' + TRIM(RETURN-VALUE)"}
                RETURN "NOK":U.
            END.
        END.

        FOR EACH tt-epc WHERE tt-epc.cod-event = "beforeZeraNrProcesso":U:
            DELETE tt-epc.
        END.

        {include/i-epc200.i2 &CodEvent='"beforeZeraNrProcesso"'
                             &CodParameter='"rowid-ordem"'
                             &ValueParameter="string(rowid(ordem-compra))"}
                             
        {include/i-epc201.i "afterZeraNrProcesso"}
        IF RETURN-VALUE = "NOK":U THEN DO:
            RETURN "NOK":U.
        END.
        
        /* Aprovacao eletronica - MLA */
        RUN lap/mlaapi099.p (INPUT 7).

        IF CAN-FIND(FIRST funcao
                    WHERE funcao.cd-funcao = "Integra_MLA_EMS":U
                      AND funcao.ativo) AND RETURN-VALUE <> "NOK":U THEN DO:
            
            /* Nao importa qual cotacao foi aprovad,a pois a chave da pendencia È o numero do processo e numero da ordem */
            FOR FIRST cotacao-item
                WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
                
                RUN cdp/cdapi171.p (7,3,ROWID(cotacao-item)).
            END.
        END.

        FIND CURRENT ordem-compra EXCLUSIVE-LOCK.
        ASSIGN ordem-compra.nr-processo          = 0
               ordem-compra.cdn-tip-lote-pregao  = 0.
        
        RUN inbo/boin762.p PERSISTENT SET h-boin762.

        RUN eliminarCampoLotePregaoOrd IN h-boin762 (INPUT ordem-compra.numero-ordem).
        RUN destroy                    IN h-boin762.

        ASSIGN h-boin762 = ?.
        
        FOR EACH tt-epc WHERE tt-epc.cod-event = "afterZeraNrProcesso":U:
            DELETE tt-epc.
        END.

        {include/i-epc200.i2 &CodEvent='"afterZeraNrProcesso"'
                             &CodParameter='"rowid-ordem"'
                             &ValueParameter="string(rowid(ordem-compra))"}
        
        {include/i-epc201.i "afterZeraNrProcesso"}
        IF RETURN-VALUE = "NOK":U THEN DO:
            RETURN "NOK":U.
        END.
        
        /*  MultiPlanta */
        IF  AVAIL param-global AND param-global.modulo-mp AND ordem-compra.cod-estab-gestor <> ""
        AND (ordem-compra.num-pedido = 0 OR
             CAN-FIND(pedido-compr WHERE pedido-compr.num-pedido = ordem-compra.num-pedido AND pedido-compr.situacao = 1) ) THEN DO:

            RUN ccp/ccapi200.p(INPUT "Ordem-compra":U, INPUT ROWID(ordem-compra),
                               INPUT 2, INPUT-OUTPUT TABLE tt-erro-mp).
        END.

        RETURN "OK":U.
   END.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

