/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCD0704 2.00.00.007 } /*** 010007 ***/

/*************************************************************************
**    Programa.:  GGCD0704
**    Objetivo.:  Solicitar codigo do deposito e gravar na tabela de
**                extensÆo. 
**    Data.....:  Setenbro/2003
*************************************************************************/


{utp/ut-glob.i}


/*********************** Defini‡Æo de Parƒmetros *************************/
DEFINE INPUT PARAMETER p-ind-event               AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object              AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object              AS HANDLE         NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame               AS WIDGET-HANDLE  NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table               AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-row-table               AS ROWID          NO-UNDO.


/******************** Defini‡Æo de Vari veis Globais *********************/
Define New Global Shared Var adm-broker-hdl         as handle         no-undo.
Define New Global Shared Var h-viewer               as handle         no-undo.
DEFINE NEW GLOBAL SHARED VAR wh-folder-frm          AS HANDLE         NO-UNDO.


/******************** Defini‡Æo de Vari veis Locais **********************/
DEFINE VARIABLE c-folder  AS CHARACTER               NO-UNDO.
DEFINE VARIABLE h-folder  AS HANDLE                  NO-UNDO.
DEFINE VARIABLE c-objects AS CHARACTER               NO-UNDO.
DEFINE VARIABLE i-objects AS INTEGER                 NO-UNDO.
DEFINE VARIABLE h-object  AS HANDLE                  NO-UNDO.
DEFINE VARIABLE wh-objeto AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE c-mes5    AS CHARACTER FORMAT "x(5)" NO-UNDO.


/************************** In¡cio do Programa ***************************/
{utp/ut-liter.i "Agro" * R}
ASSIGN c-mes5 = RETURN-VALUE.

IF p-ind-event   = "BEFORE-INITIALIZE":U AND
   p-ind-object  = 'CONTAINER':U         THEN DO:

    /* Aumenta a window via UPC */
    ASSIGN current-window:WIDTH = 90.00                     
           p-wgh-frame:WIDTH    = 100.00.
END.

if p-ind-event   = "INITIALIZE":U   and 
   p-ind-object  = "CONTAINER":U    then do:

    RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                           INPUT "PAGE-SOURCE":U,
                                           OUTPUT c-folder).

    assign h-folder = widget-handle(c-folder) no-error.
    
    if valid-handle(h-folder) then do:

        assign  wh-objeto = p-wgh-frame:FIRST-CHILD
                wh-objeto = wh-objeto:FIRST-CHILD.

        DO WHILE VALID-HANDLE(wh-objeto):
            IF  wh-objeto:NAME = 'folder-frm':U THEN DO:
                ASSIGN wh-folder-frm = wh-objeto.
            end.
            ASSIGN  wh-objeto = wh-objeto:NEXT-SIBLING.
        end.

        IF VALID-HANDLE(wh-folder-frm) THEN
            ASSIGN wh-folder-frm:WIDTH = wh-folder-frm:WIDTH + 2.

        RUN create-folder-page  IN h-folder (INPUT 7, INPUT c-mes5).
        RUN create-folder-label IN h-folder (INPUT 7, INPUT c-mes5).

        RUN select-page IN p-wgh-object (INPUT 7). 
        
        RUN init-object IN p-wgh-object (INPUT "agro-upc/ggcd0401-v01.w":U, 
                                         INPUT p-wgh-frame,
                                         INPUT "Layout = ":U,
                                         OUTPUT h-viewer).

        RUN set-position IN h-viewer ( 7.10, 5.00).

        RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                               INPUT "CONTAINER-TARGET":U,
                                               OUTPUT c-objects).

        do i-objects = 1 to num-entries(c-objects):

            assign h-object = widget-handle(entry(i-objects, c-objects)). 

            if h-object:PRIVATE-DATA = "adqry/q05ad098.w":U THEN
                RUN add-link IN adm-broker-hdl (INPUT h-object,
                                                INPUT "Record":U,
                                                INPUT h-viewer).          
            
            if h-object:PRIVATE-DATA = "cdp/cd0704-v01.w":U THEN
                RUN add-link IN adm-broker-hdl (INPUT h-object, 
                                                INPUT "Group-Assign":U,
                                                INPUT h-viewer).          
        end.

        RUN dispatch    IN h-viewer     ("initialize":U).
        RUN select-page IN p-wgh-object (INPUT 1).
    end.
end.
/* fim */


