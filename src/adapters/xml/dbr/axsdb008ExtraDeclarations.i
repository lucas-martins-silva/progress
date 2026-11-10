{cdp/cdcfgman.i}

DEFINE TEMP-TABLE tt-turno-grp-dbr NO-UNDO
    FIELD gm-codigo       AS CHARACTER
    FIELD cod-model-turno AS CHARACTER
    FIELD dt-inicio       AS DATE
    FIELD dt-termino      AS DATE
    INDEX id IS PRIMARY UNIQUE
          gm-codigo 
          dt-inicio.

/* tt-erro */
{cdg/cdg0666.i}

/* Variaveis globais */
{utp/ut-glob.i}

DEFINE VAR iSeqErro             AS INTEGER                             NO-UNDO.
DEFINE VAR de-val-refer-atualiz LIKE area-produc-dbr.val-refer-atualiz NO-UNDO.

