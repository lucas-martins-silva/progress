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
{include/i-prgvrs.i V01AD277 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01AD277 MUT}
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
&Scoped-define EXTERNAL-TABLES usuar-alter-cr
&Scoped-define FIRST-EXTERNAL-TABLE usuar-alter-cr


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR usuar-alter-cr.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS usuar-alter-cr.log-cancel-acerto-valor ~
usuar-alter-cr.log-cancel-baixa-devol usuar-alter-cr.log-comissoes ~
usuar-alter-cr.log-cancel-desconto usuar-alter-cr.log-saldo ~
usuar-alter-cr.log-cancel-desp-bcia usuar-alter-cr.log-vencto ~
usuar-alter-cr.log-cancel-subst usuar-alter-cr.log-emissao ~
usuar-alter-cr.log-cancel-titulo usuar-alter-cr.log-reemis-bord 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES usuar-alter-cr
&Scoped-define FIRST-ENABLED-TABLE usuar-alter-cr
&Scoped-Define ENABLED-OBJECTS rt-key RECT-1 RECT-2 rt-mold c-cancela ~
c-altera 
&Scoped-Define DISPLAYED-FIELDS usuar-alter-cr.usuario ~
usuar-alter-cr.log-cancel-acerto-valor ~
usuar-alter-cr.log-cancel-baixa-devol usuar-alter-cr.log-comissoes ~
usuar-alter-cr.log-cancel-desconto usuar-alter-cr.log-saldo ~
usuar-alter-cr.log-cancel-desp-bcia usuar-alter-cr.log-vencto ~
usuar-alter-cr.log-cancel-subst usuar-alter-cr.log-emissao ~
usuar-alter-cr.log-cancel-titulo usuar-alter-cr.log-reemis-bord 
&Scoped-Define DISPLAYED-OBJECTS c-cancela c-altera 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS usuar-alter-cr.usuario 

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
DEFINE VARIABLE c-altera AS CHARACTER FORMAT "X(25)":U 
      VIEW-AS TEXT 
     SIZE 25.72 BY .67 NO-UNDO.

DEFINE VARIABLE c-cancela AS CHARACTER FORMAT "X(25)":U 
      VIEW-AS TEXT 
     SIZE 30.43 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.57 BY 5.79.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.29 BY 5.79.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     usuar-alter-cr.usuario AT ROW 1.13 COL 28.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     usuar-alter-cr.log-cancel-acerto-valor AT ROW 3.21 COL 9.86
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .83
     usuar-alter-cr.log-cancel-baixa-devol AT ROW 4.04 COL 9.86
          VIEW-AS TOGGLE-BOX
          SIZE 30.43 BY .83
     usuar-alter-cr.log-comissoes AT ROW 4.13 COL 58.29
          VIEW-AS TOGGLE-BOX
          SIZE 22 BY .83
     usuar-alter-cr.log-cancel-desconto AT ROW 4.88 COL 9.86
          VIEW-AS TOGGLE-BOX
          SIZE 22.72 BY .83
     usuar-alter-cr.log-saldo AT ROW 4.96 COL 58.29
          VIEW-AS TOGGLE-BOX
          SIZE 16.57 BY .83
     usuar-alter-cr.log-cancel-desp-bcia AT ROW 5.71 COL 9.86
          VIEW-AS TOGGLE-BOX
          SIZE 27.72 BY .83
     usuar-alter-cr.log-vencto AT ROW 5.79 COL 58.29
          VIEW-AS TOGGLE-BOX
          SIZE 22.57 BY .83
     usuar-alter-cr.log-cancel-subst AT ROW 6.54 COL 9.86
          VIEW-AS TOGGLE-BOX
          SIZE 25.43 BY .83
     usuar-alter-cr.log-emissao AT ROW 6.63 COL 58.29
          VIEW-AS TOGGLE-BOX
          SIZE 18.43 BY .83
     usuar-alter-cr.log-cancel-titulo AT ROW 7.38 COL 9.86
          VIEW-AS TOGGLE-BOX
          SIZE 18.57 BY .83
     usuar-alter-cr.log-reemis-bord AT ROW 9.5 COL 9.86
          VIEW-AS TOGGLE-BOX
          SIZE 24.57 BY .83
     c-cancela AT ROW 2.38 COL 1.29 COLON-ALIGNED NO-LABEL
     c-altera AT ROW 2.38 COL 46 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     RECT-1 AT ROW 2.75 COL 1
     RECT-2 AT ROW 2.75 COL 46.14
     rt-mold AT ROW 9.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.usuar-alter-cr
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
         HEIGHT             = 9.79
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

/* SETTINGS FOR FILL-IN usuar-alter-cr.usuario IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME usuar-alter-cr.usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-alter-cr.usuario V-table-Win
ON F5 OF usuar-alter-cr.usuario IN FRAME f-main /* Usu rio */
DO:
    {include/zoomvar.i &prog-zoom=unzoom/z01un178.w
                       &campo=usuar-alter-cr.usuario
                       &campozoom=cod_usuario}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-alter-cr.usuario V-table-Win
ON MOUSE-SELECT-DBLCLICK OF usuar-alter-cr.usuario IN FRAME f-main /* Usu rio */
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
  
  if usuar-alter-cr.usuario:load-mouse-pointer ("image/lupa.cur") then.
  
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
  {src/adm/template/row-list.i "usuar-alter-cr"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "usuar-alter-cr"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {utp/ut-liter.i Cancelamento_Documentos * R}
  assign c-cancela:screen-value in frame {&FRAME-NAME} = return-value.
  
  {utp/ut-liter.i Altera‡Æo_Documentos * R}
  assign c-altera:screen-value in frame {&FRAME-NAME} = return-value.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

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
  
  RUN get-attribute ('adm-new-record':U).
  if  return-value = "yes":U then do:
   find first usuar_mestre where usuar_mestre.cod_usuario = input frame {&FRAME-NAME}
       usuar-alter-cr.usuario no-error.
       if available usuar_mestre then do:
              find first usuar-alter-cr where usuar-alter-cr.ep-codigo = i-ep-codigo-usuario and
                   usuar-alter-cr.usuario = input frame {&frame-name} usuar-alter-cr.usuario
                   no-error.
               if  avail usuar-alter-cr then do:
                    run utp/ut-msgs.p (input "show", 
                                       input 4083, 
                                       input input frame {&frame-name} usuar-alter-cr.usuario).
                    apply 'entry':U to usuar-alter-cr.usuario in frame {&FRAME-NAME}.
                    return 'adm-error'.
                end.  
           end.
           else do:
               {utp/ut-liter.i mguni usuar_mestre cod_usuario 1}
                    run utp/ut-msgs.p (input "show", 
                                       input 3211, 
                                       input input frame {&frame-name} usuar-alter-cr.usuario).
                    apply 'entry':U to usuar-alter-cr.usuario in frame {&FRAME-NAME}.
                    return 'adm-error'.
                end.  
           end.  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  RUN get-attribute ('adm-new-record':U).
  if  return-value = "yes":U then do:
      assign usuar-alter-cr.ep-codigo = i-ep-codigo-usuario.
  end.
  
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
  {utp/ut-liter.i Cancelamento_Documentos * R}
  assign c-cancela:screen-value in frame {&FRAME-NAME} = return-value.
  
  {utp/ut-liter.i Altera‡Æo_Documentos * R}
  assign c-altera:screen-value in frame {&FRAME-NAME} = return-value.
  
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
  {src/adm/template/snd-list.i "usuar-alter-cr"}

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


