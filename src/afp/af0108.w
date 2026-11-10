&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAf-formula NO-UNDO LIKE af-formula
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0108 2.00.00.004 } /*** "010004" ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AF0108
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Express∆o,Datas

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttAf-formula
&GLOBAL-DEFINE hDBOTable      hDBOboaf013
&GLOBAL-DEFINE DBOTable       af-formula

&GLOBAL-DEFINE page0KeyFields ttAf-formula.cod-formula ttAf-formula.nr-versao
&GLOBAL-DEFINE page0Fields    ttAf-formula.descricao desc-versao
&GLOBAL-DEFINE page1Fields    ttAf-formula.expressao cCodVarini cCodVarfim lPadrao lEspecifica cDescIni cDescFim cClass
&GLOBAL-DEFINE page2Fields    ttAF-formula.narrativa ttAf-formula.dt-implantacao ttAf-formula.dt-alter ttAf-formula.hora-alter ttAf-formula.usuar-alter  ttAf-formula.dt-ini-validade ttAf-formula.dt-fim-validade ttAf-formula.padrao

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOaf011 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf022 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boaf023 AS HANDLE      NO-UNDO.

{afbo/boaf011.i ttAf-variavel}

DEF VAR irowsreturned AS INT NO-UNDO.
DEF VAR iClass        AS INT NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brVariavel

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttAf-variavel

/* Definitions for BROWSE brVariavel                                    */
&Scoped-define FIELDS-IN-QUERY-brVariavel ttAf-variavel.cod-variavel ttAf-variavel.descricao ttAf-variavel.log-especifico ttAf-variavel.programa ttAf-variavel.padrao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brVariavel   
&Scoped-define SELF-NAME brVariavel
&Scoped-define OPEN-QUERY-brVariavel IF iClass = 1    THEN OPEN QUERY {&SELF-NAME} FOR EACH ttAf-variavel BY ttAf-variavel.cod-variavel.    ELSE OPEN QUERY {&SELF-NAME} FOR EACH ttAf-variavel BY ttAf-variavel.descricao.
&Scoped-define TABLES-IN-QUERY-brVariavel ttAf-variavel
&Scoped-define FIRST-TABLE-IN-QUERY-brVariavel ttAf-variavel


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brVariavel}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttAf-formula.cod-formula ~
ttAf-formula.descricao ttAf-formula.nr-versao 
&Scoped-define ENABLED-TABLES ttAf-formula
&Scoped-define FIRST-ENABLED-TABLE ttAf-formula
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btCarga btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS ttAf-formula.cod-formula ~
ttAf-formula.descricao ttAf-formula.nr-versao 
&Scoped-define DISPLAYED-TABLES ttAf-formula
&Scoped-define FIRST-DISPLAYED-TABLE ttAf-formula
&Scoped-Define DISPLAYED-OBJECTS desc-versao 

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
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
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
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image/im-add":U
     IMAGE-INSENSITIVE FILE "image/ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image/im-can":U
     IMAGE-INSENSITIVE FILE "image/im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCarga 
     IMAGE-UP FILE "image/im-carga.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-carga.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Atualiza as vari†veis padr∆o"
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image/im-copy":U
     IMAGE-INSENSITIVE FILE "image/ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image/im-era":U
     IMAGE-INSENSITIVE FILE "image/ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image/im-undo":U
     IMAGE-INSENSITIVE FILE "image/ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image/im-mod":U
     IMAGE-INSENSITIVE FILE "image/ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE desc-versao LIKE af-versao-avaliacao.desc-versao
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt0 
     LABEL "0" 
     SIZE 4 BY 1.25 TOOLTIP "N£mero 0".

DEFINE BUTTON bt1 
     LABEL "1" 
     SIZE 4 BY 1.25 TOOLTIP "N£mero 1".

DEFINE BUTTON bt2 
     LABEL "2" 
     SIZE 4 BY 1.25 TOOLTIP "N£mero 2".

DEFINE BUTTON bt3 
     LABEL "3" 
     SIZE 4 BY 1.25 TOOLTIP "N£mero 3".

DEFINE BUTTON bt4 
     LABEL "4" 
     SIZE 4 BY 1.25 TOOLTIP "N£mero 4".

DEFINE BUTTON bt5 
     LABEL "5" 
     SIZE 4 BY 1.25 TOOLTIP "N£mero 5".

DEFINE BUTTON bt6 
     LABEL "6" 
     SIZE 4 BY 1.25 TOOLTIP "N£mero 6".

DEFINE BUTTON bt7 
     LABEL "7" 
     SIZE 4 BY 1.25 TOOLTIP "N£mero 7".

DEFINE BUTTON bt8 
     LABEL "8" 
     SIZE 4 BY 1.25 TOOLTIP "N£mero 8".

DEFINE BUTTON bt9 
     LABEL "9" 
     SIZE 4 BY 1.25 TOOLTIP "N£mero 9".

DEFINE BUTTON btBranco 
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Espaáo em branco".

DEFINE BUTTON btCarrega 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "Carrega" 
     SIZE 8 BY 1.5 TOOLTIP "Seleciona vari†veis".

DEFINE BUTTON btdiv 
     LABEL "/":L 
     SIZE 4 BY 1.25 TOOLTIP "Divis∆o".

DEFINE BUTTON btMod 
     LABEL "MOD" 
     SIZE 4 BY 1.25 TOOLTIP "Resto da divis∆o".

DEFINE BUTTON btmult 
     LABEL "*":L 
     SIZE 4 BY 1.25 TOOLTIP "Multiplicaá∆o".

DEFINE BUTTON btparfim 
     LABEL ")" 
     SIZE 4 BY 1.25 TOOLTIP "Fecha paràntese".

DEFINE BUTTON btparini 
     LABEL "(" 
     SIZE 4 BY 1.25 TOOLTIP "Abre paràntese".

DEFINE BUTTON btpotencia 
     LABEL "^":L 
     SIZE 4 BY 1.25 TOOLTIP "Potenciaá∆o".

DEFINE BUTTON btSoma 
     LABEL "+" 
     SIZE 4 BY 1.25 TOOLTIP "Soma"
     FONT 4.

DEFINE BUTTON btsubt 
     LABEL "-" 
     SIZE 4 BY 1.25 TOOLTIP "Subtraá∆o"
     FONT 4.

DEFINE BUTTON btValida 
     LABEL "Validar" 
     SIZE 9 BY 2.25 TOOLTIP "Valida a f¢rmula".

DEFINE BUTTON btVirgula 
     LABEL "," 
     SIZE 4 BY 1.25 TOOLTIP "Decimal".

DEFINE VARIABLE cClass AS CHARACTER FORMAT "X(256)":U INITIAL "Vari†vel" 
     LABEL "Classificaá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Vari†vel","Descriá∆o" 
     DROP-DOWN-LIST
     SIZE 14.57 BY 1 NO-UNDO.

DEFINE VARIABLE cCodVarFim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE cCodVarini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Vari†vel" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE cDescFim AS CHARACTER FORMAT "X(50)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     LABEL "Desc Fim" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE cDescIni AS CHARACTER FORMAT "X(50)":U 
     LABEL "Desc Inicial" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-18
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 2.29.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41.43 BY 6.13.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41.43 BY 2.92.

DEFINE VARIABLE lEspecifica AS LOGICAL INITIAL no 
     LABEL "Somente Especifica" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE lPadrao AS LOGICAL INITIAL no 
     LABEL "Somente Padr∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 6.75.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 4.25.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 4.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brVariavel FOR 
      ttAf-variavel SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brVariavel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brVariavel wMaintenance _FREEFORM
  QUERY brVariavel DISPLAY
      ttAf-variavel.cod-variavel FORMAT "x(11)"
 ttAf-variavel.descricao FORMAT "x(50)"
 ttAf-variavel.log-especifico
 ttAf-variavel.programa 
 ttAf-variavel.padrao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 42 BY 9.25
         FONT 1
         TITLE "Vari†veis" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma alteraá‰es"
     btCarga AT ROW 1.13 COL 68 HELP
          "Elimina ocorrància corrente"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttAf-formula.cod-formula AT ROW 3.04 COL 19.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttAf-formula.descricao AT ROW 3.04 COL 28.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 45 BY .88
     desc-versao AT ROW 4 COL 28.43 COLON-ALIGNED HELP
          "Descriá∆o da Vers∆o" NO-LABEL
     ttAf-formula.nr-versao AT ROW 4.04 COL 19.43 COLON-ALIGNED
          LABEL "Vers∆o"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.72 BY 19.04
         FONT 1.

DEFINE FRAME fPage1
     brVariavel AT ROW 1.25 COL 44
     cCodVarini AT ROW 1.63 COL 10.14 COLON-ALIGNED
     cCodVarFim AT ROW 1.63 COL 30.14 COLON-ALIGNED NO-LABEL
     cDescIni AT ROW 2.63 COL 10.14 COLON-ALIGNED
     cDescFim AT ROW 3.67 COL 10.14 COLON-ALIGNED
     lPadrao AT ROW 4.63 COL 12.14
     lEspecifica AT ROW 5.38 COL 12.14
     btCarrega AT ROW 5.75 COL 34
     cClass AT ROW 6.25 COL 10.14 COLON-ALIGNED
     bt1 AT ROW 7.71 COL 2.72
     bt2 AT ROW 7.71 COL 6.72
     bt3 AT ROW 7.71 COL 10.72
     bt4 AT ROW 7.71 COL 14.72
     bt5 AT ROW 7.71 COL 18.72
     bt6 AT ROW 7.71 COL 22.72
     bt7 AT ROW 7.71 COL 26.72
     bt8 AT ROW 7.71 COL 30.72
     bt9 AT ROW 7.71 COL 34.72
     bt0 AT ROW 7.71 COL 38.72
     btVirgula AT ROW 8.96 COL 2.72
     btBranco AT ROW 8.96 COL 6.72
     btSoma AT ROW 8.96 COL 10.72 HELP
          "Inclui nova ocorrància"
     btsubt AT ROW 8.96 COL 14.72 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btmult AT ROW 8.96 COL 18.72 HELP
          "Primeira ocorrància"
     btdiv AT ROW 8.96 COL 22.72 HELP
          "Ocorrància anterior"
     btparini AT ROW 8.96 COL 26.72 HELP
          "V† Para"
     btparfim AT ROW 8.96 COL 30.72 HELP
          "Pesquisa"
     btpotencia AT ROW 8.96 COL 34.72 HELP
          "Pr¢xima ocorrància"
     btMod AT ROW 8.96 COL 38.72
     btValida AT ROW 10.75 COL 77
     ttAf-formula.expressao AT ROW 11 COL 3 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 73 BY 1.75
     "  Express∆o Matem†tica" VIEW-AS TEXT
          SIZE 17.72 BY .54 AT ROW 10.42 COL 3
     IMAGE-18 AT ROW 1.63 COL 22.29
     IMAGE-23 AT ROW 1.63 COL 29.14
     RECT-1 AT ROW 10.75 COL 2
     RECT-28 AT ROW 1.38 COL 2
     RECT-31 AT ROW 7.5 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.83
         SIZE 86.43 BY 12.5
         FONT 1.

DEFINE FRAME fPage2
     ttAf-formula.dt-ini-validade AT ROW 1.5 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAf-formula.dt-implantacao AT ROW 1.5 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAf-formula.dt-fim-validade AT ROW 2.38 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAf-formula.dt-alter AT ROW 2.38 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAf-formula.hora-alter AT ROW 3.33 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAf-formula.padrao AT ROW 3.42 COL 19
          VIEW-AS TOGGLE-BOX
          SIZE 14.14 BY .71
     ttAf-formula.usuar-alter AT ROW 4.21 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAf-formula.narrativa AT ROW 6.25 COL 3 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 79 BY 5.75
     " Narrativa" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 5.42 COL 3.14
     RECT-25 AT ROW 5.75 COL 2
     RECT-26 AT ROW 1.17 COL 43
     RECT-27 AT ROW 1.17 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.83
         SIZE 84.43 BY 11.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttAf-formula T "?" NO-UNDO emsdca af-formula
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
         HEIGHT             = 19.04
         WIDTH              = 90.72
         MAX-HEIGHT         = 19.04
         MAX-WIDTH          = 90.72
         VIRTUAL-HEIGHT     = 19.04
         VIRTUAL-WIDTH      = 90.72
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
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN desc-versao IN FRAME fpage0
   NO-ENABLE LIKE = emsdca.af-versao-avaliacao.desc-versao EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FILL-IN ttAf-formula.nr-versao IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brVariavel RECT-31 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brVariavel
/* Query rebuild information for BROWSE brVariavel
     _START_FREEFORM
IF iClass = 1
   THEN OPEN QUERY {&SELF-NAME} FOR EACH ttAf-variavel BY ttAf-variavel.cod-variavel.
   ELSE OPEN QUERY {&SELF-NAME} FOR EACH ttAf-variavel BY ttAf-variavel.descricao.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brVariavel */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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


&Scoped-define BROWSE-NAME brVariavel
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brVariavel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brVariavel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF brVariavel IN FRAME fPage1 /* Vari†veis */
DO:
   
    IF ttAf-formula.expressao:SENSITIVE THEN
       assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + ttAf-variavel.cod-variavel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt0 wMaintenance
ON CHOOSE OF bt0 IN FRAME fPage1 /* 0 */
DO:
  assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + "0".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt1 wMaintenance
ON CHOOSE OF bt1 IN FRAME fPage1 /* 1 */
DO:
  assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + "1".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt2 wMaintenance
ON CHOOSE OF bt2 IN FRAME fPage1 /* 2 */
DO:
  assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + "2".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt3 wMaintenance
ON CHOOSE OF bt3 IN FRAME fPage1 /* 3 */
DO:
  assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + "3".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt4 wMaintenance
ON CHOOSE OF bt4 IN FRAME fPage1 /* 4 */
DO:
  assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + "4".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt5 wMaintenance
ON CHOOSE OF bt5 IN FRAME fPage1 /* 5 */
DO:
  assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + "5".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt6 wMaintenance
ON CHOOSE OF bt6 IN FRAME fPage1 /* 6 */
DO:
  assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + "6".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt7 wMaintenance
ON CHOOSE OF bt7 IN FRAME fPage1 /* 7 */
DO:
  assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + "7".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt8 wMaintenance
ON CHOOSE OF bt8 IN FRAME fPage1 /* 8 */
DO:
  assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + "8".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt9 wMaintenance
ON CHOOSE OF bt9 IN FRAME fPage1 /* 9 */
DO:
  assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + "9".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.
    RUN piNewFormula IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btBranco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btBranco wMaintenance
ON CHOOSE OF btBranco IN FRAME fPage1
DO:
  assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + " ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCarga
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCarga wMaintenance
ON CHOOSE OF btCarga IN FRAME fpage0
DO:
  /* Inicio -- Projeto Internacional */
  {utp/ut-liter.i "atualizaá∆o_das_F¢rmulas_Padr‰es" *}
  RUN utp/ut-msgs.p (INPUT "show":u, 
                     INPUT 701, 
                     INPUT RETURN-VALUE).
  IF RETURN-VALUE = "YES" THEN DO:
      RUN piCriaFormulaPadrao IN {&hDBOTable}.
      IF RETURN-VALUE = "OK":U THEN DO:
         /* Inicio -- Projeto Internacional */
         {utp/ut-liter.i "F¢rmulas_padr‰es" *}
         RUN utp/ut-msgs.p (INPUT "show":u, 
                            INPUT 52858, 
                            INPUT RETURN-VALUE).
         RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
         RUN getFirst IN THIS-PROCEDURE.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCarrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCarrega wMaintenance
ON CHOOSE OF btCarrega IN FRAME fPage1 /* Carrega */
DO:


   IF INPUT FRAME fPage1 cClass = "Descriá∆o"  THEN ASSIGN iClass = 2.
                                               ELSE ASSIGN iClass = 1.

   RUN piDeleteTempTable IN THIS-PROCEDURE.
   RUN emptyRowObject IN hDBOaf011.
   RUN setConstraintSel IN hDBOaf011 (INPUT frame fpage1 cCodVarIni,
                                      INPUT frame fpage1 cCodVarFim,
                                      INPUT frame fpage1 cDescIni,
                                      INPUT frame fpage1 cDescFim,
                                      INPUT frame fpage1 lPadrao,
                                      INPUT frame fpage1 lEspecifica).
   RUN openQueryStatic IN hDBOaf011 (INPUT "Sel":U) NO-ERROR. 
   run getBatchRecords in hDBOaf011 (input ?,
                                     input NO,
                                     input 40,
                                     output irowsreturned,
                                     output table ttAf-variavel).
                                       
   {&OPEN-QUERY-brVariavel}
                                      

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btdiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btdiv wMaintenance
ON CHOOSE OF btdiv IN FRAME fPage1 /* / */
DO:
      assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + " / ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btMod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMod wMaintenance
ON CHOOSE OF btMod IN FRAME fPage1 /* MOD */
DO:
    assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + " MOD ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btmult
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btmult wMaintenance
ON CHOOSE OF btmult IN FRAME fPage1 /* * */
DO:
      assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + " * ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btparfim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btparfim wMaintenance
ON CHOOSE OF btparfim IN FRAME fPage1 /* ) */
DO:
        assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + " ) ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btparini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btparini wMaintenance
ON CHOOSE OF btparini IN FRAME fPage1 /* ( */
DO:
        assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + " ( ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btpotencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btpotencia wMaintenance
ON CHOOSE OF btpotencia IN FRAME fPage1 /* ^ */
DO:
        assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + " ^ ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomReposition.i &ProgramZoom="afzoom/z01af013.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btSoma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSoma wMaintenance
ON CHOOSE OF btSoma IN FRAME fPage1 /* + */
DO:
    assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + " + ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btsubt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btsubt wMaintenance
ON CHOOSE OF btsubt IN FRAME fPage1 /* - */
DO:
      assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + " - ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:

   DEFINE VARIABLE l-usa-versao AS LOGICAL     NO-UNDO.
   DEFINE VARIABLE inr-versao AS INTEGER     NO-UNDO.
   DEFINE VARIABLE cdesc-versao AS CHARACTER   NO-UNDO.

   RUN pi-usa-versao-menor (OUTPUT l-usa-versao, OUTPUT inr-versao, OUTPUT cdesc-versao).

   IF l-usa-versao THEN DO:
       RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 52824, INPUT "").
   END.


   RUN updateRecord IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btValida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btValida wMaintenance
ON CHOOSE OF btValida IN FRAME fPage1 /* Validar */
DO:
  RUN piValidaFormula IN {&hDBOTable} (INPUT FRAME  fPage1 ttAf-formula.expressao,
                                       INPUT-OUTPUT TABLE RowErrors).
  IF RETURN-VALUE = "NOK" THEN DO:
    {method/ShowMessage.i1}
    {method/ShowMessage.i2}
  END.
  ELSE DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "F¢rmula_validada" *}
    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 32388, INPUT RETURN-VALUE).
  END.
  EMPTY TEMP-TABLE RowErrors.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVirgula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVirgula wMaintenance
ON CHOOSE OF btVirgula IN FRAME fPage1 /* , */
DO:
  assign ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 = ttAf-formula.expressao:SCREEN-VALUE IN FRAME fPage1 + ".".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lPadrao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lPadrao wMaintenance
ON VALUE-CHANGED OF lPadrao IN FRAME fPage1 /* Somente Padr∆o */
DO:
    IF INPUT FRAME fpage1 lPadrao:CHECKED THEN
       DISABLE lEspecifica with frame fpage1.
    ELSE 
       ENABLE lEspecifica with frame fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttAf-formula.nr-versao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-formula.nr-versao wMaintenance
ON F5 OF ttAf-formula.nr-versao IN FRAME fpage0 /* Vers∆o */
DO:
  {method/zoomfields.i &ProgramZoom="afzoom/z01af023.w"
                      &FieldZoom1="nr-versao"
                      &FieldScreen1="ttAf-formula.nr-versao"
                      &Frame1="fPage0"
                      &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-formula.nr-versao wMaintenance
ON LEAVE OF ttAf-formula.nr-versao IN FRAME fpage0 /* Vers∆o */
DO:
  {method/referenceFields.i
            &HandleDBOLeave="h-boaf023"
            &KeyValue1="ttAf-formula.nr-versao:screen-value in frame fpage0"
            &KeyValue2="v_cdn_empres_usuar"            
            &FieldName1="desc-versao"                        
            &FieldScreen1="desc-versao"
            &Frame1="fpage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-formula.nr-versao wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttAf-formula.nr-versao IN FRAME fpage0 /* Vers∆o */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/MainBlock.i}
ttAf-formula.nr-versao:load-mouse-pointer("image/lupa.cur":U) in frame fPage0.

ENABLE btCarga WITH FRAME fpage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInteface wMaintenance 
PROCEDURE afterDestroyInteface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF VALID-HANDLE(h-boaf022) THEN DO:
        DELETE PROCEDURE h-boaf022.
        ASSIGN h-boaf022 = ?.
    END.

    IF VALID-HANDLE(h-boaf023) THEN DO:
        DELETE PROCEDURE h-boaf023.
        ASSIGN h-boaf023 = ?.
    END.

    IF VALID-HANDLE(hDBOaf011) THEN DO:
        DELETE PROCEDURE hDBOaf011.
        ASSIGN hDBOaf011 = ?.
    END.
    
    {method/ShowMessage.i3}
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisableFields wMaintenance 
PROCEDURE afterDisableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DISABLE brVariavel 
           btCarrega
           btSoma
           btSubt
           btMult
           btDiv
           btParini
           btParfim
           btPotencia btMod
           bt1 bt2 bt3 bt4 bt5 bt6 bt7 bt8 bt9 bt0 btVirgula btBranco btValida 
           WITH FRAME fPage1.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN iClass = 1.
   RUN piDeleteTempTable IN THIS-PROCEDURE.
   RUN emptyRowObject IN hDBOaf011.
   RUN setConstraintSel IN hDBOaf011 (INPUT frame fpage1 cCodVarIni,
                                      INPUT frame fpage1 cCodVarFim,
                                      INPUT frame fpage1 cDescIni,
                                      INPUT frame fpage1 cDescFim,
                                      INPUT frame fpage1 lPadrao,
                                      INPUT frame fpage1 lEspecifica).
   RUN openQueryStatic IN hDBOaf011 (INPUT "Sel":U) NO-ERROR. 
   run getBatchRecords in hDBOaf011 (input ?,
                                     input NO,
                                     input 40,
                                     output irowsreturned,
                                     output table ttAf-variavel).
   {&OPEN-QUERY-brVariavel}

   ENABLE brVariavel WITH FRAME fPage1.

   DEFINE VARIABLE l-usa-versao AS LOGICAL     NO-UNDO.
   DEFINE VARIABLE inr-versao AS INTEGER     NO-UNDO.
   DEFINE VARIABLE cdesc-versao AS CHARACTER   NO-UNDO.

   RUN pi-usa-versao-menor (OUTPUT l-usa-versao, OUTPUT inr-versao, OUTPUT cdesc-versao).

   IF l-usa-versao = FALSE THEN DO:
        DISABLE ttAf-formula.nr-versao
            WITH FRAME fpage0.
        ASSIGN ttAf-formula.nr-versao:SCREEN-VALUE IN FRAME fpage0 = STRING(inr-versao).
   END. 

   APPLY "LEAVE":U TO ttAf-formula.nr-versao IN FRAME fpage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenance 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DISABLE ttAf-formula.dt-implantacao
            ttAf-formula.dt-alter
            ttAf-formula.hora-alter
            ttAf-formula.usuar-alter
            ttAf-formula.padrao
            WITH FRAME fPage2.

    DISABLE desc-versao WITH FRAME fPage0.

   DEFINE VARIABLE l-usa-versao AS LOGICAL     NO-UNDO.
   DEFINE VARIABLE inr-versao AS INTEGER     NO-UNDO.
   DEFINE VARIABLE cdesc-versao AS CHARACTER   NO-UNDO.

   RUN pi-usa-versao-menor (OUTPUT l-usa-versao, OUTPUT inr-versao, OUTPUT cdesc-versao).

   IF l-usa-versao = FALSE THEN
        DISABLE ttAf-formula.nr-versao
            WITH FRAME fpage0.            


    IF ttAf-formula.padrao THEN
       DISABLE ttAf-formula.descricao  WITH FRAME fPage0.
    ENABLE brVariavel 
           btCarrega
           btSoma
           btSubt
           btMult
           btDiv
           btParini
           btParfim
           btPotencia
           bt1 bt2 bt3 bt4 bt5 bt6 bt7 bt8 bt9 bt0 btVirgula btBranco btValida  btMod
           WITH FRAME fPage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
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
    
    DEFINE VARIABLE i-cod-formula LIKE {&ttTable}.cod-formula NO-UNDO.
    DEFINE VARIABLE i-nr-versao LIKE {&ttTable}.nr-versao FORMAT ">>>>9" NO-UNDO.
    
    
    DEFINE FRAME fGoToRecord
        i-cod-formula  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        i-nr-versao    AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para F¢rmula" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-cod-formula
               i-nr-versao.
        
        RUN goToKey IN {&hDBOTable} (INPUT i-ep-codigo-usuario , INPUT i-cod-formula, INPUT i-nr-versao ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "F¢rmula" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-cod-formula btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 

    DEFINE VARIABLE l-usa-versao AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE inr-versao AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cdesc-versao AS CHARACTER   NO-UNDO.


    RUN pi-usa-versao-menor (OUTPUT l-usa-versao, OUTPUT inr-versao, OUTPUT cdesc-versao).

    IF l-usa-versao THEN
         ENABLE i-nr-versao
            WITH FRAME fGoToRecord. 
    ELSE DO:
        DISABLE i-nr-versao
            WITH FRAME fGoToRecord. 
        ASSIGN i-nr-versao:SCREEN-VALUE IN FRAME fGoToRecord  = STRING(inr-versao).
    END.
        
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "afbo/boaf013.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf013.p YES}
        {btb/btb008za.i2 afbo/boaf013.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(hDBOaf011) OR
       hDBOaf011:TYPE <> "PROCEDURE":U OR
       hDBOaf011:FILE-NAME <> "afbo/boaf011.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf011.p YES}
        {btb/btb008za.i2 afbo/boaf011.p '' hDBOaf011}
    END.
    
    RUN openQueryStatic IN hDBOaf011 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boaf022) THEN DO:
        RUN afbo/boaf022.p PERSISTENT SET h-boaf022.        
    END.

    RUN openQueryStatic IN h-boaf022 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boaf023) THEN DO:
       RUN afbo/boaf023.p PERSISTENT SET h-boaf023.       
    END.

    RUN openQueryStatic IN h-boaf023 (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-usa-versao-menor wMaintenance 
PROCEDURE pi-usa-versao-menor :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para retornar se utiliza vers∆o e f¢rmula (AF0101) e
               Retornar menor vers∆o se necess†rio.
  Parameters:  pHabilita -> Se Utiliza vers∆o e F¢rmula
               pnr-versao -> Menor Vers∆o
               pdesc-versao -> Descriá∆o da Vers∆o
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER phabilita AS LOGICAL NO-UNDO.
DEFINE OUTPUT PARAMETER pnr-versao LIKE af-versao-avaliacao.nr-versao NO-UNDO.
DEFINE OUTPUT PARAMETER pdesc-versao LIKE  af-versao-avaliacao.desc-versao NO-UNDO.

IF NOT VALID-HANDLE(h-boaf022) THEN DO:
    RUN afbo/boaf022.p PERSISTENT SET h-boaf022.
    RUN openQueryStatic IN h-boaf022 (INPUT "Main":U) NO-ERROR.
END.
    
DEFINE VARIABLE l-usa-versao AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-usa-formula AS LOGICAL     NO-UNDO.

RUN getLogField IN h-boaf022 (INPUT "log-usa-versao":U, OUTPUT l-usa-versao).
RUN getLogField IN h-boaf022 (INPUT "log-versao-formula":U, OUTPUT l-usa-formula).

IF l-usa-versao = TRUE AND l-usa-formula = TRUE THEN DO:
    ASSIGN phabilita = TRUE.
END.
ELSE DO:
    DEFINE VARIABLE  i-nr-versao  LIKE af-versao-avaliacao.nr-versao   NO-UNDO.
    DEFINE VARIABLE  c-desc-versao  LIKE af-versao-avaliacao.desc-versao   NO-UNDO.

    IF NOT VALID-HANDLE(h-boaf023) THEN DO:
        RUN afbo/boaf023.p PERSISTENT SET h-boaf023.
        RUN openQueryStatic IN h-boaf023 (INPUT "Main":U) NO-ERROR.
    END.

    RUN pi-retorna-menor-versao IN h-boaf023 (OUTPUT i-nr-versao).

    RUN goToKey IN h-boaf023 (INPUT i-nr-versao, INPUT v_cdn_empres_usuar).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

     RUN getCharField IN h-boaf023 (INPUT "desc-versao":U, OUTPUT c-desc-versao).      
    
     ASSIGN pnr-versao = i-nr-versao
            pdesc-versao =  c-desc-versao
            phabilita = FALSE.     
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDeleteTempTable wMaintenance 
PROCEDURE piDeleteTempTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH ttAf-variavel:
    DELETE ttAf-variavel.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piNewFormula wMaintenance 
PROCEDURE piNewFormula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   run setdefaults in hDBOboaf013 (output ttAf-formula.ep-codigo,
                                   output ttAf-formula.cod-formula,
                                   OUTPUT ttaf-formula.nr-versao).
   disp ttAf-formula.cod-formula 
        ttAf-formula.nr-versao with frame fPage0.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

