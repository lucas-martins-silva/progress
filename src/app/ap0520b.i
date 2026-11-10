/******************************************************************************
***       
*** app/ap0520b.i - Cria tt-dirf-ap
***
******************************************************************************/
if  {2} > 0 then do:
    if  {6} >= dt-data-ini and
        {6} <= dt-data-fim then do:

        create tt-dirf-ap.
        assign tt-dirf-ap.ep-codigo    = tit-ap.ep-codigo
               tt-dirf-ap.cod-estabel  = tit-ap.cod-estabel
               tt-dirf-ap.cod-fornec   = {1}
               tt-dirf-ap.cod-esp      = {5}
               tt-dirf-ap.serie        = tit-ap.serie
               tt-dirf-ap.nr-docto     = tit-ap.nr-docto
               tt-dirf-ap.parcela      = tit-ap.parcela
               tt-dirf-ap.dt-implant   = {6}
               tt-dirf-ap.dt-pagto     = tit-ap.dt-vencimen
               tt-dirf-ap.vl-rend-trib = {2}
               tt-dirf-ap.valor-ir     = {3}
               tt-dirf-ap.cod-retensao = {4}
               tt-dirf-ap.cgc          = c-cgc
               tt-dirf-ap.vl-ir-corr   = 0
               tt-dirf-ap.valor-saldo  = tit-ap.valor-saldo
               tt-dirf-ap.dt-emissao   = tit-ap.dt-emissao
               tt-dirf-ap.ind-orig     = {adinc/i01ad170.i 04 tit-ap.origem}
               tt-dirf-ap.cod-impto    = tit-ap.cod-impto-ret
               tt-dirf-ap.row-tit-ap   = rowid(tit-ap).
    
        /*  gravado o c¢digo da esp‚cie original porque para PIS/COFINS/CSLL
           poder  ser criado o dirf-ap numa esp‚cie que ser  informada na tela
           da gera‡Æo */

        assign tt-dirf-ap.char-1 = trim(caps(tit-ap.cod-esp)).

        if  avail emitente then
            assign tt-dirf-ap.nome-abrev  = emitente.nome-abrev
                   tt-dirf-ap.cod-gr-forn = emitente.cod-gr-forn
                   c-cgc                  = replace(emitente.cgc,"/","")
                   c-cgc                  = replace(c-cgc,".","")
                   c-cgc                  = replace(c-cgc,"-","").
        else
            assign c-cgc = "".
    
        assign tt-dirf-ap.cgc = c-cgc.
    end.
    find tt-dirf-ap-in511 no-lock
        where tt-dirf-ap-in511.ep-codigo   = tit-ap.ep-codigo
          and tt-dirf-ap-in511.cod-fornec  = {1}
          and tt-dirf-ap-in511.cod-estab   = tit-ap.cod-estabel
          and tt-dirf-ap-in511.cod-periodo = year({6})
        no-error.
    if  not avail tt-dirf-ap-in511 then do:
        create tt-dirf-ap-in511.
        assign tt-dirf-ap-in511.ep-codigo   = tit-ap.ep-codigo
               tt-dirf-ap-in511.cod-fornec  = {1}
               tt-dirf-ap-in511.cod-estab   = tit-ap.cod-estabel
               tt-dirf-ap-in511.cod-periodo = year({6})
               tt-dirf-ap-in511.cod-impto   = tit-ap.cod-impto-ret.
    end.
    if  {6} >= dt-data-ini and
        {6} <= dt-data-fim then
        assign tt-dirf-ap-in511.vl-rend-trib = tt-dirf-ap-in511.vl-rend-trib + {2}.
    assign tt-dirf-ap-in511.valor-ir = tt-dirf-ap-in511.valor-ir + {3}.
end.
/* Fim Include */
