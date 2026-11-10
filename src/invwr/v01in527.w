&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mgmfg            PROGRESS
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
{include/i-prgvrs.i V01IN527 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN527 MUT}
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



DEF NEW GLOBAL SHARED VAR gr-model-turno-ctrab AS rowid NO-UNDO.
def new global shared var gr-area-produc       as rowid no-undo.

def buffer b-model-turno-ctrab for model-turno-ctrab .

def var v-row-parent as rowid no-undo.

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
&Scoped-define EXTERNAL-TABLES model-turno-ctrab
&Scoped-define FIRST-EXTERNAL-TABLE model-turno-ctrab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR model-turno-ctrab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS model-turno-ctrab.dat-fim-valid 
&Scoped-define ENABLED-TABLES model-turno-ctrab
&Scoped-define FIRST-ENABLED-TABLE model-turno-ctrab
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS model-turno-ctrab.cod-model-turno ~
model-turno-ctrab.dat-inic-valid model-turno-ctrab.dat-fim-valid 
&Scoped-define DISPLAYED-TABLES model-turno-ctrab
&Scoped-define FIRST-DISPLAYED-TABLE model-turno-ctrab
&Scoped-Define DISPLAYED-OBJECTS c-desc-model tempo-util 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS model-turno-ctrab.cod-model-turno ~
model-turno-ctrab.dat-inic-valid model-turno-ctrab.dat-fim-valid 
&Scoped-define ADM-ASSIGN-FIELDS model-turno-ctrab.dat-fim-valid 
&Scoped-define ADM-MODIFY-FIELDS model-turno-ctrab.dat-fim-valid 

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
DEFINE VARIABLE c-desc-model AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE tempo-util AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Tempo util" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79.29 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79.29 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     model-turno-ctrab.cod-model-turno AT ROW 1.21 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-model AT ROW 1.21 COL 34 COLON-ALIGNED NO-LABEL
     tempo-util AT ROW 2.42 COL 16.72 COLON-ALIGNED
     model-turno-ctrab.dat-inic-valid AT ROW 3.42 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     model-turno-ctrab.dat-fim-valid AT ROW 4.42 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.model-turno-ctrab
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
         HEIGHT             = 4.83
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

/* SETTINGS FOR FILL-IN c-desc-model IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN model-turno-ctrab.cod-model-turno IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN model-turno-ctrab.dat-fim-valid IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN model-turno-ctrab.dat-inic-valid IN FRAME f-main
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

&Scoped-define SELF-NAME c-desc-model
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-desc-model V-table-Win
ON F5 OF c-desc-model IN FRAME f-main
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in467.w"
                   &campo=model-turno-ctrab.cod-model-turno
                   &campozoom=cod-model-turno
                   &campo2=c-desc-model
                   &campozoom2=des-model-turno
                   &campo3=tempo-util
                   &campozoom3=tempo-util}
                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-desc-model V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-desc-model IN FRAME f-main
DO:
     apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME model-turno-ctrab.cod-model-turno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL model-turno-ctrab.cod-model-turno V-table-Win
ON F5 OF model-turno-ctrab.cod-model-turno IN FRAME f-main /* Modelo Turno */
DO:
     assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in467.w"
                   &campo=model-turno-ctrab.cod-model-turno
                   &campozoom=cod-model-turno
                   &campo2=c-desc-model
                   &campozoom2=des-model-turno
                   &campo3=tempo-util
                   &campozoom3=tempo-util}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL model-turno-ctrab.cod-model-turno V-table-Win
ON LEAVE OF model-turno-ctrab.cod-model-turno IN FRAME f-main /* Modelo Turno */
DO:
     {include/leave.i &tabela=model-turno-semana 
                     &atributo-ref=des-model-turno
                     &variavel-ref=c-desc-model
                     &where="model-turno-semana.cod-model-turno = input frame {&frame-name} model-turno-ctrab.cod-model-turno"}
                 
    find FIRST model-turno-semana 
         where model-turno-semana.cod-model-turno = input frame {&frame-name} model-turno-ctrab.cod-model-turno no-lock no-error.
    if avail model-turno-semana then do:
       if model-turno-semana.qtd-tempo-util-sem = 0 then
           assign tempo-util:screen-value in frame {&frame-name} = string(0).
       else               
           assign tempo-util:screen-value in frame {&frame-name} = string(model-turno-semana.qtd-tempo-util-sem).               
    end.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL model-turno-ctrab.cod-model-turno V-table-Win
ON MOUSE-SELECT-DBLCLICK OF model-turno-ctrab.cod-model-turno IN FRAME f-main /* Modelo Turno */
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

model-turno-ctrab.cod-model-turno:load-mouse-pointer ("image/lupa.cur":U) in frame {&frame-name}.

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
  {src/adm/template/row-list.i "model-turno-ctrab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "model-turno-ctrab"}

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
 find first model-turno-ctrab where 
      model-turno-ctrab.cod-model-turno = input frame   {&frame-name} model-turno-ctrab.cod-model-turno exclusive-lock NO-ERROR.          
 if avail model-turno-ctrab then
     assign model-turno-ctrab.cod-model-turno:sensitive in frame {&frame-name} = yes
            model-turno-ctrab.cod-model-turno:screen-value in frame {&frame-name} = model-turno-ctrab.cod-model-turno
            model-turno-ctrab.dat-inic-valid:sensitive in frame {&frame-name} = yes
            model-turno-ctrab.dat-inic-valid:screen-value in frame {&frame-name} = string(today) 
            model-turno-ctrab.dat-fim-valid:sensitive in frame {&frame-name} = yes .
 find FIRST model-turno-semana 
      WHERE model-turno-semana.cod-model-turno = model-turno-ctrab.cod-model-turno NO-LOCK no-error.
 if avail model-turno-semana then
    assign c-desc-model:screen-value in frame {&frame-name} = model-turno-semana.des-model-turno .
 
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
 
     /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    apply 'entry' to model-turno-ctrab.dat-inic-valid in frame {&frame-name}.
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */


    find FIRST area-produc
         where rowid(area-produc) = gr-area-produc no-lock no-error.
    
    if avail model-turno-ctrab then
        assign model-turno-ctrab.cod-ctrab = area-produc.cod-area .
 
    run pi-atualiza-turnos.
    
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

  if  available model-turno-ctrab and adm-new-record = no then do:
      find FIRST model-turno-semana  where 
                 model-turno-semana.cod-model-turno = model-turno-ctrab.cod-model-turno no-lock no-error.
      assign c-desc-model = if  avail model-turno-semana 
                            then model-turno-semana.des-model-turno 
                            else "":U
             r-registro-atual   = rowid(model-turno-ctrab).
      
     find FIRST model-turno-semana  where 
                model-turno-semana.cod-model-turno = model-turno-ctrab.cod-model-turno no-lock no-error.
     if avail model-turno-semana then
         assign tempo-util = model-turno-semana.qtd-tempo-util-sem.
  
  end.
  else
      assign r-registro-atual = ?.
  
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
  run get-attribute ('adm-new-record').
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

  {utp/ut-field.i mgind model-turno-semana qtd-tempo-util-sem 1}
  assign tempo-util:label in frame {&frame-name} = trim(return-value).
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-turnos V-table-Win 
PROCEDURE pi-atualiza-turnos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def buffer b-model-turno-ctrab  for model-turno-ctrab.
def buffer b1-model-turno-ctrab for model-turno-ctrab.
def buffer b-area               for area-produc .
 
  
find first b-area where 
           b-area.cod-area-produc = area-produc.cod-area-produc no-lock no-error.
if avail b-area then do :
                 
      find first b-model-turno-ctrab exclusive-lock
           where /* b-model-turno-ctrab.cod-model-turno =  b-area.cod-model-turno 
             and */ b-model-turno-ctrab.cod-ctrab       =  b-area.cod-area-produc
             and b-model-turno-ctrab.dat-inic-valid  <  model-turno-ctrab.dat-inic-valid
             and b-model-turno-ctrab.dat-fim-valid   >  model-turno-ctrab.dat-inic-valid
             and b-model-turno-ctrab.dat-fim-valid   <= model-turno-ctrab.dat-fim-valid  no-error.

      if  available b-model-turno-ctrab
      then do:
        
          assign  b-model-turno-ctrab.dat-fim-valid = model-turno-ctrab.dat-inic-valid.
      end /* if */.
   
      find first b-model-turno-ctrab exclusive-lock
           where /*b-model-turno-ctrab.cod-model-turno = b-area.cod-model-turno
             and */ b-model-turno-ctrab.cod-ctrab       = b-area.cod-area-produc
             and b-model-turno-ctrab.dat-inic-valid  < model-turno-ctrab.dat-inic-valid
             and b-model-turno-ctrab.dat-fim-valid   > model-turno-ctrab.dat-fim-valid no-error.
      if  available b-model-turno-ctrab
      then do:
          
         create b1-model-turno-ctrab.
         assign b1-model-turno-ctrab.cod-model-turno = b-model-turno-ctrab.cod-model-turno
                b1-model-turno-ctrab.cod-ctrab       = b-area.cod-area-produc
                b1-model-turno-ctrab.dat-fim-valid   = b-model-turno-ctrab.dat-fim-valid
                b-model-turno-ctrab.dat-fim-valid    = model-turno-ctrab.dat-inic-valid
                b1-model-turno-ctrab.dat-inic-valid  = model-turno-ctrab.dat-fim-valid.
           
          
      end /* if */.
   
      block2:
      for each b-model-turno-ctrab exclusive-lock
       where /*b-model-turno-ctrab.cod-model-turno = b-area.cod-model-turno
         and */ b-model-turno-ctrab.cod-ctrab       = b-area.cod-area-produc
         and b-model-turno-ctrab.dat-inic-valid  > model-turno-ctrab.dat-inic-valid
         and b-model-turno-ctrab.dat-fim-valid   <= model-turno-ctrab.dat-fim-valid.
                      
          delete b-model-turno-ctrab.
          
      end /* for block2 */.
   
   
      find first b-model-turno-ctrab exclusive-lock
           where /*b-model-turno-ctrab.cod-model-turno = b-area.cod-model-turno
             and */ b-model-turno-ctrab.cod-ctrab       = b-area.cod-area-produc
             and b-model-turno-ctrab.dat-inic-valid  > model-turno-ctrab.dat-inic-valid
             and b-model-turno-ctrab.dat-fim-valid   > model-turno-ctrab.dat-fim-valid
             and b-model-turno-ctrab.dat-inic-valid  < model-turno-ctrab.dat-fim-valid no-error.
      if  available b-model-turno-ctrab
      then                      
         assign 
               b-model-turno-ctrab.dat-inic-valid = model-turno-ctrab.dat-fim-valid.
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
    DEF BUFFER bf-model-turno-ctrab FOR model-turno-ctrab.

    def var c-label as char no-undo.

    find FIRST area-produc where
         rowid(area-produc) = gr-area-produc no-lock no-error.

    if NOT avail area-produc then do :
        {include/i-vldprg.i} 
        {utp/ut-field.i mgind area-produc cod-area 1} 
        run utp/ut-msgs.p (input "show":U, 
                           input 56, 
                           input return-value).

        apply 'entry':U to model-turno-ctrab.cod-model-turno in frame {&frame-name}.
        return 'ADM-ERROR':U.
    END.
    /*Validacao retirada pois apenas a validacao das sobreposicoes eh suficiente.*/
    find FIRST b-model-turno-ctrab where 
               b-model-turno-ctrab.cod-ctrab      = area-produc.cod-area and 
               b-model-turno-ctrab.dat-inic-valid = input frame {&frame-name} model-turno-ctrab.dat-inic-valid  
               no-lock no-error.
    if  avail b-model-turno-ctrab AND adm-new-record then do:
       {include/i-vldprg.i} 
       {utp/ut-table.i mgind model-turno-ctrab 1} 
       run utp/ut-msgs.p (input "show":U, 
                          input 7, 
                          input return-value).
       apply 'entry':U to model-turno-ctrab.cod-model-turno in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end.
    
    /* Modelo de Turno Inexistente */
    find FIRST model-turno-semana 
         where model-turno-semana.cod-model-turno = input frame {&frame-name} model-turno-ctrab.cod-model-turno
         no-lock no-error.    
    if  not avail model-turno-semana then do:                    
        {include/i-vldprg.i} 
        {utp/ut-field.i mgind model-turno-ctrab cod-model-turno 1} 
        run utp/ut-msgs.p (input "show":U, 
                           input 56, 
                           input return-value).
        apply 'entry':U to model-turno-ctrab.dat-inic-valid in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    IF input frame {&frame-name} model-turno-ctrab.dat-inic-valid = ? OR
       input frame {&frame-name} model-turno-ctrab.dat-inic-valid = "":U THEN DO:
        {include/i-vldprg.i} 
        {utp/ut-liter.i In°cio_Validade *}
        run utp/ut-msgs.p (input "show":U, 
                           input 31044, 
                           input return-value).
        apply 'entry':U to model-turno-ctrab.dat-inic-valid in frame {&frame-name}.
        return 'ADM-ERROR':U.
    END.

    IF input frame {&frame-name} model-turno-ctrab.dat-fim-valid = ? OR
       input frame {&frame-name} model-turno-ctrab.dat-fim-valid = "":U THEN DO:
        {include/i-vldprg.i} 
        {utp/ut-liter.i Fim_Validade *}
        run utp/ut-msgs.p (input "show":U, 
                           input 31044, 
                           input return-value).
        apply 'entry':U to model-turno-ctrab.dat-fim-valid in frame {&frame-name}.
        return 'ADM-ERROR':U.
    END.

/*     /*Valida a sobreposiá∆o de turnos. Somente pode haver um turno valido para a †rea.*/                                                    */
/*     IF CAN-FIND(FIRST bf-model-turno-ctrab                                                                                                  */
/*                 WHERE bf-model-turno-ctrab.cod-ctrab = area-produc.cod-area                                                                 */
/*                   AND rowid(bf-model-turno-ctrab) <> r-registro-atual                                                                       */
/*                   AND (bf-model-turno-ctrab.dat-inic-valid >= input frame {&frame-name} model-turno-ctrab.dat-inic-valid AND                */
/*                        bf-model-turno-ctrab.dat-inic-valid <  input frame {&frame-name} model-turno-ctrab.dat-fim-valid)                    */
/*                    OR (bf-model-turno-ctrab.dat-fim-valid  >  input frame {&frame-name} model-turno-ctrab.dat-inic-valid AND                */
/*                        bf-model-turno-ctrab.dat-fim-valid  <=  input frame {&frame-name} model-turno-ctrab.dat-fim-valid)                   */
/*                    OR (bf-model-turno-ctrab.dat-inic-valid <= input frame {&frame-name} model-turno-ctrab.dat-inic-valid AND                */
/*                        bf-model-turno-ctrab.dat-fim-valid  >=  input frame {&frame-name} model-turno-ctrab.dat-fim-valid) NO-LOCK) THEN DO: */
/*                                                                                                                                             */
/*         run utp/ut-msgs.p (input "show":U,                                                                                                  */
/*                            input 32231,                                                                                                     */
/*                            input "":U).                                                                                                     */
/*         apply 'entry':U to model-turno-ctrab.dat-inic-valid in frame {&frame-name}.                                                         */
/*         return 'ADM-ERROR':U.                                                                                                               */
/*     END.                                                                                                                                    */
/*                                                                                                                                             */
    /*Validacoes comentadas, pois a validacao das sobreposiá‰es Ç suficiente.*/
    find first model-turno-ctrab where
               model-turno-ctrab.cod-ctrab       = area-produc.cod-area AND
               model-turno-ctrab.cod-model-turno = input frame {&frame-name} model-turno-ctrab.cod-model-turno and
               model-turno-ctrab.dat-inic-valid  = input frame {&frame-name} model-turno-ctrab.dat-inic-valid
               no-lock no-error.
    if  avail model-turno-ctrab and adm-new-record then do:
        {include/i-vldprg.i}

        {utp/ut-field.i mgind model-turno-ctrab dat-inic-valid 1}
        c-label = return-value.

        {utp/ut-liter.i informada * R}
        c-label = c-label + ' ':U + return-value.

        {utp/ut-table.i mgind model-turno-ctrab 1}
        run utp/ut-msgs.p (input "show":U,
                           input 428,
                           input return-value + "~~" + c-label).
        apply 'entry':U to model-turno-ctrab.dat-inic-valid in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    /* Verifica data de °nicio */

/*     find first b-model-turno-ctrab                                                                                */
/*         where b-model-turno-ctrab.cod-ctrab       = area-produc.cod-area                                          */
/*           and b-model-turno-ctrab.cod-model-turno = input frame {&frame-name}  model-turno-ctrab.cod-model-turno  */
/*           and b-model-turno-ctrab.dat-inic-valid  >= input frame {&frame-name} model-turno-ctrab.dat-inic-valid   */
/*           and b-model-turno-ctrab.dat-fim-valid   <  input frame {&frame-name} model-turno-ctrab.dat-fim-valid    */
/*         no-lock no-error.                                                                                         */
/*                                                                                                                   */
/*     if  avail b-model-turno-ctrab                                                                                 */
/*     and adm-new-record = yes then do:                                                                             */
/*         {include/i-vldprg.i}                                                                                      */
/*                                                                                                                   */
/*         {utp/ut-field.i mgind model-turno-ctrab dat-inic-valid 1}                                                 */
/*         c-label = return-value.                                                                                   */
/*                                                                                                                   */
/*         {utp/ut-liter.i informada * R}                                                                            */
/*         c-label = c-label + ' ':U + return-value.                                                                 */
/*                                                                                                                   */
/*         {utp/ut-table.i mgind model-turno-ctrab 1}                                                                */
/*         run utp/ut-msgs.p (input "show":U,                                                                        */
/*                            input 428,                                                                             */
/*                            input return-value + "~~" + c-label).                                                  */
/*         apply 'entry':U to model-turno-ctrab.dat-inic-valid in frame {&frame-name}.                               */
/*         return 'ADM-ERROR':U.                                                                                     */
/*     end.                                                                                                          */


    /* Verifica data de tÇrmino */

    find first b-model-turno-ctrab
        where b-model-turno-ctrab.cod-ctrab       = area-produc.cod-area
          and b-model-turno-ctrab.cod-model-turno = input frame {&frame-name}  model-turno-ctrab.cod-model-turno
          and b-model-turno-ctrab.dat-inic-valid  < input frame {&frame-name}  model-turno-ctrab.dat-inic-valid
          and b-model-turno-ctrab.dat-fim-valid   >= input frame {&frame-name} model-turno-ctrab.dat-fim-valid
          and rowid(b-model-turno-ctrab)         <> r-registro-atual
        no-lock no-error.
    if  avail b-model-turno-ctrab then do:
        {utp/ut-field.i mgind model-turno-ctrab dat-fim-valid 1}
        c-label = return-value.

        {utp/ut-liter.i informada * R}
        c-label = c-label + ' ':U + return-value.

        {utp/ut-table.i mgind model-turno-ctrab 1}

        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U,
                           input 428,
                           input return-value + "~~" + c-label).
        apply 'entry':U to model-turno-ctrab.dat-fim-valid in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
   
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
  {src/adm/template/snd-list.i "model-turno-ctrab"}

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

