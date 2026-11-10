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
{include/i-prgvrs.i V01IN280 2.00.00.015}  /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i V01IN280 MUT}
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

def var c-handle  as character no-undo.
def var wh-cc0104 as handle    no-undo.

define variable c-format      as character                          no-undo.

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
&Scoped-define EXTERNAL-TABLES param-compra
&Scoped-define FIRST-EXTERNAL-TABLE param-compra


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-compra.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-compra.prim-ord-man ~
param-compra.ult-ord-man param-compra.prim-solic-man ~
param-compra.ult-solic-man param-compra.prim-solic-esp ~
param-compra.ult-solic-esp param-compra.prim-solic-aut ~
param-compra.ult-solic-aut param-compra.num-pedido-ini ~
param-compra.num-pedido-fim param-compra.prox-ord-aut 
&Scoped-define ENABLED-TABLES param-compra
&Scoped-define FIRST-ENABLED-TABLE param-compra
&Scoped-define DISPLAYED-TABLES param-compra
&Scoped-define FIRST-DISPLAYED-TABLE param-compra
&Scoped-Define ENABLED-OBJECTS Habilita-ordem Habilita-solic RECT-7 RECT-8 
&Scoped-Define DISPLAYED-FIELDS param-compra.prim-ord-man ~
param-compra.ult-ord-man param-compra.prim-solic-man ~
param-compra.ult-solic-man param-compra.prim-solic-esp ~
param-compra.ult-solic-esp param-compra.prim-solic-aut ~
param-compra.ult-solic-aut param-compra.num-pedido-ini ~
param-compra.num-pedido-fim param-compra.prox-ord-aut 
&Scoped-Define DISPLAYED-OBJECTS Habilita-ordem Habilita-solic 

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
DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.57 BY 7.38.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.72 BY 2.04.

DEFINE VARIABLE Habilita-ordem AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .83 NO-UNDO.

DEFINE VARIABLE Habilita-solic AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.72 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-compra.prim-ord-man AT ROW 1.46 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     param-compra.ult-ord-man AT ROW 1.46 COL 63.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     param-compra.prim-solic-man AT ROW 2.46 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     param-compra.ult-solic-man AT ROW 2.46 COL 63.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     param-compra.prim-solic-esp AT ROW 3.46 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     param-compra.ult-solic-esp AT ROW 3.46 COL 63.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     param-compra.prim-solic-aut AT ROW 4.46 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     param-compra.ult-solic-aut AT ROW 4.46 COL 63.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     param-compra.num-pedido-ini AT ROW 5.46 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     param-compra.num-pedido-fim AT ROW 5.46 COL 63.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     param-compra.prox-ord-aut AT ROW 7.17 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     Habilita-ordem AT ROW 9.29 COL 9.29
     Habilita-solic AT ROW 9.29 COL 48.43
     RECT-7 AT ROW 1.08 COL 1
     RECT-8 AT ROW 8.71 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-compra
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
         HEIGHT             = 9.79
         WIDTH              = 85.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

    /* Altera o format dos campos de n£mero de pedido (inicial e final) de acordo com
       a tabela pedido-compr --------------------------------------------------------*/
       
    do with frame {&FRAME-NAME}:
        {utp/ut-field.i mgind pedido-compr num-pedido 4}
        assign
            param-compra.num-pedido-ini:format = return-value
            param-compra.num-pedido-fim:format = return-value.
    end.            

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

{utp/ut-liter.i Habilita_N£mero_da_Ordem * R}
assign habilita-ordem:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Habilita_N£mero_da_Solicita‡Æo * R}
assign habilita-solic:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "param-compra"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-compra"}

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
    
  /* Ponha aqui as demais valida‡äes */
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

  if  param-compra.utiliza-icm = no then
      assign param-compra.aliq-icm-pad = 0.
  if  param-compra.utiliza-iss = no then 
      assign param-compra.aliq-iss-pad = 0.
  if  param-compra.utiliza-taxa = no then
      assign param-compra.taxa-financ  = 0
             param-compra.nr-dias-taxa = 0.
             
  if input frame {&frame-name} habilita-ordem = yes then do:
       assign substring(param-compra.char-2,14,1,"character") = "Y". 
   end.  
   else assign substring(param-compra.char-2,14,1,"character") = "N".  
   
    if input frame {&frame-name} habilita-solic = yes then do:
       assign substring(param-compra.char-2,15,1,"character") = "Y". 
   end.  
   else assign substring(param-compra.char-2,15,1,"character") = "N".  


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
  
  find first param-compra no-lock no-error.
  
  if substring(param-compra.char-2,14,1,"char") = "Y" then
     assign habilita-ordem:checked in frame {&frame-name} = yes.
  else assign habilita-ordem:checked in frame {&frame-name} = no.
  
  if substring(param-compra.char-2,15,1,"char") = "Y" then
     assign habilita-solic:checked in frame {&frame-name} = yes.
  else assign habilita-solic:checked in frame {&frame-name} = no.

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

{include/i-vldfrm.i}

  /* Ponha aqui a valida‡Æo de chave duplicada */
  RUN Who-Is-The-Container IN adm-broker-hdl
      (INPUT this-procedure, OUTPUT c-handle).
  assign wh-cc0104 = widget-handle(c-handle).
  
  Do  with frame {&frame-name}:
      if  input param-compra.ult-ord-man <= input param-compra.prim-ord-man then do:
          {include/i-vldprg.i}     
          run utp/ut-msgs.p (input "show", input 257, input "").        
          RUN select-page IN wh-cc0104 (1).                    
          apply "entry":U to param-compra.ult-ord-man.                   
          RETURN 'ADM-ERROR':U.                     
      end.
      if  input param-compra.ult-solic-man <= input param-compra.prim-solic-man then do:
          {include/i-vldprg.i}     
          run utp/ut-msgs.p (input "show", input 257, input "").        
          RUN select-page IN wh-cc0104 (1).                    
          apply "entry":U to param-compra.ult-solic-man.                   
          RETURN 'ADM-ERROR':U.                     
      end.
      if  input param-compra.ult-solic-esp <= input param-compra.prim-solic-esp then do:
          {include/i-vldprg.i}     
          run utp/ut-msgs.p (input "show", input 257, input "").        
          RUN select-page IN wh-cc0104 (1).                    
          apply "entry":U to param-compra.ult-solic-esp.                   
          RETURN 'ADM-ERROR':U.                     
      end.
      if  input param-compra.ult-solic-aut <= input param-compra.prim-solic-aut then do:
          {include/i-vldprg.i}     
          run utp/ut-msgs.p (input "show", input 257, input "").        
          RUN select-page IN wh-cc0104 (1).                    
          apply "entry":U to param-compra.ult-solic-aut.                   
          RETURN 'ADM-ERROR':U.                     
      end.
      if  input mgind.param-compra.num-pedido-fim <= input mgind.param-compra.num-pedido-ini then do:
          {include/i-vldprg.i}     
          run utp/ut-msgs.p (input "show", input 257, input "").        
          RUN select-page IN wh-cc0104 (1).                    
          apply "entry":U to mgind.param-compra.num-pedido-fim.                   
          RETURN 'ADM-ERROR':U.                     
      end.
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
  {src/adm/template/snd-list.i "param-compra"}

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

