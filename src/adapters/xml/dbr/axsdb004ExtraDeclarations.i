/*********** Defini‡äes  ************/
DEF VAR iContErro  AS INT INIT 0 NO-UNDO.
DEF VAR iContTool  AS INT INIT 0 NO-UNDO.

{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i}  

/*** ferr-prod -> ferram-dbr ***/
DEFINE TEMP-TABLE tt-ferram-dbr NO-UNDO
  FIELD cod-ferram           AS CHARACTER        
  FIELD des-ferram-produc    AS CHARACTER
  INDEX codigo IS PRIMARY UNIQUE
        cod-ferram.

