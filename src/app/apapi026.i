/********************************************************************************
***
*** app/apapi026.i - Defini‡Æo de TempTables
***
********************************************************************************/
            
def temp-table tt-tit-ap-aut no-undo
    field cod-versao-integ as int
    field ep-codigo        like tit-ap.ep-codigo
    field cod-fornec       like tit-ap.cod-fornec
    field cod-estabel      like tit-ap.cod-estabel
    field cod-esp          like tit-ap.cod-esp
    field serie            like tit-ap.serie
    field nr-docto         like tit-ap.nr-docto
    field parcela          like tit-ap.parcela
    field tp-pagto         like tit-ap.tp-pagto

    INDEX tt_index IS PRIMARY cod-versao-integ
                              ep-codigo
                              cod-fornec
                              cod-estabel
                              cod-esp
                              serie
                              nr-docto
                              parcela.
                
def temp-table tt-retorno_api no-undo
    field i-sequen   as int
    field cd-erro    as int
    field mensagem   as char format "x(255)"
    field parametros as char format "x(255)" init ""
    field cod-chave  as char format "x(255)" init ""

    INDEX tt_index IS PRIMARY cd-erro
                              cod-chave.
    
/* Fim de Include */
