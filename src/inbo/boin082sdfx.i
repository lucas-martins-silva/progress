/*------------------------------------------------------------------------------
  Purpose: Seta valores defaults da cotaá∆o 
           (usado no pedido emergencial)
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    define input  param pFieldName as character no-undo.
    define output param table for rowObjectDefault.

    def var de-aliquota-icm like cotacao-item.aliquota-icm no-undo.
    def var i-mo-codigo     like moeda.mo-codigo           no-undo.
    def var deConver        as decimal                     no-undo.
    def var deQtdForn       as decimal                     no-undo.
    DEFINE VARIABLE lExisteMoeda AS LOGICAL   INIT NO  NO-UNDO.
    DEFINE VARIABLE i-cod-busca  AS INTEGER NO-UNDO.

    empty temp-table rowObjectDefault.

    find first ttPurchaseRequisition no-error.
    if  not avail ttPurchaseRequisition then
        return "NOK".

    find first param-compra no-lock no-error.

    for first emitente fields(cod-emitente taxa-financ nr-dias-taxa) 
        where emitente.cod-emitente = ttPurchaseRequisition.cod-emitente no-lock: end.

    assign i-mo-codigo = 0.

    /*** Setar moeda padrao do fornecedor - 2.05 ***/
    &IF DEFINED(bf_mat_custeio_item) &THEN
    find first dist-emitente
        where dist-emitente.cod-emitente = ttPurchaseRequisition.cod-emitente no-lock no-error.
    if  avail dist-emitente THEN
        assign i-mo-codigo = dist-emitente.mo-fatur.
    &ENDIF

    find RowObjectDefault
        where RowObjectDefault.cod-emitente = ttPurchaseRequisition.cod-emitente 
        and   RowObjectDefault.numero-ordem = ttPurchaseRequisition.numero-ordem 
        and   RowObjectDefault.it-codigo    = ttPurchaseRequisition.it-codigo    
        and   RowObjectDefault.seq-cotac    = rowObject.seq-cotac no-error.
    if  not avail RowObjectDefault then do:

        create RowObjectDefault.   
        assign /* Assigns da chave prim†ria */
               RowObjectDefault.cod-emitente = ttPurchaseRequisition.cod-emitente 
               RowObjectDefault.numero-ordem = ttPurchaseRequisition.numero-ordem 
               RowObjectDefault.it-codigo    = ttPurchaseRequisition.it-codigo    
               RowObjectDefault.seq-cotac    = rowObject.seq-cotac.
    end.

    assign RowObjectDefault.preco-fornec = 0
           RowObjectDefault.codigo-ipi   = no
           RowObjectDefault.aliquota-ipi = 0
           RowObjectDefault.prazo-entreg = if  (ttPurchaseRequisition.data-entrega - ttPurchaseRequisition.data-pedido) >= 0 then 
                                               (ttPurchaseRequisition.data-entrega - ttPurchaseRequisition.data-pedido) 
                                           else 0
           RowObjectDefault.mo-codigo    = i-mo-codigo
           RowObjectDefault.valor-taxa   = emitente.taxa-financ
           RowObjectDefault.nr-dias-taxa = emitente.nr-dias-taxa
           RowObjectDefault.taxa-financ  = param-compra.utiliza-taxa
           RowObjectDefault.aliquota-iss = param-compra.aliq-iss-pad
           RowObjectDefault.cod-cond-pag = ttPurchaseRequisition.cod-cond-pag
           RowObjectDefault.aliquota-icm = param-compra.aliq-icm-pad
           RowObjectDefault.perc-descto  = 0
           RowObjectDefault.valor-descto = 0
           RowObjectDefault.frete        = no
           RowObjectDefault.valor-frete  = 0
           RowObjectDefault.codigo-icm   = 2
           RowObjectDefault.un           = "".

    if  param-compra.utiliza-taxa then do:

        if  RowObjectDefault.valor-taxa   = ? or int(RowObjectDefault.valor-taxa) = 0 then 
            assign RowObjectDefault.valor-taxa   = param-compra.taxa-financ.

        if  RowObjectDefault.nr-dias-taxa = ? or int(RowObjectDefault.nr-dias-taxa) = 0 then 
            assign RowObjectDefault.nr-dias-taxa = param-compra.nr-dias-taxa.
    end.
    else 
        assign RowObjectDefault.valor-taxa   = 0
               RowObjectDefault.nr-dias-taxa = 0
               RowObjectDefault.taxa-financ  = no.

    /*---- calcula RowObjectDefault.aliquota-icm: buscar† aliquota da UF ou do ParÉmetros de Compras. 
           Se houver item abaixo buscaremos da tabela de preáos ou cotaá∆o desvinculada ----*/
    run ccp/ccapi014.p (input  ttPurchaseRequisition.cod-estabel,
                        input  ttPurchaseRequisition.cod-emitente,
                        output de-aliquota-icm).
    assign RowObjectDefault.aliquota-icm = de-aliquota-icm.

    for first cont-emit fields(cod-emitente nome)
        where cont-emit.cod-emitente = emitente.cod-emitente no-lock: end.
    if  available cont-emit then
        assign RowObjectDefault.contato = substring(cont-emit.nome, 1, 12).

    for first item-fornec fields(it-codigo cod-emitente ativo num-casa-dec fator-conver unid-med-for)
        where item-fornec.it-codigo    = ttPurchaseRequisition.it-codigo    
        and   item-fornec.cod-emitente = ttPurchaseRequisition.cod-emitente 
        and   item-fornec.ativo no-lock: end.
    if  avail item-fornec then DO:
        IF AVAIL param-compra 
            AND param-compra.log-multi-unid-medid 
            AND item-fornec.unid-med-for <> RowObject.un THEN DO:
            /*Utiliza M£ltiplas Unidades de Medida
             Se unidade da item-fornec <> unidade da cotaá∆o, busca fator de convers∆o conforme a unidade da cotaá∆o*/
            FOR FIRST item-fornec-umd FIELDS(fator-conver num-casa-dec)
                WHERE item-fornec-umd.it-codigo = item-fornec.it-codigo
                  AND item-fornec-umd.cod-emitente = item-fornec.cod-emitente
                  AND item-fornec-umd.unid-med-for = RowObject.un 
                  AND item-fornec-umd.log-ativo NO-LOCK: END.

            ASSIGN deConver = if avail item-fornec-umd
                               then (1 / (exp(10, item-fornec-umd.num-casa-dec)) * item-fornec-umd.fator-conver)
                               else 1.
        END.
        ELSE
            assign deConver = ( 1 / (exp(10, item-fornec.num-casa-dec))) * item-fornec.fator-conver.
    END.
    else 
        assign deConver = 1.

    find first item 
        where item.it-codigo = ttPurchaseRequisition.it-codigo no-lock no-error.

    assign deQtdForn = ttPurchaseRequisition.qt-solic * deConver.

    if  ttPurchaseRequisition.it-codigo <> ?  
    and ttPurchaseRequisition.it-codigo <> "" then do:

        if  avail item then 
            assign RowObjectDefault.aliquota-iss = item.aliquota-iss.

        IF pFieldName <> "currency":U AND pFieldName <> "mo-codigo" THEN DO:
            /* Verifica se existe relacionamento item x fornec x estab e seta a moeda*/
            FIND FIRST item-fornec-estab WHERE item-fornec-estab.it-codigo    = ttPurchaseRequisition.it-codigo
                                           AND item-fornec-estab.cod-estabel  = ttPurchaseRequisition.cod-estabel
                                           AND item-fornec-estab.cod-emitente = ttPurchaseRequisition.cod-emitente NO-LOCK NO-ERROR.
            IF AVAIL item-fornec-estab THEN DO:
                IF TRIM(SUBSTRING(item-fornec-estab.char-1, 1, 2)) <> "" THEN
                    ASSIGN iCodigoMoedaInc = integer(SUBSTRING(item-fornec-estab.char-1, 1, 2))
                           lExisteMoeda = YES.
            END.
            ELSE DO:
                /* Verifica se existe relacionamento item x fornec e seta a moeda */
                FIND FIRST item-fornec WHERE item-fornec.it-codigo    = ttPurchaseRequisition.it-codigo    
                                         AND item-fornec.cod-emitente = ttPurchaseRequisition.cod-emitente NO-LOCK NO-ERROR.
                IF AVAIL item-fornec THEN DO:
                   IF TRIM(SUBSTRING(item-fornec.char-2, 3, 2)) <> "" THEN
                       ASSIGN iCodigoMoedaInc = integer(SUBSTRING(item-fornec.char-2, 3, 2))
                              lExisteMoeda = YES.
                END.
            END.
        END.
        ELSE
            ASSIGN RowObjectDefault.mo-codigo = rowObject.mo-codigo
                   iCodigoMoedaInc            = rowObject.mo-codigo
                   lExisteMoeda               = YES.

        IF lExisteMoeda THEN DO:
            for first tb-pr-cc fields(cod-emitente cod-cond-pag dt-inicio  dt-termino  situacao
                                      nr-tab       mo-codigo    frete      taxa-financ nr-dias-taxa
                                      valor-frete  codigo-ipi   valor-taxa perc-descto cod-estabel) 
                        where tb-pr-cc.cod-emitente = ttPurchaseRequisition.cod-emitente    
                        and   tb-pr-cc.cod-cond-pag = ttPurchaseRequisition.cod-cond-pag 
                        and   tb-pr-cc.dt-inicio   <= ttPurchaseRequisition.data-pedido   
                        and   tb-pr-cc.dt-termino  >= ttPurchaseRequisition.data-pedido   
                        AND   tb-pr-cc.cod-estabel  = ttPurchaseRequisition.cod-estabel
                        AND   tb-pr-cc.mo-codigo    = iCodigoMoedaInc
                        and   tb-pr-cc.situacao     = 1 no-lock: end.
            IF AVAIL tb-pr-cc THEN
                ASSIGN i-cod-busca = 1.
            ELSE DO:
                for first tb-pr-cc fields(cod-emitente cod-cond-pag dt-inicio  dt-termino  situacao
                                          nr-tab       mo-codigo    frete      taxa-financ nr-dias-taxa
                                          valor-frete  codigo-ipi   valor-taxa perc-descto cod-estabel) 
                    where tb-pr-cc.cod-emitente = ttPurchaseRequisition.cod-emitente 
                    and   tb-pr-cc.cod-cond-pag = ttPurchaseRequisition.cod-cond-pag 
                    and   tb-pr-cc.dt-inicio   <= ttPurchaseRequisition.data-pedido   
                    and   tb-pr-cc.dt-termino  >= ttPurchaseRequisition.data-pedido   
                    AND   tb-pr-cc.cod-estabel  = ""
                    AND   tb-pr-cc.mo-codigo    = iCodigoMoedaInc
                    and   tb-pr-cc.situacao     = 1 no-lock: end.
        
                    IF AVAIL tb-pr-cc THEN
                        ASSIGN i-cod-busca = 2.
            END.
        END.
        ELSE DO:
            IF NOT AVAIL tb-pr-cc THEN DO:
                for first tb-pr-cc fields(cod-emitente cod-cond-pag dt-inicio  dt-termino  situacao
                                          nr-tab       mo-codigo    frete      taxa-financ nr-dias-taxa
                                          valor-frete  codigo-ipi   valor-taxa perc-descto cod-estabel) 
                    where tb-pr-cc.cod-emitente = ttPurchaseRequisition.cod-emitente
                    and   tb-pr-cc.cod-cond-pag = ttPurchaseRequisition.cod-cond-pag 
                    and   tb-pr-cc.dt-inicio   <= ttPurchaseRequisition.data-pedido   
                    and   tb-pr-cc.dt-termino  >= ttPurchaseRequisition.data-pedido   
                    AND   tb-pr-cc.cod-estabel  = ttPurchaseRequisition.cod-estabel
                    and   tb-pr-cc.situacao     = 1 no-lock: end.
                    
                    IF AVAIL tb-pr-cc THEN
                        ASSIGN i-cod-busca = 3.
                    ELSE DO:
                        for first tb-pr-cc fields(cod-emitente cod-cond-pag dt-inicio  dt-termino  situacao
                                              nr-tab       mo-codigo    frete      taxa-financ nr-dias-taxa
                                              valor-frete  codigo-ipi   valor-taxa perc-descto cod-estabel) 
                        where tb-pr-cc.cod-emitente = ttPurchaseRequisition.cod-emitente    
                        and   tb-pr-cc.cod-cond-pag = ttPurchaseRequisition.cod-cond-pag 
                        and   tb-pr-cc.dt-inicio   <= ttPurchaseRequisition.data-pedido   
                        and   tb-pr-cc.dt-termino  >= ttPurchaseRequisition.data-pedido   
                        AND   tb-pr-cc.cod-estabel  = ""
                        and   tb-pr-cc.situacao     = 1 no-lock: end.
        
                        IF AVAIL tb-pr-cc THEN
                            ASSIGN i-cod-busca = 4.
                    END.
            END.
        END.
        
        
        /*procurar item-tab*/
        IF AVAIL tb-pr-cc THEN DO:
            REPEAT:
                for last item-tab fields(it-codigo cod-emitente cod-cond-pag nr-tab quant-min 
                                         pr-item   aliquota-ipi desco-quant aliquota-icm cod-estabel mo-codigo)
                    where item-tab.it-codigo    = ttPurchaseRequisition.it-codigo  
                    and   item-tab.cod-emitente = ttPurchaseRequisition.cod-emitente
                    and   item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag 
                    and   item-tab.nr-tab       = tb-pr-cc.nr-tab
                    AND   item-tab.cod-estabel  = tb-pr-cc.cod-estabel
                    AND   item-tab.mo-codigo    = tb-pr-cc.mo-codigo
                    and   item-tab.quant-min   <= deQtdForn no-lock: end.
                if  not available item-tab then
                    for first item-tab fields(it-codigo cod-emitente cod-cond-pag nr-tab quant-min 
                                              pr-item   aliquota-ipi desco-quant aliquota-icm mo-codigo cod-estabel mo-codigo) 
                        where item-tab.cod-emitente = ttPurchaseRequisition.cod-emitente
                        and   item-tab.nr-tab       = tb-pr-cc.nr-tab       
                        and   item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag 
                        AND   item-tab.cod-estabel  = tb-pr-cc.cod-estabel
                        AND   item-tab.mo-codigo    = tb-pr-cc.mo-codigo
                        and   item-tab.it-codigo    = ttPurchaseRequisition.it-codigo  no-lock: end.
        
                /* achou item-tab, encerrar busca */
                IF  AVAILABLE item-tab THEN
                    LEAVE.
        
                CASE i-cod-busca:
                    WHEN 1 THEN DO:
                        FIND NEXT tb-pr-cc                                                      
                        WHERE tb-pr-cc.cod-emitente = ttPurchaseRequisition.cod-emitente             
                          AND tb-pr-cc.cod-cond-pag = ttPurchaseRequisition.cod-cond-pag    
                          AND tb-pr-cc.dt-inicio   <= ttPurchaseRequisition.data-pedido      
                          AND tb-pr-cc.dt-termino  >= ttPurchaseRequisition.data-pedido      
                          AND tb-pr-cc.cod-estabel  = ttPurchaseRequisition.cod-estabel
                          AND tb-pr-cc.mo-codigo    = iCodigoMoedaInc                              
                          AND tb-pr-cc.situacao     = 1 NO-LOCK NO-ERROR.
                    END.
        
                    WHEN 2 THEN DO:
                        FIND NEXT tb-pr-cc                                                  
                            WHERE tb-pr-cc.cod-emitente = ttPurchaseRequisition.cod-emitente             
                              AND tb-pr-cc.cod-cond-pag = ttPurchaseRequisition.cod-cond-pag
                              AND tb-pr-cc.dt-inicio   <= ttPurchaseRequisition.data-pedido  
                              AND tb-pr-cc.dt-termino  >= ttPurchaseRequisition.data-pedido  
                              AND tb-pr-cc.cod-estabel  = ""                                
                              AND tb-pr-cc.mo-codigo    = iCodigoMoedaInc
                              AND tb-pr-cc.situacao     = 1 NO-LOCK NO-ERROR.
                    END.
        
                    WHEN 3 THEN DO:
                        FIND NEXT tb-pr-cc                                                  
                            WHERE tb-pr-cc.cod-emitente = ttPurchaseRequisition.cod-emitente             
                              AND tb-pr-cc.cod-cond-pag = ttPurchaseRequisition.cod-cond-pag
                              AND tb-pr-cc.dt-inicio   <= ttPurchaseRequisition.data-pedido  
                              AND tb-pr-cc.dt-termino  >= ttPurchaseRequisition.data-pedido  
                              AND tb-pr-cc.cod-estabel  = ttPurchaseRequisition.cod-estabel 
                              AND tb-pr-cc.situacao     = 1 NO-LOCK NO-ERROR.
                    END.
        
                    WHEN 4 THEN DO:
                        FIND NEXT tb-pr-cc                                                  
                            WHERE tb-pr-cc.cod-emitente = ttPurchaseRequisition.cod-emitente             
                              AND tb-pr-cc.cod-cond-pag = ttPurchaseRequisition.cod-cond-pag
                              AND tb-pr-cc.dt-inicio   <= ttPurchaseRequisition.data-pedido  
                              AND tb-pr-cc.dt-termino  >= ttPurchaseRequisition.data-pedido  
                              AND tb-pr-cc.cod-estabel  = ""                                
                              AND tb-pr-cc.situacao     = 1 NO-LOCK NO-ERROR.
                    END.
                END CASE.
                
                /* se n∆o tiver mais tabela de preáo, encerrar busca */
                IF NOT AVAIL tb-pr-cc THEN
                    LEAVE.
            END.
        END.

        assign RowObjectDefault.taxa-financ = no.

        if  avail item-tab then do:

            assign RowObjectDefault.preco-fornec = item-tab.pr-item
                   RowObjectDefault.aliquota-icm = item-tab.aliquota-icm
                   RowObjectDefault.aliquota-ipi = item-tab.aliquota-ipi
                   RowObjectDefault.mo-codigo    = tb-pr-cc.mo-codigo
                   RowObjectDefault.frete        = tb-pr-cc.frete
                   RowObjectDefault.valor-frete  = tb-pr-cc.valor-frete
                   RowObjectDefault.taxa-financ  = tb-pr-cc.taxa-financ
                   RowObjectDefault.nr-dias-taxa = tb-pr-cc.nr-dias-taxa
                   RowObjectDefault.valor-taxa   = tb-pr-cc.valor-taxa
                   RowObjectDefault.codigo-ipi   = tb-pr-cc.codigo-ipi
                   RowObjectDefault.nr-tab       = tb-pr-cc.nr-tab.

            if  item-tab.desco-quant = 0 then
                assign RowObjectDefault.perc-descto = tb-pr-cc.perc-descto.
            else
                assign RowObjectDefault.perc-descto = item-tab.desco-quant.
        end.
        else do:

            if  avail tb-pr-cc then
                assign RowObjectDefault.perc-descto = tb-pr-cc.perc-descto WHEN AVAIL tb-pr-cc.

            if  avail item 
            and item.aliquota-ipi > 0 then
                assign RowObjectDefault.aliquota-ipi = item.aliquota-ipi.

            else if avail item then do:

                for first classif-fisc fields(class-fiscal aliquota-ipi)
                    where classif-fisc.class-fiscal = item.class-fiscal no-lock: end.
                if  avail classif-fisc then 
                    assign RowObjectDefault.codigo-ipi   = yes
                           RowObjectDefault.aliquota-ipi = classif-fisc.aliquota-ipi.
            end.
            find first RowObjectDefault no-error.
        end.

        /* Se houver cotaá∆o desvinculada, prevalecer∆o os valores da cotaá∆o */
        for first cotacao-item
            where cotacao-item.it-codigo       = item.it-codigo
            and   cotacao-item.cod-emitente    = emitente.cod-emitente            
            and   cotacao-item.numero-ordem    = 0                         
            and   cotacao-item.cod-cond-pag    = ttPurchaseRequisition.cod-cond-pag 
            and   (cotacao-item.data-cotacao 
                  + cotacao-item.prazo-entreg) >= today no-lock:

            assign RowObjectDefault.aliquota-icm = cotacao-item.aliquota-icm
                   RowObjectDefault.codigo-icm   = cotacao-item.codigo-icm
                   RowObjectDefault.codigo-ipi   = cotacao-item.codigo-ipi
                   RowObjectDefault.aliquota-ipi = cotacao-item.aliquota-ipi
                   RowObjectDefault.aliquota-iss = cotacao-item.aliquota-iss
                   RowObjectDefault.frete        = cotacao-item.frete
                   RowObjectDefault.valor-frete  = cotacao-item.valor-frete
                   RowObjectDefault.taxa-financ  = cotacao-item.taxa-financ    /* Encargos Fin. */
                   RowObjectDefault.nr-dias-taxa = cotacao-item.nr-dias-taxa   
                   RowObjectDefault.valor-taxa   = cotacao-item.valor-taxa     /* Taxa Financ.  */
                   RowObjectDefault.prazo-entreg = cotacao-item.prazo-entreg
                   RowObjectDefault.mo-codigo    = cotacao-item.mo-codigo
                   RowObjectDefault.perc-descto  = cotacao-item.perc-descto
                   RowObjectDefault.valor-descto = cotacao-item.valor-descto
                   RowObjectDefault.contato      = cotacao-item.contato
                   RowObjectDefault.preco-fornec = cotacao-item.preco-fornec.
        end.

        find first RowObjectDefault no-error.

        /* UN Default */
        find first param-mat no-lock no-error.
        if  param-mat.ind-sit-un = 2 then do:

            if  not avail item-fornec 
            or  (    avail item-fornec 
                 and (    item-fornec.cod-emitente <> emitente.cod-emitente 
                      or  item-fornec.it-codigo    <> item.it-codigo)) then
                for first item-fornec fields(it-codigo cod-emitente ativo num-casa-dec 
                                             fator-conver unid-med-for) 
                    where item-fornec.it-codigo    = item.it-codigo    
                    and   item-fornec.cod-emitente = emitente.cod-emitente 
                    and   item-fornec.ativo          no-lock: end.
            if  avail item-fornec THEN DO:
                
                IF AVAIL param-compra 
                     AND param-compra.log-multi-unid-medid 
                     AND item-fornec.unid-med-for <> RowObject.un THEN DO:
                    /*Utiliza M£ltiplas Unidades de Medida
                     Se unidade da item-fornec <> unidade da cotaá∆o, verifica se existe registro para fornecedor x item x unidade para unidade da cotaá∆o*/
                    FOR FIRST item-fornec-umd FIELDS(unid-med-for)
                        WHERE item-fornec-umd.it-codigo = item-fornec.it-codigo
                          AND item-fornec-umd.cod-emitente = item-fornec.cod-emitente
                          AND item-fornec-umd.unid-med-for = RowObject.un 
                          AND item-fornec-umd.log-ativo NO-LOCK: END.
                    IF AVAIL item-fornec-umd THEN
                        assign RowObjectDefault.un = item-fornec-umd.unid-med-for.
                    ELSE
                        assign RowObjectDefault.un = item-fornec.unid-med-for.
                END.
                ELSE
                    assign RowObjectDefault.un = item-fornec.unid-med-for.
            END.
            else do:

                if  avail item then 
                    assign RowObjectDefault.un = item.un.
                else 
                    assign RowObjectDefault.un = "".
            end.
        end.
    end.

    if  avail tb-pr-cc then
        run returnVendorUnitPrice (pFieldName, output table RowObjectDefault).

    if  ttPurchaseRequisition.natureza = 2 then do: /* pedido de serviáo n∆o tem icms - N«O TIRAR ESSA L‡GICA */

       find first RowObjectDefault no-error.
       assign RowObjectDefault.aliquota-icm = 0.
    end.
    return "OK".

