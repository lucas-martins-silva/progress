/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCD0401 2.00.00.014 } /*** "010014" 29/05/2025 09:23:33  ***/

/*************************************************************************
**    Programa.:  GGCD0401
**    Objetivo.:  UPC para cadastro de informaá‰es adicionais do emitente - CD0401
**    Data.....:  Julho de 2003
*************************************************************************/
{utp/ut-glob.i}

/*********************** Definiá∆o de ParÉmetros *************************/
define input parameter p-ind-event               as character      no-undo.
define input parameter p-ind-object              as character      no-undo.
define input parameter p-wgh-object              as handle         no-undo.
define input parameter p-wgh-frame               as widget-handle  no-undo.
define input parameter p-cod-table               as character      no-undo.
define input parameter p-row-table               as rowid          no-undo.


/******************** Definiá∆o de Vari†veis Globais *********************/
Define New Global Shared Var  adm-broker-hdl     as handle         no-undo.
Define New Global Shared Var  h-viewer           as handle         no-undo.
Define New Global Shared Var  h-browser          as handle         no-undo.


DEFINE NEW GLOBAL SHARED VAR  wgh-grupo              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  c-emitente-gg1002      LIKE emitente.cod-emitente.
DEFINE NEW GLOBAL SHARED VAR  i-cod-grupo-cd0401     LIKE gg-grupo-tax.cod-grupo.
DEFINE NEW GLOBAL SHARED VAR  wh-Inscricao-cd0401    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-lim-credito-cd0401  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-fatura-cd0401       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-tg-logistica-cd0401 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-lbl-grup-imposto    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-grup-imposto        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-desc-grup-imposto   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-flgg-pag            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-lb-cod-grupo        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-cod-grupo           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-desc-grupo          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-ins-estadual        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-inscr-inss          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-inscr-inss2         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-folder-frm          AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  i-cod-grupo            AS INTEGER       NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR  r-emit                 AS ROWID         NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  gr-emitente-gg1002     AS ROWID         NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  gr-emitente-gg1076     AS ROWID         NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  h_facelift             AS HANDLE        NO-UNDO.


DEFINE VARIABLE cValSensi                         AS CHARACTER     NO-UNDO.
DEFINE VARIABLE cValInsensi                       AS CHARACTER     NO-UNDO.
DEFINE VARIABLE c-folder                          AS CHARACTER     NO-UNDO.
DEFINE VARIABLE h-folder                          AS HANDLE        NO-UNDO.
DEFINE VARIABLE c-objects                         AS CHARACTER     NO-UNDO.
DEFINE VARIABLE i-objects                         AS INTEGER       NO-UNDO.
DEFINE VARIABLE h-object                          AS HANDLE        NO-UNDO.
DEFINE VARIABLE c-char                            AS CHARACTER     NO-UNDO.
DEFINE VARIABLE wh-objeto                         AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wh-aux                            AS WIDGET        NO-UNDO.
DEF VAR c-do AS INT.
DEF VAR c-resp AS LOG.
DEF VAR i-cont AS INT.


DEFINE VARIABLE c-agro AS CHARACTER FORMAT "x(5)"  NO-UNDO.

{utp/ut-liter.i "Agro" * R}
ASSIGN c-agro = RETURN-VALUE.


/************************** In°cio do Programa ***************************/
assign c-char = entry(num-entries(p-wgh-object:file-name,"~/":U), p-wgh-object:file-name,"~/":U) no-error.

{utp/ut-glob.i}

IF  NOT VALID-HANDLE(h_facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h_facelift.

if  p-ind-event   = "display":U       AND
    p-ind-object  = "VIEWER":U        AND
    c-char        = "cd0401-v05.w":U  then do:

    FIND FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = c-emitente-gg1002 NO-ERROR.
    IF  AVAIL emitente THEN DO:
        IF VALID-HANDLE(wh-inscr-inss) THEN
            ASSIGN wh-inscr-inss:SCREEN-VALUE = SUBSTRING(emitente.char-2,4,20).
    END.
 
END.

IF p-ind-event   = "BEFORE-INITIALIZE":U AND
   p-ind-object  = 'CONTAINER':U         THEN DO:

   /* Aumenta a window via UPC */
   ASSIGN current-window:WIDTH = 90.00                     
          p-wgh-frame:WIDTH    = 100.00.
END.



if  p-ind-event   = "INITIALIZE":U   and 
    p-ind-object  = "CONTAINER":U    then do:

    {utp/ut-liter.i "Manutená∆o Dados Produtor" * R}
    create button wh-Inscricao-cd0401
    assign frame         = p-wgh-frame 
           row           = 1.35 
           column        = 65.9
           tooltip       = return-value  
           help          = return-value
           label         = return-value
           flat-button   = YES
           no-focus      = YES
           height-pixels = 27
           width-pixels  = 28
           visible       = TRUE
           sensitive     = TRUE.
    
    &IF "{&product_version}" >= "12.1.X.2301" &THEN
     RUN pi_procura_caminho_image IN h_facelift (INPUT 'image/im-pedido.bmp', OUTPUT cValSensi, OUTPUT cValInsensi).
     wh-Inscricao-cd0401:LOAD-IMAGE-UP(cValSensi) NO-ERROR.
     wh-Inscricao-cd0401:LOAD-IMAGE-DOWN(cValSensi) NO-ERROR.
    &ELSE
     wh-Inscricao-cd0401:load-image("image~\im-pedido.bmp":U).
    &ENDIF
    
    wh-Inscricao-cd0401:MOVE-TO-TOP().
    ON 'choose':U of wh-Inscricao-cd0401 persistent
        run ggp/gg1009.w.

    {utp/ut-liter.i "Limite CrÇdito" * R}
    create button wh-lim-credito-cd0401
    assign frame         = p-wgh-frame 
           row           = 1.35 
           column        = 61.8
           tooltip       = return-value  
           help          = return-value
           label         = return-value
           flat-button   = YES
           no-focus      = YES
           height-pixels = 27
           width-pixels  = 28
           visible       = TRUE
           sensitive     = TRUE.
    
    &IF "{&product_version}" >= "12.1.X.2301" &THEN
     RUN pi_procura_caminho_image IN h_facelift (INPUT 'image/im-pcust.bmp', OUTPUT cValSensi, OUTPUT cValInsensi).
     wh-lim-credito-cd0401:LOAD-IMAGE-UP(cValSensi) NO-ERROR.
     wh-lim-credito-cd0401:LOAD-IMAGE-DOWN(cValSensi) NO-ERROR.
    &ELSE
     wh-lim-credito-cd0401:load-image("image~\im-pcust.bmp":U).
    &ENDIF
    
    wh-lim-credito-cd0401:MOVE-TO-TOP().
    ON 'choose':U of wh-lim-credito-cd0401 persistent
        run ggp/gg1076.w.
    
    RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                           INPUT "PAGE-SOURCE":U,
                                           OUTPUT c-folder).
    assign h-folder = widget-handle(c-folder) no-error.
    
    if valid-handle(h-folder) then do:
       
       ASSIGN  wh-objeto = p-wgh-frame:FIRST-CHILD
               wh-objeto = wh-objeto:FIRST-CHILD.

       DO WHILE VALID-HANDLE(wh-objeto):
           IF  wh-objeto:NAME = 'folder-frm':U THEN DO:
               ASSIGN wh-folder-frm = wh-objeto.
           END.

           ASSIGN  wh-objeto = wh-objeto:NEXT-SIBLING.
       END.
       
       IF VALID-HANDLE(wh-folder-frm) THEN
           ASSIGN wh-folder-frm:WIDTH = wh-folder-frm:WIDTH + 2.


       RUN create-folder-page IN h-folder (INPUT 10, INPUT c-agro).
       RUN create-folder-label IN h-folder (INPUT 10, INPUT c-agro).
       
       RUN select-page IN p-wgh-object (INPUT 10). 
       
       RUN init-object IN p-wgh-object (INPUT "agro-upc/ggcd0401-v01.w":U, 
                                        INPUT p-wgh-frame,
                                        INPUT "Layout = ":U,
                                        OUTPUT h-viewer).
       
       RUN set-position IN h-viewer ( 7.10, 5.00).
       
       RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                              INPUT "CONTAINER-TARGET":U,
                                              OUTPUT c-objects).
        
       do i-objects = 1 to num-entries(c-objects):
          assign h-object = widget-handle(entry(i-objects, c-objects)).          
          if h-object:PRIVATE-DATA = "adqry/q01ad098.w":U THEN
             RUN add-link IN adm-broker-hdl (INPUT h-object,
                                             INPUT "Record":U,
                                             INPUT h-viewer).          
          
          if h-object:PRIVATE-DATA = "cdp/cd0401-v02.w":U THEN
             RUN add-link IN adm-broker-hdl (INPUT h-object, 
                                             INPUT "Group-Assign":U,
                                             INPUT h-viewer).          
       end.
       
       RUN dispatch IN h-viewer ("initialize":U).
       RUN select-page IN p-wgh-object (INPUT 1).
       
    END.

END.

if  p-ind-object  = 'VIEWER':U      and
    p-ind-event   = 'display':U   and
    c-char        = 'cd0401-v02.w':U  then do:
     
    assign wh-objeto = p-wgh-frame:FIRST-CHILD.
    do  while valid-handle(wh-objeto):
        
        if  wh-objeto:NAME = "cod-emitente":U 
            then assign c-emitente-gg1002 = INT(wh-objeto:SCREEN-VALUE).
        
        if  wh-objeto:TYPE = 'field-group':U 
            then assign wh-objeto = wh-objeto:FIRST-CHILD.
            else assign wh-objeto = wh-objeto:NEXT-SIBLING.
    end.
    FIND FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = c-emitente-gg1002 NO-ERROR.
    IF AVAIL emitente THEN
       ASSIGN gr-emitente-gg1002 = ROWID(emitente)
              gr-emitente-gg1076 = ROWID(emitente).
end.


/* cd0401-v05.w - Campo Grupo Impostos */
if  p-ind-event   = "INITIALIZE":U    and 
    p-ind-object  = "VIEWER":U        AND
    c-char        = "cd0401-v05.w":U  then do:

    ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD.
    DO  WHILE VALID-HANDLE(wh-objeto):

        IF wh-objeto:NAME = "c-inscr-inss":U THEN
            ASSIGN wh-inscr-inss = wh-objeto.
        IF wh-objeto:NAME = "ins-estadual":U THEN
            ASSIGN wh-ins-estadual = wh-objeto.
        IF wh-objeto:NAME = "flgg-pag":U THEN
            ASSIGN wh-flgg-pag = wh-objeto.
        IF  wh-objeto:TYPE = "FIELD-GROUP":U THEN
            ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
        ELSE
            ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
     END.
   
END.

IF  p-ind-event  = "VALIDATE":U   AND
    c-char       = "cd0401-v05.w":U THEN DO:

    IF VALID-HANDLE(wh-ins-estadual) THEN DO:
        
        ASSIGN c-resp = NO
               i-cont = 0.

         
        DO c-do = 1 TO  INTEGER(LENGTH(STRING(wh-ins-estadual:SCREEN-VALUE))):
 
            ASSIGN i-cont = i-cont + 1.

            IF (SUBSTRING(wh-ins-estadual:SCREEN-VALUE,i-cont,1) <> "1":U AND
                SUBSTRING(wh-ins-estadual:SCREEN-VALUE,i-cont,1) <> "2":U AND
                SUBSTRING(wh-ins-estadual:SCREEN-VALUE,i-cont,1) <> "3":U AND
                SUBSTRING(wh-ins-estadual:SCREEN-VALUE,i-cont,1) <> "4":U AND
                SUBSTRING(wh-ins-estadual:SCREEN-VALUE,i-cont,1) <> "5":U AND
                SUBSTRING(wh-ins-estadual:SCREEN-VALUE,i-cont,1) <> "6":U AND
                SUBSTRING(wh-ins-estadual:SCREEN-VALUE,i-cont,1) <> "7":U AND
                SUBSTRING(wh-ins-estadual:SCREEN-VALUE,i-cont,1) <> "8":U AND
                SUBSTRING(wh-ins-estadual:SCREEN-VALUE,i-cont,1) <> "9":U AND
                SUBSTRING(wh-ins-estadual:SCREEN-VALUE,i-cont,1) <> "0":U) THEN ASSIGN c-resp = YES.
        END.

        /*Retirada a validaá∆o que obrigava o usu†rio a preencher a inscriá∆o estadual com a palavra ISENTO
          esta validaá∆o levava o sistema a ficar inconsistente com o cadastro de clientes - CD0704 que permite preencher com 
          branco, ou seja, deixar sem preenchimento. Foi adotado o padr∆o do cd0704, porque, quando possui a palavra ISENTO 
          apresenta erro de importaá∆o na SEFAZ*/

        FIND FIRST param-global NO-LOCK NO-ERROR.

        IF wh-ins-estadual:SCREEN-VALUE <> "":U AND (param-global.id-estadual-obrigatorio = NO) THEN DO:
            IF wh-ins-estadual:SCREEN-VALUE = "":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 34879,
                                   INPUT "":U).
                APPLY 'entry':U TO wh-ins-estadual.
                RETURN "NOK":U.
            END.              
    
            {utp/ut-liter.i "ISENTO" * R}
            IF wh-ins-estadual:SCREEN-VALUE <> RETURN-VALUE AND
               c-resp                        = YES      THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 34879,
                                   INPUT "":U).
                APPLY 'entry':U TO wh-ins-estadual.
                RETURN "NOK":U.
            END.
        END.
            
    END.
    
    
END.

       
