/***********************************************************************
**   AP1101a.i - Defini‡Æo das Temp-tables TT-TIT-AP, TT-IMPTO
**
************************************************************************/

/*------- Definicao Temp-Table --------*/
def temp-table tt-tit-ap
    field i-sequencia     as integer format "999999"
    field ep-codigo       as integer format "ZZ9"
    field cod-estabel   like tit-ap.cod-estabel
    field cod-esp         as character    format "x(2)"
    field nr-docto        as character    format "x(16)"
    field parcela         as character    format "x(2)"
    field cod-fornec      as integer      format "999999999"
    field serie           as character    format "x(5)"
    field dt-emissao    like  tit-ap.dt-emissao
    field dt-transacao  like  tit-ap.dt-transacao
    field dt-vencimen   like  tit-ap.dt-vencimen
    field tipo          like  tit-ap.tipo
    field valor-saldo     as  decimal     format "999999999999"
    field vl-original     as  decimal     format "999999999999"
    field vl-desconto     as  decimal     format "999999999999"
    field estado          as  integer     format "9"
    field ct-conta-db   like  tit-ap.ct-conta-db
    field sc-conta-db   like  tit-ap.sc-conta-db
    field conta-debito  like  lin-i-ap.conta-debito
    field origem          as  integer     format "99"
    field portador        as  decimal     format "99999"
    field vl-imposto      as  decimal     format "999999999999"
    field observacao      as character    format "x(80)"
    field valor-ir        as decimal      format "999999999999"
    field tp-codigo       as integer      format "999"
    field historico       as character    format "x(80)"
    field cod-retencao    as integer      format "99999"
    field l-historico     as character    format "!"
    field modalidade      as integer      format "9"
    field lancamento    like  tit-ap.lancamento
    field dt-prev-pag     as date   format "99/99/9999"
    field dt-desconto     as date   format "99/99/9999"
    field moeda           as integer      format "99".

def temp-table tt-tit-ap-imp like tt-tit-ap.
   

def temp-table tt-impto
    field  ep-codigo        as integer format "999"
    field  cod-estabel    like tt-tit-ap.cod-estabel
    field  cod-esp        like tt-tit-ap.cod-esp
    field  serie          like tt-tit-ap.serie
    field  nr-docto       like tt-tit-ap.nr-docto
    field  parcela        like tt-tit-ap.parcela
    field  cod-fornec     like tt-tit-ap.cod-fornec
    field  ct-conta-db    like tt-tit-ap.ct-conta-db
    field  sc-conta-db    like tt-tit-ap.sc-conta-db
    field  conta-imposto  like impto-tit-pend-ap.conta-imposto
    field  valor-impto      as decimal format "99999999999999"
    field  vl-base          as decimal format "99999999999999"
    field  perc-impto       as decimal format "999999" 
    field  tipo             as integer format "99"
    field  dt-transacao     as date    format "99/99/9999" 
    field  dt-vencimen      as date    format "99/99/9999" 
    field  Ind-data-base    as integer format "999999999"
    field  lancamento       as integer   format "99"
    field  mo-codigo        as integer
    field  historico        as character format "x(80)"
    field  cod-retencao     as integer   format "99999"
    field  tp-codigo        as integer   format "999"
    field  sequencia        as integer   format "9999999999"
    field  origem-impto     as integer   format "99"
    field  cotacao          as decimal   format "9999999999999"
    /*--- Chave do Imposto ----*/
    field  cod-esp-impto  like tt-tit-ap.cod-esp
    field  serie-impto    like tt-tit-ap.serie
    field  nr-docto-impto like tt-tit-ap.nr-docto
    field  parcela-impto  like tt-tit-ap.parcela.

/*--- FIM INCLUDE AP1101A.I ---*/
