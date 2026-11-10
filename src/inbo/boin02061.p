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

{include/i-prgvrs.i BOIN02061 2.00.00.000 }
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BOIN02061 MUT}
&ENDIF

/*---------------------------------------------------------------------------
    File       : boin02061.p
    Purpose    : DBO para o cabecalho das analises do Agente de Estoque.
  ------------------------------------------------------------------------*/

&GLOBAL-DEFINE DBOName BOIN02061
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ag-estoque-analise
&GLOBAL-DEFINE TableLabel Agente Estoque - Analise
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES
&GLOBAL-DEFINE KeyField1 id-analise

{inbo/boin02061.i RowObject}
{java/boRest.i}
{method/dboqry.i}

DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-id-analise     LIKE ag-estoque-analise.id-analise     NO-UNDO.
DEFINE VARIABLE c-id-correlacao  LIKE ag-estoque-analise.id-correlacao  INITIAL "" NO-UNDO.
DEFINE VARIABLE c-id-execucao-rpw LIKE ag-estoque-analise.id-execucao-rpw INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-empresa    LIKE ag-estoque-analise.cod-empresa    INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-status     LIKE ag-estoque-analise.cod-status     INITIAL "" NO-UNDO.
DEFINE VARIABLE dt-dat-ini       AS DATETIME                            NO-UNDO.
DEFINE VARIABLE dt-dat-fim       AS DATETIME                            NO-UNDO.

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
        WHEN "id-analise":U       THEN ASSIGN pFieldValue = RowObject.id-analise.
        WHEN "id-correlacao":U    THEN ASSIGN pFieldValue = RowObject.id-correlacao.
        WHEN "cod-empresa":U      THEN ASSIGN pFieldValue = RowObject.cod-empresa.
        WHEN "cod-status":U       THEN ASSIGN pFieldValue = RowObject.cod-status.
        WHEN "cod-origem-exec":U  THEN ASSIGN pFieldValue = RowObject.cod-origem-exec.
        WHEN "id-execucao-rpw":U  THEN ASSIGN pFieldValue = RowObject.id-execucao-rpw.
        WHEN "cod-usuario":U      THEN ASSIGN pFieldValue = RowObject.cod-usuario.
        WHEN "cod-versao-regra":U THEN ASSIGN pFieldValue = RowObject.cod-versao-regra.
        WHEN "cod-estabel-ini":U  THEN ASSIGN pFieldValue = RowObject.cod-estabel-ini.
        WHEN "cod-estabel-fim":U  THEN ASSIGN pFieldValue = RowObject.cod-estabel-fim.
        WHEN "fm-codigo-ini":U    THEN ASSIGN pFieldValue = RowObject.fm-codigo-ini.
        WHEN "fm-codigo-fim":U    THEN ASSIGN pFieldValue = RowObject.fm-codigo-fim.
        WHEN "it-codigo-ini":U    THEN ASSIGN pFieldValue = RowObject.it-codigo-ini.
        WHEN "it-codigo-fim":U    THEN ASSIGN pFieldValue = RowObject.it-codigo-fim.
        WHEN "des-erro":U         THEN ASSIGN pFieldValue = RowObject.des-erro.
        WHEN "char-1":U           THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U           THEN ASSIGN pFieldValue = RowObject.char-2.
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
        WHEN "dat-analise":U        THEN ASSIGN pFieldValue = RowObject.dat-analise.
        WHEN "dat-inicio-processo":U THEN ASSIGN pFieldValue = RowObject.dat-inicio-processo.
        WHEN "dat-fim-processo":U    THEN ASSIGN pFieldValue = RowObject.dat-fim-processo.
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
        WHEN "ge-codigo-ini":U       THEN ASSIGN pFieldValue = RowObject.ge-codigo-ini.
        WHEN "ge-codigo-fim":U       THEN ASSIGN pFieldValue = RowObject.ge-codigo-fim.
        WHEN "qtd-itens-analisados":U THEN ASSIGN pFieldValue = RowObject.qtd-itens-analisados.
        WHEN "qtd-itens-gravados":U   THEN ASSIGN pFieldValue = RowObject.qtd-itens-gravados.
        WHEN "int-1":U                THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U                THEN ASSIGN pFieldValue = RowObject.int-2.
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
    DEFINE OUTPUT PARAMETER pid-analise LIKE ag-estoque-analise.id-analise NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    ASSIGN pid-analise = RowObject.id-analise.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE goToKey :
    DEFINE INPUT PARAMETER pid-analise LIKE ag-estoque-analise.id-analise NO-UNDO.
    FIND FIRST bfag-estoque-analise
         WHERE bfag-estoque-analise.id-analise = pid-analise
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE bfag-estoque-analise THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfag-estoque-analise)).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryID :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-analise = c-id-analise
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintID :
    DEFINE INPUT PARAMETER pid-analise LIKE ag-estoque-analise.id-analise NO-UNDO.
    ASSIGN c-id-analise = IF pid-analise = ? THEN "":U ELSE TRIM(pid-analise).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryDashboard :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE (c-cod-empresa = "":U OR {&TableName}.cod-empresa = c-cod-empresa)
           AND (c-cod-status = "":U OR {&TableName}.cod-status = c-cod-status)
           AND (dt-dat-ini = ? OR {&TableName}.dat-analise >= dt-dat-ini)
           AND (dt-dat-fim = ? OR {&TableName}.dat-analise <= dt-dat-fim)
         BY {&TableName}.dat-analise DESCENDING
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintDashboard :
    DEFINE INPUT PARAMETER pcod-empresa LIKE ag-estoque-analise.cod-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-status  LIKE ag-estoque-analise.cod-status  NO-UNDO.
    DEFINE INPUT PARAMETER pdat-ini     AS DATE                            NO-UNDO.
    DEFINE INPUT PARAMETER pdat-fim     AS DATE                            NO-UNDO.
    ASSIGN c-cod-empresa = IF pcod-empresa = ? THEN "":U ELSE TRIM(pcod-empresa)
           c-cod-status  = IF pcod-status = ? THEN "":U ELSE CAPS(TRIM(pcod-status))
           dt-dat-ini    = IF pdat-ini = ? THEN ? ELSE DATETIME(pdat-ini, 0)
           dt-dat-fim    = IF pdat-fim = ? THEN ? ELSE DATETIME(pdat-fim, 86399999).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryCorrelacao :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-correlacao = c-id-correlacao
         BY {&TableName}.dat-analise DESCENDING
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintCorrelacao :
    DEFINE INPUT PARAMETER pid-correlacao LIKE ag-estoque-analise.id-correlacao NO-UNDO.
    ASSIGN c-id-correlacao = IF pid-correlacao = ? THEN "":U ELSE TRIM(pid-correlacao).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryRPW :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-execucao-rpw = c-id-execucao-rpw
         BY {&TableName}.dat-analise DESCENDING
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintRPW :
    DEFINE INPUT PARAMETER pid-execucao-rpw LIKE ag-estoque-analise.id-execucao-rpw NO-UNDO.
    ASSIGN c-id-execucao-rpw = IF pid-execucao-rpw = ? THEN "":U ELSE TRIM(pid-execucao-rpw).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryMain :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         BY {&TableName}.dat-analise DESCENDING
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE beforeCreateRecord :
    ASSIGN RowObject.cod-status       = IF RowObject.cod-status = ? OR TRIM(RowObject.cod-status) = "":U
                                        THEN "PENDENTE":U ELSE CAPS(TRIM(RowObject.cod-status))
           RowObject.cod-origem-exec = IF RowObject.cod-origem-exec = ? OR TRIM(RowObject.cod-origem-exec) = "":U
                                        THEN "MANUAL":U ELSE CAPS(TRIM(RowObject.cod-origem-exec)).
    IF RowObject.dat-analise = ? THEN ASSIGN RowObject.dat-analise = NOW.
    IF RowObject.dat-inicio-processo = ? THEN ASSIGN RowObject.dat-inicio-processo = NOW.
    IF RowObject.qtd-itens-analisados = ? THEN ASSIGN RowObject.qtd-itens-analisados = 0.
    IF RowObject.qtd-itens-gravados = ? THEN ASSIGN RowObject.qtd-itens-gravados = 0.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateRecord :
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-status AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-origem AS CHARACTER NO-UNDO.

    IF NOT AVAILABLE RowObject THEN DO:
        RUN addValidationError (INPUT 58377, INPUT "":U).
        RETURN "NOK":U.
    END.

    ASSIGN pType = IF pType = ? THEN "":U ELSE CAPS(TRIM(pType)).
    IF LOOKUP(pType, "CREATE,UPDATE,DELETE":U) = 0 THEN DO:
        RUN addIntegrityError (INPUT 52530, INPUT "Operacao~~CREATE, UPDATE ou DELETE":U).
        RETURN "NOK":U.
    END.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN RETURN "NOK":U.

    IF CAN-DO("CREATE,UPDATE":U, CAPS(pType)) THEN DO:
        ASSIGN c-status = CAPS(TRIM(RowObject.cod-status))
               c-origem = CAPS(TRIM(RowObject.cod-origem-exec)).

        IF RowObject.id-analise = ? OR TRIM(RowObject.id-analise) = "":U
        OR RowObject.id-correlacao = ? OR TRIM(RowObject.id-correlacao) = "":U THEN DO:
            RUN addValidationError (INPUT 58378, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.cod-empresa = ? OR TRIM(RowObject.cod-empresa) = "":U
        OR RowObject.cod-usuario = ? OR TRIM(RowObject.cod-usuario) = "":U
        OR RowObject.cod-versao-regra = ? OR TRIM(RowObject.cod-versao-regra) = "":U THEN DO:
            RUN addValidationError (INPUT 58379, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.dat-analise = ? OR RowObject.dat-inicio-processo = ? THEN DO:
            RUN addValidationError (INPUT 58380, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF LOOKUP(c-status, "PENDENTE,PROCESSANDO,CONCLUIDO,PARCIAL,ERRO,CANCELADO":U) = 0 THEN DO:
            RUN addValidationError (INPUT 58381, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF c-origem = "":U THEN DO:
            RUN addValidationError (INPUT 58382, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF c-origem = "RPW":U
        AND (RowObject.id-execucao-rpw = ? OR TRIM(RowObject.id-execucao-rpw) = "":U) THEN DO:
            RUN addValidationError (INPUT 58383, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF CAN-DO("CONCLUIDO,PARCIAL,ERRO,CANCELADO":U, c-status)
        AND RowObject.dat-fim-processo = ? THEN DO:
            RUN addValidationError (INPUT 58384, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF CAN-DO("PENDENTE,PROCESSANDO":U, c-status)
        AND RowObject.dat-fim-processo <> ? THEN DO:
            RUN addValidationError (INPUT 58385, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.dat-fim-processo <> ?
        AND RowObject.dat-fim-processo < RowObject.dat-inicio-processo THEN DO:
            RUN addValidationError (INPUT 58386, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF CAN-DO("PARCIAL,ERRO":U, c-status)
        AND (RowObject.des-erro = ? OR TRIM(RowObject.des-erro) = "":U) THEN DO:
            RUN addValidationError (INPUT 58387, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.qtd-itens-analisados = ? OR RowObject.qtd-itens-analisados < 0
        OR RowObject.qtd-itens-gravados = ? OR RowObject.qtd-itens-gravados < 0 THEN DO:
            RUN addValidationError (INPUT 58388, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.cod-estabel-ini <> "":U AND RowObject.cod-estabel-fim <> "":U
        AND RowObject.cod-estabel-ini > RowObject.cod-estabel-fim THEN DO:
            RUN addValidationError (INPUT 58389, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.ge-codigo-ini > 0 AND RowObject.ge-codigo-fim > 0
        AND RowObject.ge-codigo-ini > RowObject.ge-codigo-fim THEN DO:
            RUN addValidationError (INPUT 58390, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.fm-codigo-ini <> "":U AND RowObject.fm-codigo-fim <> "":U
        AND RowObject.fm-codigo-ini > RowObject.fm-codigo-fim THEN DO:
            RUN addValidationError (INPUT 58391, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.it-codigo-ini <> "":U AND RowObject.it-codigo-fim <> "":U
        AND RowObject.it-codigo-ini > RowObject.it-codigo-fim THEN DO:
            RUN addValidationError (INPUT 58392, INPUT "":U).
            RETURN "NOK":U.
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
    DEFINE BUFFER bIntegrityOriginal FOR ag-estoque-analise.
    DEFINE BUFFER bIntegrityDuplicado FOR ag-estoque-analise.

    DO TRANSACTION:
        IF pType <> "CREATE":U THEN DO:
            FIND bIntegrityOriginal WHERE ROWID(bIntegrityOriginal) = RowObject.r-Rowid
                 EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF LOCKED(bIntegrityOriginal) THEN DO:
                RUN addIntegrityError (INPUT 53420, INPUT "registro em uso por outro processo":U).
                RETURN "NOK":U.
            END.
            IF NOT AVAILABLE bIntegrityOriginal THEN DO:
                RUN addIntegrityError (INPUT 57401, INPUT "ag-estoque-analise":U).
                RETURN "NOK":U.
            END.
            IF RowObject.id-analise <> bIntegrityOriginal.id-analise
            OR RowObject.id-correlacao <> bIntegrityOriginal.id-correlacao
            OR RowObject.cod-empresa <> bIntegrityOriginal.cod-empresa
            OR RowObject.dat-analise <> bIntegrityOriginal.dat-analise
            OR RowObject.cod-versao-regra <> bIntegrityOriginal.cod-versao-regra
            OR RowObject.cod-origem-exec <> bIntegrityOriginal.cod-origem-exec
            OR RowObject.id-execucao-rpw <> bIntegrityOriginal.id-execucao-rpw
            OR RowObject.cod-usuario <> bIntegrityOriginal.cod-usuario
            OR RowObject.cod-estabel-ini <> bIntegrityOriginal.cod-estabel-ini
            OR RowObject.cod-estabel-fim <> bIntegrityOriginal.cod-estabel-fim
            OR RowObject.ge-codigo-ini <> bIntegrityOriginal.ge-codigo-ini
            OR RowObject.ge-codigo-fim <> bIntegrityOriginal.ge-codigo-fim
            OR RowObject.fm-codigo-ini <> bIntegrityOriginal.fm-codigo-ini
            OR RowObject.fm-codigo-fim <> bIntegrityOriginal.fm-codigo-fim
            OR RowObject.it-codigo-ini <> bIntegrityOriginal.it-codigo-ini
            OR RowObject.it-codigo-fim <> bIntegrityOriginal.it-codigo-fim THEN DO:
                RUN addIntegrityError (INPUT 53420, INPUT "alterar identificadores, vinculos ou contexto da fotografia":U).
                RETURN "NOK":U.
            END.
        END.
        IF pType <> "CREATE":U THEN DO:
            IF bIntegrityOriginal.cod-status = ?
            OR LOOKUP(bIntegrityOriginal.cod-status, "PENDENTE,PROCESSANDO":U) = 0 THEN DO:
                RUN addIntegrityError (INPUT 53420, INPUT "alterar ou excluir analise encerrada":U).
                RETURN "NOK":U.
            END.
            IF pType = "UPDATE":U
            AND bIntegrityOriginal.cod-status = "PROCESSANDO":U
            AND CAPS(TRIM(RowObject.cod-status)) = "PENDENTE":U THEN DO:
                RUN addIntegrityError (INPUT 53420, INPUT "retornar analise em processamento para pendente":U).
                RETURN "NOK":U.
            END.
        END.
        IF pType = "DELETE":U THEN DO:
            IF CAN-FIND(FIRST ag-estoque-analise-item NO-LOCK
                         WHERE ag-estoque-analise-item.id-analise = bIntegrityOriginal.id-analise)
            OR CAN-FIND(FIRST ag-estoque-analise-agregado NO-LOCK
                         WHERE ag-estoque-analise-agregado.id-analise = bIntegrityOriginal.id-analise)
            OR CAN-FIND(FIRST ag-estoque-analise-entrega NO-LOCK
                         WHERE ag-estoque-analise-entrega.id-analise = bIntegrityOriginal.id-analise)
            OR CAN-FIND(FIRST ag-estoque-analise-opcao-trf NO-LOCK
                         WHERE ag-estoque-analise-opcao-trf.id-analise = bIntegrityOriginal.id-analise)
            OR CAN-FIND(FIRST ag-estoque-recomendacao NO-LOCK
                         WHERE ag-estoque-recomendacao.id-analise = bIntegrityOriginal.id-analise)
            OR CAN-FIND(FIRST ag-estoque-log-exec NO-LOCK
                         WHERE ag-estoque-log-exec.id-correlacao = bIntegrityOriginal.id-correlacao) THEN DO:
                RUN addIntegrityError (INPUT 53420, INPUT "excluir analise com registros dependentes ou historico":U).
                RETURN "NOK":U.
            END.
            RETURN "OK":U.
        END.
        IF CAN-FIND(FIRST bIntegrityDuplicado NO-LOCK
                    WHERE bIntegrityDuplicado.id-analise = RowObject.id-analise
                      AND (pType = "CREATE":U
                           OR ROWID(bIntegrityDuplicado) <> RowObject.r-Rowid)) THEN DO:
            RUN addIntegrityError (INPUT 46216, INPUT "ag-estoque-analise":U).
            RETURN "NOK":U.
        END.
        RETURN "OK":U.
        FINALLY:
            RELEASE bIntegrityDuplicado.
            RELEASE bIntegrityOriginal.
        END FINALLY.
    END.
END PROCEDURE.
