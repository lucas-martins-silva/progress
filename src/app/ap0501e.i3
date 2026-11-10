/**************************************************************************
**
** AP0501E.I3 - Atualizaá∆o de Previs‰es
**
**************************************************************************/
        
if  espec-ap.usa-previsao then do:
    for each  l-pre-ap exclusive-lock
        where l-pre-ap.ep-codigo   = lin-i-ap.ep-codigo
        and   l-pre-ap.cod-estabel = lin-i-ap.cod-estabel
        and   l-pre-ap.cod-fornec  = lin-i-ap.cod-fornec
        and   l-pre-ap.cod-esp     = lin-i-ap.cod-esp
        and   l-pre-ap.serie       = lin-i-ap.serie
        and   l-pre-ap.nr-docto    = lin-i-ap.nr-docto
        and   l-pre-ap.parcela     = lin-i-ap.parcela:
       
        /* Busca a Previsao */     
        find first b-tit-ap-prev use-index codigo
             where b-tit-ap-prev.ep-codigo   = l-pre-ap.ep-codigo
             and   b-tit-ap-prev.cod-estabel = l-pre-ap.cod-est-pre
             and   b-tit-ap-prev.cod-esp     = l-pre-ap.cod-esp-pre
             and   b-tit-ap-prev.serie       = l-pre-ap.serie-pre
             and   b-tit-ap-prev.nr-docto    = l-pre-ap.nr-docto-pre
             and   b-tit-ap-prev.parcela     = l-pre-ap.parcela-pre
             and   b-tit-ap-prev.cod-fornec  = lin-i-ap.cod-fornec
             exclusive-lock no-error.

        /* Busca o Titulo implantado */
        find first b-tit-ap-impl where rowid(b-tit-ap-impl) = r-reg-tit no-error.
        find first b-mov-ap-impl of b-tit-ap-impl where
                   b-mov-ap-impl.transacao = 1 exclusive-lock no-error.

        if  avail b-tit-ap-prev and
            avail b-tit-ap-impl and
            avail b-mov-ap-impl then do:
           
            if  b-tit-ap-impl.tipo = 1 then do:
                {app/ap9100.i2}
                assign tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap-prev)
                       tt-integ-ap.tt-cb0110a     = yes   
                       tt-integ-ap.tt-cb1202a     = yes
                       tt-integ-ap.tt-op-cb0110a  = 6
                       tt-integ-ap.tt-op-cb1202a  = 6.

                raw-transfer tt-integ-ap to raw-integracao.
                run app/ap9100.p (Input raw-integracao, input-output table tt-erro).
                                                      
            end.                  
            
            /* Cria movimento AVA para Vincunlar Privisao-Titulo */
            if l-ava-prev then do:
               assign c-mov-relac = string(year(today))       + "/" +
                                    string(month(today),"99") + "/" +
                                    string(day(today),"99")   + "-" +
                                    string(time, "hh:mm:ss").
            
               {app/ap0502c.i "b-tit-ap-prev"
                              "b-tit-ap-impl"
                              "b-mov-ap-impl"
                              "b-tit-ap-impl.dt-emissao"
                              "l-pre-ap.vl-previsao"
                              "l-pre-ap.vl-previsao-me"}
            end.               
                    
            assign b-tit-ap-prev.valor-saldo = b-tit-ap-prev.valor-saldo 
                                             - l-pre-ap.vl-previsao
                   b-tit-ap-prev.vl-saldo-me = b-tit-ap-prev.vl-saldo-me 
                                             - l-pre-ap.vl-previsao-me.

            /*--- Zera Saldo Previs∆o ---*/
            if  l-pre-ap.log-1 = yes then do:
            
                /* Cria movimento AVA para Vincunlar Privisao-Titulo */
                if l-ava-prev then do:
                   {app/ap0502c.i "b-tit-ap-prev"
                                  "b-tit-ap-impl"
                                  "b-mov-ap-impl"
                                  "b-tit-ap-impl.dt-emissao"
                                  "b-tit-ap-prev.valor-saldo"
                                  "b-tit-ap-prev.vl-saldo-me"}
                end.               
                
                assign b-tit-ap-prev.valor-saldo = 0
                       b-tit-ap-prev.vl-saldo-me = 0.
            end.
                
            run app/ap6000a.p (rowid(b-tit-ap-prev)).
                
            if  b-tit-ap-impl.tipo = 1 then do:
                {app/ap9100.i2}
                assign tt-integ-ap.tt-row-tit-ap  = rowid(b-tit-ap-prev)
                       tt-integ-ap.tt-ge0102c     = yes   
                       tt-integ-ap.tt-cb0110a     = yes
                       tt-integ-ap.tt-cb1202a     = yes
                       tt-integ-ap.tt-op-ge0102c  = 16
                       tt-integ-ap.tt-op-cb0110a  = 16
                       tt-integ-ap.tt-op-cb1202a  = 16.

                raw-transfer tt-integ-ap to raw-integracao.
                run app/ap9100.p (Input raw-integracao, input-output table tt-erro).
            end.                  
        end.
            
        delete l-pre-ap.
            
    end.
end.    
    
/* Fim Include */
