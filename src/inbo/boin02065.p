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

{include/i-prgvrs.i BOIN02065 2.00.00.002 }
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BOIN02065 MUT}
&ENDIF

/*---------------------------------------------------------------------------
    File       : boin02065.p
    Purpose    : DBO para relacionamentos de transferencia entre
                 estabelecimentos do Agente de Estoque.
  ------------------------------------------------------------------------*/

&GLOBAL-DEFINE DBOName BOIN02065
&GLOBAL-DEFINE DBOVersion 2.00.00.002
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ag-estoque-relac-transf-estab
&GLOBAL-DEFINE TableLabel Agente Estoque - Relacionamento Transferencia
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES
&GLOBAL-DEFINE KeyField1 id-relac-transf

{inbo/boin02065.i RowObject}
{java/boRest.i}
{method/dboqry.i}

DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-id-relac-transf  LIKE ag-estoque-relac-transf-estab.id-relac-transf  NO-UNDO.
DEFINE VARIABLE c-cod-empresa      LIKE ag-estoque-relac-transf-estab.cod-empresa      INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-estabel-orig LIKE ag-estoque-relac-transf-estab.cod-estabel-orig INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-estabel-dest LIKE ag-estoque-relac-transf-estab.cod-estabel-dest INITIAL "" NO-UNDO.
DEFINE VARIABLE c-it-codigo        LIKE ag-estoque-relac-transf-estab.it-codigo        INITIAL "" NO-UNDO.
DEFINE VARIABLE c-fm-codigo        LIKE ag-estoque-relac-transf-estab.fm-codigo        INITIAL "" NO-UNDO.
DEFINE VARIABLE i-ind-sit-relac    LIKE ag-estoque-relac-transf-estab.ind-sit-relac    INITIAL 0  NO-UNDO.

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
        WHEN "id-relac-transf":U   THEN ASSIGN pFieldValue = RowObject.id-relac-transf.
        WHEN "cod-empresa":U       THEN ASSIGN pFieldValue = RowObject.cod-empresa.
        WHEN "cod-estabel-orig":U  THEN ASSIGN pFieldValue = RowObject.cod-estabel-orig.
        WHEN "cod-estabel-dest":U  THEN ASSIGN pFieldValue = RowObject.cod-estabel-dest.
        WHEN "fm-codigo":U         THEN ASSIGN pFieldValue = RowObject.fm-codigo.
        WHEN "it-codigo":U         THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "cod-usuar-criacao":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-criacao.
        WHEN "cod-usuar-atualiz":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-atualiz.
        WHEN "char-1":U            THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U            THEN ASSIGN pFieldValue = RowObject.char-2.
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
        WHEN "val-custo-transp":U THEN ASSIGN pFieldValue = RowObject.val-custo-transp.
        WHEN "val-custo-operac":U THEN ASSIGN pFieldValue = RowObject.val-custo-operac.
        WHEN "dec-1":U            THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U            THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getIntField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER   NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "ind-tip-relac":U      THEN ASSIGN pFieldValue = RowObject.ind-tip-relac.
        WHEN "qtd-dias-lead-time":U THEN ASSIGN pFieldValue = RowObject.qtd-dias-lead-time.
        WHEN "ind-sit-relac":U      THEN ASSIGN pFieldValue = RowObject.ind-sit-relac.
        WHEN "int-1":U              THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U              THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getLogField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL   NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "log-custo-transp-item":U THEN ASSIGN pFieldValue = RowObject.log-custo-transp-item.
        WHEN "log-custo-operac-item":U THEN ASSIGN pFieldValue = RowObject.log-custo-operac-item.
        WHEN "log-1":U                 THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U                 THEN ASSIGN pFieldValue = RowObject.log-2.
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
    DEFINE OUTPUT PARAMETER pid-relac-transf LIKE ag-estoque-relac-transf-estab.id-relac-transf NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    ASSIGN pid-relac-transf = RowObject.id-relac-transf.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE goToKey :
    DEFINE INPUT PARAMETER pid-relac-transf LIKE ag-estoque-relac-transf-estab.id-relac-transf NO-UNDO.
    FIND FIRST bfag-estoque-relac-transf-estab
         WHERE bfag-estoque-relac-transf-estab.id-relac-transf = pid-relac-transf
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE bfag-estoque-relac-transf-estab THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfag-estoque-relac-transf-estab)).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryID :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-relac-transf = c-id-relac-transf
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintID :
    DEFINE INPUT PARAMETER pid-relac-transf LIKE ag-estoque-relac-transf-estab.id-relac-transf NO-UNDO.
    ASSIGN c-id-relac-transf = IF pid-relac-transf = ? THEN "":U ELSE TRIM(pid-relac-transf).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryDestino :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-estabel-dest = c-cod-estabel-dest
           AND (c-cod-estabel-orig = "":U OR {&TableName}.cod-estabel-orig = c-cod-estabel-orig)
           AND (i-ind-sit-relac = 0 OR {&TableName}.ind-sit-relac = i-ind-sit-relac)
         BY {&TableName}.cod-estabel-orig
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintDestino :
    DEFINE INPUT PARAMETER pcod-estabel-dest LIKE ag-estoque-relac-transf-estab.cod-estabel-dest NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel-orig LIKE ag-estoque-relac-transf-estab.cod-estabel-orig NO-UNDO.
    DEFINE INPUT PARAMETER pind-sit-relac    LIKE ag-estoque-relac-transf-estab.ind-sit-relac    NO-UNDO.
    ASSIGN c-cod-estabel-dest = IF pcod-estabel-dest = ? THEN "":U ELSE TRIM(pcod-estabel-dest)
           c-cod-estabel-orig = IF pcod-estabel-orig = ? THEN "":U ELSE TRIM(pcod-estabel-orig)
           i-ind-sit-relac    = IF pind-sit-relac = ? THEN 0 ELSE pind-sit-relac.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryItem :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.it-codigo = c-it-codigo
           AND (c-cod-estabel-orig = "":U OR {&TableName}.cod-estabel-orig = c-cod-estabel-orig)
           AND (c-cod-estabel-dest = "":U OR {&TableName}.cod-estabel-dest = c-cod-estabel-dest)
         BY {&TableName}.cod-estabel-orig
         BY {&TableName}.cod-estabel-dest
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintItem :
    DEFINE INPUT PARAMETER pit-codigo        LIKE ag-estoque-relac-transf-estab.it-codigo        NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel-orig LIKE ag-estoque-relac-transf-estab.cod-estabel-orig NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel-dest LIKE ag-estoque-relac-transf-estab.cod-estabel-dest NO-UNDO.
    ASSIGN c-it-codigo        = IF pit-codigo = ? THEN "":U ELSE TRIM(pit-codigo)
           c-cod-estabel-orig = IF pcod-estabel-orig = ? THEN "":U ELSE TRIM(pcod-estabel-orig)
           c-cod-estabel-dest = IF pcod-estabel-dest = ? THEN "":U ELSE TRIM(pcod-estabel-dest).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryFamilia :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.fm-codigo = c-fm-codigo
           AND (c-cod-estabel-orig = "":U OR {&TableName}.cod-estabel-orig = c-cod-estabel-orig)
           AND (c-cod-estabel-dest = "":U OR {&TableName}.cod-estabel-dest = c-cod-estabel-dest)
         BY {&TableName}.cod-estabel-orig
         BY {&TableName}.cod-estabel-dest
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintFamilia :
    DEFINE INPUT PARAMETER pfm-codigo        LIKE ag-estoque-relac-transf-estab.fm-codigo        NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel-orig LIKE ag-estoque-relac-transf-estab.cod-estabel-orig NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel-dest LIKE ag-estoque-relac-transf-estab.cod-estabel-dest NO-UNDO.
    ASSIGN c-fm-codigo        = IF pfm-codigo = ? THEN "":U ELSE TRIM(pfm-codigo)
           c-cod-estabel-orig = IF pcod-estabel-orig = ? THEN "":U ELSE TRIM(pcod-estabel-orig)
           c-cod-estabel-dest = IF pcod-estabel-dest = ? THEN "":U ELSE TRIM(pcod-estabel-dest).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryMain :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         BY {&TableName}.cod-empresa
         BY {&TableName}.cod-estabel-dest
         BY {&TableName}.cod-estabel-orig
         BY {&TableName}.ind-tip-relac
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE beforeCreateRecord :
    ASSIGN RowObject.id-relac-transf  = IF RowObject.id-relac-transf = ? THEN "":U ELSE TRIM(RowObject.id-relac-transf)
           RowObject.cod-empresa      = IF RowObject.cod-empresa = ? THEN "":U ELSE TRIM(RowObject.cod-empresa)
           RowObject.cod-estabel-orig = IF RowObject.cod-estabel-orig = ? THEN "":U ELSE TRIM(RowObject.cod-estabel-orig)
           RowObject.cod-estabel-dest = IF RowObject.cod-estabel-dest = ? THEN "":U ELSE TRIM(RowObject.cod-estabel-dest)
           RowObject.fm-codigo        = IF RowObject.fm-codigo = ? THEN "":U ELSE TRIM(RowObject.fm-codigo)
           RowObject.it-codigo        = IF RowObject.it-codigo = ? THEN "":U ELSE TRIM(RowObject.it-codigo)
           RowObject.cod-usuar-criacao = IF RowObject.cod-usuar-criacao = ? THEN "":U ELSE TRIM(RowObject.cod-usuar-criacao)
           RowObject.cod-usuar-atualiz = IF RowObject.cod-usuar-atualiz = ? THEN "":U ELSE TRIM(RowObject.cod-usuar-atualiz).
    IF RowObject.dat-criacao = ? THEN ASSIGN RowObject.dat-criacao = NOW.
    IF RowObject.dat-atualizacao = ? THEN ASSIGN RowObject.dat-atualizacao = RowObject.dat-criacao.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE beforeUpdateRecord :
    ASSIGN RowObject.id-relac-transf   = IF RowObject.id-relac-transf = ? THEN "":U ELSE TRIM(RowObject.id-relac-transf)
           RowObject.cod-empresa       = IF RowObject.cod-empresa = ? THEN "":U ELSE TRIM(RowObject.cod-empresa)
           RowObject.cod-estabel-orig  = IF RowObject.cod-estabel-orig = ? THEN "":U ELSE TRIM(RowObject.cod-estabel-orig)
           RowObject.cod-estabel-dest  = IF RowObject.cod-estabel-dest = ? THEN "":U ELSE TRIM(RowObject.cod-estabel-dest)
           RowObject.fm-codigo         = IF RowObject.fm-codigo = ? THEN "":U ELSE TRIM(RowObject.fm-codigo)
           RowObject.it-codigo         = IF RowObject.it-codigo = ? THEN "":U ELSE TRIM(RowObject.it-codigo)
           RowObject.cod-usuar-atualiz = IF RowObject.cod-usuar-atualiz = ? THEN "":U ELSE TRIM(RowObject.cod-usuar-atualiz)
           RowObject.dat-atualizacao   = NOW.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateRecord :
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    IF NOT AVAILABLE RowObject THEN DO:
        RUN addValidationError (INPUT 58432, INPUT "":U).
        RETURN "NOK":U.
    END.

    ASSIGN pType = IF pType = ? THEN "":U ELSE CAPS(TRIM(pType)).
    IF LOOKUP(pType, "CREATE,UPDATE,DELETE":U) = 0 THEN DO:
        RUN addIntegrityError (INPUT 52530, INPUT "Operacao~~CREATE, UPDATE ou DELETE":U).
        RETURN "NOK":U.
    END.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN RETURN "NOK":U.

    IF CAN-DO("CREATE,UPDATE":U, CAPS(pType)) THEN DO:
        IF RowObject.id-relac-transf = ? OR TRIM(RowObject.id-relac-transf) = "":U
        OR RowObject.cod-empresa = ? OR TRIM(RowObject.cod-empresa) = "":U
        OR RowObject.cod-estabel-orig = ? OR TRIM(RowObject.cod-estabel-orig) = "":U
        OR RowObject.cod-estabel-dest = ? OR TRIM(RowObject.cod-estabel-dest) = "":U THEN DO:
            RUN addValidationError (INPUT 58433, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.cod-estabel-orig = RowObject.cod-estabel-dest THEN DO:
            RUN addValidationError (INPUT 58434, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel-orig) THEN DO:
            RUN addValidationError (INPUT 58435, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel-dest) THEN DO:
            RUN addValidationError (INPUT 58436, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel-orig
                          AND TRIM(STRING(estabelec.ep-codigo)) = TRIM(RowObject.cod-empresa)) THEN DO:
            RUN addIntegrityError (INPUT 52530, INPUT "cod-estabel-orig~~estabelecimento pertencente a empresa informada":U).
            RETURN "NOK":U.
        END.
        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel-dest
                          AND TRIM(STRING(estabelec.ep-codigo)) = TRIM(RowObject.cod-empresa)) THEN DO:
            RUN addIntegrityError (INPUT 52530, INPUT "cod-estabel-dest~~estabelecimento pertencente a empresa informada":U).
            RETURN "NOK":U.
        END.

        IF RowObject.ind-tip-relac = ? OR RowObject.ind-tip-relac < 1 OR RowObject.ind-tip-relac > 3 THEN DO:
            RUN addValidationError (INPUT 58437, INPUT "":U).
            RETURN "NOK":U.
        END.

        CASE RowObject.ind-tip-relac:
            WHEN 1 THEN DO:
                IF TRIM(RowObject.fm-codigo) <> "":U OR TRIM(RowObject.it-codigo) <> "":U THEN DO:
                    RUN addValidationError (INPUT 58438, INPUT "":U).
                    RETURN "NOK":U.
                END.
            END.
            WHEN 2 THEN DO:
                IF TRIM(RowObject.fm-codigo) = "":U OR TRIM(RowObject.it-codigo) <> "":U THEN DO:
                    RUN addValidationError (INPUT 58439, INPUT "":U).
                    RETURN "NOK":U.
                END.
                IF NOT CAN-FIND(FIRST familia-mat NO-LOCK
                                WHERE familia-mat.fm-codigo = RowObject.fm-codigo) THEN DO:
                    RUN addValidationError (INPUT 58440, INPUT "":U).
                    RETURN "NOK":U.
                END.
            END.
            WHEN 3 THEN DO:
                IF TRIM(RowObject.it-codigo) = "":U THEN DO:
                    RUN addValidationError (INPUT 58441, INPUT "":U).
                    RETURN "NOK":U.
                END.
                IF NOT CAN-FIND(FIRST item-mat NO-LOCK
                                WHERE item-mat.it-codigo = RowObject.it-codigo)
                OR (TRIM(RowObject.fm-codigo) <> "":U
                    AND NOT CAN-FIND(FIRST item NO-LOCK
                                     WHERE item.it-codigo = RowObject.it-codigo
                                       AND item.fm-codigo = RowObject.fm-codigo)) THEN DO:
                    RUN addValidationError (INPUT 58442, INPUT "":U).
                    RETURN "NOK":U.
                END.
            END.
        END CASE.

        IF RowObject.qtd-dias-lead-time = ? OR RowObject.qtd-dias-lead-time <= 0 THEN DO:
            RUN addValidationError (INPUT 58443, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.val-custo-transp = ? OR RowObject.val-custo-transp < 0 THEN DO:
            RUN addValidationError (INPUT 58444, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.val-custo-operac = ?
        OR RowObject.val-custo-operac < 0 THEN DO:
            RUN addValidationError (INPUT 58445, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.log-custo-transp-item = ?
        OR RowObject.log-custo-operac-item = ? THEN DO:
            RUN addValidationError (INPUT 58446, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.ind-sit-relac = ? OR LOOKUP(STRING(RowObject.ind-sit-relac), "1,2":U) = 0 THEN DO:
            RUN addValidationError (INPUT 58447, INPUT "":U).
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
        AND CAN-FIND(FIRST bfag-estoque-relac-transf-estab
                     WHERE bfag-estoque-relac-transf-estab.cod-empresa = RowObject.cod-empresa
                       AND bfag-estoque-relac-transf-estab.cod-estabel-orig = RowObject.cod-estabel-orig
                       AND bfag-estoque-relac-transf-estab.cod-estabel-dest = RowObject.cod-estabel-dest
                       AND bfag-estoque-relac-transf-estab.ind-tip-relac = RowObject.ind-tip-relac
                       AND bfag-estoque-relac-transf-estab.fm-codigo = RowObject.fm-codigo
                       AND bfag-estoque-relac-transf-estab.it-codigo = RowObject.it-codigo) THEN DO:
            RUN addValidationError (INPUT 58448, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF CAPS(pType) = "UPDATE":U
        AND CAN-FIND(FIRST bfag-estoque-relac-transf-estab
                     WHERE bfag-estoque-relac-transf-estab.cod-empresa = RowObject.cod-empresa
                       AND bfag-estoque-relac-transf-estab.cod-estabel-orig = RowObject.cod-estabel-orig
                       AND bfag-estoque-relac-transf-estab.cod-estabel-dest = RowObject.cod-estabel-dest
                       AND bfag-estoque-relac-transf-estab.ind-tip-relac = RowObject.ind-tip-relac
                       AND bfag-estoque-relac-transf-estab.fm-codigo = RowObject.fm-codigo
                       AND bfag-estoque-relac-transf-estab.it-codigo = RowObject.it-codigo
                       AND ROWID(bfag-estoque-relac-transf-estab) <> RowObject.r-Rowid) THEN DO:
            RUN addValidationError (INPUT 58448, INPUT "":U).
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
