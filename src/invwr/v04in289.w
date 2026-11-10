&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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
{include/i-prgvrs.i V04IN289 2.00.00.002}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04IN289 MUT}
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-mi
&Scoped-define FIRST-EXTERNAL-TABLE param-mi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-mi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-mi.classe-a-pop param-mi.classe-b-pop ~
param-mi.classe-c-pop param-mi.classe-a-val param-mi.classe-b-val ~
param-mi.classe-c-val param-mi.classe-a-par param-mi.classe-b-par ~
param-mi.classe-c-par 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}classe-a-pop ~{&FP2}classe-a-pop ~{&FP3}~
 ~{&FP1}classe-b-pop ~{&FP2}classe-b-pop ~{&FP3}~
 ~{&FP1}classe-c-pop ~{&FP2}classe-c-pop ~{&FP3}~
 ~{&FP1}classe-a-val ~{&FP2}classe-a-val ~{&FP3}~
 ~{&FP1}classe-b-val ~{&FP2}classe-b-val ~{&FP3}~
 ~{&FP1}classe-c-val ~{&FP2}classe-c-val ~{&FP3}~
 ~{&FP1}classe-a-par ~{&FP2}classe-a-par ~{&FP3}~
 ~{&FP1}classe-b-par ~{&FP2}classe-b-par ~{&FP3}~
 ~{&FP1}classe-c-par ~{&FP2}classe-c-par ~{&FP3}
&Scoped-define ENABLED-TABLES param-mi
&Scoped-define FIRST-ENABLED-TABLE param-mi
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS param-mi.classe-a-pop param-mi.classe-b-pop ~
param-mi.classe-c-pop param-mi.classe-a-val param-mi.classe-b-val ~
param-mi.classe-c-val param-mi.classe-a-par param-mi.classe-b-par ~
param-mi.classe-c-par 

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
DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73 BY 9.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-mi.classe-a-pop AT ROW 1.38 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     param-mi.classe-b-pop AT ROW 2.38 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     param-mi.classe-c-pop AT ROW 3.38 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     param-mi.classe-a-val AT ROW 4.38 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     param-mi.classe-b-val AT ROW 5.42 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     param-mi.classe-c-val AT ROW 6.38 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     param-mi.classe-a-par AT ROW 7.38 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     param-mi.classe-b-par AT ROW 8.38 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     param-mi.classe-c-par AT ROW 9.38 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     rt-mold AT ROW 1 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-mi
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
         HEIGHT             = 9.58
         WIDTH              = 73.86.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Default                                      */
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
  {src/adm/template/row-list.i "param-mi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-mi"}

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
  {include/i-valid.i}
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} 
  
  IF (INPUT FRAME {&frame-name} param-mi.classe-b-pop) < (input frame {&frame-name} param-mi.classe-a-pop)
  then do:
       {include/i-vldprg.i} 
       RUN utp/ut-msgs.p (input "show",
                          input 3143,
                          input "").
       APPLY "entry" TO param-mi.classe-b-pop IN FRAME {&frame-name}.
       RETURN "adm-error".                         
  END.  
  
  IF INPUT FRAME {&frame-name} param-mi.classe-c-pop <> 100
  THEN DO:
       {include/i-vldprg.i}
        RUN utp/ut-msgs.p (input "show",
                           input 3142,
                           input "").
        APPLY "entry" TO param-mi.classe-c-pop IN FRAME {&frame-name}.
        RETURN "adm-error".                           
  END.
  
  IF (INPUT FRAME {&frame-name} param-mi.classe-b-val) < (input frame {&frame-name} param-mi.classe-a-val)
  THEN DO:
       {include/i-vldprg.i}
       RUN utp/ut-msgs.p (input "show",
                          input 3143,
                          input "").
       APPLY "entry" TO param-mi.classe-b-val IN FRAME {&frame-name}.
       RETURN "adm-error".                           
  END.
  
  IF INPUT FRAME {&frame-name} param-mi.classe-c-val <> 100
  then do:
       {include/i-vldprg.i}                  
       RUN utp/ut-msgs.p (input "show",
                          input 3142,
                          input "").
       APPLY "entry" TO param-mi.classe-c-val IN FRAME {&frame-name}.
       RETURN "adm-error".                         
  END.  
  
  IF (INPUT FRAME {&frame-name} param-mi.classe-b-par) < (input frame {&frame-name} param-mi.classe-a-par) 
  THEN DO:
       {include/i-vldprg.i}
       RUN utp/ut-msgs.p (input "show",
                          input 3143,
                          input "").
       APPLY "entry" TO param-mi.classe-b-par IN FRAME {&frame-name}.
       RETURN "adm-error".                           
  END.
  
  IF INPUT FRAME {&frame-name} param-mi.classe-c-par <> 100
  THEN DO:
       {include/i-vldprg.i}
       RUN utp/ut-msgs.p (input "show",
                          input 3142,
                          input "").
       APPLY "entry" TO param-mi.classe-c-par IN FRAME {&frame-name}.
       RETURN "adm-error".                           
  END.

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
  {src/adm/template/snd-list.i "param-mi"}

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


