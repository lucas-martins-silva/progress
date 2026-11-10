&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcld            PROGRESS
*/
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0107B 2.00.00.017 } /*** "010017" 31/08/2023 15:08:02  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc0107b MBC}
&ENDIF

/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEF INPUT PARAMETER h-handleParam     AS HANDLE NO-UNDO.
DEF INPUT PARAMETER gr-bc-ext-familia AS ROWID  NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Handle Variable Definitions */
DEF VAR h-acomp AS HANDLE NO-UNDO.

{bcp/bcproxy.i2}    /* Definiá‰es das procedures para integraá∆o com o Magnus i.00 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS bc-ext-familia.imprime-etiq ~
bc-ext-familia.qt-etiq-item bc-ext-familia.qt-etiq-total ~
bc-ext-familia.tipo-etiq bc-ext-familia.tipo-etiq-total 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}qt-etiq-item ~{&FP2}qt-etiq-item ~{&FP3}~
 ~{&FP1}qt-etiq-total ~{&FP2}qt-etiq-total ~{&FP3}~
 ~{&FP1}tipo-etiq ~{&FP2}tipo-etiq ~{&FP3}~
 ~{&FP1}tipo-etiq-total ~{&FP2}tipo-etiq-total ~{&FP3}
&Scoped-define ENABLED-TABLES bc-ext-familia
&Scoped-define FIRST-ENABLED-TABLE bc-ext-familia
&Scoped-Define ENABLED-OBJECTS RECT-6 IMAGE-5 IMAGE-6 RECT-7 RECT-1 ~
c-inicial c-final tg-sub-imp-etiq tg-sub-qt-etiq-item tg-sub-qt-etiq-total ~
tg-sel-etiq tg-sub-sel-tp-etiq tg-sub-tipo-etiq tg-sub-tipo-etiq-total ~
bt-ok bt-cancelar bt-ajuda 
&Scoped-Define DISPLAYED-FIELDS bc-ext-familia.imprime-etiq ~
bc-ext-familia.qt-etiq-item bc-ext-familia.qt-etiq-total ~
bc-ext-familia.tipo-etiq bc-ext-familia.tipo-etiq-total 
&Scoped-Define DISPLAYED-OBJECTS c-inicial c-final tg-sub-imp-etiq ~
tg-sub-qt-etiq-item tg-sub-qt-etiq-total tg-sel-etiq tg-sub-sel-tp-etiq ~
tg-sub-tipo-etiq tg-sub-tipo-etiq-total 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-final AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-inicial AS CHARACTER FORMAT "X(8)":U 
     LABEL "Fam°lia" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-5
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image~\im-las":U
     SIZE 2.72 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 79 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 78.86 BY 1.54.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 78.86 BY 6.67.

DEFINE VARIABLE tg-sel-etiq AS LOGICAL INITIAL YES 
     LABEL "Selecionar Tipo Etiqueta?" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-imp-etiq AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-qt-etiq-item AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-qt-etiq-total AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-sel-tp-etiq AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-tipo-etiq AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-tipo-etiq-total AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-inicial AT ROW 1.25 COL 20 COLON-ALIGNED HELP
          "Fam°lia inicial"
     c-final AT ROW 1.25 COL 48 COLON-ALIGNED HELP
          "Fam°lia final" NO-LABEL
     bc-ext-familia.imprime-etiq AT ROW 3 COL 36
          VIEW-AS TOGGLE-BOX
          SIZE 22.72 BY .88
     tg-sub-imp-etiq AT ROW 3 COL 63
     bc-ext-familia.qt-etiq-item AT ROW 4 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tg-sub-qt-etiq-item AT ROW 4 COL 63
     bc-ext-familia.qt-etiq-total AT ROW 5 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tg-sub-qt-etiq-total AT ROW 5 COL 63
     tg-sel-etiq AT ROW 6 COL 36 HELP
          "Selecionar Tipo Etiqueta?"
     tg-sub-sel-tp-etiq AT ROW 6 COL 63
     bc-ext-familia.tipo-etiq AT ROW 7 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tg-sub-tipo-etiq AT ROW 7 COL 63
     bc-ext-familia.tipo-etiq-total AT ROW 8 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tg-sub-tipo-etiq-total AT ROW 8 COL 63
     bt-ok AT ROW 9.46 COL 2 HELP
          "OK"
     bt-cancelar AT ROW 9.46 COL 13 HELP
          "Cancelar"
     bt-ajuda AT ROW 9.5 COL 69 HELP
          "Ajuda"
     RECT-6 AT ROW 1 COL 1
     IMAGE-5 AT ROW 1.33 COL 36.43
     IMAGE-6 AT ROW 1.33 COL 46.57
     RECT-7 AT ROW 2.58 COL 1.14
     RECT-1 AT ROW 9.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1
         SIZE 79.43 BY 9.67
         DEFAULT-BUTTON bt-ok.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Geraá∆o Autom†tica Extens∆o Familia"
         HEIGHT             = 9.75
         WIDTH              = 79.14
         MAX-HEIGHT         = 21.13
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.13
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = NO
         SCROLL-BARS        = NO
         STATUS-AREA        = YES
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = YES
         MESSAGE-AREA       = NO
         SENSITIVE          = YES.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = YES.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Geraá∆o Autom†tica Extens∆o Familia */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
   /* This case occurs when the user presses the "Esc" key.
      In a persistently run window, just ignore this.  If we did not, the
      application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Geraá∆o Autom†tica Extens∆o Familia */
DO:
   /* This ADM code must be left here in order for the SmartWindow
      and its descendents to terminate properly on exit. */
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-window
ON CHOOSE OF bt-ajuda IN FRAME F-Main /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-window
ON CHOOSE OF bt-cancelar IN FRAME F-Main /* Cancelar */
DO:
   APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
   RUN pi-geracao-automatica.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bc-ext-familia.imprime-etiq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bc-ext-familia.imprime-etiq w-window
ON VALUE-CHANGED OF bc-ext-familia.imprime-etiq IN FRAME F-Main /* Imprime Etiqueta? */
DO:
   DO WITH FRAME {&FRAME-NAME}:
      ASSIGN bc-ext-familia.qt-etiq-item:SENSITIVE    = bc-ext-familia.imprime-etiq:CHECKED
             bc-ext-familia.qt-etiq-total:SENSITIVE   = bc-ext-familia.imprime-etiq:CHECKED
             tg-sub-qt-etiq-item:SENSITIVE            = bc-ext-familia.imprime-etiq:CHECKED
             tg-sub-qt-etiq-total:SENSITIVE           = bc-ext-familia.imprime-etiq:CHECKED
             tg-sel-etiq:SENSITIVE                    = bc-ext-familia.imprime-etiq:CHECKED
             bc-ext-familia.tipo-etiq:SENSITIVE       = bc-ext-familia.imprime-etiq:CHECKED
             bc-ext-familia.tipo-etiq-total:SENSITIVE = bc-ext-familia.imprime-etiq:CHECKED
             tg-sub-tipo-etiq:SENSITIVE               = bc-ext-familia.imprime-etiq:CHECKED
             tg-sub-tipo-etiq-total:SENSITIVE         = bc-ext-familia.imprime-etiq:CHECKED.

      IF bc-ext-familia.imprime-etiq:CHECKED THEN DO:
         ASSIGN tg-sel-etiq:CHECKED                       = NO
                bc-ext-familia.qt-etiq-item:SCREEN-VALUE  = "1,0000"
                bc-ext-familia.qt-etiq-total:SCREEN-VALUE = "1,0000".
   
         APPLY "VALUE-CHANGED" TO tg-sel-etiq.
      END.
      ELSE DO:
         ASSIGN tg-sel-etiq:CHECKED                       = NO
                bc-ext-familia.qt-etiq-item:SCREEN-VALUE  = "0,0000"
                bc-ext-familia.qt-etiq-total:SCREEN-VALUE = "0,0000".
   
         APPLY "VALUE-CHANGED" TO tg-sel-etiq.
      END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-sel-etiq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-sel-etiq w-window
ON VALUE-CHANGED OF tg-sel-etiq IN FRAME F-Main /* Selecionar Tipo Etiqueta? */
DO:
   DO WITH FRAME {&FRAME-NAME}:
      ASSIGN bc-ext-familia.tipo-etiq:SENSITIVE       = tg-sel-etiq:CHECKED
             bc-ext-familia.tipo-etiq-total:SENSITIVE = tg-sel-etiq:CHECKED
             tg-sub-tipo-etiq:SENSITIVE               = tg-sel-etiq:CHECKED
             tg-sub-tipo-etiq-total:SENSITIVE         = tg-sel-etiq:CHECKED.
   
      FIND FIRST param-bc NO-LOCK NO-ERROR.
      IF tg-sel-etiq:CHECKED AND AVAIL param-bc THEN DO:
         ASSIGN bc-ext-familia.tipo-etiq:SCREEN-VALUE       = STRING(param-bc.tp-etiq-padrao)
                bc-ext-familia.tipo-etiq-total:SCREEN-VALUE = STRING(param-bc.tp-etiq-padrao).
      END.
      ELSE
         ASSIGN bc-ext-familia.tipo-etiq:SCREEN-VALUE       = "00"
                bc-ext-familia.tipo-etiq-total:SCREEN-VALUE = "00".
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

   /* Define variables needed by this internal procedure.             */
   {src/adm/template/row-head.i}

   /* Process the newly available records (i.e. display fields,
      open queries, and/or pass records on to any RECORD-TARGETS).    */
   {src/adm/template/row-end.i}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window _DEFAULT-DISABLE
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
   IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window) THEN
      DELETE WIDGET w-window.
  
   IF THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window _DEFAULT-ENABLE
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
   DISPLAY c-inicial
           c-final
           tg-sub-imp-etiq
           tg-sub-qt-etiq-item 
           tg-sub-qt-etiq-total
           tg-sel-etiq
           tg-sub-sel-tp-etiq
           tg-sub-tipo-etiq 
           tg-sub-tipo-etiq-total 
      WITH FRAME F-Main IN WINDOW w-window.
   
   IF AVAILABLE bc-ext-familia THEN 
      DISPLAY bc-ext-familia.imprime-etiq
              bc-ext-familia.qt-etiq-item 
              bc-ext-familia.qt-etiq-total
              bc-ext-familia.tipo-etiq 
              bc-ext-familia.tipo-etiq-total 
         WITH FRAME F-Main IN WINDOW w-window.
   
   ENABLE RECT-6
          IMAGE-5
          IMAGE-6
          RECT-7
          RECT-1
          c-inicial
          c-final 
          bc-ext-familia.imprime-etiq
          tg-sub-imp-etiq 
          bc-ext-familia.qt-etiq-item
          tg-sub-qt-etiq-item 
          bc-ext-familia.qt-etiq-total
          tg-sub-qt-etiq-total
          tg-sel-etiq 
          tg-sub-sel-tp-etiq
          bc-ext-familia.tipo-etiq
          tg-sub-tipo-etiq 
          bc-ext-familia.tipo-etiq-total
          tg-sub-tipo-etiq-total
          bt-ok 
          bt-cancelar
          bt-ajuda 
      WITH FRAME F-Main IN WINDOW w-window.
   
   {&OPEN-BROWSERS-IN-QUERY-F-Main}
   VIEW w-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-window 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   IF VALID-HANDLE(h-handleParam) THEN DO:
      RUN piAtualizaChaveReg IN h-handleParam (INPUT gr-bc-ext-familia).
      RUN piAtualizaReg IN h-handleParam.
      RUN piLibWindow IN h-handleParam.
   END.
   /* Code placed here will execute PRIOR to standard behavior. */

   IF VALID-HANDLE(gh-bofn068) THEN DO:
      DELETE PROCEDURE gh-bofn068 NO-ERROR.
      ASSIGN gh-bofn068 = ?.
   END.
   
   IF VALID-HANDLE(gh-bofn088) THEN DO:
      DELETE PROCEDURE gh-bofn088 NO-ERROR.
      ASSIGN gh-bofn088 = ?.
   END.
   
   IF VALID-HANDLE(gh-bofn116) THEN DO:
      DELETE PROCEDURE gh-bofn116 NO-ERROR.
      ASSIGN gh-bofn116 = ?.
   END.

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
   {include/i-logfin.i}

   /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-window 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   /* Code placed here will execute PRIOR to standard behavior. */

{utp/ut9000.i "BC0107B" "2.00.00.017"} /* 31/08/2023 15:08:02 */

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

   IF VALID-HANDLE(h-handleParam) THEN
      RUN piBloqWindow IN h-handleParam.
  
   DO WITH FRAME {&FRAME-NAME}:
      {utp/ut-liter.i Fam°lia * R}
      ASSIGN c-inicial:LABEL = TRIM(RETURN-VALUE).

      {utp/ut-liter.i Fam°lia_Inicial * L}
      ASSIGN c-inicial:HELP = TRIM(RETURN-VALUE).
   
      {utp/ut-liter.i Fam°lia_Final * L}
      ASSIGN c-final:HELP = TRIM(RETURN-VALUE).

      {utp/ut-liter.i "Selecionar Tipo Etiqueta?" * L}
      ASSIGN tg-sel-etiq:LABEL = TRIM(RETURN-VALUE)
             tg-sel-etiq:HELP  = TRIM(RETURN-VALUE).

      {utp/ut-field.i mgcld bc-ext-familia tipo-etiq-total 1}
      ASSIGN bc-ext-familia.tipo-etiq-total:LABEL = TRIM(RETURN-VALUE).

      {utp/ut-field.i mgcld bc-ext-familia qt-etiq-total 1}
      ASSIGN bc-ext-familia.qt-etiq-total:LABEL = TRIM(RETURN-VALUE).

      {utp/ut-liter.i Substituir * R}
      ASSIGN tg-sub-qt-etiq-item:LABEL    = TRIM(RETURN-VALUE)
             tg-sub-qt-etiq-total:LABEL   = TRIM(RETURN-VALUE)
             tg-sub-tipo-etiq:LABEL       = TRIM(RETURN-VALUE)
             tg-sub-tipo-etiq-total:LABEL = TRIM(RETURN-VALUE)
             tg-sub-imp-etiq:LABEL        = TRIM(RETURN-VALUE)
             tg-sub-sel-tp-etiq:LABEL     = TRIM(RETURN-VALUE).

      ASSIGN bc-ext-familia.imprime-etiq:CHECKED = YES. 

      APPLY "VALUE-CHANGED" TO bc-ext-familia.imprime-etiq.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-geracao-automatica w-window 
PROCEDURE pi-geracao-automatica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DO WITH FRAME {&FRAME-NAME}
      ON STOP UNDO, LEAVE
      ON QUIT UNDO, LEAVE:
      
      IF bc-ext-familia.qt-etiq-item:SCREEN-VALUE = "0,0000" AND bc-ext-familia.imprime-etiq:CHECKED = YES THEN DO:
         RUN utp/ut-msgs.p(INPUT "SHOW":U,
                           INPUT 5057,
                           INPUT "").
         APPLY "ENTRY" TO bc-ext-familia.qt-etiq-item.
         RETURN NO-APPLY.
      END.
      
      IF tg-sel-etiq:CHECKED = YES THEN DO:
         FIND FIRST tipo-etiqueta
              WHERE tipo-etiqueta.tipo-etiq = INTEGER(bc-ext-familia.tipo-etiq:SCREEN-VALUE) NO-LOCK NO-ERROR.
         IF NOT AVAIL tipo-etiqueta THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 16905,
                               INPUT bc-ext-familia.tipo-etiq:SCREEN-VALUE).
            APPLY "ENTRY" TO bc-ext-familia.tipo-etiq.
            RETURN NO-APPLY.
         END.
      
         FIND FIRST tipo-etiqueta
              WHERE tipo-etiqueta.tipo-etiq = INTEGER(bc-ext-familia.tipo-etiq-total:SCREEN-VALUE) NO-LOCK NO-ERROR.      
         IF NOT AVAIL tipo-etiqueta THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 16905,
                               INPUT bc-ext-familia.tipo-etiq-total:SCREEN-VALUE).
            APPLY "ENTRY" TO bc-ext-familia.tipo-etiq-total.
            RETURN NO-APPLY.
         END.
      END.
      
      RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
      {utp/ut-liter.i Atualizando * L}
      RUN pi-inicializar IN h-acomp (INPUT TRIM(RETURN-VALUE)).
      {utp/ut-liter.i Familia: * L}
      
      
      RUN pi-verifica-familia(INPUT c-inicial:SCREEN-VALUE,
                              INPUT c-final:SCREEN-VALUE,
                              INPUT 5,
                              INPUT 1).
      
      FOR EACH ttFamilia:
         FIND FIRST bc-ext-familia 
              WHERE bc-ext-familia.fm-codigo = ttFamilia.fm-codigo EXCLUSIVE-LOCK NO-ERROR.
      
         RUN pi-acompanhar IN h-acomp ( INPUT TRIM(RETURN-VALUE) + " " + ttFamilia.fm-codigo).
      
         IF NOT AVAIL bc-ext-familia THEN DO:
            CREATE bc-ext-familia.
            ASSIGN bc-ext-familia.fm-codigo       = ttFamilia.fm-codigo
                   bc-ext-familia.imprime-etiq    = bc-ext-familia.imprime-etiq:CHECKED IN FRAME {&FRAME-NAME}
                   bc-ext-familia.qt-etiq-item    = DECIMAL(bc-ext-familia.qt-etiq-item:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   bc-ext-familia.qt-etiq-total   = DECIMAL(bc-ext-familia.qt-etiq-total:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   bc-ext-familia.tipo-etiq       = INTEGER(bc-ext-familia.tipo-etiq:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   bc-ext-familia.tipo-etiq-total = DECIMAL(bc-ext-familia.tipo-etiq-total:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   gr-bc-ext-familia              = ROWID(bc-ext-familia).
         END.
         ELSE DO:
            ASSIGN bc-ext-familia.imprime-etiq    = IF tg-sub-imp-etiq:CHECKED THEN bc-ext-familia.imprime-etiq:CHECKED IN FRAME {&FRAME-NAME} ELSE bc-ext-familia.imprime-etiq
                   bc-ext-familia.qt-etiq-item    = IF tg-sub-qt-etiq-item:CHECKED THEN dec(bc-ext-familia.qt-etiq-item:SCREEN-VALUE IN FRAME {&FRAME-NAME}) ELSE bc-ext-familia.qt-etiq-item
                   bc-ext-familia.qt-etiq-total   = IF tg-sub-qt-etiq-total:CHECKED THEN dec(bc-ext-familia.qt-etiq-total:SCREEN-VALUE IN FRAME {&FRAME-NAME}) ELSE bc-ext-familia.qt-etiq-total
                   bc-ext-familia.tipo-etiq       = IF tg-sub-tipo-etiq:CHECKED THEN INTEGER(bc-ext-familia.tipo-etiq:SCREEN-VALUE IN FRAME {&FRAME-NAME}) ELSE bc-ext-familia.tipo-etiq
                   bc-ext-familia.tipo-etiq-total = IF tg-sub-tipo-etiq-total:CHECKED THEN DECIMAL(bc-ext-familia.tipo-etiq-total:SCREEN-VALUE IN FRAME {&FRAME-NAME}) ELSE bc-ext-familia.tipo-etiq-total
                   gr-bc-ext-familia              = ROWID(bc-ext-familia).
         END.
      
         IF NOT bc-ext-familia.imprime-etiq AND tg-sub-imp-etiq:CHECKED THEN
            ASSIGN bc-ext-familia.qt-etiq-item    = 0
                   bc-ext-familia.qt-etiq-total   = 0.
      
         IF NOT tg-sel-etiq:CHECKED AND tg-sub-sel-tp-etiq:CHECKED THEN 
            ASSIGN bc-ext-familia.tipo-etiq       = 0
                   bc-ext-familia.tipo-etiq-total = 0.
      END.      
      RUN pi-finalizar IN h-acomp.
      APPLY "CLOSE" TO THIS-PROCEDURE.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

   /* SEND-RECORDS does nothing because there are no External
      Tables specified for this JanelaDetalhe, and there are no
      tables specified in any contained Browse, Query, or Frame. */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-window 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
   DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
