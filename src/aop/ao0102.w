&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mao-ensaio NO-UNDO LIKE mao-ensaio
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
{include/i-prgvrs.i AO0102 2.00.00.001} /*** "010001" 23/05/2025 06:56:52  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0102 MAO}
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
&GLOBAL-DEFINE Program        AO0102
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Principal

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

&GLOBAL-DEFINE ttTable        tt-mao-ensaio
&GLOBAL-DEFINE hDBOTable      HBOmao-ensaio
&GLOBAL-DEFINE DBOTable       mao-ensaio

&GLOBAL-DEFINE page0KeyFields tt-mao-ensaio.cod-ensaio 
&GLOBAL-DEFINE page0Fields    tt-mao-ensaio.des-ensaio
&GLOBAL-DEFINE page1Fields    tt-mao-ensaio.des-abrev ~
                              tt-mao-ensaio.idi-tip-restdo ~
                              tt-mao-ensaio.num-tabela ~
                              tt-mao-ensaio.des-formato
                             
                             

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTabela   AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-mao-ensaio.cod-ensaio ~
tt-mao-ensaio.des-ensaio 
&Scoped-define ENABLED-TABLES tt-mao-ensaio
&Scoped-define FIRST-ENABLED-TABLE tt-mao-ensaio
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btAdd btCopy btUpdate btDelete btUndo btCancel btSave btQueryJoins ~
btReportsJoins btExit btHelp rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-mao-ensaio.cod-ensaio ~
tt-mao-ensaio.des-ensaio 
&Scoped-define DISPLAYED-TABLES tt-mao-ensaio
&Scoped-define FIRST-DISPLAYED-TABLE tt-mao-ensaio


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
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
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
     IMAGE-UP FILE "image~\im-add":U
     IMAGE-INSENSITIVE FILE "image~\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image~\im-can":U
     IMAGE-INSENSITIVE FILE "image~\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image~\im-copy":U
     IMAGE-INSENSITIVE FILE "image~\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image~\im-era":U
     IMAGE-INSENSITIVE FILE "image~\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image~\im-fir":U
     IMAGE-INSENSITIVE FILE "image~\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image~\im-enter":U
     IMAGE-INSENSITIVE FILE "image~\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image~\im-las":U
     IMAGE-INSENSITIVE FILE "image~\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image~\im-nex":U
     IMAGE-INSENSITIVE FILE "image~\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image~\im-pre":U
     IMAGE-INSENSITIVE FILE "image~\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image~\im-joi":U
     IMAGE-INSENSITIVE FILE "image~\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image~\im-pri":U
     IMAGE-INSENSITIVE FILE "image~\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image~\im-undo":U
     IMAGE-INSENSITIVE FILE "image~\ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image~\im-mod":U
     IMAGE-INSENSITIVE FILE "image~\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fi-des-tabela AS CHARACTER FORMAT "X(30)" 
     VIEW-AS FILL-IN 
     SIZE 49.29 BY .88.

DEFINE VARIABLE fi-val-max-dat AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88.

DEFINE VARIABLE fi-val-max-num AS DECIMAL FORMAT "->>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88.

DEFINE VARIABLE fi-val-max-txt AS CHARACTER FORMAT "X(60)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88.

DEFINE VARIABLE fi-val-min-dat AS DATE FORMAT "99/99/9999" 
     LABEL "":R8 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88.

DEFINE VARIABLE fi-val-min-num AS DECIMAL FORMAT "->>>,>>>,>>9.99" INITIAL 0 
     LABEL "Faixa":R8 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88.

DEFINE VARIABLE fi-val-min-txt AS CHARACTER FORMAT "x(60)" 
     LABEL "":R8 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88.

DEFINE VARIABLE fiTexto1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-27
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72.86 BY 1.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73 BY 3.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrˆncia corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma altera‡äes"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-mao-ensaio.cod-ensaio AT ROW 2.88 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-mao-ensaio.des-ensaio AT ROW 3.79 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.46
         FONT 1.

DEFINE FRAME fPage1
     tt-mao-ensaio.des-abrev AT ROW 1.42 COL 8.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-mao-ensaio.idi-tip-restdo AT ROW 3.25 COL 12 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Num‚rico", 1,
"Tabela", 2,
"Texto", 3,
"Data", 4
          SIZE 65.14 BY 1
     tt-mao-ensaio.num-tabela AT ROW 4.54 COL 7.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-des-tabela AT ROW 4.54 COL 15.43 COLON-ALIGNED NO-LABEL
     tt-mao-ensaio.des-formato AT ROW 5.5 COL 7.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 57.57 BY .88
     fi-val-min-txt AT ROW 7.75 COL 13 COLON-ALIGNED
     fi-val-min-dat AT ROW 7.75 COL 13 COLON-ALIGNED HELP
          "Valor m¡nimo do resultado"
     fi-val-min-num AT ROW 7.75 COL 13 COLON-ALIGNED HELP
          "Valor m¡nimo do resultado"
     fi-val-max-num AT ROW 7.75 COL 48.72 COLON-ALIGNED HELP
          "Valor m ximo do resultado" NO-LABEL
     fi-val-max-txt AT ROW 7.75 COL 48.72 COLON-ALIGNED NO-LABEL
     fi-val-max-dat AT ROW 7.75 COL 48.72 COLON-ALIGNED HELP
          "Valor m ximo do resultado" NO-LABEL
     fiTexto1 AT ROW 2.46 COL 9.29 COLON-ALIGNED NO-LABEL
     fiTexto2 AT ROW 6.5 COL 9 COLON-ALIGNED NO-LABEL
     IMAGE-27 AT ROW 7.79 COL 44.86
     IMAGE-28 AT ROW 7.79 COL 48.29
     RECT-1 AT ROW 2.71 COL 9.14
     RECT-2 AT ROW 6.83 COL 9
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.42
         SIZE 84.43 BY 10.62
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mao-ensaio T "?" NO-UNDO mgfro mao-ensaio
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
         HEIGHT             = 16.46
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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
    {method/zoomreposition.i &ProgramZoom="frzoom/z01fr103.w"}
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-mao-ensaio.des-formato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio.des-formato wMaintenance
ON LEAVE OF tt-mao-ensaio.des-formato IN FRAME fPage1 /* Formato */
DO:
  IF AVAIL {&ttTable} THEN DO WITH FRAME fpage1:

      DEFINE VARIABLE c-teste AS CHARACTER  NO-UNDO.
      DEFINE VARIABLE i-cont1 AS INTEGER INITIAL 0 NO-UNDO.
      DEFINE VARIABLE i-cont2 AS INTEGER INITIAL 0 NO-UNDO.
      DEFINE VARIABLE c-aux1 AS CHARACTER FORMAT "X(30)" NO-UNDO.
      DEFINE VARIABLE c-aux2 AS CHARACTER FORMAT "X(30)" NO-UNDO.

      CASE INPUT {&tttable}.idi-tip-restdo :
        WHEN 1 THEN DO:
            ASSIGN  fi-val-min-num:FORMAT  = {&ttTable}.des-formato:SCREEN-VALUE
                    fi-val-max-num:FORMAT  = {&ttTable}.des-formato:SCREEN-VALUE NO-ERROR.
            IF error-status:ERROR = NO AND 
               ({&ttTable}.des-val-max = "0" OR
                {&ttTable}.des-val-max = ""  OR 
                {&ttTable}.des-val-max = ?)  THEN DO:

                /*caso tenha gravado sem erro o formato nos campos de val min e max, e o valor de max seja 0, "" ou nulo
                  entao completar o val max com 999 conforme o formato especificado pelo des-formato */

                ASSIGN c-teste = ENTRY(2,{&ttTable}.des-formato:SCREEN-VALUE,".") NO-ERROR.
                IF error-status:ERROR THEN DO:

                    /*caso o formato NÇO seja DECIMAL: */
                    DO WHILE i-cont1 <> LENGTH({&ttTable}.des-formato:SCREEN-VALUE):
                        ASSIGN i-cont1 = i-cont1 + 1.
                        IF SUBSTRING({&ttTable}.des-formato:SCREEN-VALUE,i-cont1,1) = ">" OR 
                           SUBSTRING({&ttTable}.des-formato:SCREEN-VALUE,i-cont1,1) = "9" THEN
                            ASSIGN i-cont2 = i-cont2 + 1.
                    END.
                    ASSIGN fi-val-max-num:SCREEN-VALUE = FILL("9", i-cont2).

                END.
                ELSE DO: /*caso seja DECIMAL*/

                    DO WHILE i-cont1 <> LENGTH(ENTRY(1,{&ttTable}.des-formato:SCREEN-VALUE,".")):
                        ASSIGN i-cont1 = i-cont1 + 1.
                        IF SUBSTRING(ENTRY(1,{&ttTable}.des-formato:SCREEN-VALUE,"."),i-cont1,1) = ">" OR 
                           SUBSTRING(ENTRY(1,{&ttTable}.des-formato:SCREEN-VALUE,"."),i-cont1,1) = "9" THEN
                            ASSIGN i-cont2 = i-cont2 + 1.
                    END.
                    ASSIGN c-aux1 = FILL("9",i-cont2).

                    ASSIGN i-cont1 = 0
                           i-cont2 = 0.

                    DO WHILE i-cont1 <> LENGTH(ENTRY(2,{&ttTable}.des-formato:SCREEN-VALUE,".")):
                        ASSIGN i-cont1 = i-cont1 + 1.
                        IF SUBSTRING(ENTRY(2,{&ttTable}.des-formato:SCREEN-VALUE,"."),i-cont1,1) = ">" OR 
                           SUBSTRING(ENTRY(2,{&ttTable}.des-formato:SCREEN-VALUE,"."),i-cont1,1) = "9" THEN
                            ASSIGN i-cont2 = i-cont2 + 1.
                    END.
                    ASSIGN c-aux2 = FILL("9",i-cont2).

                    ASSIGN fi-val-max-num:SCREEN-VALUE = STRING(c-aux1 + "," + c-aux2).
                    
                END. /*else*/

            END. /* IF error-status:ERROR = NO*/

        END. /*when 1*/
        WHEN 3 THEN DO:
            ASSIGN fi-val-min-txt:FORMAT  = {&ttTable}.des-formato:SCREEN-VALUE           
                   fi-val-max-txt:FORMAT  = {&ttTable}.des-formato:SCREEN-VALUE NO-ERROR.

        END. /*when 3*/
    END CASE.
  END. /*if avail*/
END. /*do*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mao-ensaio.idi-tip-restdo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio.idi-tip-restdo wMaintenance
ON VALUE-CHANGED OF tt-mao-ensaio.idi-tip-restdo IN FRAME fPage1
DO:
  IF AVAIL {&ttTable} THEN DO WITH FRAME fpage1:

      CASE INPUT {&tttable}.idi-tip-restdo :
        WHEN 1 THEN DO:
            ASSIGN  fi-val-min-txt:HIDDEN               = YES
                    fi-val-max-txt:HIDDEN               = YES
                    fi-val-min-dat:HIDDEN               = YES
                    fi-val-max-dat:HIDDEN               = YES
                    fi-val-min-num:HIDDEN               = no
                    fi-val-max-num:HIDDEN               = no 
                    fi-val-min-txt:SENSITIVE            = NO
                    fi-val-max-txt:SENSITIVE            = NO
                    fi-val-min-dat:SENSITIVE            = NO
                    fi-val-max-dat:SENSITIVE            = NO
                    fi-val-min-num:SENSITIVE            = YES 
                    fi-val-max-num:SENSITIVE            = YES 
                    fi-val-min-num:SCREEN-VALUE         = 
                                            IF cAction = "ADD":U OR {&tttable}.idi-tip-restdo <> 1 
                                                   THEN "0" 
                                                 ELSE {&ttTable}.des-val-min
                    fi-val-max-num:SCREEN-VALUE         = 
                                            IF cAction = "ADD":U OR {&tttable}.idi-tip-restdo <> 1 
                                                   THEN "0" 
                                                 ELSE {&ttTable}.des-val-max
                    fi-val-min-txt:SCREEN-VALUE         = ""
                    fi-val-max-txt:SCREEN-VALUE         = ""
                    fi-val-min-dat:SCREEN-VALUE         = ""
                    fi-val-max-dat:SCREEN-VALUE         = ""
                    {&ttTable}.num-tabela:sensitive     = NO
                    {&ttTable}.num-tabela:SCREEN-VALUE  = "0"
                    fi-des-tabela:SCREEN-VALUE          = ""
                    {&ttTable}.des-formato:SENSITIVE    = 
                                             IF cAction = "" THEN NO
                                                 ELSE YES
                    {&ttTable}.des-formato:SCREEN-VALUE =
                                             IF cAction = "ADD":U OR {&tttable}.idi-tip-restdo <> 1 
                                                     THEN "->>>,>>>,>>9.99":U 
                                                 ELSE 
                                                     {&ttTable}.des-formato.                           
        END.
        WHEN 2 THEN DO:
            ASSIGN  fi-val-min-txt:HIDDEN               = NO
                    fi-val-max-txt:HIDDEN               = NO
                    fi-val-min-dat:HIDDEN               = YES
                    fi-val-max-dat:HIDDEN               = YES
                    fi-val-min-num:HIDDEN               = YES
                    fi-val-max-num:HIDDEN               = YES 
                    fi-val-min-txt:SENSITIVE            = NO
                    fi-val-max-txt:SENSITIVE            = NO
                    fi-val-min-dat:SENSITIVE            = NO
                    fi-val-max-dat:SENSITIVE            = NO
                    fi-val-min-num:SENSITIVE            = NO 
                    fi-val-max-num:SENSITIVE            = NO 
                    fi-val-min-num:SCREEN-VALUE         = "0"
                    fi-val-max-num:SCREEN-VALUE         = "0"
                    fi-val-min-txt:SCREEN-VALUE         = "" 
                    fi-val-max-txt:SCREEN-VALUE         = "" 
                    fi-val-min-dat:SCREEN-VALUE         = "" 
                    fi-val-max-dat:SCREEN-VALUE         = "" 
                    {&ttTable}.num-tabela:sensitive     = YES
                    {&ttTable}.des-formato:SENSITIVE    = NO
                    {&ttTable}.des-formato:SCREEN-VALUE = "":U.
            APPLY "leave":U TO {&ttTable}.num-tabela.
        
        END.
        WHEN 3 THEN DO:
        
            ASSIGN  fi-val-min-txt:HIDDEN               = NO
                    fi-val-max-txt:HIDDEN               = NO
                    fi-val-min-dat:HIDDEN               = YES
                    fi-val-max-dat:HIDDEN               = YES
                    fi-val-min-num:HIDDEN               = YES
                    fi-val-max-num:HIDDEN               = YES 
                    fi-val-min-txt:SENSITIVE            = YES
                    fi-val-max-txt:SENSITIVE            = YES
                    fi-val-min-dat:SENSITIVE            = NO
                    fi-val-max-dat:SENSITIVE            = NO
                    fi-val-min-num:SENSITIVE            = NO 
                    fi-val-max-num:SENSITIVE            = NO 
                    fi-val-min-num:SCREEN-VALUE         = "0"
                    fi-val-max-num:SCREEN-VALUE         = "0"
                    fi-val-min-txt:SCREEN-VALUE         = 
                                            IF cAction = "ADD":U OR {&tttable}.idi-tip-restdo <> 3 
                                                   THEN "" 
                                                 ELSE {&ttTable}.des-val-min 
                    fi-val-max-txt:SCREEN-VALUE         = 
                                            IF cAction = "ADD":U OR {&tttable}.idi-tip-restdo <> 3 
                                                   THEN "" 
                                                 ELSE {&ttTable}.des-val-max 
                    fi-val-min-dat:SCREEN-VALUE         = "" 
                    fi-val-max-dat:SCREEN-VALUE         = "" 
                    {&ttTable}.num-tabela:sensitive     = NO
                    {&ttTable}.num-tabela:SCREEN-VALUE  = "0"
                    fi-des-tabela:SCREEN-VALUE          = ""
                    {&ttTable}.des-formato:SENSITIVE    = 
                                             IF cAction = "" THEN NO
                                                 ELSE YES
                    {&ttTable}.des-formato:SCREEN-VALUE = 
                                             IF cAction = "ADD":U OR {&tttable}.idi-tip-restdo <> 3                                              
                                                     THEN "X(60)":U 
                                                 ELSE {&ttTable}.des-formato. 

        END.
        WHEN 4 THEN DO:

            ASSIGN  fi-val-min-txt:HIDDEN               = YES
                    fi-val-max-txt:HIDDEN               = YES
                    fi-val-min-dat:HIDDEN               = NO
                    fi-val-max-dat:HIDDEN               = NO
                    fi-val-min-num:HIDDEN               = YES
                    fi-val-max-num:HIDDEN               = YES 
                    fi-val-min-txt:SENSITIVE            = NO
                    fi-val-max-txt:SENSITIVE            = NO
                    fi-val-min-dat:SENSITIVE            = YES
                    fi-val-max-dat:SENSITIVE            = YES
                    fi-val-min-num:SENSITIVE            = NO 
                    fi-val-max-num:SENSITIVE            = NO 
                    fi-val-min-num:SCREEN-VALUE         = "0"
                    fi-val-max-num:SCREEN-VALUE         = "0"
                    fi-val-min-txt:SCREEN-VALUE         = "" 
                    fi-val-max-txt:SCREEN-VALUE         = ""
                    fi-val-min-dat:SCREEN-VALUE         = 
                                            IF cAction = "ADD":U OR {&tttable}.idi-tip-restdo <> 4 
                                                    THEN "" 
                                                 ELSE {&ttTable}.des-val-min                 
                    fi-val-max-dat:SCREEN-VALUE         = 
                                            IF cAction = "ADD":U OR {&tttable}.idi-tip-restdo <> 4 
                                                    THEN ""
                                                 ELSE {&ttTable}.des-val-max   
                    {&ttTable}.num-tabela:sensitive     = NO
                    {&ttTable}.num-tabela:SCREEN-VALUE  = "0"
                    fi-des-tabela:SCREEN-VALUE          = ""
                    {&ttTable}.des-formato:SENSITIVE    = NO
                    {&ttTable}.des-formato:SCREEN-VALUE = 
                                             IF cAction = "ADD":U OR {&tttable}.idi-tip-restdo <> 4 
                                                     THEN "99/99/9999":U 
                                                 ELSE {&ttTable}.des-formato.
        END.
    END CASE.
    APPLY "leave":U TO {&ttTable}.des-formato.
  END. /*if avail table then do*/
  ELSE DO: /*caso a tabela nao esteja dispon¡vel, gravar branco em todos os campos*/
        ASSIGN fi-val-min-num:SENSITIVE IN FRAME fpage1        = no
               fi-val-max-num:SENSITIVE IN FRAME fpage1        = no
               fi-val-min-txt:SENSITIVE IN FRAME fpage1        = no
               fi-val-max-txt:SENSITIVE IN FRAME fpage1        = no
               fi-val-min-dat:SENSITIVE IN FRAME fpage1        = no
               fi-val-max-dat:SENSITIVE IN FRAME fpage1        = NO
               {&ttTable}.num-tabela:SENSITIVE IN FRAME fPage1 = NO 
               fi-val-min-num:SCREEN-VALUE IN FRAME fpage1 = "0"
               fi-val-max-num:SCREEN-VALUE IN FRAME fpage1 = "0"
               fi-val-min-txt:SCREEN-VALUE IN FRAME fpage1 = ""
               fi-val-max-txt:SCREEN-VALUE IN FRAME fpage1 = ""
               fi-val-min-dat:SCREEN-VALUE IN FRAME fpage1 = ""
               fi-val-max-dat:SCREEN-VALUE IN FRAME fpage1 = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mao-ensaio.num-tabela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio.num-tabela wMaintenance
ON LEAVE OF tt-mao-ensaio.num-tabela IN FRAME fPage1 /* Tabela */
DO:
    IF INPUT {&ttTable}.num-tabela <> 0 THEN DO:
      ASSIGN fi-des-tabela = "":U.
      RUN gotoKey IN hDBOTabela (INPUT FRAME fPage1 {&ttTable}.num-tabela ).
      IF RETURN-VALUE = "OK":U THEN DO:
         RUN getCharField IN hDBOTabela (INPUT "des-tabela":U, OUTPUT fi-des-tabela).
       END.
      {method/referenceFields.i
            &HandleDBOLeave="hDBOTabela"
            &KeyValue1="input frame fpage1 {&ttTable}.num-tabela"
            &FieldName1="des-tabela"
            &FieldScreen1="fi-des-tabela"
            &Frame1="fPage1"}  
        DISP fi-des-tabela WITH FRAME fpage1.
    END.
    ELSE 
        ASSIGN fi-des-tabela:SCREEN-VALUE IN FRAME fpage1 = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mao-ensaio.num-tabela wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-mao-ensaio.num-tabela IN FRAME fPage1 /* Tabela */
OR "F5":U OF {&ttTable}.num-tabela IN FRAME fPage1 DO:
        {method/zoomfields.i 
         &ProgramZoom="frzoom~\z01fr102.w"
         &FieldZoom1="num-tabela"
         &FieldScreen1="{&ttTable}.num-tabela"
         &Frame1="fPage1"
         &FieldZoom2="des-tabela"
         *&FieldScreen2="fi-des-tabela"
         &Frame2="fPage1"
         &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}
{&ttTable}.num-tabela:LOAD-MOUSE-POINTER("image/lupa.cur":U)      in frame fPage1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisableFields wMaintenance 
PROCEDURE afterDisableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

            ASSIGN  fi-val-min-txt:SENSITIVE in frame fPage1 = no
                    fi-val-max-txt:SENSITIVE in frame fPage1 = no
                    fi-val-min-dat:SENSITIVE in frame fPage1 = no
                    fi-val-max-dat:SENSITIVE in frame fPage1 = no
                    fi-val-min-num:SENSITIVE in frame fPage1 = NO
                    fi-val-max-num:SENSITIVE in frame fPage1 = NO.

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
/*Descri‡Æo da tabela*/
APPLY "leave":U         TO {&ttTable}.num-tabela IN FRAME fPage1.
APPLY "value-changed":U to {&tttable}.idi-tip-restdo IN FRAME fPage1.

IF AVAIL {&ttTable} and cAction = "":U THEN DO:
/*   ASSIGN {&ttTable}.des-formato = {&ttTable}.des-formato:SCREEN-VALUE IN FRAME fPage1. */

  ASSIGN {&ttTable}.des-formato:SCREEN-VALUE IN FRAME fPage1 = {&ttTable}.des-formato.
  APPLY "leave":U TO {&ttTable}.des-formato IN FRAME fPage1.

  CASE INPUT FRAME fpage1 {&tttable}.idi-tip-restdo :
       WHEN 1 THEN DO:
           ASSIGN fi-val-min-num:SCREEN-VALUE IN FRAME fpage1 = STRING({&ttTable}.des-val-min)
                  fi-val-max-num:SCREEN-VALUE IN FRAME fpage1 = STRING({&ttTable}.des-val-max).
       END.
       WHEN 3 THEN DO:
           ASSIGN fi-val-min-txt:SCREEN-VALUE IN FRAME fpage1 = {&ttTable}.des-val-min
                  fi-val-max-txt:SCREEN-VALUE IN FRAME fpage1 = {&ttTable}.des-val-max.
       END.
       WHEN 4 THEN DO:
           ASSIGN fi-val-min-dat:SCREEN-VALUE IN FRAME fpage1 = STRING({&ttTable}.des-val-min)
                  fi-val-max-dat:SCREEN-VALUE IN FRAME fpage1 = STRING({&ttTable}.des-val-max).
       END.
  END CASE.

END.
IF cAction = "ADD":U OR cAction = "COPY":U OR cAction = "UPDATE":U THEN DO:
    /***Habilita campos em tela****/
    APPLY "value-changed" TO {&tttable}.idi-tip-restdo IN FRAME fPage1.
end.
 /**** NAVEGA€ÇO DESABILITA OS CAMPOS EM TELA****/
IF cAction = "":U THEN DO:
    ASSIGN fi-val-min-num:SENSITIVE IN FRAME fpage1        = no
           fi-val-max-num:SENSITIVE IN FRAME fpage1        = no
           fi-val-min-txt:SENSITIVE IN FRAME fpage1        = no
           fi-val-max-txt:SENSITIVE IN FRAME fpage1        = no
           fi-val-min-dat:SENSITIVE IN FRAME fpage1        = no
           fi-val-max-dat:SENSITIVE IN FRAME fpage1        = NO
           {&ttTable}.num-tabela:SENSITIVE IN FRAME fPage1 = NO.
          
END.
IF cAction = "ADD":U THEN DO:
    ASSIGN fi-val-min-num:SCREEN-VALUE IN FRAME fpage1 = "0"
           fi-val-max-num:SCREEN-VALUE IN FRAME fpage1 = "0"
           fi-val-min-txt:SCREEN-VALUE IN FRAME fpage1 = ""
           fi-val-max-txt:SCREEN-VALUE IN FRAME fpage1 = ""
           fi-val-min-dat:SCREEN-VALUE IN FRAME fpage1 = ""
           fi-val-max-dat:SCREEN-VALUE IN FRAME fpage1 = "".
END.

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
DEFINE VARIABLE lStatus AS LOGICAL INITIAL NO   NO-UNDO.
/***   Se for Update testa se o registro esta sendo utilizado em algum Resultado de ensaio 
       Caso esteja deve-se desabilitar o campo em tela mantendo a integridade.              ***/
IF cAction = "UPDATE":U THEN DO:
    RUN desabilitaCampo IN {&hDBOTable} (INPUT {&ttTable}.cod-ensaio,
                                         OUTPUT lStatus).
    IF lStatus THEN 
        ASSIGN idi-tip-restdo:SENSITIVE IN FRAME fPage1 = NO.
    ELSE
        ASSIGN idi-tip-restdo:SENSITIVE IN FRAME fPage1 = YES.
END.

IF  cAction = "ADD":U THEN DO:
    ASSIGN {&tttable}.idi-tip-restdo = 1.
END.
DISP  {&tttable}.idi-tip-restdo WITH FRAME fPage1.

/***Habilita campos em tela****/
APPLY "value-changed" TO {&tttable}.idi-tip-restdo IN FRAME fPage1.

RETURN "OK":U.

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
{utp/ut-liter.i Tipo_Resultado * }
ASSIGN fiTexto1 = TRIM(RETURN-VALUE).
{utp/ut-liter.i Valores_Padräes * }
ASSIGN fiTexto2 = TRIM(RETURN-VALUE).
DISP fiTExto1 
     fiTexto2 WITH FRAME fPage1.

{utp/ut-liter.i Faixa  * }
ASSIGN fi-val-min-txt:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE)
       fi-val-min-num:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE)
       fi-val-min-dat:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMaintenance 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF AVAIL {&ttTable} and cAction = "":U THEN DO:
  ASSIGN {&tttable}.idi-tip-restdo:SCREEN-VALUE IN FRAME fPage1 = STRING({&tttable}.idi-tip-restdo)
         {&ttTable}.des-formato:SCREEN-VALUE    IN FRAME fPage1 = {&ttTable}.des-formato.
  APPLY "leave":U TO {&ttTable}.des-formato IN FRAME fPage1.
END.

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

CASE INPUT FRAME fpage1 {&tttable}.idi-tip-restdo :
        WHEN 1 THEN DO:
            ASSIGN  {&ttTable}.des-val-min = INPUT FRAME fpage1 fi-val-min-num
                    {&ttTable}.des-val-max = INPUT FRAME fpage1 fi-val-max-num.
        END.
        WHEN 2 THEN DO:
            ASSIGN  {&ttTable}.des-val-min = ""
                    {&ttTable}.des-val-max = "".
        END.
        WHEN 3 THEN DO:
            ASSIGN {&ttTable}.des-val-min = INPUT FRAME fpage1 fi-val-min-txt
                   {&ttTable}.des-val-max = INPUT FRAME fpage1 fi-val-max-txt.
        END.
        WHEN 4 THEN DO:
            ASSIGN  {&ttTable}.des-val-min = INPUT FRAME fpage1 fi-val-min-dat
                    {&ttTable}.des-val-max = INPUT FRAME fpage1 fi-val-max-dat.
        END.
    END CASE.

    ASSIGN {&ttTable}.des-formato = {&ttTable}.des-formato:SCREEN-VALUE IN FRAME fPage1.

RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
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
    
    DEFINE VARIABLE cCod-Ensaio LIKE {&ttTable}.cod-ensaio NO-UNDO.

    DEFINE FRAME fGoToRecord
        cCod-Ensaio  AT ROW 1.21 COL 17.72 COLON-ALIGNED
          VIEW-AS FILL-IN SIZE 9 BY .88
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    run utp/ut-trfrrp.p (input frame fGoToRecord:handle).
    {utp/ut-liter.i V _Para_Ensaio *}
    assign frame fGoToRecord:title = return-value.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cCod-Ensaio .
        
        RUN goToKey IN {&hDBOTable} (INPUT cCod-Ensaio ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i Ensaio }
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value ).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cCod-Ensaio btGoToOK btGoToCancel 
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
    
    IF NOT VALID-HANDLE({&hDBOtable}) OR
     {&hDBOtable}:TYPE <> "PROCEDURE":U OR
     {&hDBOTable}:FILE-NAME <> "frbo/bofr103.p":U THEN DO:
      RUN frbo/bofr103.p PERSISTENT SET  {&hDBOTable}.
  END.
  RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(hDBOTabela) OR
       hDBOTabela:TYPE <> "PROCEDURE":U OR
       hDBOTabela:FILE-NAME <> "frbo/bofr102.p":U THEN DO:
        RUN frbo/bofr102.p PERSISTENT SET  hDBOTabela.
    END.
    RUN openQueryStatic IN hDBOTabela (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaData wMaintenance 
PROCEDURE validaData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pData as date format "99/99/9999" no-undo.
DEFINE VARIABLE dData AS DATE       NO-UNDO.

assign dData = date(integer(substring(string(pData),4,2)),             /** Mˆs **/
                    integer(substring(string(pData),1,2)),            /** Dia **/
                    integer(substring(string(pData),7,4))) no-error. /** Ano **/
if error-status:error then do:
   run utp/ut-msgs.p (input "show":U,
                      input 173,
                       input "''").
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

