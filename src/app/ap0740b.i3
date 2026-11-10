/*******************************************************************************
***
*** app/ap0740b.i3 - Gera Hist¢rico.
***
*******************************************************************************/

if (tt-param.log-lis-hist-docto = yes or 
    tt-param.log-lis-hist-prev  = yes) then do:

    find first mov-ap use-index codigo
         where mov-ap.ep-codigo    = tit-ap.ep-codigo
         and   mov-ap.cod-fornec   = tit-ap.cod-fornec
         and   mov-ap.cod-estabel  = tit-ap.cod-estabel
         and   mov-ap.cod-esp      = tit-ap.cod-esp
         and   mov-ap.serie        = tit-ap.serie
         and   mov-ap.nr-docto     = tit-ap.nr-docto
         and   mov-ap.parcela      = tit-ap.parcela
         and   (mov-ap.transacao   = 1 or mov-ap.transacao = 6)
         no-lock no-error.

    if  avail mov-ap and mov-ap.historico <> "" then do:
        if  tit-ap.tipo = 3 and tt-param.log-lis-hist-prev = yes then
            assign tt-tit-ap.historico = mov-ap.historico.
        else
            if  tt-param.log-lis-hist-docto = yes then
                assign tt-tit-ap.historico = mov-ap.historico.
    end.
end.

/* Fim de Include */
