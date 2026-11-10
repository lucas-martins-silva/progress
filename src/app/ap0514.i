/******************************************************************************
**
** AP0514.I - Defini‡Æo temp_tables tt-baixa.
**
******************************************************************************/
{cdp/cdcfgfin.i}

def temp-table tt-param no-undo
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field estado           as logical
    field referencia       like tit-ap.referencia
    field da-baixa         like tit-ap.dt-transacao
    field estabel-ini      like tit-ap.cod-estabel
    field estabel-fim      like tit-ap.cod-estabel
    field esp-ini          like tit-ap.cod-esp
    field esp-fim          like tit-ap.cod-esp
    field port-ini         like tit-ap.portador
    field port-fim         like tit-ap.portador
    field fornec-ini       like tit-ap.cod-fornec
    field fornec-fim       like tit-ap.cod-fornec
    field vencim-ini       like tit-ap.dt-vencimen
    field vencim-fim       like tit-ap.dt-vencimen
    field nr-docto-ini     like tit-ap.nr-docto
    field nr-docto-fim     like tit-ap.nr-docto
    field parcela-ini      like tit-ap.parcela
    field parcela-fim      like tit-ap.parcela
    field r-rowid          as rowid
    field verifica-antec   as logical.

def temp-table tt-baixa no-undo
    field referencia           like mov-ap.referencia
    field dt-baixa             like mov-ap.dt-pagamento
    field cod-estabel          like tit-ap.cod-estabel
    field cod-esp              like tit-ap.cod-esp
    field serie                like tit-ap.serie
    field nr-docto             like tit-ap.nr-docto
    field parcela              like tit-ap.parcela
    field cod-fornec           like tit-ap.cod-fornec
    field portador             like tit-ap.portador
    field nome-abrev           like tit-ap.nome-abrev
    field dt-vencimen          as   date   format "99/99/9999" label "Data Vencto"
    field moeda                like tit-ap.moeda
    field cotacao-dia          like tit-ap.cotacao-dia
    field valor-saldo          like tit-ap.valor-saldo
    field vl-saldo-me          like tit-ap.vl-saldo-me
    field estado               like tit-ap.estado
    field atualiza             as   logical
    field de-vl-juros          like tit-ap.vl-juros-dia
    field de-vl-juros-me       like tit-ap.vl-juros-dia-me
    field de-vl-desconto       like tit-ap.vl-desconto
    field de-vl-desconto-me    like tit-ap.vl-desconto-me
    &if defined(BF_FIN_MULTA_ABATIMENTO) &then
    field vl-desconto-tot      like tit-ap.vl-desconto-tot
    field vl-desconto-tot-me   like tit-ap.vl-desconto-tot-me
    field vl-juros-tot         like tit-ap.vl-juros-tot
    field vl-juros-tot-me      like tit-ap.vl-juros-tot-me
    field vl-multa-tot         like tit-ap.vl-multa-tot
    field vl-multa-tot-me      like tit-ap.vl-multa-tot-me
    field vl-abatimento-tot    like tit-ap.vl-abatimento-tot
    field vl-abatimento-tot-me like tit-ap.vl-abatimento-tot-me
    field conta-multa          like conta-ap.conta-multa
    field ct-multa             like conta-ap.ct-multa
    field sc-multa             like conta-ap.sc-multa
    field vl-multa             like mov-ap.vl-multa
    field vl-multa-me          like mov-ap.vl-multa-me
    field vl-multa-fasb        like mov-ap.vl-multa-fasb
    field vl-multa-cmi         like mov-ap.vl-multa-cmi
    field conta-abatimento     like conta-ap.conta-abatimento
    field ct-abatimento        like conta-ap.ct-abatimento
    field sc-abatimento        like conta-ap.sc-abatimento
    field vl-abatimento        like mov-ap.vl-abatimento
    field vl-abatimento-me     like mov-ap.vl-abatimento-me
    field vl-abatimento-fasb   like mov-ap.vl-abatimento-fasb
    field vl-abatimento-cmi    like mov-ap.vl-abatimento-cmi
    field i-sel                as   int
    field r-multa              as   rowid
    &endif
    field selec-titulo         as   logical init yes
    field antecip              as   LOGICAL
    FIELD l-gera-impto-auto    AS   LOGICAL INIT NO.

def temp-table tt-baixa-old-1 no-undo
    field referencia           like mov-ap.referencia
    field dt-baixa             like mov-ap.dt-pagamento
    field cod-estabel          like tit-ap.cod-estabel
    field cod-esp              like tit-ap.cod-esp
    field serie                like tit-ap.serie
    field nr-docto             like tit-ap.nr-docto
    field parcela              like tit-ap.parcela
    field cod-fornec           like tit-ap.cod-fornec
    field portador             like tit-ap.portador
    field nome-abrev           like tit-ap.nome-abrev
    field dt-vencimen          as   date   format "99/99/9999" label "Data Vencto"
    field moeda                like tit-ap.moeda
    field cotacao-dia          like tit-ap.cotacao-dia
    field valor-saldo          like tit-ap.valor-saldo
    field vl-saldo-me          like tit-ap.vl-saldo-me
    field estado               like tit-ap.estado
    field atualiza             as   logical
    field de-vl-juros          like tit-ap.vl-juros-dia
    field de-vl-juros-me       like tit-ap.vl-juros-dia-me
    field de-vl-desconto       like tit-ap.vl-desconto
    field de-vl-desconto-me    like tit-ap.vl-desconto-me
    &if defined(BF_FIN_MULTA_ABATIMENTO) &then
    field vl-desconto-tot      like tit-ap.vl-desconto-tot
    field vl-desconto-tot-me   like tit-ap.vl-desconto-tot-me
    field vl-juros-tot         like tit-ap.vl-juros-tot
    field vl-juros-tot-me      like tit-ap.vl-juros-tot-me
    field vl-multa-tot         like tit-ap.vl-multa-tot
    field vl-multa-tot-me      like tit-ap.vl-multa-tot-me
    field vl-abatimento-tot    like tit-ap.vl-abatimento-tot
    field vl-abatimento-tot-me like tit-ap.vl-abatimento-tot-me
    field conta-multa          like conta-ap.conta-multa
    field ct-multa             like conta-ap.ct-multa
    field sc-multa             like conta-ap.sc-multa
    field vl-multa             like mov-ap.vl-multa
    field vl-multa-me          like mov-ap.vl-multa-me
    field vl-multa-fasb        like mov-ap.vl-multa-fasb
    field vl-multa-cmi         like mov-ap.vl-multa-cmi
    field conta-abatimento     like conta-ap.conta-abatimento
    field ct-abatimento        like conta-ap.ct-abatimento
    field sc-abatimento        like conta-ap.sc-abatimento
    field vl-abatimento        like mov-ap.vl-abatimento
    field vl-abatimento-me     like mov-ap.vl-abatimento-me
    field vl-abatimento-fasb   like mov-ap.vl-abatimento-fasb
    field vl-abatimento-cmi    like mov-ap.vl-abatimento-cmi
    field i-sel                as   int
    field r-multa              as   rowid
    &endif
    field selec-titulo         as   logical init yes
    field antecip              as   LOGICAL.

def temp-table tt-baixa-old no-undo
    field referencia           like mov-ap.referencia
    field dt-baixa             like mov-ap.dt-pagamento
    field cod-estabel          like tit-ap.cod-estabel
    field cod-esp              like tit-ap.cod-esp
    field serie                like tit-ap.serie
    field nr-docto             like tit-ap.nr-docto
    field parcela              like tit-ap.parcela
    field cod-fornec           like tit-ap.cod-fornec
    field portador             like tit-ap.portador
    field nome-abrev           like tit-ap.nome-abrev
    field dt-vencimen          as   date   format "99/99/9999" label "Data Vencto"
    field moeda                like tit-ap.moeda
    field cotacao-dia          like tit-ap.cotacao-dia
    field valor-saldo          like tit-ap.valor-saldo
    field vl-saldo-me          like tit-ap.vl-saldo-me
    field estado               like tit-ap.estado
    field atualiza             as   logical
    field de-vl-juros          like tit-ap.vl-juros-dia
    field de-vl-juros-me       like tit-ap.vl-juros-dia-me
    field de-vl-desconto       like tit-ap.vl-desconto
    field de-vl-desconto-me    like tit-ap.vl-desconto-me
    &if defined(BF_FIN_MULTA_ABATIMENTO) &then
    field vl-desconto-tot      like tit-ap.vl-desconto-tot
    field vl-desconto-tot-me   like tit-ap.vl-desconto-tot-me
    field vl-juros-tot         like tit-ap.vl-juros-tot
    field vl-juros-tot-me      like tit-ap.vl-juros-tot-me
    field vl-multa-tot         like tit-ap.vl-multa-tot
    field vl-multa-tot-me      like tit-ap.vl-multa-tot-me
    field vl-abatimento-tot    like tit-ap.vl-abatimento-tot
    field vl-abatimento-tot-me like tit-ap.vl-abatimento-tot-me
    field conta-multa          like conta-ap.conta-multa
    field ct-multa             like conta-ap.ct-multa
    field sc-multa             like conta-ap.sc-multa
    field vl-multa             like mov-ap.vl-multa
    field vl-multa-me          like mov-ap.vl-multa-me
    field vl-multa-fasb        like mov-ap.vl-multa-fasb
    field vl-multa-cmi         like mov-ap.vl-multa-cmi
    field conta-abatimento     like conta-ap.conta-abatimento
    field ct-abatimento        like conta-ap.ct-abatimento
    field sc-abatimento        like conta-ap.sc-abatimento
    field vl-abatimento        like mov-ap.vl-abatimento
    field vl-abatimento-me     like mov-ap.vl-abatimento-me
    field vl-abatimento-fasb   like mov-ap.vl-abatimento-fasb
    field vl-abatimento-cmi    like mov-ap.vl-abatimento-cmi
    field i-sel                as   int
    field r-multa              as   rowid
    &endif
    field selec-titulo         as   logical init yes.


/* Fim Include */

