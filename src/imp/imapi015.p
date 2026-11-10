/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMAPI015 2.00.00.002 } /*** "010002" 21/01/2026 15:58:31 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IMAPI015 MIM}
&ENDIF

/********************************************************************************
** IMAPI015.P - Objetivo: Calcular o valor das despesas do CBS.
** 
** input  p-h-table      - handle da cotacao-item-cex ou tt-ordens-totais(im0091.i1) ou tt-parametros-imp
** input  p-cod-desp     - codigo da despesa que esta sendo calculada
** input  p-cod-emitente - codigo do emitente
** input  p-cod-agrup    - codigo do agrupamento de despesas (so recebe valor quando for im0015)
** input  p-mapa-ordem   - codigo do mapa de despesas (so recebe valor quando for im0015)
** output p-valor-desp   - retorna o valor da despesa
********************************************************************************/

{utp/ut-glob.i}  /* variaveis globais do sistema */
{inbo/boin082.i tt-cotacao-item-aux}
{imp/imapi017.i}  /*Defini»ao das temp-tables para configurador de tributos*/

DEF VAR h-numero-ordem      AS HANDLE               NO-UNDO.
DEF VAR h-seq-cotac         AS HANDLE               NO-UNDO.
DEF VAR h-cod-emitente      AS HANDLE               NO-UNDO.
DEF VAR h-bodi613calc2      AS HANDLE               NO-UNDO.
DEF VAR h-bodi317im2bra     AS HANDLE               NO-UNDO.
DEF VAR h-boin082ca         AS HANDLE               NO-UNDO.
DEF VAR h-imapi017          AS HANDLE               NO-UNDO.
DEF VAR de-valor-desp       LIKE desp-imp.val-desp  NO-UNDO.
DEF VAR de-vl-base-cbs      LIKE desp-imp.val-desp  NO-UNDO.
DEF VAR de-valor-conv       AS DEC                  NO-UNDO.
DEF VAR deIndice            AS DEC                  NO-UNDO.
DEF VAR de-qtd-do-forn      AS DEC                  NO-UNDO.
DEF VAR de-conver           AS DECIMAL              NO-UNDO.
DEF VAR de-qtd-forn         AS DECIMAL              NO-UNDO.
DEF VAR de-val-merc         AS DEC                  NO-UNDO.
DEF VAR de-qtd-do-forn-tot  AS DEC                  NO-UNDO.
DEF VAR de-val-acum-desp    AS DEC                  NO-UNDO.
DEF VAR de-valor-aduaneiro  AS DEC                  NO-UNDO.
DEF VAR l-procedimento-ok   AS LOGICAL              NO-UNDO.

DEF BUFFER b-desp-imp         FOR desp-imp.
DEF BUFFER b-cotacao-item-cex FOR cotacao-item-cex.

DEF INPUT  PARAM p-h-table      AS HANDLE                  NO-UNDO.
DEF INPUT  PARAM p-cod-desp     LIKE desp-imp.cod-desp     NO-UNDO.
DEF INPUT  PARAM p-cod-emitente LIKE emitente.cod-emitente NO-UNDO.
DEF INPUT  PARAM p-cod-agrup    LIKE cot-ordem.cod-agrup   NO-UNDO.
DEF INPUT  PARAM p-mapa-ordem   LIKE cot-ordem.mapa-ordem  NO-UNDO.
DEF OUTPUT PARAM p-valor-desp   LIKE desp-imp.val-desp     NO-UNDO.

IF  p-h-table:NAME = "cotacao-item-cex":U THEN DO:
    FIND FIRST cotacao-item-cex 
         WHERE ROWID(cotacao-item-cex) = p-h-table:ROWID NO-LOCK NO-ERROR.
    IF  NOT AVAIL cotacao-item-cex THEN
        RETURN "NOK":U.
END.
ELSE 
    IF (   p-h-table:NAME = "tt-ordens-totais":U
        OR p-h-table:NAME = "tt-parametros-imp":U) THEN DO:
        ASSIGN h-cod-emitente = p-h-table:BUFFER-FIELD("cod-emitente":U)
               h-numero-ordem = p-h-table:BUFFER-FIELD("numero-ordem":U)
               h-seq-cotac    = p-h-table:BUFFER-FIELD("seq-cotac":U).
    END.
    ELSE
        RETURN "NOK":U.

FIND FIRST ordem-compra
     WHERE ordem-compra.numero-ordem = IF  p-h-table:NAME = "cotacao-item-cex":U THEN
                                           cotacao-item-cex.numero-ordem
                                       ELSE
                                           h-numero-ordem:BUFFER-VALUE NO-LOCK NO-ERROR.
IF AVAIL ordem-compra THEN
    FIND FIRST ITEM WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

IF AVAIL ordem-compra THEN DO:      
    FIND FIRST param-imp
         WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
    FIND FIRST param-imp-trib
         WHERE param-imp-trib.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
END.

IF AVAIL param-imp-trib THEN     
    FIND FIRST natur-oper 
         WHERE natur-oper.nat-operacao = param-imp-trib.cod-natur-operac-novo-impto NO-LOCK NO-ERROR.

IF p-h-table:NAME = "cotacao-item-cex":U THEN      
    FIND FIRST emitente 
         WHERE emitente.cod-emitente = cotacao-item-cex.cod-emitente NO-LOCK NO-ERROR.
ELSE 
    IF p-h-table:NAME = "tt-ordens-totais":U THEN
        FIND FIRST emitente 
             WHERE emitente.cod-emitente = h-cod-emitente:BUFFER-VALUE NO-LOCK NO-ERROR.
    ELSE
        FIND FIRST emitente 
             WHERE emitente.cod-emitente = p-cod-emitente NO-LOCK NO-ERROR.

IF AVAIL ordem-compra THEN      
    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

IF AVAIL ordem-compra THEN DO:
    IF p-h-table:NAME = "cotacao-item-cex":U THEN
        FIND FIRST cotacao-item
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
               AND cotacao-item.cod-emitente = cotacao-item-cex.cod-emitente
               AND cotacao-item.it-codigo    = ordem-compra.it-codigo
               AND cotacao-item.seq-cotac    = cotacao-item-cex.seq-cotac NO-LOCK NO-ERROR.
    ELSE 
        IF  p-h-table:NAME = "tt-ordens-totais":U THEN
            FIND FIRST cotacao-item
                 WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                   AND cotacao-item.cod-emitente = h-cod-emitente:BUFFER-VALUE
                   AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                   AND cotacao-item.seq-cotac    = h-seq-cotac:BUFFER-VALUE NO-LOCK NO-ERROR.
        ELSE
            FIND FIRST cotacao-item
                 WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                   AND cotacao-item.cod-emitente = p-cod-emitente
                   AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                   AND cotacao-item.seq-cotac    = h-seq-cotac:BUFFER-VALUE NO-LOCK NO-ERROR.
END.

IF AVAIL ordem-compra THEN
    FIND FIRST item-mat 
         WHERE item-mat.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

/*--- Verifica integridade da base ---*/
IF  NOT AVAIL ITEM
OR  NOT AVAIL ordem-compra
OR  NOT AVAIL param-imp
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


IF p-h-table:NAME = "cotacao-item-cex":U THEN  DO:
    ASSIGN de-qtd-do-forn = 0.
    FOR EACH prazo-compra FIELDS (qtd-do-forn quantidade)
       WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
       
        IF prazo-compra.qtd-do-forn = 0 THEN DO:
            FIND FIRST item-fornec 
                 WHERE item-fornec.it-codigo    = cotacao-item.it-codigo 
                   AND item-fornec.cod-emitente = cotacao-item.cod-emitente NO-LOCK NO-ERROR.
            IF AVAIL item-fornec THEN DO:
                ASSIGN de-conver   = (1 / (EXP(10, item-fornec.num-casa-dec))) * item-fornec.fator-conver
                       de-qtd-forn = prazo-compra.quantidade * de-conver.

                ASSIGN de-qtd-do-forn = de-qtd-do-forn + de-qtd-forn.
            END.
        END.
        ELSE
            ASSIGN de-qtd-do-forn = de-qtd-do-forn + prazo-compra.qtd-do-forn.
    END.
END.

/*----------------------------
** Calculo do Valor Aduaneiro
-----------------------------*/
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

    /*--- acumula o valor das despesas
          que incidem no valor aduaneiro ---*/
    ASSIGN de-val-acum-desp = 0.
    FOR EACH desp-cot-ordem 
       WHERE desp-cot-ordem.cod-agrup  = p-cod-agrup  
         AND desp-cot-ordem.mapa-ordem = p-mapa-ordem  NO-LOCK:

        FIND FIRST b-desp-imp 
             WHERE b-desp-imp.cod-desp = desp-cot-ordem.cod-desp NO-LOCK NO-ERROR.
        FIND FIRST desp-imp-trib 
             WHERE desp-imp-trib.cod-desp = desp-cot-ordem.cod-desp NO-LOCK NO-ERROR.

        IF AVAIL desp-imp-trib
        AND desp-imp-trib.log-incide-base-CBS-vladu
        AND AVAIL b-desp-imp
        AND (   b-desp-imp.inc-val-embal       <> NO
             OR b-desp-imp.inc-val-frete       <> NO 
             OR b-desp-imp.inc-val-outras-desp <> NO 
             OR b-desp-imp.inc-val-seguro  <> NO) THEN DO:

            /*--- converte para a moeda corrente ---*/
            IF  desp-cot-ordem.mo-codigo <> 0 THEN
                RUN cdp/cd0812.p (INPUT desp-cot-ordem.mo-codigo,
                                  INPUT 0,
                                  INPUT desp-cot-ordem.val-desp,
                                  INPUT TODAY,
                                  OUTPUT de-valor-desp).
            ELSE
                ASSIGN de-valor-desp = desp-cot-ordem.val-desp.

            ASSIGN de-val-acum-desp = de-val-acum-desp + de-valor-desp.

        END.
    END.

    ASSIGN de-valor-aduaneiro = de-val-merc + de-val-acum-desp.

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

    IF  p-h-table:NAME = "cotacao-item-cex":U THEN DO:
        ASSIGN de-val-acum-desp = 0.

        /*--- acumula o valor das despesas
              que incidem no valor aduaneiro ---*/
        FOR EACH b-cotacao-item-cex
            WHERE b-cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
              AND b-cotacao-item-cex.cod-emitente  = cotacao-item-cex.cod-emitente
              AND b-cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
              AND b-cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
              AND b-cotacao-item-cex.data-cotacao  = cotacao-item.data-cotacao
              AND b-cotacao-item-cex.mapa-cotacao  = cotacao-item-cex.mapa-cotacao NO-LOCK:

            FIND FIRST b-desp-imp 
                 WHERE b-desp-imp.cod-desp = b-cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.
            FIND FIRST desp-imp-trib 
                 WHERE desp-imp-trib.cod-desp = b-cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.

            IF AVAIL desp-imp-trib
            AND desp-imp-trib.log-incide-base-CBS-vladu
            AND AVAIL b-desp-imp
            AND (   b-desp-imp.inc-val-embal       <> NO
                 OR b-desp-imp.inc-val-frete       <> NO 
                 OR b-desp-imp.inc-val-outras-desp <> NO 
                 OR b-desp-imp.inc-val-seguro  <> NO) THEN DO:

                /*--- converte para a moeda corrente ---*/
                IF  b-cotacao-item-cex.mo-codigo <> 0 THEN
                    RUN cdp/cd0812.p (INPUT b-cotacao-item-cex.mo-codigo,
                                      INPUT 0,
                                      INPUT b-cotacao-item-cex.val-desp,
                                      INPUT TODAY,
                                      OUTPUT de-valor-desp).
                ELSE
                    ASSIGN de-valor-desp = b-cotacao-item-cex.val-desp.

                IF b-desp-imp.tipo = 1 THEN
                    ASSIGN de-valor-desp = de-valor-desp / de-qtd-do-forn.

                ASSIGN de-val-acum-desp = de-val-acum-desp + de-valor-desp.

            END.
        END.

        ASSIGN de-valor-aduaneiro = de-val-merc + de-val-acum-desp.

    END.
    ELSE DO:

        ASSIGN de-val-acum-desp = 0.
        FOR EACH b-cotacao-item-cex NO-LOCK
            WHERE b-cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
              AND b-cotacao-item-cex.cod-emitente  = h-cod-emitente:BUFFER-VALUE
              AND b-cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
              AND b-cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
              AND b-cotacao-item-cex.data-cotacao  = cotacao-item.data-cotacao
              AND b-cotacao-item-cex.mapa-cotacao  = cotacao-item-cex.mapa-cotacao:

            FIND FIRST b-desp-imp 
                 WHERE b-desp-imp.cod-desp = b-cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.
            FIND FIRST desp-imp-trib 
                 WHERE desp-imp-trib.cod-desp = b-cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.

            IF AVAIL desp-imp-trib
            AND desp-imp-trib.log-incide-base-CBS-vladu
            AND AVAIL b-desp-imp
            AND (   b-desp-imp.inc-val-embal       <> NO
                 OR b-desp-imp.inc-val-frete       <> NO 
                 OR b-desp-imp.inc-val-outras-desp <> NO 
                 OR b-desp-imp.inc-val-seguro  <> NO) THEN DO:

                /*--- converte para a moeda corrente ---*/
                IF  b-cotacao-item-cex.mo-codigo <> 0 THEN
                    RUN cdp/cd0812.p (INPUT b-cotacao-item-cex.mo-codigo,
                                      INPUT 0,
                                      INPUT b-cotacao-item-cex.val-desp,
                                      INPUT TODAY,
                                      OUTPUT de-valor-desp).
                ELSE
                    ASSIGN de-valor-desp = b-cotacao-item-cex.val-desp.

                ASSIGN de-val-acum-desp = de-val-acum-desp + de-valor-desp.

            END.
        END.

        ASSIGN de-valor-aduaneiro = de-val-merc + de-val-acum-desp.

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
       tb-wt-it-docto.vl-merc-liq         = de-valor-aduaneiro
       OVERLAY(tb-wt-it-docto.char-1,1,6) = "IM7777":U.

CREATE tb-wt-it-imposto.
ASSIGN tb-wt-it-imposto.seq-wt-docto    = 1
       tb-wt-it-imposto.seq-wt-it-docto = 1.

CREATE tb-wt-it-impostoCBSIBS.
ASSIGN tb-wt-it-impostoCBSIBS.seq-wt-docto     = 1
       tb-wt-it-impostoCBSIBS.seq-wt-it-docto  = 1.

RUN piEnviaCodNBS IN h-imapi017 (INPUT TRIM(SUBSTRING(cotacao-item.char-1,101,20))).
RUN pi-sugere-aliquotas IN h-imapi017 (INPUT 1, // CBS
                                       INPUT tb-wt-docto.cod-estabel,
                                       INPUT tb-wt-docto.nat-operacao,
                                       INPUT tb-wt-it-docto.it-codigo,
                                       INPUT tb-wt-docto.cod-emitente,
                                       OUTPUT TABLE tt-tributo-import).
FOR EACH tt-tributo-import 
    WHERE tt-tributo-import.nom-trib = "CBS":U NO-LOCK:
    
    IF tt-tributo-import.cod-campo = "dPercRed":U THEN
        ASSIGN tb-wt-it-impostoCBSIBS.perc-red-cbs = DEC(tt-tributo-import.cod-conteudo).
        
    IF tt-tributo-import.cod-campo = "dAliq":U THEN 
        ASSIGN tb-wt-it-impostoCBSIBS.aliquota-cbs = DEC(tt-tributo-import.cod-conteudo).
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

    IF tb-ct-trib-wt-item-docto.cod-tip-trib = "CBS":U THEN
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

