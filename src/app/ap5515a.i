/************************************************************************
***
*** app/ap5515a.i - Defini‡Æo Temp-Table.
***
************************************************************************/

def temp-table tt-documento like bord-tit
    field log-normal      as logical
    field log-erro        as logical
    field desc-erro       as char
    field row-docto       as rowid
    field row-tit-ap      as rowid
    field log-selecionado as logical
    field dt-transacao    as date
    field tp-codigo       like tipo-rec-desp.tp-codigo
    field tp-descricao    like tipo-rec-desp.descricao
    field nome-emit       like emitente.nome-emit
    field tp-pagto        as integer
    field transacao       like bordero-ap.transacao
    INDEX codigo IS UNIQUE PRIMARY row-docto ASCENDING
    INDEX selecionado log-selecionado ASCENDING.

/* Fim de Include */
