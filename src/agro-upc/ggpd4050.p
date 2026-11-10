/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGPD4050 2.00.00.007 } /*** "010007" 19/06/2024 15:24:46  ***/


/*************************************************************************
**    Programa.:  ggpd4050
**    Objetivo.:  Implantaá∆o de Pedidos de Venda
*************************************************************************/
{utp/ut-glob.i}
/*********************** Definiá∆o de Parametros *************************/
define input parameter p-ind-event               as character      no-undo.
define input parameter p-ind-object              as character      no-undo.
define input parameter p-wgh-object              as handle         no-undo.
define input parameter p-wgh-frame               as widget-handle  no-undo.
define input parameter p-cod-table               as character      no-undo.
define input parameter p-row-table               as rowid          no-undo.

/******************* Definiá∆o de Variaveis Globais **********************/
DEFINE VAR  c-char                                AS CHAR          NO-UNDO.

DEF NEW GLOBAL SHARED VAR wgh-grupo               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-objeto               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wgh-child            AS WIDGET-HANDLE NO-UNDO.
DEF NEW global SHARED VAR wh-FRAME                AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-devolve           AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-devolve2          AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-bt-aux               AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-aux2              AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-aux3              AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-qt-pedida-pd4000     AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-vl-preori-pd4000     AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-it-codigo-pd4000     AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-tabpre-pd4000     AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-vl-preori-pd4000     AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-btclass-re1001    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-ggpd4050-BrItem   AS WIDGET-HANDLE NO-UNDO.


DEF NEW GLOBAL SHARED VAR c-nr-pedcli-pd4000      AS CHAR FORMAT "x(15)".
DEF NEW GLOBAL SHARED VAR c-nome-abrev-pd4000     AS CHAR FORMAT "x(12)".

DEF BUFFER b-ped-venda FOR ped-venda.     
/*************************************/
ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/") NO-ERROR.


IF  p-ind-event = "After-Display"  THEN DO:
    FIND b-ped-venda NO-LOCK
        WHERE ROWID(b-ped-venda) = p-row-table NO-ERROR.
    IF AVAIL b-ped-venda THEN
        ASSIGN c-nr-pedcli-pd4000  = b-ped-venda.nr-pedcli
               c-nome-abrev-pd4000 = b-ped-venda.nome-abrev.
END.  


IF  p-ind-event  = "After-Initialize"  THEN  DO:
    
    create button wh-bt-aux
    assign frame     = p-wgh-frame 
           row       = 3.10 
           column    = 83.29 
           height    = 1.3
           width     = 4.0
           tooltip   = "Contrato Gr∆os"  
           help      = "Contrato Gr∆os"
           label     = "Fr"
           sensitive = true
           visible   = true.

    wh-bt-aux:load-image("image~\im-dtcom.bmp").
    wh-bt-aux:MOVE-TO-TOP().
    ON 'choose' of wh-bt-aux persistent
        run agro-upc/ggpd4000a.w.
END. 
 
  
