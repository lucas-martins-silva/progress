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

{include/i-prgvrs.i BOIN02062 2.00.00.001 }
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BOIN02062 MUT}
&ENDIF

/*---------------------------------------------------------------------------
    File       : boin02062.p
    Purpose    : DBO para a fotografia dos itens analisados pelo Agente de
                 Estoque.
  ------------------------------------------------------------------------*/

&GLOBAL-DEFINE DBOName BOIN02062
&GLOBAL-DEFINE DBOVersion 2.00.00.001
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ag-estoque-analise-item
&GLOBAL-DEFINE TableLabel Agente Estoque - Analise Item
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES
&GLOBAL-DEFINE KeyField1 id-item-analise

{inbo/boin02062.i RowObject}
{java/boRest.i}
{method/dboqry.i}

DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-id-item-analise LIKE ag-estoque-analise-item.id-item-analise NO-UNDO.
DEFINE VARIABLE c-id-analise      LIKE ag-estoque-analise-item.id-analise      INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-estabel     LIKE ag-estoque-analise-item.cod-estabel     INITIAL "" NO-UNDO.
DEFINE VARIABLE c-it-codigo       LIKE ag-estoque-analise-item.it-codigo       INITIAL "" NO-UNDO.
DEFINE VARIABLE c-fm-codigo       LIKE ag-estoque-analise-item.fm-codigo       INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-situacao    LIKE ag-estoque-analise-item.cod-situacao-principal INITIAL "" NO-UNDO.
DEFINE VARIABLE c-cod-criticidade LIKE ag-estoque-analise-item.cod-criticidade INITIAL "" NO-UNDO.
DEFINE VARIABLE i-ge-codigo       LIKE ag-estoque-analise-item.ge-codigo       INITIAL 0  NO-UNDO.
DEFINE VARIABLE l-registro-alerta LIKE ag-estoque-analise-item.log-registro-alerta INITIAL ? NO-UNDO.
DEFINE VARIABLE dt-dat-ini        AS DATETIME                                  NO-UNDO.
DEFINE VARIABLE dt-dat-fim        AS DATETIME                                  NO-UNDO.

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
        WHEN "id-item-analise":U       THEN ASSIGN pFieldValue = RowObject.id-item-analise.
        WHEN "id-analise":U            THEN ASSIGN pFieldValue = RowObject.id-analise.
        WHEN "cod-empresa":U           THEN ASSIGN pFieldValue = RowObject.cod-empresa.
        WHEN "cod-estabel":U           THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "it-codigo":U             THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "des-item-analise":U      THEN ASSIGN pFieldValue = RowObject.des-item-analise.
        WHEN "cod-unidade":U           THEN ASSIGN pFieldValue = RowObject.cod-unidade.
        WHEN "fm-codigo":U             THEN ASSIGN pFieldValue = RowObject.fm-codigo.
        WHEN "cod-situacao-principal":U THEN ASSIGN pFieldValue = RowObject.cod-situacao-principal.
        WHEN "cod-criticidade":U        THEN ASSIGN pFieldValue = RowObject.cod-criticidade.
        WHEN "char-1":U                 THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U                 THEN ASSIGN pFieldValue = RowObject.char-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getDateField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE      NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "dat-ult-movto":U       THEN ASSIGN pFieldValue = RowObject.dat-ult-movto.
        WHEN "dat-ult-entrada":U      THEN ASSIGN pFieldValue = RowObject.dat-ult-entrada.
        WHEN "dat-disp-nova-compra":U THEN ASSIGN pFieldValue = RowObject.dat-disp-nova-compra.
        WHEN "data-1":U              THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U              THEN ASSIGN pFieldValue = RowObject.data-2.
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
        WHEN "qtd-estoque-atual":U          THEN ASSIGN pFieldValue = RowObject.qtd-estoque-atual.
        WHEN "qtd-estoque-alocado":U        THEN ASSIGN pFieldValue = RowObject.qtd-estoque-alocado.
        WHEN "qtd-saldo-disponivel":U       THEN ASSIGN pFieldValue = RowObject.qtd-saldo-disponivel.
        WHEN "qtd-requis-pendente":U        THEN ASSIGN pFieldValue = RowObject.qtd-requis-pendente.
        WHEN "qtd-solic-compra-pendente":U  THEN ASSIGN pFieldValue = RowObject.qtd-solic-compra-pendente.
        WHEN "qtd-ordem-compra-pendente":U  THEN ASSIGN pFieldValue = RowObject.qtd-ordem-compra-pendente.
        WHEN "qtd-posicao-efetiva":U        THEN ASSIGN pFieldValue = RowObject.qtd-posicao-efetiva.
        WHEN "qtd-posicao-planejada":U      THEN ASSIGN pFieldValue = RowObject.qtd-posicao-planejada.
        WHEN "qtd-estoque-minimo":U         THEN ASSIGN pFieldValue = RowObject.qtd-estoque-minimo.
        WHEN "qtd-estoque-maximo":U         THEN ASSIGN pFieldValue = RowObject.qtd-estoque-maximo.
        WHEN "qtd-estoque-seguranca":U      THEN ASSIGN pFieldValue = RowObject.qtd-estoque-seguranca.
        WHEN "qtd-ponto-encomenda":U        THEN ASSIGN pFieldValue = RowObject.qtd-ponto-encomenda.
        WHEN "qtd-lote-minimo":U            THEN ASSIGN pFieldValue = RowObject.qtd-lote-minimo.
        WHEN "qtd-lote-multiplo":U          THEN ASSIGN pFieldValue = RowObject.qtd-lote-multiplo.
        WHEN "qtd-lote-economico":U         THEN ASSIGN pFieldValue = RowObject.qtd-lote-economico.
        WHEN "qtd-consumo-previsto":U       THEN ASSIGN pFieldValue = RowObject.qtd-consumo-previsto.
        WHEN "qtd-tempo-ressup":U           THEN ASSIGN pFieldValue = RowObject.qtd-tempo-ressup.
        WHEN "qtd-cobertura-dias":U         THEN ASSIGN pFieldValue = RowObject.qtd-cobertura-dias.
        WHEN "qtd-limite-excesso":U         THEN ASSIGN pFieldValue = RowObject.qtd-limite-excesso.
        WHEN "qtd-necessidade-ressup":U     THEN ASSIGN pFieldValue = RowObject.qtd-necessidade-ressup.
        WHEN "qtd-perda":U                  THEN ASSIGN pFieldValue = RowObject.qtd-perda.
        WHEN "perc-refugo":U                THEN ASSIGN pFieldValue = RowObject.perc-refugo.
        WHEN "val-custo-unit-ult-ent":U     THEN ASSIGN pFieldValue = RowObject.val-custo-unit-ult-ent.
        WHEN "dec-1":U                      THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U                      THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getIntField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER   NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "ge-codigo":U            THEN ASSIGN pFieldValue = RowObject.ge-codigo.
        WHEN "ind-tip-ressup":U        THEN ASSIGN pFieldValue = RowObject.ind-tip-ressup.
        WHEN "cod-frequencia":U        THEN ASSIGN pFieldValue = RowObject.cod-frequencia.
        WHEN "cod-obsoleto":U          THEN ASSIGN pFieldValue = RowObject.cod-obsoleto.
        WHEN "qtd-dias-sem-movto":U    THEN ASSIGN pFieldValue = RowObject.qtd-dias-sem-movto.
        WHEN "dias-ocioso":U           THEN ASSIGN pFieldValue = RowObject.dias-ocioso.
        WHEN "perc-excesso":U          THEN ASSIGN pFieldValue = RowObject.perc-excesso.
        WHEN "nr-ranking-analise":U    THEN ASSIGN pFieldValue = RowObject.nr-ranking-analise.
        WHEN "int-1":U                 THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U                 THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getLogField :
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL   NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    CASE pFieldName:
        WHEN "log-contr-ag-ia":U       THEN ASSIGN pFieldValue = RowObject.log-contr-ag-ia.
        WHEN "log-ruptura":U           THEN ASSIGN pFieldValue = RowObject.log-ruptura.
        WHEN "log-risco-ruptura":U     THEN ASSIGN pFieldValue = RowObject.log-risco-ruptura.
        WHEN "log-abaixo-seguranca":U  THEN ASSIGN pFieldValue = RowObject.log-abaixo-seguranca.
        WHEN "log-abaixo-pto-encom":U  THEN ASSIGN pFieldValue = RowObject.log-abaixo-pto-encom.
        WHEN "log-excesso":U           THEN ASSIGN pFieldValue = RowObject.log-excesso.
        WHEN "log-ocioso":U            THEN ASSIGN pFieldValue = RowObject.log-ocioso.
        WHEN "log-registro-alerta":U   THEN ASSIGN pFieldValue = RowObject.log-registro-alerta.
        WHEN "log-agenda-compra-completa":U THEN ASSIGN pFieldValue = RowObject.log-agenda-compra-completa.
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
    DEFINE OUTPUT PARAMETER pid-item-analise LIKE ag-estoque-analise-item.id-item-analise NO-UNDO.
    IF NOT AVAILABLE RowObject THEN RETURN "NOK":U.
    ASSIGN pid-item-analise = RowObject.id-item-analise.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE goToKey :
    DEFINE INPUT PARAMETER pid-item-analise LIKE ag-estoque-analise-item.id-item-analise NO-UNDO.
    FIND FIRST bfag-estoque-analise-item
         WHERE bfag-estoque-analise-item.id-item-analise = pid-item-analise
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE bfag-estoque-analise-item THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfag-estoque-analise-item)).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryID :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-item-analise = c-id-item-analise
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintID :
    DEFINE INPUT PARAMETER pid-item-analise LIKE ag-estoque-analise-item.id-item-analise NO-UNDO.
    ASSIGN c-id-item-analise = IF pid-item-analise = ? THEN "":U ELSE TRIM(pid-item-analise).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryAnalise :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-analise = c-id-analise
         BY {&TableName}.it-codigo
         BY {&TableName}.cod-estabel
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintAnalise :
    DEFINE INPUT PARAMETER pid-analise LIKE ag-estoque-analise-item.id-analise NO-UNDO.
    ASSIGN c-id-analise = IF pid-analise = ? THEN "":U ELSE TRIM(pid-analise).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryDashboard :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-analise = c-id-analise
           AND (l-registro-alerta = ? OR {&TableName}.log-registro-alerta = l-registro-alerta)
           AND (c-cod-estabel = "":U OR {&TableName}.cod-estabel = c-cod-estabel)
           AND (c-cod-situacao = "":U OR {&TableName}.cod-situacao-principal = c-cod-situacao)
           AND (c-cod-criticidade = "":U OR {&TableName}.cod-criticidade = c-cod-criticidade)
         BY {&TableName}.nr-ranking-analise
         BY {&TableName}.it-codigo
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintDashboard :
    DEFINE INPUT PARAMETER pid-analise       LIKE ag-estoque-analise-item.id-analise             NO-UNDO.
    DEFINE INPUT PARAMETER pregistro-alerta  LIKE ag-estoque-analise-item.log-registro-alerta    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel      LIKE ag-estoque-analise-item.cod-estabel            NO-UNDO.
    DEFINE INPUT PARAMETER pcod-situacao     LIKE ag-estoque-analise-item.cod-situacao-principal NO-UNDO.
    DEFINE INPUT PARAMETER pcod-criticidade  LIKE ag-estoque-analise-item.cod-criticidade        NO-UNDO.
    ASSIGN c-id-analise      = IF pid-analise = ? THEN "":U ELSE TRIM(pid-analise)
           l-registro-alerta = pregistro-alerta
           c-cod-estabel     = IF pcod-estabel = ? THEN "":U ELSE TRIM(pcod-estabel)
           c-cod-situacao    = IF pcod-situacao = ? THEN "":U ELSE CAPS(TRIM(pcod-situacao))
           c-cod-criticidade = IF pcod-criticidade = ? THEN "":U ELSE CAPS(TRIM(pcod-criticidade)).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryCadastro :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.it-codigo = c-it-codigo
           AND (c-cod-estabel = "":U OR {&TableName}.cod-estabel = c-cod-estabel)
           AND (dt-dat-ini = ? OR {&TableName}.dat-analise >= dt-dat-ini)
           AND (dt-dat-fim = ? OR {&TableName}.dat-analise <= dt-dat-fim)
         BY {&TableName}.dat-analise DESCENDING
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintCadastro :
    DEFINE INPUT PARAMETER pit-codigo  LIKE ag-estoque-analise-item.it-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE ag-estoque-analise-item.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pdat-ini     AS DATE                                  NO-UNDO.
    DEFINE INPUT PARAMETER pdat-fim     AS DATE                                  NO-UNDO.
    ASSIGN c-it-codigo   = IF pit-codigo = ? THEN "":U ELSE TRIM(pit-codigo)
           c-cod-estabel = IF pcod-estabel = ? THEN "":U ELSE TRIM(pcod-estabel)
           dt-dat-ini    = IF pdat-ini = ? THEN ? ELSE DATETIME(pdat-ini, 0)
           dt-dat-fim    = IF pdat-fim = ? THEN ? ELSE DATETIME(pdat-fim, 86399999).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryFamilia :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.id-analise = c-id-analise
           AND (c-fm-codigo = "":U OR {&TableName}.fm-codigo = c-fm-codigo)
           AND (i-ge-codigo = 0 OR {&TableName}.ge-codigo = i-ge-codigo)
           AND (l-registro-alerta = ? OR {&TableName}.log-registro-alerta = l-registro-alerta)
         BY {&TableName}.fm-codigo
         BY {&TableName}.ge-codigo
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setConstraintFamilia :
    DEFINE INPUT PARAMETER pid-analise      LIKE ag-estoque-analise-item.id-analise          NO-UNDO.
    DEFINE INPUT PARAMETER pfm-codigo       LIKE ag-estoque-analise-item.fm-codigo           NO-UNDO.
    DEFINE INPUT PARAMETER pge-codigo       LIKE ag-estoque-analise-item.ge-codigo           NO-UNDO.
    DEFINE INPUT PARAMETER pregistro-alerta LIKE ag-estoque-analise-item.log-registro-alerta NO-UNDO.
    ASSIGN c-id-analise      = IF pid-analise = ? THEN "":U ELSE TRIM(pid-analise)
           c-fm-codigo       = IF pfm-codigo = ? THEN "":U ELSE TRIM(pfm-codigo)
           i-ge-codigo       = IF pge-codigo = ? THEN 0 ELSE pge-codigo
           l-registro-alerta = pregistro-alerta.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE openQueryMain :
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         BY {&TableName}.dat-analise DESCENDING
         BY {&TableName}.it-codigo
         BY {&TableName}.cod-estabel
         INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE beforeCreateRecord :
    ASSIGN RowObject.cod-situacao-principal = IF RowObject.cod-situacao-principal = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-situacao-principal))
           RowObject.cod-criticidade        = IF RowObject.cod-criticidade = ? THEN "":U ELSE CAPS(TRIM(RowObject.cod-criticidade)).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateRecord :
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-tem-alerta AS LOGICAL NO-UNDO.

    IF NOT AVAILABLE RowObject THEN DO:
        RUN addValidationError (INPUT 58393, INPUT "":U).
        RETURN "NOK":U.
    END.

    ASSIGN pType = IF pType = ? THEN "":U ELSE CAPS(TRIM(pType)).
    IF LOOKUP(pType, "CREATE,UPDATE,DELETE":U) = 0 THEN DO:
        RUN addIntegrityError (INPUT 52530, INPUT "Operacao~~CREATE, UPDATE ou DELETE":U).
        RETURN "NOK":U.
    END.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN RETURN "NOK":U.

    IF CAN-DO("CREATE,UPDATE":U, CAPS(pType)) THEN DO:
        IF RowObject.id-item-analise = ? OR TRIM(RowObject.id-item-analise) = "":U
        OR RowObject.id-analise = ? OR TRIM(RowObject.id-analise) = "":U THEN DO:
            RUN addValidationError (INPUT 58394, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.dat-analise = ?
        OR RowObject.cod-empresa = ? OR TRIM(RowObject.cod-empresa) = "":U
        OR RowObject.cod-estabel = ? OR TRIM(RowObject.cod-estabel) = "":U
        OR RowObject.it-codigo = ? OR TRIM(RowObject.it-codigo) = "":U
        OR RowObject.des-item-analise = ? OR TRIM(RowObject.des-item-analise) = "":U
        OR RowObject.cod-unidade = ? OR TRIM(RowObject.cod-unidade) = "":U
        OR RowObject.fm-codigo = ? OR TRIM(RowObject.fm-codigo) = "":U THEN DO:
            RUN addValidationError (INPUT 58395, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.ge-codigo = ? OR RowObject.ind-tip-ressup = ? OR RowObject.cod-obsoleto = ? THEN DO:
            RUN addValidationError (INPUT 58396, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.qtd-estoque-atual = ?
        OR RowObject.qtd-estoque-alocado = ?
        OR RowObject.qtd-saldo-disponivel = ?
        OR RowObject.qtd-requis-pendente = ?
        OR RowObject.qtd-solic-compra-pendente = ?
        OR RowObject.qtd-ordem-compra-pendente = ?
        OR RowObject.qtd-posicao-efetiva = ?
        OR RowObject.qtd-posicao-planejada = ?
        OR RowObject.qtd-perda = ?
        OR RowObject.perc-refugo = ?
        OR RowObject.val-custo-unit-ult-ent = ?
        OR RowObject.qtd-estoque-seguranca = ?
        OR RowObject.qtd-ponto-encomenda = ?
        OR RowObject.log-agenda-compra-completa = ? THEN DO:
            RUN addValidationError (INPUT 58397, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.log-contr-ag-ia = ? THEN DO:
            RUN addIntegrityError (INPUT 52530, INPUT "log-contr-ag-ia~~Sim ou Nao":U).
            RETURN "NOK":U.
        END.
        /* Contexto conserva os indicadores fisicos, mas nao vira alerta ou alvo. */
        IF RowObject.log-contr-ag-ia = NO
        AND (RowObject.log-registro-alerta = ? OR RowObject.log-registro-alerta <> NO
             OR RowObject.nr-ranking-analise = ? OR RowObject.nr-ranking-analise <> 0) THEN DO:
            RUN addIntegrityError (INPUT 52530, INPUT "Origem de contexto~~sem alerta de monitoramento e com ranking zero":U).
            RETURN "NOK":U.
        END.

        IF RowObject.dias-ocioso = ? OR RowObject.dias-ocioso < 0
        OR RowObject.perc-excesso = ? OR RowObject.perc-excesso < 0 THEN DO:
            RUN addValidationError (INPUT 58398, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.qtd-perda < 0
        OR RowObject.perc-refugo < 0
        OR RowObject.val-custo-unit-ult-ent < 0 THEN DO:
            RUN addValidationError (INPUT 58399, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.qtd-dias-sem-movto <> ? AND RowObject.qtd-dias-sem-movto < 0 THEN DO:
            RUN addValidationError (INPUT 58400, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.nr-ranking-analise <> ? AND RowObject.nr-ranking-analise < 0 THEN DO:
            RUN addValidationError (INPUT 58401, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.qtd-necessidade-ressup <> ? AND RowObject.qtd-necessidade-ressup < 0 THEN DO:
            RUN addValidationError (INPUT 58402, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.cod-situacao-principal = ? OR TRIM(RowObject.cod-situacao-principal) = "":U
        OR RowObject.cod-criticidade = ? OR TRIM(RowObject.cod-criticidade) = "":U THEN DO:
            RUN addValidationError (INPUT 58403, INPUT "":U).
            RETURN "NOK":U.
        END.

        ASSIGN l-tem-alerta = RowObject.log-ruptura
                           OR RowObject.log-risco-ruptura
                           OR RowObject.log-abaixo-seguranca
                           OR RowObject.log-abaixo-pto-encom
                           OR RowObject.log-excesso
                           OR RowObject.log-ocioso.

        IF RowObject.log-registro-alerta = YES AND NOT l-tem-alerta THEN DO:
            RUN addValidationError (INPUT 58404, INPUT "":U).
            RETURN "NOK":U.
        END.

        IF RowObject.log-contr-ag-ia = YES
        AND RowObject.log-registro-alerta = NO
        AND (CAPS(RowObject.cod-situacao-principal) <> "NORMAL":U OR l-tem-alerta) THEN DO:
            RUN addValidationError (INPUT 58405, INPUT "":U).
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
    DEFINE VARIABLE lOrigemValida AS LOGICAL NO-UNDO.
    DEFINE BUFFER bIntegrityOriginal FOR ag-estoque-analise-item.
    DEFINE BUFFER bIntegrityDuplicado FOR ag-estoque-analise-item.
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
                RUN addIntegrityError (INPUT 57401, INPUT "ag-estoque-analise-item":U).
                RETURN "NOK":U.
            END.
            IF RowObject.id-item-analise <> bIntegrityOriginal.id-item-analise
            OR RowObject.id-analise <> bIntegrityOriginal.id-analise
            OR RowObject.cod-empresa <> bIntegrityOriginal.cod-empresa
            OR RowObject.dat-analise <> bIntegrityOriginal.dat-analise
            OR RowObject.cod-estabel <> bIntegrityOriginal.cod-estabel
            OR RowObject.it-codigo <> bIntegrityOriginal.it-codigo
            OR RowObject.fm-codigo <> bIntegrityOriginal.fm-codigo
            OR RowObject.log-contr-ag-ia <> bIntegrityOriginal.log-contr-ag-ia THEN DO:
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
        IF bIntegrityAnalise.cod-status = ?
        OR LOOKUP(bIntegrityAnalise.cod-status, "PENDENTE,PROCESSANDO":U) = 0 THEN DO:
            RUN addIntegrityError (INPUT 53420, INPUT "modificar detalhes de analise encerrada":U).
            RETURN "NOK":U.
        END.
        IF pType = "DELETE":U THEN DO:
            /* Remover primeiro as origens evita deixa-las sem destino durante a montagem. */
            IF bIntegrityOriginal.log-contr-ag-ia = YES
            AND CAN-FIND(FIRST bIntegrityDuplicado NO-LOCK
                         WHERE bIntegrityDuplicado.id-analise = bIntegrityOriginal.id-analise
                           AND bIntegrityDuplicado.it-codigo = bIntegrityOriginal.it-codigo
                           AND bIntegrityDuplicado.log-contr-ag-ia = NO) THEN DO:
                RUN addIntegrityError (INPUT 53420, INPUT "excluir destino antes das origens de contexto do item":U).
                RETURN "NOK":U.
            END.
            IF CAN-FIND(FIRST ag-estoque-analise-entrega NO-LOCK
                         WHERE ag-estoque-analise-entrega.id-item-analise = bIntegrityOriginal.id-item-analise)
            OR CAN-FIND(FIRST ag-estoque-analise-opcao-trf NO-LOCK
                         WHERE ag-estoque-analise-opcao-trf.id-item-analise-orig = bIntegrityOriginal.id-item-analise
                            OR ag-estoque-analise-opcao-trf.id-item-analise-dest = bIntegrityOriginal.id-item-analise)
            OR CAN-FIND(FIRST ag-estoque-recomendacao NO-LOCK
                         WHERE ag-estoque-recomendacao.id-item-analise = bIntegrityOriginal.id-item-analise) THEN DO:
                RUN addIntegrityError (INPUT 53420, INPUT "excluir detalhe com entregas, opcoes de transferencia ou recomendacoes":U).
                RETURN "NOK":U.
            END.
            RETURN "OK":U.
        END.
        IF RowObject.log-contr-ag-ia = NO THEN DO:
            RUN cep/ce0550ctx.p (INPUT RowObject.id-item-analise,
                                INPUT RowObject.id-analise,
                                INPUT RowObject.cod-empresa,
                                INPUT RowObject.cod-estabel,
                                INPUT RowObject.it-codigo,
                                INPUT RowObject.fm-codigo,
                                OUTPUT lOrigemValida).
            IF lOrigemValida <> YES THEN DO:
                RUN addIntegrityError (INPUT 53420, INPUT "gravar origem sem vinculo com destino monitorado da mesma fotografia":U).
                RETURN "NOK":U.
            END.
        END.
        IF CAN-FIND(FIRST bIntegrityDuplicado NO-LOCK
                    WHERE bIntegrityDuplicado.id-item-analise = RowObject.id-item-analise
                      AND (pType = "CREATE":U
                           OR ROWID(bIntegrityDuplicado) <> RowObject.r-Rowid)) THEN DO:
            RUN addIntegrityError (INPUT 46216, INPUT "ag-estoque-analise-item":U).
            RETURN "NOK":U.
        END.
        IF CAN-FIND(FIRST bIntegrityDuplicado NO-LOCK
                    WHERE bIntegrityDuplicado.id-analise = RowObject.id-analise
                      AND bIntegrityDuplicado.cod-estabel = RowObject.cod-estabel
                      AND bIntegrityDuplicado.it-codigo = RowObject.it-codigo
                      AND (pType = "CREATE":U
                           OR ROWID(bIntegrityDuplicado) <> RowObject.r-Rowid)) THEN DO:
            RUN addIntegrityError (INPUT 46216, INPUT "ag-estoque-analise-item":U).
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
