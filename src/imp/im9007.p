/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9007 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9007 MIM}
&ENDIF

/*****************************************************************************
**
** IM9007 - Integra‡Æo entre os m¢dulos Caixa e Bancos e Importa‡Æo. (EMS)
**
** Objetivo: Gerar fluxo de caixa das despesas da importa‡Æo.
**
******************************************************************************/

{cdp/cdcfgmat.i} /* definicao pre-processadores importacao */

&if defined(bf-mat-comex) &then
&else
{cbp/cbapi001.i} /* defini‡Æo da temp-table tt-erro  */
{cdp/cd1204.i}   /* defini‡Æo da temp-table tt-param */

def input  parameter rw-ordem-compra as rowid.
def input  parameter rw-prazo-compra as rowid.
def input  parameter table for tt-param.
def output parameter table for tt-erro.

def var da-data      as date format "99/99/9999" extent 12.
def var da-partida   as date format "99/99/9999".
def var da-dt-mov    as date format "99/99/9999".

def var i-ind        as integer.
def var i-cond       as integer extent 12.

def var i-cond-pagto as integer.
def var i-nr-datas   as integer.

def var de-quant     as decimal.
def var de-valor     as decimal.
def var de-preco     as decimal.

def var c-parc       as character format "xx". 
def var c-tipo       as character format "xx".
def var c-serie      like mov-cb.serie.

def var l-atraso     as logical.

{cdp/cd4300.i3}
{ccp/cc9019.i50}

find first ordem-compra
    where rowid(ordem-compra) = rw-ordem-compra no-lock no-error.

find first prazo-compra
    where rowid(prazo-compra) = rw-prazo-compra no-lock no-error.
    
find first param-compra no-lock no-error.

find first tt-param.

find first param-cb where param-cb.ep-codigo = tt-param.i-emp no-lock.

find cotacao-item   
    where cotacao-item.numero-ordem = ordem-compra.numero-ordem
      and cotacao-item.cod-emitente = ordem-compra.cod-emitente
      and cotacao-item.it-codigo    = ordem-compra.it-codigo
      and cotacao-item.cot-aprovada = yes no-lock no-error.

if  avail cotacao-item then do:
    {cdp/cd4300.i4 "yes" cotacao-item.char-1}
    {ccp/cc9019.i51 "yes"} 
    for each cotacao-item-cex  
        where  cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
           and cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente
           and cotacao-item-cex.it-codigo    = cotacao-item.it-codigo
           and cotacao-item-cex.seq-cotac = cotacao-item.seq-cotac 
           and cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao           
           and cotacao-item-cex.mapa-cotacao = i-mapa-cotacao-i50
           and cotacao-item-cex.cod-incoterm = c-cod-incoterm-i50 no-lock:    
           
        find first desp-itiner 
            where desp-itiner.cod-desp   = cotacao-item-cex.cod-desp 
              and desp-itiner.cod-itiner = cotacao-item-cex.cod-itiner no-lock no-error.
        
        find first processo-imp 
            where processo-imp.num-pedido = ordem-compra.num-pedido no-lock no-error.                      

        if cotacao-item-cex.cod-cond-pag <> 0 then do:
        
            assign i-cond-pagto = cotacao-item-cex.cod-cond-pag.            
                   de-preco     = cotacao-item-cex.val-desp.                   
                   
            if  avail desp-itiner then do:
                find first ordens-embarque 
                    where ordens-embarque.numero-ordem = ordem-compra.numero-ordem 
                      and ordens-embarque.parcela      = prazo-compra.parcela no-lock no-error.
            
                find historico-embarque 
                    where historico-embarque.cod-estabel   = processo-imp.cod-estabel
                      and historico-embarque.embarque      = ordens-embarque.embarque
                      and historico-embarque.cod-itiner    = desp-itiner.cod-itiner
                      and historico-embarque.cod-pto-contr = desp-itiner.cod-pto-contr        
                      no-lock no-error.              
                
                if  not avail historico-embarque then do:
                    find historico-proc-imp 
                        where historico-proc-imp.cod-estabel   = processo-imp.cod-estabel
                          and historico-proc-imp.nr-proc-imp   = processo-imp.nr-proc-imp
                          and historico-proc-imp.cod-itiner    = desp-itiner.cod-itiner
                          and historico-proc-imp.cod-pto-contr = desp-itiner.cod-pto-contr
                          no-lock no-error.
                    if  avail historico-proc-imp then 
                        assign da-partida  = if  historico-proc-imp.dt-ult-previsao < param-cb.dt-inicial then
                                                 param-cb.dt-inicial
                                             else 
                                                 historico-proc-imp.dt-ult-previsao.                                                
                end.        
                    
                else 
                    assign da-partida  = if  historico-embarque.dt-ult-previsao < param-cb.dt-inicial then
                                             param-cb.dt-inicial
                                         else 
                                             historico-embarque.dt-ult-previsao.                    
                if  not avail historico-embarque 
                and not avail historico-proc-imp then
                    assign da-partida = prazo-compra.data-entrega.                                             
            end.            
            
            {cdp/cd9020.i param-compra.end-entr-pad}

            if  cond-pagto.cod-vencto = 3 then next.

            if  cond-pagto.cod-vencto = 4 then do:
                assign da-dt-mov = prazo-compra.data-entrega.
                if  da-dt-mov < tt-param.da-data-inicial
                or  da-dt-mov > tt-param.da-data-final then
                    next.
                if  cotacao-item-cex.mo-codigo <> 0 then do:
                    find cota-cb
                         where cota-cb.ep-codigo = param-cb.ep-codigo
                         and   cota-cb.mo-codigo = cotacao-item-cex.mo-codigo
                         and   cota-cb.data      = da-dt-mov no-lock no-error.
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
                    assign de-preco = de-preco * cota-cb.cotacao.
                end.
                assign de-valor = prazo-compra.quant-saldo * de-preco
                       c-parc = string(prazo-compra.parcela,"99").                       
                {ccp/ccapi005.i "cotacao-item-cex.cod-emitente-desp"}
            end.
            else do:
                assign de-quant = (prazo-compra.quant-saldo * de-preco).
                do  i-ind = 1 to cond-pagto.num-parcelas:
                    if  da-data[i-ind] < da-data-inicial
                    or  da-data[i-ind] > da-data-final then
                        next.
                    assign da-dt-mov = da-data[i-ind].
                           de-preco  = de-quant * 
                                       cond-pagto.per-pg-dup[i-ind] / 100.
                                       
                    if  cotacao-item-cex.mo-codigo <> 0 then do:
                        find cota-cb
                              where cota-cb.ep-codigo = param-cb.ep-codigo
                              and   cota-cb.mo-codigo = cotacao-item-cex.mo-codigo
                              and   cota-cb.data      = da-dt-mov no-lock no-error.
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
                        assign de-valor = de-preco * cota-cb.cotacao.
                    end.
                    else
                        assign de-valor = de-preco.
                    assign c-parc = string(prazo-compra.parcela,"99").
                    {ccp/ccapi005.i "cotacao-item-cex.cod-emitente-desp"}
                end.
            end.
        end.
        
        else do:        
            find cond-especif-cex
                where cond-especif-cex.num-pedido        = ordem-compra.num-pedido
                  and cond-especif-cex.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp
                  and cond-especif-cex.cod-desp          = cotacao-item-cex.cod-desp
                no-lock no-error.
            if  not avail cond-especif-cex then next.
            assign i-nr-datas = 0.
            do  i-ind = 1 to 6:
                if  cond-especif-cex.data-pagto[i-ind] = ? then
                    leave.
                assign i-nr-datas = i-nr-datas + 1.
            end.
            if  i-nr-datas > 0 then do i-ind = 1 to i-nr-datas:
                if  cond-especif-cex.data-pagto[i-ind] < tt-param.da-data-inicial
                or  cond-especif-cex.data-pagto[i-ind] > tt-param.da-data-final then
                    next.
                assign de-preco = cotacao-item-cex.val-desp.
                if  cotacao-item-cex.mo-codigo <> 0 then do:
                    find cota-cb
                         where cota-cb.ep-codigo = param-cb.ep-codigo
                         and   cota-cb.mo-codigo = cotacao-item-cex.mo-codigo
                         and   cota-cb.data      = cond-especif-cex.data-pagto[i-ind]
                         no-lock no-error.
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
                    assign de-preco = de-preco * cota-cb.cotacao.
                end.
                assign de-valor  = (de-quant * de-preco)
                                 * (cond-especif-cex.perc-pagto[i-ind] / 100)
                       da-dt-mov = cond-especif-cex.data-pagto[i-ind]
                       c-parc    = string(i-ind,"99").
                {ccp/ccapi005.i "cotacao-item-cex.cod-emitente-desp"}
            end.
        end.        
    end.           
end.

&endif

/* IM9007.P */
