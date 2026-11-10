/*********** Defini‡äes  ************/

DEF VAR iContEStab    AS INT INIT 0 NO-UNDO.
DEF VAR iContErro     AS INT INIT 0 NO-UNDO.

{cdg/cdg0666.i} /*tt-erro*/
{utp/ut-glob.i}  

/*** referencia -> refer-dbr ***/
DEFINE TEMP-TABLE tt-refer-dbr NO-UNDO
    FIELD cod-refer AS CHARACTER
    FIELD descricao AS CHARACTER
    FIELD texto     AS CHARACTER
    FIELD subproduto AS LOGICAL
    INDEX codigo IS PRIMARY UNIQUE
          cod-refer.
