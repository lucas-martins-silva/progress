/*************************************************************************
**
** ANEIN004.I
**
**************************************************************************/

{adapters/neogrid/include/anein001.i out}
{adapters/neogrid/include/anein002.i out}
{utp/ut-glob.i} /* c-seg-usuario */

FUNCTION CreateDocument RETURNS CHAR (c-doc-name AS CHAR):
    DEF VAR i-id AS INT.

    FIND LAST tt-element-out NO-ERROR.
    IF  AVAILABLE tt-element-out THEN
        ASSIGN i-id = tt-element-out.id + 1.
    ELSE
        ASSIGN i-id = 1.
                
    CREATE tt-element-out.
    ASSIGN tt-element-out.parentid = 0
           tt-element-out.id       = i-id
           tt-element-out.name     = c-doc-name.
    RETURN STRING(i-id).
END.

FUNCTION AddElement RETURNS CHAR (c-root-element AS CHAR,
                                  c-element-name AS CHAR):
    DEF VAR i-id AS INT.
    
    FIND LAST tt-element-out NO-ERROR.
    IF  AVAILABLE tt-element-out THEN
        ASSIGN i-id = tt-element-out.id + 1.
        
    CREATE tt-element-out.
    ASSIGN tt-element-out.parentid = INT(c-root-element)
           tt-element-out.id       = i-id.
           tt-element-out.name     = c-element-name.
    RETURN STRING(i-id).
END.

FUNCTION AddEleChar RETURNS CHAR (c-root-element AS CHAR,
                                  c-element-name AS CHAR,
                                  c-value        AS CHAR) :
    DEF VAR i-id AS INT.

    FIND LAST tt-element-out.
    ASSIGN i-id = tt-element-out.id + 1.

    CREATE tt-element-out.
    ASSIGN tt-element-out.parentid = INT(c-root-element)
           tt-element-out.id       = i-id
           tt-element-out.name     = c-element-name
           tt-element-out.val      = IF c-value = ? THEN " " ELSE c-value.
    RETURN STRING(i-id).
END.

FUNCTION AddEleDeci RETURNS CHAR (c-root-element AS CHAR,
                                  c-element-name AS CHAR,
                                  d-value        AS DECIMAL) :
    DEF VAR i-id AS INT.
    DEF VAR c-value AS CHAR.

    ASSIGN c-value = replace(string(d-value),",",".").

    FIND LAST tt-element-out.
    ASSIGN i-id = tt-element-out.id + 1.

    CREATE tt-element-out.
    ASSIGN tt-element-out.parentid = INT(c-root-element)
           tt-element-out.id       = i-id
           tt-element-out.name     = c-element-name
           tt-element-out.val      = IF c-value = ? THEN " " ELSE c-value.
    RETURN STRING(i-id).
END.


FUNCTION AddEleInt RETURNS CHAR (c-root-element AS CHAR,
                                 c-element-name AS CHAR,
                                 i-value        AS INT) :
    DEF VAR i-id AS INT.

    FIND LAST tt-element-out.
    ASSIGN i-id = tt-element-out.id + 1.

    CREATE tt-element-out.
    ASSIGN tt-element-out.parentid = INT(c-root-element)
           tt-element-out.id       = i-id
           tt-element-out.name     = c-element-name
           tt-element-out.val      = IF i-value = ? THEN "0" ELSE STRING(i-value).
    RETURN STRING(i-id).
END.

FUNCTION AddEleDate RETURNS CHAR (c-root-element AS CHAR,
                                  c-element-name AS CHAR,
                                  c-value        AS DATE,
                                  c-hora         AS CHAR):
    DEF VAR i-id AS INT.

    FIND LAST tt-element-out.
    ASSIGN i-id = tt-element-out.id + 1.

    CREATE tt-element-out.
    assign tt-element-out.parentid = INT(c-root-element)
           tt-element-out.id       = i-id
           tt-element-out.name     = c-element-name
           tt-element-out.val      = STRING(YEAR(c-value))       + "-" +
                                     STRING(MONTH(c-value),"99") + "-" +
                                     STRING(DAY(c-value),"99")   + " " +
                                     c-hora.
    IF  tt-element-out.val = ? THEN
        ASSIGN tt-element-out.val = "".                                   

    RETURN STRING(i-id).
END.

FUNCTION WriteXML RETURNS LOGICAL():
    RUN adapters/neogrid/utp/aneut005.p(INPUT TABLE tt-element-out,
                                        INPUT TABLE tt-attribute-out).
    EMPTY temp-table tt-element-out.

    EMPTY Temp-table tt-attribute-out.

    RETURN TRUE.
END.

FUNCTION CreateNeoGridDoc RETURNS CHAR (c-doctype     AS CHAR,
                                        c-version     AS CHAR,
                                        c-cod-estabel AS CHAR):
    DEF VAR c-root    AS CHAR.
    DEF VAR c-element AS CHAR.
  
    ASSIGN c-root = CreateDocument("NeoGridDoc")
             c-element = AddEleChar(c-root,"GlobalDocumentFunctionCode",c-doctype)
             c-element = AddEleChar(c-root,"DocVersion",c-version)
             c-element = AddEleChar(c-root,"User",c-seg-usuario).
    RETURN c-root.
END.

FUNCTION CreateNeoGridDocElimina RETURNS CHAR (c-doctype     AS CHAR,
                                               c-version     AS CHAR,
                                               c-cod-estabel AS CHAR):
    DEF VAR c-root    AS CHAR.
    DEF VAR c-element AS CHAR.
  
    ASSIGN c-root = CreateDocument("NeoGridDoc")
             c-element = AddEleChar(c-root,"GlobalDocumentFunctionCode",c-doctype)
             c-element = AddEleChar(c-root,"DocVersion",c-version)
             c-element = AddEleChar(c-root,"User",ped-venda.user-alte).
    RETURN c-root.

END.
