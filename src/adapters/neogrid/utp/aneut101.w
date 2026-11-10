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

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
{include/i_framevers.i}

&IF "{&FRAME_VERSION}" = "1" &THEN /* Novo Frame */
    {include/i_prdvers.i}
&ENDIF

/* Local Variable Definitions ---                                       */
define variable l-resp as logical format "Yes/No" initial no no-undo.
define buffer b-NGMessageQueue for NGMessageQueue.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHAR NO-UNDO.
DEF VAR i-aux                           AS INT.
DEF VAR l-erro                          AS LOG INIT NO.
DEF VAR l-log                           AS CHAR INIT "IN,OUT".
DEF VAR i-tt                            AS INT.
DEF VAR i-cont                          AS INT.
DEF NEW GLOBAL SHARED VAR c-id          LIKE mgadm._user._userid   LABEL "User" INIT ?.
DEF NEW GLOBAL SHARED VAR c-senha       LIKE mgadm._user._password LABEL "Password"   INIT "".
DEF BUTTON bt-ok      LABEL "Close"        SIZE 9 by 2.3 AUTO-GO.
DEF BUTTON bt-cancela LABEL "Cancel"   SIZE 9 by 2.3 AUTO-ENDKEY.
DEFINE VARIABLE l-processando AS LOGICAL INITIAL YES.
DEF VAR i-delay             AS INT FORMAT ">>>>9" INIT 5.
DEF VAR i-maxrows           AS INT FORMAT ">>>>9" INIT 20.
DEF VAR i-max-msg           AS INT FORMAT ">>>>9" INIT 5.
DEF VAR v-start-aut         AS LOG INIT NO.
DEF VAR dt-inicial AS DATE FORMAT "99/99/9999".

&IF "{&FRAME_VERSION}" = "1" &THEN /* Novo Frame */
    DEFINE VARIABLE cCodUsuario AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cSenhaUsuario AS CHARACTER NO-UNDO.
    
    &IF "{&product_version}" >= "12.1.13" &THEN
    DEFINE NEW GLOBAL SHARED VARIABLE oSessionParams AS CLASS   com.totvs.framework.utp.SessionParams NO-UNDO.
    ASSIGN 
        cCodUsuario   = oSessionParams:codUsuar
        cSenhaUsuario = oSessionParams:userPassword.
    &ELSE
    ASSIGN 
        cCodUsuario   = ENTRY(4,SESSION:PARAMETER)
        cSenhaUsuario = ENTRY(5,SESSION:PARAMETER) NO-ERROR.    
    &ENDIF
&ENDIF

DEF FRAME fr-usuario skip(1)
    c-id            COLON 10 HELP "User Name"  VIEW-AS FILL-IN SIZE 13 BY 1.3 BGCOLOR 15 FONT 0 SKIP(.8)
    c-senha   BLANK COLON 10 HELP "Password" VIEW-AS FILL-IN SIZE 13 BY 1.3 BGCOLOR 15 FONT 0 SPACE(2) SKIP(.8)
    bt-ok           COLON 5
    bt-cancela      COLON 20 space(5) skip(.5)
    WITH THREE-D CENTERED ROW 3 SIDE-LABELS TITLE "User" VIEW-AS DIALOG-BOX BGCOLOR 8.

ON  CHOOSE of bt-cancela IN FRAME fr-usuario DO:
    QUIT.
END.

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
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 NGMessageQueue.DateTime NGMessageQueue.NGMessageQueueID NGMessageQueue.NGMessageQueueSequence NGMessageQueue.NGMessageQueueName NGMessageQueue.Done 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH NGMessageQueue NO-LOCK WHERE INDEX(l-log,NGMessageQueue.NGMessageQueueName) <> 0 BY NGMessageQueue.NGMessageQueueID DESCENDING BY NGMessageQueue.NGMessageQueueSequence DESCENDING INDEXED-REPOSITION /* MAX-ROWS i-maxrows */.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 NGMessageQueue
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 NGMessageQueue


/* Definitions for FRAME f-princ                                        */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-princ     ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-1 bt-fechar bt-atualiza bt-delete bt-deleteproc bt-deletenproc bt-inicia bt-delay bt-connection RECT-1 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* Define a variable to store the name of the active layout.            */
DEFINE VAR C-Win-layout AS CHAR INITIAL "Master Layout":U NO-UNDO.

/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-atualiza 
     LABEL "&Refresh (F5)" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 14 BY 1.17 &ENDIF.

DEFINE BUTTON bt-delete 
     LABEL "Delete" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
     &ELSE SIZE 10 BY 1.17 &ENDIF.

DEFINE BUTTON bt-deletenproc 
     LABEL "Delete &Not Processed" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 26 BY 1
     &ELSE SIZE 26 BY 1.17 &ENDIF.

DEFINE BUTTON bt-deleteproc 
     LABEL "Delete Processed" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 22 BY 1
     &ELSE SIZE 22 BY 1.17 &ENDIF.

DEFINE BUTTON bt-fechar 
     LABEL "&Close" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 9 BY 1
     &ELSE SIZE 9 BY 1.17 &ENDIF.

DEFINE BUTTON bt-inicia 
     LABEL "&Start" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
     &ELSE SIZE 10 BY 1.17 &ENDIF.

DEFINE BUTTON bt-para 
     LABEL "&Stop" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
     &ELSE SIZE 10 BY 1.17 &ENDIF.

DEFINE BUTTON bt-delay
     LABEL "&Delay" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 8 BY 1.17 &ENDIF.

DEFINE BUTTON bt-connection
     LABEL "&Connection" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
     &ELSE SIZE 13 BY 1.17 &ENDIF.

DEFINE BUTTON bt-ok-delay
     LABEL "&OK" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 5 BY 1
     &ELSE SIZE 5 BY 1.17 &ENDIF.

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
      NGMessageQueue.DateTime FORMAT "X(20)":U WIDTH 19 LABEL "Date" 
      string(NGMessageQueue.NGMessageQueueID,"z,zzz,zz9") + "/" + string(NGMessageQueue.NGMessageQueueSequence,"999") FORMAT "x(13)":U WIDTH 13 LABEL "Id"
      NGMessageQueue.NGMessageQueueName FORMAT "X(3)":U LABEL "Direction" WIDTH 7
      NGMessageQueue.Done FORMAT "Sim/N∆o":U LABEL "Processed" WIDTH 10
      substr(NGMessageQueue.XMLMessage,0001,90) FORMAT "x(90)" LABEL "Message" 
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
    WITH NO-ROW-MARKERS FONT 2 SEPARATORS SIZE 94 BY 10 ROW-HEIGHT-CHARS .90.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-princ
     BROWSE-1
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 2
          &ELSE AT ROW 1.13 COL 2 &ENDIF
     bt-fechar
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 3
          &ELSE AT ROW 12 COL 3 &ENDIF
     bt-atualiza
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 13
          &ELSE AT ROW 12 COL 13 &ENDIF
     bt-delete
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 28
          &ELSE AT ROW 12 COL 28 &ENDIF
     bt-deleteproc
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 39
          &ELSE AT ROW 12 COL 39 &ENDIF
     bt-deletenproc
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 62
          &ELSE AT ROW 12 COL 62 &ENDIF
     bt-inicia
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 3
          &ELSE AT ROW 13.25 COL 3 &ENDIF
     bt-para
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 14
          &ELSE AT ROW 13.25 COL 14 &ENDIF
     bt-delay
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 25
          &ELSE AT ROW 13.25 COL 25 &ENDIF
     i-delay NO-LABEL 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 62
          &ELSE AT ROW 13.25 COL 62 &ENDIF
     bt-ok-delay
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 69
          &ELSE AT ROW 13.25 COL 69 &ENDIF
     bt-connection
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 13 COL 34
          &ELSE AT ROW 13.25 COL 34 &ENDIF
     RECT-1
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 12 COL 2
          &ELSE AT ROW 11.63 COL 2 &ENDIF
    WITH 1 DOWN 
         NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE.

IF  CONNECTED("MGUNI") THEN 
    ASSIGN BROWSE-1:ROW-HEIGHT-CHARS IN FRAME F-PRINC = .60.
i-delay:VISIBLE = FALSE.
bt-ok-delay:VISIBLE = FALSE.

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN DO:
  FIND FIRST param-global NO-LOCK NO-ERROR.
  FIND empresa WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK NO-ERROR.
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Message Processor - ANEUT101.W - " + 
                               (IF  AVAIL param-global 
                                    THEN IF trim(param-global.grupo) <> "Datasul S.A."
                                            THEN param-global.grupo
                                            ELSE empresa.razao
                                    ELSE "Datasul S.A.")
         HEIGHT             = 14.30
         WIDTH              = 95.50
         MAX-HEIGHT         = 14.30
         MAX-WIDTH          = 95.50
         VIRTUAL-HEIGHT     = 14.30
         VIRTUAL-WIDTH      = 95.50 
         RESIZE             = NO
         SCROLL-BARS        = no
         STATUS-AREA        = YES
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = NO
         SENSITIVE          = yes.
END.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES

ASSIGN FRAME f-princ:SCROLLABLE       = FALSE
       FRAME f-princ:RESIZABLE        = TRUE.

IF SESSION:DISPLAY-TYPE = 'TTY':U  THEN 
  RUN C-Win-layouts (INPUT 'Standard Character':U) NO-ERROR.

ELSE IF SESSION:WINDOW-SYSTEM = 'MS-WINDOWS':U  THEN 
  RUN C-Win-layouts (INPUT 'Standard MS Windows':U) NO-ERROR.

ELSE IF SESSION:WINDOW-SYSTEM = 'MS-WIN95':U THEN 
  RUN C-Win-layouts (INPUT 'Standard Windows 95':U) NO-ERROR.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
&ANALYZE-RESUME

/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* NGMessageQueue Viewer */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* NGMessageQueue Viewer */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-atualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualiza C-Win
ON CHOOSE OF bt-atualiza IN FRAME f-princ /* Atualiza (F5) */
DO:
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-delete C-Win
ON CHOOSE OF bt-delete IN FRAME f-princ /* Elimina */
DO:
    IF  AVAIL NGMessageQueue THEN DO:
        MESSAGE "Confirm the delection of the record?" VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO TITLE "Message Exclusion" UPDATE l-resp.
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
        ASSIGN dt-inicial = TODAY - 30.
        MESSAGE "Initial Date?" UPDATE dt-inicial.
        MESSAGE "Confirm the delection of all records not processed?" VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO TITLE "Message Exclusion" UPDATE l-resp.
        IF  l-resp THEN DO:
            FOR EACH NGMessageQueue EXCLUSIVE-LOCK
                WHERE NGMessageQueue.Done = FALSE
                  AND DATE(integer(SUBSTRING(ngmessagequeue.datetime,4,2)),integer(SUBSTRING(ngmessagequeue.datetime,1,2)),integer(SUBSTRING(ngmessagequeue.datetime,7,4))) <= dt-inicial:
                DELETE NGMessageQueue.
            END.  
            CREATE NGMessageQueue.
            ASSIGN NGMessageQueue.NGMessageQueueName     = "LOG"
                    NGMessageQueue.NGMessageQueueID       = NEXT-VALUE(sq_ngmessagequeue)
                    NGMessageQueue.NGMessageQueueSequence = 1
                    NGMessageQueue.DateTime               = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS")
                    NGMessageQueue.XMLMessage             = "Delete: Processadas - " + STRING(dt-inicial)
                    NGMessageQueue.Done                   = TRUE.
            RELEASE NGMessageQueue.
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
        ASSIGN dt-inicial = TODAY - 30.
        MESSAGE "Initial Date?" UPDATE dt-inicial.
        MESSAGE "Confirm the delection of all records processed?" VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO TITLE "Message Exclusion" UPDATE l-resp.
        IF  l-resp THEN DO:
            FOR EACH NGMessageQueue EXCLUSIVE-LOCK
                WHERE NGMessageQueue.Done = TRUE
                  AND DATE(integer(SUBSTRING(ngmessagequeue.datetime,4,2)),integer(SUBSTRING(ngmessagequeue.datetime,1,2)),integer(SUBSTRING(ngmessagequeue.datetime,7,4))) <= dt-inicial:
                DELETE NGMessageQueue.
            END.  
            CREATE NGMessageQueue.
            ASSIGN NGMessageQueue.NGMessageQueueName     = "LOG"
                    NGMessageQueue.NGMessageQueueID       = NEXT-VALUE(sq_ngmessagequeue)
                    NGMessageQueue.NGMessageQueueSequence = 1
                    NGMessageQueue.DateTime               = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS")
                    NGMessageQueue.XMLMessage             = "Delete: Nao Processadas - " + STRING(dt-inicial)
                    NGMessageQueue.Done                   = TRUE.
            RELEASE NGMessageQueue.
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
    quit.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-delay
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-delay C-Win
ON CHOOSE OF bt-delay IN FRAME f-princ /* Fechar */
DO:
    DO  WITH FRAME f-princ:
        i-delay:VISIBLE = TRUE.
        bt-ok-delay:VISIBLE = TRUE.
        bt-connection:VISIBLE = FALSE.
        DISABLE ALL EXCEPT i-delay bt-ok-delay with FRAME f-princ.
        ENABLE i-delay bt-ok-delay.
        DISPLAY i-delay.
    END. 
END.
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-connection
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-connection C-Win
ON CHOOSE OF bt-connection IN FRAME f-princ
DO:
    FIND FIRST ngadapterparms NO-LOCK NO-ERROR.
    IF  AVAIL ngadapterparms THEN DO:
        IF  NUM-ENTRIES(ngadapterparms.queuemanager,",") = 3 
        AND ENTRY(1,ngadapterparms.queuemanager,",") = "MQ" THEN DO:
            MESSAGE "Protocol: "      + ENTRY(1,ngadapterparms.queuemanager,",") SKIP 
                    "Queue Manager: " + ENTRY(2,ngadapterparms.queuemanager,",") SKIP 
                    "Queue Name: "    + ENTRY(3,ngadapterparms.queuemanager,",") VIEW-AS ALERT-BOX INFORMATION TITLE "Data Session" IN WINDOW c-win.
        END.
        ELSE DO:
            IF  NUM-ENTRIES(ngadapterparms.queuemanager,",") >= 3
            AND ENTRY(1,ngadapterparms.queuemanager,",") = "HTTP" THEN DO:
                IF  INTEGER(SUBSTR(PROVERSION,1,R-INDEX(PROVERSION,".") - 1)) >= 9 THEN DO:
                    MESSAGE "Protocol: "       + ENTRY(1,ngadapterparms.queuemanager,",") SKIP 
                            "Host Name: "      + ENTRY(2,ngadapterparms.queuemanager,",") SKIP 
                            "Queue Name: "     + ENTRY(3,ngadapterparms.queuemanager,",") SKIP
                            "Authorization: "  + (IF NUM-ENTRIES(ngadapterparms.queuemanager,",") = 4 THEN ENTRY(4,ngadapterparms.queuemanager,",") ELSE "") SKIP
                            "Max Message: "    + TRIM(STRING(INT(SUBSTR(ngadapterparms.queuename,6,5)),">>>>9")) + " MB" VIEW-AS ALERT-BOX INFORMATION TITLE "Data Session" IN WINDOW c-win.
                END.
                ELSE DO:
                    MESSAGE "Protocol: "       + ENTRY(1,ngadapterparms.queuemanager,",") SKIP 
                            "Host Name: "      + ENTRY(2,ngadapterparms.queuemanager,",") SKIP 
                            "Queue Name: "     + ENTRY(3,ngadapterparms.queuemanager,",") SKIP
                            "Authorization: "  + (IF NUM-ENTRIES(ngadapterparms.queuemanager,",") = 4 THEN ENTRY(4,ngadapterparms.queuemanager,",") ELSE "") SKIP
                            "Max Message: "    + TRIM(STRING(INT(SUBSTR(ngadapterparms.queuename,6,5)),">>>>9")) + " MB" SKIP
                            "Observaá∆o: "     + "O programa UTP~\ANEUT112.P dever† ser executado separadamente com a vers∆o 9.0 ou superior do Progress" VIEW-AS ALERT-BOX INFORMATION TITLE "Data Session" IN WINDOW c-win.
                END.
            END.
            ELSE DO:
                IF  NUM-ENTRIES(ngadapterparms.queuemanager,",") = 4
                AND ENTRY(1,ngadapterparms.queuemanager,",") = "FILE" THEN DO:
                    MESSAGE "Protocol: "        + ENTRY(1,ngadapterparms.queuemanager,",") SKIP 
                            "Directory (IN): "  + ENTRY(2,ngadapterparms.queuemanager,",") SKIP 
                            "Directory (OUT): " + ENTRY(3,ngadapterparms.queuemanager,",") SKIP
                            "Pattern: "         + ENTRY(4,ngadapterparms.queuemanager,",") SKIP VIEW-AS ALERT-BOX INFORMATION TITLE "Data Session" IN WINDOW c-win.
                END.
            END.
        END. 
    END.
    ELSE 
        MESSAGE "No conection Parameter avail" VIEW-AS ALERT-BOX INFORMATION TITLE "Data Session" IN WINDOW c-win.
END.
&ANALYZE-RESUME

&Scoped-define SELF-NAME rect-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-connection C-Win
ON  J OF bt-connection IN FRAME f-princ
OR  j OF bt-connection IN FRAME f-princ
OR  CTRL-ALT-C OF bt-connection IN FRAME f-princ
DO:
    FIND FIRST ngadapterparms EXCLUSIVE-LOCK NO-ERROR.
    IF  NOT AVAIL ngadapterparms THEN DO:
        CREATE ngadapterparms.
        ASSIGN SUBSTR(ngadapterparms.queuename,1,10) = "0000500005".
    END.
    MESSAGE "Conection:" UPDATE ngadapterparms.queuemanager FORMAT "x(70)" IN WINDOW c-win.
END.
&ANALYZE-RESUME

&Scoped-define SELF-NAME rect-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-connection C-Win
ON  L OF bt-connection IN FRAME f-princ
OR  l OF bt-connection IN FRAME f-princ
DO:
    ASSIGN l-log = IF  l-log = "IN,OUT" THEN "LOG" ELSE "IN,OUT".
    apply "choose" to bt-atualiza in frame f-princ.
END.
&ANALYZE-RESUME

&Scoped-define SELF-NAME rect-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-connection C-Win
ON  M OF bt-connection IN FRAME f-princ
OR  m OF bt-connection IN FRAME f-princ
OR  CTRL-ALT-C OF bt-connection IN FRAME f-princ
DO:
    FIND FIRST ngadapterparms EXCLUSIVE-LOCK NO-ERROR.
    IF  NOT AVAIL ngadapterparms THEN DO:
        CREATE ngadapterparms.
        ASSIGN SUBSTR(ngadapterparms.queuename,1,10) = "0000500005".
    END.
    ASSIGN i-max-msg = INT(SUBSTR(ngadapterparms.queuename,6,5)).
    MESSAGE "Max Size (MB):" UPDATE i-max-msg FORMAT ">>>>9)" IN WINDOW c-win.
    ASSIGN SUBSTR(ngadapterparms.queuename,6,5) = STRING(i-max-msg,"99999").
END.
&ANALYZE-RESUME

&Scoped-define SELF-NAME rect-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-connection C-Win
ON  R OF bt-connection IN FRAME f-princ
OR  r OF bt-connection IN FRAME f-princ
DO:
    MESSAGE "Max Rows (Browse):" UPDATE i-maxrows FORMAT ">>>>9)" IN WINDOW c-win.
END.
&ANALYZE-RESUME

&Scoped-define SELF-NAME rect-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inicia C-Win
ON CHOOSE OF bt-inicia IN FRAME f-princ 
DO:
    CREATE NGMessageQueue.
    ASSIGN NGMessageQueue.NGMessageQueueName     = "LOG"
           NGMessageQueue.NGMessageQueueID       = NEXT-VALUE(sq_ngmessagequeue)
           NGMessageQueue.NGMessageQueueSequence = 1
           NGMessageQueue.DateTime               = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS")
           NGMessageQueue.XMLMessage             = "Start. Login = " + USERID("mgadm") + " - Delay: " + STRING(i-delay,"99999") + " - Conex∆o: " + ngadapterparms.queuemanager
           NGMessageQueue.Done                   = TRUE.
    RELEASE NGMessageQueue.
    IF  ENTRY(1,ngadapterparms.queuemanager,",") = "FILE" THEN DO:
        FILE-INFO:FILE-NAME = ENTRY(2,ngadapterparms.queuemanager,",").
        IF  FILE-INFO:FILE-TYPE = ?
        OR  INDEX(FILE-INFO:FILE-TYPE,"D") = 0 
        OR  INDEX(FILE-INFO:FILE-TYPE,"R") = 0
        OR  INDEX(FILE-INFO:FILE-TYPE,"W") = 0 THEN DO:
            ASSIGN l-erro = YES.
            MESSAGE "Diret¢rio de Entrada inexistente ou sem permiss∆o (DRW)" VIEW-AS ALERT-BOX.
        END.
        FILE-INFO:FILE-NAME = ENTRY(3,ngadapterparms.queuemanager,",").
        IF  FILE-INFO:FILE-TYPE = ?
        OR  INDEX(FILE-INFO:FILE-TYPE,"D") = 0 
        OR  INDEX(FILE-INFO:FILE-TYPE,"R") = 0
        OR  INDEX(FILE-INFO:FILE-TYPE,"W") = 0 THEN DO:
            ASSIGN l-erro = YES.
            MESSAGE "Diret¢rio de Saida inexistente ou sem permiss∆o (DRW)" VIEW-AS ALERT-BOX.
        END.
    END.

END. 
&ANALYZE-RESUME 
&Scoped-define SELF-NAME i-delay
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-delay C-Win
ON CHOOSE OF bt-ok-delay IN FRAME f-princ 
DO:
    DO  WITH FRAME f-princ:
        ASSIGN i-delay = INPUT i-delay.
        IF  i-delay < 1 THEN
            ASSIGN i-delay = 1.
        FIND FIRST ngadapterparms EXCLUSIVE-LOCK NO-ERROR.
        IF  NOT AVAIL ngadapterparms THEN 
            CREATE ngadapterparms.
        ASSIGN SUBSTR(ngadapterparms.queuename,1,5) = STRING(i-delay,"99999").
        ENABLE ALL EXCEPT bt-para WITH FRAME f-princ.
        DISABLE i-delay bt-ok-delay.
        i-delay:VISIBLE        = FALSE.
        bt-ok-delay:VISIBLE    = FALSE.
        bt-connection:VISIBLE = TRUE.
    END.
END. 
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-para
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-para C-Win
ON CHOOSE OF bt-para IN FRAME f-princ /* Encerra Processamento */
DO:
  l-processando = NO.
  CREATE NGMessageQueue.
  ASSIGN NGMessageQueue.NGMessageQueueName     = "LOG"
         NGMessageQueue.NGMessageQueueID       = NEXT-VALUE(sq_ngmessagequeue)
         NGMessageQueue.NGMessageQueueSequence = 1
         NGMessageQueue.DateTime               = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"HH:MM:SS")
         NGMessageQueue.XMLMessage             = "Stop. Login = " + USERID("mgadm") + " - Delay: " + STRING(i-delay,"99999") + " - Conex∆o: " + ngadapterparms.queuemanager
         NGMessageQueue.Done                   = TRUE.
  RELEASE NGMessageQueue.
  ENABLE bt-inicia bt-delay bt-connection WITH FRAME f-princ.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */


ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

on "F5" anywhere do:
    apply "choose" to bt-atualiza in frame f-princ.
end.

PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  IF  CONNECTED("MGUNI") THEN DO:
      RUN btb\btb906za.p.
      &IF "{&FRAME_VERSION}" = "1" &THEN /* Novo Frame */
        IF &IF "{&product_version}" >= "12.1.13" &THEN
            NUM-ENTRIES(SESSION:PARAMETER) >= 5 AND
            &ENDIF 
            cCodUsuario <> "" AND 
            cSenhaUsuario <> "" THEN 
              ASSIGN v-start-aut = YES.
      &ELSE /* Jboss */
        IF  NUM-ENTRIES(SESSION:PARAMETER) >= 5  
        AND ENTRY(4,SESSION:PARAMETER) <> ""
        AND ENTRY(5,SESSION:PARAMETER) <> "" THEN 
            ASSIGN v-start-aut = YES.
      &ENDIF
  END.
  ELSE DO: 
      ASSIGN i-cont = 1.
      REPEAT ON ENDKEY UNDO, RETRY:
          ASSIGN c-id    = ""
                 c-senha = "".
          &IF "{&FRAME_VERSION}" = "1" &THEN /* Novo Frame */
            IF &IF "{&product_version}" >= "12.1.13" &THEN
              NUM-ENTRIES(SESSION:PARAMETER) >= 5 AND
              &ENDIF 
              cCodUsuario <> "" AND 
              cSenhaUsuario <> "" THEN
                ASSIGN c-id        = cCodUsuario
                       c-senha     = cSenhaUsuario
                       i-cont      = 3
                       v-start-aut = YES.
          &ELSE /* Jboss */
            IF  NUM-ENTRIES(SESSION:PARAMETER) >= 5  
            AND ENTRY(4,SESSION:PARAMETER) <> ""
            AND ENTRY(5,SESSION:PARAMETER) <> "" THEN 
                ASSIGN c-id        = ENTRY(4,SESSION:PARAMETER)
                       c-senha     = ENTRY(5,SESSION:PARAMETER)
                       i-cont      = 3
                       v-start-aut = YES.
          &ENDIF
          ELSE 
              UPDATE c-id
                     c-senha
                     bt-ok
                     bt-cancela WITH FRAME fr-usuario.
          IF  SETUSERID(c-id,c-senha,"mgadm") THEN DO:
              DO  i-aux = 1 TO NUM-DBS:
                  IF  LDBNAME(i-aux) = "mgadm" THEN
                      NEXT.
                  IF  SETUSERID(c-id,c-senha,LDBNAME(i-aux)) THEN.
              END.
              HIDE FRAME fr-usuario NO-PAUSE.
              LEAVE.
          END.
          MESSAGE "Password Incorrect" SKIP VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
          IF  i-cont = 3 THEN
              QUIT.
          ASSIGN i-cont = i-cont + 1.
      END.
      ASSIGN v_cod_usuar_corren = c-id.
  END. 
  IF  v_cod_usuar_corren = ""
  OR  v_cod_usuar_corren = ? THEN 
      QUIT.            
  
  FIND FIRST ngadapterparms NO-LOCK NO-ERROR.
  IF  AVAIL ngadapterparms THEN
      ASSIGN i-delay = IF  INTEGER(SUBSTR(ngadapterparms.queuename,1,5)) >= 1 THEN INTEGER(SUBSTR(ngadapterparms.queuename,1,5)) ELSE 5.

  APPLY "value-changed" to {&browse-name} IN FRAME f-princ.
  REPEAT:
    STATUS INPUT "Status: Stopped...".
    PROCESS EVENTS.
    IF  v-start-aut = YES THEN DO:
        WAIT-FOR CLOSE OF THIS-PROCEDURE OR CHOOSE OF bt-inicia IN FRAME f-princ PAUSE 1.
        ASSIGN v-start-aut = NO.
        APPLY "choose" TO bt-inicia IN FRAME f-princ.
    END.
    ELSE    
        WAIT-FOR CLOSE OF THIS-PROCEDURE OR CHOOSE OF bt-inicia IN FRAME f-princ.
    IF  l-erro = YES THEN DO:
        ASSIGN l-erro = NO.
        NEXT.
    END.
    l-processando = YES.
    STATUS INPUT "Status: Starting...".

    DISABLE bt-fechar WITH FRAME f-princ.
    DISABLE bt-inicia WITH FRAME f-princ.
    DISABLE bt-deletenproc WITH FRAME f-princ.
    DISABLE bt-deleteproc WITH FRAME f-princ.
    DISABLE bt-delete WITH FRAME f-princ.
    DISABLE bt-delay WITH FRAME f-princ.
    DISABLE bt-connection WITH FRAME f-princ.
    ENABLE bt-para WITH FRAME f-princ.
    DO  WHILE l-processando: 
        WAIT-FOR CLOSE OF THIS-PROCEDURE OR CHOOSE OF bt-para IN FRAME f-princ PAUSE i-delay.
        IF  NOT CONNECTED("NEOGRID") THEN
            QUIT.
        IF  l-processando THEN DO:
            FIND FIRST ngadapterparms NO-LOCK NO-ERROR.
            IF  AVAIL ngadapterparms THEN DO:
                IF  NUM-ENTRIES(ngadapterparms.queuemanager,",") = 3 
                AND ENTRY(1,ngadapterparms.queuemanager,",") = "MQ" THEN DO:
                    RUN adapters/neogrid/utp/aneut102.p.
                    RUN adapters/neogrid/utp/aneut103.p.
                END.
                ELSE DO:
                    IF  NUM-ENTRIES(ngadapterparms.queuemanager,",") >= 3 
                    AND ENTRY(1,ngadapterparms.queuemanager,",") = "HTTP" THEN DO:
                        IF  INTEGER(SUBSTR(PROVERSION,1,R-INDEX(PROVERSION,".") - 1)) >= 9 THEN
                            RUN adapters/neogrid/utp/aneut112.p.
                        RUN adapters/neogrid/utp/aneut103.p.
                    END.
                    
                    ELSE DO:
                        IF  NUM-ENTRIES(ngadapterparms.queuemanager,",") = 4 
                        AND ENTRY(1,ngadapterparms.queuemanager,",") = "FILE" THEN DO:
                            RUN adapters/neogrid/utp/aneut122.p.
                            RUN adapters/neogrid/utp/aneut103.p. 
                        END.
                        ELSE DO:
                            MESSAGE "Conection Parameter incorrect" VIEW-AS ALERT-BOX.
                            APPLY "choose" TO bt-para IN FRAME f-princ.
                        END.
                    END.
                END.
            END.
            ELSE DO:
                MESSAGE "Falta configuraá∆o da conex∆o" VIEW-AS ALERT-BOX.
                APPLY "choose" TO bt-para IN FRAME f-princ.
            END.
        END.
        APPLY "choose" TO bt-atualiza IN FRAME f-princ.
    END.
    
    ENABLE bt-fechar WITH FRAME f-princ.
    ENABLE bt-inicia WITH FRAME f-princ.
    ENABLE bt-deletenproc WITH FRAME f-princ.
    ENABLE bt-deleteproc WITH FRAME f-princ.
    ENABLE bt-delete WITH FRAME f-princ.
    ENABLE bt-delay WITH FRAME f-princ.
    ENABLE bt-connection WITH FRAME f-princ.
    DISABLE bt-para WITH FRAME f-princ.
    PROCESS EVENTS.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
  ENABLE BROWSE-1 bt-fechar bt-atualiza bt-delete bt-deleteproc bt-deletenproc 
         bt-inicia bt-delay bt-connection RECT-1 
      WITH FRAME f-princ IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-princ}
  VIEW C-Win.
END PROCEDURE.

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
         bt-inicia:HIDDEN IN FRAME f-princ                 = yes
         bt-inicia:HEIGHT IN FRAME f-princ                 = 1.17
         bt-inicia:ROW IN FRAME f-princ                    = 13.54
         bt-inicia:HIDDEN IN FRAME f-princ                 = no.

      ASSIGN
         bt-para:HIDDEN IN FRAME f-princ                   = yes
         bt-para:HEIGHT IN FRAME f-princ                   = 1.17
         bt-para:ROW IN FRAME f-princ                      = 13.54
         bt-para:WIDTH IN FRAME f-princ                    = 24.14
         bt-para:HIDDEN IN FRAME f-princ                   = no.

      ASSIGN
         bt-delay:HIDDEN IN FRAME f-princ                  = yes
         bt-delay:HEIGHT IN FRAME f-princ                  = 1
         bt-delay:ROW IN FRAME f-princ                     = 13.25
         bt-delay:WIDTH IN FRAME f-princ                   = 24
         bt-delay:HIDDEN IN FRAME f-princ                  = no.
      
      ASSIGN
         bt-connection:HIDDEN IN FRAME f-princ            = yes
         bt-connection:HEIGHT IN FRAME f-princ            = 1
         bt-connection:ROW IN FRAME f-princ               = 13.25
         bt-connection:WIDTH IN FRAME f-princ             = 12.08
         bt-connection:HIDDEN IN FRAME f-princ            = no.
      
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
         bt-atualiza:COL IN FRAME f-princ                  = 12
         bt-atualiza:WIDTH IN FRAME f-princ                = 10
         bt-atualiza:HIDDEN IN FRAME f-princ               = no NO-ERROR.

      ASSIGN
         bt-delete:HIDDEN IN FRAME f-princ                 = yes
         bt-delete:HEIGHT IN FRAME f-princ                 = 1
         bt-delete:ROW IN FRAME f-princ                    = 12
         bt-delete:COL IN FRAME f-princ                    = 23
         bt-delete:WIDTH IN FRAME f-princ                  = 9
         bt-delete:HIDDEN IN FRAME f-princ                 = no NO-ERROR.

      ASSIGN
         bt-deleteproc:HIDDEN IN FRAME f-princ             = yes
         bt-deleteproc:HEIGHT IN FRAME f-princ             = 1
         bt-deleteproc:ROW IN FRAME f-princ                = 12
         bt-deleteproc:COL IN FRAME f-princ                = 33
         bt-deleteproc:WIDTH IN FRAME f-princ              = 14
         bt-deleteproc:LABEL IN FRAME f-princ              = "Delete Proc" 
         bt-deleteproc:HIDDEN IN FRAME f-princ             = no NO-ERROR.

      ASSIGN
         bt-deletenproc:HIDDEN IN FRAME f-princ            = yes
         bt-deletenproc:HEIGHT IN FRAME f-princ            = 1
         bt-deletenproc:ROW IN FRAME f-princ               = 12
         bt-deletenproc:COL IN FRAME f-princ               = 48
         bt-deletenproc:WIDTH IN FRAME f-princ             = 18
         bt-deletenproc:LABEL IN FRAME f-princ             = "Delete Not Proc"
         bt-deletenproc:HIDDEN IN FRAME f-princ            = no NO-ERROR.

      ASSIGN
         bt-fechar:HIDDEN IN FRAME f-princ                 = yes
         bt-fechar:HEIGHT IN FRAME f-princ                 = 1
         bt-fechar:ROW IN FRAME f-princ                    = 12
         bt-fechar:WIDTH IN FRAME f-princ                  = 8
         bt-fechar:HIDDEN IN FRAME f-princ                 = no NO-ERROR.

      ASSIGN
         bt-inicia:HIDDEN IN FRAME f-princ                 = yes
         bt-inicia:HEIGHT IN FRAME f-princ                 = 1
         bt-inicia:ROW IN FRAME f-princ                    = 13
         bt-inicia:WIDTH IN FRAME f-princ                  = 22
         bt-inicia:HIDDEN IN FRAME f-princ                 = no NO-ERROR.

      ASSIGN
         bt-para:HIDDEN IN FRAME f-princ                   = yes
         bt-para:HEIGHT IN FRAME f-princ                   = 1
         bt-para:ROW IN FRAME f-princ                      = 13
         bt-para:COL IN FRAME f-princ                      = 26
         bt-para:WIDTH IN FRAME f-princ                    = 23
         bt-para:HIDDEN IN FRAME f-princ                   = no NO-ERROR.

      ASSIGN
         bt-delay:HIDDEN IN FRAME f-princ                  = yes
         bt-delay:HEIGHT IN FRAME f-princ                  = 1
         bt-delay:ROW IN FRAME f-princ                     = 13
         bt-delay:COL IN FRAME f-princ                     = 50
         bt-delay:WIDTH IN FRAME f-princ                   = 7
         bt-delay:HIDDEN IN FRAME f-princ                  = no.
      
      ASSIGN
         bt-connection:HIDDEN IN FRAME f-princ             = yes
         bt-connection:HEIGHT IN FRAME f-princ             = 1
         bt-connection:ROW IN FRAME f-princ                = 13                  bt-connection:COL IN FRAME f-princ                = 58
         bt-connection:WIDTH IN FRAME f-princ              = 9
         bt-connection:LABEL IN FRAME f-princ              = "Connection" 
         bt-connection:HIDDEN IN FRAME f-princ             = no.
      
      ASSIGN
         RECT-1:EDGE-PIXELS IN FRAME f-princ               = 2
         RECT-1:HIDDEN IN FRAME f-princ                    = yes
         RECT-1:HEIGHT IN FRAME f-princ                    = 4
         RECT-1:ROW IN FRAME f-princ                       = 11
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
         bt-inicia:HIDDEN IN FRAME f-princ                 = yes
         bt-inicia:ROW IN FRAME f-princ                    = 13.25
         bt-inicia:HIDDEN IN FRAME f-princ                 = no.

      ASSIGN
         bt-para:HIDDEN IN FRAME f-princ                   = yes
         bt-para:ROW IN FRAME f-princ                      = 13.25
         bt-para:HIDDEN IN FRAME f-princ                   = no.

      ASSIGN
         bt-delay:HIDDEN IN FRAME f-princ                  = yes
         bt-delay:ROW IN FRAME f-princ                     = 13.25
         bt-delay:HIDDEN IN FRAME f-princ                  = no.
      
      ASSIGN
         bt-connection:HIDDEN IN FRAME f-princ            = yes
         bt-connection:ROW IN FRAME f-princ               = 13.25
         bt-connection:HIDDEN IN FRAME f-princ            = no.
      
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
         bt-inicia:HIDDEN IN FRAME f-princ                 = yes
         bt-inicia:ROW IN FRAME f-princ                    = 13.25
         bt-inicia:HIDDEN IN FRAME f-princ                 = no.

      ASSIGN
         bt-para:HIDDEN IN FRAME f-princ                   = yes
         bt-para:ROW IN FRAME f-princ                      = 13.25
         bt-para:HIDDEN IN FRAME f-princ                   = no.

      ASSIGN
         bt-delay:HIDDEN IN FRAME f-princ                  = yes
         bt-delay:ROW IN FRAME f-princ                     = 13.25
         bt-delay:HIDDEN IN FRAME f-princ                  = no.
      
      ASSIGN
         bt-connection:HIDDEN IN FRAME f-princ            = yes
         bt-connection:ROW IN FRAME f-princ               = 13.25
         bt-connection:HIDDEN IN FRAME f-princ            = no.
      
      ASSIGN
         RECT-1:EDGE-PIXELS IN FRAME f-princ               = 2
         RECT-1:HIDDEN IN FRAME f-princ                    = yes
         RECT-1:ROW IN FRAME f-princ                       = 11.3
         RECT-1:HIDDEN IN FRAME f-princ                    = no.

    END.  /* Standard Windows 95 Layout Case */

  END CASE.
END PROCEDURE.  /* C-Win-layouts */
&ANALYZE-RESUME

