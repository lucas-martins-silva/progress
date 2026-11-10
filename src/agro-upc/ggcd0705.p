/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCD0705 2.00.00.002 } /*** 010002 ***/

/*************************************************************************
**    Programa.:  ggcd0706
**    Objetivo.:  Zoom espec¡fico de Contratos
**    Data.....: novembro/2005
*************************************************************************/
{utp/ut-glob.i}
/*********************** Defini‡Æo de Parametros *************************/
define input parameter p-ind-event               as character      no-undo.
define input parameter p-ind-object              as character      no-undo.
define input parameter p-wgh-object              as handle         no-undo.
define input parameter p-wgh-frame               as widget-handle  no-undo.
define input parameter p-cod-table               as character      no-undo.
define input parameter p-row-table               as rowid          no-undo.

/******************* Defini»’o de Variaveis Globais **********************/
DEFINE NEW GLOBAL SHARED VARIABLE wgh-grupo               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-objeto               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-child               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-frame                AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-ggcd0705              AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cd0705-bt-modificar AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cd0705-bt-eliminar  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cd0705-bt-mod-appc  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cd0705-bt-eli-appc  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cd0705-br-table     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cd0705-query        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cd0705-buffer       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-Column-cod-entrega    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cd0705-cod-emitente AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-char     AS CHAR    NO-UNDO.
DEFINE VARIABLE wgh-objeto AS HANDLE  NO-UNDO.
/* Global Variable Definitions **********************************************/

/* Variable Definitions *****************************************************/

ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/":U), p-wgh-object:FILE-NAME,"~/":U) NO-ERROR.
ASSIGN wgh-grupo = p-wgh-frame:FIRST-CHILD.

IF  p-ind-event  = "BEFORE-INITIALIZE" AND 
    p-ind-object = "CONTAINER"  THEN DO:
    
    RUN agro-upc/ggcd0705.p PERSISTENT SET h-ggcd0705 (INPUT "", 
                                                       INPUT "", 
                                                       INPUT ?, 
                                                       INPUT p-wgh-frame, 
                                                       INPUT "", 
                                                       INPUT ?).
END.

IF p-ind-event  = "INITIALIZE":U AND 
   p-ind-object = "VIEWER":U     AND 
   c-char       = "V17AD098.W":U THEN DO:

    ASSIGN wgh-objeto = p-wgh-frame:FIRST-CHILD.
    DO WHILE valid-handle(wgh-objeto):

        IF wgh-objeto:TYPE = "FILL-IN" THEN DO:
            case wgh-objeto:name:
                when "cod-emitente" then
                    assign wgh-cd0705-cod-emitente = wgh-objeto:handle.
            end case.
        end.
        if  valid-handle(wgh-objeto) then
            IF  wgh-objeto:type = "field-group" THEN 
                ASSIGN wgh-objeto = wgh-objeto:first-child.
            ELSE 
                ASSIGN wgh-objeto = wgh-objeto:next-sibling.
    END.
END.

IF p-ind-event  = "INITIALIZE":U AND 
   p-ind-object = "BROWSER":U    AND 
   c-char       = "B01DI102.W":U THEN DO:

    ASSIGN wgh-objeto = p-wgh-frame:FIRST-CHILD.
    DO WHILE valid-handle(wgh-objeto):

        IF wgh-objeto:TYPE = "button" THEN DO:
            case wgh-objeto:name:
                when "bt-modificar" then
                    assign wgh-cd0705-bt-modificar = wgh-objeto:handle.
                when "bt-eliminar" then
                    assign wgh-cd0705-bt-eliminar  = wgh-objeto:handle.
            end case.
        end.
        IF wgh-objeto:TYPE = "browse" THEN DO:
            case wgh-objeto:name:
                WHEN "br-table" THEN
                    assign wgh-cd0705-br-table = wgh-objeto:HANDLE
                           wgh-cd0705-query    = wgh-cd0705-br-table:QUERY
                           wgh-cd0705-buffer   = wgh-cd0705-query:GET-BUFFER-HANDLE(1).
            end case.
        END.
        if  valid-handle(wgh-objeto) then
            IF  wgh-objeto:type = "field-group" THEN 
                ASSIGN wgh-objeto = wgh-objeto:first-child.
            ELSE 
                ASSIGN wgh-objeto = wgh-objeto:next-sibling.
    END.

    IF VALID-HANDLE(h-ggcd0705) THEN DO:
        IF VALID-HANDLE(wgh-cd0705-bt-modificar) THEN DO:
            CREATE BUTTON wgh-cd0705-bt-mod-appc
            ASSIGN FRAME = p-wgh-frame
                   NAME  = "wgh-cd0705-bt-mod-appc"
                   TRIGGERS:
                       ON CHOOSE PERSISTENT RUN pi-executa-botao-mod-appc IN h-ggcd0705.
                   END TRIGGERS.

            ASSIGN wgh-cd0705-bt-mod-appc:width     = wgh-cd0705-bt-modificar:width
                   wgh-cd0705-bt-mod-appc:label     = wgh-cd0705-bt-modificar:label
                   wgh-cd0705-bt-mod-appc:row       = wgh-cd0705-bt-modificar:row
                   wgh-cd0705-bt-mod-appc:col       = wgh-cd0705-bt-modificar:col
                   wgh-cd0705-bt-mod-appc:font      = wgh-cd0705-bt-modificar:font
                   wgh-cd0705-bt-mod-appc:visible   = wgh-cd0705-bt-modificar:visible
                   wgh-cd0705-bt-mod-appc:sensitive = YES
                   wgh-cd0705-bt-mod-appc:tooltip   = wgh-cd0705-bt-modificar:tooltip
                   wgh-cd0705-bt-mod-appc:height    = wgh-cd0705-bt-modificar:height.
                
            wgh-cd0705-bt-mod-appc:MOVE-TO-TOP().
        END.
    
        IF VALID-HANDLE(wgh-cd0705-bt-eliminar) THEN DO:
    
            CREATE BUTTON wgh-cd0705-bt-eli-appc
            ASSIGN FRAME = p-wgh-frame
                   NAME  = "wgh-cd0705-bt-eli-appc"
                   TRIGGERS:
                       ON CHOOSE PERSISTENT RUN pi-executa-botao-eli-appc IN h-ggcd0705.
                   END TRIGGERS.
        
            ASSIGN wgh-cd0705-bt-eli-appc:width     = wgh-cd0705-bt-eliminar:width
                   wgh-cd0705-bt-eli-appc:label     = wgh-cd0705-bt-eliminar:label
                   wgh-cd0705-bt-eli-appc:row       = wgh-cd0705-bt-eliminar:row
                   wgh-cd0705-bt-eli-appc:col       = wgh-cd0705-bt-eliminar:col
                   wgh-cd0705-bt-eli-appc:font      = wgh-cd0705-bt-eliminar:font
                   wgh-cd0705-bt-eli-appc:visible   = wgh-cd0705-bt-eliminar:visible
                   wgh-cd0705-bt-eli-appc:sensitive = YES
                   wgh-cd0705-bt-eli-appc:tooltip   = wgh-cd0705-bt-eliminar:tooltip
                   wgh-cd0705-bt-eli-appc:height    = wgh-cd0705-bt-eliminar:height.
                
            wgh-cd0705-bt-eli-appc:MOVE-TO-TOP().
        END.
    END.
END.

PROCEDURE pi-executa-botao-mod-appc:

    IF VALID-HANDLE(wgh-cd0705-buffer) THEN
        ASSIGN h-Column-cod-entrega = wgh-cd0705-buffer:BUFFER-FIELD("cod-entrega").

    IF VALID-HANDLE(h-Column-cod-entrega)    AND 
       VALID-HANDLE(wgh-cd0705-cod-emitente) THEN DO:
        IF CAN-FIND (FIRST gg-inscricao
                     WHERE gg-inscricao.cod-emitente  = int(wgh-cd0705-cod-emitente:SCREEN-VALUE)
                     AND   gg-inscricao.cod-inscricao = h-Column-cod-entrega:BUFFER-VALUE) THEN DO:

            {utp/ut-liter.i "Manuten‡Æo" * R}
            RUN utp/ut-msgs.p(INPUT "SHOW":U,
                              INPUT 36593,
                              INPUT RETURN-VALUE).
            RETURN "NOK":U.
        END.
        ELSE 
            APPLY "choose":U TO wgh-cd0705-bt-modificar.
    END.
    
END PROCEDURE.

PROCEDURE pi-executa-botao-eli-appc:

    IF VALID-HANDLE(wgh-cd0705-buffer) THEN
        ASSIGN h-Column-cod-entrega = wgh-cd0705-buffer:BUFFER-FIELD("cod-entrega").

    IF VALID-HANDLE(h-Column-cod-entrega)    AND 
       VALID-HANDLE(wgh-cd0705-cod-emitente) THEN DO:
        IF CAN-FIND (FIRST gg-inscricao
                     WHERE gg-inscricao.cod-emitente  = int(wgh-cd0705-cod-emitente:SCREEN-VALUE)
                     AND   gg-inscricao.cod-inscricao = h-Column-cod-entrega:BUFFER-VALUE) THEN DO:

            {utp/ut-liter.i "Elimina‡Æo" * R}
            RUN utp/ut-msgs.p(INPUT "SHOW":U,
                              INPUT 36593,
                              INPUT RETURN-VALUE).
            RETURN "NOK":U.
        END.
        ELSE 
            APPLY "choose":U TO wgh-cd0705-bt-eliminar.
    END.

END PROCEDURE.

IF  p-ind-event = "DESTROY":U THEN DO:

    ASSIGN h-ggcd0705 = ?.

END.
