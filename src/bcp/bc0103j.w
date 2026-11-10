&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
{include/i-prgvrs.i BC0103J 2.00.00.002} /*** "010002" 07/11/2023 07:39:58  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0103J MBC}
&ENDIF

{include/i_fncrowid.i}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-lay-ems AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-imp-ems AS CHARACTER NO-UNDO.

&IF {&ROWID_READY} = YES &THEN
    DEFINE NEW GLOBAL SHARED VAR v_rec_layout_impres AS ROWID NO-UNDO.
&ELSE
    DEFINE NEW GLOBAL SHARED VAR v_rec_layout_impres AS RECID NO-UNDO.
&ENDIF

{include/i_dbvers.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS i-tipo-etiq fi-impres-ems fi-layout-ems ~
bt-ok bt-cancelar bt-ajuda RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS i-tipo-etiq fi-impres-ems fi-layout-ems 

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

DEFINE VARIABLE fi-impres-ems AS CHARACTER FORMAT "X(256)":U 
     LABEL "Impressora EMS" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE fi-layout-ems AS CHARACTER FORMAT "X(256)":U 
     LABEL "Layout Impress∆o" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE i-tipo-etiq AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Tipo Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 77.86 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 78 BY 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     i-tipo-etiq AT ROW 1.5 COL 19.86 COLON-ALIGNED
     fi-impres-ems AT ROW 2.5 COL 19.86 COLON-ALIGNED
     fi-layout-ems AT ROW 3.5 COL 19.86 COLON-ALIGNED
     bt-ok AT ROW 5.38 COL 2
     bt-cancelar AT ROW 5.38 COL 13
     bt-ajuda AT ROW 5.38 COL 68
     RECT-1 AT ROW 5.17 COL 1
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 12.58.


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
         TITLE              = "<insert Custom SmartWindow title>"
         HEIGHT             = 5.71
         WIDTH              = 78.86
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
{bcp/bc0103.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
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
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
   DO WITH FRAME {&frame-name}:

      FIND FIRST tipo-etiqueta
           WHERE tipo-etiqueta.tipo-etiq = INTEGER(i-tipo-etiq:SCREEN-VALUE) NO-LOCK NO-ERROR.
      IF AVAIL tipo-etiqueta THEN DO:
         ASSIGN c-lay-ems = ENTRY(1, tipo-etiqueta.char-1, CHR(10))
                c-imp-ems = (IF NUM-ENTRIES (tipo-etiqueta.char-1, CHR(10)) = 2 THEN ENTRY (2, tipo-etiqueta.char-1, CHR(10)) ELSE '':U).
         IF TRIM(c-lay-ems) <> "":U  OR TRIM(c-imp-ems) <> "":U THEN DO: /* Destino = 2 - Impressora */
                
            /* Usa procedure do include bc0103.i para validar campos */
            RUN pi-valida-impressao-ems (fi-impres-ems:SCREEN-VALUE,
                                         fi-layout-ems:SCREEN-VALUE).
            IF RETURN-VALUE = 'NOK':U THEN DO:
               APPLY 'entry' TO fi-impres-ems IN FRAME {&FRAME-NAME}.                   
               RETURN NO-APPLY.
            END.

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 28347,
                               INPUT i-tipo-etiq:SCREEN-VALUE + "~~" + fi-impres-ems:SCREEN-VALUE + "~~" + fi-layout-ems:SCREEN-VALUE).
            IF RETURN-VALUE = "YES" THEN DO:

               FIND FIRST tipo-etiqueta
                    WHERE tipo-etiqueta.tipo-etiq = INTEGER(i-tipo-etiq:SCREEN-VALUE) EXCLUSIVE-LOCK NO-ERROR.
                
               ASSIGN tipo-etiqueta.cod-layout-impres  = TRIM(fi-layout-ems:SCREEN-VALUE)
                      tipo-etiqueta.cod-impressora     = TRIM(fi-impres-ems:SCREEN-VALUE)
                      tipo-etiqueta.documento-layout   = '':U
                      tipo-etiqueta.impressora-windows = '':U.

            END.
            ELSE DO:
               APPLY "ENTRY" TO i-tipo-etiq IN FRAME {&FRAME-NAME}.
               RETURN NO-APPLY.
            END.
         END.
         ELSE DO:
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 28346,
                               INPUT i-tipo-etiq:SCREEN-VALUE).
            APPLY "ENTRY" TO i-tipo-etiq IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
         END.
      END.
      ELSE DO:
         {utp/ut-table.i mgcld tipo-etiqueta 1}
         run utp/ut-msgs.p (INPUT "SHOW",
                            INPUT 2,
                            INPUT TRIM(RETURN-VALUE)).
         APPLY "ENTRY" TO i-tipo-etiq IN FRAME {&FRAME-NAME}.
         RETURN NO-APPLY.
      END.
   END.
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-impres-ems
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-impres-ems w-window
ON F5 OF fi-impres-ems IN FRAME F-Main /* Impressora EMS */
DO:
   RUN BTB/btb036ka.w /*prg_sea_layout_impres*/.
   IF v_rec_layout_impres <> ? THEN DO WITH FRAME {&frame-name}:
      &IF {&ROWID_READY} = YES &THEN
         FIND FIRST layout_impres
              WHERE ROWID(layout_impres) = v_rec_layout_impres NO-LOCK NO-ERROR.
      &ELSE
         FIND FIRST layout_impres
              WHERE RECID(layout_impres) = v_rec_layout_impres NO-LOCK NO-ERROR.
      &ENDIF

      fi-impres-ems:SCREEN-VALUE = layout_impres.nom_impressora.
      fi-layout-ems:SCREEN-VALUE = layout_impres.cod_layout_impres.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-impres-ems w-window
ON MOUSE-SELECT-DBLCLICK OF fi-impres-ems IN FRAME F-Main /* Impressora EMS */
DO:
   APPLY 'F5':U TO fi-impres-ems IN FRAME {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-layout-ems
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-layout-ems w-window
ON F5 OF fi-layout-ems IN FRAME F-Main /* Layout Impress∆o */
DO: 
   RUN BTB/btb036ka.w /*prg_sea_layout_impres*/.
   IF v_rec_layout_impres <> ? THEN DO WITH FRAME {&frame-name}:
      &IF {&ROWID_READY} = YES &THEN
         FIND FIRST layout_impres
              WHERE ROWID(layout_impres) = v_rec_layout_impres NO-LOCK NO-ERROR.
      &ELSE
         FIND FIRST layout_impres
              WHERE RECID(layout_impres) = v_rec_layout_impres NO-LOCK NO-ERROR.
      &ENDIF

      fi-impres-ems:SCREEN-VALUE = layout_impres.nom_impressora.
      fi-layout-ems:SCREEN-VALUE = layout_impres.cod_layout_impres.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-layout-ems w-window
ON MOUSE-SELECT-DBLCLICK OF fi-layout-ems IN FRAME F-Main /* Layout Impress∆o */
DO:
   APPLY 'F5':U TO fi-layout-ems IN FRAME {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-tipo-etiq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tipo-etiq w-window
ON F5 OF i-tipo-etiq IN FRAME F-Main /* Tipo Etiqueta */
DO:
   {include/zoomvar.i &prog-zoom = "clzoom/z01cl015.w"
                      &campo=i-tipo-etiq
                      &campozoom=tipo-etiq
                      &frame={&FRAME-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tipo-etiq w-window
ON LEAVE OF i-tipo-etiq IN FRAME F-Main /* Tipo Etiqueta */
DO:
   FIND FIRST tipo-etiqueta
        WHERE tipo-etiqueta.tipo-etiq = INTEGER(i-tipo-etiq:SCREEN-VALUE) NO-LOCK NO-ERROR.
   IF AVAIL tipo-etiqueta THEN DO:
      ASSIGN fi-layout-ems:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(1, tipo-etiqueta.char-1, CHR(10))
             fi-impres-ems:SCREEN-VALUE IN FRAME {&FRAME-NAME} = (IF NUM-ENTRIES(tipo-etiqueta.char-1, CHR(10)) = 2 THEN ENTRY(2, tipo-etiqueta.char-1, CHR(10)) ELSE "":U).
   END.
   ELSE DO:
      ASSIGN fi-layout-ems:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U
             fi-impres-ems:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tipo-etiq w-window
ON MOUSE-SELECT-DBLCLICK OF i-tipo-etiq IN FRAME F-Main /* Tipo Etiqueta */
DO:
   APPLY 'F5':U TO i-tipo-etiq IN FRAME {&frame-name}.
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
  DISPLAY i-tipo-etiq fi-impres-ems fi-layout-ems 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE i-tipo-etiq fi-impres-ems fi-layout-ems bt-ok bt-cancelar bt-ajuda 
         RECT-1 RECT-2 
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
  
{utp/ut9000.i "BC0103J" "2.00.00.002"} /* 07/11/2023 07:39:58 */
   
   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

   /* Code placed here will execute AFTER standard behavior.    */

   DO WITH FRAME  {&frame-name}:
      /* fi-layout-ems:screen-value = p-layout-ems.
      fi-impres-ems:screen-value = p-impres-ems. */
      fi-layout-ems:LOAD-MOUSE-POINTER("image/lupa.cur":U).
      fi-impres-ems:LOAD-MOUSE-POINTER("image/lupa.cur":U).
      i-tipo-etiq:LOAD-MOUSE-POINTER("image/lupa.cur":U).
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
   DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
   DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

