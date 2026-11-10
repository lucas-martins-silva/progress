/**************************************************************************
**
**   Include: BCAPI006.I - Definicao da temp-table Coletor
**
***************************************************************************/

def temp-table tt-coletor NO-UNDO
    field cod-versao-integracao     as int
    field usuario                   as char format "X(12)"
    field coletor                   as char format "X(08)"
    field ativo                     as logical
    field diretorio                 as char format "X(50)"
    field nome-arq                  as char format "X(12)"
    field tp-coletor                as inte format ">9"
    field opcao                     as inte format ">9"
    field rowid-coletor             as rowid.
