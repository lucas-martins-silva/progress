/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCD0601 2.00.00.010 } /*** "010010" ***/

/*************************************************************************
**    Programa.:  GGCD0601
**    Objetivo.:  UPC para Solicitar Log-FOB-Direto - CD0601
**    Data.....:  Agosto de 2003
*************************************************************************/

/*********************** Defini‡Æo de Parƒmetros *************************/
define input parameter p-ind-event               as character      no-undo.
define input parameter p-ind-object              as character      no-undo.
define input parameter p-wgh-object              as handle         no-undo.
define input parameter p-wgh-frame               as widget-handle  no-undo.
define input parameter p-cod-table               as character      no-undo.
define input parameter p-row-table               as rowid          no-undo.

/******************** Defini‡Æo de Vari veis Globais *********************/
define new global shared var  wh-depos-orig-cd0601 as widget-handle no-undo.
define new global shared var  wh-cod-depos         as widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VAR  h-upc-cd0601         AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  gr-gg-ext-deposito   AS ROWID         NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  h_facelift           AS HANDLE        NO-UNDO.

/******************** Defini‡Æo de Vari veis Locais **********************/
define variable cValSensi      AS CHARACTER     NO-UNDO.
define variable cValInsensi    AS CHARACTER     NO-UNDO.
define variable  c-char        AS CHAR          NO-UNDO.
define variable  wh-objeto     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE  h_Frame       AS HANDLE        NO-UNDO.
/************************** In¡cio do Programa ***************************/
assign c-char = entry(num-entries(p-wgh-object:file-name,"~/":U), p-wgh-object:file-name,"~/":U) no-error.

IF  NOT VALID-HANDLE(h_facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h_facelift.


IF p-ind-event = "BEFORE-INITIALIZE" 
    AND p-ind-object = "CONTAINER"   THEN DO:

    RUN agro-upc/ggcd0601.p PERSISTENT SET h-upc-cd0601(INPUT "",
                                               INPUT "",
                                               INPUT p-wgh-object,
                                               INPUT p-wgh-frame,
                                               INPUT "",
                                               INPUT p-row-table).

    {utp/ut-liter.i "Origina‡Æo" * R}    
    create button wh-depos-orig-cd0601
    assign frame         = p-wgh-frame 
           row           = 1.35 
           column        = 56
           tooltip       = return-value  
           help          = return-value
           label         = return-value
           flat-button   = YES
           no-focus      = YES
           height-pixels = 27
           width-pixels  = 28
           visible       = TRUE
           sensitive     = TRUE
           TRIGGERS:
             ON CHOOSE PERSISTENT RUN pi-validate IN h-upc-cd0601.
           END TRIGGERS. 
    
    &IF "{&product_version}" >= "12.1.X.2301" &THEN
     RUN pi_procura_caminho_image IN h_facelift (INPUT 'image/toolbar/im-exp.bmp', OUTPUT cValSensi, OUTPUT cValInsensi).
     wh-depos-orig-cd0601:LOAD-IMAGE-UP(cValSensi) NO-ERROR.
     wh-depos-orig-cd0601:LOAD-IMAGE-DOWN(cValSensi) NO-ERROR.
    &ELSE
     wh-depos-orig-cd0601:load-image("image~\toolbar~\im-exp.bmp":U).
    &ENDIF
end.  

IF VALID-HANDLE(wh-depos-orig-cd0601) AND wh-depos-orig-cd0601:SENSITIVE = NO THEN
    ASSIGN wh-depos-orig-cd0601:SENSITIVE = YES.

if p-ind-event  = "display":U     and 
   p-ind-object = "viewer":U     then do:  

    ASSIGN h_Frame = p-wgh-frame:FIRST-CHILD.  
    ASSIGN h_Frame = h_Frame:FIRST-CHILD.     
    DO WHILE h_Frame <> ? :
        if h_frame:type <> "field-group" then do:
           IF h_frame:NAME = "cod-depos" THEN DO:                                                          
                ASSIGN wh-cod-depos = h_Frame.
                LEAVE.
           END.
           ASSIGN h_Frame = h_Frame:NEXT-SIBLING.
        END.                                     
    END.
END.

if p-ind-event  = "assign":U     and 
   p-ind-object = "viewer":U     and
   c-char       = "v01in084.w":U then do:

   FIND FIRST deposito NO-LOCK 
       WHERE deposito.cod-depos = wh-cod-depos:SCREEN-VALUE NO-ERROR.
   IF AVAIL deposito THEN  DO:
       FIND FIRST gg-ext-deposito EXCLUSIVE-LOCK
           WHERE gg-ext-deposito.cod-depos = deposito.cod-depos NO-ERROR.
       IF NOT AVAIL gg-ext-deposito then do:
           CREATE gg-ext-deposito.
           ASSIGN gg-ext-deposito.cod-depos = deposito.cod-depos.
       END. 
   END.
END.

IF p-ind-event = "DESTROY" THEN DO:
    IF VALID-HANDLE(h-upc-cd0601) THEN DO:
        DELETE PROCEDURE h-upc-cd0601.
        ASSIGN h-upc-cd0601 = ?.
    END.
END.            

RETURN "OK":U.

PROCEDURE pi-validate:
    FIND FIRST deposito NO-LOCK 
        WHERE  deposito.cod-depos = wh-cod-depos:SCREEN-VALUE NO-ERROR.
    
    IF  AVAIL deposito THEN  DO:
        IF  VALID-HANDLE(wh-depos-orig-cd0601) THEN DO:

            FIND FIRST gg-ext-deposito NO-LOCK
                WHERE  gg-ext-deposito.cod-depos = deposito.cod-depos NO-ERROR.

            ASSIGN gr-gg-ext-deposito = IF AVAIL gg-ext-deposito THEN ROWID(gg-ext-deposito) ELSE ?.

            RUN ggp/gg1037.w.
        END.
    END.                                      
END PROCEDURE.
