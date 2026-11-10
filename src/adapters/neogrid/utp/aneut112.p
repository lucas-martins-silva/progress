/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEUT112 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEUT112 MUT}
&ENDIF



/*&IF SUBSTRING(PROVERSION,1,1) >= "9" &THEN*/
/*tech14207 - FO 1350.216 - 26072006*/
&IF int(entry(1,proversion,".")) >= 9 &THEN
/*Fim da altera‡Æo - tech14207 - FO 1350.216 - 26072006*/

    {adapters/neogrid/include/anein104.i}
    {adapters/neogrid/include/anein112.i} 

    DEF VAR l-crm AS LOG INIT NO.
    DEF VAR l-b2b AS LOG INIT NO.
    
    RUN utp/ut-crm.p.
    ASSIGN l-crm = (return-value = "YES").
    
    RUN utp/ut-neog.p.
    ASSIGN l-b2b = IF RETURN-VALUE = "NOK" THEN NO ELSE YES.
    
    DEF VAR i-delay     AS INT INIT 5.
    DEF VAR l-proc      AS LOG INIT NO.
    DEF VAR v-start-aut AS LOG INIT NO.
    
    DEF BUTTON bt-inicia  LABEL "Inicia Processamento"  SIZE 30 by 1.5 AUTO-ENDKEY.
    DEF BUTTON bt-encerra LABEL "Encerra Processamento" SIZE 30 by 1.5 AUTO-ENDKEY.
    DEF BUTTON bt-fecha   LABEL "Fechar"                SIZE 10 by 1.5 AUTO-ENDKEY.
    DEF FRAME fr-encerra 
        bt-inicia   AT 01
        bt-encerra  AT 31
        bt-fecha    AT 61
        WITH ROW 1 COL 1 NO-LABELS.
    
    ON  CHOOSE OF bt-inicia IN FRAME fr-encerra DO:
        ASSIGN l-proc = YES.
        DISABLE bt-inicia bt-fecha WITH FRAME fr-encerra.
        ENABLE bt-encerra WITH FRAME fr-encerra.
    END. 
    ON  CHOOSE OF bt-encerra IN FRAME fr-encerra DO:
        ASSIGN l-proc = NO.
        DISABLE bt-encerra WITH FRAME fr-encerra.
        ENABLE bt-inicia bt-fecha WITH FRAME fr-encerra.
    END. 
    ON  CHOOSE OF bt-fecha IN FRAME fr-encerra DO:
        QUIT.
    END. 
    
    DEF BUFFER b-MessageQueue FOR NGMessageQueue.
    
    IF  PROGRAM-NAME(2) <> ? THEN
        ASSIGN l-proc = YES.
    ELSE DO:
        ENABLE bt-inicia bt-fecha WITH FRAME fr-encerra.
        CURRENT-WINDOW:TITLE              = "Connector HTTP - ANEUT112.W ".
        CURRENT-WINDOW:HIDDEN             = YES.
        CURRENT-WINDOW:HEIGHT             = 1.6.
        CURRENT-WINDOW:WIDTH              = 95.50.
        CURRENT-WINDOW:MAX-HEIGHT         = 1.6.
        CURRENT-WINDOW:MAX-WIDTH          = 95.50.
        CURRENT-WINDOW:VIRTUAL-HEIGHT     = 1.6.
        CURRENT-WINDOW:VIRTUAL-WIDTH      = 95.50. 
        CURRENT-WINDOW:BGCOLOR            = ?.
        CURRENT-WINDOW:FGCOLOR            = ?.
        CURRENT-WINDOW:KEEP-FRAME-Z-ORDER = yes.
        CURRENT-WINDOW:SENSITIVE          = yes.
        PAUSE 1 NO-MESSAGE. 
        IF  NUM-ENTRIES(SESSION:PARAMETER) = 1  
        AND ENTRY(1,SESSION:PARAMETER) <> "" THEN
            ASSIGN v-start-aut = YES.
    END.
    
    FIND FIRST param-global NO-LOCK. 

    FIND FIRST ngadapterparms NO-LOCK NO-ERROR.
    IF  AVAIL ngadapterparms THEN DO:
        ASSIGN i-delay = IF v-start-aut = YES THEN 1 ELSE IF INTEGER(SUBSTR(ngadapterparms.queuename,1,5)) >= 1 THEN INTEGER(SUBSTR(ngadapterparms.queuename,1,5)) ELSE 5.

        IF l-b2b AND ngadapterparms.char-1 <> "" THEN DO:
            IF  NUM-ENTRIES(ngadapterparms.char-1,",") >= 3 THEN DO:
                ASSIGN HostName        = ENTRY(2,ngadapterparms.char-1,",")
                       QueueName       = ENTRY(3,ngadapterparms.char-1,",")
                       c-authorization = IF  NUM-ENTRIES(ngadapterparms.char-1,",") = 4 THEN ENTRY(4,ngadapterparms.char-1,",") ELSE "".

                REPEAT:
                    REPEAT:
                        IF  l-proc = YES THEN DO:
                            RUN pi-verifica-http.
                            RUN pi-verifica-tabelas(NO).
                        END.
                        IF  PROGRAM-NAME(2) <> ? THEN
                            LEAVE.
                        WAIT-FOR WINDOW-CLOSE OF THIS-PROCEDURE PAUSE i-delay.
                        FIND FIRST ngadapterparms NO-LOCK NO-ERROR.
                        IF  AVAIL ngadapterparms THEN 
                            ASSIGN i-delay = IF INTEGER(SUBSTR(ngadapterparms.queuename,1,5)) >= 1 THEN INTEGER(SUBSTR(ngadapterparms.queuename,1,5)) ELSE 5.
                        IF  v-start-aut = YES THEN DO:
                            ASSIGN v-start-aut = NO.
                            APPLY "choose" TO bt-inicia IN FRAME fr-encerra.
                        END.
                    END.
                    IF  PROGRAM-NAME(2) <> ? THEN LEAVE.
                END. /* repeat */
            END. /* if num-entries */
        END. /* if avail funcao */

        IF ngadapterparms.queuemanager <> "" THEN DO:
            IF  NUM-ENTRIES(ngadapterparms.queuemanager,",") >= 3 THEN DO:
                ASSIGN HostName        = ENTRY(2,ngadapterparms.queuemanager,",")
                       QueueName       = ENTRY(3,ngadapterparms.queuemanager,",")
                       c-authorization = IF  NUM-ENTRIES(ngadapterparms.queuemanager,",") = 4 THEN ENTRY(4,ngadapterparms.queuemanager,",") ELSE "".
                REPEAT:
                    REPEAT:
                        IF  l-proc = YES THEN DO:
                            RUN pi-verifica-http.
                            RUN pi-verifica-tabelas(YES).
                        END.
                        IF  PROGRAM-NAME(2) <> ? THEN
                            LEAVE.
                        WAIT-FOR WINDOW-CLOSE OF THIS-PROCEDURE PAUSE i-delay.
                        FIND FIRST ngadapterparms NO-LOCK NO-ERROR.
                        IF  AVAIL ngadapterparms THEN 
                            ASSIGN i-delay = IF INTEGER(SUBSTR(ngadapterparms.queuename,1,5)) >= 1 THEN INTEGER(SUBSTR(ngadapterparms.queuename,1,5)) ELSE 5.
                        IF  v-start-aut = YES THEN DO:
                            ASSIGN v-start-aut = NO.
                            APPLY "choose" TO bt-inicia IN FRAME fr-encerra.
                        END.
                    END.
                    IF  PROGRAM-NAME(2) <> ? THEN
                        LEAVE.
                END.
            END.
        END.
        
    END.
    ELSE
        MESSAGE "Faltam os parƒmetros para conexÆo" VIEW-AS ALERT-BOX.
    
    IF  PROGRAM-NAME(2) = ? THEN
        QUIT.
    
    RETURN.
    
    /*************************/
    PROCEDURE pi-verifica-http:
    /*************************/
        DEF VAR pBufferGet AS MEMPTR NO-UNDO.    
        DEF VAR reason AS INTEGER NO-UNDO.
        DEF VAR iCont1 AS INTEGER.
        DEF VAR i-tamanho AS INTEGER.
        DEF VAR i-tamanho1 AS INTEGER.
        DEF VAR DataLength AS INTEGER.
        
        REPEAT:
            FOR EACH tt-msg-xml EXCLUSIVE-LOCK:
                DELETE tt-msg-xml.
            END.
            SET-SIZE(pBufferGet) = 0.
            
            RUN HTTPChannel (INPUT HostName, INPUT QueueName, INPUT-OUTPUT pBufferGet, OUTPUT reason).
            IF  reason <> 200 THEN DO:
                IF  reason <> 204 THEN DO:
                    IF  reason = 401 THEN
                        STATUS INPUT "Status: Autoriza‡Æo negada (401)".
                    ELSE    
                        IF  reason = 404 THEN
                            STATUS INPUT "Status: Receiver - Fila nÆo encontrada (404)".
                        ELSE
                            IF  reason = 405 THEN
                                STATUS INPUT "Status: Receiver - Canal HTTP nÆo encontrado (405)".
                            ELSE
                                IF  reason = 500 THEN
                                    STATUS INPUT "Status: Check Server Configuration".
                                ELSE
                                    STATUS INPUT "Status: Receiver - Erro nÆo identificado (" + TRIM(STRING(REASON,"->>>9")) + ")".
                END.
                ELSE
                    STATUS INPUT "Status: OK".
                LEAVE.
            END.
            ELSE
                STATUS INPUT "Status: OK".
            ASSIGN DataLength = GET-SIZE(pBufferGet) - 1
                   iCont1 = 1
                   i-tamanho = 0
                   i-tamanho1 = 30000.
            IF DataLength > 30000 then do:
                if (DataLength - i-tamanho) < 30000 then
                    assign i-tamanho1 = DataLength - i-tamanho.
                do while i-tamanho <= DataLength AND i-tamanho1 <> 0:
                    create tt-msg-xml.
                    assign tt-msg-xml.sequencia = iCont1 
                           tt-msg-xml.conteudo  = get-string(pBufferGet,(i-tamanho + 1),i-tamanho1)
                           iCont1 = iCont1 + 1
                           i-tamanho = i-tamanho + i-tamanho1.
                    if (DataLength - i-tamanho) < 30000 then
                        assign i-tamanho1 = DataLength - i-tamanho.
                END. 
            END.
            ELSE DO:
                CREATE tt-msg-xml.
                ASSIGN tt-msg-xml.sequencia = 1 
                       tt-msg-xml.conteudo = GET-STRING(pBufferGet, 1).
            END.
            RUN pi-trata-mensagem.
        END.                       
        SET-SIZE(pBufferGet) = 0.
    
    END PROCEDURE.
    
    /**************************/
    PROCEDURE pi-trata-mensagem:
    /**************************/
        DEF VAR dt        AS CHAR.
        DEF VAR id        AS INTEGER.
        
        ASSIGN id = NEXT-VALUE(sq_ngmessagequeue).
            
        FOR EACH tt-msg-xml NO-LOCK:
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
        FOR EACH tt-msg-xml EXCLUSIVE-LOCK:
            DELETE tt-msg-xml.
        END.
        ASSIGN c-erro = "NI".
        FOR EACH NGMessageQueue NO-LOCK
            WHERE NGMessageQueue.NGMessageQueueName =  "OUT":U
              AND NGMessageQueue.Done               =  FALSE 
              AND NGMessageQueue.NGMessageQueueID   >  0
              AND NGMessageQueue.XMLMessage         <> ""
              AND NGMessageQueue.log-1              = p-crm 
            BREAK BY NGMessageQueue.NGMessageQueueID:
            IF  FIRST-OF(NGMessageQueue.NGMessageQueueID) THEN DO:
                FOR EACH b-MessageQueue EXCLUSIVE-LOCK
                    WHERE b-MessageQueue.NGMessageQueueName = "OUT":U 
                      AND b-MessageQueue.NGMessageQueueID   = NGMessageQueue.NGMessageQueueID 
                      AND b-MessageQueue.Done               = FALSE
                      AND b-MessageQueue.log-1              = p-crm
                    BY b-messagequeue.ngmessagequeuesequence:
                    CREATE tt-msg-xml.
                    ASSIGN tt-msg-xml.sequencia = b-MessageQueue.NGMessageQueueSequence
                           tt-msg-xml.conteudo  = b-MessageQueue.XMLMessage.
                END.
                FIND FIRST tt-msg-xml EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL tt-msg-xml THEN DO:
                    RUN pi-envia-mensagem (INPUT-OUTPUT c-erro).
                    IF  c-erro = "" THEN DO:
                        FOR EACH  b-MessageQueue EXCLUSIVE-LOCK
                            WHERE b-MessageQueue.NGMessageQueueName = "OUT" 
                              AND b-MessageQueue.NGMessageQueueID   = NGMessageQueue.NGMessageQueueID 
                              AND b-MessageQueue.Done               = NO
                              AND b-MessageQueue.log-1              = p-crm:
                            ASSIGN b-MessageQueue.Done = TRUE.
                            RELEASE b-MessageQueue.
                        END.
                    END.
                    FOR EACH tt-msg-xml EXCLUSIVE-LOCK:
                        DELETE tt-msg-xml.
                    END.
                END.
                ASSIGN c-erro = "NI".
            END.
        END.
    END PROCEDURE.
    
    /**************************/
    PROCEDURE pi-envia-mensagem:
    /**************************/
        DEF INPUT-OUTPUT PARAMETER c-erro AS CHAR NO-UNDO.
        DEF VAR pBufferPost AS MEMPTR NO-UNDO.    
        DEF VAR reason AS INTEGER NO-UNDO.
        DEF VAR i-tamanho AS INTEGER NO-UNDO.
        FOR EACH tt-msg-xml NO-LOCK:                 
            ASSIGN i-tamanho = i-tamanho + LENGTH(tt-msg-xml.conteudo).
        END.
        SET-SIZE(pBufferPost) = i-tamanho + 1.
        ASSIGN i-tamanho = 0.
        FOR EACH tt-msg-xml NO-LOCK:
            /* Para definir prioridade de algum tipo de mensagem
            IF  tt-msg-xml.conteudo MATCHES "*SalesOrderAcknowledgement*" THEN
                ASSIGN c-priority = "1".
            */
            PUT-STRING(pBufferPost,i-tamanho + 1) = tt-msg-xml.conteudo. 
            ASSIGN i-tamanho = i-tamanho + LENGTH(tt-msg-xml.conteudo).        
            DELETE tt-msg-xml.
        END.                     
        RUN HTTPChannel (INPUT HostName, INPUT QueueName, INPUT-OUTPUT pBufferPost, OUTPUT reason).
        SET-SIZE(pBufferPost) = 0.
        IF  reason <> 200 THEN DO:
            IF  reason = 204 THEN DO:
                STATUS INPUT "Status: Conteudo da mensagem invalido (204)".
                ASSIGN c-erro = "204".
            END.
            ELSE
                IF  reason = 401 THEN DO:
                    STATUS INPUT "Status: Autorizacao negada (401)".
                    ASSIGN c-erro = "401".
                END.
                ELSE    
                    IF  reason = 404 THEN DO:
                        STATUS INPUT "Status: Sender - Fila nao encontrada (404)".
                        ASSIGN c-erro = "404".
                    END.
                    ELSE 
                        IF  reason = 405 THEN DO:
                            STATUS INPUT "Status: Sender - Canal HTTP nao encontrado (405)".
                            ASSIGN c-erro = "405".
                        END.
                        ELSE
                            IF  reason = 500 THEN DO:
                                STATUS INPUT "Status: Check Server Configuration".
                                ASSIGN c-erro = "500".
                            END.
                            ELSE DO:
                                STATUS INPUT "Status: Sender - Erro nao identificado (" + TRIM(STRING(REASON,"->>>9")) + ")".
                                ASSIGN c-erro = "NI".
                            END.
        END.
        ELSE DO:
            ASSIGN c-erro = "".
            STATUS INPUT "Status: OK".
        END.
        RETURN c-erro.
    END PROCEDURE.

&ENDIF
