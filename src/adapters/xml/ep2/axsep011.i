DEFINE TEMP-TABLE ttMonitorFaixa_ENV NO-UNDO
     FIELD CodEstabel AS CHARACTER INITIAL ?  /*Cod Estabel - estabelec.cod-estabel*/
     FIELD ID_ENT     AS CHARACTER INITIAL ?  /*ID Ent - param-nf-estabelec.ind-empresa*/
     FIELD ChaveNFe   AS CHARACTER INITIAL ?  /*Chave da NF-e a ser Consultada*/
     INDEX ch-CodEstabel CodEstabel
.
