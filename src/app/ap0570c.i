/**********************************************************************************
***
*** app/ap0570c.i - Gera AVA no Valor da Varia‡Æo Monet ria para o Documento.
***
**********************************************************************************/

create mov-ap.
assign mov-ap.ep-codigo      = tit-ap.ep-codigo
       mov-ap.cod-estabel    = tit-ap.cod-estabel
       mov-ap.serie          = tit-ap.serie
       mov-ap.cod-esp        = tit-ap.cod-esp
       mov-ap.nr-docto       = tit-ap.nr-docto
       mov-ap.parcela        = tit-ap.parcela
       mov-ap.transacao      = 5
       mov-ap.cod-fornec     = tit-ap.cod-fornec.

if tit-ap.tipo = 2 then do:
   assign mov-ap.portador       = 0
          mov-ap.modalidade     = 1.
end.
else do:
   assign mov-ap.portador       = tit-ap.portador
          mov-ap.modalidade     = tit-ap.modalidade.
end.   

assign mov-ap.dt-emissao     = tit-ap.dt-emissao
       mov-ap.dt-vencimen    = tit-ap.dt-vencimen
       mov-ap.dt-transacao   = tt-variacao-monetaria.dt-calculo
       mov-ap.referencia     = "VC" 
                              + string(day(tt-variacao-monetaria.dt-calculo), "99")
                              + string(month(tt-variacao-monetaria.dt-calculo), "99")
                              + string(year(tt-variacao-monetaria.dt-calculo), "9999")
       mov-ap.tp-codigo      = tit-ap.tp-codigo
       mov-ap.contabilizou   = no
       mov-ap.flag-contab    = espec-ap.contabiliza
       mov-ap.contabiliza    = espec-ap.contabiliza
       mov-ap.tipo           = tit-ap.tipo
       mov-ap.nome-abrev     = tit-ap.nome-abrev
       mov-ap.ind-tp-alter   = 3
       mov-ap.dt-today       = today
       mov-ap.usuario        = c-seg-usuario
       mov-ap.c-time         = string(time, "HH:MM:SS").

assign mov-ap.moeda          = 0
       mov-ap.cotacao-dia    = tt-variacao-monetaria.cotacao-dia
       mov-ap.log-2          = yes   /* Identifica que a partir desta atualizacao
                                        passou a atualizar o campo cota‡ao dia */
       mov-ap.vl-original    = tit-ap.vl-original
       mov-ap.vl-orig-me     = tit-ap.vl-original
       mov-ap.valor-mov      = if  tt-variacao-monetaria.vl-variacao < 0 then
                                   (tt-variacao-monetaria.vl-variacao * -1)
                                else
                                    tt-variacao-monetaria.vl-variacao.

/*--- Indica que o movto ‚ de varia‡Æo monet ria ---*/
assign mov-ap.log-1 = yes.

if  tt-variacao-monetaria.vl-variacao > 0 then do:
    find first conta-contab no-lock
         where conta-contab.ep-codigo      = tit-ap.ep-codigo
         and   conta-contab.conta-contabil = conta-ap.conta-var-monetaria 
         no-error.

    if  avail conta-contab then do:
        assign mov-ap.conta-contabil = conta-contab.conta-contabil
               mov-ap.ct-conta       = conta-contab.ct-codigo
               mov-ap.sc-conta       = conta-contab.sc-codigo.
    end.
end.
else do:
    find first conta-contab no-lock
         where conta-contab.ep-codigo      = tit-ap.ep-codigo
         and   conta-contab.conta-contabil = conta-ap.conta-antecipacao
         no-error.

    if  avail conta-contab then do:
        assign mov-ap.conta-contabil = conta-contab.conta-contabil
               mov-ap.ct-conta       = conta-contab.ct-codigo
               mov-ap.sc-conta       = conta-contab.sc-codigo.
    end.
end.

assign tit-ap.valor-saldo = tit-ap.valor-saldo + tt-variacao-monetaria.vl-variacao.

if  tit-ap.valor-saldo > de-vl-saldo-ant then do:
    assign mov-ap.lancamento = if (tit-ap.tipo = 1 or
                                   tit-ap.tipo = 8 or
                                   tit-ap.tipo = 10) then 1 else 2.
end.
else do:
    assign mov-ap.lancamento = if (tit-ap.tipo = 1 or
                                   tit-ap.tipo = 8 or
                                   tit-ap.tipo = 10) then 2 else 1.
end.

find first emite-ap exclusive-lock
     where emite-ap.ep-codigo   = tit-ap.ep-codigo
     and   emite-ap.cod-estabel = tit-ap.cod-estabel
     and   emite-ap.cod-esp     = tit-ap.cod-esp
     and   emite-ap.serie       = tit-ap.serie
     and   emite-ap.nr-docto    = tit-ap.nr-docto
     and   emite-ap.parcela     = tit-ap.parcela
     and   emite-ap.cod-fornec  = tit-ap.cod-fornec
     no-error.

if  avail emite-ap then do:
    if  tit-ap.valor-saldo > de-vl-saldo-ant then do:
        assign emite-ap.valor-ap = if (tit-ap.tipo = 1
                                   or  tit-ap.tipo = 8
                                   or  tit-ap.tipo = 10) then
                                       emite-ap.valor-ap + mov-ap.valor-mov
                                   else
                                       emite-ap.valor-ap - mov-ap.valor-mov.
    end.
    else do:
        assign emite-ap.valor-ap = if (tit-ap.tipo = 1
                                   or  tit-ap.tipo = 8
                                   or  tit-ap.tipo = 10) then
                                       emite-ap.valor-ap - mov-ap.valor-mov
                                   else
                                       emite-ap.valor-ap + mov-ap.valor-mov.
    end.
end.

/*---- INTEGRA€åES FASB/CMCAC ---*/
{app/ap9100.i2}
assign tt-integ-ap.tt-row-mov-ap  = rowid(mov-ap)
       tt-integ-ap.tt-fc1014a     = yes 
       tt-integ-ap.tt-fc1114a     = yes.
raw-transfer tt-integ-ap to raw-integracao.
run app/ap9100.p (Input raw-integracao, input-output table tt-erro).

assign i-sequencia = 1.

repeat:

    find first his-d-ap no-lock
         where his-d-ap.ep-codigo    = tit-ap.ep-codigo
         and   his-d-ap.cod-estabel  = tit-ap.cod-estabel
         and   his-d-ap.cod-esp      = tit-ap.cod-esp
         and   his-d-ap.serie        = tit-ap.serie
         and   his-d-ap.nr-docto     = tit-ap.nr-docto
         and   his-d-ap.parcela      = tit-ap.parcela
         and   his-d-ap.cod-fornec   = tit-ap.cod-fornec
         and   his-d-ap.dt-his-doc   = today
         and   his-d-ap.sequencia    = i-sequencia
         no-error.

    if  avail his-d-ap then 
        assign i-sequencia = i-sequencia + 1.
    else 
        leave.

end.
if  index(proversion,"webspeed") = 0 THEN
    run utp/ut-msgs.p (input "help",
                       input 17720,
                       input string(today, "99/99/9999") + "~~" +
                             caps(c-seg-usuario) + "~~" +
                             string(tt-variacao-monetaria.dt-calculo, "99/99/9999") + "~~" +
                             string(tt-variacao-monetaria.cotacao-dia, ">>>,>9.99999999")).

create his-d-ap.
assign his-d-ap.ep-codigo    = tit-ap.ep-codigo
       his-d-ap.cod-estabel  = tit-ap.cod-estabel
       his-d-ap.cod-esp      = tit-ap.cod-esp
       his-d-ap.serie        = tit-ap.serie
       his-d-ap.nr-docto     = tit-ap.nr-docto
       his-d-ap.parcela      = tit-ap.parcela
       his-d-ap.cod-fornec   = tit-ap.cod-fornec
       his-d-ap.dt-his-doc   = today
       his-d-ap.sequencia    = i-sequencia
       his-d-ap.historico    = return-value.

/* Fim de Include */
