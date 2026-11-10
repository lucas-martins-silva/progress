&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-af-periodo-aval NO-UNDO LIKE af-periodo-aval
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
{include/i-prgvrs.i AF0110 2.00.00.006 } /*** 010006 ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AF0110
&GLOBAL-DEFINE Version        2.00.00.006

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0

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

&GLOBAL-DEFINE ttTable        tt-af-periodo-aval
&GLOBAL-DEFINE hDBOTable      h-boaf016
&GLOBAL-DEFINE DBOTable       af-perido-aval

&GLOBAL-DEFINE page0KeyFields ano-avaliacao
&GLOBAL-DEFINE page0Fields    nr-periodos ~
                              dt-periodo-fim ~
                              dt-periodo-ini ~
                              log-fechado ~
                              des-periodo-aval ~
                              narrativa

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf023       AS HANDLE NO-UNDO.
DEFINE VARIABLE h-afapi003      AS HANDLE NO-UNDO.
DEFINE VARIABLE c-acao          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-nr-per-old    AS INTEGER     NO-UNDO.
{afp/afapi002.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-af-periodo-aval.ano-avaliacao ~
tt-af-periodo-aval.nr-periodos tt-af-periodo-aval.dt-periodo-ini[1] ~
tt-af-periodo-aval.dt-periodo-fim[1] tt-af-periodo-aval.des-periodo-aval[1] ~
tt-af-periodo-aval.log-fechado[1] tt-af-periodo-aval.dt-periodo-ini[2] ~
tt-af-periodo-aval.dt-periodo-fim[2] tt-af-periodo-aval.des-periodo-aval[2] ~
tt-af-periodo-aval.log-fechado[2] tt-af-periodo-aval.dt-periodo-ini[3] ~
tt-af-periodo-aval.dt-periodo-fim[3] tt-af-periodo-aval.des-periodo-aval[3] ~
tt-af-periodo-aval.log-fechado[3] tt-af-periodo-aval.dt-periodo-ini[4] ~
tt-af-periodo-aval.dt-periodo-fim[4] tt-af-periodo-aval.des-periodo-aval[4] ~
tt-af-periodo-aval.log-fechado[4] tt-af-periodo-aval.dt-periodo-ini[5] ~
tt-af-periodo-aval.dt-periodo-fim[5] tt-af-periodo-aval.des-periodo-aval[5] ~
tt-af-periodo-aval.log-fechado[5] tt-af-periodo-aval.dt-periodo-ini[6] ~
tt-af-periodo-aval.dt-periodo-fim[6] tt-af-periodo-aval.des-periodo-aval[6] ~
tt-af-periodo-aval.log-fechado[6] tt-af-periodo-aval.dt-periodo-ini[7] ~
tt-af-periodo-aval.dt-periodo-fim[7] tt-af-periodo-aval.des-periodo-aval[7] ~
tt-af-periodo-aval.log-fechado[7] tt-af-periodo-aval.dt-periodo-ini[8] ~
tt-af-periodo-aval.dt-periodo-fim[8] tt-af-periodo-aval.des-periodo-aval[8] ~
tt-af-periodo-aval.log-fechado[8] tt-af-periodo-aval.dt-periodo-ini[9] ~
tt-af-periodo-aval.dt-periodo-fim[9] tt-af-periodo-aval.des-periodo-aval[9] ~
tt-af-periodo-aval.log-fechado[9] tt-af-periodo-aval.dt-periodo-ini[10] ~
tt-af-periodo-aval.dt-periodo-fim[10] ~
tt-af-periodo-aval.des-periodo-aval[10] tt-af-periodo-aval.log-fechado[10] ~
tt-af-periodo-aval.dt-periodo-ini[11] tt-af-periodo-aval.dt-periodo-fim[11] ~
tt-af-periodo-aval.des-periodo-aval[11] tt-af-periodo-aval.log-fechado[11] ~
tt-af-periodo-aval.dt-periodo-ini[12] tt-af-periodo-aval.dt-periodo-fim[12] ~
tt-af-periodo-aval.des-periodo-aval[12] tt-af-periodo-aval.log-fechado[12] ~
tt-af-periodo-aval.narrativa 
&Scoped-define ENABLED-TABLES tt-af-periodo-aval
&Scoped-define FIRST-ENABLED-TABLE tt-af-periodo-aval
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RECT-4 RECT-6 rtKeys ~
rtToolBar btFirst btPrev btNext btLast btGoTo btSearch btAdd btCopy ~
btUpdate btDelete btUndo btCancel btSave btOpenHist btQueryJoins ~
btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-af-periodo-aval.ano-avaliacao ~
tt-af-periodo-aval.nr-periodos tt-af-periodo-aval.dt-periodo-ini[1] ~
tt-af-periodo-aval.dt-periodo-fim[1] tt-af-periodo-aval.des-periodo-aval[1] ~
tt-af-periodo-aval.log-fechado[1] tt-af-periodo-aval.dt-periodo-ini[2] ~
tt-af-periodo-aval.dt-periodo-fim[2] tt-af-periodo-aval.des-periodo-aval[2] ~
tt-af-periodo-aval.log-fechado[2] tt-af-periodo-aval.dt-periodo-ini[3] ~
tt-af-periodo-aval.dt-periodo-fim[3] tt-af-periodo-aval.des-periodo-aval[3] ~
tt-af-periodo-aval.log-fechado[3] tt-af-periodo-aval.dt-periodo-ini[4] ~
tt-af-periodo-aval.dt-periodo-fim[4] tt-af-periodo-aval.des-periodo-aval[4] ~
tt-af-periodo-aval.log-fechado[4] tt-af-periodo-aval.dt-periodo-ini[5] ~
tt-af-periodo-aval.dt-periodo-fim[5] tt-af-periodo-aval.des-periodo-aval[5] ~
tt-af-periodo-aval.log-fechado[5] tt-af-periodo-aval.dt-periodo-ini[6] ~
tt-af-periodo-aval.dt-periodo-fim[6] tt-af-periodo-aval.des-periodo-aval[6] ~
tt-af-periodo-aval.log-fechado[6] tt-af-periodo-aval.dt-periodo-ini[7] ~
tt-af-periodo-aval.dt-periodo-fim[7] tt-af-periodo-aval.des-periodo-aval[7] ~
tt-af-periodo-aval.log-fechado[7] tt-af-periodo-aval.dt-periodo-ini[8] ~
tt-af-periodo-aval.dt-periodo-fim[8] tt-af-periodo-aval.des-periodo-aval[8] ~
tt-af-periodo-aval.log-fechado[8] tt-af-periodo-aval.dt-periodo-ini[9] ~
tt-af-periodo-aval.dt-periodo-fim[9] tt-af-periodo-aval.des-periodo-aval[9] ~
tt-af-periodo-aval.log-fechado[9] tt-af-periodo-aval.dt-periodo-ini[10] ~
tt-af-periodo-aval.dt-periodo-fim[10] ~
tt-af-periodo-aval.des-periodo-aval[10] tt-af-periodo-aval.log-fechado[10] ~
tt-af-periodo-aval.dt-periodo-ini[11] tt-af-periodo-aval.dt-periodo-fim[11] ~
tt-af-periodo-aval.des-periodo-aval[11] tt-af-periodo-aval.log-fechado[11] ~
tt-af-periodo-aval.dt-periodo-ini[12] tt-af-periodo-aval.dt-periodo-fim[12] ~
tt-af-periodo-aval.des-periodo-aval[12] tt-af-periodo-aval.log-fechado[12] ~
tt-af-periodo-aval.narrativa 
&Scoped-define DISPLAYED-TABLES tt-af-periodo-aval
&Scoped-define FIRST-DISPLAYED-TABLE tt-af-periodo-aval


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

DEFINE BUTTON btOpenHist 
     IMAGE-UP FILE "image/toolbar/gr-ger.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/gr-ger.bmp":U
     LABEL "Open History" 
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

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 3.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17 BY 12.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17 BY 12.75.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24 BY 12.75.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27 BY 12.75.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.58.

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
     btOpenHist AT ROW 1.13 COL 70.57
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-af-periodo-aval.ano-avaliacao AT ROW 3 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-af-periodo-aval.nr-periodos AT ROW 3 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     tt-af-periodo-aval.dt-periodo-ini[1] AT ROW 5 COL 3 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.dt-periodo-fim[1] AT ROW 5 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.des-periodo-aval[1] AT ROW 5 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     tt-af-periodo-aval.log-fechado[1] AT ROW 5.25 COL 72
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .71
     tt-af-periodo-aval.dt-periodo-ini[2] AT ROW 6 COL 3 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.dt-periodo-fim[2] AT ROW 6 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.des-periodo-aval[2] AT ROW 6 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     tt-af-periodo-aval.log-fechado[2] AT ROW 6.25 COL 72
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .71
     tt-af-periodo-aval.dt-periodo-ini[3] AT ROW 7 COL 3 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.dt-periodo-fim[3] AT ROW 7 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.des-periodo-aval[3] AT ROW 7 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     tt-af-periodo-aval.log-fechado[3] AT ROW 7.25 COL 72
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .71
     tt-af-periodo-aval.dt-periodo-ini[4] AT ROW 8 COL 3 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.dt-periodo-fim[4] AT ROW 8 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 20.46
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     tt-af-periodo-aval.des-periodo-aval[4] AT ROW 8 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     tt-af-periodo-aval.log-fechado[4] AT ROW 8.25 COL 72
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .71
     tt-af-periodo-aval.dt-periodo-ini[5] AT ROW 9 COL 3 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.dt-periodo-fim[5] AT ROW 9 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.des-periodo-aval[5] AT ROW 9 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     tt-af-periodo-aval.log-fechado[5] AT ROW 9.25 COL 72
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .71
     tt-af-periodo-aval.dt-periodo-ini[6] AT ROW 10 COL 3 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.dt-periodo-fim[6] AT ROW 10 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.des-periodo-aval[6] AT ROW 10 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     tt-af-periodo-aval.log-fechado[6] AT ROW 10.25 COL 72
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .71
     tt-af-periodo-aval.dt-periodo-ini[7] AT ROW 11 COL 3 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.dt-periodo-fim[7] AT ROW 11 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.des-periodo-aval[7] AT ROW 11 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     tt-af-periodo-aval.log-fechado[7] AT ROW 11.25 COL 72
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .71
     tt-af-periodo-aval.dt-periodo-ini[8] AT ROW 12 COL 3 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.dt-periodo-fim[8] AT ROW 12 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.des-periodo-aval[8] AT ROW 12 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     tt-af-periodo-aval.log-fechado[8] AT ROW 12.25 COL 72
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .71
     tt-af-periodo-aval.dt-periodo-ini[9] AT ROW 13 COL 3 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.dt-periodo-fim[9] AT ROW 13 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.des-periodo-aval[9] AT ROW 13 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     tt-af-periodo-aval.log-fechado[9] AT ROW 13.25 COL 72
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .71
     tt-af-periodo-aval.dt-periodo-ini[10] AT ROW 14 COL 3 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 20.46
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     tt-af-periodo-aval.dt-periodo-fim[10] AT ROW 14 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.des-periodo-aval[10] AT ROW 14 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     tt-af-periodo-aval.log-fechado[10] AT ROW 14.25 COL 72
          VIEW-AS TOGGLE-BOX
          SIZE 12.14 BY .71
     tt-af-periodo-aval.dt-periodo-ini[11] AT ROW 15 COL 3 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.dt-periodo-fim[11] AT ROW 15 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.des-periodo-aval[11] AT ROW 15 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     tt-af-periodo-aval.log-fechado[11] AT ROW 15.25 COL 72
          VIEW-AS TOGGLE-BOX
          SIZE 12.14 BY .71
     tt-af-periodo-aval.dt-periodo-ini[12] AT ROW 16 COL 3 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.dt-periodo-fim[12] AT ROW 16 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-af-periodo-aval.des-periodo-aval[12] AT ROW 16 COL 37 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     tt-af-periodo-aval.log-fechado[12] AT ROW 16.25 COL 72
          VIEW-AS TOGGLE-BOX
          SIZE 12.14 BY .71
     tt-af-periodo-aval.narrativa AT ROW 17.75 COL 3 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 86 BY 3.25
     "Situaá∆o" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 4.25 COL 67
     "Per°odo final" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 4.25 COL 21
     "Descriá∆o" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 4.25 COL 39
     "Per°odo in°cial" VIEW-AS TEXT
          SIZE 11 BY .54 AT ROW 4.25 COL 3
     RECT-1 AT ROW 17.5 COL 2
     RECT-2 AT ROW 4.5 COL 2
     RECT-3 AT ROW 4.5 COL 20
     RECT-4 AT ROW 4.5 COL 66
     RECT-6 AT ROW 4.5 COL 38
     rtKeys AT ROW 2.67 COL 2
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 20.46
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-af-periodo-aval T "?" NO-UNDO mgcad af-periodo-aval
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
         HEIGHT             = 20.46
         WIDTH              = 90
         MAX-HEIGHT         = 20.71
         MAX-WIDTH          = 90.14
         VIRTUAL-HEIGHT     = 20.71
         VIRTUAL-WIDTH      = 90.14
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


&Scoped-define SELF-NAME btOpenHist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOpenHist wMaintenance
ON CHOOSE OF btOpenHist IN FRAME fpage0 /* Open History */
DO:
  DEFINE VARIABLE hProgram          AS HANDLE NO-UNDO.
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).
    {&WINDOW-NAME}:SENSITIVE = NO.               

    RUN afp/af0602.w PERSISTENT SET hProgram.

   /** Validaªío do Handle **/
   IF  VALID-HANDLE(hProgram) AND
       hProgram:TYPE = "PROCEDURE":U AND
       hProgram:FILE-NAME = "afp/af0602.w":U THEN DO:
       /*--- Inicializa programa de alteraªío dos par≥metros ---*/
       RUN initializeInterface IN hProgram. 
       /*Passa os parÉmetros para executar a tela*/
       RUN pi-executa-tela IN hProgram(INPUT "af-periodo-aval":U, INPUT STRING(tt-af-periodo-aval.ano-avaliacao)).   
   END.
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
    ASSIGN c-acao = "".
    RUN saveRecord IN THIS-PROCEDURE.

    IF c-acao = "UPDATE":U THEN
        RUN pi-salva-alteracao IN h-afapi003 (INPUT 'af-periodo-aval':U, 
                                              INPUT tt-af-periodo-aval.r-rowid,
                                              INPUT 'AF0110':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomReposition.i &ProgramZoom="afzoom/z01af016.w"}
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


&Scoped-define SELF-NAME tt-af-periodo-aval.nr-periodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-af-periodo-aval.nr-periodos wMaintenance
ON LEAVE OF tt-af-periodo-aval.nr-periodos IN FRAME fpage0 /* Nr Per°odos */
DO:
    RUN pi-habilita-campos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/MainBlock.i}

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

    IF (VALID-HANDLE(h-boaf023) 
        AND h-boaf023:type = "PROCEDURE":U 
        AND h-boaf023:file-name = "afbo/boaf023.p":U ) THEN DO:
        DELETE PROCEDURE h-boaf023.
        ASSIGN h-boaf023 = ?.
    END.

    IF VALID-HANDLE(h-afapi003) THEN DO:
        DELETE PROCEDURE h-afapi003.
        ASSIGN h-afapi003 = ?.
    END.

    RETURN "OK":U.

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
    IF AVAIL tt-af-periodo-aval THEN
        ASSIGN i-nr-per-old = tt-af-periodo-aval.nr-periodos.
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
RUN pi-habilita-campos.

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
ENABLE btOpenHist 
    WITH FRAME {&FRAME-NAME}.

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

/*
    Salva os valores na API antes de salvar a tela para poder salvar o 
    hist¢rico
*/
IF cAction = "UPDATE":U THEN DO:
    ASSIGN c-acao = cAction.
    RUN pi-salva-valor-antigo IN h-afapi003 (INPUT "af-periodo-aval":U, INPUT tt-af-periodo-aval.r-rowid).
END.

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
         SIZE 30 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE i-ano-avaliacao LIKE {&ttTable}.ano-avaliacao NO-UNDO.
   
    DEFINE FRAME fGoToRecord
        i-ano-avaliacao  AT ROW 1.8 COL 14 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Per°odo Avaliaá∆o" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-ano-avaliacao.
        
        RUN goToKey IN {&hDBOTable} (INPUT i-ano-avaliacao).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Per°odo_avaliaá∆o" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ASSIGN i-ano-avaliacao:HEIGHT    = 0.88
           i-ano-avaliacao:WIDTH     = 7.
    
    ENABLE i-ano-avaliacao btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
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
       {&hDBOTable}:FILE-NAME <> "afbo/boaf016.p":U THEN DO:
        {btb/btb008za.i1 afbo/boaf016.p YES}
        {btb/btb008za.i2 afbo/boaf016.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boaf023) THEN DO:
        RUN afbo/boaf023.p persistent set h-boaf023.
    END.

    RUN openQueryStatic IN h-boaf023 (INPUT "Main":U) NO-ERROR. 

    RUN afp/afapi003.p PERSISTENT SET h-afapi003.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos wMaintenance 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     Habilita e carrega os per°odos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

DISABLE tt-af-periodo-aval.dt-periodo-ini
        tt-af-periodo-aval.dt-periodo-fim
        tt-af-periodo-aval.des-periodo-aval
        tt-af-periodo-aval.log-fechado WITH FRAME fpage0.

    ENABLE dt-periodo-ini[1]
           dt-periodo-fim[1]
           des-periodo-aval[1]
           log-fechado[1] WITH FRAME fpage0.

IF NOT AVAIL tt-af-periodo-aval THEN RETURN.

IF caction = "UPDATE":U THEN DO:
    RUN pi-existe-versao IN h-boaf023 (INPUT INT(ano-avaliacao:SCREEN-VALUE), OUTPUT c-retorno).        
    IF c-retorno = "OK":U THEN
        DISABLE nr-periodos
        WITH FRAME fpage0.    
END.

/*Para n∆o limpar as informaá‰es se estiver apenas clicando no bot∆o de editar*/
IF i-nr-per-old <> INPUT FRAME fpage0 tt-af-periodo-aval.nr-periodos THEN
    RUN pi-limpa-campos.

EMPTY TEMP-TABLE tt-periodos.
RUN afp/afapi002.p (INPUT INPUT FRAME fpage0 tt-af-periodo-aval.ano-avaliacao,
                    INPUT INPUT FRAME fpage0 tt-af-periodo-aval.nr-periodos,
                    OUTPUT TABLE tt-periodos).

FOR EACH tt-periodos:
     ENABLE tt-af-periodo-aval.dt-periodo-ini[tt-periodos.sequencia] WHEN tt-periodos.date-ini <> ?
            tt-af-periodo-aval.dt-periodo-fim[tt-periodos.sequencia] WHEN tt-periodos.date-ini <> ?
            tt-af-periodo-aval.des-periodo-aval[tt-periodos.sequencia] WHEN tt-periodos.date-ini <> ?
           WITH FRAME fpage0.
    IF i-nr-per-old = INPUT FRAME fpage0 tt-af-periodo-aval.nr-periodos THEN
        NEXT.

     ASSIGN tt-af-periodo-aval.dt-periodo-ini[tt-periodos.sequencia]   = tt-periodos.date-ini
            tt-af-periodo-aval.dt-periodo-fim[tt-periodos.sequencia]   = tt-periodos.date-fim
            tt-af-periodo-aval.des-periodo-aval[tt-periodos.sequencia] = periodo
            tt-af-periodo-aval.log-fechado[tt-periodos.sequencia]      = NO.

     DISP tt-af-periodo-aval.dt-periodo-ini[tt-periodos.sequencia]   
          tt-af-periodo-aval.dt-periodo-fim[tt-periodos.sequencia]  
          tt-af-periodo-aval.des-periodo-aval[tt-periodos.sequencia]
         WITH FRAME fPage0.
END.

ASSIGN i-nr-per-old = INPUT FRAME fpage0 tt-af-periodo-aval.nr-periodos.

IF INPUT FRAME fpage0 tt-af-periodo-aval.nr-periodos > 4 AND INPUT FRAME fpage0 tt-af-periodo-aval.nr-periodos <> 6 
    AND INPUT FRAME fpage0 tt-af-periodo-aval.nr-periodos <> 12 THEN DO:
    DEFINE VARIABLE iContPer AS INTEGER  NO-UNDO.
    REPEAT iContPer = 1 TO INPUT FRAME fpage0 tt-af-periodo-aval.nr-periodos:
         ENABLE tt-af-periodo-aval.dt-periodo-ini[iContPer]
                tt-af-periodo-aval.dt-periodo-fim[iContPer]
                tt-af-periodo-aval.des-periodo-aval[iContPer]
           WITH FRAME fpage0.         
    END.
    ASSIGN  iContPer = INPUT FRAME fpage0 tt-af-periodo-aval.nr-periodos.         

    DISABLE tt-af-periodo-aval.log-fechado[1]  
            tt-af-periodo-aval.log-fechado[2]  
            tt-af-periodo-aval.log-fechado[3]  
            tt-af-periodo-aval.log-fechado[4]  
            tt-af-periodo-aval.log-fechado[5]  
            tt-af-periodo-aval.log-fechado[6]  
            tt-af-periodo-aval.log-fechado[7]  
            tt-af-periodo-aval.log-fechado[8]  
            tt-af-periodo-aval.log-fechado[9]  
            tt-af-periodo-aval.log-fechado[10] 
            tt-af-periodo-aval.log-fechado[11] 
            tt-af-periodo-aval.log-fechado[12] 
        WITH FRAME fPage0.

    ENABLE tt-af-periodo-aval.log-fechado[1]
           tt-af-periodo-aval.log-fechado[2]
           tt-af-periodo-aval.log-fechado[3]
           tt-af-periodo-aval.log-fechado[4]
           tt-af-periodo-aval.log-fechado[5]
        WITH FRAME fPage0.

        IF iContPer > 5 THEN DO:
             ENABLE tt-af-periodo-aval.log-fechado[6]
                    tt-af-periodo-aval.log-fechado[7]
            WITH FRAME fPage0.
        END.
        
        IF iContPer = 11 THEN DO:
             ENABLE tt-af-periodo-aval.log-fechado[11]
                    tt-af-periodo-aval.log-fechado[10]
                    tt-af-periodo-aval.log-fechado[9]
                    tt-af-periodo-aval.log-fechado[8]
            WITH FRAME fPage0.
        END.
        ELSE IF iContPer = 10 THEN DO:
            ENABLE  tt-af-periodo-aval.log-fechado[10]
                    tt-af-periodo-aval.log-fechado[9]
                    tt-af-periodo-aval.log-fechado[8]
            WITH FRAME fPage0.
        END.
        ELSE IF iContPer = 9 THEN DO:
            ENABLE  tt-af-periodo-aval.log-fechado[9]
                    tt-af-periodo-aval.log-fechado[8]
            WITH FRAME fPage0.
        END.
        ELSE IF iContPer = 8 THEN DO:
            ENABLE  tt-af-periodo-aval.log-fechado[8]
            WITH FRAME fPage0.
        END.

END.
ELSE DO:

    ENABLE tt-af-periodo-aval.log-fechado[1]  WHEN tt-af-periodo-aval.dt-periodo-ini[1]  <> ?
           tt-af-periodo-aval.log-fechado[2]  WHEN tt-af-periodo-aval.dt-periodo-ini[2]  <> ?
           tt-af-periodo-aval.log-fechado[3]  WHEN tt-af-periodo-aval.dt-periodo-ini[3]  <> ?
           tt-af-periodo-aval.log-fechado[4]  WHEN tt-af-periodo-aval.dt-periodo-ini[4]  <> ?
           tt-af-periodo-aval.log-fechado[5]  WHEN tt-af-periodo-aval.dt-periodo-ini[5]  <> ?
           tt-af-periodo-aval.log-fechado[6]  WHEN tt-af-periodo-aval.dt-periodo-ini[6]  <> ?
           tt-af-periodo-aval.log-fechado[7]  WHEN tt-af-periodo-aval.dt-periodo-ini[7]  <> ?
           tt-af-periodo-aval.log-fechado[8]  WHEN tt-af-periodo-aval.dt-periodo-ini[8]  <> ?
           tt-af-periodo-aval.log-fechado[9]  WHEN tt-af-periodo-aval.dt-periodo-ini[9]  <> ?
           tt-af-periodo-aval.log-fechado[10] WHEN tt-af-periodo-aval.dt-periodo-ini[10] <> ?
           tt-af-periodo-aval.log-fechado[11] WHEN tt-af-periodo-aval.dt-periodo-ini[11] <> ?
           tt-af-periodo-aval.log-fechado[12] WHEN tt-af-periodo-aval.dt-periodo-ini[12] <> ?
        WITH FRAME fPage0.
    
    DISABLE tt-af-periodo-aval.log-fechado[1]  WHEN tt-af-periodo-aval.dt-periodo-ini[1]  = ?
            tt-af-periodo-aval.log-fechado[2]  WHEN tt-af-periodo-aval.dt-periodo-ini[2]  = ?
            tt-af-periodo-aval.log-fechado[3]  WHEN tt-af-periodo-aval.dt-periodo-ini[3]  = ?
            tt-af-periodo-aval.log-fechado[4]  WHEN tt-af-periodo-aval.dt-periodo-ini[4]  = ?
            tt-af-periodo-aval.log-fechado[5]  WHEN tt-af-periodo-aval.dt-periodo-ini[5]  = ?
            tt-af-periodo-aval.log-fechado[6]  WHEN tt-af-periodo-aval.dt-periodo-ini[6]  = ?
            tt-af-periodo-aval.log-fechado[7]  WHEN tt-af-periodo-aval.dt-periodo-ini[7]  = ?
            tt-af-periodo-aval.log-fechado[8]  WHEN tt-af-periodo-aval.dt-periodo-ini[8]  = ?
            tt-af-periodo-aval.log-fechado[9]  WHEN tt-af-periodo-aval.dt-periodo-ini[9]  = ?
            tt-af-periodo-aval.log-fechado[10] WHEN tt-af-periodo-aval.dt-periodo-ini[10] = ?
            tt-af-periodo-aval.log-fechado[11] WHEN tt-af-periodo-aval.dt-periodo-ini[11] = ?
            tt-af-periodo-aval.log-fechado[12] WHEN tt-af-periodo-aval.dt-periodo-ini[12] = ?
        WITH FRAME fPage0.
END.

APPLY 'entry' TO tt-af-periodo-aval.dt-periodo-ini[1] IN FRAME fpage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-campos wMaintenance 
PROCEDURE pi-limpa-campos :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para limpar os campos antes de setar os novos valores
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN tt-af-periodo-aval.dt-periodo-ini[1]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.dt-periodo-fim[1]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.des-periodo-aval[1]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.log-fechado[1]:CHECKED IN FRAME fpage0 = FALSE
       tt-af-periodo-aval.dt-periodo-ini[2]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.dt-periodo-fim[2]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.des-periodo-aval[2]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.log-fechado[2]:CHECKED IN FRAME fpage0 = FALSE
       tt-af-periodo-aval.dt-periodo-ini[3]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.dt-periodo-fim[3]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.des-periodo-aval[3]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.log-fechado[3]:CHECKED IN FRAME fpage0 = FALSE
       tt-af-periodo-aval.dt-periodo-ini[4]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.dt-periodo-fim[4]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.des-periodo-aval[4]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.log-fechado[4]:CHECKED IN FRAME fpage0 = FALSE
       tt-af-periodo-aval.dt-periodo-ini[5]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.dt-periodo-fim[5]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.des-periodo-aval[5]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.log-fechado[5]:CHECKED IN FRAME fpage0 = FALSE
       tt-af-periodo-aval.dt-periodo-ini[6]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.dt-periodo-fim[6]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.des-periodo-aval[6]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.log-fechado[6]:CHECKED IN FRAME fpage0 = FALSE
       tt-af-periodo-aval.dt-periodo-ini[7]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.dt-periodo-fim[7]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.des-periodo-aval[7]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.log-fechado[7]:CHECKED IN FRAME fpage0 = FALSE
       tt-af-periodo-aval.dt-periodo-ini[8]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.dt-periodo-fim[8]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.des-periodo-aval[8]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.log-fechado[8]:CHECKED IN FRAME fpage0 = FALSE
       tt-af-periodo-aval.dt-periodo-ini[9]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.dt-periodo-fim[9]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.des-periodo-aval[9]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.log-fechado[9]:CHECKED IN FRAME fpage0 = FALSE
       tt-af-periodo-aval.dt-periodo-ini[10]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.dt-periodo-fim[10]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.des-periodo-aval[10]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.log-fechado[10]:CHECKED IN FRAME fpage0 = FALSE
       tt-af-periodo-aval.dt-periodo-ini[11]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.dt-periodo-fim[11]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.des-periodo-aval[11]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.log-fechado[11]:CHECKED IN FRAME fpage0 = FALSE
       tt-af-periodo-aval.dt-periodo-ini[12]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.dt-periodo-fim[12]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.des-periodo-aval[12]:SCREEN-VALUE IN FRAME fpage0 = ""
       tt-af-periodo-aval.log-fechado[12]:CHECKED IN FRAME fpage0 = FALSE
       tt-af-periodo-aval.dt-periodo-ini[1]    = ?
       tt-af-periodo-aval.dt-periodo-fim[1]    = ?
       tt-af-periodo-aval.des-periodo-aval[1]  = ""
       tt-af-periodo-aval.log-fechado[1]       = FALSE
       tt-af-periodo-aval.dt-periodo-ini[2]    = ?
       tt-af-periodo-aval.dt-periodo-fim[2]    = ?
       tt-af-periodo-aval.des-periodo-aval[2]  = ""
       tt-af-periodo-aval.log-fechado[2]       = FALSE
       tt-af-periodo-aval.dt-periodo-ini[3]    = ?
       tt-af-periodo-aval.dt-periodo-fim[3]    = ?
       tt-af-periodo-aval.des-periodo-aval[3]  = ""
       tt-af-periodo-aval.log-fechado[3]       = FALSE
       tt-af-periodo-aval.dt-periodo-ini[4]    = ?
       tt-af-periodo-aval.dt-periodo-fim[4]    = ?
       tt-af-periodo-aval.des-periodo-aval[4]  = ""
       tt-af-periodo-aval.log-fechado[4]       = FALSE
       tt-af-periodo-aval.dt-periodo-ini[5]    = ?
       tt-af-periodo-aval.dt-periodo-fim[5]    = ?
       tt-af-periodo-aval.des-periodo-aval[5]  = ""
       tt-af-periodo-aval.log-fechado[5]       = FALSE
       tt-af-periodo-aval.dt-periodo-ini[6]    = ?
       tt-af-periodo-aval.dt-periodo-fim[6]    = ?
       tt-af-periodo-aval.des-periodo-aval[6]  = ""
       tt-af-periodo-aval.log-fechado[6]       = FALSE
       tt-af-periodo-aval.dt-periodo-ini[7]    = ?
       tt-af-periodo-aval.dt-periodo-fim[7]    = ?
       tt-af-periodo-aval.des-periodo-aval[7]  = ""
       tt-af-periodo-aval.log-fechado[7]       = FALSE
       tt-af-periodo-aval.dt-periodo-ini[8]    = ?
       tt-af-periodo-aval.dt-periodo-fim[8]    = ?
       tt-af-periodo-aval.des-periodo-aval[8]  = ""
       tt-af-periodo-aval.log-fechado[8]       = FALSE
       tt-af-periodo-aval.dt-periodo-ini[9]    = ?
       tt-af-periodo-aval.dt-periodo-fim[9]    = ?
       tt-af-periodo-aval.des-periodo-aval[9]  = ""
       tt-af-periodo-aval.log-fechado[9]       = FALSE
       tt-af-periodo-aval.dt-periodo-ini[10]   = ?
       tt-af-periodo-aval.dt-periodo-fim[10]   = ?
       tt-af-periodo-aval.des-periodo-aval[10] = ""
       tt-af-periodo-aval.log-fechado[10]      = FALSE
       tt-af-periodo-aval.dt-periodo-ini[11]   = ?
       tt-af-periodo-aval.dt-periodo-fim[11]   = ?
       tt-af-periodo-aval.des-periodo-aval[11] = ""
       tt-af-periodo-aval.log-fechado[11]      = FALSE
       tt-af-periodo-aval.dt-periodo-ini[12]   = ?
       tt-af-periodo-aval.dt-periodo-fim[12]   = ?
       tt-af-periodo-aval.des-periodo-aval[12] = ""
       tt-af-periodo-aval.log-fechado[12]      = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

