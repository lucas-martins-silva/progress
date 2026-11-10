&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-adiant-despes-embarq NO-UNDO LIKE adiant-despes-embarq
       FIELD r-Rowid      AS ROWID.
DEFINE TEMP-TABLE tt-adiant-despes-embarq-aux NO-UNDO LIKE adiant-despes-embarq
       FIELD r-Rowid      AS ROWID.
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-embarque-imp-aux NO-UNDO LIKE embarque-imp
       FIELD r-Rowid AS ROWID.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0720C 2.00.00.007 } /*** "010007" 07/11/2025 11:15:52 ***/
                                                                              
/* Programa:  Relacionamento dos Embarques/DIÊs x Adiantamento de Despesas*/
/* M¢dulo:    Importa‡Æo                                                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0720c MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0720C
&GLOBAL-DEFINE Version        2.00.00.007

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels    

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp brSource brTarget btAddAllTarget btAddTarget btDelAllTarget btDelTarget btFiltro
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

{utp/ut-glob.i}
{include/boerrtab.i} /*tt-bo-erro*/

/*Defini‡Æo da tt-param-adiant*/
{imp/im0720.i tt-param-exec}

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-bocx00442     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00446     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad107       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx220       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx220na     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad098       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-im0720c1      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin295desc   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin274       AS HANDLE      NO-UNDO.   
DEFINE VARIABLE h-bocx225       AS HANDLE      NO-UNDO. 

DEFINE VARIABLE c-nome          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-emit          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-return        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iRowsReturned   AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-abre-query    AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE l-add-all       AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE l-remove-all    AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE c-di-siscomex   LIKE decla-import.cod-di-siscomex NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSource

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-embarque-imp tt-adiant-despes-embarq-aux

/* Definitions for BROWSE brSource                                      */
&Scoped-define FIELDS-IN-QUERY-brSource tt-embarque-imp.cod-estabel tt-embarque-imp.embarque SUBSTR(fnEmitente(tt-embarque-imp.cod-estabel, tt-embarque-imp.embarque,1),1,12) @ c-emit SUBSTR(fnEmitente(tt-embarque-imp.cod-estabel, tt-embarque-imp.embarque,2),1,12) @ c-nome tt-embarque-imp.declaracao-import tt-embarque-imp.int-2 @ i-di-ems  
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSource   
&Scoped-define SELF-NAME brSource
&Scoped-define QUERY-STRING-brSource FOR EACH tt-embarque-imp NO-LOCK
&Scoped-define OPEN-QUERY-brSource OPEN QUERY {&SELF-NAME} FOR EACH tt-embarque-imp NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSource tt-embarque-imp
&Scoped-define FIRST-TABLE-IN-QUERY-brSource tt-embarque-imp

/* Definitions for BROWSE brTarget                                      */
&Scoped-define FIELDS-IN-QUERY-brTarget tt-adiant-despes-embarq-aux.cod-estabel tt-adiant-despes-embarq-aux.cod-embarq SUBSTR(fnEmitente(tt-adiant-despes-embarq-aux.cod-estabel,tt-adiant-despes-embarq-aux.cod-embarq,1),1,12) @ c-emit SUBSTR(fnEmitente(tt-adiant-despes-embarq-aux.cod-estabel, tt-adiant-despes-embarq-aux.cod-embarq,2),1,12) @ c-nome fnDIsiscomex(tt-adiant-despes-embarq-aux.cod-estabel,tt-adiant-despes-embarq-aux.cod-embarq) @ c-di-siscomex tt-adiant-despes-embarq-aux.num-di-ems  
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTarget   
&Scoped-define SELF-NAME brTarget
&Scoped-define QUERY-STRING-brTarget FOR EACH tt-adiant-despes-embarq-aux NO-LOCK
&Scoped-define OPEN-QUERY-brTarget OPEN QUERY {&SELF-NAME} FOR EACH tt-adiant-despes-embarq-aux NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTarget tt-adiant-despes-embarq-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brTarget tt-adiant-despes-embarq-aux

/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brSource}~
    ~{&OPEN-QUERY-brTarget}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 RECT-1 btQueryJoins ~
btReportsJoins btExit btHelp c-cod-estab c-desc-estabel d-dat-implant ~
d-cdd-adiant i-cdn-emitente c-desc-emitente brSource brTarget ~
btAddAllTarget btAddTarget btDelTarget btDelAllTarget btFiltro 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estab c-desc-estabel d-dat-implant ~
d-cdd-adiant i-cdn-emitente c-desc-emitente 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDIsiscomex wWindow 
FUNCTION fnDIsiscomex RETURNS CHARACTER
  ( p-cod-estabel AS CHARACTER,
    p-embarque    AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEmitente wWindow 
FUNCTION fnEmitente RETURNS CHARACTER 
  ( p-cod-estabel AS CHARACTER,
    p-embarque    AS CHARACTER,
    p-opcao       AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAddAllTarget 
     IMAGE-UP FILE "image/add-all":U
     IMAGE-INSENSITIVE FILE "image/ii-add-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui Todos".

DEFINE BUTTON btAddTarget 
     IMAGE-UP FILE "image/next-au":U
     IMAGE-INSENSITIVE FILE "image/next-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui".

DEFINE BUTTON btDelAllTarget 
     IMAGE-UP FILE "image/del-all":U
     IMAGE-INSENSITIVE FILE "image/ii-del-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira Todos".

DEFINE BUTTON btDelTarget 
     IMAGE-UP FILE "image/prev-au":U
     IMAGE-INSENSITIVE FILE "image/prev-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image/im-fil.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-fil.bmp":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro de Embarques".

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE VARIABLE c-cod-estab AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE d-dat-implant AS DATE FORMAT "99/99/9999" 
     LABEL "Data Implanta‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE d-cdd-adiant AS DECIMAL FORMAT ">>>>,>>>,>>>,>>>,>>9" INITIAL 0 
     LABEL "Adiantamento" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-di-ems AS INTEGER FORMAT ">>>>>>>>>>>9":U INITIAL 0 
     LABEL "DI EMS" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.33.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSource FOR 
      tt-embarque-imp SCROLLING.

DEFINE QUERY brTarget FOR 
      tt-adiant-despes-embarq-aux SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSource wWindow _FREEFORM
  QUERY brSource NO-LOCK DISPLAY
      tt-embarque-imp.cod-estabel FORMAT "X(5)":U COLUMN-LABEL "Estab"
      tt-embarque-imp.embarque FORMAT "X(16)":U WIDTH 17
      SUBSTR(fnEmitente(tt-embarque-imp.cod-estabel,tt-embarque-imp.embarque,1),1,12) @ c-emit COLUMN-LABEL "Emitente" FORMAT "x(10)"
      SUBSTR(fnEmitente(tt-embarque-imp.cod-estabel,tt-embarque-imp.embarque,2),1,12) @ c-nome COLUMN-LABEL "Nome Abrev" FORMAT "x(15)"
      tt-embarque-imp.declaracao-import 
      tt-embarque-imp.int-2 @ i-di-ems FORMAT ">>>>>>>>9":U       
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 39 BY 9.96
         FONT 1.

DEFINE BROWSE brTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTarget wWindow _FREEFORM
  QUERY brTarget NO-LOCK DISPLAY
      tt-adiant-despes-embarq-aux.cod-estabel FORMAT "x(5)":U COLUMN-LABEL "Estab"
      tt-adiant-despes-embarq-aux.cod-embarq FORMAT "x(16)":U WIDTH 17
      SUBSTR(fnEmitente(tt-adiant-despes-embarq-aux.cod-estabel,tt-adiant-despes-embarq-aux.cod-embarq,1),1,12) @ c-emit COLUMN-LABEL "Emitente" FORMAT "x(10)" 
      SUBSTR(fnEmitente(tt-adiant-despes-embarq-aux.cod-estabel,tt-adiant-despes-embarq-aux.cod-embarq,2),1,12) @ c-nome COLUMN-LABEL "Nome Abrev" FORMAT "x(15)"
      fnDIsiscomex(tt-adiant-despes-embarq-aux.cod-estabel,tt-adiant-despes-embarq-aux.cod-embarq) @ c-di-siscomex 
      tt-adiant-despes-embarq-aux.num-di-ems FORMAT ">>>>>>>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 39 BY 9.96
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     c-cod-estab AT ROW 2.88 COL 18 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-estabel AT ROW 2.88 COL 24.43 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     d-dat-implant AT ROW 2.88 COL 76.43 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     d-cdd-adiant AT ROW 3.83 COL 18 COLON-ALIGNED WIDGET-ID 6
          LABEL "Adiantamento"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     i-cdn-emitente AT ROW 4.75 COL 18 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-desc-emitente AT ROW 4.75 COL 28.14 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     brSource AT ROW 6.04 COL 1.72
     brTarget AT ROW 6.04 COL 51
     btAddAllTarget AT ROW 7.75 COL 42.29
     btAddTarget AT ROW 8.75 COL 42.29
     btDelTarget AT ROW 9.75 COL 42.29
     btDelAllTarget AT ROW 10.75 COL 42.29
     btFiltro AT ROW 16 COL 36.43
     rtToolBar-2 AT ROW 1 COL 1
     RECT-1 AT ROW 2.58 COL 1 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.25
         FONT 1.

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.33
         WIDTH              = 90.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 91.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 91.86
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brSource c-desc-emitente fpage0 */
/* BROWSE-TAB brTarget brSource fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSource
/* Query rebuild information for BROWSE brSource
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-embarque-imp NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSource */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTarget
/* Query rebuild information for BROWSE brTarget
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-adiant-despes-embarq-aux NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brTarget */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 
/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btAddAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddAllTarget wWindow
ON CHOOSE OF btAddAllTarget IN FRAME fpage0
DO:
    RUN pi-empty-row-errors.
    DO TRANS:
        RUN pi-addAll.
        IF  CAN-FIND(FIRST RowErrors
                     WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal=YES}
            IF  CAN-FIND(FIRST RowErrors
                         WHERE RowErrors.ErrorType    <> "INTERNAL":U
                         AND   RowErrors.ErrorSubType  = "ERROR":U    ) THEN
                UNDO,LEAVE.
        END.
    END.
    ASSIGN l-add-all = NO.
    RUN pi-mostra-embarq.
    RUN pi-mostra-adiant-embarq.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btAddTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddTarget wWindow
ON CHOOSE OF btAddTarget IN FRAME fpage0
DO:
   RUN pi-empty-row-errors.
   DO TRANS:
       RUN pi-add.
       IF  CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
           {method/showmessage.i1}
           {method/showmessage.i2 &Modal=YES}
           IF  CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType    <> "INTERNAL":U
                        AND   RowErrors.ErrorSubType  = "ERROR":U    ) THEN
               UNDO,LEAVE.
       END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btDelAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelAllTarget wWindow
ON CHOOSE OF btDelAllTarget IN FRAME fpage0
DO:
   RUN pi-empty-row-errors.
   DO TRANS:
       RUN pi-removeAll.
       IF  CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
           {method/showmessage.i1}
           {method/showmessage.i2 &Modal=YES}
           IF  CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType    <> "INTERNAL":U
                        AND   RowErrors.ErrorSubType  = "ERROR":U    ) THEN
               UNDO,LEAVE.
       END.
   END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btDelTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelTarget wWindow
ON CHOOSE OF btDelTarget IN FRAME fpage0
DO:
   RUN pi-empty-row-errors.
   DO TRANS:
       RUN pi-remove.
       IF  CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
           {method/showmessage.i1}
           {method/showmessage.i2 &Modal=YES}
           IF  CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType    <> "INTERNAL":U
                        AND   RowErrors.ErrorSubType  = "ERROR":U    ) THEN
               UNDO,LEAVE.
       END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wWindow
ON CHOOSE OF btFiltro IN FRAME fpage0 /* Filtro */
DO:
   RUN pi-filtro-embarq. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define BROWSE-NAME brSource
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

PROCEDURE WinExec EXTERNAL "kernel32.dll":
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose: Desfaz interface/handles    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF VALID-HANDLE(h-bocx00442) THEN DO:
    DELETE PROCEDURE h-bocx00442.
    ASSIGN h-bocx00442 = ?.
END.
IF VALID-HANDLE(h-bocx00446) THEN DO:
    DELETE PROCEDURE h-bocx00446.
    ASSIGN h-bocx00446 = ?.
END.
IF VALID-HANDLE(h-boad107) THEN DO:
    DELETE PROCEDURE h-boad107.
    ASSIGN h-boad107 = ?.
END.
IF VALID-HANDLE(h-boad098) THEN DO:
    DELETE PROCEDURE h-boad098.
    ASSIGN h-boad098 = ?.
END.
IF VALID-HANDLE(h-boin295desc) THEN DO:
    DELETE PROCEDURE h-boin295desc.
    ASSIGN h-boin295desc = ?.
END.
IF VALID-HANDLE(h-bocx220) THEN DO:
    DELETE PROCEDURE h-bocx220.
    ASSIGN h-bocx220 = ?.
END.
IF VALID-HANDLE(h-bocx220na) THEN DO:
    DELETE PROCEDURE h-bocx220na.
    ASSIGN h-bocx220na = ?.
END.
IF VALID-HANDLE(h-im0720c1) THEN DO:
    DELETE PROCEDURE h-im0720c1.
    ASSIGN h-im0720c1 = ?.
END.
IF VALID-HANDLE(h-boin274) THEN DO:
    DELETE PROCEDURE h-boin274.
    ASSIGN h-boin274 = ?.
END.
IF VALID-HANDLE(h-bocx225) THEN DO:
    DELETE PROCEDURE h-bocx225.
    ASSIGN h-bocx225 = ?.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose: Inicializar campos/objetos padr„es    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE (h-bocx00442) THEN
       RUN repositionRecord IN h-bocx00442 (INPUT prParent).

    IF RETURN-VALUE = "OK" THEN DO:
        RUN getCharField IN h-bocx00442(INPUT 'cod-estabel',
                                        OUTPUT c-cod-estab).

        RUN getDecField IN h-bocx00442(INPUT 'cdd-adiant',
                                       OUTPUT d-cdd-adiant).

        RUN getIntField IN h-bocx00442(INPUT 'cdn-emitente',
                                       OUTPUT i-cdn-emitente).

        RUN getDateField IN h-bocx00442(INPUT 'dat-implant',
                                       OUTPUT d-dat-implant).

        DISP c-cod-estab d-cdd-adiant i-cdn-emitente d-dat-implant WITH FRAME fPage0.

    END.
    
    RUN gotokey IN h-boad107 (INPUT c-cod-estab).
    IF RETURN-VALUE = "OK":U THEN
       RUN getcharfield in h-boad107 (INPUT "nome", OUTPUT c-desc-estabel).
    ELSE
       ASSIGN c-desc-estabel = "".    
    DISPLAY c-desc-estabel WITH FRAME fPage0. 

    RUN findCodigo IN h-boad098 (INPUT STRING(i-cdn-emitente), OUTPUT c-return).
    IF c-return = "":U THEN
        RUN getCharField IN h-boad098 (INPUT "nome-abrev",
                                       OUTPUT c-desc-emitente).
    ELSE
        ASSIGN c-desc-emitente = "".
    DISPLAY c-desc-emitente WITH FRAME fPage0.  

    RUN pi-mostra-adiant-embarq.

    apply "choose":U to btfiltro in frame fpage0.  /*executa o programa de filtro.*/

    IF l-abre-query THEN
       RUN pi-mostra-embarq.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose: Antes de inicializar campos/objetos padr„es    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN inicializaBOs.              
              
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-query wWindow 
PROCEDURE pi-atualiza-query :
/*------------------------------------------------------------------------------
  Purpose: Indica se deve ser aberta a query de embarque    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEF INPUT PARAM p-retorna AS LOGICAL NO-UNDO.

 ASSIGN l-abre-query = p-retorna.                
              
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executa-parametros-busca wWindow 
PROCEDURE executa-parametros-busca :
/*------------------------------------------------------------------------------
  Purpose: Busca tabela embarque-imp      
  Parameters:  Envia tabela com os campos do filtro
               Retorna tabela de embarque de importa‡Æo
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM TABLE FOR tt-param-exec.

EMPTY TEMP-TABLE tt-embarque-imp.

/*BROWSER SOURCE*/
RUN getEmbarqueImpByAdiant IN h-bocx220na (INPUT TABLE tt-param-exec,
                                           OUTPUT TABLE tt-embarque-imp).

{&OPEN-QUERY-brSource}

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-tt-param-exec wWindow 
PROCEDURE get-tt-param-exec :
/*------------------------------------------------------------------------------
Purpose: Recebe tabela com os campos do filtro de embarque 
Notes:  Recebe tabela tt-param-exec.
Notes:
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER TABLE FOR tt-param-exec.
  
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOParentHandle wWindow 
PROCEDURE getDBOParentHandle :
/*------------------------------------------------------------------------------
  Purpose:  Grava handle BO   
  Parameters: Retorna handle da BO 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pDBOHandle  AS HANDLE  NO-UNDO.

    ASSIGN pDBOHandle = h-bocx00442.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEstabelecimentoAdiant wWindow 
PROCEDURE getEstabelecimentoAdiant :
/*------------------------------------------------------------------------------
  Purpose: Retorna valor de campo estabelecimento    
  Parameters:  retorna c¢digo do estabelecimento
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM pEstab LIKE adiant-despes.cod-estabel NO-UNDO.

ASSIGN pEstab = c-cod-estab.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializaBOs wWindow 
PROCEDURE inicializaBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
   IF NOT VALID-HANDLE(h-bocx00442) THEN DO:              
      RUN cxbo/bocx00442.p PERSISTENT SET h-bocx00442.    
      RUN openQueryStatic IN h-bocx00442 (INPUT 'Main':U).
   END.
    
   IF NOT VALID-HANDLE(h-bocx00446) THEN DO:              
      RUN cxbo/bocx00446.p PERSISTENT SET h-bocx00446.    
      RUN openQueryStatic IN h-bocx00446 (INPUT 'Main':U).
   END.

   IF NOT VALID-HANDLE(h-boad098) THEN DO:
      RUN adbo/boad098.p PERSISTENT SET h-boad098.
   END.

   IF NOT VALID-HANDLE(h-boin295desc) THEN DO:
      RUN inbo/boin295desc.p PERSISTENT SET h-boin295desc.
   END.

   IF NOT VALID-HANDLE(h-boad107) THEN DO:
      RUN adbo/boad107na.p PERSISTENT SET h-boad107.
      RUN openQueryStatic IN h-boad107 (INPUT "Main":U).
   END.

   IF NOT VALID-HANDLE(h-bocx220) THEN DO:
      RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.
   END.

   IF NOT VALID-HANDLE(h-bocx220na) THEN DO:
      RUN cxbo/bocx220na.p PERSISTENT SET h-bocx220na.
      RUN openQueryStatic IN h-bocx220na (INPUT 'Main':U).
   END.

   IF NOT VALID-HANDLE(h-boin274) THEN DO:
      RUN inbo/boin274.p PERSISTENT SET h-boin274.
      RUN openQueryStatic IN h-boin274 (INPUT 'Main':U).
   END.
   
   IF NOT VALID-HANDLE(h-bocx225) THEN DO:
      RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.
   END.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add wWindow 
PROCEDURE pi-add :
/*------------------------------------------------------------------------------
  Purpose: Inclui embarque    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN emptyRowErrors IN h-bocx00442.
RUN emptyRowErrors IN h-bocx00446.
RUN emptyRowErrors IN h-bocx220na.

DO  i-cont = 1 TO brSource:NUM-SELECTED-ROWS IN FRAME fPage0:
    IF  brSource:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage0 THEN DO:
        EMPTY TEMP-TABLE tt-adiant-despes-embarq.
        IF NOT CAN-FIND(FIRST tt-adiant-despes-embarq-aux
                        WHERE tt-adiant-despes-embarq-aux.cod-estabel = tt-embarque-imp.cod-estabel
                        AND   tt-adiant-despes-embarq-aux.cod-embarq  = tt-embarque-imp.embarque) THEN DO:
            CREATE tt-adiant-despes-embarq.
            ASSIGN tt-adiant-despes-embarq.cod-estabel  = tt-embarque-imp.cod-estabel
                   tt-adiant-despes-embarq.cdd-adiant = d-cdd-adiant
                   tt-adiant-despes-embarq.cod-embarq = tt-embarque-imp.embarque
                   tt-adiant-despes-embarq.num-di-ems = tt-embarque-imp.int-2.

            RUN pi-vincula-embarque.
            IF RETURN-VALUE = "NOK":U THEN DO:
                UNDO, LEAVE.
            END.
            ELSE DO:
                DELETE tt-embarque-imp.               
            END.
        END.
    END.
END.

RUN pi-mostra-embarq.
RUN pi-mostra-adiant-embarq.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-addAll wWindow 
PROCEDURE pi-addAll :
/*------------------------------------------------------------------------------
  Purpose: Inclui todos os embarques   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN l-add-all = YES.
RUN emptyRowErrors IN h-bocx220na.

FOR EACH tt-embarque-imp:
    EMPTY TEMP-TABLE tt-adiant-despes-embarq.
    IF NOT CAN-FIND(FIRST tt-adiant-despes-embarq-aux
                    WHERE tt-adiant-despes-embarq-aux.cod-estabel = tt-embarque-imp.cod-estabel
                    AND   tt-adiant-despes-embarq-aux.cod-embarq  = tt-embarque-imp.embarque) THEN DO:
        CREATE tt-adiant-despes-embarq.
        ASSIGN tt-adiant-despes-embarq.cod-embarq = tt-embarque-imp.embarque
               tt-adiant-despes-embarq.cod-estabel  = tt-embarque-imp.cod-estabel
               tt-adiant-despes-embarq.cdd-adiant = d-cdd-adiant
               tt-adiant-despes-embarq.num-di-ems = tt-embarque-imp.int-2.
        IF NOT CAN-FIND(FIRST RowErrors 
                WHERE RowErrors.ErrorType <> "INTERNAL":U
                AND   RowErrors.errorSubType = "ERROR") THEN DO:
           RUN pi-vincula-embarque.
           IF RETURN-VALUE = "OK":U THEN DO:
              DELETE tt-embarque-imp.
           END.
           ELSE
              RETURN "NOK":U.              
        END.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-row-errors wWindow 
PROCEDURE pi-cria-row-errors :
/*------------------------------------------------------------------------------
  Purpose: Cria temp-table de erros.
  Parameters:  Envia numero do erro
               Envia parametro do erro
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM pErrorNumber      LIKE rowErrors.errorNumber     NO-UNDO.
DEFINE INPUT PARAM pErrorParameter   LIKE rowErrors.ErrorParameters NO-UNDO.

RUN utp/ut-msgs.p (INPUT 'msg',
                INPUT pErrorNumber,
                INPUT pErrorParameter).

CREATE RowErrors.
ASSIGN RowErrors.ErrorNumber      = pErrorNumber
       RowErrors.ErrorType        = "EMS":U
       RowErrors.ErrorParameters  = pErrorParameter
       RowErrors.errorDescription = RETURN-VALUE.

RUN utp/ut-msgs.p (INPUT 'help',
                INPUT pErrorNumber,
                INPUT pErrorParameter).

ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.

RUN utp/ut-msgs.p (INPUT 'CodType',
                INPUT pErrorNumber,
                INPUT pErrorParameter).

CASE RETURN-VALUE:
    WHEN '1' THEN
        ASSIGN RowErrors.ErrorSubType     = "ERROR":U.
    WHEN '2' THEN
        ASSIGN RowErrors.ErrorSubType     = "WARNING":U.
    WHEN '3' THEN
        ASSIGN RowErrors.ErrorSubType     = "QUESTION":U.
    WHEN '4' THEN
        ASSIGN RowErrors.ErrorSubType     = "INFORMATION":U.
END CASE.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-param-exec wWindow 
PROCEDURE pi-cria-tt-param-exec :
/*------------------------------------------------------------------------------
  Purpose: Seta campos do filtro da tabela embarque de importa‡Æo    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-param-exec:
    DELETE tt-param-exec.
END.

IF NOT CAN-FIND(FIRST tt-param-exec) THEN
    CREATE tt-param-exec.

FOR FIRST tt-param-exec:
    ASSIGN tt-param-exec.cod-estab-ini      = c-cod-estab 
           tt-param-exec.cod-estab-fim      = c-cod-estab 
           tt-param-exec.num-di-ems-ini     = 0
           tt-param-exec.num-di-ems-fim     = 999999999
           tt-param-exec.di-siscomex-ini    = ""
           tt-param-exec.di-siscomex-fim    = "ZZZZZZZZZZZZ"
           tt-param-exec.dat-di-ini         = 01/01/0001
           tt-param-exec.dat-di-fim         = 12/31/9999
           tt-param-exec.cdn-embarq-ini     = ""
           tt-param-exec.cdn-embarq-fim     = "ZZZZZZZZZZZZZZZZ" 
           tt-param-exec.cod-emitente-ini   = 0          
           tt-param-exec.cod-emitente-fim   = 999999999  
           tt-param-exec.nome-abrev-ini     = ""             
           tt-param-exec.nome-abrev-fim     = "ZZZZZZZZZZZZ" 
           tt-param-exec.num-pedido-ini     = 0
           tt-param-exec.num-pedido-fim     = 99999999
           tt-param-exec.numero-ordem-ini   = 0
           tt-param-exec.numero-ordem-fim   = 99999999
           tt-param-exec.nr-proc-ini        = ""
           tt-param-exec.nr-proc-fim        = "ZZZZZZZZZZZZ".
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desvincula-embarque wWindow 
PROCEDURE pi-desvincula-embarque :
/*------------------------------------------------------------------------------
  Purpose: Desvincula embarque do adiantamento    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAIL tt-adiant-despes-embarq THEN DO:
    EMPTY TEMP-TABLE tt-embarque-imp-aux.
    RUN openQueryStatic IN h-bocx220na (INPUT 'Main':U).
    RUN goToKey         IN h-bocx220na (INPUT tt-adiant-despes-embarq.cod-estabel, INPUT tt-adiant-despes-embarq.cod-embarq ).
    IF  RETURN-VALUE = "OK" THEN DO:
        RUN openQueryStatic IN h-bocx00446 (INPUT 'Main':U).
        RUN goToKey         IN h-bocx00446 (INPUT tt-adiant-despes-embarq.cod-estabel, 
                                            INPUT tt-adiant-despes-embarq.cdd-adiant, 
                                            INPUT tt-adiant-despes-embarq.num-di-ems, 
                                            INPUT tt-adiant-despes-embarq.cdd-siscomex-dts, 
                                            INPUT tt-adiant-despes-embarq.cod-embarq).
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN emptyRowErrors IN h-bocx00446.
            RUN emptyRowObject IN h-bocx00446.
            RUN setRecord      IN h-bocx00446 (INPUT TABLE tt-adiant-despes-embarq).
            RUN deleteRecord   IN h-bocx00446.
            RUN getRowErrors   IN h-bocx00446 (OUTPUT TABLE RowErrors).
            IF RETURN-VALUE = "NOK":U THEN DO:
                IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal=YES}
                    RETURN "NOK":U.
                END. 
            END. 
        END. 
        ELSE RETURN "NOK":U.
    END. 
END. 

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-empty-row-errors wWindow 
PROCEDURE pi-empty-row-errors :
/*------------------------------------------------------------------------------
  Purpose: Limpa RowErrors     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH RowErrors:
    DELETE RowErrors.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filtro-embarq wWindow 
PROCEDURE pi-filtro-embarq :
/*------------------------------------------------------------------------------
  Purpose: Executa programa de filtro dos embarques    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
RUN imp/im0720c1.w PERSISTENT SET h-im0720c1 (INPUT THIS-PROCEDURE).
IF  VALID-HANDLE (h-im0720c1) THEN DO:
    RUN initializeInterface IN h-im0720c1.
    WAIT-FOR CLOSE OF h-im0720c1 FOCUS CURRENT-WINDOW.
END. 
ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

RETURN "OK":U.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-embarq wWindow 
PROCEDURE pi-mostra-embarq :
/*------------------------------------------------------------------------------
  Purpose: Abre as query dos embarques     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*BROWSER SOURCE*/
IF NOT CAN-FIND(FIRST tt-param-exec) THEN
    RUN pi-cria-tt-param-exec.
RUN executa-parametros-busca (INPUT TABLE tt-param-exec).        

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-embarq wWindow 
PROCEDURE pi-mostra-adiant-embarq :
/*------------------------------------------------------------------------------
  Purpose: Abre as query embarques relacionados ao adiantamento      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*BROWSER TARGET*/
EMPTY TEMP-TABLE tt-adiant-despes-embarq.
EMPTY TEMP-TABLE tt-adiant-despes-embarq-aux.
RUN setConstraintByAdiant IN h-bocx00446 (INPUT c-cod-estab, INPUT d-cdd-adiant).
RUN openQueryStatic       IN h-bocx00446 (INPUT "ByAdiant":U).
RUN getBatchRecords       IN h-bocx00446 (INPUT ?,
                                          INPUT NO,
                                          INPUT 0,
                                          OUTPUT iRowsReturned,
                                          OUTPUT TABLE tt-adiant-despes-embarq).

FOR EACH tt-adiant-despes-embarq:
    CREATE tt-adiant-despes-embarq-aux.
    BUFFER-COPY tt-adiant-despes-embarq TO tt-adiant-despes-embarq-aux.
END.

{&OPEN-QUERY-brTarget}

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-remove wWindow 
PROCEDURE pi-remove :
/*------------------------------------------------------------------------------
  Purpose:  Retira embarque   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN openQueryStatic IN h-bocx220na (INPUT 'Main':U).

DO  i-cont = 1 TO brTarget:NUM-SELECTED-ROWS IN FRAME fPage0:
    IF  brTarget:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage0 THEN DO:  
        EMPTY TEMP-TABLE tt-adiant-despes-embarq.
        CREATE tt-adiant-despes-embarq.
        ASSIGN tt-adiant-despes-embarq.cod-estabel      = tt-adiant-despes-embarq-aux.cod-estabel   
               tt-adiant-despes-embarq.cdd-adiant       = tt-adiant-despes-embarq-aux.cdd-adiant
               tt-adiant-despes-embarq.cod-embarq       = tt-adiant-despes-embarq-aux.cod-embarq
               tt-adiant-despes-embarq.num-di-ems       = tt-adiant-despes-embarq-aux.num-di-ems
               tt-adiant-despes-embarq.cdd-siscomex-dts = tt-adiant-despes-embarq-aux.cdd-siscomex-dts
               tt-adiant-despes-embarq.r-Rowid          = tt-adiant-despes-embarq-aux.r-Rowid.
                               
        RUN pi-desvincula-embarque.

        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        ELSE DO:
            DELETE tt-adiant-despes-embarq-aux.
        END.                              
    END.
END.

RUN pi-mostra-embarq.
RUN pi-mostra-adiant-embarq.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-removeAll wWindow 
PROCEDURE pi-removeAll :
/*------------------------------------------------------------------------------
  Purpose: Retira todos os embarques    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN openQueryStatic IN h-bocx220na (INPUT 'Main':U).

ASSIGN l-remove-all = YES.
RUN emptyRowErrors IN h-bocx00446.
RUN emptyRowErrors IN h-bocx220na.

FOR EACH tt-adiant-despes-embarq-aux:
    EMPTY TEMP-TABLE tt-adiant-despes-embarq.
    CREATE tt-adiant-despes-embarq.
    BUFFER-COPY tt-adiant-despes-embarq-aux TO tt-adiant-despes-embarq.         
END.                 

FOR EACH tt-adiant-despes-embarq-aux:
    EMPTY TEMP-TABLE tt-adiant-despes-embarq.
    CREATE tt-adiant-despes-embarq.
    BUFFER-COPY tt-adiant-despes-embarq-aux TO tt-adiant-despes-embarq.      
    RUN pi-desvincula-embarque.
    IF RETURN-VALUE = "OK":U THEN DO:                
       DELETE tt-adiant-despes-embarq-aux.                
    END.
    ELSE
        RETURN "NOK":U.                                    
END.   

RUN pi-mostra-embarq.
RUN pi-mostra-adiant-embarq.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vincula-embarque wWindow 
PROCEDURE pi-vincula-embarque :
/*------------------------------------------------------------------------------
  Purpose: Vincula embarque ao adiantamento    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAIL tt-adiant-despes-embarq THEN DO:
    RUN goToKey IN h-bocx220na (INPUT tt-adiant-despes-embarq.cod-estabel, INPUT tt-adiant-despes-embarq.cod-embarq).
    IF  RETURN-VALUE = "OK" THEN DO:
        RUN emptyRowObject  IN h-bocx00446.
        RUN openQueryStatic IN h-bocx00446 (INPUT "Main":U).
        RUN emptyRowErrors  IN h-bocx00446.
        RUN setRecord       IN h-bocx00446 (INPUT TABLE tt-adiant-despes-embarq).
        RUN createRecord    IN h-bocx00446.
        RUN getRowErrors    IN h-bocx00446 (OUTPUT TABLE RowErrors APPEND).
        IF  CAN-FIND(FIRST RowErrors
                     WHERE RowErrors.ErrorType <> "INTERNAL":U
                     AND   RowErrors.ErrorSubType = "ERROR") THEN DO:
            RETURN "NOK":U.
        END.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDIsiscomex wWindow 
FUNCTION fnDIsiscomex RETURNS CHARACTER
  ( p-cod-estabel AS CHARACTER,
    p-embarque    AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Fun‡Æo para retornar o c¢digo da DI Siscomex 
  Notes:  
------------------------------------------------------------------------------*/
    def var cStatus as char no-undo.

    RUN findCh_embarque IN h-bocx220 (INPUT p-cod-estabel,
                                      INPUT p-embarque,
                                      OUTPUT cStatus).    
    if cStatus = "" then do:
        RUN getCharField in h-bocx220 (input "declaracao-import", output c-di-siscomex).
    end.
    ELSE 
        ASSIGN c-di-siscomex = "":U.

    RETURN c-di-siscomex.
     
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEmitente wZoom 
FUNCTION fnEmitente RETURNS CHARACTER
  ( p-cod-estabel AS CHARACTER,
    p-embarque    AS CHARACTER,
    p-opcao       AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose: Retorna nome abreviado e cnpj/cgc do emitente 
    Notes:  
------------------------------------------------------------------------------*/
  def var c-retorno       as char no-undo.
  def var c-return        as char no-undo.
  def var i-numero-ordem  as int  no-undo.
  def var i-cod-emitente  as int  no-undo.
  def var c-nome-abrev    as char no-undo.
  def var c-cgc           as char no-undo.
 
  RUN findEmbarque in h-bocx225(INPUT p-cod-estabel,
                                INPUT p-embarque,
                                OUTPUT c-return).
  IF c-return = "" THEN  
     RUN getIntField IN h-bocx225(INPUT "numero-ordem":U,OUTPUT i-numero-ordem).
  
  IF i-numero-ordem <> 0 THEN DO:
     RUN GotoKey in h-boin274 (input i-numero-ordem).
     IF RETURN-VALUE = "OK":U THEN
        RUN getIntField in h-boin274 ("cod-emitente", output i-cod-emitente).    
  END.

  IF p-opcao = 1 THEN DO:
     ASSIGN c-retorno = STRING(i-cod-emitente).
  END.
  ELSE DO:                               
     RUN getDescCGCEmitente in h-boin295desc(input i-cod-emitente,  
                                             output c-nome-abrev,   
                                             output c-cgc).          
     ASSIGN  c-retorno = c-nome-abrev.                                                                                      
  END.
  
  RETURN c-retorno.   


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
