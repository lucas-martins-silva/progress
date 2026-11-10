/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9055 2.00.00.007} /*** "010007" 20/08/2026 16:06:09 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9055 MIM}
&ENDIF

{cdp/cdcfgmat.i} /*Defini‡Æo pre-processadores*/

DEFINE INPUT PARAMETER pi-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
DEFINE INPUT PARAMETER pi-cod-emitente LIKE emitente.cod-emitente     NO-UNDO.
DEFINE INPUT PARAMETER pc-it-codigo    LIKE item.it-codigo            NO-UNDO.

/*Defini‡Æo de vari veis*/
DEFINE VARIABLE c-ponto-controle   AS   CHARACTER                      NO-UNDO.
DEFINE VARIABLE de-aliq-ipi        AS   DECIMAL   FORMAT ">>9.99":U    NO-UNDO.
DEFINE VARIABLE de-aliq-ii         AS   DECIMAL   FORMAT ">>9.9999":U  NO-UNDO.
DEFINE VARIABLE de-aliq-ipi-antiga LIKE cotacao-item.aliquota-ipi      NO-UNDO.
DEFINE VARIABLE l-preco-bruto      AS   LOGICAL                        NO-UNDO.
DEFINE VARIABLE l-ativo            AS   LOGICAL                        NO-UNDO.
DEFINE VARIABLE de-fator-conv      AS   DECIMAL                        NO-UNDO.

&IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
    DEFINE VARIABLE i-cod-fabricante AS INTEGER FORMAT ">>>>>>>>9":U NO-UNDO.
    DEFINE VARIABLE i-cdn-pais-orig  AS INTEGER FORMAT ">>,>>9":U    NO-UNDO.
    DEFINE VARIABLE i-regime-import  AS INTEGER FORMAT ">9":U        NO-UNDO.
    DEFINE VARIABLE h-boin082i       AS HANDLE                       NO-UNDO.
&ENDIF

DEFINE BUFFER b-cotacao-item FOR cotacao-item.
DEFINE BUFFER b-ordem-compra FOR ordem-compra.

FIND FIRST param-compra NO-LOCK NO-ERROR.
ASSIGN l-ativo = IF param-compra.perm-cot-for = YES THEN ?
                 ELSE NO.

FOR EACH cotacao-item
    WHERE cotacao-item.numero-ordem = pi-numero-ordem
      AND cotacao-item.cod-emitente = pi-cod-emitente
      AND cotacao-item.it-codigo    = pc-it-codigo NO-LOCK:

    FIND FIRST b-cotacao-item
         WHERE ROWID(b-cotacao-item) = ROWID(cotacao-item) EXCLUSIVE-LOCK NO-ERROR.

    FIND FIRST b-ordem-compra
         WHERE b-ordem-compra.numero-ordem = cotacao-item.numero-ordem EXCLUSIVE-LOCK NO-ERROR.

    FIND FIRST param-imp
         WHERE param-imp.cod-estabel = b-ordem-compra.cod-estabel NO-LOCK NO-ERROR.
    IF NOT AVAIL param-imp THEN NEXT.

    FIND FIRST ITEM
         WHERE ITEM.it-codigo = b-ordem-compra.it-codigo NO-LOCK NO-ERROR.

    FOR FIRST emitente-cex
        WHERE emitente-cex.cod-emitente = pi-cod-emitente NO-LOCK:
    END.
    IF NOT AVAIL emitente-cex THEN NEXT. /* Se nao existe fornecedor internacional cadastrado, nao haverao os dados de importacao para serem carregados */

    IF AVAIL b-cotacao-item THEN DO:

        &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
            ASSIGN c-ponto-controle = STRING(emitente-cex.cod-pto-contr).
        &ELSE
            ASSIGN c-ponto-controle = TRIM(SUBSTRING(emitente-cex.char-1,11,6)).
        &ENDIF

        /* Incoterm */
        IF SUBSTRING(b-cotacao-item.char-1,21,20) = "" THEN
            ASSIGN OVERLAY(b-cotacao-item.char-1,21,20) = STRING(emitente-cex.cod-incoterm-imp).

        /* Ponto de Controle*/
        IF SUBSTRING(b-cotacao-item.char-1,41,20) = "" THEN
           ASSIGN OVERLAY(b-cotacao-item.char-1,41,20) = c-ponto-controle.

        /* Itinerario */
        IF b-cotacao-item.int-1 = 0 THEN DO:
           ASSIGN b-cotacao-item.int-1 = IF AVAIL param-imp AND param-imp.int-1 = 2 THEN emitente-cex.cod-itiner-imp ELSE 0.
        END.

        /* Data de Embarque */
        IF TRIM(SUBSTRING(b-cotacao-item.char-2,81,20)) = "":U THEN
           ASSIGN OVERLAY(b-cotacao-item.char-2,81,20) = string(TODAY).

        /* Classifica‡Æo fiscal
           - Independente do tipo de controle do item, devera ser gravada a classificacao fiscal do cadastro na cotacao do item */
        IF TRIM(SUBSTRING(b-cotacao-item.char-1,81,20)) = "":U THEN
            ASSIGN OVERLAY(b-cotacao-item.char-1,81,20) = ITEM.class-fiscal.

        /* Fabricante */
        ASSIGN OVERLAY(b-cotacao-item.char-2,41,20) = STRING(cotacao-item.cod-emitente).

        /*Aliquota IPI*/
        ASSIGN de-aliq-ipi-antiga = cotacao-item.aliquota-ipi.

        &IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
            IF NOT VALID-HANDLE(h-boin082i) THEN
                RUN inbo/boin082i.p PERSISTENT SET h-boin082i.

            /* Busca o valor padrao do fabricante, do pais de origem e do regime de importacao padrao */
            RUN setDefaultsIm0060 IN h-boin082i (INPUT  cotacao-item.it-codigo,
                                                 INPUT  cotacao-item.cod-emitente,
                                                 INPUT  TRIM(SUBSTRING(cotacao-item.char-1,81,20)), /* class-fiscal */
                                                 OUTPUT i-cod-fabricante,
                                                 OUTPUT i-cdn-pais-orig,
                                                 OUTPUT i-regime-import).

            IF b-cotacao-item.cdn-pais-orig = 0 THEN
               ASSIGN b-cotacao-item.cdn-pais-orig = i-cdn-pais-orig.

            IF SUBSTRING(b-cotacao-item.char-2,41,20) = "" THEN
               ASSIGN OVERLAY(b-cotacao-item.char-2,41,20) = STRING(i-cod-fabricante).

            IF SUBSTRING(b-cotacao-item.char-2,61,20) = "" THEN
               ASSIGN OVERLAY(b-cotacao-item.char-2,61,20) = STRING(i-regime-import).

            /* Busca aliquotas II e IPI */
            RUN calculateII_IPI in h-boin082i (INPUT  cotacao-item.it-codigo,
                                               INPUT  cotacao-item.numero-ordem,
                                               INPUT  cotacao-item.aliquota-ipi,
                                               INPUT  SUBSTRING(cotacao-item.char-1,81,20), /* class-fiscal */
                                               INPUT  cotacao-item.cdn-pais-orig,
                                               INPUT  INT(TRIM(SUBSTRING(cotacao-item.char-2,61,20))), /* regime-import */
                                               OUTPUT de-aliq-ii,
                                               OUTPUT de-aliq-ipi).

            IF  VALID-HANDLE(h-boin082i) THEN DO:
                DELETE PROCEDURE h-boin082i.
                ASSIGN h-boin082i = ?.
            END.

            IF SUBSTRING(b-cotacao-item.char-1,61,20) = "" THEN
               ASSIGN OVERLAY(b-cotacao-item.char-1,61,20) = STRING(de-aliq-ii).

            IF  b-cotacao-item.aliquota-ipi = 0 THEN
                ASSIGN b-cotacao-item.aliquota-ipi = de-aliq-ipi.

        &ELSE
            /* Na 204 Busca-se apenas a informacao de aliquota de II regime de importacao deve ser informado manualmente no IM0060
               Nao h  tratamento da aliquota do IPI pois "compras" j  traz essa informacao correta para o ems2.04 */
            IF  ITEM.tipo-contr = 4 THEN DO:
                FIND FIRST classif-fisc
                     WHERE classif-fisc.class-fiscal = ITEM.class-fiscal NO-LOCK NO-ERROR.

                ASSIGN de-aliq-ii  = IF AVAIL classif-fisc THEN DECIMAL(substring(classif-fisc.char-1,10,6)) ELSE 0.
            END.
            ELSE
                ASSIGN de-aliq-ii  = IF SUBSTRING(ITEM.char-2,278,8) = "" THEN DECIMAL(SUBSTRING(ITEM.char-2,22,6))
                                                                          ELSE DECIMAL(SUBSTRING(ITEM.char-2,278,8)).

            /* Item isento de II */
            IF  INTEGER(SUBSTRING(ITEM.char-2,20,2)) = 2 THEN
                ASSIGN de-aliq-ii = IF SUBSTRING(ITEM.char-2,278,8) = "" THEN DECIMAL(SUBSTRING(ITEM.char-2,22,6))
                                                                         THEN DECIMAL(SUBSTRING(ITEM.char-2,278,8)). /*aliquota II*/

            IF SUBSTRING(b-cotacao-item.char-1,61,20) = "" THEN
                ASSIGN OVERLAY(b-cotacao-item.char-1,61,20) = string(de-aliq-ii).
        &ENDIF

        /* Recalcula valor do item quando altera a aliquota do IPI */
        IF  de-aliq-ipi-antiga <> cotacao-item.aliquota-ipi THEN DO:

            FOR FIRST item-fornec-estab NO-LOCK
                WHERE item-fornec-estab.it-codigo    = b-ordem-compra.it-codigo
                AND   item-fornec-estab.cod-estabel  = b-ordem-compra.cod-estabel
                AND   item-fornec-estab.ativo       <> l-ativo :
                ASSIGN de-fator-conv = (1 / (EXP(10, item-fornec-estab.num-casa-dec))) * item-fornec-estab.fator-conver.
            END.
            IF NOT AVAIL item-fornec-estab THEN DO:
                FOR FIRST item-fornec NO-LOCK
                    WHERE item-fornec.it-codigo     = b-ordem-compra.it-codigo
                    AND   item-fornec.cod-emitente  = b-cotacao-item.cod-emitente
                    AND   item-fornec.ativo        <> l-ativo :
                    ASSIGN de-fator-conv = (1 / (EXP(10, item-fornec.num-casa-dec))) * item-fornec.fator-conver.
                END.
            END.

            IF de-fator-conv = 0 THEN
                ASSIGN de-fator-conv = 1.

            ASSIGN l-preco-bruto = (param-compra.ipi-sobre-preco = 1).
            {cdp/cd9300.i cotacao-item}
            ASSIGN b-cotacao-item.preco-unit   = cotacao-item.pre-unit-for * de-fator-conv.

            ASSIGN b-ordem-compra.aliquota-ipi = cotacao-item.aliquota-ipi.
            {cdp/cd9300.i b-ordem-compra}
            ASSIGN b-ordem-compra.preco-unit   = b-ordem-compra.pre-unit-for * de-fator-conv.

            /*
            ** Calculo do preco de reposicao do item
            */
            RUN ccp/ccapi001.p (INPUT ROWID(b-ordem-compra)).
        END.
    END.
END.
