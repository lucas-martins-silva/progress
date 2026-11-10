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
{include/i-prgvrs.i AQ0325 2.00.00.009 } /*** 010009 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0325 MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors DEFinitions ---                                      */
&GLOBAL-DEFINE Program        AQ0325
&GLOBAL-DEFINE Version        2.00.00.009
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    2
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetro,Digita‡Æo,ImpressÆo

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
&GLOBAL-DEFINE page4Widgets   tg-elimina-nota tg-elimina-nota-compl
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
&GLOBAL-DEFINE page6Text      text-destino text-modo text-rtf text-ModelRtf
&GLOBAL-DEFINE page7Text      text-imprime text-destino
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1FIELDs    
&GLOBAL-DEFINE page2Fields    cFimGrpProdut cFimProdut cFimRegiao cFimRota cIniGrpProdut cIniProdut cIniRegiao cIniRota cFimPropried cIniPropried
&GLOBAL-DEFINE page3FIELDs    
&GLOBAL-DEFINE page4FIELDs    c-cod-estabel c-periodo cb-item
&GLOBAL-DEFINE page5FIELDs    
&GLOBAL-DEFINE page6FIELDs    cFile cModelRTF
&GLOBAL-DEFINE page7FIELDs    cDestinyFile
&GLOBAL-DEFINE page8FIELDs    

/* Parameters DEFinitions ---                                           */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino            AS INTEGER
    FIELD arquivo            AS CHAR FORMAT "x(35)":U
    FIELD usuario            AS CHAR FORMAT "x(12)":U
    FIELD data-exec          AS DATE
    FIELD hora-exec          AS INTEGER
    FIELD classifica         AS INTEGER
    FIELD desc-classifica    AS CHAR FORMAT "x(40)":U
    FIELD modelo             AS CHAR FORMAT "x(35)":U
    FIELD l-habilitaRtf      as LOG
    FIELD regiao-ini         as char format "x(12)":U
    FIELD regiao-fim         as char format "x(12)":U
    FIELD rota-ini           as char format "x(12)":U
    FIELD rota-fim           as char format "x(12)":U
    FIELD grp-prod-ini       AS INTEGER
    FIELD grp-prod-fim       AS INTEGER
    FIELD propried-ini       AS CHARACTER
    FIELD propried-fim       AS CHARACTER
    FIELD prod-rural-ini     AS INTEGER
    FIELD prod-rural-fim     AS INTEGER
    FIELD cod-estabel        AS CHAR FORMAT "x(5)":U
    FIELD cod-periodo        AS CHAR FORMAT "99/9999"
    FIELD cod-serie          AS CHAR FORMAT "x(5)":U
    FIELD dt-emissao         AS DATE FORMAT "99/99/9999"
    FIELD it-codigo          AS CHAR FORMAT "X(16)":U
    FIELD nat-operacao       AS CHAR FORMAT "X(6)":U
    FIELD elimina-nota       AS LOG
    FIELD elimina-nota-compl AS LOG.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD cdn-produt   AS INTEGER FORMAT ">>>,>>>,>>9"      
    FIELD nom-produt   AS CHAR                              
    FIELD cod-propried AS CHAR FORMAT "X(16)"
    FIELD des-propried AS CHAR FORMAT "X(60)"
    index id cdn-produt.

DEFINE BUFFER b-tt-digita FOR tt-digita.

DEF VAR raw-param        AS RAW NO-UNDO.

DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita      AS RAW.

DEF VAR l-ok               AS LOGICAL NO-UNDO.
DEF VAR c-arq-digita       AS CHAR    NO-UNDO.
DEF VAR c-terminal         AS CHAR    NO-UNDO.
DEF VAR c-rtf              AS CHAR    NO-UNDO.
DEF VAR c-arq-layout       AS CHAR    NO-UNDO.      
DEF VAR c-arq-temp         AS CHAR    NO-UNDO.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.
DEF VAR h-boin627na        AS HANDLE  NO-UNDO.
DEF VAR h-boin00962        AS HANDLE  NO-UNDO.
DEF VAR h-boad098          AS HANDLE  NO-UNDO.
DEF VAR h-boin00968        AS HANDLE  NO-UNDO.
DEF VAR h-boin00980        AS HANDLE  NO-UNDO.
DEF VAR h-boin00983        AS HANDLE  NO-UNDO.
DEF VAR h-boin172na        AS HANDLE  NO-UNDO.
DEF VAR c-nome-usuar       AS CHAR    NO-UNDO.
DEF VAR c-cod-periodo      AS CHARACTER NO-UNDO.

DEF STREAM s-imp.

/*15/02/2005 - tech1007 - Variavel DEFinida para tratar se o programa est  rodando no WebEnabler*/
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

DEFINE VARIABLE cFimGrpProdut AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cFimProdut LIKE produt-rural.cdn-produt-rural
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cFimPropried LIKE nf-produt-propried.cod-propried
     VIEW-AS FILL-IN 
     SIZE 19.57 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cFimRegiao LIKE regiao-abrangen.cod-regiao
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cFimRota LIKE rota-coleta.cod-rota
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniGrpProdut AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Grupo Produtor" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniProdut LIKE produt-rural.cdn-produt-rural
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniPropried LIKE nf-produt-propried.cod-propried
     VIEW-AS FILL-IN 
     SIZE 19.57 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniRegiao LIKE regiao-abrangen.cod-regiao
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cIniRota LIKE rota-coleta.cod-rota
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88
     FONT 1 NO-UNDO.

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

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rsClassif AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Por Classifica‡Æo 1", 1,
"Por Classifica‡Æo 2", 2,
"Por Classifica‡Æo 3", 3,
"Por Classifica‡Æo 4", 4
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
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodo AS CHARACTER FORMAT "99/9999" 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE tg-elimina-nota AS LOGICAL INITIAL no 
     LABEL "Elimina Notas Produtor Rural" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY .83 NO-UNDO.

DEFINE VARIABLE tg-elimina-nota-compl AS LOGICAL INITIAL no 
     LABEL "Elimina Notas Complementares Prod. Rural" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY .83 NO-UNDO.

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
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-propried AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-produt-rural AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Produtor" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image/im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btModelRtf 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
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

DEFINE BUTTON btConfigImprDest 
     IMAGE-UP FILE "image/im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btDestinyFile 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
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
tt-digita.des-propried COLUMN-LABEL "Descri‡Æo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 84 BY 8.75
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.71 COL 1.86
     btCancel AT ROW 16.71 COL 12.29
     btHelp2 AT ROW 16.71 COL 80.29
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage4
     c-cod-estabel AT ROW 2 COL 16 COLON-ALIGNED
     c-nome AT ROW 2 COL 26.14 COLON-ALIGNED NO-LABEL
     c-periodo AT ROW 3 COL 16 COLON-ALIGNED
     cb-item AT ROW 4 COL 16 COLON-ALIGNED
     c-desc-item AT ROW 4 COL 34.14 COLON-ALIGNED NO-LABEL
     tg-elimina-nota AT ROW 5.25 COL 18 WIDGET-ID 2
     tg-elimina-nota-compl AT ROW 6 COL 18 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 13
         FONT 1.

DEFINE FRAME fPage3
     rsClassif AT ROW 1.29 COL 2.14 HELP
          "Classifica‡Æo para emissÆo do relat¢rio" NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage2
     cIniRegiao AT ROW 2 COL 16.29 COLON-ALIGNED HELP
          "C¢digo RegiÆo"
          FONT 1
     cFimRegiao AT ROW 2 COL 52.29 COLON-ALIGNED HELP
          "C¢digo RegiÆo" NO-LABEL
          FONT 1
     cIniRota AT ROW 3 COL 16.29 COLON-ALIGNED HELP
          "C¢digo da rota"
          FONT 1
     cFimRota AT ROW 3 COL 52.29 COLON-ALIGNED HELP
          "C¢digo da rota" NO-LABEL
          FONT 1
     cIniGrpProdut AT ROW 4 COL 16.29 COLON-ALIGNED HELP
          "Grupo Produtor"
     cFimGrpProdut AT ROW 4 COL 52.29 COLON-ALIGNED HELP
          "Grupo Produtor" NO-LABEL
     cIniProdut AT ROW 5 COL 7.72 HELP
          "Produtor Rural"
          FONT 1
     cFimProdut AT ROW 5 COL 54.29 HELP
          "Produtor Rural" NO-LABEL
          FONT 1
     cIniPropried AT ROW 6 COL 16.29 COLON-ALIGNED HELP
          "C¢digo Propriedade"
          FONT 1
     cFimPropried AT ROW 6 COL 52.29 COLON-ALIGNED HELP
          "C¢digo Propriedade" NO-LABEL
          FONT 1
     IMAGE-5 AT ROW 6 COL 38.14
     IMAGE-6 AT ROW 6 COL 51
     IMAGE-7 AT ROW 5 COL 38.14
     IMAGE-8 AT ROW 5 COL 51
     IMAGE-9 AT ROW 3 COL 38.14
     IMAGE-10 AT ROW 3 COL 51
     IMAGE-11 AT ROW 2 COL 38.14
     IMAGE-12 AT ROW 2 COL 51
     IMAGE-13 AT ROW 4 COL 38.14
     IMAGE-14 AT ROW 4 COL 51
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 13
         FONT 1.

DEFINE FRAME fPage1
     edLayout AT ROW 1.25 COL 1 NO-LABEL
     btEdit AT ROW 10.04 COL 1 HELP
          "Dispara a ImpressÆo do Layout"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage7
     rsAll AT ROW 2.25 COL 3.14 NO-LABEL
     rsDestiny AT ROW 4.5 COL 3.14 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
          SIZE 44 BY 1.08
          FONT 1
     btConfigImprDest AT ROW 5.71 COL 43.14 HELP
          "Configura‡Æo da impressora"
     btDestinyFile AT ROW 5.71 COL 43.14 HELP
          "Escolha do nome do arquivo"
     cDestinyFile AT ROW 5.75 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 7.88 COL 3.14 HELP
          "Modo de Execu‡Æo" NO-LABEL
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
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 10.15
         FONT 1.

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
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 13
         FONT 1.

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     btAdd AT ROW 10 COL 1
     btUpdate AT ROW 10 COL 12
     btDelete AT ROW 10 COL 23
     btSave AT ROW 10 COL 34
     btOpen AT ROW 10 COL 45
     i-cdn-produt-rural AT ROW 11.75 COL 10.43 COLON-ALIGNED
     c-cod-propried AT ROW 12.75 COL 10.43 COLON-ALIGNED
     bt-can AT ROW 12.42 COL 73.86
     c-nome-abrev AT ROW 11.75 COL 25.29 NO-LABEL NO-TAB-STOP 
     bt-sav AT ROW 12.42 COL 77.86
     c-desc-propried AT ROW 12.75 COL 30.72 NO-LABEL NO-TAB-STOP 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 13
         FONT 1.


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
/* SETTINGS FOR FILL-IN cFimProdut IN FRAME fPage2
   ALIGN-L LIKE = mgind.produt-rural.cdn-produt-rural EXP-SIZE          */
/* SETTINGS FOR FILL-IN cFimPropried IN FRAME fPage2
   LIKE = mgmov.nf-produt-propried.cod-propried EXP-SIZE                */
/* SETTINGS FOR FILL-IN cFimRegiao IN FRAME fPage2
   LIKE = mgcad.regiao-abrangen.cod-regiao EXP-SIZE                     */
/* SETTINGS FOR FILL-IN cFimRota IN FRAME fPage2
   LIKE = mgcad.rota-coleta.cod-rota EXP-SIZE                           */
/* SETTINGS FOR FILL-IN cIniProdut IN FRAME fPage2
   ALIGN-L LIKE = mgind.produt-rural.cdn-produt-rural EXP-SIZE          */
/* SETTINGS FOR FILL-IN cIniPropried IN FRAME fPage2
   LIKE = mgmov.nf-produt-propried.cod-propried EXP-SIZE                */
/* SETTINGS FOR FILL-IN cIniRegiao IN FRAME fPage2
   LIKE = mgcad.regiao-abrangen.cod-regiao EXP-SIZE                     */
/* SETTINGS FOR FILL-IN cIniRota IN FRAME fPage2
   LIKE = mgcad.rota-coleta.cod-rota EXP-SIZE                           */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage5
   Custom                                                               */
/* BROWSE-TAB brDigita 1 fPage5 */
/* SETTINGS FOR FILL-IN c-desc-propried IN FRAME fPage5
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME fPage5
   ALIGN-L                                                              */
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
                "Execu‡Æo".

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
    DO WITH FRAME fPage5:
      GET CURRENT brDigita.
      ASSIGN i-cdn-produt-rural:SCREEN-VALUE = STRING(tt-digita.cdn-produt)
             c-nome-abrev      :SCREEN-VALUE = tt-digita.nom-produt
             c-cod-propried    :SCREEN-VALUE = tt-digita.cod-propried
             c-desc-propried   :SCREEN-VALUE = tt-digita.des-propried.
    END.
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
      RETURN "NOK".
    END.
  END.

  IF VALID-HANDLE(h-boin00980) THEN DO:
    RUN gotokey IN h-boin00980(INPUT INPUT FRAME fPage5 c-cod-propried).
    IF RETURN-VALUE = "NOK" THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "C¢digo Propriedade" *}
        RUN utp/ut-msgs.p (INPUT "show", 
                           INPUT 2, 
                           INPUT RETURN-VALUE).    
        APPLY "entry" TO c-cod-propried IN FRAME fPage5.
        RETURN "NOK".
    END.
  END.

  /* se for altera‡Æo, exclui o selecionado e inclui o novo*/
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
          c-cod-propried:SENSITIVE         IN FRAME fPage5 = YES
          c-desc-propried:SCREEN-VALUE     IN FRAME fPage5 = ""
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
               c-desc-propried:SCREEN-VALUE    IN FRAME fpage5 = "" 
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
  DO ON ERROR UNDO, RETURN NO-APPLY:
    RUN piExecute.
  END.
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
ON F5 OF c-cod-estabel IN FRAME fPage4 /* Estabelecimento */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z02in684.w"
                       &FieldZoom1="cod-estabel"
                       &FieldScreen1="c-cod-estabel"
                       &Frame1="fPage4"                          
                       &EnableImplant="NO"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON LEAVE OF c-cod-estabel IN FRAME fPage4 /* Estabelecimento */
DO:
  
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-nome
                   &where="estabelec.cod-estabel = input frame fPage4 c-cod-estabel"}
                   
  /* Busca £ltimo per¡odo fechado */
  RUN goToKey IN h-boin00968 (INPUT c-cod-estabel:SCREEN-VALUE IN FRAME fpage4).
  IF RETURN-VALUE = "OK":U THEN DO:
    RUN getCharField IN h-boin00968 (INPUT "cod-periodo":U,
                                    OUTPUT c-cod-periodo).
  END.

  ASSIGN c-periodo:SCREEN-VALUE IN FRAME fpage4 = c-cod-periodo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fPage4 /* Estabelecimento */
DO:
  APPLY "F5" TO SELF.
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


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

c-cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.
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
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializa‡Æo
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

/*inicializa faixas de sele‡Æo*/
ASSIGN cFimProdut   :SCREEN-VALUE IN FRAME fpage2 = "999999999"
       cFimRegiao   :SCREEN-VALUE IN FRAME fpage2 = "ZZZZZZZZZZZZ"
       cFimRota     :SCREEN-VALUE IN FRAME fpage2 = "ZZZZZZZZZZZZ" 
       cFimPropried :SCREEN-VALUE IN FRAME fpage2 = "ZZZZZZZZZZZZZZZZ"
       cFimGrpProdut:SCREEN-VALUE IN FRAME fpage2 = "999999".

/*busca estabelecimento padrÆo do usu rio*/
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

c-cod-estabel     :LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage4.
i-cdn-produt-rural:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage5.
c-cod-propried    :LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage5.

RETURN "OK".

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

DEFINE VAR r-tt-digita AS ROWID NO-UNDO.

DO ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
  {report/rpexa.i}

  /*15/02/2005 - tech1007 - Teste alterado pois RTF nÆo ‚ mais op‡Æo de Destino*/
  IF INPUT FRAME fPage6 rsDestiny   = 2 AND
    INPUT FRAME fPage6 rsExecution = 1 THEN DO:
    RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFile).
    IF RETURN-VALUE = "NOK":U THEN DO:
      RUN utp/ut-msgs.p (INPUT "show":U, INPUT 73, INPUT "":U).
      APPLY "ENTRY":U TO cFile IN FRAME fPage6.
      RETURN ERROR.
    END.
  END.

  IF INPUT FRAME fPage4 c-periodo > c-cod-periodo THEN DO:
      {utp/ut-liter.i "Periodo_informado_deve_ser_menor_que_o_£ltimo_periodo_fechado." *}
      RUN utp/ut-msgs.p (INPUT "show":U, INPUT 5663, INPUT RETURN-VALUE).
      APPLY "ENTRY":U TO c-periodo IN FRAME fPage4.
      RETURN ERROR.
  END.
  
  /*16/02/2005 - tech1007 - Teste alterado para validar o modelo informado quando for RTF*/
  &IF "{&RTF}":U = "YES":U &THEN
    IF (INPUT FRAME fPage6 cModelRTF         = ""   AND
        INPUT FRAME fPage6 l-habilitaRtf     = YES) OR
       (SEARCH(INPUT FRAME fPage6 cModelRTF) = ?    AND
        INPUT FRAME fPage6 rsExecution       = 1    AND
        INPUT FRAME fPage6 l-habilitaRtf     = YES) THEN DO:

      RUN utp/ut-msgs.p (INPUT "show":U, INPUT 73, INPUT "":U).
      RETURN ERROR.
    END.
  &ENDIF
  
  FOR EACH tt-digita:
    ASSIGN r-tt-digita = ROWID(tt-digita).
    /*:T Valida‡Æo de duplicidade de registro na temp-table tt-digita */
    FIND FIRST b-tt-digita NO-LOCK
         WHERE b-tt-digita.cdn-produt = tt-digita.cdn-produt 
           AND ROWID(b-tt-digita) <> ROWID(tt-digita) NO-ERROR.
      IF  AVAIL b-tt-digita THEN DO:
        REPOSITION brDigita TO ROWID ROWID(b-tt-digita).
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 108, INPUT "":U).
        RETURN ERROR.
    END.
  END.

  /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
     para o programa RP.P */
  
  CREATE tt-param.
  ASSIGN tt-param.usuario            = c-seg-usuario
         tt-param.destino            = INPUT FRAME fPage6 rsDestiny
         tt-param.data-exec          = TODAY 
         tt-param.hora-exec          = TIME
         tt-param.classifica         = INPUT FRAME fPage3 rsClassif
         tt-param.desc-classifica    = ENTRY((tt-param.classifica - 1) * 2 + 1, rsClassif:RADIO-BUTTONS IN FRAME fPage3)
         &IF "{&RTF}":U = "YES":U    &THEN
         tt-param.modelo             = INPUT FRAME fPage6 cModelRTF
         tt-param.l-habilitaRtf      = INPUT FRAME fPage6 l-habilitaRtf
         &ENDIF                     
         tt-param.propried-ini       = INPUT FRAME fPage2 cIniPropried
         tt-param.propried-fim       = INPUT FRAME fPage2 cFimPropried
         tt-param.prod-rural-ini     = INPUT FRAME fPage2 cIniProdut
         tt-param.prod-rural-fim     = INPUT FRAME fPage2 cFimProdut
         tt-param.regiao-ini         = INPUT FRAME fPage2 cIniRegiao
         tt-param.regiao-fim         = INPUT FRAME fPage2 cFimRegiao
         tt-param.rota-ini           = INPUT FRAME fPage2 cIniRota
         tt-param.rota-fim           = INPUT FRAME fPage2 cFimRota
         tt-param.grp-prod-ini       = INPUT FRAME fPage2 cIniGrpProdut
         tt-param.grp-prod-fim       = INPUT FRAME fPage2 cFimGrpProdut
         tt-param.cod-estabel        = INPUT FRAME fPage4 c-cod-estabel
         tt-param.cod-periodo        = INPUT FRAME fPage4 c-periodo
         tt-param.it-codigo          = INPUT FRAME fPage4 cb-item
         tt-param.elimina-nota       = INPUT FRAME fPage4 tg-elimina-nota
         tt-param.elimina-nota-compl = INPUT FRAME fPage4 tg-elimina-nota-compl.
  
  IF tt-param.destino = 1 THEN
    ASSIGN tt-param.arquivo = "":U.
  ELSE 
  IF tt-param.destino = 2 THEN 
    ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
  ELSE 
    ASSIGN tt-param.arquivo = session:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.
  
  /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
     como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
  
  /*:T Executar do programa RP.P que ir  criar o relat¢rio */
  {report/rpexb.i}
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  
  {report/rprun.i aqp/AQ0325rp.p}
  
  {report/rpexc.i}
  
  SESSION:SET-WAIT-STATE("":U).
  
  {report/rptrm.i}

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

