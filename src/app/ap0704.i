/**************************************************************************
**
** AP0704.I - Include para convers∆o das previs‰es para a data desejada
**
**************************************************************************/

if  tit-ap.tipo <> 1  /*NO*/ and 
    tit-ap.tipo <> 2 /*AN*/  then do:  
    if  tt-param.normal-fasb <> 2 then
        assign de-saldo    = de-calc-valor-saldo
               de-original = de-calc-vl-original.
    else
        assign de-saldo    = tit-ap.valor-saldo
               de-original = tit-ap.vl-original.
end.            
else do:
    if  tt-param.normal-fasb <> 2 then
        assign de-saldo    = de-calc-valor-saldo 
               de-original = de-calc-vl-original
               de-dolar    = 1.
    else do:
        assign de-saldo    = tit-ap.valor-saldo 
               de-original = tit-ap.vl-original.
 
        find param-fasb 
             where param-fasb.ep-codigo = tt-param.i-ep-codigo no-lock no-error.
        if  tit-ap.tipo = 2 then do:   /*AN*/
            assign de-dolar = tit-ap.vl-sal-fasb / 100.
        end.
        else do:
            if  param-fasb.tipo-calculo = 0 then do:
                find cotacao
                     where cotacao.mo-codigo   = param-fasb.moeda-fasb
                     and   cotacao.ano-periodo = string(year(tit-ap.dt-emissao)) + string(month(tit-ap.dt-emissao),"99")
                     and   cotacao.cotacao[int(day(tit-ap.dt-emissao))] <> 0 no-lock no-error.
          
                if  avail cotacao then
                    assign de-dolar = cotacao.cotacao[int(day(tit-ap.dt-emissao))].
                if  de-dolar = 0 then do:
                    run utp/ut-msgs.p (input "msg",
                                       input 316,
                                       input string(param-fasb.moeda-fasb) + "~~" +
                                             string(tit-ap.dt-emissao)).
                    assign c-mensagem = return-value.
                    put c-mensagem.
                end.
  
                assign de-dolar = de-dolar * (tit-ap.vl-sal-fasb / tit-ap.vl-orig-fasb).
            end.
            else
                assign de-dolar = tit-ap.vl-sal-fasb / 100.
        end.
        assign de-saldo    = if de-dolar = ? or de-dolar = 0 then 0 else
                             de-saldo / de-dolar
               de-original = if de-dolar = ? or de-dolar = 0 then 0 else
                             de-original / de-dolar.

        find first mov-ap
             where mov-ap.ep-codigo  = tit-ap.ep-codigo
             and   mov-ap.cod-est    = tit-ap.cod-est
             and   mov-ap.cod-esp    = tit-ap.cod-esp
             and   mov-ap.serie      = tit-ap.serie
             and   mov-ap.nr-docto   = tit-ap.nr-docto
             and   mov-ap.parcela    = tit-ap.parcela
             and   mov-ap.cod-fornec = tit-ap.cod-fornec
             and   mov-ap.transacao  = 1  /*IMD*/
             no-lock no-error.
        if  avail mov-ap then
            assign de-original = mov-ap.vl-mov-fasb.
    end.
end.

/* AP0704.I */
