/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*****************************************************************************
**
**       PROGRAMA: AMMF.I
**
**       DATA....: 19/07/2007
**
**       AUTOR...: Daniel Marquini - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Fun‡äes de Leitura e Grava‡Æo XML / Adapters
**
*****************************************************************************/
DEF TEMP-TABLE tt-attribute-in NO-UNDO
    FIELD elementid AS INT
    FIELD name      AS CHAR
    FIELD val       AS CHAR INIT "".

DEF TEMP-TABLE tt-attribute-out NO-UNDO
    FIELD elementid AS INT
    FIELD name      AS CHAR
    FIELD val       AS CHAR INIT "".

DEF TEMP-TABLE tt-element-in NO-UNDO
    FIELD parentid AS INT
    FIELD id       AS INT
    FIELD name     AS CHAR
    FIELD val      AS CHAR INIT ""
    INDEX idx-id IS PRIMARY
        id         ASCENDING
    INDEX idx-parentid 
        parentid   ASCENDING        
        id         ASCENDING.

DEF TEMP-TABLE tt-element-out NO-UNDO
    FIELD parentid AS INT
    FIELD id       AS INT
    FIELD name     AS CHAR
    FIELD val      AS CHAR INIT ""
    INDEX idx-id IS PRIMARY
        id         ASCENDING
    INDEX idx-parentid 
        parentid   ASCENDING        
        id         ASCENDING.

DEF TEMP-TABLE tt-erro-datasul NO-UNDO
    FIELD c-doc-origem  AS CHAR
    FIELD c-cod-estabel LIKE ESTABELEC.COD-ESTABEL
    FIELD i-cod-erro    AS INT
    FIELD c-desc-erro   AS CHAR.

DEF TEMP-TABLE tt-xml-message NO-UNDO
    FIELD Sequence             AS INT FORMAT "->,>>>,>>9"
    FIELD XMLMessage           AS CHAR FORMAT "X(31000)".

&IF {1} = "in":U &THEN
    DEF INPUT PARAMETER TABLE FOR tt-element-in.
    DEF INPUT PARAMETER TABLE FOR tt-attribute-in.
&ENDIF

{utp/ut-glob.i} 
DEF VAR p-Message  AS CHAR NO-UNDO.
DEF VAR p-Sequence AS INT INITIAL 1 NO-UNDO.

/* Defini‡Æo de Fun‡äes de Leitura XML */
FUNCTION GetRoot RETURNS CHARACTER ():
    FIND FIRST tt-element-in WHERE parentid = 0 NO-ERROR.
    
    IF  NOT AVAIL tt-element-in THEN DO:
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



/* Defini‡äes de Fun‡äes de Grava‡Æo XML */
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

FUNCTION CreateDatasulDoc RETURNS CHAR (c-doctype     AS CHAR,
                                        c-version     AS CHAR,
                                        c-cod-estabel AS CHAR):
    DEF VAR c-root    AS CHAR.
    DEF VAR c-element AS CHAR.

    ASSIGN c-root = CreateDocument("DatasulDoc")
             c-element = AddEleChar(c-root,"GlobalDocumentFunctionCode",c-doctype)
             c-element = AddEleChar(c-root,"DocVersion",c-version)
             c-element = AddEleChar(c-root,"User",c-seg-usuario).
    RETURN c-root.
END.

FUNCTION ProcessEntitiesOut RETURN CHAR (p-value AS CHAR):
    DEF VAR p-interp AS CHAR INIT "&,<,>,',":U.
    DEF VAR p-ref    AS CHAR INIT "&amp;,&lt;,&gt;,&apos;,&quot;":U.
    DEF VAR p-cont   AS INT.
    DEF VAR p-pos    AS INT.
    DEFINE VARIABLE c-parte AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-ent AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE i-entry AS INTEGER    NO-UNDO.
    ASSIGN p-interp = p-interp + '"'.

    DO  p-cont = 1 TO NUM-ENTRIES(p-interp):
        ASSIGN p-pos = INDEX(p-value,ENTRY(p-cont,p-interp)).
        IF  p-pos > 0 THEN DO:
        DO i-entry = 1 TO NUM-ENTRIES(p-value,ENTRY(p-cont,p-interp)):
               ASSIGN c-parte = entry(I-ENTRY,p-value,ENTRY(p-cont,p-interp)).
               IF i-entry = NUM-ENTRIES(p-value,ENTRY(p-cont,p-interp)) THEN DO:
                   c-ent =  c-ent + c-parte.
                   LEAVE.
               END.
               ASSIGN c-parte = entry(I-ENTRY,p-value,ENTRY(p-cont,p-interp))  +  ENTRY(p-cont,p-ref).
               c-ent = IF i-entry = 1 THEN c-parte ELSE c-ent + c-parte.
            END.
            ASSIGN p-value = (c-ent).
        END.
    END.
    RETURN p-value.
END FUNCTION.

PROCEDURE WriteXml:

    EMPTY TEMP-TABLE tt-attribute-in NO-ERROR.
    EMPTY TEMP-TABLE tt-element-in  NO-ERROR.

    FOR EACH tt-attribute-out:
        CREATE tt-attribute-in.
        BUFFER-COPY tt-attribute-out TO tt-attribute-in.
    END.

    FOR EACH tt-element-out:
        CREATE tt-element-in.
        BUFFER-COPY tt-element-out TO tt-element-in.
    END.

    DEF BUFFER b-tt-element-in FOR tt-element-in.

    FOR EACH  b-tt-element-in
        WHERE b-tt-element-in.parentid = 0:
        ASSIGN p-Message = '<?xml version="1.0" encoding="ISO-8859-1"?>'.
        
        RUN BuildXMLElement (BUFFER b-tt-element-in).
        
        IF  p-Message <> "" THEN DO:
            CREATE tt-xml-message.
            ASSIGN tt-xml-message.Sequence   = p-Sequence
                   tt-xml-message.XMLMessage = TRIM(p-Message).
            RELEASE tt-xml-message.
        END.
    END.
    FOR EACH tt-element-in:
        DELETE tt-element-in VALIDATE(TRUE,"").
    END.
    FOR EACH tt-attribute-in:
        DELETE tt-attribute-in VALIDATE(TRUE,"").
    END.

    EMPTY TEMP-TABLE tt-element-out NO-ERROR.
    EMPTY TEMP-TABLE tt-attribute-out NO-ERROR.

END PROCEDURE.

PROCEDURE BuildXMLElement:
    DEF PARAMETER BUFFER ptt-element-in FOR tt-element-in.
    
    DEF VAR p-line          AS CHAR.
    DEFINE BUFFER btt-element-in FOR tt-element-in.

    ASSIGN p-line = "<" + ptt-element-in.NAME.
    
    FOR EACH  tt-attribute-in
        WHERE tt-attribute-in.elementid = ptt-element-in.id BY tt-attribute-in.name:
        ASSIGN p-line = p-line + " " + tt-attribute-in.NAME + '="' + tt-attribute-in.val + '"'.
    END.
    
    IF TRIM(ptt-element-in.val) <> "" THEN DO:
        ASSIGN p-line = p-line + ">" + ProcessEntitiesOut(TRIM(ptt-element-in.val)) + "</" + ptt-element-in.NAME + ">".
        RUN writeLine (p-line).
    END.
    ELSE DO:
        FIND FIRST btt-element-in
            WHERE btt-element-in.parentid = ptt-element-in.id NO-ERROR.
        IF NOT AVAILABLE btt-element-in THEN DO:
            ASSIGN p-line = p-line + "/>".
            RUN writeLine (p-line).
        END.
        ELSE DO:
            ASSIGN p-line = p-line + ">".
            RUN writeLine (p-line).
            FOR EACH btt-element-in
                WHERE btt-element-in.parentid = ptt-element-in.id BY btt-element-in.id:
                RUN BuildXMLElement (BUFFER btt-element-in).
            END.
            ASSIGN p-line = "</" + ptt-element-in.NAME + ">".
            RUN writeLine (p-line).
        END.
    END.
    
END PROCEDURE.

PROCEDURE writeLine:
    DEFINE INPUT PARAMETER p-Line AS CHAR.

    IF  LENGTH(p-line) + LENGTH(p-Message) > 30000 THEN DO:
        CREATE tt-xml-message.
        ASSIGN tt-xml-message.Sequence     = p-Sequence
               tt-xml-message.XMLMessage   = p-Message.
        RELEASE tt-xml-message.
        ASSIGN p-Sequence = p-Sequence + 1
               p-Message  = "".
    END.

    ASSIGN p-Message = p-Message + p-Line.
     
END PROCEDURE.
