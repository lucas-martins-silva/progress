/********************************************************************************
***
*** app/apapi020b.i - Defini‡Æo TempTable.
***
********************************************************************************/

def temp-table tt-param
    field cod-versao-integracao as integer format "999"
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field i-ep-codigo      like empresa.ep-codigo 
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field estabel          like tit-ap.cod-estabel
    field espec            like tit-ap.cod-esp
    field serie-ini        like tit-ap.serie
    field serie-fim        like tit-ap.serie
    field docto-ini        like tit-ap.nr-docto
    field docto-fim        like tit-ap.nr-docto
    field parc-ini         like tit-ap.parcela
    field parc-fim         like tit-ap.parcela
    field forn-ini         like tit-ap.cod-fornec
    field forn-fim         like tit-ap.cod-fornec
    field emis-ini         like tit-ap.dt-emissao
    field emis-fim         like tit-ap.dt-emissao
    field ref-ini          like tit-ap.referencia
    field ref-fim          like tit-ap.referencia
    FIELD trans-ini        LIKE tit-ap.dt-transacao
    FIELD trans-fim        LIKE tit-ap.dt-transacao
    FIELD venc-ini         LIKE tit-ap.dt-vencimen
    FIELD venc-fim         LIKE tit-ap.dt-vencimen
    FIELD prev-com-saldo   AS LOGICAL
    FIELD prev-sem-saldo   AS LOGICAL
    FIELD prev-pefs        AS LOGICAL
    field verifica-movto   as logical.


def temp-table tt-digita
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id is primary unique
        ordem.

def temp-table tt-erro-retorno no-undo
    field ep-codigo         like titulo.ep-codigo
    field cod-estabel       like titulo.cod-estabel
    field cod-esp           like titulo.cod-esp
    field serie             like titulo.serie
    field cod-fornec        like mov-ap.cod-fornec
    field nr-docto          like titulo.nr-docto
    field parcela           like titulo.parcela
    field cod-erro          as integer     format ">>>>>>>>9"
    field desc-erro         as character format "x(200)".

def temp-table tt-titulo like tit-ap.
            
/* Fim de Include */


