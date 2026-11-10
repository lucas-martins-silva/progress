/**********************************************************************************
***
*** app/ap0503d.i - Multiplanta para Antecipa‡Æo e Imposto gerado na AN via Border“
***
**********************************************************************************/

create tt-bordero-ap-aux.
buffer-copy {1} to tt-bordero-ap-aux.
 
create tt-dados-env.
assign tt-dados-env.num-sequencia  = i-seq 
       tt-dados-env.cod-tipo-reg   = 172
       tt-dados-env.ind-tipo-movto = i-tipo-movto
       tt-dados-env.identif-msg    = string({1}.ep-codigo)   + " , " +
                                     string({1}.cod-fornec)  + " , " +
                                     string({1}.cod-estabel) + " , " +
                                     string({1}.cod-esp)     + " , " +
                                     string({1}.serie)       + " , " +
                                     string({1}.nr-docto)    + " , " +
                                     string({1}.parcela).

raw-transfer tt-bordero-ap-aux to tt-dados-env.conteudo-msg.
assign i-seq = i-seq + 1.
