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
{include/i-prgvrs.i V14AD057 2.00.00.008}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V14AD057 MUT}
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

def new global shared var v-row-parent as rowid no-undo.                                

def buffer b-cta-corrente for cta-corrente.

def var c-formato-agencia as char format "x(8)"  no-undo.
def var c-formato-conta   as char format "x(20)" no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cta-corrente
&Scoped-define FIRST-EXTERNAL-TABLE cta-corrente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cta-corrente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cta-corrente.agencia-extrato ~
cta-corrente.conta-corren-extr 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}agencia-extrato ~{&FP2}agencia-extrato ~{&FP3}~
 ~{&FP1}conta-corren-extr ~{&FP2}conta-corren-extr ~{&FP3}
&Scoped-define ENABLED-TABLES cta-corrente
&Scoped-define FIRST-ENABLED-TABLE cta-corrente
&Scoped-Define DISPLAYED-FIELDS cta-corrente.agencia-extrato ~
cta-corrente.conta-corren-extr 

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

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cta-corrente.agencia-extrato AT ROW 1.88 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     cta-corrente.conta-corren-extr AT ROW 2.88 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.cta-corrente
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
         HEIGHT             = 3.96
         WIDTH              = 69.86.
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cta-corrente.agencia-extrato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.agencia-extrato V-table-Win
ON ENTRY OF cta-corrente.agencia-extrato IN FRAME f-main /* Agància Extrato */
DO:
  run pi-valida-formato (input "agencia").    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.agencia-extrato V-table-Win
ON LEAVE OF cta-corrente.agencia-extrato IN FRAME f-main /* Agància Extrato */
DO:

  assign c-formato-agencia = input frame {&FRAME-NAME} cta-corrente.agencia-extrato no-error.
  if  ERROR-STATUS:ERROR then do:
      assign cta-corrente.agencia-extrato:format in frame {&FRAME-NAME} = "x(8)".
  end.
  else do:
      apply 'entry':U to cta-corrente.agencia-extrato in frame {&FRAME-NAME}.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cta-corrente.conta-corren-extr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-corren-extr V-table-Win
ON ENTRY OF cta-corrente.conta-corren-extr IN FRAME f-main /* Cta Corrente Extrato */
DO:
  run pi-valida-formato (input "conta corrente").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-corren-extr V-table-Win
ON LEAVE OF cta-corrente.conta-corren-extr IN FRAME f-main /* Cta Corrente Extrato */
DO:

  assign c-formato-conta = input frame {&FRAME-NAME} cta-corrente.conta-corren-extr no-error.
  if  ERROR-STATUS:ERROR then do:
      assign cta-corrente.conta-corren-extr:format in frame {&FRAME-NAME} = "x(20)".
  end.
  else do:
      apply 'entry':U to cta-corrente.conta-corren-extr in frame {&FRAME-NAME}.
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
  {src/adm/template/row-list.i "cta-corrente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cta-corrente"}

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

                 
  {include/i-valid.i}

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
    if i-pais-impto-usuario = 1 then do:
    assign cta-corrente.agencia-extrato = cta-corrente.agencia-extrato +
           fill (" ", length(cta-corrente.agencia-extrato:format in frame {&frame-name}) - 1 - length(cta-corrente.agencia-extrato)) 
           cta-corrente.conta-corren-extr = cta-corrente.conta-corren-extr +
           fill (" ", length(cta-corrente.conta-corren-extr:format in frame {&frame-name}) - 1 - length(cta-corrente.conta-corren-extr)).
  end.
  assign cta-corrente.agencia-extrato:format in frame {&FRAME-NAME}   = "x(8)"
         cta-corrente.conta-corren-extr:format in frame {&FRAME-NAME} = "x(20)".

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

  run pi-valida-formato (input "agencia").
  run pi-valida-formato (input "conta corrente").
    
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

  run pi-valida-formato ("agencia").
  run pi-valida-formato ("conta corrente").

  
  if avail cta-corrente then
      disp cta-corrente.agencia-extrato
           cta-corrente.conta-corren-extr with frame {&frame-name}.
      
   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-formato V-table-Win 
PROCEDURE pi-valida-formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param c-campo as char.

case c-campo:
   when "agencia" then do:
      if i-pais-impto-usuario = 1 then 
         assign cta-corrente.agencia-extrato:format in frame {&FRAME-NAME}   = "999999-X".
      else 
         assign cta-corrente.agencia-extrato:format in frame {&FRAME-NAME}   = "x(8)".
   end.
   when "conta corrente" then do:
      if i-pais-impto-usuario = 1 then 
         assign cta-corrente.conta-corren-extr:format in frame {&FRAME-NAME} = "9999999999-XX".
      else 
         assign cta-corrente.conta-corren-extr:format in frame {&FRAME-NAME} = "x(20)".
   end.
end.

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
    
    run pi-valida-formato (input "agencia").
    assign c-formato-agencia = input frame {&FRAME-NAME} cta-corrente.agencia-extrato   no-error.

    if  ERROR-STATUS:ERROR then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",
                           input 15539, 
                           input "").
        apply 'entry' to cta-corrente.agencia-extrato in frame {&frame-name}.
        return "adm-error":U.                   
    end.   

    run pi-valida-formato (input "conta corrente").
    assign c-formato-conta   = input frame {&FRAME-NAME} cta-corrente.conta-corren-extr no-error.
    
    if  ERROR-STATUS:ERROR then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",
                           input 15539, 
                           input "").
        apply 'entry' to cta-corrente.conta-corren-extr in frame {&frame-name}.
        return "adm-error":U.                   
    end.   
        
    /* Conta de extrado &1 j† cadastrada para a agància &2 
       numa outra conta corrente. */
                
    if  (input frame {&FRAME-NAME} mgadm.cta-corrente.agencia-extrato   <> "") or
        (input frame {&FRAME-NAME} mgadm.cta-corrente.conta-corren-extr <> "") then do:

        run get-attribute ('adm-new-record').
        if  return-value = 'yes' then do:
            find first b-cta-corrente
                 where b-cta-corrente.agencia-extrato   = input frame {&FRAME-NAME} mgadm.cta-corrente.agencia-extrato
                 and   b-cta-corrente.conta-corren-extr = input frame {&FRAME-NAME} mgadm.cta-corrente.conta-corren-extr
                 no-error.
        end.
        else do:
            find first b-cta-corrente
                 where b-cta-corrente.agencia-extrato   = input frame {&FRAME-NAME} mgadm.cta-corrente.agencia-extrato
                 and   b-cta-corrente.conta-corren-extr = input frame {&FRAME-NAME} mgadm.cta-corrente.conta-corren-extr
                 and   rowid(b-cta-corrente)           <> rowid(cta-corrente)
                 no-error.
        end.
                    
        if  avail b-cta-corrente then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show":U, 
                               input 9034, 
                               input string(input frame {&FRAME-NAME} mgadm.cta-corrente.conta-corren-extr) + "~~" +
                                     string(input frame {&FRAME-NAME} mgadm.cta-corrente.agencia-extrato)).
            apply 'entry' to mgadm.cta-corrente.agencia-extrato in frame {&FRAME-NAME}.
            return 'ADM-ERROR':U.
        end.
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
  {src/adm/template/snd-list.i "cta-corrente"}

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


