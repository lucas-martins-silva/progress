/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGRE1001 2.00.00.005 } /*** 010005 ***/

/*************************************************************************
**    Programa.:  agre1001
**    Objetivo.:  
**    Data.....: Setembro/2003
*************************************************************************/
{utp/ut-glob.i}
/*********************** Defini‡Æo de Parametros *************************/
define input parameter p-ind-event               as character      no-undo.
define input parameter p-ind-object              as character      no-undo.
define input parameter p-wgh-object              as handle         no-undo.
define input parameter p-wgh-frame               as widget-handle  no-undo.
define input parameter p-cod-table               as character      no-undo.
define input parameter p-row-table               as rowid          no-undo.

/******************* Defini‡Æo de Variaveis Globais **********************/
DEFINE VAR  c-char                                AS CHAR          NO-UNDO.

DEF NEW GLOBAL SHARED VAR wgh-grupo               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-objeto2              AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR wgh-child            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-btItens-re1001    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-btclass-re1001    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR p-row-table2-re1001  AS ROWID NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-ggre1001-BrItem     AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-nat-operacao-re1001   AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-serie-docto-re1001    AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-emitente-re1001   AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nro-docto-re1001      AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-estab-re1001      AS CHAR . 

DEF NEW GLOBAL SHARED VAR wh-BtConf-re1001         AS WIDGET-HANDLE NO-UNDO.

/***************************************/
ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/") NO-ERROR.


/*MESSAGE "Evento ...:"   p-ind-event   SKIP
        "Objeto ...:"   p-ind-object  SKIP
        "HObjeto...:"   p-wgh-object  SKIP
        "hFrame ...:"   p-wgh-frame   SKIP
        "Tabela ...:"   p-cod-table   SKIP
        "Rowid  ...:"   string(p-row-table)   SKIP
        "NomeObjeto:"   c-char        VIEW-AS ALERT-BOX.*/

IF  p-ind-event  = "After-Display" THEN  DO:

    ASSIGN wh-objeto2 = p-wgh-frame:FIRST-CHILD.
    DO  WHILE VALID-HANDLE(wh-objeto2):
        IF  wh-objeto2:NAME = "BtConf" THEN
            ASSIGN wh-BtConf-re1001 = wh-objeto2.
       
        IF  wh-objeto2:NAME = "fpage1"  THEN DO:
            ASSIGN wgh-child  = wh-objeto2:FIRST-CHILD
                   wgh-child  = wgh-child:FIRST-CHILD.
            DO  WHILE VALID-HANDLE(wgh-child):
                IF wgh-child:NAME = "btItens" THEN
                   ASSIGN wh-btItens-re1001 = wgh-child.
                IF  wgh-child:NAME = "brSon1" THEN
                    ASSIGN  wh-ggre1001-britem  = wgh-child.
                ASSIGN wgh-child = wgh-child:NEXT-SIBLING.
            END.
        END.
        IF  wh-objeto2:NAME = "serie-docto" THEN       
            ASSIGN wh-serie-docto-re1001 = wh-objeto2. 
        IF  wh-objeto2:NAME = "nat-operacao" THEN      
            ASSIGN wh-nat-operacao-re1001 = wh-objeto2.
        IF  wh-objeto2:NAME = "cod-emitente" THEN      
            ASSIGN wh-cod-emitente-re1001 = wh-objeto2.
        IF  wh-objeto2:NAME = "nro-docto" THEN         
            ASSIGN wh-nro-docto-re1001 = wh-objeto2.

        IF  wh-objeto2:TYPE = "FIELD-GROUP" THEN
            ASSIGN wh-objeto2 = wh-objeto2:FIRST-CHILD.
        ELSE
            ASSIGN wh-objeto2 = wh-objeto2:NEXT-SIBLING.
    END.

    FIND FIRST docum-est NO-LOCK
        WHERE ROWID(docum-est) = p-row-table  NO-ERROR.
    IF  AVAIL docum-est THEN
        ASSIGN p-row-table2-re1001   = p-row-table
               wh-cod-estab-re1001 = docum-est.cod-estabel.
END.

IF  p-ind-event  = "After-Initialize" THEN  DO:

    create button wh-btclass-re1001
    assign frame     = wh-btItens-re1001:FRAME 
           row       = wh-btItens-re1001:ROW
           column    = wh-btItens-re1001:COLUMN + 10
           height    = 1
           width     = wh-btItens-re1001:width
           tooltip   = "Classifica‡Æo"
           help      = "Classifica‡Æo"
           label     = "Classifica‡Æo"
           sensitive = true
           visible   = TRUE
           FONT      = 1 .
    ON 'choose' of wh-btclass-re1001 persistent
       run agro-upc/ggre1001g.p.

    FIND FIRST docum-est NO-LOCK
        WHERE ROWID(docum-est) = p-row-table  NO-ERROR.
    IF  AVAIL docum-est THEN
        ASSIGN p-row-table2-re1001   = p-row-table
               wh-cod-estab-re1001 = docum-est.cod-estabel.
END.

