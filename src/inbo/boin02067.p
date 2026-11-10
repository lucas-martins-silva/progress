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

{include/i-prgvrs.i BOIN02067 2.00.00.000 }
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BOIN02067 MUT}
&ENDIF

/* DBACKSTARSHIP-51: fotografia ag-estoque-analise-opcao-trf.
   CRUD e RowErrors seguem method/dbo.i. Este fonte nao grava por fora do DBO.
   Os identificadores sao recebidos do processo que criou a fotografia.
   Consultas retornam OK/NOK; erros de validacao ficam em RowErrors.
   Persistencia e validateRecord devem integrar a mesma transacao do DBO. */

&GLOBAL-DEFINE DBOName BOIN02067
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ag-estoque-analise-opcao-trf
&GLOBAL-DEFINE TableLabel Opcoes de Transferencia da Analise
&GLOBAL-DEFINE QueryName qr{&TableName}
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES
&GLOBAL-DEFINE KeyField1 id-opcao-transf

{inbo/boin02067.i RowObject}
{java/boRest.i}
{method/dboqry.i}

DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bOriginal FOR {&TableName}.
DEFINE BUFFER bDuplicado FOR {&TableName}.
DEFINE BUFFER bAnalise FOR ag-estoque-analise.
DEFINE BUFFER bItem FOR ag-estoque-analise-item.

DEFINE VARIABLE c-id-registro LIKE ag-estoque-analise-opcao-trf.id-opcao-transf INITIAL "" NO-UNDO.
DEFINE VARIABLE c-id-analise LIKE ag-estoque-analise-opcao-trf.id-analise INITIAL "" NO-UNDO.
DEFINE VARIABLE c-id-item LIKE ag-estoque-analise-opcao-trf.id-item-analise-dest INITIAL "" NO-UNDO.
DEFINE BUFFER bOrigem FOR ag-estoque-analise-item.
DEFINE BUFFER bRelacao FOR ag-estoque-relac-transf-estab.
DEFINE VARIABLE c-id-origem LIKE ag-estoque-analise-opcao-trf.id-item-analise-orig INITIAL "" NO-UNDO.

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
        WHEN "id-opcao-transf":U THEN ASSIGN pFieldValue = RowObject.id-opcao-transf.
        WHEN "id-analise":U THEN ASSIGN pFieldValue = RowObject.id-analise.
        WHEN "id-item-analise-orig":U THEN ASSIGN pFieldValue = RowObject.id-item-analise-orig.
        WHEN "id-item-analise-dest":U THEN ASSIGN pFieldValue = RowObject.id-item-analise-dest.
        WHEN "id-relac-transf":U THEN ASSIGN pFieldValue = RowObject.id-relac-transf.
        WHEN "cod-empresa":U THEN ASSIGN pFieldValue = RowObject.cod-empresa.
        WHEN "cod-estabel-orig":U THEN ASSIGN pFieldValue = RowObject.cod-estabel-orig.
        WHEN "cod-estabel-dest":U THEN ASSIGN pFieldValue = RowObject.cod-estabel-dest.
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
        WHEN "dat-disp-estimada":U THEN ASSIGN pFieldValue = RowObject.dat-disp-estimada.
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
        WHEN "dat-config-relac":U THEN ASSIGN pFieldValue = RowObject.dat-config-relac.
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
        WHEN "val-custo-transp":U THEN ASSIGN pFieldValue = RowObject.val-custo-transp.
        WHEN "val-custo-operac":U THEN ASSIGN pFieldValue = RowObject.val-custo-operac.
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
        WHEN "ind-tip-relac":U THEN ASSIGN pFieldValue = RowObject.ind-tip-relac.
        WHEN "qtd-dias-lead-time":U THEN ASSIGN pFieldValue = RowObject.qtd-dias-lead-time.
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
        WHEN "log-custo-transp-item":U THEN ASSIGN pFieldValue = RowObject.log-custo-transp-item.
        WHEN "log-custo-operac-item":U THEN ASSIGN pFieldValue = RowObject.log-custo-operac-item.
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
    DEFINE OUTPUT PARAMETER pid-registro LIKE ag-estoque-analise-opcao-trf.id-opcao-transf NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    ASSIGN pid-registro = RowObject.id-opcao-transf.
    RETURN "OK":U.
END PROCEDURE.

/* Posiciona pela chave tecnica; nao cria registro quando a chave nao existe. */
PROCEDURE goToKey :
    DEFINE INPUT PARAMETER pid-registro LIKE ag-estoque-analise-opcao-trf.id-opcao-transf NO-UNDO.
    IF pid-registro = ? OR TRIM(pid-registro) = "":U THEN RETURN "NOK":U.
    FIND FIRST bf{&TableName}
         WHERE bf{&TableName}.id-opcao-transf = TRIM(pid-registro)
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE bf{&TableName} THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* Define o filtro de openQueryID; nao abre a consulta. Filtro vazio nao seleciona todos. */
PROCEDURE setConstraintID :
    DEFINE INPUT PARAMETER pid-registro LIKE ag-estoque-analise-opcao-trf.id-opcao-transf NO-UNDO.
    ASSIGN c-id-registro = IF pid-registro = ? THEN "":U ELSE TRIM(pid-registro).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryID :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-opcao-transf = c-id-registro
         BY {&TableName}.id-opcao-transf
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* Define o filtro de openQueryAnalise; nao abre a consulta. Filtro vazio nao seleciona todos. */
PROCEDURE setConstraintAnalise :
    DEFINE INPUT PARAMETER pid-analise LIKE ag-estoque-analise-opcao-trf.id-analise NO-UNDO.
    ASSIGN c-id-analise = IF pid-analise = ? THEN "":U ELSE TRIM(pid-analise).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryAnalise :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-analise = c-id-analise
         BY {&TableName}.id-item-analise-dest
         BY {&TableName}.id-opcao-transf
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* Define o filtro de openQueryDestino; nao abre a consulta. Filtro vazio nao seleciona todos. */
PROCEDURE setConstraintDestino :
    DEFINE INPUT PARAMETER pid-analise LIKE ag-estoque-analise-opcao-trf.id-analise NO-UNDO.
    DEFINE INPUT PARAMETER pid-item LIKE ag-estoque-analise-opcao-trf.id-item-analise-dest NO-UNDO.
    ASSIGN c-id-analise = IF pid-analise = ? THEN "":U ELSE TRIM(pid-analise).
    ASSIGN c-id-item = IF pid-item = ? THEN "":U ELSE TRIM(pid-item).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryDestino :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-analise = c-id-analise
           AND {&TableName}.id-item-analise-dest = c-id-item
         BY {&TableName}.dat-disp-estimada
         BY {&TableName}.cod-estabel-orig
         BY {&TableName}.id-opcao-transf
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* Define o filtro de openQueryOrigem; nao abre a consulta. Filtro vazio nao seleciona todos. */
PROCEDURE setConstraintOrigem :
    DEFINE INPUT PARAMETER pid-analise LIKE ag-estoque-analise-opcao-trf.id-analise NO-UNDO.
    DEFINE INPUT PARAMETER pid-origem LIKE ag-estoque-analise-opcao-trf.id-item-analise-orig NO-UNDO.
    ASSIGN c-id-analise = IF pid-analise = ? THEN "":U ELSE TRIM(pid-analise).
    ASSIGN c-id-origem = IF pid-origem = ? THEN "":U ELSE TRIM(pid-origem).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryOrigem :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-analise = c-id-analise
           AND {&TableName}.id-item-analise-orig = c-id-origem
         BY {&TableName}.id-item-analise-dest
         BY {&TableName}.id-opcao-transf
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* Consulta geral do framework. Para consumo funcional, preferir filtros de analise e item. */
PROCEDURE openQueryMain :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         BY {&TableName}.id-analise
         BY {&TableName}.id-item-analise-dest
         BY {&TableName}.id-opcao-transf
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* Normaliza somente identificadores e codigos; preserva os campos livres. */
PROCEDURE normalizeRecord :
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    ASSIGN RowObject.id-opcao-transf = IF RowObject.id-opcao-transf = ? THEN "":U ELSE TRIM(RowObject.id-opcao-transf).
    ASSIGN RowObject.id-analise = IF RowObject.id-analise = ? THEN "":U ELSE TRIM(RowObject.id-analise).
    ASSIGN RowObject.id-item-analise-orig = IF RowObject.id-item-analise-orig = ? THEN "":U ELSE TRIM(RowObject.id-item-analise-orig).
    ASSIGN RowObject.id-item-analise-dest = IF RowObject.id-item-analise-dest = ? THEN "":U ELSE TRIM(RowObject.id-item-analise-dest).
    ASSIGN RowObject.id-relac-transf = IF RowObject.id-relac-transf = ? THEN "":U ELSE TRIM(RowObject.id-relac-transf).
    ASSIGN RowObject.cod-empresa = IF RowObject.cod-empresa = ? THEN "":U ELSE TRIM(RowObject.cod-empresa).
    ASSIGN RowObject.cod-estabel-orig = IF RowObject.cod-estabel-orig = ? THEN "":U ELSE TRIM(RowObject.cod-estabel-orig).
    ASSIGN RowObject.cod-estabel-dest = IF RowObject.cod-estabel-dest = ? THEN "":U ELSE TRIM(RowObject.cod-estabel-dest).
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
                                INPUT "ag-estoque-analise-opcao-trf":U).
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
                                        INPUT "ag-estoque-analise-opcao-trf":U).
                RETURN "NOK":U.
            END.

            IF RowObject.id-opcao-transf <> bOriginal.id-opcao-transf
            OR RowObject.id-analise <> bOriginal.id-analise
            OR RowObject.cod-empresa <> bOriginal.cod-empresa
            OR RowObject.id-item-analise-dest <> bOriginal.id-item-analise-dest
            OR RowObject.dat-criacao <> bOriginal.dat-criacao
            OR RowObject.cod-usuar-criacao <> bOriginal.cod-usuar-criacao
            OR RowObject.id-item-analise-orig <> bOriginal.id-item-analise-orig
            OR RowObject.id-relac-transf <> bOriginal.id-relac-transf
            OR RowObject.cod-estabel-orig <> bOriginal.cod-estabel-orig
            OR RowObject.cod-estabel-dest <> bOriginal.cod-estabel-dest THEN DO:
                RUN addValidationError (INPUT 53420,
                                        INPUT "alterar identificadores ou auditoria da fotografia":U).
                RETURN "NOK":U.
            END.

        END.

        IF RowObject.id-opcao-transf = ? OR TRIM(RowObject.id-opcao-transf) = "":U THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "id-opcao-transf":U).
            RETURN "NOK":U.
        END.

        IF RowObject.id-analise = ? OR TRIM(RowObject.id-analise) = "":U THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "id-analise":U).
            RETURN "NOK":U.
        END.

        IF RowObject.id-item-analise-orig = ? OR TRIM(RowObject.id-item-analise-orig) = "":U THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "id-item-analise-orig":U).
            RETURN "NOK":U.
        END.

        IF RowObject.id-item-analise-dest = ? OR TRIM(RowObject.id-item-analise-dest) = "":U THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "id-item-analise-dest":U).
            RETURN "NOK":U.
        END.

        IF RowObject.id-relac-transf = ? OR TRIM(RowObject.id-relac-transf) = "":U THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "id-relac-transf":U).
            RETURN "NOK":U.
        END.

        IF RowObject.cod-empresa = ? OR TRIM(RowObject.cod-empresa) = "":U THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "cod-empresa":U).
            RETURN "NOK":U.
        END.

        IF RowObject.cod-estabel-orig = ? OR TRIM(RowObject.cod-estabel-orig) = "":U THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "cod-estabel-orig":U).
            RETURN "NOK":U.
        END.

        IF RowObject.cod-estabel-dest = ? OR TRIM(RowObject.cod-estabel-dest) = "":U THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "cod-estabel-dest":U).
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
             WHERE bItem.id-item-analise = RowObject.id-item-analise-dest
             NO-LOCK NO-ERROR.
        IF NOT AVAILABLE bItem THEN DO:
            RUN addValidationError (INPUT 57401,
                                    INPUT "ag-estoque-analise-item":U).
            RETURN "NOK":U.
        END.

        IF bItem.id-analise <> RowObject.id-analise
        OR bItem.cod-empresa <> RowObject.cod-empresa THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "id-item-analise-dest~~detalhe da mesma analise e empresa":U).
            RETURN "NOK":U.
        END.

        IF bItem.log-contr-ag-ia <> YES THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "id-item-analise-dest~~destino monitorado pelo agente":U).
            RETURN "NOK":U.
        END.

        IF RowObject.dat-criacao = ? THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "dat-criacao":U).
            RETURN "NOK":U.
        END.

        IF RowObject.cod-estabel-orig = RowObject.cod-estabel-dest
        OR RowObject.id-item-analise-orig = RowObject.id-item-analise-dest THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "Origem e destino~~estabelecimentos e detalhes distintos":U).
            RETURN "NOK":U.
        END.

        FIND FIRST bOrigem
             WHERE bOrigem.id-item-analise = RowObject.id-item-analise-orig
             NO-LOCK NO-ERROR.
        IF NOT AVAILABLE bOrigem THEN DO:
            RUN addValidationError (INPUT 57401,
                                    INPUT "ag-estoque-analise-item":U).
            RETURN "NOK":U.
        END.

        IF bOrigem.id-analise <> RowObject.id-analise
        OR bOrigem.cod-empresa <> RowObject.cod-empresa
        OR bOrigem.it-codigo <> bItem.it-codigo
        OR bOrigem.cod-estabel <> RowObject.cod-estabel-orig
        OR bItem.cod-estabel <> RowObject.cod-estabel-dest THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "Origem e destino~~mesmo item e analise com estabelecimentos correspondentes":U).
            RETURN "NOK":U.
        END.

        IF RowObject.ind-tip-relac = ? OR LOOKUP(STRING(RowObject.ind-tip-relac), "1,2,3":U) = 0 THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "ind-tip-relac~~1 Geral, 2 Familia ou 3 Item":U).
            RETURN "NOK":U.
        END.

        IF RowObject.qtd-dias-lead-time = ? OR RowObject.qtd-dias-lead-time <= 0 THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "qtd-dias-lead-time~~inteiro maior que zero":U).
            RETURN "NOK":U.
        END.

        IF RowObject.val-custo-transp = ? OR RowObject.val-custo-transp < 0 THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "val-custo-transp~~numero maior ou igual a zero":U).
            RETURN "NOK":U.
        END.

        IF RowObject.val-custo-operac = ? OR RowObject.val-custo-operac < 0 THEN DO:
            RUN addValidationError (INPUT 52530,
                                    INPUT "val-custo-operac~~numero maior ou igual a zero":U).
            RETURN "NOK":U.
        END.

        IF RowObject.log-custo-transp-item = ? THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "log-custo-transp-item":U).
            RETURN "NOK":U.
        END.

        IF RowObject.log-custo-operac-item = ? THEN DO:
            RUN addValidationError (INPUT 57315,
                                    INPUT "log-custo-operac-item":U).
            RETURN "NOK":U.
        END.

        /* A configuracao viva somente e conferida na inclusao.
           Custos, prazo e datas permanecem os valores recebidos da fotografia. */
        IF c-operation = "CREATE":U THEN DO:
            FIND FIRST bRelacao
                 WHERE bRelacao.id-relac-transf = RowObject.id-relac-transf
                 NO-LOCK NO-ERROR.
            IF NOT AVAILABLE bRelacao THEN DO:
                RUN addValidationError (INPUT 57401,
                                        INPUT "ag-estoque-relac-transf-estab":U).
                RETURN "NOK":U.
            END.

            IF bRelacao.ind-sit-relac = ? OR bRelacao.ind-sit-relac <> 1
            OR bRelacao.cod-empresa <> RowObject.cod-empresa
            OR bRelacao.cod-estabel-orig <> RowObject.cod-estabel-orig
            OR bRelacao.cod-estabel-dest <> RowObject.cod-estabel-dest
            OR bRelacao.ind-tip-relac <> RowObject.ind-tip-relac
            OR (bRelacao.ind-tip-relac = 2 AND bRelacao.fm-codigo <> bItem.fm-codigo)
            OR (bRelacao.ind-tip-relac = 3 AND bRelacao.it-codigo <> bItem.it-codigo) THEN DO:
                RUN addValidationError (INPUT 52530,
                                        INPUT "id-relac-transf~~relacionamento ativo correspondente a empresa, origem, destino e item":U).
                RETURN "NOK":U.
            END.

        END.

        IF CAN-FIND(FIRST bDuplicado
                    WHERE bDuplicado.id-opcao-transf = RowObject.id-opcao-transf
                      AND (c-operation = "CREATE":U
                           OR ROWID(bDuplicado) <> RowObject.r-Rowid)) THEN DO:
            RUN addValidationError (INPUT 46216,
                                    INPUT "ag-estoque-analise-opcao-trf":U).
            RETURN "NOK":U.
        END.

        IF CAN-FIND(FIRST bDuplicado
                    WHERE bDuplicado.id-item-analise-dest = RowObject.id-item-analise-dest
                      AND bDuplicado.id-item-analise-orig = RowObject.id-item-analise-orig
                      AND bDuplicado.id-relac-transf = RowObject.id-relac-transf
                      AND (c-operation = "CREATE":U
                           OR ROWID(bDuplicado) <> RowObject.r-Rowid)) THEN DO:
            RUN addValidationError (INPUT 46216,
                                    INPUT "ag-estoque-analise-opcao-trf":U).
            RETURN "NOK":U.
        END.

    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN RETURN "NOK":U.
    RETURN "OK":U.

    FINALLY:
        RELEASE bAnalise.
        RELEASE bOriginal.
        RELEASE bItem.
        RELEASE bOrigem.
        RELEASE bRelacao.
    END FINALLY.
END PROCEDURE.
