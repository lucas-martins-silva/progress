&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V06IN292 2.00.00.022 } /*** 010022 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V06IN292 MUT}
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
def var l-inclui as logical no-undo init no.

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
&Scoped-define EXTERNAL-TABLES param-re
&Scoped-define FIRST-EXTERNAL-TABLE param-re


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-re.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-re.tipo-arredonda param-re.orig-aliq-ip ~
param-re.rateia-frete param-re.var-emis param-re.var-atual ~
param-re.esp-def-nff param-re.dec-1 
&Scoped-define ENABLED-TABLES param-re
&Scoped-define FIRST-ENABLED-TABLE param-re
&Scoped-Define ENABLED-OBJECTS RECT-14 RECT-8 RECT-16 rt-mold 
&Scoped-Define DISPLAYED-FIELDS param-re.tipo-arredonda ~
param-re.orig-aliq-ip param-re.rateia-frete param-re.var-emis ~
param-re.var-atual param-re.esp-def-nff param-re.dec-1 
&Scoped-define DISPLAYED-TABLES param-re
&Scoped-define FIRST-DISPLAYED-TABLE param-re
&Scoped-Define DISPLAYED-OBJECTS c-esp-def-nff c-tp-atual-cr ~
c-tipo-arredonda c-orig-aliq-ip c-rateia-frete 

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
DEFINE VARIABLE c-esp-def-nff AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-orig-aliq-ip AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13.57 BY .67 NO-UNDO.

DEFINE VARIABLE c-rateia-frete AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-tipo-arredonda AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14.86 BY .67 NO-UNDO.

DEFINE VARIABLE c-tp-atual-cr AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10.29 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 4.33.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27.72 BY 1.92.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27.72 BY 1.92.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 4.79.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-re.tipo-arredonda AT ROW 1.92 COL 3.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Dois", 1,
"Cinco", 2
          SIZE 22.86 BY .88
     param-re.orig-aliq-ip AT ROW 2.25 COL 33.43 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Classif Fiscal", 1,
"Item", 2
          SIZE 18.57 BY 2.25
     param-re.rateia-frete AT ROW 4.17 COL 3.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Peso", 1,
"Valor", 2
          SIZE 23.14 BY .88
     param-re.var-emis AT ROW 6.29 COL 29.29 COLON-ALIGNED FORMAT "9999"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     param-re.var-atual AT ROW 7.29 COL 29.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     param-re.esp-def-nff AT ROW 8.29 COL 29.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     c-esp-def-nff AT ROW 8.29 COL 34.57 COLON-ALIGNED NO-LABEL
     param-re.dec-1 AT ROW 9.29 COL 29.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.14 BY .88
     c-tp-atual-cr AT ROW 1 COL 30.43 COLON-ALIGNED NO-LABEL
     c-tipo-arredonda AT ROW 1.08 COL 16 RIGHT-ALIGNED NO-LABEL
     c-orig-aliq-ip AT ROW 1.08 COL 30.72 COLON-ALIGNED NO-LABEL
     c-rateia-frete AT ROW 3.42 COL 2.14 NO-LABEL
     RECT-14 AT ROW 1.29 COL 30.14
     RECT-8 AT ROW 1.33 COL 1
     RECT-16 AT ROW 3.67 COL 1
     rt-mold AT ROW 5.88 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-re
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
         HEIGHT             = 9.83
         WIDTH              = 84.
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

/* SETTINGS FOR FILL-IN c-esp-def-nff IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-orig-aliq-ip IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-orig-aliq-ip:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-rateia-frete IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-tipo-arredonda IN FRAME f-main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN c-tp-atual-cr IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-tp-atual-cr:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       param-re.dec-1:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       param-re.orig-aliq-ip:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       RECT-14:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN param-re.var-emis IN FRAME f-main
   EXP-FORMAT                                                           */
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

&Scoped-define SELF-NAME param-re.esp-def-nff
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-re.esp-def-nff V-table-Win
ON F5 OF param-re.esp-def-nff IN FRAME f-main /* Esp‚cie Duplicatas NFF */
DO:
  assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="adzoom/z01ad104.w"
                       &campo=param-re.esp-def-nff
                       &campozoom=cod-esp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-re.esp-def-nff V-table-Win
ON LEAVE OF param-re.esp-def-nff IN FRAME f-main /* Esp‚cie Duplicatas NFF */
DO:
  {include/leave.i &tabela=espec-ap
                         &atributo-ref=descricao
                         &variavel-ref=c-esp-def-nff
                         &where="espec-ap.cod-esp = input frame {&frame-name} param-re.esp-def-nff"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-re.esp-def-nff V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-re.esp-def-nff IN FRAME f-main /* Esp‚cie Duplicatas NFF */
DO:
  apply "f5" to self.
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

  if param-re.esp-def-nff:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

  {utp/ut-field.i mgind param-re rateia-frete 1}
  assign c-rateia-frete:screen-value in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind param-re tipo-arredonda 1}
  assign c-tipo-arredonda:screen-value in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind param-re orig-aliq-ip 1}
  assign c-orig-aliq-ip:screen-value in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "param-re"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-re"}

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
  assign l-inclui = yes.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

 {utp/ut-field.i mgind param-re rateia-frete 1}
 assign c-rateia-frete:screen-value in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind param-re tipo-arredonda 1}
  assign c-tipo-arredonda:screen-value in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind param-re orig-aliq-ip 1}
  assign c-orig-aliq-ip:screen-value in frame {&frame-name} = return-value. 

  {utp/ut-liter.i Diferen‡a_Aceit vel_Impostos * L}
  assign param-re.dec-1:label in frame {&frame-name} = return-value.


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
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.
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

  {utp/ut-field.i mgind param-re rateia-frete 1}
  assign c-rateia-frete:screen-value in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind param-re tipo-arredonda 1}
  assign c-tipo-arredonda:screen-value in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind param-re orig-aliq-ip 1}
  assign c-orig-aliq-ip:screen-value in frame {&frame-name} = return-value. 

  {utp/ut-field.i mgind param-re tp-atual-cr 1}
  assign c-tp-atual-cr:screen-value in frame {&frame-name} = return-value. 

  {utp/ut-liter.i Diferen‡a_Aceit vel_Impostos * L}
  assign param-re.dec-1:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Diferen‡a_Aceit vel_Impostos * L}
  assign param-re.dec-1:label in frame {&frame-name} = return-value
         param-re.dec-1:format in frame {&frame-name} = "9.99".

  find espec-ap where espec-ap.cod-esp = input frame {&frame-name} param-re.esp-def-nff no-lock no-error.
  if available espec-ap then
      display espec-ap.descricao @ c-esp-def-nff with frame {&frame-name}.

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

  assign param-re.dec-1:format in frame {&frame-name} = "9.99".
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
  assign param-re.esp-def-nff:format in frame {&frame-name} = "x(2)".
  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i Esp‚cie_Duplicatas_NFF MFT R}
  assign param-re.esp-def-nff:label in frame {&frame-name} = trim(return-value).

  {utp/ut-field.i mgind param-re orig-aliq-ip 1}
  assign c-orig-aliq-ip:screen-value in frame {&frame-name} = return-value.

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

  find espec-ap where espec-ap.cod-esp = input frame {&frame-name} param-re.esp-def-nff no-lock no-error.
  if available espec-ap then do:
      if espec-ap.tipo = 2 then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show", 
                             input 4641, 
                             input "").
          apply "entry" to param-re.esp-def-nff in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
  end. 

  if input frame {&frame-name} param-re.dec-1 > 1.00 then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show", 
                         input 15322, 
                         input "").
      apply "entry" to param-re.dec-1 in frame {&frame-name}.
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
  {src/adm/template/snd-list.i "param-re"}

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

