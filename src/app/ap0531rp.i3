/*****************************************************************
*** AP0531rp.i3 - Realiza a geraá∆o da DIRF para pessoa Fisica
***            quando a empresa n∆o utiliza a tabela progressiva   
******************************************************************/
for each  emitente
    where emitente.identific <> 1
    and   emitente.natureza   = 1 no-lock:

    assign l-primeiro = yes.

    for each  tit-ap
        where tit-ap.ep-codigo    = tt-param.ep-codigo
        and   tit-ap.cod-fornec   = emitente.cod-emit
        and ((tit-ap.dt-vencimen >= tt-param.da-ta-ini  and tit-ap.dt-vencimen <= tt-param.da-ta-fim)
        or 
        (tit-ap.dt-transacao >= tt-param.da-ta-ini  and tit-ap.dt-transacao <= tt-param.da-ta-fim))
        and   tit-ap.tipo         = 1
        and   tit-ap.transacao   <> 6 no-lock:

        /*--- Quando for INSS Ç desconsiderado o documento ---*/        
        find espec-ap where espec-ap.cod-esp = tit-ap.cod-esp no-lock no-error.
        if  avail espec-ap and espec-ap.log-1 = yes then
            next.

        run pi-acompanhar in h-acomp (input "Docto/P :" + tit-ap.nr-docto 
                                                        + "/" 
                                                        + tit-ap.parcela
                                                        + " - "
                                                        + tit-ap.nome-abrev).

        assign i-ano             = year(tit-ap.dt-vencimen)
               i-mes             = month(tit-ap.dt-vencimen)
               i-cod-ret         = tit-ap.cod-retencao
               de-sub-bruta      = 0
               de-valor-subtrair = 0
               de-valor-ava      = 0
               l-possui-ir       = no
               de-tit-deducoes   = 0.                                   

        if  tit-ap.cod-retencao = 0 then do:            

            find first mov-ap use-index ch-antecip
                where mov-ap.ep-codigo  = tit-ap.ep-codigo
                and   mov-ap.cod-est    = tit-ap.cod-est
                and   mov-ap.esp-ant    = tit-ap.cod-esp
                and   mov-ap.serie-ant  = tit-ap.serie
                and   mov-ap.docto-ant  = tit-ap.nr-docto
                and   mov-ap.parc-ant   = tit-ap.parcela
                and   mov-ap.fornec-ant = tit-ap.cod-fornec
                and   mov-ap.transacao  = 1 
                and   mov-ap.tipo       = 8 no-lock no-error.

            if  avail mov-ap then do:

                /*--- Documentos de IR da Duplicata ---*/                
                for each  mov-ap use-index ch-antecip
                    where mov-ap.ep-codigo  = tit-ap.ep-codigo
                    and   mov-ap.cod-est    = tit-ap.cod-est
                    and   mov-ap.esp-ant    = tit-ap.cod-esp
                    and   mov-ap.serie-ant  = tit-ap.serie
                    and   mov-ap.docto-ant  = tit-ap.nr-docto
                    and   mov-ap.parc-ant   = tit-ap.parcela
                    and   mov-ap.fornec-ant = tit-ap.cod-fornec
                    and   mov-ap.transacao  = 1 no-lock: 

                    find first b-tit-ap 
                         where b-tit-ap.ep-codigo  = mov-ap.ep-codigo
                         and   b-tit-ap.cod-est    = mov-ap.cod-est
                         and   b-tit-ap.cod-esp    = mov-ap.cod-esp
                         and   b-tit-ap.serie      = mov-ap.serie
                         and   b-tit-ap.nr-docto   = mov-ap.nr-docto
                         and   b-tit-ap.parcela    = mov-ap.parcela
                         and   b-tit-ap.cod-fornec = mov-ap.cod-fornec no-lock no-error.

                    if  not avail b-tit-ap then 
                        next.

                    if  b-tit-ap.tipo <> 8 then 
                        next.

                    if  b-tit-ap.tipo = 8 then
                        assign i-cod-ret = b-tit-ap.cod-retencao.

                    /* E necessario fazer este teste pois somente os codigos de retencao abaixo
                       devem ser selecionados pela data de transacao. E como no primeiro for each
                       nao temos o codigo de retencao somos obrigados a fazer o teste abaixo para nao
                       processar os registros com outros codigos de retencao */

                    if  (i-cod-ret <> 5706)
                    and (i-cod-ret <> 0916)
                    and (i-cod-ret <> 8045)
                    and ((tit-ap.dt-vencimen < tt-param.da-ta-ini)
                    or   (tit-ap.dt-vencimen > tt-param.da-ta-fim)) then
                        NEXT.

                    if  (i-cod-ret = 5706)
                    or  (i-cod-ret = 0916)
                    or  (i-cod-ret = 8045) then do:
                        if (tit-ap.dt-transacao < tt-param.da-ta-ini)
                        or (tit-ap.dt-transacao > tt-param.da-ta-fim) then
                        NEXT.
                    end.

                    if  l-gera-zero = no and i-cod-ret = 0 then
                        next.

                    if  tit-ap.vl-original >= tit-ap.valor-ir then
                        assign de-valor-ava = de-valor-ava + b-tit-ap.vl-original.

                    assign l-possui-ir = yes.

                    if i-cod-ret = 0916 
                    or i-cod-ret = 5706
                    or i-cod-ret = 8045 then
                        assign dt-ano-base = year(tit-ap.dt-transacao)
                               i-ano       = year(tit-ap.dt-transacao)
                               i-mes       = month(tit-ap.dt-transacao).
                    else
                        assign dt-ano-base = year(tit-ap.dt-vencimen).

                    find first dirf-apf
                         where dirf-apf.ep-codigo    = tit-ap.ep-codigo
                         and   dirf-apf.cod-est      = tit-ap.cod-est
                         and   dirf-apf.cod-emit     = tit-ap.cod-fornec
                         and   dirf-apf.ano-base     = dt-ano-base
                         and   dirf-apf.cod-retencao = i-cod-ret exclusive-lock no-error.

                    if   not avail dirf-apf then do: 
                         create dirf-apf.
                         assign dirf-apf.ep-codigo    = tit-ap.ep-codigo
                                dirf-apf.cod-est      = tit-ap.cod-est
                                dirf-apf.cod-emit     = tit-ap.cod-fornec
                                dirf-apf.ano-base     = dt-ano-base.
                                dirf-apf.cod-retencao = i-cod-ret.
                    end.

                    assign dirf-apf.base-bruta[i-mes] = dirf-apf.base-bruta[i-mes] 
                                                      + b-tit-ap.valor-ir.

                           dirf-apf.valor-irrf[i-mes] = dirf-apf.valor-irrf[i-mes] 
                                                      + if  b-tit-ap.tipo = 8 then 
                                                            b-tit-ap.vl-original
                                                        else 0.

                    for each tt-epc where tt-epc.cod-event = "ap0531rp" exclusive-lock:
                        delete tt-epc.
                    end.

                    create tt-epc.
                    assign tt-epc.cod-event     = "ap0531rp" 
                           tt-epc.cod-parameter = "tit-ap rowid - normal"
                           tt-epc.val-parameter = string(rowid(tit-ap)).

                    {include/i-epc201.i "ap0531rp"}   

                    find first tt-epc no-lock no-error.
                    if  avail tt-epc 
                    and tt-epc.val-parameter = "NOK" then
                        next.

                    if  l-primeiro = yes then do:
                        put skip(1).
                        disp emitente.cod-emit
                             emitente.nome-abrev
                             emitente.cgc
                             emitente.nome-emit
                             with frame f-cab-forn.
                        put skip(1).
                        assign l-primeiro = no.
                    end.

                    if  line-counter > 62 then do:
                        page.
                        put skip(1).
                        disp emitente.cod-emit
                             emitente.nome-abrev
                             emitente.cgc
                             emitente.nome-emit
                             with frame f-cab-forn.
                        put skip(1).
                    end.

                    if  b-tit-ap.tipo = 8 then do:

                        assign de-tit-deducoes   = 0
                               de-valor-subtrair = 0 
                               de-sub-bruta      = 0.
                               
                        /* Processa o INSS retido somente se foi parametrizado para tal */                    
                        if  tt-param.c-esp-inss <> "" then do:                                               
                            for each  b3-mov-ap use-index ch-antecip
                                where b3-mov-ap.ep-codigo  = tit-ap.ep-codigo
                                and   b3-mov-ap.cod-est    = tit-ap.cod-est
                                and   b3-mov-ap.esp-ant    = tit-ap.cod-esp
                                and   b3-mov-ap.serie-ant  = tit-ap.serie
                                and   b3-mov-ap.docto-ant  = tit-ap.nr-docto
                                and   b3-mov-ap.parc-ant   = tit-ap.parcela
                                and   b3-mov-ap.fornec-ant = tit-ap.cod-fornec
                                and   b3-mov-ap.cod-esp    = tt-param.c-esp-inss                                                  
                                and   b3-mov-ap.transacao  = 1 no-lock:                                              
                
                                find first b2-tit-ap 
                                     where b2-tit-ap.ep-codigo  = b3-mov-ap.ep-codigo
                                     and   b2-tit-ap.cod-est    = b3-mov-ap.cod-est
                                     and   b2-tit-ap.cod-esp    = b3-mov-ap.cod-esp
                                     and   b2-tit-ap.serie      = b3-mov-ap.serie
                                     and   b2-tit-ap.nr-docto   = b3-mov-ap.nr-docto
                                     and   b2-tit-ap.parcela    = b3-mov-ap.parcela
                                     and   b2-tit-ap.cod-fornec = b3-mov-ap.cod-fornec 
                                     no-lock no-error.

                                if  avail b2-tit-ap then
                                    assign de-tit-deducoes  = de-tit-deducoes  + b2-tit-ap.vl-original
                                           de-forn-deducoes = de-forn-deducoes + b2-tit-ap.vl-original.
                
                            end.                                                
                                
                            assign dirf-apf.ded-inss[i-mes] = dirf-apf.ded-inss[i-mes] + de-tit-deducoes.

                        end.                                                                                      

                        assign dirf-apf.base-liquida[i-mes] = dirf-apf.base-bruta[i-mes] 
                                                            - dirf-apf.ded-depend[i-mes] 
                                                            - dirf-apf.ded-pensao[i-mes]
                                                            - dirf-apf.ded-inss[i-mes].

                        {app/ap0531rp.i1}

                        disp b-tit-ap.cod-estab    @ tit-ap.cod-estab
                             b-tit-ap.cod-esp      @ tit-ap.cod-esp
                             b-tit-ap.serie        @ tit-ap.serie
                             b-tit-ap.nr-docto     @ tit-ap.nr-docto
                             b-tit-ap.parcela      @ tit-ap.parcela
                             b-tit-ap.dt-emiss     @ tit-ap.dt-emiss
                             b-tit-ap.dt-trans     @ tit-ap.dt-trans
                             b-tit-ap.dt-vencto    @ tit-ap.dt-vencto
                             b-tit-ap.referencia   @ tit-ap.referencia
                             i-cod-ret
                             b-tit-ap.valor-ir     @ tit-ap.valor-ir
                             de-tit-deducoes
                             with frame f-lin-tit.

                        disp (b-tit-ap.vl-original - de-valor-subtrair) @ tit-ap.vl-original
                             with frame f-lin-tit.

                        down with frame f-lin-tit.

                        assign de-forn-ir = de-forn-ir 
                                          + if  b-tit-ap.tipo = 8 then
                                                b-tit-ap.vl-original
                                            else 
                                                0.
                    end.      

                    assign de-forn-no = de-forn-no 
                                      + b-tit-ap.valor-ir
                                      - de-valor-subtrair.
                end.
            end.
        end.
                     
        if  (l-possui-ir = no and tit-ap.cod-retencao <> 0) or
            (l-possui-ir = no and tit-ap.cod-retencao  = 0 and l-gera-zero = yes) then do:
                 
            /* E necessario fazer este teste pois somente os codigos de retencao abaixo
               devem ser selecionados pela data de transacao. E como no primeiro for each
               nao temos o codigo de retencao somos obrigados a fazer o teste abaixo para nao
               processar os registros com outros codigos de retencao */
        
            if  (i-cod-ret <> 5706)
            and (i-cod-ret <> 0916)
            and (i-cod-ret <> 8045)
            and ((tit-ap.dt-vencimen < tt-param.da-ta-ini)
            or (tit-ap.dt-vencimen > tt-param.da-ta-fim)) then
                NEXT.
        
            if  (i-cod-ret = 5706)
            or  (i-cod-ret = 0916)
            or  (i-cod-ret = 8045) then do:
                if (tit-ap.dt-transacao < tt-param.da-ta-ini)
                or (tit-ap.dt-transacao > tt-param.da-ta-fim) then
                    NEXT.
            end.
                        
            if  l-primeiro = yes then do:
                put skip(1).
                disp emitente.cod-emit
                     emitente.nome-abrev
                     emitente.cgc
                     emitente.nome-emit
                     with frame f-cab-forn.
                put skip(1).
                assign l-primeiro = no.
            end.
        
            if i-cod-ret = 0916 
            or i-cod-ret = 5706
            or i-cod-ret = 8045 then
                assign dt-ano-base = year(tit-ap.dt-transacao)
                       i-ano       = year(tit-ap.dt-transacao)
                       i-mes       = month(tit-ap.dt-transacao).
            else
                assign dt-ano-base = year(tit-ap.dt-vencimen).
                        
            find dirf-apf
                 where dirf-apf.ep-codigo    = tit-ap.ep-codigo
                 and   dirf-apf.cod-est      = tit-ap.cod-est
                 and   dirf-apf.cod-emit     = tit-ap.cod-fornec
                 and   dirf-apf.ano-base     = dt-ano-base
                 and   dirf-apf.cod-retencao = i-cod-ret
                 exclusive-lock no-error.
                
            if   not avail dirf-apf then do: 
                 create dirf-apf.
                 assign dirf-apf.ep-codigo    = tit-ap.ep-codigo
                        dirf-apf.cod-est      = tit-ap.cod-est
                        dirf-apf.cod-emit     = tit-ap.cod-fornec
                        dirf-apf.ano-base     = dt-ano-base.
                        dirf-apf.cod-retencao = i-cod-ret.
            end.
                
            assign de-tit-deducoes = 0.
                
            /* Processa o INSS retido somente se foi parametrizado para tal */                    
            if  tt-param.c-esp-inss <> "" then do:                                               
                for each  b3-mov-ap use-index ch-antecip
                    where b3-mov-ap.ep-codigo  = tit-ap.ep-codigo
                    and   b3-mov-ap.cod-est    = tit-ap.cod-est
                    and   b3-mov-ap.esp-ant    = tit-ap.cod-esp
                    and   b3-mov-ap.serie-ant  = tit-ap.serie
                    and   b3-mov-ap.docto-ant  = tit-ap.nr-docto
                    and   b3-mov-ap.parc-ant   = tit-ap.parcela
                    and   b3-mov-ap.fornec-ant = tit-ap.cod-fornec
                    and   b3-mov-ap.cod-esp    = tt-param.c-esp-inss                                                  
                    and   b3-mov-ap.transacao  = 1 no-lock:                                              

                    find first b2-tit-ap 
                         where b2-tit-ap.ep-codigo  = b3-mov-ap.ep-codigo
                         and   b2-tit-ap.cod-est    = b3-mov-ap.cod-est
                         and   b2-tit-ap.cod-esp    = b3-mov-ap.cod-esp
                         and   b2-tit-ap.serie      = b3-mov-ap.serie
                         and   b2-tit-ap.nr-docto   = b3-mov-ap.nr-docto
                         and   b2-tit-ap.parcela    = b3-mov-ap.parcela
                         and   b2-tit-ap.cod-fornec = b3-mov-ap.cod-fornec 
                         no-lock no-error.

                    if  avail b2-tit-ap then
                        assign de-tit-deducoes  = de-tit-deducoes  + b2-tit-ap.vl-original
                               de-forn-deducoes = de-forn-deducoes + b2-tit-ap.vl-original.

                end.                                                
                
                assign dirf-apf.ded-inss[i-mes] = dirf-apf.ded-inss[i-mes] + de-tit-deducoes.

            end.   

            assign dirf-apf.base-bruta[i-mes]   = dirf-apf.base-bruta[i-mes] + tit-ap.vl-original
                   dirf-apf.base-liquida[i-mes] = dirf-apf.base-bruta[i-mes] 
                                                - dirf-apf.ded-depend[i-mes] 
                                                - dirf-apf.ded-pensao[i-mes]
                                                - dirf-apf.ded-inss[i-mes].
        
            for each tt-epc where tt-epc.cod-event = "ap0531rp" exclusive-lock:
                delete tt-epc.
            end.
        
            create tt-epc.
            assign tt-epc.cod-event     = "ap0531rp" 
                   tt-epc.cod-parameter = "tit-ap rowid NO - Final"
                   tt-epc.val-parameter = string(rowid(tit-ap)).
        
            create tt-epc.
            assign tt-epc.cod-event     = "ap0531rp" 
                   tt-epc.cod-parameter = "dirf-apf rowid NO - Final"
                   tt-epc.val-parameter = string(rowid(dirf-apf)).
        
            {include/i-epc201.i "ap0531rp"}   
                       
            if  line-counter > 62 then do:
                page.
                put skip(1).
                disp emitente.cod-emit
                     emitente.nome-abrev
                     emitente.cgc
                     emitente.nome-emit
                     with frame f-cab-forn.
                 put skip(1).
             end.
                
             disp tit-ap.cod-estab
                  tit-ap.cod-esp
                  tit-ap.serie
                  tit-ap.nr-docto
                  tit-ap.parcela
                  tit-ap.dt-emiss
                  tit-ap.dt-trans
                  tit-ap.dt-vencto
                  tit-ap.referencia
                  de-tit-deducoes
                  i-cod-ret
                  0                  @ tit-ap.vl-original
                  tit-ap.vl-original @ tit-ap.valor-ir
                  with frame f-lin-tit.
        
                down with frame f-lin-tit.
                
            assign de-forn-no = de-forn-no + tit-ap.vl-original.
        end.
        
    end.

    for each tit-ap 
        where tit-ap.ep-codigo     = tt-param.ep-codigo
        and   tit-ap.cod-fornec    = emitente.cod-emit
        and   tit-ap.dt-trans     >= da-ta-ini
        and   tit-ap.dt-trans     <= da-ta-fim
        and   tit-ap.tipo          = 2
        no-lock:

        if  tit-ap.esp-ant =  " " then
            next.

        find first espec-ap
             where espec-ap.cod-esp = tit-ap.esp-ant no-lock no-error.

        if  not avail espec-ap then 
            next.

        if  espec-ap.tipo <> 8 then 
            next.

        find b-tit-ap 
            where b-tit-ap.ep-codigo   = tit-ap.ep-codigo
            and   b-tit-ap.cod-estabel = tit-ap.cod-estabel
            and   b-tit-ap.cod-esp     = tit-ap.esp-ant
            and   b-tit-ap.serie       = tit-ap.serie-ant
            and   b-tit-ap.nr-docto    = tit-ap.docto-ant
            and   b-tit-ap.parcela     = tit-ap.parc-ant
            and   b-tit-ap.cod-fornec  = tit-ap.cod-fornec
            no-lock no-error.

        if  not avail b-tit-ap then
            next.

        if  b-tit-ap.cod-ret = 0           
        and l-gera-zero = no then
            next.

        assign i-ano = year(b-tit-ap.dt-trans)
               i-mes = month(b-tit-ap.dt-trans).

        find dirf-apf
             where dirf-apf.ep-codigo    = b-tit-ap.ep-codigo
             and   dirf-apf.cod-est      = b-tit-ap.cod-est
             and   dirf-apf.cod-emit     = b-tit-ap.cod-fornec
             and   dirf-apf.ano-base     = year(b-tit-ap.dt-trans)
             and   dirf-apf.cod-retencao = b-tit-ap.cod-ret
             exclusive-lock no-error.

        if   not avail dirf-apf then do: 
             create dirf-apf.
             assign dirf-apf.ep-codigo    = b-tit-ap.ep-codigo
                    dirf-apf.cod-est      = b-tit-ap.cod-est
                    dirf-apf.cod-emit     = b-tit-ap.cod-fornec
                    dirf-apf.ano-base     = year(b-tit-ap.dt-trans)
                    dirf-apf.cod-retencao = b-tit-ap.cod-ret.
        end.

        find first mov-ap of tit-ap
            where mov-ap.transacao = 1 no-lock no-error.

        assign dirf-apf.base-bruta[i-mes] = dirf-apf.base-bruta[i-mes] + b-tit-ap.valor-ir
               dirf-apf.valor-irrf[i-mes] = dirf-apf.valor-irrf[i-mes] + b-tit-ap.vl-original
               de-forn-no                 = de-forn-no + b-tit-ap.valor-ir
               de-forn-ir                 = de-forn-ir + b-tit-ap.vl-original. 


        assign dirf-apf.base-liquida[i-mes] = dirf-apf.base-bruta[i-mes]    
                                            - dirf-apf.ded-depend[i-mes]    
                                            - dirf-apf.ded-pensao[i-mes]    
                                            - dirf-apf.ded-inss[i-mes].     

        for each tt-epc where tt-epc.cod-event = "ap0531rp" exclusive-lock:
            delete tt-epc.
        end.

        create tt-epc.
        assign tt-epc.cod-event     = "ap0531rp" 
               tt-epc.cod-parameter = "tit-ap rowid - antecipa"
               tt-epc.val-parameter = string(rowid(tit-ap)).

        {include/i-epc201.i "ap0531rp"}   

        find first tt-epc no-lock no-error.
        if  avail tt-epc 
        and tt-epc.val-parameter = "NOK" then
            next.

        disp tit-ap.cod-estab    
             tit-ap.cod-esp
             tit-ap.serie        
             tit-ap.nr-docto     
             tit-ap.parcela      
             tit-ap.dt-emiss     
             tit-ap.dt-trans     
             tit-ap.dt-vencimen   @ tit-ap.dt-vencto
             tit-ap.referencia                        
             b-tit-ap.cod-ret     @ i-cod-ret
             b-tit-ap.vl-original @ tit-ap.vl-original  
             b-tit-ap.valor-ir    @ tit-ap.valor-ir
             0                    @ de-tit-deducoes
             with frame f-lin-tit.                                                 
             down with frame f-lin-tit.

        for each tt-epc where tt-epc.cod-event = "ap0531rp" exclusive-lock:
            delete tt-epc.
        end.

        create tt-epc.
        assign tt-epc.cod-event     = "ap0531rp" 
               tt-epc.cod-parameter = "tit-ap rowid AN - Final"
               tt-epc.val-parameter = string(rowid(tit-ap)).

        create tt-epc.
        assign tt-epc.cod-event     = "ap0531rp" 
               tt-epc.cod-parameter = "dirf-apf rowid AN - Final"
               tt-epc.val-parameter = string(rowid(dirf-apf)).

        {include/i-epc201.i "ap0531rp"}   

    end.

    if  l-primeiro = no then do:
        put skip(1)
            "Total Base Bruta:" at 50
            de-forn-no format "->>>,>>>,>>>,>>9.99"         
            "Total IR:"         at 58
            de-forn-ir format "->>>,>>>,>>>,>>9.99"         
            "Total Outras Deducoes:" at 45
            de-forn-deducoes format "->>>,>>>,>>>,>>9.99"
            "Total Liquido:"    at 53
            (de-forn-no - de-forn-ir - de-forn-deducoes) format "->>>,>>>,>>>,>>9.99".
    end.

    assign de-tot-no        = de-tot-no + de-forn-no
           de-tot-ir        = de-tot-ir + de-forn-ir
           de-tot-deducoes  = de-tot-deducoes + de-forn-deducoes
           de-forn-no       = 0
           de-forn-ir       = 0
           de-forn-deducoes = 0.
end.

/*--- Fim include ap0531rp.i3 ---*/
