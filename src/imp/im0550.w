&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-historico-proc-imp NO-UNDO LIKE historico-proc-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-historico-proc-imp2 NO-UNDO LIKE historico-proc-imp
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
{include/i-prgvrs.i IM0550 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0550 MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0550
&GLOBAL-DEFINE Version        2.00.00.011
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FramesHandle     STRING(FRAME fPage1:HANDLE)
&GLOBAL-DEFINE FolderLabels     Pts de Contr.

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE ttParent         tt-historico-proc-imp
&GLOBAL-DEFINE hDBOParent       h-bocx150a
&GLOBAL-DEFINE DBOParentTable   historico-proc-imp

&GLOBAL-DEFINE ttSon1           tt-historico-proc-imp2
&GLOBAL-DEFINE hDBOSon1         h-bocx150a2
&GLOBAL-DEFINE DBOSon1Table     historico-proc-imp

&GLOBAL-DEFINE page0Fields      tt-historico-proc-imp.cod-estabel ~
                                tt-historico-proc-imp.nr-proc-imp ~
                                tt-historico-proc-imp.cod-itiner ~
                                fill-in-1 ~
                                fill-in-2 ~
                                fill-in-3 ~
                                fill-in-4 
&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
def var h-boun005 as handle no-undo.
def var cDescricao as char no-undo.
def var h-bocx1102 as handle no-undo.
def var cDiferenca as integer no-undo.
def var isituacao as integer no-undo.
def var h-bocx140 as handle no-undo.
def var c-nr-proc-imp as char no-undo.
def var i-cod-itiner as integer no-undo.

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
&Scoped-define INTERNAL-TABLES tt-historico-proc-imp2

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-historico-proc-imp2.sequencia ~
tt-historico-proc-imp2.cod-pto-contr ~
fnDescricao(input tt-historico-proc-imp2.cod-pto-contr) @ cDescricao ~
tt-historico-proc-imp2.dt-previsao tt-historico-proc-imp2.dt-ult-previsao ~
tt-historico-proc-imp2.dt-efetiva ~
fnDiferenca(input tt-historico-proc-imp2.dt-efetiva) @ cDiferenca ~
tt-historico-proc-imp2.id-meio-transp 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-historico-proc-imp2 NO-LOCK ~
    BY tt-historico-proc-imp2.cod-estabel ~
       BY tt-historico-proc-imp2.nr-proc-imp.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-historico-proc-imp2
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-historico-proc-imp2


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-historico-proc-imp.cod-estabel ~
tt-historico-proc-imp.nr-proc-imp tt-historico-proc-imp.cod-itiner 
&Scoped-define ENABLED-TABLES tt-historico-proc-imp
&Scoped-define FIRST-ENABLED-TABLE tt-historico-proc-imp
&Scoped-define DISPLAYED-TABLES tt-historico-proc-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-historico-proc-imp
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btOrdem btItem btQueryJoins btReportsJoins btExit btHelp COMBO-BOX-1 ~
FILL-IN-2 FILL-IN-1 FILL-IN-3 FILL-IN-4 rtParent rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-historico-proc-imp.cod-estabel ~
tt-historico-proc-imp.nr-proc-imp tt-historico-proc-imp.cod-itiner 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-1 FILL-IN-2 FILL-IN-1 FILL-IN-3 ~
FILL-IN-4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricao wMasterDetail 
FUNCTION fnDescricao RETURNS CHARACTER
  (input pcod-pto-contr as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDiferenca wMasterDetail 
FUNCTION fnDiferenca RETURNS INTEGER
  (input dt-efetiva as date)  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE BUTTON btItem 
     IMAGE-UP FILE "image~\im-item":U
     LABEL "Item" 
     SIZE 4 BY 1.25 TOOLTIP "Itens do Processo"
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

DEFINE BUTTON btOrdem 
     IMAGE-UP FILE "image~\im-forma":U
     LABEL "Ordem" 
     SIZE 4 BY 1.25 TOOLTIP "Ordens do Processo"
     FONT 4.

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

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "NÆo Embarcado","Embarcado Parcial","Embarcado Total","Encerrado" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Valor Processo" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Moeda" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 5.04.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-historico-proc-imp2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 DISPLAY
      tt-historico-proc-imp2.sequencia FORMAT ">>9":U
      tt-historico-proc-imp2.cod-pto-contr FORMAT ">>,>>9":U
      fnDescricao(input tt-historico-proc-imp2.cod-pto-contr) @ cDescricao COLUMN-LABEL "Descri‡Æo" FORMAT "X(30)":U
      tt-historico-proc-imp2.dt-previsao FORMAT "99/99/9999":U
      tt-historico-proc-imp2.dt-ult-previsao FORMAT "99/99/9999":U
      tt-historico-proc-imp2.dt-efetiva FORMAT "99/99/9999":U
      fnDiferenca(input tt-historico-proc-imp2.dt-efetiva) @ cDiferenca COLUMN-LABEL "Diferen‡a" FORMAT "->>>>>9":U
      tt-historico-proc-imp2.id-meio-transp FORMAT "X(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82.29 BY 8.79
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
     btOrdem AT ROW 1.13 COL 31 HELP
          "Embarque"
     btItem AT ROW 1.13 COL 35 HELP
          "Embarque"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-historico-proc-imp.cod-estabel AT ROW 3.17 COL 34.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-historico-proc-imp.nr-proc-imp AT ROW 4.17 COL 34.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     COMBO-BOX-1 AT ROW 4.17 COL 58.57 COLON-ALIGNED
     tt-historico-proc-imp.cod-itiner AT ROW 5.17 COL 34.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     FILL-IN-2 AT ROW 5.17 COL 58.57 COLON-ALIGNED
     FILL-IN-1 AT ROW 6.17 COL 34.86 COLON-ALIGNED
     FILL-IN-3 AT ROW 6.17 COL 58.57 COLON-ALIGNED
     FILL-IN-4 AT ROW 6.17 COL 63.86 COLON-ALIGNED NO-LABEL
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.04
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.46 COL 2.57
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 9.38
         SIZE 85.72 BY 9.67
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-historico-proc-imp T "?" NO-UNDO mgcex historico-proc-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-historico-proc-imp2 T "?" NO-UNDO mgcex historico-proc-imp
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
         HEIGHT             = 18.13
         WIDTH              = 90.57
         MAX-HEIGHT         = 21.21
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.21
         VIRTUAL-WIDTH      = 114.29
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
     _TblList          = "Temp-Tables.tt-historico-proc-imp2"
     _OrdList          = "Temp-Tables.tt-historico-proc-imp2.cod-estabel|yes,Temp-Tables.tt-historico-proc-imp2.nr-proc-imp|yes"
     _FldNameList[1]   = Temp-Tables.tt-historico-proc-imp2.sequencia
     _FldNameList[2]   = Temp-Tables.tt-historico-proc-imp2.cod-pto-contr
     _FldNameList[3]   > "_<CALC>"
"fnDescricao(input tt-historico-proc-imp2.cod-pto-contr) @ cDescricao" "Descri‡Æo" "X(30)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[4]   = Temp-Tables.tt-historico-proc-imp2.dt-previsao
     _FldNameList[5]   = Temp-Tables.tt-historico-proc-imp2.dt-ult-previsao
     _FldNameList[6]   = Temp-Tables.tt-historico-proc-imp2.dt-efetiva
     _FldNameList[7]   > "_<CALC>"
"fnDiferenca(input tt-historico-proc-imp2.dt-efetiva) @ cDiferenca" "Diferen‡a" "->>>>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[8]   = Temp-Tables.tt-historico-proc-imp2.id-meio-transp
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


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btItem wMasterDetail
ON CHOOSE OF btItem IN FRAME fPage0 /* Item */
DO:
  find first tt-historico-proc-imp no-error.
    if avail tt-historico-proc-imp then
        RUN imp/im0550b.w (input "ADD",
                           input tt-historico-proc-imp.r-rowid,
                           input THIS-PROCEDURE,
                           input 1,
                           input ?).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
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
    
    RUN findNext2 IN {&hDBOParent} (OUTPUT cReturn).
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOrdem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOrdem wMasterDetail
ON CHOOSE OF btOrdem IN FRAME fPage0 /* Ordem */
DO:
    find first tt-historico-proc-imp no-error.
    if avail tt-historico-proc-imp then do:
        RUN imp/im0550a.w (input "ADD",
                           input tt-historico-proc-imp.r-rowid,
                           input THIS-PROCEDURE,
                           input 1,
                           input ?).
    END.

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
    RUN findPrev2 IN {&hDBOParent} (OUTPUT cReturn).
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


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="cxzoom/z10cx150.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-3 wMasterDetail
ON LEAVE OF FILL-IN-3 IN FRAME fPage0 /* Moeda */
DO:
  {method/referencefields.i 
      &HandleDBOLeave="h-boun005"
      &FindMethod="findCodigo"
      &KeyValue1="integer(fill-in-3:SCREEN-VALUE IN FRAME fPage0)"
      &FieldName1="descricao"
      &FieldScreen1="fill-in-4"
      &Frame1="fPage0"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyinterface wMasterDetail 
PROCEDURE afterDestroyinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    delete procedure h-bocx1102.
    delete procedure h-bocx140.
    delete procedure h-boun005.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var cStatus   as char    no-undo.
    def var isituacao as integer no-undo.
    def var de-valor-processo as decimal no-undo.
    def var i-cod-exportador  as int no-undo.
    def var i-mo-codigo       as int no-undo.
    
    if avail tt-historico-proc-imp then do:            
        run findPk_nr_processo in h-bocx140 (input tt-historico-proc-imp.nr-proc-imp,
                                             output cStatus).
        if cStatus = "" then do:
            run getIntField in h-bocx140(input "situacao", output isituacao).
            run getIntfield in h-bocx140(input "cod-exportador", output i-cod-exportador).
            assign fill-in-2:screen-value in frame fPage0= string(i-cod-exportador).
            
            assign combo-box-1:screen-value in frame fPage0 = {cxinc/i01cx140.i 04 isituacao}.
            run retornaMoedaValor in h-bocx140(input tt-historico-proc-imp.nr-proc-imp,
                                               input tt-historico-proc-imp.cod-estabel,
                                               output de-valor-processo,
                                               output i-mo-codigo).
            assign fill-in-3:screen-value in frame fPage0 = string(i-mo-codigo).            
            assign fill-in-1:screen-value in frame fPage0 = string(de-valor-processo).
            apply "leave" to fill-in-3 in frame fPage0.                                               
            run openQueriesSon in this-procedure.
        end.
    end.

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
    
    DEFINE VARIABLE ccod-estabel like historico-proc-imp.cod-estabel NO-UNDO.
    DEFINE VARIABLE cnr-proc-imp like historico-proc-imp.nr-proc-imp NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        ccod-estabel AT ROW 1.21 COL 15 COLON-ALIGNED
        cnr-proc-imp AT ROW 2.21 COL 15 COLON-ALIGNED
        btGoToOK      AT ROW 3.63 COL 2.14
        btGoToCancel  AT ROW 3.63 COL 13
        rtGoToButton  AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE FONT 1 TITLE "V  Para Histor Proc Imp"
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN ccod-estabel cnr-proc-imp.
        
        &IF DEFINED(DBOVersion) <> 0 &THEN
           RUN findChProcesso IN {&hDBOParent} (INPUT ccod-estabel, 
                                                INPUT cnr-proc-imp,
                                                OUTPUT cStatus).
           IF cStatus <> "":U THEN DO:
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Hist¢rico_dos_Processos" *}
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
    
    assign ccod-estabel:width = 4.
    
    ENABLE ccod-estabel cnr-proc-imp btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
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

    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:
        RUN cxbo/bocx150a.p persistent set h-bocx150a.
    END.    
    
    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOParent} (INPUT 1).
    &ELSE
        RUN openQueryStatic IN {&hDBOParent} (INPUT "ccod-estabel":U).
    &ENDIF
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) THEN DO:
        RUN cxbo/bocx150a.p persistent set h-bocx150a2.
    END.
    
    RUN cxbo/bocx110.p persistent set h-bocx1102.    
    RUN cxbo/bocx140.p persistent set h-bocx140.
    RUN unbo/boun005.p persistent set h-boun005.
    enable btOrdem btItem with frame {&FRAME-NAME}.
    
    &IF '{&mgdis_version}' < '2.06f' &THEN
        /*Tecnica para implementar valida‡Æo produto Estendido*/
        {cdp/cdapi558.i1}
    &endif
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
    DEFINE VARIABLE cnr-proc-imp as char NO-UNDO.
    DEFINE VARIABLE icod-itiner as integer NO-UNDO.
    
    find first tt-historico-proc-imp no-error.
    IF AVAILABLE tt-historico-proc-imp THEN do:
        {masterdetail/OpenQueriesSon.i
                 &Parent="tt-historico-proc-imp"
                 &Query="NrProcImp"
                 &PageNumber="1"
                 &QueryConstraint="2"
                 &ConstraintParameters="1, tt-historico-proc-imp.r-rowid, cnr-proc-imp, icod-itiner"}
    end.
                     
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricao wMasterDetail 
FUNCTION fnDescricao RETURNS CHARACTER
  (input pcod-pto-contr as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var c-descricao as char no-undo.
  def var cStatus as char no-undo.
  RUN findCodigo in h-bocx1102 (input pcod-pto-contr, output cStatus).
  if cStatus = "" then 
  RUN getCharField in h-bocx1102 (input "descricao", output c-descricao).

  RETURN c-descricao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDiferenca wMasterDetail 
FUNCTION fnDiferenca RETURNS INTEGER
  (input dt-efetiva as date) :
  def var num-dif as integer no-undo.
  
  if dt-efetiva <> ? then 
     assign num-dif = dt-efetiva - tt-historico-proc-imp2.dt-previsao.
  else assign num-dif = dt-ult-previsao - tt-historico-proc-imp2.dt-previsao.
  
  RETURN num-dif.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

