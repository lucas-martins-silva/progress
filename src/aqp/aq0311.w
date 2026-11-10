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
{include/i-prgvrs.i AQ0311 2.00.00.010 } /*** 010010 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0311 MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0311
&GLOBAL-DEFINE Version        2.00.00.009
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    2
&GLOBAL-DEFINE FolderLabels   Seleá∆o,ParÉmetro,Digitaá∆o,Impress∆o

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
&GLOBAL-DEFINE page1Widgets   edLayout ~
                              btEdit
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
&GLOBAL-DEFINE page7Widgets   rsAll ~
                              rsDestiny ~
                              btConfigImprDest ~
                              btDestinyFile ~
                              rsExecution
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo
&GLOBAL-DEFINE page7Text      text-imprime text-destino
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    cFimGrpProdut cFimProdut cFimRegiao cFimRota cIniGrpProdut cIniProdut cIniRegiao cIniRota
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    c-cod-estabel c-cod-serie c-data-emissao cb-item c-nat-operacao
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile 
&GLOBAL-DEFINE page7Fields    cDestinyFile
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

{aqp/aqapi004.i}

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.
DEF VAR h-boin627na        AS HANDLE  NO-UNDO.
DEF VAR h-boin00968        AS HANDLE  NO-UNDO.
DEF VAR h-boin00962        AS HANDLE  NO-UNDO.
DEF VAR h-boin245          AS HANDLE  NO-UNDO.
DEF VAR h-boin245zm        AS HANDLE  NO-UNDO.
DEF VAR h-boad098          AS HANDLE  NO-UNDO.
DEF VAR h-boin00980        AS HANDLE  NO-UNDO.
DEF VAR h-boin00983        AS HANDLE  NO-UNDO.
DEF VAR h-boin172na        AS HANDLE  NO-UNDO.
DEF VAR c-nome-usuar       AS CHAR    NO-UNDO.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.
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
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.cdn-produt tt-digita.nom-produt tt-digita.cod-propried tt-digita.des-propried   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita   
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

DEFINE BUTTON btEdit 
     LABEL "Editar Layout" 
     SIZE 20 BY 1
     FONT 1.

DEFINE VARIABLE edLayout AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 82 BY 8.75
     FONT 2 NO-UNDO.

DEFINE VARIABLE cFimGrpProdut LIKE grp-produt.cdn-grp-produt
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cFimProdut LIKE produt-rural.cdn-produt-rural
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cFimRegiao LIKE regiao-abrangen.cod-regiao
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cFimRota LIKE rota-coleta.cod-rota
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniGrpProdut LIKE grp-produt.cdn-grp-produt
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniProdut LIKE produt-rural.cdn-produt-rural
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniRegiao LIKE regiao-abrangen.cod-regiao
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniRota LIKE rota-coleta.cod-rota
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
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
          "Por Classificaá∆o 1", 1,
"Por Classificaá∆o 2", 2,
"Por Classificaá∆o 3", 3,
"Por Classificaá∆o 4", 4
     SIZE 17.86 BY 4
     FONT 1 NO-UNDO.

DEFINE VARIABLE cb-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-cod-serie AS CHARACTER FORMAT "x(05)" 
     LABEL "SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c-data-emissao AS DATE FORMAT "99/99/9999" 
     LABEL "Data Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-ds-natureza AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-operacao AS CHARACTER FORMAT "x(06)" 
     LABEL "Nat Operaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE c-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodo AS CHARACTER FORMAT "99/9999" 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE BUTTON bt-can 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Ca&n" 
     SIZE 4 BY 1.25 TOOLTIP "Cancelar".

DEFINE BUTTON bt-sav 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sav.bmp":U
     LABEL "&Sav" 
     SIZE 4 BY 1.25 TOOLTIP "Salvar".

DEFINE BUTTON btAdd 
     LABEL "Inserir" 
     SIZE 11 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "Retirar" 
     SIZE 11 BY 1
     FONT 1.

DEFINE BUTTON btOpen 
     LABEL "Recuperar" 
     SIZE 11 BY 1
     FONT 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 11 BY 1
     FONT 1.

DEFINE BUTTON btUpdate 
     LABEL "Alterar" 
     SIZE 11 BY 1
     FONT 1.

DEFINE VARIABLE c-cod-propried AS CHARACTER FORMAT "x(16)" 
     LABEL "Propriedade" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE c-desc-propried AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-produt-rural AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Produtor" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

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

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE BUTTON btConfigImprDest 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btDestinyFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cDestinyFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-imprime AS CHARACTER FORMAT "X(256)":U INITIAL "Imprime" 
      VIEW-AS TEXT 
     SIZE 9 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsAll AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Rejeitados", 2
     SIZE 34 BY .79
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.71.

DEFINE RECTANGLE rect-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 1.71.

DEFINE RECTANGLE rect-rtf-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 3.21.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.cdn-produt   COLUMN-LABEL "Produtor"
tt-digita.nom-produt   COLUMN-LABEL "Nome" WIDTH 25
tt-digita.cod-propried COLUMN-LABEL "Propriedade"
tt-digita.des-propried COLUMN-LABEL "Descriá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 84 BY 8.75
         BGCOLOR 15 FONT 1.


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
     brDigita AT ROW 1.25 COL 1
     btAdd AT ROW 10 COL 1
     btUpdate AT ROW 10 COL 12
     btDelete AT ROW 10 COL 23
     btSave AT ROW 10 COL 34
     btOpen AT ROW 10 COL 45
     i-cdn-produt-rural AT ROW 11.75 COL 10.43 COLON-ALIGNED WIDGET-ID 4
     c-nome-abrev AT ROW 11.75 COL 25.29 NO-LABEL WIDGET-ID 18
     bt-can AT ROW 12.42 COL 73.86 WIDGET-ID 90
     bt-sav AT ROW 12.42 COL 77.86 WIDGET-ID 30
     c-cod-propried AT ROW 12.75 COL 10.43 COLON-ALIGNED WIDGET-ID 2
     c-desc-propried AT ROW 12.75 COL 30.72 NO-LABEL WIDGET-ID 92
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.83
         SIZE 84.43 BY 13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     c-cod-estabel AT ROW 2 COL 16 COLON-ALIGNED WIDGET-ID 2
     c-nome AT ROW 2 COL 26.14 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     c-periodo AT ROW 3 COL 16 COLON-ALIGNED WIDGET-ID 10
     c-cod-serie AT ROW 4 COL 16 COLON-ALIGNED WIDGET-ID 24
     c-data-emissao AT ROW 4.96 COL 16 COLON-ALIGNED WIDGET-ID 62
     cb-item AT ROW 5.96 COL 16 COLON-ALIGNED WIDGET-ID 64
     c-desc-item AT ROW 5.96 COL 34.14 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     c-nat-operacao AT ROW 6.96 COL 16 COLON-ALIGNED WIDGET-ID 68
     c-ds-natureza AT ROW 6.96 COL 28.29 COLON-ALIGNED NO-LABEL WIDGET-ID 66
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configuraá∆o da impressora"
     rsExecution AT ROW 5.71 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 4.96 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.21 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     cIniRegiao AT ROW 1.5 COL 14.85 HELP
          "C¢digo Regi∆o"
          FONT 1
     cFimRegiao AT ROW 1.5 COL 54.43 HELP
          "C¢digo Regi∆o" NO-LABEL WIDGET-ID 26
          FONT 1
     cIniRota AT ROW 2.5 COL 16.43 HELP
          "C¢digo da rota" WIDGET-ID 4
          FONT 1
     cFimRota AT ROW 2.5 COL 54.43 HELP
          "C¢digo da rota" NO-LABEL WIDGET-ID 28
          FONT 1
     cIniGrpProdut AT ROW 3.5 COL 9.43 HELP
          "Grupo Produtor" WIDGET-ID 12
          FONT 1
     cFimGrpProdut AT ROW 3.5 COL 54.43 HELP
          "Grupo Produtor" NO-LABEL WIDGET-ID 30
          FONT 1
     cIniProdut AT ROW 4.5 COL 10 HELP
          "Produtor Rural" WIDGET-ID 20
          FONT 1
     cFimProdut AT ROW 4.5 COL 54.43 HELP
          "Produtor Rural" NO-LABEL WIDGET-ID 32
          FONT 1
     IMAGE-1 AT ROW 1.5 COL 35.86
     IMAGE-2 AT ROW 1.5 COL 51.14
     IMAGE-3 AT ROW 2.5 COL 35.86 WIDGET-ID 6
     IMAGE-4 AT ROW 2.5 COL 51.14 WIDGET-ID 8
     IMAGE-5 AT ROW 3.5 COL 35.86 WIDGET-ID 14
     IMAGE-6 AT ROW 3.5 COL 51.14 WIDGET-ID 16
     IMAGE-7 AT ROW 4.5 COL 35.86 WIDGET-ID 22
     IMAGE-8 AT ROW 4.5 COL 51.14 WIDGET-ID 24
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     rsClassif AT ROW 1.29 COL 2.14 HELP
          "Classificaá∆o para emiss∆o do relat¢rio" NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     edLayout AT ROW 1.25 COL 1 NO-LABEL
     btEdit AT ROW 10.04 COL 1 HELP
          "Dispara a Impress∆o do Layout"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage7
     rsAll AT ROW 2.25 COL 3.14 NO-LABEL
     rsDestiny AT ROW 4.5 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
          SIZE 44 BY 1.08
          FONT 1
     btDestinyFile AT ROW 5.71 COL 43.14 HELP
          "Escolha do nome do arquivo"
     btConfigImprDest AT ROW 5.71 COL 43.14 HELP
          "Configuraá∆o da impressora"
     cDestinyFile AT ROW 5.75 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 7.88 COL 3.14 HELP
          "Modo de Execuá∆o" NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "On-Line", 1,
"Batch", 2
          SIZE 27.86 BY .92
          FONT 1
     text-imprime AT ROW 1.5 COL 2 COLON-ALIGNED NO-LABEL
     text-destino AT ROW 3.75 COL 1.86 COLON-ALIGNED NO-LABEL FORMAT "X(256)":U
           VIEW-AS TEXT 
          SIZE 8.57 BY .63
          FONT 1
     text-modo AT ROW 7.13 COL 1.14 COLON-ALIGNED NO-LABEL FORMAT "X(256)":U
           VIEW-AS TEXT 
          SIZE 10.86 BY .63
          FONT 1
     rect-8 AT ROW 7.42 COL 2
     RECT-11 AT ROW 1.75 COL 2
     rect-rtf-2 AT ROW 4.04 COL 2
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
   Other Settings: COMPILE
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE
       FRAME fPage7:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage1
                                                                        */
ASSIGN 
       edLayout:RETURN-INSERTED IN FRAME fPage1  = TRUE
       edLayout:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN cFimGrpProdut IN FRAME fPage2
   ALIGN-L LIKE = mgind.grp-produt.cdn-grp-produt EXP-SIZE              */
/* SETTINGS FOR FILL-IN cFimProdut IN FRAME fPage2
   ALIGN-L LIKE = mgind.produt-rural.cdn-produt-rural EXP-SIZE          */
/* SETTINGS FOR FILL-IN cFimRegiao IN FRAME fPage2
   ALIGN-L LIKE = mgind.regiao-abrangen.cod-regiao EXP-SIZE             */
/* SETTINGS FOR FILL-IN cFimRota IN FRAME fPage2
   ALIGN-L LIKE = mgind.rota-coleta.cod-rota EXP-SIZE                   */
/* SETTINGS FOR FILL-IN cIniGrpProdut IN FRAME fPage2
   ALIGN-L LIKE = mgind.grp-produt.cdn-grp-produt EXP-SIZE              */
/* SETTINGS FOR FILL-IN cIniProdut IN FRAME fPage2
   ALIGN-L LIKE = mgind.produt-rural.cdn-produt-rural EXP-SIZE          */
/* SETTINGS FOR FILL-IN cIniRegiao IN FRAME fPage2
   ALIGN-L LIKE = mgind.regiao-abrangen.cod-regiao EXP-SIZE             */
/* SETTINGS FOR FILL-IN cIniRota IN FRAME fPage2
   ALIGN-L LIKE = mgind.rota-coleta.cod-rota EXP-SIZE                   */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN c-ds-natureza IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nat-operacao IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
/* SETTINGS FOR FILL-IN c-desc-propried IN FRAME fPage5
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME fPage5
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

/* SETTINGS FOR FRAME fPage7
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage7     = 
                "Destino".

ASSIGN 
       text-imprime:PRIVATE-DATA IN FRAME fPage7     = 
                "Imprime".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage7     = 
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage7
/* Query rebuild information for FRAME fPage7
     _Query            is NOT OPENED
*/  /* FRAME fPage7 */
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
        display tt-digita.cdn-produt
                tt-digita.nom-produt
                tt-digita.cod-propried with browse brDigita. 
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
ON VALUE-CHANGED OF brDigita IN FRAME fPage5
DO:
    IF brDigita:NUM-SELECTED-ROWS > 0 THEN DO:
      GET CURRENT brDigita.
      ASSIGN i-cdn-produt-rural:SCREEN-VALUE = string(tt-digita.cdn-produt)
             c-nome-abrev:SCREEN-VALUE = tt-digita.nom-produt
             c-cod-propried:SCREEN-VALUE = tt-digita.cod-propried.

      APPLY "LEAVE" TO i-cdn-produt-rural IN FRAME fpage5.
      APPLY "LEAVE" TO c-cod-propried     IN FRAME fpage5.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-can
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-can wReport
ON CHOOSE OF bt-can IN FRAME fPage5 /* Can */
DO:
   ASSIGN i-cdn-produt-rural:SCREEN-VALUE IN FRAME fPage5 = ""
          c-nome-abrev:SCREEN-VALUE       IN FRAME fPage5 = ""
          i-cdn-produt-rural:SENSITIVE    IN FRAME fPage5 = NO 
          c-cod-propried:SCREEN-VALUE     IN FRAME fPage5 = ""
          c-cod-propried:SENSITIVE        IN FRAME fPage5 = NO 
          bt-sav:SENSITIVE               IN FRAME fPage5 = NO
          bt-can:SENSITIVE               IN FRAME fPage5 = NO 
          btAdd:SENSITIVE                IN FRAME fPage5 = YES 
          btOpen:SENSITIVE               IN FRAME fPage5 = YES.

    IF CAN-FIND(FIRST tt-digita) THEN 
        ASSIGN btUpdate:SENSITIVE IN FRAME fPage5 = YES
               btDelete:SENSITIVE IN FRAME fPage5 = YES
               btSave:SENSITIVE   IN FRAME fPage5 = YES.
    APPLY 'value-changed' TO brDigita IN FRAME fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sav
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sav wReport
ON CHOOSE OF bt-sav IN FRAME fPage5 /* Sav */
DO:
  IF NOT AVAIL tt-digita THEN 
    {&OPEN-QUERY-brDigita}

  IF VALID-HANDLE(h-boin00962) THEN DO:
      RUN gotokey IN h-boin00962(INPUT INPUT FRAME fPage5 i-cdn-produt-rural).
      IF RETURN-VALUE = "NOK" THEN DO:
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Produtor Rural" *}
          RUN utp/ut-msgs.p (INPUT "show", 
                             INPUT 2, 
                             INPUT RETURN-VALUE).    
          APPLY "entry" TO i-cdn-produt-rural IN FRAME fPage5.
      END.
      ELSE DO:
          /* se for alteraá∆o, exclui o selecionado e inclui o novo*/
          IF btUpdate:SENSITIVE THEN 
            DELETE tt-digita.
          
          CREATE tt-digita.
          ASSIGN tt-digita.cdn-produt   = int(i-cdn-produt-rural:SCREEN-VALUE IN FRAME fPage5)
                 tt-digita.nom-produt   = c-nome-abrev:SCREEN-VALUE IN FRAME fPage5
                 tt-digita.cod-propried = c-cod-propried:SCREEN-VALUE IN FRAME fPage5
                 tt-digita.des-propried = c-desc-propried:SCREEN-VALUE IN FRAME fPage5.

          {&OPEN-QUERY-brDigita}
          {&OPEN-BROWSERS-IN-QUERY-fPage0}

          APPLY 'choose' TO bt-can IN FRAME fPage5.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fPage5 /* Inserir */
DO:
   ASSIGN i-cdn-produt-rural:SENSITIVE     IN FRAME fPage5 = YES
          i-cdn-produt-rural:SCREEN-VALUE  IN FRAME fPage5 = ""
          c-nome-abrev:SCREEN-VALUE        IN FRAME fPage5 = ""
          c-cod-propried:SCREEN-VALUE      IN FRAME fPage5 = ""
          c-desc-propried:SCREEN-VALUE     IN FRAME fPage5 = ""
          c-cod-propried:SENSITIVE         IN FRAME fPage5 = YES
          bt-sav:SENSITIVE                 IN FRAME fPage5 = YES
          bt-can:SENSITIVE                 IN FRAME fPage5 = YES
          btUpdate:SENSITIVE               IN FRAME fPage5 = NO   
          btDelete:SENSITIVE               IN FRAME fPage5 = NO 
          btSave:SENSITIVE                 IN FRAME fPage5 = NO 
          btOpen:SENSITIVE                 IN FRAME fPage5 = no.
    APPLY "entry" TO i-cdn-produt-rural IN FRAME fPage5.
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


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btConfigImprDest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImprDest wReport
ON CHOOSE OF btConfigImprDest IN FRAME fPage7
DO:
   {report/imimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wReport
ON CHOOSE OF btDelete IN FRAME fPage5 /* Retirar */
DO:
   IF brDigita:NUM-SELECTED-ROWS > 0 THEN DO 
       ON ERROR UNDO, return NO-APPLY:
        IF AVAIL tt-digita then do:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 3051, 
                               INPUT " ").
            IF RETURN-VALUE = "yes" THEN DO:
                GET CURRENT brDigita.
                DELETE tt-digita.
                IF brDigita:DELETE-CURRENT-ROW() IN FRAME fPage5 THEN.
            END.
        END.
    END.

    IF NUM-RESULTS("brDigita":U) = 0 THEN
        ASSIGN i-cdn-produt-rural:SCREEN-VALUE IN FRAME fPage5 = ""
               c-nome-abrev:SCREEN-VALUE       IN FRAME fPage5 = ""
               c-cod-propried:SCREEN-VALUE     IN FRAME fpage5 = "" 
               btUpdate:SENSITIVE              IN FRAME fPage5 = NO
               btDelete:SENSITIVE              IN FRAME fPage5 = NO
               btSave:SENSITIVE                IN FRAME fPage5 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btDestinyFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDestinyFile wReport
ON CHOOSE OF btDestinyFile IN FRAME fPage7
DO:
    {report/imarq.i cDestinyFile fPage7}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btEdit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEdit wReport
ON CHOOSE OF btEdit IN FRAME fPage1 /* Editar Layout */
DO:
   {report/imedl.i}
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
  IF brDigita:NUM-SELECTED-ROWS > 0 THEN DO 
      ON ERROR UNDO, RETURN NO-APPLY:
        ASSIGN i-cdn-produt-rural:SENSITIVE IN FRAME fPage5 = YES 
               c-cod-propried:SENSITIVE IN FRAME fPage5 = YES 
               bt-sav:SENSITIVE  IN FRAME fPage5 = YES 
               bt-can:SENSITIVE IN FRAME fPage5 = YES 
               btAdd:SENSITIVE         IN FRAME fPage5 = NO 
               btDelete:SENSITIVE      IN FRAME fPage5 = NO 
               btSave:SENSITIVE        IN FRAME fPage5 = NO 
               btOpen:SENSITIVE        IN FRAME fPage5 = NO 
               i-cdn-produt-rural:SCREEN-VALUE IN FRAME fPage5 = string(tt-digita.cdn-produt)
               c-cod-propried:SCREEN-VALUE IN FRAME fPage5 = tt-digita.cod-propried.
        APPLY "leave" TO i-cdn-produt-rural IN FRAME fPage5.
        APPLY "entry" TO i-cdn-produt-rural IN FRAME fPage5.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON LEAVE OF c-cod-estabel IN FRAME fPage4 /* Estabelecimento */
DO:
    DEF VAR c-data AS CHAR NO-UNDO.
    DEF VAR c-mes  AS INT FORMAT "99" NO-UNDO.
    DEF VAR c-ano  AS INT FORMAT "9999" NO-UNDO.
    DEF VAR c-cod-periodo AS CHAR NO-UNDO.

    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=c-nome
                     &where="estabelec.cod-estabel = input frame fPage4 c-cod-estabel"}
                     
    /*busca ultimo periodo fechado*/
    RUN goToKey IN h-boin00968 (INPUT c-cod-estabel:SCREEN-VALUE IN FRAME fpage4).
    IF RETURN-VALUE = "OK":U THEN DO:
        run getCharField in h-boin00968 (input  "cod-periodo":U,
                                         output c-cod-periodo).
    END.

    IF c-cod-periodo <> "" THEN DO:

        ASSIGN c-periodo:SCREEN-VALUE IN FRAME fpage4 = c-cod-periodo
               c-mes = int(ENTRY(1,c-periodo:SCREEN-VALUE IN FRAME fpage4,"/"))
               c-ano = int(ENTRY(2,c-periodo:SCREEN-VALUE IN FRAME fpage4,"/")).

        IF c-mes = 12 THEN
            ASSIGN c-mes = 1
                   c-ano = c-ano + 1.
        ELSE
            ASSIGN c-mes = c-mes + 1.

        ASSIGN c-data = "01" + "/" + STRING(c-mes) + "/" + STRING(c-ano)
               c-data-emissao:SCREEN-VALUE IN FRAME fpage4 = string(DATE(c-data) - 1).

    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fPage4 /* Estabelecimento */
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z02in684.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="c-cod-estabel"
                         &Frame1="fPage4"                          
                         &EnableImplant="NO"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME c-cod-propried
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-propried wReport
ON F5 OF c-cod-propried IN FRAME fPage5 /* Propriedade */
DO:
  {method/zoomfields.i 
       &ProgramZoom="inzoom/z01in00980.w"
       &FieldZoom1="cod-propried"
       &FieldScreen1="c-cod-propried"
       &Frame1="fPage5"
       &EnableImplant="YES"
       &RunMethod="run setaFiltroProdutor in hProgramZoom (int(i-cdn-produt-rural:SCREEN-VALUE IN FRAME fPage5))."} 
       
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-propried wReport
ON LEAVE OF c-cod-propried IN FRAME fPage5 /* Propriedade */
DO:
  {method/ReferenceFields.i 
          &HandleDBOLeave="h-boin00980"
          &KeyValue1="c-cod-propried:SCREEN-VALUE IN FRAME fPage5"
          &FieldName1="des-propried"
          &FieldScreen1="c-desc-propried"
          &Frame1="fPage5"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-propried wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-propried IN FRAME fPage5 /* Propriedade */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME c-cod-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-serie wReport
ON F5 OF c-cod-serie IN FRAME fPage4 /* SÇrie */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in407.w
                     &campo=c-cod-serie
                     &campozoom=serie
                     &frame="fPage4"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-serie wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-serie IN FRAME fPage4 /* SÇrie */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao wReport
ON F5 OF c-nat-operacao IN FRAME fPage4 /* Nat Operaá∆o */
DO:
  {method/zoomfields.i &ProgramZoom  = "inzoom/z04in245.w"
                         &FieldZoom1   = "nat-operacao"
                         &FieldScreen1 = "c-nat-operacao"
                         &Frame1       = "fPage4"
                         &FieldZoom2   = "denominacao"
                         &FieldScreen2 = "c-ds-natureza"
                         &Frame2       = "fPage4"
                         &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao wReport
ON LEAVE OF c-nat-operacao IN FRAME fPage4 /* Nat Operaá∆o */
DO:
   {method/referencefields.i &HandleDBOLeave = "h-boin245"
                         &KeyValue1      = "c-nat-operacao:SCREEN-VALUE IN FRAME fPage4"
                         &FieldName1     = "denominacao"
                         &FieldScreen1   = "c-ds-natureza"
                         &Frame1         = "fPage4"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-operacao wReport
ON MOUSE-SELECT-DBLCLICK OF c-nat-operacao IN FRAME fPage4 /* Nat Operaá∆o */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-item wReport
ON VALUE-CHANGED OF cb-item IN FRAME fPage4 /* Item */
DO: 
    DEFINE VARIABLE pDescItem    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE p-tip-aferic AS INTEGER NO-UNDO.
    
    RUN goToKey IN h-boin172na (INPUT SELF:SCREEN-VALUE IN FRAME fPage4) NO-ERROR.  
    IF RETURN-VALUE = "OK":U THEN DO:
    
        RUN findDescItem IN h-boin00983 (INPUT SELF:SCREEN-VALUE IN FRAME fPage4, OUTPUT pDescItem) NO-ERROR.
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage4 = pDescItem. 

    END.
    ELSE
       ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage4 = "".                       
   
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME i-cdn-produt-rural
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-produt-rural wReport
ON F5 OF i-cdn-produt-rural IN FRAME fPage5 /* Produtor */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in00962.w"
                         &FieldZoom1="cdn-produt-rural"
                         &FieldScreen1="i-cdn-produt-rural"
                         &Frame1="fPage5"                          
                         &EnableImplant="YES"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-produt-rural wReport
ON LEAVE OF i-cdn-produt-rural IN FRAME fPage5 /* Produtor */
DO:                         
    DEFINE VARIABLE p-nome-abrev AS CHARACTER NO-UNDO.

    RUN goToKey IN h-boin00962(INPUT INPUT FRAME fPage5 i-cdn-produt-rural).
    IF RETURN-VALUE = 'OK' THEN DO:
        RUN findCodigo IN h-boad098(INPUT i-cdn-produt-rural:SCREEN-VALUE IN FRAME fPage5, 
                                    OUTPUT p-nome-abrev).
        IF p-nome-abrev = "" THEN DO:        
            RUN goToKey      IN h-boad098(INPUT i-cdn-produt-rural:SCREEN-VALUE IN FRAME fPage5) NO-ERROR.
            RUN getCharField IN h-boad098(INPUT "nome-abrev", OUTPUT p-nome-abrev).
        END.

        ASSIGN c-nome-abrev:SCREEN-VALUE IN FRAME fPage5 = p-nome-abrev.    
    END.
    ELSE
         ASSIGN c-nome-abrev:SCREEN-VALUE IN FRAME fPage5 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-produt-rural wReport
ON MOUSE-SELECT-DBLCLICK OF i-cdn-produt-rural IN FRAME fPage5 /* Produtor */
DO:
    APPLY "f5" TO SELF.
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


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage7
DO:
do  with frame fPage7:
    case self:screen-value:
        when "1":U then do:
            assign cDestinyFile:sensitive     = no
                   cDestinyFile:visible       = yes
                   btDestinyFile:visible      = no
                   btConfigImprDest:visible   = yes.
        end.
        when "2":U then do:
            assign cDestinyFile:sensitive     = yes
                   cDestinyFile:visible       = yes
                   btDestinyFile:visible      = yes
                   btConfigImprDest:visible   = no.
        end.
        when "3":U then do:
            assign cDestinyFile:sensitive     = no
                   cDestinyFile:visible       = no
                   btDestinyFile:visible      = no
                   btConfigImprDest:visible   = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage7
DO:
   {report/imrse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{report/mainblock.i}

c-nat-operacao:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.
c-cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.
c-cod-serie:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.
i-cdn-produt-rural:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5.
c-cod-propried:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5.

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

DEF VAR c-char-1 AS CHAR NO-UNDO.  
DEF VAR c-list   AS CHAR NO-UNDO.

&IF "{&RTF}":U = "YES":U &THEN
IF VALID-HANDLE(hWenController) THEN DO:
    ASSIGN l-habilitaRtf:sensitive IN FRAME fPage6 = NO
           l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
           l-habilitaRtf = NO.
           
END.
RUN pi-habilitaRtf.
&endif

/*inicializa faixas de seleá∆o*/
ASSIGN cFimRegiao:SCREEN-VALUE IN FRAME fpage2    = "ZZZZZZZZZZZZ"
       cFimRota:SCREEN-VALUE IN FRAME fpage2      = "ZZZZZZZZZZZZ"
       cFimGrpProdut:SCREEN-VALUE IN FRAME fpage2 = "999999"
       cFimProdut:SCREEN-VALUE IN FRAME fpage2    = "999999999".


/*busca estabelecimento padr∆o do usu†rio*/
run goToKey in h-boin627na (input c-seg-usuario).
if  return-value = "OK":U then do:

    run getCharField in h-boin627na (input  "char-1":U,
                                     output c-char-1).
end.

ASSIGN c-cod-estabel:SCREEN-VALUE IN FRAME fpage4 = SUBSTR(c-char-1,16,5).

APPLY "LEAVE" TO c-cod-estabel IN FRAME fpage4.

/*carrega combo de itens*/
RUN getListItems IN h-boin00983(INPUT c-cod-estabel:SCREEN-VALUE IN FRAME fpage4, OUTPUT c-list).   
IF c-list <> "" AND (cb-item:SCREEN-VALUE IN FRAME fPage4 = "" OR cb-item:SCREEN-VALUE IN FRAME fPage4 = ?)THEN DO:        
    ASSIGN cb-item:LIST-ITEMS IN FRAME fPage4   = c-list
           cb-item:SCREEN-VALUE IN FRAME fPage4 = ENTRY (1,c-list).
           
    APPLY 'VALUE-CHANGED':U TO cb-item IN FRAME fPage4. 
END.

RUN setFolder IN hFolder (INPUT 1).

RETURN "OK".

/*Fim alteracao 17/02/2005*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wReport 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-boin00962) THEN DO:
        DELETE PROCEDURE h-boin00962.
        ASSIGN h-boin00962 = ?.    
    END.

    IF VALID-HANDLE(h-boin00968) THEN DO:
        DELETE PROCEDURE h-boin00968.
        ASSIGN h-boin00968 = ?.    
    END.

    IF VALID-HANDLE(h-boin00980) THEN DO:
        DELETE PROCEDURE h-boin00980.
        ASSIGN h-boin00980 = ?.
    END.

    IF VALID-HANDLE(h-boin00983) THEN DO:
        DELETE PROCEDURE h-boin00983.
        ASSIGN h-boin00983 = ?.
    END.

    IF VALID-HANDLE(h-boin172na) THEN DO:
        DELETE PROCEDURE h-boin172na.
        ASSIGN h-boin172na = ?.
    END.

    IF VALID-HANDLE(h-boin245) THEN DO:
        DELETE PROCEDURE h-boin245.
        ASSIGN h-boin245 = ?.
    END.

    IF VALID-HANDLE(h-boin245zm) THEN DO:
        DELETE PROCEDURE h-boin245zm.
        ASSIGN h-boin245zm = ?.
    END.

    IF VALID-HANDLE(h-boin627na) THEN DO:
        DELETE PROCEDURE h-boin627na.
        ASSIGN h-boin627na = ?.
    END.

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

    IF NOT VALID-HANDLE(h-boin627na) THEN DO:
        RUN inbo/boin627na.p PERSISTENT SET h-boin627na.
    END.
    RUN openQueryStatic IN h-boin627na (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin00968) THEN DO:
        RUN inbo/boin00968.p PERSISTENT SET h-boin00968.
    END.
    RUN openQueryStatic IN h-boin00968 (INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin00980) THEN DO:
        RUN inbo/boin00980.p PERSISTENT SET h-boin00980.
    END.
    RUN openQueryStatic IN h-boin00980 (INPUT "Main":U).

    IF  NOT VALID-HANDLE(h-boin245) THEN DO:
        {btb/btb008za.i1 inbo/boin245.p YES}
        {btb/btb008za.i2 inbo/boin245.p '' h-boin245}
    END.

    RUN openQueryStatic IN h-boin245 (INPUT "Main":U) NO-ERROR.

    IF  NOT VALID-HANDLE(h-boin00962) THEN DO:
        {btb/btb008za.i1 inbo/boin00962.p YES}
        {btb/btb008za.i2 inbo/boin00962.p '' h-boin00962}
    END.
        
    RUN openQueryStatic IN h-boin00962 (INPUT "Main":U) NO-ERROR.

    IF  NOT VALID-HANDLE(h-boad098) THEN DO:
        {btb/btb008za.i1 adbo/boad098.p YES}
        {btb/btb008za.i2 adbo/boad098.p '' h-boad098}
    END.
        
    RUN openQueryStatic IN h-boad098 (INPUT "Main":U) NO-ERROR.

    IF  NOT VALID-HANDLE(h-boin245zm) THEN DO:
        {btb/btb008za.i1 inbo/boin245zm.p YES}
        {btb/btb008za.i2 inbo/boin245zm.p '' h-boin245zm}
    END.
       
    RUN openQueryStatic IN h-boin245zm (INPUT "Main":U) NO-ERROR.

    IF  NOT VALID-HANDLE(h-boin00983) THEN DO:
        {btb/btb008za.i1 inbo/boin00983.p YES}
        {btb/btb008za.i2 inbo/boin00983.p '' h-boin00983}
    END.
       
    RUN openQueryStatic IN h-boin00983 (INPUT "Main":U) NO-ERROR.

    IF  NOT VALID-HANDLE(h-boin172na) THEN DO:
        {btb/btb008za.i1 inbo/boin172na.p YES}
        {btb/btb008za.i2 inbo/boin172na.p '' h-boin172na}
    END.
       
    RUN openQueryStatic IN h-boin172na (INPUT "Main":U) NO-ERROR.
    
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

DEFINE VAR r-tt-digita   as rowid no-undo.
DEFINE VAR c-nat-oper    AS CHAR  NO-UNDO.
DEFINE VAR l-imp-nota    AS LOG   NO-UNDO.
DEFINE VAR l-transf      AS LOG   NO-UNDO.
DEFINE VAR l-nota-rateio AS LOG   NO-UNDO.
DEFINE VAR l-oper-triang AS LOG   NO-UNDO.
DEFINE VAR l-oper-terc   AS LOG   NO-UNDO.
DEFINE VAR l-ind-entfut  AS LOG   NO-UNDO.
DEFINE VAR c-char-1      AS CHAR  NO-UNDO.

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
    
    /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).
        
        /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita */
        find first b-tt-digita 
            where b-tt-digita.cdn-produt = tt-digita.cdn-produt 
              and rowid(b-tt-digita) <> rowid(tt-digita) 
            no-lock no-error.
        if  avail b-tt-digita then do:
            reposition brDigita to rowid rowid(b-tt-digita).
            
            run utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
            
            return error.
        end.
        
        /*:T As demais validaá‰es devem ser feitas aqui */
        /*if  tt-digita.ordem <= 0 then do:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.ordem:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.
           
            run utp/ut-msgs.p (input "SHOW":U, input 99999, input "":U).
            apply "ENTRY":U to tt-digita.ordem in browse brDigita.
            
            return error.
        end.*/
        
    end.
    
    
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */

    /*Validaá∆o da SÇrie*/
    RUN validaSerieEstab IN h-boin00968 (INPUT INPUT FRAME fpage4 c-cod-estabel,
                                         INPUT INPUT FRAME fpage4 c-cod-serie,
                                         INPUT INPUT FRAME fpage4 c-data-emissao).
    IF RETURN-VALUE = "NOK":U THEN DO:
        APPLY "entry" TO c-data-emissao IN FRAME fpage4.
        RETURN NO-APPLY.
    END.

    /*Validaá∆o da Natureza*/
    /*Valida se a natureza ? do tipo entrada (1/2/3).*/ 
    assign c-nat-oper = INPUT FRAME fpage4 c-nat-operacao.
    if substrin(c-nat-oper,1,1) <> "1" and
       substrin(c-nat-oper,1,1) <> "2" and 
       substrin(c-nat-oper,1,1) <> "3" then do:
       run utp/ut-msgs.p ('show', 27705, "").
       apply 'entry' to c-nat-operacao IN FRAME fpage4.
       return no-apply.
    end.

    RUN gotokey IN h-boin245zm (INPUT INPUT FRAME fpage4 c-nat-operacao).
    IF  RETURN-VALUE = "OK":U THEN DO:
        RUN getLogField IN h-boin245zm  (INPUT  "imp-nota":U,
                                         OUTPUT l-imp-nota).
        RUN getLogField IN h-boin245zm  (INPUT  "transf":U,
                                         OUTPUT l-transf).
        RUN getLogField IN h-boin245zm  (INPUT  "nota-rateio":U,
                                         OUTPUT l-nota-rateio).
        RUN getLogField IN h-boin245zm  (INPUT  "log-oper-triang":U,
                                         OUTPUT l-oper-triang).
        RUN getLogField IN h-boin245zm  (INPUT  "terceiros":U,
                                         OUTPUT l-oper-terc).
        RUN getLogField IN h-boin245zm  (INPUT  "ind-entfut":U,
                                         OUTPUT l-ind-entfut).
        RUN getCharField IN h-boin245zm (INPUT  "char-1":U,
                                         OUTPUT c-char-1).
    END.
    
    IF NOT l-imp-nota THEN DO:
        run utp/ut-msgs.p ('show', 28153, "").
        apply 'entry' to c-nat-operacao IN FRAME fpage4.
        return no-apply.
    END.

    IF l-transf THEN DO:
        {utp/ut-liter.i "Tranferància" *}
        run utp/ut-msgs.p ('show', 54842, RETURN-VALUE).
        apply 'entry' to c-nat-operacao IN FRAME fpage4.
        return no-apply.
    END.                                     
    
    IF l-nota-rateio THEN DO:
        {utp/ut-liter.i "Rateio" *}
        run utp/ut-msgs.p ('show', 54842, RETURN-VALUE).
        apply 'entry' to c-nat-operacao IN FRAME fpage4.
        return no-apply.
    END.
    
    IF l-oper-triang THEN DO:
        {utp/ut-liter.i "Operaá∆o_Triangular" *}
        run utp/ut-msgs.p ('show', 54842, RETURN-VALUE).
        apply 'entry' to c-nat-operacao IN FRAME fpage4.
        return no-apply.
    END.

    IF l-oper-terc THEN DO:
        {utp/ut-liter.i "Operaá∆o_com_Terceiros" *}
        run utp/ut-msgs.p ('show', 54842, RETURN-VALUE).
        apply 'entry' to c-nat-operacao IN FRAME fpage4.
        return no-apply.
    END.

    IF l-ind-entfut THEN DO:
        {utp/ut-liter.i "Entrega_Futura" *}
        run utp/ut-msgs.p ('show', 54842, RETURN-VALUE).
        apply 'entry' to c-nat-operacao IN FRAME fpage4.
        return no-apply.
    END.

    IF SUBSTRING(c-char-1,1,5) = "1" THEN DO:
        {utp/ut-liter.i "Faturamento_Antecipado" *}
        run utp/ut-msgs.p ('show', 54842, RETURN-VALUE).
        apply 'entry' to c-nat-operacao IN FRAME fpage4.
        return no-apply.
    END.
    
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
           &IF "{&RTF}":U = "YES":U &THEN
           tt-param.modelo          = INPUT FRAME fPage6 cModelRTF
           tt-param.l-habilitaRtf   = INPUT FRAME fPage6 l-habilitaRtf
           &endif                   
           tt-param.regiao-ini      = INPUT FRAME fPage2 cIniRegiao
           tt-param.regiao-fim      = INPUT FRAME fPage2 cFimRegiao
           tt-param.rota-ini        = INPUT FRAME fPage2 cIniRota
           tt-param.rota-fim        = INPUT FRAME fPage2 cFimRota
           tt-param.grp-prod-ini    = INPUT FRAME fPage2 cIniGrpProdut
           tt-param.grp-prod-fim    = INPUT FRAME fPage2 cFimGrpProdut
           tt-param.prod-rural-ini  = INPUT FRAME fPage2 cIniProdut
           tt-param.prod-rural-fim  = INPUT FRAME fPage2 cFimProdut
           tt-param.cod-estabel     = INPUT FRAME fPage4 c-cod-estabel
           tt-param.cod-periodo     = INPUT FRAME fPage4 c-periodo
           tt-param.cod-serie       = INPUT FRAME fPage4 c-cod-serie
           tt-param.dt-emissao      = INPUT FRAME fPage4 c-data-emissao
           tt-param.it-codigo       = INPUT FRAME fPage4 cb-item
           tt-param.nat-operacao    = INPUT FRAME fPage4 c-nat-operacao.
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i aqp/aq0311rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

