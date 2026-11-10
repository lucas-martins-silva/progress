/******************************************************************************
***                         
*** app/ap0004.i - Gera‡Æo Autom tica de Impostos - AP.
***                             
******************************************************************************/

for each tt-impto-tit-ap:
    delete tt-impto-tit-ap.
end.
    
create tt-impto-tit-ap.
assign tt-impto-tit-ap.origem-impto   = {1}
       tt-impto-tit-ap.lancamento     = {2}
       tt-impto-tit-ap.trans-impto-ap = {3}
       tt-impto-tit-ap.dt-emissao     = {4}
       tt-impto-tit-ap.dt-transacao   = {5}
       tt-impto-tit-ap.de-valor-old   = {6}
       tt-impto-tit-ap.de-valor-new   = {7}
       tt-impto-tit-ap.ep-codigo      = {8}
       tt-impto-tit-ap.cod-estabel    = {9}
       tt-impto-tit-ap.cod-fornec     = {10}
       tt-impto-tit-ap.cod-esp        = {11}
       tt-impto-tit-ap.serie          = {12}
       tt-impto-tit-ap.nr-docto       = {13}
       tt-impto-tit-ap.parcela        = {14}
       tt-impto-tit-ap.num-id-mov-ap  = {15}
       tt-impto-tit-ap.log-pendente   = {16}.
        
run app/ap0004.p (input table tt-impto-tit-ap).
    
/* Fim de Include */
