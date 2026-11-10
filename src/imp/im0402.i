define temp-table tt-param no-undo
    field destino           as integer
    field arquivo           as char format "x(35)":U
    field usuario           as char format "x(12)":U
    field data-exec         as date
    field hora-exec         as integer
    field classifica        as integer
    field desc-classifica   as char format "x(40)":U
    field modelo            AS char format "x(35)":U
    field execucao          as int    
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf     as LOG
    /*Fim alteracao 15/02/2005*/
    FIELD cCodEstabIni       LIKE decla-import.cod-estab
    FIELD cCodEstabFim       LIKE decla-import.cod-estab
    FIELD cCodEmbarqIni      LIKE decla-import-ord.cod-embarq
    FIELD cCodEmbarqFim      LIKE decla-import-ord.cod-embarq
    FIELD iNumDiEmsIni       LIKE decla-import.num-di-ems
    FIELD iNumDiEmsFim       LIKE decla-import.num-di-ems
    FIELD cCodDiSiscomexIni  LIKE decla-import.cod-di-siscomex
    FIELD cCodDiSiscomexFim  LIKE decla-import.cod-di-siscomex
    FIELD iTipoRelat         AS   INTEGER 
    FIELD lImprimeParametros AS   LOGICAL
.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */
def temp-table tt-raw-digita
   field raw-digita      as raw.
