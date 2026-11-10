&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-decla-import-adic NO-UNDO LIKE decla-import-adic
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-decla-import-adic-itens NO-UNDO LIKE decla-import-adic-itens
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-despes-adic NO-UNDO LIKE despes-adic
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-despes-decla-import NO-UNDO LIKE despes-decla-import
       FIELD r-Rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0400G 2.00.00.010 } /*** "010010" 14/11/2025 16:15:33 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0400G 2.00.00.001}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        im0400g
&GLOBAL-DEFINE Version        2.00.00.010

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEF INPUT PARAM p-num-di-ems        LIKE decla-import.num-di-ems       NO-UNDO.
DEF INPUT PARAM p-num-seq-retif     LIKE decla-import.num-seq-retif    NO-UNDO.                              
DEF INPUT PARAM p-cdd-siscomex-dts  LIKE decla-import.cdd-siscomex-dts NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-bocx390 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx403 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx402 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx406 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx383 AS HANDLE      NO-UNDO.
DEFINE VARIABLE iRowsReturned AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brAdic

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-decla-import-adic tt-despes-adic ~
tt-despes-decla-import tt-decla-import-adic-itens

/* Definitions for BROWSE brAdic                                        */
&Scoped-define FIELDS-IN-QUERY-brAdic tt-decla-import-adic.num-adic tt-decla-import-adic.val-vmcv tt-decla-import-adic.val-vmle tt-decla-import-adic.val-vmld tt-decla-import-adic.val-frete tt-decla-import-adic.val-seguro   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brAdic   
&Scoped-define SELF-NAME brAdic
&Scoped-define QUERY-STRING-brAdic FOR EACH tt-decla-import-adic NO-LOCK
&Scoped-define OPEN-QUERY-brAdic OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-adic NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brAdic tt-decla-import-adic
&Scoped-define FIRST-TABLE-IN-QUERY-brAdic tt-decla-import-adic


/* Definitions for BROWSE brDespAdic                                    */
&Scoped-define FIELDS-IN-QUERY-brDespAdic tt-despes-adic.cdn-despes tt-despes-adic.cdn-moeda tt-despes-adic.val-despes tt-despes-adic.idi-orig-despes tt-despes-adic.log-forma-preco-compra tt-despes-adic.log-incid-vmle   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDespAdic   
&Scoped-define SELF-NAME brDespAdic
&Scoped-define QUERY-STRING-brDespAdic FOR EACH tt-despes-adic NO-LOCK
&Scoped-define OPEN-QUERY-brDespAdic OPEN QUERY {&SELF-NAME} FOR EACH tt-despes-adic NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brDespAdic tt-despes-adic
&Scoped-define FIRST-TABLE-IN-QUERY-brDespAdic tt-despes-adic


/* Definitions for BROWSE brDespDi                                      */
&Scoped-define FIELDS-IN-QUERY-brDespDi tt-despes-decla-import.cdn-despes tt-despes-decla-import.val-despes tt-despes-decla-import.cdn-moeda tt-despes-decla-import.log-incid-vmle tt-despes-decla-import.log-forma-preco-compra   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDespDi   
&Scoped-define SELF-NAME brDespDi
&Scoped-define QUERY-STRING-brDespDi FOR EACH tt-despes-decla-import NO-LOCK
&Scoped-define OPEN-QUERY-brDespDi OPEN QUERY {&SELF-NAME} FOR EACH tt-despes-decla-import NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brDespDi tt-despes-decla-import
&Scoped-define FIRST-TABLE-IN-QUERY-brDespDi tt-despes-decla-import


/* Definitions for BROWSE brItensAdic                                   */
&Scoped-define FIELDS-IN-QUERY-brItensAdic tt-decla-import-adic-itens.num-adic tt-decla-import-adic-itens.num-seq tt-decla-import-adic-itens.cod-item tt-decla-import-adic-itens.val-vmcv tt-decla-import-adic-itens.val-vmld tt-decla-import-adic-itens.val-vmle tt-decla-import-adic-itens.val-vucv tt-decla-import-adic-itens.val-frete tt-decla-import-adic-itens.val-seguro   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brItensAdic   
&Scoped-define SELF-NAME brItensAdic
&Scoped-define QUERY-STRING-brItensAdic FOR EACH tt-decla-import-adic-itens NO-LOCK
&Scoped-define OPEN-QUERY-brItensAdic OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-adic-itens NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brItensAdic tt-decla-import-adic-itens
&Scoped-define FIRST-TABLE-IN-QUERY-brItensAdic tt-decla-import-adic-itens


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brAdic}~
    ~{&OPEN-QUERY-brDespAdic}~
    ~{&OPEN-QUERY-brDespDi}~
    ~{&OPEN-QUERY-brItensAdic}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-decla-import.num-di-ems ~
tt-decla-import.dat-di 
&Scoped-define ENABLED-TABLES tt-decla-import
&Scoped-define FIRST-ENABLED-TABLE tt-decla-import
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-1 RECT-3 RECT-4 ~
RECT-5 btQueryJoins btReportsJoins btExit btHelp brDespDi brAdic brDespAdic ~
brItensAdic btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-FIELDS tt-decla-import.num-di-ems ~
tt-decla-import.dat-di 
&Scoped-define DISPLAYED-TABLES tt-decla-import
&Scoped-define FIRST-DISPLAYED-TABLE tt-decla-import


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48 BY 6.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 113 BY 7.04.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64 BY 6.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 113 BY 6.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 115 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 116 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brAdic FOR 
      tt-decla-import-adic SCROLLING.

DEFINE QUERY brDespAdic FOR 
      tt-despes-adic SCROLLING.

DEFINE QUERY brDespDi FOR 
      tt-despes-decla-import SCROLLING.

DEFINE QUERY brItensAdic FOR 
      tt-decla-import-adic-itens SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brAdic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brAdic wWindow _FREEFORM
  QUERY brAdic NO-LOCK DISPLAY
      tt-decla-import-adic.num-adic  FORMAT "999":U
      tt-decla-import-adic.val-vmcv  FORMAT "->>,>>>,>>>,>>9.99999999":U COLUMN-LABEL "VMCV"
      tt-decla-import-adic.val-vmle  FORMAT "->>,>>>,>>>,>>9.99999999":U COLUMN-LABEL "VMLE"
      tt-decla-import-adic.val-vmld  FORMAT "->>,>>>,>>>,>>9.99999999":U COLUMN-LABEL "VMLD"
      tt-decla-import-adic.val-frete FORMAT "->>,>>>,>>>,>>9.99999999":U COLUMN-LABEL "Frete"
      tt-decla-import-adic.val-seguro FORMAT "->>,>>>,>>>,>>9.99999999":U COLUMN-LABEL "Seguro"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 60 BY 4.5
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brDespAdic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDespAdic wWindow _FREEFORM
  QUERY brDespAdic NO-LOCK DISPLAY
      tt-despes-adic.cdn-despes FORMAT ">>>,>>9":U
      tt-despes-adic.cdn-moeda FORMAT ">9":U
      tt-despes-adic.val-despes FORMAT ">>>,>>>,>>>,>>9.99999999":U
      tt-despes-adic.idi-orig-despes FORMAT "9":U
      tt-despes-adic.log-forma-preco-compra FORMAT "Sim/NÆo":U
      tt-despes-adic.log-incid-vmle FORMAT "Sim/NÆo":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 103 BY 5.5
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brDespDi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDespDi wWindow _FREEFORM
  QUERY brDespDi NO-LOCK DISPLAY
      tt-despes-decla-import.cdn-despes FORMAT ">>,>>9":U
      tt-despes-decla-import.val-despes FORMAT ">>>,>>>,>>>,>>9.99999999":U
      tt-despes-decla-import.cdn-moeda FORMAT ">9":U
      tt-despes-decla-import.log-incid-vmle FORMAT "Sim/NÆo":U
      tt-despes-decla-import.log-forma-preco-compra FORMAT "Sim/NÆo":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 43 BY 4.88
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brItensAdic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brItensAdic wWindow _FREEFORM
  QUERY brItensAdic NO-LOCK DISPLAY
      tt-decla-import-adic-itens.num-adic FORMAT "999":U
      tt-decla-import-adic-itens.num-seq FORMAT ">>>>9":U
      tt-decla-import-adic-itens.cod-item FORMAT "x(16)":U
      tt-decla-import-adic-itens.val-vmcv FORMAT "->>,>>>,>>>,>>9.99999999":U COLUMN-LABEL "VMCV"  
      tt-decla-import-adic-itens.val-vmld FORMAT "->>,>>>,>>>,>>9.99999999":U COLUMN-LABEL "VMLD"  
      tt-decla-import-adic-itens.val-vmle FORMAT "->>,>>>,>>>,>>9.99999999":U COLUMN-LABEL "VMLE"  
      tt-decla-import-adic-itens.val-vucv FORMAT "->>,>>>,>>>,>>9.99999999":U COLUMN-LABEL "VUCV"
      tt-decla-import-adic-itens.val-frete FORMAT ">>>,>>>,>>>,>>9.99999999":U COLUMN-LABEL "Frete"
      tt-decla-import-adic-itens.val-seguro FORMAT ">>>,>>>,>>>,>>9.99999999":U COLUMN-LABEL "Seguro"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 103 BY 4.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 100.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 104.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 108.29 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 112.29 HELP
          "Ajuda"
     tt-decla-import.num-di-ems AT ROW 2.79 COL 24 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-decla-import.dat-di AT ROW 2.79 COL 45 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     brDespDi AT ROW 4.88 COL 5 WIDGET-ID 200
     brAdic AT ROW 5 COL 53 WIDGET-ID 300
     brDespAdic AT ROW 11.75 COL 6 WIDGET-ID 400
     brItensAdic AT ROW 18.79 COL 6 WIDGET-ID 500
     btOK AT ROW 24.71 COL 2
     btCancel AT ROW 24.71 COL 13
     btHelp2 AT ROW 24.71 COL 104.86
     "Itens Adi‡Æo" VIEW-AS TEXT
          SIZE 37 BY .54 AT ROW 18 COL 6 WIDGET-ID 24
     "Adi‡äes" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 3.88 COL 55 WIDGET-ID 20
     "Despesas Adi‡Æo" VIEW-AS TEXT
          SIZE 37 BY .54 AT ROW 10.46 COL 6 WIDGET-ID 16
     "Despesas Declara‡Æo de Importa‡Æo" VIEW-AS TEXT
          SIZE 37 BY .54 AT ROW 3.88 COL 6 WIDGET-ID 8
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 24.5 COL 1
     RECT-1 AT ROW 4.13 COL 2 WIDGET-ID 6
     RECT-3 AT ROW 10.71 COL 2 WIDGET-ID 14
     RECT-4 AT ROW 4.13 COL 51 WIDGET-ID 18
     RECT-5 AT ROW 18.25 COL 2 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 116.43 BY 27.17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decla-import T "?" NO-UNDO mgcex decla-import
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-decla-import-adic T "?" NO-UNDO mgcex decla-import-adic
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-decla-import-adic-itens T "?" NO-UNDO mgcex decla-import-adic-itens
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-despes-adic T "?" NO-UNDO mgcex despes-adic
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-despes-decla-import T "?" NO-UNDO mgcex despes-decla-import
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 27.17
         WIDTH              = 116.43
         MAX-HEIGHT         = 27.17
         MAX-WIDTH          = 116.43
         VIRTUAL-HEIGHT     = 27.17
         VIRTUAL-WIDTH      = 116.43
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brDespDi dat-di fpage0 */
/* BROWSE-TAB brAdic brDespDi fpage0 */
/* BROWSE-TAB brDespAdic brAdic fpage0 */
/* BROWSE-TAB brItensAdic brDespAdic fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brAdic
/* Query rebuild information for BROWSE brAdic
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-adic NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brAdic */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDespAdic
/* Query rebuild information for BROWSE brDespAdic
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-despes-adic NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brDespAdic */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDespDi
/* Query rebuild information for BROWSE brDespDi
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-despes-decla-import NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brDespDi */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brItensAdic
/* Query rebuild information for BROWSE brItensAdic
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-adic-itens NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brItensAdic */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brAdic
&Scoped-define SELF-NAME brAdic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAdic wWindow
ON VALUE-CHANGED OF brAdic IN FRAME fpage0
DO:
  RUN pi-busca-despesas-itens.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF VALID-HANDLE(h-bocx390) THEN DO:
    DELETE PROCEDURE h-bocx390.
    ASSIGN h-bocx390 = ?.
END.

IF VALID-HANDLE(h-bocx403) THEN DO:
    DELETE PROCEDURE h-bocx403.
    ASSIGN h-bocx403 = ?.
END.

IF VALID-HANDLE(h-bocx402) THEN DO:
    DELETE PROCEDURE h-bocx402.
    ASSIGN h-bocx402 = ?.
END.

IF VALID-HANDLE(h-bocx406) THEN DO:
    DELETE PROCEDURE h-bocx406.
    ASSIGN h-bocx406 = ?.
END.

IF VALID-HANDLE(h-bocx383) THEN DO:
    DELETE PROCEDURE h-bocx383.
    ASSIGN h-bocx383 = ?.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ENABLE brAdic brDespAdic brDespDi brItensAdic WITH FRAME fPage0.

RUN goToKey IN h-bocx383 (INPUT p-num-di-ems,
                          INPUT p-num-seq-retif,
                          INPUT p-cdd-siscomex-dts).
IF RETURN-VALUE = "OK":U THEN DO:
    RUN getRecord IN h-bocx383 (OUTPUT TABLE tt-decla-import).
END.

FOR FIRST tt-decla-import: END.

DISP tt-decla-import.num-di-ems 
     tt-decla-import.dat-di     WITH FRAME fPage0. 

RUN pi-busca-adic.
RUN pi-busca-desp.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT VALID-HANDLE(h-bocx390) THEN
    RUN cxbo\bocx390.p PERSISTENT SET h-bocx390.

IF NOT VALID-HANDLE(h-bocx403) THEN
    RUN cxbo\bocx403.p PERSISTENT SET h-bocx403.

IF NOT VALID-HANDLE(h-bocx402) THEN
    RUN cxbo\bocx402.p PERSISTENT SET h-bocx402.

IF NOT VALID-HANDLE(h-bocx406) THEN
    RUN cxbo\bocx406.p PERSISTENT SET h-bocx406.

IF NOT VALID-HANDLE(h-bocx383) THEN
    RUN cxbo\bocx383.p PERSISTENT SET h-bocx383.

RUN openQueryStatic IN h-bocx390 (INPUT "Main":U).
RUN openQueryStatic IN h-bocx403 (INPUT "Main":U).
RUN openQueryStatic IN h-bocx402 (INPUT "Main":U).
RUN openQueryStatic IN h-bocx406 (INPUT "Main":U).
RUN openQueryStatic IN h-bocx383 (INPUT "Main":U).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-adic wWindow 
PROCEDURE pi-busca-adic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    empty temp-table tt-decla-import-adic.
    
    RUN setConstraintByDI IN h-bocx403 (INPUT tt-decla-import.num-di-ems,
                                        INPUT tt-decla-import.cdd-siscomex-dts).
    RUN openQueryStatic   IN h-bocx403 (INPUT "ByDI":U).
    RUN getBatchRecords   IN h-bocx403 (INPUT ?, 
                                        INPUT ?, 
                                        INPUT 99999, 
                                        OUTPUT iRowsReturned, 
                                        OUTPUT TABLE tt-decla-import-adic).

    {&OPEN-QUERY-brAdic}

    IF CAN-FIND(FIRST tt-decla-import-adic) THEN DO:
        FOR FIRST tt-decla-import-adic:
            RUN pi-busca-despesas-itens.
        END.
    END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-desp wWindow 
PROCEDURE pi-busca-desp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-despes-decla-import.

    RUN setConstraintByDeclaImport IN h-bocx406 (INPUT tt-decla-import.num-di-ems,
                                                 INPUT tt-decla-import.cdd-siscomex-dts).
    RUN openQueryStatic            IN h-bocx406 (INPUT "ByDeclaImport":U).
    RUN getBatchRecords            IN h-bocx406 (INPUT  ?,
                                                 INPUT  ?,
                                                 INPUT  99999,
                                                 OUTPUT iRowsReturned,
                                                 OUTPUT TABLE tt-despes-decla-import).
    
    {&OPEN-QUERY-brDespDi}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-desp-adic wWindow 
PROCEDURE pi-busca-desp-adic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-despes-adic:     DELETE tt-despes-adic.     END.

IF  AVAIL tt-decla-import-adic THEN DO:
    RUN setConstraintByNumDiEms IN h-bocx390 (INPUT tt-decla-import-adic.num-di-ems, INPUT tt-decla-import-adic.num-adic, INPUT tt-decla-import-adic.cdd-siscomex-dts).
    RUN openQueryStatic         IN h-bocx390 (INPUT "ByNumDiEms":U).
    RUN getBatchRecords         IN h-bocx390 (INPUT  ?,
                                              INPUT  ?,
                                              INPUT  99999,
                                              OUTPUT iRowsReturned,
                                              OUTPUT TABLE tt-despes-adic).
   {&OPEN-QUERY-brDespAdic}
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-despesas-itens wWindow 
PROCEDURE pi-busca-despesas-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN pi-busca-desp-adic.
RUN pi-busca-itens.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-itens wWindow 
PROCEDURE pi-busca-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-decla-import-adic-itens:     DELETE tt-decla-import-adic-itens.     END.
    
    RUN setConstraintByAdicao IN h-bocx402 (INPUT tt-decla-import-adic.num-di-ems, INPUT tt-decla-import-adic.num-adic, INPUT tt-decla-import-adic.cdd-siscomex-dts).
    RUN openQueryStatic       IN h-bocx402 (INPUT 'ByAdicao':U).
    RUN getBatchRecords       IN h-bocx402 (INPUT  ?, INPUT  ?, INPUT  99999, OUTPUT iRowsReturned, OUTPUT TABLE tt-decla-import-adic-itens).

    {&OPEN-QUERY-brItensAdic}
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

