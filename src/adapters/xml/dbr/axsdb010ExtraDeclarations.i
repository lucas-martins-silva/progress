/*********** Definicoes  ************/
DEF VAR iContErro  AS INT INIT 0 NO-UNDO.
DEF VAR iContFam   AS INT INIT 0 NO-UNDO.

{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i}  
{cdg/cdcfgaps.i}
DEFINE TEMP-TABLE tt-familia-dbr NO-UNDO
    FIELD fm-codigo               AS CHARACTER 
    FIELD des-familia             AS CHARACTER
    FIELD politica                AS INTEGER
    INDEX codigo IS PRIMARY UNIQUE
          fm-codigo.
