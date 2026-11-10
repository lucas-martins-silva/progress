DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                AS INTEGER
    FIELD arquivo                AS CHARACTER FORMAT "x(35)":U
    FIELD usuario                AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec              AS DATE
    FIELD hora-exec              AS INTEGER
    FIELD classifica             AS INTEGER
    FIELD desc-classifica        AS CHARACTER FORMAT "x(40)":U
    FIELD modelo                 AS CHARACTER FORMAT "x(35)":U
    FIELD l-habilitaRtf          AS LOGICAL
    FIELD cod-estabel-ini        LIKE carg-rural.cod-estabel
    FIELD cod-estabel-fim        LIKE carg-rural.cod-estabel
    FIELD num-carg-ini           LIKE carg-rural.num-carg
    FIELD num-carg-fim           LIKE carg-rural.num-carg
    FIELD cod-carga-ini          LIKE carg-rural.cod-carga
    FIELD cod-carga-fim          LIKE carg-rural.cod-carga
    FIELD cod-placa-fim          LIKE carg-rural.cod-placa
    FIELD cod-placa-ini          LIKE carg-rural.cod-placa
    FIELD cod-rota-ini           LIKE carg-rural.cod-rota
    FIELD cod-rota-fim           LIKE carg-rural.cod-rota
    FIELD cod-transp-ini         LIKE carg-rural.cod-transp
    FIELD cod-transp-fim         LIKE carg-rural.cod-transp
    FIELD dat-trans-ini          LIKE carg-rural.dat-trans
    FIELD dat-trans-fim          LIKE carg-rural.dat-trans
    FIELD dat-entr-ini           LIKE carg-rural.dat-entr
    FIELD dat-entr-fim           LIKE carg-rural.dat-entr
    FIELD l-pesagem              AS LOGICAL 
    FIELD l-liber-carg           AS LOGICAL
    FIELD l-produtores           AS LOGICAL    
    FIELD l-nc                   AS LOGICAL
    FIELD rs-situacao            AS INTEGER
    FIELD l-imp-param            AS LOGICAL.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem                  AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo                AS CHARACTER FORMAT "X(30)":U
    INDEX id ordem.
    
DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita             AS RAW.  

DEFINE TEMP-TABLE tt-produt-carg-aux NO-UNDO
    FIELD cdn-produt-rural LIKE produt-carg.cdn-produt-rural
    FIELD c-respons        AS   CHARACTER FORMAT "X(3)":U
    FIELD c-nome-emit      AS   CHARACTER FORMAT "X(38)":U
    FIELD qtd-coleta       LIKE produt-carg.qtd-coleta
    FIELD cdn-compart      LIKE produt-carg.cdn-compart
    FIELD c-repos          AS   CHARACTER FORMAT "X(4)":U
    FIELD val-temperat     LIKE produt-carg.val-temperat
    FIELD c-rota-padrao    LIKE pto-rota-coleta.cod-rota
    FIELD cod-pto-coleta   LIKE produt-carg.cod-pto-coleta
    FIELD c-grupo-prod     AS   CHARACTER FORMAT "X(20)":U.