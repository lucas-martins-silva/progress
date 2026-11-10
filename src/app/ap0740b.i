/*******************************************************************************
***
*** app/ap0740b.i - C†lculo Valor Movimento.
***
***                 OBS: Rotina usada tambÇm pelo Raz∆o de Movimentos.
*** 
***                 <<<< CUIDADO AO ALTERAR >>>>
***
*******************************************************************************/

    
/*--- Quando o Raz∆o estiver lendo os movimentos de PEF's
      n∆o haver† titulo dispon°vel ---*/
        
if  avail tit-ap then
    assign i-moeda = tit-ap.moeda.
else
    assign i-moeda = 0.
    
/*--- Segue como critÇrio a moeda de apresentaá∆o ---*/
if  tt-param.i-opcao-moeda = 1 and tt-param.log-cons-mo-orig = no then do:
    if  tt-param.i-cod-moeda = 0 then do:
        assign de-valor-mov = {1}.
    end.
    else do:
        if  tt-param.i-cod-moeda = i-moeda then 
            assign de-valor-mov = {2}.
        else
            assign de-valor-mov = {1} / tt-param.de-cotacao-dia.
    end.
end.
    
/*--- Segue como critÇrio a moeda Original, n∆o existe convers∆o ---*/
if  tt-param.i-opcao-moeda = 1 and tt-param.log-cons-mo-orig = yes then do:
    if  i-moeda = 0 then
        assign de-valor-mov = {1}.
    else
        assign de-valor-mov = {2}.
end.
    
/*--- Somente ser for FASB ---*/
if  tt-param.i-opcao-moeda = 2 then 
    assign de-valor-mov = {3}.


/*--- CMCAC ---*/
if  tt-param.i-opcao-moeda = 3 then
    assign de-valor-mov = {4}.

