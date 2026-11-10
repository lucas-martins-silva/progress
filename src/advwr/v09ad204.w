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
{include/i-prgvrs.i V09AD204 2.00.00.004} /*** "010004" 25/06/2025 16:21:13  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V09AD204 MUT}
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
DEFINE NEW GLOBAL SHARED VARIABLE v-row-parent AS ROWID NO-UNDO.

/* Local Variable Definitions ---                                       */

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
&Scoped-Define ENABLED-FIELDS param-ge.ativo param-ge.vl-disp-ini ~
param-ge.calc-disponivel param-ge.fator-div param-ge.segundo-atual ~
param-ge.horiz-at-diaria param-ge.servid-rpw param-ge.informa-data 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}vl-disp-ini ~{&FP2}vl-disp-ini ~{&FP3}~
 ~{&FP1}fator-div ~{&FP2}fator-div ~{&FP3}~
 ~{&FP1}segundo-atual ~{&FP2}segundo-atual ~{&FP3}~
 ~{&FP1}horiz-at-diaria ~{&FP2}horiz-at-diaria ~{&FP3}~
 ~{&FP1}servid-rpw ~{&FP2}servid-rpw ~{&FP3}
&Scoped-define ENABLED-TABLES param-ge
&Scoped-define FIRST-ENABLED-TABLE param-ge
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS param-ge.ativo param-ge.vl-disp-ini ~
param-ge.calc-disponivel param-ge.fator-div param-ge.segundo-atual ~
param-ge.horiz-at-diaria param-ge.servid-rpw param-ge.informa-data ~
param-ge.dt-ult-at-dia param-ge.hr-ult-at-dia param-ge.dt-ult-at-total ~
param-ge.hr-ult-at-total param-ge.ult-proc-efet 
&Scoped-Define DISPLAYED-OBJECTS tg-recalcula-obj tg-reenvia-email ~
fi-data-inicial-calculo c-desc-servidor 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS tg-recalcula-obj tg-reenvia-email ~
fi-data-inicial-calculo 

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
DEFINE VARIABLE c-desc-servidor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data-inicial-calculo AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 11.25.

DEFINE VARIABLE tg-recalcula-obj AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-reenvia-email AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-ge.ativo AT ROW 1.25 COL 28
          VIEW-AS TOGGLE-BOX
          SIZE 8 BY .75
     param-ge.vl-disp-ini AT ROW 2.17 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 24 BY .88
     param-ge.calc-disponivel AT ROW 2.25 COL 28
          VIEW-AS TOGGLE-BOX
          SIZE 22 BY .75
     tg-recalcula-obj AT ROW 3.25 COL 28
     tg-reenvia-email AT ROW 3.25 COL 62
     param-ge.fator-div AT ROW 4.17 COL 26 COLON-ALIGNED HELP
          "Fator de ConversÆo Utilizado na Consulta Gerencial"
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     param-ge.segundo-atual AT ROW 5.17 COL 26 COLON-ALIGNED HELP
          "Segundos de Atualiza‡Æo Utilizado na Consulta Gerencial"
          LABEL "Seg. Atualiza‡Æo":R24 FORMAT ">,>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 14.86 BY .88
     param-ge.horiz-at-diaria AT ROW 6.17 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     fi-data-inicial-calculo AT ROW 6.17 COL 45 COLON-ALIGNED
     param-ge.servid-rpw AT ROW 7.17 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-desc-servidor AT ROW 7.17 COL 38.57 COLON-ALIGNED NO-LABEL
     param-ge.informa-data AT ROW 8.17 COL 28
          VIEW-AS TOGGLE-BOX
          SIZE 27 BY .88
     param-ge.dt-ult-at-dia AT ROW 9.17 COL 26 COLON-ALIGNED FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     param-ge.hr-ult-at-dia AT ROW 9.17 COL 50 COLON-ALIGNED FORMAT "99X99X99"
          VIEW-AS FILL-IN 
          SIZE 8.14 BY .88
     param-ge.dt-ult-at-total AT ROW 10.17 COL 26 COLON-ALIGNED FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     param-ge.hr-ult-at-total AT ROW 10.17 COL 50 COLON-ALIGNED FORMAT "99X99X99"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     param-ge.ult-proc-efet AT ROW 11.17 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 57 BY .88
     rt-mold AT ROW 1 COL 1
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
         HEIGHT             = 11.25
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

/* SETTINGS FOR FILL-IN c-desc-servidor IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN param-ge.dt-ult-at-dia IN FRAME f-main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN param-ge.dt-ult-at-total IN FRAME f-main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN param-ge.fator-div IN FRAME f-main
   EXP-HELP                                                             */
/* SETTINGS FOR FILL-IN fi-data-inicial-calculo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN param-ge.hr-ult-at-dia IN FRAME f-main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN param-ge.hr-ult-at-total IN FRAME f-main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN param-ge.segundo-atual IN FRAME f-main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR TOGGLE-BOX tg-recalcula-obj IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR TOGGLE-BOX tg-reenvia-email IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN param-ge.ult-proc-efet IN FRAME f-main
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

&Scoped-define SELF-NAME param-ge.calc-disponivel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.calc-disponivel V-table-Win
ON VALUE-CHANGED OF param-ge.calc-disponivel IN FRAME f-main /* Calcula Disponivel */
DO:
    ASSIGN param-ge.vl-disp-ini:SENSITIVE = NOT param-ge.calc-disponivel:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-ge.servid-rpw
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.servid-rpw V-table-Win
ON F5 OF param-ge.servid-rpw IN FRAME f-main /* Servidor RPW */
OR MOUSE-SELECT-DBLCLICK OF param-ge.servid-rpw IN FRAME {&FRAME-NAME} DO:
    ASSIGN l-implanta = YES.
    
    {include/zoomvar.i &prog-zoom=unzoom\z01un135.w
                       &campo=param-ge.servid-rpw 
                       &campozoom=cod_servid_exec
                       &campo2=c-desc-servidor
                       &campozoom2=des_servid_exec}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-ge.servid-rpw V-table-Win
ON LEAVE OF param-ge.servid-rpw IN FRAME f-main /* Servidor RPW */
DO:
    {include/leave.i &tabela=servid_exec
                     &atributo-ref=des_servid_exec
                     &variavel-ref=c-desc-servidor
                     &where="servid_exec.cod_servid_exec = param-ge.servid-rpw:SCREEN-VALUE"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-recalcula-obj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-recalcula-obj V-table-Win
ON VALUE-CHANGED OF tg-recalcula-obj IN FRAME f-main
DO:
    ASSIGN tg-reenvia-email:SENSITIVE = tg-recalcula-obj:CHECKED
           tg-reenvia-email:CHECKED   = IF tg-recalcula-obj:CHECKED THEN tg-reenvia-email:CHECKED ELSE NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

param-ge.servid-rpw:LOAD-MOUSE-POINTER("image/lupa") IN FRAME {&FRAME-NAME}.

{utp/ut-liter.i Valor_Dispon¡vel}
ASSIGN param-ge.vl-disp-ini:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Recalcula_Objetivos}
ASSIGN tg-recalcula-obj:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Recalcula_objetivos_j _realizados?}
ASSIGN tg-recalcula-obj:HELP IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Reenvia_E-mails}
ASSIGN tg-reenvia-email:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Reenvia_e-mails_para_objetivos_recalculados?}
ASSIGN tg-reenvia-email:HELP IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Dt_Inicial_C lculo}
ASSIGN fi-data-inicial-calculo:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Data_Inicial_que_o_Gerencial_passar _a_considerar_os_movimentos}
ASSIGN fi-data-inicial-calculo:HELP IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Hora_Atual_Total}
ASSIGN param-ge.hr-ult-at-total:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

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
  
  assign fi-data-inicial-calculo:screen-value in frame {&FRAME-NAME} = "01/01/" + string(year(today),"9999").
  APPLY "VALUE-CHANGED":U TO param-ge.calc-disponivel IN FRAME {&FRAME-NAME}.


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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).

    /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN 
        &IF "{&mgadm_version}":U = "2.03":U &THEN
           param-ge.log-1             = tg-recalcula-obj
        &ELSE
           param-ge.log-reatu-obj    = tg-recalcula-obj
        &ENDIF
        
        &IF "{&mgadm_version}":U = "2.03":U &THEN
           param-ge.log-2             = tg-reenvia-email
        &ELSE
           param-ge.log-reenvia-email-obj = tg-reenvia-email
        &ENDIF
        
        &IF "{&mgadm_version}":U = "2.03":U &THEN
           param-ge.usuario           = STRING(fi-data-inicial-calculo, "99/99/9999":U).
        &ELSE
           param-ge.dt-inicio-ge      = fi-data-inicial-calculo.
        &ENDIF
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
    
    ASSIGN tg-recalcula-obj:SENSITIVE IN FRAME {&FRAME-NAME}        = NO
           tg-reenvia-email:SENSITIVE IN FRAME {&FRAME-NAME}        = NO
           fi-data-inicial-calculo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
    IF AVAILABLE param-ge THEN
        ASSIGN tg-recalcula-obj:CHECKED IN FRAME {&FRAME-NAME} = &IF "{&mgadm_version}":U = "2.03":U &THEN
                                                                    param-ge.log-1
                                                                 &ELSE
                                                                    param-ge.log-reatu-obj
                                                                 &ENDIF
               tg-reenvia-email:CHECKED IN FRAME {&FRAME-NAME} = &IF "{&mgadm_version}":U = "2.03":U &THEN
                                                                    param-ge.log-2
                                                                 &ELSE
                                                                    param-ge.log-reenvia-email-obj
                                                                 &ENDIF
               fi-data-inicial-calculo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                                                                 &IF "{&mgadm_version}":U = "2.03":U &THEN
                                                                    STRING(param-ge.usuario).
                                                                 &ELSE
                                                                    STRING(param-ge.dt-inicio-ge).
                                                                 &ENDIF
    ELSE
        ASSIGN tg-recalcula-obj:CHECKED IN FRAME {&FRAME-NAME}             = NO
               tg-reenvia-email:CHECKED IN FRAME {&FRAME-NAME}             = NO
               fi-data-inicial-calculo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ?.
    
    APPLY "LEAVE":U TO param-ge.servid-rpw IN FRAME {&FRAME-NAME}.

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
        ENABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&FRAME-NAME}.
    &ENDIF
    
    ASSIGN tg-recalcula-obj:SENSITIVE IN FRAME {&FRAME-NAME}        = YES
           fi-data-inicial-calculo:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    
    APPLY "VALUE-CHANGED":U TO param-ge.calc-disponivel IN FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO tg-recalcula-obj IN FRAME {&FRAME-NAME}.

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
    
    IF NOT CAN-FIND(FIRST servid_exec WHERE servid_exec.cod_servid_exec = param-ge.servid-rpw:SCREEN-VALUE) 
        and param-ge.servid-rpw:SCREEN-VALUE <> ""
    THEN DO:
        {include/i-vldprg.i}
        
        {utp/ut-table.i mguni servid_exec 1}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 56, INPUT TRIM(RETURN-VALUE)).
        
        APPLY "ENTRY":U TO param-ge.servid-rpw IN FRAME {&FRAME-NAME}.
        
        RETURN "ADM-ERROR":U.
    END.
    
    IF DATE(fi-data-inicial-calculo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = ? THEN DO:
        {include/i-vldprg.i}
        
        {utp/ut-liter.i Dt_Inicial_C lculo}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 25379, INPUT TRIM(RETURN-VALUE)).
        
        APPLY "ENTRY":U TO fi-data-inicial-calculo IN FRAME {&FRAME-NAME}.
        
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


