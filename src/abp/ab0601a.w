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
{include/i-prgvrs.i AB0601A 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0601a MAB}
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
&GLOBAL-DEFINE Program        AB0601A
&GLOBAL-DEFINE Version        2.00.00.007

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              tgAtual tgAcima ~
                              fiDataIni fiDataFim ~
                              fiCausaIni fiCausaFim ~
                              lAtivos lInativos ~
                              lMotorizados lNaoMotorizados ~
                              lProprios lTerceiros ~

/* Parameters Definitions ---                                           */
define input-output parameter pDataIni        as date format "99/99/9999" no-undo.
define input-output parameter pDataFim        as date format "99/99/9999" no-undo.
DEFINE INPUT-OUTPUT PARAMETER pCausaIni       AS CHARACTER FORMAT "x(8)" INITIAL "" NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pCausaFim       AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" NO-UNDO.
define input-output parameter pAtual          as logical                  no-undo.
define input-output parameter pAcima          as logical                  no-undo.
define input-output parameter pAtivos         as LOGICAL INITIAL YES      no-undo.
define input-output parameter pInativos       as logical INITIAL YES      no-undo.
define input-output parameter pMotorizados    as logical INITIAL YES      no-undo.
define input-output parameter pNaoMotorizados as logical INITIAL YES      no-undo.
define input-output parameter pProprios       as logical INITIAL YES      no-undo.
define input-output parameter pTerceiros      as logical INITIAL YES      no-undo.
define output       parameter lOK             as logical                  no-undo.

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
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-2 rtKeys rtToolBar IMAGE-3 ~
IMAGE-4 rtKeys-2 fiDataIni fiDataFim fiCausaIni fiCausaFim tgAtual tgAcima ~
lAtivos lInativos lMotorizados lNaoMotorizados lProprios lTerceiros btOK ~
btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fiDataIni fiDataFim fiCausaIni fiCausaFim ~
tgAtual tgAcima lAtivos lInativos lMotorizados lNaoMotorizados lProprios ~
lTerceiros
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

DEFINE VARIABLE fiCausaFim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiCausaIni AS CHARACTER FORMAT "X(8)":U 
     LABEL "Causa" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiDataFim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiDataIni AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1800 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 9.5.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 60 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE lAtivos AS LOGICAL INITIAL no 
     LABEL "Ativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE lInativos AS LOGICAL INITIAL no 
     LABEL "Inativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE lMotorizados AS LOGICAL INITIAL no 
     LABEL "Motorizados" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE lNaoMotorizados AS LOGICAL INITIAL no 
     LABEL "N∆o Motorizados" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE lProprios AS LOGICAL INITIAL no 
     LABEL "Pr¢prios" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE lTerceiros AS LOGICAL INITIAL no 
     LABEL "Terceiros" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE tgAcima AS LOGICAL INITIAL no 
     LABEL "Exibe Somente % Remonta Acima do Padr∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.29 BY .83 NO-UNDO.

DEFINE VARIABLE tgAtual AS LOGICAL INITIAL no 
     LABEL "Analisa % Remonta Atual do Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.29 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiDataIni AT ROW 1.75 COL 12 COLON-ALIGNED WIDGET-ID 4
     fiDataFim AT ROW 1.75 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     fiCausaIni AT ROW 3 COL 12 COLON-ALIGNED
     fiCausaFim AT ROW 3 COL 36 COLON-ALIGNED NO-LABEL
     tgAtual AT ROW 4.42 COL 14 WIDGET-ID 12
     tgAcima AT ROW 5.42 COL 14 WIDGET-ID 10
     lAtivos AT ROW 7.21 COL 8.14
     lInativos AT ROW 7.21 COL 32.14
     lMotorizados AT ROW 8.21 COL 8.14
     lNaoMotorizados AT ROW 8.21 COL 32.14
     lProprios AT ROW 9.21 COL 8.14
     lTerceiros AT ROW 9.21 COL 32.14
     btOK AT ROW 10.92 COL 2
     btCancel AT ROW 10.92 COL 13
     btHelp2 AT ROW 10.92 COL 50
     "Equipamentos" VIEW-AS TEXT
          SIZE 10.14 BY .54 AT ROW 6.5 COL 7.86
     IMAGE-1 AT ROW 3 COL 24.14
     IMAGE-2 AT ROW 3 COL 34.86
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 10.67 COL 1
     IMAGE-3 AT ROW 1.75 COL 34.86 WIDGET-ID 6
     IMAGE-4 AT ROW 1.75 COL 24.14 WIDGET-ID 8
     rtKeys-2 AT ROW 6.75 COL 6.57 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60 BY 11.08
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
         HEIGHT             = 11.08
         WIDTH              = 60
         MAX-HEIGHT         = 11.08
         MAX-WIDTH          = 60
         VIRTUAL-HEIGHT     = 11.08
         VIRTUAL-WIDTH      = 60
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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    assign lOK = no.

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
    assign pDataIni = input frame fPage0 fiDataIni 
           pDataFim = input frame fPage0 fiDataFim
           pAtual   = tgAtual:checked in frame fPage0
           pAcima   = tgAcima:checked in frame fPage0
           pAtivos         = lAtivos:checked         in frame fPage0
           pInativos       = lInativos:checked       in frame fPage0
           pMotorizados    = lMotorizados:checked    in frame fPage0
           pNaoMotorizados = lNaoMotorizados:checked in frame fPage0
           pProprios       = lProprios:checked       in frame fPage0
           pTerceiros      = lTerceiros:checked      in frame fPage0
           lOK             = yes
           pCausaIni       = INPUT FRAME fPage0 fiCausaIni
           pCausaFim       = INPUT FRAME fPage0 fiCausaFim.

    IF pAtivos = FALSE AND pInativos = FALSE THEN
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 53938,
                           INPUT "").
        
    ELSE IF pMotorizados = FALSE AND pNaoMotorizados = FALSE THEN
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 53939,
                           INPUT "").

    ELSE IF pProprios = FALSE AND pTerceiros = FALSE THEN
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 53940,
                           INPUT "").
    ELSE 
        APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lAtivos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lAtivos wWindow
ON VALUE-CHANGED OF lAtivos IN FRAME fpage0 /* Ativos */
DO:
  if tgAtual:checked in frame fPage0 then
      assign tgAcima:sensitive in frame fPage0 = yes.
  else 
      assign tgAcima = no
             tgAcima:sensitive in frame fPage0 = no.

  display tgAcima with frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lInativos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lInativos wWindow
ON VALUE-CHANGED OF lInativos IN FRAME fpage0 /* Inativos */
DO:
  if tgAtual:checked in frame fPage0 then
      assign tgAcima:sensitive in frame fPage0 = yes.
  else 
      assign tgAcima = no
             tgAcima:sensitive in frame fPage0 = no.

  display tgAcima with frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgAtual
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgAtual wWindow
ON VALUE-CHANGED OF tgAtual IN FRAME fpage0 /* Analisa % Remonta Atual do Equipamento */
DO:
  if tgAtual:checked in frame fPage0 then
      assign tgAcima:sensitive in frame fPage0 = yes.
  else 
      assign tgAcima = no
             tgAcima:sensitive in frame fPage0 = no.

  display tgAcima with frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wWindow 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cRemonta AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTexto   AS CHARACTER  NO-UNDO.

{utp/ut-liter.i "Remonta" MAB}
ASSIGN cRemonta = RETURN-VALUE.

{utp/ut-liter.i "Analisa"}
ASSIGN cTexto = RETURN-VALUE.
{utp/ut-liter.i "Atual do Equipamento"}
ASSIGN tgAtual:LABEL IN FRAME fPage0 = cTexto + " % " + cRemonta + " " + RETURN-VALUE.
{utp/ut-liter.i "Exibe Somente"}
ASSIGN cTexto = RETURN-VALUE.
{utp/ut-liter.i "Acima do Padr∆o"}
ASSIGN tgAcima:LABEL IN FRAME fPage0 = cTexto + " % " + cRemonta + " " + RETURN-VALUE.
{utp/ut-liter.i "Ativos"}
ASSIGN lAtivos:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Motorizados"}
ASSIGN lMotorizados:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Pr¢prios"}
ASSIGN lProprios:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Inativos"}
ASSIGN lInativos:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "N∆o Motorizados"}
ASSIGN lNaoMotorizados:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Terceiros"}
ASSIGN lTerceiros:LABEL IN FRAME fPage0 = RETURN-VALUE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializaá∆o da tela
------------------------------------------------------------------------------*/
assign tgAtual   = pAtual
       tgAcima   = pAcima
       fiDataIni = pDataIni
       fiDataFim = pDataFim
       fiCausaIni = pCausaIni
       fiCausaFim = pCausaFim
       lAtivos         = pAtivos
       lInativos       = pInativos
       lMotorizados    = pMotorizados
       lNaoMotorizados = pNaoMotorizados
       lProprios       = pProprios
       lTerceiros      = pTerceiros.     

display tgAtual  
        tgAcima  
        fiDataIni
        fiDataFim
        fiCausaIni
        fiCausaFim
        lAtivos
        lInativos
        lMotorizados
        lNaoMotorizados
        lProprios
        lTerceiros
    with frame fPage0.

apply "VALUE-CHANGED":U to tgAtual in frame fPage0.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

