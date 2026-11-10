&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0101C 2.00.00.014 } /*** "010014" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0101c MIM}
&ENDIF

/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

{cxbo/bocx310a.i tt-desp-embarque}
{cxbo/bocx310a.i tt-desp-embarque-parent}
{cxbo/bocx310a.i tt-desp-embarque-rateio}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0101C

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Despesas

&GLOBAL-DEFINE First            no
&GLOBAL-DEFINE Prev             no
&GLOBAL-DEFINE Next             no
&GLOBAL-DEFINE Last             no
&GLOBAL-DEFINE GoTo             no
&GLOBAL-DEFINE Search           no

&GLOBAL-DEFINE AddParent        no
&GLOBAL-DEFINE CopyParent       no
&GLOBAL-DEFINE UpdateParent     no
&GLOBAL-DEFINE DeleteParent     no

&GLOBAL-DEFINE AddSon1          no
&GLOBAL-DEFINE CopySon1         no
&GLOBAL-DEFINE UpdateSon1       no
&GLOBAL-DEFINE DeleteSon1       no

&GLOBAL-DEFINE ttParent         tt-desp-embarque-parent
&GLOBAL-DEFINE hDBOParent       h-bocx310parent       
&GLOBAL-DEFINE DBOParentTable   desp-embarque   
&GLOBAL-DEFINE DBOParentDestroy 

&GLOBAL-DEFINE ttSon1           tt-desp-embarque
&GLOBAL-DEFINE hDBOSon1         h-bocx310a
&GLOBAL-DEFINE DBOSon1Table     desp-embarque
&GLOBAL-DEFINE DBOSon1Destroy   

&GLOBAL-DEFINE page0Fields      

&GLOBAL-DEFINE page1Browse      brSon1   

&GLOBAL-DEFINE MOUSE-SELECT-DBLCLICK1 yes
&GLOBAL-DEFINE VALUE-CHANGED1         yes
&GLOBAL-DEFINE NumRowsReturned        40

{cxbo/bocx220h.i tt-selecao-embarque}

{cxbo/bocx310a.i tt-desp-embarque-aux}

/* Parameters Definitions ---                                           */

def input param pl-agrupa-unico-fornec as logical                 no-undo.
def input param pcod-emitente-desp     as int  format ">>>>>>>>9" no-undo.  
def input param  table for tt-selecao-embarque.

def input-output param table for tt-desp-embarque.
def input-output param cod-desp-ini     as int format ">>,>>9"    no-undo.
def input-output param cod-desp-fim     as int format ">>,>>9"    no-undo.
def input-output param fornec-desp-ini  as int format ">>>>>>>>9" no-undo.
def input-output param fornec-desp-fim  as int format ">>>>>>>>9" no-undo.
def input-output param pto-controle-ini as int format ">>,>>9"    no-undo.
def input-output param pto-controle-fim as int format ">>,>>9"    no-undo.
def input-output param l-ok-c  as log no-undo.
def input-output param table for tt-desp-embarque-aux.

/* Local Variable Definitions ---                                       */
DEFINE BUFFER bf-desp-embarque FOR tt-desp-embarque.

DEFINE VARIABLE vc-desp-msg             AS CHARACTER              NO-UNDO.
DEFINE VARIABLE vc-emb-msg              AS CHARACTER              NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-desp-embarque

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-desp-embarque.cod-desp tt-desp-embarque.desc-desp tt-desp-embarque.cod-emitente-desp tt-desp-embarque.nome-abrev tt-desp-embarque.embarque tt-desp-embarque.cod-pto-contr tt-desp-embarque.desc-pto tt-desp-embarque.moeda tt-desp-embarque.cond-pagto tt-desp-embarque.val-desp   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 for each tt-desp-embarque         by tt-desp-embarque.embarque         by tt-desp-embarque.cod-desp
&Scoped-define OPEN-QUERY-brSon1 open query {&SELF-NAME} for each tt-desp-embarque         by tt-desp-embarque.embarque         by tt-desp-embarque.cod-desp .
&Scoped-define TABLES-IN-QUERY-brSon1 tt-desp-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-desp-embarque


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-selecao btQueryJoins btReportsJoins ~
btExit btHelp rtToolBar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-rateio 
     IMAGE-UP FILE "IMAGE/im-aloca.bmp":U
     IMAGE-INSENSITIVE FILE "IMAGE/im-aloci.bmp":U
     LABEL "Rateio Despesas" 
     SIZE 4 BY 1.25 TOOLTIP "Efetuar Rateio das Despesas para os embarques selecionados".

DEFINE BUTTON bt-selecao 
     IMAGE-UP FILE "IMAGE~\im-ran":U
     LABEL "Sel" 
     SIZE 4.14 BY 1.21 TOOLTIP "Faixa de Despesas a Selecionar".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image~\im-joi":U
     IMAGE-INSENSITIVE FILE "image~\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image~\im-pri":U
     IMAGE-INSENSITIVE FILE "image~\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-desmarca-todos 
     LABEL "&Desmarca Todos" 
     SIZE 13 BY 1.

DEFINE BUTTON bt-marca 
     LABEL "&Marca" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-marca-todos 
     LABEL "Marca &Todos" 
     SIZE 12 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-desp-embarque SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      tt-desp-embarque.cod-desp             COLUMN-LABEL "Cod Desp"   
      tt-desp-embarque.desc-desp            COLUMN-LABEL "Desc Desp"  
      tt-desp-embarque.cod-emitente-desp    COLUMN-LABEL "Fornecedor" 
      tt-desp-embarque.nome-abrev           COLUMN-LABEL "Nome Abrev" 
      tt-desp-embarque.embarque                                       
      tt-desp-embarque.cod-pto-contr                                  
      tt-desp-embarque.desc-pto             COLUMN-LABEL "Desc Pto"   
      tt-desp-embarque.moeda                                          
      tt-desp-embarque.cond-pagto           COLUMN-LABEL "Cond Pagto" 
      tt-desp-embarque.val-desp             COLUMN-LABEL "Val Despes"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 82 BY 11.08
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     bt-selecao AT ROW 1.13 COL 1.72 HELP
          "Faixa de Despesas a Selecionar"
     bt-rateio AT ROW 1.13 COL 6.14 HELP
          "Faixa de Embarques a Selecionar" WIDGET-ID 2
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.88
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     bt-marca AT ROW 12.33 COL 2.43
     bt-marca-todos AT ROW 12.33 COL 14.43
     bt-desmarca-todos AT ROW 12.33 COL 26.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.25
         SIZE 84.43 BY 12.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.88
         WIDTH              = 90
         MAX-HEIGHT         = 27.17
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.17
         VIRTUAL-WIDTH      = 146.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
ASSIGN 
       brSon1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brSon1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
open query {&SELF-NAME} for each tt-desp-embarque
        by tt-desp-embarque.embarque
        by tt-desp-embarque.cod-desp .
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON MOUSE-SELECT-DBLCLICK OF brSon1 IN FRAME fPage1
DO:
  {masterdetail/dblclick.i &PageNumber="1"}

   apply "choose" to bt-marca in frame fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON ROW-DISPLAY OF brSon1 IN FRAME fPage1
DO:
    if avail tt-desp-embarque then do:
        if tt-desp-embarque.selecionado then do:
            assign tt-desp-embarque.cod-desp:font             in browse brSon1 = 6
                   tt-desp-embarque.desc-desp:font            in browse brSon1 = 6
                   tt-desp-embarque.cod-emitente-desp:font    in browse brSon1 = 6
                   tt-desp-embarque.nome-abrev:font           in browse brSon1 = 6
                   tt-desp-embarque.embarque:font             in browse brSon1 = 6 
                   tt-desp-embarque.cod-pto-contr:font        in browse brSon1 = 6 
                   tt-desp-embarque.desc-pto:font             in browse brSon1 = 6
                   tt-desp-embarque.moeda:font                in browse brSon1 = 6
                   tt-desp-embarque.cond-pagto:font           in browse brSon1 = 6
                   tt-desp-embarque.val-desp:font             in browse brSon1 = 6
                   tt-desp-embarque.cod-desp:fgcolor          in browse brSon1 = 9 
                   tt-desp-embarque.desc-desp:fgcolor         in browse brSon1 = 9
                   tt-desp-embarque.cod-emitente-desp:fgcolor in browse brSon1 = 9
                   tt-desp-embarque.nome-abrev:fgcolor        in browse brSon1 = 9
                   tt-desp-embarque.embarque:fgcolor          in browse brSon1 = 9
                   tt-desp-embarque.cod-pto-contr:fgcolor     in browse brSon1 = 9 
                   tt-desp-embarque.desc-pto:fgcolor          in browse brSon1 = 9
                   tt-desp-embarque.moeda:fgcolor             in browse brSon1 = 9
                   tt-desp-embarque.cond-pagto:fgcolor        in browse brSon1 = 9
                   tt-desp-embarque.val-desp:fgcolor          in browse brSon1 = 9.
        end.
        else do:
            assign tt-desp-embarque.cod-desp:font             in browse brSon1 = 2
                   tt-desp-embarque.desc-desp:font            in browse brSon1 = 2
                   tt-desp-embarque.cod-emitente-desp:font    in browse brSon1 = 2
                   tt-desp-embarque.nome-abrev:font           in browse brSon1 = 2
                   tt-desp-embarque.embarque:font             in browse brSon1 = 2 
                   tt-desp-embarque.cod-pto-contr:font        in browse brSon1 = 2 
                   tt-desp-embarque.desc-pto:font             in browse brSon1 = 2
                   tt-desp-embarque.moeda:font                in browse brSon1 = 2
                   tt-desp-embarque.cond-pagto:font           in browse brSon1 = 2
                   tt-desp-embarque.val-desp:font             in browse brSon1 = 2
                   tt-desp-embarque.cod-desp:fgcolor          in browse brSon1 = 0 
                   tt-desp-embarque.desc-desp:fgcolor         in browse brSon1 = 0
                   tt-desp-embarque.cod-emitente-desp:fgcolor in browse brSon1 = 0
                   tt-desp-embarque.nome-abrev:fgcolor        in browse brSon1 = 0
                   tt-desp-embarque.embarque:fgcolor          in browse brSon1 = 0
                   tt-desp-embarque.cod-pto-contr:fgcolor     in browse brSon1 = 0 
                   tt-desp-embarque.desc-pto:fgcolor          in browse brSon1 = 0
                   tt-desp-embarque.moeda:fgcolor             in browse brSon1 = 0
                   tt-desp-embarque.cond-pagto:fgcolor        in browse brSon1 = 0
                   tt-desp-embarque.val-desp:fgcolor          in browse brSon1 = 0.
        end.
    end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON VALUE-CHANGED OF brSon1 IN FRAME fPage1
DO:
         
    {masterdetail/valuechanged.i &PageNumber="1"}
    
    define variable i-cont   as int no-undo.
    define variable l-label1 as log no-undo.
    define variable l-label2 as log no-undo.
    
    if  brSon1:num-selected-rows in frame fPage1 > 0 then do: 
        do  i-cont = 1 to brSon1:num-selected-rows in frame fPage1:
            if  brSon1:fetch-selected-row(i-cont) in frame fPage1 then do:

                get current brSon1.
                if  avail tt-desp-embarque then do:
                
                    if  tt-desp-embarque.selecionado = no then
                        assign l-label1 = yes.
                    else
                        assign l-label2 = yes.
                end.
            end.
        end.
        if  l-label1 and l-label2 then 
            assign bt-marca:label     in frame fPage1 = "Ma&rca"
                   bt-marca:sensitive in frame fPage1 = no.
        else if l-label1 then
            assign bt-marca:label     in frame fPage1 = "Ma&rca"
                   bt-marca:sensitive in frame fPage1 = yes.
           else if l-label2 then
               assign bt-marca:label     in frame fPage1 = "D&esmarca"
                      bt-marca:sensitive in frame fPage1 = yes.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarca-todos wMasterDetail
ON CHOOSE OF bt-desmarca-todos IN FRAME fPage1 /* Desmarca Todos */
DO:
    for each tt-desp-embarque:
        assign tt-desp-embarque.selecionado = no.
    end.

    {&OPEN-QUERY-brSon1}

    browse brSon1:select-row(1) no-error.

    apply "value-changed":U to brSon1 in frame fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca wMasterDetail
ON CHOOSE OF bt-marca IN FRAME fPage1 /* Marca */
DO:
    def var i-cont as int no-undo.

    if  brSon1:num-selected-rows >= 1 then do:
        do  i-cont = 1 to brSon1:num-selected-rows in frame fPage1:
            if  brSon1:fetch-selected-row(i-cont) in frame fPage1 then do:
                get current brSon1.
                if  tt-desp-embarque.selecionado then
                    assign tt-desp-embarque.selecionado = no
                           self:label in frame fPage1 = "&Marca".
                else do:
					FIND FIRST bf-desp-embarque WHERE bf-desp-embarque.selecionado = YES
                                                AND   bf-desp-embarque.cod-desp    =  tt-desp-embarque.cod-desp
                                                NO-LOCK NO-ERROR.
                    IF AVAIL bf-desp-embarque THEN
                        RUN utp/ut-msgs.p (INPUT "show",
                                           INPUT 57467,
                                           INPUT tt-desp-embarque.embarque).                        
					
                    assign tt-desp-embarque.selecionado = yes
                           self:label in frame fPage1 = "D&esmarca".                
				end.
                brSon1:refresh() in frame fPage1.
            end.
        end.
    end.

    apply "value-changed":U to brSon1 in frame fPage1.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca-todos wMasterDetail
ON CHOOSE OF bt-marca-todos IN FRAME fPage1 /* Marca Todos */
DO:
    ASSIGN vc-desp-msg = ""
           vc-emb-msg  = "".

    for each tt-desp-embarque:
        ASSIGN tt-desp-embarque.selecionado = NO.
    END.

    for each tt-desp-embarque:

        FIND FIRST bf-desp-embarque WHERE bf-desp-embarque.selecionado = YES
                                    AND   bf-desp-embarque.cod-desp    =  tt-desp-embarque.cod-desp
                                    NO-LOCK NO-ERROR.
        IF AVAIL bf-desp-embarque THEN
            ASSIGN vc-desp-msg = IF vc-desp-msg = "" THEN STRING(tt-desp-embarque.cod-desp) ELSE vc-desp-msg + ", " + STRING(tt-desp-embarque.cod-desp)
                   vc-emb-msg  = IF vc-emb-msg = "" THEN STRING(tt-desp-embarque.embarque) ELSE vc-emb-msg + ", " + STRING(tt-desp-embarque.embarque).
        
		assign tt-desp-embarque.selecionado = yes.
    end.

    {&OPEN-QUERY-brSon1}

    IF vc-desp-msg <> "" THEN
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 57468,
                           INPUT vc-desp-msg + "~~" + vc-emb-msg).

    browse brSon1:select-row(1) no-error.

    apply "value-changed":U to brSon1 in frame fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME bt-rateio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-rateio wMasterDetail
ON CHOOSE OF bt-rateio IN FRAME fPage0 /* Rateio Despesas */
DO:
    RUN pi-rateio-despesas-embarque.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-selecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-selecao wMasterDetail
ON CHOOSE OF bt-selecao IN FRAME fPage0 /* Sel */
DO:
    run imp/im0101c1.w (input-output cod-desp-ini,    
                        input-output cod-desp-fim,    
                        input-output fornec-desp-ini, 
                        input-output fornec-desp-fim, 
                        input-output pto-controle-ini,
                        input-output pto-controle-fim,
                        output l-ok-c,
                        input table  tt-desp-embarque).
    if  l-ok-c then do:
        empty temp-table tt-desp-embarque.
        empty temp-table tt-desp-embarque-aux.
    end.
    
    find first tt-desp-embarque no-error.
    if  not avail tt-desp-embarque then do:
        run openQueriesSon in this-procedure.
        browse brSon1:select-row(1) no-error.
    end.

    apply "value-changed":U to brSon1 in frame fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*Antes de sair do programa sera atualizado o campo tt-desp-embarque-aux.selecionado
    para que num pr¢ximo acesso ao programa os registro mantenham-se selecionados ou n∆o*/
    for each tt-desp-embarque
        USE-INDEX ch-embarque:  

        FOR FIRST tt-desp-embarque-aux 
            WHERE tt-desp-embarque-aux.r-rowid = tt-desp-embarque.r-rowid NO-LOCK:
        END.
        IF NOT AVAIL tt-desp-embarque-aux THEN NEXT.

        if tt-desp-embarque-aux.selecionado <> tt-desp-embarque.selecionado then
            assign tt-desp-embarque-aux.selecionado = tt-desp-embarque.selecionado.
    end.
    

    if valid-handle (h-bocx310a) then
        delete procedure h-bocx310a.
    assign h-bocx310a = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {utp/ut-liter.i Ma&rca c}
    assign bt-marca:label in frame fPage1 = trim(return-value).
    {utp/ut-liter.i "&Marca_Todos" c}
    assign bt-marca-todos:label in frame fPage1 = trim(return-value).
    {utp/ut-liter.i "&Desmarca_Todos" c}
    assign bt-desmarca-todos:label in frame fPage1 = trim(return-value).

    enable bt-marca
           bt-marca-todos
           bt-desmarca-todos  with frame fPage1.
 
    enable bt-selecao
           bt-rateio  with frame fPage0.
 
    assign bt-marca:sensitive in frame fPage1          = yes
           bt-marca-todos:sensitive in frame fPage1    = yes
           bt-desmarca-todos:sensitive in frame fPage1 = yes
           bt-selecao:sensitive in frame fPage0        = yes.
 
    /*Se n∆o houver nenhum registro na tt-desp-embarque ir† chamar o im0101c1 (Faixa de despesas)*/
    find first tt-desp-embarque
        where tt-desp-embarque.selecionado = yes no-error.
    if  not avail tt-desp-embarque then do:
        view wMasterDetail.
        apply "choose" to bt-selecao in frame fPage0.
    end.
    else do: /*Se j† houver registros, ou seja, n∆o Ç a primeira vez que o programa Ç iniciado: */
 
        /*Limpa a tt-desp-embarque*/
        empty temp-table tt-desp-embarque.
       
        /*Cria uma nova tt-desp-embarque(despesa). 
          A tt-desp-embarque-aux Ç gerada com base no primeiro acesso Ö BO com 
          base na faixa de embarques. Possui todas as despesas, porÇm s¢ aparecer∆o no browse
          as despesas dos embarques selecionados no im0101b*/
        for each tt-desp-embarque-aux:
            create tt-desp-embarque.
            buffer-copy tt-desp-embarque-aux to tt-desp-embarque.
        end.                                                     
 
        run piValidaDespesaEmbarque in this-procedure.
 
        open query brSon1 for each tt-desp-embarque.
        if can-find(first RowErrors 
                where RowErrors.ErrorSubtype = "INFORMATION":U) then do:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="yes"}
            empty temp-table RowErrors.
        end.
    end.
        
    browse brSon1:select-row(1) no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInteface wMaintenance 
PROCEDURE afterDestroyInteface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {method/ShowMessage.i3}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
   /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "cxbo~\bocx310a.p":U THEN DO:
        {btb/btb008za.i1 cxbo\bocx310a.p YES}
        {btb/btb008za.i2 cxbo\bocx310a.p '' {&hDBOSon1}} 
    END.

    IF NOT VALID-HANDLE({&hDBOParent}) OR 
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "cxbo~\bocx310a.p":U THEN DO:
        {btb/btb008za.i1 cxbo\bocx310a.p YES}
        {btb/btb008za.i2 cxbo\bocx310a.p '' {&hDBOParent}} 
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*A vari†vel l-ok-c Ç atualizada no programa im0101c1 (Faixa de despesas)
      e inicia-se com o valor "no". Ent∆o ao entrar pela primeira vez no programa 
      n∆o ser† acessada a BO para carregar a tt-desp-embarque, ser† aberto o im0101c1
      e de l† vir† o valor "yes" na variavel l-ok-c, assim Ç carregada a tt-desp-embarque
      e a query Ç aberta*/
    if l-ok-c = yes then do:
       
       empty temp-table tt-desp-embarque.

       run piRetornaSelecaoDespesa in h-bocx310a  (input pl-agrupa-unico-fornec,     /*im0101*/
                                                   input pcod-emitente-desp,         /*im0101*/
                                                   input cod-desp-ini,               /*im0101c1*/
                                                   input cod-desp-fim,               /*im0101c1*/
                                                   input fornec-desp-ini,            /*im0101c1*/
                                                   input fornec-desp-fim,            /*im0101c1*/
                                                   input pto-controle-ini,           /*im0101c1*/
                                                   input pto-controle-fim,           /*im0101c1*/
                                                   input  table tt-selecao-embarque, /*im0101b*/
                                                   output table tt-desp-embarque).

       /*Cria tt-desp-embarque-aux para que sempre estejam dispon°veis todas as despesas da faixa atual de embarques
       porÇm no browse apenas aparecer† as despesas do(s) embarque(s) selecionados, validaá∆o feita na piValidaDespesaEmbarque*/
       for each tt-desp-embarque:
            create tt-desp-embarque-aux.
            buffer-copy tt-desp-embarque to tt-desp-embarque-aux no-error.
        end.

    run piValidaDespesaEmbarque in this-procedure.

    open query brSon1 for each tt-desp-embarque.

        if  can-find(first RowErrors 
                     where RowErrors.ErrorSubtype = "INFORMATION":U) then do:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="yes"}
            empty temp-table RowErrors.
        end.
    
    apply "entry" to brSon1 in frame fPage1.

    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-rateio-despesas-embarque wMasterDetail 
PROCEDURE pi-rateio-despesas-embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-desp-embarque-rateio.
    
    FOR EACH tt-desp-embarque
        WHERE tt-desp-embarque.selecionado:   
        CREATE tt-desp-embarque-rateio.
        BUFFER-COPY tt-desp-embarque TO tt-desp-embarque-rateio.   
    END.

    IF  AVAIL tt-desp-embarque-rateio THEN DO:
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        run imp/im3101d.w (INPUT TABLE tt-desp-embarque-rateio,
                           INPUT TABLE tt-selecao-embarque,
                           INPUT TABLE tt-desp-embarque,
                           INPUT THIS-PROCEDURE).
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    END.    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seleciona-desp-rateio wMasterDetail 
PROCEDURE pi-seleciona-desp-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM TABLE FOR tt-desp-embarque-rateio.
    
    for each  tt-desp-embarque:
        delete tt-desp-embarque.
    end.
    for each  tt-desp-embarque-aux:
        delete tt-desp-embarque-aux.
    end.
    
    find first tt-desp-embarque no-error.
    if  not avail tt-desp-embarque then do:
        run openQueriesSon in this-procedure.
    end.
    
    FOR EACH tt-desp-embarque-rateio:
        FOR FIRST tt-desp-embarque 
            WHERE tt-desp-embarque.cod-estabel = tt-desp-embarque-rateio.cod-estabel
            AND   tt-desp-embarque.embarque    = tt-desp-embarque-rateio.embarque
            AND   tt-desp-embarque.cod-desp    = tt-desp-embarque-rateio.cod-desp:
            ASSIGN tt-desp-embarque.selecionado = YES.
        END.
        FOR FIRST tt-desp-embarque-aux 
            WHERE tt-desp-embarque-aux.cod-estabel = tt-desp-embarque-rateio.cod-estabel
            AND   tt-desp-embarque-aux.embarque    = tt-desp-embarque-rateio.embarque
            AND   tt-desp-embarque-aux.cod-desp    = tt-desp-embarque-rateio.cod-desp:
            ASSIGN tt-desp-embarque-aux.selecionado = YES.
        END.
    END.
    
    open query brSon1 for each tt-desp-embarque.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaDespesaEmbarque wMasterDetail 
PROCEDURE piValidaDespesaEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-seq-erro AS INTEGER NO-UNDO.

 /*Valida para mostrar no browse apenas as despesas dos 
   embarques selecionados no im0101b*/         
 for each tt-selecao-embarque
    where tt-selecao-embarque.marca = ""
     USE-INDEX selecao:
     for each tt-desp-embarque
         where tt-desp-embarque.cod-estabel = tt-selecao-embarque.cod-estabel
         and   tt-desp-embarque.embarque    = tt-selecao-embarque.embarque:
         delete tt-desp-embarque.
     end.
 end.

    /* Para os embarques relacionados a uma DI(im0400) e necessario que as despesas estejam rateadas */
    for each tt-selecao-embarque
       where tt-selecao-embarque.marca = "x"
       use-index selecao:
       for each tt-desp-embarque
           where tt-desp-embarque.cod-estabel = tt-selecao-embarque.cod-estabel
           and   tt-desp-embarque.embarque    = tt-selecao-embarque.embarque:
    
           if can-find(first decla-import
                       where decla-import.num-di-ems = tt-selecao-embarque.num-di-ems
                         and substring(decla-import.cod-livre-1,1,1) <> "S") then do:
               assign tt-desp-embarque.val-desp = 0.
    
               run utp/ut-msgs.p (input "msg",
                                  input 54553,
                                  input STRING(tt-desp-embarque.cod-desp) + "~~" + tt-desp-embarque.embarque).
               CREATE RowErrors.
               ASSIGN RowErrors.ErrorSequence    =  i-seq-erro + 1
                      RowErrors.ErrorNumber      =  54553
                      RowErrors.ErrorParameters  = STRING(tt-desp-embarque.cod-desp) + "~~" + tt-desp-embarque.embarque + "~~" + STRING(tt-selecao-embarque.num-di-ems)
                      RowErrors.ErrorDescription = RETURN-VALUE
                      RowErrors.ErrorSubType     = "INFORMATION" .
    
           end.
       end.
    end.
    
 return "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

