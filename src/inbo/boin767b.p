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
{include/i-prgvrs.i BOIN767B 2.00.00.085 } /*** "010085" 08/07/2026 14:36:54 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin767b MUT}
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
&GLOBAL-DEFINE DBOName boin767b
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-doc-pend-aprov
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver f {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin767.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{cdp/cd0020.i} 

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF TEMP-TABLE tt{&TableName} NO-UNDO
    LIKE {&TableName}
    FIELD rrowid AS ROWID
    INDEX rrowid   rrowid
    INDEX situacao ind-situacao.

def temp-table tt-lista NO-UNDO
    field seq-aprov       like mla-lista-aprov-doc.seq-aprov
    field cod-usuar-aprov like mla-lista-aprov-doc.cod-usuar
    field limite-aprov    like mla-perm-aprov.limite-aprov
    field rowlista        as rowid
    index chave as primary seq-aprov
    index limite limite-aprov.

DEF TEMP-TABLE tt-usuar-email NO-UNDO
    FIELD cod-usuar LIKE mla-usuar-aprov.cod-usuar
    INDEX codigo AS PRIMARY cod-usuar ASCENDING.

DEF TEMP-TABLE tt-usuar-aprov-altern NO-UNDO
    LIKE mla-usuar-aprov-altern.

DEFINE TEMP-TABLE tt-mla-alternativos-def NO-UNDO
    FIELD cod-usuar        AS CHAR FORMAT "x(12)"
    field cod-usuar-altern AS CHAR FORMAT "x(12)"
    FIELD da-inicial       AS DATE FORMAT "99/99/9999"
    FIELD da-final         AS DATE FORMAT "99/99/9999"
    INDEX codigo           AS PRIMARY cod-usuar ASCENDING.

/**  Variaveis necessarias aos setConstraints 
**/
DEFINE VARIABLE i-cod-tip-doc     AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-tipo-trans      AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-motivo-aprov    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE de-valor-aprov    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE i-moeda           AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-cod-usuar-trans AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-usuar-doc   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-lotacao-doc AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-it-codigo       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-referencia  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-ep-codigo       LIKE empresa.ep-codigo    NO-UNDO.
DEFINE VARIABLE c-cod-estabel     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-retorno-chave   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-usuar-mla       AS CHARACTER  NO-UNDO.

/**  Outras Vari†veis
**/
{inbo/boin767.i2}
{inbo/boin767.i4}
{cdp/cd0666.i}
{utp/utapi019.i}
{utp/ut-glob.i}
{cdp/cdapi171.i2}  
{cdp/cdapi171.i3} /* Procedure Integracao M¢dulo Importaá∆o */

/**  Definiá∆o de elementos referentes a UPC **/
{include/i-epc200.i "boin767b"}

DEFINE VARIABLE l-apr-tip-doc       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE p-cod-tip-doc       AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-chave             AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-chave             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-usuario-aed       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-destino-lotacao   AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-cod-lotacao       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lotacao           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-fm-codigo         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-aprova-auto       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-aprova-auto-aprov AS LOGICAL    NO-UNDO.
DEFINE VARIABLE de-limite-auto      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE l-mestre            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i-prioridade-aprov  AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-cod-aprov         AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-prioridade        AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-lim-lista         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i-tip-aprov         AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-usuar-aprov-auto  AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-ind-tip-aprov     AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-faixa-aprov       AS INTEGER    NO-UNDO.
DEFINE VARIABLE r-rowid             AS ROWID      NO-UNDO.
DEFINE VARIABLE c-cod-aprovador     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-desvia            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-achou-lista       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-log-email-altern  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-aprovado          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-aprovado-auto     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-cod-lotacao-trans AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-perm-aprov        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-desc-aprov-auto   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-log-depend        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-nome-usuar        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-gerou-pendencia   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i-prior             AS INTEGER    NO-UNDO.

DEFINE VARIABLE c-msgs-26593        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-help-26593        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-msgs-26652        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-help-26652        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-mensagens-geradas AS LOGICAL    NO-UNDO.

DEFINE VARIABLE l-tipo-aprov-doc    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-tipo-aprov-item   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-tipo-aprov-fam    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-tipo-aprov-ref    AS LOGICAL    NO-UNDO.

DEFINE VARIABLE i-tipo-email           AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-email                AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-usuario-remetente    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-email-remetente      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-usuario-destinatario AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-email-destinatario   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-envia-email          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-recebe-email         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-email-html-doc       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-email-html-usuar     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-log-exchange         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-des-tip-doc          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-ass-e-mail           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-men-e-mail           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-mensagem             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-arq-email            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-formato-email        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-servidor-email       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-porta-email          AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-arquivo-anexo        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-compl-email          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-log-aprov-altern     AS LOGICAL    NO-UNDO.

DEFINE VARIABLE hmla-param-aprov AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-tipo-doc-aprov AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-chave-doc AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-usuar-aprov AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-perm-aprov AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-verba-aprov AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-usuar-aprov-altern AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-tipo-aprov AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-tipo-aprov-item AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-tipo-aprov-fam AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-tipo-aprov-doc AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-tipo-aprov-ref AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-hierarquia-aprov AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-lista-aprov-item AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-lista-aprov-fam AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-lista-aprov-doc AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-lista-aprov-ref AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-usuar-padrao AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-faixa-aprov AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-hierarquia-faixa AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-lim-aprov-fam AS HANDLE NO-UNDO.
DEFINE VARIABLE hboin172  AS HANDLE NO-UNDO.
DEFINE VARIABLE hShowMsg  AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR gi-mla-prox-prior             AS INTEGER NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR gi-prox-prior   AS INTEGER NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR gc-lotacao-doc  AS CHAR    NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR c-mla-cc0300    AS CHAR    NO-UNDO.
DEFINE SHARED VAR gr-mla-rowid-pend AS ROWID.
DEFINE SHARED VAR gc-mla-cod-usuar              AS character format "x(16)".
DEFINE SHARED VAR gl-mla-gera-proxima           AS LOGICAL.
DEFINE SHARED VAR gi-mla-origem                 AS INTEGER.

DEFINE VARIABLE c-narrativa       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE de-total          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE i-empresa         LIKE empresa.ep-codigo    NO-UNDO.
DEFINE VARIABLE de-val-doc        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-cotacao        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-qt-saldo       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE i-moeda-doc       AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-nr-trans        AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-comentario      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-lotacao-doc     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE de-quant          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-valor-evento   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-valor-solserv  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-valor-medicao  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE i-erro            AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-prog-executa    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-log             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-prox-prior      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-pri-aprov-ant   AS LOGICAL    NO-UNDO.
                                  
DEFINE VARIABLE iRowsReturned     AS INTEGER    NO-UNDO.

DEFINE VARIABLE l-anexar-conteudo AS LOGICAL   NO-UNDO.
DEFINE BUFFER bf-mla-usuar-aprov FOR mla-usuar-aprov.

def temp-table tt-log-erros-atualiz no-undo
    field tta-cod-estab       as character format "x(3)"
    field tta-cod-refer       as character format "x(10)"
    field tta-num-seq-refer   as integer format ">>>9"
    field ttv-num-mensagem    as integer format ">>>>,>>9"
    field ttv-des-msg-erro    as character format "x(60)"
    field ttv-des-msg-ajuda   as character format "x(40)"
    field ttv-ind-tip-relacto as character format "X(15)"
    field ttv-num-relacto     as integer format ">>>>,>>9".

DEFINE TEMP-TABLE tt-RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    index seq ErrorSequence.

DEFINE TEMP-TABLE tt-log-erro NO-UNDO 
    FIELD i-sequen AS INT              
    FIELD cd-erro  AS INT 
    FIELD mensagem AS CHAR  FORMAT "x(255)".

/* vari†veis integraá∆o Fluig */
DEFINE VARIABLE r-rowid-aux-include  AS ROWID       NO-UNDO.
DEFINE VARIABLE i-nr-trans-include   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNrSolicFluig        AS INTEGER     NO-UNDO.
DEFINE VARIABLE lErroFluig           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE cErrorDescription    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cErrorHelp           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-mlaapi014          AS HANDLE      NO-UNDO.
DEFINE TEMP-TABLE RowErrorsAux NO-UNDO 
    LIKE tt-RowErrors.

{inbo/boin782.i "tt-mla-tipo-aprov-item"}
{inbo/boin781.i "tt-mla-tipo-aprov-fam"}
{inbo/boin780.i "tt-mla-tipo-aprov-doc"}
{inbo/boin783.i "tt-mla-tipo-aprov-ref"}

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
         HEIGHT             = 19.04
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


RUN pi-gerar-dados-extrato (INPUT "boin767b: Entrou " ).

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyBO DBOProgram 
PROCEDURE destroyBO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(hmla-param-aprov) THEN
        DELETE PROCEDURE hmla-param-aprov.
    IF VALID-HANDLE(hmla-tipo-doc-aprov) THEN
        DELETE PROCEDURE hmla-tipo-doc-aprov.
    IF VALID-HANDLE(hmla-chave-doc) THEN
        DELETE PROCEDURE hmla-chave-doc.
    IF VALID-HANDLE(hmla-usuar-aprov) THEN
        DELETE PROCEDURE hmla-usuar-aprov.
    IF VALID-HANDLE(hmla-perm-aprov) THEN
        DELETE PROCEDURE hmla-perm-aprov.
    IF VALID-HANDLE(hmla-verba-aprov) THEN
        DELETE PROCEDURE hmla-verba-aprov.
    IF VALID-HANDLE(hmla-usuar-aprov-altern) THEN
        DELETE PROCEDURE hmla-usuar-aprov-altern.
    IF VALID-HANDLE(hmla-tipo-aprov) THEN
        DELETE PROCEDURE hmla-tipo-aprov.
    IF VALID-HANDLE(hmla-tipo-aprov-item) THEN
        DELETE PROCEDURE hmla-tipo-aprov-item.
    IF VALID-HANDLE(hmla-tipo-aprov-fam) THEN
        DELETE PROCEDURE hmla-tipo-aprov-fam.
    IF VALID-HANDLE(hmla-tipo-aprov-doc) THEN
        DELETE PROCEDURE hmla-tipo-aprov-doc.
    IF VALID-HANDLE(hmla-tipo-aprov-ref) THEN
        DELETE PROCEDURE hmla-tipo-aprov-ref.
    IF VALID-HANDLE(hmla-hierarquia-aprov) THEN
        DELETE PROCEDURE hmla-hierarquia-aprov.
    IF VALID-HANDLE(hmla-lista-aprov-item) THEN
        DELETE PROCEDURE hmla-lista-aprov-item.
    IF VALID-HANDLE(hmla-lista-aprov-fam) THEN
        DELETE PROCEDURE hmla-lista-aprov-fam.
    IF VALID-HANDLE(hmla-lista-aprov-doc) THEN
        DELETE PROCEDURE hmla-lista-aprov-doc.
    IF VALID-HANDLE(hmla-lista-aprov-ref) THEN
        DELETE PROCEDURE hmla-lista-aprov-ref.
    IF VALID-HANDLE(hmla-usuar-padrao) THEN
        DELETE PROCEDURE hmla-usuar-padrao.
    IF VALID-HANDLE(hmla-faixa-aprov) THEN
        DELETE PROCEDURE hmla-faixa-aprov.
    IF VALID-HANDLE(hmla-hierarquia-faixa) THEN
        DELETE PROCEDURE hmla-hierarquia-faixa.
    IF VALID-HANDLE(hmla-lim-aprov-fam) THEN
        DELETE PROCEDURE hmla-lim-aprov-fam.

    IF VALID-HANDLE(hboin172) THEN
        DELETE PROCEDURE hboin172.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE errorValidate DBOProgram 
PROCEDURE errorValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cd-erro  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-mensagem AS CHARACTER NO-UNDO.

    {utp/ut-liter.i p-mensagem}

    {method/svc/errors/inserr.i &ErrorNumber=STRING(p-cd-erro)
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters=RETURN-VALUE}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPend DBOProgram 
PROCEDURE geraPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-tipo-docto  AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-trans    AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

    IF NOT VALID-HANDLE(h-mlaapi014) THEN
        RUN lap/mlaapi014.p PERSISTENT SET h-mlaapi014.

    run pi-verifica-importacao(output l-importacao). 

    /* Inicia o handle da api de integraá∆o com Fluig apenas uma vez, melhorando a performance da integraá∆o. */
    RUN setHandleFluig IN h-mlaapi014.

    ASSIGN i-nr-trans = p-nr-trans.

    RUN pi-gerar-dados-extrato (INPUT "boin767b: p-tipo-docto " + STRING(p-tipo-docto)).

    CASE p-tipo-docto: 
        WHEN  1 THEN RUN geraPendSolic      IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN  2 THEN RUN geraPendSolic      IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN  3 THEN RUN geraPendRequis     IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN  4 THEN RUN geraPendRequis     IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN  5 THEN RUN geraPendCotac      IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN  6 THEN RUN geraPendPedido     IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN  7 THEN RUN geraPendPedido     IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN  8 THEN RUN geraPendEmerg      IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN  9 THEN RUN geraPendProces     IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-nr-trans,  INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 10 THEN RUN geraPendProces     IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-nr-trans,  INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 13 THEN RUN geraPendContr      IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 14 THEN RUN geraPendMedic      IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 16 THEN RUN geraPendEvent      IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 18 THEN RUN geraPendSolCot     IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 19 THEN RUN geraPendEmerg      IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 20 THEN RUN geraPendManut      IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        when 21 then run geraPendRepCredito IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT table RowErrors).
        WHEN 24 THEN RUN geraPendFinanc     IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-tipo-docto, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 25 THEN RUN geraPendFinanc     IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-tipo-docto, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 26 THEN RUN geraPendFinanc     IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-tipo-docto, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 28 THEN RUN geraPendFinanc     IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-tipo-docto, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 29 THEN RUN geraPendNegFrete   IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 30 THEN RUN geraPendDocFrete   IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 31 THEN RUN geraPendFatFrete   IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 32 THEN RUN geraPendOrigAdto   IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
        WHEN 33 THEN RUN geraPendOrigFechto IN THIS-PROCEDURE (INPUT p-transacao, INPUT p-chave-doc, OUTPUT TABLE RowErrors).
    END CASE.

    IF  RETURN-VALUE = "NOK":U THEN DO:
        FOR EACH tt-erro:
            DELETE tt-erro.
        END.
        ASSIGN i-erro = 0.
        FOR EACH RowErrors:
            ASSIGN i-erro = i-erro + 1.
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = i-erro
                   tt-erro.cd-erro  = RowErrors.ErrorNumber
                   tt-erro.mensagem = RowErrors.ErrorDescription.
        END.
        /* Elimina o handle da api de integraá∆o com Fluig apenas uma vez, melhorando a performance da integraá∆o. */
        RUN unsetHandleFluig IN h-mlaapi014.
    
        IF VALID-HANDLE(h-mlaapi014) THEN DO:
            DELETE PROCEDURE h-mlaapi014.
            ASSIGN h-mlaapi014 = ?.
        END.
        RETURN "NOK":U.
    END.

    RUN setEpcGeraPend IN THIS-PROCEDURE(INPUT p-nr-trans).

    /* Elimina o handle da api de integraá∆o com Fluig apenas uma vez, melhorando a performance da integraá∆o. */
    RUN unsetHandleFluig IN h-mlaapi014.

    IF VALID-HANDLE(h-mlaapi014) THEN DO:
        DELETE PROCEDURE h-mlaapi014.
	
        ASSIGN h-mlaapi014 = ?.        
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendNegFrete DBOProgram 
PROCEDURE geraPendNegFrete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  Metodo responsavel em Gerar Pendencia para Negociacao de Frete do GFE     
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.        

    RUN ReturnKeyDoc IN THIS-PROCEDURE (INPUT p-chave-doc, 29, OUTPUT c-retorno-chave).

    RUN pi-gerar-dados-extrato (INPUT "boin767b: ReturnKeyDoc chave = " + c-retorno-chave ).

    FIND FIRST tab-generica EXCLUSIVE-LOCK
        WHERE  tab-generica.utilizacao = "GFE_MLA_TF_GVQ"
        AND    tab-generica.char-1     = c-retorno-chave NO-ERROR.

    IF  AVAIL tab-generica THEN DO:
      ASSIGN de-total = DECIMAL(REPLACE(ENTRY(04,tab-generica.char-2,"|"),".",",")).
      RELEASE tab-generica.
    END.
    ELSE
      ASSIGN de-total = 0.

    RUN pi-gerar-dados-extrato(INPUT " boin767b - valor: " + String(de-total)).

    /** Negociacao Tabela de Frete GFE **/
    FIND FIRST tab-generica NO-LOCK
            WHERE tab-generica.utilizacao  = "GFE_MLA_TF_GV9"
              AND tab-generica.char-1      = c-retorno-chave   NO-ERROR.

    IF AVAIL tab-generica THEN DO:        

        FIND FIRST mla-usuar-aprov WHERE 
            mla-usuar-aprov.cod-usuar = ENTRY(9,tab-generica.char-2,"|")/* GV9_USUCRI -> Usr Criaá∆o  */ /*c-seg-usuario*/
            NO-LOCK  NO-ERROR.       
        

        IF AVAILABLE mla-usuar-aprov THEN
            ASSIGN  c-lotacao = mla-usuar-aprov.cod-lotacao.
        ELSE
            ASSIGN  c-lotacao = "".                

        RUN pi-gerar-dados-extrato (INPUT "boin767b: c-lotacao " + STRING(c-lotacao) + " usuario " + ENTRY(9,tab-generica.char-2,"|")).

        FIND estabelec WHERE
             estabelec.cod-estabel = ENTRY(01,tab-generica.char-1,"|")
             NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN
           run cdp/cd9970.p (input  ROWID(estabelec),
                            output i-empresa).

        FIND FIRST mla-tipo-doc-aprov NO-LOCK
             WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
               AND mla-tipo-doc-aprov.cod-estabel = ENTRY(01,tab-generica.char-1,"|")
               AND mla-tipo-doc-aprov.cod-tip-doc = 29  NO-ERROR.

        IF  AVAIL mla-tipo-doc-aprov AND
            mla-tipo-doc-aprov.apr-tip-doc THEN DO:
            {lap/mlaapi001.i01} 
            CREATE tt-mla-chave.
            /* Filial */
            ASSIGN tt-mla-chave.valor[1] = TRIM(ENTRY(01,tab-generica.char-1,"|")).
            /* Transportador */
            ASSIGN tt-mla-chave.valor[2] = TRIM(ENTRY(02,tab-generica.char-1,"|")).
            /* Tabela Frete */
            ASSIGN tt-mla-chave.valor[3] = TRIM(ENTRY(03,tab-generica.char-1,"|")).
            /* sequencia Frete */
            ASSIGN tt-mla-chave.valor[4] = TRIM(ENTRY(04,tab-generica.char-1,"|")).

            RUN pi-gerar-dados-extrato (INPUT "boin767b: RUN setGeraPendencia = " + String(p-transacao) + " | ").

            RUN setGeraPendencia IN THIS-PROCEDURE (29,
                                                    p-transacao,
                                                    "Aprovaá∆o da tabela de fretes",
                                                    de-total,
                                                    0,
                                                    ENTRY(9,tab-generica.char-2,"|"), /* GV9_USUCRI -> Usr Criaá∆o  */ /*c-seg-usuario*/
                                                    ENTRY(9,tab-generica.char-2,"|"), /* GV9_USUCRI -> Usr Criaá∆o  */ /*c-seg-usuario*/
                                                    c-lotacao,
                                                    "",
                                                    "",
                                                    i-empresa,
                                                    ENTRY(01,tab-generica.char-1,"|"),
                                                    input  table tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).                      
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendDocFrete DBOProgram 
PROCEDURE geraPendDocFrete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  Metodo responsavel em Gerar Pendencia para Negociacao de Frete do GFE     
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    RUN ReturnKeyDoc IN THIS-PROCEDURE (INPUT p-chave-doc, 30, OUTPUT c-retorno-chave).

    /** Documento Contrato **/
    FIND FIRST tab-generica NO-LOCK
            WHERE tab-generica.utilizacao  = "GFE_MLA_GW3"
              AND tab-generica.char-1      = c-retorno-chave   NO-ERROR.
    IF AVAIL tab-generica THEN DO:
        find first mla-usuar-aprov where
            mla-usuar-aprov.cod-usuar = ENTRY(9,tab-generica.char-2,"|")
            no-lock no-error.       
        
        if available mla-usuar-aprov then
            assign c-lotacao = mla-usuar-aprov.cod-lotacao.
        else
            assign c-lotacao = "".                

        RUN pi-gerar-dados-extrato (INPUT "boin767b: c-lotacao " + STRING(c-lotacao) + " usuario " + ENTRY(9,tab-generica.char-2,"|")).

        FIND estabelec WHERE
             estabelec.cod-estabel = ENTRY(01,tab-generica.char-1,"|")
             NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN
           run cdp/cd9970.p (input  ROWID(estabelec),
                            output i-empresa).

        FIND FIRST mla-tipo-doc-aprov NO-LOCK
             WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
               AND mla-tipo-doc-aprov.cod-estabel = ENTRY(01,tab-generica.char-1,"|")
               AND mla-tipo-doc-aprov.cod-tip-doc = 30  NO-ERROR.

        IF  AVAIL mla-tipo-doc-aprov AND
            mla-tipo-doc-aprov.apr-tip-doc THEN DO:
            {lap/mlaapi001.i01} 
            CREATE tt-mla-chave.
            /* Filial */
            ASSIGN tt-mla-chave.valor[1] = TRIM(ENTRY(01,tab-generica.char-1,"|")).
            /* Especie */
            ASSIGN tt-mla-chave.valor[2] = TRIM(ENTRY(02,tab-generica.char-1,"|")).
            /* Transportadora */
            ASSIGN tt-mla-chave.valor[3] = TRIM(ENTRY(03,tab-generica.char-1,"|")).
            /* Serie */
            ASSIGN tt-mla-chave.valor[4] = TRIM(ENTRY(04,tab-generica.char-1,"|")).
            /* Nr Documento */
            ASSIGN tt-mla-chave.valor[5] = TRIM(ENTRY(05,tab-generica.char-1,"|")).
            /* Data Emissao */
            ASSIGN tt-mla-chave.valor[6] = TRIM(ENTRY(06,tab-generica.char-1,"|")).

            ASSIGN de-total = DECIMAL(ENTRY(08,tab-generica.char-2,"|")).

            RUN pi-gerar-dados-extrato (INPUT "boin767b: c-lotacao " + STRING(c-lotacao) + " usuario " + ENTRY(9,tab-generica.char-2,"|") + " de-total " + STRING(de-total)).
            RUN pi-gerar-dados-extrato (INPUT "boin767b: RUN setGeraPendencia = " + String(p-transacao) + " | usuario_logado " + String(c-seg-usuario)).

            RUN setGeraPendencia IN THIS-PROCEDURE (30,
                                                    p-transacao,
                                                    "Aprovaá∆o do Documento de fretes",
                                                    de-total,
                                                    0,
                                                    ENTRY(9,tab-generica.char-2,"|"),
                                                    ENTRY(9,tab-generica.char-2,"|"),
                                                    c-lotacao,
                                                    "",
                                                    "",
                                                    i-empresa,
                                                    ENTRY(01,tab-generica.char-1,"|"),
                                                    INPUT  TABLE tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).                      
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendFatFrete DBOProgram 
PROCEDURE geraPendFatFrete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  Metodo responsavel em Gerar Pendencia para Fatura de Frete do GFE     
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    RUN ReturnKeyDoc IN THIS-PROCEDURE (INPUT p-chave-doc, 31, OUTPUT c-retorno-chave).

    /** Documento Contrato **/
    FIND FIRST tab-generica NO-LOCK
            WHERE tab-generica.utilizacao  = "GFE_MLA_GW6"
              AND tab-generica.char-1      = c-retorno-chave   NO-ERROR.
    IF AVAIL tab-generica THEN DO:
        find first mla-usuar-aprov where
            mla-usuar-aprov.cod-usuar = ENTRY(9,tab-generica.char-2,"|")
            no-lock no-error.       
        
        if available mla-usuar-aprov then
            assign c-lotacao = mla-usuar-aprov.cod-lotacao.
        else
            assign c-lotacao = "".                

        RUN pi-gerar-dados-extrato (INPUT "boin767b: c-lotacao " + STRING(c-lotacao) + " usuario " + ENTRY(9,tab-generica.char-2,"|")).

        FIND estabelec WHERE
             estabelec.cod-estabel = ENTRY(01,tab-generica.char-1,"|")
             NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN
           run cdp/cd9970.p (input  ROWID(estabelec),
                            output i-empresa).

        FIND FIRST mla-tipo-doc-aprov NO-LOCK
             WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
               AND mla-tipo-doc-aprov.cod-estabel = ENTRY(01,tab-generica.char-1,"|")
               AND mla-tipo-doc-aprov.cod-tip-doc = 31  NO-ERROR.

        IF  AVAIL mla-tipo-doc-aprov AND
            mla-tipo-doc-aprov.apr-tip-doc THEN DO:
            {lap/mlaapi001.i01} 
            CREATE tt-mla-chave.
            /* GW6_FILIAL -> Filial */
            ASSIGN tt-mla-chave.valor[1] = TRIM(ENTRY(01,tab-generica.char-1,"|")).
            /* GW6_EMIFAT -> Transportador */
            ASSIGN tt-mla-chave.valor[2] = TRIM(ENTRY(02,tab-generica.char-1,"|")).
            /* GW6_SERFAT -> Serie */
            ASSIGN tt-mla-chave.valor[3] = TRIM(ENTRY(03,tab-generica.char-1,"|")).
            /* GW6_NRFAT  -> Nr Fatura */
            ASSIGN tt-mla-chave.valor[4] = TRIM(ENTRY(04,tab-generica.char-1,"|")).
            /* GW6_DTEMIS -> Dt Emissao */
            ASSIGN tt-mla-chave.valor[5] = TRIM(ENTRY(05,tab-generica.char-1,"|")).

            ASSIGN de-total = DECIMAL(ENTRY(01,tab-generica.char-2,"|")).

            RUN pi-gerar-dados-extrato (INPUT "boin767b: c-lotacao " + STRING(c-lotacao) + " usuario " + ENTRY(9,tab-generica.char-2,"|") + " de-total " + STRING(de-total)).
            RUN pi-gerar-dados-extrato (INPUT "boin767b: RUN setGeraPendencia = " + String(p-transacao) + " | " + String(c-seg-usuario)).

            RUN setGeraPendencia IN THIS-PROCEDURE (31,
                                                    p-transacao,
                                                    "Aprovaá∆o da Fatura de fretes",
                                                    de-total,
                                                    0,
                                                    ENTRY(9,tab-generica.char-2,"|"),
                                                    ENTRY(9,tab-generica.char-2,"|"),
                                                    c-lotacao,
                                                    "",
                                                    "",
                                                    i-empresa,
                                                    ENTRY(01,tab-generica.char-1,"|"),
                                                    input  table tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).                      
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendContf DBOProgram 
PROCEDURE geraPendContf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /** Documentos 11 e 12 n∆o s∆o mais utilizados **/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendContr DBOProgram 
PROCEDURE geraPendContr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE de-total-item         LIKE contrato-for.dec-2 NO-UNDO.
    DEFINE VARIABLE de-qtd-total          LIKE contrato-for.dec-1 NO-UNDO.
    DEFINE VARIABLE de-total-contrato     LIKE contrato-for.dec-2 NO-UNDO. 
    DEFINE VARIABLE de-total-contrato-qtd LIKE contrato-for.dec-2 NO-UNDO.

    /**  mlaapi010J
    **/
    if  p-transacao = 1 then
        assign p-transacao = 2.

    /** Documento Contrato **/
    FIND FIRST contrato-for NO-LOCK  
        WHERE contrato-for.nr-contrato = INT(SUBSTRING(p-chave-doc,1,9)) NO-ERROR.
    IF AVAIL contrato-for THEN DO:

        FIND estabelec WHERE
             estabelec.cod-estabel = contrato-for.cod-estabel
             NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN
           run cdp/cd9970.p (input  ROWID(estabelec),
                            output i-empresa).

        FIND FIRST mla-param-aprov NO-LOCK
             WHERE mla-param-aprov.ep-codigo   = i-empresa 
               AND mla-param-aprov.cod-estabel = contrato-for.cod-estabel NO-ERROR.
        IF AVAIL mla-param-aprov THEN DO:
            IF  mla-param-aprov.int-1 = 1 THEN DO: /* usuario da transacao */
                ASSIGN c-usuar-mla = c-seg-usuario.
            END.
            ELSE DO: /* usuario do documento */
                ASSIGN c-usuar-mla = contrato-for.gestor-tecnico. 
            END.
        END.

        find first mla-usuar-aprov where
            mla-usuar-aprov.cod-usuar = c-usuar-mla
            no-lock no-error.       
        
        if available mla-usuar-aprov then
            assign c-lotacao = mla-usuar-aprov.cod-lotacao.
        else
            assign c-lotacao = "".  

        FIND FIRST mla-tipo-doc-aprov NO-LOCK
             WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
               AND mla-tipo-doc-aprov.cod-estabel = contrato-for.cod-estabel
               AND mla-tipo-doc-aprov.cod-tip-doc = 13  NO-ERROR.

        /* se houver limite informado para o contrato */
        ASSIGN de-total-contrato     = contrato-for.dec-2
               de-total-contrato-qtd = 0
               de-total-item         = 0 
               de-qtd-total          = 0. 

        IF  AVAIL mla-tipo-doc-aprov AND
            mla-tipo-doc-aprov.apr-tip-doc THEN DO:
            {lap/mlaapi001.i01} 
            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(contrato-for.nr-contrato).

            /* Se n∆o houver limite informado, totaliza os itens */
            IF  de-total-contrato = 0 THEN DO:
                FOR EACH item-contrat
                   WHERE item-contrat.nr-contrato = contrato-for.nr-contrato
                     AND item-contrat.ind-sit-item < 3 NO-LOCK:
                    IF AVAIL param-contrat AND param-contrat.controle-aditivo THEN DO:
                       FIND FIRST hist-alter NO-LOCK 
                          WHERE hist-alter.nr-contrato    = item-contrat.nr-contrato
                            AND hist-alter.num-seq-item   = item-contrat.num-seq-item
                            AND hist-alter.it-codigo      = item-contrat.it-codigo
                            AND hist-alter.des-tipo-alter = "item-contrat.val-total"
                            AND hist-alter.num-seq-adit   = 0 NO-ERROR.
                       IF AVAIL hist-alter THEN DO:
                           ASSIGN de-total-contrato = de-total-contrato + INT(hist-alter.alter-destino).
                       END.
                       ELSE DO:
                           ASSIGN de-total-contrato = de-total-contrato + item-contrat.val-total.
                       END.
                    END.
                    ELSE DO:
                        ASSIGN de-total-contrato = de-total-contrato + item-contrat.val-total.
                    END.

                    /* Se n∆o houver limite de valor informado, totaliza os itens atraves da quantidade */
                    IF item-contrat.qtd-total = 0 THEN
                        ASSIGN de-qtd-total = 1.
                    ELSE
                        ASSIGN de-qtd-total = item-contrat.qtd-total.

                    IF AVAIL param-contrat AND param-contrat.controle-aditivo THEN DO:
                        FIND FIRST hist-alter NO-LOCK 
                             WHERE hist-alter.nr-contrato    = item-contrat.nr-contrato
                               AND hist-alter.num-seq-item   = item-contrat.num-seq-item
                               AND hist-alter.it-codigo      = item-contrat.it-codigo
                               AND hist-alter.des-tipo-alter = "item-contrat.qtd-total"
                               AND hist-alter.num-seq-adit   = 0 NO-ERROR.
                        IF AVAIL hist-alter THEN DO:
                            IF DEC(hist-alter.alter-destino) = 0 THEN
                                ASSIGN de-qtd-total = 1.
                            ELSE
                                ASSIGN de-qtd-total = DEC(hist-alter.alter-destino).

                            ASSIGN de-total-contrato-qtd = de-total-contrato-qtd + (de-qtd-total * item-contrat.pre-unit-for).
                        END.
                        ELSE DO:
                            ASSIGN de-total-contrato-qtd = de-total-contrato-qtd + (de-qtd-total * item-contrat.pre-unit-for).
                        END.
                    END.
                    ELSE DO:
                        ASSIGN de-total-contrato-qtd = de-total-contrato-qtd + (de-qtd-total * item-contrat.pre-unit-for).
                    END.
                END.
            END.

            /* Gera Pendencia pelo Saldo */
            IF AVAIL mla-tipo-doc-aprov 
               AND mla-tipo-doc-aprov.idi-tip-val-pendcia = 2 THEN DO: /* Saldo */
               FOR EACH  item-contrat
                   WHERE item-contrat.nr-contrato = contrato-for.nr-contrato
                   AND   item-contrat.ind-sit-item < 3 NO-LOCK:
                   ASSIGN de-total-item = de-total-item + item-contrat.sld-val. 
               END.
               ASSIGN de-total-contrato = de-total-contrato - de-total-item.                              
            END.

            /*Se n∆o existir limite de valor, considera o calculo a partir da quantidade*/
            IF de-total-contrato = 0 THEN
                ASSIGN de-total-contrato = de-total-contrato-qtd.


            /* Convers∆o do Valor do Contrato */
            if  contrato-for.mo-codigo = 0 then  
                assign de-cotacao = 1.
            else do:            
                 run cdp/cd0812.p (input contrato-for.mo-codigo,
                                   input 0,
                                   input 1,
                                   input today,
                                   output de-cotacao).
                 if  de-cotacao = ? then
                     assign de-cotacao = 1.
            end.

            assign de-total-contrato = de-total-contrato * de-cotacao.
            
            RUN setGeraPendencia IN THIS-PROCEDURE (13,
                                                    p-transacao,
                                                    substr(contrato-for.narrat-contrat,1,40),
                                                    de-total-contrato,
                                                    contrato-for.mo-codigo,
                                                    c-seg-usuario,
                                                    contrato-for.gestor-tecnico, /* Usu†rio do documento */
                                                    c-lotacao,
                                                    "",
                                                    string(contrato-for.cod-emitente),
                                                    i-empresa,
                                                    contrato-for.cod-estabel,
                                                    input  table tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).                      
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendCotac DBOProgram 
PROCEDURE geraPendCotac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /**  mlaapi010C
    **/
    if  p-transacao = 1 THEN 
        assign p-transacao = 2.

    FIND FIRST cotacao-item NO-LOCK
        WHERE cotacao-item.numero-ordem = INT(SUBSTRING(p-chave-doc,1,8))
          AND cotacao-item.cod-emitente = INT(SUBSTRING(p-chave-doc,9,9))
          AND cotacao-item.it-codigo    = SUBSTRING(p-chave-doc,18,16)
          AND cotacao-item.seq-cotac    = INT(SUBSTRING(p-chave-doc,34,3)) NO-ERROR.
    
    find first ordem-compra WHERE 
        ordem-compra.numero-ordem = cotacao-item.numero-ordem 
        no-lock no-error.
                                                                     
    find mla-usuar-aprov WHERE 
        mla-usuar-aprov.cod-usuar = ordem-compra.cod-comprado 
        no-lock no-error.
    
    FIND estabelec WHERE 
        estabelec.cod-estabel = ordem-compra.cod-estabel 
        NO-LOCK NO-ERROR.
    
    IF AVAIL estabelec THEN
       run cdp/cd9970.p (input  ROWID(estabelec),
                         output i-empresa).
    
    IF AVAIL ordem-compra THEN ASSIGN c-cod-estabel = ordem-compra.cod-estabel.

    FIND FIRST mla-tipo-doc-aprov NO-LOCK
         WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
           AND mla-tipo-doc-aprov.cod-estabel = ordem-compra.cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 5  NO-ERROR.

    IF  AVAIL mla-tipo-doc-aprov AND
        mla-tipo-doc-aprov.apr-tip-doc THEN DO:
        {lap/mlaapi001.i01}
        create tt-mla-chave.
        assign tt-mla-chave.valor[1] = string(cotacao-item.numero-ordem)
               tt-mla-chave.valor[2] = string(cotacao-item.cod-emitente)
               tt-mla-chave.valor[3] = cotacao-item.it-codigo
               tt-mla-chave.valor[4] = string(cotacao-item.seq-cotac).
        assign c-narrativa = substring(cotacao-item.narrativa,1,40).           
                   
        /* Calculo do Valor da Cotaá∆o */
        if  cotacao-item.mo-codigo = 0 
            THEN assign de-cotacao = 1.
            else do:            
                 run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                   input 0,
                                   input 1,
                                   input cotacao-item.data-cotacao,
                                   output de-cotacao).
                 if  de-cotacao = ? then
                     assign de-cotacao = 1.
            end.
        assign de-val-doc  = ordem-compra.qt-solic * cotacao-item.preco-unit * de-cotacao.

        /*chamado TPOLOI -  Rodrigo*/
        /*IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.mo-codigo <> cotacao-item.mo-codigo THEN DO:
            RUN cdp/cd0812.p   (INPUT  cotacao-item.mo-codigo,   /* Moeda Origem*/
                                INPUT  mla-usuar-aprov.mo-codigo,/* Moeda Destino*/
                                INPUT  de-val-doc,                           /* Valor Origem a converter */
                                INPUT  TODAY,                    /* Datas da Convers∆o*/
                                OUTPUT de-val-doc).                          /* Valor retorno convertido */

            if de-val-doc = ? then
                assign de-val-doc = 0.
        END.*/

        RUN setGeraPendencia IN THIS-PROCEDURE (5,
                                                p-transacao,
                                                c-narrativa,
                                                de-val-doc,
                                                cotacao-item.mo-codigo,
                                                c-seg-usuario,
                                                cotacao-item.cod-comprado,
                                                ordem-compra.sc-codigo,
                                                cotacao-item.it-codigo,
                                                ordem-compra.ct-codigo,
                                                i-empresa,
                                                ordem-compra.cod-estabel,
                                                input  table tt-mla-chave,
                                                OUTPUT TABLE RowErrors).                      
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendEmerg DBOProgram 
PROCEDURE geraPendEmerg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /**  mlaapi010F
    **/
    if  p-transacao = 1 then
        assign p-transacao = 2.

    /**  Total
    **/
    
    find first pedido-compr where
        pedido-compr.num-pedido = INT(SUBSTRING(p-chave-doc,1,8)) no-lock no-error.        
    IF AVAIL pedido-compr AND 
       pedido-compr.cod-estab-gestor <> '' THEN 
        ASSIGN c-cod-estabel = pedido-compr.cod-estab-gestor.
    ELSE ASSIGN c-cod-estabel = pedido-compr.cod-estabel.
    FIND FIRST estabelec NO-LOCK 
            WHERE estabelec.cod-estabel = c-cod-estabel NO-ERROR. 
    if avail estabelec then 
       run cdp/cd9970.p (input rowid(estabelec),
                         output i-empresa).

    FIND FIRST mla-tipo-doc-aprov NO-LOCK
         WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
           AND mla-tipo-doc-aprov.cod-estabel = c-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 8  NO-ERROR.

    IF  AVAIL mla-tipo-doc-aprov AND
        mla-tipo-doc-aprov.apr-tip-doc THEN DO:

        FIND FIRST mla-usuar-aprov NO-LOCK
             WHERE mla-usuar-aprov.cod-usuar = pedido-compr.responsavel NO-ERROR.
        ASSIGN c-lotacao = IF AVAIL mla-usuar-aprov THEN mla-usuar-aprov.cod-lotacao ELSE "".

        assign c-comentario = substring(pedido-compr.comentarios,1,40).

        for each  ordem-compra where 
            ordem-compra.num-pedido = pedido-compr.num-pedido and 
           (ordem-compra.situacao   = 2 or 
            ordem-compra.situacao   = 6) no-lock:
            for each prazo-compra where 
                prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:
                if can-find(funcao where
                            funcao.cd-funcao = "Pedido_Total_AED" and
                            funcao.ativo     = yes) THEN
                    assign de-qt-saldo = de-qt-saldo + prazo-compra.quantidade.
                ELSE 
                    assign de-qt-saldo = de-qt-saldo + prazo-compra.qtd-sal-forn. 
            end.
            find first cotacao-item where 
                cotacao-item.numero-ordem = ordem-compra.numero-ordem and 
                cotacao-item.cot-aprovada = yes 
                no-lock no-error.
            
            /* Calculo do Valor da Cotaá∆o */
            if  cotacao-item.mo-codigo = 0 then  
                assign de-cotacao = 1.
            else do:            
                run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                  input 0,
                                  input 1,
                                  input cotacao-item.data-cotacao,
                                  output de-cotacao).
                if  de-cotacao = ? then
                    assign de-cotacao = 1.
            end.
            
            RUN setEpcEmerg IN THIS-PROCEDURE (1).

            assign de-total    = de-total + (ordem-compra.pre-unit-for * de-qt-saldo * de-cotacao)
                   de-qt-saldo = 0.
        end.       

        {lap/mlaapi001.i01}

        create tt-mla-chave.
        assign tt-mla-chave.valor[1] = string(pedido-compr.num-pedido).

        RUN setEpcEmerg IN THIS-PROCEDURE (2).

        /*chamado TPOLOI -  Rodrigo*/
        /*FIND FIRST mla-usuar-aprov
            WHERE mla-usuar-aprov.cod-usuar = pedido-compr.responsavel NO-LOCK NO-ERROR.
        IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.mo-codigo <> cotacao-item.mo-codigo THEN DO:
            RUN cdp/cd0812.p   (INPUT  cotacao-item.mo-codigo,   /* Moeda Origem*/
                                INPUT  mla-usuar-aprov.mo-codigo,/* Moeda Destino*/
                                INPUT  de-total,                             /* Valor Origem a converter */
                                INPUT  TODAY,                    /* Datas da Convers∆o*/
                                OUTPUT de-total).                            /* Valor retorno convertido */

            if de-total = ? then
                assign de-total = 0.
        END.*/

        RUN setGeraPendencia IN THIS-PROCEDURE (8,
                                                p-transacao,
                                                c-comentario,
                                                de-total,
                                                0,
                                                c-seg-usuario,
                                                pedido-compr.responsavel,
                                                c-lotacao,
                                                "",
                                                STRING(pedido-compr.cod-emitente),
                                                i-empresa,
                                                c-cod-estabel,
                                                INPUT  TABLE tt-mla-chave,
                                                OUTPUT TABLE RowErrors).       
    END.
    ELSE DO:

        /**  Item **/

        FIND FIRST ordem-compra NO-LOCK
            WHERE ordem-compra.numero-ordem = INT(SUBSTRING(p-chave-doc,9,8))
              AND ordem-compra.num-pedido   = INT(SUBSTRING(p-chave-doc,1,8)) NO-ERROR.

        IF AVAIL ordem-compra AND 
           ordem-compra.cod-estab-gestor <> '' THEN 
            ASSIGN c-cod-estabel = ordem-compra.cod-estab-gestor.
        ELSE ASSIGN c-cod-estabel = ordem-compra.cod-estabel.
        FIND FIRST estabelec NO-LOCK 
                WHERE estabelec.cod-estabel = c-cod-estabel NO-ERROR. 
        if avail estabelec then 
           run cdp/cd9970.p (input rowid(estabelec),
                             output i-empresa).

        FIND FIRST mla-tipo-doc-aprov NO-LOCK
             WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
               AND mla-tipo-doc-aprov.cod-estabel = c-cod-estabel
               AND mla-tipo-doc-aprov.cod-tip-doc = 19  NO-ERROR.

        IF  AVAIL mla-tipo-doc-aprov AND
            mla-tipo-doc-aprov.apr-tip-doc THEN DO:

            FIND FIRST pedido-compr NO-LOCK
                WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.      

            FIND FIRST mla-usuar-aprov NO-LOCK
                 WHERE mla-usuar-aprov.cod-usuar = ordem-compra.cod-comprado NO-ERROR.
            ASSIGN c-lotacao = IF AVAIL mla-usuar-aprov THEN mla-usuar-aprov.cod-lotacao ELSE "".

            FIND estabelec 
                WHERE estabelec.cod-estabel = pedido-compr.cod-estabel
                NO-LOCK NO-ERROR.
            IF AVAIL estabelec THEN
               run cdp/cd9970.p (input  ROWID(estabelec),
                                 output i-empresa).    

            assign c-comentario  = substring(pedido-compr.comentarios,1,40)
                   c-cod-estabel = pedido-compr.cod-estab-gestor.

            IF  c-cod-estabel = "" THEN 
                ASSIGN c-cod-estabel = pedido-compr.end-entrega.

            if avail ordem-compra then
                for each prazo-compra where 
                    prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:
                    if can-find(funcao where
                                funcao.cd-funcao = "Pedido_Total_AED" and
                                funcao.ativo     = yes) THEN
                        assign de-qt-saldo = de-qt-saldo + prazo-compra.quantidade.
                    ELSE
                        assign de-qt-saldo = de-qt-saldo + prazo-compra.qtd-sal-forn. 
                        /* prazo-compra.quant-saldo - alterado para buscar o saldo do fornecedor, pois caso exista fator de conversao esta ja esta convertida */

                end.

            {lap/mlaapi001.i01} 

            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(ordem-compra.num-pedido)
                   tt-mla-chave.valor[2] = string(ordem-compra.numero-ordem).

            find first cotacao-item where 
                cotacao-item.numero-ordem = ordem-compra.numero-ordem and 
                cotacao-item.cot-aprovada = yes no-lock no-error.

            if  cotacao-item.mo-codigo = 0 then  
                assign de-cotacao = 1.
            else do:            
                run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                  input 0,
                                  input 1,
                                  input cotacao-item.data-cotacao,
                                  output de-cotacao).
                if  de-cotacao = ? then
                    assign de-cotacao = 1.
            end.

            RUN setEpcEmerg IN THIS-PROCEDURE (3).

            assign de-total    = (ordem-compra.preco-unit * de-qt-saldo * de-cotacao)
                   de-qt-saldo = 0.

            ASSIGN gc-lotacao-doc = ordem-compra.sc-codigo.

            /*chamado TPOLOI - Rodrigo*/
            /*FIND FIRST mla-usuar-aprov
                WHERE mla-usuar-aprov.cod-usuar = ordem-compra.cod-comprado NO-LOCK NO-ERROR.
            IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.mo-codigo <> cotacao-item.mo-codigo THEN DO:
                RUN cdp/cd0812.p   (INPUT  cotacao-item.mo-codigo,       /* Moeda Origem*/
                                                                    INPUT  mla-usuar-aprov.mo-codigo,/* Moeda Destino*/
                                                                    INPUT  de-total,                         /* Valor Origem a converter */
                                                                    INPUT  TODAY,                    /* Datas da Convers∆o*/
                                                                    OUTPUT de-total).                        /* Valor retorno convertido */

                        if de-total = ? then
                                assign de-total = 0.
            END.*/

            RUN setGeraPendencia IN THIS-PROCEDURE (19,
                                                    p-transacao,
                                                    substring(ordem-compra.narrativa,1,40),
                                                    de-total,
                                                    i-moeda-doc,
                                                    c-seg-usuario,
                                                    ordem-compra.cod-comprado,
                                                    gc-lotacao-doc,
                                                    ordem-compra.it-codigo,
                                                    ordem-compra.ct-codigo,
                                                    i-empresa,
                                                    c-cod-estabel, 
                                                    INPUT  TABLE tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).       
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendEvent DBOProgram 
PROCEDURE geraPendEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /**  mlaapi010K
    **/
    if  p-transacao = 1 then
        assign p-transacao = 2.

    /**  Item
    **/
    FIND FIRST evento-ped NO-LOCK 
        WHERE evento-ped.numero-ordem = INT(SUBSTRING(p-chave-doc,1,8)) 
          AND evento-ped.dt-evento    = DATE(SUBSTRING(p-chave-doc,9,10)) 
          AND evento-ped.seq-evento   = INT(SUBSTRING(p-chave-doc,19,2))  NO-ERROR.
    IF  AVAIL evento-ped THEN DO:

        find first contrato-for where
            contrato-for.nr-contrato = evento-ped.nr-contrato
            no-lock no-error.        
        if  avail contrato-for then do:
            find first item-contrat where
                item-contrat.nr-contrato  = evento-ped.nr-contrato and
                item-contrat.num-seq-item = evento-ped.num-seq-item
                no-lock no-error.        

            FIND FIRST mla-usuar-aprov NO-LOCK
                 WHERE mla-usuar-aprov.cod-usuar = contrato-for.gestor-tecnico NO-ERROR.
            ASSIGN c-lotacao = IF AVAIL mla-usuar-aprov THEN mla-usuar-aprov.cod-lotacao ELSE "".
        
            FIND estabelec WHERE
                 estabelec.cod-estabel = evento-ped.cod-estabel
                 NO-LOCK NO-ERROR.
            IF AVAIL estabelec THEN
               run cdp/cd9970.p (input  ROWID(estabelec),
                                 output i-empresa).

            /* Convers∆o do Valor do Evento */
            if  contrato-for.mo-codigo = 0 then  
                    assign de-cotacao = 1.
            else do:            
                 run cdp/cd0812.p (input contrato-for.mo-codigo,
                                   input 0,
                                   input 1,
                                   input evento-ped.dt-evento,
                                   output de-cotacao).
                 if  de-cotacao = ? then
                     assign de-cotacao = 1.
            end.

            assign de-valor-evento = evento-ped.val-previsto * de-cotacao.

            FIND FIRST mla-tipo-doc-aprov NO-LOCK
                 WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
                   AND mla-tipo-doc-aprov.cod-estabel = evento-ped.cod-estabel
                   AND mla-tipo-doc-aprov.cod-tip-doc = 16  NO-ERROR.
    
            IF  AVAIL mla-tipo-doc-aprov AND
                mla-tipo-doc-aprov.apr-tip-doc THEN DO:
                {lap/mlaapi001.i01}
                create tt-mla-chave.
                assign tt-mla-chave.valor[1] = string(evento-ped.numero-ordem)
                       tt-mla-chave.valor[2] = string(evento-ped.dt-evento)
                       tt-mla-chave.valor[3] = string(evento-ped.seq-evento).

                /*chamado TPOLOI - Rodrigo*/
                /*FIND FIRST mla-usuar-aprov
                    WHERE mla-usuar-aprov.cod-usuar = contrato-for.gestor-tecnico NO-LOCK NO-ERROR.
                IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.mo-codigo <> 0 THEN DO:
                    RUN cdp/cd0812.p   (INPUT  0,                                                /* Moeda Origem*/
                                        INPUT  mla-usuar-aprov.mo-codigo,/* Moeda Destino*/
                                        INPUT  de-valor-evento,                  /* Valor Origem a converter */
                                        INPUT  TODAY,                    /* Datas da Convers∆o*/
                                        OUTPUT de-valor-evento).                 /* Valor retorno convertido */
    
                    if de-valor-evento = ? then
                        assign de-valor-evento = 0.
                END.*/


                RUN setGeraPendencia IN THIS-PROCEDURE (16,
                                                        p-transacao,
                                                        evento-ped.observacao,
                                                        de-valor-evento,
                                                        0,
                                                        c-seg-usuario,
                                                        contrato-for.gestor-tecnico,
                                                        c-lotacao,
                                                        item-contrat.it-codigo,
                                                        string(contrato-for.cod-emitente),
                                                        i-empresa,
                                                        contrato-for.cod-estabel,
                                                        input  table tt-mla-chave,
                                                        OUTPUT TABLE RowErrors).                      
            END.
        end.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendFinanc DBOProgram 
PROCEDURE geraPendFinanc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao  AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-tipo-docto AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc  LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE i-posicao AS INTEGER INITIAL 0 NO-UNDO.
    
    if  p-transacao = 1 then
        assign p-transacao = 1.

    {lap/mlaapi001.i01}  /* elimina temp-tables */
    create tt-mla-chave. /* Monta tt-mla-chave */
    for each mla-chave-doc-aprov no-lock
       where mla-chave-doc-aprov.cod-tip-doc = p-tipo-docto:
        assign i-posicao = i-posicao + 1.
        assign tt-mla-chave.valor[i-posicao] = trim(substring(p-chave-doc,
                                                              mla-chave-doc-aprov.posicao-ini,
                                                              (mla-chave-doc-aprov.posicao-fim + 1 - 
                                                              mla-chave-doc-aprov.posicao-ini))).
    end.
    FIND FIRST tt-mla-chave NO-LOCK NO-ERROR.
    
    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = tt-mla-chave.valor[1] NO-ERROR. /* CÛdigo do estab. nos docs financeiros */
    IF AVAIL estabelec THEN
       run cdp/cd9970.p (input  ROWID(estabelec),
                         output i-empresa).

    FIND FIRST mla-tipo-doc-aprov NO-LOCK
         WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
           AND mla-tipo-doc-aprov.cod-estabel = tt-mla-chave.valor[1]
           AND mla-tipo-doc-aprov.cod-tip-doc = p-tipo-docto  NO-ERROR.

    IF  AVAIL mla-tipo-doc-aprov AND
        mla-tipo-doc-aprov.apr-tip-doc THEN DO:

        FIND FIRST mla-doc-pend-aprov NO-LOCK
            where mla-doc-pend-aprov.ep-codigo   = i-empresa
              and mla-doc-pend-aprov.cod-estabel = tt-mla-chave.valor[1]
              and mla-doc-pend-aprov.cod-tip-doc = p-tipo-docto
              and mla-doc-pend-aprov.chave-doc   = p-chave-doc
              and mla-doc-pend-aprov.historico   = NO  NO-ERROR.
        IF AVAIL mla-doc-pend-aprov THEN
            ASSIGN de-total = mla-doc-pend-aprov.valor-doc.

        /*chamado TPNBZL - Manuela*/
        /*FIND FIRST mla-usuar-aprov
            WHERE mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-doc NO-LOCK NO-ERROR.
        IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.mo-codigo <> mla-doc-pend-aprov.mo-codigo THEN DO:
            RUN cdp/cd0812.p   (INPUT  mla-doc-pend-aprov.mo-codigo,/* Moeda Origem*/
                                INPUT  mla-usuar-aprov.mo-codigo,   /* Moeda Destino*/
                                INPUT  de-total,                            /* Valor Origem a converter */
                                INPUT  TODAY,                       /* Datas da Convers∆o*/
                                OUTPUT de-total).                           /* Valor retorno convertido */

            if de-total = ? then
                assign de-total = 0.
        END.*/


        /*######################
        Chamar a procedure setGeraPendencia passando parÉmetros da mla-doc-pend-aprov posicionada 
        ######################*/
        RUN setGeraPendencia IN THIS-PROCEDURE (p-tipo-docto,                                          
                                                p-transacao,                                           
                                                mla-doc-pend-aprov.motivo-doc,                         
                                                de-total, 
                                                mla-doc-pend-aprov.mo-codigo,                          
                                                mla-doc-pend-aprov.cod-usuar-trans,                    
                                                mla-doc-pend-aprov.cod-usuar-doc,                      
                                                mla-doc-pend-aprov.cod-lotacao-doc,                    
                                                mla-doc-pend-aprov.it-codigo,                          
                                                mla-doc-pend-aprov.cod-referencia,                     
                                                mla-doc-pend-aprov.ep-codigo,                          
                                                mla-doc-pend-aprov.cod-estabel,                        
                                                INPUT  TABLE tt-mla-chave,                             
                                                OUTPUT TABLE RowErrors).                               
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendManut DBOProgram 
PROCEDURE geraPendManut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /**  mlaapi010I
    **/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendMedic DBOProgram 
PROCEDURE geraPendMedic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /**  mlaapi010L
    **/
    if  p-transacao = 1 then
        assign p-transacao = 2.

    /**  Item
    **/
    FIND FIRST medicao-contrat NO-LOCK 
        WHERE medicao-contrat.nr-contrato      = INT(SUBSTRING(p-chave-doc,1,9))
          AND medicao-contrat.num-seq-item    = INT(SUBSTRING(p-chave-doc,10,5))
          AND medicao-contrat.numero-ordem    = INT(SUBSTRING(p-chave-doc,15,8))
          AND medicao-contrat.num-seq-event   = INT(SUBSTRING(p-chave-doc,23,4))
          AND medicao-contrat.num-seq-medicao = INT(SUBSTRING(p-chave-doc,27,4)) NO-ERROR.
    if  avail medicao-contrat then do:
        find first item-contrat where
            item-contrat.nr-contrato  = medicao-contrat.nr-contrato and
            item-contrat.num-seq-item = medicao-contrat.num-seq-item
            no-lock no-error.        
        find first contrato-for where
            contrato-for.nr-contrato = medicao-contrat.nr-contrato
            no-lock no-error.    

        FIND FIRST mla-usuar-aprov NO-LOCK
             WHERE mla-usuar-aprov.cod-usuar =  medicao-contrat.responsavel NO-ERROR.
        ASSIGN c-lotacao = IF AVAIL mla-usuar-aprov THEN mla-usuar-aprov.cod-lotacao ELSE "".

        FIND estabelec WHERE
             estabelec.cod-estabel = contrato-for.cod-estabel
             NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN
           run cdp/cd9970.p (input  ROWID(estabelec),
                             output i-empresa).
    
        /* Convers∆o do Valor da Mediá∆o */
        if  contrato-for.mo-codigo = 0 then  
                assign de-cotacao = 1.
        else do:            
             run cdp/cd0812.p (input contrato-for.mo-codigo,
                               input 0,
                               input 1,
                               input medicao-contrat.dat-medicao,
                               output de-cotacao).
             if  de-cotacao = ? then
                 assign de-cotacao = 1.
        end.

        assign de-valor-medicao = medicao-contrat.val-medicao * de-cotacao.

        FIND FIRST mla-tipo-doc-aprov NO-LOCK
             WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
               AND mla-tipo-doc-aprov.cod-estabel = contrato-for.cod-estabel
               AND mla-tipo-doc-aprov.cod-tip-doc = 14  NO-ERROR.

        IF  AVAIL mla-tipo-doc-aprov AND
            mla-tipo-doc-aprov.apr-tip-doc THEN DO:

            {lap/mlaapi001.i01}
            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(medicao-contrat.nr-contrato)
                   tt-mla-chave.valor[2] = string(medicao-contrat.num-seq-item)
                   tt-mla-chave.valor[3] = string(medicao-contrat.numero-ordem)
                   tt-mla-chave.valor[4] = string(medicao-contrat.num-seq-event)
                   tt-mla-chave.valor[5] = string(medicao-contrat.num-seq-medicao).

            /*chamado TPOLOI - Rodrigo*/
            /*FIND FIRST mla-usuar-aprov
                WHERE mla-usuar-aprov.cod-usuar = medicao-contrat.responsavel NO-LOCK NO-ERROR.
            IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.mo-codigo <> 0 THEN DO:
                RUN cdp/cd0812.p   (INPUT  0,                                            /* Moeda Origem*/
                                    INPUT  mla-usuar-aprov.mo-codigo,/* Moeda Destino*/
                                    INPUT  de-valor-medicao,             /* Valor Origem a converter */
                                    INPUT  TODAY,                    /* Datas da Convers∆o*/
                                    OUTPUT de-valor-medicao).            /* Valor retorno convertido */

                if de-valor-medicao = ? then
                    assign de-valor-medicao = 0.
            END.*/

            RUN setGeraPendencia IN THIS-PROCEDURE (14,
                                                    p-transacao,
                                                    substr(medicao-contrat.observacao,1,40),
                                                    de-valor-medicao,
                                                    0,
                                                    c-seg-usuario,
                                                    medicao-contrat.responsavel,
                                                    c-lotacao,
                                                    item-contrat.it-codigo,
                                                    string(contrato-for.cod-emitente),          
                                                    i-empresa,
                                                    contrato-for.cod-estabel,
                                                    input  table tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).                      
        END.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendOrigAdto DBOProgram 
PROCEDURE geraPendOrigAdto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  Metodo responsavel em Gerar Pendencia para Adiantamento Valor (Originaá∆o de Gr∆os)
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE lOrigGraosAtivo AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE p-estabel       LIKE mla-tipo-doc-aprov.cod-estabel      NO-UNDO.
    DEFINE VARIABLE p-val           AS DECIMAL NO-UNDO.

    RUN cdp/cd0032.p (OUTPUT lOrigGraosAtivo).
    IF  lOrigGraosAtivo THEN DO:
        {lap/mlaapi001.i01} 
        
        RUN ggp/ggapi905 (INPUT p-chave-doc,
                          INPUT 1, /* tipo fechto */
                          OUTPUT p-estabel,
                          OUTPUT p-val,
                          OUTPUT TABLE tt-mla-chave).
        FIND FIRST tt-mla-chave NO-LOCK NO-ERROR.
        IF AVAIL tt-mla-chave THEN DO:
            FIND FIRST mla-usuar-aprov NO-LOCK
                WHERE  mla-usuar-aprov.cod-usuar = c-seg-usuario NO-ERROR.
            IF  AVAIL  mla-usuar-aprov THEN
                ASSIGN c-lotacao = mla-usuar-aprov.cod-lotacao.
            ELSE
                ASSIGN c-lotacao = "".

            FIND FIRST mla-tipo-doc-aprov NO-LOCK
                WHERE  mla-tipo-doc-aprov.ep-codigo   = TRIM(SUBSTRING(p-chave-doc, 1, 3))
                  AND    mla-tipo-doc-aprov.cod-estabel = p-estabel
                  AND    mla-tipo-doc-aprov.cod-tip-doc = 32 NO-ERROR.

            IF  AVAIL mla-tipo-doc-aprov AND
                mla-tipo-doc-aprov.apr-tip-doc THEN DO:
                
                RUN setGeraPendencia IN THIS-PROCEDURE (INPUT  32,
                                                        INPUT  p-transacao,
                                                        INPUT  "Aprovaá∆o Adiantamento Valor (Originaá∆o)",
                                                        INPUT  p-val,
                                                        INPUT  0,
                                                        INPUT  c-seg-usuario,
                                                        INPUT  c-seg-usuario,
                                                        INPUT  c-lotacao,
                                                        INPUT  "",
                                                        INPUT  "",
                                                        INPUT  tt-mla-chave.valor[1],
                                                        INPUT  p-estabel,
                                                        INPUT  TABLE tt-mla-chave,
                                                        OUTPUT TABLE RowErrors).                      
            END.
            ELSE DO:
                {lap/mlaapi001.i01}
            END.                                                        
        END.
    END.    

    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendOrigFechto DBOProgram 
PROCEDURE geraPendOrigFechto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  Metodo responsavel em Gerar Pendencia para Fechamento Financeiro (Originaá∆o de Gr∆os)
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

   DEFINE VARIABLE lOrigGraosAtivo AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE p-estabel       LIKE mla-tipo-doc-aprov.cod-estabel      NO-UNDO.
    DEFINE VARIABLE p-val           AS DECIMAL NO-UNDO.

    RUN cdp/cd0032.p (OUTPUT lOrigGraosAtivo).
    IF  lOrigGraosAtivo THEN DO:
        {lap/mlaapi001.i01} 
        
        RUN ggp/ggapi905 (INPUT p-chave-doc,
                          INPUT 2, /* tipo fechto */
                          OUTPUT p-estabel,
                          OUTPUT p-val,
                          OUTPUT TABLE tt-mla-chave).
        FIND FIRST tt-mla-chave NO-LOCK NO-ERROR.
        IF AVAIL tt-mla-chave THEN DO:
            FIND FIRST mla-usuar-aprov NO-LOCK
                WHERE  mla-usuar-aprov.cod-usuar = c-seg-usuario NO-ERROR.
            IF  AVAIL  mla-usuar-aprov THEN
                ASSIGN c-lotacao = mla-usuar-aprov.cod-lotacao.
            ELSE
                ASSIGN c-lotacao = "".

            FIND FIRST mla-tipo-doc-aprov NO-LOCK
                WHERE  mla-tipo-doc-aprov.ep-codigo   = TRIM(SUBSTRING(p-chave-doc, 1, 3))
                  AND    mla-tipo-doc-aprov.cod-estabel = p-estabel
                  AND    mla-tipo-doc-aprov.cod-tip-doc = 33 NO-ERROR.

            IF  AVAIL mla-tipo-doc-aprov AND
                mla-tipo-doc-aprov.apr-tip-doc THEN DO:
                
                RUN setGeraPendencia IN THIS-PROCEDURE (INPUT  33,
                                                        INPUT  p-transacao,
                                                        INPUT  "Aprovaá∆o Fechamento Financeiro (Originaá∆o)",
                                                        INPUT  p-val,
                                                        INPUT  0,
                                                        INPUT  c-seg-usuario,
                                                        INPUT  c-seg-usuario,
                                                        INPUT  c-lotacao,
                                                        INPUT  "",
                                                        INPUT  "",
                                                        INPUT  tt-mla-chave.valor[1],
                                                        INPUT  p-estabel,
                                                        INPUT  TABLE tt-mla-chave,
                                                        OUTPUT TABLE RowErrors).                          
            END.
            ELSE DO:
                {lap/mlaapi001.i01}
            END.                
        END.
    END.

    FIND FIRST RowErrors NO-ERROR.
    IF  AVAILABLE RowErrors THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendPedido DBOProgram 
PROCEDURE geraPendPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    /**  mlaapi010D
    **/
    if  p-transacao = 1 THEN 
        assign p-transacao = 2.

    /**  Item
    **/        
    
    FIND FIRST ordem-compra NO-LOCK
        WHERE ordem-compra.numero-ordem = INT(SUBSTRING(p-chave-doc,9,8))
          AND ordem-compra.num-pedido   = INT(SUBSTRING(p-chave-doc,1,8)) NO-ERROR.

    IF AVAIL ordem-compra AND 
       ordem-compra.cod-estab-gestor <> '' THEN 
        ASSIGN c-cod-estabel = ordem-compra.cod-estab-gestor.
    ELSE
        IF AVAIL ordem-compra THEN ASSIGN c-cod-estabel = ordem-compra.cod-estabel.
    FIND FIRST estabelec NO-LOCK 
            WHERE estabelec.cod-estabel = c-cod-estabel NO-ERROR. 
    if avail estabelec then 
       run cdp/cd9970.p (input rowid(estabelec),
                         output i-empresa).

    FIND FIRST mla-tipo-doc-aprov NO-LOCK
             WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
               AND mla-tipo-doc-aprov.cod-estabel = c-cod-estabel
               AND mla-tipo-doc-aprov.cod-tip-doc = 6  NO-ERROR.

    IF  AVAIL mla-tipo-doc-aprov AND
        mla-tipo-doc-aprov.apr-tip-doc THEN DO:

        /*Limpando a vari†vel*/
        ASSIGN de-total = 0.
        
        FIND FIRST pedido-compr NO-LOCK
            WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR. 
        
        FIND FIRST cotacao-item NO-LOCK  
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
              AND cotacao-item.cot-aprovada NO-ERROR.
    
        ASSIGN c-narrativa    = SUBSTRING(ordem-compra.narrativa,1,40)
               gc-lotacao-doc = ordem-compra.sc-codigo.
        
        {lap/mlaapi001.i01}
        create tt-mla-chave.
        assign tt-mla-chave.valor[1] = string(ordem-compra.num-pedido)
               tt-mla-chave.valor[2] = string(ordem-compra.numero-ordem).

        RUN setEpcPedido IN THIS-PROCEDURE (INPUT 1).

        find first cotacao-item where 
            cotacao-item.numero-ordem = ordem-compra.numero-ordem and 
            cotacao-item.cot-aprovada = yes 
            no-lock no-error.
        
        if  c-mla-cc0300 <> "btOk" then do:     
            
            /* Calculo do Valor da Cotaá∆o */
            if  avail cotacao-item and 
                cotacao-item.mo-codigo = 0 then  
                assign de-cotacao = 1.
            else do:            
                 run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                   input 0,
                                   input 1,
                                   input cotacao-item.data-cotacao,
                                   output de-cotacao).
                 if  de-cotacao = ? then
                     assign de-cotacao = 1.
            end.

            RUN setEpcPedido IN THIS-PROCEDURE (INPUT 2).

            for each prazo-compra where 
                prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:
                if can-find(funcao where
                            funcao.cd-funcao = "Pedido_Total_AED" and
                            funcao.ativo     = yes) then
                    assign de-qt-saldo = de-qt-saldo + prazo-compra.quantidade.
                else
                    assign de-qt-saldo = de-qt-saldo + prazo-compra.qtd-sal-forn. 
            end.

            assign de-total    = de-total + (ordem-compra.pre-unit-for * de-qt-saldo * de-cotacao)
                   de-qt-saldo = 0.
            
            /*chamado TPOLOI - Rodrigo*/
            /*IF AVAIL ordem-compra THEN DO:
                FIND FIRST mla-usuar-aprov
                    WHERE mla-usuar-aprov.cod-usuar = ordem-compra.cod-comprado NO-LOCK NO-ERROR.
                IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.mo-codigo <> cotacao-item.mo-codigo THEN DO:
                    RUN cdp/cd0812.p   (INPUT  cotacao-item.mo-codigo,   /* Moeda Origem*/
                                                                    INPUT  mla-usuar-aprov.mo-codigo,/* Moeda Destino*/
                                                                    INPUT  de-total,                         /* Valor Origem a converter */
                                                                    INPUT  TODAY,                    /* Datas da Convers∆o*/
                                                                    OUTPUT de-total).                        /* Valor retorno convertido */
    
                                if de-total = ? then
                                        assign de-total = 0.
                END.
            END.*/

            RUN setGeraPendencia IN THIS-PROCEDURE (6,
                                                    p-transacao,
                                                    c-narrativa,
                                                    de-total,  
                                                    i-moeda-doc,
                                                    c-seg-usuario,
                                                    ordem-compra.cod-comprado,
                                                    gc-lotacao-doc,
                                                    ordem-compra.it-codigo,
                                                    ordem-compra.ct-codigo,
                                                    i-empresa,
                                                    c-cod-estabel,
                                                    input table tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).                      
        end.
    end.
        
    /**  Total
    **/
    FIND FIRST pedido-compr NO-LOCK
        WHERE pedido-compr.num-pedido = INT(SUBSTRING(p-chave-doc,1,8)) NO-ERROR. 
    IF AVAIL pedido-compr AND 
       pedido-compr.cod-estab-gestor <> '' THEN 
        ASSIGN c-cod-estabel = pedido-compr.cod-estab-gestor.
    ELSE ASSIGN c-cod-estabel = pedido-compr.cod-estabel.
    FIND FIRST estabelec NO-LOCK 
            WHERE estabelec.cod-estabel = c-cod-estabel NO-ERROR. 
    if avail estabelec then 
       run cdp/cd9970.p (input rowid(estabelec),
                         output i-empresa).

    FIND FIRST mla-tipo-doc-aprov NO-LOCK
         WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
           AND mla-tipo-doc-aprov.cod-estabel = c-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 7  NO-ERROR.

    IF  AVAIL mla-tipo-doc-aprov AND
        mla-tipo-doc-aprov.apr-tip-doc THEN DO:
        
        /*Limpando a vari†vel*/
        ASSIGN de-total = 0.

        for each  ordem-compra 
            where ordem-compra.num-pedido = pedido-compr.num-pedido 
              and (ordem-compra.situacao  = 2 or ordem-compra.situacao   = 6) no-lock:

            for each prazo-compra 
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:

                if can-find(funcao 
                            WHERE funcao.cd-funcao = "Pedido_Total_AED" 
                              AND funcao.ativo     = yes) THEN
                    assign de-qt-saldo = de-qt-saldo + prazo-compra.quantidade.
                ELSE 
                    assign de-qt-saldo = de-qt-saldo + prazo-compra.qtd-sal-forn. 
            end.

            find first cotacao-item 
                where cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                  and cotacao-item.cot-aprovada = yes no-lock no-error.
            
            /* Calculo do Valor da Cotaá∆o */
            if  cotacao-item.mo-codigo = 0 then  
                assign de-cotacao = 1.
            else do:            
                 run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                   input 0,
                                   input 1,
                                   input cotacao-item.data-cotacao,
                                   output de-cotacao).
                 if  de-cotacao = ? then
                     assign de-cotacao = 1.
            end.
    
            RUN setEpcPedido IN THIS-PROCEDURE (INPUT 3).
            
            assign de-total    = de-total + (ordem-compra.pre-unit-for * de-qt-saldo * de-cotacao)
                   de-qt-saldo = 0.
        END.
    
        assign gc-lotacao-doc = "".
    
        FIND FIRST mla-usuar-aprov NO-LOCK
             WHERE mla-usuar-aprov.cod-usuar = pedido-compr.responsavel NO-ERROR.
        ASSIGN gc-lotacao-doc = IF AVAIL mla-usuar-aprov THEN mla-usuar-aprov.cod-lotacao ELSE "".
        
        assign c-comentario = substring(pedido-compr.comentarios,1,40).
        assign c-cod-estabel = pedido-compr.cod-estab-gestor.
        if  c-cod-estabel = "" then 
            assign c-cod-estabel = pedido-compr.end-entrega.
        
        RUN setEpcPedido IN THIS-PROCEDURE (INPUT 4).


        /*chamado TPOLOI - Rodrigo*/
        /*IF AVAIL cotacao-item THEN DO:
            FIND FIRST mla-usuar-aprov
                WHERE mla-usuar-aprov.cod-usuar = pedido-compr.responsavel NO-LOCK NO-ERROR.
            IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.mo-codigo <>  cotacao-item.mo-codigo THEN DO:
                RUN cdp/cd0812.p   (INPUT  cotacao-item.mo-codigo,       /* Moeda Origem*/
                                                                    INPUT  mla-usuar-aprov.mo-codigo,/* Moeda Destino*/
                                                                    INPUT  de-total,                         /* Valor Origem a converter */
                                                                    INPUT  TODAY,                    /* Datas da Convers∆o*/
                                                                    OUTPUT de-total).                        /* Valor retorno convertido */

                        if de-total = ? then
                                assign de-total = 0.
            END.
        END.*/
            
        if c-mla-cc0300 <> "btConfirma"     and  
           c-mla-cc0300 <> "btSalva"        and  
           c-mla-cc0300 <> "btAddAllTarget" and 
           c-mla-cc0300 <> "btAddTarget"    and 
           c-mla-cc0300 <> "btDelTarget"    and 
           c-mla-cc0300 <> "btDelAllTarget" then do:
           
           {lap/mlaapi001.i01}
           create tt-mla-chave.
           assign tt-mla-chave.valor[1] = string(pedido-compr.num-pedido).
           RUN setGeraPendencia IN THIS-PROCEDURE (7,
                                                   p-transacao,
                                                   c-comentario,
                                                   de-total,
                                                   i-moeda-doc,
                                                   c-seg-usuario,
                                                   pedido-compr.responsavel,
                                                   gc-lotacao-doc,
                                                   "",
                                                   string(pedido-compr.cod-emitente),
                                                   i-empresa,
                                                   c-cod-estabel,
                                                   input  table tt-mla-chave,
                                                   OUTPUT TABLE RowErrors).             
        end.
    
        assign c-mla-cc0300 = "".
    
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendProces DBOProgram 
PROCEDURE geraPendProces :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-trans    AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    def buffer b-ordem-compra for ordem-compra.
    define variable de-qtd-ordem like ordem-compra.qt-solic no-undo.

    /**  mlaapi010G
    **/
    if  p-transacao = 1 THEN 
        assign p-transacao = 2.

    FIND FIRST proc-compra 
         WHERE proc-compra.nr-processo = INT(SUBSTRING(p-chave-doc,1,6)) NO-LOCK NO-ERROR.

    IF NOT AVAIL proc-compra THEN
        RETURN "NOK":U.

    FIND FIRST mla-doc-pend-aprov WHERE mla-doc-pend-aprov.nr-trans = p-nr-trans NO-LOCK NO-ERROR.

    FIND FIRST mla-usuar-aprov 
         WHERE mla-usuar-aprov.cod-usuar = proc-compra.cod-comprado NO-LOCK NO-ERROR.

    /**  Item **/     
    IF CAN-FIND(first mla-tipo-doc-aprov WHERE 
                      mla-tipo-doc-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo   AND 
                      mla-tipo-doc-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel AND 
                      mla-tipo-doc-aprov.cod-tip-doc = 9                              AND 
                      mla-tipo-doc-aprov.apr-tip-doc = YES)                        THEN DO:

        FIND FIRST ordem-compra 
             WHERE ordem-compra.numero-ordem = INT(SUBSTRING(p-chave-doc,7,8)) NO-LOCK NO-ERROR.

        FOR FIRST cotacao-item WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                                 AND cotacao-item.log-1 NO-LOCK:
            assign c-narrativa = substring(cotacao-item.narrativa,1,40). 

            /* Calculo do Valor da Cotaá∆o */
            if  cotacao-item.mo-codigo = 0 THEN 
                assign de-cotacao = 1.
            else do:            
                run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                  input 0,
                                  input 1,
                                  input cotacao-item.data-cotacao,
                                  output de-cotacao).
                if  de-cotacao = ? then
                    assign de-cotacao = 1.
            end.
            assign de-val-doc  = ordem-compra.qt-solic * cotacao-item.preco-unit * de-cotacao.

            if l-importacao then do:
                run pi-desp-importacao(input rowid(cotacao-item),
                                       input ordem-compra.qt-solic,
                                       input 0, 
                                       output de-val-despesas-aux).
                assign de-val-doc = de-val-doc + de-val-despesas-aux.
            end.

            {lap/mlaapi001.i01}
            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(proc-compra.nr-processo)
                   tt-mla-chave.valor[2] = string(ordem-compra.numero-ordem)
                   tt-mla-chave.valor[3] = string(cotacao-item.cod-emitente) 
                   tt-mla-chave.valor[4] = string(cotacao-item.it-codigo)
                   tt-mla-chave.valor[5] = string(cotacao-item.seq-cotac).

            RUN setGeraPendencia IN THIS-PROCEDURE (9,
                                                    p-transacao,
                                                    c-narrativa,
                                                    de-val-doc,
                                                    0,
                                                    c-seg-usuario,
                                                    ordem-compra.cod-comprado,
                                                    ordem-compra.sc-codigo,
                                                    ordem-compra.it-codigo,
                                                    ordem-compra.ct-codigo,
                                                    mla-doc-pend-aprov.ep-codigo,
                                                    mla-doc-pend-aprov.cod-estabel,
                                                    input  table tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).  

            FIND FIRST mla-doc-pend-aprov
                 where mla-doc-pend-aprov.ep-codigo                 = mla-doc-pend-aprov.ep-codigo                        
                 and   mla-doc-pend-aprov.cod-estabel               = mla-doc-pend-aprov.cod-estabel      
                 and   mla-doc-pend-aprov.cod-tip-doc               = 9                                
                 and   substring(mla-doc-pend-aprov.chave-doc,1,6)  = string(proc-compra.nr-processo)  
                 and   substring(mla-doc-pend-aprov.chave-doc,7,8)  = string(ordem-compra.numero-ordem)
                 and   mla-doc-pend-aprov.historico                 = no   EXCLUSIVE-LOCK NO-ERROR.
            
            IF AVAIL mla-doc-pend-aprov THEN DO:
                /* Utilizado no mla009e.p para saber qual fornecedor ganhou a cotaá∆o*/
                ASSIGN substring(mla-doc-pend-aprov.char-2,1,9)   = string(cotacao-item.cod-emitente).
            END.
        END.        
    END.
    /**  Total **/
    ELSE IF CAN-FIND(first mla-tipo-doc-aprov 
                     WHERE mla-tipo-doc-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo                   
                       AND mla-tipo-doc-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel    
                       AND mla-tipo-doc-aprov.cod-tip-doc = 10                           
                       AND mla-tipo-doc-aprov.apr-tip-doc = YES) THEN DO:

        for each b-ordem-compra field (nr-processo numero-ordem qt-solic cod-estabel)
             where b-ordem-compra.nr-processo = proc-compra.nr-processo NO-LOCK BREAK BY b-ordem-compra.numero-ordem:        
        
             assign de-qtd-ordem = 0.
             for each prazo-compra field (numero-ordem situacao quantidade) where
                 prazo-compra.numero-ordem = b-ordem-compra.numero-ordem no-lock:
                 if prazo-compra.situacao = 4 then next.
                 assign de-qtd-ordem = de-qtd-ordem + prazo-compra.quantidade.
             end.
                 
             for each cotacao-item field (numero-ordem log-1 preco-unit mo-codigo data-cotacao narrativa)
                where cotacao-item.numero-ordem = b-ordem-compra.numero-ordem NO-LOCK:

                 if cotacao-item.log-1 = no then next.

                 if first(b-ordem-compra.numero-ordem) then
                    assign c-narrativa = substring(cotacao-item.narrativa,1,40).

                  /* Calculo do Valor da Cotaá∆o */
                  if  cotacao-item.mo-codigo = 0 THEN 
                      assign de-cotacao = 1.
                  else do:            
                      run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                        input 0,
                                        input 1,
                                        input cotacao-item.data-cotacao,
                                        output de-cotacao).
                      if  de-cotacao = ? then
                          assign de-cotacao = 1.
                 end.

                 assign de-val-doc = de-val-doc + (de-qtd-ordem * cotacao-item.preco-unit * de-cotacao).

                 if l-importacao then do:
                     run pi-desp-importacao(input rowid(cotacao-item),
                                            input de-qtd-ordem,
                                            input 0, 
                                            output de-val-despesas-aux).
                     assign de-val-doc = de-val-doc + de-val-despesas-aux.
                end.
             end.
         end. 

         {lap/mlaapi001.i01}
         create tt-mla-chave.
         assign tt-mla-chave.valor[1] = string(proc-compra.nr-processo).

         RUN setGeraPendencia IN THIS-PROCEDURE (10,
                                                 IF p-transacao = 3 and de-val-doc <> 0 then 2 else p-transacao,
                                                 c-narrativa,
                                                 de-val-doc,
                                                 0,
                                                 c-seg-usuario,
                                                 proc-compra.cod-comprado,
                                                 mla-usuar-aprov.cod-lotacao,
                                                 mla-doc-pend-aprov.it-codigo,
                                                 mla-doc-pend-aprov.cod-referencia,
                                                 mla-doc-pend-aprov.ep-codigo,
                                                 mla-doc-pend-aprov.cod-estabel,
                                                 input  table tt-mla-chave,
                                                 OUTPUT TABLE RowErrors).   
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendRepCredito DBOProgram 
PROCEDURE geraPendRepCredito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.        
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.        
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    if p-transacao = 1 then
       assign p-transacao = 2.
        
    for first ped-venda fields (nr-pedido cod-estabel desc-bloq-cr vl-tot-ped)             
        where ped-venda.nr-pedido = int(substring(p-chave-doc, 1, 11)) no-lock: end.
    for first estabelec fields(log-1)
        where estabelec.cod-estabel = ped-venda.cod-estabel no-lock: end.
    if avail estabelec then 
       run cdp/cd9970.p (input rowid(estabelec),
                         output i-empresa).

    FIND FIRST mla-tipo-doc-aprov NO-LOCK
         WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
           AND mla-tipo-doc-aprov.cod-estabel = ped-venda.cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 21  NO-ERROR.

    IF  AVAIL mla-tipo-doc-aprov AND
        mla-tipo-doc-aprov.apr-tip-doc THEN DO:

       {lap/mlaapi001.i01}
       create tt-mla-chave.
       assign tt-mla-chave.valor[1] = string(ped-venda.nr-pedido).
       
       for first mla-usuar-aprov fields (cod-lotacao)
           where mla-usuar-aprov.cod-usuar = c-seg-usuario no-lock:
       end.

       assign gc-lotacao-doc = mla-usuar-aprov.cod-lotacao
              c-narrativa    = ped-venda.desc-bloq-cr.

       ASSIGN de-total = ped-venda.vl-tot-ped.

       /*chamado TPOLOI - Rodrigo*/
       /*FIND FIRST mla-usuar-aprov
                WHERE mla-usuar-aprov.cod-usuar = c-seg-usuario NO-LOCK NO-ERROR.
        IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.mo-codigo <> 0 THEN DO:
            RUN cdp/cd0812.p   (INPUT  0,                                                /* Moeda Origem*/
                                INPUT  mla-usuar-aprov.mo-codigo,/* Moeda Destino*/
                                INPUT  de-total,                         /* Valor Origem a converter */
                                INPUT  TODAY,                    /* Datas da Convers∆o*/
                                OUTPUT de-total).                        /* Valor retorno convertido */

            if de-total = ? then
                assign de-total = 0.
        END.*/

       run setGeraPendencia in this-procedure (21,
                                               p-transacao,
                                               c-narrativa,
                                               de-total,
                                               0,
                                               c-seg-usuario,
                                               c-seg-usuario,
                                               gc-lotacao-doc,
                                               "",
                                               "",
                                               i-empresa,
                                               ped-venda.cod-estabel,
                                               input table tt-mla-chave,
                                               output table RowErrors).
       
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendRequis DBOProgram 
PROCEDURE geraPendRequis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE i-posicao AS INTEGER INITIAL 0 NO-UNDO.

    /**  mlaapi010B
    **/
    if  p-transacao = 1 then
        assign p-transacao = 2.

    {lap/mlaapi001.i01}  /* elimina temp-tables */
    create tt-mla-chave. /* Monta tt-mla-chave */
    for each mla-chave-doc-aprov no-lock
       where mla-chave-doc-aprov.cod-tip-doc = 3:
        assign i-posicao = i-posicao + 1.
        assign tt-mla-chave.valor[i-posicao] = trim(substring(p-chave-doc,
                                                              mla-chave-doc-aprov.posicao-ini,
                                                              (mla-chave-doc-aprov.posicao-fim + 1 - 
                                                              mla-chave-doc-aprov.posicao-ini))).
    end.

    /**  Item
    **/        
    
    FIND FIRST requisicao NO-LOCK
        WHERE requisicao.nr-requisicao =  integer(tt-mla-chave.valor[1]) NO-ERROR.
    IF AVAIL requisicao THEN ASSIGN c-cod-estabel = requisicao.cod-estabel.
    FIND estabelec 
        WHERE estabelec.cod-estabel = requisicao.cod-estabel NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
       run cdp/cd9970.p (input  ROWID(estabelec),
                         output i-empresa).

    FIND FIRST mla-tipo-doc-aprov NO-LOCK
         WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
           AND mla-tipo-doc-aprov.cod-estabel = c-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 3  NO-ERROR.

    IF  AVAIL mla-tipo-doc-aprov AND
        mla-tipo-doc-aprov.apr-tip-doc THEN DO:

        FIND FIRST it-requisicao NO-LOCK
            WHERE it-requisicao.nr-requisicao = INT(tt-mla-chave.valor[1])
              AND it-requisicao.sequencia     = INT(tt-mla-chave.valor[2])
              AND it-requisicao.it-codigo     = tt-mla-chave.valor[3] NO-ERROR.

        assign gc-lotacao-doc = it-requisicao.sc-codigo.
    
        IF  it-requisicao.int-1 <> 0  THEN DO:
            FIND FIRST ord-prod WHERE 
                ord-prod.nr-ord-produ = it-requisicao.int-1 
                NO-LOCK NO-ERROR.
            IF  AVAIL ord-prod THEN
                ASSIGN gc-lotacao-doc = ord-prod.sc-desp.
        END.
        assign c-narrativa = substring(it-requisicao.narrativa,1,40)
               de-total = it-requisicao.val-item.

        RUN setEpcRequis IN THIS-PROCEDURE.
        
        /*chamado TPOLOI - Rodrigo*/
        /*IF AVAIL requisicao THEN DO:
            FIND FIRST mla-usuar-aprov
                WHERE mla-usuar-aprov.nome-usuar = requisicao.nome-abrev NO-LOCK NO-ERROR.
            IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.mo-codigo <> 0 THEN DO:
                RUN cdp/cd0812.p   (INPUT  0,                        /* Moeda Origem*/
                                                                    INPUT  mla-usuar-aprov.mo-codigo,/* Moeda Destino*/
                                                                    INPUT  de-total,                         /* Valor Origem a converter */
                                                                    INPUT  TODAY,                    /* Datas da Convers∆o*/
                                                                    OUTPUT de-total).                        /* Valor retorno convertido */

                        if de-total = ? then
                                assign de-total = 0.
            END.
        END.*/

        RUN setGeraPendencia IN THIS-PROCEDURE (3,
                                                p-transacao,
                                                c-narrativa,
                                                de-total,
                                                0,
                                                c-seg-usuario,
                                                requisicao.nome-abrev,
                                                gc-lotacao-doc,
                                                it-requisicao.it-codigo,
                                                it-requisicao.ct-codigo,
                                                i-empresa,
                                                requisicao.cod-estabel,
                                                input table tt-mla-chave,
                                                OUTPUT TABLE RowErrors).                      
    END.
    ELSE DO:
        /**  Total
        **/
          assign i-posicao = 0.
        {lap/mlaapi001.i01}  /* elimina temp-tables */
        create tt-mla-chave. /* Monta tt-mla-chave */
        for each mla-chave-doc-aprov no-lock
           where mla-chave-doc-aprov.cod-tip-doc = 4:
            assign i-posicao = i-posicao + 1.
            assign tt-mla-chave.valor[i-posicao] = trim(substring(p-chave-doc,
                                                                  mla-chave-doc-aprov.posicao-ini,
                                                                  (mla-chave-doc-aprov.posicao-fim + 1 - 
                                                                  mla-chave-doc-aprov.posicao-ini))).
          
        end.
    
        FIND FIRST requisicao NO-LOCK
            WHERE requisicao.nr-requisicao =  INT(tt-mla-chave.valor[1]) NO-ERROR.
        IF AVAIL requisicao THEN ASSIGN c-cod-estabel = requisicao.cod-estabel.
        FIND estabelec 
            WHERE estabelec.cod-estabel = requisicao.cod-estabel NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN
           run cdp/cd9970.p (input  ROWID(estabelec),
                             output i-empresa).
    
        FIND FIRST mla-tipo-doc-aprov NO-LOCK
             WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
               AND mla-tipo-doc-aprov.cod-estabel = c-cod-estabel
               AND mla-tipo-doc-aprov.cod-tip-doc = 4  NO-ERROR.

        IF  AVAIL mla-tipo-doc-aprov AND
            mla-tipo-doc-aprov.apr-tip-doc THEN DO:

            FIND requisicao NO-LOCK
                WHERE requisicao.nr-requisicao = INT(tt-mla-chave.valor[1]) NO-ERROR.
        
            /*Limpando a vari†vel*/
            ASSIGN de-total = 0.
            FOR EACH it-requisicao 
                WHERE it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
                ASSIGN de-total = de-total + it-requisicao.val-item.
            END.
    
            {lap/mlaapi001.i01}
            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(requisicao.nr-requisicao).
    
            /*chamado TPNBZL - Manuela*/
            /*IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.mo-codigo <> 0 THEN DO:
                RUN cdp/cd0812.p   (INPUT  0,                         /* Moeda Origem*/
                                    INPUT  mla-usuar-aprov.mo-codigo, /* Moeda Destino*/
                                    INPUT  de-total,                          /* Valor Origem a converter */
                                    INPUT  TODAY,                     /* Datas da Convers∆o*/
                                    OUTPUT de-total).                         /* Valor retorno convertido */
    
                if de-total = ? then
                    assign de-total = 0.
            END.*/
    
            RUN setGeraPendencia IN THIS-PROCEDURE (4,
                                                    p-transacao,
                                                    c-narrativa,
                                                    de-total,
                                                    0,
                                                    c-seg-usuario,
                                                    requisicao.nome-abrev,
                                                    "",
                                                    "",
                                                    requisicao.cod-estabel,
                                                    i-empresa,
                                                    requisicao.cod-estabel,
                                                    input table tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).                      
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendSolCot DBOProgram 
PROCEDURE geraPendSolCot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE i-posicao AS INTEGER INITIAL 0 NO-UNDO.

    /**  mlaapi010E
    **/
    if  p-transacao = 1 then
        assign p-transacao = 2.

    {lap/mlaapi001.i01}  /* elimina temp-tables */
    create tt-mla-chave. /* Monta tt-mla-chave */
    for each mla-chave-doc-aprov no-lock
       where mla-chave-doc-aprov.cod-tip-doc = 18:
        assign i-posicao = i-posicao + 1.
        assign tt-mla-chave.valor[i-posicao] = trim(substring(p-chave-doc,
                                                              mla-chave-doc-aprov.posicao-ini,
                                                              (mla-chave-doc-aprov.posicao-fim + 1 - 
                                                              mla-chave-doc-aprov.posicao-ini))).
       
    END.    
    FIND FIRST it-requisicao NO-LOCK
        WHERE it-requisicao.nr-requisicao =  integer(tt-mla-chave.valor[1])
          AND it-requisicao.sequencia     =  integer(tt-mla-chave.valor[2])
          AND it-requisicao.it-codigo     =  tt-mla-chave.valor[3] NO-ERROR.
    
    IF AVAIL it-requisicao THEN
        FIND FIRST requisicao NO-LOCK
            WHERE requisicao.nr-requisicao = it-requisicao.nr-requisicao NO-ERROR.    

    IF AVAIL requisicao THEN DO:    
        /**  Item
        **/        
        
        ASSIGN c-cod-estabel = requisicao.cod-estabel.
        FIND estabelec 
            WHERE estabelec.cod-estabel = requisicao.cod-estabel NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN
           run cdp/cd9970.p (input  ROWID(estabelec),
                             output i-empresa).

        FIND FIRST mla-tipo-doc-aprov NO-LOCK
             WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
               AND mla-tipo-doc-aprov.cod-estabel = c-cod-estabel
               AND mla-tipo-doc-aprov.cod-tip-doc = 18  NO-ERROR.

        IF  AVAIL mla-tipo-doc-aprov AND
            mla-tipo-doc-aprov.apr-tip-doc THEN DO:
            {lap/mlaapi001.i01}
            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(requisicao.nr-requisicao)
                   tt-mla-chave.valor[2] = string(it-requisicao.sequencia)
                   tt-mla-chave.valor[3] = string(it-requisicao.it-codigo).
        
            ASSIGN c-lotacao-doc = it-requisicao.sc-codigo.
    
            FIND FIRST param-global NO-LOCK NO-ERROR.
            IF it-requisicao.int-1 <> 0  THEN DO:
                FIND FIRST ord-prod WHERE 
                    ord-prod.nr-ord-produ = it-requisicao.int-1 
                    NO-LOCK NO-ERROR.
                IF  AVAIL ord-prod THEN
                    ASSIGN c-lotacao-doc = substring(ord-prod.conta-despesa,(LENGTH(TRIM(param-global.ct-format)) + 1),8).
                ELSE 
                    c-lotacao-doc = it-requisicao.sc-codigo.
            END.
    
            ASSIGN de-total = it-requisicao.val-item.

            /*chamado TPOLOI - Rodrigo*/
            /*FIND FIRST mla-usuar-aprov
                WHERE mla-usuar-aprov.nome-usuar = requisicao.nome-abrev NO-LOCK NO-ERROR.
            IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.mo-codigo <> 0 THEN DO:
                RUN cdp/cd0812.p   (INPUT  0,                                            /* Moeda Origem*/
                                    INPUT  mla-usuar-aprov.mo-codigo,/* Moeda Destino*/
                                    INPUT  de-total,                     /* Valor Origem a converter */
                                    INPUT  TODAY,                    /* Datas da Convers∆o*/
                                    OUTPUT de-total).                    /* Valor retorno convertido */

                if de-total = ? then
                    assign de-total = 0.
            END.*/
                 
            RUN setGeraPendencia IN THIS-PROCEDURE (18,
                                                    p-transacao,
                                                    substring(it-requisicao.narrativa,1,40),
                                                    de-total,
                                                    0,
                                                    requisicao.nome-abrev,
                                                    requisicao.nome-abrev,
                                                    c-lotacao-doc,
                                                    it-requisicao.it-codigo,
                                                    it-requisicao.ct-codigo,
                                                    i-empresa,
                                                    requisicao.cod-estabel,
                                                    input  table tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).   
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendSolic DBOProgram 
PROCEDURE geraPendSolic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

     DEFINE VARIABLE i-posicao AS INTEGER INITIAL 0 NO-UNDO.

    /**  mlaapi010A
    **/
    if  p-transacao = 1 then
        assign p-transacao = 2.

    /**  Item
    **/  

    {lap/mlaapi001.i01}  /* elimina temp-tables */
    create tt-mla-chave. /* Monta tt-mla-chave */
    for each mla-chave-doc-aprov no-lock
       where mla-chave-doc-aprov.cod-tip-doc = 1:
        assign i-posicao = i-posicao + 1.
        assign tt-mla-chave.valor[i-posicao] = trim(substring(p-chave-doc,
                                                              mla-chave-doc-aprov.posicao-ini,
                                                              (mla-chave-doc-aprov.posicao-fim + 1 - 
                                                              mla-chave-doc-aprov.posicao-ini))).
       
    END.
    
    FIND FIRST requisicao NO-LOCK
        WHERE requisicao.nr-requisicao = INT( tt-mla-chave.valor[1]) NO-ERROR.
    IF AVAIL requisicao THEN ASSIGN c-cod-estabel = requisicao.cod-estabel.
    FIND estabelec 
        WHERE estabelec.cod-estabel = requisicao.cod-estabel NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
       run cdp/cd9970.p (input  ROWID(estabelec),
                         output i-empresa).

    FIND FIRST mla-tipo-doc-aprov NO-LOCK
         WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
           AND mla-tipo-doc-aprov.cod-estabel = c-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 1  NO-ERROR.

    IF  AVAIL mla-tipo-doc-aprov AND
        mla-tipo-doc-aprov.apr-tip-doc THEN DO:
        FIND FIRST it-requisicao NO-LOCK
            WHERE it-requisicao.nr-requisicao = INT( tt-mla-chave.valor[1])
              AND it-requisicao.sequencia     = INT( tt-mla-chave.valor[2])
              AND it-requisicao.it-codigo     = tt-mla-chave.valor[3] NO-ERROR.
        
        assign gc-lotacao-doc = it-requisicao.sc-codigo.
    
        IF  it-requisicao.int-1 <> 0  THEN DO:
            FIND FIRST ord-prod WHERE 
                ord-prod.nr-ord-produ = it-requisicao.int-1 
                NO-LOCK NO-ERROR.
            IF  AVAIL ord-prod THEN
                ASSIGN gc-lotacao-doc = ord-prod.sc-desp.
        END.
        
        /* Mesma logica usada na mlaapi010a pi-executar */
        IF it-requisicao.numero-ordem <> 0 THEN DO:
            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.numero-ordem = it-requisicao.numero-ordem NO-ERROR.
            IF AVAIL ordem-compra THEN
                FIND FIRST cotacao-item NO-LOCK
                     WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                       AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                       AND cotacao-item.cot-aprovada NO-ERROR.
                IF AVAIL cotacao-item AND AVAIL ordem-compra THEN
                    assign de-total  = cotacao-item.preco-unit * ordem-compra.qt-solic.
                ELSE
                    ASSIGN de-total = it-requisicao.val-item.
            END.
        ELSE
            ASSIGN de-total = it-requisicao.val-item.
        
        assign c-narrativa = substring(it-requisicao.narrativa,1,40).

        /*Valor que ser† convertido*/
        //ASSIGN de-total = it-requisicao.val-item.

        /*chamado TPOLOI - Rodrigo*/
        /*IF AVAIL requisicao THEN DO:
            FIND FIRST mla-usuar-aprov
                WHERE mla-usuar-aprov.nome-usuar = requisicao.nome-abrev NO-LOCK NO-ERROR.
            IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.mo-codigo <> 0 THEN DO:
                RUN cdp/cd0812.p   (INPUT  0,                        /* Moeda Origem*/
                                                                    INPUT  mla-usuar-aprov.mo-codigo,/* Moeda Destino*/
                                                                    INPUT  de-total,                         /* Valor Origem a converter */
                                                                    INPUT  TODAY,                    /* Datas da Convers∆o*/
                                                                    OUTPUT de-total).                        /* Valor retorno convertido */

                        if de-total = ? then
                                assign de-total = 0.
            END.
        END.*/
            
    
        RUN setEpcSolic IN THIS-PROCEDURE.

        RUN setGeraPendencia IN THIS-PROCEDURE (1,
                                                p-transacao,
                                                c-narrativa,
                                                de-total,
                                                0,
                                                c-seg-usuario,
                                                requisicao.nome-abrev,
                                                gc-lotacao-doc,
                                                it-requisicao.it-codigo,
                                                it-requisicao.ct-codigo,
                                                i-empresa,
                                                requisicao.cod-estabel,
                                                input table tt-mla-chave,
                                                OUTPUT TABLE RowErrors).                      
    END.
    ELSE DO:
        /**  Total
        **/

        FIND FIRST requisicao NO-LOCK
            WHERE requisicao.nr-requisicao = INT(INT( tt-mla-chave.valor[1])) NO-ERROR.
        IF AVAIL requisicao THEN ASSIGN c-cod-estabel = requisicao.cod-estabel.
        FIND estabelec 
            WHERE estabelec.cod-estabel = requisicao.cod-estabel NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN
           run cdp/cd9970.p (input  ROWID(estabelec),
                             output i-empresa).

        FIND FIRST mla-tipo-doc-aprov NO-LOCK
             WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
               AND mla-tipo-doc-aprov.cod-estabel = c-cod-estabel
               AND mla-tipo-doc-aprov.cod-tip-doc = 2  NO-ERROR.

        IF  AVAIL mla-tipo-doc-aprov AND
            mla-tipo-doc-aprov.apr-tip-doc THEN DO:

            ASSIGN de-total = 0.
            FOR EACH it-requisicao 
                WHERE it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
                ASSIGN de-total = de-total + it-requisicao.val-item.
            END.

            /*chamado TPNBZL - Manuela*/
            /*IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.mo-codigo <> 0 THEN DO:
                RUN cdp/cd0812.p   (INPUT  0,                        /* Moeda Origem*/
                                    INPUT  mla-usuar-aprov.mo-codigo,/* Moeda Destino*/
                                    INPUT  de-total,                         /* Valor Origem a converter */
                                    INPUT  TODAY,                    /* Datas da Convers∆o*/
                                    OUTPUT de-total).                        /* Valor retorno convertido */

                if de-total = ? then
                    assign de-total = 0.
            END.*/

            {lap/mlaapi001.i01}
            create tt-mla-chave.
            assign tt-mla-chave.valor[1] = string(requisicao.nr-requisicao).
            RUN setGeraPendencia IN THIS-PROCEDURE (2,
                                                    p-transacao,
                                                    c-narrativa,
                                                    de-total,
                                                    0,
                                                    c-seg-usuario,
                                                    requisicao.nome-abrev,
                                                    "",
                                                    "",
                                                    requisicao.cod-estabel,
                                                    i-empresa,
                                                    requisicao.cod-estabel,
                                                    input table tt-mla-chave,
                                                    OUTPUT TABLE RowErrors).                      
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraPendSolicServ DBOProgram 
PROCEDURE geraPendSolicServ :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-transacao   AS INTEGER                        NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc   LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    /*manuela*/
    /**  mlaapi020I
    **/

    IF  p-transacao = 1 THEN
        ASSIGN p-transacao = 2.

    FIND FIRST param-mi NO-LOCK NO-ERROR.

    FIND FIRST solic-serv 
         WHERE solic-serv.nr-soli-serv = INT(p-chave-doc) NO-LOCK NO-ERROR.

    IF  NOT AVAIL solic-serv THEN
        RETURN "NOK".

    IF  solic-serv.cd-equipto <> "" THEN DO:
        FIND FIRST equipto 
             WHERE equipto.cd-equipto = solic-serv.cd-equipto NO-LOCK NO-ERROR.
        IF  AVAIL equipto THEN 
            ASSIGN c-cod-estabel = equipto.cod-estabel.
    END.
    ELSE DO:
        FIND FIRST tag 
             WHERE tag.cd-tag = solic-serv.cd-tag NO-LOCK NO-ERROR.
        IF  AVAIL tag THEN 
            ASSIGN c-cod-estabel = tag.cod-estabel.
    END.

    FIND FIRST msg-solic-serv
         WHERE msg-solic-serv.nr-soli-serv = solic-serv.nr-soli-serv NO-LOCK NO-ERROR.
    IF AVAIL msg-solic-serv THEN
        ASSIGN c-narrativa = msg-solic-serv.msg-exp.
    ELSE
        ASSIGN c-narrativa = "".

    FIND FIRST usuar-mater NO-LOCK
         WHERE usuar-mater.cod-usuario = solic-serv.nome-usua NO-ERROR.
    IF  AVAIL usuar-mater THEN
        ASSIGN c-lotacao = TRIM(SUBSTRING(usuar-mater.char-1,2,8)).

    ASSIGN de-valor-solserv = solic-serv.vl-orcado-mat + solic-serv.vl-orcado-mob.

    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.
    
    IF AVAIL estabelec THEN
       RUN cdp/cd9970.p (INPUT  ROWID(estabelec),
                         OUTPUT i-empresa).

    FIND FIRST mla-tipo-doc-aprov NO-LOCK
         WHERE mla-tipo-doc-aprov.ep-codigo   = i-empresa
           AND mla-tipo-doc-aprov.cod-estabel = c-cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = 20  NO-ERROR.

    IF  AVAIL mla-tipo-doc-aprov AND
        mla-tipo-doc-aprov.apr-tip-doc THEN DO:

        {lap/mlaapi001.i01}
        CREATE tt-mla-chave.
        ASSIGN tt-mla-chave.valor[1] = string(solic-serv.nr-soli-serv).

        RUN setGeraPendencia IN THIS-PROCEDURE (20,
                                                p-transacao,
                                                c-narrativa,
                                                de-valor-solserv,
                                                0,
                                                c-seg-usuario,
                                                solic-serv.nome-usua,
                                                c-lotacao,
                                                param-mi.it-codigo,
                                                0,
                                                i-empresa,
                                                c-cod-estabel,
                                                INPUT  TABLE tt-mla-chave,
                                                OUTPUT TABLE RowErrors).    

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice transacao
  Parameters:  
               retorna valor do campo nr-trans
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-trans LIKE mla-doc-pend-aprov.nr-trans NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-trans = RowObject.nr-trans.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextTipoAprov DBOProgram 
PROCEDURE getNextTipoAprov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-tip-aprov  AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-aprov  AS INTEGER NO-UNDO.

    ASSIGN l-prox-prior = NO.

    CASE p-tip-aprov:
        WHEN 1 THEN DO:
            find FIRST mla-tipo-aprov-doc NO-LOCK
                 where mla-tipo-aprov-doc.ep-codigo        = i-ep-codigo   
                 and   mla-tipo-aprov-doc.cod-tip-doc      = i-cod-tip-doc 
                 and   mla-tipo-aprov-doc.prioridade-aprov = gi-prox-prior no-error.
            if  available mla-tipo-aprov-doc then
                ASSIGN p-cod-aprov  = mla-tipo-aprov-doc.cod-tip-aprov
                       l-prox-prior = YES.
        END.
        WHEN 2 THEN DO:
            find first mla-tipo-aprov-item NO-LOCK
                where  mla-tipo-aprov-item.ep-codigo        = i-ep-codigo 
                and    mla-tipo-aprov-item.it-codigo        = c-it-codigo 
                and    mla-tipo-aprov-item.prioridade-aprov = gi-prox-prior no-error.    
            IF  AVAILABLE mla-tipo-aprov-item THEN
                ASSIGN p-cod-aprov  = mla-tipo-aprov-item.cod-tip-aprov
                       l-prox-prior = YES.
        END.
        WHEN 3 THEN DO:
            FIND FIRST ITEM NO-LOCK 
                WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.
            IF  AVAILABLE ITEM THEN
                ASSIGN c-fm-codigo = ITEM.fm-codigo.
            
            find FIRST mla-tipo-aprov-fam NO-LOCK
                 where mla-tipo-aprov-fam.ep-codigo        = i-ep-codigo 
                 and   mla-tipo-aprov-fam.fm-codigo        = c-fm-codigo 
                 and   mla-tipo-aprov-fam.prioridade-aprov = gi-prox-prior no-error.    
            IF  AVAILABLE mla-tipo-aprov-fam THEN
                ASSIGN p-cod-aprov  = mla-tipo-aprov-fam.cod-tip-aprov
                       l-prox-prior = YES.
        END.
        WHEN 4 THEN DO:
            FIND FIRST mla-tipo-aprov-ref NO-LOCK
                 where mla-tipo-aprov-ref.ep-codigo        = i-ep-codigo 
                 and   mla-tipo-aprov-ref.cod-tip-doc      = i-cod-tip-doc 
                 and   mla-tipo-aprov-ref.codigo           = c-cod-referencia 
                 and   mla-tipo-aprov-ref.prioridade-aprov = gi-prox-prior no-error.    
            IF  AVAILABLE mla-tipo-aprov-ref THEN
                ASSIGN p-cod-aprov  = mla-tipo-aprov-ref.cod-tip-aprov
                       l-prox-prior = YES.
        END.
    END CASE.

    IF  NOT l-prox-prior THEN
        RETURN "NOK".

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice transacao
  Parameters:  
               recebe valor do campo nr-trans
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-trans LIKE mla-doc-pend-aprov.nr-trans NO-UNDO.

    FIND FIRST bfmla-doc-pend-aprov WHERE 
        bfmla-doc-pend-aprov.nr-trans = pnr-trans NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-doc-pend-aprov THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-doc-pend-aprov)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeBO DBOProgram 
PROCEDURE initializeBO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    IF  NOT VALID-HANDLE(hmla-param-aprov) THEN DO:
        RUN inbo/boin773.p PERSISTENT SET hmla-param-aprov.    
        run openQueryStatic in hmla-param-aprov (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-tipo-doc-aprov) THEN DO:
        RUN inbo/boin784.p PERSISTENT SET hmla-tipo-doc-aprov.
        run openQueryStatic in hmla-tipo-doc-aprov (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-chave-doc) THEN DO:
        RUN inbo/boin789.p PERSISTENT SET hmla-chave-doc.
        run openQueryStatic in hmla-chave-doc (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-usuar-aprov) THEN DO:
        RUN inbo/boin785.p PERSISTENT SET hmla-usuar-aprov.
        run openQueryStatic in hmla-usuar-aprov (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-perm-aprov) THEN DO:
        RUN inbo/boin774.p PERSISTENT SET hmla-perm-aprov.
        run openQueryStatic in hmla-perm-aprov (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-verba-aprov) THEN DO:
        RUN inbo/boin788.p PERSISTENT SET hmla-verba-aprov.
        run openQueryStatic in hmla-verba-aprov (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-usuar-aprov-altern) THEN DO:
        RUN inbo/boin786.p PERSISTENT SET hmla-usuar-aprov-altern.
        run openQueryStatic in hmla-usuar-aprov-altern (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-tipo-aprov) THEN DO:
        RUN inbo/boin779.p PERSISTENT SET hmla-tipo-aprov.
        run openQueryStatic in hmla-tipo-aprov (input "Main").
    END.

    IF  NOT VALID-HANDLE(hmla-tipo-aprov-item) THEN DO:
        RUN inbo/boin782.p PERSISTENT SET hmla-tipo-aprov-item.
        run openQueryStatic in hmla-tipo-aprov-item (input "Main").
        RUN getFirst IN hmla-tipo-aprov-item.
        RUN getBatchRecords IN hmla-tipo-aprov-item (INPUT ?,
                                          INPUT NO,
                                          INPUT ?,
                                          OUTPUT iRowsReturned,
                                          OUTPUT TABLE tt-mla-tipo-aprov-item).
    END. 
    IF  NOT VALID-HANDLE(hmla-tipo-aprov-fam) THEN DO:
        RUN inbo/boin781.p PERSISTENT SET hmla-tipo-aprov-fam.
        run openQueryStatic in hmla-tipo-aprov-fam (input "Main").
        RUN getFirst IN hmla-tipo-aprov-fam.
        RUN getBatchRecords IN hmla-tipo-aprov-fam (INPUT ?,
                                          INPUT NO,
                                          INPUT ?,
                                          OUTPUT iRowsReturned,
                                          OUTPUT TABLE tt-mla-tipo-aprov-fam).
    END.
    IF  NOT VALID-HANDLE(hmla-tipo-aprov-doc) THEN DO:
        RUN inbo/boin780.p PERSISTENT SET hmla-tipo-aprov-doc.
        run openQueryStatic in hmla-tipo-aprov-doc (input "Main").
        RUN getFirst IN hmla-tipo-aprov-doc.
        RUN getBatchRecords IN hmla-tipo-aprov-doc (INPUT ?,
                                          INPUT NO,
                                          INPUT ?,
                                          OUTPUT iRowsReturned,
                                          OUTPUT TABLE tt-mla-tipo-aprov-doc).
    END.
    IF  NOT VALID-HANDLE(hmla-tipo-aprov-ref) THEN DO:
        RUN inbo/boin783.p PERSISTENT SET hmla-tipo-aprov-ref.
        run openQueryStatic in hmla-tipo-aprov-ref (input "Main").
        RUN getFirst IN hmla-tipo-aprov-ref.
        RUN getBatchRecords IN hmla-tipo-aprov-ref (INPUT ?,
                                          INPUT NO,
                                          INPUT ?,
                                          OUTPUT iRowsReturned,
                                          OUTPUT TABLE tt-mla-tipo-aprov-ref).
    END.
    IF  NOT VALID-HANDLE(hmla-hierarquia-aprov) THEN DO:
        RUN inbo/boin792.p PERSISTENT SET hmla-hierarquia-aprov.
        run openQueryStatic in hmla-hierarquia-aprov (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-lista-aprov-item) THEN DO:  
        RUN inbo/boin770.p PERSISTENT SET hmla-lista-aprov-item.
        run openQueryStatic in hmla-lista-aprov-item (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-lista-aprov-fam) THEN DO: 
        RUN inbo/boin796.p PERSISTENT SET hmla-lista-aprov-fam.
        run openQueryStatic in hmla-lista-aprov-fam (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-lista-aprov-doc) THEN DO: 
        RUN inbo/boin795.p PERSISTENT SET hmla-lista-aprov-doc.
        run openQueryStatic in hmla-lista-aprov-doc (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-lista-aprov-ref) THEN DO:  
        RUN inbo/boin771.p PERSISTENT SET hmla-lista-aprov-ref.
        run openQueryStatic in hmla-lista-aprov-ref (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-usuar-padrao) THEN DO:  
        RUN inbo/boin787.p PERSISTENT SET hmla-usuar-padrao.
        run openQueryStatic in hmla-usuar-padrao (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-faixa-aprov) THEN DO: 
        RUN inbo/boin791.p PERSISTENT SET hmla-faixa-aprov.
        run openQueryStatic in hmla-faixa-aprov (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-hierarquia-faixa) THEN DO:
        RUN inbo/boin793.p PERSISTENT SET hmla-hierarquia-faixa.
        run openQueryStatic in hmla-hierarquia-faixa (input "Main").
    END.
    IF  NOT VALID-HANDLE(hmla-lim-aprov-fam) THEN DO:
        RUN inbo/boin794.p PERSISTENT SET hmla-lim-aprov-fam.
        run openQueryStatic in hmla-lim-aprov-fam (input "Main").
    END.

    /**
    IF  NOT VALID-HANDLE(hboin172) THEN DO:
        RUN inbo/boin172.p   PERSISTENT SET hboin172.
        run openQueryStatic in hboin172 (input "Main").
    END.
    **/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeHandles DBOProgram 
PROCEDURE initializeHandles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER P-hmla-lim-aprov-fam       AS HANDLE      NO-UNDO.
    DEFINE INPUT PARAMETER P-hmla-hierarquia-faixa    AS HANDLE      NO-UNDO.
    DEFINE INPUT PARAMETER P-hmla-hierarquia-aprov    AS HANDLE      NO-UNDO.
    DEFINE INPUT PARAMETER P-hmla-tipo-aprov          AS HANDLE      NO-UNDO.
    DEFINE INPUT PARAMETER P-hmla-usuar-aprov-altern  AS HANDLE      NO-UNDO.
    DEFINE INPUT PARAMETER P-hmla-verba-aprov         AS HANDLE      NO-UNDO.
    DEFINE INPUT PARAMETER P-hmla-perm-aprov          AS HANDLE      NO-UNDO.
    DEFINE INPUT PARAMETER P-hmla-usuar-aprov         AS HANDLE      NO-UNDO.
    DEFINE INPUT PARAMETER P-hmla-tipo-doc-aprov      AS HANDLE      NO-UNDO.
    DEFINE INPUT PARAMETER P-hmla-param-aprov         AS HANDLE      NO-UNDO.
    DEFINE INPUT PARAMETER P-hmla-tipo-aprov-item     AS HANDLE      NO-UNDO.
    DEFINE INPUT PARAMETER P-hmla-tipo-aprov-fam      AS HANDLE      NO-UNDO.
    DEFINE INPUT PARAMETER P-hmla-tipo-aprov-doc      AS HANDLE      NO-UNDO.
    DEFINE INPUT PARAMETER P-hmla-chave-doc           AS HANDLE      NO-UNDO.



    IF  NOT VALID-HANDLE(hmla-tipo-aprov-ref) THEN DO:
        RUN inbo/boin783.p PERSISTENT SET hmla-tipo-aprov-ref.
        run openQueryStatic in hmla-tipo-aprov-ref (input "Main").
        RUN getFirst IN hmla-tipo-aprov-ref.
        RUN getBatchRecords IN hmla-tipo-aprov-ref (INPUT ?,
                                          INPUT NO,
                                          INPUT ?,
                                          OUTPUT iRowsReturned,
                                          OUTPUT TABLE tt-mla-tipo-aprov-ref).
    END.


    IF  NOT VALID-HANDLE(hmla-lista-aprov-item) THEN DO:
        RUN inbo/boin770.p PERSISTENT SET hmla-lista-aprov-item.     
        run openQueryStatic in hmla-lista-aprov-item (input "Main"). 
    END.  

    IF  NOT VALID-HANDLE(hmla-lista-aprov-fam) THEN DO:
        RUN inbo/boin796.p PERSISTENT SET hmla-lista-aprov-fam.      
        run openQueryStatic in hmla-lista-aprov-fam (input "Main").  
    END.  
    IF  NOT VALID-HANDLE(hmla-lista-aprov-doc) THEN DO:
        RUN inbo/boin795.p PERSISTENT SET hmla-lista-aprov-doc.
        run openQueryStatic in hmla-lista-aprov-doc (input "Main").  
    END.  

    IF  NOT VALID-HANDLE(hmla-lista-aprov-ref) THEN DO:
        RUN inbo/boin771.p PERSISTENT SET hmla-lista-aprov-ref.      
        run openQueryStatic in hmla-lista-aprov-ref (input "Main").  
    END.  
    IF  NOT VALID-HANDLE(hmla-usuar-padrao) THEN DO:
        RUN inbo/boin787.p PERSISTENT SET hmla-usuar-padrao.         
        run openQueryStatic in hmla-usuar-padrao (input "Main").     
    END.  
    IF  NOT VALID-HANDLE(hmla-faixa-aprov) THEN DO:
        RUN inbo/boin791.p PERSISTENT SET hmla-faixa-aprov.          
        run openQueryStatic in hmla-faixa-aprov (input "Main").      
    END.

    ASSIGN  hmla-lim-aprov-fam      = P-hmla-lim-aprov-fam     
            hmla-hierarquia-faixa   = P-hmla-hierarquia-faixa  
            hmla-hierarquia-aprov   = P-hmla-hierarquia-aprov  
            hmla-tipo-aprov         = P-hmla-tipo-aprov        
            hmla-usuar-aprov-altern = P-hmla-usuar-aprov-altern
            hmla-verba-aprov        = P-hmla-verba-aprov       
            hmla-perm-aprov         = P-hmla-perm-aprov        
            hmla-usuar-aprov        = P-hmla-usuar-aprov       
            hmla-tipo-doc-aprov     = P-hmla-tipo-doc-aprov    
            hmla-param-aprov        = P-hmla-param-aprov       
            hmla-tipo-aprov-item    = P-hmla-tipo-aprov-item   
            hmla-tipo-aprov-fam     = P-hmla-tipo-aprov-fam    
            hmla-tipo-aprov-doc     = P-hmla-tipo-aprov-doc    
            hmla-chave-doc          = P-hmla-chave-doc .


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
    DEF INPUT PARAMETER p-ordem AS CHAR NO-UNDO.

    RUN openQueryStatic (input "Main":U). 

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
    open query {&QUERYNAME} 
        for each {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-tipo-aprov-doc DBOProgram 
PROCEDURE pi-verifica-tipo-aprov-doc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   find first mla-tipo-aprov-doc 
        where mla-tipo-aprov-doc.ep-codigo        = i-ep-codigo 
          and mla-tipo-aprov-doc.cod-tip-doc      = i-cod-tip-doc 
          and mla-tipo-aprov-doc.prioridade-aprov = gi-prox-prior + 10 no-lock no-error.

   if not avail mla-tipo-aprov-doc and gi-prox-prior = 0 then
       find first mla-tipo-aprov-doc 
            where mla-tipo-aprov-doc.ep-codigo        = i-ep-codigo 
              and mla-tipo-aprov-doc.cod-tip-doc      = i-cod-tip-doc 
              and mla-tipo-aprov-doc.prioridade-aprov = 10 no-lock no-error.

   if available mla-tipo-aprov-doc then do:
       assign i-tip-aprov       = 1
              i-cod-aprov       = mla-tipo-aprov-doc.cod-tip-aprov
              i-prioridade      = mla-tipo-aprov-doc.prioridade-aprov
              l-lim-lista       = mla-tipo-aprov-doc.log-limite
              l-tipo-aprov-ref  = no
              l-tipo-aprov-item = no
              l-tipo-aprov-fam  = no
              l-tipo-aprov-doc  = yes.
       return "OK":U.
    end.
    else 
        assign l-pri-aprov-ant = can-find(first mla-tipo-aprov-doc 
                                          where mla-tipo-aprov-doc.ep-codigo        = i-ep-codigo 
                                            and mla-tipo-aprov-doc.cod-tip-doc      = i-cod-tip-doc 
                                            and mla-tipo-aprov-doc.prioridade-aprov < gi-prox-prior + 10).

    
    return "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-tipo-aprov-fam DBOProgram 
PROCEDURE pi-verifica-tipo-aprov-fam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   find first item where item.it-codigo = c-it-codigo no-lock no-error.

   if avail item then
       find first mla-tipo-aprov-fam 
            where mla-tipo-aprov-fam.ep-codigo        = i-ep-codigo 
              and mla-tipo-aprov-fam.fm-codigo        = item.fm-codigo 
              and mla-tipo-aprov-fam.prioridade-aprov = gi-prox-prior + 10 no-lock  no-error.

   if avail item and not avail mla-tipo-aprov-fam and gi-prox-prior = 0 then
       find first mla-tipo-aprov-fam 
            where mla-tipo-aprov-fam.ep-codigo        = i-ep-codigo 
              and mla-tipo-aprov-fam.fm-codigo        = item.fm-codigo 
              and mla-tipo-aprov-fam.prioridade-aprov = 10 no-lock  no-error.

   if available mla-tipo-aprov-fam then do:
       assign i-tip-aprov       = 3
              i-cod-aprov       = mla-tipo-aprov-fam.cod-tip-aprov
              i-prioridade      = mla-tipo-aprov-fam.prioridade-aprov
              l-lim-lista       = mla-tipo-aprov-fam.log-limite
              l-tipo-aprov-ref  = no
              l-tipo-aprov-item = no
              l-tipo-aprov-fam  = yes
              l-tipo-aprov-doc  = no.
       return "OK":U.
    end.
    else 
        if avail item then
            assign l-pri-aprov-ant = can-find(first mla-tipo-aprov-fam 
                                              where mla-tipo-aprov-fam.ep-codigo        = i-ep-codigo 
                                                and mla-tipo-aprov-fam.fm-codigo        = item.fm-codigo 
                                                and mla-tipo-aprov-fam.prioridade-aprov < gi-prox-prior + 10).

    return "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-tipo-aprov-item DBOProgram 
PROCEDURE pi-verifica-tipo-aprov-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   find first mla-tipo-aprov-item 
       where  mla-tipo-aprov-item.ep-codigo        = i-ep-codigo 
       and    mla-tipo-aprov-item.it-codigo        = c-it-codigo
       and    mla-tipo-aprov-item.prioridade-aprov = gi-prox-prior + 10 no-lock no-error.

   if not avail mla-tipo-aprov-item and gi-prox-prior = 0 then
       find first mla-tipo-aprov-item 
            where mla-tipo-aprov-item.ep-codigo        = i-ep-codigo 
              and mla-tipo-aprov-item.it-codigo        = c-it-codigo
              and mla-tipo-aprov-item.prioridade-aprov = 10 no-lock no-error.

   if available mla-tipo-aprov-item then do:
       assign i-tip-aprov       = 2
              i-cod-aprov       = mla-tipo-aprov-item.cod-tip-aprov
              i-prioridade      = mla-tipo-aprov-item.prioridade-aprov
              l-lim-lista       = mla-tipo-aprov-item.log-limite
              l-tipo-aprov-ref  = no
              l-tipo-aprov-item = yes
              l-tipo-aprov-fam  = no
              l-tipo-aprov-doc  = no.
        return "OK":U.
    end.
    else 
        assign l-pri-aprov-ant = can-find(first mla-tipo-aprov-item 
                                          where mla-tipo-aprov-item.ep-codigo        = i-ep-codigo 
                                            and mla-tipo-aprov-item.it-codigo        = c-it-codigo
                                            and mla-tipo-aprov-item.prioridade-aprov < gi-prox-prior + 10).

    return "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-tipo-aprov-ref DBOProgram 
PROCEDURE pi-verifica-tipo-aprov-ref :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find first mla-tipo-aprov-ref 
        where mla-tipo-aprov-ref.ep-codigo        = i-ep-codigo 
          and mla-tipo-aprov-ref.cod-tip-doc      = i-cod-tip-doc
          and mla-tipo-aprov-ref.codigo           = c-cod-referencia 
          and mla-tipo-aprov-ref.prioridade-aprov = gi-prox-prior + 10 no-lock no-error.

   if not avail mla-tipo-aprov-ref and gi-prox-prior = 0 then
       find first mla-tipo-aprov-ref 
            where mla-tipo-aprov-ref.ep-codigo        = i-ep-codigo 
              and mla-tipo-aprov-ref.cod-tip-doc      = i-cod-tip-doc
              and mla-tipo-aprov-ref.codigo           = c-cod-referencia 
              and mla-tipo-aprov-ref.prioridade-aprov = 10 no-lock no-error.
   
   if available mla-tipo-aprov-ref then do:
       assign i-tip-aprov       = 4
              i-cod-aprov       = mla-tipo-aprov-ref.cod-tip-aprov
              i-prioridade      = mla-tipo-aprov-ref.prioridade-aprov
              l-lim-lista       = mla-tipo-aprov-ref.log-limite
              l-tipo-aprov-ref  = yes
              l-tipo-aprov-item = no
              l-tipo-aprov-fam  = no
              l-tipo-aprov-doc  = no.
       return "OK":U.
    end.
    else
        assign l-pri-aprov-ant = can-find( first mla-tipo-aprov-ref 
                                           where mla-tipo-aprov-ref.ep-codigo        = i-ep-codigo 
                                             and mla-tipo-aprov-ref.cod-tip-doc      = i-cod-tip-doc
                                             and mla-tipo-aprov-ref.codigo           = c-cod-referencia 
                                             and mla-tipo-aprov-ref.prioridade-aprov < gi-prox-prior + 10).
    
        
    return "NOK":U.
    
             
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setChave DBOProgram 
PROCEDURE setChave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-chave AS INTEGER    NO-UNDO.

    ASSIGN c-chave = "".
    FIND FIRST tt-mla-chave NO-LOCK NO-ERROR.

    ASSIGN i-chave = 0.
    FOR EACH mla-chave-doc-aprov  NO-LOCK
       WHERE mla-chave-doc-aprov.cod-tip-doc = i-cod-tip-doc:
        ASSIGN i-chave = i-chave + 1
               c-chave = c-chave + tt-mla-chave.valor[i-chave] + substring("                    ",1,  
                                   (((mla-chave-doc-aprov.posicao-fim - mla-chave-doc-aprov.posicao-ini) + 1) - length(tt-mla-chave.valor[i-chave]))). 
    END.

    ASSIGN c-chave = RIGHT-TRIM(c-chave).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint DBOProgram 
PROCEDURE setConstraint :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-tip-doc AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-tipo-trans  AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-motivo      AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER p-valor       AS DECIMAL NO-UNDO.
    DEFINE INPUT PARAMETER p-moeda       AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-usuar-trans AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER p-usuar-doc   AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER p-lotacao-doc AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER p-item        AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER p-referencia  AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER p-ep-codigo   LIKE empresa.ep-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR tt-mla-chave.

    ASSIGN i-cod-tip-doc     = p-cod-tip-doc
           i-tipo-trans      = p-tipo-trans
           c-motivo-aprov    = p-motivo
           de-valor-aprov    = p-valor
           i-moeda           = p-moeda
           c-cod-usuar-trans = p-usuar-trans
           c-cod-usuar-doc   = p-usuar-doc
           c-cod-lotacao-doc = p-lotacao-doc
           c-it-codigo       = p-item
           c-cod-referencia  = p-referencia
           i-ep-codigo       = p-ep-codigo
           c-cod-estabel     = p-cod-estabel.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEnviaEmail DBOProgram 
PROCEDURE setEnviaEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-remetente AS CHARACTER NO-UNDO.                                         
    DEFINE INPUT PARAMETER p-rowid     AS ROWID     NO-UNDO.
    DEFINE VARIABLE c-anexo AS CHARACTER   NO-UNDO.

    FIND {&TABLENAME} WHERE
        ROWID({&TABLENAME}) = p-rowid
        NO-LOCK NO-ERROR.

    IF  NOT AVAILABLE {&TABLENAME} THEN
        RETURN "NOK":U.

    RUN pi-gerar-dados-extrato (INPUT "boin767b: PROCEDURE setEnviaEmail  ").

    RUN setEpcEmail IN THIS-PROCEDURE (INPUT 1).
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN setGeraMensagem IN THIS-PROCEDURE.

    ASSIGN i-tipo-email           = 0
           c-usuario-remetente    = ""
           c-email-remetente      = ""
           c-usuario-destinatario = ""
           c-email-destinatario   = ""
           l-email                = NO
           l-envia-email          = NO
           l-recebe-email         = NO
           l-email-html-doc       = NO
           l-email-html-usuar     = NO.

    FIND FIRST bf{&TABLENAME} WHERE
        bf{&TABLENAME}.ep-codigo     = {&TABLENAME}.ep-codigo   AND
        bf{&TABLENAME}.cod-estabel   = {&TABLENAME}.cod-estabel AND
        bf{&TABLENAME}.cod-tip-doc   = {&TABLENAME}.cod-tip-doc AND
        bf{&TABLENAME}.chave-doc     = {&TABLENAME}.chave-doc   AND
        bf{&tablename}.ind-situacao >= 1 AND
        bf{&TABLENAME}.historico     = NO
        NO-LOCK NO-ERROR.

    /**  Pendente de Aprovaá∆o
    **/
    IF  {&tablename}.ind-situacao = 1 THEN DO:
        IF  p-remetente <> "" THEN

            /**  Usu†rio para Aprovador
            **/
            ASSIGN c-usuario-remetente    = p-remetente
                   c-usuario-destinatario = {&TABLENAME}.cod-usuar.
        ELSE DO:
            IF  NOT AVAILABLE bf{&TABLENAME} THEN

                /**  Usu†rio para Aprovador
                **/
                ASSIGN c-usuario-remetente    = {&TABLENAME}.cod-usuar-trans
                       c-usuario-destinatario = {&TABLENAME}.cod-usuar.
            ELSE

                /**  Aprovador para Aprovador
                **/
                ASSIGN c-usuario-remetente    = (IF  bf{&TABLENAME}.cod-usuar-altern <> ""
                                                 THEN bf{&TABLENAME}.cod-usuar-altern
                                                 ELSE bf{&TABLENAME}.cod-usuar)
                       c-usuario-destinatario = {&TABLENAME}.cod-usuar.
        END.
    END.

    /**  Aprovado ou Rejeitado
    **/
    ELSE DO:
        /**  Aprovador para Usu†rio
        **/
        ASSIGN c-usuario-remetente    = (IF  {&TABLENAME}.cod-usuar-altern <> ""
                                         THEN {&TABLENAME}.cod-usuar-altern
                                         ELSE {&TABLENAME}.cod-usuar)
               c-usuario-destinatario = {&TABLENAME}.cod-usuar-doc.
    END.

    FIND FIRST mla-param-aprov NO-LOCK
         WHERE mla-param-aprov.ep-codigo   = {&TABLENAME}.ep-codigo 
           AND mla-param-aprov.cod-estabel = {&TABLENAME}.cod-estabel NO-ERROR.
    IF AVAIL mla-param-aprov THEN
        ASSIGN l-email            = mla-param-aprov.log-email
               l-anexar-conteudo  = mla-param-aprov.log-atachado
               l-log-exchange     = mla-param-aprov.log-exchange
               c-compl-email      = mla-param-aprov.compl-email
               c-servidor-email   = mla-param-aprov.servidor-email
               i-porta-email      = mla-param-aprov.porta-email
               l-log-aprov-altern = mla-param-aprov.log-aprov-altern.

    FIND FIRST mla-tipo-doc-aprov NO-LOCK
         WHERE mla-tipo-doc-aprov.ep-codigo   = {&TABLENAME}.ep-codigo 
           AND mla-tipo-doc-aprov.cod-estabel = {&TABLENAME}.cod-estabel
           AND mla-tipo-doc-aprov.cod-tip-doc = {&TABLENAME}.cod-tip-doc NO-ERROR.
    IF  AVAIL mla-tipo-doc-aprov THEN
        ASSIGN l-email-html-doc = mla-tipo-doc-aprov.log-html
               c-des-tip-doc    = mla-tipo-doc-aprov.des-tip-doc.

    FIND FIRST mla-usuar-aprov NO-LOCK
         WHERE mla-usuar-aprov.cod-usuar = c-usuario-remetente NO-ERROR.
    IF AVAIL mla-usuar-aprov THEN
        ASSIGN l-envia-email     = mla-usuar-aprov.envia-email
               c-email-remetente = mla-usuar-aprov.e-mail.

    ASSIGN c-anexo = "".
    IF c-nom-prog-upc-mg97 <> "" THEN DO:
        FOR EACH tt-epc
           WHERE tt-epc.cod-event = "pi-envia-e-mail".
            DELETE tt-epc.
        END.
        {include/i-epc200.i2 &CodEvent='"pi-envia-e-mail"'
                             &CodParameter='"rowid-mla-doc-pend-aprov"'
                             &ValueParameter="string(rowid(mla-doc-pend-aprov))"}
        {include/i-epc201.i "pi-envia-e-mail"}
        FIND FIRST tt-epc NO-LOCK
             WHERE tt-epc.cod-event     = "pi-envia-e-mail"
               AND tt-epc.cod-parameter = "arquivo-anexo" NO-ERROR.
        IF AVAIL tt-epc THEN
            ASSIGN c-anexo = tt-epc.val-parameter.
    END.
    /**  Usu†rios do E-mail
    **/
    EMPTY TEMP-TABLE tt-usuar-email.
    CREATE tt-usuar-email.
    ASSIGN tt-usuar-email.cod-usuar = c-usuario-destinatario.
    IF  l-log-aprov-altern AND
        {&tablename}.ind-situacao = 1 THEN DO:
        FOR EACH mla-usuar-aprov-altern NO-LOCK
           WHERE mla-usuar-aprov-altern.cod-usuar     = c-usuario-destinatario 
             AND mla-usuar-aprov-altern.validade-ini <= {&TABLENAME}.dt-geracao
             AND mla-usuar-aprov-altern.validade-fim >= {&TABLENAME}.dt-geracao:
            CREATE tt-usuar-email.
            ASSIGN tt-usuar-email.cod-usuar = mla-usuar-aprov-altern.cod-usuar-altern.
        end.
    END.

    FOR EACH tt-usuar-email:
        ASSIGN c-usuario-destinatario = tt-usuar-email.cod-usuar.

        FIND FIRST mla-usuar-aprov NO-LOCK
             WHERE mla-usuar-aprov.cod-usuar = c-usuario-destinatario NO-ERROR.
        IF AVAIL mla-usuar-aprov THEN
            ASSIGN l-recebe-email       = mla-usuar-aprov.recebe-email
                   c-email-destinatario = mla-usuar-aprov.e-mail
                   l-email-html-usuar   = mla-usuar-aprov.log-html.

        IF  l-email        AND
            l-envia-email  AND
            l-recebe-email AND
            c-email-remetente    <> "" AND
            c-email-destinatario <> "" THEN DO:
            IF  {&tablename}.ind-situacao = 1 THEN DO:
    
                /**  Pendente de Aprovaá∆o
                **/
                assign c-ass-e-mail = SUBSTITUTE(c-msgs-26593,
                                 c-des-tip-doc,
                                 {&TABLENAME}.chave-doc).

                IF  l-email-html-doc AND
                    l-email-html-usuar THEN DO:
    
                    /**  HTML
                    **/
                    ASSIGN c-formato-email = "HTML".

                    IF {&TABLENAME}.cod-tip-doc < 10 then 
                        RUN VALUE("laphtml/mlahtml00" + STRING({&TABLENAME}.cod-tip-doc) + "e.p") 
                                                       (input  {&TABLENAME}.cod-tip-doc,
                                                        input  c-usuario-destinatario,
                                                        input  table tt-mla-chave,
                                                        output TABLE tt-mensagem).
                    ELSE 
                        RUN VALUE("laphtml/mlahtml0" + STRING({&TABLENAME}.cod-tip-doc) + "e.p") 
                                                      (input  {&TABLENAME}.cod-tip-doc,
                                                       input  c-usuario-destinatario,
                                                       input  table tt-mla-chave,
                                                       output TABLE tt-mensagem).

                    /* Verifica o tamanho do e-mail, caso exceda 32k, o html deve ser enviado como anexo */
                    RUN verificaTamanhoEmail.

                    IF l-anexar-conteudo THEN DO:
                        ASSIGN c-arq-email = SESSION:TEMP-DIRECTORY + "/" + REPLACE({&TABLENAME}.cod-usuar," ","_") + "_" + REPLACE(TRIM({&TABLENAME}.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm".
                        OUTPUT TO VALUE(c-arq-email) CONVERT TARGET "UTF-8":U.
                        FOR EACH tt-mensagem:
                                PUT UNFORMATTED tt-mensagem.mensagem SKIP.
                        END.
                        OUTPUT CLOSE.
                    END.
    
                END.
                ELSE DO:

                    FIND FIRST moeda
                         WHERE moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo NO-LOCK NO-ERROR.

                    /**  Texto
                    **/
                    ASSIGN c-formato-email = "".
    
                    ASSIGN c-men-e-mail = SUBSTITUTE(c-help-26593,
                                                     c-des-tip-doc,
                                                     {&TABLENAME}.chave-doc,
                                                     moeda.sigla + " " + trim(string({&TABLENAME}.valor-doc,">>>,>>>,>>>,>>>,>>9.99")),
                                                     c-usuario-destinatario) + CHR(10).
    
    
                    IF  c-compl-email <> "" then 
                        ASSIGN c-men-e-mail = c-men-e-mail + chr(10) + 
                                              trim(c-compl-email).
    
                END.
    
            END.
            ELSE DO:
    
                RUN setEpcEmail IN THIS-PROCEDURE (INPUT 2).
                IF  RETURN-VALUE = "NOK":U THEN
                    RETURN "NOK":U.
    
                ASSIGN c-ass-e-mail = SUBSTITUTE(c-msgs-26652,
                                                 c-des-tip-doc,
                                                 {&TABLENAME}.chave-doc).
    
                FIND FIRST mla-usuar-aprov NO-LOCK
                     WHERE mla-usuar-aprov.cod-usuar = c-cod-aprovador NO-ERROR.
                ASSIGN c-nome-usuar = IF AVAIL mla-usuar-aprov THEN mla-usuar-aprov.nome-usuar ELSE "".
                FIND FIRST moeda
                     WHERE moeda.mo-codigo = {&TABLENAME}.mo-codigo NO-LOCK NO-ERROR.

                /**  Aprovado ou Rejeitado
                **/
                IF  {&TABLENAME}.aprov-auto THEN DO:
                    /**  Aprovaá∆o Autom†tica
                    **/
                    ASSIGN c-men-e-mail = SUBSTITUTE(c-help-26652,
                                                     c-des-tip-doc,
                                                     {&TABLENAME}.chave-doc,
                                                     moeda.sigla + " " + trim(string({&TABLENAME}.valor-doc,">>>,>>>,>>>,>>>,>>9.99")),
                                                     c-cod-aprovador + " - " + c-nome-usuar + " - Aprovaá∆o Autom†tica") + CHR(10).
                END.
                ELSE DO:
                    /**  Aprovaá∆o Manual
                    **/
                    assign c-men-e-mail = SUBSTITUTE(c-help-26652,
                                                     mla-tipo-doc-aprov.des-tip-doc,
                                                     c-chave,
                                                     moeda.sigla + " " + trim(string({&TABLENAME}.valor-doc,">>>,>>>,>>>,>>>,>>9.99")),
                                                     c-cod-aprovador + " - " + c-nome-usuar) + CHR(10). 
                END.
    
                IF  {&TABLENAME}.cod-tip-doc = 2 OR  
                    {&TABLENAME}.cod-tip-doc = 4 THEN DO:
                    FOR EACH it-requisicao WHERE 
                        it-requisicao.nr-requisicao = int(substring({&TABLENAME}.chave-doc,1,6)) NO-LOCK:
                        ASSIGN c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requisitada,'>>>>>,>>>,>>9.9999') + CHR(10).
                    END.
                END.
                IF  {&TABLENAME}.cod-tip-doc = 1 OR  
                    {&TABLENAME}.cod-tip-doc = 3 THEN DO:
                    FOR EACH it-requisicao WHERE 
                        it-requisicao.nr-requisicao = INT(SUBSTRING({&TABLENAME}.chave-doc,1,6)) AND   
                        it-requisicao.sequencia     = INT(SUBSTRING({&TABLENAME}.chave-doc,7,3)) AND   
                        it-requisicao.it-codigo     = SUBSTRING({&tablename}.chave-doc,10,16) NO-LOCK:
                        ASSIGN c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requisitada,'>>>>>,>>>,>>9.9999') + CHR(10).
                    END.
                END.
    
                IF  c-compl-email <> "" then 
                    ASSIGN c-men-e-mail = c-men-e-mail + chr(10) + 
                                          trim(c-compl-email).
            END.

            /**  Envia E-mail
            **/
            IF  l-email-html-doc AND
                l-email-html-usuar AND
                {&tablename}.ind-situacao = 1 THEN DO:
    
                /**  HTML
                **/
                EMPTY TEMP-TABLE tt-envio2.

                CREATE tt-envio2.
                ASSIGN tt-envio2.versao-integracao = 1
                       tt-envio2.exchange    = l-log-exchange
                       tt-envio2.destino     = c-email-destinatario
                       tt-envio2.assunto     = c-ass-e-mail
                       tt-envio2.importancia = 2
                       tt-envio2.log-enviada = no
                       tt-envio2.log-lida    = no
                       tt-envio2.acomp       = no
                       tt-envio2.formato     = c-formato-email.
        
                /* Verifica o tamanho do e-mail, caso exceda 32k, o html deve ser enviado como anexo */
                RUN verificaTamanhoEmail.

                       
                {utp/ut-liter.i Foi_gerada_uma_pend?ncia_de_aprova?ío!}
                ASSIGN c-mensagem = RETURN-VALUE.
                
                {utp/ut-liter.i "Favor_verificar_o_arquivo_atachado."}
            
                if  l-anexar-conteudo then
                    assign tt-envio2.mensagem    = c-mensagem + CHR(10) + RETURN-VALUE
                           tt-envio2.arq-anexo   = IF c-anexo > "" THEN c-arq-email + "," + c-anexo
                                                   ELSE c-arq-email.
                ELSE 
                    ASSIGN tt-envio2.mensagem    = c-men-e-mail
                           tt-envio2.arq-anexo   = c-anexo.
        
                ASSIGN tt-envio2.remetente = c-email-remetente.
    
                IF  NOT l-log-exchange THEN DO:
                    ASSIGN tt-envio2.servidor = c-servidor-email
                           tt-envio2.porta    = i-porta-email.
                END.
    
                /**  Html para Palm 
                **/
                IF  {&tablename}.ind-situacao = 1 THEN DO:
                    RUN lap/mlaapi012.p (INPUT {&TABLENAME}.ep-codigo,   
                                          INPUT {&TABLENAME}.cod-estabel, 
                                          INPUT {&TABLENAME}.cod-tip-doc,
                                          INPUT c-usuario-destinatario,
                                          INPUT TABLE tt-mla-chave,
                                          OUTPUT c-arquivo-anexo). 
                    IF  RETURN-VALUE = "OK" THEN DO:
                        IF  tt-envio2.arq-anexo = "" THEN 
                            ASSIGN tt-envio2.arq-anexo = c-arquivo-anexo.
                        ELSE  
                            ASSIGN tt-envio2.arq-anexo = tt-envio2.arq-anexo + ","
                                                       + c-arquivo-anexo.
                    END. 
                END.
                /**/

                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.exchange : " + STRING(tt-envio2.exchange) ) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.servidor : " + STRING(tt-envio2.servidor) ) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.porta    : " + STRING(tt-envio2.porta)    ) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.remetente: " + STRING(tt-envio2.remetente)) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.destino  : " + STRING(tt-envio2.destino)  ) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.assunto  : " + STRING(tt-envio2.assunto)  ) NO-ERROR.

                RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    
                EMPTY TEMP-TABLE tt-erros.
    
                RUN pi-gerar-dados-extrato (INPUT "boin767b: Envia E-mail HTML padrao h-utapi019  ").

                IF  l-anexar-conteudo THEN 
                    RUN pi-execute  IN h-utapi019 (INPUT  TABLE tt-envio2,                   
                                                   OUTPUT TABLE tt-erros).                                                                           
                else
                    RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,                   
                                                   INPUT  TABLE tt-mensagem,
                                                   OUTPUT TABLE tt-erros).
    
                FOR EACH tt-erros:
                    LOG-MANAGER:WRITE-MESSAGE (">>> Erro: " + STRING(tt-erros.cod-erro) + " - " + tt-erros.desc-erro) NO-ERROR.
                END.

                DELETE PROCEDURE h-utapi019.
    
                IF  l-anexar-conteudo THEN 
                    OS-DELETE VALUE(c-arq-email).
    
                OS-DELETE VALUE(c-arquivo-anexo).
    
            END.
            ELSE DO:

                /**  Texto
                **/
                EMPTY TEMP-TABLE tt-envio.
                EMPTY TEMP-TABLE tt-erros.

                CREATE tt-envio.
                ASSIGN tt-envio.versao-integracao = 1
                       tt-envio.exchange    = l-log-exchange
                       tt-envio.destino     = c-email-destinatario
                       tt-envio.assunto     = c-ass-e-mail
                       tt-envio.importancia = 2
                       tt-envio.log-enviada = no
                       tt-envio.log-lida    = no
                       tt-envio.acomp       = no
                       tt-envio.mensagem    = c-men-e-mail
                       tt-envio.arq-anexo   = c-anexo
                       tt-envio.remetente   = c-email-remetente.
    
                IF  NOT l-log-exchange THEN DO:
                    ASSIGN tt-envio.servidor = c-servidor-email
                           tt-envio.porta    = i-porta-email.
                END.

                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.exchange : " + STRING(tt-envio.exchange) ) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.servidor : " + STRING(tt-envio.servidor) ) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.porta    : " + STRING(tt-envio.porta)    ) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.remetente: " + STRING(tt-envio.remetente)) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.destino  : " + STRING(tt-envio.destino)  ) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio.assunto  : " + STRING(tt-envio.assunto)  ) NO-ERROR.
                
                RUN pi-gerar-dados-extrato (INPUT "boin767b: Envia E-mail TXT padrao h-utapi019  ").

                run utp/utapi009.p (input  table tt-envio,
                                    output table tt-erros).
    
                FOR EACH tt-erros:
                    LOG-MANAGER:WRITE-MESSAGE (">>> Erro: " + STRING(tt-erros.cod-erro) + " - " + tt-erros.desc-erro) NO-ERROR.
                END.
            END.
        END.
    END. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEnviaEmailAltern DBOProgram 
PROCEDURE setEnviaEmailAltern :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FIND FIRST mla-param-aprov NO-LOCK
         WHERE mla-param-aprov.ep-codigo   = i-ep-codigo 
           AND mla-param-aprov.cod-estabel = c-cod-estabel NO-ERROR.
    IF AVAIL mla-param-aprov THEN
        ASSIGN l-log-email-altern = mla-param-aprov.log-email-altern.
    ELSE 
        ASSIGN l-log-email-altern = NO.

    IF  NOT l-aprovado AND 
        l-log-email-altern THEN DO:
        /**  Geraá∆o 
        **/
/*         RUN lap/aed0130a.p (1,                         */
/*                             c-cod-aprovador,           */
/*                             ROWID({&TABLENAME}),       */
/*                             INPUT TABLE tt-mla-chave). */
    END.            
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEpcEmail DBOProgram 
PROCEDURE setEpcEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-ponto AS INTEGER NO-UNDO.
                  
    CASE p-ponto:
        WHEN 1 THEN DO:

            /*************************************************************************/
            /*** IN÷CIO CHAMADA EPC - Cliente: RIO-POLIMERO / FO: 1293.168         ***/
            /*************************************************************************/
            /*** Prop¢sito: Interferir no envio do e-mail de pendància, permitindo ***/
            /***            ou n∆o o envio do e-mail ao usu†rio aprovador.         ***/
            /*** Parametros:                                                       ***/
            /***    -> ROWID-mla-DOC-PEND-APROV: rowid da tabela mla-DOC-PEND-APROV***/
            /***                                 para que a partir deste seja      ***/
            /***                                 poss°vel identificar o documento  ***/
            /***                                 e permitir ou n∆o o envio do      ***/
            /***                                 e-mail de pendància.              ***/
            /*************************************************************************/

            if  c-nom-prog-upc-mg97 <> "" then do:

                for each tt-epc
                    where tt-epc.cod-event = "SEND-EMAIL".
                    delete tt-epc.
                end.

                /*rowid mla-doc-pend-aprov */
                {include/i-epc200.i2 &CodEvent='"SEND-EMAIL"'
                                     &CodParameter='"ROWID-mla-DOC-PEND-APROV"'
                                     &ValueParameter="string(rowid({&TABLENAME}))"}

                {include/i-epc201.i "SEND-EMAIL"}

                if  return-value = "NOK" then
                    return "NOK":U.

            end.

            /*************************************************************************/
            /*** FIM CHAMADA EPC - Cliente: RIO-POLIMERO / FO: 1293.168            ***/
            /*************************************************************************/

        END.
        WHEN 2 THEN DO:

            /*************************************************************************/
            /*** IN÷CIO CHAMADA EPC - Cliente: RIO-POLIMERO / FO: 1293.168         ***/
            /*************************************************************************/
            /*** Prop¢sito: Interferir no envio do e-mail de pendància, permitindo ***/
            /***            ou n∆o o envio do e-mail ao usu†rio aprovador.         ***/
            /*** Parametros:                                                       ***/
            /***    -> ROWID-mla-DOC-PEND-APROV: rowid da tabela mla-DOC-PEND-APROV***/
            /***                                 para que a partir deste seja      ***/
            /***                                 poss°vel identificar o documento  ***/
            /***                                 e permitir ou n∆o o envio do      ***/
            /***                                 e-mail de pendància.              ***/
            /*************************************************************************/

            if  c-nom-prog-upc-mg97 <> "" then do:

                for each tt-epc
                    where tt-epc.cod-event = "SEND-EMAIL-APROV-AUTO".
                    delete tt-epc.
                end.

                /*rowid mla-doc-pend-aprov */
                {include/i-epc200.i2 &CodEvent='"SEND-EMAIL-APROV-AUTO"'
                                     &CodParameter='"ROWID-mla-DOC-PEND-APROV"'
                                     &ValueParameter="string(rowid({&TABLENAME}))"}

                {include/i-epc201.i "SEND-EMAIL-APROV-AUTO"}

                if  return-value = "NOK" then
                    return "NOK":U.

            end.

            /*************************************************************************/
            /*** FIM CHAMADA EPC - Cliente: RIO-POLIMERO / FO: 1293.168            ***/
            /*************************************************************************/

        END.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEpcEmerg DBOProgram 
PROCEDURE setEpcEmerg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-ponto AS INTEGER NO-UNDO.

    CASE p-ponto:
        WHEN 1 THEN DO:
            /*EPC Cliente: FUJITSU F.O.==> 1298.331*/
            if c-nom-prog-upc-mg97  <> "" or
               c-nom-prog-appc-mg97 <> "" or
               c-nom-prog-dpc-mg97  <> "" then do:

               EMPTY TEMP-TABLE tt-epc.

               {include/i-epc200.i2 &CodEvent='"OverrideQuotation"':U
                                    &CodParameter='"rowid-cotacao-item"':U
                                    &ValueParameter="string(rowid(cotacao-item))"}

               {include/i-epc201.i "OverrideQuotation"}

               /* Sobrescreve a vari†vel DE-COTACAO para que o valor do documento n∆o seja convertido */
               find first tt-epc 
                    where tt-epc.cod-event     = "OverrideQuotation":U
                      and tt-epc.cod-parameter = "ReturnIndex":U no-error.
               if avail tt-epc then
                  assign de-cotacao = dec(tt-epc.val-parameter). /* deve retornar 1 (um) para n∆o converter */

               /* retorna a moeda do documento */
               find first tt-epc 
                    where tt-epc.cod-event     = "OverrideQuotation":U
                      and tt-epc.cod-parameter = "ReturnCoin":U no-error.
               if avail tt-epc then
                  assign i-moeda-doc = int(tt-epc.val-parameter). /* grava moeda original do documento */

            end.
            /*FIM EPC */

        END.
        WHEN 2 THEN DO:
            /**  EPC para tratar lotaá∆o do documento
            **/

            IF c-nom-prog-upc-mg97 <> "" THEN DO: 

                EMPTY TEMP-TABLE tt-epc.

                create tt-epc.
                assign tt-epc.cod-event     = "BeforeGeraPendencia"
                       tt-epc.cod-parameter = "pedido-compr.num-pedido"
                       tt-epc.val-parameter = string(pedido-compr.num-pedido). 

                {include/i-epc201.i "BeforeGeraPendencia"}
                /**  Fim EPC  **/

                FIND FIRST tt-epc 
                     WHERE tt-epc.cod-event     = "BeforeGeraPendencia"
                       AND tt-epc.cod-parameter = "lotacao"
                       AND tt-epc.val-parameter <> "" NO-ERROR.
                IF AVAIL tt-epc THEN
                    ASSIGN c-lotacao = tt-epc.val-parameter.
            END.

        END.
        WHEN 3 THEN DO:
            /*EPC Cliente: FUJITSU F.O.==> 1298.331*/
            if c-nom-prog-upc-mg97  <> "" or 
               c-nom-prog-appc-mg97 <> "" or
               c-nom-prog-dpc-mg97  <> "" then do:

               EMPTY TEMP-TABLE tt-epc.

               {include/i-epc200.i2 &CodEvent='"OverrideQuotation"':U
                                    &CodParameter='"rowid-cotacao-item"':U
                                    &ValueParameter="string(rowid(cotacao-item))"}

               {include/i-epc201.i "OverrideQuotation"}

               /* Sobrescreve a vari†vel DE-COTACAO para que o valor do documento n∆o seja convertido */
               find first tt-epc 
                    where tt-epc.cod-event     = "OverrideQuotation":U
                      and tt-epc.cod-parameter = "ReturnIndex":U no-error.
               if avail tt-epc then
                  assign de-cotacao = dec(tt-epc.val-parameter). /* deve retornar 1 (um) para n∆o converter */

               /* retorna a moeda do documento */
               find first tt-epc 
                    where tt-epc.cod-event     = "OverrideQuotation":U
                      and tt-epc.cod-parameter = "ReturnCoin":U no-error.
               if avail tt-epc then
                  assign i-moeda-doc = int(tt-epc.val-parameter). /* grava moeda original do documento */

            end.
            /*FIM EPC */

        END.
        WHEN 4 THEN DO:
            IF c-nom-prog-upc-mg97 <> "" THEN DO:

                EMPTY TEMP-TABLE tt-epc.

                create tt-epc.
                assign tt-epc.cod-event     = "Lotacao-Doc-Item-19"
                       tt-epc.cod-parameter = "Rowid-Ordem-Compra"
                       tt-epc.val-parameter = string(ROWID(ordem-compra)). 


                {include/i-epc201.i "mla-Lotacao-Doc-Item"}
            END.

        END.
    END CASE.
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEpcFaixa DBOProgram 
PROCEDURE setEpcFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-ponto AS INTEGER NO-UNDO.

    CASE p-ponto:
        WHEN 1 THEN DO:

            /* Inicio - Chamada EPC - MERIAL repasse AED1 */
            if c-nom-prog-upc-mg97  <> "" or 
               c-nom-prog-appc-mg97 <> "" or 
               c-nom-prog-dpc-mg97  <> "" then do:

               EMPTY TEMP-TABLE tt-epc.

               create tt-epc.
               assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-FAIXA"
                      tt-epc.cod-parameter = "cod-usuar-doc"
                      tt-epc.val-parameter = c-cod-usuar-doc. 

               create tt-epc.
               assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-FAIXA"
                      tt-epc.cod-parameter = "r-mla-hierarquia-faixa"
                      tt-epc.val-parameter =  string(r-rowid). 

               {include/i-epc201.i "BEFORE-CREATE-mla-DOC-PEND-APROV-FAIXA"}

               if  return-value = "OK" then do:
                   find first tt-epc 
                        where tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-FAIXA"
                          and tt-epc.cod-parameter = "r-mla-hierarquia-faixa"
                          and tt-epc.val-parameter <> "" no-error.

                   if available tt-epc then DO:
                       IF  NOT VALID-HANDLE(hmla-hierarquia-faixa) THEN DO:
                           RUN inbo/boin793.p PERSISTENT SET hmla-hierarquia-faixa.
                           run openQueryStatic in hmla-hierarquia-faixa (input "Main").
                       END.

                       RUN goToKeyRowid IN hmla-hierarquia-faixa (INPUT to-rowid(tt-epc.val-parameter)).

                       IF  RETURN-VALUE = "OK" THEN
                           RUN getCharField IN hmla-hierarquia-faixa (INPUT "cod-usuar",
                                                                      OUTPUT c-cod-aprovador).
                       IF VALID-HANDLE(hmla-hierarquia-faixa) THEN
                           DELETE PROCEDURE hmla-hierarquia-faixa.
                   END.
               end.
            end.
            /* Fim - Chamada EPC - MERIAL repasse AED1 */

        END.
        WHEN 2 THEN DO:

            /* Inicio - Chamada EPC - MERIAL repasse AED1 */
            FIND FIRST tt{&TABLENAME} NO-ERROR.
            IF  AVAILABLE tt{&TABLENAME} THEN DO:
                create tt-epc.
                assign tt-epc.cod-event     = "AFTER-CREATE-mla-DOC-PEND-APROV-FAIXA"
                       tt-epc.cod-parameter = "r-mla-doc-pend-aprov"
                       tt-epc.val-parameter = STRING(tt{&TABLENAME}.rROWID). 

                {include/i-epc201.i "AFTER-CREATE-mla-DOC-PEND-APROV-FAIXA"}

            END.
           /* Fim - Chamada EPC - MERIAL repasse AED1 */

        END.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEpcLista DBOProgram 
PROCEDURE setEpcLista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-ponto AS INTEGER NO-UNDO.

    CASE p-ponto:
        WHEN 1 THEN DO:

            /* Inicio - Chamada EPC - MERIAL repasse AED1 */
            if c-nom-prog-upc-mg97  <> "" or 
               c-nom-prog-appc-mg97 <> "" or 
               c-nom-prog-dpc-mg97  <> "" then do:

               EMPTY TEMP-TABLE tt-epc.

               create tt-epc.
               assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF"
                      tt-epc.cod-parameter = "lotacao"
                      tt-epc.val-parameter = c-cod-lotacao-doc. 

               create tt-epc.
               assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF"
                      tt-epc.cod-parameter = "valor-doc"
                      tt-epc.val-parameter = string(de-valor-aprov). 

               create tt-epc.
               assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF"
                      tt-epc.cod-parameter = "cod-usuar-doc"
                      tt-epc.val-parameter = c-cod-usuar-doc. 

               create tt-epc.
               assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF"
                      tt-epc.cod-parameter = "cod-tip-doc"
                      tt-epc.val-parameter = string(i-cod-tip-doc).

               create tt-epc.
               assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF"
                      tt-epc.cod-parameter = "codigo-referencia"
                      tt-epc.val-parameter = c-cod-referencia.

               {include/i-epc201.i "BEFORE-CREATE-mla-DOC-PEND-APROV-REF"}
               if return-value <> "NOK" then
                  assign l-desvia = no.
               else
                  assign l-desvia = yes.

            end.
            /* Fim - Chamada EPC - MERIAL repasse AED1 */

        END.
        WHEN 2 THEN DO:

            /*************************************************************************/
            /*** IN÷CIO CHAMADA EPC - Cliente: XXX / FO: 9999.9999                 ***/
            /*************************************************************************/
            /*** Prop¢sito: Permitir que na aprovaá∆o por lista seja gerada apenas ***/
            /***            uma pendància para um aprovador da lista de acordo com ***/
            /***            o limite de aprovaá∆o                                  ***/
            /*** Parametros:                                                       ***/
            /***    -> HANDLE-TT-LISTA: disponibiliza o handle da tt-lista para    ***/
            /***                        que os aprovadores da lista sejam mani-    ***/
            /***                        pulados, ou seja, permite que os dados     ***/
            /***                        da tt-lista sejam alterados ou eliminados  ***/
            /***                        e devolvidos ao programa para geraá∆o das  ***/
            /***                        pendàncias de aprovaá∆o.                   ***/
            /***    -> VALOR-DOCUMENTO: disponibiliza o valor do documento para    ***/
            /***                        que seja verificado se os aprovadores da   ***/
            /***                        lista possuem limite para aprovaá∆o,       ***/
            /***                        gerando apenas uma pendància para o        ***/
            /***                        aprovador que possuir limite para aprovaá∆o***/
            /*************************************************************************/

            if  c-nom-prog-upc-mg97 <> "" then do:

                for each tt-epc
                    where tt-epc.cod-event = "LISTA-APROVADORES":
                    delete tt-epc.
                end.

                /* handle da temp-table de aprovadores da lista */
                {include/i-epc200.i2 &CodEvent='"LISTA-APROVADORES"'
                                     &CodParameter='"HANDLE-TT-LISTA"'
                                     &ValueParameter="string(temp-table tt-lista:handle)"}

                /* valor do pendància */
                {include/i-epc200.i2 &CodEvent='"LISTA-APROVADORES"'
                                     &CodParameter='"VALOR-DOCUMENTO"'
                                     &ValueParameter="string(de-valor-aprov)"}

                {include/i-epc201.i "LISTA-APROVADORES"}

                /* caso a EPC retorne erro n∆o deve proceder com a geraá∆o das pendàncias */
                if  return-value = "NOK" then
                    return "NOK":U.

            end.

            /*************************************************************************/
            /*** FIM CHAMADA EPC - Cliente: XXX / FO: 9999.9999                    ***/
            /*************************************************************************/

        END.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEpcLotacao DBOProgram 
PROCEDURE setEpcLotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Inicio - Chamada EPC - MERIAL repasse AED1 */
    if c-nom-prog-upc-mg97  <> "" or 
       c-nom-prog-appc-mg97 <> "" or 
       c-nom-prog-dpc-mg97  <> "" then do:
       
       EMPTY TEMP-TABLE tt-epc.

       create tt-epc.
       assign tt-epc.cod-event     = "afterLotacao":U
              tt-epc.cod-parameter = "tipo-documento":U
              tt-epc.val-parameter = STRING(i-cod-tip-doc).
    
       create tt-epc.
       assign tt-epc.cod-event     = "afterLotacao":U
              tt-epc.cod-parameter = "chave":U
              tt-epc.val-parameter = c-chave.
    
       {include/i-epc201.i "afterLotacao"}
    
       find first tt-epc no-lock  
            where tt-epc.cod-event = "afterLotacao" no-error.

       if avail  tt-epc and  
          string(tt-epc.cod-parameter,"x(20)") = "lotacao-escolhida":U then
          assign c-lotacao = tt-epc.val-parameter.
    
       EMPTY TEMP-TABLE tt-epc.
    end.
    /* FIM - Chamada EPC - MERIAL repasse AED1 */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEpcPedido DBOProgram 
PROCEDURE setEpcPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-ponto AS INTEGER NO-UNDO.

    CASE p-ponto:
        WHEN 1 THEN DO:
            /**  EPC para tratar lotaá∆o do documento
            **/

            IF c-nom-prog-upc-mg97 <> "" THEN DO:

                EMPTY TEMP-TABLE tt-epc.

                create tt-epc.
                assign tt-epc.cod-event     = "Lotacao-Doc-Item-06"
                       tt-epc.cod-parameter = "Rowid-Ordem-Compra"
                       tt-epc.val-parameter = string(ROWID(ordem-compra)). 

                {include/i-epc201.i "mla-Lotacao-Doc-Item"}

                if  return-value = 'NOK' then do:

                end.
            END.

            /**  Fim EPC  **/

        END.
        WHEN 2 THEN DO:
            /*EPC Cliente: FUJITSU F.O.==> 1298.331*/
            if c-nom-prog-upc-mg97  <> "" or 
               c-nom-prog-appc-mg97 <> "" or
               c-nom-prog-dpc-mg97  <> "" then do:
              
               EMPTY TEMP-TABLE tt-epc.

               {include/i-epc200.i2 &CodEvent='"OverrideQuotation"':U
                                    &CodParameter='"rowid-cotacao-item"':U
                                    &ValueParameter="string(rowid(cotacao-item))"}

               {include/i-epc201.i "OverrideQuotation"}

               /* Sobrescreve a vari†vel DE-COTACAO para que o valor do documento n∆o seja convertido */
               find first tt-epc 
                    where tt-epc.cod-event     = "OverrideQuotation":U
                      and tt-epc.cod-parameter = "ReturnIndex":U no-error.
               if  avail tt-epc then
                   assign de-cotacao = dec(tt-epc.val-parameter). /* deve retornar 1 (um) para n∆o converter */

               /* retorna a moeda do documento */
               find first tt-epc 
                    where tt-epc.cod-event     = "OverrideQuotation":U
                      and tt-epc.cod-parameter = "ReturnCoin":U no-error.
               if  avail tt-epc then
                   assign i-moeda-doc = int(tt-epc.val-parameter). /* grava moeda original do documento */
            end.
            /*FIM EPC */

        END.
        WHEN 3 THEN DO:
            /*EPC Cliente: FUJITSU F.O.==> 1298.331*/
            if c-nom-prog-upc-mg97  <> "" or 
               c-nom-prog-appc-mg97 <> "" or 
               c-nom-prog-dpc-mg97  <> "" then do:

               EMPTY TEMP-TABLE tt-epc.

               {include/i-epc200.i2 &CodEvent='"OverrideQuotation"':U
                                    &CodParameter='"rowid-cotacao-item"':U
                                    &ValueParameter="string(rowid(cotacao-item))"}

               {include/i-epc201.i "OverrideQuotation"}

               /* Sobrescreve a vari†vel DE-COTACAO para que o valor do documento n∆o seja convertido */
               find first tt-epc 
                    where tt-epc.cod-event     = "OverrideQuotation":U
                      and tt-epc.cod-parameter = "ReturnIndex":U no-error.
               if  avail tt-epc then
                   assign de-cotacao = dec(tt-epc.val-parameter). /* deve retornar 1 (um) para n∆o converter */

               /* retorna a moeda do documento */
               find first tt-epc 
                    where tt-epc.cod-event     = "OverrideQuotation":U
                      and tt-epc.cod-parameter = "ReturnCoin":U no-error.
               if avail tt-epc then
                  assign i-moeda-doc = int(tt-epc.val-parameter). /* grava moeda original do documento */

            end.
            /*FIM EPC */

        END.
        WHEN 4 THEN DO:
            /**  EPC para tratar lotaá∆o do documento
            **/
            IF c-nom-prog-upc-mg97 <> "" THEN DO:

                EMPTY TEMP-TABLE tt-epc.

                create tt-epc.
                assign tt-epc.cod-event     = "BeforeGeraPendencia"
                       tt-epc.cod-parameter = "pedido-compr.num-pedido"
                       tt-epc.val-parameter = string(pedido-compr.num-pedido). 

                {include/i-epc201.i "BeforeGeraPendencia"}
                /**  Fim EPC  **/

                FIND FIRST tt-epc 
                     WHERE tt-epc.cod-event     = "BeforeGeraPendencia"
                       AND tt-epc.cod-parameter = "lotacao"
                       AND tt-epc.val-parameter <> "" NO-ERROR.
                IF AVAIL tt-epc THEN
                    ASSIGN gc-lotacao-doc = tt-epc.val-parameter.
            END.

        END.
    END CASE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEpcPend DBOProgram 
PROCEDURE setEpcPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*************************************************************************/
    /*** IN÷CIO CHAMADA EPC - Cliente: BANCARIA / FO: 1220.647             ***/
    /*************************************************************************/
    /*** Prop¢sito: Permitir que uma pendància tenha seus dados alterados  ***/
    /***            antes do envio do e-mail.                              ***/
    /*************************************************************************/
    
    if  c-nom-prog-upc-mg97 <> "" then do:
    
        for each tt-epc
            where tt-epc.cod-event = "AFTER-CREATE-{&TABLENAME}".
            delete tt-epc.
        end.
    
        /*rowid da tabela {&TABLENAME}*/
        {include/i-epc200.i2 &CodEvent='"AFTER-CREATE-{&TABLENAME}"'
                             &CodParameter='"TABLE-ROWID"'
                             &ValueParameter="string(rowid({&TABLENAME}))"}
                             
        {include/i-epc201.i "AFTER-CREATE-{&TABLENAME}"}
    
        find first tt-epc
            where tt-epc.cod-event     = "AFTER-CREATE-{&TABLENAME}"
            and   tt-epc.cod-parameter = "NEW-APROVADOR"
            no-error.
        if  avail tt-epc
        and tt-epc.val-parameter <> "" then
            assign c-cod-aprovador = tt-epc.val-parameter.
    
    end.
    
    /*************************************************************************/
    /*** FIM CHAMADA EPC - Cliente: BANCARIA / FO: 1220.647                ***/
    /*************************************************************************/
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEpcRequis DBOProgram 
PROCEDURE setEpcRequis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /**  EPC para tratar lotaá∆o do documento
    **/
    {include/i-epc201.i "mlaapi010a"}

    EMPTY TEMP-TABLE tt-epc.
    create tt-epc.
    assign tt-epc.cod-event     = "Lotacao-Doc-Item-03"
           tt-epc.cod-parameter = "Rowid-It-Requisicao"
           tt-epc.val-parameter = string(ROWID(it-requisicao)). 

    {include/i-epc201.i "mla-Lotacao-Doc-Item"}
    /**  Fim EPC  **/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEpcSolic DBOProgram 
PROCEDURE setEpcSolic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /**  EPC para tratar lotaá∆o do documento
    **/
    {include/i-epc201.i "mlaapi010a"}

    EMPTY TEMP-TABLE tt-epc.
    create tt-epc.
    assign tt-epc.cod-event     = "Lotacao-Doc-Item-01"
           tt-epc.cod-parameter = "Rowid-It-Requisicao"
           tt-epc.val-parameter = string(ROWID(it-requisicao)). 

    {include/i-epc201.i "mla-Lotacao-Doc-Item"}
    /**  Fim EPC  **/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setExecutaProg DBOProgram 
PROCEDURE setExecutaProg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-ep-codigo   LIKE empresa.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-tip-doc AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-tipo-trans  AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-rowid-doc   AS ROWID   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-aprov   AS CHAR    NO-UNDO.

    EMPTY TEMP-TABLE tt-log-erros-atualiz.
    FIND FIRST mla-tipo-doc-aprov NO-LOCK
         WHERE mla-tipo-doc-aprov.ep-codigo   = p-ep-codigo              /*Empresa*/        
           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel            /*Estabelecimento*/
           AND mla-tipo-doc-aprov.cod-tip-doc = p-cod-tip-doc NO-ERROR.  /*Documento*/      


    CASE  p-tipo-trans:
        WHEN 2 THEN DO:
            /**  Rejeiá∆o
            **/
            IF  AVAIL mla-tipo-doc-aprov AND
                mla-tipo-doc-aprov.prog-rejeita <> "" THEN DO:
                ASSIGN c-prog-executa = mla-tipo-doc-aprov.prog-rejeita.

                IF  mla-doc-pend-aprov.cod-tip-doc = 32 /* Originaá∆o - Adiantamento Valor    */ OR
                    mla-doc-pend-aprov.cod-tip-doc = 33 /* Originaá∆o - Fechamento Financeiro */ THEN DO:
                    RUN VALUE(c-prog-executa) (INPUT  p-rowid-doc,
                                               INPUT  p-cod-aprov,
                                               INPUT  NO,
                                               OUTPUT TABLE RowErrors APPEND).
                END.
                ELSE DO:
                    RUN VALUE(c-prog-executa) (INPUT p-rowid-doc,
                                               INPUT p-cod-aprov,
                                               NO,
                                               INPUT-OUTPUT TABLE tt-log-erros-atualiz).  /*rodinei*/
                END.

                IF  RETURN-VALUE = "NOK":U THEN DO:
                    RETURN "NOK":U.
                END.
            END.
        END.
        OTHERWISE DO:
            /**  Aprovaá∆o
            **/
            IF  AVAIL mla-tipo-doc-aprov AND
                mla-tipo-doc-aprov.prog-aprova <> "" THEN DO:
                ASSIGN c-prog-executa = mla-tipo-doc-aprov.prog-aprova.

                IF mla-doc-pend-aprov.cod-tip-doc = 24
                    OR mla-doc-pend-aprov.cod-tip-doc = 25
                    OR mla-doc-pend-aprov.cod-tip-doc = 26
                    OR mla-doc-pend-aprov.cod-tip-doc = 28 THEN DO: /*Tratamento para os Documentos de Finanáas (temp-table de erros)*/
                        
                        run value(c-prog-executa) (gr-mla-rowid-pend,
                                                   gc-mla-cod-usuar,
                                                   not gl-mla-gera-proxima,
                                                   INPUT-OUTPUT TABLE tt-log-erros-atualiz).
                        FOR EACH tt-log-erros-atualiz:
                            {method/svc/errors/inserr.i &ErrorNumber="tt-log-erros-atualiz.ttv-num-mensagem"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U
                                                        &ErrorParameters="''"}
                            ASSIGN RowErrors.ErrorDescription = tt-log-erros-atualiz.ttv-des-msg-erro
                                   RowErrors.ErrorHelp        = tt-log-erros-atualiz.ttv-des-msg-ajuda.                                                
                        END.
        
                        find first RowErrors no-error.
                        if avail RowErrors then do:
                            RUN getRowErrors IN this-procedure (OUTPUT TABLE rowErrors).
                              IF  gi-mla-origem <> 2 THEN DO:
        						{method/showmessage.i1}
        						/*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
        						{method/showmessage.i2}
        					END.
                            return "NOK".
                        END.
                END.
                ELSE DO:
                IF c-prog-executa = "mla014e.p" THEN DO:
                    RUN VALUE(c-prog-executa) (INPUT p-rowid-doc,
                                               INPUT p-cod-aprov,
                                               NO,
                                               INPUT-OUTPUT TABLE tt-RowErrors). 
                    IF  RETURN-VALUE = "NOK":U THEN DO:
                        RETURN "NOK":U.
                    END.
                END.
                ELSE IF c-prog-executa = "mla024.p" THEN DO:
                    RUN VALUE(c-prog-executa) (INPUT p-rowid-doc,
                                               INPUT p-cod-aprov,
                                               NO,
                                               INPUT-OUTPUT TABLE tt-log-erro). 
                    IF  RETURN-VALUE = "NOK":U THEN DO:
                        RETURN "NOK":U.
                    END.
                END.
                ELSE DO:

                    RUN pi-gerar-dados-extrato (INPUT " boin767b: c-prog-executa  " + STRING(c-prog-executa) + " | " + String(p-rowid-doc)  + " | " + String(p-cod-aprov)).                    

                    IF  mla-doc-pend-aprov.cod-tip-doc = 32 /* Originaá∆o - Adiantamento Valor    */ OR
                        mla-doc-pend-aprov.cod-tip-doc = 33 /* Originaá∆o - Fechamento Financeiro */ THEN DO:
                        RUN VALUE(c-prog-executa) (INPUT  p-rowid-doc,
                                                   INPUT  p-cod-aprov,
                                                   INPUT  NO,
                                                   OUTPUT TABLE RowErrors APPEND).
                    END.
                    ELSE DO:
                        RUN VALUE(c-prog-executa) (INPUT p-rowid-doc,
                                                   INPUT p-cod-aprov,
                                                   NO). 
                    END.

                    IF  RETURN-VALUE = "NOK":U THEN DO:
                        RETURN "NOK":U.
                        END.
                    END.
                END.
            END.
        END.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeraFaixa DBOProgram 
PROCEDURE setGeraFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST mla-faixa-aprov NO-LOCK
         WHERE mla-faixa-aprov.ep-codigo   = i-ep-codigo
           AND mla-faixa-aprov.cod-estabel = c-cod-estabel
           AND mla-faixa-aprov.cod-lotacao = c-lotacao 
           AND mla-faixa-aprov.cod-tip-doc = i-cod-tip-doc
           AND mla-faixa-aprov.limite-ini <= de-valor-aprov 
           AND mla-faixa-aprov.limite-fim >= de-valor-aprov  NO-ERROR.


    IF AVAIL mla-faixa-aprov THEN DO:
        ASSIGN i-faixa-aprov = mla-faixa-aprov.num-faixa.

        FIND FIRST mla-hierarquia-faixa NO-LOCK
             WHERE mla-hierarquia-faixa.ep-codigo   = i-ep-codigo
               AND mla-hierarquia-faixa.cod-estabel = c-cod-estabel
               AND mla-hierarquia-faixa.cod-lotacao = c-lotacao
               AND mla-hierarquia-faixa.cod-tip-doc = i-cod-tip-doc
               AND mla-hierarquia-faixa.num-faixa   = i-faixa-aprov
               AND mla-hierarquia-faixa.seq-aprov   = 1  NO-ERROR.

        IF  AVAIL mla-hierarquia-faixa THEN DO:
            ASSIGN c-cod-aprovador = mla-hierarquia-faixa.cod-usuar
                   r-rowid         = ROWID(mla-hierarquia-faixa).
            

            RUN pi-gerar-dados-extrato (INPUT "boin767b: usuario possui mla-hierarquia-faixa " + " | " + STRING(c-cod-aprovador)).

            RUN setEpcFaixa IN THIS-PROCEDURE (INPUT 1).

            ASSIGN i-faixa-aprov = mla-hierarquia-faixa.num-faixa.

            RUN pi-gerar-dados-extrato (INPUT "boin767b: setGeraPendAprov " + " | " + String(c-cod-aprovador)  + " | " + String(i-faixa-aprov)).

            RUN setGeraPendAprov IN THIS-PROCEDURE (INPUT c-cod-aprovador,
                                                    INPUT i-faixa-aprov,
                                                    INPUT 1).

            RUN setEpcFaixa IN THIS-PROCEDURE (INPUT 2).

        END.
    END.
    ELSE
      RUN pi-gerar-dados-extrato (INPUT "boin767b: n∆o mla-faixa-aprov " + " | " + STRING(i-ep-codigo)  + " | " + STRING(c-cod-estabel) + " | " + STRING(c-lotacao)  + " | " + STRING(i-cod-tip-doc) + " /" + STRING(de-valor-aprov)).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeraHierarquia DBOProgram 
PROCEDURE setGeraHierarquia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FIND FIRST mla-hierarquia-aprov NO-LOCK 
         WHERE mla-hierarquia-aprov.ep-codigo   = i-ep-codigo 
           AND mla-hierarquia-aprov.cod-estabel = c-cod-estabel
           AND mla-hierarquia-aprov.cod-lotacao = c-lotacao   
           AND mla-hierarquia-aprov.cod-tip-doc = i-cod-tip-doc
           AND mla-hierarquia-aprov.seq-aprov   = 1     NO-ERROR.
    IF  AVAIL mla-hierarquia-aprov THEN DO:
        ASSIGN c-cod-aprovador = mla-hierarquia-aprov.cod-usuar.
        RUN setGeraPendAprov IN THIS-PROCEDURE (INPUT c-cod-aprovador,
                                                INPUT 0,
                                                INPUT 1).
    END.
                      
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeraHistorico DBOProgram 
PROCEDURE setGeraHistorico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  i-tipo-trans <> 1 THEN DO:
        FOR EACH {&TABLENAME} WHERE
            {&TABLENAME}.ep-codigo    = i-ep-codigo   AND
            {&TABLENAME}.cod-estabel  = c-cod-estabel AND
            {&TABLENAME}.cod-tip-doc  = i-cod-tip-doc AND 
            {&TABLENAME}.chave-doc    = c-chave       AND 
            {&tablename}.ind-situacao > 1             AND 
            {&TABLENAME}.historico    = NO EXCLUSIVE-LOCK:
            ASSIGN {&TABLENAME}.historico   = yes
                   {&TABLENAME}.motivo-hist = c-motivo-aprov.

            /**  Refaz saldo da verba
            **/
            IF  {&tablename}.ind-situacao = 2 THEN DO:
                FIND FIRST mla-verba-aprov NO-LOCK
                     WHERE mla-verba-aprov.ep-codigo    = {&TABLENAME}.ep-codigo 
                       AND mla-verba-aprov.cod-estabel  = {&TABLENAME}.cod-estabel
                       AND mla-verba-aprov.cod-usuar    = {&TABLENAME}.cod-usuar 
                       AND mla-verba-aprov.cod-tip-doc  = {&TABLENAME}.cod-tip-doc 
                       AND mla-verba-aprov.periodo-ini <= {&TABLENAME}.dt-geracao
                       AND mla-verba-aprov.periodo-fim >= {&TABLENAME}.dt-geracao NO-ERROR.
                IF AVAIL mla-verba-aprov THEN
                    ASSIGN mla-verba-aprov.verba-utilizada = mla-verba-aprov.verba-utilizada - {&TABLENAME}.valor-doc.
            END.
        END.

        /**  Elimina documentos pendentes
        **/
        FOR EACH {&TABLENAME} WHERE 
            {&TABLENAME}.ep-codigo   = i-ep-codigo AND 
            {&TABLENAME}.cod-tip-doc = i-cod-tip-doc AND 
            {&TABLENAME}.chave-doc   = c-chave EXCLUSIVE-LOCK:

            IF  {&TABLENAME}.cod-estabel = c-cod-estabel AND
                {&TABLENAME}.historico <> NO AND
                i-tipo-trans = 2 THEN
                NEXT.

            DELETE {&TABLENAME}.
        END.
    END.
       
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeraLista DBOProgram 
PROCEDURE setGeraLista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR de-limite-aprov AS DECIMAL NO-UNDO.

    EMPTY TEMP-TABLE tt-lista.
    
    ASSIGN l-achou-lista = NO.

    IF  l-tipo-aprov-ref THEN DO:
        /**  Referància
        **/
        ASSIGN l-desvia = NO.

        RUN setEpcLista IN THIS-PROCEDURE (INPUT 1).

        IF l-desvia = NO THEN DO:
            FOR EACH mla-lista-aprov-ref 
               WHERE mla-lista-aprov-ref.ep-codigo   = i-ep-codigo   
                 AND mla-lista-aprov-ref.cod-estabel = c-cod-estabel 
                 AND mla-lista-aprov-ref.cod-tip-doc = i-cod-tip-doc
                 AND mla-lista-aprov-ref.codigo      = c-cod-referencia NO-LOCK:

                FIND FIRST mla-perm-aprov NO-LOCK 
                     WHERE mla-perm-aprov.ep-codigo   = mla-lista-aprov-ref.ep-codigo 
                       AND mla-perm-aprov.cod-estabel = mla-lista-aprov-ref.cod-estabel 
                       AND mla-perm-aprov.cod-usuar   = mla-lista-aprov-ref.cod-usuar 
                       AND mla-perm-aprov.cod-tip-doc = mla-lista-aprov-ref.cod-tip-doc NO-ERROR.
                IF AVAIL mla-perm-aprov THEN DO:
                    ASSIGN de-limite-aprov = mla-perm-aprov.limite-aprov.
                    IF  de-limite-aprov < de-valor-aprov AND
                        l-lim-lista THEN /*Apenas Aprovadores com Limite*/
                        NEXT.
                    
                    CREATE tt-lista.
                    ASSIGN tt-lista.seq-aprov       = mla-lista-aprov-ref.seq-aprov
                           tt-lista.cod-usuar-aprov = mla-lista-aprov-ref.cod-usuar
                           tt-lista.limite-aprov    = de-limite-aprov
                           tt-lista.rowlista        = ROWID(mla-lista-aprov-ref).
                END.
            END.

            FIND FIRST tt-lista NO-ERROR.
            IF  AVAILABLE tt-lista THEN
                ASSIGN tt-lista.seq-aprov       = 10
                       l-achou-lista            = YES.
        END.
    END.
    ELSE IF l-tipo-aprov-item THEN DO:
        /**  Item
        **/
        FOR EACH mla-lista-aprov-item NO-LOCK 
           WHERE mla-lista-aprov-item.ep-codigo   = i-ep-codigo   
             AND mla-lista-aprov-item.cod-estabel = c-cod-estabel
             AND mla-lista-aprov-item.it-codigo   = c-it-codigo   :
        
            FIND FIRST mla-perm-aprov NO-LOCK 
                 WHERE mla-perm-aprov.ep-codigo   = mla-lista-aprov-item.ep-codigo 
                   AND mla-perm-aprov.cod-estabel = mla-lista-aprov-item.cod-estabel 
                   AND mla-perm-aprov.cod-usuar   = mla-lista-aprov-item.cod-usuar 
                   AND mla-perm-aprov.cod-tip-doc = i-cod-tip-doc NO-ERROR.
            IF AVAIL mla-perm-aprov THEN DO:
                ASSIGN de-limite-aprov = mla-perm-aprov.limite-aprov.
                IF  de-limite-aprov < de-valor-aprov AND
                    l-lim-lista THEN /*Apenas Aprovadores com Limite*/
                    NEXT.
                
                CREATE tt-lista.
                ASSIGN tt-lista.seq-aprov       = mla-lista-aprov-item.seq-aprov
                       tt-lista.cod-usuar-aprov = mla-lista-aprov-item.cod-usuar
                       tt-lista.limite-aprov    = de-limite-aprov
                       tt-lista.rowlista        = ROWID(mla-lista-aprov-item).
            END.
        END.
        FIND FIRST tt-lista NO-ERROR.
        IF  AVAILABLE tt-lista THEN
            ASSIGN tt-lista.seq-aprov       = 10
                   l-achou-lista            = YES.
    END.
    ELSE IF l-tipo-aprov-fam THEN DO:
        /**  Fam°lia
        **/
        FIND ITEM WHERE ITEM.it-codigo = c-it-codigo NO-LOCK NO-ERROR.
        IF  AVAILABLE ITEM THEN
            ASSIGN c-fm-codigo = ITEM.fm-codigo.

        FOR EACH mla-lista-aprov-fam NO-LOCK
           WHERE mla-lista-aprov-fam.ep-codigo   = i-ep-codigo   
             AND mla-lista-aprov-fam.cod-estabel = c-cod-estabel
             AND mla-lista-aprov-fam.fm-codigo   = c-fm-codigo:

            FIND FIRST mla-perm-aprov NO-LOCK 
                 WHERE mla-perm-aprov.ep-codigo   = mla-lista-aprov-fam.ep-codigo 
                   AND mla-perm-aprov.cod-estabel = mla-lista-aprov-fam.cod-estabel 
                   AND mla-perm-aprov.cod-usuar   = mla-lista-aprov-fam.cod-usuar 
                   AND mla-perm-aprov.cod-tip-doc = i-cod-tip-doc NO-ERROR.
            IF AVAIL mla-perm-aprov THEN DO:
                ASSIGN de-limite-aprov = mla-perm-aprov.limite-aprov.
                IF  de-limite-aprov < de-valor-aprov AND
                    l-lim-lista THEN /*Apenas Aprovadores com Limite*/
                    NEXT.
                
                CREATE tt-lista.
                ASSIGN tt-lista.seq-aprov       = mla-lista-aprov-fam.seq-aprov
                       tt-lista.cod-usuar-aprov = mla-lista-aprov-fam.cod-usuar
                       tt-lista.limite-aprov    = de-limite-aprov
                       tt-lista.rowlista        = ROWID(mla-lista-aprov-fam).
            END.
        END.
        FIND FIRST tt-lista NO-ERROR.
        IF  AVAILABLE tt-lista THEN
            ASSIGN tt-lista.seq-aprov       = 10
                   l-achou-lista            = YES.
    END.
    ELSE IF l-tipo-aprov-doc THEN DO:
        /**  Documento
        **/
        FOR EACH mla-lista-aprov-doc
           WHERE mla-lista-aprov-doc.ep-codigo   = i-ep-codigo
             AND mla-lista-aprov-doc.cod-estabel = c-cod-estabel
             AND mla-lista-aprov-doc.cod-tip-doc = i-cod-tip-doc NO-LOCK:

            FIND FIRST mla-perm-aprov NO-LOCK 
                 WHERE mla-perm-aprov.ep-codigo   = mla-lista-aprov-doc.ep-codigo 
                   AND mla-perm-aprov.cod-estabel = mla-lista-aprov-doc.cod-estabel 
                   AND mla-perm-aprov.cod-usuar   = mla-lista-aprov-doc.cod-usuar 
                   AND mla-perm-aprov.cod-tip-doc = mla-lista-aprov-doc.cod-tip-doc NO-ERROR.
            IF AVAIL mla-perm-aprov THEN DO:
                ASSIGN de-limite-aprov = mla-perm-aprov.limite-aprov.
                IF  de-limite-aprov < de-valor-aprov AND
                    l-lim-lista THEN /*Apenas Aprovadores com Limite*/
                    NEXT.

                CREATE tt-lista.
                ASSIGN tt-lista.seq-aprov       = mla-lista-aprov-doc.seq-aprov
                       tt-lista.cod-usuar-aprov = mla-lista-aprov-doc.cod-usuar
                       tt-lista.limite-aprov    = de-limite-aprov
                       tt-lista.rowlista        = ROWID(mla-lista-aprov-doc).
            END.
        END.
        FIND FIRST tt-lista NO-ERROR.
        IF  AVAILABLE tt-lista THEN
            ASSIGN tt-lista.seq-aprov       = 10
                   l-achou-lista            = YES.
    END.

    RUN setEpcLista IN THIS-PROCEDURE (INPUT 2).

    FOR EACH tt-lista NO-LOCK 
        BY tt-lista.limite-aprov:
        assign c-cod-aprovador = tt-lista.cod-usuar-aprov.

        RUN setGeraPendAprov IN THIS-PROCEDURE (INPUT tt-lista.cod-usuar-aprov,
                                                INPUT 0,
                                                INPUT tt-lista.seq-aprov).

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeraMensagem DBOProgram 
PROCEDURE setGeraMensagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT l-mensagens-geradas THEN DO:
        
        run utp/ut-msgs.p (input "msg", input 26593, input "&1" + "~~" +
                                                           "&2").
        ASSIGN c-msgs-26593 = RETURN-VALUE.
    
        run utp/ut-msgs.p (input "help", input 26593, input "&1" + "~~" +
                                                            "&2" + "~~" +
                                                            "&3" + "~~" +
                                                            "&4").
        ASSIGN c-help-26593 = RETURN-VALUE.
    
        run utp/ut-msgs.p (input "msg", input 26652, input "&1" + "~~" +
                                                           "&2").
    
        ASSIGN c-msgs-26652 = RETURN-VALUE.
    
        run utp/ut-msgs.p (input "help", input 26652, input "&1" + "~~" +
                                                            "&2" + "~~" +
                                                            "&3" + "~~" +
                                                            "&4").
        ASSIGN c-help-26652 = RETURN-VALUE.

        ASSIGN l-mensagens-geradas = YES.

    END.
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeraPadrao DBOProgram 
PROCEDURE setGeraPadrao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FIND FIRST mla-usuar-padrao NO-LOCK
         WHERE mla-usuar-padrao.ep-codigo     = i-ep-codigo
           AND mla-usuar-padrao.cod-estabel   = c-cod-estabel
           AND mla-usuar-padrao.cod-tip-aprov = i-cod-aprov NO-ERROR.
    IF  AVAIL mla-usuar-padrao THEN DO:
        ASSIGN c-cod-aprovador = mla-usuar-padrao.cod-usuar.

        RUN setGeraPendAprov IN THIS-PROCEDURE (INPUT c-cod-aprovador,
                                                INPUT 0,
                                                INPUT 10).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeraPendAprov DBOProgram 
PROCEDURE setGeraPendAprov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-aprovador AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-faixa     AS INTEGER   NO-UNDO. 
    DEFINE INPUT PARAMETER p-sequencia AS INTEGER   NO-UNDO.                           

    RUN pi-gerar-dados-extrato (INPUT "boin767b: entrou setGeraPendAprov " + " p-aprovador " + STRING(p-aprovador) + " | p-faixa " + STRING(p-faixa) + " p-sequencia " + STRING(p-sequencia)).

    FIND FIRST mla-usuar-aprov NO-LOCK
         WHERE mla-usuar-aprov.cod-usuar = c-cod-usuar-doc NO-ERROR.
    ASSIGN c-cod-lotacao-trans = IF AVAIL mla-usuar-aprov THEN mla-usuar-aprov.cod-lotacao ELSE ""
           i-destino-lotacao   = IF AVAIL mla-usuar-aprov THEN mla-usuar-aprov.destino-lotacao ELSE 1.

    RUN pi-gerar-dados-extrato (INPUT "boin767b: c-cod-lotacao-trans " + STRING(c-cod-lotacao-trans)).

    FIND FIRST mla-tipo-aprov NO-LOCK
         WHERE mla-tipo-aprov.cod-tip-aprov = i-cod-aprov NO-ERROR.
    ASSIGN i-ind-tip-aprov = mla-tipo-aprov.ind-tip-aprov.

    FIND FIRST bf{&TABLENAME} 
        where bf{&TABLENAME}.ep-codigo     = i-ep-codigo   
        and   bf{&TABLENAME}.cod-estabel   = c-cod-estabel 
        and   bf{&TABLENAME}.cod-tip-doc   = i-cod-tip-doc 
        and   bf{&TABLENAME}.chave-doc     = c-chave   
        and   bf{&tablename}.ind-situacao  = 2 
        and   bf{&TABLENAME}.historico     = no 
	no-lock NO-ERROR.

    CREATE {&TABLENAME}.
    ASSIGN {&TABLENAME}.ep-codigo         = i-ep-codigo
           {&TABLENAME}.cod-estabel       = c-cod-estabel
           {&TABLENAME}.chave-doc         = c-chave
           {&TABLENAME}.cod-lotacao-doc   = IF i-destino-lotacao = 1 THEN 
                                               c-cod-lotacao 
                                            ELSE IF c-cod-lotacao-doc <> "" THEN 
                                                    c-cod-lotacao-doc /*TPLQLO*/ 
                                                 ELSE bf{&TABLENAME}.cod-lotacao-doc
           {&TABLENAME}.cod-lotacao-trans = if avail bf{&TABLENAME} then bf{&TABLENAME}.cod-lotacao-trans else c-cod-lotacao-trans
           {&TABLENAME}.cod-tip-aprov     = i-cod-aprov
           {&TABLENAME}.cod-tip-doc       = i-cod-tip-doc
           {&TABLENAME}.cod-usuar         = p-aprovador            
           {&TABLENAME}.cod-usuar-doc     = c-cod-usuar-doc
           {&TABLENAME}.cod-usuar-trans   = if avail bf{&TABLENAME} then bf{&TABLENAME}.cod-usuar-trans else c-cod-usuar-trans
           {&TABLENAME}.dt-geracao        = today
           {&tablename}.ind-situacao      = 1
           {&tablename}.ind-tip-aprov     = i-ind-tip-aprov
           {&tablename}.it-codigo         = c-it-codigo
           {&TABLENAME}.mo-codigo         = i-moeda
           {&TABLENAME}.motivo-doc        = c-motivo-aprov
           {&TABLENAME}.num-faixa         = p-faixa
           {&TABLENAME}.seq-aprov         = p-sequencia
           {&TABLENAME}.valor-doc         = de-valor-aprov
           {&TABLENAME}.prioridade-aprov  = i-prioridade
           {&TABLENAME}.hora-geracao      = string(time,"HH:MM:SS")
           {&TABLENAME}.cod-referencia    = c-cod-referencia.

    RUN pi-gerar-dados-extrato (INPUT "boin767b: Criou Pend. Aprov ").

    ASSIGN l-gerou-pendencia = YES.

    LOG-MANAGER:WRITE-MESSAGE (">>> Transacao: " + STRING({&TABLENAME}.nr-trans)) NO-ERROR.

    CREATE tt{&TABLENAME}.
    BUFFER-COPY {&TABLENAME} TO tt{&TABLENAME}.
    ASSIGN tt{&TABLENAME}.rrowid = ROWID({&TABLENAME}).


    RUN setEpcPend IN THIS-PROCEDURE.

    assign l-aprovado      = NO
           l-aprovado-auto = NO.
           
    FIND FIRST mla-usuar-aprov NO-LOCK
         WHERE mla-usuar-aprov.cod-usuar = c-cod-usuar-doc NO-ERROR.
    ASSIGN l-perm-aprov  = mla-usuar-aprov.perm-aprov
           l-aprova-auto = mla-usuar-aprov.aprova-auto.

    /**  Aprovaá∆o Autom†tica
    **/

    RUN pi-gerar-dados-extrato (INPUT "boin767b: Aprovaá∆o Autom†tica 1 " + " | " + STRING(l-perm-aprov) + " | " + STRING(l-aprova-auto)).
    RUN pi-gerar-dados-extrato (INPUT "boin767b: Aprovaá∆o Autom†tica 2 " + STRING(de-limite-auto) + " | " + STRING(de-valor-aprov)).

    IF  l-perm-aprov AND 
        l-aprova-auto AND 
        de-limite-auto >= de-valor-aprov THEN DO:

        assign l-aprovado      = YES
               l-aprovado-auto = YES.

       ASSIGN c-desc-aprov-auto = "Aprovaá∆o Autom†tica - Usu†rio ".
       ASSIGN {&TABLENAME}.aprov-auto        = YES
              {&TABLENAME}.dt-aprova         = TODAY
              {&tablename}.ind-situacao      = 2
              {&TABLENAME}.narrativa-apr     = c-desc-aprov-auto + STRING(c-cod-usuar-doc) + " parametrizado no MLA0103 como Aprovaá∆o Autom†tica"
              OVERLAY({&TABLENAME}.char-1,1,8) = string(time,"hh:mm:ss"). 

        RUN pi-gerar-dados-extrato (INPUT "boin767b: Aprovaá∆o Autom†tica - Usu†rio " ).

       IF  p-aprovador <> c-cod-usuar-doc THEN
           ASSIGN {&TABLENAME}.cod-usuar-altern = c-cod-usuar-doc.
    END.
    ELSE DO:
        FIND FIRST mla-usuar-aprov NO-LOCK
             WHERE mla-usuar-aprov.cod-usuar = c-cod-aprovador NO-ERROR.
        ASSIGN l-perm-aprov        = mla-usuar-aprov.perm-aprov
               l-aprova-auto-aprov = mla-usuar-aprov.aprova-auto-aprov.

        /**  Aprovaá∆o Autom†tica para Aprovador
        **/
        IF  l-perm-aprov AND
            l-aprova-auto-aprov AND
            c-cod-aprovador = c-cod-usuar-doc AND
            de-limite-auto >= de-valor-aprov  THEN DO:

            ASSIGN l-aprovado = yes.

            RUN pi-gerar-dados-extrato (INPUT "boin767b: Aprovaá∆o Autom†tica para Aprovador " ).

            ASSIGN c-desc-aprov-auto = "Aprovaá∆o Autom†tica - Usu†rio ".
            ASSIGN {&TABLENAME}.aprov-auto        = YES
                   {&TABLENAME}.dt-aprova         = TODAY
                   {&tablename}.ind-situacao      = 2
                   {&TABLENAME}.narrativa-apr     = c-desc-aprov-auto + STRING(c-cod-aprovador) + " parametrizado no MLA0103 como Aprovaá∆o Autom†tica"
                   OVERLAY({&TABLENAME}.char-1,1,8) = string(time,"hh:mm:ss").

            IF  i-ind-tip-aprov = 1 THEN DO:
                ASSIGN l-aprovado = NO.        
                RUN setGeraPendHierarquia IN THIS-PROCEDURE.
            END.
            IF  i-ind-tip-aprov = 5 THEN DO:
                ASSIGN l-aprovado = NO.
                RUN setGeraPendFaixa IN THIS-PROCEDURE.
            END.
        END.
    END.

    /* ### Integraá∆o Fluig ### */
    IF {&TABLENAME}.aprov-auto = NO THEN DO:
        ASSIGN r-rowid-aux-include = ROWID({&TABLENAME})
               i-nr-trans-include  = {&TABLENAME}.nr-trans.

        IF NOT AVAIL mla-tipo-doc-aprov THEN DO:
            FOR FIRST mla-tipo-doc-aprov FIELDS(ep-codigo cod-estabel log-integr-fluig cod-tip-doc) NO-LOCK
                WHERE mla-tipo-doc-aprov.ep-codigo   = {&TABLENAME}.ep-codigo  
                AND   mla-tipo-doc-aprov.cod-estabel = {&TABLENAME}.cod-estabel
                AND   mla-tipo-doc-aprov.cod-tip-doc = {&TABLENAME}.cod-tip-doc: 
            END.
        END.
        IF NOT AVAIL mla-param-aprov THEN DO:
            FOR FIRST mla-param-aprov FIELDS(ep-codigo cod-estabel log-integr-fluig) NO-LOCK
                WHERE mla-param-aprov.ep-codigo   = {&TABLENAME}.ep-codigo 
                AND   mla-param-aprov.cod-estabel = {&TABLENAME}.cod-estabel: 
            END.
        END.
        /* Verifica se o documento est† parametrizado para integrar com o Fluig */
        IF AVAIL mla-tipo-doc-aprov AND AVAIL mla-param-aprov AND mla-tipo-doc-aprov.log-integr-fluig AND mla-param-aprov.log-integr-fluig THEN DO:
            RUN startProcessFluig IN h-mlaapi014(INPUT i-nr-trans-include,
                                                 OUTPUT iNrSolicFluig,
                                                 OUTPUT TABLE RowErrorsAux).
            ASSIGN lErroFluig = CAN-FIND(FIRST RowErrorsAux).
            
            IF NOT lErroFluig THEN DO:
                FOR FIRST {&TABLENAME} fields(cdn-workflow-fluig) EXCLUSIVE-LOCK
                    WHERE ROWID({&TABLENAME}) = r-rowid-aux-include:
                    ASSIGN {&TABLENAME}.cdn-workflow-fluig = iNrSolicFluig.
                END.
            END.
            ELSE DO:
                RUN utp/ut-msgs.p(INPUT "msg", INPUT 54790, INPUT "").
                ASSIGN cErrorDescription = return-value.
                RUN utp/ut-msgs.p(INPUT "help", INPUT 54790, INPUT "").
                ASSIGN cErrorHelp = return-value.
        
                IF NOT CAN-FIND (FIRST tt-erro WHERE tt-erro.cd-erro = 54790) THEN DO:
                    CREATE tt-erro.
                    ASSIGN tt-erro.mensagem = cErrorDescription + " - " + cErrorHelp.
                               tt-erro.cd-erro  = 54790.
                END.
            END.
        END.
    END.

    RUN setEnviaEmailAltern IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeraPendencia DBOProgram 
PROCEDURE setGeraPendencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-tip-doc AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER p-tipo-trans  AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER p-motivo      AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER p-valor       AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER p-moeda       AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER p-usuar-trans AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER p-usuar-doc   AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER p-lotacao-doc AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER p-item        AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER p-referencia  AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER p-ep-codigo   LIKE empresa.ep-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-mla-chave.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    ASSIGN i-cod-tip-doc     = p-cod-tip-doc
           i-tipo-trans      = p-tipo-trans
           c-motivo-aprov    = p-motivo
           de-valor-aprov    = p-valor
           i-moeda           = p-moeda
           c-cod-usuar-trans = p-usuar-trans
           c-cod-usuar-doc   = p-usuar-doc
           c-cod-lotacao-doc = p-lotacao-doc
           c-it-codigo       = p-item
           c-cod-referencia  = p-referencia
           i-ep-codigo       = p-ep-codigo
           c-cod-estabel     = p-cod-estabel.

    ASSIGN l-gerou-pendencia = NO.

    RUN setUsuario       IN THIS-PROCEDURE.
    RUN setChave         IN THIS-PROCEDURE.

    RUN pi-gerar-dados-extrato (INPUT "boin767b: RUN validatePend = " + String(i-cod-tip-doc) + " | " + String(i-tipo-trans) + " | " + String(c-cod-usuar-trans)
                                 + " | " + String(c-cod-usuar-doc) + " | " + c-cod-lotacao-doc + " | " + String(de-valor-aprov) + " | "  + c-cod-estabel + " | " ).

    RUN validatePend IN THIS-PROCEDURE (i-cod-tip-doc,
                                        i-tipo-trans,
                                        c-motivo-aprov,
                                        de-valor-aprov,
                                        i-moeda,
                                        c-cod-usuar-trans,
                                        c-cod-usuar-doc,
                                        c-cod-lotacao-doc,
                                        c-it-codigo,
                                        c-cod-referencia,
                                        i-ep-codigo,
                                        c-cod-estabel,
                                        INPUT  TABLE tt-mla-chave,
                                        OUTPUT TABLE RowErrors).


    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /*RUN setGeraHistorico IN THIS-PROCEDURE.*/
    
    RUN pi-gerar-dados-extrato (INPUT "boin767b: RUN setLotacao/setLimiteAprov/setTipoAprov ").

    RUN setLotacao       IN THIS-PROCEDURE.
    RUN setLimiteAprov   IN THIS-PROCEDURE.
    RUN setTipoAprov     IN THIS-PROCEDURE.

    EMPTY TEMP-TABLE tt{&TableName}.

    ASSIGN gi-prox-prior = gi-mla-prox-prior. 

    IF  i-tipo-trans <> 3 THEN DO:
        ASSIGN i-cod-aprov = 0.
        IF  gi-prox-prior <> 0 THEN DO:
            RUN getNextTipoAprov IN THIS-PROCEDURE (INPUT  i-tip-aprov,
                                                    OUTPUT i-cod-aprov).

            IF  RETURN-VALUE = "NOK" THEN DO:
                ASSIGN gi-prox-prior = 0.
                LEAVE.
            END.
        END.

        FIND FIRST mla-tipo-aprov NO-LOCK
             WHERE mla-tipo-aprov.cod-tip-aprov = i-cod-aprov NO-ERROR.
        IF AVAIL mla-tipo-aprov THEN
            ASSIGN i-ind-tip-aprov = mla-tipo-aprov.ind-tip-aprov.

        RUN pi-gerar-dados-extrato (INPUT "boin767b: Tipo Aprovacao " + String(i-ind-tip-aprov)).

        CASE i-ind-tip-aprov : 
            WHEN 1 THEN RUN setGeraHierarquia IN THIS-PROCEDURE.
            WHEN 2 THEN RUN setGeraLista      IN THIS-PROCEDURE.
            WHEN 3 THEN RUN setGeraPadrao     IN THIS-PROCEDURE.
            WHEN 4 THEN RUN setGeraPadrao     IN THIS-PROCEDURE.
            WHEN 5 THEN RUN setGeraFaixa      IN THIS-PROCEDURE.
        END CASE.

        ASSIGN gi-prox-prior = 0.
    END.

    IF  l-gerou-pendencia THEN DO:
        FIND FIRST tt{&TABLENAME} WHERE
            tt{&tablename}.ind-situacao = 1 NO-ERROR.
        IF  AVAILABLE tt{&TABLENAME} THEN DO:

            RUN pi-gerar-dados-extrato (INPUT "boin767b: setExecutaProg " + String(i-ep-codigo) + " | " + c-cod-estabel + " | " + String(i-cod-tip-doc) + " | " + String(i-tipo-trans)).

            RUN setExecutaProg IN THIS-PROCEDURE (INPUT i-ep-codigo,
                                                  INPUT c-cod-estabel,
                                                  INPUT i-cod-tip-doc,
                                                  INPUT i-tipo-trans,
                                                  INPUT tt{&TABLENAME}.rrowid,
                                                  INPUT tt{&TABLENAME}.cod-usuar).
            IF  RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
        END.
    END.


    FOR EACH tt{&TABLENAME}:         

        /**  N∆o encaminha e-mail (Aprovaá∆o Autom†tica) quando 
        ***  gerou para o pr¢ximo aprovador da hierarquia ou faixa
        **/
        FIND bf{&TABLENAME} WHERE
            rowid(bf{&TABLENAME}) = tt{&TABLENAME}.rrowid
            NO-LOCK NO-ERROR.
        IF  AVAILABLE bf{&TABLENAME} AND 
            bf{&tablename}.ind-situacao = 2 AND
            bf{&TABLENAME}.aprov-auto   = YES THEN DO:
            FIND FIRST bf{&TABLENAME} WHERE
                bf{&TABLENAME}.ep-codigo     = tt{&TABLENAME}.ep-codigo   AND
                bf{&TABLENAME}.cod-estabel   = tt{&TABLENAME}.cod-estabel AND
                bf{&TABLENAME}.cod-tip-doc   = tt{&TABLENAME}.cod-tip-doc AND
                bf{&TABLENAME}.chave-doc     = tt{&TABLENAME}.chave-doc   AND
                bf{&tablename}.ind-situacao  = 1 AND
                bf{&TABLENAME}.historico     = NO
                NO-LOCK NO-ERROR.
            IF  AVAILABLE bf{&TABLENAME} THEN
                NEXT.
        END.

        RUN pi-gerar-dados-extrato (INPUT "boin767b: setEnviaEmail ").

        RUN setEnviaEmail IN THIS-PROCEDURE (INPUT "",
                                             INPUT tt{&TABLENAME}.rrowid).
    END.
    
    RUN pi-gerar-dados-extrato (INPUT "boin767b: l-gerou-pendencia " + STRING(l-gerou-pendencia)).

    IF  NOT l-gerou-pendencia THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeraPendFaixa DBOProgram 
PROCEDURE setGeraPendFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST mla-hierarquia-faixa NO-LOCK
         WHERE mla-hierarquia-faixa.ep-codigo   = i-ep-codigo
           AND mla-hierarquia-faixa.cod-estabel = c-cod-estabel
           AND mla-hierarquia-faixa.cod-lotacao = c-lotacao
           AND mla-hierarquia-faixa.cod-tip-doc = i-cod-tip-doc
           AND mla-hierarquia-faixa.num-faixa   = {&TABLENAME}.num-faixa
           AND mla-hierarquia-faixa.seq-aprov   = {&TABLENAME}.seq-aprov NO-ERROR.
    IF  AVAIL mla-hierarquia-faixa THEN
        ASSIGN l-log-depend = mla-hierarquia-faixa.log-depend.

    RUN pi-gerar-dados-extrato (INPUT "boin767b: setGeraPendFaixa ").

    IF  AVAIL mla-hierarquia-faixa AND
       (l-log-depend OR
       (NOT l-log-depend AND de-limite-auto < de-valor-aprov)) THEN DO:

        FIND FIRST mla-hierarquia-faixa NO-LOCK
             WHERE mla-hierarquia-faixa.ep-codigo   = i-ep-codigo
               AND mla-hierarquia-faixa.cod-estabel = c-cod-estabel
               AND mla-hierarquia-faixa.cod-lotacao = c-lotacao
               AND mla-hierarquia-faixa.cod-tip-doc = i-cod-tip-doc
               AND mla-hierarquia-faixa.num-faixa   = {&TABLENAME}.num-faixa
               AND mla-hierarquia-faixa.seq-aprov   = ({&TABLENAME}.seq-aprov + 1) NO-ERROR.

        IF  AVAIL mla-hierarquia-faixa THEN DO:
            ASSIGN c-cod-aprovador = mla-hierarquia-faixa.cod-usuar.

            RUN pi-gerar-dados-extrato (INPUT "boin767b: Criando Pendencia = " + c-cod-aprovador + " | " + STRING({&TABLENAME}.chave-doc)).

            CREATE bf{&TABLENAME}.
            ASSIGN bf{&TABLENAME}.ep-codigo            = {&TABLENAME}.ep-codigo
                   bf{&TABLENAME}.cod-estabel          = {&TABLENAME}.cod-estabel
                   bf{&TABLENAME}.chave-doc            = {&TABLENAME}.chave-doc
                   bf{&TABLENAME}.cod-lotacao-doc      = {&TABLENAME}.cod-lotacao-doc
                   bf{&TABLENAME}.cod-lotacao-trans    = {&TABLENAME}.cod-lotacao-trans
                   bf{&TABLENAME}.cod-tip-aprov        = {&TABLENAME}.cod-tip-aprov
                   bf{&TABLENAME}.cod-tip-doc          = {&TABLENAME}.cod-tip-doc
                   bf{&TABLENAME}.cod-usuar            = c-cod-aprovador
                   bf{&TABLENAME}.cod-usuar-doc        = {&TABLENAME}.cod-usuar-doc
                   bf{&TABLENAME}.cod-usuar-trans      = {&TABLENAME}.cod-usuar-trans
                   bf{&TABLENAME}.dt-geracao           = today
                   bf{&tablename}.ind-situacao         = 1
                   bf{&tablename}.ind-tip-aprov        = {&tablename}.ind-tip-aprov
                   bf{&tablename}.it-codigo            = {&tablename}.it-codigo
                   bf{&TABLENAME}.mo-codigo            = {&TABLENAME}.mo-codigo
                   bf{&TABLENAME}.motivo-doc           = {&TABLENAME}.motivo-doc
                   bf{&TABLENAME}.num-faixa            = {&TABLENAME}.num-faixa
                   bf{&TABLENAME}.seq-aprov            = {&TABLENAME}.seq-aprov + 1
                   bf{&TABLENAME}.valor-doc            = {&TABLENAME}.valor-doc
                   bf{&TABLENAME}.prioridade-aprov     = {&TABLENAME}.prioridade-aprov
                   bf{&TABLENAME}.hora-geracao         = string(time,"HH:MM:SS")
                   bf{&TABLENAME}.cod-referencia       = {&TABLENAME}.cod-referencia
                   OVERLAY(bf{&TABLENAME}.char-1,25,4) = TRIM(SUBSTRING({&TABLENAME}.char-1,25,4)). /*condiá∆o de pagamento*/

            CREATE tt{&TABLENAME}.
            BUFFER-COPY bf{&TABLENAME} TO tt{&TABLENAME}.
            ASSIGN tt{&TABLENAME}.rrowid = ROWID(bf{&TABLENAME}).

            ASSIGN l-aprovado = NO.

            FIND FIRST mla-usuar-aprov NO-LOCK
                 WHERE mla-usuar-aprov.cod-usuar = c-cod-aprovador NO-ERROR.
            ASSIGN l-perm-aprov        = mla-usuar-aprov.perm-aprov
                   l-aprova-auto-aprov = mla-usuar-aprov.aprova-auto-aprov.

            /**  Aprovaá∆o Autom†tica para Aprovador
            **/
            IF  RETURN-VALUE = "OK" AND
                l-perm-aprov AND
                l-aprova-auto-aprov AND
                de-limite-auto >= de-valor-aprov THEN DO:

                ASSIGN l-aprovado = YES
                       c-desc-aprov-auto = "Aprovaá∆o Autom†tica - Usu†rio".
                
                RUN pi-gerar-dados-extrato (INPUT "boin767b: Aprovaá∆o Autom†tica - Usu†rio ").              

                ASSIGN bf{&TABLENAME}.aprov-auto        = YES
                       bf{&TABLENAME}.dt-aprova         = TODAY
                       bf{&tablename}.ind-situacao      = 2
                       bf{&TABLENAME}.narrativa-apr     = c-desc-aprov-auto + STRING(c-cod-aprovador) + " parametrizado no MLA0103 como Aprovaá∆o Autom†tica para Aprovadores".

                ASSIGN SUBSTRING(bf{&TABLENAME}.char-1,1,8) = STRING(TIME,"hh:mm:ss"). 

                IF  bf{&tablename}.ind-tip-aprov = 1 THEN DO:
                    ASSIGN l-aprovado = no.  
                    RUN setGeraPendHierarquia IN THIS-PROCEDURE.
                END.
                IF  bf{&tablename}.ind-tip-aprov = 5 THEN DO:
                    ASSIGN l-aprovado = no.
                    RUN setGeraPendFaixa IN THIS-PROCEDURE.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeraPendHierarquia DBOProgram 
PROCEDURE setGeraPendHierarquia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST mla-hierarquia-aprov NO-LOCK
         WHERE mla-hierarquia-aprov.ep-codigo   = i-ep-codigo
           AND mla-hierarquia-aprov.cod-estabel = c-cod-estabel
           AND mla-hierarquia-aprov.cod-lotacao = c-lotacao
           AND mla-hierarquia-aprov.cod-tip-doc = i-cod-tip-doc
           AND mla-hierarquia-aprov.seq-aprov   = {&TABLENAME}.seq-aprov NO-ERROR.

    IF AVAIL mla-hierarquia-aprov THEN
        ASSIGN l-log-depend = mla-hierarquia-aprov.log-depend.

    IF  AVAIL mla-hierarquia-aprov AND
       (l-log-depend OR
       (NOT l-log-depend AND de-limite-auto < de-valor-aprov)) THEN DO:

        FIND FIRST mla-hierarquia-aprov NO-LOCK
             WHERE mla-hierarquia-aprov.ep-codigo   = i-ep-codigo
               AND mla-hierarquia-aprov.cod-estabel = c-cod-estabel
               AND mla-hierarquia-aprov.cod-lotacao = c-lotacao
               AND mla-hierarquia-aprov.cod-tip-doc = i-cod-tip-doc
               AND mla-hierarquia-aprov.seq-aprov   = ({&TABLENAME}.seq-aprov + 1) NO-ERROR.
    
        IF AVAIL mla-hierarquia-aprov THEN DO:
            ASSIGN c-cod-aprovador = mla-hierarquia-aprov.cod-usuar.

            CREATE bf{&TABLENAME}.
            ASSIGN bf{&TABLENAME}.ep-codigo            = {&TABLENAME}.ep-codigo
                   bf{&TABLENAME}.cod-estabel          = {&TABLENAME}.cod-estabel
                   bf{&TABLENAME}.chave-doc            = {&TABLENAME}.chave-doc
                   bf{&TABLENAME}.cod-lotacao-doc      = {&TABLENAME}.cod-lotacao-doc
                   bf{&TABLENAME}.cod-lotacao-trans    = {&TABLENAME}.cod-lotacao-trans
                   bf{&TABLENAME}.cod-tip-aprov        = {&TABLENAME}.cod-tip-aprov
                   bf{&TABLENAME}.cod-tip-doc          = {&TABLENAME}.cod-tip-doc
                   bf{&TABLENAME}.cod-usuar            = c-cod-aprovador
                   bf{&TABLENAME}.cod-usuar-doc        = {&TABLENAME}.cod-usuar-doc
                   bf{&TABLENAME}.cod-usuar-trans      = {&TABLENAME}.cod-usuar-trans
                   bf{&TABLENAME}.dt-geracao           = today
                   bf{&tablename}.ind-situacao         = 1
                   bf{&tablename}.ind-tip-aprov        = {&tablename}.ind-tip-aprov
                   bf{&tablename}.it-codigo            = {&tablename}.it-codigo
                   bf{&TABLENAME}.mo-codigo            = {&TABLENAME}.mo-codigo
                   bf{&TABLENAME}.motivo-doc           = {&TABLENAME}.motivo-doc
                   bf{&TABLENAME}.num-faixa            = {&TABLENAME}.num-faixa
                   bf{&TABLENAME}.seq-aprov            = {&TABLENAME}.seq-aprov + 1
                   bf{&TABLENAME}.valor-doc            = {&TABLENAME}.valor-doc
                   bf{&TABLENAME}.prioridade-aprov     = {&TABLENAME}.prioridade-aprov
                   bf{&TABLENAME}.hora-geracao         = string(time,"HH:MM:SS")
                   bf{&TABLENAME}.cod-referencia       = {&TABLENAME}.cod-referencia
                   OVERLAY(bf{&TABLENAME}.char-1,25,4) = TRIM(SUBSTRING({&TABLENAME}.char-1,25,4)). /*condiá∆o de pagamento*/

            ASSIGN l-aprovado = NO.

            CREATE tt{&TABLENAME}.
            BUFFER-COPY bf{&TABLENAME} TO tt{&TABLENAME}.
            ASSIGN tt{&TABLENAME}.rrowid = ROWID(bf{&TABLENAME}).

            ASSIGN l-aprovado = NO.

            FIND FIRST mla-usuar-aprov NO-LOCK
                 WHERE mla-usuar-aprov.cod-usuar = c-cod-aprovador NO-ERROR.
            ASSIGN l-perm-aprov        = mla-usuar-aprov.perm-aprov
                   l-aprova-auto-aprov = mla-usuar-aprov.aprova-auto-aprov.

            /**  Aprovaá∆o Autom†tica para Aprovador
            **/
            IF  RETURN-VALUE = "OK" AND
                l-perm-aprov AND
                l-aprova-auto-aprov AND
                de-limite-auto >= de-valor-aprov THEN DO:

                ASSIGN l-aprovado = YES.

                ASSIGN c-desc-aprov-auto = "Aprovaá∆o Autom†tica - Usu†rio ".
                ASSIGN bf{&TABLENAME}.aprov-auto        = YES
                       bf{&TABLENAME}.dt-aprova         = TODAY
                       bf{&tablename}.ind-situacao      = 2
                       bf{&TABLENAME}.narrativa-apr     = c-desc-aprov-auto + STRING(c-cod-aprovador) + " parametrizado no MLA0103 como Aprovaá∆o Autom†tica para Aprovadores".

                ASSIGN SUBSTRING(bf{&TABLENAME}.char-1,1,8) = STRING(TIME,"hh:mm:ss"). 

                IF  bf{&tablename}.ind-tip-aprov = 1 THEN DO:
                    ASSIGN l-aprovado = no.    
                    RUN setGeraPendHierarquia IN THIS-PROCEDURE.
                END.
                IF  bf{&tablename}.ind-tip-aprov = 5 THEN DO:
                    ASSIGN l-aprovado = no.
                    RUN setGeraPendFaixa IN THIS-PROCEDURE.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLimiteAprov DBOProgram 
PROCEDURE setLimiteAprov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND ITEM WHERE ITEM.it-codigo = c-it-codigo NO-LOCK NO-ERROR.
    IF  AVAILABLE ITEM THEN
        ASSIGN c-fm-codigo = ITEM.fm-codigo.

    FIND FIRST mla-usuar-aprov NO-LOCK
         WHERE mla-usuar-aprov.cod-usuar = c-usuario-aed NO-ERROR.
    ASSIGN l-aprova-auto-aprov = mla-usuar-aprov.aprova-auto-aprov
           l-aprova-auto       = mla-usuar-aprov.aprova-auto
           l-mestre            = mla-usuar-aprov.usuar-mestre.

    ASSIGN de-limite-auto = 0.

    /**  Aprovaá∆o Autom†tica Aprovador
    **/
    IF  l-aprova-auto-aprov THEN DO:
        IF  l-mestre THEN 
            ASSIGN de-limite-auto = 9999999999999.99.
        ELSE DO:
            FIND FIRST mla-perm-aprov NO-LOCK
                 WHERE mla-perm-aprov.ep-codigo   = i-ep-codigo
                   AND mla-perm-aprov.cod-estabel = c-cod-estabel
                   AND mla-perm-aprov.cod-usuar   = c-usuario-aed
                   AND mla-perm-aprov.cod-tip-doc = i-cod-tip-doc NO-ERROR.
            IF  AVAIL mla-perm-aprov THEN DO:
                ASSIGN de-limite-auto = mla-perm-aprov.limite-aprov.
                FIND FIRST mla-lim-aprov-fam NO-LOCK
                     WHERE mla-lim-aprov-fam.ep-codigo   = i-ep-codigo
                       AND mla-lim-aprov-fam.fm-codigo   = c-fm-codigo
                       AND mla-lim-aprov-fam.cod-tip-doc = i-cod-tip-doc
                       AND mla-lim-aprov-fam.cod-usuar   = c-usuario-aed  NO-ERROR.
                IF  AVAIL mla-lim-aprov-fam THEN
                    ASSIGN de-limite-auto = mla-lim-aprov-fam.limite-aprov.
            END.
        END.
    END. 

    /**  Aprovaá∆o Autom†tica
    **/
    IF  l-aprova-auto THEN DO:
        IF  l-mestre THEN 
            ASSIGN de-limite-auto = 9999999999999.99.
        ELSE DO:
            FIND FIRST mla-perm-aprov NO-LOCK
                 WHERE mla-perm-aprov.ep-codigo   = i-ep-codigo
                   AND mla-perm-aprov.cod-estabel = c-cod-estabel
                   AND mla-perm-aprov.cod-usuar   = c-usuario-aed
                   AND mla-perm-aprov.cod-tip-doc = i-cod-tip-doc NO-ERROR.
            IF  AVAIL mla-perm-aprov THEN DO:
               IF  mla-perm-aprov.validade-ini <= TODAY AND
                   mla-perm-aprov.validade-fim >= TODAY AND
                   mla-perm-aprov.limite-aprov >= de-valor-aprov THEN
                   ASSIGN de-limite-auto = mla-perm-aprov.limite-aprov.

               FIND FIRST mla-lim-aprov-fam NO-LOCK
                    WHERE mla-lim-aprov-fam.ep-codigo   = i-ep-codigo
                      AND mla-lim-aprov-fam.fm-codigo   = c-fm-codigo
                      AND mla-lim-aprov-fam.cod-tip-doc = i-cod-tip-doc
                      AND mla-lim-aprov-fam.cod-usuar   = c-usuario-aed  NO-ERROR.
               IF  AVAIL mla-lim-aprov-fam THEN
                   ASSIGN de-limite-auto = mla-lim-aprov-fam.limite-aprov.
            END.
        END.
    END.

    LOG-MANAGER:WRITE-MESSAGE (">>> Limite: " + string(TRIM(STRING(de-limite-auto,">,>>>,>>>,>>>,>>9.99")))) NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLotacao DBOProgram 
PROCEDURE setLotacao :
/*------------------------------------------------------------------------------
  Purpose: Seta lotaá∆o a ser usada na aprovaá∆o    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-boin772 AS HANDLE NO-UNDO.

    FIND FIRST mla-usuar-aprov NO-LOCK
         WHERE mla-usuar-aprov.cod-usuar = c-cod-usuar-doc NO-ERROR.
    ASSIGN i-destino-lotacao = mla-usuar-aprov.destino-lotacao
           c-cod-lotacao     = mla-usuar-aprov.cod-lotacao
           c-lotacao = "".

    IF  i-destino-lotacao = 1 /*AND 
        c-usuario-aed     = c-cod-usuar-doc*/ THEN DO:

        IF mla-tipo-doc-aprov.cod-tip-doc = 5  OR /*Cotaá∆o*/
           mla-tipo-doc-aprov.cod-tip-doc = 6  OR /*Pedido de Compra - Item*/
           mla-tipo-doc-aprov.cod-tip-doc = 19   /*Pedido de Compra Emergencial - Item*/
           THEN DO:
               RUN inbo/boin772.p PERSISTENT SET h-boin772.
               RUN buscaLotacaoUsuarOrig IN h-boin772(INPUT mla-tipo-doc-aprov.cod-tip-doc,
                                                      INPUT ordem-compra.nr-requisicao,
                                                      INPUT mla-usuar-aprov.cod-usuar,
                                                      OUTPUT c-lotacao).
               /*BO mla-lotacao*/
                IF VALID-HANDLE(h-boin772) THEN DO:
                    DELETE PROCEDURE h-boin772.
                    ASSIGN h-boin772 = ?.
                END.
        END.
        ELSE DO: 
            IF (mla-tipo-doc-aprov.cod-tip-doc = 29 OR /*Negociao Frete*/ 
               mla-tipo-doc-aprov.cod-tip-doc = 30 OR /*Documento Frete*/ 
               mla-tipo-doc-aprov.cod-tip-doc = 31) /*Fatura Frete*/ THEN DO:       
                IF  c-lotacao = "" THEN DO:
                    ASSIGN c-lotacao     = c-cod-lotacao-doc.
                    ASSIGN c-cod-lotacao = c-cod-lotacao-doc.

                END.

                RUN pi-gerar-dados-extrato (INPUT "boin767b: c-cod-lotacao = " + c-cod-lotacao-doc + " c-cod-usuar-doc " + STRING(c-cod-usuar-doc)).

              END.
        END.

                       
        IF  c-lotacao = "" THEN
            ASSIGN c-lotacao = c-cod-lotacao.

        IF  c-lotacao = "" THEN
            ASSIGN c-lotacao = c-cod-lotacao-doc.

        RUN pi-gerar-dados-extrato (INPUT "boin767b: c-lotacao = " + STRING(c-lotacao)).
    END.
    ELSE DO:
        ASSIGN c-lotacao = c-cod-lotacao-doc.
        IF  c-lotacao = "" THEN 
            ASSIGN c-lotacao = c-cod-lotacao.

        IF (mla-tipo-doc-aprov.cod-tip-doc = 29 OR /*Negociao Frete*/ 
           mla-tipo-doc-aprov.cod-tip-doc = 30 OR /*Documento Frete*/ 
           mla-tipo-doc-aprov.cod-tip-doc = 31) /*Fatura Frete*/ THEN DO:       
            IF  c-lotacao = "" THEN DO:
                ASSIGN c-lotacao     = c-cod-lotacao-doc.
                ASSIGN c-cod-lotacao = c-cod-lotacao-doc.

            END.

                RUN pi-gerar-dados-extrato (INPUT "boin767b: 2 c-cod-lotacao = " + c-cod-lotacao-doc + " c-cod-usuar-doc " + STRING(c-cod-usuar-doc)).

          END.

    END.
                  
    RUN setEpcLotacao IN THIS-PROCEDURE.

    LOG-MANAGER:WRITE-MESSAGE (">>> Lotacao: " + STRING(trim(c-lotacao))) NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTipoAprov DBOProgram 
PROCEDURE setTipoAprov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find first mla-doc-pend-aprov
         where mla-doc-pend-aprov.nr-trans = i-nr-trans no-lock no-error.

    find first mla-tipo-doc-aprov 
         where mla-tipo-doc-aprov.ep-codigo   = i-ep-codigo 
           and mla-tipo-doc-aprov.cod-estabel = c-cod-estabel 
           and mla-tipo-doc-aprov.cod-tip-doc = i-cod-tip-doc no-lock no-error.

    if  avail mla-tipo-doc-aprov 
    and avail mla-doc-pend-aprov then do:
    
        /*Tipos de aprovaá∆o por total do documento*/
        if i-cod-tip-doc = 2 
        or i-cod-tip-doc = 4 
        or i-cod-tip-doc = 7 
        or i-cod-tip-doc = 8 
        or i-cod-tip-doc = 10 
        or i-cod-tip-doc = 13 then do:
           /* Inicio da valiá∆o para documentos por total - referencia/documento */
           if mla-tipo-doc-aprov.prioridade-aprov = 3 then do: /* Prioridade:  REFER“NCIA */
    
               run pi-verifica-tipo-aprov-ref.
               if  return-value = "NOK":U and not l-pri-aprov-ant then 
                   run pi-verifica-tipo-aprov-doc.
    
           end.
           else if mla-tipo-doc-aprov.prioridade-aprov = 1 then do:    /* Prioridade:  DOCUMENTO */
               run pi-verifica-tipo-aprov-doc.
           end. /* Fim da validaá∆o por referencia e documento por total */ 
        end.
        else  do: /* Inicio validaá∆o por referencia/item/familia/documento para controle por item */
           if mla-tipo-doc-aprov.prioridade-aprov = 3 then do:
    
               run pi-verifica-tipo-aprov-ref.
               if return-value = "NOK":U and not l-pri-aprov-ant then do:

                   run pi-verifica-tipo-aprov-item.
                   if return-value = "NOK":U and not l-pri-aprov-ant then do:

                       run pi-verifica-tipo-aprov-fam.
                       if return-value = "NOK":U and not l-pri-aprov-ant then 
                           run pi-verifica-tipo-aprov-doc.
                   end.
               end.
               
           end.
           else if mla-tipo-doc-aprov.prioridade-aprov = 2 then do: /* Inicio validaá∆o por item/familia/documento */
               
               run pi-verifica-tipo-aprov-item.
               if return-value = "NOK":U and not l-pri-aprov-ant then do:

                   run pi-verifica-tipo-aprov-fam.
                   if return-value = "NOK":U and not l-pri-aprov-ant then 
                       run pi-verifica-tipo-aprov-doc.
               end.
               
           end.
           else if  mla-tipo-doc-aprov.prioridade-aprov = 1 then do: /* Inicio da validaá∆o por documento */
               run pi-verifica-tipo-aprov-doc.
           end.
        end.
    end.

    ASSIGN gi-prox-prior = i-prioridade.

    LOG-MANAGER:WRITE-MESSAGE (">>> Tipo aprov: " + STRING(i-cod-aprov)      ) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> Prioridade: " + STRING(i-prioridade)     ) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> Documento : " + STRING(l-tipo-aprov-doc) ) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> Item      : " + STRING(l-tipo-aprov-item)) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> Familia   : " + STRING(l-tipo-aprov-fam) ) NO-ERROR.
    LOG-MANAGER:WRITE-MESSAGE (">>> Referencia: " + STRING(l-tipo-aprov-ref) ) NO-ERROR.
                
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUsuario DBOProgram 
PROCEDURE setUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN c-usuario-aed = c-cod-usuar-trans
           l-mestre      = NO.                  
                  
    FIND FIRST mla-usuar-aprov NO-LOCK
         WHERE mla-usuar-aprov.cod-usuar = c-usuario-aed NO-ERROR.
    IF AVAIL mla-usuar-aprov THEN DO:
        ASSIGN l-mestre = mla-usuar-aprov.usuar-mestre.
    END.

    IF  NOT l-mestre THEN DO:
        FIND FIRST mla-param-aprov NO-LOCK
             WHERE mla-param-aprov.ep-codigo   = i-ep-codigo
               AND mla-param-aprov.cod-estabel = c-cod-estabel NO-ERROR.
        IF AVAIL mla-param-aprov THEN DO:
            IF  mla-param-aprov.int-1 = 1 THEN
                ASSIGN c-usuario-aed = c-cod-usuar-trans.
            ELSE
                ASSIGN c-usuario-aed = c-cod-usuar-doc.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatePend DBOProgram 
PROCEDURE validatePend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cod-tip-doc AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER p-tipo-trans  AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER p-motivo      AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER p-valor       AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER p-moeda       AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER p-usuar-trans AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER p-usuar-doc   AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER p-lotacao-doc AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER p-item        AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER p-referencia  AS CHAR    NO-UNDO.
    DEFINE INPUT  PARAMETER p-ep-codigo   LIKE empresa.ep-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-mla-chave.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    ASSIGN i-cod-tip-doc     = p-cod-tip-doc
           i-tipo-trans      = p-tipo-trans
           c-motivo-aprov    = p-motivo
           de-valor-aprov    = p-valor
           i-moeda           = p-moeda
           c-cod-usuar-trans = p-usuar-trans
           c-cod-usuar-doc   = p-usuar-doc
           c-cod-lotacao-doc = p-lotacao-doc
           c-it-codigo       = p-item
           c-cod-referencia  = p-referencia
           i-ep-codigo       = p-ep-codigo
           c-cod-estabel     = p-cod-estabel.

    RUN pi-gerar-dados-extrato (INPUT "boin767b: validatePend " + STRING(p-cod-tip-doc) + " | " + STRING(p-tipo-trans) + " | " + String(p-usuar-doc) + " | " + STRING(p-lotacao-doc)).              

    /*RUN initializeBO IN THIS-PROCEDURE.*/
    /**  ParÉmetros
    **/
    FIND FIRST mla-param-aprov NO-LOCK
         WHERE mla-param-aprov.ep-codigo   = i-ep-codigo
           AND mla-param-aprov.cod-estabel = c-cod-estabel NO-ERROR.
    IF  NOT AVAIL mla-param-aprov THEN
        RUN errorValidate IN THIS-PROCEDURE (56,"ParÉmetros_da_Aprovaá∆o").
    
    /**  Tipo de Documento
    **/
    FIND FIRST mla-tipo-doc-aprov NO-LOCK
         WHERE mla-tipo-doc-aprov.ep-codigo   = i-ep-codigo             /*Empresa*/         
           AND mla-tipo-doc-aprov.cod-estabel = c-cod-estabel           /*Estabelecimento*/ 
           AND mla-tipo-doc-aprov.cod-tip-doc = i-cod-tip-doc NO-ERROR. /*Documento*/       
    IF  NOT AVAIL mla-tipo-doc-aprov  OR 
        NOT mla-tipo-doc-aprov.apr-tip-doc THEN
        RUN errorValidate IN THIS-PROCEDURE (56,"Tipo_de_Documento").
    
    /**   Chave do Documento
    **/
    FIND FIRST tt-mla-chave NO-LOCK NO-ERROR.
    ASSIGN p-cod-tip-doc = i-cod-tip-doc
           i-chave       = 0.
    {lap/mlachave.i}
    IF  NOT AVAILABLE tt-mla-chave OR
        c-chave = "" THEN
        RUN errorValidate IN THIS-PROCEDURE (56,"Chave_de_Documento").

    /**   Usu†rios
    **/
    FIND FIRST mla-usuar-aprov NO-LOCK
         WHERE mla-usuar-aprov.cod-usuar = c-cod-usuar-trans NO-ERROR.
    IF  NOT AVAIL mla-usuar-aprov THEN
        RUN errorValidate IN THIS-PROCEDURE (56,"Usu†rio_Transaá∆o").

    FIND FIRST mla-usuar-aprov NO-LOCK
         WHERE mla-usuar-aprov.cod-usuar = c-cod-usuar-doc NO-ERROR.
    IF  NOT AVAIL mla-usuar-aprov THEN
        RUN errorValidate IN THIS-PROCEDURE (56,"Usu†rio_Documento").

    /**  mlaapi173
    **/

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

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
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaTamanhoEmail DBOProgram 
PROCEDURE verificaTamanhoEmail:
/* -----------------------------------------------------------
  Purpose: Validar se o tamanho do e-mail ultrapassa 32k.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VARIABLE i-tamanho-msg     AS INTEGER     NO-UNDO.

    IF NOT l-anexar-conteudo THEN DO:
        FOR EACH tt-mensagem:
            ASSIGN i-tamanho-msg = i-tamanho-msg + LENGTH(tt-mensagem.mensagem).
        END.

        IF i-tamanho-msg > 32000 THEN DO:
            ASSIGN l-anexar-conteudo = YES.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEpcGeraPend DBOProgram 
PROCEDURE setEpcGeraPend :
/*------------------------------------------------------------------------------
  Purpose: Ponto EPC apÛs geraÁ„o da pendÍncia    
  Parameters:  p-nr-trans (INPUT - Integer) - N˙mero da transaÁ„o
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nr-trans    AS INTEGER NO-UNDO.

    if c-nom-prog-upc-mg97  <> "" or 
       c-nom-prog-appc-mg97 <> "" or 
       c-nom-prog-dpc-mg97  <> "" then do:

       EMPTY TEMP-TABLE tt-epc.

       create tt-epc.
       assign tt-epc.cod-event     = "afterGeraPend":U
              tt-epc.cod-parameter = "nr-trans":U
              tt-epc.val-parameter = STRING(p-nr-trans).

       create tt-epc.
       assign tt-epc.cod-event     = "afterGeraPend":U
              tt-epc.cod-parameter = "this-procedure":U
              tt-epc.val-parameter = STRING(THIS-PROCEDURE).
    
       {include/i-epc201.i "afterGeraPend"}
    
    end.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

