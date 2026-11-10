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
{include/i-prgvrs.i BOIN784 2.00.00.018 } /*** "010018" 07/02/2024 11:19:51  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin784 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : BOIN784.P
    Purpose    : L¢gica de neg¢cio e acesso a dados para a tabela mla-tipo-doc-aprov
    Parameters : 
    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

&GLOBAL-DEFINE DBOName boin784
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-tipo-doc-aprov
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*Pre-processadores para acelerador de implantaá∆o*/
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

DEFINE VARIABLE iTipDoc            AS   INTEGER           NO-UNDO.
DEFINE VARIABLE cEpCodigo          AS   CHARACTER         NO-UNDO.
DEFINE VARIABLE cCodEstabel        AS   CHARACTER         NO-UNDO.
DEFINE VARIABLE i-ep-codigo        LIKE empresa.ep-codigo NO-UNDO.
DEFINE VARIABLE c-msg              AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-lb-sim           AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-lb-nao           AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-chave-doc        AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-log-reg          AS CHARACTER           NO-UNDO.
DEFINE VARIABLE h-boin769          AS HANDLE              NO-UNDO.
DEFINE VARIABLE r-rowid-log        AS ROWID               NO-UNDO. 
DEFINE VARIABLE c-cod-proces-fluig AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-msg2             AS CHARACTER           NO-UNDO.

DEFINE TEMP-TABLE tt-estabelec-mla0122 NO-UNDO
    FIELD selecionado      AS LOGICAL format "*/ ":U
    FIELD reg-existente    AS LOGICAL 
    FIELD ep-codigo        LIKE empresa.ep-codigo
    FIELD cod-estabel      LIKE estabelec.cod-estabel
    FIELD nome             LIKE estabelec.nome
    FIELD r-rowid          AS   ROWID.

DEFINE TEMP-TABLE tt-mla-tipo-doc-aprov-mla0122 NO-UNDO LIKE mla-tipo-doc-aprov 
    FIELD selecionado       AS LOGICAL FORMAT "*/ ":U
    FIELD doc-existente     AS LOGICAL
    FIELD doc-padrao        AS LOGICAL
    FIELD doc-exportado     AS LOGICAL
    FIELD aprovacao         LIKE mla-tipo-doc-aprov.log-1         INITIAL NO
    FIELD apr-usu-transacao LIKE mla-tipo-doc-aprov.log-1         INITIAL NO
    FIELD apr-usu-documento LIKE mla-tipo-doc-aprov.log-1         INITIAL NO
    FIELD apr-aprovadores   LIKE mla-tipo-doc-aprov.log-1         INITIAL NO
    FIELD apr-Informado     LIKE mla-tipo-doc-aprov.log-1         INITIAL NO
    FIELD rejeicao          LIKE mla-tipo-doc-aprov.log-1         INITIAL NO
    FIELD rej-usu-transacao LIKE mla-tipo-doc-aprov.log-1         INITIAL NO
    FIELD rej-usu-documento LIKE mla-tipo-doc-aprov.log-1         INITIAL NO
    FIELD rej-aprovadores   LIKE mla-tipo-doc-aprov.log-1         INITIAL NO
    FIELD rej-Informado     LIKE mla-tipo-doc-aprov.log-1         INITIAL NO.

{utp/ut-liter.i "Sim" *}
ASSIGN c-lb-sim = RETURN-VALUE.

{utp/ut-liter.i "N∆o" *}
ASSIGN c-lb-nao = RETURN-VALUE.


/*:T--- Include com definiá∆o da temptable RowObject ---*/
{inbo/boin784.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
{method/dboqry.i}
{utp/ut-glob.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
         HEIGHT             = 2.21
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U                   THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U                   THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "char-3":U                   THEN ASSIGN pFieldValue = RowObject.char-3.
        WHEN "char-4":U                   THEN ASSIGN pFieldValue = RowObject.char-4.
        WHEN "char-5":U                   THEN ASSIGN pFieldValue = RowObject.char-5.
        WHEN "cod-estabel":U              THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "des-tip-doc":U              THEN ASSIGN pFieldValue = RowObject.des-tip-doc.
        WHEN "prog-aprova":U              THEN ASSIGN pFieldValue = RowObject.prog-aprova.
        WHEN "prog-consulta":U            THEN ASSIGN pFieldValue = RowObject.prog-consulta.
        WHEN "prog-rejeita":U             THEN ASSIGN pFieldValue = RowObject.prog-rejeita.
        WHEN "cod-proces":U               THEN ASSIGN pFieldValue = RowObject.cod-proces.
        WHEN "hra-execucao":U             THEN ASSIGN pFieldValue = RowObject.hra-execucao.
        WHEN "hra-exec-priorid-baixa":U   THEN ASSIGN pFieldValue = RowObject.hra-exec-priorid-baixa.
        WHEN "hra-exec-priorid-media":U   THEN ASSIGN pFieldValue = RowObject.hra-exec-priorid-media.
        WHEN "hra-exec-priorid-alta":U    THEN ASSIGN pFieldValue = RowObject.hra-exec-priorid-alta.
        WHEN "hra-exec-priorid-altssmo":U THEN ASSIGN pFieldValue = RowObject.hra-exec-priorid-altssmo.
        WHEN "ep-codigo":U                THEN ASSIGN pFieldValue = RowObject.ep-codigo.
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
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-3":U THEN ASSIGN pFieldValue = RowObject.data-3.
        WHEN "data-4":U THEN ASSIGN pFieldValue = RowObject.data-4.
        WHEN "data-5":U THEN ASSIGN pFieldValue = RowObject.data-5.
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
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "dec-3":U THEN ASSIGN pFieldValue = RowObject.dec-3.
        WHEN "dec-4":U THEN ASSIGN pFieldValue = RowObject.dec-4.
        WHEN "dec-5":U THEN ASSIGN pFieldValue = RowObject.dec-5.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-tip-doc":U      THEN ASSIGN pFieldValue = RowObject.cod-tip-doc.
        WHEN "int-1":U            THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U            THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "int-3":U            THEN ASSIGN pFieldValue = RowObject.int-3.
        WHEN "int-4":U            THEN ASSIGN pFieldValue = RowObject.int-4.
        WHEN "int-5":U            THEN ASSIGN pFieldValue = RowObject.int-5.
        WHEN "prioridade-aprov":U THEN ASSIGN pFieldValue = RowObject.prioridade-aprov.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice empresa
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-tip-doc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mla-tipo-doc-aprov.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE mla-tipo-doc-aprov.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tip-doc LIKE mla-tipo-doc-aprov.cod-tip-doc NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pcod-tip-doc = RowObject.cod-tip-doc.

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
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "apr-tip-doc":U      THEN ASSIGN pFieldValue = RowObject.apr-tip-doc.
        WHEN "log-1":U            THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U            THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-3":U            THEN ASSIGN pFieldValue = RowObject.log-3.
        WHEN "log-4":U            THEN ASSIGN pFieldValue = RowObject.log-4.
        WHEN "log-5":U            THEN ASSIGN pFieldValue = RowObject.log-5.
        WHEN "log-html":U         THEN ASSIGN pFieldValue = RowObject.log-html.
        WHEN "verba-aprov":U      THEN ASSIGN pFieldValue = RowObject.verba-aprov.
        WHEN "log-excec-val":U    THEN ASSIGN pFieldValue = RowObject.log-excec-val.
        WHEN "log-integr-fluig":U THEN ASSIGN pFieldValue = RowObject.log-integr-fluig.
        WHEN "log-praz-conclus":U THEN ASSIGN pFieldValue = RowObject.log-praz-conclus.
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
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

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
  Purpose:     Reposiciona registro com base no °ndice empresa
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-tip-doc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-tipo-doc-aprov.cod-tip-doc NO-UNDO.

    FIND FIRST bfmla-tipo-doc-aprov
         WHERE bfmla-tipo-doc-aprov.cod-tip-doc = pcod-tip-doc NO-LOCK NO-ERROR.

    IF NOT AVAILABLE bfmla-tipo-doc-aprov THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-tipo-doc-aprov)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyEmpEstab DBOProgram 
PROCEDURE goToKeyEmpEstab :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice empresa
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-tip-doc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo   LIKE mla-tipo-doc-aprov.ep-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE mla-tipo-doc-aprov.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-tipo-doc-aprov.cod-tip-doc NO-UNDO.

    FIND FIRST bfmla-tipo-doc-aprov
         WHERE bfmla-tipo-doc-aprov.cod-tip-doc = pcod-tip-doc
           AND bfmla-tipo-doc-aprov.ep-codigo   = pep-codigo
           AND bfmla-tipo-doc-aprov.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-tipo-doc-aprov THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-tipo-doc-aprov)).
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
    DEF INPUT PARAMETER p-ordem AS CHAR NO-UNDO.

    RUN openQueryStatic (input "Main":U). 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDoc DBOProgram 
PROCEDURE openQueryDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} 
        FOR EACH {&TABLENAME} 
            WHERE {&TABLENAME}.cod-tip-doc = iTipDoc NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmpEstabAprovacao DBOProgram 
PROCEDURE openQueryEmpEstabAprovacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} 
        FOR EACH {&TABLENAME} 
           WHERE {&TABLENAME}.ep-codigo   = cEpCodigo
             AND {&TABLENAME}.cod-estabel = cCodEstabel
             AND {&TABLENAME}.apr-tip-doc
         NO-LOCK INDEXED-REPOSITION.

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
    OPEN QUERY {&QUERYNAME} 
        FOR EACH {&TABLENAME} 
                 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-doctos-padroes DBOProgram 
PROCEDURE pi-cria-doctos-padroes :
/*------------------------------------------------------------------------------
  Purpose:     Cria documentos padroes em uma tabela temporaria para carregar 
               no browser "Documentos" do MLA0122 para possibiliar ao usuario
               selecionar quais documentos deseja que sejam gerados no MLA0101
  Parameters:  (Entrada) Empresa da linha selecionada no folder "Estab" do MLA0122
               (Entrada) Estabelecimento da linha selecionada no folder "Estab" do MLA0122
               (Entrada) Codigo do Tipo do documento padrao
               (Entrada) Descriá∆o do documento padrao
               (Entrada) Programa de aprovaá∆o
               (Entrada) Programa de rejeiá∆o
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo      LIKE mla-tipo-doc-aprov.ep-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel   LIKE mla-tipo-doc-aprov.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-tip-doc  LIKE mla-tipo-doc-aprov.cod-tip-doc  NO-UNDO.
    DEFINE INPUT PARAMETER pc-desc-tip-doc LIKE mla-tipo-doc-aprov.des-tip-doc  NO-UNDO.
    DEFINE INPUT PARAMETER pc-prog-aprova  LIKE mla-tipo-doc-aprov.prog-aprova  NO-UNDO.
    DEFINE INPUT PARAMETER pc-prog-rejeita LIKE mla-tipo-doc-aprov.prog-rejeita NO-UNDO.

    CREATE tt-mla-tipo-doc-aprov-mla0122.
    ASSIGN tt-mla-tipo-doc-aprov-mla0122.ep-codigo          = pep-codigo     
           tt-mla-tipo-doc-aprov-mla0122.cod-estabel        = p-cod-estabel 
           tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc        = pi-cod-tip-doc 
           tt-mla-tipo-doc-aprov-mla0122.des-tip-doc        = pc-desc-tip-doc
           tt-mla-tipo-doc-aprov-mla0122.prog-aprova        = pc-prog-aprova 
           tt-mla-tipo-doc-aprov-mla0122.prog-rejeita       = pc-prog-rejeita
           tt-mla-tipo-doc-aprov-mla0122.selecionado        = NO
           tt-mla-tipo-doc-aprov-mla0122.doc-existente      = NO
           tt-mla-tipo-doc-aprov-mla0122.doc-padrao         = YES
           tt-mla-tipo-doc-aprov-mla0122.doc-exportado      = NO

           tt-mla-tipo-doc-aprov-mla0122.apr-tip-doc        = NO
           tt-mla-tipo-doc-aprov-mla0122.prioridade-aprov   = 1
           tt-mla-tipo-doc-aprov-mla0122.verba-aprov        = NO
           tt-mla-tipo-doc-aprov-mla0122.log-html           = NO
           tt-mla-tipo-doc-aprov-mla0122.log-1              = NO
           tt-mla-tipo-doc-aprov-mla0122.log-2              = NO
           tt-mla-tipo-doc-aprov-mla0122.log-4              = NO
           tt-mla-tipo-doc-aprov-mla0122.aprovacao          = NO
           tt-mla-tipo-doc-aprov-mla0122.apr-usu-transacao  = NO
           tt-mla-tipo-doc-aprov-mla0122.apr-usu-documento  = NO
           tt-mla-tipo-doc-aprov-mla0122.apr-aprovadores    = NO
           tt-mla-tipo-doc-aprov-mla0122.apr-Informado      = NO
           tt-mla-tipo-doc-aprov-mla0122.rejeicao           = NO
           tt-mla-tipo-doc-aprov-mla0122.rej-usu-transacao  = NO
           tt-mla-tipo-doc-aprov-mla0122.rej-usu-documento  = NO
           tt-mla-tipo-doc-aprov-mla0122.rej-aprovadores    = NO
           tt-mla-tipo-doc-aprov-mla0122.rej-Informado      = NO
           tt-mla-tipo-doc-aprov-mla0122.log-excec-val      = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-doc-utiliz-prior DBOProgram 
PROCEDURE pi-doc-utiliz-prior :
/*:T------------------------------------------------------------------------------
  Purpose:     Indica se o documento utiliza prioridade de aprovaá∆o
  Parameters:  pc-cod-empresa  - input  - C¢digo da empresa   
               pc-cod-estabel  - input  - C¢digo do estabelecimento
               pi-cod-tip-doc  - input  - C¢digo do documento
               pl-utiliz-prior - output  - utiliza prioridade
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-empresa  LIKE mla-tipo-doc-aprov.ep-codigo   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-estabel  LIKE mla-tipo-doc-aprov.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-tip-doc  LIKE mla-tipo-doc-aprov.cod-tip-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-utiliz-prior     AS LOGICAL INIT NO              NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-prior-habilitada AS LOGICAL INIT NO              NO-UNDO.

    FOR FIRST mla-param-aprov FIELDS(log-priorid-aprova-docto) NO-LOCK
        WHERE mla-param-aprov.ep-codigo   = pc-cod-empresa
          AND mla-param-aprov.cod-estabel = pc-cod-estabel:
        ASSIGN pl-prior-habilitada = mla-param-aprov.log-priorid-aprova-docto.
    END.
    ASSIGN pl-utiliz-prior = (pi-cod-tip-doc = 1 OR /*Solicitaá∆o de Compra - Item*/
                              pi-cod-tip-doc = 3 OR /*Requisiá∆o de Estoque - Item*/
                              pi-cod-tip-doc = 5 OR /*Cotaá∆o de Materiais*/
                              pi-cod-tip-doc = 6 OR /*Pedido de Compra - Item*/
                              pi-cod-tip-doc = 14 OR /*Mediá∆o de Contratos - Item*/
                              pi-cod-tip-doc = 16 OR /*Eventos do Contrato - Item*/
                              pi-cod-tip-doc = 18 OR /*Solicitaá∆o de Cotaá∆o - Item*/
                              pi-cod-tip-doc = 19). /*Pedido Emergencial - Item*/ 
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-permite-doc-fluig DBOProgram 
PROCEDURE pi-permite-doc-fluig :
/*------------------------------------------------------------------------------
  Purpose:     Indica se Ç permitido integrar o documento com o Fluig, ou seja,
               se o documento foi tratado para a integraá∆o. Retorna "NOK" se n∆o possuir tratamento
  Parameters:  pi-cod-tip-doc  - input  - C¢digo do documento
  Notes:       A MEDIDA QUE OS DOCUMENTOS FOREM TRATADOS PARA INTEGRAÄ«O DEVEM SER RETIRADOS DESSA VALIDAÄ«O.
               ESSE MêTODO E SUAS CHAMADAS DEVER«O SER ELIMINADOS QUANDO TODOS OS DOCUMENTOS FOREM 
               TRATADOS PARA INTEGRAÄ«O COM O FLUIG
------------------------------------------------------------------------------*/

    {inbo/boin784.m01}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-replica-integracao-fluig DBOProgram 
PROCEDURE pi-replica-integracao-fluig :
/*:T------------------------------------------------------------------------------
  Purpose:     Replica informaá‰es de integraá∆o do fluig dos parametros de 
               aprovaá∆o para os documentos do estabelecimento
  Parameters:  pc-cod-empresa  - C¢digo da empresa   
               pc-cod-estabel  - C¢digo do estabelecimento   
               pl-integra-fluig - Integra com o Fluig  
               pl-util-prazo-concl - Utiliza prazo de conclus∆o
               pc-horas-conclusao  - Horas para conclus∆o do prazo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-empresa      LIKE mla-tipo-doc-aprov.ep-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel      LIKE mla-tipo-doc-aprov.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pl-integra-fluig    AS LOGICAL   NO-UNDO.
    DEFINE INPUT PARAMETER pl-util-prazo-concl AS LOGICAL   NO-UNDO.
    DEFINE INPUT PARAMETER pc-horas-conclusao  AS CHARACTER NO-UNDO.

    IF NOT VALID-HANDLE(h-boin769) THEN
        RUN inbo/boin769 PERSISTENT SET h-boin769.

    
    FOR EACH mla-tipo-doc-aprov FIELDS(cod-tip-doc log-integr-fluig log-praz-conclus hra-execucao) EXCLUSIVE-LOCK
        WHERE mla-tipo-doc-aprov.ep-codigo   = pc-cod-empresa
          AND mla-tipo-doc-aprov.cod-estabel = pc-cod-estabel:

        assign c-log-reg = "".
        /*Documento foi tratado para integraá∆o com Fluig?*/
        RUN pi-permite-doc-fluig(INPUT mla-tipo-doc-aprov.cod-tip-doc).
        IF RETURN-VALUE = "NOK":U THEN NEXT.

        IF mla-tipo-doc-aprov.log-integr-fluig <> pl-integra-fluig THEN DO:
            {utp/ut-field.i mgind mla-tipo-doc-aprov log-integr-fluig 1}
            ASSIGN c-log-reg = c-log-reg + 
                   RETURN-VALUE + " : " + (IF mla-tipo-doc-aprov.log-integr-fluig THEN c-lb-sim ELSE c-lb-nao) + chr(13) +
                   "                : " + (IF pl-integra-fluig THEN c-lb-sim ELSE c-lb-nao) + chr(13) + chr(13).
        END.

        IF pl-integra-fluig THEN DO:
            IF mla-tipo-doc-aprov.log-praz-conclus <> pl-util-prazo-concl THEN DO:
                {utp/ut-field.i mgind mla-tipo-doc-aprov log-praz-conclus 1}
                ASSIGN c-log-reg = c-log-reg + 
                       RETURN-VALUE + " : " + (IF mla-tipo-doc-aprov.log-praz-conclus THEN c-lb-sim ELSE c-lb-nao) + chr(13) +
                       "                : " + (IF pl-util-prazo-concl THEN c-lb-sim ELSE c-lb-nao) + chr(13) + chr(13).
            END.
            IF mla-tipo-doc-aprov.hra-execucao <> pc-horas-conclusao THEN DO:
                {utp/ut-field.i mgind mla-tipo-doc-aprov hra-execucao 1}
                ASSIGN c-log-reg = c-log-reg + 
                       RETURN-VALUE + " : " + STRING(mla-tipo-doc-aprov.hra-execucao,"999:99") + chr(13) +
                       "                : " + STRING(pc-horas-conclusao,"999:99") + chr(13) + chr(13).
            END.

            IF mla-tipo-doc-aprov.cod-proces = "" THEN DO:
                ASSIGN c-cod-proces-fluig = "WFMLA" + FILL("0", 3 - LENGTH(STRING(mla-tipo-doc-aprov.cod-tip-doc))) + STRING(mla-tipo-doc-aprov.cod-tip-doc).
                {utp/ut-field.i mgind mla-tipo-doc-aprov cod-proces 1}
                ASSIGN c-log-reg = c-log-reg + 
                       RETURN-VALUE + " : " + mla-tipo-doc-aprov.cod-proces + chr(13) +
                       "                : " + c-cod-proces-fluig + chr(13) + chr(13).
                ASSIGN mla-tipo-doc-aprov.cod-proces = c-cod-proces-fluig.
            END.

            ASSIGN mla-tipo-doc-aprov.log-integr-fluig = pl-integra-fluig
                   mla-tipo-doc-aprov.log-praz-conclus = pl-util-prazo-concl
                   mla-tipo-doc-aprov.hra-execucao     = pc-horas-conclusao.
        END.
        ELSE DO:
            ASSIGN mla-tipo-doc-aprov.log-integr-fluig = pl-integra-fluig.
        END.
        
        IF c-log-reg <> "" THEN DO:
            /*Grava registro de log de transaá∆o*/
            RUN pi-gera-log-2 IN h-boin769(INPUT 22,
                                           INPUT ROWID(mla-tipo-doc-aprov),
                                           INPUT 2,
                                           INPUT entry(22,{ininc/i03in030.i 03}) + chr(13) + chr(13) + c-log-reg,
                                           OUTPUT r-rowid-log).
        END.
    END.

    IF VALID-HANDLE(h-boin769) THEN DO:
        DELETE PROCEDURE h-boin769.
        ASSIGN h-boin769 = ?.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-doctos DBOProgram 
PROCEDURE pi-retorna-doctos :
/*------------------------------------------------------------------------------
  Purpose:     Retorna para o programa MLA0122, folder "Documentos", os documentos 
               ja existentes no MLA0101. Se houver algum documento padrao que ainda
               nao esta configurado no MLA0101, cria na tabela temporario para 
               permitir ao usuario selecionar no MLA0122 para criacao com os dados
               padroes (codigo do tipo do documento, descricao, programa de aprovacao e rejeicao)
  Parameters:  (Entrada) Empresa da linha selecionada no folder "Estab" do MLA0122
               (Entrada) Estabelecimento da linha selecionada no folder "Estab" do MLA0122
               (Saida) temp-table contendo os documentos ja cadastrados no MLA0101 mais os
               documentos padroes que ainda nao foram criados no MLA0101
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-ep-codigo     LIKE mla-tipo-doc-aprov.ep-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel   LIKE mla-tipo-doc-aprov.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-mla-tipo-doc-aprov-mla0122.

    DEFINE VARIABLE c-des-tip-doc LIKE mla-tipo-doc-aprov.des-tip-doc NO-UNDO.

    FOR EACH tt-mla-tipo-doc-aprov-mla0122:
        DELETE tt-mla-tipo-doc-aprov-mla0122.
    END.

    FOR EACH mla-tipo-doc-aprov
       WHERE mla-tipo-doc-aprov.ep-codigo   = p-ep-codigo 
         AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel NO-LOCK:

        FIND FIRST tt-mla-tipo-doc-aprov-mla0122
             WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = mla-tipo-doc-aprov.ep-codigo 
               AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = mla-tipo-doc-aprov.cod-estabel
               AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = mla-tipo-doc-aprov.cod-tip-doc NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-mla-tipo-doc-aprov-mla0122 THEN DO:
            CREATE tt-mla-tipo-doc-aprov-mla0122.
            BUFFER-COPY mla-tipo-doc-aprov TO tt-mla-tipo-doc-aprov-mla0122.
            ASSIGN tt-mla-tipo-doc-aprov-mla0122.selecionado        =  NO
                   tt-mla-tipo-doc-aprov-mla0122.doc-existente      =  YES.

            IF tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 1  
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 2  
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 3  
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 4  
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 5  
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 6  
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 7  
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 8  
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 9  
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 10 
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 13 
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 14 
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 16
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 18
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 19
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 20
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 21
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 24
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 25
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 26
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 28
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 29
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 30
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 31
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 32
            OR tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 33 THEN
                ASSIGN tt-mla-tipo-doc-aprov-mla0122.doc-padrao = YES.

        END.                                      
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 1) THEN DO:
        {utp/ut-liter.i "Solicitaá∆o_de_Compra_-_Item" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo,
                                    INPUT p-cod-estabel,
                                    INPUT 1,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla001e.r":U,
                                    INPUT "":U).
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 2) THEN DO:
        {utp/ut-liter.i "Solicitaá∆o_de_Compra_-_Total" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 2,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla001e.r":U,
                                    INPUT "":U).
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 3) THEN DO:
        {utp/ut-liter.i "Requisiá∆o_de_Estoques_-_Item" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 3,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla001e.r":U,
                                    INPUT "":U).
    END.
        
    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 4) THEN DO:
        {utp/ut-liter.i "Requisiá∆o_de_Estoques_-_Total" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 4,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla001e.r":U,
                                    INPUT "":U).
    END.
        
    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 5) THEN DO:
        {utp/ut-liter.i "Cotaá∆o_de_Materiais" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 5,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla005e.r":U,
                                    INPUT "":U).
    END.
        
    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 6) THEN DO:
        {utp/ut-liter.i "Pedido_de_Compra_-_Item" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 6,
                                    INPUT c-des-tip-doc,
                                    INPUT "":U,
                                    INPUT "":U).
    END.
        
    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 7) THEN DO:
        {utp/ut-liter.i "Pedido_de_Compra_-_Total" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 7,
                                    INPUT c-des-tip-doc,
                                    INPUT "":U,
                                    INPUT "":U).
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 8) THEN DO:
        {utp/ut-liter.i "Pedido_Emergencial_-_Total" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 8,
                                    INPUT c-des-tip-doc,
                                    INPUT "":U,
                                    INPUT "":U).
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 9) THEN DO:
        {utp/ut-liter.i "Processo_de_Compra_-_Item" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 9,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla009e.r":U,
                                    INPUT "").
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 10) THEN DO:
        {utp/ut-liter.i "Processo_de_Compra_-_Total" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 10,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla010e.r":U,
                                    INPUT "").
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 13) THEN DO:
        {utp/ut-liter.i "Contrato_de_Compras" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 13,
                                    INPUT c-des-tip-doc,
                                    INPUT "",
                                    INPUT "").
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 14) THEN DO:
        {utp/ut-liter.i "Mediá∆o_do_Contrato_-_Item" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 14,
                                    INPUT c-des-tip-doc,
                                    INPUT "",
                                    INPUT "").
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 16) THEN DO:
        {utp/ut-liter.i "Evento_do_Contrato_-_Item" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 16,
                                    INPUT c-des-tip-doc,
                                    INPUT "",
                                    INPUT "").
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 18) THEN DO:
        {utp/ut-liter.i "Solicitaá∆o_de_Cotaá∆o_-_Item" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 18,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla018e.r":U,
                                    INPUT "":U).
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 19) THEN DO:
        {utp/ut-liter.i "Pedido_Emergencial_-_Item" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 19,
                                    INPUT c-des-tip-doc,
                                    INPUT "",
                                    INPUT "").
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 20) THEN DO:
        {utp/ut-liter.i "Solicitaá∆o_de_Serviáo" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 20,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla020e.r":U,
                                    INPUT "":U).
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 21) THEN DO:
        {utp/ut-liter.i "Avaliaá∆o_de_CrÇdito" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 21,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla021e.r":U,
                                    INPUT "":U).
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 24) THEN DO:
        {utp/ut-liter.i "Documento_Normal" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 24,
                                    INPUT c-des-tip-doc,
                                    INPUT "afp/af0124a.r":U,
                                    INPUT "":U).
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 25) THEN DO:
        {utp/ut-liter.i "Antecipaá∆o" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 25,
                                    INPUT c-des-tip-doc,
                                    INPUT "afp/af0125a.r":U,
                                    INPUT "afp/af0125b.r":U).
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 26) THEN DO:
        {utp/ut-liter.i "PEF_-_Pagamento_extra-fornecedor" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 26,
                                    INPUT c-des-tip-doc,
                                    INPUT "afp/af0126a.r":U,
                                    INPUT "afp/af0126b.r":U).
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 28) THEN DO:
        {utp/ut-liter.i "Pagamento" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 28,
                                    INPUT c-des-tip-doc,
                                    INPUT "afp/af0128a.r":U,
                                    INPUT "afp/af0128b.r").
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 29) THEN DO:
        {utp/ut-liter.i "Negociaá∆o_de_Fretes" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 29,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla029e.r",
                                    INPUT "lapepc/mla029e.r").
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 30) THEN DO:
        {utp/ut-liter.i "Documento_de_Fretes" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 30,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla030.r",
                                    INPUT "lapepc/mla030.r").
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 31) THEN DO:
        {utp/ut-liter.i "Fatura_de_Fretes" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 31,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla031.r",
                                    INPUT "lapepc/mla031.r").
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 32) THEN DO:
        {utp/ut-liter.i "Originaá∆o_-_Adiantamento_Valor" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 32,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla032.r",
                                    INPUT "lapepc/mla032.r").
    END.

    IF NOT CAN-FIND(FIRST tt-mla-tipo-doc-aprov-mla0122
                    WHERE tt-mla-tipo-doc-aprov-mla0122.ep-codigo   = p-ep-codigo 
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-estabel = p-cod-estabel
                      AND tt-mla-tipo-doc-aprov-mla0122.cod-tip-doc = 33) THEN DO:
        {utp/ut-liter.i "Originaá∆o_-_Fechamento_Financeiro" *}
        ASSIGN c-des-tip-doc = RETURN-VALUE.
        RUN pi-cria-doctos-padroes (INPUT p-ep-codigo, 
                                    INPUT p-cod-estabel,
                                    INPUT 33,
                                    INPUT c-des-tip-doc,
                                    INPUT "lapepc/mla033.r",
                                    INPUT "lapepc/mla033.r").
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-estabel DBOProgram 
PROCEDURE pi-retorna-estabel :
/*------------------------------------------------------------------------------
  Purpose:     Retornar os estabelecimentos que ja possuem tipos de documento 
               parametrizados no MLA0101 para o folder "Estabelec" do programa MLA0122
  Parameters:  (Entrada) Empresa do usu†rio que encontra-se logado no sistema OU
                         Empresa trocada no MLA0122 via bot∆o "Troca Empresa"
                (Saida) Tabela de estabelecimentos que j† possuem configuraá‰es no MLA0101
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-empresa LIKE empresa.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-estabelec-mla0122.

    FOR EACH tt-estabelec-mla0122:
        DELETE tt-estabelec-mla0122.
    END.

    FOR EACH mla-tipo-doc-aprov FIELDS(ep-codigo cod-estabel) NO-LOCK
       WHERE mla-tipo-doc-aprov.ep-codigo = pc-empresa:

        FIND FIRST tt-estabelec-mla0122
             WHERE tt-estabelec-mla0122.ep-codigo   = mla-tipo-doc-aprov.ep-codigo
               AND tt-estabelec-mla0122.cod-estabel = mla-tipo-doc-aprov.cod-estabel NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-estabelec-mla0122 THEN DO:
            CREATE tt-estabelec-mla0122.
            ASSIGN tt-estabelec-mla0122.ep-codigo     = mla-tipo-doc-aprov.ep-codigo
                   tt-estabelec-mla0122.cod-estabel   = mla-tipo-doc-aprov.cod-estabel
                   tt-estabelec-mla0122.reg-existente = YES.
            FIND FIRST estabelec
                WHERE estabelec.cod-estabel = tt-estabelec-mla0122.cod-estabel NO-LOCK NO-ERROR.
            IF  AVAIL estabelec THEN
                ASSIGN tt-estabelec-mla0122.nome    = estabelec.nome
                       tt-estabelec-mla0122.r-rowid = ROWID(estabelec).
            ELSE
                ASSIGN tt-estabelec-mla0122.nome = "":U.
        END.
    END.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-hora DBOProgram 
PROCEDURE pi-valida-hora :
/*------------------------------------------------------------------------------
  Purpose:     Valida os campos hora de processamento relacionados ao fluig
  Parameters:  cFieldValue - Valor do campo
               cFieldLabel - R¢tulo do campo
  Notes:       
------------------------------------------------------------------------------*/

    {inbo/boin784.m02}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-estab-integra-fluig DBOProgram 
PROCEDURE pi-verifica-estab-integra-fluig :
/*:T------------------------------------------------------------------------------
  Purpose:     Verifica se o estabelecimento integra com o fluig
  Parameters:  pc-cod-empresa  - input  - C¢digo da empresa   
               pc-cod-estabel  - input  - C¢digo do estabelecimento
               pl-integra      - output  - Estabelecimento integra com o fluig
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-empresa  LIKE mla-tipo-doc-aprov.ep-codigo   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-estabel  LIKE mla-tipo-doc-aprov.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-integra      AS LOGICAL INIT NO                  NO-UNDO.

    FOR FIRST mla-param-aprov FIELDS(log-integr-fluig) NO-LOCK
        WHERE mla-param-aprov.ep-codigo   = pc-cod-empresa
          AND mla-param-aprov.cod-estabel = pc-cod-estabel:
        
        ASSIGN pl-integra = mla-param-aprov.log-integr-fluig.
    END.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDoc DBOProgram 
PROCEDURE setConstraintDoc :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piTipDoc AS INTEGER     NO-UNDO.

    ASSIGN iTipDoc = piTipDoc.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEmpEstabAprovacao DBOProgram 
PROCEDURE setConstraintEmpEstabAprovacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-ep-codigo   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel AS CHARACTER NO-UNDO.

    ASSIGN cEpCodigo   = pc-ep-codigo
           cCodEstabel = pc-cod-estabel.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaDocumentos DBOProgram 
PROCEDURE validaDocumentos :
/*------------------------------------------------------------------------------
  Purpose:  Verifica se o tipo de documento pode ser marcado para aprovaá∆o ou n∆o.
            (Em funá∆o de outros documentos que podem estar ativos ou pendàncias de aprovaá∆o).
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    find first param-aprov no-lock no-error.

    /*** Validaá∆o para setar aprovaá∆o do tipo do documento ***/

    CASE RowObject.cod-tip-doc:
           WHEN 1 THEN DO: /**Solicitaá∆o de Compra - Item**/

               IF  RowObject.apr-tip-doc 
               AND CAN-FIND (FIRST mla-tipo-doc-aprov 
                             WHERE mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo
                               AND mla-tipo-doc-aprov.cod-estabel = RowObject.cod-estabel
                               AND mla-tipo-doc-aprov.cod-tip-doc = 2
                               AND mla-tipo-doc-aprov.apr-tip-doc) THEN DO:
                   
                   ASSIGN c-msg = "".
                   {utp/ut-liter.i Solicitaá∆o_de_Compra_por_Item}
                   ASSIGN c-msg = TRIM(RETURN-VALUE).
                   {utp/ut-liter.i _Solicitaá∆o_de_Compra_por_Total_}
                   ASSIGN c-msg = c-msg + '~~~~' + TRIM(RETURN-VALUE).

                   {method/svc/errors/inserr.i &ErrorNumber="30343"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="c-msg"}
               END.

               IF  RowObject.apr-tip-doc AND AVAIL param-aprov
               AND (param-aprov.aprova-solic = NO OR (param-aprov.aprova-solic = YES AND param-aprov.aprov-total-solic = YES)) then do:

                   {method/svc/errors/inserr.i &ErrorNumber="31003"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters=RowObject.des-tip-doc}
               END.
           END.
           WHEN 2 THEN DO: /**Solicitaá∆o de Compra - Total**/

               IF  RowObject.apr-tip-doc
               AND CAN-FIND (FIRST mla-tipo-doc-aprov
                             WHERE mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo
                               AND mla-tipo-doc-aprov.cod-estabel = RowObject.cod-estabel
                               AND mla-tipo-doc-aprov.cod-tip-doc = 1 
                               AND mla-tipo-doc-aprov.apr-tip-doc) THEN DO:
                   
                   ASSIGN c-msg = "".
                   {utp/ut-liter.i Solicitaá∆o_de_Compra_por_Total}
                   ASSIGN c-msg = TRIM(RETURN-VALUE).
                   {utp/ut-liter.i _Solicitaá∆o_de_Compra_por_Item_}
                   ASSIGN c-msg = c-msg + '~~~~' + TRIM(RETURN-VALUE).

                   {method/svc/errors/inserr.i &ErrorNumber="30343"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="c-msg"}
               END.

               IF  RowObject.apr-tip-doc AND  AVAIL param-aprov
               AND (param-aprov.aprova-solic = NO OR (param-aprov.aprova-solic = YES AND param-aprov.aprov-total-solic = NO)) THEN DO:

                   {method/svc/errors/inserr.i &ErrorNumber="31003"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters=RowObject.des-tip-doc}
               END.
           END.
           WHEN 3 THEN DO: /**Requisiá∆o de Estoque - Item**/
               
               IF  RowObject.apr-tip-doc
               AND CAN-FIND (FIRST mla-tipo-doc-aprov
                             WHERE mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo
                               AND mla-tipo-doc-aprov.cod-estabel = RowObject.cod-estabel
                               AND mla-tipo-doc-aprov.cod-tip-doc = 4
                               AND mla-tipo-doc-aprov.apr-tip-doc) THEN DO:
                   
                   ASSIGN c-msg = "".
                   {utp/ut-liter.i Requisiá∆o_de_Estoque_por_Item}
                   ASSIGN c-msg = TRIM(RETURN-VALUE).
                   {utp/ut-liter.i _Requisiá∆o_de_Estoque_por_Total_}
                   ASSIGN c-msg = c-msg + '~~~~' + TRIM(RETURN-VALUE).

                   {method/svc/errors/inserr.i &ErrorNumber="30343"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="c-msg"}
               END.

               IF   RowObject.apr-tip-doc AND  AVAIL param-aprov
               AND (param-aprov.aprova-requis = NO OR (param-aprov.aprova-requis = YES AND param-aprov.aprov-total-requis = YES)) THEN DO:

                   {method/svc/errors/inserr.i &ErrorNumber="31003"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters=RowObject.des-tip-doc}
               END.
           END.
           WHEN 4 THEN DO: /**Requisiá∆o de Estoque - Total**/ 

               IF  RowObject.apr-tip-doc
               AND CAN-FIND (FIRST mla-tipo-doc-aprov
                             WHERE mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo
                               AND mla-tipo-doc-aprov.cod-estabel = RowObject.cod-estabel
                               AND mla-tipo-doc-aprov.cod-tip-doc = 3
                               AND mla-tipo-doc-aprov.apr-tip-doc) THEN DO:
                   
                   ASSIGN c-msg = "".
                   {utp/ut-liter.i Requisiá∆o_de_Estoque_por_Total}
                   ASSIGN c-msg = TRIM(RETURN-VALUE).
                   {utp/ut-liter.i _Requisiá∆o_de_Estoque_por_Item_}
                   ASSIGN c-msg = c-msg + '~~~~' + TRIM(RETURN-VALUE).

                   {method/svc/errors/inserr.i &ErrorNumber="30343"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="c-msg"}
               END.

               IF   RowObject.apr-tip-doc AND AVAIL param-aprov
               AND (param-aprov.aprova-requis = NO OR (param-aprov.aprova-requis = YES AND param-aprov.aprov-total-requis = NO)) THEN DO:

                   {method/svc/errors/inserr.i &ErrorNumber="31003"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters=RowObject.des-tip-doc}
               END.
           END.
           WHEN 6 THEN DO: /**Pedido de Compra - Item**/ 

               IF  RowObject.apr-tip-doc
               AND CAN-FIND (FIRST mla-tipo-doc-aprov 
                             WHERE mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo
                               AND mla-tipo-doc-aprov.cod-estabel = RowObject.cod-estabel
                               AND mla-tipo-doc-aprov.cod-tip-doc = 7
                               AND mla-tipo-doc-aprov.apr-tip-doc) THEN DO:
                   
                   ASSIGN c-msg = "".
                   {utp/ut-liter.i Pedido_de_Compra_por_Item}
                   ASSIGN c-msg = TRIM(RETURN-VALUE).
                   {utp/ut-liter.i _Pedido_de_Compra_por_Total_}
                   ASSIGN c-msg = c-msg + '~~~~' + TRIM(RETURN-VALUE).

                   {method/svc/errors/inserr.i &ErrorNumber="30343"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="c-msg"}
               END.

               IF   RowObject.apr-tip-doc AND AVAIL param-aprov
               AND (param-aprov.aprova-pedido = NO OR (param-aprov.aprova-pedido = YES AND param-aprov.aprov-total-pedido = YES)) THEN DO:

                   {method/svc/errors/inserr.i &ErrorNumber="31003"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters=RowObject.des-tip-doc}
               END.
           END.
           WHEN 7 THEN DO: /**Pedido de Compra - Total**/

               IF  RowObject.apr-tip-doc
               AND CAN-FIND (FIRST mla-tipo-doc-aprov
                             WHERE mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo
                               AND mla-tipo-doc-aprov.cod-estabel = RowObject.cod-estabel
                               AND mla-tipo-doc-aprov.cod-tip-doc = 6
                               AND mla-tipo-doc-aprov.apr-tip-doc) THEN DO:
                   
                   ASSIGN c-msg = "".
                   {utp/ut-liter.i Pedido_de_Compra_por_Total}
                   ASSIGN c-msg = TRIM(RETURN-VALUE).
                   {utp/ut-liter.i _Pedido_de_Compra_por_Item_}
                   ASSIGN c-msg = c-msg + '~~~~' + TRIM(RETURN-VALUE).
                   
                   {method/svc/errors/inserr.i  &ErrorNumber="30343"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-msg"}
               END.

               IF  RowObject.apr-tip-doc AND AVAIL param-aprov
               AND (param-aprov.aprova-pedido = NO OR (param-aprov.aprova-pedido = YES AND param-aprov.aprov-total-pedido = NO)) THEN DO:

                   {method/svc/errors/inserr.i &ErrorNumber="31003"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters=RowObject.des-tip-doc}
               END.
           END.
           WHEN 8 THEN DO: /**Pedido Emergencial - Total**/
               
               IF  RowObject.apr-tip-doc
               AND CAN-FIND (FIRST mla-tipo-doc-aprov
                             WHERE mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo
                               AND mla-tipo-doc-aprov.cod-estabel = RowObject.cod-estabel
                               AND mla-tipo-doc-aprov.cod-tip-doc = 19
                               AND mla-tipo-doc-aprov.apr-tip-doc) THEN DO:

                     ASSIGN c-msg = "".
                     {utp/ut-liter.i Pedido_Emergencial_por_Total}
                     ASSIGN c-msg = TRIM(RETURN-VALUE).
                     {utp/ut-liter.i _Pedido_Emergencial_por_Item_}
                     ASSIGN c-msg = c-msg + '~~~~' + TRIM(RETURN-VALUE).

                     {method/svc/errors/inserr.i &ErrorNumber="30343"
                                                 &ErrorType="EMS"
                                                 &ErrorSubType="ERROR"
                                                 &ErrorParameters="c-msg"}
               END.

               IF  RowObject.apr-tip-doc AND AVAIL param-aprov
               AND (param-aprov.aprova-emerg = NO OR (param-aprov.aprova-emerg = YES AND param-aprov.aprov-total-pedido = NO)) THEN DO:

                   {method/svc/errors/inserr.i &ErrorNumber="31003"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters=RowObject.des-tip-doc}
               END.
           END.
           WHEN 9 THEN DO: /**Processo de Compras - Item**/
               
               IF  RowObject.apr-tip-doc
               AND CAN-FIND (FIRST mla-tipo-doc-aprov
                             WHERE mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo
                               AND mla-tipo-doc-aprov.cod-estabel = RowObject.cod-estabel
                               AND mla-tipo-doc-aprov.cod-tip-doc = 10
                               AND mla-tipo-doc-aprov.apr-tip-doc) THEN DO:
                   
                   ASSIGN c-msg = "".
                   {utp/ut-liter.i Processo_de_Compra_por_Item}
                   ASSIGN c-msg = TRIM(RETURN-VALUE).
                   {utp/ut-liter.i _Processo_de_Compra_por_Total}
                   ASSIGN c-msg = c-msg + '~~~~' + TRIM(RETURN-VALUE).

                   {method/svc/errors/inserr.i &ErrorNumber="30343"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="c-msg"}
               END.
    
               IF  RowObject.apr-tip-doc AND AVAIL param-aprov
               AND (param-aprov.aprova-proc = NO OR (param-aprov.aprova-proc = YES AND param-aprov.aprov-total-proc = YES)) THEN DO:

                   {method/svc/errors/inserr.i &ErrorNumber="31003"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters=RowObject.des-tip-doc}
               END.
           END.
           WHEN 10 THEN DO: /**Processo de Compras - Total**/

               IF  RowObject.apr-tip-doc
               AND CAN-FIND (FIRST mla-tipo-doc-aprov
                             WHERE mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo
                               AND mla-tipo-doc-aprov.cod-estabel = RowObject.cod-estabel
                               AND mla-tipo-doc-aprov.cod-tip-doc = 9
                               AND mla-tipo-doc-aprov.apr-tip-doc) THEN DO:

                   ASSIGN c-msg = "".
                   {utp/ut-liter.i Processo_de_Compra_por_Total}
                   ASSIGN c-msg = TRIM(RETURN-VALUE).
                   {utp/ut-liter.i _Processo_de_Compra_por_Item}
                   ASSIGN c-msg = c-msg + '~~~~' + TRIM(RETURN-VALUE).

                   {method/svc/errors/inserr.i &ErrorNumber="30343"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="c-msg"}
               END.
    
               IF  RowObject.apr-tip-doc AND AVAIL param-aprov
               AND (param-aprov.aprova-proc = NO OR (param-aprov.aprova-proc = YES AND param-aprov.aprov-total-proc = NO)) THEN DO:

                   {method/svc/errors/inserr.i &ErrorNumber="31003"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters=RowObject.des-tip-doc}
               END.
           END.
           WHEN 19 THEN DO: /**Pedido Emergencial - Item**/

               IF  RowObject.apr-tip-doc
               AND CAN-FIND (FIRST mla-tipo-doc-aprov
                             WHERE mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo
                               AND mla-tipo-doc-aprov.cod-estabel = RowObject.cod-estabel
                               AND mla-tipo-doc-aprov.cod-tip-doc = 8
                               AND mla-tipo-doc-aprov.apr-tip-doc) THEN DO:

                   ASSIGN c-msg = "".
                   {utp/ut-liter.i Pedido_Emergencial_por_Item}
                   ASSIGN c-msg = TRIM(RETURN-VALUE).
                   {utp/ut-liter.i _Pedido_Emergencial_por_Total_}
                   ASSIGN c-msg = c-msg + '~~~~' + TRIM(RETURN-VALUE).

                   {method/svc/errors/inserr.i &ErrorNumber="30343"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="c-msg"}
               END.

               IF  RowObject.apr-tip-doc AND AVAIL param-aprov
               AND (param-aprov.aprova-emerg = NO OR (param-aprov.aprova-emerg = YES AND param-aprov.aprov-total-pedido = YES)) THEN DO:

                   {method/svc/errors/inserr.i &ErrorNumber="31003"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters=RowObject.des-tip-doc}
               END.
           END.
    END CASE.  

    /*n∆o permite que o parÉmetro Aprovaá∆o seja desmarcado enquanto houver pendàncias para o documento*/
    IF pType = "UPDATE":U THEN DO:
        IF CAN-FIND(FIRST mla-doc-pend-aprov
                    WHERE mla-doc-pend-aprov.ep-codigo    = RowObject.ep-codigo
                      AND mla-doc-pend-aprov.cod-estabel  = RowObject.cod-estabel 
                      AND mla-doc-pend-aprov.cod-tip-doc  = RowObject.cod-tip-doc
                      AND mla-doc-pend-aprov.ind-situacao = 1 /*Pendente*/ ) THEN DO:
                                 
            CASE RowObject.cod-tip-doc:
                WHEN 1  OR       /*Solicitaá∆o de Compra - Item*/
                WHEN 2  OR       /*Solicitaá∆o de Compra - Total*/
                WHEN 3  OR       /*Requisiá∆o de Estoque - Item*/
                WHEN 4  OR       /*Requisiá∆o de Estoque - Total*/
                WHEN 6  OR       /*Pedido de Compra - Item*/
                WHEN 7  OR       /*Pedido de Compra - Total*/
                WHEN 8  OR       /*Pedido Emergencial - Total*/
                WHEN 9  OR       /* Processo de Compra - Item */
                WHEN 10 OR       /* Processo de Compra - Total */
                WHEN 19 THEN DO: /*Pedido Emergencial - Item*/ 
                    FIND FIRST mla-doc-pend-aprov
                         WHERE mla-doc-pend-aprov.ep-codigo    = RowObject.ep-codigo
                           AND mla-doc-pend-aprov.cod-estabel  = RowObject.cod-estabel
                           AND mla-doc-pend-aprov.cod-tip-doc  = RowObject.cod-tip-doc
                           AND mla-doc-pend-aprov.ind-situacao = 1 /*Pendente*/ NO-LOCK NO-ERROR.

                    IF AVAIL mla-doc-pend-aprov THEN DO:
                        /*monta chave do documento com separadores*/
                        ASSIGN c-chave-doc = "".
                        FOR EACH mla-chave-doc-aprov
                            WHERE mla-chave-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc NO-LOCK:

                            ASSIGN c-chave-doc = c-chave-doc + 
                                    SUBSTRING(mla-doc-pend-aprov.chave-doc,mla-chave-doc-aprov.posicao-ini,
                                        ((mla-chave-doc-aprov.posicao-fim - mla-chave-doc-aprov.posicao-ini) + 1)) +
                                        " | ":U.
                        END.

                        ASSIGN c-chave-doc = SUBSTRING(c-chave-doc,1,(LENGTH(c-chave-doc) - 3)).
    
                        {method/svc/errors/inserr.i &ErrorNumber="26203"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="RowObject.des-tip-doc + '~~~~' + c-chave-doc"}
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do include: method/svc/errors/inserr.i
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        
        IF pType = "CREATE":U
        AND CAN-FIND(FIRST mla-tipo-doc-aprov
                     WHERE mla-tipo-doc-aprov.ep-codigo = RowObject.ep-codigo
                       AND mla-tipo-doc-aprov.cod-estabel = RowObject.cod-estabel
                       AND mla-tipo-doc-aprov.cod-tip-doc = RowObject.cod-tip-doc) THEN DO:
            {utp/ut-liter.i "tipos_de_documento_da_aprovaá∆o"}

            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RETURN-VALUE}
        END.

        /* Existància da empresa */
        IF NOT CAN-FIND (FIRST empresa
                         WHERE empresa.ep-codigo = RowObject.ep-codigo) THEN DO:
            {utp/ut-liter.i "empresa"}

            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RETURN-VALUE}
        END.

        /* Existància do estabelecimento */
        IF NOT CAN-FIND (FIRST estabelec
                         WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {utp/ut-liter.i "estabelecimento"}

            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RETURN-VALUE}
        END.

        IF RowObject.prioridade-aprov < 1 OR RowObject.prioridade-aprov > 3 THEN DO:
             {utp/ut-liter.i "Opá∆o_de_prioridade"}

            {method/svc/errors/inserr.i &ErrorNumber="158"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RETURN-VALUE}
        END.
        RUN validaDocumentos (INPUT pType).
    END.

    IF RowObject.idi-tip-val-pendcia <> 1 AND
       RowObject.idi-tip-val-pendcia <> 2 THEN DO:

        ASSIGN c-msg = "".
        {utp/ut-field.i mgind mla-tipo-doc-aprov idi-tip-val-pendcia 1}
        ASSIGN c-msg = RETURN-VALUE.

        /* Tipo de Valor Pendencia inexistente.*/
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-msg"}
    END.
 
    IF (RowObject.cod-tip-doc <> 6   AND  /*Pedido de Compra - Item*/
        RowObject.cod-tip-doc <> 7   AND  /*Pedido de Compra - Total*/
        RowObject.cod-tip-doc <> 8   AND  /*Pedido Emergencial - Total*/
        RowObject.cod-tip-doc <> 13  AND  /*Contrato de Compra*/
        RowObject.cod-tip-doc <> 14  AND  /*Mediá∆o*/
        RowObject.cod-tip-doc <> 19) AND /*Pedido Emergencial - Item*/
        RowObject.idi-tip-val-pendcia <> 1 THEN DO: /* Total */ 
        
        ASSIGN c-msg  = ""
               c-msg2 = "".  

        {utp/ut-field.i mgind mla-tipo-doc-aprov idi-tip-val-pendcia 1}
        ASSIGN c-msg  = RETURN-VALUE. 
        {utp/ut-liter.i "o_documento"}
        ASSIGN c-msg2 = RETURN-VALUE.

        /* Tipo de Valor Pendencia n∆o Ç v†lido para o documento.*/
        {method/svc/errors/inserr.i &ErrorNumber="17599"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters=" c-msg + '~~~~' + c-msg2  "}  
    END.

    /*Valida horas de execuá∆o integraá∆o com Fluig*/
    {utp/ut-field.i mgind mla-tipo-doc-aprov hra-execucao 1}
    RUN pi-valida-hora(INPUT RowObject.hra-execucao, INPUT TRIM(RETURN-VALUE)).
    {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-baixa 1}
    RUN pi-valida-hora(INPUT RowObject.hra-exec-priorid-baixa, INPUT TRIM(RETURN-VALUE)).
    {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-media 1}
    RUN pi-valida-hora(INPUT RowObject.hra-exec-priorid-media, INPUT TRIM(RETURN-VALUE)).
    {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-alta 1}
    RUN pi-valida-hora(INPUT RowObject.hra-exec-priorid-alta, INPUT TRIM(RETURN-VALUE)).
    {utp/ut-field.i mgind mla-tipo-doc-aprov hra-exec-priorid-altssmo 1}
    RUN pi-valida-hora(INPUT RowObject.hra-exec-priorid-altssmo, INPUT TRIM(RETURN-VALUE)).

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

