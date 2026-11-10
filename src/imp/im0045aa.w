&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0045AA 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0045AA MIM}
&ENDIF

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
define input  parameter p-numero-ordem like ordem-compra.numero-ordem no-undo.
define input  parameter p-it-codigo    like item.it-codigo            no-undo.
define input  parameter p-quantidade   like prazo-compra.quantidade   no-undo.
define input  parameter p-un-nossa     like item.un                       no-undo.
define input  parameter p-quantidade-fornec like prazo-compra.qtd-do-forn no-undo.
define input  parameter p-un-fornec    like cotacao-item.un               no-undo.
define output parameter p-quant-embarq like prazo-compra.quantidade   no-undo.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS de-quantidade btOK btCancel btHelp RECT-1 ~
rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS i-numero-ordem c-it-codigo de-quantidade ~
c-un-nossa de-quantidade-fornec c-un-fornec 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-fornec AS CHARACTER FORMAT "X(2)":U 
     LABEL "Un Fornec" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-nossa AS CHARACTER FORMAT "X(2)":U 
     LABEL "Un" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-quantidade AS DECIMAL FORMAT ">>>>>,>>9.9999":U INITIAL 0 
     LABEL "Nossa Qtde" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-quantidade-fornec AS DECIMAL FORMAT "->>>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtde Fornec" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-numero-ordem AS INTEGER FORMAT ">>>>>9,99":U INITIAL 0 
     LABEL "Ordem" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89.29 BY 4.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89.72 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     i-numero-ordem AT ROW 1.25 COL 35 COLON-ALIGNED
     c-it-codigo AT ROW 2.25 COL 35 COLON-ALIGNED
     de-quantidade AT ROW 3.25 COL 35 COLON-ALIGNED
     c-un-nossa AT ROW 3.25 COL 56.86 COLON-ALIGNED
     de-quantidade-fornec AT ROW 4.25 COL 35 COLON-ALIGNED
     c-un-fornec AT ROW 4.25 COL 56.86 COLON-ALIGNED
     btOK AT ROW 5.75 COL 2
     btCancel AT ROW 5.75 COL 13
     btHelp AT ROW 5.75 COL 79.86
     RECT-1 AT ROW 1 COL 1
     rtToolBar AT ROW 5.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.72 BY 6.04
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Quantidade Ordem de Compra - IM0045AA - 2.00.00.003"
         HEIGHT             = 6.04
         WIDTH              = 89.72
         MAX-HEIGHT         = 20.96
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 20.96
         VIRTUAL-WIDTH      = 114.29
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-fornec IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-nossa IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-quantidade-fornec IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-numero-ordem IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Quantidade Ordem de Compra - IM0045AA - 2.00.00.003 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Quantidade Ordem de Compra - IM0045AA - 2.00.00.003 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME DEFAULT-FRAME /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp C-Win
ON CHOOSE OF btHelp IN FRAME DEFAULT-FRAME /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME DEFAULT-FRAME /* OK */
DO:
    assign input frame {&FRAME-NAME} de-quantidade.
    
    assign p-quant-embarq = de-quantidade.
   
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-quantidade C-Win
ON LEAVE OF de-quantidade IN FRAME DEFAULT-FRAME /* Nossa Qtde */
DO:
  FOR FIRST ordem-compra fields(cod-emitente) 
      WHERE ordem-compra.numero-ordem = int(i-numero-ordem:SCREEN-VALUE IN FRAME default-frame) NO-LOCK: END.

  IF AVAIL ordem-compra THEN DO:
      FIND FIRST item-fornec WHERE item-fornec.it-codigo    = c-it-codigo:SCREEN-VALUE IN FRAME default-frame
                             AND   item-fornec.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.  
      IF AVAIL item-fornec THEN DO:
          ASSIGN de-quantidade-fornec:SCREEN-VALUE IN FRAME default-frame = 
                                                     string(int(de-quantidade:SCREEN-VALUE IN FRAME default-frame)
                                                                * (item-fornec.fator-conver /
                                                                IF item-fornec.num-casa-dec = 0 THEN 1
                                                                    ELSE EXP(10, item-fornec.num-casa-dec))).
      END.
      ELSE
          ASSIGN de-quantidade-fornec:SCREEN-VALUE IN FRAME default-frame = de-quantidade:SCREEN-VALUE IN FRAME default-frame.
  END.
  ELSE
      ASSIGN de-quantidade-fornec:SCREEN-VALUE IN FRAME default-frame = de-quantidade:SCREEN-VALUE IN FRAME default-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

    assign i-numero-ordem       = p-numero-ordem
           c-it-codigo          = p-it-codigo
           de-quantidade        = p-quantidade
           c-un-nossa           = p-un-nossa
           de-quantidade-fornec = p-quantidade-fornec
           c-un-fornec          = p-un-fornec.
           
    display i-numero-ordem
            c-it-codigo
            de-quantidade
            c-un-nossa
            de-quantidade-fornec
            c-un-fornec
            with frame {&FRAME-NAME}.            

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY i-numero-ordem c-it-codigo de-quantidade c-un-nossa 
          de-quantidade-fornec c-un-fornec 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE de-quantidade btOK btCancel btHelp RECT-1 rtToolBar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

