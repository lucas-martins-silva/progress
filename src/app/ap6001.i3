    find first tt-consiste-bloqueio-ap no-lock
         where tt-consiste-bloqueio-ap.ep-codigo      = {1}
         and   tt-consiste-bloqueio-ap.cod-estabel    = {2}
         and   tt-consiste-bloqueio-ap.cod-fornec     = {3}
         and   tt-consiste-bloqueio-ap.cod-esp        = {4}
         and   tt-consiste-bloqueio-ap.serie          = {5}
         and   tt-consiste-bloqueio-ap.nr-docto       = {6}
         and   tt-consiste-bloqueio-ap.parcela        = {7}
         no-error.

    if  not avail tt-consiste-bloqueio-ap then do:
    
        CREATE tt-consiste-bloqueio-ap.
        ASSIGN tt-consiste-bloqueio-ap.ep-codigo      = {1} 
               tt-consiste-bloqueio-ap.cod-estabel    = {2}
               tt-consiste-bloqueio-ap.cod-fornec     = {3} 
               tt-consiste-bloqueio-ap.cod-esp        = {4} 
               tt-consiste-bloqueio-ap.serie          = {5} 
               tt-consiste-bloqueio-ap.nr-docto       = {6} 
               tt-consiste-bloqueio-ap.parcela        = {7} 
               tt-consiste-bloqueio-ap.referencia     = {8}
               tt-consiste-bloqueio-ap.dt-transacao   = {9}
               tt-consiste-bloqueio-ap.num-id-mov-ap  = 0.
    end.
