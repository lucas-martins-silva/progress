&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram

/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i BOIN02068 2.00.00.000 }
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BOIN02068 MUT}
&ENDIF

/* DBACKSTARSHIP-51: fotografia ag-estoque-analise-entrega.
   CRUD e RowErrors seguem method/dbo.i. Este fonte nao grava por fora do DBO.
   Os identificadores sao recebidos do processo que criou a fotografia.
   Consultas retornam OK/NOK; erros de validacao ficam em RowErrors.
   Persistencia e validateRecord devem integrar a mesma transacao do DBO. */

&GLOBAL-DEFINE DBOName BOIN02068
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ag-estoque-analise-entrega
&GLOBAL-DEFINE TableLabel Entregas da Analise de Estoque
&GLOBAL-DEFINE QueryName qr{&TableName}
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES
&GLOBAL-DEFINE KeyField1 id-entrega-analise

{inbo/boin02068.i RowObject}
{java/boRest.i}
{method/dboqry.i}

DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bOriginal FOR {&TableName}.
DEFINE BUFFER bDuplicado FOR {&TableName}.
DEFINE BUFFER bAnalise FOR ag-estoque-analise.
DEFINE BUFFER bItem FOR ag-estoque-analise-item.

DEFINE VARIABLE c-id-registro LIKE ag-estoque-analise-entrega.id-entrega-analise INITIAL "" NO-UNDO.
DEFINE VARIABLE c-id-analise LIKE ag-estoque-analise-entrega.id-analise INITIAL "" NO-UNDO.
DEFINE VARIABLE c-id-item LIKE ag-estoque-analise-entrega.id-item-analise INITIAL "" NO-UNDO.

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

/* Somente codigos oficiais existentes em MSG/msg.d; parametros separados por til. */
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

/* Leitura do RowObject corrente; campo inexistente ou de outro tipo retorna NOK. */
PROCEDURE getCharField :
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "id-entrega-analise":U THEN ASSIGN pFieldValue = RowObject.id-entrega-analise.
        WHEN "id-analise":U THEN ASSIGN pFieldValue = RowObject.id-analise.
        WHEN "id-item-analise":U THEN ASSIGN pFieldValue = RowObject.id-item-analise.
        WHEN "cod-empresa":U THEN ASSIGN pFieldValue = RowObject.cod-empresa.
        WHEN "cod-usuar-criacao":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-criacao.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* Leitura do RowObject corrente; campo inexistente ou de outro tipo retorna NOK. */
PROCEDURE getDateField :
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "dat-entrega-prevista":U THEN ASSIGN pFieldValue = RowObject.dat-entrega-prevista.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* Leitura do RowObject corrente; campo inexistente ou de outro tipo retorna NOK. */
PROCEDURE getDateTimeField :
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATETIME NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "dat-criacao":U THEN ASSIGN pFieldValue = RowObject.dat-criacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* Leitura do RowObject corrente; campo inexistente ou de outro tipo retorna NOK. */
PROCEDURE getDecField :
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "qtd-saldo-aberto":U THEN ASSIGN pFieldValue = RowObject.qtd-saldo-aberto.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* Leitura do RowObject corrente; campo inexistente ou de outro tipo retorna NOK. */
PROCEDURE getIntField :
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "nr-ordem-compra":U THEN ASSIGN pFieldValue = RowObject.nr-ordem-compra.
        WHEN "nr-parcela-compra":U THEN ASSIGN pFieldValue = RowObject.nr-parcela-compra.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* Leitura do RowObject corrente; campo inexistente ou de outro tipo retorna NOK. */
PROCEDURE getLogField :
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* Leitura do RowObject corrente; campo inexistente ou de outro tipo retorna NOK. */
PROCEDURE getRawField :
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    RETURN "NOK":U.
END PROCEDURE.

PROCEDURE getKey :
    DEFINE OUTPUT PARAMETER pid-registro LIKE ag-estoque-analise-entrega.id-entrega-analise NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    ASSIGN pid-registro = RowObject.id-entrega-analise.
    RETURN "OK":U.
END PROCEDURE.

/* Posiciona pela chave tecnica; nao cria registro quando a chave nao existe. */
PROCEDURE goToKey :
    DEFINE INPUT PARAMETER pid-registro LIKE ag-estoque-analise-entrega.id-entrega-analise NO-UNDO.
    IF pid-registro = ? OR TRIM(pid-registro) = "":U THEN RETURN "NOK":U.
    FIND FIRST bf{&TableName}
         WHERE bf{&TableName}.id-entrega-analise = TRIM(pid-registro)
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE bf{&TableName} THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* Define o filtro de openQueryID; nao abre a consulta. Filtro vazio nao seleciona todos. */
PROCEDURE setConstraintID :
    DEFINE INPUT PARAMETER pid-registro LIKE ag-estoque-analise-entrega.id-entrega-analise NO-UNDO.
    ASSIGN c-id-registro = IF pid-registro = ? THEN "":U ELSE TRIM(pid-registro).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryID :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-entrega-analise = c-id-registro
         BY {&TableName}.id-entrega-analise
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* Define o filtro de openQueryAnalise; nao abre a consulta. Filtro vazio nao seleciona todos. */
PROCEDURE setConstraintAnalise :
    DEFINE INPUT PARAMETER pid-analise LIKE ag-estoque-analise-entrega.id-analise NO-UNDO.
    ASSIGN c-id-analise = IF pid-analise = ? THEN "":U ELSE TRIM(pid-analise).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryAnalise :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-analise = c-id-analise
         BY {&TableName}.id-item-analise
         BY {&TableName}.id-entrega-analise
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* Define o filtro de openQueryItem; nao abre a consulta. Filtro vazio nao seleciona todos. */
PROCEDURE setConstraintItem :
    DEFINE INPUT PARAMETER pid-analise LIKE ag-estoque-analise-entrega.id-analise NO-UNDO.
    DEFINE INPUT PARAMETER pid-item LIKE ag-estoque-analise-entrega.id-item-analise NO-UNDO.
    ASSIGN c-id-analise = IF pid-analise = ? THEN "":U ELSE TRIM(pid-analise).
    ASSIGN c-id-item = IF pid-item = ? THEN "":U ELSE TRIM(pid-item).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryItem :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-analise = c-id-analise
           AND {&TableName}.id-item-analise = c-id-item
         BY {&TableName}.dat-entrega-prevista
         BY {&TableName}.nr-ordem-compra
         BY {&TableName}.nr-parcela-compra
         BY {&TableName}.id-entrega-analise
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* Consulta geral do framework. Para consumo funcional, preferir filtros de analise e item. */
PROCEDURE openQueryMain :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         BY {&TableName}.id-analise
         BY {&TableName}.id-item-analise
         BY {&TableName}.id-entrega-analise
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* Normaliza somente identificadores e codigos; preserva os campos livres. */
PROCEDURE normalizeRecord :
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    ASSIGN RowObject.id-entrega-analise = IF RowObject.id-entrega-analise = ? THEN "":U ELSE TRIM(RowObject.id-entrega-analise).
    ASSIGN RowObject.id-analise = IF RowObject.id-analise = ? THEN "":U ELSE TRIM(RowObject.id-analise).
    ASSIGN RowObject.id-item-analise = IF RowObject.id-item-analise = ? THEN "":U ELSE TRIM(RowObject.id-item-analise).
    ASSIGN RowObject.cod-empresa = IF RowObject.cod-empresa = ? THEN "":U ELSE TRIM(RowObject.cod-empresa).
    ASSIGN RowObject.cod-usuar-criacao = IF RowObject.cod-usuar-criacao = ? THEN "":U ELSE TRIM(RowObject.cod-usuar-criacao).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE beforeCreateRecord :
    RUN normalizeRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    IF RowObject.dat-criacao = ? THEN ASSIGN RowObject.dat-criacao = NOW.
    RETURN "OK":U.
END PROCEDURE.

/* Nao regenera identificadores nem altera a auditoria de criacao. */
PROCEDURE beforeUpdateRecord :
    RUN normalizeRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* CREATE/UPDATE/DELETE: NOK inclui mensagem oficial em RowErrors; nao grava dados diretamente. */
PROCEDURE validateRecord :
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-operation AS CHARACTER NO-UNDO.

    ASSIGN c-operation = IF pType = ? THEN "":U ELSE CAPS(TRIM(pType)).
    IF NOT AVAILABLE RowObject THEN DO:
        RUN addValidationError (INPUT 57401,
                                INPUT "ag-estoque-analise-entrega":U).
        RETURN "NOK":U.
    END.

    IF LOOKUP(c-operation, "CREATE,UPDATE,DELETE":U) = 0 THEN DO:
        RUN addValidationError (INPUT 52530,
                                INPUT "Operacao~~CREATE, UPDATE ou DELETE":U).
        RETURN "NOK":U.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN RETURN "NOK":U.

    /* Serializa gravacoes da mesma analise por estas BOs e protege seu status.
       Na persistencia, este bloco participa da transacao externa do framework.
       FINALLY evita manter buffers ativos entre chamadas do DBO persistente. */
    DO TRANSACTION:
        IF c-operation <> "CREATE":U THEN DO:
            FIND bOriginal WHERE ROWID(bOriginal) = RowObject.r-Rowid NO-LOCK NO-ERROR.
            IF NOT AVAILABLE bOriginal THEN DO:
                RUN addValidationError (INPUT 57401,
                                        INPUT "ag-estoque-analise-entrega":U).
                RETURN "NOK":U.
            END.

            IF RowObject.id-entrega-analise <> bOriginal.id-entrega-analise
            OR RowObject.id-analise <> bOriginal.id-analise
            OR RowObject.cod-empresa <> bOriginal.cod-empresa
            OR RowObject.id-item-analise <> bOriginal.id-item-analise
            OR RowObject.dat-criacao <> bOriginal.dat-criacao
            OR RowObject.cod-usuar-criacao <> bOriginal.cod-usuar-criacao THEN DO:
                RUN addValidationError (INPUT 53420,
                                        INPUT "alterar identificadores ou auditoria da fotografia":U).
                RETURN "NOK":U.
            END.

        END.

        IF RowObject.id-entrega-analise = ? OR TRIM(RowObject.id-entrega-analise) = "":U THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "id-entrega-analise":U).
            RETURN "NOK":U.
        END.

        IF RowObject.id-analise = ? OR TRIM(RowObject.id-analise) = "":U THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "id-analise":U).
            RETURN "NOK":U.
        END.

        IF RowObject.id-item-analise = ? OR TRIM(RowObject.id-item-analise) = "":U THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "id-item-analise":U).
            RETURN "NOK":U.
        END.

        IF RowObject.cod-empresa = ? OR TRIM(RowObject.cod-empresa) = "":U THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "cod-empresa":U).
            RETURN "NOK":U.
        END.

        FIND FIRST bAnalise
             WHERE bAnalise.id-analise = RowObject.id-analise
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED(bAnalise) THEN DO:
            RUN addValidationError (INPUT 53420,
                                    INPUT "analise em uso por outro processo":U).
            RETURN "NOK":U.
        END.

        IF NOT AVAILABLE bAnalise THEN DO:
            RUN addValidationError (INPUT 57401,
                                    INPUT "ag-estoque-analise":U).
            RETURN "NOK":U.
        END.

        IF bAnalise.cod-empresa <> RowObject.cod-empresa THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "cod-empresa~~empresa da analise informada":U).
            RETURN "NOK":U.
        END.

        IF bAnalise.cod-status = ? OR LOOKUP(bAnalise.cod-status, "PENDENTE,PROCESSANDO":U) = 0 THEN DO:
            RUN addValidationError (INPUT 53420,
                                    INPUT "modificar fotografia de analise encerrada":U).
            RETURN "NOK":U.
        END.

        IF c-operation = "DELETE":U THEN RETURN "OK":U.

        FIND FIRST bItem
             WHERE bItem.id-item-analise = RowObject.id-item-analise
             NO-LOCK NO-ERROR.
        IF NOT AVAILABLE bItem THEN DO:
            RUN addValidationError (INPUT 57401,
                                    INPUT "ag-estoque-analise-item":U).
            RETURN "NOK":U.
        END.

        IF bItem.id-analise <> RowObject.id-analise
        OR bItem.cod-empresa <> RowObject.cod-empresa THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "id-item-analise~~detalhe da mesma analise e empresa":U).
            RETURN "NOK":U.
        END.

        IF RowObject.dat-criacao = ? THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "dat-criacao":U).
            RETURN "NOK":U.
        END.

        IF RowObject.nr-ordem-compra <> ? AND RowObject.nr-ordem-compra < 0 THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "nr-ordem-compra~~inteiro maior ou igual a zero, ou desconhecido":U).
            RETURN "NOK":U.
        END.

        IF RowObject.nr-parcela-compra <> ? AND RowObject.nr-parcela-compra < 0 THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "nr-parcela-compra~~inteiro maior ou igual a zero, ou desconhecido":U).
            RETURN "NOK":U.
        END.

        IF RowObject.qtd-saldo-aberto = ? OR RowObject.qtd-saldo-aberto < 0 THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "qtd-saldo-aberto~~numero maior ou igual a zero":U).
            RETURN "NOK":U.
        END.

        IF CAN-FIND(FIRST bDuplicado
                    WHERE bDuplicado.id-entrega-analise = RowObject.id-entrega-analise
                      AND (c-operation = "CREATE":U
                           OR ROWID(bDuplicado) <> RowObject.r-Rowid)) THEN DO:
            RUN addValidationError (INPUT 46216,
                                    INPUT "ag-estoque-analise-entrega":U).
            RETURN "NOK":U.
        END.

        /* O delta nao possui indice unico por parcela. A chave funcional
           so e conhecida quando ordem e parcela estao informadas (> zero).
           A trava da analise serializa a conferencia e a gravacao via BO. */
        IF RowObject.nr-ordem-compra <> ? AND RowObject.nr-ordem-compra > 0
        AND RowObject.nr-parcela-compra <> ? AND RowObject.nr-parcela-compra > 0
        AND CAN-FIND(FIRST bDuplicado
                     WHERE bDuplicado.id-analise = RowObject.id-analise
                       AND bDuplicado.id-item-analise = RowObject.id-item-analise
                       AND bDuplicado.nr-ordem-compra = RowObject.nr-ordem-compra
                       AND bDuplicado.nr-parcela-compra = RowObject.nr-parcela-compra
                       AND (c-operation = "CREATE":U
                            OR ROWID(bDuplicado) <> RowObject.r-Rowid)) THEN DO:
            RUN addValidationError (INPUT 46216,
                                    INPUT "ag-estoque-analise-entrega":U).
            RETURN "NOK":U.
        END.

    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN RETURN "NOK":U.
    RETURN "OK":U.

    FINALLY:
        RELEASE bAnalise.
        RELEASE bOriginal.
        RELEASE bItem.
    END FINALLY.
END PROCEDURE.
