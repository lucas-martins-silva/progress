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
{include/i-prgvrs.i IM0041A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0041A MIM}
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
&GLOBAL-DEFINE Program        IM0041A
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 

/* Parameters Definitions ---                                           */
define input-output  parameter piNumeroOrdemIni          like ordem-compra.numero-ordem          no-undo.
define input-output  parameter piNumeroOrdemFim          like ordem-compra.numero-ordem          no-undo.
define input-output  parameter pcItCodigoIni             like item.it-codigo                     no-undo.
define input-output  parameter pcItCodigoFim             like item.it-codigo                     no-undo.
define input-output  parameter pcClassFiscalIni          like item.class-fiscal                  no-undo.
define input-output  parameter pcClassFiscalFim          like item.class-fiscal                  no-undo.
define input-output  parameter pcNrLiIni                 like licenciam-import-oc.licenca-import no-undo.
define input-output  parameter pcNrLiFim                 like licenciam-import-oc.licenca-import no-undo.
define input-output  parameter plEliminadas              as   logical                            no-undo.
define input-output  parameter plRecebidas               as   logical                            no-undo.
define output        parameter lOk                       as   logical                            no-undo.


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
&Scoped-Define ENABLED-OBJECTS iNumeroOrdemIni iNumeroOrdemFim cItCodigoIni ~
cItCodigoFim cClassFiscalIni cClassFiscalFim cNrLiIni cNrLiFim lEliminadas ~
lRecebidas btOK btCancel btHelp2 IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 ~
IMAGE-6 IMAGE-7 IMAGE-8 RECT-4 RECT-5 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS iNumeroOrdemIni iNumeroOrdemFim ~
cItCodigoIni cItCodigoFim cClassFiscalIni cClassFiscalFim cNrLiIni cNrLiFim ~
lEliminadas lRecebidas 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 iNumeroOrdemIni iNumeroOrdemFim cItCodigoIni ~
cItCodigoFim cClassFiscalIni cClassFiscalFim cNrLiIni cNrLiFim lEliminadas ~
lRecebidas 

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

DEFINE VARIABLE cClassFiscalFim AS CHARACTER FORMAT "9999.99.99":U INITIAL "99999999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE cClassFiscalIni AS CHARACTER FORMAT "9999.99.99":U 
     LABEL "Classifica‡Æo Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE cItCodigoFim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE cItCodigoIni AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE cNrLiFim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE cNrLiIni AS CHARACTER FORMAT "X(20)":U 
     LABEL "Nr LI" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE iNumeroOrdemFim AS INTEGER FORMAT ">>>>>9,99":U INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE iNumeroOrdemIni AS INTEGER FORMAT ">>>>>9,99":U INITIAL 0 
     LABEL "Ordem de Compra" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 76 BY 4.75.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 76 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 76 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE lEliminadas AS LOGICAL INITIAL no 
     LABEL "Parcelas Eliminadas" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE lRecebidas AS LOGICAL INITIAL no 
     LABEL "Parcelas Recebidas" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     iNumeroOrdemIni AT ROW 1.5 COL 14.14 COLON-ALIGNED HELP
          "Ordem de Compra"
     iNumeroOrdemFim AT ROW 1.5 COL 47.43 COLON-ALIGNED HELP
          "Ordem de Compra" NO-LABEL
     cItCodigoIni AT ROW 2.5 COL 14.14 COLON-ALIGNED HELP
          "C¢digo do Item"
     cItCodigoFim AT ROW 2.5 COL 47.43 COLON-ALIGNED HELP
          "C¢digo do Item" NO-LABEL
     cClassFiscalIni AT ROW 3.5 COL 14.14 COLON-ALIGNED HELP
          "Classifica‡Æo Fiscal"
     cClassFiscalFim AT ROW 3.5 COL 47.43 COLON-ALIGNED HELP
          "Classifica‡Æo Fiscal" NO-LABEL
     cNrLiIni AT ROW 4.5 COL 14.14 COLON-ALIGNED HELP
          "N£mero da Licen‡a de Importa‡Æo"
     cNrLiFim AT ROW 4.5 COL 47.43 COLON-ALIGNED HELP
          "N£mero da Licen‡a de Importa‡Æo" NO-LABEL
     lEliminadas AT ROW 6.83 COL 16.14 HELP
          "Disponibiliza Parcelas Eliminadas"
     lRecebidas AT ROW 6.83 COL 43.71 HELP
          "Disponibiliza Parcelas Recebidas"
     btOK AT ROW 8.63 COL 2
     btCancel AT ROW 8.63 COL 13
     btHelp2 AT ROW 8.63 COL 66
     IMAGE-1 AT ROW 4.5 COL 40
     IMAGE-2 AT ROW 4.5 COL 45.43
     IMAGE-3 AT ROW 3.5 COL 40
     IMAGE-4 AT ROW 3.5 COL 45.43
     IMAGE-5 AT ROW 2.5 COL 40
     IMAGE-6 AT ROW 2.5 COL 45.43
     IMAGE-7 AT ROW 1.5 COL 40
     IMAGE-8 AT ROW 1.5 COL 45.43
     RECT-4 AT ROW 1 COL 1
     RECT-5 AT ROW 5.96 COL 1
     rtToolBar AT ROW 8.38 COL 1
     "Disponibiliza" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 5.79 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.08
         SIZE 76.29 BY 9
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
         HEIGHT             = 9.04
         WIDTH              = 76
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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
/* SETTINGS FOR FILL-IN cClassFiscalFim IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN cClassFiscalIni IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN cItCodigoFim IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN cItCodigoIni IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN cNrLiFim IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN cNrLiIni IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN iNumeroOrdemFim IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN iNumeroOrdemIni IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR TOGGLE-BOX lEliminadas IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR TOGGLE-BOX lRecebidas IN FRAME fpage0
   1                                                                    */
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
    assign lOk = no.
    apply "CLOSE":U to this-procedure.
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

    assign cClassFiscalIni:format in frame fPage0 = "x(8)"
           cClassFiscalFim:format in frame fPage0 = "x(8)".

    assign piNumeroOrdemIni = input frame fPage0 iNumeroOrdemIni
           piNumeroOrdemFim = input frame fPage0 iNumeroOrdemFim
           pcItCodigoIni    = input frame fPage0 cItCodigoIni   
           pcItCodigoFim    = input frame fPage0 cItCodigoFim   
           pcClassFiscalIni = input frame fPage0 cClassFiscalIni
           pcClassFiscalFim = input frame fPage0 cClassFiscalFim
           pcNrLiIni        = input frame fPage0 cNrLiIni       
           pcNrLiFim        = input frame fPage0 cNrLiFim       
           plEliminadas     = input frame fPage0 lEliminadas    
           plRecebidas      = input frame fPage0 lRecebidas     
           lOk              = yes.

    apply "CLOSE":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cClassFiscalFim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cClassFiscalFim wWindow
ON ENTRY OF cClassFiscalFim IN FRAME fpage0
DO:
    assign cClassFiscalFim:format in frame fPage0 = "9999.99.99".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cClassFiscalFim wWindow
ON LEAVE OF cClassFiscalFim IN FRAME fpage0
DO:
   define variable cFormat as character no-undo.

   assign cFormat = input frame fPage0 cClassFiscalFim no-error.
   if  error-status:error then
       assign cClassFiscalFim:format in frame fPage0 = "x(8)".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cClassFiscalIni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cClassFiscalIni wWindow
ON ENTRY OF cClassFiscalIni IN FRAME fpage0 /* Classifica‡Æo Fiscal */
DO:
    assign cClassFiscalIni:format in frame fPage0 = "9999.99.99".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cClassFiscalIni wWindow
ON LEAVE OF cClassFiscalIni IN FRAME fpage0 /* Classifica‡Æo Fiscal */
DO:
   define variable cFormat as character no-undo.

   assign cFormat = input frame fPage0 cClassFiscalIni no-error.
   if  error-status:error then
       assign cClassFiscalIni:format in frame fPage0 = "x(8)".

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
    enable {&list-1} with frame fPage0.

    assign iNumeroOrdemIni = piNumeroOrdemIni  
           iNumeroOrdemFim = piNumeroOrdemFim  
           cItCodigoIni    = pcItCodigoIni     
           cItCodigoFim    = pcItCodigoFim     
           cClassFiscalIni = pcClassFiscalIni  
           cClassFiscalFim = pcClassFiscalFim  
           cNrLiIni        = pcNrLiIni         
           cNrLiFim        = pcNrLiFim         
           lEliminadas     = plEliminadas      
           lRecebidas      = plRecebidas.

    display {&list-1} with frame fPage0.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

