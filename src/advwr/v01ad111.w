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
{include/i-prgvrs.i V01AD111 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01AD111 MUT}
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
def var l-inclui as logical no-undo.
def var c-cep    as char    no-undo.
def var l-eh-alteracao as logical no-undo.

/* Miniflexibilizaá∆o */  
  {include/i_dbvers.i}

def buffer b-ext-agencia for ext-agencia.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ext-agencia
&Scoped-define FIRST-EXTERNAL-TABLE ext-agencia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ext-agencia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ext-agencia.cep-final 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cep-final ~{&FP2}cep-final ~{&FP3}
&Scoped-define ENABLED-TABLES ext-agencia
&Scoped-define FIRST-ENABLED-TABLE ext-agencia
&Scoped-Define ENABLED-OBJECTS rt-key rt-mod 
&Scoped-Define DISPLAYED-FIELDS ext-agencia.cod-banco ~
ext-agencia.cod-agencia ext-agencia.cep-inicial ext-agencia.cep-final ~
ext-agencia.sufixo 
&Scoped-Define DISPLAYED-OBJECTS c-nome-banco c-agencia 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS ext-agencia.cod-banco ~
ext-agencia.cod-agencia ext-agencia.cep-inicial 

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
DEFINE VARIABLE c-agencia AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-banco AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.

DEFINE RECTANGLE rt-mod
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ext-agencia.cod-banco AT ROW 1.17 COL 33.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-nome-banco AT ROW 1.17 COL 38.43 COLON-ALIGNED NO-LABEL
     ext-agencia.cod-agencia AT ROW 2.17 COL 33.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     c-agencia AT ROW 2.17 COL 44.14 COLON-ALIGNED NO-LABEL
     ext-agencia.cep-inicial AT ROW 3.17 COL 33.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     ext-agencia.cep-final AT ROW 4.67 COL 33.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     ext-agencia.sufixo AT ROW 5.67 COL 33.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.14 BY .88
     rt-key AT ROW 1 COL 1
     rt-mod AT ROW 4.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.ext-agencia
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
         HEIGHT             = 5.92
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

/* SETTINGS FOR FILL-IN c-agencia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-banco IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ext-agencia.cep-inicial IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN ext-agencia.cod-agencia IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN ext-agencia.cod-banco IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN ext-agencia.sufixo IN FRAME f-main
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

&Scoped-define SELF-NAME ext-agencia.cep-final
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ext-agencia.cep-final V-table-Win
ON LEAVE OF ext-agencia.cep-final IN FRAME f-main /* CEP Final */
DO:
  assign c-cep = input frame {&frame-name} ext-agencia.cep-final no-error.
  if ERROR-STATUS:ERROR then do:
     run utp/ut-msgs.p (input "show",
                        input 4334,
                        input "").
     return no-apply.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ext-agencia.cep-inicial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ext-agencia.cep-inicial V-table-Win
ON LEAVE OF ext-agencia.cep-inicial IN FRAME f-main /* CEP Inicial */
DO:
  assign c-cep = input frame {&frame-name} ext-agencia.cep-inicial no-error.
  if ERROR-STATUS:ERROR then do:
     run utp/ut-msgs.p (input "show",
                        input 4334,
                        input "").
     return no-apply.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ext-agencia.cod-agencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ext-agencia.cod-agencia V-table-Win
ON F5 OF ext-agencia.cod-agencia IN FRAME f-main /* Agància */
DO:
    if  search("adzoom/z01ad009.r") = ? and 
        search("adzoom/z01ad009.w") = ? then do:
        run utp/ut-msgs.p (input "show",
                           input 4,
                           input "adzoom/z01ad009.w").
        return.
    end.
    else do:
        assign l-implanta = yes.
        {include/zoomvar.i &prog-zoom="adzoom/z01ad009.w"
                           &campo=ext-agencia.cod-agencia
                           &campozoom=agencia}
    end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ext-agencia.cod-agencia V-table-Win
ON LEAVE OF ext-agencia.cod-agencia IN FRAME f-main /* Agància */
DO:
   find first agencia no-lock
        where agencia.cod-banco = input frame {&FRAME-NAME} ext-agencia.cod-banco
          and agencia.agencia   = input frame {&FRAME-NAME} ext-agencia.cod-agencia
        no-error.
   
   if  avail agencia then do:
              assign c-agencia:screen-value in frame {&FRAME-NAME} = agencia.nome
              ext-agencia.sufixo:screen-value in frame {&FRAME-NAME} = string(agencia.sufixo).
   end.
   else do:
       assign c-agencia:screen-value in frame {&FRAME-NAME} = "".
 /*             ext-agencia.sufixo:screen-value in frame {&FRAME-NAME} = "".*/
   end.
   
   
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ext-agencia.cod-agencia V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ext-agencia.cod-agencia IN FRAME f-main /* Agància */
DO:
    apply 'F5' to self.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ext-agencia.cod-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ext-agencia.cod-banco V-table-Win
ON F5 OF ext-agencia.cod-banco IN FRAME f-main /* Banco */
DO:
    if  search("adzoom/z01ad018.r") = ? and 
        search("adzoom/z01ad018.w") = ? then do:
        run utp/ut-msgs.p (input "show",
                           input 4,
                           input "adzoom/z01ad018.w").
        return.
    end.
    else do:
        assign l-implanta = yes.
        {include/zoomvar.i &prog-zoom="adzoom/z01ad018.w"
                           &campo=ext-agencia.cod-banco
                           &campozoom=cod-banco}
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ext-agencia.cod-banco V-table-Win
ON LEAVE OF ext-agencia.cod-banco IN FRAME f-main /* Banco */
DO:
   
   find first banco no-lock
        where banco.cod-banco = input frame {&FRAME-NAME} ext-agencia.cod-banco
        no-error.
   
   if  avail banco then do:
       assign c-nome-banco:screen-value in frame {&FRAME-NAME} = banco.nome-banco.
   end.
   else do:
       assign c-nome-banco:screen-value in frame {&FRAME-NAME} = "".
   end.   
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ext-agencia.cod-banco V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ext-agencia.cod-banco IN FRAME f-main /* Banco */
DO:
    apply 'F5' to self.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if ext-agencia.cod-banco:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if ext-agencia.cod-agencia:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "ext-agencia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ext-agencia"}

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

  run get-attribute('adm-new-record':U).
  if  return-value = "yes" then do:
      assign l-inclui = yes.
  end.
  else do:
      assign l-inclui = no.
  end.
  
  /*--- Valida Banco ---*/
  find first banco no-lock
       where banco.cod-banco = input frame {&FRAME-NAME} ext-agencia.cod-banco
       no-error.
  
  if  not avail banco then do:
      run utp/ut-msgs.p (input "Show",
                         input 230,
                         input "").
      apply 'entry':U to ext-agencia.cod-banco in frame {&FRAME-NAME}.
      return 'adm-error':U.
  end.

  /*---Valida agencia---*/

  find first agencia no-lock
         where agencia.cod-banco = input frame {&FRAME-NAME} ext-agencia.cod-banco AND 
               agencia.agencia = input frame {&FRAME-NAME} ext-agencia.cod-agencia
         no-error.

    if  not avail agencia then do:
        run utp/ut-msgs.p (input "Show",
                           input 41,
                           input "").
        apply 'entry':U to ext-agencia.cod-agencia in frame {&FRAME-NAME}.
        return 'adm-error':U.
    end.
       

 /*--- Vefifica se o CEP final n∆o Ç menor que o inicial ---*/
  if  input frame {&FRAME-NAME} ext-agencia.cep-final < 
      input frame {&FRAME-NAME} ext-agencia.cep-inicial then do:
      run utp/ut-msgs.p (input "Show",
                         input 485,
                         input "").
      apply 'entry':U to ext-agencia.cep-final in frame {&FRAME-NAME}.
      return 'adm-error':U.
  end.
  

  
  /*--- Verifica se j† existe o registro ---*/
  if  l-inclui = yes then do:
      &if "{&mgdis_version}" >= "2.02" &then
          find first b-ext-agencia no-lock
             where b-ext-agencia.cod-banco   = input frame {&FRAME-NAME} ext-agencia.cod-banco
             and   b-ext-agencia.cod-agencia = input frame {&FRAME-NAME} ext-agencia.cod-agencia
             and   b-ext-agencia.cep-inicial = input frame {&FRAME-NAME} ext-agencia.cep-inicial
             no-error.
      &else
          find first b-ext-agencia no-lock
               where b-ext-agencia.cod-banco   = input frame {&FRAME-NAME} ext-agencia.cod-banco
               and   b-ext-agencia.cod-agencia = input frame {&FRAME-NAME} ext-agencia.cod-agencia +
                                                 input frame {&frame-name} ext-agencia.cep-inicial
               no-error.
      &endif.

      if  avail b-ext-agencia then do:
          run utp/ut-msgs.p (input "Show",
                             input 3868,
                             input "").
          apply 'entry':U to ext-agencia.cod-banco in frame {&FRAME-NAME}.
          return 'adm-error':U.
      end.
  end.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  &if "{&mgdis_version}" < "2.02" &then
       assign ext-agencia.char-1      = input frame {&frame-name} ext-agencia.cod-agencia
              ext-agencia.cod-agencia = input frame {&frame-name} ext-agencia.cod-agencia +
                                        input frame {&frame-name} ext-agencia.cep-inicial.
  &endif.
  
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
   if  avail ext-agencia then do:
   
       find first banco no-lock
            where banco.cod-banco = ext-agencia.cod-banco no-error.
       
       if  avail banco then do:
           assign c-nome-banco:screen-value in frame {&FRAME-NAME} = banco.nome-banco.
       end.
       
       &if "{&mgdis_version}" < "2.02" &then
           find first agencia no-lock
                where agencia.cod-banco = ext-agencia.cod-banco
                and agencia.agencia     = ext-agencia.char-1 no-error.
                
           if ext-agencia.char-1 <> "" then     
              assign ext-agencia.cod-agencia:screen-value in frame {&frame-name} = ext-agencia.char-1.
                
       &else        
           find first agencia no-lock
                where agencia.cod-banco   = ext-agencia.cod-banco
                and   agencia.agencia = ext-agencia.cod-agencia
                no-error.
       &endif.         
   
   
          if  avail agencia then do:
          assign c-agencia:screen-value in frame {&FRAME-NAME} = agencia.nome.
       end.
    
   end.
   
   find first param-global no-lock no-error.
   if  avail param-global then do:
       assign ext-agencia.cep-inicial:format in frame {&FRAME-NAME} = param-global.formato-cep
              ext-agencia.cep-final:format   in frame {&FRAME-NAME} = param-global.formato-cep.
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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 
  run get-attribute('adm-new-record':U).

  if  return-value <> "yes" then do:
      &if "{&mgdis_version}" >= "2.02" &then
          assign ext-agencia.cep-inicial:sensitive in frame {&FRAME-NAME} = no.
      &else
          assign ext-agencia.cep-inicial:sensitive in frame {&FRAME-NAME} = yes.
     &endif.
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
  {include/i-vldfrm.i} /* Validaá∆o
   de dicion†rio */
   
   /*Segue um exemplo de validaá∆o de programa 
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
  {src/adm/template/snd-list.i "ext-agencia"}

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


