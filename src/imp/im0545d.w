&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
          movadm           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-tit-ap NO-UNDO LIKE tit-ap
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0545D 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0545d MIM}
&ENDIF

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0545D
&GLOBAL-DEFINE Version        2.00.00.006
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FramesHandle     STRING(FRAME fPage1:HANDLE)
&GLOBAL-DEFINE FolderLabels     Titulos

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE ttParent         tt-embarque-imp
&GLOBAL-DEFINE hDBOParent       h-bocx220
&GLOBAL-DEFINE DBOParentTable   embarque-imp

&GLOBAL-DEFINE ttSon1           tt-tit-ap
&GLOBAL-DEFINE hDBOSon1         h-boad260f
&GLOBAL-DEFINE DBOSon1Table     tit-ap

&GLOBAL-DEFINE page0Fields      tt-embarque-imp.cod-estabel ~
                                tt-embarque-imp.embarque ~
                                
                                
&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page1widgets     bt-mov 

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAMETER p-rowid AS ROWID NO-UNDO.


/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-cod-estabel like tt-embarque-imp.cod-estabel NO-UNDO.
DEFINE VARIABLE c-embarque    like tt-embarque-imp.embarque    NO-UNDO.
DEFINE VARIABLE ro-rowid      as rowid                         NO-UNDO.
DEFINE VARIABLE c-return      as char                          NO-UNDO. 

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.

DEFINE VARIABLE p-l-titulo-despesa AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES tt-tit-ap

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-tit-ap.cod-estabel tt-tit-ap.cod-fornec tt-tit-ap.nome-abrev tt-tit-ap.ep-codigo tt-tit-ap.cod-esp tt-tit-ap.serie tt-tit-ap.nr-docto tt-tit-ap.parcela tt-tit-ap.pedido tt-tit-ap.inst-banc   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-tit-ap NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-tit-ap NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-tit-ap
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-tit-ap


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define ENABLED-TABLES tt-embarque-imp
&Scoped-define FIRST-ENABLED-TABLE tt-embarque-imp
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btQueryJoins btReportsJoins btExit btHelp rtParent rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define DISPLAYED-TABLES tt-embarque-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-embarque-imp


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
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
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
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image~\im-fir":U
     IMAGE-INSENSITIVE FILE "image~\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image~\im-enter":U
     IMAGE-INSENSITIVE FILE "image~\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image~\im-las":U
     IMAGE-INSENSITIVE FILE "image~\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image~\im-nex":U
     IMAGE-INSENSITIVE FILE "image~\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image~\im-pre":U
     IMAGE-INSENSITIVE FILE "image~\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

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

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.42.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-mov 
     LABEL "Movimentos" 
     SIZE 10 BY 1.

DEFINE BUTTON btfiltro 
     LABEL "Filtro" 
     SIZE 11 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-tit-ap SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 DISPLAY
      tt-tit-ap.cod-estabel COLUMN-LABEL "Estab"
      tt-tit-ap.cod-fornec COLUMN-LABEL "Fornecedor"
      tt-tit-ap.nome-abrev column-label "Nome Abrev"
      tt-tit-ap.ep-codigo COLUMN-LABEL "Empresa"
      tt-tit-ap.cod-esp
      tt-tit-ap.serie
      tt-tit-ap.nr-docto
      tt-tit-ap.parcela COLUMN-LABEL "Parc"
      tt-tit-ap.pedido COLUMN-LABEL "N§.Tit.Banco"
      tt-tit-ap.inst-banc COLUMN-LABEL "Instru‡Æo Banc ria"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 7.79
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-embarque-imp.cod-estabel AT ROW 2.92 COL 44 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.29 BY .88
     tt-embarque-imp.embarque AT ROW 3.92 COL 44 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.25
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.38 COL 2.29
     bt-mov AT ROW 9.33 COL 2.29
     btfiltro AT ROW 9.33 COL 12.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.72 ROW 7.13
         SIZE 84.43 BY 9.67
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-tit-ap T "?" NO-UNDO movadm tit-ap
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.25
         WIDTH              = 90
         MAX-HEIGHT         = 17.67
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.67
         VIRTUAL-WIDTH      = 90
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-tit-ap NO-LOCK.
     _END_FREEFORM
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-mov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-mov wMasterDetail
ON CHOOSE OF bt-mov IN FRAME fPage1 /* Movimentos */
DO:
    if avail tt-tit-ap then do:  
      if brson1:num-selected-rows in frame fPage1 = 0 then do:
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Nenhum_Registro_Foi_Selecionado" *}
          message RETURN-VALUE.
      end.
      if brson1:num-selected-rows in frame fPage1 <> 0 then do:
           browse brson1:fetch-selected-row(int(brson1:num-selected-rows)).
           assign ro-rowid    = tt-tit-ap.r-rowid.
      end.
    end.
  RUN imp/im0545e.w (input ro-rowid).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btfiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btfiltro wMasterDetail
ON CHOOSE OF btfiltro IN FRAME fPage1 /* Filtro */
DO:
     RUN imp/im0545df.w (INPUT-OUTPUT p-l-titulo-despesa).

     RUN openQueriesSon IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
    RETURN "OK":U.
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


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    DEFINE VARIABLE cReturn AS CHARACTER NO-UNDO.
    def var ttrowid as rowid no-undo.
        
    for each RowErrors:
        delete RowErrors.
    end.
    assign ttrowid = {&ttParent}.r-rowid.
    
    RUN findNext IN {&hDBOParent} (OUTPUT cReturn).
    IF cReturn = "":U THEN DO:
        RUN getCurrent IN {&hDBOParent} (OUTPUT TABLE {&ttParent}).
        RUN displayFields IN THIS-PROCEDURE.
    END.
    ELSE DO:
         run utp/ut-msgs.p (input "msg",
                            input 7999,
                            input "").
         create RowErrors.
         assign RowErrors.errornumber   = 7999
                RowErrors.errordescription  = return-value.
         RUN findRowid in {&hDBOParent} (input ttrowid).
         if cReturn = "" then 
            RUN setCurrent in {&hDBOParent}.
    END.
    IF CAN-FIND(FIRST RowErrors) THEN DO:
         disable btLast btNext with frame fPage0.
         IF NOT VALID-HANDLE(hShowMsg) THEN
             RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
         ELSE
             DELETE PROCEDURE hShowMsg.
         
         RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
          
         LEAVE.
    END.
    
    enable btFirst btPrev with frame fPage0.
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    DEFINE VARIABLE cReturn AS CHARACTER NO-UNDO.
    def var ttrowid as rowid no-undo.
    
    for each RowErrors:
        delete RowErrors.
    end.
    assign ttrowid = {&ttParent}.r-rowid.
    RUN findPrev IN {&hDBOParent} (OUTPUT cReturn).
    IF cReturn = "":U THEN DO:
        RUN getCurrent IN {&hDBOParent} (OUTPUT TABLE {&ttParent}).
        RUN displayFields IN THIS-PROCEDURE.
    END.
    ELSE DO:
         run utp/ut-msgs.p (input "msg",
                            input 7998,
                            input "").
         create RowErrors.
         assign RowErrors.errornumber   = 7998
                RowErrors.errordescription  = return-value.
         RUN findRowid in {&hDBOParent} (input ttrowid).
         if cReturn = "" then 
            RUN setCurrent in {&hDBOParent}.
    END.
    IF CAN-FIND(FIRST RowErrors) THEN DO:
         disable btPrev btFirst with frame fPage0.
         IF NOT VALID-HANDLE(hShowMsg) THEN
             RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
         ELSE
             DELETE PROCEDURE hShowMsg.
         
         RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).

          
         LEAVE.
    END.
    
    enable btLast btNext with frame fPage0.
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="cxzoom/z10cx220.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  enable bt-mov with frame fpage1.    
  RETURN "OK":U.
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
ASSIGN btfiltro:SENSITIVE IN FRAME fPage1 = YES
       p-l-titulo-despesa = "No".
Run getFirst in this-procedure.
RUN repositionRecord IN this-procedure (INPUT p-rowid).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8.

    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 35 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE cStatus AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE ccod-estabel like embarque-imp.cod-estabel NO-UNDO.
    DEFINE VARIABLE iembarque like embarque-imp.embarque NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        ccod-estabel AT ROW 1.21 COL 15 COLON-ALIGNED
        iembarque AT ROW 2.21 COL 15 COLON-ALIGNED
        btGoToOK      AT ROW 3.63 COL 2.14
        btGoToCancel  AT ROW 3.63 COL 13
        rtGoToButton  AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE FONT 1 TITLE "V  Para Embarque"
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN ccod-estabel iembarque.
        
        &IF DEFINED(DBOVersion) <> 0 &THEN
           RUN findch_Embarque IN {&hDBOParent} (INPUT ccod-estabel, 
                                                 INPUT iembarque,
                                                 OUTPUT cStatus).
           IF cStatus <> "":U THEN DO:
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Embarque" *}
              RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                 INPUT 2, 
                                 INPUT RETURN-VALUE).              
              RETURN NO-APPLY.
           END.
        &ENDIF
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    assign ccod-estabel:width = 4
           iembarque:width = 16.
    
    ENABLE ccod-estabel iembarque btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
    RETURN "OK":U.
    END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:
       RUN cxbo/bocx220.p persistent set h-bocx220.
    END.    
    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOParent} (INPUT 1).
    &ELSE
        RUN openQueryStatic IN {&hDBOParent} (INPUT "ccod-estabel":U).
    &ENDIF
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) THEN DO:
       RUN adbo/boad260f.p persistent set {&hDBOSon1}.
    END.

/*    run findrowid in {&hDBOParent} (input p-rowid).
 *     RUN repositionRecord IN this-procedure (INPUT p-rowid).*/
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE ccod-estabel like tt-embarque-imp.cod-estabel NO-UNDO.
   DEFINE VARIABLE iembarque    like tt-embarque-imp.embarque    NO-UNDO.

   IF AVAILABLE tt-embarque-imp THEN DO:

        ASSIGN ccod-estabel = tt-embarque-imp.cod-estabel
               iembarque    = tt-embarque-imp.embarque.

        RUN setconstraint3 in {&hDBOSon1} (input ccod-estabel,
                                           input iembarque).

        RUN carregatable   in {&hDBOSon1} (INPUT p-l-titulo-despesa).
        
        {masterdetail/OpenQueriesSon.i
        &Parent="tt-embarque-imp"
        &Query="embarque-imp"
        &PageNumber="1"
        &QueryConstraint="3"
        &ConstraintParameters="ccod-estabel, iembarque"}
        
    END.              
    ELSE
        ASSIGN iembarque = " "
               ccod-estabel  = " ".   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRowid wMasterDetail 
PROCEDURE setRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER ccod-estabel  like tt-embarque-imp.cod-estabel NO-UNDO.
   DEFINE INPUT PARAMETER cembarque     like tt-embarque-imp.embarque    NO-UNDO.
    
   ASSIGN c-cod-estabel = ccod-estabel 
          c-embarque    = cembarque.
                 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

