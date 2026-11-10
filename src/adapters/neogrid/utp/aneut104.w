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
DEF VAR r-rowid AS ROWID.
DEFINE VAR delay    AS INT INIT 5.
define buffer b-NGMessageQueue for NGMessageQueue.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHAR NO-UNDO.
DEFINE VARIABLE l-processando AS LOGICAL INITIAL YES.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define LAYOUT-VARIABLE C-Win-layout

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-princ
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NGMessageQueue

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 NGMessageQueue.DateTime ~
NGMessageQueue.NGMessageQueueID NGMessageQueue.NGMessageQueueSequence ~
NGMessageQueue.NGMessageQueueName NGMessageQueue.Done 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH NGMessageQueue NO-LOCK ~
    BY NGMessageQueue.NGMessageQueueID DESCENDING ~
       BY NGMessageQueue.NGMessageQueueSequence DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 NGMessageQueue
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 NGMessageQueue


/* Definitions for FRAME f-princ                                        */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-princ ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-1 bt-fechar bt-atualiza bt-delete ~
bt-deleteproc bt-deletenproc bt-reprocessa bt-exporta bt-delay RECT-1   bt-processMapping bt-visualizaxml


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* Define a variable to store the name of the active layout.            */
DEFINE VAR C-Win-layout AS CHAR INITIAL "Master Layout":U NO-UNDO.

/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-atualiza 
     LABEL "Atualiza (F5)" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 13 BY 1
     &ELSE SIZE 13.5 BY 1.17 &ENDIF.

DEFINE BUTTON bt-delete 
     LABEL "Elimina" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
     &ELSE SIZE 8.5 BY 1.17 &ENDIF.

DEFINE BUTTON bt-deletenproc 
     LABEL "Elimina N∆o Processadas" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 26 BY 1
     &ELSE SIZE 26 BY 1.17 &ENDIF.

DEFINE BUTTON bt-deleteproc 
     LABEL "Elimina Processadas" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 22 BY 1
     &ELSE SIZE 21.72 BY 1.17 &ENDIF.

DEFINE BUTTON bt-fechar 
     LABEL "Fechar" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8.29 BY 1.17 &ENDIF.

DEFINE BUTTON bt-reprocessa 
     LABEL "Reprocessa" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 12 BY 1
     &ELSE SIZE 12.5 BY 1.17 &ENDIF.

DEFINE BUTTON bt-exporta 
     LABEL "Exporta" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
     &ELSE SIZE 9 BY 1.17 &ENDIF.

DEFINE BUTTON bt-delay
     LABEL "Delay" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
     &ELSE SIZE 8.5 BY 1.17 &ENDIF.

DEFINE BUTTON bt-processMapping
         LABEL "Msg X Adapter" 
         &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 22 BY 1
         &ELSE SIZE  21.72 BY 1.17 &ENDIF.

    DEFINE BUTTON bt-visualizaxml
             LABEL "Visualiza" 
             &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
             &ELSE SIZE  11.72 BY 1.17 &ENDIF.


DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 93 BY 4
     &ELSE SIZE 93 BY 3.5 &ENDIF
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
      NGMessageQueue.DateTime FORMAT "X(20)":U WIDTH 19 LABEL "Data" 
      string(NGMessageQueue.NGMessageQueueID,"z,zzz,zz9") + "/" + string(NGMessageQueue.NGMessageQueueSequence,"999") FORMAT "x(13)":U WIDTH 13 LABEL "Identificaá∆o"
      NGMessageQueue.NGMessageQueueName FORMAT "X(3)":U LABEL "Sentido" WIDTH 7
      NGMessageQueue.Done FORMAT "Sim/N∆o":U LABEL "Processada" WIDTH 10
      substr(NGMessageQueue.XMLMessage,0001,90) FORMAT "x(90)" LABEL "Mensagem" 
      substr(NGMessageQueue.XMLMessage,0091,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,0181,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,0271,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,0361,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,0451,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,0531,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,0621,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,0711,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,0801,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,0891,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,0981,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,1071,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,1161,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,1251,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,1331,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,1421,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,1511,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,1601,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,1691,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,1781,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,1871,90) FORMAT "x(90)" no-label
      substr(NGMessageQueue.XMLMessage,1961,90) FORMAT "x(90)" no-label
      /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS FONT 2 SEPARATORS SIZE 94 BY 10 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-princ
     BROWSE-1
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 2
          &ELSE AT ROW 1.13 COL 2 &ENDIF
     bt-fechar
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 3
          &ELSE AT ROW 12 COL 3 &ENDIF
     bt-atualiza
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 12
          &ELSE AT ROW 12 COL 12 &ENDIF
     bt-delete
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 26
          &ELSE AT ROW 12 COL 26.5 &ENDIF
     bt-deleteproc
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 36
          &ELSE AT ROW 12 COL 36 &ENDIF
     bt-deletenproc
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 59
          &ELSE AT ROW 12 COL 59 &ENDIF
     bt-reprocessa
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 3
          &ELSE AT ROW 13.25 COL 3 &ENDIF
     bt-exporta
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 16
          &ELSE AT ROW 13.25 COL 16.5 &ENDIF
     bt-delay
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 36
          &ELSE AT ROW 13.25 COL 26.5 &ENDIF
     bt-processMapping
         &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 36
         &ELSE AT ROW 13.25 COL 36 &ENDIF
    bt-visualizaxml
        &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 36
        &ELSE AT ROW 13.25 COL 59 &ENDIF
         
     RECT-1
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 2
          &ELSE AT ROW 11.63 COL 2 &ENDIF
    WITH 1 DOWN 
         NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE.

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
IF SESSION:DISPLAY-TYPE = "GUI":U THEN DO:
  FIND FIRST param-global NO-LOCK NO-ERROR.
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Visualizador de Mensagens - ANEUT104.W - " + IF  AVAIL param-global THEN trim(param-global.grupo) ELSE "Datasul S.A."
         HEIGHT             = 14.30
         WIDTH              = 95.50
         MAX-HEIGHT         = 14.30
         MAX-WIDTH          = 95.50
         VIRTUAL-HEIGHT     = 14.30
         VIRTUAL-WIDTH      = 320
         RESIZE             = NO
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
END.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-princ
   Size-to-Fit                                                          */
/* BROWSE-TAB BROWSE-1 1 f-princ */
ASSIGN 
       FRAME f-princ:SCROLLABLE       = FALSE
       FRAME f-princ:RESIZABLE        = TRUE.

/* SETTINGS FOR BUTTON bt-exporta IN FRAME f-princ
   NO-ENABLE                                                            */

/* _MULTI-LAYOUT-RUN-TIME-ADJUSTMENTS */

/* LAYOUT-NAME: "Standard Character"
   LAYOUT-TYPE: CHARACTER
   EXPRESSION:  SESSION:DISPLAY-TYPE = 'TTY':U 
   COMMENT:     This layout is the standard layout specification for
                 a customized Character based terminal.  It is usually
                 selected to modify a window that has a GUI based
                 master layout.
                                                                        */
IF SESSION:DISPLAY-TYPE = 'TTY':U  THEN 
  RUN C-Win-layouts (INPUT 'Standard Character':U) NO-ERROR.

/* LAYOUT-NAME: "Standard MS Windows"
   LAYOUT-TYPE: GUI
   EXPRESSION:  SESSION:WINDOW-SYSTEM = 'MS-WINDOWS':U 
   COMMENT:     This layout is the standard layout specification for
                 a customized MS Windows window.  It is usually
                 selected to modify a window that needs to have a
                 standard "MS Windows" look.
                                                                        */
ELSE IF SESSION:WINDOW-SYSTEM = 'MS-WINDOWS':U  THEN 
  RUN C-Win-layouts (INPUT 'Standard MS Windows':U) NO-ERROR.

/* LAYOUT-NAME: "Standard Windows 95"
   LAYOUT-TYPE: GUI
   EXPRESSION:  SESSION:WINDOW-SYSTEM = 'MS-WIN95':U
   COMMENT:     This layout is the standard layout specification for
                 a customized Windows 95 window.  It is usually
                 selected to modify a window that needs to have a
                 standard "Windows 95" look.
                                                                        */
ELSE IF SESSION:WINDOW-SYSTEM = 'MS-WIN95':U THEN 
  RUN C-Win-layouts (INPUT 'Standard Windows 95':U) NO-ERROR.

/* END-OF-LAYOUT-DEFINITIONS */

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "neogrid.NGMessageQueue"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "neogrid.NGMessageQueue.NGMessageQueueID|no,neogrid.NGMessageQueue.NGMessageQueueSequence|no"
     _FldNameList[1]   > neogrid.NGMessageQueue.DateTime
"NGMessageQueue.DateTime" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" ""
     _FldNameList[2]   = neogrid.NGMessageQueue.NGMessageQueueID
     _FldNameList[3]   > neogrid.NGMessageQueue.NGMessageQueueSequence
"NGMessageQueue.NGMessageQueueSequence" ? ? "integer" ? ? ? ? ? ? no ? no no "26.72" yes no no "U" "" ""
     _FldNameList[4]   = neogrid.NGMessageQueue.NGMessageQueueName
     _FldNameList[5]   > neogrid.NGMessageQueue.Done
"NGMessageQueue.Done" ? ? "logical" ? ? ? ? ? ? no ? no no "6.86" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* NGMessageQueue Viewer */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* NGMessageQueue Viewer */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-atualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualiza C-Win
ON CHOOSE OF bt-atualiza IN FRAME f-princ /* Atualiza (F5) */
DO:
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-delete C-Win
ON CHOOSE OF bt-delete IN FRAME f-princ /* Elimina */
DO:
    IF  AVAIL NGMessageQueue THEN DO:
        MESSAGE "Confirma a exclus∆o do registro?" VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO TITLE "Exclus∆o de mensagens" UPDATE l-resp.
        IF  l-resp THEN DO:
            FOR EACH b-ngmessagequeue EXCLUSIVE-LOCK
                WHERE b-ngmessagequeue.ngmessagequeueid = ngmessagequeue.ngmessagequeueid:
                DELETE b-ngmessagequeue.
            END.
            {&OPEN-QUERY-{&BROWSE-NAME}}
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-deletenproc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-deletenproc C-Win
ON CHOOSE OF bt-deletenproc IN FRAME f-princ /* Elimina N∆o Processadas */
DO:
    IF  CAN-FIND(FIRST NGMessageQueue) THEN DO:
        MESSAGE "Confirma a exclus∆o de todos os registros n∆o processados?" VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO TITLE "Exclus∆o de mensagens" UPDATE l-resp.
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
ON CHOOSE OF bt-deleteproc IN FRAME f-princ /* Elimina Processadas */
DO:
    IF  CAN-FIND(FIRST NGMessageQueue) THEN DO:
        MESSAGE "Confirma a exclus∆o de todos os registros processados?" VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO TITLE "Exclus∆o de mensagens" UPDATE l-resp.
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


&Scoped-define SELF-NAME bt-fechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fechar C-Win
ON CHOOSE OF bt-fechar IN FRAME f-princ /* Fechar */
DO: 
    IF INDEX(PROGRAM-NAME(3),'men903za') <> ? 
        THEN APPLY "close" TO THIS-PROCEDURE.
        ELSE QUIT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-reprocessa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-reprocessa C-Win
ON CHOOSE OF bt-reprocessa IN FRAME f-princ 
DO:
    IF  AVAIL ngmessagequeue THEN DO TRANSACTION:
        FOR EACH b-ngmessagequeue EXCLUSIVE-LOCK
            WHERE b-ngmessagequeue.ngmessagequeueid = ngmessagequeue.ngmessagequeueid:
            ASSIGN b-ngmessagequeue.done = NO.
        END.
    END.
END.
  
&Scoped-define SELF-NAME bt-exporta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exporta C-Win
ON CHOOSE OF bt-exporta IN FRAME f-princ 
DO:
  IF  AVAIL ngmessagequeue THEN DO:
      DEF VAR arq-xml AS CHAR INIT "neogrid.xml".
      MESSAGE "Nome do Arquivo:" UPDATE arq-xml FORMAT "x(60)".
      OUTPUT TO VALUE(arq-xml) CONVERT TARGET "iso8859-1".
      FOR EACH b-ngmessagequeue EXCLUSIVE-LOCK
          WHERE b-ngmessagequeue.ngmessagequeueid = ngmessagequeue.ngmessagequeueid:
          PUT b-ngmessagequeue.xmlmessage.
      END.
      OUTPUT CLOSE.
  END.
END.

&Scoped-define SELF-NAME 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win
ON CTRL-E OF browse-1 IN FRAME f-princ 
DO:
    DEF VAR c-texto AS CHAR VIEW-AS EDITOR SIZE 95.5 BY 14.3.
    ASSIGN c-texto = "".
    FIND FIRST b-ngmessagequeue EXCLUSIVE-LOCK
        WHERE b-ngmessagequeue.ngmessagequeueid       = ngmessagequeue.ngmessagequeueid
          AND b-ngmessagequeue.ngmessagequeuesequence = ngmessagequeue.ngmessagequeuesequence NO-ERROR.
    IF  AVAIL b-ngmessagequeue THEN DO:
        ASSIGN c-texto = REPLACE(b-ngmessagequeue.xmlmessage,"><",">" + CHR(10) + "<").
        ASSIGN c-texto = REPLACE(c-texto,"/>","/>" + CHR(10)).
        UPDATE c-texto WITH NO-BOX NO-LABEL OVERLAY WIDTH 132 THREE-D FONT 2 FRAME f-editar.
        ASSIGN b-ngmessagequeue.xmlmessage = REPLACE(c-texto,CHR(10),""). 
        HIDE FRAME f-editar NO-PAUSE.
    END.
END.

&Scoped-define SELF-NAME bt-delay
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-delay C-Win
ON CHOOSE OF bt-delay IN FRAME f-princ 
DO:
    MESSAGE "Delay" UPDATE delay FORMAT ">>>9".
    IF  delay = 0 THEN
        delay = 5.
END.

&Scoped-define SELF-NAME bt-delay
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-delay C-Win
ON CHOOSE OF bt-processmapping IN FRAME f-princ 
DO: 
    RUN adapters\neogrid\utp\aneut105.w.
END.


&Scoped-define SELF-NAME bt-visualizaxml
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-delay C-Win
ON CHOOSE OF bt-visualizaxml IN FRAME f-princ 
DO: 
OUTPUT TO  VALUE (SESSION:TEMP-DIRECTORY + "tmp.xml") CONVERT TARGET "iso8859-1".
FOR EACH b-ngmessagequeue EXCLUSIVE-LOCK
      WHERE b-ngmessagequeue.ngmessagequeueid = ngmessagequeue.ngmessagequeueid:
        PUT b-ngmessagequeue.xmlmessage.
END.
OUTPUT CLOSE.    
DOS SILENT explorer VALUE(SESSION:TEMP-DIRECTORY + "tmp.xml").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
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

on "F5" anywhere do:
    apply "choose" to bt-atualiza in frame f-princ.
end.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.
    apply "value-changed" to {&browse-name} in frame f-princ.
    APPLY "choose" TO bt-atualiza.
    WAIT-FOR CLOSE OF THIS-PROCEDURE /* OR CHOOSE OF bt-fechar*/ .
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
  ENABLE BROWSE-1 bt-fechar bt-atualiza bt-delete bt-deleteproc bt-deletenproc 
         bt-reprocessa bt-exporta bt-delay  bt-processmapping RECT-1 bt-visualizaxml
      WITH FRAME f-princ IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-princ}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK  _PROCEDURE C-Win-layouts _LAYOUT-CASES
PROCEDURE C-Win-layouts:
  DEFINE INPUT PARAMETER layout AS CHARACTER                     NO-UNDO.
  DEFINE VARIABLE lbl-hndl AS WIDGET-HANDLE                      NO-UNDO.
  DEFINE VARIABLE widg-pos AS DECIMAL                            NO-UNDO.

  C-Win-layout = layout.

  CASE layout:
    WHEN "Master Layout" THEN DO:
      ASSIGN
         &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
         C-Win:HIDDEN                                      = yes &ENDIF
         &IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
         C-Win:HEIGHT                                      = 14.92 &ENDIF
         &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
         C-Win:WIDTH                                       = 95.72 &ENDIF.

      ASSIGN
         BROWSE-1:HIDDEN IN FRAME f-princ                  = yes
         BROWSE-1:ROW IN FRAME f-princ                     = 1.21
         BROWSE-1:HIDDEN IN FRAME f-princ                  = no.

      ASSIGN
         bt-atualiza:HIDDEN IN FRAME f-princ               = yes
         bt-atualiza:HEIGHT IN FRAME f-princ               = 1.17
         bt-atualiza:ROW IN FRAME f-princ                  = 12.08
         bt-atualiza:WIDTH IN FRAME f-princ                = 13.43
         bt-atualiza:HIDDEN IN FRAME f-princ               = no.

      ASSIGN
         bt-delete:HIDDEN IN FRAME f-princ                 = yes
         bt-delete:HEIGHT IN FRAME f-princ                 = 1.17
         bt-delete:ROW IN FRAME f-princ                    = 12.08
         bt-delete:HIDDEN IN FRAME f-princ                 = no.

      ASSIGN
         bt-deletenproc:HIDDEN IN FRAME f-princ            = yes
         bt-deletenproc:HEIGHT IN FRAME f-princ            = 1.17
         bt-deletenproc:ROW IN FRAME f-princ               = 12.08
         bt-deletenproc:HIDDEN IN FRAME f-princ            = no.

      ASSIGN
         bt-deleteproc:HIDDEN IN FRAME f-princ             = yes
         bt-deleteproc:HEIGHT IN FRAME f-princ             = 1.17
         bt-deleteproc:ROW IN FRAME f-princ                = 12.08
         bt-deleteproc:WIDTH IN FRAME f-princ              = 21.72
         bt-deleteproc:HIDDEN IN FRAME f-princ             = no.

      ASSIGN
         bt-fechar:HIDDEN IN FRAME f-princ                 = yes
         bt-fechar:HEIGHT IN FRAME f-princ                 = 1.17
         bt-fechar:ROW IN FRAME f-princ                    = 12.08
         bt-fechar:WIDTH IN FRAME f-princ                  = 8.29
         bt-fechar:HIDDEN IN FRAME f-princ                 = no.

      ASSIGN
         bt-delay:HIDDEN IN FRAME f-princ                  = yes
         bt-delay:HEIGHT IN FRAME f-princ                  = 1
         bt-delay:ROW IN FRAME f-princ                     = 13.25
         bt-delay:WIDTH IN FRAME f-princ                   = 24
         bt-delay:HIDDEN IN FRAME f-princ                  = no.
      
      ASSIGN
         RECT-1:EDGE-PIXELS IN FRAME f-princ               = 1
         RECT-1:HIDDEN IN FRAME f-princ                    = yes
         RECT-1:HEIGHT IN FRAME f-princ                    = 3.5
         RECT-1:ROW IN FRAME f-princ                       = 11.71
         RECT-1:HIDDEN IN FRAME f-princ                    = no.

      ASSIGN
         &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
         C-Win:HIDDEN                                      = no &ENDIF.

    END.  /* Master Layout Layout Case */

    WHEN "Standard Character":U THEN DO:
      ASSIGN
         BROWSE-1:HIDDEN IN FRAME f-princ                  = yes
         BROWSE-1:ROW IN FRAME f-princ                     = 1
         BROWSE-1:HIDDEN IN FRAME f-princ                  = no NO-ERROR.

      ASSIGN
         bt-atualiza:HIDDEN IN FRAME f-princ               = yes
         bt-atualiza:HEIGHT IN FRAME f-princ               = 1
         bt-atualiza:ROW IN FRAME f-princ                  = 12
         bt-atualiza:WIDTH IN FRAME f-princ                = 13
         bt-atualiza:HIDDEN IN FRAME f-princ               = no NO-ERROR.

      ASSIGN
         bt-delete:HIDDEN IN FRAME f-princ                 = yes
         bt-delete:HEIGHT IN FRAME f-princ                 = 1
         bt-delete:ROW IN FRAME f-princ                    = 12
         bt-delete:HIDDEN IN FRAME f-princ                 = no NO-ERROR.

      ASSIGN
         bt-deletenproc:HIDDEN IN FRAME f-princ            = yes
         bt-deletenproc:HEIGHT IN FRAME f-princ            = 1
         bt-deletenproc:ROW IN FRAME f-princ               = 12
         bt-deletenproc:HIDDEN IN FRAME f-princ            = no NO-ERROR.

      ASSIGN
         bt-deleteproc:HIDDEN IN FRAME f-princ             = yes
         bt-deleteproc:HEIGHT IN FRAME f-princ             = 1
         bt-deleteproc:ROW IN FRAME f-princ                = 12
         bt-deleteproc:WIDTH IN FRAME f-princ              = 22
         bt-deleteproc:HIDDEN IN FRAME f-princ             = no NO-ERROR.

      ASSIGN
         bt-fechar:HIDDEN IN FRAME f-princ                 = yes
         bt-fechar:HEIGHT IN FRAME f-princ                 = 1
         bt-fechar:ROW IN FRAME f-princ                    = 12
         bt-fechar:WIDTH IN FRAME f-princ                  = 8
         bt-fechar:HIDDEN IN FRAME f-princ                 = no NO-ERROR.

      ASSIGN
         bt-delay:HIDDEN IN FRAME f-princ                  = yes
         bt-delay:HEIGHT IN FRAME f-princ                  = 1
         bt-delay:ROW IN FRAME f-princ                     = 13.25
         bt-delay:WIDTH IN FRAME f-princ                   = 24
         bt-delay:HIDDEN IN FRAME f-princ                  = no.
      
      ASSIGN
         RECT-1:EDGE-PIXELS IN FRAME f-princ               = 2
         RECT-1:HIDDEN IN FRAME f-princ                    = yes
         RECT-1:HEIGHT IN FRAME f-princ                    = 4
         RECT-1:ROW IN FRAME f-princ                       = 12
         RECT-1:HIDDEN IN FRAME f-princ                    = no NO-ERROR.

    END.  /* Standard Character Layout Case */

    WHEN "Standard MS Windows":U THEN DO:
      ASSIGN
         BROWSE-1:HIDDEN IN FRAME f-princ                  = yes
         BROWSE-1:ROW IN FRAME f-princ                     = 1.13
         BROWSE-1:HIDDEN IN FRAME f-princ                  = no.

      ASSIGN
         bt-atualiza:HIDDEN IN FRAME f-princ               = yes
         bt-atualiza:ROW IN FRAME f-princ                  = 11.75
         bt-atualiza:HIDDEN IN FRAME f-princ               = no.

      ASSIGN
         bt-delete:HIDDEN IN FRAME f-princ                 = yes
         bt-delete:ROW IN FRAME f-princ                    = 11.75
         bt-delete:HIDDEN IN FRAME f-princ                 = no.

      ASSIGN
         bt-deletenproc:HIDDEN IN FRAME f-princ            = yes
         bt-deletenproc:ROW IN FRAME f-princ               = 11.75
         bt-deletenproc:HIDDEN IN FRAME f-princ            = no.

      ASSIGN
         bt-deleteproc:HIDDEN IN FRAME f-princ             = yes
         bt-deleteproc:ROW IN FRAME f-princ                = 11.75
         bt-deleteproc:HIDDEN IN FRAME f-princ             = no.

      ASSIGN
         bt-fechar:HIDDEN IN FRAME f-princ                 = yes
         bt-fechar:ROW IN FRAME f-princ                    = 11.75
         bt-fechar:HIDDEN IN FRAME f-princ                 = no.

      ASSIGN
         bt-delay:HIDDEN IN FRAME f-princ                  = yes
         bt-delay:ROW IN FRAME f-princ                     = 13.25
         bt-delay:HIDDEN IN FRAME f-princ                  = no.
      
      ASSIGN
         RECT-1:EDGE-PIXELS IN FRAME f-princ               = 2
         RECT-1:HIDDEN IN FRAME f-princ                    = yes
         RECT-1:ROW IN FRAME f-princ                       = 11.28
         RECT-1:HIDDEN IN FRAME f-princ                    = no.

    END.  /* Standard MS Windows Layout Case */

    WHEN "Standard Windows 95":U THEN DO:
      ASSIGN
         BROWSE-1:HIDDEN IN FRAME f-princ                  = yes
         BROWSE-1:ROW IN FRAME f-princ                     = 1.13
         BROWSE-1:HIDDEN IN FRAME f-princ                  = no.

      ASSIGN
         bt-atualiza:HIDDEN IN FRAME f-princ               = yes
         bt-atualiza:ROW IN FRAME f-princ                  = 11.75
         bt-atualiza:HIDDEN IN FRAME f-princ               = no.

      ASSIGN
         bt-delete:HIDDEN IN FRAME f-princ                 = yes
         bt-delete:ROW IN FRAME f-princ                    = 11.75
         bt-delete:HIDDEN IN FRAME f-princ                 = no.

      ASSIGN
         bt-deletenproc:HIDDEN IN FRAME f-princ            = yes
         bt-deletenproc:ROW IN FRAME f-princ               = 11.75
         bt-deletenproc:HIDDEN IN FRAME f-princ            = no.

      ASSIGN
         bt-deleteproc:HIDDEN IN FRAME f-princ             = yes
         bt-deleteproc:ROW IN FRAME f-princ                = 11.75
         bt-deleteproc:HIDDEN IN FRAME f-princ             = no.

      ASSIGN
         bt-fechar:HIDDEN IN FRAME f-princ                 = yes
         bt-fechar:ROW IN FRAME f-princ                    = 11.75
         bt-fechar:HIDDEN IN FRAME f-princ                 = no.

      ASSIGN
         bt-delay:HIDDEN IN FRAME f-princ                  = yes
         bt-delay:ROW IN FRAME f-princ                     = 13.25
         bt-delay:HIDDEN IN FRAME f-princ                  = no.
      
      ASSIGN
         RECT-1:EDGE-PIXELS IN FRAME f-princ               = 2
         RECT-1:HIDDEN IN FRAME f-princ                    = yes
         RECT-1:ROW IN FRAME f-princ                       = 11.3
         RECT-1:HIDDEN IN FRAME f-princ                    = no.

    END.  /* Standard Windows 95 Layout Case */

  END CASE.
END PROCEDURE.  /* C-Win-layouts */
&ANALYZE-RESUME
