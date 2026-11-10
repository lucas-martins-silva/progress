&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttEqpto NO-UNDO LIKE mab-eqpto
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
{include/i-prgvrs.i AB0139 2.00.00.007 } /*** "010007" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0139 MAB}
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
&GLOBAL-DEFINE Program        AB0139
&GLOBAL-DEFINE Version        2.00.00.005

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttEqpto
&GLOBAL-DEFINE hDBOTable      hDOBTEqpto
&GLOBAL-DEFINE DBOTable       mab-eqpto

&GLOBAL-DEFINE page0KeyFields ttEqpto.ep-codigo ttEqpto.cod-eqpto
&GLOBAL-DEFINE page0Fields    fiDescModelo ttEqpto.idi-tip-eqpto ~
                              ttEqpto.cod-sit-eqpto ttEqpto.dat-situacao fi-hra-inativa
                              
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE    NO-UNDO.
DEFINE VARIABLE hDBOSituacao AS HANDLE    NO-UNDO.
DEFINE VARIABLE hDBOModelo   AS HANDLE    NO-UNDO.
DEFINE VARIABLE hDBOParam    AS HANDLE    NO-UNDO.
DEFINE VARIABLE iSituacao    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iSituacaoAux AS INTEGER   NO-UNDO.
DEFINE VARIABLE cDesValor    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodSitAnt   AS CHARACTER NO-UNDO.


define variable c-cod-servico-pneu     as character   no-undo.
define variable c-cd-causa-pneu        as character   no-undo.
define variable c-cod-situacao-pneu    as character   no-undo.
define variable c-cd-causa-compon      as character   no-undo.
define variable c-cod-situacao-compon  as character   no-undo.
define variable l-entra-media          as logical     no-undo.
define variable hDBOMovtoPneu          as handle      no-undo.
define variable hDBOMovtoCompon        as handle      no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttEqpto.idi-tip-eqpto ttEqpto.cod-sit-eqpto ttEqpto.dat-situacao 
&Scoped-define ENABLED-TABLES ttEqpto
&Scoped-define FIRST-ENABLED-TABLE ttEqpto
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btAdd btCopy btUpdate btDelete btUndo btCancel btSave btQueryJoins ~
btReportsJoins btExit btHelp fiDescModelo fiDescSituacao fi-hra-inativa ~
rtToolBar rtKeys RECT-6 
&Scoped-Define DISPLAYED-FIELDS ttEqpto.ep-codigo ttEqpto.cod-eqpto ~
ttEqpto.idi-tip-eqpto ttEqpto.cod-sit-eqpto ttEqpto.dat-situacao 
&Scoped-define DISPLAYED-TABLES ttEqpto
&Scoped-define FIRST-DISPLAYED-TABLE ttEqpto
&Scoped-Define DISPLAYED-OBJECTS fiDescModelo fiDescSituacao fi-hra-inativa 

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
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
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

DEFINE VARIABLE fi-hra-inativa AS CHARACTER FORMAT "99:99:99":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescSituacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.25.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.25.

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
     ttEqpto.ep-codigo AT ROW 2.88 COL 15 COLON-ALIGNED HELP
          "C¢digo da empresa do equipamento"
          LABEL "Equipamento":R11 FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttEqpto.cod-eqpto AT ROW 2.88 COL 20 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     fiDescModelo AT ROW 2.88 COL 35 COLON-ALIGNED NO-LABEL
     ttEqpto.idi-tip-eqpto AT ROW 3.96 COL 17.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Motorizado", 1,
"N∆o Motorizado", 2
          SIZE 35 BY .88
     ttEqpto.cod-sit-eqpto AT ROW 5.17 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fiDescSituacao AT ROW 5.17 COL 22 COLON-ALIGNED NO-LABEL
     ttEqpto.dat-situacao AT ROW 5.17 COL 57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-hra-inativa AT ROW 5.17 COL 67 COLON-ALIGNED NO-LABEL
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
     RECT-6 AT ROW 5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 5.38
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttEqpto T "?" NO-UNDO mgfro mab-eqpto
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
         HEIGHT             = 5.38
         WIDTH              = 90
         MAX-HEIGHT         = 11
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 11
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN ttEqpto.ep-codigo IN FRAME fpage0
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
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
DO:
/*OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.*/
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
DO:
/*OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
DO:
/*OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.*/
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
    /* Chama pi de gravaá∆o do registro */
    RUN piSave IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
   {method/zoomreposition.i &ProgramZoom="frzoom/z01fr007.w"}
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


&Scoped-define SELF-NAME ttEqpto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-eqpto wMaintenance
ON LEAVE OF ttEqpto.cod-eqpto IN FRAME fpage0 /* cod-eqpto */
DO:
   RUN pi-leave-cod-eqpto IN THIS-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttEqpto.cod-sit-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-sit-eqpto wMaintenance
ON F5 OF ttEqpto.cod-sit-eqpto IN FRAME fpage0 /* Situaá∆o */
DO:
    ASSIGN ttEqpto.dat-situacao:SENSITIVE IN frame fPage0 = YES
           fi-hra-inativa:SENSITIVE       IN FRAME fPage0 = YES.
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr024.w"
           &FieldZoom1="cod-sit-eqpto"
           &FieldScreen1="ttEqpto.cod-sit-eqpto"
           &Frame1="fPage0"
           &FieldZoom2="des-sit-eqpto"
           &FieldScreen2="fiDescSituacao"
           &Frame2="fPage0"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-sit-eqpto wMaintenance
ON LEAVE OF ttEqpto.cod-sit-eqpto IN FRAME fpage0 /* Situaá∆o */
DO:
    IF NOT CAN-FIND(FIRST mab-sit-eqpto
                    WHERE mab-sit-eqpto.cod-sit-eqpto = {&ttTable}.cod-sit-eqpto:SCREEN-VALUE IN FRAME fPage0) THEN DO:
        RETURN NO-APPLY.
    END.
    ELSE DO:
        {method\ReferenceFields.i
            &HandleDBOLeave="hDBOSituacao"
            &KeyValue1="ttEqpto.cod-sit-eqpto:screen-value in frame fPage0"
            &FieldName1="des-sit-eqpto"
            &FieldScreen1="fiDescSituacao"
            &Frame1="fPage0"}
    
        /** Habilita/Desbilita Data Situaá∆o **/
        run piSituacao in this-procedure.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-sit-eqpto wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttEqpto.cod-sit-eqpto IN FRAME fpage0 /* Situaá∆o */
DO:
  apply "F5":U to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttEqpto.cod-sit-eqpto wMaintenance
ON VALUE-CHANGED OF ttEqpto.cod-sit-eqpto IN FRAME fpage0 /* Situaá∆o */
DO:
    IF NOT CAN-FIND(FIRST mab-sit-eqpto
                    WHERE mab-sit-eqpto.cod-sit-eqpto = {&ttTable}.cod-sit-eqpto:SCREEN-VALUE IN FRAME fPage0) THEN DO:
        RETURN NO-APPLY.
    END.
    ELSE
        RUN piSituacao in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME fi-hra-inativa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-inativa wMaintenance
ON LEAVE OF fi-hra-inativa IN FRAME fpage0
DO:
    DEFINE VARIABLE cHora AS CHARACTER FORMAT "99:99:99" NO-UNDO.
    /** Consiste o hor†rio **/
    assign cHora = fi-hra-inativa:screen-value in frame fPage0.
    run piFormataHorarioSeg (input-output cHora).
    if return-value = "NOK":U then do:
        apply "ENTRY":U to fi-hra-inativa in frame fPage0.
        return no-apply.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}
{abp/ab9000.i} /** Procedures controle de hora **/

ttEqpto.cod-sit-eqpto:LOAD-MOUSE-POINTER("image~\lupa.cur":U) IN FRAME fPage0.

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
/** Situaá∆o **/
IF  VALID-HANDLE(hDBOSituacao) THEN
    RUN destroy IN hDBOSituacao.

/** Modelo **/
IF  VALID-HANDLE(hDBOModelo) THEN
    RUN destroy IN hDBOModelo.

/** Paramentros **/
IF  VALID-HANDLE(hDBOParam) THEN
    RUN destroy IN hDBOParam.

/** Pneu **/
IF  VALID-HANDLE(hDBOMovtoPneu) THEN
    RUN destroy IN hDBOMovtoPneu.

/** Componente **/
IF  VALID-HANDLE(hDBOMovtoCompon) THEN
    RUN destroy IN hDBOMovtoCompon.

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
/** Descriá‰es de campos **/
APPLY "LEAVE":U TO ttEqpto.cod-eqpto IN FRAME fPage0.
APPLY "LEAVE":U TO ttEqpto.cod-sit-eqpto IN FRAME fPage0.
ASSIGN ttEqpto.dat-situacao:SENSITIVE IN frame fPage0 = NO
       cCodSitAnt = ttEqpto.cod-sit-eqpto:SCREEN-VALUE IN FRAME fPage0
       fi-hra-inativa:SENSITIVE IN FRAME fPage0 = NO.

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
ASSIGN fiDescModelo:SENSITIVE          IN FRAME fPage0 = NO
       ttEqpto.idi-tip-eqpto:SENSITIVE IN FRAME fPage0 = NO.

RUN piSituacao IN THIS-PROCEDURE.

RETURN "OK":U.

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
DEFINE VARIABLE c-hra-situacao AS CHARACTER FORMAT "x(6)" NO-UNDO.

ASSIGN c-hra-situacao = REPLACE(fi-hra-inativa:SCREEN-VALUE IN FRAME fPage0,":","").

ASSIGN OVERLAY({&ttTable}.cod-livre-1,19,6) = c-hra-situacao.

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
     SIZE 58 BY 1.42
     BGCOLOR 7.

DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

DEFINE VARIABLE cep-codigo   LIKE {&ttTable}.ep-codigo VIEW-AS FILL-IN SIZE 5.00 BY 0.88  NO-UNDO.
DEFINE VARIABLE ccod-eqpto     LIKE {&ttTable}.cod-eqpto VIEW-AS FILL-IN SIZE 16.00 BY 0.88    NO-UNDO.

DEFINE FRAME fGoToRecord
    cep-codigo      AT ROW 1.21 COL 17.72 COLON-ALIGNED
    ccod-eqpto        AT ROW 2.21 COL 17.72 COLON-ALIGNED
    btGoToOK          AT ROW 3.63 COL 2.14
    btGoToCancel      AT ROW 3.63 COL 13
    rtGoToButton      AT ROW 3.38 COL 1
    SPACE(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
         THREE-D SCROLLABLE TITLE "" FONT 1
         DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
{utp/ut-liter.i V†_Para_Equipamento *}
ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.

ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
    ASSIGN cep-codigo ccod-eqpto.
    
    /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
    RUN goToKey IN {&hDBOtable} (INPUT cep-codigo,
                                  input ccod-eqpto).
    IF RETURN-VALUE = "NOK":U THEN DO:
        {utp/ut-liter.i "Equipamento"}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value).
        
        RETURN NO-APPLY.
    END.
    
    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOtable} (OUTPUT rGoTo).
    
    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
    
    APPLY "GO":U TO FRAME fGoToRecord.
END.

ENABLE cep-codigo  
       ccod-eqpto    
       btGoToOK 
       btGoToCancel 
    WITH FRAME fGoToRecord. 

WAIT-FOR "GO":U OF FRAME fGoToRecord.

RETURN "OK":U.

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
IF NOT VALID-HANDLE({&hDBOTable})      OR
    {&hDBOTable}:TYPE <> "PROCEDURE":U OR
    {&hDBOTable}:FILE-NAME <> "frbo~\bofr007.p":U THEN DO:
    run frbo/bofr007.p persistent set  {&hDBOTable}.
END.

RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

/*--- DBO Situaá∆o ---*/
IF NOT VALID-HANDLE(hDBOSituacao)      OR
    hDBOSituacao:TYPE <> "PROCEDURE":U OR
    hDBOSituacao:FILE-NAME <> "frbo~\bofr024.p":U THEN DO:
    run frbo/bofr024.p persistent set  hDBOSituacao.
END.

RUN openQueryStatic IN hDBOSituacao (INPUT "Main":U) NO-ERROR.

/*--- DBO Modelo ---*/
IF  NOT VALID-HANDLE(hDBOModelo)     OR
    hDBOModelo:TYPE <> "PROCEDURE":U OR
    hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
    RUN frbo/bofr016.p PERSISTENT SET hDBOModelo.
END.

RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

/*--- DBO Parametros ---*/
IF  NOT VALID-HANDLE(hDBOParam)     OR
    hDBOParam:TYPE <> "PROCEDURE":U OR
    hDBOParam:FILE-NAME <> "frbo/bofr019.p":U THEN DO:
    RUN frbo/bofr019.p PERSISTENT SET hDBOParam.
END.

RUN openQueryStatic IN hDBOParam (INPUT "Main":U) NO-ERROR.

/*--- DBO Movimento Pneus ---*/
IF NOT VALID-HANDLE(hDBOMovtoPneu)     OR
   hDBOMovtoPneu:TYPE <> "PROCEDURE":U OR
   hDBOMovtoPneu:FILE-NAME <> "frbo/bofr074.p":U THEN DO:
    run frbo/bofr074.p persistent set hDBOMovtoPneu.
END.

RUN openQueryStatic IN hDBOMovtoPneu (INPUT "Main":U) NO-ERROR.

/*--- DBO Movimento Componentes ---*/
IF NOT VALID-HANDLE(hDBOMovtoCompon)     OR
   hDBOMovtoCompon:TYPE <> "PROCEDURE":U OR
   hDBOMovtoCompon:FILE-NAME <> "frbo/bofr066.p":U THEN DO:
    run frbo/bofr066.p persistent set hDBOMovtoCompon.
END.

RUN openQueryStatic IN hDBOMovtoCompon (INPUT "Main":U) NO-ERROR.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-cod-eqpto wMaintenance 
PROCEDURE pi-leave-cod-eqpto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN fiDescModelo:SCREEN-VALUE IN FRAME fPage0 = "".

IF AVAIL {&ttTable} THEN DO:
    {method/referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="{&ttTable}.cod-model"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModelo"
        &Frame1="fPage0"}
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSave wMaintenance 
PROCEDURE piSave :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
define variable cAux             as character   no-undo.
define variable cAux1            as character   no-undo.
define variable hProgram         as handle      no-undo.

{method/showmessage.i1}
empty temp-table RowErrors.

assign cDesValor = "".

run goToKey in hDBOParam (input 47).
if  return-value = "OK":U then do:
    run getCharField IN hDBOParam (input "des-valor":U,
                                   output cDesValor).
end.

for first mab-eqpto
    where mab-eqpto.ep-codigo = {&ttTable}.ep-codigo
    and   mab-eqpto.cod-eqpto = {&ttTable}.cod-eqpto no-lock:
end.

run buscaSituacao in {&hDBOTable} (input  {&ttTable}.cod-sit-eqpto:screen-value in frame fPage0,
                                   output iSituacaoAux).

run buscaSituacao in {&hDBOTable} (input  mab-eqpto.cod-sit-eqpto,
                                   output iSituacao).

/** Quando o equipamento est† inativo e o usu†rio deseja ativar o mesmo ir† mostrar mensagem de alerta **/
if  iSituacao = 2 and iSituacaoAux = 1 then do:
    /** Movimentos de Pneus **/
    for each mpn-pneu
        where mpn-pneu.ep-codigo-atual = ttEqpto.ep-codigo
        and   mpn-pneu.cod-eqpto-atual = ttEqpto.cod-eqpto no-lock:
        for last mpn-movto-pneu
            where mpn-movto-pneu.cod-pneu = mpn-pneu.cod-pneu no-lock use-index mpnmvtpn-03:
            run goToKey in hDBOMovtoPneu (input mpn-movto-pneu.num-docto).
            if return-value = "OK":U then do:
                run deleteRecord in hDBOMovtoPneu.
                if return-value = "NOK":U then do:
                    run getRowErrors in hDBOMovtoPneu (output table RowErrors).
                    /** Ignora erro progress de query posicionada no ultimo registro **/
                    for first RowErrors
                        where RowErrors.ErrorNumber = 10
                        and   RowErrors.ErrorType   = "INTERNAL":U exclusive-lock:
                        delete RowErrors.
                    end.
                    if can-find(RowErrors where RowErrors.ErrorSubType = "ERROR":U) then do:
                        {method/showmessage.i2 &Modal=YES}
                    end.
                    run emptyRowErrors in hDBOMovtoPneu.
                end.
            end.
        end.
    end.
    /** Movimentos de Componentes **/
    for each mco-compon
        where mco-compon.ep-codigo-atual = ttEqpto.ep-codigo
        and   mco-compon.cod-eqpto-atual = ttEqpto.cod-eqpto no-lock:
        for last mco-movto-compon
            where mco-movto-compon.cod-compon = mco-compon.cod-compon no-lock by mco-movto-compon.dat-movto:
            run goToKey in hDBOMovtoCompon (input mco-movto-compon.num-docto).
            if return-value = "OK":U then do:
                run deleteRecord in hDBOMovtoCompon.
                if return-value = "NOK":U then do:
                    run getRowErrors in hDBOMovtoCompon (output table RowErrors).
                    /** Ignora erro progress de query posicionada no ultimo registro **/
                    for first RowErrors
                        where RowErrors.ErrorNumber = 10
                        and   RowErrors.ErrorType   = "INTERNAL":U exclusive-lock:
                        delete RowErrors.
                    end.
                    if can-find(RowErrors where RowErrors.ErrorSubType = "ERROR":U) then do:
                        {method/showmessage.i2 &Modal=YES}
                    end.
                    run emptyRowErrors in hDBOMovtoCompon.
                end.
            end.
        end.
    end.

    run verificaComponentes IN {&hDBOTable} (input {&ttTable}.ep-codigo:screen-value in frame fPage0,
                                             input {&ttTable}.cod-eqpto:screen-value in frame fPage0,
                                             input "",
                                             input "",
                                             input "",
                                             input "",
                                             input "",
                                             input no,
                                             input no).
    /*if return-value = "OK":U then do:
        {utp/ut-liter.i "Os Componentes/Pneus deste Equipamento devem ser Manutenidos"}
        assign cAux = return-value.
        {utp/ut-liter.i "Os Componentes/Pneus deste Equipamento devem ser Manutenidos, pois os mesmos est∆o inativos"}
        assign cAux1 = return-value.
        run utp/ut-msgs.p (input "SHOW":U,
                           input 27979, 
                           input cAux + '~~' + cAux1).
    end.*/
end.

if int(cDesValor) = 1 then do:
    if iSituacaoAux = 2 then do:
        /** Busca existencia de pneus ou componentes instalados no equipamento **/
        if can-find(first mpn-pneu
                    where mpn-pneu.ep-codigo-atual = ttEqpto.ep-codigo
                    and   mpn-pneu.cod-eqpto-atual = ttEqpto.cod-eqpto)
            or can-find(first mco-compon
                        where mco-compon.ep-codigo-atual = ttEqpto.ep-codigo
                        and   mco-compon.cod-eqpto-atual = ttEqpto.cod-eqpto) then do:

            {utp/ut-liter.i "Deseja realizar a inativaá∆o dos componentes e pneus do Equipamento"}
            run utp/ut-msgs.p (input "SHOW":U,
                               input 27100,
                               input return-value + "?").

            if return-value = "YES":U then do:
                /*--- Seta cursor do mouse para espera ---*/
                session:set-wait-state("GENERAL":U).
                {&window-name}:sensitive = no.

                /** Chama tela de inativaá∆o de pneus e componentes **/
                run abp/ab0138t.w (input ttEqpto.ep-codigo,
                                   input ttEqpto.cod-eqpto,
                                   input ttEqpto.dat-situacao,
                                   input replace(fi-hra-inativa:screen-value in frame fPage0,":",""),
                                   output c-cod-servico-pneu,
                                   output c-cd-causa-pneu,
                                   output c-cod-situacao-pneu,
                                   output c-cd-causa-compon,
                                   output c-cod-situacao-compon,
                                   output l-entra-media).

                /*--- Seta cursor do mouse para espera ---*/
                session:set-wait-state("":U).
                {&window-name}:sensitive = yes.

                /** Se usu†rio confirmar inativaá∆o dos pneus e componentes **/
                if return-value = "OK":U then do:
                    run verificaComponentes in {&hDBOTable} (input {&ttTable}.ep-codigo:screen-value in frame fPage0,
                                                             input {&ttTable}.cod-eqpto:screen-value in frame fPage0,
                                                             input c-cod-servico-pneu,
                                                             input c-cd-causa-pneu,
                                                             input c-cod-situacao-pneu,
                                                             input c-cd-causa-compon,
                                                             input c-cod-situacao-compon,
                                                             input l-entra-media,
                                                             input yes).
                    run saveRecord in this-procedure.
                end.
            end.
        end.
        else
            run saveRecord in this-procedure.
    end.
    else
        run saveRecord in this-procedure.
end.
else
    run saveRecord in this-procedure.

if valid-handle(hProgram) then
    delete procedure hProgram.

{method/showmessage.i3}

return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSituacao wMaintenance 
PROCEDURE piSituacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN buscaSituacao IN {&hDBOTable} (INPUT  {&ttTable}.cod-sit-eqpto:SCREEN-VALUE IN FRAME fPage0,
                                   OUTPUT iSituacao).

CASE iSituacao:
    WHEN 1 THEN DO:  /** Ativo **/
        ASSIGN ttEqpto.dat-situacao                           = ?
               fi-hra-inativa                                 = "":U
               ttEqpto.dat-situacao:SENSITIVE IN FRAME fPage0 = NO
               fi-hra-inativa:SENSITIVE IN FRAME fPage0       = NO.
        DISP ttEqpto.dat-situacao 
             fi-hra-inativa WITH FRAME fPage0.
    END.
    OTHERWISE DO: /** Inativo ou n∆o encontrado **/
        IF ttEqpto.dat-situacao = ? THEN
            ASSIGN ttEqpto.dat-situacao = TODAY
                   fi-hra-inativa = STRING(TIME,"HH:MM:SS")
                   fi-hra-inativa = REPLACE (fi-hra-inativa,":","").
        IF fi-hra-inativa:SCREEN-VALUE IN FRAME fPage0 = "" THEN DO:
            IF SUBSTRING({&ttTable}.cod-livre-1,19,6) <> "" THEN DO:
                ASSIGN fi-hra-inativa = STRING(SUBSTRING({&ttTable}.cod-livre-1,19,6)).
            END.
            ELSE DO:
                ASSIGN fi-hra-inativa = STRING(TIME,"HH:MM:SS")
                       fi-hra-inativa = REPLACE (fi-hra-inativa,":","").
            END.
        END.

        ASSIGN ttEqpto.dat-situacao:SENSITIVE IN frame fPage0 = YES
               fi-hra-inativa:SENSITIVE       IN FRAME fPage0 = YES.

        DISPLAY ttEqpto.dat-situacao
                fi-hra-inativa WITH FRAME fPage0.
    END.
END CASE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

