&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i IM0994C1 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0994c1 MIM}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{imp/im0994c.i1}

DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-impto-docto.
DEF INPUT  PARAMETER p-rw-docum-est AS ROWID   NO-UNDO.
DEF INPUT  PARAMETER p-cdn-imposto  AS INTEGER NO-UNDO.
DEF INPUT  PARAMETER p-acao         AS CHAR    NO-UNDO.
DEF OUTPUT PARAMETER p-new-imposto  AS INTEGER NO-UNDO.
DEF OUTPUT PARAMETER p-ok           AS LOGICAL NO-UNDO.

{inbo/boin759.i tt-impto-item-docto}

DEFINE VARIABLE h-boar2061 AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 fi-cdn-imposto val-impto-merc-ext ~
bt-ok bt-cancelar bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS fi-cdn-imposto fi-descricao perc-imposto ~
val-impto-merc-ext 

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

DEFINE VARIABLE fi-cdn-imposto LIKE impto-item-docto.cdn-imposto
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE perc-imposto LIKE impto-item-docto.perc-imposto
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE val-impto-merc-ext LIKE impto-item-docto.val-impto-merc-ext
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 70.72 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fi-cdn-imposto AT ROW 1.42 COL 18.72 COLON-ALIGNED HELP
          "" FORMAT ">>>9"
     fi-descricao AT ROW 1.42 COL 27 COLON-ALIGNED NO-LABEL
     perc-imposto AT ROW 2.38 COL 18.72 COLON-ALIGNED HELP
          ""
     val-impto-merc-ext AT ROW 3.33 COL 18.72 COLON-ALIGNED HELP
          ""
     bt-ok AT ROW 4.83 COL 2.72
     bt-cancelar AT ROW 4.83 COL 13.72
     bt-ajuda AT ROW 4.83 COL 61.86
     RECT-1 AT ROW 4.63 COL 1.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.43 BY 5.5.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert Custom SmartWindow title>"
         HEIGHT             = 5.5
         WIDTH              = 72.43
         MAX-HEIGHT         = 21.13
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.13
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-cdn-imposto IN FRAME F-Main
   LIKE = mgmov.impto-item-docto.cdn-imposto EXP-FORMAT                 */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN perc-imposto IN FRAME F-Main
   NO-ENABLE LIKE = mgmov.impto-item-docto. EXP-SIZE                    */
/* SETTINGS FOR FILL-IN val-impto-merc-ext IN FRAME F-Main
   LIKE = mgmov.impto-item-docto. EXP-SIZE                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* <insert Custom SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* <insert Custom SmartWindow title> */
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
  ASSIGN p-ok = NO.
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
  IF p-acao = "add":U AND 
     CAN-FIND(FIRST tt-impto-docto
              WHERE tt-impto-docto.cdn-imposto = INPUT FRAME {&FRAME-NAME} fi-cdn-imposto) THEN DO:
      {utp/ut-liter.i Imposto *}
      RUN utp/ut-msgs.p (INPUT "show":U,
                         INPUT 1,
                         INPUT RETURN-VALUE).
      RETURN NO-APPLY.
  END.

  FIND FIRST tipo-tax NO-LOCK
       WHERE tipo-tax.cod-tax = INPUT FRAME {&FRAME-NAME} fi-cdn-imposto NO-ERROR.
  IF NOT AVAIL tipo-tax THEN DO:
      {utp/ut-liter.i Imposto *}
      RUN utp/ut-msgs.p (INPUT "show":U,
                         INPUT 2,
                         INPUT RETURN-VALUE).
      RETURN NO-APPLY.
  END.

  IF INPUT FRAME {&FRAME-NAME} val-impto-merc-ext = 0 AND tipo-tax.tipo <> 2 THEN DO:
     {utp/ut-liter.i Valor * C}
     RUN utp/ut-msgs.p (INPUT "show",
                        INPUT 4323,
                        INPUT TRIM(RETURN-VALUE)).
     APPLY 'entry' TO val-impto-merc-ext IN FRAME {&FRAME-NAME}.
     RETURN NO-APPLY.
  END.

  IF INPUT FRAME {&FRAME-NAME} perc-imposto = 0       AND tipo-tax.tipo <> 2 THEN DO:
     {utp/ut-liter.i Percentual * C}
     RUN utp/ut-msgs.p (INPUT "show",
                        INPUT 4323,
                        INPUT TRIM(RETURN-VALUE)).
     APPLY 'entry' TO perc-imposto IN FRAME {&FRAME-NAME}.
     RETURN NO-APPLY.
  END.

  IF p-acao = "add":U THEN
      CREATE tt-impto-docto.

  ASSIGN tt-impto-docto.cdn-imposto        = INPUT FRAME {&FRAME-NAME} fi-cdn-imposto
         tt-impto-docto.descricao          = INPUT FRAME {&FRAME-NAME} fi-descricao
         tt-impto-docto.perc-imposto       = INPUT FRAME {&FRAME-NAME} perc-imposto
         tt-impto-docto.val-impto-merc-ext = INPUT FRAME {&FRAME-NAME} val-impto-merc-ext.

  ASSIGN p-new-imposto = tt-impto-docto.cdn-imposto
         p-ok          = YES.
  apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cdn-imposto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-imposto w-window
ON F5 OF fi-cdn-imposto IN FRAME F-Main /* C¢digo Imposto */
DO:
   {include/zoomvar.i &prog-zoom="dizoom/z01di217.w"
                      &campo=fi-cdn-imposto
                      &campozoom=cod-tax}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-imposto w-window
ON LEAVE OF fi-cdn-imposto IN FRAME F-Main /* C¢digo Imposto */
DO:
  FIND FIRST tipo-tax 
       WHERE tipo-tax.cod-tax = INPUT FRAME {&FRAME-NAME} fi-cdn-imposto NO-LOCK NO-ERROR.
  IF  AVAIL tipo-tax THEN
  DO:
      IF i-pais-impto-usuario = 2 /* Argentina */  AND tipo-tax.perc-percepcao <> 0 THEN

          ASSIGN fi-descricao = tipo-tax.descricao
              perc-imposto = tipo-tax.perc-percepcao. 
      ELSE
          ASSIGN fi-descricao = tipo-tax.descricao
              perc-imposto = tipo-tax.tax-perc.
  END.
  ELSE
      ASSIGN fi-descricao = "":u
             perc-imposto = 0.
  
  DISP fi-descricao perc-imposto WITH FRAME {&FRAME-NAME}.
  
  APPLY "LEAVE":U TO perc-imposto IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-imposto w-window
ON MOUSE-SELECT-DBLCLICK OF fi-cdn-imposto IN FRAME F-Main /* C¢digo Imposto */
DO:
  APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME perc-imposto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL perc-imposto w-window
ON LEAVE OF perc-imposto IN FRAME F-Main /* % Imposto */
DO:
  DEFINE VARIABLE de-vl-base-calc  AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE de-vl-imposto    AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE de-vl-imposto-me AS DECIMAL     NO-UNDO.
  
  FOR EACH tt-impto-item-docto:
      DELETE tt-impto-item-docto.
  END.
  FOR EACH impto-item-docto NO-LOCK OF docum-est:
      
      IF NOT CAN-FIND(FIRST tt-impto-item-docto
                      WHERE tt-impto-item-docto.cdn-imposto = impto-item-docto.cdn-imposto) THEN
    
          CREATE tt-impto-item-docto.
      ELSE
      FOR FIRST tt-impto-item-docto
          WHERE tt-impto-item-docto.cdn-imposto = impto-item-docto.cdn-imposto: END.

      BUFFER-COPY impto-item-docto EXCEPT impto-item-docto.val-impto-merc-ext impto-item-docto.val-impto TO tt-impto-item-docto.

      ASSIGN tt-impto-item-docto.val-impto-merc-ext = tt-impto-item-docto.val-impto-merc-ext + impto-item-docto.val-impto-merc-ext
             tt-impto-item-docto.val-impto = tt-impto-item-docto.val-impto + impto-item-docto.val-impto-merc-ext.

  END.

  IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
      IF  VALID-HANDLE(h-boar2061) THEN
          RUN validaImposto IN h-boar2061(INPUT ROWID(docum-est), 
                                          INPUT fi-cdn-imposto,
                                          OUTPUT de-vl-imposto-me).
  END.
  ELSE
  DO:
     RUN rep/re0412.p(INPUT docum-est.valor-mercad-me,
                      INPUT docum-est.tot-desconto-me,
                      INPUT INPUT FRAME {&FRAME-NAME} fi-cdn-imposto,
                      INPUT INPUT FRAME {&FRAME-NAME} perc-imposto,
                      INPUT TABLE tt-impto-item-docto,
                      INPUT docum-est.mo-codigo,
                      INPUT docum-est.cotacao-dia,
                      OUTPUT de-vl-base-calc,
                      OUTPUT de-vl-imposto,
                      OUTPUT de-vl-imposto-me).

     

  END.

  ASSIGN val-impto-merc-ext = de-vl-imposto-me.

  DISP val-impto-merc-ext WITH FRAME {&FRAME-NAME}.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */
fi-cdn-imposto:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&FRAME-NAME}.

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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
  THEN DELETE WIDGET w-window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
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
  DISPLAY fi-cdn-imposto fi-descricao perc-imposto val-impto-merc-ext 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE RECT-1 fi-cdn-imposto val-impto-merc-ext bt-ok bt-cancelar bt-ajuda 
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
  {include/win-size.i}
  
{utp/ut9000.i "IM0994C1" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF p-acao = "mod":U THEN DO:
     FIND FIRST tt-impto-docto 
          WHERE tt-impto-docto.cdn-imposto = p-cdn-imposto NO-ERROR.
     ASSIGN fi-cdn-imposto     = tt-impto-docto.cdn-imposto
            fi-descricao       = tt-impto-docto.descricao
            perc-imposto       = tt-impto-docto.perc-imposto
            val-impto-merc-ext = tt-impto-docto.val-impto-merc-ext.
  END.
  ELSE DO:
     ASSIGN fi-cdn-imposto     = 0
            fi-descricao       = "":U
            perc-imposto       = 0
            val-impto-merc-ext = 0.
  END.

  FIND FIRST docum-est NO-LOCK 
       WHERE ROWID(docum-est) = p-rw-docum-est NO-ERROR.
  IF NOT AVAIL docum-est THEN
     APPLY "close":U TO THIS-PROCEDURE.
  
  IF i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
     IF  NOT VALID-HANDLE(h-boar2061) THEN
         RUN local/arg/boar2061.p PERSISTENT SET h-boar2061.
  END.

  DISP fi-cdn-imposto     
       fi-descricao       
       perc-imposto       
       val-impto-merc-ext 
     WITH FRAME {&FRAME-NAME}.

  IF p-acao = "mod":U THEN
     ASSIGN fi-cdn-imposto:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  


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
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

