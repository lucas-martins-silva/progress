&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V07AD057 2.00.00.013}  /*** "010013" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v07ad057 MUT}
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

/* Definicao TTs e Variaveis - Validacao Decimais - chile */
{cdp/cd1234.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cta-corrente
&Scoped-define FIRST-EXTERNAL-TABLE cta-corrente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cta-corrente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cta-corrente.cod-estabel cta-corrente.cod-mod ~
cta-corrente.data-saldo cta-corrente.saldo-ini cta-corrente.saldo-atual ~
cta-corrente.gera-disponivel 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-estabel ~{&FP2}cod-estabel ~{&FP3}~
 ~{&FP1}cod-mod ~{&FP2}cod-mod ~{&FP3}~
 ~{&FP1}data-saldo ~{&FP2}data-saldo ~{&FP3}~
 ~{&FP1}saldo-ini ~{&FP2}saldo-ini ~{&FP3}~
 ~{&FP1}saldo-atual ~{&FP2}saldo-atual ~{&FP3}
&Scoped-define ENABLED-TABLES cta-corrente
&Scoped-define FIRST-ENABLED-TABLE cta-corrente
&Scoped-Define DISPLAYED-FIELDS cta-corrente.cod-estabel ~
cta-corrente.cod-mod cta-corrente.data-saldo cta-corrente.saldo-ini ~
cta-corrente.saldo-atual cta-corrente.gera-disponivel 
&Scoped-Define DISPLAYED-OBJECTS c-desc-estab c-desc-mod 

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
DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-mod AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cta-corrente.cod-estabel AT ROW 1.17 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-desc-estab AT ROW 1.17 COL 31.29 COLON-ALIGNED NO-LABEL
     cta-corrente.cod-mod AT ROW 2.17 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     c-desc-mod AT ROW 2.17 COL 33.29 COLON-ALIGNED NO-LABEL
     cta-corrente.data-saldo AT ROW 3.17 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     cta-corrente.saldo-ini AT ROW 4.17 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     cta-corrente.saldo-atual AT ROW 5.17 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     cta-corrente.gera-disponivel AT ROW 6.17 COL 25.72
          VIEW-AS TOGGLE-BOX
          SIZE 20.29 BY .83
     "." VIEW-AS TEXT
          SIZE 1.29 BY .29 AT ROW 7.29 COL 85.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.cta-corrente
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 6.79
         WIDTH              = 86.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-mod IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cta-corrente.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.cod-estabel V-table-Win
ON F5 OF cta-corrente.cod-estabel IN FRAME f-main /* Estab */
DO:
Assign l-implanta = yes.
{include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                   &campo={&self-name}
                   &campozoom=cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.cod-estabel V-table-Win
ON LEAVE OF cta-corrente.cod-estabel IN FRAME f-main /* Estab */
DO:
  find estabelec where estabelec.cod-estabel = input frame {&FRAME-NAME} cta-corrente.cod-estabel no-lock no-error.
  if avail estabelec 
   then assign c-desc-estab:screen-value = estabelec.nome.
   else assign c-desc-estab:screen-value = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cta-corrente.cod-estabel IN FRAME f-main /* Estab */
DO:
    Apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cta-corrente.cod-mod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.cod-mod V-table-Win
ON F5 OF cta-corrente.cod-mod IN FRAME f-main /* Modalidade */
DO:
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.cod-mod V-table-Win
ON LEAVE OF cta-corrente.cod-mod IN FRAME f-main /* Modalidade */
DO:
  Find tipo-modalidade
      where tipo-modalidade.codigo = input frame {&FRAME-NAME} cta-corrente.cod-mod no-lock no-error.
      if avail tipo-modalidade 
   then assign c-desc-mod:screen-value = tipo-modalidade.descricao.
   else assign c-desc-mod:screen-value = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.cod-mod V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cta-corrente.cod-mod IN FRAME f-main /* Modalidade */
DO:
    Apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

If cta-corrente.cod-estabel:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
If cta-corrente.cod-mod:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "cta-corrente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cta-corrente"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN get-attribute ('adm-new-record':U).
  if  return-value = 'yes':U then do:
      assign cta-corrente.data-saldo:screen-value in frame {&FRAME-NAME} = string(today).
  end.  

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  {include/i-valid.i}

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  find estabelec
      where estabelec.cod-estabel = input frame {&FRAME-NAME} cta-corrente.cod-estabel no-lock no-error.
      if avail estabelec 
         then assign c-desc-estab:screen-value = estabelec.nome.
         else assign c-desc-estab:screen-value = "".
    Find tipo-modalidade
        where tipo-modalidade.codigo = input frame {&FRAME-NAME} cta-corrente.cod-mod no-lock no-error.
        if avail tipo-modalidade 
           then assign c-desc-mod:screen-value = tipo-modalidade.descricao.
           else assign c-desc-mod:screen-value = "".


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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  Find param-cb where param-cb.ep-codigo = i-ep-codigo-usuario no-lock no-error.
  If not avail param-cb then
      Disable cta-corrente.cod-mod with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  
  {include/i-vldfrm.i}

  Find estabelec
       where estabelec.cod-estabel = input frame {&FRAME-NAME} cta-corrente.cod-estabel
       no-lock no-error.
  
  If  not avail estabelec then do:
      {utp/ut-table.i mgadm estabelec 1}
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show",
                         input 13,
                         input input frame {&FRAME-NAME} cta-corrente.cod-estabel).
      apply 'entry' to cta-corrente.cod-estabel in frame {&frame-name}.
      Return 'ADM-ERROR':U.
  End.
                    
  If  input frame {&FRAME-NAME} cta-corrente.cod-mod <> "" then do:
      Find tipo-modalidade
           where tipo-modalidade.codigo = input frame {&FRAME-NAME} cta-corrente.cod-mod
           no-lock no-error.
      
      If  not avail tipo-modalidade then do:
          {utp/ut-table.i mgadm tipo-modalidade 1}
          {include/i-vldprg.i}
          Run utp/ut-msgs.p (input "show",
                             input 50,
                             input input frame {&FRAME-NAME} cta-corrente.cod-mod).
          Apply 'entry' to cta-corrente.cod-mod in frame {&frame-name}.
          Return 'ADM-ERROR':U.
      End.
  End.

  assign l-rejeita-dec = no
         cta-corrente.saldo-ini:screen-value   in frame {&FRAME-NAME} = string(fn_vld_ajust_dec(
                                            input frame {&FRAME-NAME} cta-corrente.saldo-ini,0))
         cta-corrente.saldo-atual:screen-value in frame {&FRAME-NAME} = string(fn_vld_ajust_dec(
                                            input frame {&FRAME-NAME} cta-corrente.saldo-atual,0)).
                                         
  if  l-rejeita-dec then do:
      run utp/ut-msgs.p (input "show":U,
                         input 18100,
                         input " ").
      apply 'entry':U to cta-corrente.saldo-ini in frame {&FRAME-NAME}.
      return 'adm-error':U.
  end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cta-corrente"}

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


