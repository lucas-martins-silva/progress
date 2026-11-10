/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGPD4000 2.00.00.009 } /*** "010009" 19/06/2024 15:24:45  ***/


/*************************************************************************
**    Programa.:  ggpd4000
**    Objetivo.:  Implanta‡Æo de Tipo de Frete
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
DEFINE VAR c-char                                 AS CHAR          NO-UNDO.
DEFINE VAR cValSensi                              AS CHAR          NO-UNDO.
DEFINE VAR cValInsensi                            AS CHAR          NO-UNDO.

DEF NEW GLOBAL SHARED VAR wgh-grupo               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-objeto               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-child               AS WIDGET-HANDLE NO-UNDO.
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
DEF NEW GLOBAL SHARED VAR h_facelift              AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-nr-pedcli-pd4000      AS CHAR FORMAT "x(15)".
DEF NEW GLOBAL SHARED VAR c-nome-abrev-pd4000     AS CHAR FORMAT "x(12)".

DEF BUFFER b-ped-venda FOR ped-venda.     
/*************************************/
ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/") NO-ERROR.


IF  NOT VALID-HANDLE(h_facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h_facelift.


IF  p-ind-event = "After-Display"  THEN DO:
    FIND b-ped-venda NO-LOCK
        WHERE ROWID(b-ped-venda) = p-row-table NO-ERROR.
	
	IF AVAIL b-ped-venda THEN
		ASSIGN c-nr-pedcli-pd4000  = b-ped-venda.nr-pedcli
			   c-nome-abrev-pd4000 = b-ped-venda.nome-abrev.
END.  


IF  VALID-HANDLE(wh-qt-pedida-pd4000) THEN DO: 
    ON "LEAVE"  OF wh-qt-pedida-pd4000 PERSISTENT RUN agro-upc/ggpd4000c.p.
END.


IF  VALID-HANDLE(wh-nr-tabpre-pd4000) THEN DO: 
    ON "LEAVE"  OF wh-nr-tabpre-pd4000 PERSISTENT RUN agro-upc/ggpd4000d.p.
END.

IF    p-ind-event = "afterDISPLAYItem" THEN  DO:
    ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD
           wh-objeto = wh-objeto:FIRST-CHILD.
    DO WHILE VALID-HANDLE(wh-objeto):
       IF  wh-objeto:NAME = "qt-pedida" THEN
           ASSIGN wh-qt-pedida-pd4000 = wh-objeto.
       IF  wh-objeto:NAME = "vl-preori" THEN DO:
           ASSIGN wh-vl-preori-pd4000 = wh-objeto.
           ASSIGN wh-vl-preori-pd4000:FORMAT = ">>>,>>>,>>9.9999999999".
       END.
       IF  wh-objeto:NAME = "it-codigo" THEN
           ASSIGN wh-it-codigo-pd4000 = wh-objeto.
       IF  wh-objeto:NAME = "nr-tabpre" THEN
           ASSIGN wh-nr-tabpre-pd4000 = wh-objeto.
              ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
    END.
END.


IF  p-ind-event  = "before_pi-enableitem" THEN  DO:
    ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD.
    DO  WHILE VALID-HANDLE(wh-objeto):
        IF  wh-objeto:NAME = "fpage6"  THEN DO:
            ASSIGN wgh-child  = wh-objeto:FIRST-CHILD
                   wgh-child  = wgh-child:FIRST-CHILD.
            DO  WHILE VALID-HANDLE(wgh-child):
                IF  wgh-child:NAME = "qt-pedida" THEN      
                    ASSIGN wh-qt-pedida-pd4000 = wgh-child.
                IF  wgh-child:NAME = "vl-preori" THEN DO:     
                    ASSIGN wh-vl-preori-pd4000 = wgh-child.
                    ASSIGN wh-vl-preori-pd4000:FORMAT = ">>>,>>>,>>9.9999999999".
                END.
                IF  wgh-child:NAME = "it-codigo" THEN      
                    ASSIGN wh-it-codigo-pd4000 = wgh-child.
                IF  wgh-child:NAME = "nr-tabpre" THEN      
                    ASSIGN wh-nr-tabpre-pd4000 = wgh-child.
                ASSIGN wgh-child = wgh-child:NEXT-SIBLING.
            END.
        END.
        IF  wh-objeto:TYPE = "FIELD-GROUP" THEN
            ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
        ELSE
            ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
    END.
END.


IF  p-ind-event  = "AfterInitializeInterface" AND
    p-ind-object = "Viewer"   THEN  DO:
    create button wh-bt-aux
    assign frame         = p-wgh-frame 
           row           = 1.09 
           column        = 60 
           tooltip       = "Contrato GrÆos"  
           help          = "Contrato GrÆos"
           label         = "Fr"
           flat-button   = YES
           no-focus      = YES
           height-pixels = 27
           width-pixels  = 28
           sensitive     = true
           visible       = true.
    
    &IF "{&product_version}" >= "12.1.X.2301" &THEN
     RUN pi_procura_caminho_image IN h_facelift (INPUT 'image/im-notah.bmp', OUTPUT cValSensi, OUTPUT cValInsensi).
     wh-bt-aux:LOAD-IMAGE-UP(cValSensi) NO-ERROR.
     wh-bt-aux:LOAD-IMAGE-DOWN(cValSensi) NO-ERROR.
    &ELSE
         wh-bt-aux:load-image("image~\im-dtcom.bmp").
    &ENDIF
    
    wh-bt-aux:MOVE-TO-TOP().
    ON 'choose' of wh-bt-aux persistent
        run agro-upc/ggpd4000a.w.
END. 
 
