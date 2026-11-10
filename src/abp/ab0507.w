&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          ems2cad          PROGRESS
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0507 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0507 MAB}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{cdp/cdcfgmnt.i}
CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program       AB0507
&GLOBAL-DEFINE Version        2.00.00.001
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Classifica‡Æo,Parƒmetro,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          YES
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets                                 
&GLOBAL-DEFINE page2Widgets   fi-num-reserva-ini ~ fi-num-reserva-fim ~ fi-dat-reserva-ini ~ fi-dat-reserva-fim ~ fi-hra-reserva-ini ~ fi-hra-reserva-fim ~
                              fi-cod-rota-orig-ini ~ fi-cod-rota-orig-fim ~ fi-cod-rota-dest-ini ~ fi-cod-rota-dest-fim ~ fi-ep-codigo-ini ~ fi-ep-codigo-fim ~
                              fi-cod-eqpto-ini ~ fi-cod-eqpto-fim ~ fi-cod-matr-ini ~ fi-cod-matr-fim ~ fi-empresa-matr-ini ~ fi-empresa-matr-fim ~ fi-estabel-matr-ini ~
                              fi-estabel-matr-fim

&GLOBAL-DEFINE page3Widgets   rsClassif
&GLOBAL-DEFINE page4Widgets   tgReservaAtend ~
                              tgReservaNAtend ~
                              tgInsere
                              
&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              l-param
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo text-modo-2 l-param
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    fi-num-reserva-ini ~ fi-num-reserva-fim ~ fi-dat-reserva-ini ~ fi-dat-reserva-fim ~ fi-hra-reserva-ini ~ fi-hra-reserva-fim ~ fi-cod-rota-orig-ini ~ fi-cod-rota-orig-fim ~ fi-cod-rota-dest-ini ~ fi-cod-rota-dest-fim ~
                              fi-ep-codigo-ini ~ fi-ep-codigo-fim ~ fi-cod-eqpto-ini ~ fi-cod-eqpto-fim ~ fi-cod-matr-ini ~ fi-cod-matr-fim ~ fi-empresa-matr-ini ~ fi-empresa-matr-fim ~ fi-estabel-matr-ini ~
                              fi-estabel-matr-fim           
                              
                              
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */
      DEF temp-table tt-param
          field destino              as integer
          field arquivo              as char
          field usuario              as char
          field data-exec            as date
          field hora-exec            as integer
          field parametro            as logical
          FIELD formato              as integer
          field v_num_tip_aces_usuar as integer
          field i-ep-codigo          LIKE mab-reserva.ep-codigo
          field classifica           as integer
          field desc-classifica      as char format "x(40)"
          field rs-considera         as integer
          field desc-considera       as char format "x(40)"
          field l-ReservaAtend       as logical  
          field l-ReservaNAtend      as logical  
          field l-Insere             as logical
          field i-reserva-ini        like mab-reserva.num-reserva
          field i-reserva-fim        like mab-reserva.num-reserva
          field d-data-ini           like mab-reserva.dat-reserva-inicial
          field d-data-fim           like mab-reserva.dat-reserva-final
          field c-hora-ini           like mab-reserva.hra-reserva-inicial
          field c-hora-fim           like mab-reserva.hra-reserva-final
          field c-rota-orig-ini      like mab-reserva.cod-rota-orig
          field c-rota-orig-fim      like mab-reserva.cod-rota-orig
          field c-rota-dest-ini      like mab-reserva.cod-rota-dest
          field c-rota-dest-fim      like mab-reserva.cod-rota-dest
          field i-cod-emp-ini        like mab-reserva.ep-codigo
          field i-cod-emp-fim        like mab-reserva.ep-codigo
          field c-cod-eqpto-ini      like mab-reserva.cod-eqpto
          field c-cod-eqpto-fim      like mab-reserva.cod-eqpto
          FIELD c-empresa-matr-ini   like mab-reserva.ep-codigo-matr  
          FIELD c-empresa-matr-fim   like mab-reserva.ep-codigo-matr  
          field c-estabel-matr-ini   like mab-reserva.cod-estabel-matr
          field c-estabel-matr-fim   like mab-reserva.cod-estabel-matr
          field c-cod-matr-ini       like mab-reserva.cod-matr
          field c-cod-matr-fim       like mab-reserva.cod-matr.


        

def temp-table tt-digita no-undo
    field linha      as integer
    field conteudo   as character format "x(80)"
    index editor-id is primary unique linha.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.

{abp/ab9000.i} /** Procedures de conversÆo de tempo:
                   piFormataHoraParaSegundo
                   piFormataSegundoParaHora **/

DEFINE VARIABLE cHora       AS CHARACTER format "00:00:00" NO-UNDO.
DEFINE VARIABLE cHora2      AS CHARACTER format "23:59:59" NO-UNDO.

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

DEFINE VARIABLE fi-cod-eqpto-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-cod-eqpto-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Equipamento":R14 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-cod-matr-fim AS CHARACTER FORMAT "x(10)" INITIAL "ZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-matr-ini AS CHARACTER FORMAT "x(10)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-rota-dest-fim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-cod-rota-dest-ini AS CHARACTER FORMAT "x(12)" 
     LABEL "Local Destino" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-cod-rota-orig-fim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-cod-rota-orig-ini AS CHARACTER FORMAT "x(12)" 
     LABEL "Local Origem":R17 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-dat-reserva-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-dat-reserva-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Data Reserva":R12 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-empresa-matr-fim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-empresa-matr-ini LIKE empresa.ep-codigo
     LABEL "Motorista":R9 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 DROP-TARGET NO-UNDO.

DEFINE VARIABLE fi-ep-codigo-fim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ep-codigo-ini LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel-matr-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel-matr-ini LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hra-reserva-fim AS CHARACTER FORMAT "99:99:99" INITIAL "235959" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-hra-reserva-ini AS CHARACTER FORMAT "99:99:99" INITIAL "000000" 
     LABEL "Hora Reserva" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-num-reserva-fim AS INTEGER FORMAT ">>,>>>,>>9" INITIAL 9999999 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-num-reserva-ini AS INTEGER FORMAT ">>,>>>,>>9" INITIAL 0 
     LABEL "Documento Reserva" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-57
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-58
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rsClassif AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Documento Reserva", 1,
"Data/Hora Inicial", 2,
"Empresa/Equipamento", 3
     SIZE 27.86 BY 5.96
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 31 BY 7.25.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 51 BY 4.29.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 51.14 BY 1.5.

DEFINE VARIABLE tgInsere AS LOGICAL INITIAL no 
     LABEL "Inserir Quebra de P gina de acordo com a classifica‡Æo escolhida" 
     VIEW-AS TOGGLE-BOX
     SIZE 48 BY .83 NO-UNDO.

DEFINE VARIABLE tgReservaAtend AS LOGICAL INITIAL yes 
     LABEL "Reservas Atendidas" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tgReservaNAtend AS LOGICAL INITIAL yes 
     LABEL "Reservas NÆo Atendidas" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image~\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
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

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Parƒmetros de ImpressÆo" 
      VIEW-AS TEXT 
     SIZE 18.14 BY .63
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
     SIZE 27.72 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE l-param AS LOGICAL INITIAL no 
     LABEL "Imprimir P gina de Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.96
         FONT 1.

DEFINE FRAME fPage2
     fi-num-reserva-ini AT ROW 1.33 COL 20 COLON-ALIGNED HELP
          "N£mero Reserva"
     fi-num-reserva-fim AT ROW 1.33 COL 48 COLON-ALIGNED HELP
          "N£mero Reserva" NO-LABEL
     fi-dat-reserva-ini AT ROW 2.33 COL 20 COLON-ALIGNED HELP
          "Data da Sa¡da do Equipamento"
     fi-dat-reserva-fim AT ROW 2.33 COL 48 COLON-ALIGNED HELP
          "Data da Sa¡da do Equipamento" NO-LABEL
     fi-hra-reserva-ini AT ROW 3.33 COL 20 COLON-ALIGNED HELP
          "Hora Sa¡da"
     fi-hra-reserva-fim AT ROW 3.33 COL 48 COLON-ALIGNED HELP
          "Hora Sa¡da" NO-LABEL
     fi-cod-rota-orig-ini AT ROW 4.33 COL 20 COLON-ALIGNED HELP
          "C¢digo Rota Origem"
     fi-cod-rota-orig-fim AT ROW 4.33 COL 48 COLON-ALIGNED HELP
          "C¢digo Rota Origem" NO-LABEL
     fi-cod-rota-dest-ini AT ROW 5.33 COL 20 COLON-ALIGNED HELP
          "C¢digo do trajeto"
     fi-cod-rota-dest-fim AT ROW 5.33 COL 48 COLON-ALIGNED HELP
          "C¢digo do trajeto" NO-LABEL
     fi-ep-codigo-ini AT ROW 6.33 COL 20 COLON-ALIGNED
     fi-ep-codigo-fim AT ROW 6.33 COL 48 COLON-ALIGNED NO-LABEL
     fi-cod-eqpto-ini AT ROW 7.33 COL 20 COLON-ALIGNED HELP
          "C¢digo do Equipamento"
     fi-cod-eqpto-fim AT ROW 7.33 COL 48 COLON-ALIGNED HELP
          "C¢digo do Equipamento" NO-LABEL
     fi-empresa-matr-ini AT ROW 8.33 COL 20 COLON-ALIGNED
          LABEL "Motorista":R9
     fi-estabel-matr-ini AT ROW 8.33 COL 25 COLON-ALIGNED NO-LABEL
     fi-cod-matr-ini AT ROW 8.33 COL 30 COLON-ALIGNED HELP
          "C¢digo do Motorista" NO-LABEL
     fi-empresa-matr-fim AT ROW 8.33 COL 48 COLON-ALIGNED NO-LABEL
     fi-estabel-matr-fim AT ROW 8.33 COL 53 COLON-ALIGNED NO-LABEL
     fi-cod-matr-fim AT ROW 8.33 COL 58 COLON-ALIGNED HELP
          "C¢digo do Motorista" NO-LABEL
     IMAGE-11 AT ROW 6.33 COL 42.72
     IMAGE-12 AT ROW 6.33 COL 47.14
     IMAGE-13 AT ROW 1.33 COL 42.72
     IMAGE-14 AT ROW 1.33 COL 47.14
     IMAGE-15 AT ROW 5.33 COL 42.72
     IMAGE-16 AT ROW 5.33 COL 47.14
     IMAGE-22 AT ROW 7.33 COL 42.72
     IMAGE-23 AT ROW 7.33 COL 47.29
     IMAGE-27 AT ROW 2.33 COL 42.72
     IMAGE-28 AT ROW 2.33 COL 47.14
     IMAGE-30 AT ROW 4.33 COL 42.72
     IMAGE-31 AT ROW 4.33 COL 47.14
     IMAGE-7 AT ROW 3.33 COL 42.72
     IMAGE-8 AT ROW 3.33 COL 47.14
     IMAGE-57 AT ROW 8.33 COL 42.72
     IMAGE-58 AT ROW 8.33 COL 47.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 11.96
         FONT 1.

DEFINE FRAME fPage3
     rsClassif AT ROW 3.21 COL 4.86 HELP
          "Classifica‡Æo para emissÆo do relat¢rio" NO-LABEL
     "Classificar por" VIEW-AS TEXT
          SIZE 11 BY .88 AT ROW 2 COL 4.57
     RECT-13 AT ROW 2.38 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 11.71
         FONT 1.

DEFINE FRAME fPage4
     tgInsere AT ROW 6.33 COL 7.72
     tgReservaAtend AT ROW 2.5 COL 7.72
     tgReservaNAtend AT ROW 3.5 COL 7.72
     RECT-24 AT ROW 1.71 COL 4.86
     RECT-26 AT ROW 6 COL 4.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 11.96
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     l-param AT ROW 8.13 COL 4
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     text-modo-2 AT ROW 7.38 COL 1.86 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 5.29 COL 2.14
     RECT-11 AT ROW 7.58 COL 2.29
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.79
         SIZE 76.86 BY 11.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = "Relat¢rio de Apontamentos de Controle de Reservas"
         HEIGHT             = 16.96
         WIDTH              = 90
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report~/report.i}

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
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
   Custom                                                               */
/* SETTINGS FOR FILL-IN fi-empresa-matr-fim IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo                                     */
/* SETTINGS FOR FILL-IN fi-empresa-matr-ini IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo EXP-LABEL                           */
ASSIGN 
       fi-empresa-matr-ini:DROP-TARGET IN FRAME fPage2      = TRUE.

/* SETTINGS FOR FILL-IN fi-ep-codigo-fim IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo                                     */
/* SETTINGS FOR FILL-IN fi-ep-codigo-ini IN FRAME fPage2
   LIKE = ems2cad.empresa.ep-codigo EXP-SIZE                            */
/* SETTINGS FOR FILL-IN fi-estabel-matr-fim IN FRAME fPage2
   LIKE = ems2cad.estabelec.cod-estabel                                 */
/* SETTINGS FOR FILL-IN fi-estabel-matr-ini IN FRAME fPage2
   LIKE = ems2cad.estabelec.cod-estabel                                 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

ASSIGN 
       text-modo-2:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

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
ON END-ERROR OF wReport /* Relat¢rio de Apontamentos de Controle de Reservas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport /* Relat¢rio de Apontamentos de Controle de Reservas */
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


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
do  with frame fPage6:
    case self:screen-value:
        when "1" then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes.
        end.
        when "2" then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no.
        end.
        when "3" then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no.
        end.
    end case.
end.
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


/*--- L¢gica para inicializa‡Æo do programam ---*/

ASSIGN fi-ep-codigo-ini = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF.
       fi-ep-codigo-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

ASSIGN fi-empresa-matr-ini = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF.
       fi-empresa-matr-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

ASSIGN fi-estabel-matr-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF.

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
/*** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}
    
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show", input 73, input "").
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    
    
    /* Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */
    
    
    
    /* Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario               = c-seg-usuario
           tt-param.destino               = input frame fPage6 rsDestiny
           tt-param.data-exec             = today
           tt-param.hora-exec             = time
           tt-param.classifica            = input frame fPage3 rsClassif
           tt-param.desc-classifica       = entry((tt-param.classifica - 1) * 2 + 1,       
                                               rsClassif:radio-buttons in frame fPage3)
          tt-param.l-ReservaAtend       = input frame fpage4  tgReservaAtend    
          tt-param.l-ReservaNAtend      = input frame fpage4  tgReservaNAtend 
          tt-param.l-Insere             = input frame fpage4  tgInsere
          tt-param.i-reserva-ini        = input frame fpage2  fi-num-reserva-ini 
          tt-param.i-reserva-fim        = input frame fpage2  fi-num-reserva-fim 
          tt-param.d-data-ini           = input frame fpage2  fi-dat-reserva-ini   
          tt-param.d-data-fim           = input frame fpage2  fi-dat-reserva-fim 
          tt-param.c-hora-ini           = input frame fpage2  fi-hra-reserva-ini 
          tt-param.c-hora-fim           = input frame fpage2  fi-hra-reserva-fim
          tt-param.c-rota-orig-ini      = input frame fpage2  fi-cod-rota-orig-ini 
          tt-param.c-rota-orig-fim      = input frame fpage2  fi-cod-rota-orig-fim
          tt-param.c-rota-dest-ini      = input frame fpage2  fi-cod-rota-dest-ini 
          tt-param.c-rota-dest-fim      = input frame fpage2  fi-cod-rota-dest-fim 
          tt-param.i-cod-emp-ini        = input frame fpage2  fi-ep-codigo-ini
          tt-param.i-cod-emp-fim        = input frame fpage2  fi-ep-codigo-fim
          tt-param.c-cod-eqpto-ini      = input frame fpage2  fi-cod-eqpto-ini 
          tt-param.c-cod-eqpto-fim      = input frame fpage2  fi-cod-eqpto-fim 
          tt-param.c-empresa-matr-ini   = input frame fpage2  fi-empresa-matr-ini  
          tt-param.c-empresa-matr-fim   = input frame fpage2  fi-empresa-matr-fim  
          tt-param.c-estabel-matr-ini   = input frame fpage2  fi-estabel-matr-ini  
          tt-param.c-estabel-matr-fim   = input frame fpage2  fi-estabel-matr-fim  
          tt-param.c-cod-matr-ini       = input frame fpage2  fi-cod-matr-ini  
          tt-param.c-cod-matr-fim       = input frame fpage2  fi-cod-matr-fim  
          tt-param.parametro            = input frame fpage6 l-param.
          if tt-param.destino = 1 then 
             assign tt-param.arquivo = "".
          else if  tt-param.destino = 2 then 
             assign tt-param.arquivo = input frame fPage6 cFile.
         else 
             assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /* Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    /* Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    

    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i abp/ab0507rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ELSE
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

