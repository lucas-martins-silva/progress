/*************************************************************************
**
** ANEPD016.I
**
**************************************************************************/

/* Defini‡Æo temp-table informa‡äes vendor */
DEFINE TEMP-TABLE tt-pd-vendor NO-UNDO
    FIELD taxa-cliente          AS DECIMAL
    FIELD cod-cond-cli          AS INTEGER
    FIELD dias-base             AS INTEGER
    FIELD data-base             AS DATE
    FIELD vl-equal-prov         AS DECIMAL
    FIELD cod-cond-cli-aux      AS INTEGER.               
