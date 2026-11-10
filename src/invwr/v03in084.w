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
{include/i-prgvrs.i V03IN084 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN084 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{include/i-vrtab.i deposito}
{include/i-vrtab.i emitente}
{cdp/cdcfgmat.i}
{include/i_dbvers.i}

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
&Scoped-define EXTERNAL-TABLES deposito
&Scoped-define FIRST-EXTERNAL-TABLE deposito


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR deposito.
/* Standard List Definitions                                            */
&IF "{&mgscm_version}" >= "2.05" &THEN 
    &Scoped-Define ENABLED-FIELDS deposito.cod-depos deposito.nome ~
    deposito.cons-saldo deposito.log-gera-wms deposito.alocado ~
    deposito.ind-acabado deposito.ind-processo deposito.ind-dep-cq ~
    deposito.ind-dep-rej deposito.nome-abrev 
&ELSE
    &Scoped-Define ENABLED-FIELDS deposito.cod-depos deposito.nome ~
    deposito.cons-saldo deposito.log-2 deposito.alocado ~
    deposito.ind-acabado deposito.ind-processo deposito.ind-dep-cq ~
    deposito.ind-dep-rej deposito.nome-abrev 
&ENDIF
&Scoped-define ENABLED-TABLES deposito
&Scoped-define FIRST-ENABLED-TABLE deposito
&Scoped-Define ENABLED-OBJECTS RECT-39 RECT-40 rt-key rt-mold 
&IF "{&mgscm_version}" >= "2.05" &THEN 
    &Scoped-Define DISPLAYED-FIELDS deposito.cod-depos deposito.nome ~
    deposito.cons-saldo deposito.log-gera-wms deposito.alocado ~
    deposito.ind-acabado deposito.ind-processo deposito.ind-dep-cq ~
    deposito.ind-dep-rej deposito.nome-abrev 
&ELSE
    &Scoped-Define DISPLAYED-FIELDS deposito.cod-depos deposito.nome ~
    deposito.cons-saldo deposito.log-2 deposito.alocado ~
    deposito.ind-acabado deposito.ind-processo deposito.ind-dep-cq ~
    deposito.ind-dep-rej deposito.nome-abrev 
&ENDIF

&Scoped-define DISPLAYED-TABLES deposito
&Scoped-define FIRST-DISPLAYED-TABLE deposito
&Scoped-Define DISPLAYED-OBJECTS c-nome-emit c-ind-tipo-dep 

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
DEFINE VARIABLE c-ind-tipo-dep AS CHARACTER FORMAT "X(8)" INITIAL "1" 
     LABEL "Tipo Dep¢sito" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.14 BY 4.83.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.86 BY 2.25.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 7.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     deposito.cod-depos AT ROW 1.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     deposito.nome AT ROW 1.17 COL 30 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     deposito.cons-saldo AT ROW 2.79 COL 24
          VIEW-AS TOGGLE-BOX
          SIZE 29.57 BY .83
     &IF "{&mgscm_version}" >= "2.05" &THEN 
         deposito.log-gera-wms AT ROW 2.79 COL 55
              VIEW-AS TOGGLE-BOX
              SIZE 30 BY .83
     &ELSE
         deposito.log-2 AT ROW 2.79 COL 55
              VIEW-AS TOGGLE-BOX
              SIZE 30 BY .83
     &ENDIF
     deposito.alocado AT ROW 3.58 COL 24
          VIEW-AS TOGGLE-BOX
          SIZE 27.86 BY .83
     deposito.ind-acabado AT ROW 4.33 COL 24
          VIEW-AS TOGGLE-BOX
          SIZE 28.14 BY .83
     deposito.ind-processo AT ROW 5.13 COL 24
          VIEW-AS TOGGLE-BOX
          SIZE 24.14 BY .83
     deposito.ind-dep-cq AT ROW 5.88 COL 24
          VIEW-AS TOGGLE-BOX
          SIZE 15.29 BY .83
     deposito.ind-dep-rej AT ROW 6.63 COL 24
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .83
     deposito.nome-abrev AT ROW 8.83 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-nome-emit AT ROW 8.83 COL 38.72 COLON-ALIGNED NO-LABEL
     c-ind-tipo-dep AT ROW 7.83 COL 22 COLON-ALIGNED HELP
          "Tipo de Dep¢sito"
     RECT-39 AT ROW 2.71 COL 1.72
     RECT-40 AT ROW 7.67 COL 1.86
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.deposito
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
         HEIGHT             = 9.13
         WIDTH              = 88.57.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-ind-tipo-dep IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-emit IN FRAME f-main
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
  {src/adm/template/row-list.i "deposito"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "deposito"}

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

  /* Code placed here will execute AFTER standard behavior.    */

if avail deposito then do with frame {&frame-name}:
    assign c-ind-tipo-dep:screen-value = {ininc/i01in084.i  04 deposito.ind-tipo-dep}.
end.
else do:
    assign c-ind-tipo-dep:screen-value = {ininc/i01in084.i  04 1}.    
end.

find emitente where emitente.nome-abrev = deposito.nome-abrev no-lock no-error.
if avail emitente then do with frame {&frame-name}:
    assign c-nome-emit:screen-value = emitente.nome-emit.
end.
else do:
   assign c-nome-emit:screen-value = "".
end.    

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

  {utp/ut-field.i mgind deposito ind-tipo-dep 1}
  &IF "{&mgscm_version}" >= "2.05" &THEN 
      ASSIGN c-ind-tipo-dep:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE)
             deposito.log-gera-wms:LABEL IN FRAME {&FRAME-NAME} = "Dep¢sito WMS":U.
  &ELSE
      ASSIGN c-ind-tipo-dep:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE)
             deposito.log-2:LABEL IN FRAME {&FRAME-NAME} = "Dep¢sito WMS":U.
  &ENDIF
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .
  if avail deposito then do:
     assign gr-deposito = rowid(deposito).
     find emitente where emitente.nome-abrev = deposito.nome-abrev no-lock no-error.
      if avail emitente then 
       assign gr-emitente = rowid(emitente).
  end.     

  /* Code placed here will execute AFTER standard behavior.    */

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a valida‡Æo de chave duplicada */

  /* Ponha aqui as demais valida‡äes */

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

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
  {src/adm/template/snd-list.i "deposito"}

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

