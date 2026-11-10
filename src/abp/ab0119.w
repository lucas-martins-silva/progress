&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wFormation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-eqpto NO-UNDO LIKE mab-eqpto
       FIELD r-rowid as rowid.
DEFINE TEMP-TABLE tt-mab-relac-eqpto-sub-sist NO-UNDO LIKE mab-relac-eqpto-sub-sist
       FIELD r-rowid as rowid
       .
DEFINE TEMP-TABLE tt-mab-sub-sist NO-UNDO LIKE mab-sub-sist
       FIELD r-rowid as rowid.
DEFINE BUFFER tt-mab-sub-sist2 FOR mab-sub-sist.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wFormation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0119 2.00.00.004 } /*** "010004" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0119 MAB}
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


/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0119
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE DelTarget      YES
&GLOBAL-DEFINE AddTarget      YES
&GLOBAL-DEFINE DelAllTarget   NO
&GLOBAL-DEFINE AddAllTarget   NO

&GLOBAL-DEFINE UpdateTarget   YES

&GLOBAL-DEFINE NumRowsReturnedSource 100000
&GLOBAL-DEFINE NumRowsReturnedTarget 100000

&GLOBAL-DEFINE ttParent       tt-mab-eqpto
&GLOBAL-DEFINE hDBOParent     hDBOmab-eqpto
&GLOBAL-DEFINE DBOParentTable mab-eqpto

&GLOBAL-DEFINE ttSource       tt-mab-sub-sist
&GLOBAL-DEFINE hDBOSource     hDBOmab-sub-sistt
&GLOBAL-DEFINE DBOSourceTable mab-sub-sist

&GLOBAL-DEFINE ttTarget       tt-mab-relac-eqpto-sub-sist
&GLOBAL-DEFINE hDBOTarget     hDBOmab-relac
&GLOBAL-DEFINE DBOTargetTable mab-relac-eqpto-sub-sist

&GLOBAL-DEFINE page0Fields    tt-mab-eqpto.ep-codigo  ~
                              tt-mab-eqpto.cod-eqpto  ~
                              tt-mab-eqpto.cod-grp-eqpto  ~
                              tt-mab-eqpto.cod-estrut-mec ~
                              tt-mab-eqpto.idi-tip-eqpto

&GLOBAL-DEFINE page1Widgets   cb-ClassificaSource

&GLOBAL-DEFINE SourceBrowse   brSource
&GLOBAL-DEFINE TargetBrowse   brTarget

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE iRowid      AS INTEGER        NO-UNDO.
DEFINE VARIABLE lprimeira   AS LOGICAL INIT YES NO-UNDO.
DEFINE VARIABLE rowSelected AS ROWID          NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSource} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTarget} AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEstrutura AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOGrupo     AS HANDLE NO-UNDO.

DEFINE VARIABLE cLista AS CHARACTER  NO-UNDO.

DEFINE TEMP-TABLE tt-selected-rows NO-UNDO
        FIELD r-row-id        AS ROWID.

DEFINE TEMP-TABLE tt-mab-relac-eqpto-sub-sist2 NO-UNDO LIKE mab-relac-eqpto-sub-sist
    FIELD des-sub-sist LIKE mab-sub-sist.des-sub-sist.

DEFINE TEMP-TABLE tt-mab-sub-sist3 NO-UNDO
    FIELD cod-sub-sist     LIKE mab-sub-sist.cod-sub-sist
    FIELD des-sub-sist     LIKE mab-sub-sist.des-sub-sist    
    FIELD log-controla-uso LIKE mab-sub-sist.log-controla-uso
    FIELD r-rowid          AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Formation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSource

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-mab-sub-sist tt-mab-relac-eqpto-sub-sist ~
mab-sub-sist

/* Definitions for BROWSE brSource                                      */
&Scoped-define FIELDS-IN-QUERY-brSource tt-mab-sub-sist.cod-sub-sist tt-mab-sub-sist.des-sub-sist tt-mab-sub-sist.log-controla-uso   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSource   
&Scoped-define SELF-NAME brSource
&Scoped-define OPEN-QUERY-brSource IF rsClassificaSource = 2 THEN do: /** Quando a classifica‡Æo for igual a "Descri‡Æo" **/     IF fiCampo:SCREEN-VALUE IN FRAME fPage1 = "":U THEN DO:         OPEN QUERY {&SELF-NAME} FOR EACH tt-mab-sub-sist NO-LOCK             BY tt-mab-sub-sist.des-sub-sist.             /*BY tt-mab-sub-sist.cod-sub-sist.*/     END.     ELSE DO:         OPEN QUERY {&SELF-NAME} FOR EACH tt-mab-sub-sist                                    WHERE tt-mab-sub-sist.des-sub-sist >= fiCampo:SCREEN-VALUE IN FRAME fPage1 NO-LOCK             BY tt-mab-sub-sist.des-sub-sist.             /*BY tt-mab-sub-sist.cod-sub-sist.*/     END. END. ELSE DO: /** Quando a classifica‡Æo for igual a "C¢digo" **/     IF fiCampo:SCREEN-VALUE IN FRAME fPage1 = "":U THEN         OPEN QUERY {&SELF-NAME} FOR EACH tt-mab-sub-sist NO-LOCK         BY tt-mab-sub-sist.cod-sub-sist.         /*BY tt-mab-sub-sist.des-sub-sist.*/     ELSE DO:         OPEN QUERY {&SELF-NAME} FOR EACH tt-mab-sub-sist                                     WHERE tt-mab-sub-sist.cod-sub-sist >= fiCampo:SCREEN-VALUE IN FRAME fPage1 NO-LOCK             BY tt-mab-sub-sist.cod-sub-sist.             /*BY tt-mab-sub-sist.des-sub-sist.*/     END. END.
&Scoped-define TABLES-IN-QUERY-brSource tt-mab-sub-sist
&Scoped-define FIRST-TABLE-IN-QUERY-brSource tt-mab-sub-sist


/* Definitions for BROWSE brTarget                                      */
&Scoped-define FIELDS-IN-QUERY-brTarget tt-mab-relac-eqpto-sub-sist.cod-sub-sist mab-sub-sist.des-sub-sist tt-mab-relac-eqpto-sub-sist.val-km-inicial tt-mab-relac-eqpto-sub-sist.dat-ult-troca   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTarget   
&Scoped-define SELF-NAME brTarget
&Scoped-define OPEN-QUERY-brTarget IF rsClassificaTarget = 2 THEN     OPEN QUERY {&SELF-NAME} FOR EACH tt-mab-relac-eqpto-sub-sist NO-LOCK, ~
                                       FIRST mab-sub-sist OF tt-mab-relac-eqpto-sub-sist NO-LOCK                                 BY mab-sub-sist.des-sub-sist.  ELSE     OPEN QUERY {&SELF-NAME} FOR EACH tt-mab-relac-eqpto-sub-sist NO-LOCK, ~
                                       FIRST mab-sub-sist OF tt-mab-relac-eqpto-sub-sist NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTarget tt-mab-relac-eqpto-sub-sist ~
mab-sub-sist
&Scoped-define FIRST-TABLE-IN-QUERY-brTarget tt-mab-relac-eqpto-sub-sist
&Scoped-define SECOND-TABLE-IN-QUERY-brTarget mab-sub-sist


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSource}~
    ~{&OPEN-QUERY-brTarget}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-mab-eqpto.ep-codigo tt-mab-eqpto.cod-eqpto ~
tt-mab-eqpto.cod-grp-eqpto tt-mab-eqpto.cod-estrut-mec ~
tt-mab-eqpto.idi-tip-eqpto 
&Scoped-define ENABLED-TABLES tt-mab-eqpto
&Scoped-define FIRST-ENABLED-TABLE tt-mab-eqpto
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btCopy btQueryJoins btReportsJoins btExit btHelp ~
fModelDesc fDescGrpEqpto fEstrutDesc 
&Scoped-Define DISPLAYED-FIELDS tt-mab-eqpto.ep-codigo ~
tt-mab-eqpto.cod-eqpto tt-mab-eqpto.cod-grp-eqpto ~
tt-mab-eqpto.cod-estrut-mec tt-mab-eqpto.idi-tip-eqpto 
&Scoped-define DISPLAYED-TABLES tt-mab-eqpto
&Scoped-define FIRST-DISPLAYED-TABLE tt-mab-eqpto
&Scoped-Define DISPLAYED-OBJECTS fModelDesc fDescGrpEqpto fEstrutDesc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 brSource 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDesSubSist wFormation 
FUNCTION fnDesSubSist RETURNS CHARACTER
  ( cCodSubSist AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wFormation AS WIDGET-HANDLE NO-UNDO.

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
DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image/im-copy":U
     IMAGE-INSENSITIVE FILE "image/ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25 TOOLTIP "Copiar"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image/im-fir":U
     IMAGE-INSENSITIVE FILE "image/ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image/im-enter":U
     IMAGE-INSENSITIVE FILE "image/ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image/im-las":U
     IMAGE-INSENSITIVE FILE "image/ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image/im-nex":U
     IMAGE-INSENSITIVE FILE "image/ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image/im-pre":U
     IMAGE-INSENSITIVE FILE "image/ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri":U
     IMAGE-INSENSITIVE FILE "image/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE fDescGrpEqpto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE fEstrutDesc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE fModelDesc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 4.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image/im-chck1":U
     LABEL "Button 1" 
     SIZE 5 BY .88.

DEFINE BUTTON btAddTarget 
     IMAGE-UP FILE "image/next-au":U
     IMAGE-INSENSITIVE FILE "image/next-ai":U
     LABEL "" 
     SIZE 7 BY .88 TOOLTIP "Inclui".

DEFINE BUTTON btDelTarget 
     IMAGE-UP FILE "image/prev-au":U
     IMAGE-INSENSITIVE FILE "image/prev-ai":U
     LABEL "" 
     SIZE 7 BY .88 TOOLTIP "Retira".

DEFINE BUTTON btUpdateTarget 
     LABEL "&Alterar" 
     SIZE 10 BY .88.

DEFINE VARIABLE fiCampo AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE rsClassificaSource AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "C¢digo", 1,
"Descri‡Æo", 2
     SIZE 29 BY .88 NO-UNDO.

DEFINE VARIABLE rsClassificaTarget AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "C¢digo", 1,
"Descri‡Æo", 2
     SIZE 29 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32 BY 2.38.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32 BY 2.38.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSource FOR 
      tt-mab-sub-sist SCROLLING.

DEFINE QUERY brTarget FOR 
      tt-mab-relac-eqpto-sub-sist, 
      mab-sub-sist SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSource wFormation _FREEFORM
  QUERY brSource NO-LOCK DISPLAY
      tt-mab-sub-sist.cod-sub-sist FORMAT "x(8)":U
      tt-mab-sub-sist.des-sub-sist FORMAT "x(30)":U
      tt-mab-sub-sist.log-controla-uso FORMAT "Sim/NÆo":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS MULTIPLE SIZE 32 BY 8
         FONT 2.

DEFINE BROWSE brTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTarget wFormation _FREEFORM
  QUERY brTarget NO-LOCK DISPLAY
      tt-mab-relac-eqpto-sub-sist.cod-sub-sist FORMAT "x(8)":U
      mab-sub-sist.des-sub-sist FORMAT "x(30)":U
      tt-mab-relac-eqpto-sub-sist.val-km-inicial FORMAT ">>,>>>,>>9.9":U
      tt-mab-relac-eqpto-sub-sist.dat-ult-troca FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-AUTO-VALIDATE SEPARATORS MULTIPLE SIZE 32 BY 8
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
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-mab-eqpto.ep-codigo AT ROW 3.13 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-mab-eqpto.cod-eqpto AT ROW 3.13 COL 21.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fModelDesc AT ROW 3.13 COL 38.29 COLON-ALIGNED NO-LABEL
     tt-mab-eqpto.cod-grp-eqpto AT ROW 4.13 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fDescGrpEqpto AT ROW 4.13 COL 27 COLON-ALIGNED NO-LABEL
     tt-mab-eqpto.cod-estrut-mec AT ROW 5.13 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fEstrutDesc AT ROW 5.13 COL 27 COLON-ALIGNED NO-LABEL
     tt-mab-eqpto.idi-tip-eqpto AT ROW 6.04 COL 19 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Motorizado", 1,
"NÆo Motorizado", 2
          SIZE 30 BY .88
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 19.33
         FONT 1.

DEFINE FRAME fPage1
     fiCampo AT ROW 1.38 COL 9.43 COLON-ALIGNED
     bt-confirma AT ROW 1.38 COL 28
     rsClassificaTarget AT ROW 2.17 COL 54 NO-LABEL
     rsClassificaSource AT ROW 2.25 COL 3.86 NO-LABEL
     brSource AT ROW 3.75 COL 2
     brTarget AT ROW 3.75 COL 52
     btAddTarget AT ROW 6.92 COL 39.57
     btDelTarget AT ROW 8.04 COL 39.57
     btUpdateTarget AT ROW 11.75 COL 52
     "Classifica‡Æo" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 1.33 COL 55
     RECT-1 AT ROW 1 COL 52
     RECT-2 AT ROW 1 COL 2.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.75
         SIZE 84.43 BY 12.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Formation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mab-eqpto T "?" NO-UNDO mgfro mab-eqpto
      ADDITIONAL-FIELDS:
          FIELD r-rowid as rowid
      END-FIELDS.
      TABLE: tt-mab-relac-eqpto-sub-sist T "?" NO-UNDO mgfro mab-relac-eqpto-sub-sist
      ADDITIONAL-FIELDS:
          FIELD r-rowid as rowid
          
      END-FIELDS.
      TABLE: tt-mab-sub-sist T "?" NO-UNDO mgfro mab-sub-sist
      ADDITIONAL-FIELDS:
          FIELD r-rowid as rowid
      END-FIELDS.
      TABLE: tt-mab-sub-sist2 B "?" ? mgfro mab-sub-sist
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wFormation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 19.33
         WIDTH              = 90
         MAX-HEIGHT         = 27.83
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.83
         VIRTUAL-WIDTH      = 146.29
         MAX-BUTTON         = no
         RESIZE             = no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wFormation 
/* ************************* Included-Libraries *********************** */

{formation/formation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wFormation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSource rsClassificaSource fPage1 */
/* BROWSE-TAB brTarget brSource fPage1 */
/* SETTINGS FOR BROWSE brSource IN FRAME fPage1
   1                                                                    */
/* SETTINGS FOR FILL-IN fiCampo IN FRAME fPage1
   DEF-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wFormation)
THEN wFormation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSource
/* Query rebuild information for BROWSE brSource
     _START_FREEFORM
IF rsClassificaSource = 2 THEN do: /** Quando a classifica‡Æo for igual a "Descri‡Æo" **/
    IF fiCampo:SCREEN-VALUE IN FRAME fPage1 = "":U THEN DO:
        OPEN QUERY {&SELF-NAME} FOR EACH tt-mab-sub-sist NO-LOCK
            BY tt-mab-sub-sist.des-sub-sist.
            /*BY tt-mab-sub-sist.cod-sub-sist.*/
    END.
    ELSE DO:
        OPEN QUERY {&SELF-NAME} FOR EACH tt-mab-sub-sist
                                   WHERE tt-mab-sub-sist.des-sub-sist >= fiCampo:SCREEN-VALUE IN FRAME fPage1 NO-LOCK
            BY tt-mab-sub-sist.des-sub-sist.
            /*BY tt-mab-sub-sist.cod-sub-sist.*/
    END.
END.
ELSE DO: /** Quando a classifica‡Æo for igual a "C¢digo" **/
    IF fiCampo:SCREEN-VALUE IN FRAME fPage1 = "":U THEN
        OPEN QUERY {&SELF-NAME} FOR EACH tt-mab-sub-sist NO-LOCK
        BY tt-mab-sub-sist.cod-sub-sist.
        /*BY tt-mab-sub-sist.des-sub-sist.*/
    ELSE DO:
        OPEN QUERY {&SELF-NAME} FOR EACH tt-mab-sub-sist
                                    WHERE tt-mab-sub-sist.cod-sub-sist >= fiCampo:SCREEN-VALUE IN FRAME fPage1 NO-LOCK
            BY tt-mab-sub-sist.cod-sub-sist.
            /*BY tt-mab-sub-sist.des-sub-sist.*/
    END.
END.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSource */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTarget
/* Query rebuild information for BROWSE brTarget
     _START_FREEFORM
IF rsClassificaTarget = 2 THEN
    OPEN QUERY {&SELF-NAME} FOR EACH tt-mab-relac-eqpto-sub-sist NO-LOCK,
                                FIRST mab-sub-sist OF tt-mab-relac-eqpto-sub-sist NO-LOCK
                                BY mab-sub-sist.des-sub-sist.

ELSE
    OPEN QUERY {&SELF-NAME} FOR EACH tt-mab-relac-eqpto-sub-sist NO-LOCK,
                                FIRST mab-sub-sist OF tt-mab-relac-eqpto-sub-sist NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brTarget */
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

&Scoped-define SELF-NAME wFormation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wFormation wFormation
ON END-ERROR OF wFormation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wFormation wFormation
ON WINDOW-CLOSE OF wFormation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma wFormation
ON CHOOSE OF bt-confirma IN FRAME fPage1 /* Button 1 */
DO:
 ASSIGN fiCampo.
 {&OPEN-QUERY-brSource}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddTarget wFormation
ON CHOOSE OF btAddTarget IN FRAME fPage1
DO:
    DEFINE VARIABLE cont AS INTEGER NO-UNDO.
    
    FOR EACH tt-selected-rows EXCLUSIVE-LOCK:
        DELETE tt-selected-rows.
    END.

    DO cont = 1 TO brsource:NUM-SELECTED-ROWS:
       IF brsource:FETCH-SELECTED-ROW(cont) THEN DO:
           CREATE tt-selected-rows.
           ASSIGN tt-selected-rows.r-row-id = {&ttSource}.r-rowid .
       END.
    END.

    FOR EACH tt-selected-rows NO-LOCK:
        
        FIND FIRST {&ttSource}
            WHERE {&ttSource}.r-rowid EQ tt-selected-rows.r-row-id NO-LOCK NO-ERROR.

        IF AVAILABLE {&ttSource} THEN DO:
            {formation/addtarget.i}

        END.
    END.

    EMPTY TEMP-TABLE tt-selected-rows.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wFormation
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
DO:
   assign {&window-name}:sensitive = NO.
   /** C¢pia **/
   run abp/ab0119b.w (INPUT {&ttParent}.ep-codigo, 
                      INPUT {&ttParent}.cod-eqpto, 
                      OUTPUT {&ttParent}.r-rowid ).
   assign {&window-name}:sensitive = YES.
   RUN repositionRecord IN THIS-PROCEDURE (INPUT {&ttParent}.r-rowid).
   apply "ENTRY":U to btCopy in frame fPage0.  
   ASSIGN btFirst:SENSITIVE IN FRAME fPage0 = YES
          btNext:SENSITIVE IN FRAME fPage0 = YES
          btPrev:SENSITIVE IN FRAME fPage0 = YES
          btLast:SENSITIVE IN FRAME fPage0 = YES
          btGoTo:SENSITIVE IN FRAME fPage0 = YES
          btSearch:SENSITIVE IN FRAME fPage0 = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDelTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelTarget wFormation
ON CHOOSE OF btDelTarget IN FRAME fPage1
DO:
    DEFINE VARIABLE cont AS INTEGER NO-UNDO.
    brtarget:REFRESHABLE = NO.
    DO cont = brtarget:NUM-SELECTED-ROWS  TO 1 BY -1 :

       IF brtarget:FETCH-SELECTED-ROW(cont) THEN DO:
           {formation/deltarget.i}
           /*CREATE tt-selected-rows.
          ASSIGN tt-selected-rows.r-row-id = {&ttTarget}.r-rowid .*/
       END.
    END.
/*
    FOR EACH tt-selected-rows NO-LOCK BY r-row-id DESC :
       FIND FIRST {&ttTarget}
            WHERE {&ttTarget}.r-rowid EQ tt-selected-rows.r-row-id NO-LOCK NO-ERROR.
       IF AVAILABLE {&ttTarget} THEN DO:
         {formation/deltarget.i}
       END.
    END.
  */
EMPTY TEMP-TABLE tt-selected-rows.
 brtarget:REFRESHABLE = YES.
RUN openQueries in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wFormation
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wFormation
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wFormation
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wFormation
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wFormation
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wFormation
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wFormation
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wFormation
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wFormation
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wFormation
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="frzoom/z01fr007.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateTarget wFormation
ON CHOOSE OF btUpdateTarget IN FRAME fPage1 /* Alterar */
DO:
    {formation/updatetarget.i &ProgramTarget="abp/ab0119a.w"}
    
    WAIT-FOR "CLOSE":U OF hTargetProgram.
    
    FOR FIRST {&ttTarget} WHERE {&ttTarget}.r-rowid = rTarget NO-LOCK:
        REPOSITION brTarget TO ROWID(ROWID({&ttTarget})).
        brTarget:SELECT-FOCUSED-ROW().
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME tt-mab-eqpto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-eqpto.cod-eqpto wFormation
ON LEAVE OF tt-mab-eqpto.cod-eqpto IN FRAME fPage0 /* cod-eqpto */
DO:
        {method/referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="tt-mab-eqpto.cod-model"
        &FieldName1="des-model"
        &FieldScreen1="fModelDesc"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mab-eqpto.cod-estrut-mec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-eqpto.cod-estrut-mec wFormation
ON LEAVE OF tt-mab-eqpto.cod-estrut-mec IN FRAME fPage0 /* Estrutura Mecƒnica */
DO:
        {method/referenceFields.i
        &HandleDBOLeave="hDBOEstrutura"
        &KeyValue1="tt-mab-eqpto.cod-estrut-mec:screen-value in frame fPage0"
        &FieldName1="des-estrut-mec"
        &FieldScreen1="fEstrutDesc"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mab-eqpto.cod-grp-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-eqpto.cod-grp-eqpto wFormation
ON LEAVE OF tt-mab-eqpto.cod-grp-eqpto IN FRAME fPage0 /* Grupo Equipamento */
DO:
        {method/referenceFields.i
        &HandleDBOLeave="hDBOGrupo"
        &KeyValue1="tt-mab-eqpto.cod-grp-eqpto"
        &FieldName1="des-grp-eqpto"
        &FieldScreen1="fDescGrpEqpto"
        &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fiCampo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCampo wFormation
ON LEAVE OF fiCampo IN FRAME fPage1 /* fiCampo */
DO:
  ASSIGN fiCampo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsClassificaSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsClassificaSource wFormation
ON VALUE-CHANGED OF rsClassificaSource IN FRAME fPage1
DO:
  ASSIGN rsClassificaSource.
  
  IF INPUT FRAME fPage1 rsClassificaSource = 1 THEN DO:
      {utp/ut-liter.i C¢digo * }
      ASSIGN fiCampo:LABEL IN FRAME fPage1 = RETURN-VALUE.
      RUN OpenQueryStatic IN {&hDBOSource} (INPUT "Main":U).
  END.
  ELSE DO:
      {utp/ut-liter.i Descri‡Æo * }
      ASSIGN fiCampo:LABEL IN FRAME fPage1 = RETURN-VALUE.
      RUN OpenQueryStatic IN {&hDBOSource} (INPUT "Descricao":U).
  END.
  
  {&OPEN-QUERY-brSource}
  brSource:MOVE-COLUMN(1,2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsClassificaTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsClassificaTarget wFormation
ON VALUE-CHANGED OF rsClassificaTarget IN FRAME fPage1
DO:
  ASSIGN rsClassificaTarget.
  
  IF rsClassificaTarget = 1 THEN
      RUN OpenQueryStatic IN {&hDBOTarget} (INPUT "Equipamento":U).
  ELSE
      RUN OpenQueryStatic IN {&hDBOTarget} (INPUT "Descricao":U).
  
  {&OPEN-QUERY-brTarget}
  brTarget:MOVE-COLUMN(1,2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSource
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wFormation 


/* ***************************  Main Block  *************************** */

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{formation/mainblock.i}


tt-mab-eqpto.ep-codigo:LABEL = "Equipamento".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wFormation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
APPLY "leave":U TO tt-mab-eqpto.cod-eqpto      IN FRAME fPage0.
APPLY "leave":U TO tt-mab-eqpto.cod-grp-eqpto  IN FRAME fPage0.
APPLY "leave":U TO tt-mab-eqpto.cod-estrut-mec IN FRAME fPage0.

IF AVAIL tt-mab-eqpto THEN
    ASSIGN btCopy:SENSITIVE = YES.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wFormation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{utp/ut-liter.i C¢digo * }
ASSIGN fiCampo:LABEL IN FRAME fPage1                 = TRIM(RETURN-VALUE).
ASSIGN fiCampo:SENSITIVE IN FRAME fPage1             = YES
       bt-Confirma:SENSITIVE IN FRAME fPage1         = YES
       rsClassificaTarget:SENSITIVE IN FRAME fPage1  = YES
       rsClassificaSource:SENSITIVE IN FRAME fPage1  = YES.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wFormation 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
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
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE cep-codigo     LIKE {&ttParent}.ep-codigo   NO-UNDO.
    DEFINE VARIABLE ccod-eqpto     LIKE {&ttParent}.cod-eqpto     NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        cep-codigo      AT ROW 1.21 COL 17.72 COLON-ALIGNED
        ccod-eqpto        AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i V _Para_Equipamento *}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cep-codigo ccod-eqpto.
        
        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT cep-codigo,
                                      input ccod-eqpto).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i "Equipamento"}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cep-codigo  
           ccod-eqpto    
           btGoToOK 
           btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wFormation 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
        /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Estrutura ---*/
    IF NOT VALID-HANDLE(hDBOEstrutura) OR
       hDBOEstrutura:TYPE <> "PROCEDURE":U OR
       hDBOEstrutura:FILE-NAME <> "frbo/bofr009.p":U THEN DO:
        run frbo/bofr009.p persistent set  hDBOEstrutura.
    END.
    
    RUN openQueryStatic IN hDBOEstrutura (INPUT "Main":U) NO-ERROR.
    
    /*--- DBO Grupo Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOGrupo) OR
       hDBOGrupo:TYPE <> "PROCEDURE":U OR
       hDBOGrupo:FILE-NAME <> "frbo/bofr011.p":U THEN DO:
        run frbo/bofr011.p persistent set  hDBOGrupo.
    END.
    
    RUN openQueryStatic IN hDBOGrupo (INPUT "Main":U) NO-ERROR.
    
    
    /*:T--- Verifica se o DBO da tabela Pai j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
        RUN frbo/bofr007.p PERSISTENT SET {&hDBOParent}.
    END.
    
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U).
    
    /*:T--- Verifica se o DBO da tabela Origem j  est  inicializado ---*/
    
    IF NOT VALID-HANDLE({&hDBOSource}) OR
       {&hDBOSource}:TYPE <> "PROCEDURE":U OR
       {&hDBOSource}:FILE-NAME <> "frbo/bofr025.p":U THEN DO:
        RUN frbo/bofr025.p  PERSISTENT SET {&hDBOSource}.
    END.

                
    /*:T--- Verifica se o DBO da tabela Forma‡Æo j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTarget}) OR
       {&hDBOTarget}:TYPE <> "PROCEDURE":U OR
       {&hDBOTarget}:FILE-NAME <> "frbo/bofr128a.p":U THEN DO:
        RUN frbo/bofr128a.p PERSISTENT SET {&hDBOTarget}.
    END.    
    
    RUN setProgramaChamador IN {&hDBOTarget}  (INPUT "ab0119.w").
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries wFormation 
PROCEDURE openQueries :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
/* assign rRepositionTarget = ?.  */

    {formation/openqueriestarget.i &Parent="Equipamento"
                                   &Query="Equipamento"}   
                                   
    {formation/openqueriessource.i &Query="Main"
                                   &OpenAlways="NO"}
/*     RUN openQuerySource.  */

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySource wFormation 
PROCEDURE openQuerySource :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* run setConstraintMain in {&hDBOSource} no-error.                                    */
/* run openQueryStatic in {&hDBOSource} (INPUT "Main":U) no-error.                     */
/* run getBatchRecords in {&hDBOSource} (input  ?,                                     */
/*                                       input  no,                                    */
/*                                       input  9999,                                  */
/*                                       output iRowid,                                */
/*                                       output table {&ttSource}).                    */
/* FOR EACH {&ttSource} NO-LOCK:                                                       */
/*     IF CAN-FIND(FIRST {&ttTarget} WHERE                                             */
/*                       {&ttTarget}.ep-codigo = {&ttParent}.ep-codigo AND             */
/*                       {&ttTarget}.cod-eqpto = {&ttParent}.cod-eqpto AND             */
/*                       {&ttTarget}.cod-sub-sist = {&ttSource}.cod-sub-sist) then do: */
/*         DELETE  {&ttSource}.                                                        */
/*     END.                                                                            */
/* END.                                                                                */
/*                                                                                     */
/* {&OPEN-QUERY-brSource}                                                              */
/*                                                                                     */
/* APPLY "VALUE-CHANGED":U TO BROWSE {&SourceBrowse}.                                  */
/*                                                                                     */
/* /*--- Seta estado dos bot„es relacionados ao browse da pÿgina 1 ---*/               */
/* IF AVAILABLE {&ttSource} THEN                                                       */
/*     ASSIGN btAddTarget:SENSITIVE IN FRAME fPage1 = YES.                             */
/* ELSE                                                                                */
/*     ASSIGN btAddTarget:SENSITIVE IN FRAME fPage1 = NO.                              */

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wFormation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela forma‡Æo ({&ttTarget}) com base 
               nos campos da tabela pai ({&ttParent}) e tabela origem ({&ttSource})
  Parameters:  
------------------------------------------------------------------------------*/
ASSIGN  {&ttTarget}.ep-codigo          = {&ttParent}.ep-codigo
        {&ttTarget}.cod-eqpto          = {&ttParent}.cod-eqpto
        {&ttTarget}.cod-sub-sist       = {&ttSource}.cod-sub-sist
        {&ttTarget}.dat-cadastro       = TODAY
        {&ttTarget}.qti-max            = 1
        {&ttTarget}.val-km-inicial     = 0
        {&ttTarget}.dat-ult-troca      = {&ttParent}.dat-inicial
        {&ttTarget}.val-km-hora-gartia = 0
        {&ttTarget}.num-dias-gartia    = 0
        {&ttTarget}.val-uso-estimad    = 0
        {&ttTarget}.num-dias-estimad   = 0
        {&ttTarget}.val-km-aviso       = 0
        {&ttTarget}.num-dias-antecip   = 0.
   
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDesSubSist wFormation 
FUNCTION fnDesSubSist RETURNS CHARACTER
  ( cCodSubSist AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE returnValue AS CHARACTER  NO-UNDO.
  
IF NOT AVAIL mab-sub-sist OR mab-sub-sist.cod-sub-sist <> cCodSubSist THEN DO:
    FOR FIRST mab-sub-sist 
        WHERE mab-sub-sist.cod-sub-sist = cCodSubSist NO-LOCK:
    END.
END.
IF AVAIL mab-sub-sist THEN
    ASSIGN returnValue = mab-sub-sist.des-sub-sist.
  
  RETURN returnValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wFormation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF VALID-HANDLE ({&hDBOSource}) THEN
   DELETE PROCEDURE {&hDBOSource}.
    
IF VALID-HANDLE (hDBOModelo) THEN
   DELETE PROCEDURE hDBOModelo.
    
IF VALID-HANDLE (hDBOEstrutura) THEN
   DELETE PROCEDURE hDBOEstrutura.  

IF VALID-HANDLE (hDBOGrupo) THEN
   DELETE PROCEDURE hDBOGrupo.







END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
