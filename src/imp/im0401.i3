if  {1}.ipi-deb-cre <> 0
and {1}.dt-venc-ipi <> ? then
    assign da-ven-ipi = {1}.dt-venc-ipi.
if  {1}.icm-deb-cre <> 0
and {1}.dt-venc-icm <> ? then
    assign da-ven-icm = {1}.dt-venc-icm.
if  {1}.iss-deb-cre <> 0 then
    assign da-ven-iss = if {1}.dt-venc-iss <> ?
                           then {1}.dt-venc-iss
                           else {1}.dt-trans.

find first item-doc-est
    {cdp/cd8900.i item-doc-est {1}} no-lock no-error.
if  avail item-doc-est
and item-doc-est.num-pedido <> 0 then
    assign l-compras = yes.

find param-re where
   param-re.usuario = {1}.usuario no-lock no-error.
if avail param-re then do:
   assign l-of-online = param-re.of-on-line
          l-ap-online = param-re.ap-on-line.       
end.
assign l-cr-online = {1}.cr-atual.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {ininc/i03in218.i 04 {1}.esp-docto}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-esp-docto = RETURN-VALUE.
&else
    ASSIGN c-esp-docto = {ininc/i03in218.i 04 {1}.esp-docto}.
&endif

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao002 = {ininc/i03in090.i 04 {1}.cod-observa}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-observa   = RETURN-VALUE.
&else
    ASSIGN c-observa   = {ininc/i03in090.i 04 {1}.cod-observa}.
&endif
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao003 = {adinc/i01ad268.i 04 {1}.via-transp}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-transp    = RETURN-VALUE.
&else
    ASSIGN c-transp    = {adinc/i01ad268.i 04 {1}.via-transp}.
&endif

ASSIGN l-docto-imp = ( {1}.origem = "I":U ).

/* Totalizando PIS / COFINS */
ASSIGN de-base-pis    = 0
       de-pis         = 0
       de-base-cofins = 0
       de-cofins      = 0.

FOR EACH   item-doc-est
    FIELDS (base-pis valor-pis val-base-calc-cofins val-cofins)
    {cdp/cd8900.i item-doc-est {1}} NO-LOCK:

    ASSIGN de-base-pis    = de-base-pis    + item-doc-est.base-pis
           de-pis         = de-pis         + item-doc-est.valor-pis
           de-base-cofins = de-base-cofins + item-doc-est.val-base-calc-cofins
           de-cofins      = de-cofins      + item-doc-est.val-cofins.
END.

ASSIGN l-memorando-exportacao = {1}.log-memorando.

    find estabelec where
             estabelec.cod-estabel = {1}.cod-estabel no-lock no-error.
        assign i-empresa = estabelec.ep-codigo when avail estabelec. 		

/* Retorna formato da conta contabil */
run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* PLANO CONTAS */
                                                   input  {1}.dt-trans, /* DATA DE TRANSACAO */
                                                   output c-formato-conta,    /* FORMATO CONTA */
                                                   output table tt_log_erro). /* ERROS */
/* Retorna formato do centro de custo */
run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* PLANO CCUSTO */
                                               input  {1}.dt-trans, /* DATA DE TRANSACAO */
                                               output c-formato-ccusto,   /* FORMATO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

/* Formatando conta e centro de custo */
if c-formato-conta <> "" then
    assign c-ct-transit = string({1}.ct-transit, c-formato-conta).
else
    assign c-ct-transit = {1}.ct-transit.
if c-formato-ccusto <> "" then
    assign c-sc-transit = string({1}.sc-transit, c-formato-ccusto).
else
    assign c-sc-transit = {1}.sc-transit.

/*====================== Impostos Reforma Tribut ria ============================*/
if l-spp-NT2024002 then do:
    ASSIGN de-base-cbs          = 0
           de-base-ibs-uf       = 0
           de-base-ibs-mun      = 0
           de-valor-cbs         = 0
           de-valor-ibs-uf      = 0
           de-valor-ibs-mun     = 0
           de-aliq-efet-cbs     = 0
           de-aliq-efet-ibs-uf  = 0
           de-aliq-efet-ibs-mun = 0
           de-base-cbs-reg      = 0
           de-base-ibs-uf-reg   = 0
           de-base-ibs-mun-reg  = 0
           de-valor-cbs-reg     = 0
           de-valor-ibs-uf-reg  = 0
           de-valor-ibs-mun-reg = 0
           de-aliq-reg-cbs      = 0
           de-aliq-reg-ibs-uf   = 0
           de-aliq-reg-ibs-mun  = 0
           de-base-is           = 0
           de-valor-is          = 0
           de-aliq-efet-is      = 0.
           
    FOR EACH  docum-est-tribut NO-LOCK
        WHERE docum-est-tribut.cod-serie-docto  = {1}.serie-docto
        AND   docum-est-tribut.cod-num-docto    = {1}.nro-docto
        AND   docum-est-tribut.cdn-emitente     = {1}.cod-emitente
        AND   docum-est-tribut.cod-natur-operac = {1}.nat-operacao:

        IF (docum-est-tribut.nom-trib  <> "CBS":U
        AND docum-est-tribut.nom-trib  <> "IBS UF":U
        AND docum-est-tribut.nom-trib  <> "IBS MUN":U
        AND docum-est-tribut.nom-trib  <> "IS":U)
        OR (docum-est-tribut.cod-campo <> "BASE":U
        AND docum-est-tribut.cod-campo <> "VALOR":U) THEN NEXT.

        CASE docum-est-tribut.cod-campo:
            WHEN "BASE":U THEN DO:
                IF  docum-est-tribut.nom-trib = "CBS":U THEN
                    ASSIGN de-base-cbs = DEC(docum-est-tribut.cod-conteudo).
                IF  docum-est-tribut.nom-trib = "IBS UF":U THEN
                    ASSIGN de-base-ibs-uf = DEC(docum-est-tribut.cod-conteudo).
                IF  docum-est-tribut.nom-trib = "IBS MUN":U THEN
                    ASSIGN de-base-ibs-mun = DEC(docum-est-tribut.cod-conteudo).
                IF  docum-est-tribut.nom-trib = "IS":U THEN
                    ASSIGN de-base-is = DEC(docum-est-tribut.cod-conteudo).
            END.
            WHEN "VALOR":U THEN DO:
                IF  docum-est-tribut.nom-trib = "CBS":U THEN
                    ASSIGN de-valor-cbs = DEC(docum-est-tribut.cod-conteudo).
                IF  docum-est-tribut.nom-trib = "IBS UF":U THEN
                    ASSIGN de-valor-ibs-uf = DEC(docum-est-tribut.cod-conteudo).
                IF  docum-est-tribut.nom-trib = "IBS MUN":U THEN
                    ASSIGN de-valor-ibs-mun = DEC(docum-est-tribut.cod-conteudo).
                IF  docum-est-tribut.nom-trib = "IS":U THEN
                    ASSIGN de-valor-is = DEC(docum-est-tribut.cod-conteudo).
            END.
        END CASE.
    END.
    
    FOR EACH  item-doc-est-tribut NO-LOCK
        WHERE item-doc-est-tribut.cod-serie-docto  = {1}.serie-docto
        AND   item-doc-est-tribut.cod-num-docto    = {1}.nro-docto
        AND   item-doc-est-tribut.cdn-emitente     = {1}.cod-emitente
        AND   item-doc-est-tribut.cod-natur-operac = {1}.nat-operacao:

        IF (item-doc-est-tribut.nom-trib <> "CBS":U
        AND item-doc-est-tribut.nom-trib <> "IBS UF":U
        AND item-doc-est-tribut.nom-trib <> "IBS MUN":U)
        OR (item-doc-est-tribut.cod-campo <> "BASE REG":U
        AND item-doc-est-tribut.cod-campo <> "VALOR REG":U) THEN NEXT.

        CASE item-doc-est-tribut.cod-campo:
            WHEN "BASE REG":U THEN DO:
                IF item-doc-est-tribut.nom-trib = "CBS":U THEN
                    ASSIGN de-base-cbs-reg = de-base-cbs-reg + DEC(item-doc-est-tribut.cod-conteudo).
                IF item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                    ASSIGN de-base-ibs-uf-reg = de-base-ibs-uf-reg + DEC(item-doc-est-tribut.cod-conteudo).
                IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                    ASSIGN de-base-ibs-mun-reg = de-base-ibs-mun-reg + DEC(item-doc-est-tribut.cod-conteudo).
            END.
            WHEN "VALOR REG":U THEN DO:
                IF item-doc-est-tribut.nom-trib = "CBS":U THEN
                    ASSIGN de-valor-cbs-reg = de-valor-cbs-reg + DEC(item-doc-est-tribut.cod-conteudo).
                IF item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                    ASSIGN de-valor-ibs-uf-reg = de-valor-ibs-uf-reg + DEC(item-doc-est-tribut.cod-conteudo).
                IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                    ASSIGN de-valor-ibs-mun-reg = de-valor-ibs-mun-reg + DEC(item-doc-est-tribut.cod-conteudo).
            END.
        END CASE.
    END.
end.
/*================================================================================*/
