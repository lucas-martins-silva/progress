&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM7000D1 2.00.00.000 } /*** "010000" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM7000D1 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM7000D1
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   btOK btCancel
&GLOBAL-DEFINE page1Widgets   c-cod-estabel-ini c-cod-estabel-fim ~
                              c-embarque-ini c-embarque-fim ~
                              i-cod-emitente-ini i-cod-emitente-fim ~
                              c-nome-abrev-ini c-nome-abrev-fim
                              
/* Parameters Definitions ---                                           */                  
DEFINE INPUT-OUTPUT PARAMETER pc-cod-estabel-ini        LIKE duimp-item.cod-estabel NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-estabel-fim        LIKE duimp-item.cod-estabel NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-embarque-ini           LIKE duimp-item.embarque NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-embarque-fim           LIKE duimp-item.embarque NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-cod-emitente-ini       LIKE duimp-item.cod-emitente NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-cod-emitente-fim       LIKE duimp-item.cod-emitente NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-nome-abrev-ini         LIKE emitente.nome-abrev NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-nome-abrev-fim         LIKE emitente.nome-abrev NO-UNDO.
DEFINE OUTPUT       PARAMETER l-ok                      AS LOGICAL NO-UNDO.


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
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 62 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER FORMAT "X(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-embarque-fim AS CHARACTER FORMAT "X(16)" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-embarque-ini AS CHARACTER FORMAT "X(16)" 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev-fim AS CHARACTER FORMAT "X(12)" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "Nome Abrev" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-las":U
     SIZE 3 BY .88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 7.13 COL 3.14 HELP
          "Confirma Altera‡äes no Filtro"
     btCancel AT ROW 7.13 COL 14.14 HELP
          "Cancelar Altera‡äes no Filtro"
     rtToolBar AT ROW 6.92 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 7.5
         FONT 1
         DEFAULT-BUTTON btOK.

DEFINE FRAME fPage1
     c-cod-estabel-ini AT ROW 1.5 COL 17.57 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento Inicial da Faixa"
     c-cod-estabel-fim AT ROW 1.5 COL 37.43 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento Final da Faixa" NO-LABEL
     c-embarque-ini AT ROW 2.5 COL 11.57 COLON-ALIGNED HELP
          "C¢digo do Embarque Inicial da Faixa" WIDGET-ID 36
     c-embarque-fim AT ROW 2.5 COL 37.43 COLON-ALIGNED HELP
          "C¢digo do Embarque Final da Faixa" NO-LABEL WIDGET-ID 34
     i-cod-emitente-ini AT ROW 3.5 COL 17.57 COLON-ALIGNED HELP
          "C¢digo do Emitente Inicial da Faixa"
     i-cod-emitente-fim AT ROW 3.5 COL 37.43 COLON-ALIGNED HELP
          "C¢digo do Emitente Final da Faixa" NO-LABEL
     c-nome-abrev-ini AT ROW 4.5 COL 15.57 COLON-ALIGNED HELP
          "Nome Abreviado do Emitente Inicial da Faixa" WIDGET-ID 28
     c-nome-abrev-fim AT ROW 4.5 COL 37.43 COLON-ALIGNED HELP
          "Nome Abreviado do Emitente Final da Faixa" NO-LABEL WIDGET-ID 26
     IMAGE-1 AT ROW 1.5 COL 30.57
     IMAGE-2 AT ROW 1.5 COL 35.57
     IMAGE-4 AT ROW 4.5 COL 30.57
     IMAGE-6 AT ROW 2.5 COL 30.57
     IMAGE-9 AT ROW 4.5 COL 35.57
     IMAGE-11 AT ROW 2.5 COL 35.57
     IMAGE-13 AT ROW 3.5 COL 30.57 WIDGET-ID 8
     IMAGE-14 AT ROW 3.5 COL 35.57 WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 1.5
         SIZE 62 BY 4.9
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 7.5
         WIDTH              = 63.72
         MAX-HEIGHT         = 37.29
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 37.29
         VIRTUAL-WIDTH      = 182.86
         MIN-BUTTON         = no
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

    ASSIGN pc-cod-estabel-ini   = input frame fPage1 c-cod-estabel-ini       
           pc-cod-estabel-fim   = input frame fPage1 c-cod-estabel-fim       
           pi-cod-emitente-ini  = input frame fPage1 i-cod-emitente-ini      
           pi-cod-emitente-fim  = input frame fPage1 i-cod-emitente-fim      
           pc-nome-abrev-ini    = input frame fPage1 c-nome-abrev-ini        
           pc-nome-abrev-fim    = input frame fPage1 c-nome-abrev-fim        
           pc-embarque-ini      = input frame fPage1 c-embarque-ini        
           pc-embarque-fim      = input frame fPage1 c-embarque-fim
           l-ok                 = YES.

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
  Purpose:     Repassa os valores dos parƒmetros para os campos de tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-cod-estabel-ini:SCREEN-VALUE IN FRAME fPage1  = pc-cod-estabel-ini           
           c-embarque-ini:SCREEN-VALUE IN FRAME fPage1     = pc-embarque-ini
           c-embarque-fim:SCREEN-VALUE IN FRAME fPage1     = pc-embarque-fim  
           c-cod-estabel-fim:SCREEN-VALUE IN FRAME fPage1  = pc-cod-estabel-fim
           i-cod-emitente-ini:SCREEN-VALUE IN FRAME fPage1 = string(pi-cod-emitente-ini)      
           i-cod-emitente-fim:SCREEN-VALUE IN FRAME fPage1 = string(pi-cod-emitente-fim)      
           c-nome-abrev-ini:SCREEN-VALUE IN FRAME fPage1   = pc-nome-abrev-ini
           c-nome-abrev-fim:SCREEN-VALUE IN FRAME fPage1   = pc-nome-abrev-fim.

    DISABLE c-cod-estabel-ini c-cod-estabel-fim WITH FRAME fPage1.          
           
    APPLY "ENTRY":U TO c-embarque-ini IN FRAME fPage1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

