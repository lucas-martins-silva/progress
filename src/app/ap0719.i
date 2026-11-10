/********************************************************************
***
***  app/ap0719.i - Defini‡Æo Temp-Table.
***
********************************************************************/
/* y2kready */

def temp-table tt-param no-undo
    field destino                       as integer
    field arquivo                       as character
    field usuario                       as character
    field data-exec                     as date
    field hora-exec                     as integer
    field classifica                    as integer
    field desc-classifica               as character
    field ep-codigo                     as integer
    field i-ano-base                    as integer
    field l-natureza                    as logical
    field l-estrangeiro                 as logical
    field c-arq                         as character
    field l-cgc                         as logical
    field i-tipo                        as integer
    field c-estabel                     as character
    field c-funcionario                 as character
    field c-cpf-func                    as character
    field i-ddd-func                    as integer
    field i-tel-func                    as integer
    field i-ramal-func                  as integer
    field i-fax-func                    as integer
    field c-mail-func                   as character
    field c-cpf-responsavel             as character
    field l-ind-depos                   as logical
    field l-ind-evento                  as logical
    field da-evento                     as date
    field i-opcao                       as int
    field c-ult-decla                   as char
    field l-ostensivo                   as logical
    field l-importa-arquivo             as log
    field c-diretorio-imp               as char
    field de-min-rendto-pf-pj           as decimal
    field de-min-rendto-pe-e-nao-tribut as decimal
    field l-min-redto-pessoa-fisica     as logical                                     
    field l-min-redto-pessoa-juridica   as logical.

/* Fim de Include */

