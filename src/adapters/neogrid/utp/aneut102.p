/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEUT102 2.00.00.009}  /*** 010001 ***/

{adapters/neogrid/include/anein104.i} 
{adapters/neogrid/include/anein106.i} 
{adapters/neogrid/include/anein107.i}.

DEF VAR l-crm AS LOG INIT NO.
DEF VAR l-b2b AS LOG INIT NO.

RUN utp/ut-crm.p.
ASSIGN l-crm = (return-value = "YES").

RUN utp/ut-neog.p.
ASSIGN l-b2b = IF RETURN-VALUE = "NOK" THEN NO ELSE YES.

DEF BUFFER b-MessageQueue FOR NGMessageQueue.

FIND FIRST ngadapterparms NO-LOCK NO-ERROR.
IF  AVAIL ngadapterparms THEN DO:

    IF (NUM-ENTRIES(ngadapterparms.queuemanager,",") = 1 
    OR  NUM-ENTRIES(ngadapterparms.char-1,",") = 1) THEN DO:
        IF ngadapterparms.queuemanager <> "" THEN DO:
            ASSIGN QueueManager = ngadapterparms.queuemanager.
                   QueueName    = ngadapterparms.queuename + ".OUT".
            RUN pi-verifica-mqseries.
            ASSIGN QueueManager = ngadapterparms.queuemanager.
                   QueueName    = ngadapterparms.queuename + ".IN".
            RUN pi-verifica-tabelas(YES).
        END.
        IF l-b2b AND ngadapterparms.char-1 <> "" THEN DO:
            ASSIGN QueueManager = ngadapterparms.char-1.
                   QueueName    = ngadapterparms.queuename + ".OUT".
            RUN pi-verifica-mqseries.
            ASSIGN QueueManager = ngadapterparms.char-1.
                   QueueName    = ngadapterparms.queuename + ".IN".
            RUN pi-verifica-tabelas(NO).
        END.
    END.
    IF (NUM-ENTRIES(ngadapterparms.queuemanager,",") = 3
    OR  NUM-ENTRIES(ngadapterparms.char-1,",") = 3) THEN DO:
        IF ngadapterparms.queuemanager <> "" THEN DO:
            ASSIGN QueueManager = ENTRY(2,ngadapterparms.queuemanager,",").
                   QueueName    = ENTRY(3,ngadapterparms.queuemanager,",") + ".OUT".
            RUN pi-verifica-mqseries.
            ASSIGN QueueManager = ENTRY(2,ngadapterparms.queuemanager,",").
                   QueueName    = ENTRY(3,ngadapterparms.queuemanager,",") + ".IN".
            RUN pi-verifica-tabelas(YES).
        END.
        IF l-b2b AND ngadapterparms.char-1 <> "" THEN DO:
            ASSIGN QueueManager = ENTRY(2,ngadapterparms.char-1,",").
                   QueueName    = ENTRY(3,ngadapterparms.char-1,",") + ".OUT".
            RUN pi-verifica-mqseries.
            ASSIGN QueueManager = ENTRY(2,ngadapterparms.char-1,",").
                   QueueName    = ENTRY(3,ngadapterparms.char-1,",") + ".IN".
            RUN pi-verifica-tabelas(NO).
        END.
    END.

END.
RETURN.

/*****************************/
PROCEDURE pi-verifica-mqseries:
/*****************************/
    RUN ConnectQueueManager (INPUT QueueManager, OUTPUT Hconn, OUTPUT CompCode, OUTPUT Reason).
    IF  reason <> 0 THEN DO:
        IF  reason <> 2002 THEN DO:
            STATUS INPUT "Status: Erro nÆo identificado (" + TRIM(STRING(REASON,"->>>9")) + ")".
            LEAVE.
        END.
    END.
    RUN OpenQueueForRead (INPUT QueueName, INPUT Hconn, OUTPUT Hobj, OUTPUT CompCode, OUTPUT Reason).
    IF  reason <> 0 THEN DO:
        IF  reason <> 2002 THEN DO:
            STATUS INPUT "Status: Erro nÆo identificado (" + TRIM(STRING(REASON,"->>>9")) + ")".
            LEAVE.
        END.
    END.
    REPEAT:
        FOR EACH tt-msg-xml:
            DELETE tt-msg-xml.
        END.
        RUN ReadMessage (INPUT Hconn, INPUT Hobj, OUTPUT TABLE tt-msg-xml, OUTPUT CompCode, OUTPUT Reason).
        IF  reason <> 0 THEN DO:
            IF  reason <> 2002 THEN DO:
                IF  reason <> 2033 THEN 
                    STATUS INPUT "Status: Erro nÆo identificado (" + TRIM(STRING(REASON,"->>>9")) + ")".
                ELSE 
                    STATUS INPUT "Status: OK".
                LEAVE.
            END.
            ELSE 
                STATUS INPUT "Status: OK".
        END.
        ELSE DO:
            STATUS INPUT "Status: OK".
            RUN pi-trata-mensagem.
        END.
    END.                       
    RUN CloseQueue (INPUT Hconn, INPUT Hobj, OUTPUT CompCode, OUTPUT Reason).
    RUN DisconnectQueueManager (INPUT Hconn, OUTPUT CompCode, OUTPUT Reason).
END PROCEDURE.

/**************************/
PROCEDURE pi-trata-mensagem:
/**************************/
    DEF VAR dt        AS CHAR.
    DEF VAR id        AS INTEGER.
    
    ASSIGN id = NEXT-VALUE(sq_ngmessagequeue).
        
    FOR EACH tt-msg-xml:
        CREATE NGMessageQueue.
        ASSIGN dt                                    = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS")
               NGMessageQueue.NGMessageQueueName     = "IN"
               NGMessageQueue.NGMessageQueueID       = id
               NGMessageQueue.NGMessageQueueSequence = tt-msg-xml.sequencia
               NGMessageQueue.DateTime               = dt
               NGMessageQueue.XMLMessage             = tt-msg-xml.conteudo
               NGMessageQueue.Done                   = FALSE.
        RELEASE NGMessageQueue.
    END.
END PROCEDURE.

/****************************/
PROCEDURE pi-verifica-tabelas:
/****************************/   

    DEF INPUT PARAM p-crm AS LOG INIT NO.

    DEF VAR c-erro AS CHAR NO-UNDO.
    FOR EACH tt-msg-xml:
        DELETE tt-msg-xml.
    END.
    ASSIGN c-erro = "".
    FOR EACH NGMessageQueue  NO-LOCK
        WHERE NGMessageQueue.NGMessageQueueName = "OUT"
          AND NGMessageQueue.Done               = FALSE
          AND NGMessageQueue.log-1              = p-crm
        BREAK BY NGMessageQueue.NGMessageQueueID:
        IF  FIRST-OF(ngmessagequeue.ngmessagequeueid) THEN DO:
            FOR EACH b-MessageQueue
                WHERE b-MessageQueue.NGMessageQueueName = "OUT" 
                  AND b-MessageQueue.NGMessageQueueID   = NGMessageQueue.NGMessageQueueID 
                  AND b-MessageQueue.Done               = FALSE
                  AND b-MessageQueue.log-1              = p-crm EXCLUSIVE-LOCK
                BY b-messagequeue.ngmessagequeuesequence:
                CREATE tt-msg-xml.
                ASSIGN tt-msg-xml.sequencia = b-MessageQueue.NGMessageQueueSequence
                       tt-msg-xml.conteudo  = b-MessageQueue.XMLMessage.
            END.
        END.
        FIND FIRST tt-msg-xml NO-ERROR.
        IF  AVAILABLE tt-msg-xml THEN DO:
            RUN pi-envia-mensagem (INPUT-OUTPUT c-erro).
        END.
        FOR EACH tt-msg-xml:
            DELETE tt-msg-xml.
        END.
        IF  c-erro = "" THEN DO:
            FOR EACH  b-MessageQueue
                WHERE b-MessageQueue.NGMessageQueueName = "OUT" 
                  AND b-MessageQueue.NGMessageQueueID   = NGMessageQueue.NGMessageQueueID 
                  AND b-MessageQueue.Done               = NO 
                  AND b-MessageQueue.log-1              = p-crm  EXCLUSIVE-LOCK:
                ASSIGN b-MessageQueue.Done = TRUE.
            END.
        END.
        ASSIGN c-erro = "".
    END.
END PROCEDURE.

/**************************/
PROCEDURE pi-envia-mensagem:
/**************************/
    DEF INPUT-OUTPUT PARAMETER c-erro AS CHAR NO-UNDO.
    RUN ConnectQueueManager (INPUT QueueManager, OUTPUT Hconn, OUTPUT CompCode, OUTPUT Reason).
    IF  reason <> 0 
    AND reason <> 2002 THEN DO:
        STATUS INPUT "Status: Erro nÆo identificado (" + TRIM(STRING(REASON,"->>>9")) + ")".
        ASSIGN c-erro = TRIM(STRING(REASON,"->>>9")).
    END.                                  
    ELSE DO:
        RUN OpenQueueForWrite (INPUT QueueName, INPUT Hconn, OUTPUT Hobj, OUTPUT CompCode, OUTPUT Reason).
        IF  reason <> 0 THEN DO:
            STATUS INPUT "Status: Erro nÆo identificado (" + TRIM(STRING(REASON,"->>>9")) + ")".
            ASSIGN c-erro = TRIM(STRING(REASON,"->>>9")).
        END.                                  
        ELSE DO:
            RUN SendMessage (INPUT Hconn, INPUT Hobj, INPUT TABLE tt-msg-xml, OUTPUT CompCode, OUTPUT Reason).
            IF  reason <> 0 THEN DO:
                STATUS INPUT "Status: Erro nÆo identificado (" + TRIM(STRING(REASON,"->>>9")) + ")".
                ASSIGN c-erro = TRIM(STRING(REASON,"->>>9")).
            END.                                  
            ELSE 
                STATUS INPUT "Status: OK".
        END.
    END.
    RUN CloseQueue (INPUT Hconn, INPUT Hobj, OUTPUT CompCode, OUTPUT Reason).                              
    RUN DisconnectQueueManager (INPUT Hconn, OUTPUT CompCode, OUTPUT Reason).
    RETURN c-erro.
END PROCEDURE.
