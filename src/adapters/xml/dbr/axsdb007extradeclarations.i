/************* Defini‡äes ***************/

{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i} 

DEF VAR de-val-refer-atualiz AS DEC           NO-UNDO.
def VAR iContErro            AS INT initial 0 NO-UNDO.

/*** ctrab -> ctrab-dbr ***/
DEFINE TEMP-TABLE tt-ctrab-dbr NO-UNDO
    FIELD cod-ctrab          AS CHARACTER
    FIELD des-ctrab          AS CHARACTER
    FIELD gm-codigo          AS CHARACTER
    FIELD num-operador-ctrab AS INTEGER
    INDEX codigo IS PRIMARY UNIQUE
          cod-ctrab
    INDEX grupo
          gm-codigo
          cod-ctrab.
