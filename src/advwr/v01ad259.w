&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V01AD259 2.00.00.017}  /*** 030017 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01AD259 MUT}
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

def new global shared var gr-tipo-rec-desp as rowid no-undo.

def var v-row-parent as rowid  no-undo.
def var c-handle     as handle no-undo.

/*************Multiplanta********************/

def var i-tipo-movto     as integer            no-undo.
def var l-cria           as logical initial no no-undo.
def var teste            as char               no-undo.
def var c-retencao       as char               no-undo.
def var c-lista-retencao as char               no-undo.
def var i-cod-tipo       as integer            no-undo.

def buffer b-tp-rec-des for tipo-rec-desp.

/******  BANCOS HIST‡RICOS ******/
/* temp-table tt-tabela */
{bhp/bh9999.i1} 

{cdp/cd1000.i}
/********************************/


{cdp/cd7300.i1}
{cdp/cdapi234.i}
{cdp/cdapi015.i}

/************Fim*****************************/

{cdp/cdcfgfin.i} /* Definiá∆o de Funá‰es */
{include/i-freeac.i}
/*-------------- Integraá∆o Magnus I.01 x EMS 2.04 -------------*/
def var i-ind-tipo-movto as inte no-undo.

{cdp/cd0920i1.i} /* Definiá∆o da temp-table tt-tipo-rec-desp-mg */
{cdp/cd0001i1.i} /* Definiá∆o da temp-table de erros tt-erro-mg */
/****************************************************************/

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
&Scoped-define EXTERNAL-TABLES tipo-rec-desp
&Scoped-define FIRST-EXTERNAL-TABLE tipo-rec-desp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR tipo-rec-desp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tipo-rec-desp.tipo tipo-rec-desp.descricao 
&Scoped-define ENABLED-TABLES tipo-rec-desp
&Scoped-define FIRST-ENABLED-TABLE tipo-rec-desp
&Scoped-define DISPLAYED-TABLES tipo-rec-desp
&Scoped-define FIRST-DISPLAYED-TABLE tipo-rec-desp
&Scoped-Define ENABLED-OBJECTS RECT-27 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS tipo-rec-desp.tp-codigo tipo-rec-desp.tipo ~
tipo-rec-desp.descricao 
&Scoped-Define DISPLAYED-OBJECTS c-text-1 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS tipo-rec-desp.tp-codigo 
&Scoped-define ADM-ASSIGN-FIELDS tipo-rec-desp.tp-codigo 

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
DEFINE VARIABLE c-text-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 5.14 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 16.57 BY 2.17.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 1.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 3.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-text-1 AT ROW 3 COL 65.86 COLON-ALIGNED NO-LABEL
     tipo-rec-desp.tp-codigo AT ROW 1.5 COL 29.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     tipo-rec-desp.tipo AT ROW 3.67 COL 69 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Receita", 1,
"Despesa", 2
          SIZE 13.14 BY 1.5
     tipo-rec-desp.descricao AT ROW 3 COL 29.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.14 BY .88
     RECT-27 AT ROW 3.33 COL 66.72
     rt-key AT ROW 1.17 COL 1
     rt-mold AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.tipo-rec-desp
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
         HEIGHT             = 5
         WIDTH              = 84.
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

/* SETTINGS FOR FILL-IN c-text-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tipo-rec-desp.tp-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
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


  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  {btb/btb008za.i0} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */

  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "tipo-rec-desp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "tipo-rec-desp"}

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
   {utp/ut-rtlbl.i mgadm tipo-rec-desp tipo c-text-1}


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

    DO WITH FRAME {&FRAME-NAME}:
        if  adm-new-record then do:
            find first b-tp-rec-des no-lock
                 where b-tp-rec-des.tp-codigo = input frame {&FRAME-NAME} tipo-rec-desp.tp-codigo no-error.
            if  avail b-tp-rec-des then do:
                {utp/ut-liter.i Tipo Receita/Despesa}
                run utp/ut-msgs.p (input "show",
                                   input 11,
                                   input trim(return-value)).
                APPLY "ENTRY" TO tipo-rec-desp.tp-codigo IN FRAME {&FRAME-NAME}.
                RETURN "ADM-ERROR":U.
            end.
        END.           
    END.     

    for each tt-rec-desp exclusive-lock:
        delete tt-rec-desp.
    end.

    for each tt-param-rec-desp exclusive-lock:
        delete tt-param-rec-desp.
    end.

    create tt-param-rec-desp.
    assign tt-param-rec-desp.c-usuario        = c-seg-usuario
           tt-param-rec-desp.l-vid-rel        = yes
           tt-param-rec-desp.cod-versao-integ = 002.

    create tt-rec-desp.
    assign tt-rec-desp.tt-tp-codigo     = input frame {&frame-name} tipo-rec-desp.tp-codigo
           tt-rec-desp.tt-descricao     = input frame {&frame-name} tipo-rec-desp.descricao
           tt-rec-desp.tt-tipo          = input frame {&frame-name} tipo-rec-desp.tipo.

    if  adm-new-record    = YES
    and adm-adding-record = NO then 
        assign tt-rec-desp.i-opcao = 3.
    else
        assign tt-rec-desp.i-opcao = 1.

    run cdp/cdapi015.p (input  table tt-param-rec-desp,
                        input  table tt-rec-desp,
                        output table tt-erro-rec-desp).

    /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */
    find first tipo-rec-desp
         where tipo-rec-desp.tp-codigo = input frame {&frame-name} tipo-rec-desp.tp-codigo
         exclusive-lock no-error.
    if  avail tipo-rec-desp then do:
       {cdp/cd0002i1.i tipo-rec-desp} 
    end.
    /************************************************/

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

    /*Existe relacionamento com a tabela emitente*/
     if tipo-rec-desp.tipo = 1 then do:  /*cliente/receita*/
         find first emitente where emitente.tp-rec-padrao = tipo-rec-desp.tp-codigo no-lock no-error.
         if avail emitente then do:
             run utp/ut-msgs.p (input "show", 
                                input 29568, 
                                input "").
             return "adm-error":U.
         end.
     end.

     if tipo-rec-desp.tipo = 2 then do: /*fornecedor/despesa*/
         find first emitente where emitente.tp-desp-padrao = tipo-rec-desp.tp-codigo no-lock no-error.
         if avail emitente then do:
             run utp/ut-msgs.p (input "show", 
                                input 29568, 
                                input "").
             return "adm-error":U.
         end.
     end.

    /********** BANCOS HIST‡RICOS ***********/
     if  not available(param-global) then
         find first param-global no-lock no-error.

     if  l-funcao-banc-hist-adm then do:
         {bhp/bh9999.i 1 tipo-rec-desp tipo-rec-desp.tp-codigo '' '' '' '' ''}
         if  return-value <> "OK" then 
             return "ADM-ERROR".
     end.

     /* Dispatch standard ADM method.                             */
     find first dupli-apagar no-lock
          where dupli-apagar.tp-despesa = input frame {&frame-name} tipo-rec-desp.tp-codigo no-error.

     if avail dupli-apagar then do:
        run utp/ut-msgs.p (input "show",
                           input 19159,
                           input "").        
        apply 'entry':U to tipo-rec-desp.tp-codigo in frame {&frame-name}.
        return "adm-error".
     end.   

     for each tt-rec-desp exclusive-lock:
         delete tt-rec-desp.
     end.

     for each tt-param-rec-desp exclusive-lock:
         delete tt-param-rec-desp.
     end.

    create tt-param-rec-desp.
    assign tt-param-rec-desp.c-usuario        = c-seg-usuario
           tt-param-rec-desp.l-vid-rel        = yes
           tt-param-rec-desp.cod-versao-integ = 002.

    create tt-rec-desp.
    assign tt-rec-desp.tt-tp-codigo = input frame {&frame-name} tipo-rec-desp.tp-codigo
           tt-rec-desp.tt-tipo      = input frame {&FRAME-NAME} tipo-rec-desp.tipo
           tt-rec-desp.i-opcao      = 2.


   {cdp/cd0002i1.i1 tipo-rec-desp "no"} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */


    run cdp/cdapi015.p (input  table tt-param-rec-desp,
                        input  table tt-rec-desp,
                        output table tt-erro-rec-desp).
    if return-value = 'ADM-ERROR':U then 
       return 'ADM-ERROR':U.

   {cdp/cd0002i1.i1 tipo-rec-desp "yes"} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */


    run dispatch in c-handle (input 'open-query':U). 


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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

   {utp/ut-rtlbl.i mgadm tipo-rec-desp tipo c-text-1}


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

  if adm-new-record = yes then
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  assign tipo-rec-desp.tipo:sensitive in frame {&frame-name} = yes.

  if  adm-new-record = no then do:
      find first demon-cb
         where demon-cb.tp-codigo = input frame {&frame-name} tipo-rec-desp.tp-codigo
         no-lock no-error.
      if  avail demon-cb then do:      
          assign tipo-rec-desp.tipo:sensitive in frame {&frame-name} = no.
          run utp/ut-msgs.p (input "show",
                             input 17041,
                             input "").
          apply 'entry' to tipo-rec-desp.descricao.
      end.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

   {utp/ut-field.i mgadm tipo-rec-desp tipo }
    assign c-text-1:screen-value in frame {&frame-name} = return-value.

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
  if avail tipo-rec-desp then
   assign gr-tipo-rec-desp = rowid(tipo-rec-desp).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-rpc-mg V-table-Win 
PROCEDURE pi-atualiza-rpc-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Nome da Tabela; Nome do Programa no Magnus I.01
  Notes:       O programa cd0920i1.p Ç executado no Magnus via RPC.
------------------------------------------------------------------------------*/

    {cdp/cd0003i1.i tipo-rec-desp cdp/cd0920i1.p}
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-tipo-rec-desp-mg V-table-Win 
PROCEDURE pi-cria-tt-tipo-rec-desp-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-ind-tipo-movto as int no-undo.
    def input param p-atualiza       as log no-undo.

    for each tt-tipo-rec-desp-mg:
        delete tt-tipo-rec-desp-mg.
    end.

    create tt-tipo-rec-desp-mg.
    assign tt-tipo-rec-desp-mg.ind-tipo-movto    = p-ind-tipo-movto
           tt-tipo-rec-desp-mg.l-atualiza        = p-atualiza.

    /* Campos Iguais */
    assign tt-tipo-rec-desp-mg.tp-codigo   = tipo-rec-desp.tp-codigo
           tt-tipo-rec-desp-mg.descricao   = fn-free-accent(tipo-rec-desp.descricao)
           tt-tipo-rec-desp-mg.operacional = tipo-rec-desp.operacional.

    if tipo-rec-desp.tipo = 1 then assign tt-tipo-rec-desp-mg.tipo = yes. /* Receita */
    if tipo-rec-desp.tipo = 2 then assign tt-tipo-rec-desp-mg.tipo = no.  /* Despesa */

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-log-mg V-table-Win 
PROCEDURE pi-gera-log-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Nome do Programa; Nome da Tabela; Valor da Chave Prim†ria;
               Tipo de Movimento (Inclui, Modifica, Elimina); Mensagem da tt-erros-mg
  Notes:       
------------------------------------------------------------------------------*/

    {cdp/cd0004i1.i "CD0920" "TIPO-REC-DESP" tipo-rec-desp.tp-codigo tt-tipo-rec-desp-mg.ind-tipo-movto tt-erros-mg.help-msg}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-hand V-table-Win 
PROCEDURE pi-recebe-hand :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param c-hand2 as handle no-undo.

    assign c-handle = c-hand2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-tipo-rec-desp-mg V-table-Win 
PROCEDURE pi-valida-tipo-rec-desp-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input-output param p-ind-tipo-movto as int no-undo.

    return "OK":U.

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
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

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
  {src/adm/template/snd-list.i "tipo-rec-desp"}

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

