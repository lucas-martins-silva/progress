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

{include/i-prgvrs.i BOIN02063 2.00.00.000 }
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BOIN02063 MUT}
&ENDIF

/*---------------------------------------------------------------------------
    File       : boin02063.p
    Purpose    : DBO para os agregados das analises do Agente de Estoque.
  ------------------------------------------------------------------------*/

&GLOBAL-DEFINE DBOName BOIN02063
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ag-estoque-analise-agregado
&GLOBAL-DEFINE TableLabel Agente Estoque - Analise Agregado
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES
&GLOBAL-DEFINE KeyField1 id-agregado-analise

{inbo/boin02063.i RowObject}
{java/boRest.i}
{method/dboqry.i}

DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-id-agregado     LIKE ag-estoque-analise-agregado.id-agregado-analise NO-UNDO.
DEFINE VARIABLE c-id-analise      LIKE ag-estoque-analise-agregado.id-analise          INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-empresa     LIKE ag-estoque-analise-agregado.cod-empresa         INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-estabel     LIKE ag-estoque-analise-agregado.cod-estabel         INITIAL "" NO-UNDO.
DEFINE VARIABLE c-fm-codigo       LIKE ag-estoque-analise-agregado.fm-codigo           INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-situacao    LIKE ag-estoque-analise-agregado.cod-situacao-estoque INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-criticidade LIKE ag-estoque-analise-agregado.cod-criticidade     INITIAL "" NO-UNDO.
DEFINE VARIABLE i-ge-codigo       LIKE ag-estoque-analise-agregado.ge-codigo           INITIAL 0  NO-UNDO.
DEFINE VARIABLE dt-dat-ini        AS DATETIME                                          NO-UNDO.
DEFINE VARIABLE dt-dat-fim        AS DATETIME                                          NO-UNDO.

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
        WHEN "id-agregado-analise":U  THEN ASSIGN pFieldValue = RowObject.id-agregado-analise.
        WHEN "id-analise":U           THEN ASSIGN pFieldValue = RowObject.id-analise.
        WHEN "cod-empresa":U          THEN ASSIGN pFieldValue = RowObject.cod-empresa.
        WHEN "cod-estabel":U          THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "fm-codigo":U            THEN ASSIGN pFieldValue = RowObject.fm-codigo.
        WHEN "cod-situacao-estoque":U THEN ASSIGN pFieldValue = RowObject.cod-situacao-estoque.
        WHEN "cod-criticidade":U       THEN ASSIGN pFieldValue = RowObject.cod-criticidade.
        WHEN "char-1":U                THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U                THEN ASSIGN pFieldValue = RowObject.char-2.
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
        WHEN "dat-analise":U THEN ASSIGN pFieldValue = RowObject.dat-analise.
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
        WHEN "ge-codigo":U                 THEN ASSIGN pFieldValue = RowObject.ge-codigo.
        WHEN "qtd-itens-analisados":U      THEN ASSIGN pFieldValue = RowObject.qtd-itens-analisados.
        WHEN "qtd-itens-criticos":U        THEN ASSIGN pFieldValue = RowObject.qtd-itens-criticos.
        WHEN "qtd-itens-ruptura":U         THEN ASSIGN pFieldValue = RowObject.qtd-itens-ruptura.
        WHEN "qtd-itens-risco-ruptura":U   THEN ASSIGN pFieldValue = RowObject.qtd-itens-risco-ruptura.
        WHEN "qtd-itens-abaixo-segur":U    THEN ASSIGN pFieldValue = RowObject.qtd-itens-abaixo-segur.
        WHEN "qtd-itens-abaixo-pto-enc":U  THEN ASSIGN pFieldValue = RowObject.qtd-itens-abaixo-pto-enc.
        WHEN "qtd-itens-excesso":U         THEN ASSIGN pFieldValue = RowObject.qtd-itens-excesso.
        WHEN "qtd-itens-ociosos":U         THEN ASSIGN pFieldValue = RowObject.qtd-itens-ociosos.
        WHEN "qtd-transf-sugeridas":U      THEN ASSIGN pFieldValue = RowObject.qtd-transf-sugeridas.
        WHEN "qtd-compras-sugeridas":U     THEN ASSIGN pFieldValue = RowObject.qtd-compras-sugeridas.
        WHEN "int-1":U                     THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U                     THEN ASSIGN pFieldValue = RowObject.int-2.
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
    DEFINE OUTPUT PARAMETER pid-agregado LIKE ag-estoque-analise-agregado.id-agregado-analise NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    ASSIGN pid-agregado = RowObject.id-agregado-analise.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE goToKey :
    DEFINE INPUT PARAMETER pid-agregado LIKE ag-estoque-analise-agregado.id-agregado-analise NO-UNDO.
    FIND FIRST bfag-estoque-analise-agregado
         WHERE bfag-estoque-analise-agregado.id-agregado-analise = pid-agregado
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE bfag-estoque-analise-agregado THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfag-estoque-analise-agregado)).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryID :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-agregado-analise = c-id-agregado
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintID :
    DEFINE INPUT PARAMETER pid-agregado LIKE ag-estoque-analise-agregado.id-agregado-analise NO-UNDO.
    ASSIGN c-id-agregado = IF pid-agregado = ? THEN "":U ELSE TRIM(pid-agregado).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryAnalise :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-analise = c-id-analise
         BY {&TableName}.cod-estabel
         BY {&TableName}.ge-codigo
         BY {&TableName}.fm-codigo
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintAnalise :
    DEFINE INPUT PARAMETER pid-analise LIKE ag-estoque-analise-agregado.id-analise NO-UNDO.
    ASSIGN c-id-analise = IF pid-analise = ? THEN "":U ELSE TRIM(pid-analise).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryDashboard :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-analise = c-id-analise
           AND (c-cod-estabel = "":U OR {&TableName}.cod-estabel = c-cod-estabel)
           AND (i-ge-codigo = 0 OR {&TableName}.ge-codigo = i-ge-codigo)
           AND (c-fm-codigo = "":U OR {&TableName}.fm-codigo = c-fm-codigo)
           AND (c-cod-situacao = "":U OR {&TableName}.cod-situacao-estoque = c-cod-situacao)
           AND (c-cod-criticidade = "":U OR {&TableName}.cod-criticidade = c-cod-criticidade)
         BY {&TableName}.cod-estabel
         BY {&TableName}.ge-codigo
         BY {&TableName}.fm-codigo
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintDashboard :
    DEFINE INPUT PARAMETER pid-analise      LIKE ag-estoque-analise-agregado.id-analise          NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel     LIKE ag-estoque-analise-agregado.cod-estabel         NO-UNDO.
    DEFINE INPUT PARAMETER pge-codigo       LIKE ag-estoque-analise-agregado.ge-codigo           NO-UNDO.
    DEFINE INPUT PARAMETER pfm-codigo       LIKE ag-estoque-analise-agregado.fm-codigo           NO-UNDO.
    DEFINE INPUT PARAMETER pcod-situacao    LIKE ag-estoque-analise-agregado.cod-situacao-estoque NO-UNDO.
    DEFINE INPUT PARAMETER pcod-criticidade LIKE ag-estoque-analise-agregado.cod-criticidade     NO-UNDO.
    ASSIGN c-id-analise      = IF pid-analise = ? THEN "":U ELSE TRIM(pid-analise)
           c-cod-estabel     = IF pcod-estabel = ? THEN "":U ELSE TRIM(pcod-estabel)
           i-ge-codigo       = IF pge-codigo = ? THEN 0 ELSE pge-codigo
           c-fm-codigo       = IF pfm-codigo = ? THEN "":U ELSE TRIM(pfm-codigo)
           c-cod-situacao    = IF pcod-situacao = ? THEN "":U ELSE CAPS(TRIM(pcod-situacao))
           c-cod-criticidade = IF pcod-criticidade = ? THEN "":U ELSE CAPS(TRIM(pcod-criticidade)).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryPeriodo :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE (c-cod-empresa = "":U OR {&TableName}.cod-empresa = c-cod-empresa)
           AND (dt-dat-ini = ? OR {&TableName}.dat-analise >= dt-dat-ini)
           AND (dt-dat-fim = ? OR {&TableName}.dat-analise <= dt-dat-fim)
           AND (c-cod-estabel = "":U OR {&TableName}.cod-estabel = c-cod-estabel)
           AND (i-ge-codigo = 0 OR {&TableName}.ge-codigo = i-ge-codigo)
           AND (c-fm-codigo = "":U OR {&TableName}.fm-codigo = c-fm-codigo)
         BY {&TableName}.dat-analise DESCENDING
         BY {&TableName}.cod-estabel
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintPeriodo :
    DEFINE INPUT PARAMETER pcod-empresa LIKE ag-estoque-analise-agregado.cod-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pdat-ini     AS DATE                                      NO-UNDO.
    DEFINE INPUT PARAMETER pdat-fim     AS DATE                                      NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE ag-estoque-analise-agregado.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pge-codigo   LIKE ag-estoque-analise-agregado.ge-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pfm-codigo   LIKE ag-estoque-analise-agregado.fm-codigo   NO-UNDO.
    ASSIGN c-cod-empresa = IF pcod-empresa = ? THEN "":U ELSE TRIM(pcod-empresa)
           dt-dat-ini    = IF pdat-ini = ? THEN ? ELSE DATETIME(pdat-ini, 0)
           dt-dat-fim    = IF pdat-fim = ? THEN ? ELSE DATETIME(pdat-fim, 86399999)
           c-cod-estabel = IF pcod-estabel = ? THEN "":U ELSE TRIM(pcod-estabel)
           i-ge-codigo   = IF pge-codigo = ? THEN 0 ELSE pge-codigo
           c-fm-codigo   = IF pfm-codigo = ? THEN "":U ELSE TRIM(pfm-codigo).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryMain :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         BY {&TableName}.dat-analise DESCENDING
         BY {&TableName}.cod-estabel
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE beforeCreateRecord :
    ASSIGN RowObject.cod-situacao-estoque = IF RowObject.cod-situacao-estoque = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-situacao-estoque))
           RowObject.cod-criticidade      = IF RowObject.cod-criticidade = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-criticidade)).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateRecord :
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    IF NOT AVAILABLE RowObject THEN DO:
        RUN addValidationError (INPUT 58406, INPUT "":U).
        RETURN "NOK":U.
    END.

    ASSIGN pType = IF pType = ? THEN "":U ELSE CAPS(TRIM(pType)).
    IF LOOKUP(pType, "CREATE,UPDATE,DELETE":U) = 0 THEN DO:
        RUN addIntegrityError (INPUT 52530, INPUT "Operacao~~CREATE, UPDATE ou DELETE":U).
        RETURN "NOK":U.
    END.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN RETURN "NOK":U.

    IF CAN-DO("CREATE,UPDATE":U, CAPS(pType)) THEN DO:
        IF RowObject.id-agregado-analise = ? OR TRIM(RowObject.id-agregado-analise) = "":U
        OR RowObject.id-analise = ? OR TRIM(RowObject.id-analise) = "":U THEN DO:
            RUN addValidationError (INPUT 58407, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.dat-analise = ?
        OR RowObject.cod-empresa = ? OR TRIM(RowObject.cod-empresa) = "":U
        OR RowObject.cod-estabel = ? OR TRIM(RowObject.cod-estabel) = "":U
        OR RowObject.ge-codigo = ?
        OR RowObject.fm-codigo = ? OR TRIM(RowObject.fm-codigo) = "":U
        OR RowObject.cod-situacao-estoque = ? OR TRIM(RowObject.cod-situacao-estoque) = "":U
        OR RowObject.cod-criticidade = ? OR TRIM(RowObject.cod-criticidade) = "":U THEN DO:
            RUN addValidationError (INPUT 58408, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.qtd-itens-analisados = ? OR RowObject.qtd-itens-analisados < 0
        OR RowObject.qtd-itens-criticos = ? OR RowObject.qtd-itens-criticos < 0
        OR RowObject.qtd-itens-ruptura = ? OR RowObject.qtd-itens-ruptura < 0
        OR RowObject.qtd-itens-risco-ruptura = ? OR RowObject.qtd-itens-risco-ruptura < 0
        OR RowObject.qtd-itens-abaixo-segur = ? OR RowObject.qtd-itens-abaixo-segur < 0
        OR RowObject.qtd-itens-abaixo-pto-enc = ? OR RowObject.qtd-itens-abaixo-pto-enc < 0
        OR RowObject.qtd-itens-excesso = ? OR RowObject.qtd-itens-excesso < 0
        OR RowObject.qtd-itens-ociosos = ? OR RowObject.qtd-itens-ociosos < 0
        OR RowObject.qtd-transf-sugeridas = ? OR RowObject.qtd-transf-sugeridas < 0
        OR RowObject.qtd-compras-sugeridas = ? OR RowObject.qtd-compras-sugeridas < 0 THEN DO:
            RUN addValidationError (INPUT 58409, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.qtd-itens-criticos > RowObject.qtd-itens-analisados
        OR RowObject.qtd-itens-ruptura > RowObject.qtd-itens-analisados
        OR RowObject.qtd-itens-risco-ruptura > RowObject.qtd-itens-analisados
        OR RowObject.qtd-itens-abaixo-segur > RowObject.qtd-itens-analisados
        OR RowObject.qtd-itens-abaixo-pto-enc > RowObject.qtd-itens-analisados
        OR RowObject.qtd-itens-excesso > RowObject.qtd-itens-analisados
        OR RowObject.qtd-itens-ociosos > RowObject.qtd-itens-analisados THEN DO:
            RUN addValidationError (INPUT 58410, INPUT "":U).
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
    DEFINE BUFFER bIntegrityOriginal FOR ag-estoque-analise-agregado.
    DEFINE BUFFER bIntegrityDuplicado FOR ag-estoque-analise-agregado.
    DEFINE BUFFER bIntegrityAnalise FOR ag-estoque-analise.

    DO TRANSACTION:
        IF pType <> "CREATE":U THEN DO:
            FIND bIntegrityOriginal WHERE ROWID(bIntegrityOriginal) = RowObject.r-Rowid
                 EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF LOCKED(bIntegrityOriginal) THEN DO:
                RUN addIntegrityError (INPUT 53420, INPUT "registro em uso por outro processo":U).
                RETURN "NOK":U.
            END.
            IF NOT AVAILABLE bIntegrityOriginal THEN DO:
                RUN addIntegrityError (INPUT 57401, INPUT "ag-estoque-analise-agregado":U).
                RETURN "NOK":U.
            END.
            IF RowObject.id-agregado-analise <> bIntegrityOriginal.id-agregado-analise
            OR RowObject.id-analise <> bIntegrityOriginal.id-analise
            OR RowObject.cod-empresa <> bIntegrityOriginal.cod-empresa
            OR RowObject.dat-analise <> bIntegrityOriginal.dat-analise
            OR RowObject.cod-estabel <> bIntegrityOriginal.cod-estabel
            OR RowObject.ge-codigo <> bIntegrityOriginal.ge-codigo
            OR RowObject.fm-codigo <> bIntegrityOriginal.fm-codigo
            OR RowObject.cod-situacao-estoque <> bIntegrityOriginal.cod-situacao-estoque
            OR RowObject.cod-criticidade <> bIntegrityOriginal.cod-criticidade THEN DO:
                RUN addIntegrityError (INPUT 53420, INPUT "alterar identificadores, vinculos ou contexto da fotografia":U).
                RETURN "NOK":U.
            END.
        END.
        FIND FIRST bIntegrityAnalise
             WHERE bIntegrityAnalise.id-analise = RowObject.id-analise
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED(bIntegrityAnalise) THEN DO:
            RUN addIntegrityError (INPUT 53420, INPUT "analise em uso por outro processo":U).
            RETURN "NOK":U.
        END.
        IF NOT AVAILABLE bIntegrityAnalise THEN DO:
            RUN addIntegrityError (INPUT 57401, INPUT "ag-estoque-analise":U).
            RETURN "NOK":U.
        END.
        IF RowObject.cod-empresa = ? OR TRIM(RowObject.cod-empresa) = "":U
        OR RowObject.cod-empresa <> bIntegrityAnalise.cod-empresa THEN DO:
            RUN addIntegrityError (INPUT 52530, INPUT "cod-empresa~~empresa da analise informada":U).
            RETURN "NOK":U.
        END.
        IF RowObject.dat-analise <> bIntegrityAnalise.dat-analise THEN DO:
            RUN addIntegrityError (INPUT 52530, INPUT "dat-analise~~data da fotografia do cabecalho":U).
            RETURN "NOK":U.
        END.
        /* Apos CONCLUIDO, somente os dois contadores de recomendacoes podem mudar.
           As dimensoes, metricas de estoque e campos livres permanecem fotografados. */
        IF bIntegrityAnalise.cod-status = ?
        OR LOOKUP(bIntegrityAnalise.cod-status, "PENDENTE,PROCESSANDO":U) = 0 THEN DO:
            IF pType <> "UPDATE":U
            OR bIntegrityAnalise.cod-status <> "CONCLUIDO":U THEN DO:
                RUN addIntegrityError (INPUT 53420, INPUT "modificar agregado de analise encerrada":U).
                RETURN "NOK":U.
            END.
            IF RowObject.id-agregado-analise <> bIntegrityOriginal.id-agregado-analise
            OR RowObject.id-analise <> bIntegrityOriginal.id-analise
            OR RowObject.dat-analise <> bIntegrityOriginal.dat-analise
            OR RowObject.cod-empresa <> bIntegrityOriginal.cod-empresa
            OR RowObject.cod-estabel <> bIntegrityOriginal.cod-estabel
            OR RowObject.ge-codigo <> bIntegrityOriginal.ge-codigo
            OR RowObject.fm-codigo <> bIntegrityOriginal.fm-codigo
            OR RowObject.cod-situacao-estoque <> bIntegrityOriginal.cod-situacao-estoque
            OR RowObject.cod-criticidade <> bIntegrityOriginal.cod-criticidade
            OR RowObject.qtd-itens-analisados <> bIntegrityOriginal.qtd-itens-analisados
            OR RowObject.qtd-itens-criticos <> bIntegrityOriginal.qtd-itens-criticos
            OR RowObject.qtd-itens-ruptura <> bIntegrityOriginal.qtd-itens-ruptura
            OR RowObject.qtd-itens-risco-ruptura <> bIntegrityOriginal.qtd-itens-risco-ruptura
            OR RowObject.qtd-itens-abaixo-segur <> bIntegrityOriginal.qtd-itens-abaixo-segur
            OR RowObject.qtd-itens-abaixo-pto-enc <> bIntegrityOriginal.qtd-itens-abaixo-pto-enc
            OR RowObject.qtd-itens-excesso <> bIntegrityOriginal.qtd-itens-excesso
            OR RowObject.qtd-itens-ociosos <> bIntegrityOriginal.qtd-itens-ociosos
            OR RowObject.char-1 <> bIntegrityOriginal.char-1
            OR RowObject.char-2 <> bIntegrityOriginal.char-2
            OR RowObject.dec-1 <> bIntegrityOriginal.dec-1
            OR RowObject.dec-2 <> bIntegrityOriginal.dec-2
            OR RowObject.int-1 <> bIntegrityOriginal.int-1
            OR RowObject.int-2 <> bIntegrityOriginal.int-2
            OR RowObject.log-1 <> bIntegrityOriginal.log-1
            OR RowObject.log-2 <> bIntegrityOriginal.log-2
            OR RowObject.data-1 <> bIntegrityOriginal.data-1
            OR RowObject.data-2 <> bIntegrityOriginal.data-2 THEN DO:
                RUN addIntegrityError (INPUT 53420, INPUT "alterar fotografia do agregado; somente contadores de recomendacoes sao atualizaveis":U).
                RETURN "NOK":U.
            END.
        END.
        IF pType = "DELETE":U THEN RETURN "OK":U.
        IF CAN-FIND(FIRST bIntegrityDuplicado NO-LOCK
                    WHERE bIntegrityDuplicado.id-agregado-analise = RowObject.id-agregado-analise
                      AND (pType = "CREATE":U
                           OR ROWID(bIntegrityDuplicado) <> RowObject.r-Rowid)) THEN DO:
            RUN addIntegrityError (INPUT 46216, INPUT "ag-estoque-analise-agregado":U).
            RETURN "NOK":U.
        END.
        IF CAN-FIND(FIRST bIntegrityDuplicado NO-LOCK
                    WHERE bIntegrityDuplicado.id-analise = RowObject.id-analise
                      AND bIntegrityDuplicado.cod-estabel = RowObject.cod-estabel
                      AND bIntegrityDuplicado.ge-codigo = RowObject.ge-codigo
                      AND bIntegrityDuplicado.fm-codigo = RowObject.fm-codigo
                      AND bIntegrityDuplicado.cod-situacao-estoque = RowObject.cod-situacao-estoque
                      AND bIntegrityDuplicado.cod-criticidade = RowObject.cod-criticidade
                      AND (pType = "CREATE":U
                           OR ROWID(bIntegrityDuplicado) <> RowObject.r-Rowid)) THEN DO:
            RUN addIntegrityError (INPUT 46216, INPUT "ag-estoque-analise-agregado":U).
            RETURN "NOK":U.
        END.
        RETURN "OK":U.
        FINALLY:
            RELEASE bIntegrityAnalise.
            RELEASE bIntegrityDuplicado.
            RELEASE bIntegrityOriginal.
        END FINALLY.
    END.
END PROCEDURE.
