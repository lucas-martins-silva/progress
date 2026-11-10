&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAf-item-contr NO-UNDO LIKE af-item-contr
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttAf-item-contr-form NO-UNDO LIKE af-item-contr-form
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
************************************************a*******************************/
{include/i-prgvrs.i AF0104 2.00.00.005 } /*** 010005 ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AF0104
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Principal,F¢rmula

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

&GLOBAL-DEFINE ttTable        ttAf-item-contr
&GLOBAL-DEFINE hDBOTable      hDBboaf004
&GLOBAL-DEFINE DBOTable       Af-item-contr

&GLOBAL-DEFINE page0KeyFields ttAf-item-contr.it-codigo ~
                              ttAf-item-contr.cod-emitente ~
                              ttAf-item-contr.nr-versao
&GLOBAL-DEFINE page1Fields    ttAf-item-contr.qualidade ttAf-item-contr.ativo ~
                              ttAf-item-contr.demerito ~
                              ttAf-item-contr.quantidade ~
                              ttAf-item-contr.preco ~
                              ttAf-item-contr.data-entrega ~
                              ttAf-item-contr.nr-dia-min ~
                              ttAf-item-contr.nr-dia-max ~
                              ttAf-item-contr.dt-implantacao ~
                              ttAf-item-contr.dt-alter ~
                              ttAf-item-contr.usuar-alter ~
                              ttAf-item-contr.hora-alter ~
                              ttAf-item-contr.narrativa ~
                              ttAf-item-contr.log-considera-qtd-receb ~
                              ttAf-item-contr.log-considera-val-receb ~
                              ttAf-item-contr.pct-qtd-min ~
                              ttAf-item-contr.pct-qtd-max ~
                              ttAf-item-contr.pct-val-min ~
                              ttAf-item-contr.pct-val-max
    
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{utp/ut-glob.i}
DEFINE VARIABLE c-periodicidade AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-cod-grp-resp  AS CHARACTER FORMAT "x(8)"  NO-UNDO.
DEFINE VARIABLE cDesItem        LIKE item.desc-item         NO-UNDO.
DEFINE VARIABLE cNomeEmite      LIKE emitente.nome-emit     NO-UNDO.
DEFINE VARIABLE cDescVers       LIKE af-versao-avaliacao.desc-versao NO-UNDO.
DEFINE VARIABLE c-desc          LIKE af-controle.descricao  NO-UNDO.
DEFINE VARIABLE iSeq            AS INTEGER                  NO-UNDO.
DEFINE VARIABLE v-table         AS ROWID                    NO-UNDO.
DEFINE VARIABLE l-usa-versao    AS LOGICAL                  NO-UNDO.

DEFINE VARIABLE c-cod-grp-respon AS CHARACTER FORMAT "x(8)"      NO-UNDO.
DEFINE VARIABLE c-it-codigo      LIKE af-item-contr.it-codigo    NO-UNDO.
DEFINE VARIABLE i-cod-emitente   LIKE af-item-contr.cod-emitente NO-UNDO.
DEFINE VARIABLE i-nr-versao      LIKE af-item-contr.nr-versao    NO-UNDO.

/*--- Vari†veis definidas para que se possa utilizar o zoom 
      feito em Smart Objects ---*/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
/*-----------------------------------------------------------------*/


/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf001    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf005    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf023    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf022    AS HANDLE NO-UNDO.

{afbo/boaf005.i bttAf-item-contr-form}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttAf-item-contr-form

/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 ttAf-item-contr-form.seq ~
ttAf-item-contr-form.nr-controle ~
fn-desc(ttAf-item-contr-form.nr-controle) @ c-desc ~
ttAf-item-contr-form.percentual ttAf-item-contr-form.cod-grp-resp ~
ttAf-item-contr-form.log-per-variavel fn_periodicidade() @ c-periodicidade ~
ttAf-item-contr-form.dt-implantacao ttAf-item-contr-form.dt-alter ~
ttAf-item-contr-form.hora-alter ttAf-item-contr-form.usuar-alter ~
ttAf-item-contr-form.narrativa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH ttAf-item-contr-form NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH ttAf-item-contr-form NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon2 ttAf-item-contr-form
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 ttAf-item-contr-form


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttAf-item-contr.it-codigo ~
ttAf-item-contr.cod-emitente ttAf-item-contr.nr-versao 
&Scoped-define ENABLED-TABLES ttAf-item-contr
&Scoped-define FIRST-ENABLED-TABLE ttAf-item-contr
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btQueryJoins btReportsJoins btExit btHelp cDescItem cNomeEmitente ~
cDescVersao 
&Scoped-Define DISPLAYED-FIELDS ttAf-item-contr.it-codigo ~
ttAf-item-contr.cod-emitente ttAf-item-contr.nr-versao 
&Scoped-define DISPLAYED-TABLES ttAf-item-contr
&Scoped-define FIRST-DISPLAYED-TABLE ttAf-item-contr
&Scoped-Define DISPLAYED-OBJECTS cDescItem cNomeEmitente cDescVersao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc wMaintenance 
FUNCTION fn-desc RETURNS CHARACTER
  (i-controle AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn_periodicidade wMaintenance 
FUNCTION fn_periodicidade RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
     IMAGE-UP FILE "image~/im-add":U
     IMAGE-INSENSITIVE FILE "image~/ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image~/im-can":U
     IMAGE-INSENSITIVE FILE "image~/im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image~/im-copy":U
     IMAGE-INSENSITIVE FILE "image~/ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image~/im-era":U
     IMAGE-INSENSITIVE FILE "image~/ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~/im-exi":U
     IMAGE-INSENSITIVE FILE "image~/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image~/im-fir":U
     IMAGE-INSENSITIVE FILE "image~/ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image~/im-enter":U
     IMAGE-INSENSITIVE FILE "image~/ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~/im-hel":U
     IMAGE-INSENSITIVE FILE "image~/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image~/im-las":U
     IMAGE-INSENSITIVE FILE "image~/ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image~/im-nex":U
     IMAGE-INSENSITIVE FILE "image~/ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image~/im-pre":U
     IMAGE-INSENSITIVE FILE "image~/ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image~/im-joi":U
     IMAGE-INSENSITIVE FILE "image~/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image~/im-pri":U
     IMAGE-INSENSITIVE FILE "image~/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image~/im-sav":U
     IMAGE-INSENSITIVE FILE "image~/ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image~/im-sea":U
     IMAGE-INSENSITIVE FILE "image~/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image~/im-undo":U
     IMAGE-INSENSITIVE FILE "image~/ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image~/im-mod":U
     IMAGE-INSENSITIVE FILE "image~/ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE cDescItem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE cDescVersao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .88 NO-UNDO.

DEFINE VARIABLE cNomeEmitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 2.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 3.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 4.25.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 2.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 3.5.

DEFINE BUTTON btAddSon 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon2 FOR 
      ttAf-item-contr-form SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMaintenance _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      ttAf-item-contr-form.seq FORMAT ">>>>9":U WIDTH 6
      ttAf-item-contr-form.nr-controle FORMAT ">>>>>9":U WIDTH 12
      fn-desc(ttAf-item-contr-form.nr-controle) @ c-desc COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 30
      ttAf-item-contr-form.percentual FORMAT ">>9.99":U WIDTH 7
      ttAf-item-contr-form.cod-grp-resp FORMAT "X(8)":U
      ttAf-item-contr-form.log-per-variavel FORMAT "Sim/N∆o":U
      fn_periodicidade() @ c-periodicidade COLUMN-LABEL "Periodicidade" FORMAT "x(10)":U
      ttAf-item-contr-form.dt-implantacao FORMAT "99/99/9999":U
            WIDTH 11
      ttAf-item-contr-form.dt-alter FORMAT "99/99/9999":U WIDTH 11
      ttAf-item-contr-form.hora-alter FORMAT "X(8)":U
      ttAf-item-contr-form.usuar-alter FORMAT "X(12)":U WIDTH 13
      ttAf-item-contr-form.narrativa FORMAT "x(100)":U WIDTH 100
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.


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
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttAf-item-contr.it-codigo AT ROW 2.83 COL 12.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     cDescItem AT ROW 2.83 COL 30 COLON-ALIGNED NO-LABEL
     ttAf-item-contr.cod-emitente AT ROW 3.83 COL 12.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cNomeEmitente AT ROW 3.83 COL 23 COLON-ALIGNED NO-LABEL
     ttAf-item-contr.nr-versao AT ROW 4.83 COL 12.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescVersao AT ROW 4.83 COL 23 COLON-ALIGNED NO-LABEL
     rtKeys AT ROW 2.5 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.5
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.17 COL 2
     btAddSon AT ROW 10.33 COL 2
     btUpdateSon AT ROW 10.33 COL 12
     btDeleteSon AT ROW 10.33 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.79
         SIZE 84.43 BY 10.62
         FONT 1.

DEFINE FRAME fPage1
     ttAf-item-contr.qualidade AT ROW 1.5 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 10.43 BY .71
     ttAf-item-contr.demerito AT ROW 1.5 COL 55 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttAf-item-contr.quantidade AT ROW 2.5 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 11.43 BY .71
     ttAf-item-contr.log-considera-qtd-receb AT ROW 2.5 COL 17
          VIEW-AS TOGGLE-BOX
          SIZE 29.43 BY .71
     ttAf-item-contr.pct-qtd-min AT ROW 2.5 COL 55 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttAf-item-contr.pct-qtd-max AT ROW 2.5 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttAf-item-contr.preco AT ROW 3.5 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 7.57 BY .71
     ttAf-item-contr.log-considera-val-receb AT ROW 3.5 COL 17
          VIEW-AS TOGGLE-BOX
          SIZE 29.29 BY .71
     ttAf-item-contr.pct-val-min AT ROW 3.5 COL 55 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttAf-item-contr.pct-val-max AT ROW 3.5 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttAf-item-contr.data-entrega AT ROW 4.5 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 12.57 BY .71
     ttAf-item-contr.nr-dia-min AT ROW 4.5 COL 55 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttAf-item-contr.nr-dia-max AT ROW 4.5 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttAf-item-contr.dt-implantacao AT ROW 6 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     ttAf-item-contr.dt-alter AT ROW 6 COL 46.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     ttAf-item-contr.ativo AT ROW 6.67 COL 66
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .71
     ttAf-item-contr.hora-alter AT ROW 7 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     ttAf-item-contr.usuar-alter AT ROW 7 COL 46.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     ttAf-item-contr.narrativa AT ROW 8.75 COL 17 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 66 BY 3
     "Narrativa:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 8.71 COL 9.57
     RECT-1 AT ROW 5.75 COL 61
     RECT-2 AT ROW 8.5 COL 2
     RECT-3 AT ROW 1.25 COL 2
     RECT-4 AT ROW 5.75 COL 2
     RECT-5 AT ROW 8.5 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.83
         SIZE 84.43 BY 11.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttAf-item-contr T "?" NO-UNDO mgcad af-item-contr
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttAf-item-contr-form T "?" NO-UNDO mgcad af-item-contr-form
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
         HEIGHT             = 18.5
         WIDTH              = 90
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
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.ttAf-item-contr-form"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.ttAf-item-contr-form.seq
"ttAf-item-contr-form.seq" ? ? "integer" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttAf-item-contr-form.nr-controle
"ttAf-item-contr-form.nr-controle" ? ? "integer" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fn-desc(ttAf-item-contr-form.nr-controle) @ c-desc" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttAf-item-contr-form.percentual
"ttAf-item-contr-form.percentual" ? ? "decimal" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.ttAf-item-contr-form.cod-grp-resp
     _FldNameList[6]   = Temp-Tables.ttAf-item-contr-form.log-per-variavel
     _FldNameList[7]   > "_<CALC>"
"fn_periodicidade() @ c-periodicidade" "Periodicidade" "x(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttAf-item-contr-form.dt-implantacao
"ttAf-item-contr-form.dt-implantacao" ? ? "date" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ttAf-item-contr-form.dt-alter
"ttAf-item-contr-form.dt-alter" ? ? "date" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = Temp-Tables.ttAf-item-contr-form.hora-alter
     _FldNameList[11]   > Temp-Tables.ttAf-item-contr-form.usuar-alter
"ttAf-item-contr-form.usuar-alter" ? ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ttAf-item-contr-form.narrativa
"ttAf-item-contr-form.narrativa" ? "x(100)" "character" ? ? ? ? ? ? no ? no no "100" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon2 */
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


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon wMaintenance
ON CHOOSE OF btAddSon IN FRAME fPage2 /* Incluir */
DO:
  RUN afp/af0104a.w ( INPUT 1,
                      INPUT FRAME fPage0 ttAf-item-contr.it-codigo,
                      INPUT FRAME fPage0 ttAf-item-contr.cod-emitente,
                      INPUT FRAME fPage0 ttAf-item-contr.nr-versao,
                      INPUT 0,
                      INPUT-OUTPUT TABLE ttAf-item-contr-form). 
  {&OPEN-QUERY-{&BROWSE-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
    DISABLE btAddSon
            btUpdateSon
            btDeleteSon WITH FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDeleteSon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon wMaintenance
ON CHOOSE OF btDeleteSon IN FRAME fPage2 /* Eliminar */
DO:
   
  IF ttAf-item-contr-form.nr-controle >= 1 AND ttAf-item-contr-form.nr-controle <= 4 THEN DO:
     /* Inicio -- Projeto Internacional */
     {utp/ut-liter.i "Ponto_de_Controle_dever_ser_eliminado_na_tela_principal" *}
     RUN utp/ut-msgs.p (INPUT "show",
                        INPUT  17567,
                        INPUT RETURN-VALUE + ".").
     RETURN.
  END. 
    
   IF AVAIL ttAf-item-contr-form THEN
      DELETE ttAf-item-contr-form.
   {&OPEN-QUERY-{&BROWSE-NAME}}  
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


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:

    ASSIGN c-it-codigo    = INPUT FRAME fPage0 ttAf-item-contr.it-codigo   
           i-cod-emitente = INPUT FRAME fPage0 ttAf-item-contr.cod-emitente
           i-nr-versao    = INPUT FRAME fPage0 ttAf-item-contr.nr-versao.

    RUN saveRecord IN THIS-PROCEDURE.

    IF cAction = "ADD" THEN DO:
      FIND FIRST af-item-contr NO-LOCK 
           WHERE af-item-contr.ep-codigo    = i-ep-codigo-usuario
             AND af-item-contr.it-codigo    = c-it-codigo    
             AND af-item-contr.cod-emitente = i-cod-emitente
             AND af-item-contr.nr-versao    = i-nr-versao NO-ERROR.
      IF AVAIL af-item-contr THEN
         ASSIGN v-table = ROWID(af-item-contr).
    END.
    ELSE DO: /*quando for inclus∆o precisa continuar habilitado para o novo registro*/

       IF RETURN-VALUE <> "NOK":U THEN
         DISABLE btAddSon
                 btUpdateSon
                 btDeleteSon WITH FRAME fPage2.
    END.
    IF RETURN-VALUE <> "NOK":U THEN 
       IF v-table <> ? THEN
          RUN afp/af0121.w (INPUT "af0104",
                            INPUT v-table).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomReposition.i &ProgramZoom="afzoom~/z01af004.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btUpdateSon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon wMaintenance
ON CHOOSE OF btUpdateSon IN FRAME fPage2 /* Alterar */
DO:
  IF AVAIL ttAf-item-contr-form THEN DO:
     RUN afp/af0104a.w ( INPUT 2,
                         INPUT FRAME fPage0 ttAf-item-contr.it-codigo,
                         INPUT FRAME fPage0 ttAf-item-contr.cod-emitente,
                         INPUT FRAME fPage0 ttAf-item-contr.nr-versao,
                         INPUT ttAf-item-contr-form.nr-controle,
                         INPUT-OUTPUT TABLE ttAf-item-contr-form). 
     {&OPEN-QUERY-{&BROWSE-NAME}}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttAf-item-contr.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.cod-emitente wMaintenance
ON F5 OF ttAf-item-contr.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
        /* ZOOM SMART OBJECT */
    {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                       &campo=ttAf-item-contr.cod-emitente
                       &campozoom=cod-emitente
                       &frame=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.cod-emitente wMaintenance
ON LEAVE OF ttAf-item-contr.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
    RUN getNomeEmitente in {&hDBOTable} ( INPUT FRAME fPage0 ttAf-item-contr.cod-emitente,
                                          OUTPUT cNomeEmite ).
    ASSIGN cNomeEmitente:SCREEN-VALUE IN FRAME fPage0 = cNomeEmite.
    
    FOR EACH ttAf-item-contr-form:
        ASSIGN ttAf-item-contr-form.cod-emitente = INPUT FRAME fPage0 ttAf-item-contr.cod-emitente.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.cod-emitente wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttAf-item-contr.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttAf-item-contr.data-entrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.data-entrega wMaintenance
ON VALUE-CHANGED OF ttAf-item-contr.data-entrega IN FRAME fPage1 /* Data Entrega */
DO:
    IF ttAf-item-contr.data-entrega:CHECKED THEN DO:
       RUN piRetornaGrupoAvaliacao IN h-boaf001 (INPUT 4,
                                                 OUTPUT c-cod-grp-respon).

       FIND ttAf-item-contr-form
           WHERE ttAf-item-contr-form.ep-codigo    = i-ep-codigo-usuario
           AND   ttAf-item-contr-form.it-codigo    = INPUT FRAME fPage0 ttAf-item-contr.it-codigo
           AND   ttAf-item-contr-form.cod-emitente = INPUT FRAME fPage0 ttAf-item-contr.cod-emitente
           AND   ttAf-item-contr-form.nr-versao    = INPUT FRAME fPage0 ttAf-item-contr.nr-versao
           AND   ttAf-item-contr-form.nr-controle  = 4
           NO-LOCK NO-ERROR.
       IF NOT AVAIL ttAf-item-contr-form THEN DO:
          FIND LAST ttAf-item-contr-form NO-LOCK NO-ERROR.
          IF AVAIL ttAf-item-contr-form THEN
             ASSIGN iSeq = ttAf-item-contr-form.seq + 10.
          ELSE 
             ASSIGN iSeq = 10.
          CREATE ttAf-item-contr-form.
          ASSIGN ttAf-item-contr-form.ep-codigo    = i-ep-codigo-usuario
                 ttAf-item-contr-form.it-codigo    = INPUT FRAME fPage0 ttAf-item-contr.it-codigo
                 ttAf-item-contr-form.cod-emitente = INPUT FRAME fPage0 ttAf-item-contr.cod-emitente
                 ttAf-item-contr-form.nr-versao    = INPUT FRAME fPage0 ttAf-item-contr.nr-versao
                 ttAf-item-contr-form.nr-controle  = 4
                 ttAf-item-contr-form.percentual   = 0
                 ttAf-item-contr-form.cod-grp-resp = c-cod-grp-respon
                 ttAf-item-contr-form.seq          = iSeq 
                 ttAf-item-contr-form.narrativa    = "".

          run gotokey      IN h-boaf001 (INPUT 4).
          IF  RETURN-VALUE = "ok" THEN do:
              RUN getcharfield IN h-boaf001 (INPUT "cod-grp-resp",
                                             OUTPUT c-cod-grp-resp).
              assign ttAf-item-contr-form.cod-grp-resp = c-cod-grp-resp.
          end.

          {&OPEN-QUERY-{&BROWSE-NAME}}
       END.
    END.  
    ELSE DO:
       FIND ttAf-item-contr-form
           WHERE ttAf-item-contr-form.ep-codigo    = i-ep-codigo-usuario
           AND   ttAf-item-contr-form.it-codigo    = INPUT FRAME fPage0 ttAf-item-contr.it-codigo
           AND   ttAf-item-contr-form.cod-emitente = INPUT FRAME fPage0 ttAf-item-contr.cod-emitente
           AND   ttAf-item-contr-form.nr-versao    = INPUT FRAME fPage0 ttAf-item-contr.nr-versao
           AND   ttAf-item-contr-form.nr-controle  = 4
           NO-LOCK NO-ERROR.
       IF AVAIL ttAf-item-contr-form THEN DO:
          DELETE ttAf-item-contr-form.
          {&OPEN-QUERY-{&BROWSE-NAME}}
       END.
    END.
    run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttAf-item-contr.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.it-codigo wMaintenance
ON F5 OF ttAf-item-contr.it-codigo IN FRAME fpage0 /* Item */
DO:
        /* ZOOM SMART OBJECT */
    {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                       &campo=ttAf-item-contr.it-codigo
                       &campozoom=it-codigo
                       &frame=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.it-codigo wMaintenance
ON LEAVE OF ttAf-item-contr.it-codigo IN FRAME fpage0 /* Item */
DO:
    RUN getDescItem in {&hDBOTable} ( INPUT FRAME fPage0 ttAf-item-contr.it-codigo,
                                      OUTPUT cDesItem ).
    ASSIGN cDescItem:SCREEN-VALUE IN FRAME fPage0 = cDesItem.
    
    FOR EACH ttAf-item-contr-form:
        ASSIGN ttAf-item-contr-form.it-codigo = INPUT FRAME fPage0 ttAf-item-contr.it-codigo.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.it-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttAf-item-contr.it-codigo IN FRAME fpage0 /* Item */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttAf-item-contr.log-considera-qtd-receb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.log-considera-qtd-receb wMaintenance
ON VALUE-CHANGED OF ttAf-item-contr.log-considera-qtd-receb IN FRAME fPage1 /* Considera variaá‰es qtd recebimento */
DO:
    run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAf-item-contr.log-considera-val-receb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.log-considera-val-receb wMaintenance
ON VALUE-CHANGED OF ttAf-item-contr.log-considera-val-receb IN FRAME fPage1 /* Considera variaá‰es valor recebimento */
DO:
    run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttAf-item-contr.nr-versao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.nr-versao wMaintenance
ON F5 OF ttAf-item-contr.nr-versao IN FRAME fpage0 /* N£mero Vers∆o */
DO:
  {method/ZoomFields.i
         &ProgramZoom="afzoom/Z01AF023.w"
         &FieldZoom1="nr-versao"
         &FieldScreen1="ttAf-item-contr.nr-versao"
         &Frame1="fpage0"
         &FieldZoom2="desc-versao"
         &FieldScreen2="cDescVersao"
         &Frame2="fpage0"
         &EnableImplant="yes"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.nr-versao wMaintenance
ON LEAVE OF ttAf-item-contr.nr-versao IN FRAME fpage0 /* N£mero Vers∆o */
DO:
  {method/referencefields.i &HandleDBOLeave="h-boaf023"
                              &KeyValue1="input frame fPage0 ttAf-item-contr.nr-versao"
                              &KeyValue2="ttAf-item-contr.ep-codigo"
                              &FieldName1="desc-versao"
                              &FieldScreen1="cDescVersao"
                              &Frame1="fpage0"}
  
  FOR EACH ttAf-item-contr-form:
      ASSIGN ttAf-item-contr-form.nr-versao = INPUT FRAME fPage0 ttAf-item-contr.nr-versao.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.nr-versao wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttAf-item-contr.nr-versao IN FRAME fpage0 /* N£mero Vers∆o */
DO:
  APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttAf-item-contr.preco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.preco wMaintenance
ON VALUE-CHANGED OF ttAf-item-contr.preco IN FRAME fPage1 /* Preáo */
DO:
  IF ttAf-item-contr.preco:CHECKED THEN DO:
     RUN piRetornaGrupoAvaliacao IN h-boaf001 (INPUT 3,
                                               OUTPUT c-cod-grp-respon).

     FIND ttAf-item-contr-form
         WHERE ttAf-item-contr-form.ep-codigo    = i-ep-codigo-usuario
         AND   ttAf-item-contr-form.it-codigo    = INPUT FRAME fPage0 ttAf-item-contr.it-codigo
         AND   ttAf-item-contr-form.cod-emitente = INPUT FRAME fPage0 ttAf-item-contr.cod-emitente
         AND   ttAf-item-contr-form.nr-versao    = INPUT FRAME fPage0 ttAf-item-contr.nr-versao
         AND   ttAf-item-contr-form.nr-controle  = 3
         NO-LOCK NO-ERROR.
     IF NOT AVAIL ttAf-item-contr-form THEN DO:
        FIND LAST ttAf-item-contr-form NO-LOCK NO-ERROR.
        IF AVAIL ttAf-item-contr-form THEN
           ASSIGN iSeq = ttAf-item-contr-form.seq + 10.
        ELSE 
           ASSIGN iSeq = 10.
        CREATE ttAf-item-contr-form.
        ASSIGN ttAf-item-contr-form.ep-codigo    = i-ep-codigo-usuario
               ttAf-item-contr-form.it-codigo    = INPUT FRAME fPage0 ttAf-item-contr.it-codigo
               ttAf-item-contr-form.cod-emitente = INPUT FRAME fPage0 ttAf-item-contr.cod-emitente
               ttAf-item-contr-form.nr-versao    = INPUT FRAME fPage0 ttAf-item-contr.nr-versao
               ttAf-item-contr-form.nr-controle  = 3
               ttAf-item-contr-form.percentual   = 0
               ttAf-item-contr-form.cod-grp-resp = c-cod-grp-respon
               ttAf-item-contr-form.seq          = iSeq 
               ttAf-item-contr-form.narrativa    = "".

        run gotokey      IN h-boaf001 (INPUT 3).
        IF  RETURN-VALUE = "ok" THEN do:
            RUN getcharfield IN h-boaf001 (INPUT "cod-grp-resp",
                                           OUTPUT c-cod-grp-resp).
            assign ttAf-item-contr-form.cod-grp-resp = c-cod-grp-resp.
        end.

        {&OPEN-QUERY-{&BROWSE-NAME}}
     END.
  END.  
  ELSE DO:
     FIND ttAf-item-contr-form
         WHERE ttAf-item-contr-form.ep-codigo    = i-ep-codigo-usuario
         AND   ttAf-item-contr-form.it-codigo    = INPUT FRAME fPage0 ttAf-item-contr.it-codigo
         AND   ttAf-item-contr-form.cod-emitente = INPUT FRAME fPage0 ttAf-item-contr.cod-emitente
         AND   ttAf-item-contr-form.nr-versao    = INPUT FRAME fPage0 ttAf-item-contr.nr-versao
         AND   ttAf-item-contr-form.nr-controle  = 3
         NO-LOCK NO-ERROR.
     IF AVAIL ttAf-item-contr-form THEN DO:
        DELETE ttAf-item-contr-form.
        {&OPEN-QUERY-{&BROWSE-NAME}}
     END.
  END.  
  run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAf-item-contr.qualidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.qualidade wMaintenance
ON VALUE-CHANGED OF ttAf-item-contr.qualidade IN FRAME fPage1 /* Qualidade */
DO:
  IF ttAf-item-contr.qualidade:CHECKED THEN DO:
     RUN piRetornaGrupoAvaliacao IN h-boaf001 (INPUT 1,
                                               OUTPUT c-cod-grp-respon).

     FIND ttAf-item-contr-form
         WHERE ttAf-item-contr-form.ep-codigo    = i-ep-codigo-usuario
         AND   ttAf-item-contr-form.it-codigo    = INPUT FRAME fPage0 ttAf-item-contr.it-codigo
         AND   ttAf-item-contr-form.cod-emitente = INPUT FRAME fPage0 ttAf-item-contr.cod-emitente
         AND   ttAf-item-contr-form.nr-versao    = INPUT FRAME fPage0 ttAf-item-contr.nr-versao
         AND   ttAf-item-contr-form.nr-controle  = 1
         NO-LOCK NO-ERROR.
     IF NOT AVAIL ttAf-item-contr-form THEN DO:
        FIND LAST ttAf-item-contr-form NO-LOCK NO-ERROR.
        IF AVAIL ttAf-item-contr-form THEN
           ASSIGN iSeq = ttAf-item-contr-form.seq + 10.
        ELSE 
           ASSIGN iSeq = 10.
        CREATE ttAf-item-contr-form.
        ASSIGN ttAf-item-contr-form.ep-codigo    = i-ep-codigo-usuario
               ttAf-item-contr-form.it-codigo    = INPUT FRAME fPage0 ttAf-item-contr.it-codigo
               ttAf-item-contr-form.cod-emitente = INPUT FRAME fPage0 ttAf-item-contr.cod-emitente
               ttAf-item-contr-form.nr-versao    = INPUT FRAME fPage0 ttAf-item-contr.nr-versao
               ttAf-item-contr-form.nr-controle  = 1
               ttAf-item-contr-form.percentual   = 0
               ttAf-item-contr-form.cod-grp-resp = c-cod-grp-respon
               ttAf-item-contr-form.seq          = iSeq 
               ttAf-item-contr-form.narrativa    = "".

        run gotokey      IN h-boaf001 (INPUT 1).
        IF  RETURN-VALUE = "ok" THEN do:
            RUN getcharfield IN h-boaf001 (INPUT "cod-grp-resp",
                                           OUTPUT c-cod-grp-resp).
            assign ttAf-item-contr-form.cod-grp-resp = c-cod-grp-resp.
        end.

        {&OPEN-QUERY-{&BROWSE-NAME}}
     END.
  END.
  ELSE DO:
      FIND ttAf-item-contr-form
          WHERE ttAf-item-contr-form.ep-codigo    = i-ep-codigo-usuario
          AND   ttAf-item-contr-form.it-codigo    = INPUT FRAME fPage0 ttAf-item-contr.it-codigo
          AND   ttAf-item-contr-form.cod-emitente = INPUT FRAME fPage0 ttAf-item-contr.cod-emitente
          AND   ttAf-item-contr-form.nr-versao    = INPUT FRAME fPage0 ttAf-item-contr.nr-versao
          AND   ttAf-item-contr-form.nr-controle  = 1
          NO-LOCK NO-ERROR.
      IF AVAIL ttAf-item-contr-form THEN DO:
         DELETE ttAf-item-contr-form.
      END.
  END.  
  run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAf-item-contr.quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAf-item-contr.quantidade wMaintenance
ON VALUE-CHANGED OF ttAf-item-contr.quantidade IN FRAME fPage1 /* Quantidade */
DO:
  IF ttAf-item-contr.quantidade:CHECKED THEN DO:
     RUN piRetornaGrupoAvaliacao IN h-boaf001 (INPUT 2,
                                               OUTPUT c-cod-grp-respon).

     FIND ttAf-item-contr-form
         WHERE ttAf-item-contr-form.ep-codigo    = i-ep-codigo-usuario
         AND   ttAf-item-contr-form.it-codigo    = INPUT FRAME fPage0 ttAf-item-contr.it-codigo
         AND   ttAf-item-contr-form.cod-emitente = INPUT FRAME fPage0 ttAf-item-contr.cod-emitente
         AND   ttAf-item-contr-form.nr-versao    = INPUT FRAME fPage0 ttAf-item-contr.nr-versao
         AND   ttAf-item-contr-form.nr-controle  = 2
         NO-LOCK NO-ERROR.
     IF NOT AVAIL ttAf-item-contr-form THEN DO:
        FIND LAST ttAf-item-contr-form NO-LOCK NO-ERROR.
        IF AVAIL ttAf-item-contr-form THEN
           ASSIGN iSeq = ttAf-item-contr-form.seq + 10.
        ELSE 
           ASSIGN iSeq = 10.
        CREATE ttAf-item-contr-form.
        ASSIGN ttAf-item-contr-form.ep-codigo    = i-ep-codigo-usuario
               ttAf-item-contr-form.it-codigo    = INPUT FRAME fPage0 ttAf-item-contr.it-codigo
               ttAf-item-contr-form.cod-emitente = INPUT FRAME fPage0 ttAf-item-contr.cod-emitente
               ttAf-item-contr-form.nr-versao    = INPUT FRAME fPage0 ttAf-item-contr.nr-versao
               ttAf-item-contr-form.nr-controle  = 2
               ttAf-item-contr-form.percentual   = 0
               ttAf-item-contr-form.cod-grp-resp = c-cod-grp-respon
               ttAf-item-contr-form.seq          = iSeq 
               ttAf-item-contr-form.narrativa    = "".

        run gotokey      IN h-boaf001 (INPUT 2).
        IF  RETURN-VALUE = "ok" THEN do:
            RUN getcharfield IN h-boaf001 (INPUT "cod-grp-resp",
                                           OUTPUT c-cod-grp-resp).
            assign ttAf-item-contr-form.cod-grp-resp = c-cod-grp-resp.
        end.

        {&OPEN-QUERY-{&BROWSE-NAME}}
     END.
  END.
  ELSE DO:
     FIND ttAf-item-contr-form
         WHERE ttAf-item-contr-form.ep-codigo    = i-ep-codigo-usuario
         AND   ttAf-item-contr-form.it-codigo    = INPUT FRAME fPage0 ttAf-item-contr.it-codigo
         AND   ttAf-item-contr-form.cod-emitente = INPUT FRAME fPage0 ttAf-item-contr.cod-emitente
         AND   ttAf-item-contr-form.nr-versao    = INPUT FRAME fPage0 ttAf-item-contr.nr-versao
         AND   ttAf-item-contr-form.nr-controle  = 2
         NO-LOCK NO-ERROR.
     IF AVAIL ttAf-item-contr-form THEN DO:
        DELETE ttAf-item-contr-form.
        {&OPEN-QUERY-{&BROWSE-NAME}}
     END.
  END.  
  run piHabilitaCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/MainBlock.i}

ttAf-item-contr.it-codigo:load-mouse-pointer("image/lupa.cur":U) in frame fPage0.
ttAf-item-contr.cod-emitente:load-mouse-pointer("image/lupa.cur":U) in frame fPage0.
ttAf-item-contr.nr-versao:load-mouse-pointer("image/lupa.cur":U) in frame fPage0.

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
    
    IF  AVAIL ttAf-item-contr THEN DO:
    
        RUN getDescItem in {&hDBOTable} ( INPUT ttAf-item-contr.it-codigo,
                                          OUTPUT cDesItem ).
    
        ASSIGN cDescItem:SCREEN-VALUE IN FRAME fPage0 = cDesItem.
    
        RUN getNomeEmitente in {&hDBOTable} ( INPUT ttAf-item-contr.cod-emitente,
                                              OUTPUT cNomeEmite ).
    
        ASSIGN cNomeEmitente:SCREEN-VALUE IN FRAME fPage0 = cNomeEmite.

        APPLY "LEAVE":U TO ttAf-item-contr.nr-versao IN FRAME fPage0.
    
        RUN setConstraintForm     IN h-boaf005 (INPUT ttAf-item-contr.it-codigo,
                                                INPUT ttAf-item-contr.cod-emitente,
                                                INPUT ttAf-item-contr.nr-versao).
    
        FOR EACH ttAf-item-contr-form:
            DELETE ttAf-item-contr-form.
        END.
        RUN pi-retorna-temp-table IN h-boaf005 (OUTPUT TABLE ttAf-item-contr-form).
        
        {&OPEN-QUERY-{&BROWSE-NAME}}

    END.

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
    ENABLE btAddSon
           btUpdateSon
           btDeleteSon WITH FRAME fPage2.
    DISABLE ttAf-item-contr.dt-implantacao
            ttAf-item-contr.dt-alter
            ttAf-item-contr.hora-alter
            ttAf-item-contr.usuar-alter
            WITH FRAME fPage1.

    /* mensagem de alerta na alteraá∆o para usar versionamento*/
    IF l-usa-versao AND
       cAction = "UPDATE":U THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show',
                        INPUT 52824,
                        INPUT '').
    END.

    IF AVAIL ttAf-item-contr THEN
        ASSIGN ttAf-item-contr.ep-codigo = v_cdn_empres_usuar WHEN ttAf-item-contr.ep-codigo = "".

    IF NOT l-usa-versao THEN DO:
        DISABLE ttAf-item-contr.nr-versao WITH FRAME fPage0.
        APPLY "leave" TO ttAf-item-contr.nr-versao IN FRAME fPage0.
    END.

    run piHabilitaCampos.


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
    ENABLE brSon2 WITH FRAME fPage2.

    RUN goToKey IN h-boaf022(INPUT 1,
                             INPUT i-ep-codigo-usuario).
    RUN getLogField IN h-boaf022(INPUT "log-usa-versao":U,
                                 OUTPUT l-usa-versao).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenance 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


RUN piRecebeFormula IN {&hDBOTable} (INPUT TABLE ttAf-item-contr-form).    
        
IF AVAIL ttAf-item-contr THEN 
   ASSIGN ttAf-item-contr.ep-codigo = i-ep-codigo-usuario.

IF cAction = "UPDATE":U THEN ASSIGN v-table = ttAf-item-contr.r-rowid.
                      ELSE ASSIGN v-table = ?.
  

RETURN "OK":U.

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
         SIZE 48 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE cItem     LIKE {&ttTable}.it-codigo NO-UNDO.
    DEFINE VARIABLE iEmitente LIKE {&ttTable}.cod-emitente NO-UNDO.
    DEFINE VARIABLE iNrVersao LIKE {&ttTable}.nr-versao    NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        cItem      AT ROW 1.21 COL 17.72 COLON-ALIGNED 
        iEmitente  AT ROW 2.21 COL 17.72 COLON-ALIGNED
        iNrVersao  AT ROW 3.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Item Avaliaá∆o Fornecedores" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cItem iEmitente iNrVersao.
        
        RUN goToKey IN {&hDBOTable} (INPUT i-ep-codigo-usuario, INPUT cItem, INPUT iEmitente, INPUT iNrVersao ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Item_Avaliaá∆o_Fornecedores" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cItem iEmitente iNrVersao btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    ASSIGN cItem:WIDTH      = 20
           iEmitente:WIDTH  = 12
           iNrVersao:WIDTH  = 12
           cItem:HEIGHT     = .88
           iEmitente:HEIGHT = .88
           iNrVersao:HEIGHT = .88.

    IF NOT l-usa-versao THEN DO:
        DISABLE iNrVersao WITH FRAME fGoToRecord.
        ASSIGN iNrVersao = 0.
        DISP iNrVersao WITH FRAME fGoToRecord.
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
       {&hDBOTable}:FILE-NAME <> "afbo/boaf004.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf004.p YES}
        {btb/btb008za.i2 afbo/boaf004.p '' {&hDBOTable}}
    END.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    IF NOT VALID-HANDLE(h-boaf001) OR
       h-boaf001:TYPE <> "PROCEDURE":U OR
       h-boaf001:FILE-NAME <> "afbo/boaf001.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf001.p YES}
        {btb/btb008za.i2 afbo/boaf001.p '' h-boaf001}
    END.
    RUN openQueryStatic IN h-boaf001 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boaf005) OR
       h-boaf005:TYPE <> "PROCEDURE":U OR
       h-boaf005:FILE-NAME <> "afbo/boaf005.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf005.p YES}
        {btb/btb008za.i2 afbo/boaf005.p '' h-boaf005}
    END.
    RUN openQueryStatic IN h-boaf005 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boaf023) OR
       h-boaf023:TYPE <> "PROCEDURE":U OR
       h-boaf023:FILE-NAME <> "afbo/boaf023.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf023.p YES}
        {btb/btb008za.i2 afbo/boaf023.p '' h-boaf023}
    END.
    RUN openQueryStatic IN h-boaf023 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boaf022) OR
       h-boaf022:TYPE <> "PROCEDURE":U OR
       h-boaf022:FILE-NAME <> "afbo/boaf022.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf022.p YES}
        {btb/btb008za.i2 afbo/boaf022.p '' h-boaf022}
    END.
    RUN openQueryStatic IN h-boaf022 (INPUT "Main":U) NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHabilitaCampos wMaintenance 
PROCEDURE piHabilitaCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF input frame fpage1 ttAf-item-contr.qualidade:CHECKED THEN 
   ENABLE ttAf-item-contr.demerito WITH FRAME fPage1.
ELSE 
   DISABLE ttAf-item-contr.demerito WITH FRAME fPage1.

IF input frame fpage1 ttAf-item-contr.data-entrega:CHECKED THEN 
  ENABLE ttAf-item-contr.nr-dia-min
         ttAf-item-contr.nr-dia-max
         WITH FRAME fPage1.
ELSE 
  DISABLE ttAf-item-contr.nr-dia-min
          ttAf-item-contr.nr-dia-max
          WITH FRAME fPage1.

IF input frame fpage1 ttAf-item-contr.quantidade:CHECKED THEN DO:
  ENABLE ttAf-item-contr.log-considera-qtd-receb
         WITH FRAME fPage1.
  IF input frame fpage1 ttAf-item-contr.log-considera-qtd-receb:CHECKED then
       DISABLE ttAf-item-contr.pct-qtd-min
               ttAf-item-contr.pct-qtd-max
               with frame fpage1.
  else
       ENABLE ttAf-item-contr.pct-qtd-min
              ttAf-item-contr.pct-qtd-max
              with frame fpage1.
end.
ELSE 
  DISABLE ttAf-item-contr.log-considera-qtd-receb
          ttAf-item-contr.pct-qtd-min
          ttAf-item-contr.pct-qtd-max
          WITH FRAME fPage1.

IF input frame fpage1 ttAf-item-contr.preco:CHECKED THEN DO:
  ENABLE ttAf-item-contr.log-considera-val-receb
         WITH FRAME fPage1.
  IF input frame fpage1 ttAf-item-contr.log-considera-val-receb:CHECKED then
       DISABLE ttAf-item-contr.pct-val-min
               ttAf-item-contr.pct-val-max
               with frame fpage1.
  else
       ENABLE ttAf-item-contr.pct-val-min
              ttAf-item-contr.pct-val-max
              with frame fpage1.
end.
ELSE 
  DISABLE ttAf-item-contr.log-considera-val-receb
          ttAf-item-contr.pct-val-min
          ttAf-item-contr.pct-val-max
          WITH FRAME fPage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc wMaintenance 
FUNCTION fn-desc RETURNS CHARACTER
  (i-controle AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RUN gotokey      IN h-boaf001 (INPUT i-controle).
  IF RETURN-VALUE = "ok" THEN
     RUN getcharfield IN h-boaf001 (INPUT "descricao",
                                    OUTPUT c-desc).
  ELSE c-desc = "".

  RETURN c-desc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn_periodicidade wMaintenance 
FUNCTION fn_periodicidade RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {afinc/i01af017.i 04 ttAf-item-contr-form.ind-tipo-periodo}. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

