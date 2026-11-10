&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d-filtro 
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


DEF INPUT PARAM c-label AS CHAR.
DEF OUTPUT PARAM p-ini AS CHAR.
DEF OUTPUT PARAM p-fim AS CHAR.
 DEFINE VARIABLE i-test AS INTEGER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME d-filtro

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-ini c-fim Btn_OK Btn_Cancel IMAGE-1 ~
IMAGE-2 RECT-3 RECT-4 
&Scoped-Define DISPLAYED-OBJECTS c-ini c-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 12 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 12 BY 1.13
     BGCOLOR 8 .

DEFINE VARIABLE c-fim AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE c-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Inicial" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 61 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 61 BY 3.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d-filtro
     c-ini AT ROW 1.75 COL 12 COLON-ALIGNED
     c-fim AT ROW 1.75 COL 35 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 4.46 COL 1
     Btn_Cancel AT ROW 4.46 COL 13.72
     IMAGE-1 AT ROW 1.83 COL 28.14
     IMAGE-2 AT ROW 1.75 COL 34
     RECT-3 AT ROW 4.25 COL 1
     RECT-4 AT ROW 1 COL 1
     SPACE(0.42) SKIP(2.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE ""
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
/* SETTINGS FOR DIALOG-BOX d-filtro
                                                                        */
ASSIGN 
       FRAME d-filtro:SCROLLABLE       = FALSE
       FRAME d-filtro:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME d-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-filtro d-filtro
ON WINDOW-CLOSE OF FRAME d-filtro
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK d-filtro
ON CHOOSE OF Btn_OK IN FRAME d-filtro /* OK */
DO:
  ASSIGN p-ini = INPUT c-ini
         p-fim = INPUT c-fim.
  RETURN "OK".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-fim d-filtro
ON LEAVE OF c-fim IN FRAME d-filtro /* Fill 2 */
DO:
    IF ENTRY(3,c-label) = 'i'  THEN DO:
     ASSIGN i-test = int(INPUT  c-fim) NO-ERROR.
     IF ERROR-STATUS:ERROR 
         THEN DO: 
         MESSAGE "Valor NÆo pode conter letras!!" VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ini d-filtro
ON LEAVE OF c-ini IN FRAME d-filtro /* Inicial */
DO:

  IF ENTRY(3,c-label) = 'i'  THEN DO:
     ASSIGN i-test = int(INPUT  c-ini) NO-ERROR.
     IF ERROR-STATUS:ERROR 
         THEN DO: 
         MESSAGE "Valor NÆo pode conter letras!!" VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d-filtro 


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

  ASSIGN FRAME d-filtro:TITLE = entry(1,c-label)
         c-fim:SCREEN-VALUE = IF ENTRY(3,c-label) = 'i' THEN "9999999999" 
                                                        ELSE "ZZZZZZZZZZZZ".
  ASSIGN c-ini:FORMAT = ENTRY(2,c-label) 
         c-fim:FORMAT = ENTRY(2,c-label) .

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d-filtro  _DEFAULT-DISABLE
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
  HIDE FRAME d-filtro.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d-filtro  _DEFAULT-ENABLE
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
  DISPLAY c-ini c-fim 
      WITH FRAME d-filtro.
  ENABLE c-ini c-fim Btn_OK Btn_Cancel IMAGE-1 IMAGE-2 RECT-3 RECT-4 
      WITH FRAME d-filtro.
  VIEW FRAME d-filtro.
  {&OPEN-BROWSERS-IN-QUERY-d-filtro}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

