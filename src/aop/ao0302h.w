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
{include/i-prgvrs.i AO0302H 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0302h MAO}
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
&GLOBAL-DEFINE Program        AO0302H
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btHelp2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btOK btHelp2 fiTarefa1 fiTarefa2 fiTarefa3 ~
fiTarefa4 RECT-2 RECT-28 RECT-3 RECT-4 RECT-5 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS fiTarefa1 fiTarefa2 fiTarefa3 fiTarefa4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fiTarefa1 AS CHARACTER FORMAT "X(256)":U INITIAL "Pendente Aprova‡Æo" 
      VIEW-AS TEXT 
     SIZE 23 BY .67 NO-UNDO.

DEFINE VARIABLE fiTarefa2 AS CHARACTER FORMAT "X(256)":U INITIAL "Resultado do Ensaio Aprovado" 
      VIEW-AS TEXT 
     SIZE 23 BY .67 NO-UNDO.

DEFINE VARIABLE fiTarefa3 AS CHARACTER FORMAT "X(256)":U INITIAL "Resultado Aprovado pelo Usu rio" 
      VIEW-AS TEXT 
     SIZE 32 BY .67 NO-UNDO.

DEFINE VARIABLE fiTarefa4 AS CHARACTER FORMAT "X(256)":U INITIAL "Resultado Reprovado" 
      VIEW-AS TEXT 
     SIZE 29 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 5 BY 1
     BGCOLOR 10 FGCOLOR 10 .

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45 BY 5.25.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 5 BY 1
     BGCOLOR 9 FGCOLOR 9 .

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 5 BY 1
     BGCOLOR 12 FGCOLOR 12 .

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 5 BY 1
     BGCOLOR 7 FGCOLOR 7 .

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 45 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 6.58 COL 2
     btHelp2 AT ROW 6.58 COL 35
     fiTarefa1 AT ROW 1.83 COL 10 COLON-ALIGNED NO-LABEL
     fiTarefa2 AT ROW 2.75 COL 10 COLON-ALIGNED NO-LABEL
     fiTarefa3 AT ROW 3.75 COL 10 COLON-ALIGNED NO-LABEL
     fiTarefa4 AT ROW 4.75 COL 10 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 2.5 COL 5
     RECT-28 AT ROW 1 COL 1
     RECT-3 AT ROW 3.5 COL 5
     RECT-4 AT ROW 4.5 COL 5
     RECT-5 AT ROW 1.5 COL 5
     rtToolBar AT ROW 6.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 45 BY 7
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
         TITLE              = ""
         HEIGHT             = 7
         WIDTH              = 45
         MAX-HEIGHT         = 7
         MAX-WIDTH          = 45
         VIRTUAL-HEIGHT     = 7
         VIRTUAL-WIDTH      = 45
         MAX-BUTTON         = no
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
   FRAME-NAME                                                           */
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
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s mostrar campos em tela
------------------------------------------------------------------------------*/
{utp/ut-liter.i Resultado_do_Ensaio_Aprovado * }
assign fiTarefa2:screen-value in frame fPage0 = trim(return-value).
{utp/ut-liter.i Resultado_do_Ensaio_Aprovado_Pelo_Usu rio * }
assign fiTarefa3:screen-value in frame fPage0 = trim(return-value).
{utp/ut-liter.i Resultado_do_Ensaio_Reprovado * }
assign fiTarefa4:screen-value in frame fPage0 = trim(return-value).
{utp/ut-liter.i Pendente_Aprova‡Æo * }
assign fiTarefa1:screen-value in frame fPage0 = trim(return-value).

ASSIGN RECT-2:BGCOLOR IN FRAME FPAGE0 = 10
       RECT-2:FGCOLOR IN FRAME FPAGE0 = 10
       RECT-3:BGCOLOR IN FRAME FPAGE0 = 9
       RECT-3:FGCOLOR IN FRAME FPAGE0 = 9
       RECT-4:BGCOLOR IN FRAME FPAGE0 = 12
       RECT-4:FGCOLOR IN FRAME FPAGE0 = 12
       RECT-5:BGCOLOR IN FRAME FPAGE0 = 7
       RECT-5:FGCOLOR IN FRAME FPAGE0 = 7.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

