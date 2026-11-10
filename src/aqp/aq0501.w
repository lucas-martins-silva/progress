&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0501 2.00.00.016 } /*** 010016 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0501 MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0501
&GLOBAL-DEFINE Version        2.00.00.016
/*&GLOBAL-DEFINE VersionLayout  */

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetros,Digita‡Æo,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2

&GLOBAL-DEFINE page2Widgets   

&GLOBAL-DEFINE page4Widgets   

&GLOBAL-DEFINE page5Widgets   brDigita ~
                              btAdd ~
                              btUpdate ~
                              btDelete ~
                              btSave ~
                              btOpen
			      
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              l-habilitaRtf ~
                              btModelRtf

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo text-rtf text-ModelRtf

&GLOBAL-DEFINE page2Fields    c-cod-regiao-ini c-cod-regiao-fim c-cod-rota-ini c-cod-rota-fim ~
i-cdn-grp-produt-ini i-cdn-grp-produt-fim c-cod-pto-coleta-ini c-cod-pto-coleta-fim ~
i-cdn-produt-rural-ini i-cdn-produt-rural-fim c-cod-propried-ini c-cod-propried-fim

&GLOBAL-DEFINE page4Fields    cb-item c-cod-estabel l-recalcula-sit-conf l-sobrepoe-bon-fix-inf 

&GLOBAL-DEFINE page5Fields    

&GLOBAL-DEFINE page6Fields    cFile cModelRTF

DEFINE VARIABLE cEstabCtrl  AS CHARACTER   NO-UNDO.

/* Parameters Definitions ---                                           */

{aqp/aqapi001.i}  /*temp-tables*/

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

DEFINE VARIABLE h-boad107na AS HANDLE NO-UNDO.  /* estabelec            */
DEFINE VARIABLE h-boin172na AS HANDLE NO-UNDO.  /* item                 */
DEFINE VARIABLE h-boin627   AS HANDLE NO-UNDO.  /* usuar-mater          */
DEFINE VARIABLE h-boin00968 AS HANDLE NO-UNDO.  /* param-aquis-rural    */
DEFINE VARIABLE h-boin00975 AS HANDLE NO-UNDO.  /* rota-coleta          */
DEFINE VARIABLE h-boin00983 AS HANDLE NO-UNDO.  /* item-estab-rural     */
DEFINE VARIABLE h-boin00999 AS HANDLE NO-UNDO.  /* fechto-produt-period */

/* Zoom Smart */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDigita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.cod-rota tt-digita.des-rota   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.cod-rota   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita tt-digita
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY brDigita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-digita


/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brDigita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-cod-propried-fim LIKE regra-form-preco.cod-propried
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-propried-ini LIKE regra-form-preco.cod-propried
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-pto-coleta-fim LIKE regra-form-preco.cod-pto-coleta
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-pto-coleta-ini LIKE regra-form-preco.cod-pto-coleta
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-regiao-fim LIKE regra-form-preco.cod-regiao
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-regiao-ini LIKE regra-form-preco.cod-regiao
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-rota-fim LIKE regra-form-preco.cod-rota
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-rota-ini LIKE regra-form-preco.cod-rota
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-grp-produt-fim LIKE regra-form-preco.cdn-grp-produt
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-grp-produt-ini LIKE regra-form-preco.cdn-grp-produt
     LABEL "Grupo Produtor" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-produt-rural-fim LIKE regra-form-preco.cdn-produt-rural
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-produt-rural-ini LIKE regra-form-preco.cdn-produt-rural
     LABEL "Produtor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 7.88.

DEFINE VARIABLE cb-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-estabel LIKE fechto-produt-period.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-dat-inic AS CHARACTER FORMAT "99/9999" 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item LIKE item.desc-item
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-estabel LIKE estabelec.nome
     VIEW-AS FILL-IN 
     SIZE 41.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 6.88.

DEFINE VARIABLE l-recalcula-sit-conf AS LOGICAL INITIAL no 
     LABEL "Aplica regras pre‡o confirmado" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.86 BY .83 NO-UNDO.

DEFINE VARIABLE l-sobrepoe-bon-fix-inf AS LOGICAL INITIAL no 
     LABEL "Sobrepäe B“nus Fixo Informado" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.86 BY .83 TOOLTIP "Quando marcado, ignora os ajustes feitos pelo AQ0315" NO-UNDO.

DEFINE BUTTON btAdd 
     LABEL "Inserir" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "Retirar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btOpen 
     LABEL "Recuperar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btUpdate 
     LABEL "Alterar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btModelRtf 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cModelRTF AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-ModelRtf AS CHARACTER FORMAT "X(256)":U INITIAL "Modelo:" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-rtf AS CHARACTER FORMAT "X(256)":U INITIAL "Rich Text Format(RTF)" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE RECTANGLE rect-rtf
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 3.21.

DEFINE VARIABLE l-habilitaRtf AS LOGICAL INITIAL no 
     LABEL "RTF" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.cod-rota
      tt-digita.des-rota
ENABLE
tt-digita.cod-rota
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 11.75
         BGCOLOR 15 FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     c-cod-estabel AT ROW 3.92 COL 16.14 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" WIDGET-ID 72
     c-nome-estabel AT ROW 3.92 COL 25.43 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL WIDGET-ID 74
     c-dat-inic AT ROW 4.92 COL 16.14 COLON-ALIGNED HELP
          "Data in¡cio da apura‡Æo" WIDGET-ID 4
     cb-item AT ROW 5.92 COL 16.14 COLON-ALIGNED WIDGET-ID 70
     c-desc-item AT ROW 5.92 COL 34.29 COLON-ALIGNED HELP
          "" NO-LABEL WIDGET-ID 2
     l-recalcula-sit-conf AT ROW 7.71 COL 18.14 WIDGET-ID 76
     l-sobrepoe-bon-fix-inf AT ROW 8.71 COL 18.14 WIDGET-ID 80
     RECT-10 AT ROW 3.38 COL 4.14 WIDGET-ID 56
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 84.43 BY 10.21
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     l-habilitaRtf AT ROW 5.58 COL 3.14
     cModelRTF AT ROW 7.29 COL 3 HELP
          "Nome do arquivo de modelo" NO-LABEL
     btModelRtf AT ROW 7.29 COL 43 HELP
          "Escolha o arquivo de modelo"
     rsExecution AT ROW 9.5 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-rtf AT ROW 5 COL 2 COLON-ALIGNED NO-LABEL
     text-ModelRtf AT ROW 6.54 COL 2 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 8.75 COL 1.14 COLON-ALIGNED NO-LABEL
     rect-rtf AT ROW 5.29 COL 2
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 9 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     c-cod-regiao-ini AT ROW 4.42 COL 16.86 COLON-ALIGNED HELP
          "C¢digo RegiÆo" WIDGET-ID 12
     c-cod-regiao-fim AT ROW 4.42 COL 53.29 COLON-ALIGNED HELP
          "C¢digo RegiÆo" NO-LABEL WIDGET-ID 14
     c-cod-rota-ini AT ROW 5.42 COL 16.86 COLON-ALIGNED HELP
          "C¢digo da rota" WIDGET-ID 24
     c-cod-rota-fim AT ROW 5.42 COL 53.29 COLON-ALIGNED HELP
          "C¢digo da rota" NO-LABEL WIDGET-ID 26
     i-cdn-grp-produt-ini AT ROW 6.42 COL 16.86 COLON-ALIGNED HELP
          "" WIDGET-ID 28
          LABEL "Grupo Produtor"
     i-cdn-grp-produt-fim AT ROW 6.42 COL 53.29 COLON-ALIGNED HELP
          "" NO-LABEL WIDGET-ID 30
     i-cdn-produt-rural-ini AT ROW 7.42 COL 16.86 COLON-ALIGNED HELP
          "Produtor Rural" WIDGET-ID 48
          LABEL "Produtor"
     i-cdn-produt-rural-fim AT ROW 7.42 COL 53.29 COLON-ALIGNED HELP
          "Produtor Rural" NO-LABEL WIDGET-ID 50
     c-cod-propried-ini AT ROW 8.42 COL 16.86 COLON-ALIGNED HELP
          "C¢digo Propriedade" WIDGET-ID 60
     c-cod-propried-fim AT ROW 8.42 COL 53.29 COLON-ALIGNED HELP
          "C¢digo Propriedade" NO-LABEL WIDGET-ID 62
     c-cod-pto-coleta-ini AT ROW 9.42 COL 16.86 COLON-ALIGNED HELP
          "C¢digo Ponto Coleta" WIDGET-ID 40
     c-cod-pto-coleta-fim AT ROW 9.42 COL 53.29 COLON-ALIGNED HELP
          "C¢digo Ponto Coleta" NO-LABEL WIDGET-ID 46
     IMAGE-3 AT ROW 4.42 COL 37.29 WIDGET-ID 16
     IMAGE-4 AT ROW 4.42 COL 50.86 WIDGET-ID 18
     IMAGE-5 AT ROW 5.42 COL 37.29 WIDGET-ID 20
     IMAGE-6 AT ROW 5.42 COL 50.86 WIDGET-ID 22
     IMAGE-7 AT ROW 6.42 COL 37.29 WIDGET-ID 32
     IMAGE-8 AT ROW 6.42 COL 50.86 WIDGET-ID 34
     IMAGE-9 AT ROW 7.42 COL 37.29 WIDGET-ID 36
     IMAGE-10 AT ROW 7.42 COL 50.86 WIDGET-ID 38
     IMAGE-11 AT ROW 8.42 COL 37.29 WIDGET-ID 44
     IMAGE-12 AT ROW 8.42 COL 50.86 WIDGET-ID 42
     IMAGE-13 AT ROW 9.42 COL 37.29 WIDGET-ID 52
     IMAGE-14 AT ROW 9.42 COL 50.86 WIDGET-ID 54
     RECT-11 AT ROW 3.38 COL 4.14 WIDGET-ID 58
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.58
         SIZE 84.43 BY 12.17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     btAdd AT ROW 13.08 COL 1
     btUpdate AT ROW 13.08 COL 16
     btDelete AT ROW 13.08 COL 31
     btSave AT ROW 13.08 COL 46
     btOpen AT ROW 13.08 COL 61
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 13.21
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.14
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-propried-fim IN FRAME fPage2
   LIKE = mgcad.regra-form-preco.cod-propried EXP-SIZE                  */
/* SETTINGS FOR FILL-IN c-cod-propried-ini IN FRAME fPage2
   LIKE = mgcad.regra-form-preco.cod-propried EXP-SIZE                  */
/* SETTINGS FOR FILL-IN c-cod-pto-coleta-fim IN FRAME fPage2
   LIKE = mgcad.regra-form-preco.cod-pto-coleta EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN c-cod-pto-coleta-ini IN FRAME fPage2
   LIKE = mgcad.regra-form-preco.cod-pto-coleta EXP-SIZE                */
/* SETTINGS FOR FILL-IN c-cod-regiao-fim IN FRAME fPage2
   LIKE = mgcad.regra-form-preco.cod-regiao EXP-SIZE                    */
/* SETTINGS FOR FILL-IN c-cod-regiao-ini IN FRAME fPage2
   LIKE = mgcad.regra-form-preco.cod-regiao EXP-SIZE                    */
/* SETTINGS FOR FILL-IN c-cod-rota-fim IN FRAME fPage2
   LIKE = mgcad.regra-form-preco.cod-rota EXP-SIZE                      */
/* SETTINGS FOR FILL-IN c-cod-rota-ini IN FRAME fPage2
   LIKE = mgcad.regra-form-preco.cod-rota EXP-SIZE                      */
/* SETTINGS FOR FILL-IN i-cdn-grp-produt-fim IN FRAME fPage2
   LIKE = mgcad.regra-form-preco.cdn-grp-produt EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN i-cdn-grp-produt-ini IN FRAME fPage2
   LIKE = mgcad.regra-form-preco.cdn-grp-produt EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN i-cdn-produt-rural-fim IN FRAME fPage2
   LIKE = mgcad.regra-form-preco.cdn-produt-rural EXP-LABEL EXP-SIZE    */
/* SETTINGS FOR FILL-IN i-cdn-produt-rural-ini IN FRAME fPage2
   LIKE = mgcad.regra-form-preco.cdn-produt-rural EXP-LABEL EXP-SIZE    */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME fPage4
   LIKE = mgmov.fechto-produt-period.cod-estabel EXP-SIZE               */
/* SETTINGS FOR FILL-IN c-dat-inic IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME fPage4
   LIKE = mgcad.item.desc-item EXP-SIZE                                 */
/* SETTINGS FOR FILL-IN c-nome-estabel IN FRAME fPage4
   LIKE = mgcad.estabelec.nome EXP-LABEL EXP-SIZE                       */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       btModelRtf:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       cModelRTF:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-ModelRtf:HIDDEN IN FRAME fPage6           = TRUE
       text-ModelRtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Modelo:".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

ASSIGN 
       text-rtf:HIDDEN IN FRAME fPage6           = TRUE
       text-rtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Rich Text Format(RTF)".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita
/* Query rebuild information for BROWSE brDigita
     _START_FREEFORM
OPEN QUERY brDigita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDigita
&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON DEL OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btDelete in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON END-ERROR OF brDigita IN FRAME fPage5
ANYWHERE 
DO:
    if  brDigita:new-row in frame fPage5 then do:
        if  avail tt-digita then
            delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then. 
    end.                                                               
    else do:
        get current brDigita.
        display tt-digita.cod-rota
                tt-digita.des-rota with browse brDigita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ENTER OF brDigita IN FRAME fPage5
ANYWHERE
DO:
  apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON INS OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-END OF brDigita IN FRAME fPage5
DO:
   apply 'entry' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-HOME OF brDigita IN FRAME fPage5
DO:
  apply 'entry' to btOpen in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-ENTRY OF brDigita IN FRAME fPage5
DO:
   /*:T trigger para inicializar campos da temp table de digita‡Æo */
   if  brDigita:new-row in frame fPage5 then do:
       /*assign tt-digita.exemplo:screen-value in browse brDigita = string(today, "99/99/9999":U).*/
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
    
    DEFINE VARIABLE c-des-rota LIKE tt-digita.des-rota NO-UNDO.
    /*:T  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */
    
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse brDigita tt-digita.cod-rota
               input browse brDigita tt-digita.des-rota.

        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-digita then
            assign input browse brDigita tt-digita.cod-rota
                   input browse brDigita tt-digita.des-rota.
    end.


    IF AVAIL tt-digita THEN DO:
        RUN goToKey IN h-boin00975(INPUT tt-digita.cod-rota).
        
        IF RETURN-VALUE = "OK":U THEN
            RUN getCharField IN h-boin00975(INPUT 'des-rota', OUTPUT c-des-rota).
        
        IF RETURN-VALUE = "OK":U THEN
            ASSIGN tt-digita.des-rota = c-des-rota.
        ELSE
            ASSIGN tt-digita.des-rota = "".
        
        display tt-digita.cod-rota
                tt-digita.des-rota with browse brDigita.  
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fPage5 /* Inserir */
DO:
    assign btUpdate:SENSITIVE in frame fPage5 = yes
           btDelete:SENSITIVE in frame fPage5 = yes
           btSave:SENSITIVE   in frame fPage5 = yes.
    
    if num-results("brDigita":U) > 0 then
        brDigita:INSERT-ROW("after":U) in frame fPage5.
    else do transaction:
        create tt-digita.
        
        open query brDigita for each tt-digita.
        
        apply "entry":U to tt-digita.cod-rota in browse brDigita. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wReport
ON CHOOSE OF btConfigImpr IN FRAME fPage6
DO:
   {report/rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wReport
ON CHOOSE OF btDelete IN FRAME fPage5 /* Retirar */
DO:
    if  brDigita:num-selected-rows > 0 then do on error undo, return no-apply:
        get current brDigita.
        delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then.
    end.
    
    if num-results("brDigita":U) = 0 then
        assign btUpdate:SENSITIVE in frame fPage5 = no
               btDelete:SENSITIVE in frame fPage5 = no
               btSave:SENSITIVE   in frame fPage5 = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wReport
ON CHOOSE OF btFile IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btModelRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModelRtf wReport
ON CHOOSE OF btModelRtf IN FRAME fPage6
DO:
    def var cFile as char no-undo.
    def var l-ok  as logical no-undo.

    assign cModelRTF = replace(input frame {&frame-name} cModelRTF, "/", "~\").
    SYSTEM-DIALOG GET-FILE cFile
       FILTERS "*.rtf" "*.rtf",
               "*.*" "*.*"
       DEFAULT-EXTENSION "rtf"
       INITIAL-DIR "modelos" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign cModelRTF:screen-value in frame {&frame-name}  = replace(cFile, "~\", "/"). 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOpen wReport
ON CHOOSE OF btOpen IN FRAME fPage5 /* Recuperar */
DO:
    {report/rprcd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wReport
ON CHOOSE OF btSave IN FRAME fPage5 /* Salvar */
DO:
   {report/rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wReport
ON CHOOSE OF btUpdate IN FRAME fPage5 /* Alterar */
DO:
   apply 'entry' to tt-digita.cod-rota in browse brDigita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON LEAVE OF c-cod-estabel IN FRAME fPage4 /* Estabelecimento */
DO:

    IF cEstabCtrl <> c-cod-estabel:SCREEN-VALUE IN FRAME fPage4 THEN DO:
    
        ASSIGN cEstabCtrl = c-cod-estabel:SCREEN-VALUE IN FRAME fPage4.

        {method/ReferenceFields.i &HandleDBOLeave="h-boad107na"
                                  &KeyValue1="c-cod-estabel:SCREEN-VALUE IN FRAME fPage4"
                                  &FieldName1="nome"
                                  &FieldScreen1="c-nome-estabel"
                                  &Frame1="fPage4"}
         
        DEFINE VARIABLE c-list-pair AS CHARACTER NO-UNDO.
        
        RUN getListItemPairs IN h-boin00983(INPUT c-cod-estabel:SCREEN-VALUE IN FRAME fPage4, OUTPUT c-list-pair).
        
        ASSIGN cb-item:LIST-ITEM-PAIRS IN FRAME fPage4   = c-list-pair
                   cb-item:SCREEN-VALUE    IN FRAME fPage4   = ENTRY (1,c-list-pair).
        
        /*período a ser fechado conforme estabelecimento selecionado*/
        RUN piBuscarPeriodo IN THIS-PROCEDURE.
        /************************************************************/
        
        APPLY "ENTRY":U TO cb-item IN FRAME fPage4.
        APPLY "VALUE-CHANGED":U TO cb-item IN FRAME fPage4.

    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fPage4 /* Estabelecimento */
OR F5 OF c-cod-estabel IN FRAME fPage4
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z01in00983.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="c-cod-estabel"
                         &Frame1="fPage4"
                         &EnableImplant="NO"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-item wReport
ON VALUE-CHANGED OF cb-item IN FRAME fPage4 /* Item */
DO: 
    DEFINE VARIABLE pDescItem    AS CHARACTER NO-UNDO.

    RUN goToKey IN h-boin172na (INPUT cb-item:SCREEN-VALUE IN FRAME fPage4) NO-ERROR.

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN findDescItem IN h-boin00983 (INPUT SELF:SCREEN-VALUE IN FRAME fPage4, OUTPUT pDescItem) NO-ERROR. 
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage4 = pDescItem.
    END.
    ELSE 
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage4 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME l-habilitaRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-habilitaRtf wReport
ON VALUE-CHANGED OF l-habilitaRtf IN FRAME fPage6 /* RTF */
DO:
    &IF "{&RTF}":U = "YES":U &THEN
    RUN pi-habilitaRtf.  
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME l-recalcula-sit-conf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-recalcula-sit-conf wReport
ON VALUE-CHANGED OF l-recalcula-sit-conf IN FRAME fPage4 /* Aplica regras pre‡o confirmado */
DO:
  
    IF NOT l-recalcula-sit-conf:CHECKED IN FRAME fPage4 THEN
        ASSIGN l-sobrepoe-bon-fix-inf:CHECKED IN FRAME fPage4 = NO.
    
    ASSIGN l-sobrepoe-bon-fix-inf:SENSITIVE = l-recalcula-sit-conf:CHECKED IN FRAME fPage4.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
do  with frame fPage6:
    case self:screen-value:
        when "1":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   /*Alterado 15/02/2005 - tech1007 - Alterado para suportar adequadamente com a 
                     funcionalidade de RTF*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = NO
                   l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                   l-habilitaRtf = NO
                   &endif
                   .
                   /*Fim alteracao 15/02/2005*/
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
            /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
            &IF "{&RTF}":U = "YES":U &THEN
            IF VALID-HANDLE(hWenController) THEN DO:
                ASSIGN l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                       l-habilitaRtf = NO.
            END.
            &endif
            /*Fim alteracao 15/02/2005*/
        END.
        /*Alterado 15/02/2005 - tech1007 - Condi‡Æo removida pois RTF nÆo ‚ mais um destino
        when "4":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   text-ModelRtf:VISIBLE   = YES
                   rect-rtf:VISIBLE       = YES
                   blModelRtf:VISIBLE       = yes.
        end.
        Fim alteracao 15/02/2005*/
    end case.
end.
&IF "{&RTF}":U = "YES":U &THEN
RUN pi-habilitaRtf.  
&endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

tt-digita.cod-rota:load-mouse-pointer("image/lupa.cur") in browse brDigita.
c-cod-estabel:load-mouse-pointer("image/lupa.cur") in FRAME fPage4.

ON MOUSE-SELECT-DBLCLICK OF tt-digita.cod-rota IN BROWSE brDigita
OR F5 OF tt-digita.cod-rota IN BROWSE brDigita
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z01in00975.w"
                         &FieldZoom1="cod-rota"
                         &FieldScreen1="tt-digita.cod-rota"
                         &BROWSE1="brDigita"
                         &EnableImplant="NO"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wReport 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* estabelec            */
IF VALID-HANDLE(h-boad107na) THEN DO:
    DELETE PROCEDURE h-boad107na.
    ASSIGN h-boad107na = ?.
END.

/* item                 */
IF VALID-HANDLE(h-boin172na) THEN DO:
    DELETE PROCEDURE h-boin172na.
    ASSIGN h-boin172na = ?.
END.

/* usuar-mater          */
IF VALID-HANDLE(h-boin627) THEN DO:
    DELETE PROCEDURE h-boin627.
    ASSIGN h-boin627 = ?.
END.

/* param-aquis-rural    */
IF VALID-HANDLE(h-boin00968) THEN DO:
    DELETE PROCEDURE h-boin00968.
    ASSIGN h-boin00968 = ?.
END.

/* rota-coleta          */
IF VALID-HANDLE(h-boin00975) THEN DO:
    DELETE PROCEDURE h-boin00975.
    ASSIGN h-boin00975 = ?.
END.

/* item-estab-rural     */
IF VALID-HANDLE(h-boin00983) THEN DO:
    DELETE PROCEDURE h-boin00983.
    ASSIGN h-boin00983 = ?.
END.

/* fechto-produt-period */
IF VALID-HANDLE(h-boin00999) THEN DO:
    DELETE PROCEDURE h-boin00999.
    ASSIGN h-boin00999 = ?.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializa‡Æo
  correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/
&IF "{&RTF}":U = "YES":U &THEN
IF VALID-HANDLE(hWenController) THEN DO:
    ASSIGN l-habilitaRtf:sensitive IN FRAME fPage6 = NO
           l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
           l-habilitaRtf = NO.
           
END.
RUN pi-habilitaRtf.
&endif
/*Fim alteracao 17/02/2005*/

RUN piValPadrao.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wReport 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN initializeDBOs.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wReport 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* estabelec            */
IF NOT VALID-HANDLE(h-boad107na) THEN DO: 
        {btb/btb008za.i1 adbo/boad107na.p}
        {btb/btb008za.i2 adbo/boad107na.p '' h-boad107na}
END.
RUN openQueryStatic IN h-boad107na (INPUT "Main":U).
/************************/


/* item                 */
IF NOT VALID-HANDLE(h-boin172na) THEN DO: 
        {btb/btb008za.i1 inbo/boin172na.p}
        {btb/btb008za.i2 inbo/boin172na.p '' h-boin172na}
END.
RUN openQueryStatic IN h-boin172na (INPUT "Main":U).
/************************/


/* usuar-mater          */
IF NOT VALID-HANDLE(h-boin627) THEN DO:
        {btb/btb008za.i1 inbo/boin627.p}
        {btb/btb008za.i2 inbo/boin627.p '' h-boin627}
END.
/************************/


/* param-aquis-rural    */
IF NOT VALID-HANDLE(h-boin00968) THEN DO:
        {btb/btb008za.i1 inbo/boin00968.p}
        {btb/btb008za.i2 inbo/boin00968.p '' h-boin00968}
END.
RUN openQueryStatic IN h-boin00968 (INPUT "Main":U).
/************************/

/* rota-coleta          */
IF NOT VALID-HANDLE(h-boin00975) THEN DO:
        {btb/btb008za.i1 inbo/boin00975.p}
        {btb/btb008za.i2 inbo/boin00975.p '' h-boin00975}
END.
RUN openQueryStatic IN h-boin00975 (INPUT "Main":U).
/************************/


/* item-estab-rural     */
IF NOT VALID-HANDLE(h-boin00983) THEN DO:
        {btb/btb008za.i1 inbo/boin00983.p}
        {btb/btb008za.i2 inbo/boin00983.p '' h-boin00983}
END.
RUN openQueryStatic IN h-boin00983 (INPUT "Main":U).
/************************/

 
/* fechto-produt-period */
IF NOT VALID-HANDLE(h-boin00999) THEN DO:
        {btb/btb008za.i1 inbo/boin00999.p}
        {btb/btb008za.i2 inbo/boin00999.p '' h-boin00999}
END.
RUN openQueryStatic IN h-boin00999 (INPUT "Main":U).
/************************/

    
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-valores wReport 
PROCEDURE pi-verifica-valores :
/*------------------------------------------------------------------------------
  Purpose: Verificar valores digitados pelo usuário na tela.     
------------------------------------------------------------------------------*/

DEFINE VARIABLE c-txt-menor AS CHARACTER NO-UNDO.
{utp/ut-liter.i "menor" *}
ASSIGN c-txt-menor = TRIM(RETURN-VALUE).

DEFINE VARIABLE c-txt-maior AS CHARACTER NO-UNDO.
{utp/ut-liter.i "maior" *}
ASSIGN c-txt-maior = TRIM(RETURN-VALUE).

    /** Tratamento mês entre jan e dez **/
    DO WITH FRAME fPage4:
        IF INT(SUBSTRING(c-dat-inic:SCREEN-VALUE,1,2)) < 1   THEN DO:
            RUN utp/ut-msgs.p (input "show":U,
                               input 706,
                               input c-txt-menor + "~~" + '01').
            APPLY "ENTRY":U TO c-dat-inic.
            RETURN ERROR.
        END.
        IF INT(SUBSTRING(c-dat-inic:SCREEN-VALUE,1,2)) > 12   THEN DO:
            RUN utp/ut-msgs.p (input "show":U,
                               input 706,
                               input c-txt-maior + "~~" + '12').
            APPLY "ENTRY":U TO c-dat-inic.
            RETURN ERROR.
        END.
    END.
    
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscarPeriodo wReport 
PROCEDURE piBuscarPeriodo :
/*------------------------------------------------------------------------------
  Purpose: Setar os valores iniciais para sele‡Æo.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  VALID-HANDLE(h-boin00968) THEN DO:
        
        RUN goToKey IN h-boin00968 (INPUT INPUT FRAME fPage4 c-cod-estabel).
        IF RETURN-VALUE = "OK":U THEN DO:
        
            RUN getCharField IN h-boin00968 (INPUT  "cod-periodo",
                                             OUTPUT c-dat-inic).
           
                IF c-dat-inic <> "" THEN DO:   /*ao fechar per¡odo, busca £ltimo per¡odo fechado, e ir  fechar o pr¢ximo*/
                    ASSIGN c-dat-inic:SCREEN-VALUE IN FRAME fPage4 = IF INT(SUBSTRING(c-dat-inic,1,2)) < 9
                                                                       THEN "0" + STRING(INT(SUBSTRING(c-dat-inic,1,2)) + 1) + SUBSTRING(c-dat-inic,3,4)
                                                                       ELSE IF INT(SUBSTRING(c-dat-inic,1,2)) < 12 
                                                                       THEN STRING(INT(SUBSTRING(c-dat-inic,1,2)) + 1) + SUBSTRING(c-dat-inic,3,4)    
                                                                       ELSE "01" +  STRING(INT(SUBSTRING(c-dat-inic,3,4)) + 1).
                END.
                ELSE DO: /*caso nÆo encontre (primeira execu‡Æo) ir  verificar a £ltima fechto*/

                    RUN setConstraintEstabel IN h-boin00999 (INPUT INPUT FRAME fPage4 c-cod-estabel) NO-ERROR.
                    RUN openQueryStatic      IN h-boin00999 (INPUT "Estabel":U) NO-ERROR.    
                    RUN getLast              IN h-boin00999 NO-ERROR.
                    
                    IF RETURN-VALUE = "OK":U THEN DO:
                        
                        RUN getCharField IN h-boin00999 (INPUT  "cod-period",
                                                         OUTPUT c-dat-inic).
                        ASSIGN c-dat-inic:SCREEN-VALUE IN FRAME fPage4 = c-dat-inic.

                    END.

                END.
            
        END.
        ELSE    
            ASSIGN c-dat-inic:SCREEN-VALUE IN FRAME fPage4 = "".

    END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define var r-tt-digita as rowid no-undo.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    /*15/02/2005 - tech1007 - Teste alterado pois RTF nÆo ‚ mais op‡Æo de Destino*/
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    
    /*16/02/2005 - tech1007 - Teste alterado para validar o modelo informado quando for RTF*/
    &IF "{&RTF}":U = "YES":U &THEN
    IF ( input frame fPage6 cModelRTF = "" AND
         input frame fPage6 l-habilitaRtf = YES ) OR
       ( SEARCH(INPUT FRAME fPage6 cModelRTF) = ? AND
         input frame fPage6 rsExecution = 1 AND
         input frame fPage6 l-habilitaRtf = YES )
         THEN DO:
        run utp/ut-msgs.p (input "show":U, input 73, input "":U).
        /*30/12/2004 - tech1007 - Evento removido pois causa problemas no WebEnabler*/
        /*apply "CHOOSE":U to blModelRtf in frame fPage6.*/
        return error.
    END.
    &endif
    
    /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).
        
        /*:T Valida‡Æo de duplicidade de registro na temp-table tt-digita */
        find first b-tt-digita 
            where b-tt-digita.cod-rota = tt-digita.cod-rota 
              and rowid(b-tt-digita) <> rowid(tt-digita) 
            no-lock no-error.
        if  avail b-tt-digita then do:
            reposition brDigita to rowid rowid(b-tt-digita).
            
            run utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
            apply "ENTRY":U to tt-digita.cod-rota in browse brDigita.
            
            return error.
        end.
        
        /*:T As demais valida‡äes devem ser feitas aqui */
        if  tt-digita.cod-rota = "" then do:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.cod-rota:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.
           
            {utp/ut-liter.i Rota *}
            run utp/ut-msgs.p (input "SHOW":U, input 17677, input return-value).
            apply "ENTRY":U to tt-digita.cod-rota in browse brDigita.
            
            return error.
        end.
        
    end.
    
    
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */
    RUN pi-verifica-valores.
    
    DEFINE VARIABLE da-data-inicial AS DATE. /*variável auxiliar para cálculo da data*/
    ASSIGN da-data-inicial = DATE("01/" + c-dat-inic:SCREEN-VALUE IN FRAME fPage4).
    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    CREATE tt-param.
    ASSIGN tt-param.destino                   = input frame fPage6 rsDestiny
           tt-param.usuario                   = c-seg-usuario
           tt-param.data-exec                 = TODAY
           tt-param.hora-exec                 = TIME
           &IF "{&RTF}":U = "YES":U &THEN     
               tt-param.modelo                = INPUT FRAME fPage6 cModelRTF
               tt-param.l-habilitaRtf         = INPUT FRAME fPage6 l-habilitaRtf
           &endif                             
           tt-param.cod-period                = INPUT FRAME fpage4 c-dat-inic
           tt-param.da-dat-ini                = da-data-inicial  /*primeiro dia do mês digitado em tela*/
           tt-param.da-dat-fim                = IF INT(SUBSTRING(c-dat-inic:SCREEN-VALUE,1,2)) < 12 
                                                THEN DATE("01/" + STRING(MONTH(da-data-inicial) + 1) + "/" + STRING(YEAR(da-data-inicial))) - 1 /* último dia do mês */
                                                ELSE DATE("31/" +         "12"                       + "/" + STRING(YEAR(da-data-inicial)))     /* digitado em tela  */
           tt-param.it-codigo                 = cb-item:SCREEN-VALUE              IN FRAME fpage4  
           tt-param.cod-estabel-ini           = c-cod-estabel:SCREEN-VALUE        IN FRAME fPage4
           tt-param.cod-estabel-fim           = c-cod-estabel:SCREEN-VALUE        IN FRAME fPage4
           tt-param.cod-regiao-ini            = c-cod-regiao-ini:SCREEN-VALUE     IN FRAME fPage2
           tt-param.cod-regiao-fim            = c-cod-regiao-fim:SCREEN-VALUE     IN FRAME fPage2
           tt-param.cod-rota-ini              = c-cod-rota-ini:SCREEN-VALUE       IN FRAME fPage2
           tt-param.cod-rota-fim              = c-cod-rota-fim:SCREEN-VALUE       IN FRAME fPage2
           tt-param.cdn-grp-produt-ini        = INTEGER(i-cdn-grp-produt-ini:SCREEN-VALUE   IN FRAME fPage2)
           tt-param.cdn-grp-produt-fim        = INTEGER(i-cdn-grp-produt-fim:SCREEN-VALUE   IN FRAME fPage2)
           tt-param.cdn-produt-rural-ini      = INTEGER(i-cdn-produt-rural-ini:SCREEN-VALUE IN FRAME fPage2)
           tt-param.cdn-produt-rural-fim      = INTEGER(i-cdn-produt-rural-fim:SCREEN-VALUE IN FRAME fPage2)
           tt-param.cod-propried-ini          = c-cod-propried-ini:SCREEN-VALUE     IN FRAME fPage2
           tt-param.cod-propried-fim          = c-cod-propried-fim:SCREEN-VALUE     IN FRAME fPage2
           tt-param.cod-pto-coleta-ini        = c-cod-pto-coleta-ini:SCREEN-VALUE   IN FRAME fPage2
           tt-param.cod-pto-coleta-fim        = c-cod-pto-coleta-fim:SCREEN-VALUE   IN FRAME fPage2
           tt-param.recalcula-sit-conf        = l-recalcula-sit-conf:CHECKED        IN FRAME fPage4
           tt-param.sobrepoe-bon-fix-inf      = l-sobrepoe-bon-fix-inf:CHECKED      IN FRAME fPage4
           .
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i aqp/aq0501rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ELSE
    /*Tratamento para PGIMP*/
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValPadrao wReport 
PROCEDURE piValPadrao :
/*------------------------------------------------------------------------------
  Purpose: Setar os valores iniciais para sele‡Æo.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-list   AS CHARACTER NO-UNDO.
    
    /*item padrão do estabelecimento do usuário*/
    RUN findUsuar_mater IN h-boin627 (INPUT c-seg-usuario, OUTPUT c-cod-estabel).

    IF c-cod-estabel = "" THEN DO:
        RUN getCharField IN h-boin627 (INPUT 'char-1', OUTPUT c-cod-estabel).
         ASSIGN c-cod-estabel = SUBSTR(c-cod-estabel,16,5). /* estab usuar */
    END.

    RUN getListItems IN h-boin00983(INPUT c-cod-estabel, OUTPUT c-list).

    IF c-list <> "" THEN DO:
        ASSIGN cb-item:LIST-ITEMS IN FRAME fPage4   = c-list
               cb-item:SCREEN-VALUE IN FRAME fPage4 = ENTRY (1,c-list).

        APPLY 'VALUE-CHANGED':U TO cb-item IN FRAME fPage4. 
    END.
        
    APPLY 'VALUE-CHANGED':U TO cb-item       IN FRAME fPage4.
    /*******************************************/

    
    /*estabelecimento padrão do usuário*/
    ASSIGN c-cod-estabel:SCREEN-VALUE IN FRAME fPage4 = c-cod-estabel.
    APPLY "LEAVE":U TO c-cod-estabel IN FRAME fPage4.
    /***********************************/
    

    /*período a ser fechado conforme estabelecimento selecionado*/
    RUN piBuscarPeriodo IN THIS-PROCEDURE.
    /************************************************************/

    ASSIGN c-cod-regiao-fim:SCREEN-VALUE         IN FRAME fPage2 = FILL('Z', 12)
           c-cod-rota-fim:SCREEN-VALUE           IN FRAME fPage2 = FILL('Z', 12)
           i-cdn-grp-produt-fim:SCREEN-VALUE     IN FRAME fPage2 = FILL('9', 6)
           i-cdn-produt-rural-fim:SCREEN-VALUE   IN FRAME fPage2 = FILL('9', 9)
           c-cod-propried-fim:SCREEN-VALUE       IN FRAME fPage2 = FILL('Z', 16)
           c-cod-pto-coleta-fim:SCREEN-VALUE     IN FRAME fPage2 = FILL('Z', 12).

    APPLY "ENTRY":U TO cb-item IN FRAME fPage4.
    APPLY "VALUE-CHANGED":U TO l-recalcula-sit-conf IN FRAME fPage4.

    ASSIGN cEstabCtrl = c-cod-estabel.    

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

