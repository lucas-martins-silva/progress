{cdp/cdcfgman.i}

/*** area-produc -> area-produc-dbr ***/
DEFINE TEMP-TABLE tt-area-produc-dbr NO-UNDO
    FIELD cod-area-produc    AS CHARACTER
    FIELD des-area-produc    AS CHARACTER
    INDEX codigo IS PRIMARY UNIQUE
          cod-area-produc.

/* tt-erro */
{cdg/cdg0666.i}

/* Variaveis globais */
{utp/ut-glob.i}

DEFINE VAR iSeqErro             AS INTEGER                             NO-UNDO.
DEFINE VAR de-val-refer-atualiz LIKE area-produc-dbr.val-refer-atualiz NO-UNDO.

