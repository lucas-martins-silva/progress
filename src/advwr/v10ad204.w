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
{include/i-prgvrs.i V10AD204 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V10AD204 MUT}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitios ---                                          */
&SCOPED-DEFINE adm-attribute-dlg support/viewerd.w

/* Global Variable Definitions ---                                      */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h_v11ad204   AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v12ad204   AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v13ad204   AS HANDLE NO-UNDO.
DEFINE VARIABLE v-row-parent AS ROWID  NO-UNDO.
def var l-novo-cr as logical init no.
def var l-novo-ft as logical init no.
/* Include Definitions ---                                              */
{include/i_dbvers.i}

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
&Scoped-Define ENABLED-FIELDS param-ge.modulo-cc param-ge.modulo-pd ~
param-ge.modulo-ft param-ge.modulo-cr 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES param-ge
&Scoped-define FIRST-ENABLED-TABLE param-ge
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS param-ge.modulo-cc param-ge.modulo-pd ~
param-ge.modulo-ft param-ge.modulo-cr 
&Scoped-Define DISPLAYED-OBJECTS tg-modulo-ap 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS tg-modulo-ap 

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
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 5.

DEFINE VARIABLE tg-modulo-ap AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-ge.modulo-cc AT ROW 1.17 COL 35
          VIEW-AS TOGGLE-BOX
          SIZE 31 BY .83
     param-ge.modulo-pd AT ROW 2.17 COL 35
          VIEW-AS TOGGLE-BOX
          SIZE 31 BY .83
     param-ge.modulo-ft AT ROW 3.17 COL 35
          VIEW-AS TOGGLE-BOX
          SIZE 31 BY .83
     tg-modulo-ap AT ROW 4.17 COL 35
     param-ge.modulo-cr AT ROW 5.17 COL 35
          VIEW-AS TOGGLE-BOX
          SIZE 31 BY .83
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
         HEIGHT             = 5
         WIDTH              = 86.
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

ASSIGN 
       param-ge.modulo-cc:AUTO-RESIZE IN FRAME f-main      = TRUE.

ASSIGN 
       param-ge.modulo-cr:AUTO-RESIZE IN FRAME f-main      = TRUE.

ASSIGN 
       param-ge.modulo-ft:AUTO-RESIZE IN FRAME f-main      = TRUE.

ASSIGN 
       param-ge.modulo-pd:AUTO-RESIZE IN FRAME f-main      = TRUE.

/* SETTINGS FOR TOGGLE-BOX tg-modulo-ap IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN 
       tg-modulo-ap:AUTO-RESIZE IN FRAME f-main      = TRUE.

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

&Scoped-define SELF-NAME param-ge.modulo-cc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.modulo-cc V-table-Win
ON VALUE-CHANGED OF param-ge.modulo-cc IN FRAME f-main /* Compras */
DO:
  apply "value-changed":U to param-ge.modulo-ft.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-ge.modulo-cr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.modulo-cr V-table-Win
ON VALUE-CHANGED OF param-ge.modulo-cr IN FRAME f-main /* Contas a Receber */
DO:
    IF ADM-NEW-RECORD and l-novo-cr then
       assign tg-modulo-ap:checked = no
              param-ge.modulo-cr:CHECKED = no
              l-novo-cr = no.
    
    IF VALID-HANDLE(h_v11ad204) THEN
        RUN pi-change IN h_v11ad204 (INPUT tg-modulo-ap:CHECKED,
                                     INPUT param-ge.modulo-cr:CHECKED).
    
    IF VALID-HANDLE(h_v12ad204) THEN
        RUN pi-change IN h_v12ad204 (INPUT tg-modulo-ap:CHECKED,
                                     INPUT param-ge.modulo-cr:CHECKED).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-ge.modulo-ft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.modulo-ft V-table-Win
ON VALUE-CHANGED OF param-ge.modulo-ft IN FRAME f-main /* Faturamento */
DO:
   IF ADM-NEW-RECORD and l-novo-ft then
       assign param-ge.modulo-ft:CHECKED = no
              param-ge.modulo-pd:CHECKED = no
              param-ge.modulo-cc:CHECKED = no
              l-novo-ft = no.
 
   IF VALID-HANDLE(h_v13ad204) THEN
        RUN pi-change IN h_v13ad204 (INPUT param-ge.modulo-pd:CHECKED IN FRAME {&FRAME-NAME},
                                     INPUT param-ge.modulo-ft:CHECKED IN FRAME {&FRAME-NAME},
                                     INPUT param-ge.modulo-cc:CHECKED IN FRAME {&FRAME-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-ge.modulo-pd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.modulo-pd V-table-Win
ON VALUE-CHANGED OF param-ge.modulo-pd IN FRAME f-main /* Pedidos */
DO:
     apply "value-changed":U to param-ge.modulo-ft.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-modulo-ap
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-modulo-ap V-table-Win
ON VALUE-CHANGED OF tg-modulo-ap IN FRAME f-main
DO:
     apply "value-changed":U to param-ge.modulo-cr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-liter.i Contas_a_Pagar}
ASSIGN tg-modulo-ap:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Considera_Contas_a_Pagar?}
ASSIGN tg-modulo-ap:HELP IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

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
    ASSIGN param-ge.modulo-cc:CHECKED IN FRAME {&FRAME-NAME}     = NO
           param-ge.modulo-pd:CHECKED IN FRAME {&FRAME-NAME}     = NO
           param-ge.modulo-ft:CHECKED IN FRAME {&FRAME-NAME}     = NO
           tg-modulo-ap:CHECKED IN FRAME {&FRAME-NAME}           = NO
           param-ge.modulo-cr:CHECKED IN FRAME {&FRAME-NAME}     = NO
           l-novo-ft                                             = YES
           l-novo-cr                                             = YES.
    
    IF VALID-HANDLE(h_v13ad204) THEN
        RUN pi-change IN h_v13ad204 (INPUT param-ge.modulo-pd:CHECKED IN FRAME {&FRAME-NAME},
                                     INPUT param-ge.modulo-ft:CHECKED IN FRAME {&FRAME-NAME},
                                     INPUT param-ge.modulo-cc:CHECKED IN FRAME {&FRAME-NAME}).

    apply "value-changed":U to param-ge.modulo-ft in frame {&FRAME-NAME}.
    apply "value-changed":U to param-ge.modulo-cr in frame {&FRAME-NAME}.
  

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
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN 
        &IF "{&mgadm_version}":U = "2.03":U &THEN
           param-ge.tp-atualizacao = IF tg-modulo-ap:CHECKED IN FRAME {&FRAME-NAME}
                                     THEN 2 
                                     ELSE 1.
        &ELSE
           param-ge.modulo-ap      = tg-modulo-ap:CHECKED in frame {&FRAME-NAME}.
        &ENDIF

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

  apply "value-changed":U to param-ge.modulo-ft in frame {&FRAME-NAME}.
  apply "value-changed":U to param-ge.modulo-cr in frame {&FRAME-NAME}.


  /* Code placed here will execute AFTER standard behavior.    */

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
    
    ASSIGN tg-modulo-ap:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
    ASSIGN tg-modulo-ap:CHECKED IN FRAME {&FRAME-NAME} = 
                                                      &IF "{&mgadm_version}":U = "2.03":U &THEN
                                                        AVAILABLE param-ge AND param-ge.tp-atualizacao = 2.
                                                      &ELSE
                                                        AVAILABLE param-ge AND param-ge.modulo-ap.
                                                      &ENDIF

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
    &IF DEFINED(ADM-MODIFY-FIELDS) &THEN
        IF adm-new-record THEN
            ENABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&FRAME-NAME}.
    &ENDIF
    
    ASSIGN tg-modulo-ap:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    if not adm-new-record then do:
        apply "value-changed":U to param-ge.modulo-ft.
        apply "value-changed":U to param-ge.modulo-cr.
    end.
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
    DEFINE INPUT PARAMETER p-h_v10ad204 AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p-h_v12ad204 AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p-h_v13ad204 AS HANDLE NO-UNDO.
    
    ASSIGN h_v11ad204 = p-h_v10ad204
           h_v12ad204 = p-h_v12ad204
           h_v13ad204 = p-h_v13ad204.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
    
    /*/*    Segue um exemplo de valida‡Æo de programa */
     *     find tabela where tabela.campo1 = c-variavel and
     *                       tabela.campo2 > i-variavel no-lock no-error.
     *     
     *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
     *     {include/i-vldprg.i}
     *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
     *     return 'ADM-ERROR':U.*/

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


