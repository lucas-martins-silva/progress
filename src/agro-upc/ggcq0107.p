/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCQ0107 2.00.00.007 } /*** "010007" 29/05/2025 09:23:33  ***/


/*************************************************************************
**    Programa.:  AGCQ0107
**    Objetivo.:  UPC para Solicitar se o exame possui desconto de produto
**                e se imprime na nota fiscal.
**    Data.....:  Agosto/2003
*************************************************************************/

/*********************** Defini‡Æo de Parƒmetros *************************/
define input parameter p-ind-event               as character      no-undo.
define input parameter p-ind-object              as character      no-undo.
define input parameter p-wgh-object              as handle         no-undo.
define input parameter p-wgh-frame               as widget-handle  no-undo.
define input parameter p-cod-table               as character      no-undo.
define input parameter p-row-table               as rowid          no-undo.


/* Projeto DAGR001 - IRM1909 - Replanejamento 11.8 para 11.5.10 - classifica‡Æo     */
{ggp/gg0001.i}


/******************** Defini‡Æo de Vari veis Globais *********************/
define new global shared VAR  v-wgh-object      AS handle        no-undo.
Define New Global Shared Var  adm-broker-hdl    as handle         no-undo.
Define New Global Shared Var  h-folder          as handle         no-undo.
Define New Global Shared Var  h-viewer           as handle         no-undo.
Define New Global Shared Var  h-browser          as handle         no-undo.

/******************** Defini‡Æo de Vari veis Locais **********************/
Define var  c-char                                     as char           no-undo.
Define Var  wh-objeto                                  as widget-handle  no-undo.
Define NEW GLOBAL SHARED VAR  wh-desconto-cq0107       as widget-handle  no-undo.
Define NEW GLOBAL SHARED VAR  wh-nf-cq0107             as widget-handle  no-undo.
define NEW GLOBAL SHARED VAR  wh-container-cq0107      as handle         no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wh-rec-for-pad-cq0107  AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wgh-cq0107-rect        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-exame               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-exame1              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-exame2              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ex-melhoria         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ex-melhoria1        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-text-est            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-text-item           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR  wh-folder-frm              AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gr-comp-exame          AS ROWID NO-UNDO.
DEF VAR wh-bt-tabela-cq0107 AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-bt-cancela-cq0107 AS WIDGET-HANDLE NO-UNDO.

DEFINE var h_frame  as widget-handle no-undo. 

DEFINE VARIABLE h-object                          AS HANDLE        NO-UNDO.
DEFINE VARIABLE i-objects                         AS INTEGER       NO-UNDO.
DEFINE VARIABLE c-objects                            AS CHARACTER     NO-UNDO.
Define Var      c-folder                             as Char           no-undo.

DEFINE VARIABLE c-mes1 AS CHARACTER FORMAT "x(28)"  NO-UNDO.
DEFINE VARIABLE c-mes2 AS CHARACTER FORMAT "x(16)"  NO-UNDO.
DEFINE VARIABLE c-mes3 AS CHARACTER FORMAT "x(20)"  NO-UNDO.

{utp/ut-liter.i "Valor do item para estoque" * R}
ASSIGN c-mes1 = RETURN-VALUE.
{utp/ut-liter.i "Possui Desconto?" * R}
ASSIGN c-mes2 = RETURN-VALUE.
{utp/ut-liter.i "Imprime Nota Fiscal?" * R}
ASSIGN c-mes3 = RETURN-VALUE.


/************************** In¡cio do Programa ***************************/

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/":U), p-wgh-object:file-name,"~/":U) NO-ERROR.
       
v-wgh-object = p-wgh-object.

if  p-ind-event   = "before-INITIALIZE":U   and 
    p-ind-object  = "CONTAINER":U    then do:

  
   /* bloco */                                                    
   ASSIGN h_Frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
   ASSIGN h_Frame = h_Frame:FIRST-CHILD.       /* pegando o 1o. Campo */
         
   DO WHILE h_Frame <> ? :
       if h_frame:type <> "field-group":U then do:  
          IF h_Frame:NAME = "f-main":U THEN DO :
             ASSIGN h_frame:HEIGHT = h_frame:HEIGHT + 2.
          END.
          ASSIGN h_Frame = h_Frame:NEXT-SIBLING.
       end. 
       else do:
          assign h_frame = h_frame:first-child.
       end.  
   END.    
   /* fim */
   
   ASSIGN wh-container-cq0107 = p-wgh-object.

   ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD
          wh-objeto = wh-objeto:FIRST-CHILD.
   DO WHILE VALID-HANDLE(wh-objeto):
      IF  wh-objeto:NAME = "bt-cancela":U THEN DO:
          ASSIGN wh-bt-cancela-cq0107 = wh-objeto
                 wh-objeto:SENSITIVE   = NO .
      END.

      ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
   END.

   CREATE BUTTON wh-bt-tabela-cq0107
   ASSIGN ROW            = wh-bt-cancela-cq0107:ROW
          COL            = wh-bt-cancela-cq0107:COL    + 44.5
          HEIGHT         = wh-bt-cancela-cq0107:HEIGHT
          WIDTH          = wh-bt-cancela-cq0107:WIDTH
          FRAME          = wh-bt-cancela-cq0107:FRAME
          SENSITIVE      = YES
          VISIBLE        = YES
          label          = "&Tabelas":U.

   wh-bt-tabela-cq0107:MOVE-TO-TOP() .
   ON  CHOOSE OF wh-bt-tabela-cq0107 PERSISTENT  RUN ggp/gg5020.w.

End.

IF p-ind-event  = "initialize":U AND
   p-ind-object = "VIEWER":U     AND
   c-char       = "v01in050.w":U THEN DO:

   /* aumenta retangulo viewer */
   ASSIGN h_frame = p-wgh-frame
          h_frame = h_frame:FIRST-CHILD.
   
   DO WHILE h_Frame <> ? :
      if h_frame:type <> "field-group":U then do:
         if h_frame:type = "rectangle":U then do:
            if h_frame:NAME = "rt-mold":U THEN 
               ASSIGN h_frame:HEIGHT = h_frame:HEIGHT + 2 NO-ERROR.
         END.
         ASSIGN h_Frame = h_Frame:NEXT-SIBLING.
      END.
      else DO:
          assign h_frame = h_frame:first-child.
      END.
   END.      
END.

if  p-ind-event   = "initialize":U and
    p-ind-object  = 'VIEWER':U      AND
    c-char        = 'v03in050.w':U then do:     

    {utp/ut-liter.i "Possui Desconto na Quantidade Recebida?" * R}
    create toggle-box wh-desconto-cq0107 
    assign frame     = p-wgh-frame
           col       = 60
           row       = 9.7
           visible   = yes
           sensitive = no
           checked   = NO
           help      = RETURN-VALUE
           label     = c-mes2.

    {utp/ut-liter.i "Imprime Resultado na Nota Fiscal?" * R}
    create toggle-box wh-nf-cq0107
    assign frame     = p-wgh-frame
           col       = 60
           row       = 10.4
           visible   = yes
           sensitive = no
           checked   = NO
           help      = RETURN-VALUE
           label     = c-mes3.

    {utp/ut-liter.i "Recebe Fora do PadrÆo" * R}
    create toggle-box wh-rec-for-pad-cq0107
    assign frame     = p-wgh-frame
           col       = 60
           row       = 9.0
           visible   = YES
           sensitive = NO
           checked   = NO
           help      = RETURN-VALUE
           label     = RETURN-VALUE.

    /* Sarah */
    {utp/ut-liter.i "Melhoria" * R}
    CREATE TEXT wh-exame1
    ASSIGN ROW          = 3.15
           COLUMN       = 57.30
           FRAME        = p-wgh-frame
           SENSITIVE    = NO
           VISIBLE      = YES
           HEIGHT-CHARS = 0.8
           WIDTH-CHARS  = 8
           FORMAT       = "x(08)"
           SCREEN-VALUE = RETURN-VALUE.

    CREATE RECTANGLE wgh-cq0107-rect
    ASSIGN ROW         = 3.50 
           COL         = 55.72
           FRAME       = p-wgh-frame
           WIDTH       = 29
           HEIGHT      = 2.75
           NAME        = "retan-cq0107":U
           EDGE-PIXELS = 2
           BGCOLOR     = 8
           FILLED      = NO.
           wgh-cq0107-rect:GRAPHIC-EDGE.
    
    {utp/ut-liter.i "Exame de Melhoria:" * R}
    CREATE TEXT wh-exame
    ASSIGN ROW          = 3.92
           COLUMN       = 60
           FRAME        = p-wgh-frame
           VISIBLE      = YES
           HEIGHT       = 0.8
           WIDTH        = 16
           FORMAT       = "x(18)"
           SCREEN-VALUE = RETURN-VALUE.
    
    CREATE FILL-IN wh-ex-melhoria
    ASSIGN ROW          = 3.92
           SIDE-LABEL-HANDLE = wh-exame:HANDLE       
           LABEL             = RETURN-VALUE
           COLUMN       = 73.96
           DATA-TYPE    = "integer":U
           FRAME        = p-wgh-frame
           SENSITIVE    = YES
           VISIBLE      = YES
           WIDTH        = 7
           HEIGHT       = 0.88  
           WIDTH-CHARS  = 10
           NAME         = RETURN-VALUE
           FORMAT       = ">>>>>9":U
           SCREEN-VALUE = "":U 
           HELP         = RETURN-VALUE.

    ON 'MOUSE-SELECT-DBLCLICK':U OF wh-ex-melhoria OR 'f5':U OF wh-ex-melhoria PERSISTENT RUN agro-upc/ggcq0107a.p.
    ON 'leave':U OF wh-ex-melhoria PERSISTENT RUN agro-upc/ggcq0107c.p.
    wh-ex-melhoria:LOAD-MOUSE-POINTER("image/lupa.cur":U).

    {utp/ut-liter.i "Exame Umidade:" * R}
    CREATE TEXT wh-exame2
    ASSIGN ROW          = 4.92
           COLUMN       = 62
           FRAME        = p-wgh-frame
           VISIBLE      = YES
           HEIGHT       = 0.8
           WIDTH        = 13
           FORMAT       = "x(14)"
           SCREEN-VALUE = RETURN-VALUE.
    
    CREATE FILL-IN wh-ex-melhoria1
    ASSIGN ROW          = 4.92
           SIDE-LABEL-HANDLE = wh-exame2:HANDLE       
           LABEL             = RETURN-VALUE
           COLUMN       = 73.96
           DATA-TYPE    = "integer":U
           FRAME        = p-wgh-frame
           SENSITIVE    = YES
           VISIBLE      = YES
           WIDTH        = 7
           HEIGHT       = 0.88  
           WIDTH-CHARS  = 10
           NAME         = "Exame_Umidade":U
           FORMAT       = ">>>>>9":U
           SCREEN-VALUE = "":U 
           HELP         = RETURN-VALUE.

    ON 'MOUSE-SELECT-DBLCLICK':U OF wh-ex-melhoria1 OR 'f5':U OF wh-ex-melhoria1 PERSISTENT RUN agro-upc/ggcq0107b.p.
    ON 'leave':U OF wh-ex-melhoria1 PERSISTENT RUN agro-upc/ggcq0107d.p.
    wh-ex-melhoria1:LOAD-MOUSE-POINTER("image/lupa.cur":U).
    
    IF VALID-HANDLE(wh-container-cq0107) THEN
       RUN select-page IN wh-container-cq0107 (INPUT 1).
end.
  
if  p-ind-object  = 'VIEWER':U      and
    p-ind-event   = 'Display':U     and
    c-char        = 'v03in050.w':U  then do:
    
    IF p-row-table <> ? THEN DO:
       FIND FIRST comp-exame NO-LOCK WHERE rowid(comp-exame) = p-row-table NO-ERROR.
       IF AVAIL comp-exame THEN  DO:
           ASSIGN gr-comp-exame = ROWID(comp-exame).
           FIND FIRST gg-ext-comp-exame NO-LOCK
                WHERE gg-ext-comp-exame.cod-exame = comp-exame.cod-exame
                  AND gg-ext-comp-exame.cod-comp  = comp-exame.cod-comp NO-ERROR.
           IF AVAIL gg-ext-comp-exame THEN DO:
               IF valid-handle(wh-desconto-cq0107) THEN 
                  ASSIGN wh-desconto-cq0107:CHECKED = gg-ext-comp-exame.log-desconto.

               IF valid-handle(wh-nf-cq0107) THEN 
                  ASSIGN wh-nf-cq0107:CHECKED = gg-ext-comp-exame.log-nf.

               IF valid-handle(wh-rec-for-pad-cq0107) THEN 
                  ASSIGN wh-rec-for-pad-cq0107:CHECKED = gg-ext-comp-exame.log-rec-fora-padrao.

               IF valid-handle(wh-ex-melhoria) THEN 
                  ASSIGN wh-ex-melhoria:SCREEN-VALUE = string(gg-ext-comp-exame.cod-exame-me).
               
               IF valid-handle(wh-ex-melhoria1) THEN 
                  ASSIGN wh-ex-melhoria1:SCREEN-VALUE = string(gg-ext-comp-exame.cod-exame-um).
           END.
           ELSE DO:
               IF VALID-HANDLE(wh-desconto-cq0107) THEN
                   ASSIGN wh-desconto-cq0107:CHECKED = NO.

               IF VALID-HANDLE(wh-nf-cq0107) THEN
                   ASSIGN wh-nf-cq0107:CHECKED = NO.

               IF VALID-HANDLE(wh-rec-for-pad-cq0107) THEN
                   ASSIGN wh-rec-for-pad-cq0107:CHECKED = NO.
               
               IF VALID-HANDLE(wh-ex-melhoria) THEN
                   ASSIGN wh-ex-melhoria:SCREEN-VALUE   = '':U
                           wh-ex-melhoria1:SCREEN-VALUE  = '':U.
           END.
       END.
    END.
END.          
                       
if p-ind-event   =  "enable":U       and
   p-ind-object  =  "viewer":U       and
   c-char   =  'v03in050.w':U  then do:
   
  IF VALID-HANDLE(wh-desconto-cq0107) THEN
     ASSIGN wh-desconto-cq0107:SENSITIVE    = YES
            wh-nf-cq0107      :SENSITIVE    = YES
            wh-rec-for-pad-cq0107:SENSITIVE = YES.

  IF VALID-HANDLE(wh-ex-melhoria) THEN
     ASSIGN wh-ex-melhoria:sensitive = yes.
  IF VALID-HANDLE(wh-ex-melhoria1) THEN
     ASSIGN wh-ex-melhoria1:sensitive = yes.
end.   

if p-ind-event  = "assign":U     AND 
   p-ind-object = "viewer":U     AND
   c-char       = "v03in050.w":U THEN DO:
   
   FIND FIRST comp-exame NO-LOCK WHERE rowid(comp-exame) = p-row-table NO-ERROR.
   IF AVAIL comp-exame THEN  DO:
      FIND FIRST gg-ext-comp-exame EXCLUSIVE-LOCK
           WHERE gg-ext-comp-exame.cod-exame        = comp-exame.cod-exame
             AND gg-ext-comp-exame.cod-comp         = comp-exame.cod-comp NO-ERROR.
      IF NOT AVAIL gg-ext-comp-exame THEN DO:
         CREATE gg-ext-comp-exame.
         ASSIGN gg-ext-comp-exame.cod-exame        = comp-exame.cod-exame
                gg-ext-comp-exame.cod-comp         = comp-exame.cod-comp
                gg-ext-comp-exame.log-desconto     = IF VALID-HANDLE(wh-desconto-cq0107) THEN wh-desconto-cq0107:CHECKED ELSE NO
                gg-ext-comp-exame.log-nf           = IF VALID-HANDLE(wh-nf-cq0107) THEN wh-nf-cq0107:CHECKED ELSE NO
                gg-ext-comp-exame.log-rec-fora-padrao = IF VALID-HANDLE(wh-rec-for-pad-cq0107) THEN wh-rec-for-pad-cq0107:CHECKED ELSE NO
                gg-ext-comp-exame.cod-exame-me     = int(wh-ex-melhoria:SCREEN-VALUE)
                gg-ext-comp-exame.cod-exame-um     = int(wh-ex-melhoria1:SCREEN-VALUE).
      END.
      ELSE 
          ASSIGN gg-ext-comp-exame.log-desconto     = IF valid-handle(wh-desconto-cq0107) THEN wh-desconto-cq0107:CHECKED ELSE NO
                 gg-ext-comp-exame.log-nf           = IF valid-handle(wh-nf-cq0107) THEN wh-nf-cq0107:CHECKED ELSE NO
                 gg-ext-comp-exame.log-rec-fora-padrao = IF valid-handle(wh-rec-for-pad-cq0107) THEN wh-rec-for-pad-cq0107:CHECKED ELSE NO
                 gg-ext-comp-exame.cod-exame-me     = IF valid-handle(wh-ex-melhoria) THEN int(wh-ex-melhoria:SCREEN-VALUE) ELSE 0
                 gg-ext-comp-exame.cod-exame-um     = IF valid-handle(wh-ex-melhoria1) THEN int(wh-ex-melhoria1:SCREEN-VALUE) ELSE 0.
   END.
end.

if p-ind-event  = "add":U        and
   p-ind-object = "viewer":U     and
   c-char       = "v03in050.w":U then do:

    {utp/ut-liter.i "Exame de Melhoria:" * R}
    IF  VALID-HANDLE(wh-exame) THEN
        ASSIGN wh-exame:SCREEN-VALUE = RETURN-VALUE.

    {utp/ut-liter.i "Melhoria" * R}
    IF VALID-HANDLE(wh-exame1) THEN
        ASSIGN wh-exame1:SCREEN-VALUE = RETURN-VALUE.

    {utp/ut-liter.i "Exame Umidade:" * R}
    IF VALID-HANDLE(wh-exame2) THEN
        ASSIGN wh-exame2:SCREEN-VALUE = RETURN-VALUE. 
END.
     
/************** FOLDER GERAIS ******************************/
if  p-ind-event   = "INITIALIZE":U   and 
    p-ind-object  = "CONTAINER":U    then do:

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


       
       {utp/ut-liter.i "Geral" * R}
       RUN create-folder-page IN h-folder (INPUT 4, INPUT RETURN-VALUE).  
       
       {utp/ut-liter.i "Geral" * R}
       RUN create-folder-label IN h-folder (INPUT 4, INPUT RETURN-VALUE).
       
       RUN select-page IN p-wgh-object (INPUT 4). 
       
       RUN init-object IN p-wgh-object (INPUT "agro-upc/ggcq0107-v01.w":U, 
                                        INPUT p-wgh-frame,
                                        INPUT "Layout = ":U,
                                        OUTPUT h-viewer).
       
       RUN set-position IN h-viewer ( 2.75, 3.00).
       
       RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                              INPUT "CONTAINER-TARGET":U,
                                              OUTPUT c-objects).
        
       do i-objects = 1 to num-entries(c-objects):
          assign h-object = widget-handle(entry(i-objects, c-objects)).          
          if h-object:PRIVATE-DATA = "inqry/q01in050.w":U THEN
             RUN add-link IN adm-broker-hdl (INPUT h-object,
                                             INPUT "Record":U,
                                             INPUT h-viewer).          
          
          if h-object:PRIVATE-DATA = "invwr/v01in050.w":U THEN
             RUN add-link IN adm-broker-hdl (INPUT h-object, 
                                             INPUT "Group-Assign":U,
                                             INPUT h-viewer).          
       end.
       
       RUN dispatch IN h-viewer ("initialize":U).
       RUN select-page IN p-wgh-object (INPUT 1).
       
    END.
END.

