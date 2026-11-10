/* ac1010.i - Acumula o total do percentual de distribui‡Æo para cada n¡vel controlado */

for each base-rat no-lock
    where  base-rat.cod-estabel      = tt-estabel.cod-estabel
      {&condicao}
      and  base-rat.cd-produto      >= tt-param.produto-ini
      and  base-rat.cd-produto      <= tt-param.produto-fim
      and  base-rat.codigo           = tt-param.codigo
      and (can-find(tt-canal-cotas where tt-canal-cotas.cod-canal-venda = base-rat.cod-canal-venda) 
           or base-rat.cod-canal-venda = 0)
      {&quebra}:

    assign de-tot-perc = de-tot-perc + base-rat.pct-rateio.

    run pi-acompanhar in h-acomp ( input de-tot-perc).

    if last-of({&last}) then do:
       if par-cota.log-limita-rateio = yes and  /* Limita o Rateio a 100% */
          de-tot-perc > 100.00 then do:
          create tt-erro-rateio.
          assign tt-erro-rateio.cod-estabel = base-rat.cod-estabel
                 tt-erro-rateio.nivel = (if "{&nivel}" = "Canal Venda" then c-canal-venda 
                                        else if "{&nivel}" = "Grupo Cliente" then c-grupo-cliente
                                        else if "{&nivel}" = "Cliente" then c-cliente
                                        else if "{&nivel}" = "Regiao" then c-regiao
                                        else if "{&nivel}" = "Microrregiao" then c-microrregiao
                                        else c-repres)
                 tt-erro-rateio.cd-produto = base-rat.cd-produto
                 tt-erro-rateio.percentual = de-tot-perc
                 l-perc-ok = no.
       end.
       if de-tot-perc = 0 then do:
          create tt-erro-rateio.
          assign tt-erro-rateio.cod-estabel = base-rat.cod-estabel
                 tt-erro-rateio.nivel = (if "{&nivel}" = "Canal Venda" then c-canal-venda 
                                        else if "{&nivel}" = "Grupo Cliente" then c-grupo-cliente
                                        else if "{&nivel}" = "Cliente" then c-cliente
                                        else if "{&nivel}" = "Regiao" then c-regiao
                                        else if "{&nivel}" = "Microrregiao" then c-microrregiao
                                        else c-repres)
                 tt-erro-rateio.cd-produto = base-rat.cd-produto
                 tt-erro-rateio.percentual = de-tot-perc
                 l-perc-ok = no.
       end.
       assign de-tot-perc = 0.
    end.
end.
