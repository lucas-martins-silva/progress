/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT4003 2.00.00.006 } /*** 010006 ***/


/*************************************************************************
**    Programa.:  GGFT4003
**    Objetivo.:  UPC para Pegar a sequencia
**    Data.....:  Agosto/2003
*************************************************************************/
{ggp/tt-erro.i}
/*********************** Defini‡Æo de Parƒmetros *************************/
define input parameter p-ind-event               as character      no-undo.
define input parameter p-ind-object              as character      no-undo.
define input parameter p-wgh-object              as handle         no-undo.
define input parameter p-wgh-frame               as widget-handle  no-undo.
define input parameter p-cod-table               as character      no-undo.
define input parameter p-row-table               as rowid          no-undo.

/******************** Defini‡Æo de Vari veis Globais *********************/
DEF NEW GLOBAL SHARED VAR seq-wt-docto-ft4003  LIKE wt-docto.seq-wt-docto NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btclass-ft4003      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btcalcula2-ft4003   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-child              AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btaddson1           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btupdateson1        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btdeleteson1        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btcalcula           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_facelift             AS HANDLE        NO-UNDO.

DEF NEW GLOBAL SHARED VAR p-row-table2           AS ROWID NO-UNDO.

                                              
/******************** Defini‡Æo de Vari veis Locais **********************/
DEFINE VAR c-char                                AS CHAR           NO-UNDO.
DEFINE VAR wh-objeto                             AS WIDGET-HANDLE  NO-UNDO.
DEFINE VAR wgh-child                             AS WIDGET-HANDLE  NO-UNDO.
DEFINE VAR c-folder                              AS CHAR           NO-UNDO.
DEFINE VAR cValSensi                             AS CHARACTER      NO-UNDO.
DEFINE VAR cValInsensi                           AS CHARACTER      NO-UNDO.
/************************** In¡cio do Programa ***************************/

if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 
assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/") NO-ERROR.
       
IF  NOT VALID-HANDLE(h_facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h_facelift.
  
IF  p-ind-event = "after-initialize" THEN DO:

    ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD.
    DO  WHILE VALID-HANDLE(wh-objeto):
        IF  wh-objeto:NAME = "btCalcula" THEN 
            ASSIGN wh-btcalcula = wh-objeto.
        
        IF  wh-objeto:NAME = "fpage1"  THEN DO:
            ASSIGN wgh-child  = wh-objeto:FIRST-CHILD
                   wgh-child  = wgh-child:FIRST-CHILD.
            DO  WHILE VALID-HANDLE(wgh-child):
                IF wgh-child:NAME = "btaddson1" THEN
                   ASSIGN wh-btaddson1 = wgh-child.
                IF wgh-child:NAME = "btupdateson1" THEN
                   ASSIGN wh-btupdateson1 = wgh-child.
                IF wgh-child:NAME = "btdeleteson1" THEN
                   ASSIGN wh-btdeleteson1 = wgh-child.
                ASSIGN wgh-child = wgh-child:NEXT-SIBLING.
            END.
        END.
        
        IF  wh-objeto:TYPE = "FIELD-GROUP" THEN
            ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
        ELSE
            ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
    END.
    
    create button wh-btclass-ft4003
    assign frame     = wh-btaddson1:FRAME 
           row       = 9.38
           column    = 25.86
           height    = 1
           width     = 08
           tooltip   = "Classifica‡Æo"  
           help      = "Classifica‡Æo"
           label     = "Classif"
           sensitive = true
           visible   = TRUE 
           FONT      = 1 .

    
    ON 'choose' of wh-btclass-ft4003 persistent
       run agro-upc/ggft4003e.p.

    ASSIGN wh-btaddson1:WIDTH     = 08
           wh-btupdateson1:WIDTH  = 08
           wh-btupdateson1:COLUMN = 09.86   
           wh-btdeleteson1:WIDTH  = 08.
           wh-btdeleteson1:COLUMN = 17.86.

    IF  VALID-HANDLE(wh-btcalcula) THEN DO:
        create button wh-btcalcula2-ft4003
        assign frame       = wh-btcalcula:FRAME 
               row         = wh-btcalcula:row    
               column      = wh-btcalcula:column 
               height      = wh-btcalcula:height
               width       = wh-btcalcula:width 
               tooltip     = wh-btcalcula:tooltip 
               help        = wh-btcalcula:help   
               label       = wh-btcalcula:label
               sensitive   = wh-btcalcula:sensitive
               flat-button = wh-btcalcula:flat-button
               no-focus    = wh-btcalcula:no-focus
               visible     = TRUE   
               FONT        = wh-btcalcula:FONT .

        &IF "{&product_version}" >= "12.1.X.2301" &THEN
         RUN pi_procura_caminho_image IN h_facelift (INPUT 'image/im-calc4.bmp', OUTPUT cValSensi, OUTPUT cValInsensi).
         wh-btcalcula2-ft4003:LOAD-IMAGE-UP(cValSensi) NO-ERROR.
         wh-btcalcula2-ft4003:LOAD-IMAGE-DOWN(cValSensi) NO-ERROR.
        &ELSE
         wh-btcalcula2-ft4003:load-image("image~\im-calc4.bmp").
        &ENDIF
        wh-btcalcula2-ft4003:LOAD-IMAGE-INSENSITIVE(wh-btcalcula:IMAGE-INSENSITIVE).
        wh-btcalcula2-ft4003:MOVE-TO-TOP().                       

        ON 'choose' of wh-btcalcula2-ft4003 persistent
            RUN  agro-upc/ggft40031.p .
    END.
END.


IF  p-ind-event = "after-display" THEN DO:
    FIND FIRST wt-docto NO-LOCK
        WHERE ROWID(wt-docto) = p-row-table NO-ERROR.
    IF  AVAIL wt-docto THEN DO:

        ASSIGN  seq-wt-docto-ft4003 = wt-docto.seq-wt-docto.
                p-row-table2 = p-row-table.
    END.
    ELSE 
       ASSIGN p-row-table2 = ? .

     
END.
