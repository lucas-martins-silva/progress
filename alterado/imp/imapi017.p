/******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMAPI017 2.00.00.020 } /* 26/08/2026 11:55:11 */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i IMAPI017 MIM}
&ENDIF

/*------------------------------------------------------------------------
    Programa    : IMAPI017
    Data        : 05/05/2025
    Objetivo    : API com procedures centralizadas para atendimento da
                  Reforma Tribut†ria
------------------------------------------------------------------------*/
{utp/ut-glob.i}
/******************* DEFINICAO TEMP-TABLE'S **********************************/
{imp/imapi017.i}  /*tt-tributo-import*/
{cxbo/bocx225e.i tt-ordens-desemb}
{cxbo/bocx00514.i tt-ordens-embarque-trib}
{dibo/bodi01141.i tt-relacto-tributo}
/******************* DEFINICAO PARAMETROS ***********************************/

/******************* DEFINICAO VARIAVEIS ************************************/
{cdp/cd4300.i3} /* Include Tratamento Atributo Livre */
{cxbo/bocx250.i50} /* include tratamento atributo livre */

DEFINE VARIABLE h-cdapi1005        AS   HANDLE                           NO-UNDO.
DEFINE VARIABLE h-reapi433         AS   HANDLE                           NO-UNDO.
DEFINE VARIABLE h-bodi613calc2     AS   HANDLE                           NO-UNDO.
DEFINE VARIABLE h-bodi317im2bra    AS   HANDLE                           NO-UNDO.
DEFINE VARIABLE dAliqDeson         AS   DECIMAL                          NO-UNDO.
DEFINE VARIABLE dPercRedAliqGov    AS   DECIMAL                          NO-UNDO.
DEFINE VARIABLE l-procedimento-ok  AS   LOGICAL                          NO-UNDO.
DEFINE VARIABLE i                  AS   INTEGER                          NO-UNDO.
DEFINE VARIABLE i-seq-item         AS   INTEGER                          NO-UNDO.
DEFINE VARIABLE dAliq              LIKE relacto-tributo.aliquota         NO-UNDO.
DEFINE VARIABLE dPercDifer         LIKE relacto-tributo.perc-diferido    NO-UNDO.
DEFINE VARIABLE dPercRed           LIKE relacto-tributo.perc-red         NO-UNDO.
DEFINE VARIABLE dPercCredPresum    LIKE relacto-tributo.perc-cred-presum NO-UNDO.
DEFINE variable i-cod-desp-ii      like item-doc-est-cex.cod-desp        NO-UNDO.
DEFINE variable i-num-di-ems       like decla-import.num-di-ems          NO-UNDO.
DEFINE variable i-num-adic         like decla-import.num-adic            NO-UNDO.
DEFINE variable i-num-seq          like decla-import.num-seq             NO-UNDO.
DEFINE VARIABLE de-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts   NO-UNDO.
DEFINE VARIABLE v-cod-nbs          AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE d-val-desp-convert LIKE despes-adic-itens.val-despes     NO-UNDO.
DEFINE VARIABLE h-bocx383          AS HANDLE                             NO-UNDO.
DEFINE VARIABLE de-qtde-trib-IS    AS DECIMAL                            NO-UNDO.
DEFINE VARIABLE de-qtde-calc-IS    AS DECIMAL INITIAL 0                  NO-UNDO.

{inbo/boin176.m98} /*procedure pi-gravar-dados-cfg-trib*/

/* ********************************************************************************* */
PROCEDURE piCalculaVALAduanCBS:
    DEFINE INPUT  PARAMETER pi-cod-emitente LIKE docum-est.cod-emitente                  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-serie-docto  LIKE docum-est.serie-docto                   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nro-docto    LIKE docum-est.nro-docto                     NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-operacao LIKE docum-est.nat-operacao                  NO-UNDO.
    DEFINE INPUT  PARAMETER pi-sequencia    LIKE item-doc-est.sequencia                  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo    LIKE item-doc-est.it-codigo                  NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-VA-CBS      AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO.

    FOR FIRST item-doc-est NO-LOCK
        WHERE item-doc-est.cod-emitente = pi-cod-emitente
          AND item-doc-est.serie-docto  = pc-serie-docto
          AND item-doc-est.nro-docto    = pc-nro-docto
          AND item-doc-est.nat-operacao = pc-nat-operacao
          AND item-doc-est.sequencia    = pi-sequencia
          AND item-doc-est.it-codigo    = pc-it-codigo:

         FOR EACH item-doc-est-cex
            WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
              AND item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
              AND item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
              AND item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
              AND item-doc-est-cex.sequencia    = item-doc-est.sequencia NO-LOCK:

            FOR FIRST desp-imp-trib
                WHERE desp-imp-trib.cod-desp = item-doc-est-cex.cod-desp NO-LOCK:

                IF desp-imp-trib.log-incide-base-CBS-vladu THEN      /* incide base CBS valor aduaneiro */
                    ASSIGN pde-VA-CBS = pde-VA-CBS + item-doc-est-cex.val-desp.

            END.
         END.
    END.

    IF NOT AVAIL item-doc-est THEN DO:
        if i-num-di-ems > 0 then do:
            for first decla-import-adic-itens no-lock
                where decla-import-adic-itens.num-di-ems = i-num-di-ems
                  and decla-import-adic-itens.num-adic   = i-num-adic
                  and decla-import-adic-itens.num-seq    = i-num-seq
                  AND decla-import-adic-itens.cdd-siscomex-dts = de-cdd-siscomex-dts:


                 for each despes-adic-itens
                   where despes-adic-itens.num-di-ems = decla-import-adic-itens.num-di-ems
                     and despes-adic-itens.num-adic   = decla-import-adic-itens.num-adic
                     and despes-adic-itens.num-seq    = decla-import-adic-itens.num-seq
                     AND despes-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts no-lock:

                     FOR FIRST desp-imp-trib
                        WHERE desp-imp-trib.cod-desp = despes-adic-itens.cdn-despes NO-LOCK:

                        IF desp-imp-trib.log-incide-base-CBS-vladu THEN DO:     /* incide base CBS valor aduaneiro */

                            IF despes-adic-itens.cdn-moed <> 0 THEN DO:

                                FIND FIRST decla-import NO-LOCK
                                     WHERE decla-import.num-di-ems       = decla-import-adic-itens.num-di-ems
                                     AND   decla-import.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts NO-ERROR.

                                IF NOT VALID-HANDLE(h-bocx383) THEN
                                    RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.

                                RUN converteValorMoeda IN h-bocx383 (INPUT  decla-import-adic-itens.num-di-ems,
                                                                     INPUT  decla-import-adic-itens.cdd-siscomex-dts,
                                                                     INPUT  despes-adic-itens.cdn-moeda,    /* moeda de origem */
                                                                     INPUT  0,                              /* moeda de destino */
                                                                     INPUT  despes-adic-itens.val-despes,   /* valor da despesa */
                                                                     INPUT  decla-import.dat-di,            /* data da di */
                                                                     OUTPUT d-val-desp-convert).
                            END.
                            ELSE
                                ASSIGN d-val-desp-convert = despes-adic-itens.val-despes.

                            ASSIGN pde-VA-CBS = pde-VA-CBS + d-val-desp-convert. /*despes-adic-itens.val-despes.*/

                        END.

                     end.
                 end.
            end.
        end.
    end.

    IF VALID-HANDLE(h-bocx383) THEN DO:
        DELETE PROCEDURE h-bocx383.
        ASSIGN h-bocx383 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE piCalculaValIBSUF:
    DEFINE INPUT  PARAMETER pi-cod-emitente LIKE docum-est.cod-emitente                  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-serie-docto  LIKE docum-est.serie-docto                   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nro-docto    LIKE docum-est.nro-docto                     NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-operacao LIKE docum-est.nat-operacao                  NO-UNDO.
    DEFINE INPUT  PARAMETER pi-sequencia    LIKE item-doc-est.sequencia                  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo    LIKE item-doc-est.it-codigo                  NO-UNDO.
    DEFINE OUTPUT parameter pde-VA-IBSUF    AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO.

    FOR FIRST item-doc-est NO-LOCK
        WHERE item-doc-est.cod-emitente = pi-cod-emitente
          AND item-doc-est.serie-docto  = pc-serie-docto
          AND item-doc-est.nro-docto    = pc-nro-docto
          AND item-doc-est.nat-operacao = pc-nat-operacao
          AND item-doc-est.sequencia    = pi-sequencia
          AND item-doc-est.it-codigo    = pc-it-codigo:


         FOR EACH item-doc-est-cex
            WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
              AND item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
              AND item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
              AND item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
              AND item-doc-est-cex.sequencia    = item-doc-est.sequencia NO-LOCK:

             FOR FIRST desp-imp-trib
                WHERE desp-imp-trib.cod-desp = item-doc-est-cex.cod-desp NO-LOCK:

                IF desp-imp-trib.log-incide-base-IBSUF THEN      /* incide base IBSUF */
                    ASSIGN pde-VA-IBSUF = pde-VA-IBSUF + item-doc-est-cex.val-desp.
             END.
         END.
    END.

    if not avail item-doc-est then do:
        if i-num-di-ems > 0 then do:
            for first decla-import-adic-itens no-lock
                where decla-import-adic-itens.num-di-ems = i-num-di-ems
                  and decla-import-adic-itens.num-adic   = i-num-adic
                  and decla-import-adic-itens.num-seq    = i-num-seq
                  AND decla-import-adic-itens.cdd-siscomex-dts = de-cdd-siscomex-dts:

                for each despes-adic-itens
                   where despes-adic-itens.num-di-ems = decla-import-adic-itens.num-di-ems
                     and despes-adic-itens.num-adic   = decla-import-adic-itens.num-adic
                     and despes-adic-itens.num-seq    = decla-import-adic-itens.num-seq
                     AND despes-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts no-lock:

                     FOR FIRST desp-imp-trib
                         WHERE desp-imp-trib.cod-desp = despes-adic-itens.cdn-despes NO-LOCK:

                        IF desp-imp-trib.log-incide-base-IBSUF  THEN DO:     /* incide base IBSUF */

                            IF despes-adic-itens.cdn-moed <> 0 THEN DO:

                                FIND FIRST decla-import NO-LOCK WHERE
                                           decla-import.num-di-ems = decla-import-adic-itens.num-di-ems AND
                                           decla-import.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts NO-ERROR.

                                IF NOT VALID-HANDLE(h-bocx383) THEN RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.

                                RUN converteValorMoeda IN h-bocx383 (INPUT  decla-import-adic-itens.num-di-ems,
                                                                     INPUT  decla-import-adic-itens.cdd-siscomex-dts,
                                                                     INPUT  despes-adic-itens.cdn-moeda,    /* moeda de origem */
                                                                     INPUT  0,                              /* moeda de destino */
                                                                     INPUT  despes-adic-itens.val-despes,   /* valor da despesa */
                                                                     INPUT  decla-import.dat-di,            /* data da di */
                                                                     OUTPUT d-val-desp-convert).
                            END.
                            ELSE
                                ASSIGN d-val-desp-convert = despes-adic-itens.val-despes.

                            ASSIGN pde-VA-IBSUF = pde-VA-IBSUF + d-val-desp-convert.

                        END.

                    end.
                end.
            end.
        end.
    end.

    IF VALID-HANDLE(h-bocx383) THEN DO:
        DELETE PROCEDURE h-bocx383.
        ASSIGN h-bocx383 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCalculaValIBSMun:
    DEFINE INPUT  PARAMETER pi-cod-emitente LIKE docum-est.cod-emitente                  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-serie-docto  LIKE docum-est.serie-docto                   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nro-docto    LIKE docum-est.nro-docto                     NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-operacao LIKE docum-est.nat-operacao                  NO-UNDO.
    DEFINE INPUT  PARAMETER pi-sequencia    LIKE item-doc-est.sequencia                  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo    LIKE item-doc-est.it-codigo                  NO-UNDO.
    DEFINE OUTPUT parameter pde-VA-IBSMun   AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999"   NO-UNDO.

    FOR FIRST item-doc-est NO-LOCK
        WHERE item-doc-est.cod-emitente = pi-cod-emitente
          AND item-doc-est.serie-docto  = pc-serie-docto
          AND item-doc-est.nro-docto    = pc-nro-docto
          AND item-doc-est.nat-operacao = pc-nat-operacao
          AND item-doc-est.sequencia    = pi-sequencia
          AND item-doc-est.it-codigo    = pc-it-codigo:

         FOR EACH item-doc-est-cex
            WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
              AND item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
              AND item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
              AND item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
              AND item-doc-est-cex.sequencia    = item-doc-est.sequencia NO-LOCK:

             FOR FIRST desp-imp-trib
                WHERE desp-imp-trib.cod-desp = item-doc-est-cex.cod-desp NO-LOCK:

                IF desp-imp-trib.log-incide-base-IBSMun THEN      /* incide base IBSMun */
                    ASSIGN pde-VA-IBSMun = pde-VA-IBSMun + item-doc-est-cex.val-desp.
             END.
         END.
    END.

    if not avail item-doc-est then do:
        if i-num-di-ems > 0 then do:
            for first decla-import-adic-itens no-lock
                where decla-import-adic-itens.num-di-ems = i-num-di-ems
                  and decla-import-adic-itens.num-adic   = i-num-adic
                  and decla-import-adic-itens.num-seq    = i-num-seq
                  AND decla-import-adic-itens.cdd-siscomex-dts = de-cdd-siscomex-dts:

                for each despes-adic-itens
                   where despes-adic-itens.num-di-ems = decla-import-adic-itens.num-di-ems
                     and despes-adic-itens.num-adic   = decla-import-adic-itens.num-adic
                     and despes-adic-itens.num-seq    = decla-import-adic-itens.num-seq
                     AND despes-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts no-lock:

                     FOR FIRST desp-imp-trib
                         WHERE desp-imp-trib.cod-desp = despes-adic-itens.cdn-despes NO-LOCK:

                        IF desp-imp-trib.log-incide-base-IBSMun THEN DO:     /* incide base IBSMun */

                            IF despes-adic-itens.cdn-moed <> 0 THEN DO:

                                FIND FIRST decla-import NO-LOCK WHERE
                                           decla-import.num-di-ems = decla-import-adic-itens.num-di-ems AND
                                           decla-import.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts NO-ERROR.

                                IF NOT VALID-HANDLE(h-bocx383) THEN RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.

                                RUN converteValorMoeda IN h-bocx383 (INPUT  decla-import-adic-itens.num-di-ems,
                                                                     INPUT  decla-import-adic-itens.cdd-siscomex-dts,
                                                                     INPUT  despes-adic-itens.cdn-moeda,    /* moeda de origem */
                                                                     INPUT  0,                              /* moeda de destino */
                                                                     INPUT  despes-adic-itens.val-despes,   /* valor da despesa */
                                                                     INPUT  decla-import.dat-di,            /* data da di */
                                                                     OUTPUT d-val-desp-convert).
                            END.
                            ELSE
                                ASSIGN d-val-desp-convert = despes-adic-itens.val-despes.

                            ASSIGN pde-VA-IBSMun = pde-VA-IBSMun + d-val-desp-convert.

                        END.
                    end.
                end.
            end.
        end.
    end.

    IF VALID-HANDLE(h-bocx383) THEN DO:
        DELETE PROCEDURE h-bocx383.
        ASSIGN h-bocx383 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCalculaValIS:
    DEFINE INPUT  PARAMETER pi-cod-emitente LIKE docum-est.cod-emitente                  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-serie-docto  LIKE docum-est.serie-docto                   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nro-docto    LIKE docum-est.nro-docto                     NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-operacao LIKE docum-est.nat-operacao                  NO-UNDO.
    DEFINE INPUT  PARAMETER pi-sequencia    LIKE item-doc-est.sequencia                  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo    LIKE item-doc-est.it-codigo                  NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-VA-IS       AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999"   NO-UNDO.

    FOR FIRST item-doc-est NO-LOCK
        WHERE item-doc-est.cod-emitente = pi-cod-emitente
          AND item-doc-est.serie-docto  = pc-serie-docto
          AND item-doc-est.nro-docto    = pc-nro-docto
          AND item-doc-est.nat-operacao = pc-nat-operacao
          AND item-doc-est.sequencia    = pi-sequencia
          AND item-doc-est.it-codigo    = pc-it-codigo:

         FOR EACH item-doc-est-cex
            WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
              AND item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
              AND item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
              AND item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
              AND item-doc-est-cex.sequencia    = item-doc-est.sequencia NO-LOCK:

             FOR FIRST desp-imp-trib
                WHERE desp-imp-trib.cod-desp = item-doc-est-cex.cod-desp NO-LOCK:

                IF desp-imp-trib.log-incide-base-IS THEN      /* incide base IS */
                    ASSIGN pde-VA-IS = pde-VA-IS + item-doc-est-cex.val-desp.
             END.
         END.
    END.

    IF NOT AVAIL item-doc-est THEN DO:
        IF i-num-di-ems > 0 THEN DO:
            FOR FIRST decla-import-adic-itens NO-LOCK
                WHERE decla-import-adic-itens.num-di-ems = i-num-di-ems
                  AND decla-import-adic-itens.num-adic   = i-num-adic
                  AND decla-import-adic-itens.num-seq    = i-num-seq
                  AND decla-import-adic-itens.cdd-siscomex-dts = de-cdd-siscomex-dts:

                FOR EACH despes-adic-itens
                   WHERE despes-adic-itens.num-di-ems = decla-import-adic-itens.num-di-ems
                     AND despes-adic-itens.num-adic   = decla-import-adic-itens.num-adic
                     AND despes-adic-itens.num-seq    = decla-import-adic-itens.num-seq
                     AND despes-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts NO-LOCK:

                     FOR FIRST desp-imp-trib
                         WHERE desp-imp-trib.cod-desp = despes-adic-itens.cdn-despes NO-LOCK:

                        IF desp-imp-trib.log-incide-base-IS THEN DO:     /* incide base IS */

                            IF despes-adic-itens.cdn-moed <> 0 THEN DO:

                                FIND FIRST decla-import NO-LOCK WHERE
                                           decla-import.num-di-ems = decla-import-adic-itens.num-di-ems AND
                                           decla-import.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts NO-ERROR.

                                IF NOT VALID-HANDLE(h-bocx383) THEN RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.

                                RUN converteValorMoeda IN h-bocx383 (INPUT  decla-import-adic-itens.num-di-ems,
                                                                     INPUT  decla-import-adic-itens.cdd-siscomex-dts,
                                                                     INPUT  despes-adic-itens.cdn-moeda,    /* moeda de origem */
                                                                     INPUT  0,                              /* moeda de destino */
                                                                     INPUT  despes-adic-itens.val-despes,   /* valor da despesa */
                                                                     INPUT  decla-import.dat-di,            /* data da di */
                                                                     OUTPUT d-val-desp-convert).
                            END.
                            ELSE
                                ASSIGN d-val-desp-convert = despes-adic-itens.val-despes.

                            ASSIGN pde-VA-IS = pde-VA-IS + d-val-desp-convert.
                        END.
                    END.
                END.
            END.
        END.
    END.

    IF VALID-HANDLE(h-bocx383) THEN DO:
        DELETE PROCEDURE h-bocx383.
        ASSIGN h-bocx383 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-sugere-cClassTrib:
/*------------------------------------------------------------------------------
  Purpose: Faz a busca da sugest∆o do cClassTrib e CST.
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pc-cod-estabel   LIKE estabelec.cod-estabel              NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-fiscal    LIKE natur-oper.nat-operacao            NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo     LIKE item.it-codigo                     NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-emitente  LIKE emitente.cod-emitente              NO-UNDO.
    DEFINE OUTPUT PARAMETER pcClassTrib      LIKE relac-class-trib.cod-cclass-trib   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcCST            LIKE relac-class-trib.cod-cst           NO-UNDO.
    DEFINE OUTPUT PARAMETER pcClassTrib-reg  LIKE relac-class-trib.cod-cclass-trib   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcCST-reg        LIKE relac-class-trib.cod-cst           NO-UNDO.

    IF NOT VALID-HANDLE(h-reapi433) THEN
        RUN rep/reapi433.p PERSISTENT SET h-reapi433.

    FOR FIRST ITEM
        WHERE ITEM.it-codigo = pc-it-codigo NO-LOCK:
    END.

    FOR FIRST emitente
        WHERE emitente.cod-emitente = pi-cod-emitente NO-LOCK:
    END.

    FOR FIRST natur-oper
        WHERE natur-oper.nat-operacao = pc-nat-fiscal NO-LOCK:
    END.

    RUN emptyTtRelacClassTrib  IN h-reapi433.
    RUN setTipoDocto           IN h-reapi433 (INPUT 1). /*Entrada*/
    RUN setDtIniValidade       IN h-reapi433 (INPUT TODAY).
    RUN setCodEstabel          IN h-reapi433 (INPUT pc-cod-estabel).
    RUN setNatOperacao         IN h-reapi433 (INPUT pc-nat-fiscal).
    RUN setItCodigo            IN h-reapi433 (INPUT ITEM.it-codigo).
    RUN setClassifFiscal       IN h-reapi433 (INPUT ITEM.class-fiscal).
    RUN setCodNbs              IN h-reapi433 (INPUT v-cod-nbs).
    RUN setCodGrupEmit         IN h-reapi433 (INPUT IF AVAIL emitente THEN emitente.cod-gr-forn ELSE 0).
    RUN setCodEmitente         IN h-reapi433 (INPUT emitente.cod-emitente).
    RUN setCFOP                IN h-reapi433 (INPUT IF AVAIL natur-oper THEN natur-oper.cod-cfop ELSE "").
    RUN setIndTributo          IN h-reapi433 (INPUT 1). /*1-IBS/CBS*/
    RUN buscarRelacClassTrib   IN h-reapi433.

    RUN getCSTcClassTribAndReg IN h-reapi433 (OUTPUT pcClassTrib,
                                              OUTPUT pcCST,
                                              OUTPUT pcClassTrib-reg,
                                              OUTPUT pcCST-reg).

    IF VALID-HANDLE(h-reapi433) THEN DO:
        DELETE PROCEDURE h-reapi433.
        ASSIGN h-reapi433 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-sugere-aliquotas:
/*------------------------------------------------------------------------------
  Purpose: Faz a busca da sugest∆o das aliquotas do CBS, IBS UF, IBS Mun e IS.
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-tipo-tribut      AS   INTEGER                   NO-UNDO. /*1-CBS 2-IBS UF 3-IBS Mun 4-IS */
    DEFINE INPUT  PARAMETER pc-cod-estabel      LIKE estabelec.cod-estabel     NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-fiscal       LIKE natur-oper.nat-operacao   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo        LIKE item.it-codigo            NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-emitente     LIKE emitente.cod-emitente     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-tributo-import.

    EMPTY TEMP-TABLE tt-tributo-import.

    IF NOT VALID-HANDLE(h-cdapi1005) THEN
        RUN cdp/cdapi1005.p PERSISTENT SET h-cdapi1005.

    FOR FIRST ITEM
        WHERE ITEM.it-codigo = pc-it-codigo NO-LOCK:
    END.

    FOR FIRST emitente
        WHERE emitente.cod-emitente = pi-cod-emitente NO-LOCK:
    END.

    FOR FIRST natur-oper
        WHERE natur-oper.nat-operacao = pc-nat-fiscal NO-LOCK:
    END.

    FOR FIRST estabelec
        WHERE estabelec.cod-estabel = pc-cod-estabel NO-LOCK:
    END.

    RUN emptyTtRelactoTributo IN h-cdapi1005.
    RUN setDados              IN h-cdapi1005 (INPUT 1, /*Entrada*/
                                              INPUT TODAY,
                                              INPUT pc-cod-estabel,
                                              INPUT pc-nat-fiscal,
                                              INPUT ITEM.it-codigo,
                                              INPUT item.class-fiscal,
                                              INPUT IF AVAIL emitente THEN emitente.cod-gr-forn ELSE 0,
                                              INPUT pi-cod-emitente,
                                              INPUT IF AVAIL natur-oper THEN natur-oper.cod-cfop ELSE "",
                                              INPUT ITEM.cod-servico,
                                              INPUT "",                 /*cidade*/
                                              INPUT estabelec.estado).  /*UF*/
    RUN setNbs IN h-cdapi1005 (INPUT v-cod-nbs).
    RUN gerattcombinacao IN h-cdapi1005.

    IF pi-tipo-tribut = 1 THEN DO: /*CBS*/

        /* CBS */
        ASSIGN dAliq           = 0
               dPercDifer      = 0
               dPercRed        = 0
               dPercCredPresum = 0
               dAliqDeson      = 0
               dPercRedAliqGov = 0.

        RUN emptyTtRelactoTributo IN h-cdapi1005.
        RUN setIndTributo         IN h-cdapi1005 (INPUT 1). /*CBS*/
        RUN buscarRelactotributo  IN h-cdapi1005.
        RUN getTributo            IN h-cdapi1005 (OUTPUT dAliq,
                                                  OUTPUT dPercDifer,
                                                  OUTPUT dPercRed,
                                                  OUTPUT dPercCredPresum,
                                                  OUTPUT dAliqDeson,
                                                  OUTPUT dPercRedAliqGov).

        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "CBS":U
               tt-tributo-import.cod-campo      = "dAliq":U
               tt-tributo-import.cod-conteudo   = string(dAliq).
        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "CBS":U
               tt-tributo-import.cod-campo      = "dPercDifer":U
               tt-tributo-import.cod-conteudo   = string(dPercDifer).
        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "CBS":U
               tt-tributo-import.cod-campo      = "dPercRed":U
               tt-tributo-import.cod-conteudo   = string(dPercRed).
        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "CBS":U
               tt-tributo-import.cod-campo      = "dPercCredPresum":U
               tt-tributo-import.cod-conteudo   = string(dPercCredPresum).
        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "CBS":U
               tt-tributo-import.cod-campo      = "dAliqDeson":U
               tt-tributo-import.cod-conteudo   = string(dAliqDeson).

    END.

    IF pi-tipo-tribut = 2 THEN DO: /* IBS UF */

        /* IBS UF */
        ASSIGN dAliq           = 0
               dPercDifer      = 0
               dPercRed        = 0
               dPercCredPresum = 0
               dAliqDeson      = 0
               dPercRedAliqGov = 0.

        RUN emptyTtRelactoTributo IN h-cdapi1005.
        RUN setIndTributo         IN h-cdapi1005 (INPUT 2). /* IBS UF */
        RUN buscarRelactotributo  IN h-cdapi1005.
        RUN getTributo            IN h-cdapi1005 (OUTPUT dAliq,
                                                  OUTPUT dPercDifer,
                                                  OUTPUT dPercRed,
                                                  OUTPUT dPercCredPresum,
                                                  OUTPUT dAliqDeson,
                                                  OUTPUT dPercRedAliqGov).
        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "IBS UF":U
               tt-tributo-import.cod-campo      = "dAliq":U
               tt-tributo-import.cod-conteudo   = string(dAliq).
        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "IBS UF":U
               tt-tributo-import.cod-campo      = "dPercDifer":U
               tt-tributo-import.cod-conteudo   = string(dPercDifer).
        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "IBS UF":U
               tt-tributo-import.cod-campo      = "dPercRed":U
               tt-tributo-import.cod-conteudo   = string(dPercRed).
        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "IBS UF":U
               tt-tributo-import.cod-campo      = "dPercCredPresum":U
               tt-tributo-import.cod-conteudo   = string(dPercCredPresum).
        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "IBS UF":U
               tt-tributo-import.cod-campo      = "dAliqDeson":U
               tt-tributo-import.cod-conteudo   = string(dAliqDeson).
    END.

    IF pi-tipo-tribut = 3 THEN DO: /* IBS Mun */

        /* IBS Mun */
        ASSIGN dAliq           = 0
               dPercDifer      = 0
               dPercRed        = 0
               dPercCredPresum = 0
               dAliqDeson      = 0
               dPercRedAliqGov = 0.

        RUN emptyTtRelactoTributo IN h-cdapi1005.
        RUN setIndTributo         IN h-cdapi1005 (INPUT 3). /* IBS Mun */
        RUN buscarRelactotributo  IN h-cdapi1005.
        RUN getTributo            IN h-cdapi1005 (OUTPUT dAliq,
                                                  OUTPUT dPercDifer,
                                                  OUTPUT dPercRed,
                                                  OUTPUT dPercCredPresum,
                                                  OUTPUT dAliqDeson,
                                                  OUTPUT dPercRedAliqGov).
        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "IBS MUN":U
               tt-tributo-import.cod-campo      = "dAliq":U
               tt-tributo-import.cod-conteudo   = string(dAliq).
        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "IBS MUN":U
               tt-tributo-import.cod-campo      = "dPercDifer":U
               tt-tributo-import.cod-conteudo   = string(dPercDifer).
        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "IBS MUN":U
               tt-tributo-import.cod-campo      = "dPercRed":U
               tt-tributo-import.cod-conteudo   = string(dPercRed).
        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "IBS MUN":U
               tt-tributo-import.cod-campo      = "dPercCredPresum":U
               tt-tributo-import.cod-conteudo   = string(dPercCredPresum).
        CREATE tt-tributo-import.
        ASSIGN tt-tributo-import.nom-trib       = "IBS MUN":U
               tt-tributo-import.cod-campo      = "dAliqDeson":U
               tt-tributo-import.cod-conteudo   = string(dAliqDeson).
    END.
    
    IF pi-tipo-tribut = 4 THEN DO: /* IS */

        RUN emptyTtRelactoTributo IN h-cdapi1005.
        RUN setIndTributo         IN h-cdapi1005 (INPUT 4). /* IS */
        RUN buscarRelactotributo  IN h-cdapi1005.
        
        EMPTY TEMP-TABLE tt-relacto-tributo.  
        
        /*retorna a temp-table com o dados que foram filtrados*/
        RUN getTtRelactoTributo   IN h-cdapi1005 (OUTPUT TABLE tt-relacto-tributo).  
         
        FOR FIRST tt-relacto-tributo:
            CREATE tt-tributo-import.
            ASSIGN tt-tributo-import.nom-trib       = "IS":U
                   tt-tributo-import.cod-campo      = "dAliq":U
                   tt-tributo-import.cod-conteudo   = string(tt-relacto-tributo.aliquota).
            CREATE tt-tributo-import.
            ASSIGN tt-tributo-import.nom-trib       = "IS":U
                   tt-tributo-import.cod-campo      = "dAliqEspecUN":U
                   tt-tributo-import.cod-conteudo   = string(tt-relacto-tributo.aliq-esp-por-unid-aprop-is).
            CREATE tt-tributo-import.
            ASSIGN tt-tributo-import.nom-trib       = "IS":U
                   tt-tributo-import.cod-campo      = "cUnTrib":U
                   tt-tributo-import.cod-conteudo   = SUBSTRING(item.char-1,290,2).
            IF de-qtde-calc-IS <> 0 THEN DO:
                RUN converteQtdeTribIS (INPUT  ITEM.it-codigo,
                                        INPUT  de-qtde-calc-IS,
                                        OUTPUT de-qtde-trib-IS).
                CREATE tt-tributo-import.
                ASSIGN tt-tributo-import.nom-trib       = "IS":U
                       tt-tributo-import.cod-campo      = "dQtdeTrib":U
                       tt-tributo-import.cod-conteudo   = STRING(de-qtde-trib-IS).
                ASSIGN de-qtde-calc-IS = 0.
            END.
        END.
    END.
    
    IF VALID-HANDLE(h-cdapi1005) THEN DO:
        DELETE PROCEDURE h-cdapi1005.
        ASSIGN h-cdapi1005 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE createTempTableImpostosCBSIBS:

    DEFINE INPUT PARAMETER pi-sequencia     AS INTEGER   NO-UNDO.

    FIND FIRST tb-wt-it-impostoCBSIBS EXCLUSIVE-LOCK
        WHERE tb-wt-it-impostoCBSIBS.seq-wt-docto    = 1
          AND tb-wt-it-impostoCBSIBS.seq-wt-it-docto = pi-sequencia NO-ERROR.
    IF NOT AVAIL tb-wt-it-impostoCBSIBS THEN DO:
        CREATE tb-wt-it-impostoCBSIBS.
        ASSIGN tb-wt-it-impostoCBSIBS.seq-wt-docto    = 1
               tb-wt-it-impostoCBSIBS.seq-wt-it-docto = pi-sequencia.
    END.

    RUN getValAtribImportTribut (INPUT "CBS":U, INPUT "ALIQUOTA",   OUTPUT tb-wt-it-impostoCBSIBS.aliquota-cbs).
    RUN getValAtribImportTribut (INPUT "CBS":U, INPUT "ALIQ-RED",   OUTPUT tb-wt-it-impostoCBSIBS.perc-red-cbs).
    RUN getValAtribImportTribut (INPUT "CBS":U, INPUT "PERC-DIFER", OUTPUT tb-wt-it-impostoCBSIBS.perc-difer-cbs).

    RUN getValAtribImportTribut (INPUT "IBSUF":U, INPUT "ALIQUOTA",   OUTPUT tb-wt-it-impostoCBSIBS.aliquota-ibsuf).
    RUN getValAtribImportTribut (INPUT "IBSUF":U, INPUT "ALIQ-RED",   OUTPUT tb-wt-it-impostoCBSIBS.perc-red-ibsuf).
    RUN getValAtribImportTribut (INPUT "IBSUF":U, INPUT "PERC-DIFER", OUTPUT tb-wt-it-impostoCBSIBS.perc-difer-ibsuf).

    RUN getValAtribImportTribut (INPUT "IBSMUN":U, INPUT "ALIQUOTA",   OUTPUT tb-wt-it-impostoCBSIBS.aliquota-ibsmun).
    RUN getValAtribImportTribut (INPUT "IBSMUN":U, INPUT "ALIQ-RED",   OUTPUT tb-wt-it-impostoCBSIBS.perc-red-ibsmun).
    RUN getValAtribImportTribut (INPUT "IBSMUN":U, INPUT "PERC-DIFER", OUTPUT tb-wt-it-impostoCBSIBS.perc-difer-ibsmun).

    RUN getValAtribImportTribut (INPUT "IS":U, INPUT "ALIQUOTA",      OUTPUT tb-wt-it-impostoCBSIBS.aliquota-is).
    RUN getValAtribImportTribut (INPUT "IS":U, INPUT "ALIQ-ESPEC-UN", OUTPUT tb-wt-it-impostoCBSIBS.aliq-espec-is).
    RUN getValAtribImportTribut (INPUT "IS":U, INPUT "QTDE-TRIBUT",   OUTPUT tb-wt-it-impostoCBSIBS.qtde-tribut-is).
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-busca-tributacaoRT:
/*------------------------------------------------------------------------------
    ** Procedure respons†vel pela chamada do Configurador de tributos
    ** realizada pelas BO's do recebimento e atualizaá∆o dos dados
    ** de Tributaá∆o do CBS, IBSUF e IBSMUN
-------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-recarrega-IBSUF   AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-recarrega-IBSMun  AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-recarrega-CBS     AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-recarrega-IS      AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-grava-dados       AS LOGICAL NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-ordens-desemb.

    EMPTY TEMP-TABLE tb-wt-docto.
    EMPTY TEMP-TABLE tb-wt-it-docto.
    EMPTY TEMP-TABLE tb-wt-it-imposto.
    EMPTY TEMP-TABLE tb-wt-it-impostoCBSIBS.
    EMPTY TEMP-TABLE tb-ct-trib-wt-item-docto.

    IF NOT VALID-HANDLE(h-bodi317im2bra) THEN
        RUN dibo/bodi317im2bra PERSISTEN SET h-bodi317im2bra.

    /*Configurador de Tributos*/
    IF NOT VALID-HANDLE(h-bodi613calc2) THEN
        RUN dibo/bodi613calc2.p PERSISTENT SET h-bodi613calc2.

    ASSIGN i          = 0
           i-seq-item = 0.


    FOR EACH tt-ordens-desemb:
        ASSIGN i          = i + 1
               i-seq-item = i-seq-item + 1.

        FOR FIRST ct-trib-item-doc-est NO-LOCK
            WHERE ct-trib-item-doc-est.cod-estab   = tt-ordens-desemb.cod-estabel
              AND ct-trib-item-doc-est.cod-embarq  = tt-ordens-desemb.embarque
              AND ct-trib-item-doc-est.num-ordem   = tt-ordens-desemb.numero-ordem
              AND ct-trib-item-doc-est.num-parcela = tt-ordens-desemb.parcela:
            ASSIGN i-seq-item = ct-trib-item-doc-est.num-seq.
        END.
        IF NOT AVAIL ct-trib-item-doc-est THEN
            FOR LAST ct-trib-item-doc-est NO-LOCK
                WHERE ct-trib-item-doc-est.cod-estab   = tt-ordens-desemb.cod-estabel
                  AND ct-trib-item-doc-est.cod-embarq  = tt-ordens-desemb.embarque:
                ASSIGN i-seq-item = ct-trib-item-doc-est.num-seq + 1.
            END.

        /*criaá∆o registro wt-docto para carregar informaá‰es da configuraá∆o de tributo*/
        RUN createTbWtDocto               (INPUT i-seq-item).
        RUN createTempTableImpostosCBSIBS (INPUT i-seq-item).
    END.

    /* enviar temp-tables */
    run enviaTbWtDocto           in h-bodi613calc2 (input table tb-wt-docto).
    run enviaTbWtItDocto         in h-bodi613calc2 (input table tb-wt-it-docto).
    run enviaTbWtItImposto       in h-bodi613calc2 (input table tb-wt-it-imposto).
    run enviaTbWtItImpostoCBSIBS in h-bodi613calc2 (input table tb-wt-it-impostoCBSIBS).

    run enviaTbWtDocto           in h-bodi317im2bra (input table tb-wt-docto).
    run enviaTbWtItDocto         in h-bodi317im2bra (input table tb-wt-it-docto).
    run enviaTbWtItImposto       in h-bodi317im2bra (input table tb-wt-it-imposto).

    /* posicionar registros */
    RUN localizaWtDocto in h-bodi317im2bra ( input 1,
                                             output l-procedimento-ok ).

    RUN localizaWtDocto in h-bodi613calc2  ( input 1,
                                             output l-procedimento-ok ).
    if  not l-procedimento-ok then do:
        delete procedure h-bodi613calc2.
        RETURN "NOK":U.
    end.

    RUN pi-recebe-handle in h-bodi317im2bra (input "h-bodi613calc2",
                                             input h-bodi613calc2).

    RUN trataConfigTributos in h-bodi317im2bra.

    /* retornar temp-table */
    run retornaTbCtTribWtItemDocto in h-bodi613calc2 ( output table tb-ct-trib-wt-item-docto ).
    run retornaTbWtItImposto       in h-bodi613calc2 ( output table tb-wt-it-imposto ).

    IF NOT AVAIL tb-wt-docto THEN
        FOR FIRST tb-wt-docto NO-LOCK
            WHERE tb-wt-docto.seq-wt-docto = 1:
        END.

    IF  pl-grava-dados THEN DO:
        FOR EACH tb-wt-it-docto NO-LOCK:
            FOR EACH ct-trib-item-doc-est EXCLUSIVE-LOCK
               WHERE ct-trib-item-doc-est.cdn-emitente  = tb-wt-docto.cod-emitente
                 AND ct-trib-item-doc-est.cod-ser-docto = ""
                 AND ct-trib-item-doc-est.cod-docto     = tb-wt-docto.nr-nota
                 AND ct-trib-item-doc-est.cod-estab     = tb-wt-docto.cod-estabel
                 AND ct-trib-item-doc-est.num-ordem     = tb-wt-it-docto.numero-ordem
                 AND ct-trib-item-doc-est.num-parcela   = tb-wt-it-docto.parcela:
                DELETE ct-trib-item-doc-est.
            END.
        END.

        RUN pi-gravar-dados-cfg-trib (input "", input tb-wt-docto.nr-nota).
    END.

    RUN piExecutaAtualizacaoImport (INPUT pl-recarrega-IBSUF,
                                    INPUT pl-recarrega-IBSMun,
                                    INPUT pl-recarrega-CBS,
                                    INPUT pl-recarrega-IS,
                                    INPUT "ordens-embarque-trib":U).

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE piExecutaAtualizacaoImport:
    /*
    ** Procedure respons†vel por realizar a atualizaá∆o do c¢digo da tributaá∆o
    ** conforme retornada a informaá∆o do cen†rio fiscal
    */
    DEFINE INPUT PARAMETER pl-recarrega-IBSUF  AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-recarrega-IBSMun AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-recarrega-CBS    AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pl-recarrega-IS     AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pc-tabela AS CHARACTER NO-UNDO.

    FOR EACH tb-wt-it-docto NO-LOCK
        WHERE tb-wt-it-docto.seq-wt-docto = 1,
         EACH tb-wt-it-imposto NO-LOCK
        WHERE tb-wt-it-imposto.seq-wt-docto    = tb-wt-it-docto.seq-wt-docto
          AND tb-wt-it-imposto.seq-wt-it-docto = tb-wt-it-docto.seq-wt-it-docto,

         EACH tb-ct-trib-wt-item-docto NO-LOCK
        WHERE tb-ct-trib-wt-item-docto.num-seq-wt-docto      = tb-wt-it-imposto.seq-wt-docto
          AND tb-ct-trib-wt-item-docto.num-seq-wt-item-docto = tb-wt-it-imposto.seq-wt-it-docto:

        CASE tb-ct-trib-wt-item-docto.cod-tip-trib:
            WHEN "CBS":U THEN DO:
                RUN atualizaTributImport (INPUT pl-recarrega-IBSUF,
                                          INPUT pl-recarrega-IBSMun,
                                          INPUT pl-recarrega-CBS,
                                          INPUT pl-recarrega-IS,
                                          INPUT pc-tabela,
                                          INPUT "CBS":U,
                                          INPUT "COD-TRIB",
                                          INPUT STRING(tb-ct-trib-wt-item-docto.idi-cod-tributac)).
            END.
            WHEN "IBSUF":U THEN DO:
                RUN atualizaTributImport (INPUT pl-recarrega-IBSUF,
                                          INPUT pl-recarrega-IBSMun,
                                          INPUT pl-recarrega-CBS,
                                          INPUT pl-recarrega-IS,
                                          INPUT pc-tabela,
                                          INPUT "IBSUF":U,
                                          INPUT "COD-TRIB",
                                          INPUT STRING(tb-ct-trib-wt-item-docto.idi-cod-tributac)).
            END.
            WHEN "IBSMUN":U THEN DO:
                RUN atualizaTributImport (INPUT pl-recarrega-IBSUF,
                                          INPUT pl-recarrega-IBSMun,
                                          INPUT pl-recarrega-CBS,
                                          INPUT pl-recarrega-IS,
                                          INPUT pc-tabela,
                                          INPUT "IBSMUN":U,
                                          INPUT "COD-TRIB",
                                          INPUT STRING(tb-ct-trib-wt-item-docto.idi-cod-tributac)).
            END.
            WHEN "IS":U THEN DO:
                RUN atualizaTributImport (INPUT pl-recarrega-IBSUF,
                                          INPUT pl-recarrega-IBSMun,
                                          INPUT pl-recarrega-CBS,
                                          INPUT pl-recarrega-IS,
                                          INPUT pc-tabela,
                                          INPUT "IS":U,
                                          INPUT "COD-TRIB",
                                          INPUT STRING(tb-ct-trib-wt-item-docto.idi-cod-tributac)).
            END.
        END.
    END.

    IF VALID-HANDLE(h-bodi317im2bra) THEN DO:
        DELETE PROCEDURE h-bodi317im2bra.
        ASSIGN h-bodi317im2bra = ?.
    END.

    IF VALID-HANDLE(h-bodi613calc2) THEN DO:
        DELETE PROCEDURE h-bodi613calc2.
        ASSIGN h-bodi613calc2 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE createTbWtDocto :
/*------------------------------------------------------------------------------
Criacao da temp-table tb-wt-docto para calculo dos impostos.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-seq-item AS INTEGER NO-UNDO.

    FOR FIRST ordem-compra
        WHERE ordem-compra.numero-ordem = tt-ordens-desemb.numero-ordem NO-LOCK:
        FOR FIRST cotacao-item
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
              AND cotacao-item.cot-aprovada NO-LOCK:
        END.
        FOR FIRST ITEM
            WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK:
        END.
        FOR FIRST emitente
            WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK:
        END.
    END.

    FOR FIRST natur-oper
        WHERE natur-oper.nat-operacao = tt-ordens-desemb.c-nat-fiscal NO-LOCK:
    END.

    FOR FIRST estabelec
        WHERE estabelec.cod-estabel = tt-ordens-desemb.cod-estabel NO-LOCK:
    END.

    IF NOT CAN-FIND(FIRST tb-wt-docto
                    WHERE tb-wt-docto.seq-wt-docto = 1) THEN DO:

        CREATE tb-wt-docto.
        ASSIGN tb-wt-docto.seq-wt-docto = 1
               tb-wt-docto.cod-emitente = ordem-compra.cod-emitente
               tb-wt-docto.nr-nota      = tt-ordens-desemb.embarque
               tb-wt-docto.serie        = "":U
               tb-wt-docto.nat-operacao = tt-ordens-desemb.c-nat-fiscal
               tb-wt-docto.cod-des-merc = IF natur-oper.consum-final THEN 2 ELSE 1
               tb-wt-docto.cod-estabel  = tt-ordens-desemb.cod-estabel
               tb-wt-docto.dt-emis-nota = TODAY
               tb-wt-docto.esp-docto    = 21
               tb-wt-docto.ind-tip-nota = 8
               tb-wt-docto.mo-codigo    = cotacao-item.mo-codigo
               tb-wt-docto.nome-abrev   = emitente.nome-abrev
               tb-wt-docto.vl-embalagem = 0
               tb-wt-docto.vl-frete     = 0
               tb-wt-docto.vl-mercad    = 0
               tb-wt-docto.nr-prog      = 176
               tb-wt-docto.vl-seguro    = 0
               tb-wt-docto.cidade       = estabelec.cidade
               tb-wt-docto.estado       = estabelec.estado
               tb-wt-docto.pais         = estabelec.pais.
    END.

    IF NOT CAN-FIND(FIRST tb-wt-it-docto
                    WHERE tb-wt-it-docto.seq-wt-docto    = 1
                      AND tb-wt-it-docto.seq-wt-it-docto = pi-seq-item) THEN DO:

        CREATE tb-wt-it-docto.
        ASSIGN tb-wt-it-docto.seq-wt-docto        = 1
               tb-wt-it-docto.seq-wt-it-docto     = pi-seq-item
               tb-wt-it-docto.calcula             = YES
               tb-wt-it-docto.it-codigo           = item.it-codigo when avail item
               tb-wt-it-docto.nat-operacao        = natur-oper.nat-operacao
               tb-wt-it-docto.nr-sequencia        = pi-seq-item
               tb-wt-it-docto.numero-ordem        = tt-ordens-desemb.numero-ordem
               tb-wt-it-docto.parcela             = tt-ordens-desemb.parcela
               OVERLAY(tb-wt-it-docto.char-1,1,6) = "IM7777":U.
    END.

    IF NOT CAN-FIND(FIRST tb-wt-it-imposto
                    WHERE tb-wt-it-imposto.seq-wt-docto = 1
                    AND   tb-wt-it-imposto.seq-wt-it-docto = pi-seq-item) THEN DO:
        CREATE tb-wt-it-imposto.
        ASSIGN tb-wt-it-imposto.seq-wt-docto    = 1
               tb-wt-it-imposto.seq-wt-it-docto = pi-seq-item.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE atualizaTributImport :
/*------------------------------------------------------------------------------
  Purpose:     Realiza a criaá∆o/atualizaá∆o dos dados retornados pelo
               configurador nas temp-tables de tributos de importaá∆o
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-recarrega-IBSUF   AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER pl-recarrega-IBSMun  AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER pl-recarrega-CBS     AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER pl-recarrega-IS      AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER pc-tabela-trib       AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pNomTribut           AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pCodCampo            AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pCodConteudo         AS CHARACTER    NO-UNDO.

    CASE pc-tabela-trib:
        WHEN "ordens-embarque-trib":U THEN DO:

            FOR FIRST tt-ordens-desemb
                WHERE tt-ordens-desemb.cod-estabel  = tb-wt-docto.cod-estabel
                  AND tt-ordens-desemb.embarque     = tb-wt-docto.nr-nota
                  AND tt-ordens-desemb.numero-ordem = tb-wt-it-docto.numero-ordem
                  AND tt-ordens-desemb.parcela      = tb-wt-it-docto.parcela:

                  CASE pNomTribut:
                      WHEN "CBS":U THEN DO:
                           IF  pCodCampo = "COD-TRIB":U
                           AND (tt-ordens-desemb.c-trib-CBS = "" OR pl-recarrega-CBS) THEN
                                ASSIGN tt-ordens-desemb.c-trib-CBS = pCodConteudo.
                      END.
                      WHEN "IBSUF":U THEN DO:
                           IF  pCodCampo = "COD-TRIB":U
                           AND (tt-ordens-desemb.c-trib-IBSUF = "" OR pl-recarrega-IBSUF) THEN
                                ASSIGN tt-ordens-desemb.c-trib-IBSUF = pCodConteudo.
                      END.
                      WHEN "IBSMUN":U THEN DO:
                           IF  pCodCampo = "COD-TRIB":U
                           AND (tt-ordens-desemb.c-trib-IBSMun = "" OR pl-recarrega-IBSMun) THEN
                                ASSIGN tt-ordens-desemb.c-trib-IBSMun = pCodConteudo.
                      END.
                      WHEN "IS":U THEN DO:
                           IF  pCodCampo = "COD-TRIB":U
                           AND (tt-ordens-desemb.c-trib-IS = "" OR pl-recarrega-IS) THEN
                                ASSIGN tt-ordens-desemb.c-trib-IS = pCodConteudo.
                      END.
                  END.
            END.
        END.
    END CASE.

RETURN "OK":U.
END PROCEDURE.

procedure getValAtribImportTribut:
    DEFINE INPUT  PARAM pImposto    AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pAtributo   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM pValorAtrib AS DECIMAL   NO-UNDO.

    FIND FIRST tt-ordens-embarque-trib NO-LOCK
         WHERE tt-ordens-embarque-trib.cod-estabel  = tt-ordens-desemb.cod-estabel
           AND tt-ordens-embarque-trib.embarque     = tt-ordens-desemb.embarque
           AND tt-ordens-embarque-trib.numero-ordem = tt-ordens-desemb.numero-ordem
           AND tt-ordens-embarque-trib.parcela      = tt-ordens-desemb.parcela
           AND tt-ordens-embarque-trib.nom-trib     = pImposto
           AND tt-ordens-embarque-trib.cod-campo    = pAtributo NO-ERROR.
    IF AVAIL tt-ordens-embarque-trib THEN
       ASSIGN pValorAtrib = dec(tt-ordens-embarque-trib.cod-conteudo).
    ELSE DO:
        FIND FIRST ordens-embarque-trib NO-LOCK
             WHERE ordens-embarque-trib.cod-estabel  = tt-ordens-desemb.cod-estabel
               AND ordens-embarque-trib.embarque     = tt-ordens-desemb.embarque
               AND ordens-embarque-trib.numero-ordem = tt-ordens-desemb.numero-ordem
               AND ordens-embarque-trib.parcela      = tt-ordens-desemb.parcela
               AND ordens-embarque-trib.nom-trib     = pImposto
               AND ordens-embarque-trib.cod-campo    = pAtributo NO-ERROR.
        IF AVAIL ordens-embarque-trib THEN
           ASSIGN pValorAtrib = dec(ordens-embarque-trib.cod-conteudo).
    END.
END PROCEDURE.

procedure piEnviaNumDIEMS:
    define input parameter pi-num-di-ems like decla-import.num-di-ems no-undo.
    define input parameter pi-num-adic   like decla-import.num-adic   no-undo.
    define input parameter pi-num-seq    like decla-import.num-seq    no-undo.
    define input parameter p-cdd-siscomex-dts like decla-import.cdd-siscomex-dts no-undo.

    assign i-num-di-ems = pi-num-di-ems
           i-num-adic   = pi-num-adic
           i-num-seq    = pi-num-seq
           de-cdd-siscomex-dts = p-cdd-siscomex-dts.

end procedure.

PROCEDURE piCalculaValorII:

    DEFINE INPUT  PARAMETER pi-cod-emitente LIKE docum-est.cod-emitente                  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-serie-docto  LIKE docum-est.serie-docto                   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nro-docto    LIKE docum-est.nro-docto                     NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-operacao LIKE docum-est.nat-operacao                  NO-UNDO.
    DEFINE INPUT  PARAMETER pi-sequencia    LIKE item-doc-est.sequencia                  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo    LIKE item-doc-est.it-codigo                  NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-valor-ii    AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO.

    for FIRST docum-est
        WHERE docum-est.cod-emitente = pi-cod-emitente
          AND docum-est.serie-docto  = pc-serie-docto
          AND docum-est.nro-docto    = pc-nro-docto
          AND docum-est.nat-operacao = pc-nat-operacao NO-LOCK:
    end.

    if avail docum-est then do:
        FOR FIRST param-imp NO-LOCK
            WHERE param-imp.cod-estabel = docum-est.cod-estabel:
        END.

        {cdp/cd4300.i4 "yes" param-imp.char-1}
        {cxbo/bocx250.i51 "yes"}

        assign i-cod-desp-ii     = i-desp-ii-i50.

        FOR FIRST item-doc-est NO-LOCK
            WHERE item-doc-est.cod-emitente = docum-est.cod-emitente
              AND item-doc-est.serie-docto  = docum-est.serie-docto
              AND item-doc-est.nro-docto    = docum-est.nro-docto
              AND item-doc-est.nat-operacao = docum-est.nat-operacao
              AND item-doc-est.sequencia    = pi-sequencia
              AND item-doc-est.it-codigo    = pc-it-codigo:

             FOR EACH item-doc-est-cex
                WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
                  AND item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
                  AND item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
                  AND item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
                  AND item-doc-est-cex.sequencia    = item-doc-est.sequencia NO-LOCK:

                for FIRST desp-imp NO-LOCK
                    WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp:

                    if desp-imp.cod-desp = i-cod-desp-ii THEN
                        ASSIGN pde-valor-ii  = pde-valor-ii + item-doc-est-cex.val-desp.

                END.
             END.
        END.
    END.
     else do:
        if i-num-di-ems > 0 then do:
            for first decla-import-adic-itens no-lock
                where decla-import-adic-itens.num-di-ems = i-num-di-ems
                  and decla-import-adic-itens.num-adic   = i-num-adic
                  and decla-import-adic-itens.num-seq    = i-num-seq
                  AND decla-import-adic-itens.cdd-siscomex-dts = de-cdd-siscomex-dts:

                 ASSIGN pde-valor-ii = pde-valor-ii + (  decla-import-adic-itens.val-ii-db-cr
                                                       + decla-import-adic-itens.val-ii-nao-tribut
                                                       + decla-import-adic-itens.val-ii-outras).
            end.
        end.
    end.

END PROCEDURE.

PROCEDURE piCalculaValorIPI:

    DEFINE INPUT  PARAMETER pi-cod-emitente LIKE docum-est.cod-emitente                  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-serie-docto  LIKE docum-est.serie-docto                   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nro-docto    LIKE docum-est.nro-docto                     NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-operacao LIKE docum-est.nat-operacao                  NO-UNDO.
    DEFINE INPUT  PARAMETER pi-sequencia    LIKE item-doc-est.sequencia                  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo    LIKE item-doc-est.it-codigo                  NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-valor-ipi   AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO.

    FOR FIRST item-doc-est NO-LOCK
        WHERE item-doc-est.cod-emitente = pi-cod-emitente
          AND item-doc-est.serie-docto  = pc-serie-docto
          AND item-doc-est.nro-docto    = pc-nro-docto
          AND item-doc-est.nat-operacao = pc-nat-operacao
          AND item-doc-est.sequencia    = pi-sequencia
          AND item-doc-est.it-codigo    = pc-it-codigo:

        ASSIGN pde-valor-ipi = item-doc-est.valor-ipi[1].
    END.
    IF NOT AVAIL item-doc-est THEN DO:
        if i-num-di-ems > 0 then do:
            for first decla-import-adic-itens no-lock
                where decla-import-adic-itens.num-di-ems = i-num-di-ems
                  and decla-import-adic-itens.num-adic   = i-num-adic
                  and decla-import-adic-itens.num-seq    = i-num-seq
                  AND decla-import-adic-itens.cdd-siscomex-dts = de-cdd-siscomex-dts:

                 ASSIGN pde-valor-ipi = pde-valor-ipi + (  decla-import-adic-itens.val-ipi-nao-tributad
                                                         + decla-import-adic-itens.val-ipi-outras
                                                         + decla-import-adic-itens.val-ipi-db-cr).
            end.
        end.
    end.

END PROCEDURE.

PROCEDURE piEnviaCodNBS:
    DEFINE INPUT PARAMETER pCodNBS AS CHAR NO-UNDO.

    ASSIGN v-cod-nbs = pCodNBS.

    IF  v-cod-nbs = "" THEN //se o item n∆o possuir nbs considerar o genÇrico que Ç '*'
        ASSIGN v-cod-nbs = '*'.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE converteQtdeTribIS:
    DEFINE INPUT  PARAMETER pItCodigo   AS CHAR NO-UNDO.
    DEFINE INPUT  PARAMETER pQtSolic    AS DEC  NO-UNDO.
    DEFINE OUTPUT PARAMETER pQtdeTribIS AS DEC  NO-UNDO.
    
    DEF VAR de-indice-conv AS DEC NO-UNDO.

    ASSIGN pQtdeTribIS = pQtSolic.
    FIND FIRST ITEM WHERE ITEM.it-codigo = pItCodigo NO-LOCK NO-ERROR.
    IF AVAIL ITEM AND SUBSTRING(item.char-1,290,2) <> "" /* UN Tribut†vel */ THEN DO:
        FOR FIRST tab-conv-un NO-LOCK
            WHERE tab-conv-un.un           = item.un
              AND tab-conv-un.unid-med-for = SUBSTRING(item.char-1,290,2):          
            ASSIGN de-indice-conv = tab-conv-un.fator-conver / IF tab-conv-un.num-casa-dec = 0 THEN 1
                                                               ELSE EXP(10,tab-conv-un.num-casa-dec).                                                           
            ASSIGN pQtdeTribIS = pQtSolic * de-indice-conv.                  
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piEnviaQtdeIS:
    DEFINE INPUT PARAMETER pQtdeIS AS DEC NO-UNDO.

    ASSIGN de-qtde-calc-IS = pQtdeIS.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piBuscaValorPIS:
    DEFINE INPUT  PARAMETER pi-cod-emitente LIKE docum-est.cod-emitente  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-serie-docto  LIKE docum-est.serie-docto   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nro-docto    LIKE docum-est.nro-docto     NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-operacao LIKE docum-est.nat-operacao  NO-UNDO.
    DEFINE INPUT  PARAMETER pi-sequencia    LIKE item-doc-est.sequencia  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo    LIKE item-doc-est.it-codigo  NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-valor-pis   AS   DECIMAL                 NO-UNDO.

    FOR FIRST item-doc-est NO-LOCK
        WHERE item-doc-est.cod-emitente = pi-cod-emitente
          AND item-doc-est.serie-docto  = pc-serie-docto
          AND item-doc-est.nro-docto    = pc-nro-docto
          AND item-doc-est.nat-operacao = pc-nat-operacao
          AND item-doc-est.sequencia    = pi-sequencia
          AND item-doc-est.it-codigo    = pc-it-codigo:

        ASSIGN pde-valor-pis = item-doc-est.valor-pis.
    END.
    
    IF  NOT AVAIL item-doc-est
    AND i-num-di-ems > 0 THEN DO:
        FOR FIRST decla-import-adic-itens NO-LOCK
            WHERE decla-import-adic-itens.num-di-ems       = i-num-di-ems
              AND decla-import-adic-itens.num-adic         = i-num-adic
              AND decla-import-adic-itens.num-seq          = i-num-seq
              AND decla-import-adic-itens.cdd-siscomex-dts = de-cdd-siscomex-dts:

             ASSIGN pde-valor-pis = (decla-import-adic-itens.val-pis-db-cr +
                                     decla-import-adic-itens.val-pis-outras).
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piBuscaValorCOFINS:
    DEFINE INPUT  PARAMETER pi-cod-emitente  LIKE docum-est.cod-emitente  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-serie-docto   LIKE docum-est.serie-docto   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nro-docto     LIKE docum-est.nro-docto     NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-operacao  LIKE docum-est.nat-operacao  NO-UNDO.
    DEFINE INPUT  PARAMETER pi-sequencia     LIKE item-doc-est.sequencia  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo     LIKE item-doc-est.it-codigo  NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-valor-cofins AS   DECIMAL                 NO-UNDO.

    FOR FIRST item-doc-est NO-LOCK
        WHERE item-doc-est.cod-emitente = pi-cod-emitente
          AND item-doc-est.serie-docto  = pc-serie-docto
          AND item-doc-est.nro-docto    = pc-nro-docto
          AND item-doc-est.nat-operacao = pc-nat-operacao
          AND item-doc-est.sequencia    = pi-sequencia
          AND item-doc-est.it-codigo    = pc-it-codigo:

        ASSIGN pde-valor-cofins = item-doc-est.val-cofins.
    END.
    
    IF  NOT AVAIL item-doc-est
    AND i-num-di-ems > 0 THEN DO:
        FOR FIRST decla-import-adic-itens NO-LOCK
            WHERE decla-import-adic-itens.num-di-ems       = i-num-di-ems
              AND decla-import-adic-itens.num-adic         = i-num-adic
              AND decla-import-adic-itens.num-seq          = i-num-seq
              AND decla-import-adic-itens.cdd-siscomex-dts = de-cdd-siscomex-dts:

             ASSIGN pde-valor-cofins = (decla-import-adic-itens.val-cofins-db-cr +
                                        decla-import-adic-itens.val-cofins-outras).
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piBuscaValorICMS:
    DEFINE INPUT  PARAMETER pi-cod-emitente LIKE docum-est.cod-emitente  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-serie-docto  LIKE docum-est.serie-docto   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nro-docto    LIKE docum-est.nro-docto     NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-operacao LIKE docum-est.nat-operacao  NO-UNDO.
    DEFINE INPUT  PARAMETER pi-sequencia    LIKE item-doc-est.sequencia  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo    LIKE item-doc-est.it-codigo  NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-valor-icms  AS   DECIMAL                 NO-UNDO.
    
    DEF VAR de-valor-fcp AS DEC NO-UNDO.

    FOR FIRST item-doc-est NO-LOCK
        WHERE item-doc-est.cod-emitente = pi-cod-emitente
          AND item-doc-est.serie-docto  = pc-serie-docto
          AND item-doc-est.nro-docto    = pc-nro-docto
          AND item-doc-est.nat-operacao = pc-nat-operacao
          AND item-doc-est.sequencia    = pi-sequencia
          AND item-doc-est.it-codigo    = pc-it-codigo:

        ASSIGN pde-valor-icms = item-doc-est.valor-icm[1].
    END.
    
    IF  NOT AVAIL item-doc-est
    AND i-num-di-ems > 0 THEN DO:
        FOR FIRST decla-import-adic-itens NO-LOCK
            WHERE decla-import-adic-itens.num-di-ems       = i-num-di-ems
              AND decla-import-adic-itens.num-adic         = i-num-adic
              AND decla-import-adic-itens.num-seq          = i-num-seq
              AND decla-import-adic-itens.cdd-siscomex-dts = de-cdd-siscomex-dts:

             ASSIGN pde-valor-icms = (decla-import-adic-itens.val-icms-db-cr +
                                      decla-import-adic-itens.val-icms-outras).
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.

/*IMAPI017.P*/

