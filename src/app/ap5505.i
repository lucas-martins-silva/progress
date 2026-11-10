def temp-table tt-documento like bord-tit
    field log-normal        as logical
    field row-docto         as rowid
    field row-tit-ap        as rowid
    field log-selecionado   as logical
    FIELD log-impto-vincul  AS LOGICAL FORMAT "Sim/NÆo" LABEL "Tem Impto"
    INDEX codigo IS UNIQUE PRIMARY row-docto ASCENDING.

DEF TEMP-TABLE tt-documento1 NO-UNDO LIKE tt-documento.

def temp-table tt-emitente no-undo
    field cod-emit          like emitente.cod-emit
    field nome-abrev        like emitente.nome-abrev
    INDEX chave IS PRIMARY cod-emit ASCENDING.
