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
{include/i-prgvrs.i BOIN295 2.00.01.046 } /*** "010146" 29/09/2025 08:52:05 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin295 MUT}
&ENDIF


/*--------------------------------------------------------------------------
    File       :
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiáao ---*/
&GLOBAL-DEFINE DBOName pedido-compr
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName pedido-compr
&GLOBAL-DEFINE TableLabel Pedidos de Compra
&GLOBAL-DEFINE QueryName qr{&TableName}

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/
&Scoped-define TTONLY TRUE
&Scoped-define REPOSITION-PROCEDURE repositionQueries
&Scoped-define SEGUR-ESTAB-ATRIBUTE end-entrega /*atributo que contem o estabelecimento na query*/

&Scoped-define KEY-PHRASE TRUE
{include/i-estab-security.i}

&IF "{&ems_dbtype}":U = "mss":U &THEN
   DEFINE QUERY {&QueryName} FOR {&TableName}, {&ESTAB-SEC-TT} SCROLLING.
&ELSE
   DEFINE QUERY {&QueryName} FOR {&ESTAB-SEC-TT}, {&TableName} SCROLLING.
&ENDIF
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/
                      
/*&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
  &GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS Main*/

/*--- Include com definiá∆o da temptable RowObject new field---*/
{inbo/boin295.i RowObject}

/* Local Pre Processors Definitions ---                                            */
{include/i_dbvers.i}  /* Preprocessadores que identificam os bancos do Produto */
{cdp/cdcfgmnt.i}      /* Include com prÇ-processadores  */   
{cdp/cdcfgmat.i}      /* Include com prÇ-processadores  */
{cdp/cdcfgdis.i}      /* Include com prÇ-processadores  */

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName}  FOR {&TableName}.
DEFINE BUFFER bf-ordem        FOR ordem-compra.
DEFINE BUFFER b-ordem-compra  FOR ordem-compra.
DEFINE BUFFER b-prazo-compra  FOR prazo-compra.
DEFINE BUFFER bf-pedido-compr FOR pedido-compr.
DEFINE BUFFER bf-prazo-compra FOR prazo-compra.

/* Global Variable Definitions ---                                            */
{utp/ut-glob.i}
DEFINE NEW GLOBAL SHARED VAR gl-prog-cc9019        AS LOGICAL   NO-UNDO. /*--- Eng Melhorias Aprov eletronica ---*/
DEFINE NEW GLOBAL SHARED VAR gl-proxima-aprovacao  AS LOGICAL   NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR gi-proxima-prioridade AS INTEGER   NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR gr-ordem-compra       AS ROWID     NO-UNDO.

/* Local Variables Definitions ---                                            */
DEFINE VARIABLE c-tipo-moeda              AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-moeda-lim               AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-tipo-trans              AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE cComments                 AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-estabelecimento         AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-cod-estabel             AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE i-empresa                 AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-mensagem                AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-servico                 AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-lista-r-AltPed 	      AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-literal-obs             AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-usuario                 AS   CHARACTER                           NO-UNDO. 
DEFINE VARIABLE c-it-codigo               AS   CHARACTER                           NO-UNDO. 
DEFINE VARIABLE c-cod-incoterm1           AS   CHARACTER                           NO-UNDO. 
DEFINE VARIABLE c-cod-incoterm2           AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-lb-campo                AS   CHARACTER                           NO-UNDO. 
DEFINE VARIABLE c-lb-tabela               AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-lb-relac                AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-lb-estab                AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE cCodEstabel               AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-numero-ordem            AS   CHARACTER                           NO-UNDO.
DEFINE VARIABLE da-date                   AS   DATE                                NO-UNDO.
DEFINE VARIABLE de-valor-doc-tot          AS   DECIMAL                             NO-UNDO.
DEFINE VARIABLE de-valor-doc              AS   DECIMAL                             NO-UNDO.
DEFINE VARIABLE de-valor-lim              AS   DECIMAL                             NO-UNDO.
DEFINE VARIABLE de-valor-item             AS   DECIMAL                             NO-UNDO.
DEFINE VARIABLE de-valor-total            AS   DECIMAL                             NO-UNDO.
DEFINE VARIABLE de-cotacao                AS   DECIMAL                             NO-UNDO.
DEFINE VARIABLE de-qtd-tot                AS   DECIMAL                             NO-UNDO.
DEFINE VARIABLE de-preco-conv             AS   DECIMAL                             NO-UNDO.
DEFINE VARIABLE de-val-tot                AS   DECIMAL                             NO-UNDO.
DEFINE VARIABLE h-cdapi029                AS   HANDLE                              NO-UNDO.
DEFINE VARIABLE hBoin082ca                AS   HANDLE                              NO-UNDO.
DEFINE VARIABLE hMMVUnidNegoc             AS   HANDLE                              NO-UNDO.
DEFINE VARIABLE h-axssu016                AS   HANDLE                              NO-UNDO.
DEFINE VARIABLE h-bocx341                 AS   HANDLE                              NO-UNDO.
DEFINE VARIABLE h-boiv028                 AS   HANDLE                              NO-UNDO. /* Integraáao com Investimentos                                 */
DEFINE VARIABLE h-boiv037                 AS   HANDLE                              NO-UNDO.
DEFINE VARIABLE h-boin356vl               AS   HANDLE                              NO-UNDO. /* Validacao fornecedores                                       */
DEFINE VARIABLE h-boin706                 AS   HANDLE                              NO-UNDO. /* Outras despesas compras                                      */
DEFINE VARIABLE h-bocx225                 AS   HANDLE                              NO-UNDO. /* Relacionamento pedido/ordem com o embarque                   */
DEFINE VARIABLE h-cdapi050                AS   HANDLE                              NO-UNDO. /* Vari†vel necess†ria para a tabela de extensao do Siscoserv   */
DEFINE VARIABLE h-axssu004                AS   HANDLE                              NO-UNDO. /* Operacional Textil                                           */
DEFINE VARIABLE h-ggapi106                AS   HANDLE                              NO-UNDO. /* M¢dulo Graos                                                 */
DEFINE VARIABLE i-moeda-lim               AS   INTEGER                             NO-UNDO.
DEFINE VARIABLE i-tipo-moeda              AS   INTEGER                             NO-UNDO.
DEFINE VARIABLE i-tracking-number         AS   INTEGER                             NO-UNDO.
DEFINE VARIABLE iTpAtualizacao            AS   INTEGER                             NO-UNDO.
DEFINE VARIABLE i-tipo-aux                AS   INTEGER INITIAL 4                   NO-UNDO.
DEFINE VARIABLE i-num-pedido-gerado       AS   INTEGER                             NO-UNDO. 
DEFINE VARIABLE i-cont                    AS   INTEGER                             NO-UNDO.
DEFINE VARIABLE i-numero-pedido           AS   INTEGER                             NO-UNDO. 
DEFINE VARIABLE iCodEmit                  AS   INTEGER                             NO-UNDO. 
DEFINE VARIABLE iNumPedido                AS   INTEGER                             NO-UNDO.
DEFINE VARIABLE i-tipo-movto              AS   INTEGER                             NO-UNDO.
DEFINE VARIABLE l-erro                    AS   LOGICAL                             NO-UNDO.
DEFINE VARIABLE l-ped-emerg               AS   LOGICAL                             NO-UNDO.
DEFINE VARIABLE l-pendente                AS   LOGICAL                             NO-UNDO.
DEFINE VARIABLE l-aprov-total	          AS   LOGICAL INITIAL NO                  NO-UNDO.
DEFINE VARIABLE l-integra-mla-total       AS   LOGICAL INITIAL NO                  NO-UNDO.
DEFINE VARIABLE l-aprov-total-9019        AS   LOGICAL INITIAL NO                  NO-UNDO.
DEFINE VARIABLE l-altera-investimentos    AS   LOGICAL                             NO-UNDO.
DEFINE VARIABLE l-aprov-eletronica        AS   LOGICAL                             NO-UNDO.
DEFINE VARIABLE l-processo-completo       AS   LOGICAL                             NO-UNDO.
DEFINE VARIABLE l-erro-mp                 AS   LOGICAL INITIAL NO                  NO-UNDO.
DEFINE VARIABLE l-flex-lastOrder          AS   LOGICAL INITIAL NO                  NO-UNDO. 
DEFINE VARIABLE l-lastOrder               AS   LOGICAL INITIAL YES                 NO-UNDO. 
DEFINE VARIABLE l-seg-cc0300              AS   LOGICAL INITIAL NO                  NO-UNDO. /* Permissao usu†rio manutenáao de pedidos no programa cc0300   */
DEFINE VARIABLE l-executCreate            AS   LOGICAL INITIAL NO                  NO-UNDO. 
DEFINE VARIABLE l-retorno                 AS   LOGICAL                             NO-UNDO. 
DEFINE VARIABLE l-primeiro                AS   LOGICAL                             NO-UNDO.
DEFINE VARIABLE l-aberto                  AS   LOGICAL                             NO-UNDO. 
DEFINE VARIABLE l-modulo-ge               AS   LOGICAL                             NO-UNDO. 
DEFINE VARIABLE l-retorno-aprov           AS   LOGICAL                             NO-UNDO.
DEFINE VARIABLE l-portal-paradigma        AS   LOGICAL INITIAL NO                  NO-UNDO.
DEFINE VARIABLE l-cria                    AS   LOGICAL                             NO-UNDO.
DEFINE VARIABLE l-graos-ativo             AS   LOGICAL INITIAL NO                  NO-UNDO.
DEFINE VARIABLE l-mla-ativo               AS   LOGICAL                             NO-UNDO. 
DEFINE VARIABLE r-rowid-ordem-compra      AS   ROWID                               NO-UNDO.
DEFINE VARIABLE i-num-pedido-ini          LIKE pedido-compr.num-pedido             NO-UNDO.
DEFINE VARIABLE i-num-pedido-fim          LIKE pedido-compr.num-pedido             NO-UNDO.
DEFINE VARIABLE i-pedido-ord              LIKE pedido-compr.num-pedido             NO-UNDO.
DEFINE VARIABLE iNumNewPedido             LIKE pedido-compr.num-pedido             NO-UNDO.
DEFINE VARIABLE de-qtde-parcela           LIKE prazo-compra.quantidade             NO-UNDO.
DEFINE VARIABLE de-qt-saldo               LIKE prazo-compra.quant-saldo            NO-UNDO.
DEFINE VARIABLE de-preco-unit             LIKE ordem-compra.preco-unit DECIMALS 4  NO-UNDO.

/*  Vari†veis de validaá∆o pedidos integrados ME   */
DEFINE VARIABLE isOrderIntegrMe                  AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-ordem-integrada-me             AS LOGICAL NO-UNDO.
DEFINE VARIABLE h-ccPedidoCompraValidaIntegraMe  AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-ccOrdemCompraValidaIntegraMe   AS HANDLE  NO-UNDO.


{cdp/cdapi171.i2} /* Variaveis Integracao Modulo Importacao, l-importacao, de-val-despesas, de-val-despesas-aux */
{cdp/cd4300.i3}   /* Vari†veis utilizadas pelo cd4300.i4                                                        */
{ccp/cc9019.i50}  /* Definicao das variaveis que serao utilizadas pela include cc9019.i51                       */
{cdp/cd9731.i6}   /* l-min-mmi = yes                                                                            */


/* Local Temp-Tables Definitions ---                                            */
DEFINE TEMP-TABLE tt-embarque NO-UNDO
    FIELD embarque AS CHAR FORMAT "x(16)":U.

DEFINE TEMP-TABLE tt-aed-chave NO-UNDO
    FIELD valor AS CHARACTER FORMAT "x(20)":U EXTENT 10.

DEFINE TEMP-TABLE tt-erro-mp NO-UNDO
    FIELD i-sequen AS INTEGER
    FIELD cd-erro  AS INTEGER
    FIELD mensagem AS CHARACTER FORMAT "x(255)":U.

DEFINE TEMP-TABLE tt-erro-ggapi106 NO-UNDO
    FIELD i-sequen  AS INTEGER
    FIELD cd-erro   AS INTEGER
    FIELD mensagem  AS CHARACTER FORMAT "x(255)":U.

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

{cdp/cd0669.i}                  /* l-multi(global), l-del-erros, v-nom-arquivo-cb, c-mensagem-cb, tt-erro                                       */
{cdp/cd7300.i1}                 /* Definicao de Temp-Tables e Variaveis de controle para Integracao entre o Multiplanta e os demais Modulos     */
{cdp/cd7300.i2}                 /* Definicao de Frames e Literais para Emissao de Relatorio de Erros de Integracao com o Multiplanta            */
{ccp/cc9019.i1}                 /* tt-ordem-rowid, tt-param-rowid                                                                               */
{include/boini.i}               /* l-version, lExistsCustomBO, cCustomBOName, l-query, i-bo-query, i-seq-erro, c-return, tt-bo-erro             */
{include/i-epc200.i boin295}    /* Definicao e preenchimento das variaveis de upc, appc e dpc (Ex.: c-nom-prog-upc-mg97) e Definicao da tt-epc  */
{adapters/xml/su2/axssu012.i}   /* ttPurchaseOrderLine012, tt_log_erro, tt-pedido-compr                                                         */
{inbo/boin082.i tt-cotacao-aux}
{fch/fchmat/fchmatcreatepurchaseorder.i3} /* tt-digita e tt-pedidos */

                          
/* Local Informations Boot ---                                            */
IF CAN-FIND(FIRST funcao
            WHERE funcao.cd-funcao = "spp-portal-paradigma":U
              AND funcao.ativo) THEN DO:
    FIND FIRST param-compra NO-LOCK NO-ERROR.

    IF &IF "{&bf_mat_versao_ems}":U < "2.09":U &THEN
           AVAIL param-compra AND
           SUBSTRING(param-compra.char-2,103,1) = "S":U
       &ELSE
           AVAIL param-compra AND
           param-compra.log-portal-paradigma
       &ENDIF
    THEN DO:
        ASSIGN l-portal-paradigma = YES.
    END.
END.

ASSIGN l-mla-ativo = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "Integra_MLA_EMS":U AND funcao.ativo).


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
         HEIGHT             = 2.54
         WIDTH              = 37.14.
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

/*--- Desabilita a trigger de delete do pedido ---*/
on delete of pedido-compr override do:
end.

{method/svc/autentic/autentic.i
        &vUserName="c-seg-usuario"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     /* afterexecuteCreate */
               Atualiza dados de situaáao,status emergencial,estabelecimento e
               estat°sticas de compras sempre que um registro Ç criado.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    ASSIGN l-executCreate           = YES.
    ASSIGN pedido-compr.nr-contrato = 0.

    RUN atualizaSituacaoPedidoCompra.

    RUN ccp/ccapi642.p (5, ROWID(pedido-compr), 1).

    RUN validateSegcc0300 (INPUT "Create":U,
                           INPUT pedido-compr.emergencial,
                           INPUT pedido-compr.situacao).

    RETURN STRING(ROWID({&TableName})).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza dados de situaáao,status emergencial,estabelecimento,
               estat°sticas de compras,ordens dependentes e respectivas cotaáoes
               sempre que um registro Ç alterado.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    ASSIGN l-executCreate = NO.

    RUN atualizaSituacaoPedidoCompra.
    RUN atualizaOrdensCompraPedidoCompra.

    RUN validateSegcc0300 (INPUT "Update":U,
                           INPUT pedido-compr.emergencial,
                           INPUT pedido-compr.situacao).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aprovacaoEletronica DBOProgram
PROCEDURE aprovacaoEletronica :
/*------------------------------------------------------------------------------
  Purpose:    
  Parameters: prOrdem - rowid da ordem de compra 
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prOrdem AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-lotacao AS CHARACTER      NO-UNDO.
    DEFINE VARIABLE h-boin772 AS HANDLE         NO-UNDO.

    FIND FIRST param-aprov NO-LOCK NO-ERROR.

    FOR FIRST ordem-compra NO-LOCK
        WHERE ROWID(ordem-compra) = prOrdem: END.

    FOR FIRST pedido-compr NO-LOCK
        WHERE pedido-compr.num-pedido = ordem-compra.num-pedido: END.
    
    /** Aprovaáao Eletrìnica **/

    IF NOT AVAIL param-compra THEN
        FIND FIRST param-compra NO-LOCK NO-ERROR.
    
    IF AVAIL ordem-compra AND AVAIL param-compra AND param-compra.log-1 THEN DO:

        ASSIGN gr-ordem-compra = ROWID(ordem-compra).

        /* INICIO - PONTO DE CHAMADA PARA UPC */
        IF  c-nom-prog-dpc-mg97  <> "":U
        OR  c-nom-prog-appc-mg97 <> "":U
        OR  c-nom-prog-upc-mg97  <> "":U THEN DO:
    
            FOR EACH tt-epc
                WHERE tt-epc.cod-event = "BeforeAprovacaoEletronica":U:
                DELETE tt-epc.
            END.
    
            {include/i-epc200.i2 &CodEvent="'beforeAprovacaoEletronica'"
                                 &CodParameter="'rowid-ordem-compra'"
                                 &ValueParameter=STRING(ROWID(ordem-compra))}
    
            {include/i-epc201.i "beforeAprovacaoEletronica"}
    
            IF  RETURN-VALUE = "NOK":U THEN
                RETURN.
        END.

        /*BO mla-lotacao*/
        RUN inbo/boin772.p PERSISTENT SET h-boin772.

        IF SUBSTRING(param-compra.char-2, 7, 3) = "sim":U THEN DO:
            
            RUN cdp/cdapi173.p (INPUT  4,
                                INPUT  ordem-compra.it-codigo,
                                INPUT  pedido-compr.responsavel,
                                OUTPUT l-retorno-aprov).
            
            RUN lap/mlaapi099.p (INPUT 4).

            IF l-mla-ativo AND RETURN-VALUE <> "NOK":U THEN DO:
                
                ASSIGN de-valor-total = 0.

                FOR EACH b-ordem-compra
                   WHERE b-ordem-compra.num-pedido = pedido-compr.num-pedido
                     AND (b-ordem-compra.situacao  = 2 OR b-ordem-compra.situacao = 6) NO-LOCK: /* 2 - Confirmada, 6 - Recebida */

                    FOR EACH b-prazo-compra
                       WHERE b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem NO-LOCK:

                        ASSIGN de-qt-saldo = de-qt-saldo + b-prazo-compra.quant-saldo.
                    END.

                    /* Calculo do Valor da Cotaáao */
                    FIND FIRST cotacao-item 
                         WHERE cotacao-item.numero-ordem = b-ordem-compra.numero-ordem 
                           AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.

                    IF AVAIL cotacao-item THEN DO:
                        IF  cotacao-item.mo-codigo = 0 THEN
                            ASSIGN de-cotacao = 1.
                        ELSE DO:
                             RUN cdp/cd0812.p (INPUT cotacao-item.mo-codigo,
                                               INPUT 0,
                                               INPUT 1,
                                               INPUT cotacao-item.data-cotacao,
                                               OUTPUT de-cotacao).

                             IF de-cotacao = ? THEN
                                 ASSIGN de-cotacao = 1.
                        END.
                    END.

                    ASSIGN de-valor-total = de-valor-total + (b-ordem-compra.preco-unit * de-qt-saldo * de-cotacao)
                           de-qt-saldo    = 0.
                END.

                IF AVAIL pedido-compr AND pedido-compr.cod-estab-gestor <> "" THEN
                    ASSIGN c-estabelecimento = pedido-compr.cod-estab-gestor.
                ELSE
                    ASSIGN c-estabelecimento = ordem-compra.cod-estabel.

                ASSIGN de-valor-item  = ordem-compra.qt-acum-nec * cotacao-item.preco-unit * de-cotacao.

                RUN lap/mlaapi173.p (INPUT  4,
                                     INPUT  ordem-compra.it-codigo,
                                     INPUT  pedido-compr.responsavel,
                                     INPUT  ordem-compra.ct-codigo,
                                     INPUT  STRING(pedido-compr.cod-emitente),
                                     INPUT  ordem-compra.sc-codigo,
                                     INPUT  de-valor-item,
                                     INPUT  de-valor-total,
                                     INPUT  c-estabelecimento,
                                     OUTPUT TABLE tt-erro).

                IF  RETURN-VALUE = "NOK":U THEN DO:
                    FIND FIRST tt-erro NO-ERROR.
                    IF AVAIL tt-erro THEN DO:
                        {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="tt-erro.c-param"}

                        RETURN "NOK":U.
                    END.
                END.
            END.
        END. /* param-compra.char-2 = SIM */
        ELSE DO:
            RUN cdp/cdapi173.p (INPUT  4,
                                INPUT  ordem-compra.it-codigo,
                                INPUT  ordem-compra.cod-comprado,
                                OUTPUT l-retorno-aprov).

            RUN lap/mlaapi099.p (INPUT 4).
            
            IF l-mla-ativo AND RETURN-VALUE <> "NOK":U THEN DO:
                
                ASSIGN de-valor-total = 0.

                FOR EACH b-ordem-compra
                   WHERE b-ordem-compra.num-pedido = pedido-compr.num-pedido
                     AND (b-ordem-compra.situacao  = 2 OR b-ordem-compra.situacao = 6) NO-LOCK: /* 2 - Confirmada, 6 - Recebida */

                    FOR EACH b-prazo-compra
                       WHERE b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem NO-LOCK:
                        ASSIGN de-qt-saldo = de-qt-saldo + b-prazo-compra.quant-saldo.
                    END.
                    
                    /* Calculo do Valor da Cotaáao */
                    FIND FIRST cotacao-item 
                         WHERE cotacao-item.numero-ordem = b-ordem-compra.numero-ordem 
                           AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.

                    IF AVAIL cotacao-item THEN DO:
                        IF cotacao-item.mo-codigo = 0 THEN
                            ASSIGN de-cotacao = 1.
                        ELSE DO:
                             RUN cdp/cd0812.p (INPUT  cotacao-item.mo-codigo,
                                               INPUT  0,
                                               INPUT  1,
                                               INPUT  cotacao-item.data-cotacao,
                                               OUTPUT de-cotacao).

                             IF de-cotacao = ? THEN
                                 ASSIGN de-cotacao = 1.
                        END.
                    END.
                    
                    ASSIGN de-valor-total = de-valor-total + (b-ordem-compra.preco-unit * de-qt-saldo * de-cotacao)
                           de-qt-saldo    = 0.
                END.

                IF AVAIL pedido-compr AND pedido-compr.cod-estab-gestor <> "":U THEN
                    ASSIGN c-estabelecimento = pedido-compr.cod-estab-gestor.
                ELSE
                    ASSIGN c-estabelecimento = ordem-compra.cod-estabel.

                ASSIGN de-valor-item  = ordem-compra.qt-acum-nec * cotacao-item.preco-unit * de-cotacao.

                RUN buscaLotacaoUsuarOrig IN h-boin772(INPUT 6, /*Pedido Compra Item - C¢digo no MLA*/
                                                       INPUT ordem-compra.nr-requisicao,
                                                       INPUT ordem-compra.cod-comprado,
                                                       OUTPUT c-lotacao).
                IF c-lotacao = "":U THEN
                    ASSIGN c-lotacao = ordem-compra.sc-codigo.
                
                RUN lap/mlaapi173.p (INPUT  4,
                                     INPUT  ordem-compra.it-codigo,
                                     INPUT  ordem-compra.cod-comprado,
                                     INPUT  ordem-compra.ct-codigo,
                                     INPUT  STRING(pedido-compr.cod-emitente),
                                     INPUT  c-lotacao,
                                     INPUT  de-valor-item,
                                     INPUT  de-valor-total,
                                     INPUT  c-estabelecimento,
                                     OUTPUT TABLE tt-erro).

                IF RETURN-VALUE = "NOK":U THEN DO:
                    FIND FIRST tt-erro NO-ERROR.
                    IF  AVAIL tt-erro THEN DO:
                        {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="tt-erro.c-param"}

                        RETURN "NOK":U.
                    END.
                END.
            END.
        END.
        IF NOT l-retorno-aprov THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="15661"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    ELSE DO:

        IF NOT AVAIL param-compra THEN
            FIND FIRST param-compra NO-LOCK NO-ERROR.

        IF param-compra.log-1 AND AVAIL pedido-compr AND AVAIL ordem-compra THEN DO:
            
            RUN lap/mlaapi099.p (INPUT IF pedido-compr.emergencial THEN 6 ELSE 4).

            IF l-mla-ativo AND RETURN-VALUE <> "NOK":U THEN DO:
                
                FIND FIRST mla-param-aprov
                     WHERE mla-param-aprov.ep-codigo   = i-ep-codigo-usuario
                       AND mla-param-aprov.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
                
                /* Tratamento realizado para o envio de e-mail quando se tem o parametro cond pagto e valor marcado*/
                IF  c-tipo-trans = "choose-bt-ok":U 
                AND AVAIL mla-param-aprov 
                AND mla-param-aprov.log-cond-pagto 
                AND param-aprov.aprov-total-pedido THEN DO:

                    IF pedido-compr.emergencial THEN
                        RUN cdp/cdapi171.p (6,1,ROWID(ordem-compra)).
                    ELSE
                        RUN cdp/cdapi171.p (4,1,ROWID(ordem-compra)).
                END.
                ELSE DO:
                    IF pedido-compr.emergencial THEN
                        RUN cdp/cdapi171.p (6,2,ROWID(ordem-compra)).
                    ELSE
                        RUN cdp/cdapi171.p (4,2,ROWID(ordem-compra)).
                END.
            END.
            ELSE DO:
                
                IF pedido-compr.emergencial THEN
                    RUN cdp/cdapi171.p (6,2,ROWID(ordem-compra)).
                ELSE
                    RUN cdp/cdapi171.p (4,2,ROWID(ordem-compra)).
            END.

            RUN retornaMsgAprovacao (ROWID(ordem-compra)).
        END.
    END.

    /*BO mla-lotacao*/
    IF VALID-HANDLE(h-boin772) THEN DO:
        DELETE PROCEDURE h-boin772.
        ASSIGN h-boin772 = ?.
    END.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     /* beforeexecuteCreate */
               Atualiza a tabela pedido-compr, de acordo com a necessidade de se
			    manter um flag de pendencia na cria?Oo de ordens de compra.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    /* --- Avaliaá∆o de Fornecedores nas Listas - In°cio - */
    RUN cdp/cd0032.p ( OUTPUT l-graos-ativo ).
    IF  l-graos-ativo THEN DO:
        IF NOT VALID-HANDLE(h-ggapi106) THEN
           RUN ggp/ggapi106.p PERSISTENT SET h-ggapi106.

        /* --- Se o M¢dulo de Gr∆os estiver Ativo, efetua avaliaá∆o de fornecedores nas listas - */
        RUN piAvaliarListaFornecedores IN h-ggapi106 ( INPUT  4, /* --- Pedido de Compras (gginc/i01gg00726) - */
                                                       INPUT  RowObject.cod-emitente,
                                                       INPUT  "- Inclus∆o Pedido de Compra via CC0300":U,
                                                       OUTPUT TABLE tt-erro-ggapi106 ).

        FOR EACH tt-erro-ggapi106:
             {method/svc/errors/inserr.i &ErrorNumber=tt-erro-ggapi106.cd-erro
                                         &ErrorType="EMS"
                                         &ErrorSubType=IF tt-erro-ggapi106.cd-erro = 56450 THEN "WARNING" ELSE "ERROR"
                                         &ErrorParameters=tt-erro-ggapi106.mensagem}
        END.

        DELETE PROCEDURE h-ggapi106.
        ASSIGN h-ggapi106 = ?.
    END.
    /* --- Avaliaá∆o de Fornecedores nas Listas - Fim - */


    /* Condicional de valida?Oo da necessidade de se manter o registro do 
	  pedido de compra via altera?Oo de uma flag no campo char-1. */
	  
	IF l-flex-lastOrder = YES THEN DO:
		IF l-lastOrder = YES THEN 
			ASSIGN OVERLAY(rowObject.char-1,58,1) = "S":U.
		ELSE 
			ASSIGN OVERLAY(rowObject.char-1,58,1) = "N":U.	
	END.

    ASSIGN RowObject.cod-usuar-criac = v_cod_usuar_corren
           RowObject.cod-usuar-alter = v_cod_usuar_corren
           RowObject.dat-criac       = TODAY
           RowObject.hra-criac       = REPLACE(STRING(TIME, "HH:MM:SS":U), ":":U, "":U)
           RowObject.dat-alter       = TODAY
           RowObject.hra-alter       = REPLACE(STRING(TIME, "HH:MM:SS":U), ":":U, "":U).
                              	
	RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lFlexLastOrder DBOProgram
PROCEDURE lFlexLastOrder :
/*------------------------------------------------------------------------------
  Purpose:     Verifica a necessidade de manter o pedido de compra pendente,
			   quando o mesmo estiver em edi?Oo pela tela flex.
  Parameters:  Flag do flex para manter o pedido pendente, flag do flex que 
			   define se a ordem adicionada È a ultima intera?Oo do pedido.
  Notes:
------------------------------------------------------------------------------*/
	DEFINE INPUT PARAMETER p-flex-lastOrder AS LOGICAL NO-UNDO.
	DEFINE INPUT PARAMETER p-lastOrder		AS LOGICAL NO-UNDO.
	
	ASSIGN l-flex-lastOrder = p-flex-lastOrder
		   l-lastOrder		= p-lastOrder.
		   
	
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE groupRequisitionsToCreateOrder DBOProgram
PROCEDURE groupRequisitionsToCreateOrder :
/*------------------------------------------------------------------------------
  Purpose: agrupa ordens cotada conforme a regra de neg¢cio gerar pedido de compra.
  Parameters: Comprador, normalmente Ç o usu†rio logado
              ordens selecionadas na tela, se houver.  Se nao houver ele considera todas
              temp-table com os pedidos que serao criados
              ordens de cada pedido
              Erros: se houverem erros serao apresentados como Advertencia, para permitir gerar os pedidos que puderem ser gerados.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-comprado LIKE comprador.cod-comprado NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-digita.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-pedidos.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-ordens.

    DEFINE VARIABLE c-msg            AS   CHARACTER                 NO-UNDO.
    DEFINE VARIABLE c-return         AS   CHARACTER                 NO-UNDO.
    DEFINE VARIABLE dt-vig-ini       AS   DATE                      NO-UNDO.
    DEFINE VARIABLE dt-vig-fim       AS   DATE                      NO-UNDO.
    DEFINE VARIABLE de-cotacao       AS   DECIMAL DECIMALS 9        NO-UNDO.
    DEFINE VARIABLE de-valor-item    AS   DECIMAL                   NO-UNDO.
    DEFINE VARIABLE de-valor-total   AS   DECIMAL                   NO-UNDO.
    DEFINE VARIABLE cont             AS   INTEGER                   NO-UNDO.
    DEFINE VARIABLE i-situacao       AS   INTEGER                   NO-UNDO.
    DEFINE VARIABLE l-erro           AS   LOGICAL                   NO-UNDO.
    DEFINE VARIABLE c-comprado-aprov LIKE comprador.cod-comprado    NO-UNDO.

    FIND FIRST param-compra NO-LOCK NO-ERROR.
    FIND FIRST param-aprov  NO-LOCK NO-ERROR.

    EMPTY TEMP-TABLE tt-erro.

    RUN cdp/cdapi029.p PERSISTENT SET h-cdapi029 (INPUT  c-seg-usuario,
                                                  INPUT  0,
                                                  INPUT  ?,
                                                  INPUT  0,
                                                  OUTPUT i-situacao,
                                                  OUTPUT dt-vig-ini,
                                                  OUTPUT dt-vig-fim,
                                                  OUTPUT TABLE tt-erro).

    FOR EACH tt-digita:

        FIND FIRST ordem-compra 
             WHERE ordem-compra.numero-ordem = tt-digita.numero-ordem NO-LOCK NO-ERROR.

        ASSIGN l-erro         = NO
               de-cotacao     = 1
               de-valor-item  = 0
               de-valor-total = 0.

        IF  AVAIL ordem-compra
        AND ordem-compra.situacao   = 3 /* Cotada */
        AND ordem-compra.num-pedido = 0 THEN DO:
            
            IF  ordem-compra.cod-estab-gestor <> "":U THEN DO:

                /*Ordem so pode ser alterada no estabelecimento gestor.*/
                RUN ccp/ccapi199.p (INPUT  "ordem-compra":U,
                                    INPUT  ROWID(ordem-compra),
                                    OUTPUT l-erro).
                IF l-erro THEN DO:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Ordem_Compra_pode_ser_alterada_somente_no_Estabelecimento_Gestor" *}
                    RUN _insertErrorManual IN THIS-PROCEDURE (INPUT "18200":U,
                                                              INPUT "EMS":U,
                                                              INPUT "Warning":U,
                                                              INPUT RETURN-VALUE + " ":U +
                                                                        ordem-compra.cod-estab-gestor,
                                                              INPUT "":U,
                                                              INPUT "":U).
                    NEXT.
                END.
            END.
            
            RUN pi-verifica-status-emitente IN h-cdapi029 (input c-seg-usuario,
                                                           input 1,
                                                           input TODAY,
                                                           input ordem-compra.cod-emitente,
                                                           output i-situacao,
                                                           output dt-vig-ini,
                                                           output dt-vig-fim,
                                                           output table tt-erro APPEND).
            ASSIGN c-return = RETURN-VALUE.

            IF c-return = "NOK":U THEN DO:
                DELETE tt-digita.
                NEXT.
            END.

            ASSIGN  tt-digita.cod-emitente   = ordem-compra.cod-emitente
                    tt-digita.cod-estabel    = ordem-compra.cod-estabel
                    tt-digita.cod-cond-pag   = ordem-compra.cod-cond-pag
                    tt-digita.cod-transp     = ordem-compra.cod-transp
                    tt-digita.nr-processo    = ordem-compra.nr-processo
                    tt-digita.natureza       = ordem-compra.natureza
                    tt-digita.frete          = ordem-compra.frete
                    tt-digita.it-codigo      = ordem-compra.it-codigo
                    tt-digita.qt-solic       = ordem-compra.qt-solic.
        END.
        ELSE
            DELETE tt-digita.
    END.

    FOR EACH tt-erro:
        RUN _insertErrorManual IN THIS-PROCEDURE (INPUT tt-erro.cd-erro,
                                                  INPUT "EMS":U,
                                                  INPUT "WARNING":U,
                                                  INPUT tt-erro.mensagem,
                                                  INPUT "":U,
                                                  INPUT "":U).
    END.

    FOR EACH tt-digita
        BREAK BY tt-digita.cod-emitente
              BY tt-digita.cod-estabel
              BY tt-digita.cod-cond-pag
              BY tt-digita.cod-transp
              BY tt-digita.nr-processo
              BY tt-digita.natureza
              BY tt-digita.frete:
        
        IF FIRST-OF (tt-digita.cod-emitente) OR
           FIRST-OF (tt-digita.cod-estabel ) OR
           FIRST-OF (tt-digita.cod-cond-pag) OR
           FIRST-OF (tt-digita.cod-transp  ) OR
           FIRST-OF (tt-digita.nr-processo ) OR
           FIRST-OF (tt-digita.natureza    ) OR
           FIRST-OF (tt-digita.frete       ) THEN DO:
            
            ASSIGN cont = cont + 1.

            IF NO THEN
                FIND FIRST emitente NO-LOCK NO-ERROR.

            IF NOT AVAIL emitente OR emitente.cod-emitente <> tt-digita.cod-emitente THEN
                FIND FIRST emitente
                     WHERE emitente.cod-emitente = tt-digita.cod-emitente NO-LOCK NO-ERROR.

            CREATE tt-pedidos.
            ASSIGN tt-pedidos.cod-emitente = tt-digita.cod-emitente
                   tt-pedidos.nome-abrev   = IF AVAIL emitente THEN emitente.nome-abrev ELSE "":U
                   tt-pedidos.cod-estabel  = tt-digita.cod-estabel
                   tt-pedidos.cod-cond-pag = tt-digita.cod-cond-pag
                   tt-pedidos.cod-transp   = tt-digita.cod-transp
                   tt-pedidos.nr-processo  = tt-digita.nr-processo
                   tt-pedidos.natureza     = tt-digita.natureza
                   tt-pedidos.frete        = tt-digita.frete
                   tt-pedidos.num-pedido   = cont.   /* n˙mero do pedido apenas para controle interno,
                                                                     nOo ser· o n˙mero do pedido criado na base de dados */
        END.

        CREATE tt-ordens.
        ASSIGN tt-ordens.cod-emitente = tt-digita.cod-emitente
               tt-ordens.numero-ordem = tt-digita.numero-ordem
               tt-ordens.cod-estabel  = tt-digita.cod-estabel
               tt-ordens.cod-cond-pag = tt-digita.cod-cond-pag
               tt-ordens.cod-transp   = tt-digita.cod-transp
               tt-ordens.nr-processo  = tt-digita.nr-processo
               tt-ordens.natureza     = tt-digita.natureza
               tt-ordens.frete        = tt-digita.frete
               tt-ordens.it-codigo    = tt-digita.it-codigo
               tt-ordens.qt-solic     = tt-digita.qt-solic
               tt-ordens.num-pedido   = cont.        /* n˙mero do pedido apenas para controle interno,
                                                             nOo ser· o n˙mero do pedido criado na base de dados */
    END.

    DELETE PROCEDURE h-cdapi029.
    ASSIGN h-cdapi029 = ?.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aprovEletronicaDeletePedido DBOProgram
PROCEDURE aprovEletronicaDeletePedido :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-pedido AS INTEGER NO-UNDO.

    /*--- Elimina pendencias de aprovaáao ---*/
    IF NOT AVAIL param-compra THEN
        FIND FIRST param-compra NO-LOCK NO-ERROR.

    FOR FIRST bf{&TableName} FIELDS(emergencial)
        WHERE bf{&TableName}.num-pedido = p-num-pedido NO-LOCK:

		FOR EACH ordem-compra FIELDS()
		   WHERE ordem-compra.num-pedido = p-num-pedido NO-LOCK:

			IF bf{&TableName}.emergencial THEN
                RUN cdp/cdapi171.p (6,3,ROWID(ordem-compra)).
			ELSE
				RUN cdp/cdapi171.p (4,3,ROWID(ordem-compra)).
		END.
    END.

    /*Quando for eliminar o pedido, dever· eliminar as pendÍncias de aprovaÁ„o e histÛrico - MLA*/
    RUN lap/mlaapi099.p (INPUT 0).

    IF l-mla-ativo AND RETURN-VALUE <> "NOK":U THEN DO:

        FIND FIRST param-aprov 
             WHERE param-aprov.aprov-total-pedido = YES NO-LOCK NO-ERROR.

        IF AVAIL param-aprov THEN DO:
            
            IF NOT CAN-FIND (FIRST bf{&TableName}
                             WHERE bf{&TableName}.num-pedido = p-num-pedido) THEN

                FOR EACH mla-doc-pend-aprov
                   WHERE mla-doc-pend-aprov.chave-doc = STRING(p-num-pedido) EXCLUSIVE-LOCK:
                    DELETE mla-doc-pend-aprov.
                END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aprovEletronicaDeletePedidoRowid DBOProgram
PROCEDURE aprovEletronicaDeletePedidoRowid :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-rowid-pedido AS ROWID NO-UNDO.

    FIND FIRST pedido-compr
         WHERE ROWID(pedido-compr) = p-rowid-pedido NO-LOCK NO-ERROR.

    IF AVAIL pedido-compr THEN
       RUN aprovEletronicaDeletePedido (INPUT pedido-compr.num-pedido).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aprovUpdatePedido DBOProgram
PROCEDURE aprovUpdatePedido :
/*------------------------------------------------------------------------------
  Notes: Esta procedure e executada quando for alterado no pedido de
         compra(cc0300a) os campos end-entrega, cod-cond-pag ou responsavel.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prOrdemCompra AS ROWID NO-UNDO.

    DEFINE VARIABLE c-lotacao     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE h-boin772     AS HANDLE     NO-UNDO.
    DEFINE VARIABLE l-emergencial as LOGICAL    NO-UNDO.
    
    /***** Aprovaáao Eletrìnica ****/
    IF NOT AVAIL param-aprov THEN
        FIND FIRST param-aprov NO-LOCK NO-ERROR.

    /***** Aprovaáao Eletrìnica ****/
    FOR FIRST ordem-compra FIELDS(numero-ordem num-pedido ct-codigo sc-codigo cod-estabel) 
        WHERE ROWID(ordem-compra) = prOrdemCompra NO-LOCK: END.

    FOR FIRST pedido-compr FIELDS(cod-emitente num-pedido emergencial cod-emitente cod-estab-gestor) 
        WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.

    IF  AVAIL param-aprov  AND
        param-compra.log-1 AND
        AVAIL ordem-compra AND
        AVAIL pedido-compr THEN DO:
        
        /*BO mla-lotacao*/
         RUN inbo/boin772.p PERSISTENT SET h-boin772.

        ASSIGN l-emergencial = IF pedido-compr.emergencial THEN YES ELSE NO.

        IF SUBSTRING(param-compra.char-2, 7, 3) = "sim":U THEN DO:
            IF l-emergencial  THEN DO:

                RUN cdp/cdapi173.p (INPUT  6,
                                    INPUT  ordem-compra.it-codigo,
                                    INPUT  pedido-compr.responsavel,
                                    OUTPUT l-retorno-aprov).

                 RUN lap/mlaapi099.p (INPUT 6).

                 IF l-mla-ativo AND RETURN-VALUE <> "NOK":U THEN DO:

                    ASSIGN de-valor-total = 0.

                    FOR EACH b-ordem-compra
                       WHERE b-ordem-compra.num-pedido = pedido-compr.num-pedido
                         AND (b-ordem-compra.situacao  = 2 OR b-ordem-compra.situacao = 6) NO-LOCK: /* 2 - Confirmada, 6 - Recebida */

                            FOR EACH b-prazo-compra
                               WHERE b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem NO-LOCK:
                                ASSIGN de-qt-saldo = de-qt-saldo + b-prazo-compra.quant-saldo.
                            END.

                            /* Calculo do Valor da Cotaáao */
                            FIND FIRST cotacao-item 
                                 WHERE cotacao-item.numero-ordem = b-ordem-compra.numero-ordem 
                                   AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.

                            IF AVAIL cotacao-item THEN DO:

                                IF  cotacao-item.mo-codigo = 0 THEN
                                    ASSIGN de-cotacao = 1.
                                ELSE DO:
                                     RUN cdp/cd0812.p (input cotacao-item.mo-codigo,
                                                       input 0,
                                                       input 1,
                                                       input cotacao-item.data-cotacao,
                                                       output de-cotacao).
                                     if  de-cotacao = ? then
                                         assign de-cotacao = 1.
                                end.
                            END.

                            ASSIGN de-valor-total = de-valor-total + (b-ordem-compra.preco-unit * de-qt-saldo * de-cotacao)
                                   de-qt-saldo    = 0.
                    END.

                    IF AVAIL pedido-compr AND pedido-compr.cod-estab-gestor <> "":U THEN
                        ASSIGN c-estabelecimento = pedido-compr.cod-estab-gestor.
                    ELSE
                        ASSIGN c-estabelecimento = ordem-compra.cod-estabel.

                    ASSIGN de-valor-item  = ordem-compra.qt-acum-nec * cotacao-item.preco-unit * de-cotacao.

                    RUN lap/mlaapi173.p (INPUT 6,
                                         INPUT ordem-compra.it-codigo,
                                         INPUT pedido-compr.responsavel,
                                         INPUT ordem-compra.ct-codigo,
                                         INPUT STRING(pedido-compr.cod-emitente),
                                         INPUT ordem-compra.sc-codigo,
                                         INPUT de-valor-item,
                                         INPUT de-valor-total,
                                         INPUT c-estabelecimento,
                                         OUTPUT TABLE tt-erro).

                    IF RETURN-VALUE = "NOK":U THEN DO:
                        FIND FIRST tt-erro NO-ERROR.
                        IF AVAIL tt-erro THEN DO:
                            {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U
                                                        &ErrorParameters="tt-erro.c-param"}

                            RETURN "NOK":U.
                        END.
                    END.
                 END.
            END.
            ELSE DO:
                RUN cdp/cdapi173.p (INPUT  4,
                                    INPUT  ordem-compra.it-codigo,
                                    INPUT  pedido-compr.responsavel,
                                    OUTPUT l-retorno-aprov).

                RUN lap/mlaapi099.p (INPUT 4).

                IF l-mla-ativo AND RETURN-VALUE <> "NOK":U THEN DO:
                    
                    ASSIGN de-valor-total = 0.
                    
                    FOR EACH b-ordem-compra
                       WHERE b-ordem-compra.num-pedido = pedido-compr.num-pedido
                         AND (b-ordem-compra.situacao   = 2 OR b-ordem-compra.situacao   = 6) NO-LOCK: /* 2 - Confirmada, 6 - Recebida */

                        FOR EACH b-prazo-compra
                            WHERE b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem NO-LOCK:
                            ASSIGN de-qt-saldo = de-qt-saldo + b-prazo-compra.quant-saldo.
                        END.
                     
                        /* Calculo do Valor da Cotaáao */
                        FIND FIRST cotacao-item 
                             WHERE cotacao-item.numero-ordem = b-ordem-compra.numero-ordem 
                               AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.

                        IF AVAIL cotacao-item THEN DO:
                            IF cotacao-item.mo-codigo = 0 THEN
                                ASSIGN de-cotacao = 1.
                            ELSE DO:
                                 RUN cdp/cd0812.p (INPUT cotacao-item.mo-codigo,
                                                   INPUT 0,
                                                   INPUT 1,
                                                   INPUT cotacao-item.data-cotacao,
                                                   OUTPUT de-cotacao).
                                 IF de-cotacao = ? THEN
                                     ASSIGN de-cotacao = 1.
                            END.
                        END.
                     
                        ASSIGN de-valor-total = de-valor-total + (b-ordem-compra.preco-unit * de-qt-saldo * de-cotacao)
                               de-qt-saldo    = 0.
                   END.

                   IF AVAIL pedido-compr AND pedido-compr.cod-estab-gestor <> "":U THEN
                       ASSIGN c-estabelecimento = pedido-compr.cod-estab-gestor.
                   ELSE
                       ASSIGN c-estabelecimento = ordem-compra.cod-estabel.

                   ASSIGN de-valor-item  = ordem-compra.qt-acum-nec * cotacao-item.preco-unit * de-cotacao.
                   
                   RUN lap/mlaapi173.p (INPUT  4,
                                        INPUT  ordem-compra.it-codigo,
                                        INPUT  pedido-compr.responsavel,
                                        INPUT  ordem-compra.ct-codigo,
                                        INPUT  STRING(pedido-compr.cod-emitente),
                                        INPUT  ordem-compra.sc-codigo,
                                        INPUT  de-valor-item,
                                        INPUT  de-valor-total,
                                        INPUT  c-estabelecimento,
                                        OUTPUT TABLE tt-erro).

                   IF RETURN-VALUE = "NOK":U THEN DO:
                       FIND FIRST tt-erro NO-ERROR.
                       IF AVAIL tt-erro THEN DO:
                           {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                                       &ErrorType="EMS":U
                                                       &ErrorSubType="ERROR":U
                                                       &ErrorParameters="tt-erro.c-param"}

                           RETURN "NOK":U.
                       END.
                   END.
                END.
            END.
        END.
        ELSE DO:
             IF l-emergencial THEN DO:

                 RUN cdp/cdapi173.p (INPUT  6,
                                     INPUT  ordem-compra.it-codigo,
                                     INPUT  ordem-compra.cod-comprado,
                                     OUTPUT l-retorno-aprov).

                 RUN lap/mlaapi099.p (INPUT 6).

                 IF l-mla-ativo AND RETURN-VALUE <> "NOK":U THEN DO:

                    ASSIGN de-valor-total = 0.

                    FOR EACH  b-ordem-compra
                       WHERE b-ordem-compra.num-pedido = pedido-compr.num-pedido
                         AND (b-ordem-compra.situacao  = 2 OR b-ordem-compra.situacao   = 6) NO-LOCK: /* 2 - Confirmada, 6 - Recebida */

                        FOR EACH b-prazo-compra
                           WHERE b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem NO-LOCK:
                            ASSIGN de-qt-saldo = de-qt-saldo + b-prazo-compra.quant-saldo.
                        END.

                        /* Calculo do Valor da Cotaáao */
                        FIND FIRST cotacao-item 
                             WHERE cotacao-item.numero-ordem = b-ordem-compra.numero-ordem 
                               AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.

                        IF AVAIL cotacao-item THEN DO:
                            IF cotacao-item.mo-codigo = 0 THEN
                                ASSIGN de-cotacao = 1.
                            ELSE DO:
                                 RUN cdp/cd0812.p (INPUT cotacao-item.mo-codigo,
                                                   INPUT 0,
                                                   INPUT 1,
                                                   INPUT cotacao-item.data-cotacao,
                                                   OUTPUT de-cotacao).

                                 IF de-cotacao = ? THEN
                                     ASSIGN de-cotacao = 1.
                            END.
                        END.
                        ASSIGN de-valor-total = de-valor-total + (b-ordem-compra.preco-unit * de-qt-saldo * de-cotacao)
                               de-qt-saldo    = 0.
                    END.

                    IF AVAIL pedido-compr AND pedido-compr.cod-estab-gestor <> "":U THEN
                        ASSIGN c-estabelecimento = pedido-compr.cod-estab-gestor.
                    ELSE
                        ASSIGN c-estabelecimento = ordem-compra.cod-estabel.

                    ASSIGN de-valor-item  = ordem-compra.qt-acum-nec * cotacao-item.preco-unit * de-cotacao.

                    RUN buscaLotacaoUsuarOrig IN h-boin772(INPUT 19, /*Pedido Emergencial Item - C¢digo no MLA*/
                                                           INPUT ordem-compra.nr-requisicao,
                                                           INPUT ordem-compra.cod-comprado,
                                                           OUTPUT c-lotacao).
                    IF c-lotacao = "":U THEN
                        ASSIGN c-lotacao = ordem-compra.sc-codigo.

                    RUN lap/mlaapi173.p (INPUT  6,
                                         INPUT  ordem-compra.it-codigo,
                                         INPUT  ordem-compra.cod-comprado,
                                         INPUT  ordem-compra.ct-codigo,
                                         INPUT  STRING(pedido-compr.cod-emitente),
                                         INPUT  c-lotacao,
                                         INPUT  de-valor-item,
                                         INPUT  de-valor-total,
                                         INPUT  c-estabelecimento,
                                         OUTPUT TABLE tt-erro).

                    IF RETURN-VALUE = "NOK":U THEN DO:
                        FIND FIRST tt-erro NO-ERROR.
                        IF AVAIL tt-erro THEN DO:
                            {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U
                                                        &ErrorParameters="tt-erro.c-param"}

                           RETURN "NOK":U.
                        END.
                    END.
                 END.
             END.
             ELSE DO:
                 RUN cdp/cdapi173.p (INPUT  4,
                                     INPUT  ordem-compra.it-codigo,
                                     INPUT  ordem-compra.cod-comprado,
                                     OUTPUT l-retorno-aprov).
                 
                 RUN lap/mlaapi099.p (INPUT 4).

                 IF l-mla-ativo AND RETURN-VALUE <> "NOK":U THEN DO:
                     
                     ASSIGN de-valor-total = 0.

                     FOR EACH  b-ordem-compra
                        WHERE b-ordem-compra.num-pedido = pedido-compr.num-pedido
                          AND (b-ordem-compra.situacao   = 2 or b-ordem-compra.situacao   = 6) NO-LOCK: /* 2 - Confirmada, 6 - Recebida */

                         FOR EACH b-prazo-compra
                            WHERE b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem NO-LOCK:
                             ASSIGN de-qt-saldo = de-qt-saldo + b-prazo-compra.quant-saldo.
                         END.

                         /* Calculo do Valor da Cotaáao */
                         FIND FIRST cotacao-item 
                              WHERE cotacao-item.numero-ordem = b-ordem-compra.numero-ordem 
                                AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.

                         IF AVAIL cotacao-item THEN DO:
                             IF cotacao-item.mo-codigo = 0 THEN
                                 ASSIGN de-cotacao = 1.
                             ELSE DO:
                                  RUN cdp/cd0812.p (INPUT cotacao-item.mo-codigo,
                                                    INPUT 0,
                                                    INPUT 1,
                                                    INPUT cotacao-item.data-cotacao,
                                                    OUTPUT de-cotacao).

                                  IF  de-cotacao = ? THEN
                                      ASSIGN de-cotacao = 1.
                             END.
                         END.
                         ASSIGN de-valor-total = de-valor-total + (b-ordem-compra.preco-unit * de-qt-saldo * de-cotacao)
                                de-qt-saldo    = 0.
                     END.

                     IF AVAIL pedido-compr AND pedido-compr.cod-estab-gestor <> "":U THEN
                         ASSIGN c-estabelecimento = pedido-compr.cod-estab-gestor.
                     ELSE
                         ASSIGN c-estabelecimento = ordem-compra.cod-estabel.

                     ASSIGN de-valor-item  = ordem-compra.qt-acum-nec * cotacao-item.preco-unit * de-cotacao.

                     RUN buscaLotacaoUsuarOrig IN h-boin772(INPUT  6, /*Pedido Compra Item - C¢digo no MLA*/
                                                            INPUT  ordem-compra.nr-requisicao,
                                                            INPUT  ordem-compra.cod-comprado,
                                                            OUTPUT c-lotacao).
                     IF c-lotacao = "":U THEN
                         ASSIGN c-lotacao = ordem-compra.sc-codigo.

                     RUN lap/mlaapi173.p (INPUT  4,
                                          INPUT  ordem-compra.it-codigo,
                                          INPUT  ordem-compra.cod-comprado,
                                          INPUT  ordem-compra.ct-codigo,
                                          INPUT  STRING(pedido-compr.cod-emitente),
                                          INPUT  c-lotacao,
                                          INPUT  de-valor-item,
                                          INPUT  de-valor-total,
                                          INPUT  c-estabelecimento,
                                          OUTPUT TABLE tt-erro).

                     IF RETURN-VALUE = "NOK":U THEN DO:
                         FIND FIRST tt-erro NO-ERROR.
                         IF AVAIL tt-erro THEN DO:
                             {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                                         &ErrorType="EMS":U
                                                         &ErrorSubType="ERROR":U
                                                         &ErrorParameters="tt-erro.c-param"}
                            RETURN "NOK":U.
                         END.
                     END.
                 END.
             END.
        END.
        IF NOT l-retorno-aprov THEN DO:
             {method/svc/errors/inserr.i &ErrorNumber="15661"
                                         &ErrorType="EMS":U
                                         &ErrorSubType="ERROR":U}
        END.

        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.
        IF  param-aprov.aprov-total-pedido THEN DO:

            IF CAN-FIND(FIRST cotacao-item 
                        WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                          AND cotacao-item.cot-aprovada = YES) THEN DO:

                IF l-emergencial AND param-aprov.aprova-emerg THEN DO:

                    RUN cdp/cdapi171.p (6,2,prOrdemCompra) NO-ERROR.    /* Emergencial */
                    RUN retornaMsgAprovacao (prOrdemCompra). /* retorna rowErrors */
                END.
                ELSE
                    IF NOT l-emergencial AND param-aprov.aprova-pedido THEN DO:
                        RUN cdp/cdapi171.p (4,2,prOrdemCompra) NO-ERROR.
                        RUN retornaMsgAprovacao (prOrdemCompra). /* retorna rowErrors */
                    END.
                    ELSE DO:
                       {method/svc/errors/inserr.i
                                          &ErrorNumber="16760"
                                          &ErrorType="EMS"
                                          &ErrorSubType="ERROR"}
                    END.
            END.
        END.
        ELSE DO:
            FOR EACH  ordem-compra
               WHERE ordem-compra.num-pedido = pedido-compr.num-pedido 
                 AND (ordem-compra.situacao  = 2 OR ordem-compra.situacao  = 6) NO-LOCK: /* 2 - Confirmada, 6 - Recebida */

                IF CAN-FIND(FIRST cotacao-item 
                            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                              AND cotacao-item.cot-aprovada = YES) THEN DO:

                    IF l-emergencial AND param-aprov.aprova-emerg THEN DO:
                        
                        RUN cdp/cdapi171.p (6,2,ROWID(ordem-compra)) NO-ERROR.    /* Emergencial */
                        RUN retornaMsgAprovacao (ROWID(ordem-compra)). /* retorna rowErrors */
                    END.
                    ELSE
                        IF NOT l-emergencial AND param-aprov.aprova-pedido THEN DO:
                            
                            RUN cdp/cdapi171.p (4,2,ROWID(ordem-compra)) NO-ERROR.
                            RUN retornaMsgAprovacao (ROWID(ordem-compra)). /* retorna rowErrors */
                        END.
                        ELSE DO:
                           {method/svc/errors/inserr.i
                                              &ErrorNumber="16760"
                                              &ErrorType="EMS"
                                              &ErrorSubType="ERROR"}
                        END.
                END.
            END.
        END.
    END.
    ELSE DO:
       {method/svc/errors/inserr.i
                          &ErrorNumber="16760"
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR"}
    END.

    /*BO mla-lotacao*/
    IF VALID-HANDLE(h-boin772) THEN DO:
        DELETE PROCEDURE h-boin772.
        ASSIGN h-boin772 = ?.
    END.

    /*--- Verifica ocorrencia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignImprPedido DBOProgram
PROCEDURE assignImprPedido :
/*------------------------------------------------------------------------------
  PurpoFse: cc0300b
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-pedido  AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-impr-pedido AS LOGICAL NO-UNDO.

    FIND FIRST pedido-compr
         WHERE pedido-compr.num-pedido = p-num-pedido EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL pedido-compr THEN
        ASSIGN pedido-compr.impr-pedido = p-impr-pedido.
    ELSE
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaOrdensCompraPedidoCompra DBOProgram
PROCEDURE atualizaOrdensCompraPedidoCompra :
/*------------------------------------------------------------------------------
  Purpose:    Atualiza ordens dependentes e respectivas cotaáoes
              quando um pedido  de compra Ç atualizado. (wcc0310a)
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    
    /*API de Execucao Orcamentaria*/
    RUN cdp/cdapi197.p (INPUT ?, INPUT ROWID(pedido-compr), INPUT 2, OUTPUT TABLE Rowerrors APPEND).
    
    FOR EACH ordem-compra 
       WHERE ordem-compra.num-pedido  = pedido-compr.num-pedido EXCLUSIVE-LOCK:

        ASSIGN ordem-compra.natureza     = pedido-compr.natureza
               ordem-compra.cod-estabel  = pedido-compr.end-entrega
               ordem-compra.nr-processo  = pedido-compr.nr-processo
               ordem-compra.cod-transp    = pedido-compr.cod-transp
               ordem-compra.cod-cond-pag = pedido-compr.cod-cond-pag.

        FOR EACH prazo-compra 
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:
            ASSIGN prazo-compra.natureza   = pedido-compr.natureza.
        END.
    
        FOR FIRST cotacao-item
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
              AND cotacao-item.cod-emitente = ordem-compra.cod-emitente 
              AND cotacao-item.cot-aprovada = YES EXCLUSIVE-LOCK:
        
            ASSIGN cotacao-item.cod-transp    = pedido-compr.cod-transp
                   cotacao-item.cod-cond-pag = pedido-compr.cod-cond-pag.
        
            CREATE tt-cotacao-aux.
            BUFFER-COPY cotacao-item TO tt-cotacao-aux.
        
            /* Atualizar preáos da cotaáao */
            RUN inbo/boin082ca.p PERSISTENT SET hBoin082ca.
            RUN calculaPrecoUnitFornecedorCotacao IN hBoin082ca (INPUT NO,
                                                                 INPUT cotacao-item.numero-ordem,
                                                                 INPUT-OUTPUT TABLE tt-cotacao-aux).
            /* Nao posso passar tabela do banco como parÉmetro, por usei tt-cotacao-aux */
            DELETE PROCEDURE hBoin082ca.
        
            FIND FIRST tt-cotacao-aux NO-LOCK NO-ERROR.
            BUFFER-COPY tt-cotacao-aux TO cotacao-item.
        
            EMPTY TEMP-TABLE tt-cotacao-aux.
                   
        END.
		RELEASE cotacao-item NO-ERROR.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacaoPedidoCompra DBOProgram
PROCEDURE atualizaSituacaoPedidoCompra :
/*------------------------------------------------------------------------------
  Purpose:    Atualiza dados de situaáao, status emergencial e
              estabelecimento sempre que um registro Ç criado ou
              alterado.
  Parameters: <none>
  Notes:
------------------------------------------------------------------------------*/
    
    IF l-executCreate THEN ASSIGN pedido-compr.situacao = 2.

    /* No update Ç mantida a situaáao atual do pedido */

    ASSIGN pedido-compr.cod-estabel = rowObject.end-entrega.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    {inbo/boin706.i1} /* Executa a boin706.p persistente */
    

    /***   C‡DIGO TRANSFERIDO DA TRIGGER   ***/
    /* A trigger foi desabilitada pois possui ut-msgs com "SHOW" */

    DISABLE TRIGGERS FOR DUMP OF pedido-compr.

    /*** Se o comando acima nao funcionar, usar esse que est† em coment†rio ****
        /* Ignora as Triggers */
        ON WRITE OF pedido-compr OVERRIDE DO:
        END.
    ***/

    RUN ccp/ccPedidoCompraValidaIntegraMe.p PERSISTENT SET h-ccPedidoCompraValidaIntegraMe.
    
    RUN verifica-pedido-compra-me IN h-ccPedidoCompraValidaIntegraMe (INPUT RowObject.num-pedido, OUTPUT isOrderIntegrMe).
    
    IF isOrderIntegrMe THEN DO:
        {method/svc/errors/inserr.i
                          &ErrorNumber="57881"
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR" 
                          &ErrorParameters="string({&TableName}.num-pedido)"}

        RETURN "NOK":U.
    END.
    
    /**************** Essa parte nao estava na trigger *******************/

    FOR FIRST estabelec 
        WHERE estabelec.cod-estabel = pedido-compr.cod-estabel NO-LOCK: END.
    
    ASSIGN i-empresa = estabelec.ep-codigo WHEN AVAIL estabelec.
    /*** Fim Trigger delin295  ***/

    /** Fim das validaáoes de eliminaáao **/

    IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
        
        /** Inicio da eliminaáao em cascata **/

        /** Nao elimine a linha abaixo, Ç a chamada EPC **/
        {include/i-epc102.i pedido-compr}

        IF NOT AVAIL ordem-compra THEN DO:

           FOR EACH ordem-compra 
              WHERE ordem-compra.num-pedido = pedido-compr.num-pedido EXCLUSIVE-LOCK:

               /* atualizacao gerencial abatendo pedidos do dia/mes e carteira */

               FOR EACH prazo-compra 
                  WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:
                   DELETE prazo-compra.
               END.

               FOR EACH cotacao-item 
                  WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:
                   /* For each nas despesas da cotacao para eliminacao */
                   {inbo/boin706.i2}

                   DELETE cotacao-item.
               END.

               DELETE ordem-compra.
           END.

           FOR EACH alt-ped 
              WHERE alt-ped.num-pedido = pedido-compr.num-pedido EXCLUSIVE-LOCK:
               
               DELETE alt-ped.
           END.

           FIND FIRST texto-follow-up WHERE texto-follow-up.num-pedido = pedido-compr.num-pedido EXCLUSIVE-LOCK NO-ERROR.
           IF AVAIL texto-follow-up THEN
               DELETE texto-follow-up.
        END.
        ELSE DO: /*Quantidades nao zeradas*/

           FOR EACH ordem-compra 
              WHERE ordem-compra.num-pedido = pedido-compr.num-pedido EXCLUSIVE-LOCK:

               /* atualizacao gerencial abatendo pedidos dia/mes e carteira */
               FOR EACH prazo-compra 
                  WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:

                   ASSIGN prazo-compra.situacao = 4. /* Eliminada */

                   /*API de Execuáao Oráament†ria*/
                   RUN cdp/cdapi194.p(INPUT ROWID(prazo-compra), INPUT TABLE rowobject, INPUT 5, OUTPUT TABLE rowerrors APPEND).
               END.
               ASSIGN ordem-compra.situacao = 4. /* Eliminada */
           END.

           ASSIGN pedido-compr.situacao = 3.
        END.

        FOR EACH cond-especif 
           WHERE cond-especif.num-pedido = pedido-compr.num-pedido EXCLUSIVE-LOCK:
            DELETE cond-especif.
        END.
    END.
    /*** FIM DO C‡DIGO DA TRIGGER  ***/
    
    {inbo/boin706.i3} /* delete procedure h-boin706 */
    
    /*--- Tratamento fornecedor tempor†rio EMS2.04B(Foresight)---*/
    FOR EACH extra-fornec
       WHERE extra-fornec.num-pedido   = pedido-compr.num-pedido
         AND extra-fornec.nro-docto    = "":U
         AND extra-fornec.nat-operacao = "":U
         AND extra-fornec.serie-docto  = "":U EXCLUSIVE-LOCK:

        DELETE extra-fornec.
    END.

    RETURN "OK":U.
    
    FINALLY:
        DELETE PROCEDURE h-ccPedidoCompraValidaIntegraMe NO-ERROR.
        ASSIGN h-ccPedidoCompraValidaIntegraMe = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:    Executa Update
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
     
  /* Condicional de valida?Oo da necessidade de se manter o registro do 
	  pedido de compra via altera?Oo de uma flag no campo char-1. Leonardo Hermes*/
  	  
	IF l-flex-lastOrder = YES THEN DO:
		IF l-lastOrder = YES THEN 
			ASSIGN OVERLAY(rowObject.char-1,58,1) = "S":U.
		ELSE 
			ASSIGN OVERLAY(rowObject.char-1,58,1) = "N":U.	
	END.
  
    ASSIGN RowObject.cod-usuar-alter = v_cod_usuar_corren
           RowObject.dat-alter       = TODAY
           RowObject.hra-alter       = REPLACE(STRING(TIME, "HH:MM:SS":U), ":":U, "":U).

    FIND FIRST bf-pedido-compr NO-LOCK
         WHERE bf-pedido-compr.num-pedido = RowObject.num-pedido NO-ERROR.

    IF AVAIL bf-pedido-compr THEN DO:
        ASSIGN RowObject.cod-usuar-criac = bf-pedido-compr.cod-usuar-criac
               RowObject.dat-criac       = bf-pedido-compr.dat-criac      
               RowObject.hra-criac       = bf-pedido-compr.hra-criac.          
    END.

    RETURN "OK":U.
    
    FINALLY:
        DELETE PROCEDURE h-ccPedidoCompraValidaIntegraMe NO-ERROR.
        ASSIGN h-ccPedidoCompraValidaIntegraMe = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcComplemPedCompra DBOProgram
PROCEDURE calcComplemPedCompra :
/*------------------------------------------------------------------------------
  Purpose: Tem como objetivo calcular o valor em aberto, o valor em atraso e o valor total do
           pedido de compra conforme a moeda parametrizada. E retornar o n£mero total de ordens,
           a data do £ltimo recebimento e n£mero da £ltima nota fiscal de entrada relacionadas ao pedido.
  Parameters:
  ipar1  : pl-conv-g       : Indica se a data da conversao ser† a data da cotaáao ou a data atual (today).
  ipar2  : pda-conv-g      : Caso o parÉmetro acima seja "data da cotaáao" os valores serao convertidos
                             com base nesta data.
  ipar3  : pi-moeda-g      : Moeda para conversao dos valores.
  opar4  : pi-qtd-ordens   : N£mero de ordens do pedido de compra.
  opar5  : pi-qtd-aberto   : N£mero de ordens em aberto do pedido de compra.
  opar6  : pde-aberto      : Valor em aberto do pedido de compra (valor que falta receber).
  opar7  : pde-atraso      : Valor em atraso do pedido de compra (valor que j† deveria estar recebido).
  opar8  : pde-total       : Valor total do pedido de compra.
  opar9  : pdate-data-movto: Data do £ltimo recebimento do pedido de compra.
  opar10 : pc-numero-nota  : N£mero £ltima nota fiscal recebida.
  opar11 : pc-moeda        : Descriáao da moeda.
  opar12 : pc-transporte   : Nome da transportadora.

  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pl-conv-g        AS LOGICAL                     NO-UNDO.
    DEFINE INPUT  PARAMETER pda-conv-g       AS DATE FORMAT "99/99/9999":U  NO-UNDO.
    DEFINE INPUT  PARAMETER pi-moeda-g       AS INTEGER                     NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-qtd-ordens    AS INTEGER                     NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-qtd-aberto    AS INTEGER                     NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-aberto       AS DECIMAL                     NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-atraso       AS DECIMAL                     NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-total        AS DECIMAL                     NO-UNDO.
    DEFINE OUTPUT PARAMETER pdate-data-movto AS DATE                        NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-numero-nota   AS CHARACTER                   NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-moeda         AS CHARACTER FORMAT "X(10)":U  NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-transporte    AS CHARACTER                   NO-UNDO.

    ASSIGN pi-qtd-ordens = 0
           pi-qtd-aberto = 0
           pde-aberto    = 0
           pde-total     = 0
           pde-atraso    = 0.

    FOR EACH ordem-compra FIELDS(num-pedido situacao numero-ordem data-cotacao mo-codigo preco-unit) USE-INDEX pedido 
       WHERE ordem-compra.num-pedido = pedido-compr.num-pedido 
         AND ordem-compra.situacao <> 4 NO-LOCK: /* Eliminada */
        
        ASSIGN pi-qtd-ordens = pi-qtd-ordens + 1
               l-aberto      = NO.

        FOR EACH prazo-compra FIELDS(numero-ordem quantidade quant-saldo situacao data-entrega) USE-INDEX ordem 
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
            
            IF pl-conv-g THEN
                ASSIGN da-date = ordem-compra.data-cotacao.
            ELSE
                ASSIGN da-date = pda-conv-g.

            IF ordem-compra.mo-codigo = pi-moeda-g THEN
              ASSIGN de-preco-unit = ordem-compra.preco-unit.
            ELSE
               RUN cdp/cd0812.p (INPUT ordem-compra.mo-codigo, 
                                 INPUT pi-moeda-g, 
                                 INPUT ordem-compra.preco-unit,
                                 INPUT da-date,
                                 OUTPUT de-preco-unit).

             IF de-preco-unit = ? THEN
                 ASSIGN de-preco-unit = 0.

             ASSIGN pde-total = pde-total + prazo-compra.quantidade * de-preco-unit.

             IF  prazo-compra.quant-saldo > 0
             AND (prazo-compra.situacao <> 4 AND prazo-compra.situacao <> 6) THEN /* 4 - Eliminada, 6 - Recebida */
                 ASSIGN l-aberto  = YES
                        pde-aberto = pde-aberto + prazo-compra.quant-saldo * de-preco-unit.

             IF prazo-compra.data-entrega < TODAY THEN
                 ASSIGN pde-atraso = pde-atraso + prazo-compra.quant-saldo * de-preco-unit.
         END.
         IF l-aberto THEN
           ASSIGN pi-qtd-aberto = pi-qtd-aberto + 1.
    END.

    IF pde-atraso < 0 THEN
        ASSIGN pde-atraso = 0.

    IF pi-moeda-g = 0 THEN
        ASSIGN pc-moeda = "Corrente":U.
    ELSE
        FOR FIRST moeda FIELDS(mo-codigo descricao) 
            WHERE moeda.mo-codigo = pi-moeda-g NO-LOCK: END.

    IF AVAIL moeda THEN
        ASSIGN pc-moeda = moeda.descricao.

    FOR FIRST transporte FIELDS(cod-transp nome-abrev) 
        WHERE transporte.cod-transp = pedido-compr.cod-transp NO-LOCK: END.

    IF AVAIL transporte THEN
        ASSIGN pc-transporte = transporte.nome-abrev.
    ELSE
        ASSIGN pc-transporte = "":U.

    FOR LAST recebimento FIELDS(num-pedido data-movto numero-nota) 
       WHERE recebimento.num-pedido = pedido-compr.num-pedido NO-LOCK: END.

    IF AVAIL recebimento THEN
        ASSIGN pdate-data-movto = recebimento.data-movto
               pc-numero-nota   = recebimento.numero-nota.
    ELSE
        ASSIGN pdate-data-movto = ?
               pc-numero-nota   = "":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defineAprovEletronicaPedido DBOProgram
PROCEDURE defineAprovEletronicaPedido :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-aprov-eletronica AS LOGICAL NO-UNDO.
    
    DEFINE VARIABLE c-diferencas AS CHARACTER NO-UNDO.

    IF NOT AVAIL rowObject THEN
        RETURN "NOK":U.

    FIND FIRST pedido-compr 
         WHERE ROWID(pedido-compr) = rowObject.r-rowid NO-LOCK NO-ERROR.

    IF NOT AVAIL pedido-compr THEN
        RETURN "NOK":U.

    BUFFER-COMPARE rowObject EXCEPT r-rowid TO pedido-compr
    SAVE RESULT IN c-diferencas.

    /*--- Se foi alterado um dos campos abaixo, submete o pedido a nova aprovacao eletronica ---*/
    IF  rowObject.log-2 = YES                   /* Validaáao usada para alteraáÑes nas parcelas */
    OR  CAN-DO(c-diferencas,"end-entrega":U)
    OR  CAN-DO(c-diferencas,"responsavel":U)
    OR  CAN-DO(c-diferencas,"cod-cond-pag":U)
    OR  CAN-DO(c-diferencas,"cod-estab-gestor":U) THEN
        ASSIGN p-aprov-eletronica = YES.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desfazRelacOrdemPedido DBOProgram
PROCEDURE desfazRelacOrdemPedido :
/*------------------------------------------------------------------------------
  Purpose:     Desfaz o relacionamento da Ordem com o Pedido Compra.
  Parameters:  ipar1  : prOrdem  :  Rowid ordem compra.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prOrdem  AS ROWID  NO-UNDO.

    DEFINE VARIABLE h-boin274vl AS HANDLE  NO-UNDO.
    DEFINE VARIABLE i-cont-prog AS INTEGER NO-UNDO INIT 1.
    DEFINE VARIABLE l-program   AS LOGICAL NO-UNDO INIT NO.

    RUN inbo/boin274vl.p PERSISTENT SET h-boin274vl.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST RowObject    NO-LOCK NO-ERROR.
    FIND FIRST param-compra NO-LOCK NO-ERROR.
    FIND FIRST param-aprov  NO-LOCK NO-ERROR.
     
    IF AVAIL param-compra THEN DO:
        ASSIGN l-aprov-total = SUBSTRING(param-compra.char-2, 7, 3) = "sim":U.
    END.
    
    FOR EACH tt-epc 
       WHERE tt-epc.cod-event = "AlteraCC9019":U:
        DELETE tt-epc.
    END.

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AlteraCC9019":U
           tt-epc.cod-parameter = "gl-prog-cc9019":U.

    {include/i-epc201.i "AlteraCC9019"}

    FIND FIRST tt-epc 
         WHERE tt-epc.cod-event     = "AlteraCC9019":U 
           AND tt-epc.cod-parameter = "Return":U       NO-LOCK NO-ERROR.

    IF AVAIL tt-epc AND tt-epc.val-parameter = "yes":U THEN
        ASSIGN gl-prog-cc9019 = YES.

    RUN lap/mlaapi099.p (INPUT 0).

    IF l-mla-ativo AND RETURN-VALUE <> "NOK":U THEN DO:
        ASSIGN l-integra-mla-total = YES.				
    END.

    IF  l-integra-mla-total  
    AND l-aprov-total 
    AND gl-prog-cc9019 THEN DO:

        ASSIGN l-aprov-total-9019 = YES.
    END.

    FIND FIRST ordem-compra WHERE ROWID(ordem-compra) = prOrdem EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL ordem-compra THEN DO:

        FOR FIRST pedido-compr FIELDS(num-pedido emergencial cod-estab-gestor) 
            WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: 
            
            ASSIGN l-ped-emerg = pedido-compr.emergencial. 
        END.

        ASSIGN i-pedido-ord = ordem-compra.num-pedido.

        /** Eliminar pendencias de aprovaáao **/
        
         IF  param-compra.log-1 
         AND AVAIL ordem-compra 
         AND AVAIL pedido-compr 
         AND ((not gl-prog-cc9019 OR l-aprov-total-9019) OR SUBSTRING(param-compra.char-2, 7, 3) = "nao":U) THEN DO:
            
            IF pedido-compr.emergencial THEN
                RUN cdp/cdapi171.p (6,3,ROWID(ordem-compra)).
            ELSE
                RUN cdp/cdapi171.p (4,3,ROWID(ordem-compra)).
        END.

        IF AVAIL param-global AND param-global.log-modul-draw THEN DO:

            FIND FIRST prazo-compra
                 WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK NO-ERROR.

            IF  AVAIL prazo-compra
            AND &IF "{&bf_mat_versao_ems}":U >= "2.09":U &THEN 
                    prazo-compra.cod-ato-concessor <> "":U
                &ELSE
                    TRIM(SUBSTRING(prazo-compra.char-2,11,30)) <> "":U
                &ENDIF  
                THEN DO:
        
                ASSIGN de-qtde-parcela = 0.
                FOR EACH bf-prazo-compra NO-LOCK
                    WHERE bf-prazo-compra.numero-ordem = ordem-compra.numero-ordem
                      AND bf-prazo-compra.situacao <> 4 /*eliminada*/
                      AND bf-prazo-compra.situacao <> 6 /*recebida*/ :
                    ASSIGN de-qtde-parcela = de-qtde-parcela + bf-prazo-compra.quantidade.
                END.
        
                RUN ValidateAtoConcessorio IN h-boin274vl (INPUT &IF "{&bf_mat_versao_ems}":U >= "2.09":U &THEN prazo-compra.cod-ato-concessor
                                                                 &ELSE TRIM(SUBSTRING(prazo-compra.char-2,11,30))
                                                                 &ENDIF ,
                                                           INPUT "DELETE":U,
                                                           INPUT prazo-compra.numero-ordem,
                                                           INPUT de-qtde-parcela,
                                                           OUTPUT TABLE rowErrors).
            END.
        END.
        ASSIGN ordem-compra.num-pedido  = 0
               ordem-compra.data-pedido = ?
               ordem-compra.situacao    = 3.  /* Ordem passa para Cotada */
               
        //Altera situacao caso ordem seja do Mercado Eletronico
        IF NOT VALID-HANDLE(h-ccOrdemCompraValidaIntegraMe) THEN
           RUN ccp/ccOrdemCompraValidaIntegraMe.p PERSISTENT SET h-ccOrdemCompraValidaIntegraMe.
           
        RUN verifica-ordem-compra IN h-ccOrdemCompraValidaIntegraMe ( INPUT  ordem-compra.numero-ordem,
                                                                      OUTPUT l-ordem-integrada-me).
                                                                     
        IF l-ordem-integrada-me THEN
            ASSIGN ordem-compra.situacao = 5. /* Ordem passa para Em Cotacao */
        
        FIND CURRENT ordem-compra NO-LOCK NO-ERROR.

        FOR EACH prazo-compra
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:
            
            ASSIGN prazo-compra.situacao = ordem-compra.situacao.

            IF param-global.log-modul-draw THEN DO:
                &IF "{&bf_mat_versao_ems}":U >= "2.09":U &THEN 
                    ASSIGN prazo-compra.cod-ato-concessor = "":U.
                &ELSE
                    ASSIGN OVERLAY(prazo-compra.char-2,11,30) = "":U.
                &ENDIF
            END.
        END.

        /*---Modulo Investimento---*/
        IF param-global.modulo-in AND ordem-compra.num-ord-inv <> 0 THEN DO:

            RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.
            RUN UpdateOrdPed IN h-boiv028 (INPUT ROWID(ordem-compra),
                                           INPUT-OUTPUT TABLE RowErrors).
            DELETE PROCEDURE h-boiv028.
        END.
        
        FIND FIRST emitente
            WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK NO-ERROR.

        IF  param-global.modulo-07 AND (emitente.natureza = 3 OR emitente.natureza = 4) THEN DO:

            IF  NOT VALID-HANDLE(h-bocx341) THEN
                RUN cxbo/bocx341.p PERSISTENT SET h-bocx341.

            RUN openQueryStatic IN h-bocx341("main":U).
            RUN atualizaDespesasPedido IN h-bocx341 (INPUT 3,
                                                     INPUT ROWID(ordem-compra),
                                                     INPUT pedido-compr.num-pedido).
            RUN getRowErrors IN h-bocx341(OUTPUT TABLE rowErrors).
            FOR EACH RowErrors
                WHERE RowErrors.ErrorSubType = "ERROR":U
                  AND RowErrors.ErrorType    = "INTERNAL":U:
                DELETE RowErrors.
            END.
            DELETE PROCEDURE h-bocx341.
            ASSIGN h-bocx341 = ?.
        END.

        IF NOT VALID-HANDLE(h-cdapi050) THEN
            RUN cdp/cdapi050.p PERSISTENT SET h-cdapi050.
            
        RUN pi-siscoserv-ativo IN h-cdapi050.
        IF RETURN-VALUE = "OK":U THEN
            RUN pi-apaga-ord-compra-sis IN h-cdapi050 (INPUT ordem-compra.numero-ordem, INPUT i-pedido-ord).

        IF VALID-HANDLE(h-cdapi050) THEN DO:
            DELETE PROCEDURE h-cdapi050.
            ASSIGN h-cdapi050 = ?.
        END.
        
        //Verificar se execuá∆o da Procedure Ç feita pelo CC9019 - Caso seja, n∆o enviar e-mail de pendància para usu†rio ao remover Ordens do Pedido.
        DO  WHILE PROGRAM-NAME(i-cont-prog) <> ?:

            IF  PROGRAM-NAME(i-cont-prog) MATCHES "*cc9019*" THEN DO:
                ASSIGN l-program =  YES.
                LEAVE.
            END.
    
            ASSIGN i-cont-prog = i-cont-prog + 1.
        END.

        /*Por localizar as ordens restantes vinculadas ao pedido, 
        a chamada para a procedure retornaMsgAprovacao tem que ficar no final para n∆o perder o rowid da ordem que ja esta sendo usado*/

        /* Para aprovaáao total gera novamente pendencia com o restante das ordens.
        */
        IF ((NOT gl-prog-cc9019 OR l-integra-mla-total) OR SUBSTRING(param-compra.char-2, 7, 3) = "nao":U) AND
        AVAIL param-aprov AND param-aprov.aprov-total-pedido AND NOT l-program THEN DO:
            
            FIND FIRST bf-ordem WHERE bf-ordem.num-pedido   =  i-pedido-ord
                                  AND bf-ordem.numero-ordem <> ordem-compra.numero-ordem
                                  AND bf-ordem.situacao     <> 4 NO-LOCK NO-ERROR.

            IF AVAIL bf-ordem THEN DO:
                IF pedido-compr.emergencial THEN
                    RUN cdp/cdapi171.p (6,2,ROWID(bf-ordem)).
                ELSE
                    RUN cdp/cdapi171.p (4,2,ROWID(bf-ordem)).

                RUN retornaMsgAprovacao (ROWID(bf-ordem)).
            END.
        END.

        RELEASE ordem-compra.
    END.

    IF VALID-HANDLE(h-boin274vl) THEN DO:
        DELETE PROCEDURE h-boin274vl.
        ASSIGN h-boin274vl = ?.
    END.
    
    IF VALID-HANDLE(h-ccOrdemCompraValidaIntegraMe) THEN DO:
        DELETE PROCEDURE h-ccOrdemCompraValidaIntegraMe.
        ASSIGN h-ccOrdemCompraValidaIntegraMe = ?.
    END.

    /* Include i-epc200.i2: Criaáao de registro para temp-table tt-epc */
    FOR EACH tt-epc WHERE tt-epc.cod-event = "desfazRelacOrdemPedido":U.
        DELETE tt-epc.
    END.
    {include/i-epc200.i2 &CodEvent='"desfazRelacOrdemPedido"'
                         &CodParameter='"OBJECT-HANDLE"'
                         &ValueParameter="string(this-procedure)"}
    {include/i-epc200.i2 &CodEvent='"desfazRelacOrdemPedido"'
                         &CodParameter='"rowid-ordem-compra"'
                         &ValueParameter="string(prOrdem)"}
    {include/i-epc200.i2 &CodEvent='"desfazRelacOrdemPedido"'
                         &CodParameter='"ped-emerg"'
                         &ValueParameter="string(l-ped-emerg)"}
    /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i "desfazRelacOrdemPedido"}
    IF RETURN-VALUE = "NOK":U THEN DO:
        UNDO, RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaPedidoCompra DBOProgram
PROCEDURE eliminaPedidoCompra :
/*------------------------------------------------------------------------------
  Purpose:
    Elimina pedido de compras
  Parameters:
    ipar1 : p-rowid-pedido : rowid do pedido
    ipar2 : p-motivo       : motivo da eliminaáao
    ipar3 : pc-seg-usuario : codigo do usuario
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-rowid-pedido  AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER pc-seg-usuario  AS CHAR  NO-UNDO.
    DEFINE INPUT PARAMETER p-motivo        AS CHAR  NO-UNDO.
    
    DEFINE VARIABLE de-val-tot    AS DECIMAL                        NO-UNDO.
    DEFINE VARIABLE de-qtd-tot    AS DECIMAL                        NO-UNDO.
    DEFINE VARIABLE de-preco-conv AS DECIMAL                        NO-UNDO.
    DEFINE VARIABLE r-gerencial   AS ROWID                          NO-UNDO.
    DEFINE VARIABLE c-gerencial   AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE c-elimina     AS CHARACTER FORMAT "x(2000)":U   NO-UNDO.

    ASSIGN c-seg-usuario = IF  pc-seg-usuario <> "":U THEN pc-seg-usuario
                           ELSE c-seg-usuario.

    {utp/ut-liter.i Eliminaáao_de_Pedidos mcc R}
    ASSIGN c-literal-obs = RETURN-VALUE.

    FIND FIRST pedido-compr WHERE ROWID(pedido-compr) = p-rowid-pedido EXCLUSIVE-LOCK NO-ERROR.

    /* INICIO - PONTO DE CHAMADA PARA UPC */
    IF  c-nom-prog-dpc-mg97  <> "":U
    OR  c-nom-prog-appc-mg97 <> "":U
    OR  c-nom-prog-upc-mg97  <> "":U THEN DO:

        FOR EACH tt-epc
            WHERE tt-epc.cod-event = "before_delete_pedido-compr":U:
            DELETE tt-epc.
        END.

        {include/i-epc200.i2 &CodEvent="'before_delete_pedido-compr'"
                             &CodParameter="'TABLE-ROWID'"
                             &ValueParameter=STRING(ROWID(pedido-compr))}

        {include/i-epc200.i2 &CodEvent="'before_delete_pedido-compr'"
                             &CodParameter="'OBJECT-HANDLE'"
                             &ValueParameter=STRING(THIS-PROCEDURE)}

        {include/i-epc201.i "before_delete_pedido-compr"}

        IF  RETURN-VALUE = "NOK":U THEN
            RETURN.
    END.

    IF l-portal-paradigma  
    AND &IF "{&bf_mat_versao_ems}":U  <  "2.09":U  &THEN
           SUBSTRING(pedido-compr.char-1,55,1) = "S":U
       &ELSE
           pedido-compr.log-envdo-integr
       &ENDIF
    THEN DO:     
        
        RUN adapters/xml/su2/axssu016.p PERSISTENT SET h-axssu016 (OUTPUT TABLE tt_log_erro).

        RUN PIUpsert IN h-axssu016 (INPUT pedido-compr.cod-estabel, /*pedido-compr.responsavel,*/
                                    INPUT "":U,
                                    INPUT "add":U,
                                    INPUT pedido-compr.num-pedido,
                                    OUTPUT TABLE tt_log_erro).

        FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
        IF AVAIL tt_log_erro THEN DO:
            CREATE RowErrors.
            ASSIGN RowErrors.errornumber       = 50
                   RowErrors.ErrorDescription  = tt_log_erro.ttv_des_msg_erro
                   RowErrors.ErrorHelp         = tt_log_erro.ttv_des_msg_erro
                   rowErrors.ErrorType         = "EMS":U
                   rowErrors.ErrorSubType      = "ERROR":U.

            RETURN "NOK":U.
        END.

        IF (VALID-HANDLE(h-axssu016)
            AND h-axssu016:TYPE = "PROCEDURE":U
            AND h-axssu016:FILE-NAME = "adapters/xml/su2/axssu016.p":U ) THEN DO:

            DELETE PROCEDURE h-axssu016.
            ASSIGN h-axssu016 = ?.
        END.
    END.
    
    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST param-compra NO-LOCK NO-ERROR.
    FIND FIRST ordem-compra WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-LOCK NO-ERROR.

    ASSIGN pedido-compr.situacao = 3. /* Eliminado */

    IF ("{&mgadm_dbtype}":U <> "PROGRESS":U) THEN DO:
        ASSIGN c-elimina = pedido-compr.mot-elimina + CHR(10) + CHR(10) 
                         + "== ":U + "Usu†rio":U + ": ":U + c-seg-usuario 
                         + " = ":U + "Pedido Eliminado":U 
                         + " = ":U + "Data:":U + ": ":U
                         + STRING(TODAY,"99/99/9999":U) + " ==":U + CHR(10) + p-motivo.

        ASSIGN pedido-compr.mot-elimina  = SUBSTRING(c-elimina,1,2000).
    END.
    ELSE
        ASSIGN pedido-compr.mot-elimina = pedido-compr.mot-elimina + CHR(10) + CHR(10) 
                                        + "== ":U + "Usu†rio":U + ": " + c-seg-usuario 
                                        + " = ":U + "Pedido Eliminado":U 
                                        + " = ":U + "Data:":U + ": ":U
                                        + STRING(TODAY,"99/99/9999":U) + " ==":U + CHR(10) + p-motivo.

    FOR EACH ordem-compra 
       WHERE ordem-compra.num-pedido = pedido-compr.num-pedido 
         AND ordem-compra.situacao  <> 4 EXCLUSIVE-LOCK: /* Eliminada */

        IF ("{&mgadm_dbtype}":U <> "PROGRESS":U) THEN
            ASSIGN ordem-compra.comentarios = SUBSTRING(p-motivo,1,76)
                   ordem-compra.situacao    = 4
                   de-qtd-tot               = 0.
        ELSE
            ASSIGN ordem-compra.comentarios = p-motivo
                   ordem-compra.situacao    = 4
                   de-qtd-tot               = 0.
        
        /*API de Execuáao Oráament†ria*/
        RUN cdp/cdapi197.p (INPUT ROWID(ordem-compra), INPUT ?, INPUT 1, OUTPUT TABLE Rowerrors APPEND).
        

        FOR EACH prazo-compra 
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem 
             AND prazo-compra.situacao    <> 4 EXCLUSIVE-LOCK: /* Eliminada */

            ASSIGN prazo-compra.situacao = ordem-compra.situacao
                   de-qtd-tot            = de-qtd-tot + prazo-compra.qtd-sal-forn.

            /* ---------- Modulo Investimento -----------*/
            IF param-global.modulo-in AND ordem-compra.num-ord-inv <> 0 THEN DO:

               RUN ivbo/boiv037.p PERSISTENT SET h-boiv037.
               RUN DeleteProgEntr IN h-boiv037 (INPUT ROWID(prazo-compra),
                                                INPUT-OUTPUT TABLE RowErrors).
               DELETE PROCEDURE h-boiv037.
            END.
        END.

        IF ordem-compra.mo-codigo > 0 THEN
            RUN cdp/cd0812.p (INPUT  ordem-compra.mo-codigo,
                              INPUT  0,
                              INPUT  ordem-compra.pre-unit-for,
                              INPUT  pedido-compr.data-pedido,
                              OUTPUT de-preco-conv).

        ASSIGN de-preco-conv = IF de-preco-conv <> ? THEN de-preco-conv ELSE ordem-compra.pre-unit-for
               de-val-tot    = de-qtd-tot * de-preco-conv.

        /* ---------- Modulo Investimento -----------*/
        IF param-global.modulo-in AND ordem-compra.num-ord-inv <> 0 THEN DO:

           RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.
           RUN DeleteOrdPed IN h-boiv028 (INPUT ROWID(ordem-compra),
                                          INPUT-OUTPUT TABLE RowErrors).
           DELETE PROCEDURE h-boiv028.
        END.
       
        IF param-global.modulo-pl OR param-global.modulo-pi AND AVAIL ordem-compra THEN
            RUN cdp/cd7000.p (INPUT 0, ordem-compra.it-codigo, ordem-compra.cod-estabel).
    END.

    /**   Multiplanta **/
    /*******************
        Parte dessa procedure esta em coment†rio porque as
        includes do multiplanta nao possui tratamento para UTMSG COM SHOW.
        Porem com a chamada da ccapi200 este problema seria solucionado.
        Verificar se a geracao da pendencia est† correta mesmo sem
        este ponto de chamada.
    ********************/

    IF param-global.modulo-mp THEN DO:

        RUN ccp/ccapi200.p (INPUT "Pedido-compr":U, INPUT ROWID(pedido-compr),
                            INPUT  2, INPUT-OUTPUT TABLE tt-erro-mp).

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
    /*FIM DO COMENTARIO MULTIPLANTA ********************************/

    FIND FIRST emitente 
         WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK NO-ERROR.

    IF AVAIL emitente THEN DO:

        CREATE alt-ped.
        ASSIGN alt-ped.data         = TODAY
               alt-ped.hora         = STRING(TIME,"HH:MM:SS":U)
               alt-ped.usuario      = {cdp/cd7777.i}
               alt-ped.num-pedido   = pedido-compr.num-pedido
               alt-ped.nome-abrev   = emitente.nome-abrev
               alt-ped.cod-cond-pag = ?
               alt-ped.observacao   = "# ":U + c-literal-obs.
    END.

    &IF DEFINED(bf_mat_compras_edi) &THEN
        /*   Atualiza dados do pedido e da ordem possibilitando
        **   extrair novamente os dados do pedido no EDI */
        ASSIGN ordem-compra.gera-edi = YES.
        
        FIND FIRST pedido-compr
             WHERE pedido-compr.num-pedido = ordem-compra.num-pedido EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL pedido-compr THEN
           ASSIGN pedido-compr.gera-edi = YES.

        FIND CURRENT pedido-compr NO-LOCK NO-ERROR.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEmitente DBOProgram
PROCEDURE findEmitente :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER  piCodEmitente AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER  piNumPedido   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER  pcReturn      AS CHARACTER NO-UNDO.

    RUN openQueryStatic ("Main":U).

    RUN gotokey (piCodEmitente, piNumPedido).

    IF RETURN-VALUE = "OK":U THEN ASSIGN pcReturn = "":U.

    IF RETURN-VALUE = "NOK":U THEN DO:
        {utp/ut-table.i movind {&TableName} 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
        ASSIGN pcReturn = RETURN-VALUE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNumero DBOProgram
PROCEDURE findNumero :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER  piNumPedido AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER  pcReturn    AS CHARACTER NO-UNDO.

    RUN openQueryStatic ("Main":U).

    RUN gotokey (piNumPedido).

    IF RETURN-VALUE = "OK":U THEN ASSIGN pcReturn = "":U.

    IF RETURN-VALUE = "NOK":U THEN DO:
        {utp/ut-table.i movind {&TableName} 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
        ASSIGN pcReturn = RETURN-VALUE.
    END.
	
	RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraNumeroPedidoCompra DBOProgram
PROCEDURE geraNumeroPedidoCompra :
/*------------------------------------------------------------------------------
  Purpose:     Gera um novo n£mero de pedido de compra (wcc0310a).
  Parameters:  opar1 : pi-num-pedido : N£mero do pedido gerado
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pi-num-pedido AS INTEGER NO-UNDO.

    DEF BUFFER b-param-compra FOR param-compra.
    FIND FIRST param-compra NO-LOCK NO-ERROR.
    FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND LAST pedido-compr
        WHERE pedido-compr.num-pedido <= param-compra.num-pedido-fim NO-LOCK NO-ERROR.

    IF AVAIL pedido-compr THEN DO:

        IF pedido-compr.num-pedido = 0 THEN DO:
            ASSIGN i-cont = 1.
            REPEAT:
                FIND PREV pedido-compr NO-LOCK NO-ERROR.

                IF AVAIL pedido-compr THEN DO:
                    IF pedido-compr.num-pedido = 0 THEN
                        ASSIGN i-cont = i-cont + 1.
                    ELSE 
                        LEAVE.
                END.
                ELSE DO:
                    FIND LAST pedido-compr 
                        WHERE pedido-compr.num-pedido <= param-compra.num-pedido-fim 
                          AND pedido-compr.num-pedido <> 0 NO-LOCK NO-ERROR.

                    IF NOT AVAIL pedido-compr THEN
                        FIND LAST pedido-compr 
                            WHERE pedido-compr.num-pedido <= param-compra.num-pedido-fim NO-LOCK NO-ERROR.

                    ASSIGN l-primeiro = YES.
                    LEAVE.
                END.
            END.
        END.
        IF AVAIL pedido-compr THEN DO:
            IF i-cont > 0 AND l-primeiro = NO THEN DO:

                IF (pedido-compr.num-pedido + 1) > param-compra.num-pedido-fim OR
                   (pedido-compr.num-pedido + 1) < param-compra.num-pedido-ini THEN DO:
                    ASSIGN i-num-pedido-gerado = param-compra.num-pedido-ini.
                END.
                ELSE DO:
                    ASSIGN i-num-pedido-gerado = pedido-compr.num-pedido + i-cont + 1.
                END.
            END.
            ELSE DO:
                IF (pedido-compr.num-pedido + 1) > param-compra.num-pedido-fim
                OR (pedido-compr.num-pedido + 1) < param-compra.num-pedido-ini THEN
                    ASSIGN i-num-pedido-gerado = param-compra.num-pedido-ini.
                ELSE
                    ASSIGN i-num-pedido-gerado = pedido-compr.num-pedido + 1.
            END.
        END.
        ELSE
            ASSIGN i-num-pedido-gerado = param-compra.num-pedido-ini.
    END.
    ELSE
        ASSIGN i-num-pedido-gerado = param-compra.num-pedido-ini.

    /** Acha proximo numero disponivel ao chegar ao ultimo parametrizado **/

    IF i-num-pedido-gerado = param-compra.num-pedido-ini THEN DO:

        
        IF param-compra.num-livre-1 <> 0  AND param-compra.num-livre-1 < param-compra.num-pedido-fim THEN
            ASSIGN i-num-pedido-gerado = param-compra.num-livre-1.
        REPEAT:
            FIND FIRST pedido-compr 
                 WHERE pedido-compr.num-pedido = i-num-pedido-gerado NO-LOCK NO-ERROR.

            IF AVAIL pedido-compr THEN DO:
                
                ASSIGN i-num-pedido-gerado = i-num-pedido-gerado + 1.

                IF i-num-pedido-gerado > param-compra.num-pedido-fim THEN DO:
                    ASSIGN pi-num-pedido = i-num-pedido-gerado.
                    /* "Nao ha' numero de Pedidos disponiveis na faixa" */
                     {method/svc/errors/inserr.i &ErrorNumber="15218"
                                                 &ErrorType="EMS":U
                                                 &ErrorSubType="ERROR":U}
                END.
            END.
            ELSE
                LEAVE.
        END.
    END.

    /* Usado para bancos historicos */
    IF AVAIL param-global AND param-global.modulo-bh THEN DO:

       IF CAN-FIND(FIRST his-pedido-compr 
                   WHERE his-pedido-compr.num-pedido = i-num-pedido-gerado) THEN DO:

           FIND LAST his-pedido-compr 
               WHERE his-pedido-compr.num-pedido >= i-num-pedido-gerado 
                 AND his-pedido-compr.num-pedido <= param-compra.num-pedido-fim NO-LOCK NO-ERROR.

           IF AVAIL his-pedido-compr THEN DO:

              IF his-pedido-compr.num-pedido = param-compra.num-pedido-fim THEN
                  ASSIGN i-num-pedido-gerado = param-compra.num-pedido-ini.
              ELSE
                  ASSIGN i-num-pedido-gerado = his-pedido-compr.num-pedido + 1.
           END.

           /*** Busca do Num do Ped Compra, considerando a existencia do numero em BH e Banco Oficial ***/
           REPEAT:
               FIND FIRST pedido-compr 
                    WHERE pedido-compr.num-pedido = i-num-pedido-gerado NO-LOCK NO-ERROR.

               FIND FIRST his-pedido-compr 
                    WHERE his-pedido-compr.num-pedido = i-num-pedido-gerado NO-LOCK NO-ERROR.

               IF NOT AVAILABLE pedido-compr     AND
                  NOT AVAILABLE his-pedido-compr THEN LEAVE.

               IF ((i-num-pedido-gerado + 1) > param-compra.num-pedido-fim)
               OR ((i-num-pedido-gerado + 1) < param-compra.num-pedido-ini) THEN DO:
                   ASSIGN i-num-pedido-gerado = param-compra.num-pedido-ini.
                   LEAVE.
               END.
               ELSE
                   ASSIGN i-num-pedido-gerado = i-num-pedido-gerado + 1.
           END.
       END.
    END.

    FIND FIRST b-param-compra EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN b-param-compra.num-livre-1 = i-num-pedido-gerado.
    RELEASE b-param-compra.
    ASSIGN pi-num-pedido = i-num-pedido-gerado.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /* Verifica se temptable RowObject estˇ dispon°vel, caso nao esteja serˇ retornada flag "NOK":U */
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "hra-criac":U        THEN ASSIGN pFieldValue = RowObject.hra-criac.
        WHEN "hra-alter":U        THEN ASSIGN pFieldValue = RowObject.hra-alter.
        WHEN "cod-usuar-criac":U  THEN ASSIGN pFieldValue = RowObject.cod-usuar-criac.
        WHEN "cod-usuar-alter":U  THEN ASSIGN pFieldValue = RowObject.cod-usuar-alter.
        WHEN "cargo-ass[02]":U    THEN ASSIGN pFieldValue = RowObject.cargo-ass[02].
        WHEN "cargo-ass[03]":U    THEN ASSIGN pFieldValue = RowObject.cargo-ass[03].
        WHEN "char-1":U           THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "desc-forma":U       THEN ASSIGN pFieldValue = RowObject.desc-forma.
        WHEN "desc-via":U         THEN ASSIGN pFieldValue = RowObject.desc-via.
        WHEN "end-cobranca":U     THEN ASSIGN pFieldValue = RowObject.end-cobranca.
        WHEN "compl-entrega":U    THEN ASSIGN pFieldValue = RowObject.compl-entrega.
        WHEN "mot-elimina":U      THEN ASSIGN pFieldValue = RowObject.mot-elimina.
        WHEN "nome-ass[01]":U     THEN ASSIGN pFieldValue = RowObject.nome-ass[01].
        WHEN "nome-ass[02]":U     THEN ASSIGN pFieldValue = RowObject.nome-ass[02].
        WHEN "nome-ass[03]":U     THEN ASSIGN pFieldValue = RowObject.nome-ass[03].
        WHEN "responsavel":U      THEN ASSIGN pFieldValue = RowObject.responsavel.
        WHEN "end-entrega":U      THEN ASSIGN pFieldValue = RowObject.end-entrega.
        WHEN "c-cod-tabela":U     THEN ASSIGN pFieldValue = RowObject.c-cod-tabela.
        WHEN "c-descr-merc[01]":U THEN ASSIGN pFieldValue = RowObject.c-descr-merc[01].
        WHEN "c-descr-merc[02]":U THEN ASSIGN pFieldValue = RowObject.c-descr-merc[02].
        WHEN "c-descr-merc[03]":U THEN ASSIGN pFieldValue = RowObject.c-descr-merc[03].
        WHEN "c-embalagem[01]":U  THEN ASSIGN pFieldValue = RowObject.c-embalagem[01].
        WHEN "c-embalagem[02]":U  THEN ASSIGN pFieldValue = RowObject.c-embalagem[02].
        WHEN "c-embalagem[03]":U  THEN ASSIGN pFieldValue = RowObject.c-embalagem[03].
        WHEN "c-observacao[01]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[01].
        WHEN "c-observacao[02]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[02].
        WHEN "c-observacao[03]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[03].
        WHEN "c-observacao[04]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[04].
        WHEN "c-observacao[05]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[05].
        WHEN "c-prazo":U          THEN ASSIGN pFieldValue = RowObject.c-prazo.
        WHEN "cargo-ass[01]":U    THEN ASSIGN pFieldValue = RowObject.cargo-ass[01].
        WHEN "char-2":U           THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U        THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel":U      THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "comentarios":U      THEN ASSIGN pFieldValue = RowObject.comentarios.
        WHEN "cod-estab-gestor":U THEN ASSIGN pFieldValue = rowObject.cod-estab-gestor.
        WHEN "cod-entrega":U      THEN ASSIGN pFieldValue = rowObject.cod-entrega.
        WHEN "endereco_text":U    THEN ASSIGN pFieldValue = rowObject.endereco_text.
        WHEN "endereco":U         THEN ASSIGN pFieldValue = rowObject.endereco.
        WHEN "bairro":U           THEN ASSIGN pFieldValue = rowObject.bairro.
        WHEN "cidade":U           THEN ASSIGN pFieldValue = rowObject.cidade.
        WHEN "estado":U           THEN ASSIGN pFieldValue = rowObject.estado.
        WHEN "pais":U             THEN ASSIGN pFieldValue = rowObject.pais.
        WHEN "cep":U              THEN ASSIGN pFieldValue = rowObject.cep.
        WHEN "jurisdicao":U       THEN ASSIGN pFieldValue = rowObject.jurisdicao.
        &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
            WHEN "log-congela-ped":U   THEN ASSIGN pFieldValue = rowObject.log-congela-ped.
            WHEN "log-integr-portal":U THEN ASSIGN pFieldValue = rowObject.log-integr-portal.
        &endif
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDatetimeField DBOProgram
PROCEDURE getDatetimeField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data e hora
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE      NO-UNDO.

    /* Verifica se temptable RowObject estˇ dispon°vel, caso nao esteja serˇ retornada flag "NOK":U */
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE      NO-UNDO.

    /* Verifica se temptable RowObject estˇ dispon°vel, caso nao esteja serˇ retornada flag "NOK":U */
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-pedido":U THEN ASSIGN pFieldValue = RowObject.data-pedido.
        WHEN "dat-alter":U   THEN ASSIGN pFieldValue = RowObject.dat-alter.
        WHEN "dat-criac":U   THEN ASSIGN pFieldValue = RowObject.dat-criac.
        WHEN "data-1":U      THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U      THEN ASSIGN pFieldValue = RowObject.data-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL   NO-UNDO.

    /* Verifica se temptable RowObject estˇ dispon°vel, caso nao esteja serˇ retornada flag "NOK":U */
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "de-vl-frete-i":U THEN ASSIGN pFieldValue = RowObject.de-vl-frete-i.
        WHEN "dec-1":U         THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "de-vl-fob":U     THEN ASSIGN pFieldValue = RowObject.de-vl-fob.
        WHEN "dec-2":U         THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /* Verifica se temptable RowObject estˇ dispon°vel, caso nao esteja serˇ retornada flag "NOK":U */
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-cond-pag":U       THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U       THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-mensagem":U       THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "cod-transp":U         THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "int-1":U              THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "nr-contrato"          THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-processo":U        THEN ASSIGN pFieldValue = RowObject.nr-processo.
        WHEN "nr-prox-ped":U        THEN ASSIGN pFieldValue = RowObject.nr-prox-ped.
        WHEN "num-ped-benef":U      THEN ASSIGN pFieldValue = RowObject.num-ped-benef.
        WHEN "num-pedido":U         THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "via-transp":U         THEN ASSIGN pFieldValue = RowObject.via-transp.
        WHEN "i-cod-forma":U        THEN ASSIGN pFieldValue = RowObject.i-cod-forma.
        WHEN "i-cod-porto":U        THEN ASSIGN pFieldValue = RowObject.i-cod-porto.
        WHEN "i-cod-via":U          THEN ASSIGN pFieldValue = RowObject.i-cod-via.
        WHEN "i-exportador":U       THEN ASSIGN pFieldValue = RowObject.i-exportador.
        WHEN "i-importador":U       THEN ASSIGN pFieldValue = RowObject.i-importador.
        WHEN "i-moeda":U            THEN ASSIGN pFieldValue = RowObject.i-moeda.
        WHEN "i-situacao":U         THEN ASSIGN pFieldValue = RowObject.i-situacao.
        WHEN "cod-maq-origem":U     THEN ASSIGN pFieldValue = RowObject.cod-maq-origem.
        WHEN "int-2":U              THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "l-classificacao":U    THEN ASSIGN pFieldValue = RowObject.l-classificacao.
        WHEN "l-tipo-ped":U         THEN ASSIGN pFieldValue = RowObject.l-tipo-ped.
        WHEN "natureza":U           THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "nro-proc-alteracao":U THEN ASSIGN pFieldValue = RowObject.nro-proc-alteracao.
        WHEN "nro-proc-entrada":U   THEN ASSIGN pFieldValue = RowObject.nro-proc-entrada.
        WHEN "nro-proc-saida":U     THEN ASSIGN pFieldValue = RowObject.nro-proc-saida.
        WHEN "num-id-documento":U   THEN ASSIGN pFieldValue = RowObject.num-id-documento.
        WHEN "num-processo-mp":U    THEN ASSIGN pFieldValue = RowObject.num-processo-mp.
        WHEN "situacao":U           THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "frete":U              THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "ind-orig-entrada":U   THEN ASSIGN pFieldValue = RowObject.ind-orig-entrada.
        WHEN "ind-via-envio":U      THEN ASSIGN pFieldValue = RowObject.ind-via-envio.
        WHEN "cod-emit-terc":U      THEN ASSIGN pFieldValue = RowObject.cod-emit-terc.
        WHEN "nr-ped-venda":U       THEN ASSIGN pFieldValue = RowObject.nr-ped-venda.
        WHEN "local-entrega":U      THEN ASSIGN pFieldValue = RowObject.local-entrega.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice NUMERO
  Parameters:
               retorna valor dos campos do °ndice NUMERO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    /* Verifica se temptable RowObject estˇ dispon°vel, caso nao esteja serˇ retornada flag "NOK":U */
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnum-pedido = RowObject.num-pedido.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL   NO-UNDO.

    /* Verifica se temptable RowObject estˇ dispon°vel, caso nao esteja serˇ retornada flag "NOK":U */
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "emergencial":U THEN ASSIGN pFieldValue = RowObject.emergencial.
        WHEN "contr-forn":U  THEN ASSIGN pFieldValue = RowObject.contr-forn.
        WHEN "l-ind-prof":U  THEN ASSIGN pFieldValue = RowObject.l-ind-prof.
        WHEN "log-1":U       THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "impr-pedido":U THEN ASSIGN pFieldValue = RowObject.impr-pedido.
        WHEN "log-2":U       THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "gera-edi":U    THEN ASSIGN pFieldValue = RowObject.gera-edi.
        &IF "{&bf_mat_versao_ems}":U >= "2.09":U &THEN
            WHEN "log-congela-ped":U   THEN ASSIGN pFieldValue = rowObject.log-congela-ped.
            WHEN "log-integr-portal":U THEN ASSIGN pFieldValue = rowObject.log-integr-portal.
        &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW       NO-UNDO.

    /* Verifica se temptable RowObject estˇ dispon°vel, caso nao esteja serˇ retornada flag "NOK":U */
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice NUMERO
  Parameters:
               recebe valor dos campos do °ndice NUMERO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    FIND FIRST bfpedido-compr 
         WHERE bfpedido-compr.num-pedido = pnum-pedido NO-LOCK NO-ERROR.

    /* Verifica se registro foi encontrado, em caso de erro serˇ retornada flag "NOK":U */
    IF NOT AVAILABLE bfpedido-compr THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrencia de erros, caso
          existam erros serˇ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpedido-compr)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyEmitente DBOProgram
PROCEDURE goToKeyEmitente :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro
  Parameters:  recebe valor dos campos cod-emitente, num-pedido e
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piCodEmit   LIKE pedido-compr.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER piNumPedido LIKE pedido-compr.num-pedido   NO-UNDO.

    FOR FIRST bfpedido-compr fields(cod-emitente num-pedido) 
        WHERE bfpedido-compr.cod-emitente = piCodEmit 
          AND bfpedido-compr.num-pedido = piNumPedido NO-LOCK: END.

    /*--- Verifica se registro foi encontrado, em caso de erro serˇ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpedido-compr THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrencia de erros, caso
          existam erros serˇ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpedido-compr)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-abertura AS INTEGER NO-UNDO.

    CASE i-abertura:
        WHEN 1 THEN
            RUN openQueryStatic ("Main":U).
        WHEN 2 THEN
            RUN openQueryStatic ("ByPedido":U).
        WHEN 3 THEN
            RUN openQueryStatic ("ByEmitente":U).
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEmitente DBOProgram
PROCEDURE openQueryByEmitente :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    &IF "{&ems_dbtype}":U = "mss":U &THEN
       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-AT OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE {&TableName}.cod-emitente = iCodEmit AND {&TableName}.num-pedido  >= iNumPedido NO-LOCK, EACH {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = {&TableName}.cod-estabel NO-LOCK INDEXED-REPOSITION.
    
       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-IN OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE {&TableName}.cod-emitente = iCodEmit AND {&TableName}.num-pedido  >= iNumPedido NO-LOCK, EACH {&ESTAB-SEC-TT} NO-LOCK INDEXED-REPOSITION.
    &ELSE
       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-AT OPEN QUERY {&QueryName} FOR EACH {&ESTAB-SEC-TT} NO-LOCK, EACH {&TableName} WHERE {&TableName}.cod-emitente = iCodEmit AND {&TableName}.num-pedido  >= iNumPedido AND {&TableName}.cod-estabel = {&ESTAB-SEC-TT-FIELD} NO-LOCK INDEXED-REPOSITION.
    
       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-IN OPEN QUERY {&QueryName} FOR EACH {&ESTAB-SEC-TT} NO-LOCK, EACH {&TableName} WHERE {&TableName}.cod-emitente = iCodEmit AND {&TableName}.num-pedido  >= iNumPedido NO-LOCK INDEXED-REPOSITION.
    &ENDIF
    
    {include/i-estab-openquery.i}
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByPedido DBOProgram
PROCEDURE openQueryByPedido :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    &IF "{&ems_dbtype}":U = "mss":U &THEN
       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-AT OPEN QUERY {&QueryName} FOR EACH  {&TableName} WHERE {&TableName}.num-pedido = iNumPedido AND {&TableName}.num-pedido  >= iNumPedido NO-LOCK, EACH {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = {&TableName}.cod-estabel NO-LOCK INDEXED-REPOSITION.

       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-IN OPEN QUERY {&QueryName} FOR EACH  {&TableName} WHERE {&TableName}.num-pedido = iNumPedido AND {&TableName}.num-pedido  >= iNumPedido NO-LOCK, EACH {&ESTAB-SEC-TT} NO-LOCK INDEXED-REPOSITION.
    &ELSE
       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-AT OPEN QUERY {&QueryName} FOR EACH {&ESTAB-SEC-TT} NO-LOCK, EACH {&TableName} WHERE {&TableName}.num-pedido = iNumPedido AND {&TableName}.num-pedido  >= iNumPedido AND {&TableName}.cod-estabel = {&ESTAB-SEC-TT-FIELD} NO-LOCK INDEXED-REPOSITION.

       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-IN OPEN QUERY {&QueryName} FOR EACH {&ESTAB-SEC-TT} NO-LOCK, EACH {&TableName} WHERE {&TableName}.num-pedido = iNumPedido AND {&TableName}.num-pedido  >= iNumPedido NO-LOCK INDEXED-REPOSITION.
    &ENDIF
    
    {include/i-estab-openquery.i}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByPedidoToReceb DBOProgram
PROCEDURE openQueryByPedidoToReceb :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    &IF "{&ems_dbtype}":U = "mss":U &THEN
       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-AT OPEN QUERY {&QueryName} FOR EACH  {&TableName} WHERE {&TableName}.situacao <> 3 /* Eliminado */ AND ( IF  iCodEmit <> ? THEN {&TableName}.cod-emitente  = iCodEmit ELSE YES ) NO-LOCK, EACH {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = {&TableName}.cod-estabel NO-LOCK INDEXED-REPOSITION.

       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-IN OPEN QUERY {&QueryName} FOR EACH  {&TableName} WHERE {&TableName}.situacao <> 3 /* Eliminado */ AND ( IF  iCodEmit <> ? THEN {&TableName}.cod-emitente  = iCodEmit ELSE YES ) NO-LOCK, EACH {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = {&TableName}.cod-estabel NO-LOCK INDEXED-REPOSITION.
    &ELSE
       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-AT OPEN QUERY {&QueryName} FOR EACH {&ESTAB-SEC-TT} NO-LOCK, EACH {&TableName} WHERE {&TableName}.situacao <> 3 /* Eliminado */ AND ( IF  iCodEmit <> ? THEN {&TableName}.cod-emitente  = iCodEmit ELSE YES ) AND {&TableName}.cod-estabel = {&ESTAB-SEC-TT-FIELD} NO-LOCK INDEXED-REPOSITION.

       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-IN OPEN QUERY {&QueryName} FOR EACH {&ESTAB-SEC-TT} NO-LOCK, EACH {&TableName} WHERE {&TableName}.situacao <> 3 /* Eliminado */ AND ( IF  iCodEmit <> ? THEN {&TableName}.cod-emitente  = iCodEmit ELSE YES ) NO-LOCK INDEXED-REPOSITION.
    &ENDIF
    
    {include/i-estab-openquery.i}

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
    
    &IF "{&ems_dbtype}":U = "mss":U &THEN
        &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-AT OPEN QUERY {&QueryName} FOR EACH  {&TableName} USE-INDEX numero NO-LOCK, each {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = {&TableName}.cod-estabel NO-LOCK INDEXED-REPOSITION.
                                                                                          
        &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-IN OPEN QUERY {&QueryName} FOR EACH {&TableName} USE-INDEX numero NO-LOCK, each {&ESTAB-SEC-TT} NO-LOCK INDEXED-REPOSITION.
    &ELSE
       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-AT OPEN QUERY {&QueryName} FOR EACH {&ESTAB-SEC-TT} NO-LOCK, EACH {&TableName} WHERE {&TableName}.end-entrega = {&ESTAB-SEC-TT-FIELD} NO-LOCK BY {&TableName}.num-pedido INDEXED-REPOSITION.
                                                                                          
       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-IN OPEN QUERY {&QueryName} FOR EACH {&ESTAB-SEC-TT} NO-LOCK, EACH {&TableName} NO-LOCK USE-INDEX numero INDEXED-REPOSITION.
    &ENDIF

    {include/i-estab-openquery.i}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstMain DBOProgram
PROCEDURE findFirstMain :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    FIND FIRST {&tableName} NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastMain DBOProgram
PROCEDURE findLastMain :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    FIND LAST {&tableName} NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextMain DBOProgram
PROCEDURE findNextMain :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    FIND NEXT {&tableName} NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevMain DBOProgram
PROCEDURE findPrevMain :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    FIND PREV {&tableName} NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePedido DBOProgram
PROCEDURE openQueryRangePedido :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    &IF "{&ems_dbtype}":U = "mss":U &THEN
       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-AT OPEN QUERY {&QueryName} FOR EACH {&TableName} USE-INDEX numero WHERE {&TableName}.num-pedido >= i-num-pedido-ini AND {&tableName}.num-pedido <= i-num-pedido-fim NO-LOCK, each {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = {&TableName}.cod-estabel no-lock INDEXED-REPOSITION. 
                                                                                                                                      
       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-IN OPEN QUERY {&QueryName} FOR EACH {&TableName} USE-INDEX numero WHERE {&TableName}.num-pedido >= i-num-pedido-ini AND {&tableName}.num-pedido <= i-num-pedido-fim NO-LOCK, each {&ESTAB-SEC-TT} no-lock INDEXED-REPOSITION.                                                        
    &ELSE
       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-AT OPEN QUERY {&QueryName} FOR EACH {&ESTAB-SEC-TT} NO-LOCK, EACH {&TableName} WHERE {&TableName}.num-pedido >= i-num-pedido-ini AND {&tableName}.num-pedido <= i-num-pedido-fim AND {&TableName}.cod-estabel = {&ESTAB-SEC-TT-FIELD} NO-LOCK BY {&TableName}.num-pedido INDEXED-REPOSITION. 
                                                                                                                                      
       &SCOPED-DEFINE OPEN-QUERY-{&MY-QUERY}-IN OPEN QUERY {&QueryName} FOR EACH {&ESTAB-SEC-TT} NO-LOCK, EACH {&TableName} WHERE {&TableName}.num-pedido >= i-num-pedido-ini AND {&tableName}.num-pedido <= i-num-pedido-fim NO-LOCK USE-INDEX numero INDEXED-REPOSITION.                                                        
    &ENDIF
    
    {include/i-estab-openquery.i}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-cond-pagto DBOProgram
PROCEDURE pi-altera-cond-pagto :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    
    IF AVAIL pedido-compr AND rowObject.cod-cond-pag <> pedido-compr.cod-cond-pag THEN DO:
        
        FOR EACH ordem-compra  
           WHERE ordem-compra.num-pedido = pedido-compr.num-pedido EXCLUSIVE-LOCK:

            ASSIGN ordem-compra.cod-cond-pag = rowObject.cod-cond-pag.
            FIND FIRST cotacao-item 
                 WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                   AND cotacao-item.cot-aprovada = YES EXCLUSIVE-LOCK NO-ERROR.

            IF AVAILABLE cotacao-item THEN
                ASSIGN cotacao-item.cod-cond-pag = rowObject.cod-cond-pag.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-investimento DBOProgram
PROCEDURE pi-altera-investimento :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    
    FIND FIRST param-global NO-LOCK NO-ERROR.
    
    IF param-global.modulo-in AND
       CAN-FIND (FIRST ordem-compra 
                 WHERE ordem-compra.num-pedido = pedido-compr.num-pedido 
                   AND ordem-compra.num-ord-inv > 0) THEN DO:

       RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.
    
       RUN UpdatePedido IN h-boiv028 (INPUT ROWID(pedido-compr),
                                      INPUT-OUTPUT TABLE RowErrors).
    
       DELETE PROCEDURE h-boiv028.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-bt-unid-neg DBOProgram
PROCEDURE pi-bt-unid-neg :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-ordem-servic   LIKE ordem-compra.ordem-servic   NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo      LIKE ordem-compra.it-codigo      NO-UNDO.
    DEFINE INPUT  PARAMETER p-ct-codigo      LIKE ordem-compra.ct-codigo      NO-UNDO.
    DEFINE INPUT  PARAMETER p-sc-codigo      LIKE ordem-compra.sc-codigo      NO-UNDO.
    DEFINE OUTPUT PARAMETER p-habilita       AS LOGICAL                       NO-UNDO.

    FIND FIRST item NO-LOCK
         WHERE item.it-codigo = p-it-codigo NO-ERROR.

    IF AVAIL item THEN DO:
        IF (p-ordem-servic = 0) AND
           ((item.tipo-contr = 1 OR item.tipo-contr = 4) OR
            (item.tipo-contr = 2 AND (p-ct-codigo + p-sc-codigo) <> "":U)) THEN
            ASSIGN p-habilita = YES.
        ELSE
            ASSIGN p-habilita = NO.
    END.
    
    {cdp/cd9911.i}

    IF l-usa-unid-negoc = YES THEN DO:
        IF CAN-FIND(FIRST unid-negoc-om NO-LOCK
                    WHERE unid-negoc-om.num-ord-manut = p-ordem-servic) THEN DO:
            ASSIGN p-habilita = YES.
        END.
        ELSE DO:
            RUN cdp/cd9902.p (INPUT 3).

            IF RETURN-VALUE = "OK":U THEN DO:
                IF NOT VALID-HANDLE(hMMVUnidNegoc) THEN
                    RUN frbo/bofr134.p PERSISTENT SET hMmvUnidNegoc.

                RUN canFindMatrizMMV IN hMMVUnidNegoc (INPUT p-ordem-servic).

                IF RETURN-VALUE = "OK":U THEN
                    ASSIGN p-habilita = YES.

                DELETE PROCEDURE hMMVUnidNegoc.
                ASSIGN hMMVUnidNegoc = ?.
            END.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preparaPedidoCompra DBOProgram
PROCEDURE preparaPedidoCompra :
/*------------------------------------------------------------------------------
  Purpose:    Valida dados para criaáao de novos pedidos de compra (wcc0310a).
  Parameters: opar1 : p-c-formato-cgc  : Formato do CGC da empresa
              opar2 : p-l-modulo-ge    : Indica se o m¢dulo gerencial est† implantado
              opar3 : p-c-end-cobranca : Endereáo de Cobranáa
              opar4 : p-c-end-entrega  : Endereáo de Entrega
              opar5 : p-i-cod-mensagem : C¢digo Mensagem
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-c-formato-cgc  AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-l-modulo-ge    AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER p-c-end-cobranca AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-c-end-entrega  AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-i-cod-mensagem AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER p-c-seg-usuario  AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-i-cond-pagto   AS INTEGER     NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST param-compra NO-LOCK NO-ERROR.

    IF l-estab-security-active THEN
        FOR FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel = pedido-compr.cod-estabel,
            FIRST {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = estabelec.cod-estabel: END.
    ELSE
        FOR FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel = pedido-compr.cod-estabel: END.

    ASSIGN i-empresa = estabelec.ep-codigo WHEN AVAIL estabelec.

    ASSIGN p-c-formato-cgc  = param-global.formato-id-federal
           p-c-end-entrega  = param-compra.end-entr-pad
           p-c-end-cobranca = param-compra.end-cobr-pad
           p-i-cod-mensagem = param-compra.cod-mensagem
           p-i-cond-pagto   = param-compra.cod-cond-pag
           p-c-seg-usuario  = c-seg-usuario.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE relacionaOrdemCompraPedido DBOProgram
PROCEDURE relacionaOrdemCompraPedido :
/*------------------------------------------------------------------------------
  Purpose:     Faz o Relacionamento da Ordem Compra com o Pedido.
  Parameters:  ipar1:  prOrdem  :Rowid da ordem a ser relacionada.

  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prOrdem   AS ROWID NO-UNDO.
    
    DEFINE VARIABLE h-bocx150        AS HANDLE             NO-UNDO.
    DEFINE VARIABLE l-acesso-bocx150 AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE l-acompanhamento AS LOGICAL INITIAL NO NO-UNDO.

    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND FIRST RowObject NO-LOCK NO-ERROR.

    FOR FIRST pedido-compr FIELDS(num-pedido data-pedido cod-estab-gestor end-entrega cod-estab-gestor) 
        WHERE pedido-compr.num-pedido = RowObject.num-pedido NO-LOCK: END.

    FIND FIRST ordem-compra 
         WHERE ROWID(ordem-compra) = prOrdem EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL ordem-compra THEN DO:

        /*API de Execucao Orcamentaria*/
        RUN cdp/cdapi197.p (INPUT ROWID(ordem-compra), INPUT ROWID(pedido-compr), INPUT 3, OUTPUT TABLE Rowerrors APPEND).

        ASSIGN ordem-compra.cod-estab-gestor = pedido-compr.cod-estab-gestor
               ordem-compra.num-pedido       = pedido-compr.num-pedido
               ordem-compra.situacao         = 2  /* Ordem Confirmada */
               ordem-compra.data-pedido      = pedido-compr.data-pedido
               ordem-compra.cod-estabel      = pedido-compr.end-entrega.

        FOR EACH prazo-compra 
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:

            ASSIGN prazo-compra.situacao = ordem-compra.situacao.

            /****************************************************************
            ** Integracao Compras - Importacao x MRP                       **
            ** Verifica se a ordem de compra esta vinculada a um processo  **
            ** de importacao com acompanhamento. Caso estiver, as parcelas **
            ** envolvidas serao setadas para nao serem reprogramadas MRP   **
            ****************************************************************/
            
            IF  CONNECTED("mgcex":U) AND (AVAIL param-global AND param-global.modulo-07) THEN DO:
                {inbo/boin295.i01}
            END.
        END.

        /*--- MIN X MMI - Preenche num-ord-inv a partir de uma ordem de manutenáao */
        IF l-min-mmi AND param-global.modulo-in AND ordem-compra.ordem-servic <> 0 THEN DO:

            RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.

            RUN BuscaOrdemInvOrdProd IN h-boiv028 (INPUT ordem-compra.ordem-servic,
                                                   INPUT-OUTPUT ordem-compra.num-ord-inv).
        END.

        /*---Modulo Investimento---*/
        IF  param-global.modulo-in AND ordem-compra.num-ord-inv <> 0 THEN DO:
            
            IF NOT VALID-HANDLE(h-boiv028) THEN
                RUN ivbo/boiv028.p PERSISTENT SET h-boiv028.

            RUN UpdateOrdPed IN h-boiv028 (INPUT ROWID(ordem-compra),
                                           INPUT-OUTPUT TABLE RowErrors).
        END.

        IF VALID-HANDLE(h-boiv028) THEN DO:
            DELETE PROCEDURE h-boiv028.
            ASSIGN h-boiv028 = ?.
        END.
        
        RUN ccp/ccapi001.p (INPUT ROWID(ordem-compra)).

        FIND FIRST emitente
            WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK NO-ERROR.

        /* Modulo de importacao com fornecedor estrangeiro ou trading*/
        IF  param-global.modulo-07 AND (emitente.natureza = 3 OR emitente.natureza = 4) THEN DO:
            
            IF NOT VALID-HANDLE(h-bocx341) THEN
                RUN cxbo/bocx341.p PERSISTENT SET h-bocx341.

            RUN openQueryStatic IN h-bocx341("main":U).
            RUN atualizaDespesasPedido IN h-bocx341 (INPUT 1,
                                                     INPUT ROWID(ordem-compra),
                                                     INPUT pedido-compr.num-pedido).
            RUN getRowErrors IN h-bocx341(OUTPUT TABLE rowErrors APPEND).
            FOR EACH RowErrors
                WHERE RowErrors.ErrorSubType = "ERROR":U
                  AND RowErrors.ErrorType    = "INTERNAL":U:
                DELETE RowErrors.
            END.
            DELETE PROCEDURE h-bocx341.
            ASSIGN h-bocx341 = ?.
        END.
        
        /* Inicio Siscoserv */
        IF UPPER(emitente.pais) <> "BRASIL":U THEN DO:

            /*Para ordens de compra que sejam de serviáo*/
            FOR FIRST item-uni-estab FIELDS(char-1)
                WHERE item-uni-estab.it-codigo   = ordem-compra.it-codigo
                  AND item-uni-estab.cod-estabel = ordem-compra.cod-estabel NO-LOCK:
            END.

            IF AVAIL item-uni-estab THEN /*Verifica se existe o item-uni-estab, e pega o tipo do item*/
                ASSIGN c-servico = SUBSTRING(item-uni-estab.char-1,133,1).
            ELSE DO: /*Se n∆o existir pega a informaá∆o da tabela de Item*/
                FOR FIRST item FIELDS(char-2)
                    WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK:
                END.
                IF AVAIL item THEN
                    ASSIGN c-servico = SUBSTRING(item.char-2,212,1).
            END.
            IF c-servico = "9":U OR ordem-compra.natureza = 2 THEN DO: /*Se o tipo for '9' - Serviáo ou a natureza da ordem for de serviáo*/
                
                /*Somente para emitentes extrangeiros*/                    
                FOR FIRST prazo-compra NO-LOCK
                    WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                    
                    IF NOT VALID-HANDLE(h-cdapi050) THEN
                        RUN cdp/cdapi050 PERSISTENT SET h-cdapi050.

                    RUN pi-siscoserv-ativo IN h-cdapi050.
                    IF RETURN-VALUE = "OK":U THEN
                        RUN pi-grava-ord-compra-sis IN h-cdapi050 (INPUT ordem-compra.numero-ordem,
                                                                   INPUT ordem-compra.num-pedido,
                                                                   INPUT STRING(ordem-compra.cod-emitente),
                                                                   INPUT ordem-compra.cod-estabel,
                                                                   INPUT prazo-compra.data-entrega).
                    IF VALID-HANDLE(h-cdapi050) THEN DO:
                        DELETE PROCEDURE h-cdapi050.
                        ASSIGN h-cdapi050 = ?.
                    END.
                END.
            END.
        END.

    END. /* AVAIL ordem-compra */

    /* Include i-epc200.i2: Criaáao de registro para temp-table tt-epc */
    FOR EACH tt-epc WHERE tt-epc.cod-event = "relacionaOrdemCompraPedido".
        DELETE tt-epc.
    END.
    {include/i-epc200.i2 &CodEvent='"relacionaOrdemCompraPedido"'
                         &CodParameter='"OBJECT-HANDLE"'
                         &ValueParameter="string(this-procedure)"}
    {include/i-epc200.i2 &CodEvent='"relacionaOrdemCompraPedido"'
                         &CodParameter='"rowid-ordem-compra"'
                         &ValueParameter="string(prOrdem)"}
    /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i "relacionaOrdemCompraPedido"}

    IF RETURN-VALUE = "NOK":U THEN DO:
        UNDO, RETURN "NOK":U.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaMsgAprovacao DBOProgram
PROCEDURE retornaMsgAprovacao :
/*------------------------------------------------------------------------------
  Purpose:
     Retorna informaáao se o Documento esta pendente de aprovaáao.
     Com as informaáoes: Moeda Conversao  : *****
                         Limite Aprovaáao : *****
                         Valor Documento  : *****
  Parameters:  <none>
     ipar1 : prOrdem : rowid registro ordem-compra

  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prOrdem AS ROWID NO-UNDO.

    /* Cria rowErrors que pode ser retornado pela procedure getRowErrors */
    IF  NOT AVAIL ordem-compra
    OR  (AVAIL ordem-compra AND ROWID(ordem-compra) <> prOrdem) THEN
        FOR FIRST ordem-compra FIELDS() 
            WHERE ROWID(ordem-compra) = prOrdem NO-LOCK:
        END.

    IF SUBSTRING(param-compra.char-2, 7, 3) = "nao":U THEN DO:
        
        FIND FIRST ordem-compra
             WHERE ROWID(ordem-compra) = prOrdem NO-LOCK NO-ERROR.
         
        IF AVAIL ordem-compra THEN
            ASSIGN c-numero-ordem = STRING(ordem-compra.numero-ordem,"zzzzz9,99":U).
    END.

    IF NOT AVAIL pedido-compr THEN
        FIND FIRST pedido-compr
             WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.

    IF AVAIL ordem-compra THEN DO:

        IF NOT AVAIL param-compra THEN
            FIND FIRST param-compra NO-LOCK NO-ERROR.

        IF param-compra.log-1 AND (param-compra.int-1 = 2 OR param-compra.int-1 = 3) THEN DO:
            
            IF pedido-compr.emergencial THEN
                RUN cdp/cdapi174.p (6,
                                    ROWID(ordem-compra),
                                    OUTPUT i-moeda-lim,
                                    OUTPUT i-tipo-moeda,
                                    OUTPUT de-valor-doc,
                                    OUTPUT de-valor-lim).
            ELSE
                RUN cdp/cdapi174.p (4,
                                    ROWID(ordem-compra),
                                    OUTPUT i-moeda-lim,
                                    OUTPUT i-tipo-moeda,
                                    OUTPUT de-valor-doc,
                                    OUTPUT de-valor-lim).

            FIND FIRST moeda 
                 WHERE moeda.mo-codigo = i-moeda-lim NO-LOCK NO-ERROR.

            ASSIGN c-moeda-lim  = STRING(i-moeda-lim,"9":U) + " - ":U + moeda.descricao.

            CASE i-tipo-moeda:
                WHEN 1 THEN DO:
                    ASSIGN c-tipo-moeda = "(Usu†rio)":U.
                END.
                WHEN 2 THEN DO:
                    ASSIGN c-tipo-moeda = "(Aprovador)":U.
                END.
                WHEN 3 THEN DO:
                    ASSIGN c-tipo-moeda = "(Fam°lia)":U.
                END.
                WHEN 4 THEN DO:
                    ASSIGN c-tipo-moeda = "(Mestre)":U.
                END.
            END CASE.

            IF pedido-compr.emergencial THEN
               RUN cdp/cdapi172.p (INPUT 6, INPUT ROWID(ordem-compra), OUTPUT l-pendente).
            ELSE
               RUN cdp/cdapi172.p (INPUT 4, INPUT ROWID(ordem-compra), OUTPUT l-pendente).

            IF l-pendente = NO THEN DO:
                IF  SUBSTRING(param-compra.char-2, 7, 3) = "nao":U THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="16725"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="INFORMATION":U
                                                &ErrorParameters= "c-moeda-lim + '~~~~'  + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') +
                                                                   c-tipo-moeda + '~~~~~' + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99') +
                                                                   '~~~~~' + c-numero-ordem"}

                END.
                ELSE DO:
                     {method/svc/errors/inserr.i &ErrorNumber="16725"
                                                 &ErrorType="EMS":U
                                                 &ErrorSubType="INFORMATION":U
                                                 &ErrorParameters="c-moeda-lim + '~~~~'  + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') +
                                                                   c-tipo-moeda + '~~~~~' + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')"}
                END.
            END.
            ELSE DO:
                IF SUBSTRING(param-compra.char-2, 7, 3) = "nao":U THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="16724"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="INFORMATION":U
                                                &ErrorParameters="c-moeda-lim + '~~~~'  + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') +
                                                                  c-tipo-moeda + '~~~~~' + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99') +
                                                                  '~~~~~' + c-numero-ordem"}
                END.
                ELSE DO:
                     {method/svc/errors/inserr.i &ErrorNumber="16724"
                                                 &ErrorType="EMS":U
                                                 &ErrorSubType="INFORMATION":U
                                                 &ErrorParameters="c-moeda-lim + '~~~~'  + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') +
                                                                   c-tipo-moeda + '~~~~~' + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')"}
                END.
            END.
        END.
        ELSE DO:
             IF NOT CAN-FIND(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="16760"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="INFORMATION":U}
             END.
             ELSE
                 RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnParamConsEmitenteNota DBOProgram
PROCEDURE returnParamConsEmitenteNota :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER cConsEmitenteNota AS CHARACTER NO-UNDO.

    FOR FIRST param-re FIELDS(usuario rec-out-for) 
        WHERE param-re.usuario = c-seg-usuario  NO-LOCK: END.

    ASSIGN cConsEmitenteNota = STRING(param-re.rec-out-for).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnRowidFirstOCPedido DBOProgram
PROCEDURE returnRowidFirstOCPedido :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-pedido AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-rowid-oc   AS ROWID     NO-UNDO.

    FOR FIRST ordem-compra FIELDS()
        WHERE ordem-compra.num-pedido = p-num-pedido NO-LOCK: END.

    IF AVAIL ordem-compra THEN
        ASSIGN p-rowid-oc = ROWID(ordem-compra).
    ELSE
        ASSIGN p-rowid-oc = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcNumPedido AS CHARACTER NO-UNDO.

    RUN SetConstraintByPedido (INT(pcNumPedido)).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piCodFornec AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER piNumPedido AS INTEGER NO-UNDO.

    RUN setConstraintByEmitente (piCodFornec, piNumPedido).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByEmitente DBOProgram
PROCEDURE setConstraintByEmitente :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piCodEmit   AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER piNumPedido AS INTEGER NO-UNDO.

    ASSIGN iCodEmit   = piCodEmit
           iNumPedido = piNumPedido.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintByPedido DBOProgram
PROCEDURE SetConstraintByPedido :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piNumPedido AS INTEGER NO-UNDO.

    ASSIGN iNumPedido = piNumPedido.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintByPedidoToReceb DBOProgram
PROCEDURE SetConstraintByPedidoToReceb :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piCodEmitente  AS INTEGER  NO-UNDO.

    ASSIGN iCodEmit    = piCodEmitente.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLSegcc0300 DBOProgram
PROCEDURE setLSegcc0300:
/*------------------------------------------------------------------------------
  Purpose: Modifica o status da variˇvel l-seg-cc0300. Indica se o usuˇrio serˇ validado
           ou nao em relaáao a sua permissao para inserir, alterar ou remover pedidos na
           tela cc0300.
  Parameters:
  Notes: PARA SER EXECUTADA SOMENTE DO PROGRAMA CC0300 OU DAS TELAS FILHO
         PARA CONTROLAR SEGURAN∞A POR USUµRIO PARA A∞aES(INSER∞ÄO, ALTERA∞ÄO OU REMO∞ÄO)
         SOB PEDIDO DE COMPRA
------------------------------------------------------------------------------*/
    {cdp/cd9731.i5}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRangePedido DBOProgram
PROCEDURE setRangePedido :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-pedido-ini LIKE pedido-compr.num-pedido NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-pedido-fim LIKE pedido-compr.num-pedido NO-UNDO.

    ASSIGN i-num-pedido-ini = pi-num-pedido-ini
           i-num-pedido-fim = pi-num-pedido-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTipoTrans DBOProgram
PROCEDURE setTipoTrans :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-tipo-trans AS CHARACTER NO-UNDO.

    ASSIGN c-tipo-trans = pc-tipo-trans.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTRowidOrdem DBOProgram
PROCEDURE setTTRowidOrdem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-ordem-rowid.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaAtivBotoesPedEmerg DBOProgram
PROCEDURE validaAtivBotoesPedEmerg :
/*------------------------------------------------------------------------------
  Purpose:    Valida a ativaáao dos botoes de inclusao modificaáao e exclusao no programa de
              pedidos emergenciais (cc0310).
  Parameters:  ipar1  : piNumPedido     : n£mero do pedido.
               opar2  : plEnableButtons : Habilita botoes(yes/no)?
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piNumPedido      AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnableButtons  AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnableButonAdd AS LOGICAL NO-UNDO.

    FOR FIRST pedido-compr FIELDS(num-pedido nr-contrato situacao emergencial)
        WHERE pedido-compr.num-pedido = piNumPedido NO-LOCK: END.

    /********************************************************
    A partir da 2.03 o cc0310 incorporou as funcionalidades
    do c0304 e cc0308, o que causou mudanáas na l¢gica abaixo.
    ********************************************************/

    IF AVAIL pedido-compr THEN DO:
         IF pedido-compr.nr-contrato = 0  AND (pedido-compr.situacao = 1 OR pedido-compr.situacao = 2) THEN
             ASSIGN plEnableButtons = YES.
         ELSE
             ASSIGN plEnableButtons = NO.
    END.
    ELSE
        ASSIGN plEnableButtons = NO.

    ASSIGN plEnableButonAdd = plEnableButtons.

    IF plEnableButonAdd AND pedido-compr.emergencial = NO THEN DO:
        ASSIGN plEnableButonAdd = NO.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaCondicaoEspecifica DBOProgram
PROCEDURE validaCondicaoEspecifica :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  ipar2  : l-clicou-bt-espec     : Clicou no botao de cond especif(yes/no)?
               ipar2  : i-numPedido           : numero pedido
               ipar3  : i-cod-cond-pag        : cond especif informada
               ipar4  : l-carregou-tabela     : J† informou os prazos da cond especif(yes/no)?
               opar5  : l-inform-cond-especif : chama o programa para informar os prazos(yes/no)?

  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER l-clicou-bt-espec     AS LOGICAL NO-UNDO.
    DEFINE INPUT  PARAMETER i-numPedido           AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER i-cod-cond-pag        AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER l-carregou-tabela     AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER l-inform-cond-especif AS LOGICAL NO-UNDO.
   
    IF l-clicou-bt-espec THEN DO:
        IF i-cod-cond-pag = 0 OR i-cod-cond-pag = ? THEN
            ASSIGN l-inform-cond-especif = YES.
        ELSE DO:
            ASSIGN l-inform-cond-especif = NO.
            /* Condiáao informada nao Ç espec°fica */
            {method/svc/errors/inserr.i &ErrorNumber="25194"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
        END.
    END.
    ELSE DO:
        IF NOT l-carregou-tabela AND (i-cod-cond-pag = 0 OR i-cod-cond-pag = ?) THEN DO:

           FIND FIRST cond-especif WHERE cond-especif.num-pedido = i-numPedido NO-LOCK NO-ERROR.
           IF NOT AVAIL cond-especif THEN DO:
               /* ù necess†rio informar os prazos da condiáao espec°fica */
               {method/svc/errors/inserr.i &ErrorNumber="15052"
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR"}
           END.
        END.
    END.

    IF l-portal-paradigma THEN DO:

        FIND FIRST pedido-compr NO-LOCK
             WHERE pedido-compr.num-pedido = i-numPedido NO-ERROR.

        IF AVAIL pedido-compr AND
           &IF "{&bf_mat_versao_ems}":U  <  "2.09":U  &THEN
               SUBSTRING(pedido-compr.char-1,55,1) = "S":U
           &ELSE
               pedido-compr.log-envdo-integr
           &ENDIF
        THEN DO:
            /* Pedido integrado com o Portal de Compras */
            {method/svc/errors/inserr.i &ErrorNumber="52210"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
        END.
    END.

     IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaContratoPedidoCompr DBOProgram
PROCEDURE validaContratoPedidoCompr :
/*------------------------------------------------------------------------------
  Purpose: Valida Pedido de Compra antes de altera-lo ou elimina-lo
           logicamente (nao fisicamente) no cc0308.w, e na manutencao
           de ordens ou parcelas (tambem no cc0308.w).
           L¢gica proveniente da include {ccp/cc0308.i}
  Parameters: ipar1 : rPedido   : Numero do pedido a ser validado
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER rPedido AS ROWID NO-UNDO.

    FOR FIRST pedido-compr FIELDS(situacao nr-contrato num-pedido) 
        WHERE ROWID(pedido-compr) = rPedido NO-LOCK: END.

    IF pedido-compr.situacao = 3 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="1813"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
    END.

    IF pedido-compr.nr-contrato <> 0 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="1806"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
    END.

    IF CAN-FIND(FIRST recebimento 
                WHERE recebimento.num-pedido = pedido-compr.num-pedido) THEN DO:
        
        {utp/ut-liter.i "Pedido_de_Compra" *}.
        {method/svc/errors/inserr.i &ErrorNumber="3106"
                                   &ErrorType="EMS":U
                                   &ErrorSubType="INFORMATION":U
                                   &ErrorParameters=TRIM(RETURN-VALUE)}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEmitenteImport DBOProgram
PROCEDURE validaEmitenteImport :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cod-emitente  AS INTEGER              NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-pedido    AS INTEGER              NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-estrangeiro  AS LOGICAL INITIAL YES  NO-UNDO.
    DEFINE OUTPUT PARAMETER pr-processo-imp AS ROWID                NO-UNDO.

    DEFINE VARIABLE hDBOProcesso-imp AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hDBOEmitente     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i-natureza       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-return         AS CHARACTER   NO-UNDO.

    RUN adbo/boad098na.p PERSISTENT SET hDBOEmitente.
    RUN openQueryStatic IN hDBOEmitente (INPUT "Main":U).
    RUN goTokey IN hDBOEmitente (INPUT p-cod-emitente).

    IF RETURN-VALUE = "":U OR RETURN-VALUE = "OK":U THEN
        RUN getIntField IN hDBOEmitente (INPUT "natureza":U,OUTPUT i-natureza).
    
    DELETE PROCEDURE hDBOEmitente.

    IF i-natureza < 3 THEN
        ASSIGN pl-estrangeiro = NO.

    RUN cxbo/bocx140.p PERSISTENT SET hDBOProcesso-imp.
    RUN findPedido IN hDBOProcesso-imp (INPUT p-num-pedido,OUTPUT c-return).

    IF c-return = "":U THEN
        RUN getRowid IN hDBOProcesso-imp (OUTPUT pr-processo-imp).
    
    DELETE PROCEDURE hDBOProcesso-imp.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaFuncoesIncModElimPedEmerg DBOProgram
PROCEDURE validaFuncoesIncModElimPedEmerg :
/*------------------------------------------------------------------------------
  Purpose:   Valida a ativaáao dos botoes de inclusao modificaáao e exclusao no
             programa de pedidos emergenciais
  Parameters:  ipar1  : prChaveOrdem    : rowid Ordem Compra
               opar2  : plEnableButtons : habilita botoes(sim/nao)?
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prChaveOrdem      AS ROWID      NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnableButtons   AS LOGICAL    NO-UNDO.

    FOR FIRST ordem-compra FIELDS(num-pedido numero-ordem nr-contrato) 
        WHERE ROWID(ordem-compra) = prChaveOrdem NO-LOCK: END.

    IF AVAIL ordem-compra THEN DO:
        FOR FIRST pedido-compr FIELDS(num-pedido situacao nr-contrato) 
            WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.
            
        IF ordem-compra.nr-contrato <> 0 OR
           CAN-FIND(FIRST recebimento WHERE
                          recebimento.numero-ordem = ordem-compra.numero-ordem ) OR
           pedido-compr.situacao = 1 OR /* Impresso */
           pedido-compr.situacao = 3 OR /* Eliminado */
           pedido-compr.nr-contrato <> 0 THEN
            ASSIGN plEnableButtons = NO.
        ELSE
            ASSIGN plEnableButtons = YES.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaParamWcc9002 DBOProgram
PROCEDURE validaParamWcc9002 :
/*------------------------------------------------------------------------------
  Purpose:     Valida a moeda e verifica se algum parÉmetro foi selecionado. Se
               uma destas condiáoes for verdadeira, inclui erro na RowErrors.
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER l-naocon       AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER l-termin       AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER l-confir       AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER l-elimin       AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER l-em-cotacao   AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER l-cotada       AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER i-moeda        AS INTEGER    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF l-naocon     = "no":U AND
       l-termin     = "no":U AND
       l-confir     = "no":U AND
       l-elimin     = "no":U AND
       l-em-cotacao = "no":U AND
       l-cotada     = "no":U THEN DO:
        
        {method/svc/errors/inserr.i &ErrorNumber="2171"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U} /* ParÉmetros nao informado */
    END.

    FIND FIRST moeda WHERE moeda.mo-codigo = i-moeda NO-LOCK NO-ERROR.
    
    IF NOT AVAIL moeda THEN DO:
        
        {method/svc/errors/inserr.i &ErrorNumber="4929"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=STRING(i-moeda)} /* Moeda Nao Cadastrada */
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaRelacinamentoOrdemPedido DBOProgram
PROCEDURE validaRelacinamentoOrdemPedido :
/*------------------------------------------------------------------------------
  Purpose: Faz a validaáao do Relacionamento da Ordem-Compra x Pedido.
  Parameters: ipar1:  prOrdem : rowid da ordem a ser relacionada.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prOrdem      AS ROWID   NO-UNDO.
    DEFINE INPUT PARAMETER plConfEstab  AS LOGICAL NO-UNDO.

    DEFINE BUFFER b-ordem-compra FOR ordem-compra.
    DEFINE BUFFER b-cotacao-item FOR cotacao-item.
    
    DEFINE VARIABLE l-incoterm AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE c-msg      AS CHARACTER NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST RowObject    NO-LOCK NO-ERROR.

    FOR FIRST ordem-compra FIELDS(numero-ordem num-pedido cod-estabel) 
        WHERE ROWID(ordem-compra) = prOrdem NO-LOCK: END.
    
    IF  ordem-compra.num-pedido <> 0 THEN DO:
        
        {utp/ut-liter.i "Ordem_de_Compra_ja_relacionada_ao_Pedido" *}
        ASSIGN c-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-msg +
                                                      string(ordem-compra.num-pedido) + '.'"}
    END.
        
    /****** Consiste estabelecimento Gestor da Ordem  *******/

    IF ordem-compra.cod-estab-gestor <> "":U THEN DO:

        RUN ccp/ccapi199.p (INPUT "ordem-compra":U, INPUT ROWID(ordem-compra), OUTPUT l-erro).

        IF  l-erro THEN DO:
            /*Ordem so pode ser alterado no estabelecimento gestor.*/
            {utp/ut-liter.i Ordem}
            ASSIGN c-msg = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Gestor}
            ASSIGN c-msg = c-msg + '~~' + TRIM(RETURN-VALUE).

            {method/svc/errors/inserr.i &ErrorNumber="18200"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters= c-msg}
        END.
    END.
        

    /****** Consiste estabelecimento da ordem e do pedido  *******/

    IF ordem-compra.cod-estabel <> RowObject.end-entrega  THEN DO:
        IF plConfEstab = NO THEN DO:
           
           {utp/ut-liter.i "da_Ordem_de_Compra_Ç_diferente_do_estabelecimento_de_entrega" *}
           ASSIGN c-msg = TRIM(RETURN-VALUE).
           {utp/ut-liter.i "do_Pedido" *}
           
           {method/svc/errors/inserr.i &ErrorNumber="27858"
                                       &ErrorType="EMS":U
                                       &ErrorSubType="ERROR":U
                                       &ErrorParameters=" ordem-compra.cod-estabel +
                                                          ' ' + c-msg + ' '
                                                          + STRING(RowObject.end-entrega) + ' ' + TRIM(RETURN-VALUE) + '.'"}
        END.
        ELSE DO:
            
            {utp/ut-liter.i "da_Ordem_de_Compra_Ç_diferente_do_estabelecimento_de_entrega" *}
            ASSIGN c-msg = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "do_Pedido" *}
            
            {method/svc/errors/inserr.i &ErrorNumber="2060"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" ordem-compra.cod-estabel +
                                                           ' ' + c-msg + ' '
                                                           + STRING(RowObject.end-entrega) + ' ' + TRIM(RETURN-VALUE) + '.'"}
        END.
    END.

    IF AVAILABLE ordem-compra THEN DO:
        IF RowObject.nr-contrato <> 0 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="6156"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        END.
    END.

    /* Consiste data de entrega, deve ser maior ou igual a Data de Implantacao do Pedido  */
    FOR FIRST prazo-compra FIELDS(data-entrega) 
        WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
          AND prazo-compra.data-entrega < RowObject.data-pedido
          AND prazo-compra.situacao    <> 4 /* Eliminada */  NO-LOCK:
        {utp/ut-liter.i "Prazo_Compra" *}
        ASSIGN c-msg = TRIM(RETURN-VALUE) + ':':U + STRING(prazo-compra.data-entrega) + ') ':U.
        {utp/ut-liter.i "da_Ordem_de_Compra" *}
        ASSIGN c-msg = c-msg + TRIM(RETURN-VALUE) + '(':U + STRING(ordem-compra.numero-ordem) + '~~' + STRING(RowObject.data-pedido).
        {method/svc/errors/inserr.i &ErrorNumber="5668"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters= c-msg}
    END.

    if CAN-FIND(first RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    /*  Integraáao M¢dulo Importaáao */
    RUN validateImportacao (INPUT rowObject.cod-emitente, INPUT ordem-compra.numero-ordem).
    
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaSegUsuarioPedCompra DBOProgram
PROCEDURE validaSegUsuarioPedCompra :
/*------------------------------------------------------------------------------
  Purpose: Validar a permissao do usuˇrio logado quanto π insersao, alteracao e remocao de
           um pedido de compra.
  Parameters:
  Notes: VALIDACAO PARA SER EXECUTADA DO PROGRAMA CC0300 OU DAS TELAS FILHO
         PARA CONTROLAR SEGURANCA POR USUARIO PARA ACOES(INSERCAO, ALTERACAO OU REMOCAO)
         SOB PEDIDO DE COMPRA
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pr-pedido AS ROWID     NO-UNDO.
    DEFINE INPUT PARAMETER pc-tipo   AS CHARACTER NO-UNDO.


    FOR FIRST pedido-compr FIELDS (emergencial situacao)
        WHERE ROWID(pedido-compr) = pr-pedido NO-LOCK:
    END.

    RUN setLSegcc0300.

    IF l-seg-cc0300 = YES AND AVAIL pedido-compr THEN DO:
        RUN validateSegCC0300 (INPUT pc-tipo,
                               INPUT pedido-compr.emergencial,
                               INPUT pedido-compr.situacao).
    END.
	
	RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateBusinessLogicPedEmerg DBOProgram
PROCEDURE validateCreateBusinessLogicPedEmerg :
/*------------------------------------------------------------------------------
  Purpose:     Validaáoes de neg¢cio para criaáao de
               novos registros.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    IF param-global.modulo-bh AND
       CAN-FIND (FIRST his-pedido-compr 
                 WHERE his-pedido-compr.num-pedido = rowObject.num-pedido) THEN DO:
        
        {utp/ut-liter.i "Hist¢rico_do_Pedido_Compra" *}
            
        {method/svc/errors/inserr.i &ErrorNumber="4521"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
    END.

    FOR FIRST emitente FIELDS(cod-emitente identific) 
        WHERE emitente.cod-emitente = rowObject.cod-emitente 
          AND emitente.identific   <> 1 NO-LOCK: END.

    IF NOT AVAILABLE emitente THEN DO:
        
        {utp/ut-liter.i "Fornecedor" *}
        
        {method/svc/errors/inserr.i &ErrorNumber="47"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
    END.

    IF rowObject.cod-emitente = 0 THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="3278"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    IF rowObject.num-pedido < param-compra.num-pedido-ini 
    OR rowObject.num-pedido > param-compra.num-pedido-fim THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="7959"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    RUN inbo/boin356vl.p PERSISTENT SET h-boin356vl.
    
    /**Valida a situacao do fornecedor na inclusao do pedido**/
    RUN ValidateStatusFornec in h-boin356vl (rowObject.data-pedido, rowObject.cod-emitente).

    RUN getRowErrors IN h-boin356vl (OUTPUT TABLE rowErrorsAux).

    FOR EACH RowErrorsAux:
        CREATE RowErrors.
        BUFFER-COPY RowErrorsAux TO RowErrors.
    END.

    EMPTY TEMP-TABLE RowErrorsAux.
    DELETE PROCEDURE h-boin356vl.
    ASSIGN h-boin356vl = ?.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreatePedEmerg DBOProgram
PROCEDURE validateCreatePedEmerg :
/*------------------------------------------------------------------------------
  Purpose: Valida criaáao da tabela/duplicidade de registro.
  Parameters:  opar1  : r-chave  :retorna rowid do registro criado.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR RowObject.
    DEFINE OUTPUT PARAMETER piNumNewPedido AS INTEGER NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.
    
    FIND FIRST rowObject    NO-LOCK NO-ERROR.
    FIND FIRST param-compra NO-LOCK NO-ERROR.

    RUN validateRecord (INPUT "Create":U).
    RUN validateFieldsBusinessLogicPedEmerg.
    RUN validateCreateBusinessLogicPedEmerg.

    ASSIGN piNumNewPedido = iNumNewPedido.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteBusinessLogic DBOProgram
PROCEDURE validateDeleteBusinessLogic :
/*------------------------------------------------------------------------------
  Purpose:     Validaáoes de neg¢cio para exclusao de registros.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    
    IF NOT AVAIL param-global THEN
       FIND FIRST param-global NO-LOCK NO-ERROR.
    
    IF NOT AVAIL param-compra THEN
       FIND FIRST param-compra NO-LOCK NO-ERROR.

    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = pedido-compr.cod-estabel: END.

    ASSIGN i-empresa = estabelec.ep-codigo WHEN AVAIL estabelec.

    IF pedido-compr.situacao = 1 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="1812"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
    END.

    IF pedido-compr.situacao = 3 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="1813"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    IF pedido-compr.nr-contrato <> 0 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="1806"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    IF CAN-FIND(FIRST recebimento 
                WHERE recebimento.num-pedido = pedido-compr.num-pedido) THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="16295"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    /* O uso do buffer Ç necess†rio para nao desposicionar o registro. */
    FIND FIRST bf{&TableName} 
         WHERE bf{&TableName}.num-pedido = pedido-compr.num-pedido EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

    IF LOCKED bf{&TableName} THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="1815"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    IF param-global.modulo-in AND
       CAN-FIND (FIRST ordem-compra 
                 WHERE ordem-compra.num-pedido = pedido-compr.num-pedido 
                   AND  ordem-compra.num-ord-inv <> 0) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="1816"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
    END.
  
    FIND FIRST cond-especif 
         WHERE cond-especif.num-pedido = pedido-compr.num-pedido EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL cond-especif THEN
        DELETE cond-especif.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldsBusinessLogicPedEmerg DBOProgram
PROCEDURE validateFieldsBusinessLogicPedEmerg :
/*------------------------------------------------------------------------------
  Purpose:    Validaáoes de neg¢cio a serem efetuadas
              tanto na atualizaáao quanto na criaáao
              de novos registros.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    
    FIND FIRST param-compra NO-LOCK NO-ERROR.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND FIRST RowObject NO-LOCK NO-ERROR.
    
    IF rowObject.cod-emit-terc <> 0 THEN DO:
        FOR FIRST emitente FIELDS(cod-emitente identific) 
            WHERE emitente.cod-emitente = rowObject.cod-emit-terc 
            NO-LOCK: END.
    
        IF NOT AVAILABLE emitente THEN DO:
            
            {utp/ut-liter.i "Emitente Entrega" *}
            
            {method/svc/errors/inserr.i &ErrorNumber="47"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
    END.

    IF rowObject.nr-processo <> 0 THEN DO:

        FOR FIRST proc-compra FIELDS(nr-processo cod-comprado) 
            WHERE proc-compra.nr-processo = rowObject.nr-processo NO-LOCK: END.

        IF NOT AVAIL proc-compra THEN DO:

            {utp/ut-liter.i "Processo_de_Compras" *}

            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.

        FIND FIRST proc-fornec 
             WHERE proc-fornec.nr-processo  = rowObject.nr-processo 
               AND proc-fornec.cod-emitente = rowObject.cod-emitente NO-LOCK NO-ERROR.

        IF NOT AVAIL proc-fornec THEN DO:

            {utp/ut-liter.i "Fornecedor" *}
            
            {method/svc/errors/inserr.i &ErrorNumber="2147"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
    END.

    IF rowObject.cod-cond-pag > 0 THEN DO:
        IF NOT CAN-FIND(FIRST cond-pagto 
                        WHERE cond-pagto.cod-cond-pag = rowObject.cod-cond-pag ) THEN DO:

            {utp/ut-liter.i "Condiáao_de_Pagamento" *}
            
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="TRIM(RETURN-VALUE) + ' ' + string(rowObject.cod-cond-pag)"}
        END.
    END.

    IF NOT CAN-FIND(FIRST transporte 
                    WHERE transporte.cod-transp = rowObject.cod-transp ) THEN DO:

        {utp/ut-liter.i "Transportador" *}
        
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
    END.

    IF NOT CAN-FIND(FIRST mensagem 
                    WHERE mensagem.cod-mensagem = rowObject.cod-mensagem ) THEN DO:
        
        {utp/ut-liter.i "Mensagem" *}
        
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
    END.

    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = rowObject.end-entrega NO-LOCK NO-ERROR.

    IF NOT AVAIL estabelec THEN DO:
        
        {utp/ut-liter.i "Estabelecimento_de_Entrega" *}
        
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
    END.

    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = rowObject.end-cobranca NO-LOCK NO-ERROR.

    IF NOT AVAIL estabelec THEN DO:
        
        {utp/ut-liter.i "Estabelecimento_de_Cobranáa" *}
        
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
    END.

    IF NOT CAN-FIND (FIRST usuar-mater 
                     WHERE usuar-mater.cod-usuario = rowObject.responsavel 
                       AND usuar-mater.usuar-comprador) THEN DO:
        
        {method/svc/errors/inserr.i &ErrorNumber="17063"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="rowObject.responsavel"}
    END.

    IF RowObject.data-pedido = ? THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="173"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
        RETURN "NOK":U.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldsPedido DBOProgram
PROCEDURE validateFieldsPedido :
/*------------------------------------------------------------------------------
  Purpose:  Validaáoes de neg¢cio a serem efetuadas tanto na atualizaáao quanto na criaáao
            de novos registros.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    FIND FIRST RowObject NO-ERROR.

    IF NOT CAN-FIND(FIRST estabelec 
                    WHERE estabelec.cod-estabel = RowObject.end-entrega) THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="8416"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    IF NOT CAN-FIND(FIRST estabelec 
                    WHERE estabelec.cod-estabel = RowObject.end-cobranca) THEN DO:
        
        {utp/ut-liter.i "de_Cobranáa" *}
        
        {method/svc/errors/inserr.i &ErrorNumber="13"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="' ' + TRIM(RETURN-VALUE) + ' '"}
    END.

    IF NOT CAN-FIND(FIRST transporte 
                    WHERE transporte.cod-transp = RowObject.cod-transp) THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="2190"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    IF NOT CAN-FIND(FIRST mensagem 
                    WHERE mensagem.cod-mensagem = RowObject.cod-mensagem) THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="5328"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateImportacao DBOProgram
PROCEDURE validateImportacao :
/*------------------------------------------------------------------------------
  Purpose:     Validaáoes para o m¢dulo de Importaáao / Incoterm Ordem de Compra
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-emitente LIKE emitente.cod-emitente     NO-UNDO.
    DEFINE INPUT PARAMETER p-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    DEFINE VARIABLE h-boin082i AS HANDLE NO-UNDO.

    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    IF NOT AVAIL param-global OR NOT param-global.modulo-07 THEN
        RETURN "OK":U.

    RUN inbo/boin082i.p PERSISTENT SET h-boin082i.
    RUN validateVinculacaoOrdemPedido IN h-boin082i (INPUT p-cod-emitente,
                                                     INPUT rowObject.num-pedido,
                                                     INPUT p-numero-ordem,
                                                     OUTPUT TABLE tt-bo-erro).
    DELETE PROCEDURE h-boin082i.

    IF RETURN-VALUE = "NOK":U THEN DO:
        FIND FIRST tt-bo-erro NO-ERROR.
        IF AVAIL tt-bo-erro THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17478"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaáao (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE l-ind-drop-shipment              AS LOGICAL NO-UNDO.

    /*--- Utilize o parfmetro pType para identificar quais as validaáoes a serem  executadas ---*/
    /*--- Os valores poss°veis para o parfmetro sao: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaáoes ---*/
    
    FIND FIRST RowObject NO-ERROR.
    
    RUN ccp/ccPedidoCompraValidaIntegraMe.p PERSISTENT SET h-ccPedidoCompraValidaIntegraMe.
    
    RUN verifica-pedido-compra-me IN h-ccPedidoCompraValidaIntegraMe (INPUT RowObject.num-pedido, OUTPUT isOrderIntegrMe).

    IF pType = "Create":U THEN DO:
        
        FIND FIRST {&TableName} 
             WHERE {&TableName}.num-pedido = RowObject.num-pedido NO-LOCK NO-ERROR.

        IF AVAIL {&TableName} THEN DO:
            {utp/ut-liter.i "Pedido_de_Compra" *}
            
            {method/svc/errors/inserr.i &ErrorNumber="11"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
                                        
            RUN geraNumeroPedidoCompra (OUTPUT iNumNewPedido).
            
            {method/svc/errors/inserr.i &ErrorNumber="19158"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="INFORMATION":U
                                        &ErrorParameters="TRIM(STRING(RowObject.num-pedido)) + '~~~~' + STRING(iNumNewPedido)"}
        END.

        IF RowObject.num-pedido = 0 THEN DO:
            {utp/ut-liter.i "Nro_nao_pode_ser_zero" *}
            
            {method/svc/errors/inserr.i &ErrorNumber="6363"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
                                        
            RUN geraNumeroPedidoCompra (OUTPUT iNumNewPedido).
        END.
        
        /* Include i-epc200.i2: Criaáao de registro para temp-table tt-epc */
        FOR EACH tt-epc WHERE tt-epc.cod-event = "afterValidateCreate":U.
            DELETE tt-epc.
        END.
        {include/i-epc200.i2 &CodEvent='"afterValidateCreate"'
                             &CodParameter='"OBJECT-HANDLE"'
                             &ValueParameter="string(this-procedure)"}
        {include/i-epc200.i2 &CodEvent='"afterValidateCreate"'
                             &CodParameter='"numero-pedido"'
                             &ValueParameter="string(iNumNewPedido)"}
        /* Include i-epc201.i: Chamada do programa de EPC */
        {include/i-epc201.i "afterValidateCreate"}
        IF RETURN-VALUE = "NOK":U THEN DO:
            UNDO, RETURN "NOK":U.
        END.
    END.
    IF pType = "Update":U THEN DO:
    

        
        IF RowObject.situacao = 3 THEN DO:
            /* registro nao pode ser modificado, pois j† foi eliminado: 1805 */
            {method/svc/errors/inserr.i &ErrorNumber="1805"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        END.
        
        FIND FIRST param-global NO-LOCK NO-ERROR.

        IF AVAIL param-global THEN DO:
            IF param-global.modulo-cp THEN DO:
                FOR FIRST pedido-compr FIELDS (pedido-compr.num-pedido pedido-compr.cod-estabel)
                    WHERE pedido-compr.num-pedido = RowObject.num-pedido NO-LOCK:

                    IF pedido-compr.cod-estabel <> RowObject.end-entrega THEN DO:
                        FOR FIRST ordem-compra FIELDS (ordem-servic)
                            WHERE ordem-compra.num-pedido = RowObject.num-pedido NO-LOCK:

                            FIND FIRST ord-prod
                                 WHERE ord-prod.nr-ord-produ = ordem-compra.ordem-servic no-lock NO-ERROR.

                            IF AVAIL ord-prod THEN DO:
                                IF ord-prod.cod-estabel <> RowObject.end-entrega THEN DO:
                                    {method/svc/errors/inserr.i &ErrorNumber="15189"
                                                                &ErrorType="EMS"
                                                                &ErrorSubType="ERROR"
                                                                &ErrorParameters="''"}
                                END.
                            END.
                        END.
                    END.
                END.
            END.
            /* Esta validaáao deve ser realizada, pois quando o cliente trabalha com multiplanta,  */ 
            /* nao se faz obrigat¢rio o relacionamento do item com o estabelecimento*/
            IF  param-global.modulo-mp = NO THEN DO: /*multiplanta*/

                FOR EACH ordem-compra 
                   WHERE ordem-compra.num-pedido  = pedido-compr.num-pedido NO-LOCK:
                    
                    IF NOT CAN-FIND(FIRST item-uni-estab        
                                    WHERE item-uni-estab.it-codigo   = ordem-compra.it-codigo
                                      AND item-uni-estab.cod-estabel = RowObject.end-entrega) THEN DO:

                        {method/svc/errors/inserr.i
                                   &ErrorNumber="25904"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="ordem-compra.it-codigo + '~~~~' + RowObject.end-entrega"}
                    END.
                END.
            END.
        END.
    END.

    IF pType = "Delete":U THEN DO:
    
        IF isOrderIntegrMe THEN DO:
            {method/svc/errors/inserr.i
                              &ErrorNumber="57881"
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR" 
                              &ErrorParameters="string({&TableName}.num-pedido)"}

            RETURN "NOK":U.
        END.
        
        RUN validateDeleteBusinessLogic.

        IF  pedido-compr.nr-contrato <> 0 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="6113"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
             RETURN "NOK":U.
        END.

        IF CAN-FIND (FIRST ordem-compra WHERE ordem-compra.num-pedido = pedido-compr.num-pedido) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="6764"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
             RETURN "NOK":U.
        END.

        /* Pregao Eletrìnico */
        FIND FIRST param-compra NO-LOCK NO-ERROR.
        IF AVAIL param-compra THEN DO:
            
            IF  param-compra.log-param-pregao-eletron AND RowObject.nr-processo <> 0 THEN DO:

                FIND FIRST proc-compra NO-LOCK
                     WHERE proc-compra.nr-processo = RowObject.nr-processo NO-ERROR.

                IF  AVAIL proc-compra AND proc-compra.log-proces-pregao THEN DO:

                    FIND FIRST usuar-mater NO-LOCK
                         WHERE usuar-mater.cod-usuario = c-seg-usuario NO-ERROR.

                    IF  AVAIL usuar-mater AND usuar-mater.log-usuar-pregao THEN DO:
                        {utp/ut-liter.i "Pedido_de_Compra" *}
                        
                        {method/svc/errors/inserr.i &ErrorNumber="32715"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="WARNING"
                                                    &ErrorParameters=TRIM(RETURN-VALUE)}
                    END.
                    ELSE DO:
                        {utp/ut-liter.i "incluir,_alterar_e_eliminar_pedidos_de_compra_de_processos_de_pregao_eletrìnico" *}
                        
                        {method/svc/errors/inserr.i &ErrorNumber="25729"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="c-seg-usuario + '~~~~' + TRIM(RETURN-VALUE)"}
                        RETURN "NOK":U.
                    END.
                END.
            END.
        END.

        /** Aprovaáao Eletrìnica **/
        IF NOT AVAIL param-compra THEN
           FIND FIRST param-compra NO-LOCK NO-ERROR.
        IF NOT AVAIL param-aprov  THEN
           FIND FIRST param-aprov NO-LOCK NO-ERROR.

        IF  AVAILABLE param-compra AND param-compra.log-1
        AND AVAILABLE param-aprov  AND (param-aprov.aprova-pedido OR param-aprov.aprova-emerg) THEN DO:
            FOR EACH ordem-compra FIELDS(num-pedido) 
               WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-LOCK:

                RUN cdp/cdapi171.p (4, 3, ROWID(ordem-compra)).
            END.
        END.
    END.

    IF pType = "Create":U OR pType = "Update":U THEN DO:
        /* Pregao Eletrìnico */
        IF RowObject.emergencial THEN DO:

            FIND FIRST param-compra NO-LOCK NO-ERROR.
            IF AVAIL param-compra THEN DO:
                
                IF param-compra.log-param-pregao-eletron AND RowObject.nr-processo <> 0 THEN DO:

                    FIND FIRST proc-compra NO-LOCK
                         WHERE proc-compra.nr-processo = RowObject.nr-processo NO-ERROR.

                    IF AVAIL proc-compra AND proc-compra.log-proces-pregao THEN DO:
                        {utp/ut-liter.i "incluir,_alterar_e_eliminar_parcelas_em_ordens_de_compra_de_pregao_eletrìnico" *}
                        
                        {method/svc/errors/inserr.i &ErrorNumber="25729"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="c-seg-usuario + '~~~~' + TRIM(RETURN-VALUE)"}
                        RETURN "NOK":U.
                    END.
                END.
            END.
        END.
    END.
    
    RUN ccp/ccapi035.p (OUTPUT l-ind-drop-shipment).

    IF l-ind-drop-shipment AND RowObject.local-entrega = 1 /* Estabelecimento Entrega */ THEN DO:
        
        /* Quando for parametrizado para buscar o local de entrega do
           estabelecimento de entrega, serao zerados os campos de en-
           dereco de entrega do pedido de compra */
        ASSIGN RowObject.cod-emit-terc = 0
               RowObject.cod-entrega   = "":U
               RowObject.endereco_text = "":U
               RowObject.endereco      = "":U
               RowObject.bairro        = "":U
               RowObject.cidade        = "":U
               RowObject.estado        = "":U
               RowObject.pais          = "":U
               RowObject.cep           = "":U.
    END.
    
    /* VALIDAÄAO DO PROGRAMA CC0300 PARA CONTROLAR SEGURANÄA POR USUµRIO PARA PEDIDO DE COMPRA */
    IF l-seg-cc0300 = YES THEN DO:
        run validateSegCC0300 (INPUT pType,
                               INPUT RowObject.emergencial,
                               INPUT RowObject.situacao).
    END.

    /*--- Verifica ocorrencia de erros ---*/
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
PROCEDURE validateSegcc0300:
/*------------------------------------------------------------------------------
  Purpose: Configura mensagem de erro a ser mostrada para o usuˇrio logado quanto π inseráao,
           alteraáao e remoáao de um pedido de compra caso este nao tenha acesso.
  Parameters:
  Notes: VALIDA∞ÄO PARA SER EXECUTADA DO PROGRAMA CC0300 OU DAS TELAS FILHO
         PARA CONTROLAR SEGURAN∞A POR USUµRIO PARA A∞aES(INSER∞ÄO, ALTERA∞ÄO OU REMO∞ÄO)
         SOB PEDIDO DE COMPRA
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType          AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pl-emergencial AS LOGICAL    NO-UNDO.
    DEFINE INPUT PARAMETER pi-situacao    AS INTEGER    NO-UNDO.

    DEFINE VARIABLE c-param1     AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE c-param2     AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE i-tipo-docum AS INTEGER             NO-UNDO.
    DEFINE VARIABLE i-permissao  AS INTEGER             NO-UNDO.
    DEFINE VARIABLE l-permissao  AS LOGICAL INITIAL YES NO-UNDO.
    

    ASSIGN i-tipo-docum = IF pl-emergencial = NO
                            THEN (IF pi-situacao = 2 THEN 5
                                  ELSE 6)
                            ELSE (IF pi-situacao = 2 THEN 7
                                  ELSE 8)
           i-permissao = IF pType = "Create":U
                           THEN 1
                           ELSE IF pType = "Update":U THEN 2
                                ELSE 3.

    RUN cdp/cdapi181.p (INPUT  c-seg-usuario,
                        INPUT  i-tipo-docum,
                        INPUT  i-permissao,
                        OUTPUT l-permissao).

    IF l-permissao = NO THEN DO:
        IF i-permissao = 1 THEN DO:
            IF i-tipo-docum = 5 OR i-tipo-docum = 6 THEN DO:
                {utp/ut-liter.i Pedidos_Normais mcc R}
                ASSIGN c-param2 = TRIM(RETURN-VALUE).
            END.
            ELSE DO:
                {utp/ut-liter.i Pedidos_Emergenciais mcc R}
                ASSIGN c-param2 = TRIM(RETURN-VALUE).
            END.
            {utp/ut-liter.i incluir mcc R}
            ASSIGN c-param1 = TRIM(RETURN-VALUE).
        END.
        ELSE DO:
            IF i-tipo-docum = 5 THEN DO:
                {utp/ut-liter.i Pedidos_Normais_Nao_Emitidos mcc R}
                ASSIGN c-param2 = TRIM(RETURN-VALUE).
            END.
            ELSE IF i-tipo-docum = 6 THEN DO:
                {utp/ut-liter.i Pedidos_Normais_Emitidos mcc R}
                ASSIGN c-param2 = TRIM(RETURN-VALUE).
            END.
            ELSE IF i-tipo-docum = 7 THEN DO:
                {utp/ut-liter.i Pedidos_Emergenciais_Nao_Emitidos mcc R}
                ASSIGN c-param2 = TRIM(RETURN-VALUE).
            END.
            ELSE IF i-tipo-docum = 8 THEN DO:
                {utp/ut-liter.i Pedidos_Emergenciais_Emitidos mcc R}
                ASSIGN c-param2 = TRIM(RETURN-VALUE).
            END.
            IF i-permissao = 2 THEN DO:
                {utp/ut-liter.i alterar mcc R}
                ASSIGN c-param1 = TRIM(RETURN-VALUE).
            END.
            ELSE DO:
                {utp/ut-liter.i eliminar mcc R}
                ASSIGN c-param1 = TRIM(RETURN-VALUE).
            END.
        END.

        {method/svc/errors/inserr.i &ErrorNumber="18728"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters= "c-param1 + '~~~~'  + c-param2"}
    END.
	
	RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdateBusinessLogicPedEmerg DBOProgram
PROCEDURE validateUpdateBusinessLogicPedEmerg :
/*------------------------------------------------------------------------------
  Purpose:  Validaáoes de neg¢cio para alteraáao
            de registros.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF AVAIL param-global AND param-global.modulo-mp AND pedido-compr.situacao = 1 THEN DO:

        FIND FIRST ordem-compra 
             WHERE ordem-compra.num-pedido       = pedido-compr.num-pedido 
               AND ordem-compra.cod-estab-gestor = pedido-compr.cod-estab-gestor NO-LOCK NO-ERROR.

        IF AVAIL ordem-compra THEN DO:

            RUN ccp/ccapi199.p ("Altera-ordem":U, ROWID(ordem-compra), OUTPUT l-erro-mp).
            IF  l-erro-mp THEN DO:
                {utp/ut-liter.i "Pedido_de_Compra" *}

                {method/svc/errors/inserr.i &ErrorNumber="7193"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
            END.
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdatePedEmerg DBOProgram
PROCEDURE validateUpdatePedEmerg :
/*------------------------------------------------------------------------------
  Purpose: Valida Update
  Parameters: ipar1  : rowid pedido.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prChave         AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER pc-seg-usuario  AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcListaRAltPed  AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE c-mensagem          AS CHARACTER FORMAT "x(200)":U  NO-UNDO.
    DEFINE VARIABLE c-nr-proc-imp       AS CHARACTER FORMAT "x(12)":U   NO-UNDO.
    DEFINE VARIABLE hDBOProcesso-imp    AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE i-cont              AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE l-altera-cond-pagto AS LOGICAL                      NO-UNDO.
    DEFINE VARIABLE c-cod-estabel       LIKE estabelec.cod-estabel      NO-UNDO.

    ASSIGN pcListaRAltPed   = ?.
    ASSIGN c-lista-r-AltPed = ?.

    ASSIGN c-seg-usuario = IF pc-seg-usuario <> "":U THEN
                              pc-seg-usuario
                           ELSE
                               c-seg-usuario.

    FIND FIRST rowObject NO-LOCK NO-ERROR.

    EMPTY TEMP-TABLE RowErrors.
    
    /*--- Verifica se o pedido-compr deve passar por aprovacao eletronica ---*/
    RUN defineAprovEletronicaPedido (OUTPUT l-aprov-eletronica).
    RUN validateRecord (input "Update":U).
    RUN validateFieldsBusinessLogicPedEmerg.

    FIND FIRST {&TableName} 
         WHERE ROWID({&TableName}) = prChave NO-LOCK NO-ERROR.

    /* Pregao Eletrìnico */
    FIND FIRST param-compra NO-LOCK NO-ERROR.
    IF AVAIL param-compra THEN DO:
        
        IF param-compra.log-param-pregao-eletron THEN DO:
            IF RowObject.nr-processo <> {&TableName}.nr-processo THEN DO:

                FIND FIRST proc-compra NO-LOCK
                     WHERE proc-compra.nr-processo = {&TableName}.nr-processo NO-ERROR.

                IF AVAIL proc-compra AND proc-compra.log-proces-pregao THEN DO:
                    {utp/ut-liter.i "alterar_pedidos_de_compra_de_processos_de_pregao_eletrìnico" *}
                    
                    {method/svc/errors/inserr.i &ErrorNumber="25729"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-seg-usuario + '~~~~' + TRIM(RETURN-VALUE)"}
                END.
            END.
            ELSE DO:
                IF RowObject.nr-processo <> 0 THEN DO:

                    FIND FIRST proc-compra NO-LOCK
                         WHERE proc-compra.nr-processo = RowObject.nr-processo NO-ERROR.

                    IF  AVAIL proc-compra AND proc-compra.log-proces-pregao THEN DO:

                        IF {&TableName}.cod-cond-pag <> RowObject.cod-cond-pag 
                        OR {&TableName}.end-entrega  <> RowObject.end-entrega  
                        OR {&TableName}.cod-transp   <> RowObject.cod-transp  THEN DO:

                            FIND FIRST usuar-mater NO-LOCK
                                WHERE usuar-mater.cod-usuario = c-seg-usuario NO-ERROR.

                            IF  AVAIL usuar-mater AND usuar-mater.log-usuar-pregao THEN DO:
                                {utp/ut-liter.i "Pedido_de_Compra" *}
                                
                                {method/svc/errors/inserr.i &ErrorNumber="32715"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="WARNING"
                                                            &ErrorParameters=TRIM(RETURN-VALUE)}
                            END.
                            ELSE DO:
                                {utp/ut-liter.i "alterar_pedidos_de_compra_de_pregao_eletrìnico" *}
                                
                                {method/svc/errors/inserr.i &ErrorNumber="25729"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="ERROR"
                                                            &ErrorParameters="c-seg-usuario + '~~~~' + TRIM(RETURN-VALUE)"}
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.

    RUN validateUpdateBusinessLogicPedEmerg.

    RUN pi-altera-cond-pagto.

    /** Procedure com a l¢gica da modificaáao do cc0304/cc0308 - gera alt-ped **/
    IF pedido-compr.situacao = 1 /* Impresso */
       THEN RUN validateUpdatePedidos. /* aqui era executada a aprovaáao eletrìnica novamente - agora s¢ gera alt-ped */

    /* Se alterar cod-cond-pagto ou responsavel deve consistir novamente a aprovaáao*/
    IF (pedido-compr.cod-cond-pag <> rowObject.cod-cond-pag OR
        pedido-compr.cod-cond-pag = 0 OR
        pedido-compr.data-pedido  <> rowObject.data-pedido OR
        pedido-compr.situacao     <> rowObject.situacao OR
        pedido-compr.cod-emitente <> rowObject.cod-emitente) THEN
        ASSIGN l-altera-investimentos = YES.
    ELSE
        ASSIGN l-altera-investimentos = NO.

    FIND FIRST RowErrors NO-LOCK NO-ERROR.

    IF NOT AVAIL RowErrors THEN DO:

        FIND FIRST {&TableName} 
             WHERE ROWID({&TableName}) = prChave EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

        IF NOT AVAIL {&TableName} THEN DO:
           IF LOCKED {&TableName} THEN DO:
                {utp/ut-liter.i "Pedidos_de_Compra" *}
                
                {method/svc/errors/inserr.i &ErrorNumber="3012"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
           END.
        END.
        ELSE DO:
            FIND FIRST {&TableName} 
                 WHERE ROWID({&TableName}) = prChave EXCLUSIVE-LOCK NO-ERROR.
            
            IF rowObject.cod-cond-pag <> 0 THEN DO:
               FOR EACH cond-especif 
                  WHERE cond-especif.num-pedido = pedido-compr.num-pedido EXCLUSIVE-LOCK:
                   DELETE cond-especif.
               END.
            END.

            ASSIGN l-altera-cond-pagto = pedido-compr.cod-cond-pag <> rowobject.cod-cond-pag.
            RUN updateRecord.
        END.
    END.

    IF CONNECTED("mgcex":U) AND (AVAIL param-global AND param-global.modulo-07) THEN DO:
        
        {utp/ut-field.i movind pedido-compr end-entrega 1}
         ASSIGN c-lb-campo  = RETURN-VALUE.
        {utp/ut-field.i movind pedido-compr num-pedido 1}
         ASSIGN c-lb-tabela = RETURN-VALUE + " ":U.
        {utp/ut-liter.i Processo_Importaáao * R}
         ASSIGN c-lb-relac  = RETURN-VALUE + " ":U.
        {utp/ut-liter.i Estabelecimento * R}
         ASSIGN c-lb-estab  = RETURN-VALUE + " ":U.


        RUN cxbo/bocx140.p PERSISTENT SET hDBOProcesso-imp.
        RUN findPedido IN hDBOProcesso-imp (INPUT pedido-compr.num-pedido, OUTPUT c-return).
        IF  c-return = "":U THEN DO:

            RUN getCharField IN hDBOProcesso-imp (INPUT "cod-estabel":U, OUTPUT c-cod-estabel).
            RUN getCharField IN hDBOProcesso-imp (INPUT "nr-proc-imp":U, OUTPUT c-nr-proc-imp).

            IF c-cod-estabel <> pedido-compr.end-entrega THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="33380"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters= "c-lb-campo  + '~~~~' +
                                                               c-lb-tabela + string(pedido-compr.num-pedido) + '~~~~' +
                                                               c-lb-relac  + c-nr-proc-imp + ', ' +
                                                               c-lb-estab  + c-cod-estabel"}
            END.
        END.
        DELETE PROCEDURE hDBOProcesso-imp.
    END.

    IF l-altera-investimentos THEN
        RUN pi-altera-investimento.

    IF l-aprov-eletronica THEN DO:
        /*--- Retorna o rowid da primeira ordem-compra do pedido ---*/
        RUN returnRowidFirstOCPedido (INPUT  pedido-compr.num-pedido, OUTPUT r-rowid-ordem-compra).

        IF  r-rowid-ordem-compra <> ? THEN DO:
            /*--- Mensagem sobre aprovacao da Ordem de Compra ---*/
            RUN aprovUpdatePedido (INPUT r-rowid-ordem-compra).
        END.
    END.

    ASSIGN pcListaRAltPed = c-lista-r-AltPed.

    FIND FIRST emitente
         WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK NO-ERROR.

    IF l-altera-cond-pagto THEN DO:
        
        IF  param-global.modulo-07 AND emitente.natureza > 2 THEN DO:
            
            RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.
            RUN procuraEmbarqueCompras in h-bocx225 (INPUT pedido-compr.num-pedido,
                                                     INPUT ?,
                                                     INPUT ?,
                                                     OUTPUT TABLE tt-embarque).
            DELETE PROCEDURE h-bocx225.
            FOR EACH tt-embarque NO-LOCK:
                ASSIGN i-cont = i-cont + 1.
                IF i-cont = 1 THEN
                    ASSIGN c-mensagem = tt-embarque.embarque.
                ELSE
                    ASSIGN c-mensagem = c-mensagem + ', ' + tt-embarque.embarque.
            END.
            
            IF i-cont >= 1 THEN DO:
                
                
                {utp/ut-liter.i "Material_em_TrÉnsito" *}
                ASSIGN c-mensagem = c-mensagem + '~~~~' + TRIM(RETURN-VALUE).

                {method/svc/errors/inserr.i &ErrorNumber="28558"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="INFORMATION":U
                                            &ErrorParameters= "c-mensagem"}
            END.
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdatePedidos DBOProgram
PROCEDURE validateUpdatePedidos :
/*------------------------------------------------------------------------------
  Purpose:     l¢gica extra°da do cc0304-v02.w (assign-records)
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF pedido-compr.responsavel <> rowObject.responsavel THEN
    IF NOT CAN-FIND (FIRST usuar-mater 
                     WHERE usuar-mater.cod-usuario = rowObject.responsavel
                       AND usuar-mater.usuar-comprador) THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="17063"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="rowObject.responsavel"}
    END.

    IF NOT CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
        
        {utp/ut-liter.i Alterada_Condiáao_de_Pagamento_do_Pedido mcc R}
        ASSIGN c-literal-obs = RETURN-VALUE.

        /* S¢ gera alt-ped quando o pedido for Impresso */
        IF pedido-compr.cod-cond-pag <> rowObject.cod-cond-pag AND pedido-compr.situacao = 1 THEN DO:

            FOR EACH ordem-compra USE-INDEX pedido 
                WHERE ordem-compra.num-pedido = pedido-compr.num-pedido EXCLUSIVE-LOCK:

                CREATE alt-ped.
                ASSIGN alt-ped.data         = TODAY
                       alt-ped.hora         = STRING(TIME,"HH:MM:SS":U)
                       alt-ped.usuario      = {cdp/cd7777.i}
                       alt-ped.num-pedido   = ordem-compra.num-pedido
                       alt-ped.numero-ordem = ordem-compra.numero-ordem
                       alt-ped.cod-cond-pag = pedido-compr.cod-cond-pag
                       alt-ped.preco        = ?
                       alt-ped.quantidade   = ?
                       alt-ped.data-entrega = ?
                       alt-ped.char-1       = "":U + "|":U + "":U + "|":U + "?":U + "|":U + STRING(rowObject.cod-cond-pag)
                       alt-ped.observacao   = c-literal-obs.

                IF c-lista-r-AltPed <> ? THEN ASSIGN c-lista-r-AltPed = c-lista-r-AltPed + ",":U.
                                         ELSE ASSIGN c-lista-r-AltPed = "":U.

                ASSIGN c-lista-r-AltPed = c-lista-r-AltPed + STRING(ROWID(alt-ped)).
            END.
        END.
    END.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validDesfazRelacOrdemCompraPedido DBOProgram
PROCEDURE validDesfazRelacOrdemCompraPedido :
/*------------------------------------------------------------------------------
  Purpose:     Faz validaáao para desfazer relacionamento da Ordem Compra com
               Pedido.
  Parameters:  ipar1  :  prOrdem  :  rowid ordem compra.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prOrdem  AS ROWID NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR FIRST ordem-compra FIELDS(situacao numero-ordem) 
        WHERE ROWID(ordem-compra) = prOrdem NO-LOCK: END.

    IF AVAIL ordem-compra THEN DO:
        
        FIND FIRST pedido-compr WHERE pedido-compr.num-pedido = RowObject.num-pedido NO-LOCK NO-ERROR.

        IF pedido-compr.nr-contrato <> 0 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="5439"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        END.

        IF ordem-compra.situacao = 6 OR /* Eliminada */
           ordem-compra.situacao = 4 THEN DO: /* Recbida */
            {method/svc/errors/inserr.i &ErrorNumber="7439"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        END.

        IF CAN-FIND(FIRST recebimento 
                    WHERE recebimento.numero-ordem = ordem-compra.numero-ordem) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="16294"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        END.
    END.
    /***********************In°cio chamada EPC Grendene ************************/
    {include/i-epc200.i2 &CodEvent='"validDesfazRelacOrdemCompraPedido"'
                         &CodParameter='"OBJECT-HANDLE"'
                         &ValueParameter="string(this-procedure)"}
    {include/i-epc200.i2 &CodEvent='"validDesfazRelacOrdemCompraPedido"'
                         &CodParameter='"rowid-ordem-compra"'
                         &ValueParameter="string(prOrdem)"}
    {include/i-epc201.i "validDesfazRelacOrdemCompraPedido"}
    /**************************Fim chamada EPC Grendene ************************/


   IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validDesfazRelacOrdemCompraPedidoImportacao DBOProgram
PROCEDURE validDesfazRelacOrdemCompraPedidoImportacao :
/*------------------------------------------------------------------------------
  Purpose:    Verifica se a ordem que esta sendo desvinculada nao Ç a ultima,
              porque nao Ç permitido eliminar a ultima ordem do pedido.
  Parameters:  ipar1  :  prOrdem  :  rowid ordem compra.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prOrdem  AS ROWID       NO-UNDO.
    DEFINE INPUT  PARAMETER cBotao   AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE hDBOProcesso-imp  AS HANDLE     NO-UNDO.
    DEFINE VARIABLE i-num             AS INTEGER    NO-UNDO.
    DEFINE VARIABLE c-return          AS CHARACTER  NO-UNDO.
    
    DEFINE BUFFER b-ordem-compra FOR ordem-compra.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR FIRST emitente FIELDS(cod-emitente natureza) 
        WHERE emitente.cod-emitente = RowObject.cod-emitente NO-LOCK: END.

    FOR FIRST ordem-compra FIELDS(numero-ordem) 
        WHERE ROWID(ordem-compra) = prOrdem NO-LOCK: END.
    
    IF AVAIL ordem-compra THEN DO:
        IF param-global.modulo-07 THEN DO:
            
            IF AVAIL emitente AND (emitente.natureza = 3 OR emitente.natureza = 4) THEN DO:  /* 3 - Estrangeiro, 4 - Traiding */

                ASSIGN i-num = 0.
                /******* verifica se existe mais que uma ordem para o pedido *******/
                IF cBotao = "one":U THEN DO:

                    FOR EACH b-ordem-compra 
                       WHERE b-ordem-compra.num-pedido = ordem-compra.num-pedido 
                         AND b-ordem-compra.situacao   <> 4 NO-LOCK:
                        
                        ASSIGN i-num = i-num + 1.
                        
                        IF i-num > 1 THEN
                            LEAVE.
                    END.

                    IF i-num < 2 THEN DO:

                        RUN cxbo/bocx140na.p PERSISTENT SET hDBOProcesso-imp.
                        RUN openQueryStatic IN hDBOProcesso-imp (INPUT "Main":U).
                        RUN goToPedido in hDBOProcesso-imp (INPUT ordem-compra.num-pedido).
                        DELETE PROCEDURE hDBOProcesso-imp.

                        IF RETURN-VALUE = "OK":U OR RETURN-VALUE = "":U THEN DO:
                            
                            {utp/ut-table.i movind pedido-compr 1}
                            ASSIGN c-return = TRIM(RETURN-VALUE).
                            {utp/ut-liter.i "Processo_Importaáao" *}
                            
                            {method/svc/errors/inserr.i &ErrorNumber="5"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U
                                                        &ErrorParameters="c-return + '~~~~' + ' ' + TRIM(RETURN-VALUE) + ' '"}

                            RETURN "NOK":U.
                        END.
                        ELSE 
                            RETURN "OK":U.
                    END.
                END.
                ELSE
                    IF cBotao = "all":U THEN DO:

                        RUN cxbo/bocx140na.p PERSISTENT SET hDBOProcesso-imp.
                        RUN openQueryStatic IN hDBOProcesso-imp (INPUT "Main":U).
                        RUN goToPedido IN hDBOProcesso-imp (INPUT ordem-compra.num-pedido).
                        DELETE PROCEDURE hDBOProcesso-imp.

                        IF RETURN-VALUE = "OK":U OR RETURN-VALUE = "":U THEN DO:
                            
                            {utp/ut-table.i movind pedido-compr 1}
                            ASSIGN c-return = TRIM(RETURN-VALUE).
                            {utp/ut-liter.i "Processo_Importaáao" *}
                            
                            {method/svc/errors/inserr.i &ErrorNumber="5"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U
                                                        &ErrorParameters="c-return + '~~~~' + ' ' + TRIM(RETURN-VALUE) + ' '"}

                            RETURN "NOK":U.
                            
                        END.
                        ELSE
                            RETURN "OK":U.
                    END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaBeforeUpdatePedidoCompr DBOProgram
PROCEDURE verificaBeforeUpdatePedidoCompr :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER rpPedido AS ROWID NO-UNDO.

    FIND FIRST {&TableName} WHERE ROWID({&TableName}) = rpPedido NO-LOCK NO-ERROR.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF AVAIL {&TableName} AND AVAIL param-global THEN DO:

        IF {&TableName}.situacao <> 1 AND {&TableName}.situacao <> 2 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="1805"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U} /* pedido eliminado */
        END.
        ELSE
            IF param-global.modulo-mp = YES AND
               (ordem-compra.num-pedido = 0 OR
                CAN-FIND(FIRST pedido-compr 
                         WHERE pedido-compr.num-pedido = ordem-compra.num-pedido 
                           AND pedido-compr.situacao = 1) ) THEN DO:

                /* Multiplanta: Verifica se pedido j† est† na central. */
                FOR FIRST ordem-compra FIELDS(num-pedido int-1 cod-estab-gestor) 
                    WHERE ordem-compra.num-pedido       = {&TableName}.num-pedido 
                      AND ordem-compra.cod-estab-gestor = {&TableName}.cod-estab-gestor NO-LOCK: END.

                IF AVAIL ordem-compra THEN DO:

                    RUN ccp/ccapi199.p ("Altera-ordem":U, ROWID(ordem-compra), OUTPUT l-erro-mp).

                    IF l-erro-mp THEN DO:
                        {utp/ut-liter.i "Pedido_de_Compra" *}
                        
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="7193"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
                    END.
                END.
            END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaCondicaoEspecifica DBOProgram
PROCEDURE verificaCondicaoEspecifica :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se existe Condiáao Espec°fica para o Pedido Informado. Caso
               nao exista, inclui erro na RowErrors.
  Parameters:  ipar1: pPedido  : N£mero Pedido.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPedido AS INTEGER NO-UNDO.

    IF NOT CAN-FIND(FIRST cond-especif 
                    WHERE  cond-especif.num-pedido = pPedido) THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="1743"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaPedidoDuplicado DBOProgram
PROCEDURE verificaPedidoDuplicado :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piNumPedido    AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER piNumNewPedido AS INTEGER NO-UNDO.

    IF CAN-FIND(pedido-compr WHERE pedido-compr.num-pedido = piNumPedido) THEN DO:

        RUN geraNumeroPedidoCompra (OUTPUT piNumNewPedido).

        {method/svc/errors/inserr.i
                             &ErrorNumber="19158"
                             &ErrorType="EMS":U
                             &ErrorSubType="INFORMATION":U
                             &ErrorParameters="trim(string(piNumPedido)) + '~~~~' + string(piNumNewPedido)"}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaPedidoImpriEliminCentral DBOProgram
PROCEDURE verificaPedidoImpriEliminCentral :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se pedido j† foi impresso, eliminado ou est† na central. Se
               uma destas condiáoes for verdadeira, inclui erro na RowErrors.
  Parameters:  ipar1: prPedidoCompr  : Rowid Pedido Compra.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prPedidoCompr AS ROWID NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND FIRST {&TableName} WHERE ROWID({&TableName}) = prPedidoCompr NO-LOCK NO-ERROR.

    IF AVAIL {&TableName} THEN DO:

        IF {&TableName}.situacao <> 2 THEN DO:

            IF {&TableName}.situacao = 1 THEN DO:
                {method/svc/errors/inserr.i
                                     &ErrorNumber="1804"
                                     &ErrorType="EMS":U
                                     &ErrorSubType="ERROR":U} /* pedido ja impresso */
            END.
            ELSE DO:
                {method/svc/errors/inserr.i
                                     &ErrorNumber="1805"
                                     &ErrorType="EMS":U
                                     &ErrorSubType="ERROR":U} /* pedido eliminado */
            END.
        END.
        ELSE
            IF  param-global.modulo-mp = YES AND
                (ordem-compra.num-pedido = 0 OR
                CAN-FIND(FIRST pedido-compr 
                         WHERE pedido-compr.num-pedido = ordem-compra.num-pedido 
                           AND pedido-compr.situacao = 1) ) THEN DO:
                /* Multiplanta: Verifica se pedido j† est† na central. */
                FOR FIRST ordem-compra FIELDS(num-pedido int-1 cod-estab-gestor) 
                    WHERE ordem-compra.num-pedido       = {&TableName}.num-pedido 
                      AND ordem-compra.cod-estab-gestor = {&TableName}.cod-estab-gestor NO-LOCK: END.
    
                IF AVAIL ordem-compra THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="7193"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="'{&TableName}'":U}
                END.
            END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaRelacionamentoContrato DBOProgram
PROCEDURE verificaRelacionamentoContrato :
/*------------------------------------------------------------------------------
  Purpose: Verifica se o registro corrente da tabela pedido-compr possui relacionamento
  com a tabela contrato-for.
  Parameters:  ipar1  : r-chave    :recebe rowid do registro corrente.
               opar2  : rowerrors  :retorna temp-table de erros.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER r-chave AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF CAN-FIND (FIRST pedido-compr 
                 WHERE ROWID(pedido-compr) = r-chave and pedido-compr.nr-contrato > 0) THEN DO:
        
        {method/svc/errors/inserr.i &ErrorNumber="1806"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U}
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaAtivacaoPedidoCompra DBOProgram
PROCEDURE validaAtivacaoPedidoCompra :
/*------------------------------------------------------------------------------
  Purpose:     Valida a ativacao dos campos na manutencao
               de pedidos emergenciais (wcc0310a).

  Parameters:  ipar1 : c-mod-exec    : Add ou Cop ou mod
               opar1 : plNrProcesso  : Ativa processo na tela?
               opar2 : plResponsavel : Ativa responsavel na tela?
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-mod-exec    AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER plNrProcesso  AS LOGICAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER plResponsavel AS LOGICAL    NO-UNDO.

    IF  c-mod-exec = "add":U    
    OR  c-mod-exec = "update":U 
    OR  c-mod-exec = "copy":U   THEN DO:
        
        FOR FIRST param-compra FIELDS(usa-proc) NO-LOCK: END.

        IF AVAIL param-compra THEN DO:
            ASSIGN plNrProcesso = param-compra.usa-proc.
        END.
        ELSE DO:
            ASSIGN plNrProcesso = NO.
            RETURN "NOK":U.
        END.
    END.
    ELSE
        ASSIGN plNrProcesso = NO.

    ASSIGN plResponsavel = YES.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificCentralPedidoCompra DBOProgram
PROCEDURE verificCentralPedidoCompra :
/*------------------------------------------------------------------------------
  Purpose:
    Verifica se o pedido j† est† na central.
  Parameters:
    ipar1 : p-rowid-pedido : rowid do pedido
    opar2 : c-situacao-pai : retorna a situacao do pedido
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-rowid-pedido AS ROWID      NO-UNDO.
    DEFINE OUTPUT PARAMETER c-situacao-pai AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE l-proces-pregao AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-usuar-pregao  AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE c-lbl-liter     AS CHARACTER NO-UNDO.

    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR FIRST pedido-compr FIELDS(num-pedido situacao nr-contrato) 
        WHERE ROWID(pedido-compr) = p-rowid-pedido NO-LOCK: END.

    /** ---------------------------------------------------------------**/
    IF AVAIL pedido-compr THEN    /* essa l¢gica Ç usada na deleáao do pai => pedido-compra */
        ASSIGN c-situacao-pai = STRING(pedido-compr.situacao).

    IF pedido-compr.nr-contrato <> 0 THEN DO:
       {method/svc/errors/inserr.i &ErrorNumber="1806"
                                   &ErrorType="EMS":U
                                   &ErrorSubType="ERROR":U}
    END.

    IF param-global.modulo-mp THEN DO:

        FOR FIRST ordem-compra FIELDS(num-pedido it-codigo num-seq-item) 
            WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-LOCK: END.

        IF NOT AVAIL param-compra THEN
            FIND FIRST param-compra NO-LOCK NO-ERROR.

        IF NOT AVAIL param-compra THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="2587"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        END.

        if  c-situacao-pai = "1":U /* Impresso */  THEN DO:

            RUN ccp/ccapi199.p(INPUT "altera-ordem":U, INPUT ROWID(ordem-compra), OUTPUT l-erro-mp).

            IF l-erro-mp THEN DO:
                {utp/ut-liter.i "Pedido_de_Compra" *}
                
                {method/svc/errors/inserr.i &ErrorNumber="7193"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters=TRIM(RETURN-VALUE)}
            END.
        END.

        /** ---------------------------------------------------------------
        ** Se a Ordem estiver associada a um contrato, o pedido tambÇm est†. **
        ** Logo, a mensagem de erro abaixo j† Ç suficiente para tratar isso  **
        ---------------------------------------------------------------**/
    END.

    
    FOR EACH ordem-compra WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-LOCK:

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
                ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                {utp/ut-liter.i "eliminar_este_registro" *}
                 
                {method/svc/errors/inserr.i &ErrorNumber="33085"
                                   &ErrorType="EMS":U
                                   &ErrorSubType="Error":U
                                   &ErrorParameters="c-seg-usuario + '~~~~' + c-lbl-liter + '~~~~' + TRIM(RETURN-VALUE)"}
                LEAVE.
            END.
        END.
    END.
    

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEmitenteImport DBOProgram
PROCEDURE ValidaPedidoImport :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-num-pedido    AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    DEFINE VARIABLE c-retorno1 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-retorno2 AS CHARACTER  NO-UNDO.

    FIND FIRST pedido-compr
         WHERE pedido-compr.num-pedido = p-num-pedido NO-LOCK NO-ERROR.

    IF AVAIL pedido-compr THEN DO:

        FIND FIRST emitente
             WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK NO-ERROR.

        IF  AVAIL emitente AND emitente.natureza < 3 THEN DO:

            {utp/ut-liter.i Pedido * R}
            ASSIGN c-retorno1  = RETURN-VALUE.

           {utp/ut-liter.i Importaáao * R}
           ASSIGN c-retorno2 = RETURN-VALUE.

           ASSIGN i-seq-erro = i-seq-erro + 1.
           RUN utp/ut-msgs.p (INPUT "msg":U,
                              INPUT 17167,
                              INPUT c-retorno1 + "~~":U + c-retorno2).
           CREATE tt-bo-erro.
           ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                  tt-bo-erro.cd-erro  = 17167
                  tt-bo-erro.mensagem = RETURN-VALUE.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiRetornaRowid DBOProgram
PROCEDURE PiRetornaRowid :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT   PARAMETER p-num-pedido    AS INTEGER NO-UNDO.
    DEFINE OUTPUT  PARAMETER pr-pedido-compr AS ROWID   NO-UNDO.

    FIND FIRST pedido-compr
         WHERE pedido-compr.num-pedido = p-num-pedido NO-LOCK NO-ERROR.

    IF AVAIL pedido-compr THEN
        ASSIGN pr-pedido-compr = ROWID(pedido-compr).
    ELSE
        ASSIGN pr-pedido-compr = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiRetornaRowidByCotacao DBOProgram
PROCEDURE PiRetornaRowidByCotacao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT   PARAMETER p-num-ordem     LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT  PARAMETER pr-pedido-compr AS   ROWID                     NO-UNDO.

    FIND FIRST ordem-compra
         WHERE ordem-compra.numero-ordem = p-num-ordem NO-LOCK NO-ERROR.

    IF AVAIL ordem-compra  THEN DO:

        FIND FIRST pedido-compr
             WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.

        IF AVAIL pedido-compr THEN
            ASSIGN pr-pedido-compr = ROWID(pedido-compr).
        ELSE
            ASSIGN pr-pedido-compr = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaPedidoCompra DBOProgram
PROCEDURE piEliminaPedidoCompra :
/*------------------------------------------------------------------------------
  Purpose:    Eliminar pedido de compra e seus relacionamentos
  Parameters: pNumPedido - N£mero do pedido de compra a ser eliminado.
              RowErrors  - Temp-table de erros retornada do mÇtodo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNumPedido LIKE pedido-compr.num-pedido NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE h-bocx140na       AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h-boin274vl       AS HANDLE     NO-UNDO.
    DEFINE VARIABLE c-situacao-pedido AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE i-nivel           AS INTEGER    NO-UNDO.
    DEFINE VARIABLE l-exec-integracao AS LOGICAL    NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.

    RUN openQueryStatic ("Main":U).
    RUN inbo/boin274vl.p PERSISTENT SET h-boin274vl.
    RUN openQueryStatic IN h-boin274vl ("Main":U).

    /*-- Posiciona o pedido selecionado na BO --*/
    RUN goToKey (INPUT pNumPedido).
    IF RETURN-VALUE = "OK":U THEN DO:
        
        /* Integraáao M¢dulo de Importaáao - Validaáao relacionamentos p/ Eliminaáao */
        FIND FIRST param-global NO-LOCK NO-ERROR.

        IF AVAIL param-global AND param-global.modulo-07 THEN DO:

            FOR FIRST emitente FIELDS (cod-emitente natureza)
                WHERE emitente.cod-emitente = rowObject.cod-emitente NO-LOCK: END.

            IF AVAIL emitente AND emitente.natureza = 3 OR emitente.natureza = 4 THEN DO: /* 3 - Estrangeiro, 4 - Trading */
                
                RUN cxbo/bocx140na.p PERSISTENT SET h-bocx140na.
                RUN openQueryStatic IN h-bocx140na (INPUT "Main":U).

                RUN goToPedido IN h-bocx140na (INPUT rowObject.num-pedido).
                DELETE PROCEDURE h-bocx140na.
                ASSIGN h-bocx140na = ?.

                IF RETURN-VALUE = "OK":U OR RETURN-VALUE = "":U THEN DO:

                    {utp/ut-table.i movind pedido-compr 1}
                    assign c-return = trim(return-value).
                    {utp/ut-table.i mgcex processo-imp 1}

                    run utp/ut-msgs.p (input "msg":U,
                                       input 5,
                                       input c-return + "~~":U + trim(return-value)).

                    create RowErrors.
                    assign RowErrors.errornumber       = 5
                           RowErrors.ErrorDescription  = return-value
                           RowErrors.ErrorHelp         = return-value
                           rowErrors.ErrorType         = "EMS":U
                           rowErrors.ErrorSubType      = "ERROR":U.

                    RETURN "NOK":U.
                END.
            END.
        END.

        /*--- Limpa a temp-table de erros ---*/
        RUN emptyRowErrors.

        /*-- Pedidos com contrato nao podem ser alterados/eliminados --*/
        RUN verificaRelacionamentoContrato(INPUT rowObject.r-rowid, OUTPUT TABLE rowErrors).

        /*--- Valida Ordem ---*/
        RUN emptyRowErrors IN h-boin274vl.
        RUN validateSegcc0300 IN h-boin274vl (INPUT 3, INPUT rowObject.num-pedido).
        RUN validaEliminacaoPedidoCompra IN h-boin274vl (INPUT rowObject.r-rowid).

        RUN getRowErrors in h-boin274vl (OUTPUT TABLE RowErrors APPEND).

		DELETE PROCEDURE h-boin274vl.
		ASSIGN h-boin274vl = ?.

        /*Eliminaáao dos erros internos disparados quando Ç eliminado o £ltimo registro da base:
                10 - Query est† posicionada no £ltimo registro
                 8 - Query est† vazia
                 3 - Tabela nao dispon°vel*/
        FOR EACH RowErrors
           WHERE RowErrors.errorType   = "INTERNAL":U
             AND (RowErrors.errorNumber = 3 OR
                  RowErrors.errorNumber = 8 OR
                  RowErrors.errorNumber = 10):
            DELETE RowErrors.
        END.

        /*-- Retorna os erros encontrados e desfaz a transacao --*/
        IF CAN-FIND (FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.

        /*--- Verifica se o mÇtodo est† sendo executado pelo programa de integraáao*/
        REPEAT WHILE PROGRAM-NAME(i-nivel) <> ?:
           IF PROGRAM-NAME(i-nivel) MATCHES "*axrsu004*":U THEN
               ASSIGN l-exec-integracao = YES.
        END.

        /*--- Seguranáa de Usu†rio ---*/
        /*Valida seguranáa usu†rio apenas se nao for integraáao*/
        IF NOT l-exec-integracao THEN
            RUN validateSegcc0300 (INPUT "Delete":U,
                                   INPUT rowObject.emergencial,
                                   INPUT rowObject.situacao).

        IF CAN-FIND (FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.
        
        FIND FIRST param-compra NO-LOCK NO-ERROR.

        IF CAN-FIND (FIRST funcao WHERE funcao.cd-funcao = "SPP-INTEGRA-PORTAL-COMPRA":U AND funcao.ativo) AND
           &IF  "{&bf_mat_versao_ems}":U  <  "2.09":U  &THEN
             (AVAIL param-compra AND substring(param-compra.char-2,102,1) = "S":U)
           &ELSE
             (AVAIL param-compra AND param-compra.log-integr-portal)
           &ENDIF   THEN DO:

            &IF  "{&bf_mat_versao_ems}":U  <  "2.09":U  &THEN
               IF (substring(rowObject.char-1,2,1) = "S":U) THEN DO:
            &ELSE
               IF (rowObject.log-integr-portal) THEN DO:
            &ENDIF

                  {utp/ut-liter.i Pedido_de_Compra *}

                  RUN utp/ut-msgs.p (INPUT "msg":U,
                                     INPUT 36712,
                                     INPUT RETURN-VALUE).

                  CREATE RowErrors.
                  ASSIGN RowErrors.errornumber       = 36712
                         RowErrors.ErrorDescription  = RETURN-VALUE
                         RowErrors.ErrorHelp         = RETURN-VALUE
                         rowErrors.ErrorType         = "EMS":U
                         rowErrors.ErrorSubType      = "ERROR":U.

                  RETURN "NOK":U.
               END.
        END.

        IF  rowObject.situacao = 1 /* Impresso */
        OR  rowObject.situacao = 2 /* Nao Impresso */ THEN DO:
            
            RUN aprovEletronicaDeletePedido (INPUT rowObject.num-pedido).

            IF rowObject.situacao = 1 THEN DO: /*--- Impresso ---*/

                IF cComments = "":U THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="1213"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U}
                    RETURN "NOK":U.
                END.

                RUN eliminaPedidoCompra (INPUT rowObject.r-rowid,
                                         INPUT "":U, /* usu†rio do sistema */
                                         INPUT cComments).

                FIND FIRST emitente WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK NO-ERROR.

                
                FIND FIRST dist-emitente WHERE dist-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
                IF AVAIL dist-emitente AND dist-emitente.parceiro-b2b THEN DO:
                    RUN adapters/neogrid/ccp/anecc007.p (INPUT rowObject.r-rowid).
                END.
            END.
            ELSE DO: /*--- Nao Impresso ---*/

                /*--- Elimina as pendencias do pedido (situaáao = Nao Impresso) ---*/
                RUN repositionRecord (INPUT rowObject.r-rowid).
                RUN deleteRecord.

                /*Eliminaáao dos erros internos disparados quando Ç eliminado o £ltimo registro da base:
                    10 - Query est† posicionada no £ltimo registro
                     8 - Query est† vazia
                     3 - Tabela nao dispon°vel*/
                FOR EACH RowErrors
                   WHERE RowErrors.errorType   = "INTERNAL":U
                     AND (RowErrors.errorNumber = 3 OR
                          RowErrors.errorNumber = 8 OR
                          RowErrors.errorNumber = 10):
                    DELETE RowErrors.
                END.
                IF CAN-FIND (FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
                    RETURN "NOK":U.
            END.
        END.
        ELSE DO: /*--- Situaáao do pedido = eliminado ---*/
            
            RUN utp/ut-msgs.p  ("msg":U,6003,"":U). /*--- Opáao Inv†lida ---*/
            
            CREATE RowErrors.
            ASSIGN RowErrors.errornumber       = 6003
                   RowErrors.ErrorDescription  = RETURN-VALUE
                   RowErrors.ErrorHelp         = RETURN-VALUE
                   rowErrors.ErrorType         = "EMS":U
                   rowErrors.ErrorSubType      = "ERROR":U.

            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setComments DBOProgram
PROCEDURE setComments :
/*------------------------------------------------------------------------------
  Purpose:     sera utilizado na alteracao dos pedidos impressos
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcComments AS CHARACTER NO-UNDO.

    ASSIGN cComments = pcComments.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaProcessoCompletoMLA DBOProgram 
PROCEDURE piVerificaProcessoCompletoMLA :
/*------------------------------------------------------------------------------
  Purpose:    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    FIND FIRST bf-pedido-compr
         WHERE bf-pedido-compr.num-pedido = p-num-pedido EXCLUSIVE-LOCK NO-ERROR.

    IF  AVAIL bf-pedido-compr THEN
        ASSIGN l-processo-completo = IF trim(substring(bf-pedido-compr.char-1,58,1)) = "S":U THEN YES ELSE NO.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaProcessoCompletoMLA DBOProgram 
PROCEDURE piRetornaProcessoCompletoMLA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pl-processo-completo AS LOGICAL NO-UNDO.

    ASSIGN pl-processo-completo = l-processo-completo.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionQueries DBOProgram 
PROCEDURE repositionQueries /*{&REPOSITION-PROCEDURE}*/:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-row-table AS ROWID           NO-UNDO.    
    DEFINE OUTPUT PARAMETER rowid-array AS ROWID EXTENT 18 NO-UNDO.

    DEFINE VARIABLE oldRowid AS ROWID NO-UNDO.

    IF AVAIL({&MY-TABLE}) THEN 
        ASSIGN oldRowid = ROWID({&MY-TABLE}).
    ELSE 
        ASSIGN oldRowid = ?.
    
    &IF DEFINED(REPOSITION-PROCEDURE-KEY-PHRASE) > 0 &THEN
                                  
        FOR FIRST {&MY-TABLE} 
             WHERE ROWID({&MY-TABLE}) = p-row-table
             AND {&REPOSITION-PROCEDURE-KEY-PHRASE}:            
        END.
    &ELSE
        FIND FIRST {&MY-TABLE} NO-LOCK 
             WHERE ROWID({&MY-TABLE}) = p-row-table NO-ERROR.
    
    &ENDIF


    IF l-estab-security-active THEN DO:
        FIND FIRST {&ESTAB-SEC-TT} NO-LOCK 
             WHERE {&ESTAB-SEC-TT-FIELD} = {&MY-TABLE}.{&SEGUR-ESTAB-ATRIBUTE} NO-ERROR.
    END.
    ELSE DO:
        FIND FIRST {&ESTAB-SEC-TT} NO-LOCK NO-ERROR.             
    END.
	
    IF AVAIL {&ESTAB-SEC-TT} AND avail {&MY-TABLE} /*aqui*/ THEN DO:
        &IF "{&ems_dbtype}":U = "mss":U &THEN
           ASSIGN rowid-array[1] = p-row-table
                  rowid-array[2] = ROWID({&ESTAB-SEC-TT}).    
        &ELSE
           ASSIGN rowid-array[1] = ROWID({&ESTAB-SEC-TT})
                  rowid-array[2] = p-row-table.    
        &ENDIF
        RETURN "OK":U.
    END.
    ELSE DO:
        &IF {&SEGUR-ESTAB-NOTFIND-MES} = TRUE &THEN
        
            RUN utp/ut-msgs.p (input "show":U,
                               input 2,
                               input "{&MY-TABLE}":U). 
        &ENDIF
        /*inicio logica para retornar ao registro anterior*/
        IF oldRowid <> ? THEN DO:

            &IF DEFINED(REPOSITION-PROCEDURE-KEY-PHRASE) > 0 &THEN                                          
                FOR FIRST {&MY-TABLE} 
                     WHERE ROWID({&MY-TABLE}) = oldRowid
                     AND {&REPOSITION-PROCEDURE-KEY-PHRASE}:                    
                END.
            &ELSE
                FIND FIRST {&MY-TABLE} NO-LOCK 
                     WHERE ROWID({&MY-TABLE}) = oldRowid NO-ERROR.
            
            &ENDIF


            IF l-estab-security-active THEN DO:
                FIND FIRST {&ESTAB-SEC-TT} NO-LOCK 
                     WHERE {&ESTAB-SEC-TT-FIELD} = {&MY-TABLE}.{&SEGUR-ESTAB-ATRIBUTE} NO-ERROR.
            END.
            ELSE DO:
                FIND FIRST {&ESTAB-SEC-TT} NO-LOCK NO-ERROR.             
            END.
        END.
        /*fim logica para retornar ao registro anterior*/
        IF AVAIL {&ESTAB-SEC-TT} THEN DO:
            &IF "{&ems_dbtype}":U = "mss":U &THEN
               ASSIGN rowid-array[1] = oldRowid
                      rowid-array[2] = ROWID({&ESTAB-SEC-TT}).    
            &ELSE
               ASSIGN rowid-array[1] = ROWID({&ESTAB-SEC-TT})
                      rowid-array[2] = oldRowid.    
            &ENDIF
            RETURN "OK":U.
        END.
        ELSE DO:        
            ASSIGN ERROR-STATUS:ERROR = NO. /*CORRIGE O ERRO DE STATUS PARA NÄO APRESENTAR A MSG 16690*/
            ASSIGN 
                rowid-array[1] = ?    
                rowid-array[2] = ?
                rowid-array[3] = ?
                rowid-array[4] = ?    
                rowid-array[5] = ?
                rowid-array[6] = ?.
            /*RETURN "ADM-ERROR".*/
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


{cdp/cdapi171.i3} /* PROCEDURE pi-verifica-importacao, PROCEDURE pi-desp-importacao */
