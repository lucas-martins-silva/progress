/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCQ0113 2.00.00.005 } /*** 010005 ***/

/***********************************************************************
** Programa: agro-upc/ggcq0113.p
** Objetivo: Campo para informar se nota do Recebimento procissa de pedido
************************************************************************/

DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET     NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID      NO-UNDO.


/* Projeto DAGR001 - IRM1909 - Replanejamento 11.8 para 11.5.10 - classifica‡Æo     */
{ggp/gg0001.i}


DEFINE VARIABLE h-win AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-char    AS CHARACTER  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-contr-classif-cq0113  AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gr-rw-item  AS ROWID NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gr-rw-item1 AS ROWID NO-UNDO.


define new global shared var wh-button           as widget-handle  no-undo.
define new global shared var wh-button1          as widget-handle  no-undo.

ASSIGN h-win = p-wgh-object.
IF NOT VALID-HANDLE(h-win) THEN RETURN "OK".
ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/").

/**************************************************************************/

/* MESSAGE "Evento ...:"   p-ind-event   SKIP               */
/*         "Objeto ...:"   p-ind-object  SKIP               */
/*         "HObjeto...:"   p-wgh-object  SKIP               */
/*         "hFrame ...:"   p-wgh-frame   SKIP               */
/*         "Tabela ...:"   p-cod-table   SKIP               */
/*         "Rowid  ...:"   string(p-row-table)   SKIP       */
/*         "NomeObjeto:"   c-char   . */


IF  p-ind-event  = "before-INITIALIZE" AND
    p-ind-object = "container" AND
    c-char       = "cq0113.w"     THEN DO:

    create toggle-box wh-contr-classif-cq0113
    assign frame     = p-wgh-frame
           col       = 68.0
           row       = 5.08
           visible   = YES
           sensitive = NO
           checked   = yes
           help      = "Controle Classifica‡Æo"
           label     = "Controle Classifica‡Æo".


    /* Sarah - 16/10/08 */
    create button wh-button 
    assign frame = p-wgh-frame
         width      = 4
         height     = 1.25
         row        = 1.13
         col        = 62
         visible    = yes
         sensitive  = YES
         FONT       = 4
         label      = "Melhoria PH"
         TOOLTIP    = "Melhoria PH"
         name       = "bt-ph"

         triggers:      
            on 'choose'  persistent
            run ggp/gg1085.w.
         end triggers.
         wh-button:LOAD-IMAGE('image/im-ph.bmp').

    create button wh-button1 
    assign frame = p-wgh-frame
         width      = 4
         height     = 1.25
         row        = 1.13
         col        = 57
         visible    = yes
         sensitive  = YES
         FONT       = 4
         label      = "Faixas PH"
         TOOLTIP    = "Faixas PH"
         name       = "bt-fx"

         triggers:      
            on 'choose'  persistent
            run ggp/gg1086.w.
         end triggers.
         wh-button1:LOAD-IMAGE('image/im-ran_a.bmp').

END.

IF  p-ind-event  = "after-enable"     AND
p-ind-object = "container" AND
    c-char       = "cq0113.w" THEN DO:

    ASSIGN wh-contr-classif-cq0113:SENSITIVE = YES.
END.

IF  p-ind-event  = "after-disable"    AND
    p-ind-object = "container" AND
    c-char       = "cq0113.w" THEN DO:
    ASSIGN wh-contr-classif-cq0113:SENSITIVE = NO.
END.

IF  p-ind-event  = "after-DISPLAY"        AND
    c-char       = "cq0113.w" THEN DO:

    ASSIGN gr-rw-item  = ?
           gr-rw-item1 = ?.

    FIND FIRST ITEM WHERE
         ROWID(item) = p-row-table NO-LOCK NO-ERROR.
    IF  AVAIL item THEN DO:

        ASSIGN gr-rw-item  = ROWID(ITEM)
               gr-rw-item1 = ROWID(ITEM).

        FIND FIRST gg-ext-item
            WHERE gg-ext-item.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL gg-ext-item THEN
            ASSIGN wh-contr-classif-cq0113:CHECKED = gg-ext-item.log-controle-clas.
        ELSE
            ASSIGN wh-contr-classif-cq0113:CHECKED = NO.
    END.
END.

IF  p-ind-event  = "after-ASSIGN"  AND
    c-char       = "cq0113.w"      THEN DO:
    
    FIND FIRST item NO-LOCK WHERE
         ROWID(item) = p-row-table  NO-ERROR.
    IF  AVAIL item THEN DO:
        FIND FIRST gg-ext-item
            WHERE gg-ext-item.it-codigo = ITEM.it-codigo EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL gg-ext-item THEN DO:
            CREATE gg-ext-item.
            ASSIGN gg-ext-item.it-codigo            = ITEM.it-codigo.
        END.
        ASSIGN gg-ext-item.log-controle-clas = wh-contr-classif-cq0113:CHECKED.
    END.
END.
