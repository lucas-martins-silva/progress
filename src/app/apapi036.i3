/********************************************************************************
***
*** app/apapi036.i3 - Verifica Cancelamentos de AVAs.
***
********************************************************************************/
            
if  i-seq-enc-contas > 0 then do:
    &if defined(BF_FIN_ENCCONTAS) &then
        for each mov-ap exclusive-lock
             where mov-ap.ep-codigo      = tt-movto-ap.ep-codigo
             and   mov-ap.cod-estabel    = tt-movto-ap.cod-estabel
             and   mov-ap.seq-enc-contas = tt-movto-ap.i-seq-enc-contas
             and   mov-ap.transacao      = 5:
             
            {app/ap6001.i3 mov-ap.ep-codigo
                           mov-ap.cod-estabel
                           mov-ap.cod-fornec
                           mov-ap.cod-esp
                           mov-ap.serie
                           mov-ap.nr-docto
                           mov-ap.parcela
                           mov-ap.referencia
                           mov-ap.dt-transacao}

             run pi-cancelamento-acerto-valor.
        end.
    &endif
end.
else do:
    if  tt-movto-ap.i-opcao = 1 then do:
        find first mov-ap exclusive-lock
             where mov-ap.ep-codigo      = tt-movto-ap.ep-codigo
             and   mov-ap.cod-estabel    = tt-movto-ap.cod-estabel
             and   mov-ap.cod-esp        = tt-movto-ap.cod-esp
             and   mov-ap.serie          = tt-movto-ap.serie
             and   mov-ap.nr-docto       = tt-movto-ap.nr-docto
             and   mov-ap.parcela        = tt-movto-ap.parcela
             and   mov-ap.cod-fornec     = tt-movto-ap.cod-fornec
             and   mov-ap.lancamento     = tt-movto-ap.lancamento
             and   mov-ap.valor-mov      = tt-movto-ap.valor-mov
             and   mov-ap.dt-transacao   = tt-movto-ap.dt-transacao
             and   mov-ap.conta-contabil = tt-movto-ap.conta-contabil
             and   mov-ap.referencia     = tt-movto-ap.referencia
             and   mov-ap.transacao      = 5 no-error.

        if  avail mov-ap then do:
            &if defined(BF_FIN_ENCCONTAS) &then
                if  mov-ap.seq-enc-contas > 0 then do:
                    assign i-sequencia = mov-ap.seq-enc-contas.

                    for each mov-ap exclusive-lock
                        where mov-ap.ep-codigo      = tt-movto-ap.ep-codigo
                        and   mov-ap.cod-estabel    = tt-movto-ap.cod-estabel
                        and   mov-ap.seq-enc-contas = i-sequencia
                        and   mov-ap.transacao      = 5:
                        run pi-cancelamento-acerto-valor.
                    end.
                end.
                else
                   run pi-cancelamento-acerto-valor.
            &else
                run pi-cancelamento-acerto-valor.
            &endif
        end.        
    end.
    else do:
            
        for each  mov-ap exclusive-lock
            where mov-ap.ep-codigo    = tt-movto-ap.ep-codigo
            and   mov-ap.referencia   = tt-movto-ap.referencia
            and   mov-ap.dt-transacao = tt-movto-ap.dt-transacao
            and   mov-ap.transacao    = 5:

            {app/ap6001.i3 mov-ap.ep-codigo
                           mov-ap.cod-estabel
                           mov-ap.cod-fornec
                           mov-ap.cod-esp
                           mov-ap.serie
                           mov-ap.nr-docto
                           mov-ap.parcela
                           mov-ap.referencia
                           mov-ap.dt-transacao}
                           
            if  mov-ap.dt-transacao < da-ini-validac or
                mov-ap.dt-transacao > da-fim-validac then
                next.
                
            /*--- Movimento j  contabilizado ---*/
            if  mov-ap.contabilizou = yes 
            and mov-ap.tipo        <> 4   
            and mov-ap.tipo        <> 5   then
                next.
                    
            /*--- NÆo pode Cancelar Movimentos ND/NC ---*/
            find espec-ap where espec-ap.cod-esp = mov-ap.cod-esp no-lock no-error.
            if (espec-ap.tipo = 4 or espec-ap.tipo = 5) then
                next.
                        
            /*--- NÆo pode cancelar Movtos originados por ND/NC ---*/
            find first tit-ap no-lock
                 where tit-ap.ep-codigo   = mov-ap.ep-codigo
                 and   tit-ap.cod-estabel = mov-ap.cod-estabel
                 and   tit-ap.cod-esp     = mov-ap.esp-ant
                 and   tit-ap.serie       = mov-ap.serie-ant
                 and   tit-ap.nr-docto    = mov-ap.docto-ant
                 and   tit-ap.parcela     = mov-ap.parc-ant
                 and   tit-ap.cod-fornec  = mov-ap.fornec-ant 
                 no-error.
                    
            if  avail tit-ap then do: 
                find espec-ap where espec-ap.cod-esp = tit-ap.cod-esp no-lock no-error.
                if (espec-ap.tipo = 4 or espec-ap.tipo = 5) then
                    next.
            end.
                    
            find first tit-ap
                 where tit-ap.ep-codigo    = mov-ap.ep-codigo
                 and   tit-ap.cod-estabel  = mov-ap.cod-estabel
                 and   tit-ap.cod-esp      = mov-ap.cod-esp
                 and   tit-ap.serie        = mov-ap.serie
                 and   tit-ap.nr-docto     = mov-ap.nr-docto
                 and   tit-ap.parcela      = mov-ap.parcela
                 and   tit-ap.cod-fornec   = mov-ap.cod-fornec
                 no-lock no-error.
                    
            if  not avail tit-ap then
                next.
                    
            /*--- Se existir AVA com data superior a data informada o cancelamento
                  nÆo ser  permitido, o cancelamento de AVA referente a varia‡Æo
                  deve ser do mais recente para o mais antigo. ---*/
                  
            if  mov-ap.log-1 = no then
                find first b-mov-ap no-lock
                     where b-mov-ap.ep-codigo     = mov-ap.ep-codigo
                     and   b-mov-ap.cod-estabel   = mov-ap.cod-estabel
                     and   b-mov-ap.cod-esp       = mov-ap.cod-esp
                     and   b-mov-ap.serie         = mov-ap.serie
                     and   b-mov-ap.nr-docto      = mov-ap.nr-docto
                     and   b-mov-ap.parcela       = mov-ap.parcela
                     and   b-mov-ap.cod-fornec    = mov-ap.cod-fornec
                     and   b-mov-ap.dt-transacao >= mov-ap.dt-transacao
                     and   b-mov-ap.log-1         = yes /* Identifica que ‚ de Varia‡Æo */
                     and   b-mov-ap.num-id-mov-ap > mov-ap.num-id-mov-ap 
                     and   b-mov-ap.transacao     = 5 
                     no-error.
            else
                find first b-mov-ap no-lock
                     where b-mov-ap.ep-codigo     = mov-ap.ep-codigo
                     and   b-mov-ap.cod-estabel   = mov-ap.cod-estabel
                     and   b-mov-ap.cod-esp       = mov-ap.cod-esp
                     and   b-mov-ap.serie         = mov-ap.serie
                     and   b-mov-ap.nr-docto      = mov-ap.nr-docto
                     and   b-mov-ap.parcela       = mov-ap.parcela
                     and   b-mov-ap.cod-fornec    = mov-ap.cod-fornec
                     and   b-mov-ap.dt-transacao >= mov-ap.dt-transacao
                     and   b-mov-ap.referencia   <> mov-ap.referencia
                     and   b-mov-ap.transacao    <> 1  /* IMD */
                     and   b-mov-ap.transacao    <> 13 /* DSV */
                     and   b-mov-ap.transacao    <> 14 /* DSD */
                     and   b-mov-ap.transacao    <> 15 /* ALT */
                     and   b-mov-ap.transacao    <> 11 /* SUS */
                     and   b-mov-ap.transacao    <> 10 /* CAN */
                     and   b-mov-ap.transacao    <> 12 /* CSP */
                     and   b-mov-ap.transacao    <> 8  /* GPF */
                     and   b-mov-ap.transacao    <> 9  /* CMCAC */
                     and not (b-mov-ap.transacao  = 6  /* SND */
                     and      b-mov-ap.lancamento = 2) /* C   */
                     and   rowid(b-mov-ap)       <> rowid(mov-ap)
                     no-error.
                                            
            if  avail b-mov-ap then
                next.
            
            /*--- NÆo pode ser cancelado o AVA referente a uma antecipa‡Æo
                  caso a mesma tenha sido usada contra um documento numa
                  data igual ou superior a data de transa‡Æo da AN ---*/

            if  espec-ap.tipo = 2 and tit-ap.moeda <> 0 then do:
                find first b-mov-ap no-lock
                     where b-mov-ap.ep-codigo    = mov-ap.ep-codigo
                     and   b-mov-ap.cod-estabel  = mov-ap.cod-estabel
                     and   b-mov-ap.esp-ant      = mov-ap.cod-esp
                     and   b-mov-ap.serie-ant    = mov-ap.serie
                     and   b-mov-ap.docto-ant    = mov-ap.nr-docto
                     and   b-mov-ap.parc-ant     = mov-ap.parcela
                     and   b-mov-ap.fornec-ant   = mov-ap.cod-fornec 
                     and   b-mov-ap.dt-transacao >= mov-ap.dt-transacao
                     no-error.
                
                if  avail b-mov-ap then 
                    next.
            end.

            find first b-mov-ap no-lock
                 where b-mov-ap.ep-codigo     = mov-ap.ep-codigo
                 and   b-mov-ap.cod-estabel   = mov-ap.cod-estabel
                 and   b-mov-ap.cod-esp       = mov-ap.cod-esp
                 and   b-mov-ap.serie         = mov-ap.serie
                 and   b-mov-ap.nr-docto      = mov-ap.nr-docto
                 and   b-mov-ap.parcela       = mov-ap.parcela
                 and   b-mov-ap.cod-fornec    = mov-ap.cod-fornec
                 and   b-mov-ap.dt-transacao >= mov-ap.dt-transacao
                 and   b-mov-ap.transacao    <> 5  /* AVA */
                 and   b-mov-ap.transacao    <> 1  /* IMD */
                 and   b-mov-ap.transacao    <> 13 /* DSV */
                 and   b-mov-ap.transacao    <> 14 /* DSD */
                 and   b-mov-ap.transacao    <> 15 /* ALT */
                 and   b-mov-ap.transacao    <> 11 /* SUS */
                 and   b-mov-ap.transacao    <> 10 /* CAN */
                 and   b-mov-ap.transacao    <> 12 /* CSP */
                 and   b-mov-ap.transacao    <> 8  /* GPF */
                 and   b-mov-ap.transacao    <> 9  /* CMCAC */
                 and not (b-mov-ap.transacao  = 6  /* SND */
                 and      b-mov-ap.lancamento = 2) /* C   */
                 no-error.
                
            if  avail b-mov-ap then
                next.
            
            run pi-cancelamento-acerto-valor.
        end.
    end.
end.

/* Fim apapi036.i3 */
