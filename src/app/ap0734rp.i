/******************************************************************************
***
*** app/ap0734.i - Impress∆o Detalhe.
***
******************************************************************************/

ASSIGN i-cont = i-cont + 1.

IF  i-cont MOD 10 = 0 THEN
    run pi-acompanhar in h-acomp (input "Registros Lidos: " + STRING(i-cont)).

IF  tt-param.l-resumo = NO THEN DO:
    disp tt-dirf-ap.cod-retensao
         tt-dirf-ap.dt-implant
         tt-dirf-ap.dt-pagto
         tt-dirf-ap.cod-fornec
         tt-dirf-ap.nome-abrev
         tt-dirf-ap.cod-estabel
         tt-dirf-ap.serie 
         tt-dirf-ap.nr-docto 
         tt-dirf-ap.parcela
         tt-dirf-ap.origem FORMAT "x(10)"
         tt-dirf-ap.cod-esp 
         tt-dirf-ap.de-rendto
         tt-dirf-ap.valor-ir 
         with frame {1}.
    
    down with frame {1}.
END.

ASSIGN de-geral-tot-rend  = de-geral-tot-rend  + tt-dirf-ap.vl-rend-trib
       de-geral-tot-impto = de-geral-tot-impto + tt-dirf-ap.valor-ir.

/* Fim Include */
