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

{include/i-prgvrs.i BOIN02060 2.00.00.000 }
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BOIN02060 MUT}
&ENDIF

/*---------------------------------------------------------------------------
    File       : boin02060.p
    Purpose    : DBO para eventos tecnicos e funcionais do Agente de Estoque.
  ------------------------------------------------------------------------*/

&GLOBAL-DEFINE DBOName BOIN02060
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ag-estoque-log-exec
&GLOBAL-DEFINE TableLabel Agente Estoque - Log Execucao
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES
&GLOBAL-DEFINE KeyField1 id-log-exec

{inbo/boin02060.i RowObject}
{java/boRest.i}
{method/dboqry.i}

DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-id-log-exec      LIKE ag-estoque-log-exec.id-log-exec      NO-UNDO.
DEFINE VARIABLE c-id-correlacao    LIKE ag-estoque-log-exec.id-correlacao    INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-origem       LIKE ag-estoque-log-exec.cod-origem       INITIAL "" NO-UNDO.
DEFINE VARIABLE c-id-evento-origem LIKE ag-estoque-log-exec.id-evento-origem INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-status       LIKE ag-estoque-log-exec.cod-status-evento INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-etapa        LIKE ag-estoque-log-exec.cod-etapa        INITIAL "" NO-UNDO.
DEFINE VARIABLE c-localizador      LIKE ag-estoque-log-exec.localizador      INITIAL "" NO-UNDO.
DEFINE VARIABLE c-it-codigo        LIKE ag-estoque-log-exec.it-codigo        INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-estabel      LIKE ag-estoque-log-exec.cod-estabel      INITIAL "" NO-UNDO.
DEFINE VARIABLE dt-dat-ini         AS DATETIME                               NO-UNDO.
DEFINE VARIABLE dt-dat-fim         AS DATETIME                               NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK
&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no
&ANALYZE-RESUME

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
{method/dbo.i}
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE addValidationError :
    DEFINE INPUT PARAMETER piMessage AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pcParameters AS CHARACTER NO-UNDO.
    {method/svc/errors/inserr.i
        &ErrorNumber="piMessage"
        &ErrorType="EMS"
        &ErrorSubType="ERROR"
        &ErrorParameters="pcParameters"}
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getCharField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "id-log-exec":U         THEN ASSIGN pFieldValue = RowObject.id-log-exec.
        WHEN "id-correlacao":U       THEN ASSIGN pFieldValue = RowObject.id-correlacao.
        WHEN "id-exec-agente":U      THEN ASSIGN pFieldValue = RowObject.id-exec-agente.
        WHEN "id-trace-lynn":U       THEN ASSIGN pFieldValue = RowObject.id-trace-lynn.
        WHEN "id-evento-origem":U    THEN ASSIGN pFieldValue = RowObject.id-evento-origem.
        WHEN "cod-origem":U          THEN ASSIGN pFieldValue = RowObject.cod-origem.
        WHEN "cod-etapa":U           THEN ASSIGN pFieldValue = RowObject.cod-etapa.
        WHEN "cod-tipo-evento":U     THEN ASSIGN pFieldValue = RowObject.cod-tipo-evento.
        WHEN "cod-status-evento":U   THEN ASSIGN pFieldValue = RowObject.cod-status-evento.
        WHEN "cod-canal-retorno":U   THEN ASSIGN pFieldValue = RowObject.cod-canal-retorno.
        WHEN "cod-empresa":U         THEN ASSIGN pFieldValue = RowObject.cod-empresa.
        WHEN "cod-estabel":U         THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "it-codigo":U           THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "localizador":U         THEN ASSIGN pFieldValue = RowObject.localizador.
        WHEN "des-msg-retorno":U     THEN ASSIGN pFieldValue = RowObject.des-msg-retorno.
        WHEN "cod-acao":U            THEN ASSIGN pFieldValue = RowObject.cod-acao.
        WHEN "cod-usuario":U         THEN ASSIGN pFieldValue = RowObject.cod-usuario.
        WHEN "cod-erro":U            THEN ASSIGN pFieldValue = RowObject.cod-erro.
        WHEN "des-erro":U            THEN ASSIGN pFieldValue = RowObject.des-erro.
        WHEN "des-payload-entrada":U THEN ASSIGN pFieldValue = RowObject.des-payload-entrada.
        WHEN "des-payload-saida":U   THEN ASSIGN pFieldValue = RowObject.des-payload-saida.
        WHEN "char-1":U              THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U              THEN ASSIGN pFieldValue = RowObject.char-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getDateField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE      NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getDateTimeField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATETIME  NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "dat-evento":U THEN ASSIGN pFieldValue = RowObject.dat-evento.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getDecField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL   NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getIntField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER   NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "seq-evento":U      THEN ASSIGN pFieldValue = RowObject.seq-evento.
        WHEN "cod-status-http":U THEN ASSIGN pFieldValue = RowObject.cod-status-http.
        WHEN "qtd-duracao-ms":U  THEN ASSIGN pFieldValue = RowObject.qtd-duracao-ms.
        WHEN "int-1":U           THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U           THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getLogField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL   NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getRawField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW       NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    RETURN "NOK":U.
END PROCEDURE.

PROCEDURE getKey :
    DEFINE OUTPUT PARAMETER pid-log-exec LIKE ag-estoque-log-exec.id-log-exec NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    ASSIGN pid-log-exec = RowObject.id-log-exec.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE goToKey :
    DEFINE INPUT PARAMETER pid-log-exec LIKE ag-estoque-log-exec.id-log-exec NO-UNDO.
    FIND FIRST bfag-estoque-log-exec
         WHERE bfag-estoque-log-exec.id-log-exec = pid-log-exec
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE bfag-estoque-log-exec THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfag-estoque-log-exec)).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryID :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-log-exec = c-id-log-exec
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintID :
    DEFINE INPUT PARAMETER pid-log-exec LIKE ag-estoque-log-exec.id-log-exec NO-UNDO.
    ASSIGN c-id-log-exec = IF pid-log-exec = ? THEN "":U ELSE TRIM(pid-log-exec).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryCorrelacao :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-correlacao = c-id-correlacao
         BY {&TableName}.seq-evento
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintCorrelacao :
    DEFINE INPUT PARAMETER pid-correlacao LIKE ag-estoque-log-exec.id-correlacao NO-UNDO.
    ASSIGN c-id-correlacao = IF pid-correlacao = ? THEN "":U ELSE TRIM(pid-correlacao).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryPeriodo :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE (dt-dat-ini = ? OR {&TableName}.dat-evento >= dt-dat-ini)
           AND (dt-dat-fim = ? OR {&TableName}.dat-evento <= dt-dat-fim)
           AND (c-cod-status = "":U OR {&TableName}.cod-status-evento = c-cod-status)
           AND (c-cod-etapa = "":U OR {&TableName}.cod-etapa = c-cod-etapa)
         BY {&TableName}.dat-evento DESCENDING
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintPeriodo :
    DEFINE INPUT PARAMETER pdat-ini    AS DATE                                  NO-UNDO.
    DEFINE INPUT PARAMETER pdat-fim    AS DATE                                  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-status LIKE ag-estoque-log-exec.cod-status-evento NO-UNDO.
    DEFINE INPUT PARAMETER pcod-etapa  LIKE ag-estoque-log-exec.cod-etapa        NO-UNDO.
    ASSIGN dt-dat-ini   = IF pdat-ini = ? THEN ? ELSE DATETIME(pdat-ini, 0)
           dt-dat-fim   = IF pdat-fim = ? THEN ? ELSE DATETIME(pdat-fim, 86399999)
           c-cod-status = IF pcod-status = ? THEN "":U ELSE CAPS(TRIM(pcod-status))
           c-cod-etapa  = IF pcod-etapa = ? THEN "":U ELSE CAPS(TRIM(pcod-etapa)).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryIdempotencia :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-origem = c-cod-origem
           AND {&TableName}.id-evento-origem = c-id-evento-origem
         BY {&TableName}.dat-evento DESCENDING
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintIdempotencia :
    DEFINE INPUT PARAMETER pcod-origem       LIKE ag-estoque-log-exec.cod-origem       NO-UNDO.
    DEFINE INPUT PARAMETER pid-evento-origem LIKE ag-estoque-log-exec.id-evento-origem NO-UNDO.
    ASSIGN c-cod-origem       = IF pcod-origem = ? THEN "":U ELSE CAPS(TRIM(pcod-origem))
           c-id-evento-origem = IF pid-evento-origem = ? THEN "":U ELSE TRIM(pid-evento-origem).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryLocalizador :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.localizador = c-localizador
         BY {&TableName}.seq-evento
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintLocalizador :
    DEFINE INPUT PARAMETER plocalizador LIKE ag-estoque-log-exec.localizador NO-UNDO.
    ASSIGN c-localizador = IF plocalizador = ? THEN "":U ELSE CAPS(TRIM(plocalizador)).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryItem :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.it-codigo = c-it-codigo
           AND (c-cod-estabel = "":U OR {&TableName}.cod-estabel = c-cod-estabel)
           AND (dt-dat-ini = ? OR {&TableName}.dat-evento >= dt-dat-ini)
           AND (dt-dat-fim = ? OR {&TableName}.dat-evento <= dt-dat-fim)
         BY {&TableName}.dat-evento DESCENDING
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintItem :
    DEFINE INPUT PARAMETER pit-codigo  LIKE ag-estoque-log-exec.it-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE ag-estoque-log-exec.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pdat-ini     AS DATE                              NO-UNDO.
    DEFINE INPUT PARAMETER pdat-fim     AS DATE                              NO-UNDO.
    ASSIGN c-it-codigo   = IF pit-codigo = ? THEN "":U ELSE TRIM(pit-codigo)
           c-cod-estabel = IF pcod-estabel = ? THEN "":U ELSE TRIM(pcod-estabel)
           dt-dat-ini    = IF pdat-ini = ? THEN ? ELSE DATETIME(pdat-ini, 0)
           dt-dat-fim    = IF pdat-fim = ? THEN ? ELSE DATETIME(pdat-fim, 86399999).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryMain :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         BY {&TableName}.dat-evento DESCENDING
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE beforeCreateRecord :
    ASSIGN RowObject.cod-origem        = IF RowObject.cod-origem = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-origem))
           RowObject.cod-etapa         = IF RowObject.cod-etapa = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-etapa))
           RowObject.cod-tipo-evento   = IF RowObject.cod-tipo-evento = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-tipo-evento))
           RowObject.cod-status-evento = IF RowObject.cod-status-evento = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-status-evento))
           RowObject.cod-canal-retorno = IF RowObject.cod-canal-retorno = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-canal-retorno))
           RowObject.cod-acao          = IF RowObject.cod-acao = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-acao))
           RowObject.localizador       = IF RowObject.localizador = ? THEN "":U ELSE CAPS(TRIM(RowObject.localizador)).
    IF RowObject.dat-evento = ? THEN ASSIGN RowObject.dat-evento = NOW.
    IF RowObject.seq-evento = ? OR RowObject.seq-evento = 0 THEN ASSIGN RowObject.seq-evento = 1.
    IF RowObject.qtd-duracao-ms = ? THEN ASSIGN RowObject.qtd-duracao-ms = 0.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateRecord :
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-alfabeto AS CHARACTER NO-UNDO INITIAL "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ":U.
    DEFINE VARIABLE c-localiz  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-posicao  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE l-letra    AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-numero   AS LOGICAL   NO-UNDO.

    IF NOT AVAILABLE RowObject THEN DO:
        RUN addValidationError (INPUT 58370, INPUT "":U).
        RETURN "NOK":U.
    END.

    ASSIGN pType = IF pType = ? THEN "":U ELSE CAPS(TRIM(pType)).
    IF LOOKUP(pType, "CREATE,UPDATE,DELETE":U) = 0 THEN DO:
        RUN addIntegrityError (INPUT 52530, INPUT "Operacao~~CREATE, UPDATE ou DELETE":U).
        RETURN "NOK":U.
    END.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN RETURN "NOK":U.

    IF pType <> "CREATE":U THEN DO:
        RUN addIntegrityError (INPUT 53420, INPUT "alterar ou excluir eventos do historico do agente":U).
        RETURN "NOK":U.
    END.
    IF CAN-DO("CREATE,UPDATE":U, CAPS(pType)) THEN DO:
        IF RowObject.id-log-exec = ? OR TRIM(RowObject.id-log-exec) = "":U
        OR RowObject.id-correlacao = ? OR TRIM(RowObject.id-correlacao) = "":U
        OR RowObject.id-evento-origem = ? OR TRIM(RowObject.id-evento-origem) = "":U THEN DO:
            RUN addValidationError (INPUT 58371, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.seq-evento = ? OR RowObject.seq-evento <= 0 THEN DO:
            RUN addValidationError (INPUT 58372, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.cod-origem = ? OR TRIM(RowObject.cod-origem) = "":U
        OR RowObject.cod-etapa = ? OR TRIM(RowObject.cod-etapa) = "":U
        OR RowObject.cod-tipo-evento = ? OR TRIM(RowObject.cod-tipo-evento) = "":U
        OR RowObject.cod-status-evento = ? OR TRIM(RowObject.cod-status-evento) = "":U THEN DO:
            RUN addValidationError (INPUT 58373, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.dat-evento = ? THEN DO:
            RUN addValidationError (INPUT 58374, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.qtd-duracao-ms = ? OR RowObject.qtd-duracao-ms < 0 THEN DO:
            RUN addValidationError (INPUT 58375, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.cod-status-http <> ?
        AND RowObject.cod-status-http <> 0
        AND (RowObject.cod-status-http < 100 OR RowObject.cod-status-http > 599) THEN DO:
            RUN addValidationError (INPUT 58376, INPUT "":U).
            RETURN "NOK":U.
        END.

        ASSIGN c-localiz = IF RowObject.localizador = ? THEN "":U ELSE RowObject.localizador.
        IF c-localiz <> "":U THEN DO:
            IF LENGTH(c-localiz) <> 8 OR c-localiz <> CAPS(c-localiz) THEN DO:
                RUN addValidationError (INPUT 52530,
                                        INPUT "Localizador":U + "~~Oito caracteres em mai£sculas":U).
                RETURN "NOK":U.
            END.
            DO i-posicao = 1 TO LENGTH(c-localiz):
                IF INDEX(c-alfabeto, SUBSTRING(c-localiz, i-posicao, 1)) = 0 THEN DO:
                    RUN addValidationError (INPUT 52530,
                                            INPUT "Localizador":U + "~~Somente letras de A a Z e n£meros de 0 a 9":U).
                    RETURN "NOK":U.
                END.
                IF INDEX("0123456789":U, SUBSTRING(c-localiz, i-posicao, 1)) > 0 THEN
                    ASSIGN l-numero = YES.
                ELSE
                    ASSIGN l-letra = YES.
            END.
            IF NOT l-letra OR NOT l-numero THEN DO:
                RUN addValidationError (INPUT 52530,
                                        INPUT "Localizador":U + "~~Combina‡Æo contendo letras e n£meros":U).
                RETURN "NOK":U.
            END.
        END.
    END.

    RUN validateIntegrity IN THIS-PROCEDURE (INPUT pType).
    IF RETURN-VALUE <> "OK":U THEN RETURN "NOK":U.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* Erros oficiais das verificacoes de integridade; nao substitui as mensagens anteriores. */
PROCEDURE addIntegrityError :
    DEFINE INPUT PARAMETER piMessage AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pcParameters AS CHARACTER NO-UNDO.
    {method/svc/errors/inserr.i
        &ErrorNumber="piMessage"
        &ErrorType="EMS"
        &ErrorSubType="ERROR"
        &ErrorParameters="pcParameters"}
    RETURN "OK":U.
END PROCEDURE.

/* CREATE/UPDATE/DELETE: confere contexto original e dependencias; retorna OK/NOK.
   Participa da transacao de persistencia do framework. Nao executa CRUD direto.
   NO-WAIT evita espera indefinida; FINALLY encerra o escopo dos buffers. */
PROCEDURE validateIntegrity :
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEFINE BUFFER bIntegrityOriginal FOR ag-estoque-log-exec.
    DEFINE BUFFER bIntegrityDuplicado FOR ag-estoque-log-exec.

    DO TRANSACTION:
        IF CAN-FIND(FIRST bIntegrityDuplicado NO-LOCK
                    WHERE bIntegrityDuplicado.id-log-exec = RowObject.id-log-exec
                      AND (pType = "CREATE":U
                           OR ROWID(bIntegrityDuplicado) <> RowObject.r-Rowid)) THEN DO:
            RUN addIntegrityError (INPUT 46216, INPUT "ag-estoque-log-exec":U).
            RETURN "NOK":U.
        END.
        RETURN "OK":U.
        FINALLY:
            RELEASE bIntegrityDuplicado.
            RELEASE bIntegrityOriginal.
        END FINALLY.
    END.
END PROCEDURE.
