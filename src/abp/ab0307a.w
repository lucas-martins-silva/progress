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
{include/i-prgvrs.i AB0307A 2.00.00.002}  /*** 010002 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0307a MAB}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0307A
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType    Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 rsVisualiza ~
                              tgAtivos tgInativos tgProprios tgTerceiros ~
                              tgMotorizados tgNMotorizados fiAtualiza fiTexto1 fiTexto fiMin

{abp/ab0307.i} /** Defini‡Æo da ttSelecao **/

/* Parameters Definitions ---                                           */
define input-output parameter table for ttSelecao.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-18 RECT-19 rtToolBar rsVisualiza ~
tgAtivos tgInativos tgProprios tgTerceiros tgMotorizados tgNMotorizados ~
fiAtualiza btOK btCancel btHelp2 fiTexto fiTexto1 fiMin 
&Scoped-Define DISPLAYED-OBJECTS rsVisualiza tgAtivos tgInativos tgProprios ~
tgTerceiros tgMotorizados tgNMotorizados fiAtualiza fiTexto fiTexto1 fiMin 

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

DEFINE VARIABLE fiAtualiza AS INTEGER FORMAT ">9":U INITIAL 10 
     LABEL "Atualiza tela em" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiMin AS CHARACTER FORMAT "X(256)":U INITIAL "minutos" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto AS CHARACTER FORMAT "X(30)":U INITIAL "Visualizar Fichas Com Problemas" 
      VIEW-AS TEXT 
     SIZE 23 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto1 AS CHARACTER FORMAT "X(256)":U INITIAL "Equipamentos" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE rsVisualiza AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Consistˆncia", 1,
"Integra‡Æo Estoque", 2
     SIZE 34.72 BY .83 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39.43 BY 3.71.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39.43 BY 1.58.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39.43 BY 1.83.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 39.43 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tgAtivos AS LOGICAL INITIAL no 
     LABEL "Ativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgInativos AS LOGICAL INITIAL no 
     LABEL "Inativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tgMotorizados AS LOGICAL INITIAL no 
     LABEL "Motorizados" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgNMotorizados AS LOGICAL INITIAL no 
     LABEL "NÆo Motorizados" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.14 BY .83 NO-UNDO.

DEFINE VARIABLE tgProprios AS LOGICAL INITIAL no 
     LABEL "Pr¢prios" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgTerceiros AS LOGICAL INITIAL no 
     LABEL "Terceiros" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     rsVisualiza AT ROW 1.96 COL 3.29 NO-LABEL
     tgAtivos AT ROW 4.13 COL 3.86
     tgInativos AT ROW 4.13 COL 22.86
     tgProprios AT ROW 5.13 COL 3.86
     tgTerceiros AT ROW 5.13 COL 22.86
     tgMotorizados AT ROW 6.13 COL 3.86
     tgNMotorizados AT ROW 6.13 COL 22.86
     fiAtualiza AT ROW 7.83 COL 14.43 COLON-ALIGNED HELP
          "Atualiza a tela pela quantidade de minutos"
     btOK AT ROW 9.46 COL 2
     btCancel AT ROW 9.46 COL 13
     btHelp2 AT ROW 9.46 COL 29.57
     fiTexto AT ROW 1.08 COL 2.86 NO-LABEL
     fiTexto1 AT ROW 3.29 COL 3 NO-LABEL
     fiMin AT ROW 7.96 COL 19.72 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 3.54 COL 1
     RECT-18 AT ROW 7.5 COL 1
     RECT-19 AT ROW 1.42 COL 1
     rtToolBar AT ROW 9.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 39.5 BY 9.71
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
         HEIGHT             = 9.71
         WIDTH              = 39.57
         MAX-HEIGHT         = 9.71
         MAX-WIDTH          = 39.57
         VIRTUAL-HEIGHT     = 9.71
         VIRTUAL-WIDTH      = 39.57
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
/* SETTINGS FOR FILL-IN fiTexto IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiTexto1 IN FRAME fpage0
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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
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
{utp/ut-liter.i "Ativos"}
ASSIGN tgAtivos:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Inativos"}
ASSIGN tgInativos:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Pr¢prios"}
ASSIGN tgProprios:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Terceiros"}
ASSIGN tgTerceiros:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Motorizados"}
ASSIGN tgMotorizados:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "NÆo Motorizados"}
ASSIGN tgNMotorizados:LABEL IN FRAME fPage0 = RETURN-VALUE.

/** Busca Parƒmtros **/
find first ttSelecao no-lock no-error.
if avail ttSelecao then do:
    assign rsVisualiza = ttSelecao.iVisualiza
           tgAtivos:CHECKED IN FRAME fPage0       = ttSelecao.lAtivos
           tgInativos:CHECKED IN FRAME fPage0     = ttSelecao.lInativos
           tgProprios:CHECKED IN FRAME fPage0     = ttSelecao.lProprios
           tgTerceiros:CHECKED IN FRAME fPage0    = ttSelecao.lTerceiros
           tgMotorizados:CHECKED IN FRAME fPage0  = ttSelecao.lMotorizados
           tgNMotorizados:CHECKED IN FRAME fPage0 = ttSelecao.lNMotorizados
           fiAtualiza = ttSelecao.iAtualiza.
end.

DISP rsVisualiza fiAtualiza WITH FRAME fPage0.

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
find first ttSelecao exclusive-lock no-error.
if avail ttSelecao then do:
    assign ttSelecao.iVisualiza    = INPUT FRAME fPage0 rsVisualiza                    
           ttSelecao.lAtivos       = tgAtivos:CHECKED       IN FRAME fPage0
           ttSelecao.lInativos     = tgInativos:CHECKED     IN FRAME fPage0
           ttSelecao.lProprios     = tgProprios:CHECKED     IN FRAME fPage0
           ttSelecao.lTerceiros    = tgTerceiros:CHECKED    IN FRAME fPage0
           ttSelecao.lMotorizados  = tgMotorizados:CHECKED  IN FRAME fPage0
           ttSelecao.lNMotorizados = tgNMotorizados:CHECKED IN FRAME fPage0
           ttSelecao.iAtualiza     = INPUT FRAME fPage0 fiAtualiza.
END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

