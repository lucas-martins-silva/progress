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
{include/i-prgvrs.i V01IN245 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN245 MUT}
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
def new global shared var gr-natur-oper as rowid no-undo. 
def var wh-viewer as widget-handle no-undo.
def var wh-viewer-cont as widget-handle no-undo.


/**********Multiplanta************/

def var i-tipo-movto as integer no-undo.
def var l-modifica   as logical no-undo.  
{cdp/cd7300.i1}
{cdp/cdapi204.i}

/************Fim******************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES natur-oper
&Scoped-define FIRST-EXTERNAL-TABLE natur-oper


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR natur-oper.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS natur-oper.denominacao natur-oper.tipo 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}denominacao ~{&FP2}denominacao ~{&FP3}
&Scoped-define ENABLED-TABLES natur-oper
&Scoped-define FIRST-ENABLED-TABLE natur-oper
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS natur-oper.nat-operacao ~
natur-oper.denominacao natur-oper.tipo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS natur-oper.nat-operacao 
&Scoped-define ADM-ASSIGN-FIELDS natur-oper.denominacao natur-oper.tipo 

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
DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     natur-oper.nat-operacao AT ROW 1.25 COL 24.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     natur-oper.denominacao AT ROW 2.25 COL 24.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 36.43 BY .88
     natur-oper.tipo AT ROW 1.13 COL 74 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Entrada", 1,
"Sa°da", 2,
"Serviáo", 3
          SIZE 11 BY 1.83
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.natur-oper
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
         HEIGHT             = 2.46
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN natur-oper.denominacao IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN natur-oper.nat-operacao IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR RADIO-SET natur-oper.tipo IN FRAME f-main
   2                                                                    */
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

&Scoped-define SELF-NAME natur-oper.nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-operacao V-table-Win
ON LEAVE OF natur-oper.nat-operacao IN FRAME f-main /* Nat Operaá∆o */
DO:
   {cdp/cd9998.i}

  if  replace(replace(self:screen-value,".",""),"-","") = "" then do:
      {utp/ut-table.i mgind natur-oper 1}
      run utp/ut-msgs.p (input "show",
                         input 773,
                         input return-value).
     /* apply 'entry' to natur-oper.nat-operacao.  */
      return 'adm-error'.
      assign natur-oper.tipo:screen-value = "1".  
      return no-apply.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.tipo V-table-Win
ON VALUE-CHANGED OF natur-oper.tipo IN FRAME f-main /* Tp Nat Op */
DO:

  run notify in this-procedure ("pi-habilita-campo,group-assign-target").

 /* run new-state (input "disable-campos":u).  */
  
  run get-attribute ('v02in245').
  assign wh-viewer-cont = widget-handle(return-value).
  if valid-handle(wh-viewer-cont) then do:  
     run pi-habilita-ind-cont in wh-viewer-cont.
           
 /*    if input frame {&frame-name} natur-oper.tipo = 1 then
 *         run pi-habilita-ind-cont in wh-viewer-cont (input no).
 *      else 
 *         run pi-habilita-ind-cont in wh-viewer-cont (input yes).
 */ 
  end. 
    
   run pi-habilita-duplic in wh-viewer-cont (input natur-oper.tipo:screen-value in frame {&frame-name}).
 
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
  {src/adm/template/row-list.i "natur-oper"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "natur-oper"}

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
  /* Ponha aqui a validaá∆o de chave duplicada */
  
  /* Code placed here will execute PRIOR to standard behavior. */
  
  {include/i-valid.i}  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
   
  /* Code placed here will execute AFTER standard behavior.    */
  
  /***************Multiplanta*************/
  
   assign c-transacao = "DIS003".
  {cdp/cd7300.i5 "001" c-transacao}
  
  if natur-oper.nat-operacao:sensitive in frame {&frame-name} = yes
     then assign i-tipo-movto = 1.
     else assign i-tipo-movto = 2.
  
  run pi-cria-tt-dados (input i-tipo-movto).
  
  {cdp/cd7300.i6 "001" c-transacao}
  find first tt-dados-env exclusive-lock no-error.
  if  avail tt-dados-env then
      delete tt-dados-env.
  
  /*************Fim-Multiplanta************/
  
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  assign natur-oper.tipo:screen-value in frame {&frame-name} = "1".
  
  if session:set-wait-state("general") then.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  
  if session:set-wait-state("") then.
  
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  
  /* a pi-trata-tipo habilita ou n∆o o campo tipo numa modificaá∆o.
     foi colocada aqui pq a enable-fields acabava sempre habilitando
     o campo, § respeitando a chamada da pi na state-changed... */
 
       if l-modifica = yes then do:
          run pi-trata-tipo.
          assign l-modifica = no.
       end.   

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
  
  if  avail natur-oper then 
      assign gr-natur-oper = rowid(natur-oper). 
 
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apply-tipo V-table-Win 
PROCEDURE pi-apply-tipo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  apply "value-changed" to natur-oper.tipo in frame {&frame-name}. 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Esta procedure Ç espec°fica do MULTIPLANTA.      
------------------------------------------------------------------------------*/

def input parameter i-tipo-movto as integer.

if  param-global.modulo-mp and
    tt-replica-msg.log-replica-msg  = yes then do:
    create tt-natur-oper-aux.
    buffer-copy natur-oper to tt-natur-oper-aux.
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 10
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = natur-oper.nat-operacao.
    raw-transfer tt-natur-oper-aux to tt-dados-env.conteudo-msg.                                     
    assign i-seq = i-seq + 1.                                     
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-tipo V-table-Win 
PROCEDURE pi-trata-tipo :
/*------------------------------------------------------------------------------
  Purpose: Impossibilita a alteraá∆o do campo TIPO qdo a natureza possuir
           ped-venda, ped-item, nota-fiscal ou it-nota-fisc.
  Notes:   Chamado no enable-fields dependendo do parametro l-modifica,
           q/ por sua vez Ç setado no state-changed.  
------------------------------------------------------------------------------*/

  find first ped-venda    where ped-venda.nat-operacao    = natur-oper.nat-operacao no-lock no-error.
  find first ped-item     where ped-item.nat-operacao     = natur-oper.nat-operacao no-lock no-error.
  find first nota-fiscal  where nota-fiscal.nat-operacao  = natur-oper.nat-operacao no-lock no-error.
  find first it-nota-fisc where it-nota-fisc.nat-operacao = natur-oper.nat-operacao no-lock no-error.
  
  if avail ped-venda
  or avail ped-item
  or avail nota-fiscal
  or avail it-nota-fisc then do:
     disable natur-oper.tipo with frame {&frame-name}.
     apply "value-changed" to natur-oper.tipo in frame {&frame-name}. 
        /* o comando acima valida o i-tipo p/ q/ a v02in245 
           reconheáa o tipo numa modificaá∆o  */        
  end.    
  else 
     enable  natur-oper.tipo with frame {&frame-name}.

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
  
 /* if  not frame {&frame-name}:validate() then
 *       return 'ADM-ERROR':U.*/

   if  natur-oper.nat-operacao:sensitive in frame {&frame-name} = yes
  and can-find (natur-oper where natur-oper.nat-operacao = 
                input frame {&frame-name} natur-oper.nat-operacao) then do:
      {include/i-vldprg.i}    
      {utp/ut-table.i mgind natur-oper 1}
      run utp/ut-msgs.p (input "show",
                         input 1,
                         input return-value).
      apply 'entry' to natur-oper.nat-operacao.                   
      return 'adm-error'.
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
  {src/adm/template/snd-list.i "natur-oper"}

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
 
  assign l-modifica = no.
 
  if p-state = "update-begin" then   /* = Modificaá∆o  */
     assign l-modifica = yes.
         /* O l-modifica faz executar a pi-trata-tipo no enable-fields. Essa pi foi
            colocada l† pq o enable Ç executado depois do update-begin. Se fosse 
            deixada a pi aqui, o enable iria desfazer a l¢gica da pi.            */
          
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


