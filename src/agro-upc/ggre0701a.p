/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGRE0701A 2.00.00.006 } /*** 010006 ***/


/*************************************************************************
**    Programa.:  GGRE0701a.p
**    Objetivo.:  Solicitar n£mero do contrato 
**    Data.....:  Setenbro/2003
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
DEFINE NEW GLOBAL SHARED VAR v-wgh-object        AS HANDLE         NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h-viewer            AS HANDLE         NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-cod-contrato     AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-descricao        AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-cod-inid-negoc   AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  adm-broker-hdl     AS HANDLE         NO-UNDO.
/******************** Defini‡Æo de Vari veis Locais **********************/
DEFINE VAR  c-char                               AS CHAR          NO-UNDO.
DEFINE VAR  wh-objeto                            AS WIDGET-HANDLE NO-UNDO.
Define Var  c-objects                            as Char          no-undo.

DEF VAR h-browser     AS HANDLE        NO-UNDO.
DEF VAR h-column      AS HANDLE        NO-UNDO.
DEF VAR h-column-2    AS HANDLE        NO-UNDO.

{btb/btb009za.i} /* Define tt_erro */
/************************** In¡cio do Programa ***************************/
ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/") NO-ERROR.

v-wgh-object = p-wgh-object.


/*MESSAGE "Evento ...:"   p-ind-event   SKIP
        "Objeto ...:"   p-ind-object  SKIP
        "HObjeto...:"   p-wgh-object  SKIP
        "hFrame ...:"   p-wgh-frame   SKIP
        "Tabela ...:"   p-cod-table   SKIP
        "Rowid  ...:"   string(p-row-table)   SKIP
        "NomeObjeto:"   c-char        VIEW-AS ALERT-BOX.*/


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
    c-char        = 'b10in090.w'         THEN DO:

    ASSIGN h-browser = getObject(p-wgh-frame,"br_table").
    
    ASSIGN h-column             = h-browser:ADD-CALC-COLUMN('char',"x(21)",'','Contrato',10)
           h-column:READ-ONLY   = TRUE
           h-column-2           = h-browser:ADD-CALC-COLUMN('char',"x(11)",'','Romaneio',11)
           h-column-2:READ-ONLY = TRUE.
        
    ON 'ROW-DISPLAY' OF h-browser PERSISTENT 
        RUN agro-upc/ggre0701aa.p (INPUT h-browser:QUERY,
                                   INPUT h-column,
                                   INPUT h-column-2).
END.

