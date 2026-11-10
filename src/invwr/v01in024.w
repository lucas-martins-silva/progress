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
{include/i-prgvrs.i V01IN024 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in024 MUT}
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
DEF NEW GLOBAL SHARED VAR gr-cab-req-sum AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-lin-prod    AS rowid NO-UNDO.

{cdp/cdcfgman.i}
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 
 
/* ********************  Preprocessor Definitions  ******************** */
 
&Scoped-define PROCEDURE-TYPE SmartViewer
 
&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target
 
/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main
 
/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cab-req-sum
&Scoped-define FIRST-EXTERNAL-TABLE cab-req-sum
 
 
/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cab-req-sum.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cab-req-sum.nr-req-sum cab-req-sum.nr-linha ~
cab-req-sum.dt-ini-pri cab-req-sum.dt-fim-pri cab-req-sum.dt-ini-ult ~
cab-req-sum.dt-fim-ult 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nr-req-sum ~{&FP2}nr-req-sum ~{&FP3}~
 ~{&FP1}nr-linha ~{&FP2}nr-linha ~{&FP3}~
 ~{&FP1}dt-ini-pri ~{&FP2}dt-ini-pri ~{&FP3}~
 ~{&FP1}dt-fim-pri ~{&FP2}dt-fim-pri ~{&FP3}~
 ~{&FP1}dt-ini-ult ~{&FP2}dt-ini-ult ~{&FP3}~
 ~{&FP1}dt-fim-ult ~{&FP2}dt-fim-ult ~{&FP3}
&Scoped-define ENABLED-TABLES cab-req-sum
&Scoped-define FIRST-ENABLED-TABLE cab-req-sum
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS cab-req-sum.nr-req-sum cab-req-sum.nr-linha ~
cab-req-sum.dt-ini-pri cab-req-sum.dt-fim-pri cab-req-sum.dt-ini-ult ~
cab-req-sum.dt-fim-ult 
 
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
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.63.
 
DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 7.
 
 
/* ************************  Frame Definitions  *********************** */
 
DEFINE FRAME f-main
     cab-req-sum.nr-req-sum AT ROW 1.25 COL 40 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     cab-req-sum.nr-linha AT ROW 3.17 COL 40 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cab-req-sum.dt-ini-pri AT ROW 4.5 COL 40 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     cab-req-sum.dt-fim-pri AT ROW 5.58 COL 40 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     cab-req-sum.dt-ini-ult AT ROW 6.92 COL 40 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     cab-req-sum.dt-fim-ult AT ROW 8 COL 40 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.63 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .
 
 
/* *********************** Procedure Settings ************************ */
 
&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.cab-req-sum
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
         HEIGHT             = 8.63
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
  {src/adm/template/row-list.i "cab-req-sum"}
 
  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}
 
  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cab-req-sum"}
 
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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
 
  /* Ponha aqui a valida‡Æo de chave duplicada */
 
  /* Ponha aqui as demais valida‡äes */
 
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
 
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
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .
 
  IF  AVAIL cab-req-sum THEN 
      ASSIGN gr-cab-req-sum = ROWID(cab-req-sum).
  
  &IF DEFINED (bf_man_linha_estab) &THEN
  FIND lin-prod 
       WHERE lin-prod.cod-estabel = cab-req-sum.cod-estabel
         AND lin-prod.nr-linha    = cab-req-sum.nr-linha NO-LOCK NO-ERROR.
  &ELSE
  FIND lin-prod WHERE lin-prod.nr-linha = cab-req-sum.nr-linha NO-LOCK NO-ERROR.  
  &ENDIF
  
  IF  AVAIL lin-prod THEN
      ASSIGN gr-lin-prod = ROWID(lin-prod).    
 
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
  {src/adm/template/snd-list.i "cab-req-sum"}
 
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
 
 
