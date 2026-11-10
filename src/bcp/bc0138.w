&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcld   emsfnd         PROGRESS
*/
&Scoped-define WINDOW-NAME wFormation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttBc-tipo-trans NO-UNDO LIKE bc-tipo-trans
            FIELD RowNum  AS INTEGER
            FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE ttUsuar-mestre NO-UNDO LIKE usuar_mestre
            FIELD r-Rowid AS ROWID. 

DEFINE TEMP-TABLE ttBc-usuar-trans NO-UNDO LIKE bc-usuar-trans
            FIELD RowNum  AS INTEGER
            FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE ttBc-usuar-trans-aux NO-UNDO LIKE bc-usuar-trans
            FIELD RowNum  AS INTEGER
            FIELD r-Rowid AS ROWID.

DEFINE BUFFER bfBc-usuar-trans FOR bc-usuar-trans.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wFormation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0138 2.00.00.009 } /*** "010009" 14/08/2023 08:00:49  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bc0138 MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          BC0138
&GLOBAL-DEFINE Version        2.00.00.009

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE DelTarget        YES
&GLOBAL-DEFINE AddTarget        YES
&GLOBAL-DEFINE DelAllTarget     YES
&GLOBAL-DEFINE AddAllTarget     YES

&GLOBAL-DEFINE UpdateTarget     NO


&GLOBAL-DEFINE ttParent         ttUsuar-mestre
&GLOBAL-DEFINE hDBOParent       hDBOUsuar-mestre
&GLOBAL-DEFINE DBOParentTable   usuar_mestre        

  
&GLOBAL-DEFINE ttSource         ttBc-tipo-trans
&GLOBAL-DEFINE hDBOSource       hDBOBc-tipo-trans
&GLOBAL-DEFINE DBOSourceTable   bc-tipo-trans 

&GLOBAL-DEFINE ttTarget         ttBc-usuar-trans
&GLOBAL-DEFINE hDBOTarget       hDBOBc-usuar-trans
&GLOBAL-DEFINE DBOTargetTable   bc-usuar-trans

&GLOBAL-DEFINE page0Fields      ttUsuar-mestre.cod_usuario

&GLOBAL-DEFINE SourceBrowse     brSource
&GLOBAL-DEFINE TargetBrowse     brTarget

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-desc-transacao AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-prioridade     AS INTEGER   NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSource} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTarget} AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bc0138a     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bc0138b     AS HANDLE NO-UNDO.

{cdp/cdcfgmat.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Formation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSource

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttBc-tipo-trans ttBc-usuar-trans

/* Definitions for BROWSE brSource                                      */
&Scoped-define FIELDS-IN-QUERY-brSource ttBc-tipo-trans.cd-trans ttBc-tipo-trans.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSource   
&Scoped-define SELF-NAME brSource
&Scoped-define QUERY-STRING-brSource FOR EACH ttBc-tipo-trans NO-LOCK
&Scoped-define OPEN-QUERY-brSource OPEN QUERY {&SELF-NAME} FOR EACH ttBc-tipo-trans NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSource ttBc-tipo-trans
&Scoped-define FIRST-TABLE-IN-QUERY-brSource ttBc-tipo-trans


/* Definitions for BROWSE brTarget                                      */
&Scoped-define FIELDS-IN-QUERY-brTarget ttBc-usuar-trans.cd-trans ttBc-usuar-trans.descricao fn-descricao-transacao() @ c-desc-transacao fn-priorid() @ i-prioridade
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTarget   
&Scoped-define SELF-NAME brTarget
&Scoped-define QUERY-STRING-brTarget FOR EACH ttBc-usuar-trans NO-LOCK BY ttBc-usuar-trans.vli-priorid BY ttBc-usuar-trans.cd-trans
&Scoped-define OPEN-QUERY-brTarget OPEN QUERY {&SELF-NAME} FOR EACH ttBc-usuar-trans NO-LOCK BY ttBc-usuar-trans.vli-priorid BY ttBc-usuar-trans.cd-trans.
&Scoped-define TABLES-IN-QUERY-brTarget ttBc-usuar-trans
&Scoped-define FIRST-TABLE-IN-QUERY-brTarget ttBc-usuar-trans


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSource}~
    ~{&OPEN-QUERY-brTarget}


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttUsuar-mestre.cod_usuario
&Scoped-define ENABLED-TABLES ttUsuar-mestre
&Scoped-define FIRST-ENABLED-TABLE ttUsuar-mestre
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btGerar btSearch btQueryJoins btReportsJoins btExit btHelp
&Scoped-Define DISPLAYED-FIELDS ttUsuar-mestre.cod_usuario
&Scoped-define DISPLAYED-TABLES ttUsuar-mestre
&Scoped-define FIRST-DISPLAYED-TABLE ttUsuar-mestre


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
  

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-descricao-transacao wFormation 
FUNCTION fn-descricao-transacao RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-priorid wFormation 
FUNCTION fn-priorid RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wFormation                            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE        NO-UNDO.

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

DEFINE BUTTON btGerar
     IMAGE-UP FILE "image\im-carga":U
     IMAGE-INSENSITIVE FILE "image\ii-carga":U
     LABEL "Gerar" 
     SIZE 4 BY 1.25 TOOLTIP "Gerar".

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

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.63.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddAllTarget 
     IMAGE-UP FILE "image~\add-all":U
     IMAGE-INSENSITIVE FILE "image~\ii-add-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui Todos".

DEFINE BUTTON btAddTarget 
     IMAGE-UP FILE "image/next-au":U
     IMAGE-INSENSITIVE FILE "image/next-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui".

DEFINE BUTTON btAlterar 
     LABEL "Alterar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btDelAllTarget 
     IMAGE-UP FILE "image~\del-all":U
     IMAGE-INSENSITIVE FILE "image~\ii-del-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira Todos".

DEFINE BUTTON btDelTarget 
     IMAGE-UP FILE "image/prev-au":U
     IMAGE-INSENSITIVE FILE "image/prev-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira".


/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSource FOR 
      ttBc-tipo-trans SCROLLING.

DEFINE QUERY brTarget FOR 
      ttBc-usuar-trans SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSource wFormation _FREEFORM
  QUERY brSource DISPLAY
      ttBc-tipo-trans.cd-trans COLUMN-LABEL "Transa‡Æo" FORMAT "x(8)":U
      ttBc-tipo-trans.descricao FORMAT "X(40)":U  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 32 BY 8
         FONT 2.

DEFINE BROWSE brTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTarget wFormation _FREEFORM
  QUERY brTarget DISPLAY
      ttBc-usuar-trans.cd-trans COLUMN-LABEL "Transa‡Æo" FORMAT "x(8)":U
      fn-descricao-transacao() @ c-desc-transacao COLUMN-LABEL "Descri‡Æo" FORMAT "X(40)":U
      fn-priorid() @ i-prioridade COLUMN-LABEL "Prioridade"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 32 BY 8
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
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
     btGerar AT ROW 1.13 COL 64.86 HELP
          "Gerar"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
    ttUsuar-mestre.cod_usuario AT ROW 3 COL 35.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15.83
         FONT 1.

DEFINE FRAME fPage1
     brSource AT ROW 1.25 COL 2
     brTarget AT ROW 1.25 COL 52
     btAddAllTarget AT ROW 3.25 COL 39.57
     btAddTarget AT ROW 4.42 COL 39.57
     btDelTarget AT ROW 5.54 COL 39.57
     btDelAllTarget AT ROW 6.67 COL 39.57
     btAlterar AT ROW 9.5 COL 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.58
         SIZE 84.43 BY 10.17
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Formation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttBc-tipo-trans T "?" NO-UNDO mgcld bc-tipo-trans
      ADDITIONAL-FIELDS:
          FIELD RowNum  AS INTEGER
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: ttUsuar-mestre T "?" NO-UNDO emsfnd usuar_mestre
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: ttBc-usuar-trans T "?" NO-UNDO mgcld bc-usuar-trans
      ADDITIONAL-FIELDS:
          FIELD RowNum  AS INTEGER
          FIELD r-Rowid AS ROWID
      END-FIELDS.
   END-TABLES.
 */

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wFormation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 14.21
         WIDTH              = 90
         MAX-HEIGHT         = 21.21
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.21
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = YES
         SCROLL-BARS        = NO
         STATUS-AREA        = YES
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = YES
         THREE-D            = YES
         MESSAGE-AREA       = NO
         SENSITIVE          = YES.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wFormation 
/* ************************* Included-Libraries *********************** */

{formation/formation.i}           

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wFormation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSource 1 fPage1 */
/* BROWSE-TAB brTarget brSource fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wFormation)
THEN wFormation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSource
/* Query rebuild information for BROWSE brSource
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttBc-tipo-trans NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brSource */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTarget
/* Query rebuild information for BROWSE brTarget
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttBc-usuar-trans NO-LOCK BY ttBc-usuar-trans.vli-priorid BY ttBc-usuar-trans.cd-trans.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brTarget */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */
&Scoped-define SELF-NAME wFormation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wFormation wFormation
ON END-ERROR OF wFormation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
   /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wFormation wFormation
ON WINDOW-CLOSE OF wFormation
DO:
   /* This event will close the window and terminate the procedure.  */
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddAllTarget wFormation
ON CHOOSE OF btAddAllTarget IN FRAME fPage1
DO: 
   APPLY "CHOOSE":U TO btDelAllTarget IN FRAME fPage1.
    
   {formation/addalltarget.i} 

   RUN atualizaBrowserFormacao IN THIS-PROCEDURE.

   btAlterar:SENSITIVE IN FRAME fPage1 = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddTarget wFormation
ON CHOOSE OF btAddTarget IN FRAME fPage1
DO:
   bloco1:
   DO TRANS:
      {formation/addtarget.i}

      IF AVAIL ttBc-usuar-trans THEN
         btAlterar:SENSITIVE IN FRAME fPage1 = YES.
      ELSE
         btAlterar:SENSITIVE IN FRAME fPage1 = NO.
        
      RUN pi-programa-prioridade IN THIS-PROCEDURE.
      IF RETURN-VALUE = "NOK":U THEN
         UNDO bloco1, LEAVE bloco1.
   END.

   RUN atualizaBrowserFormacao IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAlterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlterar wFormation
ON CHOOSE OF btAlterar IN FRAME fPage1 /* Alterar */
DO:
   RUN pi-programa-prioridade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelAllTarget wFormation
ON CHOOSE OF btDelAllTarget IN FRAME fPage1
DO:
   {formation/delalltarget.i}  

   btAlterar:SENSITIVE IN FRAME fPage1 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelTarget wFormation
ON CHOOSE OF btDelTarget IN FRAME fPage1
DO:
   {formation/deltarget.i}   
    
   IF AVAIL ttBc-usuar-trans THEN
      btAlterar:SENSITIVE IN FRAME fPage1 = YES.
   ELSE
      btAlterar:SENSITIVE IN FRAME fPage1 = NO.

   RUN atualizaBrowserFormacao IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wFormation
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wFormation
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
   RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGerar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGerar wFormation
ON CHOOSE OF btGerar IN FRAME fPage0 DO: /* Gerar */
   RUN bcp/bc0138b.w PERSISTENT SET h-bc0138b (INPUT THIS-PROCEDURE).
   RUN dispatch IN h-bc0138b('initialize').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wFormation
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
   RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wFormation
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wFormation
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
   RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wFormation
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
   RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wFormation
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
   RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wFormation
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
   RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wFormation
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
   RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wFormation
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
       
   DEFINE VARIABLE rUsuar AS ROWID NO-UNDO.

   {include/zoomvar.i &prog-zoom=unzoom/z01un178.w
                      &campo=ttUsuar-mestre.cod_usuario
                      &campozoom=cod_usuario}
                         
   WAIT-FOR CLOSE OF wh-pesquisa.         
      
   RUN goToKey IN {&hDBOParent} (INPUT ttUsuar-mestre.cod_usuario:SCREEN-VALUE IN FRAME fpage0).

   RUN getRowid IN {&hDBOParent} (OUTPUT rUsuar).
        
   RUN repositionRecord IN THIS-PROCEDURE (INPUT rUsuar).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSource
&UNDEFINE SELF-NAME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wFormation


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
{formation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wFormation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/                

   ASSIGN btGerar:SENSITIVE IN FRAME fPage0 = YES.

   IF AVAIL ttBc-usuar-trans THEN
      ASSIGN btAlterar:SENSITIVE IN FRAME fPage1 = YES.
   ELSE
      ASSIGN btAlterar:SENSITIVE IN FRAME fPage1 = NO.
              
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wFormation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   ASSIGN btAddAllTarget:VISIBLE IN FRAME fPage1 = YES
          btDelAllTarget:VISIBLE IN FRAME fPage1 = YES
          btAlterar:VISIBLE IN FRAME fPage1 = YES.
              
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaBrowserFormacao wFormation 
PROCEDURE atualizaBrowserFormacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   RUN atualizaBrowserFormacao IN {&hDBOTarget} (INPUT INPUT FRAME fPage0 ttUsuar-mestre.cod_usuario,
                                                 OUTPUT TABLE ttBc-usuar-trans).

   {&OPEN-QUERY-brTarget}

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wFormation
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
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
    
   DEFINE VARIABLE c-usuario LIKE {&ttParent}.cod_usuario NO-UNDO.    
   DEFINE FRAME fGoToRecord
      c-usuario         AT ROW 1.21 COL 17.72 COLON-ALIGNED
      btGoToOK          AT ROW 2.63 COL 2.14
      btGoToCancel      AT ROW 2.63 COL 13
      rtGoToButton      AT ROW 2.38 COL 1
      SPACE(0.28)
      WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
         THREE-D SCROLLABLE TITLE "V  Para Usu rio" FONT 1
         DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

   RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
   {utp/ut-liter.i "V _Para_Usu rio"}
   ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
   ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
       
      ASSIGN c-usuario.
        
      RUN goToKey IN {&hDBOParent} (INPUT c-usuario).

      IF RETURN-VALUE = "NOK":U THEN DO:
         {utp/ut-liter.i "Usu rio" *}
         RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
         RETURN NO-APPLY.
      END.

      /* Retorna rowid do registro corrente do DBO */
      RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
      /* Reposiciona registro com base em um rowid */
      RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

      APPLY "GO":U TO FRAME fGoToRecord.
   END.

   ASSIGN c-usuario:width  = 21.29
          c-usuario:height =  0.88.

   ENABLE c-usuario btGoToOK btGoToCancel
      WITH FRAME fGoToRecord.

   WAIT-FOR "GO":U OF FRAME fGoToRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wFormation
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

   /*--- Verifica se o DBO da tabela Pai j  est  inicializado ---*/
   IF NOT VALID-HANDLE({&hDBOParent}) OR
      {&hDBOParent}:TYPE <> "PROCEDURE":U OR
      {&hDBOParent}:FILE-NAME <> "fnbo/bofn017.p":U THEN DO:
      {btb/btb008za.i1 fnbo/bofn017.p YES}
      {btb/btb008za.i2 fnbo/bofn017.p '' {&hDBOParent}} 
   END.
    
   RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U).
    
   /*--- Verifica se o DBO da tabela Origem j  est  inicializado ---*/
   IF NOT VALID-HANDLE({&hDBOSource}) OR
      {&hDBOSource}:TYPE <> "PROCEDURE":U OR
      {&hDBOSource}:FILE-NAME <> "clbo/bocl018.p":U THEN DO:
      {btb/btb008za.i1 clbo/bocl018.p YES}
      {btb/btb008za.i2 clbo/bocl018.p '' {&hDBOSource}}
   END. 
                
   /*--- Verifica se o DBO da tabela Forma‡Æo j  est  inicializado ---*/
   IF NOT VALID-HANDLE({&hDBOTarget}) OR
      {&hDBOTarget}:TYPE <> "PROCEDURE":U OR
      {&hDBOTarget}:FILE-NAME <> "clbo/bocl046.p":U THEN DO:
      {btb/btb008za.i1 clbo/bocl046.p YES}
      {btb/btb008za.i2 clbo/bocl046.p '' {&hDBOTarget}} 
   END.    
         
   RUN setConstraintUsuario IN {&hDBOTarget} (INPUT INPUT FRAME fPage0 ttUsuar-mestre.cod_usuario).
         
   RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries wFormation 
PROCEDURE openQueries :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza browsers 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
   {formation/openqueriestarget.i &Parent="Usuario"
                                  &Query="Usuario-Transacao"}    
                                   
   {formation/openqueriessource.i &Query="transacao-progLeitura"
                                  &OpenAlways="yes"}                                    
    
   RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
  
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-programa-prioridade wFormation 
PROCEDURE pi-programa-prioridade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
       
   IF AVAIL ttBc-usuar-trans THEN DO:
      
      RUN retornaDescricaoTransacao IN {&hDBOTarget} (INPUT  ttBc-usuar-trans.cd-trans,
                                                      OUTPUT c-desc-transacao).
      
      RUN bcp/bc0138a.w PERSISTENT SET h-bc0138a (INPUT THIS-PROCEDURE,
                                                  INPUT ttBc-usuar-trans.cod-usuario,
                                                  INPUT ttBc-usuar-trans.cd-trans,
                                                  INPUT c-desc-transacao,
                                                  INPUT ttBc-usuar-trans.vli-priorid).
      RUN dispatch IN h-bc0138a('initialize').
   END.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wFormation 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:  Salva valores dos campos da tabela forma‡Æo ({&ttTarget}) com base 
            nos campos da tabela pai ({&ttParent}) e tabela origem ({&ttSource})
  Parameters:  
------------------------------------------------------------------------------*/

   ASSIGN {&ttTarget}.cod-usuario  = {&ttParent}.cod_usuario
          {&ttTarget}.cd-trans    = {&ttSource}.cd-trans
          {&ttTarget}.vli-priorid  = 0.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-prioridade wFormation 
PROCEDURE pi-prioridade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE INPUT PARAM p-prioridade LIKE bc-usuar-trans.vli-priorid NO-UNDO.
 
   IF AVAIL ttBc-usuar-trans THEN DO: 
      
      ASSIGN ttBc-usuar-trans.vli-priorid = p-prioridade. 

      EMPTY TEMP-TABLE ttBc-usuar-trans-aux.
      CREATE ttBc-usuar-trans-aux.
      BUFFER-COPY ttBc-usuar-trans TO ttBc-usuar-trans-aux.

      RUN goToKey IN {&hDBOTarget} (INPUT ttBc-usuar-trans-aux.cod-usuario,
                                    INPUT ttBc-usuar-trans-aux.cd-trans).
            
      IF RETURN-VALUE = "OK":U THEN DO:
         RUN SetRecord IN {&hDBOTarget} (INPUT TABLE ttBc-usuar-trans-aux).
         RUN emptyRowErrors IN {&hDBOTarget}.
         RUN UpdateRecord IN {&hDBOTarget}.
      END.
   END.

   RUN openQueries IN THIS-PROCEDURE.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBloqWindow wMaintenance 
PROCEDURE piBloqWindow :
/*------------------------------------------------------------------------------
  Notes: Bloquei Tela
------------------------------------------------------------------------------*/
   ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLibWindow wMaintenance 
PROCEDURE piLibWindow  :
/*------------------------------------------------------------------------------
  Notes: Libera Tela
------------------------------------------------------------------------------*/
   ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-descricao-transacao wFormation 
FUNCTION fn-descricao-transacao RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
   RUN retornaDescricaoTransacao IN {&hDBOTarget} (INPUT  ttBc-usuar-trans.cd-trans,
                                                   OUTPUT c-desc-transacao).  

   RETURN c-desc-transacao.   /* Function return value. */
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-priorid wFormation 
FUNCTION fn-priorid RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
   ASSIGN i-prioridade = ttBc-usuar-trans.vli-priorid.

   RETURN i-prioridade.   /* Function return value. */
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

