/********************************************************************************
** Copyright TOTVS S.A. (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproduá∆o
** parcial ou total por qualquer meio, so poder† ser feita mediante
** autorizaá∆o expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0514RP 2.00.00.000 } /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0514RP MAQ}
&ENDIF

/******************************************************************************
**
**       Programa: AQ0514RP.P
**
**       Data....: 19/10/2017.
**
**       Objetivo: Emiss∆o relat¢rio em planilha para cargar rurais.
**                 M¢dulo Aquisiá∆o de Produtos Rurais.
** 
******************************************************************************/

{aqp/aq0514.i}      /*Definiá∆o da tt-param*/
{method/dbotterr.i} /* rowErrors*/
{utp/ut-glob.i}

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/*HANDLES*/
DEFINE VARIABLE h-boad098na AS HANDLE NO-UNDO. /* emitente          */
DEFINE VARIABLE h-boin00980 AS HANDLE NO-UNDO. /* propried-rural    */
DEFINE VARIABLE h-boin00966 AS HANDLE NO-UNDO. /* pto-coleta        */
DEFINE VARIABLE h-boin01004 AS HANDLE NO-UNDO. /* motivo-nao-coleta */
DEFINE VARIABLE h-acomp     AS HANDLE NO-UNDO.

DEFINE VARIABLE c-nome-emit      LIKE emitente.nome-emit          NO-UNDO.
DEFINE VARIABLE c-des-propried   LIKE propried-rural.des-propried NO-UNDO.
DEFINE VARIABLE c-des-pto-coleta LIKE pto-coleta.des-pto-coleta   NO-UNDO.
DEFINE VARIABLE des-motivo       LIKE motiv-nao-coleta.des-motivo NO-UNDO.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

{utp/ut-liter.i Buscando_dados_relat¢rio *}
RUN pi-inicializar IN h-acomp (INPUT TRIM(RETURN-VALUE)).
RUN pi-acompanhar  IN h-acomp (INPUT TRIM(RETURN-VALUE)).

FIND FIRST tt-param NO-ERROR.

RUN piStartHandles IN THIS-PROCEDURE.

RUN piGeraTTDados IN THIS-PROCEDURE.

IF  tt-param.destino = 4  THEN DO:
    /*envia tt para geraÁ„o do excel*/
    RUN aqp/aq0514a.p (INPUT TABLE tt-param,
                       INPUT TABLE tt-dados-cargas-rurais).
END.

RUN piFinishHandles IN THIS-PROCEDURE.

RUN pi-finalizar IN h-acomp.

/* ===================== PROCEDURES INTERNAS ========================*/
PROCEDURE piGeraTTDados:

    FOR EACH produt-carg
       WHERE produt-carg.dat-trans        >= tt-param.d-data-ini
         AND produt-carg.dat-trans        <= tt-param.d-data-fim
         AND produt-carg.cdn-produt-rural >= tt-param.cdn-produt-rural-ini
         AND produt-carg.cdn-produt-rural <= tt-param.cdn-produt-rural-fim
         AND produt-carg.cod-estabel      >= tt-param.cod-estabel-ini
         AND produt-carg.cod-estabel      <= tt-param.cod-estabel-fim NO-LOCK:

         CREATE tt-dados-cargas-rurais.
         ASSIGN tt-dados-cargas-rurais.num-carg             = produt-carg.num-carg
                tt-dados-cargas-rurais.cdn-produt-rural     = produt-carg.cdn-produt-rural
                tt-dados-cargas-rurais.cod-propried         = produt-carg.cod-propried
                tt-dados-cargas-rurais.cod-pto-coleta       = produt-carg.cod-pto-coleta
                tt-dados-cargas-rurais.dat-trans            = produt-carg.dat-trans
                tt-dados-cargas-rurais.cod-estabel          = produt-carg.cod-estabel
                tt-dados-cargas-rurais.cdn-produt-respons   = produt-carg.cdn-produt-respons
                tt-dados-cargas-rurais.qtd-coleta           = produt-carg.qtd-coleta
                tt-dados-cargas-rurais.cdn-compart          = produt-carg.cdn-compart
                tt-dados-cargas-rurais.val-temperat         = produt-carg.val-temperat
                tt-dados-cargas-rurais.cod-amostra          = produt-carg.cod-amostra
                tt-dados-cargas-rurais.cod-lacre            = produt-carg.cod-lacre
                tt-dados-cargas-rurais.cdn-repos            = produt-carg.cdn-repos
                tt-dados-cargas-rurais.dat-coleta           = produt-carg.dat-coleta
                tt-dados-cargas-rurais.hra-coleta           = IF produt-carg.hra-coleta <> "" THEN string(produt-carg.hra-coleta, "99:99:99") ELSE ""
                tt-dados-cargas-rurais.cdn-motiv-nao-coleta = produt-carg.cdn-motiv-nao-coleta.

         /*buscando nome do produtor*/
         IF VALID-HANDLE(h-boad098na) THEN DO:
            RUN GotoKey in h-boad098na (INPUT tt-dados-cargas-rurais.cdn-produt-rural).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN GetCharField in h-boad098na (INPUT "nome-emit", OUTPUT c-nome-emit).
            END.
            ELSE 
                ASSIGN c-nome-emit  = "":U.
         END.
         /*****************/

         ASSIGN tt-dados-cargas-rurais.nome-emitente = c-nome-emit.

         /*des propriedade */
         IF VALID-HANDLE(h-boin00980) THEN DO:

            RUN goToKey IN h-boin00980(INPUT tt-dados-cargas-rurais.cod-propried).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN h-boin00980(INPUT "des-propried":U,
                                                OUTPUT c-des-propried).
            END.
            ELSE ASSIGN c-des-propried   = "":U.

            ASSIGN tt-dados-cargas-rurais.des-propried = c-des-propried.

        END.
        /*****************/

        /*descriá∆o ponto de coleta*/
        IF VALID-HANDLE(h-boin00966) AND tt-dados-cargas-rurais.cod-pto-coleta <> "":U THEN DO:

            RUN goToKey IN h-boin00966(INPUT tt-dados-cargas-rurais.cod-pto-coleta).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN h-boin00966(INPUT "des-pto-coleta":U,
                                                OUTPUT c-des-pto-coleta).
            END.
            ELSE ASSIGN c-des-pto-coleta = "":U.

            ASSIGN tt-dados-cargas-rurais.des-pto-coleta = c-des-pto-coleta.

        END.
        /**********************/

        /*descr motivo n∆o coleta*/
        IF VALID-HANDLE(h-boin01004) THEN DO:

            RUN goToKey IN h-boin01004(INPUT tt-dados-cargas-rurais.cdn-motiv-nao-coleta).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN h-boin01004(INPUT "des-motivo":U,
                                                OUTPUT des-motivo).
            END.
            ELSE ASSIGN des-motivo = "":U.

            ASSIGN tt-dados-cargas-rurais.des-motivo = des-motivo.

        END.
        /**********************/


    END.

    RETURN "OK":U.

END PROCEDURE.



PROCEDURE piStartHandles:

    /*emitente*/
    IF NOT VALID-HANDLE(h-boad098na) THEN
        RUN adbo/boad098na.p PERSISTENT SET h-boad098na.
    RUN openQueryStatic IN h-boad098na (INPUT "Main":U).

    /*propried-rural*/
    IF NOT VALID-HANDLE(h-boin00980) THEN
        RUN inbo/boin00980.p PERSISTENT SET h-boin00980.
    RUN openQueryStatic IN h-boin00980 (INPUT "Main":U).

    /*pto-coleta*/
    IF NOT VALID-HANDLE(h-boin00966) THEN
        RUN inbo/boin00966.p PERSISTENT SET h-boin00966.
    RUN openQueryStatic IN h-boin00966 (INPUT "Main":U).

    /*motivo-nao-coleta*/ 
    IF NOT VALID-HANDLE(h-boin01004) THEN
        RUN inbo/boin01004.p PERSISTENT SET h-boin01004.
    RUN openQueryStatic IN h-boin01004 (INPUT "Main":U).
    
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piFinishHandles:

    /*emitente*/
    IF VALID-HANDLE(h-boad098na) THEN DO:
        DELETE PROCEDURE h-boad098na.
        ASSIGN h-boad098na = ?.
    END.

    /*propried-rural*/
    IF VALID-HANDLE(h-boin00980) THEN DO:
        DELETE PROCEDURE h-boin00980.
        ASSIGN h-boin00980 = ?.
    END.

    /*pto-coleta*/
    IF VALID-HANDLE(h-boin00966) THEN DO:
        DELETE PROCEDURE h-boin00966.
        ASSIGN h-boin00966 = ?.
    END.

    /*motivo-nao-coleta*/ 
    IF VALID-HANDLE(h-boin01004) THEN DO:
        DELETE PROCEDURE h-boin01004.
        ASSIGN h-boin01004 = ?.
    END.
    
    RETURN "OK":U.

END PROCEDURE.
