/******************************************************************************
**
** AP0705E.I - for each
**
******************************************************************************/

  for each emitente use-index {2}
      where emitente.cod-gr-forn >= tt-param.cod-emi-ini
      and   emitente.cod-gr-forn <= tt-param.cod-emi-fim
      and   emitente.identific   <> 1 no-lock, 
      each tit-ap use-index fornec no-lock
        where tit-ap.cod-fornec   = emitente.cod-emit
          and   tit-ap.ep-codigo    = tt-param.i-ep-codigo
          and   tit-ap.cod-estab   >= tt-param.est-ini
          and   tit-ap.cod-estab   <= tt-param.est-fim
          and   tit-ap.cod-esp     >= tt-param.esp-ini
          and   tit-ap.cod-esp     <= tt-param.esp-fim
          and   tit-ap.dt-vencimen <= tt-param.da-referencia
          {1}
          and   tit-ap.valor-saldo  > 0 
          break {3} by tit-ap.cod-fornec:

          {app/ap9999.i1 "tit-ap" "tt-param.moeda"}

          assign de-saldo      = de-calc-valor-saldo
                 de-vl-titulo  = de-saldo 
                 de-total-emit = de-total-emit + de-vl-titulo.

          if  {4} then do:
              create curva-ap.
              assign curva-ap.cod-fornec = {5}
                     curva-ap.vl-aberto  = de-total-emit
                     i-nr-emit           = i-nr-emit + 1
                     de-tit-period       = de-tit-period + de-total-emit
                     de-total-emit       = 0.
          end.
          run pi-acompanhar in h-acomp(input c-for + string(emitente.cod-emitente)).       
  end.
/* AP0705E.I */
