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
{include/i-prgvrs.i V14AD204 2.00.00.005}  /*** 010005 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v14ad204 MUT}
&ENDIF

{cdp/cdcfgint.i}
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

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-container  AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-container  AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_v15ad204   AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_b03ad204   AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_b04ad204   AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_b05ad204   AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_b06ad204   AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_b07ad204   AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_b08ad204   AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_v07ad204   AS HANDLE    NO-UNDO.
DEFINE VARIABLE v-row-parent AS ROWID     NO-UNDO.
def    var      l-estado     as logica    no-undo.

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
&Scoped-Define ENABLED-FIELDS param-ge.fator-div 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}fator-div ~{&FP2}fator-div ~{&FP3}
&Scoped-define ENABLED-TABLES param-ge
&Scoped-define FIRST-ENABLED-TABLE param-ge
&Scoped-Define ENABLED-OBJECTS rt-key fi-cod-cenario fi-data 
&Scoped-Define DISPLAYED-FIELDS param-ge.ep-codigo param-ge.fator-div 
&Scoped-Define DISPLAYED-OBJECTS fi-razao-social fi-cod-cenario ~
fi-nome-cenario fi-data fi-data-inicio-carteira 

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
DEFINE VARIABLE fi-cod-cenario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cen†rio" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data AS DATE FORMAT "99/99/9999":U 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data-inicio-carteira AS DATE FORMAT "99/99/9999":U 
     LABEL "Data In°cio Carteira" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-cenario AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-razao-social AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 4.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-ge.ep-codigo AT ROW 1.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     fi-razao-social AT ROW 1.17 COL 30 COLON-ALIGNED HELP
          "Razao Social da Empresa" NO-LABEL
     fi-cod-cenario AT ROW 2.17 COL 25 COLON-ALIGNED
     fi-nome-cenario AT ROW 2.17 COL 31 COLON-ALIGNED NO-LABEL
     fi-data AT ROW 3.17 COL 25 COLON-ALIGNED
     fi-data-inicio-carteira AT ROW 3.17 COL 66 COLON-ALIGNED
     param-ge.fator-div AT ROW 4.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
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
         HEIGHT             = 4.25
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

/* SETTINGS FOR FILL-IN param-ge.ep-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-data-inicio-carteira IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nome-cenario IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-razao-social IN FRAME f-main
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

&Scoped-define SELF-NAME f-main
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-main V-table-Win
ON GO OF FRAME f-main
DO:
  assign l-estado = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-main V-table-Win
ON LEAVE OF FRAME f-main
DO:
  assign l-estado = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-ge.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.ep-codigo V-table-Win
ON ENTRY OF param-ge.ep-codigo IN FRAME f-main /* Empresa */
DO:
   assign l-estado = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.ep-codigo V-table-Win
ON F5 OF param-ge.ep-codigo IN FRAME f-main /* Empresa */
OR MOUSE-SELECT-DBLCLICK OF param-ge.ep-codigo DO:
    {include/zoomvar.i &prog-zoom="unzoom/z01un004.w"
                       &campo="param-ge.ep-codigo"
                       &campozoom="ep-codigo"
                       &campo2="fi-razao-social"
                       &campozoom2="razao-social"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.ep-codigo V-table-Win
ON LEAVE OF param-ge.ep-codigo IN FRAME f-main /* Empresa */
DO:  
   &IF "{&mguni_version}" >= "2.07A" &THEN
   {include/leave.i &tabela=empresa
                 &atributo-ref=razao-social
                 &variavel-ref=fi-razao-social
                 &where="empresa.ep-codigo = param-ge.ep-codigo:SCREEN-VALUE"}
   &ELSE
   {include/leave.i &tabela=empresa
                 &atributo-ref=razao-social
                 &variavel-ref=fi-razao-social
                 &where="empresa.ep-codigo = INTEGER(param-ge.ep-codigo:SCREEN-VALUE)"}
   &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-ge.fator-div
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.fator-div V-table-Win
ON ENTRY OF param-ge.fator-div IN FRAME f-main /* Fator Divis∆o */
DO:
  assign l-estado = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.fator-div V-table-Win
ON GO OF param-ge.fator-div IN FRAME f-main /* Fator Divis∆o */
DO:
  assign l-estado = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.fator-div V-table-Win
ON LEAVE OF param-ge.fator-div IN FRAME f-main /* Fator Divis∆o */
DO:
  assign l-estado = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-cenario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-cenario V-table-Win
ON ENTRY OF fi-cod-cenario IN FRAME f-main /* Cen†rio */
DO:
assign l-estado = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-cenario V-table-Win
ON F5 OF fi-cod-cenario IN FRAME f-main /* Cen†rio */
OR MOUSE-SELECT-DBLCLICK OF fi-cod-cenario IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad340.w"
                       &campo="fi-cod-cenario"
                       &campozoom="cod-cenario"
                       &campo2="fi-nome-cenario"
                       &campozoom2="nome"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-cenario V-table-Win
ON LEAVE OF fi-cod-cenario IN FRAME f-main /* Cen†rio */
DO:

    
    if  int(fi-cod-cenario:SCREEN-VALUE) <> 0 then do:
    
        {include/leave.i &tabela="cenario-ge"
                         &where="cenario-ge.cod-cenario = INTEGER(fi-cod-cenario:SCREEN-VALUE)"
                         &variavel-ref="fi-nome-cenario"
                         &atributo-ref="nome"}
    end.          
               
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-data
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-data V-table-Win
ON ENTRY OF fi-data IN FRAME f-main /* Data */
DO:
   assign l-estado = no.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-data V-table-Win
ON LEAVE OF fi-data IN FRAME f-main /* Data */
DO:
    assign  error-status:error = no.
    assign fi-data = input frame {&FRAME-NAME} fi-data no-error.
    if error-status:error = yes then do:
        run utp/ut-msgs.p  (input "SHOW",
                            input 25858,
                            input  "").       
        assign fi-data:screen-value = string(today,'99/99/9999').
    end.
    
   if  fi-data:screen-value in frame {&FRAME-NAME} = ? 
   or  fi-data:screen-value in frame {&FRAME-NAME} = "":U
   then do:
       run utp/ut-msgs.p (input "show",
                          input 173,
                          input "").
       
       apply "ENTRY":U to fi-data in frame {&FRAME-NAME}.
       
       return no-apply.                  
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

param-ge.ep-codigo:LOAD-MOUSE-POINTER("image/lupa":U).

{utp/ut-liter.i Cen†rio}
ASSIGN fi-cod-cenario:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
fi-cod-cenario:LOAD-MOUSE-POINTER("image/lupa":U).

{utp/ut-liter.i Data}
ASSIGN fi-data:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Data_In°cio_Carteira}
ASSIGN fi-data-inicio-carteira:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI V-table-Win _DEFAULT-ENABLE
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
  DISPLAY fi-razao-social fi-cod-cenario fi-nome-cenario fi-data 
          fi-data-inicio-carteira 
      WITH FRAME f-main.
  IF AVAILABLE param-ge THEN 
    DISPLAY param-ge.ep-codigo param-ge.fator-div 
      WITH FRAME f-main.
  ENABLE rt-key fi-cod-cenario fi-data param-ge.fator-div 
      WITH FRAME f-main.
  {&OPEN-BROWSERS-IN-QUERY-f-main}
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
    
    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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
    APPLY "LEAVE":U TO param-ge.ep-codigo IN FRAME {&FRAME-NAME}.
    
    find param-ge 
        &IF "{&mguni_version}" >= "2.07A" &THEN
        where param-ge.ep-codigo = param-ge.ep-codigo:screen-value in frame {&FRAME-NAME}
        &ELSE
        where param-ge.ep-codigo = integer(param-ge.ep-codigo:screen-value in frame {&FRAME-NAME})
        &ENDIF
        no-lock no-error.
    
    IF AVAILABLE param-ge THEN DO:
        FIND FIRST cenario-ge WHERE cenario-ge.ep-codigo     = param-ge.ep-codigo NO-LOCK NO-ERROR.
        
        IF AVAILABLE cenario-ge THEN
            ASSIGN fi-cod-cenario:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = STRING(cenario-ge.cod-cenario)
                   fi-nome-cenario:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cenario-ge.nome.
        ELSE
            ASSIGN fi-cod-cenario:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = "0":U
                   fi-nome-cenario:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.
        
        ASSIGN fi-data:SCREEN-VALUE IN FRAME {&FRAME-NAME}                 = STRING(TODAY, "99/99/9999":U)
               fi-data:SENSITIVE IN FRAME {&frame-name}                    = param-ge.informa-data
               fi-data-inicio-carteira:SCREEN-VALUE IN FRAME {&FRAME-NAME} = &IF "{&mgcld_version}":U = "2.03":U &THEN
                                                                                STRING(param-ge.usuario).
                                                                             &ELSE
                                                                                STRING(param-ge.dt-inicio-ge).
                                                                             &ENDIF
        IF NOT VALID-HANDLE(h-container) THEN DO:
            RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "CONTAINER-SOURCE":U, OUTPUT c-container).
            
            ASSIGN h-container = WIDGET-HANDLE(c-container).
        END.
        
    END.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizacao V-table-Win 
PROCEDURE pi-atualizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-window AS WIDGET-HANDLE NO-UNDO.
    
    /*--- Validaá‰es ---*/
    IF  INTEGER(fi-cod-cenario:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0
    &IF "{&mguni_version}" >= "2.07A" &THEN
    and NOT CAN-FIND(FIRST cenario-ge WHERE cenario-ge.ep-codigo    = param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} AND
    &ELSE
    and NOT CAN-FIND(FIRST cenario-ge WHERE cenario-ge.ep-codigo    = INTEGER(param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) AND
    &ENDIF
                                           cenario-ge.cod-cenario   = INTEGER(fi-cod-cenario:SCREEN-VALUE IN FRAME {&FRAME-NAME})) THEN DO:
        assign l-estado = no.

        {utp/ut-liter.i Cen†rio}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 56,
                           INPUT TRIM(RETURN-VALUE)).
        
        APPLY "ENTRY":U TO fi-cod-cenario IN FRAME {&FRAME-NAME}.
        
        
        RETURN "ADM-ERROR":U.
    END.
    
    find cenario-ge 
         &IF "{&mguni_version}" >= "2.07A" &THEN
         WHERE cenario-ge.ep-codigo   = param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
         &ELSE
         WHERE cenario-ge.ep-codigo   = INTEGER(param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) 
         &ENDIF
         AND   cenario-ge.cod-cenario = INTEGER(fi-cod-cenario:SCREEN-VALUE IN FRAME {&FRAME-NAME})
         no-lock no-error.
          
    /*--- Processo de Atualizaá∆o ---*/
    IF VALID-HANDLE(h_v15ad204) THEN DO:
        PROCESS EVENTS.
        {utp/ut-liter.i Atualizando_Dados_Di†rios}
        
        IF VALID-HANDLE(p-window) THEN
            STATUS INPUT TRIM(RETURN-VALUE) IN WINDOW p-window.
        
        PROCESS EVENTS.
        
        IF VALID-HANDLE(h_v15ad204) THEN
            RUN pi-atualizacao IN h_v15ad204 (INPUT INTEGER(param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT DATE(fi-data:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT DATE(fi-data-inicio-carteira:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT INTEGER(param-ge.fator-div:SCREEN-VALUE IN FRAME {&FRAME-NAME})).
    END.
    
    IF VALID-HANDLE(h_b03ad204) THEN DO:
        PROCESS EVENTS.
        {utp/ut-liter.i Atualizando_Pedidos}
        IF VALID-HANDLE(p-window) THEN
            STATUS INPUT TRIM(RETURN-VALUE) IN WINDOW p-window.
        
        PROCESS EVENTS.
        
        IF VALID-HANDLE(h_b03ad204) THEN
            RUN pi-atualizacao IN h_b03ad204 (INPUT INTEGER(param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT DATE(fi-data:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT DATE(fi-data-inicio-carteira:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT INTEGER(param-ge.fator-div:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT INTEGER(fi-cod-cenario:SCREEN-VALUE IN FRAME {&FRAME-NAME})).
    END.
    
    IF VALID-HANDLE(h_b04ad204) THEN DO:
        PROCESS EVENTS.
        {utp/ut-liter.i Atualizando_Faturamento}
        IF VALID-HANDLE(p-window) THEN
            STATUS INPUT TRIM(RETURN-VALUE) IN WINDOW p-window.
        
        PROCESS EVENTS.
        
        IF VALID-HANDLE(h_b04ad204) THEN
            RUN pi-atualizacao IN h_b04ad204 (INPUT INTEGER(param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT DATE(fi-data:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT DATE(fi-data-inicio-carteira:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT INTEGER(param-ge.fator-div:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT INTEGER(fi-cod-cenario:SCREEN-VALUE IN FRAME {&FRAME-NAME})).
    END.
    
    IF VALID-HANDLE(h_b05ad204) THEN DO:
        PROCESS EVENTS.
        {utp/ut-liter.i Atualizando_Contas_a_Receber}
        IF VALID-HANDLE(p-window) THEN
            STATUS INPUT TRIM(RETURN-VALUE) IN WINDOW p-window.
        
        PROCESS EVENTS.
        
        IF VALID-HANDLE(h_b05ad204) THEN
            RUN pi-atualizacao IN h_b05ad204 (INPUT INTEGER(param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT DATE(fi-data:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT DATE(fi-data-inicio-carteira:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT INTEGER(param-ge.fator-div:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT INTEGER(fi-cod-cenario:SCREEN-VALUE IN FRAME {&FRAME-NAME})).
    END.
    
    IF VALID-HANDLE(h_b06ad204) THEN DO:
        PROCESS EVENTS.
        {utp/ut-liter.i Atualizando_Contas_a_Pagar}
        IF VALID-HANDLE(p-window) THEN
            STATUS INPUT TRIM(RETURN-VALUE) IN WINDOW p-window.
        
        PROCESS EVENTS.
        
        IF VALID-HANDLE(h_b06ad204) THEN
            RUN pi-atualizacao IN h_b06ad204 (INPUT INTEGER(param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT DATE(fi-data:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT DATE(fi-data-inicio-carteira:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT INTEGER(param-ge.fator-div:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT INTEGER(fi-cod-cenario:SCREEN-VALUE IN FRAME {&FRAME-NAME})).
    END.
    
    IF VALID-HANDLE(h_b07ad204) THEN DO:
        PROCESS EVENTS.
        {utp/ut-liter.i Atualizando_Compras}
        IF VALID-HANDLE(p-window) THEN
            STATUS INPUT TRIM(RETURN-VALUE) IN WINDOW p-window.
        
        PROCESS EVENTS.
        
        IF VALID-HANDLE(h_b07ad204) THEN
            RUN pi-atualizacao IN h_b07ad204 (INPUT INTEGER(param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT DATE(fi-data:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT DATE(fi-data-inicio-carteira:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT INTEGER(param-ge.fator-div:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT INTEGER(fi-cod-cenario:SCREEN-VALUE IN FRAME {&FRAME-NAME})).
    END.
    
    IF VALID-HANDLE(h_b08ad204) THEN DO:
        PROCESS EVENTS.
        {utp/ut-liter.i Atualizando_Fluxo_de_Caixa}
        IF VALID-HANDLE(p-window) THEN
            STATUS INPUT TRIM(RETURN-VALUE) IN WINDOW p-window.
        
        PROCESS EVENTS.
        
        IF VALID-HANDLE(h_b08ad204) THEN
            RUN pi-atualizacao IN h_b08ad204 (INPUT INTEGER(param-ge.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT DATE(fi-data:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT DATE(fi-data-inicio-carteira:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT INTEGER(param-ge.fator-div:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                              INPUT INTEGER(fi-cod-cenario:SCREEN-VALUE IN FRAME {&FRAME-NAME})).
    END.
    
    PROCESS EVENTS.
    
    IF VALID-HANDLE(p-window) THEN
        STATUS INPUT TRIM(RETURN-VALUE) IN WINDOW p-window.
    
    PROCESS EVENTS.
    
    /*--- Setar Timer ---*/
    IF NOT VALID-HANDLE(h-container) THEN DO:
        RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "CONTAINER-SOURCE":U, OUTPUT c-container).
        
        ASSIGN h-container = WIDGET-HANDLE(c-container).
    END.

    find param-ge 
        &IF "{&mguni_version}" >= "2.07A" &THEN
        where param-ge.ep-codigo = param-ge.ep-codigo:screen-value in frame {&FRAME-NAME}
        &ELSE
        where param-ge.ep-codigo = integer(param-ge.ep-codigo:screen-value in frame {&FRAME-NAME})
        &ENDIF
        no-lock no-error.
    
    IF VALID-HANDLE(h-container) 
    and avail param-ge 
    THEN
        RUN pi-recebe-segundos IN h-container (INPUT param-ge.segundo-atual).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-estado-frame V-table-Win 
PROCEDURE pi-estado-frame :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter p-estado as log.

assign p-estado = l-estado.

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
    DEFINE INPUT PARAMETER p-h_v15ad204 AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p-h_b03ad204 AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p-h_b04ad204 AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p-h_b05ad204 AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p-h_b06ad204 AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p-h_b07ad204 AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p-h_b08ad204 AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p-h_v07ad204 AS HANDLE NO-UNDO.
    
    ASSIGN h_v15ad204  = p-h_v15ad204
           h_b03ad204  = p-h_b03ad204
           h_b04ad204  = p-h_b04ad204
           h_b05ad204  = p-h_b05ad204
           h_b06ad204  = p-h_b06ad204
           h_b07ad204  = p-h_b07ad204
           h_b08ad204  = p-h_b08ad204
           h_v07ad204  = p-h_v07ad204.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-param-ge V-table-Win 
PROCEDURE pi-retorna-param-ge :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output param p-fator-div as int no-undo.

assign p-fator-div = integer(param-ge.fator-div:screen-value in frame {&frame-name}).

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
    
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
    
    /*/*    Segue um exemplo de validaá∆o de programa */
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
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
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


