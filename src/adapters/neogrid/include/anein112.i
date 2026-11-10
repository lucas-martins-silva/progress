DEF VAR HostName                        AS CHAR     NO-UNDO.
DEF VAR QueueName                       AS CHAR     NO-UNDO.
DEF VAR c-authorization                 AS CHAR     NO-UNDO.
DEF VAR c-priority                      AS CHAR     NO-UNDO.
DEF VAR vSocket                         AS HANDLE   NO-UNDO.   
DEF VAR wstatus                         AS LOG      NO-UNDO.
DEF VAR vStr                            AS CHAR     NO-UNDO.
DEF VAR lBuffer                         AS INT      NO-UNDO.
DEF VAR wloop                           AS LOG      NO-UNDO.
DEF VAR mBuffer                         AS MEMPTR   NO-UNDO.
DEF VAR rbuffer                         AS MEMPTR   NO-UNDO.
DEF VAR hbuffer                         AS MEMPTR   NO-UNDO.

PROCEDURE HTTPChannel:
    DEF INPUT PARAMETER pHost           AS CHAR     NO-UNDO.
    DEF INPUT PARAMETER pQueue          AS CHAR     NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER pBuffer  AS MEMPTR   NO-UNDO.
    DEF OUTPUT PARAMETER pStatus        AS INT      NO-UNDO.
    DEF VAR vHost                       AS CHAR     NO-UNDO.
    DEF VAR vPort                       AS CHAR     NO-UNDO.
    DEF VAR vStr                        AS CHAR     NO-UNDO.
    DEF VAR urlHost                     AS CHAR     NO-UNDO.
    DEF VAR l-read                      AS LOG      NO-UNDO.
    DEF VAR l-write                     AS LOG      NO-UNDO.
    DEF VAR post-tam                    AS INT      NO-UNDO.
    DEF VAR l-post-tam                  AS INT      NO-UNDO.
    DEF VAR post-aux                    AS INT      NO-UNDO.
    DEF VAR i-max-msg                   AS INT      NO-UNDO INIT 5242880.
    DEF VAR aux                         AS INT      NO-UNDO.
    DEF VAR ini                         AS INT      NO-UNDO INIT 1.
    DEF VAR lin                         AS CHAR     NO-UNDO.
    DEF VAR iMessage                    AS INT      NO-UNDO.

    FIND FIRST ngadapterparms NO-LOCK NO-ERROR.
    IF  AVAIL ngadapterparms THEN
        ASSIGN i-max-msg = IF  INTEGER(SUBSTR(ngadapterparms.queuename,6,5)) >= 1 THEN 
                              (INTEGER(SUBSTR(ngadapterparms.queuename,6,5)) * 1048576) 
                           ELSE 
                              (1048576).
    SET-SIZE(mBuffer) = 0.
    SET-SIZE(mBuffer) = i-max-msg.
    ASSIGN lBuffer = 1.
    
    /* HTTP,http://www.magazineluiza.com.br:8080/servlet@60.134.222.112:8080 */
    
    IF  NUM-ENTRIES(pHost, "@") > 1 THEN /* Via HTTP Proxy */
        ASSIGN vHost   = ENTRY(2, pHost, "@")
               urlHost = ENTRY(1, pHost, "@")
               pHost   = urlHost.
    ELSE DO: /* Direct HTTP */
       IF  pHost BEGINS "http://" THEN
           ASSIGN SUBSTRING(pHost,1,7) = "".
       IF  NUM-ENTRIES(pHost,"/") > 1 THEN
           ASSIGN vHost   = ENTRY(1, pHost, "/")
                  urlHost = "/" + ENTRY(2, pHost, "/").
       ELSE
           ASSIGN vHost   = pHost
                  urlHost = "".
    END.
    
    IF  pHost BEGINS "http://" THEN
        ASSIGN SUBSTRING(pHost,1,7) = "".
    IF  NUM-ENTRIES(pHost,"/") > 1 THEN
        ASSIGN pHost = ENTRY(1,pHost, "/").
    IF  NUM-ENTRIES(pHost, ":") > 1 THEN
        ASSIGN pHost = ENTRY(1, pHost, ":").
    IF  vHost BEGINS "http://" THEN
        ASSIGN SUBSTRING(vHost,1,7) = "".
    IF  NUM-ENTRIES(vHost, ":") > 1 THEN 
        ASSIGN vPort = ENTRY(2, vHost, ":")
               vHost = ENTRY(1, vHost, ":").
    ELSE 
        ASSIGN vPort = "80".

    ASSIGN wloop = YES.
   
    CREATE SOCKET vSocket.
    vSocket:SET-READ-RESPONSE-PROCEDURE ("readHandler", THIS-PROCEDURE).
    ASSIGN wstatus = vSocket:CONNECT("-H " + vHost + " -S " + vPort) NO-ERROR.
    IF  wstatus = NO THEN DO:
        ASSIGN pStatus = -1.
        DELETE OBJECT vSocket.
        SET-SIZE(mBuffer) = 0.
        SET-SIZE(rBuffer) = 0.
        SET-SIZE(hBuffer) = 0.
        RETURN.
    END.
   
    IF  GET-SIZE(pBuffer) = 0 THEN DO:
        ASSIGN vStr = "GET " + urlHost + "/NeoGridHTTPChannel?queuename=" + pQueue + " HTTP/1.0~n" +
                      "Host: " + pHost + "~n" +
                      "Accept: text/xml~n" + 
                      IF  c-authorization = "" THEN "~n" ELSE ("NeoGrid-authorization: " + c-authorization + "~n~n").
        SET-SIZE(hBuffer) = 0.
        SET-SIZE(hBuffer) = LENGTH(vStr) + 1.
        PUT-STRING(hBuffer,1) = vStr.
        ASSIGN l-read = vSocket:WRITE(hBuffer, 1, LENGTH(vStr)) NO-ERROR.
    END.
    ELSE DO:
        ASSIGN vStr = "POST " + urlHost + "/NeoGridHTTPChannel HTTP/1.0~n" +
                      "Host: " + pHost + "~n" +
                      "Content-length: " + STRING(GET-SIZE(pBuffer) - 1) + "~n" +
                      "Content-type: text/xml~n" +
                      "NeoGrid-queuename: " + pQueue + "~n" + 
                      IF  c-authorization = "" THEN 
                          (IF  c-priority = "" THEN "~n" ELSE ("NeoGrid-priority: " + c-priority + "~n~n")) 
                      ELSE 
                          ("NeoGrid-authorization: " + c-authorization + "~n") + (IF  c-priority = "" THEN "~n" ELSE ("NeoGrid-priority: " + c-priority + "~n~n")).
        SET-SIZE(hBuffer) = 0.
        SET-SIZE(hBuffer) = LENGTH(vStr) + GET-SIZE(pBuffer) + 1.
        ASSIGN post-tam  = GET-SIZE(pBuffer)
              l-post-tam = LENGTH(vStr) + 1.
        PUT-STRING(hBuffer,1) = vStr.
        DO  post-aux = 1 TO post-tam BY 30000:                    
            IF  (post-tam - post-aux + 1) < 30000 THEN DO:                 
                PUT-BYTES(hBuffer,l-post-tam) = GET-BYTES(pBuffer,post-aux,(post-tam - post-aux) + 1). 
                ASSIGN l-post-tam = l-post-tam + (post-tam - post-aux) + 1.      
            END.                                                       
            ELSE DO:                                                   
                PUT-BYTES(hBuffer,l-post-tam) = GET-BYTES(pBuffer,post-aux,30000).                 
                ASSIGN l-post-tam = l-post-tam + 30000.                      
            END.                                                       
        END.
        ASSIGN l-write = vSocket:WRITE(hBuffer, 1, GET-SIZE(hBuffer)).
    END.
    
    SET-SIZE(hBuffer) = 0.
    
    DO  WHILE wloop:              
        WAIT-FOR READ-RESPONSE OF vSocket.
    END.

    vSocket:DISCONNECT().
    DELETE OBJECT vSocket.
    
    ASSIGN iMessage = 1.
    
    DO  aux = 1 TO (lBuffer - 1):
        IF  GET-STRING(mBuffer,aux,2) = (CHR(13) + CHR(10)) THEN DO:
            ASSIGN lin = GET-STRING(mBuffer,ini,aux - ini)
                   ini = aux + 2.
            IF  lin BEGINS "HTTP" THEN 
                ASSIGN pStatus = DECIMAL(ENTRY(2,lin," ")).
            ELSE
                IF  lin = "" THEN DO:
                    ASSIGN iMessage = aux + 2.
                    LEAVE.
                END.
        END.
    END.
    
    IF  GET-SIZE(pBuffer) = 0 THEN DO:
        SET-SIZE(pBuffer) = (lBuffer - iMessage) + 100.
        ASSIGN ini = 1.
        DO  aux = iMessage TO lBuffer BY 30000:
            IF (lBuffer - aux + 1) < 30000 THEN
                PUT-BYTES(pBuffer,ini) = GET-BYTES(mBuffer,aux,(lBuffer - aux) + 1).
            ELSE
                PUT-BYTES(pBuffer,ini) = GET-BYTES(mBuffer,aux,30000).
            ASSIGN ini = ini + 30000.
        END.
    END.
    
    SET-SIZE(mBuffer) = 0.

END PROCEDURE.

PROCEDURE readHandler:
    DEF VAR pLen                         AS INT      NO-UNDO.
    DEF VAR l-read                       AS LOG      NO-UNDO.
    DEF VAR read-aux                     AS INT      NO-UNDO.
    
    IF  vSocket:CONNECTED() THEN DO:
        ASSIGN pLen = vSocket:GET-BYTES-AVAILABLE(). 
        IF  pLen > 0 THEN DO:
            SET-SIZE(rBuffer) = 0.
            SET-SIZE(rBuffer) = pLen + 1.
            ASSIGN l-read = NO
                   l-read = vSocket:READ(rBuffer,1,pLen,1)
                   pLen   = vSocket:BYTES-READ.
            DO  read-aux = 1 TO pLen BY 30000:
                IF (pLen - read-aux + 1) < 30000 THEN DO:
                    PUT-BYTES(mBuffer,lBuffer) = GET-BYTES(rBuffer,read-aux,(Plen - read-aux) + 1).
                    ASSIGN lBuffer = lBuffer + (Plen - read-aux) + 1.
                END.
                ELSE DO:
                    PUT-BYTES(mBuffer,lBuffer) = GET-BYTES(rBuffer,read-aux,30000).
                    ASSIGN lBuffer = lBuffer + 30000.
                END.
            END.
            SET-SIZE(rBuffer) = 0.
        END.
        ASSIGN wloop = YES.
    END.
    ELSE DO:
        ASSIGN wloop = NO.
        vSocket:DISCONNECT().
    END.
END.
