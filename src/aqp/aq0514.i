/******************************************************************************
** Include:   AQ0514.i -  Defini‡Æo da tt-param                              **
** Programas: AQ0514.w                                                       **
**            AQ0514rp.p                                                     **
******************************************************************************/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD usuario              AS CHARACTER format "x(12)":U
    FIELD destino              AS INTEGER
    FIELD data-exec            AS DATE
    FIELD hora-exec            AS INTEGER
    FIELD d-data-ini           AS DATE
    FIELD d-data-fim           AS DATE
    FIELD cdn-produt-rural-ini AS INTEGER
    FIELD cdn-produt-rural-fim AS INTEGER
    FIELD cdn-grp-produt-ini   AS INTEGER 
    FIELD cdn-grp-produt-fim   AS INTEGER 
    FIELD cod-estabel-ini      AS CHARACTER
    FIELD cod-estabel-fim      AS CHARACTER
    FIELD arquivo              AS CHARACTER format "x(35)":U
    FIELD execucao             AS INTEGER
    FIELD imp-param            AS LOGICAL
    FIELD i-classif            AS INTEGER.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD id AS INTEGER. 
    

DEFINE TEMP-TABLE tt-dados-cargas-rurais NO-UNDO
    FIELD num-carg             AS INTEGER
    FIELD cdn-produt-rural     AS INTEGER
    FIELD nome-emitente        AS CHARACTER FORMAT "x(80)":U
    FIELD cod-propried         AS CHARACTER FORMAT "x(30)":U
    FIELD des-propried         AS CHARACTER FORMAT "x(60)":U
    FIELD cod-pto-coleta       AS CHARACTER FORMAT "x(12)":U
    FIELD des-pto-coleta       AS CHARACTER FORMAT "x(40)":U
    FIELD dat-trans            AS DATE
    FIELD cod-estabel          AS CHARACTER FORMAT "x(5)":U
    FIELD cdn-produt-respons   AS INTEGER
    FIELD qtd-coleta           AS DECIMAL
    FIELD cdn-compart          AS INTEGER
    FIELD val-temperat         AS DECIMAL
    FIELD cod-amostra          AS CHARACTER
    FIELD cod-lacre            AS CHARACTER
    FIELD cdn-repos            AS INTEGER
    FIELD cdn-motiv-nao-coleta AS INTEGER
    FIELD dat-coleta           AS DATE
    FIELD hra-coleta           AS CHARACTER FORMAT "99:99:99":U
    FIELD des-motivo           AS CHARACTER FORMAT "x(80)":U.
    





