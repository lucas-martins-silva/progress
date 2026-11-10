&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mgmnt            PROGRESS
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
{include/i-prgvrs.i V01IN206 2.00.00.018}  /*** "010018" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN206 MUT}
&ENDIF



/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var v-row-parent   as rowid  no-undo.                                
def new global shared var gr-manut       as rowid  no-undo.
def new global shared var gr-grup-manut  as rowid  no-undo.
def new global shared var gc-estado      as char  no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-manut for manut.
def temp-table tt-manut no-undo like manut.  

DEF BUFFER b-msg-manut FOR msg-manut.
DEF TEMP-TABLE tt-msg-manut NO-UNDO LIKE msg-manut.

  def var c-query-hdl    as char    no-undo.
  def var h-query-hdl    as handle  no-undo.
  def var i-cont         as integer no-undo.
  def var c-viewer-hdl   as char    no-undo.
  def var h-viewer-hdl   as handle  no-undo.

def new global shared var gc-cd-manut like manut.cd-manut no-undo.

def var gr-manut-aux like manut.grp-manut no-undo.
def var l-copia as logical init no no-undo.

def var c-grup-manut as char no-undo.
def var l-zoom       as logical.

def var c-reg-alter as char no-undo.
def var c-narr-alter as char no-undo.
def var rs-op-exporta as integer no-undo.
def var l-exp as log no-undo.
def var l-confirma as log initial yes no-undo.
def var h-container as handle no-undo.
def var l-primeira-vez as log initial yes no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES manut
&Scoped-define FIRST-EXTERNAL-TABLE manut


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR manut.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS manut.grp-manut 
&Scoped-define ENABLED-TABLES manut
&Scoped-define FIRST-ENABLED-TABLE manut
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold c-descricao 
&Scoped-Define DISPLAYED-FIELDS manut.cd-manut manut.grp-manut 
&Scoped-define DISPLAYED-TABLES manut
&Scoped-define FIRST-DISPLAYED-TABLE manut
&Scoped-Define DISPLAYED-OBJECTS c-descricao c-descricao-grup 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS manut.cd-manut 

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
DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(50)" 
     VIEW-AS FILL-IN 
     SIZE 47.57 BY .88.

DEFINE VARIABLE c-descricao-grup AS CHARACTER FORMAT "X(50)" 
     VIEW-AS FILL-IN 
     SIZE 47.57 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     manut.cd-manut AT ROW 1.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .88
     c-descricao AT ROW 1.17 COL 35 COLON-ALIGNED NO-LABEL
     manut.grp-manut AT ROW 2.46 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .88
     c-descricao-grup AT ROW 2.46 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.29 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.manut
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
         HEIGHT             = 2.54
         WIDTH              = 88.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao-grup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN manut.cd-manut IN FRAME f-main
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

&Scoped-define SELF-NAME manut.cd-manut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-manut V-table-Win
ON F5 OF manut.cd-manut IN FRAME f-main /* Manuten‡Æo */
DO:
   assign l-implanta = no.
   {include/zoom.i &prog-zoom="inzoom/z01in205.w"
                   &tabela=manut }   
   /* nao deve receber qualquer codigo existente > INCLUSAO */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-manut V-table-Win
ON LEAVE OF manut.cd-manut IN FRAME f-main /* Manuten‡Æo */
DO:
    ASSIGN gc-cd-manut = INPUT FRAME {&FRAME-NAME} manut.cd-manut.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.cd-manut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF manut.cd-manut IN FRAME f-main /* Manuten‡Æo */
DO:
  apply 'F5' to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME manut.grp-manut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.grp-manut V-table-Win
ON ENTRY OF manut.grp-manut IN FRAME f-main /* Grupo Manuten‡Æo */
DO:
  if not l-zoom then
     assign c-grup-manut = manut.grp-manut:screen-value in frame {&frame-name}.
  assign l-zoom = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.grp-manut V-table-Win
ON F5 OF manut.grp-manut IN FRAME f-main /* Grupo Manuten‡Æo */
DO:
   assign l-implanta = yes
          l-zoom     = yes.
   {include/zoom.i &prog-zoom="inzoom/z01in143.w"
                   &tabela=manut
                   &atributo=grp-manut}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.grp-manut V-table-Win
ON LEAVE OF manut.grp-manut IN FRAME f-main /* Grupo Manuten‡Æo */
DO:
    FIND FIRST grup-manut WHERE grup-manut.grp-manut = INPUT FRAME {&FRAME-NAME} 
                         manut.grp-manut NO-LOCK NO-ERROR.

    IF AVAIL grup-manut THEN
        ASSIGN c-descricao-grup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = grup-manut.descricao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL manut.grp-manut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF manut.grp-manut IN FRAME f-main /* Grupo Manuten‡Æo */
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

if manut.cd-manut:load-mouse-pointer  ("image/lupa.cur") in frame {&frame-name} then.
if manut.grp-manut:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "manut"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "manut"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  RUN get-attribute ("W-Container-Source").
  assign h-container = widget-handle (return-value).

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}

  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */

  ASSIGN c-descricao = c-descricao:screen-value in frame {&frame-name}.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  IF RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

   ASSIGN manut.descricao = c-descricao.

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

  assign l-copia = yes.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

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

  assign gc-cd-manut = input frame {&frame-name} manut.cd-manut.

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
    /* Code placed here will execute AFTER standard behavior.    */

    IF AVAIL manut THEN DO:

        FIND FIRST grup-manut
            WHERE grup-manut.grp-manut = manut.grp-manut
            NO-LOCK NO-ERROR.

        ASSIGN gr-grup-manut = IF AVAIL grup-manut THEN ROWID(grup-manut) ELSE ?
               c-descricao-grup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL grup-manut THEN grup-manut.descricao ELSE ?
               c-descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = manut.descricao
               c-descricao:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      
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
  run get-attribute ('adm-new-record').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  if avail manut then 
      assign gr-manut-aux = input frame {&frame-name} manut.grp-manut.

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
     if gr-manut <> ? then do:

      find manut where rowid(manut) = gr-manut no-lock  no-error.
      if not avail manut then
         find first manut no-lock  no-error.
      if avail manut then
         assign gr-manut     = rowid(manut)
                v-row-parent = rowid(manut)
                gc-cd-manut  = manut.cd-manut .
      else
         assign gr-manut     = ?
                v-row-parent = ? 
                gc-cd-manut  = ? .
   end.
   else do:
      find first manut no-lock  no-error.
      if avail manut then
         assign gr-manut     = rowid(manut)
                v-row-parent = rowid(manut)
                gc-cd-manut  = manut.cd-manut .
      else
         assign gr-manut     = ?
                v-row-parent = ? 
                gc-cd-manut  = ? .
   end.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  assign gc-cd-manut = input frame {&frame-name} manut.cd-manut  .


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
  if  avail manut then
      assign gr-manut = rowid(manut).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
  /* Ponha aqui a valida‡Æo de chave duplicada */
  if  manut.cd-manut:sensitive in frame {&frame-name} = yes Then do:
      {utp/ut-table.i mgind manut 1}
      if input frame {&frame-name} manut.cd-manut = '' then do:
         {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */ 
         run utp/ut-msgs.p("show", 164, return-value).
         apply 'entry' to manut.cd-manut in frame {&frame-name}.
         return 'ADM-ERROR'.
      end.

      if can-find (b-manut where 
         b-manut.cd-manut =  input frame {&frame-name} manut.cd-manut) then do:
        {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */ 
        run utp/ut-msgs.p("show", 8, return-value).
        apply 'entry' to manut.cd-manut in frame {&frame-name}.
        return 'ADM-ERROR'.
      end.
  end.  


/* Ponha aqui as demais valida‡äes */
  if  input frame {&frame-name} manut.grp-manut = " " 
  or  not can-find (grup-manut where grup-manut.grp-manut = 
                                 input frame {&frame-name} manut.grp-manut)
  then do:
      {utp/ut-table.i mgind grup-manut 1}
      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */       
      run utp/ut-msgs.p( input "show",
                         input 2,
                         input return-value).
      apply 'entry' to manut.grp-manut in frame {&frame-name}.
      return 'ADM-ERROR'.
  end.    

   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "manut"}

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

