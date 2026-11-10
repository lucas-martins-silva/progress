/****************************************************************************
***
*** app/ap0706b.i3 - pi-classif2-moeda1.
***
****************************************************************************/

class-block:
do  on error  undo class-block, return error
    on endkey undo class-block, return error
    on stop   undo class-block, return error:

    for each grupo-fornec
        where grupo-fornec.cod-gr-forn >= tt-param.grp-forn-ini
        and   grupo-fornec.cod-gr-forn <= tt-param.grp-forn-fim no-lock
        break by grupo-fornec.cod-gr-forn:

        if  first-of(grupo-fornec.cod-gr-forn) then do:
            disp grupo-fornec.cod-gr-forn
                 grupo-fornec.descricao with frame f-grupo.
        end.

        for each emitente use-index grupo-fornec
            where emitente.cod-gr-forn   = grupo-fornec.cod-gr-forn
            and   emitente.cod-emitente >= tt-param.fornec-ini
            and   emitente.cod-emitente <= tt-param.fornec-fim
            and   emitente.identific    <> 1 no-lock:

            assign l-nao-entrou = yes
                   l-entrou     = yes
                   i-emitente   = emitente.cod-emitente
                   i-cod-forn   = ?.

            run pi-acompanhar in h-acomp (input (c-text-acomp + string(emitente.cod-emitente))).

            if  emitente.cod-emitente = 0 then do:
                {utp/ut-liter.i Desconhecido * R}
                disp emitente.cod-emitente @ mov-ap.cod-fornec
                     trim(return-value) @ emitente.nome-emit with frame f-resumo.
            end.

            mov-block:
            for each mov-ap use-index codigo
                where mov-ap.ep-codigo     = i-ep-codigo-usuario
                and   mov-ap.cod-fornec    = emitente.cod-emitente
                and   mov-ap.cod-estabel  >= tt-param.estab-ini
                and   mov-ap.cod-estabel  <= tt-param.estab-fim
                and   mov-ap.cod-esp      >= tt-param.espec-ini
                and   mov-ap.cod-esp      <= tt-param.espec-fim
                and   mov-ap.dt-transacao >= tt-param.dt-transac-ini
                and   mov-ap.dt-transacao <= tt-param.dt-transac-fim
                and  (mov-ap.transacao     = 3
                or    mov-ap.transacao     = 4)
                and   mov-ap.tipo         <> 4
                and   mov-ap.tipo         <> 5 
                and  (mov-ap.tipo         <> 7
                 or   tt-param.l-lista-op) no-lock
                by mov-ap.ep-codigo
                by mov-ap.cod-fornec
                by mov-ap.dt-transacao
                by mov-ap.cod-estabel
                by mov-ap.cod-esp
                by mov-ap.serie
                by mov-ap.nr-docto
                by mov-ap.parcela:

                if mov-ap.transacao = 5 and mov-ap.tipo = 10 and mov-ap.contabiliza = false then
                    next.

                find first tit-ap of mov-ap no-lock no-error.
                if  avail tit-ap then do:
                    {app/ap9999.i2 mov-ap tt-param.moeda tit-ap}
                end.
                else do:
                    {app/ap9999.i2 mov-ap tt-param.moeda mov-ap}
                end.
                            
                if  mov-ap.transacao = 3 then
                    assign c-tipo     = {adinc/i01ad059.i 04 1}
                           de-tot-pef = de-tot-pef - de-calc-valor-mov.
                else
                    assign c-tipo     = {adinc/i01ad059.i 04 2}
                           de-tot-pef = de-tot-pef + de-calc-valor-mov.
                           
            end.

            if  emitente.cod-emitente = 0 then do:
                if  tt-param.l-ficha = yes then
                    page.
                else
                    put skip(1).
            end.

            {app/ap0706.i6 "and tit-ap.cod-fornec = emitente.cod-emitente"
                           codigo
                           tit-ap.cod-fornec}

            mov-block:
            for each mov-ap use-index codigo no-lock
                where mov-ap.ep-codigo     = i-ep-codigo-usuario
                and   mov-ap.cod-fornec    = emitente.cod-emitente
                and   mov-ap.cod-estabel  >= tt-param.estab-ini
                and   mov-ap.cod-estabel  <= tt-param.estab-fim
                and   mov-ap.cod-esp      >= tt-param.espec-ini
                and   mov-ap.cod-esp      <= tt-param.espec-fim
                and   mov-ap.dt-transacao >= tt-param.dt-transac-ini
                and   mov-ap.dt-transacao <= tt-param.dt-transac-fim
                and  (mov-ap.cod-fornec  > 0
                and   mov-ap.transacao  <> 8
                and   mov-ap.transacao  <> 9
                and   mov-ap.transacao  <> 10
                and   mov-ap.transacao  <> 11
                and   mov-ap.transacao  <> 12
                and   mov-ap.transacao  <> 13
                and   mov-ap.transacao  <> 14
                and   mov-ap.transacao  <> 15)
                and   mov-ap.tipo       <> 4
                and   mov-ap.tipo       <> 5
                break by mov-ap.ep-codigo
                      by mov-ap.cod-fornec
                      by mov-ap.dt-transacao
                      by mov-ap.cod-estabel
                      by mov-ap.cod-esp
                      by mov-ap.serie
                      by mov-ap.nr-docto
                      by mov-ap.parcela:

                find espec-ap
                    where espec-ap.cod-esp = mov-ap.cod-esp no-lock no-error.
                assign i-tipo-esp = if  avail espec-ap then espec-ap.tipo else 0.

                if  tt-param.l-prev-saldo = no
                and mov-ap.transacao = 1 and (i-tipo-esp = 3 or i-tipo-esp = 10) then
                    assign l-nao-entrou = no.
                            
                find first tit-ap of mov-ap no-lock no-error.
                if  avail tit-ap then do:
                    {app/ap9999.i2 mov-ap tt-param.moeda tit-ap}
                end.
                else do:
                    {app/ap9999.i2 mov-ap tt-param.moeda mov-ap}
                end.
                                
                /* éltimo Fornecedor */

                run pi-ultimo-fornecedor-i3.

                /* Primeiro Fornecedor */

                run pi-primeiro-fornecedor-i3.

                if  tt-param.l-espec-ctbl = yes and mov-ap.transacao <> 7
                and mov-ap.transacao <> 3 and mov-ap.transacao <> 4 then
                    if  not avail espec-ap or espec-ap.contabiliza = no then
                        next mov-block.

                if  tt-param.l-prev-saldo = no
                and mov-ap.transacao = 1 and (i-tipo-esp = 3 or i-tipo-esp = 10) then
                    next mov-block.

                /* Demais Registros */

                run pi-demais-registros-i3.  
                
                assign l-entrou     = no
                       l-nao-entrou = no.
                       
            end.

            if  l-nao-entrou = no then do:
                assign i-prazo      = if  de-pr-total <> 0 then
                                          de-prazo / de-pr-total
                                      else 0
                       i-atraso     = if  de-at-total <> 0 then
                                          de-atraso / de-at-total
                                      else 0
                       de-tot-atual = de-tot-atual + de-total-cr - de-total-db.

                do  with frame f-resumo:
                    if  de-tot-saldo >= 0 then do:
                        disp {adinc/i01ad059.i 04 2} @ c-tipo.
                        assign de-ger-saldo-cr    = de-ger-saldo-cr + de-tot-saldo
                               de-tot-gr-saldo-cr = de-tot-gr-saldo-cr + de-tot-saldo.
                    end.
                    else do:
                         disp {adinc/i01ad059.i 04 1} @ c-tipo.
                         assign de-tot-saldo       = de-tot-saldo * (- 1)
                                de-ger-saldo-db    = de-ger-saldo-db + de-tot-saldo
                                de-tot-gr-saldo-db = de-tot-gr-saldo-db + de-tot-saldo.
                    end.

                    if  de-tot-atual >= 0 then do:
                        disp {adinc/i01ad059.i 04 2} @ c-lancto.
                        assign de-ger-atual-cr    = de-ger-atual-cr + de-tot-atual
                               de-tot-gr-atual-cr = de-tot-gr-atual-cr + de-tot-atual.
                    end.
                    else do:
                        disp {adinc/i01ad059.i 04 1} @ c-lancto.
                        assign de-tot-atual       = de-tot-atual * (- 1)
                               de-ger-atual-db    = de-ger-atual-db + de-tot-atual
                               de-tot-gr-atual-db = de-tot-gr-atual-db + de-tot-atual.
                    end.

                    disp i-prazo
                         de-tot-saldo
                         i-atraso
                         de-tot-atual.

                    assign i-tot-gr-prazo  = i-tot-gr-prazo + i-prazo
                           i-tot-gr-atraso = i-tot-gr-atraso + i-atraso.
                    down.
                end.

                assign de-at-geral  = de-at-geral + de-at-total
                       de-pr-geral  = de-pr-geral + de-pr-total
                       de-at-data   = de-at-data  + de-atraso
                       de-pr-data   = de-pr-data  + de-prazo
                       de-pr-total  = 0
                       de-at-total  = 0
                       de-atraso    = 0
                       de-prazo     = 0
                       de-tot-cr    = 0
                       de-tot-db    = 0
                       de-total-cr  = 0
                       de-total-db  = 0
                       de-tot-saldo = 0
                       de-tot-atual = 0
                       l-entrou     = yes.
            end.
        end.

        if  last-of(grupo-fornec.cod-gr-forn) and i-emitente > 0 then do:
            disp i-tot-gr-prazo
                 i-tot-gr-atraso
                 with frame f-total-grupo.

            if  de-tot-gr-saldo-cr > de-tot-gr-saldo-db then do:
                assign de-tot-gr-saldo = de-tot-gr-saldo-cr - de-tot-gr-saldo-db.
                disp de-tot-gr-saldo
                     {adinc/i01ad059.i 04 2} @ c-tipo
                     with frame f-total-grupo.
            end.
            else do:
                assign de-tot-gr-saldo = de-tot-gr-saldo-db - de-tot-gr-saldo-cr.
                disp de-tot-gr-saldo
                     {adinc/i01ad059.i 04 1} @ c-tipo
                     with frame f-total-grupo.
            end.

            if  de-tot-gr-atual-cr > de-tot-gr-atual-db then do:
                assign de-tot-gr-atual = de-tot-gr-atual-cr - de-tot-gr-atual-db.
                disp de-tot-gr-atual
                     {adinc/i01ad059.i 04 2} @ c-lancto
                     with frame f-total-grupo.
            end.
            else do:
                 assign de-tot-gr-atual = de-tot-gr-atual-db - de-tot-gr-atual-cr.
                 disp de-tot-gr-atual
                      {adinc/i01ad059.i 04 1} @ c-lancto
                      with frame f-total-grupo.
            end.

            put skip(1).
            assign i-tot-gr-prazo     = 0
                   i-tot-gr-atraso    = 0
                   de-tot-gr-saldo    = 0
                   de-tot-gr-atual    = 0
                   de-tot-gr-saldo-cr = 0
                   de-tot-gr-saldo-db = 0
                   de-tot-gr-atual-cr = 0
                   de-tot-gr-atual-db = 0.
        end.
        assign i-emitente = 999999.
    end.

    do  with frame f-geral:
        if  de-ger-saldo-cr >= de-ger-saldo-db then do:
            assign de-diferenca = de-ger-saldo-cr - de-ger-saldo-db.
            disp de-diferenca @ de-ger-saldo
                 {adinc/i01ad059.i 04 2} @ c-tipo.
        end.
        else do:
             assign de-diferenca = de-ger-saldo-db - de-ger-saldo-cr.
             disp de-diferenca @ de-ger-saldo
                  {adinc/i01ad059.i 04 1} @ c-tipo.
        end.

        if  de-ger-atual-cr >= de-ger-atual-db  then do:
            assign de-diferenca = de-ger-atual-cr - de-ger-atual-db.
            disp de-diferenca @ de-ger-atual
                 {adinc/i01ad059.i 04 2} @ c-lancto.
        end.
        else do:
             assign de-diferenca = de-ger-atual-db - de-ger-atual-cr.
             disp de-diferenca @ de-ger-atual
                  {adinc/i01ad059.i 04 1} @ c-lancto.
        end.

        if  de-tot-pef < 0 then
            assign de-tot-pef = de-tot-pef * -1
                   c-db-cr    = {adinc/i01ad059.i 04 1}.
        else
            assign c-db-cr = {adinc/i01ad059.i 04 2}.

        disp de-total-geral-cr
             de-total-geral-db
             de-tot-pef
             c-db-cr.
    end.
end.

/* Fim de Include */
