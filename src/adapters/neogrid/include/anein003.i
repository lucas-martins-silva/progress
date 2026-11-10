/*************************************************************************
**
** ANEIN003.I
**
**************************************************************************/

DEF TEMP-TABLE tt-lines NO-UNDO
    FIELD lineid    AS INT
    FIELD linedesc  AS CHAR
    FIELD processed AS LOGICAL INIT NO
    INDEX idx-lineid IS PRIMARY
        lineid      ASCENDING.
