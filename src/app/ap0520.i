/******************************************************************************
***       
*** app/ap0520.i - Gera‡Æo Dados DIRF PJ - Temp-tableïs.
***
******************************************************************************/

def temp-table tt-param no-undo
    field ep-codigo            as integer
    field destino              as integer
    field arquivo              as char format "x(35)"
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field modelo-rtf           as char format "x(35)"
    field l-habilitaRtf        as log
    field c-estab-ini          as char
    field c-estab-fim          as char
    field c-esp-ini            as char
    field c-esp-fim            as char
    field i-fornec-ini         as integer format ">>>>>>>>9"
    field i-fornec-fim         as integer format ">>>>>>>>9"
    field i-grupo-ini          as integer
    field i-grupo-fim          as integer
    field i-opcao              as integer
    field i-imposto            as integer
    field dt-data-ini          as date
    field dt-data-fim          as date
    field l-cod-zero           as logical
    field l-estrangeiro        as logical
    field l-substituicao       as logical
    field l-planilha           as logical
    field c-arq-planilha       as char
    field c-caracter           as char
    field l-gerar-pis          as log
    field c-esp-pis            as char
    field c-ret-pis            as int
    field l-baixa              as log
    field l-subst-normal       as log
    field i-fato-gerador       as int
    field val-min-rendimento   as dec form ">>>,>>>,>>9.99"
    field l-for-ret-pagto      as log
    field c-cod-nom-resp       AS CHAR FORMAT "X(30)".

def temp-table tt-digita no-undo
    field cod-esp              like espec-ap.cod-esp
    field descricao            like espec-ap.descricao
    field tipo                 as char format "x(25)" label "Tipo Esp‚cie"
    field log-sel              as log
    field tipo-impto           as char format "x(6)"
    index espec cod-esp.

def temp-table tt-raw-digita no-undo
    field raw-digita           as raw.

def temp-table tt-retencao no-undo
    field codigo               like dirf-ap.cod-retensao
    field cod-esp              like dirf-ap.cod-esp
    field tot-reg              as integer format ">>>>>>9"
    field vl-tot-rend          like dirf-ap.vl-rend-trib
    field vl-tot-impto         like dirf-ap.valor-ir
    index codigo codigo cod-esp.

def temp-table tt-dirf-ap no-undo like dirf-ap 
    field nome-abrev           like emitente.nome-abrev
    field valor-saldo          like tit-ap.valor-saldo
    field dt-emissao           like tit-ap.dt-emissao
    field ind-orig             as char format "x(13)" label "Origem"
    field cod-impto            like tit-ap.cod-impto-ret
    field cod-gr-forn          like emitente.cod-gr-forn
    field row-tit-ap           as rowid
    index row-tit-ap row-tit-ap
    index codigo ep-codigo
                 cod-fornec
                 cod-estabel
                 cod-esp
                 serie
                 nr-docto
                 parcela
    index listagem cod-retensao
                   dt-implant
                   dt-pagto
                   cod-estabel
                   cod-fornec
                   cod-esp 
                   serie 
                   nr-docto 
                   parcela.
def temp-table tt-dirf-ap-in511 no-undo
    field ep-codigo            like dirf-ap.ep-codigo
    field cod-fornec           like dirf-ap.cod-fornec
    field cod-estab            like dirf-ap.cod-estab
    field cod-periodo          as integer format ">>>9"
    field cod-impto            like tit-ap.cod-impto-ret
    field vl-rend-trib         like dirf-ap.vl-rend-trib
    field valor-ir             like dirf-ap.valor-ir
    index codigo ep-codigo
                 cod-fornec
                 cod-estab
                 cod-periodo
                 cod-impto.
/* Fim Include */
