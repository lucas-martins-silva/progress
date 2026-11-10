/*******************************************************************************
***
*** app/ap0741c.i - For each Principal.
***
*******************************************************************************/

case tt-param.i-opcao-moeda:
   when 1 then
       assign i-moeda-1 = 8    /* GPF */
              i-moeda-2 = 9.   /* CMI */
   when 2 then
       assign i-moeda-1 = 9
              i-moeda-2 = 9.
   when 3 then
       assign i-moeda-1 = 8
              i-moeda-2 = 8.
end case.


Movto_Block:
for each  mov-ap use-index {1}
    where mov-ap.ep-codigo     = tt-param.ep-codigo
    {2}
    and   mov-ap.cod-esp      >= tt-param.cod-esp-ini
    and   mov-ap.cod-esp      <= tt-param.cod-esp-fim
    and   mov-ap.transacao    <> 7   /* XYZ */
    and   mov-ap.transacao    <> 10  /* CAN */
    and   mov-ap.transacao    <> 11  /* SUS */
    and   mov-ap.transacao    <> 12  /* CSP */
    and   mov-ap.transacao    <> 13  /* DSV */
    and   mov-ap.transacao    <> 14  /* DSP */
    and   mov-ap.transacao    <> 15  /* ALT */
    and   mov-ap.transacao    <> i-moeda-1
    and   mov-ap.transacao    <> i-moeda-2    
    no-lock:

    if mov-ap.transacao = 5 and mov-ap.tipo = 10 and mov-ap.contabiliza = false then
        next.


    find first tt-tit-ap no-lock
        where tt-tit-ap.ep-codigo   = mov-ap.ep-codigo
        and   tt-tit-ap.cod-estabel = mov-ap.cod-estabel
        and   tt-tit-ap.cod-fornec  = mov-ap.cod-fornec
        and   tt-tit-ap.cod-esp     = mov-ap.cod-esp
        and   tt-tit-ap.serie       = mov-ap.serie
        and   tt-tit-ap.nr-docto    = mov-ap.nr-docto
        and   tt-tit-ap.parcela     = mov-ap.parcela
        no-error.
    if  not avail tt-tit-ap then do:
        find first tit-ap no-lock
            where tit-ap.ep-codigo   = mov-ap.ep-codigo
            and   tit-ap.cod-estabel = mov-ap.cod-estabel
            and   tit-ap.cod-fornec  = mov-ap.cod-fornec
            and   tit-ap.cod-esp     = mov-ap.cod-esp
            and   tit-ap.serie       = mov-ap.serie
            and   tit-ap.nr-docto    = mov-ap.nr-docto
            and   tit-ap.parcela     = mov-ap.parcela
            no-error.
        if  avail tit-ap then do:
            create tt-tit-ap.
            buffer-copy tit-ap to tt-tit-ap.
        end.
    end.        


    if avail tt-tit-ap then do:

        if  tt-tit-ap.moeda = tt-param.i-cod-moeda then do:
            if  tt-param.log-lista-variacao   = no 
            and mov-ap.log-1                  = yes 
            and substr(mov-ap.referencia,1,2) = "VC" then 
                next.
        end.    

        if (tt-tit-ap.moeda < tt-param.moeda-ini or
            tt-tit-ap.moeda > tt-param.moeda-fim) then
            next Movto_Block.

        if (tt-tit-ap.tipo = 4 or
            tt-tit-ap.tipo = 5) then
            next Movto_Block.

    end.
    else
        if (mov-ap.moeda < tt-param.moeda-ini or
            mov-ap.moeda > tt-param.moeda-fim) then
            next Movto_Block.

    run pi-selecionar-movimentos.

    if  return-value = 'NOK' then
        next Movto_Block.

end.

if l-log-lista-baixa-an = yes then do:
    Ant_block:
    for each  mov-ap use-index {3}
        where mov-ap.ep-codigo     = tt-param.ep-codigo
        {4}
        and   mov-ap.esp-ant      >= tt-param.cod-esp-ini
        and   mov-ap.esp-ant      <= tt-param.cod-esp-fim
        and   mov-ap.transacao    = 2   /* BND */
        no-lock:

        find first tt-tit-ap no-lock
            where tt-tit-ap.ep-codigo   = mov-ap.ep-codigo
            and   tt-tit-ap.cod-estabel = mov-ap.cod-estabel
            and   tt-tit-ap.cod-fornec  = mov-ap.fornec-ant
            and   tt-tit-ap.cod-esp     = mov-ap.esp-ant
            and   tt-tit-ap.serie       = mov-ap.serie-ant
            and   tt-tit-ap.nr-docto    = mov-ap.docto-ant
            and   tt-tit-ap.parcela     = mov-ap.parc-ant
            no-error.
        if  not avail tt-tit-ap then do:
            find first tit-ap no-lock
                where tit-ap.ep-codigo   = mov-ap.ep-codigo  
                and   tit-ap.cod-estabel = mov-ap.cod-estabel
                and   tit-ap.cod-fornec  = mov-ap.fornec-ant 
                and   tit-ap.cod-esp     = mov-ap.esp-ant    
                and   tit-ap.serie       = mov-ap.serie-ant  
                and   tit-ap.nr-docto    = mov-ap.docto-ant  
                and   tit-ap.parcela     = mov-ap.parc-ant   
                no-error.
            if  avail tit-ap then do:
                create tt-tit-ap.
                buffer-copy tit-ap to tt-tit-ap.
            end.
        end.        


        if avail tt-tit-ap then do:

            if  tt-tit-ap.moeda = tt-param.i-cod-moeda then do:
                if  tt-param.log-lista-variacao   = no 
                and mov-ap.log-1                  = yes 
                and substr(mov-ap.referencia,1,2) = "VC" then 
                    next.
            end.    

            if (tt-tit-ap.moeda < tt-param.moeda-ini or
                tt-tit-ap.moeda > tt-param.moeda-fim) then
                next Ant_block.

            if (tt-tit-ap.tipo = 4 or
                tt-tit-ap.tipo = 5) then
                next Ant_block.

        end.
        else
            if (mov-ap.moeda < tt-param.moeda-ini or
                mov-ap.moeda > tt-param.moeda-fim) then
                next Ant_block.

        run pi-selecionar-movimentos-ant.

        if  return-value = 'NOK' then
            next Ant_block.

    end.
end.

/* Fim de Include */
