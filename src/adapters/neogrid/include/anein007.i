FUNCTION GetRoot RETURNS CHARACTER ():
    FIND FIRST tt-element-in WHERE parentid = 0 NO-ERROR.
    
    IF  NOT AVAIL tt-element-in THEN DO:
        MESSAGE "NÆo foi possivel encontrar tag - Fun‡Æo: GetRoot" VIEW-AS ALERT-BOX ERROR.
        RETURN "".
    END.
    ELSE
        RETURN STRING(tt-element-in.id).
END FUNCTION.

FUNCTION GetName RETURNS CHARACTER(c-element-id AS CHAR):
    DEF VAR i-id LIKE tt-element-in.id.

    ASSIGN i-id = INT(c-element-id).
    FIND FIRST tt-element-in WHERE tt-element-in.id = i-id NO-ERROR.

    IF  NOT AVAIL tt-element-in THEN DO:
        MESSAGE "NÆo foi possivel encontrar tag - Fun‡Æo: GetName" VIEW-AS ALERT-BOX ERROR.
        RETURN "".
    END.
    ELSE
        RETURN tt-element-in.name.
END FUNCTION.

FUNCTION GetValue RETURNS CHARACTER (c-element-id AS CHAR):
    DEF VAR i-id AS INT.

    ASSIGN i-id = INT(c-element-id).
    FIND FIRST tt-element-in WHERE tt-element-in.id = i-id NO-ERROR.

    IF  NOT AVAIL tt-element-in THEN DO:
        MESSAGE "NÆo foi possivel encontrar tag - Fun‡Æo: GetValue" VIEW-AS ALERT-BOX ERROR.
        RETURN ?.
    END.
    ELSE
        RETURN tt-element-in.val.
END FUNCTION.

FUNCTION Get RETURNS CHARACTER (c-root-id      AS CHAR,
                                c-element-name AS CHAR):
    DEF VAR i-root AS INT.

    ASSIGN i-root = INT(c-root-id).
    FIND FIRST tt-element-in
         WHERE tt-element-in.parentid = i-root
         AND   tt-element-in.name     = c-element-name NO-ERROR.

    IF  NOT AVAIL tt-element-in THEN DO:
        MESSAGE "NÆo foi possivel encontrar tag: " + TRIM(c-element-name) VIEW-AS ALERT-BOX ERROR.
        RETURN "".
    END.
    ELSE
        RETURN STRING(tt-element-in.id).
END FUNCTION.

FUNCTION GetElements RETURNS CHARACTER (c-root-id AS CHAR):
    DEF VAR c-return AS CHAR.
    DEF VAR i-root   AS INT.

    ASSIGN i-root = INT(c-root-id).

    FOR EACH tt-element-in
        WHERE tt-element-in.parentid = i-root
        AND   tt-element-in.id      <> 0
        BY tt-element-in.id:
        ASSIGN c-return = c-return + STRING(tt-element-in.id) +  ",".
    END.
    ASSIGN c-return = SUBSTRING(c-return,1,LENGTH(c-return) - 1).
    RETURN c-return.
END FUNCTION.

FUNCTION GetAttribute RETURNS CHARACTER (c-element-id AS CHAR,
                                         c-attribute  AS CHAR):
    DEF VAR i-element AS INT.

    ASSIGN i-element = INT(c-element-id).
    FIND FIRST tt-attribute-in
         WHERE tt-attribute-in.elementid = i-element
         AND   tt-attribute-in.name      = c-attribute NO-ERROR.

    IF  NOT AVAIL tt-element-in THEN DO:
        MESSAGE "NÆo foi possivel encontrar atributo: " + TRIM(c-attribute) VIEW-AS ALERT-BOX ERROR.
        RETURN ?.
    END.
    ELSE
        RETURN tt-attribute-in.val.
END FUNCTION.

FUNCTION GetAttributeList RETURNS CHARACTER (c-element-id AS CHAR):
    DEF VAR c-return  AS CHAR.
    DEF VAR i-element AS INT.
    
    ASSIGN i-element = INT(c-element-id).
    FOR EACH  tt-attribute-in
        WHERE tt-attribute-in.elementid = i-element
        BY tt-attribute-in.name:
        ASSIGN c-return = c-return + STRING(tt-attribute-in.name) + ",".
    END.
    ASSIGN c-return = SUBSTRING(c-return,1,LENGTH(c-return) - 1).
    RETURN c-return.
END FUNCTION.

FUNCTION Getsonval RETURNS CHARACTER (c-root-id      AS CHAR,
                                      c-element-name AS CHAR):
    DEF VAR i-root AS INT.

    ASSIGN i-root = INT(c-root-id).
    FIND FIRST tt-element-in 
         WHERE tt-element-in.parentid = i-root
         AND   tt-element-in.name     = c-element-name NO-ERROR.

    IF  NOT AVAIL tt-element-in THEN
        FIND FIRST tt-element-in 
             WHERE tt-element-in.parentid = i-root
             AND   tt-element-in.name     = c-element-name + "/" NO-ERROR.

    IF  NOT AVAIL tt-element-in THEN DO:
        MESSAGE "NÆo foi possivel encontrar tag: " + TRIM(c-element-name) VIEW-AS ALERT-BOX ERROR.
        RETURN ?.
    END.
    ELSE
        IF  tt-element-in.val = ? THEN
            RETURN "".            
        ELSE
            RETURN tt-element-in.val.
END FUNCTION.

FUNCTION Getsondec RETURNS CHARACTER (c-root-id      AS CHAR,
                                      c-element-name AS CHAR):
    DEF VAR i-root AS INT.
    DEF VAR c-aux  AS CHAR.

    ASSIGN i-root = INT(c-root-id).
    FIND FIRST tt-element-in 
         WHERE tt-element-in.parentid = i-root
         AND   tt-element-in.name     = c-element-name NO-ERROR.

    IF  NOT AVAIL tt-element-in THEN
        FIND FIRST tt-element-in 
             WHERE tt-element-in.parentid = i-root
             AND   tt-element-in.name     = c-element-name + "/" NO-ERROR.

    IF  NOT AVAIL tt-element-in THEN DO:
        MESSAGE "NÆo foi possivel encontrar tag: " + TRIM(c-element-name) VIEW-AS ALERT-BOX ERROR.
        RETURN "".
    END.
    ELSE
        IF  tt-element-in.val = ? THEN
            RETURN "".            
        ELSE DO:
            ASSIGN c-aux = tt-element-in.val.
            IF  SESSION:NUMERIC-FORMAT = "EUROPEAN" THEN
                ASSIGN c-aux = replace(string(tt-element-in.val), ".", ",").
            RETURN c-aux.
        END.
END FUNCTION.

FUNCTION Getsondate RETURNS DATE (c-root-id      AS CHAR,
                                  c-element-name AS CHAR):
    DEF VAR i-root AS INT.
    DEF VAR dt-aux AS DATE.

    ASSIGN i-root = INT(c-root-id).
    FIND FIRST tt-element-in 
         WHERE tt-element-in.parentid = i-root
         AND   tt-element-in.name     = c-element-name NO-ERROR.

    IF  NOT AVAIL tt-element-in THEN DO:
        MESSAGE "NÆo foi possivel encontrar tag: " + TRIM(c-element-name) VIEW-AS ALERT-BOX ERROR.
        RETURN ?.
    END.
    ELSE DO:
        IF  NUM-ENTRIES(tt-element-in.val,"-") > 2 THEN
            ASSIGN dt-aux = DATE(INT(SUBSTRING(tt-element-in.val,6,2)),INT(SUBSTRING(tt-element-in.val,9,2)),INT(SUBSTRING(tt-element-in.val,1,4))).
        RETURN dt-aux.
    END.
END FUNCTION.

FUNCTION Getfirstid RETURNS CHARACTER (c-element-name AS CHAR):
    FIND FIRST tt-element-in 
         WHERE tt-element-in.name = c-element-name NO-ERROR.

    IF  NOT AVAIL tt-element-in THEN DO:
        MESSAGE "NÆo foi possivel encontrar tag - Fun‡Æo: GetFirstID" VIEW-AS ALERT-BOX ERROR.
        RETURN "".
    END.
    ELSE
        RETURN STRING(tt-element-in.id).
END FUNCTION.

FUNCTION AvailTag RETURNS LOGICAL (c-root-id AS CHAR, c-element-name AS CHAR):
    DEF VAR i-root AS INT.

    ASSIGN i-root = INT(c-root-id).
    FIND FIRST tt-element-in 
         WHERE tt-element-in.parentid = i-root
         AND   tt-element-in.name     = c-element-name NO-ERROR.

    IF  NOT AVAIL tt-element-in THEN
        RETURN no.
    ELSE
        RETURN yes.
END FUNCTION.
