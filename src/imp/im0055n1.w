&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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
{include/i-prgvrs.i IM0055N1 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0055N1 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0055N1
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   btOK btCancel
&GLOBAL-DEFINE page1Widgets   c-cod-estabel-ini c-cod-estabel-fim ~
                              i-cdn-emitente-ini i-cdn-emitente-fim ~
                              d-dat-transacao-ini d-dat-transacao-fim ~
                              c-cod-especie-ini c-cod-especie-fim ~
                              c-cod-serie-ini c-cod-serie-fim ~
                              c-cod-tit-ap-ini c-cod-tit-ap-fim ~
/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER pc-cod-estabel-ini   LIKE estabelec.cod-estabel NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-estabel-fim   LIKE estabelec.cod-estabel NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-cdn-emitente-ini  LIKE emitente.cod-emitente NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-cdn-emitente-fim  LIKE emitente.cod-emitente NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pd-dat-transacao-ini AS DATE                    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pd-dat-transacao-fim AS DATE                    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-especie-ini   AS CHARACTER               NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-especie-fim   AS CHARACTER               NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-serie-ini     AS CHARACTER               NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-serie-fim     AS CHARACTER               NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-tit-ap-ini    AS CHARACTER               NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-tit-ap-fim    AS CHARACTER               NO-UNDO.
DEFINE OUTPUT       PARAMETER l-ok                 AS LOGICAL                 NO-UNDO.

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
     SIZE 55 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-cod-especie-fim AS CHARACTER FORMAT "X(3)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-especie-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini LIKE estabelec.cod-estabel
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-serie-fim AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-serie-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-tit-ap-fim AS CHARACTER FORMAT "X(16)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-tit-ap-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "T¡tulo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-dat-transacao-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE d-dat-transacao-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-emitente-fim LIKE emitente.cod-emitente
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-emitente-ini LIKE emitente.cod-emitente
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-las":U
     SIZE 3 BY .88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 9 COL 3.14 HELP
          "Confirma Altera‡äes no Filtro"
     btCancel AT ROW 9 COL 14.14 HELP
          "Cancelar Altera‡äes no Filtro"
     rtToolBar AT ROW 8.79 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.71
         FONT 1
         DEFAULT-BUTTON btOK.

DEFINE FRAME fPage1
     c-cod-estabel-ini AT ROW 1.54 COL 13.86 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento Inicial da Faixa" 
          LABEL "Estabelecimento" FORMAT "X(5)"
     c-cod-estabel-fim AT ROW 1.54 COL 33.72 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento Final da Faixa" NO-LABEL FORMAT "x(5)"
     i-cdn-emitente-ini AT ROW 2.54 COL 13.86 COLON-ALIGNED HELP
          "C¢digo do Emitente Inicial da Faixa" 
          LABEL "Emitente" FORMAT ">>>>>>>>9"
     i-cdn-emitente-fim AT ROW 2.54 COL 33.72 COLON-ALIGNED HELP
          "C¢digo do Emitente Final da Faixa" NO-LABEL FORMAT ">>>>>>>>9"
     d-dat-transacao-ini AT ROW 3.54 COL 13.86 COLON-ALIGNED HELP
          "Data de Transa‡Æo Inicial da Faixa" 
     d-dat-transacao-fim AT ROW 3.54 COL 33.72 COLON-ALIGNED HELP
          "Data de Transa‡Æo Final da Faixa" NO-LABEL 
     c-cod-especie-ini AT ROW 4.54 COL 13.86 COLON-ALIGNED HELP
          "C¢digo da Esp‚cie de Antecipa‡Æo Inicial da Faixa" 
     c-cod-especie-fim AT ROW 4.54 COL 33.72 COLON-ALIGNED HELP
          "C¢digo da Esp‚cie de Antecipa‡Æo Final da Faixa" NO-LABEL 
     c-cod-serie-ini AT ROW 5.54 COL 13.86 COLON-ALIGNED HELP
          "C¢digo da S‚rie Inicial da Faixa" 
     c-cod-serie-fim AT ROW 5.54 COL 33.72 COLON-ALIGNED HELP
          "C¢digo da S‚rie Final da Faixa" NO-LABEL 
     c-cod-tit-ap-ini AT ROW 6.54 COL 7.86 COLON-ALIGNED HELP
          "C¢digo do T¡tulo Inicial da Faixa" 
     c-cod-tit-ap-fim AT ROW 6.54 COL 33.72 COLON-ALIGNED HELP
          "C¢digo do T¡tulo Final da Faixa" NO-LABEL 
     IMAGE-1 AT ROW 1.54 COL 26.86 
     IMAGE-2 AT ROW 1.54 COL 31.86 
     IMAGE-3 AT ROW 2.54 COL 26.86 
     IMAGE-4 AT ROW 3.54 COL 26.86 
     IMAGE-5 AT ROW 4.54 COL 26.86 
     IMAGE-6 AT ROW 5.54 COL 26.86 
     IMAGE-7 AT ROW 6.54 COL 26.86 
     IMAGE-8 AT ROW 2.54 COL 31.86 
     IMAGE-9 AT ROW 3.54 COL 31.86 
     IMAGE-10 AT ROW 4.54 COL 31.86 
     IMAGE-11 AT ROW 5.54 COL 31.86 
     IMAGE-12 AT ROW 6.54 COL 31.86 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 1.5
         SIZE 55 BY 7
         FONT 1 .


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
         HEIGHT             = 9.42
         WIDTH              = 57.43
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
   Custom                                                               */
/* SETTINGS FOR FILL-IN c-cod-estabel-fim IN FRAME fPage1
   LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-FORMAT EXP-HELP EXP-SIZE */
/* SETTINGS FOR FILL-IN c-cod-estabel-ini IN FRAME fPage1
   LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-FORMAT EXP-HELP EXP-SIZE */
/* SETTINGS FOR FILL-IN i-cdn-emitente-fim IN FRAME fPage1
   LIKE = mgcad.emitente.cod-emitente EXP-LABEL EXP-FORMAT EXP-HELP EXP-SIZE */
/* SETTINGS FOR FILL-IN i-cdn-emitente-ini IN FRAME fPage1
   LIKE = mgcad.emitente.cod-emitente EXP-LABEL EXP-FORMAT EXP-HELP EXP-SIZE */
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
           pi-cdn-emitente-ini  = input frame fPage1 i-cdn-emitente-ini 
           pi-cdn-emitente-fim  = input frame fPage1 i-cdn-emitente-fim 
           pd-dat-transacao-ini = input frame fPage1 d-dat-transacao-ini
           pd-dat-transacao-fim = input frame fPage1 d-dat-transacao-fim
           pc-cod-especie-ini   = input frame fPage1 c-cod-especie-ini  
           pc-cod-especie-fim   = input frame fPage1 c-cod-especie-fim  
           pc-cod-serie-ini     = input frame fPage1 c-cod-serie-ini    
           pc-cod-serie-fim     = input frame fPage1 c-cod-serie-fim    
           pc-cod-tit-ap-ini    = input frame fPage1 c-cod-tit-ap-ini   
           pc-cod-tit-ap-fim    = input frame fPage1 c-cod-tit-ap-fim
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-cod-estabel-ini:SCREEN-VALUE IN FRAME fpage1   = pc-cod-estabel-ini  
           c-cod-estabel-fim:SCREEN-VALUE IN FRAME fpage1   = pc-cod-estabel-fim  
           i-cdn-emitente-ini:SCREEN-VALUE IN FRAME fpage1  = STRING(pi-cdn-emitente-ini) 
           i-cdn-emitente-fim:SCREEN-VALUE IN FRAME fpage1  = STRING(pi-cdn-emitente-fim) 
           d-dat-transacao-ini:SCREEN-VALUE IN FRAME fpage1 = STRING(pd-dat-transacao-ini)
           d-dat-transacao-fim:SCREEN-VALUE IN FRAME fpage1 = STRING(pd-dat-transacao-fim)
           c-cod-especie-ini:SCREEN-VALUE IN FRAME fpage1   = pc-cod-especie-ini  
           c-cod-especie-fim:SCREEN-VALUE IN FRAME fpage1   = pc-cod-especie-fim  
           c-cod-serie-ini:SCREEN-VALUE IN FRAME fpage1     = pc-cod-serie-ini    
           c-cod-serie-fim:SCREEN-VALUE IN FRAME fpage1     = pc-cod-serie-fim    
           c-cod-tit-ap-ini:SCREEN-VALUE IN FRAME fpage1    = pc-cod-tit-ap-ini   
           c-cod-tit-ap-fim:SCREEN-VALUE IN FRAME fpage1    = pc-cod-tit-ap-fim.   


    APPLY "ENTRY":U TO c-cod-estabel-ini IN FRAME fPage1.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

