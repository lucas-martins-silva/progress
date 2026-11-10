&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0104G 2.00.00.002}  /*** "010002" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0104g MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0104G
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp ~
                              c-cod-evento-ini c-cod-evento-fim ~
                              c-cod-sub-sistema-ini c-cod-sub-sistema-fim ~
                              c-tp-especial-ini c-tp-especial-fim
/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAM pc-cod-evento-ini      AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pc-cod-evento-fim      AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pc-cod-sub-sistema-ini AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pc-cod-sub-sistema-fim AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pc-tp-especial-ini     AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pc-tp-especial-fim     AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAM p-botao                AS CHARACTER NO-UNDO.

/* Local input-output paramiable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-cod-evento-ini c-cod-evento-fim ~
c-cod-sub-sistema-ini c-cod-sub-sistema-fim c-tp-especial-ini ~
c-tp-especial-fim btOK btCancel btHelp rtToolBar IMAGE-1 IMAGE-10 IMAGE-11 ~
IMAGE-7 IMAGE-8 IMAGE-9 
&Scoped-Define DISPLAYED-OBJECTS c-cod-evento-ini c-cod-evento-fim ~
c-cod-sub-sistema-ini c-cod-sub-sistema-fim c-tp-especial-ini ~
c-tp-especial-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-evento-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-evento-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Evento":R9 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-sub-sistema-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-sub-sistema-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Sub-Sistema":R15 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-especial-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-especial-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Especialidade":R15 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 61 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-cod-evento-ini AT ROW 1.75 COL 28.57 RIGHT-ALIGNED HELP
          "C¢digo do Evento"
     c-cod-evento-fim AT ROW 1.67 COL 51.29 RIGHT-ALIGNED HELP
          "C¢digo do Evento" NO-LABEL WIDGET-ID 20
     c-cod-sub-sistema-ini AT ROW 2.75 COL 28.57 RIGHT-ALIGNED HELP
          "C¢digo do Sub-Sistema" WIDGET-ID 24
     c-cod-sub-sistema-fim AT ROW 2.67 COL 51.29 RIGHT-ALIGNED HELP
          "C¢digo do Sub-Sistema" NO-LABEL WIDGET-ID 22
     c-tp-especial-ini AT ROW 3.75 COL 28.57 RIGHT-ALIGNED HELP
          "C¢digo da Especialidade" WIDGET-ID 28
     c-tp-especial-fim AT ROW 3.67 COL 51.29 RIGHT-ALIGNED HELP
          "C¢digo da Especialidade" NO-LABEL WIDGET-ID 26
     btOK AT ROW 5.5 COL 2
     btCancel AT ROW 5.5 COL 13
     btHelp AT ROW 5.5 COL 51.14
     rtToolBar AT ROW 5.29 COL 1
     IMAGE-1 AT ROW 1.75 COL 30 WIDGET-ID 8
     IMAGE-10 AT ROW 3.75 COL 30 WIDGET-ID 10
     IMAGE-11 AT ROW 3.75 COL 36 WIDGET-ID 12
     IMAGE-7 AT ROW 2.75 COL 30 WIDGET-ID 14
     IMAGE-8 AT ROW 1.67 COL 36 WIDGET-ID 16
     IMAGE-9 AT ROW 2.75 COL 36 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 61.29 BY 5.79
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Sele‡Æo"
         HEIGHT             = 5.79
         WIDTH              = 61.29
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN c-cod-evento-fim IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-cod-evento-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-cod-sub-sistema-fim IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-cod-sub-sistema-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-tp-especial-fim IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-tp-especial-ini IN FRAME fpage0
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Sele‡Æo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Sele‡Æo */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    ASSIGN pc-cod-evento-ini      = INPUT FRAME fPage0 c-cod-evento-ini
           pc-cod-evento-fim      = INPUT FRAME fPage0 c-cod-evento-fim
           pc-cod-sub-sistema-ini = INPUT FRAME fPage0 c-cod-sub-sistema-ini
           pc-cod-sub-sistema-fim = INPUT FRAME fPage0 c-cod-sub-sistema-fim
           pc-tp-especial-ini     = INPUT FRAME fPage0 c-tp-especial-ini
           pc-tp-especial-fim     = INPUT FRAME fPage0 c-tp-especial-fim
           p-botao = "OK":U.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-evento-ini
&Scoped-define SELF-NAME c-cod-sub-sistema-ini
&Scoped-define SELF-NAME c-tp-especial-ini
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
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN c-cod-evento-ini:SCREEN-VALUE IN FRAME fPage0      = pc-cod-evento-ini
           c-cod-evento-fim:SCREEN-VALUE IN FRAME fPage0      = pc-cod-evento-fim
           c-cod-sub-sistema-ini:SCREEN-VALUE IN FRAME fPage0 = pc-cod-sub-sistema-ini
           c-cod-sub-sistema-fim:SCREEN-VALUE IN FRAME fPage0 = pc-cod-sub-sistema-fim
           c-tp-especial-ini:SCREEN-VALUE IN FRAME fPage0     = pc-tp-especial-ini
           c-tp-especial-fim:SCREEN-VALUE IN FRAME fPage0     = pc-tp-especial-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

