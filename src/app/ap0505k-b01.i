/******************************************************************************
**
** AP05505k-b01.i - Sele‡Æo dos T¡tulos.
** Cria‡Æo - ATO
** 
******************************************************************************/
    IF SESSION:SET-WAIT-STATE('general') THEN.

    if not avail doc-b-ap then
        find first doc-b-ap 
             where rowid(doc-b-ap) = v-row-parent no-lock no-error.
       
    for each   tit-ap {1}
        where tit-ap.ep-codigo     = i-ep-codigo-usuario    
        {2}
        and   tit-ap.portador     >= tt-param.port-ini
        and   tit-ap.portador     <= tt-param.port-fim
        and   tit-ap.cod-esp      >= tt-param.esp-ini
        and   tit-ap.cod-esp      <= tt-param.esp-fim
        and   tit-ap.nr-docto     >= tt-param.nr-docto-ini
        and   tit-ap.nr-docto     <= tt-param.nr-docto-fim
        and   tit-ap.parcela      >= tt-param.parcela-ini
        and   tit-ap.parcela      <= tt-param.parcela-fim
        and   tit-ap.serie        >= tt-param.serie-ini
        and   tit-ap.serie        <= tt-param.serie-fim
        and   tit-ap.dt-emissao   >= tt-param.emissao-ini
        and   tit-ap.dt-emissao   <= tt-param.emissao-fim
        and   tit-ap.moeda        >= tt-param.moeda-ini
        and   tit-ap.moeda        <= tt-param.moeda-fim
        and   tit-ap.vl-saldo-me   > 0          
        and  (tit-ap.tipo          = 1
        or    tit-ap.tipo          = 8)
        and  (tt-param.estado      = yes
        or    tit-ap.estado        = 1) 
        no-lock:
        
        if  tit-ap.data-2   > tt-param.da-baixa
        or  tit-ap.enviado  
        or  tit-ap.vl-saldo = 0 then 
            next.
        
        /*** TRATAMETNO CHEQUE NOMINAL PARA VERSAO >= 2.02 ***/
        run pi-versao in this-procedure (input 1).
        if  return-value = "NOK" then
            next.

        find first tt-emitente where tt-emitente.cod-emitente = tit-ap.cod-fornec no-lock no-error.
        if  not avail tt-emitente then do:
            find emitente where emitente.cod-emitente = tit-ap.cod-fornec no-lock no-error.
            if not avail emitente then 
               next.
            create tt-emitente.
            buffer-copy emitente to tt-emitente.
        end.
        if  avail tt-emitente and tt-emitente.flag-pag = 2 then 
            next.

        /** NÆo permite baixa caso tenha o M¢dulo de Cƒmbio **/
        &if defined(BF_FIN_MODUL_CAMBIO) &then
            if avail param-global and param-global.modulo-mec = yes then do:
                if avail tt-emitente then do:
                    if tit-ap.moeda      <> 0 and
                       tt-emitente.natureza  = 3 then
                       next.
                end.
            end.
        &endif
        
        /*** Verifica se possui registro pendente ***/
        if can-find (first lin-b-ap
                     where lin-b-ap.ep-codigo   = tit-ap.ep-codigo    
                     and   lin-b-ap.cod-estabel = tit-ap.cod-estabel
                     and   lin-b-ap.cod-esp     = tit-ap.cod-esp
                     and   lin-b-ap.serie       = tit-ap.serie
                     and   lin-b-ap.nr-docto    = tit-ap.nr-docto
                     and   lin-b-ap.parcela     = tit-ap.parcela
                     and   lin-b-ap.cod-fornec  = tit-ap.cod-fornec) then
            next.
        
        if  tit-ap.moeda <> 0 then do:
            find first cotacao 
                 where cotacao.mo-codigo   = tit-ap.moeda 
                 and   cotacao.ano-periodo = string(year(tt-param.da-baixa)) + string(month(tt-param.da-baixa),"99") 
                 and   cotacao.cotacao[int(day(tt-param.da-baixa))] <> 0 no-lock no-error.
            if  not avail cotacao then 
                next.
        end.

        /*** Verifica se o potador do T¡tulo difere do lote ***/
        
        if  doc-b-ap.mo-codigo <> 0 
        and doc-b-ap.mo-codigo <> tit-ap.moeda then
            next.

        create tt-baixa.
        assign tt-baixa.referencia   = tt-param.referencia
               tt-baixa.dt-baixa     = tt-param.da-baixa 
               tt-baixa.cod-estabel  = tit-ap.cod-estabel
               tt-baixa.cod-esp      = tit-ap.cod-esp
               tt-baixa.serie        = tit-ap.serie           
               tt-baixa.nr-docto     = tit-ap.nr-docto
               tt-baixa.parcela      = tit-ap.parcela
               tt-baixa.cod-fornec   = tit-ap.cod-fornec
               tt-baixa.portador     = tit-ap.portador
               tt-baixa.nome-abrev   = tit-ap.nome-abrev
               tt-baixa.dt-vencimen  = tit-ap.dt-vencimen
               tt-baixa.moeda        = tit-ap.moeda
               tt-baixa.estado       = tit-ap.estado.

       assign tt-baixa.valor-saldo    = tit-ap.valor-saldo               
              tt-baixa.vl-saldo-me    = tit-ap.vl-saldo-me
              tt-baixa.de-vl-desconto    = tit-ap.vl-desconto
              tt-baixa.de-vl-desconto-me = tit-ap.vl-desconto-me.                    

       if  tt-baixa.moeda <> 0 then do:

           assign tt-baixa.cotacao-dia = cotacao.cotacao[int(day(tt-param.da-baixa))].

           run app/ap0570a.p (input rowid(tit-ap),
                              input tt-baixa.dt-baixa,
                              input tt-baixa.cotacao-dia,
                              output de-vl-var-monet).

           assign tt-baixa.valor-saldo = tt-baixa.valor-saldo
                                       + de-vl-var-monet.
       end.
       else do:
           assign tt-baixa.cotacao-dia = 1.
       end.
    end.

    IF SESSION:SET-WAIT-STATE('') THEN

