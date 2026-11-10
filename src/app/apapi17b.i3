/*******************************************************************************
*** 
*** app/apapi17b.i3 - Atualiza‡Æo Contas de D‚bito.
*** 
*******************************************************************************/

for each tt-conta-debito:

    find first conta-contab no-lock 
         where conta-contab.ep-codigo      = tit-ap.ep-codigo
         and   conta-contab.conta-contabil = tt-conta-debito.conta-debito no-error.

    if  avail conta-contab then do:
        create tit-conta-ap.
        assign tit-conta-ap.ep-codigo    = tit-ap.ep-codigo
               tit-conta-ap.cod-estabel  = tit-ap.cod-estabel
               tit-conta-ap.cod-esp      = tit-ap.cod-esp
               tit-conta-ap.serie        = tit-ap.serie
               tit-conta-ap.nr-docto     = tit-ap.nr-docto
               tit-conta-ap.parcela      = tit-ap.parcela
               tit-conta-ap.cod-fornec   = tit-ap.cod-fornec
               tit-conta-ap.ct-codigo    = conta-contab.ct-codigo
               tit-conta-ap.sc-codigo    = conta-contab.sc-codigo
               tit-conta-ap.conta-debito = conta-contab.conta-contabil.
        assign tit-conta-ap.vl-movto-me  = fn_ajust_dec(tt-conta-debito.vl-movto, tit-ap.moeda)
               tit-conta-ap.vl-movto     = fn_ajust_dec(tt-conta-debito.vl-movto, tit-ap.moeda).
    end.
end.

/* Fim de Include */

