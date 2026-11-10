/*************************************************************************
**
**   Include: ap0817rp.i3 
**
**   Gerar temp-table para a opcao "Analitico", quando a contabilizacao
**   foi aberta.
*************************************************************************/

conta-block:
for each conta-ap no-lock
    where conta-ap.ep-codigo    = i-ep-codigo-usuario
    and   conta-ap.conta-saldo >= tt-param.c-ini-conta
    and   conta-ap.conta-saldo <= tt-param.c-fim-conta
    break by conta-ap.conta-saldo:
    
    {utp/ut-liter.i Conta: * L}
    run pi-acompanhar in h-acomp (input return-value + " " + conta-ap.conta-saldo).
    
    if  first-of(conta-ap.conta-saldo) then do:
        find first conta-contab where
                   conta-contab.ep-codigo      = i-ep-codigo-usuario and  
                   conta-contab.conta-contabil = conta-ap.conta-saldo 
                   no-lock no-error.
     
        if avail conta-contab then
            assign c-titulo-conta = conta-contab.titulo.
        else
            assign c-titulo-conta = "".

        for each t-diario-ap no-lock
            where t-diario-ap.ep-codigo     = i-ep-codigo-usuario
            and   t-diario-ap.ct-conta      = conta-ap.ct-saldo
            and   t-diario-ap.sc-conta      = conta-ap.sc-saldo
            and   t-diario-ap.dt-transacao >= tt-param.dt-ini-period
            and   t-diario-ap.dt-transacao <= tt-param.dt-fim-period
            and   t-diario-ap.lancamento    = 1
            break by t-diario-ap.dt-transacao
                  by t-diario-ap.vl-debito:

            case tt-param.moeda:
            	when 1 then assign de-vl-moeda = if t-diario-ap.lancamento = 1
            					      then t-diario-ap.vl-debito
            					      else t-diario-ap.vl-credito.
            	when 2 then assign de-vl-moeda = t-diario-ap.vl-deb-fasb.
            	when 3 then assign de-vl-moeda = t-diario-ap.vl-deb-cmi.
            	when 4 then assign de-vl-moeda = t-diario-ap.vl-deb-presente.
            end.
                        
            create tt-diario.
            assign tt-diario.empresa  = t-diario-ap.ep-codigo
                   tt-diario.ct-conta = t-diario-ap.ct-conta
                   tt-diario.sc-conta = t-diario-ap.sc-conta
                   tt-diario.data     = t-diario-ap.dt-transacao
                   tt-diario.debito   = de-vl-moeda
                   tt-diario.estab    = t-diario-ap.cod-estabel
                   tt-diario.espec    = t-diario-ap.cod-esp
                   tt-diario.docto    = t-diario-ap.nr-docto
                   tt-diario.parcela  = t-diario-ap.parcela
                   tt-diario.tipo     = "DB"
                   tt-diario.lido     = no.
        end.
        
        for each t-diario-ap no-lock
            where t-diario-ap.ep-codigo     = i-ep-codigo-usuario
            and   t-diario-ap.ct-conta      = conta-ap.ct-saldo
            and   t-diario-ap.sc-conta      = conta-ap.sc-saldo
            and   t-diario-ap.dt-transacao >= tt-param.dt-ini-period
            and   t-diario-ap.dt-transacao <= tt-param.dt-fim-period
            and   t-diario-ap.lancamento    = 2
            break by t-diario-ap.dt-transacao
                  by t-diario-ap.vl-credito:

            case tt-param.moeda:
            	when 1 then assign de-vl-moeda = if t-diario-ap.lancamento = 1
            					      then t-diario-ap.vl-debito
            					      else t-diario-ap.vl-credito.
            	when 2 then assign de-vl-moeda = t-diario-ap.vl-deb-fasb.
            	when 3 then assign de-vl-moeda = t-diario-ap.vl-deb-cmi.
            	when 4 then assign de-vl-moeda = t-diario-ap.vl-deb-presente.
            end.

            create tt-diario.
            assign tt-diario.empresa  = t-diario-ap.ep-codigo
                   tt-diario.ct-conta = t-diario-ap.ct-conta
                   tt-diario.sc-conta = t-diario-ap.sc-conta
                   tt-diario.data     = t-diario-ap.dt-transacao
                   tt-diario.credito  = de-vl-moeda
                   tt-diario.estab    = t-diario-ap.cod-estabel
                   tt-diario.espec    = t-diario-ap.cod-esp
                   tt-diario.docto    = t-diario-ap.nr-docto
                   tt-diario.parcela  = t-diario-ap.parcela
                   tt-diario.tipo     = "CR"
                   tt-diario.lido     = no.
        end.
             
        assign l-prim-mov1 = yes
               l-prim-mov2 = yes.
        
        block-movto1:
        for each movimento no-lock
            where movimento.ep-codigo    = conta-ap.ep-codigo
            and   movimento.ct-codigo    = conta-ap.ct-saldo
            and   movimento.sc-codigo    = conta-ap.sc-saldo
            and   movimento.data        >= tt-param.dt-ini-period
            and   movimento.data        <= tt-param.dt-fim-period
            and  (movimento.tipo         = 1
            or    movimento.tipo         = 3)
            break by movimento.data
                  by movimento.valor:
            
            case tt-param.moeda:
            	  when 1 then assign de-vl-moeda = movimento.valor.
                when 2 then assign de-vl-moeda = movimento.valor-fasb.
                when 3 then assign de-vl-moeda = movimento.valor-cmi.
                when 4 then assign de-vl-moeda = movimento.valor-presente.
            end.

            create tt-concil-ap.
            assign tt-concil-ap.dt-contab     = movimento.data
                   tt-concil-ap.ct-conta      = movimento.ct-codigo
                   tt-concil-ap.sc-conta      = movimento.sc-codigo
                   tt-concil-ap.refer         = movimento.referencia
                   tt-concil-ap.titulo        = c-titulo-conta
                   tt-concil-ap.debito-contab = de-vl-moeda.
    
            if l-prim-mov1 = yes then do:
                find first tt-diario exclusive-lock
                    where tt-diario.empresa  = i-ep-codigo-usuario
                      and tt-diario.ct-conta = conta-ap.ct-saldo
                      and tt-diario.sc-conta = conta-ap.sc-saldo
                      and tt-diario.data     = movimento.data                      
                      and tt-diario.tipo     = "DB"  no-error.
    
                if  avail tt-diario then do:
                    assign tt-concil-ap.estab         = tt-diario.estab
                           tt-concil-ap.espec         = tt-diario.espec
                           tt-concil-ap.docto         = tt-diario.docto
                           tt-concil-ap.parcela       = tt-diario.parcela
                           tt-concil-ap.dt-modulo     = tt-diario.data
                           tt-concil-ap.debito-modulo = tt-diario.debito
                           tt-diario.lido = yes.
                    assign l-prim-mov1 = no.
                end.
            end.
            else do:   
                find next tt-diario exclusive-lock
                    where tt-diario.empresa  = i-ep-codigo-usuario
                      and tt-diario.ct-conta = conta-ap.ct-saldo
                      and tt-diario.sc-conta = conta-ap.sc-saldo
                      and tt-diario.data     = movimento.data                      
                      and tt-diario.tipo     = "DB"  no-error.
                 if  avail tt-diario then 
                    assign tt-concil-ap.estab         = tt-diario.estab
                           tt-concil-ap.espec         = tt-diario.espec
                           tt-concil-ap.docto         = tt-diario.docto
                           tt-concil-ap.parcela       = tt-diario.parcela
                           tt-concil-ap.dt-modulo     = tt-diario.data
                           tt-concil-ap.debito-modulo = tt-diario.debito
                           tt-diario.lido = yes.
            end.
        end /*block-movto1*/.
        
        block-movto2:
        for each movimento no-lock
            where movimento.ep-codigo    = conta-ap.ep-codigo
            and   movimento.ct-codigo    = conta-ap.ct-saldo
            and   movimento.sc-codigo    = conta-ap.sc-saldo
            and   movimento.data        >= tt-param.dt-ini-period
            and   movimento.data        <= tt-param.dt-fim-period
            and  (movimento.tipo         = 2
            or    movimento.tipo         = 4)
            break by movimento.data
                  by movimento.valor:

            case tt-param.moeda:
                when 1 then assign de-vl-moeda = movimento.valor.
                when 2 then assign de-vl-moeda = movimento.valor-fasb.
                when 3 then assign de-vl-moeda = movimento.valor-cmi.
                when 4 then assign de-vl-moeda = movimento.valor-presente.
            end.

            create tt-concil-ap.
            assign tt-concil-ap.dt-contab      = movimento.data
                   tt-concil-ap.ct-conta       = movimento.ct-codigo
                   tt-concil-ap.sc-conta       = movimento.sc-codigo
                   tt-concil-ap.refer          = movimento.referencia
                   tt-concil-ap.titulo         = c-titulo-conta
                   tt-concil-ap.credito-contab = de-vl-moeda.

            if l-prim-mov2 = yes then do:
                find first tt-diario exclusive-lock
                    where tt-diario.empresa  = i-ep-codigo-usuario
                      and tt-diario.ct-conta = conta-ap.ct-saldo
                      and tt-diario.sc-conta = conta-ap.sc-saldo
                      and tt-diario.data     = movimento.data                      
                      and tt-diario.tipo     = "CR" no-error.
    
                if  avail tt-diario then do:
                    assign tt-concil-ap.estab          = tt-diario.estab
                           tt-concil-ap.espec          = tt-diario.espec
                           tt-concil-ap.docto          = tt-diario.docto
                           tt-concil-ap.parcela        = tt-diario.parcela
                           tt-concil-ap.dt-modulo      = tt-diario.data
                           tt-concil-ap.credito-modulo = tt-diario.credito
                           tt-diario.lido = yes.
                    assign l-prim-mov2 = no.
                end.
            end.
            else do:   
                find next tt-diario exclusive-lock
                    where tt-diario.empresa  = i-ep-codigo-usuario
                      and tt-diario.ct-conta = conta-ap.ct-saldo
                      and tt-diario.sc-conta = conta-ap.sc-saldo
                      and tt-diario.data     = movimento.data
                      and tt-diario.tipo     = "CR"  no-error.
    
                if  avail tt-diario then 
                    assign tt-concil-ap.estab          = tt-diario.estab
                           tt-concil-ap.espec          = tt-diario.espec
                           tt-concil-ap.docto          = tt-diario.docto
                           tt-concil-ap.parcela        = tt-diario.parcela
                           tt-concil-ap.dt-modulo      = tt-diario.data
                           tt-concil-ap.credito-modulo = tt-diario.credito
                           tt-diario.lido = yes.
            end.
        end /*block-movto2*/.

        /*Procura por movimentos diferentes que nÆo estÆo na contabilidade*/
        for each tt-diario no-lock
            where tt-diario.empresa  = i-ep-codigo-usuario
              and tt-diario.ct-conta = conta-ap.ct-saldo
              and tt-diario.sc-conta = conta-ap.sc-saldo
              and tt-diario.data    >= tt-param.dt-ini-period
              and tt-diario.data    <= tt-param.dt-fim-period
              and tt-diario.lido     = no
            break by tt-diario.data
                  by tt-diario.credito:

            create tt-concil-ap.
            assign tt-concil-ap.ct-conta  = conta-ap.ct-saldo
                   tt-concil-ap.sc-conta  = conta-ap.sc-saldo
                   tt-concil-ap.dt-contab = tt-diario.data
                   tt-concil-ap.titulo    = c-titulo-conta

                   tt-concil-ap.estab     = tt-diario.estab
                   tt-concil-ap.espec     = tt-diario.espec
                   tt-concil-ap.docto     = tt-diario.docto
                   tt-concil-ap.parcela   = tt-diario.parcela
                   tt-concil-ap.dt-modulo = tt-diario.data.

            if tt-diario.tipo = "CR" then
                assign tt-concil-ap.credito-modulo = tt-diario.credito.
            else
                assign tt-concil-ap.debito-modulo  = tt-diario.debito.

        end /*tt-diario*/.

    end /*first-of*/.
end /*conta-block*/.
/* Fim de Include */
