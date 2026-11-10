/********************************************************************************
***
*** app/ap0518b.i - Procedures MultiPlanta.
***
********************************************************************************/
            
Procedure pi-cria-tt-dados-tit-ap:
                        
    def input parameter i-tipo-movto as integer. 
                        
    {cdp/cd0006c.i "AP"
                   "tit-ap.ep-codigo"
                   "tit-ap.cod-estabel" 
                   "return"}
    
    if  param-global.modulo-mp = yes and tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do: 
                            
        create tt-tit-ap-aux.
        buffer-copy tit-ap to tt-tit-ap-aux no-error.
                    
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

Procedure pi-cria-tt-dados-mov-ap:
    
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
               tt-dados-env.identif-msg    = string(mov-ap.ep-codigo)   + " , " +
                                             string(mov-ap.cod-fornec)  + " , " +
                                             string(mov-ap.cod-estabel) + " , " +
                                             string(mov-ap.cod-esp)     + " , " +
                                             string(mov-ap.serie)       + " , " +
                                             string(mov-ap.nr-docto)    + " , " +
                                             string(mov-ap.parcela)     + " , " +
                                             string(mov-ap.transacao)   + " , " +
                                             string(mov-ap.referencia).
        raw-transfer tt-mov-ap-aux to tt-dados-env.conteudo-msg.
        assign i-seq = i-seq + 1.
    end.
      
end procedure.

Procedure pi-cria-tt-dados-emite-ap:

    def input parameter i-tipo-movto as integer. 
  
    {cdp/cd0006c.i "AP"
                   "emite-ap.ep-codigo"
                   "emite-ap.cod-estabel" 
                   "return"}
    
    if  param-global.modulo-mp = yes and tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do: 
    
        create tt-emite-ap-aux.
        buffer-copy emite-ap to tt-emite-ap-aux no-error.
        
        create tt-dados-env.                  
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 168
               tt-dados-env.ind-tipo-movto = i-tipo-movto
               tt-dados-env.identif-msg    = string(emite-ap.ep-codigo)   + " , " +
                                             string(emite-ap.cod-fornec)  + " , " +
                                             string(emite-ap.cod-estabel) + " , " +
                                             string(emite-ap.cod-esp)     + " , " +
                                             string(emite-ap.serie)       + " , " +
                                             string(emite-ap.nr-docto)    + " , " +
                                             string(emite-ap.parcela).
        raw-transfer tt-emite-ap-aux to tt-dados-env.conteudo-msg.
        assign i-seq = i-seq + 1.
    end.
    
end procedure.    

Procedure pi-cria-tt-dados-che-emit:

    def input parameter i-tipo-movto as integer. 

    {cdp/cd0006c.i "AP"
                   "che-emit.ep-codigo"
                   "che-emit.cod-estabel" 
                   "return"}
    
    if  param-global.modulo-mp = yes and tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do: 
        
        create tt-che-emit-aux.
        buffer-copy che-emit to tt-che-emit-aux no-error.
            
        create tt-dados-env.                  
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 171
               tt-dados-env.ind-tipo-movto = i-tipo-movto
               tt-dados-env.identif-msg    = string(che-emit.ep-codigo)   + " , " +
                                             string(che-emit.cod-fornec)  + " , " +
                                             string(che-emit.cod-estabel) + " , " +
                                             string(che-emit.cod-esp)     + " , " +
                                             string(che-emit.serie)       + " , " +
                                             string(che-emit.nr-docto)    + " , " +
                                             string(che-emit.parcela)     + " , " +
                                             string(che-emit.nr-cheque)   + " , " +
                                             string(che-emit.portador).
        raw-transfer tt-che-emit-aux to tt-dados-env.conteudo-msg.
        assign i-seq = i-seq + 1.
    end.

end procedure.

Procedure pi-cria-tt-dados-his-d-ap:
                    
    def input parameter i-tipo-movto as integer. 
            
    {cdp/cd0006c.i "AP"
                   "his-d-ap.ep-codigo"
                   "his-d-ap.cod-estabel" 
                   "return"}
    
    if  param-global.modulo-mp = yes and tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do: 
            
        create tt-his-d-ap-aux.
        buffer-copy his-d-ap to tt-his-d-ap-aux no-error.
        
        create tt-dados-env.                  
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 177
               tt-dados-env.ind-tipo-movto = i-tipo-movto
               tt-dados-env.identif-msg    = string(his-d-ap.ep-codigo)   + " , " +
                                             string(his-d-ap.parcela)     + " , " +
                                             string(his-d-ap.cod-estabel) + " , " +
                                             string(his-d-ap.cod-esp)     + " , " +
                                             string(his-d-ap.serie)       + " , " +
                                             string(his-d-ap.nr-docto)    + " , " +
                                             string(his-d-ap.parcela).
        raw-transfer tt-his-d-ap-aux to tt-dados-env.conteudo-msg.
        assign i-seq = i-seq + 1.
    end.

end procedure.

/* Fim de Include */
