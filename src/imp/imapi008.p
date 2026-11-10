/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMAPI008 2.00.00.012 } /*** "010012" 09/07/2026 16:01:59 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i imapi008 MIM}
&ENDIF

/********************************************************************************
**
**  IMAPI008.P - Objetivo: Calcular o valor das despesas dos impostos PIS e COFINS               
**
********************************************************************************/
{inbo/boin082.i tt-cotacao-item-aux}

DEF VAR i-cod-cond-pag LIKE cond-pagto.cod-cond-pag           NO-UNDO.
DEF VAR i-trib-ipi     LIKE item-doc-est.cd-trib-ipi          NO-UNDO.
DEF VAR de-aliq-ipi    LIKE item-doc-est.aliquota-ipi         NO-UNDO.
DEF VAR c-trib-icm     LIKE item-doc-est.cd-trib-icm          NO-UNDO.
DEF VAR de-aliq-icm    LIKE item-doc-est.aliquota-ipi         NO-UNDO.
DEF VAR de-valor-desp  LIKE cotacao-item-cex.val-desp         NO-UNDO.
DEF VAR de-va-pis      AS DEC FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* Valor Aduaneiro PIS        */
DEF VAR de-da-pis      AS DEC FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* Despesas Aduaneiras PIS    */
DEF VAR de-va-cofins   AS DEC FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* Valor Aduaneiro COFINS     */
DEF VAR de-da-cofins   AS DEC FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* Despesas Aduaneiras COFINS */
DEF VAR de-red-pis     AS DEC FORMAT ">>9.99"                 NO-UNDO. /* Valor Reducao PIS          */
DEF VAR de-red-cofins  AS DEC FORMAT ">>9.99"                 NO-UNDO. /* Valor Reducao COFINS       */
DEF VAR l-ordens-embarque AS LOGICAL                          NO-UNDO.
DEF VAR i-trib-ii      AS INT                                 NO-UNDO.
DEF VAR de-aliq-ii     AS DEC FORMAT ">>9.9999"               NO-UNDO.

DEF VAR i-trib-pis          AS INT NO-UNDO.
DEF VAR de-aliq-pis         AS DEC NO-UNDO.
DEF VAR de-valor-un-pis     AS DEC NO-UNDO.
DEF VAR de-valor-vol-pis    AS DEC NO-UNDO.

DEF VAR i-trib-cofins       AS INT NO-UNDO.
DEF VAR de-aliq-cofins      AS DEC NO-UNDO.
DEF VAR de-valor-un-cofins  AS DEC NO-UNDO.
DEF VAR de-valor-vol-cofins AS DEC NO-UNDO.

DEF VAR de-val-merc         AS DEC NO-UNDO.
DEF VAR de-qtd-do-forn-tot  AS DEC NO-UNDO.
DEF VAR de-quantidade-tot   AS DEC NO-UNDO.
DEF VAR de-qtd-do-forn      AS DEC NO-UNDO.
DEF VAR de-val-acum-desp    AS DEC NO-UNDO.
DEF VAR de-valor-aduaneiro  AS DEC NO-UNDO.
DEF VAR l-deleta-erros      AS LOGICAL NO-UNDO.
def var deIndice            as dec    no-undo.
DEF VAR h-boin082ca         AS HANDLE NO-UNDO.

DEF VAR de-a  AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* aliq imposto de importacao */
DEF VAR de-b  AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* aliq ipi */
DEF VAR de-c  AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* aliq pis */
DEF VAR de-d  AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* aliq cofins */
DEF VAR de-e  AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* aliq icms */
DEF VAR de-VA AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* valor aduaneiro */
DEF VAR de-DA AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999" NO-UNDO. /* despesas aduaneiras */

DEF VAR de-conver        AS   DECIMAL              NO-UNDO.
DEF VAR de-qtd-forn      AS   DECIMAL              NO-UNDO.

DEF BUFFER b-emit-estab FOR emitente.
DEF BUFFER b-desp-imp   FOR desp-imp.
DEF BUFFER b-cotacao-item-cex FOR cotacao-item-cex.

DEF VAR h-im9048 AS HANDLE NO-UNDO.
DEF VAR h-im9042 AS HANDLE NO-UNDO.

DEF VAR h-numero-ordem AS HANDLE NO-UNDO.
DEF VAR h-seq-cotac    AS HANDLE NO-UNDO.
DEF VAR h-cod-emitente AS HANDLE NO-UNDO.

{cdp/cd4300.i3} /* variaveis utilizadas pela cc9019.i50 */
{ccp/cc9019.i50} /* variaveis utilizadas pela cc9019.i51 */
{cxbo/bocx250.i2} /* variaveis utilizadas pela bocx250.i3 */
{cdp/cd0666.i}    /* definicao da temp-table geral tt-erro */
{cdp/cdapi020.i}  /* definicao da temp-table tt-formula */
{cdp/cdcfgmat.i}

/*--- recebe o handle da cotacao-item-cex ou tt-ordens-totais(im0091.i1) ---*/
DEF INPUT  PARAM p-h-table      AS HANDLE                      NO-UNDO.

/*--- recebe o codigo da despesa que esta sendo calculada ---*/
DEF INPUT PARAM p-cod-despesa   LIKE desp-imp.cod-desp         NO-UNDO.

/*--- recebe o codigo do emitente ---*/
DEF INPUT PARAM p-cod-emitente  LIKE emitente.cod-emitente     NO-UNDO.
/*--- recebe a chave da cot-ordem ---*/
DEF INPUT PARAM p-cod-agrup     LIKE cot-ordem.cod-agrup       NO-UNDO.
DEF INPUT PARAM p-mapa-ordem    LIKE cot-ordem.mapa-ordem      NO-UNDO.

/*--- retorna o valor da despesa ---*/
DEF OUTPUT PARAM p-valor-desp   LIKE desp-imp.val-desp         NO-UNDO.

IF  p-h-table:NAME = "cotacao-item-cex":U THEN DO:
    FIND cotacao-item-cex WHERE
         ROWID(cotacao-item-cex) = p-h-table:ROWID NO-LOCK NO-ERROR.
    IF  NOT AVAIL cotacao-item-cex THEN
        RETURN "NOK":U.
END.
ELSE IF (   p-h-table:NAME = "tt-ordens-totais":U
         OR p-h-table:NAME = "tt-parametros-imp":U) THEN DO:
     ASSIGN h-cod-emitente = p-h-table:BUFFER-FIELD("cod-emitente":U)
            h-numero-ordem = p-h-table:BUFFER-FIELD("numero-ordem":U)
            h-seq-cotac    = p-h-table:BUFFER-FIELD("seq-cotac":U).
END.
ELSE
    RETURN "NOK":U.

RUN imp/im9048.p PERSISTENT SET h-im9048.

FIND ordem-compra
     WHERE ordem-compra.numero-ordem = IF  p-h-table:NAME = "cotacao-item-cex":U THEN
                                           cotacao-item-cex.numero-ordem
                                       ELSE
                                           h-numero-ordem:BUFFER-VALUE NO-LOCK NO-ERROR.

IF  AVAIL ordem-compra THEN
    FIND ITEM WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

IF  AVAIL ordem-compra THEN      
    FIND param-imp
         WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

IF  AVAIL param-imp THEN     
    FIND natur-oper 
         WHERE natur-oper.nat-operacao = param-imp.cod-natur-operac-padr NO-LOCK NO-ERROR.

IF  p-h-table:NAME = "cotacao-item-cex":U THEN      
    FIND emitente 
         WHERE emitente.cod-emitente = cotacao-item-cex.cod-emitente NO-LOCK NO-ERROR.
ELSE IF  p-h-table:NAME = "tt-ordens-totais":U THEN
    FIND emitente 
         WHERE emitente.cod-emitente = h-cod-emitente:BUFFER-VALUE NO-LOCK NO-ERROR.
ELSE
    FIND emitente 
         WHERE emitente.cod-emitente = p-cod-emitente NO-LOCK NO-ERROR.

IF  AVAIL ordem-compra THEN      
    FIND estabelec
         WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

IF  AVAIL ordem-compra THEN DO:
    IF  p-h-table:NAME = "cotacao-item-cex":U THEN
        FIND cotacao-item
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
              AND cotacao-item.cod-emitente = cotacao-item-cex.cod-emitente
              AND cotacao-item.it-codigo    = ordem-compra.it-codigo
              AND cotacao-item.seq-cotac    = cotacao-item-cex.seq-cotac NO-LOCK NO-ERROR.
    ELSE IF  p-h-table:NAME = "tt-ordens-totais":U THEN
        FIND cotacao-item
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
              AND cotacao-item.cod-emitente = h-cod-emitente:BUFFER-VALUE
              AND cotacao-item.it-codigo    = ordem-compra.it-codigo
              AND cotacao-item.seq-cotac    = h-seq-cotac:BUFFER-VALUE     NO-LOCK NO-ERROR.
    ELSE
        FIND cotacao-item
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
              AND cotacao-item.cod-emitente = p-cod-emitente
              AND cotacao-item.it-codigo    = ordem-compra.it-codigo
              AND cotacao-item.seq-cotac    = h-seq-cotac:BUFFER-VALUE NO-LOCK NO-ERROR.
END.

IF  AVAIL ordem-compra THEN
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

/*--- busca tributacao e aliquota do PIS ---*/
RUN pi-tributa-aliquota-pis-importacao IN h-im9048 (BUFFER natur-oper,
                                                    BUFFER ITEM,
                                                    INPUT  ordem-compra.cod-estabel,
                                                    INPUT  TODAY,
                                                    INPUT  NO,
                                                    INPUT  ?,
                                                    INPUT  ?,
                                                    INPUT  ?,
                                                    OUTPUT i-trib-pis,
                                                    OUTPUT de-aliq-pis,
                                                    OUTPUT de-valor-un-pis,
                                                    OUTPUT de-valor-vol-pis,
                                                    OUTPUT de-red-pis /* Valor Reducao PIS */).

/*--- busca tributacao e aliquota do COFINS ---*/
RUN pi-tributa-aliquota-cofins-importacao IN h-im9048 (BUFFER natur-oper,
                                                       BUFFER ITEM,
                                                       INPUT  ordem-compra.cod-estabel,
                                                       INPUT  TODAY,
                                                       INPUT  NO,
                                                       INPUT  ?,
                                                       INPUT  ?,
                                                       INPUT  ?,
                                                       OUTPUT i-trib-cofins,
                                                       OUTPUT de-aliq-cofins,
                                                       OUTPUT de-valor-un-cofins,
                                                       OUTPUT de-valor-vol-cofins, 
                                                       OUTPUT de-red-cofins /* Valor Reducao COFINS */).

DELETE PROCEDURE h-im9048.

/*--- verifica se foi informado valor unitario
      ou por volume no item, neste caso assume
      estes valores e nao aplica a formula ---*/
IF  (    p-cod-despesa = param-imp.cdn-despes-impto-pis 
     AND (de-valor-un-pis > 0 OR de-valor-vol-pis > 0))
OR  (    p-cod-despesa = param-imp.cdn-despes-impto-cofins 
     AND (de-valor-un-cofins > 0 OR de-valor-vol-cofins > 0)) THEN DO:
    
    /*--- determina valor do PIS ---*/
    IF  p-cod-despesa = param-imp.cdn-despes-impto-pis THEN DO:
        
        /*--- atribui o valor unitario do item
              para o valor da despesa ---*/
        IF  de-valor-un-pis > 0 THEN DO:
            IF p-h-table:NAME = "tt-ordens-totais":U THEN DO:
                ASSIGN de-quantidade-tot = 0.
                FOR EACH  prazo-compra FIELDS(quantidade)
                    WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
                    ASSIGN de-quantidade-tot = de-quantidade-tot + prazo-compra.quantidade.
                END.
                ASSIGN p-valor-desp = de-valor-un-pis * de-quantidade-tot.
            END.
            ELSE
                ASSIGN p-valor-desp = de-valor-un-pis.
        END.

        /*--- atribui o valor por volume do item
              para o valor da despesa ---*/
        ELSE DO:
            IF p-h-table:NAME = "tt-ordens-totais":U THEN DO:
                ASSIGN de-quantidade-tot = 0.
                FOR EACH  prazo-compra FIELDS(quantidade)
                    WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
                    ASSIGN de-quantidade-tot = de-quantidade-tot + prazo-compra.quantidade.
                END.
                ASSIGN p-valor-desp = de-valor-vol-pis * de-quantidade-tot
                                          * ITEM.altura * ITEM.largura * ITEM.comprim.
            END.
            ELSE
                ASSIGN p-valor-desp = de-valor-vol-pis * ITEM.altura * ITEM.largura * ITEM.comprim.
        END.
    END.
    /*--- determina valor da COFINS ---*/
    ELSE DO:

        /*--- atribui o valor unitario do item
              para o valor da despesa ---*/
        IF  de-valor-un-cofins > 0 THEN DO:
            IF p-h-table:NAME = "tt-ordens-totais":U THEN DO:
                ASSIGN de-quantidade-tot = 0.
                FOR EACH  prazo-compra FIELDS(quantidade)
                    WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
                    ASSIGN de-quantidade-tot = de-quantidade-tot + prazo-compra.quantidade.
                END.
                ASSIGN p-valor-desp = de-valor-un-cofins * de-quantidade-tot.
            END.
            ELSE
                ASSIGN p-valor-desp = de-valor-un-cofins.
        END.

        /*--- atribui o valor por volume do item
              para o valor da despesa ---*/
        ELSE DO:
            IF p-h-table:NAME = "tt-ordens-totais":U THEN DO:
                ASSIGN de-quantidade-tot = 0.
                FOR EACH  prazo-compra FIELDS(quantidade)
                    WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
                    ASSIGN de-quantidade-tot = de-quantidade-tot + prazo-compra.quantidade.
                END.
                ASSIGN p-valor-desp = de-valor-vol-cofins * de-quantidade-tot
                                          * ITEM.altura * ITEM.largura * ITEM.comprim.
            END.
            ELSE
                ASSIGN p-valor-desp = de-valor-vol-cofins * ITEM.altura * ITEM.largura * ITEM.comprim.
        END.

    END.
END.
ELSE DO:

    /*--- calcula o valor do PIS e COFINS
          utilizando a formula do param-imp ---*/

    IF  p-h-table:NAME = "cotacao-item-cex":U THEN  DO:
        ASSIGN de-qtd-do-forn = 0.
        FOR EACH prazo-compra FIELDS (qtd-do-forn quantidade)
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
           
            IF prazo-compra.qtd-do-forn = 0 THEN DO:
                 find first item-fornec where
                            item-fornec.it-codigo    = cotacao-item.it-codigo and
                            item-fornec.cod-emitente = cotacao-item.cod-emitente no-lock no-error.
				if avail item-fornec then do:
					assign de-conver   = (1 / (exp(10, item-fornec.num-casa-dec))) * item-fornec.fator-conver
						   de-qtd-forn = prazo-compra.quantidade * de-conver.

					ASSIGN de-qtd-do-forn = de-qtd-do-forn + de-qtd-forn.
				end.
            END.
            ELSE
                ASSIGN de-qtd-do-forn = de-qtd-do-forn + prazo-compra.qtd-do-forn.
        END.
    END.

    /*--- busca a tributacao do II ---*/
    RUN imp/im9041.p (INT(SUBSTR(item.char-2,20,2)),
                      INT(SUBSTR(natur-oper.char-1,10,2)),
                      OUTPUT i-trib-ii). 
    
    /*--- busca aliquota do II ---*/
    IF  i-trib-ii = 2 /* isento */ THEN
        ASSIGN de-aliq-ii = 0.
    ELSE DO:
        RUN imp/im9042.p PERSISTENT SET h-im9042(INPUT cotacao-item.numero-ordem,
                                                 OUTPUT de-aliq-ii).
        RUN pi-retorna-aliquota-ii IN h-im9042(INPUT ROWID(cotacao-item),
                                               OUTPUT de-aliq-ii).
        DELETE PROCEDURE h-im9042 NO-ERROR.
        ASSIGN h-im9042 = ?.
    END.

     /*--- 
     ** Determina tributacao e aliquota do IPI
     ** carrega nas variaveis de-aliq-ipi e i-trib-ipi
     ---*/
    {imp/im0091.i5}

    IF  i-trib-ipi = 2 /* isento */ THEN
        ASSIGN de-aliq-ipi = 0.

    /*--- aplica reducao do IPI ---*/
    IF  i-trib-ipi = 4 /* reduzido */ THEN
        ASSIGN de-aliq-ipi = de-aliq-ipi - (de-aliq-ipi * natur-oper.perc-red-ipi / 100).

    /*---
    ** Calcula a tributacao do ICMS 
    ---*/
    RUN cdp/cd4302.p (item.cd-trib-icm,
                      natur-oper.cd-trib-icm,
                      output c-trib-icm).

    /*---
    ** Calcula a aliquota do ICMS
    ---*/
    IF  c-trib-icm <> 2 THEN DO:

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
                            ordem-compra.it-codigo,
                            natur-oper.aliquota-icm,   
                            OUTPUT de-aliq-icm ).

        /*--- aplica reducao do ICMS ---*/
        IF  c-trib-icm = 4 /* reduzido */ THEN
            ASSIGN de-aliq-icm = de-aliq-icm - (de-aliq-icm * natur-oper.perc-red-icm / 100).

    END.
    ELSE
        ASSIGN de-aliq-icm = 0. /* item isento */
    
    /*---
    ** Calculo do Valor Aduaneiro
    ---*/
    IF  p-h-table:NAME = "tt-ordens-totais":U THEN DO:

        /*--- encontra o valor da mercadoria ---*/
        ASSIGN de-val-merc = (cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi).
        
        ASSIGN de-qtd-do-forn-tot = 0.
        FOR EACH prazo-compra FIELDS(qtd-do-forn quantidade)
            WHERE prazo-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK:

            IF prazo-compra.qtd-do-forn = 0 THEN DO:
                 find first item-fornec where
                            item-fornec.it-codigo    = cotacao-item.it-codigo and
                            item-fornec.cod-emitente = cotacao-item.cod-emitente no-lock no-error.
    
                assign de-conver   = (1 / (exp(10, item-fornec.num-casa-dec))) * item-fornec.fator-conver
                       de-qtd-forn = prazo-compra.quantidade * de-conver.

                ASSIGN de-qtd-do-forn-tot = de-qtd-do-forn-tot + de-qtd-forn.
    
            END.
            ELSE
                ASSIGN de-qtd-do-forn-tot = de-qtd-do-forn-tot + prazo-compra.qtd-do-forn.

            
        END.

        ASSIGN de-val-merc = de-val-merc * de-qtd-do-forn-tot.

        /*--- converte para a moeda corrente ---*/
        IF  cotacao-item.mo-codigo <> 0 THEN
            RUN cdp/cd0812.p (cotacao-item.mo-codigo,
                              0,
                              de-val-merc,
                              TODAY,
                              OUTPUT de-val-merc).            

        /*--- acumula o valor das despesas
              que incidem no valor aduaneiro ---*/
        ASSIGN de-val-acum-desp = 0.
        FOR EACH  desp-cot-ordem 
            WHERE desp-cot-ordem.cod-agrup  = p-cod-agrup  
              AND desp-cot-ordem.mapa-ordem = p-mapa-ordem  NO-LOCK:

            FOR FIRST b-desp-imp 
                WHERE b-desp-imp.cod-desp = desp-cot-ordem.cod-desp NO-LOCK: END.

            /*--- se a despesa incide na base do PIS ou COFINS e
                  compoe os calculos da nota fiscal, entao
                  acumula o valor da despesa ---*/
            IF  AVAIL b-desp-imp
            AND (   (    b-desp-imp.log-incid-base-pis-val AND p-cod-despesa = param-imp.cdn-despes-impto-pis)
                 OR (    b-desp-imp.log-incid-base-cofins-val AND p-cod-despesa = param-imp.cdn-despes-impto-cofins))
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

        /*--- acumula o valor das despesas
              que incidem na despesa aduaneira ---*/
        ASSIGN de-val-acum-desp = 0.
        FOR EACH  desp-cot-ordem 
            WHERE desp-cot-ordem.cod-agrup  = p-cod-agrup  
              AND desp-cot-ordem.mapa-ordem = p-mapa-ordem  NO-LOCK:

            FOR FIRST b-desp-imp 
                WHERE b-desp-imp.cod-desp = desp-cot-ordem.cod-desp NO-LOCK: END.

            /*--- se a despesa incide na base do PIS ou COFINS e
                  compoe os calculos da nota fiscal, entao
                  acumula o valor da despesa ---*/
            IF  AVAIL b-desp-imp
            AND (   (b-desp-imp.log-incid-base-pis-despes AND p-cod-despesa = param-imp.cdn-despes-impto-pis)
                 OR (b-desp-imp.log-incid-base-cofins-despes AND p-cod-despesa = param-imp.cdn-despes-impto-cofins))
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

        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
        {ccp/cc9019.i51 "yes"}

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

                FOR FIRST b-desp-imp 
                    WHERE b-desp-imp.cod-desp = b-cotacao-item-cex.cod-desp NO-LOCK: END.
    
                /*--- se a despesa incide na base do PIS ou COFINS e
                      compoe os calculos da nota fiscal, entao
                      acumula o valor da despesa ---*/
                IF  AVAIL b-desp-imp
                AND (   (b-desp-imp.log-incid-base-pis-val AND p-cod-despesa = param-imp.cdn-despes-impto-pis)
                     OR (b-desp-imp.log-incid-base-cofins-val AND p-cod-despesa = param-imp.cdn-despes-impto-cofins))
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
    
            /*--- calcula despesas que incidem 
                  na despesa aduaneira ---*/
            ASSIGN de-val-acum-desp = 0.
            FOR EACH b-cotacao-item-cex
                WHERE b-cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                  AND b-cotacao-item-cex.cod-emitente  = cotacao-item-cex.cod-emitente
                  AND b-cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                  AND b-cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                  AND b-cotacao-item-cex.data-cotacao  = cotacao-item.data-cotacao
                  AND b-cotacao-item-cex.mapa-cotacao  = cotacao-item-cex.mapa-cotacao NO-LOCK:
    
                FOR FIRST b-desp-imp 
                    WHERE b-desp-imp.cod-desp = b-cotacao-item-cex.cod-desp NO-LOCK: END.
    
                /*--- se a despesa incide na base do PIS ou COFINS e
                      compoe os calculos da nota fiscal, entao
                      acumula o valor da despesa ---*/
                IF  AVAIL b-desp-imp
                AND (   (b-desp-imp.log-incid-base-pis-despes AND p-cod-despesa = param-imp.cdn-despes-impto-pis)
                     OR (b-desp-imp.log-incid-base-cofins-despes AND p-cod-despesa = param-imp.cdn-despes-impto-cofins))
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
    
                FOR FIRST b-desp-imp 
                    WHERE b-desp-imp.cod-desp = b-cotacao-item-cex.cod-desp NO-LOCK: END.
    
                /*--- se a despesa incide na base do PIS ou COFINS e
                      compoe os calculos da nota fiscal, entao
                      acumula o valor da despesa ---*/
                IF  AVAIL b-desp-imp
                AND (   (b-desp-imp.log-incid-base-pis-val AND p-cod-despesa = param-imp.cdn-despes-impto-pis)
                     OR (b-desp-imp.log-incid-base-cofins-val AND p-cod-despesa = param-imp.cdn-despes-impto-cofins))
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
    
            /*--- calcula despesas que incidem 
                  na despesa aduaneira ---*/
            ASSIGN de-val-acum-desp = 0.
            FOR EACH b-cotacao-item-cex NO-LOCK
                WHERE b-cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                  AND b-cotacao-item-cex.cod-emitente  = h-cod-emitente:BUFFER-VALUE
                  AND b-cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                  AND b-cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                  AND b-cotacao-item-cex.data-cotacao  = cotacao-item.data-cotacao
                  AND b-cotacao-item-cex.mapa-cotacao  = cotacao-item-cex.mapa-cotacao:
    
                FOR FIRST b-desp-imp 
                    WHERE b-desp-imp.cod-desp = b-cotacao-item-cex.cod-desp NO-LOCK: END.
    
                /*--- se a despesa incide na base do PIS ou COFINS e
                      compoe os calculos da nota fiscal, entao
                      acumula o valor da despesa ---*/
                IF  AVAIL b-desp-imp
                AND (   (b-desp-imp.log-incid-base-pis-despes AND p-cod-despesa = param-imp.cdn-despes-impto-pis)
                     OR (b-desp-imp.log-incid-base-cofins-despes AND p-cod-despesa = param-imp.cdn-despes-impto-cofins))
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
        END.
    END.

    /*--- se o imposto for isento entao atribui zero 
          para o imposto e nao executa o calculo ---*/
    IF  (    i-trib-pis = 2 /* isento */
         AND p-cod-despesa = param-imp.cdn-despes-impto-pis) 
    OR  (    i-trib-cofins = 2 /* isento */
         AND p-cod-despesa = param-imp.cdn-despes-impto-pis) THEN
        ASSIGN p-valor-desp = 0.

    ELSE DO:

        /*--- Calcula o valor do PIS/COFINS ---*/
        FOR EACH tt-formula:
            DELETE tt-formula.
        END.

        FOR EACH tt-var:
            DELETE tt-var.
        END.

        /* As aliquotas dos impostos II, IPI e ICMS dever∆o ser zeradas quando a natureza de operaá∆o esteja marcada p/ suspens∆o */
        IF SUBSTR(natur-oper.char-1,154,1) = "1" THEN ASSIGN de-aliq-ii  = 0.00000.    
        IF SUBSTR(natur-oper.char-1,155,1) = "1" THEN ASSIGN de-aliq-ipi = 0.00000. 
        IF SUBSTR(natur-oper.char-1,156,1) = "1" THEN ASSIGN de-aliq-icm = 0.00000. 

        ASSIGN de-VA = de-valor-aduaneiro
               de-DA = de-val-acum-desp
               de-a  = de-aliq-ii
               de-b  = de-aliq-ipi
               de-c  = de-aliq-pis
               de-d  = de-aliq-cofins
               de-e  = de-aliq-icm.

        /* busca a formula do param-imp */
        {cxbo/bocx250.i3 param-imp}

        CREATE tt-formula.
        ASSIGN tt-formula.formula = IF  p-cod-despesa = param-imp.cdn-despes-impto-pis THEN 
                                        c-formula-pis-param-imp
                                    ELSE
                                        c-formula-cofins-param-imp
               tt-formula.cod-versao-integracao = 001.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "VA"
               tt-var.valor     = de-VA
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "DA"
               tt-var.valor     = de-DA
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "a"
               tt-var.valor     = de-a / 100
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "b"
               tt-var.valor     = de-b / 100
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "c"
               tt-var.valor     = de-c / 100
               tt-var.tipo-res  = 1.  

        CREATE tt-var.
        ASSIGN tt-var.nome      = "d"
               tt-var.valor     = de-d / 100
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "e"
               tt-var.valor     = de-e / 100
               tt-var.tipo-res  = 1.               

        RUN cdp/cdapi020.p (INPUT-OUTPUT TABLE tt-formula,
                            INPUT TABLE tt-var,
                            INPUT-OUTPUT TABLE tt-erro,
                            INPUT l-deleta-erros).

        IF  NOT CAN-FIND(FIRST tt-erro) THEN DO:
            FIND FIRST tt-formula NO-LOCK NO-ERROR.        
            IF AVAIL tt-formula THEN
                ASSIGN p-valor-desp = tt-formula.RESULT.
        END. 
    END. 
END.
