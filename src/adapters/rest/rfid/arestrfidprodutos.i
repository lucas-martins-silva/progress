
&IF "{1}" = "RowErrors" &THEN
    /* Temp-table para retorno de erro */
    DEF TEMP-TABLE RowErrors NO-UNDO
        FIELD ErrorSequence    AS INTEGER
        FIELD ErrorNumber      AS INTEGER
        FIELD ErrorDescription AS CHARACTER
        FIELD ErrorParameters  AS CHARACTER
        FIELD ErrorType        AS CHARACTER
        FIELD ErrorHelp        AS CHARACTER
        FIELD ErrorSubType     AS CHARACTER.
&ENDIF


DEFINE TEMP-TABLE ttProduto NO-UNDO
    FIELD codigo          AS CHARACTER
    FIELD nome            AS CHARACTER
    FIELD codigoDeBarra   AS CHARACTER
    .
