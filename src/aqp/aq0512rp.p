/********************************************************************************
** Copyright TOTVS S.A. (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reprodu‡Æo
** parcial ou total por qualquer meio, so poder  ser feita mediante
** autoriza‡Æo expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0512RP 2.00.00.028 } /*** "010028" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0512RP MAQ}
&ENDIF

/******************************************************************************
**
**       Programa: AQ0512RP.P
**
**       Data....: 30/011/2016.
**
**       Objetivo: EmissÆo relat¢rio em planilha para produtores rurais.
**                 M¢dulo Aquisi‡Æo de Produtos Rurais.
** 
******************************************************************************/

{aqp/aq0512.i}      /*Defini‡Æo da tt-param*/
{method/dbotterr.i} /* rowErrors*/
{utp/ut-glob.i}

 DEFINE TEMP-TABLE tt-fechto-com NO-UNDO
    FIELD cod-period          AS CHARACTER FORMAT "99/9999"
    FIELD cdn-produt-rural    AS INTEGER   FORMAT ">>>,>>>,>>9"
    FIELD cod-propried        AS CHARACTER FORMAT "x(16)"
    FIELD it-codigo           AS CHARACTER FORMAT "x(16)"
    FIELD cod-estabel         AS CHARACTER FORMAT "x(5)"
    FIELD qtd-period          AS DECIMAL   FORMAT "->>>,>>>,>>9.99999"
    FIELD val-preco-base      AS DECIMAL   FORMAT ">>>>>,>>>,>>9.9999"
    FIELD val-var-volum       AS DECIMAL   FORMAT "->>>,>>9.99999"
    FIELD val-bonus-fix       AS DECIMAL   FORMAT "->>>,>>9.99999"
    FIELD val-bonus-fix-inf   AS DECIMAL   FORMAT "->>>,>>9.99999"
    FIELD val-var-qualid      AS DECIMAL   FORMAT "->>>,>>9.99999"
    FIELD val-frete           AS DECIMAL   FORMAT ">>>,>>>,>>>,>>9.9999"
    FIELD val-preco-final-inf AS DECIMAL   FORMAT ">>>>>,>>>,>>9.9999"
    FIELD val-impto           AS DECIMAL   FORMAT ">>>,>>>,>>>,>>9.9999" /* Valor Imposto Sanidade Rural */
    INDEX idx-prop-produt cod-propried cdn-produt-rural.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/*HANDLES*/
DEFINE VARIABLE h-aqapi001  AS HANDLE NO-UNDO. /* tt-fechto-com        */
DEFINE VARIABLE h_api_ems5  AS HANDLE NO-UNDO. /* dados ems5           */
DEFINE VARIABLE h-boin00990 AS HANDLE NO-UNDO. /* produt-pto-coleta    */
DEFINE VARIABLE h-boin00966 AS HANDLE NO-UNDO. /* pto-coleta           */
DEFINE VARIABLE h-boin00980 AS HANDLE NO-UNDO. /* propried-rural       */
DEFINE VARIABLE h-boin00962 AS HANDLE NO-UNDO. /* produt-rural         */
DEFINE VARIABLE h-boin00963 AS HANDLE NO-UNDO. /* grp-produt           */
DEFINE VARIABLE h-boin00975 AS HANDLE NO-UNDO. /* rota-coleta          */
DEFINE VARIABLE h-boin00977 AS HANDLE NO-UNDO. /* regiao-abrangen      */
DEFINE VARIABLE h-boin00999 AS HANDLE NO-UNDO. /* fechto-produt-period */
DEFINE VARIABLE h-acomp     AS HANDLE NO-UNDO.

DEFINE VARIABLE c-cod-propried-ini    LIKE fechto-produt-period.cod-propried NO-UNDO.
DEFINE VARIABLE c-cod-propried-fim    LIKE fechto-produt-period.cod-propried NO-UNDO.
DEFINE VARIABLE c-cidade              LIKE cidade.cidade                     NO-UNDO.
DEFINE VARIABLE c-uf                  LIKE emitente.estado                   NO-UNDO.
DEFINE VARIABLE c-nome-emit           LIKE emitente.nome-emit                NO-UNDO.
DEFINE VARIABLE c-nome-abrev          LIKE emitente.nome-abrev               NO-UNDO.
DEFINE VARIABLE c-cgc                 LIKE emitente.cgc                      NO-UNDO.
DEFINE VARIABLE c-ins-estadual        LIKE emitente.ins-estadual             NO-UNDO.
DEFINE VARIABLE i-natureza            LIKE emitente.natureza                 NO-UNDO.
DEFINE VARIABLE c-cod-externo         AS CHARACTER                           NO-UNDO.    
DEFINE VARIABLE c-cod-pto-coleta      AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-des-pto-coleta      LIKE pto-coleta.des-pto-coleta         NO-UNDO.
DEFINE VARIABLE c-des-propried        LIKE propried-rural.des-propried       NO-UNDO.
DEFINE VARIABLE i-cdn-grp-produt      LIKE produt-rural.cdn-grp-produt       NO-UNDO.
DEFINE VARIABLE c-des-grp-produt      LIKE grp-produt.des-grp-produt         NO-UNDO.
DEFINE VARIABLE c-cod-rota-princ      LIKE propried-rural.cod-rota-princ     NO-UNDO.
DEFINE VARIABLE c-cod-regiao          LIKE regiao-abrangen.cod-regiao        NO-UNDO.
DEFINE VARIABLE c-nom-regiao          LIKE regiao-abrangen.nom-regiao        NO-UNDO.
DEFINE VARIABLE c-des-rota            LIKE rota-coleta.des-rota              NO-UNDO.
DEFINE VARIABLE i-val-incentivo       AS DECIMAL                             NO-UNDO.
DEFINE VARIABLE i-val-imp-retido      AS DECIMAL                             NO-UNDO.
DEFINE VARIABLE i-val-pre-liq-ant     AS DECIMAL                             NO-UNDO.
DEFINE VARIABLE i-val-ajuste          AS DECIMAL                             NO-UNDO.
DEFINE VARIABLE i-cod-regra-utilizada AS INTEGER                             NO-UNDO.
DEFINE VARIABLE c-var-preco-total     AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-val_preco-unit      AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE c-val_ajuste          AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE de-perc-incentivo     AS DECIMAL                             NO-UNDO.
DEFINE VARIABLE c-val-despesa         AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE de-total-prov-engine  AS DECIMAL                             NO-UNDO.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

{utp/ut-liter.i Buscando_dados_relat¢rio *}
RUN pi-inicializar IN h-acomp (INPUT TRIM(RETURN-VALUE)).
RUN pi-acompanhar  IN h-acomp (INPUT TRIM(RETURN-VALUE)).

FIND FIRST tt-param NO-ERROR.
ASSIGN c-cod-propried-ini = "":U
       c-cod-propried-fim = FILL('Z', 16).

RUN piStartHandles IN THIS-PROCEDURE.

RUN piGeraTTDados IN THIS-PROCEDURE.

IF  tt-param.destino = 4  THEN DO:

    {utp/ut-liter.i Gerando_excel *}
    RUN pi-acompanhar  IN h-acomp (INPUT TRIM(RETURN-VALUE)).

    /*envia tt para gera‡Æo do excel*/
    RUN aqp/aq0512a.p (INPUT TABLE tt-param,
                       INPUT TABLE tt-dados-ensaio-pagtoV2).
END.

RUN piFinishHandles IN THIS-PROCEDURE.

RUN pi-finalizar IN h-acomp.


/* ===================== PROCEDURES INTERNAS ========================*/
PROCEDURE piGeraTTDados:
    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF VALID-HANDLE(h-aqapi001) THEN DO:
        {utp/ut-liter.i Varia‡äes_de_qualidade_e_volume *}
        RUN pi-acompanhar  IN h-acomp (INPUT TRIM(RETURN-VALUE)).

        RUN setItem IN h-aqapi001 (INPUT tt-param.it-codigo).

        RUN piFechtoParcial IN h-aqapi001 (INPUT tt-param.period,
                                           INPUT tt-param.cod-estabel-ini,
                                           INPUT tt-param.cod-estabel-fim,
                                           INPUT tt-param.cod-regiao-ini,
                                           INPUT tt-param.cod-regiao-fim,
                                           INPUT tt-param.cod-rota-ini,
                                           INPUT tt-param.cod-rota-fim,
                                           INPUT tt-param.cdn-grp-produt-ini,
                                           INPUT tt-param.cdn-grp-produt-fim,
                                           INPUT tt-param.cdn-produt-rural-ini,
                                           INPUT tt-param.cdn-produt-rural-fim,
                                           INPUT c-cod-propried-ini,
                                           INPUT c-cod-propried-fim,
                                           OUTPUT TABLE tt-fechto-com,
                                           OUTPUT TABLE rowErrors).
    
    END.
    
    /*dados iniciais*/
    FOR EACH tt-fechto-com:
        IF NOT tt-param.list-qtd-zerada AND tt-fechto-com.qtd-period <= 0 THEN
            NEXT.

        CREATE tt-dados-ensaio-pagto.
        ASSIGN tt-dados-ensaio-pagto.cod-period          = tt-fechto-com.cod-period
               tt-dados-ensaio-pagto.cod-estab           = tt-fechto-com.cod-estabel
               tt-dados-ensaio-pagto.cdn-produt-rural    = tt-fechto-com.cdn-produt-rural
               tt-dados-ensaio-pagto.cod-propried        = tt-fechto-com.cod-propried
               tt-dados-ensaio-pagto.qtd-period          = tt-fechto-com.qtd-period
               tt-dados-ensaio-pagto.val-preco-final-inf = tt-fechto-com.val-preco-final-inf
               tt-dados-ensaio-pagto.val-preco-base      = tt-fechto-com.val-preco-base
               tt-dados-ensaio-pagto.val-var-qualid      = tt-fechto-com.val-var-qualid
               tt-dados-ensaio-pagto.val-var-volum       = tt-fechto-com.val-var-volum
               tt-dados-ensaio-pagto.val-bonus-fix       = tt-fechto-com.val-bonus-fix
               tt-dados-ensaio-pagto.val-bonus-fix-inf   = tt-fechto-com.val-bonus-fix-inf.
    END.
    /****************/
    
    /*dados ems5*/
    IF VALID-HANDLE(h_api_ems5) THEN DO:
        {utp/ut-liter.i Dados_financeiros *}
        RUN pi-acompanhar  IN h-acomp (INPUT TRIM(RETURN-VALUE)).
        RUN pi_retornar_dados_produtor_ensaio_pagamento IN h_api_ems5 (INPUT-OUTPUT TABLE tt-dados-ensaio-pagto).
    END.
    /************/

    FOR EACH tt-dados-ensaio-pagto:
        CREATE tt-dados-ensaio-pagtoV2.
        BUFFER-COPY tt-dados-ensaio-pagto TO tt-dados-ensaio-pagtoV2.
        FOR FIRST tt-fechto-com
            WHERE tt-fechto-com.cod-period       = tt-dados-ensaio-pagto.cod-period      
              AND tt-fechto-com.cod-estabel      = tt-dados-ensaio-pagto.cod-estab     
              AND tt-fechto-com.cdn-produt-rural = tt-dados-ensaio-pagto.cdn-produt-rural
              AND tt-fechto-com.cod-propried     = tt-dados-ensaio-pagto.cod-propried:
              tt-dados-ensaio-pagtoV2.val-impto = tt-fechto-com.val-impto.
        END.
    END.
    
    /*dados extras*/
    FOR EACH tt-dados-ensaio-pagtoV2:

        {utp/ut-liter.i Dados_extras_produdor *}
        RUN pi-acompanhar  IN h-acomp (INPUT TRIM(RETURN-VALUE) + ": " + STRING(tt-dados-ensaio-pagtoV2.cdn-produt-rural)).

        ASSIGN c-cidade       = "":U
               c-uf           = "":U
               c-nome-emit    = "":U
               c-nome-abrev   = "":U
               c-cgc          = "":U
               c-ins-estadual = "":U.
        /*buscando cidade e nome do produtor*/
        FOR FIRST emitente FIELDS (cidade estado nome-emit nome-abrev cgc ins-estadual natureza) NO-LOCK 
            WHERE emitente.cod-emitente = tt-dados-ensaio-pagtoV2.cdn-produt-rural:
            ASSIGN c-cidade       = emitente.cidade
                   c-uf           = emitente.estado
                   c-nome-emit    = emitente.nome-emit
                   c-nome-abrev   = emitente.nome-abrev
                   c-cgc          = emitente.cgc
                   c-ins-estadual = emitente.ins-estadual
                   i-natureza     = emitente.natureza.
        END.

        FOR FIRST propried-rural NO-LOCK  /* busca a propriedade do emitente*/
            WHERE propried-rural.cod-propried     = tt-dados-ensaio-pagtoV2.cod-propried
              AND propried-rural.cdn-produt-rural = tt-dados-ensaio-pagtoV2.cdn-produt-rural,

            FIRST loc-entr NO-LOCK /*busca os dados do local de entrega da propriedade*/
                WHERE loc-entr.nome-abrev  = c-nome-abrev
                  AND loc-entr.cod-entrega = propried-rural.cod-entrega:           
           
                ASSIGN c-cidade = IF AVAIL loc-entr THEN loc-entr.cidade ELSE c-cidade
                       c-uf     = IF AVAIL loc-entr THEN loc-entr.estado ELSE c-uf
                       c-ins-estadual = IF AVAIL loc-entr THEN loc-entr.ins-estadual ELSE c-ins-estadual.
        END.

        CASE i-natureza:
            WHEN 1 THEN assign c-cgc = string(c-cgc, param-global.formato-id-pessoal).
            WHEN 2 THEN assign c-cgc = string(c-cgc, param-global.formato-id-federal).
        END CASE.
            
                              
        ASSIGN tt-dados-ensaio-pagtoV2.cidade       = c-cidade
               tt-dados-ensaio-pagtoV2.uf           = c-uf
               tt-dados-ensaio-pagtoV2.nome-emit    = c-nome-emit
               tt-dados-ensaio-pagtoV2.cnpj         = c-cgc        
               tt-dados-ensaio-pagtoV2.ins-estadual = c-ins-estadual. 
        /********************************/

        /*cod e des pto-coleta*/
        /*cod*/
        IF VALID-HANDLE(h-boin00990) THEN DO:

            RUN findCodExternoProdutPtoColetivo IN h-boin00990(INPUT tt-dados-ensaio-pagtoV2.cdn-produt-rural,
                                                               INPUT tt-dados-ensaio-pagtoV2.cod-propried,
                                                               OUTPUT c-cod-externo,
                                                               OUTPUT c-cod-pto-coleta).

            ASSIGN tt-dados-ensaio-pagtoV2.cod-pto-coleta = c-cod-pto-coleta.

        END.
        
        /*des*/
        IF VALID-HANDLE(h-boin00966) AND c-cod-pto-coleta <> "":U THEN DO:

            RUN goToKey IN h-boin00966(INPUT c-cod-pto-coleta).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN h-boin00966(INPUT "des-pto-coleta":U,
                                                OUTPUT c-des-pto-coleta).
            END.
            ELSE ASSIGN c-des-pto-coleta = "":U.

            ASSIGN tt-dados-ensaio-pagtoV2.des-pto-coleta = c-des-pto-coleta.

        END.
        /**********************/

        /*des propriedade cod-rota cod-regiao*/
        IF VALID-HANDLE(h-boin00980) THEN DO:

            RUN goToKey IN h-boin00980(INPUT tt-dados-ensaio-pagtoV2.cod-propried).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN h-boin00980(INPUT "des-propried":U,
                                                OUTPUT c-des-propried).
                RUN getCharField IN h-boin00980(INPUT "cod-rota-princ":U,
                                                OUTPUT c-cod-rota-princ).
                RUN getCharField IN h-boin00980(INPUT "cod-regiao",
                                                OUTPUT c-cod-regiao).
            END.
            ELSE ASSIGN c-des-propried   = "":U
                        c-cod-rota-princ = "":U
                        c-cod-regiao     = "":U.

            ASSIGN tt-dados-ensaio-pagtoV2.des-propried = c-des-propried
                   tt-dados-ensaio-pagtoV2.cod-rota     = c-cod-rota-princ
                   tt-dados-ensaio-pagtoV2.cod-regiao   = c-cod-regiao.

        END.
        /*****************/

        /*des rota*/
        IF VALID-HANDLE(h-boin00975) THEN DO:

            RUN goToKey IN h-boin00975(INPUT tt-dados-ensaio-pagtoV2.cod-rota).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN h-boin00975(INPUT "des-rota":U,
                                                OUTPUT c-des-rota).
            END.
            ELSE ASSIGN c-des-rota = "":U.

            ASSIGN tt-dados-ensaio-pagtoV2.des-rota = c-des-rota.

        END.
        /**********/

        /*des-regiao*/
        IF VALID-HANDLE(h-boin00977) THEN DO:

            RUN goToKey IN h-boin00977(INPUT tt-dados-ensaio-pagtoV2.cod-regiao).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN h-boin00977(INPUT "nom-regiao":U,
                                                OUTPUT c-nom-regiao).
            END.
            ELSE ASSIGN c-des-rota = "":U.

            ASSIGN tt-dados-ensaio-pagtoV2.des-regiao = c-nom-regiao.

        END.
        /************/

        /*cod e des grp-produt*/
        /*cod*/
        IF VALID-HANDLE(h-boin00962) THEN DO:

            RUN goToKey IN h-boin00962 (INPUT tt-dados-ensaio-pagtoV2.cdn-produt-rural).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getIntField IN h-boin00962 (INPUT "cdn-grp-produt":U,
                                                OUTPUT i-cdn-grp-produt).
            END.
            ELSE ASSIGN i-cdn-grp-produt = 0.

            ASSIGN tt-dados-ensaio-pagtoV2.cdn-grp-produt = i-cdn-grp-produt.

        END.
        /*****/
        
        /*des*/
        IF VALID-HANDLE(h-boin00963) THEN DO:

            RUN goToKey IN h-boin00963 (INPUT tt-dados-ensaio-pagtoV2.cdn-grp-produt).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN h-boin00963 (INPUT "des-grp-produt":U,
                                                 OUTPUT c-des-grp-produt).
            END.
            ELSE ASSIGN c-des-grp-produt = "":U.

            ASSIGN tt-dados-ensaio-pagtoV2.des-grp-produt = c-des-grp-produt.

        END.
        /*****/
        /**********************/

        RUN piRetornaPreLiqAnt IN THIS-PROCEDURE (OUTPUT i-val-pre-liq-ant).
        ASSIGN tt-dados-ensaio-pagtoV2.val-pre-liq-ant     = i-val-pre-liq-ant.

        IF VALID-HANDLE(h-boin00999) THEN DO:
            RUN retornaIncentivo IN h-boin00999(INPUT tt-param.period,
                                                INPUT tt-dados-ensaio-pagtoV2.cdn-produt-rural,
                                                INPUT tt-param.it-codigo,
                                                INPUT tt-dados-ensaio-pagtoV2.cod-estab,
                                                INPUT tt-dados-ensaio-pagtoV2.qtd-period,
                                                INPUT tt-dados-ensaio-pagtoV2.val-preco-base,
                                                INPUT tt-dados-ensaio-pagtoV2.val-var-volum,
                                                INPUT tt-dados-ensaio-pagtoV2.val-bonus-fix-inf,
                                                INPUT tt-dados-ensaio-pagtoV2.val-var-qualid,
                                                INPUT tt-dados-ensaio-pagtoV2.val-preco-final-inf,
                                                OUTPUT i-val-ajuste,
                                                OUTPUT i-val-incentivo,
                                                OUTPUT i-val-imp-retido).
        END.
        
        ASSIGN tt-dados-ensaio-pagtoV2.val-imp-retido = IF i-val-imp-retido <> 0 THEN i-val-imp-retido ELSE tt-dados-ensaio-pagtoV2.val-imp-retido.

        /* buscar valores do engine para preco total quando tem incentivo */
        ASSIGN de-total-prov-engine = 0.
        RUN piEngineRegras.
        ASSIGN de-total-prov-engine                 = IF DEC(c-var-preco-total) > 0 AND DEC(c-val-despesa) > 0 THEN 
                                                          DEC(c-var-preco-total) + DEC(c-val-despesa)
                                                      ELSE
                                                          0.
               tt-dados-ensaio-pagtoV2.val-ajuste     = DEC(c-val_ajuste).

        /*dados calculados*/
        ASSIGN tt-dados-ensaio-pagtoV2.val-pre-unit        = tt-dados-ensaio-pagtoV2.val-preco-base +
                                                             tt-dados-ensaio-pagtoV2.val-var-qualid +
                                                             tt-dados-ensaio-pagtoV2.val-var-volum  +
                                                             tt-dados-ensaio-pagtoV2.val-bonus-fix
                                                             /*Soma de preço base + var. qualidade + var. volume + bônus fixo*/

               tt-dados-ensaio-pagtoV2.val-incentivo       = DEC(c-val-despesa)

               tt-dados-ensaio-pagtoV2.val-pre-liq         = ((tt-dados-ensaio-pagtoV2.qtd-period * tt-dados-ensaio-pagtoV2.val-pre-unit) +
                                                               tt-dados-ensaio-pagtoV2.val-incentivo + tt-dados-ensaio-pagtoV2.val-imp-retido) / tt-dados-ensaio-pagtoV2.qtd-period
                                                           /*(Quantidade * Preço Final + Incentivo + Imp. Retido) / Quantidade*/

               tt-dados-ensaio-pagtoV2.val-tot-prov        = IF DEC(de-total-prov-engine) > 0 THEN
                                                               de-total-prov-engine
                                                             ELSE
                                                               (tt-dados-ensaio-pagtoV2.qtd-period * tt-dados-ensaio-pagtoV2.val-preco-final-inf )  
                                                               /*(Quantidade * Preço Final)*/

               tt-dados-ensaio-pagtoV2.val-pre-bruto       = (tt-dados-ensaio-pagtoV2.val-tot-prov / tt-dados-ensaio-pagtoV2.qtd-period)
                                                             /* total proventos / quantidade */ 

               tt-dados-ensaio-pagtoV2.val-desconto-tot    = tt-dados-ensaio-pagtoV2.val-outr-cred     +
                                                             tt-dados-ensaio-pagtoV2.val-adiantamentos +
                                                             tt-dados-ensaio-pagtoV2.val-emprestimos   +
                                                             tt-dados-ensaio-pagtoV2.val-convenios     +
                                                             tt-dados-ensaio-pagtoV2.val-outr-debitos
                                                             /*Outros créditos + Adiantamentos + Empréstimos + Convênios + Outros Débitos*/ 
               
               tt-dados-ensaio-pagtoV2.val-liq-receb-tot   = tt-dados-ensaio-pagtoV2.val-tot-prov     + 
                                                             tt-dados-ensaio-pagtoV2.val-desconto-tot + 
                                                             tt-dados-ensaio-pagtoV2.val-imp-retido
                                                             /*Total Proventos + Desconto Total + Imp. Retido*/ 
               . 
        /******************/

        FOR EACH nf-produt-propried NO-LOCK
           WHERE nf-produt-propried.cod-period       = tt-dados-ensaio-pagtoV2.cod-period
             AND nf-produt-propried.cdn-produt-rural = tt-dados-ensaio-pagtoV2.cdn-produt-rural
             AND nf-produt-propried.cod-propried     = tt-dados-ensaio-pagtoV2.cod-propried
             AND nf-produt-propried.it-codigo        = tt-param.it-codigo
             AND nf-produt-propried.cod-estabel      = tt-dados-ensaio-pagtoV2.cod-estab:

            IF nf-produt-propried.num-livre-1 <> 0 THEN /* desconsidera complementar */
                NEXT.

            IF tt-dados-ensaio-pagtoV2.nro-docto = "" THEN
                ASSIGN tt-dados-ensaio-pagtoV2.nro-docto   = nf-produt-propried.nro-docto
                       tt-dados-ensaio-pagtoV2.serie-docto = nf-produt-propried.serie-docto.
            ELSE 
                ASSIGN tt-dados-ensaio-pagtoV2.nro-docto   = tt-dados-ensaio-pagtoV2.nro-docto   + "/" + nf-produt-propried.nro-docto
                       tt-dados-ensaio-pagtoV2.serie-docto = tt-dados-ensaio-pagtoV2.serie-docto + "/" + nf-produt-propried.serie-docto.
        END.

    END.
    /**************/

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE piRetornaPreLiqAnt:

    DEFINE OUTPUT PARAMETER i-val-period-ant AS DECIMAL NO-UNDO.

    DEFINE VARIABLE c-period-anterior LIKE fechto-produt-period.cod-period NO-UNDO.

    ASSIGN c-period-anterior = IF INT(SUBSTRING(tt-param.period,1,2)) = 1  /*janeiro*/
                                   THEN "12" + STRING(INT(SUBSTRING(tt-param.period,3,4)) - 1)
                               ELSE IF INT(SUBSTRING(tt-param.period,1,2)) <= 10
                                   THEN "0" + STRING(INT(SUBSTRING(tt-param.period,1,2)) - 1) + SUBSTRING(tt-param.period,3,4)
                               ELSE     
                                   STRING(INT(SUBSTRING(tt-param.period,1,2)) - 1) + SUBSTRING(tt-param.period,3,4).


    IF VALID-HANDLE(h-boin00999) THEN DO:

        RUN goToKey IN h-boin00999(INPUT c-period-anterior,
                                   INPUT tt-dados-ensaio-pagtoV2.cdn-produt-rural,
                                   INPUT tt-dados-ensaio-pagtoV2.cod-propried,
                                   INPUT tt-param.it-codigo,
                                   INPUT tt-dados-ensaio-pagtoV2.cod-estab).

        IF RETURN-VALUE = "OK":U THEN
            RUN getDecField IN h-boin00999(INPUT "val-preco-final-inf":U,
                                           OUTPUT i-val-period-ant).


    END.

RETURN "OK":U.

END PROCEDURE.


PROCEDURE piEngineRegras:

    DEFINE VARIABLE da-ini-period     AS DATE      NO-UNDO.
    DEFINE VARIABLE da-fim-period     AS DATE      NO-UNDO.

    ASSIGN da-ini-period = DATE("01/" + SUBSTRING(tt-dados-ensaio-pagtoV2.cod-period,1,2) + "/" + SUBSTRING(tt-dados-ensaio-pagtoV2.cod-period,3,4)).
           da-fim-period = IF INT(SUBSTRING(tt-dados-ensaio-pagtoV2.cod-period,1,2)) < 12 THEN 
                               DATE("01/" + STRING(MONTH(da-ini-period) + 1) + "/" + STRING(YEAR(da-ini-period))) - 1  /* £ltimo dia do mˆs */
                           ELSE 
                               DATE("31/" +         "12"                     + "/" + STRING(YEAR(da-ini-period))).     /* digitado em tela  */

    /*Busca dados no Engine de Regras para tratamento de incentivo*/
    FOR FIRST produt-rural FIELDS(cdn-produt-rural log-optan-incent) NO-LOCK
        WHERE produt-rural.cdn-produt-rural = tt-dados-ensaio-pagtoV2.cdn-produt-rural:
    END.

    IF NOT AVAIL produt-rural THEN
        RETURN "NOK":U.

    /*controle de quantidade entregue pelo produtor*/
    FOR FIRST quant-fornec-produt FIELDS(qtd-fornec) NO-LOCK
        WHERE quant-fornec-produt.cdn-produt-rural = tt-dados-ensaio-pagtoV2.cdn-produt-rural
          AND quant-fornec-produt.it-codigo        = tt-param.it-codigo
          AND quant-fornec-produt.dat-inic         = DATE("01/01/" + SUBSTRING(tt-dados-ensaio-pagtoV2.cod-period,3,4))
          AND quant-fornec-produt.dat-fim          = DATE("31/12/" + SUBSTRING(tt-dados-ensaio-pagtoV2.cod-period,3,4)):
    END.

    IF CAN-FIND(FIRST config-operac 
                WHERE config-operac.cdn-empresa    = i-ep-codigo-usuario
                  AND config-operac.cod-estab      = tt-dados-ensaio-pagtoV2.cod-estab     
                  AND config-operac.cod-tip-operac = "AQR-NF-Produtor":U) THEN DO:

        EMPTY TEMP-TABLE tt-variavel.

        /*Carrega variaveis para o engine de regras*/
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "optante":U
               tt-variavel.valor-variavel    = IF AVAIL produt-rural THEN string(produt-rural.log-optan-incent) ELSE "No" /*Verificar campo*/.

        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "item":U
               tt-variavel.valor-variavel    = tt-param.it-codigo.
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "preco-base":U
               tt-variavel.valor-variavel    = STRING(tt-dados-ensaio-pagtoV2.val-preco-base,">>>>>,>>>,>>9.9999").
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "var-volume":U
               tt-variavel.valor-variavel    = string(tt-dados-ensaio-pagtoV2.val-var-volum,"->>>,>>9.99999").
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "bonus-fix-inf":U
               tt-variavel.valor-variavel    = string(tt-dados-ensaio-pagtoV2.val-bonus-fix-inf,"->>>,>>9.99999").
    
        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "var-qualid":U
               tt-variavel.valor-variavel    = string(tt-dados-ensaio-pagtoV2.val-var-qualid,"->>>,>>9.99999").

        create tt-variavel.
        assign tt-variavel.cod-var-oper      = "preco-final-inf":U
               tt-variavel.valor-variavel = string(tt-dados-ensaio-pagtoV2.val-preco-final-inf,">>>>>,>>>,>>9.9999").

        /*caso já tenha NF gerada, descontar qtd*/
        IF CAN-FIND (FIRST nf-produt-propried
                     WHERE nf-produt-propried.cod-period       = tt-dados-ensaio-pagtoV2.cod-period
                       AND nf-produt-propried.cdn-produt-rural = tt-dados-ensaio-pagtoV2.cdn-produt-rural
                       AND nf-produt-propried.cod-propried     = tt-dados-ensaio-pagtoV2.cod-propried
                       AND nf-produt-propried.it-codigo        = tt-param.it-codigo
                       AND nf-produt-propried.cod-estabel      = tt-dados-ensaio-pagtoV2.cod-estab) THEN DO:

            create tt-variavel.
            assign tt-variavel.cod-var-oper      = "vol-acum-ano":U
                   tt-variavel.valor-variavel    = IF AVAIL quant-fornec-produt THEN string((quant-fornec-produt.qtd-fornec - tt-dados-ensaio-pagtoV2.qtd-period),">>>,>>>>,>>>,>>9.9999") ELSE "0".
            
            create tt-variavel.
            assign tt-variavel.cod-var-oper      = "vol-mes":U
                   tt-variavel.valor-variavel    = string(tt-dados-ensaio-pagtoV2.qtd-period,"->>>,>>>,>>9.99999").
            
            create tt-variavel.
            assign tt-variavel.cod-var-oper      = "vol-ano-mes":U
                   tt-variavel.valor-variavel    = IF AVAIL quant-fornec-produt THEN string(quant-fornec-produt.qtd-fornec,"->>>,>>>,>>9.99999") ELSE "0".
            
        END.
        /*se não, somar a qtd para o engine*/
        ELSE DO:

            create tt-variavel.
            assign tt-variavel.cod-var-oper      = "vol-acum-ano":U
                   tt-variavel.valor-variavel    = IF AVAIL quant-fornec-produt THEN string(quant-fornec-produt.qtd-fornec,">>>,>>>>,>>>,>>9.9999") ELSE "0".
            
            create tt-variavel.
            assign tt-variavel.cod-var-oper      = "vol-mes":U
                   tt-variavel.valor-variavel    = string(tt-dados-ensaio-pagtoV2.qtd-period,"->>>,>>>,>>9.99999").
            
            create tt-variavel.
            assign tt-variavel.cod-var-oper      = "vol-ano-mes":U
                   tt-variavel.valor-variavel = IF AVAIL quant-fornec-produt THEN 
                                                    string(quant-fornec-produt.qtd-fornec + tt-dados-ensaio-pagtoV2.qtd-period,">>>,>>>>,>>>,>>9.9999") 
                                                ELSE 
                                                    string(tt-dados-ensaio-pagtoV2.qtd-period,"->>>,>>>,>>9.99999").
            
        END.
    
        RUN cdp/cdapi034.p  (INPUT i-ep-codigo-usuario,
                             INPUT tt-dados-ensaio-pagtoV2.cod-estab,
                             INPUT "AQR-NF-Produtor":U,
                             INPUT TABLE tt-variavel,
                             OUTPUT i-cod-regra-utilizada,
                             OUTPUT TABLE tt-retorno,
                             OUTPUT TABLE RowErrors).

        FOR FIRST RowErrors
            WHERE RowErrors.ErrorNumber <> 25997: /*desconsidera erro de regra nÆo encontrada, neste caso ele ir  gerar as notas com os parametros informados em tela*/
            RETURN "NOK":U.
        END.

        /*Elimina conte£do das Variaveis*/
        ASSIGN c-var-preco-total = ""
               c-val_preco-unit  = ""
               c-val_ajuste      = ""
               c-val-despesa     = ""
               de-perc-incentivo = 0.

        /*passa os retornos do engine para as variaveis apropriadas*/
        FOR EACH tt-retorno:

            IF tt-retorno.campo-retorno = "Val-Preco-Total" THEN
                ASSIGN c-var-preco-total = tt-retorno.valor-retorno.
    
            IF tt-retorno.campo-retorno = "Val-Preco-Unit" THEN
                ASSIGN c-val_preco-unit = tt-retorno.valor-retorno.

            IF tt-retorno.campo-retorno = "Val-ajuste" THEN
                ASSIGN c-val_ajuste = tt-retorno.valor-retorno.

            IF tt-retorno.campo-retorno = "Val-Despesa" THEN
                ASSIGN c-val-despesa = tt-retorno.valor-retorno.

            IF tt-retorno.campo-retorno = "Perc-Incentivo" THEN
                ASSIGN de-perc-incentivo = dec(tt-retorno.valor-retorno).

        END.

    END.

RETURN "OK":U.

END PROCEDURE.


PROCEDURE piStartHandles:

    /*api calculo*/
    IF NOT VALID-HANDLE(h-aqapi001) THEN
        RUN aqp/aqapi001.p PERSISTENT SET h-aqapi001.

    /*api ems5*/
    IF NOT VALID-HANDLE(h_api_ems5) THEN
        RUN prgfin/apb/apb061za.p PERSISTENT SET h_api_ems5.

    /*produt-pto-coleta*/
    IF NOT VALID-HANDLE(h-boin00990) THEN
        RUN inbo/boin00990.p PERSISTENT SET h-boin00990.
    RUN openQueryStatic IN h-boin00990 (INPUT "Main":U).

    /*pto-coleta*/
    IF NOT VALID-HANDLE(h-boin00966) THEN
        RUN inbo/boin00966.p PERSISTENT SET h-boin00966.
    RUN openQueryStatic IN h-boin00966 (INPUT "Main":U).

    /*propried-rural*/
    IF NOT VALID-HANDLE(h-boin00980) THEN
        RUN inbo/boin00980.p PERSISTENT SET h-boin00980.
    RUN openQueryStatic IN h-boin00980 (INPUT "Main":U).

    /*produt-rural*/
    IF NOT VALID-HANDLE(h-boin00962) THEN
        RUN inbo/boin00962.p PERSISTENT SET h-boin00962.
    RUN openQueryStatic IN h-boin00962 (INPUT "Main":U).

    /*grp-produt*/
    IF NOT VALID-HANDLE(h-boin00963) THEN
        RUN inbo/boin00963.p PERSISTENT SET h-boin00963.
    RUN openQueryStatic IN h-boin00963 (INPUT "Main":U).

    /*rota-coleta*/
    IF NOT VALID-HANDLE(h-boin00975) THEN
        RUN inbo/boin00975.p PERSISTENT SET h-boin00975.
    RUN openQueryStatic IN h-boin00975 (INPUT "Main":U).

    /*rota-coleta*/
    IF NOT VALID-HANDLE(h-boin00977) THEN
        RUN inbo/boin00977.p PERSISTENT SET h-boin00977.
    RUN openQueryStatic IN h-boin00977 (INPUT "Main":U).

    /*fechto-produt-period*/
    IF NOT VALID-HANDLE(h-boin00999) THEN
        RUN inbo/boin00999.p PERSISTENT SET h-boin00999.
    RUN openQueryStatic IN h-boin00999 (INPUT "Main":U).

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE piFinishHandles:

    /*api calculo*/
    IF  h-aqapi001 <> ? THEN DO:
        DELETE PROCEDURE h-aqapi001.
        ASSIGN h-aqapi001 = ?.
    END.

    /*api ems5*/
    IF  h_api_ems5 <> ? THEN DO:
        DELETE PROCEDURE h_api_ems5.
        ASSIGN h_api_ems5 = ?.
    END.

    /*produt-pto-coleta*/
    IF VALID-HANDLE(h-boin00990) THEN DO:
        DELETE PROCEDURE h-boin00990.
        ASSIGN h-boin00990 = ?.
    END.

    /*pto-coleta*/
    IF VALID-HANDLE(h-boin00966) THEN DO:
        DELETE PROCEDURE h-boin00966.
        ASSIGN h-boin00966 = ?.
    END.

    /*propried-rural*/
    IF VALID-HANDLE(h-boin00980) THEN DO:
        DELETE PROCEDURE h-boin00980.
        ASSIGN h-boin00980 = ?.
    END.

    /*produt-rural*/
    IF VALID-HANDLE(h-boin00962) THEN DO:
        DELETE PROCEDURE h-boin00962.
        ASSIGN h-boin00962 = ?.
    END.

    /*grp-produt*/
    IF VALID-HANDLE(h-boin00963) THEN DO:
        DELETE PROCEDURE h-boin00963.
        ASSIGN h-boin00963 = ?.
    END.

    /*rota-coleta*/
    IF VALID-HANDLE(h-boin00975) THEN DO:
        DELETE PROCEDURE h-boin00975.
        ASSIGN h-boin00975 = ?.
    END.

    /*regiao-abrangen*/
    IF VALID-HANDLE(h-boin00977) THEN DO:
        DELETE PROCEDURE h-boin00977.
        ASSIGN h-boin00977 = ?.
    END.

    /*fechto-produt-period*/
    IF VALID-HANDLE(h-boin00999) THEN DO:
        DELETE PROCEDURE h-boin00999.
        ASSIGN h-boin00999 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

