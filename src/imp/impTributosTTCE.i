/******************************************************************************
** impTributosTTCE.i
** Monta o array "tributos" dos itens da DUIMP consultando a API TTCE do
** Portal Unico por NCM + pais:
**   POST /ttce/api/ext/tratamentos-tributarios/importacao/
**   body: { "ncm", "codigoPais", "dataFatoGerador", "tipoOperacao":"I" }
**
** Envia SOMENTE os fundamentos legais NORMAIS com atributos dinamicos que o
** TTCE retornar em "tratamentosTributarios" (regra oficial: fundamentos
** normais sem atributo sao calculados pelo sistema e nao devem ser enviados).
** O valor de cada atributo dinamico vem de item-atrib-det (tabela definitiva,
** alimentada pelo cadastro do item); quando nao cadastrado, usa coringa
** ("0" p/ numerico, "XXXX" p/ dominio/EX).
**
** Uso: {imp/impTributosTTCE.i} no fonte (area de procedures), depois, no laco
** de itens:
**   RUN pi-ttce-obtem-ncm-pais (item, isoFabric, OUTPUT ncm, OUTPUT paisNum).
**   RUN pi-ttce-monta-tributos (item, ncm, paisNum, INPUT oArr,
**                               OUTPUT lMontou, OUTPUT cMsg).
**
** Depende de: PROCEDURE piIntegraTTCE (INPUT body, INPUT endpoint,
**             INPUT method, OUTPUT result) no fonte hospedeiro.
******************************************************************************/

/* cache do array de tributos ja montado por NCM+pais (evita repetir POST) */
DEFINE TEMP-TABLE tt-ttce-cache NO-UNDO
    FIELD ncm      AS CHARACTER FORMAT "x(8)"
    FIELD pais-num AS CHARACTER FORMAT "x(3)"
    FIELD ok       AS LOGICAL
    FIELD msg      AS CHARACTER
    FIELD corpo    AS CHARACTER
    INDEX idx01 IS PRIMARY UNIQUE ncm pais-num.

/* ------------------------------------------------------------------------- */
PROCEDURE pi-ttce-obtem-ncm-pais:
    DEFINE INPUT  PARAMETER pCodItem   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pIsoFabric AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pNcm       AS CHARACTER NO-UNDO INIT "".
    DEFINE OUTPUT PARAMETER pPaisNum   AS CHARACTER NO-UNDO INIT "".

    FIND FIRST item NO-LOCK
        WHERE item.it-codigo = pCodItem NO-ERROR.
    IF AVAILABLE item THEN
        ASSIGN pNcm = REPLACE(TRIM(item.class-fiscal), ".", "").

    IF pIsoFabric <> "" THEN DO:
        FIND FIRST pais NO-LOCK
            WHERE SUBSTRING(pais.char-1,23,02) = pIsoFabric NO-ERROR.
        IF AVAILABLE pais AND pais.cod-pais-siscomex <> "" THEN DO:
            /* cod-pais-siscomex = 3 digitos do codigo + 1 digito verificador;
               o TTCE usa apenas os 3 primeiros (ex.: "105" Brasil, "063") */
            ASSIGN pPaisNum = STRING(INTEGER(SUBSTRING(pais.cod-pais-siscomex,1,3))) NO-ERROR.
            IF pPaisNum = ? THEN ASSIGN pPaisNum = "".
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* ------------------------------------------------------------------------- */
/* de-para do codigo do tributo (TTCE numerico -> codigo DUIMP descritivo)   */
FUNCTION fn-ttce-cod-duimp RETURNS CHARACTER (INPUT pCodTrib AS CHARACTER):
    CASE pCodTrib:
        WHEN "1"  THEN RETURN "II":U.
        WHEN "2"  THEN RETURN "IPI":U.
        WHEN "3"  THEN RETURN "ANTIDUMPING":U.
        WHEN "4"  THEN RETURN "CIDE":U.
        WHEN "5"  THEN RETURN "MEDIDAS":U.
        WHEN "6"  THEN RETURN "PIS":U.
        WHEN "7"  THEN RETURN "COFINS":U.
        WHEN "20" THEN RETURN "CBS":U.
        WHEN "21" THEN RETURN "IBS_ESTADUAL":U.
        WHEN "22" THEN RETURN "IBS_MUNICIPAL":U.
        OTHERWISE      RETURN "".
    END CASE.
END FUNCTION.

/* ------------------------------------------------------------------------- */
/* valor do atributo dinamico: busca em item-atrib-det (tabela definitiva);  */
/* escolhe o campo conforme a forma de preenchimento (classif-atrib):        */
/*   1 Lista/dominio -> cod-domin; 2 Inteiro -> num-valor;                   */
/*   3 Decimal -> val-valor; 4 Texto -> cod-valor; 5 Logico -> log-valor.    */
/* se nao houver valor, devolve coringa ("0" numerico, "XXXX" dominio/EX).   */
PROCEDURE pi-ttce-valor-atributo:
    DEFINE INPUT  PARAMETER pCodItem  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pCodAtrib AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pTipoCod  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pValor    AS CHARACTER NO-UNDO INIT "".

    DEFINE VARIABLE lAchou AS LOGICAL NO-UNDO.

    RUN pi-ttce-obtem-valor-atributo (INPUT  pCodItem,
                                      INPUT  pCodAtrib,
                                      OUTPUT lAchou,
                                      OUTPUT pValor).
    IF lAchou THEN
        RETURN "OK":U.

    /* coringa: numerico -> "0"; dominio dinamico / lista / EX -> "XXXX" */
    IF INDEX(pTipoCod, "mero") > 0 THEN   /* "Numero real", "Numero inteiro" */
        ASSIGN pValor = "0".
    ELSE
        ASSIGN pValor = "XXXX".

    RETURN "OK":U.
END PROCEDURE.

/* ------------------------------------------------------------------------- */
PROCEDURE pi-ttce-monta-tributos:
    DEFINE INPUT  PARAMETER pCodItem AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pNcm     AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pPaisNum AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER poArr    AS PROGRESS.Json.ObjectModel.JsonArray NO-UNDO.
    DEFINE OUTPUT PARAMETER pMontou  AS LOGICAL   NO-UNDO INIT NO.
    DEFINE OUTPUT PARAMETER pMsgErro AS CHARACTER NO-UNDO INIT "".

    DEFINE VARIABLE lcBody    AS LONGCHAR  NO-UNDO.
    DEFINE VARIABLE lcResp    AS LONGCHAR  NO-UNDO.
    DEFINE VARIABLE cEndPoint AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cData     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE oParser   AS PROGRESS.Json.ObjectModel.ObjectModelParser NO-UNDO.
    DEFINE VARIABLE oRoot     AS PROGRESS.Json.ObjectModel.JsonObject         NO-UNDO.
    DEFINE VARIABLE oTratArr  AS PROGRESS.Json.ObjectModel.JsonArray          NO-UNDO.
    DEFINE VARIABLE oArrCache AS PROGRESS.Json.ObjectModel.JsonArray          NO-UNDO.
    DEFINE VARIABLE lcArr     AS LONGCHAR  NO-UNDO.
    DEFINE VARIABLE iIdx      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iPaisNum  AS INTEGER   NO-UNDO.

    IF pNcm = "" THEN DO:
        ASSIGN pMsgErro = "TTCE: item " + pCodItem + " sem NCM (classificacao fiscal).".
        RETURN.
    END.

    ASSIGN iPaisNum = INTEGER(pPaisNum) NO-ERROR.
    IF pPaisNum = "" OR iPaisNum = ? THEN DO:
        ASSIGN pMsgErro = "TTCE: item " + pCodItem + " sem pais de origem valido (codigoPais); bloco de tributos nao gerado.".
        RETURN.
    END.

    ASSIGN cData = STRING(YEAR(TODAY),"9999") + "-"
                 + STRING(MONTH(TODAY),"99") + "-"
                 + STRING(DAY(TODAY),"99").

    /* cache por NCM+pais: guarda o ARRAY de tributos ja resolvido (pequeno) */
    FIND FIRST tt-ttce-cache
        WHERE tt-ttce-cache.ncm      = pNcm
        AND   tt-ttce-cache.pais-num = pPaisNum NO-ERROR.

    IF NOT AVAILABLE tt-ttce-cache THEN DO:
        ASSIGN cEndPoint = "/ttce/api/ext/tratamentos-tributarios/importacao/".

        FIX-CODEPAGE (lcBody) = 'UTF-8'.
        ASSIGN lcBody = '~{"ncm":"' + pNcm + '"'
                      + ',"codigoPais":' + STRING(iPaisNum)
                      + ',"dataFatoGerador":"' + cData + '"'
                      + ',"tipoOperacao":"I"~}'.

        RUN piIntegraTTCE (INPUT  lcBody,
                           INPUT  cEndPoint,
                           INPUT  "POST":U,
                           OUTPUT lcResp) NO-ERROR.

        CREATE tt-ttce-cache.
        ASSIGN tt-ttce-cache.ncm      = pNcm
               tt-ttce-cache.pais-num = pPaisNum
               tt-ttce-cache.ok       = (NOT ERROR-STATUS:ERROR AND lcResp <> "").

        IF NOT tt-ttce-cache.ok THEN DO:
            ASSIGN tt-ttce-cache.msg = "TTCE indisponivel para NCM " + pNcm
                                     + " / pais " + pPaisNum + ".".
            ASSIGN pMsgErro = tt-ttce-cache.msg.
            RETURN.
        END.

        /* parse do corpo bruto (LONGCHAR local; nunca vai para temp-table) */
        ASSIGN oParser = NEW PROGRESS.Json.ObjectModel.ObjectModelParser().
        oRoot = CAST(oParser:Parse(lcResp), PROGRESS.Json.ObjectModel.JsonObject) NO-ERROR.
        IF NOT VALID-OBJECT(oRoot) OR NOT oRoot:Has("tratamentosTributarios") THEN DO:
            ASSIGN tt-ttce-cache.ok  = NO
                   tt-ttce-cache.msg = "TTCE: resposta sem tratamentosTributarios (NCM " + pNcm + ").".
            ASSIGN pMsgErro = tt-ttce-cache.msg.
            RETURN.
        END.

        oTratArr = oRoot:GetJsonArray("tratamentosTributarios") NO-ERROR.
        IF NOT VALID-OBJECT(oTratArr) THEN DO:
            ASSIGN tt-ttce-cache.ok  = NO
                   tt-ttce-cache.msg = "TTCE: tratamentosTributarios invalido (NCM " + pNcm + ").".
            ASSIGN pMsgErro = tt-ttce-cache.msg.
            RETURN.
        END.

        /* monta o array resolvido (pequeno) e serializa no cache */
        ASSIGN oArrCache = NEW PROGRESS.Json.ObjectModel.JsonArray().
        DO iIdx = 1 TO oTratArr:Length:
            RUN pi-ttce-monta-um-tratamento (INPUT  pCodItem,
                                             INPUT  oTratArr:GetJsonObject(iIdx),
                                             INPUT  oArrCache).
        END.

        ASSIGN lcArr = "".
        FIX-CODEPAGE (lcArr) = 'UTF-8'.
        oArrCache:Write(lcArr) NO-ERROR.
        ASSIGN tt-ttce-cache.corpo = STRING(lcArr).
    END.

    IF NOT tt-ttce-cache.ok THEN DO:
        ASSIGN pMsgErro = tt-ttce-cache.msg.
        RETURN.
    END.

    /* reidrata o array resolvido do cache e copia para poArr */
    ASSIGN oParser   = NEW PROGRESS.Json.ObjectModel.ObjectModelParser()
           oArrCache = CAST(oParser:Parse(tt-ttce-cache.corpo),
                            PROGRESS.Json.ObjectModel.JsonArray) NO-ERROR.
    IF VALID-OBJECT(oArrCache) THEN
        DO iIdx = 1 TO oArrCache:Length:
            poArr:ADD(oArrCache:GetJsonObject(iIdx)).
        END.

    ASSIGN pMontou = (poArr:Length > 0).
    IF NOT pMontou THEN
        ASSIGN pMsgErro = "TTCE: NCM " + pNcm + " sem fundamentos normais a informar.".

    RETURN "OK":U.
END PROCEDURE.

/* ------------------------------------------------------------------------- */
/* valor CADASTRADO do atributo no item (item-atrib-det). pAchou=YES somente  */
/* quando existe cadastro com valor; senao pAchou=NO.                         */
PROCEDURE pi-ttce-item-tem-atributo:
    DEFINE INPUT  PARAMETER pCodItem  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pCodAtrib AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pAchou    AS LOGICAL   NO-UNDO INIT NO.
    DEFINE OUTPUT PARAMETER pValor    AS CHARACTER NO-UNDO INIT "".

    RUN pi-ttce-obtem-valor-atributo (INPUT  pCodItem,
                                      INPUT  pCodAtrib,
                                      OUTPUT pAchou,
                                      OUTPUT pValor).
    RETURN "OK":U.
END PROCEDURE.

/* ------------------------------------------------------------------------- */
/* obtem o valor CADASTRADO do atributo no item (item-atrib-det), resolvendo  */
/* a forma de preenchimento (registro ou classif-atrib) e convertendo por     */
/* tipo. pAchou=YES somente quando existe item-atrib-det com valor nao-vazio. */
PROCEDURE pi-ttce-obtem-valor-atributo:
    DEFINE INPUT  PARAMETER pCodItem  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pCodAtrib AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pAchou    AS LOGICAL   NO-UNDO INIT NO.
    DEFINE OUTPUT PARAMETER pValor    AS CHARACTER NO-UNDO INIT "".

    DEFINE VARIABLE iForma AS INTEGER NO-UNDO.

    FIND FIRST item-atrib-det NO-LOCK
        WHERE item-atrib-det.cod-item  = pCodItem
        AND   item-atrib-det.cod-atrib = pCodAtrib NO-ERROR.
    IF NOT AVAILABLE item-atrib-det THEN RETURN.

    /* forma de preenchimento: usa a do proprio registro; se vazia,
       busca em classif-atrib pela classificacao/atributo/modal */
    ASSIGN iForma = item-atrib-det.id-forma-preench.
    IF iForma = 0 OR iForma = ? THEN DO:
        FIND FIRST classif-atrib NO-LOCK
            WHERE classif-atrib.cod-class-fisc = item-atrib-det.cod-class-fisc
            AND   classif-atrib.cod-atributo   = item-atrib-det.cod-atrib
            AND   classif-atrib.ind-modal      = item-atrib-det.ind-modal NO-ERROR.
        IF AVAILABLE classif-atrib THEN
            ASSIGN iForma = classif-atrib.idi-forma-preench.
    END.

    CASE iForma:
        WHEN 1 THEN ASSIGN pValor = STRING(item-atrib-det.cod-domin).   /* Lista/dominio */
        WHEN 2 THEN ASSIGN pValor = STRING(item-atrib-det.num-valor).   /* Inteiro */
        WHEN 3 THEN ASSIGN pValor = STRING(item-atrib-det.val-valor).   /* Decimal */
        WHEN 4 THEN ASSIGN pValor = item-atrib-det.cod-valor.           /* Texto */
        WHEN 5 THEN ASSIGN pValor = IF item-atrib-det.log-valor THEN "true":U ELSE "false":U. /* Logico */
        OTHERWISE   ASSIGN pValor = item-atrib-det.cod-valor.           /* fallback texto */
    END CASE.

    IF pValor <> "" AND pValor <> ? THEN
        ASSIGN pAchou = YES.

    RETURN "OK":U.
END PROCEDURE.

/* ------------------------------------------------------------------------- */
PROCEDURE pi-ttce-monta-um-tratamento:
    DEFINE INPUT PARAMETER pCodItem AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER poTrat   AS PROGRESS.Json.ObjectModel.JsonObject NO-UNDO.
    DEFINE INPUT PARAMETER poArr    AS PROGRESS.Json.ObjectModel.JsonArray  NO-UNDO.

    DEFINE VARIABLE oTrib    AS PROGRESS.Json.ObjectModel.JsonObject NO-UNDO.
    DEFINE VARIABLE oTrb     AS PROGRESS.Json.ObjectModel.JsonObject NO-UNDO.
    DEFINE VARIABLE oReg     AS PROGRESS.Json.ObjectModel.JsonObject NO-UNDO.
    DEFINE VARIABLE oFund    AS PROGRESS.Json.ObjectModel.JsonObject NO-UNDO.
    DEFINE VARIABLE oAtrArr  AS PROGRESS.Json.ObjectModel.JsonArray  NO-UNDO.
    DEFINE VARIABLE oAtr     AS PROGRESS.Json.ObjectModel.JsonObject NO-UNDO.
    DEFINE VARIABLE oSubTrb  AS PROGRESS.Json.ObjectModel.JsonObject NO-UNDO.
    DEFINE VARIABLE oSubReg  AS PROGRESS.Json.ObjectModel.JsonObject NO-UNDO.
    DEFINE VARIABLE oSubFund AS PROGRESS.Json.ObjectModel.JsonObject NO-UNDO.
    DEFINE VARIABLE oMercArr AS PROGRESS.Json.ObjectModel.JsonArray  NO-UNDO.
    DEFINE VARIABLE oMerc    AS PROGRESS.Json.ObjectModel.JsonObject NO-UNDO.
    DEFINE VARIABLE oFonteAt AS PROGRESS.Json.ObjectModel.JsonArray  NO-UNDO.
    DEFINE VARIABLE oAtrIn   AS PROGRESS.Json.ObjectModel.JsonObject NO-UNDO.
    DEFINE VARIABLE cCodTrib AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCodDui  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCodAtr  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cTipoCod AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cValMerc AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cValCad  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lAchou   AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE a         AS INTEGER  NO-UNDO.
    DEFINE VARIABLE m         AS INTEGER  NO-UNDO.
    /* escolha da mercadoria */
    DEFINE VARIABLE iMercCad      AS INTEGER NO-UNDO INIT 0.  /* casa por cadastro */
    DEFINE VARIABLE iMercFallb    AS INTEGER NO-UNDO INIT 0.  /* fallback all-XXXX */
    DEFINE VARIABLE iQtdFallb     AS INTEGER NO-UNDO INIT 0.  /* menos atributos   */
    DEFINE VARIABLE lTemCadNaMerc AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lCasaCad      AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lTodosPreench AS LOGICAL NO-UNDO.  /* fallback: todos XXXX ou vazio (coringa) */
    DEFINE VARIABLE iQtdAtr       AS INTEGER NO-UNDO.
    DEFINE VARIABLE iMercEscol    AS INTEGER NO-UNDO INIT 0.

    IF NOT VALID-OBJECT(poTrat) THEN RETURN.

    oSubTrb  = poTrat:GetJsonObject("tributo") NO-ERROR.
    oSubReg  = poTrat:GetJsonObject("regime") NO-ERROR.
    oSubFund = poTrat:GetJsonObject("fundamentoLegal") NO-ERROR.
    IF NOT VALID-OBJECT(oSubTrb) OR NOT VALID-OBJECT(oSubReg)
    OR NOT VALID-OBJECT(oSubFund) THEN RETURN.

    ASSIGN cCodTrib = oSubTrb:GetCharacter("codigo")
           cCodDui  = fn-ttce-cod-duimp(cCodTrib).
    IF cCodDui = "" THEN RETURN.   /* tributo sem correspondencia na DUIMP */

    oMercArr = poTrat:GetJsonArray("mercadorias") NO-ERROR.
    IF NOT VALID-OBJECT(oMercArr) OR oMercArr:Length < 1 THEN RETURN.

    /* ----- 1a passada: escolher a mercadoria ----- */
    DO m = 1 TO oMercArr:Length:
        oMerc = oMercArr:GetJsonObject(m) NO-ERROR.
        IF NOT VALID-OBJECT(oMerc) THEN NEXT.
        oFonteAt = oMerc:GetJsonArray("atributos") NO-ERROR.
        IF NOT VALID-OBJECT(oFonteAt) THEN NEXT.

        ASSIGN lTemCadNaMerc = NO
               lCasaCad      = YES
               lTodosPreench = YES
               iQtdAtr       = oFonteAt:Length.

        DO a = 1 TO oFonteAt:Length:
            oAtrIn = oFonteAt:GetJsonObject(a) NO-ERROR.
            IF NOT VALID-OBJECT(oAtrIn) THEN NEXT.
            ASSIGN cCodAtr  = oAtrIn:GetCharacter("codigo")
                   cValMerc = oAtrIn:GetCharacter("valor").

            /* preenchivel = XXXX (nao se enquadra) ou vazio (resolvido por
               cadastro/coringa). Valor de dominio fixo (ex.: 0001/0002) NAO. */
            IF cValMerc <> "XXXX" AND cValMerc <> "" AND cValMerc <> ? THEN
                ASSIGN lTodosPreench = NO.

            RUN pi-ttce-item-tem-atributo (INPUT pCodItem,
                                           INPUT cCodAtr,
                                           OUTPUT lAchou,
                                           OUTPUT cValCad).
            IF lAchou THEN DO:
                ASSIGN lTemCadNaMerc = YES.
                IF cValCad <> cValMerc THEN ASSIGN lCasaCad = NO.
            END.
        END.

        /* prioridade (a): mercadoria que casa com o cadastro do item */
        IF iMercCad = 0 AND lTemCadNaMerc AND lCasaCad THEN
            ASSIGN iMercCad = m.

        /* fallback (b): todos preenchiveis (XXXX/vazio), a de menos atributos */
        IF lTodosPreench THEN
            IF iMercFallb = 0 OR iQtdAtr < iQtdFallb THEN
                ASSIGN iMercFallb = m
                       iQtdFallb  = iQtdAtr.
    END.

    ASSIGN iMercEscol = IF iMercCad > 0 THEN iMercCad ELSE iMercFallb.

    /* (c): nenhuma opcao valida -> nao monta este tributo */
    IF iMercEscol = 0 THEN RETURN.

    /* ----- 2a passada: montar os atributos da mercadoria escolhida ----- */
    oMerc    = oMercArr:GetJsonObject(iMercEscol) NO-ERROR.
    oFonteAt = oMerc:GetJsonArray("atributos") NO-ERROR.
    IF NOT VALID-OBJECT(oFonteAt) THEN RETURN.

    ASSIGN oTrib   = NEW PROGRESS.Json.ObjectModel.JsonObject()
           oTrb    = NEW PROGRESS.Json.ObjectModel.JsonObject()
           oReg    = NEW PROGRESS.Json.ObjectModel.JsonObject()
           oFund   = NEW PROGRESS.Json.ObjectModel.JsonObject()
           oAtrArr = NEW PROGRESS.Json.ObjectModel.JsonArray().

    oTrb:ADD("codigo", cCodDui).
    oReg:ADD("codigo", oSubReg:GetCharacter("codigo")).
    oFund:ADD("codigo", oSubFund:GetCharacter("codigo")).

    DO a = 1 TO oFonteAt:Length:
        oAtrIn = oFonteAt:GetJsonObject(a) NO-ERROR.
        IF NOT VALID-OBJECT(oAtrIn) THEN NEXT.
        ASSIGN cCodAtr  = oAtrIn:GetCharacter("codigo")
               cValMerc = oAtrIn:GetCharacter("valor")
               cTipoCod = "".
        IF oAtrIn:Has("tipoCodigo") THEN
            ASSIGN cTipoCod = oAtrIn:GetCharacter("tipoCodigo").

        /* valor cadastrado tem prioridade; senao usa o valor da mercadoria;
           se a mercadoria nao trouxe valor, cai no coringa por tipo */
        RUN pi-ttce-item-tem-atributo (INPUT pCodItem,
                                       INPUT cCodAtr,
                                       OUTPUT lAchou,
                                       OUTPUT cValCad).

        IF lAchou THEN
            ASSIGN cValMerc = cValCad.
        ELSE IF cValMerc = "" OR cValMerc = ? THEN DO:
            /* coringa: numerico -> "0"; dominio/lista/EX -> "XXXX" */
            IF INDEX(cTipoCod, "mero") > 0 THEN
                ASSIGN cValMerc = "0".
            ELSE
                ASSIGN cValMerc = "XXXX".
        END.

        ASSIGN oAtr = NEW PROGRESS.Json.ObjectModel.JsonObject().
        oAtr:ADD("codigo", cCodAtr).
        oAtr:ADD("valor", cValMerc).
        oAtrArr:ADD(oAtr).
    END.

    oTrib:ADD("tributo", oTrb).
    oTrib:ADD("regime", oReg).
    oTrib:ADD("fundamento", oFund).
    oTrib:ADD("atributos", oAtrArr).
    poArr:ADD(oTrib).

    RETURN "OK":U.
END PROCEDURE.
