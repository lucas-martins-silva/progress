&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
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
{include/i-prgvrs.i V15IN176 2.00.00.028}  /*** 010028 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V15IN176 MUT}
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
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
 
    def var v-row-parent        as rowid    no-undo.
    def var c-nat-operacao      as char     no-undo.
    def var l-pede-cab-item     as logical  no-undo.
    def var h_principal         as handle   no-undo.
    def var h_b03in367          as handle   no-undo.
    def var h_v16in176          as handle   no-undo.
    def var h_v17in176          as handle   no-undo.
    def var h_v18in176          as handle   no-undo.
    def var l-ok                as logical  no-undo.
    def var l-novo-reg          as logical  no-undo.
    def var de-tot              like rat-lote.quantidade no-undo.
 
    def new global shared var gr-docum-est    as rowid   no-undo.
    def new global shared var i-programa-re   as integer no-undo.
    def new global shared var gr-item-doc-est as rowid   no-undo.

    /**
    ***  Recebimento   1 - Normal
    ***                2 - F°sico
    ***                3 - Internacional
    **/
 
    def buffer b-item-doc-est for item-doc-est.
 
    {rep/re9800.i}
    {cdp/cdcfgmat.i}
    
    def new global shared var l-material-agregado as logical no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item-doc-est
&Scoped-define FIRST-EXTERNAL-TABLE item-doc-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-doc-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-doc-est.sequencia item-doc-est.it-codigo ~
item-doc-est.cod-refer 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}sequencia ~{&FP2}sequencia ~{&FP3}~
 ~{&FP1}it-codigo ~{&FP2}it-codigo ~{&FP3}~
 ~{&FP1}cod-refer ~{&FP2}cod-refer ~{&FP3}
&Scoped-define ENABLED-TABLES item-doc-est
&Scoped-define FIRST-ENABLED-TABLE item-doc-est
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS item-doc-est.sequencia ~
item-doc-est.it-codigo item-doc-est.cod-refer 
&Scoped-Define DISPLAYED-OBJECTS c-desc-it-codigo fi-item-do-forn 

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
DEFINE VARIABLE c-desc-it-codigo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item-do-forn AS CHARACTER FORMAT "X(20)" 
     LABEL "Item Fornecedor":R18 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-doc-est.sequencia AT ROW 1.33 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     item-doc-est.it-codigo AT ROW 2.33 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-it-codigo AT ROW 2.33 COL 35 COLON-ALIGNED NO-LABEL
     fi-item-do-forn AT ROW 3.33 COL 17.29 COLON-ALIGNED
     item-doc-est.cod-refer AT ROW 3.33 COL 74.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.item-doc-est
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
         HEIGHT             = 3.5
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

/* SETTINGS FOR FILL-IN c-desc-it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-item-do-forn IN FRAME f-main
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

&Scoped-define SELF-NAME item-doc-est.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.cod-refer V-table-Win
ON F5 OF item-doc-est.cod-refer IN FRAME f-main /* Referància */
DO:
 
    {include/zoomvar.i &prog-zoom=inzoom/z02in377.w
                       &campo=item-doc-est.cod-refer
                       &campozoom=cod-refer}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.cod-refer V-table-Win
ON LEAVE OF item-doc-est.cod-refer IN FRAME f-main /* Referància */
DO:
    find referencia 
        where referencia.cod-refer = input frame {&frame-name} item-doc-est.cod-refer
        no-lock no-error.
    if not available referencia then do:
        /* mensagem: Referencia n∆o cadastrada */
        {utp/ut-field.i mgind item-doc-est cod-refer 01}
        run utp/ut-msgs.p (input "show",input 47,input return-value).
        apply 'entry' to item-doc-est.cod-refer in frame {&frame-name} .
        return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-doc-est.cod-refer IN FRAME f-main /* Referància */
DO:
            apply "F5" to self.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-item-do-forn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-item-do-forn V-table-Win
ON F5 OF fi-item-do-forn IN FRAME f-main /* Item Fornecedor */
DO:
 
    {include/zoomvar.i &prog-zoom=inzoom/z01in178.w
                       &campo=fi-item-do-forn
                       &campozoom=item-do-forn}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-item-do-forn V-table-Win
ON LEAVE OF fi-item-do-forn IN FRAME f-main /* Item Fornecedor */
DO:
    if input frame {&frame-name} fi-item-do-forn <> "" then do:
        find first item-fornec 
             where item-fornec.cod-emitente = docum-est.cod-emitente
               and item-fornec.item-do-forn = input frame {&frame-name} fi-item-do-forn
                   no-lock no-error.
 
        if  not available item-fornec then do:
            {utp/ut-table.i mgind item-fornec 1}
            run utp/ut-msgs.p (input "show",input 2,input return-value).
            apply "entry" to fi-item-do-forn in frame {&frame-name}.
            return no-apply.
        end.
        assign item-doc-est.it-codigo:screen-value in frame {&FRAME-NAME} = item-fornec.it-codigo.
    end.        
    else         
        assign item-doc-est.it-codigo:screen-value in frame {&FRAME-NAME} = "".
 
    find item 
        where item.it-codigo = input frame {&frame-name} item-doc-est.it-codigo
        no-lock no-error.
    if  not available item then do:
        run utp/ut-msgs.p (input "show",input 166,input return-value).
        apply "entry" to fi-item-do-forn in frame {&frame-name}.
        return no-apply.
    end.
    assign c-desc-it-codigo:screen-value in frame {&FRAME-NAME} = item.desc-item.
 
    run pi-passa-item ( input input frame {&frame-name} item-doc-est.sequencia,
                        input input frame {&frame-name} item-doc-est.it-codigo ).
 
    disable fi-item-do-forn with frame {&frame-name}.
 
    run pi-cod-refer.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-item-do-forn V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-item-do-forn IN FRAME f-main /* Item Fornecedor */
DO:
            apply "F5" to self.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.it-codigo V-table-Win
ON F5 OF item-doc-est.it-codigo IN FRAME f-main /* Item */
DO:
 
    {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                       &campo=item-doc-est.it-codigo
                       &campozoom=it-codigo}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.it-codigo V-table-Win
ON LEAVE OF item-doc-est.it-codigo IN FRAME f-main /* Item */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=c-desc-it-codigo
                     &where="item.it-codigo = input frame {&frame-name}
                             item-doc-est.it-codigo"}

    find item 
        where item.it-codigo = input frame {&frame-name} item-doc-est.it-codigo
        no-lock no-error.
    if  not available item then do:
        run utp/ut-msgs.p (input "show",input 166,input return-value).
        apply "entry" to item-doc-est.it-codigo in frame {&frame-name}.
        return no-apply.
    end.
    find first item-fornec 
         where item-fornec.cod-emitente = docum-est.cod-emitente
           and item-fornec.it-codigo    = input frame {&frame-name} item-doc-est.it-codigo
               no-lock no-error.
    if avail item-fornec then 
        assign fi-item-do-forn:screen-value in frame {&FRAME-NAME} = item-fornec.item-do-forn.

    run pi-passa-item ( input input frame {&frame-name} item-doc-est.sequencia,
                        input input frame {&frame-name} item-doc-est.it-codigo ).

    disable item-doc-est.it-codigo with frame {&frame-name}.

    run pi-cod-refer.

    if item-doc-est.cod-refer:sensitive in frame {&frame-name} = yes then do:
       apply "entry" to item-doc-est.cod-refer in frame {&frame-name}.
       return no-apply.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-doc-est.it-codigo IN FRAME f-main /* Item */
DO:
          apply "F5" to self.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.sequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.sequencia V-table-Win
ON LEAVE OF item-doc-est.sequencia IN FRAME f-main /* Seq */
DO:
 
 
  disable item-doc-est.sequencia with frame {&frame-name}.
 
 
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
 
  if item-doc-est.it-codigo:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .
  if fi-item-do-forn:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .
  if item-doc-est.cod-refer:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .

    {utp/ut-field.i mgind item-fornec item-do-forn 1}
    assign fi-item-do-forn:label in frame {&frame-name} = trim(return-value).

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
  {src/adm/template/row-list.i "item-doc-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-doc-est"}

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
 
  find param-re
      where param-re.usuario = docum-est.usuario no-lock no-error.
       
  find last b-item-doc-est 
      where b-item-doc-est.cod-emitente = docum-est.cod-emitente 
        and b-item-doc-est.nro-docto    = docum-est.nro-docto    
        and b-item-doc-est.serie-docto  = docum-est.serie-docto  
        and b-item-doc-est.nat-operacao = c-nat-operacao 
      no-lock no-error.

  if  available b-item-doc-est then
      assign item-doc-est.sequencia:screen-value in frame {&frame-name} = 
             string(b-item-doc-est.sequencia + param-re.inc-seq).
  else
      assign item-doc-est.sequencia:screen-value in frame {&frame-name} = 
             string(param-re.seq-item-um).

  run pi-passa-item ( input input frame {&frame-name} item-doc-est.sequencia,
                      input input frame {&frame-name} item-doc-est.it-codigo ).
 
  run pi-habilita-refer ( no ).
 
  if  docum-est.mod-atual = 1         /* Nota Material Agregado */
  and not param-re.pede-it-agreg then /* N∆o Pede Item Agregado */
  do:
      find item 
         where item.it-codigo = input frame {&frame-name} item-doc-est.it-codigo
         no-lock no-error.
    
      if  avail item then
          assign c-desc-it-codigo:screen-value in frame {&frame-name} = item.desc-item.
  end.        
    
  if  valid-handle(h_b03in367) then
      run pi-novo-registro in h_b03in367 (input yes).
        
 
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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
      return 'ADM-ERROR':U.
 
    assign item-doc-est.cod-emitente = docum-est.cod-emitente
           item-doc-est.nro-docto    = docum-est.nro-docto
           item-doc-est.serie-docto  = docum-est.serie-docto
           item-doc-est.nat-operacao = docum-est.nat-operacao.
 
    assign item-doc-est.nat-operacao = c-nat-operacao.           
 
    for each rat-lote {cdp/cd8900.i rat-lote item-doc-est }
         and rat-lote.sequencia = item-doc-est.sequencia exclusive-lock:
 
        if  rat-lote.int-2 = 3 then 
            delete rat-lote.
        else 
            assign rat-lote.int-2 = 0
                   rat-lote.dec-2 = 0.
    end.                   

    /* Grava o primeiro deposito informado para o item */   
    find first rat-lote {cdp/cd8900.i rat-lote item-doc-est}
          and rat-lote.it-codigo = item-doc-est.it-codigo
          and rat-lote.sequencia = item-doc-est.sequencia
          no-lock no-error.
 
    if  avail rat-lote then
        assign item-doc-est.cod-depos    = rat-lote.cod-depos
               item-doc-est.cod-localiz  = rat-lote.cod-localiz
               item-doc-est.lote         = rat-lote.lote
               item-doc-est.dt-vali-lote = rat-lote.dt-vali-lote. 
 
    /** Monta temp-table saldo estoque no browse de estoque.  
    **/
    if valid-handle(h_b03in367) then do:
        if adm-new-record = no then 
            run pi-novo-registro in h_b03in367 (input no).
    end.
    if valid-handle(h_principal) then
       run pi-altera-reg in h_principal.

    find first param-estoq no-lock no-error.
 
 
    if  substring(param-estoq.char-2,2,1) = "@" 
    and ( can-find(funcao where funcao.cd-funcao = "adm-apb-ems-5.00"
                            and funcao.ativo = yes
                            and funcao.log-1 = yes) 
    or    can-find(funcao where funcao.cd-funcao = "adm-cfl-ems-5.00"
                            and funcao.ativo = yes  
                            and funcao.log-1 = yes)  )
    and  not l-devolucao
    and  not natur-oper.terceiros  then do:
 
         run cdp/cd9760.p ( input 3,   /* Item-doc-est */
                           input item-doc-est.it-codigo,
                           input rowid(item-doc-est) ).

    end. 
 
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
  for each rat-lote {cdp/cd8900.i rat-lote docum-est} 
       and rat-lote.sequencia = input frame {&frame-name} item-doc-est.sequencia:
 
      if  rat-lote.int-2 = 1
      or  adm-new-record  then do:        /* Inclusao */
          delete rat-lote.
          next.
      end.
      else 
      if  rat-lote.int-2 = 2 then 
          assign rat-lote.quantidade = rat-lote.dec-2.
 
      assign rat-lote.int-2 = 0 
             rat-lote.dec-2 = 0.        
  end.
 
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .
 
    assign l-novo-reg = no.
 
    /** Habilita/Desabilita browse de estoque.  
    **/
    if valid-handle(h_b03in367) then do:
        run pi-novo-registro in h_b03in367 (input no).
        run pi-habilita-sal-re in h_b03in367 (input no).
    end.
 
 
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
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  if valid-handle(h_principal) then 
     run pi-altera-reg in h_principal.
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
 
    assign l-novo-reg = no.
 
    /** Habilita/Desabilita browse de estoque.  
    **/
    if valid-handle(h_b03in367) then
        run pi-habilita-sal-re in h_b03in367 (input no).
 disable fi-item-do-forn with frame {&frame-name}.
 
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
 
    if  available item-doc-est and available docum-est then do:
        find item where 
            item.it-codigo = item-doc-est.it-codigo
            no-lock no-error.
     
        if available item then
            assign c-desc-it-codigo:screen-value in frame {&frame-name} =
                                    item.desc-item.
        else
            assign c-desc-it-codigo:screen-value in frame {&frame-name} = "".
 
        find item-fornec where
            item-fornec.it-codigo    = item-doc-est.it-codigo and
            item-fornec.cod-emitente = docum-est.cod-emitente 
            no-lock no-error.
     
        if available item-fornec then
            assign fi-item-do-forn:screen-value in frame {&frame-name} =
                                   item-fornec.item-do-forn.
        else
            assign fi-item-do-forn:screen-value in frame {&frame-name} = "".

        if  valid-handle(h_b03in367) then do:
            run pi-passa-item in h_b03in367 
                ( input item-doc-est.sequencia,
                  input item-doc-est.it-codigo ).
                 
            run pi-habilita-sal-re in h_b03in367 (input no).
        end.         
 
        assign gr-item-doc-est = rowid(item-doc-est).
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
    /* Dispatch standard ADM method.                             */
 
    if  valid-handle(h_principal) then
        run pi-primeira-pagina in h_principal.
 
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
 
    /* Code placed here will execute AFTER standard behavior.    */
 
    assign l-novo-reg = yes.
  
    if  i-programa-re = 1 then
        run pi-recebimento.
    else
        if  i-programa-re = 2 then
            run pi-fisico.
        else
            run pi-internacional.
 
    disable item-doc-est.sequencia
            item-doc-est.it-codigo
            fi-item-do-forn 
            item-doc-est.cod-refer with frame {&frame-name}.    
 
    if  l-pede-cab-item then do:
        if  param-re.pd-seq then
            enable item-doc-est.sequencia with frame {&frame-name}.
 
        if  not l-material-agregado 
        or  param-re.pede-it-agreg  then do:
            if  param-re.cod-ent-item = 1 then /* Pede o nosso item */
                enable item-doc-est.it-codigo with frame {&frame-name}.
            else /* Pede o item do fornecedor */
                enable fi-item-do-forn with frame {&frame-name}.
        end.            
    end.                    
 
    if  l-material-agregado 
    and not param-re.pede-it-agreg then 
    do:
        if  adm-new-record then do:
            find item where item.it-codigo = "":U no-lock no-error.
            assign c-desc-it-codigo:screen-value in frame {&frame-name} = item.desc-item.
        end.
    end.
 
    /** Habilita/Desabilita browse de estoque.   **/
    if  valid-handle(h_b03in367) then do:
        run pi-habilita-sal-re in h_b03in367 ( if  not adm-new-record 
                                               and not item-doc-est.baixa-ce 
                                               then no
                                               else yes ).

        run pi-novo-registro in h_b03in367 ( no ).
    end.

    if  adm-new-record then do:
        &if  defined(ADM-MODIFY-FIELDS) &then do:
             enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
        &endif
        run pi-passa-item ( 0, "" ).
    end.
    else 
        if  avail item-doc-est then do:
            for each rat-lote {cdp/cd8900.i rat-lote item-doc-est}
                 and rat-lote.sequencia = item-doc-est.sequencia exclusive-lock:
 
                 assign rat-lote.int-2 = 0
                        rat-lote.dec-2 = rat-lote.quantidade.
             end.
             run pi-passa-item ( item-doc-est.sequencia, item-doc-est.it-codigo ).
        end.                 

    /* Recebimento F°sico */
    if  avail docum-est 
    and docum-est.rec-fisico then
        disable item-doc-est.cod-refer with frame {&frame-name}.
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    def var de-tot-unid as decimal  no-undo.
    
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    /* Unidade de Neg¢cio */
    &if  defined(bf_mat_unidade_negocio) &then
    
        if  substring(param-estoq.char-2,2,1) = "@" 
        and ( can-find(funcao where funcao.cd-funcao = "adm-apb-ems-5.00"
                                and funcao.ativo = yes
                                and funcao.log-1 = yes) 
        or    can-find(funcao where funcao.cd-funcao = "adm-cfl-ems-5.00"
                                and funcao.ativo = yes  
                                and funcao.log-1 = yes)  )
        and  connected("emsuni")
        and  connected("emsbas") 
        and  not l-devolucao
        and  not natur-oper.terceiros  then do:
    
             assign de-tot-unid = 0.
    
             for each unid-neg-nota
                  where unid-neg-nota.cod-emitente = item-doc-est.cod-emitente
                    and unid-neg-nota.serie-docto  = item-doc-est.serie-docto
                    and unid-neg-nota.nro-docto    = item-doc-est.nro-docto
                    and unid-neg-nota.nat-operacao = item-doc-est.nat-operacao 
                    and unid-neg-nota.sequencia    = item-doc-est.sequencia no-lock:
                    
                    assign de-tot-unid = de-tot-unid + unid-neg-nota.perc-unid-neg.
             end.
             if  de-tot-unid <> 100 then 
                 run cdp/cd9765.w ( input rowid(item-doc-est) ).
        end.
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

    {utp/ut-field.i mgind item-fornec item-do-forn 1}
    assign fi-item-do-forn:label in frame {&frame-name} = trim(return-value).
 
    find docum-est 
        where rowid(docum-est) = gr-docum-est no-lock no-error.

    if  avail docum-est then do:
        find emitente 
            where emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.

        find natur-oper 
            where natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.
    end.        
 
    find param-re 
        where param-re.usuario = c-seg-usuario no-lock no-error.        
 
    find first param-global no-lock no-error.
    find first param-compra no-lock no-error.        
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-reset-record V-table-Win 
PROCEDURE local-reset-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'reset-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    if valid-handle(h_b03in367) then do:
        run pi-novo-registro in h_b03in367 (input no).
        run pi-habilita-sal-re in h_b03in367 (input no).
    end.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cod-refer V-table-Win 
PROCEDURE pi-cod-refer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    find item 
        where item.it-codigo = input frame {&frame-name} item-doc-est.it-codigo
        no-lock no-error.
 
    if  (avail item and item.tipo-con-est = 4) 
    and  not docum-est.rec-fisico then do:
         enable item-doc-est.cod-refer with frame {&frame-name}.
         apply "entry" to item-doc-est.cod-refer in frame {&frame-name}.
         return "adm-error".
    end.
    else
        disable item-doc-est.cod-refer with frame {&frame-name}.
        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fisico V-table-Win 
PROCEDURE pi-fisico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-refer V-table-Win 
PROCEDURE pi-habilita-refer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input param l-habilita as logical no-undo.

  if  l-habilita 
  and avail item 
  and item.tipo-con-est = 4 
  and not docum-est.rec-fisico 
  then 
      assign item-doc-est.cod-refer:sensitive in frame {&frame-name} = yes.
  else 
      assign item-doc-est.cod-refer:sensitive in frame {&frame-name} = no.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-internacional V-table-Win 
PROCEDURE pi-internacional :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if adm-new-record then
      assign l-pede-cab-item = yes.
  else
      assign l-pede-cab-item = no.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-item-cc V-table-Win 
PROCEDURE pi-item-cc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-it-codigo     like item-doc-est.it-codigo no-undo.
 
    if  not l-material-agregado then 
        assign item-doc-est.it-codigo:screen-value in frame {&frame-name} = p-it-codigo.
 
    apply "leave" to item-doc-est.it-codigo in frame {&FRAME-NAME}.
 
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
 
    def input parameter p-handle-1 as handle.
    def input parameter p-handle-2 as handle.
    def input parameter p-handle-3 as handle.
    def input parameter p-handle-4 as handle.
    def input parameter p-handle-5 as handle.
 
    assign h_principal = p-handle-1
           h_b03in367  = p-handle-2
           h_v16in176  = p-handle-3
           h_v17in176  = p-handle-4
           h_v18in176  = p-handle-5.
           
    if valid-handle(h_b03in367) then do:
       run pi-passa-handle in h_b03in367 (input this-procedure).
       run pi-novo-registro in h_b03in367 (input no).
       run pi-habilita-sal-re in h_b03in367 (input no).
    end.       
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-item V-table-Win 
PROCEDURE pi-passa-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-sequencia     like item-doc-est.sequencia no-undo.
    def input parameter p-it-codigo     like item-doc-est.it-codigo no-undo.
 
    /* Browse Estoque */
    if valid-handle(h_b03in367) then
       run pi-passa-item in h_b03in367 ( p-sequencia,
                                         p-it-codigo ).

    /* Ordem de Compra / Produá∆o */
    if valid-handle(h_v16in176) then
       run pi-passa-item in h_v16in176 ( p-sequencia,
                                         p-it-codigo).
 
    /* Quantidade e Valores */
    if valid-handle(h_v17in176) then
       run pi-passa-item in h_v17in176 ( p-sequencia,
                                         p-it-codigo ).

    /* Impostos */
    if valid-handle(h_v18in176) then
       run pi-passa-item in h_v18in176 ( p-sequencia,
                                         p-it-codigo ).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-rateio V-table-Win 
PROCEDURE pi-passa-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    def input parameter p-it-codigo    as char no-undo.
    def input parameter p-item-do-forn as char no-undo.
 
    assign item-doc-est.it-codigo:screen-value in frame {&frame-name} = 
        p-it-codigo.
    assign fi-item-do-forn:screen-value in frame {&frame-name} = 
        p-item-do-forn.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define output parameter c-item like item-doc-est.it-codigo.
assign c-item = input frame {&FRAME-NAME} item-doc-est.it-codigo.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebimento V-table-Win 
PROCEDURE pi-recebimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    run pi-seta-flags-observacao (docum-est.cod-observa, 
                                  docum-est.nat-operacao).
 
    assign c-nat-operacao       = docum-est.nat-operacao.
 
    if  adm-new-record and docum-est.rec-fisico = no then
        assign l-pede-cab-item = yes.
    else
        assign l-pede-cab-item = no.          
 
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
def var l-baixa-ce as log no-undo.
def var c-formato as char no-undo.
 
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
 
    find item 
        where item.it-codigo = input frame {&frame-name} item-doc-est.it-codigo
        no-lock no-error.
 
    if  adm-new-record then do:
        find b-item-doc-est 
            where b-item-doc-est.nro-docto    = docum-est.nro-docto    
              and b-item-doc-est.serie-docto  = docum-est.serie-docto  
              and b-item-doc-est.cod-emitente = docum-est.cod-emitente  
              and b-item-doc-est.nat-operacao = c-nat-operacao 
              and b-item-doc-est.sequencia    = input frame {&frame-name} item-doc-est.sequencia
             no-lock no-error.
        if  available b-item-doc-est then do:
            /* mensagem: Sequencia do item ja cadastrada */
            {include/i-vldprg.i}
            {utp/ut-field.i mgind item-doc-est sequencia 01}
            run utp/ut-msgs.p (input "show",input 24,input return-value).
            apply 'entry' to item-doc-est.sequencia in frame {&frame-name}.
            return 'adm-error':U.
        end.                
    end.
 
    if  not available item then do:
        /* mensagem: Item nao cadastrado */
        {include/i-vldprg.i}
        {utp/ut-field.i mgind item-doc-est it-codigo 01}
        run utp/ut-msgs.p (input "show",input 47,input return-value).
        apply 'entry' to item-doc-est.it-codigo in frame {&frame-name} .
        return 'adm-error':U.
    end.
    
    if  item.cod-obsol = 4 then do:
        /* Item esta Obsoleto */
        {include/i-vldprg.i}
        run utp/ut-msgs.p ( input "show", input 563, input item.it-codigo ).
    end.
 
    /** Consiste quantidades no browse do estoque. **/
 
    assign de-tot = 0.
    for each rat-lote {cdp/cd8900.i rat-lote docum-est} and
        rat-lote.sequencia = input frame {&frame-name} item-doc-est.sequencia
        and rat-lote.int-2 <> 3:
        assign de-tot = de-tot + rat-lote.quantidade.
    end.    
 
    {utp/ut-field.i mgind item-doc-est baixa-ce 4}
    assign c-formato = return-value.
    RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure, INPUT "baixa-ce").
 
    assign l-baixa-ce = yes.
    assign l-baixa-ce = if return-value = string(l-baixa-ce,c-formato) 
                        then yes else no.
 
    RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure, INPUT "quantidade").
    assign l-ok = if (de-tot = dec(return-value)) 
                  or (((item.politica = 5 
                        or item.politica = 6)
                        and not l-baixa-ce) 
                      and docum-est.esp-docto = 20)
                      or not l-baixa-ce 
                  then yes
                  else no.
 
    if  not l-ok then do:
        /* mensagem: Quantidades informadas diferem da quantidade informada para o item. */
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input 15224,input " ").
        apply 'entry' to item-doc-est.it-codigo in frame {&frame-name} .
        return 'adm-error':U.
    end.        
 
    if  l-material-agregado then do:
        if item.tipo-contr <> 4 then do:
            /* mensagem: Item deve ser dÇbito direto. */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 851,input " ").
            apply 'entry' to item-doc-est.it-codigo in frame {&frame-name} .
            return 'adm-error':U.
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
  {src/adm/template/snd-list.i "item-doc-est"}

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


