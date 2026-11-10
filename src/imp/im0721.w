&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-adiant-despes NO-UNDO LIKE adiant-despes
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-adiant-despes-parc NO-UNDO LIKE adiant-despes-parc
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0721 2.00.00.008 } /*** "010008" 21/03/2025 09:24:36  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0721 MIM}
&ENDIF

{utp/ut-glob.i}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0721
&GLOBAL-DEFINE Version          2.00.00.008

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Antecip

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        NO
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     NO

&GLOBAL-DEFINE AddSon1          NO
&GLOBAL-DEFINE UpdateSon1       NO
&GLOBAL-DEFINE DeleteSon1       NO

&GLOBAL-DEFINE ttParent         tt-adiant-despes
&GLOBAL-DEFINE hDBOParent       h-bocx00442
&GLOBAL-DEFINE DBOParentTable   adiant-despes
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           tt-adiant-despes-parc
&GLOBAL-DEFINE hDBOSon1         h-bocx00443
&GLOBAL-DEFINE DBOSon1Table     adiant-despes-parc
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE page1Widgets 
&GLOBAL-DEFINE page2Widgets 
&GLOBAL-DEFINE page3Widgets 

&GLOBAL-DEFINE page0Fields tt-adiant-despes.cod-estabel ~
                           tt-adiant-despes.dat-implant ~
                           tt-adiant-despes.cdd-adiant ~
                           tt-adiant-despes.cdn-emitente ~
                           tt-adiant-despes.cdn-moeda ~
                           tt-adiant-despes.val-adiant-moed

&GLOBAL-DEFINE page1Browse  brSon1    
&GLOBAL-DEFINE VALUE-CHANGED1    YES
&GLOBAL-DEFINE OFF-END1          YES
&global-define mouse-select-dblclick1 YES

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-return               AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-situacao             AS CHARACTER  FORMAT "X(16)":U NO-UNDO.
DEFINE VARIABLE c-idi-valor            AS CHARACTER  FORMAT "X(16)":U NO-UNDO.
DEFINE VARIABLE l-gerou-apb            AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE c-marcar               AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-desmarcar            AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-filtro               AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE l-fn-antecip           AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE l-usou-filtro          AS LOGICAL                     NO-UNDO.

DEFINE VARIABLE c-cod-parcela-ini      AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-cod-parcela-fim      AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-cod-espec-docto-ini  AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-cod-espec-docto-fim  AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-cod-ser-docto-ini    AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-cod-ser-docto-fim    AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-cod-refer-ini        AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-cod-refer-fim        AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-cod-tit-ap-ini       AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-cod-tit-ap-fim       AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE dt-dat-emissao-ini     AS DATE                        NO-UNDO.
DEFINE VARIABLE dt-dat-emissao-fim     AS DATE                        NO-UNDO.
DEFINE VARIABLE dt-dat-vencto-ini      AS DATE                        NO-UNDO.
DEFINE VARIABLE dt-dat-vencto-fim      AS DATE                        NO-UNDO.
DEFINE VARIABLE de-val-adiant-moed-ini AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-val-adiant-moed-fim AS DECIMAL                     NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE      NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad098     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad107     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boun005     AS HANDLE      NO-UNDO.

define temp-table tt-param  no-undo
    field destino            as integer
    field arquivo            as char
    field usuario            as char
    field data-exec          as date
    field hora-exec          as integer.

define temp-table tt-digita NO-UNDO
    field r-adiant        as rowid.
    
def var raw-param        as raw no-undo.

def temp-table tt-raw-digita  no-undo
   field raw-digita   as raw.

{imp/im0720b.i}

DEFINE TEMP-TABLE tt-adiant-despes-parc-aux NO-UNDO LIKE tt-adiant-despes-parc
    FIELD marcar AS CHARACTER.

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
&Scoped-define INTERNAL-TABLES tt-adiant-despes-parc-aux

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-adiant-despes-parc-aux.marcar tt-adiant-despes-parc-aux.cod-refer tt-adiant-despes-parc-aux.cod-espec-docto tt-adiant-despes-parc-aux.cod-ser-docto tt-adiant-despes-parc-aux.cod-tit-ap tt-adiant-despes-parc-aux.cod-parcela tt-adiant-despes-parc-aux.dat-emissao tt-adiant-despes-parc-aux.dat-vencto tt-adiant-despes-parc-aux.val-adiant-moed tt-adiant-despes-parc-aux.log-gerou-tit-ap fnSituacaoParc(INPUT tt-adiant-despes-parc-aux.cod-estabel, INPUT tt-adiant-despes-parc-aux.cod-refer) @ c-situacao tt-adiant-despes-parc-aux.val-adiant-orig fnIdiValor (INPUT tt-adiant-despes-parc-aux.idi-valor) @ c-idi-valor   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-adiant-despes-parc-aux NO-LOCK                                 BY tt-adiant-despes-parc-aux.cod-espec-docto                                 BY tt-adiant-despes-parc-aux.cod-ser-docto                                 BY tt-adiant-despes-parc-aux.cod-tit-ap                                 BY tt-adiant-despes-parc-aux.cod-parcela
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-adiant-despes-parc-aux NO-LOCK                                 BY tt-adiant-despes-parc-aux.cod-espec-docto                                 BY tt-adiant-despes-parc-aux.cod-ser-docto                                 BY tt-adiant-despes-parc-aux.cod-tit-ap                                 BY tt-adiant-despes-parc-aux.cod-parcela.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-adiant-despes-parc-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-adiant-despes-parc-aux


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-adiant-despes.cod-estabel ~
tt-adiant-despes.dat-implant tt-adiant-despes.cdd-adiant ~
tt-adiant-despes.cdn-emitente tt-adiant-despes.cdn-moeda ~
tt-adiant-despes.val-adiant-moed 
&Scoped-define ENABLED-TABLES tt-adiant-despes
&Scoped-define FIRST-ENABLED-TABLE tt-adiant-despes
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btFirst btPrev btNext ~
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
c-desc-estabel c-desc-emitente c-desc-moeda 
&Scoped-Define DISPLAYED-FIELDS tt-adiant-despes.cod-estabel ~
tt-adiant-despes.dat-implant tt-adiant-despes.cdd-adiant ~
tt-adiant-despes.cdn-emitente tt-adiant-despes.cdn-moeda ~
tt-adiant-despes.val-adiant-moed 
&Scoped-define DISPLAYED-TABLES tt-adiant-despes
&Scoped-define FIRST-DISPLAYED-TABLE tt-adiant-despes
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel c-desc-emitente ~
c-desc-moeda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnIdiValor wMasterDetail 
FUNCTION fnIdiValor RETURNS CHARACTER
  (INPUT i-idi-valor AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSituacaoParc wMasterDetail 
FUNCTION fnSituacaoParc RETURNS CHARACTER
  ( INPUT c-cod-estabel AS CHAR, 
    INPUT c-cod-refer AS CHAR)  FORWARD.

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

DEFINE VARIABLE c-desc-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 4.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btFilter 
     IMAGE-UP FILE "image/im-fil.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-fil.bmp":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro Antecipa‡äes".

DEFINE BUTTON btGera 
     LABEL "Gera T¡tulo" 
     SIZE 14 BY 1.

DEFINE BUTTON btMarca 
     LABEL "Marca Todos" 
     SIZE 14 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-adiant-despes-parc-aux SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      tt-adiant-despes-parc-aux.marcar FORMAT "x(5)":U COLUMN-LABEL " * " 
      tt-adiant-despes-parc-aux.cod-refer FORMAT "x(12)":U
      tt-adiant-despes-parc-aux.cod-espec-docto FORMAT "x(3)":U COLUMN-LABEL "Esp‚cie"
      tt-adiant-despes-parc-aux.cod-ser-docto FORMAT "x(5)":U
      tt-adiant-despes-parc-aux.cod-tit-ap FORMAT "x(16)":U
      tt-adiant-despes-parc-aux.cod-parcela FORMAT "x(02)":U
      tt-adiant-despes-parc-aux.dat-emissao FORMAT "99/99/9999":U COLUMN-LABEL "Data EmissÆo"
      tt-adiant-despes-parc-aux.dat-vencto FORMAT "99/99/9999":U COLUMN-LABEL "Data Vencto"
      tt-adiant-despes-parc-aux.val-adiant-moed FORMAT "->>>,>>>,>>>,>>>,>>9.99":U COLUMN-LABEL "Valor Adiantamento"
      tt-adiant-despes-parc-aux.log-gerou-tit-ap FORMAT "Sim/NÆo":U
      fnSituacaoParc(INPUT tt-adiant-despes-parc-aux.cod-estabel, INPUT tt-adiant-despes-parc-aux.cod-refer) @ c-situacao COLUMN-LABEL "Situa‡Æo APB"
      tt-adiant-despes-parc-aux.val-adiant-orig FORMAT "->>>,>>>,>>>,>>>,>>9.99":U COLUMN-LABEL "Valor Original"
      fnIdiValor (INPUT tt-adiant-despes-parc-aux.idi-valor) @ c-idi-valor COLUMN-LABEL "Gera‡Æo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 79 BY 8.33
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorr¼ncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorr¼ncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr½xima ocorr¼ncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "‚ltima ocorr¼ncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "Vÿ Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat½rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-adiant-despes.cod-estabel AT ROW 2.88 COL 18 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-estabel AT ROW 2.88 COL 24.43 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     tt-adiant-despes.dat-implant AT ROW 2.88 COL 76.43 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-adiant-despes.cdd-adiant AT ROW 3.83 COL 18 COLON-ALIGNED WIDGET-ID 6
          LABEL "Adiantamento"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-adiant-despes.cdn-emitente AT ROW 4.75 COL 18 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-desc-emitente AT ROW 4.75 COL 28.14 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     tt-adiant-despes.cdn-moeda AT ROW 5.67 COL 18 COLON-ALIGNED WIDGET-ID 10
          LABEL "Moeda"
          VIEW-AS FILL-IN 
          SIZE 3 BY .88
     c-desc-moeda AT ROW 5.67 COL 21.29 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     tt-adiant-despes.val-adiant-moed AT ROW 5.88 COL 66.29 COLON-ALIGNED WIDGET-ID 28
          LABEL "Valor Adiantamento"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.96
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btFilter AT ROW 8.27 COL 81.14
     btMarca AT ROW 9.58 COL 2
     btGera AT ROW 9.58 COL 67.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 9
         SIZE 85.43 BY 9.67
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-adiant-despes T "?" NO-UNDO mgcex adiant-despes
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-adiant-despes-parc T "?" NO-UNDO mgcex adiant-despes-parc
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
         HEIGHT             = 18.04
         WIDTH              = 90
         MAX-HEIGHT         = 25.08
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 25.08
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
/* SETTINGS FOR FILL-IN tt-adiant-despes.cdd-adiant IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-adiant-despes.cdn-moeda IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-adiant-despes.val-adiant-moed IN FRAME fPage0
   EXP-LABEL                                                            */
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
OPEN QUERY {&SELF-NAME} FOR EACH tt-adiant-despes-parc-aux NO-LOCK
                                BY tt-adiant-despes-parc-aux.cod-espec-docto
                                BY tt-adiant-despes-parc-aux.cod-ser-docto
                                BY tt-adiant-despes-parc-aux.cod-tit-ap
                                BY tt-adiant-despes-parc-aux.cod-parcela.
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
  IF AVAIL tt-adiant-despes-parc-aux THEN DO:
        IF tt-adiant-despes-parc-aux.marcar = "*":U THEN DO:
            ASSIGN tt-adiant-despes-parc-aux.marcar = "".
        END.
        ELSE
            ASSIGN tt-adiant-despes-parc-aux.marcar = "*":U.
            
        DISP tt-adiant-despes-parc-aux.marcar WITH BROWSE brSon1.
       
    END.
    
    RUN pi-atualiza-botoes.
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
&Scoped-define SELF-NAME btFilter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFilter wMasterDetail
ON CHOOSE OF btFilter IN FRAME fPage1 /* Filtro */
DO:
  RUN imp/im0721pr.w (input-output c-cod-refer-ini,      
                      input-output c-cod-refer-fim,      
                      input-output c-cod-espec-docto-ini,
                      input-output c-cod-espec-docto-fim,
                      input-output c-cod-ser-docto-ini,  
                      input-output c-cod-ser-docto-fim,  
                      input-output c-cod-tit-ap-ini,     
                      input-output c-cod-tit-ap-fim,
                      input-output c-cod-parcela-ini,    
                      input-output c-cod-parcela-fim,
                      input-output dt-dat-emissao-ini,   
                      input-output dt-dat-emissao-fim,   
                      input-output dt-dat-vencto-ini,    
                      input-output dt-dat-vencto-fim,
                      input-output de-val-adiant-moed-ini,    
                      input-output de-val-adiant-moed-fim,
                      output l-usou-filtro).

  IF l-usou-filtro THEN DO:

      RUN SetConstraintFilter IN h-bocx00443 (input c-cod-refer-ini,      
                                              input c-cod-refer-fim,      
                                              input c-cod-espec-docto-ini,
                                              input c-cod-espec-docto-fim,
                                              input c-cod-ser-docto-ini,  
                                              input c-cod-ser-docto-fim,  
                                              input c-cod-tit-ap-ini,     
                                              input c-cod-tit-ap-fim,
                                              input c-cod-parcela-ini,    
                                              input c-cod-parcela-fim,
                                              input dt-dat-emissao-ini,   
                                              input dt-dat-emissao-fim,   
                                              input dt-dat-vencto-ini,    
                                              input dt-dat-vencto-fim,
                                              input de-val-adiant-moed-ini,    
                                              input de-val-adiant-moed-fim).  
    
     {masterdetail/openqueriesson.i &Parent="AdiantDespes"
                                    &Query="Filter"
                                    &PageNumber="1"}.
     
      RUN pi-cria-browser.
    
      APPLY "VALUE-CHANGED":U TO {&page1browse} IN FRAME fPage1.
      {&OPEN-QUERY-brSon1}
  END.
      
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


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btMarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMarca wMasterDetail
ON CHOOSE OF btMarca IN FRAME fPage1 /* Marca Todos */
DO:
    IF btMarca:LABEL IN FRAME fPage1 = c-marcar  THEN
       ASSIGN c-filtro = "".
    ELSE
       ASSIGN c-filtro = "*":U.

   FOR EACH tt-adiant-despes-parc-aux
      WHERE tt-adiant-despes-parc-aux.marcar = c-filtro:

      IF c-filtro = "" THEN
          ASSIGN tt-adiant-despes-parc-aux.marcar = "*":U.
      ELSE          
          ASSIGN tt-adiant-despes-parc-aux.marcar = "":U.
   END.
   {&OPEN-QUERY-brSon1}

    RUN pi-atualiza-botoes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btGera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGera wMasterDetail
ON CHOOSE OF btGera IN FRAME fPage1 /* Gera T¡tulo */
DO:
    /* Valida se existe alguma parcela para gerar t¡tulo no AP */
    IF NOT CAN-FIND(FIRST tt-adiant-despes-parc-aux
                    WHERE tt-adiant-despes-parc-aux.marcar = "*":U
                    AND   tt-adiant-despes-parc-aux.log-gerou-tit-ap = NO) THEN DO: 
        RUN utp/ut-msgs.p(INPUT "show":U, INPUT 55349, INPUT RETURN-VALUE).
        return no-apply.
    END.

    /*--- Pede confirmacao para a atualizacao ---*/
    {utp/ut-liter.i "gera‡Æo_do(s)_t¡tulo(s)" *}
    run utp/ut-msgs.p (input "show":U, input 701, input return-value).
    
    /*--- Cancela a trigger no caso de resposta negativa ---*/
    if  return-value = "NO":U then 
        return no-apply.

    /* Valida emitente */    
    run findCodigo in h-boad098(input tt-adiant-despes-parc-aux.cdn-emitente, output c-return).
    if c-return <> "" then do:
        {utp/ut-liter.i "Emitente" *}
        RUN utp/ut-msgs.p(INPUT "show":U, INPUT 2, INPUT RETURN-VALUE).
        return no-apply.
    end.    

    for each tt-digita:
        delete tt-digita.
    end.

    find first tt-adiant-despes-parc-aux where tt-adiant-despes-parc-aux.marcar = "*":U no-error.
    if available tt-adiant-despes-parc-aux then do:

        create tt-param.
        assign tt-param.usuario         = c-seg-usuario
               tt-param.destino         = 3
               tt-param.data-exec       = today
               tt-param.hora-exec       = time
               tt-param.arquivo         = session:temp-directory + "IM0721":U + ".tmp".

        for each tt-adiant-despes-parc-aux
            where tt-adiant-despes-parc-aux.marcar = "*"
            and   tt-adiant-despes-parc-aux.log-gerou-tit-ap = NO:
            create tt-digita.
            assign tt-digita.r-adiant = tt-adiant-despes-parc-aux.r-rowid.
        end.
        
        raw-transfer tt-param    to raw-param.

        for each tt-raw-digita:
            delete tt-raw-digita.
        end.

        for each tt-digita:
            create tt-raw-digita.
            raw-transfer tt-digita to tt-raw-digita.raw-digita.
        end.

        RUN imp/im0721a.p (input raw-param, input table tt-raw-digita).
    end.

    EMPTY TEMP-TABLE tt-adiant-despes-parc-aux.
    EMPTY TEMP-TABLE tt-adiant-despes-parc.
    {&OPEN-QUERY-{&page1browse}} 
    RUN pi-cria-browser.
    {&OPEN-QUERY-brSon1}
    RUN displayFields IN THIS-PROCEDURE.

    {include/i-rptrm.i}

END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
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
    {method/zoomreposition.i &ProgramZoom="cxzoom/z01cx00442.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes.cdn-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cdn-emitente wMasterDetail
ON LEAVE OF tt-adiant-despes.cdn-emitente IN FRAME fPage0 /* Emitente */
DO:
    IF  AVAIL {&ttParent} THEN DO:
        RUN findCodigo IN h-boad098 (INPUT INPUT FRAME fPage0 {&ttParent}.cdn-emitente, OUTPUT c-return).
        IF  c-return = "":U THEN DO:
            RUN getcharfield in h-boad098 (input "nome-abrev":U, OUTPUT c-desc-emitente).
                DISPLAY c-desc-emitente WITH FRAME fPage0.
        END.
        ELSE DO:
            ASSIGN c-desc-emitente:SCREEN-VALUE IN FRAME fpage0 = "":U.
        END.
    END.
    ELSE DO:
        ASSIGN c-desc-emitente:SCREEN-VALUE IN FRAME fpage0 = "":U.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes.cdn-moeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cdn-moeda wMasterDetail
ON LEAVE OF tt-adiant-despes.cdn-moeda IN FRAME fPage0 /* Moeda */
DO:
    IF AVAIL {&ttParent} THEN DO:
       RUN findCodigo in h-boun005 (INPUT INPUT FRAME fpage0 {&ttParent}.cdn-moeda, OUTPUT c-return).
       IF  c-return = "":U THEN DO:
           RUN getCharField in h-boun005 (input "descricao":U, output c-desc-moeda).
           DISPLAY c-desc-moeda WITH FRAME fPage0.
       END.
       ELSE DO:
           ASSIGN c-desc-moeda:SCREEN-VALUE IN FRAME fpage0 = "":U.
       END.
    END.
    ELSE DO: 
       ASSIGN c-desc-moeda:SCREEN-VALUE IN FRAME fpage0 = "":U.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cod-estabel wMasterDetail
ON LEAVE OF tt-adiant-despes.cod-estabel IN FRAME fPage0 /* Estabelecimento */
DO:
    IF AVAIL {&ttParent} THEN DO:
        RUN gotokey IN h-boad107 (INPUT INPUT FRAME fpage0 {&ttParent}.cod-estabel).
        IF RETURN-VALUE = "OK":U THEN
            RUN getcharfield in h-boad107 (INPUT "nome", OUTPUT c-desc-estabel).
        ELSE
            ASSIGN c-desc-estabel = "".    
    END.
    DISPLAY c-desc-estabel WITH FRAME fPage0.  
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

/* Funcionalidade nÆo est  liberada para o Internacional. */
if i-pais-impto-usuario <> 1 then do:
   run utp/ut-msgs.p(input "show",
                     input 55282,
                     input return-value).
   apply 'close' to this-procedure.
   return no-apply.
end.

ASSIGN l-fn-antecip = CAN-FIND(FIRST funcao
                               WHERE funcao.cd-funcao = "spp-imp-antecip":U
                                 AND funcao.ativo     = YES).

/* Funcionalidade nÆo liberada. */
if NOT l-fn-antecip then do:
   run utp/ut-msgs.p(input "show",
                     input 55283,
                     input return-value).
   apply 'close' to this-procedure.
   return no-apply.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose: Desfaz interface/handles    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF VALID-HANDLE(h-bocx00442) THEN DO:
    DELETE PROCEDURE h-bocx00442.
    ASSIGN h-bocx00442 = ?.
END.
IF VALID-HANDLE(h-bocx00443) THEN DO:
    DELETE PROCEDURE h-bocx00443.
    ASSIGN h-bocx00443 = ?.
END.
IF VALID-HANDLE(h-boad107) THEN DO:                         
    DELETE PROCEDURE h-boad107.                             
    ASSIGN h-boad107 = ?.                                   
END.                                                        
IF VALID-HANDLE(h-boad098) THEN DO:                         
    DELETE PROCEDURE h-boad098.                             
    ASSIGN h-boad098 = ?.                                   
END.                                                                                            
IF VALID-HANDLE(h-boad107) THEN DO:              
    DELETE PROCEDURE h-boad107.                  
    ASSIGN h-boad107 = ?.
END.
IF VALID-HANDLE(h-boun005) THEN DO:
    DELETE PROCEDURE h-boun005.
    ASSIGN h-boun005 = ?.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     Mostrar informa‡äes em tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL {&ttParent} THEN DO:
        APPLY "LEAVE":U TO {&ttParent}.cdn-emitente IN FRAME fPage0.
        APPLY "LEAVE":U TO {&ttParent}.cod-estabel  IN FRAME fPage0.
        APPLY "LEAVE":U TO {&ttParent}.cdn-moeda    IN FRAME fPage0.         
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:    Inicializar campos/objetos padräes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {utp/ut-liter.i "Marca_Todos" *}
    ASSIGN c-marcar = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "Desmarca_Todos" *}
    ASSIGN c-desmarcar = TRIM(RETURN-VALUE).

    ASSIGN btMarca:LABEL IN FRAME fpage1 = c-marcar.

    RUN pi-inicializa-filtro.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
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
    
    DEFINE VARIABLE c-cod-estabel   LIKE {&ttParent}.cod-estabel NO-UNDO.
    DEFINE VARIABLE i-cdd-adiant    LIKE {&ttParent}.cdd-adiant NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-cod-estabel AT ROW 1.21 COL 17.72 COLON-ALIGNED
        i-cdd-adiant  AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Adiantamento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Adiantamento"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
                                         
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-estabel i-cdd-adiant.
        
        /*:T Posiciona query, do DBO, atrav²s dos valores do ­ndice œnico */
        RUN goToKey IN {&hDBOParent} (INPUT c-cod-estabel, INPUT i-cdd-adiant).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i Adiantamento * R}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-estabel i-cdd-adiant btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord.  
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
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
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "cxbo/bocx00442.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00442.p YES}
        {btb/btb008za.i2 cxbo/bocx00442.p '' {&hDBOParent}} 
    END.
    
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "cxbo/bocx00443.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00443.p YES}
        {btb/btb008za.i2 cxbo/bocx00443.p '' {&hDBOSon1}} 
    END.
    
    IF NOT VALID-HANDLE(h-boad098) THEN
        RUN adbo/boad098.p PERSISTENT SET h-boad098.

    IF NOT VALID-HANDLE(h-boad107) THEN
        RUN adbo/boad107na.p PERSISTENT SET h-boad107.
    RUN openQueryStatic IN h-boad107 (INPUT "Main":U) NO-ERROR. 

    IF NOT VALID-HANDLE(h-boun005) THEN
        RUN unbo/boun005.p PERSISTENT SET h-boun005.
    
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

    IF AVAIL tt-adiant-despes THEN DO: 
        {masterdetail/openqueriesson.i &Parent="AdiantDespes"
                                       &Query="Adiantamento"
                                       &PageNumber="1"}           
        
    END.
    ELSE DO:
        EMPTY TEMP-TABLE tt-adiant-despes-parc-aux.
        EMPTY TEMP-TABLE tt-adiant-despes-parc.
        {&OPEN-QUERY-{&page1browse}}
    END.

    RUN pi-cria-browser.

    RUN pi-atualiza-botoes.

    RUN pi-inicializa-filtro.

    APPLY "VALUE-CHANGED":U TO {&page1browse} IN FRAME fPage1.
    {&OPEN-QUERY-{&page1browse}}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-botoes wMasterDetail 
PROCEDURE pi-atualiza-botoes :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza estado e label dos botäes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN btMarca:LABEL IN FRAME fPage1 = IF CAN-FIND(FIRST tt-adiant-despes-parc-aux 
                                                       WHERE tt-adiant-despes-parc-aux.marcar = "":U) 
                                           THEN c-marcar 
                                           ELSE 
                                               IF NOT AVAIL tt-adiant-despes-parc-aux
                                                   THEN c-marcar
                                               ELSE c-desmarcar
           btMarca:SENSITIVE IN FRAME fPage1  = CAN-FIND(FIRST tt-adiant-despes-parc-aux)
           btFilter:SENSITIVE IN FRAME fPage1 = CAN-FIND(FIRST tt-adiant-despes-parc-aux)
           btGera:SENSITIVE IN FRAME fPage1   = CAN-FIND(FIRST tt-adiant-despes-parc-aux).

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-browser wMasterDetail 
PROCEDURE pi-cria-browser :
/*------------------------------------------------------------------------------
  Purpose:     Cria os registros para visualiza‡Æo no browser.
  Parameters:  <none>
  Notes:       Se fez necess rio trabalhar com temp-table auxiliar devido ao 
               campo "marcar"
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-adiant-despes-parc-aux.
    
    FOR EACH tt-adiant-despes-parc:
        CREATE tt-adiant-despes-parc-aux.
        BUFFER-COPY tt-adiant-despes-parc TO tt-adiant-despes-parc-aux.
        ASSIGN tt-adiant-despes-parc-aux.marcar = "".
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-filtro wMasterDetail 
PROCEDURE pi-inicializa-filtro :
/*------------------------------------------------------------------------------
  Purpose:     Coloca as variaveis utilizadas no filtro em seu estado inicial 
  Parameters:  <none>
  Notes:       A cada navegacao de registro o filtro e limpo
------------------------------------------------------------------------------*/
    
    ASSIGN c-cod-parcela-ini      = ""
           c-cod-parcela-fim      = "ZZ"
           c-cod-espec-docto-ini  = ""
           c-cod-espec-docto-fim  = "ZZZ"
           c-cod-ser-docto-ini    = ""
           c-cod-ser-docto-fim    = "ZZZZZ"
           c-cod-refer-ini        = ""
           c-cod-refer-fim        = "ZZZZZZZZZZ"
           c-cod-tit-ap-ini       = ""
           c-cod-tit-ap-fim       = "ZZZZZZZZZZZZZZZZ"
           dt-dat-emissao-ini     = 01/01/1800         
           dt-dat-emissao-fim     = 12/31/9999
           dt-dat-vencto-ini      = 01/01/1800
           dt-dat-vencto-fim      = 12/31/9999
           de-val-adiant-moed-ini = 0.00
           de-val-adiant-moed-fim = 999999999999999.99.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE WinExec  EXTERNAL  "kernel32.dll":
  DEF INPUT PARAM prg_name      AS CHARACTER.
  DEF INPUT PARAM prg_style     AS SHORT.
END PROCEDURE.

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnIdiValor wMasterDetail 
FUNCTION fnIdiValor RETURNS CHARACTER
  (INPUT i-idi-valor AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Atualizar descri‡Æo da forma que a parcela foi gerada: Manual/Autom tica
    Notes:  
------------------------------------------------------------------------------*/

  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {cxinc/i01cx443.i 04 i-idi-valor}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  c-idi-valor = RETURN-VALUE.
  &else
        ASSIGN c-idi-valor = {cxinc/i01cx443.i 04 i-idi-valor}.
  &endif

  RETURN c-idi-valor.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSituacaoParc wMasterDetail 
FUNCTION fnSituacaoParc RETURNS CHARACTER
  ( INPUT c-cod-estabel AS CHAR, 
    INPUT c-cod-refer AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Retorna a situa‡Æo da Antecipa‡Æo no APB
    Notes:  
------------------------------------------------------------------------------*/

    RUN piRetornaSituacaoAPB IN h-bocx00443 (INPUT c-cod-estabel,
                                             INPUT c-cod-refer,
                                             INPUT tt-adiant-despes.cdn-emitente,
                                             OUTPUT c-situacao,
                                             OUTPUT l-gerou-apb,
                                             OUTPUT TABLE tt_retorno_antecip_pef_pend,
                                             OUTPUT TABLE tt_log_erro).

    RETURN c-situacao.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

