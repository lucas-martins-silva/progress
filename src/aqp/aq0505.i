DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                AS INTEGER
    FIELD arquivo                AS CHARACTER FORMAT "x(35)":U
    FIELD usuario                AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec              AS DATE
    FIELD hora-exec              AS INTEGER
    FIELD cod-nao-conform-ini    AS INTEGER
    FIELD cod-nao-conform-fim    AS INTEGER
    FIELD dt-trans-ini           AS DATE
    FIELD dt-trans-fim           AS DATE
    FIELD cod-estab-ini          AS CHARACTER FORMAT "X(5)":U
    FIELD cod-estab-fim          AS CHARACTER FORMAT "X(5)":U
    FIELD num-carg-ini           AS INTEGER
    FIELD num-carg-fim           AS INTEGER
    FIELD imp-param              AS LOGICAL
    FIELD tg-dif-qtde            AS LOGICAL
    FIELD tg-qualidade           AS LOGICAL
    FIELD tg-nao-coleta          AS LOGICAL
    FIELD tg-pendente            AS LOGICAL
    FIELD tg-em-analise          AS LOGICAL
    FIELD tg-resolvida           AS LOGICAL.
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "X(30)":U
    INDEX id ordem.    
    
DEF TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita AS RAW.
