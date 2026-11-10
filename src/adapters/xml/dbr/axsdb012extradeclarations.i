
/*********** Defini‡äes  ************/

DEF VAR iContEStab    AS INT INIT 0 NO-UNDO.
DEF VAR iContErro     AS INT INIT 0 NO-UNDO.

{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i}  

/*** estabelec -> estab-dbr ***/



DEFINE TEMP-TABLE tt-estab-dbr NO-UNDO
    FIELD cod-estabel AS CHARACTER
    FIELD des-estab   AS CHARACTER
    INDEX codigo IS PRIMARY UNIQUE
          cod-estabel.

