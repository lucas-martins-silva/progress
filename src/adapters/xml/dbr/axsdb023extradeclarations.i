/*********** Defini‡äes  ************/
DEFINE VARIABLE iContErro  AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE iContTool  AS INTEGER INIT 0 NO-UNDO.

{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i}

DEFINE TEMP-TABLE tt-matriz-reduc-prepar NO-UNDO
    FIELD cod-reduc-orig    AS CHARACTER
    FIELD cod-reduc-dest    AS CHARACTER
    FIELD gm-codigo         AS CHARACTER
    FIELD qtd-hora-reduc    AS DECIMAL
    FIELD qtd-perc-reduc    AS DECIMAL
    INDEX mtr-rdcp-id IS PRIMARY UNIQUE
          gm-codigo cod-reduc-orig cod-reduc-dest.
