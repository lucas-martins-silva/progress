&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V04IN373 2.00.01.002}  /*** 010102 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v04in373 MUT}
&ENDIF

/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

def new global shared var gr-recurso as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---      */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cap-rec-estab
&Scoped-define FIRST-EXTERNAL-TABLE cap-rec-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cap-rec-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cap-rec-estab.dt-efetivacao ~
cap-rec-estab.cod-estabel cap-rec-estab.carga-minima ~
cap-rec-estab.sobrecarga cap-rec-estab.capacidade-dia 
&Scoped-define ENABLED-TABLES cap-rec-estab
&Scoped-define FIRST-ENABLED-TABLE cap-rec-estab
&Scoped-define DISPLAYED-TABLES cap-rec-estab
&Scoped-define FIRST-DISPLAYED-TABLE cap-rec-estab
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS cap-rec-estab.dt-efetivacao ~
cap-rec-estab.cod-estabel cap-rec-estab.carga-minima ~
cap-rec-estab.sobrecarga cap-rec-estab.capacidade-dia 
&Scoped-Define DISPLAYED-OBJECTS c-tp-recurso c-cd-recurso fi-fator-setup 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cd-recurso AS CHARACTER FORMAT "x(16)" 
     LABEL "":R9 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE c-tp-recurso AS CHARACTER FORMAT "x(5)" 
     LABEL "":R15 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88.

DEFINE VARIABLE fi-fator-setup AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Setup (%)" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75 BY 3.33.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75 BY 5.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-tp-recurso AT ROW 1.17 COL 25 COLON-ALIGNED
     c-cd-recurso AT ROW 2.17 COL 25 COLON-ALIGNED
     cap-rec-estab.dt-efetivacao AT ROW 3.25 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     cap-rec-estab.cod-estabel AT ROW 4.5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     cap-rec-estab.carga-minima AT ROW 5.5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cap-rec-estab.sobrecarga AT ROW 6.5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-fator-setup AT ROW 7.5 COL 25 COLON-ALIGNED
     cap-rec-estab.capacidade-dia AT ROW 8.5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.cap-rec-estab
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 8.71
         WIDTH              = 75.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R,COLUMNS                               */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cd-recurso IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-recurso IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-fator-setup IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cap-rec-estab.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cap-rec-estab.cod-estabel V-table-Win
ON F5 OF cap-rec-estab.cod-estabel IN FRAME f-main /* Estab */
DO:
   {include/zoomvar.i &prog-zoom=inzoom/z01in329.w
                      &campo=cap-rec-estab.cod-estabel
                      &campozoom=cod-estabel}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cap-rec-estab.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cap-rec-estab.cod-estabel IN FRAME f-main /* Estab */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
{utp/ut-field.i mgind recurso tp-recurso 1}
assign c-tp-recurso:label = return-value.

{utp/ut-field.i mgind recurso cd-recurso 1}
assign c-cd-recurso:label = return-value.

if cap-rec-estab.cod-estabel:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "cap-rec-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cap-rec-estab"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  assign cap-rec-estab.dt-efetivacao:screen-value in frame {&frame-name} = string(today).
  if avail recurso then do:
     assign c-tp-recurso:screen-value in frame {&frame-name}           = recurso.tp-recurso
            c-cd-recurso:screen-value in frame {&frame-name}           = recurso.cd-recurso
            cap-rec-estab.carga-minima:screen-value in frame {&frame-name}   = string(recurso.carga-minima)
            cap-rec-estab.sobrecarga:screen-value in frame {&frame-name}     = string(recurso.sobrecarga) 
            cap-rec-estab.capacidade-dia:screen-value in frame {&frame-name} = string(recurso.qtd-capac-nominal).

     for first tp-recur fields (cl-recurso) use-index tipo no-lock where
              tp-recur.tp-recurso = recurso.tp-recurso:

        if tp-recur.cl-recurso = 1 or
           tp-recur.cl-recurso = 3 or
           tp-recur.cl-recurso = 4 then
            assign fi-fator-setup:sensitive    in frame {&frame-name} = true
                   fi-fator-setup:screen-value in frame {&frame-name} = if not adm-new-record then string(cap-rec.dec-1)
                                                                                              else string(1).
        else
            assign fi-fator-setup:sensitive in frame {&frame-name} = false.

    end.

  end.

 /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  def var de-fator-setup as dec no-undo.

  /* Ponha aqui a valida‡Æo de chave duplicada */
  find cap-rec-estab where cap-rec-estab.cod-estabel = input frame {&frame-name} cap-rec-estab.cod-estabel
               and   cap-rec-estab.tp-recurso    = c-tp-recurso 
               and   cap-rec-estab.cd-recurso    = c-cd-recurso
               and   cap-rec-estab.dt-efetivacao = input frame {&frame-name} cap-rec-estab.dt-efetivacao no-lock no-error.
  if avail cap-rec-estab then do:
     {utp/ut-table.i mgind cap-rec-estab 1}
     run utp/ut-msgs.p (input "show",
                        input 7,  
                        input return-value).
     apply "entry" to cap-rec-estab.dt-efetivacao in frame {&frame-name}.
     return 'ADM-ERROR':U.     
  end.

  /* Ponha aqui as demais valida‡äes */
  if input dt-efetivacao = ? then do:
     {utp/ut-field.i mgind cap-rec-estab dt-efetivacao 1}
     run utp/ut-msgs.p (input "show",
                        input 164,
                        input return-value).
     apply "entry" to cap-rec-estab.dt-efetivacao in frame {&frame-name}.
     return 'ADM-ERROR':U.     
  end.

  find mpm-estabel where mpm-estabel.cod-estabel = 
       input frame {&frame-name} cap-rec-estab.cod-estabel no-lock no-error.
  if not avail mpm-estabel then do:
     run utp/ut-msgs.p (input "show",
                        input 8100,
                        input "").
     apply "entry" to cap-rec-estab.cod-estabel in frame {&frame-name}.
     return 'ADM-ERROR':U.     
  end.

  if not mpm-estabel.log-fabrica then do:
     run utp/ut-msgs.p (input "show",
                        input 8103,
                        input "").
     apply "entry" to cap-rec-estab.cod-estabel in frame {&frame-name}.
     return 'ADM-ERROR':U.    
  end.

  if (tp-recur.cl-recurso = 1 or
      tp-recur.cl-recurso = 3 or
      tp-recur.cl-recurso = 4) and
     input frame {&frame-name} fi-fator-setup >= 100 then do:
      run utp/ut-liter.p (input "Fator_de_Setup", "*", "").
      run utp/ut-msgs.p (input "show",
                         input 25495,
                         input  Return-value + "~~100%" ).
      apply "entry" to fi-fator-setup in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.

  assign de-fator-setup = input frame {&frame-name} fi-fator-setup.

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

if tp-recur.cl-recurso = 1 or
   tp-recur.cl-recurso = 3 or
   tp-recur.cl-recurso = 4 then
    assign cap-rec-estab.dec-1 = de-fator-setup.

  /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .
  find recurso no-lock where rowid(recurso) = gr-recurso no-error.
  if available recurso then do:
     assign cap-rec-estab.tp-recurso = recurso.tp-recurso
            cap-rec-estab.cd-recurso = recurso.cd-recurso.
  end.
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  find recurso no-lock where rowid(recurso) = gr-recurso no-error.
  if avail recurso then do:
     assign c-tp-recurso = recurso.tp-recurso
            c-cd-recurso = recurso.cd-recurso.
  end.
  else do:
     {utp/ut-table.i mgind tp-recur 1} 
     run utp/ut-msgs.p (input "show",
                        input 56,
                        input return-value).
     return 'ADM-ERROR'.
  end.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cap-rec-estab"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

