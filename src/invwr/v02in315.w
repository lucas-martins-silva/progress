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
{include/i-prgvrs.i V02IN315 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN315 MUT}
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
def new global shared var v-row-parent as rowid no-undo.                                

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-pl-mest-tipo for pl-mest-tipo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES pl-mest-tipo
&Scoped-define FIRST-EXTERNAL-TABLE pl-mest-tipo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pl-mest-tipo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS pl-mest-tipo.dt-tipo-ini ~
pl-mest-tipo.dt-tipo-fim pl-mest-tipo.num-periodos 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}dt-tipo-ini ~{&FP2}dt-tipo-ini ~{&FP3}~
 ~{&FP1}dt-tipo-fim ~{&FP2}dt-tipo-fim ~{&FP3}~
 ~{&FP1}num-periodos ~{&FP2}num-periodos ~{&FP3}
&Scoped-define ENABLED-TABLES pl-mest-tipo
&Scoped-define FIRST-ENABLED-TABLE pl-mest-tipo
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold rt-mold-2 rt-mold-3 
&Scoped-Define DISPLAYED-FIELDS pl-mest-tipo.num-dias ~
pl-mest-tipo.log-dias-uteis pl-mest-tipo.dt-tipo-ini ~
pl-mest-tipo.dt-tipo-fim pl-mest-tipo.num-periodos 
&Scoped-Define DISPLAYED-OBJECTS i-cd-plano c-descricao cb-ind-tipo-per 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cb-ind-tipo-per 
&Scoped-define ADM-ASSIGN-FIELDS cb-ind-tipo-per pl-mest-tipo.num-dias ~
pl-mest-tipo.log-dias-uteis 
&Scoped-define ADM-MODIFY-FIELDS cb-ind-tipo-per 

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
DEFINE VARIABLE cb-ind-tipo-per AS CHARACTER FORMAT "X(30)":U 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 31.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-plano AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Plano":R7 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.72 BY 1.42.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.72 BY 2.25.

DEFINE RECTANGLE rt-mold-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44.14 BY 2.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-cd-plano AT ROW 1.17 COL 15 COLON-ALIGNED HELP
          "C¢digo do plano mestre de produá∆o"
     c-descricao AT ROW 1.17 COL 20 COLON-ALIGNED NO-LABEL
     cb-ind-tipo-per AT ROW 2.67 COL 15 COLON-ALIGNED
     pl-mest-tipo.num-dias AT ROW 2.75 COL 46 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     pl-mest-tipo.log-dias-uteis AT ROW 2.75 COL 55
          VIEW-AS TOGGLE-BOX
          SIZE 32.43 BY .83
     pl-mest-tipo.dt-tipo-ini AT ROW 4.33 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     pl-mest-tipo.dt-tipo-fim AT ROW 5.33 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     pl-mest-tipo.num-periodos AT ROW 4.79 COL 71 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
     rt-mold-2 AT ROW 4.17 COL 1
     rt-mold-3 AT ROW 4.17 COL 45.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.pl-mest-tipo
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
         HEIGHT             = 5.42
         WIDTH              = 88.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-ind-tipo-per IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-cd-plano IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX pl-mest-tipo.log-dias-uteis IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN pl-mest-tipo.num-dias IN FRAME f-main
   NO-ENABLE 2                                                          */
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

&Scoped-define SELF-NAME cb-ind-tipo-per
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ind-tipo-per V-table-Win
ON VALUE-CHANGED OF cb-ind-tipo-per IN FRAME f-main /* Tipo */
DO:
  def var i-ind-tipo-per as integer no-undo.

  do with frame {&frame-name}:
     assign i-ind-tipo-per = {ininc/i01in315.i 06 cb-ind-tipo-per:screen-value}
            pl-mest-tipo.log-dias-uteis:sensitive = (i-ind-tipo-per = 5)
            pl-mest-tipo.num-dias:sensitive       = (i-ind-tipo-per = 5).

     if i-ind-tipo-per < 5 then
        assign pl-mest-tipo.log-dias-uteis:checked = no.

     if i-ind-tipo-per <> 5 and i-ind-tipo-per <> 6  then   
        assign pl-mest-tipo.num-dias:screen-value = entry(i-ind-tipo-per,'30,15,7,1,1,').

     if i-ind-tipo-per = 6 then do:
        find first param-cp no-lock no-error.
        if avail param-cp then do: 
           find tipo-per where tipo-per.cd-tipo = param-cp.cd-tipo no-lock no-error.
           if avail tipo-per then do:
              assign pl-mest-tipo.num-dias:screen-value = string(tipo-per.nr-dia).  
              find first periodo 
                   where periodo.dt-termino >= input pl-mest-tipo.dt-tipo-fim
                     and periodo.cd-tipo     = param-cp.cd-tipo
                   no-lock no-error.
              if not avail periodo then 
                 find last periodo 
                     where periodo.dt-termino <= input pl-mest-tipo.dt-tipo-fim
                       and periodo.cd-tipo     = param-cp.cd-tipo
                     no-lock no-error.
              if avail periodo then
                 assign pl-mest-tipo.dt-tipo-fim:screen-value = string (periodo.dt-termino)
                        pl-mest-tipo.num-periodos:screen-value = string ((date(pl-mest-tipo.dt-tipo-fim:screen-value) - 
                                                                         date(pl-mest-tipo.dt-tipo-ini:screen-value)) /
                                                                         tipo-per.nr-dia + 1).


           end.
        end.
        else do: 
           run utp/ut-msgs.p (input "show",
                              input 200,  
                              input return-value).
        end.
     end.
  end.
  if input frame {&frame-name} pl-mest-tipo.dt-tipo-ini <> ? then do:
     if input frame {&frame-name} pl-mest-tipo.num-periodos > 0 then
        run pi-leave-num-periodos.  
     else
        if input frame {&frame-name} pl-mest-tipo.dt-tipo-fim <> ? then
           run pi-leave-data-fim.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pl-mest-tipo.dt-tipo-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-mest-tipo.dt-tipo-fim V-table-Win
ON LEAVE OF pl-mest-tipo.dt-tipo-fim IN FRAME f-main /* Data Final Per°odo */
DO:
  run pi-leave-data-fim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pl-mest-tipo.dt-tipo-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-mest-tipo.dt-tipo-ini V-table-Win
ON LEAVE OF pl-mest-tipo.dt-tipo-ini IN FRAME f-main /* Data In°cio Per°odo */
DO:
  run pi-leave-num-periodos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pl-mest-tipo.log-dias-uteis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-mest-tipo.log-dias-uteis V-table-Win
ON VALUE-CHANGED OF pl-mest-tipo.log-dias-uteis IN FRAME f-main /* Considera somente dias £teis */
DO:
  run pi-leave-num-periodos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pl-mest-tipo.num-dias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-mest-tipo.num-dias V-table-Win
ON LEAVE OF pl-mest-tipo.num-dias IN FRAME f-main /* N£mero Dias */
DO:
  run pi-leave-num-periodos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pl-mest-tipo.num-periodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-mest-tipo.num-periodos V-table-Win
ON LEAVE OF pl-mest-tipo.num-periodos IN FRAME f-main /* Per°odos Gerados */
DO:
  run pi-leave-num-periodos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-field.i mgind pl-mest-tipo cd-plano 2}
assign i-cd-plano:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind pl-mest-tipo ind-tipo-per 2}
assign cb-ind-tipo-per:label in frame {&frame-name} = return-value.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
   RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF         

/************************ INTERNAL PROCEDURES ********************/

{cdp/cd9989.i} /*** Procedures PI-RETORNA-DIAS-UTEIS
                               PI-RETORNA-DATA-INICIAL
                               PI-RETORNA-DATA-FINAL   ***/

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
  {src/adm/template/row-list.i "pl-mest-tipo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "pl-mest-tipo"}

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
  find last b-pl-mest-tipo 
       where b-pl-mest-tipo.cd-plano = pl-mest.cd-plano 
       no-lock no-error.

  do with frame {&frame-name}:
     if avail b-pl-mest-tipo then
        display (b-pl-mest-tipo.dt-tipo-fim + 1) @ pl-mest-tipo.dt-tipo-ini.
     else display (today + 1) @ pl-mest-tipo.dt-tipo-ini.

     assign cb-ind-tipo-per:screen-value       = {ininc/i01in315.i 04 1}
            pl-mest-tipo.num-dias:screen-value = '30'.

     display i-cd-plano c-descricao.
     run pi-leave-num-periodos.
  end.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  def var i-ind-tipo-per like pl-mest-tipo.ind-tipo-per no-undo.
  def var c-label        as   char                      no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */
  if not frame {&frame-name}:validate() then
     return 'ADM-ERROR':U.

  if input frame {&frame-name} pl-mest-tipo.dt-tipo-ini  = "" then do:
     {utp/ut-field.i mgind pl-mest-tipo dt-tipo-ini 1}
     run utp/ut-msgs.p (input 'show',
                        input 158,
                        input return-value).
     apply 'entry' to pl-mest-tipo.dt-tipo-ini in frame {&frame-name}.
     return 'adm-error':U.
  end.

  if input frame {&frame-name} pl-mest-tipo.dt-tipo-fim = "" then do:
     {utp/ut-field.i mgind pl-mest-tipo dt-tipo-fim 1}
     run utp/ut-msgs.p (input 'show',
                        input 158,
                        input return-value).
     apply 'entry' to pl-mest-tipo.dt-tipo-fim in frame {&frame-name}.
     return 'adm-error':U.
  end.

  if input frame {&frame-name} pl-mest-tipo.num-periodos = 0 then do:
     {utp/ut-field.i mgind pl-mest-tipo num-periodos 1}
     run utp/ut-msgs.p (input 'show',
                        input 158,
                        input return-value).
     apply 'entry' to pl-mest-tipo.num-periodos in frame {&frame-name}.
     return 'adm-error':U.
  end.

  assign i-ind-tipo-per = {ininc/i01in315.i 06 cb-ind-tipo-per:screen-value}.  
  /*** Se per°odo informado ent∆o n£mero de dias dever† ser v†lido. ***/
  if i-ind-tipo-per = 5 
  and input frame {&frame-name} pl-mest-tipo.num-dias = 0 then do:
     {utp/ut-field.i mgind pl-mest-tipo num-dias 1}
     run utp/ut-msgs.p (input 'show',
                        input 158,
                        input return-value).
     apply 'entry' to pl-mest-tipo.num-dias in frame {&frame-name}.
     return 'adm-error':U.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  do with frame {&frame-name}:
    assign pl-mest-tipo.ind-tipo-per = {ininc/i01in315.i 06 cb-ind-tipo-per:screen-value}.

    assign input frame {&frame-name} pl-mest-tipo.num-dias
                                     pl-mest-tipo.log-dias-uteis. 
  end.

  do on error undo, leave: 
       validate pl-mest-tipo.
  end.

  if return-value <> 'ok' and return-value <> '' then do:
     run pi-mostra-erros.
     return 'adm-error':U.
  end.


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

  find pl-mest where rowid(pl-mest)  = v-row-parent no-lock.
  if avail pl-mest then
     assign pl-mest-tipo.cd-plano = pl-mest.cd-plano.

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

  if avail pl-mest-tipo then do with frame {&frame-name}:
     assign cb-ind-tipo-per:screen-value =  {ininc/i01in315.i 04 pl-mest-tipo.ind-tipo-per}.
  end.

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

  if adm-new-record = no then do with frame {&frame-name}:
/*     assign pl-mest-tipo.num-dias:sensitive       = (pl-mest-tipo.ind-tipo-per = 5)
            pl-mest-tipo.log-dias-uteis:sensitive = (pl-mest-tipo.ind-tipo-per = 5). */
     assign cb-ind-tipo-per:sensitive             = no
            pl-mest-tipo.dt-tipo-ini:sensitive    = no
            pl-mest-tipo.num-dias:sensitive       = no
            pl-mest-tipo.log-dias-uteis:sensitive = no.
  end.

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

  do with frame {&frame-name}:
     assign cb-ind-tipo-per:list-items =  {ininc/i01in315.i 03}. 
  end. 

  find pl-mest where rowid(pl-mest) = v-row-parent no-lock no-error.
  if avail pl-mest then
     assign i-cd-plano  = pl-mest.cd-plano 
            c-descricao = pl-mest.descricao.

  find first param-pm no-lock no-error.
  if not avail param-pm then do:
     {utp/ut-table.i mgind param-pm 1}
     run utp/ut-msgs.p (input "show",
                        input 56,
                        input return-value).
     return.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-focus V-table-Win 
PROCEDURE pi-focus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 apply "entry" to cb-ind-tipo-per in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-data-fim V-table-Win 
PROCEDURE pi-leave-data-fim :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def var i-ind-tipo-per like pl-mest-tipo.ind-tipo-per no-undo.
  def var i-num-dias     like pl-mest-tipo.num-dias     no-undo.
  def var i-num-per      like pl-mest-tipo.num-periodos no-undo.
  def var da-data        as   date format "99/99/9999"  no-undo.
  def var i-num-max-per  as   integer                   no-undo.
  def buffer b-pl-mest-tipo   for pl-mest-tipo.

  if  input frame {&frame-name} pl-mest-tipo.dt-tipo-ini <> ""
  and input frame {&frame-name} pl-mest-tipo.dt-tipo-fim <> "" then
  do with frame {&frame-name}:
     if adm-new-record then
        find last b-pl-mest-tipo
             where b-pl-mest-tipo.cd-plano = i-cd-plano no-lock no-error.
     else
         find last b-pl-mest-tipo 
             where b-pl-mest-tipo.cd-plano = i-cd-plano
               and b-pl-mest-tipo.num-seq-tipo < pl-mest-tipo.num-seq-tipo no-lock no-error.
     if avail b-pl-mest-tipo then
        assign i-num-max-per = param-pm.num-max-periodos - b-pl-mest-tipo.num-per-fim.
     else
         assign i-num-max-per = param-pm.num-max-periodos.              
     assign i-ind-tipo-per = {ininc/i01in315.i 06 cb-ind-tipo-per:screen-value}.

     case i-ind-tipo-per:
        when 1 or 
        when 2 then do with frame {&frame-name}: /*** mensal ***/
           run pi-periodo-mensal-quinzenal (input date(pl-mest-tipo.dt-tipo-ini:screen-value),
                                            input date(pl-mest-tipo.dt-tipo-fim:screen-value),
                                            input 0,
                                            input (i-ind-tipo-per = 2)).
        end.   
        when 3 then do with frame {&frame-name}:
           assign da-data   = date(pl-mest-tipo.dt-tipo-ini:screen-value)
                  i-num-per = 0.
           repeat while da-data < date(pl-mest-tipo.dt-tipo-fim:screen-value):
              assign da-data   = da-data  + 7
                     i-num-per = i-num-per + 1.
           end.
           assign pl-mest-tipo.dt-tipo-fim:screen-value = string(da-data - 1).
        end.
        when 4 then /*** se tipo de periodo Ç di†rio ***/
               assign i-num-per = date(pl-mest-tipo.dt-tipo-fim:screen-value) - 
                                  date(pl-mest-tipo.dt-tipo-ini:screen-value) + 1.

        when 5 then do with frame {&frame-name}: /*** se tipo de per°odo Ç informado ***/
           if pl-mest-tipo.log-dias-uteis:checked in frame {&frame-name} = yes then do:
              assign da-data = input frame {&frame-name} pl-mest-tipo.dt-tipo-fim.
              repeat:
                 run pi-retorna-dias-uteis (input param-pm.cd-calen,
                                            input date(pl-mest-tipo.dt-tipo-ini:screen-value),
                                            input da-data,
                                            output i-num-dias).
                 if i-num-dias > 0 then leave.
                 assign da-data = da-data + 1.
              end.
              assign pl-mest-tipo.dt-tipo-fim:screen-value = string(da-data).
           end.
           else do:
              assign i-num-dias = 
                  (integer(date(pl-mest-tipo.dt-tipo-fim:screen-value) - 
                   date(pl-mest-tipo.dt-tipo-ini:screen-value)) + 1).
           end.

           assign i-num-per = (i-num-dias / integer(pl-mest-tipo.num-dias:screen-value)).
        end.
        when 6 then do:
             find first param-cp no-lock no-error.
             find first periodo 
                  where periodo.dt-termino >= input pl-mest-tipo.dt-tipo-fim
                    and periodo.cd-tipo     = param-cp.cd-tipo
                  no-lock no-error.
             if not avail periodo then 
                find last periodo 
                     where periodo.dt-termino <= input pl-mest-tipo.dt-tipo-fim
                       and periodo.cd-tipo     = param-cp.cd-tipo
                     no-lock no-error.
             if avail periodo then
                assign pl-mest-tipo.dt-tipo-fim:screen-value = string (periodo.dt-termino)
                       i-num-per = (periodo.dt-termino - input pl-mest-tipo.dt-tipo-ini) / 
                                    input pl-mest-tipo.num-dias + 1.
        end.               
     end case.
     if i-ind-tipo-per > 2 then
        if i-num-per > i-num-max-per then do:
           assign pl-mest-tipo.num-periodos:screen-value = string (i-num-max-per).
           run pi-leave-num-periodos.
        end.
        else 
             assign pl-mest-tipo.num-periodos:screen-value = string (i-num-per).
     else
         run pi-leave-num-periodos.
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-num-periodos V-table-Win 
PROCEDURE pi-leave-num-periodos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def var i-ind-tipo-per    like pl-mest-tipo.ind-tipo-per no-undo.
  def var da-data           like pl-mest-tipo.dt-tipo-fim  no-undo.
  def var i-num-dias        like pl-mest-tipo.num-dias     no-undo.
  def buffer b-pl-mest-tipo for pl-mest-tipo.

  if  input frame {&frame-name} pl-mest-tipo.dt-tipo-ini <> ? 
  and input frame {&frame-name} pl-mest-tipo.num-periodos > 0 then 
  do with frame {&frame-name}:
     if adm-new-record then
        find last b-pl-mest-tipo
             where b-pl-mest-tipo.cd-plano = i-cd-plano no-lock no-error.
     else
         find last b-pl-mest-tipo 
             where b-pl-mest-tipo.cd-plano = i-cd-plano
               and b-pl-mest-tipo.num-seq-tipo < pl-mest-tipo.num-seq-tipo no-lock no-error.
     if avail b-pl-mest-tipo then
        if input pl-mest-tipo.num-periodos > 
           param-pm.num-max-periodos - b-pl-mest-tipo.num-per-fim then
           assign pl-mest-tipo.num-periodos:screen-value = string (param-pm.num-max-periodos -
                                                             b-pl-mest-tipo.num-per-fim).
     else
         if input pl-mest-tipo.num-periodos > param-pm.num-max-periodos then
           assign pl-mest-tipo.num-periodos:screen-value = string (param-pm.num-max-periodos).                                            

     assign i-ind-tipo-per = {ininc/i01in315.i 06 cb-ind-tipo-per:screen-value}
            i-num-dias     = integer(pl-mest-tipo.num-periodos:screen-value) *
                             integer(pl-mest-tipo.num-dias:screen-value).

     if i-num-dias = 0 then leave.

     case i-ind-tipo-per:
        when 1 or 
        when 2 then do with frame {&frame-name}: /*** mensal ***/
           run pi-periodo-mensal-quinzenal (input date(pl-mest-tipo.dt-tipo-ini:screen-value),
                                            input ?,
                                            input integer(pl-mest-tipo.num-periodos:screen-value),
                                            input (i-ind-tipo-per = 2)).
        end.   

        when 3 then do with frame {&frame-name}:
           assign da-data = date(pl-mest-tipo.dt-tipo-ini:screen-value) + 
                            (integer(pl-mest-tipo.num-periodos:screen-value) * 7).

           assign pl-mest-tipo.dt-tipo-fim:screen-value = string(da-data - 1).
        end.

        when 4 then do: /*** se tipo de periodo Ç di†rio ***/
           assign da-data = date(pl-mest-tipo.dt-tipo-ini:screen-value) + i-num-dias - 1
                  pl-mest-tipo.dt-tipo-fim:screen-value = string(da-data).
        end.    

        when 5 or when 6 then do: /*** se tipo de per°odo Ç informado ***/
           if pl-mest-tipo.log-dias-uteis:checked in frame {&frame-name} = yes then do:
              run pi-retorna-data-final (input  param-pm.cd-calen,
                                         input  date(pl-mest-tipo.dt-tipo-ini:screen-value),
                                         input  (i-num-dias - 1),
                                         output da-data).
           end.
           else 
              assign da-data = date(pl-mest-tipo.dt-tipo-ini:screen-value) + i-num-dias - 1.

              assign pl-mest-tipo.dt-tipo-fim:screen-value = string(da-data).
        end.

   end case.
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-erros V-table-Win 
PROCEDURE pi-mostra-erros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   {cdp/cd1120.i} /*** Apresenta os erros retornados pelo trigger de write ***/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-periodo-mensal-quinzenal V-table-Win 
PROCEDURE pi-periodo-mensal-quinzenal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input parameter lda-data-ini as date format "99/99/9999" no-undo.
   def input parameter lda-data-fim as date format "99/99/9999" no-undo.
   def input parameter li-periodos  as integer                  no-undo.
   def input parameter ll-quinzenal as logical                  no-undo.

   def var lda-data     as date format "99/99/9999" no-undo.
   def var lda-data-aux as date format "99/99/9999" no-undo.
   def var lda-media    as date format "99/99/9999" no-undo.
   def var li-cont-per  as integer                  no-undo.

   assign lda-data     = lda-data-ini
          lda-data-aux = lda-data-fim.

   repeat:
      if (lda-data-aux <> ? and lda-data    >= lda-data-aux)
      or (li-periodos   > 0  and li-cont-per >= li-periodos) then leave.

      assign lda-data-ini  = lda-data
             lda-data-fim  = lda-data   + 30.

      if  month(lda-data-ini) <> month(lda-data-fim) 
      and (day(lda-data-fim) >= day(lda-data-ini) 
      or  (month(lda-data-fim) - month(lda-data-ini)) > 1) then do:

         blk-repeat:
         repeat:
            assign lda-data-fim = lda-data-fim - 1.
            if  (day(lda-data-fim) < day(lda-data-ini) 
                 and (month(lda-data-fim) - month(lda-data-ini)) = 1) 
            or month(lda-data-ini) = month(lda-data-fim) then leave blk-repeat.
         end.
      end.

      if ll-quinzenal then do:
         assign lda-media   = lda-data-ini + (integer((lda-data-fim - lda-data-ini) / 2) - 1)
                li-cont-per = li-cont-per + 1.

         if (lda-data-aux <> ? and lda-media >= lda-data-aux)
         or (li-periodos > 0 and li-cont-per >= li-periodos) then do:
            assign lda-data-fim = lda-media.
            leave.
         end.
      end. 

      assign lda-data    = lda-data-fim + 1
             li-cont-per = li-cont-per  + 1.
   end.
   do with frame {&frame-name}:

      assign pl-mest-tipo.dt-tipo-fim:screen-value = string(lda-data-fim)
             pl-mest-tipo.num-periodos:screen-value = string(li-cont-per).
   end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "pl-mest-tipo"}

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


