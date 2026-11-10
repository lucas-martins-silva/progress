/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEUT122 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneut122 MAN}
&ENDIF

{adapters/neogrid/include/anein104.i} 

DEF STREAM ME1.
DEF STREAM ME2.

DEF VAR l-crm AS LOG INIT NO.
DEF VAR l-b2b AS LOG INIT NO.

RUN utp/ut-crm.p.
ASSIGN l-crm = (return-value = "YES").

RUN utp/ut-neog.p.
ASSIGN l-b2b = IF RETURN-VALUE = "NOK" THEN NO ELSE YES.

DEF TEMP-TABLE tt-arquivos NO-UNDO
    FIELD arquivo       AS CHAR FORMAT "x(60)"
    INDEX tt-index IS PRIMARY
        arquivo         ASCENDING.

DEF BUFFER b-MessageQueue FOR NGMessageQueue.

DEF VAR i-seq           AS INT    NO-UNDO.
DEF VAR i-seq-aux       AS INT    NO-UNDO.
DEF VAR directoryIn     AS CHAR   NO-UNDO.
DEF VAR directoryOut    AS CHAR   NO-UNDO.
DEF VAR c-padrao        AS CHAR   NO-UNDO.
DEF VAR c-conteudo      AS CHAR   NO-UNDO.
DEF VAR c-conteudo-crm  AS CHAR   NO-UNDO.
DEF VAR c-conteudo-xml  AS MEMPTR NO-UNDO.
DEF VAR i-dl-xml        AS INT    NO-UNDO.
DEF VAR c-arq-file      AS CHAR   NO-UNDO.
DEF VAR c-nome-aux      AS CHAR   NO-UNDO.
DEF VAR c-cont-arq      AS INT    NO-UNDO.

FIND FIRST ngadapterparms NO-LOCK NO-ERROR.
IF  AVAIL ngadapterparms THEN DO:
    IF (NUM-ENTRIES(ngadapterparms.queuemanager,",") = 4 
    OR  NUM-ENTRIES(ngadapterparms.char-1,",") = 4) THEN DO:
        IF ngadapterparms.queuemanager <> "" THEN DO:
            ASSIGN DirectoryIn  = ENTRY(2,ngadapterparms.queuemanager,",")
                   DirectoryOut = ENTRY(3,ngadapterparms.queuemanager,",")
                   c-padrao     = ENTRY(4,ngadapterparms.queuemanager,",").
            RUN pi-verifica-tabelas(YES).
            RUN pi-verifica-mensagem.
        END.

        IF l-b2b AND ngadapterparms.char-1 <> "" THEN DO:
            ASSIGN DirectoryIn  = ENTRY(2,ngadapterparms.char-1,",")
                   DirectoryOut = ENTRY(3,ngadapterparms.char-1,",")
                   c-padrao     = ENTRY(4,ngadapterparms.char-1,",").
            RUN pi-verifica-tabelas(NO).
            RUN pi-verifica-mensagem.
        END.
    END.
END.

RETURN.

/*****************************/
PROCEDURE pi-verifica-mensagem:
/*****************************/
    FOR EACH tt-arquivos:
        DELETE tt-arquivos.
    END.

    IF  c-padrao = "ME" THEN DO:
        INPUT FROM OS-DIR (DirectoryIn) CONVERT SOURCE "iso8859-1".
        REPEAT:
            CREATE tt-arquivos.
            IMPORT tt-arquivos.arquivo.
        END.
        INPUT CLOSE.
        FOR EACH tt-arquivos:
            IF  LENGTH(tt-arquivos.arquivo) <= 2 
            OR  SUBSTRING(tt-arquivos.arquivo,LENGTH(tt-arquivos.arquivo) - 3,4) <> ".OKI" THEN DO:
                DELETE tt-arquivos. 
                NEXT.
            END.
            IF  SEARCH(DirectoryIn + SUBSTRING(tt-arquivos.arquivo,1,LENGTH(tt-arquivos.arquivo) - 4) + ".V") <> ? THEN DO:
                INPUT FROM VALUE(DirectoryIn + SUBSTRING(tt-arquivos.arquivo,1,LENGTH(tt-arquivos.arquivo) - 4) + ".V") CONVERT TARGET "iso8859-1".
                FOR EACH tt-msg-xml:
                    DELETE tt-msg-xml.
                END.
                CREATE tt-msg-xml.
                ASSIGN tt-msg-xml.sequencia = 1
                       i-seq                = 1.
                REPEAT:
                    IMPORT UNFORMATTED c-conteudo.
                    IF  (LENGTH(TRIM(tt-msg-xml.conteudo)) + LENGTH(TRIM(c-conteudo))) <= 30000 THEN DO:
                        ASSIGN tt-msg-xml.conteudo = tt-msg-xml.conteudo + TRIM(c-conteudo).
                    END.
                    ELSE DO:
                        CREATE tt-msg-xml.
                        ASSIGN i-seq                = i-seq + 1
                               tt-msg-xml.sequencia = i-seq
                               tt-msg-xml.conteudo  = TRIM(c-conteudo).
                    END.
                END.
                INPUT CLOSE.
                RUN pi-trata-mensagem. 
                OS-DELETE VALUE(DirectoryIn + tt-arquivos.arquivo).
            END.
        END.
        STATUS INPUT "Status: OK".
    END.
    
    IF  c-padrao = "TXT" THEN DO:
        INPUT FROM OS-DIR (DirectoryIn) CONVERT SOURCE "iso8859-1".
        REPEAT:
            CREATE tt-arquivos.
            IMPORT tt-arquivos.arquivo.
        END.
        INPUT CLOSE.
        FOR EACH tt-arquivos:
            IF  LENGTH(tt-arquivos.arquivo) <= 2 
            OR  SUBSTRING(tt-arquivos.arquivo,LENGTH(tt-arquivos.arquivo) - 3,4) <> ".txt" THEN DO:
                DELETE tt-arquivos. 
                NEXT.
            END.
            IF  SEARCH(TRIM(DirectoryIn) + TRIM(tt-arquivos.arquivo)) <> ? THEN DO:
                ASSIGN c-arq-file = TRIM(DirectoryIn) + TRIM(tt-arquivos.arquivo).
                FILE-INFO:FILE-NAME = c-arq-file.
                SET-SIZE(c-conteudo-xml) = 0.
                SET-SIZE(c-conteudo-xml) = FILE-INFO:FILE-SIZE.
                INPUT FROM VALUE(TRIM(DirectoryIn) + TRIM(tt-arquivos.arquivo)) BINARY CONVERT TARGET "iso8859-1".
                IMPORT c-conteudo-xml.
                INPUT CLOSE.
                
                ASSIGN i-dl-xml = GET-SIZE(c-conteudo-xml).

                FOR EACH tt-msg-xml:
                    DELETE tt-msg-xml.
                END.
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
                RUN pi-trata-mensagem. 
                OS-DELETE VALUE(DirectoryIn + tt-arquivos.arquivo). 
            END.
        END.
        STATUS INPUT "Status: OK".
    END.

    IF  c-padrao = "XML" THEN DO:
        INPUT FROM OS-DIR (DirectoryIn) CONVERT SOURCE "iso8859-1".
        REPEAT:
            CREATE tt-arquivos.
            IMPORT tt-arquivos.arquivo.
        END.
        INPUT CLOSE.
        FOR EACH tt-arquivos:
            IF  LENGTH(tt-arquivos.arquivo) <= 2 
            OR  SUBSTRING(tt-arquivos.arquivo,LENGTH(tt-arquivos.arquivo) - 3,4) <> ".xml" THEN DO:
                DELETE tt-arquivos. 
                NEXT.
            END.
            IF  SEARCH(TRIM(DirectoryIn) + TRIM(tt-arquivos.arquivo)) <> ? THEN DO:
                ASSIGN c-arq-file = TRIM(DirectoryIn) + TRIM(tt-arquivos.arquivo).
                FILE-INFO:FILE-NAME = c-arq-file.
                SET-SIZE(c-conteudo-xml) = 0.
                SET-SIZE(c-conteudo-xml) = FILE-INFO:FILE-SIZE.
                INPUT FROM VALUE(TRIM(DirectoryIn) + TRIM(tt-arquivos.arquivo)) BINARY CONVERT TARGET "iso8859-1".
                IMPORT c-conteudo-xml.
                INPUT CLOSE.
                
                ASSIGN i-dl-xml = GET-SIZE(c-conteudo-xml).

                FOR EACH tt-msg-xml:
                    DELETE tt-msg-xml.
                END.
                
                ASSIGN i-seq     = 0.
                       i-seq-aux = 1.
                REPEAT WHILE i-dl-xml > 0:
                    ASSIGN i-seq = i-seq + 1.
                    CREATE tt-msg-xml.
                    ASSIGN tt-msg-xml.sequencia = i-seq
                           tt-msg-xml.conteudo  = REPLACE(GET-STRING(c-conteudo-xml,i-seq-aux,30000),CHR(13),"")
                           i-dl-xml             = i-dl-xml - 30000
                           i-seq-aux            = i-seq-aux + 30000.
                END.
                RUN pi-trata-mensagem. 
                OS-DELETE VALUE(DirectoryIn + tt-arquivos.arquivo). 
            END.
        END.
        STATUS INPUT "Status: OK".
    END.
    
    IF  c-padrao = "CRM" THEN DO:
        INPUT FROM OS-DIR (DirectoryIn) CONVERT SOURCE "iso8859-1".
        REPEAT:
            CREATE tt-arquivos.
            IMPORT tt-arquivos.arquivo.
        END.
        INPUT CLOSE.
        FOR EACH tt-arquivos:
            IF  LENGTH(tt-arquivos.arquivo) <= 2 
            OR  SUBSTRING(tt-arquivos.arquivo,LENGTH(tt-arquivos.arquivo) - 3,4) <> ".xml" THEN DO:
                DELETE tt-arquivos. 
                NEXT.
            END.
            IF  SEARCH(TRIM(DirectoryIn) + TRIM(tt-arquivos.arquivo)) <> ? THEN DO:
                ASSIGN c-arq-file = TRIM(DirectoryIn) + TRIM(tt-arquivos.arquivo).
                FILE-INFO:FILE-NAME = c-arq-file.
                SET-SIZE(c-conteudo-xml) = 0.
                SET-SIZE(c-conteudo-xml) = (FILE-INFO:FILE-SIZE + 1024).
                INPUT FROM VALUE(TRIM(DirectoryIn) + TRIM(tt-arquivos.arquivo)) BINARY CONVERT TARGET "iso8859-1".
                IMPORT c-conteudo-xml NO-ERROR.
                INPUT CLOSE.
                
                ASSIGN i-dl-xml = GET-SIZE(c-conteudo-xml).

                FOR EACH tt-msg-xml:
                    DELETE tt-msg-xml.
                END.
                
                ASSIGN i-seq     = 0.
                       i-seq-aux = 1.
                REPEAT WHILE i-dl-xml > 0:
                    ASSIGN i-seq = i-seq + 1.
                    CREATE tt-msg-xml.
                    ASSIGN tt-msg-xml.sequencia = i-seq
                           tt-msg-xml.conteudo  = REPLACE(GET-STRING(c-conteudo-xml,i-seq-aux,30000),CHR(13),"")
                           i-dl-xml             = i-dl-xml - 30000
                           i-seq-aux            = i-seq-aux + 30000.
                END.
                RUN pi-trata-mensagem. 
                OS-DELETE VALUE(DirectoryIn + tt-arquivos.arquivo). 
            END.
        END.
        STATUS INPUT "Status: OK".
    END.

END PROCEDURE.

/**************************/
PROCEDURE pi-trata-mensagem:
/**************************/
    DEF VAR dt        AS CHAR.
    DEF VAR id        AS INTEGER.
    
    ASSIGN id = NEXT-VALUE(sq_ngmessagequeue).
    FOR EACH tt-msg-xml
        WHERE tt-msg-xml.conteudo <> "":
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
    FOR EACH NGMessageQueue
        WHERE NGMessageQueue.NGMessageQueueName = "OUT"
          AND NGMessageQueue.Done = FALSE 
          AND NGMessageQueue.log-1 = p-crm NO-LOCK
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
                  AND b-MessageQueue.log-1              = p-crm EXCLUSIVE-LOCK:
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
    DEF VAR c-arq-out                 AS CHAR NO-UNDO.
    DEF VAR c-nome-arq                AS CHAR NO-UNDO.

    IF  c-padrao = "ME" THEN DO:
        ASSIGN c-arq-out = TRIM(DirectoryOut) + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + REPLACE(STRING(TIME,"HH:MM:SS"),":",""). 
        OUTPUT STREAM ME1 TO VALUE(TRIM(c-arq-out) + ".DSX") CONVERT TARGET "iso8859-1".
        OUTPUT STREAM ME2 TO VALUE(TRIM(c-arq-out) + ".OKI") CONVERT TARGET "iso8859-1".
        FOR EACH tt-msg-xml
            BY tt-msg-xml.sequencia:
            PUT STREAM ME1 UNFORMATTED tt-msg-xml.conteudo.
            PUT STREAM ME2 UNFORMATTED tt-msg-xml.conteudo. 
        END.
        PUT STREAM ME1 UNFORMATTED SKIP.
        PUT STREAM ME2 UNFORMATTED SKIP. 
        OUTPUT STREAM ME1 CLOSE.
        OUTPUT STREAM ME2 CLOSE.
        PAUSE 1 NO-MESSAGE.
    END.

    IF  c-padrao = "TXT" THEN DO:
        IF  c-nome-arq = c-nome-aux THEN DO:
            ASSIGN c-cont-arq = c-cont-arq + 1
                   c-nome-arq = c-nome-arq + STRING(c-cont-arq,"9999").
        END.
        ELSE DO:
            ASSIGN c-cont-arq = 0
                   c-nome-aux = c-nome-arq
                   c-nome-arq = c-nome-arq + "0000".
        END.
        ASSIGN c-arq-out = TRIM(DirectoryOut) + TRIM(c-nome-arq) + ".txt". 
        OUTPUT TO VALUE(c-arq-out) CONVERT TARGET "iso8859-1".
        FOR EACH tt-msg-xml
            BY tt-msg-xml.sequencia:
            PUT UNFORMATTED tt-msg-xml.conteudo.
        END.
        PUT UNFORMATTED SKIP.
        OUTPUT CLOSE.
        PAUSE 0 NO-MESSAGE.
    END.
    
    IF  c-padrao = "XML" 
    OR  c-padrao = "CRM" THEN DO:
        ASSIGN c-nome-arq = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + REPLACE(STRING(TIME,"HH:MM:SS"),":","").
        IF  c-nome-arq = c-nome-aux THEN DO:
            ASSIGN c-cont-arq = c-cont-arq + 1
                   c-nome-arq = c-nome-arq + STRING(c-cont-arq,"9999").
        END.
        ELSE DO:
            ASSIGN c-cont-arq = 0
                   c-nome-aux = c-nome-arq
                   c-nome-arq = c-nome-arq + "0000".
        END.
        ASSIGN c-arq-out = TRIM(DirectoryOut) + TRIM(c-nome-arq) + ".xml". 
        OUTPUT TO VALUE(c-arq-out) CONVERT TARGET "iso8859-1".
        FOR EACH tt-msg-xml
            BY tt-msg-xml.sequencia:
            PUT UNFORMATTED tt-msg-xml.conteudo.
        END.
        PUT UNFORMATTED SKIP.
        OUTPUT CLOSE.
        PAUSE 0 NO-MESSAGE.
    END.
    
    RETURN c-erro.
END PROCEDURE.
