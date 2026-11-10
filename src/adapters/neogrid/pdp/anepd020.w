&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i ANEPD020 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anepd020 MAN}
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
&GLOBAL-DEFINE Program        ANEPD020
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetro,ImpressÆo

&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGIMP          YES

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page4Widgets   tb-ord-comp ~
                              tb-ord-prod ~
                              tb-planejada ~
                              tb-res-comp ~
                              tb-res-plan ~
                              tb-sald-est ~
                              tb-wf-desconto ~
                              tb-item-fatur ~
                              i-cd-plano ~
                              tb-depositos ~
                              l-dep-cq ~
                              rs-benefic ~
                              t-pedidos ~
                              t-ord-prod ~
                              t-reservas ~
                              t-compras ~
                              bt-pedidos ~
                              bt-saldo-ter ~
                              fi-dt-plan ~
                              fi-dt-corte
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution

&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page2Fields    fi-estab-ini fi-estab-fim fi-item-ini fi-item-fim fi-fam-com-ini ~
                              fi-fam-com-fim fi-ge-codigo-ini fi-ge-codigo-fim
&GLOBAL-DEFINE page6Fields    cFile

/* Parameters Definitions ---                                           */

{adapters/neogrid/pdp/anepd020.i} /* Definicao tt-param */     

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

define temp-table tt-digita no-undo
    field cod-estabel like estabelec.cod-estabel                      
    field cod-depos   like deposito.cod-depos.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

DEF VAR l-pedidos          AS LOGICAL INIT YES NO-UNDO.
DEF VAR l-cred-aprov       AS LOGICAL INIT YES NO-UNDO.
DEF VAR l-ped-nao-aval     AS LOGICAL INIT YES NO-UNDO.
DEF VAR l-ped-aval         AS LOGICAL INIT YES NO-UNDO.
DEF VAR l-ped-apro         AS LOGICAL INIT YES NO-UNDO.
DEF VAR l-ped-repr         AS LOGICAL INIT YES NO-UNDO.
DEF VAR l-abate-dispon     AS LOGICAL INIT YES NO-UNDO.
DEF VAR l-abertos          AS LOGICAL INIT YES NO-UNDO.
DEF VAR l-at-parcial       AS LOGICAL INIT YES NO-UNDO.
DEF VAR l-entrada-benef    AS LOGICAL INIT NO  NO-UNDO.
DEF VAR l-entrada-consig   AS LOGICAL INIT NO  NO-UNDO.
DEF VAR l-remessa-benef    AS LOGICAL INIT YES NO-UNDO.
DEF VAR l-transferencia    AS LOGICAL INIT YES NO-UNDO.
DEF VAR l-remessa-consig   AS LOGICAL INIT YES NO-UNDO.
DEF VAR tb-sald-terc       AS LOGICAL INIT YES NO-UNDO.
def var i-benefic          as integer          no-undo.
def var li-bt-benefic      as char extent 3    no-undo.

DEFINE VARIABLE l-cancelar AS LOGICAL NO-UNDO.

def stream s-imp.

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

DEFINE VARIABLE fi-estab-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-estab-ini LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-fam-com-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-fam-com-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Fam¡lia Comercial" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-ge-codigo-fim AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-ge-codigo-ini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo de Estoque" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-item-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-item-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-pedidos 
     LABEL "&Pedidos" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-saldo-ter 
     LABEL "&Saldo Terceiros" 
     SIZE 15 BY 1.

DEFINE VARIABLE fi-dt-corte AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "N£mero de Dias para Data de Corte" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-dt-plan AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "N£mero de Dias para Ordens Planejadas" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-titulo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8.72 BY .63 NO-UNDO.

DEFINE VARIABLE fi-titulo-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .63 NO-UNDO.

DEFINE VARIABLE fi-titulo-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15 BY .63 NO-UNDO.

DEFINE VARIABLE fi-titulo-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .63 NO-UNDO.

DEFINE VARIABLE fi-titulo-4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 28 BY .63 NO-UNDO.

DEFINE VARIABLE fi-titulo-5 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8.29 BY .63 NO-UNDO.

DEFINE VARIABLE i-cd-plano AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Plano":R7 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE rs-benefic AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Considera", 1,
"NÆo Considera", 2,
"Demonstra", 3
     SIZE 33 BY 2.25 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 2.75.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 6.88.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 1.58.

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 2.46.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 1.75.

DEFINE RECTANGLE RECT-44
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 3.5.

DEFINE RECTANGLE RECT-45
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42 BY 2.

DEFINE VARIABLE l-dep-cq AS LOGICAL INITIAL yes 
     LABEL "Considera Dep¢sitos CQ" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.57 BY .83 NO-UNDO.

DEFINE VARIABLE t-compras AS LOGICAL INITIAL yes 
     LABEL "Detalhar Ordens de Compra" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE t-ord-prod AS LOGICAL INITIAL yes 
     LABEL "Detalhar Ordens de Produ‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE t-pedidos AS LOGICAL INITIAL yes 
     LABEL "Detalhar Pedidos" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE t-reservas AS LOGICAL INITIAL yes 
     LABEL "Detalhar Reservas" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE tb-depositos AS LOGICAL INITIAL yes 
     LABEL "Informa Depositos?" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.43 BY .88 NO-UNDO.

DEFINE VARIABLE tb-item-fatur AS LOGICAL INITIAL yes 
     LABEL "Considera Somente Itens Fatur veis?" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.43 BY .88 NO-UNDO.

DEFINE VARIABLE tb-ord-comp AS LOGICAL INITIAL yes 
     LABEL "Considera Ordens de Compra?" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.43 BY .88 NO-UNDO.

DEFINE VARIABLE tb-ord-prod AS LOGICAL INITIAL yes 
     LABEL "Considera Ordens de Produ‡Æo?" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.43 BY .88 NO-UNDO.

DEFINE VARIABLE tb-planejada AS LOGICAL INITIAL yes 
     LABEL "Considera Ordens Planejadas?" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.43 BY .88 NO-UNDO.

DEFINE VARIABLE tb-res-comp AS LOGICAL INITIAL yes 
     LABEL "Considera Reservas Comprometidas?" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.43 BY .88 NO-UNDO.

DEFINE VARIABLE tb-res-plan AS LOGICAL INITIAL yes 
     LABEL "Considera Reservas Planejadas?" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.43 BY .88 NO-UNDO.

DEFINE VARIABLE tb-sald-est AS LOGICAL INITIAL yes 
     LABEL "Considera Saldo em Estoque?" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.43 BY .88 NO-UNDO.

DEFINE VARIABLE tb-wf-desconto AS LOGICAL INITIAL yes 
     LABEL "Considera Somente Pedidos Aprovados WF Desconto?" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .83 NO-UNDO.

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

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 15.71 COL 2
     btCancel AT ROW 15.71 COL 13
     btHelp2 AT ROW 15.71 COL 80
     "Text 6" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 2.75 COL 53
     rtToolBar AT ROW 15.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.14 ROW 1
         SIZE 90 BY 16.13
         FONT 1.

DEFINE FRAME fPage4
     tb-wf-desconto AT ROW 7.04 COL 3.86
     tb-ord-comp AT ROW 1.17 COL 3.86
     tb-ord-prod AT ROW 2 COL 3.86
     tb-planejada AT ROW 2.88 COL 3.86
     tb-res-comp AT ROW 3.71 COL 3.86
     tb-res-plan AT ROW 4.58 COL 3.86
     tb-sald-est AT ROW 5.42 COL 3.86
     tb-item-fatur AT ROW 6.25 COL 3.86
     tb-depositos AT ROW 8.5 COL 3.72
     l-dep-cq AT ROW 9.33 COL 3.72
     i-cd-plano AT ROW 1.63 COL 61.14 COLON-ALIGNED
     fi-dt-plan AT ROW 3.33 COL 47.85
     fi-dt-corte AT ROW 4.29 COL 51.14
     rs-benefic AT ROW 6.17 COL 49 NO-LABEL
     t-pedidos AT ROW 9.25 COL 49
     t-ord-prod AT ROW 10 COL 49
     t-reservas AT ROW 10.75 COL 49
     t-compras AT ROW 11.5 COL 49
     bt-pedidos AT ROW 11.17 COL 5.57
     bt-saldo-ter AT ROW 11.17 COL 25
     fi-titulo-2 AT ROW 1 COL 54 COLON-ALIGNED NO-LABEL
     fi-titulo-3 AT ROW 2.88 COL 56.14 COLON-ALIGNED NO-LABEL
     fi-titulo-4 AT ROW 5.67 COL 48 COLON-ALIGNED NO-LABEL
     fi-titulo AT ROW 8 COL 16.29 COLON-ALIGNED NO-LABEL
     fi-titulo-5 AT ROW 8.75 COL 55.72 COLON-ALIGNED NO-LABEL
     fi-titulo-1 AT ROW 10.38 COL 15 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 5.92 COL 45
     RECT-40 AT ROW 1.13 COL 2
     RECT-41 AT ROW 1.17 COL 45
     RECT-42 AT ROW 3.13 COL 45
     RECT-43 AT ROW 10.75 COL 2
     RECT-44 AT ROW 9 COL 45
     RECT-45 AT ROW 8.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 11.96
         FONT 1.

DEFINE FRAME fPage2
     fi-estab-ini AT ROW 1.5 COL 22.14 HELP
          ""
          LABEL "Estabelecimento":R7
          FONT 1
     fi-estab-fim AT ROW 1.5 COL 53.14 HELP
          "" NO-LABEL
          FONT 1
     fi-item-ini AT ROW 2.5 COL 11.28
     fi-item-fim AT ROW 2.5 COL 53.14 NO-LABEL
     fi-fam-com-ini AT ROW 3.5 COL 12.28
     fi-fam-com-fim AT ROW 3.5 COL 53.14 NO-LABEL
     fi-ge-codigo-ini AT ROW 4.5 COL 17.86
     fi-ge-codigo-fim AT ROW 4.5 COL 53.14 NO-LABEL
     IMAGE-1 AT ROW 1.5 COL 34.86
     IMAGE-10 AT ROW 4.5 COL 50.29
     IMAGE-2 AT ROW 1.5 COL 50.29
     IMAGE-5 AT ROW 2.5 COL 34.86
     IMAGE-6 AT ROW 2.5 COL 50.29
     IMAGE-7 AT ROW 3.5 COL 34.86
     IMAGE-8 AT ROW 3.5 COL 50.29
     IMAGE-9 AT ROW 4.5 COL 34.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 11.96
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 11.96
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
         HEIGHT             = 16.17
         WIDTH              = 90.43
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
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
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN fi-estab-fim IN FRAME fPage2
   ALIGN-L LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE        */
/* SETTINGS FOR FILL-IN fi-estab-ini IN FRAME fPage2
   ALIGN-L LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE        */
/* SETTINGS FOR FILL-IN fi-fam-com-fim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-fam-com-ini IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-ge-codigo-fim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-ge-codigo-ini IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-item-fim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-item-ini IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* SETTINGS FOR FILL-IN fi-dt-corte IN FRAME fPage4
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-dt-plan IN FRAME fPage4
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-titulo IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-titulo-1 IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-titulo-2 IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-titulo-3 IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-titulo-4 IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-titulo-5 IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-ord-comp IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pedidos wReport
ON CHOOSE OF bt-pedidos IN FRAME fPage4 /* Pedidos */
DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN adapters/neogrid/pdp/anepd020a.w (input-output l-pedidos,
                                          input-output l-cred-aprov,
                                          input-output l-ped-nao-aval,
                                          input-output l-ped-aval,
                                          input-output l-ped-apro,
                                          input-output l-ped-repr,
                                          input-output l-abate-dispon,
                                          input-output l-abertos,
                                          input-output l-at-parcial).
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    APPLY "entry":U TO bt-pedidos IN FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-saldo-ter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-saldo-ter wReport
ON CHOOSE OF bt-saldo-ter IN FRAME fPage4 /* Saldo Terceiros */
DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN adapters/neogrid/pdp/anepd020b.w (input-output tb-sald-terc,
                                          input-output l-entrada-benef,
                                          input-output l-remessa-benef,
                                          input-output l-entrada-consig,
                                          input-output l-remessa-consig,
                                          input-output l-transferencia).
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    APPLY "entry":U TO bt-saldo-ter IN FRAME fPage4.
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
&Scoped-define SELF-NAME i-cd-plano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-plano wReport
ON MOUSE-SELECT-DBLCLICK OF i-cd-plano IN FRAME fPage4 /* Plano */
DO:
  apply 'F5' to self.
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
                   btConfigImpr:visible  = yes.
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no.
        end.
        when "3":U then do:
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME t-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-pedidos wReport
ON VALUE-CHANGED OF t-pedidos IN FRAME fPage4 /* Detalhar Pedidos */
DO:
    /*
  RUN pi-
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-planejada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-planejada wReport
ON VALUE-CHANGED OF tb-planejada IN FRAME fPage4 /* Considera Ordens Planejadas? */
DO:
    if input frame fPage4 tb-planejada or
       input frame fPage4 tb-res-plan  then
       enable i-cd-plano with frame fPage4.
    else
       disable i-cd-plano with frame fPage4.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-res-plan
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-res-plan wReport
ON VALUE-CHANGED OF tb-res-plan IN FRAME fPage4 /* Considera Reservas Planejadas? */
DO:
  if input frame fPage4 tb-planejada or
     input frame fPage4 tb-res-plan  then
     enable i-cd-plano with frame fPage4.
  else
     disable i-cd-plano with frame fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

&IF "{&mguni_version}" >= "2.071" &THEN
    ASSIGN fi-estab-fim:SCREEN-VALUE IN FRAME fPage2 = "ZZZZZ".
&ELSE
    ASSIGN fi-estab-fim:SCREEN-VALUE IN FRAME fPage2 = "ZZZ".
&ENDIF

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

    {utp/ut-liter.i Estabelecimento   MPC r} ASSIGN fi-estab-ini:LABEL     IN FRAME fPage2 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Item              MPC r} ASSIGN fi-item-ini:LABEL      IN FRAME fPage2 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Fam¡lia_Comercial MPC r} ASSIGN fi-fam-com-ini:LABEL   IN FRAME fPage2 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Grupo_de_Estoque  MPC r} ASSIGN fi-ge-codigo-ini:LABEL IN FRAME fPage2 = TRIM(RETURN-VALUE).

    {utp/ut-liter.i Considera_Ordens_de_Compra?         MPD r} assign tb-ord-comp:LABEL   IN FRAME fPage4 = trim(return-value).     
    {utp/ut-liter.i Considera_Ordens_de_Produ‡Æo?       MPD r} assign tb-ord-prod:label   IN FRAME fPage4 = trim(return-value).     
    {utp/ut-liter.i Considera_Ordens_Planejadas?        MPD r} assign tb-planejada:label  IN FRAME fPage4 = trim(return-value).     
    {utp/ut-liter.i Considera_Reservas_Comprometidas?   MPD r} assign tb-res-comp:LABEL   IN FRAME fPage4 = trim(return-value).     
    {utp/ut-liter.i Considera_Reservas_Planejadas?      MPD r} assign tb-res-plan:label   IN FRAME fPage4 = trim(return-value).     
    {utp/ut-liter.i Considera_Saldo_em_Estoque?         MPD r} assign tb-sald-est:label   IN FRAME fPage4 = trim(return-value).
    {utp/ut-liter.i Considera_Somente_Itens_Fatur veis? MPD r} assign tb-item-fatur:label IN FRAME fPage4 = trim(return-value).
    {utp/ut-liter.i Considera_Somente_Pedidos_Aprovados_WF_Desconto? MPD r} assign tb-wf-desconto:label IN FRAME fPage4 = trim(return-value).
    
    {utp/ut-liter.i Datas_de_Corte                        MPD r} assign fi-titulo-3:SCREEN-VALUE IN FRAME fPage4 = trim(return-value).          
    {utp/ut-liter.i N£mero_de_Dias_para_Data_de_Corte     MPD r} assign fi-dt-corte:LABEL        IN FRAME fPage4 = TRIM(return-value).     
    {utp/ut-liter.i N£mero_de_Dias_para_Ordens_Planejadas MPD r} assign fi-dt-plan:LABEL         IN FRAME fPage4 = trim(return-value).
    
    {utp/ut-liter.i Dep¢sitos               MPD r} assign fi-titulo:SCREEN-VALUE IN FRAME fPage4 = trim(return-value).
    {utp/ut-liter.i Informa_Depositos?      MPD r} assign tb-depositos:label     IN FRAME fPage4 = trim(return-value).     
    {utp/ut-liter.i Considera_Dep¢sitos_CQ? MPD r} assign l-dep-cq:label         IN FRAME fPage4 = trim(return-value).
    
    {utp/ut-liter.i Parƒmetros      MPD r} assign fi-titulo-1:SCREEN-VALUE IN FRAME fPage4 = trim(return-value).          
    {utp/ut-liter.i Pedidos         MPD r} assign bt-pedidos:label         IN FRAME fPage4 = "&" + trim(return-value).
    {utp/ut-liter.i Saldo_Terceiros MPD r} assign bt-saldo-ter:label       IN FRAME fPage4 = "&" + trim(return-value).
    
    {utp/ut-liter.i Plano_de_Produ‡Æo MPD r} assign fi-titulo-2:SCREEN-VALUE IN FRAME fPage4 = trim(return-value).     
    {utp/ut-liter.i Plano             MPD r} assign i-cd-plano:label         IN FRAME fPage4 = trim(return-value).
    
    {utp/ut-liter.i Ordens_de_Compras_de_Beneficiamento MPD r} assign fi-titulo-4:SCREEN-VALUE IN FRAME fPage4 = trim(return-value).
    {utp/ut-liter.i Considera     MPD r} assign li-bt-benefic[1] = trim(return-value).    
    {utp/ut-liter.i NÆo_Considera MPD r} assign li-bt-benefic[2] = trim(return-value).     
    {utp/ut-liter.i Demonstra     MPD r} assign li-bt-benefic[3] = trim(return-value).          
    assign rs-benefic:RADIO-BUTTONS  IN FRAME fPage4 = li-bt-benefic[1] + ", 1," +
                                                       li-bt-benefic[2] + ", 2," +
                                                       li-bt-benefic[3] + ", 3".
                                        
    {utp/ut-liter.i Detalhar                    MPD r} assign fi-titulo-5:SCREEN-VALUE IN FRAME fPage4 = trim(return-value).
    {utp/ut-liter.i Detalhar_Pedidos            MPD r} assign t-pedidos:label          IN FRAME fPage4 = trim(return-value).
    {utp/ut-liter.i Detalhar_Ordens_de_Produ‡Æo MPD r} assign t-ord-prod:label         IN FRAME fPage4 = trim(return-value).
    {utp/ut-liter.i Detalhar_Reservas           MPD r} assign t-reservas:label         IN FRAME fPage4 = trim(return-value).
    {utp/ut-liter.i Detalhar_Ordens_de_Compra   MPD r} assign t-compras:label          IN FRAME fPage4 = trim(return-value).

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
    
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    
    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    create tt-param.
    assign tt-param.usuario             = c-seg-usuario
           tt-param.destino             = input frame fPage6 rsDestiny
           tt-param.data-exec           = today
           tt-param.hora-exec           = TIME
           tt-param.estab-ini           = INPUT FRAME fPage2 fi-estab-ini
           tt-param.estab-fim           = INPUT FRAME fPage2 fi-estab-fim
           tt-param.item-ini            = INPUT FRAME fPage2 fi-item-ini
           tt-param.item-fim            = INPUT FRAME fPage2 fi-item-fim
           tt-param.fam-com-ini         = INPUT FRAME fPage2 fi-fam-com-ini
           tt-param.fam-com-fim         = INPUT FRAME fPage2 fi-fam-com-fim
           tt-param.ge-codigo-ini       = INPUT FRAME fPage2 fi-ge-codigo-ini
           tt-param.ge-codigo-fim       = INPUT FRAME fPage2 fi-ge-codigo-fim
           tt-param.pa-ord-comp         = tb-ord-comp:CHECKED    IN FRAME fPage4
           tt-param.pa-ord-prod         = tb-ord-prod:CHECKED    IN FRAME fPage4
           tt-param.pa-planejada        = tb-planejada:CHECKED   IN FRAME fPage4
           tt-param.pa-res-comp         = tb-res-comp:CHECKED    IN FRAME fPage4
           tt-param.pa-res-plan         = tb-res-plan:CHECKED    IN FRAME fPage4
           tt-param.pa-sald-est         = tb-sald-est:CHECKED    IN FRAME fPage4
           tt-param.pa-wf-desconto      = tb-wf-desconto:CHECKED IN FRAME fPage4
           tt-param.pa-item-fatur       = tb-item-fatur:CHECKED  IN FRAME fPage4
           tt-param.pa-depositos        = tb-depositos:CHECKED   IN FRAME fPage4
           tt-param.pa-dep-cq           = l-dep-cq:CHECKED       IN FRAME fPage4
           tt-param.pa-cod-plano        = INPUT FRAME fPage4 i-cd-plano
           tt-param.pa-dt-plan          = INPUT FRAME fPage4 fi-dt-plan
           tt-param.pa-dt-corte         = INPUT FRAME fPage4 fi-dt-corte
           tt-param.pa-benefic          = INPUT FRAME fPage4 rs-benefic
           tt-param.pa-t-pedidos        = INPUT FRAME fPage4 t-pedidos
           tt-param.pa-t-ord-prod       = INPUT FRAME fPage4 t-ord-prod
           tt-param.pa-t-reservas       = INPUT FRAME fPage4 t-reservas
           tt-param.pa-t-compras        = INPUT FRAME fPage4 t-compras
           tt-param.pa-abertos          = l-abertos
           tt-param.pa-at-parcial       = l-at-parcial
           tt-param.pa-cons-qt-aba      = l-abate-dispon
           tt-param.pa-ped-apro         = l-ped-apro
           tt-param.pa-ped-aval         = l-ped-aval
           tt-param.pa-ped-n-av         = l-ped-nao-aval
           tt-param.pa-ped-repr         = l-ped-repr
           tt-param.pa-cred-aprov       = l-cred-aprov
           tt-param.pa-pedidos          = l-pedidos
           tt-param.pa-entrada-benef    = l-entrada-benef
           tt-param.pa-entrada-consig   = l-entrada-consig
           tt-param.pa-remessa-benef    = l-remessa-benef
           tt-param.pa-transferencia    = l-transferencia
           tt-param.pa-remessa-consig   = l-remessa-consig
           tt-param.pa-sald-terc        = tb-sald-terc.

    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.

     /* Quando parƒmetro Informa dep¢sitos estiver ligado */
     if  tt-param.pa-depositos then DO:
         run cdp/cd0284b1.w (INPUT-OUTPUT TABLE tt-digita,
                             OUTPUT             l-cancelar).
     END.

    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    if  session:set-wait-state("general") then.
    
    {report/rprun.i adapters/neogrid/pdp/anepd020rp.p}
    
    {report/rpexc.i}
    
    if  session:set-wait-state("") then.
    
    {report/rptrm.i}
end.
&endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

