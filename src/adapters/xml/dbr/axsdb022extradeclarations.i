/*********** Defini‡äes  ************/
DEFINE VARIABLE iContErro  AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE iContTool  AS INTEGER INIT 0 NO-UNDO.

{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i}

DEFINE TEMP-TABLE tt-reduc-prepar-dbr NO-UNDO
    FIELD cod-reduc-prepar  AS CHARACTER
    FIELD des-reduc-prepar  AS CHARACTER
    FIELD dsl-reduc-prepar  AS CHARACTER
    INDEX codigo IS PRIMARY UNIQUE
          cod-reduc-prepar.
