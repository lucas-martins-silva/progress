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

{include/i-prgvrs.i BOIN02064 2.00.00.001 }
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BOIN02064 MUT}
&ENDIF

/*---------------------------------------------------------------------------
    File       : boin02064.p
    Purpose    : DBO para recomendacoes e decisoes do Agente de Estoque.
  ------------------------------------------------------------------------*/

&GLOBAL-DEFINE DBOName BOIN02064
&GLOBAL-DEFINE DBOVersion 2.00.00.001
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ag-estoque-recomendacao
&GLOBAL-DEFINE TableLabel Agente Estoque - Recomendacao
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES
&GLOBAL-DEFINE KeyField1 id-recomendacao

{inbo/boin02064.i RowObject}
{java/boRest.i}
{method/dboqry.i}

DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-id-recomendacao  LIKE ag-estoque-recomendacao.id-recomendacao  NO-UNDO.
DEFINE VARIABLE c-id-analise       LIKE ag-estoque-recomendacao.id-analise       INITIAL "" NO-UNDO.
DEFINE VARIABLE c-id-item-analise  LIKE ag-estoque-recomendacao.id-item-analise  INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-status       LIKE ag-estoque-recomendacao.cod-status       INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-estabel-alvo LIKE ag-estoque-recomendacao.cod-estabel-alvo INITIAL "" NO-UNDO.
DEFINE VARIABLE c-it-codigo        LIKE ag-estoque-recomendacao.it-codigo        INITIAL "" NO-UNDO.
DEFINE VARIABLE c-localizador      LIKE ag-estoque-recomendacao.localizador      INITIAL "" NO-UNDO.
DEFINE VARIABLE dt-dat-ini         AS DATETIME                                   NO-UNDO.
DEFINE VARIABLE dt-dat-fim         AS DATETIME                                   NO-UNDO.

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
        WHEN "id-recomendacao":U      THEN ASSIGN pFieldValue = RowObject.id-recomendacao.
        WHEN "id-analise":U           THEN ASSIGN pFieldValue = RowObject.id-analise.
        WHEN "id-item-analise":U      THEN ASSIGN pFieldValue = RowObject.id-item-analise.
        WHEN "id-correlacao":U        THEN ASSIGN pFieldValue = RowObject.id-correlacao.
        WHEN "cod-empresa":U          THEN ASSIGN pFieldValue = RowObject.cod-empresa.
        WHEN "cod-estabel-alvo":U     THEN ASSIGN pFieldValue = RowObject.cod-estabel-alvo.
        WHEN "it-codigo":U            THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "cod-acao":U             THEN ASSIGN pFieldValue = RowObject.cod-acao.
        WHEN "cod-estabel-orig":U     THEN ASSIGN pFieldValue = RowObject.cod-estabel-orig.
        WHEN "id-relac-transf":U      THEN ASSIGN pFieldValue = RowObject.id-relac-transf.
        WHEN "des-justificativa":U    THEN ASSIGN pFieldValue = RowObject.des-justificativa.
        WHEN "des-regra-aplicada":U   THEN ASSIGN pFieldValue = RowObject.des-regra-aplicada.
        WHEN "cod-status":U           THEN ASSIGN pFieldValue = RowObject.cod-status.
        WHEN "cod-usuar-atualiz":U    THEN ASSIGN pFieldValue = RowObject.cod-usuar-atualiz.
        WHEN "cod-usuar-decisao":U    THEN ASSIGN pFieldValue = RowObject.cod-usuar-decisao.
        WHEN "des-motivo-decisao":U   THEN ASSIGN pFieldValue = RowObject.des-motivo-decisao.
        WHEN "id-execucao-erp":U      THEN ASSIGN pFieldValue = RowObject.id-execucao-erp.
        WHEN "des-resultado-exec":U   THEN ASSIGN pFieldValue = RowObject.des-resultado-exec.
        WHEN "localizador":U          THEN ASSIGN pFieldValue = RowObject.localizador.
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
        WHEN "dat-disp-estimada":U THEN ASSIGN pFieldValue = RowObject.dat-disp-estimada.
        WHEN "data-1":U            THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U            THEN ASSIGN pFieldValue = RowObject.data-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getDateTimeField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATETIME  NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "dat-criacao":U      THEN ASSIGN pFieldValue = RowObject.dat-criacao.
        WHEN "dat-atualizacao":U  THEN ASSIGN pFieldValue = RowObject.dat-atualizacao.
        WHEN "dat-decisao":U      THEN ASSIGN pFieldValue = RowObject.dat-decisao.
        WHEN "dat-inicio-exec":U  THEN ASSIGN pFieldValue = RowObject.dat-inicio-exec.
        WHEN "dat-fim-execucao":U THEN ASSIGN pFieldValue = RowObject.dat-fim-execucao.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getDecField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL   NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "qtd-sugerida":U       THEN ASSIGN pFieldValue = RowObject.qtd-sugerida.
        WHEN "val-custo-estimado":U THEN ASSIGN pFieldValue = RowObject.val-custo-estimado.
        WHEN "val-preco-transf":U   THEN ASSIGN pFieldValue = RowObject.val-preco-transf.
        WHEN "dec-1":U              THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U              THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getIntField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER   NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "nr-prioridade":U      THEN ASSIGN pFieldValue = RowObject.nr-prioridade.
        WHEN "qtd-dias-estimados":U THEN ASSIGN pFieldValue = RowObject.qtd-dias-estimados.
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
        WHEN "log-requer-aprovacao":U THEN ASSIGN pFieldValue = RowObject.log-requer-aprovacao.
        WHEN "log-1":U                THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U                THEN ASSIGN pFieldValue = RowObject.log-2.
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
    DEFINE OUTPUT PARAMETER pid-recomendacao LIKE ag-estoque-recomendacao.id-recomendacao NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    ASSIGN pid-recomendacao = RowObject.id-recomendacao.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE goToKey :
    DEFINE INPUT PARAMETER pid-recomendacao LIKE ag-estoque-recomendacao.id-recomendacao NO-UNDO.
    FIND FIRST bfag-estoque-recomendacao
         WHERE bfag-estoque-recomendacao.id-recomendacao = pid-recomendacao
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE bfag-estoque-recomendacao THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfag-estoque-recomendacao)).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryID :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-recomendacao = c-id-recomendacao
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintID :
    DEFINE INPUT PARAMETER pid-recomendacao LIKE ag-estoque-recomendacao.id-recomendacao NO-UNDO.
    ASSIGN c-id-recomendacao = IF pid-recomendacao = ? THEN "":U ELSE TRIM(pid-recomendacao).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryAnalise :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-analise = c-id-analise
         BY {&TableName}.nr-prioridade
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintAnalise :
    DEFINE INPUT PARAMETER pid-analise LIKE ag-estoque-recomendacao.id-analise NO-UNDO.
    ASSIGN c-id-analise = IF pid-analise = ? THEN "":U ELSE TRIM(pid-analise).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryDetalhe :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-item-analise = c-id-item-analise
           AND (c-cod-status = "":U OR {&TableName}.cod-status = c-cod-status)
         BY {&TableName}.nr-prioridade
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintDetalhe :
    DEFINE INPUT PARAMETER pid-item-analise LIKE ag-estoque-recomendacao.id-item-analise NO-UNDO.
    DEFINE INPUT PARAMETER pcod-status      LIKE ag-estoque-recomendacao.cod-status      NO-UNDO.
    ASSIGN c-id-item-analise = IF pid-item-analise = ? THEN "":U ELSE TRIM(pid-item-analise)
           c-cod-status      = IF pcod-status = ? THEN "":U ELSE CAPS(TRIM(pcod-status)).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryStatus :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE (c-cod-status = "":U OR {&TableName}.cod-status = c-cod-status)
           AND (dt-dat-ini = ? OR {&TableName}.dat-criacao >= dt-dat-ini)
           AND (dt-dat-fim = ? OR {&TableName}.dat-criacao <= dt-dat-fim)
           AND (c-cod-estabel-alvo = "":U OR {&TableName}.cod-estabel-alvo = c-cod-estabel-alvo)
         BY {&TableName}.dat-criacao DESCENDING
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintStatus :
    DEFINE INPUT PARAMETER pcod-status       LIKE ag-estoque-recomendacao.cod-status       NO-UNDO.
    DEFINE INPUT PARAMETER pdat-ini          AS DATE                                       NO-UNDO.
    DEFINE INPUT PARAMETER pdat-fim          AS DATE                                       NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel-alvo LIKE ag-estoque-recomendacao.cod-estabel-alvo NO-UNDO.
    ASSIGN c-cod-status       = IF pcod-status = ? THEN "":U ELSE CAPS(TRIM(pcod-status))
           dt-dat-ini         = IF pdat-ini = ? THEN ? ELSE DATETIME(pdat-ini, 0)
           dt-dat-fim         = IF pdat-fim = ? THEN ? ELSE DATETIME(pdat-fim, 86399999)
           c-cod-estabel-alvo = IF pcod-estabel-alvo = ? THEN "":U ELSE TRIM(pcod-estabel-alvo).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryItem :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.it-codigo = c-it-codigo
           AND (c-cod-estabel-alvo = "":U OR {&TableName}.cod-estabel-alvo = c-cod-estabel-alvo)
           AND (dt-dat-ini = ? OR {&TableName}.dat-criacao >= dt-dat-ini)
           AND (dt-dat-fim = ? OR {&TableName}.dat-criacao <= dt-dat-fim)
         BY {&TableName}.dat-criacao DESCENDING
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintItem :
    DEFINE INPUT PARAMETER pit-codigo        LIKE ag-estoque-recomendacao.it-codigo        NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel-alvo LIKE ag-estoque-recomendacao.cod-estabel-alvo NO-UNDO.
    DEFINE INPUT PARAMETER pdat-ini          AS DATE                                       NO-UNDO.
    DEFINE INPUT PARAMETER pdat-fim          AS DATE                                       NO-UNDO.
    ASSIGN c-it-codigo        = IF pit-codigo = ? THEN "":U ELSE TRIM(pit-codigo)
           c-cod-estabel-alvo = IF pcod-estabel-alvo = ? THEN "":U ELSE TRIM(pcod-estabel-alvo)
           dt-dat-ini         = IF pdat-ini = ? THEN ? ELSE DATETIME(pdat-ini, 0)
           dt-dat-fim         = IF pdat-fim = ? THEN ? ELSE DATETIME(pdat-fim, 86399999).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryLocalizador :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.localizador = c-localizador
         BY {&TableName}.dat-criacao DESCENDING
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintLocalizador :
    DEFINE INPUT PARAMETER plocalizador LIKE ag-estoque-recomendacao.localizador NO-UNDO.
    ASSIGN c-localizador = IF plocalizador = ? THEN "":U ELSE CAPS(TRIM(plocalizador)).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryMain :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         BY {&TableName}.dat-criacao DESCENDING
         BY {&TableName}.nr-prioridade
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE beforeCreateRecord :
    ASSIGN RowObject.cod-acao        = IF RowObject.cod-acao = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-acao))
           RowObject.cod-status      = IF RowObject.cod-status = ? OR TRIM(RowObject.cod-status) = "":U
                                       THEN "PENDENTE":U ELSE CAPS(TRIM(RowObject.cod-status))
           RowObject.localizador     = IF RowObject.localizador = ? THEN "":U ELSE CAPS(TRIM(RowObject.localizador))
           RowObject.cod-usuar-atualiz = IF RowObject.cod-usuar-atualiz = ? THEN "":U ELSE TRIM(RowObject.cod-usuar-atualiz).
    IF RowObject.dat-criacao = ? THEN ASSIGN RowObject.dat-criacao = NOW.
    IF RowObject.dat-atualizacao = ? THEN ASSIGN RowObject.dat-atualizacao = RowObject.dat-criacao.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE beforeUpdateRecord :
    ASSIGN RowObject.cod-acao          = IF RowObject.cod-acao = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-acao))
           RowObject.cod-status        = IF RowObject.cod-status = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-status))
           RowObject.localizador       = IF RowObject.localizador = ? THEN "":U ELSE CAPS(TRIM(RowObject.localizador))
           RowObject.cod-usuar-atualiz = IF RowObject.cod-usuar-atualiz = ? THEN "":U ELSE TRIM(RowObject.cod-usuar-atualiz)
           RowObject.dat-atualizacao   = NOW.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateRecord :
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-acao     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-status   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-localiz  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-alfabeto AS CHARACTER NO-UNDO INITIAL "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ":U.
    DEFINE VARIABLE i-posicao  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE l-letra    AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-numero   AS LOGICAL   NO-UNDO.

    IF NOT AVAILABLE RowObject THEN DO:
        RUN addValidationError (INPUT 58411, INPUT "":U).
        RETURN "NOK":U.
    END.

    ASSIGN pType = IF pType = ? THEN "":U ELSE CAPS(TRIM(pType)).
    IF LOOKUP(pType, "CREATE,UPDATE,DELETE":U) = 0 THEN DO:
        RUN addIntegrityError (INPUT 52530, INPUT "Operacao~~CREATE, UPDATE ou DELETE":U).
        RETURN "NOK":U.
    END.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN RETURN "NOK":U.

    IF CAN-DO("CREATE,UPDATE":U, CAPS(pType)) THEN DO:
        ASSIGN c-acao    = CAPS(TRIM(RowObject.cod-acao))
               c-status  = CAPS(TRIM(RowObject.cod-status))
               c-localiz = IF RowObject.localizador = ? THEN "":U ELSE RowObject.localizador.

        IF RowObject.id-recomendacao = ? OR TRIM(RowObject.id-recomendacao) = "":U
        OR RowObject.id-analise = ? OR TRIM(RowObject.id-analise) = "":U
        OR RowObject.id-item-analise = ? OR TRIM(RowObject.id-item-analise) = "":U
        OR RowObject.id-correlacao = ? OR TRIM(RowObject.id-correlacao) = "":U THEN DO:
            RUN addValidationError (INPUT 58412, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.cod-estabel-alvo = ? OR TRIM(RowObject.cod-estabel-alvo) = "":U
        OR RowObject.it-codigo = ? OR TRIM(RowObject.it-codigo) = "":U
        OR RowObject.des-justificativa = ? OR TRIM(RowObject.des-justificativa) = "":U THEN DO:
            RUN addValidationError (INPUT 58413, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.nr-prioridade = ? OR RowObject.nr-prioridade <= 0 THEN DO:
            RUN addValidationError (INPUT 58414, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF LOOKUP(c-acao, "COMPRAR,TRANSFERIR,AVALIAR,ALERTAR":U) = 0 THEN DO:
            RUN addValidationError (INPUT 58415, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF LOOKUP(c-status, "PENDENTE,APROVADA,REJEITADA,EXECUTANDO,CONCLUIDA,ERRO,CANCELADA":U) = 0 THEN DO:
            RUN addValidationError (INPUT 58416, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.log-requer-aprovacao = ? THEN DO:
            RUN addValidationError (INPUT 58417, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF CAN-DO("COMPRAR,TRANSFERIR":U, c-acao)
        AND (RowObject.qtd-sugerida = ? OR RowObject.qtd-sugerida <= 0) THEN DO:
            RUN addValidationError (INPUT 58418, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF CAN-DO("COMPRAR,TRANSFERIR":U, c-acao)
        AND RowObject.dat-disp-estimada = ? THEN DO:
            RUN addValidationError (INPUT 58419, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF c-acao = "TRANSFERIR":U THEN DO:
            IF RowObject.cod-estabel-orig = ? OR TRIM(RowObject.cod-estabel-orig) = "":U
            OR RowObject.id-relac-transf = ? OR TRIM(RowObject.id-relac-transf) = "":U THEN DO:
                RUN addValidationError (INPUT 58420, INPUT "":U).
                RETURN "NOK":U.
            END.
            IF RowObject.cod-estabel-orig = RowObject.cod-estabel-alvo THEN DO:
                RUN addValidationError (INPUT 58421, INPUT "":U).
                RETURN "NOK":U.
            END.
        END.

        IF c-acao = "COMPRAR":U
        AND ((RowObject.cod-estabel-orig <> ? AND TRIM(RowObject.cod-estabel-orig) <> "":U)
             OR (RowObject.id-relac-transf <> ? AND TRIM(RowObject.id-relac-transf) <> "":U)) THEN DO:
            RUN addValidationError (INPUT 58422, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF (RowObject.qtd-sugerida <> ? AND RowObject.qtd-sugerida < 0)
        OR (RowObject.qtd-dias-estimados <> ? AND RowObject.qtd-dias-estimados < 0)
        OR (RowObject.val-custo-estimado <> ? AND RowObject.val-custo-estimado < 0)
        OR (RowObject.val-preco-transf <> ? AND RowObject.val-preco-transf < 0) THEN DO:
            RUN addValidationError (INPUT 58423, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.dat-criacao = ? OR RowObject.dat-atualizacao = ? THEN DO:
            RUN addValidationError (INPUT 58424, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.dat-atualizacao < RowObject.dat-criacao THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "Data Atualiza‡Æo":U + "~~Data igual ou posterior … cria‡Æo":U).
            RETURN "NOK":U.
        END.

        IF CAN-DO("APROVADA,REJEITADA,CANCELADA":U, c-status) THEN DO:
            IF RowObject.cod-usuar-decisao = ? OR TRIM(RowObject.cod-usuar-decisao) = "":U
            OR RowObject.dat-decisao = ? THEN DO:
                RUN addValidationError (INPUT 58425, INPUT "":U).
                RETURN "NOK":U.
            END.
            IF CAN-DO("REJEITADA,CANCELADA":U, c-status)
            AND (RowObject.des-motivo-decisao = ? OR TRIM(RowObject.des-motivo-decisao) = "":U) THEN DO:
                RUN addValidationError (INPUT 58426, INPUT "":U).
                RETURN "NOK":U.
            END.
        END.

        IF RowObject.dat-decisao <> ? AND RowObject.dat-decisao < RowObject.dat-criacao THEN DO:
            RUN addValidationError (INPUT 58427, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF CAN-DO("EXECUTANDO,CONCLUIDA":U, c-status)
        AND RowObject.dat-inicio-exec = ? THEN DO:
            RUN addValidationError (INPUT 58428, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF c-status = "CONCLUIDA":U THEN DO:
            IF RowObject.dat-fim-execucao = ?
            OR RowObject.des-resultado-exec = ? OR TRIM(RowObject.des-resultado-exec) = "":U THEN DO:
                RUN addValidationError (INPUT 58429, INPUT "":U).
                RETURN "NOK":U.
            END.
        END.

        IF RowObject.dat-inicio-exec <> ?
        AND RowObject.dat-inicio-exec < RowObject.dat-criacao THEN DO:
            RUN addValidationError (INPUT 58430, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.dat-fim-execucao <> ?
        AND RowObject.dat-inicio-exec <> ?
        AND RowObject.dat-fim-execucao < RowObject.dat-inicio-exec THEN DO:
            RUN addValidationError (INPUT 58431, INPUT "":U).
            RETURN "NOK":U.
        END.

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
    DEFINE BUFFER bIntegrityOriginal FOR ag-estoque-recomendacao.
    DEFINE BUFFER bIntegrityDuplicado FOR ag-estoque-recomendacao.
    DEFINE BUFFER bIntegrityAnalise FOR ag-estoque-analise.
    DEFINE BUFFER bIntegrityItem FOR ag-estoque-analise-item.
    DEFINE BUFFER bIntegrityOpcao FOR ag-estoque-analise-opcao-trf.
    DEFINE BUFFER bIntegrityOrigem FOR ag-estoque-analise-item.

    DO TRANSACTION:
        IF pType = "DELETE":U THEN DO:
            RUN addIntegrityError (INPUT 53420, INPUT "excluir recomendacao historica; utilizar o fluxo de cancelamento":U).
            RETURN "NOK":U.
        END.
        IF pType <> "CREATE":U THEN DO:
            FIND bIntegrityOriginal WHERE ROWID(bIntegrityOriginal) = RowObject.r-Rowid
                 EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF LOCKED(bIntegrityOriginal) THEN DO:
                RUN addIntegrityError (INPUT 53420, INPUT "registro em uso por outro processo":U).
                RETURN "NOK":U.
            END.
            IF NOT AVAILABLE bIntegrityOriginal THEN DO:
                RUN addIntegrityError (INPUT 57401, INPUT "ag-estoque-recomendacao":U).
                RETURN "NOK":U.
            END.
            IF RowObject.id-recomendacao <> bIntegrityOriginal.id-recomendacao
            OR RowObject.id-analise <> bIntegrityOriginal.id-analise
            OR RowObject.id-item-analise <> bIntegrityOriginal.id-item-analise
            OR RowObject.id-correlacao <> bIntegrityOriginal.id-correlacao
            OR RowObject.cod-empresa <> bIntegrityOriginal.cod-empresa
            OR RowObject.cod-estabel-alvo <> bIntegrityOriginal.cod-estabel-alvo
            OR RowObject.it-codigo <> bIntegrityOriginal.it-codigo
            OR RowObject.cod-acao <> bIntegrityOriginal.cod-acao
            OR RowObject.cod-estabel-orig <> bIntegrityOriginal.cod-estabel-orig
            OR RowObject.id-relac-transf <> bIntegrityOriginal.id-relac-transf
            OR RowObject.dat-criacao <> bIntegrityOriginal.dat-criacao THEN DO:
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
        IF RowObject.id-correlacao <> bIntegrityAnalise.id-correlacao THEN DO:
            RUN addIntegrityError (INPUT 52530, INPUT "id-correlacao~~correlacao da analise informada":U).
            RETURN "NOK":U.
        END.
        IF bIntegrityAnalise.cod-status = ? OR bIntegrityAnalise.cod-status <> "CONCLUIDO":U THEN DO:
            RUN addIntegrityError (INPUT 53420, INPUT "registrar recomendacao sem fotografia concluida":U).
            RETURN "NOK":U.
        END.
        FIND FIRST bIntegrityItem
             WHERE bIntegrityItem.id-item-analise = RowObject.id-item-analise NO-LOCK NO-ERROR.
        IF NOT AVAILABLE bIntegrityItem THEN DO:
            RUN addIntegrityError (INPUT 57401, INPUT "ag-estoque-analise-item":U).
            RETURN "NOK":U.
        END.
        IF bIntegrityItem.id-analise <> RowObject.id-analise
        OR bIntegrityItem.cod-empresa <> RowObject.cod-empresa
        OR bIntegrityItem.cod-estabel <> RowObject.cod-estabel-alvo
        OR bIntegrityItem.it-codigo <> RowObject.it-codigo THEN DO:
            RUN addIntegrityError (INPUT 52530, INPUT "id-item-analise~~detalhe da mesma analise, empresa, item e estabelecimento alvo":U).
            RETURN "NOK":U.
        END.
        IF bIntegrityItem.log-contr-ag-ia <> YES
        OR bIntegrityItem.log-registro-alerta <> YES THEN DO:
            RUN addIntegrityError (INPUT 52530, INPUT "id-item-analise~~alerta de destino monitorado pelo agente":U).
            RETURN "NOK":U.
        END.
        IF CAPS(TRIM(RowObject.cod-acao)) = "TRANSFERIR":U THEN DO:
            /* O cadastro atual pode mudar ou ser removido. A referencia e a opcao fotografada. */
            FIND FIRST bIntegrityOpcao
                 WHERE bIntegrityOpcao.id-analise = RowObject.id-analise
                   AND bIntegrityOpcao.id-item-analise-dest = RowObject.id-item-analise
                   AND bIntegrityOpcao.id-relac-transf = RowObject.id-relac-transf
                   AND bIntegrityOpcao.cod-empresa = RowObject.cod-empresa
                   AND bIntegrityOpcao.cod-estabel-orig = RowObject.cod-estabel-orig
                   AND bIntegrityOpcao.cod-estabel-dest = RowObject.cod-estabel-alvo
                 NO-LOCK NO-ERROR.
            IF NOT AVAILABLE bIntegrityOpcao THEN DO:
                RUN addIntegrityError (INPUT 57401, INPUT "ag-estoque-analise-opcao-trf":U).
                RETURN "NOK":U.
            END.
            FIND FIRST bIntegrityOrigem
                 WHERE bIntegrityOrigem.id-item-analise = bIntegrityOpcao.id-item-analise-orig
                 NO-LOCK NO-ERROR.
            IF NOT AVAILABLE bIntegrityOrigem THEN DO:
                RUN addIntegrityError (INPUT 57401, INPUT "ag-estoque-analise-item (origem)":U).
                RETURN "NOK":U.
            END.
            IF bIntegrityOrigem.id-analise <> RowObject.id-analise
            OR bIntegrityOrigem.cod-empresa <> RowObject.cod-empresa
            OR bIntegrityOrigem.it-codigo <> RowObject.it-codigo
            OR bIntegrityOrigem.cod-estabel <> RowObject.cod-estabel-orig
            OR bIntegrityOrigem.id-item-analise = bIntegrityItem.id-item-analise THEN DO:
                RUN addIntegrityError (INPUT 52530, INPUT "origem da transferencia~~outro estabelecimento do mesmo item, empresa e analise":U).
                RETURN "NOK":U.
            END.
        END.
        IF CAN-FIND(FIRST bIntegrityDuplicado NO-LOCK
                    WHERE bIntegrityDuplicado.id-recomendacao = RowObject.id-recomendacao
                      AND (pType = "CREATE":U
                           OR ROWID(bIntegrityDuplicado) <> RowObject.r-Rowid)) THEN DO:
            RUN addIntegrityError (INPUT 46216, INPUT "ag-estoque-recomendacao":U).
            RETURN "NOK":U.
        END.
        RETURN "OK":U.
        FINALLY:
            RELEASE bIntegrityOrigem.
            RELEASE bIntegrityOpcao.
            RELEASE bIntegrityItem.
            RELEASE bIntegrityAnalise.
            RELEASE bIntegrityDuplicado.
            RELEASE bIntegrityOriginal.
        END FINALLY.
    END.
END PROCEDURE.
