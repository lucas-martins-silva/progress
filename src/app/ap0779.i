/*********************************************************************************
***
***  crp/ap0779.i - Defini‡Æo de temp-table's
***
**********************************************************************************/

def temp-table tt-param
    field destino            as integer
    field arquivo            as char
    field usuario            as char
    field i-ep-codigo        as integer
    field data-exec          as date
    field hora-exec          as integer
    field cod-layout         as character
    field nom-arquivo        as character
    field diretorio          as character
    field l-transfere        as logical
    field l-conc-autom       as logical
    field l-imp-sacador      as logical.

def temp-table tt-digita
    field cod-portador       as integer
    field modalidade         as integer
    field arquivo            as char
    field mensagem           as char
    field i-mensag           as integer
    field mensagem-real20    as char    extent 20
    field local-real20       as integer extent 20.

/* Final Include */


