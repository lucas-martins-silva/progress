&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
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
{include/i-prgvrs.i V03IN373 2.00.01.001}  /*** 010101 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN373 MUT}
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
&Scoped-define EXTERNAL-TABLES cap-rec
&Scoped-define FIRST-EXTERNAL-TABLE cap-rec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cap-rec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cap-rec.dt-efetivacao cap-rec.carga-minima ~
cap-rec.sobrecarga cap-rec.capacidade-dia cap-rec.observacao 
&Scoped-define ENABLED-TABLES cap-rec
&Scoped-define FIRST-ENABLED-TABLE cap-rec
&Scoped-define DISPLAYED-TABLES cap-rec
&Scoped-define FIRST-DISPLAYED-TABLE cap-rec
&Scoped-Define ENABLED-OBJECTS fi-fator-setup rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS cap-rec.dt-efetivacao cap-rec.carga-minima ~
cap-rec.sobrecarga cap-rec.capacidade-dia cap-rec.observacao 
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

DEFINE VARIABLE c-tp-recurso AS CHARACTER FORMAT "x(5)" INITIAL "GM" 
     LABEL "":R15 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88.

DEFINE VARIABLE fi-fator-setup AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Setup (%)" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75 BY 5.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-tp-recurso AT ROW 1.17 COL 25 COLON-ALIGNED
     c-cd-recurso AT ROW 2.17 COL 25 COLON-ALIGNED
     cap-rec.dt-efetivacao AT ROW 3.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     cap-rec.carga-minima AT ROW 4.5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cap-rec.sobrecarga AT ROW 5.5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-fator-setup AT ROW 6.5 COL 25 COLON-ALIGNED
     cap-rec.capacidade-dia AT ROW 7.5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     cap-rec.observacao AT ROW 8.5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 36.14 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.cap-rec
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
         HEIGHT             = 8.63
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
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
{utp/ut-field.i mgind recurso tp-recurso 1}
assign c-tp-recurso:label = return-value.

{utp/ut-field.i mgind recurso cd-recurso 1}
assign c-cd-recurso:label = return-value.

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
  {src/adm/template/row-list.i "cap-rec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cap-rec"}

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
  assign cap-rec.dt-efetivacao:screen-value in frame {&frame-name} = string(today).
  if avail recurso then do:
     assign c-tp-recurso:screen-value in frame {&frame-name}           = recurso.tp-recurso
            c-cd-recurso:screen-value in frame {&frame-name}           = recurso.cd-recurso
            cap-rec.carga-minima:screen-value in frame {&frame-name}   = string(recurso.carga-minima)
            cap-rec.sobrecarga:screen-value in frame {&frame-name}     = string(recurso.sobrecarga) 
            cap-rec.capacidade-dia:screen-value in frame {&frame-name} = string(recurso.qtd-capac-nominal).

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
  find cap-rec where cap-rec.tp-recurso    = c-tp-recurso 
               and   cap-rec.cd-recurso    = c-cd-recurso
               and   cap-rec.dt-efetivacao = input frame {&frame-name} cap-rec.dt-efetivacao no-lock no-error.
  if avail cap-rec then do:
     {utp/ut-table.i mgind cap-rec 1}
     run utp/ut-msgs.p (input "show",
                        input 7,  
                        input return-value).
     apply "entry" to cap-rec.dt-efetivacao in frame {&frame-name}.
     return 'ADM-ERROR':U.     
  end.

  /* Ponha aqui as demais valida‡äes */
  if input dt-efetivacao = ? then do:
     {utp/ut-field.i mgind cap-rec dt-efetivacao 1}
     run utp/ut-msgs.p (input "show",
                        input 164,
                        input return-value).
     apply "entry" to cap-rec.dt-efetivacao in frame {&frame-name}.
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

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  assign de-fator-setup = input frame {&frame-name} fi-fator-setup.

  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

if tp-recur.cl-recurso = 1 or
   tp-recur.cl-recurso = 3 or
   tp-recur.cl-recurso = 4 then
    assign cap-rec.dec-1 = de-fator-setup.

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
     assign cap-rec.tp-recurso = recurso.tp-recurso
            cap-rec.cd-recurso = recurso.cd-recurso.
  end.
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

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
  {src/adm/template/snd-list.i "cap-rec"}

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

