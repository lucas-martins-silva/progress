for each operacao where
         operacao.cod-roteiro = v-cod-roteiro and 
         operacao.it-codigo   = v-it-codigo EXCLUSIVE-LOCK :
    if not can-find (first tt-operacao  
                     where tt-operacao.it-codigo   = operacao.it-codigo
                       and tt-operacao.cod-roteiro = operacao.cod-roteiro
                       and tt-operacao.op-codigo   = operacao.op-codigo) then do:
         for each rede-pert where
                  rede-pert.num-id-operacao-predec = operacao.num-id-operacao EXCLUSIVE-LOCK :
            delete rede-pert.
         end.         
         for each rede-pert where
                  rede-pert.num-id-operacao-sucess = operacao.num-id-operacao EXCLUSIVE-LOCK :
            delete rede-pert.
         end.         

         delete operacao.
    end.     
end.                    

find first tt-operacao
     where tt-operacao.it-codigo   = v-it-codigo
       and tt-operacao.cod-roteiro = v-cod-roteiro
       and tt-operacao.op-altern  <> 0 no-error.
if available tt-operacao then 
     assign v-log-alternativas = yes.
else assign v-log-alternativas = no.
       
for each tt-operacao
    where tt-operacao.it-codigo   = v-it-codigo
      and tt-operacao.cod-roteiro = v-cod-roteiro
      and tt-operacao.op-altern   = 0:
      
    find first operacao
         where operacao.it-codigo   = tt-operacao.it-codigo
           and operacao.cod-roteiro = tt-operacao.cod-roteiro
           and operacao.op-codigo   = tt-operacao.op-codigo exclusive-lock no-error.
    
    /*** Valida se existe grupo de m quina ***/
    if not can-find(first grup-maquina
                    where grup-maquina.gm-codigo = tt-operacao.gm-codigo) then do:
       run utp/ut-msgs.p (input 'msg',
                          input 19025,
                          input string(v-cod-roteiro + "/" + v-it-codigo) + "~~" +
                          string(tt-operacao.op-codigo) + "~~" + 
                          tt-operacao.gm-codigo).
       create tt-erro.
       assign tt-erro.cd-erro  = 19025
              tt-erro.mensagem = return-value.  
       next.              
    end.
                    
    if not available operacao then do:
       create operacao.
       buffer-copy tt-operacao except nr-unidades to operacao
       assign operacao.nr-unidades  = tt-operacao.nr-unidades.
    end.
    else do:
        assign operacao.gm-codigo         = tt-operacao.gm-codigo
               operacao.descricao         = tt-operacao.descricao
               operacao.qtd-pallet-produt = tt-operacao.qtd-pallet-produt.
               
        if  l-tempos = yes then
             assign operacao.tempo-prepar = tt-operacao.tempo-prepar
                    operacao.tempo-maquin = tt-operacao.tempo-maquin
                    operacao.tempo-homem  = tt-operacao.tempo-homem
                    operacao.nr-unidades  = tt-operacao.nr-unidades
                    operacao.un-med-tempo = tt-operacao.un-med-tempo.
    end.
    if  v-log-alternativas then do:

        for each op-altern where
                 op-altern.num-id-operacao = operacao.num-id-operacao EXCLUSIVE-LOCK :
            find first b-tt-operacao
                 where b-tt-operacao.it-codigo   = operacao.it-codigo
                   and b-tt-operacao.cod-roteiro = operacao.cod-roteiro
                   and b-tt-operacao.op-codigo   = operacao.op-codigo
                   and b-tt-operacao.op-altern   = op-altern.op-altern no-error.
            if not available b-tt-operacao then 
               delete op-altern.        
        end.         
        
        for each b-tt-operacao
            where b-tt-operacao.it-codigo   = operacao.it-codigo
              and b-tt-operacao.cod-roteiro = operacao.cod-roteiro
              and b-tt-operacao.op-codigo   = operacao.op-codigo
              and b-tt-operacao.op-altern  <> 0:
          
           /*** Valida grupo de m quina (next) ***/
           if not can-find(first grup-maquina
                           where grup-maquina.gm-codigo = b-tt-operacao.gm-codigo) then next.
           
           find first op-altern                  
                where op-altern.num-id-operacao = operacao.num-id-operacao and
                      op-altern.op-altern       = b-tt-operacao.op-altern exclusive-lock no-error.
           if not available op-altern then do:
              create op-altern.
              buffer-copy b-tt-operacao except nr-unidades to op-altern
              assign op-altern.op-altern       = b-tt-operacao.op-altern
                     op-altern.num-id-operacao = operacao.num-id-operacao
                     op-altern.nr-unidades     = b-tt-operacao.nr-unidades.
           end.       
           else do:    
               assign op-altern.gm-codigo         = b-tt-operacao.gm-codigo
                      op-altern.descricao         = b-tt-operacao.descricao
                      op-altern.qtd-pallet-produt = b-tt-operacao.qtd-pallet-produt.
               if  l-tempos = yes then
                   assign op-altern.tempo-prepar = b-tt-operacao.tempo-prepar
                          op-altern.tempo-maquin = b-tt-operacao.tempo-maquin
                          op-altern.tempo-homem  = b-tt-operacao.tempo-homem
                          op-altern.nr-unidades  = b-tt-operacao.nr-unidades
                          op-altern.un-med-tempo = b-tt-operacao.un-med-tempo.
           end.                
           delete b-tt-operacao.
        end.
    end.
    
    for each tt-rede-pert
        where tt-rede-pert.it-codigo   = tt-operacao.it-codigo
          and tt-rede-pert.cod-roteiro = tt-operacao.cod-roteiro
          and tt-rede-pert.op-codigo   = tt-operacao.op-codigo:
        
        find b-operacao where
             b-operacao.cod-roteiro = tt-rede-pert.cod-roteiro and
             b-operacao.it-codigo   = tt-rede-pert.it-codigo   and
             b-operacao.op-codigo   = tt-rede-pert.op-predeces no-lock no-error.
       
        if not available b-operacao then next.                 
        
        find first rede-pert
             where rede-pert.it-codigo   = tt-rede-pert.it-codigo
              and  rede-pert.cod-roteiro = tt-rede-pert.cod-roteiro
              and  rede-pert.op-codigo   = tt-rede-pert.op-codigo
              and  rede-pert.op-predeces = tt-rede-pert.op-predeces EXCLUSIVE-LOCK no-error.
        if not avail rede-pert then do:
            create rede-pert.
            assign rede-pert.it-codigo   = tt-rede-pert.it-codigo
                   rede-pert.cod-roteiro = tt-rede-pert.cod-roteiro
                   rede-pert.op-codigo   = tt-rede-pert.op-codigo
                   rede-pert.op-predeces = tt-rede-pert.op-predeces
                   rede-pert.num-id-operacao-predec = b-operacao.num-id-operacao
                   rede-pert.num-id-operacao-sucess = operacao.num-id-operacao.
        end.
        assign rede-pert.overlap     = tt-rede-pert.overlap
               rede-pert.transporte  = tt-rede-pert.transporte
               rede-pert.qtd-overlap = tt-rede-pert.qtde-overlap.
        
        delete tt-rede-pert.
    end.
    
    for each tt-rede-pert
        where tt-rede-pert.it-codigo   = tt-operacao.it-codigo
          and tt-rede-pert.cod-roteiro = tt-operacao.cod-roteiro
          and tt-rede-pert.op-predeces = tt-operacao.op-codigo:
        
        find b-operacao where
             b-operacao.cod-roteiro = tt-rede-pert.cod-roteiro and
             b-operacao.it-codigo   = tt-rede-pert.it-codigo   and
             b-operacao.op-codigo   = tt-rede-pert.op-codigo no-lock no-error.
       
        if not available b-operacao then next.                 
        
        find first rede-pert
             where rede-pert.it-codigo   = tt-rede-pert.it-codigo
              and  rede-pert.cod-roteiro = tt-rede-pert.cod-roteiro
              and  rede-pert.op-codigo   = tt-rede-pert.op-codigo
              and  rede-pert.op-predeces = tt-rede-pert.op-predeces EXCLUSIVE-LOCK no-error.
        if not avail rede-pert then do:
            create rede-pert.
            assign rede-pert.it-codigo   = tt-rede-pert.it-codigo
                   rede-pert.cod-roteiro = tt-rede-pert.cod-roteiro
                   rede-pert.op-codigo   = tt-rede-pert.op-codigo
                   rede-pert.op-predeces = tt-rede-pert.op-predeces
                   rede-pert.num-id-operacao-predec = operacao.num-id-operacao
                   rede-pert.num-id-operacao-sucess = b-operacao.num-id-operacao.
        end.
        assign rede-pert.overlap     = tt-rede-pert.overlap
               rede-pert.transporte  = tt-rede-pert.transporte
               rede-pert.qtd-overlap = tt-rede-pert.qtde-overlap.
        
        delete tt-rede-pert.
    end.      

    delete tt-operacao.
end.
