&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
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
{include/i-prgvrs.i V02IN013 2.00.00.002 } /*** 010002 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v02in013 MUT}
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

def new global shared var gr-mla-tipo-doc-aprov as rowid no-undo.

def buffer b-mla-hierarquia-aprov for mla-hierarquia-aprov.

def new global shared var g-empresa-aed LIKE empresa.ep-codigo no-undo.
def new global shared var gc-estabel-aed LIKE estabelec.cod-estabel    no-undo.

def var c-log-reg as char no-undo.

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
&Scoped-define EXTERNAL-TABLES mla-hierarquia-aprov
&Scoped-define FIRST-EXTERNAL-TABLE mla-hierarquia-aprov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR mla-hierarquia-aprov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS mla-hierarquia-aprov.log-depend 
&Scoped-define ENABLED-TABLES mla-hierarquia-aprov
&Scoped-define FIRST-ENABLED-TABLE mla-hierarquia-aprov
&Scoped-Define ENABLED-OBJECTS RECT-16 
&Scoped-Define DISPLAYED-FIELDS mla-hierarquia-aprov.cod-usuar ~
mla-hierarquia-aprov.log-depend 
&Scoped-define DISPLAYED-TABLES mla-hierarquia-aprov
&Scoped-define FIRST-DISPLAYED-TABLE mla-hierarquia-aprov
&Scoped-Define DISPLAYED-OBJECTS c-desc-usuar 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS mla-hierarquia-aprov.cod-usuar 

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
DEFINE VARIABLE c-desc-usuar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79.29 BY 2.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     mla-hierarquia-aprov.cod-usuar AT ROW 1.25 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.72 BY .88
     c-desc-usuar AT ROW 1.25 COL 33.72 COLON-ALIGNED NO-LABEL
     mla-hierarquia-aprov.log-depend AT ROW 2.38 COL 19
          VIEW-AS TOGGLE-BOX
          SIZE 22.57 BY .83
     RECT-16 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.mla-hierarquia-aprov
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
         HEIGHT             = 2.5
         WIDTH              = 79.29.
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

/* SETTINGS FOR FILL-IN c-desc-usuar IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN mla-hierarquia-aprov.cod-usuar IN FRAME f-main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME mla-hierarquia-aprov.cod-usuar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-hierarquia-aprov.cod-usuar V-table-Win
ON F5 OF mla-hierarquia-aprov.cod-usuar IN FRAME f-main /* Usu rio */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z02in785.w
                       &campo=mla-hierarquia-aprov.cod-usuar
                       &campozoom=cod-usuar}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-hierarquia-aprov.cod-usuar V-table-Win
ON LEAVE OF mla-hierarquia-aprov.cod-usuar IN FRAME f-main /* Usu rio */
DO:

    {include/leave.i &tabela=mla-usuar-aprov
                     &atributo-ref=nome-usuar
                     &variavel-ref=c-desc-usuar
                     &where="mla-usuar-aprov.cod-usuar = input frame {&frame-name} mla-hierarquia-aprov.cod-usuar"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-hierarquia-aprov.cod-usuar V-table-Win
ON MOUSE-SELECT-DBLCLICK OF mla-hierarquia-aprov.cod-usuar IN FRAME f-main /* Usu rio */
DO:

    apply 'f5' to self.  
  
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

  if mla-hierarquia-aprov.cod-usuar:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "mla-hierarquia-aprov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "mla-hierarquia-aprov"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  assign mla-hierarquia-aprov.log-depend:CHECKED    IN FRAME {&FRAME-NAME} = NO
         mla-hierarquia-aprov.log-depend:SENSITIVE  IN FRAME {&FRAME-NAME} = NO.

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
    
    if adm-new-record then do:
        find first mla-usuar-aprov where
            mla-usuar-aprov.cod-usuar = input frame {&frame-name} mla-hierarquia-aprov.cod-usuar
            no-lock no-error.
        if not available mla-usuar-aprov then do:
            {utp/ut-table.i mgind mla-usuar-aprov 1}
            run utp/ut-msgs.p ("show",2,trim(return-value)).
            apply "entry" to mla-hierarquia-aprov.cod-usuar in frame {&frame-name}.
            return "adm-error".                    
        end.
    end.

    if not adm-new-record then
        run pi-log-reg.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    assign mla-hierarquia-aprov.ep-codigo   = g-empresa-aed
           mla-hierarquia-aprov.cod-estabel = gc-estabel-aed.

    if adm-new-record and
       available mla-lotacao then do:    
        find last b-mla-hierarquia-aprov where
            b-mla-hierarquia-aprov.ep-codigo   = g-empresa-aed and
            b-mla-hierarquia-aprov.cod-estabel = gc-estabel-aed and
            b-mla-hierarquia-aprov.cod-tip-doc = mla-tipo-doc-aprov.cod-tip-doc and
            b-mla-hierarquia-aprov.cod-lotacao = mla-lotacao.cod-lotacao
            no-lock no-error.
        if available b-mla-hierarquia-aprov then
            assign mla-hierarquia-aprov.seq-aprov = b-mla-hierarquia-aprov.seq-aprov + 1.
        else
            assign mla-hierarquia-aprov.seq-aprov = 1.
    end.            
    
    if adm-new-record then do:
        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-hierarquia-aprov.ep-codigo
               mla-log-reg.cod-estabel = mla-hierarquia-aprov.cod-estabel
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 4
               mla-log-reg.chave-reg   = string(mla-hierarquia-aprov.cod-lotacao) + " | " +
                                         string(mla-hierarquia-aprov.cod-tip-doc) + " | " +
                                         string(mla-hierarquia-aprov.seq-aprov)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 1
               mla-log-reg.log-reg     = entry(4,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                         "Lota‡Æo            : " + string(mla-hierarquia-aprov.cod-lotacao) + chr(13) +
                                         "Documento          : " + string(mla-hierarquia-aprov.cod-tip-doc) + chr(13) + 
                                         "Sequˆncia          : " + string(mla-hierarquia-aprov.seq-aprov)   + chr(13) +                                   
                                         "Usu rio            : " + string(mla-hierarquia-aprov.cod-usuar)   + chr(13) +                                   
                                         "Dependˆncia        : " + string(mla-hierarquia-aprov.log-depend).
    end.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

    find first mla-tipo-doc-aprov where
        rowid(mla-tipo-doc-aprov) = gr-mla-tipo-doc-aprov
        no-lock no-error.
    find first mla-lotacao where
        rowid(mla-lotacao) = v-row-parent
        no-lock no-error.
    if available mla-lotacao then
        assign mla-hierarquia-aprov.cod-lotacao = mla-lotacao.cod-lotacao
               mla-hierarquia-aprov.cod-tip-doc = mla-tipo-doc-aprov.cod-tip-doc
               mla-hierarquia-aprov.log-depend  = NO.

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

    if available mla-hierarquia-aprov then do:
        find first mla-usuar-aprov where
            mla-usuar-aprov.cod-usuar = mla-hierarquia-aprov.cod-usuar
            no-lock no-error.
        if available mla-usuar-aprov then 
            assign c-desc-usuar:screen-value in frame {&frame-name} =
                   mla-usuar-aprov.nome-usuar.
    end.

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
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    IF  AVAIL mla-hierarquia-aprov THEN DO WITH FRAME {&FRAME-NAME}:
        find first mla-tipo-doc-aprov where
            rowid(mla-tipo-doc-aprov) = gr-mla-tipo-doc-aprov no-lock no-error.
        find first mla-lotacao where
            rowid(mla-lotacao) = v-row-parent no-lock no-error.

        FIND FIRST b-mla-hierarquia-aprov no-lock
             WHERE b-mla-hierarquia-aprov.ep-codigo   = mla-hierarquia-aprov.ep-codigo
             and   b-mla-hierarquia-aprov.cod-estabel = mla-hierarquia-aprov.cod-estabel
             and   b-mla-hierarquia-aprov.cod-lotacao = mla-lotacao.cod-lotacao 
             AND   b-mla-hierarquia-aprov.cod-tip-doc = mla-tipo-doc-aprov.cod-tip-doc 
             AND   b-mla-hierarquia-aprov.seq-aprov   = (mla-hierarquia-aprov.seq-aprov + 1) no-error.
        if NOT avail b-mla-hierarquia-aprov then 
            assign mla-hierarquia-aprov.log-depend:CHECKED   = NO
                   mla-hierarquia-aprov.log-depend:SENSITIVE = NO.
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
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-log-reg V-table-Win 
PROCEDURE pi-log-reg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign c-log-reg = "".
    
    if available mla-hierarquia-aprov then do:
        if mla-hierarquia-aprov.log-depend <> mla-hierarquia-aprov.log-depend:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg + 
                   "Dependˆncia        : " + string(mla-hierarquia-aprov.log-depend) + chr(13) + 
                   "                   : " + string(mla-hierarquia-aprov.log-depend:checked in frame {&frame-name}).
    end.
    
    if c-log-reg <> "" then do:
        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-hierarquia-aprov.ep-codigo
               mla-log-reg.cod-estabel = mla-hierarquia-aprov.cod-estabel
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 4
               mla-log-reg.chave-reg   = string(mla-hierarquia-aprov.cod-lotacao) + " | " +
                                         string(mla-hierarquia-aprov.cod-tip-doc) + " | " +
                                         string(mla-hierarquia-aprov.seq-aprov)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 2
               mla-log-reg.log-reg     = entry(4,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                         c-log-reg.
    end.

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
  {src/adm/template/snd-list.i "mla-hierarquia-aprov"}

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

