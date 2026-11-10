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
{include/i-prgvrs.i V01IN281 2.00.00.013 } /*** "010013" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN281 MUT}
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

/* Defini‡Æo de Temp-Table Local                                        */
DEF TEMP-TABLE tt-faixa
    FIELD inicio LIKE param-cp.prim-ord-man
    FIELD fim    LIKE param-cp.ult-ord-man.

/* Local Variable Definitions ---                                       */
DEF VAR i-anterior LIKE param-cp.prim-ord-man.
DEF VAR l-erro     AS   logical.

def var l-numer-unica  as logical no-undo.

def var hDBOParamMi    as handle  no-undo.

{cdp/cd9043.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-cp
&Scoped-define FIRST-EXTERNAL-TABLE param-cp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-cp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-cp.prim-ord-man param-cp.ult-ord-man ~
param-cp.prim-ord-aut-cp param-cp.ult-ord-aut-cp param-cp.prox-ord-aut 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}prim-ord-man ~{&FP2}prim-ord-man ~{&FP3}~
 ~{&FP1}ult-ord-man ~{&FP2}ult-ord-man ~{&FP3}~
 ~{&FP1}prim-ord-aut-cp ~{&FP2}prim-ord-aut-cp ~{&FP3}~
 ~{&FP1}ult-ord-aut-cp ~{&FP2}ult-ord-aut-cp ~{&FP3}~
 ~{&FP1}prox-ord-aut ~{&FP2}prox-ord-aut ~{&FP3}
&Scoped-define ENABLED-TABLES param-cp
&Scoped-define FIRST-ENABLED-TABLE param-cp
&Scoped-Define ENABLED-OBJECTS RECT-35 
&Scoped-Define DISPLAYED-FIELDS param-cp.prim-ord-man param-cp.ult-ord-man ~
param-cp.prim-ord-aut-cp param-cp.ult-ord-aut-cp param-cp.prox-ord-aut 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS param-cp.prim-ord-man 

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
DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 8.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-cp.prim-ord-man AT ROW 2.04 COL 38.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     param-cp.ult-ord-man AT ROW 3.04 COL 38.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     param-cp.prim-ord-aut-cp AT ROW 4.04 COL 38.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     param-cp.ult-ord-aut-cp AT ROW 5.04 COL 38.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     param-cp.prox-ord-aut AT ROW 6.04 COL 38.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     RECT-35 AT ROW 1.21 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-cp
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
         HEIGHT             = 8.75
         WIDTH              = 84.29.
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

/* SETTINGS FOR FILL-IN param-cp.prim-ord-man IN FRAME f-main
   1                                                                    */
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
  {src/adm/template/row-list.i "param-cp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-cp"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

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

  /* COLOCAR TODOS ASSIGNS DE TABELA .. DEPOIS DO RUN DISPATCH */

  valida-ordens:
  do transaction:
      /* Dispatch standard ADM method.                             */
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
      if RETURN-VALUE = 'ADM-ERROR':U then 
         RETURN 'ADM-ERROR':U.
    
      /* Code placed here will execute AFTER standard behavior.    */
      run pi-valida-ordens-frota in this-procedure.
      if return-value = "NOK":u  then do:
         undo, leave valida-ordens.
      end.
    
       ASSIGN param-cp.prim-ord-man    = INPUT FRAME {&frame-name} param-cp.prim-ord-man
             param-cp.ult-ord-man     = INPUT FRAME {&frame-name} param-cp.ult-ord-man
             param-cp.prim-ord-aut-cp = INPUT FRAME {&frame-name} param-cp.prim-ord-aut-cp
             param-cp.ult-ord-aut-cp  = INPUT FRAME {&frame-name} param-cp.ult-ord-aut-cp 
             param-cp.prox-ord-aut    = INPUT FRAME {&frame-name} param-cp.prox-ord-aut.
    
  end.
  if return-value = "NOK":U  then  return 'ADM-ERROR':U.

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
  ENABLE param-cp.prim-ord-man
         param-cp.ult-ord-man
         param-cp.prim-ord-aut-cp
         param-cp.ult-ord-aut-cp
         param-cp.prox-ord-aut
         WITH FRAME {&frame-name}.

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

    IF  (INPUT FRAME {&frame-name} param-cp.prim-ord-man) > (INPUT FRAME {&frame-name} param-cp.ult-ord-man) THEN DO:
        {include/i-vldprg.i}
        RUN utp/ut-msgs.p (input "show",
                           input 252,
                           input "").
        APPLY "entry" TO param-cp.prim-ord-man IN FRAME {&frame-name}.
        RETURN "adm-error".  
    END.

    IF  (INPUT FRAME {&frame-name} param-cp.prim-ord-aut-cp) > (INPUT FRAME {&frame-name} param-cp.ult-ord-aut-cp) THEN DO:
        {include/i-vldprg.i}
        RUN utp/ut-msgs.p (input "show",
                           input 252,
                           input "").
        APPLY "entry" TO param-cp.prim-ord-aut-cp IN FRAME {&frame-name}.
        RETURN "adm-error".                          
    END.

    IF  (INPUT FRAME {&frame-name} param-cp.prox-ord-aut) < (INPUT FRAME {&frame-name} param-cp.prim-ord-aut-cp)
    AND (INPUT FRAME {&frame-name} param-cp.prox-ord-aut) > (INPUT FRAME {&frame-name} param-cp.ult-ord-aut-cp) THEN DO:
        {include/i-vldprg.i}
        RUN utp/ut-msgs.p (input "show",
                           input 749,
                           input "").
        APPLY "entry" TO param-cp.prox-ord-aut IN FRAME {&frame-name}.
        RETURN "adm-error".
    END.


  /*****  Verifica a faixa das ordens manuais e autom ticas tanto para Produ‡Æo quanto para MI *****/

   CREATE tt-faixa.
   ASSIGN tt-faixa.inicio = INPUT FRAME {&frame-name} param-cp.prim-ord-man
          tt-faixa.fim    = INPUT FRAME {&frame-name} param-cp.ult-ord-man.

   CREATE tt-faixa.
   ASSIGN tt-faixa.inicio = INPUT FRAME {&frame-name} param-cp.prim-ord-aut-cp
          tt-faixa.fim    = INPUT FRAME {&frame-name} param-cp.ult-ord-aut-cp.


   find first param-global no-lock no-error.
   if  avail param-global then do:          
       if  param-global.modulo-mi = yes then do:

           IF NOT VALID-HANDLE(hDBOParamMi) THEN 
              run mnbo/bomn140.p persistent set hDBOParamMi.

           RUN openQueryStatic IN hDBOParamMi (INPUT "Default":U).
           run getFirst in hDBOParamMi.
           if return-value = "OK":U then do:     

              CREATE tt-faixa.
              run getIntField in hDBOParamMi (input "prim-ord-man-mi", output tt-faixa.inicio).
              run getIntField in hDBOParamMi (input "ult-ord-man-mi", output tt-faixa.fim).

              CREATE tt-faixa.
              run getIntField in hDBOParamMi (input "prim-ord-aut-mi", output tt-faixa.inicio).
              run getIntField in hDBOParamMi (input "ult-ord-aut-mi", output tt-faixa.fim).

              run getLogField in hDBOParamMi (input "numer-unica", output l-numer-unica).
              if l-numer-unica then do:
                 CREATE tt-faixa.
                 run getIntField in hDBOParamMi (input "prim-sol-serv", output tt-faixa.inicio).
                 run getIntField in hDBOParamMi (input "ult-sol-serv", output tt-faixa.fim).
              end.          
           end.   
       end.

       if  param-global.modulo-pi = yes then do:

           IF NOT VALID-HANDLE(hDBOParamMi) THEN 
              run mnbo/bomn140.p persistent set hDBOParamMi.

           RUN openQueryStatic IN hDBOParamMi (INPUT "Default":U).
           run getFirst in hDBOParamMi.
           if return-value = "OK":U then do: 
              CREATE tt-faixa.
              run getIntField in hDBOParamMi (input "prim-ord-plan", output tt-faixa.inicio).
              run getIntField in hDBOParamMi (input "ult-ord-plan" , output tt-faixa.fim).
           end.   
       end.

       IF VALID-HANDLE(hDBOParamMi) THEN
           DELETE PROCEDURE hDBOParamMi.

   end.

   ASSIGN i-anterior = 0
          l-erro     = no.

   FOR EACH tt-faixa BREAK BY tt-faixa.inicio:
       IF  tt-faixa.fim > i-anterior AND tt-faixa.inicio > i-anterior THEN DO:
           ASSIGN i-anterior = tt-faixa.fim. 
       END. /* if tt-faixa.fim ... */ 
       ELSE DO:
           ASSIGN l-erro = yes. 
       END. /* else do */
   END. /* for each tt-faixa ... */                                                          

   FOR EACH tt-faixa:
       DELETE tt-faixa. 
   END. /* for each tt-faixa */
   
   IF c-nom-prog-upc-mg97 <> "" THEN DO:
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "AFTER-VALIDA-FAIXA", 
                                        INPUT "VIEWER",
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME {&FRAME-NAME}:HANDLE,
                                        INPUT "param-cp",
                                        INPUT ROWID(param-cp)).
        IF RETURN-VALUE = "NAO-VALIDA":U THEN
            ASSIGN l-erro = NO.
   end.

   IF  l-erro = yes THEN DO:
       RUN utp/ut-msgs.p (input "show",
                          input 4336,
                          input "").
       APPLY "entry" TO param-cp.prim-ord-man IN FRAME {&frame-name}.
       RETURN "adm-error".  
   END. /* if  l-erro ... */    

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
  {src/adm/template/snd-list.i "param-cp"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ordens-frota V-table-Win 
PROCEDURE pi-valida-ordens-frota :

    define variable hMvapi003 as handle  no-undo.
    define variable iErro     as integer no-undo.

    /* Verifica se Sistema de Manuten‡Æo de Frota Est  Implantado */
    run cdp/cd9902.p(3).
    if return-value = "OK":U then do:
        /** Roda API de valida‡Æo de faixas persistente **/
        run mvp\mvapi003.p persistent set hMvapi003 (input "":U,
                                                     input 0).
        for each RowErrors:
            delete RowErrors.
        end.

        /** Passa as faixas **/
        run buscafaixas in hMvapi003.
    
        /** Valida‡Æo das faixas de Ordens do EMS **/
        run validaFaixas in hMvapi003.
        /** Se ocorreu erro **/
        if return-value = "NOK":U then do:
            /** Busca os erros **/
            run getRowErrors in hMvapi003 (output table RowErrors).
            /** Busca £ltimo erro criado na BO **/
            /** Percorre os erros da API **/
            for first RowErrors where RowErrors.errorType <> "INTERNAL":U no-lock:
                RUN utp/ut-msgs.p (input "show",
                                   input RowErrors.errorNumber,
                                   input RowErrors.errorParameter).
            end.

        end.
    
        /** Elimina programa da mem¢ria **/
        delete procedure hMvapi003.
    
        if can-find(first RowErrors where RowErrors.errorType <> "INTERNAL":U) then return "NOK":U.
     end.
   return "OK":U.

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

