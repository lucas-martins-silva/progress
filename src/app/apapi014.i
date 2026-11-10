/**********************************************************************************
**
**  APAPI014.I
**
** Defini‡Æo de temp-tables.
**
**********************************************************************************/

def temp-table tt-mov-ap no-undo 
    field ep-codigo        like mov-ap.ep-codigo
    field cod-estabel      like mov-ap.cod-estabel
    field cod-esp          like mov-ap.cod-esp
    field serie            like mov-ap.serie
    field nr-docto         like mov-ap.nr-docto
    field parcela          like mov-ap.parcela
    field cod-fornec       like mov-ap.cod-fornec
    field portador         like mov-ap.portador
    field historico        like mov-ap.historico
    field usuario          like mov-ap.usuario
    field cb-trans         as char
    field l-vid-rel        as logical
    field cod-versao-integ as int.

def temp-table tt-erro-sus no-undo
    field i-cod-erro        as int  format "9999999"
    field c-desc-erro       as char format "x(70)"
    field c-arquivo-erro    as char format "x(100)".

/* app/apapi014.i */
