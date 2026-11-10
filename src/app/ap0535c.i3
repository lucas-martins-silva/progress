/**********************************************************************************
***
*** app/ap0535c.i3 - Gera Movimento de Baixa.
***
**********************************************************************************/

create mov-ap.
assign mov-ap.ep-codigo      = b-tit-ap-dup.ep-codigo
       mov-ap.cod-estabel    = b-tit-ap-dup.cod-estabel
       mov-ap.cod-esp        = b-tit-ap-dup.cod-esp
       mov-ap.serie          = b-tit-ap-dup.serie
       mov-ap.nr-docto       = b-tit-ap-dup.nr-docto
       mov-ap.parcela        = b-tit-ap-dup.parcela
       mov-ap.cod-fornec     = b-tit-ap-dup.cod-fornec
       mov-ap.nome-abrev     = b-tit-ap-dup.nome-abrev
       mov-ap.referencia     = b-tit-ap-dup.referencia
       mov-ap.dt-emissao     = b-tit-ap-dup.dt-emissao
       mov-ap.dt-vencimen    = b-tit-ap-dup.dt-vencimen
       mov-ap.dt-transacao   = p-da-transacao
       mov-ap.dt-pagamento   = b-tit-ap-dup.dt-emissao
       mov-ap.portador       = b-tit-ap-dup.portador
       mov-ap.modalidade     = b-tit-ap-dup.modalidade
       mov-ap.ct-conta       = b-tit-ap-dup.ct-conta-db
       mov-ap.sc-conta       = b-tit-ap-dup.sc-conta-db
       mov-ap.conta-contabil = b-tit-ap-dup.conta-debito
       mov-ap.tp-codigo      = b-tit-ap-dup.tp-codigo
       mov-ap.transacao      = 2
       mov-ap.contabilizou   = no
       mov-ap.fornec-ant     = b-tit-ap-ant.cod-fornec
       mov-ap.esp-ant        = b-tit-ap-ant.cod-esp
       mov-ap.serie-ant      = b-tit-ap-ant.serie
       mov-ap.docto-ant      = b-tit-ap-ant.nr-docto
       mov-ap.parc-ant       = b-tit-ap-ant.parcela
       mov-ap.usuario        = c-seg-usuario
       mov-ap.dt-today       = today
       mov-ap.c-time         = string(time, "HH:MM").
                    
assign mov-ap.cotacao-dia    = p-cotacao
       mov-ap.vl-original    = b-tit-ap-dup.vl-original
       mov-ap.vl-orig-me     = b-tit-ap-dup.vl-orig-me
       mov-ap.valor-mov      = p-vl-baixa
       mov-ap.valor-mov-me   = p-vl-baixa-me
       mov-ap.vl-antecip     = p-vl-baixa
       mov-ap.vl-antecip-me  = p-vl-baixa-me.

if  b-tit-ap-dup.moeda <> 0 then
    assign mov-ap.moeda = p-moeda.
else 
    assign mov-ap.moeda = 0.

/* Fim de Include */

