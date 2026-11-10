&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-event NO-UNDO LIKE mab-event
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
{include/i-prgvrs.i AB0113 2.00.00.019} /*** "010019" 11/07/2024 13:30:46  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0113 MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{cdp/cdcfgman.i} /** Pr‚-processadores **/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0113
&GLOBAL-DEFINE Version        2.00.00.019

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Evento, Integra‡äes

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

&GLOBAL-DEFINE ttTable        TTmab-event   
&GLOBAL-DEFINE hDBOTable      hDBEvent   
&GLOBAL-DEFINE DBOTable       mab-event     

&GLOBAL-DEFINE page0KeyFields TTmab-event.cod-evento 
&GLOBAL-DEFINE page0Fields    TTmab-event.des-evento
&GLOBAL-DEFINE page1Fields TTmab-event.des-abrev ~
                           TTmab-event.cod-grp-event TTmab-event.idi-compon-event ~
                           TTmab-event.idi-valor   
&GLOBAL-DEFINE page2Fields TTmab-event.log-infracao ~
                           TTmab-event.log-integr-ap {&ttTable}.ct-despesa fi-especie tg-agro ~
                           fi-tipo-despesa tg-centrocusto   


/* Local Variable Definitions ---                                       */
{cdp/cdunif001.i} /*vari veis unifica‡Æo de conceito*/
/*unifica‡Æo de conceito - centro de custo e conta contabil*/
DEFINE VARIABLE cContaDespesa AS CHARACTER   NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOGrpEvent AS HANDLE NO-UNDO.
DEFINE VARIABLE iTpValor AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-agro   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-documentos AS LOGICAL    NO-UNDO.


/** Zoom Smart **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-event.cod-evento TTmab-event.des-evento 
&Scoped-define ENABLED-TABLES TTmab-event
&Scoped-define FIRST-ENABLED-TABLE TTmab-event
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btAdd btCopy btUpdate btDelete btUndo btCancel btSave btQueryJoins ~
btReportsJoins btExit btHelp rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS TTmab-event.cod-evento ~
TTmab-event.des-evento 
&Scoped-define DISPLAYED-TABLES TTmab-event
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-event


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
       MENU-ITEM miNext         LABEL "Pr¢&ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "Pes&quisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "A&lterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "Ca&ncelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miQueryJoins   LABEL "C&onsultas"    
       MENU-ITEM miReportsJoins LABEL "Rela&t¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "Sai&r"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "Aj&uda"        .


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
     SIZE 89.86 BY 2.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE cDescGrpEvent AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 37.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.14 BY 4.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.14 BY 4.04.

DEFINE VARIABLE fi-especie AS CHARACTER FORMAT "X(02)":U 
     LABEL "Esp‚cie T¡tulo" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tipo-despesa AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Tipo Despesa" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 4.75.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24 BY 1.75.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 1.75.

DEFINE VARIABLE tg-agro AS LOGICAL INITIAL no 
     LABEL "Integra Agroind£stria" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-centrocusto AS LOGICAL INITIAL yes 
     LABEL "Envia Centro Custo" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.86 BY .83 NO-UNDO.


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
     TTmab-event.cod-evento AT ROW 2.83 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     TTmab-event.des-evento AT ROW 3.83 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.75
         FONT 1.

DEFINE FRAME fPage2
     tg-agro AT ROW 3.21 COL 61.43
     TTmab-event.log-integr-ap AT ROW 3.25 COL 7
          VIEW-AS TOGGLE-BOX
          SIZE 22.29 BY .71
     TTmab-event.ct-despesa AT ROW 4.25 COL 16 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 20 BY .79
     fi-especie AT ROW 4.25 COL 48 COLON-ALIGNED
     fi-tipo-despesa AT ROW 5.25 COL 16 COLON-ALIGNED
     TTmab-event.log-infracao AT ROW 6.17 COL 61.43
          VIEW-AS TOGGLE-BOX
          SIZE 18.14 BY .71
     tg-centrocusto AT ROW 6.25 COL 18
     "EAI" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 2.5 COL 59.43
     "Integra‡Æo Contas Pagar" VIEW-AS TEXT
          SIZE 21 BY .54 AT ROW 2.5 COL 8
     "Infra‡äes" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 5.5 COL 59.43
     RECT-39 AT ROW 2.75 COL 5
     RECT-40 AT ROW 2.75 COL 58
     RECT-41 AT ROW 5.67 COL 58.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 84.43 BY 10.62
         FONT 1.

DEFINE FRAME fPage1
     TTmab-event.des-abrev AT ROW 2.17 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     TTmab-event.cod-grp-event AT ROW 3.21 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     cDescGrpEvent AT ROW 3.21 COL 24.57 COLON-ALIGNED NO-LABEL
     TTmab-event.idi-valor AT ROW 5.75 COL 14.43 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "NÆo Gera Valor", 1,
"Gera Despesa", 2,
"Gera Receita", 3
          SIZE 17 BY 3
     TTmab-event.idi-compon-event AT ROW 5.79 COL 47.14 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "NÆo Interfere Componente", 1,
"Troca Componente", 2,
"Troca Vida Componente", 3
          SIZE 21 BY 3
     "Tipo Valor" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 4.96 COL 13.72
     "Componentes" VIEW-AS TEXT
          SIZE 10.43 BY .54 AT ROW 5 COL 47.43
     RECT-17 AT ROW 5.21 COL 11.29
     RECT-18 AT ROW 5.21 COL 45
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.42
         SIZE 84.43 BY 10.62
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-event T "?" NO-UNDO mgfro mab-event
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
         TITLE              = "Manuten‡Æo  de Eventos"
         HEIGHT             = 16.75
         WIDTH              = 90
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fPage2
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance /* Manuten‡Æo  de Eventos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance /* Manuten‡Æo  de Eventos */
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
    APPLY "leave":U TO TTmab-event.cod-grp-event IN FRAME fPage1.
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
    RUN pi-atualiza IN THIS-PROCEDURE.
    RUN copyRecord IN THIS-PROCEDURE.
    APPLY "leave":U TO TTmab-event.cod-grp-event IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    EMPTY TEMP-TABLE rowerrors.
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
    {method/zoomreposition.i &ProgramZoom="frzoom/z01fr010.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
    if cAction = "COPY":U then
        run pi-atualiza in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE.
    APPLY "leave":U TO TTmab-event.cod-grp-event IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME TTmab-event.cod-grp-event
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-event.cod-grp-event wMaintenance
ON LEAVE OF TTmab-event.cod-grp-event IN FRAME fPage1 /* Grupo Evento */
DO:
  {method/ReferenceFields.i
      &HandleDBOLeave="hDBOGrpEvent"
      &KeyValue1="TTmab-event.cod-grp-event:screen-value in frame fPage1"
      &FieldName1="des-grp-event"
      &FieldScreen1="cDescGrpEvent"
      &Frame1="fPage1"}
      /*** Habilita os campos em tela em fun‡Æo do tipo de valar**/
      run habilitaCampos in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-event.cod-grp-event wMaintenance
ON MOUSE-SELECT-DBLCLICK OF TTmab-event.cod-grp-event IN FRAME fPage1 /* Grupo Evento */
OR f5 OF TTmab-event.cod-grp-event IN FRAME fPage1 DO:

        {method/ZoomFields.i
           &ProgramZoom="frzoom/z01fr012.w"
           &FieldZoom1="cod-grp-event"
           &FieldScreen1="TTmab-event.cod-grp-event"
           &Frame1="fPage1"
           &FieldZoom2="des-grp-event"
           &FieldScreen2="cDescGrpEvent"
           &Frame2="fPage1"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME TTmab-event.ct-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-event.ct-despesa wMaintenance
ON ENTRY OF TTmab-event.ct-despesa IN FRAME fPage2 /* Conta Despesa */
DO:
      ASSIGN {&ttTable}.ct-despesa:FORMAT IN FRAME fPage2 = "x(20)".
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-event.ct-despesa wMaintenance
ON F5 OF TTmab-event.ct-despesa IN FRAME fPage2 /* Conta Despesa */
DO:
        /*unifica‡Æo de conceito centro de custo e sub-conta*/
        IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN 
            RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.    
    
        {utp/ut-liter.i Consumo}
        RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  "",                 /* EMPRESA PADRÇO DO USUµRIO*/
                                                       INPUT  "CEP",              /* MODULO */                                                  
                                                       INPUT  "",                 /* PLANO DE CONTAS */
                                                       INPUT  RETURN-VALUE,       /* FINALIDADES */
                                                       INPUT  TODAY,              /* DATA TRANSACAO */
                                                       OUTPUT v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                       OUTPUT v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                       OUTPUT v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                       OUTPUT TABLE tt_log_erro). /* ERROS */
        
        IF v_cod_cta_ctbl <> "" THEN
                    ASSIGN {&ttTable}.ct-despesa:SCREEN-VALUE IN FRAME fPage2 = v_cod_cta_ctbl .
    
        /*tratamento de erros*/
        IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
          {cdp/cdunif001b.i}
        END.
        END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-event.ct-despesa wMaintenance
ON LEAVE OF TTmab-event.ct-despesa IN FRAME fPage2 /* Conta Despesa */
DO:
        ASSIGN cContaDespesa = INPUT FRAME fPage2 {&ttTable}.ct-despesa.
    
        /*unifica‡Æo de conceito centro de custo e sub-conta*/
        IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN 
            RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.    
    
    
      
        
        RUN pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT        "",                 /* EMPRESA */
                                                       INPUT        "",                 /* PLANO DE CONTAS */
                                                       INPUT-OUTPUT cContaDespesa,      /* CONTA */
                                                       INPUT        TODAY,              /* DATA TRANSACAO */   
                                                       OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                       OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       OUTPUT       v_num_sit_cta_ctbl, /* SITUA°€O DA CONTA */
                                                       OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       OUTPUT TABLE tt_log_erro).       /* ERROS */
        
        ASSIGN {&ttTable}.ct-despesa:SCREEN-VALUE IN FRAME fPage2 = cContaDespesa .
            
        IF p_cod_format_cta_ctbl <> "" THEN
        ASSIGN {&ttTable}.ct-despesa:FORMAT IN FRAME fPage2 = p_cod_format_cta_ctbl NO-ERROR.
    
        IF ttmab-event.log-integr-ap:CHECKED IN FRAME fPage2 THEN DO:
        /*tratamento de erros*/
            IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
            {cdp/cdunif001b.i}
            ASSIGN {&ttTable}.ct-despesa:FORMAT IN FRAME fPage2 = "x(20)" NO-ERROR.
            END.
            ELSE DO:
                IF p_cod_format_cta_ctbl <> "" THEN
                ASSIGN {&ttTable}.ct-despesa:FORMAT IN FRAME fPage2 = p_cod_format_cta_ctbl NO-ERROR.
            END.
        END.
            ELSE DO:
                ASSIGN {&ttTable}.ct-despesa:FORMAT IN FRAME fPage2 = "x(20)" NO-ERROR.
            END.
    
        END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-event.ct-despesa wMaintenance
ON MOUSE-SELECT-DBLCLICK OF TTmab-event.ct-despesa IN FRAME fPage2 /* Conta Despesa */
DO:
        APPLY "f5":U TO SELF.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-especie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-especie wMaintenance
ON F5 OF fi-especie IN FRAME fPage2 /* Esp‚cie T¡tulo */
DO:
      {include/zoomvar.i &prog-zoom=adzoom/z01ad104.w
                     &campo=fi-especie
                     &campozoom=cod-esp
                     &frame=fPage2}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-especie wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-especie IN FRAME fPage2 /* Esp‚cie T¡tulo */
DO:
  APPLY "f5":U TO fi-especie IN FRAME fPage2. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-tipo-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tipo-despesa wMaintenance
ON F5 OF fi-tipo-despesa IN FRAME fPage2 /* Tipo Despesa */
DO:
      {include/zoomvar.i &prog-zoom=adzoom/z01ad259.w
                     &campo=fi-tipo-despesa
                     &campozoom=tp-codigo
                     &frame=fPage2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tipo-despesa wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-tipo-despesa IN FRAME fPage2 /* Tipo Despesa */
DO:
    APPLY "f5":U TO fi-tipo-despesa IN FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-event.log-integr-ap
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-event.log-integr-ap wMaintenance
ON VALUE-CHANGED OF TTmab-event.log-integr-ap IN FRAME fPage2 /* Integra‡Æo Contas Pagar */
DO:
  /*habilita o campo Conta Despesa caso o toggle Integra Contas a Pagar seja marcado*/
  IF ttmab-event.log-integr-ap:CHECKED IN FRAME fPage2 THEN DO:
      ASSIGN {&ttTable}.ct-despesa:SENSITIVE IN FRAME fPage2 = YES
             fi-tipo-despesa:SENSITIVE IN FRAME fPage2  = YES
             fi-especie:SENSITIVE IN FRAME fPage2       = YES
             tg-centrocusto:SENSITIVE IN FRAME fpage2   = YES.
  END.
  ELSE DO:
      ASSIGN {&ttTable}.ct-despesa:SENSITIVE IN FRAME fPage2    = NO
             fi-especie:SENSITIVE IN FRAME fPage2          = NO
             fi-tipo-despesa:SENSITIVE IN FRAME fPage2     = NO
             tg-centrocusto:SENSITIVE IN FRAME fpage2      = NO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


TTmab-event.cod-grp-event:load-mouse-pointer ("image/lupa.cur") in frame fPage1.
{&ttTable}.ct-despesa:LOAD-MOUSE-POINTER("image/lupa.cur":U)    in frame fPage2.
fi-tipo-despesa:LOAD-MOUSE-POINTER("image/lupa.cur":U)          in frame fPage2.
fi-especie:LOAD-MOUSE-POINTER("image/lupa.cur":U)               in frame fPage2.

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}


   IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (INPUT "" ,
                                                   INPUT "" ,
                                                   INPUT TODAY ,
                                                   OUTPUT p_cod_format_cta_ctbl,
                                                   OUTPUT TABLE tt_log_erro ).
    
   /* {cdp/cdunif001b.i} */
    

      IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
          DELETE OBJECT h_api_cta_ctbl.
      END.


ASSIGN ct-despesa:format in frame fPage2 = IF ct-despesa:SCREEN-VALUE IN FRAME fPage2 <> "" THEN p_cod_format_cta_ctbl  ELSE "X(20)".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override ap¢s fechar o programa
------------------------------------------------------------------------------*/
/** Grupo de Evento **/
IF VALID-HANDLE (hDBOGrpEvent) THEN
    RUN destroy IN hDBOGrpEvent.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override ap¢s mostrar campos em tela
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE rowerrors.
APPLY "LEAVE":U TO TTmab-event.cod-grp-event IN FRAME fPage1.

/** Descri‡Æo **/
DO WITH FRAME fPage2:
    if not(l-documentos) then DO:
        ASSIGN TTmab-event.log-integr-ap:HIDDEN = YES
               {&ttTable}.ct-despesa:HIDDEN          = YES
               fi-tipo-despesa:HIDDEN           = YES
               fi-especie:HIDDEN                = YES
               TTmab-event.log-infracao:HIDDEN  = YES.
    END.
    ELSE DO:
        IF AVAIL TTmab-event THEN
            ASSIGN fi-especie       = substring(TTmab-event.cod-livre-1,9,2)
                   fi-tipo-despesa  = int(substring(TTmab-event.cod-livre-1,11,3)).
        ELSE
            ASSIGN fi-especie       = "":U
                   fi-tipo-despesa  = 0.
        DISP {&ttTable}.ct-despesa fi-especie fi-tipo-despesa.
    END.
END.

IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT "",
                                                   INPUT "",
                                                   INPUT TODAY,
                                                   OUTPUT p_cod_format_cta_ctbl,
                                                   OUTPUT TABLE tt_log_erro).

{cdp/cdunif001b.i}
  

assign {&ttTable}.ct-despesa:format in frame fPage2 = IF {&ttTable}.ct-despesa:SCREEN-VALUE IN FRAME fPage2 <> "" THEN p_cod_format_cta_ctbl  ELSE "X(20)".

RUN habilitaCampos IN THIS-PROCEDURE.

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
IF AVAIL {&ttTable} THEN DO:
    /** Manuten‡Æo de Documentos **/  
    if not(l-documentos) then do:
        disable {&ttTable}.log-infracao with frame fPage2.
        disable {&ttTable}.log-integr-ap with frame fPage2.
        DISABLE {&ttTable}.ct-despesa WITH FRAME fPage2.
        DISABLE fi-tipo-despesa  WITH FRAME fPage2.
        DISABLE fi-especie       WITH FRAME fPage2.
    END.
    else do:
        enable {&ttTable}.log-infracao with frame fPage2.
        enable {&ttTable}.log-integr-ap with frame fPage2.
        IF {&ttTable}.log-integr-ap:CHECKED IN FRAME fPage2 THEN DO:
            ENABLE {&ttTable}.ct-despesa WITH FRAME fPage2.
            ENABLE fi-tipo-despesa  WITH FRAME fPage2.
            ENABLE fi-especie       WITH FRAME fPage2.
        END.
        ELSE DO:
            DISABLE {&ttTable}.ct-despesa WITH FRAME fPage2.
            DISABLE fi-tipo-despesa  WITH FRAME fPage2.
            DISABLE fi-especie       WITH FRAME fPage2.
        END.
    END.
END.

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
{utp/ut-liter.i Evento_de_Infra‡Æo * }
assign {&ttTable}.log-infracao:label in frame fpage2 = trim(return-value).

{utp/ut-liter.i Integra‡Æo_Contas_a_Pagar * }
assign {&ttTable}.log-integr-ap:label in frame fpage2 = trim(return-value).

{utp/ut-liter.i Conta_Despesa * }
assign {&ttTable}.ct-despesa:label in frame fpage2 = trim(return-value).

{utp/ut-liter.i Tipo_Despesa * }
assign fi-tipo-despesa:label in frame fpage2 = trim(return-value).

{utp/ut-liter.i Esp‚cie_T¡tulo * }
assign fi-especie:label in frame fpage2 = trim(return-value).

{utp/ut-liter.i Integra_Agroind£stria * }
assign tg-agro:label in frame fpage2 = trim(return-value).


{utp/ut-liter.i Envia_Centro_Custo * }
assign tg-centrocusto:label in frame fpage2 = trim(return-value).

APPLY "LEAVE":U TO TTmab-event.cod-grp-event IN FRAME fPage1.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenance 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override antes de abrir a tela
------------------------------------------------------------------------------*/
/** M¢dulo Documentos **/
run cdp/cd9902.p (input 7).
IF RETURN-VALUE = "OK":U THEN 
    ASSIGN l-documentos = YES.

/** Verifica se Agroind£stria est  implantado **/
find first param-global no-lock no-error.
IF AVAIL param-global THEN DO:
    &IF DEFINED (bf_man_206) &THEN
    if param-global.ind-int-agro THEN 
    &ELSE        
    if substring(param-global.char-2,21,1) = "1":U then
    &endif
        assign l-agro = YES.
    else assign l-agro = NO.
END.

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

/**busca o tipo de paramametro***/
run gotoKey in hDBOGrpEvent (input input frame fPage1 {&ttTable}.cod-grp-event).
run getIntField in hDBOGrpEvent (input "idi-tip":U, output iTpValor ).

IF iTpValor <> 5 THEN
    /*Limpa os campos que vao ficar desabilitados, caso o evento nao seja de Custos*/
    ASSIGN /*{&tttable}.idi-compon-event:screen-value IN FRAME fPage0 = "1":U
           {&tttable}.idi-valor:screen-value IN FRAME fPage0 = "1":U*/
           TTmab-event.log-integr-ap:CHECKED IN FRAME fPage2 = NO
           {&ttTable}.log-infracao:CHECKED IN FRAME fPage2 = NO
           {&ttTable}.ct-despesa = "":U
           {&ttTable}.ct-despesa:SCREEN-VALUE IN FRAME fPage2 = "":U
           fi-especie = "":U
           fi-especie:SCREEN-VALUE IN FRAME fPage2 = "":U
           OVERLAY(TTmab-event.cod-livre-1,9,2) = "":U
           fi-tipo-despesa = 0
           fi-tipo-despesa:SCREEN-VALUE IN FRAME fPage2 = "0":U
           OVERLAY(TTmab-event.cod-livre-1,11,3) = "":U.
ELSE
    IF TTmab-event.log-integr-ap:CHECKED IN FRAME fPage2 THEN
        ASSIGN OVERLAY(TTmab-event.cod-livre-1,9,2)  = fi-especie:SCREEN-VALUE IN FRAME fPage2
               OVERLAY(TTmab-event.cod-livre-1,11,3) = fi-tipo-despesa:SCREEN-VALUE IN FRAME fPage2.
    ELSE
        ASSIGN OVERLAY(TTmab-event.cod-livre-1,9,2)  = "":U
               OVERLAY(TTmab-event.cod-livre-1,11,3) = "":U.
        
IF l-agro THEN
    ASSIGN {&ttTable}.log-livre-1 = tg-agro:CHECKED IN FRAME fPage2.
    ASSIGN {&ttTable}.log-livre-2 = tg-centrocusto:CHECKED IN FRAME fPage2.

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
    

    DEFINE VARIABLE  cCodEvent  LIKE  {&ttTable}.cod-evento
           VIEW-AS FILL-IN SIZE 14.00 BY 0.88 NO-UNDO.
    

     
    
    DEFINE FRAME fGoToRecord
        cCodEvent AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Eventos" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Eventos"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN  cCodEvent.
        
 



        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOTable} (INPUT cCodEvent).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Evento" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cCodEvent   btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.

     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitaCampos wMaintenance 
PROCEDURE habilitaCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAIL {&ttTable} THEN DO:
    ASSIGN tg-agro = {&ttTable}.log-livre-1
           tg-agro:HIDDEN IN FRAME fPage2 = NOT(l-agro)
           tg-centrocusto = {&ttTable}.log-livre-2.
    DISP tg-centrocusto WITH FRAME fPage2.
END.

IF l-agro THEN DISPLAY tg-agro WITH FRAME fPage2.

/** Busca o tipo de paramametro **/
run gotoKey     in hDBOGrpEvent (input input frame fPage1 {&ttTable}.cod-grp-event).
run getIntField in hDBOGrpEvent (input "idi-tip":U, output iTpValor).
if cAction = "ADD":U    or 
   cAction = "COPY":U   or 
   cAction = "UPDATE":U then do:

    /** Evento do tipo de Custos **/
    if iTpValor =  5 THEN DO with frame fPage1:
        ASSIGN {&tttable}.idi-compon-event:sensitive = NO
               {&tttable}.idi-valor:sensitive        = YES
               tg-agro:SENSITIVE                     = l-agro.
        
        /** Verifica se o m¢dulo manuten‡Æo de documentos esta implantado **/
        if not(l-documentos) then DO:
            IF AVAIL {&ttTable} THEN DO:
                ASSIGN {&ttTable}.log-integr-ap:HIDDEN = YES
                       {&ttTable}.ct-despesa:HIDDEN         = YES
                       fi-tipo-despesa:HIDDEN          = YES
                       fi-especie:HIDDEN               = YES
                       {&ttTable}.log-infracao:HIDDEN  = YES
                       tg-centrocusto:HIDDEN            = YES.
            END.
        END.
        /** M¢dulo de documentos Implantado **/
        ELSE DO:
            ASSIGN {&ttTable}.log-infracao:SENSITIVE  = YES 
                   {&ttTable}.log-integr-ap:SENSITIVE = YES.

            IF {&ttTable}.log-integr-ap:CHECKED THEN
                ASSIGN {&ttTable}.ct-despesa:SENSITIVE = YES
                       fi-tipo-despesa:SENSITIVE  = YES
                       fi-especie:SENSITIVE       = YES
                       tg-centrocusto:SENSITIVE   = YES.
            ELSE
                ASSIGN {&ttTable}.ct-despesa:SENSITIVE = NO
                       fi-tipo-despesa:SENSITIVE  = NO
                       fi-especie:SENSITIVE       = NO
                       tg-centrocusto:SENSITIVE   = NO. 
        END.
    END. /*if iTpValor =  5 */
    ELSE DO with frame fPage2:
        ASSIGN tg-agro:SENSITIVE = NO
               tg-centrocusto:SENSITIVE = NO. 

        /** Evento do tipo Manuten‡Æo mecƒnica**/
        IF iTpValor = 3 THEN
            ASSIGN {&tttable}.idi-compon-event:sensitive = YES.
        ELSE
            ASSIGN {&tttable}.idi-compon-event:sensitive    = NO
                   {&tttable}.idi-compon-event:screen-value = "1":U.
            
        ASSIGN /*{&tttable}.idi-compon-event:sensitive = IF iTpValor = 3 THEN YES ELSE NO /*s¢ habilita qdo for Manut. Mecanica.*/ */
               {&tttable}.idi-valor:sensitive        = NO
               /*{&tttable}.idi-compon-event:screen-value = "1":U*/
               {&tttable}.idi-valor:screen-value        = "1":U.
       if not(l-documentos) then DO:
           IF AVAIL {&ttTable} THEN DO:
               ASSIGN {&ttTable}.log-integr-ap:HIDDEN = YES
                      {&ttTable}.ct-despesa:HIDDEN         = YES
                      fi-tipo-despesa:HIDDEN          = YES
                      fi-especie:HIDDEN               = YES
                      {&ttTable}.log-infracao:HIDDEN  = YES
                      tg-centrocusto:HIDDEN           = YES.
           END.
       END.
       ELSE DO:
           ASSIGN {&ttTable}.log-infracao:SENSITIVE  = NO
                  {&ttTable}.log-infracao:CHECKED    = NO
                  {&ttTable}.ct-despesa:SENSITIVE         = NO
                  {&ttTable}.ct-despesa:SCREEN-VALUE      = "":U
                  fi-tipo-despesa:SENSITIVE          = NO
                  fi-tipo-despesa:SCREEN-VALUE       = "0":U
                  fi-especie:SENSITIVE               = NO
                  fi-especie:SCREEN-VALUE            = "":U
                  tg-centrocusto:SENSITIVE           = NO
                  tg-centrocusto:CHECKED             = YES
                  {&ttTable}.log-integr-ap:SENSITIVE = NO
                  {&ttTable}.log-integr-ap:CHECKED   = NO.
       END.
                                             
    end. /*do else do if iTpValor =  5*/
end. /*if cAction*/
/** se for ADD o campo Envia Centro Custo fica marcado**/
 IF tg-centrocusto:SENSITIVE = YES AND cAction = "ADD":U THEN
    ASSIGN tg-centrocusto = YES.

return "OK":U.

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
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "frbo/bofr010.p":U THEN DO:
        run "frbo/bofr010.p" persistent set {&hDBOTable}.
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(hDBOGrpEvent) OR
       hDBOGrpEvent:TYPE <> "PROCEDURE":U OR
       hDBOGrpEvent:FILE-NAME <> "frbo/bofr012.p":U THEN DO:
        run "frbo/bofr012.p" persistent set hDBOGrpEvent.
    END.
    
    RUN openQueryStatic IN hDBOGrpEvent (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza wMaintenance 
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     pi-atualiza
  Parameters:  <none>
  Notes:       Atualiza campos descri‡Æo para branco ap¢s uma c¢pia
------------------------------------------------------------------------------*/
IF AVAIL TTmab-event THEN 
    ASSIGN cDescGrpEvent:SCREEN-VALUE    IN FRAME fPage1 = "":U
           {&ttTable}.ct-despesa:SCREEN-VALUE IN FRAME fPage2 = "":U
           fi-tipo-despesa:SCREEN-VALUE  IN FRAME fPage2 = "0":U
           fi-especie:SCREEN-VALUE       IN FRAME fPage2 = "":U.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

