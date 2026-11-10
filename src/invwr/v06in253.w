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
{include/i-prgvrs.i V06IN253 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V06IN253 MUT}
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
&scoped-define ENABLED-TABLES op-altern

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def new global shared var gr-op-altern as rowid no-undo. 
def new global shared var v-row-parent as rowid no-undo.


def buffer b-op-altern for op-altern.
def var i-un-med-tempo as integer no-undo.
def var rw-parent as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES op-altern
&Scoped-define FIRST-EXTERNAL-TABLE op-altern


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR op-altern.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS operacao.op-codigo operacao.descricao ~
op-altern.op-altern 
&Scoped-Define DISPLAYED-OBJECTS c-codigo c-descricao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */
&Scoped-define ADM-CREATE-FIELDS op-altern.op-altern 

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
DEFINE VARIABLE c-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "":R5 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-codigo AT ROW 1.17 COL 22 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-descricao AT ROW 1.17 COL 39.86 COLON-ALIGNED NO-LABEL
     operacao.op-codigo AT ROW 2.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     operacao.descricao AT ROW 2.17 COL 29.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 36.29 BY .88
     op-altern.op-altern AT ROW 3.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.op-altern
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
         HEIGHT             = 3.25
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-codigo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN operacao.descricao IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN op-altern.op-altern IN FRAME F-Main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN operacao.op-codigo IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
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
  {src/adm/template/row-list.i "op-altern"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "op-altern"}

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
  HIDE FRAME F-Main.
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
    
  /* Inicializa sequencia da operacao conforme o intervalo de variacao de */
  /* operacoes na tabela de parametros de engenharia                      */
  find last param-en no-lock no-error.
  if not avail param-en then do:
     run utp/ut-msgs.p (input 'show',
                        input 7597,
                        input '').
     return 'adm-error':U.
  end.
  
 display c-codigo c-descricao with frame {&frame-name}.
  
  find operacao where rowid(operacao) = v-row-parent no-lock.
  find last b-op-altern 
       where b-op-altern.num-id-operacao = operacao.num-id-operacao 
       no-lock no-error.
  if avail b-op-altern then
     assign op-altern.op-altern:screen-value in frame {&frame-name} = string(b-op-altern.op-altern + param-en.num-var-operacao).
  else 
     assign op-altern.op-altern:screen-value in frame {&frame-name} = string(param-en.num-var-operacao).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   
  /* Ponha aqui a valida‡Æo de chave duplicada */
  /* {include/i-valid.i} /*** Valida‡Æo do dicion rio ***/ */
  
  /* Code placed here will execute PRIOR to standard behavior. */
  
  /*** Valida‡Æo Chave Duplicada ***/
  find operacao where rowid(operacao) = v-row-parent no-lock no-error.

  if op-altern.op-altern:sensitive in frame {&frame-name} = yes
  and can-find(b-op-altern 
      where b-op-altern.num-id-operacao = operacao.num-id-operacao
      and   b-op-altern.op-altern       = input frame {&frame-name} op-altern.op-altern) then do:
     {utp/ut-table.i mgind op-altern 1}
     run utp/ut-msgs.p (input "show",
                        input 1,
                        input return-value).
     apply "entry" to op-altern.op-altern in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

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

  /* Code placed here will execute AFTER standard behavior.    */
  
  IF ADM-NEW-RECORD then do with frame {&frame-name} on error undo, return 'ADM-ERROR':
     assign {&ADM-CREATE-FIELDS}.
     if ERROR-STATUS:ERROR then run DISPATCH in THIS-PROCEDURE ('SHOW-ERRORS':U).
  end.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  if avail operacao then 
     assign op-altern.num-id-operacao = operacao.num-id-operacao.

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

  find operacao where rowid(operacao) = v-row-parent no-lock no-error.
  if not avail operacao then do:
    {utp/ut-table.i mgind operacao 1}
    run utp/ut-msgs.p (input "show",
                       input 56,
                       input return-value).
    return "adm-error":U.
  end.      
                  
  assign rw-parent = v-row-parent.
  
  if operacao.cod-roteiro <> '' then do:
     {utp/ut-field.i mgind rot-fabric cod-roteiro 1}
     find rot-fabric where rot-fabric.cod-roteiro = operacao.cod-roteiro no-lock no-error.
     assign c-codigo    = operacao.cod-roteiro
            c-descricao = if avail rot-fabric then rot-fabric.descricao else "":U
            c-codigo:label in frame {&frame-name} = return-value.
  end.
  else do:
     {utp/ut-field.i mgind operacao it-codigo 1}
     find item where item.it-codigo = operacao.it-codigo no-lock no-error.
     assign c-codigo    = operacao.it-codigo
            c-descricao = if avail item then item.desc-item else "":U
            c-codigo:label in frame {&frame-name} = return-value.
  end.   
  
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
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-troca V-table-Win 
PROCEDURE pi-verifica-troca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def var h-handle         as handle.
  def var h-v01in253       as handle.
  def var i-oper-pad       like oper-pad.nr-oper-pad.

  RUN Who-Is-The-Container IN adm-broker-hdl
      (INPUT this-procedure,
       OUTPUT h-handle).    

  run pi-retorna-handle in h-handle(output h-v01in253).    
        
  run pi-retorna-campo in h-v01in253(output i-oper-pad).
  
  def var c-param1         as char    no-undo.
  def var c-param2         as char    no-undo.
  def var l-copia-oper-pad as logical no-undo.

  assign l-copia-oper-pad = no.
  find oper-pad where oper-pad.nr-oper-pad = i-oper-pad no-lock no-error.
  
  if avail oper-pad then 
     assign l-copia-oper-pad = (adm-new-record = yes or op-altern.nr-oper-pad <> oper-pad.nr-oper-pad).

  if  return-value <> 'adm-error':U  and
      l-copia-oper-pad = yes then do:
  
      if adm-new-record = no then do:
         {utp/ut-table.i mgind op-altern 1}
         assign c-param1 = return-value + " " + string(op-altern.op-altern).
         {utp/ut-table.i mgind oper-pad 1}
         assign c-param2 = return-value + " " + string(oper-pad.nr-oper-pad).
         run utp/ut-msgs.p (input "show",
                            input 1499,
                            input c-param1 + "~~" + c-param2).

      end.
       
      if return-value = "no" then
         return "NOK":U.
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
  {src/adm/template/snd-list.i "op-altern"}

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


