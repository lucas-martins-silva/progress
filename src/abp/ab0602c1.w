&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-comptmento-eqpto NO-UNDO LIKE mab-comptmento-eqpto
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
{include/i-prgvrs.i AB0602C1 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0602c1 MAB}
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
&GLOBAL-DEFINE Program        AB0602C1
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Pag.01

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            no
&GLOBAL-DEFINE Copy           no
&GLOBAL-DEFINE Update         no
&GLOBAL-DEFINE Delete         no
&GLOBAL-DEFINE Undo           no
&GLOBAL-DEFINE Cancel         no
&GLOBAL-DEFINE Save           no

&GLOBAL-DEFINE ttTable        tt-mab-comptmento-eqpto
&GLOBAL-DEFINE hDBOTable      hDboCompartimento
&GLOBAL-DEFINE DBOTable       mab-comptmento-eqpto

&GLOBAL-DEFINE page0KeyFields tt-mab-comptmento-eqpto.ep-codigo tt-mab-comptmento-eqpto.cod-eqpto ~
                              tt-mab-comptmento-eqpto.cod-comptmento 
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    tt-mab-comptmento-eqpto.cod-tip-mater tt-mab-comptmento-eqpto.val-km-inicial tt-mab-comptmento-eqpto.cod-sub-sist ~
                              tt-mab-comptmento-eqpto.qtd-capac tt-mab-comptmento-eqpto.idi-remonta tt-mab-comptmento-eqpto.val-perc-remon 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cCodModelo AS CHARACTER  NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE  NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE  NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE  NO-UNDO.
DEFINE VARIABLE hDBOComp      AS HANDLE  NO-UNDO.
DEFINE VARIABLE hDBOMater     AS HANDLE  NO-UNDO.
DEFINE VARIABLE hDBOSist      AS HANDLE  NO-UNDO.
define variable iTipo         as integer no-undo.
define variable lMotor        as logical no-undo.
define variable l-tipo        as logical no-undo.
define variable l-motor       as logical no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-mab-comptmento-eqpto.ep-codigo ~
tt-mab-comptmento-eqpto.cod-eqpto tt-mab-comptmento-eqpto.cod-comptmento 
&Scoped-define ENABLED-TABLES tt-mab-comptmento-eqpto
&Scoped-define FIRST-ENABLED-TABLE tt-mab-comptmento-eqpto
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
c-desc-modelo c-desc-comptmento 
&Scoped-Define DISPLAYED-FIELDS tt-mab-comptmento-eqpto.ep-codigo ~
tt-mab-comptmento-eqpto.cod-eqpto tt-mab-comptmento-eqpto.cod-comptmento 
&Scoped-define DISPLAYED-TABLES tt-mab-comptmento-eqpto
&Scoped-define FIRST-DISPLAYED-TABLE tt-mab-comptmento-eqpto
&Scoped-Define DISPLAYED-OBJECTS c-desc-modelo c-desc-comptmento 

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

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE c-desc-comptmento AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-modelo AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-desc-ssist AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tp-mater AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE cDescUnModel AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE cDescUnTpMatrl AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE fiTipoRemonta AS CHARACTER FORMAT "X(20)":U INITIAL "Tipo Remonta" 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 23 BY 1.25.


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
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-mab-comptmento-eqpto.ep-codigo AT ROW 3 COL 26.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-mab-comptmento-eqpto.cod-eqpto AT ROW 4 COL 26.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-desc-modelo AT ROW 4 COL 39.29 COLON-ALIGNED NO-LABEL
     tt-mab-comptmento-eqpto.cod-comptmento AT ROW 5 COL 26.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-desc-comptmento AT ROW 5 COL 39.29 COLON-ALIGNED NO-LABEL
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     tt-mab-comptmento-eqpto.cod-tip-mater AT ROW 1.67 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     c-desc-tp-mater AT ROW 1.67 COL 25 COLON-ALIGNED NO-LABEL
     tt-mab-comptmento-eqpto.qtd-capac AT ROW 2.67 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     cDescUnTpMatrl AT ROW 2.67 COL 25 COLON-ALIGNED HELP
          "Unidade de Medida" NO-LABEL
     tt-mab-comptmento-eqpto.val-km-inicial AT ROW 3.67 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     cDescUnModel AT ROW 3.67 COL 25 COLON-ALIGNED HELP
          "Unidade do contador do equipamento" NO-LABEL
     tt-mab-comptmento-eqpto.cod-sub-sist AT ROW 4.67 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     c-desc-ssist AT ROW 4.67 COL 25 COLON-ALIGNED NO-LABEL
     tt-mab-comptmento-eqpto.idi-remonta AT ROW 6.5 COL 19 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Normal", 1,
"Anormal", 2
          SIZE 17.29 BY .88
     tt-mab-comptmento-eqpto.val-perc-remon AT ROW 7.79 COL 14.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fiTipoRemonta AT ROW 5.96 COL 16 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 6.21 COL 17
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.25
         SIZE 84.43 BY 8.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mab-comptmento-eqpto T "?" NO-UNDO mgfro mab-comptmento-eqpto
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


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="frzoom\z01fr004.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mab-comptmento-eqpto.cod-comptmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-comptmento-eqpto.cod-comptmento wMaintenance
ON LEAVE OF tt-mab-comptmento-eqpto.cod-comptmento IN FRAME fpage0 /* Compartimento */
DO:
      {method\referenceFields.i
        &HandleDBOLeave="hDBOComp"
        &KeyValue1="tt-mab-comptmento-eqpto.cod-comptmento:screen-value in frame fPage0"
        &FieldName1="des-comptmento"
        &FieldScreen1="c-desc-comptmento"
        &Frame1="fPage0"}
        
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mab-comptmento-eqpto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-comptmento-eqpto.cod-eqpto wMaintenance
ON LEAVE OF tt-mab-comptmento-eqpto.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:

   if avail tt-mab-comptmento-eqpto then do:
    run buscaModelo in this-procedure.
    {method\referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="cCodModelo"
        &FieldName1="des-model"
        &FieldScreen1="c-desc-modelo"
        &Frame1="fPage0"
        &FieldName2="un"
        &FieldScreen2="cDescUnModel"
        &Frame2="fPage1"}          
   end.
   else 
       assign c-desc-modelo:screen-value in frame fPage0 = ""
              cDescUnModel:screen-value in frame fPage1 = "".
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-mab-comptmento-eqpto.cod-sub-sist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-comptmento-eqpto.cod-sub-sist wMaintenance
ON LEAVE OF tt-mab-comptmento-eqpto.cod-sub-sist IN FRAME fPage1 /* Sub-Sistema */
DO:
    {method\referenceFields.i
            &HandleDBOLeave="hDBOSist"
            &KeyValue1="tt-mab-comptmento-eqpto.cod-sub-sist:screen-value in frame fPage1"
            &FieldName1="des-sub-sist"
            &FieldScreen1="c-desc-ssist"
            &Frame1="fPage1"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mab-comptmento-eqpto.cod-tip-mater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-comptmento-eqpto.cod-tip-mater wMaintenance
ON LEAVE OF tt-mab-comptmento-eqpto.cod-tip-mater IN FRAME fPage1 /* Tipo Material */
DO:
    {method\referenceFields.i
            &HandleDBOLeave="hDBOMater"
            &KeyValue1="tt-mab-comptmento-eqpto.cod-tip-mater:screen-value in frame fPage1"
            &FieldName1="des-tip-mater"
            &FieldScreen1="c-desc-tp-mater"
            &Frame1="fPage1"
            &FieldName2="un"
            &FieldScreen2="cDescUnTpMatrl"
            &Frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-mab-comptmento-eqpto.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-comptmento-eqpto.ep-codigo wMaintenance
ON LEAVE OF tt-mab-comptmento-eqpto.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
  APPLY "leave":U TO tt-mab-comptmento-eqpto.cod-eqpto IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

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
{utp/ut-liter.i "Tipo Remonta" MAB}
ASSIGN fiTipoRemonta:SCREEN-VALUE IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i "Remonta" MAB}
ASSIGN {&ttTable}.val-perc-remon:LABEL IN FRAME fPage1 = "% " + RETURN-VALUE.

/** Descri‡äes dos campos **/
apply "LEAVE":U to tt-mab-comptmento-eqpto.cod-eqpto      in frame fPage0.
apply "LEAVE":U to tt-mab-comptmento-eqpto.cod-comptmento in frame fPage0.
apply "LEAVE":U to tt-mab-comptmento-eqpto.cod-tip-mater  in frame fPage1.
apply "LEAVE":U to tt-mab-comptmento-eqpto.cod-sub-sist   in frame fPage1.


return "OK":U.

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
RUN setConstraintEquipamento IN hDboCompartimento (input tt-mab-comptmento-eqpto.ep-codigo,
                                                   INPUT tt-mab-comptmento-eqpto.cod-eqpto) NO-ERROR.

RUN openQueryStatic IN hDboCompartimento (INPUT "Equipamento":U) NO-ERROR.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaModelo wMaintenance 
PROCEDURE buscaModelo :
/*------------------------------------------------------------------------------
  Purpose:     buscaModelo
  Parameters:  <none>
  Notes:       Busca o c¢digo do modelo no equipamento
------------------------------------------------------------------------------*/

{method\referenceFields.i
    &HandleDBOLeave="hDBOEqpto"
    &KeyValue1="tt-mab-comptmento-eqpto.ep-codigo"
    &KeyValue2="tt-mab-comptmento-eqpto.cod-eqpto"
    &FieldName1="cod-model"
    &Variable1="cCodModelo"}
   
return "OK":U.

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
    DEFINE VARIABLE iep-codigo LIKE {&ttTable}.ep-codigo  VIEW-AS FILL-IN SIZE 05.00 BY 0.88 NO-UNDO.
    DEFINE VARIABLE ccod-eqpto LIKE {&ttTable}.cod-eqpto  VIEW-AS FILL-IN SIZE 16.00 BY 0.88 NO-UNDO.
    DEFINE VARIABLE ccod-comptmento LIKE {&ttTable}.cod-comptmento  VIEW-AS FILL-IN SIZE 10.00 BY 0.88 NO-UNDO.

    
    

    DEFINE FRAME fGoToRecord
        iep-codigo  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        ccod-eqpto  AT ROW 2.21 COL 17.72 COLON-ALIGNED
        ccod-comptmento AT ROW 3.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Compartimento do Equipamento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Compartimento_do_Equipamento"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN iep-codigo ccod-eqpto ccod-comptmento.
        
        RUN goToKey IN {&hDBOTable} (INPUT iep-codigo , INPUT ccod-eqpto, input ccod-comptmento ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "V _Para_Compartimento_do_Equipamento" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE iep-codigo ccod-eqpto ccod-comptmento btGoToOK btGoToCancel 
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

   /*--- DBO Compartimento ---*/
   IF NOT VALID-HANDLE(hDboCompartimento) OR
       hDboCompartimento:TYPE <> "PROCEDURE":U OR
       hDboCompartimento:FILE-NAME <> "frbo~\bofr004.p":U THEN DO:
        run frbo/bofr004.p persistent set  hDboCompartimento.
    END.

    RUN openQueryStatic IN hDboCompartimento (INPUT "Main":U) NO-ERROR.

    /*--- DBO Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo~\bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Compartimento ---*/
    IF NOT VALID-HANDLE(hDBOComp) OR
       hDBOComp:TYPE <> "PROCEDURE":U OR
       hDBOComp:FILE-NAME <> "frbo~\bofr003.p":U THEN DO:
        run frbo/bofr003.p persistent set  hDBOComp.
    END.
    
    RUN openQueryStatic IN hDBOComp (INPUT "Main":U) NO-ERROR.

    /*--- DBO Tipo Material  ---*/
    IF NOT VALID-HANDLE(hDBOMater) OR
       hDBOMater:TYPE <> "PROCEDURE":U OR
       hDBOMater:FILE-NAME <> "frbo~\bofr026.p":U THEN DO:
        run frbo/bofr026.p persistent set  hDBOMater.
    END.
    
    RUN openQueryStatic IN hDBOMater (INPUT "Main":U) NO-ERROR.

    /*--- DBO Sub Sistema ---*/
    IF NOT VALID-HANDLE(hDBOSist) OR
       hDBOSist:TYPE <> "PROCEDURE":U OR
       hDBOSist:FILE-NAME <> "frbo~\bofr025.p":U THEN DO:
        run frbo/bofr025.p persistent set  hDBOSist.
    END.
    
    RUN openQueryStatic IN hDBOSist (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

