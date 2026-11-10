{cdp/cdcfgman.i}

/*** grup-maquina -> gm-dbr ***/
DEFINE TEMP-TABLE tt-gm-dbr NO-UNDO
    FIELD gm-codigo         AS CHARACTER         
    FIELD descricao         AS CHARACTER             
    FIELD cod-calend        AS CHARACTER  /*** cd-calen ***/           
    FIELD cod-area-produc   AS CHARACTER             
    FIELD num-maquinas      AS INTEGER
    &IF DEFINED(bf_man_206) &THEN
    FIELD log-principal     AS LOGICAL
    &ENDIF
    INDEX codigo IS PRIMARY UNIQUE gm-codigo.  

/*** tt-erro ***/
{cdg/cdg0666.i}

/*** Variaveis globais ***/
{utp/ut-glob.i}

DEFINE VAR iSeqErro             AS INTEGER                             NO-UNDO.
DEFINE VAR de-val-refer-atualiz LIKE area-produc-dbr.val-refer-atualiz NO-UNDO.




