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
{include/i-prgvrs.i V39IN122 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V39IN122 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
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
&Scoped-define EXTERNAL-TABLES familia
&Scoped-define FIRST-EXTERNAL-TABLE familia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR familia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS i-prioridade c-liter-vendas c-liter-mps ~
RECT-28 RECT-32 RECT-33 
&Scoped-Define DISPLAYED-OBJECTS cb-cd-origem cb-cd-formula ~
cb-ind-calc-meta i-prioridade cb-tipo-sched c-liter-vendas c-liter-mps ~
c-liter-crp 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cb-cd-origem cb-cd-formula ~
cb-ind-calc-meta i-prioridade cb-tipo-sched 
&Scoped-define ADM-MODIFY-FIELDS cb-cd-origem cb-cd-formula ~
cb-ind-calc-meta i-prioridade cb-tipo-sched 

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
DEFINE VARIABLE cb-cd-formula AS CHARACTER FORMAT "X(50)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 31 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cd-origem AS CHARACTER FORMAT "X(25)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ind-calc-meta AS CHARACTER FORMAT "X(40)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 31.14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-sched AS CHARACTER FORMAT "X(40)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-liter-crp AS CHARACTER FORMAT "X(3)":U 
      VIEW-AS TEXT 
     SIZE 6.57 BY .67 NO-UNDO.

DEFINE VARIABLE c-liter-mps AS CHARACTER FORMAT "X(3)":U 
      VIEW-AS TEXT 
     SIZE 7.43 BY .67 NO-UNDO.

DEFINE VARIABLE c-liter-vendas AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .67 NO-UNDO.

DEFINE VARIABLE i-prioridade AS INTEGER FORMAT "99" INITIAL 0 
     LABEL "Prioridade":R12 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.86 BY 1.5.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.29 BY 2.79.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.43 BY 1.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-cd-origem AT ROW 1.67 COL 33.57 COLON-ALIGNED HELP
          "Origem"
     cb-cd-formula AT ROW 2.75 COL 33.43 COLON-ALIGNED HELP
          "F¢rmula"
     cb-ind-calc-meta AT ROW 4.96 COL 33.57 COLON-ALIGNED HELP
          "Crit‚rio C lculo Meta Produ‡Æo"
     i-prioridade AT ROW 6.83 COL 20.86 COLON-ALIGNED
     cb-tipo-sched AT ROW 6.83 COL 61 COLON-ALIGNED HELP
          "Programa‡Æo"
     c-liter-vendas AT ROW 1 COL 3 COLON-ALIGNED NO-LABEL
     c-liter-mps AT ROW 4.42 COL 2.57 COLON-ALIGNED NO-LABEL
     c-liter-crp AT ROW 6.25 COL 2 COLON-ALIGNED NO-LABEL
     RECT-28 AT ROW 6.58 COL 1.57
     RECT-32 AT ROW 1.25 COL 1.29
     RECT-33 AT ROW 4.63 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.familia
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 7.21
         WIDTH              = 84.86.
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

/* SETTINGS FOR FILL-IN c-liter-crp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-cd-formula IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-cd-origem IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-ind-calc-meta IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-tipo-sched IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN i-prioridade IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/


{utp/ut-liter.i Gera‡Æo_Prev_Vendas * r}
assign c-liter-vendas:screen-value in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i MPS * r}
assign c-liter-mps:screen-value in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i CRP * r}
assign c-liter-crp:screen-value in frame {&frame-name} = trim(return-value).

{utp/ut-field.i mgind familia cd-origem 1}
assign cb-cd-origem:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgind familia cd-formula 1}
assign cb-cd-formula:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgind familia ind-calc-meta 1}
assign cb-ind-calc-meta:label in frame {&frame-name} = return-value.
{utp/ut-field.i mgind item tipo-sched  01}
assign cb-tipo-sched:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "familia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "familia"}

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

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .*/

  do with frame {&frame-name} on error undo, return "adm-error":
      assign {&adm-create-fields} {&adm-assign-fields}.  
      assign familia.ind-calc-meta = {ininc/i19in122.i 06 cb-ind-calc-meta}
             familia.cd-formula    = {ininc/i24in172.i 06 cb-cd-formula}
             familia.cd-origem     = {ininc/i14in122.i 06 cb-cd-origem}
             familia.prioridade    = INPUT frame {&frame-name} i-prioridade.

      if  param-global.modulo-pc then 
          assign familia.tipo-sched = {ininc/i16in122.i 06 cb-tipo-sched}.       

      if error-status:error then do:
          run dispath in this-procedure ('show-errors':U).
      end.
  end.        

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
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .*/

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

   if avail familia then do with frame {&frame-name}:  
     assign cb-ind-calc-meta:screen-value in frame {&frame-name}   = if familia.ind-calc-meta <> 0 then {ininc/i19in122.i 04 familia.ind-calc-meta}
                                                                     else  {ininc/i19in122.i 04 1}
            cb-cd-formula:screen-value in frame {&frame-name}      = if familia.cd-formula <> 0 then {ininc/i24in172.i 04 familia.cd-formula}
                                                                     else {ininc/i24in172.i 04 1}
            cb-cd-origem:screen-value in frame {&frame-name}       = if familia.cd-origem <> 0 then {ininc/i14in122.i 04 familia.cd-origem}
                                                                     else {ininc/i14in122.i 04 1}
            cb-tipo-sched:screen-value in frame {&frame-name}      = if familia.tipo-sched <> 0 then {ininc/i16in122.i 04 familia.tipo-sched}
                                                                     else {ininc/i16in122.i 04 1}
            i-prioridade                                            = familia.prioridade.
            DISP i-prioridade WITH frame {&frame-name}.
   end.         
   else do:
       assign cb-ind-calc-meta:screen-value in frame {&frame-name} = {ininc/i19in122.i 04 1}
              cb-cd-formula:screen-value in frame {&frame-name}    = {ininc/i24in172.i 04 1}
              cb-cd-origem:screen-value in frame {&frame-name}     = {ininc/i14in122.i 04 1}
              cb-tipo-sched:screen-value in frame {&frame-name}    = {ininc/i16in122.i 04 1}
              i-prioridade                                          = 99.
              DISP i-prioridade WITH frame {&frame-name}.
   end.    

  /* Dispatch standard ADM method.                             */
  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
ASSIGN  i-prioridade:SENSITIVE in frame {&frame-name}      = NO.

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
  /*  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */

 
  if adm-new-record = yes then
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  if param-global.modulo-pm = no and
       param-global.modulo-pv = no then do:
       if not can-find(first est-prod use-index onde-se-usa
                   where est-prod.it-codigo = item.it-codigo) then do:
          disable cb-cd-origem with frame {&frame-name}.
       end.
   end.        

   if param-global.modulo-pm = no and
       param-global.modulo-pv = no then do:
       if not can-find(first est-prod use-index onde-se-usa
                   where est-prod.it-codigo = item.it-codigo) then do:
       disable cb-cd-formula with frame {&frame-name}.
       end.
   end. 
  
        
        
   if param-global.modulo-pv = yes then do:
       assign cb-cd-origem:sensitive in frame {&frame-name}  = yes
              cb-cd-formula:sensitive in frame {&frame-name} = yes.
   end.
   else do: 
       assign cb-cd-origem:sensitive in frame {&frame-name}  = no
              cb-cd-formula:sensitive in frame {&frame-name} = no.
   end.          

   if param-global.modulo-pm = yes then do:
       assign cb-ind-calc-meta:sensitive in frame {&frame-name}    = yes.
   end.
   else do: 
       assign cb-ind-calc-meta:sensitive in frame {&frame-name}    = no.
   end.      

   if param-global.modulo-pc then do:
        assign cb-tipo-sched:sensitive in frame {&frame-name}  = yes.
   end.
   else do:
        assign cb-tipo-sched:sensitive in frame {&frame-name}  = no.
   end.
   if param-global.modulo-pc = no then 
      assign cb-tipo-sched:sensitive in frame {&frame-name}      = no.
             
   else
      assign cb-tipo-sched:sensitive in frame {&frame-name}      = yes.
             
ASSIGN  i-prioridade:SENSITIVE in frame {&frame-name}      = YES.

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
           cb-cd-formula:list-items in frame {&frame-name}    = {ininc/i24in172.i 03}
           cb-cd-origem:list-items  in frame {&frame-name}    = {ininc/i14in122.i 03}
           cb-tipo-sched:list-items in frame {&frame-name}    = {ininc/i16in122.i 03}
           i-prioridade:SENSITIVE in frame {&frame-name}      = NO.

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
  {src/adm/template/snd-list.i "familia"}

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

