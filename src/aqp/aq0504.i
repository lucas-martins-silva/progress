DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                AS INTEGER
    FIELD arquivo                AS CHARACTER FORMAT "x(35)":U
    FIELD usuario                AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec              AS DATE
    FIELD hora-exec              AS INTEGER
    FIELD cod-transp-ini         AS INTEGER
    FIELD cod-transp-fim         AS INTEGER
    FIELD dt-trans-ini           AS DATE
    FIELD dt-trans-fim           AS DATE
    FIELD num-carg-ini           AS INTEGER   FORMAT ">>>,>>>,>>9":U
    FIELD num-carg-fim           AS INTEGER   FORMAT ">>>,>>>,>>9":U    
    FIELD cod-estab-ini          AS CHARACTER FORMAT "X(5)":U
    FIELD cod-estab-fim          AS CHARACTER FORMAT "X(5)":U
    FIELD cod-rota-ini           AS CHARACTER FORMAT "X(12)":U
    FIELD cod-rota-fim           AS CHARACTER FORMAT "X(12)":U
    FIELD it-codigo-ini          AS CHARACTER FORMAT "X(16)":U
    FIELD it-codigo-fim          AS CHARACTER FORMAT "X(16)":U
    FIELD codigo-rejei-ini       AS INTEGER   FORMAT ">>9":U
    FIELD codigo-rejei-fim       AS INTEGER   FORMAT ">>9":U
    FIELD cons-toler             AS LOGICAL
    FIELD emissao                AS INTEGER 
    FIELD imp-param              AS LOGICAL. 
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "X(30)":U
    INDEX id ordem.    
    
DEF TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita AS RAW.