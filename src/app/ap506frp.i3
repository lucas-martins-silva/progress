/*********************************************************************************
***
*** app/ap506frp.i3 - pi-cancelar-substituicoes
***
*********************************************************************************/
        
nota-block:
for each  nota-dup exclusive-lock use-index referencia
    where nota-dup.ep-codigo-n  = tt-param.i-ep-codigo
    and   nota-dup.referencia   = tt-param.referencia
    and   nota-dup.dt-transacao = tt-param.dt-transacao on error  undo nota-block, return error
                                                        on endkey undo nota-block, return error
                                                        on stop   undo nota-block, return error:
                
    /* P/ Controle Bloqueio */
    {app/ap6001.i3 nota-dup.ep-codigo-n
                   nota-dup.cod-estabel-n
                   nota-dup.cod-fornec
                   nota-dup.cod-esp-n
                   nota-dup.serie-n
                   nota-dup.nr-docto-n
                   nota-dup.parcela-n
                   nota-dup.referencia
                   nota-dup.dt-transacao}
                 
    {app/ap6001.i3 nota-dup.ep-codigo
                   nota-dup.cod-estabel-d
                   nota-dup.fornec-dup
                   nota-dup.cod-esp-d
                   nota-dup.serie-d
                   nota-dup.nr-docto-d
                   nota-dup.parcela-d
                   nota-dup.referencia
                   nota-dup.dt-transacao}
                     
    run pi-acompanhar in h-acomp (input (c-obj-proces + nota-dup.nr-docto-n + "/" + nota-dup.parcela-n)).
            
    repeat:
                
        find first mov-ap exclusive-lock
             where mov-ap.ep-codigo    = nota-dup.ep-codigo-n
             and   mov-ap.cod-fornec   = nota-dup.cod-fornec
             and   mov-ap.cod-estabel  = nota-dup.cod-estabel-n
             and   mov-ap.cod-esp      = nota-dup.cod-esp-n
             and   mov-ap.serie        = nota-dup.serie-n
             and   mov-ap.nr-docto     = nota-dup.nr-docto-n
             and   mov-ap.parcela      = nota-dup.parcela-n
             and   mov-ap.referencia   = nota-dup.referencia
             and   mov-ap.dt-transacao = nota-dup.dt-transacao
             and  (mov-ap.transacao    = 6
             or    mov-ap.transacao    = 2) no-error.
                
        if  not avail mov-ap then do:
            find first mov-ap exclusive-lock
                 where mov-ap.ep-codigo    = nota-dup.ep-codigo-n
                 and   mov-ap.cod-fornec   = nota-dup.cod-fornec
                 and   mov-ap.cod-estabel  = nota-dup.cod-estabel-n
                 and   mov-ap.cod-esp      = nota-dup.cod-esp-n
                 and   mov-ap.serie        = nota-dup.serie-n
                 and   mov-ap.nr-docto     = nota-dup.nr-docto-n
                 and   mov-ap.parcela      = nota-dup.parcela-n
                 and   mov-ap.transacao    = 5
                 and   mov-ap.impostos     = yes no-error.
                    
            if  not avail mov-ap or (avail mov-ap and mov-ap.baixa-subs = no) then 
                leave.  
                    
        end.      
                
        if  avail mov-ap then do:
            find first tit-ap exclusive-lock
                 where tit-ap.ep-codigo   = nota-dup.ep-codigo-n
                 and   tit-ap.cod-fornec  = nota-dup.cod-fornec
                 and   tit-ap.cod-estabel = nota-dup.cod-estabel-n
                 and   tit-ap.cod-esp     = nota-dup.cod-esp-n
                 and   tit-ap.serie       = nota-dup.serie-n
                 and   tit-ap.nr-docto    = nota-dup.nr-docto-n
                 and   tit-ap.parcela     = nota-dup.parcela-n no-error.
                 
            if  avail tit-ap then do:
                        
                assign tit-ap.valor-saldo = tit-ap.valor-saldo + mov-ap.valor-mov
                       tit-ap.vl-saldo-me = tit-ap.vl-saldo-me + mov-ap.valor-mov-me
                       tit-ap.dt-liq      = 12/31/9999.
                    
                /*cria emite-ap*/
                find first espec-ap 
                        where espec-ap.cod-esp = tit-ap.cod-esp
                        no-lock no-error.
        
                if  avail espec-ap then do:                
                    if  espec-ap.emite-ap = yes then do:
                        find first emite-ap
                             where emite-ap.ep-codigo   = tit-ap.ep-codigo
                             and   emite-ap.cod-estabel = tit-ap.cod-estabel
                             and   emite-ap.cod-esp     = tit-ap.cod-esp
                             and   emite-ap.serie       = tit-ap.serie
                             and   emite-ap.nr-docto    = tit-ap.nr-docto
                             and   emite-ap.parcela     = tit-ap.parcela
                             and   emite-ap.cod-fornec  = tit-ap.cod-fornec
                             and   emite-ap.transacao   = 1
                             no-lock no-error.
                
                        if  not avail emite-ap then do:
                            create emite-ap.
                            assign emite-ap.ep-codigo = tit-ap.ep-codigo
                                emite-ap.cod-estabel  = tit-ap.cod-estabel
                                emite-ap.cod-esp      = tit-ap.cod-esp
                                emite-ap.serie        = tit-ap.serie
                                emite-ap.nr-docto     = tit-ap.nr-docto
                                emite-ap.parcela      = tit-ap.parcela
                                emite-ap.cod-fornec   = tit-ap.cod-fornec
                                emite-ap.dt-emissao   = tit-ap.dt-emissao
                                emite-ap.dt-vencimen  = tit-ap.dt-vencimen
                                emite-ap.valor-ap     = tit-ap.vl-saldo
                                emite-ap.referencia   = tit-ap.referencia
                                emite-ap.transacao    = 1.
                        end.
                    end.
                end.    
            end.
                
            delete mov-ap.
            
            /*--- INTEGRA€åES ---*/
            {app/ap9100.i2}
            assign tt-integ-ap.tt-row-tit-ap  = rowid(tit-ap)
                   tt-integ-ap.tt-cb1202a     = yes
                   tt-integ-ap.tt-ge0102b     = yes
                   tt-integ-ap.tt-ge0102g     = yes
                   tt-integ-ap.tt-cb0110a     = yes  
                   tt-integ-ap.tt-op-ge0102b  = 16
                   tt-integ-ap.tt-op-ge0102g  = 16
                   tt-integ-ap.tt-op-cb0110a  = 16
                   tt-integ-ap.tt-op-cb1202a  = 22.
            raw-transfer tt-integ-ap to raw-integracao.
            run app/ap9100.p (input raw-integracao, input-output table tt-erro).
        end.
    end.
            
    for each  mov-ap exclusive-lock
        where mov-ap.ep-codigo   = nota-dup.ep-codigo
        and   mov-ap.cod-fornec  = nota-dup.fornec-dup
        and   mov-ap.cod-estabel = nota-dup.cod-estabel-d
        and   mov-ap.cod-esp     = nota-dup.cod-esp-d
        and   mov-ap.serie       = nota-dup.serie-d
        and   mov-ap.nr-docto    = nota-dup.nr-docto-d
        and   mov-ap.parcela     = nota-dup.parcela-d:
            
        if (mov-ap.transacao = 6 or mov-ap.transacao = 2 ) and mov-ap.lancamento = 2 then do:
                         
            find first tit-ap exclusive-lock
                 where tit-ap.ep-codigo   = nota-dup.ep-codigo
                 and   tit-ap.cod-fornec  = nota-dup.fornec-dup
                 and   tit-ap.cod-estabel = nota-dup.cod-estabel-d
                 and   tit-ap.cod-esp     = nota-dup.cod-esp-d
                 and   tit-ap.serie       = nota-dup.serie-d
                 and   tit-ap.nr-docto    = nota-dup.nr-docto-d
                 and   tit-ap.parcela     = nota-dup.parcela-d no-error.
                    
             if  avail tit-ap then do:
                 {app/ap9100.i2}
                 assign tt-integ-ap.tt-row-tit-ap  = rowid(tit-ap)
                        tt-integ-ap.tt-cb1202a     = yes
                        tt-integ-ap.tt-ge0102b     = yes
                        tt-integ-ap.tt-ge0102g     = yes
                        tt-integ-ap.tt-cb0110a     = yes 
                        tt-integ-ap.tt-op-ge0102b  = 6
                        tt-integ-ap.tt-op-ge0102g  = 6
                        tt-integ-ap.tt-op-cb0110a  = 6
                        tt-integ-ap.tt-op-cb1202a  = 6.
                 raw-transfer tt-integ-ap to raw-integracao.
                 run app/ap9100.p (input raw-integracao, input-output table tt-erro).
             end.
         end.        
         
         /*-----------IVA-----------*/
         if i-pais-impto-usuario = 4 then do:
             for each  tit-conta-ap
                 where tit-conta-ap.ep-codigo   = mov-ap.ep-codigo
                 and   tit-conta-ap.cod-estabel = mov-ap.cod-estabel
                 and   tit-conta-ap.cod-esp     = mov-ap.cod-esp
                 and   tit-conta-ap.serie       = mov-ap.serie
                 and   tit-conta-ap.nr-docto    = mov-ap.nr-docto
                 and   tit-conta-ap.parcela     = mov-ap.parcela
                 and   tit-conta-ap.cod-fornec  = mov-ap.cod-fornec
                 exclusive-lock:
                 delete tit-conta-ap.
             end.
         end.
         delete mov-ap.
    end.
  
    find first emite-ap exclusive-lock
         where emite-ap.ep-codigo   = nota-dup.ep-codigo
         and   emite-ap.cod-fornec  = nota-dup.fornec-dup
         and   emite-ap.cod-estabel = nota-dup.cod-estabel-d
         and   emite-ap.cod-esp     = nota-dup.cod-esp-d
         and   emite-ap.serie       = nota-dup.serie-d
         and   emite-ap.nr-docto    = nota-dup.nr-docto-d
         and   emite-ap.parcela     = nota-dup.parcela-d no-error.
        
    if  avail emite-ap then do:
        delete emite-ap.     
    end.          
        
    find first tit-ap exclusive-lock
         where tit-ap.ep-codigo   = nota-dup.ep-codigo
         and   tit-ap.cod-fornec  = nota-dup.fornec-dup
         and   tit-ap.cod-estabel = nota-dup.cod-estabel-d
         and   tit-ap.cod-esp     = nota-dup.cod-esp-d
         and   tit-ap.serie       = nota-dup.serie-d
         and   tit-ap.nr-docto    = nota-dup.nr-docto-d
         and   tit-ap.parcela     = nota-dup.parcela-d no-error.
            
    if  avail tit-ap then do:
                
        /*--- Limite de Reten‡Æo PIS/COFINS/CSLL ---*/
        if i-pais-impto-usuario = 1 then do:
            /* --- Elimina tabela de Complemento de Impostos --- */ 
            for each  compl-retenc-impto-pagto 
                where compl-retenc-impto-pagto.ep-codigo   = tit-ap.ep-codigo
                and   compl-retenc-impto-pagto.cod-estabel = tit-ap.cod-estabel
                and   compl-retenc-impto-pagto.cod-esp     = tit-ap.cod-esp
                and   compl-retenc-impto-pagto.serie       = tit-ap.serie
                and   compl-retenc-impto-pagto.parcela     = tit-ap.parcela
                and   compl-retenc-impto-pagto.nr-docto    = tit-ap.nr-docto
                and   compl-retenc-impto-pagto.cod-fornec  = tit-ap.cod-fornec exclusive-lock.
                delete compl-retenc-impto-pagto.
            end.
        end.
        
        delete tit-ap.
    end.
          
    create tt-nota-dup.
    buffer-copy nota-dup to tt-nota-dup.
  
    delete nota-dup.
      
end.

/* Fim de Include */
