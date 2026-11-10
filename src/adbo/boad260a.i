/*
**  BOAD260A.i
**
**  Include para defini‡Æo das temp-tables tt-baixa, tt-param, tt-prepara
**  tt-atualiza  
**
*/
{cdp/cdcfgfin.i}
def temp-table tt-baixa1
    field referencia        like mov-ap.referencia
    field dt-baixa          like mov-ap.dt-pagamento
    field cod-estabel       like tit-ap.cod-estabel
    field cod-esp           like tit-ap.cod-esp
    field serie             like tit-ap.serie
    field nr-docto          like tit-ap.nr-docto
    field parcela           like tit-ap.parcela
    field cod-fornec        like tit-ap.cod-fornec
    field portador          like tit-ap.portador
    field nome-abrev        like tit-ap.nome-abrev
    field dt-vencimen       as date format "99/99/9999" label "Data Vencto"
    field moeda             like tit-ap.moeda
    field cotacao-dia       like tit-ap.cotacao-dia
    field valor-saldo       like tit-ap.valor-saldo
    field vl-saldo-me       like tit-ap.vl-saldo-me
    field estado            like tit-ap.estado
    field atualiza          as logical
    field de-vl-juros       like tit-ap.vl-juros-dia
    field de-vl-juros-me    like tit-ap.vl-juros-dia-me
    field de-vl-desconto    like tit-ap.vl-desconto
    field de-vl-desconto-me like tit-ap.vl-desconto-me
    field r-rowid           as rowid.

def temp-table RowObject
    field referencia        like mov-ap.referencia
    field dt-baixa          like mov-ap.dt-pagamento
    field cod-estabel       like tit-ap.cod-estabel
    field cod-esp           like tit-ap.cod-esp
    field serie             like tit-ap.serie
    field nr-docto          like tit-ap.nr-docto
    field parcela           like tit-ap.parcela
    field cod-fornec        like tit-ap.cod-fornec
    field portador          like tit-ap.portador
    field nome-abrev        like tit-ap.nome-abrev
    field dt-vencimen       as date format "99/99/9999" label "Data Vencto"
    field moeda             like tit-ap.moeda
    field cotacao-dia       like tit-ap.cotacao-dia
    field valor-saldo       like tit-ap.valor-saldo
    field vl-saldo-me       like tit-ap.vl-saldo-me
    field estado            like tit-ap.estado
    field atualiza          as logical
    field de-vl-juros       like tit-ap.vl-juros-dia
    field de-vl-juros-me    like tit-ap.vl-juros-dia-me
    field de-vl-desconto    like tit-ap.vl-desconto
    field de-vl-desconto-me like tit-ap.vl-desconto-me
    field r-rowid           as rowid.

    
def temp-table tt-param
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
        
def temp-table tt-prepara
    field referencia        like mov-ap.referencia
    field dt-baixa          like mov-ap.dt-pagamento
    field cod-estabel       like tit-ap.cod-estabel
    field cod-esp           like tit-ap.cod-esp
    field serie             like tit-ap.serie
    field nr-docto          like tit-ap.nr-docto
    field parcela           like tit-ap.parcela
    field cod-fornec        like tit-ap.cod-fornec
    field portador          like tit-ap.portador
    field nome-abrev        like tit-ap.nome-abrev
    field dt-vencimen       as date format "99/99/9999" label "Data Vencto"
    field moeda             like tit-ap.moeda
    field cotacao-dia       like tit-ap.cotacao-dia
    field valor-saldo       like tit-ap.valor-saldo
    field vl-saldo-me       like tit-ap.vl-saldo-me
    field estado            like tit-ap.estado
    field atualiza          as logical
    field de-vl-juros       like tit-ap.vl-juros-dia
    field de-vl-juros-me    like tit-ap.vl-juros-dia-me
    field de-vl-desconto    like tit-ap.vl-desconto
    field de-vl-desconto-me like tit-ap.vl-desconto-me
    field juros             as decimal
    field descto            as decimal
    field r-rowid           as rowid.

def temp-table tt-baixa
    field referencia        like mov-ap.referencia
    field dt-baixa          like mov-ap.dt-pagamento
    field cod-estabel       like tit-ap.cod-estabel
    field cod-esp           like tit-ap.cod-esp
    field serie             like tit-ap.serie
    field nr-docto          like tit-ap.nr-docto
    field parcela           like tit-ap.parcela
    field cod-fornec        like tit-ap.cod-fornec
    field portador          like tit-ap.portador
    field nome-abrev        like tit-ap.nome-abrev
    field dt-vencimen       as date format "99/99/9999" label "Data Vencto"
    field moeda             like tit-ap.moeda
    field cotacao-dia       like tit-ap.cotacao-dia
    field valor-saldo       like tit-ap.valor-saldo
    field vl-saldo-me       like tit-ap.vl-saldo-me
    field estado            like tit-ap.estado
    field atualiza          as logical
    field de-vl-juros       like tit-ap.vl-juros-dia
    field de-vl-juros-me    like tit-ap.vl-juros-dia-me
    field de-vl-desconto    like tit-ap.vl-desconto
    field de-vl-desconto-me like tit-ap.vl-desconto-me
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
    

def temp-table tt-param-nom no-undo
    field ep-codigo           like mov-ap.ep-codigo
    field portador            like mov-ap.portador
    field nr-cheque           like mov-ap.nr-cheque
    field dt-venc-cheq        like mov-ap.dt-vencimen
    field c-literal           as char format "x(50)"
    field c-nominal           as char
    field l-vid-rel           as logical
    field cod-versao-integ    as int.


/*******************************************************************
**
**  CD0666.I - Definicao temp-table de erros
**
*******************************************************************/

/* def new global shared var l-multi as logical initial yes. */

def var l-multi as logical initial yes.
def var l-del-erros as logical init yes.
def var v-nom-arquivo-cb as char format "x(50)" no-undo.
def var c-mensagem-cb    as char format "x(90)" no-undo.

def {1} temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

form
    space(04)
    tt-erro.cd-erro 
    space (02)
    c-mensagem-cb
    with width 132 no-box down stream-io frame f-consiste.



{utp/ut-liter.i Mensagem}
assign tt-erro.cd-erro:label in frame f-consiste = trim(return-value).

{utp/ut-liter.i Descri‡Æo}
assign c-mensagem-cb:label in frame f-consiste = trim(return-value).    
