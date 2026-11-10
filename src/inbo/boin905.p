&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : boin905.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para a
                 tabela dta-agente-exec-acao.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN905
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName dta-agente-exec-acao
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
{inbo/boin905.i RowObject}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
{method/dboqry.i}

DEFINE VARIABLE iCodExec     AS INTEGER NO-UNDO.
DEFINE VARIABLE iSeqEvento   AS INTEGER NO-UNDO.

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***************************  Main Block  *************************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

PROCEDURE getCharField:
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  recebe nome do campo / retorna valor do campo
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:        
        WHEN "cod-prog-dtsul":U  THEN ASSIGN pFieldValue = RowObject.cod-prog-dtsul.
        WHEN "des-titulo":U      THEN ASSIGN pFieldValue = RowObject.des-titulo.
        WHEN "des-detalhe":U     THEN ASSIGN pFieldValue = RowObject.des-detalhe.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getIntField:
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  recebe nome do campo / retorna valor do campo
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER   NO-UNDO.

    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "seq-acao":U    THEN ASSIGN pFieldValue = RowObject.seq-acao.
        WHEN "seq-evento":U  THEN ASSIGN pFieldValue = RowObject.seq-evento.
        WHEN "id-exec":U     THEN ASSIGN pFieldValue = RowObject.id-exec.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getLogField:
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  recebe nome do campo / retorna valor do campo
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL   NO-UNDO.

    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-dta-chat":U THEN ASSIGN pFieldValue = RowObject.log-dta-chat.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getDateField:
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE      NO-UNDO.

    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getDecField:
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL   NO-UNDO.

    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getRawField:
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW       NO-UNDO.

    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getKey:
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice prim rid-execexeseq-eventoento + seq-acao)
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pid-exec    LIKE dta-agente-exec-acao.id-exec    NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-evento LIKE dta-agente-exec-acao.seq-evento NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-acao   LIKE dta-agente-exec-acao.seq-acao   NO-UNDO.

    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    ASSIGN pid-exec    = RowObject.id-exec
           pseq-evento = RowObject.seq-evento
           pseq-acao   = RowObject.seq-acao.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE goToKey:
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice prim rio
  Parameters:  recebe id-exec, seq-evento e seq-acao
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pid-exec    LIKE dta-agente-exec-acao.id-exec    NO-UNDO.
    DEFINE INPUT PARAMETER pseq-evento LIKE dta-agente-exec-acao.seq-evento NO-UNDO.
    DEFINE INPUT PARAMETER pseq-acao   LIKE dta-agente-exec-acao.seq-acao   NO-UNDO.

    FIND FIRST bf{&TableName}
        WHERE bf{&TableName}.id-exec    = pid-exec
          AND bf{&TableName}.seq-evento = pseq-evento
          AND bf{&TableName}.seq-acao   = pseq-acao NO-LOCK NO-ERROR.

    IF NOT AVAILABLE bf{&TableName} THEN
        RETURN "NOK":U.

    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateRecord:
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryMain:
/*------------------------------------------------------------------------------
  Purpose:     Abre query para todos os registros
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryExec:
/*------------------------------------------------------------------------------
  Purpose:     Abre query filtrada por id-exec
------------------------------------------------------------------------------*/
    OPEN QUERY qr{&TableName}
         FOR EACH {&TableName}
             WHERE {&TableName}.id-exec = iCodExec
        NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryEvent:
/*------------------------------------------------------------------------------
  Purpose:     Abre query filtrada por id-exec + seq-evento
------------------------------------------------------------------------------*/
    OPEN QUERY qr{&TableName}
         FOR EACH {&TableName}
             WHERE {&TableName}.id-exec    = iCodExec
               AND {&TableName}.seq-evento = iSeqEvento
        NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintExec:
/*------------------------------------------------------------------------------
  Purpose:     Define filtro por id-exec
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodExec AS integer NO-UNDO.
    ASSIGN iCodExec = pCodExec.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintEvent:
/*------------------------------------------------------------------------------
  Purpose:     Define filtros por id-exec e seq-evento
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodExec    AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pSeqEvento  AS INTEGER NO-UNDO.
    ASSIGN iCodExec   = pCodExec
           iSeqEvento = pSeqEvento.
    RETURN "OK":U.
END PROCEDURE.
