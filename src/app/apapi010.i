/*********************************************************************************
**
**  apapi010.i
**
**  Definni‡Æo temp-table de erros.
**
**********************************************************************************/

def temp-table tt-erro-ret no-undo
    field i-cod-erro        as integer format "9999999"
    field c-desc-erro       as char format "x(70)"
    field c-arquivo-erro    as char format "x(100)".
