DEFINE TEMP-TABLE tt-cond-pagto
    FIELD cod-cond-pag     LIKE cond-pagto.cod-cond-pag
    FIELD descricao          LIKE cond-pagto.descricao
    INDEX ch-codigo IS PRIMARY cod-cond-pag .

DEFINE TEMP-TABLE tt-tab-unidade
    FIELD Un                 LIKE tab-conv-un.un
    FIELD descricao          LIKE tab-conv-un.descricao
    INDEX ch-codigo IS PRIMARY un .

DEFINE TEMP-TABLE tt-natur-oper
    FIELD nat-operacao      LIKE natur-oper.nat-operacao
    FIELD denominacao          LIKE natur-oper.denominacao
    INDEX ch-codigo IS PRIMARY nat-operacao .

DEFINE TEMP-TABLE tt-cliente
    FIELD cod-emitente     LIKE emitente.cod-emitente
    FIELD nome-abrev          LIKE emitente.nome-abrev
    INDEX ch-codigo IS PRIMARY cod-emitente.

DEFINE TEMP-TABLE tt-fornec
    FIELD cod-emitente     LIKE emitente.cod-emitente
    FIELD nome-abrev          LIKE emitente.nome-abrev
    INDEX ch-codigo IS PRIMARY cod-emitente.

DEFINE TEMP-TABLE tt-transporte
    FIELD cod-transp     LIKE transporte.cod-transp
    FIELD nome-abrev       LIKE transporte.nome-abrev
    INDEX ch-codigo IS PRIMARY cod-transp.


DEFINE TEMP-TABLE tt-Serie
    FIELD Serie     LIKE serie.serie
    INDEX ch-codigo IS PRIMARY Serie.


DEFINE TEMP-TABLE tt-moeda
    FIELD mo-codigo     LIKE moeda.mo-codigo
    FIELD descricao     LIKE moeda.descricao
    INDEX ch-codigo IS PRIMARY mo-codigo.

DEFINE TEMP-TABLE tt-item
    FIELD it-codigo     LIKE ITEM.it-codigo
    FIELD desc-item     LIKE ITEM.desc-item
    INDEX ch-codigo IS PRIMARY it-codigo.

DEFINE TEMP-TABLE via-transporte 
        FIELD cod-via    AS INT LABEL "C¢digo" 
        FIELD descricao  AS CHAR   LABEL "Descri‡Æo" FORMAT "X(25)" .

DEFINE TEMP-TABLE tt-via-transporte LIKE via-transporte.

DEFINE TEMP-TABLE tt-item-fornec 
       LIKE item-fornec.

DEFINE TEMP-TABLE tt-b2b-item-fornec
       LIKE item-fornec.

DEFINE TEMP-TABLE tt-item-cli
       LIKE item-cli.

DEFINE TEMP-TABLE tt-b2b-item-cli
       LIKE item-cli.

DEFINE TEMP-TABLE tt-conta-contab
       LIKE conta-contab.

CREATE via-transporte.
ASSIGN via-transporte.cod-via    = 1
       via-transporte.descricao  = "Rodovi rio".
CREATE via-transporte.
ASSIGN via-transporte.cod-via    = 2
       via-transporte.descricao  = "Aerovi rio".
CREATE via-transporte.
ASSIGN via-transporte.cod-via    = 3
       via-transporte.descricao  = "Mar¡tmo".
CREATE via-transporte.
ASSIGN via-transporte.cod-via    = 4
       via-transporte.descricao  = "Ferrovi rio".
CREATE via-transporte.
ASSIGN via-transporte.cod-via    = 5
       via-transporte.descricao  = "RodoFerrovi rio".
CREATE via-transporte.
ASSIGN via-transporte.cod-via    = 6
       via-transporte.descricao  = "RodoFluvial".
CREATE via-transporte.
ASSIGN via-transporte.cod-via    = 7
       via-transporte.descricao  = "RodoAereovi rio".
CREATE via-transporte.
ASSIGN via-transporte.cod-via    = 8
       via-transporte.descricao  = "Outros".
