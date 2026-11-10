/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGOF0311 2.00.00.001 } /*** 010001 ***/



/*************************************************************************
**    Programa.:  ggof0311
**    Objetivo.:  
**    Data.....:  Mar‡o/2010
*************************************************************************/
{utp/ut-glob.i}
{ggp/tt-erro.i}
/*********************** Defini‡Æo de Parƒmetros *************************/
DEFINE INPUT PARAMETER p-ind-event               AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object              AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object              AS HANDLE         NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame               AS WIDGET-HANDLE  NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table               AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-row-table               AS ROWID          NO-UNDO.

/******************** Defini‡Æo de Vari veis Globais *********************/

/******************** Defini‡Æo de Vari veis Locais **********************/
DEFINE VAR  c-char                               AS CHAR          NO-UNDO.

DEF VAR wgh-grupo               AS WIDGET-HANDLE NO-UNDO.
DEF VAR wgh-child               AS WIDGET-HANDLE NO-UNDO.
DEF VAR h-cgc                   AS HANDLE        NO-UNDO.
DEF BUFFER b-doc-fiscal         FOR doc-fiscal.
/************************** In¡cio do Programa ***************************/
ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/") NO-ERROR.

IF p-ind-object = 'VIEWER'     AND
   p-ind-event  = 'FORMAT'     AND
   c-char       = "v09di037.w" THEN DO:

    ASSIGN wgh-grupo = p-wgh-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(wgh-grupo):
        ASSIGN wgh-child = wgh-grupo:FIRST-CHILD.
        DO  WHILE VALID-HANDLE(wgh-child):
            CASE wgh-child:TYPE:
                WHEN "FILL-IN" THEN do:
                    IF wgh-child:NAME = "cgc" THEN DO:
                        ASSIGN h-cgc = wgh-child:HANDLE.
                        LEAVE.
                    END.
                END.
            END.
            ASSIGN wgh-child = wgh-child:NEXT-SIBLING NO-ERROR.
        END.
        LEAVE.
    END.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR FIRST b-doc-fiscal
        WHERE ROWID(b-doc-fiscal) = p-row-table NO-LOCK:

        IF LENGTH (b-doc-fiscal.cgc) = 11 THEN
            ASSIGN h-cgc:FORMAT = param-global.formato-id-pessoal.
        ELSE IF LENGTH (b-doc-fiscal.cgc) = 14 THEN
            ASSIGN h-cgc:FORMAT = param-global.formato-id-federal.
    END.
END.
