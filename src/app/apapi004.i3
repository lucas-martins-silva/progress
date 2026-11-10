/********************************************************************************
***
*** app/apapi004.i3 - Cria Log Erros API Previsäes Contas a Pagar.
***
********************************************************************************/
        
find first tt-log-tit-ap use-index codigo
     where tt-log-tit-ap.ep-codigo   = tt-tit-ap.ep-codigo
     and   tt-log-tit-ap.cod-estabel = tt-tit-ap.cod-estabel
     and   tt-log-tit-ap.cod-fornec  = tt-tit-ap.cod-fornec
     and   tt-log-tit-ap.cod-esp     = tt-tit-ap.cod-esp
     and   tt-log-tit-ap.serie       = tt-tit-ap.serie
     and   tt-log-tit-ap.nr-docto    = tt-tit-ap.nr-docto
     and   tt-log-tit-ap.parcela     = tt-tit-ap.parcela no-error.
        
if  avail tt-log-tit-ap then do:
    assign tt-log-tit-ap.descricao = tt-log-tit-ap.descricao
                                   + chr(13)
                                   + chr(13)
                                   + {1}.
end.
else do:
    create tt-log-tit-ap.
    assign tt-log-tit-ap.ep-codigo   = tt-tit-ap.ep-codigo
           tt-log-tit-ap.cod-fornec  = tt-tit-ap.cod-fornec
           tt-log-tit-ap.cod-estabel = tt-tit-ap.cod-estabel
           tt-log-tit-ap.cod-esp     = tt-tit-ap.cod-esp
           tt-log-tit-ap.serie       = tt-tit-ap.serie
           tt-log-tit-ap.nr-docto    = tt-tit-ap.nr-docto
           tt-log-tit-ap.parcela     = tt-tit-ap.parcela
           tt-log-tit-ap.descricao   = {1}.
end.

/* Fim de Include */
