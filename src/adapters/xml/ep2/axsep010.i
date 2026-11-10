/************************************************************************************************
                               DEFINIÄÂES TEMP-TABLES AXSEP010
************************************************************************************************/

DEFINE TEMP-TABLE ttConsStatServ_ENV NO-UNDO
     FIELD CodEstabel AS CHARACTER INITIAL ?  /*Cod Estabel - estabelec.cod-estabel*/
     FIELD versao     AS CHARACTER INITIAL ?  /*Vers∆o do leiaute*/
     FIELD cUF        AS CHARACTER INITIAL ?  /*C¢digo IBGE da UF consultada*/
     FIELD UF         AS CHARACTER INITIAL ?  /*Sigla da UF consultada*/
     FIELD pais       AS CHARACTER INITIAL ?  /*Pais*/
     FIELD tpAmb      AS CHARACTER INITIAL ?  /*Identificaá∆o do Ambiente: 1 - Produá∆o | 2 - Homologaá∆o*/
     FIELD xServ      AS CHARACTER INITIAL ?  /*Serviáo Solicitado*/
     INDEX ch-CodEstabel IS PRIMARY UNIQUE CodEstabel ASCENDING
.

DEFINE TEMP-TABLE ttConsStatServ_RET NO-UNDO
     FIELD tpAmb             AS CHARACTER INITIAL ?
     FIELD verAplic          AS CHARACTER INITIAL ?
     FIELD cStat             AS CHARACTER INITIAL ?
     FIELD xMotivo           AS CHARACTER INITIAL ?
     FIELD cUF               AS CHARACTER INITIAL ?
     FIELD dhRecbto          AS CHARACTER INITIAL ?
     FIELD tMed              AS CHARACTER INITIAL ?
     FIELD dhRetorno         AS CHARACTER INITIAL ?
     FIELD xObs              AS CHARACTER INITIAL ?
     FIELD CodEstabel        AS CHARACTER INITIAL ?
     FIELD UF                AS CHARACTER INITIAL ?  /*Sigla da UF consultada*/
     INDEX ch-CodEstabel IS PRIMARY UNIQUE CodEstabel ASCENDING
.



/**************************************** FIM AXSEP010.i ***************************************/
