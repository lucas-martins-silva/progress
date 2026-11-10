/********************************************************************************
***
*** app/apapi001.i - TempTables API implanta‡Æo de hist¢ricos.
***
********************************************************************************/


def temp-table tt-his-d-ap
    field ep-codigo                    as integer     format ">>9"
    field cod-estabel                  as char        format "x(3)"
    field cod-esp                      as char        format "!!"
    field serie                        as char        format "x(5)"
    field nr-docto                     as char        format "x(16)"
    field parcela                      as char        format "x(2)"
    field data                         as date        format "99/99/9999"
    field sequencia                    as integer     format "99"
    field historico                    as char        format "x(15000)"
    field cod-fornec                   as integer     format ">>>>>>>>9"
    field cod-versao-integ             as integer     format "999"        init 0.

def temp-table tt-retorno-erros
     field cod-erro   as character format "x(10)"
     field desc-erro  as character format "x(60)"
                         view-as editor max-chars 2000 
                         scrollbar-vertical size 50 by 4
     field situacao   as logical
     field cod-chave  as character
     INDEX ch-codigo  IS PRIMARY cod-erro
                                 cod-chave.
        
/* Fim de Include */
