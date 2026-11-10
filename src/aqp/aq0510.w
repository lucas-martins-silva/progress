&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind            PROGRESS
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
{include/i-prgvrs.i AQ0510 2.00.00.005 } /*** 010005 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0510 MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0510
&GLOBAL-DEFINE Version        2.00.00.005
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,ParÉmetros,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2

&GLOBAL-DEFINE page2Widgets   

&GLOBAL-DEFINE page4Widgets  rs-situacao ~
                             l-todos ~
                             l-pesagem ~
                             l-liber-carg ~
                             l-produtores ~
                             l-nc 

&GLOBAL-DEFINE page6Widgets   btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              rsDestiny ~
                              l-imp-param
     
&GLOBAL-DEFINE page2Text
&GLOBAL-DEFINE page4Text      text-situacao text-listar
&GLOBAL-DEFINE page6Text      text-destino text-modo text-imp-param

   
&GLOBAL-DEFINE page2Fields  c-cod-estabel-ini    ~
                            c-cod-estabel-fim    ~
                            i-num-carg-ini       ~
                            i-num-carg-fim       ~
                            c-cod-carga-ini      ~
                            c-cod-carga-fim      ~
                            c-cod-placa-fim      ~
                            c-cod-placa-ini      ~
                            c-cod-rota-ini       ~
                            c-cod-rota-fim       ~
                            i-cod-transp-ini     ~
                            i-cod-transp-fim     ~
                            dt-dat-trans-ini     ~
                            dt-dat-trans-fim     ~
                            dt-dat-entr-ini      ~
                            dt-dat-entr-fim

&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page6Fields    cFile

 

/* Parameters Definitions and Transfer Definitions ---*/

{aqp/aq0510.i} /* tt-param, tt-digita, tt-raw-digita */ 
    
DEFINE BUFFER b-tt-digita FOR tt-digita.

DEFINE VARIABLE raw-param          AS RAW       NO-UNDO.
DEFINE VARIABLE l-ok               AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-arq-digita       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-terminal         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-rtf              AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arq-layout       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arq-temp         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-modelo-default   AS CHARACTER NO-UNDO.

DEFINE STREAM s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

DEFINE VARIABLE h-boin627     AS HANDLE NO-UNDO. /* usuar-mater  */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnFaixaDatas wMaintenance 
FUNCTION fnFaixaDatas RETURNS DATE
  ( i AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE VARIABLE c-cod-carga-fim LIKE carg-rural.cod-carga
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-carga-ini LIKE carg-rural.cod-carga
     LABEL "C¢digo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-fim LIKE carg-rural.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini LIKE carg-rural.cod-estabel
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-cod-placa-fim LIKE carg-rural.cod-placa
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-placa-ini LIKE carg-rural.cod-placa
     LABEL "Placa" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-rota-fim LIKE carg-rural.cod-rota
     VIEW-AS FILL-IN 
     SIZE 14.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-rota-ini LIKE carg-rural.cod-rota
     LABEL "Rota" 
     VIEW-AS FILL-IN 
     SIZE 14.72 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dat-entr-fim LIKE carg-rural.dat-entr
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dat-entr-ini LIKE carg-rural.dat-entr
     LABEL "Data Entrada" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dat-trans-fim LIKE carg-rural.dat-trans
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dat-trans-ini LIKE carg-rural.dat-trans
     LABEL "Data Transaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-transp-fim LIKE carg-rural.cod-transp
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-transp-ini LIKE carg-rural.cod-transp
     LABEL "Transportador" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-carg-fim LIKE carg-rural.num-carg
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-carg-ini LIKE carg-rural.num-carg
     LABEL "Carga" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE text-listar AS CHARACTER FORMAT "X(256)":U INITIAL "Listar" 
      VIEW-AS TEXT 
     SIZE 4.14 BY .67 NO-UNDO.

DEFINE VARIABLE text-situacao AS CHARACTER FORMAT "X(256)":U INITIAL "Situaá∆o" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE rs-situacao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pendente", 1,
"Encerrada", 2,
"Todos", 0
     SIZE 31 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 2.25.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 5.63.

DEFINE VARIABLE l-liber-carg AS LOGICAL INITIAL no 
     LABEL "Liberaá‰es da Carga" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-nc AS LOGICAL INITIAL no 
     LABEL "N∆o Conformidades" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.57 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-pesagem AS LOGICAL INITIAL no 
     LABEL "Pesagens" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-produtores AS LOGICAL INITIAL no 
     LABEL "Produtores" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-todos AS LOGICAL INITIAL no 
     LABEL "Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .71
     FONT 1 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image/im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
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

DEFINE VARIABLE text-imp-param AS CHARACTER FORMAT "X(256)":U INITIAL "ParÉmetros de Impress∆o" 
      VIEW-AS TEXT 
     SIZE 17.86 BY .63
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

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE VARIABLE l-imp-param AS LOGICAL INITIAL yes 
     LABEL "Imprimir ParÉmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.


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

DEFINE FRAME fPage6
     l-imp-param AT ROW 10.25 COL 5
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configuraá∆o da impressora"
     rsExecution AT ROW 6.92 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 6.17 COL 1.14 COLON-ALIGNED NO-LABEL
     text-imp-param AT ROW 9.42 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 6.42 COL 2
     RECT-10 AT ROW 9.67 COL 2 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.71
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     rs-situacao AT ROW 2.58 COL 10.86 NO-LABEL WIDGET-ID 2
     l-todos AT ROW 6.25 COL 10.29
     l-pesagem AT ROW 6.88 COL 13.43
     l-liber-carg AT ROW 7.88 COL 13.43
     l-produtores AT ROW 8.88 COL 13.43
     l-nc AT ROW 9.88 COL 13.43
     text-situacao AT ROW 1.58 COL 8.86 COLON-ALIGNED NO-LABEL
     text-listar AT ROW 5.25 COL 8.86 COLON-ALIGNED NO-LABEL
     RECT-13 AT ROW 1.83 COL 8.29 WIDGET-ID 6
     RECT-14 AT ROW 5.63 COL 8.29 WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.46
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     c-cod-estabel-ini AT ROW 2.71 COL 12.29 HELP
          "C¢digo do estabelecimento"
          LABEL "Estabelecimento"
          FONT 1
     c-cod-estabel-fim AT ROW 2.71 COL 49.86 HELP
          "C¢digo do estabelecimento" NO-LABEL WIDGET-ID 2
          FONT 1
     i-num-carg-ini AT ROW 3.71 COL 22.29 COLON-ALIGNED HELP
          "N£mero da Carga"
          LABEL "Carga"
     i-num-carg-fim AT ROW 3.71 COL 47.86 COLON-ALIGNED HELP
          "N£mero da Carga" NO-LABEL
     c-cod-carga-ini AT ROW 4.71 COL 22.29 COLON-ALIGNED HELP
          "C¢digo da Carga" WIDGET-ID 4
          LABEL "C¢digo"
     c-cod-carga-fim AT ROW 4.71 COL 47.86 COLON-ALIGNED HELP
          "C¢digo da Carga" NO-LABEL
     c-cod-placa-ini AT ROW 5.71 COL 22.29 COLON-ALIGNED HELP
          "Placa"
          LABEL "Placa"
     c-cod-placa-fim AT ROW 5.67 COL 47.86 COLON-ALIGNED HELP
          "Placa" NO-LABEL
     c-cod-rota-ini AT ROW 6.71 COL 22.29 COLON-ALIGNED HELP
          "C¢digo da rota"
          LABEL "Rota"
     c-cod-rota-fim AT ROW 6.71 COL 47.86 COLON-ALIGNED HELP
          "C¢digo da rota" NO-LABEL
     i-cod-transp-ini AT ROW 7.71 COL 22.29 COLON-ALIGNED HELP
          "C¢digo do transportador"
          LABEL "Transportador"
     i-cod-transp-fim AT ROW 7.71 COL 48 COLON-ALIGNED HELP
          "C¢digo do transportador" NO-LABEL WIDGET-ID 44
     dt-dat-trans-ini AT ROW 8.71 COL 22.29 COLON-ALIGNED HELP
          "Data Transaá∆o"
          LABEL "Data Transaá∆o"
     dt-dat-trans-fim AT ROW 8.71 COL 48 COLON-ALIGNED HELP
          "Data Transaá∆o" NO-LABEL
     dt-dat-entr-ini AT ROW 9.71 COL 22.29 COLON-ALIGNED HELP
          "Data de entrada da carga"
          LABEL "Data Entrada"
     dt-dat-entr-fim AT ROW 9.67 COL 48 COLON-ALIGNED HELP
          "Data de entrada da carga" NO-LABEL
     IMAGE-1 AT ROW 2.71 COL 40.43
     IMAGE-2 AT ROW 2.71 COL 46.86
     IMAGE-9 AT ROW 3.71 COL 40.43 WIDGET-ID 16
     IMAGE-10 AT ROW 3.71 COL 46.86 WIDGET-ID 18
     IMAGE-11 AT ROW 4.71 COL 40.43 WIDGET-ID 22
     IMAGE-12 AT ROW 4.71 COL 46.86 WIDGET-ID 20
     IMAGE-13 AT ROW 5.71 COL 40.43 WIDGET-ID 24
     IMAGE-14 AT ROW 5.71 COL 46.86 WIDGET-ID 26
     IMAGE-15 AT ROW 6.71 COL 40.43 WIDGET-ID 28
     IMAGE-16 AT ROW 6.71 COL 46.86 WIDGET-ID 40
     IMAGE-17 AT ROW 7.71 COL 40.43 WIDGET-ID 42
     IMAGE-18 AT ROW 7.71 COL 46.86 WIDGET-ID 30
     IMAGE-19 AT ROW 8.71 COL 40.43 WIDGET-ID 32
     IMAGE-21 AT ROW 9.71 COL 40.43 WIDGET-ID 36
     IMAGE-22 AT ROW 9.71 COL 46.86 WIDGET-ID 38
     IMAGE-23 AT ROW 8.71 COL 46.86 WIDGET-ID 46
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 84.43 BY 12.5
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
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
   Custom                                                               */
/* SETTINGS FOR FILL-IN c-cod-carga-fim IN FRAME fPage2
   LIKE = movind.carg-rural.cod-carga EXP-LABEL EXP-SIZE                 */
/* SETTINGS FOR FILL-IN c-cod-carga-ini IN FRAME fPage2
   LIKE = movind.carg-rural.cod-carga EXP-LABEL EXP-SIZE                 */
/* SETTINGS FOR FILL-IN c-cod-estabel-fim IN FRAME fPage2
   ALIGN-L LIKE = movind.carg-rural.cod-estabel EXP-LABEL EXP-SIZE       */
/* SETTINGS FOR FILL-IN c-cod-estabel-ini IN FRAME fPage2
   ALIGN-L LIKE = movind.carg-rural.cod-estabel EXP-LABEL EXP-SIZE       */
/* SETTINGS FOR FILL-IN c-cod-placa-fim IN FRAME fPage2
   LIKE = movind.carg-rural.cod-placa EXP-LABEL EXP-SIZE                 */
/* SETTINGS FOR FILL-IN c-cod-placa-ini IN FRAME fPage2
   LIKE = movind.carg-rural.cod-placa EXP-LABEL EXP-SIZE                 */
/* SETTINGS FOR FILL-IN c-cod-rota-fim IN FRAME fPage2
   LIKE = movind.carg-rural.cod-rota EXP-LABEL EXP-SIZE                  */
/* SETTINGS FOR FILL-IN c-cod-rota-ini IN FRAME fPage2
   LIKE = movind.carg-rural.cod-rota EXP-LABEL EXP-SIZE                  */
/* SETTINGS FOR FILL-IN dt-dat-entr-fim IN FRAME fPage2
   LIKE = movind.carg-rural.dat-entr EXP-LABEL EXP-SIZE                  */
/* SETTINGS FOR FILL-IN dt-dat-entr-ini IN FRAME fPage2
   LIKE = movind.carg-rural.dat-entr EXP-LABEL EXP-SIZE                  */
/* SETTINGS FOR FILL-IN dt-dat-trans-fim IN FRAME fPage2
   LIKE = movind.carg-rural.dat-trans EXP-LABEL EXP-SIZE                 */
/* SETTINGS FOR FILL-IN dt-dat-trans-ini IN FRAME fPage2
   LIKE = movind.carg-rural.dat-trans EXP-LABEL EXP-SIZE                 */
/* SETTINGS FOR FILL-IN i-cod-transp-fim IN FRAME fPage2
   LIKE = movind.carg-rural.cod-transp EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN i-cod-transp-ini IN FRAME fPage2
   LIKE = movind.carg-rural.cod-transp EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN i-num-carg-fim IN FRAME fPage2
   LIKE = movind.carg-rural.num-carg EXP-LABEL EXP-SIZE                  */
/* SETTINGS FOR FILL-IN i-num-carg-ini IN FRAME fPage2
   LIKE = movind.carg-rural.num-carg EXP-LABEL EXP-SIZE                  */
/* SETTINGS FOR FRAME fPage4
                                                                        */
ASSIGN 
       text-listar:PRIVATE-DATA IN FRAME fPage4     = 
                "Listar".

ASSIGN 
       text-situacao:PRIVATE-DATA IN FRAME fPage4     = 
                "Situaá∆o".

/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-imp-param:PRIVATE-DATA IN FRAME fPage6     = 
                "ParÉmetros de Impress∆o".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME l-liber-carg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-liber-carg wReport
ON VALUE-CHANGED OF l-liber-carg IN FRAME fPage4 /* Liberaá‰es da Carga */
DO:
  RUN pi-marca-todos IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-nc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-nc wReport
ON VALUE-CHANGED OF l-nc IN FRAME fPage4 /* N∆o Conformidades */
DO:
  RUN pi-marca-todos IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-pesagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-pesagem wReport
ON VALUE-CHANGED OF l-pesagem IN FRAME fPage4 /* Pesagens */
DO:
  RUN pi-marca-todos IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-produtores
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-produtores wReport
ON VALUE-CHANGED OF l-produtores IN FRAME fPage4 /* Produtores */
DO:
  RUN pi-marca-todos IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-todos wReport
ON VALUE-CHANGED OF l-todos IN FRAME fPage4 /* Tudo */
DO:
    ASSIGN l-todos:CHECKED                IN FRAME fPage4 = SELF:CHECKED
           l-pesagem:CHECKED              IN FRAME fPage4 = SELF:CHECKED
           l-liber-carg:CHECKED           IN FRAME fPage4 = SELF:CHECKED
           l-produtores:CHECKED           IN FRAME fPage4 = SELF:CHECKED
           l-nc:CHECKED                   IN FRAME fPage4 = SELF:CHECKED.   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :

     IF VALID-HANDLE(h-boin627) AND
        h-boin627:TYPE = "PROCEDURE":U AND
        h-boin627:FILE-NAME = "inbo/boin627.p":U THEN DO:
        DELETE PROCEDURE h-boin627.
        ASSIGN h-boin627 = ?.
    END. 

    RETURN "OK":U.
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
    DEFINE VARIABLE c-return AS CHARACTER NO-UNDO.
        
    RUN initializeDBOs IN THIS-PROCEDURE.
    
    IF VALID-HANDLE(h-boin627) THEN DO:
        RUN findUsuar_mater IN h-boin627 (INPUT c-seg-usuario, OUTPUT c-return).
        IF c-return = "" THEN DO:
            RUN getCharField IN h-boin627 (INPUT 'char-1', OUTPUT c-return).
             ASSIGN c-return = SUBSTR(c-return,16,5). /* estab usuar */
        END.
    END.
    
    IF c-return <> "" THEN 
        ASSIGN c-cod-estabel-ini = c-return
               c-cod-estabel-fim = c-return.
    ELSE 
        ASSIGN c-cod-estabel-fim = FILL("Z", 5).
    
    ASSIGN i-num-carg-fim                       = INT(FILL("9", 9))
           c-cod-carga-fim                      = FILL("Z", 15)
           c-cod-placa-fim                      = FILL("Z", 10)
           c-cod-rota-fim                       = FILL("Z", 12)
           i-cod-transp-fim                     = INT(FILL("9", 5))
           dt-dat-trans-ini                     = fnFaixaDatas(1) 
           dt-dat-trans-fim                     = fnFaixaDatas(2) 
           dt-dat-entr-ini                      = DATE('01/01/2000')
           dt-dat-entr-fim                      = DATE('31/12/9999')
           rs-situacao                          = 0
           l-produtores:CHECKED IN FRAME fPage4 = YES.
            
    DISPLAY c-cod-estabel-ini
            c-cod-estabel-fim 
            i-num-carg-fim    
            c-cod-carga-fim   
            c-cod-placa-fim   
            c-cod-rota-fim    
            i-cod-transp-fim  
            dt-dat-trans-ini  
            dt-dat-trans-fim  
            dt-dat-entr-ini   
            dt-dat-entr-fim   
            WITH FRAME fPage2.
    
    DISPLAY rs-situacao 
            WITH FRAME fPage4.
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

    IF NOT VALID-HANDLE(h-boin627) THEN
        RUN inbo/boin627.p PERSISTENT SET h-boin627.

    RUN openQuery IN h-boin627 (INPUT 1) NO-ERROR. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-marca-todos wReport 
PROCEDURE pi-marca-todos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     IF  l-pesagem:CHECKED              IN FRAME fPage4 
     AND l-liber-carg:CHECKED           IN FRAME fPage4 
     AND l-produtores:CHECKED           IN FRAME fPage4 
     AND l-nc:CHECKED                   IN FRAME fPage4 THEN 
         ASSIGN l-todos:CHECKED IN FRAME fPage4 = YES.
     ELSE 
         ASSIGN l-todos:CHECKED IN FRAME fPage4 = NO.
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

    DEFINE VARIABLE r-tt-digita AS ROWID NO-UNDO.

    /*:T** Relatorio ***/
    DO ON ERROR UNDO, RETURN ERROR ON STOP  UNDO, RETURN ERROR:
        {report/rpexa.i}

        /*15/02/2005 - tech1007 - Teste alterado pois RTF n∆o Ç mais opá∆o de Destino*/
        IF INPUT FRAME fPage6 rsDestiny = 2 AND
           INPUT FRAME fPage6 rsExecution = 1 THEN do:
            RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFile).
            
            IF RETURN-VALUE = "NOK":U then do:
                RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 73, INPUT "":U).
                APPLY "ENTRY":U TO cFile IN FRAME fPage6.
                RETURN ERROR.
            END.
        END.
        
        CREATE tt-param.
        ASSIGN tt-param.destino                = INPUT FRAME fPage6 rsDestiny             
               tt-param.usuario                = c-seg-usuario
               tt-param.data-exec              = TODAY
               tt-param.hora-exec              = TIME
               tt-param.cod-estabel-ini        = INPUT FRAME fPage2 c-cod-estabel-ini
               tt-param.cod-estabel-fim        = INPUT FRAME fPage2 c-cod-estabel-fim
               tt-param.num-carg-ini           = INPUT FRAME fPage2 i-num-carg-ini 
               tt-param.num-carg-fim           = INPUT FRAME fPage2 i-num-carg-fim 
               tt-param.cod-carga-ini          = INPUT FRAME fPage2 c-cod-carga-ini
               tt-param.cod-carga-fim          = INPUT FRAME fPage2 c-cod-carga-fim  
               tt-param.cod-placa-fim          = INPUT FRAME fPage2 c-cod-placa-fim  
               tt-param.cod-placa-ini          = INPUT FRAME fPage2 c-cod-placa-ini  
               tt-param.cod-rota-ini           = INPUT FRAME fPage2 c-cod-rota-ini   
               tt-param.cod-rota-fim           = INPUT FRAME fPage2 c-cod-rota-fim   
               tt-param.cod-transp-ini         = INPUT FRAME fPage2 i-cod-transp-ini 
               tt-param.cod-transp-fim         = INPUT FRAME fPage2 i-cod-transp-fim 
               tt-param.dat-trans-ini          = INPUT FRAME fPage2 dt-dat-trans-ini  
               tt-param.dat-trans-fim          = INPUT FRAME fPage2 dt-dat-trans-fim  
               tt-param.dat-entr-ini           = INPUT FRAME fPage2 dt-dat-entr-ini   
               tt-param.dat-entr-fim           = INPUT FRAME fPage2 dt-dat-entr-fim   
               tt-param.l-pesagem              = INPUT FRAME fPage4 l-pesagem             
               tt-param.l-liber-carg           = INPUT FRAME fPage4 l-liber-carg          
               tt-param.l-produtores           = INPUT FRAME fPage4 l-produtores
               tt-param.l-nc                   = INPUT FRAME fPage4 l-nc                  
               tt-param.rs-situacao            = INPUT FRAME fPage4 rs-situacao
               tt-param.l-imp-param            = INPUT FRAME fPage6 l-imp-param.
        
        IF tt-param.destino = 1 THEN 
            ASSIGN tt-param.arquivo = "":U.
        ELSE IF tt-param.destino = 2 THEN 
            ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
        ELSE 
            ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.       

        {report/rpexb.i}
        
        SESSION:SET-WAIT-STATE("GENERAL":U).
        
        {report/rprun.i aqp/aq0510rp.p}
        
        {report/rpexc.i}
        
        SESSION:SET-WAIT-STATE("":U).
        
        {report/rptrm.i}
        
        
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnFaixaDatas wMaintenance 
FUNCTION fnFaixaDatas RETURNS DATE
  ( i AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dtAtual      AS INTEGER EXTENT 2 NO-UNDO.
    DEFINE VARIABLE mesAnt       AS INTEGER          NO-UNDO.
    DEFINE VARIABLE anoIni       AS INTEGER          NO-UNDO.
    DEFINE VARIABLE dtDataVigenc AS DATE    EXTENT 2 NO-UNDO.
    DEFINE VARIABLE i-cont       AS INTEGER          NO-UNDO.    
    
    ASSIGN dtAtual[1] = MONTH(TODAY) /* mes corrente */
           dtAtual[2] = YEAR(TODAY)  /* ano corrente */
           mesant = dtAtual[1] - 1   /* mes anterior */
           anoini = dtAtual[2].      /* ano data inicial vigencia */
    
    /* Se for o mes um, atializa mes anterior com o mes 12*/
    IF dtAtual[1] = 1 THEN
        ASSIGN mesant = 12
               anoini  = dtAtual[2] - 1. /* ano anterior */
               
    ASSIGN dtDataVigenc[1] = DATE(mesant,DAY(TODAY),anoini) NO-ERROR. 
    DO WHILE ERROR-STATUS:ERROR:
        ASSIGN i-cont = i-cont + 1.
        ASSIGN dtDataVigenc[1] = DATE(mesant, DAY(TODAY) - i-cont ,anoini) NO-ERROR.
    END.
    
    ASSIGN dtDataVigenc[2] = TODAY.
    
    RETURN dtDataVigenc[i].
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


