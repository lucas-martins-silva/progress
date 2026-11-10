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
{include/i-prgvrs.i V11IN287 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v11in287 MUT}
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

def var  i-mo-fasb         as integer   no-undo.
def var  i-mo-cmi          as integer   no-undo.
def var  h_v08in287        as handle    no-undo.
def var  h_v10in287        as handle    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-15 RECT-14 bt-executa3 
&Scoped-Define DISPLAYED-FIELDS param-estoq.tp-ct-moeda1 ~
param-estoq.tp-ct-moeda2 
&Scoped-Define DISPLAYED-OBJECTS c-tit1 c-tit2 

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
DEFINE BUTTON bt-executa3 
     LABEL "" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-tit1 AS CHARACTER FORMAT "X(14)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .63 NO-UNDO.

DEFINE VARIABLE c-tit2 AS CHARACTER FORMAT "X(14)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59.43 BY 2.08.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59.43 BY 1.96.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.72 BY 7.63.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-estoq.tp-ct-moeda1 AT ROW 2.88 COL 27 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Di ria", 1,
"Mensal", 2,
"M‚dia", 3
          SIZE 36.43 BY 1
     param-estoq.tp-ct-moeda2 AT ROW 5.58 COL 27 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Di ria", 1,
"Mensal", 2,
"M‚dia", 3
          SIZE 36.43 BY 1
     bt-executa3 AT ROW 7.46 COL 78.57
     c-tit1 AT ROW 2.08 COL 15 COLON-ALIGNED NO-LABEL
     c-tit2 AT ROW 4.75 COL 15 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1.13 COL 1
     RECT-15 AT ROW 2.38 COL 15.57
     RECT-14 AT ROW 5.04 COL 15.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 7.75
         WIDTH              = 89.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-tit1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET param-estoq.tp-ct-moeda1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET param-estoq.tp-ct-moeda2 IN FRAME f-main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME bt-executa3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executa3 V-table-Win
ON CHOOSE OF bt-executa3 IN FRAME f-main
DO:
  do transaction :
     find first param-estoq exclusive-lock no-error.
     if available param-estoq then
        assign param-estoq.tp-ct-moeda1 = input frame {&frame-name} param-estoq.tp-ct-moeda1
               param-estoq.tp-ct-moeda2 = input frame {&frame-name} param-estoq.tp-ct-moeda2.
  end.            
            
         
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  if valid-handle(h_v08in287) = yes then RUN dispatch IN h_v08in287 ( INPUT 'initialize':U).
  if valid-handle(h_v10in287) = yes then RUN dispatch IN h_v10in287 ( INPUT 'initialize':U).
    

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
  
  {utp/ut-liter.i Executa * C}
  assign bt-executa3:label in frame {&frame-name} = return-value.
    
  find first param-global no-lock no-error.
  if not avail param-global then do:
     run utp/ut-msgs.p (input "show",
                        input 16,
                        input "").
     return 'adm-error'.
  end.
  
  find first param-estoq no-lock no-error.
  if not avail param-estoq then do:
     run utp/ut-msgs.p (input "show",
                        input 1059,
                        input "").
     return 'adm-error'.
  end.
  
  find param-fasb where param-fasb.ep-codigo = param-global.empresa-prin no-lock no-error.
  if avail param-fasb then do:
     assign i-mo-fasb = param-fasb.moeda-fasb
            i-mo-cmi  = param-fasb.moeda-cmi. 
  end.
  
    
  {utp/ut-liter.i Moeda_1 * C}
  assign c-tit1 = return-value.
  display c-tit1 with frame {&frame-name}.
  
  {utp/ut-liter.i Moeda_2 * C}
  assign c-tit2 = return-value. 
  display c-tit2 with frame {&frame-name}.

  if param-estoq.tem-moeda1 then do:
     enable param-estoq.tp-ct-moeda1 with frame {&frame-name}.
  end.
  else do:
     disable param-estoq.tp-ct-moeda1 with frame {&frame-name}.
  end.
  
  if param-estoq.tem-moeda2 then do:
     enable param-estoq.tp-ct-moeda2 with frame {&frame-name}.
  end.
  else do:
     disable param-estoq.tp-ct-moeda2 with frame {&frame-name}.
  end.
  
  
  display param-estoq.tp-ct-moeda1
          param-estoq.tp-ct-moeda2 with frame {&frame-name}.

 
   /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter c-handle1 as handle no-undo.
def input parameter c-handle2 as handle no-undo.

assign h_v08in287 = c-handle1
       h_v10in287 = c-handle2.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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


