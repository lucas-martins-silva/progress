DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                  AS INTEGER
    FIELD arquivo                  AS CHARACTER FORMAT "x(35)":U
    FIELD usuario                  AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec                AS DATE
    FIELD hora-exec                AS INTEGER
    FIELD classifica               AS INTEGER
    FIELD desc-classifica          AS CHARACTER FORMAT "x(40)":U
    FIELD modelo                   AS CHARACTER FORMAT "x(35)":U
    FIELD l-habilitaRtf            AS LOGICAL
    FIELD cod-pto-coleta-ini       LIKE pto-coleta.cod-pto-coleta
    FIELD cod-pto-coleta-fim       LIKE pto-coleta.cod-pto-coleta
    FIELD cod-propried-ini         LIKE propried-rural.cod-propried
    FIELD cod-propried-fim         LIKE propried-rural.cod-propried
    FIELD cdn-produt-rural-ini     LIKE produt-rural.cdn-produt-rural
    FIELD cdn-produt-rural-fim     LIKE produt-rural.cdn-produt-rural
    FIELD cod-rota-ini             LIKE rota-coleta.cod-rota
    FIELD cod-rota-fim             LIKE rota-coleta.cod-rota
    FIELD l-somente-pto-coletivo   AS LOGICAL
    FIELD l-somente-produt-respons AS LOGICAL
    FIELD l-inativos               AS LOGICAL.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem                  AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo                AS CHARACTER FORMAT "X(30)":U
    INDEX id ordem.
    
DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita             AS RAW.
