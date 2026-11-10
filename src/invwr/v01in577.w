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
{include/i-prgvrs.i V01IN577 2.00.00.013 } /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN577 MUT}
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

def buffer b-event-mod-contrat for event-mod-contrat.
def var i-num-seq-event   like event-mod-contrat.num-seq-event.
def var de-total-qtd      like event-mod-contrat.qtd-prevista.
def var de-total-val      like event-mod-contrat.val-previsto.
def var de-variacao-qtd   like event-mod-contrat.qtd-prevista.
def var de-variacao-val   like event-mod-contrat.val-previsto.
def var c-desc-aux        as char.
def var de-perc-tot       as decimal no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES event-mod-contrat
&Scoped-define FIRST-EXTERNAL-TABLE event-mod-contrat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR event-mod-contrat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS event-mod-contrat.prazo-dat-realiz ~
event-mod-contrat.cod-cond-pag event-mod-contrat.dat-event ~
event-mod-contrat.perc-lib-previsto 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}prazo-dat-realiz ~{&FP2}prazo-dat-realiz ~{&FP3}~
 ~{&FP1}cod-cond-pag ~{&FP2}cod-cond-pag ~{&FP3}~
 ~{&FP1}dat-event ~{&FP2}dat-event ~{&FP3}~
 ~{&FP1}perc-lib-previsto ~{&FP2}perc-lib-previsto ~{&FP3}
&Scoped-define ENABLED-TABLES event-mod-contrat
&Scoped-define FIRST-ENABLED-TABLE event-mod-contrat
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold c-descricao cb-dest-event 
&Scoped-Define DISPLAYED-FIELDS event-mod-contrat.nr-contrato ~
event-mod-contrat.it-codigo event-mod-contrat.num-seq-item ~
event-mod-contrat.num-seq-event-mod event-mod-contrat.prazo-dat-realiz ~
event-mod-contrat.cod-cond-pag event-mod-contrat.dat-event ~
event-mod-contrat.qtd-prevista event-mod-contrat.val-previsto ~
event-mod-contrat.perc-lib-previsto 
&Scoped-Define DISPLAYED-OBJECTS c-desc-contrat c-desc-item c-descricao ~
cb-dest-event c-desc-cond 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS event-mod-contrat.num-seq-event-mod 
&Scoped-define ADM-ASSIGN-FIELDS event-mod-contrat.qtd-prevista ~
event-mod-contrat.val-previsto 

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
DEFINE VARIABLE cb-dest-event AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-cond AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-contrat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(50)" 
     LABEL "Descri‡Æo":R11 
     VIEW-AS FILL-IN 
     SIZE 60 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.33.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 8.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     event-mod-contrat.nr-contrato AT ROW 1.17 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-contrat AT ROW 1.17 COL 36.57 COLON-ALIGNED NO-LABEL
     event-mod-contrat.it-codigo AT ROW 2.17 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 2.17 COL 36.57 COLON-ALIGNED NO-LABEL
     event-mod-contrat.num-seq-item AT ROW 3.17 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.14 BY .88
     event-mod-contrat.num-seq-event-mod AT ROW 4.17 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     c-descricao AT ROW 5.88 COL 19.14 COLON-ALIGNED
     event-mod-contrat.prazo-dat-realiz AT ROW 6.88 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     cb-dest-event AT ROW 7.88 COL 19.14 COLON-ALIGNED
     event-mod-contrat.cod-cond-pag AT ROW 8.88 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-cond AT ROW 8.88 COL 24 COLON-ALIGNED NO-LABEL
     event-mod-contrat.dat-event AT ROW 9.88 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     event-mod-contrat.qtd-prevista AT ROW 10.88 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .88
     event-mod-contrat.val-previsto AT ROW 11.88 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     event-mod-contrat.perc-lib-previsto AT ROW 12.88 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 5.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.event-mod-contrat
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
         HEIGHT             = 13
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-desc-cond IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-contrat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN event-mod-contrat.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN event-mod-contrat.nr-contrato IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN event-mod-contrat.num-seq-event-mod IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN event-mod-contrat.num-seq-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN event-mod-contrat.qtd-prevista IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN event-mod-contrat.val-previsto IN FRAME f-main
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

&Scoped-define SELF-NAME event-mod-contrat.cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL event-mod-contrat.cod-cond-pag V-table-Win
ON F5 OF event-mod-contrat.cod-cond-pag IN FRAME f-main /* Cond Pagto */
DO:
   assign l-implanta = yes.
   {include/zoom.i &prog-zoom="adzoom/z01ad039.w"
                   &tabela=event-mod-contrat
                   &atributo=cod-cond-pag}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL event-mod-contrat.cod-cond-pag V-table-Win
ON LEAVE OF event-mod-contrat.cod-cond-pag IN FRAME f-main /* Cond Pagto */
DO:
   {include/leave.i &tabela=cond-pagto
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-cond
                    &where="cond-pagto.cod-cond-pag = input frame {&frame-name} event-mod-contrat.cod-cond-pag"}

  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL event-mod-contrat.cod-cond-pag V-table-Win
ON MOUSE-SELECT-DBLCLICK OF event-mod-contrat.cod-cond-pag IN FRAME f-main /* Cond Pagto */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME event-mod-contrat.perc-lib-previsto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL event-mod-contrat.perc-lib-previsto V-table-Win
ON LEAVE OF event-mod-contrat.perc-lib-previsto IN FRAME f-main /* Perc Previsto */
DO:
  if item-contrat.ind-tipo-control-val = 1 then do:
     if item-contrat.ind-un-contrato <> 1 or de-variacao-qtd > 0 then do:
        if  item-contrat.ind-un-contrato = 2 and item-contrat.qtd-total > 0 then do:
            disp ((input frame {&frame-name} event-mod-contrat.perc-lib-previsto * item-contrat.qtd-total) / 100) @ event-mod-contrat.qtd-prevista with frame {&frame-name}.
        end. 
     end.
  end.

  if item-contrat.ind-tipo-control-val = 3 then do: 
     if  item-contrat.ind-un-contrat = 2 and item-contrat.val-total > 0 then do: 
         disp input frame {&frame-name} event-mod-contrat.perc-lib-previsto * item-contrat.val-total / 100 @ event-mod-contrat.val-previsto with frame {&frame-name}.
     end. 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME event-mod-contrat.val-previsto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL event-mod-contrat.val-previsto V-table-Win
ON LEAVE OF event-mod-contrat.val-previsto IN FRAME f-main /* Valor Previsto */
DO:
  if item-contrat.ind-tipo-control-val = 3 then do: 
     if item-contrat.ind-un-contrato = 1 or item-contrat.val-total <= 0 then do: 
        if item-contrat.val-total > 0 then   
           disp ((input frame {&frame-name} event-mod-contrat.val-previsto * 100) / item-contrat.val-total) 
                @ event-mod-contrat.perc-lib-previsto with frame {&frame-name}.
        else
           disp 100 @ event-mod-contrat.perc-lib-previsto with frame {&frame-name}.
     end.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  if event-mod-contrat.cod-cond-pag:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "event-mod-contrat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "event-mod-contrat"}

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

  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  assign cb-dest-event:screen-value in frame {&frame-name} = {varinc/var00064.i 04 1}.
  
  find item-contrat where rowid(item-contrat) = v-row-parent no-lock no-error.
  if avail item-contrat then do:
     display item-contrat.nr-contrat   @ event-mod-contrat.nr-contrat with frame {&frame-name}.
     display item-contrat.it-codigo    @ event-mod-contrat.it-codigo with frame {&frame-name}.
     display item-contrat.num-seq-item @ event-mod-contrat.num-seq-item with frame {&frame-name}.
         find contrato-for where contrato-for.nr-contrato = item-contrat.nr-contrat no-lock no-error.
     if avail contrato-for then do:
        display contrato-for.des-contrat @ c-desc-contrat with frame {&frame-name}.
     end.
     find item where item.it-codigo = item-contrat.it-codigo no-lock no-error.
     if avail item then do:
        display item.desc-item @ c-desc-item with frame {&frame-name}.  
     end.
  end.  
     
  find last event-mod-contrat where event-mod-contrat.nr-contrat   = input frame {&frame-name} event-mod-contrat.nr-contrat and 
                                    event-mod-contrat.num-seq-item = input frame {&frame-name} event-mod-contrat.num-seq-item NO-LOCK no-error.
  if  available event-mod-contrat then
      assign i-num-seq-event = if  event-mod-contrat.num-seq-event-mod < 999999 then
                                   event-mod-contrat.num-seq-event-mod + 1
                                   else 1.
  else
      i-num-seq-event = 1.
       
  display i-num-seq-event @ event-mod-contrat.num-seq-event-mod with frame {&frame-name}.

  display today @ event-mod-contrat.dat-event with frame {&frame-name}.

  
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
  {include/i-valid.i}
  
  run pi-validate.
  
  if return-value = "adm-error" then return return-value.
  
  assign c-desc-aux = input frame {&frame-name} c-descricao
         cb-dest-event = input frame {&frame-name} cb-dest-event.
   
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  assign event-mod-contrat.des-event = c-desc-aux
         event-mod-contrat.ind-dest-event = {varinc/var00064.i 06 cb-dest-event}.
  
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

  find item-contrat where rowid(item-contrat) = v-row-parent NO-LOCK no-error.
  if avail item-contrat then do:
     assign event-mod-contrat.nr-contrat   = item-contrat.nr-contrat
            event-mod-contrat.it-codigo    = item-contrat.it-codigo
            event-mod-contrat.num-seq-item = item-contrat.num-seq-item.
  end.
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
  
  if avail item-contrat then do:
     display item-contrat.nr-contrat   @ event-mod-contrat.nr-contrat with frame {&frame-name}.
     display item-contrat.it-codigo    @ event-mod-contrat.it-codigo with frame {&frame-name}.
     display item-contrat.num-seq-item @ event-mod-contrat.num-seq-item with frame {&frame-name}.
         find contrato-for where contrato-for.nr-contrato = item-contrat.nr-contrat no-lock no-error.
     if avail contrato-for then do:
        display contrato-for.des-contrat @ c-desc-contrat with frame {&frame-name}.
     end.
     find item where item.it-codigo = item-contrat.it-codigo no-lock no-error.
     if avail item then do:
        display item.desc-item @ c-desc-item with frame {&frame-name}.  
     end.
  end.  
  
  if avail event-mod-contrat then do:
     assign c-descricao = substr(event-mod-contrat.des-event,01,50).
     display c-descricao with frame {&frame-name}.
  end.
  
  find cond-pagto where cond-pagto.cod-cond-pag = event-mod-contrat.cod-cond-pag no-lock no-error.
  if avail cond-pagto then do:
     assign c-desc-cond = cond-pagto.descricao.
     display c-desc-cond with frame {&frame-name}. 
  end.
  
  {utp/ut-liter.i Destina‡Æo * L}
  assign cb-dest-event:label in frame {&frame-name} = return-value.

  
  if avail event-mod-contrat then do with frame {&frame-name}:
     assign cb-dest-event:screen-value = {varinc/var00064.i 04 event-mod-contrat.ind-dest-event}.
  end.
  else do:
      assign cb-dest-event:screen-value = {varinc/var00064.i 04 1}.
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
  
  do with frame {&frame-name}:
     assign cb-dest-event:list-items = {varinc/var00064.i 03}.
  end.
  
  {utp/ut-liter.i Destina‡Æo * L}
  assign cb-dest-event:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Descri‡Æo}
  assign c-descricao:label in frame {&frame-name} = return-value.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  find item-contrat where rowid(item-contrat) = v-row-parent no-lock no-error.
  find contrato-for where contrato-for.nr-contrato = item-contrat.nr-contrat no-lock no-error.
 
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
 *    find tabela where tabela.campo1 = c-variavel and tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, 
                         input 7, 
                         input return-value).
 *    return 'ADM-ERROR':U.*/
 
  if avail item-contrat then do:
     if item-contrat.log-control-event = no or item-contrat.ind-tipo-control = 1 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 8528, 
                           input return-value).
        return 'ADM-ERROR':U.
     end.
  end.
  
  if event-mod-contrat.num-seq-event-mod:sensitive in frame {&frame-name} = yes then do:
     find event-mod-contrat where event-mod-contrat.nr-contrat        = input frame {&frame-name} event-mod-contrat.nr-contrat and 
                                  event-mod-contrat.num-seq-item      = input frame {&frame-name} event-mod-contrat.num-seq-item and 
                                  event-mod-contrat.num-seq-event-mod = input frame {&frame-name} event-mod-contrat.num-seq-event no-lock no-error.
     if available event-mod-contrat then do:
        {include/i-vldprg.i}      
        {utp/ut-table.i mgind event-mod-contrat 1}             
        run utp/ut-msgs.p (input "show":U, 
                           input 1, 
                           input return-value). 
     end.
  end.
 
  if input frame {&frame-name} c-descricao = "" then do:
     {include/i-vldprg.i}      
     run utp/ut-msgs.p (input "show":U, 
                        input 190, 
                        input return-value). 
  end.
  
  find cond-pagto where cond-pagto.cod-cond-pag = input frame {&frame-name} event-mod-contrat.cod-cond-pag no-lock no-error.
  if not avail cond-pagto then do:
     {include/i-vldprg.i}                   
     run utp/ut-msgs.p (input "show":U, 
                        input 8303, 
                        input return-value).
     return 'ADM-ERROR':U.
  end.
  
  assign de-perc-tot = 0.
  for each  b-event-mod-contrat
      where b-event-mod-contrat.nr-contrato  = input frame {&frame-name} event-mod-contrat.nr-contrato
        and b-event-mod-contrat.it-codigo    = input frame {&frame-name} event-mod-contrat.it-codigo
        and b-event-mod-contrat.num-seq-item = input frame {&frame-name} event-mod-contrat.num-seq-item
        and rowid (b-event-mod-contrat)     <> rowid (event-mod-contrat):
      assign de-perc-tot = de-perc-tot + b-event-mod-contrat.perc-lib-previsto.
  end. 
  
  if de-perc-tot + input frame {&frame-name} event-mod-contrat.perc-lib-previsto > 100  then do:
     {include/i-vldprg.i}                   
     run utp/ut-msgs.p (input "show":U, 
                        input 8451, 
                        input return-value).
     return 'ADM-ERROR':U.
  end.
  
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
  {src/adm/template/snd-list.i "event-mod-contrat"}

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


