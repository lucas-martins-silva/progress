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
{include/i-prgvrs.i V01AD339 2.00.00.001}  /*** 010001 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01ad339 MUT}
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
DEFINE VARIABLE v-row-parent AS ROWID NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cot-infl-ge
&Scoped-define FIRST-EXTERNAL-TABLE cot-infl-ge


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cot-infl-ge.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cot-infl-ge.cotacao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cotacao ~{&FP2}cotacao ~{&FP3}
&Scoped-define ENABLED-TABLES cot-infl-ge
&Scoped-define FIRST-ENABLED-TABLE cot-infl-ge
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS cot-infl-ge.ep-codigo cot-infl-ge.mo-codigo ~
cot-infl-ge.cotacao 
&Scoped-Define DISPLAYED-OBJECTS c-razao-social fi-descricao-moeda 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cot-infl-ge.mo-codigo 
&Scoped-define ADM-ASSIGN-FIELDS cot-infl-ge.ep-codigo 

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
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao-moeda AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cot-infl-ge.ep-codigo AT ROW 1.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     c-razao-social AT ROW 1.17 COL 29 COLON-ALIGNED HELP
          "Razao Social da Empresa" NO-LABEL
     cot-infl-ge.mo-codigo AT ROW 2.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     fi-descricao-moeda AT ROW 2.17 COL 28 COLON-ALIGNED NO-LABEL
     cot-infl-ge.cotacao AT ROW 3.67 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.cot-infl-ge
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
         HEIGHT             = 3.75
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
/* SETTINGS FOR FILL-IN cot-infl-ge.ep-codigo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-descricao-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cot-infl-ge.mo-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME cot-infl-ge.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cot-infl-ge.ep-codigo V-table-Win
ON LEAVE OF cot-infl-ge.ep-codigo IN FRAME f-main /* Empresa */
DO:
    &IF "{&mguni_version}" >= "2.07A" &THEN
    {include/leave.i &tabela=empresa
                     &atributo-ref=razao-social
                     &variavel-ref=c-razao-social
                     &where="empresa.ep-codigo = cot-infl-ge.ep-codigo:SCREEN-VALUE"}
    &ELSE
    {include/leave.i &tabela=empresa
                     &atributo-ref=razao-social
                     &variavel-ref=c-razao-social
                     &where="empresa.ep-codigo = INTEGER(cot-infl-ge.ep-codigo:SCREEN-VALUE)"}
    &ENDIF
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cot-infl-ge.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cot-infl-ge.mo-codigo V-table-Win
ON F5 OF cot-infl-ge.mo-codigo IN FRAME f-main /* Moeda */
OR MOUSE-SELECT-DBLCLICK OF cot-infl-ge.mo-codigo DO:
    {include/zoomvar.i &prog-zoom="unzoom/z01un005.w"
                       &campo="cot-infl-ge.mo-codigo"
                       &campozoom="mo-codigo"
                       &campo2="fi-descricao-moeda"
                       &campozoom2="descricao"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cot-infl-ge.mo-codigo V-table-Win
ON LEAVE OF cot-infl-ge.mo-codigo IN FRAME f-main /* Moeda */
DO:
    {include/leave.i &tabela="moeda"
                     &where="moeda.mo-codigo = INTEGER(cot-infl-ge.mo-codigo:SCREEN-VALUE)"
                     &variavel-ref="fi-descricao-moeda"
                     &atributo-ref="descricao"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF         

cot-infl-ge.mo-codigo:LOAD-MOUSE-POINTER("image/lupa":U) IN FRAME {&FRAME-NAME}.

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
  {src/adm/template/row-list.i "cot-infl-ge"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cot-infl-ge"}

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
    IF AVAILABLE param-ge THEN
        ASSIGN cot-infl-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(param-ge.ep-codigo).
    ELSE IF AVAILABLE empresa THEN
        ASSIGN cot-infl-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(empresa.ep-codigo).
    ELSE
        ASSIGN cot-infl-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0":U.
    
    APPLY "LEAVE":U TO cot-infl-ge.ep-codigo IN FRAME {&FRAME-NAME}.

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
    IF NOT FRAME {&FRAME-NAME}:VALIDATE() THEN
        RETURN "ADM-ERROR":U.
    
    IF NOT CAN-FIND(FIRST empresa
                    &IF "{&mguni_version}" >= "2.07A" &THEN
                    WHERE empresa.ep-codigo = cot-infl-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
                    &ELSE
                    WHERE empresa.ep-codigo = INTEGER(cot-infl-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME})) THEN DO:
                    &ENDIF
                    
        {utp/ut-table.i mguni empresa 1}
        
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 56, 
                           INPUT TRIM(RETURN-VALUE)).
        
        APPLY "ENTRY":U TO cot-infl-ge.ep-codigo IN FRAME {&FRAME-NAME}.
        
        RETURN "ADM-ERROR":U.
    END.
    
    IF NOT CAN-FIND(FIRST moeda WHERE moeda.mo-codigo = INTEGER(cot-infl-ge.mo-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME})) THEN DO:
        {utp/ut-table.i mguni moeda 1}
        
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 56, 
                           INPUT TRIM(RETURN-VALUE)).
        
        APPLY "ENTRY":U TO cot-infl-ge.mo-codigo IN FRAME {&FRAME-NAME}.
        
        RETURN "ADM-ERROR":U.
    END.
    
    IF  CAN-FIND(FIRST cot-infl-ge 
                       &IF "{&mguni_version}" >= "2.07A" &THEN
                       WHERE cot-infl-ge.ep-codigo = cot-infl-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                       &ELSE
                       WHERE cot-infl-ge.ep-codigo = INTEGER(cot-infl-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) 
                       &ENDIF
                        AND cot-infl-ge.mo-codigo = INTEGER(cot-infl-ge.mo-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}))
    and adm-new-record
    THEN DO:
      
        {utp/ut-liter.i Cota‡Æo_de_Infla‡äes}
        
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 1,
                           INPUT TRIM(RETURN-VALUE)).
        
        APPLY "ENTRY":U TO cot-infl-ge.mo-codigo IN FRAME {&FRAME-NAME}.
        
        RETURN "ADM-ERROR":U.
    END.
    
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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
    APPLY "LEAVE":U TO cot-infl-ge.ep-codigo IN FRAME {&FRAME-NAME}.
    APPLY "LEAVE":U TO cot-infl-ge.mo-codigo IN FRAME {&FRAME-NAME}.

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
    
    FIND param-ge WHERE ROWID(param-ge) = v-row-parent NO-LOCK NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-empresa V-table-Win 
PROCEDURE pi-recebe-empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-empresa AS ROWID NO-UNDO.
    
    FIND empresa WHERE ROWID(empresa) = p-empresa NO-LOCK NO-ERROR.

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
  {src/adm/template/snd-list.i "cot-infl-ge"}

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


