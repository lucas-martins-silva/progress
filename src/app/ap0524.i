define temp-table tt-param no-undo
    FIELD ep-codigo             AS INTEGER
    field destino               as integer
    field arquivo               as char format "x(35)"
    field usuario               as char format "x(12)"
    field data-exec             as date
    field hora-exec             as integer
    field modelo-rtf            as char format "x(35)"
    field l-habilitaRtf         as LOG
    FIELD i-opcao               AS INT
    FIELD c-estab-ini           AS CHAR
    FIELD c-estab-fim           AS CHAR
    FIELD i-fornec-ini          AS INTEGER FORMAT ">>>>>>>>9"
    FIELD i-fornec-fim          AS INTEGER FORMAT ">>>>>>>>9"
    FIELD i-grupo-ini           AS INTEGER
    FIELD i-grupo-fim           AS INTEGER
    FIELD i-retencao-ini        AS INTEGER
    FIELD i-retencao-fim        AS INTEGER
    FIELD l-normal              AS LOGICAL
    FIELD l-antecipacao         AS LOGICAL
    FIELD l-ir                  AS LOGICAL
    FIELD l-pis                 AS LOGICAL
    FIELD dt-data-ini           AS DATE
    FIELD dt-data-fim           AS DATE
    FIELD de-rendto-ini         AS DEC FORMAT ">>>,>>>,>>>,>>9.99"
    FIELD de-rendto-fim         AS DEC FORMAT ">>>,>>>,>>>,>>9.99"
    FIELD de-impto-ini          AS DEC FORMAT ">>>,>>>,>>>,>>9.99"
    FIELD de-impto-fim          AS DEC FORMAT ">>>,>>>,>>>,>>9.99"
    FIELD l-elimina-reg-manual  AS LOGICAL.

DEF temp-table tt-digita NO-UNDO
    FIELD cod-esp          LIKE espec-ap.cod-esp
    FIELD descricao        LIKE espec-ap.descricao
    FIELD tipo             AS CHAR FORMAT "x(25)" LABEL "Tipo Esp‚cie"
    FIELD log-sel          AS LOG
    INDEX espec cod-esp.

def temp-table tt-raw-digita NO-UNDO
   field raw-digita      as raw.
