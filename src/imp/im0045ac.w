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
{include/i-prgvrs.i IM0045AC 2.00.00.002 } /*** "010002" 12/12/2025 11:00:57 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0045AC MIM}
&ENDIF

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER p-nr-ato-concessorio AS CHAR                          NO-UNDO.
DEFINE input  PARAMETER p-cod-estabel        LIKE ordens-embarque.cod-estabel NO-UNDO.
DEFINE INPUT  PARAMETER p-embarque           LIKE ordens-embarque.embarque    NO-UNDO.
DEFINE OUTPUT PARAMETER p-nr-ato-atual       AS CHAR                          NO-UNDO.

{include/boerrtab.i}
/* Local Variable Definitions ---                                       */
def var hprogramzoom as handle no-undo.
def var h-bocx312 as handle no-undo.
def var c-nr-ato as char.
DEFINE VARIABLE hShowMsg AS HANDLE      NO-UNDO.
{cdp/cdcfgdis.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 rtToolBar nr_ato btHelp btOK btCancel 
&Scoped-Define DISPLAYED-OBJECTS nr_ato 

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

DEFINE VARIABLE nr_ato AS CHARACTER FORMAT "X(20)":U 
     LABEL "Ato Concess¢rio" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.14 BY 3.29.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 38.14 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     nr_ato AT ROW 2.38 COL 3
     btHelp AT ROW 4.58 COL 28.86
     btOK AT ROW 4.63 COL 2
     btCancel AT ROW 4.63 COL 13
     RECT-1 AT ROW 1 COL 1
     rtToolBar AT ROW 4.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 38.29 BY 4.92
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Frames: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Ato Concess¢rio"
         HEIGHT             = 4.92
         WIDTH              = 38.43
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN nr_ato IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Ato Concess¢rio */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Ato Concess¢rio */
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
    assign p-nr-ato-atual = p-nr-ato-concessorio.
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
    IF p-nr-ato-concessorio <> input frame {&FRAME-NAME} nr_ato THEN DO:
       RUN pi-valida-ato-concessorio.
       IF RETURN-VALUE = "ADM-ERROR" THEN DO:
          UNDO, RETURN NO-APPLY.
       END.
    END.
    ASSIGN p-nr-ato-atual = input frame {&FRAME-NAME} nr_ato.
    APPLY "CLOSE":U TO THIS-PROCEDURE.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME nr_ato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nr_ato C-Win
ON F5 OF nr_ato IN FRAME DEFAULT-FRAME /* Ato Concess¢rio */
DO:
    {method/ZoomFields.i &ProgramZoom="cxzoom/z01cx312.w"
                         &FieldZoom1="nr-ato-concessorio"
                         &FieldScreen1="nr_ato"
                         &frame1="{&frame-name}"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nr_ato C-Win
ON MOUSE-SELECT-DBLCLICK OF nr_ato IN FRAME DEFAULT-FRAME /* Ato Concess¢rio */
DO:
      apply "f5" to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL nr_ato C-Win
ON RETURN OF nr_ato IN FRAME DEFAULT-FRAME /* Ato Concess¢rio */
DO:
  RUN pi-valida-ato-concessorio.
    
  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
     UNDO, RETURN NO-APPLY.
  END.
  ELSE DO:
     ASSIGN p-nr-ato-atual = input frame {&FRAME-NAME} nr_ato.
     APPLY "CLOSE":U TO THIS-PROCEDURE.     
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

  assign nr_ato = p-nr-ato-concessorio.

  disp nr_ato with frame {&FRAME-NAME}.
  
  nr_ato:LOAD-MOUSE-POINTER("image/lupa.cur":U)IN frame {&FRAME-NAME}.

  IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
      {utp/ut-liter.i "DIT" *}
      ASSIGN nr_ato:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
  END.

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
  DISPLAY nr_ato 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-1 rtToolBar nr_ato btHelp btOK btCancel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ato-concessorio C-Win 
PROCEDURE pi-valida-ato-concessorio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     IF input frame {&FRAME-NAME} nr_ato <> "" THEN DO:
 
         RUN cxbo/bocx312.p persistent set h-bocx312.
         
         ASSIGN c-nr-ato = input frame {&FRAME-NAME} nr_ato.     
         DO TRANS:
             run validateVincAtoConcesEmbarque in h-bocx312 (input p-cod-estabel,
                                                             input p-embarque,
                                                             input c-nr-ato,
                                                             output table tt-bo-erro).        
             DELETE procedure h-bocx312.
             
             
             IF CAN-FIND(FIRST tt-bo-erro) THEN DO:     
                 IF NOT VALID-HANDLE(hShowMsg) THEN 
                     RUN utp/showmessage.w PERSISTENT SET hShowMsg.
                 ELSE DO:
                     DELETE PROCEDURE hShowMsg.
                     RUN utp/showmessage.w PERSISTENT SET hShowMsg.
                 END. /* ELSE DO: */
             
                 RUN setModal     IN hShowMsg (INPUT YES).
                 run showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
                 UNDO, RETURN "adm-error".
             end.   
         END.
    END.     
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

