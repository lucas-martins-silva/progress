/*************************************************************************
**
** ANEIN002.I
**
**************************************************************************/

DEF TEMP-TABLE tt-element-{1} NO-UNDO
    FIELD parentid AS INT
    FIELD id       AS INT
    FIELD name     AS CHAR
    FIELD val      AS CHAR INIT ""
    INDEX idx-id IS PRIMARY
        id         ASCENDING
    INDEX idx-parentid 
        parentid   ASCENDING        
        id         ASCENDING.

