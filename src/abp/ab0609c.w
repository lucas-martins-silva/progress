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
{include/i-prgvrs.i AB0609C 2.00.00.003}  /*** 010003 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0609c MAB}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0609C
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE WindowType    Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 tgIrregular tgLogContSec tgDesperdicio ~
                              tgAtivos tgProprios tgInativos tgTerceiros tgOK rs-classifica

{abp/ab0609.i} /** Defini‡Æo da ttSelecao **/

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
&Scoped-Define ENABLED-OBJECTS tgAtivos tgInativos tgProprios tgTerceiros ~
tgOK tgLogContSec tgIrregular tgDesperdicio rs-classifica btOK btCancel ~
btHelp2 fiTexto1 fiTexto2 fiClassifica RECT-1 RECT-2 RECT-3 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS tgAtivos tgInativos tgProprios tgTerceiros ~
tgOK tgLogContSec tgIrregular tgDesperdicio rs-classifica fiTexto1 fiTexto2 ~
fiClassifica 

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

DEFINE VARIABLE fiClassifica AS CHARACTER FORMAT "X(15)":U INITIAL "Classifica‡Æo" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto1 AS CHARACTER FORMAT "X(256)":U INITIAL "Equipamentos" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto2 AS CHARACTER FORMAT "X(256)":U INITIAL "Exibe" 
      VIEW-AS TEXT 
     SIZE 5.29 BY .67 NO-UNDO.

DEFINE VARIABLE rs-classifica AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "C¢digo", 1,
"Quantidade Combust¡vel", 2
     SIZE 42 BY 1.33 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49 BY 2.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49 BY 2.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49 BY 2.42.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 50 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tgAtivos AS LOGICAL INITIAL no 
     LABEL "Ativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgDesperdicio AS LOGICAL INITIAL no 
     LABEL "Considerar Desperd¡cio" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE tgInativos AS LOGICAL INITIAL no 
     LABEL "Inativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tgIrregular AS LOGICAL INITIAL no 
     LABEL "Consumo Irregular" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE tgLogContSec AS LOGICAL INITIAL no 
     LABEL "Contador Secund rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tgOK AS LOGICAL INITIAL no 
     LABEL "Consumo OK" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .88 NO-UNDO.

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
     tgAtivos AT ROW 2 COL 6
     tgInativos AT ROW 2 COL 28.14
     tgProprios AT ROW 3 COL 6
     tgTerceiros AT ROW 3 COL 28.14
     tgOK AT ROW 5 COL 6
     tgLogContSec AT ROW 5 COL 28
     tgIrregular AT ROW 6 COL 6
     tgDesperdicio AT ROW 6 COL 28
     rs-classifica AT ROW 8.42 COL 4 NO-LABEL
     btOK AT ROW 10.38 COL 2
     btCancel AT ROW 10.38 COL 13
     btHelp2 AT ROW 10.38 COL 40
     fiTexto1 AT ROW 1.25 COL 2 COLON-ALIGNED NO-LABEL
     fiTexto2 AT ROW 4.25 COL 2.29 COLON-ALIGNED NO-LABEL
     fiClassifica AT ROW 7.33 COL 2 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1.5 COL 1.57
     RECT-2 AT ROW 4.5 COL 1.57
     RECT-3 AT ROW 7.58 COL 1.57
     rtToolBar AT ROW 10.17 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 50 BY 10.63
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
         HEIGHT             = 10.63
         WIDTH              = 50
         MAX-HEIGHT         = 14.5
         MAX-WIDTH          = 50
         VIRTUAL-HEIGHT     = 14.5
         VIRTUAL-WIDTH      = 50
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
   FRAME-NAME Custom                                                    */
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
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgIrregular
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgIrregular wWindow
ON VALUE-CHANGED OF tgIrregular IN FRAME fpage0 /* Consumo Irregular */
DO:
  if tgIrregular:checked in frame fPage0 then
      assign tgDesperdicio:sensitive in frame fPage0 = yes.
  else do:
      assign tgDesperdicio:sensitive in frame fPage0 = no
             tgDesperdicio = no.
      disp tgDesperdicio with frame fPage0.
  end.
      
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
{utp/ut-liter.i "Classifica‡Æo"}
assign fiClassifica:screen-value in frame fPage0 = return-value.
{utp/ut-liter.i "Equipamento"}
assign fiTexto1:screen-value in frame fPage0 = return-value.
{utp/ut-liter.i "Exibe"}
assign fiTexto2:screen-value in frame fPage0 = return-value.
{utp/ut-liter.i "Ativos"}
assign tgAtivos:label in frame fPage0 = return-value.
{utp/ut-liter.i "Inativos"}
assign tgInativos:label in frame fPage0 = return-value.
{utp/ut-liter.i "Pr¢prios"}
assign tgProprios:label in frame fPage0 = return-value.
{utp/ut-liter.i "Terceiros"}
assign tgTerceiros:label in frame fPage0 = return-value.
{utp/ut-liter.i "Consumo OK"}
assign tgOK:label in frame fPage0 = return-value.
{utp/ut-liter.i "Consumo Irregular"}
assign tgIrregular:label in frame fPage0 = return-value.
{utp/ut-liter.i "Contador Secund rio"}
assign tgLogContSec:label in frame fPage0 = return-value.
{utp/ut-liter.i "Considerar Desperd¡cio"}
assign tgDesperdicio:label in frame fPage0 = return-value.

/** Busca Parƒmtros **/
find first ttSelecao no-lock no-error.
if avail ttSelecao then do:
    assign tgAtivos:checked       in frame fPage0 = ttSelecao.lAtivos         
           tgProprios:checked     in frame fPage0 = ttSelecao.lProprios       
           tgInativos:checked     in frame fPage0 = ttSelecao.lInativos       
           tgTerceiros:CHECKED    in frame fPage0 = ttSelecao.lTerceiros  
           tgOK:checked           in frame fPage0 = ttSelecao.lOK
           tgIrregular:checked    in frame fPage0 = ttSelecao.lIrregular          
           tgLogContSec:checked   in frame fPage0 = ttSelecao.lLogContSec
           tgDesperdicio:checked  in frame fPage0 = ttSelecao.lDesperdicio
           rs-classifica                          = ttSelecao.classificacao.
end.

disp rs-classifica with frame fPage0.

apply "VALUE-CHANGED":U to tgIrregular in frame fPage0.

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
    assign ttSelecao.lAtivos        = tgAtivos:checked      in frame fPage0    
           ttSelecao.lProprios      = tgProprios:checked    in frame fPage0    
           ttSelecao.lInativos      = tgInativos:checked    in frame fPage0    
           ttSelecao.lTerceiros     = tgTerceiros:checked   in frame fPage0
           ttSelecao.lOK            = tgOK:checked          in frame fPage0
           ttSelecao.lIrregular     = tgIrregular:checked   in frame fPage0        
           ttSelecao.lLogContSec    = tgLogContSec:checked  in frame fPage0
           ttSelecao.lDesperdicio   = tgDesperdicio:checked in frame fPage0
           ttSelecao.classificacao  = input frame fPage0 rs-classifica.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

