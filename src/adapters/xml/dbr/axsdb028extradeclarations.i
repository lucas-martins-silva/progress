/*********** Defini‡äes  ************/
DEFINE VARIABLE iContErro  AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE iContTool  AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE iContTool2  AS INTEGER INIT 0 NO-UNDO.

{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i}

DEFINE TEMP-TABLE tt-det-turno-excec NO-UNDO
    FIELD cod-cenario       AS CHARACTER
    FIELD gm-codigo         AS CHARACTER
    FIELD cod-ctrab         AS CHARACTER
    FIELD dat-excec         AS DATE
    FIELD val-hora-inic     AS DECIMAL
    FIELD val-hora-fim      AS DECIMAL
    FIELD des-coment        AS CHARACTER
    INDEX hora IS PRIMARY UNIQUE
          cod-cenario gm-codigo cod-ctrab dat-excec val-hora-inic.

DEFINE TEMP-TABLE tt-turno-excec-cenar
    FIELD cod-cenario as character
    FIELD gm-codigo   as character
    FIELD cod-ctrab   as character
    FIELD des-coment  as character
    INDEX turno IS PRIMARY UNIQUE 
         cod-cenario
         gm-codigo
         cod-ctrab.
