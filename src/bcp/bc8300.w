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
{include/i-prgvrs.i BC8300 2.00.00.004}  /*** "010004" 03/07/2023 09:45:13  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC8300 MBC}
&ENDIF


/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

Define Variable wgCommReader            As Widget-Handle        no-undo.
Define Variable vControl                As Integer              no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ed-leitura RECT-1 bt-inicializar ~
bt-finalizar bt-fechar RECT-2 im-sinal 
&Scoped-Define DISPLAYED-OBJECTS cUltimoValor ed-leitura c-texto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE PStimer AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chPStimer AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-fechar 
     LABEL "Fechar" 
     SIZE 12 BY 1 TOOLTIP "Finaliza SessÆo".

DEFINE BUTTON bt-finalizar 
     LABEL "Finalizar" 
     SIZE 12 BY 1 TOOLTIP "Finaliza SessÆo".

DEFINE BUTTON bt-inicializar 
     LABEL "Inicializar" 
     SIZE 12 BY 1 TOOLTIP "Inicializa SessÆo".

DEFINE VARIABLE ed-leitura AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 83 BY 8.25 TOOLTIP "Conte£do Captura na Porta" NO-UNDO.

DEFINE VARIABLE c-texto AS CHARACTER FORMAT "X(30)":U INITIAL "Status Porta:" 
      VIEW-AS TEXT 
     SIZE 13 BY .75
     BGCOLOR 7  NO-UNDO.

DEFINE VARIABLE cUltimoValor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ultimo Valor" 
     VIEW-AS FILL-IN 
     SIZE 69 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE IMAGE im-sinal
     FILENAME "image\im-led1":U
     SIZE 1.72 BY .42.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 83 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 4 BY 1.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     cUltimoValor AT ROW 1.25 COL 2.57
     ed-leitura AT ROW 2.5 COL 1 NO-LABEL
     bt-inicializar AT ROW 11 COL 2
     bt-finalizar AT ROW 11 COL 14
     bt-fechar AT ROW 11 COL 26
     c-texto AT ROW 11.25 COL 64 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 10.75 COL 1
     RECT-2 AT ROW 11 COL 79
     im-sinal AT ROW 11.33 COL 80.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.57 BY 11.42.


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
         TITLE              = "DEMO Leitura Porta Serial"
         HEIGHT             = 11.42
         WIDTH              = 83.43
         MAX-HEIGHT         = 13.38
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 13.38
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* SETTINGS FOR FILL-IN c-texto IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cUltimoValor IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       ed-leitura:AUTO-INDENT IN FRAME DEFAULT-FRAME      = TRUE
       ed-leitura:RETURN-INSERTED IN FRAME DEFAULT-FRAME  = TRUE
       ed-leitura:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

//liga o facelift
&GLOBAL-DEFINE aplica_facelift YES
{include/i_fcldef.i}
{include/i_fclfrm.i DEFAULT-FRAME}

/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME PStimer ASSIGN
       FRAME        = FRAME DEFAULT-FRAME:HANDLE
       ROW          = 11
       COLUMN       = 44
       HEIGHT       = 1.17
       WIDTH        = 4
       HIDDEN       = yes
       SENSITIVE    = yes.
      PStimer:NAME = "PStimer":U .
/* PStimer OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      PStimer:MOVE-AFTER(bt-fechar:HANDLE IN FRAME DEFAULT-FRAME).

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* DEMO Leitura Porta Serial */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* DEMO Leitura Porta Serial */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fechar C-Win
ON CHOOSE OF bt-fechar IN FRAME DEFAULT-FRAME /* Fechar */
DO:
    Assign  chPStimer:PSTimer:enabled = no.

    if  valid-handle(wgCommReader)
    Then
        Run DisconnectPort in wgCommReader.

    Apply 'close' to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-finalizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-finalizar C-Win
ON CHOOSE OF bt-finalizar IN FRAME DEFAULT-FRAME /* Finalizar */
DO:
    Assign  chPStimer:PSTimer   :enabled    = no
            bt-inicializar      :Sensitive  = yes.

    if  valid-handle(wgCommReader)
    Then do:
        Run DisconnectPort in wgCommReader.
        Delete Procedure wgCommReader.
    End.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inicializar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inicializar C-Win
ON CHOOSE OF bt-inicializar IN FRAME DEFAULT-FRAME /* Inicializar */
DO:
    Run bcp/bcapi014.w persistent set wgCommReader.

    Run ConnectPort in wgCommReader.

    Assign  chPSTimer:PSTimer:Enabled = yes
            bt-inicializar  :Sensitive = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PStimer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PStimer C-Win
PROCEDURE PStimer.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/
    Define var vDesTeste    as char no-undo.
    Define var vDesBuffer   as char no-undo.

    If  valid-handle(wgCommReader)
    Then do:
        Run GetData in wgCommReader (output vDesTeste, output vDesBuffer). 
        Assign ed-leitura   :screen-value in frame {&Frame-Name} = vDesTeste
               cUltimoValor :screen-value in frame {&Frame-Name} = vDesBuffer.
    End.
    Else do:
        if  im-sinal:LOAD-IMAGE('image/im-led1.bmp') Then.
        Assign chPSTimer:PSTimer:Enabled = no.
        return.
    End.
    If  vControl = 3 Then do:
        if  im-sinal:LOAD-IMAGE('image/im-led1.bmp') Then.
        Assign vControl = 1.
    End.
    if  vControl = 2 Then do:
        if  im-sinal:LOAD-IMAGE('image/im-led3.bmp') Then.
        Assign vControl = 3.
    End.
    if (   vControl = 0
        or vControl = 1)
    Then do:
        if  im-sinal:LOAD-IMAGE('image/im-led2.bmp') Then.
        Assign vControl = 2.
    End.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

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
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    
    RUN enable_UI.

    {utp/ut-liter.i "Conte£do Captura na Porta" * L}
    assign  ed-leitura:tooltip in frame {&FRAME-NAME} = trim(return-value).
    {utp/ut-liter.i "Inicializa SessÆo" * L}
    assign  bt-inicializar:tooltip in frame {&FRAME-NAME} = trim(return-value).
    {utp/ut-liter.i "Inicializar" * L}
    assign  bt-inicializar:label in frame {&FRAME-NAME} = trim(return-value).
    {utp/ut-liter.i "Finaliza SessÆo" * L}
    assign  bt-finalizar:tooltip in frame {&FRAME-NAME} = trim(return-value).
    {utp/ut-liter.i "Finalizar" * L}
    assign  bt-finalizar:label in frame {&FRAME-NAME} = trim(return-value).
    {utp/ut-liter.i "Status Porta:" * L}
    assign  c-texto:screen-value in frame {&FRAME-NAME} = trim(return-value).

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.


/****************************************************************************************************************
Documentação das funções disponibilizadas no programa bcp/bcapi014.r - Leitura Porta Serial

1.) Função ClearData....: Limpa Dados Enviados da Porta Serial
2.) Função CloseReader..: Finaliza Conexão da Porta Serial
3.) ConnectPort.........: Conecta a Porta Serial

****************************************************************************************************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load C-Win _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "bc8300.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chPStimer = PStimer:COM-HANDLE
    UIB_S = chPStimer:LoadControls( OCXFile, "PStimer":U)
  .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "bc8300.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win _DEFAULT-ENABLE
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
  RUN control_load.
  DISPLAY cUltimoValor ed-leitura c-texto 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE ed-leitura RECT-1 bt-inicializar bt-finalizar bt-fechar RECT-2 
         im-sinal 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


