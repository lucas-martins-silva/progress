/*************************************************************************
**
** Include: ap0707.i - Complemento do programa ap0707rp.p
**
*************************************************************************/

/* ImpressÆo Termo de Encerramento */
{app/ap0707.i2}

assign da-data-ant = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF .
if  first-of(t-diario-ap.dt-transacao) then do:
    assign l-movimento = yes
           da-data-ant = t-diario-ap.dt-transacao.
    run pi-acompanhar in h-acomp (input (c-des-objeto + string(t-diario-ap.dt-transacao))).
end.

if  (t-diario-ap.vl-debito        > 0 and tt-param.moeda = 1)
or  (t-diario-ap.vl-credito       > 0 and tt-param.moeda = 1)
or  (t-diario-ap.vl-deb-fasb      > 0 and tt-param.moeda = 2)
or  (t-diario-ap.vl-cred-fasb     > 0 and tt-param.moeda = 2)
or  (t-diario-ap.vl-deb-cmi       > 0 and tt-param.moeda = 3)
or  (t-diario-ap.vl-cred-cmi      > 0 and tt-param.moeda = 3)
or  (t-diario-ap.vl-deb-presente  > 0 and tt-param.moeda = 4)
or  (t-diario-ap.vl-cred-presente > 0 and tt-param.moeda = 4) then do:
    assign c-conta = string(t-diario-ap.conta-contabil,param-global.formato-conta-contabil)
           c-contra-partida = string(t-diario-ap.contra-partida,param-global.formato-conta-contabil). 

    if  (param-ap.prim-pg-diar <> param-ap.prox-pg-diar)
    or  (i-pag-diario >= param-ap.prim-pg-diar) then do:
        if  l-view = no then do:
            if not tt-param.l-imprime-contra-partida then do:
                display c-liter-1
                        c-liter-2
                        c-liter-3
                        c-liter-4
                        c-liter-5
                        c-liter-6
                        c-liter-7
                        c-liter-8
                        c-liter-9
                        c-liter-10
                        c-liter-11
                        c-liter-12
                        c-liter-13
                        c-fill-1
                        with frame f-cab.
                view frame f-cab.
            end.
            else do:
                display c-liter-1
                        c-liter-2
                        c-liter-3
                        c-liter-4
                        c-liter-5
                        c-liter-6
                        c-liter-7
                        c-liter-8
                        c-liter-9
                        c-liter-10
                        c-liter-11
                        c-liter-12
                        c-liter-13
                        c-liter-14
                        c-liter-15
                        c-fill-1
                        with frame f-cab-contra-partida.
                view frame f-cab-contra-partida.
            end.

            assign l-view = yes.
        end.

        if  l-movimento = yes then 
            disp fill("-", 80) format "x(80)" @ c-fill-1
                 t-diario-ap.dt-transacao
                 fill("-", 20) format "x(20)" @ c-fill-2
            with frame f-movimento.

        assign l-movimento = no.

        if  t-diario-ap.lancamento = 1 then
            assign de-vl-credito = 0
                   de-vl-debito  = (if  tt-param.moeda = 1 then
                                        t-diario-ap.vl-debito
                                    else
                                        if  tt-param.moeda = 2 then
                                            t-diario-ap.vl-deb-fasb
                                        else
                                            if  tt-param.moeda = 3 then
                                                t-diario-ap.vl-deb-cmi
                                            else
                                                t-diario-ap.vl-deb-presente).
        else
            assign de-vl-debito  = 0
                   de-vl-credito = (if  tt-param.moeda = 1 then
                                        t-diario-ap.vl-credito
                                    else
                                        if  tt-param.moeda = 2 then
                                            t-diario-ap.vl-cred-fasb
                                        else
                                            if  tt-param.moeda = 3 then
                                                t-diario-ap.vl-cred-cmi
                                            else
                                                t-diario-ap.vl-cred-presente).

        assign c-trans = {adinc/i01ad165.i 04 t-diario-ap.transacao}.
        assign c-docto = fill(" ", 16 - length(t-diario-ap.nr-docto)) + t-diario-ap.nr-docto.

        if  line-counter >= page-size and l-trocou-pag = no then do:
             assign i-pag-diario = i-pag-diario + 1
                    l-trocou-pag = yes
                    i-cont       = i-cont + 1.
                    {app/ap0707.i2}
         end.           
         else do:
                if line-counter < page-size then
                  assign l-trocou-pag = no.
         end.

         IF  tt-param.gera-movto-saldo THEN DO:
             CREATE tt_movimentos.
             ASSIGN tt_movimentos.ep-codigo        = t-diario-ap.ep-codigo
                    tt_movimentos.cod-estabel      = t-diario-ap.cod-estabel
                    tt_movimentos.conta-contabil   = t-diario-ap.conta-contabil
                    tt_movimentos.ct-codigo        = t-diario-ap.ct-conta
                    tt_movimentos.sc-codigo        = t-diario-ap.sc-conta
                    tt_movimentos.data             = t-diario-ap.dt-transacao
                    tt_movimentos.valor            = IF t-diario-ap.lancamento = 1 THEN t-diario-ap.vl-debito
                                                                                   ELSE t-diario-ap.vl-credito
                    tt_movimentos.num-arquivamento = c-docto
                    tt_movimentos.historico        = string(t-diario-ap.cod-estabel) + 
                                                     string(t-diario-ap.cod-esp) + 
                                                     string(t-diario-ap.serie) + 
                                                     string(t-diario-ap.cod-fornec) + 
                                                     string(t-diario-ap.nr-docto) + 
                                                     string(t-diario-ap.parcela) + 
                                                     string(t-diario-ap.historico)
                    tt_movimentos.transacao        = t-diario-ap.lancamento /* IF t-diario-ap.lancamento = 1 THEN 'D' ELSE 'C' */
                    tt_movimentos.contra-partida   = t-diario-ap.contra-partida
                    tt_movimentos.rowid-mov-ap     = t-diario-ap.rowid-mov-ap.

            if valid-handle(h-uthex64) then
                tt_movimentos.rowid-mov-ap = convert-hex-to-base64(tt_movimentos.rowid-mov-ap).


        END.

        if not tt-param.l-imprime-contra-partida then do:
            disp c-conta  when ((t-diario-ap.ct-conta <> c-ct-ant)
                 or  (da-data-ant <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF )
                 or  (t-diario-ap.sc-conta <> c-sc-ant))
                 or  (t-diario-ap.ct-conta = ct-initial
                 and t-diario-ap.sc-conta = sc-initial)
                 or  (line-counter <= 8)
                 or (line-counter <= 9 and tt-param.l-imp-histor = yes)
                 c-trans
                 t-diario-ap.referencia              @ b-mov.referencia 
                 t-diario-ap.cod-fornec              @ b-mov.cod-fornec 
                 t-diario-ap.cod-estabel             @ b-mov.cod-estabel 
                 t-diario-ap.cod-esp                 @ b-mov.cod-esp 
                 t-diario-ap.serie                   @ b-mov.serie 
                 c-docto
                 t-diario-ap.parcela                 @ b-mov.parcela 
                 t-diario-ap.nr-cheque
                 t-diario-ap.portador
                 de-vl-debito when de-vl-debito <> 0
                 de-vl-credito when de-vl-credito <> 0
                 with frame f-diario.

            down with frame f-diario.
        end.
        else do:
            if  tt-param.l-imp-histor = NO then do:
                disp c-conta 
                     c-trans
                     t-diario-ap.referencia              @ b-mov.referencia 
                     t-diario-ap.cod-fornec              @ b-mov.cod-fornec 
                     t-diario-ap.cod-estabel             @ b-mov.cod-estabel 
                     t-diario-ap.cod-esp                 @ b-mov.cod-esp 
                     t-diario-ap.serie                   @ b-mov.serie 
                     c-docto
                     t-diario-ap.parcela                 @ b-mov.parcela 
                     t-diario-ap.nr-cheque
                     t-diario-ap.portador
                     de-vl-debito when de-vl-debito <> 0
                     de-vl-credito when de-vl-credito <> 0
                     c-contra-partida
                     with frame f-diario-contra-partida.
    
                down with frame f-diario-contra-partida.
            end.
        end.
        
         if  line-counter >= page-size and l-trocou-pag = no then do:
             assign i-pag-diario = i-pag-diario + 1
                    l-trocou-pag = yes
                    i-cont       = i-cont + 1.
                    {app/ap0707.i2}
         end.           
         else do:
                if line-counter < page-size then
                  assign l-trocou-pag = no.
         end.

        if  tt-param.l-imp-histor = yes then do:
            if  t-diario-ap.transacao = 1 then do:
                find first mov-ap
                    where mov-ap.ep-codigo   = tt-param.i-ep-codigo
                      and mov-ap.cod-estabel = t-diario-ap.cod-estabel
                      and mov-ap.cod-esp     = t-diario-ap.cod-esp
                      and mov-ap.serie       = t-diario-ap.serie
                      and mov-ap.cod-fornec  = t-diario-ap.cod-fornec
                      and mov-ap.nr-docto    = t-diario-ap.nr-docto
                      and mov-ap.parcela     = t-diario-ap.parcela
                      and mov-ap.transacao   = 1 no-lock no-error.

                find first tt-emitente
                    where tt-emitente.cod-emit = t-diario-ap.cod-fornec
                    and   tt-emitente.identific <> 1
                    no-lock no-error.
                if  not avail tt-emitente then do:
                    find emitente
                        where emitente.cod-emitente = t-diario-ap.cod-fornec
                        and emitente.identific <> 1 no-lock no-error.
                    if  avail emitente then do:
                        create tt-emitente.
                        buffer-copy emitente to tt-emitente.
                    end.
                end.        
                if  not avail tt-emitente then
                    assign c-nomehist = t-diario-ap.historico.
                else do:
                    {utp/ut-liter.i Hist MAP L}
                    assign c-nomehist = if  t-diario-ap.historico <> "" then
                                            tt-emitente.nome-emit + " / " +
                                            trim(return-value) + ": " +
                                            t-diario-ap.historico
                                        else tt-emitente.nome-emit.
                end.

            end.
            else
               assign c-nomehist = t-diario-ap.historico
                      c-nomehist = replace(c-nomehist,chr(13) + chr(10)," ").
               assign c-nomehist = replace(c-nomehist,chr(13) + chr(10)," ").
               
               if not tt-param.l-imprime-contra-partida then
                   disp c-nomehist with frame f-nomehist.
               else do:
                disp c-conta 
                     c-trans
                     t-diario-ap.referencia              @ b-mov.referencia 
                     t-diario-ap.cod-fornec              @ b-mov.cod-fornec 
                     t-diario-ap.cod-estabel             @ b-mov.cod-estabel 
                     t-diario-ap.cod-esp                 @ b-mov.cod-esp 
                     t-diario-ap.serie                   @ b-mov.serie 
                     c-docto
                     t-diario-ap.parcela                 @ b-mov.parcela 
                     t-diario-ap.nr-cheque
                     t-diario-ap.portador
                     de-vl-debito when de-vl-debito <> 0
                     de-vl-credito when de-vl-credito <> 0
                     c-contra-partida
                     c-nomehist 
                     with frame f-diario-contra-partida.
    
                down with frame f-diario-contra-partida.
            end.
        end.

        assign de-total-debito  = de-total-debito  + de-vl-debito
               de-total-credito = de-total-credito + de-vl-credito
               de-conta-debito  = de-conta-debito  + de-vl-debito
               de-conta-credito = de-conta-credito + de-vl-credito
               c-ct-ant         = t-diario-ap.ct-conta
               c-sc-ant         = t-diario-ap.sc-conta
               de-tot-db-che    = de-tot-db-che    + de-vl-debito
               de-tot-cr-che    = de-tot-cr-che    + de-vl-credito.

    end.
end.

/* ap0707.i */
