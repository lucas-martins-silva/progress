/*********** Defini‡äes  ************/
DEF VAR iContUn       AS INT INIT 0 NO-UNDO.
DEF VAR iContErro     AS INT INIT 0 NO-UNDO.

{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i}  

/*** tab-unidade -> tt-unid-medid-dbr***/
DEFINE TEMP-TABLE tt-unid-medid-dbr NO-UNDO
    FIELD cod-unid-medid AS CHARACTER
    FIELD des-unid       AS CHARACTER
    INDEX codigo IS PRIMARY UNIQUE
          cod-unid-medid.
