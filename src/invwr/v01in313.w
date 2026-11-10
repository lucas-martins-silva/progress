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
{include/i-prgvrs.i V01IN313 2.00.00.021}  /*** 010021 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN313 MUT}
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
def new global shared var gr-pl-mest   as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var h-v02in313    as handle no-undo.
def var c-lista-tipo  as char.

def buffer b-pl-mest for pl-mest.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES pl-mest
&Scoped-define FIRST-EXTERNAL-TABLE pl-mest


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pl-mest.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS pl-mest.descricao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}descricao ~{&FP2}descricao ~{&FP3}
&Scoped-define ENABLED-TABLES pl-mest
&Scoped-define FIRST-ENABLED-TABLE pl-mest
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS pl-mest.cd-plano pl-mest.descricao 
&Scoped-Define DISPLAYED-OBJECTS c-estado cb-tipo-plano c-situacao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS pl-mest.cd-plano 
&Scoped-define ADM-MODIFY-FIELDS pl-mest.descricao cb-tipo-plano 

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
DEFINE VARIABLE cb-tipo-plano AS CHARACTER FORMAT "X(30)":U 
     LABEL "Tipo Plano" 
     VIEW-AS COMBO-BOX INNER-LINES 5
/*      LIST-ITEMS "","" */
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE c-estado AS CHARACTER FORMAT "X(30)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 21.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(15)":U 
     LABEL "Situa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     pl-mest.cd-plano AT ROW 1.17 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     pl-mest.descricao AT ROW 2.67 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 35 BY .88
     c-estado AT ROW 2.67 COL 64 COLON-ALIGNED
     cb-tipo-plano AT ROW 3.67 COL 17 COLON-ALIGNED
     c-situacao AT ROW 3.79 COL 64 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.pl-mest
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
         HEIGHT             = 3.92
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
ASSIGN        FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-situacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tipo-plano IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN pl-mest.cd-plano IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN pl-mest.descricao IN FRAME f-main
   3                                                                    */
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

&Scoped-define SELF-NAME cb-tipo-plano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-plano V-table-Win
ON VALUE-CHANGED OF cb-tipo-plano IN FRAME f-main /* Tipo Plano */
DO:
  if {ininc/i03in313.i 06 cb-tipo-plano:screen-value} = 3 or 
     {ininc/i03in313.i 06 cb-tipo-plano:screen-value} = 4 then do :
     run utp/ut-msgs.p (input 'show',
                        input 8569,
                        input return-value).
     assign cb-tipo-plano:screen-value = cb-tipo-plano.
     return 'no-apply':U.
  end.

  run pi-recebe-valor in h-v02in313 (input 
                                    {ininc/i03in313.i 06 cb-tipo-plano:screen-value}). 

  assign cb-tipo-plano = cb-tipo-plano:screen-value.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
do with frame {&frame-name} :
   {utp/ut-field.i mgind pl-mest tipo-plano 1}  assign cb-tipo-plano:label = trim(return-value).
   {utp/ut-field.i mgind pl-mest estado 1}      assign c-estado:label      = trim(return-value).
   {utp/ut-field.i mgind pl-mest situacao 1}    assign c-situacao:label    = trim(return-value).
end.   

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
  {src/adm/template/row-list.i "pl-mest"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "pl-mest"}

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
 
 cb-tipo-plano:screen-value in frame {&frame-name} = {ininc/i03in313.i 04 1}.

 assign cb-tipo-plano = cb-tipo-plano:screen-value.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN utp/ut-liter.p (trim({ininc/i01in313.i 04 1}), "*", "").
  assign c-estado:screen-value   in frame {&frame-name} = RETURN-VALUE.
  RUN utp/ut-liter.p (trim({ininc/i05in313.i 04 2}), "*", "").
  ASSIGN c-situacao:screen-value in frame {&frame-name} = RETURN-VALUE.
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
  if not frame {&frame-name}:validate() then
     return 'ADM-ERROR':U.

  /*** Valida‡Æo de chave duplicada ***/
  if pl-mest.cd-plano:sensitive in frame {&frame-name} = yes 
  and can-find (b-pl-mest where
                b-pl-mest.cd-plano = input frame {&frame-name} pl-mest.cd-plano) then do:
     {utp/ut-table.i mgind pl-mest 1}
     run utp/ut-msgs.p (input 'show',
                        input 1,
                        input return-value).
     apply 'entry' to pl-mest.cd-plano in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  if ADM-NEW-RECORD = yes then do:
     assign v-row-parent = rowid(pl-mest).
     run pi-atualiza-pl-mest-tipo.
  end.

  /* Code placed here will execute AFTER standard behavior.    */
  do with frame {&frame-name}:
     assign pl-mest.tipo-plano   = {ininc/i03in313.i 06 cb-tipo-plano:screen-value}.
     if ADM-NEW-RECORD = yes then
         assign pl-mest.situacao     = 2. 
    /*alterado pois estava gravando 0 no campo para os idiomas ESP e ING*/
            
  end.

  do on error undo, leave:
     validate pl-mest.            
  end.

  if return-value  <> 'ok'
  and return-value <> "" then do:

     run pi-verifica-erro.
     undo, return 'adm-error':U.
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
  disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
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
   DEF VAR i-situacao LIKE pl-mest.situacao NO-UNDO.

  if avail pl-mest THEN DO:
      RUN utp/ut-liter.p (trim({ininc/i01in313.i 04 pl-mest.estado}), "*", "").
      ASSIGN c-estado   = RETURN-VALUE.
      IF pl-mest.situacao = 0 
      THEN ASSIGN i-situacao = 1.
      ELSE i-situacao = pl-mest.situacao.
      RUN utp/ut-liter.p (trim({ininc/i05in313.i 04 i-situacao}), "*", "").
      ASSIGN c-situacao = RETURN-VALUE.
  END.
  ELSE DO:
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
   DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
   ASSIGN cAuxTraducao001 = {ininc/i01in313.i 04 1}.
   run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                       INPUT "",
                       INPUT "").
   ASSIGN c-estado   = RETURN-VALUE.
&else
   ASSIGN c-estado   = {ininc/i01in313.i 04 1}.
&endif
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao002 = {ininc/i05in313.i 04 2}.
          run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                              INPUT "",
                              INPUT "").
          ASSIGN c-situacao = RETURN-VALUE.
      &else
          ASSIGN c-situacao = {ininc/i05in313.i 04 2}.
      &endif
  END.
/*   assign c-estado   = if avail pl-mest then {ininc/i01in313.i 04 pl-mest.estado}   */
/*                       else {ininc/i01in313.i 04 1}                                 */
/*          c-situacao = if avail pl-mest then {ininc/i05in313.i 04 pl-mest.situacao} */
/*                       else {ininc/i05in313.i 04 2}.                                */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  do with frame {&frame-name}:
     assign cb-tipo-plano = 
                 if avail pl-mest then {ininc/i03in313.i 04 pl-mest.tipo-plano}
                 else {ininc/i03in313.i 04 1}.
     display cb-tipo-plano.            
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

  apply "value-changed" to cb-tipo-plano in frame {&frame-name}.

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

  ASSIGN c-lista-tipo = {ininc/i03in313.i 03}.

  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      run utp/ut-lstit.p (input-output c-lista-tipo).
      assign cb-tipo-plano:LIST-ITEM-PAIRS in frame {&frame-name} = c-lista-tipo.
  &else
      assign cb-tipo-plano:list-items in frame {&frame-name} = c-lista-tipo.
  &endif
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Code placed here will execute AFTER standard behavior.    */
  if avail pl-mest then
     assign gr-pl-mest = rowid(pl-mest).

  run new-state('modifica|' + string(not avail pl-mest or pl-mest.estado = 1)).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-pl-mest-tipo V-table-Win 
PROCEDURE pi-atualiza-pl-mest-tipo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def var v-row-table as rowid  no-undo.

   assign v-row-parent = rowid(pl-mest).

   /*** Chama cadastro de tipos de periodos ***/
   /*** enviado para o browse b01in315.w no programa cd1120.w ***/
   run new-state ('periodo':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-handle V-table-Win 
PROCEDURE pi-envia-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-handle as handle no-undo.

assign h-v02in313 = p-handle.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-erro V-table-Win 
PROCEDURE pi-verifica-erro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   {cdp/cd1120.i}  /*** apresenta erros reportados pelo trigger de write ***/
    return 'ADM-ERROR':U.

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
  {src/adm/template/snd-list.i "pl-mest"}

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



