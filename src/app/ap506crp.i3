/********************************************************************************
***
*** app/ap506crp.i3 - Procedures MultiPlanta.
***
********************************************************************************/
                    
PROCEDURE pi-cria-tt-dados-tit-ap:
                
    def input parameter ind-tipo-movto as integer no-undo. 

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
               tt-dados-env.ind-tipo-movto = ind-tipo-movto
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
            
END PROCEDURE.

PROCEDURE pi-cria-tt-dados-b-mov-ap:

    def input parameter ind-tipo-movto as integer no-undo.

    {cdp/cd0006c.i "AP"
                   "b-mov-ap.ep-codigo"
                   "b-mov-ap.cod-estabel" 
                   "return"}
                    
    if  param-global.modulo-mp = yes and tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do:
                
        create tt-mov-ap-aux.
        buffer-copy b-mov-ap to tt-mov-ap-aux no-error.
                    
        create tt-dados-env.                  
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 59
               tt-dados-env.ind-tipo-movto = ind-tipo-movto
               tt-dados-env.identif-msg    = string(b-mov-ap.ep-codigo)   + " , " +
                                             string(b-mov-ap.cod-fornec)  + " , " +
                                             string(b-mov-ap.cod-estabel) + " , " +
                                             string(b-mov-ap.cod-esp)     + " , " +
                                             string(b-mov-ap.serie)       + " , " +
                                             string(b-mov-ap.nr-docto)    + " , " +
                                             string(b-mov-ap.referencia)  + " , " +
                                             string(b-mov-ap.parcela)     + " , " +
                                             string(b-mov-ap.dt-transacao).                                                                         
        raw-transfer tt-mov-ap-aux to tt-dados-env.conteudo-msg.                                    
        assign i-seq = i-seq + 1.                                    
    end.

END PROCEDURE.

PROCEDURE pi-cria-tt-dados-b-mov-ap-prev:

    def input parameter ind-tipo-movto as integer no-undo.

    {cdp/cd0006c.i "AP"
                   "b-mov-ap-prev.ep-codigo"
                   "b-mov-ap-prev.cod-estabel" 
                   "return"}
                    
    if  param-global.modulo-mp = yes and tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do:
                
        create tt-mov-ap-aux.
        buffer-copy b-mov-ap-prev to tt-mov-ap-aux no-error.
                    
        create tt-dados-env.                  
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 59
               tt-dados-env.ind-tipo-movto = ind-tipo-movto
               tt-dados-env.identif-msg    = string(b-mov-ap-prev.ep-codigo)   + " , " +
                                             string(b-mov-ap-prev.cod-fornec)  + " , " +
                                             string(b-mov-ap-prev.cod-estabel) + " , " +
                                             string(b-mov-ap-prev.cod-esp)     + " , " +
                                             string(b-mov-ap-prev.serie)       + " , " +
                                             string(b-mov-ap-prev.nr-docto)    + " , " +
                                             string(b-mov-ap-prev.referencia)  + " , " +
                                             string(b-mov-ap-prev.parcela)     + " , " +
                                             string(b-mov-ap-prev.dt-transacao).                                                                         
        raw-transfer tt-mov-ap-aux to tt-dados-env.conteudo-msg.                                    
        assign i-seq = i-seq + 1.                                    
    end.

END PROCEDURE.

PROCEDURE pi-cria-tt-dados-mov-ap:
            
    def input parameter ind-tipo-movto as integer no-undo. 
            
    {cdp/cd0006c.i "AP"
                   "mov-ap.ep-codigo"  
                   "mov-ap.cod-estabel" 
                   "return"}
    
    if  param-global.modulo-mp = yes and tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do:
            
        create tt-mov-ap-aux.
        buffer-copy mov-ap to tt-mov-ap-aux no-error.
            
        create tt-dados-env.                  
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 59
               tt-dados-env.ind-tipo-movto = ind-tipo-movto
               tt-dados-env.identif-msg    = string(mov-ap.ep-codigo)   + " , " +
                                             string(mov-ap.cod-fornec)  + " , " +
                                             string(mov-ap.cod-estabel) + " , " +
                                             string(mov-ap.cod-esp)     + " , " +
                                             string(mov-ap.serie)       + " , " +
                                             string(mov-ap.nr-docto)    + " , " +
                                             string(mov-ap.referencia)  + " , " +
                                             string(mov-ap.parcela)     + " , " +
                                             string(mov-ap.dt-emissao).    
        raw-transfer tt-mov-ap-aux to tt-dados-env.conteudo-msg.                                     
        assign i-seq = i-seq + 1.                         
    end.
END PROCEDURE.

PROCEDURE pi-cria-tt-dados-che-emit:
        
    def input parameter ind-tipo-movto as integer no-undo. 
            
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
               tt-dados-env.ind-tipo-movto = ind-tipo-movto
               tt-dados-env.identif-msg    = string(che-emit.ep-codigo)   + " , " +
                                             string(che-emit.portador)    + " , " +
                                             string(che-emit.nr-cheque)   + " , " +
                                             string(che-emit.cod-fornec)  + " , " +
                                             string(che-emit.cod-estabel) + " , " +
                                             string(che-emit.cod-esp)     + " , " +
                                             string(che-emit.serie)       + " , " +
                                             string(che-emit.nr-docto)    + " , " +
                                             string(che-emit.parcela).                                                                         
        raw-transfer tt-che-emit-aux to tt-dados-env.conteudo-msg.                                    
        assign i-seq = i-seq + 1.                                    
    end.
            
END PROCEDURE.
    
/* Fim de Include */
