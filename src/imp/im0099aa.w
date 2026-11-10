&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i IM0099AA 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0099AA MIM}
&ENDIF

/*------------------------------------------------------------------------

  File: 

  Description: Tela de Parƒmetros para Sele‡Æo pro programa IM0099
               Desembarque Parcial

  Author: Manuela MacanhÆo da Silva (log1520)

  Created: 28/07/2005

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */


DEFINE INPUT-OUTPUT PARAMETER pi-numero-ordem-ini     AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-numero-ordem-fim     AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-parcela-ini          AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-parcela-fim          AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-item-ini             AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-item-fim             AS CHARACTER    NO-UNDO.
DEFINE OUTPUT       PARAMETER pl-ok                   AS LOGICAL      NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE i-cont      AS INTEGER      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS i-numero-ordem-ini i-numero-ordem-fim ~
i-parcela-ini i-parcela-fim c-item-ini c-item-fim btOK btCancel btHelp ~
IMAGE-01 IMAGE-02 IMAGE-03 IMAGE-04 IMAGE-05 IMAGE-06 RECT-56 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS i-numero-ordem-ini i-numero-ordem-fim ~
i-parcela-ini i-parcela-fim c-item-ini c-item-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-item-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE i-numero-ordem-fim AS INTEGER FORMAT ">>>>>9,99" INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE i-numero-ordem-ini AS INTEGER FORMAT ">>>>>9,99" INITIAL 0 
     LABEL "Ordem de Compra" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE i-parcela-fim AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-parcela-ini AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Parcela" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-01
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-02
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-03
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-04
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-05
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-06
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-56
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 64 BY 4.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 64 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     i-numero-ordem-ini AT ROW 1.75 COL 13 COLON-ALIGNED HELP
          "Informe C¢digo da Ordem de Compra"
     i-numero-ordem-fim AT ROW 1.75 COL 41 COLON-ALIGNED HELP
          "Informe C¢digo da Ordem de Compra" NO-LABEL
     i-parcela-ini AT ROW 2.75 COL 13 COLON-ALIGNED HELP
          "Informe Classifica‡Æo Fiscal do Item"
     i-parcela-fim AT ROW 2.75 COL 41 COLON-ALIGNED HELP
          "Informe Classifica‡Æo Fiscal do Item" NO-LABEL
     c-item-ini AT ROW 3.71 COL 13 COLON-ALIGNED HELP
          "Informe C¢digo do Item"
     c-item-fim AT ROW 3.71 COL 41 COLON-ALIGNED NO-LABEL
     btOK AT ROW 5.75 COL 2
     btCancel AT ROW 5.75 COL 13
     btHelp AT ROW 5.75 COL 53.14
     IMAGE-01 AT ROW 1.75 COL 34.29
     IMAGE-02 AT ROW 1.75 COL 38.72
     IMAGE-03 AT ROW 2.75 COL 34.29
     IMAGE-04 AT ROW 2.75 COL 38.72
     IMAGE-05 AT ROW 3.75 COL 34.29
     IMAGE-06 AT ROW 3.75 COL 38.72
     RECT-56 AT ROW 1 COL 1
     rtToolBar AT ROW 5.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 64.14 BY 6.04
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
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Sele‡Æo"
         HEIGHT             = 6.21
         WIDTH              = 64.14
         MAX-HEIGHT         = 6.21
         MAX-WIDTH          = 64.14
         VIRTUAL-HEIGHT     = 6.21
         VIRTUAL-WIDTH      = 64.14
         RESIZE             = no
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fPage0
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Sele‡Æo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Sele‡Æo */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancelar */
DO:
  ASSIGN pl-ok = NO.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp C-Win
ON CHOOSE OF btHelp IN FRAME fPage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME fPage0 /* OK */
DO:
   ASSIGN pi-numero-ordem-ini = INPUT FRAME {&FRAME-NAME} i-numero-ordem-ini
          pi-numero-ordem-fim = INPUT FRAME {&FRAME-NAME} i-numero-ordem-fim
          pi-parcela-ini      = INPUT FRAME {&FRAME-NAME} i-parcela-ini
          pi-parcela-fim      = INPUT FRAME {&FRAME-NAME} i-parcela-fim
          pc-item-ini         = INPUT FRAME {&FRAME-NAME} c-item-ini
          pc-item-fim         = INPUT FRAME {&FRAME-NAME} c-item-fim
          pl-ok               = YES.

   APPLY "CLOSE":U TO THIS-PROCEDURE.

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
   DO WITH FRAME fpage0:

       IF pi-numero-ordem-ini <> 0 OR  
          pi-numero-ordem-fim <> 0 OR 
          pi-parcela-ini <> 0 OR
          pi-parcela-fim <> 0 OR 
          pc-item-ini <> "" OR
          pc-item-fim <> "" THEN
          ASSIGN i-numero-ordem-ini:SCREEN-VALUE  =   string(pi-numero-ordem-ini)      
                 i-numero-ordem-fim:SCREEN-VALUE  =   string(pi-numero-ordem-fim)
                 i-parcela-ini:SCREEN-VALUE       =   string(pi-parcela-ini)
                 i-parcela-fim:SCREEN-VALUE       =   string(pi-parcela-fim)
                 c-item-ini:SCREEN-VALUE          =   pc-item-ini
                 c-item-fim:SCREEN-VALUE          =   pc-item-fim.
       ELSE
           ASSIGN i-numero-ordem-ini:SCREEN-VALUE  =  "0"
                  i-numero-ordem-fim:SCREEN-VALUE  =  "99999999"
                  i-parcela-ini:SCREEN-VALUE       =  "0"
                  i-parcela-fim:SCREEN-VALUE       =  "99999"
                  c-item-ini:SCREEN-VALUE          =  ""
                  c-item-fim:SCREEN-VALUE          =  "ZZZZZZZZZZZZZZZZ".
   END.

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
  DISPLAY i-numero-ordem-ini i-numero-ordem-fim i-parcela-ini i-parcela-fim 
          c-item-ini c-item-fim 
      WITH FRAME fPage0 IN WINDOW C-Win.
  ENABLE i-numero-ordem-ini i-numero-ordem-fim i-parcela-ini i-parcela-fim 
         c-item-ini c-item-fim btOK btCancel btHelp IMAGE-01 IMAGE-02 IMAGE-03 
         IMAGE-04 IMAGE-05 IMAGE-06 RECT-56 rtToolBar 
      WITH FRAME fPage0 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

