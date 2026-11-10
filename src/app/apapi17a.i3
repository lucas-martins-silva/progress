/*******************************************************************************
***
*** app/apapi17a.i3 - Valida‡äes tt-documento-original.
***
*******************************************************************************/

{utp/ut-liter.i Documento_Original}
assign c-identificacao = trim(return-value).

/*--- Valida‡Æo Documento Original ---*/
for each  tt-documento-original
    where tt-documento-original.ep-codigo   = tt-nota-debito-credito.ep-codigo
    and   tt-documento-original.cod-estabel = tt-nota-debito-credito.cod-estabel
    and   tt-documento-original.cod-fornec  = tt-nota-debito-credito.cod-fornec
    and   tt-documento-original.cod-esp     = tt-nota-debito-credito.cod-esp
    and   tt-documento-original.serie       = tt-nota-debito-credito.serie
    and   tt-documento-original.nr-docto    = tt-nota-debito-credito.nr-docto
    and   tt-documento-original.parcela     = tt-nota-debito-credito.parcela:

    /*--- Verifica se o documento original existe ---*/                
    find first tit-ap exclusive-lock
         where tit-ap.ep-codigo   = tt-documento-original.ep-codigo-orig
         and   tit-ap.cod-estabel = tt-documento-original.cod-estabel-orig
         and   tit-ap.cod-esp     = tt-documento-original.cod-esp-orig
         and   tit-ap.cod-fornec  = tt-documento-original.cod-fornec-orig
         and   tit-ap.serie       = tt-documento-original.serie-orig
         and   tit-ap.nr-docto    = tt-documento-original.nr-docto-orig
         and   tit-ap.parcela     = tt-documento-original.parcela-orig no-error.

    if  not avail tit-ap then do: 

        /*--- Se o documento Original foi informado o mesmo deve existir ---*/
        if  tt-documento-original.ep-codigo-orig   <> 0  or
            tt-documento-original.cod-estabel-orig <> "" or
            tt-documento-original.cod-esp-orig     <> "" or
            tt-documento-original.cod-fornec-orig  <> 0  or
            tt-documento-original.serie-orig       <> "" or
            tt-documento-original.nr-docto-orig    <> "" or
            tt-documento-original.parcela-orig     <> "" then do:
            run utp/ut-msgs.p (input "help",
                               input 15996,
                               input string(tt-documento-original.cod-estabel-orig) + "~~" +
                                     string(tt-documento-original.cod-esp-orig) + "~~" +
                                     string(tt-documento-original.serie-orig) + "~~" +
                                     string(tt-documento-original.nr-docto-orig) + "~~" +
                                     string(tt-documento-original.parcela-orig) + "~~" +
                                     string(tt-documento-original.cod-fornec-orig)).
            run pi-gerar-erro-retorno (input 15996, input return-value).
         end.

        /*--- Quando ‚ gerado AN nÆo pode haver rateio ---*/
        if  avail espec-ap and espec-ap.tipo = 5 then do:
            if  i-contador > 1 then do:
                run utp/ut-msgs.p (input "help", 
                                   input 15711, 
                                   input "").
                run pi-gerar-erro-retorno (input 15711, input return-value).
            end.
        end.

    end.
    else do:
        /*--- Estabel Orig deve ser igual ao Estabel da NC/ND ---*/
        if  tt-nota-debito-credito.cod-estabel <> tit-ap.cod-estabel then do:
            run utp/ut-msgs.p (input "help", 
                               input 15941, 
                               input "").
            run pi-gerar-erro-retorno (input 15941, input return-value).
        end.                         

        /*--- Moeda Original deve ser igual a Moeda da NC/ND ---*/
        if  tt-nota-debito-credito.moeda <> tit-ap.moeda then do:
            run utp/ut-msgs.p (input "help", 
                               input 15695, 
                               input "").
            run pi-gerar-erro-retorno (input 15695, input return-value).
        end.                         

        if  avail espec-ap and espec-ap.tipo = 5 then do:

            /*--- Quando ‚ gerado AN nÆo pode haver rateio ---*/
            if  i-contador > 1 then do:
                if  tit-ap.valor-saldo = 0 then do:
                    run utp/ut-msgs.p (input "help", 
                                       input 15698, 
                                       input "").
                    run pi-gerar-erro-retorno (input 15698, input return-value).
                end.
            end.
        end.
        find first bord-tit use-index codigo
                where  bord-tit.ep-codigo   = tt-documento-original.ep-codigo-orig
                and    bord-tit.cod-estabel = tt-documento-original.cod-estabel-orig
                and    bord-tit.cod-esp     = tt-documento-original.cod-esp-orig
                and    bord-tit.serie       = tt-documento-original.serie-orig
                and    bord-tit.nr-docto    = tt-documento-original.nr-docto-orig
                and    bord-tit.parcela     = tt-documento-original.parcela-orig
                and    bord-tit.cod-fornec  = tt-documento-original.cod-fornec
                no-lock no-error.
        if  avail bord-tit then do:
            run utp/ut-msgs.p (input "help", 
                               input 1712, 
                               input bord-tit.nr-bordero).
            run pi-gerar-erro-retorno (input 1712, input return-value).
        end.    
    end.        
end.

/* Fim de Include */

