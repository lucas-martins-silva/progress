&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME fLegenda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS fLegenda 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9008G 2.00.00.003}  /*** "010003" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9008G MBC}
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
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fLegenda

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 EDITOR-1 EDITOR-2 EDITOR-3 EDITOR-4 ~
btFechar 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 EDITOR-2 EDITOR-3 EDITOR-4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btFechar AUTO-END-KEY 
     LABEL "&Fechar" 
     SIZE 12 BY .92.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP
     SIZE 1.86 BY .56
     BGCOLOR 12  NO-UNDO.

DEFINE VARIABLE EDITOR-2 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP
     SIZE 1.86 BY .56
     BGCOLOR 9  NO-UNDO.

DEFINE VARIABLE EDITOR-3 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP
     SIZE 1.86 BY .56
     BGCOLOR 2  NO-UNDO.

DEFINE VARIABLE EDITOR-4 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP
     SIZE 1.86 BY .56
     BGCOLOR 5  NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.29 BY 4.28.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fLegenda
     EDITOR-1 AT ROW 1.52 COL 5.57 NO-LABEL
     EDITOR-2 AT ROW 2.52 COL 5.57 NO-LABEL
     EDITOR-3 AT ROW 3.52 COL 5.57 NO-LABEL
     EDITOR-4 AT ROW 4.52 COL 5.57 NO-LABEL
     btFechar AT ROW 5.76 COL 35.14
     RECT-4 AT ROW 1.2 COL 1.86
     "Itens sem Embarque Registrado" VIEW-AS TEXT
          SIZE 30.86 BY .76 AT ROW 1.36 COL 8
     "Itens Embarcados com Quantidade Abaixo do Faturado" VIEW-AS TEXT
          SIZE 38 BY .76 AT ROW 2.36 COL 8
     "Itens Embarcados Corretamente" VIEW-AS TEXT
          SIZE 27.14 BY .76 AT ROW 3.36 COL 8
     "Itens Embarcados com Quantidade Acima do Faturado" VIEW-AS TEXT
          SIZE 38.14 BY .76 AT ROW 4.36 COL 8
     SPACE(1.01) SKIP(1.67)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Legenda".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX fLegenda
                                                                        */
ASSIGN 
       FRAME fLegenda:SCROLLABLE       = FALSE
       FRAME fLegenda:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME fLegenda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fLegenda fLegenda
ON WINDOW-CLOSE OF FRAME fLegenda /* Legenda */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK fLegenda 


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI fLegenda _DEFAULT-DISABLE
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
  HIDE FRAME fLegenda.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI fLegenda _DEFAULT-ENABLE
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
  DISPLAY EDITOR-1 EDITOR-2 EDITOR-3 EDITOR-4 
      WITH FRAME fLegenda.
  ENABLE RECT-4 EDITOR-1 EDITOR-2 EDITOR-3 EDITOR-4 btFechar 
      WITH FRAME fLegenda.
  VIEW FRAME fLegenda.
  {&OPEN-BROWSERS-IN-QUERY-fLegenda}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


