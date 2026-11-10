&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva  da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0100A1 2.00.00.012 } /*** "010012" 16/09/2025 16:13:57 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0100a1 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0100a1
&GLOBAL-DEFINE Version        2.00.00.012

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

{cxbo/bocx220c.i1 tt-item-doc-est}

/* Temporary Table Definitions ---                                      */
DEF TEMP-TABLE ttEmbarque NO-UNDO
    FIELD marcado      AS   LOGICAL
    FIELD selecionado  AS   CHAR FORMAT "X(1)":U
    FIELD embarque     LIKE ordens-embarque.embarque /*AS   CHARACTER FORMAT 'x(12)':U*/
    field numero-ordem LIKE ordens-embarque.numero-ordem
    field parcela      LIKE ordens-embarque.parcela
    field sequencial   AS   INTEGER
    FIELD r-Rowid      AS   ROWID.

/* Parameters Definitions ---                                           */
DEF INPUT  PARAM phCaller  AS HANDLE NO-UNDO.
DEF INPUT  PARAM TABLE FOR tt-item-doc-est.
/*DEF OUTPUT PARAM TABLE FOR ttEmbarque.*/

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brEmbarque

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttEmbarque

/* Definitions for BROWSE brEmbarque                                    */
&Scoped-define FIELDS-IN-QUERY-brEmbarque ttEmbarque.selecionado ttEmbarque.embarque   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brEmbarque   
&Scoped-define SELF-NAME brEmbarque
&Scoped-define QUERY-STRING-brEmbarque FOR EACH ttEmbarque
&Scoped-define OPEN-QUERY-brEmbarque OPEN QUERY {&SELF-NAME} FOR EACH ttEmbarque.
&Scoped-define TABLES-IN-QUERY-brEmbarque ttEmbarque
&Scoped-define FIRST-TABLE-IN-QUERY-brEmbarque ttEmbarque


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brEmbarque}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-87 brEmbarque btOK btCancel ~
btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-87
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58 BY 7.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 58 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brEmbarque FOR 
      ttEmbarque SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brEmbarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brEmbarque wWindow _FREEFORM
  QUERY brEmbarque DISPLAY
      ttEmbarque.selecionado
      ttEmbarque.embarque
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 44 BY 5.83
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     brEmbarque AT ROW 2.25 COL 8.43 WIDGET-ID 200
     btOK AT ROW 9.13 COL 2
     btCancel AT ROW 9.13 COL 13
     btHelp2 AT ROW 9.13 COL 48.57
     "Embarques - Itens Controlados por S‚rie" VIEW-AS TEXT
          SIZE 28 BY .54 AT ROW 1.21 COL 2 WIDGET-ID 4
     rtToolBar AT ROW 8.92 COL 1.29
     RECT-87 AT ROW 1.46 COL 1.29 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 58.57 BY 9.54
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 9.58
         WIDTH              = 58.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 93.72
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 93.72
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
/* BROWSE-TAB brEmbarque RECT-87 fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brEmbarque
/* Query rebuild information for BROWSE brEmbarque
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttEmbarque.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brEmbarque */
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


&Scoped-define BROWSE-NAME brEmbarque
&Scoped-define SELF-NAME brEmbarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brEmbarque wWindow
ON MOUSE-SELECT-DBLCLICK OF brEmbarque IN FRAME fpage0
DO:
    IF  AVAIL  ttEmbarque THEN
        IF ttEmbarque.marcado THEN 
            ASSIGN ttEmbarque.marcado     = NO
                   ttEmbarque.selecionado = "".
        ELSE
            ASSIGN ttEmbarque.marcado     = YES
                   ttEmbarque.selecionado = "*".

    {&OPEN-QUERY-brEmbarque}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    
    RUN pi-monta-ttEmbarque IN phCaller(INPUT TABLE ttEmbarque). /* carrega a tt que alimenta o browse do im0100a */
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    ENABLE brEmbarque
        WITH FRAME fPage0.

    RUN pi-carregaTT.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carregaTT wWindow 
PROCEDURE pi-carregaTT :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEF VAR h-bocx225na AS HANDLE    NO-UNDO.
    DEF VAR c-return    AS CHARACTER NO-UNDO.
    DEF VAR cembarque   AS CHARACTER NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx225na) THEN RUN cxbo\bocx225na.p PERSISTENT SET h-bocx225na.

    FOR EACH tt-item-doc-est:
        RUN FindOrdensEmbarque IN h-bocx225na (INPUT tt-item-doc-est.numero-ordem, INPUT tt-item-doc-est.parcela, OUTPUT c-return).
        IF  c-return = "" 
        THEN RUN getCharField IN h-bocx225na ("embarque":U, OUTPUT cembarque).
        ELSE ASSIGN cembarque = "".

        IF  cembarque <> "" THEN DO:
            IF  NOT CAN-FIND(FIRST ttEmbarque WHERE ttEmbarque.embarque = cembarque) THEN DO:
                CREATE ttEmbarque.
                ASSIGN ttEmbarque.embarque     = cembarque
                       ttEmbarque.marcado      = tt-item-doc-est.l-selecionado
                       ttEmbarque.selecionado  = "*" WHEN tt-item-doc-est.l-selecionado
                       ttEmbarque.selecionado  = ""  WHEN NOT tt-item-doc-est.l-selecionado 
                       ttEmbarque.numero-ordem = tt-item-doc-est.numero-ordem
                       ttEmbarque.parcela      = tt-item-doc-est.parcela
                       ttEmbarque.sequencial   = tt-item-doc-est.sequencial.
            END. /* IF  NOT CAN-FIND(FIRST ttEmbarque */
        END. /* IF  cembarque <> "" THEN DO: */
        ELSE NEXT.
    END. /* FOR EACH tt-item-doc-est: */

    {&OPEN-QUERY-brEmbarque}

    IF VALID-HANDLE(h-bocx225na) THEN DO:
        DELETE PROCEDURE h-bocx225na.
        ASSIGN h-bocx225na = ?.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
