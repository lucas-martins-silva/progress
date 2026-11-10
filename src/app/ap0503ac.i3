/********************************************************************************
***
*** app/ap0503ac.i3 - Gera Emite AP.
***
********************************************************************************/

find first espec-ap where espec-ap.cod-esp = b-tit-ap.cod-esp no-lock no-error.
if  avail espec-ap then do:
    if  espec-ap.emite-ap = yes then do:
        create emite-ap.
        assign emite-ap.ep-codigo   = b-tit-ap.ep-codigo
               emite-ap.cod-estabel = b-tit-ap.cod-estabel
               emite-ap.cod-esp     = b-tit-ap.cod-esp
               emite-ap.serie       = b-tit-ap.serie
               emite-ap.nr-docto    = b-tit-ap.nr-docto
               emite-ap.parcela     = b-tit-ap.parcela
               emite-ap.valor-saldo = b-tit-ap.vl-original
               emite-ap.cod-fornec  = b-tit-ap.cod-fornec
               emite-ap.dt-emissao  = b-tit-ap.dt-emissao
               emite-ap.valor-ap    = b-tit-ap.vl-original
               emite-ap.dt-vencimen = b-tit-ap.dt-vencimen
               emite-ap.referencia  = b-tit-ap.referencia
               emite-ap.transacao   = 1.
               
        /************* MULTIPLATA *************/
        run pi-cria-tt-dados-emite-ap (input 1).
        /**************************************/
            
    end.
end.
        
/* Fim de Include */
