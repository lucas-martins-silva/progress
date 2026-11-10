/********************************************************************************
***
*** app/ap506erp.i3 - Procedures MultiPlanta.
***
********************************************************************************/
        
Procedure pi-cria-tt-dados-tit:
        
    def input parameter i-tipo-movto as integer. 
            
    {cdp/cd0006c.i "AP"
                   "tit-ap.ep-codigo"
                   "tit-ap.cod-estabel" 
                   "return"}
    
    if  param-global.modulo-mp = yes and tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do: 
                
        create tt-tit-ap-aux.
        buffer-copy tit-ap to tt-tit-ap-aux.
                    
        create tt-dados-env.                  
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 58
               tt-dados-env.ind-tipo-movto = i-tipo-movto
               tt-dados-env.identif-msg    = string(tit-ap.ep-codigo)   + " , " +
                                             string(tit-ap.cod-fornec)  + " , " +
                                             string(tit-ap.cod-estabel) + " , " +
                                             string(tit-ap.cod-esp)     + " , " +
                                             string(tit-ap.serie)       + " , " +
                                             string(tit-ap.nr-docto)    + " , " +
                                             string(tit-ap.parcela).
        raw-transfer tt-tit-ap-aux to tt-dados-env.conteudo-msg.                                     
        assign i-seq = i-seq + 1.                     
    end.
end procedure.

Procedure pi-cria-tt-dados-mov:
        
    def input parameter i-tipo-movto as integer. 
        
    {cdp/cd0006c.i "AP"
                   "mov-ap.ep-codigo" 
                   "mov-ap.cod-estabel" 
                   "return"}
    
    if  param-global.modulo-mp = yes and tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do: 
                                
        create tt-mov-ap-aux.
        buffer-copy mov-ap to tt-mov-ap-aux.
                
        create tt-dados-env.                  
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 59
               tt-dados-env.ind-tipo-movto = i-tipo-movto
               tt-dados-env.identif-msg    = string(mov-ap.ep-codigo)    + " , " +
                                             string(mov-ap.cod-fornec)   + " , " +
                                             string(mov-ap.cod-estabel)  + " , " +
                                             string(mov-ap.cod-esp)      + " , " +
                                             string(mov-ap.serie)        + " , " +
                                             string(mov-ap.nr-docto)     + " , " +
                                             string(mov-ap.parcela)      + " , " +
                                             string(mov-ap.dt-transacao) + " , " +
                                             string(mov-ap.transacao).
        raw-transfer tt-mov-ap-aux to tt-dados-env.conteudo-msg.                                     
        assign i-seq = i-seq + 1.                     
    end.
end procedure.

Procedure pi-cria-tt-dados-b-mov:
            
    def input parameter i-tipo-movto as integer. 
            
    {cdp/cd0006c.i "AP"
                   "b-mov-ap.ep-codigo"
                   "b-mov-ap.cod-estabel" 
                   "return"}
    
    if  param-global.modulo-mp = yes and tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do: 
                    
        create tt-mov-ap-aux.
        buffer-copy b-mov-ap to tt-mov-ap-aux.
                
        create tt-dados-env.                  
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 59
               tt-dados-env.ind-tipo-movto = i-tipo-movto
               tt-dados-env.identif-msg    = string(b-mov-ap.ep-codigo)    + " , " +
                                             string(b-mov-ap.cod-fornec)   + " , " +
                                             string(b-mov-ap.cod-estabel)  + " , " +
                                             string(b-mov-ap.cod-esp)      + " , " +
                                             string(b-mov-ap.serie)        + " , " +
                                             string(b-mov-ap.nr-docto)     + " , " +
                                             string(b-mov-ap.parcela)      + " , " +
                                             string(b-mov-ap.dt-transacao) + " , " +
                                             string(b-mov-ap.transacao).
        raw-transfer tt-mov-ap-aux to tt-dados-env.conteudo-msg.                                     
        assign i-seq = i-seq + 1.                     
    end.
end procedure.

Procedure pi-cria-tt-dados-bord:
            
    def input parameter i-tipo-movto as integer. 
            
    {cdp/cd0006c.i "AP"
                   "bord-tit.ep-codigo"
                   "bord-tit.cod-estabel" 
                   "return"}
    
    if  param-global.modulo-mp = yes and tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do: 
                    
        create tt-bord-tit-aux.
        buffer-copy bord-tit to tt-bord-tit-aux.
                
        create tt-dados-env.                  
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 179
               tt-dados-env.ind-tipo-movto = i-tipo-movto
               tt-dados-env.identif-msg    = string(bord-tit.ep-codigo)   + " , " +
                                             string(bord-tit.nr-bordero)  + " , " +
                                             string(bord-tit.portador)    + " , " +
                                             string(bord-tit.cod-fornec)  + " , " +
                                             string(bord-tit.cod-estabel) + " , " +
                                             string(bord-tit.cod-esp)     + " , " +
                                             string(bord-tit.serie)       + " , " +
                                             string(bord-tit.nr-docto)    + " , " +
                                             string(bord-tit.parcela).
        raw-transfer tt-bord-tit-aux to tt-dados-env.conteudo-msg.                                     
        assign i-seq = i-seq + 1.                     
    end.
end procedure.

/* Fim de Include */
