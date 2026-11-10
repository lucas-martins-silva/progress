&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          neogrid          PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEUT105 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ANEUT105 MUT}
&ENDIF


/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE R-ROWID AS ROWID      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NGProcessMapping

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 NGProcessMapping.DocType ~
NGProcessMapping.Program NGProcessMapping.Version 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 NGProcessMapping.Program ~
NGProcessMapping.Version 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 NGProcessMapping
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 NGProcessMapping
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH NGProcessMapping NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH NGProcessMapping NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 NGProcessMapping
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 NGProcessMapping


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 bt-inclui bt-Modifica-3 ~
bt-Modifica-2 RECT-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-inclui 
     LABEL "&Inclui" 
     SIZE 10 BY 1.13.

DEFINE BUTTON bt-Modifica-2 
     LABEL "&Sair" 
     SIZE 10 BY 1.13.

DEFINE BUTTON bt-Modifica-3 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.13.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 79 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      NGProcessMapping SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 C-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      NGProcessMapping.DocType FORMAT "X(30)":U WIDTH 27.43
      NGProcessMapping.Program FORMAT "X(40)":U WIDTH 37.43
      NGProcessMapping.Version FORMAT "X(10)":U
  ENABLE
      NGProcessMapping.Program
      NGProcessMapping.Version
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 9.5 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     BROWSE-2 AT ROW 1.25 COL 2
     bt-inclui AT ROW 11.21 COL 2.14
     bt-Modifica-3 AT ROW 11.21 COL 13
     bt-Modifica-2 AT ROW 11.21 COL 69.43
     RECT-2 AT ROW 11 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 11.83.


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
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Documento X Adatpter - Neogrid S.A."
         HEIGHT             = 11.67
         WIDTH              = 80
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB BROWSE-2 1 DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "neogrid.NGProcessMapping"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > neogrid.NGProcessMapping.DocType
"NGProcessMapping.DocType" ? ? "character" ? ? ? ? ? ? no ? no no "27.43" yes no no "U" "" ""
     _FldNameList[2]   > neogrid.NGProcessMapping.Program
"NGProcessMapping.Program" ? ? "character" ? ? ? ? ? ? yes ? no no "37.43" yes no no "U" "" ""
     _FldNameList[3]   > neogrid.NGProcessMapping.Version
"NGProcessMapping.Version" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Documento X Adatpter - Neogrid S.A. */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Documento X Adatpter - Neogrid S.A. */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 C-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME DEFAULT-FRAME
DO:
  ASSIGN r-rowid = ROWID(ngprocessmapping).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inclui
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inclui C-Win
ON CHOOSE OF bt-inclui IN FRAME DEFAULT-FRAME /* Inclui */
DO:
  RUN pi-cria.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  REPOSITION   BROWSE-2 TO ROWID  R-ROWID.
    APPLY "entry" TO browse-2 .
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-Modifica-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-Modifica-2 C-Win
ON CHOOSE OF bt-Modifica-2 IN FRAME DEFAULT-FRAME /* Sair */
DO:
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-Modifica-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-Modifica-3 C-Win
ON CHOOSE OF bt-Modifica-3 IN FRAME DEFAULT-FRAME /* Eliminar */
DO:
  FIND CURRENT ngprocessmapping EXCLUSIVE-LOCK.
  MESSAGE  "Voce tem certeza que deseja apagar  tipo de documento "  ngprocessmapping.doctype "?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL UPDATE l-resp AS LOG .
  IF l-resp  THEN DO:
      DELETE ngprocessmapping.
      {&OPEN-QUERY-{&BROWSE-NAME}}
  END.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  APPLY "value-changed" TO BROWSE-2 IN FRAME {&FRAME-NAME}.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE BROWSE-2 bt-inclui bt-Modifica-3 bt-Modifica-2 RECT-2 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria C-Win 
PROCEDURE pi-cria :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUTTON bt-inclui 
     LABEL "&OK" 
     SIZE 10 BY 1.13.

DEFINE BUTTON bt-cancel 
     LABEL "&Cancela" 
     SIZE 10 BY 1.13.

DEFINE VARIABLE c-doctype AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Docto" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 46 BY 1.50
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */


DEFINE FRAME FRAME-C
     c-doctype AT ROW 2 COL 13 COLON-ALIGNED
     bt-inclui AT ROW 4.71 COL 2.14
     bt-Cancel AT ROW 4.71 COL 13.14
     RECT-2 AT ROW 4.5 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 12 ROW 5
         SIZE 49 BY 6.25 VIEW-AS DIALOG-BOX.




                                                                        
ASSIGN 
       FRAME FRAME-C:HIDDEN           = FALSE
       FRAME frame-c:SCROLLABLE       = FALSE .



ENABLE ALL WITH FRAME frame-c.

&Scoped-define FRAME-NAME FRAME-C
&Scoped-define SELF-NAME bt-inclui
ON CHOOSE OF bt-inclui IN FRAME FRAME-C /* Inclui */
DO:

  HIDE FRAME FRAME-c.
  FIND ngprocessmapping WHERE ngprocessmapping.doctype =  INPUT FRAME frame-c c-doctype NO-LOCK NO-ERROR.
  IF NOT AVAIL ngprocessmapping THEN DO:
      CREATE ngprocessmapping.
      ASSIGN ngprocessmapping.doctype = INPUT FRAME frame-c c-doctype.
  END.
  ELSE MESSAGE "J  existe ocorrencia cadastrada para este tipo de documento!!!"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
  ASSIGN R-ROWID = ROWID(ngprocessmapping).
END.

ON CHOOSE OF bt-cancel IN FRAME FRAME-C /* Inclui */
DO:   
  HIDE FRAME FRAME-c.
END.


   WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW OR CHOOSE OF bt-inclui OR CHOOSE OF bt-cancel.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

