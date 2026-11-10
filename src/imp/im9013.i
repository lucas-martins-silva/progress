/*****************************************************************************
**
** IM9013 - Integraá∆o entre Importaá∆o e Recebimento (EMS)
**
** Objetivo: Achar total das duplicatas.
**
******************************************************************************/

{include/i_fncrowid.i}
{cdp/cdcfgmat.i} /* Definiá∆o de prÇ-processadores */
{cdp/cdcfgdis.i} /* Definiá∆o de prÇ-processadores */
{cdp/cdcfgcex.i} /* Definiá∆o de prÇ-processadores */
{cdp/cd4300.i3}  /* include tratamento atributo livre */
{cxbo/bocx250.i50} /* include tratamento atributo livre param-imp.char-1 */

DEF BUFFER bNatur-oper FOR natur-oper.

&if defined(bf-mat-comex) &then
    def input parameter rw-docto   as &IF {&ROWID_READY} = YES &THEN
                                        ROWID
                                      &ELSE
                                        RECID
                                      &ENDIF.
&else
    /*Include i-epc200.i: Definicao Temp-Table tt-epc */
    {include/i-epc200.i im9013}
    {utp/ut-glob.i}

    def input parameter rw-docto   as rowid.
&endif

def input-output parameter de-tot-dup as decimal format ">>>>>,>>>,>>9.99".

/* Tratamento PIS/COFINS */
DEF VAR da-inicio-pis    AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF VAR da-inicio-cofins AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF VAR de-valor-pis     AS DECIMAL FORMAT "99999999999.99" NO-UNDO.
DEF VAR de-valor-cofins  AS DECIMAL FORMAT "99999999999.99" NO-UNDO.
DEF VAR l-imp-rateio     AS LOGICAL INIT NO NO-UNDO.
DEF VAR l-rec-dif-dp-nf-imp AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR de-icms-deson       LIKE ct-trib-item-doc-est.val-trib NO-UNDO.
DEF VAR l-icms-diferido     AS LOGICAL            NO-UNDO.
{rep/re1001a.i50} /* include tratamento atributo livre docum-est.char-1 */

&if defined(bf-mat-comex) &then
    for first docum-est fields(cod-estabel cod-emitente serie-docto
                               nro-docto nat-operacao)
        where &IF {&ROWID_READY} = YES &THEN
                ROWID(docum-est)
              &ELSE
                recid(docum-est)
              &ENDIF
              = rw-docto no-lock:
    end.
&else
    for first docum-est fields(cod-estabel cod-emitente serie-docto
                               nro-docto nat-operacao)
        where rowid(docum-est) = rw-docto no-lock:
    end.

    FOR EACH   tt-epc:
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"CalculoSemImpostos"'
                         &CodParameter='"c-seg-usuario"'
                         &ValueParameter="string(c-seg-usuario)"}
    /*
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "CalculoSemImpostos"
           tt-epc.cod-parameter = "c-seg-usuario"
           tt-epc.val-parameter = c-seg-usuario.
    */
    {include/i-epc201.i "CalculoSemImpostos"}

    FIND  tt-epc WHERE
          tt-epc.cod-event     = "recebecomdiferenca" AND
          tt-epc.cod-parameter = "l-rec-dif-dp-nf-imp" NO-ERROR.
    IF AVAIL tt-epc THEN
        ASSIGN l-rec-dif-dp-nf-imp = IF tt-epc.val-parameter = "yes" THEN YES ELSE NO.
    ELSE
       ASSIGN l-rec-dif-dp-nf-imp = NO.

&endif

&IF DEFINED(bf-mat-comex) &THEN
    /* especifico FUNDAP */
    FIND emitente
        WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
    FIND estabelec
        WHERE estabelec.cod-estabel = docum-est.cod-estabel  NO-LOCK NO-ERROR.
    IF AVAIL emitente AND
        AVAIL estabelec AND
        emitente.pais = estabelec.pais THEN DO:
        ASSIGN de-tot-dup = docum-est.valor-mercad.

        for each docum-est-cex fields(cod-desp val-desp cod-emitente-desp)
            where docum-est-cex.serie-docto   = docum-est.serie-docto
            and docum-est-cex.nro-docto = string(docum-est.nro-docto)
            and docum-est-cex.cod-emitente  = docum-est.cod-emitente
            and docum-est-cex.nat-operacao  = docum-est.nat-operacao no-lock:

            IF docum-est-cex.cod-emitente-desp = docum-est.cod-emitente THEN DO:
                for first desp-imp fields(inc-val-duplic)
                    where desp-imp.cod-desp = docum-est-cex.cod-desp no-lock:
                    if desp-imp.inc-val-duplic and
                    docum-est-cex.cod-desp <> i-desp-ii-i50 then do:
                        assign de-tot-dup = de-tot-dup + round(docum-est-cex.val-desp,2).
                    END.
                END.
            END.
        END.
    END.
&ENDIF

/*
** Acrescenta as duplicatas de despesas de importacao
*/
FOR FIRST embarque-imp NO-LOCK
    WHERE embarque-imp.embarque    = TRIM(SUBSTRING(docum-est.char-1,1,20))
      AND embarque-imp.cod-estabel = docum-est.cod-estabel:

    &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
       IF embarque-imp.idi-natur-cambial = 2 AND de-tot-dup = 0 THEN
           ASSIGN de-tot-dup = docum-est.valor-mercad.
    &ELSE
        IF embarque-imp.int-1 = 2 AND de-tot-dup = 0 THEN
            ASSIGN de-tot-dup = docum-est.valor-mercad.
    &ENDIF
END.

for each dupli-apagar-cex fields(vl-a-pagar)
    where dupli-apagar-cex.serie-docto   = docum-est.serie-docto
    &if defined(bf-mat-comex) &then
      and dupli-apagar-cex.nro-docto = string(docum-est.nro-docto)
    &else
      and dupli-apagar-cex.nro-docto = docum-est.nro-docto
    &endif
      and dupli-apagar-cex.cod-emitente  = docum-est.cod-emitente
      and dupli-apagar-cex.nat-operacao  = docum-est.nat-operacao no-lock:

    assign de-tot-dup = de-tot-dup + dupli-apagar-cex.vl-a-pagar.
end.

for first param-imp fields(char-1 inc-icms-tot-nf &if "{&bf_cex_versao_ems}" >= "2.062" &then
                                                      &if "{&bf_dis_versao_ems}" >= "2.04" &then
                                                          dat-pis-recup dat-cofins-recup
                                                      &endif
                                                  &else
                                                      &if "{&bf_dis_versao_ems}" > "2.05" &then
                                                          dat-pis-recup dat-cofins-recup
                                                      &endif
                                                  &endif
                                                  cdn-despes-tax-estatis)
    where param-imp.cod-estabel = docum-est.cod-estabel no-lock:
end.

{cdp/cd4300.i4 "yes" param-imp.char-1}
{cxbo/bocx250.i51 "yes"}

/* Determina rateio com nota de importacao referenciada ANTES do loop de despesas,
   para nao somar despesas em dobro no total das duplicatas (mesma regra do PIS/COFINS) */
{rep/re1001a.i51 "yes"}
FIND FIRST natur-oper NO-LOCK
    WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.
IF AVAIL natur-oper AND natur-oper.nota-rateio AND c-embarque <> "":U THEN
    ASSIGN l-imp-rateio = YES.

/*
** Acrescenta o valor do imposto de importacao e das despesas que nao geram duplicatas
*/
for each docum-est-cex fields(cod-desp val-desp)
    where docum-est-cex.serie-docto   = docum-est.serie-docto
    &if defined(bf-mat-comex) &then
      and docum-est-cex.nro-docto = string(docum-est.nro-docto)
    &else
      and docum-est-cex.nro-docto = docum-est.nro-docto
    &endif
      and docum-est-cex.cod-emitente  = docum-est.cod-emitente
      and docum-est-cex.nat-operacao  = docum-est.nat-operacao no-lock:

    for first desp-imp fields(inc-val-duplic char-1)
       where desp-imp.cod-desp = docum-est-cex.cod-desp no-lock: END.

    IF l-rec-dif-dp-nf-imp = NO THEN DO: /*Informaá∆o vindo a epc eshu003*/
        IF i-pais-impto-usuario = 1 THEN DO:
            if i-desp-ii-i50 <> 0 and (docum-est-cex.cod-desp = i-desp-ii-i50) then
               assign de-tot-dup = de-tot-dup + round(docum-est-cex.val-desp,2).
        END.
        ELSE DO:

            IF docum-est.idi-nf-simples-remes = 1 /* Nota M∆e */ THEN DO:
                /*Para nota m∆e, n∆o s∆o geradas as duplicatas de II e Taxa de Estat°stica*/

                IF (i-desp-ii-i50 <> 0 and docum-est-cex.cod-desp = i-desp-ii-i50) OR
                   (i-pais-impto-usuario = 2 /* Argentina */ AND param-imp.cdn-despes-tax-estatis <> 0 AND docum-est-cex.cod-desp = param-imp.cdn-despes-tax-estatis) THEN
                    assign de-tot-dup = de-tot-dup + round(docum-est-cex.val-desp,2).

            END.
            ELSE DO:
                /*Para o internacional s¢ soma o II no valor das duplicatas se n∆o incide no valor da duplicata*/
                IF i-desp-ii-i50 <> 0 and (docum-est-cex.cod-desp = i-desp-ii-i50) AND
                   NOT desp-imp.inc-val-duplic  THEN
                    assign de-tot-dup = de-tot-dup + round(docum-est-cex.val-desp,2).
            END.
        END.
    END.

    if not desp-imp.inc-val-duplic and
       docum-est-cex.cod-desp <> i-desp-ii-i50 and
       not l-imp-rateio and
       (i-pais-impto-usuario = 1 OR substring(desp-imp.char-1,45,1) <> "Y":U) THEN DO:
       assign de-tot-dup = de-tot-dup + round(docum-est-cex.val-desp,2).
    end.

    /* Diminuir o valor da despesa que n∆o atualiza estoque e gerou duplicata */
    IF i-pais-impto-usuario <> 1 AND
       desp-imp.inc-val-duplic   AND
       substring(desp-imp.char-1,45,1) = "Y":U THEN DO:
        assign de-tot-dup = de-tot-dup - round(docum-est-cex.val-desp,2).
    END.

end.

/*
** Tratamento IPI
*/
&IF DEFINED(bf-mat-comex) &THEN
    assign de-tot-dup = de-tot-dup + docum-est.ipi-deb-cre.

&ELSE
    &if "{&bf_mat_versao_ems}":U >= "2.04":U &then
        find first natur-oper
            where natur-oper.nat-operacao = docum-est.nat-operacao
            and   natur-oper.nota-rateio  = no no-lock no-error.
        if  avail natur-oper
        and not l-rec-dif-dp-nf-imp then
            assign de-tot-dup = de-tot-dup + docum-est.ipi-deb-cre.
    &else
        if  not l-rec-dif-dp-nf-imp then
            assign de-tot-dup = de-tot-dup + docum-est.ipi-deb-cre.
    &endif
&ENDIF

for first estabelec fields (pais)
    where estabelec.cod-estabel = docum-est.cod-estabel no-lock:
end.

for first emitente fields (pais)
    where emitente.cod-emitente = docum-est.cod-emitente no-lock:
end.

/*
** Tratamento ICMS
*/

// Verifica se o ICMS Ç Diferido, e se o estabelecimento Ç do Cear† (somente no CE dever† mudar o valor total da nota)
ASSIGN l-icms-diferido = NO.
FIND FIRST natur-oper NO-LOCK
    WHERE  natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.
IF  AVAIL  natur-oper AND natur-oper.ind-it-sub-dif = ? THEN DO:
    FIND FIRST estabelec NO-LOCK
        WHERE  estabelec.cod-estabel = docum-est.cod-estabel NO-ERROR.
    IF  AVAIL  estabelec AND estabelec.estado = "CE" THEN
        ASSIGN l-icms-diferido = YES.
END.


/* ICMS Desonerado n∆o soma no total da nota */
ASSIGN de-icms-deson = 0.
FOR EACH ct-trib-item-doc-est NO-LOCK
    WHERE ct-trib-item-doc-est.cdn-emitente     = docum-est.cod-emitente
      AND ct-trib-item-doc-est.cod-ser-docto    = docum-est.serie-docto
      AND ct-trib-item-doc-est.cod-docto        = docum-est.nro-docto
      AND ct-trib-item-doc-est.cod-natur-operac = docum-est.nat-operacao:
      IF ct-trib-item-doc-est.cod-tip-trib     = "icms desonerado":U THEN
         ASSIGN de-icms-deson = de-icms-deson + ct-trib-item-doc-est.val-trib.
END.

if  NOT l-rec-dif-dp-nf-imp then do: /*Informaá∆o vindo a epc eshu003*/
    IF AVAIL param-imp AND
       param-imp.inc-icms-tot-nf AND
       estabelec.pais <> emitente.pais AND
       AVAIL natur-oper THEN DO:
       ASSIGN de-tot-dup = de-tot-dup + docum-est.icm-deb-cre.
       IF de-icms-deson > 0 THEN /* n∆o soma ICMS desoneraá∆o */
          ASSIGN de-tot-dup = de-tot-dup - de-icms-deson.
    END.
    ELSE DO:
       FIND FIRST bNatur-oper NO-LOCK
            WHERE bNatur-oper.nat-operacao = docum-est.nat-operacao
               AND bNatur-oper.nota-rateio  = YES NO-ERROR.
       IF  AVAIL bNatur-oper
           &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
           AND bNatur-oper.log-icms-despes-import-nfr
           &ELSE
           AND SUBSTR(bNatur-oper.char-2,146,1) = "1"
           &ENDIF THEN
            ASSIGN de-tot-dup = de-tot-dup + docum-est.icm-deb-cre.
    END.
end.
else do:
    if  AVAIL param-imp AND
        (NOT param-imp.inc-icms-tot-nf OR l-icms-diferido) AND  // Quando o ICMS Ç diferido, n∆o deve ir para o total da nota
        estabelec.pais <> emitente.pais THEN
        assign de-tot-dup = de-tot-dup - docum-est.icm-deb-cre.

end.

/*
** Ajuste PIS/COFINS
*/

/* Verifica se a nota est† dentro da vigància do imposto */

&if "{&bf_cex_versao_ems}" >= "2.062" &then /*s¢ comex*/
    &if "{&bf_dis_versao_ems}" >= "2.04" &then
        ASSIGN da-inicio-pis    = param-imp.dat-pis-recup
               da-inicio-cofins = param-imp.dat-cofins-recup.
    &endif
&else
    &if "{&bf_dis_versao_ems}" > "2.05" &then
        ASSIGN da-inicio-pis    = param-imp.dat-pis-recup
               da-inicio-cofins = param-imp.dat-cofins-recup.

    &else
        ASSIGN da-inicio-pis    = DATE(SUBSTRING(param-imp.char-1,72,8))  /* data de inicio da cobranca do pis */
               da-inicio-cofins = DATE(SUBSTRING(param-imp.char-1,80,8)). /* data de inicio da cobranca do cofins */
    &endif
&endif

IF docum-est.dt-emissao < da-inicio-pis AND
   docum-est.dt-emissao < da-inicio-cofins THEN
    LEAVE.

/* Verifica se a nota Ç de rateio com nota importaá∆o referenciada*/
{rep/re1001a.i51 "yes"}
IF natur-oper.nota-rateio AND
   c-embarque <> "":U THEN
   ASSIGN l-imp-rateio = YES.

/* N∆o soma o valor de PIS/ COFINS em notas de rateio com nota importaá∆o referenciada*/
IF NOT l-imp-rateio  THEN DO:
    /* Calcula o valor do PIS/COFINS na nota */
    FOR EACH item-doc-est OF docum-est NO-LOCK:
    &if defined(bf-mat-comex) &then
        ASSIGN de-valor-pis    = de-valor-pis    + DECIMAL(SUBSTRING(item-doc-est.char-1,120,13))   /* valor do pis    */
            de-valor-cofins = de-valor-cofins + DECIMAL(SUBSTRING(item-doc-est.char-1,152,13)). /* valor do cofins */
    &else
        &IF "{&bf_dis_versao_ems}":U >= "2.06":U &THEN
            ASSIGN de-valor-pis    = de-valor-pis    + item-doc-est.valor-pis
                de-valor-cofins = de-valor-cofins + item-doc-est.val-cofins.
        &ELSE
            ASSIGN de-valor-pis    = de-valor-pis    + DECIMAL(SUBSTRING(item-doc-est.char-2,41,14))   /* valor do pis    */
                de-valor-cofins = de-valor-cofins + DECIMAL(SUBSTRING(item-doc-est.char-2,103,14)). /* valor do cofins */
        &ENDIF
    &endif
    END.

    IF docum-est.dt-emissao >= da-inicio-pis
    &if "{&bf_mat_versao_ems}":U >= "2.04":U &then AND AVAIL natur-oper &ENDIF THEN
        if not l-rec-dif-dp-nf-imp then
            ASSIGN de-tot-dup = de-tot-dup + de-valor-pis.

    IF docum-est.dt-emissao >= da-inicio-cofins
    &if "{&bf_mat_versao_ems}":U >= "2.04":U &then AND AVAIL natur-oper &ENDIF THEN
        if not l-rec-dif-dp-nf-imp then
            ASSIGN de-tot-dup = de-tot-dup + de-valor-cofins.
END.

/* Inicio Ponto UPC */

&if defined(bf-mat-comex) &then
&else
    FOR EACH   tt-epc:
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent       = '"RecalculaTotalDuplicata"'
                         &CodParameter   = '"docum-est rowid"'
                         &ValueParameter = string(rowid(docum-est))}.
    {include/i-epc200.i2 &CodEvent       = '"RecalculaTotalDuplicata"'
                         &CodParameter   = '"de-tot-dup"'
                         &ValueParameter = string(de-tot-dup)}.
    {include/i-epc201.i "RecalculaTotalDuplicata"}

    FIND  tt-epc WHERE
          tt-epc.cod-event     = "RetornaTotalDuplicata" AND
          tt-epc.cod-parameter = "de-tot-dup" NO-ERROR.
    IF AVAIL tt-epc THEN
        ASSIGN de-tot-dup = DEC(tt-epc.val-parameter).
&endif

/* Fim Ponto UPC */

/* IM9013.I */
