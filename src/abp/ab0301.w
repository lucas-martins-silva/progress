&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-apont-aferic-bomba NO-UNDO LIKE mab-control-bomba
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
{include/i-prgvrs.i AB0301 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0301 MAB}
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
&GLOBAL-DEFINE Program        AB0301
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Pag. 1

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

&GLOBAL-DEFINE ttTable        tt-apont-aferic-bomba
&GLOBAL-DEFINE hDBOTable      hDBO-apont-aferic-bomba
&GLOBAL-DEFINE DBOTable       mab-control-bomba

&GLOBAL-DEFINE page0KeyFields tt-apont-aferic-bomba.num-docto
&GLOBAL-DEFINE page0Fields    tt-apont-aferic-bomba.cod-usuar
&GLOBAL-DEFINE page1Fields    tt-apont-aferic-bomba.dat-apont tt-apont-aferic-bomba.hra-apont ~
                              tt-apont-aferic-bomba.cod-posto-orig tt-apont-aferic-bomba.cod-bomba ~
                              tt-apont-aferic-bomba.idi-tip-movto tt-apont-aferic-bomba.val-leitura-inicial ~
                              tt-apont-aferic-bomba.val-leitura-final tt-apont-aferic-bomba.val-quant ~
                              tt-apont-aferic-bomba.cod-posto-dest

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Global Variable Definitions ---                                      */


/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOPosto    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOBomba    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOMaterial AS HANDLE     NO-UNDO.


{abp\ab9000.i} /** Procedures de convers∆o de tempo:
                   piFormataHoraParaSegundo
                   piFormataSegundoParaHora **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-apont-aferic-bomba.num-docto ~
tt-apont-aferic-bomba.cod-usuar 
&Scoped-define ENABLED-TABLES tt-apont-aferic-bomba
&Scoped-define FIRST-ENABLED-TABLE tt-apont-aferic-bomba
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-apont-aferic-bomba.num-docto ~
tt-apont-aferic-bomba.cod-usuar 
&Scoped-define DISPLAYED-TABLES tt-apont-aferic-bomba
&Scoped-define FIRST-DISPLAYED-TABLE tt-apont-aferic-bomba


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

DEFINE BUTTON btSoma 
     IMAGE-UP FILE "image/im-total.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-total.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Somat¢ria".

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

DEFINE VARIABLE fiDescPostoDestino LIKE mab-posto.des-posto
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescPostoOrigem LIKE mab-posto.des-posto
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescTpMaterial LIKE mab-tip-mater.des-tip-mater
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE fiTpMaterial LIKE mab-bomba.cod-tip-mater
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.


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
     btSoma AT ROW 1.13 COL 59 HELP
          "Somat¢ria"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-apont-aferic-bomba.num-docto AT ROW 2.88 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-apont-aferic-bomba.cod-usuar AT ROW 3.88 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     tt-apont-aferic-bomba.dat-apont AT ROW 1.75 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-apont-aferic-bomba.hra-apont AT ROW 1.75 COL 28.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-apont-aferic-bomba.cod-posto-orig AT ROW 2.75 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .88
     fiDescPostoOrigem AT ROW 2.75 COL 27 COLON-ALIGNED NO-LABEL
     tt-apont-aferic-bomba.cod-bomba AT ROW 3.75 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fiTpMaterial AT ROW 4.75 COL 18 COLON-ALIGNED
     fiDescTpMaterial AT ROW 4.75 COL 30.57 COLON-ALIGNED NO-LABEL
     tt-apont-aferic-bomba.idi-tip-movto AT ROW 5.75 COL 20 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Aferiá∆o", 1,
"Transferància", 2,
"Leitura Bomba", 3
          SIZE 36 BY .88
     tt-apont-aferic-bomba.val-leitura-inicial AT ROW 6.75 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-apont-aferic-bomba.val-leitura-final AT ROW 7.75 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-apont-aferic-bomba.val-quant AT ROW 8.75 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-apont-aferic-bomba.cod-posto-dest AT ROW 9.75 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .88
     fiDescPostoDestino AT ROW 9.75 COL 27 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 84.43 BY 10.62
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-apont-aferic-bomba T "?" NO-UNDO movfro mab-control-bomba
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
         HEIGHT             = 17
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
/* SETTINGS FOR BUTTON btSoma IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN fiDescPostoDestino IN FRAME fPage1
   LIKE = mgfro.mab-posto.des-posto EXP-SIZE                            */
/* SETTINGS FOR FILL-IN fiDescPostoOrigem IN FRAME fPage1
   LIKE = mgfro.mab-posto.des-posto EXP-SIZE                            */
/* SETTINGS FOR FILL-IN fiDescTpMaterial IN FRAME fPage1
   LIKE = mgfro.mab-tip-mater.des-tip-mater EXP-SIZE                    */
/* SETTINGS FOR FILL-IN fiTpMaterial IN FRAME fPage1
   LIKE = mgfro.mab-bomba.cod-tip-mater EXP-SIZE                        */
ASSIGN 
       tt-apont-aferic-bomba.val-leitura-inicial:PRIVATE-DATA IN FRAME fPage1     = 
                "0000000000".

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
    apply "ENTRY":U to tt-apont-aferic-bomba.dat-apont in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
    run piAtualizaBotoes in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
    apply "ENTRY":U to tt-apont-aferic-bomba.dat-apont in frame fPage1.
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
    run piAtualizaBotoes in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="frzoom\z01fr056.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSoma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSoma wMaintenance
ON CHOOSE OF btSoma IN FRAME fpage0
DO:
    run piSomatoria in this-procedure.
    apply "ENTRY":U to tt-apont-aferic-bomba.val-quant in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.

    if cAction = "ADD":U then do:
        run afterEnableFields in this-procedure.
        apply "ENTRY":U to tt-apont-aferic-bomba.dat-apont in frame fPage1.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE.
    apply "ENTRY":U to tt-apont-aferic-bomba.dat-apont in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-apont-aferic-bomba.cod-bomba
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-apont-aferic-bomba.cod-bomba wMaintenance
ON F5 OF tt-apont-aferic-bomba.cod-bomba IN FRAME fPage1 /* Bomba */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr002.w"
           &FieldZoom1="cod-bomba"
           &FieldScreen1="{&ttTable}.cod-bomba"
           &Frame1="fPage1"
           &FieldZoom2="cod-tip-mater"
           &FieldScreen2="fiTPMaterial"
           &Frame2="fPage1"
           &RunMethod="run setaPosto in hProgramZoom 
                       (input {&ttTable}.cod-posto-orig:screen-value in frame fPage1)."
           &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-apont-aferic-bomba.cod-bomba wMaintenance
ON LEAVE OF tt-apont-aferic-bomba.cod-bomba IN FRAME fPage1 /* Bomba */
DO:

    {method\referenceFields.i
            &HandleDBOLeave="hDBOBomba"
            &KeyValue1="{&ttTable}.cod-posto-orig:screen-value in frame fPage1"
            &KeyValue2="{&ttTable}.cod-bomba:screen-value in frame fPage1"
            &FieldName1="cod-tip-mater"
            &FieldScreen1="fiTpMaterial"
            &Frame1="fPage1"}
            
    apply "leave":U to fiTpMaterial in frame fPage1.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-apont-aferic-bomba.cod-bomba wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-apont-aferic-bomba.cod-bomba IN FRAME fPage1 /* Bomba */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-apont-aferic-bomba.cod-posto-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-apont-aferic-bomba.cod-posto-dest wMaintenance
ON F5 OF tt-apont-aferic-bomba.cod-posto-dest IN FRAME fPage1 /* Posto Destino */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr021.w"
           &FieldZoom1="cod-posto"
           &FieldScreen1="{&ttTable}.cod-posto-dest"
           &Frame1="fPage1"
           &FieldZoom2="des-posto"
           &FieldScreen2="fiDescPostoDestino"
           &Frame2="fPage1"
           &EnableImplant="YES"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-apont-aferic-bomba.cod-posto-dest wMaintenance
ON LEAVE OF tt-apont-aferic-bomba.cod-posto-dest IN FRAME fPage1 /* Posto Destino */
DO:
   /** Validaá‰es para posto destino **/
   if input frame fPage1 {&tttable}.idi-tip-movto = 2 then do:
       run consistePostoDestino in {&hDBOTable} (input {&ttTable}.cod-posto-orig:screen-value in frame fPage1,    
                                                 input {&ttTable}.cod-bomba:screen-value in frame fPage1,     
                                                 input {&ttTable}.cod-posto-dest:screen-value in frame fPage1).
       if return-value = "NOK":U then do:
            run piMostraErros in this-procedure.
            return no-apply.
       end.
   end.

  {method/referencefields.i                                                           
      &HandleDBOLeave="hDBOPosto"                                                     
      &KeyValue1="{&ttTable}.cod-posto-dest:screen-value in frame fPage1"    
      &FieldName1="des-posto"                                                 
      &FieldScreen1="fiDescPostoDestino"                                               
      &Frame1="fPage1"}                                                               
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-apont-aferic-bomba.cod-posto-dest wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-apont-aferic-bomba.cod-posto-dest IN FRAME fPage1 /* Posto Destino */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-apont-aferic-bomba.cod-posto-orig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-apont-aferic-bomba.cod-posto-orig wMaintenance
ON F5 OF tt-apont-aferic-bomba.cod-posto-orig IN FRAME fPage1 /* Posto Origem */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr021.w"
           &FieldZoom1="cod-posto"
           &FieldScreen1="{&ttTable}.cod-posto-orig"
           &Frame1="fPage1"
           &FieldZoom2="des-posto"
           &FieldScreen2="fiDescPostoOrigem"
           &Frame2="fPage1"
           &EnableImplant="YES"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-apont-aferic-bomba.cod-posto-orig wMaintenance
ON LEAVE OF tt-apont-aferic-bomba.cod-posto-orig IN FRAME fPage1 /* Posto Origem */
DO:
    
    {method\referenceFields.i
        &HandleDBOLeave="hDBOPosto"
        &KeyValue1="{&ttTable}.cod-posto-orig:screen-value in frame fPage1"
        &FieldName1="des-posto"
        &FieldScreen1="fiDescPostoOrigem"
        &Frame1="fPage1"}
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-apont-aferic-bomba.cod-posto-orig wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-apont-aferic-bomba.cod-posto-orig IN FRAME fPage1 /* Posto Origem */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiTpMaterial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiTpMaterial wMaintenance
ON LEAVE OF fiTpMaterial IN FRAME fPage1 /* Tipo Material */
DO:
    {method\referenceFields.i
            &HandleDBOLeave="hDBOMaterial"
            &KeyValue1="fiTpMaterial:screen-value in frame fPage1"
            &FieldName1="des-tip-mater"
            &FieldScreen1="fiDescTpMaterial"
            &Frame1="fPage1"}  
            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-apont-aferic-bomba.hra-apont
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-apont-aferic-bomba.hra-apont wMaintenance
ON LEAVE OF tt-apont-aferic-bomba.hra-apont IN FRAME fPage1 /* hra-apont */
DO:
    def var cHora as char format "99:99:99" no-undo.

    /** Consiste o hor†rio **/
    assign cHora = {&ttTable}.hra-apont:screen-value in frame fPage1.
    run piFormataHorarioSeg (input-output cHora).
    if return-value = "NOK":U then do:
        apply "ENTRY":U to {&ttTable}.hra-apont in frame fPage1.
        return no-apply.
    end.
    assign {&ttTable}.hra-apont:screen-value in frame fPage1 = cHora.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-apont-aferic-bomba.idi-tip-movto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-apont-aferic-bomba.idi-tip-movto wMaintenance
ON VALUE-CHANGED OF tt-apont-aferic-bomba.idi-tip-movto IN FRAME fPage1
DO:
  /** Procedure para habilitar / desabilitar campos em tela **/
  run piTipoMovimento in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-apont-aferic-bomba.val-leitura-final
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-apont-aferic-bomba.val-leitura-final wMaintenance
ON LEAVE OF tt-apont-aferic-bomba.val-leitura-final IN FRAME fPage1 /* Leitura Final */
DO:
  if input frame fPage1 {&tttable}.idi-tip-movto = 2 or
     input frame fPage1 {&tttable}.idi-tip-movto = 1 then do:
    /** Atualiza o campo hora invertida. Ser† gravado no 
    formato "AAAAMMDDHHMM" (Ano+Màs+Dia+Hora+Minuto) **/
    run converteParaHoraInvertida in {&hDBOTable} (input  string(input frame fPage1 {&ttTable}.dat-apont, "99/99/9999"),
                                                   input  input frame fPage1 {&ttTable}.hra-apont,
                                                   output {&ttTable}.val-dat-hora-invrtda).
    /** Calcula a val-quant **/
    run consisteLeitura in {&hDBOTable} (input  {&ttTable}.r-rowid,
                                         input  {&ttTable}.cod-posto-orig:screen-value in frame fPage1,
                                         input  {&ttTable}.cod-bomba:screen-value in frame fPage1,
                                         input  2,  /** Calcula val-quant **/
                                         input  {&ttTable}.val-dat-hora-invrtda,
                                         input  input frame fPage1 {&ttTable}.val-leitura-inicial,
                                         input  input frame fPage1 {&ttTable}.val-leitura-final,
                                         input-output {&ttTable}.val-quant).
    if return-value = "OK":U then
        assign {&ttTable}.val-quant:screen-value in frame fPage1 = string({&ttTable}.val-quant).
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-apont-aferic-bomba.val-leitura-inicial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-apont-aferic-bomba.val-leitura-inicial wMaintenance
ON LEAVE OF tt-apont-aferic-bomba.val-leitura-inicial IN FRAME fPage1 /* Leitura Inicial */
DO:
  if input frame fPage1 {&tttable}.idi-tip-movto = 3 then do:
    /** Atualiza o campo hora invertida. Ser† gravado no 
    formato "AAAAMMDDHHMM" (Ano+Màs+Dia+Hora+Minuto) **/
    run converteParaHoraInvertida in {&hDBOTable} (input  string(input frame fPage1 {&ttTable}.dat-apont, "99/99/9999"),
                                                   input  input frame fPage1 {&ttTable}.hra-apont,
                                                   output {&ttTable}.val-dat-hora-invrtda).

    /** Verifica se a leitura da bomba est† incorreta, ou seja, 
        a bomba pode ter quebrado, para habilitar a val-quant 
        para ser informada, sen∆o, retorna val-quant **/
    run consisteLeitura in {&hDBOTable} (input  {&ttTable}.r-rowid,
                                         input  {&ttTable}.cod-posto-orig:screen-value in frame fPage1,
                                         input  {&ttTable}.cod-bomba:screen-value in frame fPage1,
                                         input  input frame fPage1 {&tttable}.idi-tip-movto,
                                         input  {&ttTable}.val-dat-hora-invrtda,
                                         input  input frame fPage1 {&ttTable}.val-leitura-inicial,
                                         input  input frame fPage1 {&ttTable}.val-leitura-final,
                                         input-output {&ttTable}.val-quant).
    if return-value = "NOK":U then do:
        assign {&ttTable}.val-quant:sensitive in frame fPage1    = yes
               btSoma:sensitive in frame fPage0                  = yes
               {&ttTable}.val-quant:screen-value in frame fPage1 = "0,00".
        run piMostraErros in this-procedure.
    end.
    else
        assign {&ttTable}.val-quant:sensitive in frame fPage1    = no
               btSoma:sensitive in frame fPage0                  = no
               {&ttTable}.val-quant:screen-value in frame fPage1 = string({&ttTable}.val-quant).
  end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-apont-aferic-bomba.val-quant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-apont-aferic-bomba.val-quant wMaintenance
ON LEAVE OF tt-apont-aferic-bomba.val-quant IN FRAME fPage1 /* Quantidade */
DO:
  define variable deQtde as decimal no-undo.
  
  if input frame fPage1 {&tttable}.idi-tip-movto = 1 then do:
    /** Atualiza o campo hora invertida. Ser† gravado no 
    formato "AAAAMMDDHHMM" (Ano+Màs+Dia+Hora+Minuto) **/
    run converteParaHoraInvertida in {&hDBOTable} (input  string(input frame fPage1 {&ttTable}.dat-apont, "99/99/9999"),
                                                   input  input frame fPage1 {&ttTable}.hra-apont,
                                                   output {&ttTable}.val-dat-hora-invrtda).
    /** Verifica se a leitura inicial e final da bomba est† diferente 
        da val-quant informada **/
    assign deQtde = input frame fPage1 {&ttTable}.val-quant.
    run consisteLeitura in {&hDBOTable} (input  {&ttTable}.r-rowid,
                                         input  {&ttTable}.cod-posto-orig:screen-value in frame fPage1,
                                         input  {&ttTable}.cod-bomba:screen-value in frame fPage1,
                                         input  input frame fPage1 {&tttable}.idi-tip-movto,
                                         input  {&ttTable}.val-dat-hora-invrtda,
                                         input  input frame fPage1 {&ttTable}.val-leitura-inicial,
                                         input  input frame fPage1 {&ttTable}.val-leitura-final,
                                         input-output deQtde).
    if return-value = "NOK":U then do:
        run piMostraErros in this-procedure.
    end.

  end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}


tt-apont-aferic-bomba.cod-posto-orig:LOAD-MOUSE-POINTER("image~\lupa.cur":U)  in frame fPage1.
tt-apont-aferic-bomba.cod-posto-dest:LOAD-MOUSE-POINTER("image~\lupa.cur":U) in frame fPage1.
tt-apont-aferic-bomba.cod-bomba:LOAD-MOUSE-POINTER("image~\lupa.cur":U)     in frame fPage1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     Override do MÇtodo Destroy Interface
  Parameters:  <none>
  Notes:       Elimina os handles da mem¢ria
------------------------------------------------------------------------------*/

if valid-handle (hDBOPosto) then
    run destroy in hDBOPosto.

if valid-handle (hDBOBomba) then
    run destroy in hDBOBomba.

if valid-handle (hDBOMaterial) then
    run destroy in hDBOMaterial.

{method/showmessage.i3}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     Override do mÇtodo padr∆o Display Fields
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

apply "LEAVE":U to {&ttTable}.cod-posto-dest in frame fPage1.
apply "LEAVE":U to {&ttTable}.cod-posto-orig  in frame fPage1.
apply "LEAVE":U to {&ttTable}.cod-bomba     in frame fPage1.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenance 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     MÇtodo Override Display Fields (Ap¢s)
  Parameters:  
  Notes:       Mostra valores em tela ap¢s mÇtodo padr∆o
------------------------------------------------------------------------------*/

/** Desabilita campos em tela que n∆o s∆o atualizados pelo usu†rio **/
disable {&ttTable}.num-docto 
        {&ttTable}.cod-usuar
    with frame fPage0.

if cAction = "ADD":U or cAction = "COPY":U then do:
    /** Busca pr¢ximo n£mero do documento **/
    run buscaProximoDocumento in {&hDBOTable} (output {&ttTable}.num-docto).
    /** Busca a hora atual **/
    run piMostraHorario in this-procedure.
end.

/** Busca Usu†rio Corrente do EMS **/
assign {&ttTable}.cod-usuar = c-seg-usuario.

/** pega data atual para c¢pia **/
if cAction = "COPY":U then do:
    assign {&ttTable}.dat-apont = today.
    disp {&ttTable}.dat-apont
       with frame fPage1.
end.

disp {&ttTable}.num-docto
     {&ttTable}.cod-usuar
    with frame fPage0.

/** Verifica campos Tipo Movimento **/
apply "VALUE-CHANGED":U to {&tttable}.idi-tip-movto in frame fPage1.

if cAction = "COPY":U then
    assign {&ttTable}.r-rowid = ?.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenance 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     beforeSaveFields
  Parameters:  <none>
  Notes:       Override do mÇtodo padr∆o, salva valores antes do padr∆o na 
               temp-table
------------------------------------------------------------------------------*/

/** Atualiza o campo hora invertida. Ser† gravado no 
    formato "AAAAMMDDHHMM" (Ano+Màs+Dia+Hora+Minuto) **/
run converteParaHoraInvertida in {&hDBOTable} (input  string(input frame fPage1 {&ttTable}.dat-apont, "99/99/9999"),
                                               input  input frame fPage1 {&ttTable}.hra-apont,
                                               output {&ttTable}.val-dat-hora-invrtda).

return "OK":U.

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
    
    DEFINE VARIABLE i-num-docto LIKE {&ttTable}.num-docto NO-UNDO.
    
    {utp/ut-liter.i "V† Para Documento"}
    DEFINE FRAME fGoToRecord
        i-num-docto       AT ROW 1.21 COL 20 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE return-value FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i " "}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-num-docto.
        
        RUN goToKey IN {&hDBOTable} (INPUT i-num-docto).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i "Controle Bombas"}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT return-value).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-num-docto btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
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
       {&hDBOTable}:FILE-NAME <> "frbo~\bofr056.p":U THEN DO:
        run frbo/bofr056.p persistent set  {&hDBOTable}.
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    /*--- DBO Posto  ---*/
    IF NOT VALID-HANDLE(hDBOPosto) OR
       hDBOPosto:TYPE <> "PROCEDURE":U OR
       hDBOPosto:FILE-NAME <> "frbo~\bofr021.p":U THEN DO:
        run frbo/bofr021.p persistent set  hDBOPosto.
    END.
    
    RUN openQueryStatic IN hDBOPosto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Bomba ---*/
    IF NOT VALID-HANDLE(hDBOBomba) OR
       hDBOBomba:TYPE <> "PROCEDURE":U OR
       hDBOBomba:FILE-NAME <> "frbo~\bofr002.p":U THEN DO:
        run frbo/bofr002.p persistent set  hDBOBomba.
    END.
    
    RUN openQueryStatic IN hDBOBomba (INPUT "Main":U) NO-ERROR.

    /*--- DBO Material ---*/
    IF NOT VALID-HANDLE(hDBOMaterial) OR
       hDBOMaterial:TYPE <> "PROCEDURE":U OR
       hDBOMaterial:FILE-NAME <> "frbo~\bofr026.p":U THEN DO:
        run frbo/bofr026.p persistent set  hDBOMaterial.
    END.
    
    RUN openQueryStatic IN hDBOMaterial (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaBotoes wMaintenance 
PROCEDURE piAtualizaBotoes :
/*------------------------------------------------------------------------------
  Purpose:     piAtualizaBotoes
  Parameters:  <none>
  Notes:       Habilita / Desabilita bot‰es adicionais em tela
------------------------------------------------------------------------------*/

assign btSoma:sensitive in frame fPage0 = no.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wMaintenance 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     piMostraErros
  Parameters:  <none>
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
------------------------------------------------------------------------------*/

/** Instancia aplicativo **/
{method/showmessage.i1}
/** Busca erros na BO **/
run getRowErrors in {&hDBOTable} (output table RowErrors).
/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}
/** Limpa temp-tables de erros **/
run emptyRowErrors in {&hDBOTable}.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraHorario wMaintenance 
PROCEDURE piMostraHorario :
/*------------------------------------------------------------------------------
  Purpose:     piMostraHorario
  Parameters:  <none>
  Notes:       Busca hora atual e mostra em tela
------------------------------------------------------------------------------*/

/** Busca a hora atual **/
run piFormataSegundoParaHora (input  time,
                              output {&ttTable}.hra-apont).
disp {&ttTable}.hra-apont
    with frame fPage1.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSomatoria wMaintenance 
PROCEDURE piSomatoria :
/*------------------------------------------------------------------------------
  Purpose:     piSomatoria
  Parameters:  <none>
  Notes:       Soma os abastecimetos ocorridos entre a £ltima leitura de bomba 
               e a atual.
------------------------------------------------------------------------------*/

/** Atualiza o campo hora invertida. Ser† gravado no 
formato "AAAAMMDDHHMM" (Ano+Màs+Dia+Hora+Minuto) **/
run converteParaHoraInvertida in {&hDBOTable} (input  string(input frame fPage1 {&ttTable}.dat-apont, "99/99/9999"),
                                               input  input frame fPage1 {&ttTable}.hra-apont,
                                               output {&ttTable}.val-dat-hora-invrtda).

/** Verifica se a leitura da bomba est† incorreta, ou seja, 
    a bomba pode ter quebrado, para habilitar a val-quant 
    para ser informada, sen∆o, retorna val-quant **/
run consisteLeitura in {&hDBOTable} (input  {&ttTable}.r-rowid,
                                     input  {&ttTable}.cod-posto-orig:screen-value in frame fPage1,
                                     input  {&ttTable}.cod-bomba:screen-value in frame fPage1,
                                     input  20,   /** Somat¢ria **/
                                     input  {&ttTable}.val-dat-hora-invrtda,
                                     input  input frame fPage1 {&ttTable}.val-leitura-inicial,
                                     input  input frame fPage1 {&ttTable}.val-leitura-final,
                                     input-output {&ttTable}.val-quant).

display {&ttTable}.val-quant
    with frame fPage1.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTipoMovimento wMaintenance 
PROCEDURE piTipoMovimento :
/*------------------------------------------------------------------------------
  Purpose:     piTipoMovimento
  Parameters:  <none>
  Notes:       Habilita campos em tela conforme tipo de movimento
------------------------------------------------------------------------------*/

assign btSoma:sensitive in frame fPage0 = no.

case input frame fPage1 {&tttable}.idi-tip-movto:
    when 1 then
        assign {&ttTable}.val-leitura-final:sensitive  in frame fPage1   = yes
               {&ttTable}.val-leitura-inicial:sensitive  in frame fPage1 = yes
               {&ttTable}.val-quant:sensitive  in frame fPage1           = yes 
               {&ttTable}.cod-posto-dest:sensitive  in frame fPage1      = no.
    when 2 then
        assign {&ttTable}.val-leitura-final:sensitive  in frame fPage1   = yes
               {&ttTable}.val-leitura-inicial:sensitive  in frame fPage1 = yes
               {&ttTable}.val-quant:sensitive  in frame fPage1           = no 
               {&ttTable}.cod-posto-dest:sensitive  in frame fPage1      = yes.
    when 3 then
        assign {&ttTable}.val-leitura-final:sensitive  in frame fPage1   = no 
               {&ttTable}.val-leitura-inicial:sensitive  in frame fPage1 = yes         
               {&ttTable}.val-quant:sensitive  in frame fPage1           = no
               {&ttTable}.cod-posto-dest:sensitive  in frame fPage1      = no       .
               /*btSoma:sensitive in frame fPage0                          = yes. */
end case.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

