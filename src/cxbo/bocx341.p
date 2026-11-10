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
{include/i-prgvrs.i BOCX341 2.00.00.023 } /*** "010023" 19/08/2026 16:23:25 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX341 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX341
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName despes-ped-compra
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com definiá∆o da temptable RowObject ---*/
{cxbo/bocx341.i RowObject}
{cxbo/bocx085.i tt-cotacao-item-cex}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
{method/dboqry.i}
{utp/ut-glob.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}     FOR {&TableName}.
DEFINE BUFFER b-ordem-compra     FOR ordem-compra.
DEFINE BUFFER b-cotacao-item     FOR cotacao-item.
DEFINE BUFFER b-cotacao-item-cex FOR cotacao-item-cex.

/*:T--- Definiá∆o de Temp Table's ---*/
DEFINE TEMP-TABLE tt-embarque NO-UNDO
    FIELD embarque AS CHAR FORMAT "x(16)":U.

DEFINE TEMP-TABLE tt-pedidos NO-UNDO
    FIELD num-pedido LIKE pedido-compr.num-pedido.

DEFINE TEMP-TABLE tt-ordens-compra NO-UNDO
    FIELD numero-ordem LIKE ordem-compra.numero-ordem.

DEFINE TEMP-TABLE tt-desp-param NO-UNDO
    FIELD cod-desp          LIKE desp-imp.cod-desp
    FIELD val-desp          LIKE despes-ped-compra.val-desp
    FIELD mo-codigo         LIKE despes-ped-compra.mo-codigo
    FIELD cod-emitente-desp LIKE despes-ped-compra.cod-emitente-desp
    FIELD cod-cond-pag      LIKE despes-ped-compra.cod-cond-pag
    FIELD cod-pto-contr     LIKE despes-ped-compra.cod-pto-contr
    FIELD cod-incoterm-rat  LIKE despes-ped-compra.cod-incoterm-rat
    FIELD tp-despesa        LIKE despes-ped-compra.tp-despesa.

DEFINE TEMP-TABLE tt-ordem-desp NO-UNDO
    FIELD cod-desp          LIKE cotacao-item-cex.cod-desp         
    FIELD sequencia         LIKE despes-ped-compra.sequencia
    FIELD mo-codigo         LIKE cotacao-item-cex.mo-codigo        
    FIELD cod-emitente-desp LIKE cotacao-item-cex.cod-emitente-desp
    FIELD cod-cond-pag      LIKE cotacao-item-cex.cod-cond-pag     
    FIELD cod-pto-contr     LIKE cotacao-item-cex.cod-pto-contr    
    FIELD tp-despesa        LIKE cotacao-item-cex.tp-despesa 
    FIELD val-desp          LIKE despes-ped-compra.val-desp.

{include/boerrtab.i} /* Definic∆o tt-bo-erro                                                                                                                */
{imp/imapi006.i}     /* Definic∆o tt-desp-ja-recalc                                                                                                         */
{imp/im0091.i}       /* tt-desp-rateio, tt-itens-rateio, tt-ordens-totais, tt-ordens-totais-incoterm, tt-ordens-desp, tt-ordens-desp-cot, tt-desp-totais, 
                        tt-desp-totais-incoterm, tt-desp-totais-embarques-mult, tt-itiner-emb, tt-despesas, tt-ordem-compra, tt-desp-cif                    */

/*:T--- Definiá∆o de Variaveis Locais ---*/
DEFINE VARIABLE c-lista-embarques      AS  CHARACTER                NO-UNDO.
DEFINE VARIABLE h-bocx225              AS  HANDLE                   NO-UNDO.
DEFINE VARIABLE h-bocx085              AS  HANDLE                   NO-UNDO.
DEFINE VARIABLE l-valida-processo      AS  LOGICAL                  NO-UNDO.
DEFINE VARIABLE l-ultima-desp-pedido   AS  LOGICAL                  NO-UNDO.
DEFINE VARIABLE l-reposiciona-registro AS  LOGICAL INITIAL YES      NO-UNDO.
DEFINE VARIABLE l-desp-imposto         AS  LOGICAL                  NO-UNDO.                             
DEFINE VARIABLE iNumPedido             LIKE pedido-compr.num-pedido NO-UNDO.

DEFINE VARIABLE l-nt2024002   AS LOGICAL  NO-UNDO.
ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo).

{cdp/cd4300.i3}      /* tratamento atributo livre param-imp.char-1   */
{cxbo/bocx250.i50}   /* tratamento atributo livre param-imp.char-1   */

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
         HEIGHT             = 9.46
         WIDTH              = 40.
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


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDespesasOrdem DBOProgram 
PROCEDURE atualizaDespesasOrdem :
/*------------------------------------------------------------------------------
Parameters:
INPUT pi-transacao     -> 1 = incluir, 2 = alterar, 3 = eliminar
INPUT pi-tipo-alter(*) -> 1 = somente ordens que possuem a despesa, 2 = todas as ordens do pedido
INPUT pi-cod-cond-pag-ant(*)  -> condicao de pagto antes da alteracao 
INPUT pi-cod-pto-contr-ant(*) -> ponto de controle antes da alteracao
INPUT pi-tp-despesa-ant(*)    -> tipo despesa antes da alteracao
INPUT TABLE FOR tt-desp-param   -> despesa a ser alterada (1 registro por vez)
INPUT TABLE FOR tt-pedidos    -> pedidos a serem alterados (podem ser varios)

(*) Estes campos somente dever∆o ser enviados para este procedure na transaá∆o "alterar".
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pi-transacao         AS INTEGER                           NO-UNDO.
    DEFINE INPUT PARAM pi-tipo-alter        AS INTEGER                           NO-UNDO.
    DEFINE INPUT PARAM pi-cod-cond-pag-ant  LIKE despes-ped-compra.cod-cond-pag  NO-UNDO.
    DEFINE INPUT PARAM pi-cod-pto-contr-ant LIKE despes-ped-compra.cod-pto-contr NO-UNDO.
    DEFINE INPUT PARAM pi-tp-despesa-ant    LIKE despes-ped-compra.tp-despesa    NO-UNDO.
    DEFINE INPUT PARAM TABLE FOR tt-desp-param.
    DEFINE INPUT PARAM TABLE FOR tt-pedidos.
    
    DEFINE VARIABLE c-estabel             AS   CHARACTER                     NO-UNDO.
    DEFINE VARIABLE h-im0091              AS   HANDLE                        NO-UNDO.
    DEFINE VARIABLE i-qtd-pedidos         AS   INTEGER                       NO-UNDO.
    DEFINE VARIABLE l-considera-ordem     AS   LOGICAL                       NO-UNDO.
    DEFINE VARIABLE rw-despes-ped-compra  AS   ROWID                         NO-UNDO.
    DEFINE VARIABLE i-sequencia           LIKE cotacao-item-cex.sequencia    NO-UNDO.
    DEFINE VARIABLE de-vl-tot-desp-pedido LIKE desp-imp.val-desp             NO-UNDO.
    DEFINE VARIABLE de-valor-tot-desp     LIKE despes-ped-compra.val-desp    NO-UNDO.
    DEFINE VARIABLE de-valor-diferenca    LIKE despes-ped-compra.val-desp    NO-UNDO.
    DEFINE VARIABLE i-num-prim-pedido     LIKE pedido-compr.num-pedido       NO-UNDO.

    /*--- verifica se tem mais de um pedido ---*/
    FOR EACH tt-pedidos:
        FIND FIRST pedido-compr 
             WHERE pedido-compr.num-pedido = tt-pedidos.num-pedido NO-LOCK NO-ERROR.

        IF NOT AVAIL pedido-compr THEN
            NEXT.

        ASSIGN i-qtd-pedidos     = i-qtd-pedidos + 1
               c-estabel         = pedido-compr.cod-estabel
               i-num-prim-pedido = pedido-compr.num-pedido.

        IF i-qtd-pedidos = 2 THEN DO:
            ASSIGN i-num-prim-pedido = 0.
            LEAVE.
        END.
    END.

    IF pi-tipo-alter = ? THEN
        ASSIGN pi-tipo-alter = 1.

    FIND FIRST tt-desp-param NO-ERROR.

    IF NOT AVAIL tt-desp-param THEN
        RETURN "NOK":U.

    IF NOT VALID-HANDLE(h-bocx085) THEN
        RUN cxbo/bocx085.p PERSISTENT SET h-bocx085.

    IF pi-transacao = 3 /* elimina */ THEN DO:
        
        FOR EACH tt-pedidos:
            FOR EACH ordem-compra FIELDS(numero-ordem it-codigo)
               WHERE ordem-compra.num-pedido = tt-pedidos.num-pedido NO-LOCK:
                
                FOR FIRST cotacao-item FIELDS (numero-ordem it-codigo cod-emitente seq-cotac char-1)
                    WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                      AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                      AND cotacao-item.cot-aprovada = YES NO-LOCK: END.
    
                IF  NOT AVAIL cotacao-item THEN NEXT.
    
                /*--- verifica se a cotacao esta vinculada a algum mapa de cotacao ---*/
                IF  SUBSTRING(cotacao-item.char-1,1,20) <> ""  THEN DO:
                    FOR EACH cotacao-item-cex
                       WHERE cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem                    
                         AND cotacao-item-cex.it-codigo    = cotacao-item.it-codigo                       
                         AND cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente                    
                         AND cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac                       
                         AND cotacao-item-cex.mapa-cotacao = INTEGER(SUBSTRING(cotacao-item.char-1,1,20)) 
                         AND cotacao-item-cex.cod-desp     = tt-desp-param.cod-desp                       EXCLUSIVE-LOCK:

                        IF tt-desp-param.cod-emitente-desp <> ? THEN
                            IF cotacao-item-cex.cod-emitente-desp <>  tt-desp-param.cod-emitente-desp THEN
                                NEXT.

                        IF tt-desp-param.mo-codigo <> ? THEN
                            IF cotacao-item-cex.mo-codigo <> tt-desp-param.mo-codigo THEN
                                NEXT.

                        IF tt-desp-param.cod-cond-pag <> ? THEN
                            IF cotacao-item-cex.cod-cond-pag <> tt-desp-param.cod-cond-pag THEN
                                NEXT.

                        IF tt-desp-param.cod-pto-contr <> ? THEN
                            IF cotacao-item-cex.cod-pto-contr <> tt-desp-param.cod-pto-contr THEN
                                NEXT.

                        IF tt-desp-param.tp-despesa <> ? THEN
                            IF cotacao-item-cex.tp-despesa <> tt-desp-param.tp-despesa THEN
                                NEXT.

                        /*--- Verifica se foi informado mais de um pedido, caso foi, devera se feita a atualizacao da tabela despes-ped-compra.
                              Caso contrario (im0300) esta atualizacao nao precisara ser feita ---*/
                        IF i-qtd-pedidos = 2 THEN DO:
                            
                            RUN retornaValorTotalDespCotada IN h-bocx085 (INPUT  ROWID(cotacao-item-cex),
                                                                          OUTPUT de-valor-tot-desp).

                            RUN retornaValorDespesa (INPUT tt-pedidos.num-pedido, 
                                                     INPUT cotacao-item-cex.cod-desp,
                                                     INPUT cotacao-item-cex.mo-codigo,
                                                     INPUT cotacao-item-cex.cod-emitente-desp,
                                                     INPUT cotacao-item-cex.cod-cond-pag,
                                                     INPUT cotacao-item-cex.cod-pto-contr,
                                                     INPUT cotacao-item-cex.tp-despesa,
                                                     OUTPUT rw-despes-ped-compra,
                                                     OUTPUT de-vl-tot-desp-pedido).

                            IF  de-vl-tot-desp-pedido <> 0 THEN DO:

                                FIND FIRST desp-imp 
                                     WHERE desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.

                                IF AVAIL desp-imp AND desp-imp.tipo <> 1 /* valor fixo */ THEN DO:
                                    
                                    ASSIGN de-valor-diferenca = de-vl-tot-desp-pedido - de-valor-tot-desp.
    
                                    IF  de-valor-diferenca > 0 THEN DO:
                                        /*--- atualiza despes-ped-compra na base ---*/    
                                        RUN emptyRowObject IN THIS-PROCEDURE.
                                        RUN emptyRowErrors IN THIS-PROCEDURE.
                                        RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
                                        RUN repositionRecord IN THIS-PROCEDURE (INPUT rw-despes-ped-compra).
                                        IF RETURN-VALUE = "NOK":U THEN NEXT.
                                        RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE rowObject).
                                        FIND FIRST rowObject NO-ERROR.
                                        IF NOT AVAIL rowObject THEN NEXT.
                                        ASSIGN rowObject.val-desp = de-valor-diferenca.
                                        RUN setRecord IN THIS-PROCEDURE (INPUT TABLE rowObject).
                                        RUN updateRecord IN THIS-PROCEDURE.
                                        /*--- fim atualizacao despes-ped-compra ---*/
                                    END.
                                    ELSE DO:
                                        /*--- elimina despes-ped-compra na base ---*/    
                                        RUN emptyRowErrors IN THIS-PROCEDURE.
                                        RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
                                        RUN repositionRecord IN THIS-PROCEDURE (INPUT rw-despes-ped-compra).
                                        IF RETURN-VALUE = "NOK":U THEN NEXT.
                                        RUN deleteRecord IN THIS-PROCEDURE.
                                        /*--- fim eliminacao despes-ped-compra ---*/
                                    END.
                                END.
                            END.
                        END. /* IF i-qtd-pedidos = 2... */

                        FIND FIRST desp-imp 
                             WHERE desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.

                        IF AVAIL desp-imp AND desp-imp.tipo = 1 /* valor fixo */ THEN DO:

                            ASSIGN l-ultima-desp-pedido = YES.
    
                            /*--- verifica se a despesa que esta sendo eliminada eh a ultima do pedido compra em questao ---*/
                            FOR EACH b-ordem-compra 
                               WHERE b-ordem-compra.num-pedido = tt-pedidos.num-pedido NO-LOCK,
                               FIRST b-cotacao-item
                               WHERE b-cotacao-item.numero-ordem = b-ordem-compra.numero-ordem
                                 AND b-cotacao-item.it-codigo    = b-ordem-compra.it-codigo
                                 AND b-cotacao-item.cot-aprovada = YES  /* cotacao aprovada */
                                 AND SUBSTRING(b-cotacao-item.char-1,1,20) <> "" /* mapa aprovado */ NO-LOCK:

                                FOR FIRST b-cotacao-item-cex
                                    WHERE b-cotacao-item-cex.numero-ordem = b-ordem-compra.numero-ordem
                                      AND b-cotacao-item-cex.cod-desp     = cotacao-item-cex.cod-desp
                                      AND ROWID(b-cotacao-item-cex) <> ROWID(cotacao-item-cex)
                                      AND b-cotacao-item-cex.mapa-cotacao = INT(SUBSTR(b-cotacao-item.char-1,1,20)) NO-LOCK: END.
                                
                                IF AVAIL b-cotacao-item-cex THEN DO:
                                    ASSIGN l-ultima-desp-pedido = NO.
                                    LEAVE.
                                END.
                            END.
    
                            IF l-ultima-desp-pedido THEN DO:
                                RUN retornaValorDespesa IN THIS-PROCEDURE(INPUT  tt-pedidos.num-pedido, 
                                                                          INPUT  cotacao-item-cex.cod-desp,
                                                                          INPUT  cotacao-item-cex.mo-codigo,
                                                                          INPUT  cotacao-item-cex.cod-emitente-desp,
                                                                          INPUT  cotacao-item-cex.cod-cond-pag, 
                                                                          INPUT  cotacao-item-cex.cod-pto-contr,
                                                                          INPUT  cotacao-item-cex.tp-despesa,   
                                                                          OUTPUT rw-despes-ped-compra,
                                                                          OUTPUT de-vl-tot-desp-pedido).
    
                                /*--- elimina despes-ped-compra na base ---*/    
                                IF l-reposiciona-registro THEN DO:
                                
                                    RUN emptyRowErrors IN THIS-PROCEDURE.
                                    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
                                    RUN repositionRecord IN THIS-PROCEDURE (INPUT rw-despes-ped-compra).
                                
                                    IF  RETURN-VALUE = "OK":U THEN DO: 
                                        RUN deleteRecord IN THIS-PROCEDURE.
                                        IF  RETURN-VALUE = "NOK":U THEN
                                            UNDO, RETURN "NOK":U.
                                    END.
                                END.
                                /*--- fim eliminacao despes-ped-compra ---*/
                            END.
                        END.

                        /*--- atualiza despesas influenciadas ---*/
                        RUN imp/imapi006.p(INPUT "cotacao-item-cex":U,  
                                           INPUT ROWID(cotacao-item-cex),
                                           INPUT cotacao-item-cex.cod-desp,
                                           INPUT 0,
                                           INPUT TABLE tt-cotacao-item-cex,
                                           INPUT-OUTPUT TABLE tt-desp-ja-recalc).
                        
                        DELETE cotacao-item-cex NO-ERROR.

                        /* Verifica se existe mais alguma despesa para o mesmo mapa da cotacao-item, caso nao exista, desvincula a cotacao-item do mapa */
                        {cdp/cd4300.i3} /* Atributos livres */

                        FOR FIRST b-cotacao-item-cex
                            WHERE b-cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem                          
                              AND b-cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente                          
                              AND b-cotacao-item-cex.it-codigo    = cotacao-item.it-codigo                             
                              AND b-cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac                             
                              AND b-cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao                          
                              AND b-cotacao-item-cex.mapa-cotacao = INTEGER(TRIM(SUBSTRING(cotacao-item.char-1,1,20))) NO-LOCK: END.

                        IF NOT AVAIL b-cotacao-item-cex THEN DO:

                            FIND CURRENT cotacao-item EXCLUSIVE-LOCK  NO-WAIT NO-ERROR.

                            {ccp/cc9019.i50}
                            {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                            {ccp/cc9019.i51 "yes"}

                            ASSIGN i-mapa-cotacao-i50 = 0.

                            {ccp/cc9019.i51 "no"}
                            {cdp/cd4300.i4 "no" cotacao-item.char-1}.
                        END.
                    END. /* FOR EACH cotacao-item-cex... */
                END.
            END.
        END.
    END. /* if pi-transacao = 3 */
    ELSE DO:
        
        EMPTY TEMP-TABLE tt-ordens-compra.
        
        RUN imp/im0091.p PERSISTENT SET h-im0091.

        FOR EACH tt-pedidos:

            IF  pi-transacao = 1 /* incluir */
            OR (    pi-transacao  = 2 /* alterar */
                AND pi-tipo-alter = 2 /* todas as ordens */) THEN DO:

                FOR EACH  ordem-compra FIELDS(numero-ordem)
                    WHERE ordem-compra.num-pedido = tt-pedidos.num-pedido NO-LOCK: 

                    CREATE tt-ordens-compra.
                    ASSIGN tt-ordens-compra.numero-ordem = ordem-compra.numero-ordem.
                END.
            END.
            ELSE IF  pi-transacao  = 2 /* alterar */
                 AND pi-tipo-alter = 1 /* somente ordens que possuem a despesa */ THEN DO:

                FOR EACH  ordem-compra FIELDS(numero-ordem it-codigo)
                    WHERE ordem-compra.num-pedido = tt-pedidos.num-pedido NO-LOCK:

                    FOR  FIRST cotacao-item FIELDS(numero-ordem it-codigo cod-emitente seq-cotac char-1)
                         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                           AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                           AND cotacao-item.cot-aprovada = YES NO-LOCK: END.

                    IF NOT AVAIL cotacao-item THEN NEXT.

                    IF SUBSTRING(cotacao-item.char-1,1,20) <> ""  THEN DO:
                        
                        ASSIGN l-considera-ordem = YES.

                        FOR EACH  cotacao-item-cex
                            WHERE cotacao-item-cex.numero-ordem      = cotacao-item.numero-ordem
                              AND cotacao-item-cex.it-codigo         = cotacao-item.it-codigo
                              AND cotacao-item-cex.cod-emitente      = cotacao-item.cod-emitente
                              AND cotacao-item-cex.seq-cotac         = cotacao-item.seq-cotac
                              AND cotacao-item-cex.mapa-cotacao      = INT(SUBSTR(cotacao-item.char-1,1,20))
                              AND cotacao-item-cex.cod-desp          = tt-desp-param.cod-desp
                              AND cotacao-item-cex.mo-codigo         = tt-desp-param.mo-codigo
                              AND cotacao-item-cex.cod-emitente-desp = tt-desp-param.cod-emitente-desp
                              AND cotacao-item-cex.cod-cond-pag      = pi-cod-cond-pag-ant
                              AND cotacao-item-cex.cod-pto-contr     = pi-cod-pto-contr-ant 
                              AND cotacao-item-cex.tp-despesa        = pi-tp-despesa-ant NO-LOCK:

                            CREATE tt-ordens-compra.
                            ASSIGN tt-ordens-compra.numero-ordem = ordem-compra.numero-ordem.

                            LEAVE.
                        END.
                    END.
                END.
            END. /* if pi-transacao = 2 ... */

            RUN setaValorInicial IN h-im0091(INPUT TODAY, INPUT c-estabel).

            RUN rateioDespesasPedido IN h-im0091(INPUT  i-num-prim-pedido,
                                                 INPUT  TABLE tt-ordens-compra,
                                                 INPUT  TABLE tt-desp-param,
                                                 OUTPUT TABLE tt-desp-rateio).

            RUN getTTbo-erro IN h-im0091(OUTPUT TABLE tt-bo-erro).
            
            IF CAN-FIND(FIRST tt-bo-erro) THEN
                NEXT.

            IF pi-transacao = 1 /* incluir */ THEN DO:

                FOR EACH tt-ordens-compra:
                    
                    FOR FIRST ordem-compra FIELDS(num-pedido numero-ordem it-codigo)
                        WHERE ordem-compra.numero-ordem = tt-ordens-compra.numero-ordem NO-LOCK: END.

                    IF  NOT AVAIL ordem-compra THEN
                        NEXT.

                    FIND FIRST tt-desp-rateio
                         WHERE tt-desp-rateio.numero-ordem = tt-ordens-compra.numero-ordem
                           AND tt-desp-rateio.cod-desp     = tt-desp-param.cod-desp NO-ERROR.

                    IF NOT AVAIL tt-desp-rateio OR tt-desp-rateio.val-desp-unit <= 0 THEN
                        NEXT.

                    FOR FIRST processo-imp FIELDS(cod-itiner)
                        WHERE processo-imp.num-pedido = ordem-compra.num-pedido NO-LOCK: END.

                    IF NOT AVAIL processo-imp THEN
                        NEXT.

                    FIND FIRST cotacao-item
                         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                           AND cotacao-item.it-codigo    = ordem-compra.it-codigo    
                           AND cotacao-item.cot-aprovada = YES                       EXCLUSIVE-LOCK NO-ERROR.

                    IF  AVAIL cotacao-item THEN DO:
                        /*--- efetua criacao da cotacao-item-cex ---*/
                        {cxbo/bocx341.i1 &END=END.}

                        FIND CURRENT cotacao-item NO-LOCK NO-ERROR.
                    END.
                END. /* if  pi-transacao = 1... */
            ELSE DO:

                FOR EACH tt-ordens-compra:
                    
                    FOR FIRST ordem-compra FIELDS(num-pedido numero-ordem it-codigo)
                        WHERE ordem-compra.numero-ordem = tt-ordens-compra.numero-ordem NO-LOCK: END.

                    IF NOT AVAIL ordem-compra THEN
                        NEXT.

                    FIND FIRST tt-desp-rateio
                         WHERE tt-desp-rateio.numero-ordem = tt-ordens-compra.numero-ordem
                           AND tt-desp-rateio.cod-desp     = tt-desp-param.cod-desp NO-ERROR.

                    IF NOT AVAIL tt-desp-rateio OR  tt-desp-rateio.val-desp-unit <= 0 THEN
                        NEXT.

                    FOR FIRST processo-imp FIELDS(cod-itiner)
                        WHERE processo-imp.num-pedido = ordem-compra.num-pedido NO-LOCK: END.

                    IF NOT AVAIL processo-imp THEN
                        NEXT.

                    FIND FIRST cotacao-item
                         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                           AND cotacao-item.it-codigo    = ordem-compra.it-codigo    
                           AND cotacao-item.cot-aprovada = YES                       EXCLUSIVE-LOCK NO-ERROR.

                    IF NOT AVAIL cotacao-item THEN NEXT.

                    /*-- converte para a moeda da despesa ---*/
                    IF  tt-desp-param.mo-codigo <> 0 THEN
                        RUN cdp/cd0812.p (INPUT 0, 
                                          INPUT tt-desp-param.mo-codigo,
                                          INPUT tt-desp-rateio.val-desp-unit,
                                          INPUT TODAY,
                                          OUTPUT tt-desp-rateio.val-desp-unit).

                    FIND FIRST cotacao-item-cex
                         WHERE cotacao-item-cex.numero-ordem      = cotacao-item.numero-ordem
                           AND cotacao-item-cex.it-codigo         = cotacao-item.it-codigo
                           AND cotacao-item-cex.cod-emitente      = cotacao-item.cod-emitente
                           AND cotacao-item-cex.seq-cotac         = cotacao-item.seq-cotac 
                           AND cotacao-item-cex.data-cotacao      = cotacao-item.data-cotacao
                           AND cotacao-item-cex.mapa-cotacao      = INT(SUBSTRING(cotacao-item.char-1,1,20))
                           AND cotacao-item-cex.cod-incoterm      = TRIM(SUBSTRING(cotacao-item.char-1,21,20))
                           AND cotacao-item-cex.cod-itiner        = processo-imp.cod-itiner
                           AND cotacao-item-cex.cod-emitente-desp = tt-desp-param.cod-emitente-desp
                           AND cotacao-item-cex.cod-desp          = tt-desp-param.cod-desp
                           AND cotacao-item-cex.cod-pto-contr     = pi-cod-pto-contr-ant 
                           AND cotacao-item-cex.cod-cond-pag      = pi-cod-cond-pag-ant 
                           AND cotacao-item-cex.tp-despesa        = pi-tp-despesa-ant EXCLUSIVE-LOCK NO-ERROR.

                    IF AVAIL cotacao-item-cex THEN DO:

                        ASSIGN cotacao-item-cex.val-desp          = tt-desp-rateio.val-desp-unit
                               cotacao-item-cex.cod-pto-contr     = tt-desp-param.cod-pto-contr
                               cotacao-item-cex.cod-cond-pag      = tt-desp-param.cod-cond-pag
                               cotacao-item-cex.data-cotacao-desp = TODAY
                               cotacao-item-cex.usuario           = c-seg-usuario
                               cotacao-item-cex.data-atualiz      = TODAY
                               cotacao-item-cex.hora-atualiz      = STRING(TIME,"HH:MM:SS":U)
                               cotacao-item-cex.motivo-apr        = ""
                               cotacao-item-cex.tp-despesa        = tt-desp-param.tp-despesa.

                        FIND FIRST desp-imp 
                             WHERE desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.

                        IF AVAIL desp-imp AND desp-imp.tipo = 1 /* Valor fixo */ THEN DO:
                            
                            IF  AVAIL tt-desp-param THEN
                                ASSIGN cotacao-item-cex.val-desp = tt-desp-param.val-desp.
                        END.

                        /*--- atualiza despesas influenciadas ---*/
                        RUN imp/imapi006.p(INPUT "cotacao-item-cex":U,  
                                           INPUT ROWID(cotacao-item-cex),
                                           INPUT cotacao-item-cex.cod-desp,
                                           INPUT 0,
                                           INPUT TABLE tt-cotacao-item-cex,
                                           INPUT-OUTPUT TABLE tt-desp-ja-recalc).

                    END.
                    ELSE DO:
                        /*--- efetua criacao da cotacao-item-cex ---*/
                        {cxbo/bocx341.i1 &END=.}

                        FIND CURRENT cotacao-item NO-LOCK NO-ERROR.
                    END.
                END. /* for each tt-ordens-compra... */
            END. /* else do...*/
        END. /* for each tt-pedidos ...*/

        DELETE PROCEDURE h-im0091 NO-ERROR.
        ASSIGN h-im0091 = ?.
    END.

    DELETE PROCEDURE h-bocx085 NO-ERROR.
    ASSIGN h-bocx085 = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDespesasPedido DBOProgram 
PROCEDURE atualizaDespesasPedido :
/*------------------------------------------------------------------------------
  Parameters: pi-transacao (1 = incluir, 2 = alterar, 3 = eliminar)
              pr-rowid-ordem - rowid da ordem de compra
              pi-num-pedido  - numero do pedido de compra
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pi-transacao   AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAM pr-rowid-ordem AS ROWID      NO-UNDO.
    DEFINE INPUT PARAM pi-num-pedido  AS INTEGER    NO-UNDO.
    
    DEFINE VARIABLE rw-despes-ped-compra  AS ROWID                           NO-UNDO.
    DEFINE VARIABLE c-cod-incoterm        LIKE cotacao-item-cex.cod-incoterm NO-UNDO.
    DEFINE VARIABLE de-vl-tot-desp-pedido LIKE desp-imp.val-desp             NO-UNDO.
    DEFINE VARIABLE de-valor-tot-desp     LIKE despes-ped-compra.val-desp    NO-UNDO.

    FOR FIRST ordem-compra FIELDS(numero-ordem it-codigo)
        WHERE ROWID(ordem-compra) = pr-rowid-ordem NO-LOCK: END.
    
    FOR FIRST cotacao-item FIELDS(numero-ordem it-codigo cod-emitente seq-cotac char-1)
        WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
          AND cotacao-item.it-codigo    = ordem-compra.it-codigo
          AND cotacao-item.cot-aprovada = YES NO-LOCK: END.

    IF AVAIL cotacao-item THEN DO:
        
        IF SUBSTRING(cotacao-item.char-1,1,20) <> ""  THEN DO:
            
            IF NOT VALID-HANDLE(h-bocx085) THEN
                RUN cxbo/bocx085.p PERSISTENT SET h-bocx085.

            FOR EACH cotacao-item-cex
               WHERE cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
                 AND cotacao-item-cex.it-codigo    = cotacao-item.it-codigo
                 AND cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente
                 AND cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
                 AND cotacao-item-cex.mapa-cotacao = INT(SUBSTRING(cotacao-item.char-1,1,20)) NO-LOCK:
    
                  RUN retornaValorTotalDespCotada IN h-bocx085 (INPUT ROWID(cotacao-item-cex), OUTPUT de-valor-tot-desp).

                  RUN retornaValorDespesa (INPUT pi-num-pedido, 
                                           INPUT cotacao-item-cex.cod-desp,
                                           INPUT cotacao-item-cex.mo-codigo,
                                           INPUT cotacao-item-cex.cod-emitente-desp,
                                           INPUT cotacao-item-cex.cod-cond-pag,
                                           INPUT cotacao-item-cex.cod-pto-contr,
                                           INPUT cotacao-item-cex.tp-despesa,
                                           OUTPUT rw-despes-ped-compra,
                                           OUTPUT de-vl-tot-desp-pedido).

                  IF pi-transacao = 1 /* incluir */ THEN DO:
                      
                      RUN retornaIncotermRateio (INPUT ROWID(cotacao-item-cex),
                                                 INPUT pi-num-pedido,
                                                 OUTPUT c-cod-incoterm).
    
                      IF de-vl-tot-desp-pedido <> 0 THEN DO:
                          /*--- atualiza despes-ped-compra na base ---*/    
                          RUN emptyRowObject   IN THIS-PROCEDURE.
                          RUN emptyRowErrors   IN THIS-PROCEDURE.
                          RUN openQueryStatic  IN THIS-PROCEDURE (INPUT "main":U).
                          RUN repositionRecord IN THIS-PROCEDURE (INPUT rw-despes-ped-compra).
                          IF RETURN-VALUE = "NOK":U THEN 
                              NEXT.

                          RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE rowObject).

                          FIND FIRST rowObject NO-ERROR.
                          IF NOT AVAIL rowObject THEN 
                              NEXT.

                          FIND FIRST desp-imp 
                               WHERE desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.

                          IF  AVAIL desp-imp AND desp-imp.tipo = 1 /* valor fixo */ THEN
                              ASSIGN rowObject.val-desp = de-valor-tot-desp.
                          ELSE
                              ASSIGN rowObject.val-desp = de-valor-tot-desp + de-vl-tot-desp-pedido.

                          RUN setRecord    IN THIS-PROCEDURE (INPUT TABLE rowObject).
                          RUN updateRecord IN THIS-PROCEDURE.
                          /*--- fim atualizacao despes-ped-compra ---*/
                      END.
                      ELSE DO:
                          /*--- cria despes-ped-compra na base ---*/    
                          RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
                          RUN getFirst IN THIS-PROCEDURE.
                          RUN emptyRowObject IN THIS-PROCEDURE.
                          RUN emptyRowErrors IN THIS-PROCEDURE.
                          CREATE rowObject.
                          ASSIGN rowObject.num-pedido        = pi-num-pedido
                                 rowObject.cod-desp          = cotacao-item-cex.cod-desp
                                 rowObject.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp
                                 rowObject.cod-incoterm-rat  = c-cod-incoterm
                                 rowObject.cod-pto-contr     = cotacao-item-cex.cod-pto-contr
                                 rowObject.cod-cond-pag      = cotacao-item-cex.cod-cond-pag
                                 rowObject.mo-codigo         = cotacao-item-cex.mo-codigo
                                 rowObject.tp-despesa        = cotacao-item-cex.tp-despesa
                                 rowObject.val-desp          = de-valor-tot-desp.

                          RUN sugereSeqDespesa IN THIS-PROCEDURE (INPUT pi-num-pedido, OUTPUT rowObject.sequencia).

                          RUN setRecord    IN THIS-PROCEDURE (INPUT TABLE rowObject).
                          RUN createRecord IN THIS-PROCEDURE.
                          /*--- fim criacao despes-ped-compra ---*/
                      END.
                  END. 
                  ELSE IF pi-transacao = 3 /* eliminar */ THEN DO:
    
                      IF  (de-vl-tot-desp-pedido - de-valor-tot-desp) <= 0 THEN DO:
                          /*--- elimina despes-ped-compra na base ---*/    
                          RUN emptyRowErrors   IN THIS-PROCEDURE.
                          RUN openQueryStatic  IN THIS-PROCEDURE (INPUT "main":U).
                          RUN repositionRecord IN THIS-PROCEDURE (INPUT rw-despes-ped-compra).
                          IF RETURN-VALUE = "NOK":U THEN 
                              NEXT.
                          RUN deleteRecord IN THIS-PROCEDURE.
                          /*--- fim eliminacao despes-ped-compra ---*/
                      END.
                      ELSE DO:
                          /*--- atualiza despes-ped-compra na base ---*/    
                          RUN emptyRowObject   IN THIS-PROCEDURE.
                          RUN emptyRowErrors   IN THIS-PROCEDURE.
                          RUN openQueryStatic  IN THIS-PROCEDURE (INPUT "main":U).
                          RUN repositionRecord IN THIS-PROCEDURE (INPUT rw-despes-ped-compra).
                          IF RETURN-VALUE = "NOK":U THEN 
                              NEXT.
                          
                          RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE rowObject).
                          
                          FIND FIRST rowObject NO-ERROR.
                          IF NOT AVAIL rowObject THEN 
                              NEXT.

                          ASSIGN rowObject.val-desp = de-vl-tot-desp-pedido - de-valor-tot-desp.

                          RUN setRecord    IN THIS-PROCEDURE (INPUT TABLE rowObject).
                          RUN updateRecord IN THIS-PROCEDURE.
                          /*--- fim atualizacao despes-ped-compra ---*/
                      END.
                  END.
            END.
    
            DELETE PROCEDURE h-bocx085 NO-ERROR.
            ASSIGN h-bocx085 = ?.
        END.
    END.

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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-incoterm-rat":U THEN ASSIGN pFieldValue = RowObject.cod-incoterm-rat.
        WHEN "cod-livre-1":U      THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U      THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE      NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL   NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "val-desp":U THEN ASSIGN pFieldValue = RowObject.val-desp.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIncoterm DBOProgram 
PROCEDURE getIncoterm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-pedido AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-incoterm   AS CHARACTER NO-UNDO.

    FIND FIRST ordem-compra
        WHERE ordem-compra.num-pedido = p-num-pedido NO-LOCK  NO-ERROR.

    IF AVAIL ordem-compra THEN DO:
        FIND FIRST cotacao-item
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
               AND cotacao-item.it-codigo    = ordem-compra.it-codigo
               AND cotacao-item.cot-aprovada = YES NO-LOCK NO-ERROR.

        IF AVAIL cotacao-item THEN
            ASSIGN p-incoterm = TRIM(SUBSTRING(cotacao-item.char-1,21,20)).
    END.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER      NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-cond-pag":U       THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-desp":U           THEN ASSIGN pFieldValue = RowObject.cod-desp.
        WHEN "cod-emitente-desp":U  THEN ASSIGN pFieldValue = RowObject.cod-emitente-desp.
        WHEN "cod-pto-contr":U      THEN ASSIGN pFieldValue = RowObject.cod-pto-contr.
        WHEN "mo-codigo":U          THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "num-livre-1":U        THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U        THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-pedido":U         THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "sequencia":U          THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "tp-despesa":U         THEN ASSIGN pFieldValue = RowObject.tp-despesa.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dspspdcm-id
  Parameters:  
               retorna valor do campo num-pedido
               retorna valor do campo sequencia
               retorna valor do campo cod-desp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-pedido LIKE despes-ped-compra.num-pedido   NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia  LIKE despes-ped-compra.sequencia    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-desp   LIKE despes-ped-compra.cod-desp     NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-pedido = RowObject.num-pedido
           psequencia = RowObject.sequencia
           pcod-desp = RowObject.cod-desp.

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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL      NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-despes-ped":U THEN ASSIGN pFieldValue = RowObject.log-despes-ped.  
        WHEN "log-livre-1":U    THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U    THEN ASSIGN pFieldValue = RowObject.log-livre-2.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW          NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTtBoErro DBOProgram 
PROCEDURE getTtBoErro :
/*------------------------------------------------------------------------------
  Purpose: Retornar a temp-table de erro    
  Parameters:  OUTPUT TABLE - temp-table de erro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice dspspdcm-id
  Parameters:  
               recebe valor do campo num-pedido
               recebe valor do campo sequencia
               recebe valor do campo cod-desp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-pedido  LIKE despes-ped-compra.num-pedido   NO-UNDO.
    DEFINE INPUT PARAMETER psequencia   LIKE despes-ped-compra.sequencia    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-desp    LIKE despes-ped-compra.cod-desp     NO-UNDO.

    FIND FIRST bfdespes-ped-compra 
         WHERE bfdespes-ped-compra.num-pedido = pnum-pedido 
           AND bfdespes-ped-compra.sequencia  = psequencia 
           AND bfdespes-ped-compra.cod-desp   = pcod-desp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdespes-ped-compra THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdespes-ped-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToPedido-compr DBOProgram 
PROCEDURE linkToPedido-compr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
    RUN getKey IN pHandle (OUTPUT iNumPedido).
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK 
         INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedido DBOProgram 
PROCEDURE openQueryPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK 
        WHERE {&tableName}.num-pedido = iNumPedido
        INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDespesaImposto DBOProgram 
PROCEDURE retornaDespesaImposto :
/*------------------------------------------------------------------------------
  Purpose:     Retorna se a despesa Ç imposto 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Definicao de Parametros */
    DEFINE INPUT  PARAMETER pNum-pedido      LIKE despes-ped-compra.num-pedido NO-UNDO.
    DEFINE INPUT  PARAMETER pCod-desp        LIKE despes-ped-compra.cod-desp   NO-UNDO.
    DEFINE INPUT  PARAMETER pCod-Estabel-ini LIKE param-imp.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER pCod-Estabel-fim LIKE param-imp.cod-estabel        NO-UNDO.
    DEFINE INPUT  PARAMETER pOpcao           AS INTEGER                        NO-UNDO.
    DEFINE OUTPUT PARAMETER pLog-imposto     AS LOGICAL                        NO-UNDO.

    ASSIGN pLog-imposto = NO.

    IF pOpcao = 1 THEN DO:
        FOR EACH ordem-compra
           WHERE ordem-compra.num-pedido = pNum-pedido NO-LOCK:

            FIND FIRST param-imp
                 WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

            FIND FIRST param-imp-trib
                 WHERE param-imp-trib.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
                 
            IF AVAIL param-imp THEN DO:
                {cdp/cd4300.i4 "yes" param-imp.char-1}
                {cxbo/bocx250.i51 "yes"}

                IF pCod-desp = param-imp.cdn-despes-impto-ipi    
                OR pCod-desp = param-imp.cdn-despes-impto-pis    
                OR pCod-desp = param-imp.cdn-despes-impto-cofins 
                OR pCod-desp = param-imp.cdn-despes-impto-icms   
                OR pCod-desp = i-desp-ii-i50                     
                OR pCod-desp = INT(TRIM(SUBSTRING(param-imp.char-1,21,20)))
                OR (l-nt2024002 AND AVAIL param-imp-trib AND pCod-desp = param-imp-trib.cdn-despes-impto-IBSUF)
                OR (l-nt2024002 AND AVAIL param-imp-trib AND pCod-desp = param-imp-trib.cdn-despes-impto-IBSMun)
                OR (l-nt2024002 AND AVAIL param-imp-trib AND pCod-desp = param-imp-trib.cdn-despes-impto-CBS) 
                OR (l-nt2024002 AND AVAIL param-imp-trib AND pCod-desp = param-imp-trib.cdn-despes-impto-IS) THEN   
                    ASSIGN pLog-imposto = YES.
            END.
        END.
    END.
    ELSE DO:
        IF  pOpcao = 2 THEN DO:
            FOR EACH param-imp
               WHERE param-imp.cod-estabel >= pCod-Estabel-ini 
                 AND param-imp.cod-estabel <= pCod-Estabel-fim NO-LOCK:

                FIND FIRST param-imp-trib
                     WHERE param-imp-trib.cod-estabel = param-imp.cod-estabel NO-LOCK NO-ERROR.
                 
                {cdp/cd4300.i4 "yes" param-imp.char-1}
                {cxbo/bocx250.i51 "yes"}

                IF pCod-desp = param-imp.cdn-despes-impto-ipi    
                OR pCod-desp = param-imp.cdn-despes-impto-pis    
                OR pCod-desp = param-imp.cdn-despes-impto-cofins 
                OR pCod-desp = param-imp.cdn-despes-impto-icms   
                OR pCod-desp = i-desp-ii-i50                     
                OR pCod-desp = INT(TRIM(SUBSTRING(param-imp.char-1,21,20)))
                OR (l-nt2024002 AND AVAIL param-imp-trib AND pCod-desp = param-imp-trib.cdn-despes-impto-IBSUF)
                OR (l-nt2024002 AND AVAIL param-imp-trib AND pCod-desp = param-imp-trib.cdn-despes-impto-IBSMun)
                OR (l-nt2024002 AND AVAIL param-imp-trib AND pCod-desp = param-imp-trib.cdn-despes-impto-CBS)
                OR (l-nt2024002 AND AVAIL param-imp-trib AND pCod-desp = param-imp-trib.cdn-despes-impto-IS) THEN  
                    ASSIGN pLog-imposto = YES.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaIncotermRateio DBOProgram 
PROCEDURE retornaIncotermRateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pr-rowid-cot-it-cex AS ROWID                 NO-UNDO.
    DEFINE INPUT  PARAMETER pi-num-pedido       AS INTEGER               NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-cod-incoterm     LIKE inco-cx.cod-incoter NO-UNDO.
    
    DEFINE VARIABLE l-busca-incoterm AS LOGICAL INITIAL YES NO-UNDO.

    FIND FIRST cotacao-item-cex
         WHERE ROWID(cotacao-item-cex) = pr-rowid-cot-it-cex NO-LOCK NO-ERROR.

    IF AVAIL cotacao-item-cex THEN DO:

        FOR FIRST ordem-compra FIELDS (cod-estabel)
            WHERE ordem-compra.numero-ordem = cotacao-item-cex.numero-ordem NO-LOCK: END.

        IF AVAIL ordem-compra THEN DO:
            FOR FIRST param-imp FIELDS(char-1 cdn-despes-impto-ipi cdn-despes-impto-pis cdn-despes-impto-cofins cdn-despes-impto-icms)
                WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK: END.
            FIND FIRST param-imp-trib 
                 WHERE param-imp-trib.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
        END.

        /*--- verifica se a despesa eh imposto ---*/
        IF  AVAIL param-imp 
        AND (   INT(trim(SUBSTR(param-imp.char-1,21,20))) = cotacao-item-cex.cod-desp
             OR param-imp.cdn-despes-impto-ipi      = cotacao-item-cex.cod-desp
             OR param-imp.cdn-despes-impto-pis      = cotacao-item-cex.cod-desp
             OR param-imp.cdn-despes-impto-cofins   = cotacao-item-cex.cod-desp
             OR param-imp.cdn-despes-impto-icms     = cotacao-item-cex.cod-desp
             OR (l-nt2024002 AND AVAIL param-imp-trib AND param-imp-trib.cdn-despes-impto-IBSUF  = cotacao-item-cex.cod-desp)
             OR (l-nt2024002 AND AVAIL param-imp-trib AND param-imp-trib.cdn-despes-impto-IBSMun = cotacao-item-cex.cod-desp)
             OR (l-nt2024002 AND AVAIL param-imp-trib AND param-imp-trib.cdn-despes-impto-CBS    = cotacao-item-cex.cod-desp) 
             OR (l-nt2024002 AND AVAIL param-imp-trib AND param-imp-trib.cdn-despes-impto-IS     = cotacao-item-cex.cod-desp) ) THEN   
             RETURN "OK":U.

        FOR FIRST desp-imp FIELDS(tipo cod-desp cod-incoterm-rat) 
            WHERE desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK: END.

        IF  AVAIL desp-imp
        AND (   desp-imp.tipo = 3 /* taxa sobre peso */
             OR desp-imp.tipo = 6 /* taxa sobre qtde */
             OR desp-imp.tipo = 9) /* taxa sobre cubagem */ THEN
            RETURN "OK":U.

        FIND FIRST bfdespes-ped-compra
             WHERE bfdespes-ped-compra.num-pedido = pi-num-pedido
               AND bfdespes-ped-compra.cod-desp   = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.
        IF  AVAIL bfdespes-ped-compra THEN DO:
            ASSIGN pc-cod-incoterm = bfdespes-ped-compra.cod-incoterm-rat.
            RETURN "OK":U.
        END.
            
        FIND FIRST cot-ordem
             WHERE cot-ordem.cod-emitente  = cotacao-item-cex.cod-emitente
               AND cot-ordem.numero-ordem  = cotacao-item-cex.numero-ordem
               AND cot-ordem.seq-cotac     = cotacao-item-cex.seq-cotac
               AND cot-ordem.mapa-aprovado = YES NO-LOCK NO-ERROR.

        IF  AVAIL cot-ordem THEN DO:
            FIND FIRST desp-cot-ordem
                 WHERE desp-cot-ordem.cod-agrup         = cot-ordem.cod-agrup
                   AND desp-cot-ordem.mapa-ordem        = cot-ordem.mapa-ordem
                   AND desp-cot-ordem.cod-desp          = cotacao-item-cex.cod-desp
                   AND desp-cot-ordem.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp NO-LOCK NO-ERROR.

            IF  AVAIL desp-cot-ordem THEN DO:
                ASSIGN pc-cod-incoterm = desp-cot-ordem.cod-incoterm-rat.
                RETURN "OK":U.
            END.
        END.

        IF  NOT AVAIL desp-imp
        OR  (    AVAIL desp-imp
             AND desp-imp.cod-desp <> cotacao-item-cex.cod-desp) THEN
            FIND desp-imp WHERE
                 desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.

        IF  AVAIL desp-item THEN DO:
            ASSIGN pc-cod-incoterm = desp-imp.cod-incoterm-rat.
            RETURN "OK":U.
        END.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaValorDespesa DBOProgram 
PROCEDURE retornaValorDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-num-pedido    LIKE pedido-compr.num-pedido          NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-desp      LIKE desp-imp.cod-desp                NO-UNDO.
    DEFINE INPUT  PARAMETER pi-mo-codigo     LIKE cotacao-item-cex.mo-codigo       NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-emitente  LIKE cotacao-item-cex.cod-emitente    NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-cond-pag  LIKE cotacao-item-cex.cod-cond-pag    NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-pto-contr LIKE cotacao-item-cex.cod-pto-contr   NO-UNDO.
    DEFINE INPUT  PARAMETER pi-tp-desp       LIKE cotacao-item-cex.tp-desp         NO-UNDO.
    DEFINE OUTPUT PARAMETER pr-rowid-table   AS   ROWID                            NO-UNDO.
    DEFINE OUTPUT PARAMETER pd-val-desp      LIKE despes-ped-compra.val-desp       NO-UNDO.

    FIND FIRST bfdespes-ped-compra
         WHERE bfdespes-ped-compra.num-pedido        = pi-num-pedido
           AND bfdespes-ped-compra.cod-desp          = pc-cod-desp
           AND bfdespes-ped-compra.mo-codigo         = pi-mo-codigo
           AND bfdespes-ped-compra.cod-emitente-desp = pi-cod-emitente
           AND bfdespes-ped-compra.cod-cond-pag      = pi-cod-cond-pag
           AND bfdespes-ped-compra.cod-pto-contr     = pi-cod-pto-contr
           AND bfdespes-ped-compra.tp-despesa        = pi-tp-desp NO-LOCK NO-ERROR.

    IF AVAIL bfdespes-ped-compra THEN
        ASSIGN pd-val-desp    = bfdespes-ped-compra.val-desp
               pr-rowid-table = ROWID(bfdespes-ped-compra).
    ELSE DO:
        ASSIGN pd-val-desp = 0.
        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaValorMoedaParamDespesa DBOProgram 
PROCEDURE retornaValorMoedaParamDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pi-num-pedido LIKE pedido-compr.num-pedido     NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-desp   LIKE despes-ped-compra.cod-desp  NO-UNDO.
    DEFINE INPUT  PARAMETER pi-seq        LIKE despes-ped-compra.sequencia NO-UNDO.
    DEFINE INPUT  PARAMETER pi-mo-codigo  LIKE moeda.mo-codigo             NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-ordem-desp.
    
    DEFINE VARIABLE de-valor-tot-desp LIKE despes-ped-compra.val-desp NO-UNDO.
    DEFINE VARIABLE de-vl-convertido  LIKE despes-ped-compra.val-desp NO-UNDO.

    EMPTY TEMP-TABLE tt-ordem-desp.

    IF NOT VALID-HANDLE(h-bocx085) THEN
        RUN cxbo/bocx085.p PERSISTENT SET h-bocx085.

    FOR EACH ordem-compra
       WHERE ordem-compra.num-pedido = pi-num-pedido NO-LOCK:
        
        FIND FIRST cotacao-item
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
               AND cotacao-item.it-codigo    = ordem-compra.it-codigo
               AND cotacao-item.cot-aprovada = YES NO-LOCK NO-ERROR.

        IF AVAIL cotacao-item THEN DO:

            FOR EACH  cotacao-item-cex
               WHERE cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
                 AND cotacao-item-cex.it-codigo    = cotacao-item.it-codigo   
                 AND cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente
                 AND cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
                 AND cotacao-item-cex.cod-desp     = pi-cod-desp
                 AND cotacao-item-cex.mapa-cotacao = INT(SUBSTRING(cotacao-item.char-1,1,20)) NO-LOCK:
                  
                RUN retornaValorTotalDespCotada IN h-bocx085 (INPUT ROWID(cotacao-item-cex), OUTPUT de-valor-tot-desp).

                IF pi-mo-codigo <> cotacao-item-cex.mo-codigo THEN
                    RUN cdp/cd0812.p (INPUT  cotacao-item-cex.mo-codigo,
                                      INPUT  pi-mo-codigo,
                                      INPUT  de-valor-tot-desp,
                                      INPUT  cotacao-item-cex.data-cotacao,
                                      OUTPUT de-vl-convertido).
                ELSE
                    ASSIGN de-vl-convertido = de-valor-tot-desp.

                FIND FIRST tt-ordem-desp 
                     WHERE tt-ordem-desp.cod-desp          = cotacao-item-cex.cod-desp         
                       AND tt-ordem-desp.mo-codigo         = cotacao-item-cex.mo-codigo        
                       AND tt-ordem-desp.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp
                       AND tt-ordem-desp.cod-cond-pag      = cotacao-item-cex.cod-cond-pag     
                       AND tt-ordem-desp.cod-pto-contr     = cotacao-item-cex.cod-pto-contr    
                       AND tt-ordem-desp.tp-despesa        = cotacao-item-cex.tp-despesa NO-ERROR.

                IF NOT AVAIL tt-ordem-desp THEN DO:
                    CREATE tt-ordem-desp.
                    ASSIGN tt-ordem-desp.cod-desp          = cotacao-item-cex.cod-desp         
                           tt-ordem-desp.sequencia         = pi-seq
                           tt-ordem-desp.mo-codigo         = cotacao-item-cex.mo-codigo        
                           tt-ordem-desp.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp
                           tt-ordem-desp.cod-cond-pag      = cotacao-item-cex.cod-cond-pag     
                           tt-ordem-desp.cod-pto-contr     = cotacao-item-cex.cod-pto-contr    
                           tt-ordem-desp.tp-despesa        = cotacao-item-cex.tp-despesa.
                END.

                FIND FIRST desp-imp 
                     WHERE desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.

                IF AVAIL desp-imp AND desp-imp.tipo = 1 /* valor fixo */ THEN
                    ASSIGN tt-ordem-desp.val-desp = de-vl-convertido.
                ELSE
                    ASSIGN tt-ordem-desp.val-desp = tt-ordem-desp.val-desp + de-vl-convertido.
            END.
        END.
    END.

    DELETE PROCEDURE h-bocx085 NO-ERROR.
    ASSIGN h-bocx085 = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAtualizaDespesasOrdem DBOProgram 
PROCEDURE setAtualizaDespesasOrdem :
/*------------------------------------------------------------------------------
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-reposiciona-registro AS LOGICAL NO-UNDO. 
    
    ASSIGN l-reposiciona-registro = p-reposiciona-registro. 
           
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereSeqDespesa DBOProgram 
PROCEDURE sugereSeqDespesa :
/*------------------------------------------------------------------------------
  Purpose: Sugerir a proxima sequencia de despesa para o pedido    
  Parameters: input  pi-num-pedido: pedido que ser† inclusa nova despesa
              output pi-sequencia: nova sequencia a ser utilizada
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-num-pedido LIKE pedido-compr.num-pedido     NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-sequencia  LIKE despes-ped-compra.sequencia NO-UNDO.

    FOR LAST  bfDespes-ped-compra FIELDS(sequencia) USE-INDEX dspspdcm-id
        WHERE bfDespes-ped-compra.num-pedido = pi-num-pedido NO-LOCK: END.

    IF  AVAIL bfDespes-ped-compra THEN
        ASSIGN pi-sequencia = bfDespes-ped-compra.sequencia + 1.
    ELSE
        ASSIGN pi-sequencia = 1.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDespesaUsuario DBOProgram 
PROCEDURE validateDespesaUsuario :
/*------------------------------------------------------------------------------
  Purpose:    verifica se tem despesa cotaca automaticamente, parametrizada para n∆o ser alterada, e se o  
              usuario estah parametrizado para alterar despesas cotadas automaticamente  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH ordem-compra
       WHERE ordem-compra.num-pedido = rowObject.num-pedido NO-LOCK:
        
        FIND FIRST cotacao-item
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
               AND cotacao-item.it-codigo    = ordem-compra.it-codigo
               AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.
    
        IF AVAIL cotacao-item THEN DO:
    
            FIND FIRST cotacao-item-cex 
                 WHERE cotacao-item-cex.numero-ordem    = cotacao-item.numero-ordem
                   AND cotacao-item-cex.cod-emitente    = cotacao-item.cod-emitente
                   AND cotacao-item-cex.it-codigo       = cotacao-item.it-codigo
                   AND cotacao-item-cex.seq-cotac       = cotacao-item.seq-cotac
                   AND cotacao-item-cex.mapa-cotacao    = INT(SUBSTRING(cotacao-item.char-1,1,20))
                   AND cotacao-item-cex.log-gerac-autom = YES
                   AND cotacao-item-cex.cod-desp = rowObject.cod-desp NO-LOCK NO-ERROR.
    
             IF AVAIL cotacao-item-cex THEN DO:
                 
                 FIND FIRST desp-imp 
                      WHERE desp-imp.cod-desp                = cotacao-item-cex.cod-desp 
                        AND desp-imp.log-permite-alter-cotac = NO NO-LOCK NO-ERROR.
    
                 IF AVAIL desp-imp THEN DO:
    
                     FIND FIRST usuar-import 
                          WHERE usuar-import.cod-usuar = c-seg-usuario NO-LOCK NO-ERROR.

                     IF NOT AVAIL usuar-import OR log-permite-alter-cotac-despes = NO THEN DO:
    
                         /* Mensagem: Usu†rio &1 n∆o possui permiss∆o para alteraá∆o / eliminaá∆o. */
                         {method/svc/errors/inserr.i
                                             &ErrorNumber="30099"
                                             &ErrorType="EMS":U
                                             &ErrorSubType="ERROR":U 
                                             &ErrorParameters="c-seg-usuario + '~~~~' + string(rowObject.cod-desp)"}
                                             
                          RETURN "NOK":U.
                     END.
                 END. /* if avail desp-imp...*/    
             END. /* if avail cotacao-item-cex...*/
        END. /* if avail cotacao-item...*/
    END. /* for each ordem-compra...*/
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatePedidoCompr DBOProgram 
PROCEDURE validatePedidoCompr :
/*------------------------------------------------------------------------------
  Purpose: Validar pedido de compra (utilizado na inclusao de despesas no im0300 e
           no v† para deste programa).
  Parameters:  input pi-num-pedido.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    FIND FIRST pedido-compr
         WHERE pedido-compr.num-pedido = pi-num-pedido NO-LOCK NO-ERROR.

    IF NOT AVAIL pedido-compr THEN DO:
        
        /* Mensagem: N∆o encontrado (a) Pedido de Compra para chave informada. */
        {utp/ut-liter.i "Pedido_de_Compra" *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}

    END.
    ELSE DO:

        FIND FIRST emitente
             WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK NO-ERROR.

        IF AVAIL emitente AND emitente.natureza <= 2 THEN DO:

            /* Mensagem: Fornecedor &1 do pedido &2 deve ser estrangeiro ou trading. */
            {method/svc/errors/inserr.i
                                &ErrorNumber="30220"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U 
                                &ErrorParameters="string(emitente.cod-emitente)+ '~~~~' + string(pedido-compr.num-pedido)"}
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateProcessoImp DBOProgram 
PROCEDURE validateProcessoImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-valida-processo AS LOGICAL NO-UNDO.

    ASSIGN l-valida-processo = pl-valida-processo.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem  executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    ASSIGN l-desp-imposto = NO.
    IF pType = "Create":U THEN DO:

        IF  CAN-FIND (FIRST bf{&TableName}
                      WHERE bf{&TableName}.num-pedido        = RowObject.num-pedido 
                        AND bf{&TableName}.sequencia         = RowObject.sequencia  
                        AND bf{&TableName}.cod-desp          = RowObject.cod-desp   
                        AND bf{&TableName}.mo-codigo         = RowObject.mo-codigo  
                        AND bf{&TableName}.cod-emitente-desp = RowObject.cod-emitente-desp 
                        AND bf{&TableName}.cod-cond-pag      = RowObject.cod-cond-pag 
                        AND bf{&TableName}.cod-pto-contr     = RowObject.cod-pto-contr 
                        AND bf{&TableName}.tp-despesa        = RowObject.tp-despesa NO-LOCK) THEN DO:

            {utp/ut-liter.i "Despesa_do_pedido" *}
            {method/svc/errors/inserr.i &ErrorNumber="8"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="TRIM(RETURN-VALUE) + ' ' + string(RowObject.num-pedido)"}
        END.
    END.

    IF pType = "Create":U
    OR pType = "Update":U THEN DO:

        RUN validatePedidoCompr(INPUT rowObject.num-pedido).

        IF NOT CAN-FIND(FIRST desp-imp
                        WHERE desp-imp.cod-desp = rowObject.cod-desp) THEN DO:

            /* Mensagem: N∆o encontrado (a) &1 para chave informada. */
            {utp/ut-liter.i "despesa" *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        IF NOT CAN-FIND(FIRST moeda
                        WHERE moeda.mo-codigo = rowObject.mo-codigo) THEN DO:

            /* Mensagem: N∆o encontrado (a) &1 para chave informada. */
            {utp/ut-liter.i "moeda" *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        IF NOT CAN-FIND(FIRST emitente
                        WHERE emitente.cod-emitente = rowObject.cod-emitente-desp) THEN DO:
            
            /* Mensagem: N∆o encontrado (a) &1 para chave informada. */
            {utp/ut-liter.i "emitente" *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        IF CAN-FIND(FIRST emitente
                    WHERE emitente.cod-emitente = rowObject.cod-emitente-desp
                      AND emitente.identific    = 1 /* cliente */ ) THEN DO:

            /* Mensagem: Emitente n∆o pode ser cliente. */
            {method/svc/errors/inserr.i &ErrorNumber="8738"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        END.
        
        IF rowObject.cod-cond-pag = 0
        OR NOT CAN-FIND(FIRST cond-pagto
                        WHERE cond-pagto.cod-cond-pag = rowObject.cod-cond-pag) THEN DO:

            /* Mensagem: N∆o encontrado (a) &1 para chave informada. */
            {utp/ut-liter.i "condiá∆o_de_pagamento" *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        IF NOT CAN-FIND(FIRST pto-contr
                        WHERE pto-contr.cod-pto-contr = rowObject.cod-pto-contr) THEN DO:

            /* Mensagem: N∆o encontrado (a) &1 para chave informada. */
            {utp/ut-liter.i "ponto_de_controle" *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        /*--- valida o processo somente quando a despesa for inclu°da manualmente (im0300 ou im0017) ---*/

        IF l-valida-processo THEN DO:

            FIND FIRST processo-imp
                 WHERE processo-imp.num-pedido = rowObject.num-pedido NO-LOCK NO-ERROR.
    
            IF AVAIL processo-imp THEN DO:
    
                FIND FIRST itinerario
                     WHERE itinerario.cod-itiner = processo-imp.cod-itiner NO-LOCK NO-ERROR.
    
                IF AVAIL itinerario THEN DO:
    
                    IF NOT CAN-FIND(FIRST pto-itiner
                                     WHERE pto-itiner.cod-itiner    = itinerario.cod-itiner
                                       AND pto-itiner.cod-pto-contr = rowObject.cod-pto-contr) THEN DO:

                        /* Mensagem: Ponto de controle base &1 nao pertence ao itininerario &2. */
                        {method/svc/errors/inserr.i &ErrorNumber="30222"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U 
                                                    &ErrorParameters="string(rowObject.cod-pto-contr) + '~~~~' + string(processo-imp.cod-itiner)"}
    
                    END.
                END.
            END.
            ELSE DO:
                /* Mensagem: Pedido &1 n∆o possui processo de importaá∆o vinculado. */
                {method/svc/errors/inserr.i &ErrorNumber="30224"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U 
                                            &ErrorParameters="string(rowObject.num-pedido)"}
            END.
        END.

        IF rowObject.cod-incoterm-rat <> "" THEN DO:

            IF NOT CAN-FIND(FIRST inco-cx
                            WHERE inco-cx.cod-incoterm = rowObject.cod-incoterm-rat) THEN DO:

                /* Mensagem: N∆o encontrado (a) &1 para chave informada. */
                {utp/ut-liter.i "incoterm" *}
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U 
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.

            IF CAN-FIND(FIRST desp-incoterm
                        WHERE desp-incoterm.cod-incoterm = rowObject.cod-incoterm-rat
                          AND desp-incoterm.cod-desp     = rowObject.cod-desp) THEN DO:

                /* Descriá∆o: A incoterm de rateio informada n∆o deve conter em sua parametrizaá∆o a pr¢pria despesa a ser rateada &2. */
                {method/svc/errors/inserr.i &ErrorNumber="30164"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U 
                                            &ErrorParameters="string(rowObject.cod-incoterm-rat) + '~~~~' + string(rowObject.cod-desp)"}
            END.
            
            FIND FIRST bfDespes-ped-compra 
                 WHERE bfDespes-ped-compra.num-pedido        = rowObject.num-pedido
                   AND bfDespes-ped-compra.cod-desp          = rowObject.cod-desp
                   AND bfDespes-ped-compra.cod-incoterm-rat <> rowObject.cod-incoterm-rat 
                   AND (   pType = "create":U
                        OR (    ptype = "update":U
                            AND ROWID(bfDespes-ped-compra) <> rowObject.r-rowid)) NO-LOCK NO-ERROR.

            IF AVAIL bfDespes-ped-compra THEN DO:

                /* Descriá∆o: J† existe a incoterm de rateio &2 informada para esta mesma despesa / pedido &3. */
                {method/svc/errors/inserr.i &ErrorNumber="30230"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U 
                                            &ErrorParameters="string(rowObject.cod-incoterm-rat) + '~~~~' + string(bfDespes-ped-compra.cod-incoterm-rat) + '~~~~' + string(rowObject.num-pedido)"}
            END.
        END.

        IF rowObject.val-desp <= 0 THEN DO:
            RUN retornaDespesaImposto (INPUT  rowObject.num-pedido,
                                       INPUT  rowObject.cod-desp,
                                       INPUT  "",
                                       INPUT  "",
                                       INPUT  1,
                                       OUTPUT l-desp-imposto).
            IF NOT l-desp-imposto THEN DO:
                /* Mensagem: Valor deve ser maior que zero. */
                {method/svc/errors/inserr.i &ErrorNumber="28569"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U}
            END.
        END.

        IF NOT CAN-FIND(FIRST tipo-rec-desp
                        WHERE tipo-rec-desp.tp-codigo = rowObject.tp-despesa) THEN DO:
            /* Mensagem: Tipo de despesa n∆o cadastrado. */
            {method/svc/errors/inserr.i &ErrorNumber="3866"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        END.

        IF CAN-FIND(FIRST tipo-rec-desp
                    WHERE tipo-rec-desp.tp-codigo = rowObject.tp-despesa
                      AND tipo-rec-desp.tipo = 1 /*receita*/) THEN DO:

            /* Descriá∆o: O tipo de despesa n∆o pode ser receita. */
            {method/svc/errors/inserr.i &ErrorNumber="4995"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U}
        END.
    END.

    IF pType = "Delete":U
    OR pType = "Update":U THEN DO:
        RUN validateDespesaUsuario.

        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END. /* if update or delete...*/

    IF NOT VALID-HANDLE(h-bocx225) THEN
        RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.

    IF VALID-HANDLE(h-bocx225) THEN DO:
        RUN procuraEmbarqueCompras IN h-bocx225(INPUT rowObject.num-pedido,
                                                INPUT ?,
                                                INPUT ?,
                                                OUTPUT TABLE tt-embarque).
    
        IF CAN-FIND(FIRST tt-embarque) THEN DO:

            ASSIGN c-lista-embarques = "".

            FOR EACH tt-embarque:
                ASSIGN c-lista-embarques = IF c-lista-embarques <> "" THEN 
                                              "," + tt-embarque.embarque
                                           ELSE
                                               tt-embarque.embarque.
            END.

            /* Mensagem: Atená∆o: Compra possui embarques relacionados. */
            {utp/ut-liter.i "Despesas_do_Embarque" *}
            {method/svc/errors/inserr.i &ErrorNumber="28558"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="INFORMATION":U 
                                        &ErrorParameters="c-lista-embarques + '~~~~' + ' ' + TRIM(RETURN-VALUE)"}
        END.

        DELETE PROCEDURE h-bocx225 NO-ERROR.
        ASSIGN h-bocx225 = ?.
    END.

    FOR EACH rowErrors 
       WHERE rowErrors.errorType = "INTERNAL":U
         AND (rowErrors.errorNumber = 8 OR rowErrors.errorNumber = 11):
        DELETE rowErrors.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDespesasOrdemQtdAlterada DBOProgram 
PROCEDURE atualizaDespesasOrdemQtdAlterada :
/*------------------------------------------------------------------------------
  Purpose:   Realiza o rateio das despesas nas ordens de compra (unit†rio) 
             para as despesas que foram inseridas no pedido (Total) quando h† 
             alteraá∆o da quantidade da ordem
  Parameters: pi-num-pedido - N£mero do pedido - inteiro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    EMPTY TEMP-TABLE tt-pedidos.
    
    CREATE tt-pedidos.
    ASSIGN tt-pedidos.num-pedido = pi-num-pedido.

    FOR EACH bf{&TableName} 
       WHERE bf{&TableName}.num-pedido = pi-num-pedido NO-LOCK:

        /*Despesa inserida no pedido (Valor Total)*/
        IF bf{&TableName}.log-despes-ped THEN DO:
            EMPTY TEMP-TABLE tt-desp-param.

            CREATE tt-desp-param.
            BUFFER-COPY bf{&TableName} TO tt-desp-param NO-ERROR.

            RUN atualizaDespesasOrdem (INPUT 2, /*Alteraá∆o*/
                                       INPUT 1,/*Somente ordens que possuem a despesa*/
                                       INPUT bf{&TableName}.cod-cond-pag,
                                       INPUT bf{&TableName}.cod-pto-contr,
                                       INPUT bf{&TableName}.tp-despesa,
                                       INPUT TABLE tt-desp-param,
                                       INPUT TABLE tt-pedidos).
        END.
    END.
  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

