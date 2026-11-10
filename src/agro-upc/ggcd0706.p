/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCD0706 2.00.00.004 } /*** 010004 ***/

/*************************************************************************
**    Programa.:  ggcd0706
**    Objetivo.:  Zoom espec¡fico de Contratos
**    Data.....: novembro/2005
*************************************************************************/
{utp/ut-glob.i}
/*********************** Defini‡Æo de Parametros *************************/
define input parameter p-ind-event               as character      no-undo.
define input parameter p-ind-object              as character      no-undo.
define input parameter p-wgh-object              as handle         no-undo.
define input parameter p-wgh-frame               as widget-handle  no-undo.
define input parameter p-cod-table               as character      no-undo.
define input parameter p-row-table               as rowid          no-undo.


/******************* Defini»’o de Variaveis Globais **********************/
DEF NEW GLOBAL SHARED VAR wgh-grupo        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-objeto        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-child        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-frame         AS HANDLE        NO-UNDO.

DEF                   VAR c-char               AS CHAR          NO-UNDO.
DEF NEW GLOBAL SHARED VAR bt-roteiro-cd0706    AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-query-new-cd0706 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_facelift           AS HANDLE        NO-UNDO.


/* Global Variable Definitions **********************************************/

define new global shared var adm-broker-hdl as handle no-undo.

define var c-folder       as character no-undo.
define var h-folder       as handle    no-undo.
define var c-objects      as character no-undo.
define var h-object       as handle    no-undo.
define var i-objects      as integer   no-undo.
define var cValSensi      as character no-undo.
define var cValInsensi    as character no-undo.

/**** Alteracao efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/

IF  NOT VALID-HANDLE(h_facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h_facelift.


ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/":U), p-wgh-object:FILE-NAME,"~/":U) NO-ERROR.
ASSIGN wgh-grupo = p-wgh-frame:FIRST-CHILD.

if p-ind-event = "INITIALIZE":U and p-ind-object = "CONTAINER":U then do:
    
    RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                           INPUT "PAGE-SOURCE":U,
                                           OUTPUT c-folder).

    RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                           INPUT "CONTAINER-TARGET":U,
                                           OUTPUT c-objects).

    do i-objects = 1 to num-entries(c-objects):

       assign h-object = widget-handle(entry(i-objects, c-objects)).

       if index(h-object:private-data, "diqry/q01di181.w":U) <> 0 then do: /* Vocˆ deve verificar se e a query principal */ 

           ASSIGN wgh-query-new-cd0706 = h-object.

       end.
    end.
END.

IF  p-ind-event  = "BEFORE-INITIALIZE":U AND
    p-ind-object = "CONTAINER":U         THEN  DO:
    create button bt-roteiro-cd0706
    assign frame         = p-wgh-frame 
           row           = 1.35 
           column        = 63.10 
           tooltip       = "Pesquisa Contratos"
           help          = "Pesquisa Contratos"
           flat-button   = YES
           no-focus      = YES
           height-pixels = 27
           width-pixels  = 28
           visible       = TRUE
           sensitive     = TRUE.

    &IF "{&product_version}" >= "12.1.X.2301" &THEN
     RUN pi_procura_caminho_image IN h_facelift (INPUT 'image/im-edl.bmp', OUTPUT cValSensi, OUTPUT cValInsensi).
     bt-roteiro-cd0706:LOAD-IMAGE-UP(cValSensi) NO-ERROR.
     bt-roteiro-cd0706:LOAD-IMAGE-DOWN(cValSensi) NO-ERROR.
    &ELSE
     bt-roteiro-cd0706:load-image("image~\im-edl.bmp":U).
    &ENDIF
    
    bt-roteiro-cd0706:MOVE-TO-TOP().

    
    ON 'choose':U of bt-roteiro-cd0706 persistent
        run agro-upc/gg0706-z01.w.             

END.
