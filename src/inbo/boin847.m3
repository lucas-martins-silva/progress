

/*------------------------------------------------------------------------------
  Purpose:                                                                    
  Criar as temp-tables tt-doc-fisico e tt-it-doc-fisico com as informaá‰es 
  provenientes do conversor (RE0708 - notas fiscais eletrìnicas) a fim de gerar
  os registros para posterior efetivaá∆o nas tabelas relacionadas aos documentos 
  recebidos pelo f°sico (documentos recebidos sem informaá∆o de detalhes fiscais,
  a fim de agilizar o recebimento de materiais).
     
------------------------------------------------------------------------------*/

def var c-cod-unid-negoc like it-doc-fisico.cod-unid-negoc no-undo.
def var h-cdapi024       as   handle                       no-undo.  
def var l-reabre-pd      as   logical initial no           no-undo.
def var h-reapi321       as   handle                       no-undo.

/* CRIA TT-DOC-FISICO ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */
CREATE tt-doc-fisico.
ASSIGN tt-doc-fisico.nro-docto    = bf{&TableName}.nro-docto
       tt-doc-fisico.serie-docto  = bf{&TableName}.serie-docto
       tt-doc-fisico.cod-emitente = bf{&TableName}.cod-emitente
       tt-doc-fisico.cod-estabel  = bf{&TableName}.cod-estabel
       tt-doc-fisico.dt-emissao   = bf{&TableName}.dt-emissao
       tt-doc-fisico.dt-trans     = bf{&TableName}.dt-transacao
       tt-doc-fisico.observacao   = IF bf{&TableName}.inf-complement = ? THEN "" ELSE SUBSTRING(bf{&TableName}.inf-complement,1,2000)
       tt-doc-fisico.tipo-nota    = i-tipo-nota
       tt-doc-fisico.valor-frete  = 0
       tt-doc-fisico.valor-seguro = 0
       tt-doc-fisico.valor-outras = 0
       tt-doc-fisico.despesa-nota = 0
       tt-doc-fisico.tot-desconto = bf{&TableName}.valor-desconto.
       

/* ALTERAÄ«O PARA COLOCAR O ESTABELECIMENTO DE ORIGEM NA NOTA DE TRANSFERENCIA */
IF i-tipo-nota = 3 THEN /* transferencia */
    FOR FIRST estabelec FIELDS(cod-estabel)
        WHERE estabelec.cgc = bf{&TableName}.cnpj
          AND estabelec.cod-emitente = bf{&TableName}.cod-emitente NO-LOCK:
        ASSIGN tt-doc-fisico.estab-de-or = estabelec.cod-estabel.
    END.

ASSIGN i-seq-item = param-re.seq-item-um
       l-saldo-ok = YES.
/* ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */

    
/* CRIA TT-IT-DOC-FISICO ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */
FOR EACH item-doc-orig-nfe WHERE 
         item-doc-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe AND
         item-doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:

    IF item-doc-orig-nfe.int-2 <> tt-tipo-operacao.tipo-operac THEN NEXT.

    RUN validaQtdeFracionada. //Somente com funá∆o REC-VALID-XML-FRAC ativada!
    IF RETURN-VALUE = "ERROR":U THEN DO:
        ASSIGN l-erro-item-proc-fis = YES.
        release msg-ret-nfe.
        RETURN.
    END.

    ASSIGN l-devol-cli      = NO /* Flag devolucao de cliente.           */
           de-frete-item    = 0  /* Totaliza o frete do item corrente.   */
           de-seguro-item   = 0  /* Totaliza o seguro do item corrente.   */
           de-outros-item   = 0  /* Totaliza o outros do item corrente.   */
           de-despesa-item  = 0. /* Totaliza a despesa do item corrente. */
           
    /* Totaliza o frete separadamente da despesa do item. */
    IF  (item-doc-orig-nfe.vl-frete      <> ?
         AND item-doc-orig-nfe.vl-frete  <> 0) THEN
        ASSIGN de-total-frete       = de-total-frete + item-doc-orig-nfe.vl-frete
               de-frete-item        = item-doc-orig-nfe.vl-frete.
    ELSE IF NOT l-vfrete-it AND bf{&TableName}.valor-produto > 0 THEN DO:
        ASSIGN de-frete-item  = TRUNCATE(((bf{&TableName}.valor-frete * ROUND(item-doc-orig-nfe.preco-total, 5)) 
                                                                        / bf{&TableName}.valor-produto),2)
               de-total-frete = de-total-frete + de-frete-item.
    END.
    
    /* Totaliza as demais despesas do item. A despesa do documento sera a despesa do item somada com o frete. */
    IF  (item-doc-orig-nfe.vl-seguro     <> ?
         AND item-doc-orig-nfe.vl-seguro <> 0) THEN
        ASSIGN de-total-desp-docto  = de-total-desp-docto + item-doc-orig-nfe.vl-seguro /* Total da despesa dos itens. */
               de-total-seguro      = de-total-seguro + item-doc-orig-nfe.vl-seguro
               de-seguro-item       = item-doc-orig-nfe.vl-seguro
               de-despesa-item      = item-doc-orig-nfe.vl-seguro. /* Valor da despesa individual do item. */
    ELSE IF NOT l-vseg-it AND bf{&TableName}.valor-produto > 0 THEN DO:    
        ASSIGN de-despesa-item = TRUNCATE(((bf{&TableName}.valor-seguro * ROUND(item-doc-orig-nfe.preco-total, 5)) 
                                                                        / bf{&TableName}.valor-produto),2)
               de-seguro-item  = TRUNCATE(((bf{&TableName}.valor-seguro * ROUND(item-doc-orig-nfe.preco-total, 5)) 
                                                                        / bf{&TableName}.valor-produto),2)
               de-total-seguro = de-total-seguro + TRUNCATE(((bf{&TableName}.valor-seguro * ROUND(item-doc-orig-nfe.preco-total, 5)) 
                                                                        / bf{&TableName}.valor-produto),2).
    END.

    IF  (item-doc-orig-nfe.vl-outros     <> ?
         AND item-doc-orig-nfe.vl-outros <> 0) THEN
        ASSIGN de-total-desp-docto  = de-total-desp-docto + item-doc-orig-nfe.vl-outros /* Total da despesa dos itens. */
               de-total-outros      = de-total-outros + item-doc-orig-nfe.vl-outros
               de-outros-item       = item-doc-orig-nfe.vl-outros
               de-despesa-item      = de-despesa-item + item-doc-orig-nfe.vl-outros. /* Valor da despesa individual do item. */
    ELSE IF NOT l-voutro-it AND bf{&TableName}.valor-produto > 0 then DO:
        ASSIGN de-despesa-item = de-despesa-item + TRUNCATE(((bf{&TableName}.valor-outros * ROUND(item-doc-orig-nfe.preco-total, 5)) 
                                                                        / bf{&TableName}.valor-produto),2)
               de-outros-item  = TRUNCATE(((bf{&TableName}.valor-outros * ROUND(item-doc-orig-nfe.preco-total, 5)) 
                                                                        / bf{&TableName}.valor-produto),2)
               de-total-outros = de-total-outros + TRUNCATE(((bf{&TableName}.valor-outros * ROUND(item-doc-orig-nfe.preco-total, 5)) 
                                                                        / bf{&TableName}.valor-produto),2).
    END.
    
    /* Passa a considerar o tipo operacao no lugar da natureza de operacao */
    IF  NOT param-re.log-1 /* Nao usa FIFO */ 
    OR  item-doc-orig-nfe.numero-ordem > 0
    OR  item-doc-orig-nfe.int-2  =  3 /* tranf */
    OR  (item-doc-orig-nfe.int-2  <> 6 /* Entrada Consignacao */ AND item-doc-orig-nfe.int-2 <> 1)
    OR  (item-doc-orig-nfe.int-2 <> 11 AND item-doc-orig-nfe.int-2 <> 1) THEN DO: /* Material Agregado e Compra */
        ASSIGN l-fifo-oc = NO.
    END.
    ELSE DO:
        ASSIGN l-fifo-oc = item-doc-orig-nfe.log-fifo-oc.
    END.

    FIND FIRST item-fornec
         WHERE item-fornec.cod-emitente = bf{&TableName}.cod-emitente 
           AND item-fornec.it-codigo    = item-doc-orig-nfe.it-codigo
           AND item-fornec.ativo NO-LOCK NO-ERROR.
    IF AVAIL item-fornec THEN
        ASSIGN unid-item-doc-est = item-fornec.unid-med-for.
    ELSE DO:
        FIND FIRST item WHERE item.it-codigo = item-doc-orig-nfe.it-codigo NO-LOCK NO-ERROR.
        IF  AVAIL item AND (item.un = item-doc-orig-nfe.un-comercial OR item.tipo-contr = 4) THEN DO:
            IF  item.un = item-doc-orig-nfe.un-comercial THEN
                ASSIGN unid-item-doc-est = item-doc-orig-nfe.un-comercial.
            IF  item.tipo-contr = 4 THEN
                ASSIGN unid-item-doc-est = item-doc-orig-nfe.un-interna.
        END.
        ELSE DO:
            FIND tab-conv-un
                WHERE tab-conv-un.un           = item-doc-orig-nfe.un-interna
                  AND tab-conv-un.unid-med-for = item-doc-orig-nfe.un-comercial NO-LOCK NO-ERROR.
            IF  AVAIL tab-conv-un THEN
                ASSIGN unid-item-doc-est = item-doc-orig-nfe.un-interna.
            ELSE
                ASSIGN unid-item-doc-est = item-doc-orig-nfe.un-comercial.                             
        END.
    END.
    
    /* Flag que indica se o item foi criado de acordo com a note de terceiros. */
    ASSIGN l-terceiros = NO.
    IF  CAN-FIND(first item-ref-nfe NO-LOCK
                 WHERE item-ref-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                 AND   item-ref-nfe.seq-item           = item-doc-orig-nfe.seq-item          ) THEN DO:

        RUN validarSaldoTercInsuficiente.
        IF RETURN-VALUE = "ERROR":U THEN DO:
            ASSIGN l-erro-item-proc-fis = YES.
            release msg-ret-nfe.
            RETURN.
        END.
        
        FOR EACH item-ref-nfe NO-LOCK
           WHERE item-ref-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
             AND item-ref-nfe.seq-item           = item-doc-orig-nfe.seq-item:
            
            ASSIGN l-reabre-pd = item-ref-nfe.reabre-pd.    

            FOR FIRST saldo-terc NO-LOCK
                WHERE saldo-terc.cod-emitente = item-ref-nfe.cod-emitente
                AND   saldo-terc.nro-docto    = item-ref-nfe.nro-docto   
                AND   saldo-terc.serie-docto  = item-ref-nfe.serie-docto 
                AND   saldo-terc.nat-operacao = item-ref-nfe.nat-operacao
                AND   saldo-terc.it-codigo    = item-ref-nfe.it-codigo   
                AND   saldo-terc.cod-refer    = item-doc-orig-nfe.cod-refer   
                AND   saldo-terc.sequencia    = item-ref-nfe.seq-saldo-terc:
                
                RUN validaSaldoTercTipoOperac (OUTPUT l-saldo-ok).
                IF  l-saldo-ok THEN DO:
                    FOR FIRST componente OF saldo-terc NO-LOCK:

                        RUN criaItemNotaReferFisico.

                        ASSIGN l-terceiros = YES.
                    END.
                END.
                ELSE DO:
                    ASSIGN l-erro-saldo = YES.
                END.
            END.

            /* TRATAMENTO NOTAS DEVOLUCAO DE CLIENTE. */
            IF  NOT AVAIL saldo-terc
                AND NOT AVAIL componente
                AND i-tipo-nota = 2 THEN DO: /* Devolucao de Cliente.*/
                FOR FIRST nota-fiscal NO-LOCK
                    WHERE nota-fiscal.cod-estabel = tt-doc-fisico.cod-estabel
                    AND   nota-fiscal.serie       = item-ref-nfe.serie-docto
                    AND   nota-fiscal.nr-nota-fis = item-ref-nfe.nro-docto:
                    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK
                        WHERE it-nota-fisc.nr-seq-fat = item-ref-nfe.seq-saldo-terc:
                        RUN criaItemNotaDevolFisico.
                        ASSIGN l-devol-cli = YES.
                    END.
                END.
            END.
        END. /* ....FOR EACH item-ref-nfe*/
    END.
    ELSE DO:
    
        ASSIGN l-reabre-pd = NO.

        IF i-tipo-nota = 5          /* Retorno Beneficiamento.  */          
        OR i-tipo-nota = 8 THEN DO: /* Devolucao Consignacao.   */
            FIND FIRST saldo-terc NO-LOCK
                WHERE saldo-terc.cod-emitente = bf{&TableName}.cod-emitente
                AND   saldo-terc.it-codigo    = item-doc-orig-nfe.it-codigo
                AND   saldo-terc.cod-refer    = item-doc-orig-nfe.cod-refer NO-ERROR.
            IF  AVAIL saldo-terc THEN DO:
                RUN validaSaldoTercTipoOperac (OUTPUT l-saldo-ok).

                IF  l-saldo-ok THEN DO:
                    FOR FIRST componente OF saldo-terc NO-LOCK:
                        RUN criaItemNotaReferFisico.
                        ASSIGN l-terceiros = YES.
                    END.
                END.
                ELSE DO:
                    ASSIGN l-erro-saldo = YES
                           l-erro-doc-proc-fis = YES.
                    RUN utp/ut-msgs.p (INPUT "HELP":U,
                                       INPUT 5934,
                                       INPUT item-doc-orig-nfe.seq-item).
                    RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                     INPUT 5934,
                                     INPUT RETURN-VALUE,
                                     INPUT 0).
                    RELEASE msg-ret-nfe. 
                    RETURN "NOK":U.
                END.
            END. /* ....IF  AVAIL saldo-terc THEN */
        END. /* ....IF i-tipo-nota = 5 OR i-tipo-nota = 8 */
    END. /* .. ELSE*/

    /* Cria nota normalmente. */
    IF  NOT l-terceiros AND NOT l-devol-cli THEN DO:
    
        /* Seta o desconto do item */
        if (item-doc-orig-nfe.vl-desconto <> ? and item-doc-orig-nfe.vl-desconto <> 0) then
            assign l-desconto-item   = yes
                   de-desconto-item  = item-doc-orig-nfe.vl-desconto.
        
        /* Seta o frete do item */
        if (item-doc-orig-nfe.vl-frete <> ? and item-doc-orig-nfe.vl-frete <> 0) then
            assign l-frete-item   = yes
                   de-frete-item  = item-doc-orig-nfe.vl-frete.
        
        /* Seta seguro do item */
        if (item-doc-orig-nfe.vl-seguro <> ? and item-doc-orig-nfe.vl-seguro <> 0) then
            assign l-seguro-item   = yes
                   de-seguro-item  = item-doc-orig-nfe.vl-seguro.
                   
        /* Seta as demais despesas do item */
        if (item-doc-orig-nfe.vl-outros <> ? and item-doc-orig-nfe.vl-outros <> 0) then
            assign l-outros-item   = yes
                   de-outros-item  = item-doc-orig-nfe.vl-outros.

        /* Se nao houver quebra, tem que somar as quantidades. */
        /* Se houver quebra, tem que criar nova sequencia.     */
        IF  item-doc-orig-nfe.log-fifo-oc
            AND CAN-FIND(FIRST tt-rat-ordem-orig-nfe-aux
                         WHERE tt-rat-ordem-orig-nfe-aux.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                         AND   tt-rat-ordem-orig-nfe-aux.seq-item           = item-doc-orig-nfe.seq-item) THEN DO:

            /* Variaveis para controle de valores residuais devido a arredondamentos. */
            ASSIGN de-soma-desconto-fifo = 0
                   de-soma-frete-fifo    = 0
                   de-soma-seguro-fifo   = 0
                   de-soma-outros-fifo   = 0.
            
            IF  l-desconto-item THEN
                ASSIGN de-desconto-unit = de-desconto-item / item-doc-orig-nfe.qtd-comercial.
            ELSE
                ASSIGN de-desconto-unit = 0.
                
            /* Calcula o valor unitario do frete para ratear o frete entre os itens. */
            IF  l-frete-item THEN
                ASSIGN de-frete-unit = de-frete-item / item-doc-orig-nfe.qtd-comercial.
            ELSE
                ASSIGN de-frete-unit = 0.
            
            /* Caso o seguro e outros tenham sido informados por item, rateia os valores  **
            ** entre as sequencias criadas pelo FIFO para totalizar nas despesas do item. */
            IF  l-seguro-item THEN
                ASSIGN de-seguro-unit = de-seguro-item / item-doc-orig-nfe.qtd-comercial.
            ELSE
                ASSIGN de-seguro-unit = 0.
            
            IF  l-outros-item THEN
                ASSIGN de-outros-unit = de-outros-item / item-doc-orig-nfe.qtd-comercial.
            ELSE
                ASSIGN de-outros-unit = 0.

            FOR EACH tt-rat-ordem-orig-nfe-aux
                WHERE tt-rat-ordem-orig-nfe-aux.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                AND   tt-rat-ordem-orig-nfe-aux.seq-item           = item-doc-orig-nfe.seq-item
                BREAK BY tt-rat-ordem-orig-nfe-aux.ctrl-quebra:

                /* Soma as quantidades selecionadas por FIFO para setar a quantidade da nota. */
                ASSIGN de-soma-fifo       = de-soma-fifo       + tt-rat-ordem-orig-nfe-aux.qtd-interna 
                       de-soma-fifo-emit  = de-soma-fifo-emit  + tt-rat-ordem-orig-nfe-aux.val-quant-emit
                       de-total-fifo      = de-total-fifo      + tt-rat-ordem-orig-nfe-aux.qtd-interna    /* Nao Ç zerada ao quebrar os itens. */
                       de-total-fifo-emit = de-total-fifo-emit + tt-rat-ordem-orig-nfe-aux.val-quant-emit  /* Nao Ç zerada ao quebrar os itens. */
                       tt-rat-ordem-orig-nfe-aux.seq-item-doc-est = i-seq-item.
                
                /* 12/12/2011: conforme teste no RE1001, quando sao selecionadas duas ordens  **
                ** diferentes e nao ≤ feita a quebra de sequencia pelo FIFO, o produto usa o  **
                ** deposito, localizacao e referencia que foram informados na primeira ordem. */
                IF  FIRST-OF(ctrl-quebra) THEN DO:
                    
                    /* Inicializa as variaveis. */
                    ASSIGN c-cod-depos      = ""
                           c-cod-localiz    = ""
                           c-cod-refer      = ""
                           i-nr-ord-produ   = 0.
                    
                    /* Sugestao de localizacao unica. */
                    FOR FIRST item-uni-estab NO-LOCK
                        WHERE item-uni-estab.it-codigo   = item-doc-orig-nfe.it-codigo
                          AND item-uni-estab.cod-estabel = bf{&TableName}.cod-estabel:
                        IF item-uni-estab.loc-unica THEN
                            ASSIGN c-cod-localiz = item-uni-estab.cod-localiz.
                    END.
                    /*** FIM SUGESTAO DEPOSITO/LOCALIZACAO ***/

                    /*** REFERENCIA ***/
                    FOR FIRST item NO-LOCK
                        WHERE item.it-codigo    = item-doc-orig-nfe.it-codigo
                          AND item.tipo-con-est = 4, /* Referencia */
                        FIRST prazo-compra NO-LOCK
                        WHERE prazo-compra.numero-ordem = tt-rat-ordem-orig-nfe-aux.numero-ordem
                          AND prazo-compra.parcela      = tt-rat-ordem-orig-nfe-aux.parcela:

                        ASSIGN c-cod-refer = prazo-compra.cod-refer.
                    END.
                    /*** FIM SUGESTAO REFERENCIA ***/

                    /*** ORDEM DE PRODUCAO ***/
                    FOR FIRST ordem-compra NO-LOCK
                        WHERE ordem-compra.numero-ordem = tt-rat-ordem-orig-nfe-aux.numero-ordem:
                        ASSIGN i-nr-ord-produ = ordem-compra.ordem-servic.

                        // caso seja item com CQ, o deposito de CQ j† ir† constar na item-doc-orig-nfe.cod-depos
                        if avail item-uni-estab and not item-uni-estab.contr-qualid then
                            assign c-cod-depos = ordem-compra.dep-almoxar.
                    END.
                    /*** FIM SUGESTAO ORDEM DE PRODUCAO ***/
                END.
                
                CREATE tt-rat-ordem.
                ASSIGN tt-rat-ordem.nro-docto    = bf{&TableName}.nro-docto
                       tt-rat-ordem.serie-docto  = bf{&TableName}.serie-docto
                       tt-rat-ordem.cod-emitente = bf{&TableName}.cod-emitente
                       tt-rat-ordem.sequencia    = i-seq-item
                       tt-rat-ordem.tipo-nota    = i-tipo-nota
                       tt-rat-ordem.qtidade-forn = tt-rat-ordem-orig-nfe-aux.val-quant-emit
                       tt-rat-ordem.quantidade   = tt-rat-ordem-orig-nfe-aux.qtd-interna
                       tt-rat-ordem.num-pedido   = tt-rat-ordem-orig-nfe-aux.num-pedido
                       tt-rat-ordem.numero-ordem = tt-rat-ordem-orig-nfe-aux.numero-ordem
                       tt-rat-ordem.parcela      = tt-rat-ordem-orig-nfe-aux.parcela
                       tt-rat-ordem.encerrada    = tt-rat-ordem-orig-nfe-aux.encerrada.
                       
                IF  LAST-OF(tt-rat-ordem-orig-nfe-aux.ctrl-quebra) THEN DO:
                    CREATE tt-it-doc-fisico.
                    ASSIGN tt-it-doc-fisico.nro-docto      = bf{&TableName}.nro-docto
                           tt-it-doc-fisico.serie-docto    = bf{&TableName}.serie-docto
                           tt-it-doc-fisico.cod-emitente   = bf{&TableName}.cod-emitente
                           tt-it-doc-fisico.tipo-nota      = i-tipo-nota
                           tt-it-doc-fisico.fifo-oc        = YES
                           tt-it-doc-fisico.sequencia      = i-seq-item
                           i-seq-item                      = i-seq-item + IF param-re.inc-seq > 0 THEN param-re.inc-seq ELSE 10
                           tt-it-doc-fisico.it-codigo      = item-doc-orig-nfe.it-codigo
                           tt-it-doc-fisico.quantidade     = de-soma-fifo
                           tt-it-doc-fisico.qt-do-forn     = de-soma-fifo-emit
                           tt-it-doc-fisico.preco-unit     = ROUND(item-doc-orig-nfe.preco-unit, 5)
                           tt-it-doc-fisico.preco-total    = ROUND((tt-it-doc-fisico.preco-unit * tt-it-doc-fisico.qt-do-forn), 5)
                           /* Informacoes relacionamento FIFO. */ 
                           tt-it-doc-fisico.num-pedido     = 0
                           tt-it-doc-fisico.numero-ordem   = 0
                           tt-it-doc-fisico.parcela        = 0
                           tt-it-doc-fisico.ct-codigo      = tt-rat-ordem-orig-nfe-aux.ct-codigo
                           tt-it-doc-fisico.sc-codigo      = tt-rat-ordem-orig-nfe-aux.sc-codigo
                           tt-it-doc-fisico.num-ord-inv    = tt-rat-ordem-orig-nfe-aux.num-ord-inv
                           tt-it-doc-fisico.nr-ord-produ   = IF i-nr-ord-produ > 0 THEN i-nr-ord-produ ELSE item-doc-orig-nfe.nr-ord-produ
                           tt-it-doc-fisico.encerra-pa     = NO
                           tt-it-doc-fisico.un             = unid-item-doc-est
                           tt-it-doc-fisico.narrativa      = item-doc-orig-nfe.narrativa
                           tt-it-doc-fisico.reabre-pd      = l-reabre-pd 
                           /************************************/
                           /* Em alguns casos o programa arredonda o valor do desconto para cima, fazendo com que a soma **
                           ** do desconto dos itens seja maior que o desconto da nota. Como solucao, trunca o desconto   **
                           ** para que a soma dos valores individuais dos itens tenha tendencia a ser menor que o total  **
                           ** da nota. O desconto que restar sera tratado como desconto residual.                        */
                           tt-it-doc-fisico.desconto       = TRUNC(de-desconto-unit * tt-it-doc-fisico.qt-do-forn, 2)
                           tt-it-doc-fisico.cod-refer      = IF c-cod-refer > "" THEN c-cod-refer ELSE item-doc-orig-nfe.cod-refer
                           tt-it-doc-fisico.cod-depos      = IF c-cod-depos > "" THEN c-cod-depos ELSE item-doc-orig-nfe.cod-depos     
                           tt-it-doc-fisico.cod-localiz    = IF c-cod-localiz > "" THEN c-cod-localiz ELSE item-doc-orig-nfe.cod-localiz
                           tt-it-doc-fisico.lote           = item-doc-orig-nfe.lote-serie
                           tt-it-doc-fisico.dt-vali-lote   = item-doc-orig-nfe.dt-vali-lote
                           tt-it-doc-fisico.baixa-ce       = (item-doc-orig-nfe.int-2 <> 11) /* N∆o baixa ce somente se for material agregado */
                           tt-it-doc-fisico.num-seq-event  = item-doc-orig-nfe.int-1 /* EVENTO - Adicionado para correªío da validacao de valor. */
                           tt-it-doc-fisico.vl-frete       = TRUNC(de-frete-unit * tt-it-doc-fisico.qt-do-forn, 2)
                           tt-it-doc-fisico.despesas       = tt-it-doc-fisico.vl-frete
                                                             + TRUNC(de-seguro-unit * tt-it-doc-fisico.qt-do-forn, 2)
                                                             + TRUNC(de-outros-unit * tt-it-doc-fisico.qt-do-forn, 2)
                           tt-it-doc-fisico.cod-unid-negoc          = tt-rat-ordem-orig-nfe-aux.cod-unid-neg
                           tt-it-doc-fisico.log-usa-unid-negoc-fifo = tt-rat-ordem-orig-nfe-aux.log-livre-1
                           OVERLAY(tt-it-doc-fisico.char-2,42,5) = STRING(item-doc-orig-nfe.seq-item)
                           tt-it-doc-fisico.ind-bem-movel-usado  = IF lNT2024002 THEN item-doc-orig-nfe.ind-bem-movel-usado else no
                           tt-it-doc-fisico.log-doacao           = IF lNT2024002 THEN item-doc-orig-nfe.log-doacao else no.
                           /**********************************************************************************************/
                           
                    /*******************Informaá‰es grupo de combust°vel********************/
                    ASSIGN tt-it-doc-fisico.cod-prod-anp = item-doc-orig-nfe.cod-prod-anp /*cProdANP */
                    &IF '{&product_version}' >= "12.1.X.2205"  &THEN
                           tt-it-doc-fisico.desc-anp     = item-doc-orig-nfe.desc-anp     /*descANP  */
                           tt-it-doc-fisico.perc-glp     = item-doc-orig-nfe.perc-glp     /*pGLP     */
                           tt-it-doc-fisico.perc-gnn     = item-doc-orig-nfe.perc-gnn     /*pGNn     */
                           tt-it-doc-fisico.perc-gni     = item-doc-orig-nfe.perc-gni     /*pGNi     */
                           tt-it-doc-fisico.valor-part   = item-doc-orig-nfe.valor-part.  /*vPart    */
                    &ELSE
                           tt-it-doc-fisico.desc-anp     = trim(substring(item-doc-orig-nfe.char-2,1,95))         /*descANP */
                           tt-it-doc-fisico.perc-glp     = dec(trim(substring(item-doc-orig-nfe.char-2,96,8)))    /*pGLP    */
                           tt-it-doc-fisico.perc-gnn     = dec(trim(substring(item-doc-orig-nfe.char-2,104,8)))   /*pGNn    */
                           tt-it-doc-fisico.perc-gni     = dec(trim(substring(item-doc-orig-nfe.char-2,112,8)))   /*pGNi    */
                           tt-it-doc-fisico.valor-part   = dec(trim(substring(item-doc-orig-nfe.char-2,120,16))). /*vPart   */
                    &ENDIF
                    /***********************************************************************/
                    
                    /* Ao fim da quebra atual, zera as variaveis para uso na proxima quebra. */
                    ASSIGN de-soma-fifo          = 0 
                           de-soma-fifo-emit     = 0
                           de-soma-desconto-fifo = de-soma-desconto-fifo + tt-it-doc-fisico.desconto
                           de-soma-frete-fifo    = de-soma-frete-fifo    + tt-it-doc-fisico.vl-frete
                           de-soma-seguro-fifo   = de-soma-seguro-fifo   + TRUNC(de-seguro-unit * tt-it-doc-fisico.qt-do-forn, 2)
                           de-soma-outros-fifo   = de-soma-outros-fifo   + TRUNC(de-outros-unit * tt-it-doc-fisico.qt-do-forn, 2).

                END. /* END IF LAST-OF(tt-rat-ordem-orig-nfe-aux.ctrl-quebra */

            END. /* END FOR EACH tt-rat-ordem-orig-nfe-aux */
            
            /* Apos ser realizada toda a quebra de FIFO, valida se foi selecionada quantidade suficiente. */
            IF  de-total-fifo < item-doc-orig-nfe.qtd-interna THEN DO:

                /* PONTO UPC DENSO - CHAMADO TDJQD5 / UNIMED - CHAMADO TEVA20 - RETORNA PARAMETRO "ATUALIZA SEM PEDIDO" */
                IF  c-nom-prog-upc-mg97 <> "" THEN DO:
                    FOR EACH tt-epc WHERE tt-epc.cod-event = "RecNotaSemBaixarPed":
                        DELETE tt-epc.
                    END.
                    
                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "RecNotaSemBaixarPed"
                           tt-epc.cod-parameter = "sem-pedido".
            
                    {include/i-epc201.i "RecNotaSemBaixarPed"}
            
                    FOR FIRST tt-epc
                        WHERE tt-epc.cod-event     = "RecNotaSemBaixarPed"
                        AND   tt-epc.cod-parameter = "sem-pedido"
                        AND   tt-epc.val-parameter = "valida":
                        ASSIGN l-sem-pedido = NO.
                    END.
                END.
                
                /* Se o usuario tem permissao para receber sem baixar pedido, cria sequencia com o que sobrou. */
                IF  AVAIL param-re AND l-sem-pedido THEN DO:
                    CREATE tt-it-doc-fisico.
                    ASSIGN tt-it-doc-fisico.nro-docto      = bf{&TableName}.nro-docto
                           tt-it-doc-fisico.serie-docto    = bf{&TableName}.serie-docto
                           tt-it-doc-fisico.cod-emitente   = bf{&TableName}.cod-emitente
                           tt-it-doc-fisico.tipo-nota      = i-tipo-nota
                           tt-it-doc-fisico.fifo-oc        = NO
                           tt-it-doc-fisico.sequencia      = i-seq-item
                           i-seq-item                      = i-seq-item + IF param-re.inc-seq > 0 THEN param-re.inc-seq ELSE 10
                           tt-it-doc-fisico.it-codigo      = item-doc-orig-nfe.it-codigo
                           tt-it-doc-fisico.quantidade     = ROUND((item-doc-orig-nfe.qtd-interna - de-total-fifo), 5)
                           tt-it-doc-fisico.qt-do-forn     = ROUND((item-doc-orig-nfe.qtd-comercial - de-total-fifo-emit), 5)
                           tt-it-doc-fisico.preco-unit     = ROUND(item-doc-orig-nfe.preco-unit, 5)
                           tt-it-doc-fisico.preco-total    = ROUND((tt-it-doc-fisico.preco-unit * tt-it-doc-fisico.qt-do-forn), 5)
                           /* Informacoes relacionamento FIFO. */ 
                           tt-it-doc-fisico.num-pedido     = 0
                           tt-it-doc-fisico.numero-ordem   = 0
                           tt-it-doc-fisico.parcela        = 0
                           tt-it-doc-fisico.ct-codigo      = tt-rat-ordem-orig-nfe-aux.ct-codigo
                           tt-it-doc-fisico.sc-codigo      = tt-rat-ordem-orig-nfe-aux.sc-codigo
                           tt-it-doc-fisico.num-ord-inv    = 0
                           tt-it-doc-fisico.nr-ord-produ   = item-doc-orig-nfe.nr-ord-produ
                           tt-it-doc-fisico.encerra-pa     = NO
                           tt-it-doc-fisico.un             = unid-item-doc-est
                           tt-it-doc-fisico.desconto       = TRUNC(de-desconto-unit * tt-it-doc-fisico.qt-do-forn, 2)
                           tt-it-doc-fisico.cod-refer      = item-doc-orig-nfe.cod-refer    
                           tt-it-doc-fisico.cod-depos      = item-doc-orig-nfe.cod-depos     
                           tt-it-doc-fisico.cod-localiz    = item-doc-orig-nfe.cod-localiz
                           tt-it-doc-fisico.narrativa      = item-doc-orig-nfe.narrativa
                           tt-it-doc-fisico.reabre-pd      = l-reabre-pd
                           /************************************/
                           tt-it-doc-fisico.lote           = item-doc-orig-nfe.lote-serie
                           tt-it-doc-fisico.dt-vali-lote   = item-doc-orig-nfe.dt-vali-lote
                           tt-it-doc-fisico.baixa-ce       = (item-doc-orig-nfe.int-2 <> 11) /* N∆o baixa ce somente se for material agregado */
                           tt-it-doc-fisico.num-seq-event  = item-doc-orig-nfe.int-1 /* EVENTO - Adicionado para correªío da validacao de valor. */
                           tt-it-doc-fisico.vl-frete       = TRUNC(de-frete-unit * tt-it-doc-fisico.qt-do-forn, 2)
                           tt-it-doc-fisico.despesas       = tt-it-doc-fisico.vl-frete
                                                             + TRUNC(de-seguro-unit * tt-it-doc-fisico.qt-do-forn, 2) 
                                                             + TRUNC(de-outros-unit * tt-it-doc-fisico.qt-do-forn, 2)
                           tt-it-doc-fisico.cod-unid-negoc  =  tt-rat-ordem-orig-nfe-aux.cod-unid-neg
                           OVERLAY(tt-it-doc-fisico.char-2,42,5) = STRING(item-doc-orig-nfe.seq-item)
                           tt-it-doc-fisico.ind-bem-movel-usado  = IF lNT2024002 THEN item-doc-orig-nfe.ind-bem-movel-usado else no
                           tt-it-doc-fisico.log-doacao           = IF lNT2024002 THEN item-doc-orig-nfe.log-doacao else no.
                           
                    /**********************************************************************************************/
                    /*******************Informaá‰es grupo de combust°vel********************/
                    ASSIGN tt-it-doc-fisico.cod-prod-anp = item-doc-orig-nfe.cod-prod-anp /*cProdANP */
                    &IF '{&product_version}' >= "12.1.X.2205"  &THEN
                           tt-it-doc-fisico.desc-anp     = item-doc-orig-nfe.desc-anp     /*descANP  */
                           tt-it-doc-fisico.perc-glp     = item-doc-orig-nfe.perc-glp     /*pGLP     */
                           tt-it-doc-fisico.perc-gnn     = item-doc-orig-nfe.perc-gnn     /*pGNn     */
                           tt-it-doc-fisico.perc-gni     = item-doc-orig-nfe.perc-gni     /*pGNi     */
                           tt-it-doc-fisico.valor-part   = item-doc-orig-nfe.valor-part.  /*vPart    */
                    &ELSE
                           tt-it-doc-fisico.desc-anp     = trim(substring(item-doc-orig-nfe.char-2,1,95))         /*descANP */
                           tt-it-doc-fisico.perc-glp     = dec(trim(substring(item-doc-orig-nfe.char-2,96,8)))    /*pGLP    */
                           tt-it-doc-fisico.perc-gnn     = dec(trim(substring(item-doc-orig-nfe.char-2,104,8)))   /*pGNn    */
                           tt-it-doc-fisico.perc-gni     = dec(trim(substring(item-doc-orig-nfe.char-2,112,8)))   /*pGNi    */
                           tt-it-doc-fisico.valor-part   = dec(trim(substring(item-doc-orig-nfe.char-2,120,16))). /*vPart   */
                    &ENDIF
                    /***********************************************************************/
                    ASSIGN de-soma-frete-fifo    = de-soma-frete-fifo    + tt-it-doc-fisico.vl-frete
                           de-soma-desconto-fifo = de-soma-desconto-fifo + tt-it-doc-fisico.desconto
                           de-soma-seguro-fifo   = de-soma-seguro-fifo   + TRUNC(de-seguro-unit * tt-it-doc-fisico.qt-do-forn, 2)
                           de-soma-outros-fifo   = de-soma-outros-fifo   + TRUNC(de-outros-unit * tt-it-doc-fisico.qt-do-forn, 2).
                END.
                ELSE DO:
                    /* Nao permite gerar nota sem saldar todo o FIFO manual. */

                    {utp/ut-liter.i "Quantidade" *}
                    ASSIGN c-msg-aux = RETURN-VALUE + " " + STRING(de-total-fifo) + " ".
                    {utp/ut-liter.i "selecionada_por_FIFO_insuficiente_para_o_item" *}
                    ASSIGN c-msg-aux = c-msg-aux + RETURN-VALUE + " " + STRING(item-doc-orig-nfe.seq-item) + ".".
                    RUN implantaErro(INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                     INPUT 17006,
                                     INPUT c-msg-aux,
                                     INPUT 0).
                    ASSIGN l-erro-doc-proc-fis  = YES
                           l-erro-item-proc-fis = YES
                           l-erro-rat-proc-fis  = YES.
                    release msg-ret-nfe.
                    RETURN.
                END.

            END. /* END IF de-total-fifo < item-doc-orig-nfe.qtd-interna */

            /* Calcula o desconto residual do item para acertar os valores caso **
            ** o desconto total dos itens tenha sido arredondado pelo programa. */
            IF  l-desconto-item THEN DO:
                IF  de-soma-desconto-fifo < de-desconto-item THEN DO:
                    ASSIGN tt-it-doc-fisico.desconto = tt-it-doc-fisico.desconto + (de-desconto-item - de-soma-desconto-fifo).
                END.
            END.
            
            /* Calcula o frete residual do item e soma o frete na despesa. */
            IF  l-frete-item THEN DO:
                IF  de-soma-frete-fifo < de-frete-item THEN DO:
                    ASSIGN tt-it-doc-fisico.vl-frete = tt-it-doc-fisico.vl-frete + (de-frete-item - de-soma-frete-fifo)
                           tt-it-doc-fisico.despesas = tt-it-doc-fisico.despesas + (de-frete-item - de-soma-frete-fifo).
                END.
            END.

            /* Calcula o seguro residual do item e soma na despesa. */
            IF  l-seguro-item THEN DO:
                IF  de-soma-seguro-fifo < de-seguro-item THEN DO:
                    ASSIGN tt-it-doc-fisico.despesas = tt-it-doc-fisico.despesas + (de-seguro-item - de-soma-seguro-fifo).
                END.
            END.

            /* Calcula outros valores residuais do item e soma na despesa. */
            IF  l-outros-item THEN DO:
                IF  de-soma-outros-fifo < de-outros-item THEN DO:
                    ASSIGN tt-it-doc-fisico.despesas = tt-it-doc-fisico.despesas + (de-outros-item - de-soma-outros-fifo).
                END.
            END.

        END. /* END IF item-doc-orig-nfe.log-fifo-oc */
        ELSE DO:
        
            CREATE tt-it-doc-fisico.
            ASSIGN tt-it-doc-fisico.nro-docto       =  bf{&TableName}.nro-docto
                   tt-it-doc-fisico.serie-docto     =  bf{&TableName}.serie-docto
                   tt-it-doc-fisico.cod-emitente    =  bf{&TableName}.cod-emitente
                   tt-it-doc-fisico.tipo-nota       =  i-tipo-nota
                   tt-it-doc-fisico.fifo-oc         =  l-fifo-oc 
                   tt-it-doc-fisico.sequencia       =  i-seq-item
                   i-seq-item                       =  i-seq-item + IF param-re.inc-seq > 0 THEN param-re.inc-seq ELSE 10
                   tt-it-doc-fisico.it-codigo       =  item-doc-orig-nfe.it-codigo
                   tt-it-doc-fisico.quantidade      =  item-doc-orig-nfe.qtd-interna
                   tt-it-doc-fisico.nro-comp        =  ""
                   tt-it-doc-fisico.serie-comp      =  ""
                   tt-it-doc-fisico.nat-comp        =  bf{&TableName}.nat-oper-comp
                   tt-it-doc-fisico.seq-comp        =  0
                   tt-it-doc-fisico.cod-depos       =  item-doc-orig-nfe.cod-depos
                   tt-it-doc-fisico.cod-refer       =  item-doc-orig-nfe.cod-refer
                   tt-it-doc-fisico.lote            =  item-doc-orig-nfe.lote-serie
                   tt-it-doc-fisico.dt-vali-lote    =  item-doc-orig-nfe.dt-vali-lote
                   tt-it-doc-fisico.nr-ord-produ    =  item-doc-orig-nfe.nr-ord-produ
                   tt-it-doc-fisico.cod-localiz     =  item-doc-orig-nfe.cod-localiz
                   tt-it-doc-fisico.ct-codigo       =  item-doc-orig-nfe.ct-codigo
                   tt-it-doc-fisico.sc-codigo       =  item-doc-orig-nfe.sc-codigo
                   tt-it-doc-fisico.desconto        =  IF item-doc-orig-nfe.vl-desconto = ? THEN 0 ELSE item-doc-orig-nfe.vl-desconto
                   tt-it-doc-fisico.preco-total     =  ROUND(item-doc-orig-nfe.preco-total, 5)
                   tt-it-doc-fisico.preco-unit      =  ROUND(item-doc-orig-nfe.preco-unit, 5)
                   tt-it-doc-fisico.qt-do-forn      =  item-doc-orig-nfe.qtd-comercial
                   tt-it-doc-fisico.un              =  unid-item-doc-est
                   tt-it-doc-fisico.narrativa       =  item-doc-orig-nfe.narrativa
                   tt-it-doc-fisico.num-pedido      =  item-doc-orig-nfe.num-pedido
                   tt-it-doc-fisico.numero-ordem    =  item-doc-orig-nfe.numero-ordem
                   i-num-pedido                     =  item-doc-orig-nfe.num-pedido
                   tt-it-doc-fisico.parcela         =  item-doc-orig-nfe.parcela
                   tt-it-doc-fisico.encerra-pa      =  IF item-doc-orig-nfe.encerra-pa = ? THEN NO ELSE item-doc-orig-nfe.encerra-pa
                   tt-it-doc-fisico.baixa-ce        =  (item-doc-orig-nfe.int-2 <> 11) /* N∆o baixa ce somente se for material agregado */
                   tt-it-doc-fisico.num-seq-event   =  item-doc-orig-nfe.int-1 /* EVENTO - Adicionado para correá∆o da validacao de valor. */
                   tt-it-doc-fisico.vl-frete        =  de-frete-item
                   tt-it-doc-fisico.despesas        =  de-despesa-item + de-frete-item
                   tt-it-doc-fisico.cod-unid-negoc  =  item-doc-orig-nfe.cod-unid-negoc
                   tt-it-doc-fisico.reabre-pd       = l-reabre-pd
                   OVERLAY(tt-it-doc-fisico.char-2,42,5) = STRING(item-doc-orig-nfe.seq-item)
                   tt-it-doc-fisico.ind-bem-movel-usado  = IF lNT2024002 THEN item-doc-orig-nfe.ind-bem-movel-usado else no
                   tt-it-doc-fisico.log-doacao           = IF lNT2024002 THEN item-doc-orig-nfe.log-doacao else no.

            /*******************Informaá‰es grupo de combust°vel********************/
            ASSIGN tt-it-doc-fisico.cod-prod-anp = item-doc-orig-nfe.cod-prod-anp /*cProdANP */
                   tt-it-doc-fisico.desc-anp     = item-doc-orig-nfe.desc-anp     /*descANP  */
                   tt-it-doc-fisico.perc-glp     = item-doc-orig-nfe.perc-glp     /*pGLP     */
                   tt-it-doc-fisico.perc-gnn     = item-doc-orig-nfe.perc-gnn     /*pGNn     */
                   tt-it-doc-fisico.perc-gni     = item-doc-orig-nfe.perc-gni     /*pGNi     */
                   tt-it-doc-fisico.valor-part   = item-doc-orig-nfe.valor-part.  /*vPart    */
            /***********************************************************************/

            IF l-unidade-negocio AND l-mat-unid-negoc AND tt-it-doc-fisico.cod-unid-negoc = "" THEN DO:
                if not valid-handle(h-cdapi024) then
                   run cdp/cdapi024.p persistent set h-cdapi024.

                if valid-handle(h-cdapi024) THEN
                  run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input  tt-doc-fisico.cod-estabel,
                                                                     input  tt-it-doc-fisico.it-codigo,
                                                                     input  tt-it-doc-fisico.cod-depos,
                                                                     output c-cod-unid-negoc).

                ASSIGN tt-it-doc-fisico.cod-unid-negoc = c-cod-unid-negoc.
                DELETE PROCEDURE h-cdapi024 NO-ERROR.
                ASSIGN h-cdapi024 = ?.
            END.
            
            IF NOT tt-it-doc-fisico.fifo-oc THEN DO: /* Nao eh Fifo */
                /* Quando Ç informado apenas o pedido busca a primeira ordem com data de entrega mais antiga */
                IF  tt-it-doc-fisico.num-pedido  <> 0 AND 
                    tt-it-doc-fisico.numero-ordem = 0 THEN DO:
                    FOR EACH ordem-compra
                       WHERE ordem-compra.num-pedido = tt-it-doc-fisico.num-pedido
                         AND ordem-compra.situacao   = 2
                         AND (ordem-compra.it-codigo  = tt-it-doc-fisico.it-codigo OR tt-it-doc-fisico.it-codigo = " ") NO-LOCK,
                       FIRST prazo-compra USE-INDEX ordem-sit NO-LOCK
                       WHERE prazo-compra.numero-ordem  = ordem-compra.numero-ordem
                         AND prazo-compra.situacao      = 2
                         AND (prazo-compra.quant-saldo - prazo-compra.dec-1 > 0)
                          BY prazo-compra.data-entrega
                          BY prazo-compra.numero-ordem:
                       ASSIGN tt-it-doc-fisico.numero-ordem = ordem-compra.numero-ordem
                              tt-it-doc-fisico.parcela      = IF tt-it-doc-fisico.parcela = 0 THEN prazo-compra.parcela ELSE tt-it-doc-fisico.parcela.
                    END.
                END.        
                
                /* Quando Ç informado apenas a ordem de compra busca o pedido da ordem */
                IF  tt-it-doc-fisico.num-pedido    = 0 AND 
                    tt-it-doc-fisico.numero-ordem <> 0 THEN DO:
                    FIND FIRST ordem-compra NO-LOCK
                         WHERE ordem-compra.numero-ordem = tt-it-doc-fisico.numero-ordem NO-ERROR.
                    IF AVAIL ordem-compra AND 
                       ordem-compra.num-pedido <> 0 THEN
                        ASSIGN tt-it-doc-fisico.num-pedido = ordem-compra.num-pedido.
                END. 
                 
                /** BUSCA PARCELA DA OC **/
                IF  tt-it-doc-fisico.numero-ordem > 0 AND
                    tt-it-doc-fisico.parcela      = 0 THEN DO:
                    
                    /* Busca a parcela mais antiga da ordem de compra com saldo */
                    FOR FIRST prazo-compra USE-INDEX ordem-sit NO-LOCK
                        WHERE prazo-compra.numero-ordem = tt-it-doc-fisico.numero-ordem 
                          AND prazo-compra.situacao = 2 
                          AND (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0  
                           BY prazo-compra.data-entrega 
                           BY prazo-compra.numero-ordem:
                        ASSIGN tt-it-doc-fisico.parcela = prazo-compra.parcela.
                    END.
              
                    /* Caso n∆o encontre uma parcela com saldo, busca a primeira parcela confirmada da ordem */
                    IF  tt-it-doc-fisico.parcela = 0 THEN
                        FOR FIRST prazo-compra USE-INDEX ordem-sit NO-LOCK
                            WHERE prazo-compra.numero-ordem = tt-it-doc-fisico.numero-ordem 
                              AND prazo-compra.situacao     = 2
                              BY prazo-compra.data-entrega
                              BY prazo-compra.numero-ordem:
                            ASSIGN tt-it-doc-fisico.parcela = prazo-compra.parcela.
                        END.
                END.
            END. /*IF NOT tt-it-doc-fisico.fifo-oc*/  
     
            /* Busca documento de sa°da para notas de transferància. */
            IF  tt-it-doc-fisico.tipo-nota = 3 THEN DO:
                FOR EACH saldo-terc NO-LOCK
                    WHERE saldo-terc.serie-docto  =  tt-doc-fisico.serie-docto
                    AND   saldo-terc.nro-docto    =  tt-doc-fisico.nro-docto
                    AND   saldo-terc.cod-emitente =  tt-doc-fisico.cod-emitente                   
                    AND   saldo-terc.it-codigo    =  item-doc-orig-nfe.it-codigo
                    AND   saldo-terc.cod-estabel  =  tt-doc-fisico.estab-de-or
                    BY saldo-terc.sequencia:
                    
                    IF  NOT CAN-FIND(FIRST tt-seq-saldo-terc WHERE tt-seq-saldo-terc.sequencia = saldo-terc.sequencia) THEN DO:
                        
                        CREATE tt-seq-saldo-terc.
                        ASSIGN tt-seq-saldo-terc.sequencia  = saldo-terc.sequencia
                               tt-it-doc-fisico.nro-comp    =  saldo-terc.nro-docto
                               tt-it-doc-fisico.serie-comp  =  saldo-terc.serie-docto
                               tt-it-doc-fisico.nat-comp    =  saldo-terc.nat-operacao
                               tt-it-doc-fisico.seq-comp    =  saldo-terc.sequencia.                               
                                                      
                        if not can-find(first fat-ser-lote
                                        where fat-ser-lote.cod-estabel      = saldo-terc.cod-estabel
                                          and fat-ser-lote.serie            = saldo-terc.serie-docto
                                          and fat-ser-lote.nr-nota-fis      = saldo-terc.nro-docto
                                          and fat-ser-lote.nr-seq-fat       = saldo-terc.sequencia
                                          and fat-ser-lote.it-codigo        = saldo-terc.it-codigo) then do:
                            
                            if tt-it-doc-fisico.cod-refer = "" then 
                               assign tt-it-doc-fisico.cod-refer = saldo-terc.cod-refer.

                            if tt-it-doc-fisico.cod-localiz = "" then
                               assign tt-it-doc-fisico.cod-localiz = saldo-terc.cod-localiz.

                            if tt-it-doc-fisico.cod-depos = "" then
                               assign tt-it-doc-fisico.cod-depos = saldo-terc.cod-depos.                               
                            
                            /*DMANRECEB-4540 - Verifica se a localizaá∆o da origem existe no destino*/
                            if not can-find(first localizacao
                                            where localizacao.cod-estabel = tt-doc-fisico.cod-estabel
                                              and localizacao.cod-depos   = tt-it-doc-fisico.cod-depos
                                              and localizacao.cod-localiz = tt-it-doc-fisico.cod-localiz) then do:
                                for first item-uni-estab
                                    where item-uni-estab.cod-estabel = tt-doc-fisico.cod-estabel
                                      and item-uni-estab.it-codigo   = tt-it-doc-fisico.it-codigo no-lock:
                                end.
                                if  avail item-uni-estab then
                                    assign tt-it-doc-fisico.cod-depos   = item-uni-estab.deposito-pad
                                           tt-it-doc-fisico.cod-localiz = item-uni-estab.cod-localiz.
                            end.
                        end.        
                        LEAVE.
                    END.
                    ELSE
                        NEXT.
                END.
            END.
            
            IF  item-doc-orig-nfe.num-pedido <> 0 THEN DO:
                IF  tt-it-doc-fisico.nr-ord-produ = 0 THEN DO:
                    FIND FIRST ordem-compra NO-LOCK WHERE ordem-compra.numero-ordem = item-doc-orig-nfe.numero-ordem NO-ERROR.
                    IF AVAIL ordem-compra THEN DO:
                        IF  ordem-compra.ordem-servic <> 0 THEN DO:
                            ASSIGN tt-it-doc-fisico.nr-ord-produ = ordem-compra.ordem-servic.
                        END.
                    END.
                END.
            END.

            IF  item-doc-orig-nfe.num-pedido <> 0 THEN DO:
                FIND FIRST ordem-compra NO-LOCK WHERE ordem-compra.numero-ordem = item-doc-orig-nfe.numero-ordem NO-ERROR.
                IF AVAIL ordem-compra THEN DO:
                    ASSIGN tt-it-doc-fisico.num-ord-inv = ordem-compra.num-ord-inv.
                END.
            END.

            /* Posiciona o item para buscar a conta de aplicaá∆o.   **
            ** A conta de aplicaá∆o do item Ç a £ltima na ordem     **
            ** de prioridade para sugest∆o de conta-cont†bil.       */
            FIND FIRST item NO-LOCK WHERE item.it-codigo = item-doc-orig-nfe.it-codigo NO-ERROR.
            
            IF  tt-it-doc-fisico.preco-total > de-maior-valor-item THEN
                ASSIGN i-seq-item-maior-valor = tt-it-doc-fisico.sequencia
                       de-maior-valor-item    = tt-it-doc-fisico.preco-total.
            
        END. /* END ELSE DO */
     
    END. /* END IF NOT l-terceiros AND NOT l-devol-cli */

END. /* END FOR EACH item-doc-orig-nfe */

ASSIGN tt-doc-fisico.valor-frete  = bf{&TableName}.valor-frete
       tt-doc-fisico.valor-seguro = bf{&TableName}.valor-seguro
       tt-doc-fisico.valor-outras = bf{&TableName}.valor-outros
       tt-doc-fisico.despesa-nota = tt-doc-fisico.valor-frete + tt-doc-fisico.valor-seguro + tt-doc-fisico.valor-outras.            

/* Ajustes de frete e despesas*/

/* Leva a diferenca entre o total do frete e o frete do XML para o £ltimo item da nota. */
IF  de-total-frete < bf{&TableName}.valor-frete THEN DO:
    FOR FIRST tt-it-doc-fisico WHERE tt-it-doc-fisico.sequencia = i-seq-item-maior-valor:
        ASSIGN tt-it-doc-fisico.vl-frete = tt-it-doc-fisico.vl-frete + (bf{&TableName}.valor-frete - de-total-frete)
               tt-it-doc-fisico.despesas = tt-it-doc-fisico.despesas + (bf{&TableName}.valor-frete - de-total-frete).
    END.
END.

/* Leva a diferenca entre o total do seguro e o seguro do XML para a ultima nota. */
IF  de-total-seguro < bf{&TableName}.valor-seguro THEN DO:
    FOR FIRST tt-it-doc-fisico WHERE tt-it-doc-fisico.sequencia = i-seq-item-maior-valor:
        tt-it-doc-fisico.despesas = tt-it-doc-fisico.despesas + (bf{&TableName}.valor-seguro - de-total-seguro).
    END.
END.

/* Leva a diferenca entre o total das outras despesas e as despesas do XML para a ultima nota. */
IF  de-total-outros < bf{&TableName}.valor-outros THEN DO:
    FOR FIRST tt-it-doc-fisico WHERE tt-it-doc-fisico.sequencia = i-seq-item-maior-valor:
        tt-it-doc-fisico.despesas = tt-it-doc-fisico.despesas + (bf{&TableName}.valor-outros - de-total-outros).
    END.
END.

/*Gerando os dados de Descriá∆o e unidade medida emitente do XML*/        
EMPTY TEMP-TABLE tt-ext-item-doc-est.
FOR EACH tt-it-doc-fisico NO-LOCK:
    IF NOT CAN-FIND (FIRST ext-item-doc-est NO-LOCK
                     WHERE ext-item-doc-est.serie-docto  = tt-it-doc-fisico.serie-docto
                       AND ext-item-doc-est.nro-docto    = tt-it-doc-fisico.nro-docto
                       AND ext-item-doc-est.cod-emitente = tt-it-doc-fisico.cod-emitente
                       AND ext-item-doc-est.nat-operacao = ""
                       AND ext-item-doc-est.sequencia    = tt-it-doc-fisico.sequencia
                       AND ext-item-doc-est.cod-param    = "infoXML":U) THEN DO:
                       
        FOR FIRST item-doc-orig-nfe NO-LOCK
            WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
              AND item-doc-orig-nfe.seq-item           = INT(SUBSTRING(tt-it-doc-fisico.char-2,42,5)) /*Sequencia Item monitor*/
              AND item-doc-orig-nfe.idi-orig-trad      = 1: /*Dados originais XML*/
              
            CREATE tt-ext-item-doc-est.
            ASSIGN tt-ext-item-doc-est.serie-docto  = tt-it-doc-fisico.serie-docto
                   tt-ext-item-doc-est.nro-docto    = tt-it-doc-fisico.nro-docto
                   tt-ext-item-doc-est.cod-emitente = tt-it-doc-fisico.cod-emitente
                   tt-ext-item-doc-est.nat-operacao = ""
                   tt-ext-item-doc-est.sequencia    = tt-it-doc-fisico.sequencia
                   tt-ext-item-doc-est.cod-param    = "infoXML":U.
            ASSIGN tt-ext-item-doc-est.num-livre-1                = tt-it-doc-fisico.tipo-nota
                   OVERLAY(tt-ext-item-doc-est.cod-livre-1,1,120) = item-doc-orig-nfe.desc-item
                   OVERLAY(tt-ext-item-doc-est.cod-livre-2,1,6)   = item-doc-orig-nfe.un-comercial.
        END.
    END.
END.

DO TRANS:
    FOR FIRST tt-doc-fisico NO-LOCK:
        /* Funcao para validar item em branco. */
        IF  l-bloq-item-branco AND CAN-FIND(FIRST tt-it-doc-fisico WHERE TRIM(tt-it-doc-fisico.it-codigo) = "") THEN DO:
            {utp/ut-liter.i "ParÉmetro_'Bloqueio_Item_Branco'_n∆o_permite_gerar_documento_com_item_branco." *}
            RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                             INPUT 17567,
                             INPUT TRIM(RETURN-VALUE),
                             INPUT 0).
            ASSIGN l-erro-doc-proc-fis  = YES
                   l-erro-item-proc-fis = YES
                   l-erro-rat-proc-fis  = YES.
            release msg-ret-nfe.
            RELEASE natur-oper.
            RETURN.
        END.
        ELSE DO:

            IF  NOT l-erro-saldo THEN DO:
                RUN rep/reapi321.p PERSISTENT SET h-reapi321 (INPUT  TABLE tt-doc-fisico,
                                                              INPUT  TABLE tt-it-doc-fisico,
                                                              INPUT  TABLE tt-rat-ordem,
                                                              INPUT  i-num-pedido,
                                                              OUTPUT TABLE tt-erros,
                                                              OUTPUT l-erro-doc-proc-fis,
                                                              OUTPUT l-erro-item-proc-fis,
                                                              OUTPUT l-erro-rat-proc-fis).

                RUN setOrigemDocto IN h-reapi321 ( INPUT "XML":U).
                run setChaveAcesso in h-reapi321 ( INPUT bf{&TableName}.ch-acesso-comp-nfe).
                RUN setConsidEnderNfSaida IN h-reapi321 ( INPUT bf{&TableName}.log-consid-ender-nf-saida).   
                RUN setTTExtItemDocEst IN h-reapi321 (INPUT TABLE tt-ext-item-doc-est).
                RUN pi-execute in h-reapi321 (INPUT  TABLE tt-doc-fisico,
                                              INPUT  TABLE tt-it-doc-fisico,
                                              INPUT  TABLE tt-rat-ordem,
                                              INPUT  i-num-pedido,
                                              OUTPUT TABLE tt-erros,
                                              OUTPUT l-erro-doc-proc-fis,
                                              OUTPUT l-erro-item-proc-fis,
                                              OUTPUT l-erro-rat-proc-fis).

                IF RETURN-VALUE = "NOK" THEN DO:
                    DELETE PROCEDURE h-reapi321 NO-ERROR.
                    ASSIGN h-reapi321 = ?.

                    ASSIGN l-erro-doc-proc-fis = YES.
                    UNDO, LEAVE.
                END.
                ELSE DO:
                    DELETE PROCEDURE h-reapi321 NO-ERROR.
                    ASSIGN h-reapi321 = ?.
                END.
            END.
        END.
    END.
    /* Verifica se encontra mensagem do tipo Erro. */
    IF  CAN-FIND(FIRST tt-erros WHERE tt-erros.tipo-msg = 1) THEN DO:
        ASSIGN l-erro-doc-proc-fis = YES.
        UNDO, LEAVE.
    END.
END.
