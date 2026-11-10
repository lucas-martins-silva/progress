&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXRMF 2.00.00.001}  /*** 010001 ***/



/*****************************************************************************
**
**       PROGRAMA: AMRMF
**
**       DATA....: 19/07/2007
**
**       AUTOR...: Daniel Marquini - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Leitura de Arquivos XML
**
*****************************************************************************/

/* ***************************  Definitions  ************************** */

def temp-table tt-msg-xml no-undo
    field sequencia as int
    field conteudo  as char
    index ch-sequencia is primary sequencia.   

DEF TEMP-TABLE tt-lines NO-UNDO
    FIELD lineid    AS INT
    FIELD linedesc  AS CHAR
    FIELD processed AS LOGICAL INIT NO
    INDEX idx-lineid IS PRIMARY
        lineid      ASCENDING.

DEF TEMP-TABLE tt-attribute-in NO-UNDO
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

DEF TEMP-TABLE tt-log-import NO-UNDO
    FIELD descricao   AS CHAR
    FIELD ajuda   AS CHAR.

DEFINE TEMP-TABLE tt-MessageQueue NO-UNDO
    FIELD MessageQueueName      AS CHAR FORMAT "X(3)"
    FIELD MessageQueueID        AS INTE FORMAT "->,>>>,>>9"
    FIELD MessageQueueSequence  AS inte FORMAT "->,>>>,>>9"
    FIELD DateTime              AS char FORMAT "X(20)"
    FIELD XMLMessage            AS char FORMAT "X(31000)"
    FIELD Done                  AS log  FORMAT "yes/no"
    FIELD GenerationDate        AS date FORMAT "99/99/9999"
    FIELD ProcessDate           AS date FORMAT "99/99/9999"
    FIELD GenerationTime        AS inte FORMAT ">>>,>>9"
    FIELD ProcessTime           AS inte FORMAT ">,>>>,>>9"
    FIELD char-1                AS char FORMAT "X(8)"
    FIELD char-2                AS char FORMAT "X(8)"
    FIELD int-1                 AS inte FORMAT "->,>>>,>>9"
    FIELD int-2                 AS INT  FORMAT "->,>>>,>>9"
    FIELD log-1                 AS LOG  FORMAT "yes/no"
    FIELD log-2                 AS log  FORMAT "yes/no"
    FIELD dec-1                 AS dec  FORMAT "->>,>>9.99"
    FIELD dec-2                 AS dec  FORMAT "->>,>>9.99"
    FIELD Raw-1                 AS raw  
    FIELD data-1                AS date FORMAT "99/99/9999"
    FIELD data-2                AS date FORMAT "99/99/9999"
    INDEX DateTime GenerationDate GenerationTime
    INDEX pk_ngmessagequeue IS PRIMARY UNIQUE MessageQueueName MessageQueueID MessageQueueSequence
    INDEX processor Done MessageQueueName MessageQueueID MessageQueueSequence
    .

DEFINE INPUT PARAM p-arquivo-xml     AS CHAR NO-UNDO.
DEFINE INPUT PARAM p-program-adapter AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-log-import.

DEF VAR c-conteudo-xml    AS MEMPTR NO-UNDO.
DEFINE VARIABLE i-dl-xml  AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-seq     AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-seq-aux AS INTEGER    NO-UNDO.

DEF BUFFER b-Locked       FOR tt-MessageQueue.
DEF BUFFER b-MessageQueue FOR tt-MessageQueue.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-GetElementValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetElementValue Procedure 
FUNCTION GetElementValue RETURNS CHARACTER
    (p-message AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetNextElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetNextElement Procedure 
FUNCTION GetNextElement RETURNS CHARACTER
    (p-line AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ParseLine) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ParseLine Procedure 
FUNCTION ParseLine RETURNS LOGICAL
    (p-root AS INT, p-root-description AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ProcessEntitiesIn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ProcessEntitiesIn Procedure 
FUNCTION ProcessEntitiesIn RETURNS CHARACTER
    (p-value AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


IF SEARCH(p-arquivo-xml) = ? THEN DO:
   CREATE tt-log-import.
    ASSIGN tt-log-import.descricao = p-arquivo-xml
           tt-log-import.ajuda     = "NÆo foi poss¡vel encontrar o arquivo xml":u.
    RETURN "NOK":U.
END.

FILE-INFO:FILE-NAME = p-arquivo-xml.
SET-SIZE(c-conteudo-xml) = FILE-INFO:FILE-SIZE.

INPUT FROM VALUE(p-arquivo-xml) BINARY CONVERT TARGET "iso8859-1":u.
IMPORT c-conteudo-xml.
INPUT CLOSE.

ASSIGN i-dl-xml = GET-SIZE(c-conteudo-xml).

EMPTY TEMP-TABLE tt-msg-xml NO-ERROR.


ASSIGN i-seq     = 0.
       i-seq-aux = 1.
REPEAT WHILE i-dl-xml > 0:
    ASSIGN i-seq = i-seq + 1.
    CREATE tt-msg-xml.
    ASSIGN tt-msg-xml.sequencia = i-seq
           tt-msg-xml.conteudo  = GET-STRING(c-conteudo-xml,i-seq-aux,30000)
           i-dl-xml             = i-dl-xml - 30000
           i-seq-aux            = i-seq-aux + 30000.
END.

FOR EACH tt-msg-xml
    WHERE tt-msg-xml.conteudo <> "":
    CREATE tt-MessageQueue.
    ASSIGN tt-MessageQueue.MessageQueueName     = "IN":U
           tt-MessageQueue.MessageQueueID       = 1
           tt-MessageQueue.MessageQueueSequence = tt-msg-xml.sequencia
           tt-MessageQueue.DateTime               = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS")
           tt-MessageQueue.XMLMessage             = tt-msg-xml.conteudo
           tt-MessageQueue.Done                   = FALSE.
    RELEASE tt-MessageQueue.
END.

FOR EACH  tt-MessageQueue
    WHERE tt-MessageQueue.MessageQueueName = "IN":u
    AND   tt-MessageQueue.Done               = NO 
    AND   tt-Messagequeue.xmlmessage         <> "" 
    AND   tt-Messagequeue.xmlmessage         <> ?  NO-LOCK
    BREAK BY MessageQueueID:
    ASSIGN p-message = ""
           P-lineid  = 0.
    IF  NOT LOCKED tt-MessageQueue THEN DO TRANSACTION:
        FOR EACH  b-MessageQueue
            WHERE b-MessageQueue.MessageQueueName = "IN":u 
            AND   b-MessageQueue.MessageQueueID   = tt-MessageQueue.MessageQueueID 
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
                    IF  p-line BEGINS "<NeoGridDoc":U THEN
                        ASSIGN p-line = "<NeoGridDoc>":U.
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

            IF SEARCH(p-program-adapter + ".r":U) <> ? THEN DO:
                assign p-program-adapter = p-program-adapter + ".r":U.
                RUN VALUE(SEARCH(p-program-adapter)) (INPUT TABLE tt-element-in, 
                                                      INPUT TABLE tt-attribute-in,
                                                      INPUT-OUTPUT TABLE tt-log-import).
                IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
            END.
            else do:
                IF search(p-program-adapter + ".p":U) <> ? THEN DO:
                    assign p-program-adapter = p-program-adapter + ".p":U.
                    RUN VALUE(SEARCH(p-program-adapter)) (INPUT TABLE tt-element-in, 
                                                          INPUT TABLE tt-attribute-in,
                                                          INPUT-OUTPUT TABLE tt-log-import).
                    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
                end.
            end.

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


OS-DELETE VALUE(p-arquivo-xml).


RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-WriteAttributeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WriteAttributeList Procedure 
PROCEDURE WriteAttributeList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-GetElementValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetElementValue Procedure 
FUNCTION GetElementValue RETURNS CHARACTER
    (p-message AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR p-cont        AS INT.
    DEF VAR p-pos         AS INT.
    DEF VAR p-interp      AS CHAR INIT "<,>,&,',".
    DEF VAR p-ref         AS CHAR INIT "&lt;,&gt;,&amp;,&apos;,&quot;":U.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetNextElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetNextElement Procedure 
FUNCTION GetNextElement RETURNS CHARACTER
    (p-line AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ParseLine) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ParseLine Procedure 
FUNCTION ParseLine RETURNS LOGICAL
    (p-root AS INT, p-root-description AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ProcessEntitiesIn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ProcessEntitiesIn Procedure 
FUNCTION ProcessEntitiesIn RETURNS CHARACTER
    (p-value AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
    DEF VAR p-interp AS CHAR INIT "&,<,>,',":U.
    DEF VAR p-ref    AS CHAR INIT "&amp;,&lt;,&gt;,&apos;,&quot;":U.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

