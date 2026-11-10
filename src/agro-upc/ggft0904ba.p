/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT0904BA 2.00.00.002 } /*** 010002 ***/


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
DEFINE NEW GLOBAL SHARED VAR v-wgh-object        AS HANDLE         NO-UNDO.

/******************** Defini‡Æo de Vari veis Locais **********************/
DEFINE VARIABLE c-char        AS CHAR          NO-UNDO.
DEFINE VARIABLE wh-objeto     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-objects     AS CHAR          NO-UNDO.
DEFINE VARIABLE h-browser     AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-column      AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-column2     AS HANDLE        NO-UNDO.
/************************** In¡cio do Programa ***************************/
if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 

ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/") NO-ERROR.

v-wgh-object = p-wgh-object.

FUNCTION getObject RETURNS HANDLE (pFrame AS HANDLE, pObj AS CHAR).

    DEF VAR hHdl AS HANDLE NO-UNDO.

    ASSIGN hHdl = pFrame:FIRST-CHILD
           hHdl = hHdl:FIRST-CHILD.

    DO WHILE VALID-HANDLE(hHdl):

        IF hHdl:NAME = pObj THEN LEAVE.

        hHdl = hHdl:NEXT-SIBLING.
    END.

    RETURN IF VALID-HANDLE(hHdl) THEN hHdl ELSE ?.

END FUNCTION.

IF  p-ind-event   = "BEFORE-INITIALIZE"  AND
    p-ind-object  = 'BROWSER'            AND
    c-char        = "b04di088.w"         THEN DO:

    ASSIGN h-browser = getObject(p-wgh-frame,"br-table").

    ASSIGN h-column             = h-browser:ADD-CALC-COLUMN('char',"x(21)",'','Contrato',10)
           h-column:READ-ONLY   = TRUE
           h-column2            = h-browser:ADD-CALC-COLUMN('char',"x(10)",'','N£m Romaneio',11)
           h-column2:READ-ONLY  = TRUE.

    ON 'ROW-DISPLAY' OF h-browser PERSISTENT 
        RUN agro-upc/ggft0904bb.p (INPUT h-browser:QUERY,
                                   INPUT h-column,
                                   INPUT h-column2).
END.
