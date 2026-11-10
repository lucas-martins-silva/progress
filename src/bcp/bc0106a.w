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
{include/i-prgvrs.i BC0106A 2.00.00.029 } /*** "010029" 31/08/2023 15:08:02  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc0106a MBC}
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
DEF INPUT PARAMETER h-handleParam  AS HANDLE NO-UNDO.
DEF INPUT PARAMETER gr-bc-ext-item AS ROWID  NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Handle Variable Definitions */
DEF VAR h-acomp        AS HANDLE NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS bc-ext-item.it-codigo-ext-1 ~
bc-ext-item.it-codigo-ext-2 bc-ext-item.it-codigo-ext-3 ~
bc-ext-item.it-codigo-ext-4 bc-ext-item.imprime-etiq ~
bc-ext-item.qt-etiq-item bc-ext-item.qt-etiq-total bc-ext-item.tipo-etiq ~
bc-ext-item.tipo-etiq-total 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}it-codigo-ext-1 ~{&FP2}it-codigo-ext-1 ~{&FP3}~
 ~{&FP1}it-codigo-ext-2 ~{&FP2}it-codigo-ext-2 ~{&FP3}~
 ~{&FP1}it-codigo-ext-3 ~{&FP2}it-codigo-ext-3 ~{&FP3}~
 ~{&FP1}it-codigo-ext-4 ~{&FP2}it-codigo-ext-4 ~{&FP3}~
 ~{&FP1}qt-etiq-item ~{&FP2}qt-etiq-item ~{&FP3}~
 ~{&FP1}qt-etiq-total ~{&FP2}qt-etiq-total ~{&FP3}~
 ~{&FP1}tipo-etiq ~{&FP2}tipo-etiq ~{&FP3}~
 ~{&FP1}tipo-etiq-total ~{&FP2}tipo-etiq-total ~{&FP3}
&Scoped-define ENABLED-TABLES bc-ext-item
&Scoped-define FIRST-ENABLED-TABLE bc-ext-item
&Scoped-Define ENABLED-OBJECTS rt-buttom RECT-5 IMAGE-4 IMAGE-3 RECT-4 ~
c-inicial c-final tg-sub-it-codigo-ext-1 tg-sub-it-codigo-ext-2 ~
tg-sub-it-codigo-ext-3 tg-sub-it-codigo-ext-4 tg-sub-imp-etiq ~
tg-sub-qt-etiq-item tg-sub-qt-etiq-total tg-sel-etiq tg-sub-sel-tp-etiq ~
tg-sub-tipo-etiq tg-sub-tipo-etiq-total bt-ok bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-FIELDS bc-ext-item.it-codigo-ext-1 ~
bc-ext-item.it-codigo-ext-2 bc-ext-item.it-codigo-ext-3 ~
bc-ext-item.it-codigo-ext-4 bc-ext-item.imprime-etiq ~
bc-ext-item.qt-etiq-item bc-ext-item.qt-etiq-total bc-ext-item.tipo-etiq ~
bc-ext-item.tipo-etiq-total 
&Scoped-Define DISPLAYED-OBJECTS c-inicial c-final tg-sub-it-codigo-ext-1 ~
tg-sub-it-codigo-ext-2 tg-sub-it-codigo-ext-3 tg-sub-it-codigo-ext-4 ~
tg-sub-imp-etiq tg-sub-qt-etiq-item tg-sub-qt-etiq-total tg-sel-etiq ~
tg-sub-sel-tp-etiq tg-sub-tipo-etiq tg-sub-tipo-etiq-total 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-final AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-inicial AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3.57 BY .92.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-las":U
     SIZE 3.14 BY .92.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77 BY 1.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77 BY 10.5.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 77 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-sel-etiq AS LOGICAL INITIAL YES 
     LABEL "Selecionar Tipo Etiqueta?" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-imp-etiq AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-it-codigo-ext-1 AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-it-codigo-ext-2 AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-it-codigo-ext-3 AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-it-codigo-ext-4 AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-qt-etiq-item AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-qt-etiq-total AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-sel-tp-etiq AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-tipo-etiq AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-tipo-etiq-total AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-inicial AT ROW 1.38 COL 13.57 COLON-ALIGNED HELP
          "Item inicial"
     c-final AT ROW 1.38 COL 47 COLON-ALIGNED HELP
          "Item final" NO-LABEL
     bc-ext-item.it-codigo-ext-1 AT ROW 2.75 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tg-sub-it-codigo-ext-1 AT ROW 2.75 COL 61
     bc-ext-item.it-codigo-ext-2 AT ROW 3.75 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tg-sub-it-codigo-ext-2 AT ROW 3.75 COL 61
     bc-ext-item.it-codigo-ext-3 AT ROW 4.75 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tg-sub-it-codigo-ext-3 AT ROW 4.75 COL 61
     bc-ext-item.it-codigo-ext-4 AT ROW 5.75 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tg-sub-it-codigo-ext-4 AT ROW 5.75 COL 61
     bc-ext-item.imprime-etiq AT ROW 6.75 COL 34
          VIEW-AS TOGGLE-BOX
          SIZE 22.72 BY .75
     tg-sub-imp-etiq AT ROW 6.75 COL 61
     bc-ext-item.qt-etiq-item AT ROW 7.75 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tg-sub-qt-etiq-item AT ROW 7.75 COL 61
     bc-ext-item.qt-etiq-total AT ROW 8.75 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tg-sub-qt-etiq-total AT ROW 8.75 COL 61
     tg-sel-etiq AT ROW 9.75 COL 34 HELP
          "Selecionar Tipo Etiqueta?"
     tg-sub-sel-tp-etiq AT ROW 9.75 COL 61
     bc-ext-item.tipo-etiq AT ROW 10.75 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tg-sub-tipo-etiq AT ROW 10.75 COL 61
     bc-ext-item.tipo-etiq-total AT ROW 11.75 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tg-sub-tipo-etiq-total AT ROW 11.75 COL 61
     bt-ok AT ROW 13.25 COL 2 HELP
          "OK"
     bt-cancela AT ROW 13.25 COL 13 HELP
          "Cancelar"
     bt-ajuda AT ROW 13.25 COL 67 HELP
          "Ajuda"
     rt-buttom AT ROW 13 COL 1
     RECT-5 AT ROW 2.5 COL 1
     IMAGE-4 AT ROW 1.42 COL 45.86
     IMAGE-3 AT ROW 1.42 COL 37.43
     RECT-4 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.43 BY 13.54
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
         TITLE              = "Geraá∆o Autom†tica - Extens∆o de Itens"
         HEIGHT             = 13.5
         WIDTH              = 77
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
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
ON END-ERROR OF w-window /* Geraá∆o Autom†tica - Extens∆o de Itens */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
   /* This case occurs when the user presses the "Esc" key.
      In a persistently run window, just ignore this.  If we did not, the
      application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Geraá∆o Autom†tica - Extens∆o de Itens */
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
   /* Call Help Function (or a simple message). */
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-window
ON CHOOSE OF bt-cancela IN FRAME F-Main /* Cancelar */
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


&Scoped-define SELF-NAME bc-ext-item.imprime-etiq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bc-ext-item.imprime-etiq w-window
ON VALUE-CHANGED OF bc-ext-item.imprime-etiq IN FRAME F-Main /* Imprime Etiqueta? */
DO:
   DO WITH FRAME {&FRAME-NAME}:
      ASSIGN  bc-ext-item.qt-etiq-item:SENSITIVE    = bc-ext-item.imprime-etiq:CHECKED
              bc-ext-item.qt-etiq-total:SENSITIVE   = bc-ext-item.imprime-etiq:CHECKED
              tg-sel-etiq:SENSITIVE                 = bc-ext-item.imprime-etiq:CHECKED
              tg-sub-qt-etiq-item:SENSITIVE         = bc-ext-item.imprime-etiq:CHECKED
              tg-sub-qt-etiq-total:SENSITIVE        = bc-ext-item.imprime-etiq:CHECKED
              bc-ext-item.tipo-etiq:SENSITIVE       = bc-ext-item.imprime-etiq:CHECKED
              bc-ext-item.tipo-etiq-total:SENSITIVE = bc-ext-item.imprime-etiq:CHECKED
              tg-sub-tipo-etiq:SENSITIVE            = bc-ext-item.imprime-etiq:CHECKED
              tg-sub-tipo-etiq-total:SENSITIVE      = bc-ext-item.imprime-etiq:CHECKED.

      IF bc-ext-item.imprime-etiq:CHECKED THEN DO:
         ASSIGN  tg-sel-etiq:CHECKED                    = NO
                 bc-ext-item.qt-etiq-item:SCREEN-VALUE  = "1,0000"
                 bc-ext-item.qt-etiq-total:SCREEN-VALUE = "1,0000".

         APPLY "VALUE-CHANGED" TO tg-sel-etiq.
      END.
      ELSE DO:
         ASSIGN tg-sel-etiq:checked                    = NO
                bc-ext-item.qt-etiq-item:SCREEN-VALUE  = "0,0000"
                bc-ext-item.qt-etiq-total:SCREEN-VALUE = "0,0000".

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
      ASSIGN bc-ext-item.tipo-etiq:SENSITIVE       = tg-sel-etiq:CHECKED
             bc-ext-item.tipo-etiq-total:SENSITIVE = tg-sel-etiq:CHECKED
             tg-sub-tipo-etiq:SENSITIVE            = tg-sel-etiq:CHECKED
             tg-sub-tipo-etiq-total:SENSITIVE      = tg-sel-etiq:CHECKED.

      FIND FIRST param-bc NO-LOCK NO-ERROR.
      IF tg-sel-etiq:CHECKED AND AVAIL param-bc THEN DO:
         ASSIGN bc-ext-item.tipo-etiq:SCREEN-VALUE       = STRING(param-bc.tp-etiq-padrao)
                bc-ext-item.tipo-etiq-total:SCREEN-VALUE = STRING(param-bc.tipo-etiq-total).
      END.
      ELSE
         ASSIGN bc-ext-item.tipo-etiq:SCREEN-VALUE       = "00"
                bc-ext-item.tipo-etiq-total:SCREEN-VALUE = "00".
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
           tg-sub-it-codigo-ext-1
           tg-sub-it-codigo-ext-2 
           tg-sub-it-codigo-ext-3
           tg-sub-it-codigo-ext-4
           tg-sub-imp-etiq 
           tg-sub-qt-etiq-item
           tg-sub-qt-etiq-total
           tg-sel-etiq 
           tg-sub-sel-tp-etiq
           tg-sub-tipo-etiq
           tg-sub-tipo-etiq-total 
      WITH FRAME F-Main IN WINDOW w-window.
   
   IF AVAILABLE bc-ext-item THEN 
      DISPLAY bc-ext-item.it-codigo-ext-1
              bc-ext-item.it-codigo-ext-2 
              bc-ext-item.it-codigo-ext-3
              bc-ext-item.it-codigo-ext-4 
              bc-ext-item.imprime-etiq
              bc-ext-item.qt-etiq-item 
              bc-ext-item.qt-etiq-total
              bc-ext-item.tipo-etiq 
              bc-ext-item.tipo-etiq-total 
         WITH FRAME F-Main IN WINDOW w-window.
   
   ENABLE rt-buttom
          RECT-5
          IMAGE-4
          IMAGE-3
          RECT-4
          c-inicial
          c-final 
          bc-ext-item.it-codigo-ext-1
          tg-sub-it-codigo-ext-1 
          bc-ext-item.it-codigo-ext-2
          tg-sub-it-codigo-ext-2 
          bc-ext-item.it-codigo-ext-3
          tg-sub-it-codigo-ext-3 
          bc-ext-item.it-codigo-ext-4
          tg-sub-it-codigo-ext-4 
          bc-ext-item.imprime-etiq
          tg-sub-imp-etiq bc-ext-item.qt-etiq-item 
          tg-sub-qt-etiq-item
          bc-ext-item.qt-etiq-total
          tg-sub-qt-etiq-total 
          tg-sel-etiq
          tg-sub-sel-tp-etiq
          bc-ext-item.tipo-etiq
          tg-sub-tipo-etiq 
          bc-ext-item.tipo-etiq-total
          tg-sub-tipo-etiq-total
          bt-ok
          bt-cancela 
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
      RUN piAtualizaChaveReg IN h-handleParam (INPUT gr-bc-ext-item).
      RUN piAtualizaReg IN h-handleParam.
      RUN piLibWindow IN h-handleParam.
   END.
   
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
   
   /* Code placed here will execute PRIOR to standard behavior. */
   
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

{utp/ut9000.i "BC0106A" "2.00.00.029"} /* 31/08/2023 15:08:02 */

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
   
   IF VALID-HANDLE(h-handleParam) THEN
      RUN piBloqWindow IN h-handleParam.

   DO WITH FRAME {&FRAME-NAME}:
      {utp/ut-liter.i Item * R}
      ASSIGN c-inicial:LABEL = TRIM(RETURN-VALUE).
   
      {utp/ut-liter.i "Item Inicial" * R}
      ASSIGN c-inicial:HELP = TRIM(RETURN-VALUE).
              
      {utp/ut-liter.i "Item Final" * R}
      ASSIGN c-final:HELP = TRIM(RETURN-VALUE).
      
      {utp/ut-liter.i "Selecionar Tipo Etiqueta?" * L}
      ASSIGN tg-sel-etiq:LABEL = TRIM(RETURN-VALUE)
             tg-sel-etiq:HELP = TRIM(RETURN-VALUE).
   
      {utp/ut-field.i mgcld bc-ext-item tipo-etiq-total 1}
      ASSIGN bc-ext-item.tipo-etiq-total:LABEL = TRIM(RETURN-VALUE).
   
      {utp/ut-field.i mgcld bc-ext-item qt-etiq-total 1}
      ASSIGN bc-ext-item.qt-etiq-total:LABEL = TRIM(RETURN-VALUE).
   
      {utp/ut-field.i mgcld bc-ext-item it-codigo-ext-1 1}
      ASSIGN bc-ext-item.it-codigo-ext-1:LABEL = TRIM(RETURN-VALUE).
      
      {utp/ut-field.i mgcld bc-ext-item it-codigo-ext-2 1}
      ASSIGN bc-ext-item.it-codigo-ext-2:LABEL = TRIM(RETURN-VALUE).
      
      {utp/ut-field.i mgcld bc-ext-item it-codigo-ext-3 1}
      ASSIGN bc-ext-item.it-codigo-ext-3:LABEL = TRIM(RETURN-VALUE).
      
      {utp/ut-field.i mgcld bc-ext-item it-codigo-ext-4 1}
      ASSIGN bc-ext-item.it-codigo-ext-4:LABEL = TRIM(RETURN-VALUE).
   
      {utp/ut-liter.i Substituir * R}
      ASSIGN tg-sub-qt-etiq-item:LABEL    = TRIM(RETURN-VALUE)
             tg-sub-qt-etiq-total:LABEL   = TRIM(RETURN-VALUE)
             tg-sub-tipo-etiq:LABEL       = TRIM(RETURN-VALUE)
             tg-sub-tipo-etiq-total:LABEL = TRIM(RETURN-VALUE)
             tg-sub-imp-etiq:LABEL        = TRIM(RETURN-VALUE)
             tg-sub-it-codigo-ext-1:LABEL = TRIM(RETURN-VALUE)
             tg-sub-it-codigo-ext-2:LABEL = TRIM(RETURN-VALUE)
             tg-sub-it-codigo-ext-3:LABEL = TRIM(RETURN-VALUE)
             tg-sub-it-codigo-ext-4:LABEL = TRIM(RETURN-VALUE)
             tg-sub-sel-tp-etiq:LABEL     = TRIM(RETURN-VALUE).
   
      
   
   
      ASSIGN bc-ext-item.imprime-etiq:CHECKED = YES.
   
      APPLY "VALUE-CHANGED" TO bc-ext-item.imprime-etiq.   
   END.
   /* Code placed here will execute AFTER standard behavior.    */
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
   
      IF bc-ext-item.qt-etiq-item:SCREEN-VALUE = "0,0000" AND bc-ext-item.imprime-etiq:CHECKED = YES THEN DO:
         RUN utp/ut-msgs.p(INPUT "SHOW":U,
                           INPUT 5057,
                           INPUT "").
         APPLY "ENTRY" TO bc-ext-item.qt-etiq-item.
         RETURN NO-APPLY.
      END.
   
      IF tg-sel-etiq:checked = YES THEN DO:
         FIND FIRST tipo-etiqueta
              WHERE tipo-etiqueta.tipo-etiq = INTEGER(bc-ext-item.tipo-etiq:SCREEN-VALUE) NO-LOCK NO-ERROR.   
         IF NOT AVAIL tipo-etiqueta THEN DO:
            RUN utp/ut-msgs.p(INPUT "SHOW":U,
                              INPUT 16905,
                              INPUT bc-ext-item.tipo-etiq:SCREEN-VALUE).
            APPLY "ENTRY" TO bc-ext-item.tipo-etiq.
            RETURN NO-APPLY.
         END.
   
         FIND FIRST tipo-etiqueta
              WHERE tipo-etiqueta.tipo-etiq = INTEGER(bc-ext-item.tipo-etiq-total:SCREEN-VALUE) NO-LOCK NO-ERROR.   
         IF NOT AVAIL tipo-etiqueta THEN DO:
            RUN utp/ut-msgs.p(INPUT "SHOW":U,
                              INPUT 16905,
                              INPUT bc-ext-item.tipo-etiq-total:SCREEN-VALUE).
            APPLY "ENTRY" TO bc-ext-item.tipo-etiq-total.
            RETURN NO-APPLY.
         END.
      END.
   
      RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
      {utp/ut-liter.i Atualizando * L}      
      RUN pi-inicializar IN h-acomp (INPUT TRIM(RETURN-VALUE)).
      
      {utp/ut-liter.i Item: * L}   
      RUN pi-verifica-item (INPUT c-inicial:SCREEN-VALUE,
                            INPUT c-final:SCREEN-VALUE,
                            INPUT 5,   /* Tipo de Acesso 0=Currente .... */
                            INPUT 1).
   
      IF AVAIL ttReturnMessages THEN
         RELEASE ttItem.
   
      FOR EACH ttItem:   
         FIND FIRST bc-ext-item
              WHERE bc-ext-item.it-codigo = ttItem.it-codigo EXCLUSIVE-LOCK NO-ERROR.
   
         RUN pi-acompanhar IN h-acomp ( INPUT TRIM(RETURN-VALUE) + " " + ttItem.it-codigo).
   
         IF NOT AVAIL bc-ext-item THEN DO:             
            CREATE bc-ext-item.
            ASSIGN bc-ext-item.it-codigo       = ttItem.it-codigo
                   bc-ext-item.it-codigo-ext-1 = bc-ext-item.it-codigo-ext-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                   bc-ext-item.it-codigo-ext-2 = bc-ext-item.it-codigo-ext-2:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                   bc-ext-item.it-codigo-ext-3 = bc-ext-item.it-codigo-ext-3:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                   bc-ext-item.it-codigo-ext-4 = bc-ext-item.it-codigo-ext-4:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                   bc-ext-item.imprime-etiq    = bc-ext-item.imprime-etiq:CHECKED IN FRAME {&FRAME-NAME}
                   bc-ext-item.qt-etiq-item    = DECIMAL(bc-ext-item.qt-etiq-item:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   bc-ext-item.qt-etiq-total   = DECIMAL(bc-ext-item.qt-etiq-total:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   bc-ext-item.tipo-etiq       = INTEGER(bc-ext-item.tipo-etiq:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   bc-ext-item.tipo-etiq-total = DECIMAL(bc-ext-item.tipo-etiq-total:SCREEN-VALUE  IN FRAME {&FRAME-NAME})
                   gr-bc-ext-item              = ROWID(bc-ext-item).
      
            IF c-nom-prog-upc-mg97 <> "" AND c-nom-prog-upc-mg97 <> ? THEN DO:   
               RUN VALUE(c-nom-prog-upc-mg97) (INPUT "after-create-bc-ext-item",
                                               INPUT "VIEWER",
                                               INPUT THIS-PROCEDURE,
                                               INPUT FRAME f-main:HANDLE,
                                               INPUT "bc-ext-item",
                                               INPUT ROWID(bc-ext-item)).
            END.
         END.
         ELSE DO:
            ASSIGN  bc-ext-item.it-codigo-ext-1 = IF tg-sub-it-codigo-ext-1:CHECKED THEN bc-ext-item.it-codigo-ext-1:SCREEN-VALUE ELSE bc-ext-item.it-codigo-ext-1
                    bc-ext-item.it-codigo-ext-2 = IF tg-sub-it-codigo-ext-2:CHECKED THEN bc-ext-item.it-codigo-ext-2:SCREEN-VALUE ELSE bc-ext-item.it-codigo-ext-2
                    bc-ext-item.it-codigo-ext-3 = IF tg-sub-it-codigo-ext-3:CHECKED THEN bc-ext-item.it-codigo-ext-3:SCREEN-VALUE ELSE bc-ext-item.it-codigo-ext-3
                    bc-ext-item.it-codigo-ext-4 = IF tg-sub-it-codigo-ext-4:CHECKED THEN bc-ext-item.it-codigo-ext-4:SCREEN-VALUE ELSE bc-ext-item.it-codigo-ext-4      
                    bc-ext-item.imprime-etiq    = IF tg-sub-imp-etiq:CHECKED THEN bc-ext-item.imprime-etiq:CHECKED ELSE bc-ext-item.imprime-etiq
                    bc-ext-item.qt-etiq-item    = IF tg-sub-qt-etiq-item:CHECKED THEN DECIMAL(bc-ext-item.qt-etiq-item:SCREEN-VALUE) ELSE bc-ext-item.qt-etiq-item
                    bc-ext-item.qt-etiq-total   = IF tg-sub-qt-etiq-total:CHECKED THEN DECIMAL(bc-ext-item.qt-etiq-total:SCREEN-VALUE) ELSE bc-ext-item.qt-etiq-total
                    bc-ext-item.tipo-etiq       = IF tg-sub-tipo-etiq:CHECKED THEN INTEGER(bc-ext-item.tipo-etiq:SCREEN-VALUE) ELSE bc-ext-item.tipo-etiq
                    bc-ext-item.tipo-etiq-total = IF tg-sub-tipo-etiq-total:CHECKED THEN DECIMAL(bc-ext-item.tipo-etiq-total:SCREEN-VALUE) ELSE bc-ext-item.tipo-etiq-total
                    gr-bc-ext-item              = ROWID(bc-ext-item).
         END.
         
         IF NOT bc-ext-item.imprime-etiq AND tg-sub-imp-etiq:CHECKED THEN
            ASSIGN bc-ext-item.qt-etiq-item    = 0
                   bc-ext-item.qt-etiq-total   = 0.
   
         IF NOT tg-sel-etiq:CHECKED AND tg-sub-sel-tp-etiq:CHECKED THEN 
            ASSIGN bc-ext-item.tipo-etiq       = 0
                   bc-ext-item.tipo-etiq-total = 0.
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
   DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
   DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
