/**********************************************************************************
**
**  apapi011.i
**
**  Defini‡Æo das temp-tableïs.
**
**********************************************************************************/

def temp-table tt-movto no-undo
    field r-tit-ap         as rowid
    field r-mov-ap         as rowid
    field cod-versao-integ as integer
    field l-vid-rel        as logical.

def temp-table tt-mov-ap no-undo
    field cod-conta    as character format "x(25)" label "Conta"
    field titulo       like conta-contab.titulo
    field valor        like mov-ap.valor-mov
    field lancto       as character format "XX" label "Lan‡amento" column-label "Lan‡amento" .
    
def temp-table tt-erro-mov-ap no-undo
    field i-cod-erro        as integer format "9999999"
    field c-desc-erro       as char format "x(70)"
    field c-arquivo-erro    as char format "x(100)".

/* apapi011.i */
