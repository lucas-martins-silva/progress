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
{include/i-prgvrs.i  2.00.00.001}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i  MUT}
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
def new global shared var v-row-parent as rowid no-undo.                                
def new global shared var i-sequencia like val-tab-prog-impto.seq-valid no-undo.
def new global shared var r-row-tab-prog-impto as rowid no-undo.
def new global shared var r-row-val-tab-prog-impto as rowid no-undo.
def new global shared var v-incluir-modificar as char format "x(20)" no-undo.
def var dt-val-fim-anterior like val-tab-prog-impto.dt-val-fim.

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
&Scoped-define EXTERNAL-TABLES val-tab-prog-impto
&Scoped-define FIRST-EXTERNAL-TABLE val-tab-prog-impto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR val-tab-prog-impto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS val-tab-prog-impto.dt-val-ini ~
val-tab-prog-impto.dt-val-fim val-tab-prog-impto.fator-reducao-1 ~
val-tab-prog-impto.fator-reducao-2 val-tab-prog-impto.fator-reducao-3 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}dt-val-ini ~{&FP2}dt-val-ini ~{&FP3}~
 ~{&FP1}dt-val-fim ~{&FP2}dt-val-fim ~{&FP3}~
 ~{&FP1}fator-reducao-1 ~{&FP2}fator-reducao-1 ~{&FP3}~
 ~{&FP1}fator-reducao-2 ~{&FP2}fator-reducao-2 ~{&FP3}~
 ~{&FP1}fator-reducao-3 ~{&FP2}fator-reducao-3 ~{&FP3}
&Scoped-define ENABLED-TABLES val-tab-prog-impto
&Scoped-define FIRST-ENABLED-TABLE val-tab-prog-impto
&Scoped-Define ENABLED-OBJECTS rt-key i-sequencia rt-mold 
&Scoped-Define DISPLAYED-FIELDS val-tab-prog-impto.nr-tab-progr ~
val-tab-prog-impto.dt-val-ini val-tab-prog-impto.dt-val-fim ~
val-tab-prog-impto.fator-reducao-1 val-tab-prog-impto.fator-reducao-2 ~
val-tab-prog-impto.fator-reducao-3 
&Scoped-Define DISPLAYED-OBJECTS i-sequencia 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS val-tab-prog-impto.nr-tab-progr 

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
DEFINE VARIABLE i-sequencia AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 66.86 BY 2.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 66.86 BY 5.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     val-tab-prog-impto.nr-tab-progr AT ROW 1.25 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.86 BY .88
     i-sequencia AT ROW 2.21 COL 31.14 COLON-ALIGNED
     val-tab-prog-impto.dt-val-ini AT ROW 4.04 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     val-tab-prog-impto.dt-val-fim AT ROW 5.04 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     val-tab-prog-impto.fator-reducao-1 AT ROW 6.04 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     val-tab-prog-impto.fator-reducao-2 AT ROW 7.04 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     val-tab-prog-impto.fator-reducao-3 AT ROW 8.04 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.54 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.val-tab-prog-impto
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
         HEIGHT             = 8.29
         WIDTH              = 67.
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

/* SETTINGS FOR FILL-IN val-tab-prog-impto.nr-tab-progr IN FRAME f-main
   NO-ENABLE 2                                                          */
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
    &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "val-tab-prog-impto"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "val-tab-prog-impto"}

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

/*Inicializando valores*/
 if v-incluir-modificar = 'incluir' then do:
    find tab-prog-impto where rowid(tab-prog-impto) = r-row-tab-prog-impto no-lock.
    if avail tab-prog-impto then do:
    end.
    assign val-tab-prog-impto.nr-tab-progr:screen-value in frame {&frame-name} = string(tab-prog-impto.nr-tab-progr).
 end.
 else do:
      find val-tab-prog-impto where rowid(val-tab-prog-impto) = r-row-val-tab-prog-impto no-lock.
      disable i-sequencia with frame {&frame-name}.
      assign val-tab-prog-impto.nr-tab-progr:screen-value in frame {&frame-name} = string(val-tab-prog-impto.nr-tab-progr)
             i-sequencia:screen-value in frame {&frame-name} = string(val-tab-prog-impto.seq-valid)
             val-tab-prog-impto.dt-val-ini:screen-value in frame {&frame-name} = string(val-tab-prog-impto.dt-val-ini)
             val-tab-prog-impto.dt-val-fim:screen-value in frame {&frame-name} = string(val-tab-prog-impto.dt-val-fim)
             val-tab-prog-impto.fator-reducao-1:screen-value in frame {&frame-name} = string(val-tab-prog-impto.fator-reducao-1)
             val-tab-prog-impto.fator-reducao-2:screen-value in frame {&frame-name} = string(val-tab-prog-impto.fator-reducao-2)
             val-tab-prog-impto.fator-reducao-3:screen-value in frame {&frame-name} = string(val-tab-prog-impto.fator-reducao-3).
 end.

/*C lculo sequencial*/
if v-incluir-modificar = 'incluir' then do :
   find last val-tab-prog-impto no-lock
        where val-tab-prog-impto.nr-tab-progr = tab-prog-impto.nr-tab-progr
        no-error.
   if  avail val-tab-prog-impto then do:          
       assign i-sequencia = val-tab-prog-impto.seq-valid + 10
              dt-val-fim-anterior = val-tab-prog-impto.dt-val-fim.
       if dt-val-fim-anterior <> 12/31/9999 then do:  
          assign val-tab-prog-impto.dt-val-ini:screen-value in frame {&frame-name} = string(dt-val-fim-anterior + 1).
       end.
       else do:
            assign val-tab-prog-impto.dt-val-ini:screen-value in frame {&frame-name} = string(today).
       end.
   end.
   else do:
        assign val-tab-prog-impto.dt-val-ini:screen-value in frame {&frame-name} = string(today)
               i-sequencia = 10.
   end.
assign i-sequencia:screen-value in frame {&frame-name} = string(i-sequencia).
end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .
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
  {include/i-valid.i}
   if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
      
   run pi-validate.
   
   /* Coloca valores na variavel pi-validate */
   if v-incluir-modificar = 'incluir' then do:
      assign i-sequencia = input frame {&frame-name} i-sequencia.   
   end.
      
      
  /*Valida se data final ‚ maior que data inicial*/
  if input frame {&frame-name} val-tab-prog-impto.dt-val-fim < input frame {&frame-name} val-tab-prog-impto.dt-val-ini then do:
     {utp/ut-table.i mgadm val-tab-prog-impto 1}
     run utp/ut-msgs.p (input "show":U,
                        input 7471,
                        input return-value).
     apply 'entry' to val-tab-prog-impto.dt-val-fim.
     return 'ADM-ERROR':U.
 end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
  assign val-tab-prog-impto.seq-valid = input frame {&frame-name} i-sequencia.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
   
  {utp\ut-field.i mgadm val-tab-prog-impto seq-valid 1}
  assign i-sequencia:label in frame {&frame-name} = return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

/*Valida‡Æo chave duplicada*/
if v-incluir-modificar = 'incluir' then do:
    find val-tab-prog-impto where val-tab-prog-impto.nr-tab-progr = input frame {&frame-name} val-tab-prog-impto.nr-tab-progr 
         and val-tab-prog-impto.seq-valid = input frame {&frame-name} i-sequencia 
         exclusive-lock no-error.
    if avail val-tab-prog-impto then do:
       {utp\ut-table.i mgadm val-tab-prog-impto 1}
       run utp\ut-msgs.p(input "show",
                         input 1,
                         input return-value).
       APPLY 'entry' TO i-sequencia IN FRAME {&FRAME-NAME}.
       RETURN 'adm-error'.                          
    END.
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
  {src/adm/template/snd-list.i "val-tab-prog-impto"}

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


