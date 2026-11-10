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

{include/i-prgvrs.i BOIN02059 2.00.00.000 }
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BOIN02059 MUT}
&ENDIF

/*---------------------------------------------------------------------------
    File       : boin02059.p
    Purpose    : DBO para responsaveis operacionais do Agente de Estoque.
  ------------------------------------------------------------------------*/

&GLOBAL-DEFINE DBOName BOIN02059
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ag-estoque-responsavel-estab
&GLOBAL-DEFINE TableLabel Agente Estoque - Responsaveis
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES
&GLOBAL-DEFINE KeyField1 id-respons-estab

{inbo/boin02059.i RowObject}
{java/boRest.i}
{method/dboqry.i}

DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-id-respons-estab     LIKE ag-estoque-responsavel-estab.id-respons-estab     NO-UNDO.
DEFINE VARIABLE c-cod-empresa          LIKE ag-estoque-responsavel-estab.cod-empresa          INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-estabel          LIKE ag-estoque-responsavel-estab.cod-estabel          INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-usuario          LIKE ag-estoque-responsavel-estab.cod-usuario          INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-responsabilidade LIKE ag-estoque-responsavel-estab.cod-responsabilidade INITIAL "" NO-UNDO.
DEFINE VARIABLE l-log-ativo            LIKE ag-estoque-responsavel-estab.log-ativo            INITIAL ?  NO-UNDO.

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
        WHEN "id-respons-estab":U     THEN ASSIGN pFieldValue = RowObject.id-respons-estab.
        WHEN "cod-empresa":U          THEN ASSIGN pFieldValue = RowObject.cod-empresa.
        WHEN "cod-estabel":U          THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-usuario":U          THEN ASSIGN pFieldValue = RowObject.cod-usuario.
        WHEN "cod-responsabilidade":U THEN ASSIGN pFieldValue = RowObject.cod-responsabilidade.
        WHEN "cod-usuar-atualiz":U    THEN ASSIGN pFieldValue = RowObject.cod-usuar-atualiz.
        WHEN "char-1":U               THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U               THEN ASSIGN pFieldValue = RowObject.char-2.
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
        WHEN "dat-criacao":U     THEN ASSIGN pFieldValue = RowObject.dat-criacao.
        WHEN "dat-atualizacao":U THEN ASSIGN pFieldValue = RowObject.dat-atualizacao.
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
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getLogField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL   NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "log-ativo":U THEN ASSIGN pFieldValue = RowObject.log-ativo.
        WHEN "log-1":U     THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U     THEN ASSIGN pFieldValue = RowObject.log-2.
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
    DEFINE OUTPUT PARAMETER pid-respons-estab LIKE ag-estoque-responsavel-estab.id-respons-estab NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    ASSIGN pid-respons-estab = RowObject.id-respons-estab.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE goToKey :
    DEFINE INPUT PARAMETER pid-respons-estab LIKE ag-estoque-responsavel-estab.id-respons-estab NO-UNDO.
    FIND FIRST bfag-estoque-responsavel-estab
         WHERE bfag-estoque-responsavel-estab.id-respons-estab = pid-respons-estab
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE bfag-estoque-responsavel-estab THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfag-estoque-responsavel-estab)).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryID :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-respons-estab = c-id-respons-estab
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintID :
    DEFINE INPUT PARAMETER pid-respons-estab LIKE ag-estoque-responsavel-estab.id-respons-estab NO-UNDO.
    ASSIGN c-id-respons-estab = IF pid-respons-estab = ? THEN "":U ELSE TRIM(pid-respons-estab).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryEtapa :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-empresa = c-cod-empresa
           AND {&TableName}.cod-estabel = c-cod-estabel
           AND {&TableName}.cod-responsabilidade = c-cod-responsabilidade
           AND (l-log-ativo = ? OR {&TableName}.log-ativo = l-log-ativo)
         BY {&TableName}.cod-usuario
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintEtapa :
    DEFINE INPUT PARAMETER pcod-empresa          LIKE ag-estoque-responsavel-estab.cod-empresa          NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel          LIKE ag-estoque-responsavel-estab.cod-estabel          NO-UNDO.
    DEFINE INPUT PARAMETER pcod-responsabilidade LIKE ag-estoque-responsavel-estab.cod-responsabilidade NO-UNDO.
    DEFINE INPUT PARAMETER plog-ativo            LIKE ag-estoque-responsavel-estab.log-ativo            NO-UNDO.
    ASSIGN c-cod-empresa          = IF pcod-empresa = ? THEN "":U ELSE TRIM(pcod-empresa)
           c-cod-estabel          = IF pcod-estabel = ? THEN "":U ELSE TRIM(pcod-estabel)
           c-cod-responsabilidade = IF pcod-responsabilidade = ? THEN "":U ELSE CAPS(TRIM(pcod-responsabilidade))
           l-log-ativo            = plog-ativo.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryUsuario :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-usuario = c-cod-usuario
           AND (l-log-ativo = ? OR {&TableName}.log-ativo = l-log-ativo)
           AND (c-cod-estabel = "":U OR {&TableName}.cod-estabel = c-cod-estabel)
         BY {&TableName}.cod-estabel
         BY {&TableName}.cod-responsabilidade
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintUsuario :
    DEFINE INPUT PARAMETER pcod-usuario LIKE ag-estoque-responsavel-estab.cod-usuario NO-UNDO.
    DEFINE INPUT PARAMETER plog-ativo   LIKE ag-estoque-responsavel-estab.log-ativo   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE ag-estoque-responsavel-estab.cod-estabel NO-UNDO.
    ASSIGN c-cod-usuario = IF pcod-usuario = ? THEN "":U ELSE TRIM(pcod-usuario)
           l-log-ativo   = plog-ativo
           c-cod-estabel = IF pcod-estabel = ? THEN "":U ELSE TRIM(pcod-estabel).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryMain :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         BY {&TableName}.cod-empresa
         BY {&TableName}.cod-estabel
         BY {&TableName}.cod-responsabilidade
         BY {&TableName}.cod-usuario
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE beforeCreateRecord :
    ASSIGN RowObject.id-respons-estab     = IF RowObject.id-respons-estab = ? THEN "":U ELSE TRIM(RowObject.id-respons-estab)
           RowObject.cod-empresa          = IF RowObject.cod-empresa = ? THEN "":U ELSE TRIM(RowObject.cod-empresa)
           RowObject.cod-estabel          = IF RowObject.cod-estabel = ? THEN "":U ELSE TRIM(RowObject.cod-estabel)
           RowObject.cod-usuario          = IF RowObject.cod-usuario = ? THEN "":U ELSE TRIM(RowObject.cod-usuario)
           RowObject.cod-responsabilidade = IF RowObject.cod-responsabilidade = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-responsabilidade))
           RowObject.cod-usuar-atualiz    = IF RowObject.cod-usuar-atualiz = ? THEN "":U ELSE TRIM(RowObject.cod-usuar-atualiz).
    IF RowObject.log-ativo = ? THEN ASSIGN RowObject.log-ativo = YES.
    IF RowObject.dat-criacao = ? THEN ASSIGN RowObject.dat-criacao = NOW.
    IF RowObject.dat-atualizacao = ? THEN ASSIGN RowObject.dat-atualizacao = RowObject.dat-criacao.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE beforeUpdateRecord :
    ASSIGN RowObject.id-respons-estab     = IF RowObject.id-respons-estab = ? THEN "":U ELSE TRIM(RowObject.id-respons-estab)
           RowObject.cod-empresa          = IF RowObject.cod-empresa = ? THEN "":U ELSE TRIM(RowObject.cod-empresa)
           RowObject.cod-estabel          = IF RowObject.cod-estabel = ? THEN "":U ELSE TRIM(RowObject.cod-estabel)
           RowObject.cod-usuario          = IF RowObject.cod-usuario = ? THEN "":U ELSE TRIM(RowObject.cod-usuario)
           RowObject.cod-responsabilidade = IF RowObject.cod-responsabilidade = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-responsabilidade))
           RowObject.cod-usuar-atualiz    = IF RowObject.cod-usuar-atualiz = ? THEN "":U ELSE TRIM(RowObject.cod-usuar-atualiz)
           RowObject.dat-atualizacao      = NOW.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateRecord :
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    IF NOT AVAILABLE RowObject THEN DO:
        RUN addValidationError (INPUT 58362, INPUT "":U).
        RETURN "NOK":U.
    END.

    ASSIGN pType = IF pType = ? THEN "":U ELSE CAPS(TRIM(pType)).
    IF LOOKUP(pType, "CREATE,UPDATE,DELETE":U) = 0 THEN DO:
        RUN addIntegrityError (INPUT 52530, INPUT "Operacao~~CREATE, UPDATE ou DELETE":U).
        RETURN "NOK":U.
    END.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN RETURN "NOK":U.

    IF CAN-DO("CREATE,UPDATE":U, CAPS(pType)) THEN DO:
        IF TRIM(RowObject.id-respons-estab) = "":U THEN DO:
            RUN addValidationError (INPUT 58363, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF TRIM(RowObject.cod-empresa) = "":U
        OR TRIM(RowObject.cod-estabel) = "":U
        OR TRIM(RowObject.cod-usuario) = "":U
        OR TRIM(RowObject.cod-responsabilidade) = "":U THEN DO:
            RUN addValidationError (INPUT 58364, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF LOOKUP(CAPS(RowObject.cod-responsabilidade),
                  "APROVAR_TRANSFERENCIA,GERAR_NF_TRANSFERENCIA":U) = 0 THEN DO:
            RUN addValidationError (INPUT 58365, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            RUN addValidationError (INPUT 58366, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel
                          AND TRIM(STRING(estabelec.ep-codigo)) = TRIM(RowObject.cod-empresa)) THEN DO:
            RUN addIntegrityError (INPUT 52530, INPUT "cod-estabel~~estabelecimento pertencente a empresa informada":U).
            RETURN "NOK":U.
        END.

        IF NOT CAN-FIND(FIRST usuar_mestre NO-LOCK
                        WHERE usuar_mestre.cod_usuario = RowObject.cod-usuario) THEN DO:
            RUN addValidationError (INPUT 58367, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.log-ativo = ? THEN DO:
            RUN addValidationError (INPUT 58368, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.dat-criacao = ? OR RowObject.dat-atualizacao = ? THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT (IF (RowObject.dat-criacao = ?) THEN "Data Cria‡Æo":U
                                          ELSE "Data Atualiza‡Æo":U)).
            RETURN "NOK":U.
        END.

        IF RowObject.dat-atualizacao < RowObject.dat-criacao THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "Data Atualiza‡Æo":U + "~~Data igual ou posterior … cria‡Æo":U).
            RETURN "NOK":U.
        END.

        IF CAPS(pType) = "CREATE":U
        AND CAN-FIND(FIRST bfag-estoque-responsavel-estab
                     WHERE bfag-estoque-responsavel-estab.cod-empresa = RowObject.cod-empresa
                       AND bfag-estoque-responsavel-estab.cod-estabel = RowObject.cod-estabel
                       AND bfag-estoque-responsavel-estab.cod-usuario = RowObject.cod-usuario
                       AND bfag-estoque-responsavel-estab.cod-responsabilidade = RowObject.cod-responsabilidade) THEN DO:
            RUN addValidationError (INPUT 58369, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF CAPS(pType) = "UPDATE":U
        AND CAN-FIND(FIRST bfag-estoque-responsavel-estab
                     WHERE bfag-estoque-responsavel-estab.cod-empresa = RowObject.cod-empresa
                       AND bfag-estoque-responsavel-estab.cod-estabel = RowObject.cod-estabel
                       AND bfag-estoque-responsavel-estab.cod-usuario = RowObject.cod-usuario
                       AND bfag-estoque-responsavel-estab.cod-responsabilidade = RowObject.cod-responsabilidade
                       AND ROWID(bfag-estoque-responsavel-estab) <> RowObject.r-Rowid) THEN DO:
            RUN addValidationError (INPUT 58369, INPUT "":U).
            RETURN "NOK":U.
        END.
    END.

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
