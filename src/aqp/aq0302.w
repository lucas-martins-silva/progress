&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-alter-produt-carg NO-UNDO LIKE alter-produt-carg
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-carg-rural NO-UNDO LIKE carg-rural
       FIELD r-rowid AS ROWID
       .
DEFINE TEMP-TABLE tt-produt-carg NO-UNDO LIKE produt-carg
       FIELD r-rowid AS ROWID      
       .
DEFINE TEMP-TABLE ttProdutCargAux NO-UNDO LIKE produt-carg
       FIELD r-rowid AS ROWID.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/


{include/i-prgvrs.i AQ0302 2.00.00.032 } /*** 010032 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0302 MAQ}
&ENDIF 

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          AQ0302
&GLOBAL-DEFINE Version        2.00.00.030

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Ptos Coleta

&GLOBAL-DEFINE First            NO
&GLOBAL-DEFINE Prev             NO
&GLOBAL-DEFINE Next             NO
&GLOBAL-DEFINE Last             NO
&GLOBAL-DEFINE GoTo             NO
&GLOBAL-DEFINE Search           NO

&GLOBAL-DEFINE AddParent        NO
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     NO

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       NO
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE ttParent         tt-carg-rural
&GLOBAL-DEFINE hDBOParent       h-boin00961
&GLOBAL-DEFINE DBOParentTable   carg-rural
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           tt-produt-carg
&GLOBAL-DEFINE hDBOSon1         h-boin00965
&GLOBAL-DEFINE DBOSon1Table     produt-carg
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE page0Fields      tt-carg-rural.num-carg tt-carg-rural.cod-carga ~
                                tt-carg-rural.cod-placa tt-carg-rural.cod-estabel ~
                                tt-carg-rural.it-codigo tt-carg-rural.cod-rota 

&GLOBAL-DEFINE page1Fields      fi-qtd-aferid
&GLOBAL-DEFINE page1Browse      brSon1

&GLOBAL-DEFINE page1Widgets     d-qtd-coleta
   
/* Shared Variable Definitions ---                                      */
DEFINE NEW SHARED VARIABLE v_cdn-identif AS INTEGER NO-UNDO.   
DEFINE NEW SHARED VARIABLE v_l-fraciona   AS LOGICAL           NO-UNDO.
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER pNumCarg AS INTEGER NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-texto                  AS CHARACTER FORMAT "X(2000)" NO-UNDO.
DEFINE VARIABLE l-log-pto-coleta-coletiv AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE i-cdn-compart-old        AS INTEGER                    NO-UNDO.
DEFINE VARIABLE d-qtd-tot-brw            AS DECIMAL                    NO-UNDO.
DEFINE VARIABLE i-linha                  AS INTEGER INITIAL 0          NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad107na   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin172na   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00975   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00967   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00966   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin01004   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin01009   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00982   AS HANDLE NO-UNDO.

{inbo/boin00965.i tt-produt-carg-aux}

DEFINE VARIABLE h-boad098     AS HANDLE NO-UNDO.

DEFINE BUFFER bf-tt-produt-carg FOR  tt-produt-carg.

DEFINE VARIABLE l-list AS LOGICAL INITIAL ? NO-UNDO.

DEFINE VARIABLE i-motivo-nao-coleta AS INTEGER NO-UNDO.

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
&Scoped-define INTERNAL-TABLES tt-produt-carg

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-produt-carg.cod-pto-coleta ~
tt-produt-carg.cdn-repos fn-produtor(tt-produt-carg.cdn-produt-rural) ~
tt-produt-carg.cdn-compart ~
fn-qtd-total(tt-produt-carg.num-carg, tt-produt-carg.cod-pto-coleta, tt-produt-carg.cdn-compart, tt-produt-carg.cdn-repos) @  d-qtd-tot-brw ~
tt-produt-carg.val-temperat tt-produt-carg.cod-amostra ~
tt-produt-carg.cod-lacre 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-produt-carg NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-produt-carg NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-produt-carg
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-produt-carg


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-carg-rural.num-carg ~
tt-carg-rural.cod-carga tt-carg-rural.cod-placa tt-carg-rural.cod-estabel ~
tt-carg-rural.it-codigo tt-carg-rural.cod-rota 
&Scoped-define ENABLED-TABLES tt-carg-rural
&Scoped-define FIRST-ENABLED-TABLE tt-carg-rural
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btQueryJoins ~
btReportsJoins btExit btHelp c-nome c-desc-item c-desc-rota 
&Scoped-Define DISPLAYED-FIELDS tt-carg-rural.num-carg ~
tt-carg-rural.cod-carga tt-carg-rural.cod-placa tt-carg-rural.cod-estabel ~
tt-carg-rural.it-codigo tt-carg-rural.cod-rota 
&Scoped-define DISPLAYED-TABLES tt-carg-rural
&Scoped-define FIRST-DISPLAYED-TABLE tt-carg-rural
&Scoped-Define DISPLAYED-OBJECTS c-nome c-desc-item c-desc-rota 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-idi-nao-coleta wMasterDetail 
FUNCTION fn-idi-nao-coleta RETURNS CHARACTER
  ( i-idi-nao-coleta AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-produtor wMasterDetail 
FUNCTION fn-produtor RETURNS CHARACTER
  (iProdutRural AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-qtd-total wMasterDetail 
FUNCTION fn-qtd-total RETURNS DECIMAL
  (iNumCarg AS INTEGER, cPtoColeta AS CHARACTER, pCdnCompart AS INTEGER,  pCdnRepos AS INTEGER ) FORWARD.

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

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-rota AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 134 BY 2.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 134 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-can AUTO-END-KEY 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Ca&n" 
     SIZE 4 BY 1.25 TOOLTIP "Cancelar".

DEFINE BUTTON bt-obs 
     IMAGE-UP FILE "image/im-respl.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-respl.bmp":U
     LABEL "&Obs" 
     SIZE 4.86 BY 1.42 TOOLTIP "Observa‡äes".

DEFINE BUTTON bt-sav 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sav.bmp":U
     LABEL "&Sav" 
     SIZE 4 BY 1.25 TOOLTIP "Salvar".

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1 TOOLTIP "Incluir".

DEFINE BUTTON btColetiva 
     LABEL "Coletiva" 
     SIZE 10 BY 1 TOOLTIP "Coletiva".

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1 TOOLTIP "Eliminar".

DEFINE VARIABLE cb-nao-coleta AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "         0" 
     DROP-DOWN-LIST
     SIZE 27.86 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-amostra AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-lacre AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-lbl-idi-nao-coleta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .88 NO-UNDO.

DEFINE VARIABLE d-qtd-coleta AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-qtd-difer AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Diferen‡a" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-qtd-infor AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtd Informada" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-temperat AS DECIMAL FORMAT "->,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cdn-naocfedade AS CHARACTER FORMAT "X(09)" 
     LABEL "NC" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qtd-aferid AS DECIMAL FORMAT ">>>>,>>>,>>9.9999" INITIAL 0 
     LABEL "Qtd Aferida" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE i-cdn-compart AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 10.5.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 2.67.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-produt-carg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      tt-produt-carg.cod-pto-coleta FORMAT "x(12)":U WIDTH 14.43
      tt-produt-carg.cdn-repos FORMAT ">>>,>>9":U
      fn-produtor(tt-produt-carg.cdn-produt-rural) COLUMN-LABEL "Produtor" FORMAT "x(80)":U
            WIDTH 16
      tt-produt-carg.cdn-compart COLUMN-LABEL "Comp." FORMAT ">>9":U
            WIDTH 5
      fn-qtd-total(tt-produt-carg.num-carg, tt-produt-carg.cod-pto-coleta, tt-produt-carg.cdn-compart, tt-produt-carg.cdn-repos) @  d-qtd-tot-brw COLUMN-LABEL "Quantidade" FORMAT ">>>>,>>>,>>9.9999":U
            WIDTH 13.29
      tt-produt-carg.val-temperat FORMAT "->,>>9.9999":U WIDTH 11.43
      tt-produt-carg.cod-amostra FORMAT "x(20)":U
      tt-produt-carg.cod-lacre FORMAT "X(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 85.57 BY 10.5
         FONT 2 NO-EMPTY-SPACE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-carg-rural.num-carg AT ROW 3 COL 10 COLON-ALIGNED
          LABEL "Carga"
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-carg-rural.cod-carga AT ROW 3 COL 31 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-carg-rural.cod-placa AT ROW 3 COL 51 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-carg-rural.cod-estabel AT ROW 3 COL 78 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-nome AT ROW 3 COL 88.14 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     tt-carg-rural.it-codigo AT ROW 4 COL 10 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     c-desc-item AT ROW 4 COL 28.14 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     tt-carg-rural.cod-rota AT ROW 4 COL 78 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-desc-rota AT ROW 4 COL 90.72 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 134 BY 18.17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.5 COL 2
     c-lbl-idi-nao-coleta AT ROW 9.04 COL 115 COLON-ALIGNED
     d-qtd-coleta AT ROW 2.04 COL 101 COLON-ALIGNED WIDGET-ID 34
     d-val-temperat AT ROW 3.04 COL 101 COLON-ALIGNED WIDGET-ID 6
     i-cdn-compart AT ROW 4.04 COL 101 COLON-ALIGNED WIDGET-ID 8
     c-cod-amostra AT ROW 5.04 COL 101 COLON-ALIGNED
     c-cod-lacre AT ROW 6.04 COL 101 COLON-ALIGNED
     cb-nao-coleta AT ROW 8.04 COL 97 COLON-ALIGNED
     bt-obs AT ROW 5.58 COL 122 WIDGET-ID 32
     bt-can AT ROW 10.5 COL 120 WIDGET-ID 28
     bt-sav AT ROW 10.5 COL 124 WIDGET-ID 30
     fi-qtd-aferid AT ROW 12.13 COL 10 COLON-ALIGNED WIDGET-ID 16
     d-qtd-infor AT ROW 12.13 COL 40.57 COLON-ALIGNED WIDGET-ID 18
     d-qtd-difer AT ROW 12.13 COL 68 COLON-ALIGNED WIDGET-ID 20
     btAddSon1 AT ROW 12.08 COL 88.86
     btDeleteSon1 AT ROW 12.08 COL 98.86
     btColetiva AT ROW 12.08 COL 119 WIDGET-ID 22
     fi-cdn-naocfedade AT ROW 9.04 COL 97 COLON-ALIGNED HELP
          "C¢digo NÆo-conformidade"
     "NÆo Coleta" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 7.33 COL 92
     RECT-12 AT ROW 1.5 COL 89 WIDGET-ID 2
     RECT-14 AT ROW 7.63 COL 91 WIDGET-ID 38
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.75
         SIZE 129.72 BY 12.25
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-alter-produt-carg T "?" NO-UNDO movind alter-produt-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-carg-rural T "?" NO-UNDO movind carg-rural
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
          
      END-FIELDS.
      TABLE: tt-produt-carg T "?" NO-UNDO movind produt-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
          
          
      END-FIELDS.
      TABLE: ttProdutCargAux T "?" NO-UNDO movind produt-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
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
         HEIGHT             = 18.29
         WIDTH              = 134
         MAX-HEIGHT         = 38.63
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.63
         VIRTUAL-WIDTH      = 182.86
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
/* SETTINGS FOR FILL-IN tt-carg-rural.num-carg IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* BROWSE-TAB brSon1 1 fPage1 */
/* SETTINGS FOR BUTTON bt-can IN FRAME fPage1
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.tt-produt-carg"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-produt-carg.cod-pto-coleta
"tt-produt-carg.cod-pto-coleta" ? ? "character" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.tt-produt-carg.cdn-repos
     _FldNameList[3]   > "_<CALC>"
"fn-produtor(tt-produt-carg.cdn-produt-rural)" "Produtor" ? ? ? ? ? ? ? ? no "Produtor Rural" no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-produt-carg.cdn-compart
"tt-produt-carg.cdn-compart" "Comp." ? "integer" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fn-qtd-total(tt-produt-carg.num-carg, tt-produt-carg.cod-pto-coleta, tt-produt-carg.cdn-compart, tt-produt-carg.cdn-repos) @  d-qtd-tot-brw" "Quantidade" ">>>>,>>>,>>9.9999" ? ? ? ? ? ? ? no ? no no "13.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-produt-carg.val-temperat
"tt-produt-carg.val-temperat" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.tt-produt-carg.cod-amostra
     _FldNameList[8]   = Temp-Tables.tt-produt-carg.cod-lacre
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
ON ROW-DISPLAY OF brSon1 IN FRAME fPage1
DO:    
    ASSIGN d-qtd-tot-brw:FORMAT IN BROWSE brSon1 = IF v_l-fraciona THEN "->>>,>>>,>>9.9999":U ELSE "->>>,>>>,>>9":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON VALUE-CHANGED OF brSon1 IN FRAME fPage1
DO:
    /* Logica trigger no main-block */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-can
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-can wMasterDetail
ON CHOOSE OF bt-can IN FRAME fPage1 /* Can */
DO:
   IF AVAILABLE {&ttSon1} THEN DO:            

        RUN getQtdTotalPtoColeta IN {&hDBOSon1} (INPUT {&ttSon1}.num-carg, 
                                                 INPUT {&ttSon1}.cod-pto-coleta, 
                                                 INPUT {&ttSon1}.cdn-compart,
                                                 INPUT {&ttSon1}.cdn-repos,
                                                 OUTPUT d-qtd-coleta).

        APPLY 'leave':U TO d-qtd-coleta IN FRAME fPage1 .
        ASSIGN d-qtd-coleta:SCREEN-VALUE            IN FRAME fPage1 = STRING(d-qtd-coleta) 
               d-val-temperat:SCREEN-VALUE          IN FRAME fPage1 = STRING({&ttSon1}.val-temperat)
               i-cdn-compart:SCREEN-VALUE           IN FRAME fPage1 = STRING({&ttSon1}.cdn-compart)
               c-cod-lacre:SCREEN-VALUE             IN FRAME fPage1 = {&ttSon1}.cod-lacre
               cb-nao-coleta:SCREEN-VALUE           IN FRAME fPage1 = STRING({&ttSon1}.cdn-motiv-nao-coleta).

        

    END.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-obs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-obs wMasterDetail
ON CHOOSE OF bt-obs IN FRAME fPage1 /* Obs */
DO:    
    GET CURRENT brSon1 NO-LOCK.    
    IF AVAILABLE {&ttSon1} THEN DO:
        ASSIGN c-texto = {&ttSon1}.des-obs.
              
        RUN aqp/aq0302b.w (INPUT-OUTPUT c-texto).
        IF c-texto <> "" THEN DO:
            RUN atualizarObservacao IN {&hDBOSon1} (INPUT {&ttSon1}.cdn-identif, INPUT c-texto).
            IF RETURN-VALUE = "OK":U THEN
                ASSIGN {&ttSon1}.des-obs = c-texto.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sav
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sav wMasterDetail
ON CHOOSE OF bt-sav IN FRAME fPage1 /* Sav */
DO:
    DEFINE VARIABLE cParams AS CHARACTER NO-UNDO.

    IF INPUT FRAME fPage1 i-cdn-compart = 0 
    AND i-motivo-nao-coleta = 0
    AND INPUT FRAME fPage1 d-qtd-coleta > 0 THEN DO:
        {utp/ut-liter.i Compartimento}
        RUN utp/ut-msgs.p(INPUT 'SHOW':U,
                          INPUT 36,
                          INPUT RETURN-VALUE).
        APPLY "ENTRY":U TO i-cdn-compart IN FRAME fPage1.
        RETURN NO-APPLY.    
    END.
    ELSE IF INPUT FRAME fPage1 i-cdn-compart >  tt-carg-rural.qti-comptmento THEN DO:
        ASSIGN cParams = STRING(tt-carg-rural.num-carg) + "~~" +  STRING(tt-carg-rural.qti-comptmento).
        RUN utp/ut-msgs.p(INPUT 'SHOW':U,
                          INPUT 54655,
                          INPUT cParams).
        APPLY "ENTRY":U TO i-cdn-compart IN FRAME fPage1.
        RETURN NO-APPLY.
    END.
        
    GET CURRENT brSon1 NO-LOCK.
 
    ASSIGN v_cdn-identif = tt-produt-carg.cdn-identif WHEN AVAILABLE tt-produt-carg.       

    RUN pi-save IN THIS-PROCEDURE.

    IF RETURN-VALUE <> "OK":U THEN RETURN "NOK":U.

    RUN openQueriesSon IN THIS-PROCEDURE.
        
    FIND FIRST tt-produt-carg NO-LOCK 
         WHERE tt-produt-carg.cdn-identif = v_cdn-identif NO-ERROR.

    FIND NEXT tt-produt-carg NO-LOCK NO-ERROR.

    IF AVAILABLE tt-produt-carg THEN
       REPOSITION brSon1 TO ROWID ROWID(tt-produt-carg) NO-ERROR.
    ELSE
        FIND FIRST tt-produt-carg NO-LOCK 
             WHERE tt-produt-carg.cdn-identif = v_cdn-identif NO-ERROR.

    APPLY "ENTRY":U TO d-qtd-coleta IN FRAME fPage1.
    APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO: 
    DEFINE VARIABLE h-prog-desp AS HANDLE NO-UNDO.
    
    ASSIGN v_cdn-identif = tt-produt-carg.cdn-identif WHEN AVAILABLE tt-produt-carg.
    SESSION:SET-WAIT-STATE("general":U).

    RUN aqp/aq0302a.w PERSISTENT SET h-prog-desp (INPUT ?,
                                                  INPUT {&ttParent}.r-rowid,
                                                  INPUT "ADD":U,
                                                  INPUT THIS-PROCEDURE,
                                                  INPUT 1).

    IF VALID-HANDLE(h-prog-desp) THEN DO:
        RUN initializeInterface IN h-prog-desp.
         
        SESSION:SET-WAIT-STATE("":U).

        WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.
        RUN initializeDBOs IN THIS-PROCEDURE.
        FIND FIRST {&ttParent} NO-ERROR.
    END.               
                           
    RUN openQueriesSon IN THIS-PROCEDURE.  

    IF v_cdn-identif = ? THEN
        FIND FIRST tt-produt-carg NO-ERROR.
    ELSE     
        FIND FIRST tt-produt-carg 
             WHERE tt-produt-carg.cdn-identif = v_cdn-identif NO-ERROR.
 
    IF AVAILABLE tt-produt-carg THEN DO:
       REPOSITION brSon1 TO ROWID ROWID(tt-produt-carg) NO-ERROR.
        APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1. 
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btColetiva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btColetiva wMasterDetail
ON CHOOSE OF btColetiva IN FRAME fPage1 /* Coletiva */
DO:
    DEFINE VARIABLE h-prog-desp AS HANDLE NO-UNDO.

    DEFINE VARIABLE i-cdn-identif AS INTEGER     NO-UNDO.
    
    IF INPUT FRAME fPage1 i-cdn-compart = 0 THEN DO:
        {utp/ut-liter.i Compartimento}
        RUN utp/ut-msgs.p(INPUT 'SHOW':U,
                          INPUT 36,
                          INPUT RETURN-VALUE).
        APPLY "ENTRY":U TO i-cdn-compart IN FRAME fPage1.
        RETURN NO-APPLY.    
    END.

    /*ELSE IF INPUT FRAME fPage1 d-qtd-coleta = 0 THEN DO:
        {utp/ut-liter.i Quantidade_Coleta }
        RUN utp/ut-msgs.p(INPUT 'SHOW':U,
                          INPUT 36,
                          INPUT RETURN-VALUE).
        APPLY "ENTRY":U TO i-cdn-compart IN FRAME fPage1.
        RETURN NO-APPLY. 
    END.*/

    
    ASSIGN i-cdn-identif = tt-produt-carg.cdn-identif WHEN AVAILABLE tt-produt-carg.
    
    SESSION:SET-WAIT-STATE("general":U).
    {&WINDOW-NAME}:SENSITIVE = FALSE.

    RUN aqp/aq0302c.w PERSISTENT SET h-prog-desp (INPUT DECIMAL(d-qtd-coleta:SCREEN-VALUE IN FRAME fPage1),
                                                  INPUT tt-produt-carg.num-carg, 
                                                  INPUT tt-produt-carg.cod-pto-coleta, 
                                                  INPUT-OUTPUT i-cdn-identif) .

    IF VALID-HANDLE(h-prog-desp) THEN DO:
        RUN initializeInterface IN h-prog-desp.
         
        SESSION:SET-WAIT-STATE("":U).
         
        WAIT-FOR CLOSE OF h-prog-desp FOCUS CURRENT-WINDOW.
    END.
    
    {&WINDOW-NAME}:SENSITIVE = TRUE.
    RUN openQueriesSon IN THIS-PROCEDURE.

        
    FIND FIRST tt-produt-carg NO-LOCK 
         WHERE tt-produt-carg.cdn-identif = i-cdn-identif NO-ERROR.
 
    IF AVAILABLE tt-produt-carg THEN
       REPOSITION brSon1 TO ROWID ROWID(tt-produt-carg) NO-ERROR.

    APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    DEFINE VARIABLE i-cdn-produt-resp AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-cdn-compart     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-cdn-repos       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-cod-pto-coleta  AS CHARACTER NO-UNDO.

    IF AVAILABLE {&ttSon1} THEN
        ASSIGN i-cdn-produt-resp = {&ttSon1}.cdn-produt-resp
               i-cdn-compart     = {&ttSon1}.cdn-compart
               i-cdn-repos       = {&ttSon1}.cdn-repos
               c-cod-pto-coleta  = {&ttSon1}.cod-pto-coleta. 

    RUN goToKey IN h-boin00965 (INPUT {&ttSon1}.cdn-identif).
    IF RETURN-VALUE = 'ok' THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT  3051, /* Confirma elimina‡Æo */
                          INPUT "").
        IF RETURN-VALUE = 'YES' THEN DO:
            IF tt-carg-rural.cdn-sit = 6 THEN  /* reaberta */
                RUN pi-chama-aq0302b IN THIS-PROCEDURE.              
             
            RUN emptyRowErrors IN h-boin00965.
            RUN deleteRecord   IN h-boin00965.           
            EMPTY TEMP-TABLE rowErrors NO-ERROR.
            RUN getRowErrors IN h-boin00965(OUTPUT TABLE rowerrors).
            IF CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
               {method/showmessage.i1}
               {method/showmessage.i2}
               RETURN NO-APPLY.
           END.

           RUN openQueriesSon IN THIS-PROCEDURE.                                           
           APPLY "VALUE-CHANGED":U TO brSon1 IN FRAME fPage1.
        END.
    END.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-nao-coleta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-nao-coleta wMasterDetail
ON VALUE-CHANGED OF cb-nao-coleta IN FRAME fPage1
DO:   
    ASSIGN i-motivo-nao-coleta =  IF SELF:SCREEN-VALUE  IN FRAME fPage1 = ? THEN 0 ELSE INT(SELF:SCREEN-VALUE IN FRAME fPage1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-qtd-coleta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-qtd-coleta wMasterDetail
ON LEAVE OF d-qtd-coleta IN FRAME fPage1
DO:
    RUN pi-habilita-nao-coleta IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-qtd-coleta wMasterDetail
ON TAB OF d-qtd-coleta IN FRAME fPage1
DO:
    APPLY 'leave' TO SELF IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMasterDetail
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

  
/* Sobrescrita de triggers para evitar erro de temp-table duplicada */
ON OFF-END OF brSon1 IN FRAME fPage1
DO:
END.

ON OFF-HOME OF brSon1 IN FRAME fPage1
DO:
END.  
  
ON RETURN OF FRAME fPage1 ANYWHERE 
DO: 
    APPLY 'choose':U TO bt-sav IN FRAME fPage1.
END.


ON VALUE-CHANGED OF brSon1 IN FRAME fPage1
DO:

    DEFINE VARIABLE i-cdn-naocfedade AS INTEGER NO-UNDO.

    {masterdetail/valuechanged.i &PageNumber="1"}
    IF AVAILABLE {&ttSon1} THEN DO:
        IF NUM-ENTRIES ("brSon1":U) > 0 THEN DO :
            RUN goTokey IN h-boin00966(INPUT {&ttSon1}.cod-pto-coleta).
            IF RETURN-VALUE = 'OK' THEN 
                RUN getLogField IN h-boin00966 (INPUT 'log-pto-coleta-coletiv', OUTPUT l-log-pto-coleta-coletiv).
    
            GET CURRENT brSon1 NO-LOCK.
            
            ASSIGN c-cod-lacre:SCREEN-VALUE            IN FRAME fPage1 = {&ttSon1}.cod-lacre              
                   c-cod-amostra:SCREEN-VALUE          IN FRAME fPage1 = {&ttSon1}.cod-amostra
                   d-qtd-coleta:SCREEN-VALUE           IN FRAME fPage1 = STRING(fn-qtd-total({&ttSon1}.num-carg, 
                                                                                             {&ttSon1}.cod-pto-coleta, 
                                                                                             {&ttSon1}.cdn-compart, 
                                                                                             {&ttSon1}.cdn-repos))
                   d-val-temperat:SCREEN-VALUE         IN FRAME fPage1 = STRING({&ttSon1}.val-temperat)
                   i-cdn-compart:SCREEN-VALUE          IN FRAME fPage1 = STRING({&ttSon1}.cdn-compart)
                   c-lbl-idi-nao-coleta:SCREEN-VALUE   IN FRAME fPage1 = fn-idi-nao-coleta({&ttSon1}.idi-nao-coleta).

            IF l-list <> ? THEN DO:
                IF {&ttSon1}.cdn-motiv-nao-coleta > 0 THEN
                    ASSIGN cb-nao-coleta:SCREEN-VALUE IN FRAME fPage1 = STRING({&ttSon1}.cdn-motiv-nao-coleta).
                ELSE 
                    ASSIGN cb-nao-coleta:SCREEN-VALUE IN FRAME fPage1 = '0'.

                IF VALID-HANDLE(h-boin01009) THEN DO:
                    IF {&ttSon1}.idi-nao-coleta > 1 THEN DO:
                        RUN get-cdn-naocfedade-by-produt-carg IN h-boin01009(INPUT {&ttSon1}.cdn-identif, OUTPUT i-cdn-naocfedade).
                        IF RETURN-VALUE = "OK":U THEN
                            ASSIGN fi-cdn-naocfedade:SCREEN-VALUE IN FRAME fPage1 = STRING(i-cdn-naocfedade).
                        ELSE 
                            ASSIGN fi-cdn-naocfedade:SCREEN-VALUE IN FRAME fPage1 = "":U.
                    END.
                    ELSE 
                        ASSIGN fi-cdn-naocfedade:SCREEN-VALUE IN FRAME fPage1 = "":U.
                   
                END.
            END.

            ASSIGN d-qtd-coleta:SENSITIVE   IN FRAME fPage1 = YES
                   i-cdn-compart:SENSITIVE  IN FRAME fPage1 = YES
                   d-val-temperat:SENSITIVE IN FRAME fPage1 = YES
                   c-cod-lacre:SENSITIVE    IN FRAME fPage1 = YES
                   c-cod-amostra:SENSITIVE  IN FRAME fPage1 = YES
                   btColetiva:SENSITIVE     IN FRAME fPage1 = l-log-pto-coleta-coletiv.
            
        END.
    END.  
    ELSE DO:
        ASSIGN bt-can:SENSITIVE     IN FRAME fPage1 = NO
               bt-sav:SENSITIVE     IN FRAME fPage1 = NO
               bt-obs:SENSITIVE     IN FRAME fPage1 = NO
               btColetiva:SENSITIVE IN FRAME fPage1 = NO.
                 
        ASSIGN d-qtd-coleta:SENSITIVE           IN FRAME fPage1 = NO
               d-val-temperat:SENSITIVE         IN FRAME fPage1 = NO
               i-cdn-compart:SENSITIVE          IN FRAME fPage1 = NO
               c-cod-lacre:SENSITIVE            IN FRAME fPage1 = NO      
               c-cod-amostra:SENSITIVE          IN FRAME fPage1 = NO.
              

        ASSIGN d-qtd-coleta:SCREEN-VALUE            IN FRAME fPage1 = ""
               d-val-temperat:SCREEN-VALUE          IN FRAME fPage1 = ""
               i-cdn-compart:SCREEN-VALUE           IN FRAME fPage1 = ""
               c-cod-lacre:SCREEN-VALUE             IN FRAME fPage1 = ""
               c-cod-amostra:SCREEN-VALUE           IN FRAME fPage1 = ""
               c-lbl-idi-nao-coleta:SCREEN-VALUE    IN FRAME fPage1 = ""
               fi-cdn-naocfedade:SCREEN-VALUE       IN FRAME fPage1 = "":U.
    END.

    APPLY "ENTRY":U TO d-qtd-coleta IN FRAME fPage1.
    APPLY "VALUE-CHANGED":U TO cb-nao-coleta IN FRAME fPage1.
    
    RUN pi-habilita-nao-coleta IN THIS-PROCEDURE.

    
END.

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

    IF VALID-HANDLE({&hDBOParent}) AND
        {&hDBOParent}:TYPE = "PROCEDURE":U AND
        {&hDBOParent}:FILE-NAME = "inbo/boin00961.p":U THEN DO:
        DELETE PROCEDURE {&hDBOParent}.
        ASSIGN {&hDBOParent} = ?.
    END.

    IF VALID-HANDLE({&hDBOSon1}) AND
        {&hDBOSon1}:TYPE = "PROCEDURE":U AND
        {&hDBOSon1}:FILE-NAME = "inbo/boin00965.p":U THEN DO:
        DELETE PROCEDURE {&hDBOSon1}.
        ASSIGN {&hDBOSon1} = ?.
    END.

    IF VALID-HANDLE(h-boad107na) AND
        h-boad107na:TYPE = "PROCEDURE":U AND
        h-boad107na:FILE-NAME = "adbo/boad107na.p":U THEN DO:
        DELETE PROCEDURE h-boad107na.
        ASSIGN h-boad107na = ?.
    END.

    IF VALID-HANDLE(h-boin172na) AND
        h-boin172na:TYPE = "PROCEDURE":U AND
        h-boin172na:FILE-NAME = "inbo/boin172na.p":U THEN DO:
        DELETE PROCEDURE h-boin172na.
        ASSIGN h-boin172na = ?.
    END.

    IF VALID-HANDLE(h-boin00975) AND
        h-boin00975:TYPE = "PROCEDURE":U AND
        h-boin00975:FILE-NAME = "inbo/boin00975.p":U THEN DO:
        DELETE PROCEDURE h-boin00975.
        ASSIGN h-boin00975 = ?.
    END.

    IF VALID-HANDLE(h-boin00967) AND
        h-boin00967:TYPE = "PROCEDURE":U AND
        h-boin00967:FILE-NAME = "inbo/boin00967.p":U THEN DO:
        DELETE PROCEDURE h-boin00967.
        ASSIGN h-boin00967 = ?.
    END.

    IF VALID-HANDLE(h-boad098) AND
        h-boad098:TYPE = "PROCEDURE":U AND
        h-boad098:FILE-NAME = "adbo/boad098.p":U THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    IF VALID-HANDLE(h-boin00966) AND
        h-boin00966:TYPE = "PROCEDURE":U AND
        h-boin00966:FILE-NAME = "inbo/boin00966.p":U THEN DO:
        DELETE PROCEDURE h-boin00966.
        ASSIGN h-boin00966 = ?.
    END.

    IF VALID-HANDLE(h-boin01004) AND
        h-boin01004:TYPE = "PROCEDURE":U AND
        h-boin01004:FILE-NAME = "inbo/boin01004.p":U THEN DO:
        DELETE PROCEDURE h-boin01004.
        ASSIGN h-boin01004 = ?.
    END.

    IF VALID-HANDLE(h-boin01009) AND
        h-boin01009:TYPE = "PROCEDURE":U AND
        h-boin01009:FILE-NAME = "inbo/boin01009.p":U THEN DO:
        DELETE PROCEDURE h-boin01009.
        ASSIGN h-boin01009 = ?.
    END.


    IF VALID-HANDLE(h-boin00982) THEN DO:
        DELETE PROCEDURE h-boin00982.
        ASSIGN h-boin00982 = ?.
    END.

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
    DEFINE VARIABLE c-format AS CHARACTER NO-UNDO.

    IF NOT AVAILABLE tt-carg-rural THEN RETURN "NOK":U.

    IF VALID-HANDLE(h-boad107na) THEN DO:
        RUN goToKey IN h-boad107na (INPUT tt-carg-rural.cod-estabel:SCREEN-VALUE IN FRAME fPage0) NO-ERROR.
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getCharField IN h-boad107na (INPUT "nome":U, OUTPUT c-nome) NO-ERROR.
            ASSIGN c-nome:SCREEN-VALUE IN FRAME fPage0 = c-nome.
        END.
    END.

    IF VALID-HANDLE(h-boin172na) THEN DO:
        RUN goToKey IN h-boin172na (INPUT tt-carg-rural.it-codigo:SCREEN-VALUE IN FRAME fPage0) NO-ERROR.
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getCharField IN h-boin172na (INPUT "desc-item":U, OUTPUT c-desc-item) NO-ERROR. 
            ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage0 = c-desc-item.
            RUN getLogField  IN h-boin172na (INPUT "fraciona ":U, OUTPUT v_l-fraciona) NO-ERROR.
            IF NOT v_l-fraciona THEN DO:
                ASSIGN c-format = "->>>,>>>,>>9":U
                       d-qtd-coleta:FORMAT  IN FRAME fPage1 = ">>>,>>>,>>9":U
                       d-qtd-infor:FORMAT   IN FRAME fPage1 = c-format
                       d-qtd-difer:FORMAT   IN FRAME fPage1 = c-format
                       fi-qtd-aferid:FORMAT IN FRAME fPage1 = c-format.
            END.    
                
            {&OPEN-QUERY-brSon1}  
            
        END.
    END.
    
    IF VALID-HANDLE(h-boin00975) THEN DO:
        RUN goToKey IN h-boin00975 (INPUT tt-carg-rural.cod-rota:SCREEN-VALUE IN FRAME fPage0) NO-ERROR.
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getCharField IN h-boin00975 (INPUT "des-rota":U, OUTPUT c-desc-rota) NO-ERROR.    
            ASSIGN c-desc-rota:SCREEN-VALUE IN FRAME fPage0 = c-desc-rota.
        END.
    END.
        
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

    DISABLE c-lbl-idi-nao-coleta
            WITH FRAME fPage1.

    RUN pi-posicionar IN THIS-PROCEDURE (INPUT NO).

    RUN pi-cb-nao-coleta IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMasterDetail 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {utp/ut-liter.i Quantidade * R }
    ASSIGN d-qtd-coleta:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE). 
    {utp/ut-liter.i Temperatura * R }
    ASSIGN d-val-temperat:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Compartimento * R }
    ASSIGN i-cdn-compart:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Amostra * R }
    ASSIGN c-cod-amostra:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Lacre * R }
    ASSIGN c-cod-lacre:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Motivo * R }
    ASSIGN cb-nao-coleta:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Situa‡Æo * R }
    ASSIGN c-lbl-idi-nao-coleta:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    RETURN "OK":U.
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

    DEFINE VARIABLE iRowid AS INTEGER NO-UNDO.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "inbo/boin00961.p":U THEN DO:
          
        {btb/btb008za.i1 inbo/boin00961.p YES}
        {btb/btb008za.i2 inbo/boin00961.p '' {&hDBOParent}}               
    END.
   
    RUN setConstraintNumCarg IN {&hDBOParent} (INPUT pNumCarg, INPUT pNumCarg) NO-ERROR.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "NumCarg":U) NO-ERROR.
               
    RUN getBatchRecords IN {&hDBOParent} (INPUT ?,
                                          INPUT NO,
                                          INPUT 9999,
                                          OUTPUT iRowid,
                                          OUTPUT TABLE tt-carg-rural).  
                                                      
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "inbo/boin00965.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00965.p YES}
        {btb/btb008za.i2 inbo/boin00965.p '' {&hDBOSon1}} 
    END.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boad107na) OR
        h-boad107na:TYPE <> "PROCEDURE":U OR
        h-boad107na:FILE-NAME <> "adbo/boad107na.p":U THEN DO:
            
        {btb/btb008za.i1 adbo/boad107na.p YES}
        {btb/btb008za.i2 adbo/boad107na.p '' h-boad107na}                      
    END.

    RUN openQueryStatic IN h-boad107na (INPUT "Main":U) NO-ERROR. 

     /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boin172na) OR 
       h-boin172na:TYPE <> "PROCEDURE":U OR
       h-boin172na:FILE-NAME <> "inbo/boin172na.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin172na.p YES}
        {btb/btb008za.i2 inbo/boin172na.p '' h-boin172na} 
    END.
    
    RUN openQueryStatic IN h-boin172na (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00975) OR 
       h-boin00975:TYPE <> "PROCEDURE":U OR
       h-boin00975:FILE-NAME <> "inbo/boin00975.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00975.p YES}
        {btb/btb008za.i2 inbo/boin00975.p '' h-boin00975} 
    END.
    
    RUN openQueryStatic IN h-boin00975 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00967) OR 
       h-boin00967:TYPE <> "PROCEDURE":U OR
       h-boin00967:FILE-NAME <> "inbo/boin00967.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00967.p YES}
        {btb/btb008za.i2 inbo/boin00967.p '' h-boin00967} 
    END.
    
    RUN openQueryStatic IN h-boin00967 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boad098) OR 
       h-boad098:TYPE <> "PROCEDURE":U OR
       h-boad098:FILE-NAME <> "adbo/boad098.p":U THEN DO:

        {btb/btb008za.i1 adbo/boad098.p YES}
        {btb/btb008za.i2 adbo/boad098.p '' h-boad098} 
    END.
    
    RUN openQueryStatic IN h-boad098 (INPUT "Main":U) NO-ERROR.

     /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00966) OR 
       h-boin00966:TYPE <> "PROCEDURE":U OR
       h-boin00966:FILE-NAME <> "inbo/boin00966.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00966.p YES}
        {btb/btb008za.i2 inbo/boin00966.p '' h-boin00966} 
    END.
    
    RUN openQueryStatic IN h-boin00966 (INPUT "Main":U) NO-ERROR.

     /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boin01004) OR 
       h-boin01004:TYPE <> "PROCEDURE":U OR
       h-boin01004:FILE-NAME <> "inbo/boin01004.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin01004.p YES}
        {btb/btb008za.i2 inbo/boin01004.p '' h-boin01004} 
    END.
    
    RUN openQueryStatic IN h-boin01004 (INPUT "Main":U) NO-ERROR.

     /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boin01009) OR 
       h-boin01009:TYPE <> "PROCEDURE":U OR
       h-boin01009:FILE-NAME <> "inbo/boin01009.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin01009.p YES}
        {btb/btb008za.i2 inbo/boin01009.p '' h-boin01009} 
    END.
    
    RUN openQueryStatic IN h-boin01009 (INPUT "Main":U) NO-ERROR.


    IF NOT VALID-HANDLE(h-boin00982) THEN
        RUN inbo/boin00982.p PERSISTENT SET h-boin00982.

    RUN openQueryStatic IN h-boin00982(INPUT "Main":U).

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

    /*--- Faz a liga‡Æo entre o DBO filho e o DBO pai ---*/
    RUN linkToCarg-rural IN {&hDBOSon1} (INPUT {&hDBOParent}).
    
    /*--- Abre query do DBO filho ---*/
    RUN openQueryStatic IN {&hDBOSon1} (INPUT "ProdutoresCarga":U).
    
    RUN getBatchRecords IN {&hDBOSon1} (INPUT ?,
                                        INPUT NO,
                                        INPUT 99999,
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE {&ttSon1}). 

    EMPTY TEMP-TABLE tt-produt-carg-aux NO-ERROR.    

    FOR EACH {&ttSon1}:

        IF CAN-FIND(FIRST tt-produt-carg-aux
                    WHERE tt-produt-carg-aux.cod-pto-coleta = {&ttSon1}.cod-pto-coleta
                      AND tt-produt-carg-aux.cdn-repos      = {&ttSon1}.cdn-repos 
                      AND tt-produt-carg-aux.cdn-compart    = {&ttSon1}.cdn-compart) THEN

            DELETE {&ttSon1}.

        ELSE DO:

            CREATE tt-produt-carg-aux.
            BUFFER-COPY {&ttSon1} TO tt-produt-carg-aux.

        END.            

    END.

    /*--- Abre a query associada ao browse da pÿgina {&PageNumber} ---*/
    {&OPEN-QUERY-brSon1}

     APPLY "VALUE-CHANGED":U TO BROWSE brSon1.

    /*--- Seta estado dos botäes relacionados ao browse da p gina {&PageNumber} ---*/
    IF AVAILABLE {&ttSon1} THEN
        ASSIGN 
            &IF "{&AddSon1}":U = "YES":U &THEN
               btAddSon1:SENSITIVE IN FRAME fPage1    = YES
            &ENDIF
                        
            &IF "{&UpdateSon1}":U = "YES":U &THEN               
               btUpdateSon1:SENSITIVE IN FRAME fPage1 = YES
            &ENDIF
            
            &IF "{&DeleteSon1}":U = "YES":U &THEN               
               btDeleteSon1:SENSITIVE IN FRAME fPage1 = YES
            &ENDIF.
    ELSE
        ASSIGN 
            &IF "{&AddSon1}":U = "YES":U &THEN
               btAddSon1:SENSITIVE IN FRAME fPage1    = AVAILABLE {&ttParent}
            &ENDIF
                        
            &IF "{&UpdateSon1}":U = "YES":U &THEN               
               btUpdateSon1:SENSITIVE IN FRAME fPage1 = NO
            &ENDIF
            
            &IF "{&DeleteSon1}":U = "YES":U &THEN               
               btDeleteSon1:SENSITIVE IN FRAME fPage1 = NO
            &ENDIF.
                       
    IF AVAILABLE {&ttSon1} THEN 
         assign epc-rowid1 = {&ttSon1}.r-Rowid. 
    ELSE 
         assign epc-rowid1 = ?.
                          
    IF AVAILABLE {&ttSon1} THEN
        ASSIGN bt-can:SENSITIVE IN FRAME fPage1 = YES  
               bt-sav:SENSITIVE IN FRAME fPage1 = YES
               bt-obs:SENSITIVE IN FRAME fPage1 = YES.  
               

    ASSIGN d-qtd-infor = 0.
    
    IF AVAILABLE {&ttParent} THEN DO:
        RUN getQtdTotalCarga IN {&hDBOSon1} (INPUT {&ttParent}.num-carg, OUTPUT d-qtd-infor).
        
        IF VALID-HANDLE(h-boin00982) THEN
            RUN calcula-qtd-aferida-carga IN h-boin00982(INPUT {&ttParent}.num-carg, OUTPUT fi-qtd-aferid).
            
        ASSIGN d-qtd-infor:SCREEN-VALUE IN FRAME fPage1 = STRING(d-qtd-infor)
               d-qtd-difer:SCREEN-VALUE IN FRAME fPage1 = IF fi-qtd-aferid > 0 THEN STRING(fi-qtd-aferid - d-qtd-infor)
                                                          ELSE "".                                                          
        DISP fi-qtd-aferid WITH FRAME fPage1.
    END.
                 
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cb-nao-coleta wMasterDetail 
PROCEDURE pi-cb-nao-coleta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-list AS CHARACTER NO-UNDO.

    ENABLE cb-nao-coleta
      WITH FRAME fPage1.

    IF VALID-HANDLE(h-boin01004) THEN DO:
        RUN getList IN h-boin01004(OUTPUT c-list).
        ASSIGN l-list  = RETURN-VALUE = "OK":U
               cb-nao-coleta:LIST-ITEM-PAIRS IN FRAME fPage1 = c-list.
    END.

    APPLY 'VALUE-CHANGED' TO brSon1 IN FRAME fPage1. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-chama-aq0302b wMasterDetail 
PROCEDURE pi-chama-aq0302b :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-texto = "".
    DO WHILE c-texto = "":       
        RUN aqp/aq0302b.w (INPUT-OUTPUT c-texto).
    END. 
    RUN setConstraintTexto IN {&hDBOSon1} (INPUT c-texto).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-nao-coleta wMasterDetail 
PROCEDURE pi-habilita-nao-coleta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAILABLE {&ttSon1} THEN DO:
        IF INPUT FRAME fPage1 d-qtd-coleta = 0 THEN DO:
            ASSIGN cb-nao-coleta:SENSITIVE     IN FRAME fPage1 = YES
                   d-val-temperat:SENSITIVE    IN FRAME fPage1 = NO
                   i-cdn-compart:SENSITIVE     IN FRAME fPage1 = NO
                   c-cod-amostra:SENSITIVE     IN FRAME fPage1 = NO
                   c-cod-lacre:SENSITIVE       IN FRAME fPage1 = NO
                   c-cod-amostra:SENSITIVE     IN FRAME fPage1 = NO
                   btColetiva:SENSITIVE        IN FRAME fPage1 = NO 
                   d-val-temperat:SCREEN-VALUE IN FRAME fPage1 = '0'
                   i-cdn-compart:SCREEN-VALUE  IN FRAME fPage1 = '0'
                   c-cod-amostra:SCREEN-VALUE  IN FRAME fPage1 = ''.                   
        END.
        ELSE DO:
            ASSIGN cb-nao-coleta:SENSITIVE    IN FRAME fPage1 = YES
                   d-val-temperat:SENSITIVE   IN FRAME fPage1 = YES
                   i-cdn-compart:SENSITIVE    IN FRAME fPage1 = YES
                   c-cod-amostra:SENSITIVE    IN FRAME fPage1 = YES
                   c-cod-lacre:SENSITIVE      IN FRAME fPage1 = YES
                   btColetiva:SENSITIVE       IN FRAME fPage1 = l-log-pto-coleta-coletiv.
        END.  
        APPLY "VALUE-CHANGED":U TO cb-nao-coleta IN FRAME fPage1.     

    END.
    ELSE DO:
     ASSIGN cb-nao-coleta:SCREEN-VALUE IN FRAME fPage1 = "0"
            cb-nao-coleta:SENSITIVE    IN FRAME fPage1 = NO
            d-val-temperat:SENSITIVE   IN FRAME fPage1 = NO
            i-cdn-compart:SENSITIVE    IN FRAME fPage1 = NO
            c-cod-amostra:SENSITIVE    IN FRAME fPage1 = NO
            c-cod-lacre:SENSITIVE      IN FRAME fPage1 = NO
            btColetiva:SENSITIVE       IN FRAME fPage1 = NO
            d-qtd-coleta:SENSITIVE     IN FRAME fPage1 = NO.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posicionar wMasterDetail 
PROCEDURE pi-posicionar :
/*------------------------------------------------------------------------------
  Purpose: Reposicionar browse no próx registro a ser atualizado
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM l-soma AS LOGICAL NO-UNDO.
    
    IF l-soma THEN
        ASSIGN i-linha = brSon1:FOCUSED-ROW IN FRAME fPage1 + 1. /*quando chamado pelo botão salvar, posiciona na próxima linha*/

    REPOSITION brSon1 TO ROW (i-linha) NO-ERROR. 
    IF AVAIL {&ttSon1} THEN
        ASSIGN d-qtd-coleta:SCREEN-VALUE IN FRAME  fPage1 =  STRING(fn-qtd-total({&ttSon1}.num-carg, 
                                                                                 {&ttSon1}.cod-pto-coleta, 
                                                                                 {&ttSon1}.cdn-compart, 
                                                                                 {&ttSon1}.cdn-repos)).
    APPLY "ENTRY":U TO d-qtd-coleta IN FRAME fPage1.
       
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-save wMasterDetail 
PROCEDURE pi-save :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE d-total-ponto       AS DECIMAL NO-UNDO.
    DEFINE VARIABLE l-nao-coleta        AS LOGICAL NO-UNDO.
   

    RUN getQtdTotalPtoColeta IN {&hDBOSon1} (INPUT {&ttSon1}.num-carg, 
                                             INPUT {&ttSon1}.cod-pto-coleta, 
                                             INPUT {&ttSon1}.cdn-compart,
                                             INPUT {&ttSon1}.cdn-repos,
                                             OUTPUT d-total-ponto).
                                             
    RUN piCriaTTProdutCargAux IN THIS-PROCEDURE. /* Cria estrutura comum da ttProdutCargAux */
 
    IF d-total-ponto                  = DECIMAL(d-qtd-coleta:SCREEN-VALUE   IN FRAME fPage1) AND
       {&ttSon1}.val-temperat         = DECIMAL(d-val-temperat:SCREEN-VALUE IN FRAME fPage1) AND
       {&ttSon1}.cdn-compart          = INTEGER(i-cdn-compart:SCREEN-VALUE  IN FRAME fPage1) AND
       {&ttSon1}.cod-lacre            = c-cod-lacre:SCREEN-VALUE            IN FRAME fPage1  AND
       {&ttSon1}.cod-amostra          = c-cod-amostra:SCREEN-VALUE          IN FRAME fPage1  AND
       {&ttSon1}.cdn-motiv-nao-coleta = i-motivo-nao-coleta THEN  RETURN 'NOK':U.

    IF tt-carg-rural.cdn-sit = 6 THEN /* reaberta */
        RUN pi-chama-aq0302b IN THIS-PROCEDURE.
 
    ASSIGN ttProdutCargAux.qtd-coleta   = DECIMAL(d-qtd-coleta:SCREEN-VALUE IN FRAME fPage1)
           ttProdutCargAux.val-temperat = DECIMAL(d-val-temperat:SCREEN-VALUE IN FRAME fPage1) 
           ttProdutCargAux.cdn-compart  = INTEGER(i-cdn-compart:SCREEN-VALUE IN FRAME fPage1)
           ttProdutCargAux.cod-lacre    = INPUT FRAME fPage1 c-cod-lacre 
           ttProdutCargAux.cod-amostra  = INPUT FRAME fPage1 c-cod-amostra.

    IF INPUT FRAME fPage1 cb-nao-coleta > 0 THEN
        ASSIGN ttProdutCargAux.cdn-motiv-nao-coleta = i-motivo-nao-coleta
               ttProdutCargAux.idi-nao-coleta       = 1 /* 1- Pendente*/.
    ELSE
        ASSIGN ttProdutCargAux.idi-nao-coleta       = 0 /* 0-NÇO TEM MOTIVO  DE NÇO COLETA.*/
               ttProdutCargAux.cdn-motiv-nao-coleta = 0.

    
   EMPTY TEMP-TABLE RowErrors NO-ERROR.
   RUN emptyRowErrors IN {&hDBOSon1}. 

    IF INPUT FRAME fPage1 d-qtd-coleta = 0 THEN DO:
        RUN updateProdutCargNaoColeta IN {&hDBOSon1} (INPUT {&ttSon1}.num-carg,       
                                                      INPUT {&ttSon1}.cod-pto-coleta,
                                                      INPUT {&ttSon1}.cdn-produt-respons,
                                                      INPUT {&ttSon1}.cdn-compart,
                                                      INPUT {&ttSon1}.cdn-repos,
                                                      INPUT ttProdutCargAux.cdn-motiv-nao-coleta).
    END.
    ELSE DO:

      /* Atualiza informa‡äes dos produtores coletivos */
        IF l-log-pto-coleta-coletiv THEN DO:
             RUN updateProdutCargColetivo IN {&hDBOSon1} (INPUT {&ttSon1}.num-carg,       
                                                          INPUT {&ttSon1}.cod-pto-coleta,
                                                          INPUT {&ttSon1}.cdn-produt-respons,
                                                          INPUT {&ttSon1}.cdn-compart,
                                                          INPUT {&ttSon1}.cdn-repos,
                                                          INPUT TABLE ttProdutCargAux).

             IF RETURN-VALUE = "OK" THEN DO:
                /* SE A COLETA TEM QUANTIDADE INFORMADA, ABRE A TELA DE PRODUTORES COLETIVOS */
                IF DECIMAL(d-qtd-coleta:SCREEN-VALUE IN FRAME fPage1) > 0 
               AND d-total-ponto <> DECIMAL(d-qtd-coleta:SCREEN-VALUE IN FRAME fPage1) THEN
                    APPLY "CHOOSE":U TO btColetiva IN FRAME fPage1.
             END.
        END.
        ELSE DO:
            RUN setRecord      IN {&hDBOSon1} (INPUT TABLE ttProdutCargAux).
            RUN emptyRowErrors IN {&hDBOSon1}.
            RUN updateRecord   IN {&hDBOSon1}. 
        END.  
    END.


   

    RUN getRowErrors IN {&hDBOSon1} (OUTPUT TABLE RowErrors).            
    IF CAN-FIND(FIRST RowErrors
                WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:            
        {method/showmessage.i1}
        {method/showmessage.i2}
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaTTProdutCargAux wMasterDetail 
PROCEDURE piCriaTTProdutCargAux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN openQueryStatic IN {&hDBOSon1}(INPUT 'Main').
    RUN goToKey IN {&hDBOSon1} (INPUT {&ttSon1}.cdn-identif) NO-ERROR.
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    EMPTY TEMP-TABLE ttProdutCargAux NO-ERROR.    
    RUN getRecord IN {&hDBOSon1} (OUTPUT TABLE ttProdutCargAux).

    FIND FIRST ttProdutCargAux NO-ERROR.          
    IF NOT AVAILABLE ttProdutCargAux THEN RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-idi-nao-coleta wMasterDetail 
FUNCTION fn-idi-nao-coleta RETURNS CHARACTER
  ( i-idi-nao-coleta AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN IF i-idi-nao-coleta = 0 THEN "" ELSE {ininc/i01in00965.i 04 i-idi-nao-coleta}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-produtor wMasterDetail 
FUNCTION fn-produtor RETURNS CHARACTER
  (iProdutRural AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE RESULT AS CHARACTER FORMAT "X(80)" NO-UNDO.
                   
    RUN findCodigo IN h-boad098(INPUT iProdutRural, 
                                OUTPUT RESULT).
    IF RESULT = "" THEN DO:        
        RUN goToKey IN h-boad098 (INPUT iProdutRural) NO-ERROR.
        RUN getCharfield IN h-boad098(INPUT "nome-emit", OUTPUT RESULT).
    END.
    
    RETURN RESULT.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-qtd-total wMasterDetail 
FUNCTION fn-qtd-total RETURNS DECIMAL
  (iNumCarg AS INTEGER, cPtoColeta AS CHARACTER, pCdnCompart AS INTEGER,  pCdnRepos AS INTEGER ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE result AS DECIMAL NO-UNDO.

    RUN getQtdTotalPtoColeta IN {&hDBOSon1} (INPUT iNumCarg, 
                                             INPUT cPtoColeta, 
                                             INPUT pCdnCompart, 
                                             INPUT pCdnRepos,
                                             OUTPUT result).                
        
        RETURN result.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

