&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram
/*******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
******************************************************************************/
{include/i-prgvrs.i BOIN082VL 2.00.01.064 } /*** "010164" 04/09/2026 16:37:18 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin082vl MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : BOIN082VL.P
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      : BO com procedures que fazem algum tipo de valida‡Æo.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName cotacao-item
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName cotacao-item
&GLOBAL-DEFINE TableLabel cotacao-item
&GLOBAL-DEFINE QueryName qr{&TableName}
/*&GLOBAL-DEFINE ProxyNotIncluded YES */

/*********************************************************************************
**  S¢ a DBO principal (boin082.p) estÿ com as fun‡„es de inclui (createRecord),
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas,
**  porque S… nela foram implementadas as triggers do dicionÿrio.
**  Para desabilitar as procedures foram usados os pr‚-processadores abaixo.
**  A procedure validateRecord dessa DBO nÆo deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{include/i_dbvers.i} /* Include de versÒo de banco de dados  */

/* Local Global Shared Variables Definitions ---                                            */
DEFINE NEW GLOBAL SHARED VARIABLE gl-proxima-aprovacao  AS LOGICAL                      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gi-proxima-prioridade AS INTEGER                      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario         AS CHARACTER FORMAT "x(12)":U   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gl-bt-despesas-cc0300 AS LOGICAL                      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gr-ordem-compra       AS ROWID                        NO-UNDO.

{ccp/cc9999.i} /* lg-naocon, lg-cotada, lg-confir, lg-elimin, lg-em-cotacao, lg-termin, i-moeda-g, l-conv-g, da-conv-g */

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
{method/dboqry.i}

/* Local Temp-Table's Definitions ---                                            */
{cdp/cd0669.i}                          /*--- tt-erro, l-multi, l-del-erros, v-nom-arquivo-cb, c-mensagem-cb ---*/
{imp/imapi006.i}                        /*--- tt-desp-ja-recalc, tt-desp-vinc                                ---*/
{include/boerrtab.i}                    /*--- tt-bo-erro                                                     ---*/
{inbo/boin082.i rowObject}              /*--- Include com defini‡Æo da temptable rowObject                   ---*/
{inbo/boin081.i ttCotaItemReaj}
{cxbo/bocx085.i tt-cotacao-item-cex}
{inbo/boin082.i tt-cotacao-item-imp}
{inbo/boin082.i tt-cotacao-item-aux}
{inbo/boin082.i tt-cotacao-item-aux1}
{inbo/boin082.i tt-cotacao-item-aux2}
{web/ccp/wcc0322.i tt-cotacao-item-edit}

DEFINE TEMP-TABLE tt-embarque NO-UNDO
    FIELD embarque AS CHAR FORMAT "x(16)":U.

{include/i-epc200.i boin082vl} /* tt-epc, c-nom-prog-upc-mg97, raw-rowObject */

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER b-ord          FOR ordem-compra.
DEFINE BUFFER b-cot-item     FOR {&TableName}.
DEFINE BUFFER b-cotacao-item FOR {&TableName}.
DEFINE BUFFER b-cotacao      FOR {&TableName}.
DEFINE BUFFER b-cot-reaj     FOR cota-item-reaj.
DEFINE BUFFER b-ordem-compra FOR ordem-compra.
DEFINE BUFFER b-prazo-compra FOR prazo-compra.

/* Local Variables Definitions ---                                            */
DEFINE VARIABLE c-msg                   AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE gc-motivo-apr           AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cTipoMoeda              AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cMoedaLim               AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cFormato                AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cTransacao              AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cAprovador              AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cComprador              AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cItCodigo               AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cMotivoApr              AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cIsento                 AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-return                AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-cod-estabel           AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-estabelecimento       AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-usuar-trans           AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-un-ant                AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-un                    AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE da-atualiza             AS DATE                         NO-UNDO.
DEFINE VARIABLE da-aux                  AS DATE                         NO-UNDO.
DEFINE VARIABLE daReajAux               AS DATE      EXTENT 5           NO-UNDO.
DEFINE VARIABLE daDataIndice            AS DATE      EXTENT 5           NO-UNDO.
DEFINE VARIABLE de-valor-doc            AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-valor-lim            AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE deIndice                AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE deTotPerc               AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE dePrecoUnitAnt          AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE deCotacaoMoeda          AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE deConver                AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE deQtdForn               AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE dePerc                  AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE deperReaj               AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE deValorDoc              AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE deValorLim              AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-preco                AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE dePercAux               AS DECIMAL   EXTENT 5           NO-UNDO.
DEFINE VARIABLE dePercReaj              AS DECIMAL   EXTENT 5           NO-UNDO.
DEFINE VARIABLE de-indice               AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-valor-item           AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-valor-total          AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-cotacao-moeda        AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE h-boin082               AS HANDLE                       NO-UNDO.
DEFINE VARIABLE hBoin082ca              AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-boin681               AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-boin274               AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-bosc019               AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-bosc014               AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-boin274vl             AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-boiv011               AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-bocx225               AS HANDLE                       NO-UNDO.
DEFINE VARIABLE i-tipo-movto            AS INTEGER                      NO-UNDO.
DEFINE VARIABLE i-atualiza              AS INTEGER                      NO-UNDO.
DEFINE VARIABLE gi-atualiza-data        AS INTEGER                      NO-UNDO.
DEFINE VARIABLE i-dias-atualiza         AS INTEGER                      NO-UNDO.
DEFINE VARIABLE i-alt-data              AS INTEGER                      NO-UNDO.
DEFINE VARIABLE i-moeda-lim             AS INTEGER                      NO-UNDO.
DEFINE VARIABLE i-tipo-moeda            AS INTEGER                      NO-UNDO.
DEFINE VARIABLE iCodigo                 AS INTEGER   EXTENT 5           NO-UNDO.
DEFINE VARIABLE iMoAux2                 AS INTEGER   EXTENT 5           NO-UNDO.
DEFINE VARIABLE iMoeda                  AS INTEGER                      NO-UNDO.
DEFINE VARIABLE iPrecoBruto             AS INTEGER                      NO-UNDO.
DEFINE VARIABLE iCont                   AS INTEGER                      NO-UNDO.
DEFINE VARIABLE iContAux                AS INTEGER                      NO-UNDO.
DEFINE VARIABLE iTentativas             AS INTEGER                      NO-UNDO.
DEFINE VARIABLE iMoAux                  AS INTEGER   EXTENT 5           NO-UNDO.
DEFINE VARIABLE iMoedaLim               AS INTEGER                      NO-UNDO.
DEFINE VARIABLE iTipoMoeda              AS INTEGER                      NO-UNDO.
DEFINE VARIABLE i-tp-doc                AS INTEGER                      NO-UNDO.
DEFINE VARIABLE iNumOrdem               AS INTEGER   INITIAL 0          NO-UNDO.
DEFINE VARIABLE l-cria                  AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-erro                  AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-preco-bruto           AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-pendente              AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-mapa                  AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-erro-item-um-duplic   AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE lPendente               AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE lGeraPendencia          AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE lRetornoAprov           AS LOGICAL   INITIAL YES        NO-UNDO.
DEFINE VARIABLE lErro                   AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE lAprovada               AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE lInvest                 AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE lHabilita               AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE lPossuiReaj             AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE lRetorno                AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-create-cotac          AS LOGICAL   INITIAL YES        NO-UNDO.
DEFINE VARIABLE l-log-frete             AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-sugeriu-fator-conver  AS LOGICAL   INITIAL NO         NO-UNDO.
DEFINE VARIABLE l-cc0308                AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-importacao            AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-recalcula-despesas    AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-cotacao-RFI           AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE gr-cotacao-item         AS ROWID                        NO-UNDO.
DEFINE VARIABLE rItemFornec             AS ROWID                        NO-UNDO.
DEFINE VARIABLE de-qt-saldo             LIKE prazo-compra.quant-saldo   NO-UNDO.
DEFINE VARIABLE de-qtd-forn             LIKE prazo-compra.qtd-do-forn   NO-UNDO.
DEFINE VARIABLE l-Integr-Me             AS LOGICAL                      NO-UNDO.

{cdp/cd7300.i1} /* Multi-Planta */
{cdp/cd4300.i3} /* Tratamento atributos livres */

{utils/validaparamIntegraMe.i}
RUN pi-check-integr-me.

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
         HEIGHT             = 20.92
         WIDTH              = 48.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alteraCotAprovada DBOProgram
PROCEDURE alteraCotAprovada :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-cotacao-item-cex.
    DEFINE INPUT PARAMETER pl-cot-aprovada AS LOGICAL NO-UNDO.

    FIND FIRST tt-cotacao-item-cex NO-ERROR.
    IF AVAIL tt-cotacao-item-cex THEN
        FIND FIRST cotacao-item
             WHERE cotacao-item.numero-ordem = tt-cotacao-item-cex.numero-ordem
               AND cotacao-item.cod-emitente = tt-cotacao-item-cex.cod-emitente
               AND cotacao-item.it-codigo    = tt-cotacao-item-cex.it-codigo
               AND cotacao-item.seq-cotac    = tt-cotacao-item-cex.seq-cotac EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL cotacao-item THEN
        ASSIGN cotacao-item.cot-aprovada = pl-cot-aprovada.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aprovaCotacaoItem DBOProgram
PROCEDURE aprovaCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:   Aprova cotacao item se nÆo for aprova‡Æo eletr“nica
  Parameters:
            ipar1 : prCotacaoItem : Rowid da tabela Cotacao-Item
            ipar2 : pcMotivoApr   : Motivo da Aprova‡Æo digitado pelo usu˜rio
            ipar3 : pcSegUsuario  : C«digo do usu˜rio
            ipar4 : piAltData     : Identificador de atualiza‡Æo das datas
            ipar5 : piFornec      : C«digo do fornecedor da cota‡Æo escolhida
            RowErrors     : tabela de erros - recuperar via getRowErrors
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prOrdemCompra AS ROWID       NO-UNDO.
    DEFINE INPUT PARAMETER prCotacaoItem AS ROWID       NO-UNDO.
    DEFINE INPUT PARAMETER pcMotivoApr   AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pcSegUsuario  AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER piAltData     AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER piFornec      AS INTEGER     NO-UNDO.

    IF NOT AVAIL param-compra THEN
        FIND FIRST param-compra NO-LOCK NO-ERROR.

    /* Usadas na include cc0320.i */
    ASSIGN i-alt-data    = piAltData
           c-seg-usuario = pcSegUsuario
           gc-motivo-apr = pcMotivoApr.

    /* Aprova‡Æo da Cota‡Æo */

    FOR FIRST cotacao-item FIELDS(numero-ordem cod-emitente data-cotacao dias-validade log-1 cot-aprovada cod-comprado)
        WHERE ROWID(cotacao-item) = prCotacaoItem NO-LOCK:
    END.

    FOR FIRST ordem-compra FIELDS(numero-ordem num-pedido)
        WHERE ROWID(ordem-compra) = prOrdemCompra NO-LOCK:
    END.

    IF AVAIL ordem-compra AND ordem-compra.num-pedido <> 0 THEN DO:
       /* nÆo pode ser aprovada porque jÿ estÿ associada a um pedido - mostrar mensagem de erro */
       {method/svc/errors/inserr.i &ErrorNumber="5636" &ErrorType="EMS" &ErrorSubType="ERROR"}
       RETURN "NOK":U.
    END.

    ASSIGN l-mapa = NO. /* Integracao Modulo Importacao */

    IF cotacao-item.numero-ordem <> ordem-compra.numero-ordem THEN
        FOR LAST cotacao-item FIELDS(numero-ordem cod-emitente data-cotacao dias-validade log-1 cot-aprovada cod-comprado)
           WHERE cotacao-item.numero-ordem  = ordem-compra.numero-ordem
             AND cotacao-item.cod-emitente  = piFornec
             AND cotacao-item.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF
             AND TODAY <= (cotacao-item.data-cotacao + cotacao-item.dias-validade)  NO-LOCK:
        END.

    IF NOT AVAIL cotacao-item THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="18624"
                                    &ErrorType="EMS"
                                    &ErrorSubType="INFORMATION"
                                    &ErrorParameters="trim(string(ordem-compra.numero-ordem,'zzzzz9,99')) + '~~~~' + string(piFornec)"}
    END.
    ELSE DO:

        ASSIGN gr-cotacao-item = ROWID(cotacao-item).

        FIND FIRST ordem-compra
             WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem  EXCLUSIVE-LOCK NO-ERROR.

        IF (cotacao-item.log-1 OR cotacao-item.cot-aprovada) AND param-compra.log-1 THEN DO:

            /*  Aprova‡Æo Eletr“nica  */

            RUN cdp/cdapi171.p (3,3,ROWID(cotacao-item)).

            IF AVAIL ordem-compra THEN DO:

                IF ordem-compra.nr-requisicao <> 0 THEN DO:

                    FOR FIRST requisicao FIELDS(nr-requisicao tp-requis)
                        WHERE requisicao.nr-requisicao = ordem-compra.nr-requisicao NO-LOCK: END.

                    IF AVAIL requisicao AND requisicao.tp-requis = 3 THEN
                        ASSIGN ordem-compra.expectativa = YES.
                END.

                ASSIGN ordem-compra.situacao     = 5
                       ordem-compra.data-cotacao = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF
                       ordem-compra.pre-unit-for = 0
                       ordem-compra.preco-fornec = 0
                       ordem-compra.mo-codigo    = 0
                       ordem-compra.cod-cond-pag = 0
                       ordem-compra.contato      = ""
                       ordem-compra.cod-comprado = cotacao-item.cod-comprado
                       ordem-compra.preco-unit   = 0
                       ordem-compra.preco-orig   = 0.

                FOR EACH prazo-compra
                   WHERE prazo-compra.numero-ordem = cotacao-item.numero-ordem EXCLUSIVE-LOCK:

                    ASSIGN prazo-compra.situacao = 5.
                END.
            END.

            FIND CURRENT cotacao-item EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN cotacao-item.cot-aprovada = NO
                   cotacao-item.log-1        = NO.
        END.

        IF AVAIL ordem-compra THEN
            ASSIGN ordem-compra.cod-comprado = cotacao-item.cod-comprado.

        /* Aprova cota‡Æo  */

        RUN pi-aprova.

        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        RELEASE cotacao-item.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aprovaEletrCotacaoItem DBOProgram
PROCEDURE aprovaEletrCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:  Este m‚todo faz a aprovacao eletronica se existem aprovadores
            relacionados ao item ou fam¡lia que possam aprovar o documento.
  Parameters:
             ipar1 : prOrdemCompra : rowid da tabela ordem-compra
             ipar2 : prCotacaoItem : rowid da tabela cotacao-item
             ipar3 : pcUsuarCorren : codigo do usuario corrente
             ipar4 : pcNarrativa   : Narrativa de Aprova‡Æo
             ipar5 : piFornec      : C¢digo do fornecedor da cota‡ao
             RowErrors    : tabela de erros - recuperar via getRowErrors
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prOrdemCompra  AS ROWID      NO-UNDO.
    DEFINE INPUT PARAMETER prCotacaoItem  AS ROWID      NO-UNDO.
    DEFINE INPUT PARAMETER pcUsuarCorren  AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER pcNarrativa    AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER piAltData      AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER piFornec       AS INTEGER    NO-UNDO.

    /**** usadas na include cc0320.i *****/
    ASSIGN i-alt-data    = piAltData
           c-seg-usuario = pcUsuarCorren
           gc-motivo-apr = pcNarrativa.

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    FOR FIRST ordem-compra FIELDS(num-pedido numero-ordem)
        WHERE ROWID(ordem-compra) = prOrdemCompra NO-LOCK: END.


    IF AVAIL ordem-compra AND ordem-compra.num-pedido <> 0 THEN DO:
        /* nÆo pode ser aprovada porque jÿ estÿ associada a um pedido - mostrar mensagem de erro */
       {method/svc/errors/inserr.i &ErrorNumber="5636" &ErrorType="EMS" &ErrorSubType="ERROR"}
       RETURN "NOK":U.
    END.

    FOR FIRST cotacao-item FIELDS(numero-ordem cod-emitente data-cotacao dias-validade)
        WHERE ROWID(cotacao-item) = prCotacaoItem NO-LOCK: END.

    IF cotacao-item.numero-ordem <> ordem-compra.numero-ordem THEN
       FOR LAST cotacao-item FIELDS(numero-ordem cod-emitente data-cotacao dias-validade)
          WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
            AND cotacao-item.cod-emitente = piFornec
            AND cotacao-item.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF
            AND TODAY <= (cotacao-item.data-cotacao + cotacao-item.dias-validade) NO-LOCK: END.

    FIND FIRST param-aprov NO-LOCK NO-ERROR.

    IF AVAIL cotacao-item THEN DO:

        IF param-compra.log-1 AND param-aprov.aprova-cotac THEN DO:

            IF AVAIL ordem-compra THEN
                FIND CURRENT ordem-compra EXCLUSIVE-LOCK NO-ERROR.

            /************* Aprova‡Æo Eletr“nica *************/
            ASSIGN gr-cotacao-item = ROWID(cotacao-item).
            RUN pi-efetivaAprovacaoEletr.
        END.
        ELSE DO:
            FIND CURRENT cotacao-item EXCLUSIVE-LOCK NO-ERROR.

            {ocp/oc0205.i}

            ASSIGN cotacao-item.narrativa = pcNarrativa.

            RELEASE cotacao-item.
            RELEASE ordem-compra.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaCotacaoItem DBOProgram
PROCEDURE atualizaCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:    Atualiza Cota‡Æo Item de uma lista de registros selecionados.

  Parameters:
              ipar1 : ttCotaItemReaj       : temp-table com atualiza‡Æo do Reajuste da Cotacao.
              ipar2 : tt-cotacao-item-edit : lista de registros a serem atualizados e campos com novo valor.
              ipar3 : rowObject            : temp-table de cota‡Æo item com valores a serem atualizados em todos
                                             os registros selecionados.
              ipar4 : pdtPrecoBase         : Data Pre‡o Base(quando tiver reajuste de pre‡o).
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR ttCotaItemReaj.
    DEFINE INPUT PARAMETER TABLE FOR tt-cotacao-item-edit.
    DEFINE INPUT PARAMETER TABLE FOR rowObject.
    DEFINE INPUT PARAMETER pdtPrecoBase AS CHARACTER.

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    IF AVAILABLE param-compra THEN
        ASSIGN iPrecoBruto = param-compra.ipi-sobre-preco.
    ELSE
        ASSIGN iPrecoBruto = 2.

    FIND FIRST tt-cotacao-item-edit NO-LOCK NO-ERROR.

    FOR FIRST cotacao-item FIELDS(cod-emitente numero-ordem)
        WHERE ROWID(cotacao-item) = TO-ROWID(tt-cotacao-item-edit.chave) NO-LOCK: END.

    FIND FIRST ttCotaItemReaj NO-LOCK NO-ERROR.

    IF AVAIL ttCotaItemReaj THEN DO:

        DO iCont = 1 TO 5:
            ASSIGN deperReaj = deperReaj + ttCotaItemReaj.perc-reaj[iCont].
        END.
        IF deperReaj = 0 THEN DO:

            FIND FIRST cota-item-reaj
                 WHERE cota-item-reaj.cod-emitente = cotacao-item.cod-emitente
                   AND cota-item-reaj.numero-ordem = cotacao-item.numero-ordem  NO-LOCK NO-ERROR.

            IF AVAIL cota-item-reaj THEN DO:

                DO iCont = 1 TO 5:

                    ASSIGN iCodigo[iCont]      = cota-item-reaj.mo-codigo[iCont]
                           daDataIndice[iCont] = cota-item-reaj.data-indice[iCont]
                           dePercReaj[iCont]   = cota-item-reaj.perc-reaj[iCont].
                END.
            END.
        END.
        ELSE DO:

            DO iCont = 1 TO 5:

                ASSIGN iCodigo[iCont]      = ttCotaItemReaj.mo-codigo[iCont]
                       daDataIndice[iCont] = ttCotaItemReaj.data-indice[iCont]
                       dePercReaj[iCont]   = ttCotaItemReaj.perc-reaj[iCont].
            END.
        END.
    END.
    ELSE DO:

        FIND FIRST cota-item-reaj
             WHERE cota-item-reaj.cod-emitente = cotacao-item.cod-emitente
               AND cota-item-reaj.numero-ordem = cotacao-item.numero-ordem  NO-LOCK NO-ERROR.

        IF AVAIL cota-item-reaj THEN DO:

            DO iCont = 1 TO 5:

                ASSIGN iCodigo[iCont]      = cota-item-reaj.mo-codigo[iCont]
                       daDataIndice[iCont] = cota-item-reaj.data-indice[iCont]
                       dePercReaj[iCont]   = cota-item-reaj.perc-reaj[iCont].
            END.
        END.
    END.

    FIND FIRST rowObject NO-ERROR.

    IF AVAIL rowObject THEN DO:

        FOR EACH tt-cotacao-item-edit:

            FIND FIRST cotacao-item
                 WHERE cotacao-item.numero-ordem = INT(ENTRY(1,tt-cotacao-item-edit.chave))
                   AND cotacao-item.cod-emitente = INT(ENTRY(2,tt-cotacao-item-edit.chave))
                   AND cotacao-item.it-codigo    = ENTRY(3,tt-cotacao-item-edit.chave)
                   AND cotacao-item.seq-cotac    = INT(ENTRY(4,tt-cotacao-item-edit.chave)) EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAIL cotacao-item THEN DO:

                CREATE cotacao-item.
                ASSIGN cotacao-item.numero-ordem = INT(ENTRY(1,tt-cotacao-item-edit.chave))
                       cotacao-item.cod-emitente = INT(ENTRY(2,tt-cotacao-item-edit.chave))
                       cotacao-item.it-codigo    = ENTRY(3,tt-cotacao-item-edit.chave)
                       cotacao-item.seq-cotac    = INT(ENTRY(4,tt-cotacao-item-edit.chave)).
            END.


            ASSIGN cotacao-item.data-cotacao  = rowObject.data-cotacao
                   cotacao-item.un            = tt-cotacao-item-edit.un1
                   cotacao-item.preco-fornec  = tt-cotacao-item-edit.preco-fornec1
                   cotacao-item.aliquota-ipi  = tt-cotacao-item-edit.aliquota-ipi1
                   cotacao-item.aliquota-icm  = tt-cotacao-item-edit.aliquota-icm1
                   cotacao-item.mo-codigo     = rowObject.mo-codigo
                   cotacao-item.aliquota-iss  = rowObject.aliquota-iss
                   cotacao-item.codigo-ipi    = rowObject.codigo-ipi
                   cotacao-item.dias-validade = rowObject.dias-validade
                   cotacao-item.codigo-icm    = rowObject.codigo-icm
                   cotacao-item.perc-descto   = rowObject.perc-descto
                   cotacao-item.valor-descto  = ((cotacao-item.perc-descto * cotacao-item.preco-fornec) / 100)
                   cotacao-item.aliquota-iss  = rowObject.aliquota-iss
                   cotacao-item.possui-reaj   = rowObject.possui-reaj
                   cotacao-item.frete         = rowObject.frete
                   cotacao-item.cod-cond-pag  = rowObject.cod-cond-pag
                   cotacao-item.valor-frete   = rowObject.valor-frete
                   cotacao-item.prazo-entreg  = rowObject.prazo-entreg
                   cotacao-item.contato       = rowObject.contato
                   cotacao-item.cod-comprado  = rowObject.cod-comprado
                   cotacao-item.valor-taxa    = rowObject.valor-taxa
                   cotacao-item.nr-dias-taxa  = rowObject.nr-dias-taxa
                   cotacao-item.pre-unit-for  = DEC(tt-cotacao-item-edit.pre-unit-for)
                   cotacao-item.data-atualiz  = TODAY
                   cotacao-item.hora-atualiz  = STRING(TIME,"hh:mm:ss":U)
                   cotacao-item.taxa-financ   = rowObject.taxa-financ
                   cotacao-item.cod-transp    = rowObject.cod-transp
                   cotacao-item.log-2         = tt-cotacao-item-edit.log-2.

            FIND FIRST ordem-compra
                 WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem EXCLUSIVE-LOCK NO-ERROR.

            RUN inbo/boin082ca.p PERSISTENT SET hboin082ca.
            RUN calcIndiceCotacaoItem IN hBoin082ca (INPUT  TABLE rowObject,
                                                     INPUT  cotacao-item.it-codigo,
                                                     OUTPUT deIndice).
            DELETE PROCEDURE hBoin082ca.
            ASSIGN hBoin082ca = ?.

            IF AVAIL ordem-compra THEN
                ASSIGN ordem-compra.situacao = 5.

            FOR EACH prazo-compra
               WHERE prazo-compra.numero-ordem = cotacao-item.numero-ordem EXCLUSIVE-LOCK:

                IF AVAIL ordem-compra THEN
                    ASSIGN prazo-compra.situacao = 5.
            END.

            IF deIndice = 0 OR deIndice = ? THEN ASSIGN deIndice = 1.
            {cdp/cd9300.i cotacao-item}   /* Calculo de Preco */


            FOR EACH tt-epc WHERE tt-epc.cod-event = "AfterDesconto":U:
                DELETE tt-epc.
            END.
            {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                                 &CodParameter='"handle"'
                                 &ValueParameter="string(this-procedure)"}

            {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                                 &CodParameter='"table"'
                                 &ValueParameter='"cotacao-item"'}

            {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                                 &CodParameter='"r-rowid"'
                                 &ValueParameter="string(rowid(cotacao-item))"}


            {include/i-epc201.i "AfterDesconto"}
            IF  RETURN-VALUE = "NOK":U THEN DO:
                UNDO, RETURN "NOK":U.
            END.

            IF AVAIL ordem-compra THEN DO:

                CREATE tt-cotacao-item-aux.
                ASSIGN tt-cotacao-item-aux.numero-ordem = cotacao-item.numero-ordem
                       tt-cotacao-item-aux.cod-emitente = cotacao-item.cod-emitente
                       tt-cotacao-item-aux.it-codigo    = cotacao-item.it-codigo
                       tt-cotacao-item-aux.seq-cotac    = cotacao-item.seq-cotac
                       tt-cotacao-item-aux.data-cotacao = cotacao-item.data-cotacao
                       tt-cotacao-item-aux.cod-cond-pag = cotacao-item.cod-cond-pag
                       tt-cotacao-item-aux.perc-descto  = cotacao-item.perc-descto
                       tt-cotacao-item-aux.aliquota-ipi = cotacao-item.aliquota-ipi
                       tt-cotacao-item-aux.valor-taxa   = cotacao-item.valor-taxa
                       tt-cotacao-item-aux.nr-dias-taxa = cotacao-item.nr-dias-taxa
                       tt-cotacao-item-aux.codigo-ipi   = cotacao-item.codigo-ipi
                       tt-cotacao-item-aux.log-2        = cotacao-item.log-2
                       tt-cotacao-item-aux.preco-unit   = cotacao-item.preco-unit
                       tt-cotacao-item-aux.mo-codigo    = cotacao-item.mo-codigo.

                RUN inbo/boin681.p PERSISTENT SET h-boin681.
                RUN openQueryStatic IN h-boin681 ("main":U).
                RUN atualizaDadosControlePreco IN h-boin681 (INPUT ROWID(ordem-compra),
                                                             INPUT TABLE tt-cotacao-item-aux).
                DELETE PROCEDURE h-boin681.
                ASSIGN h-boin681 = ?.
            END.

            IF rowObject.possui-reaj THEN DO:
                FIND FIRST cota-item-reaj
                     WHERE cota-item-reaj.it-codigo    = cotacao-item.it-codigo
                       AND cota-item-reaj.numero-ordem = cotacao-item.numero-ordem
                       AND cota-item-reaj.cod-emitente = cotacao-item.cod-emitente
                       AND cota-item-reaj.data-cotacao = cotacao-item.data-cotacao
                       AND cota-item-reaj.seq-cotac    = cotacao-item.seq-cotac  EXCLUSIVE-LOCK NO-ERROR.

                IF NOT AVAILABLE cota-item-reaj THEN DO:

                    FIND FIRST cota-item-reaj
                         WHERE cota-item-reaj.numero-ordem = cotacao-item.numero-ordem
                           AND cota-item-reaj.cod-emitente = cotacao-item.cod-emitente
                           AND cota-item-reaj.seq-cotac    = cotacao-item.seq-cotac EXCLUSIVE-LOCK NO-ERROR.

                    IF NOT AVAILABLE cota-item-reaj THEN DO:

                        CREATE cota-item-reaj.
                        ASSIGN cota-item-reaj.it-codigo     = cotacao-item.it-codigo
                                cota-item-reaj.numero-ordem = cotacao-item.numero-ordem
                                cota-item-reaj.cod-emitente = cotacao-item.cod-emitente
                                cota-item-reaj.data-cotacao = cotacao-item.data-cotacao
                                cota-item-reaj.seq-cotac    = cotacao-item.seq-cotac.
                    END.
                END.

                ASSIGN cota-item-reaj.dt-preco-base  = DATE(pdtPrecoBase)
                       cota-item-reaj.mo-codigo[1]   = iCodigo[1]
                       cota-item-reaj.data-indice[1] = daDataIndice[1]
                       cota-item-reaj.perc-reaj[1]   = dePercReaj[1]
                       cota-item-reaj.mo-codigo[2]   = iCodigo[2]
                       cota-item-reaj.data-indice[2] = daDataIndice[2]
                       cota-item-reaj.perc-reaj[2]   = dePercReaj[2]
                       cota-item-reaj.mo-codigo[3]   = iCodigo[3]
                       cota-item-reaj.data-indice[3] = daDataIndice[3]
                       cota-item-reaj.perc-reaj[3]   = dePercReaj[3]
                       cota-item-reaj.mo-codigo[4]   = iCodigo[4]
                       cota-item-reaj.data-indice[4] = daDataIndice[4]
                       cota-item-reaj.perc-reaj[4]   = dePercReaj[4]
                       cota-item-reaj.mo-codigo[5]   = iCodigo[5]
                       cota-item-reaj.data-indice[5] = daDataIndice[5]
                       cota-item-reaj.perc-reaj[5]   = dePercReaj[5].
            END.
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDadosCotacaoItemPedEmerg DBOProgram
PROCEDURE atualizaDadosCotacaoItemPedEmerg :
/*------------------------------------------------------------------------------
  Purpose:   Atualiza os dados da cotacao-item ap¢s
             a cria‡Æo ou modifica‡Æo de um registro.
  Parameters:
              ipar1 : pcUsuarCorren : Usuÿrio atual do sistema
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcAction      AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pcUsuarCorren AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER r-chave       AS ROWID       NO-UNDO. /* rowid cotacao-item */
    DEFINE INPUT PARAMETER lGeraItFornec AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE c-comprado-aprov LIKE comprador.cod-comprado NO-UNDO.
    DEFINE VARIABLE i-empresa        LIKE empresa.ep-codigo      NO-UNDO.
    DEFINE VARIABLE lRetornoAprov    AS LOGICAL INITIAL YES      NO-UNDO.
    DEFINE VARIABLE c-lotacao        AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE h-boin772        AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE d-pre-unit-for   AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE d-pre-unit       AS DECIMAL                  NO-UNDO.

    IF NOT AVAIL param-compra THEN
        FIND FIRST param-compra NO-LOCK NO-ERROR.
    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.
    IF NOT AVAIL param-aprov THEN
        FIND FIRST param-aprov NO-LOCK NO-ERROR.

    FIND FIRST cotacao-item
         WHERE ROWID(cotacao-item) = r-chave EXCLUSIVE-LOCK NO-ERROR.

    FOR FIRST ordem-compra FIELDS(numero-ordem cod-emitente it-codigo qt-solic situacao num-pedido)
       WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK: END.

    FOR FIRST pedido-compr FIELDS(num-pedido cod-cond-pag data-pedido cod-transp responsavel emergencial cod-emitente cod-estab-gestor)
        WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.

    FOR FIRST prazo-compra FIELDS(numero-ordem it-codigo un)
        WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK: END.

    FOR FIRST item FIELDS(it-codigo tipo-contr)
        WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK: END.

    FOR FIRST emitente FIELDS(cod-emitente pais estado natureza cod-cond-pag)
        WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK: END.

    FOR FIRST item-fornec FIELDS(it-codigo cod-emitente ativo num-casa-dec fator-conver)
        WHERE item-fornec.it-codigo    = item.it-codigo
          AND item-fornec.cod-emitente = emitente.cod-emitente NO-LOCK: END.

    IF lGeraItFornec THEN DO:

        /*** CRIA°€O DO RELACIONAMENTO ITEM-FORNEC ***/
        IF NOT AVAILABLE item-fornec AND item.tipo-contr <> 4 AND item.it-codigo  <> "" THEN DO:

            IF AVAIL emitente THEN
                RUN pi-cria-item-fornec.

            IF NOT AVAIL item-fornec THEN

                FOR FIRST item-fornec FIELDS(it-codigo cod-emitente ativo num-casa-dec fator-conver)
                    WHERE item-fornec.it-codigo    = item.it-codigo
                      AND item-fornec.cod-emitente = emitente.cod-emitente NO-LOCK: END.
        END.
    END.

    ASSIGN deIndice = 1.

    IF ordem-compra.situacao <> 4 THEN DO:

        EMPTY TEMP-TABLE tt-cotacao-item-aux.

        CREATE tt-cotacao-item-aux.
        BUFFER-COPY cotacao-item TO tt-cotacao-item-aux.

        RUN inbo/boin082ca.p PERSISTENT SET hboin082ca.
        RUN calcIndiceCotacaoItem IN hBoin082ca (INPUT  TABLE tt-cotacao-item-aux,
                                                 INPUT  cotacao-item.it-codigo,
                                                 OUTPUT deIndice).
        DELETE PROCEDURE hBoin082ca.
        ASSIGN hBoin082ca = ?.

        /* necess rio efetuar esta conversÆo neste ponto pois quando criada a parcela
           ainda nÆo h  cota‡Æo cadastrada. J  na altera‡Æo pode-se estar alterando a unidade de
           medida da cota‡Æo, desta forma, tamb‚m ‚ necess rio este controle. */

        FOR EACH prazo-compra
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:

           ASSIGN prazo-compra.qtd-do-forn    = prazo-compra.quantidade   * deIndice
                  prazo-compra.qtd-rec-forn   = prazo-compra.quant-receb  * deIndice
                  prazo-compra.qtd-rej-forn   = prazo-compra.quant-rejeit * deIndice
                  prazo-compra.qtd-sal-forn   = (prazo-compra.qtd-do-forn  - prazo-compra.qtd-rec-forn + prazo-compra.qtd-rej-forn)
                  prazo-compra.quant-saldo    = prazo-compra.quantidade - prazo-compra.quant-receb + prazo-compra.quant-rejeit
                  prazo-compra.qtd-a-ped-forn = prazo-compra.qtd-do-forn.

           IF prazo-compra.qtd-sal-forn < 0 THEN
               ASSIGN prazo-compra.qtd-sal-forn = 0.

           IF prazo-compra.quantidade > 9999999.9999 THEN DO:
               /* Quantidade da parcela &1 maior que 9999999.9999 - unidade medida interna */
               {method/svc/errors/inserr.i &ErrorNumber="27685"
                                           &ErrorType="EMS":U
                                           &ErrorSubType="ERROR":U
                                           &ErrorParameters="trim(string(prazo-compra.parcela, '>>9'))"}
           END.

           IF prazo-compra.qtd-do-forn > 9999999.9999 THEN DO:
               /* Quantidade da parcela &1 maior que 9999999.9999 - unidade medida fornecedor */
               {method/svc/errors/inserr.i &ErrorNumber="27684"
                                           &ErrorType="EMS":U
                                           &ErrorSubType="ERROR":U
                                           &ErrorParameters="trim(string(prazo-compra.parcela, '>>9'))"}
           END.
        END.
    END.

    FIND FIRST ordem-compra
         WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem EXCLUSIVE-LOCK NO-ERROR NO-WAIT.

    IF l-Integr-Me THEN DO:
        IF CAN-FIND(FIRST ordem-compra-integr-me WHERE ordem-compra-integr-me.numero-ordem = ordem-compra.numero-ordem) THEN
            ASSIGN cotacao-item.preco-unit = cotacao-item.pre-unit-for / deIndice.
        ELSE
            ASSIGN cotacao-item.preco-unit = cotacao-item.pre-unit-for * deIndice.
    END.
    ELSE
       ASSIGN cotacao-item.preco-unit = cotacao-item.pre-unit-for * deIndice.

    assign cotacao-item.cot-aprovada = YES
           cotacao-item.usuario      = pcUsuarCorren
           cotacao-item.data-atualiz = TODAY
           cotacao-item.hora-atualiz = STRING(TIME,"hh:mm:ss":U)
           ordem-compra.data-cotacao = cotacao-item.data-cotacao
           ordem-compra.pre-unit-for = cotacao-item.pre-unit-for
           ordem-compra.preco-fornec = cotacao-item.preco-fornec
           ordem-compra.mo-codigo    = cotacao-item.mo-codigo
           ordem-compra.codigo-ipi   = cotacao-item.codigo-ipi
           ordem-compra.aliquota-ipi = cotacao-item.aliquota-ipi
           ordem-compra.codigo-icm   = cotacao-item.codigo-icm
           ordem-compra.aliquota-icm = cotacao-item.aliquota-icm
           ordem-compra.aliquota-iss = cotacao-item.aliquota-iss
           ordem-compra.frete        = cotacao-item.frete
           ordem-compra.valor-frete  = cotacao-item.valor-frete
           ordem-compra.taxa-financ  = cotacao-item.taxa-financ
           ordem-compra.valor-taxa   = cotacao-item.valor-taxa
           ordem-compra.nr-dias-taxa = cotacao-item.nr-dias-taxa
           ordem-compra.perc-descto  = cotacao-item.perc-descto
           ordem-compra.valor-descto = cotacao-item.valor-descto
           ordem-compra.cod-cond-pag = cotacao-item.cod-cond-pag
           ordem-compra.prazo-entreg = cotacao-item.prazo-entreg
           ordem-compra.contato      = cotacao-item.contato
           ordem-compra.preco-unit   = cotacao-item.preco-unit
           ordem-compra.cod-transp   = cotacao-item.cod-transp
           ordem-compra.prazo-entreg = cotacao-item.prazo-entreg
           ordem-compra.codigo-icm   = cotacao-item.codigo-icm
           ordem-compra.cod-transp   = IF AVAIL pedido-compr THEN pedido-compr.cod-transp ELSE 0
           cotacao-item.cod-comprado = ordem-compra.cod-comprado
           cotacao-item.cod-transp   = IF AVAIL pedido-compr THEN pedido-compr.cod-transp ELSE 0.

    IF l-Integr-Me THEN DO:
        IF CAN-FIND(FIRST ordem-compra-integr-me WHERE ordem-compra-integr-me.numero-ordem = ordem-compra.numero-ordem)
        AND NOT PROGRAM-NAME(2) MATCHES "*cc0300b*"
        AND NOT PROGRAM-NAME(3) MATCHES "*cc0300b*" THEN DO: /* NÆo fazer a atualiza‡Æo autom tica do pre‡o pelo CC0300B*/
            ASSIGN d-pre-unit-for            = ordem-compra.pre-unit-for
                   d-pre-unit                = ordem-compra.preco-unit
                   ordem-compra.pre-unit-for = d-pre-unit
                   ordem-compra.preco-fornec = d-pre-unit
                   ordem-compra.preco-unit   = d-pre-unit-for.

            ASSIGN d-pre-unit-for            = cotacao-item.pre-unit-for
                   d-pre-unit                = cotacao-item.preco-unit
                   cotacao-item.pre-unit-for = d-pre-unit
                   cotacao-item.preco-fornec = d-pre-unit
                   cotacao-item.preco-unit   = d-pre-unit-for.

        END.
    END.

    IF pcAction <> "update":U THEN DO:
        ASSIGN ordem-compra.preco-orig = cotacao-item.preco-unit.
    END.

    ASSIGN deIndice  = 1
           de-indice = 1.

    IF AVAIL prazo-compra AND cotacao-item.un <> prazo-compra.un THEN DO:
        {cdp/cd9950.i prazo-compra.un cotacao-item.un cotacao-item.cod-emitente}
        ASSIGN deIndice = de-indice.
    END.

    if AVAILABLE ordem-compra AND AVAILABLE param-compra AND param-compra.log-1 THEN DO:

        ASSIGN gr-ordem-compra = rowid(ordem-compra).

        ASSIGN lRetornoAprov    = YES
               c-comprado-aprov = IF param-aprov.aprov-total-pedido AND AVAIL pedido-compr THEN pedido-compr.responsavel
                                  ELSE ordem-compra.cod-comprado.

       /*BO mla-lotacao*/
       RUN inbo/boin772.p PERSISTENT SET h-boin772.
       IF AVAIL pedido-compr AND pedido-compr.emergencial AND param-aprov.aprova-emerg THEN DO:

           RUN lap/mlaapi099.p (INPUT 6).

           IF CAN-FIND(funcao
                 WHERE funcao.cd-funcao = "Integra_MLA_EMS":U
                   AND funcao.ativo) AND RETURN-VALUE <> "NOK":U  THEN DO:

               IF AVAIL pedido-compr AND pedido-compr.cod-estab-gestor <> "" THEN
                   ASSIGN c-estabelecimento = pedido-compr.cod-estab-gestor.
               ELSE
                   ASSIGN c-estabelecimento = ordem-compra.cod-estabel.

               FOR FIRST estabelec
                   WHERE estabelec.cod-estabel = c-estabelecimento NO-LOCK:

                   RUN cdp/cd9970.p (INPUT ROWID(estabelec), OUTPUT i-empresa).
               END.

               FIND FIRST mla-tipo-doc-aprov
                    WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
                      AND mla-tipo-doc-aprov.cod-estabel = c-estabelecimento
                      AND mla-tipo-doc-aprov.cod-tip-doc = 8 NO-LOCK NO-ERROR.

               ASSIGN de-valor-total = 0
                      de-qtd-forn    = 0.

               IF AVAIL mla-tipo-doc-aprov AND mla-tipo-doc-aprov.apr-tip-doc THEN DO: /*8 - Pedido Emergencial - Total*/

                   FOR EACH b-ordem-compra
                      WHERE b-ordem-compra.num-pedido = pedido-compr.num-pedido
                        AND (b-ordem-compra.situacao  = 2 OR b-ordem-compra.situacao = 6) NO-LOCK:

                       FOR EACH b-prazo-compra
                          WHERE b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem NO-LOCK:

                           /*Eliminada*/
                           IF b-prazo-compra.situacao = 4 THEN NEXT.

                           IF mla-tipo-doc-aprov.idi-tip-val-pendcia = 1 THEN  /* Total */
                               ASSIGN de-qtd-forn = de-qtd-forn + b-prazo-compra.qtd-do-forn.
                           ELSE
                               ASSIGN de-qtd-forn = de-qtd-forn + b-prazo-compra.qtd-sal-forn. /* Saldo */
                       END.

                       IF de-qtd-forn < 0 THEN
                           ASSIGN de-qtd-forn = 0.

                       /* Calculo do Valor da Cota‡Æo */
                       IF cotacao-item.mo-codigo = 0 THEN
                           ASSIGN de-cotacao-moeda = 1.
                       ELSE DO:

                           RUN cdp/cd0812.p (INPUT cotacao-item.mo-codigo,
                                             INPUT 0,
                                             INPUT 1,
                                             INPUT cotacao-item.data-cotacao,
                                             OUTPUT de-cotacao-moeda).
                           IF de-cotacao-moeda = ? THEN
                               ASSIGN de-cotacao-moeda = 1.
                       END.

                       ASSIGN de-valor-total  = de-valor-total + (b-ordem-compra.pre-unit-for * de-qtd-forn * de-cotacao-moeda)
                              de-qtd-forn     = 0.
                   END.
               END.
               ELSE DO:

                   FIND FIRST mla-tipo-doc-aprov /*19 - Pedido Emergencial - Item*/
                        WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
                          AND mla-tipo-doc-aprov.cod-estabel = c-estabelecimento
                          AND mla-tipo-doc-aprov.cod-tip-doc = 19 NO-LOCK NO-ERROR.

                   IF AVAIL mla-tipo-doc-aprov AND mla-tipo-doc-aprov.apr-tip-doc THEN DO:

                       FOR EACH b-prazo-compra
                          WHERE b-prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:

                           /*Eliminada*/
                           IF b-prazo-compra.situacao = 4 THEN NEXT.

                           IF mla-tipo-doc-aprov.idi-tip-val-pendcia = 1 THEN  /* Total */
                               ASSIGN de-qtd-forn = de-qtd-forn + b-prazo-compra.qtd-do-forn.
                           ELSE
                               ASSIGN de-qtd-forn = de-qtd-forn + b-prazo-compra.qtd-sal-forn. /* Saldo */
                       END.

                       IF de-qtd-forn < 0 THEN
                           ASSIGN de-qtd-forn = 0.

                       /* Calculo do Valor da Cota‡Æo */
                       IF cotacao-item.mo-codigo = 0 THEN
                           ASSIGN de-cotacao-moeda = 1.
                       ELSE DO:

                           RUN cdp/cd0812.p (INPUT  cotacao-item.mo-codigo,
                                             INPUT  0,
                                             INPUT  1,
                                             INPUT  cotacao-item.data-cotacao,
                                             OUTPUT de-cotacao-moeda).

                            IF de-cotacao-moeda = ? THEN
                                ASSIGN de-cotacao-moeda = 1.
                       END.

                       ASSIGN de-valor-item  = de-qtd-forn * cotacao-item.pre-unit-for * de-cotacao-moeda.
                   END.
               END.

               IF NOT param-aprov.aprov-total-pedido THEN DO: /*Aprova‡Æo por Item*/

                   RUN buscaLotacaoUsuarOrig IN h-boin772(INPUT 19, /*Pedido Emergencial Item - C¢digo no MLA*/
                                                          INPUT ordem-compra.nr-requisicao,
                                                          INPUT c-comprado-aprov,
                                                          OUTPUT c-lotacao).
                   IF c-lotacao = "" THEN
                       ASSIGN c-lotacao = ordem-compra.sc-codigo.
               END.
               ELSE
                   ASSIGN c-lotacao = ordem-compra.sc-codigo.

               RUN lap/mlaapi173.p (INPUT  6,
                                    INPUT  cotacao-item.it-codigo,
                                    INPUT  c-comprado-aprov,
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
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="ERROR"
                                                   &ErrorParameters="tt-erro.c-param"}

                       RETURN "NOK":U.
                   END.
               END.
           END.
           ELSE DO:

               IF ordem-compra.situacao <> 4 THEN /* eliminada */
                   RUN cdp/cdapi173.p (INPUT  6,
                                       INPUT  ordem-compra.it-codigo,
                                       INPUT  c-comprado-aprov,
                                       OUTPUT lRetornoAprov).
           END.
       END.

       IF AVAIL pedido-compr AND NOT pedido-compr.emergencial AND param-aprov.aprova-pedido THEN DO:

           RUN lap/mlaapi099.p (INPUT 4).

           IF CAN-FIND(funcao
                 WHERE funcao.cd-funcao = "Integra_MLA_EMS":U
                   AND funcao.ativo) AND RETURN-VALUE <> "NOK":U THEN DO:

               IF AVAIL pedido-compr AND pedido-compr.cod-estab-gestor <> "" THEN
                   ASSIGN c-estabelecimento = pedido-compr.cod-estab-gestor.
               ELSE
                   ASSIGN c-estabelecimento = ordem-compra.cod-estabel.

               FOR FIRST estabelec
                   WHERE estabelec.cod-estabel = c-estabelecimento NO-LOCK:

                   RUN cdp/cd9970.p (INPUT ROWID(estabelec), OUTPUT i-empresa).
               END.

               FIND FIRST mla-tipo-doc-aprov
                    WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
                      AND mla-tipo-doc-aprov.cod-estabel = c-estabelecimento
                      AND mla-tipo-doc-aprov.cod-tip-doc = 7 NO-LOCK NO-ERROR.

               ASSIGN de-valor-total = 0
                      de-qtd-forn    = 0.

               IF AVAIL mla-tipo-doc-aprov AND mla-tipo-doc-aprov.apr-tip-doc THEN DO: /*7 - Pedido Compra - Total*/

                   FOR EACH b-ordem-compra
                      WHERE b-ordem-compra.num-pedido = pedido-compr.num-pedido
                        AND (b-ordem-compra.situacao  = 2 OR b-ordem-compra.situacao   = 6) NO-LOCK:

                       FOR EACH b-prazo-compra
                          WHERE b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem NO-LOCK:

                           /*Eliminada*/
                           IF b-prazo-compra.situacao = 4 THEN NEXT.

                           IF mla-tipo-doc-aprov.idi-tip-val-pendcia = 1 THEN  /* Total */
                               ASSIGN de-qtd-forn = de-qtd-forn + b-prazo-compra.qtd-do-forn.
                           ELSE
                               ASSIGN de-qtd-forn = de-qtd-forn + b-prazo-compra.qtd-sal-forn. /* Saldo */
                       END.

                       IF de-qtd-forn < 0 THEN
                           ASSIGN de-qtd-forn = 0.

                       /* Calculo do Valor da Cota‡Æo */
                       IF cotacao-item.mo-codigo = 0 THEN
                           ASSIGN de-cotacao-moeda = 1.
                       ELSE DO:

                           RUN cdp/cd0812.p (INPUT  cotacao-item.mo-codigo,
                                             INPUT  0,
                                             INPUT  1,
                                             INPUT  cotacao-item.data-cotacao,
                                             OUTPUT de-cotacao-moeda).

                           IF de-cotacao-moeda = ? THEN
                               ASSIGN de-cotacao-moeda = 1.
                       END.

                       ASSIGN de-valor-total  = de-valor-total + (b-ordem-compra.pre-unit-for * de-qtd-forn * de-cotacao-moeda)
                              de-qtd-forn     = 0.
                   END.
               END.
               ELSE DO:

                   FIND FIRST mla-tipo-doc-aprov /*6 - Pedido Compra - Item*/
                        WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
                          AND mla-tipo-doc-aprov.cod-estabel = c-estabelecimento
                          AND mla-tipo-doc-aprov.cod-tip-doc = 6 NO-LOCK NO-ERROR.

                   IF AVAIL mla-tipo-doc-aprov AND mla-tipo-doc-aprov.apr-tip-doc THEN DO:

                       FOR EACH b-prazo-compra
                          WHERE b-prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:

                           /*Eliminada*/
                           IF b-prazo-compra.situacao = 4 THEN NEXT.

                           IF mla-tipo-doc-aprov.idi-tip-val-pendcia = 1 THEN  /* Total */
                               ASSIGN de-qtd-forn = de-qtd-forn + b-prazo-compra.qtd-do-forn.
                           ELSE
                               ASSIGN de-qtd-forn = de-qtd-forn + b-prazo-compra.qtd-sal-forn. /* Saldo */
                       END.

                       IF de-qtd-forn < 0 THEN
                           ASSIGN de-qtd-forn = 0.

                       /* Calculo do Valor da Cota‡Æo */
                       IF cotacao-item.mo-codigo = 0 THEN
                           ASSIGN de-cotacao-moeda = 1.
                       ELSE DO:

                           RUN cdp/cd0812.p (input  cotacao-item.mo-codigo,
                                             input  0,
                                             input  1,
                                             input  cotacao-item.data-cotacao,
                                             output de-cotacao-moeda).

                           IF de-cotacao-moeda = ? THEN
                               ASSIGN de-cotacao-moeda = 1.
                       END.

                       ASSIGN de-valor-item  = de-qtd-forn * cotacao-item.pre-unit-for * de-cotacao-moeda.
                   END.
               END.

               IF NOT param-aprov.aprov-total-pedido THEN DO: /*Aprova‡Æo por Item*/

                   RUN buscaLotacaoUsuarOrig IN h-boin772(INPUT  6, /*Pedido Compra Item - C¢digo no MLA*/
                                                          INPUT  ordem-compra.nr-requisicao,
                                                          INPUT  c-comprado-aprov,
                                                          OUTPUT c-lotacao).
                   IF c-lotacao = "" THEN
                       ASSIGN c-lotacao = ordem-compra.sc-codigo.
               END.
               ELSE
                   ASSIGN c-lotacao = ordem-compra.sc-codigo.

               RUN lap/mlaapi173.p (INPUT 4,
                                    INPUT ordem-compra.it-codigo,
                                    INPUT c-comprado-aprov,
                                    INPUT ordem-compra.ct-codigo,
                                    INPUT STRING(pedido-compr.cod-emitente),
                                    INPUT c-lotacao,
                                    INPUT de-valor-item,
                                    INPUT de-valor-total,
                                    INPUT c-estabelecimento,
                                    OUTPUT TABLE tt-erro).

               IF RETURN-VALUE = "NOK":U THEN DO:

                   FIND FIRST tt-erro NO-ERROR.
                   IF AVAIL tt-erro THEN DO:

                       {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="ERROR"
                                                   &ErrorParameters="tt-erro.c-param"}

                        RETURN "NOK":U.
                   END.
               END.
           END.
           ELSE DO:

               IF ordem-compra.situacao <> 4 THEN /* eliminada */
                   RUN cdp/cdapi173.p (INPUT  4,
                                       INPUT  ordem-compra.it-codigo,
                                       INPUT  c-comprado-aprov,
                                       OUTPUT lRetornoAprov).
           END.
       END.

       /*BO mla-lotacao*/
       IF VALID-HANDLE(h-boin772) THEN DO:
           DELETE PROCEDURE h-boin772.
           ASSIGN h-boin772 = ?.
       END.

       IF NOT lRetornoAprov THEN DO:
          {method/svc/errors/inserr.i &ErrorNumber="15661" &ErrorType="EMS" &ErrorSubType="ERROR"}
       END.
    END.

     /* Ira verificar se nao passou pelo botao despesas antes de validar a integracao com Investimentos  */
     IF NOT gl-bt-despesas-cc0300 THEN
         RUN integracaoInvestimentosCotacaoItem (INPUT "M":U, INPUT ROWID(cotacao-item)).

    FOR EACH tt-epc WHERE tt-epc.cod-event = "AtualizaCotacEmOrdem":U:
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"AtualizaCotacEmOrdem"' &CodParameter="'OBJECT-HANDLE'":U &ValueParameter="string(this-procedure)"}

    {include/i-epc200.i2 &CodEvent='"AtualizaCotacEmOrdem"' &CodParameter='"rowid-ordem-compra"' &ValueParameter="string(rowid(ordem-compra))"}

    {include/i-epc201.i "AtualizaCotacEmOrdem"}

    RUN ccp/ccapi001.p (INPUT ROWID(ordem-compra)).

    IF RETURN-VALUE = "NOK":U THEN DO:
        UNDO, RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CalculaPrecoItem DBOProgram
PROCEDURE CalculaPrecoItem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-cotacao-item-aux2.
    DEFINE INPUT PARAMETER r-chave AS ROWID NO-UNDO. /* rowid cotacao-item */

    FIND FIRST cotacao-item
         WHERE ROWID(cotacao-item) = r-chave EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL cotacao-item THEN DO:

        CREATE tt-cotacao-item-aux1.
        BUFFER-COPY cotacao-item TO tt-cotacao-item-aux1.

        FIND FIRST tt-cotacao-item-aux2 NO-ERROR.

        IF  AVAIL  tt-cotacao-item-aux2 THEN DO:

            ASSIGN tt-cotacao-item-aux1.aliquota-ipi = tt-cotacao-item-aux2.aliquota-ipi.

            {cdp/cd9300.i tt-cotacao-item-aux1} /* Calculo de Preco */

            FOR EACH tt-epc WHERE tt-epc.cod-event = "AfterDesconto":U:
                DELETE tt-epc.
            END.

            {include/i-epc200.i2 &CodEvent='"AfterDesconto"' &CodParameter='"handle"' &ValueParameter="string(this-procedure)"}

            {include/i-epc200.i2 &CodEvent='"AfterDesconto"' &CodParameter='"table"' &ValueParameter='"tt-cotacao-item-aux1"'}

            {include/i-epc200.i2 &CodEvent='"AfterDesconto"' &CodParameter='"r-rowid"' &ValueParameter="string(rowid(tt-cotacao-item-aux1))"}

            {include/i-epc201.i "AfterDesconto"}

            IF RETURN-VALUE = "NOK":U THEN DO:
                UNDO, RETURN "NOK":U.
            END.

            IF AVAIL tt-cotacao-item-aux1 THEN
                ASSIGN tt-cotacao-item-aux1.preco-unit = tt-cotacao-item-aux1.pre-unit-for.
        END.
    END.

    RUN inbo/boin082.p PERSISTENT SET h-boin082.
    RUN setConstraintNumOrdem IN h-boin082 (INPUT cotacao-item.numero-ordem).
    RUN openQueryStatic IN h-boin082 (INPUT "ByCotacao":U).
    RUN repositionRecord IN h-boin082 (INPUT r-chave).
    RUN setRecord IN h-boin082 (INPUT TABLE tt-cotacao-item-aux1).
    RUN updateRecord IN h-boin082.
    RUN getRowErrors IN h-boin082 (OUTPUT TABLE rowErrors).

    DELETE PROCEDURE h-boin082.
    ASSIGN h-boin082 = ?.

    FOR EACH tt-epc WHERE tt-epc.cod-event = "AfterDesconto":U:
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"AfterDesconto"' &CodParameter='"hprocedure"' &ValueParameter='"this-procedure"'}

    {include/i-epc200.i2 &CodEvent='"AfterDesconto"' &CodParameter='"nometable"' &ValueParameter='"tt-cotacao-item-aux1"'}

    {include/i-epc200.i2 &CodEvent='"AfterDesconto"' &CodParameter='"rowidtable"' &ValueParameter='""'}

    {include/i-epc201.i "AfterDesconto"}

    IF RETURN-VALUE = "NOK":U THEN DO:
        UNDO, RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CalculaValorFreteCotacao DBOProgram
PROCEDURE CalculaValorFreteCotacao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-cotacao AS ROWID NO-UNDO.

    DEFINE VARIABLE c-nome-transp AS CHARACTER                              NO-UNDO.
    DEFINE VARIABLE de-peso       AS DECIMAL    FORMAT ">>>,>>>,>>9.9999":U NO-UNDO.
    DEFINE VARIABLE de-valor      AS DECIMAL    FORMAT ">>>,>>>,>>9.9999":U NO-UNDO.
    DEFINE VARIABLE de-quantidade AS DECIMAL    FORMAT ">>>,>>>,>>9.9999":U NO-UNDO.
    DEFINE VARIABLE de-vl-frete   AS DECIMAL    FORMAT ">>>,>>>,>>9.9999":U NO-UNDO.
    DEFINE VARIABLE de-preco-unit AS DECIMAL                                NO-UNDO.
    DEFINE VARIABLE de-desconto   AS DECIMAL                                NO-UNDO.
    DEFINE VARIABLE de-taxa       AS DECIMAL                                NO-UNDO.
    DEFINE VARIABLE h-bosc008calc AS HANDLE                                 NO-UNDO.

    FOR FIRST cotacao-item FIELDS (cod-transp it-codigo numero-ordem pre-unit-for cod-servico data-cotacao int-2 mo-codigo
                                   taxa-financ valor-taxa nr-dias-taxa perc-descto cod-cond-pag codigo-ipi aliquota-ipi cod-emitente)
        WHERE ROWID(cotacao-item) = r-cotacao NO-LOCK: END.

    IF AVAIL cotacao-item THEN DO:

        FOR FIRST ordem-compra FIELDS (cod-estabel numero-ordem)
            WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK: END.

        IF AVAIL ordem-compra THEN DO:

            FOR FIRST item FIELDS (peso-bruto it-codigo)
                WHERE item.it-codigo = cotacao-item.it-codigo NO-LOCK: END.

            IF AVAIL item THEN DO:

                FOR EACH prazo-compra FIELDS (qtd-do-forn)
                   WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                     AND prazo-compra.it-codigo    = item.it-codigo NO-LOCK:

                    ASSIGN de-quantidade = de-quantidade + prazo-compra.qtd-do-forn.
                END.

                ASSIGN de-peso  = de-quantidade * item.peso-bruto
                       de-valor = de-quantidade * cotacao-item.pre-unit-for.
            END.

            IF NOT VALID-HANDLE (h-bosc008calc) THEN
                RUN scbo/bosc008calc.p PERSISTENT SET h-bosc008calc.

            EMPTY TEMP-TABLE tt-cotacao-item-aux.

            CREATE tt-cotacao-item-aux.
            ASSIGN tt-cotacao-item-aux.numero-ordem = cotacao-item.numero-ordem
                   tt-cotacao-item-aux.pre-unit-for = cotacao-item.pre-unit-for
                   tt-cotacao-item-aux.mo-codigo    = cotacao-item.mo-codigo
                   tt-cotacao-item-aux.taxa-financ  = cotacao-item.taxa-financ
                   tt-cotacao-item-aux.valor-taxa   = cotacao-item.valor-taxa
                   tt-cotacao-item-aux.nr-dias-taxa = cotacao-item.nr-dias-taxa
                   tt-cotacao-item-aux.perc-descto  = cotacao-item.perc-descto
                   tt-cotacao-item-aux.valor-descto = cotacao-item.valor-descto
                   tt-cotacao-item-aux.cod-cond-pag = cotacao-item.cod-cond-pag
                   tt-cotacao-item-aux.codigo-ipi   = cotacao-item.codigo-ipi
                   tt-cotacao-item-aux.aliquota-ipi = cotacao-item.aliquota-ipi.

            FOR FIRST emitente FIELDS(cidade estado pais)
                WHERE emitente.cod-emitente = cotacao-item.cod-emitente NO-LOCK: END.

            IF AVAIL emitente THEN
                RUN recebeDadosPolo IN h-bosc008calc (INPUT emitente.cidade,
                                                      INPUT emitente.estado,
                                                      INPUT emitente.pais).

            RUN calculaPrecoUnitarioOC IN h-bosc008calc (INPUT TABLE tt-cotacao-item-aux,
                                                         INPUT cotacao-item.data-cotacao,
                                                         OUTPUT de-preco-unit,
                                                         OUTPUT de-desconto,
                                                         OUTPUT de-taxa).
            EMPTY TEMP-TABLE tt-cotacao-item-aux.

            RUN calculaPrecoMercSemIcmsOC IN h-bosc008calc (INPUT de-preco-unit,
                                                            INPUT de-desconto,
                                                            INPUT de-taxa,
                                                            INPUT RowObject.aliquota-icm,
                                                            INPUT de-quantidade).

            RUN calculaFreteRe IN h-bosc008calc (INPUT ordem-compra.cod-estabel,
                                                 INPUT cotacao-item.cod-transp,
                                                 INPUT NO,
                                                 INPUT 0,
                                                 INPUT cotacao-item.cod-servico,
                                                 INPUT cotacao-item.data-cotacao,
                                                 INPUT de-valor,
                                                 INPUT de-peso,
                                                 OUTPUT c-nome-transp,
                                                 OUTPUT de-vl-frete).

            IF VALID-HANDLE (h-bosc008calc) THEN DO:
                RUN destroy IN h-bosc008calc.
                ASSIGN h-bosc008calc = ?.
            END.
        END.
    END.

    FIND FIRST cotacao-item
         WHERE ROWID(cotacao-item) = r-cotacao EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL cotacao-item THEN
        ASSIGN cotacao-item.valor-frete = de-vl-frete.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaCampoAprovaCompr DBOProgram
PROCEDURE carregaCampoAprovaCompr :
/*------------------------------------------------------------------------------
  Purpose:     Carrega o campo que indica se a cota‡Æo estÿ aprovada.
  Parameters:
               ipar1 : prCotacaoItem : rowid da cotacao-item
               opar2 : plAprovado     : indica a situacao da cotacao (aprovada ou nÆo)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prCotacaoItem AS ROWID      NO-UNDO.
    DEFINE OUTPUT PARAMETER plAprovado    AS LOGICAL    NO-UNDO.

    FOR FIRST cotacao-item FIELDS(log-1 cot-aprovada)
        WHERE ROWID(cotacao-item) = prCotacaoItem  NO-LOCK: END.

    IF AVAIL cotacao-item THEN DO:

        ASSIGN plAprovado = NO.
        IF cotacao-item.log-1 or cotacao-item.cot-aprovada THEN
            ASSIGN plAprovado = YES.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkErrosBrowser DBOProgram
PROCEDURE checkErrosBrowser :
/*------------------------------------------------------------------------------
  Purpose: Verefica :
             1. se  un informada ‚ diferente a item-fornec.unid-med-for. Se for, emite mensagem de erro.
             2. se un informada existe ou nÆo. Se nÆo, emite mensagem erro.
  Parameters:
              ipar1 : pcCotacaoItem : chave da tabela cotacao-item concatenada e mais o pre-unit-for
                      formato: pcCotacaoItem = (numero-ordem,cod-emitente,item,seq-cotac,pre-unit-for).
              ipar2 : pUn           : unid. med. informada pelo usuario.
              ipar3 : pPrecoFornec  : pre‡o fornecedor informado pelo usuario.
              ipar4 : plRelItFor    : Gera relacionamento Item/Fornecedor Automaticamente?
              ipar5 : plReatForn    : Reativa Fornecedor Automaticamente?
              opar6 : pdePreUnitFor : pre‡o unitÿrio do fornecedor
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcCotacaoItem    AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pUn              AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pPrecoFornec     AS DECIMAL     NO-UNDO.
    DEFINE INPUT  PARAMETER plRelItFor       AS LOGICAL     NO-UNDO.
    DEFINE INPUT  PARAMETER plReatForn       AS LOGICAL     NO-UNDO.
    DEFINE INPUT  PARAMETER prProcFornec     AS Rowid       NO-UNDO.
    DEFINE OUTPUT PARAMETER pPrecoUnitFornec AS DECIMAL     NO-UNDO.

    FOR FIRST proc-fornec FIELDS(nr-processo cod-emitente)
        WHERE ROWID(proc-fornec) = prProcFornec NO-LOCK: END.

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    FOR FIRST item FIELDS(it-codigo tipo-contr)
        WHERE item.it-codigo = ENTRY(3,pcCotacaoItem) NO-LOCK: END.

    IF AVAILABLE item THEN DO:

        FOR FIRST item-fornec FIELDS(it-codigo cod-emitente ativo fator-conver num-casa-dec unid-med-for)
            WHERE item-fornec.it-codigo    = ENTRY(3,pcCotacaoItem)
              AND item-fornec.cod-emitente = INT(ENTRY(2,pcCotacaoItem))
              AND item-fornec.ativo          NO-LOCK: END.

        IF item.tipo-contr = 4 AND NOT AVAIL item-fornec THEN DO:

            FOR FIRST cotacao-item FIELDS(numero-ordem cod-emitente it-codigo seq-cotac)
                WHERE cotacao-item.numero-ordem = INT(ENTRY(1,pcCotacaoItem))
                  AND cotacao-item.cod-emitente = INT(ENTRY(2,pcCotacaoItem))
                  AND cotacao-item.it-codigo    = ENTRY(3,pcCotacaoItem)
                  AND cotacao-item.seq-cotac    = INT(ENTRY(4,pcCotacaoItem)) NO-LOCK: END.

            IF AVAIL cotacao-item THEN DO:

                FOR FIRST prazo-compra FIELDS(numero-ordem un)
                    WHERE prazo-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK: END.

                IF pUn <> prazo-compra.un THEN DO:

                    FOR FIRST tab-conv-un FIELDS(un unid-med-for fator-conver num-casa-dec)
                        WHERE tab-conv-un.un           = prazo-compra.un
                          AND tab-conv-un.unid-med-for = pUn NO-LOCK: END.

                    ASSIGN deIndice = IF AVAILABLE tab-conv-un THEN tab-conv-un.fator-conver / EXP(10, tab-conv-un.num-casa-dec)
                                      ELSE 1.
               END.
               ELSE
                   ASSIGN deIndice = 1.
            END.
        END.
        ELSE DO:

            ASSIGN deIndice = IF AVAILABLE item-fornec THEN item-fornec.fator-conver / EXP(10, item-fornec.num-casa-dec)
                              ELSE 1.

            IF AVAIL item-fornec AND pUn <> item-fornec.unid-med-for THEN DO:

                IF AVAIL param-compra AND param-compra.log-multi-unid-medid THEN DO:

                    /*Utiliza M£ltiplas Unidades de Medida
                      Se unidade da item-fornec <> unidade da cota‡Æo, busca fator de conversÆo conforme a unidade da cota‡Æo*/
                    FOR FIRST item-fornec-umd FIELDS(fator-conver num-casa-dec)
                        WHERE item-fornec-umd.it-codigo = item-fornec.it-codigo
                          AND item-fornec-umd.cod-emitente = item-fornec.cod-emitente
                          AND item-fornec-umd.unid-med-for = pUn
                          AND item-fornec-umd.log-ativo NO-LOCK: END.

                    ASSIGN deIndice = IF AVAIL item-fornec-umd THEN item-fornec-umd.fator-conver / EXP(10, item-fornec-umd.num-casa-dec)
                                      ELSE 1.

                    IF NOT AVAIL item-fornec-umd THEN DO:

                        {method/svc/errors/inserr.i &ErrorNumber="51523"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="item-fornec.it-codigo + '~~~~' + string(item-fornec.cod-emitente) + '~~~~' + pUn"}
                    END.
                END.
                ELSE DO:

                    {method/svc/errors/inserr.i &ErrorNumber="2244" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
                END.
            END.

            FOR FIRST item-fornec FIELDS(it-codigo cod-emitente ativo)
                WHERE item-fornec.it-codigo    = item.it-codigo
                  AND item-fornec.cod-emitente = proc-fornec.cod-emitente NO-LOCK: END.

            IF NOT AVAIL item-fornec THEN DO:

                IF plRelItFor THEN DO:

                    FOR FIRST emitente FIELDS(cod-emitente cod-cond-pag)
                        WHERE emitente.cod-emitente = proc-fornec.cod-emitente NO-LOCK: END.

                    CREATE item-fornec.
                    ASSIGN item-fornec.it-codigo    = item.it-codigo
                           item-fornec.cod-emitente = proc-fornec.cod-emitente
                           item-fornec.item-do-forn = item.it-codigo
                           item-fornec.unid-med-for = pUn
                           item-fornec.fator-conver = 1
                           item-fornec.num-casa-dec = 0
                           item-fornec.ativo        = yes
                           item-fornec.cod-cond-pag = emitente.cod-cond-pag
                           item-fornec.classe-repro = 1.

                    RUN criaEPCAfterCreateItemFornec(INPUT STRING(ROWID(item-fornec))).
                END.
            END.
            ELSE DO:

                /** Verifica relacionamento ativo a n¡vel de estabelecimento **/

                FOR FIRST ordem-compra FIELDS(numero-ordem cod-estabel)
                    WHERE ordem-compra.numero-ordem = INT(ENTRY(1,pcCotacaoItem)) NO-LOCK: END.

                IF AVAIL ordem-compra THEN
                    FOR FIRST item-fornec-estab FIELDS(it-codigo cod-emitente cod-estabel ativo)
                        WHERE item-fornec-estab.it-codigo    = item.it-codigo
                          AND item-fornec-estab.cod-emitente = proc-fornec.cod-emitente
                          AND item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel NO-LOCK: END.

                IF AVAIL item-fornec-estab AND item-fornec-estab.ativo = NO AND item-fornec.ativo THEN DO:

                    IF param-compra.perm-cot-for = NO AND plReatForn = NO THEN DO:

                        {method/svc/errors/inserr.i &ErrorNumber="2155" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
                    END.
                    ELSE DO:

                        IF plReatForn THEN DO:

                            FOR FIRST item-fornec-estab FIELDS(it-codigo cod-emitente cod-estabel ativo)
                                WHERE item-fornec-estab.it-codigo    = item.it-codigo
                                  AND item-fornec-estab.cod-emitente = proc-fornec.cod-emitente NO-LOCK: END.

                            IF item-fornec-estab.ativo = NO THEN DO:
                                FIND CURRENT item-fornec-estab EXCLUSIVE-LOCK NO-ERROR.
                                ASSIGN item-fornec-estab.ativo = YES.
                            END.
                        END.
                        ELSE DO:

                            {method/svc/errors/inserr.i &ErrorNumber="2155" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
                        END.
                   END.
                END.

                IF item-fornec.ativo = NO THEN DO:

                    IF param-compra.perm-cot-for = NO AND plReatForn = NO THEN DO:

                        {method/svc/errors/inserr.i &ErrorNumber="2155" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
                    END.
                    ELSE DO:

                        IF plReatForn THEN DO:

                            FOR FIRST item-fornec FIELDS(it-codigo cod-emitente ativo)
                                WHERE item-fornec.it-codigo    = item.it-codigo
                                  AND item-fornec.cod-emitente = proc-fornec.cod-emitente NO-LOCK: END.

                            IF AVAIL item-fornec AND item-fornec.ativo = NO THEN DO:

                                FIND CURRENT item-fornec EXCLUSIVE-LOCK NO-ERROR.
                                ASSIGN item-fornec.ativo = YES.
                            END.
                        END.
                        ELSE DO:

                            {method/svc/errors/inserr.i &ErrorNumber="2155" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
                        END.
                    END.
                END.
            END.
        END.
    END.

    IF NOT CAN-FIND(FIRST tab-unidade
                    WHERE tab-unidade.un = pUn) THEN DO:

        {utp/ut-liter.i "Unidade_Medida" *}

        {method/svc/errors/inserr.i &ErrorNumber="47"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    ASSIGN pPrecoUnitFornec = DEC(ENTRY(5,pcCotacaoItem)) * deIndice.

    IF pPrecoFornec = 0 THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="8542" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createUpdateCotacaoItem DBOProgram
PROCEDURE createUpdateCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:  Inclui e modifica uma cotacao de ordem de compra
  Parameters:
             ipar1  : rowObject        : registro da tabela cotacao-item
             ipar2  : pcItem           : c¢digo do item
             ipar3  : plInclui         : indica se a cota‡Æo estÿ sendo modificada ou inclu¡da
             ipar4  : pcSegUsuario     : c¢digo do usuÿrio corrente
             ipar5  : plItemxFornec    : indica se o relacionamento item x fornecedor serÿ feito
                                          automaticamente
             ipar6  : plFornecInativo  : indica se o fornecedor inativo pode ser reativado
             iopar7 : r-chave          : rowid do registro criado
             opar8  : plIncItemxFornec : indica se deverÿ ser incluido um fornecedor para o item
             opar9  : RowErrors        : tabela que cont‚m os erros
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER TABLE FOR rowObject.
    DEFINE INPUT        PARAMETER pcItem            AS CHARACTER    NO-UNDO.
    DEFINE INPUT        PARAMETER plInclui          AS LOGICAL      NO-UNDO.
    DEFINE INPUT        PARAMETER pcSegUsuario      AS CHARACTER    NO-UNDO.
    DEFINE INPUT        PARAMETER plItemxFornec     AS LOGICAL      NO-UNDO.
    DEFINE INPUT        PARAMETER plFornecInativo   AS LOGICAL      NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER r-chave           AS ROWID        NO-UNDO.
    DEFINE OUTPUT       PARAMETER plIncItemxFornec  AS LOGICAL      NO-UNDO.
    DEFINE OUTPUT       PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE l-exec-api-orcam AS LOGICAL NO-UNDO.

    FIND FIRST rowObject NO-LOCK NO-ERROR.

    IF NOT AVAIL rowObject THEN DO:

        {utp/ut-liter.i "Cota‡Æo_Item" *}

        {method/svc/errors/inserr.i &ErrorNumber="16283"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
        RETURN "NOK":U.
    END.

    FIND FIRST item WHERE item.it-codigo = pcItem NO-LOCK NO-ERROR.

    IF NOT AVAIL ordem-compra THEN

        FOR FIRST ordem-compra FIELDS()
            WHERE ordem-compra.numero-ordem = rowObject.numero-ordem NO-LOCK: END.

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    IF param-compra.utiliza-taxa = NO THEN
        ASSIGN rowObject.taxa-financ  = NO
               rowObject.nr-dias-taxa = 0
               rowObject.valor-taxa   = 0.

    ASSIGN l-preco-bruto = (param-compra.ipi-sobre-preco = 1).

    IF plInclui THEN DO:

        /* Multiplanta */
        IF AVAIL ordem-compra THEN DO:

            RUN ccp/ccapi199.p (INPUT "ordem-compra":U, INPUT ROWID(ordem-compra), OUTPUT lErro).

            IF lErro THEN DO:

                /*Ordem so pode ser alterada no estabelecimento gestor.*/
                {utp/ut-liter.i Ordem}
                ASSIGN c-msg = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Gestor}
                {method/svc/errors/inserr.i &ErrorNumber="18200"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-msg + '~~~~' + trim(return-value)"}
                 RETURN "NOK":U.
            END.
        END.
    END.

    RUN validateFieldsCotacaoItem (INPUT  TABLE rowObject,
                                   INPUT  pcItem,
                                   INPUT  plItemxFornec,
                                   INPUT  pcSegUsuario,
                                   INPUT  plInclui,
                                   INPUT  plFornecInativo,
                                   OUTPUT plIncItemxFornec,
                                   OUTPUT TABLE RowErrors).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    ELSE DO:
        IF plInclui THEN DO:

            FIND FIRST bfcotacao-item
                 WHERE bfcotacao-item.numero-ordem = rowObject.numero-ordem
                   AND bfcotacao-item.it-codigo    = rowObject.it-codigo
                   AND bfcotacao-item.cod-emitente = rowObject.cod-emitente
                   AND bfcotacao-item.seq-cotac    = rowObject.seq-cotac NO-LOCK NO-ERROR.

            IF AVAIL bfcotacao-item THEN DO:

                FIND LAST bfcotacao-item
                    WHERE bfcotacao-item.numero-ordem = rowObject.numero-ordem
                      AND bfcotacao-item.it-codigo    = rowObject.it-codigo
                      AND bfcotacao-item.cod-emitente = rowObject.cod-emitente USE-INDEX cotacao NO-LOCK NO-ERROR.

                ASSIGN rowObject.seq-cotac = bfcotacao-item.seq-cotac + 1.
            END.

            RUN inbo/boin082.p PERSISTENT SET h-boin082.
            RUN setConstraintNumOrdem IN h-boin082 (INPUT rowObject.numero-ordem).
            RUN openQueryStatic IN h-boin082 (INPUT "ByCotacao":U).

            RUN validateCreate IN h-boin082 (INPUT  TABLE rowObject,
                                             OUTPUT TABLE RowErrors APPEND,
                                             OUTPUT r-chave).
            DELETE PROCEDURE h-boin082.
            ASSIGN h-boin082 = ?.
        END.
        ELSE DO:
            RUN inbo/boin082.p PERSISTENT SET h-boin082.
            RUN setConstraintNumOrdem IN h-boin082 (INPUT rowObject.numero-ordem).
            RUN openQueryStatic IN h-boin082 (INPUT "ByCotacao":U).

            RUN validateUpdate IN h-boin082 (INPUT  TABLE rowObject,
                                             INPUT  r-chave,
                                             OUTPUT TABLE RowErrors APPEND).
            DELETE PROCEDURE h-boin082.
            ASSIGN h-boin082 = ?.
        END.
    END.

    /******************* REGISTRO J  GRAVADO *********************/

	/*Elimina erros internos*/
	FOR EACH RowErrors
	   WHERE RowErrors.ErrorType   = "INTERNAL":U
         AND (RowErrors.ErrorNumber = 3 OR
		      RowErrors.ErrorNumber = 8 OR
			  RowErrors.ErrorNumber = 10 OR
			  RowErrors.ErrorNumber = 11):
		DELETE RowErrors.
	END.

    FIND FIRST cotacao-item
         WHERE ROWID(cotacao-item) = r-chave EXCLUSIVE-LOCK NO-ERROR.

    IF plInclui THEN
        ASSIGN cotacao-item.numero-ordem = rowObject.numero-ordem
               cotacao-item.seq-cotac    = rowObject.seq-cotac
               cotacao-item.nr-tab       = IF AVAIL item-tab THEN item-tab.nr-tab ELSE "0":U.

    {cdp/cd9300.i cotacao-item}   /* Calculo de Preco */

    FOR EACH tt-epc WHERE tt-epc.cod-event = "AfterDesconto":U:
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"AfterDesconto"' &CodParameter='"handle"' &ValueParameter="string(this-procedure)"}

    {include/i-epc200.i2 &CodEvent='"AfterDesconto"' &CodParameter='"table"' &ValueParameter='"cotacao-item"'}

    {include/i-epc200.i2 &CodEvent='"AfterDesconto"' &CodParameter='"r-rowid"' &ValueParameter="string(rowid(cotacao-item))"}

    {include/i-epc201.i "AfterDesconto"}

    IF RETURN-VALUE = "NOK":U THEN DO:
        UNDO, RETURN "NOK":U.
    END.

    RUN inbo/boin082ca.p PERSISTENT SET hboin082ca.
    RUN calcIndiceCotacaoItem IN hBoin082ca (INPUT TABLE rowObject,
                                             INPUT  pcItem,
                                             OUTPUT deIndice).
    DELETE PROCEDURE hBoin082ca.
    ASSIGN hBoin082ca = ?.

    /* Execucao Orcamentaria - Financas */
    IF cotacao-item.cot-aprovada THEN DO:

        ASSIGN l-exec-api-orcam = YES.
        /*--- UPC ---*/
        IF  c-nom-prog-dpc-mg97  <> "":U
        OR  c-nom-prog-appc-mg97 <> "":U
        OR  c-nom-prog-upc-mg97  <> "":U THEN DO:

            EMPTY TEMP-TABLE tt-epc.

            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "BOIN082VL_CreateUpdCotItem":U
                   tt-epc.cod-parameter = "Executa_Api_Orcam":U
                   tt-epc.val-parameter = "YES":U.

            {include/i-epc201.i "BOIN082VL_CreateUpdCotItem"}

            FIND FIRST tt-epc
                 WHERE tt-epc.cod-event       = "BOIN082VL_CreateUpdCotItem":U
                   AND   tt-epc.cod-parameter = "Executa_Api_Orcam":U
                   AND   tt-epc.val-parameter = "NO" NO-LOCK NO-ERROR.

            IF AVAILABLE tt-epc THEN
                ASSIGN l-exec-api-orcam = NO.

            EMPTY TEMP-TABLE tt-epc.
        END.

        IF l-exec-api-orcam  THEN
            RUN cdp/cdapi184.p(ROWID(ordem-compra),ROWID(cotacao-item), OUTPUT TABLE rowerrors APPEND).

        IF RETURN-VALUE = "NOK":U THEN DO:
            RETURN "NOK":U.
        END.
    END.
    /* Execucao Orcamentaria - Financas */

    ASSIGN c-seg-usuario              = pcSegUsuario
           cotacao-item.usuario       = {cdp/cd7777.i}
           cotacao-item.data-atualiz  = TODAY
           cotacao-item.hora-atualiz  = STRING(TIME,"hh:mm:ss":U)
           cotacao-item.aprovador     = cAprovador.

    IF l-Integr-Me THEN DO:
        IF CAN-FIND(FIRST ordem-compra-integr-me WHERE ordem-compra-integr-me.numero-ordem = ordem-compra.numero-ordem) THEN
            ASSIGN cotacao-item.preco-unit = cotacao-item.pre-unit-for / deIndice.
        ELSE
            ASSIGN cotacao-item.preco-unit = cotacao-item.pre-unit-for * deIndice.
    END.
    ELSE
       ASSIGN cotacao-item.preco-unit = cotacao-item.pre-unit-for * deIndice.

    FIND FIRST ordem-compra
         WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem EXCLUSIVE-LOCK NO-ERROR.

    IF NOT plInclui AND cotacao-item.cot-aprovada THEN
        ASSIGN lAprovada = YES.

    /* Investimentos */
    IF AVAIL ordem-compra then
        IF plInclui THEN
            RUN integracaoInvestimentosCotacaoItem (input "I":U, INPUT r-chave).
        ELSE
            RUN integracaoInvestimentosCotacaoItem (INPUT "M":U, INPUT r-chave).

    FIND FIRST ordem-compra
         WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL ordem-compra THEN DO:

        ASSIGN ordem-compra.cod-transp = rowObject.cod-transp.

        IF ordem-compra.nr-contrato <> 0 THEN DO:

            FOR FIRST comprador FIELDS(cod-comprado corporativo)
                WHERE comprador.cod-comprado = ordem-compra.cod-comprado NO-LOCK: END.

            IF AVAIL comprador THEN DO:

                IF comprador.corporativo = NO OR param-compra.compra-centr THEN DO:

                    FOR FIRST emitente FIELDS(cod-emitente prog-emit cod-cond-pag)
                        WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK: END.

                    IF AVAIL emitente AND emitente.prog-emit = NO THEN DO:

                        FIND CURRENT emitente EXCLUSIVE-LOCK NO-ERROR.
                        ASSIGN emitente.prog-emit = YES.
                    END.
                END.
            END.
        END.
    END. /* avail ordem-compra */

    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    IF AVAIL param-global AND param-global.modulo-07 THEN
        ASSIGN l-importacao = YES.

    /* Tratamento de campos de importa‡Æo */
    {cdp/cd9300.i rowObject}
    ASSIGN rowObject.preco-unit = rowObject.pre-unit-for.

    FOR FIRST emitente FIELDS(natureza) WHERE emitente.cod-emitente = rowObject.cod-emitente NO-LOCK: END.

    IF  l-importacao
    AND AVAIL emitente
    AND (emitente.natureza = 3 OR emitente.natureza = 4)
    AND NOT plInclui AND (l-recalcula-despesas) THEN DO:

        RUN imp/im9052.p (INPUT "cotacao-item":U, INPUT ROWID(cotacao-item)).
    END.

    FOR EACH b-cot-item
       WHERE b-cot-item.numero-ordem = rowObject.numero-ordem
         AND b-cot-item.it-codigo    = (IF AVAIL item THEN item.it-codigo ELSE "")
         AND b-cot-item.cod-emitente = rowObject.cod-emitente
         AND b-cot-item.data-cotacao = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF EXCLUSIVE-LOCK:

        IF ROWID(b-cot-item) = ROWID(cotacao-item) THEN NEXT.
        DELETE b-cot-item.
    END.

    /*  Integra‡Æo M¢dulo de Importa‡Æo */

    IF plInclui THEN DO:

        IF l-importacao THEN DO:
            RUN validateImportacao (INPUT TABLE rowObject).
        END.

        IF AVAIL ordem-compra AND ordem-compra.situacao = 1 THEN DO:

            ASSIGN ordem-compra.situacao = 5.

            FOR EACH prazo-compra WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:
                ASSIGN prazo-compra.situacao = 5.
            END.
        END.
    END.

    /******************************************************************************************************************/

    FOR EACH tt-epc WHERE tt-epc.cod-event = "AfterDesconto":U:
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"AfterDesconto"' &CodParameter='"hprocedure"' &ValueParameter='"this-procedure"'}

    {include/i-epc200.i2 &CodEvent='"AfterDesconto"' &CodParameter='"nometable"' &ValueParameter='"cotacao-item"'}

    {include/i-epc200.i2 &CodEvent='"AfterDesconto"' &CodParameter='"rowidtable"' &ValueParameter="string(rowid(cotacao-item))"}

    {include/i-epc201.i "AfterDesconto"}

    IF RETURN-VALUE = "NOK":U THEN DO:
        UNDO, RETURN "NOK":U.
    END.

    /* Liberar registro */
    FIND FIRST cotacao-item
         WHERE ROWID(cotacao-item) = r-chave NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTDadosEnv DBOProgram
PROCEDURE criaTTDadosEnv :
/*------------------------------------------------------------------------------
  Purpose: Esse m‚todo cria dados para gera‡Æo dos log's
           para atualiza‡Æo do relacionamento item/fornecedor via multi-planta
  Parameters:
             ipar1 : piTipoMovto : tipo do movimento
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piTipoMovto AS INTEGER NO-UNDO.

    IF param-global.modulo-mp AND tt-replica-msg.log-replica-msg THEN DO:

        CREATE tt-dados-env.
        ASSIGN tt-dados-env.num-sequencia  = i-seq
               tt-dados-env.cod-tipo-reg   = 47
               tt-dados-env.ind-tipo-movto = piTipoMovto
               tt-dados-env.identif-msg    = item-fornec.it-codigo + " , ":U + STRING(item-fornec.cod-emitente).

        RAW-TRANSFER item-fornec TO tt-dados-env.conteudo-msg.
        ASSIGN i-seq = i-seq + 1.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executeCreatePedEmerg DBOProgram
PROCEDURE executeCreatePedEmerg :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER rChave AS ROWID NO-UNDO.

    FIND FIRST rowObject NO-ERROR.

    RUN inbo/boin082.p PERSISTENT SET h-boin082.
    RUN setConstraintNumOrdem IN h-boin082 (INPUT rowObject.numero-ordem).
    run openQueryStatic in h-boin082 (input "ByCotacao":U).

    RUN validateCreate IN h-boin082 (INPUT  TABLE rowObject,
                                     OUTPUT TABLE RowErrors,
                                     OUTPUT rChave).
    DELETE PROCEDURE h-boin082.
    ASSIGN h-boin082 = ?.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    FIND FIRST ordem-compra
         WHERE ordem-compra.numero-ordem = rowObject.numero-ordem EXCLUSIVE-LOCK NO-ERROR.

    ASSIGN ordem-compra.preco-fornec = rowObject.preco-fornec.

    RUN integracaoInvestimentosCotacaoItem (INPUT "I":U, INPUT rChave).

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gravaMotivoAprovaCotacaoItem DBOProgram
PROCEDURE gravaMotivoAprovaCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:     Grava o motivo de aprovacao na tabela cotacao-item
  Parameters:
            ipar1 : peNarrativa    : motivo da aprovacao p/ gravacao
            ipar2 : pcSegUsuario  : nome do usuario corrente
            ipar3 : prCotacaoItem : rowid da tabela cotacao-item
            opar4 : RowErrors     : tabela de erros
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER peNarrativa    AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcSegUsuario   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER prCotacaoItem  AS ROWID     NO-UNDO.
    DEFINE INPUT  PARAMETER piAtualizaData AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors .

    FOR FIRST cotacao-item FIELDS(cod-emitente it-codigo)
        WHERE ROWID(cotacao-item) = prCotacaoItem NO-LOCK: END.

    FOR FIRST item-fornec FIELDS(it-codigo cod-emitente ativo)
        WHERE item-fornec.cod-emitente = cotacao-item.cod-emitente
          AND item-fornec.it-codigo    = cotacao-item.it-codigo
          AND item-fornec.ativo        = yes NO-LOCK: END.

    IF AVAIL item-fornec THEN
        ASSIGN rItemFornec = ROWID(item-fornec).

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    ASSIGN cMotivoApr = peNarrativa.

    RUN ocp/oc0201i.p (INPUT cmotivoapr,
                       INPUT pcSegUsuario,
                       INPUT prCotacaoItem,
                       INPUT piAtualizaData,
                       OUTPUT TABLE RowErrors).

    FIND FIRST param-aprov NO-LOCK NO-ERROR.

    IF param-compra.log-1 AND param-aprov.aprova-cotac THEN
        RUN retornaMensaAprovCotacaoItem (INPUT prCotacaoItem, OUTPUT TABLE rowErrors).

    FOR EACH tt-epc WHERE tt-epc.cod-event = "criaHistSolicGrendene":U:
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"criaHistSolicGrendene"' &CodParameter='"rowid-cotacao"' &ValueParameter="STRING(prCotacaoItem)"}

    {include/i-epc201.i "criaHistSolicGrendene"}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gravaReajusteCotacao DBOProgram
PROCEDURE gravaReajusteCotacao :
/*------------------------------------------------------------------------------
  Purpose: Grava dados refentes ao Reajuste da Cota‡Æo.
  Parameters: ipar1  : prCotacao      : Rowid da Cota‡Æo.
              ipar2  : pdtPrecoBase   : Data do Pre‡o Base.
              ipar3  : piMoCodigo1    : Moeda1 da Cota‡Æo.
              ipar4  : piMoCodigo2    : Moeda2 da Cota‡Æo.
              ipar5  : piMoCodigo3    : Moeda3 da Cota‡Æo.
              ipar6  : piMoCodigo4    : Moeda4 da Cota‡Æo.
              ipar7  : piMoCodigo5    : Moeda5 da Cota‡Æo.
              ipar8  : ppercReaj1     : Percentual1 do Reajuste de Cota‡Æo.
              ipar9  : ppercReaj2     : Percentual2 do Reajuste de Cota‡Æo.
              ipar10 : ppercReaj3     : Percentual3 do Reajuste de Cota‡Æo.
              ipar11 : ppercReaj4     : Percentual4 do Reajuste de Cota‡Æo.
              ipar12 : ppercReaj5     : Percentual5 do Reajuste de Cota‡Æo.
              ipar13 : pdaDataIndice1 : Data ™ndice1 da Cota‡Æo.
              ipar14 : pdaDataIndice2 : Data ™ndice2 da Cota‡Æo.
              ipar15 : pdaDataIndice3 : Data ™ndice3 da Cota‡Æo.
              ipar16 : pdaDataIndice4 : Data ™ndice4 da Cota‡Æo.
              ipar17 : pdaDataIndice5 : Data ™ndice5 da Cota‡Æo.
              opar18 : RowErrors      : Tabela de erros
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prCotacao       AS ROWID            NO-UNDO.
    DEFINE INPUT  PARAMETER pdtPrecoBase    AS DATE             NO-UNDO.
    DEFINE INPUT  PARAMETER piMoCodigo1     AS INTEGER          NO-UNDO.
    DEFINE INPUT  PARAMETER piMoCodigo2     AS INTEGER          NO-UNDO.
    DEFINE INPUT  PARAMETER piMoCodigo3     AS INTEGER          NO-UNDO.
    DEFINE INPUT  PARAMETER piMoCodigo4     AS INTEGER          NO-UNDO.
    DEFINE INPUT  PARAMETER piMoCodigo5     AS INTEGER          NO-UNDO.
    DEFINE INPUT  PARAMETER ppercReaj1      AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER ppercReaj2      AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER ppercReaj3      AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER ppercReaj4      AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER ppercReaj5      AS DECIMAL          NO-UNDO.
    DEFINE INPUT  PARAMETER pdaDataIndice1  AS DATE             NO-UNDO.
    DEFINE INPUT  PARAMETER pdaDataIndice2  AS DATE             NO-UNDO.
    DEFINE INPUT  PARAMETER pdaDataIndice3  AS DATE             NO-UNDO.
    DEFINE INPUT  PARAMETER pdaDataIndice4  AS DATE             NO-UNDO.
    DEFINE INPUT  PARAMETER pdaDataIndice5  AS DATE             NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors  .


    ASSIGN iMoAux[1]    = piMoCodigo1
           iMoAux[2]    = piMoCodigo2
           iMoAux[3]    = piMoCodigo3
           iMoAux[4]    = piMoCodigo4
           iMoAux[5]    = piMoCodigo5
           dePercAux[1] = ppercReaj1
           dePercAux[2] = ppercReaj2
           dePercAux[3] = ppercReaj3
           dePercAux[4] = ppercReaj4
           dePercAux[5] = ppercReaj5
           daReajAux[1] = pdaDataIndice1
           daReajAux[2] = pdaDataIndice2
           daReajAux[3] = pdaDataIndice3
           daReajAux[4] = pdaDataIndice4
           daReajAux[5] = pdaDataIndice5.

    FOR FIRST cotacao-item FIELDS(it-codigo cod-emitente numero-ordem)
        WHERE ROWID(cotacao-item) = prCotacao NO-LOCK: END.

    ASSIGN deTotPerc = 0.

    DO iContAux = 1 TO 5:

        ASSIGN iMoeda    = iMoAux[iContAux]
               dePerc    = dePercAux[iContAux]
               deTotPerc = deTotPerc + dePerc.

        IF iMoeda <> 0 THEN DO:

            IF NOT CAN-FIND(FIRST moeda WHERE moeda.mo-codigo = iMoeda) THEN DO:

                {utp/ut-liter.i "Moeda" *}
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
            IF dePerc = 0 THEN DO:

                {method/svc/errors/inserr.i &ErrorNumber="1548" &ErrorType="EMS" &ErrorSubType="ERROR"}
            END.
        END.
        ELSE DO:

            IF dePerc <> 0 THEN DO:

                {method/svc/errors/inserr.i &ErrorNumber="3617" &ErrorType="EMS" &ErrorSubType="ERROR"}
            END.
        END.
    END.

    IF deTotPerc > 100 THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="2208" &ErrorType="EMS" &ErrorSubType="ERROR"}
    END.

    IF deTotPerc < 100 THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="16928" &ErrorType="EMS" &ErrorSubType="ERROR"}
    END.

    IF cotacao-item.numero-ordem = ? THEN
        FIND FIRST cota-item-reaj
             WHERE cota-item-reaj.it-codigo    = cotacao-item.it-codigo
               AND cota-item-reaj.numero-ordem = 0
               AND cota-item-reaj.cod-emitente = cotacao-item.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
    ELSE
        FIND FIRST cota-item-reaj
             WHERE cota-item-reaj.it-codigo    = cotacao-item.it-codigo
               AND cota-item-reaj.numero-ordem = cotacao-item.numero-ordem
               AND cota-item-reaj.cod-emitente = cotacao-item.cod-emitente EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL cota-item-reaj THEN DO:

        CREATE cota-item-reaj.
        ASSIGN cota-item-reaj.it-codigo    = cotacao-item.it-codigo
               cota-item-reaj.numero-ordem = IF cotacao-item.numero-ordem = ? THEN 0 ELSE cotacao-item.numero-ordem
               cota-item-reaj.cod-emitente = cotacao-item.cod-emitente
               cota-item-reaj.data-cotacao = pdtPrecoBase.
    END.

    ASSIGN iCont                        = 0
           iMoAux2                      = 0
           iCont                        = 0
           cota-item-reaj.mo-codigo     = 0
           cota-item-reaj.data-indice   = ?
           cota-item-reaj.perc-reaj     = 0
           cota-item-reaj.dt-preco-base = pdtPrecoBase.

    DO iContAux = 1 TO 5:
        IF iMoAux[iContAux] <> 0 THEN DO:

            ASSIGN iCont                             = iCont + 1
                   cota-item-reaj.mo-codigo[iCont]   = iMoAux[iContAux]
                   cota-item-reaj.data-indice[iCont] = daReajAux[iContAux]
                   cota-item-reaj.perc-reaj[iCont]   = dePercAux[iContAux].
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitaBotaoAprovCotacaoItem DBOProgram
PROCEDURE habilitaBotaoAprovCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:  Habilita ou nÆo o botao de aprovacao do cotacao do item
  Parameters:
            ipar1 : prCotacaoItem : rowid da tabela cotacao-item
            opar2 : pcAprovada    : indica se o botao ficarÿ ou nÆo habilitado
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prCotacaoItem  AS ROWID     NO-UNDO.
    DEFINE INPUT  PARAMETER c-button       AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcAprovada     AS CHARACTER NO-UNDO.

    DEFINE VARIABLE l-apr-eletr AS LOGICAL INITIAL YES NO-UNDO.
    DEFINE VARIABLE l-apr-cotac AS LOGICAL INITIAL YES NO-UNDO.
    DEFINE VARIABLE l-cotac-apr AS LOGICAL INITIAL YES NO-UNDO.

    FOR FIRST cotacao-item FIELDS(log-1 cot-aprovada)
        WHERE ROWID(cotacao-item) = prCotacaoItem NO-LOCK: END.

    IF AVAIL cotacao-item THEN DO:

        /** Valida se estÿ setado o par³matro Aprova‡Æo Eletr“nica **/
        FIND FIRST param-compra NO-LOCK NO-ERROR.

        IF AVAIL param-compra THEN DO:

            IF param-compra.log-1 THEN
                IF NOT(cotacao-item.log-1) THEN
                    ASSIGN l-apr-eletr = YES.
                ELSE
                    ASSIGN l-apr-eletr = NO.
            ELSE
                ASSIGN l-apr-eletr = YES.
        END.

        /** Valida se estÿ setado para aprovar Cota‡Æo **/
        FIND FIRST param-aprov NO-LOCK NO-ERROR.

        IF AVAIL param-aprov THEN DO:

            IF param-aprov.aprova-cotac THEN
                ASSIGN l-apr-cotac = YES.
            ELSE
                ASSIGN l-apr-cotac = NO.
        END.

        /** Valida se a cota‡Æo jÿ nÆo estÿ aprovada. Nesse caso, apenas informa-se a narrativa **/
        IF cotacao-item.cot-aprovada OR cotacao-item.log-1 THEN
            ASSIGN l-cotac-apr = YES.     /* jÿ estÿ aprovada */
        ELSE
            ASSIGN l-cotac-apr = NO.
    END.

    IF c-button = "aprova":U THEN DO:

        IF l-apr-eletr AND l-apr-cotac AND NOT(l-cotac-apr) THEN DO:
            /* faz aprova‡Æo eletr“nica e chama wcc0303h habilitado */
            ASSIGN pcAprovada = "yes":U.
        END.
        IF NOT(l-apr-eletr) OR NOT(l-apr-cotac) THEN DO:
           /* nÆo faz a aprova‡Æo eletr“nica mas chama-se a tela wcc0303h habilitada */
            ASSIGN pcAprovada = "no":U.
        END.
        IF l-cotac-apr THEN DO:
            /* o wcc0303h nÆo ‚ chamado e exibe msg de erro, pois a cota‡Æo jÿ estÿ aprovada */
            {method/svc/errors/inserr.i &ErrorNumber="6003" &ErrorType="EMS" &ErrorSubType="ERROR"}
        END.
    END.

    IF c-button = "motivo":U THEN DO:

        IF NOT(l-cotac-apr) THEN DO:
            /* o wcc0303h nÆo ‚ chamado e exibe msg de erro, pois a cota‡Æo nÆo estÿ aprovada */
            {method/svc/errors/inserr.i &ErrorNumber="6003" &ErrorType="EMS" &ErrorSubType="ERROR"}
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE integracaoInvestimentosCotacaoItem DBOProgram
PROCEDURE integracaoInvestimentosCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose: Leva valores da Ordem Compra p/ controle de verbas no Investimento
  Parameters:
             ipar1 : pcOpcao       : indica a opera‡Æo (I-Incluir , M-Modificar
                                     ou E-Excluir)
             ipar2 : prCotacaoItem : rowid do registro da cotacao-item
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcOpcao          AS CHARACTER FORMAT "x(2)":U   NO-UNDO.
    DEFINE INPUT PARAMETER prCotacaoItem    AS ROWID                       NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF NOT param-global.modulo-in THEN RETURN "OK":U.

    FOR FIRST cotacao-item FIELDS(numero-ordem)
        WHERE ROWID(cotacao-item) = prCotacaoItem NO-LOCK: END.

    FOR FIRST ordem-compra FIELDS(numero-ordem num-ord-inv num-pedido)
        WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK: END.

    IF AVAIL cotacao-item AND AVAIL ordem-compra THEN DO:

        IF ordem-compra.num-ord-inv <> 0 THEN DO:

            // Quando cota‡Æo vier do ME e ordem sem pedido nÆo atualiza investimentos
            IF  l-Integr-Me
            AND CAN-FIND(FIRST ordem-compra-integr-me NO-LOCK WHERE ordem-compra-integr-me.numero-ordem = ordem-compra.numero-ordem)
            AND ordem-compra.num-pedido = 0 THEN
                RETURN "OK":U.

            IF pcOpcao="I":U THEN DO:

                RUN ivbo/boiv011.p PERSISTENT SET h-boiv011.
                RUN UpdateCotacaoInv IN h-boiv011 (INPUT ROWID(cotacao-item), INPUT-OUTPUT TABLE RowErrors).

                DELETE PROCEDURE h-boiv011.
                ASSIGN h-boiv011 = ?.
           END.
           ELSE DO:

               RUN ivbo/boiv011.p PERSISTENT SET h-boiv011.
               RUN UpdateCotacaoInv IN h-boiv011 (INPUT ROWID(cotacao-item), INPUT-OUTPUT TABLE RowErrors).

               DELETE PROCEDURE h-boiv011.
               ASSIGN h-boiv011 = ?.
           END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE motivoAprovaCotacaoItem DBOProgram
PROCEDURE motivoAprovaCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose: Retorna o motivo de aprovacao de uma cotacao do item se a cotacao jÿ estiver
           aprovada, ou grava o motivo de aprovacao se a cotacao do item estiver pendente de
           aprovacao.
  Parameters:
             ipar1 : prCotacaoItem   : rowid da cotacao do item a ser aprovada ou consultada
             ipar2 : plAprovaMotivo  : indica se serÿ consulta ou gravacao
             ipar3 : plOrdemCotada   : indica se aprova (ou nÆo) cota‡„es para ordens jÿ cotadas
             ipar4 : plFornecInativo : indica se o fornecedor estÿ ou nÆo inativo
             opar5 : peNarrativa     : descricao da narrativa se for uma consulta
             opar6 : RowErrors       : tabela de erros

  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prCotacaoItem   AS ROWID        NO-UNDO.
    DEFINE INPUT  PARAMETER plAprovaMotivo  AS LOGICAL      NO-UNDO.
    DEFINE INPUT  PARAMETER plOrdemCotada   AS LOGICAL      NO-UNDO.
    DEFINE INPUT  PARAMETER plFornecInativo AS LOGICAL      NO-UNDO.
    DEFINE OUTPUT PARAMETER peNarrativa     AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE c-lotacao AS CHARACTER NO-UNDO.
    DEFINE VARIABLE h-boin772 AS HANDLE    NO-UNDO.

    FIND FIRST param-aprov NO-LOCK NO-ERROR.

    FOR FIRST cotacao-item FIELDS(cod-emitente it-codigo numero-ordem preco-unit cod-comprado log-1 mo-codigo narrativa data-cotacao)
        WHERE ROWID(cotacao-item) = prCotacaoItem NO-LOCK: END.

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    /* Aprova Compras */
    IF plAprovaMotivo THEN DO:

        IF AVAIL cotacao-item THEN DO:

            IF param-compra.log-1 AND param-aprov.aprova-cotac THEN DO:

                ASSIGN lRetorno = NO.
                RUN cdp/cdapi173.p (INPUT  3,
                                    INPUT  cotacao-item.it-codigo,
                                    INPUT  cotacao-item.cod-comprado,
                                    OUTPUT lRetorno).

                RUN lap/mlaapi099.p (INPUT 0).

                IF CAN-FIND(FIRST funcao
                            WHERE funcao.cd-funcao = "Integra_MLA_EMS":U
                              AND funcao.ativo     = YES) AND RETURN-VALUE <> "NOK":U THEN DO:

                    FIND FIRST ordem-compra
                         WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK NO-ERROR.

                   /* Calculo do Valor da Cota‡Æo */
                   IF cotacao-item.mo-codigo = 0 THEN
                       ASSIGN de-cotacao-moeda = 1.
                   ELSE DO:

                       RUN cdp/cd0812.p (INPUT  cotacao-item.mo-codigo,
                                         INPUT  0,
                                         INPUT  1,
                                         INPUT  cotacao-item.data-cotacao,
                                         OUTPUT de-cotacao-moeda).
                       IF de-cotacao-moeda = ? THEN
                           ASSIGN de-cotacao-moeda = 1.
                   END.

                   IF AVAIL pedido-compr AND pedido-compr.cod-estab-gestor <> "" THEN
                       ASSIGN c-estabelecimento = pedido-compr.cod-estab-gestor.
                   ELSE
                       ASSIGN c-estabelecimento = ordem-compra.cod-estabel.
                   /* Fim Calculo */

                   ASSIGN de-valor-item = ordem-compra.qt-solic * cotacao-item.preco-unit * de-cotacao-moeda
                          de-valor-total = de-valor-item.

                   /*Verifica se ‚ solicita‡Æo de cota‡Æo*/
                   ASSIGN i-tp-doc = 3.

                   IF AVAIL ordem-compra THEN DO:

                       IF ordem-compra.nr-requisicao <> 0 THEN DO:
                           FIND FIRST requisicao
                                WHERE requisicao.nr-requisicao = ordem-compra.nr-requisicao NO-LOCK NO-ERROR.
                           IF AVAIL requisicao AND requisicao.tp-requis = 3 THEN
                               ASSIGN i-tp-doc = 5.
                       END.
                   END.

                   IF i-tp-doc = 3 THEN DO: /*Cota‡Æo*/
                       /*BO mla-lotacao*/
                       RUN inbo/boin772.p PERSISTENT SET h-boin772.
                       RUN buscaLotacaoUsuarOrig IN h-boin772(INPUT 5, /*Cota‡Æo - C¢digo no MLA*/
                                                              INPUT ordem-compra.nr-requisicao,
                                                              INPUT cotacao-item.cod-comprado,
                                                              OUTPUT c-lotacao).

                       IF c-lotacao = "" THEN
                           ASSIGN c-lotacao = ordem-compra.sc-codigo.

                       IF VALID-HANDLE(h-boin772) THEN DO:
                           DELETE PROCEDURE h-boin772.
                           ASSIGN h-boin772 = ?.
                       END.

                   END.
                   ELSE
                       ASSIGN c-lotacao = ordem-compra.sc-codigo.

                   RUN lap/mlaapi173.p (INPUT i-tp-doc,
                                        INPUT cotacao-item.it-codigo,
                                        INPUT cotacao-item.cod-comprado,
                                        INPUT ordem-compra.ct-codigo,
                                        INPUT "",
                                        INPUT c-lotacao,
                                        INPUT de-valor-item,
                                        INPUT de-valor-total,
                                        INPUT c-estabelecimento,
                                        OUTPUT TABLE tt-erro).

                   IF RETURN-VALUE = "NOK":U THEN DO:
                       FIND FIRST tt-erro NO-ERROR.
                       IF AVAIL tt-erro THEN DO:

                           {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                                       &ErrorType="EMS"
                                                       &ErrorSubType="ERROR"
                                                       &ErrorParameters="tt-erro.c-param"}
                           RETURN "NOK":U.
                       END.
                   END.
                END.

                IF NOT lRetorno THEN DO:

                    {method/svc/errors/inserr.i &ErrorNumber="15661" &ErrorType="EMS" &ErrorSubType="ERROR"}
                END.
            END.

            FOR FIRST ordem-compra FIELDS(numero-ordem nr-processo cod-estabel)
                WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK: END.

            IF AVAIL ordem-compra AND ordem-compra.nr-processo <> 0 THEN DO:

                IF CAN-FIND(FIRST proc-fornec
                            WHERE proc-fornec.nr-processo  = ordem-compra.nr-processo
                              AND proc-fornec.cod-emitente = cotacao-item.cod-emitente NO-LOCK) = NO THEN DO:

                    {method/svc/errors/inserr.i &ErrorNumber="2147" &ErrorType="EMS" &ErrorSubType="ERROR"}
                END.
            END.

            ASSIGN prCotacaoItem = ROWID(cotacao-item).

            FOR FIRST item-fornec
                WHERE item-fornec.cod-emitente = cotacao-item.cod-emitente
                  AND item-fornec.it-codigo    = cotacao-item.it-codigo NO-LOCK:

                ASSIGN rItemFornec = ROWID(item-fornec).
            END.

            FIND FIRST param-compra NO-LOCK NO-ERROR.

            ASSIGN lHabilita = NO.

            IF AVAIL item-fornec THEN DO:

                IF item-fornec.ativo = NO AND param-compra.perm-cot-for = NO THEN DO:

                    {method/svc/errors/inserr.i &ErrorNumber="2155" &ErrorType="EMS" &ErrorSubType="ERROR"}
                END.
                ELSE DO:

                    IF AVAIL ordem-compra THEN
                        FOR FIRST item-fornec-estab FIELDS(cod-emitente it-codigo cod-estabel ativo)
                            WHERE item-fornec-estab.cod-emitente = cotacao-item.cod-emitente
                              AND item-fornec-estab.it-codigo    = cotacao-item.it-codigo
                              AND item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel NO-LOCK: END.

                    IF AVAIL item-fornec-estab THEN DO:

                        IF item-fornec-estab.ativo = NO AND param-compra.perm-cot-for = NO THEN DO:

                            {method/svc/errors/inserr.i &ErrorNumber="2155" &ErrorType="EMS" &ErrorSubType="ERROR"}
                        END.
                        ELSE DO:

                            IF item-fornec-estab.ativo = NO THEN DO:

                                IF plFornecInativo THEN DO:

                                    FIND CURRENT item-fornec-estab EXCLUSIVE-LOCK NO-ERROR.
                                    ASSIGN item-fornec-estab.ativo = YES
                                           lHabilita               = YES.
                                END.
                                ELSE DO:
                                    {method/svc/errors/inserr.i &ErrorNumber="7514" &ErrorType="EMS" &ErrorSubType="ERROR"}
                                END.
                            END.
                            ELSE
                                ASSIGN lHabilita = YES.
                        END.
                    END.
                    ELSE
                        ASSIGN lHabilita = YES.

                    IF item-fornec.ativo = NO THEN DO:
                        IF plFornecInativo THEN
                            ASSIGN item-fornec.ativo = YES
                                    lHabilita        = YES.
                        ELSE DO:
                            {method/svc/errors/inserr.i &ErrorNumber="7514" &ErrorType="EMS" &ErrorSubType="ERROR"}
                        END.
                    END.
                    ELSE
                        ASSIGN lHabilita = YES.
                END.
            END.
            ELSE
                ASSIGN lHabilita = YES.
        END.
    END.
    ELSE DO: /* Motivo Aprova‡Æo */

        ASSIGN lHabilita = YES.
        IF AVAIL cotacao-item THEN DO:

            FIND FIRST ordem-compra
                 WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL ordem-compra THEN
                ASSIGN ordem-compra.cod-comprado = cotacao-item.cod-comprado.

            RELEASE ordem-compra.

            ASSIGN prCotacaoItem = ROWID(cotacao-item).

            IF prCotacaoItem <> ? THEN
                IF AVAIL cotacao-item THEN DO:

                    IF cotacao-item.cot-aprovada THEN
                        ASSIGN peNarrativa = cotacao-item.motivo-apr.
                    ELSE
                        IF cotacao-item.log-1 THEN
                            ASSIGN peNarrativa = cotacao-item.narrativa .
                END.
        END.
    END.

    IF lHabilita THEN DO:

        IF param-compra.log-1 AND param-aprov.aprova-cotac THEN
            FOR FIRST b-cotacao-item FIELDS(cod-emitente it-codigo numero-ordem cod-comprado log-1 narrativa)
                WHERE b-cotacao-item.numero-ordem = cotacao-item.numero-ordem
                  AND b-cotacao-item.it-codigo    = cotacao-item.it-codigo
                  AND b-cotacao-item.log-1        = YES NO-LOCK: END.
        ELSE
            FOR FIRST b-cotacao-item FIELDS(cod-emitente it-codigo numero-ordem cod-comprado log-1 narrativa)
                WHERE b-cotacao-item.numero-ordem = cotacao-item.numero-ordem
                  AND b-cotacao-item.it-codigo    = cotacao-item.it-codigo
                  AND b-cotacao-item.cot-aprovada = YES NO-LOCK: END.

        IF AVAIL b-cotacao-item AND ROWID(b-cotacao-item) <> prCotacaoItem THEN DO:

            IF param-compra.log-1 AND param-aprov.aprova-cotac THEN DO:

                IF plOrdemCotada = NO THEN DO:

                    {method/svc/errors/inserr.i &ErrorNumber="16244" &ErrorType="EMS" &ErrorSubType="ERROR"}
                END.
            END.
            ELSE DO:

                IF plOrdemCotada = NO THEN DO:

                    {method/svc/errors/inserr.i &ErrorNumber="16244" &ErrorType="EMS" &ErrorSubType="ERROR"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByordem DBOProgram
PROCEDURE openQueryByordem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName}
                               WHERE {&TableName}.numero-ordem = iNumOrdem  NO-LOCK INDEXED-REPOSITION.

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
    OPEN QUERY {&QueryName} FOR EACH cotacao-item NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-aprova DBOProgram
PROCEDURE pi-aprova :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  Aprova cota‡Æo
  Notes:
------------------------------------------------------------------------------*/

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    FIND FIRST cotacao-item WHERE ROWID(cotacao-item) = gr-cotacao-item NO-LOCK NO-ERROR.

    IF AVAIL cotacao-item THEN
        FIND FIRST b-cotacao-item
             WHERE b-cotacao-item.numero-ordem = cotacao-item.numero-ordem
               AND b-cotacao-item.it-codigo    = cotacao-item.it-codigo
               AND b-cotacao-item.log-1        = YES NO-LOCK NO-ERROR.

    IF AVAIL b-cotacao-item AND ROWID(b-cotacao-item) <> gr-cotacao-item THEN DO:

        IF param-compra.log-1 THEN DO:

            RUN cdp/cdapi171.p (3,3,ROWID(b-cotacao-item)).

            FIND FIRST ordem-compra
                 WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem  EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL ordem-compra THEN DO:

                ASSIGN ordem-compra.situacao     = 5
                       ordem-compra.data-cotacao = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF
                       ordem-compra.pre-unit-for = 0
                       ordem-compra.preco-fornec = 0
                       ordem-compra.mo-codigo    = 0
                       ordem-compra.cod-cond-pag = 0
                       ordem-compra.contato      = ""
                       ordem-compra.cod-comprado = cotacao-item.cod-comprado
                       ordem-compra.preco-unit   = 0
                       ordem-compra.preco-orig   = 0.

                FOR EACH prazo-compra
                   WHERE prazo-compra.numero-ordem = cotacao-item.numero-ordem EXCLUSIVE-LOCK:

                    ASSIGN prazo-compra.situacao = 5.
                END.
            END.
        END.

        FIND FIRST cotacao-item
             WHERE ROWID(cotacao-item) = ROWID(b-cotacao-item) EXCLUSIVE-LOCK NO-ERROR.

        ASSIGN cotacao-item.cot-aprovada = NO
               cotacao-item.motivo-apr   = ""
               cotacao-item.log-1        = NO.
    END.

    IF param-compra.log-1 THEN DO:

        /* Aprova‡Æo Eletr“nica */
        ASSIGN gr-cotacao-item = ROWID(cotacao-item).

        RUN pi-efetivaAprovacaoEletr.

        IF RETURN-VALUE = "NOK" THEN RETURN "OK":U.
    END.
    ELSE DO:
        FIND FIRST cotacao-item
             WHERE ROWID(cotacao-item) = gr-cotacao-item EXCLUSIVE-LOCK NO-ERROR.

        {ocp/oc0205.i}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-item-fornec DBOProgram
PROCEDURE pi-cria-item-fornec :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
        /*Se a unidade de medida do item for diferente da unidade de medida do fornecedor
          deverá ser verificado se existe um fator de conversao cadastrado para estas duas
          unidades de medida. Caso existir deverá criar a unidade de medida do fornecedor
          utilizando o fator de conversao informado no cadastro de fatores de conversao.
          Exemplo:
          Unidade de medida do item:       UN - Unidade
          Unidade de medida do fornecedor: CX - Caixa de 12 unidades
          Relacionamento item-fornec será criado com a unidade de medida = "CX", fator de
          conversao = "8333333" e numero de casas decimais = "8"                            */

    IF CAN-FIND(FIRST item-fornec
                WHERE item-fornec.it-codigo      = item.it-codigo
                  AND   item-fornec.cod-emitente = emitente.cod-emitente) THEN DO:

        RETURN "OK":U.
    END.

    IF NOT AVAIL param-compra THEN
        FIND FIRST param-compra NO-LOCK NO-ERROR.

    /* param-compra.char-2,136,1 -> Sugere Fator de Conv. Gera»’o Item/Fornec */
    IF SUBSTRING(param-compra.char-2,136,1) <> "S":U AND item.un <> rowobject.un THEN
         RETURN "NOK":U.

    CREATE item-fornec.
    ASSIGN item-fornec.it-codigo    = item.it-codigo
           item-fornec.cod-emitente = emitente.cod-emitente
           item-fornec.item-do-forn = item.it-codigo
           item-fornec.ativo        = YES
           item-fornec.cod-cond-pag = emitente.cod-cond-pag
           item-fornec.classe-repro = 1.

    ASSIGN l-sugeriu-fator-conver = YES
           item-fornec.unid-med-for = rowobject.un
           item-fornec.fator-conver = 1
           item-fornec.num-casa-dec = 0.

    IF SUBSTRING(param-compra.char-2,136,1) = "S":U AND rowObject.un <> ITEM.un  THEN DO:

        FOR FIRST item-unid-compra FIELDS(cdd-fator-conver nr-casa-dec)
            WHERE item-unid-compra.it-codigo = item.it-codigo
            AND   item-unid-compra.un        = rowObject.un NO-LOCK: END.

        IF AVAIL item-unid-compra THEN DO:
            /* busca fator de conversÆo do cc0106 */
            ASSIGN item-fornec.fator-conver = item-unid-compra.cdd-fator-conver
                   item-fornec.num-casa-dec = item-unid-compra.nr-casa-dec.
        END.
        ELSE DO:
            /* busca fator de conversÆo do cd0902 */
            FOR FIRST tab-conv-un FIELDS (fator-conver num-casa-dec)
                WHERE tab-conv-un.un = item.un
                  AND tab-conv-un.unid-med-for = rowObject.un NO-LOCK:

                ASSIGN item-fornec.fator-conver = tab-conv-un.fator-conver
                       item-fornec.num-casa-dec = tab-conv-un.num-casa-dec.
            END.
        END.
    END.

    RUN criaEPCAfterCreateItemFornec(INPUT string(rowid(item-fornec))).

    /*********** Multi-Planta **************/
    ASSIGN cTransacao = "MAT001".
    {cdp/cd7300.i5 "001" cTransacao}
    ASSIGN i-tipo-movto = 1.
    RUN criaTTDadosEnv (INPUT i-tipo-movto).
    /********** Fim Multi-Planta ***********/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-efetivaAprovacaoEletr DBOProgram
PROCEDURE pi-efetivaAprovacaoEletr :
/*------------------------------------------------------------------------------
  Purpose:     Aprova‡Æo Eletr“nica
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    DEFINE VARIABLE h-mlaapi014 AS HANDLE NO-UNDO.

    /*  Aprova‡Æo Eletr“nica / quando for processo a cdapi171 estÿ validando */

    RUN cdp/cdapi171.p (7,2,gr-cotacao-item).
    RUN cdp/cdapi172.p (7,gr-cotacao-item, OUTPUT lpendente).

    FIND FIRST cotacao-item WHERE ROWID(cotacao-item) = gr-cotacao-item EXCLUSIVE-LOCK NO-ERROR.

    IF NOT lPendente THEN DO:

        {ocp/oc0205.i}
    END.
    ELSE DO:

        IF AVAIL ordem-compra AND ordem-compra.situacao = 3 THEN DO:

            ASSIGN ordem-compra.situacao     = 5
                   ordem-compra.data-cotacao = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF
                   ordem-compra.pre-unit-for = 0
                   ordem-compra.preco-fornec = 0
                   ordem-compra.mo-codigo    = 0
                   ordem-compra.cod-cond-pag = 0
                   ordem-compra.contato      = ""
                   ordem-compra.preco-unit   = 0
                   ordem-compra.preco-orig   = 0.

            FOR EACH prazo-compra
               WHERE prazo-compra.numero-ordem = cotacao-item.numero-ordem EXCLUSIVE-LOCK:

                ASSIGN prazo-compra.situacao       = ordem-compra.situacao
                       prazo-compra.qtd-do-forn    = 0
                       prazo-compra.qtd-sal-forn   = 0
                       prazo-compra.qtd-a-ped-forn = 0.
            END.
        END.
    END.

    ASSIGN cotacao-item.log-1     = YES
           cotacao-item.narrativa = gc-motivo-apr.

    RUN retornaMensaAprovCotacaoItem (INPUT ROWID(cotacao-item), OUTPUT TABLE RowErrors).

    /* Atualiza dados da integra‡Æo com o Fluig */

    IF NOT VALID-HANDLE(h-mlaapi014) THEN
        RUN lap/mlaapi014.p PERSISTENT SET h-mlaapi014.
    RUN setUseDBOOnly IN h-mlaapi014(INPUT YES).
    RUN setHandleFluig IN h-mlaapi014.
    IF AVAIL cotacao-item THEN
        RUN updateApprovedQuoteDetails IN h-mlaapi014(INPUT ROWID(cotacao-item)).

    IF VALID-HANDLE(h-mlaapi014) THEN DO:
        RUN unsetHandleFluig IN h-mlaapi014.
        DELETE PROCEDURE h-mlaapi014.
        ASSIGN h-mlaapi014 = ?.
    END.
    /** Fim Atualiza‡Æo Fluig **/

    RELEASE cotacao-item.
    RELEASE ordem-compra.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE replicaCotacaoItem DBOProgram
PROCEDURE replicaCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose: Este m‚todo serve para incluir a mesma cota‡Æo que se estÿ acabando de
           incluir  para ordens de compra pendentes de cota‡Æo do mesmo item.
           Ou seja, replica a cota‡Æo para todas as ordens pendentes do mesmo item.

  Parameters:
             ipar1 : prCotacaoItem : rowid do registro cotacao-item corrente
             ipar2 : plMultipla    : indica se ‚ multiplas ordens
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prCotacaoItem AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER plMultipla    AS LOG   NO-UNDO.

    FIND FIRST cotacao-item
         WHERE ROWID(cotacao-item) = prCotacaoItem NO-LOCK NO-ERROR.

    IF AVAIL cotacao-item THEN DO:

        IF plMultipla THEN DO:

            ASSIGN cComprador = cotacao-item.cod-comprado.

            FOR EACH ordem-compra
               WHERE ordem-compra.it-codigo    = cotacao-item.it-codigo
                 AND ordem-compra.cod-comprado = cComprador
                 AND (ordem-compra.situacao    = 1 or ordem-compra.situacao = 5)
                 AND ordem-compra.cota-ordem   > 1 EXCLUSIVE-LOCK:

                FIND FIRST b-cot-item
                     WHERE b-cot-item.cod-emitente = cotacao-item.cod-emitente
                       AND b-cot-item.numero-ordem = ordem-compra.numero-ordem
                       AND b-cot-item.seq-cotac    = cotacao-item.seq-cotac EXCLUSIVE-LOCK NO-ERROR.

                IF NOT AVAIL b-cot-item THEN DO:

                    CREATE b-cot-item.
                    ASSIGN b-cot-item.cod-emitente = cotacao-item.cod-emitente
                           b-cot-item.numero-ordem = ordem-compra.numero-ordem
                           b-cot-item.seq-cotac    = cotacao-item.seq-cotac
                           lInvest                 = YES.
                END.

                ASSIGN b-cot-item.it-codigo        = cotacao-item.it-codigo
                       b-cot-item.data-cotacao     = cotacao-item.data-cotacao
                       b-cot-item.un               = cotacao-item.un
                       b-cot-item.pre-unit-for     = cotacao-item.pre-unit-for
                       b-cot-item.preco-fornec     = cotacao-item.preco-fornec
                       b-cot-item.mo-codigo        = cotacao-item.mo-codigo
                       b-cot-item.codigo-ipi       = cotacao-item.codigo-ipi
                       b-cot-item.aliquota-ipi     = cotacao-item.aliquota-ipi
                       b-cot-item.codigo-icm       = cotacao-item.codigo-icm
                       b-cot-item.aliquota-icm     = cotacao-item.aliquota-icm
                       b-cot-item.aliquota-iss     = cotacao-item.aliquota-iss
                       b-cot-item.frete            = cotacao-item.frete
                       b-cot-item.valor-frete      = cotacao-item.valor-frete
                       b-cot-item.taxa-financ      = cotacao-item.taxa-financ
                       b-cot-item.dias-validade    = cotacao-item.dias-validade
                       b-cot-item.nr-dias-taxa     = cotacao-item.nr-dias-taxa
                       b-cot-item.valor-taxa       = cotacao-item.valor-taxa
                       b-cot-item.perc-descto      = cotacao-item.perc-descto
                       b-cot-item.valor-descto     = cotacao-item.valor-descto
                       b-cot-item.prazo-entreg     = cotacao-item.prazo-entreg
                       b-cot-item.cod-cond-pag     = cotacao-item.cod-cond-pag
                       b-cot-item.contato          = cotacao-item.contato
                       b-cot-item.cod-comprado     = cotacao-item.cod-comprado
                       b-cot-item.preco-unit       = cotacao-item.preco-unit
                       b-cot-item.usuario          = cotacao-item.usuario
                       b-cot-item.data-atualiz     = cotacao-item.data-atualiz
                       b-cot-item.hora-atualiz     = cotacao-item.hora-atualiz
                       b-cot-item.motivo-apr       = cotacao-item.motivo-apr
                       b-cot-item.aprovador        = cotacao-item.aprovador
                       b-cot-item.possui-reaj      = cotacao-item.possui-reaj
                       b-cot-item.nr-tab           = cotacao-item.nr-tab
                       b-cot-item.reajusta-cotacao = cotacao-item.reajusta-cotacao
                       b-cot-item.cod-transp       = cotacao-item.cod-transp
                       b-cot-item.char-1           = cotacao-item.char-1
                       b-cot-item.char-2           = cotacao-item.char-2.


                /* Investimentos */
                IF lInvest THEN
                    RUN integracaoInvestimentosCotacaoItem (INPUT "I":U, INPUT prCotacaoItem).
                ELSE
                    RUN integracaoInvestimentosCotacaoItem (INPUT "M":U, INPUT prCotacaoItem).

                IF AVAIL cotacao-item THEN DO:

                    IF cotacao-item.possui-reaj THEN DO:

                        FOR FIRST b-cot-reaj FIELDS(numero-ordem cod-emitente seq-cotac it-codigo data-cotacao mo-codigo data-indice perc-reaj)
                            WHERE b-cot-reaj.numero-ordem = ordem-compra.numero-ordem
                              AND b-cot-reaj.cod-emitente = cotacao-item.cod-emitente
                              AND b-cot-reaj.seq-cotac    = cotacao-item.seq-cotac NO-LOCK: END.

                        IF AVAIL b-cot-reaj THEN DO:

                            CREATE cota-item-reaj.
                            ASSIGN cota-item-reaj.it-codigo    = b-cot-reaj.it-codigo
                                   cota-item-reaj.numero-ordem = b-cot-reaj.numero-ordem
                                   cota-item-reaj.seq-cotac    = b-cot-reaj.seq-cotac
                                   cota-item-reaj.cod-emitente = b-cot-reaj.cod-emitente
                                   cota-item-reaj.data-cotacao = b-cot-reaj.data-cotacao.

                            DO iCont = 1 TO 5:

                                IF cota-item-reaj.mo-codigo[iCont] <> 0 THEN
                                    ASSIGN cota-item-reaj.mo-codigo[iCont]   = b-cot-reaj.mo-codigo[iCont]
                                           cota-item-reaj.data-indice[iCont] = b-cot-reaj.data-indice[iCont]
                                           cota-item-reaj.perc-reaj[iCont]   = b-cot-reaj.perc-reaj[iCont].
                            END.
                        END.
                    END.

                    ASSIGN ordem-compra.situacao   = IF ordem-compra.situacao = 1 THEN 5 ELSE ordem-compra.situacao
                           ordem-compra.cota-ordem = 1
                           ordem-compra.cod-transp = cotacao-item.cod-transp.

                    FOR EACH prazo-compra
                       WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:

                        ASSIGN prazo-compra.situacao = ordem-compra.situacao.
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaMensaAprovCotacaoItem DBOProgram
PROCEDURE retornaMensaAprovCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose: Retorna mensagem quando tenta-se aprovar uma cotacao.
  Parameters:
             ipar1 : prCotacaoItem : rowid da tabela cotacao-item.
             opar2 : RowErrors     : tabela de erros
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prCotacaoItem AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /* Mensagem de Aprova‡Æo */
    RUN cdp/cdapi174.p (INPUT  7,
                        INPUT  prCotacaoItem,
                        OUTPUT iMoedaLim,
                        OUTPUT iTipoMoeda,
                        OUTPUT deValorDoc,
                        OUTPUT deValorLim).

    FOR FIRST moeda FIELDS(mo-codigo descricao)
        WHERE moeda.mo-codigo = iMoedaLim NO-LOCK: END.

    ASSIGN cMoedaLim  = STRING(iMoedaLim,"9":U) + " - ":U + moeda.descricao.

    CASE iTipoMoeda:
        WHEN 1 THEN DO:
            {utp/ut-liter.i (Usuÿrio) * r}
            ASSIGN cTipoMoeda = RETURN-VALUE.
        END.
        WHEN 2 THEN DO:
            {utp/ut-liter.i (Aprovador) * r}
            ASSIGN cTipoMoeda = RETURN-VALUE.
        END.
        WHEN 3 THEN DO:
            {utp/ut-liter.i (Fam¡lia) * r}
            ASSIGN cTipoMoeda = RETURN-VALUE.
        END.
        WHEN 4 THEN DO:
            {utp/ut-liter.i (Mestre) * r}
            ASSIGN cTipoMoeda = RETURN-VALUE.
        END.
    END CASE.

    FOR FIRST cotacao-item FIELDS(cot-aprovada numero-ordem)
        WHERE ROWID(cotacao-item) = prCotacaoItem NO-LOCK: END.

    IF AVAIL cotacao-item THEN DO:

        IF cotacao-item.cot-aprovada THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="16725"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="INFORMATION":U
                                        &ErrorParameters="cMoedaLim + '  --  ' +
                                                          '~~~~' +
                                                          TRIM(STRING(deValorLim,'zzz,zzz,zzz,zzz,zz9.99')) +
                                                          cTipoMoeda + '  --  ' +
                                                          '~~~~' +
                                                          TRIM(STRING(deValorDoc,'zzz,zzz,zzz,zzz,zz9.99')) + '  --  ' +
                                                          '~~~~' +
                                                          TRIM(STRING(cotacao-item.numero-ordem,'>>>>>>,99'))"}
        END.
        ELSE DO:
            {method/svc/errors/inserr.i &ErrorNumber="16724"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="INFORMATION":U
                                        &ErrorParameters="cMoedaLim + '  --  ' +
                                                          '~~~~' +
                                                          TRIM(STRING(deValorLim,'zzz,zzz,zzz,zzz,zz9.99')) +
                                                          cTipoMoeda + '  --  ' +
                                                          '~~~~' +
                                                          TRIM(STRING(deValorDoc,'zzz,zzz,zzz,zzz,zz9.99')) + '  --  ' +
                                                          '~~~~' +
                                                          TRIM(STRING(cotacao-item.numero-ordem,'>>>>>>,99'))"}
        END.
    END.

    FOR EACH tt-epc WHERE tt-epc.cod-event = "verificaButtonGrendene":U:
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"verificaButtonGrendene"' &CodParameter='"handle-rowerrors"' &ValueParameter="STRING(buffer RowErrors:HANDLE)"}

    {include/i-epc200.i2 &CodEvent='"verificaButtonGrendene"' &CodParameter='"rowid-cotacao"' &ValueParameter="STRING(prCotacaoItem)"}

    {include/i-epc201.i "verificaButtonGrendene"}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNumOrdem DBOProgram
PROCEDURE setConstraintNumOrdem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  ipar1  : piNumOrdem : Numero da ordem corrente da interface.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piNumOrdem AS INTEGER NO-UNDO.

    ASSIGN iNumOrdem = piNumOrdem.

    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setQuotationRFI DBOProgram
PROCEDURE setQuotationRFI :
/*------------------------------------------------------------------------------
  Purpose: Indica se a cotacao veio do RFI
  Parameters:  pQuotationRFI (logical)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pQuotationRFI AS LOGICAL NO-UNDO.

    ASSIGN l-cotacao-RFI = pQuotationRFI.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRecalculaDespesImp DBOProgram
PROCEDURE setRecalculaDespesImp :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pRecalculaDespesas AS LOGICAL NO-UNDO.

    ASSIGN l-recalcula-despesas = pRecalculaDespesas.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaAtivModCamposCotacaoPedEmerg DBOProgram
PROCEDURE validaAtivModCamposCotacaoPedEmerg :
/*------------------------------------------------------------------------------
  Purpose:     Valida a ativa‡Æo de campos na modifica‡Æo
               de registros de cota‡Æo no programa de
               pedidos emergenciais (cc0310)
  Parameters:
              opar1 : plEnableAliquotaIPI : Indica se o campo Aliquota IPI ficarÿ habilitado
              opar2 : plEnableAliquotaICM : Indica se o campo Aliquota ICM ficarÿ habilitado
              opar3 : plEnableAliquotaISS : Indica se o campo Aliquota ISS ficarÿ habilitado
              opar4 : plEnableCodigoICM   : Indica se o campo C¢digo ICM ficarÿ habilitado
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER plEnableAliquotaIPI AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnableAliquotaICM AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnableAliquotaISS AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER plEnableCodigoICM   AS LOGICAL NO-UNDO.

    FOR FIRST param-compra FIELDS(utiliza-icm) NO-LOCK: END.

    ASSIGN plEnableAliquotaIPI = YES
           plEnableAliquotaICM = param-compra.utiliza-icm
           plEnableAliquotaISS = YES
           plEnableCodigoICM   = YES.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaCotacaoOrdemCompraPedImp DBOProgram
PROCEDURE validaCotacaoOrdemCompraPedImp :
/*------------------------------------------------------------------------------
  Purpose:  (validaParcelaOrdemCompra)
            Valida existencia de cota‡Æo para a ordem de compra
            Valida a Unidades de Medida.
            Valida Conta Contÿbil
  Parameters: ipar1  : pNumero-ordem : n£mero da ordem-compra
              ipar6  : iMoeda        : Codigo da moeda
              ipar11 : deValorDescto : Valor do desconto
              ipar12 : dePrecoForn   : Pre¹o do fornecedor
              gera RowErrors
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNumero-ordem  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER iMoeda         AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER deValorDescto  AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER dePrecoFornec  AS DECIMAL   NO-UNDO.

    DEFINE VARIABLE de-cotacao AS DECIMAL  NO-UNDO.

    FOR FIRST ordem-compra FIELDS(numero-ordem data-cotacao natureza nr-contrato  num-ord-inv)
        WHERE ordem-compra.numero-ordem = pNumero-ordem NO-LOCK: END.

    IF iMoeda <> 0 THEN DO:

        IF NOT CAN-FIND(FIRST moeda
                        WHERE moeda.mo-codigo = iMoeda) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="47" &ErrorType="EMS" &ErrorSubType="ERROR"}
        END.

        RUN cdp/cd0812.p (INPUT imoeda,
                          INPUT 0,
                          INPUT 1,
                          INPUT ordem-compra.data-cotacao,
                          OUTPUT de-cotacao).

        IF de-cotacao = ? THEN
            ASSIGN de-cotacao = 0.

        IF de-cotacao = 0 THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="58" &ErrorType="EMS" &ErrorSubType="ERROR" &ErrorParameters="string(iMoeda)"}
        END.
    END.

    IF deValorDescto >= dePrecoFornec THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="3361" &ErrorType="EMS" &ErrorSubType="ERROR"}
    END.

  RETURN (IF NOT (CAN-FIND (FIRST rowErrors)) THEN "OK":U ELSE "NOK":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateButtonAprovaCotacaoItem DBOProgram
PROCEDURE validateButtonAprovaCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prCotacaoItem  AS ROWID     NO-UNDO.
    DEFINE INPUT  PARAMETER plNaoAprovadas AS LOGICAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER plBtAprova     AS LOGICAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER prItem         AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    FOR FIRST cotacao-item FIELDS(numero-ordem it-codigo)
        WHERE ROWID(cotacao-item) = prCotacaoItem NO-LOCK: END.

    FOR FIRST item FIELDS(it-codigo)
        WHERE item.it-codigo = cotacao-item.it-codigo NO-LOCK: END.

    IF AVAIL item THEN
        ASSIGN prItem = ROWID(ITEM).

    IF plNaoAprovadas = NO THEN
        ASSIGN plBtAprova = NO.
    ELSE DO:

        FOR FIRST ordem-compra FIELDS(numero-ordem situacao)
            WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK: END.

        IF ordem-compra.situacao = 3 THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="16244" &ErrorType="EMS" &ErrorSubType="ERROR"}
        END.
        ELSE
            ASSIGN plBtAprova = YES.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCotacaoItem DBOProgram
PROCEDURE validateCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    FIND FIRST rowObject NO-LOCK NO-ERROR.

   IF rowObject.data-1 = ? AND rowObject.possui-reaj THEN DO:

        {utp/ut-liter.i "Pre‡o_Base" *}
        {method/svc/errors/inserr.i &ErrorNumber="1385"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    IF NOT CAN-FIND(FIRST comprador
                    WHERE comprador.cod-comprado = rowObject.cod-comprado) THEN DO:

        {utp/ut-liter.i "Comprador" *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    IF NOT CAN-FIND(FIRST moeda
                    WHERE moeda.mo-codigo = rowObject.mo-codigo) THEN DO:

        {utp/ut-liter.i "Moeda" *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    IF rowObject.cod-cond-pag <> 0  THEN DO:

        IF NOT CAN-FIND(FIRST cond-pagto
                        WHERE cond-pagto.cod-cond-pag = rowObject.cod-cond-pag) THEN DO:

            {utp/ut-liter.i "Condi‡Æo_de_Pagamento" *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    END.

    IF NOT CAN-FIND(FIRST transporte
                    WHERE transporte.cod-transp = rowObject.cod-transp) THEN DO:

        {utp/ut-liter.i "Transporte" *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    /*--- Verifica ocorrencia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreatePedEmerg DBOProgram
PROCEDURE validateCreatePedEmerg :
/*------------------------------------------------------------------------------
  Purpose:  Valida cria‡Æo da tabela/duplicidade de registro.
            Criado para o CC0310 (Pedidos Emergenciais) .
  Parameters: ipar1 : rowObject : Tabela cotacao-item
              opar2 : rowErrors  : Tabela de erros
              opar3 : r-chave   : Rowid do registro da cotacao-item criado
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR rowObject.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST rowObject NO-ERROR.

    RUN validateFieldsPedEmerg.

    FIND FIRST rowObject NO-ERROR.

    IF RETURN-VALUE = "OK":U AND
       CAN-FIND( FIRST cotacao-item
                 WHERE cotacao-item.numero-ordem = rowObject.numero-ordem
                   AND cotacao-item.cod-emitente = rowObject.cod-emitente
                   AND cotacao-item.it-codigo    = rowObject.it-codigo
                   AND cotacao-item.seq-cotac    = rowObject.seq-cotac) THEN DO:

        {utp/ut-liter.i "Cota‡Æo_Item" *}
        {method/svc/errors/inserr.i &ErrorNumber="8"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}

    END.

    ASSIGN rowObject.cot-aprovada = YES.

    FOR EACH tt-epc WHERE tt-epc.cod-event = "afterCriaRowErrors":U:
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"afterCriaRowErrors"' &CodParameter='"handle"' &ValueParameter="string(this-procedure)"}

    {include/i-epc201.i "afterCriaRowErrors"}

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldsCotacaoItem DBOProgram
PROCEDURE validateFieldsCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:     Valida os campos da cotacao-item na inclusÆo e na modifica‡Æo
  Parameters:
              ipar1 : rowObject          : tabela cotacao-item
              ipar2 : pcItem             : c¢digo do item
              ipar3 : plItemxFornec      : indica se deverÿ relacionar item x fornecdor
                                           automaticamente
              ipar4 : pcSegUsuario       : codigo do usuÿrio corrente
              ipar5 : plInclui           : indica se ‚ uma inclusÆo
              ipar6 : plFornecInativo    : indica se deverÿ reativar fornecedores inativos
              opar7 : plIncItemFornec    : indica se haverÿ inclusÆo do fornecedor no item
              opar8 : RowErrors          : tabela de erros
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR rowObject.
    DEFINE INPUT  PARAMETER pcItem            AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER plItemxFornec     AS LOGICAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pcSegUsuario      AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER plInclui          AS LOGICAL    NO-UNDO.
    DEFINE INPUT  PARAMETER plFornecInativo   AS LOGICAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER plIncItemFornec   AS LOGICAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors .

    DEFINE VARIABLE c-lotacao   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE h-boin772   AS HANDLE       NO-UNDO.
    DEFINE VARIABLE i-situacao  AS INTEGER      NO-UNDO.
    DEFINE VARIABLE dt-vig-ini  AS DATE         NO-UNDO.
    DEFINE VARIABLE dt-vig-fim  AS DATE         NO-UNDO.
    DEFINE VARIABLE c-return    AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cMensagemItem AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cMensagemUnit AS CHARACTER  NO-UNDO.

    ASSIGN c-seg-usuario =  pcSegUsuario.

    FOR FIRST item FIELDS(it-codigo tipo-contr un)
        WHERE item.it-codigo = pcItem NO-LOCK: END.


    IF NOT AVAIL item THEN DO:

        {utp/ut-liter.i "Item" *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
        RETURN "NOK":U.
    END.

    FIND FIRST rowObject NO-LOCK NO-ERROR.

    IF rowObject.cod-emitente = 0 THEN DO:

        {utp/ut-liter.i "Fornecedor" *}
        {method/svc/errors/inserr.i &ErrorNumber="1491"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
        RETURN "NOK":U.
	END.

    FOR FIRST emitente FIELDS(cod-emitente identific cod-cond-pag)
        WHERE emitente.cod-emitente = rowObject.cod-emitente NO-LOCK: END.

    IF AVAIL emitente AND emitente.identific = 1 THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="15425" &ErrorType="EMS":U &ErrorSubType="ERROR":U}

        RETURN "NOK":U.
    END.

    IF NOT AVAIL emitente THEN DO:

        {utp/ut-liter.i "Fornecedor" *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
        RETURN "NOK":U.
    END.

    /* Verifica situa‡Æo do fornecedor */
    RUN cdp/cdapi029.p (INPUT  rowObject.cod-comprado,
                        INPUT  1,
                        INPUT  TODAY,
                        INPUT  rowObject.cod-emitente,
                        OUTPUT i-situacao,
                        OUTPUT dt-vig-ini,
                        OUTPUT dt-vig-fim,
                        OUTPUT TABLE tt-erro).

    ASSIGN c-return = RETURN-VALUE.

    FOR EACH tt-erro:
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = tt-erro.i-sequen
               RowErrors.ErrorNumber      = tt-erro.cd-erro
               RowErrors.ErrorDescription = tt-erro.mensagem
               RowErrors.ErrorHelp        = tt-erro.mensagem
               RowErrors.ErrorParameters  = tt-erro.c-param
               RowErrors.ErrorType        = "":U
               RowErrors.ErrorSubType     = IF c-return = "NOK":U THEN "ERROR":U ELSE "WARNING":U.
    END.

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF AVAIL item THEN DO:

        FOR FIRST ordem-compra FIELDS(numero-ordem it-codigo situacao nr-contrato sc-codigo data-emissao nr-processo cod-estabel ct-codigo qt-solic)
            WHERE ordem-compra.numero-ordem = rowObject.numero-ordem NO-LOCK: END.

        IF rowObject.numero-ordem <> 0 AND NOT AVAIL ordem-compra THEN DO:

            {utp/ut-liter.i "Ordem_Compra" *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        IF NOT CAN-FIND(FIRST moeda
                        WHERE moeda.mo-codigo = rowObject.mo-codigo) THEN DO:

            {utp/ut-liter.i "Moeda" *}
            {method/svc/errors/inserr.i &ErrorNumber="47"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
            RETURN "NOK":U.
        END.

        IF AVAIL ordem-compra AND ordem-compra.nr-contrato <> 0 THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="1917" &ErrorType="EMS" &ErrorSubType="ERROR"}
            RETURN "NOK":U.
        END.

        FIND FIRST comprador
             WHERE comprador.cod-comprado = rowObject.cod-comprado NO-LOCK NO-ERROR.

        IF NOT AVAIL comprador THEN DO:

            {utp/ut-liter.i "Comprador" *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        IF (rowObject.numero-ordem = ? OR rowObject.numero-ordem = 0) THEN DO:

            IF item.tipo-contr = 4 THEN DO:

                {utp/ut-liter.i "Numero_Ordem" *}
                {method/svc/errors/inserr.i &ErrorNumber="158"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
                RETURN "NOK":U.
            END.
        END.
        ELSE DO:

            IF rowObject.data-cotacao = ? THEN DO:

                {utp/ut-liter.i "Data_Cota‡Æo" *}
                {method/svc/errors/inserr.i &ErrorNumber="265"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
                 RETURN "NOK":U.
            END.
        END.

        IF AVAIL ordem-compra THEN DO:

            IF ordem-compra.it-codigo <> item.it-codigo THEN DO:

                {method/svc/errors/inserr.i &ErrorNumber="1918" &ErrorType="EMS":U &ErrorSubType="ERROR"}
                RETURN "NOK":U.
            END.

            IF plInclui = YES THEN DO:
                IF INDEX("246":U,STRING(ordem-compra.situacao)) > 0 THEN DO:

                    {method/svc/errors/inserr.i &ErrorNumber="1919" &ErrorType="EMS" &ErrorSubType="ERROR"}
                    RETURN "NOK":U.
                END.
            END.
            ELSE DO:
                IF INDEX("46":U,STRING(ordem-compra.situacao)) > 0 THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="1919" &ErrorType="EMS" &ErrorSubType="ERROR"}
                    RETURN "NOK":U.
                END.
            END.

            IF ordem-compra.nr-processo <> 0 THEN DO:

                IF NOT CAN-FIND(FIRST proc-fornec
                                WHERE proc-fornec.nr-processo  = ordem-compra.nr-processo
                                  AND proc-fornec.cod-emitente = rowObject.cod-emitente) THEN DO:

                    {method/svc/errors/inserr.i &ErrorNumber="2147" &ErrorType="EMS" &ErrorSubType="ERROR"}
                    RETURN "NOK":U.
                END.
            END.
        END.

        IF rowObject.preco-fornec = 0 THEN DO:

            {utp/ut-liter.i "Pre‡o_Fornecedor" *}
            {method/svc/errors/inserr.i &ErrorNumber="36"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
            RETURN "NOK":U.
        END.

        IF rowObject.data-cotacao = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF
        OR rowObject.data-cotacao > TODAY THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="1920" &ErrorType="EMS" &ErrorSubType="ERROR"}
            RETURN "NOK":U.
        END.

        IF NOT CAN-FIND(FIRST tab-unidade
                        WHERE tab-unidade.un = rowObject.un) THEN DO:

            {utp/ut-liter.i "Ordem_de_Compra" *}
            ASSIGN c-msg = TRIM(RETURN-VALUE)
                   c-msg = c-msg + " " + string(rowObject.numero-ordem).
           {utp/ut-liter.i "Item" *}
           ASSIGN cMensagemItem = TRIM(RETURN-VALUE)
                  c-msg = c-msg + " " + cMensagemItem + " " + rowObject.it-codigo.
           {utp/ut-liter.i "Unidade_de_Medida" *}
           ASSIGN cMensagemUnit = TRIM(RETURN-VALUE)
                  c-msg = c-msg + " " + cMensagemUnit + " " + string(rowObject.un).

            {method/svc/errors/inserr.i &ErrorNumber="846" &ErrorType="EMS" &ErrorSubType="ERROR" &ErrorParameters="c-msg + '~~~~' + trim(RETURN-VALUE)"}
            RETURN "NOK":U.
        END.

        IF NOT CAN-FIND(FIRST comprador
                        WHERE comprador.cod-comprado = c-seg-usuario) THEN DO:

            {utp/ut-liter.i "Usu rio_corrente" *}
            ASSIGN c-msg = TRIM(RETURN-VALUE)
                   c-msg = c-msg + " " + c-seg-usuario.
            {utp/ut-liter.i "Comprador" *}

            {method/svc/errors/inserr.i &ErrorNumber="17167"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-msg + '~~~~' + trim(RETURN-VALUE)"}

            RETURN "NOK":U.
        END.

        FOR FIRST item-fornec
            WHERE item-fornec.cod-emitente = rowObject.cod-emitente
              AND item-fornec.it-codigo    = rowObject.it-codigo NO-LOCK: END.

        IF rowObject.it-codigo <> "" THEN DO:

            // Quando cota‡Æo vier do ME atualiza unidade de medida para a unidade do fornecedor para converter qtd e evitar erro 2244
            IF l-Integr-Me
            AND CAN-FIND(FIRST ordem-compra-integr-me WHERE ordem-compra-integr-me.numero-ordem = rowObject.numero-ordem) THEN
                ASSIGN rowObject.un = item-fornec.unid-med-for. //BB tratar aqui pra considerar a tabela item-fornec-umd

            IF AVAIL item-fornec AND item-fornec.it-codigo = rowObject.it-codigo THEN DO:


                IF item.it-codigo <> "" AND item.tipo-contr = 4  AND AVAIL item-fornec
                OR item.tipo-contr <> 4 AND AVAIL item-fornec THEN DO:

                    IF rowObject.un <> item-fornec.unid-med-for THEN DO:

                        IF AVAIL param-compra AND param-compra.log-multi-unid-medid THEN DO:

                            /*Utiliza M£ltiplas Unidades de Medida se unidade da item-fornec <> unidade da cota‡Æo,
                            verifica se existe registro para item x fornecedor x unidade para unidade da cota‡Æo */

                            FIND FIRST item-fornec-umd
                                 WHERE item-fornec-umd.it-codigo = item-fornec.it-codigo
                                   AND item-fornec-umd.cod-emitente = item-fornec.cod-emitente
                                   AND item-fornec-umd.unid-med-for = Rowobject.un NO-LOCK NO-ERROR.

                            IF NOT AVAIL item-fornec-umd THEN DO:

                                {method/svc/errors/inserr.i &ErrorNumber="2244" &ErrorType="EMS" &ErrorSubType="ERROR"}
                                RETURN "NOK":U.
                            END.
                            ELSE DO:
                                IF NOT item-fornec-umd.log-ativo THEN DO:

                                    {utp/ut-liter.i "Relacionamento_Item_X_Fornecedor_X_Unidade_de_Medida" *}
                                    {method/svc/errors/inserr.i &ErrorNumber="469"
                                                                &ErrorType="EMS"
                                                                &ErrorSubType="ERROR"
                                                                &ErrorParameters="TRIM(RETURN-VALUE)"}
                                    RETURN "NOK":U.
                                END.
                            END.
                        END.
                        ELSE DO:

                            {method/svc/errors/inserr.i &ErrorNumber="2244" &ErrorType="EMS" &ErrorSubType="ERROR"}
                            RETURN "NOK":U.
                        END.
                    END.
                END.
            END.
        END. /*end if it-codigo <> "" */


        IF rowObject.cod-cond-pag <> 0 THEN DO:

            IF NOT CAN-FIND(FIRST cond-pagto
                            WHERE cond-pagto.cod-cond-pag = rowObject.cod-cond-pag) THEN DO:

                {utp/ut-liter.i "Condi‡Æo_Pagamento" *}
                {method/svc/errors/inserr.i &ErrorNumber="47"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
                RETURN "NOK":U.
            END.
        END.

        IF CAN-FIND (FIRST funcao WHERE funcao.cd-funcao = "spp-integra-ems-his":U AND funcao.ativo = YES) THEN DO:

            &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
                 IF rowObject.cdn-fab-medic = 0 THEN
            &ELSE
                IF SUBSTRING(rowObject.char-1,127,9) = "0" THEN
            &ENDIF

                IF CAN-FIND (FIRST fab-medic-item
                             WHERE fab-medic-item.cod-item = rowObject.it-codigo
                               AND fab-medic-item.log-ativo) THEN DO:

                    {utp/ut-liter.i "Fabricante" *}
                    {method/svc/errors/inserr.i &ErrorNumber="17677"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="TRIM(RETURN-VALUE)"}
                     RETURN "NOK":U.
                END.
                ELSE
                    IF CAN-FIND (FIRST fab-medic-item
                                 WHERE fab-medic-item.cod-item  = rowObject.it-codigo
                                   AND fab-medic-item.log-ativo = NO) THEN DO:

                        {utp/ut-liter.i "Fabricante_deve_ser_diferente_de_branco" *}
                        ASSIGN c-msg = TRIM(RETURN-VALUE).
                        {utp/ut-liter.i "Deve_haver_fabricante_ativo_cadastrado_para_o_item_conforme_programa_CC9051(Consulta_Item_X_Fabricantes)" *}
                        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="c-msg + '.' + '~~~~' + TRIM(RETURN-VALUE) + '.'"}
                        RETURN "NOK":U.
                    END.
        END.

        FIND FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U NO-LOCK NO-ERROR.
        IF AVAIL RowErrors THEN
             RETURN "NOK":U.
        ELSE DO:

            IF plInclui THEN DO:

                IF rowObject.it-codigo <> "" THEN DO:

                    IF item.tipo-contr <> 4 THEN DO:

                        IF NOT AVAIL item-fornec THEN DO:

                            /* Pelo RFI, nao apresentar msg sempre gerar relacionamento item/fornec, caso nao existir */
                            IF param-compra.gera-item-for = NO AND NOT l-cotacao-RFI THEN DO:

                                {utp/ut-liter.i "Ordem_Compra" *}
                                {method/svc/errors/inserr.i &ErrorNumber="2153"
                                                            &ErrorType="EMS"
                                                            &ErrorSubType="ERROR"
                                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
                            END.
                            ELSE DO:

                                IF plItemxFornec = NO THEN
                                    ASSIGN plIncItemFornec = YES.
                                ELSE DO:
                                    ASSIGN plIncItemFornec = NO.
                                    RUN pi-cria-item-fornec.
                                END.
                            END.
                        END.
                        ELSE DO:

                            IF AVAIL ordem-compra THEN
                                FOR FIRST item-fornec-estab FIELDS(it-codigo cod-estabel cod-emitente ativo)
                                    WHERE item-fornec-estab.it-codigo    = item.it-codigo
                                      AND item-fornec-estab.cod-emitente = rowObject.cod-emitente
                                      AND item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel NO-LOCK: END.

                            IF item-fornec.ativo AND (AVAIL item-fornec-estab AND item-fornec-estab.ativo = NO) THEN DO:

                                IF param-compra.perm-cot-for = NO THEN DO:
                                    {method/svc/errors/inserr.i &ErrorNumber="2155" &ErrorType="EMS" &ErrorSubType="ERROR"}
                                END.
                                ELSE DO:
                                    IF plFornecInativo THEN DO:

                                        ASSIGN rItemFornec = ROWID(item-fornec-estab).

                                        FIND FIRST item-fornec-estab
                                             WHERE ROWID(item-fornec-estab) = rItemFornec EXCLUSIVE-LOCK NO-ERROR.

                                        ASSIGN item-fornec-estab.ativo = YES.
                                    END.
                                    ELSE DO:
                                        {method/svc/errors/inserr.i &ErrorNumber="2156" &ErrorType="EMS" &ErrorSubType="ERROR"}
                                    END.
                                END.
                            END.

                            IF item-fornec.ativo = NO THEN DO:

                                IF param-compra.perm-cot-for = NO THEN DO:
                                    {method/svc/errors/inserr.i &ErrorNumber="2155" &ErrorType="EMS" &ErrorSubType="ERROR"}
                                END.
                                ELSE DO:
                                    IF plFornecInativo THEN DO:
                                        ASSIGN rItemFornec = ROWID(item-fornec).
                                        FIND FIRST item-fornec
                                             WHERE ROWID(item-fornec) = rItemFornec EXCLUSIVE-LOCK NO-ERROR.
                                        ASSIGN item-fornec.ativo = YES.
                                    END.
                                    ELSE DO:
                                        {method/svc/errors/inserr.i &ErrorNumber="2156" &ErrorType="EMS" &ErrorSubType="ERROR"}
                                    END.
                                END.
                            END.
                        END.
                    END. /* item.tipo-contr <> 4 */
                END.   /*end if it-codigo <> "" */
            END.
        END.

        FIND FIRST item-fornec
             WHERE item-fornec.it-codigo    = item.it-codigo
               AND item-fornec.cod-emitente = rowObject.cod-emitente NO-LOCK NO-ERROR.

        IF NOT AVAIL item-fornec AND rowObject.un <> item.un THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="2244" &ErrorType="EMS" &ErrorSubType="ERROR"}
            RETURN "NOK":U.
        END.

        /* Sugere Fator de Conv. Gera‡Æo Item/Fornec */
        IF l-sugeriu-fator-conver AND NOT l-cotacao-RFI THEN DO:

            {utp/ut-liter.i "Relacionamento_Item_x_Fornecedor" *}
            {method/svc/errors/inserr.i &ErrorNumber="54492"
                                        &ErrorType="EMS"
                                        &ErrorSubType="WARNING"
                                        &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~' + string(item-fornec.fator-conver) + '~~~~' + string(item-fornec.num-casa-dec)"}
        END.

        IF param-compra.utiliza-icm = NO THEN
            ASSIGN rowObject.codigo-icm   = 1
                   rowObject.aliquota-icm = 0.

        IF param-compra.utiliza-iss = NO THEN
            ASSIGN rowObject.aliquota-iss = 0.

        IF rowObject.dias-validade = 0 THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="2292" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
        END.

        IF(rowObject.data-cotacao + rowObject.dias-validade) < TODAY THEN DO:

            {utp/ut-liter.i "cota‡Æo" *}
            {method/svc/errors/inserr.i &ErrorNumber="17262"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        IF NOT CAN-FIND(FIRST transporte
                        WHERE transporte.cod-transp = rowObject.cod-transp) THEN DO:

            {utp/ut-liter.i "Transporte" *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        /*  Aprova‡Æo Eletr“nica */

        FIND FIRST param-compra NO-LOCK NO-ERROR.

        IF AVAILABLE ordem-compra AND param-compra.log-1 THEN DO:

            ASSIGN lGeraPendencia = NO.

            {utp/ut-field.i mgind item-doc-est cot-aprovada 4}

            ASSIGN cFormato = RETURN-VALUE.

            ASSIGN lGeraPendencia = YES.
            ASSIGN lGeraPendencia = IF STRING(rowObject.cot-aprovada) = STRING(lGeraPendencia,cFormato) THEN YES ELSE NO.

            IF lGeraPendencia THEN DO:

                RUN cdp/cdapi173.p (INPUT  3,
                                    INPUT  item.it-codigo,
                                    INPUT  rowObject.cod-comprado,
                                    OUTPUT lRetornoAprov).

                RUN lap/mlaapi099.p (INPUT 0).

                IF CAN-FIND(FIRST funcao
                            WHERE funcao.cd-funcao = "Integra_MLA_EMS":U
                              AND funcao.ativo     = YES) AND RETURN-VALUE <> "NOK":U THEN DO:

                    /* Calculo do Valor da Cota‡Æo */
                    IF rowObject.mo-codigo = 0 THEN
                        ASSIGN de-cotacao-moeda = 1.
                    ELSE DO:

                        RUN cdp/cd0812.p (INPUT rowobject.mo-codigo,
                                          INPUT 0,
                                          INPUT 1,
                                          INPUT rowObject.data-cotacao,
                                          OUTPUT de-cotacao-moeda).

                        IF de-cotacao-moeda = ? THEN
                            ASSIGN de-cotacao-moeda = 1.
                    END.
                    IF AVAIL pedido-compr AND pedido-compr.cod-estab-gestor <> "" THEN
                        ASSIGN c-estabelecimento = pedido-compr.cod-estab-gestor.
                    ELSE
                        ASSIGN c-estabelecimento = ordem-compra.cod-estabel.
                    /* Fim Calculo */

                    ASSIGN de-valor-item  = ordem-compra.qt-solic * rowObject.preco-unit * de-cotacao-moeda
                           de-valor-total = de-valor-item.

                    /*Verifica se ‚ solicita‡Æo de cota‡Æo*/
                    ASSIGN i-tp-doc = 3.

                    IF ordem-compra.nr-requisicao <> 0 THEN DO:

                        FIND FIRST requisicao WHERE requisicao.nr-requisicao = ordem-compra.nr-requisicao NO-LOCK NO-ERROR.
                        IF AVAIL requisicao AND requisicao.tp-requis = 3 THEN
                            ASSIGN i-tp-doc = 5.
                    END.

                    IF i-tp-doc = 3 THEN DO: /*Cota‡Æo*/
                        /*BO mla-lotacao*/
                        RUN inbo/boin772.p PERSISTENT SET h-boin772.
                        RUN buscaLotacaoUsuarOrig IN h-boin772(INPUT 5, /*Cota‡Æo - C¢digo no MLA*/
                                                               INPUT ordem-compra.nr-requisicao,
                                                               INPUT cotacao-item.cod-comprado,
                                                               OUTPUT c-lotacao).
                        IF c-lotacao = "" THEN
                            ASSIGN c-lotacao = ordem-compra.sc-codigo.

                        IF VALID-HANDLE(h-boin772) THEN DO:
                            DELETE PROCEDURE h-boin772.
                            ASSIGN h-boin772 = ?.
                        END.
                    END.
                    ELSE
                        ASSIGN c-lotacao = ordem-compra.sc-codigo.

                    RUN lap/mlaapi173.p (INPUT i-tp-doc,
                                         INPUT item.it-codigo,
                                         INPUT rowObject.cod-comprado,
                                         INPUT ordem-compra.ct-codigo,
                                         INPUT "",
                                         INPUT c-lotacao,
                                         INPUT de-valor-item,
                                         INPUT de-valor-total,
                                         INPUT c-estabelecimento,
                                         OUTPUT TABLE tt-erro).

                    IF RETURN-VALUE = "NOK":U THEN DO:
                        FIND FIRST TT-ERRO NO-ERROR.
                        IF AVAIL tt-erro THEN DO:

                            {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="tt-erro.c-param"}

                            RETURN "NOK":U.
                        END.
                    END.
                END.

                IF NOT lRetornoAprov THEN DO:

                    {method/svc/errors/inserr.i &ErrorNumber="15661" &ErrorType="EMS" &ErrorSubType="ERROR"}
                END.
            END.
        END.
    END. /* if avail item */

    FOR EACH tt-epc WHERE tt-epc.cod-event = "FimValidateFieldsCotacaoItem":U:
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"FimValidateFieldsCotacaoItem"' &CodParameter="'OBJECT-HANDLE'":U &ValueParameter="string(this-procedure)"}
    {include/i-epc200.i2 &CodEvent='"FimValidateFieldsCotacaoItem"' &CodParameter='"Handle-RowErrors"' &ValueParameter="string(TEMP-TABLE rowErrors:HANDLE)"}
    {include/i-epc201.i "FimValidateFieldsCotacaoItem"}

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldsPedEmerg DBOProgram
PROCEDURE validateFieldsPedEmerg :
/*------------------------------------------------------------------------------
  Purpose:   Valida‡„es de neg¢cio para altera‡Æo/inclusÆo de
             cota‡„es para ordens de pedidos emergenciais
             Criado para o CC0310 (Pedidos Emergenciais)
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-leave-descto AS LOGICAL INITIAL YES NO-UNDO.

    FOR FIRST ordem-compra FIELDS(numero-ordem num-pedido perc-descto)
        WHERE ordem-compra.numero-ordem = rowObject.numero-ordem NO-LOCK: END.

    FOR FIRST pedido-compr FIELDS(num-pedido data-pedido cod-estab-gestor)
        WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    IF (AVAIL ordem-compra AND ordem-compra.perc-descto <> rowObject.perc-descto)
    OR (NOT AVAIL ordem-compra AND rowObject.perc-descto <> 0) THEN
        ASSIGN l-leave-descto = YES.
    ELSE
        ASSIGN l-leave-descto = NO.

    RUN inbo/boin082ca.p PERSISTENT SET hboin082ca.
    RUN calculaPrecoUnitFornecedorCotacao IN hBoin082ca (INPUT l-leave-descto,
                                                         INPUT rowObject.numero-ordem,
                                                         INPUT-OUTPUT TABLE rowObject).

    DELETE PROCEDURE hBoin082ca.
    ASSIGN hBoin082ca = ?.

    FIND FIRST rowObject NO-LOCK NO-ERROR.

    IF CAN-FIND(FIRST moeda
                WHERE moeda.mo-codigo = rowObject.mo-codigo) THEN DO:

        ASSIGN deCotacaoMoeda = 1.
        RUN cdp/cd0812.p (INPUT rowobject.mo-codigo,
                          INPUT 0,
                          INPUT 1,
                          INPUT pedido-compr.data-pedido,
                          OUTPUT deCotacaoMoeda).

      IF deCotacaoMoeda = ? THEN
          ASSIGN deCotacaoMoeda = 0.

      IF deCotacaoMoeda = 0 THEN DO:

          {method/svc/errors/inserr.i &ErrorNumber="3360" &ErrorType="EMS" &ErrorSubType="ERROR"}
      END.
    END.
    ELSE DO:

        {utp/ut-liter.i "Moeda" *}
        {method/svc/errors/inserr.i &ErrorNumber="47"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    IF NOT CAN-FIND(FIRST tab-unidade
                    WHERE tab-unidade.un = rowObject.un) THEN DO:

      {utp/ut-liter.i "Unidade" *}
      {method/svc/errors/inserr.i &ErrorNumber="47"
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR"
                                  &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    IF rowObject.valor-descto > rowObject.preco-fornec THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="3361" &ErrorType="EMS" &ErrorSubType="ERROR"}
    END.

    IF rowObject.valor-descto = rowObject.preco-fornec THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="3362" &ErrorType="EMS" &ErrorSubType="ERROR" }
    END.

    FIND FIRST moeda
         WHERE moeda.mo-codigo = rowObject.mo-codigo NO-LOCK NO-ERROR.

    IF NOT AVAIL moeda THEN DO:

        {utp/ut-liter.i "Moeda" *}
        {method/svc/errors/inserr.i &ErrorNumber="47"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}

    END.

    IF rowObject.preco-fornec = 0 THEN DO:


      {utp/ut-liter.i "Pre¯o_Fornecedor" *}
      {method/svc/errors/inserr.i &ErrorNumber="36"
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR"
                                  &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    IF CAN-FIND (FIRST funcao WHERE funcao.cd-funcao = "spp-integra-ems-his":U AND funcao.ativo = YES) THEN DO:

        &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
            IF rowObject.cdn-fab-medic = 0 THEN
        &ELSE
            IF SUBSTRING(rowObject.char-1,127,9) = "0":U THEN
        &ENDIF
            IF CAN-FIND (FIRST fab-medic-item
                         WHERE fab-medic-item.cod-item = rowObject.it-codigo
                           AND fab-medic-item.log-ativo) THEN DO:


                {utp/ut-liter.i "Fabricante" *}
                {method/svc/errors/inserr.i &ErrorNumber="17677"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
            ELSE
                IF CAN-FIND (FIRST fab-medic-item
                             WHERE fab-medic-item.cod-item  = rowObject.it-codigo
                               AND fab-medic-item.log-ativo = NO) THEN DO:

                    {utp/ut-liter.i "Fabricante_deve_ser_diferente_de_branco" *}
                    ASSIGN c-msg = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i "Deve_haver_fabricante_ativo_cadastrado_para_o_item_conforme_programa_CC9051(Consulta_Item_X_Fabricantes)" *}
                    {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-msg + '.' + '~~~~' + TRIM(RETURN-VALUE) + '.'"}
                END.
    END.


    IF rowObject.cod-cond-pag <> 0 THEN DO:

        FIND FIRST cond-pagto
             WHERE cond-pagto.cod-cond-pag = rowObject.cod-cond-pag NO-LOCK NO-ERROR.

        IF NOT AVAIL cond-pagto THEN DO:

            {utp/ut-liter.i "Condi‡Æo_Pagamento" *}
            {method/svc/errors/inserr.i &ErrorNumber="47"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    END.

    FIND FIRST transporte
         WHERE transporte.cod-transp = rowObject.cod-transp NO-LOCK NO-ERROR.

    IF NOT AVAIL transporte THEN DO:

        {utp/ut-liter.i "Transporte" *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    FOR FIRST item-fornec FIELDS(it-codigo cod-emitente ativo unid-med-for)
        WHERE item-fornec.it-codigo    = rowObject.it-codigo
          AND item-fornec.cod-emitente = rowObject.cod-emitente
          AND item-fornec.ativo          NO-LOCK: END.

    FOR FIRST item FIELDS(it-codigo tipo-contr)
        WHERE item.it-codigo = rowObject.it-codigo NO-LOCK: END.

    IF rowObject.it-codigo = "" OR rowObject.it-codigo = ? OR (item.tipo-contr = 4 AND NOT AVAILABLE item-fornec) THEN DO:

        FOR FIRST prazo-compra FIELDS(numero-ordem un)
            WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK: END.

        IF AVAIL prazo-compra THEN DO:
            IF rowObject.un <> prazo-compra.un AND
            NOT CAN-FIND(FIRST tab-conv-un
                         WHERE tab-conv-un.un           = prazo-compra.un
                           AND tab-conv-un.unid-med-for = rowObject.un) THEN DO:

                {method/svc/errors/inserr.i &ErrorNumber="4032" &ErrorType="EMS" &ErrorSubType="ERROR" }
            END.
        END.
    END.
    ELSE DO:
        IF AVAIL item-fornec THEN DO:
            IF rowObject.un <> item-fornec.unid-med-for THEN DO:
                IF AVAIL param-compra AND param-compra.log-multi-unid-medid THEN DO:

                    /*Utiliza M£ltiplas Unidades de Medida Se unidade da item-fornec <> unidade da cota‡Æo,
                      Verifica se existe registro para item x fornecedor x unidade para unidade da cota‡Æo */
                    IF NOT CAN-FIND(FIRST item-fornec-umd
                                    WHERE item-fornec-umd.it-codigo = item-fornec.it-codigo
                                      AND item-fornec-umd.cod-emitente = item-fornec.cod-emitente
                                      AND item-fornec-umd.unid-med-for = Rowobject.un
                                      AND item-fornec-umd.log-ativo) THEN DO:

                        {method/svc/errors/inserr.i &ErrorNumber="51523"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="item-fornec.it-codigo + '~~~~' + string(item-fornec.cod-emitente) + '~~~~' + Rowobject.un"}
                    END.
                END.
                ELSE DO:

                    {method/svc/errors/inserr.i &ErrorNumber="1571" &ErrorType="EMS" &ErrorSubType="ERROR"}
                END.
            END.
        END.
    END.

    IF CAN-FIND(FIRST funcao
                WHERE funcao.cd-funcao = "spp-item-um-duplic":U
                  AND funcao.ativo     = YES) THEN DO:

        FOR EACH b-ordem-compra NO-LOCK
            WHERE b-ordem-compra.num-pedido    =  ordem-compra.num-pedido
              AND b-ordem-compra.numero-ordem <> ordem-compra.numero-ordem
              AND b-ordem-compra.cod-emitente  =  ordem-compra.cod-emitente
              AND b-ordem-compra.it-codigo     =  RowObject.it-codigo:

            IF CAN-FIND(FIRST cotacao-item
                        WHERE cotacao-item.numero-ordem = b-ordem-compra.numero-ordem
                          AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                          AND cotacao-item.it-codigo    = RowObject.it-codigo
                          AND cotacao-item.un           = Rowobject.un) AND l-erro-item-um-duplic = NO THEN DO:

                RUN _insertErrorManual IN THIS-PROCEDURE (INPUT 17119,                                              /* pErrorNumber  */
                                                          INPUT "EMS":U,                                            /* pErrorType        */
                                                          INPUT "Error":U,                                          /* pErrorSubType     */
                                                          INPUT "Item j  foi informado para ordem de compra "       /* pErrorDescription */
                                                                +  STRING(b-ordem-compra.numero-ordem)
                                                                + " com mesma unidade de medida.":U,
                                                          INPUT "",                                                 /* pErrorHelp        */
                                                          INPUT "").                                                /* pErrorParameters  */
                ASSIGN l-erro-item-um-duplic = YES.
            END.
        END.
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
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-cotacao-item-imp.

    DEFINE VARIABLE hDBOCotacao-item-cex AS HANDLE NO-UNDO.

    FIND FIRST tt-cotacao-item-imp NO-ERROR.

    IF AVAIL tt-cotacao-item-imp THEN DO:

        {ccp/cc9019.i50}
        {cdp/cd4300.i4 "yes" tt-cotacao-item-imp.char-1}
        {ccp/cc9019.i51 "yes"}
        {ocp/oc0201.i50}
        {cdp/cd4300.i4 "yes" tt-cotacao-item-imp.char-2}
        {ocp/oc0201.i51 "yes"}

        RUN cxbo/bocx085.p PERSISTENT SET hdbocotacao-item-cex.

        /* Valida informa‡„es de Importa‡Æo */
        RUN validaCotacaoitem in hDBOCotacao-item-cex (INPUT tt-cotacao-item-imp.cod-emitente,
                                                       INPUT c-cod-incoterm-i50,
                                                       INPUT i-cod-pto-contr-i50,
                                                       INPUT i-cod-fabricante-i50,
                                                       INPUT i-regime-import-i50,
                                                       INPUT tt-cotacao-item-imp.it-codigo,
                                                       INPUT c-class-fiscal-i50,
                                                       INPUT c-nbs-i50,
                                                       INPUT tt-cotacao-item-imp.cdn-pais-orig,
                                                       OUTPUT TABLE tt-bo-erro).
        FIND FIRST tt-bo-erro NO-ERROR.
        IF AVAIL tt-bo-erro THEN DO:

            {utp/ut-liter.i "Importa‡Æo" *}
            {method/svc/errors/inserr.i &ErrorNumber="26492"
                                        &ErrorType="EMS"
                                        &ErrorSubType="WARNING"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        DELETE PROCEDURE hDBOCotacao-item-cex.
        ASSIGN hDBOCotacao-item-cex = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable rowObject
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o parümetro pType para identificar quais as valida¯´es a serem executadas                    ---*/
    /*--- Os valores possðveis para o parümetro sÊo: Create, Delete e Update                                   ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravýs do include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida¯´es                                                                            ---*/

    /*--- Verifica ocorr¬ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdateAprovacaoCotacaoItem DBOProgram
PROCEDURE validateUpdateAprovacaoCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose: Faz valida‡„es e atualiza a parte de aprovacao da cotacao
  Parameters:
              ipar1  :  rowObject        : tabela cotaco-item
              ipar2  :  pcSegUsuario     : codigo do usuario corrente
              ipar3  :  prCotacaoItem    : rowid  de um registro da tabela cotacao-item
              ipar4  :  prItem           : rowid  de um registro da tabela item
              ipar5  :  plAprovar        : indica se a cota‡Æo deverÿ ser aprovada
              opar6  :  plOrdemCotada    : indica se poderÿ ser reaprovada ordens jÿ aprovadas
              opar7  :  plFornecInativo  : indica se poderÿ reativar fornecedores inativos
              opar8  :  plMotivoAprov    : indica se a cota‡Æo estÿ aprovada
              opar9  :  pcMotivoApr      : motivo da aprova‡Æo
              opar10 :  prPrazoCompra    : rowid de um registro da tabela prazo-compra
              opar11 :  RowErrors        : tabela de erros
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR rowObject.
    DEFINE INPUT  PARAMETER pcSegUsuario    AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER prCotacaoItem   AS ROWID        NO-UNDO.
    DEFINE INPUT  PARAMETER prItem          AS ROWID        NO-UNDO.
    DEFINE INPUT  PARAMETER plAprovar       AS LOGICAL      NO-UNDO.
    DEFINE OUTPUT PARAMETER plOrdemCotada   AS LOGICAL      NO-UNDO.
    DEFINE OUTPUT PARAMETER plFornecInativo AS LOGICAL      NO-UNDO.
    DEFINE OUTPUT PARAMETER plMotivoAprov   AS LOGICAL      NO-UNDO.
    DEFINE OUTPUT PARAMETER pcMotivoApr     AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER prPrazoCompra   AS ROWID        NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST rowObject NO-ERROR.

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    FIND FIRST cotacao-item
         WHERE ROWID(cotacao-item) = prCotacaoItem EXCLUSIVE-LOCK NO-ERROR.

    FOR FIRST ordem-compra FIELDS(numero-ordem it-codigo cod-estabel)
        WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK: END.

    FOR FIRST item FIELDS(it-codigo preco-repos)
        WHERE ROWID(item) = prItem NO-LOCK: END.

    FOR FIRST item-fornec FIELDS(it-codigo cod-emitente ativo)
        WHERE item-fornec.it-codigo    = item.it-codigo
          AND item-fornec.cod-emitente = cotacao-item.cod-emitente NO-LOCK: END.

    ASSIGN dePrecoUnitAnt = IF AVAIL cotacao-item THEN cotacao-item.preco-unit ELSE 0.

    ASSIGN c-seg-usuario = pcSegUsuario.

    FOR FIRST prazo-compra FIELDS(numero-ordem)
        WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK: END.

    IF AVAIL prazo-compra THEN
        ASSIGN prPrazoCompra = rowid(prazo-compra).

    IF AVAIL ordem-compra THEN DO:
        IF AVAIL item THEN DO:

            IF plAprovar = YES AND cotacao-item.preco-unit > item.preco-repos AND cotacao-item.preco-unit <> dePrecoUnitAnt THEN DO:

                {method/svc/errors/inserr.i &ErrorNumber="15407" &ErrorType="EMS" &ErrorSubType="ERROR"}
            END.
        END.

        ASSIGN cItCodigo = IF AVAIL ordem-compra THEN ordem-compra.it-codigo ELSE ?.

        IF plAprovar AND AVAIL cotacao-item THEN DO:

            ASSIGN lHabilita = NO.

            IF AVAIL item-fornec THEN DO:
                IF item-fornec.ativo = NO AND param-compra.perm-cot-for = NO THEN DO:

                    {method/svc/errors/inserr.i &ErrorNumber="2155" &ErrorType="EMS" &ErrorSubType="ERROR"}
                END.
                ELSE DO:

                    FIND FIRST item-fornec-estab
                         WHERE item-fornec-estab.cod-emitente = cotacao-item.cod-emitente
                           AND item-fornec-estab.it-codigo    = cotacao-item.it-codigo
                           AND item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel EXCLUSIVE-LOCK NO-ERROR.

                    IF AVAIL item-fornec-estab THEN DO:
                        IF item-fornec.ativo AND item-fornec-estab.ativo = NO AND plFornecInativo = NO THEN DO:

                            {method/svc/errors/inserr.i &ErrorNumber="2156" &ErrorType="EMS" &ErrorSubType="ERROR"}
                        END.
                        ELSE
                            ASSIGN item-fornec-estab.ativo = YES
                                   lHabilita               = YES.
                    END.

                    IF item-fornec.ativo = NO THEN DO:
                        IF plFornecInativo = NO THEN DO:

                            {method/svc/errors/inserr.i &ErrorNumber="2156" &ErrorType="EMS" &ErrorSubType="ERROR"}
                        END.
                        ELSE
                            ASSIGN item-fornec.ativo = YES
                                    lHabilita        = YES.
                    END.
                    ELSE
                        ASSIGN lHabilita = YES.
                END.
            END.
            ELSE
                ASSIGN lHabilita = YES.

            IF lHabilita THEN DO:

                FIND FIRST param-aprov NO-LOCK NO-ERROR.

                IF param-compra.log-1 AND param-aprov.aprova-cotac THEN
                    FOR FIRST b-cotacao-item FIELDS(it-codigo numero-ordem log-1 cot-aprovada)
                        WHERE b-cotacao-item.numero-ordem = cotacao-item.numero-ordem
                          AND b-cotacao-item.it-codigo    = cItCodigo
                          AND b-cotacao-item.log-1        = YES NO-LOCK: END.
                ELSE
                    FOR FIRST b-cotacao-item FIELDS(it-codigo numero-ordem log-1 cot-aprovada)
                        WHERE b-cotacao-item.numero-ordem = cotacao-item.numero-ordem
                          AND b-cotacao-item.it-codigo    = cItCodigo
                          AND b-cotacao-item.cot-aprovada = YES NO-LOCK: END.

                FIND FIRST param-aprov NO-LOCK NO-ERROR.

                IF AVAIL b-cotacao-item AND AVAIL cotacao-item AND ROWID(b-cotacao-item) <> prCotacaoItem THEN DO:

                    IF param-compra.log-1 AND param-aprov.aprova-cotac THEN DO:

                        {method/svc/errors/inserr.i &ErrorNumber="15957" &ErrorType="EMS" &ErrorSubType="ERROR"}
                    END.
                    ELSE
                        IF plOrdemCotada = NO THEN DO:

                            {method/svc/errors/inserr.i &ErrorNumber="15957" &ErrorType="EMS" &ErrorSubType="ERROR"}
                        END.
                END.

                ASSIGN pcMotivoApr = IF cotacao-item.cot-aprovada THEN cotacao-item.motivo-apr
                                     ELSE cotacao-item.narrativa.

                ASSIGN plMotivoAprov = YES.
            END.
        END.
    END.

    IF NOT plAprovar THEN DO:

        FIND FIRST param-aprov NO-LOCK NO-ERROR.

        IF param-compra.log-1 AND param-aprov.aprova-cotac THEN DO:

            IF cotacao-item.log-1 THEN
                RUN cdp/cdapi171.p (3,3,ROWID(cotacao-item)).
        END.

        IF cotacao-item.log-1 OR cotacao-item.cot-aprovada THEN DO:

            FIND FIRST ordem-compra
                 WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem EXCLUSIVE-LOCK NO-ERROR.

            /* Solic. Cotac */
            IF ordem-compra.nr-requisicao <> 0 THEN DO:

                FOR FIRST requisicao FIELDS(nr-requisicao tp-requis)
                    WHERE requisicao.nr-requisicao = ordem-compra.nr-requisicao NO-LOCK: END.

                IF AVAIL requisicao AND requisicao.tp-requis = 3 THEN
                    ASSIGN ordem-compra.expectativa = YES.

                IF ordem-compra.expectativa THEN DO:

                    FIND FIRST it-requisicao
                         WHERE it-requisicao.nr-requisicao = ordem-compra.nr-requisicao
                           AND it-requisicao.it-codigo     = ordem-compra.it-codigo
                           AND it-requisicao.sequencia     = ordem-compra.sequencia EXCLUSIVE-LOCK NO-ERROR.

                    IF AVAIL it-requisicao THEN DO:

                        ASSIGN it-requisicao.preco-unit = 0.

                        FOR FIRST it-requisicao FIELDS(nr-requisicao it-codigo sequencia)
                            WHERE it-requisicao.nr-requisicao = ordem-compra.nr-requisicao
                              AND it-requisicao.it-codigo     = ordem-compra.it-codigo
                              AND it-requisicao.sequencia     = ordem-compra.sequencia NO-LOCK: END.

                        RUN cdp/cdapi171.p(5,3,ROWID(it-requisicao)).
                    END.
                END.
            END.

            IF AVAIL ordem-compra THEN DO:

                RUN cdp/cdapi195.p(ROWID(ordem-compra),ROWID(cotacao-item)).

                /* Execucao Orcamentaria - Financas */
                ASSIGN ordem-compra.situacao     = 5
                       ordem-compra.data-cotacao = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF
                       ordem-compra.pre-unit-for = 0
                       ordem-compra.preco-fornec = 0
                       ordem-compra.mo-codigo    = 0
                       ordem-compra.cod-cond-pag = 0
                       ordem-compra.contato      = ""
                       ordem-compra.preco-unit   = 0
                       ordem-compra.preco-orig   = 0.

                FOR EACH prazo-compra
                   WHERE prazo-compra.numero-ordem = cotacao-item.numero-ordem EXCLUSIVE-LOCK:

                    ASSIGN prazo-compra.situacao = 5.
                END.
            END.

            IF AVAIL cotacao-item THEN
                ASSIGN rowObject.cot-aprovada    = NO
                       rowObject.log-1           = NO
                       cotacao-item.cot-aprovada = NO
                       cotacao-item.log-1        = NO.
        END. /* cotacao-item.log-1 OR cotacao-item.cot-aprovada */
    END. /* NOT plAprovar */

    IF NOT plAprovar AND (cotacao-item.cot-aprovada OR cotacao-item.log-1) THEN
        ASSIGN plMotivoAprov = YES.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    ELSE DO:

        RUN inbo/boin082.p PERSISTENT SET h-boin082.
        RUN setConstraintNumOrdem IN h-boin082 (INPUT cotacao-item.numero-ordem).
        RUN openQueryStatic IN h-boin082 (INPUT "ByCotacao":U).

        RUN validateUpdate IN h-boin082 (INPUT  TABLE rowObject,
                                         INPUT  prCotacaoItem,
                                         OUTPUT TABLE RowErrors).
        DELETE PROCEDURE h-boin082.
        ASSIGN h-boin082 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdateFiscalCotacaoItem DBOProgram
PROCEDURE validateUpdateFiscalCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose: Valida e altera a parte fiscal da cota‡Æo.
  Parameters:
             ipar1 : rowObject : tabela cotacao-item
             ipar2 : r-chave   : rowid do registro da cotacao-item a ser alterado
             opar3 : RowErrors : tabela de erros
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR rowObject.
    DEFINE INPUT  PARAMETER r-chave AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    FIND FIRST rowObject NO-LOCK NO-ERROR.

    IF param-compra.utiliza-icm = NO THEN
        ASSIGN rowObject.codigo-icm   = 1
               rowObject.aliquota-icm = 0.

    IF param-compra.utiliza-iss = NO THEN
        ASSIGN rowObject.aliquota-iss = 0.

    IF rowObject.dias-validade = 0 THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="2292" &ErrorType="EMS" &ErrorSubType="ERROR"}
    END.

    IF NOT CAN-FIND(FIRST transporte
                    WHERE transporte.cod-transp = rowObject.cod-transp) THEN DO:

        FOR FIRST ordem-compra FIELDS(num-pedido)
            WHERE ordem-compra.numero-ordem = rowObject.numero-ordem NO-LOCK: END.

        IF NOT AVAIL ordem-compra
        OR (   (AVAIL ordem-compra AND ordem-compra.num-pedido = 0)
            OR (CAN-FIND(FIRST pedido-compr
                         WHERE pedido-compr.num-pedido = ordem-compra.num-pedido
                           AND pedido-compr.situacao = 1 /*Impresso*/ ))) THEN DO:

            {utp/ut-liter.i "Transporte" *}
            {method/svc/errors/inserr.i &ErrorNumber="7193"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    ELSE DO:

        RUN inbo/boin082.p PERSISTENT SET h-boin082.
        RUN setConstraintNumOrdem in h-boin082 (INPUT rowObject.numero-ordem).
        RUN openQueryStatic IN h-boin082 (INPUT "ByCotacao":U).

        RUN validateUpdate IN h-boin082 (INPUT  TABLE rowObject,
                                         INPUT  r-chave,
                                         OUTPUT TABLE RowErrors).
        DELETE PROCEDURE h-boin082.
        ASSIGN h-boin082 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdatePedEmerg DBOProgram
PROCEDURE validateUpdatePedEmerg :
/*------------------------------------------------------------------------------
  Purpose:  Valida Update
            Criado para o CC0310 (Pedidos Emergenciais)
  Parameters:
             ipar1 : rowObject : tabela cotacao-item
             ipar2 : r-chave   : rowid da cotacao-item
             opar3 : rowErrors  : tabela de erros

  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR rowObject.
    DEFINE INPUT  PARAMETER r-chave AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors .

    DEFINE VARIABLE l-alteracao-preco   AS LOGICAL                      NO-UNDO.
    DEFINE VARIABLE i-cont              AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE c-mensagem          AS CHARACTER FORMAT "x(200)":U  NO-UNDO.

    FIND FIRST rowObject NO-LOCK NO-ERROR.

    RUN validateFieldsPedEmerg.


    FOR EACH tt-epc WHERE tt-epc.cod-event = "afterCriaRowErrors":U:
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"afterCriaRowErrors"' &CodParameter='"handle"' &ValueParameter="string(this-procedure)"}

    {include/i-epc201.i "afterCriaRowErrors"}

    FOR FIRST cotacao-item FIELDS(numero-ordem mo-codigo valor-descto preco-fornec)
        WHERE ROWID(cotacao-item) = r-chave NO-LOCK: END.

    FOR FIRST ordem-compra FIELDS(numero-ordem num-pedido)
        WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK: END.

    FOR FIRST pedido-compr FIELDS(cod-emitente num-pedido situacao cod-estab-gestor)
        WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.

    IF pedido-compr.situacao = 1 /* Impresso */ THEN
        ASSIGN l-cc0308 = YES.
    ELSE
        ASSIGN l-cc0308 = NO.

    IF l-cc0308 THEN
        RUN validaCotacaoOrdemCompraPedImp (INPUT cotacao-item.numero-ordem,
                                            INPUT cotacao-item.mo-codigo,
                                            INPUT cotacao-item.valor-descto,
                                            INPUT cotacao-item.preco-fornec).

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    ELSE DO:

        FIND FIRST rowObject NO-LOCK NO-ERROR.

        ASSIGN l-alteracao-preco = (cotacao-item.pre-unit-for <> RowObject.pre-unit-for)OR(cotacao-item.mo-codigo <> rowobject.mo-codigo).

        RUN inbo/boin082.p PERSISTENT SET h-boin082.
        RUN setConstraintNumOrdem in h-boin082 (INPUT rowObject.numero-ordem).
        RUN openQueryStatic in h-boin082 (INPUT "ByCotacao":U).

        RUN validateUpdate IN h-boin082 (INPUT  TABLE rowObject,
                                         INPUT  r-chave,
                                         OUTPUT TABLE RowErrors).

        DELETE PROCEDURE h-boin082.
        ASSIGN h-boin082 = ?.

        IF AVAIL ordem-compra THEN DO:
            FIND CURRENT ordem-compra EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN ordem-compra.preco-fornec = rowObject.preco-fornec.
        END.

        FIND FIRST emitente
             WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK NO-ERROR.

        FIND FIRST param-global NO-LOCK NO-ERROR.

        IF l-alteracao-preco THEN DO: /** alteracao no preco ou na moeda **/

            IF  param-global.modulo-07
            AND emitente.natureza > 2 THEN DO:

                RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.
                RUN procuraEmbarqueCompras IN h-bocx225 (INPUT pedido-compr.num-pedido,
                                                         INPUT ordem-compra.numero-ordem,
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

                    /* Inicio -- Projeto Internacional */

                    {utp/ut-liter.i "Material_em_Trƒnsito" *}
                    ASSIGN c-msg = c-mensagem + '~~~~' + TRIM(RETURN-VALUE).

                    {method/svc/errors/inserr.i &ErrorNumber="28558"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="INFORMATION":U
                                                &ErrorParameters= "c-msg"}
                END.
            END.

            IF  CONNECTED ("mgcex":U) AND param-global.modulo-07 AND emitente.natureza > 2 THEN DO:

                {method/svc/errors/inserr.i &ErrorNumber="30079" &ErrorType="EMS":U &ErrorSubType="INFORMATION":U}

                RUN imp/im9052.p (INPUT "cotacao-item", INPUT ROWID(cotacao-item)).
            END.
        END.
    END.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaItemFornecedor DBOProgram
PROCEDURE verificaItemFornecedor :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pitCodigo AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pcodEmit  AS INTEGER     NO-UNDO.

    IF NOT CAN-FIND(FIRST item-fornec
                    WHERE item-fornec.it-codigo    = pitCodigo
                      AND item-fornec.cod-emitente = pcodemit
                      AND item-fornec.ativo) THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="8440" &ErrorType="EMS":U &ErrorSubType="ERROR":U}

        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaEPCAfterCreateItemFornec DBOProgram
PROCEDURE criaEPCAfterCreateItemFornec :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-c-rowid-item-fornec AS CHARACTER NO-UNDO.


    FOR EACH tt-epc WHERE tt-epc.cod-event = "after_create_item_fornec":U:
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"after_create_item_fornec"' &CodParameter='"rowid-item-fornec"' &ValueParameter="p-c-rowid-item-fornec"}

    {include/i-epc201.i "after_create_item_fornec"}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
