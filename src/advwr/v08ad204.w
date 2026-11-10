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
{include/i-prgvrs.i V08AD204 2.00.00.001}  /*** 010001 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v08ad204 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */
&SCOPED-DEFINE adm-attribute-dlg support/viewerd.w

/* Parameters Definitions ---                                           */

/* Global Variable Definitions ---                                      */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h_b01ad339   AS HANDLE NO-UNDO.
DEFINE VARIABLE v-row-parent AS ROWID  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-ge
&Scoped-define FIRST-EXTERNAL-TABLE param-ge


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-ge.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS param-ge.ep-codigo 
&Scoped-Define DISPLAYED-OBJECTS c-razao-social 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS param-ge.ep-codigo 
&Scoped-define ADM-ASSIGN-FIELDS param-ge.ep-codigo 

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
DEFINE VARIABLE c-razao-social AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 58 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-ge.ep-codigo AT ROW 1.17 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-razao-social AT ROW 1.17 COL 20 COLON-ALIGNED HELP
          "Razao Social da Empresa" NO-LABEL
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.param-ge
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 1.25
         WIDTH              = 90.
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

/* SETTINGS FOR FILL-IN c-razao-social IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN param-ge.ep-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
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

{include/i-auxtab.i}
{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME param-ge.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.ep-codigo V-table-Win
ON F5 OF param-ge.ep-codigo IN FRAME f-main /* Empresa */
OR MOUSE-SELECT-DBLCLICK OF param-ge.ep-codigo IN FRAME {&FRAME-NAME} DO:
    ASSIGN l-implanta = YES.
    
    {include/zoomvar.i &prog-zoom=unzoom/z01un004.w
                       &campo=param-ge.ep-codigo
                       &campozoom=ep-codigo
                       &campo2=c-razao-social
                       &campozoom2=razao-social}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.ep-codigo V-table-Win
ON LEAVE OF param-ge.ep-codigo IN FRAME f-main /* Empresa */
DO:
    &IF "{&mguni_version}" >= "2.07A" &THEN
    {include/leave.i &tabela=empresa
                     &atributo-ref=razao-social
                     &variavel-ref=c-razao-social
                     &where="empresa.ep-codigo = param-ge.ep-codigo:SCREEN-VALUE"}
    &ELSE
    {include/leave.i &tabela=empresa
                     &atributo-ref=razao-social
                     &variavel-ref=c-razao-social
                     &where="empresa.ep-codigo = INTEGER(param-ge.ep-codigo:SCREEN-VALUE)"}
    &ENDIF
                                                                                           
    IF VALID-HANDLE(h_b01ad339) THEN
        RUN pi-recebe-empresa IN h_b01ad339 (INPUT INTEGER(param-ge.ep-codigo:SCREEN-VALUE)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

param-ge.ep-codigo:LOAD-MOUSE-POINTER("image/lupa":U) IN FRAME {&FRAME-NAME}.

IF  VALID-HANDLE(h_b01ad339) THEN
    RUN pi-change IN h_b01ad339 (INPUT NO).

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
  {src/adm/template/row-list.i "param-ge"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-ge"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    IF VALID-HANDLE(h_b01ad339) THEN DO:
        RUN pi-recebe-empresa IN h_b01ad339 (INPUT ?).
        RUN pi-recebe-param-ge IN h_b01ad339 (INPUT ?).
    END.

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
    
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    IF RETURN-VALUE = 'ADM-ERROR':U then 
        RETURN 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    IF VALID-HANDLE(h_b01ad339) THEN DO:
        RUN pi-recebe-empresa IN h_b01ad339 (INPUT ?).
        RUN pi-recebe-param-ge IN h_b01ad339 (INPUT ?).
    END.

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
    &IF DEFINED(ADM-MODIFY-FIELDS) &THEN
        DISABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&FRAME-NAME}.
    &ENDIF
    
    IF VALID-HANDLE(h_b01ad339) THEN
        RUN pi-change IN h_b01ad339 (INPUT NO).

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
    APPLY "LEAVE":U TO param-ge.ep-codigo IN FRAME {&FRAME-NAME}.

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
/*    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/
    
    /* Code placed here will execute AFTER standard behavior.    */
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    
    RUN notify ('enable-fields, GROUP-ASSIGN-TARGET':U).
    
    &IF DEFINED(ADM-MODIFY-FIELDS) &THEN
        IF adm-new-record THEN
            ENABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&FRAME-NAME}.
    &ENDIF
    
    IF VALID-HANDLE(h_b01ad339) THEN
        IF adm-new-record AND adm-adding-record THEN
            RUN pi-change IN h_b01ad339 (INPUT NO).
        ELSE
            RUN pi-change IN h_b01ad339 (INPUT param-ge.fluxo-ap-cb OR param-ge.fluxo-cr-cb).
    
    IF adm-new-record THEN
        ASSIGN param-ge.ep-codigo:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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

    /* Code placed here will execute AFTER standard behavior.    */
    IF VALID-HANDLE(h_b01ad339) THEN DO:
        RUN pi-recebe-empresa IN h_b01ad339 (INPUT IF AVAILABLE param-ge THEN param-ge.ep-codigo ELSE ?).
        RUN pi-recebe-param-ge IN h_b01ad339 (INPUT ROWID(param-ge)).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER v-row-parent-externo AS ROWID NO-UNDO.
    
    ASSIGN v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-h_b01ad339 AS HANDLE NO-UNDO.
    
    ASSIGN h_b01ad339 = p-h_b01ad339.
    
    IF VALID-HANDLE(h_b01ad339) THEN DO:
        RUN pi-change IN h_b01ad339 (INPUT IF AVAILABLE param-ge THEN param-ge.fluxo-cr-cb OR param-ge.fluxo-ap-cb ELSE ?).
        RUN pi-recebe-empresa IN h_b01ad339 (INPUT IF AVAILABLE param-ge THEN param-ge.ep-codigo ELSE ?).
        RUN pi-recebe-param-ge IN h_b01ad339 (INPUT ROWID(param-ge)).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    
    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
    
    &IF "{&mguni_version}" >= "2.07A" &THEN
    IF NOT CAN-FIND(FIRST empresa WHERE empresa.ep-codigo = param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
    &ELSE
    IF NOT CAN-FIND(FIRST empresa WHERE empresa.ep-codigo = INTEGER(param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME})) THEN DO:
    &ENDIF
        {include/i-vldprg.i}
        
        {utp/ut-table.i mguni empresa 1}

        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 56, 
                           INPUT TRIM(RETURN-VALUE)).
        
        APPLY "ENTRY":U TO param-ge.ep-codigo IN FRAME {&FRAME-NAME}.
        
        RETURN "ADM-ERROR":U.
    END.
    ELSE IF adm-new-record AND
            &IF "{&mguni_version}" >= "2.07A" &THEN
            CAN-FIND(FIRST param-ge WHERE param-ge.ep-codigo = param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
            &ELSE
            CAN-FIND(FIRST param-ge WHERE param-ge.ep-codigo = INTEGER(param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME})) THEN DO:
            &ENDIF
        {include/i-vldprg.i}
        
        {utp/ut-table.i mgadm param-ge 1}
        
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 1, 
                           INPUT TRIM(RETURN-VALUE)).
        
        APPLY "ENTRY":U TO param-ge.ep-codigo IN FRAME {&FRAME-NAME}.
        
        RETURN "ADM-ERROR":U.
    END.

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
  {src/adm/template/snd-list.i "param-ge"}

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
    
    RUN pi-trata-state IN THIS-PROCEDURE (INPUT p-issuer-hdl, INPUT p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


