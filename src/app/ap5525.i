/*************************************************************************
** 
**  Programa: APAPI5525.I
**  Objetivo: Defini‡Æo das temp-tables usadas no  ap5525.p
**
*************************************************************************/
def temp-table tt-param
    field i-ep-codigo      like tit-ap.ep-codigo
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field portador         like tit-ap.portador
    field data-pagto       like tit-ap.dt-prev-pag
    field situacao         as  logical init no
    field prim-pag         as  logical init no
    field infor-banc       as  logical init no
    field est-ini          like tit-ap.cod-est
    field est-fim          like tit-ap.cod-est
    field esp-ini          like tit-ap.cod-esp
    field esp-fim          like tit-ap.cod-esp
    field port-ini         like tit-ap.portador
    field port-fim         like tit-ap.portador
    field fornec-ini       like tit-ap.cod-fornec
    field fornec-fim       like tit-ap.cod-fornec
    field dt-vencto-ini    like tit-ap.dt-vencimen
    field dt-vencto-fim    like tit-ap.dt-vencimen
    field dt-pag-ini       like tit-ap.dt-vencimen
    field dt-pag-fim       like tit-ap.dt-vencimen
    field razao-ini        like emitente.nome-emit
    field razao-fim        like emitente.nome-emit
    field l-vid-rel        as logical
    field l-acompanha      as logical
    field cod-versao-integ as integer.


define temp-table tt-digita
    field ep-codigo           like tit-ap.ep-codigo
    field estabelec           like tit-ap.cod-estabel
    field cod-esp             like tit-ap.cod-esp
    field serie               like tit-ap.serie
    field nr-docto            like tit-ap.nr-docto
    field parcela             like tit-ap.parcela
    field portador            like tit-ap.portador
    field bordero             like tit-ap.nr-bordero
    field fornec              like tit-ap.cod-fornec
    field nome-abrev          like tit-ap.nome-abrev
    field dt-vencto           as date format "99/99/9999" label "Data Vencto"
    field vl-saldo            like tit-ap.valor-saldo
    field vl-desconto         like tit-ap.vl-desconto
    field vl-juros            like tit-ap.vl-juros-dia
    field vl-variacao         like bord-tit.vl-var-mon
    field autorizacao         like tit-ap.autorizacao
    field confirma            as logical init no
    field marcado             as logical init no
    field rw-digita           as rowid
    field estado              like tit-ap.estado init 1
    field cod-barras          like tit-ap.cod-barras
    field razao               like emitente.nome-emit
    field titulo-banco        like tit-ap.titulo-banco
    field cod-banco-forn      like tit-ap.cod-banco-forn
    field agencia-forn        like tit-ap.agencia-forn
    field conta-corrente-forn like tit-ap.conta-corrente-forn
    field log-leitora         as logical initial yes
    field tipo-pagto          as char format "x(20)"
    field seq                 as int
    index ch-razao razao ascending
    index classif-id razao
                     vl-saldo
                     dt-vencto
                     nr-docto
                     parcela.
