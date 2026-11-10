&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0601 2.00.00.011 } /*** "010011" ***/
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AF0601 MAF}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AF0601
&GLOBAL-DEFINE Version        2.00.00.011

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btHelp2 bt-executa bt-param
&GLOBAL-DEFINE page1Widgets   c-cod-estabel-ini c-cod-estabel-fim ~
                              i-cod-emitente-ini i-cod-emitente-fim ~
                              c-it-codigo-ini c-it-codigo-fim ~
                              i-nr-controle-ini i-nr-controle-fim ~
                              i-filtro i-melhor-pior bt-itens br-notas1 ~
                              br-notas cb-classificacao ~
                              bt-grafico-1  bt-grafico-2 bt-fornecedor ~
                              cb-periodo-ini cb-periodo-fim cb-ano-ini cb-ano-fim
                              


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var h-boaf008   as handle                no-undo.
def var c-dt-indice as char format "99/9999" no-undo.
{afbo/boaf008.i1}
def var da-dt-ini        as date       no-undo.
def var da-dt-fim        as date       no-undo.
def buffer b-tt-notas  for tt-notas.

def var c-cod-grp-aval-ini  like af-item-contr-estab.cod-grp-avaliacao no-undo.
def var c-cod-grp-aval-fim  like af-item-contr-estab.cod-grp-avaliacao INIT "ZZZZZZZZ" no-undo.
DEF VAR c-cod-grp-resp-ini  LIKE af-item-contr-estab-form.cod-grp-resp NO-UNDO.
DEF VAR c-cod-grp-resp-fim  LIKE af-item-contr-estab-form.cod-grp-resp INIT "ZZZZZZZZ" NO-UNDO.
def var i-cod-gr-forn-ini   like emitente.cod-gr-forn no-undo.
def var i-cod-gr-forn-fim   like emitente.cod-gr-forn init 99 no-undo.
def var c-fm-codigo-ini     like item.fm-codigo       no-undo.
def var c-fm-codigo-fim     like item.fm-codigo       init "ZZZZZZ" no-undo.
def var i-ge-codigo-ini     like item.ge-codigo       no-undo.
def var i-ge-codigo-fim     like item.ge-codigo       init 99 no-undo.
def var i-classific           as int no-undo.

{utp/utapi011.i}
DEF TEMP-TABLE tt-points-2-af NO-UNDO LIKE tt-points-2
    FIELD nome-abrev  LIKE tt-notas.nome-abrev
    FIELD periodo     AS CHAR
    FIELD cod-estabel LIKE tt-notas.cod-estabel.

DEF TEMP-TABLE tt-sets-af     NO-UNDO LIKE tt-sets
    FIELD nome-abrev  LIKE tt-notas.nome-abrev
    FIELD periodo     AS CHAR
    FIELD cod-estabel LIKE tt-notas.cod-estabel.

def new global shared var gr-emitente as rowid no-undo.

DEF VAR i-tipo            AS INT        NO-UNDO.
def var i-media           as int init 1 no-undo.

/* Valida‡Æo licen‡a MAF */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-notas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-notas b-tt-notas

/* Definitions for BROWSE br-notas                                      */
&Scoped-define FIELDS-IN-QUERY-br-notas tt-notas.cod-estabel tt-notas.des-periodo-aval tt-notas.cod-emitente tt-notas.nome-abrev tt-notas.nota tt-notas.ano-avaliacao string(month(tt-notas.dt-indice-ini),"99") + "/" + string(year(tt-notas.dt-indice-ini),"9999") string(month(tt-notas.dt-indice-fim),"99") + "/" + string(year(tt-notas.dt-indice-fim),"9999")   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-notas   
&Scoped-define SELF-NAME br-notas
&Scoped-define OPEN-QUERY-br-notas  case i-classific:    when 1 then        OPEN QUERY {&SELF-NAME} FOR EACH tt-notas                                   WHERE tt-notas.tipo = "TF"                                      by tt-notas.cod-estabel                                      by tt-notas.dt-indice-fim                                      by tt-notas.dt-indice-ini desc                                      by tt-notas.cod-emitente.    when 2 then        OPEN QUERY {&SELF-NAME} FOR EACH tt-notas                                   WHERE tt-notas.tipo = "TF"                                      by tt-notas.cod-estabel                                      by tt-notas.dt-indice-fim                                      by tt-notas.dt-indice-ini desc                                      by tt-notas.nome-abrev.    when 3 then        OPEN QUERY {&SELF-NAME} FOR EACH tt-notas                                   WHERE tt-notas.tipo = "TF"                                      by tt-notas.cod-estabel                                      by tt-notas.dt-indice-fim                                      by tt-notas.dt-indice-ini desc                                      by tt-notas.nota.    when 4 then        OPEN QUERY {&SELF-NAME} FOR EACH tt-notas                                   WHERE tt-notas.tipo = "TF"                                      by tt-notas.cod-estabel                                      by tt-notas.dt-indice-fim                                      by tt-notas.dt-indice-ini desc                                      by tt-notas.nota desc. end case.  apply 'value-changed' to br-notas in frame fpage1.
&Scoped-define TABLES-IN-QUERY-br-notas tt-notas
&Scoped-define FIRST-TABLE-IN-QUERY-br-notas tt-notas


/* Definitions for BROWSE br-notas1                                     */
&Scoped-define FIELDS-IN-QUERY-br-notas1 b-tt-notas.nr-controle b-tt-notas.descricao b-tt-notas.indice b-tt-notas.percentual b-tt-notas.nota   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-notas1   
&Scoped-define SELF-NAME br-notas1
&Scoped-define QUERY-STRING-br-notas1 FOR EACH b-tt-notas                            WHERE b-tt-notas.tipo = "DF" and                                  b-tt-notas.cod-estabel = tt-notas.cod-estabel and                                  b-tt-notas.dt-indice-fim = tt-notas.dt-indice-fim and                                  b-tt-notas.dt-indice-ini = tt-notas.dt-indice-ini and                                  b-tt-notas.cod-emitente = tt-notas.cod-emitente                         by b-tt-notas.nr-controle
&Scoped-define OPEN-QUERY-br-notas1 OPEN QUERY {&SELF-NAME} FOR EACH b-tt-notas                            WHERE b-tt-notas.tipo = "DF" and                                  b-tt-notas.cod-estabel = tt-notas.cod-estabel and                                  b-tt-notas.dt-indice-fim = tt-notas.dt-indice-fim and                                  b-tt-notas.dt-indice-ini = tt-notas.dt-indice-ini and                                  b-tt-notas.cod-emitente = tt-notas.cod-emitente                         by b-tt-notas.nr-controle.
&Scoped-define TABLES-IN-QUERY-br-notas1 b-tt-notas
&Scoped-define FIRST-TABLE-IN-QUERY-br-notas1 b-tt-notas


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-notas}~
    ~{&OPEN-QUERY-br-notas1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-executa btHelp btQueryJoins ~
btReportsJoins btExit btHelp2 bt-param rtToolBar rtToolBar-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-executa DEFAULT 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "Executa" 
     SIZE 5 BY 1.25 TOOLTIP "Executa a leitura das notas conforme sele‡Æo".

DEFINE BUTTON bt-param 
     IMAGE-UP FILE "IMAGE/im-param":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-fornecedor 
     LABEL "&Fornecedor" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-grafico-1 DEFAULT 
     IMAGE-UP FILE "image/im-grf.bmp":U
     LABEL "Gr fico" 
     SIZE 6 BY 1.25 TOOLTIP "Gr fico de fornecedores".

DEFINE BUTTON bt-grafico-2 DEFAULT 
     IMAGE-UP FILE "image/im-grf.bmp":U
     LABEL "Gr fico" 
     SIZE 6 BY 1.25 TOOLTIP "Gr fico dos pontos de controle dos fornecedores".

DEFINE BUTTON bt-itens 
     LABEL "&Itens" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-ano-fim AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ano-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Per¡odo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE cb-classificacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Classifica‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-periodo-fim AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-periodo-ini AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER FORMAT "X(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER FORMAT "X(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-it-codigo-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE c-it-codigo-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE i-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-melhor-pior AS INTEGER FORMAT ">>>,>>9":U INITIAL 999999 
     LABEL "Melhores/Piores" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-controle-fim AS INTEGER FORMAT ">>>>>9" INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE i-nr-controle-ini AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "N£mero Controle" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE IMAGE IMAGE-65
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-69
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-83
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-84
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-85
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-86
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-89
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-90
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-91
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-92
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE i-filtro AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", 1,
"Apenas melhores", 2,
"Apenas piores", 3
     SIZE 16 BY 2.25 NO-UNDO.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.25.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 9.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 1.5.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 4.5.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 2.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-notas FOR 
      tt-notas SCROLLING.

DEFINE QUERY br-notas1 FOR 
      b-tt-notas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-notas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-notas wWindow _FREEFORM
  QUERY br-notas DISPLAY
      tt-notas.cod-estabel format "x(5)"
 tt-notas.des-periodo-aval COLUMN-LABEL "Per¡odo"
 tt-notas.cod-emitente
 tt-notas.nome-abrev
 tt-notas.nota format "->>>9.99"
 tt-notas.ano-avaliacao 
 string(month(tt-notas.dt-indice-ini),"99") + "/" + string(year(tt-notas.dt-indice-ini),"9999") label "Dt ini"
 string(month(tt-notas.dt-indice-fim),"99") + "/" + string(year(tt-notas.dt-indice-fim),"9999") label "Dt fim"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-ROW-MARKERS SEPARATORS SIZE 45 BY 7.25
         FONT 1
         TITLE "Notas dos Fornecedores" ROW-HEIGHT-CHARS .5.

DEFINE BROWSE br-notas1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-notas1 wWindow _FREEFORM
  QUERY br-notas1 DISPLAY
      b-tt-notas.nr-controle
b-tt-notas.descricao
b-tt-notas.indice
b-tt-notas.percentual
b-tt-notas.nota
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-ROW-MARKERS SEPARATORS SIZE 42 BY 7.25
         FONT 1
         TITLE "Notas dos pontos de controle do fornecedor" ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-executa AT ROW 1.13 COL 2
     btOK AT ROW 18.5 COL 2
     btCancel AT ROW 18.5 COL 13
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp2 AT ROW 18.5 COL 80
     bt-param AT ROW 1.13 COL 8.29 HELP
          "Parƒmetros"
     rtToolBar AT ROW 18.25 COL 1
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.83
         FONT 1.

DEFINE FRAME fPage1
     cb-ano-ini AT ROW 1.25 COL 16 COLON-ALIGNED
     cb-periodo-ini AT ROW 1.25 COL 25 COLON-ALIGNED NO-LABEL
     c-cod-estabel-ini AT ROW 2.75 COL 16 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
     c-cod-estabel-fim AT ROW 2.75 COL 32 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" NO-LABEL
     i-cod-emitente-ini AT ROW 3.75 COL 12 COLON-ALIGNED HELP
          "C¢digo do fornecedor"
     i-cod-emitente-fim AT ROW 3.75 COL 32 COLON-ALIGNED HELP
          "C¢digo do fornecedor" NO-LABEL
     c-it-codigo-ini AT ROW 4.75 COL 5 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-it-codigo-fim AT ROW 4.75 COL 32 COLON-ALIGNED HELP
          "C¢digo do Item" NO-LABEL
     i-nr-controle-ini AT ROW 5.75 COL 14 COLON-ALIGNED HELP
          "N£mero do ponto de controle"
     i-nr-controle-fim AT ROW 5.75 COL 32 COLON-ALIGNED HELP
          "N£mero do ponto de controle" NO-LABEL
     i-filtro AT ROW 2.75 COL 54 NO-LABEL
     i-melhor-pior AT ROW 2.75 COL 80 COLON-ALIGNED
     cb-classificacao AT ROW 5.75 COL 65 COLON-ALIGNED
     br-notas AT ROW 7.5 COL 2
     br-notas1 AT ROW 7.5 COL 48
     bt-itens AT ROW 15 COL 2
     bt-grafico-1 AT ROW 14.79 COL 40.86
     bt-grafico-2 AT ROW 14.79 COL 48.43
     bt-fornecedor AT ROW 15 COL 13
     cb-ano-fim AT ROW 1.25 COL 51 COLON-ALIGNED NO-LABEL
     cb-periodo-fim AT ROW 1.25 COL 60 COLON-ALIGNED NO-LABEL
     IMAGE-65 AT ROW 2.75 COL 25
     IMAGE-69 AT ROW 2.75 COL 30
     IMAGE-83 AT ROW 3.75 COL 25
     IMAGE-84 AT ROW 3.75 COL 30
     IMAGE-85 AT ROW 4.75 COL 25
     IMAGE-86 AT ROW 4.75 COL 30
     IMAGE-89 AT ROW 5.75 COL 25
     IMAGE-90 AT ROW 5.75 COL 30
     IMAGE-91 AT ROW 1.25 COL 44
     IMAGE-92 AT ROW 1.25 COL 49
     RECT-16 AT ROW 1 COL 1
     RECT-17 AT ROW 7.25 COL 1
     RECT-18 AT ROW 5.5 COL 53
     RECT-19 AT ROW 2.5 COL 1
     RECT-20 AT ROW 2.5 COL 53
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.75
         SIZE 90 BY 15.25
         FONT 1.


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
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta de Notas"
         HEIGHT             = 18.83
         WIDTH              = 90
         MAX-HEIGHT         = 27.13
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.13
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (bt-executa:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR BUTTON btCancel IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btCancel:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR BUTTON btOK IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btOK:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* BROWSE-TAB br-notas cb-classificacao fPage1 */
/* BROWSE-TAB br-notas1 br-notas fPage1 */
ASSIGN 
       br-notas:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       br-notas:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

ASSIGN 
       br-notas1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       br-notas1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

/* SETTINGS FOR FILL-IN i-melhor-pior IN FRAME fPage1
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-notas
/* Query rebuild information for BROWSE br-notas
     _START_FREEFORM

case i-classific:
   when 1 then
       OPEN QUERY {&SELF-NAME} FOR EACH tt-notas
                                  WHERE tt-notas.tipo = "TF"
                                     by tt-notas.cod-estabel
                                     by tt-notas.dt-indice-fim
                                     by tt-notas.dt-indice-ini desc
                                     by tt-notas.cod-emitente.
   when 2 then
       OPEN QUERY {&SELF-NAME} FOR EACH tt-notas
                                  WHERE tt-notas.tipo = "TF"
                                     by tt-notas.cod-estabel
                                     by tt-notas.dt-indice-fim
                                     by tt-notas.dt-indice-ini desc
                                     by tt-notas.nome-abrev.
   when 3 then
       OPEN QUERY {&SELF-NAME} FOR EACH tt-notas
                                  WHERE tt-notas.tipo = "TF"
                                     by tt-notas.cod-estabel
                                     by tt-notas.dt-indice-fim
                                     by tt-notas.dt-indice-ini desc
                                     by tt-notas.nota.
   when 4 then
       OPEN QUERY {&SELF-NAME} FOR EACH tt-notas
                                  WHERE tt-notas.tipo = "TF"
                                     by tt-notas.cod-estabel
                                     by tt-notas.dt-indice-fim
                                     by tt-notas.dt-indice-ini desc
                                     by tt-notas.nota desc.
end case.

apply 'value-changed' to br-notas in frame fpage1.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-notas */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-notas1
/* Query rebuild information for BROWSE br-notas1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH b-tt-notas
                           WHERE b-tt-notas.tipo = "DF" and
                                 b-tt-notas.cod-estabel = tt-notas.cod-estabel and
                                 b-tt-notas.dt-indice-fim = tt-notas.dt-indice-fim and
                                 b-tt-notas.dt-indice-ini = tt-notas.dt-indice-ini and
                                 b-tt-notas.cod-emitente = tt-notas.cod-emitente
                        by b-tt-notas.nr-controle.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-notas1 */
&ANALYZE-RESUME

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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Consulta de Notas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Consulta de Notas */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-notas
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-notas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-notas wWindow
ON MOUSE-SELECT-DBLCLICK OF br-notas IN FRAME fPage1 /* Notas dos Fornecedores */
DO:
  apply 'choose' to bt-itens.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-notas wWindow
ON ROW-DISPLAY OF br-notas IN FRAME fPage1 /* Notas dos Fornecedores */
DO:
     if tt-notas.des-periodo-aval = " -*- M‚dia -*-" then
         assign tt-notas.cod-estabel:bgcolor       in browse {&browse-name} = 11     
                tt-notas.des-periodo-aval:bgcolor  in browse {&browse-name} = 11 
                tt-notas.cod-emitente:bgcolor      in browse {&browse-name} = 11      
                tt-notas.nome-abrev:bgcolor        in browse {&browse-name} = 11
                tt-notas.nota:bgcolor              in browse {&browse-name} = 11
                tt-notas.ano-avaliacao:bgcolor     in browse {&browse-name} = 11.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-notas wWindow
ON VALUE-CHANGED OF br-notas IN FRAME fPage1 /* Notas dos Fornecedores */
DO:
  {&OPEN-QUERY-br-notas1}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-executa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executa wWindow
ON CHOOSE OF bt-executa IN FRAME fpage0 /* Executa */
DO:

  DEF VAR h-acomp          AS HANDLE     NO-UNDO.

  RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
  RUN pi-inicializar IN h-acomp (INPUT "Carregando informa‡äes ...").
  /* Inicio -- Projeto Internacional */
  {utp/ut-liter.i "Carregando_informa‡äes" *}
  RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + " ...").

  run getNotas in h-boaf008 (input input frame fpage1 c-cod-estabel-ini,
                             input input frame fpage1 c-cod-estabel-fim,
                             input input frame fpage1 i-cod-emitente-ini, 
                             input input frame fpage1 i-cod-emitente-fim,
                             input input frame fpage1 c-it-codigo-ini,  
                             input input frame fpage1 c-it-codigo-fim,
                             input input frame fpage1 i-nr-controle-ini,
                             input input frame fpage1 i-nr-controle-fim, 
                             input INPUT FRAME fpage1 cb-ano-ini,  
                             input INPUT FRAME fpage1 cb-periodo-ini,
                             input INPUT FRAME fpage1 cb-ano-fim,  
                             input INPUT FRAME fpage1 cb-periodo-fim, 
                             input c-cod-grp-aval-ini,
                             input c-cod-grp-aval-fim,
                             INPUT c-cod-grp-resp-ini,
                             INPUT c-cod-grp-resp-fim,
                             input i-cod-gr-forn-ini, 
                             input i-cod-gr-forn-fim,
                             input c-fm-codigo-ini,
                             input c-fm-codigo-fim,
                             input i-ge-codigo-ini, 
                             input i-ge-codigo-fim,
                             input input frame fpage1 i-filtro,
                             input input frame fpage1 i-melhor-pior,
                             input i-media,
                             output table tt-notas). 

  RUN pi-finalizar IN h-acomp.

  {&OPEN-QUERY-{&BROWSE-NAME}}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-fornecedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fornecedor wWindow
ON CHOOSE OF bt-fornecedor IN FRAME fPage1 /* Fornecedor */
DO:
    if not avail tt-notas then return.

    for first emitente fields()
        where emitente.cod-emitente = tt-notas.cod-emitente no-lock: end.
    if not avail emitente then return.

    assign gr-emitente = rowid(emitente).

    {&WINDOW-NAME}:SENSITIVE = NO.
    run ccp/cc0503.w.
    {&WINDOW-NAME}:SENSITIVE = YES.
    APPLY 'entry' TO {&WINDOW-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-grafico-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-grafico-1 wWindow
ON CHOOSE OF bt-grafico-1 IN FRAME fPage1 /* Gr fico */
DO:               
   run pi-grafico (input 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-grafico-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-grafico-2 wWindow
ON CHOOSE OF bt-grafico-2 IN FRAME fPage1 /* Gr fico */
DO:
   
  run pi-grafico (input 2).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-itens wWindow
ON CHOOSE OF bt-itens IN FRAME fPage1 /* Itens */
DO:
    if not avail tt-notas then return.

    {&WINDOW-NAME}:SENSITIVE = NO.
    run afp/af0601a.w (input table tt-notas,
                       input tt-notas.cod-estabel,
                       INPUT tt-notas.ano-avaliacao,
                       INPUT tt-notas.des-periodo-aval,
                       INPUT tt-notas.dt-indice-ini,
                       input tt-notas.dt-indice-fim,
                       input tt-notas.cod-emitente,
                       input tt-notas.nome-abrev ).
    {&WINDOW-NAME}:SENSITIVE = YES.
    APPLY 'entry' TO {&WINDOW-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-param
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-param wWindow
ON CHOOSE OF bt-param IN FRAME fpage0
DO:
  run afp/af0601f.w (input-output c-cod-grp-aval-ini,
                     input-output c-cod-grp-aval-fim,
                     INPUT-OUTPUT c-cod-grp-resp-ini,
                     INPUT-OUTPUT c-cod-grp-resp-fim,
                     input-output i-cod-gr-forn-ini,
                     input-output i-cod-gr-forn-fim,
                     input-output c-fm-codigo-ini,
                     input-output c-fm-codigo-fim,
                     input-output i-ge-codigo-ini, 
                     input-output i-ge-codigo-fim,
                     input-output i-media).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-ano-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano-fim wWindow
ON VALUE-CHANGED OF cb-ano-fim IN FRAME fPage1
DO:
  RUN pi-preenche-periodo-fim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ano-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ano-ini wWindow
ON VALUE-CHANGED OF cb-ano-ini IN FRAME fPage1 /* Per¡odo */
DO:
   RUN pi-preenche-periodo-ini.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-classificacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-classificacao wWindow
ON VALUE-CHANGED OF cb-classificacao IN FRAME fPage1 /* Classifica‡Æo */
DO:
    assign input frame fPage1 cb-classificacao.
           
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        if lookup(cb-classificacao:screen-value,cb-classificacao:LIST-ITEM-PAIRS in frame fPage1,",") mod 2 <> 0 then 
            assign i-classific = (lookup(cb-classificacao:screen-value,cb-classificacao:LIST-ITEM-PAIRS in frame fPage1,",") + 1) / 2.
        else
            assign i-classific = lookup(cb-classificacao:screen-value, cb-classificacao:LIST-ITEM-PAIRS in frame fPage1,",") / 2.  
    &else
        assign i-classific = lookup(cb-classificacao:screen-value, cb-classificacao:LIST-ITEMS in frame fPage1,",").      
    &endif
   
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-filtro wWindow
ON VALUE-CHANGED OF i-filtro IN FRAME fPage1
DO:
   if input frame {&frame-name} i-filtro <> 1 then
      enable i-melhor-pior with frame fpage1.
   else
      disable i-melhor-pior with frame fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-boaf008) THEN
        RUN destroy IN h-boaf008.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def var c-classific as char no-undo.

   assign c-classific = "C¢digo Fornecedor, Nome Fornecedor, Nota Ascendente, Nota Descendente".
 /*--- Verifica se o DBO j  est  inicializado ---*/
   run initializeDBOs in this-procedure.

   IF NOT CAN-FIND (FIRST funcao WHERE funcao.cd-funcao = "spp-habilita-grafico":U 
                                   AND funcao.ativo) THEN

       ASSIGN bt-grafico-1:HIDDEN IN FRAME fPage1 = YES
              bt-grafico-2:HIDDEN IN FRAME fPage1 = YES.

   FOR FIRST param-estoq FIELDS(estabel-pad) NO-LOCK. END.
   assign c-cod-estabel-ini:screen-value in frame fpage1 = param-estoq.estabel-pad
          c-cod-estabel-fim:screen-value in frame fpage1 = param-estoq.estabel-pad.

   disable i-melhor-pior with frame fpage1.
   
   /* Preenche os combo-box com os anos */
   {afbo/boaf016.i2 cb-ano-ini cb-ano-fim fpage1}

   RUN pi-preenche-periodo-ini.
   RUN pi-preenche-periodo-fim.

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      run utp/ut-lstit.p (input-output c-classific).
      assign cb-classificacao:list-item-pairs in frame fPage1 = c-classific
             cb-classificacao:screen-value in frame fPage1    = entry(4 * 2 /*Nota Descendente*/, cb-classificacao:list-item-pairs in frame fPage1,",").
   &else
      assign cb-classificacao:list-items in frame fPage1   = ""
             cb-classificacao:list-items in frame fPage1   = c-classific
             cb-classificacao:screen-value in frame fPage1 = entry(4 /*Nota Descendente*/, cb-classificacao:list-items in frame fPage1,",").
   &endif

   assign i-classific = 4 /*Nota Descendente*/.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boaf008) THEN DO:
        run afbo/boaf008.p persistent set h-boaf008.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-atributos wWindow 
PROCEDURE pi-cria-atributos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   IF NOT CAN-FIND (FIRST tt-atributos) THEN DO:
        create tt-atributos.
        assign tt-atributos.cod-versao-integracao = 003
               tt-atributos.numgraph              = 1
               tt-atributos.graphtype             = 1
               tt-atributos.graphtitle            = ""
               tt-atributos.lefttitle             = ""
               tt-atributos.lefttitlestyle        = 1
               tt-atributos.bottomtitle           = ""
               tt-atributos.legendpos             = 1
               tt-atributos.gridstyle             = 1
               tt-atributos.gridlinestyle         = 0
               tt-atributos.DataLabels            = 1
               tt-atributos.DataLabelFormat       = ">>9.99"
               tt-atributos.TitleFontSize         = 10
               tt-atributos.LabelFontSize         = 8
               tt-atributos.LegendFontSize        = 10
               tt-atributos.OtherFontSize         = 8
               tt-atributos.LineStats             = 0.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grafico wWindow 
PROCEDURE pi-grafico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-tipo-graf   as int no-undo.

    if NOT can-find (first tt-notas) THEN RETURN.

    EMPTY TEMP-TABLE tt-atributos.
    RUN pi-cria-atributos.

   /* Inicializa temp-tables -----------------------------------------------------*/
    for each tt-dados:       delete tt-dados.       end.
    for each tt-points-2:    delete tt-points-2.    end.
    for each tt-sets:        delete tt-sets.        end.
    for each tt-points-2-af: delete tt-points-2-af. end.
    for each tt-sets-af:     delete tt-sets-af.     end.
    for each tt-erros:       delete tt-erros.       end.
    
    FIND FIRST tt-atributos 
         WHERE tt-atributos.NumGraph = 2 NO-ERROR.
    IF AVAIL tt-atributos THEN DELETE tt-atributos.

    FIND FIRST tt-atributos NO-ERROR.

    IF p-tipo-graf = 1 THEN 
       RUN pi-grafico-fornecedores.
    ELSE
       RUN pi-grafico-pontos-controle.
    IF RETURN-VALUE = "NOK" THEN RETURN.

    IF NOT CAN-FIND (FIRST tt-sets) THEN DO:
        create tt-sets.
        assign tt-sets.numgraph   = 1
               tt-sets.numset     = 1.
    END.

    FIND FIRST tt-atributos NO-ERROR.

    /* Gera o Gr fico -------------------------------------------------------------*/
    Def var h-utapi011 as handle no-undo.

    Run utp/utapi011.p persistent set h-utapi011.
    
    Run pi-execute in h-utapi011 (Input  table tt-atributos,
                                  Input  table tt-points-2,
                                  Input  table tt-sets,
                                  Input  table tt-dados,
                                  Input  table tt-ylabels,
                                  Output table tt-erros).
    
    Delete procedure h-utapi011.

    if return-value = "NOK" then
        for each tt-erros:
             run utp/ut-msgs.p (input "show",
                                input tt-erros.cod-erro,
                                input "").
        end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grafico-fornecedores wWindow 
PROCEDURE pi-grafico-fornecedores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-tit-graf        as char     no-undo.
    def var c-tit-Y           as char     no-undo.
    def var c-tit-X           as char     no-undo.
    def var c-labeltext       as char     no-undo.
    def var de-total          as dec      no-undo.
    def var r-notas           as rowid    no-undo.
    DEF VAR l-varios-periodos AS LOG      NO-UNDO.
    DEF VAR c-periodo-ini     AS CHAR     NO-UNDO.
    DEF VAR c-forn-old        LIKE tt-notas.nome-abrev NO-UNDO.
    DEF VAR i-numset          AS INT      NO-UNDO.
    DEF VAR l-cancela         AS LOG      NO-UNDO.
    def var i-conta-points    as int      no-undo.


    ASSIGN c-tit-graf = "Notas X Fornecedores - Per¡odo: "
                        + input frame fpage1 cb-ano-ini + "-" + INPUT FRAME fpage1 cb-periodo-ini.
                        if input frame fpage1 cb-ano-ini <> input frame fpage1 cb-ano-fim OR
                           INPUT FRAME fpage1 cb-periodo-ini <> INPUT FRAME fpage1 cb-periodo-fim then
                           assign c-tit-graf = c-tit-graf + 
                                  " A " + input frame fpage1 cb-ano-fim + "-" + INPUT FRAME fpage1 cb-periodo-fim.
                        assign c-tit-graf = c-tit-graf + 
                               " Est: " + input frame fpage1 c-cod-estabel-ini.
                        if input frame fpage1 c-cod-estabel-ini <> input frame fpage1 c-cod-estabel-fim then
                           assign c-tit-graf = c-tit-graf + 
                                  " A " + input frame fpage1 c-cod-estabel-fim.
    

    assign r-notas = rowid(tt-notas).
    get first br-notas.
    IF AVAIL tt-notas THEN
       ASSIGN c-periodo-ini = string(month(tt-notas.dt-indice-fim),"99") + "/" + string(year(tt-notas.dt-indice-fim)).

    do while avail (tt-notas):
       IF c-periodo-ini <> string(month(tt-notas.dt-indice-fim),"99") + "/" + string(year(tt-notas.dt-indice-fim)) THEN DO:
          ASSIGN l-varios-periodos = YES.
          LEAVE.
       END.
       get next br-notas.
    end.

    IF NOT l-varios-periodos THEN
        assign c-tit-x = "Fornecedor"
               tt-atributos.graphType = 3.
    ELSE
        ASSIGN c-tit-x = "Per¡odo"
               tt-atributos.graphType = 6.

    ASSIGN tt-atributos.graphtitle            = c-tit-graf
           tt-atributos.lefttitle             = "Nota"
           tt-atributos.lefttitlestyle        = 1
           tt-atributos.bottomtitle           = c-tit-x.

   if can-find (first tt-notas) then do:
      assign r-notas = rowid(tt-notas).
      get first br-notas.
      ASSIGN c-periodo-ini =  "".
   end.

   EMPTY TEMP-TABLE tt-dados.

   do while avail (tt-notas):
      IF NOT l-varios-periodos THEN DO:
          assign c-labeltext = tt-notas.nome-abrev.
          if input frame fpage1 c-cod-estabel-ini <>
             input frame fpage1 c-cod-estabel-fim then 
             assign c-labeltext = c-labeltext + " Est:" + tt-notas.cod-estabel.
          if input frame fpage1 cb-ano-ini <> input frame fpage1 cb-ano-fim OR
             INPUT FRAME fpage1 cb-periodo-ini <> INPUT FRAME fpage1 cb-periodo-fim then 
             assign c-labeltext = c-labeltext + " " + string(month(tt-notas.dt-indice-fim),"99") + "/" 
                                                    + string(year(tt-notas.dt-indice-fim)).

             assign i-conta-points = i-conta-points + 1.
             create tt-points-2.
             assign tt-points-2.numgraph  = 1
                    tt-points-2.numpoint  = i-conta-points
                    tt-points-2.labeltext = c-labeltext.

             create tt-dados.
             assign tt-dados.numgraph   = 1
                    tt-dados.numpoint   = i-conta-points
                    tt-dados.numset     = 1
                    tt-dados.graphdata  = tt-notas.nota.

      END.
      ELSE DO:
          assign c-labeltext = string(month(tt-notas.dt-indice-fim),"99") + "/" 
                                  + string(year(tt-notas.dt-indice-fim)).

          IF NOT CAN-FIND (FIRST tt-sets-af WHERE
                             tt-sets-af.nome-abrev = tt-notas.nome-abrev) THEN DO:
             ASSIGN i-numset = i-numset + 1.
             CREATE tt-sets-af.
             ASSIGN tt-sets-af.numgraph   = 1
                    tt-sets-af.numset     = i-numset
                    tt-sets-af.legendText = tt-notas.nome-abrev
                    tt-sets-af.nome-abrev = tt-notas.nome-abrev.
          END.
          
          IF NOT CAN-FIND (FIRST tt-points-2-af WHERE
                                 tt-points-2-af.periodo = string(month(tt-notas.dt-indice-fim),"99") + "/" +
                                                          STRING(year(tt-notas.dt-indice-fim))) 
             or tt-notas.des-periodo-aval = " -*- M‚dia -*-" THEN DO:  

              assign i-conta-points = i-conta-points + 1.
              create tt-points-2-af.
              assign tt-points-2-af.numgraph  = 1
                     tt-points-2-af.numpoint  = i-conta-points
                     tt-points-2-af.labeltext = c-labeltext
                     tt-points-2-af.periodo   = string(month(tt-notas.dt-indice-fim),"99") + "/" +
                                                STRING(year(tt-notas.dt-indice-fim)).

              find last tt-points-2-af where 
                        tt-points-2-af.numgraph = 1 and
                        tt-points-2-af.periodo  = string(month(tt-notas.dt-indice-fim),"99") + "/" + string(year(tt-notas.dt-indice-fim)) and
                        tt-points-2-af.numpoint = i-conta-points no-error.  

          END.
          ELSE
              find last tt-points-2-af where
                        tt-points-2-af.numgraph = 1 and
                        tt-points-2-af.periodo = string(month(tt-notas.dt-indice-fim),"99") + "/" + string(year(tt-notas.dt-indice-fim)) no-error.


          FIND tt-sets-af WHERE
               tt-sets-af.numgraph   = 1 AND
               tt-sets-af.nome-abrev = tt-notas.nome-abrev NO-ERROR.
            
          IF NOT CAN-FIND(FIRST tt-dados WHERE tt-dados.numpoint   = tt-points-2-af.numpoint
                                           AND tt-dados.numset     = tt-sets-af.numset
                                           AND tt-dados.numgraph   = 1 ) THEN DO:

              create tt-dados.
              assign tt-dados.numgraph   = 1
                     tt-dados.numpoint   = tt-points-2-af.numpoint
                     tt-dados.numset     = tt-sets-af.numset
                     tt-dados.graphdata  = tt-notas.nota.    
          END.
      END.
      get next br-notas.
   end.

   find tt-notas where
        rowid(tt-notas) = r-notas no-error.

   FOR EACH tt-points-2-af:
       CREATE tt-points-2.
       BUFFER-COPY tt-points-2-af TO tt-points-2.
   END.

   FOR EACH tt-sets-af:
       CREATE tt-sets.
       BUFFER-COPY tt-sets-af TO tt-sets.
   END.

    /* Selecionar caracter¡sticas do gr fio */
    RUN afp/af0601g.w (INPUT-OUTPUT TABLE tt-atributos,
                       OUTPUT l-cancela).
    IF l-cancela THEN RETURN "NOK".

    RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grafico-pontos-controle wWindow 
PROCEDURE pi-grafico-pontos-controle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-tit-graf        as char     no-undo.
    def var c-tit-Y           as char     no-undo.
    def var c-tit-X           as char     no-undo.
    def var c-labeltext       as char     no-undo.
    def var de-total          as dec      no-undo.
    def var r-notas           as rowid    no-undo.
    DEF VAR l-varios-periodos AS LOG      NO-UNDO.
    DEF VAR c-periodo-ini     AS CHAR     NO-UNDO.
    DEF VAR c-forn-old        LIKE tt-notas.nome-abrev NO-UNDO.
    DEF VAR i-numset          AS INT      NO-UNDO.
    DEF VAR i-conta-points    AS INT      NO-UNDO.
    DEF VAR i-cor             AS INT      NO-UNDO.
    DEF VAR de-total-falta    AS DEC      NO-UNDO.
    DEF VAR l-cancela         AS LOG      NO-UNDO.
    DEF VAR l-pizza           AS LOG      NO-UNDO.
    DEF VAR l-barra           AS LOG      NO-UNDO.

    DEF BUFFER b1-tt-atributos FOR tt-atributos.
 
   assign c-tit-x    = "Pontos de Controle" 
          c-tit-graf = "Pontos Controle Fornecedor: "
          c-tit-y    = "Notas".
   if can-find (first b-tt-notas) then do:
       get first br-notas1.
       if avail b-tt-notas then
          assign c-tit-graf = c-tit-graf + b-tt-notas.nome-abrev + 
                " Per¡odo: " + string(month(b-tt-notas.dt-indice-fim),"99") + "/" 
                             + string(year(b-tt-notas.dt-indice-fim)) + 
                " Est: " + b-tt-notas.cod-estabel.
   end.

   ASSIGN tt-atributos.graphtitle            = c-tit-graf
          tt-atributos.lefttitle             = c-tit-y
          tt-atributos.lefttitlestyle        = 1
          tt-atributos.bottomtitle           = c-tit-x.

   CREATE tt-sets.
   assign tt-sets.numgraph   = 1
          tt-sets.numset     = 1.
   CREATE tt-sets.
   assign tt-sets.numgraph   = 2
          tt-sets.numset     = 1
          tt-sets.Legendtext = "Realizado".
   CREATE tt-sets.
   assign tt-sets.numgraph   = 2
          tt-sets.numset     = 2
          tt-sets.Legendtext = "NÆo Realizado".

   assign de-total = 0
          i-cor    = 8.
   if can-find (first b-tt-notas) then
      get first br-notas1.
   do while avail (b-tt-notas):
      assign c-labeltext = substr(b-tt-notas.descricao,1,20) + 
                           "(" + trim(string(b-tt-notas.nota,">>9.99")) + "/"
                               + trim(string(b-tt-notas.percentual,">>9.99")) + ")  Öndice: " 
                               + trim(STRING(b-tt-notas.indice)).

      IF i-cor = 14 THEN ASSIGN i-cor = 0.

      assign i-conta-points = i-conta-points + 1
             i-cor          = i-cor + 1.

      IF i-cor = 4 THEN i-cor = i-cor + 1.
      

      /* Pizza *************************************************/
      create tt-points-2.
      assign tt-points-2.numgraph  = 1
             tt-points-2.numpoint  = i-conta-points
             tt-points-2.labeltext = c-labeltext
             tt-points-2.Colorpoint = i-cor.
      create tt-dados.
      assign tt-dados.numgraph   = 1
             tt-dados.numpoint   = i-conta-points
             tt-dados.numset     = 1
             tt-dados.graphdata  = b-tt-notas.nota.
      /*********************************************************/

      /* Barra *************************************************/
      create tt-points-2.
      assign tt-points-2.numgraph  = 2
             tt-points-2.numpoint  = i-conta-points
             tt-points-2.labeltext = substr(b-tt-notas.descricao,1,20) + " " + 
                                     trim(string(b-tt-notas.percentual,">>9.99"))
             tt-points-2.Colorpoint = i-cor.
      create tt-dados.
      assign tt-dados.numgraph   = 2
             tt-dados.numpoint   = i-conta-points
             tt-dados.numset     = 1
             tt-dados.graphdata  = b-tt-notas.nota.
      create tt-dados.
      assign tt-dados.numgraph   = 2
             tt-dados.numpoint   = i-conta-points
             tt-dados.numset     = 2
             tt-dados.graphdata  = b-tt-notas.percentual - b-tt-notas.nota.
      /*********************************************************/
                                                   
      ASSIGN de-total-falta = de-total-falta + (b-tt-notas.percentual - b-tt-notas.nota).

      assign de-total = de-total + b-tt-notas.nota.
      get next br-notas1.
   end.


   IF de-total-falta > 0 THEN DO:

      assign i-conta-points = i-conta-points + 1.

      create tt-points-2.
      assign tt-points-2.numgraph  = 1
             tt-points-2.numpoint  = i-conta-points
             tt-points-2.labeltext = "NÆo Realizado (" + trim(string(de-total-falta,">>9.99")) + "%)"
             tt-points-2.Colorpoint = 4.

      create tt-dados.
      assign tt-dados.numgraph   = 1
             tt-dados.numpoint   = i-conta-points
             tt-dados.numset     = 1
             tt-dados.graphdata  = de-total-falta.
  END.

  ASSIGN c-tit-y = "Nota: " + string(de-total,">>9.99").

  FIND tt-atributos WHERE
       tt-atributos.numgraph = 1 NO-ERROR.
  assign tt-atributos.graphtype = 2
         tt-atributos.LeftTitleStyle = 0
         tt-atributos.lefttitle = c-tit-y
         tt-atributos.graphstyle = 0.

  CREATE b1-tt-atributos.
  BUFFER-COPY tt-atributos EXCEPT numgraph TO b1-tt-atributos.
  ASSIGN b1-tt-atributos.numgraph = 2
         b1-tt-atributos.graphtitle     = c-tit-graf
         b1-tt-atributos.lefttitle      = c-tit-y
         b1-tt-atributos.lefttitlestyle = 1
         b1-tt-atributos.bottomtitle    = c-tit-x
         b1-tt-atributos.graphtype      = 3
         b1-tt-atributos.graphstyle     = 2.

  /* Selecionar caracter¡sticas do gr fio */
  RUN afp/af0601h.w (INPUT-OUTPUT TABLE tt-atributos,
                     OUTPUT l-cancela).
   
  IF NOT CAN-FIND (FIRST tt-atributos
                   WHERE tt-atributos.numgraph = 1) THEN DO:
      FOR EACH tt-sets
         WHERE tt-sets.numgraph = 1:
          DELETE tt-sets.
      END.
      FOR EACH tt-points-2
         WHERE tt-points-2.numgraph = 1:
          DELETE tt-points-2.
      END.
      FOR EACH tt-dados
         WHERE tt-dados.numgraph = 1:
          DELETE tt-dados.
      END.
  END.
  IF NOT CAN-FIND (FIRST tt-atributos
                   WHERE tt-atributos.numgraph = 2) THEN DO:
      FOR EACH tt-sets
         WHERE tt-sets.numgraph = 2:
          DELETE tt-sets.
      END.
      FOR EACH tt-points-2
         WHERE tt-points-2.numgraph = 2:
          DELETE tt-points-2.
      END.
      FOR EACH tt-dados
         WHERE tt-dados.numgraph = 2:
          DELETE tt-dados.
      END.
  END.

   IF NOT CAN-FIND (FIRST tt-atributos
                    WHERE tt-atributos.numgraph = 1) AND
          CAN-FIND (FIRST tt-atributos
                    WHERE tt-atributos.numgraph = 2) THEN DO:
      FOR EACH tt-atributos
         WHERE tt-atributos.numgraph = 2:
          ASSIGN tt-atributos.numgraph = 1.
      END.
      FOR EACH tt-sets
         WHERE tt-sets.numgraph = 2:
          ASSIGN tt-sets.numgraph = 1.
      END.
      FOR EACH tt-points-2
         WHERE tt-points-2.numgraph = 2:
          ASSIGN tt-points-2.numgraph = 1.
      END.
      FOR EACH tt-dados
         WHERE tt-dados.numgraph = 2:
          ASSIGN tt-dados.numgraph = 1.
      END.
   END.

  IF l-cancela THEN RETURN "NOK".

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-preenche-periodo-fim wWindow 
PROCEDURE pi-preenche-periodo-fim :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Preenche os combo-box com os per¡odos do ano final */
{afbo/boaf016.i3 "INPUT FRAME fpage1 cb-ano-fim:SCREEN-VALUE" cb-periodo-fim fpage1}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-preenche-periodo-ini wWindow 
PROCEDURE pi-preenche-periodo-ini :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Preenche os combo-box com os per¡odos do ano inicial */
{afbo/boaf016.i3 "INPUT FRAME fpage1 cb-ano-ini:SCREEN-VALUE" cb-periodo-ini fpage1}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRange wWindow 
PROCEDURE setRange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-cod-estabel-ini  like af-contr-indice.cod-estabel  no-undo.
def input param p-cod-estabel-fim  like af-contr-indice.cod-estabel  no-undo.      
def input param p-cod-emitente-ini like af-contr-indice.cod-emitente no-undo.                                        
def input param p-cod-emitente-fim like af-contr-indice.cod-emitente no-undo.
def input param p-it-codigo-ini    like af-contr-indice.it-codigo    no-undo.
def input param p-it-codigo-fim    like af-contr-indice.it-codigo    no-undo.
def input param p-nr-controle-ini  like af-contr-indice.nr-controle  no-undo.
def input param p-nr-controle-fim  like af-contr-indice.nr-controle  no-undo.
def input param p-ano-ini          LIKE af-periodo-aval.ano-avaliacao    no-undo.
def input param p-periodo-ini      LIKE af-periodo-aval.des-periodo-aval[1] no-undo.
def input param p-ano-fim          LIKE af-periodo-aval.ano-avaliacao    no-undo.
def input param p-periodo-fim      LIKE af-periodo-aval.des-periodo-aval[1] no-undo.
DEF INPUT PARAM p-cod-grp-aval-ini LIKE af-item-contr-estab.cod-grp-avaliacao NO-UNDO.
DEF INPUT PARAM p-cod-grp-aval-fim LIKE af-item-contr-estab.cod-grp-avaliacao NO-UNDO.
DEF INPUT PARAM p-cod-grp-resp-ini LIKE af-item-contr-estab-form.cod-grp-resp NO-UNDO.
DEF INPUT PARAM p-cod-grp-resp-fim LIKE af-item-contr-estab-form.cod-grp-resp NO-UNDO.
def input param p-cod-gr-forn-ini  like emitente.cod-gr-forn         no-undo.
def input param p-cod-gr-forn-fim  like emitente.cod-gr-forn         no-undo.
def input param p-fm-codigo-ini    like item.fm-codigo               no-undo.
def input param p-fm-codigo-fim    like item.fm-codigo               no-undo.
def input param p-ge-codigo-ini    like item.ge-codigo               no-undo.
def input param p-ge-codigo-fim    like item.ge-codigo               no-undo.
def input param p-filtro           as   int                          no-undo.
def input param p-melhor-pior      as   int                          no-undo.
def input param p-media            as   int                              no-undo.


assign c-cod-estabel-ini:screen-value  in frame fpage1 = p-cod-estabel-ini
       c-cod-estabel-fim:screen-value  in frame fpage1 = p-cod-estabel-fim  
       i-cod-emitente-ini:screen-value in frame fpage1 = string(p-cod-emitente-ini)
       i-cod-emitente-fim:screen-value in frame fpage1 = string(p-cod-emitente-fim) 
       c-it-codigo-ini:screen-value    in frame fpage1 = p-it-codigo-ini    
       c-it-codigo-fim:screen-value    in frame fpage1 = p-it-codigo-fim    
       i-nr-controle-ini:screen-value  in frame fpage1 = string(p-nr-controle-ini)  
       i-nr-controle-fim:screen-value  in frame fpage1 = string(p-nr-controle-fim)
       c-cod-grp-aval-ini = p-cod-grp-aval-ini
       c-cod-grp-aval-fim = p-cod-grp-aval-fim
       c-cod-grp-resp-ini = p-cod-grp-resp-ini
       c-cod-grp-resp-fim = p-cod-grp-resp-fim
       i-cod-gr-forn-ini = p-cod-gr-forn-ini
       i-cod-gr-forn-fim = p-cod-gr-forn-fim
       c-fm-codigo-ini   = p-fm-codigo-ini   
       c-fm-codigo-fim   = p-fm-codigo-fim    
       i-ge-codigo-ini   = p-ge-codigo-ini 
       i-ge-codigo-fim   = p-ge-codigo-fim
       i-filtro:screen-value           in frame fpage1 = string(p-filtro)         
       i-melhor-pior:screen-value      in frame fpage1 = string(p-melhor-pior)
       i-media  = p-media.

   /* Preenche os combo-box com os anos */
   {afbo/boaf016.i2 cb-ano-ini cb-ano-fim fpage1}

    if p-ano-ini <> ? and p-ano-ini <> 0 then 
       assign cb-ano-ini:screen-value in frame fpage1 = string(p-ano-ini).
    
    if p-ano-fim <> ? and p-ano-fim <> 0 then 
       assign cb-ano-fim:screen-value in frame fpage1 = string(p-ano-fim).


   RUN pi-preenche-periodo-ini.
   RUN pi-preenche-periodo-fim.

    if p-ano-ini <> ? and p-ano-ini <> 0 then 
       assign cb-periodo-ini:screen-value in frame fpage1 = p-periodo-ini.
    
    if p-ano-fim <> ? and p-ano-fim <> 0 then 
       assign cb-periodo-fim:screen-value in frame fpage1 = p-periodo-fim.


apply 'choose' to bt-executa in frame fpage0. 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

