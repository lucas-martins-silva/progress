/**************************************************************************
**
**  AP0705A.i
**
***************************************************************************/

 for each emitente use-index {1}
     where emitente.cod-gr-forn >= tt-param.cod-emi-ini
     and   emitente.cod-gr-forn <= tt-param.cod-emi-fim
     and   emitente.identific   <> 1 no-lock,      
     each tit-ap use-index ch-liq       
      where tit-ap.ep-codigo      = tt-param.i-ep-codigo
        and   tit-ap.cod-fornec   = emitente.cod-emitente
        and   tit-ap.dt-liq      >= tt-param.da-referencia
        and   tit-ap.cod-estab   >= tt-param.est-ini
        and   tit-ap.cod-estab   <= tt-param.est-fim
        and   tit-ap.cod-esp     >= tt-param.esp-ini
        and   tit-ap.cod-esp     <= tt-param.esp-fim
        {5}
        and   tit-ap.dt-trans    <= i-fim-periodo no-lock
        break {2}:

       {app/ap9999.i1 "tit-ap" "tt-param.moeda"}

       assign de-saldo = de-calc-valor-saldo.

       if  tit-ap.tipo <> 2 then do:
           if  tit-ap.valor-saldo <> tit-ap.vl-original then do:
               mov-block:
               for each mov-ap
                   where mov-ap.ep-codigo   = tit-ap.ep-codigo
                   and   mov-ap.cod-estabel = tit-ap.cod-estabel
                   and   mov-ap.cod-esp     = tit-ap.cod-esp
                   and   mov-ap.serie       = tit-ap.serie
                   and   mov-ap.nr-docto    = tit-ap.nr-docto
                   and   mov-ap.parcela     = tit-ap.parcela
                   and   mov-ap.cod-fornec  = tit-ap.cod-fornec
                   and   (mov-ap.transacao  = 2 or mov-ap.transacao = 5
                   or     mov-ap.transacao  = 3
                   or    (mov-ap.transacao  = 6 and mov-ap.lancamento = 1)) no-lock:

                   {app/ap9999.i2 "mov-ap" "tt-param.moeda" "tit-ap"}

                   if  mov-ap.dt-transacao > tt-param.da-referencia then do:
                       if  mov-ap.transacao = 5 and mov-ap.lancamento = 1 then
                           assign de-saldo = de-saldo - de-calc-valor-mov.
                       else
                           assign de-saldo = de-saldo + de-calc-valor-mov.  
                   end.        
               end.        
           end.
       end.
       else do:
           mov-block:
           for each mov-ap use-index ch-antecip
               where mov-ap.ep-codigo  = tit-ap.ep-codigo
               and   mov-ap.cod-est    = tit-ap.cod-est
               and   mov-ap.esp-ant    = tit-ap.cod-esp
               and   mov-ap.serie-ant  = tit-ap.serie
               and   mov-ap.docto-ant  = tit-ap.nr-docto
               and   mov-ap.parc-ant   = tit-ap.parcela
               and   mov-ap.cod-fornec = tit-ap.cod-fornec
               and  (mov-ap.transacao  = 2
               or    mov-ap.transacao  = 3)
               and   mov-ap.vl-antecip > 0 no-lock:

               {app/ap9999.i2 "mov-ap" "tt-param.moeda" "tit-ap"}

               if  mov-ap.dt-trans > tt-param.da-referencia then
                   assign de-saldo = de-saldo + de-calc-vl-antecip.

           end. 

           mov-block:
           for each mov-ap use-index codigo
               where mov-ap.ep-codigo  = tit-ap.ep-codigo
               and   mov-ap.cod-fornec = tit-ap.cod-fornec
               and   mov-ap.cod-est    = tit-ap.cod-est
               and   mov-ap.cod-esp    = tit-ap.cod-esp
               and   mov-ap.serie      = tit-ap.serie
               and   mov-ap.nr-docto   = tit-ap.nr-docto
               and   mov-ap.parcela    = tit-ap.parcela
               and   mov-ap.transacao  = 5 no-lock:

               {app/ap9999.i2 "mov-ap" "tt-param.moeda" "tit-ap"}

               if  mov-ap.dt-trans > tt-param.da-referencia then do:
                   if  mov-ap.lancamento = 1 then
                       assign de-saldo = de-saldo + de-calc-valor-mov.
                   else
                       assign de-saldo = de-saldo - de-calc-valor-mov.
               end.
           end.
       end.

       assign de-vl-titulo = de-saldo.

       if  tit-ap.tipo = 2 then
           assign de-vl-titulo = de-vl-titulo * (-1).

       assign de-total-emit = de-total-emit + de-vl-titulo.

       if  {3}

           de-total-emit <> 0 then do:
           create curva-ap.
           assign curva-ap.cod-fornec = {4}
                  curva-ap.vl-aberto  = de-total-emit
                  i-nr-emit           = i-nr-emit + 1
                  de-tit-period       = de-tit-period + de-total-emit
                  de-total-emit       = 0.
       end.
       run pi-acompanhar in h-acomp (input c-for + string(emitente.cod-emitente)).
end.                  

/* ap0705a.i */
