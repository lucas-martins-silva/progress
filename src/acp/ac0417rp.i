/*******************************************************************************
** 
** AC0417RP..i : ImpressÆo do relat¢rio de Cotas por Produto
**
********************************************************************************/
    for each cotas NO-LOCK {1}
        where {2}
        and   cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
        and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim
        and   cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
        and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim
        and   cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
        and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim
        and   cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
        and   cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim
        break by cotas.cod-estabel
              by cotas.cd-produto:

        run pi-acompanhar in h-acomp (input cotas.cod-rep).

        IF FIRST-OF (cotas.cod-estabel) THEN do:
           find first par-cota 
                where par-cota.cod-estabel = cotas.cod-estabel no-lock no-error.
           if not avail par-cota then next. 
        end.   
        
        /****** Quebra por Cliente **********************************/ 
        
        if first-of(cotas.cod-estabel) then do:
           find estabelec where
                estabelec.cod-estabel = cotas.cod-estabel no-lock no-error.

           disp cotas.cod-estabel
                estabelec.nome
                with frame f-tit.
        end. /*if first-of*/     

        /************* Calculo Valores acumulando os itens produtos *******/ 
          
        if par-cota.tipo-controle = 2 then do: /*controle por valor*/
           assign de-original = de-original + if tt-param.l-utiliza-decimais then cotas.vl-original
                                                                           else trunc(cotas.vl-original, 0)
                  de-prevista = de-prevista + if tt-param.l-utiliza-decimais then cotas.vl-previsto
                                                                           else trunc(cotas.vl-previsto, 0)
                  de-realiz-pedida   = de-realiz-pedida   + if tt-param.l-utiliza-decimais then cotas.vl-pedido
                                                                                         else trunc(cotas.vl-pedido, 0)
                  de-cancel-ped = de-cancel-ped + if tt-param.l-utiliza-decimais then cotas.vl-ped-canc
                                                                               else trunc(cotas.vl-ped-canc, 0).
           if tt-param.l-cons-reprov then /*considera reprovados*/
              assign de-realiz-pedida   = de-realiz-pedida + if tt-param.l-utiliza-decimais then cotas.vl-ped-reprov
                                                                                            else trunc(cotas.vl-ped-reprov, 0).
           if tt-param.l-cons-susp then /*considera suspensos*/
              assign de-realiz-pedida   = de-realiz-pedida + if tt-param.l-utiliza-decimais then cotas.vl-ped-susp
                                                                                            else trunc(cotas.vl-ped-susp, 0).
           assign de-dif-prev-real   = de-prevista - de-realiz-pedida
                  de-perc-real = de-realiz-pedida * 100 / de-prevista.
        end.
        else do: /*controle por qtde ou pontos*/
           assign de-original = de-original + if tt-param.l-utiliza-decimais then cotas.qt-original
                                                                           else trunc(cotas.qt-original, 0)
                  de-prevista = de-prevista + if tt-param.l-utiliza-decimais then cotas.qt-prevista
                                                                           else trunc(cotas.qt-prevista, 0)
                  de-realiz-pedida   = de-realiz-pedida   + if tt-param.l-utiliza-decimais then cotas.qt-pedida
                                                                                         else trunc(cotas.qt-pedida, 0)
                  de-cancel-ped = de-cancel-ped + if tt-param.l-utiliza-decimais then cotas.qt-ped-canc
                                                                               else trunc(cotas.qt-ped-canc, 0).
           if tt-param.l-cons-reprov then /*considera reprovados*/
              assign de-realiz-pedida   = de-realiz-pedida + if tt-param.l-utiliza-decimais then cotas.qt-ped-reprov
                                                                                            else trunc(cotas.qt-ped-reprov, 0).
           if tt-param.l-cons-susp then /*considera suspensos*/
              assign de-realiz-pedida   = de-realiz-pedida + if tt-param.l-utiliza-decimais then cotas.qt-ped-susp
                                                                                            else trunc(cotas.qt-ped-susp, 0).
           assign de-dif-prev-real   = de-prevista - de-realiz-pedida
                  de-perc-real = de-realiz-pedida * 100 / de-prevista.
           if de-perc-real = ? then
              assign de-perc-real = 0.
                  
        end.

        /********** Quebra de item/produto *****************/ 

        /*

        */
        if last-of(cotas.cd-produto) then do:
   
           find first produto-coml no-lock where
                      produto-coml.cod-produto-coml = cotas.cd-produto no-error.
           if avail produto-coml then
              assign c-descricao = produto-coml.des-produto-coml.
           else 
           do:
             find first produto no-lock where
                         produto.cd-produto = cotas.cd-produto no-error.
             if avail produto then
                 assign c-descricao = produto.descricao.
             else 
             do:
                 find first item where 
                            item.it-codigo = cotas.cd-produto no-lock no-error.
                 if avail item then
                     assign c-descricao = item.descricao-1.
             end.
           end.
           if de-original        < 0 then de-original = 0.
           if de-prevista        < 0 then de-prevista = 0.
           if de-realiz-pedida   < 0 then de-realiz-pedida   = 0.
           if de-cancel-ped      < 0 then de-cancel-ped = 0.        
           assign de-tot-original = de-tot-original + de-original
                  de-tot-prevista = de-tot-prevista + de-prevista
                  de-tot-realiz-pedida = de-tot-realiz-pedida   + de-realiz-pedida
                  de-tot-dif-prev-real = de-tot-dif-prev-real + de-dif-prev-real
                  de-tot-cancel-ped    = de-tot-cancel-ped + de-cancel-ped
                  de-tot-perc-real     = de-tot-realiz-pedida * 100 / de-tot-prevista.
                  
           if tt-param.l-utiliza-decimais then do:
               disp cotas.cd-produto
                    c-descricao
                    cotas.dt-inicial
                    de-original 
                    de-prevista 
                    de-realiz-pedida   
                    de-dif-prev-real
                    de-cancel-ped
                    de-perc-real                 
                    with frame f-imp.
               down with frame f-imp.
           end.
           else do:
              disp cotas.cd-produto
                   c-descricao
                   cotas.dt-inicial
                   de-original 
                   de-prevista 
                   de-realiz-pedida   
                   de-dif-prev-real
                   de-cancel-ped
                   de-perc-real                 
                   with frame f-imp-int.
              down with frame f-imp-int.
           end.
           
           assign de-original = 0
                  de-prevista = 0
                  de-realiz-pedida   = 0
                  de-cancel-ped = 0.
        end. /*if last-of*/

        /************** ImpressÆo Valores Totais *************/ 
    
        if last-of(cotas.cod-estabel) then do:
           if tt-param.l-utiliza-decimais then do:
              disp de-tot-original 
                   de-tot-prevista 
                   de-tot-realiz-pedida   
                   de-tot-dif-prev-real
                   de-tot-cancel-ped
                   de-tot-perc-real
                   with frame f-total. 
           end.
           else do:
              disp de-tot-original 
                   de-tot-prevista 
                   de-tot-realiz-pedida   
                   de-tot-dif-prev-real
                   de-tot-cancel-ped
                   de-tot-perc-real
                   with frame f-total-int.
           end.
           
           assign de-tot-original      = 0
                  de-tot-prevista      = 0
                  de-tot-realiz-pedida = 0
                  de-tot-dif-prev-real = 0
                  de-tot-cancel-ped    = 0.
        end.    
    
    end. /* for each cotas*/      
