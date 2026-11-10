/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMAPI014 2.00.00.003 } /*** "010003" 21/01/2026 15:58:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IMAPI014 MIM}
&ENDIF

/********************************************************************************
** IMAPI014.P - Objetivo: Calcular o valor das despesas do IBS UF.
** 
** input  p-h-table    - handle da cotacao-item-cex ou tt-ordens-totais(im0091.i1) ou tt-parametros-imp
** input  p-cod-desp   - codigo da despesa que esta sendo calculada
** input  p-cod-agrup  - codigo do agrupamento de despesas (so recebe valor quando for im0015)
** input  p-mapa-ordem - codigo do mapa de despesas (so recebe valor quando for im0015)
** output p-valor-desp - retorna o valor da despesa
********************************************************************************/

{imp/im0091.i}   /* defini‡Æo temp-table para rateio de despesas */
{utp/ut-glob.i}  /* variaveis globais do sistema */
{inbo/boin082.i tt-cotacao-item-aux}
{imp/imapi017.i}  /*Defini»ao das temp-tables para configurador de tributos*/

DEF VAR h-numero-ordem      AS HANDLE               NO-UNDO.
DEF VAR h-seq-cotac         AS HANDLE               NO-UNDO.
DEF VAR h-cod-emitente      AS HANDLE               NO-UNDO.
DEF VAR h-qtd-do-forn       AS HANDLE               NO-UNDO.
DEF VAR h-preco-unit        AS HANDLE               NO-UNDO.
DEF VAR h-preco-total       AS HANDLE               NO-UNDO.
DEF VAR h-base-ipi          AS HANDLE               NO-UNDO.
DEF VAR h-base-icms         AS HANDLE               NO-UNDO.
def var h-mapa-cotacao      as handle               no-undo.
DEF VAR h-bodi613calc2      AS HANDLE               NO-UNDO.
DEF VAR h-bodi317im2bra     AS HANDLE               NO-UNDO.
DEF VAR h-boin082ca         AS HANDLE               NO-UNDO.
DEF VAR h-imapi017          AS HANDLE               NO-UNDO.
DEF VAR de-valor-desp       LIKE desp-imp.val-desp  NO-UNDO.
DEF VAR de-vl-base-ibsuf    LIKE desp-imp.val-desp  NO-UNDO.
DEF VAR de-valor-conv       AS DEC                  NO-UNDO.
DEF VAR deIndice            AS DEC                  NO-UNDO.
DEF VAR de-conver           AS DECIMAL              NO-UNDO.
DEF VAR de-qtd-forn         AS DECIMAL              NO-UNDO.
DEF VAR de-val-merc         AS DEC                  NO-UNDO.
DEF VAR de-qtd-do-forn-tot  AS DEC                  NO-UNDO.
DEF VAR l-procedimento-ok   AS LOGICAL              NO-UNDO.

DEF BUFFER b-desp-imp         FOR desp-imp.
DEF BUFFER b-cotacao-item-cex FOR cotacao-item-cex.

DEF INPUT  PARAM p-h-table     AS HANDLE                  NO-UNDO.
DEF INPUT  PARAM p-cod-desp    LIKE desp-imp.cod-desp     NO-UNDO.
DEF INPUT  PARAM p-cod-agrup   LIKE cot-ordem.cod-agrup   NO-UNDO.
DEF INPUT  PARAM p-mapa-ordem  LIKE cot-ordem.mapa-ordem  NO-UNDO.
DEF OUTPUT PARAM p-valor-desp  LIKE desp-imp.val-desp     NO-UNDO.


IF p-h-table:NAME = "cotacao-item-cex":U THEN DO:
    FIND FIRST b-cotacao-item-cex 
         WHERE ROWID(b-cotacao-item-cex) = p-h-table:ROWID NO-LOCK NO-ERROR.
    IF NOT AVAIL b-cotacao-item-cex THEN
        RETURN "NOK":U.
END.
ELSE 
    IF p-h-table:NAME = "tt-ordens-totais":U THEN
        ASSIGN h-numero-ordem = p-h-table:BUFFER-FIELD("numero-ordem":U)
               h-seq-cotac    = p-h-table:BUFFER-FIELD("seq-cotac":U)
               h-qtd-do-forn  = p-h-table:BUFFER-FIELD("qtd-do-forn":U)
               h-preco-unit   = p-h-table:BUFFER-FIELD("preco-unit":U)
               h-preco-total  = p-h-table:BUFFER-FIELD("preco-total":U)
               h-base-ipi     = p-h-table:BUFFER-FIELD("base-ipi":U)
               h-base-icms    = p-h-table:BUFFER-FIELD("base-icms":U)
               h-cod-emitente = p-h-table:BUFFER-FIELD("cod-emitente":U).

    ELSE 
        IF p-h-table:NAME = "tt-parametros-imp":U THEN
             ASSIGN h-numero-ordem = p-h-table:BUFFER-FIELD("numero-ordem":U)
                    h-seq-cotac    = p-h-table:BUFFER-FIELD("seq-cotac":U)
                    h-mapa-cotacao = p-h-table:BUFFER-FIELD("mapa-cotacao":U)
                    h-cod-emitente = p-h-table:BUFFER-FIELD("cod-emitente":U).
        ELSE
            RETURN "NOK":U.

IF p-h-table:NAME = "cotacao-item-cex":U THEN
    FIND FIRST ordem-compra 
         WHERE ordem-compra.numero-ordem = b-cotacao-item-cex.numero-ordem NO-LOCK NO-ERROR.
ELSE
    FIND FIRST ordem-compra
         WHERE ordem-compra.numero-ordem = h-numero-ordem:BUFFER-VALUE NO-LOCK NO-ERROR.

IF AVAIL ordem-compra THEN      
    FIND FIRST ITEM WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

IF AVAIL ordem-compra THEN DO:      
    FIND FIRST param-imp
         WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
    FIND FIRST param-imp-trib
         WHERE param-imp-trib.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
END.

/*--- so calcula de for despesa do IBS UF ---*/
IF AVAIL param-imp-trib THEN
    IF  p-cod-desp <> param-imp-trib.cdn-despes-impto-IBSUF THEN
        RETURN "NOK":U.

IF AVAIL param-imp-trib THEN     
    FIND FIRST natur-oper 
         WHERE natur-oper.nat-operacao = param-imp-trib.cod-natur-operac-novo-impto NO-LOCK NO-ERROR.

IF p-h-table:NAME = "cotacao-item-cex":U THEN
    FIND FIRST emitente 
         WHERE emitente.cod-emitente = b-cotacao-item-cex.cod-emitente NO-LOCK NO-ERROR.
ELSE
    FIND FIRST emitente 
         WHERE emitente.cod-emitente = h-cod-emitente:BUFFER-VALUE NO-LOCK NO-ERROR.
 
IF AVAIL ordem-compra THEN      
    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

IF AVAIL ordem-compra THEN DO:
    IF  p-h-table:NAME = "cotacao-item-cex":U THEN
        FIND FIRST cotacao-item
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
               AND cotacao-item.cod-emitente = b-cotacao-item-cex.cod-emitente
               AND cotacao-item.it-codigo    = ordem-compra.it-codigo
               AND cotacao-item.seq-cotac    = b-cotacao-item-cex.seq-cotac NO-LOCK NO-ERROR.
 
    ELSE
        FIND FIRST cotacao-item
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
               AND cotacao-item.cod-emitente = h-cod-emitente:BUFFER-VALUE
               AND cotacao-item.it-codigo    = ordem-compra.it-codigo
               AND cotacao-item.seq-cotac    = h-seq-cotac:BUFFER-VALUE NO-LOCK NO-ERROR.
END.
 
IF AVAIL ordem-compra THEN
    FIND FIRST item-mat 
         WHERE item-mat.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

IF p-h-table:NAME = "cotacao-item-cex":U THEN
    FIND FIRST desp-imp 
         WHERE desp-imp.cod-desp = b-cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.
ELSE
    FIND FIRST desp-imp
         WHERE desp-imp.cod-desp = p-cod-desp NO-LOCK NO-ERROR.

/*--- Verifica integridade da base ---*/
IF  NOT AVAIL ITEM
OR  NOT AVAIL ordem-compra
OR  NOT AVAIL param-imp
OR  NOT AVAIL param-imp-trib
OR  NOT AVAIL natur-oper
OR  NOT AVAIL emitente
OR  NOT AVAIL estabelec
OR  NOT AVAIL cotacao-item THEN
    NEXT.

/*--- Determina o indice que sera utilizado para atualizar o 
   preco-unit com base no pre-unit-for ---*/
EMPTY TEMP-TABLE tt-cotacao-item-aux.
CREATE tt-cotacao-item-aux.
BUFFER-COPY cotacao-item TO tt-cotacao-item-aux.
IF NOT VALID-HANDLE (h-boin082ca) THEN
    RUN inbo/boin082ca.p PERSISTENT SET h-boin082ca.
RUN calcIndiceCotacaoItem IN h-boin082ca (INPUT  TABLE tt-cotacao-item-aux,
                                          INPUT  cotacao-item.it-codigo,
                                          OUTPUT deIndice).
IF VALID-HANDLE (h-boin082ca) THEN DO:
    DELETE PROCEDURE h-boin082ca.
    ASSIGN h-boin082ca = ?.
END.

/*--------------------------------
-- Calcula valor base do IBS UF --
---------------------------------*/
IF p-h-table:NAME = "tt-ordens-totais":U THEN DO:
    
    /*--- encontra o valor da mercadoria ---*/
    ASSIGN de-val-merc = (cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi).
    
    ASSIGN de-qtd-do-forn-tot = 0.
    FOR EACH prazo-compra FIELDS(qtd-do-forn quantidade)
       WHERE prazo-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK:

        IF prazo-compra.qtd-do-forn = 0 THEN DO:
            FIND FIRST item-fornec 
                 WHERE item-fornec.it-codigo    = cotacao-item.it-codigo 
                   AND item-fornec.cod-emitente = cotacao-item.cod-emitente NO-LOCK NO-ERROR.

            ASSIGN de-conver   = (1 / (EXP(10, item-fornec.num-casa-dec))) * item-fornec.fator-conver
                   de-qtd-forn = prazo-compra.quantidade * de-conver.

            ASSIGN de-qtd-do-forn-tot = de-qtd-do-forn-tot + de-qtd-forn.
        END.
        ELSE
            ASSIGN de-qtd-do-forn-tot = de-qtd-do-forn-tot + prazo-compra.qtd-do-forn.
    END.

    ASSIGN de-val-merc = de-val-merc * de-qtd-do-forn-tot.

    /*--- converte para a moeda corrente ---*/
    IF cotacao-item.mo-codigo <> 0 THEN
        RUN cdp/cd0812.p (cotacao-item.mo-codigo,
                          0,
                          de-val-merc,
                          TODAY,
                          OUTPUT de-val-merc).            

    /*--- acumula o valor das despesas que incidem no tributo ---*/
    FOR EACH desp-cot-ordem NO-LOCK
       WHERE desp-cot-ordem.cod-agrup  = p-cod-agrup
         AND desp-cot-ordem.mapa-ordem = p-mapa-ordem:

        FIND FIRST b-desp-imp 
             WHERE b-desp-imp.cod-desp = desp-cot-ordem.cod-desp NO-LOCK NO-ERROR.
        FIND FIRST desp-imp-trib 
             WHERE desp-imp-trib.cod-desp = desp-cot-ordem.cod-desp NO-LOCK NO-ERROR.

        IF AVAIL desp-imp-trib
        AND desp-imp-trib.log-incide-base-IBSUF
        AND AVAIL b-desp-imp
        AND (   b-desp-imp.inc-val-embal       <> NO
             OR b-desp-imp.inc-val-frete       <> NO 
             OR b-desp-imp.inc-val-outras-desp <> NO 
             OR b-desp-imp.inc-val-seguro      <> NO) THEN DO:

            /*--- converte para a moeda corrente ---*/
            IF desp-cot-ordem.mo-codigo <> 0 THEN
                RUN cdp/cd0812.p (INPUT desp-cot-ordem.mo-codigo,
                                  INPUT 0,
                                  INPUT desp-cot-ordem.val-desp,
                                  INPUT TODAY,
                                  OUTPUT de-valor-conv).
            ELSE
                ASSIGN de-valor-conv = desp-cot-ordem.val-desp.
            
            ASSIGN de-vl-base-ibsuf = de-vl-base-ibsuf + de-valor-conv.
        END.
    END.
    ASSIGN de-vl-base-ibsuf = de-vl-base-ibsuf + de-val-merc.
END.
ELSE DO:
    /*--- encontra o valor da mercadoria ---*/
    ASSIGN de-val-merc = ( (cotacao-item.pre-unit-for * deIndice) * 100)
                         / (100 + cotacao-item.aliquota-ipi).
    
    /*--- converte para a moeda corrente ---*/
    IF  cotacao-item.mo-codigo <> 0 THEN
        RUN cdp/cd0812.p (cotacao-item.mo-codigo,
                          0,
                          de-val-merc,
                          TODAY,
                          OUTPUT de-val-merc).

    IF p-h-table:NAME = "tt-parametros-imp" THEN DO:
        /*--- acumula o valor das despesas da cota‡Æo que incidem no tributo ---*/
        FOR EACH cotacao-item-cex NO-LOCK
           WHERE cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
             AND cotacao-item-cex.cod-emitente = h-cod-emitente:BUFFER-VALUE
             AND cotacao-item-cex.it-codigo    = ordem-compra.it-codigo
             AND cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
             AND cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao
             AND cotacao-item-cex.mapa-cotacao = h-mapa-cotacao:BUFFER-VALUE:
              
            FIND FIRST b-desp-imp 
                 WHERE b-desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.
            FIND FIRST desp-imp-trib 
                 WHERE desp-imp-trib.cod-desp = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.

            IF AVAIL desp-imp-trib
            AND desp-imp-trib.log-incide-base-IBSUF
            AND AVAIL b-desp-imp
            AND (   b-desp-imp.inc-val-embal       <> NO
                 OR b-desp-imp.inc-val-frete       <> NO 
                 OR b-desp-imp.inc-val-outras-desp <> NO 
                 OR b-desp-imp.inc-val-seguro      <> NO) THEN DO:

                 /*--- converte para a moeda corrente ---*/
                 IF cotacao-item-cex.mo-codigo <> 0 THEN
                     RUN cdp/cd0812.p (INPUT cotacao-item-cex.mo-codigo,
                                       INPUT 0,
                                       INPUT cotacao-item-cex.val-desp,
                                       INPUT TODAY,
                                       OUTPUT de-valor-desp).
                 ELSE
                     ASSIGN de-valor-desp = cotacao-item-cex.val-desp.

                 ASSIGN de-vl-base-ibsuf = de-vl-base-ibsuf + de-valor-desp.

            END.
        END.
        ASSIGN de-vl-base-ibsuf = de-vl-base-ibsuf + de-val-merc.
    END.
    ELSE DO:
        /*--- acumula o valor das despesas da cota‡Æo que incidem no tributo ---*/
        FOR EACH cotacao-item-cex NO-LOCK
           WHERE cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
             AND cotacao-item-cex.cod-emitente = b-cotacao-item-cex.cod-emitente
             AND cotacao-item-cex.it-codigo    = ordem-compra.it-codigo
             AND cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
             AND cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao
             AND cotacao-item-cex.mapa-cotacao = b-cotacao-item-cex.mapa-cotacao:
              
            FIND FIRST b-desp-imp 
                 WHERE b-desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.
            FIND FIRST desp-imp-trib 
                 WHERE desp-imp-trib.cod-desp = cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.

            IF AVAIL desp-imp-trib
            AND desp-imp-trib.log-incide-base-IBSUF
            AND AVAIL b-desp-imp
            AND (   b-desp-imp.inc-val-embal       <> NO
                 OR b-desp-imp.inc-val-frete       <> NO 
                 OR b-desp-imp.inc-val-outras-desp <> NO 
                 OR b-desp-imp.inc-val-seguro      <> NO) THEN DO:
       
                 /*--- converte para a moeda corrente ---*/
                 IF  cotacao-item-cex.mo-codigo <> 0 THEN
                     RUN cdp/cd0812.p (INPUT cotacao-item-cex.mo-codigo,
                                       INPUT 0,
                                       INPUT cotacao-item-cex.val-desp,
                                       INPUT TODAY,
                                       OUTPUT de-valor-desp).
                 ELSE
                     ASSIGN de-valor-desp = cotacao-item-cex.val-desp.

                 ASSIGN de-vl-base-ibsuf = de-vl-base-ibsuf + de-valor-desp.

            END.
        END.
        ASSIGN de-vl-base-ibsuf = de-vl-base-ibsuf + de-val-merc.
    END.
END.

EMPTY TEMP-TABLE tb-wt-docto.
EMPTY TEMP-TABLE tb-wt-it-docto.
EMPTY TEMP-TABLE tb-wt-it-imposto.
EMPTY TEMP-TABLE tb-wt-it-impostoCBSIBS.
EMPTY TEMP-TABLE tb-ct-trib-wt-item-docto.

IF NOT VALID-HANDLE(h-bodi317im2bra) THEN
    RUN dibo/bodi317im2bra PERSISTEN SET h-bodi317im2bra.

IF NOT VALID-HANDLE(h-bodi613calc2) THEN
    RUN dibo/bodi613calc2.p PERSISTENT SET h-bodi613calc2.

IF NOT VALID-HANDLE(h-imapi017) THEN
    RUN imp/imapi017.p PERSISTENT SET h-imapi017.

CREATE tb-wt-docto.
ASSIGN tb-wt-docto.seq-wt-docto = 1
       tb-wt-docto.cod-emitente = ordem-compra.cod-emitente
       tb-wt-docto.nr-nota      = string(ordem-compra.numero-ordem)
       tb-wt-docto.serie        = "":U
       tb-wt-docto.nat-operacao = natur-oper.nat-operacao
       tb-wt-docto.cod-des-merc = IF natur-oper.consum-final THEN 2 ELSE 1
       tb-wt-docto.cod-estabel  = ordem-compra.cod-estabel
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
    
CREATE tb-wt-it-docto.
ASSIGN tb-wt-it-docto.seq-wt-docto        = 1
       tb-wt-it-docto.seq-wt-it-docto     = 1
       tb-wt-it-docto.calcula             = YES
       tb-wt-it-docto.it-codigo           = item.it-codigo WHEN AVAIL item
       tb-wt-it-docto.nat-operacao        = natur-oper.nat-operacao
       tb-wt-it-docto.nr-sequencia        = 1
       tb-wt-it-docto.numero-ordem        = ordem-compra.numero-ordem
       tb-wt-it-docto.vl-merc-liq         = de-vl-base-ibsuf
       OVERLAY(tb-wt-it-docto.char-1,1,6) = "IM7777":U.

CREATE tb-wt-it-imposto.
ASSIGN tb-wt-it-imposto.seq-wt-docto    = 1
       tb-wt-it-imposto.seq-wt-it-docto = 1.

CREATE tb-wt-it-impostoCBSIBS.
ASSIGN tb-wt-it-impostoCBSIBS.seq-wt-docto     = 1
       tb-wt-it-impostoCBSIBS.seq-wt-it-docto  = 1.

RUN piEnviaCodNBS IN h-imapi017 (INPUT TRIM(SUBSTRING(cotacao-item.char-1,101,20))).
RUN pi-sugere-aliquotas IN h-imapi017 (INPUT 2, // IBS UF
                                       INPUT tb-wt-docto.cod-estabel,
                                       INPUT tb-wt-docto.nat-operacao,
                                       INPUT tb-wt-it-docto.it-codigo,
                                       INPUT tb-wt-docto.cod-emitente,
                                       OUTPUT TABLE tt-tributo-import).
FOR EACH tt-tributo-import 
    WHERE tt-tributo-import.nom-trib = "IBS UF":U NO-LOCK:
    
    IF tt-tributo-import.cod-campo = "dPercRed":U THEN
        ASSIGN tb-wt-it-impostoCBSIBS.perc-red-ibsuf = DEC(tt-tributo-import.cod-conteudo).
        
    IF tt-tributo-import.cod-campo = "dAliq":U THEN 
        ASSIGN tb-wt-it-impostoCBSIBS.aliquota-ibsuf = DEC(tt-tributo-import.cod-conteudo).
END.

/* enviar temp-tables */
RUN enviaTbWtDocto           IN h-bodi613calc2 (INPUT TABLE tb-wt-docto).            
RUN enviaTbWtItDocto         IN h-bodi613calc2 (INPUT TABLE tb-wt-it-docto).            
RUN enviaTbWtItImposto       IN h-bodi613calc2 (INPUT TABLE tb-wt-it-imposto).
RUN enviaTbWtItImpostoCBSIBS IN h-bodi613calc2 (INPUT TABLE tb-wt-it-impostoCBSIBS).

RUN enviaTbWtDocto           IN h-bodi317im2bra (INPUT TABLE tb-wt-docto).
RUN enviaTbWtItDocto         IN h-bodi317im2bra (INPUT TABLE tb-wt-it-docto).            
RUN enviaTbWtItImposto       IN h-bodi317im2bra (INPUT TABLE tb-wt-it-imposto).            

/* posicionar registros */
RUN localizaWtDocto IN h-bodi317im2bra (INPUT 1,
                                        OUTPUT l-procedimento-ok).

RUN localizaWtDocto IN h-bodi613calc2  (INPUT 1,
                                        OUTPUT l-procedimento-ok).
IF  NOT l-procedimento-ok THEN DO:
    DELETE PROCEDURE h-bodi613calc2.
    RETURN "NOK":U.
END.

RUN pi-recebe-handle in h-bodi317im2bra (INPUT "h-bodi613calc2",
                                         INPUT h-bodi613calc2).
  
RUN trataConfigTributos in h-bodi317im2bra.

/* retornar temp-table */
RUN retornaTbCtTribWtItemDocto IN h-bodi613calc2 ( OUTPUT TABLE tb-ct-trib-wt-item-docto ).
RUN retornaTbWtItImposto       IN h-bodi613calc2 ( OUTPUT TABLE tb-wt-it-imposto ). 

IF NOT AVAIL tb-wt-docto THEN
    FOR FIRST tb-wt-docto NO-LOCK
        WHERE tb-wt-docto.seq-wt-docto = 1:
    END.
    
RUN pi-gravar-dados-cfg-trib (INPUT "", INPUT tb-wt-docto.nr-nota).

FOR EACH tb-wt-it-docto NO-LOCK
   WHERE tb-wt-it-docto.seq-wt-docto = 1,
    EACH tb-wt-it-imposto NO-LOCK
   WHERE tb-wt-it-imposto.seq-wt-docto    = tb-wt-it-docto.seq-wt-docto
     AND tb-wt-it-imposto.seq-wt-it-docto = tb-wt-it-docto.seq-wt-it-docto,
    EACH tb-ct-trib-wt-item-docto NO-LOCK
   WHERE tb-ct-trib-wt-item-docto.num-seq-wt-docto      = tb-wt-it-imposto.seq-wt-docto
     AND tb-ct-trib-wt-item-docto.num-seq-wt-item-docto = tb-wt-it-imposto.seq-wt-it-docto:

    IF tb-ct-trib-wt-item-docto.cod-tip-trib = "IBSUF":U THEN
        ASSIGN p-valor-desp = tb-ct-trib-wt-item-docto.val-trib.
END.

IF VALID-HANDLE(h-bodi317im2bra) THEN DO:
    DELETE PROCEDURE h-bodi317im2bra.
    ASSIGN h-bodi317im2bra = ?.                          
END.

IF VALID-HANDLE(h-bodi613calc2) THEN DO:
    DELETE PROCEDURE h-bodi613calc2.
    ASSIGN h-bodi613calc2 = ?.
END.

IF VALID-HANDLE(h-imapi017) THEN DO:
    DELETE PROCEDURE h-imapi017.
    ASSIGN h-imapi017 = ?.
END.

    
{inbo/boin176.m98} /*procedure pi-gravar-dados-cfg-trib*/
    
RETURN "OK":U.

