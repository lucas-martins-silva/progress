/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT0904CC 2.00.00.006 } /*** "010006" ***/


{cdp/cdcfgmat.i}
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
DEFINE NEW GLOBAL SHARED VAR v-wgh-object              AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR tx-cod-contrato-ft0904cc  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-cod-contrato-ft0904cc  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-descricao-ft0904cc     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR tx-cod-romaneio-ft0904cc  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-cod-romaneio-ft0904cc  AS WIDGET-HANDLE NO-UNDO.

/******************** Defini‡Æo de Vari veis Locais **********************/
DEFINE VARIABLE c-char     AS CHAR          NO-UNDO.
DEFINE VARIABLE wh-objeto  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-objects  AS CHAR          NO-UNDO.

/************************** In¡cio do Programa ***************************/
if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 

ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/") NO-ERROR.

v-wgh-object = p-wgh-object.

IF p-ind-event   = "BEFORE-INITIALIZE"  AND
   p-ind-object  = 'VIEWER'             AND
   c-char        = "v19di088.w"         THEN DO:
    
    ASSIGN p-wgh-frame:HEIGHT = 9.21.

    CREATE TEXT tx-cod-contrato-ft0904cc
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(17)"
           WIDTH        = 14
           HEIGHT       = 00.88
           SCREEN-VALUE = "N£m Contrato:"
           ROW          = 7.63
           COL          = 15.4
           VISIBLE      = YES.
 
    CREATE FILL-IN wh-cod-contrato-ft0904cc
    ASSIGN FRAME             = p-wgh-frame
           SIDE-LABEL-HANDLE = tx-cod-contrato-ft0904cc:HANDLE
           LABEL             = "N£m Contrato:"
           DATA-TYPE         = "character"
           FORMAT            = "x(20)"
           WIDTH             = 13.50
           HEIGHT            = .88
           ROW               = 7.63
           COL               = 25.5
           NAME              = "wh-cod-contrato-ft0904cc"
           SENSITIVE         = NO
           VISIBLE           = YES.

    CREATE FILL-IN wh-descricao-ft0904cc
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "character"
           FORMAT            = "x(24)"
           WIDTH             = 25
           HEIGHT            = .88
           ROW               = 7.63
           COL               = 39.5
           NAME              = "wh-descricao-ft0904cc"
           SENSITIVE         = NO
           VISIBLE           = YES.

    CREATE TEXT tx-cod-romaneio-ft0904cc
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(17)"
           WIDTH        = 14
           HEIGHT       = 00.88
           SCREEN-VALUE = "N£m Romaneio:"
           ROW          = 8.63
           COL          = 14.4
           VISIBLE      = YES.
 
    CREATE FILL-IN wh-cod-romaneio-ft0904cc
    ASSIGN FRAME             = p-wgh-frame
           SIDE-LABEL-HANDLE = tx-cod-romaneio-ft0904cc:HANDLE
           LABEL             = "N£m Romaneio:"
           DATA-TYPE         = "character"
           FORMAT            = "x(10)"
           WIDTH             = 10
           HEIGHT            = .88
           ROW               = 8.63
           COL               = 25.5
           NAME              = "wh-cod-romaneio-ft0904cc"
           SENSITIVE         = NO
           VISIBLE           = YES.
END. 

IF p-ind-event   = "DISPLAY"    AND
   p-ind-object  = 'VIEWER'     AND
   c-char        = "v19di088.w" THEN DO:

    FIND FIRST it-nota-fisc WHERE
        ROWID(it-nota-fisc) = p-row-table NO-LOCK NO-ERROR.

    IF AVAIL it-nota-fisc THEN DO:
        ASSIGN wh-cod-contrato-ft0904cc:SCREEN-VALUE = &IF '{&bf_mat_versao_ems}' >= "2.09" &THEN it-nota-fisc.cod-contrat-comerc
                                                       &ELSE SUBSTRING(it-nota-fisc.char-2,247,20) &ENDIF.
               wh-cod-romaneio-ft0904cc:SCREEN-VALUE = &IF '{&bf_mat_versao_ems}' >= "2.09" &THEN it-nota-fisc.num-romaneio-rel
                                                       &ELSE SUBSTRING(it-nota-fisc.char-2,232,9) &ENDIF.
                                                       
        FIND FIRST gg-contrato NO-LOCK
             WHERE gg-contrato.ep-codigo    = i-ep-codigo-usuario
               AND gg-contrato.cod-contrato = wh-cod-contrato-ft0904cc:SCREEN-VALUE NO-ERROR.
            
        IF AVAIL gg-contrato THEN
            ASSIGN wh-descricao-ft0904cc:SCREEN-VALUE = gg-contrato.des-contrato.
        ELSE
            ASSIGN wh-descricao-ft0904cc:SCREEN-VALUE = "".
    END.
END.
