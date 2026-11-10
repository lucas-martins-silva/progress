/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCM0102 2.00.00.001 } /*** 010001 ***/


/***********************************************************************
** Programa: agro-upc/ggpd0806.p
** Objetivo: Toggle-box para informar se libera bloqueio de vendas MI
************************************************************************/
DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET     NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID      NO-UNDO.

DEFINE VARIABLE h-win AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-char    AS CHARACTER  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cm0102-tg-libera-bloq-graos AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cm0102-tg-aval-multi-emp   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cm0102-ind-lib-estoque     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-window                      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-window-cm0102               AS WIDGET-HANDLE NO-UNDO.

/*Alan*/
DEFINE NEW GLOBAL SHARED VARIABLE wh-cm0102-rt-mold-4          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cm0102-rect-16            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cm0102-rect-29            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cm0102-ind-abrange-aval   AS WIDGET-HANDLE NO-UNDO.



ASSIGN h-win = p-wgh-object.
IF NOT VALID-HANDLE(h-win) THEN RETURN "OK".
ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/").
/**************************************************************************/
 /*MESSAGE "Evento ...:"   p-ind-event           SKIP
         "Objeto ...:"   p-ind-object          SKIP
         "HObjeto...:"   p-wgh-object          SKIP
         "hFrame ...:"   p-wgh-frame           SKIP
         "Tabela ...:"   p-cod-table           SKIP
         "Rowid  ...:"   string(p-row-table)   SKIP
         "NomeObjeto:"   c-char                VIEW-AS ALERT-BOX.*/

DEF VAR wgh-grupo        AS WIDGET-HANDLE NO-UNDO.
DEF VAR wgh-child        AS WIDGET-HANDLE NO-UNDO.

IF p-ind-event  = "INITIALIZE":U AND
   p-ind-object = "container":U THEN DO:
    
    ASSIGN wh-window = p-wgh-frame:PARENT.  /* pegando o Field-Group */
    ASSIGN wh-window = wh-window:FIRST-CHILD. /* pegando o 1o. Campo */
    ASSIGN wh-window = wh-window:PARENT.    
    ASSIGN wh-window:HEIGHT = wh-window:HEIGHT + 1.

    ASSIGN wh-window = p-wgh-frame:PARENT.   /* pegando o Field-Group */
    ASSIGN wh-window = wh-window:FIRST-CHILD.  /* pegando o 1o. Campo */
    ASSIGN wh-window:HEIGHT = wh-window:HEIGHT + 1.

    ASSIGN wh-window = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN wh-window = wh-window:FIRST-CHILD.     /* pegando o 1o. Campo */
          
    DO WHILE wh-window <> ? :
        if wh-window:type <> "field-group":U then do:  
           IF wh-window:NAME = "f-main":U THEN DO :
               ASSIGN wh-window:HEIGHT = wh-window:HEIGHT + 1.
           END.
           ASSIGN wh-window = wh-window:NEXT-SIBLING.
        end. 
        else do:
            assign wh-window = wh-window:first-child.
        end.
    END.

    IF VALID-HANDLE(wh-cm0102-ind-abrange-aval) THEN
        ASSIGN wh-cm0102-ind-abrange-aval:WIDTH = wh-cm0102-ind-abrange-aval:WIDTH - 3 NO-ERROR.

    IF VALID-HANDLE(wh-cm0102-rt-mold-4) THEN
        ASSIGN wh-cm0102-rt-mold-4:HEIGHT = wh-cm0102-rt-mold-4:HEIGHT + 1 NO-ERROR.

    IF VALID-HANDLE(wh-cm0102-rect-16) THEN
        ASSIGN wh-cm0102-rect-16:HEIGHT = wh-cm0102-rect-16:HEIGHT + 1
               wh-cm0102-rect-16:WIDTH  = wh-cm0102-rect-16:WIDTH  - 3 NO-ERROR.

    IF VALID-HANDLE(wh-cm0102-rect-29) THEN
        ASSIGN wh-cm0102-rect-29:HEIGHT = wh-cm0102-rect-29:HEIGHT + 1
               wh-cm0102-rect-29:COL    = wh-cm0102-rect-29:COL    - 3
               wh-cm0102-rect-29:WIDTH  = wh-cm0102-rect-29:WIDTH  + 3 NO-ERROR.

    IF VALID-HANDLE(wgh-cm0102-tg-aval-multi-emp) THEN
        ASSIGN wgh-cm0102-tg-aval-multi-emp:COL = wgh-cm0102-tg-aval-multi-emp:COL - 3 NO-ERROR.

    IF VALID-HANDLE(wgh-cm0102-ind-lib-estoque) THEN
        ASSIGN wgh-cm0102-ind-lib-estoque:COL = wgh-cm0102-ind-lib-estoque:COL - 3 NO-ERROR.

    CREATE TOGGLE-BOX wh-cm0102-tg-libera-bloq-graos
    ASSIGN  frame     = p-wgh-frame
            row       = 17.6 
            column    = 63  
            height    = 1
            width     = 25
            tooltip   = "Libera Bloqueio Vendas Gr∆os"
            help      = "Libera Bloqueio Vendas Gr∆os"
            label     = "Libera Bloqueio Vendas Gr∆os"
            sensitive = NO
            visible   = TRUE
            FONT      = 1.

END.

IF  p-ind-event    = "INITIALIZE" AND
    p-ind-object   = "VIEWER"     AND
    c-char         = "v32ad098.w" THEN DO:

    assign wgh-grupo = p-wgh-frame:first-child.
    do while valid-handle(wgh-grupo):
       assign  wgh-child = wgh-grupo:first-child.
       do  while valid-handle(wgh-child):
           case wgh-child:type :
                when "TOGGLE-BOX" then do:
                    if  wgh-child:name = "ind-lib-estoque" THEN
                        assign wgh-cm0102-ind-lib-estoque = wgh-child:handle.
                    if  wgh-child:name = "tg-aval-multi-emp" THEN
                        assign wgh-cm0102-tg-aval-multi-emp = wgh-child:handle.
                end.
                when "RECTANGLE" then do:
                    if wgh-child:name = "rt-mold-4" then 
                         assign wh-cm0102-rt-mold-4 = wgh-child:handle.
                    if wgh-child:name = "rect-16" then 
                         assign wh-cm0102-rect-16 = wgh-child:handle.
                    if wgh-child:name = "rect-29" then 
                         assign wh-cm0102-rect-29 = wgh-child:handle.
                end.
                when "RADIO-SET" then do:
                    if wgh-child:name = "ind-abrange-aval" then 
                        ASSIGN wh-cm0102-ind-abrange-aval = wgh-child:handle.
                END.
           END.
           ASSIGN wgh-child = wgh-child:NEXT-SIBLING.
       END.
       ASSIGN wgh-grupo = wgh-grupo:NEXT-SIBLING.
    END.

    ASSIGN wh-window        = p-wgh-frame
           wh-window-cm0102 = p-wgh-frame:PARENT. /* Busca o handle da window */
        
END.

IF  p-ind-event  = "DISPLAY"    AND
    p-ind-object = "viewer"     AND
    c-char       = "v32ad098.w" THEN DO:

    IF VALID-HANDLE(wh-cm0102-tg-libera-bloq-graos) THEN DO:
    
        FIND FIRST emitente WHERE
             ROWID(emitente) = p-row-table NO-LOCK NO-ERROR.
        IF  AVAIL emitente THEN DO:
            FIND FIRST gg-ext-emitente
                WHERE gg-ext-emitente.cod-emitente = emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL gg-ext-emitente THEN
                ASSIGN wh-cm0102-tg-libera-bloq-graos:CHECKED = gg-ext-emitente.log-libera-vmi.
            ELSE
                ASSIGN wh-cm0102-tg-libera-bloq-graos:CHECKED = NO.
        END.
    END.
END.

IF  p-ind-event  = "ASSIGN"     AND
    p-ind-object = "viewer"     AND
    c-char       = "v32ad098.w" THEN DO:

    FIND FIRST emitente WHERE
         ROWID(emitente) = p-row-table NO-LOCK NO-ERROR.
    IF  AVAIL emitente THEN DO:
        FIND FIRST gg-ext-emitente
            WHERE gg-ext-emitente.cod-emitente = emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL gg-ext-emitente THEN DO:
            CREATE gg-ext-emitente.
            ASSIGN gg-ext-emitente.cod-emitente = emitente.cod-emitente.
        END.
            ASSIGN gg-ext-emitente.log-libera-vmi = wh-cm0102-tg-libera-bloq-graos:CHECKED.
    END.
END.

IF  p-ind-event  = "ENABLE"     AND
    p-ind-object = "viewer"     AND
    c-char       = "v32ad098.w" THEN
    ASSIGN wh-cm0102-tg-libera-bloq-graos:SENSITIVE = YES.

IF  p-ind-event  = "DISABLE"    AND
    p-ind-object = "viewer"     AND
    c-char       = "v32ad098.w" THEN
    ASSIGN wh-cm0102-tg-libera-bloq-graos:SENSITIVE = NO.
