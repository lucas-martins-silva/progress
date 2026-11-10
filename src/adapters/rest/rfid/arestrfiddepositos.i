
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
 

DEFINE TEMP-TABLE ttDeposito NO-UNDO
    FIELD codDepos AS CHARACTER
    FIELD nome     AS CHARACTER
    .
DEFINE TEMP-TABLE ttLocal NO-UNDO
    FIELD codDepos AS CHARACTER
    FIELD codigo   AS CHARACTER
    FIELD nome     AS CHARACTER
    .

    