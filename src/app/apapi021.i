/**********************************************************************
**
**   APAPI021.I - DEFINICAO DE TEMP-TABLE PARA ESTORNO DO TÖTULO DO AP
**
***********************************************************************/

def temp-table tt-tot-tit
    field referencia     like tit-ap.referencia
    field ep-codigo      like tit-ap.ep-codigo
    field cod-empresa    as character format "x(3)"
    field cod-estabel    like tit-ap.cod-estabel
    field cod-estab-ems5 as character format "x(3)"
    field cod-fornec    like tit-ap.cod-fornec
    field cod-esp       like tit-ap.cod-esp
    field serie         like tit-ap.serie
    field nr-docto      like tit-ap.nr-docto
    field tot-saldo     like tit-ap.vl-saldo
    field tot-baixa     like tit-ap.vl-saldo
    field mo-codigo     like docum-est.mo-codigo
    field cotacao-dia   like docum-est.cotacao-dia
    field dt-trans      like docum-est.dt-trans
    field nr-docto-cr   like tit-ap.nr-docto
    field serie-cr      like tit-ap.serie
    field cod-esp-cr    like tit-ap.cod-esp 
    field tp-codigo     like natur-oper.tp-rec-desp
    /*field estorn-comis  like docum-est.estorn-comis este campo nao estava na defini‡Æo passada pelo Odair */
    field conta-debito  like docum-est.conta-transit
    field sequencia     as   integer
    field erro          as logical format  "Sim/Nao" /*l_sim_nao*/
    index seq           is primary unique
          sequencia
    index titulo
          serie
          nr-docto.
          
def temp-table tt-tot-tit-new
    field referencia     like tit-ap.referencia
    field ep-codigo      like tit-ap.ep-codigo
    field cod-empresa    as character format "x(3)"
    field cod-estabel    like tit-ap.cod-estabel
    field cod-estab-ems5 as character format "x(3)"
    field cod-fornec    like tit-ap.cod-fornec
    field cod-esp       like tit-ap.cod-esp
    field serie         like tit-ap.serie
    field nr-docto      like tit-ap.nr-docto
    field tot-saldo     like tit-ap.vl-saldo
    field tot-baixa     like tit-ap.vl-saldo
    field mo-codigo     like docum-est.mo-codigo
    field cotacao-dia   like docum-est.cotacao-dia
    field dt-trans      like docum-est.dt-trans
    field nr-docto-cr   like tit-ap.nr-docto
    field serie-cr      like tit-ap.serie
    field cod-esp-cr    like tit-ap.cod-esp 
    field tp-codigo     like natur-oper.tp-rec-desp
    field conta-debito  like docum-est.conta-transit
    field sequencia     as   integer
    field erro          as logical format  "Sim/Nao"
    field serie-nota     as character format "x(5)"
    field nr-docto-nota  as character format "x(16)"
    index seq           is primary unique
          sequencia
    index titulo
          serie
          nr-docto.

def temp-table tt-titulo
    field sequencia     as  integer
    field parcela       like tit-ap.parcela
    field vl-saldo      like tit-ap.vl-saldo
    field vl-baixa      like tit-ap.vl-saldo
    field ind-baixa     as logical
    index titulo        is primary
          sequencia
          ind-baixa.



/*as temp-tables abaixo possuem a mesma defini‡Æo das temp-tables acima.
  A £nica diferen‡a ‚ que nas temp-tables abaixo foram inclu¡dos campos para
  utiliza‡Æo no multiplanta*/
def temp-table tt-tot-tit-mp
    field referencia       like tit-ap.referencia
    field ep-codigo        like tit-ap.ep-codigo
    field cod-estabel      like tit-ap.cod-estabel
    field cod-fornec       like tit-ap.cod-fornec
    field cod-esp          like tit-ap.cod-esp
    field serie            like tit-ap.serie
    field nr-docto         like tit-ap.nr-docto
    field tot-saldo        like tit-ap.vl-saldo
    field tot-baixa        like tit-ap.vl-saldo
    field mo-codigo        like docum-est.mo-codigo
    field cotacao-dia      like docum-est.cotacao-dia
    field dt-trans         like docum-est.dt-trans
    field nr-docto-cr      like tit-ap.nr-docto
    field serie-cr         like tit-ap.serie
    field cod-esp-cr       like tit-ap.cod-esp 
    field tp-codigo        like natur-oper.tp-rec-desp
    field estorn-comis     like docum-est.estorn-comis
    field conta-debito     like docum-est.conta-transit
    field sequencia        as   integer
    field cod-maq-origem   like maquina.cd-maquina
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    field serie-nota     as character format "x(5)"
    field nr-docto-nota  as character format "x(16)"
    INDEX documento IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.


def temp-table tt-titulo-mp
    field sequencia        as  integer
    field parcela          like tit-ap.parcela
    field vl-saldo         like tit-ap.vl-saldo
    field vl-baixa         like tit-ap.vl-saldo
    field ind-baixa        as logical
    field cod-maq-origem   like maquina.cd-maquina
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX documento IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.

/* fim do include */
