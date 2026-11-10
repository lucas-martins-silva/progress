DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                AS INTEGER
    FIELD arquivo                AS CHARACTER FORMAT "x(35)":U
    FIELD usuario                AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec              AS DATE
    FIELD hora-exec              AS INTEGER
    FIELD dt-alter-ini           AS DATE      FORMAT "99/99/9999"
    FIELD dt-alter-fim           AS DATE      FORMAT "99/99/9999"
    FIELD dt-trans-ini           AS DATE      FORMAT "99/99/9999"
    FIELD dt-trans-fim           AS DATE      FORMAT "99/99/9999"
    FIELD num-carg-ini           AS INTEGER   FORMAT ">>>,>>>,>>9":U
    FIELD num-carg-fim           AS INTEGER   FORMAT ">>>,>>>,>>9":U    
    FIELD cod-estab-ini          AS CHARACTER FORMAT "X(15)":U
    FIELD cod-estab-fim          AS CHARACTER FORMAT "X(15)":U
    FIELD cod-usuar-ini          AS CHARACTER FORMAT "X(12)":U
    FIELD cod-usuar-fim          AS CHARACTER FORMAT "X(12)":U
    FIELD emissao                AS INTEGER 
    FIELD imp-param              AS LOGICAL. 
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "X(30)":U
    INDEX id ordem.    
    
DEF TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita AS RAW.
