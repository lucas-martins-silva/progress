&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V06IN686 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V06IN686 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES fam-uni-estab
&Scoped-define FIRST-EXTERNAL-TABLE fam-uni-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR fam-uni-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS fam-uni-estab.prioridade 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}prioridade ~{&FP2}prioridade ~{&FP3}
&Scoped-define ENABLED-TABLES fam-uni-estab
&Scoped-define FIRST-ENABLED-TABLE fam-uni-estab
&Scoped-Define ENABLED-OBJECTS RECT-28 RECT-33 c-liter-mps 
&Scoped-Define DISPLAYED-FIELDS fam-uni-estab.prioridade 
&Scoped-Define DISPLAYED-OBJECTS cb-ind-calc-meta cb-tipo-sched c-liter-mps ~
c-liter-crp 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cb-ind-calc-meta fam-uni-estab.prioridade ~
cb-tipo-sched 
&Scoped-define ADM-MODIFY-FIELDS cb-ind-calc-meta fam-uni-estab.prioridade ~
cb-tipo-sched 

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
DEFINE VARIABLE cb-ind-calc-meta AS CHARACTER FORMAT "X(40)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 31.14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-sched AS CHARACTER FORMAT "X(40)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-liter-crp AS CHARACTER FORMAT "X(3)":U 
      VIEW-AS TEXT 
     SIZE 6.57 BY .67 NO-UNDO.

DEFINE VARIABLE c-liter-mps AS CHARACTER FORMAT "X(3)":U 
      VIEW-AS TEXT 
     SIZE 7.43 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 1.5.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 1.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-ind-calc-meta AT ROW 1.54 COL 33.29 COLON-ALIGNED
     fam-uni-estab.prioridade AT ROW 3.42 COL 23.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     cb-tipo-sched AT ROW 3.42 COL 60.72 COLON-ALIGNED
     c-liter-mps AT ROW 1 COL 2.86 NO-LABEL
     c-liter-crp AT ROW 2.92 COL 2.43 NO-LABEL
     RECT-28 AT ROW 3.17 COL 1
     RECT-33 AT ROW 1.21 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.fam-uni-estab
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
         HEIGHT             = 3.71
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

/* SETTINGS FOR FILL-IN c-liter-crp IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-liter-mps IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX cb-ind-calc-meta IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-tipo-sched IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fam-uni-estab.prioridade IN FRAME f-main
   2 3                                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartViewerCues" V-table-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartViewer,uib,50030
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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

{utp/ut-liter.i MPS * r} assign c-liter-mps:screen-value in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i CRP * r} assign c-liter-crp:screen-value in frame {&frame-name} = trim(return-value).

{utp/ut-field.i mgind fam-uni-estab ind-calc-meta 1}
assign cb-ind-calc-meta:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind item tipo-sched  01}
assign cb-tipo-sched:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "fam-uni-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "fam-uni-estab"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}


    /* Dispatch standard ADM method.                             */
    /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) . */
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    do  with frame {&frame-name} on error undo, return "adm-error":
        assign {&adm-create-fields} {&adm-assign-fields}.  
        assign fam-uni-estab.ind-calc-meta = {ininc/i19in122.i 06 cb-ind-calc-meta}.

        if  not param-global.modulo-pc then 
            assign fam-uni-estab.prioridade:sensitive in frame {&frame-name} = no
                   fam-uni-estab.tipo-sched = {ininc/i16in122.i 06 cb-tipo-sched}.       

        if error-status:error then do:
            run dispath in this-procedure ('show-errors':U).
        end.
    end.  

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
  /**  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) . **/

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

    if avail fam-uni-estab then do with frame {&frame-name}:  
      assign cb-ind-calc-meta:screen-value         = if fam-uni-estab.ind-calc-meta <> 0 
                                                     then {ininc/i19in122.i 04 fam-uni-estab.ind-calc-meta}
                                                     else {ininc/i19in122.i 04 1}
             cb-tipo-sched:screen-value            = if  fam-uni-estab.tipo-sched <> 0 
                                                     then {ininc/i16in122.i 04 fam-uni-estab.tipo-sched}
                                                     else {ininc/i16in122.i 04 1}
             fam-uni-estab.prioridade:screen-value = string(fam-uni-estab.prioridade).
    end.
    else do:
        assign cb-ind-calc-meta:screen-value in frame {&frame-name} = {ininc/i19in122.i 04 1}
               cb-tipo-sched:screen-value    in frame {&frame-name} = {ininc/i16in122.i 04 1}.
    end.

  /* Dispatch standard ADM method.                             */
/**  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) . **/

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
/**    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ). **/

    if adm-new-record = yes then
        &if  defined(ADM-MODIFY-FIELDS) &then
            enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
        &endif

    if  param-global.modulo-pm = yes then
        assign cb-ind-calc-meta:sensitive in frame {&frame-name} = yes.
    else
        assign cb-ind-calc-meta:sensitive in frame {&frame-name} = no.

    if  param-global.modulo-pc then
        assign fam-uni-estab.prioridade:sensitive in frame {&frame-name} = yes
               cb-tipo-sched:sensitive            in frame {&frame-name} = yes.
    else
        assign fam-uni-estab.prioridade:sensitive in frame {&frame-name} = no
               cb-tipo-sched:sensitive            in frame {&frame-name} = no.

    if  param-global.modulo-pc = no then 
        assign cb-tipo-sched:sensitive            in frame {&frame-name} = no
               fam-uni-estab.prioridade:sensitive in frame {&frame-name} = no.
    else
        assign cb-tipo-sched:sensitive            in frame {&frame-name} = yes
               fam-uni-estab.prioridade:sensitive in frame {&frame-name} = yes.

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

 assign cb-ind-calc-meta:list-items in frame {&frame-name} = {ininc/i19in122.i 03}
        cb-tipo-sched:list-items in frame {&frame-name}    = {ininc/i16in122.i 03}.

 find first param-global no-lock no-error.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
    define input parameter v-row-parent-externo as rowid no-undo.

    assign v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
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
  {src/adm/template/snd-list.i "fam-uni-estab"}

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


