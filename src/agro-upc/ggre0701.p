/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGRE0701 2.00.00.007 } /*** 010007 ***/

/*************************************************************************
**    Programa.:  GGRE0701.p
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
DEFINE NEW GLOBAL SHARED VAR wh-bt-pessore0701   AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR p-row-table2        AS ROWID          NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_facelift          AS HANDLE         NO-UNDO.
/******************** Defini‡Æo de Vari veis Locais **********************/
DEFINE VAR  c-char                               AS CHAR          NO-UNDO.
define var cValSensi                             AS CHAR          NO-UNDO.
define var cValInsensi                           AS CHAR          NO-UNDO.

/************************** In¡cio do Programa ***************************/
ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/") NO-ERROR.

IF  NOT VALID-HANDLE(h_facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h_facelift.

IF  p-ind-event   = "BEFORE-INITIALIZE"  AND
    p-ind-object  = "CONTAINER"   THEN DO:
    create button wh-bt-pessore0701
    assign frame         = p-wgh-frame
           row           = 1.13
           column        = 56.14
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
     wh-bt-pessore0701:LOAD-IMAGE-UP(cValSensi)   NO-ERROR.
     wh-bt-pessore0701:LOAD-IMAGE-DOWN(cValSensi) NO-ERROR.
    &ELSE
     wh-bt-pessore0701:load-image("image/im-carg.bmp").
    &ENDIF
    
    ON 'choose' of wh-bt-pessore0701 persistent run agro-upc/ggre0701c.p.
END.

IF p-ind-object = 'VIEWER'        AND
   p-ind-event  = 'DISPLAY'       AND
   c-char       = "v26in090.w" THEN DO:
    ASSIGN  p-row-table2 = p-row-table. 
END.






