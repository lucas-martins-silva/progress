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
{include/i-prgvrs.i IM0044AA 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0044AA MIM}
&ENDIF

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
define input  parameter p-numero-ordem like ordem-compra.numero-ordem  no-undo.
define input  parameter p-it-codigo    like ordem-compra.it-codigo     no-undo.
define input  parameter p-quantidade   like prazo-compra.quantidade    no-undo.
define input  parameter p-qt-do-forn   like ordens-embarque.qt-do-forn no-undo.
define input  parameter p-cod-fornec   like emitente.cod-emitente      no-undo.
define input  parameter p-un-fornec    like item.un                    no-undo.
define input  parameter p-un-nosso     like item.un                    no-undo.
define output parameter p-quant-embarq like prazo-compra.quantidade    no-undo.

/* Local Variable Definitions ---                                       */


DEFINE VARIABLE c-return  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE de-fator-conver AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-num-casa-dec AS DECIMAL    NO-UNDO.
DEFINE VARIABLE c-cod-fornec like cotacao-item.cod-emitente.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS de-quantidade btOK btCancel btHelp RECT-1 ~
rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS i-numero-ordem c-it-codigo de-quantidade ~
c-un-nosso de-quantidade-f c-un-fornec 

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

DEFINE VARIABLE c-un-fornec LIKE cotacao-item.un
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-nosso LIKE item.un
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE VARIABLE de-quantidade AS DECIMAL FORMAT ">>>>>,>>9.9999":U INITIAL 0 
     LABEL "Nossa Qtde" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-quantidade-f AS DECIMAL FORMAT ">>>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtde Fornec" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-numero-ordem AS INTEGER FORMAT ">>>>>9,99":U INITIAL 0 
     LABEL "Ordem" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 51.29 BY 4.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 51.14 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     i-numero-ordem AT ROW 1.17 COL 20 COLON-ALIGNED
     c-it-codigo AT ROW 2.17 COL 20 COLON-ALIGNED
     de-quantidade AT ROW 3.17 COL 20 COLON-ALIGNED
     c-un-nosso AT ROW 3.17 COL 33 COLON-ALIGNED NO-LABEL
     de-quantidade-f AT ROW 4.17 COL 20 COLON-ALIGNED
     c-un-fornec AT ROW 4.17 COL 33 COLON-ALIGNED NO-LABEL
     btOK AT ROW 5.54 COL 2
     btCancel AT ROW 5.54 COL 13
     btHelp AT ROW 5.54 COL 41.14
     RECT-1 AT ROW 1 COL 1
     rtToolBar AT ROW 5.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 51.43 BY 5.92
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
         TITLE              = "Quantidade Ordem de Compra - IM0044AA - 2.00.00.000"
         HEIGHT             = 5.83
         WIDTH              = 51.57
         MAX-HEIGHT         = 20.96
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 20.96
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
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
   NO-ENABLE LIKE = movind.cotacao-item.un EXP-LABEL EXP-SIZE           */
/* SETTINGS FOR FILL-IN c-un-nosso IN FRAME DEFAULT-FRAME
   NO-ENABLE LIKE = mgind.item.un EXP-LABEL EXP-SIZE                    */
/* SETTINGS FOR FILL-IN de-quantidade-f IN FRAME DEFAULT-FRAME
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
ON END-ERROR OF C-Win /* Quantidade Ordem de Compra - IM0044AA - 2.00.00.000 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Quantidade Ordem de Compra - IM0044AA - 2.00.00.000 */
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
  assign de-quantidade = int(de-quantidade:screen-value in frame {&frame-name}).

  assign de-quantidade-f = de-quantidade * (de-fator-conver /
                                            if de-num-casa-dec = 0 
                                            then 1
                                            else exp(10,de-num-casa-dec)).

  display de-quantidade-f with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

    /* Encontra fatores de conversao do item para conversÆo da quantidade interna -> qt-do-forn */
    for first item-fornec fields (fator-conver num-casa-dec) no-lock
        where item-fornec.it-codigo    = p-it-codigo and
              item-fornec.cod-emitente = p-cod-fornec:
    end.

    if avail item-fornec then
        assign de-fator-conver = item-fornec.fator-conver
               de-num-casa-dec = item-fornec.num-casa-dec.
    /* Fim fatores de conversao */


    /* Atualiza campos de tela */
    assign i-numero-ordem  = p-numero-ordem
           c-it-codigo     = p-it-codigo
           de-quantidade   = p-quantidade
           de-quantidade-f = p-qt-do-forn
           c-un-nosso      = p-un-nosso
           c-un-fornec     = p-un-fornec.
           
    /* Mostra campos */
    display i-numero-ordem
            c-it-codigo
            de-quantidade
            de-quantidade-f
            c-un-nosso
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
  DISPLAY i-numero-ordem c-it-codigo de-quantidade c-un-nosso de-quantidade-f 
          c-un-fornec 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE de-quantidade btOK btCancel btHelp RECT-1 rtToolBar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

