/********************************************************************************
***
*** app/ap0521b.i - Defini‡Æo TempTable.
***
********************************************************************************/

def temp-table tt-documento like bord-tit
    field log-normal      as logical
    field row-docto       as rowid
    field log-selecionado as logical
    field dt-transacao    as date
    field tp-codigo       like tipo-rec-desp.tp-codigo
    field tp-descricao    like tipo-rec-desp.descricao
    field nome-emit       like emitente.nome-emit
    field transacao       like bordero-ap.transacao
    INDEX codigo IS UNIQUE PRIMARY row-docto ASCENDING.

/* Fim de Include */
