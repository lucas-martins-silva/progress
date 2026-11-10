&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgemp            PROGRESS
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
{include/i-prgvrs.i BC0113A 2.00.00.021 } /*** "010021" 31/08/2023 15:08:03  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc0113a MBC}
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
DEF INPUT PARAMETER h-handleParam  AS HANDLE  NO-UNDO.
DEF INPUT PARAMETER gr-item-cli    AS ROWID   NO-UNDO.
DEF INPUT PARAMETER l-atualiza     AS LOGICAL NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Handle Variable Definitions */
DEF VAR h-acomp AS HANDLE NO-UNDO.

{bcp/bcproxy.i2}    /* Definiá‰es das procedures para integraá∆o com o Magnus i.00 */

DEFINE TEMP-TABLE bttReturnMessages NO-UNDO LIKE ttReturnMessages.
DEFINE TEMP-TABLE ttItem-emitente NO-UNDO
            FIELD it-codigo       AS CHARACTER LABEL 'Codigo do Item'
            FIELD nome-abrev      AS CHARACTER LABEL 'Nome Abreviado'
            FIELD cod-emitente    AS INTEGER   LABEL 'Emitente'
            FIELD item-emitente   AS CHARACTER LABEL 'Item do Emitente'
            FIELD rowid-value     AS ROWID
            INDEX tcdg   it-codigo
            INDEX nmbrv  nome-abrev
            INDEX cdmtnt cod-emitente.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE NO

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS bc-ext-item-emit.it-codigo-ext-1 ~
bc-ext-item-emit.it-codigo-ext-2 bc-ext-item-emit.it-codigo-ext-3 ~
bc-ext-item-emit.it-codigo-ext-4 bc-ext-item-emit.imprime-etiq ~
bc-ext-item-emit.qt-etiq-item bc-ext-item-emit.qt-etiq-total ~
bc-ext-item-emit.tipo-etiq bc-ext-item-emit.tipo-etiq-total 
&Scoped-define ENABLED-TABLES bc-ext-item-emit
&Scoped-define FIRST-ENABLED-TABLE bc-ext-item-emit
&Scoped-Define ENABLED-OBJECTS c-item-inicial c-item-final c-cli-inicial ~
c-cli-final tg-itemCLI tg-itemFOR tg-sub-item-ext-1 tg-sub-item-ext-2 ~
tg-sub-item-ext-3 tg-sub-item-ext-4 tg-sub-imp-etiq tg-sub-qt-etiq-item ~
tg-sub-qt-etiq-total tg-sel-etiq tg-sub-tipo-etiq tg-sub-tipo-etiq-total ~
bt-ok bt-cancela bt-ajuda IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 RECT-4 RECT-5 ~
RECT-6 rt-buttom 
&Scoped-Define DISPLAYED-FIELDS bc-ext-item-emit.it-codigo-ext-1 ~
bc-ext-item-emit.it-codigo-ext-2 bc-ext-item-emit.it-codigo-ext-3 ~
bc-ext-item-emit.it-codigo-ext-4 bc-ext-item-emit.imprime-etiq ~
bc-ext-item-emit.qt-etiq-item bc-ext-item-emit.qt-etiq-total ~
bc-ext-item-emit.tipo-etiq bc-ext-item-emit.tipo-etiq-total 
&Scoped-define DISPLAYED-TABLES bc-ext-item-emit
&Scoped-define FIRST-DISPLAYED-TABLE bc-ext-item-emit
&Scoped-Define DISPLAYED-OBJECTS c-item-inicial c-item-final c-cli-inicial ~
c-cli-final tg-itemCLI tg-itemFOR tg-sub-item-ext-1 tg-sub-item-ext-2 ~
tg-sub-item-ext-3 tg-sub-item-ext-4 tg-sub-imp-etiq tg-sub-qt-etiq-item ~
tg-sub-qt-etiq-total tg-sel-etiq tg-sub-tipo-etiq tg-sub-tipo-etiq-total ~
c-lit-atualizacao 

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

DEFINE VARIABLE c-cli-final AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-cli-inicial AS CHARACTER FORMAT "X(12)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-final AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-inicial AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-lit-atualizacao AS CHARACTER FORMAT "X(256)":U INITIAL "Atualizar:" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3.57 BY .92.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-las":U
     SIZE 3.14 BY .92.

DEFINE IMAGE IMAGE-5
     FILENAME "image~\im-fir":U
     SIZE 3.57 BY .92.

DEFINE IMAGE IMAGE-6
     FILENAME "image~\im-las":U
     SIZE 3.14 BY .92.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 2.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 10.5.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 1.25.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 83 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-itemCLI AS LOGICAL INITIAL YES 
     LABEL "Item Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE tg-itemFOR AS LOGICAL INITIAL YES 
     LABEL "Item Fornecedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sel-etiq AS LOGICAL INITIAL NO 
     LABEL "Seleciona Tipo Etiqueta" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .75 NO-UNDO.

DEFINE VARIABLE tg-sub-imp-etiq AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-item-ext-1 AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-item-ext-2 AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-item-ext-3 AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-item-ext-4 AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-qt-etiq-item AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-qt-etiq-total AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-tipo-etiq AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE tg-sub-tipo-etiq-total AS LOGICAL INITIAL NO 
     LABEL "Substituir" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-item-inicial AT ROW 1.25 COL 18 COLON-ALIGNED HELP
          "Item inicial"
     c-item-final AT ROW 1.25 COL 53 COLON-ALIGNED HELP
          "Item final" NO-LABEL
     c-cli-inicial AT ROW 2.25 COL 18 COLON-ALIGNED HELP
          "Cliente inicial"
     c-cli-final AT ROW 2.25 COL 53 COLON-ALIGNED HELP
          "Cliente final" NO-LABEL
     tg-itemCLI AT ROW 4.17 COL 21
     tg-itemFOR AT ROW 4.17 COL 47
     bc-ext-item-emit.it-codigo-ext-1 AT ROW 5.75 COL 33 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tg-sub-item-ext-1 AT ROW 5.75 COL 64
     bc-ext-item-emit.it-codigo-ext-2 AT ROW 6.75 COL 33 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tg-sub-item-ext-2 AT ROW 6.75 COL 64
     bc-ext-item-emit.it-codigo-ext-3 AT ROW 7.75 COL 33 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tg-sub-item-ext-3 AT ROW 7.75 COL 64
     bc-ext-item-emit.it-codigo-ext-4 AT ROW 8.75 COL 33 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tg-sub-item-ext-4 AT ROW 8.75 COL 64
     bc-ext-item-emit.imprime-etiq AT ROW 9.75 COL 35
          VIEW-AS TOGGLE-BOX
          SIZE 22.72 BY .83
     tg-sub-imp-etiq AT ROW 9.75 COL 64
     bc-ext-item-emit.qt-etiq-item AT ROW 10.75 COL 33 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tg-sub-qt-etiq-item AT ROW 10.75 COL 64
     bc-ext-item-emit.qt-etiq-total AT ROW 11.75 COL 33 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tg-sub-qt-etiq-total AT ROW 11.75 COL 64
     tg-sel-etiq AT ROW 12.75 COL 35
     bc-ext-item-emit.tipo-etiq AT ROW 13.5 COL 33 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tg-sub-tipo-etiq AT ROW 13.5 COL 64
     bc-ext-item-emit.tipo-etiq-total AT ROW 14.5 COL 33 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tg-sub-tipo-etiq-total AT ROW 14.5 COL 64
     bt-ok AT ROW 16 COL 2 HELP
          "OK"
     bt-cancela AT ROW 16 COL 13 HELP
          "Cancelar"
     bt-ajuda AT ROW 16 COL 73.14 HELP
          "Ajuda"
     c-lit-atualizacao AT ROW 3.58 COL 1 COLON-ALIGNED NO-LABEL
     IMAGE-3 AT ROW 2.25 COL 41
     IMAGE-4 AT ROW 2.29 COL 52
     IMAGE-5 AT ROW 1.25 COL 41
     IMAGE-6 AT ROW 1.29 COL 52
     RECT-4 AT ROW 1 COL 1
     RECT-5 AT ROW 5.25 COL 1
     RECT-6 AT ROW 3.96 COL 1
     rt-buttom AT ROW 15.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.43 BY 16.29
         DEFAULT-BUTTON bt-ok.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Geraá∆o Autom†tica Item/Cliente"
         HEIGHT             = 16.29
         WIDTH              = 83.43
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* SETTINGS FOR FILL-IN c-lit-atualizacao IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = YES.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Geraá∆o Autom†tica Item/Cliente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Geraá∆o Autom†tica Item/Cliente */
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
DO: /* Call Help Function (or a simple message). */
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


&Scoped-define SELF-NAME bc-ext-item-emit.imprime-etiq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bc-ext-item-emit.imprime-etiq w-window
ON VALUE-CHANGED OF bc-ext-item-emit.imprime-etiq IN FRAME F-Main /* Imprime Etiqueta? */
DO:
   DO WITH FRAME {&FRAME-NAME}:
      ASSIGN bc-ext-item-emit.qt-etiq-item:SENSITIVE    = bc-ext-item-emit.imprime-etiq:CHECKED
             bc-ext-item-emit.qt-etiq-total:SENSITIVE   = bc-ext-item-emit.imprime-etiq:CHECKED
             tg-sel-etiq:SENSITIVE                      = bc-ext-item-emit.imprime-etiq:CHECKED
             bc-ext-item-emit.tipo-etiq:SENSITIVE       = bc-ext-item-emit.imprime-etiq:CHECKED
             bc-ext-item-emit.tipo-etiq-total:SENSITIVE = bc-ext-item-emit.imprime-etiq:CHECKED
             tg-sub-qt-etiq-item:SENSITIVE              = bc-ext-item-emit.imprime-etiq:CHECKED
             tg-sub-qt-etiq-total:SENSITIVE             = bc-ext-item-emit.imprime-etiq:CHECKED.
   
      IF bc-ext-item-emit.imprime-etiq:CHECKED THEN DO:
         ASSIGN tg-sel-etiq:CHECKED                         = NO
                bc-ext-item-emit.qt-etiq-item:SCREEN-VALUE  = "1,0000"
                bc-ext-item-emit.qt-etiq-total:SCREEN-VALUE = "1,0000".
         
         APPLY "VALUE-CHANGED" TO tg-sel-etiq.
      END.
      ELSE DO:
         ASSIGN tg-sel-etiq:CHECKED                         = NO
                bc-ext-item-emit.qt-etiq-item:SCREEN-VALUE  = "0,0000"
                bc-ext-item-emit.qt-etiq-total:SCREEN-VALUE  = "0,0000".
         
         APPLY "VALUE-CHANGED" TO tg-sel-etiq.
      END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-sel-etiq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-sel-etiq w-window
ON VALUE-CHANGED OF tg-sel-etiq IN FRAME F-Main /* Seleciona Tipo Etiqueta */
DO:
   DO WITH FRAME {&FRAME-NAME}:
      ASSIGN bc-ext-item-emit.tipo-etiq:SENSITIVE       = tg-sel-etiq:CHECKED
             bc-ext-item-emit.tipo-etiq-total:SENSITIVE = tg-sel-etiq:CHECKED
             tg-sub-tipo-etiq:SENSITIVE                 = tg-sel-etiq:CHECKED
             tg-sub-tipo-etiq-total:SENSITIVE           = tg-sel-etiq:CHECKED.
   
      FIND FIRST param-bc NO-LOCK NO-ERROR.
      IF tg-sel-etiq:CHECKED AND AVAIL param-bc THEN
         ASSIGN bc-ext-item-emit.tipo-etiq:SCREEN-VALUE       = STRING(param-bc.tp-etiq-padrao)
                bc-ext-item-emit.tipo-etiq-total:SCREEN-VALUE = STRING(param-bc.tp-etiq-padrao).
      ELSE
         ASSIGN bc-ext-item-emit.tipo-etiq:SCREEN-VALUE       = "00"
                bc-ext-item-emit.tipo-etiq-total:SCREEN-VALUE = "00".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window  _DEFAULT-ENABLE
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
   DISPLAY c-item-inicial
           c-item-final
           c-cli-inicial
           c-cli-final
           tg-itemCLI 
           tg-itemFOR
           tg-sub-item-ext-1
           tg-sub-item-ext-2
           tg-sub-item-ext-3 
           tg-sub-item-ext-4
           tg-sub-imp-etiq
           tg-sub-qt-etiq-item 
           tg-sub-qt-etiq-total
           tg-sel-etiq
           tg-sub-tipo-etiq 
           tg-sub-tipo-etiq-total
           c-lit-atualizacao 
      WITH FRAME F-Main IN WINDOW w-window.
  
   IF AVAIL bc-ext-item-emit THEN 
      DISPLAY bc-ext-item-emit.it-codigo-ext-1
              bc-ext-item-emit.it-codigo-ext-2 
              bc-ext-item-emit.it-codigo-ext-3
              bc-ext-item-emit.it-codigo-ext-4 
              bc-ext-item-emit.imprime-etiq
              bc-ext-item-emit.qt-etiq-item 
              bc-ext-item-emit.qt-etiq-total
              bc-ext-item-emit.tipo-etiq 
              bc-ext-item-emit.tipo-etiq-total 
         WITH FRAME F-Main IN WINDOW w-window.
  
   ENABLE c-item-inicial
          c-item-final
          c-cli-inicial
          c-cli-final
          tg-itemCLI 
          tg-itemFOR
          bc-ext-item-emit.it-codigo-ext-1
          tg-sub-item-ext-1 
          bc-ext-item-emit.it-codigo-ext-2
          tg-sub-item-ext-2 
          bc-ext-item-emit.it-codigo-ext-3
          tg-sub-item-ext-3 
          bc-ext-item-emit.it-codigo-ext-4
          tg-sub-item-ext-4 
          bc-ext-item-emit.imprime-etiq
          tg-sub-imp-etiq 
          bc-ext-item-emit.qt-etiq-item
          tg-sub-qt-etiq-item 
          bc-ext-item-emit.qt-etiq-total
          tg-sub-qt-etiq-total
          tg-sel-etiq 
          bc-ext-item-emit.tipo-etiq
          tg-sub-tipo-etiq 
          bc-ext-item-emit.tipo-etiq-total
          tg-sub-tipo-etiq-total
          bt-ok 
          bt-cancela
          bt-ajuda
          IMAGE-3
          IMAGE-4
          IMAGE-5
          IMAGE-6
          RECT-4
          RECT-5 
          RECT-6
          rt-buttom 
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
      RUN piAtualizaChaveReg IN h-handleParam (INPUT gr-item-cli).
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

{utp/ut9000.i "BC0113A" "2.00.00.021"} /* 31/08/2023 15:08:03 */

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ).

   IF VALID-HANDLE(h-handleParam) THEN
      RUN piBloqWindow IN h-handleParam.

   DO WITH FRAME {&FRAME-NAME}:
      {utp/ut-liter.i Item * R}
      ASSIGN c-item-inicial:LABEL = TRIM(RETURN-VALUE).
      
      {utp/ut-liter.i Item_Inicial * L}
      ASSIGN c-item-inicial:HELP = TRIM(RETURN-VALUE).
      
      {utp/ut-liter.i Item_Final * L}
      ASSIGN c-item-final:HELP = TRIM(RETURN-VALUE).
      
      {utp/ut-liter.i "Nome Abreviado" * R}
      ASSIGN c-cli-inicial:LABEL = TRIM(RETURN-VALUE).
      
      {utp/ut-liter.i Cliente_Inicial * L}
      ASSIGN c-cli-inicial:HELP                    = TRIM(RETURN-VALUE).
      
      {utp/ut-liter.i Cliente_Final * L}
      ASSIGN c-cli-final:HELP                    = TRIM(RETURN-VALUE).
            
      {utp/ut-liter.i "Selecionar Tipo Etiqueta?" * L}
      ASSIGN tg-sel-etiq:LABEL   = TRIM(RETURN-VALUE)
             tg-sel-etiq:HELP    = TRIM(RETURN-VALUE)
             tg-sel-etiq:TOOLTIP = TRIM(RETURN-VALUE).
      
      {utp/ut-field.i mgcld bc-ext-item-emit qt-etiq-total 1}
      ASSIGN bc-ext-item-emit.qt-etiq-total:LABEL = TRIM(RETURN-VALUE).
      
      {utp/ut-field.i mgcld bc-ext-item-emit tipo-etiq-total 1}
      ASSIGN bc-ext-item-emit.tipo-etiq-total:LABEL = TRIM(RETURN-VALUE).
      
      {utp/ut-liter.i "Selecionar Tipo Etiqueta?" * L}
      ASSIGN tg-sel-etiq:LABEL = TRIM(RETURN-VALUE).
      
      {utp/ut-field.i mgcld bc-ext-item-emit it-codigo-ext-1 1}
      ASSIGN bc-ext-item-emit.it-codigo-ext-1:LABEL = TRIM(RETURN-VALUE).
      
      {utp/ut-field.i mgcld bc-ext-item-emit it-codigo-ext-2 1}
      ASSIGN bc-ext-item-emit.it-codigo-ext-2:LABEL = TRIM(RETURN-VALUE).
      
      {utp/ut-field.i mgcld bc-ext-item-emit it-codigo-ext-3 1}
      ASSIGN bc-ext-item-emit.it-codigo-ext-3:LABEL = TRIM(RETURN-VALUE).
      
      {utp/ut-field.i mgcld bc-ext-item-emit it-codigo-ext-4 1}
      ASSIGN bc-ext-item-emit.it-codigo-ext-4:LABEL = TRIM(RETURN-VALUE).
      
      {utp/ut-liter.i Substituir * R}
      ASSIGN tg-sub-qt-etiq-item:LABEL      = TRIM(RETURN-VALUE)
             tg-sub-qt-etiq-total:LABEL     = TRIM(RETURN-VALUE)
             tg-sub-tipo-etiq:LABEL         = TRIM(RETURN-VALUE)
             tg-sub-tipo-etiq-total:LABEL   = TRIM(RETURN-VALUE)
             tg-sub-item-ext-1:LABEL        = TRIM(RETURN-VALUE)
             tg-sub-item-ext-2:LABEL        = TRIM(RETURN-VALUE)
             tg-sub-item-ext-3:LABEL        = TRIM(RETURN-VALUE)
             tg-sub-item-ext-4:LABEL        = TRIM(RETURN-VALUE)
             tg-sub-imp-etiq:LABEL          = TRIM(RETURN-VALUE)
             tg-sub-qt-etiq-item:VISIBLE    = NOT l-atualiza
             tg-sub-qt-etiq-total:VISIBLE   = NOT l-atualiza
             tg-sub-tipo-etiq:VISIBLE       = NOT l-atualiza
             tg-sub-tipo-etiq-total:VISIBLE = NOT l-atualiza
             tg-sub-item-ext-1:VISIBLE      = NOT l-atualiza
             tg-sub-item-ext-2:VISIBLE      = NOT l-atualiza
             tg-sub-item-ext-3:VISIBLE      = NOT l-atualiza
             tg-sub-item-ext-4:VISIBLE      = NOT l-atualiza
             tg-sub-imp-etiq:VISIBLE        = NOT l-atualiza.
   
      APPLY "VALUE-CHANGED" TO bc-ext-item-emit.imprime-etiq.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign-registro w-window 
PROCEDURE pi-assign-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DO WITH FRAME {&FRAME-NAME}:
      ASSIGN bc-ext-item-emit.it-codigo-ext-1 = IF l-atualiza THEN
                                                   bc-ext-item-emit.it-codigo-ext-1:SCREEN-VALUE
                                                ELSE
                                                   IF tg-sub-item-ext-1:CHECKED THEN
                                                      bc-ext-item-emit.it-codigo-ext-1:SCREEN-VALUE
                                                   ELSE
                                                      bc-ext-item-emit.it-codigo-ext-1
             bc-ext-item-emit.it-codigo-ext-2 = IF l-atualiza THEN
                                                   bc-ext-item-emit.it-codigo-ext-2:SCREEN-VALUE
                                                ELSE
                                                   IF tg-sub-item-ext-2:CHECKED THEN
                                                      bc-ext-item-emit.it-codigo-ext-2:SCREEN-VALUE
                                                   ELSE
                                                      bc-ext-item-emit.it-codigo-ext-2   
             bc-ext-item-emit.it-codigo-ext-3 = IF l-atualiza THEN
                                                   bc-ext-item-emit.it-codigo-ext-3:SCREEN-VALUE
                                                ELSE
                                                   IF tg-sub-item-ext-3:CHECKED THEN
                                                      bc-ext-item-emit.it-codigo-ext-3:SCREEN-VALUE
                                                   ELSE
                                                      bc-ext-item-emit.it-codigo-ext-3
             bc-ext-item-emit.it-codigo-ext-4 = IF l-atualiza THEN
                                                   bc-ext-item-emit.it-codigo-ext-4:SCREEN-VALUE
                                                ELSE
                                                   IF tg-sub-item-ext-4:CHECKED THEN
                                                      bc-ext-item-emit.it-codigo-ext-4:SCREEN-VALUE
                                                   ELSE
                                                      bc-ext-item-emit.it-codigo-ext-4
             bc-ext-item-emit.tipo-etiq       = IF l-atualiza THEN
                                                   INTEGER(bc-ext-item-emit.tipo-etiq:SCREEN-VALUE)
                                                ELSE
                                                   IF tg-sub-tipo-etiq:CHECKED THEN
                                                      INTEGER(bc-ext-item-emit.tipo-etiq:SCREEN-VALUE)
                                                   ELSE
                                                      bc-ext-item-emit.tipo-etiq
             bc-ext-item-emit.tipo-etiq-total = IF l-atualiza THEN
                                                   INTEGER(bc-ext-item-emit.tipo-etiq-total:SCREEN-VALUE)
                                                ELSE
                                                   IF tg-sub-tipo-etiq-total:CHECKED THEN
                                                      INTEGER(bc-ext-item-emit.tipo-etiq-total:SCREEN-VALUE)
                                                   ELSE
                                                      bc-ext-item-emit.tipo-etiq-total
             bc-ext-item-emit.qt-etiq-item    = IF l-atualiza THEN
                                                   INTEGER(bc-ext-item-emit.qt-etiq-item:SCREEN-VALUE)
                                                ELSE
                                                   IF tg-sub-qt-etiq-item:CHECKED THEN
                                                      INTEGER(bc-ext-item-emit.qt-etiq-item:SCREEN-VALUE)
                                                   ELSE
                                                      bc-ext-item-emit.qt-etiq-item   
             bc-ext-item-emit.qt-etiq-total   = IF l-atualiza THEN
                                                   INTEGER(bc-ext-item-emit.qt-etiq-total:SCREEN-VALUE)
                                                ELSE
                                                   IF tg-sub-qt-etiq-total:CHECKED THEN
                                                      INTEGER(bc-ext-item-emit.qt-etiq-total:SCREEN-VALUE)
                                                   ELSE
                                                      bc-ext-item-emit.qt-etiq-total   
             bc-ext-item-emit.imprime-etiq    = IF l-atualiza THEN
                                                   bc-ext-item-emit.imprime-etiq:CHECKED
                                                ELSE
                                                   IF tg-sub-imp-etiq:checked THEN
                                                      bc-ext-item-emit.imprime-etiq:CHECKED
                                                   ELSE
                                                      bc-ext-item-emit.imprime-etiq
             gr-item-cli                      = ROWID(bc-ext-item-emit).
   
       IF NOT bc-ext-item-emit.imprime-etiq THEN
          ASSIGN bc-ext-item-emit.tipo-etiq       = 0
                 bc-ext-item-emit.tipo-etiq-total = 0
                 bc-ext-item-emit.qt-etiq-item    = 0
                 bc-ext-item-emit.qt-etiq-total   = 0.
   
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
   
      FIND FIRST bc-ext-item-emit NO-LOCK NO-ERROR.
      IF NOT AVAIL bc-ext-item-emit AND NOT l-atualiza THEN
         APPLY "CLOSE" TO THIS-PROCEDURE.
      ELSE DO:
         IF bc-ext-item-emit.imprime-etiq:CHECKED THEN DO:
            IF INTEGER(bc-ext-item-emit.tipo-etiq:screen-value) <> 0 THEN DO:
               FIND FIRST tipo-etiqueta
                    WHERE tipo-etiqueta.tipo-etiq = INTEGER(bc-ext-item-emit.tipo-etiq:SCREEN-VALUE) NO-LOCK NO-ERROR.
               IF NOT AVAIL tipo-etiqueta THEN DO:
                  {utp/ut-table.i mgcld tipo-etiqueta 1}
                  RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                    INPUT 56,
                                    INPUT TRIM(RETURN-VALUE)).
                  
                  APPLY "ENTRY" TO bc-ext-item-emit.tipo-etiq.
                  RETURN NO-APPLY.
               END.
            END.
   
            IF INTEGER(bc-ext-item-emit.tipo-etiq-total:SCREEN-VALUE) <> 0 THEN DO:
               FIND FIRST tipo-etiqueta
                    WHERE tipo-etiqueta.tipo-etiq = INTEGER(bc-ext-item-emit.tipo-etiq-total:SCREEN-VALUE) NO-LOCK NO-ERROR.
               IF NOT AVAIL tipo-etiqueta THEN DO:
                  {utp/ut-table.i mgcld tipo-etiqueta 1}
                  RUN utp/ut-msgs.p(INPUT "SHOW":U,
                                    INPUT 56,
                                    INPUT TRIM(RETURN-VALUE)).
                  
                  APPLY "ENTRY" TO bc-ext-item-emit.tipo-etiq-total.
                  RETURN NO-APPLY.
               END.
            END.
         END.
   
         RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
         {utp/ut-liter.i "Atualizando Extens∆o Item x Emitente" * L}
         RUN pi-inicializar IN h-acomp (INPUT TRIM(RETURN-VALUE)).
         {utp/ut-liter.i Item: * L}
   
         RUN pi-verifica-emitente (  INPUT c-cli-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                     INPUT c-cli-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                     INPUT 0,
                                     INPUT 999999999,
                                     INPUT 5,
                                     INPUT 2).   /* for each item-cli */
   
         IF NOT AVAIL ttReturnMessages THEN DO:
            FOR EACH ttEmitente:
               /* Atualizaá∆o Item x Clinte */
               IF tg-ItemCLI:CHECKED THEN DO:
                  {utp/ut-liter.i "Atualizando Item x Cliente" * L}
                  RUN pi-verifica-item-cli (  INPUT "",
                                              INPUT "",
                                              INPUT ttEmitente.Nome-abrev,
                                              INPUT ttEmitente.Nome-abrev,
                                              INPUT 5,   /* for each item-cli */
                                              INPUT 5).
   
                  FIND FIRST ttItem-cli NO-LOCK NO-ERROR.
                  IF AVAIL ttItem-cli THEN DO:
                     RUN pi-verifica-item-cli (  INPUT c-item-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                                 INPUT c-item-final  :SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                                 INPUT ttEmitente.Nome-abrev,
                                                 INPUT ttEmitente.Nome-abrev,
                                                 INPUT 5,   /* for each item-cli */
                                                 INPUT 4).
   
                     IF AVAIL ttReturnMessages THEN DO:
                        CREATE bttReturnMessages.
                        BUFFER-COPY ttReturnMessages TO bttReturnMessages NO-ERROR.
                     END.
                     ELSE DO:
                        FOR EACH ttItem-cli.
                           CREATE ttItem-emitente.
                           ASSIGN ttItem-emitente.it-codigo       = ttItem-cli.it-codigo
                                  ttItem-emitente.nome-abrev      = ttEmitente.Nome-abrev
                                  ttItem-emitente.cod-emitente    = ttItem-cli.cod-emitente
                                  ttItem-emitente.item-emitente   = ""
                                  ttItem-emitente.rowid-value     = ttItem-cli.rowid-value.
                        END.
                     END.
                  END.
               END.
               /* Atualizaá∆o Item x Forncedor */
               EMPTY TEMP-TABLE ttReturnMessages.
   
               IF tg-ItemFOR:CHECKED THEN DO:
                  {utp/ut-liter.i "Atualizando Item x Fornecedor" * L}
                  RUN pi-verifica-item-for (  INPUT "",
                                              INPUT "",
                                              INPUT ttEmitente.cod-emitente,
                                              INPUT ttEmitente.cod-emitente,
                                              INPUT 5,   /* for each item-cli */
                                              INPUT 4).
   
                  FIND FIRST ttItem-fornec NO-LOCK NO-ERROR.
                  IF AVAIL ttItem-fornec THEN DO:
                     RUN pi-verifica-item-for (  INPUT c-item-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                                 INPUT c-item-final  :SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                                 INPUT ttEmitente.cod-emitente,
                                                 INPUT ttEmitente.cod-emitente,
                                                 INPUT 5,   /* for each item-cli */
                                                 INPUT 3).
                     IF AVAIL ttReturnMessages THEN DO:
                        CREATE bttReturnMessages.
                        BUFFER-COPY ttReturnMessages TO bttReturnMessages NO-ERROR.
                     END.
                     ELSE DO:
                        FOR EACH ttItem-fornec.
                           FIND FIRST ttItem-emitente
                                WHERE ttItem-emitente.it-codigo    = ttItem-fornec.it-codigo
                                  AND ttItem-emitente.cod-emitente = ttItem-fornec.cod-emitente NO-LOCK NO-ERROR.
                           IF NOT AVAIL ttItem-emitente THEN DO:
                              CREATE ttItem-emitente.
                              ASSIGN ttItem-emitente.it-codigo     = ttItem-fornec.it-codigo
                                     ttItem-emitente.nome-abrev    = ttEmitente.Nome-abrev
                                     ttItem-emitente.cod-emitente  = ttItem-fornec.cod-emitente
                                     ttItem-emitente.item-emitente = ttItem-fornec.item-do-forn
                                     ttItem-emitente.rowid-value   = ttItem-fornec.rowid-value.
                           END.
                        END.
                     END.
                  END.
               END.
            END.
            EMPTY TEMP-TABLE ttReturnMessages.
   
            FOR EACH ttItem-emitente:
               RUN pi-acompanhar IN h-acomp (INPUT TRIM(RETURN-VALUE) + " " + ttItem-emitente.it-codigo).
   
               FIND FIRST bc-ext-item-emit
                    WHERE bc-ext-item-emit.cod-emitente = ttItem-emitente.cod-emitente
                      AND bc-ext-item-emit.it-codigo    = ttItem-emitente.it-codigo EXCLUSIVE-LOCK NO-ERROR.   
               IF NOT AVAIL bc-ext-item-emit AND l-atualiza THEN DO:     /* somente gera novo registro */
                  CREATE bc-ext-item-emit.
                  ASSIGN bc-ext-item-emit.it-codigo    = ttItem-emitente.it-codigo
                         bc-ext-item-emit.nome-abrev   = ttItem-emitente.Nome-abrev
                         bc-ext-item-emit.cod-emitente = ttItem-emitente.cod-emitente.
               END.
               ELSE
                  IF l-atualiza THEN
                     NEXT.
   
               IF NOT AVAIL bc-ext-item-emit AND NOT l-atualiza THEN
                  NEXT.
   
               RUN pi-assign-registro.   
            END.
         END.
   
         FIND FIRST bttReturnMessages NO-LOCK NO-ERROR.
         IF AVAIL bttReturnMessages THEN DO:   
            OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "bc0113a.txt").
            DEFINE VARIABLE c-lbl-liter-erros-ocorridos-na-atualizacao AS CHARACTER FORMAT "X(50)" NO-UNDO.
            {utp/ut-liter.i "Erros_ocorridos_na_Atualizaá∆o_Item_x_Emitentes" *}
            ASSIGN c-lbl-liter-erros-ocorridos-na-atualizacao = TRIM(RETURN-VALUE).

            PUT "===================================================================================================="
                SKIP
                STRING(TODAY,"99/99/9999")
                SPACE(05)
                STRING(TIME,"HH:MM:SS")
                SPACE(05)
                c-lbl-liter-erros-ocorridos-na-atualizacao + "."
                SKIP.
                FOR EACH bttReturnMessages:
                    PUT " *** " 
                        bttReturnMessages.CodErro
                        SPACE(05)
                        bttReturnMessages.DesErro
                        SPACE(05)
                        bttReturnMessages.Local
                        SPACE(05)
                        bttReturnMessages.Type
                        SPACE(05)
                        bttReturnMessages.Parameters
                        SKIP.
                END.
            OUTPUT CLOSE.

            {utp/ut-liter.i "Ocorreram_erros_na_geraá∆o,_verificar_arquivo" *}
            RUN utp/ut-msgs.p(INPUT "SHOW":U,
                              INPUT 17567, 
                              INPUT RETURN-VALUE + ":" + SESSION:TEMP-DIRECTORY + "bc0113a.txt").
   
         END.   
         RUN pi-finalizar IN h-acomp.   
         APPLY "CLOSE" TO THIS-PROCEDURE. 
      END.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window  _ADM-SEND-RECORDS
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
