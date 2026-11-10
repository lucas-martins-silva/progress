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
{include/i-prgvrs.i V02IN282 2.00.00.004}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN282 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-variavel  as char no-undo.
def var wh-variavel as handle no-undo.
def new global shared var l-erro-v2 as logical no-undo.
def new global shared var gr-param-cq as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-cq
&Scoped-define FIRST-EXTERNAL-TABLE param-cq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-cq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-cq.com-sn-lote param-cq.com-sn-reje ~
param-cq.com-na-lote param-cq.com-na-reje param-cq.com-ns-lote ~
param-cq.com-ns-reje param-cq.com-an-lote param-cq.com-an-reje 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}com-sn-lote ~{&FP2}com-sn-lote ~{&FP3}~
 ~{&FP1}com-sn-reje ~{&FP2}com-sn-reje ~{&FP3}~
 ~{&FP1}com-na-lote ~{&FP2}com-na-lote ~{&FP3}~
 ~{&FP1}com-na-reje ~{&FP2}com-na-reje ~{&FP3}~
 ~{&FP1}com-ns-lote ~{&FP2}com-ns-lote ~{&FP3}~
 ~{&FP1}com-ns-reje ~{&FP2}com-ns-reje ~{&FP3}~
 ~{&FP1}com-an-lote ~{&FP2}com-an-lote ~{&FP3}~
 ~{&FP1}com-an-reje ~{&FP2}com-an-reje ~{&FP3}
&Scoped-define ENABLED-TABLES param-cq
&Scoped-define FIRST-ENABLED-TABLE param-cq
&Scoped-Define ENABLED-OBJECTS rt-mold c-label-de-para c-label-nr-lotes ~
c-label-max-lotes c-label-severa-normal c-label-normal-atenuada ~
c-label-normal-severa c-label-atenuada-normal 
&Scoped-Define DISPLAYED-FIELDS param-cq.com-sn-lote param-cq.com-sn-reje ~
param-cq.com-na-lote param-cq.com-na-reje param-cq.com-ns-lote ~
param-cq.com-ns-reje param-cq.com-an-lote param-cq.com-an-reje 
&Scoped-Define DISPLAYED-OBJECTS c-label-de-para c-label-nr-lotes ~
c-label-max-lotes c-label-severa-normal c-label-normal-atenuada ~
c-label-normal-severa c-label-atenuada-normal 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

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
DEFINE VARIABLE c-label-atenuada-normal AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-de-para AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-max-lotes AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-normal-atenuada AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-normal-severa AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-nr-lotes AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-severa-normal AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.57 BY 6.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-cq.com-sn-lote AT ROW 3 COL 36.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     param-cq.com-sn-reje AT ROW 3 COL 64.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     param-cq.com-na-lote AT ROW 4 COL 36.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     param-cq.com-na-reje AT ROW 4 COL 64.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     param-cq.com-ns-lote AT ROW 5 COL 36.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     param-cq.com-ns-reje AT ROW 5 COL 64.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     param-cq.com-an-lote AT ROW 6 COL 36.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     param-cq.com-an-reje AT ROW 6 COL 64.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-label-de-para AT ROW 1.63 COL 6 COLON-ALIGNED NO-LABEL
     c-label-nr-lotes AT ROW 1.63 COL 33.72 COLON-ALIGNED NO-LABEL
     c-label-max-lotes AT ROW 1.63 COL 53.57 COLON-ALIGNED NO-LABEL
     c-label-severa-normal AT ROW 3 COL 6 COLON-ALIGNED NO-LABEL
     c-label-normal-atenuada AT ROW 3.96 COL 6 COLON-ALIGNED NO-LABEL
     c-label-normal-severa AT ROW 5 COL 6 COLON-ALIGNED NO-LABEL
     c-label-atenuada-normal AT ROW 6 COL 6 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-cq
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
         HEIGHT             = 6.54
         WIDTH              = 85.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R, COLUMNS                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

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
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-desabilita V-table-Win 
PROCEDURE adm-desabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DISABLE all WITH FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-habilita V-table-Win 
PROCEDURE adm-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ENABLE all WITH FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  {src/adm/template/row-list.i "param-cq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-cq"}

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

  RUN Who-Is-The-Container IN adm-broker-hdl
      (INPUT this-procedure,
       OUTPUT c-variavel).
  assign wh-variavel = widget-handle(c-variavel).

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT string(param-cq.tipo-cq)).
  
  assign l-erro-v2 = no.
  if string(param-cq.tipo-cq) = "3" then do:
  
     /* Nr m ximo rejeitados tem que ser menor que nr lotes */
     if integer(param-cq.com-sn-reje:screen-value in frame {&FRAME-NAME}) > 
         integer(param-cq.com-sn-lote:screen-value in frame {&FRAME-NAME}) then do:
        assign l-erro-v2 = yes.
        run utp/ut-msgs.p (input "show",
                           input 505,
                           input param-cq.com-sn-reje:screen-value in frame {&FRAME-NAME} + "~~" +
                                 param-cq.com-sn-lote:screen-value in frame {&FRAME-NAME}).
        run select-page in wh-variavel (2).
        apply 'ENTRY' to param-cq.com-sn-reje.
        return 'adm-error'.
     end.

     /* Nr de lotes normal/atenuada tem que ser maior que nr lotes severa/normal */
     if integer(param-cq.com-na-lote:screen-value in frame {&FRAME-NAME}) <= 
        integer(param-cq.com-sn-lote:screen-value in frame {&FRAME-NAME}) then do:
        assign l-erro-v2 = yes.
        run utp/ut-msgs.p (input "show",
                           input 506,
                           input "").
        run select-page in wh-variavel (2).
        apply 'entry' to param-cq.com-na-lote.
        return 'adm-error'.
     end.

     /* Nr m ximo de rejeitados tem que ser menor que nr lotes */
     if integer(param-cq.com-na-reje:screen-value in frame {&FRAME-NAME}) > 
        integer(param-cq.com-na-lote:screen-value in frame {&FRAME-NAME}) then do:
        assign l-erro-v2 = yes.
        run utp/ut-msgs.p (input "show",
                           input 505,
                           input param-cq.com-na-reje:screen-value in frame {&FRAME-NAME} + "~~" +
                                 param-cq.com-na-lote:screen-value in frame {&FRAME-NAME}).
        run select-page in wh-variavel (2).
        apply 'entry' to param-cq.com-na-reje.
        return 'adm-error'.
     end.
   
     /* Nr m ximo de rejeitados tem que ser menor que nr lotes */
     if integer(param-cq.com-ns-reje:screen-value in frame {&FRAME-NAME}) > 
        integer(param-cq.com-ns-lote:screen-value in frame {&FRAME-NAME}) then do:
        assign l-erro-v2 = yes.
        run utp/ut-msgs.p (input "show",
                           input 505,
                           input param-cq.com-ns-reje:screen-value in frame {&FRAME-NAME} + "~~" +
                                 param-cq.com-ns-lote:screen-value in frame {&FRAME-NAME}).
        run select-page in wh-variavel (2).
        apply 'entry' to param-cq.com-ns-reje.
        return 'adm-error'.
     end.
   
     /* Nr m ximo de rejeitados tem que ser menor que nr lotes */
     if integer(param-cq.com-an-reje:screen-value in frame {&FRAME-NAME}) > 
        integer(param-cq.com-an-lote:screen-value in frame {&FRAME-NAME}) then do:
        assign l-erro-v2 = yes.
        run utp/ut-msgs.p (input "show",
                           input 505,
                           input param-cq.com-an-reje:screen-value in frame {&FRAME-NAME} + "~~" +
                                 param-cq.com-an-lote:screen-value in frame {&FRAME-NAME}).
        run select-page in wh-variavel (2).
        apply 'entry' to param-cq.com-an-reje.
        return 'adm-error'.
     end.
             
  end.

  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.


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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-liter.i De_/_Para * R}
  assign c-label-de-para:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Nr_de_Lotes * R}
  assign c-label-nr-lotes:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Nr_M ximo_Lotes_Rejeitados * R}
  assign c-label-max-lotes:screen-value in frame {&FRAME-NAME} = return-value.
  
  {utp/ut-liter.i Severa/Normal * R}
  assign c-label-severa-normal:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Normal/Atenuada * R}
  assign c-label-normal-atenuada:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Normal/Severa * R}
  assign c-label-normal-severa:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Atenuada/Normal * R}
  assign c-label-atenuada-normal:screen-value in frame {&FRAME-NAME} = return-value.

  if avail param-cq then do:
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT 'tipo-cq').

    IF return-value = '3' then
       ENABLE ALL WITH FRAME {&frame-name}.
    ELSE 
       DISABLE ALL WITH FRAME {&frame-name}.  
  end.       


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

  if avail param-cq then
     assign gr-param-cq = rowid(param-cq).

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "param-cq"}

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


