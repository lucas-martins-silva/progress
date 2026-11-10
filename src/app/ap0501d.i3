/******************************************************************************
***
***  app/ap0501d.i3 - Valida‡Æo Casas Decimais Moeda - lin-i-ap.
***  
***  ***** NÆo foram validados os atributos 
***  ***** valor-fasb
***  ***** valor-pres
***  ***** valor-cmi
******************************************************************************/

/* Verifica Decimais para vl-original */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.vl-original,0).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap vl-original 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para vl-desconto */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.vl-desconto,0).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap vl-desconto 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.


/* Verifica Decimais para vl-juros */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.vl-juros,0).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap vl-juros 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para vl-imposto */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.vl-imposto,0).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap vl-imposto 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para valor-ir */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.valor-ir,0).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap valor-ir 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para vl-ir-antec */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.vl-ir-antec,0).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap vl-ir-antec 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para diversos */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.diversos,0).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap diversos 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para frete */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.frete,0).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap frete 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para vl-liquido */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.vl-liquido,0).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap vl-liquido 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para vl-orig-me */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.vl-orig-me,lin-i-ap.mo-codigo).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap vl-orig-me 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para vl-desconto-me */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.vl-desconto-me,lin-i-ap.mo-codigo).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap vl-desconto-me 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para diversos-me */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.diversos-me,lin-i-ap.mo-codigo).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap diversos-me 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para frete-me */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.frete-me,lin-i-ap.mo-codigo).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap frete-me 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para vl-imposto-me */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.vl-imposto-me,lin-i-ap.mo-codigo).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap vl-imposto-me 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para vl-liquido-me */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.vl-liquido-me,lin-i-ap.mo-codigo).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap vl-liquido-me 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para vl-juros-me */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.vl-juros-me,lin-i-ap.mo-codigo).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap vl-juros-me 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.

/* Verifica Decimais para valor-ir-me */
assign l-rejeita-dec  = no.
assign de-tt-valor-valida = fn_vld_ajust_dec(lin-i-ap.valor-ir-me,lin-i-ap.mo-codigo).
if  l-rejeita-dec then do:
    {utp/ut-field.i mgadm lin-i-ap valor-ir-me 1}
    run utp/ut-msgs.p(input "help", 
                      input 18130, 
                      input trim(return-value)).
    assign l-situacao = no
           i-num-erro = 18130
           c-cod-msg  = string(lin-i-ap.ep-codigo)  + " , " +
                        string(lin-i-ap.referencia) + " , " +
                        string(lin-i-ap.sequencia)  + " , " +
                        string(lin-i-ap.seq-import).       
    {app/ap0501d.i "18130"}
end.
