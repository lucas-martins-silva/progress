/********************************************************************************
***
*** app/ap0507bc.i - Procedures MultiPlanta.
***
*********************************************************************************/

PROCEDURE pi-cria-tt-dados-che-emit:
    
    def input parameter i-tipo-movto as integer no-undo.
        
    if  tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do: 
    
        create tt-che-emit-aux.
        buffer-copy che-emit to tt-che-emit-aux.
        
        create tt-dados-env.                  
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 171
               tt-dados-env.ind-tipo-movto = i-tipo-movto
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

PROCEDURE pi-cria-tt-dados-emite-ap:

    def input parameter i-tipo-movto as integer no-undo.
        
    if  tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do: 

        create tt-emite-ap-aux.
        buffer-copy emite-ap to tt-emite-ap-aux.
        
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
                                             string(emite-ap.parcela)     + " , " +
                                             string(emite-ap.transacao).
        raw-transfer tt-emite-ap-aux to tt-dados-env.conteudo-msg.                                    
        assign i-seq = i-seq + 1.                                     
    end.

END PROCEDURE.

PROCEDURE pi-cria-tt-dados-his-d-ap:

    def input parameter ind-tipo-movto as integer. 
  
    if  tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do: 

        create tt-his-d-ap-aux.
        buffer-copy his-d-ap to tt-his-d-ap-aux.
        
        create tt-dados-env.                  
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 177
               tt-dados-env.ind-tipo-movto = ind-tipo-movto
               tt-dados-env.identif-msg    = string(his-d-ap.ep-codigo)   + " , " +
                                             string(his-d-ap.cod-estabel) + " , " +
                                             string(his-d-ap.cod-esp)     + " , " +
                                             string(his-d-ap.serie)       + " , " +
                                             string(his-d-ap.nr-docto)    + " , " +
                                             string(his-d-ap.parcela)     + " , " +
                                             string(his-d-ap.cod-fornec)  + " , " +                                         
                                             string(his-d-ap.dt-his-doc)  + " , " +
                                             string(his-d-ap.sequencia).
        raw-transfer tt-his-d-ap-aux to tt-dados-env.conteudo-msg.                                     
        assign i-seq = i-seq + 1.                     
    end.

END PROCEDURE.

PROCEDURE pi-cria-tt-dados-mov-ap:

    def input parameter i-tipo-movto as integer no-undo.
        
    if  tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do: 
            
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
                                             string(mov-ap.dt-transacao).
        raw-transfer tt-mov-ap-aux to tt-dados-env.conteudo-msg.                                    
        assign i-seq = i-seq + 1.                                     
    end.

END PROCEDURE.

PROCEDURE pi-cria-tt-dados-tit-ap:

    def input parameter i-tipo-movto as integer no-undo.

    if  tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do: 
            
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

END PROCEDURE.

PROCEDURE pi-cria-tt-dados-usuar-autoriza-tit:

    def input parameter i-tipo-movto as integer no-undo.

    if  tt-replica-msg.log-replica-msg = yes and l-centraliz = no then do: 
            
        create tt-usuar-autoriza-tit-aux.
        buffer-copy usuar-autoriza-tit to tt-usuar-autoriza-tit-aux.
            
        create tt-dados-env.                  
        assign tt-dados-env.num-sequencia  = i-seq 
               tt-dados-env.cod-tipo-reg   = 213
               tt-dados-env.ind-tipo-movto = i-tipo-movto
               tt-dados-env.identif-msg    = string(usuar-autoriza-tit.ep-codigo)   + " , " +
                                             string(usuar-autoriza-tit.cod-fornec)  + " , " +
                                             string(usuar-autoriza-tit.cod-estabel) + " , " +
                                             string(usuar-autoriza-tit.cod-esp)     + " , " +
                                             string(usuar-autoriza-tit.serie)       + " , " +
                                             string(usuar-autoriza-tit.nr-docto)    + " , " +
                                             string(usuar-autoriza-tit.parcela).
        raw-transfer tt-usuar-autoriza-tit-aux to tt-dados-env.conteudo-msg.                                    
        assign i-seq = i-seq + 1.                                     
    end.

END PROCEDURE.

/* Fim de Include */
