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

{include/i-prgvrs.i BOIN02058 2.00.00.000 }
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BOIN02058 MUT}
&ENDIF

/*---------------------------------------------------------------------------
    File       : boin02058.p
    Purpose    : DBO para parametros de integracao do Agente de Estoque.
  ------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

&GLOBAL-DEFINE DBOName BOIN02058
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ag-estoque-param
&GLOBAL-DEFINE TableLabel Agente Estoque - Parametros
&GLOBAL-DEFINE QueryName qr{&TableName}

/* DBO-XML-BEGIN */
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES
&GLOBAL-DEFINE XMLExcludeFields des-chave-api,des-hash-chave-callback
&GLOBAL-DEFINE KeyField1 id-param
/* DBO-XML-END */

{inbo/boin02058.i RowObject}
{inbo/boin02058.i ttAgEstoqueParam}

{java/boRest.i}
{method/dboqry.i}

DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-id-param    LIKE ag-estoque-param.id-param    NO-UNDO.
DEFINE VARIABLE c-cod-empresa LIKE ag-estoque-param.cod-empresa INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-estabel LIKE ag-estoque-param.cod-estabel INITIAL "" NO-UNDO.
DEFINE VARIABLE l-log-ativo   LIKE ag-estoque-param.log-ativo   INITIAL ?  NO-UNDO.

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

/* **********************  Internal Procedures  *********************** */

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

PROCEDURE getEffectiveParameters :
/*------------------------------------------------------------------------------
  Purpose:     Retorna a parametrizacao ativa mais especifica para o escopo.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcod-empresa LIKE ag-estoque-param.cod-empresa NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-estabel LIKE ag-estoque-param.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttAgEstoqueParam.

    ASSIGN pcod-empresa = IF pcod-empresa = ? THEN "":U ELSE TRIM(pcod-empresa)
           pcod-estabel = IF pcod-estabel = ? THEN "":U ELSE TRIM(pcod-estabel).

    EMPTY TEMP-TABLE ttAgEstoqueParam NO-ERROR.

    FIND FIRST bfag-estoque-param NO-LOCK
         WHERE bfag-estoque-param.log-ativo   = YES
           AND bfag-estoque-param.cod-empresa = pcod-empresa
           AND bfag-estoque-param.cod-estabel = pcod-estabel
         NO-ERROR.

    IF NOT AVAILABLE bfag-estoque-param
    AND pcod-empresa <> "":U THEN
        FIND FIRST bfag-estoque-param NO-LOCK
             WHERE bfag-estoque-param.log-ativo   = YES
               AND bfag-estoque-param.cod-empresa = pcod-empresa
               AND bfag-estoque-param.cod-estabel = "":U
             NO-ERROR.

    IF NOT AVAILABLE bfag-estoque-param THEN
        FIND FIRST bfag-estoque-param NO-LOCK
             WHERE bfag-estoque-param.log-ativo   = YES
               AND bfag-estoque-param.cod-empresa = "":U
               AND bfag-estoque-param.cod-estabel = "":U
             NO-ERROR.

    IF NOT AVAILABLE bfag-estoque-param THEN
        RETURN "NOK":U.

    IF (TRIM(bfag-estoque-param.des-url-base) = "":U
        AND TRIM(bfag-estoque-param.des-url-execucao) = "":U)
    OR TRIM(bfag-estoque-param.cod-projeto-lynn) = "":U
    OR TRIM(bfag-estoque-param.id-agente-lynn) = "":U
    OR TRIM(bfag-estoque-param.des-chave-api) = "":U
    OR LENGTH(TRIM(bfag-estoque-param.des-hash-chave-callback)) <> 64
    OR bfag-estoque-param.nr-timeout-seg <= 0 THEN
        RETURN "NOK":U.

    CREATE ttAgEstoqueParam.
    BUFFER-COPY bfag-estoque-param TO ttAgEstoqueParam.
    ASSIGN ttAgEstoqueParam.r-Rowid = ROWID(bfag-estoque-param).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getConfiguredApiKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna a chave de saida da parametrizacao efetiva.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcod-empresa LIKE ag-estoque-param.cod-empresa NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-estabel LIKE ag-estoque-param.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-chave-api AS CHARACTER NO-UNDO.

    ASSIGN pc-chave-api = "":U
           pcod-empresa = IF pcod-empresa = ? THEN "":U ELSE TRIM(pcod-empresa)
           pcod-estabel = IF pcod-estabel = ? THEN "":U ELSE TRIM(pcod-estabel).

    FIND FIRST bfag-estoque-param NO-LOCK
         WHERE bfag-estoque-param.log-ativo   = YES
           AND bfag-estoque-param.cod-empresa = pcod-empresa
           AND bfag-estoque-param.cod-estabel = pcod-estabel
         NO-ERROR.

    IF NOT AVAILABLE bfag-estoque-param
    AND pcod-empresa <> "":U THEN
        FIND FIRST bfag-estoque-param NO-LOCK
             WHERE bfag-estoque-param.log-ativo   = YES
               AND bfag-estoque-param.cod-empresa = pcod-empresa
               AND bfag-estoque-param.cod-estabel = "":U
             NO-ERROR.

    IF NOT AVAILABLE bfag-estoque-param THEN
        FIND FIRST bfag-estoque-param NO-LOCK
             WHERE bfag-estoque-param.log-ativo   = YES
               AND bfag-estoque-param.cod-empresa = "":U
               AND bfag-estoque-param.cod-estabel = "":U
             NO-ERROR.

    IF NOT AVAILABLE bfag-estoque-param
    OR TRIM(bfag-estoque-param.des-chave-api) = "":U THEN
        RETURN "NOK":U.

    ASSIGN pc-chave-api = bfag-estoque-param.des-chave-api.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE saveCallbackKeyHash :
/*------------------------------------------------------------------------------
  Purpose:     Grava somente o hash da chave de autenticacao do callback.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pid-param       LIKE ag-estoque-param.id-param NO-UNDO.
    DEFINE INPUT  PARAMETER pc-hash         AS CHARACTER                   NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-usuario    AS CHARACTER                   NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-sucesso      AS LOGICAL                     NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-erro         AS CHARACTER                   NO-UNDO.

    DEFINE VARIABLE c-hexadecimal AS CHARACTER NO-UNDO
        INITIAL "0123456789abcdef":U.
    DEFINE VARIABLE i-posicao AS INTEGER NO-UNDO.

    ASSIGN pl-sucesso   = NO
           pc-erro      = "":U
           pid-param    = IF pid-param = ? THEN "":U ELSE TRIM(pid-param)
           pc-hash      = IF pc-hash = ? THEN "":U ELSE LC(TRIM(pc-hash))
           pcod-usuario = IF pcod-usuario = ? THEN "":U ELSE TRIM(pcod-usuario).

    IF pid-param = "":U THEN DO:
        ASSIGN pc-erro = "O identificador do parametro nao foi informado.":U.
        RETURN "NOK":U.
    END.

    IF LENGTH(pc-hash) <> 64 THEN DO:
        ASSIGN pc-erro = "O hash da chave de callback deve conter 64 caracteres hexadecimais.":U.
        RETURN "NOK":U.
    END.

    DO i-posicao = 1 TO LENGTH(pc-hash):
        IF INDEX(c-hexadecimal, SUBSTRING(pc-hash, i-posicao, 1)) = 0 THEN DO:
            ASSIGN pc-erro = "O hash da chave de callback deve ser hexadecimal.":U.
            RETURN "NOK":U.
        END.
    END.

    DO TRANSACTION ON ERROR UNDO, THROW:
        FIND FIRST bfag-estoque-param EXCLUSIVE-LOCK
             WHERE bfag-estoque-param.id-param = pid-param
             NO-ERROR.

        IF NOT AVAILABLE bfag-estoque-param THEN DO:
            ASSIGN pc-erro = "Parametro do Agente de Estoque nao encontrado.":U.
            RETURN "NOK":U.
        END.

        ASSIGN bfag-estoque-param.des-hash-chave-callback = pc-hash
               bfag-estoque-param.dat-atualizacao         = NOW
               bfag-estoque-param.cod-usuar-atualiz       = pcod-usuario.
    END.

    ASSIGN pl-sucesso = YES.
    RETURN "OK":U.

    CATCH eError AS Progress.Lang.Error:
        ASSIGN pl-sucesso = NO
               pc-erro    = IF eError:NumMessages > 0
                            THEN eError:GetMessage(1)
                            ELSE "Nao foi possivel gravar a chave de callback.":U.
        RETURN "NOK":U.
    END CATCH.
END PROCEDURE.

PROCEDURE getCharField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.

    CASE pFieldName:
        WHEN "id-param":U            THEN ASSIGN pFieldValue = RowObject.id-param.
        WHEN "cod-empresa":U         THEN ASSIGN pFieldValue = RowObject.cod-empresa.
        WHEN "cod-estabel":U         THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "des-url-base":U        THEN ASSIGN pFieldValue = RowObject.des-url-base.
        WHEN "des-url-execucao":U    THEN ASSIGN pFieldValue = RowObject.des-url-execucao.
        WHEN "cod-projeto-lynn":U    THEN ASSIGN pFieldValue = RowObject.cod-projeto-lynn.
        WHEN "id-agente-lynn":U      THEN ASSIGN pFieldValue = RowObject.id-agente-lynn.
        WHEN "cod-usuar-atualiz":U   THEN ASSIGN pFieldValue = RowObject.cod-usuar-atualiz.
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
        WHEN "nr-timeout-seg":U THEN ASSIGN pFieldValue = RowObject.nr-timeout-seg.
        WHEN "int-1":U          THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U          THEN ASSIGN pFieldValue = RowObject.int-2.
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
    DEFINE OUTPUT PARAMETER pid-param LIKE ag-estoque-param.id-param NO-UNDO.

    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    ASSIGN pid-param = RowObject.id-param.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE goToKey :
    DEFINE INPUT PARAMETER pid-param LIKE ag-estoque-param.id-param NO-UNDO.

    FIND FIRST bfag-estoque-param
         WHERE bfag-estoque-param.id-param = pid-param
         NO-LOCK NO-ERROR.

    IF NOT AVAILABLE bfag-estoque-param THEN RETURN "NOK":U.

    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfag-estoque-param)).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryID :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-param = c-id-param
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintID :
    DEFINE INPUT PARAMETER pid-param LIKE ag-estoque-param.id-param NO-UNDO.
    ASSIGN c-id-param = IF pid-param = ? THEN "":U ELSE TRIM(pid-param).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryEscopo :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-empresa = c-cod-empresa
           AND {&TableName}.cod-estabel = c-cod-estabel
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintEscopo :
    DEFINE INPUT PARAMETER pcod-empresa LIKE ag-estoque-param.cod-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE ag-estoque-param.cod-estabel NO-UNDO.

    ASSIGN c-cod-empresa = IF pcod-empresa = ? THEN "":U ELSE TRIM(pcod-empresa)
           c-cod-estabel = IF pcod-estabel = ? THEN "":U ELSE TRIM(pcod-estabel).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryAtivo :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE (l-log-ativo = ? OR {&TableName}.log-ativo = l-log-ativo)
           AND (c-cod-empresa = "":U OR {&TableName}.cod-empresa = c-cod-empresa)
           AND (c-cod-estabel = "":U OR {&TableName}.cod-estabel = c-cod-estabel)
         BY {&TableName}.log-ativo DESCENDING
         BY {&TableName}.cod-empresa
         BY {&TableName}.cod-estabel
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintAtivo :
    DEFINE INPUT PARAMETER plog-ativo  LIKE ag-estoque-param.log-ativo  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-empresa LIKE ag-estoque-param.cod-empresa NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE ag-estoque-param.cod-estabel NO-UNDO.

    ASSIGN l-log-ativo   = plog-ativo
           c-cod-empresa = IF pcod-empresa = ? THEN "":U ELSE TRIM(pcod-empresa)
           c-cod-estabel = IF pcod-estabel = ? THEN "":U ELSE TRIM(pcod-estabel).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryMain :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         BY {&TableName}.log-ativo DESCENDING
         BY {&TableName}.cod-empresa
         BY {&TableName}.cod-estabel
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE beforeCreateRecord :
    ASSIGN RowObject.id-param          = IF RowObject.id-param = ? THEN "":U ELSE TRIM(RowObject.id-param)
           RowObject.cod-empresa       = IF RowObject.cod-empresa = ? THEN "":U ELSE TRIM(RowObject.cod-empresa)
           RowObject.cod-estabel       = IF RowObject.cod-estabel = ? THEN "":U ELSE TRIM(RowObject.cod-estabel)
           RowObject.des-url-base      = IF RowObject.des-url-base = ? THEN "":U ELSE TRIM(RowObject.des-url-base)
           RowObject.des-url-execucao  = IF RowObject.des-url-execucao = ? THEN "":U ELSE TRIM(RowObject.des-url-execucao)
           RowObject.cod-projeto-lynn  = IF RowObject.cod-projeto-lynn = ? THEN "":U ELSE TRIM(RowObject.cod-projeto-lynn)
           RowObject.id-agente-lynn    = IF RowObject.id-agente-lynn = ? THEN "":U ELSE TRIM(RowObject.id-agente-lynn)
           RowObject.cod-usuar-atualiz = IF RowObject.cod-usuar-atualiz = ? THEN "":U ELSE TRIM(RowObject.cod-usuar-atualiz).

    IF RowObject.log-ativo = ? THEN ASSIGN RowObject.log-ativo = YES.
    IF RowObject.nr-timeout-seg = ? OR RowObject.nr-timeout-seg = 0 THEN
        ASSIGN RowObject.nr-timeout-seg = 60.
    IF RowObject.dat-criacao = ? THEN ASSIGN RowObject.dat-criacao = NOW.
    IF RowObject.dat-atualizacao = ? THEN
        ASSIGN RowObject.dat-atualizacao = RowObject.dat-criacao.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE beforeUpdateRecord :
    ASSIGN RowObject.id-param          = IF RowObject.id-param = ? THEN "":U ELSE TRIM(RowObject.id-param)
           RowObject.cod-empresa       = IF RowObject.cod-empresa = ? THEN "":U ELSE TRIM(RowObject.cod-empresa)
           RowObject.cod-estabel       = IF RowObject.cod-estabel = ? THEN "":U ELSE TRIM(RowObject.cod-estabel)
           RowObject.des-url-base      = IF RowObject.des-url-base = ? THEN "":U ELSE TRIM(RowObject.des-url-base)
           RowObject.des-url-execucao  = IF RowObject.des-url-execucao = ? THEN "":U ELSE TRIM(RowObject.des-url-execucao)
           RowObject.cod-projeto-lynn  = IF RowObject.cod-projeto-lynn = ? THEN "":U ELSE TRIM(RowObject.cod-projeto-lynn)
           RowObject.id-agente-lynn    = IF RowObject.id-agente-lynn = ? THEN "":U ELSE TRIM(RowObject.id-agente-lynn)
           RowObject.cod-usuar-atualiz = IF RowObject.cod-usuar-atualiz = ? THEN "":U ELSE TRIM(RowObject.cod-usuar-atualiz)
           RowObject.dat-atualizacao   = NOW.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateRecord :
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-hexadecimal AS CHARACTER NO-UNDO
        INITIAL "0123456789abcdef":U.
    DEFINE VARIABLE c-hash AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-posicao AS INTEGER NO-UNDO.

    IF NOT AVAILABLE RowObject THEN DO:
        RUN addValidationError (INPUT 58352, INPUT "":U).
        RETURN "NOK":U.
    END.

    IF CAN-DO("CREATE,UPDATE":U, CAPS(pType)) THEN DO:
        IF TRIM(RowObject.id-param) = "":U THEN DO:
            RUN addValidationError (INPUT 58353, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.log-ativo = ? THEN DO:
            RUN addValidationError (INPUT 58354, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF TRIM(RowObject.des-url-base) = "":U
        AND TRIM(RowObject.des-url-execucao) = "":U THEN DO:
            RUN addValidationError (INPUT 58355, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF TRIM(RowObject.cod-projeto-lynn) = "":U
        OR TRIM(RowObject.id-agente-lynn) = "":U THEN DO:
            RUN addValidationError (INPUT 58356, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.des-chave-api = ? OR TRIM(RowObject.des-chave-api) = "":U THEN DO:
            RUN addValidationError (INPUT 58357, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.nr-timeout-seg = ?
        OR RowObject.nr-timeout-seg <= 0
        OR RowObject.nr-timeout-seg > 999999 THEN DO:
            RUN addValidationError (INPUT 58358, INPUT "":U).
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

        ASSIGN c-hash = IF RowObject.des-hash-chave-callback = ?
                        THEN "":U
                        ELSE LC(TRIM(RowObject.des-hash-chave-callback)).

        IF c-hash <> "":U THEN DO:
            IF LENGTH(c-hash) <> 64 THEN DO:
                RUN addValidationError (INPUT 58359, INPUT "":U).
                RETURN "NOK":U.
            END.

            DO i-posicao = 1 TO LENGTH(c-hash):
                IF INDEX(c-hexadecimal, SUBSTRING(c-hash, i-posicao, 1)) = 0 THEN DO:
                    RUN addValidationError (INPUT 58360, INPUT "":U).
                    RETURN "NOK":U.
                END.
            END.
        END.

        IF CAPS(pType) = "CREATE":U
        AND CAN-FIND(FIRST bfag-estoque-param
                     WHERE bfag-estoque-param.cod-empresa = RowObject.cod-empresa
                       AND bfag-estoque-param.cod-estabel = RowObject.cod-estabel) THEN DO:
            RUN addValidationError (INPUT 58361, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF CAPS(pType) = "UPDATE":U
        AND CAN-FIND(FIRST bfag-estoque-param
                     WHERE bfag-estoque-param.cod-empresa = RowObject.cod-empresa
                       AND bfag-estoque-param.cod-estabel = RowObject.cod-estabel
                       AND ROWID(bfag-estoque-param) <> RowObject.r-Rowid) THEN DO:
            RUN addValidationError (INPUT 58361, INPUT "":U).
            RETURN "NOK":U.
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.
