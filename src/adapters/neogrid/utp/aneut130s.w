&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          neogrid          PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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

define variable l-resp as logical format "Sim/N„o" initial no no-undo.

DEFINE VAR delay    AS INT INIT 5.
define buffer b-NGMessageQueue for NGMessageQueue.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHAR NO-UNDO.
DEFINE VARIABLE l-processando AS LOGICAL INITIAL YES.
DEFINE VARIABLE c-string AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-texto AS CHARACTER  NO-UNDO.
DEFINE VARIABLE r-rowid AS ROWID      NO-UNDO.
DEF VAR l-first  AS LOG.
DEF VAR l-resultlist AS LOG.

DEFINE VARIABLE i AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-ini AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-fim AS INTEGER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-princ
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NGMessageQueue

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 NGMessageQueue.DateTime ~
NGMessageQueue.NGMessageQueueID NGMessageQueue.NGMessageQueueName ~
NGMessageQueue.Done 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH NGMessageQueue NO-LOCK ~
    BY NGMessageQueue.NGMessageQueueID DESCENDING ~
       BY NGMessageQueue.NGMessageQueueSequence DESCENDING.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 NGMessageQueue
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 NGMessageQueue


/* Definitions for FRAME f-princ                                        */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-princ ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-XMLMessage BROWSE-1 bt-fechar bt-atualiza ~
bt-delete bt-deleteproc bt-deletenproc bt-exporta bt-reprocessa ~
bt-visualizaxml bt-processMapping bt-Search RECT-1 
&Scoped-Define DISPLAYED-OBJECTS c-XMLMessage 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-BROWSE-1 
       MENU-ITEM m_Selecione_Todas LABEL "Select All"    
       MENU-ITEM m_Deselecione_Todas LABEL "Deselect All"  .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-atualiza AUTO-GO 
     LABEL "Refresh (F5)" 
     SIZE 12 BY 1.5.

DEFINE BUTTON bt-delete 
     LABEL "Delete" 
     SIZE 10 BY 1.5.

DEFINE BUTTON bt-deletenproc 
     LABEL "Delete Not Processed" 
     SIZE 21.14 BY 1.5.

DEFINE BUTTON bt-deleteproc 
     LABEL "Delete Processed" 
     SIZE 18 BY 1.5.

DEFINE BUTTON bt-exporta 
     LABEL "Export" 
     SIZE 10 BY 1.5.

DEFINE BUTTON bt-fechar 
     LABEL "Close" 
     SIZE 10 BY 1.5.

DEFINE BUTTON bt-processMapping 
     LABEL "Msg X Adapter" 
     SIZE 18 BY 1.5.

DEFINE BUTTON bt-reprocessa 
     LABEL "Reprocess" 
     SIZE 12 BY 1.5.

DEFINE BUTTON bt-Search 
     LABEL "Search" 
     SIZE 11.72 BY 1.5.

DEFINE BUTTON bt-visualizaxml 
     LABEL "View" 
     SIZE 10 BY 1.5.

DEFINE VARIABLE c-XMLMessage AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 31000 SCROLLBAR-VERTICAL
     SIZE 40 BY 13.75
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 78 BY 4.92
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      NGMessageQueue SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 C-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      NGMessageQueue.DateTime FORMAT "X(20)":U WIDTH 16.43
      NGMessageQueue.NGMessageQueueID FORMAT "->,>>>,>>9":U WIDTH 8.43
      NGMessageQueue.NGMessageQueueName COLUMN-LABEL "Dir" FORMAT "X(3)":U
            WIDTH 3.43
      NGMessageQueue.Done FORMAT "true/false":U WIDTH 4.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 36 BY 13.63
         FONT 2 ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-princ
     c-XMLMessage AT ROW 1 COL 39 NO-LABEL
     BROWSE-1 AT ROW 1.13 COL 2
     bt-fechar AT ROW 15.71 COL 2
     bt-atualiza AT ROW 15.71 COL 13
     bt-delete AT ROW 15.71 COL 26
     bt-deleteproc AT ROW 15.71 COL 37.14
     bt-deletenproc AT ROW 15.71 COL 56
     bt-exporta AT ROW 17.75 COL 2
     bt-reprocessa AT ROW 17.75 COL 13
     bt-visualizaxml AT ROW 17.75 COL 26
     bt-processMapping AT ROW 17.75 COL 37
     bt-Search AT ROW 17.75 COL 56.43
     RECT-1 AT ROW 15 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 93.14 BY 19.5.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Message Viewer"
         HEIGHT             = 19.75
         WIDTH              = 78.57
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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
/* SETTINGS FOR FRAME f-princ
                                                                        */
/* BROWSE-TAB BROWSE-1 c-XMLMessage f-princ */
ASSIGN 
       BROWSE-1:POPUP-MENU IN FRAME f-princ             = MENU POPUP-MENU-BROWSE-1:HANDLE
       BROWSE-1:ALLOW-COLUMN-SEARCHING IN FRAME f-princ = TRUE
       BROWSE-1:COLUMN-MOVABLE IN FRAME f-princ         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "neogrid.NGMessageQueue"
     _Options          = "NO-LOCK"
     _OrdList          = "neogrid.NGMessageQueue.NGMessageQueueID|no,neogrid.NGMessageQueue.NGMessageQueueSequence|no"
     _FldNameList[1]   > neogrid.NGMessageQueue.DateTime
"DateTime" ? ? "character" ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" ""
     _FldNameList[2]   > neogrid.NGMessageQueue.NGMessageQueueID
"NGMessageQueueID" ? ? "integer" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" ""
     _FldNameList[3]   > neogrid.NGMessageQueue.NGMessageQueueName
"NGMessageQueueName" "Dir" ? "character" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" ""
     _FldNameList[4]   > neogrid.NGMessageQueue.Done
"Done" ? ? "logical" ? ? ? ? ? ? no ? no no "4.29" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Message Viewer */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Message Viewer */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 C-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-1 IN FRAME f-princ
DO:
  APPLY "choose" TO bt-visualizaxml.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 C-Win
ON VALUE-CHANGED OF BROWSE-1 IN FRAME f-princ
DO:
  
    FIND FIRST b-ngmessagequeue NO-LOCK
        WHERE b-ngmessagequeue.ngmessagequeueid       = ngmessagequeue.ngmessagequeueid
          AND b-ngmessagequeue.ngmessagequeuesequence = ngmessagequeue.ngmessagequeuesequence NO-ERROR.
    IF  AVAIL b-ngmessagequeue THEN DO:
        ASSIGN c-texto = REPLACE(b-ngmessagequeue.xmlmessage,"><",">" + CHR(10) + "<").
       /* ASSIGN c-texto = REPLACE(c-texto,"/>","/>" + CHR(10)).*/
    END.
    ELSE c-texto = "".

    c-xmlmessage:SCREEN-VALUE = c-texto .

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-atualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualiza C-Win
ON CHOOSE OF bt-atualiza IN FRAME f-princ /* Refresh (F5) */
DO:
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-delete C-Win
ON CHOOSE OF bt-delete IN FRAME f-princ /* Delete */
DO:
    

    MESSAGE "Confirm the Selected record(s) exclusion?" VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO TITLE "Exclus∆o de mensagens" UPDATE l-resp.

    DO i = 1 TO browse-1:NUM-SELECTED-ROWS:
          browse-1:FETCH-SELECTED-ROW( i ).
        IF  AVAIL NGMessageQueue THEN DO:
            IF  l-resp THEN DO:
                FOR EACH b-ngmessagequeue NO-LOCK
                    WHERE b-ngmessagequeue.ngmessagequeueid = ngmessagequeue.ngmessagequeueid:
                    DELETE b-ngmessagequeue.
                END.
            END.
        END.
    END.
    IF browse-1:NUM-SELECTED-ROWS <> 0 THEN  DO :
        {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-deletenproc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-deletenproc C-Win
ON CHOOSE OF bt-deletenproc IN FRAME f-princ /* Delete Not Processed */
DO:
    IF  CAN-FIND(FIRST NGMessageQueue) THEN DO:
        MESSAGE "Confirm The Exclusion of all not Processed Records ?" VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO TITLE "Exclus∆o de mensagens" UPDATE l-resp.
        IF  l-resp THEN DO:
            FOR EACH NGMessageQueue 
                WHERE NGMessageQueue.Done = FALSE EXCLUSIVE-LOCK:
                DELETE NGMessageQueue.
            END.  
            {&OPEN-QUERY-{&BROWSE-NAME}}
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-deleteproc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-deleteproc C-Win
ON CHOOSE OF bt-deleteproc IN FRAME f-princ /* Delete Processed */
DO:
    IF  CAN-FIND(FIRST NGMessageQueue) THEN DO:
        MESSAGE "Confirm The Exclusion of all Processed Records ?" VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO TITLE "Exclus∆o de mensagens" UPDATE l-resp.
        IF  l-resp THEN DO:
            FOR EACH NGMessageQueue 
                WHERE NGMessageQueue.Done = TRUE EXCLUSIVE-LOCK:
                DELETE NGMessageQueue.
            END.  
            {&OPEN-QUERY-{&BROWSE-NAME}}
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exporta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exporta C-Win
ON CHOOSE OF bt-exporta IN FRAME f-princ /* Export */
DO:

    DEFINE VARIABLE c-aux AS CHARACTER  NO-UNDO.
     DEF VAR arq-xml AS CHAR INIT "neogrid.xml".

    ASSIGN c-aux = IF browse-1:NUM-SELECTED-ROWS > 1 
                      THEN "Directory Name:"
                      ELSE "File Name:"
           arq-xml = IF browse-1:NUM-SELECTED-ROWS > 1 
                      THEN SESSION:TEMP-DIRECTORY
                      ELSE  SESSION:TEMP-DIRECTORY + String(ngmessagequeue.ngmessagequeueid) + ".xml".
     MESSAGE c-aux UPDATE arq-xml FORMAT "x(60)".

    DO i = 1 TO browse-1:NUM-SELECTED-ROWS:
        browse-1:FETCH-SELECTED-ROW( i ).
        IF  AVAIL ngmessagequeue THEN DO:
          OUTPUT TO VALUE(arq-xml + IF c-aux = "File Name:" THEN '' ELSE ('\' + STRING(ngmessagequeue.ngmessagequeueid) + ".xml" )) CONVERT TARGET "iso8859-1".
          FOR EACH b-ngmessagequeue NO-LOCK
              WHERE b-ngmessagequeue.ngmessagequeueid = ngmessagequeue.ngmessagequeueid:
              PUT b-ngmessagequeue.xmlmessage.
          END.
          OUTPUT CLOSE.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fechar C-Win
ON CHOOSE OF bt-fechar IN FRAME f-princ /* Close */
DO: 
    IF INDEX(PROGRAM-NAME(3),'men903za') <> ? 
        THEN APPLY "close" TO THIS-PROCEDURE.
        ELSE QUIT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-processMapping
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-processMapping C-Win
ON CHOOSE OF bt-processMapping IN FRAME f-princ /* Msg X Adapter */
DO:
      RUN adapters\neogrid\utp\aneut105.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-reprocessa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-reprocessa C-Win
ON CHOOSE OF bt-reprocessa IN FRAME f-princ /* Reprocess */
DO:
      DO i = 1 TO browse-1:NUM-SELECTED-ROWS:
          browse-1:FETCH-SELECTED-ROW( i ).
    IF  AVAIL ngmessagequeue THEN DO TRANSACTION:
        FOR EACH b-ngmessagequeue NO-LOCK
            WHERE b-ngmessagequeue.ngmessagequeueid = ngmessagequeue.ngmessagequeueid:
            ASSIGN b-ngmessagequeue.done = NO.
        END.
    END.
      END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-Search
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-Search C-Win
ON CHOOSE OF bt-Search IN FRAME f-princ /* Search */
DO:
  RUN adapters\neogrid\utp\aneut130b.w (INPUT-OUTPUT c-string, INPUT-OUTPUT l-first, INPUT-OUTPUT l-resultlist,OUTPUT i-ini, OUTPUT i-fim).

  ASSIGN c-string = "*" + trim(c-string) + "*".

  IF l-first  THEN DO:
      FOR EACH b-ngmessagequeue NO-LOCK WHERE b-ngmessagequeue.xmlmessage MATCHES c-string 
                                          AND b-ngmessagequeue.ngmessagequeueid  >= i-ini 
                                          AND b-ngmessagequeue.ngmessagequeueid  <= i-fim BY b-ngmessagequeue.ngmessagequeueid DESC.
           BROWSE browse-1:DESELECT-ROWS().
         MESSAGE b-ngmessagequeue.ngmessagequeueid VIEW-AS ALERT-BOX INFO BUTTONS OK.
         REPOSITION  browse-1 TO ROWID(rowid(b-ngmessagequeue)).
         browse-1:SELECT-FOCUSED-ROW ( ).
         APPLY "VALUE-CHANGED" TO BROWSE browse-1.
         APPLY "entry" TO c-xmlmessage.
         c-xmlmessage:SEARCH(c-string,1).
         LEAVE.
      END.
  END.
  IF l-resultlist THEN DO:
      RUN adapters\neogrid\utp\aneut130c.w (INPUT-OUTPUT c-string, OUTPUT r-rowid , INPUT i-ini, INPUT i-fim).
      IF r-rowid <> ?  THEN DO: 
           BROWSE browse-1:DESELECT-ROWS(). 
          REPOSITION  browse-1 TO ROWID(r-rowid).
          browse-1:SELECT-FOCUSED-ROW ( ).
          APPLY "VALUE-CHANGED" TO BROWSE browse-1.
          APPLY "entry" TO c-xmlmessage.
      END.
  END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-visualizaxml
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-visualizaxml C-Win
ON CHOOSE OF bt-visualizaxml IN FRAME f-princ /* View */
DO:
    OUTPUT TO  VALUE (SESSION:TEMP-DIRECTORY + "tmp.xml") CONVERT TARGET "iso8859-1".
  FOR EACH b-ngmessagequeue NO-LOCK
        WHERE b-ngmessagequeue.ngmessagequeueid = ngmessagequeue.ngmessagequeueid:
          PUT b-ngmessagequeue.xmlmessage.
  END.
  OUTPUT CLOSE.    
  DOS SILENT explorer VALUE(SESSION:TEMP-DIRECTORY + "tmp.xml").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-XMLMessage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-XMLMessage C-Win
ON CTRL-F OF c-XMLMessage IN FRAME f-princ
DO:
  RUN adapters\neogrid\utp\aneut130a.w (INPUT-OUTPUT c-string).
  IF NOT c-xmlmessage:SEARCH(c-string,1) THEN DO:
      MESSAGE "Text not Found!"
          VIEW-AS ALERT-BOX warning  BUTTONS OK.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-XMLMessage C-Win
ON F9 OF c-XMLMessage IN FRAME f-princ
DO:
    IF NOT c-xmlmessage:SEARCH(c-string,1) THEN DO:
      MESSAGE "Text not Found!"
          VIEW-AS ALERT-BOX warning  BUTTONS OK.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-XMLMessage C-Win
ON LEAVE OF c-XMLMessage IN FRAME f-princ
DO:
  IF c-xmlmessage:SCREEN-VALUE <> c-texto THEN DO:
      MESSAGE "Deseja salvar as alteraáoes feitas na Mensagem?" 
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-resp AS LOGICAL.
      IF l-resp THEN DO:
          FIND CURRENT ngmessagequeue EXCLUSIVE-LOCK NO-ERROR.
          ASSIGN ngmessagequeue.xmlmessage = REPLACE(c-xmlmessage:SCREEN-VALUE,CHR(10),"").
          FIND CURRENT ngmessagequeue NO-LOCK NO-ERROR.  
          APPLY "VALUE-CHANGED" TO BROWSE browse-1.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-XMLMessage C-Win
ON SHIFT-F9 OF c-XMLMessage IN FRAME f-princ
DO:
    IF NOT c-xmlmessage:SEARCH(c-string,2) THEN DO:
       MESSAGE "Text not Found!"
           VIEW-AS ALERT-BOX warning  BUTTONS OK.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Deselecione_Todas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Deselecione_Todas C-Win
ON CHOOSE OF MENU-ITEM m_Deselecione_Todas /* Deselect All */
DO:
  BROWSE browse-1:DESELECT-ROWS().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Selecione_Todas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Selecione_Todas C-Win
ON CHOOSE OF MENU-ITEM m_Selecione_Todas /* Select All */
DO:
 BROWSE  browse-1:SELECT-ALL() .
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
   APPLY "VALUE-CHANGED" TO BROWSE browse-1.
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
  DISPLAY c-XMLMessage 
      WITH FRAME f-princ IN WINDOW C-Win.
  ENABLE c-XMLMessage BROWSE-1 bt-fechar bt-atualiza bt-delete bt-deleteproc 
         bt-deletenproc bt-exporta bt-reprocessa bt-visualizaxml 
         bt-processMapping bt-Search RECT-1 
      WITH FRAME f-princ IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-princ}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

