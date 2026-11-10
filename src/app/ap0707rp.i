/********************************************************************************
***
*** app/ap0707rp.i - Defini‡Æo temp-table tt-param.
***
********************************************************************************/

def temp-table tt-param NO-UNDO
    field destino             as INT
    field arquivo             as char
    field usuario             as char
    field data-exec           as date
    field hora-exec           as int
    field classifica          as int
    field text-classif        as char
    field estab-ini           like mov-ap.cod-estabel
    field estab-fim           like mov-ap.cod-estabel
    field espec-ini           like mov-ap.cod-esp
    field espec-fim           like mov-ap.cod-esp
    field dt-transac-ini      like mov-ap.dt-transacao
    field dt-transac-fim      like mov-ap.dt-transacao
    field conta-ini           like mov-ap.conta-contabil
    field conta-fim           like mov-ap.conta-contabil
    field l-imp-histor        as log
    field l-imp-termo         as log
    field moeda               as int
    field i-ep-codigo         like empresa.ep-codigo
    field ref-ini             like mov-ap.referencia init " "
    field ref-fim             like mov-ap.referencia init "ZZZZZZZZZZ"
    field log-pag-parametros  as log
    field label-cab           as int
    field gera-movto-saldo    as log
    field diretorio           as char
    field arq-acomp           as char
    field tipo-armazena       as char
    field l-dados-fiscal      as LOG FORMAT "Sim/NÆo"
    field l-imprime-contra-partida as log format "Sim/NÆo".

def temp-table tt-digita NO-UNDO
    field ordem            as INT  format ">>>>9"
    field exemplo          as char format "x(30)"
    index id is primary unique
        ordem.

def temp-table tt-raw-digita NO-UNDO
    field raw-digita       as raw.

def temp-table tt_movimentos no-undo
    field ep-codigo        like diario-ap.ep-codigo
    field cod-estabel      like diario-ap.cod-estabel
    field ano-periodo        as char
    field conta-contabil   like diario-ap.conta-contabil
    field ct-codigo        like diario-ap.ct-conta
    field sc-codigo        like diario-ap.sc-conta
    field data             like diario-ap.dt-transacao
    field valor            like diario-ap.vl-credito
    field transacao          as int
    field historico        like diario-ap.historico
    field num-arquivamento like mov-ap.nr-docto
    field cod-emitente     like diario-ap.cod-fornec
    field contra-partida    as char format "x(17)"
    field rowid-mov-ap      as char.

DEF TEMP-TABLE tt_log_erros NO-UNDO
    FIELD ttv_num_seq       AS INT  FORMAT ">>>,>>9"  LABEL "Sequˆncia" COLUMN-LABEL "Seq"
    FIELD ttv_num_cod_erro  AS INT  FORMAT ">>>>,>>9" LABEL "N£mero" COLUMN-LABEL "N£mero"
    FIELD ttv_des_erro      AS CHAR FORMAT "x(50)"    LABEL "Inconsistˆncia" COLUMN-LABEL "Inconsistˆncia"
    FIELD ttv_des_ajuda     AS CHAR FORMAT "x(50)"    LABEL "Ajuda" COLUMN-LABEL "Ajuda".

/* Fim de Include */

