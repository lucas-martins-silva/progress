&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-item-docto-import NO-UNDO LIKE item-docto-import
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
{include/i-prgvrs.i IM0071 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0071 MIM}
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

{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0071
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE Folder         NO

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

&GLOBAL-DEFINE ttTable        tt-item-docto-import 
&GLOBAL-DEFINE hDBOTable      hDBOitem-docto-import
&GLOBAL-DEFINE DBOTable       item-docto-import

&GLOBAL-DEFINE page0KeyFields 
&GLOBAL-DEFINE page0Fields tt-item-docto-import.it-codigo tt-item-docto-import.cod-pais tt-item-docto-import.cod-emitente tt-item-docto-import.cod-docto 
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

/* Global Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE wh-pesquisa        AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-return-item-desc AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-return-nome-pais AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-return-nome-emit AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-return-des-docto AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-return           AS CHARACTER  NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}   AS HANDLE NO-UNDO.

DEFINE VARIABLE h-boin172      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boun006      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad098na    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx342      AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-item-docto-import.it-codigo ~
tt-item-docto-import.cod-pais tt-item-docto-import.cod-emitente ~
tt-item-docto-import.cod-docto 
&Scoped-define ENABLED-TABLES tt-item-docto-import
&Scoped-define FIRST-ENABLED-TABLE tt-item-docto-import
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-item-docto-import.it-codigo ~
tt-item-docto-import.cod-pais tt-item-docto-import.cod-emitente ~
tt-item-docto-import.cod-docto 
&Scoped-define DISPLAYED-TABLES tt-item-docto-import
&Scoped-define FIRST-DISPLAYED-TABLE tt-item-docto-import
&Scoped-Define DISPLAYED-OBJECTS c-desc-item c-nome-pais c-nome-emit ~
c-des-docto 

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
     LABEL "pdate" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE c-des-docto AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-pais AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 4.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .


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
     tt-item-docto-import.it-codigo AT ROW 2.83 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     c-desc-item AT ROW 2.83 COL 30 COLON-ALIGNED NO-LABEL
     tt-item-docto-import.cod-pais AT ROW 3.83 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-nome-pais AT ROW 3.83 COL 20 COLON-ALIGNED NO-LABEL
     tt-item-docto-import.cod-emitente AT ROW 4.83 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-nome-emit AT ROW 4.83 COL 23 COLON-ALIGNED NO-LABEL
     tt-item-docto-import.cod-docto AT ROW 5.83 COL 12.72 COLON-ALIGNED
          LABEL "Documento":R20
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     c-des-docto AT ROW 5.83 COL 30 COLON-ALIGNED NO-LABEL
     rtKeys AT ROW 2.5 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 6.46
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-item-docto-import T "?" NO-UNDO mgcex item-docto-import
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
         HEIGHT             = 6.46
         WIDTH              = 90
         MAX-HEIGHT         = 28
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28
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
/* SETTINGS FOR FILL-IN c-des-docto IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-emit IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-pais IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-item-docto-import.cod-docto IN FRAME fpage0
   EXP-LABEL                                                            */
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
    {method/zoomreposition.i &ProgramZoom="cxzoom/z01cx343.w"}
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
ON CHOOSE OF btUpdate IN FRAME fpage0 /* pdate */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-item-docto-import.cod-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-docto-import.cod-docto wMaintenance
ON F5 OF tt-item-docto-import.cod-docto IN FRAME fpage0 /* Documento */
DO:
    {method/ZoomFields.i
        &ProgramZoom="cxzoom/z01cx342.w"
        &FieldZoom1="cod-docto"
        &FieldScreen1="tt-item-docto-import.cod-docto"
        &Frame1="fPage0"
        &FieldZoom2="des-docto"
        &FieldScreen2="c-des-docto"
        &Frame2="fPage0"
        &EnableImplant="no"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-docto-import.cod-docto wMaintenance
ON LEAVE OF tt-item-docto-import.cod-docto IN FRAME fpage0 /* Documento */
DO:
    RUN setConstraintCodigo IN h-bocx342 (INPUT tt-item-docto-import.cod-docto:SCREEN-VALUE IN FRAME fPage0,
                                          INPUT tt-item-docto-import.cod-docto:SCREEN-VALUE IN FRAME fPage0).
    RUN openQueryStatic IN h-bocx342 (INPUT "Codigo":U).
    RUN getCharField    IN h-bocx342 (INPUT "des-docto", 
                                      OUTPUT c-return-des-docto).
    ASSIGN c-des-docto:SCREEN-VALUE IN FRAME fPage0 = c-return-des-docto.
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-docto-import.cod-docto wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-item-docto-import.cod-docto IN FRAME fpage0 /* Documento */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-item-docto-import.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-docto-import.cod-emitente wMaintenance
ON F5 OF tt-item-docto-import.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
    {include/zoomvar.i
           &prog-zoom="adzoom/z01ad098.w"
           &campo="tt-item-docto-import.cod-emitente"
           &campozoom="cod-emitente"
           &frame="fPage0"
           &campo2="c-nome-emit"
           &campozoom2="nome-emit"
           &Frame2="fPage0"
           &EnableImplant=NO}
           
           
                
                   


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-docto-import.cod-emitente wMaintenance
ON LEAVE OF tt-item-docto-import.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
  RUN goToKey IN h-boad098na (INPUT tt-item-docto-import.cod-emitente:SCREEN-VALUE IN FRAME fPage0).
  
    IF RETURN-VALUE = "OK" THEN DO:        
      RUN getCharField IN h-boad098na (INPUT "nome-emit",
                                       OUTPUT c-return-nome-emit).
     ASSIGN c-nome-emit:SCREEN-VALUE IN FRAME fPage0 = c-return-nome-emit.
  END.
  ELSE
       ASSIGN c-nome-emit:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-docto-import.cod-emitente wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-item-docto-import.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-item-docto-import.cod-pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-docto-import.cod-pais wMaintenance
ON F5 OF tt-item-docto-import.cod-pais IN FRAME fpage0 /* C¢digo do Pa¡s */
DO:
  {include/zoomvar.i
       &prog-zoom="unzoom/z01un006.w"
       &campo="tt-item-docto-import.cod-pais"
       &campozoom="cod-pais"
       &frame="fPage0"
       &campo2="c-nome-pais"
       &campozoom2="nome-pais"
       &Frame2="fPage0"
       &EnableImplant=NO}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-docto-import.cod-pais wMaintenance
ON LEAVE OF tt-item-docto-import.cod-pais IN FRAME fpage0 /* C¢digo do Pa¡s */
DO:
    RUN findCh_Pais IN h-boun006 (INPUT INT(tt-item-docto-import.cod-pais:SCREEN-VALUE IN FRAME fPage0), 
                                OUTPUT c-return).
    IF c-return = "" THEN DO:
        RUN getCharField IN h-boun006 (INPUT "nome-pais", 
                                       OUTPUT c-return-nome-pais).
        ASSIGN c-nome-pais:SCREEN-VALUE IN FRAME fPage0 = c-return-nome-pais.
    END.
    ELSE 
        ASSIGN c-nome-pais:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-docto-import.cod-pais wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-item-docto-import.cod-pais IN FRAME fpage0 /* C¢digo do Pa¡s */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-item-docto-import.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-docto-import.it-codigo wMaintenance
ON F5 OF tt-item-docto-import.it-codigo IN FRAME fpage0 /* Item */
DO:
  {include/zoomvar.i
           &prog-zoom="inzoom/z02in172.w"
           &campo="tt-item-docto-import.it-codigo"
           &campozoom="it-codigo"
           &frame="fPage0"
           &campo2="c-desc-item"
           &campozoom2="desc-item"
           &Frame2="fPage0"
           &EnableImplant=NO}
 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-docto-import.it-codigo wMaintenance
ON LEAVE OF tt-item-docto-import.it-codigo IN FRAME fpage0 /* Item */
DO:
    RUN setConstraintFiltroItCodigo IN h-boin172 (INPUT tt-item-docto-import.it-codigo:SCREEN-VALUE IN FRAME fPage0,
                                                  INPUT tt-item-docto-import.it-codigo:SCREEN-VALUE IN FRAME fPage0).
    RUN openQueryStatic IN h-boin172 (INPUT "ByItCodigo":U).
    RUN getCharField    IN h-boin172 (INPUT "desc-item", 
                                          OUTPUT c-return-item-desc).
    ASSIGN c-desc-item:SCREEN-VALUE IN FRAME fPage0 = c-return-item-desc.
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-docto-import.it-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-item-docto-import.it-codigo IN FRAME fpage0 /* Item */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

    
/*--- Seta cursor do mousr para lupa, quando estiver posicionado sobre o fill-in ---*/
tt-item-docto-import.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-item-docto-import.cod-pais:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-item-docto-import.cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-item-docto-import.cod-docto:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

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
    IF VALID-HANDLE(h-boin172) THEN DO:
        DELETE PROCEDURE h-boin172.
        ASSIGN h-boin172 = ?.
    END.
    
    IF VALID-HANDLE(h-boun006) THEN DO:
        DELETE PROCEDURE h-boun006.
        ASSIGN h-boun006 = ?.
    END.
    
    IF VALID-HANDLE(h-boad098na) THEN DO: 
        DELETE PROCEDURE h-boad098na.
        ASSIGN h-boad098na = ?.
    END.
    
    
    IF VALID-HANDLE(h-bocx342) THEN DO:
        DELETE PROCEDURE h-bocx342.
        ASSIGN h-bocx342 = ?.
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

    APPLY "LEAVE" TO tt-item-docto-import.it-codigo    IN FRAME fPage0.
    APPLY "LEAVE" TO tt-item-docto-import.cod-pais     IN FRAME fPage0.
    APPLY "LEAVE" TO tt-item-docto-import.cod-emitente IN FRAME fPage0.
    APPLY "LEAVE" TO tt-item-docto-import.cod-docto    IN FRAME fPage0.

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
    
    DEFINE VARIABLE cit-codigo    LIKE {&tttable}.it-codigo NO-UNDO.
    DEFINE VARIABLE ccod-pais     LIKE {&ttTable}.cod-pais NO-UNDO.
    DEFINE VARIABLE icod-emitente LIKE {&ttTable}.cod-emitente NO-UNDO.
    DEFINE VARIABLE ccod-docto    LIKE {&ttTable}.cod-docto LABEL "Documento" NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        cit-codigo    AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 17 BY 0.88
        ccod-pais     AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 07 BY 0.88
        icod-emitente AT ROW 3.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 10 BY 0.88
        ccod-docto    AT ROW 4.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 17 BY 0.88
        btGoToOK      AT ROW 5.63 COL 2.14
        btGoToCancel  AT ROW 5.63 COL 13
        rtGoToButton  AT ROW 5.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Item X Documento Importa‡Æo" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
        
        RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
        {utp/ut-liter.i "V _Para_Item_X_Documento_Importa‡Æo"}
        ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.

    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cit-codigo ccod-pais icod-emitente ccod-docto.
        
        RUN goToKey IN {&hDBOTable} (INPUT cit-codigo,   
                                           icod-emitente,
                                           ccod-pais,    
                                           ccod-docto).  
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i " Item_X_Documento_Importa‡Æo"}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cit-codigo 
           ccod-pais 
           icod-emitente 
           ccod-docto 
           btGoToOK 
           btGoToCancel 
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
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
        {btb/btb008za.i1 cxbo~\bocx343.p YES}
        {btb/btb008za.i2 cxbo~\bocx343.p '' {&hDBOTable}}
    END.
    
    /*RUN setConstraintMain IN {&hDBOTable} NO-ERROR.*/
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-boin172) THEN
        RUN inbo/boin172.p PERSISTENT SET h-boin172.

    IF NOT VALID-HANDLE(h-boun006) THEN
        RUN unbo/boun006.p PERSISTENT SET h-boun006.

    IF NOT VALID-HANDLE(h-boad098na) THEN
        RUN adbo/boad098na.p PERSISTENT SET h-boad098na.

    RUN openQueryStatic IN h-boad098na ("Main":U).

    IF NOT VALID-HANDLE(h-bocx342) THEN
        RUN cxbo/bocx342.p PERSISTENT SET h-bocx342.
    
    &IF '{&mgdis_version}' < '2.06f' &THEN
        /*Tecnica para implementar valida‡Æo produto Estendido*/
        {cdp/cdapi558.i1}
    &endif
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

