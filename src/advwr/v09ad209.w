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
{include/i-prgvrs.i V09AD209 2.00.00.004} /*** "010004" 25/06/2025 16:21:13  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V09AD209 MUT}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{utp/ut-glob.i}

{cdp/cd1501.i2} /* Verifica Funá∆o Cobr Centralizada */

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var l-cob-centr-aux as logical no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES portador
&Scoped-define FIRST-EXTERNAL-TABLE portador


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR portador.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS portador.log-1 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES portador
&Scoped-define FIRST-ENABLED-TABLE portador
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS portador.cod-portador portador.nome ~
portador.log-1 
&Scoped-Define DISPLAYED-OBJECTS c-modalidade l-cob-centr 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS l-cob-centr 

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
DEFINE VARIABLE c-modalidade AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.38.

DEFINE VARIABLE l-cob-centr AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.72 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     portador.cod-portador AT ROW 1.17 COL 26.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     portador.nome AT ROW 1.17 COL 33.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 44 BY .88
     c-modalidade AT ROW 2.17 COL 26.29 COLON-ALIGNED
     portador.log-1 AT ROW 3.63 COL 28.43
          VIEW-AS TOGGLE-BOX
          SIZE 27.57 BY .83
     l-cob-centr AT ROW 4.63 COL 28.43
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.portador
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 4.75
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

/* SETTINGS FOR FILL-IN c-modalidade IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN portador.cod-portador IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-cob-centr IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN portador.nome IN FRAME f-main
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-liter.i Modalidade}
assign c-modalidade:label in frame {&FRAME-NAME} = trim(return-value).

{utp/ut-liter.i Pagamento_Centralizado}
assign portador.log-1:label in frame {&FRAME-NAME} = trim(return-value).

{utp/ut-liter.i Portador_usado_para_Pagamento_centralizado_?}
assign portador.log-1:help in frame {&FRAME-NAME} = trim(return-value).

{utp/ut-liter.i Cobranáa_Centralizada}
assign l-cob-centr:label in frame {&FRAME-NAME} = trim(return-value).

{utp/ut-liter.i Portador_usado_para_Cobranáa_centralizada_?}
assign l-cob-centr:help in frame {&FRAME-NAME} = trim(return-value).

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
  {src/adm/template/row-list.i "portador"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "portador"}

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
  Purpose: Override standard ADM method
  Notes..:       
------------------------------------------------------------------------------*/

    {include/i-valid.i}
    
    run pi-validate.
    if return-value = "NOK" then 
       return 'ADM-ERROR':U.
    
    assign l-cob-centr = input frame {&FRAME-NAME} l-cob-centr.
    
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    if  avail portador then do:
        &if defined(BF_FIN_COBRANCA_CENTR) &then
            assign portador.log-cobr-centr = input frame {&FRAME-NAME} l-cob-centr.
        &else 
            if input frame {&FRAME-NAME} l-cob-centr = yes then 
                assign portador.dec-1 = 1.
            else 
                assign portador.dec-1 = 0.
        &endif
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
  Purpose: Override standard ADM method
  Notes..:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if  avail portador then do with frame {&frame-name}:
      assign c-modalidade:screen-value = {adinc/i03ad209.i 04 portador.modalidade}.

      &if defined(BF_FIN_COBRANCA_CENTR) &then
          assign l-cob-centr:screen-value in frame {&FRAME-NAME} = string(portador.log-cobr-centr).
      &else 
          if  portador.dec-1 = 1 then 
              assign l-cob-centr:screen-value in frame {&FRAME-NAME} = "yes".
          else 
              assign l-cob-centr:screen-value in frame {&FRAME-NAME} = "no".
      &endif
  end.
  else do:
      assign c-modalidade:screen-value = {adinc/i03ad209.i 04 1}.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
    Purpose: Override standard ADM method
    Notes..:       
------------------------------------------------------------------------------*/
    
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    if adm-new-record = yes then
    &if  defined(ADM-MODIFY-FIELDS) &then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
        enable l-cob-centr with frame {&frame-name}.
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

   find param-cr 
       where param-cr.ep-codigo = i-ep-codigo-usuario no-lock no-error.
   
   &if defined(BF_FIN_COBRANCA_CENTR) &then 
      if avail param-cr 
      and param-cr.log-cob-centr = no then
          assign l-cobr-centr = no.
   &else 
      if avail param-cr 
      and param-cr.log-2 = no then
         assign l-cobr-centr = no.
   &endif 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
  Purpose...: Validar a viewer 
  Parameters: <none>
  Notes.....: N∆o fazer assign aqui. Nesta procedure devem ser colocadas apenas 
              validaá‰es, pois neste ponto do programa o registro ainda n∆o foi 
              criado.
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} 
    
    if  avail portador then do:
        if  portador.log-1 <> input frame {&FRAME-NAME} portador.log-1 then do:
            find first mov-ap no-lock
                 where mov-ap.ep-codigo = i-ep-codigo-usuario
                 and   mov-ap.portador  = portador.cod-portador no-error.
            
            if  avail mov-ap then do:
                {utp/ut-liter.i Contas_a_Pagar * R}
                run utp/ut-msgs.p (input "show":U, 
                                   input 16822, 
                                   input string(portador.cod-portador) + "~~" +
                                         trim(return-value)).
                apply 'entry' to portador.log-1 in frame {&FRAME-NAME}.
                return 'NOK':U.
            end.
        end.

        &if defined(BF_FIN_COBRANCA_CENTR) &then 
        /* vers∆o >= 2.03 */
            assign l-cob-centr-aux = portador.log-cobr-centr.
        &else 
        /* vers∆o < 2.03 */
            if portador.dec-1 = 1 then 
                assign l-cob-centr-aux = yes.
            else
                assign l-cob-centr-aux = no.
        &endif
        if  l-cob-centr-aux <> input frame {&FRAME-NAME} l-cob-centr then do:
            find first mov-tit no-lock 
                 where mov-tit.ep-codigo = i-ep-codigo-usuario 
                 and   mov-tit.cod-portador  = portador.cod-portador no-error.
            
            if  avail mov-tit then do:
                {utp/ut-liter.i Contas_a_Receber * R}
                run utp/ut-msgs.p (input "show":U, 
                                   input 16822, 
                                   input string(portador.cod-portador) + "~~" +
                                         trim(return-value)).
                apply 'entry' to l-cob-centr in frame {&FRAME-NAME}.
                return 'NOK':U.
            end.
        end.
    end.
    
    return "OK".
    
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
  {src/adm/template/snd-list.i "portador"}

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


