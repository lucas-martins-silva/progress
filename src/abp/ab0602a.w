&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-eqpto NO-UNDO LIKE mab-eqpto
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0602A 2.00.00.007 } /*** "010007" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0602a MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
******************************************************************************/

{include/i_fnctrad.i}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0602A
&GLOBAL-DEFINE Version        2.00.00.005

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Dados, Inc. Controle, Document

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            no 
&GLOBAL-DEFINE Copy           no
&GLOBAL-DEFINE Update         no
&GLOBAL-DEFINE Delete         no
&GLOBAL-DEFINE Undo           no
&GLOBAL-DEFINE Cancel         no
&GLOBAL-DEFINE Save           no

&GLOBAL-DEFINE ttTable        tt-mab-eqpto
&GLOBAL-DEFINE hDBOTable      hDboEqpto
&GLOBAL-DEFINE DBOTable       mab-eqpto


&GLOBAL-DEFINE page0KeyFields tt-mab-eqpto.ep-codigo tt-mab-eqpto.cod-eqpto
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields tt-mab-eqpto.idi-tip-eqpto tt-mab-eqpto.cod-model ~
                           tt-mab-eqpto.cod-estrut-mec tt-mab-eqpto.cod-sit-eqpto ~
                           tt-mab-eqpto.dat-situacao tt-mab-eqpto.idi-tip-propriet tt-mab-eqpto.cod-emitente ~
                           tt-mab-eqpto.bm-codigo tt-mab-eqpto.bm-indice 
&GLOBAL-DEFINE page2Fields tt-mab-eqpto.dat-inicial tt-mab-eqpto.val-hodom-horim-inicial tt-mab-eqpto.val-km-inicial tt-mab-eqpto.cod-estabel tt-mab-eqpto.cod-grp-eqpto tt-mab-eqpto.cc-codigo  tt-mab-eqpto.ct-codigo tt-mab-eqpto.cod-ccusto-alter tt-mab-eqpto.log-cont-sec tt-mab-eqpto.val-hodom-horim-sec tt-mab-eqpto.val-km-sec tt-mab-eqpto.log-bloq-informa-cont-ord tt-mab-eqpto.cod-cta-ctbl-lubrific tt-mab-eqpto.cod-ccusto-lubrific
&GLOBAL-DEFINE page3Fields tt-mab-eqpto.cod-placa tt-mab-eqpto.cod-chassi tt-mab-eqpto.cod-renavam tt-mab-eqpto.vli-ano-fabric  ~
                           tt-mab-eqpto.vli-ano-model tt-mab-eqpto.dat-compra tt-mab-eqpto.val-compra tt-mab-eqpto.num-livre-2 fiDescFornecedor


/* Parameters Definitions ---                                           */
define input parameter p-ep-codigo like tt-mab-eqpto.ep-codigo. 
define input parameter p-cod-eqpto like tt-mab-eqpto.cod-eqpto. 

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-mostra-cta-patr AS LOGICAL INITIAL NO NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

define variable hDBOModelo    as handle no-undo.
define variable hDBOEstrutura as handle no-undo.
define variable hDBOSituacao  as handle no-undo.

DEFINE new global shared VARIABLE c-seg-usuario      as CHAR FORMAT "x(12)" no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-mab-eqpto.ep-codigo tt-mab-eqpto.cod-eqpto 
&Scoped-define ENABLED-TABLES tt-mab-eqpto
&Scoped-define FIRST-ENABLED-TABLE tt-mab-eqpto
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-mab-eqpto.ep-codigo ~
tt-mab-eqpto.cod-eqpto 
&Scoped-define DISPLAYED-TABLES tt-mab-eqpto
&Scoped-define FIRST-DISPLAYED-TABLE tt-mab-eqpto


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

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
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

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

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-desc-emit AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 38.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estrut AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 39.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-modelo AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 39.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-sit AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 39.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cta-patrimonial AS CHARACTER FORMAT "X(18)":U 
     LABEL "Conta Patrimonial" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-usuario AS CHARACTER FORMAT "X(12)":U 
     LABEL "Usu rio" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56.14 BY 1.5.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 1.5.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67 BY 1.25.

DEFINE VARIABLE fiAtual AS CHARACTER FORMAT "X(256)":U INITIAL "Dados Atuais" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE fidescEstab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescGrupo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiUnModel AS CHARACTER FORMAT "xx":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiUnModelSec AS CHARACTER FORMAT "XX":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67 BY 6.

DEFINE VARIABLE fiDescFornecedor AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26 BY 3.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
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
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-mab-eqpto.ep-codigo AT ROW 2.88 COL 36.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-mab-eqpto.cod-eqpto AT ROW 3.88 COL 36.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.5
         FONT 1.

DEFINE FRAME fPage1
     tt-mab-eqpto.idi-tip-eqpto AT ROW 1.96 COL 16.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Motorizado", 1,
"NÆo Motorizado", 2
          SIZE 42.14 BY .71
     tt-mab-eqpto.cod-model AT ROW 3.04 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-modelo AT ROW 3.04 COL 28.57 COLON-ALIGNED NO-LABEL
     tt-mab-eqpto.cod-estrut-mec AT ROW 4.04 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-estrut AT ROW 4.04 COL 28.57 COLON-ALIGNED NO-LABEL
     tt-mab-eqpto.cod-sit-eqpto AT ROW 5.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-sit AT ROW 5.17 COL 28.57 COLON-ALIGNED NO-LABEL
     tt-mab-eqpto.dat-situacao AT ROW 5.17 COL 68.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-mab-eqpto.idi-tip-propriet AT ROW 7.13 COL 17.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Proprio", 1,
"Terceiro", 2
          SIZE 43.43 BY .71
     tt-mab-eqpto.cod-emitente AT ROW 8.29 COL 20 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-desc-emit AT ROW 8.29 COL 29.57 COLON-ALIGNED NO-LABEL
     tt-mab-eqpto.bm-codigo AT ROW 9.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-mab-eqpto.bm-indice AT ROW 9.5 COL 32.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.86 BY .88
     fi-cta-patrimonial AT ROW 9.5 COL 51 COLON-ALIGNED
     fi-usuario AT ROW 9.5 COL 69 COLON-ALIGNED
     "Tipo Propriet rio" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 6.29 COL 15.57
     "Tipo Equipamento" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 1.17 COL 14.86
     "Propriet rio" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 8.42 COL 14
     RECT-6 AT ROW 1.42 COL 13.86
     RECT-7 AT ROW 6.54 COL 14
     RECT-9 AT ROW 5 COL 14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 84.43 BY 10.38
         FONT 1.

DEFINE FRAME fPage2
     tt-mab-eqpto.dat-inicial AT ROW 1.25 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-mab-eqpto.log-bloq-informa-cont-ord AT ROW 1.25 COL 36.29 WIDGET-ID 2
          LABEL "Bloqueia Informar Contador na OM"
          VIEW-AS TOGGLE-BOX
          SIZE 26.14 BY .71
     tt-mab-eqpto.log-cont-sec AT ROW 1.25 COL 66.43
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .71
     tt-mab-eqpto.val-hodom-horim-inicial AT ROW 2.25 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fiUnModel AT ROW 2.25 COL 26.29 COLON-ALIGNED NO-LABEL
     tt-mab-eqpto.val-hodom-horim-sec AT ROW 2.25 COL 53.57 COLON-ALIGNED
          LABEL "Contador Inicial Secund rio":R32
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fiUnModelSec AT ROW 2.25 COL 65 COLON-ALIGNED NO-LABEL
     tt-mab-eqpto.val-km-inicial AT ROW 3.25 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-mab-eqpto.val-km-sec AT ROW 3.25 COL 53.57 COLON-ALIGNED
          LABEL "Uso Secund rio Inicial":R26
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-mab-eqpto.cod-estabel AT ROW 5.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fidescEstab AT ROW 5.25 COL 27.29 COLON-ALIGNED NO-LABEL
     tt-mab-eqpto.cod-grp-eqpto AT ROW 6.21 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fiDescGrupo AT ROW 6.21 COL 28.43 COLON-ALIGNED NO-LABEL
     tt-mab-eqpto.ct-codigo AT ROW 7.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tt-mab-eqpto.cc-codigo AT ROW 7.17 COL 40.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tt-mab-eqpto.cod-ccusto-lubrific AT ROW 8.08 COL 40.43 COLON-ALIGNED NO-LABEL WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 20 BY .88 TOOLTIP "C¢digo Centro de Custo Lubrifica‡Æo"
     tt-mab-eqpto.cod-cta-ctbl-lubrific AT ROW 8.17 COL 20 COLON-ALIGNED WIDGET-ID 4
          LABEL "Conta Lubrifica‡Æo"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88 TOOLTIP "C¢digo Conta Contabil Lubrifica‡Æo"
     tt-mab-eqpto.cod-ccusto-alter AT ROW 9.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     fiAtual AT ROW 4.46 COL 4.43 COLON-ALIGNED NO-LABEL
     RECT-23 AT ROW 4.75 COL 5
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 84.43 BY 10.38
         FONT 1.

DEFINE FRAME fPage3
     tt-mab-eqpto.cod-placa AT ROW 1.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-mab-eqpto.cod-chassi AT ROW 2.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tt-mab-eqpto.cod-renavam AT ROW 3.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-mab-eqpto.vli-ano-fabric AT ROW 4.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-mab-eqpto.vli-ano-model AT ROW 5.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-mab-eqpto.dat-compra AT ROW 6.88 COL 34.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-mab-eqpto.val-compra AT ROW 7.88 COL 34.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-mab-eqpto.num-livre-2 AT ROW 9.5 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fiDescFornecedor AT ROW 9.5 COL 32.14 COLON-ALIGNED NO-LABEL
     "Compra" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 6.13 COL 27.29
     RECT-8 AT ROW 6.38 COL 25.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 84.43 BY 10.38
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mab-eqpto T "?" NO-UNDO mgfro mab-eqpto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.5
         WIDTH              = 90.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN tt-mab-eqpto.cod-ccusto-lubrific IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-mab-eqpto.cod-cta-ctbl-lubrific IN FRAME fPage2
   EXP-LABEL                                                            */
ASSIGN 
       tt-mab-eqpto.cod-grp-eqpto:READ-ONLY IN FRAME fPage2        = TRUE.

/* SETTINGS FOR TOGGLE-BOX tt-mab-eqpto.log-bloq-informa-cont-ord IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-mab-eqpto.val-hodom-horim-sec IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-mab-eqpto.val-km-sec IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage3
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="frzoom\z01fr007.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-mab-eqpto.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-eqpto.cod-emitente wMaintenance
ON LEAVE OF tt-mab-eqpto.cod-emitente IN FRAME fPage1 /* cod-emitente */
DO:
  {include/leave.i
             &tabela=emitente
             &atributo-ref=nome-emit
             &variavel-ref=c-desc-emit
             &where="emitente.cod-emitente = input frame fPage1 tt-mab-eqpto.cod-emitente"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt-mab-eqpto.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-eqpto.cod-estabel wMaintenance
ON LEAVE OF tt-mab-eqpto.cod-estabel IN FRAME fPage2 /* Estabelecimento */
DO:
  /** Busca Descri‡Æo do estabelecimento **/
    assign fiDescEstab:screen-value in frame fPage2 = "".
    for first estabelec fields(nome)
        where estabelec.cod-estabel = tt-mab-eqpto.cod-estabel:screen-value in frame fPage2 no-lock:
        assign fiDescEstab:screen-value in frame fPage2 = estabelec.nome.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-mab-eqpto.cod-estrut-mec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-eqpto.cod-estrut-mec wMaintenance
ON LEAVE OF tt-mab-eqpto.cod-estrut-mec IN FRAME fPage1 /* Estrutura Mecƒnica */
DO:
     {method\referenceFields.i
        &HandleDBOLeave="hDBOEstrutura"
        &KeyValue1="tt-mab-eqpto.cod-estrut-mec:screen-value in frame fPage1"
        &FieldName1="des-estrut-mec"
        &FieldScreen1="c-desc-estrut"
        &Frame1="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt-mab-eqpto.cod-grp-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-eqpto.cod-grp-eqpto wMaintenance
ON LEAVE OF tt-mab-eqpto.cod-grp-eqpto IN FRAME fPage2 /* Grupo Equipamento */
DO:
    /** Busca Descri‡Æo do Grupo de Equipamento **/
    assign fiDescGrupo:screen-value in frame fPage2 = "".
    for first mab-grp-eqpto fields(cod-grp-eqpto des-grp-eqpto)
        where mab-grp-eqpto.cod-grp-eqpto = tt-mab-eqpto.cod-grp-eqpto:screen-value in frame fPage2 no-lock:
        assign fiDescGrupo:screen-value in frame fPage2 = mab-grp-eqpto.des-grp-eqpto.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-mab-eqpto.cod-model
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-eqpto.cod-model wMaintenance
ON LEAVE OF tt-mab-eqpto.cod-model IN FRAME fPage1 /* Modelo */
DO:
      {method\referenceFields.i
       &HandleDBOLeave="hDBOModelo"
       &KeyValue1="tt-mab-eqpto.cod-model:screen-value in frame fPage1"
       &FieldName1="des-model"
       &FieldScreen1="c-desc-modelo"
       &Frame1="fPage1"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mab-eqpto.cod-sit-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-eqpto.cod-sit-eqpto wMaintenance
ON LEAVE OF tt-mab-eqpto.cod-sit-eqpto IN FRAME fPage1 /* Situa‡Æo */
DO:
    {method\ReferenceFields.i
        &HandleDBOLeave="hDBOSituacao"
        &KeyValue1="tt-mab-eqpto.cod-sit-eqpto"
        &FieldName1="des-sit-eqpto"
        &FieldScreen1="c-desc-sit"
        &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME tt-mab-eqpto.num-livre-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-eqpto.num-livre-2 wMaintenance
ON LEAVE OF tt-mab-eqpto.num-livre-2 IN FRAME fPage3 /* Livre 2 */
DO:
            {include/leave.i
             &tabela=emitente
             &atributo-ref=nome-emit
             &variavel-ref=fiDescFornecedor
             &where="emitente.cod-emitente = input frame fPage3 tt-mab-eqpto.num-livre-2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

apply "leave":U to tt-mab-eqpto.cod-model in frame fPage1.   
apply "leave":U to tt-mab-eqpto.cod-emitente in frame fPage1.   
apply "leave":U to tt-mab-eqpto.cod-estrut-mec in frame fPage1.   
apply "leave":U to tt-mab-eqpto.cod-sit-eqpto in frame fPage1.   
APPLY "leave":U TO tt-mab-eqpto.cod-estabel IN FRAME fPage2.
APPLY "leave":U TO tt-mab-eqpto.cod-grp-eqpto IN FRAME fPage2.
APPLY "leave":U TO tt-mab-eqpto.num-livre-2 IN FRAME fPage3.

IF l-mostra-cta-patr THEN do:
    if AVAIL tt-mab-eqpto THEN
        ASSIGN fi-cta-patrimonial = SUBSTRING(tt-mab-eqpto.cod-livre-1,1,18).
    ELSE
        ASSIGN fi-cta-patrimonial = "":U.
    DISP fi-cta-patrimonial WITH FRAME fPage1.
END.


/** Usuario de inclusÆo ou £ltima altera‡Æo do registro **/
ASSIGN fi-usuario:SCREEN-VALUE IN FRAME fpage1 = tt-mab-eqpto.cod-livre-2.

FOR FIRST mab-eqpto FIELDS (ep-codigo cod-eqpto cod-model)
    WHERE mab-eqpto.ep-codigo = &IF "{&mguni_version}" >= "2.071" &THEN tt-mab-eqpto.ep-codigo:screen-value in frame fPage0 &else INT(tt-mab-eqpto.ep-codigo:screen-value in frame fPage0) &ENDIF
    AND   mab-eqpto.cod-eqpto = tt-mab-eqpto.cod-eqpto:screen-value in frame fPage0 NO-LOCK,
    FIRST mab-model FIELDS (cod-model un )
          WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
    ASSIGN fiUnModel    = mab-model.un
           fiUnModelSec = SUBSTRING(mab-model.cod-livre-1, 1, 2).
    DISP fiUnModel
         fiUnModelSec WITH FRAME fPage2.
END.

if  not tt-mab-eqpto.log-cont-sec then
    assign fiUnModelSec:SCREEN-VALUE IN FRAME fPage2 = "".

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{utp/ut-liter.i "Dados Atuais" *}
ASSIGN fiAtual:SCREEN-VALUE IN FRAME fPage2 = RETURN-VALUE.
{utp/ut-liter.i "Fornecedor" *}
ASSIGN tt-mab-eqpto.num-livre-2:LABEL IN FRAME fPage3 = RETURN-VALUE.
{utp/ut-liter.i Chassi/S‚rie}
assign tt-mab-eqpto.cod-chassi:label in frame fPage3 = return-value.

assign tt-mab-eqpto.ep-codigo:screen-value in frame fPage0 = string(p-ep-codigo)
       tt-mab-eqpto.cod-eqpto:screen-value in frame fPage0 = p-cod-eqpto.

run habilitaCampos in {&hDBOTable} (output l-mostra-cta-patr,
                                    OUTPUT l-mostra-cta-patr).

RUN afterDisplayFields IN THIS-PROCEDURE.

/*Caso integra‡Æo com ems5 esteja implantado, mostrar campo Conta Patrimonial */
IF l-mostra-cta-patr THEN
    ASSIGN fi-cta-patrimonial:HIDDEN IN FRAME fPage1 = FALSE.
ELSE
    ASSIGN fi-cta-patrimonial:HIDDEN IN FRAME fPage1    = TRUE.
       
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
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
    
    DEFINE VARIABLE cep-codigo LIKE {&ttTable}.ep-codigo  VIEW-AS FILL-IN SIZE 05.00 BY 0.88 NO-UNDO.
    DEFINE VARIABLE ccod-eqpto LIKE {&ttTable}.cod-eqpto  VIEW-AS FILL-IN SIZE 16.00 BY 0.88 NO-UNDO.

    
    DEFINE FRAME fGoToRecord
        cep-codigo      AT ROW 1.21 COL 17.72 COLON-ALIGNED
        ccod-eqpto        AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Equipamento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Equipamento"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cep-codigo ccod-eqpto.
        
        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOTable} (INPUT cep-codigo,
                                      input ccod-eqpto).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Equipamento" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     initializeDBOs
  Parameters:  <none>
  Notes:       Inicializa as BOs no programa
------------------------------------------------------------------------------*/


    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo~\bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.



    
    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.


    /*--- DBO Estrutura ---*/
    IF NOT VALID-HANDLE(hDBOEstrutura) OR
       hDBOEstrutura:TYPE <> "PROCEDURE":U OR
       hDBOEstrutura:FILE-NAME <> "frbo~\bofr009.p":U THEN DO:
        run frbo/bofr009.p persistent set  hDBOEstrutura.
    END.
    
    RUN openQueryStatic IN hDBOEstrutura (INPUT "Main":U) NO-ERROR.
    

    /*--- DBO Situa‡Æo ---*/
    IF NOT VALID-HANDLE(hDBOSituacao) OR
       hDBOSituacao:TYPE <> "PROCEDURE":U OR
       hDBOSituacao:FILE-NAME <> "frbo~\bofr024.p":U THEN DO:
        run frbo/bofr024.p persistent set  hDBOSituacao.
    END.
    
    RUN openQueryStatic IN hDBOSituacao (INPUT "Main":U) NO-ERROR.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

