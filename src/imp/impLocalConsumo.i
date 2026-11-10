/******************************************************************************
** impLocalConsumo.i
** Monta o Local de Consumo (UF + codigo IBGE do municipio) para itens de
** importacao, reutilizavel em rotinas de comex.
**
** Uso: {imp/impLocalConsumo.i} no fonte, depois:
**      RUN pi-monta-local-consumo (INPUT cod-estabel-embarque,
**                                  INPUT numero-ordem,
**                                  OUTPUT cod-livre-1).
**
** Formato de saida (cod-livre-1): posicoes 1-2 = UF, posicoes 3-9 = IBGE.
******************************************************************************/

PROCEDURE pi-monta-local-consumo:
    DEFINE INPUT  PARAMETER pcCodEstabEmb AS CHARACTER NO-UNDO. /* ordens-embarque.cod-estabel */
    DEFINE INPUT  PARAMETER piNumeroOrdem AS INTEGER   NO-UNDO. /* ordens-embarque.numero-ordem */
    DEFINE OUTPUT PARAMETER pcCodLivre1   AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cEstabConsumo AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCodIBGE      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iDomFisc      AS INTEGER   NO-UNDO.

    ASSIGN pcCodLivre1 = "".

    /* Opcao A: estabelecimento do local de entrega da ordem (local-entrega = 1) */
    FIND FIRST ordem-compra NO-LOCK
        WHERE ordem-compra.numero-ordem = piNumeroOrdem NO-ERROR.
    IF  AVAILABLE ordem-compra
    AND ordem-compra.local-entrega = 1
    AND ordem-compra.estab-entrega <> "" THEN
        ASSIGN cEstabConsumo = ordem-compra.estab-entrega.
    ELSE
        ASSIGN cEstabConsumo = pcCodEstabEmb. /* fallback: estabelecimento do embarque */

    FIND FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = cEstabConsumo NO-ERROR.
    IF  AVAILABLE estabelec THEN DO:
        RUN pi-pesquisa-cod-ibge-lc (INPUT  estabelec.pais,
                                     INPUT  estabelec.estado,
                                     INPUT  estabelec.cidade,
                                     OUTPUT iCodIBGE,
                                     OUTPUT iDomFisc).
        ASSIGN pcCodLivre1 = estabelec.estado + STRING(iCodIBGE, "9999999").
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-pesquisa-cod-ibge-lc:
    DEFINE INPUT  PARAMETER pcPais    AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcEstado  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcCidade  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER piCodIBGE AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER piDomFisc AS INTEGER   NO-UNDO.

    DEFINE VARIABLE c-uf-Localizada AS CHARACTER NO-UNDO.
    DEFINE VARIABLE hlf0202d        AS HANDLE    NO-UNDO.

    FOR FIRST cidade NO-LOCK
        WHERE cidade.cidade = pcCidade
        AND   cidade.estado = pcEstado
        AND   cidade.pais   = pcPais:
    END.

    IF  NOT AVAIL cidade
    OR  &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN
        cidade.cdn-munpio-ibge = ? OR cidade.cdn-munpio-ibge = 0
        &ELSE
        cidade.int-2 = ? OR cidade.int-2 = 0
        &ENDIF
    THEN DO:
        RUN lfp/lf0202d.p PERSISTENT SET hlf0202d.
        RUN sendState     IN hlf0202d (INPUT pcEstado).
        RUN initializeInf IN hlf0202d.
        RUN returnCityInf IN hlf0202d (INPUT  pcCidade,
                                       INPUT  pcEstado,
                                       OUTPUT piCodIBGE,
                                       OUTPUT piDomFisc,
                                       OUTPUT c-uf-Localizada).
        RUN finalizeInf   IN hlf0202d.
        DELETE PROCEDURE hlf0202d.
        ASSIGN hlf0202d = ?.
    END.
    ELSE DO:
        &IF '{&bf_dis_versao_ems}' >= '2.07':U &THEN
            IF  AVAIL cidade THEN
                ASSIGN piCodIBGE = cidade.cdn-munpio-ibge
                       piDomFisc = cidade.cdn-domic-fisc.
        &ELSE
            IF  AVAIL cidade THEN
                ASSIGN piCodIBGE = cidade.int-2
                       piDomFisc = cidade.int-1.
        &ENDIF
    END.

    RETURN "OK":U.
END PROCEDURE.
