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
{include/i-prgvrs.i V30AD098 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V30AD098 MUT}
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS emitente.cod-entrega emitente.per-minfat ~
emitente.perc-fat-ped emitente.per-max-canc emitente.bonificacao ~
emitente.emite-etiq emitente.ind-fat-par 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-entrega ~{&FP2}cod-entrega ~{&FP3}~
 ~{&FP1}per-minfat ~{&FP2}per-minfat ~{&FP3}~
 ~{&FP1}perc-fat-ped ~{&FP2}perc-fat-ped ~{&FP3}~
 ~{&FP1}per-max-canc ~{&FP2}per-max-canc ~{&FP3}~
 ~{&FP1}bonificacao ~{&FP2}bonificacao ~{&FP3}
&Scoped-define ENABLED-TABLES emitente
&Scoped-define FIRST-ENABLED-TABLE emitente
&Scoped-Define ENABLED-OBJECTS RECT-11 
&Scoped-Define DISPLAYED-FIELDS emitente.cod-entrega emitente.per-minfat ~
emitente.perc-fat-ped emitente.per-max-canc emitente.bonificacao ~
emitente.emite-etiq emitente.ind-fat-par 
&Scoped-Define DISPLAYED-OBJECTS cb-ind-div-atraso cb-esp-pd-venda ~
cb-ind-dif-atrs-1 cb-ind-dif-atrs-2 cb-ind-atraso cb-tp-qt-prg 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cb-ind-div-atraso cb-esp-pd-venda ~
cb-ind-dif-atrs-1 cb-ind-dif-atrs-2 cb-ind-atraso cb-tp-qt-prg 
&Scoped-define ADM-ASSIGN-FIELDS cb-ind-div-atraso cb-esp-pd-venda ~
cb-ind-dif-atrs-1 cb-ind-dif-atrs-2 cb-ind-atraso cb-tp-qt-prg 
&Scoped-define ADM-MODIFY-FIELDS cb-ind-div-atraso cb-esp-pd-venda ~
cb-ind-dif-atrs-1 cb-ind-dif-atrs-2 cb-ind-atraso cb-tp-qt-prg 

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
DEFINE VARIABLE cb-esp-pd-venda AS CHARACTER FORMAT "X(256)":U INITIAL "1" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ind-atraso AS CHARACTER FORMAT "X(256)":U INITIAL "1" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ind-dif-atrs-1 AS CHARACTER FORMAT "X(256)":U INITIAL "1" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ind-dif-atrs-2 AS CHARACTER FORMAT "X(256)":U INITIAL "1" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ind-div-atraso AS CHARACTER FORMAT "X(256)":U INITIAL "1" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tp-qt-prg AS CHARACTER FORMAT "X(256)":U INITIAL "1" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 29 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29 BY 2.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     emitente.cod-entrega AT ROW 1.13 COL 22.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     cb-ind-div-atraso AT ROW 2.17 COL 23
     cb-esp-pd-venda AT ROW 3.25 COL 23
     cb-ind-dif-atrs-1 AT ROW 4.38 COL 23
     cb-ind-dif-atrs-2 AT ROW 5.46 COL 23
     cb-ind-atraso AT ROW 6.67 COL 22.29 COLON-ALIGNED
     cb-tp-qt-prg AT ROW 7.83 COL 22.29 COLON-ALIGNED
     emitente.per-minfat AT ROW 2 COL 73.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     emitente.perc-fat-ped AT ROW 3 COL 73.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     emitente.per-max-canc AT ROW 4 COL 73.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     emitente.bonificacao AT ROW 5 COL 73.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     emitente.emite-etiq AT ROW 6.38 COL 58.86
          VIEW-AS TOGGLE-BOX
          SIZE 18.86 BY .83
     emitente.ind-fat-par AT ROW 7.5 COL 58.86
          VIEW-AS TOGGLE-BOX
          SIZE 21.86 BY .83
     RECT-11 AT ROW 6.04 COL 54.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.emitente
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
         HEIGHT             = 8.54
         WIDTH              = 85.72.
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

/* SETTINGS FOR COMBO-BOX cb-esp-pd-venda IN FRAME f-main
   NO-ENABLE ALIGN-L 1 2 3                                              */
/* SETTINGS FOR COMBO-BOX cb-ind-atraso IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-ind-dif-atrs-1 IN FRAME f-main
   NO-ENABLE ALIGN-L 1 2 3                                              */
/* SETTINGS FOR COMBO-BOX cb-ind-dif-atrs-2 IN FRAME f-main
   NO-ENABLE ALIGN-L 1 2 3                                              */
/* SETTINGS FOR COMBO-BOX cb-ind-div-atraso IN FRAME f-main
   NO-ENABLE ALIGN-L 1 2 3                                              */
/* SETTINGS FOR COMBO-BOX cb-tp-qt-prg IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

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
  {src/adm/template/row-list.i "emitente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "emitente"}

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
  assign input frame {&frame-name}  cb-ind-div-atraso 
         emitente.ind-div-atraso  = {adinc\i21ad098.i 06 cb-ind-div-atraso}
         input frame {&frame-name}  cb-esp-pd-venda   
         emitente.esp-pd-venda    = {adinc\i06ad098.i 06 cb-esp-pd-venda}
         input frame {&frame-name}  cb-ind-dif-atrs-1 
         emitente.ind-dif-atrs-1  = {adinc\i19ad098.i 06 cb-ind-dif-atrs-1}
         input frame {&frame-name}  cb-ind-dif-atrs-2 
         emitente.ind-dif-atrs-2  = {adinc\i20ad098.i 06 cb-ind-dif-atrs-2}
         input frame {&frame-name}  cb-ind-atraso     
         emitente.ind-atraso      = {adinc\i18ad098.i 06 cb-ind-atraso}
         input frame {&frame-name}  cb-tp-qt-prg      
         emitente.tp-qt-prg       = {adinc\i23ad098.i 06 cb-tp-qt-prg}.
         
  if emitente.ind-div-atraso = 0 then assign emitente.ind-div-atraso = 1.
  if emitente.esp-pd-venda   = 0 then assign emitente.esp-pd-venda   = 1.
  if emitente.ind-dif-atrs-1 = 0 then assign emitente.ind-dif-atrs-1 = 1.
  if emitente.ind-dif-atrs-2 = 0 then assign emitente.ind-dif-atrs-2 = 1.
  if emitente.ind-atraso     = 0 then assign emitente.ind-atraso     = 1.
  if emitente.tp-qt-prg      = 0 then assign emitente.tp-qt-prg      = 1.
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
  do with frame {&frame-name}:
     if avail emitente then do:
        assign cb-ind-div-atraso:screen-value = if emitente.ind-div-atraso = 0
                                                   then {adinc\i21ad098.i 04 1}
                                                   else {adinc\i21ad098.i 04 emitente.ind-div-atraso}
               cb-esp-pd-venda:screen-value   = if emitente.esp-pd-venda = 0
                                                   then {adinc\i06ad098.i 04 1}
                                                   else {adinc\i06ad098.i 04 emitente.esp-pd-venda}
               cb-ind-dif-atrs-1:screen-value = if emitente.ind-dif-atrs-1 = 0 
                                                   then {adinc\i19ad098.i 04 1}
                                                   else {adinc\i19ad098.i 04 emitente.ind-dif-atrs-1}
               cb-ind-dif-atrs-2:screen-value = if emitente.ind-dif-atrs-2 = 0
                                                   then {adinc\i20ad098.i 04 1}
                                                   else {adinc\i20ad098.i 04 emitente.ind-dif-atrs-2}
               cb-ind-atraso:screen-value     = if emitente.ind-atraso = 0
                                                   then {adinc\i18ad098.i 04 1}
                                                   else {adinc\i18ad098.i 04 emitente.ind-atraso}
               cb-tp-qt-prg:screen-value      = if emitente.tp-qt-prg = 0
                                                   then {adinc\i23ad098.i 04 1}
                                                   else {adinc\i23ad098.i 04 emitente.tp-qt-prg}.
     end.
     else do:
        assign cb-ind-div-atraso:screen-value = {adinc\i21ad098.i 04 1}
               cb-esp-pd-venda:screen-value   = {adinc\i06ad098.i 04 1}
               cb-ind-dif-atrs-1:screen-value = {adinc\i19ad098.i 04 1}
               cb-ind-dif-atrs-2:screen-value = {adinc\i20ad098.i 04 1}
               cb-ind-atraso:screen-value     = {adinc\i18ad098.i 04 1}
               cb-tp-qt-prg:screen-value      = {adinc\i23ad098.i 04 1}.
     end.
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
  Do with frame {&frame-name}:
     assign cb-ind-div-atraso:list-items   = {adinc\i21ad098.i 03}
            cb-ind-div-atraso:screen-value = {adinc\i21ad098.i 04 1}
            cb-esp-pd-venda:list-items     = {adinc\i06ad098.i 03}
            cb-esp-pd-venda:screen-value   = {adinc\i06ad098.i 04 1}            
            cb-ind-dif-atrs-1:list-items   = {adinc\i19ad098.i 03}
            cb-ind-dif-atrs-1:screen-value = {adinc\i19ad098.i 04 1}            
            cb-ind-dif-atrs-2:list-items   = {adinc\i20ad098.i 03}
            cb-ind-dif-atrs-2:screen-value = {adinc\i20ad098.i 04 1}            
            cb-ind-atraso:list-items       = {adinc\i18ad098.i 03}
            cb-ind-atraso:screen-value     = {adinc\i18ad098.i 04 1}            
            cb-tp-qt-prg:list-items        = {adinc\i23ad098.i 03}
            cb-tp-qt-prg:screen-value      = {adinc\i23ad098.i 04 1}.
  End.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-field.i mgadm emitente tp-qt-prg 1}.
  assign cb-tp-qt-prg:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-field.i mgadm emitente ind-atraso 1}.
  assign cb-ind-atraso:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-field.i mgadm emitente ind-div-atraso 1}.
  assign cb-ind-div-atraso:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-field.i mgadm emitente ind-dif-atrs-1 1}.
  assign cb-ind-dif-atrs-1:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-field.i mgadm emitente ind-dif-atrs-2 1}. 
  assign cb-ind-dif-atrs-2:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-field.i mgadm emitente esp-pd-venda 1}.
  assign cb-esp-pd-venda:label in frame {&FRAME-NAME} = return-value.

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
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
  
  /* Ponha aqui as demais valida‡äes */
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "emitente"}

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


