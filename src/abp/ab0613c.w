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
{include/i-prgvrs.i AB0613C 2.00.00.002}  /*** 010002 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0613c MAB}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0613C
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType    Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              tgAtivos tgProprios tgInativos tgMotor ~
                              tgAntes tgDentro tgApos tgNMotor tgTerceiros ~
                              tgComp tgFiltro rsTipo

{abp/ab0613.i} /** Defini‡Æo da ttSelecao **/

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
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 rtToolBar tgMotor ~
tgNMotor tgAtivos tgInativos tgProprios tgTerceiros tgComp tgFiltro tgOutro ~
rsTipo tgAntes tgDentro tgApos btOK btCancel btHelp2 fiTexto1 fiTexto3 ~
fiTexto2 
&Scoped-Define DISPLAYED-OBJECTS tgMotor tgNMotor tgAtivos tgInativos ~
tgProprios tgTerceiros tgComp tgFiltro tgOutro rsTipo tgAntes tgDentro ~
tgApos fiTexto1 fiTexto3 fiTexto2 

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

DEFINE VARIABLE fiTexto1 AS CHARACTER FORMAT "X(256)":U INITIAL "Equipamentos" 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto2 AS CHARACTER FORMAT "X(256)":U INITIAL "Eventos" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fiTexto3 AS CHARACTER FORMAT "X(256)":U INITIAL "Analisar" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE rsTipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Compartivo Real x PadrÆo", 1,
"Quantidade e Valor", 2
     SIZE 24 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48.57 BY 3.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48.57 BY 3.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48.57 BY 2.88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 50 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tgAntes AS LOGICAL INITIAL no 
     LABEL "Antes Prazo" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tgApos AS LOGICAL INITIAL no 
     LABEL "Ap¢s Prazo" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tgAtivos AS LOGICAL INITIAL no 
     LABEL "Ativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE tgComp AS LOGICAL INITIAL no 
     LABEL "Compartimentos" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tgDentro AS LOGICAL INITIAL no 
     LABEL "Dentro Prazo" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tgFiltro AS LOGICAL INITIAL no 
     LABEL "Filtros" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgInativos AS LOGICAL INITIAL no 
     LABEL "Inativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.14 BY .83 NO-UNDO.

DEFINE VARIABLE tgMotor AS LOGICAL INITIAL no 
     LABEL "Motorizados" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE tgNMotor AS LOGICAL INITIAL no 
     LABEL "NÆo Motorizados" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE tgOutro AS LOGICAL INITIAL no 
     LABEL "Outros Eventos" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

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
     tgMotor AT ROW 2 COL 7
     tgNMotor AT ROW 2 COL 25
     tgAtivos AT ROW 3 COL 7
     tgInativos AT ROW 3 COL 25
     tgProprios AT ROW 4 COL 7
     tgTerceiros AT ROW 4 COL 25
     tgComp AT ROW 6 COL 7
     tgFiltro AT ROW 6 COL 25
     tgOutro AT ROW 7 COL 7
     rsTipo AT ROW 8.96 COL 25 NO-LABEL
     tgAntes AT ROW 9.25 COL 7
     tgDentro AT ROW 10.25 COL 7
     tgApos AT ROW 11.25 COL 7
     btOK AT ROW 12.83 COL 2
     btCancel AT ROW 12.83 COL 13
     btHelp2 AT ROW 12.83 COL 40
     fiTexto1 AT ROW 1.25 COL 2 COLON-ALIGNED NO-LABEL
     fiTexto3 AT ROW 5.13 COL 2 COLON-ALIGNED NO-LABEL
     fiTexto2 AT ROW 8.46 COL 2 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1.5 COL 1.57
     RECT-2 AT ROW 8.75 COL 1.57
     RECT-3 AT ROW 5.38 COL 1.57
     rtToolBar AT ROW 12.63 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 50 BY 13.21
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
         HEIGHT             = 13.21
         WIDTH              = 50
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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


&Scoped-define SELF-NAME rsTipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsTipo wWindow
ON VALUE-CHANGED OF rsTipo IN FRAME fpage0
DO:
    if input rstipo  = 1 then do:
        assign tgAntes  = true               
               tgDentro = true
               tgApos   = true.
        display tgAntes  
                tgDentro 
                tgApos with frame fpage0.
        assign tgAntes:sensitive  = true
               tgDentro:sensitive = true
               tgApos:sensitive   = true.
        
        ASSIGN tgOutro:SENSITIVE IN FRAME fPage0 = NO.
        ASSIGN tgOutro:CHECKED IN FRAME fPage0 = FALSE.

    end.
    if input rstipo  = 2 then do:
       assign tgAntes  = false
              tgDentro = false
              tgApos   = false.

       assign tgAntes:sensitive  = false
              tgDentro:sensitive = false
              tgApos:sensitive   = false.

       ASSIGN tgOutro:SENSITIVE IN FRAME fPage0 = YES.
       ASSIGN tgOutro = FALSE.

       display tgAntes  
               tgDentro 
               tgApos with frame fpage0.

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
{utp/ut-liter.i "Equipamento"}
assign fiTexto1:screen-value in frame fPage0 = return-value.
{utp/ut-liter.i "Eventos"}
assign fiTexto2:screen-value in frame fPage0 = return-value.
{utp/ut-liter.i "Analisar"}
assign fiTexto3:screen-value in frame fPage0 = return-value.
{utp/ut-liter.i "Ativos"}
assign tgAtivos:label in frame fPage0 = return-value.
{utp/ut-liter.i "Inativos"}
assign tgInativos:label in frame fPage0 = return-value.
{utp/ut-liter.i "Pr¢prios"}
assign tgProprios:label in frame fPage0 = return-value.
{utp/ut-liter.i "Terceiros"}
assign tgTerceiros:label in frame fPage0 = return-value.
{utp/ut-liter.i "Motorizados"}
assign tgMotor:label in frame fPage0 = return-value.
{utp/ut-liter.i "NÆo Motorizados"}
assign tgNMotor:label in frame fPage0 = return-value.
{utp/ut-liter.i "Antes Prazo"}
assign tgAntes:label in frame fPage0 = return-value.
{utp/ut-liter.i "Dentro Prazo"}
assign tgDentro:label in frame fPage0 = return-value.
{utp/ut-liter.i "Ap¢s Prazo"}
assign tgApos:label in frame fPage0 = return-value.
{utp/ut-liter.i "Compartimentos"}
assign tgComp:label in frame fPage0 = return-value.
{utp/ut-liter.i "Filtros"}
assign tgFiltro:label in frame fPage0 = return-value.
{utp/ut-liter.i "Outros Eventos"}
assign tgOutro:label in frame fPage0 = return-value.

/** Busca Parƒmtros **/
find first ttSelecao no-lock no-error.
if avail ttSelecao then do:
    assign tgAtivos:checked      in frame fPage0 = ttSelecao.lAtivos         
           tgProprios:checked    in frame fPage0 = ttSelecao.lProprios       
           tgInativos:checked    in frame fPage0 = ttSelecao.lInativos       
           tgTerceiros:checked   in frame fPage0 = ttSelecao.lTerceiros  
           tgMotor:checked       in frame fPage0 = ttSelecao.lMotor
           tgNMotor:checked      in frame fPage0 = ttSelecao.lNMotor          
           tgAntes:checked       in frame fPage0 = ttSelecao.lAntes
           tgDentro:checked      in frame fPage0 = ttSelecao.lDentro
           tgApos:checked        in frame fPage0 = ttSelecao.lApos
           tgComp:checked        in frame fPage0 = ttSelecao.lComp
           tgOutro:checked       in frame fPage0 = ttSelecao.lOutro
           tgFiltro:checked      in frame fPage0 = ttSelecao.lFiltro
           rsTipo                                = ttSelecao.lTipo.
    display rsTipo with frame fPage0.
end.
IF rsTipo = 1 THEN
    ASSIGN tgOutro:SENSITIVE IN FRAME fPage0 = NO.
ELSE
   ASSIGN tgOutro:SENSITIVE IN FRAME fPage0 = YES.
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

do with frame fPage0:
    assign rsTipo.
end.

find first ttSelecao exclusive-lock no-error.
if avail ttSelecao then do:
    assign ttSelecao.lAtivos    = tgAtivos:checked      in frame fPage0      
           ttSelecao.lProprios  = tgProprios:checked    in frame fPage0      
           ttSelecao.lInativos  = tgInativos:checked    in frame fPage0      
           ttSelecao.lTerceiros = tgTerceiros:checked   in frame fPage0  
           ttSelecao.lMotor     = tgMotor:checked       in frame fPage0
           ttSelecao.lNMotor    = tgNMotor:checked      in frame fPage0       
           ttSelecao.lAntes     = tgAntes:checked       in frame fPage0
           ttSelecao.lDentro    = tgDentro:checked      in frame fPage0
           ttSelecao.lApos      = tgApos:checked        in frame fPage0
           ttSelecao.lComp      = tgComp:checked        in frame fPage0
           ttSelecao.lFiltro    = tgFiltro:checked      in frame fPage0
           ttSelecao.lOutro     = tgOutro:CHECKED       IN FRAME fPage0
           ttSelecao.lTipo      = rsTipo.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

