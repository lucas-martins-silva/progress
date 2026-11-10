/**********************************************************************************
**
** APAPI009.i
**
** Defini‡Æo temp-tableïs
**
***********************************************************************************/

def temp-table tt-referencia no-undo
    field i-ep-codigo      like mov-pef-pend.ep-codigo
    field c-referencia     like mov-pef-pend.referencia
    field cod-versao-integ as int
    field c-usuario        like mov-ap.usuario
    field l-vid-rel        as log 
    field l-acompanha      as log.
                 
def temp-table tt-erro-pef no-undo
    field i-cod-erro        as integer format "9999999"
    field c-desc-erro       as char format "x(70)"
    field c-arquivo-erro    as char format "x(100)".

/* apapi009.i */
