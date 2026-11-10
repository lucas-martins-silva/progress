/* DEFINICAO TEMP-TABLES AQ0326 */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino            AS INTEGER
    FIELD arquivo            AS CHAR FORMAT "x(35)":U
    FIELD usuario            AS CHAR FORMAT "x(12)":U
    FIELD data-exec          AS DATE
    FIELD hora-exec          AS INTEGER
    FIELD classifica         AS INTEGER
    FIELD desc-classifica    AS CHAR FORMAT "x(40)":U
    FIELD cod-estabel        AS CHAR FORMAT "x(5)":U
    FIELD cod-periodo        AS CHAR FORMAT "99/9999"
    FIELD it-codigo          AS CHAR FORMAT "X(16)":U
    FIELD envia-email-transp AS LOGICAL
    FIELD envia-email-cc     AS LOGICAL
    FIELD email-cc           AS CHAR FORMAT "x(120)":U
    FIELD origem-xml         AS CHAR FORMAT "x(255)":U 
    FIELD destino-xml        AS CHAR FORMAT "x(255)":U
    FIELD cod-regiao-ini     AS CHAR FORMAT "x(12)":U
    FIELD cod-regiao-fim     AS CHAR FORMAT "x(12)":U
    FIELD cod-rota-ini       AS CHAR FORMAT "x(12)":U
    FIELD cod-rota-fim       AS CHAR FORMAT "x(12)":U
    FIELD cod-transp-ini     AS INTEGER
    FIELD cod-transp-fim     AS INTEGER
    FIELD tipo-integr        AS CHAR FORMAT "X(5)":U
    FIELD remetente          AS CHAR FORMAT "x(120)":U
    FIELD nome-estabel       AS CHARACTER
    FIELD desc-item          AS CHARACTER
    FIELD imp-param          AS LOGICAL.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD cod-transp       LIKE transpdor-coleta.cod-transp COLUMN-LABEL "Transportador"
    FIELD descricao        AS CHARACTER FORMAT "x(150)":U   COLUMN-LABEL "Nome Transportador"
    FIELD nome-abrev       AS CHARACTER FORMAT "x(12)":U    
    FIELD email            AS CHARACTER FORMAT "x(120)":U   COLUMN-LABEL "E-mail"
    INDEX id cod-transp.
    
DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
      