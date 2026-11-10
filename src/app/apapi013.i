/**********************************************************************************
**
**  apapi013.i 
**
**  Defini‡Æo de temp-tables.
**
**********************************************************************************/
{app/ap5515a.i}

def temp-table tt-confirma no-undo
    field r-bord-rec        as rowid
    field l-vid-rel         as logical
    field cod-versao-integ  as integer
    field c-usuario         as character format "x(12)".

def temp-table tt-erro-conf no-undo
    field i-cod-erro        as integer format "9999999"
    field c-desc-erro       as char format "x(70)"
    field c-arquivo-erro    as char format "x(100)".
