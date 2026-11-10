/******************************************************************************
***
***   AP1002.I1
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
    field l-mant-refer      as logical
    field i-doc-cb          as char
    field i-op-banco        as integer
    field c-arquivo-entrada as char
    field l-vid-rel         as logical
    field cod-versao-integ  as integer.

def temp-table tt-digita
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id is primary unique ordem.

/* Fim de Include */

