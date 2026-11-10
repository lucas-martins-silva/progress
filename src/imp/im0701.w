&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-docum-est NO-UNDO LIKE docum-est
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-docum-est-cex NO-UNDO LIKE docum-est-cex
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0701 2.00.00.001}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0701 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0701
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Doc Imp

&GLOBAL-DEFINE First          NO
&GLOBAL-DEFINE Prev           NO
&GLOBAL-DEFINE Next           NO
&GLOBAL-DEFINE Last           NO
&GLOBAL-DEFINE GoTo           NO
&GLOBAL-DEFINE Search         NO

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        tt-docum-est
&GLOBAL-DEFINE hDBOTable      h-boin090
&GLOBAL-DEFINE DBOTable       docum-est

&GLOBAL-DEFINE page0KeyFields tt-docum-est.cod-emitente tt-docum-est.serie-docto tt-docum-est.nro-docto ~
                              tt-docum-est.nat-operacao
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields
&GLOBAL-DEFINE page1Widgets   br-docum-est-cex

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER pr-documento AS ROWID NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE h-bocx090        AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin090        AS HANDLE NO-UNDO.
DEFINE VARIABLE c-emitente       LIKE emitente.nome-abrev NO-UNDO.
DEFINE VARIABLE c-desp-imp       LIKE desp-imp.descricao  NO-UNDO.
DEFINE VARIABLE iNumRowsReturned AS INTEGER               NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-docum-est-cex

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-docum-est-cex

/* Definitions for BROWSE br-docum-est-cex                              */
&Scoped-define FIELDS-IN-QUERY-br-docum-est-cex ~
tt-docum-est-cex.cod-emitente-desp ~
fn-emitente(tt-docum-est-cex.cod-emitente-desp) @ c-emitente ~
tt-docum-est-cex.cod-desp ~
fn-desp-imp(tt-docum-est-cex.cod-desp) @ c-desp-imp ~
tt-docum-est-cex.val-desp tt-docum-est-cex.cod-cond-pag 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-docum-est-cex 
&Scoped-define QUERY-STRING-br-docum-est-cex FOR EACH tt-docum-est-cex NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-docum-est-cex OPEN QUERY br-docum-est-cex FOR EACH tt-docum-est-cex NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-docum-est-cex tt-docum-est-cex
&Scoped-define FIRST-TABLE-IN-QUERY-br-docum-est-cex tt-docum-est-cex


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-docum-est-cex}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-docum-est.cod-emitente ~
tt-docum-est.serie-docto tt-docum-est.nro-docto tt-docum-est.nat-operacao 
&Scoped-define ENABLED-TABLES tt-docum-est
&Scoped-define FIRST-ENABLED-TABLE tt-docum-est
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-docum-est.cod-emitente ~
tt-docum-est.serie-docto tt-docum-est.nro-docto tt-docum-est.nat-operacao 
&Scoped-define DISPLAYED-TABLES tt-docum-est
&Scoped-define FIRST-DISPLAYED-TABLE tt-docum-est
&Scoped-Define DISPLAYED-OBJECTS desc-emitente desc-nat-oper 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desp-imp wMaintenance 
FUNCTION fn-desp-imp RETURNS CHARACTER
  ( input p-cod-desp as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-emitente wMaintenance 
FUNCTION fn-emitente RETURNS CHARACTER
  ( INPUT p-cod-emitente AS INTEGER )  FORWARD.

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
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE desc-emitente AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .88 NO-UNDO.

DEFINE VARIABLE desc-nat-oper AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.21.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-docum-est-cex FOR 
      tt-docum-est-cex SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-docum-est-cex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-docum-est-cex wMaintenance _STRUCTURED
  QUERY br-docum-est-cex NO-LOCK DISPLAY
      tt-docum-est-cex.cod-emitente-desp FORMAT ">>>>>>>>9":U WIDTH 8
      fn-emitente(tt-docum-est-cex.cod-emitente-desp) @ c-emitente COLUMN-LABEL "Nome Abreviado"
            WIDTH 15
      tt-docum-est-cex.cod-desp FORMAT ">>,>>9":U
      fn-desp-imp(tt-docum-est-cex.cod-desp) @ c-desp-imp COLUMN-LABEL "Descri‡Æo"
            WIDTH 25
      tt-docum-est-cex.val-desp FORMAT ">>>>>,>>>,>>9.99":U WIDTH 15
      tt-docum-est-cex.cod-cond-pag FORMAT ">>>9":U WIDTH 7.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 83 BY 9.29
         FONT 1 FIT-LAST-COLUMN.


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
     tt-docum-est.cod-emitente AT ROW 2.83 COL 16.43 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     desc-emitente AT ROW 2.83 COL 26.57 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     tt-docum-est.serie-docto AT ROW 3.83 COL 16.43 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .88
     tt-docum-est.nro-docto AT ROW 4.83 COL 16.43 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-docum-est.nat-operacao AT ROW 5.83 COL 16.43 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     desc-nat-oper AT ROW 5.83 COL 24.57 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     br-docum-est-cex AT ROW 1.25 COL 1.57 WIDGET-ID 200
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.08
         SIZE 84.43 BY 9.75
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-docum-est T "?" NO-UNDO movind docum-est
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-docum-est-cex T "?" NO-UNDO mgcex docum-est-cex
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
         TITLE              = "Consulta Doctos Importa‡Æo"
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
/* SETTINGS FOR FILL-IN desc-emitente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN desc-nat-oper IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-docum-est-cex 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-docum-est-cex
/* Query rebuild information for BROWSE br-docum-est-cex
     _TblList          = "Temp-Tables.tt-docum-est-cex"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-docum-est-cex.cod-emitente-desp
"tt-docum-est-cex.cod-emitente-desp" ? ? "integer" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fn-emitente(tt-docum-est-cex.cod-emitente-desp) @ c-emitente" "Nome Abreviado" ? ? ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.tt-docum-est-cex.cod-desp
     _FldNameList[4]   > "_<CALC>"
"fn-desp-imp(tt-docum-est-cex.cod-desp) @ c-desp-imp" "Descri‡Æo" ? ? ? ? ? ? ? ? no ? no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-docum-est-cex.val-desp
"tt-docum-est-cex.val-desp" ? ">>>>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-docum-est-cex.cod-cond-pag
"tt-docum-est-cex.cod-cond-pag" ? ? "integer" ? ? ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-docum-est-cex */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance /* Consulta Doctos Importa‡Æo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance /* Consulta Doctos Importa‡Æo */
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
    {method/zoomreposition.i &ProgramZoom="inzoom/z01in0814.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-docum-est.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-docum-est.cod-emitente wMaintenance
ON LEAVE OF tt-docum-est.cod-emitente IN FRAME fpage0 /* Emitente */
DO:
   {include/leave.i &tabela=emitente
                    &atributo-ref=nome-emit
                    &variavel-ref=desc-emitente
                    &where="emitente.cod-emitente = input frame fpage0 tt-docum-est.cod-emitente"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMaintenance
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-docum-est.nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-docum-est.nat-operacao wMaintenance
ON LEAVE OF tt-docum-est.nat-operacao IN FRAME fpage0 /* Nat Opera‡Æo */
DO:
   {include/leave.i &tabela=natur-oper
                    &atributo-ref=denominacao
                    &variavel-ref=desc-nat-oper
                    &where="natur-oper.nat-operacao = input frame fPage0 tt-docum-est.nat-operacao"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-docum-est-cex
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

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
    IF VALID-HANDLE(h-bocx090) THEN 
        DELETE PROCEDURE h-bocx090.

    IF  VALID-HANDLE(h-boin090) THEN 
        DELETE PROCEDURE h-boin090.

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
    APPLY "leave":U TO tt-docum-est.cod-emitente IN FRAME fPage0.
    APPLY "leave":U TO tt-docum-est.nat-operacao IN FRAME fPage0.
    
    ENABLE br-docum-est-cex WITH FRAME fPage1.

    {&OPEN-QUERY-br-docum-est-cex}
    
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
    
    IF NOT VALID-HANDLE(h-boin090) THEN
        RUN inbo/boin090.p PERSISTENT SET h-boin090.
    
    FOR FIRST docum-est WHERE ROWID(docum-est) = pr-documento NO-LOCK:
        RUN setConstraintChave IN h-boin090(INPUT docum-est.serie-docto,
                                            INPUT docum-est.nro-docto,
                                            INPUT docum-est.cod-emitente,
                                            INPUT docum-est.nat-operacao).
        RUN openQueryStatic in h-boin090 (INPUT "Chave":U).
        RUN goToKey IN h-boin090(INPUT docum-est.serie-docto,  
                                 INPUT docum-est.nro-docto,    
                                 INPUT docum-est.cod-emitente, 
                                 INPUT docum-est.nat-operacao).
        RUN getRecord IN h-boin090 (OUTPUT TABLE tt-docum-est).
        FIND FIRST tt-docum-est NO-ERROR.
    END.
    
    IF NOT VALID-HANDLE(h-bocx090) THEN
        RUN cxbo/bocx090.p PERSISTENT SET h-bocx090.
    
    RUN linktoDocumEst  IN h-bocx090 (INPUT h-boin090).
    RUN openQuery       IN h-bocx090 (INPUT 2).
    RUN getBatchRecords IN h-bocx090 (INPUT ?,
                                      INPUT NO,
                                      INPUT ?,
                                      OUTPUT iNumRowsReturned,
                                      OUTPUT TABLE tt-docum-est-cex).
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desp-imp wMaintenance 
FUNCTION fn-desp-imp RETURNS CHARACTER
  ( input p-cod-desp as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    IF AVAIL tt-docum-est THEN DO:
        FOR FIRST desp-embarque FIELDS(descricao) NO-LOCK
            WHERE desp-embarque.embarque    = tt-docum-est.embarque
              AND desp-embarque.cod-estabel = tt-docum-est.cod-estabel
              AND desp-embarque.cod-desp    = p-cod-desp:
            IF TRIM(desp-embarque.descricao) <> "":U THEN
                RETURN desp-embarque.descricao.
        END.
    END.
    FIND desp-imp WHERE desp-imp.cod-desp = p-cod-desp NO-LOCK NO-ERROR.
    IF AVAIL desp-imp THEN
        RETURN desp-imp.descricao.
    ELSE
        RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-emitente wMaintenance 
FUNCTION fn-emitente RETURNS CHARACTER
  ( INPUT p-cod-emitente AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND FIRST emitente WHERE emitente.cod-emitente = p-cod-emitente NO-LOCK NO-ERROR.
  IF AVAIL emitente THEN
    RETURN emitente.nome-abrev.
  ELSE
    RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

