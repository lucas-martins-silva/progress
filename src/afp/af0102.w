&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-af-controle NO-UNDO LIKE af-controle
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-af-controle-result NO-UNDO LIKE af-controle-result
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
{include/i-prgvrs.i AF0102 2.00.00.010 } /*** "010010" ***/
/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AF0102 MAF}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AF0102
&GLOBAL-DEFINE Version        2.00.00.010

&GLOBAL-DEFINE Folder         yes
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Principal,Resultado, Narrativa

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

&GLOBAL-DEFINE ttTable        tt-af-controle
&GLOBAL-DEFINE hDBOTable      h-boaf001
&GLOBAL-DEFINE DBOTable       af-controle

&GLOBAL-DEFINE page0KeyFields tt-af-controle.nr-controle 
&GLOBAL-DEFINE page0Fields    tt-af-controle.descricao
&GLOBAL-DEFINE page1Fields    tt-af-controle.log-especifico tt-af-controle.programa ~
                              tt-af-controle.dt-implantacao tt-af-controle.dt-alter tt-af-controle.usuar-alter ~
                              tt-af-controle.hora-alter tt-af-controle.padrao tt-af-controle.log-formula ~
                              tt-af-controle.cod-formula c-desc-form tt-af-controle.cod-grp-resp ~
                              l-log-per-variavel cb-periodicidade
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    tt-af-controle.narrativa

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{utp/ut-glob.i}
DEFINE VARIABLE h-boaf019      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf008      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf021      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf022      AS HANDLE NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOaf013      AS HANDLE NO-UNDO.

DEFINE VARIABLE l-habilita       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE iRetorno         AS INTEGER   NO-UNDO.
DEFINE VARIABLE cType            AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-seq-resultado  AS INTEGER NO-UNDO.
DEFINE VARIABLE i-nr-controle-aux AS INTEGER     NO-UNDO.

DEF TEMP-TABLE tt-Af-controle-result-aux NO-UNDO LIKE tt-af-controle-result.
DEF TEMP-TABLE tt-Af-controle-result-delete NO-UNDO LIKE tt-af-controle-result.

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
&Scoped-define INTERNAL-TABLES tt-af-controle-result

/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-af-controle-result.seq-resultado ~
tt-af-controle-result.descricao tt-af-controle-result.indice ~
tt-af-controle-result.log-justificativa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-af-controle-result NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH tt-af-controle-result NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-af-controle-result
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-af-controle-result


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-af-controle.nr-controle ~
tt-af-controle.descricao 
&Scoped-define ENABLED-TABLES tt-af-controle
&Scoped-define FIRST-ENABLED-TABLE tt-af-controle
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-af-controle.nr-controle ~
tt-af-controle.descricao 
&Scoped-define DISPLAYED-TABLES tt-af-controle
&Scoped-define FIRST-DISPLAYED-TABLE tt-af-controle


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

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 1.67.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-programa 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btn-detalhar 
     LABEL "Detalhar" 
     SIZE 12 BY 1.

DEFINE VARIABLE cb-periodicidade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Periodicidade" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-des-grp-resp AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 50.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-form AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.57 BY 5.79.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.57 BY 2.21.

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.57 BY 2.21.

DEFINE VARIABLE l-log-per-variavel AS LOGICAL INITIAL no 
     LABEL "Utiliza Per°odo Avaliaá∆o Vari†vel" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.14 BY .83 NO-UNDO.

DEFINE BUTTON btAddSon 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 10.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon2 FOR 
      tt-af-controle-result SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMaintenance _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      tt-af-controle-result.seq-resultado FORMAT ">>9":U
      tt-af-controle-result.descricao FORMAT "x(30)":U
      tt-af-controle-result.indice FORMAT ">>9.9999":U
      tt-af-controle-result.log-justificativa COLUMN-LABEL "Justif. Obrig" FORMAT "Sim/N∆o":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.5
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
     tt-af-controle.nr-controle AT ROW 3.08 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-af-controle.descricao AT ROW 3.08 COL 26.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 43 BY .88
     rtKeys AT ROW 2.58 COL 1.57
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.25 COL 2
     btAddSon AT ROW 9.75 COL 2
     btUpdateSon AT ROW 9.75 COL 12
     btDeleteSon AT ROW 9.75 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.5
         SIZE 84.43 BY 10.75
         FONT 1.

DEFINE FRAME fPage1
     tt-af-controle.padrao AT ROW 1.29 COL 16
          VIEW-AS TOGGLE-BOX
          SIZE 14.43 BY .71
     tt-af-controle.log-formula AT ROW 2.04 COL 16
          VIEW-AS TOGGLE-BOX
          SIZE 13.29 BY .71
     btn-detalhar AT ROW 2.75 COL 68
     tt-af-controle.cod-formula AT ROW 2.83 COL 14.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-form AT ROW 2.83 COL 22.57 COLON-ALIGNED NO-LABEL
     tt-af-controle.cod-grp-resp AT ROW 3.83 COL 14.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     c-des-grp-resp AT ROW 3.83 COL 27.57 COLON-ALIGNED NO-LABEL
     tt-af-controle.log-especifico AT ROW 4.83 COL 16.14
          VIEW-AS TOGGLE-BOX
          SIZE 10.86 BY .88
     bt-programa AT ROW 5.79 COL 80 HELP
          "Escolha do nome do arquivo"
     tt-af-controle.programa AT ROW 5.83 COL 14.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 64 BY .88
     l-log-per-variavel AT ROW 7.5 COL 16.14
     cb-periodicidade AT ROW 7.5 COL 49
     tt-af-controle.dt-implantacao AT ROW 9.25 COL 14.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-af-controle.dt-alter AT ROW 9.25 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-af-controle.usuar-alter AT ROW 10.25 COL 14.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-af-controle.hora-alter AT ROW 10.25 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     RECT-40 AT ROW 1.13 COL 1.43
     RECT-41 AT ROW 9.13 COL 1.43
     RECT-42 AT ROW 6.92 COL 1.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 84.43 BY 10.62
         FONT 1.

DEFINE FRAME fPage3
     tt-af-controle.narrativa AT ROW 1.79 COL 14.57 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 57 BY 6
     RECT-43 AT ROW 1.17 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 84.43 BY 10.62
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-af-controle T "?" NO-UNDO emsdca af-controle
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-af-controle-result T "?" NO-UNDO emsdca af-controle-result
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
         HEIGHT             = 17.08
         WIDTH              = 90.57
         MAX-HEIGHT         = 21.21
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.21
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
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN c-des-grp-resp IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-periodicidade IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR TOGGLE-BOX tt-af-controle.log-formula IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.tt-af-controle-result"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.tt-af-controle-result.seq-resultado
     _FldNameList[2]   = Temp-Tables.tt-af-controle-result.descricao
     _FldNameList[3]   = Temp-Tables.tt-af-controle-result.indice
     _FldNameList[4]   > Temp-Tables.tt-af-controle-result.log-justificativa
"tt-af-controle-result.log-justificativa" "Justif. Obrig" ? "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-programa wMaintenance
ON CHOOSE OF bt-programa IN FRAME fPage1
DO:
    def var c-programa  as char no-undo.
    def var l-ok        as log  no-undo.

    assign c-programa = input frame fpage1 tt-af-controle.programa.

    assign c-programa = replace(c-programa, "/", "~\").

    SYSTEM-DIALOG GET-FILE programa
       FILTERS "*.p" "*.p",
               "*.*" "*.*"         
       DEFAULT-EXTENSION "p"
       INITIAL-DIR "spool" 
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then do:
        assign tt-af-controle.programa:screen-value in frame fpage1 = replace(c-programa, "~\", "/").
        display tt-af-controle.programa with frame fpage1.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    ASSIGN i-nr-controle-aux = int(tt-af-controle.nr-controle:SCREEN-VALUE IN FRAME {&FRAME-NAME}). 
    RUN addRecord IN THIS-PROCEDURE.
    run piSugereControle.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon wMaintenance
ON CHOOSE OF btAddSon IN FRAME fPage2 /* Incluir */
DO:

    
    RUN piValidaInclusao IN h-boaf021 (INPUT FRAME fPage0 tt-af-controle.nr-controle).


    IF RETURN-VALUE = "NOK" THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-tabela-de-resultados AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Tabela_de_resultados" *}
        ASSIGN c-lbl-liter-tabela-de-resultados = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-apenas-pode-ser-utilizada-para AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Apenas_pode_ser_utilizada_para_pontos_de_controles_manuais" *}
        ASSIGN c-lbl-liter-apenas-pode-ser-utilizada-para = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 52856,
                           INPUT c-lbl-liter-tabela-de-resultados + "~~" + c-lbl-liter-apenas-pode-ser-utilizada-para ).
        RETURN.
    END.

    FOR EACH tt-af-controle-result-aux:
        DELETE tt-af-controle-result-aux.
    END.

    FIND LAST tt-af-controle-result NO-LOCK NO-ERROR.
    IF AVAIL tt-af-controle-result THEN DO:
        ASSIGN i-seq-resultado = tt-af-controle-result.seq-resultado.
    END.
    ELSE
        ASSIGN i-seq-resultado = 0.

    RUN afp/af0102a.w ( INPUT 1,
                        INPUT FRAME fPage0 tt-af-controle.nr-controle,
                        INPUT FRAME fPage0 tt-af-controle.descricao,
                        INPUT i-seq-resultado,
                        INPUT THIS-PROCEDURE,
                        INPUT-OUTPUT TABLE tt-af-controle-result-aux). 
    
    {&OPEN-QUERY-{&BROWSE-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN goToKey IN {&hDBOTable} (INPUT i-nr-controle-aux).
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
    ASSIGN i-nr-controle-aux = int(tt-af-controle.nr-controle:SCREEN-VALUE IN FRAME {&FRAME-NAME}). 
    RUN copyRecord IN THIS-PROCEDURE.
    run piSugereControle.
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
    
    IF AVAIL tt-af-controle-result THEN DO:
        ASSIGN cType = "Delete".
        IF NOT CAN-FIND(tt-Af-controle-result-delete
                        WHERE tt-Af-controle-result-delete.seq-resultado = tt-Af-controle-result.seq-resultado) THEN DO:
            CREATE tt-Af-controle-result-delete.
            BUFFER-COPY tt-Af-controle-result TO tt-Af-controle-result-delete.
        END.
        DELETE tt-af-controle-result.
        {&OPEN-QUERY-{&BROWSE-NAME}}  
    END.

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
&Scoped-define SELF-NAME btn-detalhar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-detalhar wMaintenance
ON CHOOSE OF btn-detalhar IN FRAME fPage1 /* Detalhar */
DO:
  DEFINE VARIABLE hProgram          AS HANDLE NO-UNDO.
  /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).
    {&WINDOW-NAME}:SENSITIVE = NO.

  RUN afp/af0102b.w PERSISTENT SET hProgram (INPUT INPUT FRAME fPage1 tt-af-controle.cod-formula, 
                                             INPUT INPUT FRAME fPage1 c-desc-form).
    
   /** Validaªío do Handle **/
   IF  VALID-HANDLE(hProgram) AND
       hProgram:TYPE = "PROCEDURE":U AND
       hProgram:FILE-NAME = "afp/af0102b.w":U THEN DO:
       /*--- Inicializa programa de alteraªío dos par≥metros ---*/
       RUN initializeInterface IN hProgram. 
   END.
    
    /** Espera pelo fechamento do programa **/
    WAIT-FOR "CLOSE":U of hProgram.
    IF  VALID-HANDLE(hProgram) THEN
        DELETE PROCEDURE hProgram.
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
    RUN goToKey IN {&hDBOTable} (INPUT tt-af-controle.nr-controle).
    RUN saveRecord IN THIS-PROCEDURE.

    IF RETURN-VALUE <> "NOK":U THEN
       DISABLE btAddSon
               btUpdateSon
               btDeleteSon WITH FRAME fPage2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="afzoom/z01af001.w"}
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
    ASSIGN i-nr-controle-aux = int(tt-af-controle.nr-controle:SCREEN-VALUE IN FRAME {&FRAME-NAME}). 
    RUN UpdateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btUpdateSon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon wMaintenance
ON CHOOSE OF btUpdateSon IN FRAME fPage2 /* Alterar */
DO:
    RUN piValidaInclusao IN h-boaf021 (INPUT FRAME fPage0 tt-af-controle.nr-controle).
    IF RETURN-VALUE = "NOK" THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-tabela-de-resultados-nao-pode AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Tabela_de_resultados_n∆o_pode_ser_informada" *}
        ASSIGN c-lbl-liter-tabela-de-resultados-nao-pode = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-tabela-de-resultados-pode-ser AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Tabela_de_resultados_pode_ser_utilizada_apenas_para_pontos_de_controle_manuais" *}
        ASSIGN c-lbl-liter-tabela-de-resultados-pode-ser = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT c-lbl-liter-tabela-de-resultados-nao-pode + "." + "~~" + c-lbl-liter-tabela-de-resultados-pode-ser + "!" ).
        RETURN.
    END.

    IF AVAIL tt-af-controle-result THEN DO:
        RUN afp/af0102a.w ( INPUT 2,
                            INPUT FRAME fPage0 tt-af-controle.nr-controle,
                            INPUT FRAME fPage0 tt-af-controle.descricao,
                            INPUT BROWSE brSon2 tt-af-controle-result.seq-resultado,  
                            INPUT THIS-PROCEDURE,
                            INPUT-OUTPUT TABLE tt-af-controle-result).   
        {&OPEN-QUERY-{&BROWSE-NAME}}
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-periodicidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-periodicidade wMaintenance
ON VALUE-CHANGED OF cb-periodicidade IN FRAME fPage1 /* Periodicidade */
DO:
    
    /*if  input frame fPage1 tt-af-controle.dt-ult-aval <> ? then do:
    
        case {afinc/i01af017.i 06 cb-periodicidade:screen-value in frame fpage1}:
    
            when 1 then  /* mensal */
                run piSetaDtProxAval in h-boaf008 (input frame fPage1 tt-af-controle.dt-ult-aval,
                                                   input 1,
                                                   output da-prox-aval).
            when 2 then /* bimestral */
                run piSetaDtProxAval in h-boaf008 (input frame fPage1 tt-af-controle.dt-ult-aval,
                                                   input 2,
                                                   output da-prox-aval).
            when 3 then /*trimestral */
                run piSetaDtProxAval in h-boaf008 (input frame fPage1 tt-af-controle.dt-ult-aval,
                                                   input 3,
                                                   output da-prox-aval).
            when 4 then /*semestral */
                run piSetaDtProxAval in h-boaf008 (input frame fPage1 tt-af-controle.dt-ult-aval,
                                                   input 6,
                                                   output da-prox-aval).
            when 5 then /*anual*/
                run piSetaDtProxAval in h-boaf008 (input frame fPage1 tt-af-controle.dt-ult-aval,
                                                   input 12,
                                                   output da-prox-aval).
        end case.
        assign dt-prox-aval = da-prox-aval.
    end.
    else
        assign dt-prox-aval = today.

    disp dt-prox-aval with frame fpage1.*/
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-controle.cod-formula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-controle.cod-formula wMaintenance
ON F5 OF tt-af-controle.cod-formula IN FRAME fPage1 /* F¢rmula */
DO:
    DEFINE VARIABLE l-usa-versao AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-usa-formula AS LOGICAL     NO-UNDO.

    RUN getLogField IN h-boaf022 (INPUT "log-usa-versao":U, OUTPUT l-usa-versao).
    RUN getLogField IN h-boaf022 (INPUT "log-versao-formula":U, OUTPUT l-usa-formula).

    IF l-usa-versao = TRUE AND l-usa-formula THEN DO:
        {method/zoomfields.i &ProgramZoom="afzoom/z02af013.w"
                       &FieldZoom1="Cod-Formula"
                       &FieldScreen1="tt-af-controle.cod-formula"
                       &Frame1="fpage1"
                       &EnableImplant="no"}

    END.
    ELSE DO:
        {method/zoomfields.i &ProgramZoom="afzoom/z01af013.w"
                       &FieldZoom1="Cod-Formula"
                       &FieldScreen1="tt-af-controle.cod-formula"
                       &Frame1="fpage1"
                       &EnableImplant="no"}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-controle.cod-formula wMaintenance
ON LEAVE OF tt-af-controle.cod-formula IN FRAME fPage1 /* F¢rmula */
DO:
    
    
    RUN pi-retorna-primeiro-registro IN hDBOaf013 (INPUT i-ep-codigo-usuario,
                                   INPUT tt-af-controle.cod-formula:SCREEN-VALUE IN FRAME fpage1).

    IF RETURN-VALUE = "OK":U THEN
       RUN getcharfield IN hDBOaf013 (INPUT "descricao",
                                      OUTPUT c-desc-form).
    ELSE c-desc-form = "".

    DISP c-desc-form WITH FRAME fpage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-controle.cod-formula wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-af-controle.cod-formula IN FRAME fPage1 /* F¢rmula */
DO:
    APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-controle.cod-grp-resp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-controle.cod-grp-resp wMaintenance
ON F5 OF tt-af-controle.cod-grp-resp IN FRAME fPage1 /* Grupo Respons†vel */
DO:
    {method/zoomfields.i &ProgramZoom="afzoom/z01af019.w"
                         &FieldZoom1="cod-grp-resp"
                         &FieldScreen1="tt-af-controle.cod-grp-resp"
                         &Frame1="fpage1"
                         &FieldZoom2="des-grp-resp"
                         &FieldScreen2="c-des-grp-resp"
                         &Frame2="fpage1"                         
                         &EnableImplant="no"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-controle.cod-grp-resp wMaintenance
ON LEAVE OF tt-af-controle.cod-grp-resp IN FRAME fPage1 /* Grupo Respons†vel */
DO:
  
    {method/referencefields.i &HandleDBOLeave="h-boaf019"
                              &KeyValue1="input frame fpage1 tt-af-controle.cod-grp-resp"
                              &FieldName1="des-grp-resp"
                              &FieldScreen1="c-des-grp-resp"
                              &Frame1="fpage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-controle.cod-grp-resp wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-af-controle.cod-grp-resp IN FRAME fPage1 /* Grupo Respons†vel */
DO:
    apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-log-per-variavel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-log-per-variavel wMaintenance
ON VALUE-CHANGED OF l-log-per-variavel IN FRAME fPage1 /* Utiliza Per°odo Avaliaá∆o Vari†vel */
DO:
  
    if  l-log-per-variavel:checked in frame fPage1 then 
        assign cb-periodicidade:sensitive            in frame fPage1 = yes.
    else
        assign cb-periodicidade:sensitive            in frame fPage1 = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-controle.log-especifico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-controle.log-especifico wMaintenance
ON VALUE-CHANGED OF tt-af-controle.log-especifico IN FRAME fPage1 /* Espec°fico */
DO:
  run habilitaEspecifico.
  RUN habilitaPeriodoAvaliacao.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-af-controle.log-formula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-controle.log-formula wMaintenance
ON VALUE-CHANGED OF tt-af-controle.log-formula IN FRAME fPage1 /* Utiliza F¢rmula */
DO:
     RUN habilitaFormula.
     RUN habilitaPeriodoAvaliacao.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-af-controle.nr-controle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-controle.nr-controle wMaintenance
ON LEAVE OF tt-af-controle.nr-controle IN FRAME fpage0 /* N£mero Controle */
DO:
  run habilitaEspecifico.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-af-controle.padrao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-controle.padrao wMaintenance
ON VALUE-CHANGED OF tt-af-controle.padrao IN FRAME fPage1 /* Controle Padr∆o */
DO:
  
     RUN habilitaPeriodoAvaliacao.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*--- L¢gica para inicializaá∆o do programam ---*/

assign cb-periodicidade:list-items in frame fPage1 = {afinc/i01af017.i 03} no-error.
{maintenance/mainblock.i}

tt-af-controle.cod-formula:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fpage1.
tt-af-controle.cod-grp-resp:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fpage1.

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

    /*IF VALID-HANDLE(h-boaf001) THEN
        RUN destroy IN h-boaf001.*/

    if  valid-handle (h-boaf008) then do:
        delete procedure h-boaf008.
        assign h-boaf008 = ?.
    end.

    if  valid-handle (h-boaf021) then do:
        delete procedure h-boaf021.
        assign h-boaf021 = ?.
    end.

    IF VALID-HANDLE(h-boaf022) THEN DO:
        DELETE PROCEDURE h-boaf022.
        ASSIGN h-boaf022 = ?.
    END.

    RETURN "OK".

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

    IF AVAIL tt-af-controle THEN DO:
        RUN pi-retorna-primeiro-registro IN hDBOaf013 (INPUT i-ep-codigo-usuario,
                                                       INPUT tt-af-controle.cod-formula:SCREEN-VALUE IN FRAME fpage1).
        
        IF RETURN-VALUE = "ok" THEN
           RUN getcharfield IN hDBOaf013 (INPUT "descricao",
                                          OUTPUT c-desc-form).
        ELSE c-desc-form = "".
        
        DISP c-desc-form WITH FRAME fpage1.  
        
        assign l-log-per-variavel:checked in frame fPage1 = tt-af-controle.log-per-variavel.
        assign cb-periodicidade:screen-value in frame fPage1 = {afinc/i01af017.i 04 tt-af-controle.ind-tipo-periodo}.
        
        APPLY "LEAVE" TO tt-af-controle.nr-controle  IN FRAME fpage0.
        APPLY "LEAVE" TO tt-af-controle.cod-grp-resp IN FRAME fpage1.
    
        IF VALID-HANDLE(h-boaf021) THEN DO:
            RUN setConstraintNrControle IN h-boaf021 (INPUT tt-af-controle.nr-controle).
            RUN openQueryStatic IN h-boaf021 (INPUT "NrControle":U).
            RUN getBatchRecords IN h-boaf021 (INPUT ?,
                                              INPUT NO,
                                              INPUT 9999,
                                              OUTPUT iRetorno,
                                              OUTPUT TABLE tt-af-controle-result).
             {&OPEN-QUERY-{&BROWSE-NAME}}
        END.

    END.

    RETURN "OK".

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
           btDeleteSon 
           brSon2  WITH FRAME fPage2.
   
    run habilitaEspecifico.
    RUN habilitaFormula.
    RUN habilitaPeriodoAvaliacao.
    
    
    IF tt-af-controle.padrao THEN 
        DISABLE tt-Af-controle.descricao WITH FRAME fpage0.

    DISABLE tt-Af-controle.dt-implantacao
            tt-Af-controle.dt-alter
            tt-Af-controle.hora-alter
            tt-Af-controle.usuar-alter
            tt-Af-controle.padrao
            c-desc-form
            WITH FRAME fpage1.

    RUN piHabilitaPeriodoAvaliacao IN h-boaf001 (INPUT FRAME fPage0 tt-af-controle.nr-controle,
                                                 OUTPUT l-habilita).

    IF l-habilita THEN
        ENABLE l-log-per-variavel WITH FRAME fpage1.
    ELSE
        DISABLE l-log-per-variavel WITH FRAME fpage1.

    apply "value-changed" to l-log-per-variavel  in frame fPage1.

    RETURN "OK".

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
    
    IF VALID-HANDLE({&hDBOTable}) THEN DO:
        RUN getRowErrors in {&hDBOTable} (OUTPUT TABLE RowErrors).
    END.

    IF CAN-FIND (FIRST RowErrors NO-LOCK
                 WHERE RowErrors.ErrorSubType = "Error") THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Vers‰es" *}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 4610, INPUT RETURN-VALUE).
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.

    DEFINE VARIABLE l-usa-versao AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-usa-formula AS LOGICAL     NO-UNDO.

    RUN getLogField IN h-boaf022 (INPUT "log-usa-versao":U, OUTPUT l-usa-versao).
    RUN getLogField IN h-boaf022 (INPUT "log-versao-formula":U, OUTPUT l-usa-formula).


    IF l-usa-versao = TRUE AND l-usa-formula THEN DO:
        ENABLE btn-detalhar
            WITH FRAME fpage1.
    END.
    ELSE DO:
        DISABLE btn-detalhar
            WITH FRAME fpage1.
    END.    

    apply "LEAVE" to tt-af-controle.cod-grp-resp in frame fpage1.
    
    return "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenance 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign tt-af-controle.log-per-variavel = l-log-per-variavel:checked in frame fPage1
           tt-af-controle.ind-tipo-periodo = {afinc/i01af017.i 06 cb-periodicidade:screen-value in frame fPage1}.

    return "OK".
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenance 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE(h-boaf021)               
    OR h-boaf021:TYPE      <> "PROCEDURE":U      
    OR h-boaf021:FILE-NAME <> "afbo/boaf021.p":U THEN DO:
       RUN afbo/boaf021.p PERSISTENT SET h-boaf021.
    END.

    
    FOR EACH tt-af-controle-result NO-LOCK :
         RUN piGravaNrControle IN h-boaf021 (INPUT tt-af-controle-result.nr-controle,
                                             INPUT tt-af-controle-result.seq-resultado,
                                             INPUT tt-af-controle-result.descricao,
                                             INPUT tt-af-controle-result.indice,
                                             INPUT tt-af-controle-result.log-justificativa). 
    END. 

    IF cType = "Delete" THEN DO:
        FOR EACH tt-Af-controle-result-delete:
            RUN piEliminaResultado IN h-boaf021 (INPUT tt-Af-controle-result-delete.ep-codigo,
                                                 INPUT tt-Af-controle-result-delete.nr-controle,
                                                 INPUT tt-Af-controle-result-delete.seq-resultado).
        END.
        ASSIGN cType = "".
    END.

    RETURN "OK":U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
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
         SIZE 30 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    define variable i-nr-controle like tt-af-controle.nr-controle.
    
    DEFINE FRAME fGoToRecord
        i-nr-controle     AT ROW 1.8 COL 14 COLON-ALIGNED
        btGoToOK        AT ROW 3.6 COL 2.14
        btGoToCancel    AT ROW 3.6 COL 13
        rtGoToButton    AT ROW 3.4 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Ponto de Controle" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    


    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:

        ASSIGN i-nr-controle.

        RUN goToKey IN {&hDBOTable} (INPUT i-nr-controle).

        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Ponto_de_Controle" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-nr-controle
           btGoToOK btGoToCancel 
           WITH FRAME fGoToRecord. 

    ASSIGN i-nr-controle:HEIGHT    = 0.88
           i-nr-controle:WIDTH     = 7.

    WAIT-FOR "GO":U OF FRAME fGoToRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitaEspecifico wMaintenance 
PROCEDURE habilitaEspecifico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    if input frame fpage0 tt-af-controle.descricao:sensitive = no then return.

    if  tt-af-controle.padrao then
        disable tt-af-controle.log-especifico
                tt-af-controle.programa bt-programa
                with frame fpage1.
    else
        enable tt-af-controle.log-especifico
                with frame fpage1.

    if not input frame fpage1 tt-af-controle.log-especifico:checked then
       disable tt-af-controle.programa bt-programa with frame fpage1.
    else DO:
       enable tt-af-controle.programa bt-programa with frame fpage1.
       ASSIGN tt-af-controle.log-formula = NO.
       DISP tt-af-controle.log-formula WITH FRAME fpage1.
       DISABLE tt-af-controle.cod-formula WITH FRAME fpage1.
    END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitaFormula wMaintenance 
PROCEDURE habilitaFormula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if not input frame fpage1 tt-af-controle.log-formula:checked THEN DO:
       disable tt-af-controle.cod-formula with frame fpage1.
       
       ASSIGN tt-af-controle.cod-formula = 0
              c-desc-form                = "".
       DISP tt-af-controle.cod-formula
            c-desc-form
           WITH FRAME fPage1.
              
    END.
    else DO:
       enable tt-af-controle.cod-formula with frame fpage1.
       ASSIGN tt-af-controle.log-especifico = NO.
       DISP tt-af-controle.log-especifico WITH FRAME fpage1.
       DISABLE tt-af-controle.programa WITH FRAME fpage1.

       ASSIGN tt-af-controle.programa = "".
       DISP tt-af-controle.programa WITH FRAME fPage1.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitaPeriodoAvaliacao wMaintenance 
PROCEDURE habilitaPeriodoAvaliacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF  INPUT FRAME fpage1 tt-af-controle.padrao OR 
    INPUT FRAME fpage1 tt-af-controle.log-formula OR 
    INPUT FRAME fpage1 tt-af-controle.log-especifico THEN 
    DISABLE l-log-per-variavel WITH FRAME fpage1.
ELSE 
    ENABLE  l-log-per-variavel WITH FRAME fpage1.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "afbo/boaf001.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf001.p YES}
        {btb/btb008za.i2 afbo/boaf001.p '' {&hDBOTable}} 
    END.

    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.  


    IF NOT VALID-HANDLE(hDBOaf013) OR
       hDBOaf013:TYPE <> "PROCEDURE":U OR
       hDBOaf013:FILE-NAME <> "afbo/boaf013.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf013.p YES}
        {btb/btb008za.i2 afbo/boaf013.p '' hDBOaf013}
    END.

    RUN openQueryStatic IN hDBOaf013 (INPUT "Main":U) NO-ERROR. 


    /*--- Tabela af-grp-responsavel ---*/
    if  not valid-handle(h-boaf019) 
    or  h-boaf019:type <> "PROCEDURE":U 
    or  h-boaf019:file-name <> "afbo/boaf019.p":U then 
        run afbo/boaf019.p persistent set h-boaf019.
 
    run openQueryStatic in h-boaf019 (input "Main":U) no-error. 
 
    /*--- Tabela af-contr-indice ---*/
    if  not valid-handle(h-boaf008) 
    or  h-boaf008:type <> "PROCEDURE":U 
    or  h-boaf008:file-name <> "afbo/boaf008.p":U then 
        run afbo/boaf008.p persistent set h-boaf008.
 
    run openQueryStatic in h-boaf008 (input "Main":U) no-error. 

    /*--- Tabela af-contr-indice ---*/
    if  not valid-handle(h-boaf021) 
    or  h-boaf021:type <> "PROCEDURE":U 
    or  h-boaf021:file-name <> "afbo/boaf021.p":U then 
        run afbo/boaf021.p persistent set h-boaf021.
 
    run openQueryStatic in h-boaf021 (input "Main":U) no-error. 


      if  not valid-handle(h-boaf022) 
        or  h-boaf022:type <> "PROCEDURE":U 
        or  h-boaf022:file-name <> "afbo/boaf022.p":U then 
            run afbo/boaf022.p persistent set h-boaf022.
 
    run openQueryStatic in h-boaf022 (input "Main":U) no-error.    

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSalva wMaintenance 
PROCEDURE piSalva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR tt-Af-controle-result-aux.

FOR EACH tt-Af-controle-result-aux NO-LOCK: 
        FIND FIRST tt-Af-controle-result 
             WHERE tt-Af-controle-result.ep-codigo     = i-ep-codigo-usuario 
               AND tt-Af-controle-result.nr-controle   = tt-Af-controle-result-Aux.nr-controle 
               AND tt-Af-controle-result.seq-resultado = tt-Af-controle-result-Aux.seq-resultado  NO-LOCK NO-ERROR.
        
    IF NOT AVAIL tt-Af-controle-result THEN DO:
        CREATE tt-Af-controle-result.    
        ASSIGN tt-Af-controle-result.ep-codigo         = i-ep-codigo-usuario
               tt-Af-controle-result.nr-controle       = tt-Af-controle-result-Aux.nr-controle
               tt-Af-controle-result.seq-resultado     = tt-Af-controle-result-Aux.seq-resultado
               tt-Af-controle-result.descricao         = tt-Af-controle-result-Aux.descricao
               tt-Af-controle-result.indice            = tt-Af-controle-result-Aux.indice
               tt-Af-controle-result.log-justificativa = tt-Af-controle-result-Aux.log-justificativa.
    
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END.

END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSugereControle wMaintenance 
PROCEDURE piSugereControle :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
   IF AVAIL tt-af-controle THEN DO:
       run setdefaults in h-boaf001 (output tt-af-controle.ep-codigo,
                                     output tt-af-controle.nr-controle).

       disp tt-af-controle.nr-controle with frame fpage0.
    
       RUN habilitaPeriodoAvaliacao.
   END.
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

