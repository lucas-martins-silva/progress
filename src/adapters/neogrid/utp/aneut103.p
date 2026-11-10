/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEUT103 2.00.00.009 } /*** 010009 ***/

{adapters/neogrid/include/anein003.i}
{adapters/neogrid/include/anein006.i}

DEF BUFFER b-Locked       FOR NGMessageQueue.
DEF BUFFER b-MessageQueue FOR NGMessageQueue.
  
DEF VAR p-next-attributeid AS INT.
DEF VAR p-message          AS CHAR.
DEF VAR p-length           AS INT.
DEF VAR p-lineid           AS INT.
DEF VAR p-line             AS CHAR.
DEF VAR p-start-tag        AS INT INIT -1.
DEF VAR p-end-tag          AS INT.
DEF VAR p-program          AS CHAR.
DEF VAR p-token            AS CHAR.
DEF VAR p-root             AS CHAR.
DEF VAR p-doc              AS CHAR.
DEF VAR msgp               AS INT.

/*******************************************************/
FUNCTION ProcessEntitiesIn RETURN CHAR (p-value AS CHAR).
/*******************************************************/    
    DEF VAR p-interp AS CHAR INIT "&,<,>,',".
    DEF VAR p-ref    AS CHAR INIT "&amp;,&lt;,&gt;,&apos;,&quot;".
    DEF VAR p-cont   AS INT.
    DEF VAR p-pos    AS INT.

    ASSIGN p-interp = p-interp + '"'.
    DO  p-cont = 1 TO NUM-ENTRIES(p-ref):
        ASSIGN p-pos = INDEX(p-value,ENTRY(p-cont,p-ref)).
        IF  p-pos > 0 THEN 
            ASSIGN p-value = SUBSTRING(p-value,1,p-pos - 1) + ENTRY(p-cont,p-interp) + SUBSTRING(p-value,p-pos + LENGTH(TRIM(ENTRY(p-cont,p-ref)))). 
    END.
    RETURN p-value.
END FUNCTION.

/***************************/
PROCEDURE WriteAttributeList:
/***************************/
    DEF INPUT PARAM p-element   AS CHAR.
    DEF INPUT PARAM p-message   AS CHAR.
    DEF INPUT PARAM p-elementid AS INT.

    DEF VAR p-elem-start AS INT.
    DEF VAR p-elem-end   AS INT.
    DEF VAR p-cont       AS INT.
    DEF VAR p-attribute  AS CHAR.
    DEF VAR p-value      AS CHAR.

    ASSIGN p-elem-start = INDEX(p-message,"<" + p-element) + LENGTH("<" + p-element)
           p-elem-end   = INDEX(p-message,">",p-elem-start).
    DO  p-cont = p-elem-start TO p-elem-end:
        IF  SUBSTRING(p-message,p-cont,1) = " " THEN DO:
            ASSIGN p-attribute = ""
                   p-value     = ""
                   p-cont      = p-cont + 1.
            DO  WHILE SUBSTRING(p-message,p-cont,1) <> "="
            AND p-cont < p-elem-end:
                ASSIGN p-attribute = p-attribute + SUBSTRING(p-message,p-cont,1)
                       p-cont      = p-cont + 1.
            END. 
            ASSIGN p-cont = p-cont + 2.
            DO  WHILE SUBSTRING(p-message,p-cont,1) <> '"'
            AND p-cont < p-elem-end:
                ASSIGN p-value = p-value + SUBSTRING(p-message,p-cont,1)
                       p-cont = p-cont + 1.
            END.
            IF  p-attribute <> "/" THEN DO:
                CREATE tt-attribute-in.
                ASSIGN tt-attribute-in.elementid = p-elementid
                       tt-attribute-in.name      = p-attribute
                       tt-attribute-in.val       = p-value.
            END. 
        END.
    END.
END PROCEDURE.

/************************************************************/
FUNCTION GetElementValue RETURNS CHARACTER(p-message AS CHAR):
/************************************************************/
    DEF VAR p-cont        AS INT.
    DEF VAR p-pos         AS INT.
    DEF VAR p-interp      AS CHAR INIT "<,>,&,',".
    DEF VAR p-ref         AS CHAR INIT "&lt;,&gt;,&amp;,&apos;,&quot;".
    DEF VAR p-end-tag-pos AS INT.
    DEF VAR p-value       AS CHAR.

    ASSIGN p-interp      = p-interp + '"'
           p-end-tag-pos = INDEX(p-message,">") + 1.
    IF  p-end-tag-pos > LENGTH(p-message) THEN 
        RETURN "".
    ASSIGN p-value = SUBSTRING(p-message,p-end-tag-pos).
    IF  TRIM(p-value) <> "" THEN 
        RETURN p-value.
    DO  p-cont = 1 TO NUM-ENTRIES(p-interp):
        ASSIGN p-pos = INDEX(p-value,ENTRY(p-cont,p-interp)).
        IF  p-pos > 0 THEN DO:
            ASSIGN p-value = SUBSTRING(p-value,1,p-pos - 1) + ENTRY(p-cont,p-ref) + SUBSTRING(p-value,p-pos + LENGTH(ENTRY(p-cont,p-ref))).
        END.
    END.
END FUNCTION.

/********************************************************/
FUNCTION GetNextElement RETURNS CHARACTER(p-line AS CHAR):
/********************************************************/    
    DEF VAR p-line-size AS INT.
    DEF VAR p-cont      AS INT.
    DEF VAR p-element   AS CHAR.
    
    ASSIGN p-line-size = LENGTH(p-line)
           p-element   = "".
           
    DO  p-cont = 1 TO p-line-size:
        IF  SUBSTRING(p-line,p-cont,1) = "<" THEN DO:
            ASSIGN p-cont = p-cont + 1.
            DO  WHILE SUBSTRING(p-line,p-cont,1) <> " "
            AND SUBSTRING(p-line,p-cont,1)       <> ">":
                ASSIGN p-element = p-element + SUBSTRING(p-line,p-cont,1)
                       p-cont    = p-cont + 1.
            END.
            RETURN p-element.
        END.
    END.
    RETURN p-element.
END FUNCTION.

/****************************************************************************/
FUNCTION ParseLine RETURNS LOGICAL(p-root AS INT, p-root-description AS CHAR): 
/****************************************************************************/    
    DEF VAR p-element   AS CHAR.
    DEF VAR p-value     AS CHAR.
    DEF VAR well-formed AS LOG INIT NO.
    DEF VAR no-value    AS LOG INIT NO.
    DEF VAR my-id       AS INT.
    
    ASSIGN p-element = TRIM(GetNextElement(tt-lines.linedesc))
           p-value   = GetElementValue(tt-lines.linedesc).
    IF  p-value <> "" THEN
        ASSIGN p-value = ProcessEntitiesIn(p-value).
    IF  SUBSTRING(p-element,LENGTH(p-element),1) = "/" THEN
        ASSIGN p-element = SUBSTRING(p-element,1,LENGTH(p-element) - 1).
    IF  INDEX(tt-lines.linedesc,"/>") > 0 THEN
        ASSIGN no-value    = TRUE
               well-formed = TRUE.
    ASSIGN my-id = p-next-attributeid.
    CREATE tt-element-in.
    ASSIGN tt-element-in.parentid = p-root
           tt-element-in.id       = my-id
           tt-element-in.name     = p-element
           tt-element-in.val      = p-value.
    RUN WriteAttributeList(p-element,tt-lines.linedesc,p-next-attributeid).
    IF  no-value = YES THEN 
        RETURN well-formed.
    REPEAT:
        FIND NEXT tt-lines.
        IF SUBSTRING(tt-lines.linedesc,1,2) <> "</" THEN DO:
            ASSIGN p-next-attributeid = p-next-attributeid + 1
                   well-formed        = ParseLine(my-id, p-element).
            IF  well-formed = NO THEN 
                LEAVE.
        END.
        ELSE DO:
            ASSIGN well-formed = (TRIM(tt-lines.linedesc) = "</" + p-element + ">").
            LEAVE.
        END.
    END.
    RETURN well-formed.
END FUNCTION.


/*** PROCEDURE PRINCIPAL ***/
FOR EACH  NGMessageQueue
    WHERE NGMessageQueue.NGMessageQueueName = "IN"
    AND   NGMessageQueue.Done               = NO NO-LOCK
    BREAK BY NGMessageQueueID:
    ASSIGN p-message = ""
           P-lineid  = 0.
    IF  NOT LOCKED NGMessageQueue THEN DO TRANSACTION:
        FOR EACH  b-MessageQueue
            WHERE b-MessageQueue.NGMessageQueueName = "IN" 
            AND   b-MessageQueue.NGMessageQueueID   = NGMessageQueue.NGMessageQueueID 
            AND   b-MessageQueue.Done               = NO EXCLUSIVE-LOCK:
            ASSIGN msgp = msgp + 1.
            ASSIGN p-message   = p-message + b-MessageQueue.XMLMessage
                   p-start-tag = INDEX(p-message,"<")
                   p-end-tag   = INDEX(p-message,">",p-start-tag).

            REPEAT WHILE p-start-tag <> 0 :
                IF  SUBSTRING(p-message,p-end-tag + 1,1) <> "<" THEN DO:
                    ASSIGN p-end-tag = INDEX(p-message,"<",p-end-tag) - 1.
                    IF  p-end-tag <= 0 THEN
                        LEAVE.
                END.
                ASSIGN p-line = SUBSTRING(p-message,p-start-tag,p-end-tag - p-start-tag + 1).
                IF  SUBSTRING(TRIM(p-line),1,2) <> "<?"
                AND SUBSTRING(TRIM(p-line),1,2) <> "<-" 
                AND SUBSTRING(TRIM(p-line),1,2) <> "<!" THEN DO:
                    IF  p-line BEGINS "<NeoGridDoc" THEN
                        ASSIGN p-line = "<NeoGridDoc>".
                    ASSIGN p-lineid = p-lineid + 1.
                    CREATE tt-lines.
                    ASSIGN lineid   = p-lineid
                           linedesc = p-line.
                END.
                ASSIGN p-message   = SUBSTRING(p-message,p-end-tag + 1)
                       p-start-tag = INDEX(p-message,"<").
                IF  p-start-tag <> 0 THEN DO:
                    ASSIGN p-end-tag = INDEX(p-message,">",p-start-tag).
                    IF  p-end-tag = 0 THEN
                        ASSIGN p-start-tag = 0.
                END.
            END.
            ASSIGN b-MessageQueue.Done = YES.
        END.
        IF p-message <> "" THEN DO:
            ASSIGN p-lineid = p-lineid + 1.
            CREATE tt-lines.
            ASSIGN lineid   = p-lineid
                   linedesc = p-message.
        END.
        IF  p-lineid > 0 THEN DO:
            ASSIGN p-next-attributeid = 1.
            FIND FIRST tt-lines.
            ParseLine(0,"").
            ASSIGN p-root = GetRoot().
            IF  GetName(p-root) = "NeoGridDoc" THEN DO:
                ASSIGN p-token = GET(p-root,"GlobalDocumentFunctionCode")
                       p-doc   = GetValue(p-token).
                FIND FIRST NGProcessMapping WHERE DocType = p-doc NO-LOCK NO-ERROR.
                IF  AVAILABLE NGProcessMapping THEN DO:
                    ASSIGN p-program = NGProcessMapping.Program.     
                    IF  TRIM(p-program) <> "" THEN DO:
                        ASSIGN p-program = TRIM(p-program) + ".p".
                        RUN VALUE(p-program) (INPUT TABLE tt-element-in, INPUT TABLE tt-attribute-in).
                    END.
                END.
            END.
        END.
        FOR EACH tt-element-in:
            DELETE tt-element-in.
        END.
        FOR EACH tt-attribute-in:
            DELETE tt-attribute-in.
        END.
        FOR EACH tt-lines:
            DELETE tt-lines.
        END.
    END.
END.
RETURN.

