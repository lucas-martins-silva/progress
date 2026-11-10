/*******************************************************************************
**
**  Include.: AP0703.I3
**  Objetivo: Instrucoes comuns a AP0703A.P, AP0703B.P, AP0703C.P, AP0703D.P
*******************************************************************************/

each tit-ap  
    where tit-ap.ep-codigo    = tt-param.i-ep-codigo
    and   {1}
    and   tit-ap.dt-liq       >= tt-param.fim-per
    and   tit-ap.cod-estabel  >= tt-param.est-ini
    and   tit-ap.cod-estabel  <= tt-param.est-fim
    and   tit-ap.cod-esp      >= tt-param.esp-ini
    and   tit-ap.cod-esp      <= tt-param.esp-fim
    and   tit-ap.portador     >= tt-param.port-ini
    and   tit-ap.portador     <= tt-param.port-fim
    and ((tit-ap.tipo = 1)
    or   (tit-ap.tipo = 8)
    or   (tit-ap.tipo = 2  and tt-param.antec     = yes)
    or   (tit-ap.tipo = 10 and tt-param.provisao  = yes)
    or   (tit-ap.tipo = 3  and tt-param.considera = yes))
    and   tit-ap.dt-vencimen  <= da-venc-xxx
    and   tit-ap.dt-vencimen  >= da-a-vencer  
    and   tit-ap.dt-transacao <= tt-param.fim-per
    and  (tt-param.fasb        = 2 
    or    tt-param.fasb        = 1) no-lock
    break by tit-ap.ep-codigo
          by {2} tit-ap.cod-fornec
          by year(tit-ap.dt-vencimen)
          by month(tit-ap.dt-vencimen)
          by day(tit-ap.dt-vencimen)
          by tit-ap.ep-codigo
          by tit-ap.cod-estabel
          by tit-ap.cod-esp
          by tit-ap.nr-docto
          by tit-ap.parcela:

    {cdp/cd9600.i "tt-param.moeda"
                  "tt-param.da-conversao"
                  "de-calc-cotacao"
                  "return error."}
                
    {app/ap9999.i1 "tit-ap"
                   "tt-param.moeda"}

    if  first-of({6}) then
        assign l-disp-forn   = yes
               l-emitiu-mes  = no
               l-emitiu-forn = no.
    {5}

    if  tt-param.fasb <> 2 then do:
        if  tit-ap.tipo <> 3 and tit-ap.tipo <> 10 then   /* Carlos - src12112 - Tratamento de Provisäes */
            assign de-saldo  = de-calc-valor-saldo 
                   de-saldo1 = de-calc-valor-saldo 
                   de-orig   = de-calc-vl-original 
                   de-orig1  = de-calc-vl-original.
        else
            assign de-saldo = de-calc-valor-saldo
                   de-orig  = de-calc-vl-original.
    end.
    else do:
        if  tit-ap.tipo <> 3 and tit-ap.tipo <> 10 then do:   /* Carlos - src12112 - Tratamento de Provisäes */
            assign de-saldo  = de-calc-valor-saldo
                   de-saldo1 = de-calc-valor-saldo
                   de-orig   = de-calc-vl-original
                   de-orig1  = de-calc-vl-original.
        end.
        else
            assign de-saldo = de-calc-valor-saldo
                   de-orig  = de-calc-vl-original.
    end.

    if  tt-param.fasb = 2 then do:
        if  tit-ap.tipo = 2 then do:
            assign de-dolar = tit-ap.vl-sal-fasb / 100.
        end.
        else do:
            if  param-fasb.tipo-calculo = 0 then do:
                assign de-dolar = 1.
                if  param-fasb.moeda-fasb <> 0 then do:
                    find cotacao
                        where cotacao.mo-codigo   = param-fasb.moeda-fasb
                        and   cotacao.ano-periodo = string(year(tit-ap.dt-emissao)) + string(month(tit-ap.dt-emissao),"99")
                        and   cotacao.cotacao[int(day(tit-ap.dt-emissao))] <> 0 no-lock no-error.
                    if  avail cotacao then
                        assign de-dolar = cotacao.cotacao[int(day(tit-ap.dt-emissao))].
                    if  de-dolar = 0 then do:
                        run utp/ut-msgs.p (input "msg",
                                           input 1175,
                                           input string(param-fasb.moeda-fasb) + "~~" + string(tit-ap.dt-emissao)).
                        put skip return-value format "x(80)" skip.
                        assign de-dolar = 1.
                    end.
                end.
                assign de-dolar = de-dolar * (tit-ap.vl-sal-fasb /  tit-ap.vl-orig-fasb).
            end.
            else
                assign de-dolar = tit-ap.vl-sal-fasb / 100.
        end.
        assign de-saldo  = round(de-saldo / de-dolar,2)
               de-orig   = round(de-orig  / de-dolar,2)
               de-saldo1 = de-saldo
               de-orig1  = de-orig.
    end.
    else
        assign de-dolar = 1.

    assign de-sal-fasb = de-saldo.

    if  tit-ap.tipo <> 2 then do:
        if  tit-ap.vl-original <> tit-ap.valor-saldo then do:
            mov-block:
            for each mov-ap  use-index codigo
                where mov-ap.ep-codigo   = tit-ap.ep-codigo
                and   mov-ap.cod-estabel = tit-ap.cod-estabel
                and   mov-ap.cod-esp     = tit-ap.cod-esp
                and   mov-ap.serie       = tit-ap.serie
                and   mov-ap.nr-docto    = tit-ap.nr-docto
                and   mov-ap.parcela     = tit-ap.parcela
                and   mov-ap.cod-fornec  = tit-ap.cod-fornec
                and   mov-ap.transacao <> 17
                and   mov-ap.transacao <> 18
                and   mov-ap.dt-transacao > tt-param.fim-per no-lock:

                {app/ap9999.i2 "mov-ap"
                               "tt-param.moeda"
                               "tit-ap"}

                if  (mov-ap.transacao = 2 or   mov-ap.transacao = 5 
                or   mov-ap.transacao = 3 or  (mov-ap.transacao = 6 and mov-ap.lancamento = 1)) then do:
                    assign de-vl-mov-fasb = mov-ap.vl-mov-fasb.
                    
                    if  mov-ap.transacao = 5 and mov-ap.lancamento = 1 then do:
                        if  tt-param.fasb = 1 then
                            assign de-saldo = de-saldo - de-calc-valor-mov.
                        else 
                            assign de-saldo = de-saldo - mov-ap.vl-mov-fasb.
                        assign de-sal-fasb = de-sal-fasb - de-calc-valor-mov.
                    end.                                        
                    else do:
                        if  mov-ap.transacao = 5 and mov-ap.lancamento = 2 then do:
                           if  tt-param.fasb = 1 then
                               assign de-saldo = de-saldo + de-calc-valor-mov.
                           else 
                               assign de-saldo = de-saldo + mov-ap.vl-mov-fasb.
                           assign de-sal-fasb = de-sal-fasb + de-calc-valor-mov.
                        end.
                        else do:
                            if  tt-param.fasb = 1 then
                                assign de-saldo = de-saldo + de-calc-valor-mov.
                            else 
                                assign de-saldo = de-saldo + de-vl-mov-fasb.
                            assign de-sal-fasb = de-sal-fasb + de-calc-valor-mov.
                        end.
                    end.
                end.
                if  mov-ap.transacao = 8 and tt-param.fasb = 2 then
                    assign de-saldo = de-saldo + de-calc-valor-mov + de-calc-valor-juros.
            end.
        end.

        if  de-saldo > 0 then do:
            if  tit-ap.tipo = 1 or  tit-ap.tipo = 8 then
                assign de-tot-nor   = de-tot-nor  + de-orig
                       de-tot-nor1  = de-tot-nor1 + de-saldo
                       de-orig1 = de-orig
                       de-saldo1    = de-saldo.
            if  tit-ap.tipo = 3 then
                assign de-tot-pre   = de-tot-pre  + de-orig
                       de-tot-pre1  = de-tot-pre1 + de-saldo
                       de-saldo2    = de-saldo
                       de-orig2 = de-orig.

            /* Carlos - src12112 - Tratamento de Provisäes */
            if tit-ap.tipo = 10 then
                assign de-tot-pro  = de-tot-pro  + de-orig
                       de-tot-pro1 = de-tot-pro1 + de-saldo
                       de-saldo3   = de-saldo
                       de-orig3    = de-orig.
            /* ------------------------------------------- */

            assign c-dbcr     = c-cred
                   c-dbcr1    = c-cred
                   de-normal  = de-normal  + de-orig
                   de-normal1 = de-normal1 + de-saldo
                   de-fornec  = de-fornec  + de-orig
                   de-fornec1 = de-fornec1 + de-saldo.

            {app/ap0703.i5}
          
            else do:
                 {app/ap0703.i8}
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
            and   mov-ap.fornec-ant = tit-ap.cod-fornec
            and   mov-ap.transacao <> 17
            and   mov-ap.transacao <> 18
            and   mov-ap.dt-transacao > tt-param.fim-per no-lock:

            {app/ap9999.i2 "mov-ap"
                           "tt-param.moeda"
                           "tit-ap"}

            if   (mov-ap.transacao   = 2 or  mov-ap.transacao = 3)
            and ((mov-ap.vl-antecip  > 0 and tt-param.fasb    = 1)
            or   (mov-ap.vl-ant-fasb > 0 and tt-param.fasb    = 2)) then do:
                assign de-vl-ant-fasb = mov-ap.vl-mov-fasb.
                if  mov-ap.dt-trans > tt-param.fim-per then
                    if  tt-param.fasb = 1 then
                        assign de-saldo = de-saldo + de-calc-vl-antecip.
                    else 
                        assign de-saldo = de-saldo + de-vl-ant-fasb.
            end.
            if  mov-ap.dt-trans  > tt-param.fim-per 
            and mov-ap.transacao = 8 
            and tt-param.fasb    = 2 then
                assign de-saldo = de-saldo + de-calc-valor-mov + de-calc-valor-juros.
        end.
        
        mov-block:
        for each mov-ap use-index codigo
            where mov-ap.ep-codigo  = tit-ap.ep-codigo
            and   mov-ap.cod-est    = tit-ap.cod-est
            and   mov-ap.cod-esp    = tit-ap.cod-esp
            and   mov-ap.serie      = tit-ap.serie
            and   mov-ap.nr-docto   = tit-ap.nr-docto
            and   mov-ap.parcela    = tit-ap.parcela
            and   mov-ap.cod-fornec = tit-ap.cod-fornec
            and   (mov-ap.transacao = 5
            or    mov-ap.transacao  = 3
            or    mov-ap.transacao  = 8)
            and   mov-ap.dt-transacao > tt-param.fim-per no-lock:

            {app/ap9999.i2 "mov-ap"
                           "tt-param.moeda"
                           "tit-ap"}

            assign de-vl-ant-fasb = mov-ap.vl-mov-fasb.

            if  mov-ap.dt-trans > tt-param.fim-per then do:
                if  mov-ap.transacao = 5 then
                    if  mov-ap.lancamento = 1 then
                        if  tt-param.fasb = 1 then
                            assign de-saldo = de-saldo + de-calc-valor-mov.
                        else 
                            assign de-saldo = de-saldo + de-vl-ant-fasb.
                    else
                        if  tt-param.fasb = 1 then
                            assign de-saldo = de-saldo - de-calc-valor-mov.
                        else 
                            assign de-saldo = de-saldo - de-vl-ant-fasb.
        
                if  mov-ap.transacao = 3 and tt-param.fasb = 2 then
                    assign de-saldo = de-saldo + de-vl-ant-fasb.
       
                if  mov-ap.transacao = 8 and tt-param.fasb = 2 then
                     assign de-saldo = de-saldo - de-calc-valor-mov + de-calc-valor-juros.
            end.
        end.
 
        if  de-saldo > 0 then do:
            assign c-dbcr      = c-deb
                   c-dbcr1     = c-deb
                   de-tot-ant  = de-tot-ant  + de-orig
                   de-tot-ant1 = de-tot-ant1 + de-saldo
                   de-tot-ant2 = de-orig
                   de-tot-ant3 = de-saldo
                   de-antec    = de-antec    + de-orig
                   de-antec1   = de-antec1   + de-saldo
                   de-forant   = de-forant   + de-orig
                   de-forant1  = de-forant1  + de-saldo.
            {app/ap0703.i8}            
        end.
    end.
    if  de-saldo > 0 then do:
        if  l-disp-forn then do:
            {3}
            {4}
            {8}
            disp c-forn
                 {6}
                 {9}
                 with frame f-codigo{7}.
            if  tt-param.classifica < 3
            or  tt-param.classifica = 4 then
                disp emitente.nome-abrev @ emitente.nome-emit
                with frame f-codigo{7}.
            else
                disp c-forn
                     emitente.nome-emit with frame f-codigo{7}.
            assign l-disp-forn   = no
                   l-emitiu-mes  = yes
                   l-emitiu-forn = yes.
        end.
        assign c-docto = fill(" ", 16 - length(tit-ap.nr-docto)) + tit-ap.nr-docto.
        
        if  line-counter > 61 then
            assign l-item = true.
                        
        if  l-item then do:
            disp tit-ap.referencia
                 tit-ap.cod-estabel
                 tit-ap.cod-esp
                 tit-ap.serie
                 c-docto
                 tit-ap.parcela
                 {adinc/i01ad165.i 04 tit-ap.transacao} @ c-trans 
                 tit-ap.dt-emissao
                 tit-ap.dt-vencimen
                 tit-ap.moeda
                 de-orig
                 de-saldo
                 c-dbcr
                 c-dbcr1 with frame f-item.
            down with frame f-item.
            assign l-item = false.
        end.
        else do:
            disp tit-ap.referencia
                 tit-ap.cod-estabel
                 tit-ap.cod-esp
                 tit-ap.serie
                 c-docto
                 tit-ap.parcela
                 {adinc/i01ad165.i 04 tit-ap.transacao} @ c-trans 
                 tit-ap.dt-emissao
                 tit-ap.dt-vencimen
                 tit-ap.moeda
                 de-orig
                 de-saldo
                 c-dbcr
                 c-dbcr1 with frame f-item2.
                 down with frame f-item2.
        end.
        
        if  line-counter > 61 then
            assign l-item = true.

        if  (tt-param.lista  and tit-ap.tipo = 3)
        or  (tt-param.lista1 and tit-ap.tipo <> 3)
        or  (tt-param.lista  and tt-param.lista1) then do :
            find first mov-ap  use-index codigo
                 where mov-ap.ep-codigo    = tit-ap.ep-codigo
                 and   mov-ap.cod-estabel  = tit-ap.cod-estabel
                 and   mov-ap.cod-esp      = tit-ap.cod-esp
                 and   mov-ap.serie        = tit-ap.serie
                 and   mov-ap.nr-docto     = tit-ap.nr-docto
                 and   mov-ap.parcela      = tit-ap.parcela
                 and   mov-ap.cod-fornec   = tit-ap.cod-fornec
                 and   mov-ap.transacao    = 1
                 no-lock no-error.
            if avail mov-ap then
               if mov-ap.historico <> "" then do:
                  disp mov-ap.historico 
                       with frame f-historico.
                  down with frame f-historico.
               end.
        end.
    end.

    if  last-of(month(tit-ap.dt-vencimen))
    and l-emitiu-mes then do:
        assign de-tot-mes   = de-normal  - de-antec
               de-tot-mes1  = de-normal1 - de-antec1
               c-tipo       = ""
               c-tipo1      = "".

        if  de-tot-mes > 0 then
            assign c-tipo     = c-cred.
        else
            if  de-tot-mes < 0 then
                assign de-tot-mes = de-tot-mes * (-1)
                       c-tipo     = c-deb.
        if  de-tot-mes1 > 0 then
            assign c-tipo1     = c-cred.
        else
            if  de-tot-mes1 < 0 then
                assign de-tot-mes1 = de-tot-mes1 * (-1)
                       c-tipo1     = c-deb.

        if  de-tot-mes > 0 or de-tot-mes1 > 0 then do:
            disp c-mes
                 de-tot-mes
                 c-tipo
                 de-tot-mes1
                 c-tipo1 with frame f-mes.
            down with frame f-mes.
            
            if  line-counter > 61 then
                assign l-item = true.
        end.

        assign de-tot-mes  = 0
               de-tot-mes1 = 0
               de-normal   = 0
               de-normal1  = 0
               de-antec    = 0
               de-antec1   = 0.
    end.
    if  last-of({6})
    and l-emitiu-forn then do:
        assign l-emitiu-forn = no
               l-emitiu-mes  = no
               de-tot-forn   = de-fornec  - de-forant
               de-tot-forn1  = de-fornec1 - de-forant1
               c-tipo        = ""
               c-tipo1       = "".

        if  de-tot-forn > 0 then
            assign c-tipo = c-cred.

        if  de-tot-forn < 0 then
            assign c-tipo      = c-deb
                   de-tot-forn = de-tot-forn * (-1).

        if  de-tot-forn1 > 0 then
            assign c-tipo1      = c-cred.

        if  de-tot-forn1 < 0 then
            assign de-tot-forn1 = de-tot-forn1 * (-1)
                   c-tipo1      = c-deb.

        disp c-fornec
             de-tot-forn
             c-tipo
             de-tot-forn1
             c-tipo1 with frame f-fornec.
       
        assign de-tot-mes   = 0
               de-tot-mes1  = 0
               de-tot-forn  = 0
               de-tot-forn1 = 0
               de-normal    = 0
               de-normal1   = 0
               de-antec     = 0
               de-antec1    = 0
               de-fornec    = 0
               de-fornec1   = 0
               de-forant    = 0
               de-forant1   = 0.
    end.
    assign de-tot-ger  = de-tot-nor  + de-tot-pre  + de-tot-pro  - de-tot-ant
           de-tot-ger1 = de-tot-nor1 + de-tot-pre1 + de-tot-pro1 - de-tot-ant1
           de-tot-mes  = 0
           c-tipo      = ""
           c-tipo1     = "".

    if  de-tot-ger > 0 then
        assign c-tipo     = c-cred.

    if  de-tot-ger < 0 then
        assign de-tot-ger = de-tot-ger * (-1)
               c-tipo     = c-deb.

    if  de-tot-ger1 > 0 then
        assign c-tipo1 = c-cred.

    if  de-tot-ger1 < 0 then
        assign de-tot-ger1 = de-tot-ger1 * (-1)
               c-tipo1     = c-deb.

    if  de-tot-nor  = 0 then assign c-tip  = "".
    if  de-tot-nor1 = 0 then assign c-tip1 = "".
    if  de-tot-pre  = 0 then assign c-tpo  = "".
    if  de-tot-pre1 = 0 then assign c-tpo1 = "".
    /* Carlos - src12112 - Tratamento de Provisäes */
    if de-tot-pro  = 0 then assign c-tpro  = "".
    if de-tot-pro1 = 0 then assign c-tpro1 = "".
    /* ------------------------------------------- */
    if  de-tot-ant  = 0 then assign c-tp   = "".
    if  de-tot-ant1 = 0 then assign c-tp1  = "".
  i-soma = i-soma + 1.
  run pi-acompanhar in h-acomp(input c-mov + ":":U + string(i-soma, "999999")).
end.


disp c-normal
     de-tot-nor 
     c-tip
     de-tot-nor1 
     c-tip1 
     c-previsao
     de-tot-pre  
     c-tpo
     de-tot-pre1 
     c-tpo1
     with frame f-geral.

if tt-param.provisao = yes then
    disp c-provisao
         de-tot-pro
         c-tpro
         de-tot-pro1
         c-tpro1
         with frame f-geral-prov.

disp c-antecipa
     de-tot-ant  
     c-tp
     de-tot-ant1 
     c-tp1
     c-geral
     de-tot-ger  
     c-tipo
     de-tot-ger1 
     c-tipo1
     with frame f-geral2.

assign de-tot-ger  = 0
       de-tot-ger1 = 0
       de-tot-nor  = 0
       de-tot-nor1 = 0
       de-tot-pre  = 0
       de-tot-pre1 = 0
       de-tot-ant  = 0
       de-tot-ant1 = 0.

assign de-tot-pro  = 0
       de-tot-pro1 = 0.

if  tt-param.chave = 1 then do:
    {app/ap0703.i6}
    if  de-total <> 0 then
        assign de-per-30   = (de-ven-30   / de-total)  * 100
               de-per-60   = (de-ven-60   / de-total)  * 100
               de-per-90   = (de-ven-90   / de-total)  * 100
               de-per-120  = (de-ven-120  / de-total)  * 100
               de-per-999  = (de-ven-999  / de-total)  * 100
               de-per-tot  = (de-total    / de-total)  * 100.

    if  de-total1 <> 0 then
        assign de-per1-30  = (de-ven1-30  / de-total1) * 100
               de-per1-60  = (de-ven1-60  / de-total1) * 100
               de-per1-90  = (de-ven1-90  / de-total1) * 100
               de-per1-120 = (de-ven1-120 / de-total1) * 100
               de-per1-999 = (de-ven1-999 / de-total1) * 100
               de-per-tot1 = (de-total1   / de-total1) * 100.

    page.
    put skip(5).

    disp c-resumo1
         c-30-ven 
         de-ven-30  
         de-per-30
         c-60-ven         
         de-ven-60  
         de-per-60
         c-90-ven 
         de-ven-90  
         de-per-90 
         c-91-ven 
         de-ven-999 
         de-per-999 
         c-total
         de-total  
         de-per-tot
         with frame f-vencidos.

    put skip(8).
    disp c-resumo2
         c-30-aven  
         de-ven1-30  
         de-per1-30
         c-60-aven  
         de-ven1-60  
         de-per1-60  
         c-90-aven  
         de-ven1-90  
         de-per1-90  
         c-120-aven 
         de-ven1-120 
         de-per1-120 
         c-121-aven 
         de-ven1-999 
         de-per1-999 
         c-total
         de-total1 
         de-per-tot1
         with frame f-vencer.

    assign de-total-gr = de-total1 + de-total.
    put skip(3).
    disp c-ven1
         de-total-gr 
         with frame f-total-gr.

    assign de-per-30   = 0
           de-per-60   = 0
           de-per-90   = 0
           de-per-120  = 0
           de-per-999  = 0
           de-per-tot  = 0
           de-per1-30  = 0
           de-per1-60  = 0
           de-per1-90  = 0
           de-per1-120 = 0
           de-per1-999 = 0
           de-per-tot1 = 0
           tt-param.dias = 0
           de-ven-30   = 0
           de-ven-60   = 0
           de-ven-90   = 0
           de-ven-120  = 0
           de-ven-999  = 0
           de-total    = 0
           de-ven1-30  = 0
           de-ven1-60  = 0
           de-ven1-90  = 0
           de-ven1-120 = 0
           de-ven1-999 = 0
           de-total1   = 0
           de-total-gr = 0
           de-saldo    = 0
           de-orig = 0
           de-fator    = 0
           c-30-aven   = ""
           c-60-aven   = ""
           c-90-aven   = ""
           c-120-aven  = ""
           c-121-aven  = ""
           c-30-ven    = ""
           c-60-ven    = ""
           c-90-ven    = ""
           c-91-ven    = "".
end.
else do:
    for each w-grupo-for no-lock by w-grupo-for.grupo:
        if  w-grupo-for.tot <> 0 then
            assign de-per-30   = (w-grupo-for.ven-30  / w-grupo-for.tot)  * 100
                   de-per-60   = (w-grupo-for.ven-60  / w-grupo-for.tot)  * 100
                   de-per-90   = (w-grupo-for.ven-90  / w-grupo-for.tot)  * 100
                   de-per-120  = (w-grupo-for.ven-120 / w-grupo-for.tot)  * 100
                   de-per-999  = (w-grupo-for.ven-999 / w-grupo-for.tot)  * 100
                   de-per-tot  = (w-grupo-for.tot     / w-grupo-for.tot)  * 100.

        if  w-grupo-for.tot1 <> 0 then
            assign de-per1-30  = (w-grupo-for.ven1-30  / w-grupo-for.tot1) * 100
                   de-per1-60  = (w-grupo-for.ven1-60  / w-grupo-for.tot1) * 100
                   de-per1-90  = (w-grupo-for.ven1-90  / w-grupo-for.tot1) * 100
                   de-per1-120 = (w-grupo-for.ven1-120 / w-grupo-for.tot1) * 100
                   de-per1-999 = (w-grupo-for.ven1-999 / w-grupo-for.tot1) * 100
                   de-per-tot1 = (w-grupo-for.tot1   / w-grupo-for.tot1) * 100.
        page.
        do:
            {app/ap0703.i6}
            find first grupo-fornec
                where grupo-fornec.cod-gr-forn = w-grupo-for.grupo
                no-lock no-error.
            if  avail grupo-fornec then
                disp c-grupo
                     w-grupo-for.grupo
                     grupo-fornec.descricao
                     with frame f-grupo.
            else
                disp c-grupo
                     w-grupo-for.grupo
                     c-desco @ grupo-fornec.descricao
                     with frame f-grupo.

            disp c-resumo1
                 w-grupo-for.ven-30    @  de-ven-30
                 de-per-30 
                 w-grupo-for.ven-60    @  de-ven-60
                 de-per-60 
                 w-grupo-for.ven-90    @  de-ven-90
                 de-per-90 
                 w-grupo-for.ven-90    @  de-ven-90
                 w-grupo-for.ven-120   @  de-ven-120
                 de-per-120
                 w-grupo-for.ven-999   @  de-ven-999
                 de-per-999 
                 c-total
                 w-grupo-for.tot       @ de-total  
                 de-per-tot
                 with frame f-vencidos.

            put skip(3).
            disp c-resumo2
                 w-grupo-for.ven1-30     @  de-ven1-30
                 de-per1-30 
                 w-grupo-for.ven1-60     @  de-ven1-60
                 de-per1-60  
                 de-per1-90  
                 w-grupo-for.ven1-120    @  de-ven1-120
                 de-per1-120 
                 w-grupo-for.ven1-999    @  de-ven1-999
                 de-per1-999
                 c-total
                 de-per-tot1
                 w-grupo-for.tot1        @  de-total1 
                 with frame f-vencer.

            put skip(2).
            disp c-original
                 c-saldo
                 c-normal
                 w-grupo-for.nor-gr   @ de-tot-nor
                 w-grupo-for.nor-gr1  @ de-tot-nor1
                 c-previsao
                 w-grupo-for.pre-gr   @ de-tot-pre
                 w-grupo-for.pre-gr1  @ de-tot-pre1
                 c-antecipa
                 w-grupo-for.ant-gr   @ de-tot-ant
                 w-grupo-for.ant-gr1  @ de-tot-ant1
                 with frame f-geral-forn.

            if tt-param.provisao = yes then
                 disp c-previsao
                      w-grupo-for.pre-gr   @ de-tot-pre
                      w-grupo-for.pre-gr1  @ de-tot-pre1
                      with frame f-geral-forn-prov.
        end.

        assign de-per-30   = 0
               de-per-60   = 0
               de-per-90   = 0
               de-per-120  = 0
               de-per-999  = 0
               de-per-tot  = 0
               de-per1-30  = 0
               de-per1-60  = 0
               de-per1-90  = 0
               de-per1-120 = 0
               de-per1-999 = 0
               de-per-tot1 = 0
               tt-param.dias = 0
               de-saldo    = 0
               de-orig = 0
               de-fator    = 0
               c-30-aven   = ""
               c-60-aven   = ""
               c-90-aven   = ""
               c-120-aven  = ""
               c-121-aven  = ""
               c-30-ven    = ""
               c-60-ven    = ""
               c-90-ven    = ""
               c-91-ven    = "".
    end.
end.

/* AP0703.I3 */
