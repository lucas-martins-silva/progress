&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i IM0440 2.00.00.002 } /*** 010002 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0440 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0440
&GLOBAL-DEFINE Version        2.00.00.001
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,Classificaá∆o,ParÉmetro,Digitaá∆o,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          YES
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   rsClassif
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
                              rsExecution

&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    c-diems-fim c-diems-ini c-estab-fim c-estab-ini c-siscomex-fim c-siscomex-ini d-datadi-fim d-datadi-ini cx-via-trans-ini cx-via-trans-fim
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    l-cambio l-cus-nacio l-Despesas l-despesas-adicoes l-Itinerario l-listaradicoes l-LItens l-Obervacoes l-transporte 
&GLOBAL-DEFINE page5Fields    /*l-habilitaRtf*/
&GLOBAL-DEFINE page6Fields    cFile l-habilitaRtf
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

{include/i_dbtype.i}

/* Parameters Definitions ---                                           */

define temp-table tt-param no-undo
    field c-diems-ini         LIKE decla-import.num-di-ems
    field c-diems-fim         LIKE decla-import.num-di-ems
    field c-siscomex-ini      LIKE decla-import.cod-di-siscomex
    field c-siscomex-fim      LIKE decla-import.cod-di-siscomex
    FIELD d-datadi-ini        LIKE decla-import.dat-di
    FIELD d-datadi-fim        LIKE decla-import.dat-di
    FIELD c-estab-ini         LIKE decla-import.cod-estab
    FIELD c-estab-fim         LIKE decla-import.cod-estab
    FIELD c-via-transp-ini    AS CHAR FORMAT "x(16)"
    FIELD c-via-transp-fim    AS CHAR FORMAT "x(16)"
    FIELD l-Obervacoes        as logical format "Sim/N∆o"
    FIELD l-transporte        as logical format "Sim/N∆o"
    FIELD l-Itinerario        as logical format "Sim/N∆o"
    FIELD l-Despesas          as logical format "Sim/N∆o"
    FIELD l-cus-nacio         as logical format "Sim/N∆o"
    FIELD l-listaradicoes     as logical format "Sim/N∆o"
    FIELD l-despesas-adicoes  as logical format "Sim/N∆o"
    FIELD l-LItens            as logical format "Sim/N∆o"
    FIELD l-cambio            as logical format "Sim/N∆o"
    FIELD rsDestiny           AS INTEGER
    FIELD rsExecution         as logical format "Sim/N∆o"
    field destino             as integer
    field arquivo             as char format "x(35)":U
    field usuario             as char format "x(12)":U
    field data-exec           as date format "99/99/9999"
    field hora-exec           as integer
    field classifica          as integer
    field desc-classifica     as char format "x(40)":U
    field modelo              AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf       as LOGICAL FORMAT "Sim/N∆o".
    /*Fim alteracao 15/02/2005*/


define temp-table tt-digita no-undo
    field num-di-ems        LIKE decla-import.num-di-ems
    field cod-di-siscomex   LIKE decla-import.cod-di-siscomex
    FIELD data-di           LIKE decla-import.dat-di.


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

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

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
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.num-di-ems tt-digita.cod-di-siscomex tt-digita.data-di   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.num-di-ems ~
 tt-digita.cod-di-siscomex ~
tt-digita.data-di   
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

DEFINE VARIABLE cx-via-trans-fim AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cx-via-trans-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Via Transporte" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-diems-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-diems-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Declaraá∆o de Importaá∆o EMS" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-estab-fim AS CHARACTER FORMAT "x(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-estab-ini AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-siscomex-fim AS CHARACTER FORMAT "x(13)" INITIAL "ZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-siscomex-ini AS CHARACTER FORMAT "x(13)" 
     LABEL "DI Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE d-datadi-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE d-datadi-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/001 
     LABEL "Data da DI" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-123
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-124
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
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

DEFINE VARIABLE rsClassif AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Por DI-EMS/Adiá∆o/Sequencia", 1,
"Por DI-EMS/Embarque/Item", 2
     SIZE 26.86 BY 1.96
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32.72 BY 6.13.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 4.5.

DEFINE VARIABLE l-cambio AS LOGICAL INITIAL no 
     LABEL "Cambio" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-cus-nacio AS LOGICAL INITIAL no 
     LABEL "Custos Nacionalizaá∆o e Internaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.72 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-Despesas AS LOGICAL INITIAL no 
     LABEL "Despesas" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.86 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-despesas-adicoes AS LOGICAL INITIAL no 
     LABEL "Despesas" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-Itinerario AS LOGICAL INITIAL no 
     LABEL "Itinerario" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.86 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-listaradicoes AS LOGICAL INITIAL no 
     LABEL "Listar Adiá‰es" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-LItens AS LOGICAL INITIAL no 
     LABEL "LItens" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-Obervacoes AS LOGICAL INITIAL no 
     LABEL "Observaá‰es" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.86 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-transporte AS LOGICAL INITIAL no 
     LABEL "Transporte" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.86 BY 1.08
     FONT 1 NO-UNDO.

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

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

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

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46 BY 1.75.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE VARIABLE l-habilitaRtf AS LOGICAL INITIAL no 
     LABEL "Imprimir Parametros" 
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
      tt-digita.num-di-ems 
tt-digita.cod-di-siscomex
tt-digita.data-di
ENABLE tt-digita.num-di-ems 
       tt-digita.cod-di-siscomex
       tt-digita.data-di
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 8.75
         FONT 1.


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

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1 WIDGET-ID 200
     btAdd AT ROW 10 COL 1
     btUpdate AT ROW 10 COL 16
     btDelete AT ROW 10 COL 31
     btSave AT ROW 10 COL 46
     btOpen AT ROW 10 COL 61
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 10.21
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     c-diems-ini AT ROW 1.5 COL 4.15 HELP
          "N£mero Declaraá∆o de Importaá∆o EMS" WIDGET-ID 28
     c-diems-fim AT ROW 1.5 COL 54.14 HELP
          "N£mero Declaraá∆o de Importaá∆o EMS" NO-LABEL WIDGET-ID 26
     c-siscomex-ini AT ROW 2.92 COL 17.28 HELP
          "C¢digo DI Siscomex" WIDGET-ID 4
     c-siscomex-fim AT ROW 2.92 COL 54.14 HELP
          "C¢digo DI Siscomex" NO-LABEL WIDGET-ID 2
     d-datadi-ini AT ROW 4.17 COL 18.28 HELP
          "Data da DI" WIDGET-ID 12
     d-datadi-fim AT ROW 4.17 COL 54.14 HELP
          "Data da DI" NO-LABEL WIDGET-ID 10
     c-estab-ini AT ROW 5.5 COL 14.57 HELP
          "C¢digo do estabelecimento." WIDGET-ID 20
     c-estab-fim AT ROW 5.5 COL 54.14 HELP
          "C¢digo do estabelecimento." NO-LABEL WIDGET-ID 18
     cx-via-trans-ini AT ROW 6.75 COL 24.72 COLON-ALIGNED WIDGET-ID 34
     cx-via-trans-fim AT ROW 6.75 COL 52.29 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     IMAGE-1 AT ROW 1.5 COL 43.72 WIDGET-ID 30
     IMAGE-2 AT ROW 1.5 COL 50.72 WIDGET-ID 32
     IMAGE-3 AT ROW 2.92 COL 43.72 WIDGET-ID 6
     IMAGE-4 AT ROW 2.92 COL 50.72 WIDGET-ID 8
     IMAGE-5 AT ROW 4.17 COL 43.72 WIDGET-ID 14
     IMAGE-6 AT ROW 4.17 COL 50.72 WIDGET-ID 16
     IMAGE-7 AT ROW 5.5 COL 43.72 WIDGET-ID 22
     IMAGE-8 AT ROW 5.5 COL 50.72 WIDGET-ID 24
     IMAGE-123 AT ROW 6.75 COL 43.72 WIDGET-ID 38
     IMAGE-124 AT ROW 6.75 COL 50.72 WIDGET-ID 40
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     rsClassif AT ROW 2.13 COL 6.14 HELP
          "Classificaá∆o para emiss∆o do relat¢rio" NO-LABEL WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     l-listaradicoes AT ROW 1.5 COL 50 WIDGET-ID 14
     l-Obervacoes AT ROW 2.38 COL 5.72 WIDGET-ID 24
     l-despesas-adicoes AT ROW 2.92 COL 53.29 WIDGET-ID 18
     l-transporte AT ROW 3.38 COL 5.72 WIDGET-ID 6
     l-LItens AT ROW 3.96 COL 53.29 WIDGET-ID 20
     l-Itinerario AT ROW 4.42 COL 5.72 WIDGET-ID 8
     l-cambio AT ROW 5.13 COL 53.29 WIDGET-ID 22
     l-Despesas AT ROW 5.5 COL 5.72 WIDGET-ID 10
     l-cus-nacio AT ROW 6.58 COL 5.72 WIDGET-ID 12
     "Listar DI" VIEW-AS TEXT
          SIZE 6 BY 1 AT ROW 1.42 COL 4.43 WIDGET-ID 4
     RECT-16 AT ROW 1.88 COL 2.72 WIDGET-ID 2
     RECT-17 AT ROW 2 COL 47 WIDGET-ID 16
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 10.21
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL WIDGET-ID 18
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo" WIDGET-ID 8
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configuraá∆o da impressora" WIDGET-ID 6
     rsExecution AT ROW 5.83 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL WIDGET-ID 22
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     text-modo AT ROW 5.08 COL 1.14 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL WIDGET-ID 30
     l-habilitaRtf AT ROW 8 COL 3.14 WIDGET-ID 12
     "Parametros de Impress∆o" VIEW-AS TEXT
          SIZE 18.14 BY .5 AT ROW 7.29 COL 2.86 WIDGET-ID 4
     RECT-7 AT ROW 1.92 COL 2.14 WIDGET-ID 14
     RECT-10 AT ROW 5.33 COL 2 WIDGET-ID 16
     RECT-18 AT ROW 7.54 COL 2 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
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
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-diems-fim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-diems-ini IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-estab-fim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-estab-ini IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-siscomex-fim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-siscomex-ini IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN d-datadi-fim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN d-datadi-ini IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

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
        display tt-digita.num-di-ems
                tt-digita.cod-di-siscomex with browse brDigita. 
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
   /*:T trigger para inicializar campos da temp table de digitaá∆o */
   if  brDigita:new-row in frame fPage5 then do:
       assign tt-digita.data-di:screen-value in browse brDigita = string(today, "99/99/9999":U).
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
    /*:T ê aqui que a gravaá∆o da linha da temp-table Ç efetivada.
       PorÇm as validaá‰es dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment†rio */
    
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse brDigita tt-digita.num-di-ems
               input browse brDigita tt-digita.cod-di-siscomex
               input browse brDigita tt-digita.data-di.

        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-digita then
            assign input browse brDigita tt-digita.num-di-ems
                   input browse brDigita tt-digita.cod-di-siscomex
                   input browse brDigita tt-digita.data-di.
    end.
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
        
        apply "entry":U to tt-digita.num-di-ems in browse brDigita. 
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
   apply 'entry' to tt-digita.num-di-ems in browse brDigita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME l-habilitaRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-habilitaRtf wReport
ON VALUE-CHANGED OF l-habilitaRtf IN FRAME fPage6 /* Imprimir Parametros */
DO:
    &IF "{&RTF}":U = "YES":U &THEN
    RUN pi-habilitaRtf.  
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME l-listaradicoes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-listaradicoes wReport
ON MOUSE-SELECT-CLICK OF l-listaradicoes IN FRAME fPage4 /* Listar Adiá‰es */
DO:
  ASSIGN l-despesas-adicoes:checked in frame fPage4 = l-listaradicoes:CHECKED IN FRAME fPage4
         l-LItens          :checked in frame fPage4 = l-listaradicoes:CHECKED IN FRAME fPage4
         l-cambio          :checked in frame fPage4 = l-listaradicoes:CHECKED IN FRAME fPage4.
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
        /*Alterado 15/02/2005 - tech1007 - Condiá∆o removida pois RTF n∆o Ç mais um destino
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


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializaá∆o
  correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/
&IF "{&RTF}":U = "YES":U &THEN
IF VALID-HANDLE(hWenController) THEN DO:
    ASSIGN l-habilitaRtf:sensitive IN FRAME fPage6 = NO
           l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
           l-habilitaRtf = NO.
           
END.
RUN pi-habilitaRtf.
&endif

ASSIGN l-Obervacoes      :CHECKED IN FRAME fPage4 = YES
       l-transporte      :CHECKED IN FRAME fPage4 = YES
       l-itinerario      :CHECKED IN FRAME fPage4 = YES
       l-Despesas        :CHECKED IN FRAME fPage4 = YES
       l-cus-nacio       :CHECKED IN FRAME fPage4 = YES
       l-listaradicoes   :CHECKED IN FRAME fPage4 = YES
       l-despesas-adicoes:CHECKED IN FRAME fPage4 = YES
       l-LItens          :CHECKED IN FRAME fPage4 = YES
       l-cambio          :CHECKED IN FRAME fPage4 = YES
       l-habilitaRtf     :CHECKED IN FRAME fPage6 = YES.

ASSIGN cx-via-trans-ini:SCREEN-VALUE IN FRAME fPage2 = {adinc/i01ad268.i 04 1}
       cx-via-trans-fim:SCREEN-VALUE IN FRAME fPage2 = {adinc/i01ad268.i 04 1}.

/*Fim alteracao 17/02/2005*/
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

    ASSIGN cx-via-trans-ini:LIST-ITEMS IN FRAME fPage2 = {adinc/i01ad268.i 03}
           cx-via-trans-fim:LIST-ITEMS IN FRAME fPage2 = {adinc/i01ad268.i 03}.

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

    /*15/02/2005 - tech1007 - Teste alterado pois RTF n∆o Ç mais opá∆o de Destino*/
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.

    /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).
        
        /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita */
        find first b-tt-digita 
            where b-tt-digita.num-di-ems = tt-digita.num-di-ems
              AND b-tt-digita.cod-di-siscomex = tt-digita.cod-di-siscomex
              and rowid(b-tt-digita) <> rowid(tt-digita) 
            no-lock no-error.
        if  avail b-tt-digita then do:
            reposition brDigita to rowid rowid(b-tt-digita).
            
            run utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
            apply "ENTRY":U to tt-digita.num-di-ems in browse brDigita.
            
            return error.
        end.
        
        /*:T As demais validaá‰es devem ser feitas aqui 
        if  tt-digita.num-di-ems <= 0 then do:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.num-di-ems:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.
           
            run utp/ut-msgs.p (input "SHOW":U, input 99999, input "":U).
            apply "ENTRY":U to tt-digita.ordem in browse brDigita.
            
            return error.
        end.                                            */
        
    end.
    
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */
    
    
    
    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.classifica      = input frame fPage3 rsClassif
           tt-param.desc-classifica = entry((tt-param.classifica - 1) * 2 + 1, 
                                            rsClassif:radio-buttons in frame fPage3)
           .
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
    
    ASSIGN tt-param.c-diems-ini         = INPUT FRAME fPage2 c-diems-ini          
           tt-param.c-diems-fim         = INPUT FRAME fPage2 c-diems-fim          
           tt-param.c-siscomex-ini      = INPUT FRAME fPage2 c-siscomex-ini       
           tt-param.c-siscomex-fim      = INPUT FRAME fPage2 c-siscomex-fim       
           tt-param.d-datadi-ini        = INPUT FRAME fPage2 d-datadi-ini         
           tt-param.d-datadi-fim        = INPUT FRAME fPage2 d-datadi-fim         
           tt-param.c-estab-ini         = INPUT FRAME fPage2 c-estab-ini          
           tt-param.c-estab-fim         = INPUT FRAME fPage2 c-estab-fim          
           tt-param.c-via-transp-ini    = INPUT FRAME fPage2 cx-via-trans-ini
           tt-param.c-via-transp-fim    = INPUT FRAME fPage2 cx-via-trans-fim
           tt-param.l-Obervacoes        = INPUT FRAME fPage4 l-Obervacoes         
           tt-param.l-transporte        = INPUT FRAME fPage4 l-transporte         
           tt-param.l-Itinerario        = INPUT FRAME fPage4 l-Itinerario         
           tt-param.l-Despesas          = INPUT FRAME fPage4 l-Despesas           
           tt-param.l-cus-nacio         = INPUT FRAME fPage4 l-cus-nacio          
           tt-param.l-listaradicoes     = INPUT FRAME fPage4 l-listaradicoes      
           tt-param.l-despesas-adicoes  = INPUT FRAME fPage4 l-despesas-adicoes   
           tt-param.l-LItens            = INPUT FRAME fPage4 l-LItens             
           tt-param.l-cambio            = INPUT FRAME fPage4 l-cambio
           tt-param.l-habilitaRtf       = INPUT FRAME fPage6 l-habilitaRtf.             

    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i imp/im0440rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ELSE
/*:T** Importacao/Exportacao ***/
do  on error undo, return error
    on stop  undo, return error:     

    {report/rpexa.i}

    if  input frame fPage7 rsDestiny = 2 and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage7 cDestinyFile).
        if  return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "SHOW":U,
                               input 73,
                               input "":U).
            apply "ENTRY":U to cDestinyFile in frame fPage7.                   
            return error.
        end.
    end.
    
    assign file-info:file-name = input frame fPage4 cInputFile.
    if  file-info:pathname = ? and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-msgs.p (input "SHOW":U,
                           input 326,
                           input cInputFile).                               
        apply "ENTRY":U to cInputFile in frame fPage4.                
        return error.
    end. 
            
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p†gina 
       com problemas e colocar o focus no campo com problemas             */    
         
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage7 rsDestiny
           tt-param.todos           = input frame fPage7 rsAll
           tt-param.arq-entrada     = input frame fPage4 cInputFile
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.

    if  tt-param.destino = 1 then
        assign tt-param.arq-destino = "":U.
    else
    if  tt-param.destino = 2 THEN
        assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Coloque aqui a l¢gica de gravaá∆o dos parÉmtros e seleá∆o na temp-table
       tt-param */ 

    {report/imexb.i}

    if  session:set-wait-state("GENERAL":U) then.

    {report/imrun.i imp/im0440rp.p}

    {report/imexc.i}

    if  session:set-wait-state("":U) then.
    
    {report/imtrm.i tt-param.arq-destino tt-param.destino}
    
end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

