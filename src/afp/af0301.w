&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-af-contr-indice NO-UNDO LIKE af-contr-indice
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttaf-grp-avaliacao-form NO-UNDO LIKE af-grp-avaliacao-form
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttaf-item-contr-estab NO-UNDO LIKE af-item-contr-estab
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0301 2.00.00.012 } /*** "010012" 03/03/2025 09:10:31  ***/
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
&GLOBAL-DEFINE Program        AF0301
&GLOBAL-DEFINE Version        2.00.00.012

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   

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

&GLOBAL-DEFINE ttTable        tt-af-contr-indice
&GLOBAL-DEFINE hDBOTable      h-boaf008
&GLOBAL-DEFINE DBOTable       af-contr-indice

&GLOBAL-DEFINE page0KeyFields tt-af-contr-indice.cod-estabel ~
                              tt-af-contr-indice.cod-emitente ~
                              tt-af-contr-indice.it-codigo ~
                              tt-af-contr-indice.nr-controle ~
                              c-data-indice ~
                              c-dt-indice
&GLOBAL-DEFINE page0Fields    tt-af-contr-indice.indice ~
                              tt-af-contr-indice.narrativa ~
                              tt-af-contr-indice.usuar-alter ~
                              tt-af-contr-indice.dt-implantacao ~
                              tt-af-contr-indice.dt-alter ~
                              tt-af-contr-indice.hora-alter ~
                              tt-af-contr-indice.percentual ~
                              tt-af-contr-indice.nota ~
                              cb-resultado
                              /*c-cod-grp-resp ~
                              c-cod-grp-avaliacao  ~*/


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

{utp/ut-glob.i}
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.

def var c-cod-estabel-old  like {&ttTable}.cod-estabel  no-undo.
def var i-cod-emitente-old like {&ttTable}.cod-emitente no-undo.
def var c-it-codigo-old    like {&tttable}.it-codigo    no-undo.
def var i-nr-controle-old  like {&ttTable}.nr-controle  no-undo.
def var c-dt-indice-old    as char                      no-undo.
def var c-grupo-respons    as char                      no-undo.
def var c-grupo-avaliacao  as char                      no-undo.
DEF VAR i-nr-versao-grp-aval AS INT                     NO-UNDO.
DEFINE VARIABLE l-periodo      AS LOGICAL               NO-UNDO.
DEFINE VARIABLE c-dt-inicial   AS DATE                  NO-UNDO.
DEFINE VARIABLE c-inicial      AS CHAR                  NO-UNDO.
DEFINE VARIABLE cResultados    AS CHARACTER             NO-UNDO.
DEFINE VARIABLE cResultadosIni AS CHARACTER             NO-UNDO.
DEFINE VARIABLE de-indice      LIKE {&tttable}.indice   NO-UNDO.
DEFINE VARIABLE i-cont         AS INTEGER               NO-UNDO.
DEFINE VARIABLE i-num-seq      AS INTEGER               NO-UNDO.
DEFINE VARIABLE i-nr-versao    AS INTEGER               NO-UNDO.

DEFINE VARIABLE l-habilita     AS LOGICAL               NO-UNDO.
DEFINE VARIABLE c-resultados   AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-valor        AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-periodo      AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-periodo-aux  AS CHARACTER             NO-UNDO.


DEFINE VARIABLE h-boaf006      AS HANDLE                NO-UNDO.
DEFINE VARIABLE h-boaf007      AS HANDLE                NO-UNDO.
DEFINE VARIABLE h-boaf018      AS HANDLE                NO-UNDO.
DEFINE VARIABLE h-boaf019      AS HANDLE                NO-UNDO.
DEFINE VARIABLE h-boaf021      AS HANDLE                NO-UNDO.
DEFINE VARIABLE h-boaf023      AS HANDLE                NO-UNDO.

DEFINE VARIABLE d-data-aux     AS DATE                  NO-UNDO.

{afbo/boaf006.i bttAf-item-contr-estab}
{afbo/boaf018.i bttAf-grp-avaliacao-form}

DEFINE TEMP-TABLE tt-versao-data NO-UNDO
    FIELD nr-versao      LIKE af-versao-avaliacao.nr-versao
    FIELD desc-versao    LIKE af-versao-avaliacao.desc-versao
    FIELD ano-avaliacao  LIKE af-versao-avaliacao.ano-avaliacao
    FIELD nr-periodo     LIKE af-versao-avaliacao.nr-periodo
    FIELD data-ini       AS DATE
    FIELD data-fim       AS DATE
    INDEX data-inicial
          data-ini.

DEFINE TEMP-TABLE tt-item-data NO-UNDO LIKE tt-versao-data.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-af-contr-indice.cod-estabel ~
tt-af-contr-indice.cod-emitente tt-af-contr-indice.it-codigo ~
tt-af-contr-indice.nr-controle tt-af-contr-indice.indice ~
tt-af-contr-indice.percentual tt-af-contr-indice.usuar-alter ~
tt-af-contr-indice.nota tt-af-contr-indice.hora-alter ~
tt-af-contr-indice.narrativa 
&Scoped-define ENABLED-TABLES tt-af-contr-indice
&Scoped-define FIRST-ENABLED-TABLE tt-af-contr-indice
&Scoped-Define ENABLED-OBJECTS RECT-29 RECT-3 RECT-4 RECT-46 rtKeys ~
rtKeys-2 rtToolBar btFirst btPrev btNext btLast btGoTo btSearch btAdd ~
btCopy btUpdate btDelete btUndo btCancel btSave btQueryJoins btReportsJoins ~
btExit btHelp c-des-estabelec c-des-emitente c-des-item c-des-controle ~
c-data-indice c-dt-indice i-nr-versao-grp-avaliacao cb-resultado 
&Scoped-Define DISPLAYED-FIELDS tt-af-contr-indice.cod-estabel ~
tt-af-contr-indice.cod-emitente tt-af-contr-indice.it-codigo ~
tt-af-contr-indice.nr-controle tt-af-contr-indice.dt-implantacao ~
tt-af-contr-indice.indice tt-af-contr-indice.dt-alter ~
tt-af-contr-indice.percentual tt-af-contr-indice.usuar-alter ~
tt-af-contr-indice.nota tt-af-contr-indice.hora-alter ~
tt-af-contr-indice.narrativa 
&Scoped-define DISPLAYED-TABLES tt-af-contr-indice
&Scoped-define FIRST-DISPLAYED-TABLE tt-af-contr-indice
&Scoped-Define DISPLAYED-OBJECTS c-des-estabelec c-des-emitente c-des-item ~
c-des-controle c-data-indice c-dt-indice cDescGrupoRespon ~
c-cod-grp-avaliacao i-nr-versao-grp-avaliacao cb-resultado 

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

DEFINE VARIABLE cb-resultado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Resultado" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "item 1" 
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-grp-avaliacao LIKE ttaf-item-contr-estab.cod-grp-avaliacao
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-grp-resp LIKE ttaf-grp-avaliacao-form.cod-grp-resp
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE c-data-indice AS DATE FORMAT "99/99/9999" 
     LABEL "Data ÷ndice" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE c-des-controle AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-emitente AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-estabelec AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-item AS CHARACTER FORMAT "x(60)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .88 NO-UNDO.

DEFINE VARIABLE c-dt-indice AS CHARACTER FORMAT "99/9999" 
     LABEL "Per°odo ÷ndice" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE cDescGrupoRespon AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-versao-grp-avaliacao AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 4.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 4.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 6.08.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 6.08.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


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
     tt-af-contr-indice.cod-estabel AT ROW 3 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-des-estabelec AT ROW 3 COL 24 COLON-ALIGNED NO-LABEL
     tt-af-contr-indice.cod-emitente AT ROW 4 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-des-emitente AT ROW 4 COL 30 NO-LABEL
     tt-af-contr-indice.it-codigo AT ROW 5 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     c-des-item AT ROW 5 COL 34 COLON-ALIGNED NO-LABEL
     tt-af-contr-indice.nr-controle AT ROW 6 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-des-controle AT ROW 6 COL 27 COLON-ALIGNED NO-LABEL
     c-data-indice AT ROW 7 COL 17 COLON-ALIGNED HELP
          "Data do °ndice"
     c-dt-indice AT ROW 7 COL 77 COLON-ALIGNED HELP
          "Data do °ndice"
     c-cod-grp-resp AT ROW 9 COL 17 COLON-ALIGNED HELP
          "" NO-TAB-STOP 
     cDescGrupoRespon AT ROW 9 COL 26.29 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     c-cod-grp-avaliacao AT ROW 9 COL 69.72 COLON-ALIGNED HELP
          "" NO-TAB-STOP 
     i-nr-versao-grp-avaliacao AT ROW 9 COL 80 COLON-ALIGNED NO-LABEL
     cb-resultado AT ROW 10.5 COL 17 COLON-ALIGNED
     tt-af-contr-indice.dt-implantacao AT ROW 10.5 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-contr-indice.indice AT ROW 11.5 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-contr-indice.dt-alter AT ROW 11.5 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-contr-indice.percentual AT ROW 12.5 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-contr-indice.usuar-alter AT ROW 12.5 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-contr-indice.nota AT ROW 13.5 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-contr-indice.hora-alter AT ROW 13.5 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 17.96
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     tt-af-contr-indice.narrativa AT ROW 15 COL 3 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 86 BY 3.5
          FONT 2
     RECT-29 AT ROW 10.25 COL 1
     RECT-3 AT ROW 10.25 COL 50
     RECT-4 AT ROW 14.75 COL 1
     RECT-46 AT ROW 8.75 COL 1
     rtKeys AT ROW 2.67 COL 1
     rtKeys-2 AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 17.96
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-af-contr-indice T "?" NO-UNDO emscda af-contr-indice
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttaf-grp-avaliacao-form T "?" NO-UNDO emscda af-grp-avaliacao-form
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttaf-item-contr-estab T "?" NO-UNDO emscda af-item-contr-estab
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
         HEIGHT             = 17.96
         WIDTH              = 90.29
         MAX-HEIGHT         = 27
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-cod-grp-avaliacao IN FRAME fpage0
   NO-ENABLE LIKE = Temp-Tables.ttaf-item-contr-estab.cod-grp-avaliacao EXP-SIZE */
/* SETTINGS FOR FILL-IN c-cod-grp-resp IN FRAME fpage0
   NO-DISPLAY NO-ENABLE LIKE = Temp-Tables.ttaf-grp-avaliacao-form.cod-grp-resp EXP-SIZE */
/* SETTINGS FOR FILL-IN c-des-emitente IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cDescGrupoRespon IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-af-contr-indice.dt-alter IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-af-contr-indice.dt-implantacao IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
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
    run piSugereCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
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
    run piGravaCampos.
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="afzoom/z01af008.w"}
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
    APPLY "entry" TO tt-af-contr-indice.indice IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-grp-resp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-grp-resp wMaintenance
ON LEAVE OF c-cod-grp-resp IN FRAME fpage0 /* Grupo Respons†vel */
DO:
  
    run getDesGrupoRespon in h-boaf019 ( input frame fPage0 c-cod-grp-resp,
                                         output cDescGrupoRespon ).
    assign cDescGrupoRespon:screen-value in frame fPage0 = cDescGrupoRespon.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-data-indice
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-data-indice wMaintenance
ON LEAVE OF c-data-indice IN FRAME fpage0 /* Data ÷ndice */
DO:
  RUN buscaVersaoData (INPUT 2).
  IF RETURN-VALUE = "OK":U THEN DO:
      RUN piControlaResultado.
      RUN piVerificaPeriodoAvaliacao IN h-boaf007 (input frame fPage0 tt-af-contr-indice.cod-estabel,
                                                   input frame fPage0 tt-af-contr-indice.cod-emitente,
                                                   INPUT i-nr-versao,
                                                   input frame fPage0 tt-af-contr-indice.it-codigo,
                                                   input frame fPage0 tt-af-contr-indice.nr-controle,
                                                   output l-periodo).

      IF NOT l-periodo THEN DO:
          DEFINE VARIABLE dt-indice AS DATE        NO-UNDO.
          DEFINE VARIABLE c-data    AS CHARACTER   NO-UNDO.
          ASSIGN dt-indice = DATE(c-data-indice:SCREEN-VALUE IN FRAME fpage0)
                 c-data = STRING(MONTH(dt-indice), "99") + STRING(YEAR(dt-indice))
                 c-dt-indice:SCREEN-VALUE IN FRAME fpage0 = STRING(c-data,"99/9999")
                 c-data-indice:SCREEN-VALUE IN FRAME fpage0  = ?.
          DISABLE c-data-indice WITH FRAME fpage0.
          ENABLE c-dt-indice WITH FRAME fpage0.
          
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-dt-indice
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-dt-indice wMaintenance
ON LEAVE OF c-dt-indice IN FRAME fpage0 /* Per°odo ÷ndice */
DO:
  RUN buscaVersaoData (INPUT 1).
  IF RETURN-VALUE = "OK":U THEN DO:
      RUN piControlaResultado.
      RUN piVerificaPeriodoAvaliacao IN h-boaf007 (input frame fPage0 tt-af-contr-indice.cod-estabel,
                                                   input frame fPage0 tt-af-contr-indice.cod-emitente,
                                                   INPUT i-nr-versao,
                                                   input frame fPage0 tt-af-contr-indice.it-codigo,
                                                   input frame fPage0 tt-af-contr-indice.nr-controle,
                                                   output l-periodo).


      IF l-periodo THEN DO:
          DEFINE VARIABLE c-data    AS CHARACTER   NO-UNDO.
          ASSIGN c-data =  string("01" + REPLACE(c-dt-indice:SCREEN-VALUE IN FRAME fPage0,"/",""), "xx/xx/xxxx")
                 c-dt-indice:SCREEN-VALUE IN FRAME fpage0 =  ?
                 c-data-indice:SCREEN-VALUE IN FRAME fpage0 = c-data.

          ENABLE c-data-indice WITH FRAME fpage0.
          DISABLE c-dt-indice WITH FRAME fpage0.
          
      END.
  END.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-resultado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-resultado wMaintenance
ON VALUE-CHANGED OF cb-resultado IN FRAME fpage0 /* Resultado */
DO:

    ASSIGN i-num-seq = INT(entry(1, cb-resultado:screen-value in frame fpage0,"-")).
    
    run piRetornaIndice in h-boaf021 ( INPUT FRAME fPage0 tt-af-contr-indice.nr-controle,
                                       INPUT i-num-seq,
                                       OUTPUT de-indice).
    ASSIGN tt-af-contr-indice.indice:SCREEN-VALUE IN FRAME fpage0 = STRING(de-indice).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-contr-indice.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-contr-indice.cod-emitente wMaintenance
ON F5 OF tt-af-contr-indice.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
      /*--- Zoom Smart Object ---*/
    assign l-implanta = yes
        /* input frame fpage0 cb-natureza
           i-natureza = {ininc/i01in295.i 06 cb-natureza}*/.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                       &campo=tt-af-contr-indice.cod-emitente
                       &campozoom=cod-emitente
                       &frame1=fpage0
                       &campo2=c-des-emitente
                       &campozoom2=nome-emit
                       &frame2=fpage0}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-contr-indice.cod-emitente wMaintenance
ON LEAVE OF tt-af-contr-indice.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
  run getDesEmitente in h-boaf008 (input frame fPage0 tt-af-contr-indice.cod-emitente,
                                   output c-des-emitente ).
  assign c-des-emitente:screen-value in frame fPage0 = c-des-emitente.

  APPLY "LEAVE":U TO tt-af-contr-indice.nr-controle IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-contr-indice.cod-emitente wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-af-contr-indice.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-contr-indice.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-contr-indice.cod-estabel wMaintenance
ON F5 OF tt-af-contr-indice.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  /*--- Zoom Smart Object ---*/
    assign l-implanta = yes.  
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=tt-af-contr-indice.cod-estabel
                       &campozoom=cod-estabel
                       &frame1=fpage0
                       &campo2=c-des-estabelec
                       &campozoom2=nome
                       &frame2=fpage0}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-contr-indice.cod-estabel wMaintenance
ON LEAVE OF tt-af-contr-indice.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    run getDesEstabelec in h-boaf008 ( input frame fPage0 tt-af-contr-indice.cod-estabel,
                                       output c-des-estabelec ).

    assign c-des-estabelec:screen-value in frame fPage0 = c-des-estabelec.

    APPLY "LEAVE":U TO tt-af-contr-indice.nr-controle IN FRAME fPage0 .

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-contr-indice.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-af-contr-indice.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-contr-indice.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-contr-indice.it-codigo wMaintenance
ON F5 OF tt-af-contr-indice.it-codigo IN FRAME fpage0 /* Item */
DO:
    /*--- Zoom Smart Object ---*/
    assign l-implanta = yes.
        /* input frame fpage0 cb-natureza
           i-natureza = {ininc/i01in295.i 06 cb-natureza}*/.
    {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                       &campo=tt-af-contr-indice.it-codigo
                       &campozoom=it-codigo
                       &frame1="fPage0"
                       &campo2="c-des-item"
                       &campozoom2="desc-item"
                       &frame2="fPage0"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-contr-indice.it-codigo wMaintenance
ON LEAVE OF tt-af-contr-indice.it-codigo IN FRAME fpage0 /* Item */
DO:
  run getDesitem in h-boaf008 ( input frame fPage0 tt-af-contr-indice.it-codigo,
                                output c-des-item ).
  assign c-des-item:screen-value in frame fPage0 = c-des-item.

  APPLY "LEAVE":U TO tt-af-contr-indice.nr-controle IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-contr-indice.it-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-af-contr-indice.it-codigo IN FRAME fpage0 /* Item */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-contr-indice.nr-controle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-contr-indice.nr-controle wMaintenance
ON F5 OF tt-af-contr-indice.nr-controle IN FRAME fpage0 /* N£mero Controle */
DO:
  {method/zoomfields.i &ProgramZoom="afzoom/z01af001.w"
                       &FieldZoom1="nr-controle"
                       &FieldScreen1="tt-af-contr-indice.nr-controle"
                       &Frame1="fPage0"
                       &FieldZoom2="descricao"
                       &FieldScreen2="c-des-controle"
                       &Frame2="fPage0"
                       &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-contr-indice.nr-controle wMaintenance
ON LEAVE OF tt-af-contr-indice.nr-controle IN FRAME fpage0 /* N£mero Controle */
DO:                                                                                           
/*
     No "leave" do ponto de controle, ser† buscada a vers∆o "v†lida" para a data atual, 
     e esta que ser† utilizada para verificar o tipo do ponto de controle e sugerir a data. 
     Obs.: Caso n∆o exista o ponto de controle com a vers∆o "v†lida" para a data atual utilizar a mais recente que houver.
*/
     RUN buscaVersao(INPUT YES).

     RUN piVerificaPeriodoAvaliacao IN h-boaf007 (input frame fPage0 tt-af-contr-indice.cod-estabel,
                                                  input frame fPage0 tt-af-contr-indice.cod-emitente,
                                                  INPUT i-nr-versao,
                                                  input frame fPage0 tt-af-contr-indice.it-codigo,
                                                  input frame fPage0 tt-af-contr-indice.nr-controle,
                                                  output l-periodo).
     IF l-periodo THEN DO:
         RUN setDataIndice IN h-boaf007 (input frame fPage0 tt-af-contr-indice.cod-estabel,
                                         input frame fPage0 tt-af-contr-indice.cod-emitente,
                                         input i-nr-versao,
                                         input frame fPage0 tt-af-contr-indice.it-codigo,
                                         input frame fPage0 tt-af-contr-indice.nr-controle,
                                         output c-data-indice).

         ASSIGN c-data-indice:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(c-data-indice)
                c-dt-indice:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ?.

         DISABLE c-dt-indice WITH FRAME fpage0.
         ENABLE c-data-indice WITH FRAME fpage0.

     END.
     ELSE DO:
         
         ASSIGN c-dt-indice = ?
                c-dt-indice:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(STRING(MONTH(TODAY),"99") + STRING(YEAR(TODAY)),"99/9999").
         DISABLE c-data-indice WITH FRAME fpage0.
         ENABLE c-dt-indice WITH FRAME fpage0.
     END.

     run getDesControle in h-boaf008 ( input frame fPage0 tt-af-contr-indice.nr-controle,
                                      output c-des-controle ).
     assign c-des-controle:screen-value in frame fPage0 = c-des-controle.

     RUN piRetornaGrupoResponsavel in h-boaf008 (input frame fPage0 tt-af-contr-indice.cod-estabel,
                                                 input frame fPage0 tt-af-contr-indice.cod-emitente,
                                                 input frame fPage0 tt-af-contr-indice.it-codigo,
                                                 input frame fPage0 tt-af-contr-indice.nr-controle,
                                                 output c-grupo-respons).
     assign c-cod-grp-resp:screen-value in frame {&frame-name}= c-grupo-respons.

     run getDesGrupoRespon in h-boaf019 ( input frame fPage0 c-cod-grp-resp,
                                          output cDescGrupoRespon ).
    assign cDescGrupoRespon:screen-value in frame fPage0 = cDescGrupoRespon.

    run piControlaResultado.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-contr-indice.nr-controle wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-af-contr-indice.nr-controle IN FRAME fpage0 /* N£mero Controle */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}
tt-af-contr-indice.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-af-contr-indice.cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-af-contr-indice.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-af-contr-indice.nr-controle:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-boaf008) THEN
        RUN destroy IN h-boaf008.

    IF VALID-HANDLE(h-boaf007) THEN
        RUN destroy IN h-boaf007.

    IF VALID-HANDLE(h-boaf019) THEN
        RUN destroy IN h-boaf019.

    IF VALID-HANDLE(h-boaf021) THEN
        RUN destroy IN h-boaf021.

    IF VALID-HANDLE(h-boaf023) THEN
        RUN destroy IN h-boaf023.

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
if avail tt-af-contr-indice then
    RUN piVerificaPeriodoAvaliacao IN h-boaf007 (input frame fPage0 tt-af-contr-indice.cod-estabel,
                                             input frame fPage0 tt-af-contr-indice.cod-emitente,
                                             INPUT tt-af-contr-indice.nr-versao,
                                             input frame fPage0 tt-af-contr-indice.it-codigo,
                                             input frame fPage0 tt-af-contr-indice.nr-controle,
                                             output l-periodo).
if avail tt-af-contr-indice then do:
   IF l-periodo = NO THEN DO:
       run setDataPeriodo in h-boaf008 (input tt-af-contr-indice.dt-indice).
       run getPeriodo in h-boaf008 (output c-dt-indice).
       assign c-dt-indice:screen-value in frame {&frame-name} = c-dt-indice
              c-data-indice:screen-value in frame {&frame-name} = ?.
   END.
   ELSE DO:

        IF cAction = "ADD":U THEN DO:
            RUN setDataIndice IN h-boaf007 (input frame fPage0 tt-af-contr-indice.cod-estabel,
                                             input frame fPage0 tt-af-contr-indice.cod-emitente,
                                             input i-nr-versao,
                                             input frame fPage0 tt-af-contr-indice.it-codigo,
                                             input frame fPage0 tt-af-contr-indice.nr-controle,
                                             output c-data-indice).

            ASSIGN c-data-indice:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(c-data-indice).
        END.
        ELSE DO:
            ASSIGN c-data-indice:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(tt-af-contr-indice.dt-indice, "99/99/9999").
        END.
        
        ASSIGN c-dt-indice:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ?.

        DISABLE c-dt-indice WITH FRAME fpage0.
   END.
end.

IF NOT VALID-HANDLE(h-boaf023) THEN
    RUN afbo/boaf023.p PERSISTENT SET h-boaf023.
IF NOT VALID-HANDLE(h-boaf006) THEN
    RUN afbo/boaf006.p PERSISTENT SET h-boaf006.

IF INPUT FRAME fPage0 c-dt-indice = "" THEN
  ASSIGN c-periodo-aux = string(TODAY ).
ELSE
    ASSIGN c-periodo-aux = "01" + INPUT FRAME fPage0 c-dt-indice.

ASSIGN /*c-periodo-aux = "01" + INPUT FRAME fPage0 c-dt-indice*/
       c-periodo-aux = STRING(c-periodo-aux,"99/99/9999")
       c-periodo = c-periodo-aux
       c-periodo = STRING(MONTH(DATE(c-periodo))) + "/" + STRING(YEAR(DATE(c-periodo))).

FIND FIRST param-af
    WHERE param-af.ep-codigo = i-ep-codigo-usuario NO-LOCK NO-ERROR.
    
IF AVAIL param-af AND param-af.log-usa-versao THEN DO:
    IF param-af.i-tipo-validade-versao = 1 THEN DO: /* controle de validade conforme utilizacao de versoes */

        RUN piRetornaVersoesData IN h-boaf023(INPUT i-ep-codigo-usuario,
                                              OUTPUT TABLE tt-versao-data).
    END.

    RUN buscaVersao(INPUT NO).

END.

assign c-cod-grp-avaliacao:screen-value in frame {&frame-name}= ""
       i-nr-versao-grp-avaliacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
RUN piRetornaGrupoAvaliacao in h-boaf008 (input frame fPage0 tt-af-contr-indice.cod-estabel,
                                          input frame fPage0 tt-af-contr-indice.cod-emitente,
                                          input i-nr-versao,
                                          input frame fPage0 tt-af-contr-indice.it-codigo,
                                          output c-grupo-avaliacao,
                                          OUTPUT i-nr-versao-grp-aval).
assign c-cod-grp-avaliacao:screen-value in frame {&frame-name}= c-grupo-avaliacao
       i-nr-versao-grp-avaliacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(i-nr-versao-grp-aval).

RUN piRetornaGrupoResponsavel in h-boaf008 (input frame fPage0 tt-af-contr-indice.cod-estabel,
                                            input frame fPage0 tt-af-contr-indice.cod-emitente,
                                            input frame fPage0 tt-af-contr-indice.it-codigo,
                                            input frame fPage0 tt-af-contr-indice.nr-controle,
                                            output c-grupo-respons).
assign c-cod-grp-resp:screen-value in frame {&frame-name}= c-grupo-respons.

run getDesEstabelec in h-boaf008 ( input frame fPage0 tt-af-contr-indice.cod-estabel,
                                   output c-des-estabelec ).
assign c-des-estabelec:screen-value in frame fPage0 = c-des-estabelec.

run getDesEmitente in h-boaf008 ( input frame fPage0 tt-af-contr-indice.cod-emitente,
                                  output c-des-emitente ).
assign c-des-emitente:screen-value in frame fPage0 = c-des-emitente.

run getDesitem in h-boaf008 ( input frame fPage0 tt-af-contr-indice.it-codigo,
                              output c-des-item ).
assign c-des-item:screen-value in frame fPage0 = c-des-item.

run getDesControle in h-boaf008 ( input frame fPage0 tt-af-contr-indice.nr-controle,
                                  output c-des-controle ).
assign c-des-controle:screen-value in frame fPage0 = c-des-controle.

run getDesGrupoRespon in h-boaf019 ( input frame fPage0 c-cod-grp-resp,
                                         output cDescGrupoRespon ).
assign cDescGrupoRespon:screen-value in frame fPage0 = cDescGrupoRespon.

IF AVAIL tt-af-contr-indice THEN DO:

     RUN resultadoPontoControle IN h-boaf008 (INPUT tt-af-contr-indice.cod-estabel,
                                              INPUT tt-af-contr-indice.cod-emitente,
                                              INPUT tt-af-contr-indice.it-codigo,
                                              INPUT tt-af-contr-indice.nr-controle,
                                              INPUT tt-af-contr-indice.dt-indice,
                                              INPUT 2, /* Registro j† existe */
                                              OUTPUT l-habilita,
                                              OUTPUT c-resultados,
                                              OUTPUT c-valor).
    IF c-resultados <> "" THEN DO:
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            ASSIGN cb-resultado:list-item-pairs in frame fpage0 = c-resultados
        &else
            ASSIGN cb-resultado:list-items in frame fpage0 = c-resultados
        &endif
        cb-resultado:screen-value in frame fpage0 = c-valor.
    END.
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

disable tt-af-contr-indice.usuar-alter
        tt-af-contr-indice.dt-implantacao
        tt-af-contr-indice.dt-alter 
        tt-af-contr-indice.hora-alter 
        tt-af-contr-indice.percentual 
        tt-af-contr-indice.nota 
        c-cod-grp-resp 
        c-cod-grp-avaliacao 
        with frame fpage0.

run piControlaResultado.

if tt-af-contr-indice.nr-controle:sensitive in frame fpage0 = no then do:
    IF l-habilita THEN DO:
        apply 'entry' to cb-resultado in frame fpage0.
    END.
    ELSE DO:
        apply 'entry' to tt-af-contr-indice.indice in frame fpage0.
    END.
end.

assign i-num-seq = tt-af-contr-indice.seq-resultado.

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayfields wMaintenance 
PROCEDURE beforeDisplayfields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

assign cb-resultado = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeEnableFields wMaintenance 
PROCEDURE beforeEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenance 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* DEF VAR H-LICENCA AS HANDLE.                  */
/* RUN afp/afapi001.p PERSISTENT SET H-LICENCA.  */
/* delete procedure h-licenca.                   */

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
IF AVAIL tt-af-contr-indice THEN DO:
   ASSIGN tt-af-contr-indice.seq-resultado = i-num-seq
          tt-af-contr-indice.indice  = input frame fPage0 tt-af-contr-indice.indice.

     IF l-periodo THEN
        ASSIGN tt-af-contr-indice.dt-indice = input frame fPage0 c-data-indice.
     ELSE IF cAction <> "UPDATE" THEN
        ASSIGN tt-af-contr-indice.dt-indice = ?.
       
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaVersao wMaintenance 
PROCEDURE buscaVersao :
/*------------------------------------------------------------------------------
  Purpose: Busca a vers∆o correta do relacionamento     
  Parameters: l-use-today: Usa a data de hoje
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER l-use-today AS LOGICAL NO-UNDO.

    DEFINE VARIABLE c-indice             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dt-indice            AS DATE        NO-UNDO.
    DEFINE VARIABLE l-existe-periodo AS LOGICAL INITIAL FALSE NO-UNDO.

    IF l-periodo = NO THEN DO:
        IF l-use-today OR input frame fpage0 c-dt-indice = "" THEN
            ASSIGN c-indice = STRING(month(TODAY), "99") + STRING(YEAR(TODAY), "9999").
        ELSE
            ASSIGN c-indice = input frame fpage0 c-dt-indice NO-ERROR.
    END.
    ELSE DO:
        IF l-use-today OR input frame fpage0 c-dt-indice = "" THEN
            ASSIGN dt-indice = TODAY.
        ELSE
            ASSIGN dt-indice = input frame fpage0 c-data-indice NO-ERROR.
       
        ASSIGN c-indice = STRING(MONTH(dt-indice), "99") + STRING(YEAR(dt-indice), "9999").
    END.

    IF param-af.log-usa-versao THEN DO:
    
        IF param-af.i-tipo-validade-versao = 1 THEN DO: /* controle de validade conforme utilizacao de versoes */

            ASSIGN d-data-aux = date(string("01" + c-indice,"xx/xx/xxxx")).
        
            FOR EACH tt-item-data:
                DELETE tt-item-data.
            END.
        
            RUN piRetornaVersoesData IN h-boaf006(INPUT i-ep-codigo-usuario,
                                                  INPUT INPUT FRAME fPage0 tt-af-contr-indice.it-codigo,
                                                  INPUT INPUT FRAME fPage0 tt-af-contr-indice.cod-emitente,
                                                  INPUT INPUT FRAME fPage0 tt-af-contr-indice.cod-estabel,
                                                  INPUT TABLE tt-versao-data,
                                                  OUTPUT TABLE tt-item-data).
            FOR EACH tt-item-data NO-LOCK:
               IF d-data-aux >= tt-item-data.data-ini AND
                  d-data-aux <= tt-item-data.data-fim THEN DO:
        
                   ASSIGN tt-af-contr-indice.nr-versao = tt-item-data.nr-versao
                          i-nr-versao                  = tt-item-data.nr-versao.
                   LEAVE.
               END.
            END.
        END.
        ELSE DO: /* controle de validade conforme cadastro de versoes */

            RUN piRetornaVersaoPeriodo IN h-boaf023(INPUT  string(c-indice, "99/9999"),
                                                    INPUT  i-ep-codigo-usuario,
                                                    OUTPUT i-nr-versao).

            ASSIGN tt-af-contr-indice.nr-versao = i-nr-versao.

        END.
    END.

    /*
        Busca uma vers∆o v†lida para o ponto de controle.
        Se n∆o existir o ponto de controle para a vers∆o com a data atual,
        busca o ponto com a vers∆o mais recente.
    */
    RUN piVerificaPontoControleExiste IN h-boaf007 (INPUT frame fPage0 tt-af-contr-indice.cod-estabel,
                                                    INPUT frame fPage0 tt-af-contr-indice.cod-emitente,
                                                    INPUT i-nr-versao,
                                                    INPUT frame fPage0 tt-af-contr-indice.it-codigo,
                                                    INPUT frame fPage0 tt-af-contr-indice.nr-controle,
                                                    OUTPUT l-existe-periodo).
											  
    IF l-existe-periodo = FALSE THEN DO:        
        RUN pi-retorna-maior-versao-valida IN h-boaf007 (INPUT frame fPage0 tt-af-contr-indice.it-codigo,
                                                         INPUT frame fPage0 tt-af-contr-indice.cod-estabel,
                                                         INPUT frame fPage0 tt-af-contr-indice.cod-emitente,
                                                         INPUT frame fPage0 tt-af-contr-indice.nr-controle,
                                                         OUTPUT i-nr-versao).

        IF AVAIL tt-af-contr-indice THEN
            ASSIGN tt-af-contr-indice.nr-versao = i-nr-versao.         

    END.

    /* Busca o grupo de avaliaá∆o, pois pode mudar conforme a vers∆o */

    RUN piRetornaGrupoAvaliacao in h-boaf008 (input frame fPage0 tt-af-contr-indice.cod-estabel,
                                              input frame fPage0 tt-af-contr-indice.cod-emitente,
                                              input i-nr-versao,
                                              input frame fPage0 tt-af-contr-indice.it-codigo,
                                              output c-grupo-avaliacao,
                                              OUTPUT i-nr-versao-grp-aval).

    assign c-cod-grp-avaliacao:screen-value in frame {&frame-name}       = c-grupo-avaliacao
           i-nr-versao-grp-avaliacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(i-nr-versao-grp-aval).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaVersaoData wMaintenance 
PROCEDURE buscaVersaoData :
/*------------------------------------------------------------------------------
  Purpose: Busca a vers∆o correta do relacionamento     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-tipo        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-indice             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dt-indice            AS DATE        NO-UNDO.
    DEFINE VARIABLE l-existe-periodo AS LOGICAL INITIAL FALSE NO-UNDO.

    ASSIGN i-nr-versao = ?.
    IF i-tipo = 1 THEN
        ASSIGN c-indice = input frame fpage0 c-dt-indice.
    ELSE DO:
        ASSIGN dt-indice = input frame fpage0 c-data-indice.
        ASSIGN c-indice = STRING(MONTH(dt-indice), "99") + STRING(YEAR(dt-indice)).
    END.

    IF param-af.log-usa-versao THEN DO:
    
        IF param-af.i-tipo-validade-versao = 1 THEN DO: /* controle de validade conforme utilizacao de versoes */

            ASSIGN d-data-aux = date(string("01" + c-indice,"xx/xx/xxxx")).
        
            FOR EACH tt-item-data:
                DELETE tt-item-data.
            END.
        
            RUN piRetornaVersoesData IN h-boaf006(INPUT i-ep-codigo-usuario,
                                                  INPUT INPUT FRAME fPage0 tt-af-contr-indice.it-codigo,
                                                  INPUT INPUT FRAME fPage0 tt-af-contr-indice.cod-emitente,
                                                  INPUT INPUT FRAME fPage0 tt-af-contr-indice.cod-estabel,
                                                  INPUT TABLE tt-versao-data,
                                                  OUTPUT TABLE tt-item-data).
            FOR EACH tt-item-data NO-LOCK:
               IF d-data-aux >= tt-item-data.data-ini AND
                  d-data-aux <= tt-item-data.data-fim THEN DO:
        
                   ASSIGN tt-af-contr-indice.nr-versao = tt-item-data.nr-versao
                          i-nr-versao                  = tt-item-data.nr-versao.
                   LEAVE.
               END.
            END.
        END.
        ELSE DO: /* controle de validade conforme cadastro de versoes */
            RUN piRetornaVersaoPeriodo IN h-boaf023(INPUT  string(c-indice, "99/9999"),
                                                    INPUT  i-ep-codigo-usuario,
                                                    OUTPUT i-nr-versao).
            ASSIGN tt-af-contr-indice.nr-versao = i-nr-versao.

        END.
    END.
    /*
        Busca uma vers∆o v†lida para o ponto de controle.
        Se n∆o existir o ponto de controle para a vers∆o com a data atual,
        busca o ponto com a vers∆o mais recente.
    */
    RUN piVerificaPontoControleExiste IN h-boaf007 (INPUT frame fPage0 tt-af-contr-indice.cod-estabel,
                                              INPUT frame fPage0 tt-af-contr-indice.cod-emitente,
                                              INPUT i-nr-versao,
                                              INPUT frame fPage0 tt-af-contr-indice.it-codigo,
                                              INPUT frame fPage0 tt-af-contr-indice.nr-controle,
                                              OUTPUT l-existe-periodo).

											  
    IF l-existe-periodo = FALSE THEN    
        RETURN "NOK":U.

    /* Busca o grupo de avaliaá∆o, pois pode mudar conforme a vers∆o */

    RUN piRetornaGrupoAvaliacao in h-boaf008 (input frame fPage0 tt-af-contr-indice.cod-estabel,
                                              input frame fPage0 tt-af-contr-indice.cod-emitente,
                                              input i-nr-versao,
                                              input frame fPage0 tt-af-contr-indice.it-codigo,
                                              output c-grupo-avaliacao,
                                              OUTPUT i-nr-versao-grp-aval).

    assign c-cod-grp-avaliacao:screen-value in frame {&frame-name}       = c-grupo-avaliacao
           i-nr-versao-grp-avaliacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(i-nr-versao-grp-aval).

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
         SIZE 40 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-cod-estabel  LIKE {&ttTable}.cod-estabel  NO-UNDO.
    DEFINE VARIABLE i-cod-emitente LIKE {&ttTable}.cod-emitente NO-UNDO.
    DEFINE VARIABLE c-it-codigo    LIKE {&tttable}.it-codigo    NO-UNDO.
    DEFINE VARIABLE i-nr-controle  LIKE {&ttTable}.nr-controle  NO-UNDO.
    DEFINE VARIABLE c-periodo      as char format "99/9999" label "Data ÷ndice" NO-UNDO.
    DEFINE VARIABLE da-dt-indice   as date                      no-undo.
    
   
    DEFINE FRAME fGoToRecord
        c-cod-estabel     AT ROW 1.21 COL 17.72 COLON-ALIGNED
        i-cod-emitente    AT ROW 2.21 COL 17.72 COLON-ALIGNED
        c-it-codigo       AT ROW 3.21 COL 17.72 COLON-ALIGNED
        i-nr-controle     AT ROW 4.21 COL 17.72 COLON-ALIGNED
        c-periodo         AT ROW 5.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 6.63 COL 2.14
        btGoToCancel      AT ROW 6.63 COL 13
        rtGoToButton      AT ROW 6.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para ÷ndice de Ponto de Controle" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    


    assign c-periodo:screen-value in frame fGoToRecord = string(month(today),"99") + string(year(today),"9999").
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-estabel i-cod-emitente c-it-codigo i-nr-controle c-periodo.
        
        run setPeriodo in h-boaf008 (input c-periodo).
        run getDataPeriodo in h-boaf008 (output da-dt-indice).

        RUN goToKey IN {&hDBOTable} (INPUT c-cod-estabel,
                                           i-cod-emitente,
                                           c-it-codigo,
                                           i-nr-controle,
                                           da-dt-indice).

        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "÷ndice_de_Ponto_de_Controle" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-estabel i-cod-emitente c-it-codigo i-nr-controle c-periodo btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 

    ASSIGN c-cod-estabel:HEIGHT  = 0.88
           c-cod-estabel:WIDTH   = 5
           i-cod-emitente:HEIGHT = 0.88
           i-cod-emitente:WIDTH  = 11
           c-it-codigo:HEIGHT    = 0.88
           c-it-codigo:WIDTH     = 20
           i-nr-controle:HEIGHT  = 0.88
           i-nr-controle:WIDTH   = 7
           c-periodo:HEIGHT      = 0.88
           c-periodo:WIDTH       = 9.
    
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
       {&hDBOTable}:FILE-NAME <> "afbo/boaf008.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf008.p YES}
        {btb/btb008za.i2 afbo/boaf008.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boaf007) OR
       h-boaf007:TYPE <> "PROCEDURE":U OR
       h-boaf007:FILE-NAME <> "afbo/boaf007.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf007.p YES}
        {btb/btb008za.i2 afbo/boaf007.p '' h-boaf007}
    END.
    
    RUN openQueryStatic IN h-boaf007 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boaf019) OR
       h-boaf019:TYPE <> "PROCEDURE":U OR
       h-boaf019:FILE-NAME <> "afbo/boaf019.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf019.p YES}
        {btb/btb008za.i2 afbo/boaf019.p '' h-boaf019}
    END.
    
    RUN openQueryStatic IN h-boaf019 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boaf021) OR
       h-boaf021:TYPE <> "PROCEDURE":U OR
       h-boaf021:FILE-NAME <> "afbo/boaf021.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf021.p YES}
        {btb/btb008za.i2 afbo/boaf021.p '' h-boaf021}
    END.
    
    RUN openQueryStatic IN h-boaf021 (INPUT "Main":U) NO-ERROR.
    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piControlaResultado wMaintenance 
PROCEDURE piControlaResultado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN resultadoPontoControle IN h-boaf008 (INPUT input frame fpage0 tt-af-contr-indice.cod-estabel,
                                         INPUT input frame fpage0 tt-af-contr-indice.cod-emitente,
                                         INPUT input frame fpage0 tt-af-contr-indice.it-codigo,
                                         INPUT input frame fpage0 tt-af-contr-indice.nr-controle,
                                         INPUT tt-af-contr-indice.dt-indice, 
                                         input if tt-af-contr-indice.nr-controle:sensitive in frame fpage0 then 1 else 2,
                                         OUTPUT l-habilita,
                                         OUTPUT c-resultados,
                                         OUTPUT c-valor).

IF c-resultados <> "" THEN DO:
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        ASSIGN cb-resultado:list-item-pairs in frame fpage0 = c-resultados
               cb-resultado:screen-value in frame fpage0 = c-valor.
    &else
        ASSIGN cb-resultado:list-items in frame fpage0 = c-resultados
               cb-resultado:screen-value in frame fpage0 = c-valor.
    &endif
END.

IF l-habilita THEN DO:
    ENABLE cb-resultado WITH FRAME fpage0.
    DISABLE tt-af-contr-indice.indice WITH FRAME fpage0.    
END.
ELSE DO:
    ENABLE tt-af-contr-indice.indice WITH FRAME fpage0.
    DISABLE cb-resultado WITH FRAME fpage0.    
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGravaCampos wMaintenance 
PROCEDURE piGravaCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if cAction = "Add" or 
   cAction = "Copy" then do:

   IF l-periodo = NO THEN 
        run setPeriodo in h-boaf008 (input input frame fpage0 c-dt-indice).
   
   assign c-cod-estabel-old  = input frame fpage0 {&ttTable}.cod-estabel
          i-cod-emitente-old = input frame fpage0 {&ttTable}.cod-emitente
          c-it-codigo-old    = input frame fpage0 {&tttable}.it-codigo
          i-nr-controle-old  = input frame fpage0 {&ttTable}.nr-controle
          c-dt-indice-old    = IF l-periodo = NO THEN input frame fpage0 c-dt-indice
                               ELSE string(input frame fpage0 c-data-indice).
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSugereCampos wMaintenance 
PROCEDURE piSugereCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
   
   run setdefaults in h-boaf008 (output tt-af-contr-indice.ep-codigo,
                                 output tt-af-contr-indice.dt-indice,
                                 output tt-af-contr-indice.cod-estabel).

   disp tt-af-contr-indice.cod-estabel with frame fpage0.
   run afterDisplayFields.
   if c-cod-estabel-old <> "" then do:
       assign {&ttTable}.cod-estabel:screen-value in frame fpage0 = c-cod-estabel-old
              {&ttTable}.cod-emitente:screen-value in frame fpage0 = string(i-cod-emitente-old)
              {&tttable}.it-codigo:screen-value in frame fpage0 = c-it-codigo-old
              {&ttTable}.nr-controle:screen-value in frame fpage0 = string(i-nr-controle-old).
     
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

