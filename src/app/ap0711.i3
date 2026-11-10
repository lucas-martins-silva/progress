/******************************************************************************
**
**  APP/AP0711.I3
**  Objetivo :   Dar display dos mov-ap's com quebra por grupo
**
*******************************************************************************/

{cdp/cdcfgfin.i}

assign l-primeiro  = no
       l-primeiro2 = no
       l-ultimo    = no
       l-exist-gr  = no.
       
view frame f-cab-mov.       
       
for each emitente use-index grupo-fornec
    where emitente.cod-gr-forn >= tt-param.grupo-ini
    and   emitente.cod-gr-forn <= tt-param.grupo-fim
    {6} 
    no-lock break by emitente.cod-gr-forn :
    if  first-of(emitente.cod-gr-forn) then
        assign l-primeiro = yes.

    for each mov-ap use-index codigo
        where mov-ap.ep-codigo     = tt-param.i-ep-codigo
        and   mov-ap.cod-fornec    = emitente.cod-emitente
        and   mov-ap.cod-estabel  >= tt-param.est-ini
        and   mov-ap.cod-estabel  <= tt-param.est-fim
        and   mov-ap.cod-esp      >= tt-param.esp-ini
        and   mov-ap.cod-esp      <= tt-param.esp-fim
        and   mov-ap.nr-cheque    >= tt-param.nr-cheque-ini
        and   mov-ap.nr-cheque    <= tt-param.nr-cheque-fim
        and   mov-ap.nr-bordero   >= tt-param.bordero-ini
        and   mov-ap.nr-bordero   <= tt-param.bordero-fim
        and   mov-ap.portador     >= tt-param.portador-ini
        and   mov-ap.portador     <= tt-param.portador-fim
        and   mov-ap.dt-transacao >= {1}
        and   mov-ap.dt-transacao <= {2}
        break by mov-ap.cod-fornec:

        if  first-of(mov-ap.cod-fornec) then
            assign l-primeiro2 = yes.
        
        if  mov-ap.cod-esp <> " " then do:
            find first tit-ap
                 where tit-ap.ep-codigo   = mov-ap.ep-codigo
                 and   tit-ap.cod-estabel = mov-ap.cod-estabel
                 and   tit-ap.cod-esp     = mov-ap.cod-esp
                 and   tit-ap.serie       = mov-ap.serie
                 and   tit-ap.nr-docto    = mov-ap.nr-docto
                 and   tit-ap.parcela     = mov-ap.parcela
                 and   tit-ap.cod-fornec  = mov-ap.cod-fornec no-lock no-error.
      
            if  not avail tit-ap then
                next.               
        end.
        
        {cdp/cd9600.i "tt-param.moeda"
                      "tt-param.dt-conversao"
                      "de-calc-cotacao"
                      "return error."}
                      
        {app/ap9999.i2 "mov-ap"
                       "tt-param.moeda"
                       "mov-ap"}    
       
        find espec-ap
            where espec-ap.cod-esp = mov-ap.cod-esp no-lock no-error.
        assign i-tipo-esp = if  avail espec-ap then espec-ap.tipo else 0.

        if  first-of(mov-ap.cod-fornec)
        and l-ultimo = yes then do:
            disp c-total
                 de-tot-pagto
                 de-tot-juros space(1)
                 de-tot-desc
                 &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                 de-tot-multa
                 de-tot-abat
                 &endif
                 with frame f-total.
            assign de-tot-pagto = 0
                   de-tot-juros = 0
                   de-tot-desc  = 0
                   &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                   de-tot-multa = 0
                   de-tot-abat  = 0
                   &endif
                   atraso     = 0
                   l-ultimo     = no.
        end.

       if  first-of(mov-ap.cod-fornec) then
            assign l-primeiro2 = yes.

       if  (mov-ap.transacao = 3 or mov-ap.transacao = 4)
       and mov-ap.portador > 0
       and mov-ap.port-transf > 0
       and tt-param.transf = no then
           next.

       if  mov-ap.transacao  = 5
       and mov-ap.lancamento = 1 then
            next.
       
       if  i-tipo-esp = 2
       and tt-param.tipo <> 5
       and tt-param.tipo <> 4
       and tt-param.tipo <> 2 then
            next.
      
       if  tt-param.acerto = yes then do:
           if  mov-ap.transacao <> {3}
           and mov-ap.transacao <> {4}
           and mov-ap.transacao <> {5}
           and mov-ap.transacao <> {7}
           and mov-ap.transacao <> {8} then
               next.
       end.
       else do:
           if  mov-ap.transacao <> {3}
           and mov-ap.transacao <> {4}
           and mov-ap.transacao <> {5}
           and mov-ap.transacao <> {7} then
               next.
       end.

        if  mov-ap.transacao = 1 
        and i-tipo-esp       = 2 
        and mov-ap.referencia begins "TRAN" then
            next.

       if  mov-ap.transacao = 3
       and mov-ap.portador  = 0
       and i-tipo-esp = 2 then
           next.

       if  tt-param.tipo = 1
       and mov-ap.referencia begins "BORD" then next.

       if  tt-param.tipo = 1 or tt-param.tipo = 2 or tt-param.tipo = 5 then do:
           if mov-ap.transacao = 3 or mov-ap.transacao = 4 then
              assign de-valor-conv = if tt-param.moeda = 0 
                                     then (mov-ap.valor-mov + mov-ap.vl-var-monet)
                                     else (mov-ap.valor-mov-me + mov-ap.vl-var-monet).
           else
              assign de-valor-conv = if tt-param.moeda = 0 
                                     then (mov-ap.valor-mov - mov-ap.vl-antecip + mov-ap.vl-var-monet) 
                                     else (mov-ap.valor-mov-me - mov-ap.vl-antecip-me + mov-ap.vl-var-monet).
           if  de-valor-conv = 0 then 
               next.
       end.
       else
          assign de-valor-conv = if tt-param.moeda = 0 
                                 then (mov-ap.valor-mov + mov-ap.vl-var-monet) 
                                 else (mov-ap.valor-mov-me + mov-ap.vl-var-monet). 

       if  tt-param.tipo = 1 or tt-param.tipo = 2 or tt-param.tipo = 5 then do:
           if mov-ap.transacao = 3 or mov-ap.transacao = 4 then
              assign de-valor-conv = de-calc-valor-mov. 
           else
              assign de-valor-conv = de-calc-valor-mov - de-calc-vl-antecip.
           if  de-valor-conv = 0 then
              next.
       end.
       else
            assign de-valor-conv = de-calc-valor-mov.

        
       if (tt-param.tipo = 4
       or (tt-param.tipo = 5 and mov-ap.transacao = 1))
       and i-tipo-esp <> 2 then
           next.
       if  mov-ap.transacao = 4
       or  (mov-ap.transacao = 3 and i-tipo-esp = 2) then
           assign de-ger-pagto   = de-ger-pagto   - de-valor-conv
                  de-tot-pagto   = de-tot-pagto   - de-valor-conv
                  de-ger-juros   = de-ger-juros   - de-calc-valor-juros
                  de-tot-juros   = de-tot-juros   - de-calc-valor-juros
                  de-ger-desc    = de-ger-desc    - de-calc-vl-desconto
                  de-tot-desc    = de-tot-desc    - de-calc-vl-desconto
                  de-pagto-grupo = de-pagto-grupo - de-valor-conv
                  de-juros-grupo = de-juros-grupo - de-calc-valor-juros
                  de-desc-grupo  = de-desc-grupo  - de-calc-vl-desconto
                  &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                  de-ger-multa   = de-ger-multa   - de-calc-valor-multa
                  de-tot-multa   = de-tot-multa   - de-calc-valor-multa
                  de-ger-abat    = de-ger-abat    - de-calc-valor-abat
                  de-tot-abat    = de-tot-abat    - de-calc-valor-abat
                  de-multa-grupo = de-multa-grupo - de-calc-valor-multa
                  de-abat-grupo  = de-abat-grupo  - de-calc-valor-abat
                  &endif
                  .
       else
           assign de-ger-pagto   = de-ger-pagto   + de-valor-conv
                  de-tot-pagto   = de-tot-pagto   + de-valor-conv
                  de-ger-juros   = de-ger-juros   + de-calc-valor-juros
                  de-tot-juros   = de-tot-juros   + de-calc-valor-juros
                  de-ger-desc    = de-ger-desc    + de-calc-vl-desconto
                  de-tot-desc    = de-tot-desc    + de-calc-vl-desconto
                  de-pagto-grupo = de-pagto-grupo + de-valor-conv
                  de-juros-grupo = de-juros-grupo + de-calc-valor-juros
                  de-desc-grupo  = de-desc-grupo  + de-calc-vl-desconto
                  &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                  de-ger-multa   = de-ger-multa   + de-calc-valor-multa
                  de-tot-multa   = de-tot-multa   + de-calc-valor-multa
                  de-ger-abat    = de-ger-abat    + de-calc-valor-abat
                  de-tot-abat    = de-tot-abat    + de-calc-valor-abat
                  de-multa-grupo = de-multa-grupo + de-calc-valor-multa
                  de-abat-grupo  = de-abat-grupo  + de-calc-valor-abat
                  &endif
                  .

        if  mov-ap.cod-esp <> "" and avail tit-ap then
            assign da-vencim = tit-ap.dt-vencimen.
        else
            assign da-vencim = mov-ap.dt-vencimen.
           
       find calen-coml
           where calen-coml.ep-codigo   = mov-ap.ep-codigo
           and   calen-coml.cod-estabel = mov-ap.cod-estabel
           and   calen-coml.data        = da-vencim
           no-lock no-error.
       if  avail calen-coml then do:
           i-semana   = weekday(da-vencim).
           if  calen-coml.tipo-dia <> 1 then do:
               if  (i-semana = 7 and emitente.ven-sabado = 1)
               or  (i-semana = 1 and emitente.ven-domingo = 1)
               or  (i-semana > 1 and i-semana < 7
               and emitente.ven-feriado = 1) then repeat:
                   assign da-vencim = da-vencim + 1.
                   find calen-coml
                       where calen-coml.ep-codigo = mov-ap.ep-codigo
                       and   calen-coml.cod-estabel = mov-ap.cod-estabel
                       and   calen-coml.data  = da-vencim
                       no-lock no-error.
                   if  not avail calen-coml then do:
                       run utp/ut-msgs.p (input "help",
                                          input 1723,
                                          input string(mov-ap.ep-codigo) + "~~" +
                                                string(mov-ap.cod-estabel) + "~~" + 
                                                string(da-vencim)).
                       assign c-mensagem = return-value.
                       disp c-mensagem with frame f-mensagem.
                       next.
                   end.
                   if  calen-coml.tipo = 1 then
                       leave.
               end.

               if  (i-semana = 7 and emitente.ven-sabado = 2)
               or  (i-semana = 1 and emitente.ven-domingo = 2)
               or  (i-semana > 1 and i-semana < 7
               and emitente.ven-feriado = 2) then repeat:
                   assign da-vencim = da-vencim - 1.
                   find calen-coml
                       where calen-coml.ep-codigo = mov-ap.ep-codigo
                       and   calen-coml.cod-estabel = mov-ap.cod-estabel
                       and   calen-coml.data  = da-vencim
                       no-lock no-error.
                   if  not avail calen-coml then do:
                       run utp/ut-msgs.p (input "show",
                                          input 1723,
                                          input string(mov-ap.ep-codigo) + "~~" +
                                                string(mov-ap.cod-estabel) + "~~" + 
                                                string(da-vencim)).
                      assign c-mensagem = return-value.
                      disp c-mensagem with frame f-mensagem.
                      next.                   
                   end.
                   if  calen-coml.tipo-dia = 1 then
                       leave.
               end.
           end.
       end.

        if  da-vencim = mov-ap.dt-transacao then
            assign atraso = 0.
        else
            if  mov-ap.cod-esp <> "" and avail tit-ap then
                assign atraso = (mov-ap.dt-transacao - tit-ap.dt-vencimen).
            else
                assign atraso = (mov-ap.dt-transacao - mov-ap.dt-vencimen).
           
     if  l-primeiro = yes then do:
         find grupo-fornec
              where grupo-fornec.cod-gr-forn = emitente.cod-gr-forn
              no-lock no-error.
         if  avail grupo-fornec then
             disp c-grupo-for
                  grupo-fornec.cod-gr-forn
                  grupo-fornec.descricao with frame f-desc-gru.
         assign l-primeiro = no
                l-ultimo   = yes
                l-exist-gr = yes.
     end.

       if  l-primeiro2 = yes then do:
           find b-emitente
              where b-emitente.cod-emitente = mov-ap.cod-fornec
              and   b-emitente.identific <> 1 no-lock no-error.
           if not avail b-emitente then
              next.
           else do:    
              disp c-emitente
                   emitente.cod-emitente
                   emitente.nome-emit
                   emitente.cidade
                   emitente.telefone[1] 
                   with frame f-emitente.
              assign l-primeiro2 = no
                     l-ultimo    = yes. 
           end.
       end.
       assign de-juros-conv = de-calc-valor-juros
              de-desc-conv  = de-calc-vl-desconto
              &if defined(BF_FIN_MULTA_ABATIMENTO) &then
              de-multa-conv = de-calc-valor-multa
              de-abat-conv  = de-calc-valor-abat
              &endif
              c-docto       = fill(" ", 16 - length(mov-ap.nr-docto)) 
                            + mov-ap.nr-docto.
       
       if mov-ap.transacao = 4 then
          assign de-valor-conv = de-valor-conv * -1.

     if  mov-ap.cod-esp <> "" and avail tit-ap then
         assign da-venc-disp = tit-ap.dt-vencimen.
     else
         assign da-venc-disp = mov-ap.dt-vencimen.
       
     disp mov-ap.cod-estabel
               mov-ap.cod-esp
               mov-ap.serie
               c-docto
               mov-ap.parcela
               mov-ap.nr-bordero
               mov-ap.referencia
               mov-ap.portador
               da-venc-disp @ mov-ap.dt-vencimen
               mov-ap.dt-transacao
               atraso
               mov-ap.nr-cheque
               de-valor-conv
               de-juros-conv 
               de-desc-conv 
               &if defined(BF_FIN_MULTA_ABATIMENTO) &then
               de-multa-conv 
               de-abat-conv
               &endif
               with frame f-mov-impl2.
            down with frame f-mov-impl2.
      
       if  tt-param.lista   =  yes
       and (mov-ap.transacao  =  3
       or   mov-ap.transacao  =  4)
       and  mov-ap.historico  <> " "    then do:
            disp mov-ap.historico with frame f-historico.
            down with frame f-historico.
       end.
    end.

    if  l-ultimo = yes then do:
        disp c-total
             de-tot-pagto
             de-tot-juros space(1)
             de-tot-desc
             &if defined(BF_FIN_MULTA_ABATIMENTO) &then
             de-tot-multa
             de-tot-abat
             &endif
             with frame f-total.
        assign de-tot-pagto = 0
               de-tot-juros = 0
               de-tot-desc  = 0
               &if defined(BF_FIN_MULTA_ABATIMENTO) &then
               de-tot-multa = 0
               de-tot-abat  = 0
               &endif
               atraso     = 0
               l-ultimo     = no.
    end.

    if  l-exist-gr = yes
    and last-of(emitente.cod-gr-forn) then do:
        disp c-tot-gru
             de-pagto-grupo
             de-juros-grupo space(1)
             de-desc-grupo
             &if defined(BF_FIN_MULTA_ABATIMENTO) &then
             de-multa-grupo
             de-abat-grupo
             &endif
             with frame f-tot-gru.
        assign de-pagto-grupo = 0
               de-juros-grupo = 0
               de-desc-grupo  = 0
               &if defined(BF_FIN_MULTA_ABATIMENTO) &then
               de-multa-grupo = 0
               de-abat-grupo  = 0
               &endif
               l-exist-gr     = no.
    end.
    run pi-acompanhar in h-acomp (input c-mens + string(emitente.cod-emitente)).
end.
hide frame f-cab-mov.
disp c-geral
     de-ger-pagto
     de-ger-juros space(1)
     de-ger-desc
     &if defined(BF_FIN_MULTA_ABATIMENTO) &then
     de-ger-multa
     de-ger-abat
     &endif
     with frame f-geral.
assign de-ger-pagto = 0
       de-ger-juros = 0
       de-ger-desc  = 0
       &if defined(BF_FIN_MULTA_ABATIMENTO) &then
       de-ger-multa = 0
       de-ger-abat  = 0
       &endif.

/*  AP0711.i3 */
