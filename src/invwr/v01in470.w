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
{include/i-prgvrs.i V01IN470 2.00.00.007} /*** "010007" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN470 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

&Scop adm-attribute-dlg support/viewerd.w

DEF NEW GLOBAL SHARED VAR gr-grup-maquina AS rowid NO-UNDO.

def buffer b-gm-turno-crp for gm-turno-crp.

def var v-row-parent as rowid no-undo.
def var r-registro   as rowid no-undo.

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
&Scoped-define EXTERNAL-TABLES gm-turno-crp
&Scoped-define FIRST-EXTERNAL-TABLE gm-turno-crp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gm-turno-crp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gm-turno-crp.dt-termino 
&Scoped-define ENABLED-TABLES gm-turno-crp
&Scoped-define FIRST-ENABLED-TABLE gm-turno-crp
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS gm-turno-crp.gm-codigo ~
gm-turno-crp.dt-inicio gm-turno-crp.cod-model-turno gm-turno-crp.dt-termino 
&Scoped-define DISPLAYED-TABLES gm-turno-crp
&Scoped-define FIRST-DISPLAYED-TABLE gm-turno-crp
&Scoped-Define DISPLAYED-OBJECTS tempo-util c-desc-gm c-desc-model 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS gm-turno-crp.gm-codigo ~
gm-turno-crp.dt-inicio gm-turno-crp.cod-model-turno gm-turno-crp.dt-termino 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cod-model-turno|y|y|mgind.gm-turno-crp.cod-model-turno
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cod-model-turno",
     Keys-Supplied = "cod-model-turno"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-gm AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-model AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 32.57 BY .88 NO-UNDO.

DEFINE VARIABLE tempo-util AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77.72 BY 6.83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     gm-turno-crp.gm-codigo AT ROW 1.5 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.14 BY .88
     gm-turno-crp.dt-inicio AT ROW 2.67 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     gm-turno-crp.cod-model-turno AT ROW 3.83 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     tempo-util AT ROW 5 COL 17.29 COLON-ALIGNED
     gm-turno-crp.dt-termino AT ROW 6.17 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-desc-gm AT ROW 1.5 COL 31 COLON-ALIGNED NO-LABEL
     c-desc-model AT ROW 3.83 COL 29.86 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.gm-turno-crp
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
         HEIGHT             = 6.88
         WIDTH              = 78.
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
   NOT-VISIBLE Size-to-Fit L-To-R,COLUMNS                               */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-gm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-model IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gm-turno-crp.cod-model-turno IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN gm-turno-crp.dt-inicio IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN gm-turno-crp.dt-termino IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN gm-turno-crp.gm-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN tempo-util IN FRAME f-main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gm-turno-crp.cod-model-turno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gm-turno-crp.cod-model-turno V-table-Win
ON F5 OF gm-turno-crp.cod-model-turno IN FRAME f-main /* Modelo Turno */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in467.w"
                   &campo=gm-turno-crp.cod-model-turno
                   &campozoom=cod-model-turno
                   &campo2=c-desc-model
                   &campozoom2=des-model-turno
                   &campo3=tempo-util
                   &campozoom3=tempo-util}
                      

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gm-turno-crp.cod-model-turno V-table-Win
ON LEAVE OF gm-turno-crp.cod-model-turno IN FRAME f-main /* Modelo Turno */
DO:
    {include/leave.i &tabela=model-turno-semana 
                     &atributo-ref=des-model-turno
                     &variavel-ref=c-desc-model
                     &where="model-turno-semana.cod-model-turno = input frame {&frame-name} gm-turno-crp.cod-model-turno"}
                 
    find model-turno-semana where model-turno-semana.cod-model-turno = input frame {&frame-name} gm-turno-crp.cod-model-turno no-lock no-error.
    if avail model-turno-semana then do:
       if model-turno-semana.qtd-tempo-util-sem = 0 then
           assign tempo-util:screen-value in frame {&frame-name} = string(0).
       else               
           assign tempo-util:screen-value in frame {&frame-name} = string(model-turno-semana.qtd-tempo-util-sem).               
    end.        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gm-turno-crp.cod-model-turno V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gm-turno-crp.cod-model-turno IN FRAME f-main /* Modelo Turno */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gm-turno-crp.gm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gm-turno-crp.gm-codigo V-table-Win
ON F5 OF gm-turno-crp.gm-codigo IN FRAME f-main /* Grupo Maquina */
DO:
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gm-turno-crp.gm-codigo V-table-Win
ON LEAVE OF gm-turno-crp.gm-codigo IN FRAME f-main /* Grupo Maquina */
DO:
     {include/leave.i &tabela=grup-maquina 
                 &atributo-ref=descricao
                 &variavel-ref=c-desc-gm
                 &where="grup-maquina.gm-codigo = input frame {&frame-name} gm-turno-crp.gm-codigo"}
  
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gm-turno-crp.gm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gm-turno-crp.gm-codigo IN FRAME f-main /* Grupo Maquina */
DO:
    apply 'F5' to self.
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

if gm-turno-crp.gm-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if gm-turno-crp.cod-model-turno:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.
  DEF VAR row-avail-enabled AS LOGICAL NO-UNDO.

  /* LOCK status on the find depends on FIELDS-ENABLED. */
  RUN get-attribute ('FIELDS-ENABLED':U).
  row-avail-enabled = (RETURN-VALUE eq 'yes':U).
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'cod-model-turno':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = gm-turno-crp
           &WHERE = "WHERE gm-turno-crp.cod-model-turno eq key-value"
       }
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "gm-turno-crp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gm-turno-crp"}

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
 find grup-maquina where rowid(grup-maquina) = v-row-parent no-lock no-error. 
 if avail grup-maquina then
     assign gm-turno-crp.gm-codigo:screen-value in frame {&frame-name} = grup-maquina.gm-codigo
            gm-turno-crp.gm-codigo:sensitive in frame {&frame-name} = no
            gm-turno-crp.dt-inicio:screen-value in frame {&frame-name} = string(today)
            c-desc-gm:screen-value in frame {&frame-name} = grup-maquina.descricao.
 
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
 
    run pi-validate.
    if  RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
     /* Ponha na pi-validate todas as valida‡äes */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  find grup-maquina where rowid(grup-maquina) = v-row-parent no-error.
  if available grup-maquina  then do:
      assign gm-turno-crp.gm-codigo = grup-maquina.gm-codigo.
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

  if  available gm-turno-crp
  and adm-new-record = no then do:
      find model-turno-semana 
          where model-turno-semana.cod-model-turno = gm-turno-crp.cod-model-turno no-lock no-error.
      assign c-desc-model = if  avail model-turno-semana 
                            then model-turno-semana.des-model-turno 
                            else "":U
             r-registro   = rowid(gm-turno-crp).
      find grup-maquina 
          where grup-maquina.gm-codigo = gm-turno-crp.gm-codigo no-lock no-error.
      assign c-desc-model = if  avail grup-maquina 
                            then grup-maquina.descricao 
                            else "":U.
     find model-turno-semana 
         where model-turno-semana.cod-model-turno = gm-turno-crp.cod-model-turno no-lock no-error.
     if avail model-turno-semana then
         assign tempo-util = model-turno-semana.qtd-tempo-util-sem.
  end.
  else
      assign r-registro = ?.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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
    if adm-new-record = yes then
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

  {utp/ut-field.i mgind model-turno-semana qtd-tempo-util-sem 1}
  assign tempo-util:label in frame {&frame-name} = trim(return-value).
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if gr-grup-maquina <> ? then 
     find grup-maquina where rowid(grup-maquina) = gr-grup-maquina no-lock no-error.
  
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

    def var c-label as char no-undo.

    /* Chave duplicada */
    find b-gm-turno-crp
        where b-gm-turno-crp.gm-codigo       = input frame {&frame-name} gm-turno-crp.gm-codigo
          and b-gm-turno-crp.cod-model-turno = input frame {&frame-name} gm-turno-crp.cod-model-turno 
          and b-gm-turno-crp.dt-inicio       = input frame {&frame-name} gm-turno-crp.dt-inicio
          and adm-new-record                 = yes
        no-lock no-error.
    if  avail b-gm-turno-crp then do:
        {include/i-vldprg.i} 
        {utp/ut-table.i mgind gm-turno-crp 1} 
        run utp/ut-msgs.p (input "show":U, 
                           input 7, 
                           input return-value).
        return 'ADM-ERROR':U.
    end.
    
    /* Grupo de m quina inexistente */
    find grup-maquina 
        where grup-maquina.gm-codigo = input frame {&frame-name} gm-turno-crp.gm-codigo
        no-lock no-error.    
    if  not avail grup-maquina then do:                    
        {include/i-vldprg.i} 
        {utp/ut-field.i mgind gm-turno-crp gm-codigo 1} 
        run utp/ut-msgs.p (input "show":U, 
                           input 56, 
                           input return-value).
        return 'ADM-ERROR':U.
    end.
    
    /* Modelo de Turno Inexistente */
    find model-turno-semana 
        where model-turno-semana.cod-model-turno = input frame {&frame-name} gm-turno-crp.cod-model-turno
        no-lock no-error.    
    if  not avail model-turno-semana then do:                    
        {include/i-vldprg.i} 
        {utp/ut-field.i mgind gm-turno-crp cod-model-turno 1} 
        run utp/ut-msgs.p (input "show":U, 
                           input 56, 
                           input return-value).
        return 'ADM-ERROR':U.
    end.

    IF INPUT FRAME {&frame-name} gm-turno-crp.dt-inicio = ? or
       INPUT FRAME {&frame-name} gm-turno-crp.dt-inicio = "":U THEN DO:
        {include/i-vldprg.i} 
        {utp/ut-liter.i Data_In¡cio *} 
        run utp/ut-msgs.p (input "show":U, 
                           input 31044, 
                           input return-value).
        return 'ADM-ERROR':U.
    END.

    IF INPUT FRAME {&frame-name} gm-turno-crp.dt-termino = ? or
       INPUT FRAME {&frame-name} gm-turno-crp.dt-termino = "":U THEN DO:
        {include/i-vldprg.i} 
        {utp/ut-liter.i Data_T‚rmino *} 
        run utp/ut-msgs.p (input "show":U, 
                           input 31044, 
                           input return-value).
        return 'ADM-ERROR':U.
    END.
    
    find first gm-turno-crp
        where gm-turno-crp.gm-codigo = input frame {&frame-name} gm-turno-crp.gm-codigo
          and gm-turno-crp.dt-inicio = input frame {&frame-name} gm-turno-crp.dt-inicio
        no-lock no-error.
    if  avail gm-turno-crp
    and adm-new-record = yes then do:
        {include/i-vldprg.i} 
        
        {utp/ut-field.i mgind gm-turno-crp dt-inicio 1}
        c-label = return-value.
        
        {utp/ut-liter.i informada * R}
        c-label = c-label + ' ':U + return-value.
        
        {utp/ut-table.i mgind gm-turno-crp 1} 
        run utp/ut-msgs.p (input "show":U, 
                           input 428, 
                           input return-value + "~~" + c-label).
        apply 'entry' to gm-turno-crp.dt-inicio in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    /* Verifica data de ¡nicio */

    find first b-gm-turno-crp
        where b-gm-turno-crp.gm-codigo       = input frame {&frame-name} gm-turno-crp.gm-codigo
          and b-gm-turno-crp.cod-model-turno = input frame {&frame-name} gm-turno-crp.cod-model-turno
          and b-gm-turno-crp.dt-inicio      >= input frame {&frame-name} gm-turno-crp.dt-inicio
          and b-gm-turno-crp.dt-inicio      <  input frame {&frame-name} gm-turno-crp.dt-termino
        no-lock no-error.

    if  avail b-gm-turno-crp
    and adm-new-record = yes then do:
        {include/i-vldprg.i} 
        
        {utp/ut-field.i mgind gm-turno-crp dt-inicio 1}
        c-label = return-value.
        
        {utp/ut-liter.i informada * R}
        c-label = c-label + ' ':U + return-value.
        
        {utp/ut-table.i mgind gm-turno-crp 1} 
        run utp/ut-msgs.p (input "show":U, 
                           input 428, 
                           input return-value + "~~" + c-label).
        apply 'entry' to gm-turno-crp.dt-inicio in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    
    /* Verifica data de t‚rmino */
    
    find first b-gm-turno-crp
        where b-gm-turno-crp.gm-codigo       = input frame {&frame-name} gm-turno-crp.gm-codigo
          and b-gm-turno-crp.cod-model-turno = input frame {&frame-name} gm-turno-crp.cod-model-turno
          and b-gm-turno-crp.dt-inicio       < input frame {&frame-name} gm-turno-crp.dt-termino
          and b-gm-turno-crp.dt-termino     >= input frame {&frame-name} gm-turno-crp.dt-termino
          and rowid(b-gm-turno-crp)         <> r-registro
        no-lock no-error.
    if  avail b-gm-turno-crp then do:
        {utp/ut-field.i mgind gm-turno-crp dt-termino 1}
        c-label = return-value.
        
        {utp/ut-liter.i informada * R}
        c-label = c-label + ' ':U + return-value.
        
        {utp/ut-table.i mgind gm-turno-crp 1} 
        
        {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show":U, 
                           input 428, 
                           input return-value + "~~" + c-label).
        apply 'entry' to gm-turno-crp.dt-termino in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cod-model-turno" "gm-turno-crp" "cod-model-turno"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "gm-turno-crp"}

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

