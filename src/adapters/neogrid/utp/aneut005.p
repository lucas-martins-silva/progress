/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEUT005 2.00.00.012}  /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneut005 MAN}
&ENDIF

{adapters/neogrid/include/anein005.i}

DEF VAR p-DateTime AS CHAR.
DEF VAR p-ID       AS INT NO-UNDO.
DEF VAR p-Message  AS CHAR NO-UNDO.
DEF VAR p-Sequence AS INT NO-UNDO.

/* µrea incluida para diferenciar CRM de Neogrid */
DEF VAR l-crm      AS LOG INIT NO. 

FIND FIRST tt-element-in 
    WHERE tt-element-in.NAME = "CRM" NO-ERROR.
IF AVAIL tt-element-in THEN DO:
    ASSIGN l-crm = YES.
    DELETE tt-element-in.
END.
/*************************************************/

RUN XMLSender.

/*FUNCTION ProcessEntitiesOut RETURN CHAR (p-value AS CHAR):
    DEF VAR p-interp AS CHAR INIT "&,<,>,',".
    DEF VAR p-ref    AS CHAR INIT "&amp;,&lt;,&gt;,&apos;,&quot;".
    DEF VAR p-cont   AS INT.
    DEF VAR p-pos    AS INT.

    ASSIGN p-interp = p-interp + '"'.
    DO  p-cont = 1 TO NUM-ENTRIES(p-interp):
        ASSIGN p-pos = INDEX(p-value,ENTRY(p-cont,p-interp)).
        IF  p-pos > 0 THEN 
            ASSIGN p-value = SUBSTRING(p-value,1,p-pos - 1) + ENTRY(p-cont,p-ref) + SUBSTRING(p-value,p-pos + 1). 
    END.
    RETURN p-value.
END FUNCTION.*/

FUNCTION ProcessEntitiesOut RETURN CHAR (p-value AS CHAR): /*lutz 05/02/2004*/
    DEF VAR p-interp AS CHAR INIT "&,<,>,',".
    DEF VAR p-ref    AS CHAR INIT "&amp;,&lt;,&gt;,&apos;,&quot;".
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

PROCEDURE writeLine:
DEFINE INPUT PARAMETER p-Line AS CHAR.

   IF  LENGTH(p-line) + LENGTH(p-Message) > 30000 THEN DO:
       CREATE NGMessageQueue.
       ASSIGN NGMessageQueue.NGMessageQueueName     = "OUT"
              NGMessageQueue.NGMessageQueueID       = p-ID
              NGMessageQueue.NGMessageQueueSequence = p-Sequence
              NGMessageQueue.DateTime               = p-DateTime
              NGMessageQueue.XMLMessage             = p-Message
              NGMessageQueue.log-1                  = l-crm. /* YES = CRM / NO = Neogrid */ 
        RELEASE NGMessageQueue.
       ASSIGN p-Sequence                            = p-Sequence + 1
              p-Message                             = "".

   END.

    ASSIGN p-Message = p-Message + p-Line.

END PROCEDURE.

PROCEDURE BuildXMLElement:
    DEF PARAMETER BUFFER ptt-element-in FOR tt-element-in.

    DEF VAR p-line          AS CHAR.
    DEFINE BUFFER btt-element-in FOR tt-element-in.

    ASSIGN p-line = "<" + ptt-element-in.NAME.

    FOR EACH  tt-attribute-in NO-LOCK
        WHERE tt-attribute-in.elementid = ptt-element-in.id BY tt-attribute-in.name:
        ASSIGN p-line = p-line + " " + tt-attribute-in.NAME + '="' + tt-attribute-in.val + '"'.
    END.

    IF TRIM(ptt-element-in.val) <> "" THEN DO:
        ASSIGN p-line = p-line + ">" + ProcessEntitiesOut(RIGHT-TRIM(ptt-element-in.val)) + "</" + ptt-element-in.NAME + ">".
        RUN writeLine (p-line).
    END.
    ELSE DO:
        FIND FIRST btt-element-in
            WHERE btt-element-in.parentid = ptt-element-in.id EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE btt-element-in THEN DO:
            ASSIGN p-line = p-line + "/>".
            RUN writeLine (p-line).
        END.
        ELSE DO:
            ASSIGN p-line = p-line + ">".
            RUN writeLine (p-line).
            FOR EACH btt-element-in EXCLUSIVE-LOCK
                WHERE btt-element-in.parentid = ptt-element-in.id BY btt-element-in.id:
                RUN BuildXMLElement (BUFFER btt-element-in).
            END.
            ASSIGN p-line = "</" + ptt-element-in.NAME + ">".
            RUN writeLine (p-line).
        END.
    END.

END PROCEDURE.

PROCEDURE XMLSender :
    DEF BUFFER b-tt-element-in FOR tt-element-in.

    FOR EACH  b-tt-element-in EXCLUSIVE-LOCK
        WHERE b-tt-element-in.parentid = 0:
        ASSIGN p-DateTime = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS")
               p-ID = NEXT-VALUE(sq_ngmessagequeue)
               p-Message = '<?xml version="1.0" encoding="ISO-8859-1"?>'.

        RUN BuildXMLElement (BUFFER b-tt-element-in).

        IF  p-Message <> "" THEN DO:
            CREATE NGMessageQueue.
            ASSIGN NGMessageQueue.NGMessageQueueName     = "OUT"
                   NGMessageQueue.NGMessageQueueID       = p-ID
                   NGMessageQueue.NGMessageQueueSequence = p-Sequence
                   NGMessageQueue.DateTime               = p-DateTime
                   NGMessageQueue.XMLMessage             = TRIM(p-Message)
                   NGMessageQueue.log-1                  = l-crm. /* YES = CRM / NO = Neogrid */
            RELEASE Ngmessagequeue.
        END.
    END.
    FOR EACH tt-element-in EXCLUSIVE-LOCK:
        DELETE tt-element-in VALIDATE(TRUE,"").
    END.
    FOR EACH tt-attribute-in EXCLUSIVE-LOCK:
        DELETE tt-attribute-in VALIDATE(TRUE,"").
    END.
END PROCEDURE.
