/****************************************************************************
***
***  - app/ap1001.i - Defini‡Æo temp-table's.
***
*****************************************************************************/
{include/i_dbvers.i}
def temp-table tt-param no-undo
    field destino           as inte
    field arquivo           as char
    field usuario           as char
    field data-exec         as date
    field hora-exec         as inte
    field i-empresa         as inte
    field c-est-ini         as char
    field c-est-fim         as char
    field c-esp-ini         as char
    field c-esp-fim         as char
    field c-ser-ini         as char
    field c-ser-fim         as char
    field i-docto-ini       as char
    field i-docto-fim       as char
    field i-fornec-ini      as inte FORMAT "999999999"
    field i-fornec-fim      as inte FORMAT "999999999" 
    field da-vencimen-ini   as date
    field da-vencimen-fim   as date
    field da-inicial        as date
    field da-final          as date
    field i-bord-ini        as inte
    field i-bord-fim        as inte
    field i-portador        as inte
    field i-escolhe         as inte
    field i-sel-bordero     as inte
    field i-ocorrencia      as inte
    field i-tipo-pag        as inte
    field i-documento       as inte
    field l-estado          as logi
    field c-arquivo-remessa as char
    field i-op-banco        as inte
    field cta-corrente      as char format "XXXXXXXXXX-XX"
    field agencia           as char format "XXXXXX-X"
    field identific-emp     as char format "x(8)"
    field l-vid-rel         as logical
    field conta-compl       as inte
    field c-tipo-docum      as char format "x(01)"
    field i-finalidade      as inte format "99"
    field de-tipo-band      as dec  format "9999999999"
    field i-agencia         as inte format "9999999"
    field cod-versao-integ  as inte
    field i-conta-bos       as inte format "99999999"
    field i-agenc-bos       as inte format "9999999"
    field l-autoriza        as logical
    field i-sequencia       as integer
    field da-pagto          as date
    field i-convenio        as inte format "999999"
    field c-filial          as char 
    field d-conta-cosmos    as dec format "9999999999"
    FIELD l-incl-param-arq  as log.
        
def temp-table tt-raw-param no-undo
    field raw-param as raw.
        
def temp-table tt-tit-ap no-undo like tit-ap
    field row-mov-ap        as rowid
    field selecionado       as logical init no
    field c-trans           as char format "x(03)" label "TRA"
    field banco             like mov-ap.banco
    field agencia           like mov-ap.agencia
    field cta-corrente      like mov-ap.cta-corrente
    field c-cod-barras      as char format "x(50)"
    field ita-aceite        as logi 
    field ita-carteira      as char format "x(05)"
    field ita-uso-banco     as char format "x(10)"
    field ita-vl-abatim     as dec
    field ita-vl-multa      as dec
    field c-moeda           as char
    field log-leitora       as logical
    field r-rowid           as rowid
    field i-tipo-pagto      as integer
    INDEX codigo IS PRIMARY UNIQUE 
       row-mov-ap
    INDEX dt-trans 
       dt-transacao
    INDEX dt-venc  
       dt-vencimen
    INDEX saldo    
       valor-saldo
    INDEX abrev    
       nome-abrev
    INDEX docto    
       nr-docto
    INDEX fornec   
       cod-fornec.
    
def temp-table tt-erro-pag no-undo
    field i-cod-erro        as integer format "9999999"
    field c-desc-erro       as char format "x(70)"
    field c-arquivo-erro    as char format "x(100)".

def temp-table tt-digita no-undo like tt-tit-ap.

def buffer b-tt-digita for tt-digita.

def temp-table tt-raw-digita no-undo
    field raw-digita  as raw.

/* Fim de Include */
