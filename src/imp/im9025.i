/*****************************************************************************
**
** IM9025.i - Despesas do Embarque
**
** Objetivo: Gera‡Æo da tabela desp-embarque. 
**
******************************************************************************/

find ordem-compra 
    where ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock no-error.
    
if  avail ordem-compra then do:    

    find cotacao-item   
        where cotacao-item.numero-ordem = ordem-compra.numero-ordem
          and cotacao-item.cod-emitente = processo-imp.cod-exportador
          and cotacao-item.it-codigo    = ordem-compra.it-codigo
          and cotacao-item.cot-aprovada = yes no-lock no-error.                   
    
    &if defined(bf-mat-comex) &then
        assign i-mapa-cotacao-i50  = int(substring(cotacao-item.char-1,6,2))
               c-cod-incoterm-i50  = substring(cotacao-item.char-1,8,3)
               i-cod-pto-contr-i50 = int(substring(cotacao-item.char-1,11,5)).
    &else
        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
        {ccp/cc9019.i51 "yes"}
    &endif          
          
    for each cotacao-item-cex 
        where cotacao-item-cex.numero-ordem       = cotacao-item.numero-ordem 
          and cotacao-item-cex.cod-emitente       = cotacao-item.cod-emitente 
          and cotacao-item-cex.it-codigo          = cotacao-item.it-codigo 
          &if defined(bf-mat-comex) &then          
                and cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao
          &else
                and cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac           
          &endif
          and cotacao-item-cex.mapa-cotacao   = i-mapa-cotacao-i50 
          and cotacao-item-cex.cod-incoterm   = c-cod-incoterm-i50 
          and cotacao-item-cex.cod-pto-contr  = historico-embarque.cod-pto-contr no-lock:      
          
          
        find desp-embarque 
            where desp-embarque.cod-estabel       = historico-embarque.cod-estabel
              and desp-embarque.embarque          = historico-embarque.embarque
              and desp-embarque.cod-itiner        = historico-embarque.cod-itiner
              and desp-embarque.cod-pto-contr     = historico-embarque.cod-pto-contr
              and desp-embarque.cod-desp          = cotacao-item-cex.cod-desp
              and desp-embarque.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp EXCLUSIVE-LOCK NO-ERROR.              
                   
        if  not avail desp-embarque then do:  
            create desp-embarque.
            assign desp-embarque.cod-estabel       = historico-embarque.cod-estabel
                   desp-embarque.embarque          = historico-embarque.embarque
                   desp-embarque.cod-itiner        = historico-embarque.cod-itiner
                   desp-embarque.cod-pto-contr     = historico-embarque.cod-pto-contr
                   desp-embarque.cod-desp          = cotacao-item-cex.cod-desp
                   desp-embarque.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp.
        end.
       
        assign desp-embarque.cod-cond-pag = cotacao-item-cex.cod-cond-pag                                    
               desp-embarque.mo-codigo    = cotacao-item-cex.mo-codigo
               desp-embarque.val-desp     = cotacao-item-cex.val-desp 
                                          * ordens-embarque.quantidade.                        
    end.
end.          

/* im9025.i */
