define temp-table tt-param no-undo
    FIELD c-num-di-ems-ini      LIKE decla-import.num-di-ems
    FIELD c-num-di-ems-fim      LIKE decla-import.num-di-ems
    FIELD c-num-di-siscomex-ini LIKE decla-import.cod-di-siscomex
    FIELD c-num-di-siscomex-fim LIKE decla-import.cod-di-siscomex
    FIELD c-data-di-ini         LIKE decla-import.dat-di
    FIELD c-data-di-fim         LIKE decla-import.dat-di
    FIELD c-estab-ini           LIKE decla-import.cod-estab
    FIELD c-estab-fim           LIKE decla-import.cod-estab
    field destino               as integer
    field arquivo               as char format "x(35)":U
    field usuario               as char format "x(12)":U
    field data-exec             as date
    field hora-exec             as integer
    field classifica            as integer
    field desc-classifica       as char format "x(40)":U
    field modelo                AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG.
    /*Fim alteracao 15/02/2005*/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.
