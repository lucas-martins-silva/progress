&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0101C1 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0101C1 MIM}
&ENDIF

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
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
&GLOBAL-DEFINE Program        IM0101C1

/*&GLOBAL-DEFINE WindowType     Master/Detail*/

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

{cxbo/bocx310a.i tt-desp-embarque}

/* Parameters Definitions ---                                           */

def input-output param cod-desp-ini     as int format ">>,>>9"    no-undo.
def input-output param cod-desp-fim     as int format ">>,>>9"    no-undo.
def input-output param fornec-desp-ini  as int format ">>>>>>>>9" no-undo.
def input-output param fornec-desp-fim  as int format ">>>>>>>>9" no-undo.
def input-output param pto-controle-ini as int format ">>,>>9"    no-undo.
def input-output param pto-controle-fim as int format ">>,>>9"    no-undo.
def output       param l-ok-c           as log                    no-undo.
def input        param table for tt-desp-embarque.

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
&Scoped-Define ENABLED-OBJECTS btOK btCancel btHelp2 rtToolBar 

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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 66 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE i-cod-desp-fim AS INTEGER FORMAT ">>,>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-desp-ini AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Cod Desp" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-desp-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-desp-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornec Desp" 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-pto-contr-fim AS INTEGER FORMAT ">>,>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-pto-contr-ini AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Ponto Controle" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-64
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-65
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-66
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-67
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65 BY 4.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 5.79 COL 2
     btCancel AT ROW 5.79 COL 13
     btHelp2 AT ROW 5.79 COL 55.86
     rtToolBar AT ROW 5.58 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 17
         FONT 1.

DEFINE FRAME fPage1
     i-cod-desp-ini AT ROW 1.5 COL 18.72 COLON-ALIGNED
     i-cod-desp-fim AT ROW 1.5 COL 40.43 COLON-ALIGNED NO-LABEL
     i-cod-emitente-desp-ini AT ROW 2.5 COL 18.57 COLON-ALIGNED
     i-cod-emitente-desp-fim AT ROW 2.5 COL 40.43 COLON-ALIGNED NO-LABEL
     i-cod-pto-contr-ini AT ROW 3.5 COL 18.57 COLON-ALIGNED
     i-cod-pto-contr-fim AT ROW 3.5 COL 40.43 COLON-ALIGNED NO-LABEL
     IMAGE-17 AT ROW 1.5 COL 38.14
     IMAGE-18 AT ROW 1.5 COL 32
     IMAGE-64 AT ROW 2.5 COL 38.14
     IMAGE-65 AT ROW 2.5 COL 32
     IMAGE-66 AT ROW 3.5 COL 38.14
     IMAGE-67 AT ROW 3.5 COL 32
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.43 ROW 1.08
         SIZE 65.57 BY 4.42
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
         HEIGHT             = 6.08
         WIDTH              = 66.43
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.96
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
    find first tt-desp-embarque
        where tt-desp-embarque.selecionado = yes no-error.
    if  avail tt-desp-embarque then do:
        run utp/ut-msgs.p (input "show":U,
                           input 29405,
                           input "":U).

        if  return-value = "NO" then do:
            apply "close":U to this-procedure.
            return no-apply.
        end.
    end.

    assign cod-desp-ini     = input frame fPage1 i-cod-desp-ini 
           cod-desp-fim     = input frame fPage1 i-cod-desp-fim
           fornec-desp-ini  = input frame fPage1 i-cod-emitente-desp-ini
           fornec-desp-fim  = input frame fPage1 i-cod-emitente-desp-fim
           pto-controle-ini = input frame fPage1 i-cod-pto-contr-ini
           pto-controle-fim = input frame fPage1 i-cod-pto-contr-fim
           l-ok-c           = yes.
    
    apply "close":U to this-procedure.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/MainBlock.i}

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
    {utp/ut-liter.i Cod_Desp * L}
    assign i-cod-desp-ini:label in frame fPage1 = trim(return-value).
    {utp/ut-liter.i Fornec_Desp * L}
    assign i-cod-emitente-desp-ini:label in frame fPage1 = trim(return-value).
    {utp/ut-liter.i Ponto_Controle * L}
    assign i-cod-pto-contr-ini:label in frame fPage1 = trim(return-value).

    enable i-cod-desp-ini
           i-cod-desp-fim
           i-cod-emitente-desp-ini
           i-cod-emitente-desp-fim
           i-cod-pto-contr-ini
           i-cod-pto-contr-fim
        with frame fPage1.
                                   
    assign i-cod-desp-ini:screen-value in frame fPage1          = string(cod-desp-ini)    
           i-cod-desp-fim:screen-value in frame fPage1          = string(cod-desp-fim)    
           i-cod-emitente-desp-ini:screen-value in frame fPage1 = string(fornec-desp-ini) 
           i-cod-emitente-desp-fim:screen-value in frame fPage1 = string(fornec-desp-fim) 
           i-cod-pto-contr-ini:screen-value in frame fPage1     = string(pto-controle-ini)
           i-cod-pto-contr-fim:screen-value in frame fPage1     = string(pto-controle-fim).

    apply "entry" to i-cod-desp-ini in frame fPage1.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

