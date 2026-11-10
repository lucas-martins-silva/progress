/****************************************************************************
***
*** app/ap0706a.i3 - pi-classif2-moeda1.
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
            if  l-primeira-vez = yes then
                disp grupo-fornec.cod-gr-forn
                     grupo-fornec.descricao with frame f-grupo.
            else do:
                disp grupo-fornec.cod-gr-forn
                     grupo-fornec.descricao with frame f-grupo.
            end.
            assign l-primeira-vez = no.
        end.

        assign l-prim = yes.

        for each emitente use-index grupo-fornec
            where emitente.cod-gr-forn   = grupo-fornec.cod-gr-forn
            and   emitente.cod-emitente >= tt-param.fornec-ini
            and   emitente.cod-emitente <= tt-param.fornec-fim
            and   emitente.identific    <> 1 no-lock:

            assign l-nao-entrou = yes
                   l-entrou     = yes
                   i-cod-forn   = ?
                   i-emitente   = emitente.cod-emitente.

            run pi-acompanhar in h-acomp (input (c-text-acomp + string(emitente.cod-emitente))).

            if  emitente.cod-emitente = 0 then do:
                {utp/ut-liter.i Desconhecido * R}
                disp emitente.cod-emitente @ mov-ap.cod-fornec
                     trim(return-value) @ emitente.nome-emit with frame f-fornec.
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
                or    tt-param.l-lista-op)  no-lock
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
                run pi-ap9999.
                   
                assign c-tipo     = if mov-ap.transacao = 4 then {adinc/i01ad059.i 04 2}
                                    else {adinc/i01ad059.i 04 1}
                       c-trans    = {adinc/i01ad165.i 04 mov-ap.transacao}.
                                        
                assign de-tot-pef = de-tot-pef + if mov-ap.transacao = 4 then
                                    de-calc-valor-mov else (- de-calc-valor-mov).
                                
                if  mov-ap.cod-fornec = 0 then do:
                                
                    if  tt-param.l-pula-linha = yes then
                        put skip(1).
                        
                    disp mov-ap.cod-estabel
                         mov-ap.cod-esp
                         mov-ap.serie
                         mov-ap.nr-docto
                         mov-ap.parcela
                         mov-ap.portador
                         c-trans
                         mov-ap.referencia
                         mov-ap.dt-transacao
                         mov-ap.dt-vencimen
                         de-calc-valor-mov @ mov-ap.valor-mov
                         c-tipo
                         with frame f-detalhe.
                    down 1 with frame f-detalhe.
                end.
            end.

            if  emitente.cod-emitente = 0 then do:
                if  tt-param.l-ficha = yes then 
                    page.
                else 
                    put skip(1).
            end.
                                
            /* C lculo do Saldo Anterior */
          
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
                and  (mov-ap.cod-fornec    > 0
                and   mov-ap.transacao    <> 8
                and   mov-ap.transacao    <> 9
                and   mov-ap.transacao    <> 10
                and   mov-ap.transacao    <> 11
                and   mov-ap.transacao    <> 12
                and   mov-ap.transacao    <> 13
                and   mov-ap.transacao    <> 14
                and   mov-ap.transacao    <> 15)
                and   mov-ap.tipo         <> 4
                and   mov-ap.tipo         <> 5
                and  (mov-ap.tipo         <> 7
                or    tt-param.l-lista-op)
                break by mov-ap.ep-codigo
                      by mov-ap.cod-fornec
                      by mov-ap.dt-transacao
                      by mov-ap.cod-estabel
                      by mov-ap.cod-esp
                      by mov-ap.serie
                      by mov-ap.nr-docto
                      by mov-ap.parcela:
                                    
                find first tit-ap of mov-ap no-lock no-error.
                run pi-ap9999.
                                
                find espec-ap
                    where espec-ap.cod-esp = mov-ap.cod-esp no-lock no-error.
                    
                assign i-tipo-esp = if  avail espec-ap then espec-ap.tipo else 0.

                if  tt-param.l-prev-saldo = no
                and mov-ap.transacao = 1 and (i-tipo-esp = 3 or i-tipo-esp = 10) then
                    assign l-nao-entrou = no.

                /*--- éltimo Fornecedor ---*/
                if  i-cod-forn <> mov-ap.cod-fornec and i-cod-forn <> ? then do:
                    assign i-prazo      = if  de-pr-total <> 0 then
                                              de-prazo / de-pr-total
                                          else 0
                           i-atraso     = if  de-at-total <> 0 then
                                              de-atraso / de-at-total
                                          else 0
                           i-cod-forn   = ?.
                    if  mov-ap.cod-fornec <> 0 
                    and mov-ap.transacao  <> 3
                    and mov-ap.transacao  <> 4 then
                        assign de-tot-atual = de-tot-atual + de-total-cr - de-total-db.

                    do  with frame f-medio:
                        if  de-tot-saldo >= 0 then do:
                            disp {adinc/i01ad059.i 04 2} @ c-tipo.
                            assign de-ger-saldo-cr    = de-ger-saldo-cr    + de-tot-saldo
                                   de-tot-gr-saldo-cr = de-tot-gr-saldo-cr + de-tot-saldo.
                        end.
                        else do:
                            disp {adinc/i01ad059.i 04 1} @ c-tipo.
                            assign de-tot-saldo       = de-tot-saldo * (- 1)
                                   de-ger-saldo-db    = de-ger-saldo-db    + de-tot-saldo
                                   de-tot-gr-saldo-db = de-tot-gr-saldo-db + de-tot-saldo.
                        end.

                        if  de-tot-atual >= 0 then do:
                            disp {adinc/i01ad059.i 04 2} @ c-lancto.
                            assign de-ger-atual-cr    = de-ger-atual-cr    + de-tot-atual
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
                    end.
                    
                    put skip(1).

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
                           l-nao-entrou = yes
                           l-entrou     = no.
                           
                    if  tt-param.l-ficha = yes then 
                        page.
                        
               end.

               /*--- Primeiro Fornecedor ---*/
               if  i-cod-forn = ? and mov-ap.cod-fornec <> 0 then do:
                    if  l-entrou = no then do:
                        assign i-prazo      = if  de-pr-total <> 0 then
                                                  de-prazo / de-pr-total
                                              else 0
                               i-atraso     = if  de-at-total <> 0 then
                                                  de-atraso / de-at-total
                                              else 0.
                        if  mov-ap.cod-fornec <> 0 
                        and mov-ap.transacao  <> 3
                        and mov-ap.transacao  <> 4 then
                            assign de-tot-atual = de-tot-atual + de-total-cr - de-total-db.

                        do  with frame f-medio:
                            if  de-tot-saldo >= 0 then do:
                                disp {adinc/i01ad059.i 04 2} @ c-tipo.
                                assign de-ger-saldo-cr    = de-ger-saldo-cr + de-tot-saldo
                                       de-tot-gr-saldo-cr = de-tot-gr-saldo-cr + de-tot-saldo.
                            end.
                            else do:
                                disp {adinc/i01ad059.i 04 1} @ c-tipo.
                                assign de-tot-saldo   = de-tot-saldo * (- 1)
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
                                assign de-tot-atual   = de-tot-atual * (- 1)
                                   de-ger-atual-db    = de-ger-atual-db + de-tot-atual
                                   de-tot-gr-atual-db = de-tot-gr-atual-db + de-tot-atual.
                            end.

                            disp i-prazo
                                 de-tot-saldo
                                 i-atraso
                                 de-tot-atual.

                            assign i-tot-gr-prazo  = i-tot-gr-prazo + i-prazo
                                   i-tot-gr-atraso = i-tot-gr-atraso + i-atraso.
                        end.
                        
                        put skip(1).

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
                               l-nao-entrou = no.
                    end.
  
                      assign i-cod-forn = mov-ap.cod-fornec.
                      if  tt-param.l-ficha = yes and l-prim = no then
                          page.

                    disp mov-ap.cod-fornec
                         emitente.nome-emit with frame f-fornec.
                    assign l-prim = no.
               end.

                if  tt-param.l-espec-ctbl = yes and mov-ap.transacao <> 7
                and mov-ap.transacao <> 3 and mov-ap.transacao <> 4 then
                    if  not avail espec-ap or espec-ap.contabiliza = no then
                        next mov-block.

                if  tt-param.l-prev-saldo = no
                and mov-ap.transacao = 1 and (i-tipo-esp = 3 or i-tipo-esp = 10) then
                    next mov-block.

               /*--- Demais Registros ---*/
               if  mov-ap.transacao = 7 then do:
                   assign de-tot-saldo = de-tot-saldo + de-calc-valor-mov.
                   if  mov-ap.cod-fornec <> 0 
                   and mov-ap.transacao  <> 3
                   and mov-ap.transacao  <> 4 then
                       assign de-tot-atual = de-tot-atual + de-calc-valor-mov.
               end.
               else do:
                   if  (mov-ap.transacao = 1 and i-tipo-esp <> 2)
                   or  (mov-ap.transacao = 5 and mov-ap.lancamento = 1)
                   or  (mov-ap.transacao = 6 and mov-ap.lancamento = 2)
                   or  (mov-ap.transacao = 3 and i-tipo-esp = 2)
                   or   mov-ap.transacao = 4 then do:
                   
                       if  i-tipo-esp = 3 then do:
                           assign de-total-cr       = de-total-cr       + de-calc-valor-mov
                                  de-total-geral-cr = de-total-geral-cr + de-calc-valor-mov.
                       end.
                       else do:
                           if  i-tipo-esp = 2 and mov-ap.transacao = 3 then do:
                               assign de-total-cr       = de-total-cr       + de-calc-vl-antecip
                                      de-total-geral-cr = de-total-geral-cr + de-calc-vl-antecip.
                           end.
                           else do:
                               if  mov-ap.transacao <> 4 then do:
                                   assign de-total-cr       = de-total-cr       + de-calc-valor-mov
                                          de-total-geral-cr = de-total-geral-cr + de-calc-valor-mov.
                               end.
                           end.
                       end.
                       assign c-tipo = {adinc/i01ad059.i 04 2}.
                   end.

                   if  (mov-ap.transacao = 1 and i-tipo-esp = 2)
                   or  (mov-ap.transacao = 5 and mov-ap.lancamento = 2)
                   or  (mov-ap.transacao = 6 and mov-ap.lancamento = 1)
                   or  (mov-ap.transacao = 3 and i-tipo-esp <> 2 and tt-param.l-prev-saldo = yes)
                   or  mov-ap.transacao  = 2 then do:
                   
                       assign de-total-db = de-total-db + if mov-ap.transacao <> 5
                                      and mov-ap.esp-ant >= tt-param.espec-ini
                                     and mov-ap.esp-ant <= tt-param.espec-fim then
                                     de-calc-valor-mov
                                     else de-calc-valor-mov
                                     
                              de-total-geral-db = de-total-geral-db + if mov-ap.transacao <> 5
                                           and mov-ap.esp-ant >= tt-param.espec-ini
                                           and mov-ap.esp-ant <= tt-param.espec-fim then
                                           de-calc-valor-mov
                                           else de-calc-valor-mov
                                           
                              de-total-cr = de-total-cr + if mov-ap.transacao <> 5
                                     and mov-ap.transacao <> 1
                                     and mov-ap.esp-ant <> " "
                                     and mov-ap.esp-ant >= tt-param.espec-ini
                                     and mov-ap.esp-ant <= tt-param.espec-fim then
                                     de-calc-valor-mov
                                     else 0
                                     
                              de-total-geral-cr = de-total-geral-cr + if mov-ap.transacao <> 5
                                           and mov-ap.transacao <> 1
                                           and mov-ap.esp-ant <> " "
                                           and mov-ap.esp-ant >= tt-param.espec-ini
                                           and mov-ap.esp-ant <= tt-param.espec-fim then
                                           de-calc-valor-mov
                                           else 0.                        

                       assign c-tipo = {adinc/i01ad059.i 04 1}.
                   end.

                   if  mov-ap.transacao = 3
                   and tt-param.l-prev-saldo = no and i-tipo-esp <> 2 then
                       assign c-tipo = {adinc/i01ad059.i 04 1}.

                   if  mov-ap.transacao = 4 then
                       assign c-tipo = {adinc/i01ad059.i 04 2}.

                   if  mov-ap.transacao = 1 and i-tipo-esp <> 2
                   and ((i-tipo-esp <> 3 and i-tipo-esp <> 10) or tt-param.l-prev-perfil = yes) then do:
                       {app/ap0706.i2}
                   end.

                   if  mov-ap.transacao = 2
                   and (mov-ap.dt-transacao > mov-ap.dt-vencimen or tt-param.atraso-medio = 1) then do:
                       assign i-data      = mov-ap.dt-transacao - mov-ap.dt-vencimen
                              de-atraso   = fn_ajust_dec((de-atraso   + (i-data * de-calc-valor-mov)),tt-param.moeda)
                              de-at-total = de-at-total + de-calc-valor-mov.
                   end.

                   assign c-trans = {adinc/i01ad165.i 04 mov-ap.transacao}.

                   if  tt-param.l-pula-linha = yes then
                       put skip(1).
                    
                   disp mov-ap.cod-estabel
                        mov-ap.cod-esp
                        mov-ap.serie
                        mov-ap.nr-docto
                        mov-ap.parcela
                        mov-ap.portador
                        c-trans
                        mov-ap.referencia
                        mov-ap.dt-transacao
                        mov-ap.dt-vencimen
                        with frame f-detalhe.

                   disp de-calc-valor-mov @ mov-ap.valor-mov
                        c-tipo with frame f-detalhe.
                        
                   down 1 with frame f-detalhe.
                                    
                   if  tt-param.l-lista-antecip = yes then do:
                       if  mov-ap.esp-ant <> "" then do:
                           disp mov-ap.esp-ant   @ mov-ap.cod-esp
                                mov-ap.serie-ant @ mov-ap.serie
                                mov-ap.docto-ant @ mov-ap.nr-docto
                                mov-ap.parc-ant  @ mov-ap.parcela
                                with frame f-detalhe.
                           
                           find b-espec-ap no-lock
                                where b-espec-ap.cod-esp = mov-ap.cod-esp no-error.
                                
                           if  avail b-espec-ap and b-espec-ap.tipo = 1 then do:
                               find b-espec-ap no-lock
                                    where b-espec-ap.cod-esp = mov-ap.esp-ant no-error.
                               
                               if  avail b-espec-ap and b-espec-ap.tipo = 2 then do:
                                   disp de-calc-valor-mov @ mov-ap.valor-mov
                                        {adinc/i01ad059.i 04 2} @ c-tipo
                                        with frame f-detalhe.
                               end.
                           end.
                           down 1 with frame f-detalhe.
                       end.
                   end.
                end.
                assign l-entrou = no
                       l-nao-entrou = no.
            end.

            if  l-nao-entrou = no then do:
                assign i-prazo      = if  de-pr-total <> 0 then de-prazo  / de-pr-total else 0
                       i-atraso     = if  de-at-total <> 0 then de-atraso / de-at-total else 0.
                if  mov-ap.cod-fornec <> 0 
                and mov-ap.transacao  <> 3
                and mov-ap.transacao  <> 4 then
                    assign de-tot-atual = de-tot-atual + de-total-cr - de-total-db.

                do  with frame f-medio:
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
                end.
                
                put skip(1).

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
                disp   de-tot-gr-atual
                       {adinc/i01ad059.i 04 2} @ c-lancto
                       with frame f-total-grupo.
            end.
            else do:
                 assign de-tot-gr-atual = de-tot-gr-atual-db - de-tot-gr-atual-cr.
                 disp de-tot-gr-atual
                      {adinc/i01ad059.i 04 1} @ c-lancto
                      with frame f-total-grupo.
            end.

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
             assign de-diferenca = de-ger-saldo-db - de-ger-saldo-cr .
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
