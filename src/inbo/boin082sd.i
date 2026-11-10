/*------------------------------------------------------------------------------
  Purpose: Prepara cotaá‰es para inclusío de Ordens do cc0300.
  Parameters: 
            ipar1 : piNumeroOrdem         : Numero da Ordem
            ipar2 : piNum-pedido          : Numero do Pedido
            ipar3 : piCod-emitente        : C¢digo do Emitente
            ipar4 : pcIt-codigo           : C¢digo do Item
            ipar5 : pdData-entrega        : Data de Entrega da primeira parcela
            opar6 : plEnableCodigoICM     : Ativar codigo-icm?
            opar7 : plEnableAliquotaICM   : Ativar aliquota-icm ?
            opar8 : plEnableAliquotaISS   : Ativar aliquota-iss?
            opar9 : plEnableDiasValorTaxa : Ativar valor-taxa?
            opar10: plEnableTaxaFinanc    : Ativar taxa-financ?
            opar11: plEnablePossuiReaj    : Ativar possui-reaj?
            opar12: rowObject             : Tabela de Dados cotacao-item
  Notes:       
------------------------------------------------------------------------------*/
    def input  param piNumeroOrdem         as int  no-undo.
    def input  param piNum-pedido          as int  no-undo.
    def input  param piCod-emitente        as int  no-undo.
    def input  param pcIt-codigo           as char no-undo.
    def input  param pcCod-estabel         as char no-undo.
    def input  param pdeQtdTot             as dec  no-undo.
    def input  param pdData-entrega        as date no-undo.
    def input-output param pc-cod-comprado as char no-undo.
    def output param plEnableCodigoICM     as log  no-undo.
    def output param plEnableAliquotaICM   as log  no-undo.
    def output param plEnableAliquotaISS   as log  no-undo.
    def output param plEnableDiasValorTaxa as log  no-undo.
    def output param plEnableTaxaFinanc    as log  no-undo.
    def output param plEnablePossuiReaj    as log  no-undo.
    def output param table                 for rowObject.
    FOR EACH rowObject NO-LOCK:
        DELETE rowObject.
    END.

    def var de-aliquota-icm like cotacao-item.aliquota-icm.

    DEFINE VARIABLE lExisteMoeda AS LOGICAL NO-UNDO.
    DEFINE VARIABLE i-cod-busca  AS INTEGER NO-UNDO.

    find first param-compra no-lock no-error.

    for first pedido-compr fields(num-pedido data-pedido cod-cond-pag natureza) where
         pedido-compr.num-pedido = piNum-pedido
         no-lock: end.
    for first emitente fields(cod-emitente taxa-financ nr-dias-taxa) where
        emitente.cod-emitente = piCod-emitente
        no-lock: end.

    ASSIGN i-mo-codigo = 0
           lExisteTabela = NO.
    /*** Setar moeda padrao do fornecedor - 2.05 ***/
    &IF DEFINED(bf_mat_custeio_item) &THEN
        FIND FIRST dist-emitente
             WHERE dist-emitente.cod-emitente = piCod-emitente NO-LOCK NO-ERROR.
        IF AVAIL dist-emitente THEN
            ASSIGN i-mo-codigo = dist-emitente.mo-fatur.
    &ENDIF
    
    create rowObject.   
    assign /* Assigns da chave prim†ria */
           rowObject.cod-emitente = piCod-emitente
           rowObject.numero-ordem = piNumeroOrdem
           rowObject.it-codigo    = pcIt-codigo
           rowObject.preco-fornec = 0
           rowObject.codigo-ipi   = no
           rowObject.aliquota-ipi = 0
           rowObject.prazo-entreg = if (pdData-entrega - pedido-compr.data-pedido) >= 0 then (pdData-entrega - pedido-compr.data-pedido) else 0
           rowObject.mo-codigo    = i-mo-codigo
           rowObject.valor-taxa   = emitente.taxa-financ
           rowObject.nr-dias-taxa = emitente.nr-dias-taxa
           rowObject.taxa-financ  = param-compra.utiliza-taxa
           rowObject.aliquota-iss = param-compra.aliq-iss-pad
           rowObject.cod-cond-pag = pedido-compr.cod-cond-pag
           rowObject.aliquota-icm = param-compra.aliq-icm-pad
           rowObject.perc-descto  = 0
           rowObject.valor-descto = 0
           rowObject.frete        = no
           rowObject.valor-frete  = 0
           rowObject.codigo-icm   = 2
           rowObject.un           = "".
    assign plEnableCodigoICM      = param-compra.utiliza-icm 
           plEnableAliquotaICM    = param-compra.utiliza-icm 
           plEnableAliquotaISS    = param-compra.utiliza-iss
           plEnableTaxaFinanc     = param-compra.utiliza-taxa
           plEnableDiasValorTaxa  = param-compra.utiliza-taxa.
    if  param-compra.utiliza-taxa then do:
        if rowObject.valor-taxa   = ? or int(rowObject.valor-taxa)   = 0 then 
           assign rowObject.valor-taxa   = param-compra.taxa-financ.
        if rowObject.nr-dias-taxa = ? or int(rowObject.nr-dias-taxa) = 0 then 
           assign rowObject.nr-dias-taxa = param-compra.nr-dias-taxa.
    end.
    else do:
        assign rowObject.valor-taxa   = 0
               rowObject.nr-dias-taxa = 0
               rowObject.taxa-financ  = no.
    end.

    /*---- calcula rowObject.aliquota-icm: buscar† aliquota da UF ou do ParÉmetros de Compras. 
           Se houver item abaixo buscaremos da tabela de preáos ou cotaá∆o desvinculada ----*/
        run ccp/ccapi014.p (input  pcCod-estabel,
                            input  piCod-emitente,
                            output de-aliquota-icm).
        assign rowObject.aliquota-icm = de-aliquota-icm.

    for first cont-emit fields(cod-emitente nome) where 
        cont-emit.cod-emitente = emitente.cod-emitente 
        no-lock: end.
    if  available cont-emit then
        assign rowObject.contato = cont-emit.nome.

    for first item-fornec fields(it-codigo cod-emitente ativo num-casa-dec 
                                 fator-conver unid-med-for) where 
              item-fornec.it-codigo    = pcIt-codigo and
              item-fornec.cod-emitente = piCod-emitente and
              item-fornec.ativo          no-lock: end.
    if avail item-fornec then assign deConver = ( 1 / (exp(10, item-fornec.num-casa-dec))) * item-fornec.fator-conver.
                         else assign deConver = 1.

    assign deQtdForn = pdeQtdTot * deConver.
    if pcIt-codigo <> ?  and 
       pcIt-codigo <> "" then do:

        find first item where item.it-codigo = pcIt-codigo no-lock no-error.
        if avail item then assign rowObject.aliquota-iss = item.aliquota-iss.

        /* Se o usu†rio n∆o informou nenhuma moeda ou n∆o foi executado o 'leave' no campo moeda busca a moeda
         nos relacionamentos item x fornec x estab ou item x fornec*/
        IF NOT lUtilizaMoedaUsuario THEN DO:
            /* Verifica se existe relacionamento item x fornec x estab e seta a moeda*/
            FIND FIRST item-fornec-estab WHERE item-fornec-estab.it-codigo    = pcIt-codigo
                                           AND item-fornec-estab.cod-estabel  = pcCod-estabel
                                           AND item-fornec-estab.cod-emitente = piCod-emitente NO-LOCK NO-ERROR.
            IF AVAIL item-fornec-estab THEN DO:
                IF SUBSTRING(item-fornec-estab.char-1, 1, 2) <> "" THEN DO:
                    ASSIGN iCodigoMoedaPedEmerg = integer(SUBSTRING(item-fornec-estab.char-1, 1, 2))
                           lExisteMoeda = YES.
                END.
            END.
            ELSE DO:
                /* Verifica se existe relacionamento item x fornec e seta a moeda */
                FIND FIRST item-fornec WHERE item-fornec.it-codigo    = pcIt-codigo    
                                         AND item-fornec.cod-emitente = piCod-emitente NO-LOCK NO-ERROR.
                IF AVAIL item-fornec THEN DO:
                   IF SUBSTRING(item-fornec.char-2, 3, 2) <> "" THEN DO:
                       ASSIGN iCodigoMoedaPedEmerg = integer(SUBSTRING(item-fornec.char-2, 3, 2))
                              lExisteMoeda = YES.
                   END.
                END.
            END.
        END.
        /* A moeda a ser utilizada para localizar a tabela de preáo ser† a informada pelo usu†rio */
        ELSE
            ASSIGN iCodigoMoedaPedEmerg = iMoCodigoEmergencial /*pi-seta-moeda*/
                   lExisteMoeda         = YES
                   lUtilizaMoedaUsuario = NO. /*pi-seta-moeda*/

        IF lExisteMoeda THEN DO:
            for first tb-pr-cc fields(cod-emitente cod-cond-pag dt-inicio  dt-termino  situacao
                                      nr-tab       mo-codigo    frete      taxa-financ nr-dias-taxa
                                      valor-frete  codigo-ipi   valor-taxa perc-descto cod-estabel) where 
                 tb-pr-cc.cod-emitente = emitente.cod-emitente     and
                 tb-pr-cc.cod-cond-pag = pedido-compr.cod-cond-pag and
                 tb-pr-cc.dt-inicio   <= pedido-compr.data-pedido  and
                 tb-pr-cc.dt-termino  >= pedido-compr.data-pedido  and
                 tb-pr-cc.cod-estabel  = pcCod-estabel  AND
                 tb-pr-cc.mo-codigo    = iCodigoMoedaPedEmerg                  AND
                 tb-pr-cc.situacao     = 1 
                 no-lock: end.

            IF AVAIL tb-pr-cc THEN DO:
                ASSIGN i-cod-busca = 1.
            END.
            ELSE DO:
                 for first tb-pr-cc fields(cod-emitente cod-cond-pag dt-inicio  dt-termino  situacao
                                  nr-tab       mo-codigo    frete      taxa-financ nr-dias-taxa
                                  valor-frete  codigo-ipi   valor-taxa perc-descto cod-estabel)
                     where tb-pr-cc.cod-emitente = emitente.cod-emitente     and
                           tb-pr-cc.cod-cond-pag = pedido-compr.cod-cond-pag and
                           tb-pr-cc.dt-inicio   <= pedido-compr.data-pedido  and
                           tb-pr-cc.dt-termino  >= pedido-compr.data-pedido  and
                           tb-pr-cc.cod-estabel  = ""                        and
                           tb-pr-cc.mo-codigo    = iCodigoMoedaPedEmerg                  and
                           tb-pr-cc.situacao     = 1 no-lock: end.
                IF AVAIL tb-pr-cc THEN DO:
                    ASSIGN i-cod-busca = 2.
                END.
            END.
        END. 
        ELSE DO:
            for first tb-pr-cc fields(cod-emitente cod-cond-pag dt-inicio  dt-termino  situacao
                                  nr-tab       frete      taxa-financ nr-dias-taxa mo-codigo
                                  valor-frete  codigo-ipi   valor-taxa perc-descto cod-estabel)
                 where tb-pr-cc.cod-emitente = emitente.cod-emitente     and
                       tb-pr-cc.cod-cond-pag = pedido-compr.cod-cond-pag and
                       tb-pr-cc.dt-inicio   <= pedido-compr.data-pedido  and
                       tb-pr-cc.dt-termino  >= pedido-compr.data-pedido  and
                       tb-pr-cc.cod-estabel  = pcCod-estabel  AND
                       tb-pr-cc.situacao     = 1 no-lock: end.

            IF AVAIL tb-pr-cc THEN DO:
                ASSIGN i-cod-busca = 3.
            END.
            ELSE DO:
                for first tb-pr-cc fields(cod-emitente cod-cond-pag dt-inicio  dt-termino  situacao
                                      nr-tab       frete      taxa-financ nr-dias-taxa mo-codigo
                                      valor-frete  codigo-ipi   valor-taxa perc-descto cod-estabel)
                     where tb-pr-cc.cod-emitente = emitente.cod-emitente     and
                           tb-pr-cc.cod-cond-pag = pedido-compr.cod-cond-pag and
                           tb-pr-cc.dt-inicio   <= pedido-compr.data-pedido  and
                           tb-pr-cc.dt-termino  >= pedido-compr.data-pedido  and
                           tb-pr-cc.cod-estabel  = ""                        and 
                           tb-pr-cc.situacao     = 1 no-lock: end.

                IF AVAIL tb-pr-cc THEN DO:
                    ASSIGN i-cod-busca = 4.
                END.
            END.
        END.

        if available tb-pr-cc then DO:
            repeat:
                for last item-tab fields(it-codigo cod-emitente cod-cond-pag nr-tab quant-min 
                                         pr-item   aliquota-ipi desco-quant aliquota-icm cod-estabel mo-codigo) where 
                    item-tab.it-codigo    = pcIt-codigo and
                    item-tab.cod-emitente = emitente.cod-emitente and
                    item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag and
                    item-tab.nr-tab       = tb-pr-cc.nr-tab       and
                    item-tab.cod-estabel  = tb-pr-cc.cod-estabel  AND
                    item-tab.mo-codigo    = tb-pr-cc.mo-codigo    AND
                    item-tab.quant-min   <= deQtdForn
                    no-lock: end.
    
                if  not available item-tab then
                    for first item-tab fields(it-codigo cod-emitente cod-cond-pag nr-tab quant-min 
                                              pr-item   aliquota-ipi desco-quant aliquota-icm cod-estabel mo-codigo) where 
                         item-tab.cod-emitente = emitente.cod-emitente and
                         item-tab.nr-tab       = tb-pr-cc.nr-tab       and
                         item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag and
                         item-tab.cod-estabel  = tb-pr-cc.cod-estabel  AND
                         item-tab.mo-codigo    = tb-pr-cc.mo-codigo    AND
                         item-tab.it-codigo    = pcIt-codigo
                         no-lock: end.
                if  available item-tab then  
                    leave.

                CASE i-cod-busca:
                    WHEN 1 THEN DO:
                         find next tb-pr-cc  where 
                             tb-pr-cc.cod-emitente = emitente.cod-emitente     and
                             tb-pr-cc.cod-cond-pag = pedido-compr.cod-cond-pag and
                             tb-pr-cc.dt-inicio   <= pedido-compr.data-pedido  and
                             tb-pr-cc.dt-termino  >= pedido-compr.data-pedido  and
                             tb-pr-cc.cod-estabel  = pcCod-estabel             AND
                             tb-pr-cc.mo-codigo    = iCodigoMoedaPedEmerg      AND
                             tb-pr-cc.situacao     = 1 no-lock no-error.
                    END.
                    WHEN 2 THEN DO:
                         find next tb-pr-cc  where 
                             tb-pr-cc.cod-emitente = emitente.cod-emitente     and
                             tb-pr-cc.cod-cond-pag = pedido-compr.cod-cond-pag and
                             tb-pr-cc.dt-inicio   <= pedido-compr.data-pedido  and
                             tb-pr-cc.dt-termino  >= pedido-compr.data-pedido  and
                             tb-pr-cc.cod-estabel  = ""                        and
                             tb-pr-cc.mo-codigo    = iCodigoMoedaPedEmerg      AND
                             tb-pr-cc.situacao     = 1 no-lock no-error.
                    END.
                    WHEN 3 THEN DO:
                         find next tb-pr-cc  where 
                             tb-pr-cc.cod-emitente = emitente.cod-emitente     and
                             tb-pr-cc.cod-cond-pag = pedido-compr.cod-cond-pag and
                             tb-pr-cc.dt-inicio   <= pedido-compr.data-pedido  and
                             tb-pr-cc.dt-termino  >= pedido-compr.data-pedido  and
                             tb-pr-cc.cod-estabel  = pcCod-estabel             AND
                             tb-pr-cc.situacao     = 1 no-lock no-error.
                    END.
                    WHEN 4 THEN DO:
                         find next tb-pr-cc  where 
                             tb-pr-cc.cod-emitente = emitente.cod-emitente     and
                             tb-pr-cc.cod-cond-pag = pedido-compr.cod-cond-pag and
                             tb-pr-cc.dt-inicio   <= pedido-compr.data-pedido  and
                             tb-pr-cc.dt-termino  >= pedido-compr.data-pedido  and
                             tb-pr-cc.cod-estabel  = ""                        and
                             tb-pr-cc.situacao     = 1 no-lock no-error.
                    END.
                END CASE.

                if  not avail tb-pr-cc then
                    leave.            
            end.
        END.

        
        assign rowObject.taxa-financ = no.
        
        if  avail item-tab then do:  
            assign rowObject.preco-fornec = item-tab.pr-item
                   rowObject.aliquota-icm = item-tab.aliquota-icm
                   rowObject.mo-codigo    = tb-pr-cc.mo-codigo    when avail tb-pr-cc
                   rowObject.frete        = tb-pr-cc.frete        when avail tb-pr-cc
                   rowObject.valor-frete  = tb-pr-cc.valor-frete  when avail tb-pr-cc
                   rowObject.taxa-financ  = tb-pr-cc.taxa-financ  when avail tb-pr-cc
                   rowObject.nr-dias-taxa = tb-pr-cc.nr-dias-taxa when avail tb-pr-cc
                   rowObject.valor-taxa   = tb-pr-cc.valor-taxa   when avail tb-pr-cc
                   rowObject.codigo-ipi   = tb-pr-cc.codigo-ipi   when avail tb-pr-cc
                   rowObject.aliquota-ipi = item-tab.aliquota-ipi
                   rowObject.nr-tab       = tb-pr-cc.nr-tab       when avail tb-pr-cc
                   plEnablePossuiReaj     = yes
                   lExisteTabela          = yes. /* pi-retorna-existencia-tab-preco-item */
            if item-tab.desco-quant = 0 then
                assign rowObject.perc-descto = tb-pr-cc.perc-descto when avail tb-pr-cc.
            else
                assign rowObject.perc-descto = item-tab.desco-quant.
        end.        
        else do:
            if avail tb-pr-cc then
                assign rowObject.perc-descto = tb-pr-cc.perc-descto.

            for first item fields(it-codigo aliquota-ipi class-fiscal un) where 
                item.it-codigo = pcIt-codigo no-lock: end.
            if avail item and item.aliquota-ipi > 0 then
                assign rowObject.aliquota-ipi = item.aliquota-ipi.
            else if avail item then do:
                for first classif-fisc fields(class-fiscal aliquota-ipi) where 
                    classif-fisc.class-fiscal = item.class-fiscal 
                    no-lock: end.
                if avail classif-fisc then 
                    assign rowObject.codigo-ipi   = yes
                           rowObject.aliquota-ipi = classif-fisc.aliquota-ipi.
            end.
            /*  Chamada EPC  */
            {include/i-epc200.i2 &CodEvent='"atribui-codigo-ipi"'
                                 &CodParameter='"DBO-HANDLE"'
                                 &ValueParameter="string(this-procedure)"}
            {include/i-epc201.i "atribui-codigo-ipi"}
            find first rowObject no-error.
        end.
        
        /* Se houver cotaá∆o desvinculada, prevalecer∆o os valores da cotaá∆o */
        for first cotacao-item where
                  cotacao-item.it-codigo       = pcIt-codigo               and
                  cotacao-item.cod-emitente    = piCod-emitente            and
                  cotacao-item.numero-ordem    = 0                         and
                  cotacao-item.cod-cond-pag    = pedido-compr.cod-cond-pag and
                  (cotacao-item.data-cotacao 
                  + cotacao-item.prazo-entreg) >= today     no-lock:

            assign rowObject.aliquota-icm = cotacao-item.aliquota-icm
                   rowObject.codigo-icm   = cotacao-item.codigo-icm
                   rowObject.codigo-ipi   = cotacao-item.codigo-ipi
                   rowObject.aliquota-ipi = cotacao-item.aliquota-ipi
                   rowObject.aliquota-iss = cotacao-item.aliquota-iss
                   rowObject.frete        = cotacao-item.frete
                   rowObject.valor-frete  = cotacao-item.valor-frete
                   rowObject.taxa-financ  = cotacao-item.taxa-financ    /* Encargos Fin. */
                   rowObject.nr-dias-taxa = cotacao-item.nr-dias-taxa   
                   rowObject.valor-taxa   = cotacao-item.valor-taxa     /* Taxa Financ.  */
                   rowObject.prazo-entreg = cotacao-item.prazo-entreg
                   rowObject.mo-codigo    = cotacao-item.mo-codigo
                   rowObject.perc-descto  = cotacao-item.perc-descto
                   rowObject.valor-descto = cotacao-item.valor-descto
                   rowObject.contato      = cotacao-item.contato
                   rowObject.preco-fornec = cotacao-item.preco-fornec
                   /* pc-cod-comprado        = cotacao-item.cod-comprado */.
        end.
/* N∆o eliminar o c¢digo abaixo, pois ser† implementado para a Grendene. Esta implementaá∆o foi feita
   inicialmente na epc da interface mas, ser† repassado para a epc deste bo. Falar c/Osnir 
        /*************  Chamada EPC   *************/
        {include/i-epc200.i2 &CodEvent='"atribui-valores"'
                             &CodParameter='"rowid-pedido"'
                             &ValueParameter="string(rowid(pedido-compr))"}
        {include/i-epc200.i2 &CodEvent='"atribui-valores"'
                             &CodParameter='"DBO-HANDLE"'
                             &ValueParameter="string(this-procedure)"}
        {include/i-epc201.i "atribui-valores"}
*/        
        find first rowObject no-error.
        /* UN Default */
        find first param-mat no-lock no-error.
        if  param-mat.ind-sit-un = 2 then do:
            if not avail item-fornec or
               (avail item-fornec and
               (item-fornec.cod-emitente <> piCod-emitente or
                item-fornec.it-codigo    <> pcIt-codigo)) then
                for first item-fornec fields(it-codigo cod-emitente ativo num-casa-dec 
                                             fator-conver unid-med-for) where 
                     item-fornec.it-codigo    = pcIt-codigo    and
                     item-fornec.cod-emitente = piCod-emitente and
                     item-fornec.ativo          no-lock: end.
            if  avail item-fornec then
                assign rowObject.un = item-fornec.unid-med-for.
            else do:
                if avail item then assign rowObject.un = item.un.
                              else assign rowObject.un = "".
            end.
        end.
    end.

    if avail tb-pr-cc then do:
       RUN inbo/boin082ca.p PERSISTENT SET hBoin082ca.
       RUN calculaPrecoUnitFornecedorCotacao in hBoin082ca (input YES,
                                                            input piNumeroOrdem,
                                                            input-output table rowObject).
       DELETE PROCEDURE hBoin082ca.
                        hBoin082ca = ?.
    end.

    if avail pedido-compr and pedido-compr.natureza = 2 then do: /* pedido de serviáo n∆o tem icms - N«O TIRAR ESSA L‡GICA */
       find first rowObject no-error.
       assign rowObject.aliquota-icm = 0.
    end.
    return "OK".
