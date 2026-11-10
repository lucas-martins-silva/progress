/**************************************************************************
**
**   Include: BCAPI005.I - Definicao da temp-table Codigo unico
**
***************************************************************************/

def temp-table tt-cod-unico NO-UNDO
    field cod-versao-integracao     as int
    field it-codigo                 as char     format "X(16)"
    field cod-estabel               LIKE estabelec.cod-estabel
    field cod-depos                 as char     format "X(03)"
    field cod-localiz               as char     format "X(20)"
    field lote                      as char     format "X(10)"
    field cod-unico                 as char     format "X(16)"
    field opcao                     as integer  format "99"
    field rowid-bc                  as rowid.
    
