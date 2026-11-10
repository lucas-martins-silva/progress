/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMAPI007 2.00.00.010 } /*** "010010" 16/09/2025 16:13:58 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i imapi007 MIM}
&ENDIF

/********************************************************************************
**
**  IMAPI007.P - Objetivo: calcular o valor do IPI ou ICMS.               
**
********************************************************************************/

{cdp/cd4300.i3}  /* include tratamento atributo livre */
{imp/im0091.i}   /* defini‡Æo temp-table para rateio de despesas */
{cdp/cd4305.i1}  /* definicao das temp-tables TT-DOCTO, TT-IT-DOCTO E TT-IT-IMPOSTO */    
{utp/ut-glob.i}  /* variaveis globais do sistema */
{cdp/cdapi020.i} /* def temp-tables para a cdapi020.p */
{ccp/cc9019.i50} /* def variaveis utilizadas no cc9019.i51 */
{inbo/boin082.i tt-cotacao-item-aux}

/* PCREQ-9042 - Portador do Emitente */
{cdp/cdapi3009.i1}
define variable i-port-emit    as integer no-undo.
define variable i-modalid-emit as integer no-undo.
{cdp/cd9900.i6} /* procedure pi-imprime-erros-tt_log_erro */

DEF VAR de-indice           AS DEC    NO-UNDO.
DEF VAR h-numero-ordem      AS HANDLE NO-UNDO.
DEF VAR h-seq-cotac         AS HANDLE NO-UNDO.
DEF VAR h-cod-emitente      AS HANDLE NO-UNDO.
DEF VAR h-qtd-do-forn       AS HANDLE NO-UNDO.
DEF VAR h-preco-unit        AS HANDLE NO-UNDO.
DEF VAR h-preco-total       AS HANDLE NO-UNDO.
DEF VAR h-base-ipi          AS HANDLE NO-UNDO.
DEF VAR h-base-icms         AS HANDLE NO-UNDO.
def var h-mapa-cotacao      as handle no-undo.
DEF VAR i-trib-ipi          AS INT    NO-UNDO.
DEF VAR de-aliq-ipi         AS DEC    NO-UNDO.
DEF VAR i-trib-icm          AS INT    NO-UNDO.
DEF VAR de-aliq-icm         AS DEC    NO-UNDO.
DEF VAR de-valor-desp       LIKE desp-imp.val-desp NO-UNDO.
DEF VAR l-desp-impto        AS LOG    NO-UNDO.
DEF VAR de-valor-conv       AS DEC    NO-UNDO.
def var deIndice            as dec    no-undo.
DEF VAR h-boin082ca         AS HANDLE NO-UNDO.

DEF BUFFER b-item             FOR ITEM.
DEF BUFFER b-emit-estab       FOR emitente.
DEF BUFFER b-desp-imp         FOR desp-imp.
DEF BUFFER b-cotacao-item-cex FOR cotacao-item-cex.

/*--- recebe o handle da cotacao-item-cex ou tt-ordens-totais(im0091.i1) ou tt-parametros-imp ---*/
DEF INPUT  PARAM p-h-table      AS HANDLE                      NO-UNDO.

/*--- codigo da despesa que esta sendo calculada ---*/
DEF INPUT PARAM p-cod-desp      LIKE desp-imp.cod-desp         NO-UNDO.

/*--- codigo do agrupamento de despesas (so recebe valor quando for im0015) ---*/
DEF INPUT PARAM p-cod-agrup     LIKE cot-ordem.cod-agrup       NO-UNDO.

/*--- codigo do mapa de despesas (so recebe valor quando for im0015) ---*/
DEF INPUT PARAM p-mapa-ordem    LIKE cot-ordem.mapa-ordem      NO-UNDO.

/*--- retorna o valor da despesa ---*/
DEF OUTPUT PARAM p-valor-desp   LIKE desp-imp.val-desp         NO-UNDO.

/* PCREQ-9042 - Portador do Emitente */
{cdp/cdapi3009.i2}

IF  p-h-table:NAME = "cotacao-item-cex":U THEN DO:
    FIND b-cotacao-item-cex WHERE
         ROWID(b-cotacao-item-cex) = p-h-table:ROWID NO-LOCK NO-ERROR.
    IF  NOT AVAIL b-cotacao-item-cex THEN
        RETURN "NOK":U.
END.
ELSE IF p-h-table:NAME = "tt-ordens-totais":U THEN
    ASSIGN h-numero-ordem = p-h-table:BUFFER-FIELD("numero-ordem":U)
           h-seq-cotac    = p-h-table:BUFFER-FIELD("seq-cotac":U)
           h-qtd-do-forn  = p-h-table:BUFFER-FIELD("qtd-do-forn":U)
           h-preco-unit   = p-h-table:BUFFER-FIELD("preco-unit":U)
           h-preco-total  = p-h-table:BUFFER-FIELD("preco-total":U)
           h-base-ipi     = p-h-table:BUFFER-FIELD("base-ipi":U)
           h-base-icms    = p-h-table:BUFFER-FIELD("base-icms":U)
           h-cod-emitente = p-h-table:BUFFER-FIELD("cod-emitente":U).

ELSE IF p-h-table:NAME = "tt-parametros-imp":U THEN
     ASSIGN h-numero-ordem = p-h-table:BUFFER-FIELD("numero-ordem":U)
            h-seq-cotac    = p-h-table:BUFFER-FIELD("seq-cotac":U)
            h-mapa-cotacao = p-h-table:BUFFER-FIELD("mapa-cotacao":U)
            h-cod-emitente = p-h-table:BUFFER-FIELD("cod-emitente":U).
ELSE
    RETURN "NOK":U.

FOR EACH tt-docto:
    DELETE tt-docto.
END.

FOR EACH tt-it-docto:
    DELETE tt-it-docto.
END.

FOR EACH tt-it-imposto:
    DELETE tt-it-imposto.
END.

IF  p-h-table:NAME = "cotacao-item-cex":U THEN
    FIND ordem-compra 
         WHERE ordem-compra.numero-ordem = b-cotacao-item-cex.numero-ordem NO-LOCK NO-ERROR.
ELSE
    FIND ordem-compra
         WHERE ordem-compra.numero-ordem = h-numero-ordem:BUFFER-VALUE NO-LOCK NO-ERROR.

IF  AVAIL ordem-compra THEN      
    FIND ITEM WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

IF  AVAIL ordem-compra THEN      
    FIND param-imp
         WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

/*--- soh calcula IPI ou ICMS ---*/
IF  AVAIL param-imp THEN
    IF  p-cod-desp <> param-imp.cdn-despes-impto-ipi 
    AND p-cod-desp <> param-imp.cdn-despes-impto-icms THEN
        RETURN "NOK":U.

IF  AVAIL param-imp THEN     
    FIND natur-oper 
         WHERE natur-oper.nat-operacao = param-imp.cod-natur-operac-padr NO-LOCK NO-ERROR.

IF  p-h-table:NAME = "cotacao-item-cex":U THEN
    FIND emitente 
         WHERE emitente.cod-emitente = b-cotacao-item-cex.cod-emitente NO-LOCK NO-ERROR.
ELSE
    FIND emitente 
         WHERE emitente.cod-emitente = h-cod-emitente:BUFFER-VALUE NO-LOCK NO-ERROR.
 
IF  AVAIL ordem-compra THEN      
    FIND estabelec
         WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

IF  AVAIL ordem-compra THEN DO:
    IF  p-h-table:NAME = "cotacao-item-cex":U THEN
        FIND cotacao-item
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
              AND cotacao-item.cod-emitente = b-cotacao-item-cex.cod-emitente
              AND cotacao-item.it-codigo    = ordem-compra.it-codigo
              AND cotacao-item.seq-cotac    = b-cotacao-item-cex.seq-cotac NO-LOCK NO-ERROR.
 
    ELSE
        FIND cotacao-item
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
              AND cotacao-item.cod-emitente = h-cod-emitente:BUFFER-VALUE
              AND cotacao-item.it-codigo    = ordem-compra.it-codigo
              AND cotacao-item.seq-cotac    = h-seq-cotac:BUFFER-VALUE NO-LOCK NO-ERROR.
END.
 
IF  AVAIL ordem-compra THEN
    FIND FIRST item-mat 
         WHERE item-mat.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

IF  p-h-table:NAME = "cotacao-item-cex":U THEN
    FIND desp-imp WHERE
         desp-imp.cod-desp = b-cotacao-item-cex.cod-desp NO-LOCK NO-ERROR.
ELSE
    FIND desp-imp WHERE
         desp-imp.cod-desp = p-cod-desp NO-LOCK NO-ERROR.

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
empty temp-table tt-cotacao-item-aux.
create tt-cotacao-item-aux.
buffer-copy cotacao-item to tt-cotacao-item-aux.
if  not valid-handle (h-boin082ca) then
    run inbo/boin082ca.p persistent set h-boin082ca.
run calcIndiceCotacaoItem in h-boin082ca (input  table tt-cotacao-item-aux,
                                          input  cotacao-item.it-codigo,
                                          output deIndice).
if  valid-handle (h-boin082ca) then do:
    delete procedure h-boin082ca.
                     h-boin082ca = ?.
end.

/*--- Determina tributacao e aliquota do IPI ---*/
{imp/im0091.i5}

/*--- se o imposto for o IPI, verifica se o mesmo
      eh isento ou tem suspensao de IPI ---*/
IF  desp-imp.cod-desp = param-imp.cdn-despes-impto-ipi 
AND (i-trib-ipi = 2 
     OR  (    natur-oper.log-suspens-ipi-import
          OR (    NOT natur-oper.log-suspens-ipi-import 
              AND AVAIL item-mat AND item-mat.log-suspens-ipi-import)))  THEN DO:
    
    ASSIGN p-valor-desp = 0.

END.
ELSE DO:
    /* PCREQ-9042 - Portador do Emitente */
    ASSIGN i-port-emit = emitente.portador-ap
           i-modalid-emit = emitente.modalidade-ap.
    IF l-fn-port-emitente THEN DO:
        run prgint/ufn/ufn008za.py persistent set h-api.
        IF valid-handle(h-api) then do:
            run pi_busca_dados_portador_fin in h-api  (input "",
                                                       input i-port-emit,
                                                       input i-modalid-emit,
                                                       input emitente.cod-emitente,
                                                       input "Fornecedor":U,
                                                       input "",                                          
                                                       output i-port-emit,
                                                       output i-modalid-emit,
                                                       output table tt_log_erro).
            delete procedure h-api.
        end.
        run pi-imprime-erros-tt_log_erro.
    END.

    /*--- se o item nao for isento, nem 
          tiver suspensao de IPI, inicia o 
          calculo do valor do IPI ---*/
    CREATE tt-docto.
    ASSIGN tt-docto.ind-tip-nota = 8
           tt-docto.seq-tt-docto = 1
           tt-docto.dt-trans     = TODAY
           tt-docto.cod-estabel  = ordem-compra.cod-estabel
           tt-docto.serie        = ""
           tt-docto.nr-nota      = STRING(cotacao-item.numero-ordem)
           tt-docto.cod-emitente = cotacao-item.cod-emitente
           tt-docto.dt-emis-nota = TODAY
           tt-docto.nome-abrev   = emitente.nome-abrev
           tt-docto.usuario      = c-seg-usuario
           tt-docto.inc-seq      = 10
           tt-docto.seq-item-um  = 10
           tt-docto.estado       = estabelec.estado
           tt-docto.cidade       = estabelec.cidade
           tt-docto.pais         = estabelec.pais
           tt-docto.cod-des-merc = IF  natur-oper.consum-final THEN 2 ELSE 1
           tt-docto.esp-docto    = 21
           tt-docto.cod-msg      = natur-oper.cod-mensagem
           tt-docto.cod-portador = i-port-emit
           tt-docto.modalidade   = i-modalid-emit
           tt-docto.ind-lib-nota = YES
           tt-docto.perc-desco1  = IF cotacao-item.perc-descto <> 0 THEN 1 ELSE 0.

    /*-------------------------------------
    --- calcula a natureza de operacao ----
    ---------------------------------------*/
    IF  desp-imp.cod-desp = param-imp.cdn-despes-impto-ipi THEN DO:

        /*--- verifica se foi informado regime especial ---*/
        IF  INT(SUBSTR(cotacao-item.char-2,61,20)) <> 0 THEN DO:

            FIND pais-aliquota
                 WHERE pais-aliquota.cod-pais      = cotacao-item.cdn-pais-orig 
                   AND pais-aliquota.regime-import = INT(SUBSTR(cotacao-item.char-2,61,20))        
                   AND pais-aliquota.class-fiscal  = IF  ITEM.tipo-contr = 4 THEN
                                                         SUBSTR(cotacao-item.char-1,81,20) 
                                                     ELSE
                                                         ITEM.class-fiscal
            NO-LOCK NO-ERROR.
            
            /*--- verifica se o regime possui ipi especial ---*/
            IF  AVAIL pais-aliquota 
            AND pais-aliquota.log-ipi-especial 
            AND pais-aliquota.cod-natur-operac-ipi <> "" THEN
                /*--- se foi informada natureza no regime especial,
                      assume essa natureza ---*/
                ASSIGN tt-docto.nat-operacao = pais-aliquota.cod-natur-operac-ipi.
            ELSE 
                ASSIGN tt-docto.nat-operacao = param-imp.cod-natur-operac-padr.

        END.
        ELSE
            ASSIGN tt-docto.nat-operacao = param-imp.cod-natur-operac-padr.

    END.
    ELSE
        ASSIGN tt-docto.nat-operacao = param-imp.cod-natur-operac-padr.
    
    CREATE tt-it-docto.
    ASSIGN tt-it-docto.seq-tt-it-docto = 1
           tt-it-docto.ct-codigo       = param-imp.ct-transit-import
           tt-it-docto.sc-codigo       = param-imp.sc-transit-import
           tt-it-docto.cod-emitente    = tt-docto.cod-emitente
           tt-it-docto.nr-nota         = tt-docto.nr-nota
           tt-it-docto.serie           = tt-docto.serie
           tt-it-docto.cod-estabel     = tt-docto.cod-estabel
           tt-it-docto.nat-operacao    = tt-docto.nat-operacao
           tt-it-docto.calcula         = YES
           tt-it-docto.nr-sequencia    = 10
           tt-it-docto.vl-frete        = 0
           tt-it-docto.vl-despes-it    = 0
           tt-it-docto.vl-embalagem    = 0
           tt-it-docto.it-codigo       = cotacao-item.it-codigo
           tt-it-docto.nro-comp        = ""
           tt-it-docto.serie-comp      = ""
           tt-it-docto.nat-comp        = ""
           tt-it-docto.seq-comp        = 0
           tt-it-docto.class-fiscal    = IF  ITEM.tipo-contr = 4 THEN
                                             SUBSTR(cotacao-item.char-1,81,20)
                                         ELSE 
                                             ITEM.class-fiscal
           tt-it-docto.data-comp       = ?
           tt-it-docto.nr-ord-prod     = ordem-compra.ordem-servic
           tt-it-docto.numero-ordem    = ordem-compra.numero-ordem
           tt-it-docto.parcela         = 1
           tt-it-docto.cod-refer       = ""
           tt-it-docto.encerra-pa      = NO
           tt-it-docto.narrativa       = ""
           tt-it-docto.per-des-item    = cotacao-item.perc-descto
           tt-it-docto.vl-seguro       = 0
           tt-it-docto.char-1          = "im7777":U.

    /*------------------------
    -- Calcula a quantidade --
    --------------------------*/
    IF  p-h-table:NAME = "tt-ordens-totais":U THEN
        ASSIGN tt-it-docto.quantidade[1] = h-qtd-do-forn:BUFFER-VALUE.
    ELSE 
        ASSIGN tt-it-docto.quantidade[1] = 1.

    /*-------------------------
    -- Calcula o item pai    --
    --------------------------*/
    IF  tt-it-docto.nr-ord-prod <> 0 THEN DO:
        FOR FIRST reservas FIELDS(item-pai cod-roteiro op-codigo)
            WHERE reservas.nr-ord-prod = tt-it-docto.nr-ord-prod
               AND reservas.it-codigo   = tt-it-docto.it-codigo NO-LOCK: END.
        IF  NOT AVAIL reservas THEN DO:

            ASSIGN tt-it-docto.item-pai = ?.
            /*
            ** NÆo exige reserva para ordens de produ‡Æo de itens de pol¡tica configurado e controlado por referˆncia
            */
            FOR FIRST ord-prod FIELDS(it-codigo)
                WHERE ord-prod.nr-ord-prod = tt-it-docto.nr-ord-prod NO-LOCK: END.
            IF  AVAIL ord-prod THEN DO:
                FOR FIRST b-item FIELDS(politica tipo-con-est tipo-contr)
                    WHERE b-item.it-codigo = ord-prod.it-codigo NO-LOCK: END.
                IF AVAIL b-item THEN DO:
                    IF b-item.politica     = 5 AND /* configurado */
                       b-item.tipo-con-est = 4 THEN /* referˆncia  */
                       ASSIGN tt-it-docto.item-pai = "".
                    IF b-item.tipo-contr = 4 THEN /* D‚bito Direto */
                        ASSIGN tt-it-docto.item-pai = "".
                END.
            END.

            IF ITEM.tipo-contr = 4 THEN /* D‚bito Direto */
                ASSIGN tt-it-docto.item-pai = "".

        END.
        ELSE do:
            ASSIGN tt-it-docto.item-pai    = reservas.item-pai
                   tt-it-docto.cod-roteiro = reservas.cod-roteiro
                   tt-it-docto.op-codigo   = reservas.op-codigo.
        END.
    END.

    /*----------------------------
    -- Calcula o campo desconto --
    -----------------------------*/
    ASSIGN tt-it-docto.desconto = cotacao-item.valor-descto.
    
    IF  p-h-table:NAME = "tt-ordens-totais":U THEN DO:

       /*--- quando for executado pelo IM0015, devera
             multiplicar o valor do desconto pela quantidade
             antes de converter para a moeda corrente ---*/
        ASSIGN tt-it-docto.desconto = tt-it-docto.desconto * tt-it-docto.quantidade[1].
        
        /*--- converte para a moeda corrente ---*/
        RUN cdp/cd0812.p (INPUT cotacao-item.mo-codigo,
                          INPUT 0,
                          INPUT tt-it-docto.desconto,
                          INPUT TODAY,
                          OUTPUT tt-it-docto.desconto).

    END.
    ELSE DO:
        
        FOR FIRST prazo-compra FIELDS(un)
            WHERE prazo-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK: END.

        /*--- converte o valor para a unidade 
              de medida interna ---*/
        {cdp/cd9950.i prazo-compra.un cotacao-item.un tt-it-docto.cod-emitente}

        ASSIGN tt-it-docto.desconto = tt-it-docto.desconto * de-indice.

        /*--- converte para a moeda corrente ---*/
        RUN cdp/cd0812.p (INPUT cotacao-item.mo-codigo,
                          INPUT 0,
                          INPUT tt-it-docto.desconto,
                          INPUT TODAY,
                          OUTPUT tt-it-docto.desconto).

    END.

    /*------------------------------------
    -- calcula o preco unitario liquido --
    -------------------------------------*/
    IF  p-h-table:NAME = "tt-ordens-totais":U THEN
        ASSIGN tt-it-docto.vl-preuni = h-preco-unit:BUFFER-VALUE.
    ELSE DO:

        /*--- encontra o valor liquido sem o IPI ---*/
        ASSIGN tt-it-docto.vl-preuni = ( (cotacao-item.pre-unit-for * deIndice) * 100)
                                       / (100 + cotacao-item.aliquota-ipi).

        /*--- converte para a moeda corrente ---*/
        RUN cdp/cd0812.p (INPUT cotacao-item.mo-codigo,
                          INPUT 0,
                          INPUT tt-it-docto.vl-preuni,
                          INPUT TODAY,
                          OUTPUT tt-it-docto.vl-preuni).
    END.

    /*------------------------------------
    -- Calcula o preco original (bruto) --
    -------------------------------------*/
    IF  p-h-table:NAME = "tt-ordens-totais":U THEN
        ASSIGN tt-it-docto.vl-preori = h-preco-total:BUFFER-VALUE + tt-it-docto.desconto
               tt-it-docto.vl-preori = tt-it-docto.vl-preori / tt-it-docto.quantidade[1].

    ELSE DO:
        /*--- encontra o valor bruto sem o IPI ---*/
        ASSIGN tt-it-docto.vl-preori = ( (cotacao-item.pre-unit-for * deIndice) * 100)
                                       / (100 + cotacao-item.aliquota-ipi).

        /*--- converte para a moeda corrente ---*/
        RUN cdp/cd0812.p (INPUT cotacao-item.mo-codigo,
                          INPUT 0,
                          INPUT tt-it-docto.vl-preori,
                          INPUT TODAY,
                          OUTPUT tt-it-docto.vl-preori).
        
        ASSIGN tt-it-docto.vl-preori = tt-it-docto.vl-preori + tt-it-docto.desconto.

    END.

    /*---------------------------------
    -- Calcula o valor total liquido --
    ----------------------------------*/
    IF  p-h-table:NAME = "tt-ordens-totais":U THEN DO:
        ASSIGN tt-it-docto.vl-merc-liq = tt-it-docto.vl-preuni * tt-it-docto.quantidade[1].
    END.
    ELSE DO:
        ASSIGN tt-it-docto.vl-merc-liq = tt-it-docto.vl-preuni.
    END.

    /*-------------------------------
    -- Calcula o valor total bruto --
    --------------------------------*/
    IF  p-h-table:NAME = "tt-ordens-totais":U THEN DO:
        ASSIGN tt-it-docto.vl-merc-ori = tt-it-docto.vl-preori * tt-it-docto.quantidade[1].
    END.
    ELSE DO:
        ASSIGN tt-it-docto.vl-merc-ori = tt-it-docto.vl-preori.
    END.

    CREATE tt-it-imposto.
    ASSIGN tt-it-imposto.seq-tt-it-docto = 1
           tt-it-imposto.ind-icm-ret     = NO
           tt-it-imposto.perc-red-ipi    = natur-oper.perc-red-ipi
           tt-it-imposto.perc-red-icm    = natur-oper.perc-red-icm
           tt-it-imposto.cd-trib-ipi     = i-trib-ipi
           tt-it-imposto.aliquota-ipi    = de-aliq-ipi.

    /*--------------------------------
    -- Calcula a tributacao do ICMS --
    ---------------------------------*/
    RUN cdp/cd4302.p (item.cd-trib-icm,
                      natur-oper.cd-trib-icm,
                      output i-trib-icm).

    ASSIGN tt-it-imposto.cd-trib-icm = i-trib-icm.

    /*------------------------------
    -- Calcula a aliquota do ICMS --
    -------------------------------*/
    FOR FIRST b-emit-estab FIELDS(contrib-icms natureza)
        WHERE b-emit-estab.cod-emitente = estabelec.cod-emitente NO-LOCK: END.

    RUN cdp/cd4301.p ( (IF  AVAIL b-emit-estab THEN
                            b-emit-estab.contrib-icms
                        ELSE
                            YES),
                       (IF  AVAIL b-emit-estab THEN
                            b-emit-estab.natureza
                        ELSE 2 /*"J"*/),
                        estabelec.estado /*estabelec.estado*/,
                        estabelec.pais,
                        estabelec.estado,
                        tt-it-docto.it-codigo,
                        natur-oper.aliquota-icm,
                        OUTPUT de-aliq-icm ).

    ASSIGN tt-it-imposto.aliquota-icm = de-aliq-icm.

    /*-----------------------------
    -- Calcula valor base do IPI --
    ------------------------------*/
    IF  p-h-table:NAME = "tt-ordens-totais":U THEN DO:

        FOR EACH  desp-cot-ordem NO-LOCK
            WHERE desp-cot-ordem.cod-agrup  = p-cod-agrup
              AND desp-cot-ordem.mapa-ordem = p-mapa-ordem:

            FIND b-desp-imp WHERE
                 b-desp-imp.cod-desp = desp-cot-ordem.cod-desp NO-LOCK NO-ERROR.

            IF  NOT b-desp-imp.inc-base-ipi THEN
                NEXT.


             /*--- se a despesa incide na base do ipi e
                  compoe os calculos da nota fiscal, entao
                  soma o valor da despesa ---*/
            IF  AVAIL b-desp-imp
            AND b-desp-imp.inc-base-ipi
            AND (   b-desp-imp.inc-val-embal       <> NO
                 OR b-desp-imp.inc-val-frete       <> NO 
                 OR b-desp-imp.inc-val-outras-desp <> NO 
                 OR b-desp-imp.inc-val-seguro  <> NO) THEN DO:


                /*--- se a despesa incide no frete, somente soma
                      essa despesa se a natureza de operacao incluir 
                      o valor do frete na base do IPI ---*/
                IF  b-desp-imp.inc-val-frete 
                AND INT(SUBSTRING(natur-oper.char-2,6,5)) <> 1 THEN
                    NEXT.

                /*--- converte para a moeda corrente ---*/                                  
                IF  desp-cot-ordem.mo-codigo <> 0 THEN                                        
                    RUN cdp/cd0812.p (INPUT desp-cot-ordem.mo-codigo,                         
                                      INPUT 0,                                                
                                      INPUT desp-cot-ordem.val-desp,                          
                                      INPUT TODAY,                                            
                                      OUTPUT de-valor-conv).                                  
                ELSE                                                                          
                    ASSIGN de-valor-conv = desp-cot-ordem.val-desp.                           
                                                                                              
                ASSIGN tt-it-imposto.vl-bipi-it = tt-it-imposto.vl-bipi-it + de-valor-conv.

            END.
        END.
    END.
    ELSE DO:

        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
        {ccp/cc9019.i51 "yes"}

        /*--- le as despesas da cotacao ---*/
        IF  p-h-table:NAME = "tt-parametros-imp" THEN DO:
            FOR EACH cotacao-item-cex NO-LOCK
                WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                  AND cotacao-item-cex.cod-emitente  = h-cod-emitente:BUFFER-VALUE 
                  AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                  AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                  AND cotacao-item-cex.data-cotacao  = cotacao-item.data-cotacao
                  AND cotacao-item-cex.mapa-cotacao  = h-mapa-cotacao:buffer-value:

                  FOR FIRST b-desp-imp 
                      WHERE b-desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK: END.

                  /*--- se a despesa incide na base do ipi e
                        compoe os calculos da nota fiscal, entao
                        soma o valor da despesa ---*/
                  IF  AVAIL b-desp-imp
                  AND b-desp-imp.inc-base-ipi
                  AND (   b-desp-imp.inc-val-embal       <> NO
                       OR b-desp-imp.inc-val-frete       <> NO 
                       OR b-desp-imp.inc-val-outras-desp <> NO 
                       OR b-desp-imp.inc-val-seguro  <> NO) THEN DO:

                      /*--- se a despesa incide no frete, somente soma
                            essa despesa se a natureza de operacao incluir 
                            o valor do frete na base do IPI ---*/
                      IF  b-desp-imp.inc-val-frete 
                      AND INT(SUBSTRING(natur-oper.char-2,6,5)) <> 1 THEN
                          NEXT.

                      /*--- converte para a moeda corrente ---*/
                      IF  cotacao-item-cex.mo-codigo <> 0 THEN
                          RUN cdp/cd0812.p (INPUT cotacao-item-cex.mo-codigo,
                                            INPUT 0,
                                            INPUT cotacao-item-cex.val-desp,
                                            INPUT TODAY,
                                            OUTPUT de-valor-desp).
                      ELSE
                          ASSIGN de-valor-desp = cotacao-item-cex.val-desp.

                      ASSIGN tt-it-imposto.vl-bipi-it = tt-it-imposto.vl-bipi-it + de-valor-desp.

                  END.
            END.
        END.
        ELSE DO:
           FOR EACH cotacao-item-cex NO-LOCK
               WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                 AND cotacao-item-cex.cod-emitente  = b-cotacao-item-cex.cod-emitente
                 AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                 AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                 AND cotacao-item-cex.data-cotacao  = cotacao-item.data-cotacao
                 AND cotacao-item-cex.mapa-cotacao  = b-cotacao-item-cex.mapa-cotacao:

                 FOR FIRST b-desp-imp 
                     WHERE b-desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK: END.

                 /*--- se a despesa incide na base do ipi e
                       compoe os calculos da nota fiscal, entao
                       soma o valor da despesa ---*/
                 IF  AVAIL b-desp-imp
                 AND (b-desp-imp.inc-base-ipi OR (NOT b-desp-imp.inc-base-ipi AND b-desp-imp.inc-val-frete <> NO))
                 AND (   b-desp-imp.inc-val-embal       <> NO
                      OR b-desp-imp.inc-val-frete       <> NO 
                      OR b-desp-imp.inc-val-outras-desp <> NO 
                      OR b-desp-imp.inc-val-seguro  <> NO) THEN DO:

                     /*--- se a despesa incide no frete, somente soma
                           essa despesa se a natureza de operacao incluir 
                           o valor do frete na base do IPI ---*/
                     IF  b-desp-imp.inc-val-frete 
                     AND INT(SUBSTRING(natur-oper.char-2,6,5)) <> 1 THEN
                         NEXT.

                     /*--- converte para a moeda corrente ---*/
                     IF  cotacao-item-cex.mo-codigo <> 0 THEN
                         RUN cdp/cd0812.p (INPUT cotacao-item-cex.mo-codigo,
                                           INPUT 0,
                                           INPUT cotacao-item-cex.val-desp,
                                           INPUT TODAY,
                                           OUTPUT de-valor-desp).
                     ELSE
                         ASSIGN de-valor-desp = cotacao-item-cex.val-desp.

                     ASSIGN tt-it-imposto.vl-bipi-it = tt-it-imposto.vl-bipi-it + de-valor-desp.

                 END.
           END.
        END.
    END.

    /*------------------------------
    -- Calcula valor base do ICMS --
    -------------------------------*/
    IF  p-h-table:NAME = "tt-ordens-totais":U THEN DO:
        
        FOR EACH  desp-cot-ordem NO-LOCK
            WHERE desp-cot-ordem.cod-agrup  = p-cod-agrup
              AND desp-cot-ordem.mapa-ordem = p-mapa-ordem:

            FIND b-desp-imp WHERE
                 b-desp-imp.cod-desp = desp-cot-ordem.cod-desp NO-LOCK NO-ERROR.

            IF  AVAIL b-desp-imp THEN DO:

                IF  desp-cot-ordem.cod-desp = param-imp.cdn-despes-impto-ipi
                OR  desp-cot-ordem.cod-desp = param-imp.cdn-despes-impto-pis
                OR  desp-cot-ordem.cod-desp = param-imp.cdn-despes-impto-cofins THEN
                    ASSIGN l-desp-impto = YES.
                ELSE
                    ASSIGN l-desp-impto = NO.

                /*--- SE a despesa incide na base do icms e compoe os calculos da nota fiscal 
                      OU se for ipi/pis/cofins e incidem na base do icms, 
                      entao soma o valor da despesa ---*/
                IF  (NOT l-desp-impto
                     AND b-desp-imp.inc-base-icms
                     AND (   b-desp-imp.inc-val-embal       <> NO
                          OR b-desp-imp.inc-val-frete       <> NO 
                          OR b-desp-imp.inc-val-outras-desp <> NO 
                          OR b-desp-imp.inc-val-seguro  <> NO))
                OR  (l-desp-impto
                     AND (   (   desp-cot-ordem.cod-desp = param-imp.cdn-despes-impto-ipi
                              AND INT(SUBSTRING(natur-oper.char-2,1,5)) = 1 /* incide IPI na base ICMS */)
                          OR (   desp-cot-ordem.cod-desp = param-imp.cdn-despes-impto-pis
                              AND param-imp.log-incid-pis-base-icms)
                          OR (   desp-cot-ordem.cod-desp = param-imp.cdn-despes-impto-cofins
                              AND param-imp.log-incid-cofins-base-icms))) 
                THEN DO:

                     /*--- se a despesa incide no frete, somente soma
                               essa despesa se a natureza de operacao incluir 
                               o valor do frete na base do IPI ---*/
                     IF  b-desp-imp.inc-val-frete 
                     AND INT(SUBSTRING(natur-oper.char-2,6,5)) <> 1 THEN
                         NEXT.
                    /*--- converte para a moeda corrente ---*/
                    IF  desp-cot-ordem.mo-codigo <> 0 THEN
                        RUN cdp/cd0812.p (INPUT desp-cot-ordem.mo-codigo,
                                          INPUT 0,
                                          INPUT desp-cot-ordem.val-desp,
                                          INPUT TODAY,
                                          OUTPUT de-valor-conv).
                    ELSE
                        ASSIGN de-valor-conv = desp-cot-ordem.val-desp.
                    
                    ASSIGN tt-it-imposto.vl-bicms-it = tt-it-imposto.vl-bicms-it + de-valor-conv.
                END.
            END.
        END.
    END.
    ELSE DO:

        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
        {ccp/cc9019.i51 "yes"}

        IF  p-h-table:NAME = "tt-parametros-imp" THEN DO:
            /*--- le as despesas da cotacao ---*/
            FOR EACH  cotacao-item-cex NO-LOCK
                WHERE cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
                  AND cotacao-item-cex.cod-emitente = h-cod-emitente:BUFFER-VALUE
                  AND cotacao-item-cex.it-codigo    = ordem-compra.it-codigo
                  AND cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
                  AND cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao
                  AND cotacao-item-cex.mapa-cotacao = h-mapa-cotacao:BUFFER-VALUE:
                  
                FOR FIRST b-desp-imp 
                    WHERE b-desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK: END.
    
                IF  AVAIL b-desp-imp THEN DO:
    
                    IF  cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-ipi
                    OR  cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-pis
                    OR  cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-cofins THEN
                        ASSIGN l-desp-impto = YES.
                    ELSE
                        ASSIGN l-desp-impto = NO.
    
                    /*--- SE a despesa incide na base do icms e compoe os calculos da nota fiscal 
                          OU se for ipi/pis/cofins e incidem na base do icms, 
                          entao soma o valor da despesa ---*/
                    IF  (NOT l-desp-impto
                         AND b-desp-imp.inc-base-icms
                         AND (   b-desp-imp.inc-val-embal       <> NO
                              OR b-desp-imp.inc-val-frete       <> NO 
                              OR b-desp-imp.inc-val-outras-desp <> NO 
                              OR b-desp-imp.inc-val-seguro  <> NO))
                    OR  (l-desp-impto
                         AND (   (   cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-ipi
                                  AND INT(SUBSTRING(natur-oper.char-2,1,5)) = 1 /* incide IPI na base ICMS */)
                              OR (   cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-pis
                                  AND param-imp.log-incid-pis-base-icms)
                              OR (   cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-cofins
                                  AND param-imp.log-incid-cofins-base-icms))) 
                    THEN DO:
    
                         /*--- se a despesa incide no frete, somente soma
                               essa despesa se a natureza de operacao incluir 
                               o valor do frete na base do IPI ---*/
                         IF  b-desp-imp.inc-val-frete 
                         AND INT(SUBSTRING(natur-oper.char-2,6,5)) <> 1 THEN
                             NEXT.
           
                         /*--- converte para a moeda corrente ---*/
                         IF  cotacao-item-cex.mo-codigo <> 0 THEN
                             RUN cdp/cd0812.p (INPUT cotacao-item-cex.mo-codigo,
                                               INPUT 0,
                                               INPUT cotacao-item-cex.val-desp,
                                               INPUT TODAY,
                                               OUTPUT de-valor-desp).
                         ELSE
                             ASSIGN de-valor-desp = cotacao-item-cex.val-desp.
        
                         ASSIGN tt-it-imposto.vl-bicms-it = tt-it-imposto.vl-bicms-it + de-valor-desp.
    
                    END.
                END.
            END.
        END.
        ELSE DO:
            /*--- le as despesas da cotacao ---*/
            FOR EACH  cotacao-item-cex NO-LOCK
                WHERE cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
                  AND cotacao-item-cex.cod-emitente = b-cotacao-item-cex.cod-emitente
                  AND cotacao-item-cex.it-codigo    = ordem-compra.it-codigo
                  AND cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
                  AND cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao
                  AND cotacao-item-cex.mapa-cotacao = b-cotacao-item-cex.mapa-cotacao:
                  
                FOR FIRST b-desp-imp 
                    WHERE b-desp-imp.cod-desp = cotacao-item-cex.cod-desp NO-LOCK: END.
    
                IF  AVAIL b-desp-imp THEN DO:
    
                    IF  cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-ipi
                    OR  cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-pis
                    OR  cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-cofins THEN
                        ASSIGN l-desp-impto = YES.
                    ELSE
                        ASSIGN l-desp-impto = NO.
    
                    /*--- SE a despesa incide na base do icms e compoe os calculos da nota fiscal 
                          OU se for ipi/pis/cofins e incidem na base do icms, 
                          entao soma o valor da despesa ---*/
                    IF  (NOT l-desp-impto
                         AND b-desp-imp.inc-base-icms
                         AND (   b-desp-imp.inc-val-embal       <> NO
                              OR b-desp-imp.inc-val-frete       <> NO 
                              OR b-desp-imp.inc-val-outras-desp <> NO 
                              OR b-desp-imp.inc-val-seguro  <> NO))
                    OR  (l-desp-impto
                         AND (   (   cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-ipi
                                  AND INT(SUBSTRING(natur-oper.char-2,1,5)) = 1 /* incide IPI na base ICMS */)
                              OR (   cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-pis
                                  AND param-imp.log-incid-pis-base-icms)
                              OR (   cotacao-item-cex.cod-desp = param-imp.cdn-despes-impto-cofins
                                  AND param-imp.log-incid-cofins-base-icms))) 
                    THEN DO:
    
                         /*--- se a despesa incide no frete, somente soma
                               essa despesa se a natureza de operacao incluir 
                               o valor do frete na base do IPI ---*/
                         IF  b-desp-imp.inc-val-frete 
                         AND INT(SUBSTRING(natur-oper.char-2,6,5)) <> 1 THEN
                             NEXT.
           
                         /*--- converte para a moeda corrente ---*/
                         IF  cotacao-item-cex.mo-codigo <> 0 THEN
                             RUN cdp/cd0812.p (INPUT cotacao-item-cex.mo-codigo,
                                               INPUT 0,
                                               INPUT cotacao-item-cex.val-desp,
                                               INPUT TODAY,
                                               OUTPUT de-valor-desp).
                         ELSE
                             ASSIGN de-valor-desp = cotacao-item-cex.val-desp.
        
                         ASSIGN tt-it-imposto.vl-bicms-it = tt-it-imposto.vl-bicms-it + de-valor-desp.
    
                    END.
                END.
            END.
        END.
    END.

    /*---------------------------------------
    --- Chama apis que efetivamente farao ---
    --- o calculo do IPI ou ICMS.         ---
    -----------------------------------------*/

    IF  desp-imp.cod-desp = param-imp.cdn-despes-impto-ipi THEN DO:

        /*--- Calculo da base e o valor do IPI  ---*/
        RUN cdp/cd4306.p ( tt-it-docto.seq-tt-it-docto,
                           1,                  /* Natureza Entrada */
                           natur-oper.char-2,  /* Frete Base IPI   */
                           NO,                 /* Nota Comercio    */
                           INPUT        TABLE tt-docto,
                           INPUT        TABLE tt-it-docto,
                           INPUT-OUTPUT TABLE tt-it-imposto).
    
        FIND FIRST tt-it-imposto NO-ERROR.
        ASSIGN p-valor-desp = tt-it-imposto.vl-ipi-it.

    END.
    ELSE DO:

        /* Calcula a base e o valor do ICMS */
        RUN rep/re1906.p (tt-docto.seq-tt-docto,
                          YES,                /* ICMS */
                          NO,                 /* Subst. Tributaria */
                          NO,                 /* ICMS Complementar */
                          INPUT        TABLE tt-docto,
                          INPUT        TABLE tt-it-docto,
                          INPUT-OUTPUT TABLE tt-it-imposto).
        
        FIND FIRST tt-it-imposto NO-ERROR.
        ASSIGN p-valor-desp = tt-it-imposto.vl-icms-it.

    END.

END.

RETURN "OK":U.
