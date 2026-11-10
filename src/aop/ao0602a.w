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
{include/i-prgvrs.i AO0602A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0602a MAO}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AO0602A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType    Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 tgAprovado tgReprovado tgPendente tgAprovUsuar~
                              

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER pPendente   AS   LOGICAL                    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pAprovado   AS   LOGICAL                    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pAprovUsuar AS   LOGICAL                    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pReprovado  AS   LOGICAL                    NO-UNDO.
DEFINE OUTPUT       PARAMETER pOK         AS   LOGICAL                    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tgPendente tgAprovado tgAprovUsuar ~
tgReprovado btOK btCancel btHelp2 fiTexto3 RECT-4 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS tgPendente tgAprovado tgAprovUsuar ~
tgReprovado fiTexto3 

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

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fiTexto3 AS CHARACTER FORMAT "X(256)":U INITIAL "Estado dos Ensaios" 
      VIEW-AS TEXT 
     SIZE 15 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42 BY 3.46.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 41 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tgAprovado AS LOGICAL INITIAL yes 
     LABEL "Aprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .83 NO-UNDO.

DEFINE VARIABLE tgAprovUsuar AS LOGICAL INITIAL yes 
     LABEL "Aprovado pelo Usu rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.14 BY .83 NO-UNDO.

DEFINE VARIABLE tgPendente AS LOGICAL INITIAL yes 
     LABEL "Pendente" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .83 NO-UNDO.

DEFINE VARIABLE tgReprovado AS LOGICAL INITIAL yes 
     LABEL "Reprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tgPendente AT ROW 1.75 COL 4
     tgAprovado AT ROW 1.75 COL 27
     tgAprovUsuar AT ROW 3.5 COL 4
     tgReprovado AT ROW 3.5 COL 27
     btOK AT ROW 5.21 COL 2
     btCancel AT ROW 5.21 COL 13
     btHelp2 AT ROW 5.21 COL 29
     fiTexto3 AT ROW 1 COL 2 NO-LABEL
     RECT-4 AT ROW 1.29 COL 1
     rtToolBar AT ROW 5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 42.43 BY 5.79
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
         TITLE              = "Filtro"
         HEIGHT             = 5.58
         WIDTH              = 43
         MAX-HEIGHT         = 18
         MAX-WIDTH          = 90.86
         VIRTUAL-HEIGHT     = 18
         VIRTUAL-WIDTH      = 90.86
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
/* SETTINGS FOR FILL-IN fiTexto3 IN FRAME fpage0
   ALIGN-L                                                              */
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
ON END-ERROR OF wWindow /* Filtro */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Filtro */
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
    assign pOK = no. 
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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
    run piGrava in this-procedure.
    assign pOK = yes. 
    if return-value = "NOK":U then
        return no-apply.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializa‡Æo do programam ---*/

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s inicializa‡Æo da tela.
------------------------------------------------------------------------------*/

/** Labels dos campos **/
{utp/ut-liter.i Aprovado * }
assign tgAprovado:label in frame fPage0 = return-value.
{utp/ut-liter.i Reprovado * }
assign tgReprovado:label in frame fPage0 = return-value.
{utp/ut-liter.i Pendente * }
assign tgPendente:label in frame fPage0 = return-value.
{utp/ut-liter.i Estado_Ensaios * }
assign fiTexto3:screen-value in frame fPage0 = return-value.

assign tgPendente:checked        in frame fPage0    =    pPendente  
       tgAprovado:checked        in frame fPage0    =    pAprovado  
       tgAprovUsuar:checked      in frame fPage0    =    pAprovUsuar
       tgReprovado:checked       in frame fPage0    =    pReprovado.

/* disp tgPendente                     */
/*      tgAprovado                     */
/*      tgAprovUsuar                   */
/*      tgReprovado with frame fPage0. */

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGrava wWindow 
PROCEDURE piGrava :
/*------------------------------------------------------------------------------
  Purpose:     piGrava
  Parameters:  <none>
  Notes:       Grava os parƒmetros selecionados na temp-table
------------------------------------------------------------------------------*/
assign  pPendente     =       tgPendente:checked        in frame fPage0     
        pAprovado     =       tgAprovado:checked        in frame fPage0     
        pAprovUsuar   =       tgAprovUsuar:checked      in frame fPage0     
        pReprovado    =       tgReprovado:checked       in frame fPage0 . 

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

