/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT0904 2.00.00.007 } /*** 010007 ***/



/*************************************************************************
**    Programa.:  GGRE0904.p
**    Objetivo.:  Solicitar BotÆo Consulta de Pesagem~\Classifica‡Æo
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
DEFINE NEW GLOBAL SHARED VAR wh-bt-pessoft0904   AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR p-row-table2-ft0904 AS ROWID          NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_facelift          AS HANDLE        NO-UNDO.

/******************** Defini‡Æo de Vari veis Locais **********************/
DEFINE VAR  c-char        AS CHAR           NO-UNDO.
DEFINE VAR  wh-objeto     AS WIDGET-HANDLE  NO-UNDO.
DEFINE VAR  c-objects     AS Char           NO-UNDO.
DEFINE VAR  wgh-grupo     AS WIDGET-HANDLE  NO-UNDO.
DEFINE VAR  wgh-child     AS WIDGET-HANDLE  NO-UNDO.
DEFINE VAR  h-cgc         AS HANDLE         NO-UNDO.
DEFINE VAR cValSensi      AS CHARACTER      NO-UNDO.
DEFINE VAR cValInsensi    AS CHARACTER      NO-UNDO.

DEF BUFFER b-nota-fiscal        FOR nota-fiscal.
/************************** In¡cio do Programa ***************************/

if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 

ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/") NO-ERROR.

v-wgh-object = p-wgh-object.

IF  NOT VALID-HANDLE(h_facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h_facelift.

IF  p-ind-event   = "INITIALIZE"  AND
    p-ind-object  = "CONTAINER"   THEN DO:
 
    create button wh-bt-pessoft0904                     
    assign frame         = p-wgh-frame              
           row           = 1.15                     
           column        = 61.5                                         
           tooltip       = "Pesagem"                
           help          = "Pesagem"                
           label         = "Pesagem"                    
           flat-button   = YES
           no-focus      = YES
           height-pixels = 27
           width-pixels  = 28
           visible       = TRUE
           sensitive     = TRUE.                                     
    
    &IF "{&product_version}" >= "12.1.X.2301" &THEN
     RUN pi_procura_caminho_image IN h_facelift (INPUT 'image/im-carg.bmp', OUTPUT cValSensi, OUTPUT cValInsensi).
     wh-bt-pessoft0904:LOAD-IMAGE-UP(cValSensi) NO-ERROR.
     wh-bt-pessoft0904:LOAD-IMAGE-DOWN(cValSensi) NO-ERROR.
    &ELSE
     wh-bt-pessoft0904:load-image("image/im-carg.bmp").
    &ENDIF
    wh-bt-pessoft0904:MOVE-TO-TOP().
    ON 'choose' of wh-bt-pessoft0904 PERSISTENT
        run agro-upc/ggft0904c.p.

END.
    

IF  p-ind-event   = "BEFORE-INITIALIZE"  AND
    p-ind-object  = 'VIEWER'             AND
    c-char        = "v26in090.w"         THEN DO:
    
END. 

IF p-ind-object = 'VIEWER'        AND
   p-ind-event  = 'DISPLAY'       AND
   c-char       = "v02di135.w" THEN DO:
   
   ASSIGN p-row-table2-ft0904 = p-row-table. 

END.

IF p-ind-object = 'VIEWER'     AND
   p-ind-event  = 'FORMAT'     AND
   c-char       = "v06di135.w" THEN DO:

    ASSIGN wgh-grupo = p-wgh-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(wgh-grupo):
        ASSIGN wgh-child = wgh-grupo:FIRST-CHILD.
        DO  WHILE VALID-HANDLE(wgh-child):
            CASE wgh-child:TYPE:
                WHEN "FILL-IN" THEN do:
                    IF wgh-child:NAME = "c-cgc" THEN DO:
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

    FOR FIRST b-nota-fiscal
        WHERE ROWID(b-nota-fiscal) = p-row-table NO-LOCK:

        IF LENGTH (b-nota-fiscal.cgc) = 11 THEN
            ASSIGN h-cgc:FORMAT = param-global.formato-id-pessoal.
        ELSE IF LENGTH (b-nota-fiscal.cgc) = 14 THEN
            ASSIGN h-cgc:FORMAT = param-global.formato-id-federal.
    END.
END.
