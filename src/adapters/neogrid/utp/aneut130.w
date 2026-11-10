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

define variable l-resp as logical format "Sim/N∆o":U initial no no-undo.

DEFINE VAR delay    AS INT INIT 5.
define buffer b-NGMessageQueue for NGMessageQueue.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHAR NO-UNDO.
DEFINE VARIABLE l-processando AS LOGICAL INITIAL YES.
DEFINE VARIABLE c-string AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-texto AS CHARACTER  NO-UNDO.
DEFINE VARIABLE r-rowid AS ROWID      NO-UNDO.
DEFINE VARIABLE c-messages AS CHARACTER NO-UNDO INIT "IN,OUT".
DEF VAR l-first  AS LOG.
DEF VAR l-resultlist AS LOG.

DEFINE VARIABLE i AS INTEGER    NO-UNDO.
DEFINE VARIABLE pi-ini AS INTEGER    NO-UNDO.
DEFINE VARIABLE pi-fim AS INTEGER    NO-UNDO.
DEFINE VARIABLE pd-ini AS DATE       NO-UNDO.
DEFINE VARIABLE pd-fim AS DATE       NO-UNDO.
DEFINE VARIABLE ph-ini AS CHAR       NO-UNDO.
DEFINE VARIABLE ph-fim AS CHAR       NO-UNDO.
DEFINE VARIABLE pt-in  AS LOG        NO-UNDO.
DEFINE VARIABLE pt-out AS LOG        NO-UNDO.

DEFINE VARIABLE i-height AS dec   NO-UNDO.
DEFINE VARIABLE i-last-height AS DEC  INIT 15   NO-UNDO.

DEFINE VARIABLE c-from   AS CHAR NO-UNDO FORMAT "x(04)".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-princ
&Scoped-define BROWSE-NAME br-messagequeue

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NGMessageQueue

/* Definitions for BROWSE br-messagequeue                               */
&Scoped-define FIELDS-IN-QUERY-br-messagequeue NGMessageQueue.DateTime ~
NGMessageQueue.NGMessageQueueID NGMessageQueue.NGMessageQueueSequence ~
NGMessageQueue.NGMessageQueueName NGMessageQueue.Done fnfrom() @ c-from 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-messagequeue 
&Scoped-define OPEN-QUERY-br-messagequeue OPEN QUERY br-messagequeue FOR EACH NGMessageQueue NO-LOCK ~
    BY NGMessageQueue.NGMessageQueueID DESCENDING ~
       BY NGMessageQueue.NGMessageQueueSequence DESCENDING.
&Scoped-define TABLES-IN-QUERY-br-messagequeue NGMessageQueue
&Scoped-define FIRST-TABLE-IN-QUERY-br-messagequeue NGMessageQueue


/* Definitions for FRAME f-princ                                        */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-princ ~
    ~{&OPEN-QUERY-br-messagequeue}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-messagequeue c-XMLMessage bt-fechar ~
bt-atualiza bt-delete bt-deleteproc bt-deletenproc bt-exporta bt-reprocessa ~
bt-visualizaxml bt-processMapping bt-Search RECT-1 
&Scoped-Define DISPLAYED-OBJECTS c-XMLMessage 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnfrom C-Win 
FUNCTION fnfrom RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br-messagequeue 
       MENU-ITEM m_Selecione_Todas LABEL "Select All":U    
       MENU-ITEM m_Deselecione_Todas LABEL "Deselect All":U  .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-atualiza AUTO-GO 
     LABEL "Refresh (F5)":U 
     SIZE 12 BY 1.

DEFINE BUTTON bt-delete 
     LABEL "Delete":U 
     SIZE 10 BY 1.

DEFINE BUTTON bt-deletenproc 
     LABEL "Delete Not Processed":U 
     SIZE 21.14 BY 1.

DEFINE BUTTON bt-deleteproc 
     LABEL "Delete Processed":U 
     SIZE 18 BY 1.

DEFINE BUTTON bt-exporta 
     LABEL "Export":U 
     SIZE 10 BY 1.

DEFINE BUTTON bt-fechar 
     LABEL "Close":U 
     SIZE 10 BY 1.

DEFINE BUTTON bt-processMapping 
     LABEL "Msg X Adapter":U 
     SIZE 18 BY 1.

DEFINE BUTTON bt-reprocessa 
     LABEL "Reprocess":U 
     SIZE 12 BY 1.

DEFINE BUTTON bt-Search 
     LABEL "Search":U 
     SIZE 11.72 BY 1.

DEFINE BUTTON bt-visualizaxml 
     LABEL "View":U 
     SIZE 10 BY 1.

DEFINE VARIABLE c-XMLMessage AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 31000 SCROLLBAR-VERTICAL
     SIZE 50.14 BY 11.08
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 99 BY 2.67
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-messagequeue FOR 
      NGMessageQueue SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-messagequeue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-messagequeue C-Win _STRUCTURED
  QUERY br-messagequeue NO-LOCK DISPLAY
      NGMessageQueue.DateTime FORMAT "X(20)":U WIDTH 19.43
      NGMessageQueue.NGMessageQueueID COLUMN-LABEL "ID" FORMAT "->>>,>>>,>>9":U
            WIDTH 7.43
      NGMessageQueue.NGMessageQueueSequence COLUMN-LABEL "Seq" FORMAT "->,>>>,>>9":U
            WIDTH 3.43
      NGMessageQueue.NGMessageQueueName COLUMN-LABEL "Dir" FORMAT "X(3)":U
            WIDTH 3.43
      NGMessageQueue.Done FORMAT "yes/no":U WIDTH 4.29
      fnfrom() @ c-from COLUMN-LABEL "Orig"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 48.2 BY 11.13
         FONT 2 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-princ
     br-messagequeue AT ROW 1.13 COL 2
     c-XMLMessage AT ROW 1.17 COL 50.72 NO-LABEL
     bt-fechar AT ROW 12.79 COL 3
     bt-atualiza AT ROW 12.79 COL 14
     bt-delete AT ROW 12.79 COL 27
     bt-deleteproc AT ROW 12.79 COL 38
     bt-deletenproc AT ROW 12.79 COL 57
     bt-exporta AT ROW 14 COL 3
     bt-reprocessa AT ROW 14 COL 14
     bt-visualizaxml AT ROW 14 COL 27
     bt-processMapping AT ROW 14 COL 38
     bt-Search AT ROW 14 COL 57
     RECT-1 AT ROW 12.58 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 146.29 BY 29.


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
         TITLE              = "Message Viewer"
         HEIGHT             = 14.5
         WIDTH              = 101.72
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
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
/* BROWSE-TAB br-messagequeue 1 f-princ */
ASSIGN 
       br-messagequeue:POPUP-MENU IN FRAME f-princ             = MENU POPUP-MENU-br-messagequeue:HANDLE
       br-messagequeue:ALLOW-COLUMN-SEARCHING IN FRAME f-princ = TRUE
       br-messagequeue:COLUMN-MOVABLE IN FRAME f-princ         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-messagequeue
/* Query rebuild information for BROWSE br-messagequeue
     _TblList          = "neogrid.NGMessageQueue"
     _Options          = "NO-LOCK"
     _OrdList          = "neogrid.NGMessageQueue.NGMessageQueueID|no,neogrid.NGMessageQueue.NGMessageQueueSequence|no"
     _FldNameList[1]   > neogrid.NGMessageQueue.DateTime
"DateTime" ? ? "character" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" ""
     _FldNameList[2]   > neogrid.NGMessageQueue.NGMessageQueueID
"NGMessageQueueID" "ID" ? "integer" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" ""
     _FldNameList[3]   > neogrid.NGMessageQueue.NGMessageQueueSequence
"NGMessageQueueSequence" "Seq" ? "integer" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" ""
     _FldNameList[4]   > neogrid.NGMessageQueue.NGMessageQueueName
"NGMessageQueueName" "Dir" ? "character" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" ""
     _FldNameList[5]   > neogrid.NGMessageQueue.Done
"Done" ? ? "logical" ? ? ? ? ? ? no ? no no "4.29" yes no no "U" "" ""
     _FldNameList[6]   > "_<CALC>"
"fnfrom() @ c-from" "Orig" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE br-messagequeue */
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
ON î OF C-Win /* Message Viewer */
DO:
  MESSAGE "vou processar!"
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
  RUN adapters/neogrid/utp/aneut103.p.
  MESSAGE "Fim do processamento!"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-MAXIMIZED OF C-Win /* Message Viewer */
DO:
  MESSAGE c-win:HEIGHT
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win /* Message Viewer */
DO:
  
/*   ASSIGN i-height             = c-win:HEIGHT - i-last-height .             */
/*   MESSAGE i-height                                                         */
/*       VIEW-AS ALERT-BOX INFO BUTTONS OK.                                   */
/*   ASSIGN FRAME f-princ:HEIGHT         =  FRAME f-princ:HEIGHT + i-height . */
/*   MESSAGE FRAME f-princ:HEIGHT                                             */
/*       VIEW-AS ALERT-BOX INFO BUTTONS OK.                                   */
/*   ASSIGN rect-1:ROW IN FRAME f-princ  = rect-1:ROW + i-height.             */
/*   ASSIGN i-last-height = c-win:HEIGHT.                                     */

  
  


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-messagequeue
&Scoped-define SELF-NAME br-messagequeue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-messagequeue C-Win
ON MOUSE-SELECT-DBLCLICK OF br-messagequeue IN FRAME f-princ
DO:
  APPLY "choose" TO bt-visualizaxml.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-messagequeue C-Win
ON VALUE-CHANGED OF br-messagequeue IN FRAME f-princ
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
    {&OPEN-QUERY-br-messagequeue}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-delete C-Win
ON CHOOSE OF bt-delete IN FRAME f-princ /* Delete */
DO:
    

    MESSAGE "Confirm the Selected record(s) exclusion?" VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO TITLE "Exclus∆o de mensagens" UPDATE l-resp.

    DO i = 1 TO br-messagequeue:NUM-SELECTED-ROWS:
          br-messagequeue:FETCH-SELECTED-ROW( i ).
        IF  AVAIL NGMessageQueue THEN DO:
            IF  l-resp THEN DO:
                FOR EACH b-ngmessagequeue EXCLUSIVE-LOCK
                    WHERE b-ngmessagequeue.ngmessagequeueid = ngmessagequeue.ngmessagequeueid:
                    DELETE b-ngmessagequeue.
                END.
            END.
        END.
    END.
    IF br-messagequeue:NUM-SELECTED-ROWS <> 0 THEN  DO :
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

    ASSIGN c-aux = IF br-messagequeue:NUM-SELECTED-ROWS > 1 
                      THEN "Directory Name:"
                      ELSE "File Name:"
           arq-xml = IF br-messagequeue:NUM-SELECTED-ROWS > 1 
                      THEN SESSION:TEMP-DIRECTORY
                      ELSE  SESSION:TEMP-DIRECTORY + String(ngmessagequeue.ngmessagequeueid) + ".xml".
     MESSAGE c-aux UPDATE arq-xml FORMAT "x(60)".

    DO i = 1 TO br-messagequeue:NUM-SELECTED-ROWS:
        br-messagequeue:FETCH-SELECTED-ROW( i ).
        IF  AVAIL ngmessagequeue THEN DO:
          OUTPUT TO VALUE(arq-xml + IF c-aux = "File Name:" THEN '' ELSE ('~\' + STRING(ngmessagequeue.ngmessagequeueid) + ".xml" )) CONVERT TARGET "iso8859-1".
          FOR EACH b-ngmessagequeue NO-LOCK
              WHERE b-ngmessagequeue.ngmessagequeueid = ngmessagequeue.ngmessagequeueid:
              PUT UNFORMATTED b-ngmessagequeue.xmlmessage.
          END.
          PUT UNFORMATTED SKIP.
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
      RUN adapters/neogrid/utp/aneut105.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-reprocessa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-reprocessa C-Win
ON ALT-CTRL-B OF bt-reprocessa IN FRAME f-princ /* Reprocess */
DO:
    MESSAGE "vou processar!"
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
  RUN adapters/neogrid/utp/aneut103.p.
  MESSAGE "Fim do processamento!"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-reprocessa C-Win
ON CHOOSE OF bt-reprocessa IN FRAME f-princ /* Reprocess */
DO:
      DO i = 1 TO br-messagequeue:NUM-SELECTED-ROWS:
          br-messagequeue:FETCH-SELECTED-ROW( i ).
    IF  AVAIL ngmessagequeue THEN DO TRANSACTION:
        FOR EACH b-ngmessagequeue EXCLUSIVE-LOCK
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
  RUN adapters/neogrid/utp/aneut130b.w (INPUT-OUTPUT c-string, INPUT-OUTPUT l-first, INPUT-OUTPUT l-resultlist, OUTPUT pi-ini, OUTPUT pi-fim, OUTPUT pd-ini, OUTPUT pd-fim, OUTPUT ph-ini, OUTPUT ph-fim, OUTPUT pt-in, OUTPUT pt-out).

  ASSIGN c-string = "*" + trim(c-string) + "*".

  IF  l-first  THEN DO:
      FOR EACH b-ngmessagequeue NO-LOCK WHERE b-ngmessagequeue.xmlmessage MATCHES c-string 
                                          AND b-ngmessagequeue.ngmessagequeueid  >= pi-ini 
                                          AND b-ngmessagequeue.ngmessagequeueid  <= pi-fim 
                                          AND b-ngmessagequeue.GenerationDate    >= pd-ini 
                                          AND b-ngmessagequeue.GenerationDate    <= pd-fim 
                                          AND b-ngmessagequeue.GenerationTime    >= (INTEGER(SUBSTR(ph-ini,1,2)) * 3600) + (INTEGER(SUBSTR(ph-ini,3,2)) * 60) + (INTEGER(SUBSTR(ph-ini,5,2)))
                                          AND b-ngmessagequeue.GenerationTime    <= (INTEGER(SUBSTR(ph-fim,1,2)) * 3600) + (INTEGER(SUBSTR(ph-fim,3,2)) * 60) + (INTEGER(SUBSTR(ph-fim,5,2)))
                                          AND ((b-ngmessagequeue.NGMessageQueueName = (IF  pt-in  = YES THEN "IN"  ELSE ""))
                                           OR  (b-ngmessagequeue.NGMessageQueueName = (IF  pt-out = YES THEN "OUT" ELSE "")))
         BY b-ngmessagequeue.ngmessagequeueid DESC.
         BROWSE br-messagequeue:DESELECT-ROWS().
         MESSAGE "First message:" b-ngmessagequeue.ngmessagequeueid VIEW-AS ALERT-BOX INFO BUTTONS OK.
         REPOSITION  br-messagequeue TO ROWID(rowid(b-ngmessagequeue)).
         br-messagequeue:SELECT-FOCUSED-ROW ( ).
         APPLY "VALUE-CHANGED" TO BROWSE br-messagequeue.
         APPLY "entry" TO c-xmlmessage.
         c-xmlmessage:SEARCH(c-string,1).
         LEAVE.
      END.
  END.
  IF l-resultlist THEN DO:
      RUN adapters/neogrid/utp/aneut130c.w (INPUT-OUTPUT c-string, OUTPUT r-rowid, INPUT pi-ini, INPUT pi-fim, INPUT pd-ini, INPUT pd-fim, INPUT ph-ini, INPUT ph-fim, INPUT pt-in, INPUT pt-out).
      IF r-rowid <> ?  THEN DO: 
          BROWSE br-messagequeue:DESELECT-ROWS(). 
          REPOSITION  br-messagequeue TO ROWID(r-rowid).
          br-messagequeue:SELECT-FOCUSED-ROW ( ).
          APPLY "VALUE-CHANGED" TO BROWSE br-messagequeue.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-visualizaxml C-Win
ON L OF bt-visualizaxml IN FRAME f-princ /* View */
OR l OF bt-visualizaxml IN FRAME f-princ
DO:
    ASSIGN c-messages = IF c-messages = "LOG" THEN "IN,OUT" ELSE "LOG".
    {&OPEN-QUERY-br-messagequeue}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-XMLMessage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-XMLMessage C-Win
ON CTRL-F OF c-XMLMessage IN FRAME f-princ
DO:
  RUN adapters/neogrid/utp/aneut130a.w (INPUT-OUTPUT c-string).
  IF NOT c-xmlmessage:SEARCH(c-string,1) THEN DO:
      MESSAGE "Text not Found!":U
          VIEW-AS ALERT-BOX warning  BUTTONS OK.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-XMLMessage C-Win
ON F9 OF c-XMLMessage IN FRAME f-princ
DO:
    IF NOT c-xmlmessage:SEARCH(c-string,1) THEN DO:
      MESSAGE "Text not Found!":U
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
          APPLY "VALUE-CHANGED" TO BROWSE br-messagequeue.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-XMLMessage C-Win
ON SHIFT-F9 OF c-XMLMessage IN FRAME f-princ
DO:
    IF NOT c-xmlmessage:SEARCH(c-string,2) THEN DO:
       MESSAGE "Text not Found!":U
           VIEW-AS ALERT-BOX warning  BUTTONS OK.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Deselecione_Todas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Deselecione_Todas C-Win
ON CHOOSE OF MENU-ITEM m_Deselecione_Todas /* Deselect All */
DO:
  BROWSE br-messagequeue:DESELECT-ROWS().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Selecione_Todas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Selecione_Todas C-Win
ON CHOOSE OF MENU-ITEM m_Selecione_Todas /* Select All */
DO:
 BROWSE  br-messagequeue:SELECT-ALL() .
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
  ASSIGN i-last-height = c-win:HEIGHT.
   APPLY "VALUE-CHANGED" TO BROWSE br-messagequeue.
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
  ENABLE br-messagequeue c-XMLMessage bt-fechar bt-atualiza bt-delete 
         bt-deleteproc bt-deletenproc bt-exporta bt-reprocessa bt-visualizaxml 
         bt-processMapping bt-Search RECT-1 
      WITH FRAME f-princ IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-princ}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnfrom C-Win 
FUNCTION fnfrom RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF NGMessageQueue.NGMessageQueueName = "OUT" 
      THEN ASSIGN c-from = IF NGMessageQueue.log-1 THEN "CRM" ELSE "B2B". 
      ELSE ASSIGN c-from = "".

  RETURN c-from.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

