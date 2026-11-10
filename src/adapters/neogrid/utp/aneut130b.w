&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
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
/*          This .W file was created with the Progress AppBulder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF INPUT-OUTPUT PARAMETER c-string AS CHAR.
DEF INPUT-OUTPUT PARAMETER l-first  AS LOG.
DEF INPUT-OUTPUT PARAMETER l-resultlist AS LOG.
DEF OUTPUT PARAM  pi-ini     AS INT.
DEF OUTPUT PARAM  pi-fim     AS INT. 
DEF OUTPUT PARAM  pd-ini     AS DATE.
DEF OUTPUT PARAM  pd-fim     AS DATE. 
DEF OUTPUT PARAM  ph-ini     AS CHAR.
DEF OUTPUT PARAM  ph-fim     AS CHAR. 
DEF OUTPUT PARAM  pt-in      AS LOG.
DEF OUTPUT PARAM  pt-out     AS LOG. 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-what t-first t-resultlist i-ini i-fim ~
Btn_OK Btn_Cancel RECT-2 RECT-3 RECT-4 
&Scoped-Define DISPLAYED-OBJECTS c-what t-first t-resultlist i-ini i-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 10 BY 1.13
     BGCOLOR 8 FONT 0.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.13
     BGCOLOR 8 FONT 0.

DEFINE VARIABLE c-what AS CHARACTER FORMAT "X(256)":U 
     LABEL "Find What" 
     VIEW-AS FILL-IN 
     SIZE 44.57 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE i-ini AS INTEGER FORMAT ">>>>,>>9":U INITIAL 0 
     LABEL "InitialId" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE i-fim AS INTEGER FORMAT ">>>>,>>9":U INITIAL 9999999 
     LABEL "FinalId" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE d-ini AS DATE FORMAT "99/99/9999":U INITIAL 01.01.2000
     LABEL "InitialDate" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE d-fim AS DATE FORMAT "99/99/9999":U INITIAL 01.01.2999
     LABEL "FinalDate" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE h-ini AS CHAR FORMAT "99:99:99":U INITIAL "000000"
     LABEL "InitialHour" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE h-fim AS CHAR FORMAT "99:99:99":U INITIAL "240000"
     LABEL "FinalHour" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 56.72 BY 3.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 56.72 BY 4.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 56.72 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE t-first AS LOGICAL INITIAL yes 
     LABEL "Find First Ocurrence" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.43 BY .83 NO-UNDO.

DEFINE VARIABLE t-resultlist AS LOGICAL INITIAL no 
     LABEL "Show Result List" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.43 BY .83 NO-UNDO.

DEFINE VARIABLE t-in AS LOGICAL INITIAL yes 
     LABEL "In" 
     VIEW-AS TOGGLE-BOX
     SIZE 10 BY .83 NO-UNDO.

DEFINE VARIABLE t-out AS LOGICAL INITIAL YES
     LABEL "Out" 
     VIEW-AS TOGGLE-BOX
     SIZE 10 BY .83 NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     c-what AT ROW 1.5 COL 10.43 COLON-ALIGNED
     t-first AT ROW 2.75 COL 12
     t-resultlist AT ROW 3.46 COL 12
     i-ini AT ROW 5.25 COL 13.86 COLON-ALIGNED
     i-fim AT ROW 5.25 COL 40.86 COLON-ALIGNED
     d-ini AT ROW 6.25 COL 13.86 COLON-ALIGNED
     d-fim AT ROW 6.25 COL 40.86 COLON-ALIGNED
     h-ini AT ROW 7.25 COL 13.86 COLON-ALIGNED
     h-fim AT ROW 7.25 COL 40.86 COLON-ALIGNED
     "Direction: " AT ROW 8.25 COL 5
     t-in  AT ROW 8.25 COL 15.86 
     t-out AT ROW 8.25 COL 22.86 
     Btn_OK AT ROW 9.7 COL 2
     Btn_Cancel AT ROW 9.7 COL 13
     RECT-2 AT ROW 1 COL 1
     RECT-3 AT ROW 4.88 COL 1
     RECT-4 AT ROW 9.5 COL 1
     " Filter " VIEW-AS TEXT
          SIZE 8 BY .58 AT ROW 4.67 COL 2.43
     SPACE(47.2) SKIP(2.95)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Search"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Search */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
    IF NOT INPUT t-first AND NOT INPUT T-resultlist  THEN DO:
        MESSAGE "At least one option must be selected !"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN NO-APPLY.
    END.
    
    ASSIGN c-string = INPUT c-what
         l-first  = INPUT t-first
         l-resultlist = INPUT t-resultlist
         pi-ini        = INPUT i-ini
         pi-fim        = INPUT i-fim
         pd-ini        = INPUT d-ini
         pd-fim        = INPUT d-fim
         ph-ini        = INPUT h-ini
         ph-fim        = INPUT h-fim
         pt-in         = INPUT t-in
         pt-out        = INPUT t-out.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY c-what t-first t-resultlist i-ini i-fim d-ini d-fim h-ini h-fim t-in t-out
      WITH FRAME Dialog-Frame.
  ENABLE c-what t-first t-resultlist i-ini i-fim d-ini d-fim h-ini h-fim t-in t-out Btn_OK Btn_Cancel RECT-2 
         RECT-3 RECT-4 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

