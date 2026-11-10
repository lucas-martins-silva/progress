/****************************************************************************
***
***  - app/ap1001.i - Defini»’o temp-table's.
***
*****************************************************************************/
{include/i_dbvers.i}

define temp-table tt-param no-undo
    field destino         as integer
    field arquivo         as char format "x(35)"
    field usuario         as char format "x(12)"
    field data-exec       as date
    field hora-exec       as integer
    field classifica      as integer
    field desc-classifica as char format "x(40)"
    field i-empresa       as integer
    field cod-fornec-ini  as integer format ">>>>>>>>9"
    field cod-fornec-fim  as integer format ">>>>>>>>9"
    field cod-estab-ini   as char
    field cod-estab-fim   as char
    field cod-esp-ini     as char
    field cod-esp-fim     as char
    field cod-ret-ini     as integer
    field cod-ret-fim     as integer
    field dt-vencto-ini   as date    format "99/99/9999"
    field dt-vencto-fim   as date    format "99/99/9999" 
    field dt-trans-ini    as date    format "99/99/9999"
    field dt-trans-fim    as date    format "99/99/9999"
    field bordero-ini     as integer format ">>>>>>>9"
    field bordero-fim     as integer format ">>>>>>>9"
    field i-selecao       as integer
    field i-ocorrencia    as integer
    field i-cod-port      as integer
    field i-cod-febr      as integer
    field d-val-minimo    as decimal format ">>>,>>>,>>9.99":U
    field i-periodo-comp  as integer
    field cod-pagto-gps   as integer format "9999"
    field l-agrupa-estab  as logical format "Sim/N’o"
    field c-arquivo-remessa as char.

define temp-table tt-digita no-undo
    field selecionado   as logical   init   no
    field ordem         as integer   format ">>>>9"
    field exemplo       as character format "x(30)"
    field cod-estabel   like tit-ap.cod-estabel
    field cod-fornec    like tit-ap.cod-fornec
    field cod-esp       like tit-ap.cod-esp
    field serie         like tit-ap.serie
    field nr-docto      like tit-ap.nr-docto
    field parcela       like tit-ap.parcela
    field cod-retencao  like tit-ap.cod-retencao
    field dt-vencimen   like tit-ap.dt-vencimen
    field valor-saldo   like tit-ap.valor-saldo
    field c-transacao   as char      format "x(03)" label "TRAN"
    field num-id-mov-ap like mov-ap.num-id-mov-ap
    index id ordem.

define temp-table tt-gps no-undo
    field nr-docto-gps      like tit-ap.titulo-banco
    field cgc               like emitente.cgc
    field valor-gps         like tit-ap.valor-saldo
    field dt-pagto          like tit-ap.dt-vencimen
    field cod-retencao      like tit-ap.cod-retencao
    field dt-competencia    like tit-ap.dt-vencimen
    field nome-emit         like emitente.nome-emit.

/* Transfer Definitions */

def temp-table tt-raw-digita
   field raw-digita      as raw.


/* Fim de Include */

