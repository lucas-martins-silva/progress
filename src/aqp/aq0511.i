/******************************************************************************
** Include:   AQ0511.i -  Defini‡Æo da tt-param                              **
** Programas: AQ0511.w                                                       **
**            AQ0511rp.p                                                     **
**            AQ0511a.p                                                      **
******************************************************************************/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino              AS INTEGER
    FIELD execucao             AS INTEGER
    FIELD arquivo              AS CHAR format "x(35)":U
    FIELD usuario              AS CHAR format "x(12)":U
    FIELD data-exec            AS DATE
    FIELD hora-exec            AS INTEGER
    FIELD cod-rota-ini         AS CHARACTER
    FIELD cod-rota-fim         AS CHARACTER
    FIELD cdn-grp-produt-ini   AS INTEGER 
    FIELD cdn-grp-produt-fim   AS INTEGER 
    FIELD cdn-produt-rural-ini AS INTEGER 
    FIELD cdn-produt-rural-fim AS INTEGER 
    FIELD cod-estabel          AS CHARACTER
    FIELD cod-pto-coleta-ini   AS CHARACTER
    FIELD cod-pto-coleta-fim   AS CHARACTER
    FIELD period               AS CHARACTER FORMAT "99/9999"
    FIELD it-codigo            AS CHARACTER
    FIELD list-qtd-zerada      AS LOGICAL.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD id AS INTEGER. 

DEFINE TEMP-TABLE tt-produtor
    FIELD cdn-produt-rural     AS INTEGER
    FIELD nome-produt          AS CHARACTER
    FIELD desc-rota            AS CHARACTER
    FIELD cod-estabel          AS CHARACTER
    FIELD cod-propried         AS CHARACTER
    FIELD des-propried         AS CHARACTER
    FIELD cod-pto-coleta       AS CHARACTER
    FIELD cod-inscr-imob-rural AS CHARACTER /*propried-rural.cod-inscr-imob-rural*/
    FIELD cod-rota-princ       AS CHARACTER /*propried-rural.cod-rota-princ*/
    FIELD dat-coleta           AS DATE  
    FIELD dia                  AS INTEGER EXTENT 31
    FIELD coleta               AS INTEGER EXTENT 31
    FIELD total-coleta         AS INTEGER
    FIELD cdn-grp-produt       AS INTEGER
    FIELD des-grp-produt       AS CHARACTER.
