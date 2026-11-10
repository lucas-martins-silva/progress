/*********** Defini‡äes  ************/

DEF VAR iContEStab    AS INT INIT 0 NO-UNDO.
DEF VAR iContErro     AS INT INIT 0 NO-UNDO.

{cdg/cdg0666.i} /*tt-erro*/
{utp/ut-glob.i}  

/*** planejad -> plandor-dbr ***/

DEFINE TEMP-TABLE tt-planejad-dbr NO-UNDO
    FIELD cod-plandor AS CHARACTER
    FIELD nom-plandor AS CHARACTER
    INDEX codigo IS PRIMARY UNIQUE
          cod-plandor.
