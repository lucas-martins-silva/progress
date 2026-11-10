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
{include/i-prgvrs.i V13AD204 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V13AD204 MUT}
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

/* Global Variable Definitions ---                                      */

/* Parameters Definitions ---                                           */

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
&Scoped-define EXTERNAL-TABLES param-ge
&Scoped-define FIRST-EXTERNAL-TABLE param-ge


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-ge.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-ge.cons-movto-bh 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES param-ge
&Scoped-define FIRST-ENABLED-TABLE param-ge
&Scoped-Define ENABLED-OBJECTS rt-pedidos-faturamento ~
rt-compras-recebimento rt-bancos-historicos fi-pedidos-faturamento ~
fi-compras-recebimento fi-bancos-historicos 
&Scoped-Define DISPLAYED-FIELDS param-ge.cons-movto-bh 
&Scoped-Define DISPLAYED-OBJECTS cb-tipo-calculo cb-tipo-calculo-compras ~
fi-pedidos-faturamento fi-compras-recebimento fi-bancos-historicos 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cb-tipo-calculo cb-tipo-calculo-compras ~
param-ge.cons-movto-bh fi-pedidos-faturamento fi-compras-recebimento ~
fi-bancos-historicos 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-tipo-calculo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo C lculo" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS " "
     SIZE 33 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-calculo-compras AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo C lculo" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS " "
     SIZE 33 BY 1 NO-UNDO.

DEFINE VARIABLE fi-bancos-historicos AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 17 BY .67 NO-UNDO.

DEFINE VARIABLE fi-compras-recebimento AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 28 BY .67 NO-UNDO.

DEFINE VARIABLE fi-pedidos-faturamento AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 28 BY .67 NO-UNDO.

DEFINE RECTANGLE rt-bancos-historicos
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 1.33.

DEFINE RECTANGLE rt-compras-recebimento
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 1.5.

DEFINE RECTANGLE rt-pedidos-faturamento
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 1.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-tipo-calculo AT ROW 1.58 COL 29 COLON-ALIGNED
     cb-tipo-calculo-compras AT ROW 3.5 COL 29 COLON-ALIGNED
     param-ge.cons-movto-bh AT ROW 5.63 COL 31
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .83
     fi-pedidos-faturamento AT ROW 1 COL 2 NO-LABEL
     fi-compras-recebimento AT ROW 3 COL 2 NO-LABEL
     fi-bancos-historicos AT ROW 5 COL 2 NO-LABEL
     rt-pedidos-faturamento AT ROW 1.33 COL 1
     rt-compras-recebimento AT ROW 3.25 COL 1
     rt-bancos-historicos AT ROW 5.25 COL 1
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
         HEIGHT             = 5.58
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

/* SETTINGS FOR COMBO-BOX cb-tipo-calculo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR COMBO-BOX cb-tipo-calculo-compras IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR TOGGLE-BOX param-ge.cons-movto-bh IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-bancos-historicos IN FRAME f-main
   ALIGN-L 2                                                            */
/* SETTINGS FOR FILL-IN fi-compras-recebimento IN FRAME f-main
   ALIGN-L 2                                                            */
/* SETTINGS FOR FILL-IN fi-pedidos-faturamento IN FRAME f-main
   ALIGN-L 2                                                            */
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

{utp/ut-liter.i Pedidos_e_Faturamento}
ASSIGN fi-pedidos-faturamento = TRIM(RETURN-VALUE)
       fi-pedidos-faturamento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = fi-pedidos-faturamento.

{utp/ut-liter.i Tipo_C lculo}
ASSIGN cb-tipo-calculo:LABEL IN FRAME {&FRAME-NAME}        = TRIM(RETURN-VALUE)
       cb-tipo-calculo:LIST-ITEMS IN FRAME {&FRAME-NAME}   = {adinc/i04ad204.i 03}
       cb-tipo-calculo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {adinc/i04ad204.i 04 1}.

{utp/ut-field.i mgadm param-ge tp-calc-ft-pd 3}
ASSIGN cb-tipo-calculo:HELP IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

{utp/ut-liter.i Compras_e_Recebimento}
ASSIGN fi-compras-recebimento = TRIM(RETURN-VALUE)
       fi-compras-recebimento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = fi-compras-recebimento.

{utp/ut-liter.i Tipo_C lculo}
ASSIGN cb-tipo-calculo-compras:LABEL IN FRAME {&FRAME-NAME}        = TRIM(RETURN-VALUE)
       cb-tipo-calculo-compras:LIST-ITEMS IN FRAME {&FRAME-NAME}   = {adinc/i04ad204.i 03}
       cb-tipo-calculo-compras:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {adinc/i04ad204.i 04 1}.


{utp/ut-liter.i Bancos_Hist¢ricos}
ASSIGN fi-bancos-historicos = TRIM(RETURN-VALUE)
       fi-bancos-historicos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = fi-bancos-historicos.

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
    DISPLAY fi-pedidos-faturamento fi-compras-recebimento fi-bancos-historicos
        WITH FRAME {&FRAME-NAME}.
    
    ASSIGN cb-tipo-calculo:SCREEN-VALUE IN FRAME {&FRAME-NAME}         = {adinc/i04ad204.i 04 1}
           cb-tipo-calculo-compras:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {adinc/i04ad204.i 04 1}
           mgadm.param-ge.cons-movto-bh:checked in frame {&FRAME-NAME} = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-tipo-calculo         AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-tipo-calculo-compras AS INTEGER NO-UNDO.
    
    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    ASSIGN FRAME {&FRAME-NAME} cb-tipo-calculo cb-tipo-calculo-compras.
    
    ASSIGN i-tipo-calculo         = INTEGER(cb-tipo-calculo:LOOKUP(cb-tipo-calculo) IN FRAME {&FRAME-NAME})
           i-tipo-calculo-compras = INTEGER(cb-tipo-calculo-compras:LOOKUP(cb-tipo-calculo-compras) IN FRAME {&FRAME-NAME}).
    
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN param-ge.tp-calc-ft-pd = i-tipo-calculo
           param-ge.tp-calc-cc-re = i-tipo-calculo-compras.

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
    
    ASSIGN cb-tipo-calculo:SENSITIVE IN FRAME {&FRAME-NAME}         = NO
           cb-tipo-calculo-compras:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
    ASSIGN cb-tipo-calculo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAILABLE param-ge AND param-ge.tp-calc-ft-pd <> 0
                                                                 THEN {adinc/i04ad204.i 04 INTEGER(param-ge.tp-calc-ft-pd)}
                                                                 ELSE {adinc/i04ad204.i 04 1}
           cb-tipo-calculo-compras:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAILABLE param-ge AND param-ge.tp-calc-cc-re <> 0
                                                                         THEN {adinc/i04ad204.i 04 INTEGER(param-ge.tp-calc-cc-re)}
                                                                         ELSE {adinc/i04ad204.i 04 1}.

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
    
    &IF DEFINED(ADM-MODIFY-FIELDS) &THEN
        IF adm-new-record THEN
            ENABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&FRAME-NAME}.
    &ENDIF
    
    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF AVAILABLE param-global AND param-global.modulo-bh THEN
        ASSIGN param-ge.cons-movto-bh:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-change V-table-Win 
PROCEDURE pi-change :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-modulo-pd AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-modulo-ft AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-modulo-cc AS LOGICAL NO-UNDO.
    
    ASSIGN cb-tipo-calculo:SENSITIVE IN FRAME {&FRAME-NAME}         = p-modulo-pd OR p-modulo-ft
           cb-tipo-calculo-compras:SENSITIVE IN FRAME {&FRAME-NAME} = p-modulo-cc.

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


