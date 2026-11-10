/*********** Defini‡äes  ************/
DEF VAR iContProd     AS INT INIT 0 NO-UNDO.
DEF VAR iContErro     AS INT INIT 0 NO-UNDO.

{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i}  

/*** lin-prod -> lin-produc-dbr ***/
DEFINE TEMP-TABLE tt-lin-produc-dbr NO-UNDO
    FIELD nr-linha        AS INTEGER
    FIELD cod-estabel     AS CHARACTER
    FIELD des-linh-produc AS CHARACTER
    INDEX codigo IS PRIMARY UNIQUE
          nr-linha cod-estabel.  
