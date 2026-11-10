/*************************************************************************
** 
**  Programa: APAPI227.I
**  Objetivo: Defini‡Æo das temp-tables usadas na API apapi227.p
**
*************************************************************************/ 

{cdp/cdcfgfin.i} /* Miniflexibiliza‡Æo 2.03 */

def temp-table tt-bord-rec-aux NO-UNDO like bord-rec
    INDEX ch-codigo IS PRIMARY ep-codigo
                               portador
                               nr-bordero.

def temp-table tt-bord-tit-aux NO-UNDO like bord-tit
    INDEX ch-codigo IS PRIMARY ep-codigo
                               nr-bordero
                               portador
                               cod-fornec
                               cod-estabel
                               cod-esp
                               serie
                               nr-docto
                               parcela.

def temp-table tt-bordero-ap-aux NO-UNDO like bordero-ap
    INDEX ch-codigo IS PRIMARY ep-codigo
                               cod-fornec
                               cod-estabel
                               cod-esp
                               serie
                               nr-docto
                               parcela.

def temp-table tt-bord-rec NO-UNDO like bord-rec
    field cod-maq-origem   as   integer format "9999"
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.

def temp-table tt-bord-tit NO-UNDO like bord-tit
    field cod-maq-origem   as   integer format "9999"
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.

def temp-table tt-bordero-ap NO-UNDO like bordero-ap
    field cod-maq-origem   as   integer format "9999"
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.

def temp-table tt-param NO-UNDO
    field i-ep-codigo      like tit-ap.ep-codigo
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field portador         like tit-ap.portador
    field bordero          like tit-ap.nr-bordero
    field data-pagto       like tit-ap.dt-prev-pag
    field situacao         as  logical init no
    field prim-pag         as  logical init no
    field infor-banc       as  logical init no
    field linha            as  logical init no
    field imp-hist         as  logical init no 
    field quebra           as  logical init no
    field est-ini          like tit-ap.cod-est
    field est-fim          like tit-ap.cod-est
    field esp-ini          like tit-ap.cod-esp
    field esp-fim          like tit-ap.cod-esp
    field msg-ini          like bord-rec.mens-ini
    field msg-fim          like bord-rec.mens-final
    field port-ini         like tit-ap.portador
    field port-fim         like tit-ap.portador
    field fornec-ini       like tit-ap.cod-fornec
    field fornec-fim       like tit-ap.cod-fornec
    field dt-vencto-ini    like tit-ap.dt-vencimen
    field dt-vencto-fim    like tit-ap.dt-vencimen
    field dt-pag-ini       like tit-ap.dt-vencimen
    field dt-pag-fim       like tit-ap.dt-vencimen
    field dt-desconto-ini  like tit-ap.dt-vencimen
    field dt-desconto-fim  like tit-ap.dt-vencimen
    FIELD i-autoriz-ini    AS INTEGER
    FIELD i-autoriz-fim    AS INTEGER
    field tp-relato        as integer
    field vl-total         like bord-rec.vl-total
    field l-vid-rel        as logical
    field l-acompanha      as logical
    field cod-versao-integ as INTEGER
    FIELD l-pis-cofins-csll-auto AS LOGICAL
    FIELD l-verifica-an          AS LOGICAL
    FIELD l-doc                  AS LOGICAL
    FIELD l-credito-cc           AS LOGICAL
    FIELD l-cheque-adm           AS LOGICAL
    FIELD l-cobranca-cart        AS LOGICAL
    FIELD l-cheque-nominal       AS LOGICAL
    FIELD l-debita-cta-cor       AS LOGICAL
    FIELD l-cartao-credito       AS LOGICAL
    FIELD l-agend-elet           AS LOGICAL
    FIELD l-considera-desc       AS LOGICAL.

define temp-table tt-digita NO-UNDO
    field estabelec     like tit-ap.cod-estabel
    field cod-esp       like tit-ap.cod-esp
    field serie         like tit-ap.serie
    field nr-docto      like tit-ap.nr-docto
    field parcela       like tit-ap.parcela
    field portador      like tit-ap.portador
    field bordero       like tit-ap.nr-bordero
    field fornec        like tit-ap.cod-fornec
    field nome-abrev    like tit-ap.nome-abrev
    field dt-vencto     as   date format "99/99/9999" label "Data Vencto"
    field vl-saldo      like tit-ap.valor-saldo
    field vl-desconto   like tit-ap.vl-desconto
    field vl-juros      like tit-ap.vl-juros-dia
    &if defined(BF_FIN_MULTA_ABATIMENTO) &then
    field vl-abatimento like tit-ap.vl-abatimento-tot
    field vl-multa      like tit-ap.vl-multa-tot
    &endif
    field vl-variacao   like bord-tit.vl-var-mon
    field autorizacao   like tit-ap.autorizacao
    FIELD tp-pagto      LIKE tit-ap.tp-pagto
    FIELD tipo          LIKE tit-ap.tipo
    field confirma      as   logical init no
    field marcado       as   logical init no
    field rw-digita     as   rowid
    field estado        like tit-ap.estado init 1
    field tabela        as   char
    field antecip       as   LOGICAL
    FIELD antecip-vinc  AS   LOGICAL
    INDEX fornec fornec antecip
    INDEX codigo estabelec
                 fornec
                 cod-esp
                 serie
                 nr-docto
                 parcela.

/* Fim de Include */

