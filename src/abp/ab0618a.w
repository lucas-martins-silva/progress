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
{include/i-prgvrs.i AB0618A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0618a MAB}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0618A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   d-dat-movto-ini d-dat-movto-fim ~
                              c-hra-inicial-ini c-hra-inicial-fim ~
                              i-num-docto-ini i-num-docto-fim ~
                              btOK btCancel btHelp

/* Parameters Definitions ---                                           */
def input-output parameter p-data-ini       as date format "99/99/9999" no-undo.
def input-output parameter p-data-fim       as date format "99/99/9999" no-undo.
def input-output parameter p-hora-ini       as char                     no-undo.
def input-output parameter p-hora-fim       as char                     no-undo.
def input-output parameter p-docto-ini      as integer                  no-undo. 
def input-output parameter p-docto-fim      as integer                  no-undo. 
def output       parameter l-alterou        as logical                  no-undo.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cHora-1      AS CHARACTER format "00:00:00" NO-UNDO.
DEFINE VARIABLE cHora-2      AS CHARACTER format "00:00:00" NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS d-dat-movto-ini d-dat-movto-fim ~
c-hra-inicial-ini c-hra-inicial-fim i-num-docto-ini i-num-docto-fim btOK ~
btCancel btHelp RECT-37 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS d-dat-movto-ini d-dat-movto-fim ~
c-hra-inicial-ini c-hra-inicial-fim i-num-docto-ini i-num-docto-fim 

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

DEFINE VARIABLE c-hra-inicial-fim AS CHARACTER FORMAT "99:99:99" INITIAL "235959" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-hra-inicial-ini AS CHARACTER FORMAT "99:99:99" INITIAL "000000" 
     LABEL "Hora":R5 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE d-dat-movto-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE d-dat-movto-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Data":R5 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-num-docto-fim AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-num-docto-ini AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Documento":R11 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-40
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-41
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-42
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-43
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-37
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58 BY 5.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 58 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     d-dat-movto-ini AT ROW 1.75 COL 12 COLON-ALIGNED HELP
          "Data do movimento de vida dos equipamento"
     d-dat-movto-fim AT ROW 1.75 COL 30 COLON-ALIGNED HELP
          "Data do movimento de vida dos equipamento" NO-LABEL
     c-hra-inicial-ini AT ROW 3 COL 12 COLON-ALIGNED HELP
          "Hora do movimento de vida dos equipamentos"
     c-hra-inicial-fim AT ROW 3 COL 30 COLON-ALIGNED HELP
          "Hora do movimento de vida dos equipamentos" NO-LABEL
     i-num-docto-ini AT ROW 4.5 COL 12 COLON-ALIGNED HELP
          "Documento de Abastecimento / Lubrifica‡Æo"
     i-num-docto-fim AT ROW 4.5 COL 30 COLON-ALIGNED HELP
          "Documento de Abastecimento / Lubrifica‡Æo" NO-LABEL
     btOK AT ROW 6.71 COL 1.86
     btCancel AT ROW 6.71 COL 12.86
     btHelp AT ROW 6.71 COL 48.57
     IMAGE-26 AT ROW 1.75 COL 24.57
     IMAGE-40 AT ROW 4.5 COL 24.57
     IMAGE-29 AT ROW 1.75 COL 29
     IMAGE-41 AT ROW 3 COL 24.57
     IMAGE-43 AT ROW 3 COL 29
     IMAGE-42 AT ROW 4.5 COL 29
     RECT-37 AT ROW 1 COL 1
     rtToolBar AT ROW 6.46 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.57 ROW 1
         SIZE 58 BY 6.96
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
         TITLE              = "Parƒmetros"
         HEIGHT             = 6.96
         WIDTH              = 58.57
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
   FRAME-NAME                                                           */
/* SETTINGS FOR IMAGE IMAGE-26 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE IMAGE-29 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE IMAGE-40 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE IMAGE-41 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE IMAGE-42 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE IMAGE-43 IN FRAME fpage0
   NO-ENABLE                                                            */
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
ON END-ERROR OF wWindow /* Parƒmetros */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Parƒmetros */
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
    assign l-alterou    = no.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
  ASSIGN p-data-ini   = input frame fPage0 d-dat-movto-ini   
         p-data-fim   = input frame fPage0 d-dat-movto-fim
         p-hora-ini   = input frame fPage0 c-hra-inicial-ini 
         p-hora-fim   = input frame fPage0 c-hra-inicial-fim 
         p-docto-ini  = input frame fPage0 i-num-docto-ini   
         p-docto-fim  = input frame fPage0 i-num-docto-fim   
         l-alterou    = yes.
         
  apply "CLOSE":U to this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-hra-inicial-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-inicial-fim wWindow
ON LEAVE OF c-hra-inicial-fim IN FRAME fpage0
DO:
  assign cHora-2 = c-hra-inicial-fim:screen-value in frame fPage0.
     run piFormataHorarioSeg (input-output cHora-2).
     if return-value = "NOK":U then do:
         apply "ENTRY":U to c-hra-inicial-fim in frame fPage0.
         return no-apply.
     end.
     assign c-hra-inicial-fim:screen-value in frame fPage0 = cHora-2. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-hra-inicial-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-inicial-ini wWindow
ON LEAVE OF c-hra-inicial-ini IN FRAME fpage0 /* Hora */
DO:
  assign cHora-1 = c-hra-inicial-ini:screen-value in frame fPage0.
     run piFormataHorarioSeg (input-output cHora-1).
     if return-value = "NOK":U then do:
         apply "ENTRY":U to c-hra-inicial-ini in frame fPage0.
         return no-apply.
     end.
     assign c-hra-inicial-ini:screen-value in frame fPage0 = cHora-1. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

{abp/ab9000.i} /** Procedures de conversÆo de tempo:
                   piFormataHoraParaSegundo
                   piFormataSegundoParaHora **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s inicializar a tela do programa
------------------------------------------------------------------------------*/
/** Labels em tela **/
{utp/ut-liter.i "Data"}
assign d-dat-movto-ini:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Hora"}
assign c-hra-inicial-ini:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Documento"}
assign i-num-docto-ini:label in frame fPage0 = trim(return-value).

/** Mostra ops valores atuais dos parƒmetros em tela **/
assign d-dat-movto-ini   = p-data-ini 
       d-dat-movto-fim   = p-data-fim 
       c-hra-inicial-ini = p-hora-ini 
       c-hra-inicial-fim = p-hora-fim 
       i-num-docto-ini   = p-docto-ini
       i-num-docto-fim   = p-docto-fim.
display d-dat-movto-ini  
        d-dat-movto-fim  
        c-hra-inicial-ini
        c-hra-inicial-fim
        i-num-docto-ini  
        i-num-docto-fim 
    with frame fPage0.

RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

