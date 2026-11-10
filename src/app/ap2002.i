/******************************************************************************
***
***   AP2002.I1
***   Objetivo: Definicao de temp-table's.
***
******************************************************************************/

def temp-table tt-param
    field destino           as integer
    field arquivo           as char format "x(50)"
    field usuario           as char format "x(12)"
    field data-exec         as date
    field hora-exec         as integer
    field i-empresa         as integer
    field i-portador        as integer
    field c-referencia      as char
    field l-atualiza        as logical 
    field i-doc-cb          as char
    field i-op-banco        as integer
    field c-arquivo-entrada as char
    field l-vid-rel         as logical
    field cod-versao-integ  as integer.

def temp-table tt-gps       no-undo
    field nr-gps            as char
    field vl-gps            as decimal
    field cod-situacao      as integer
    field descricao         as char
    field vl-titulos        as decimal
    field dt-baixa          as date
    field livre             as char
    index chave cod-situacao
                nr-gps.

def temp-table tt-tit-gps   no-undo
    field ep-codigo         as integer
    field cod-estabel       like tit-ap.cod-estabel
    field cod-esp           like tit-ap.cod-esp
    field serie             like tit-ap.serie
    field nr-docto          like tit-ap.nr-docto
    field parcela           like tit-ap.parcela
    field cod-fornec        like tit-ap.cod-fornec
    field cod-ret           like tit-ap.cod-ret
    field nr-bordero        like tit-ap.nr-bordero
    field dt-transacao      like tit-ap.dt-transacao
    field dt-vencimen       like tit-ap.dt-vencimen
    field vl-original       like tit-ap.vl-original 
    field vl-saldo          like tit-ap.valor-saldo
    field nome-abrev        like tit-ap.nome-abrev
    field titulo-banco      like tit-ap.titulo-banco
    field cod-port          like tit-ap.portador
    field situacao          as char format "X(10)"
    field observacao        like tit-ap.observacao
    index chave titulo-banco
                ep-codigo
                cod-estabel
                cod-fornec
                cod-esp
                serie
                nr-docto
                parcela.

def temp-table tt-digita
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id is primary unique ordem.

/* Fim de Include */

