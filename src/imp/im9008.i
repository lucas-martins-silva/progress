 /*****************************************************************************
**
** IM9008.i - Integraá∆o entre os m¢dulos Caixa e Bancos e Importaá∆o. (EMS)
**
** Objetivo : Gerar fluxo de caixa das despesas da importaá∆o - fluxo gerencial.
**
******************************************************************************/

def var i-empresa  like empresa.ep-codigo no-undo.
{utp/ut-glob.i}
ASSIGN i-empresa = i-ep-codigo-usuario.

def var c-fluxo-ge   as character no-undo.

def var da-data      as date format "99/99/9999" extent 12 initial TODAY NO-UNDO.
def var da-partida   as date format "99/99/9999" no-undo.
def var da-dt-mov    as date format "99/99/9999" no-undo.

def var i-ind        as integer                          no-undo.
def var i-cond       as integer   extent 12              no-undo.
def var i-cont       as integer   format "999" init 0    no-undo.
def var c-esp        as character format "xx"  init "CC" no-undo.

def var i-cond-pagto  as integer no-undo.
def var i-nr-datas    as integer no-undo.
def var i-tp-despesa  as integer no-undo.
def var de-quant      as decimal no-undo.
def var de-valor      as decimal no-undo.
def var de-preco      as decimal no-undo.
def var de-preco-conv as decimal no-undo.

def var c-parc       as character format "xx" no-undo.
def var c-tipo       as character format "xx" no-undo.
def var c-serie      like mov-cb.serie        no-undo.

def var l-atraso         as logical                      no-undo.
def var i-seq-erro       as integer                      no-undo.
def var i-versao-integ   as integer                      no-undo.
def var de-preco-unit    like ordem-compra.preco-unit    no-undo.
def var de-preco-total   like ordem-compra.preco-unit    no-undo.
def var de-quant-saldo   like prazo-compra.quant-saldo   no-undo.
def var l-atual-demon-cb as   logical initial no         no-undo.
def var l-atualiza-fluxo as   logical initial no         no-undo.
DEF VAR i-mo-codigo      LIKE desp-embarque.mo-codigo    NO-UNDO.
DEF VAR h-im0091         AS   HANDLE                     NO-UNDO.

{cdp/cd4300.i3}  /* Include atributos livres */
{ccp/cc9019.i50} /* Atributo livre cotacao-item.char-1 */
{imp/im0091.i}   /* Definicao temp-table tt-desp-rateio */

Procedure pi-fluxo-caixa-imp-im9040-im9008:

/**
*** Procedure executada apartir do cb1213 e cc5678.
***
*** Variaveis entrada:
*** input p-cb1213 - diferencia as chamadas dos programa im9008 e im9040, isto
*** foi feito pois os inputs e outputs s∆o diferentes.
**/

    def input parameter p-cb1213 as char no-undo.
    find ordem-compra
        where rowid(ordem-compra) = rw-ordem-compra no-lock no-error.

    find prazo-compra
        where rowid(prazo-compra) = rw-prazo-compra no-lock no-error.

    find first param-compra no-lock no-error.

    find first tt-param no-error.

    find first param-cb
        where param-cb.ep-codigo = tt-param.i-emp no-lock.

    find cotacao-item
        where cotacao-item.numero-ordem = ordem-compra.numero-ordem
          and cotacao-item.cod-emitente = ordem-compra.cod-emitente
          and cotacao-item.it-codigo    = ordem-compra.it-codigo
          and cotacao-item.cot-aprovada = yes no-lock no-error.

    if not avail cotacao-item then
        return.

    do transaction:
        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
        {ccp/cc9019.i51 "yes"}
    end.

    for each cotacao-item-cex
        where cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
          and cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente
          and cotacao-item-cex.it-codigo    = cotacao-item.it-codigo
          and cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
          and cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao
          and cotacao-item-cex.mapa-cotacao = i-mapa-cotacao-i50
          and cotacao-item-cex.cod-incoterm = c-cod-incoterm-i50 no-lock:

        find desp-imp
            where desp-imp.cod-desp = cotacao-item-cex.cod-desp no-lock no-error.

        if desp-imp.tipo = 1 then
            assign de-preco = cotacao-item-cex.val-desp.
        else
            assign de-preco = cotacao-item-cex.val-desp * prazo-compra.quant-saldo.

        if not desp-imp.inc-val-embal       and
           not desp-imp.inc-val-frete       and
           not desp-imp.inc-val-outras-desp and
           not desp-imp.inc-val-seguro then next.

        find processo-imp where
             processo-imp.num-pedido = ordem-compra.num-pedido no-lock no-error.

        IF AVAIL processo-imp THEN DO:
            assign i-cond-pagto = cotacao-item-cex.cod-cond-pag.

            find ordens-embarque
                where ordens-embarque.numero-ordem = ordem-compra.numero-ordem
                  and ordens-embarque.parcela      = prazo-compra.parcela no-lock no-error.

            if not avail ordens-embarque then next.

            find historico-embarque where
                 historico-embarque.cod-estabel   = processo-imp.cod-estabel and
                 historico-embarque.embarque      = ordens-embarque.embarque and
                 historico-embarque.cod-pto-contr = cotacao-item-cex.cod-pto-contr no-lock no-error.

            IF AVAIL historico-embarque THEN DO:
                FIND desp-embarque WHERE
                     desp-embarque.cod-estabel = historico-embarque.cod-estabel     AND
                     desp-embarque.embarque    = historico-embarque.embarque        AND
                     desp-embarque.cod-itiner  = historico-embarque.cod-itiner      AND
                     desp-embarque.cod-pto-contr = historico-embarque.cod-pto-contr AND
                     desp-embarque.cod-desp      = cotacao-item-cex.cod-desp        AND
                     desp-embarque.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp NO-LOCK NO-ERROR.

                IF AVAIL desp-embarque THEN
                    ASSIGN de-preco-unit = desp-embarque.val-desp
                           i-cond-pagto  = desp-embarque.cod-cond-pag.
            END.
        END.
        if i-cond-pagto <> 0 then do:

            if not avail historico-embarque then do:
                find historico-proc-imp
                    where historico-proc-imp.cod-estabel   = processo-imp.cod-estabel
                      and historico-proc-imp.nr-proc-imp   = processo-imp.nr-proc-imp
                      and historico-proc-imp.cod-pto-contr = cotacao-item-cex.cod-pto-contr no-lock no-error.
                if avail historico-proc-imp then do:
                    if historico-proc-imp.dt-efetiva <> ? then
                        assign da-partida = historico-proc-imp.dt-efetiva.
                    else
                        assign da-partida = historico-proc-imp.dt-ult-previsao.
                end.
            end.
            else do:
                if historico-embarque.dt-efetiva <> ? then
                    assign da-partida  = historico-embarque.dt-efetiva.
                else
                    assign da-partida  = historico-embarque.dt-ult-previsao.
            end.

            if not avail historico-embarque and not avail historico-proc-imp then
                assign da-partida = prazo-compra.data-entrega.

            {cdp/cd9020.i param-compra.end-entr-pad}

            if cond-pagto.cod-vencto = 3 then
                next.

            if  cond-pagto.cod-vencto = 4 then do:

                assign da-dt-mov = prazo-compra.data-entrega.

                if  da-dt-mov < tt-param.da-data-inicial
                or  da-dt-mov > tt-param.da-data-final then
                    next.

                assign de-preco-conv = de-preco
                       c-parc   = string(prazo-compra.parcela,"99").

                if  cotacao-item-cex.mo-codigo <> 0 then do:

                    find cota-cb
                         where cota-cb.ep-codigo = param-cb.ep-codigo
                           and cota-cb.mo-codigo = cotacao-item-cex.mo-codigo
                           and cota-cb.data      = da-dt-mov no-lock no-error.
                    if not avail cota-cb then do:
                        run utp/ut-msgs.p (input "msg",
                                           input 7450,
                                           input string(param-cb.ep-codigo) + "~~" +
                                                 string(cotacao-item-cex.mo-codigo) + "~~" +
                                                 string(da-dt-mov)).
                        create tt-erro.
                        assign tt-erro.cd-erro  = 7450
                               tt-erro.modulo   = "MCC"
                               tt-erro.mensagem = return-value.
                        return "NOK":U.
                    end.
                    else
                        assign de-preco-conv = de-preco * cota-cb.cotacao.
                end.

                {ccp/ccapi007.i1 "cotacao-item-cex.cod-emitente-desp"}
            end.
            else do:
                do i-ind = 1 to cond-pagto.num-parcelas:

                    if da-data[i-ind] < tt-param.da-data-inicial or
                       da-data[i-ind] > tt-param.da-data-final then
                        next.

                    assign da-dt-mov     = da-data[i-ind]
                           de-valor      = (de-preco * cond-pagto.per-pg-dup[i-ind] / 100)
                           c-parc        = string(prazo-compra.parcela,"99")
                           de-preco-conv = de-valor.


                    if cotacao-item-cex.mo-codigo <> 0 then do:
                        find cota-cb
                            where cota-cb.ep-codigo = param-cb.ep-codigo
                              and cota-cb.mo-codigo = cotacao-item-cex.mo-codigo
                              and cota-cb.data      = da-dt-mov no-lock no-error.
                        if not avail cota-cb then do:
                            run utp/ut-msgs.p (input "msg",
                                               input 7450,
                                               input string(param-cb.ep-codigo) + "~~" +
                                                     string(cotacao-item-cex.mo-codigo) + "~~" +
                                                     string(da-dt-mov)).
                            create tt-erro.
                            assign tt-erro.cd-erro=7450
                                   tt-erro.modulo = "MCC"
                                   tt-erro.mensagem = return-value.
                            return "nok".
                        end.
                        else do:
                            assign de-preco-conv = de-valor * cota-cb.cotacao.
                        end.
                    end.

                    {ccp/ccapi007.i1 "cotacao-item-cex.cod-emitente-desp"}

                end.
            end.
        end.
        else do:
            find cond-especif-cex
                where cond-especif-cex.num-pedido        = ordem-compra.num-pedido
                  and cond-especif-cex.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp
                  and cond-especif-cex.cod-desp          = cotacao-item-cex.cod-desp no-lock no-error.
            if not avail cond-especif-cex then
                next.

            assign i-nr-datas = 0.

            do i-ind = 1 to 6:
                if cond-especif-cex.data-pagto[i-ind] = ? then
                    leave.
                assign i-nr-datas = i-nr-datas + 1.
            end.

            if i-nr-datas > 0 then do:

                do i-ind = 1 to i-nr-datas:

                    if  cond-especif-cex.data-pagto[i-ind] < tt-param.da-data-inicial
                    or  cond-especif-cex.data-pagto[i-ind] > tt-param.da-data-final then
                        next.

                    assign de-valor  = de-preco * cond-especif-cex.perc-pagto[i-ind] / 100
                           da-dt-mov = cond-especif-cex.data-pagto[i-ind]
                           c-parc    = string(i-ind,"99")
                           de-preco-conv = de-valor.

                    if cotacao-item-cex.mo-codigo <> 0 then do:
                        find cota-cb
                            where cota-cb.ep-codigo = param-cb.ep-codigo
                              and cota-cb.mo-codigo = cotacao-item-cex.mo-codigo
                              and cota-cb.data      = cond-especif-cex.data-pagto[i-ind] no-lock no-error.
                        if  not avail cota-cb then do:
                            run utp/ut-msgs.p (input "msg",
                                                input 7450,
                                                input string(param-cb.ep-codigo) + "~~" +
                                                       string(cotacao-item-cex.mo-codigo) + "~~" +
                                                       string(da-dt-mov)).
                              create tt-erro.
                              assign tt-erro.cd-erro=7450
                                     tt-erro.modulo = "MCC"
                                     tt-erro.mensagem = return-value.
                              return "nok".
                        end.
                        else
                            assign de-preco-conv = de-valor * cota-cb.cotacao.
                    end.

                    {ccp/ccapi007.i1 "cotacao-item-cex.cod-emitente-desp"}

                end.
            end.
        end.
    end.

end procedure.


procedure gera-fluxo-caixa-im9017:
/**
*** Procedure executada apartir do ccapi011.
***
**/
    find ordem-compra
        where rowid(ordem-compra) = rw-ordem-compra no-lock no-error.

    find first prazo-compra
        where rowid(prazo-compra) = rw-prazo-compra no-lock no-error.

    find first param-compra no-lock no-error.

    find first tt-param-fluxo no-lock no-error.

    find first param-cb where
               param-cb.ep-codigo = i-empresa no-lock no-error.

    find cotacao-item
        where cotacao-item.numero-ordem = ordem-compra.numero-ordem
          and cotacao-item.cod-emitente = ordem-compra.cod-emitente
          and cotacao-item.it-codigo    = ordem-compra.it-codigo
          and cotacao-item.cot-aprovada = yes no-lock no-error.
    if  avail cotacao-item then do:

        do transaction:
            {cdp/cd4300.i4 "yes" cotacao-item.char-1}
            {ccp/cc9019.i51 "yes"}
        end.

        for each cotacao-item-cex
            where  cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
               and cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente
               and cotacao-item-cex.it-codigo    = cotacao-item.it-codigo
               and cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
               and cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao
               and cotacao-item-cex.mapa-cotacao = i-mapa-cotacao-i50
               and cotacao-item-cex.cod-incoterm = c-cod-incoterm-i50 no-lock:


            find desp-imp
                where desp-imp.cod-desp = cotacao-item-cex.cod-desp no-lock no-error.
            if avail desp-imp and desp-imp.tipo = 1 then
                assign de-preco-unit = cotacao-item-cex.val-desp.
            else
                assign de-preco-unit = cotacao-item-cex.val-desp * prazo-compra.quant-saldo.

            if not avail desp-imp               or
               not desp-imp.inc-val-embal       and
               not desp-imp.inc-val-frete       and
               not desp-imp.inc-val-outras-desp and
               not desp-imp.inc-val-seguro then next.

            assign i-cond-pagto  = cotacao-item-cex.cod-cond-pag
                   i-mo-codigo   = cotacao-item-cex.mo-codigo.

            find first processo-imp
                where processo-imp.num-pedido = ordem-compra.num-pedido no-lock no-error.

            IF AVAIL processo-imp THEN DO:

                FIND FIRST ordens-embarque WHERE
                           ordens-embarque.numero-ordem = ordem-compra.numero-ordem AND
                           ordens-embarque.parcela      = prazo-compra.parcela      NO-LOCK NO-ERROR.

                IF AVAIL ordens-embarque THEN DO:

                    FIND historico-embarque WHERE
                         historico-embarque.cod-estabel   = processo-imp.cod-estabel       AND
                         historico-embarque.embarque      = ordens-embarque.embarque       AND
                         historico-embarque.cod-pto-contr = cotacao-item-cex.cod-pto-contr NO-LOCK NO-ERROR.

                    IF AVAIL historico-embarque THEN DO:
                        FIND desp-embarque WHERE
                             desp-embarque.cod-estabel       = historico-embarque.cod-estabel     AND
                             desp-embarque.embarque          = historico-embarque.embarque        AND
                             desp-embarque.cod-itiner        = historico-embarque.cod-itiner      AND
                             desp-embarque.cod-pto-contr     = historico-embarque.cod-pto-contr   AND
                             desp-embarque.cod-desp          = cotacao-item-cex.cod-desp          AND
                             desp-embarque.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp NO-LOCK NO-ERROR.

                        IF AVAIL desp-embarque THEN DO:
                            /*- Busca valor rateado das despesas do embarque
                              - So cria a tt-desp-rateio uma vez*/
                            IF NOT CAN-FIND(FIRST tt-desp-rateio) THEN DO:

                                IF NOT VALID-HANDLE(h-im0091)         OR
                                    h-im0091:TYPE <> "PROCEDURE":U    OR
                                    h-im0091:FILE-NAME <> "imp/im0091.p":U THEN DO:
                                    RUN imp/im0091.p PERSISTENT SET h-im0091.
                                END.

                                RUN setaValorinicial     IN h-im0091 (INPUT TODAY,
                                                                      INPUT desp-embarque.cod-estabel).

                                RUN rateioAcompanhamento IN h-im0091 (INPUT  desp-embarque.cod-estabel,
                                                                      INPUT  desp-embarque.embarque,
                                                                      OUTPUT TABLE tt-desp-rateio).

                                IF  VALID-HANDLE(h-im0091) THEN DO:
                                    DELETE PROCEDURE h-im0091.
                                    ASSIGN h-im0091 = ?.
                                END.

                            END.

                            FIND FIRST tt-desp-rateio
                                 WHERE tt-desp-rateio.numero-ordem = ordens-embarque.numero-ordem
                                   AND tt-desp-rateio.parcela      = ordens-embarque.parcela
                                   AND tt-desp-rateio.cod-desp     = desp-embarque.cod-desp NO-ERROR.
                            IF AVAIL tt-desp-rateio THEN DO:
                               ASSIGN i-cond-pagto  = desp-embarque.cod-cond-pag
                                      i-mo-codigo   = desp-embarque.mo-codigo.
                               IF i-mo-codigo = 0 THEN
                                  ASSIGN de-preco-unit = tt-desp-rateio.val-desp.
                               ELSE
                                  ASSIGN de-preco-unit = tt-desp-rateio.val-desp-mo.
                            END.
                        END.
                    END.
                END.
            END.

            if i-cond-pagto <> 0 then do:
                if  avail processo-imp then do:
                    if  not avail historico-embarque then do:
                        find historico-proc-imp where
                             historico-proc-imp.cod-estabel   = processo-imp.cod-estabel       and
                             historico-proc-imp.nr-proc-imp   = processo-imp.nr-proc-imp       and
                             historico-proc-imp.cod-pto-contr = cotacao-item-cex.cod-pto-contr no-lock no-error.
                        if  avail historico-proc-imp then
                            if historico-proc-imp.dt-efetiva <> ? then
                                assign da-partida  =  historico-proc-imp.dt-efetiva.
                            else
                                assign da-partida  =  historico-proc-imp.dt-ult-previsao.
                    end.
                    else do:
                        if historico-embarque.dt-efetiva <> ? then
                            assign da-partida  = historico-embarque.dt-efetiva.
                        else
                            assign da-partida  = historico-embarque.dt-ult-previsao.
                    end.

                    if  not avail historico-embarque
                    and not avail historico-proc-imp then
                        assign da-partida = prazo-compra.data-entrega.
                end.
                else
                    assign da-partida = prazo-compra.data-entrega.

                assign da-dt-mov = da-partida
                       da-data = da-partida.

                {cdp/cd9020.i param-compra.end-entr-pad}

                if  cond-pagto.cod-vencto = 3 then next.

                if  cond-pagto.cod-vencto = 4 then do:

                    if  da-dt-mov < tt-param-fluxo.dt-ini
                    or  da-dt-mov > tt-param-fluxo.dt-fim then
                        next.

                    assign de-preco-conv = de-preco-unit.

                    find emitente where
                         emitente.cod-emitente = cotacao-item-cex.cod-emitente-desp no-lock no-error.

                    if not avail emitente then
                       next.

                    /**  Esta temp-table tt-despesas-importacao, no ems n∆o Ç utilizada, como retorno para
                    ***  ccapi011, s¢ Ç utilizada para controle de registro.
                    **/

                    find first tt-despesas-importacao where
                               tt-despesas-importacao.data-fluxo   = da-dt-mov and
                               tt-despesas-importacao.tp-codigo    = cotacao-item-cex.tp-despesa and
                               tt-despesas-importacao.nome-abrev   = emitente.nome-abrev         and
                               tt-despesas-importacao.numero-ordem = string(cotacao-item-cex.numero-ordem) and
                               tt-despesas-importacao.embarque     = ordens-embarque.embarque      no-error.

                    assign l-atualiza-fluxo = no.

                    if avail tt-despesas-importacao then do:
                        if tt-despesas-importacao.cod-desp = cotacao-item-cex.cod-desp then
                            if desp-imp.tipo <> 1 then
                                assign tt-despesas-importacao.vl-fluxo = tt-despesas-importacao.vl-fluxo + de-preco-conv
                                       de-preco-total = de-preco-conv
                                       l-atualiza-fluxo = yes.
                        else do:
                            assign tt-despesas-importacao.vl-fluxo = tt-despesas-importacao.vl-fluxo + de-preco-conv
                                   de-preco-total = de-preco-conv
                                   l-atualiza-fluxo = yes.
                        end.
                    end.
                    else do:
                        create  tt-despesas-importacao.
                        assign  tt-despesas-importacao.data-fluxo   = da-dt-mov
                                tt-despesas-importacao.tp-codigo    = cotacao-item-cex.tp-despesa
                                tt-despesas-importacao.nome-abrev   = emitente.nome-abrev
                                tt-despesas-importacao.numero-ordem = string(cotacao-item-cex.numero-ordem)
                                tt-despesas-importacao.parcela      = string(ordens-embarque.parcela)
                                tt-despesas-importacao.embarque     = ordens-embarque.embarque
                                tt-despesas-importacao.vl-fluxo     = de-preco-conv
                                tt-despesas-importacao.cod-desp     = cotacao-item-cex.cod-desp
                                de-preco-total = de-preco-conv
                                l-atualiza-fluxo = yes.
                    end.

                    if l-atualiza-fluxo then
                        RUN pi-atualiza-fluxo ( INPUT prazo-compra.parcela,
                                                INPUT cotacao-item-cex.cod-emitente-desp,
                                                INPUT i-mo-codigo, /*cotacao-item-cex.mo-codigo*/
                                                INPUT cotacao-item-cex.tp-despesa).
                end.
                else do:

                    do  i-ind = 1 to cond-pagto.num-parcelas:

                        if  da-data[i-ind] < tt-param-fluxo.dt-ini
                        or  da-data[i-ind] > tt-param-fluxo.dt-fim then do:
                            next.
                        end.

                        assign da-dt-mov       = da-data[i-ind]
                               de-preco-total  = (de-preco-unit * cond-pagto.per-pg-dup[i-ind] / 100)
                               de-preco-conv   = de-preco-total
                               c-parc = string(prazo-compra.parcela,"999").

                        find emitente where
                             emitente.cod-emitente = cotacao-item-cex.cod-emitente-desp no-lock no-error.
                        if not avail emitente then next.

                        find first tt-despesas-importacao where
                                   tt-despesas-importacao.data-fluxo   = da-dt-mov and
                                   tt-despesas-importacao.tp-codigo    = cotacao-item-cex.tp-despesa AND
                                   tt-despesas-importacao.nome-abrev   = emitente.nome-abrev         AND
                                   tt-despesas-importacao.numero-ordem = string(cotacao-item-cex.numero-ordem) and
                                   tt-despesas-importacao.embarque     = ordens-embarque.embarque      no-error.

                        assign l-atualiza-fluxo = no.

                        if avail tt-despesas-importacao then do:

                            if tt-despesas-importacao.cod-desp = cotacao-item-cex.cod-desp then do:

                                if desp-imp.tipo <> 1 then do:
                                    assign tt-despesas-importacao.vl-fluxo = tt-despesas-importacao.vl-fluxo + de-preco-conv
                                           de-preco-total = de-preco-conv
                                           l-atualiza-fluxo = yes.

                                end.
                                else do:
                                    assign tt-despesas-importacao.vl-fluxo = tt-despesas-importacao.vl-fluxo + de-preco-conv
                                           de-preco-total = de-preco-conv
                                           l-atualiza-fluxo = yes.
                                end.
                            end.
                            else do:

                                assign tt-despesas-importacao.vl-fluxo = tt-despesas-importacao.vl-fluxo + de-preco-conv
                                       de-preco-total = de-preco-conv
                                       l-atualiza-fluxo = yes.

                            end.
                        end.
                        else do:

                            create tt-despesas-importacao.
                            assign tt-despesas-importacao.data-fluxo   = da-dt-mov
                                   tt-despesas-importacao.tp-codigo    = cotacao-item-cex.tp-despesa
                                   tt-despesas-importacao.nome-abrev   = emitente.nome-abrev
                                   tt-despesas-importacao.numero-ordem = string(cotacao-item-cex.numero-ordem)
                                   tt-despesas-importacao.parcela      = c-parc
                                   tt-despesas-importacao.embarque     = IF AVAIL ordens-embarque THEN ordens-embarque.embarque ELSE ""
                                   tt-despesas-importacao.cod-desp     = cotacao-item-cex.cod-desp
                                   tt-despesas-importacao.vl-fluxo     = de-preco-conv
                                   de-preco-total = de-preco-conv
                                   l-atualiza-fluxo = yes.

                        end.

                        if l-atualiza-fluxo then do:
                            RUN pi-atualiza-fluxo ( INPUT prazo-compra.parcela,
                                                    INPUT cotacao-item-cex.cod-emitente-desp,
                                                    INPUT i-mo-codigo, /*cotacao-item-cex.mo-codigo*/
                                                    INPUT cotacao-item-cex.tp-despesa).
                        end.
                    end.
                end.
            end.
            else do:
                find cond-especif-cex where
                     cond-especif-cex.num-pedido        = ordem-compra.num-pedido            and
                     cond-especif-cex.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp and
                     cond-especif-cex.cod-desp          = cotacao-item-cex.cod-desp
                    no-lock no-error.
                if  not avail cond-especif-cex then next.
                assign i-nr-datas = 0.
                do  i-ind = 1 to 6:
                    if  cond-especif-cex.data-pagto[i-ind] = ? then
                        leave.
                    assign i-nr-datas = i-nr-datas + 1.
                end.
                if  i-nr-datas > 0 then do i-ind = 1 to i-nr-datas:

                    if  cond-especif-cex.data-pagto[i-ind] < tt-param-fluxo.dt-ini
                    or  cond-especif-cex.data-pagto[i-ind] > tt-param-fluxo.dt-fim then
                        next.

                    assign de-preco-total  = de-preco-unit * cond-especif-cex.perc-pagto[i-ind] / 100
                           da-dt-mov = cond-especif-cex.data-pagto[i-ind]
                           de-preco-conv = de-preco-total.

                    find emitente where
                         emitente.cod-emitente = cotacao-item-cex.cod-emitente-desp no-lock no-error.

                    if not avail emitente then next.

                    find first tt-despesas-importacao where
                               tt-despesas-importacao.data-fluxo   = da-dt-mov and
                               tt-despesas-importacao.tp-codigo    = cotacao-item-cex.tp-despesa AND
                               tt-despesas-importacao.nome-abrev   = emitente.nome-abrev         AND
                               tt-despesas-importacao.numero-ordem = string(cotacao-item-cex.numero-ordem) and
                               tt-despesas-importacao.embarque     = ""                            no-error.

                    assign l-atualiza-fluxo = no.

                    if avail tt-despesas-importacao then
                        if tt-despesas-importacao.cod-desp = cotacao-item-cex.cod-desp then
                            if desp-imp.tipo <> 1 then
                                assign tt-despesas-importacao.vl-fluxo = tt-despesas-importacao.vl-fluxo + de-preco-conv
                                       de-preco-total = de-preco-conv.
                        else
                            assign tt-despesas-importacao.vl-fluxo = tt-despesas-importacao.vl-fluxo + de-preco-conv
                                   de-preco-total = de-preco-conv.
                    else do:
                        create tt-despesas-importacao.
                        assign tt-despesas-importacao.data-fluxo   = da-dt-mov
                               tt-despesas-importacao.tp-codigo    = cotacao-item-cex.tp-despesa
                               tt-despesas-importacao.nome-abrev   = emitente.nome-abrev
                               tt-despesas-importacao.numero-ordem = string(cotacao-item-cex.numero-ordem)
                               tt-despesas-importacao.parcela      = string(prazo-compra.parcela)
                               tt-despesas-importacao.embarque     = ""
                               tt-despesas-importacao.vl-fluxo     = de-preco-conv
                               de-preco-total = de-preco-conv
                               l-atualiza-fluxo = yes.
                    end.

                    if l-atualiza-fluxo then
                        RUN pi-atualiza-fluxo ( INPUT prazo-compra.parcela,
                                                INPUT cotacao-item-cex.cod-emitente-desp,
                                                INPUT i-mo-codigo, /*cotacao-item-cex.mo-codigo*/
                                                INPUT cotacao-item-cex.tp-despesa).
                end.
            end.
        end.
    end.
end procedure.

/* IM9008.I */

