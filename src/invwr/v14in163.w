&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            ORACLE
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
{include/i-prgvrs.i V14IN163 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V14IN163 MUT}
&ENDIF


    CREATE WIDGET-POOL.
    &Scop adm-attribute-dlg support/viewerd.w

    def var v-row-parent        as rowid     no-undo.
    def var l-pede-cab-item     as logical   no-undo.
    def var h_principal         as handle    no-undo.
    def var h_b06in367          as handle    no-undo.
    def var h_v05in163          as handle    no-undo.
    def var h_v06in163          as handle    no-undo.
    def var l-ok                as logical   no-undo.
    def var l-novo-reg          as logical   no-undo.
    def var l-docto-devolucao   as logical   no-undo.
    def var de-tot              like rat-lote.quantidade no-undo.
    def var l-verifica-item     as logical   no-undo.
    def var wh_re2001           as handle    no-undo.
    def var c-handle            as character no-undo.

    def new global shared var l-material-agregado as logical no-undo.
    def new global shared var gr-doc-fisico       as rowid   no-undo.
    def new global shared var gr-it-doc-fisico    as rowid   no-undo.

    def buffer b-it-doc-fisico for it-doc-fisico.

    {cdp/cdcfgmat.i}
    {cdp/cdcfgdis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES it-doc-fisico
&Scoped-define FIRST-EXTERNAL-TABLE it-doc-fisico


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR it-doc-fisico.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS it-doc-fisico.sequencia ~
it-doc-fisico.it-codigo it-doc-fisico.cod-refer 
&Scoped-define ENABLED-TABLES it-doc-fisico
&Scoped-define FIRST-ENABLED-TABLE it-doc-fisico
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS it-doc-fisico.sequencia ~
it-doc-fisico.it-codigo it-doc-fisico.cod-refer 
&Scoped-define DISPLAYED-TABLES it-doc-fisico
&Scoped-define FIRST-DISPLAYED-TABLE it-doc-fisico
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
     SIZE 49.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item-do-forn AS CHARACTER FORMAT "X(60)" 
     LABEL "Item Fornecedor":R18 
     VIEW-AS FILL-IN 
     SIZE 44.57 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.29 BY 3.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     it-doc-fisico.sequencia AT ROW 1.25 COL 17.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     it-doc-fisico.it-codigo AT ROW 2.25 COL 17.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.57 BY .88
     c-desc-it-codigo AT ROW 2.25 COL 35.43 COLON-ALIGNED NO-LABEL
     fi-item-do-forn AT ROW 3.25 COL 17.43 COLON-ALIGNED
     it-doc-fisico.cod-refer AT ROW 3.25 COL 73.14 COLON-ALIGNED
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
   External Tables: movind.it-doc-fisico
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
         HEIGHT             = 3.42
         WIDTH              = 88.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME it-doc-fisico.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.cod-refer V-table-Win
ON F5 OF it-doc-fisico.cod-refer IN FRAME f-main /* Referància */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z02in377.w
                       &campo=it-doc-fisico.cod-refer
                       &campozoom=cod-refer}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.cod-refer V-table-Win
ON LEAVE OF it-doc-fisico.cod-refer IN FRAME f-main /* Referància */
DO:

    find referencia where 
        referencia.cod-refer = input frame {&frame-name} it-doc-fisico.cod-refer
        no-lock no-error.
    if not available referencia then do:
        /**  Referencia n∆o cadastrada 
        **/
        {utp/ut-field.i mgind it-doc-fisico cod-refer 01}
        run utp/ut-msgs.p (input "show",input 47,input return-value).
        apply 'entry' to it-doc-fisico.cod-refer in frame {&frame-name} .
        return no-apply.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-doc-fisico.cod-refer IN FRAME f-main /* Referància */
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

        find first item-fornec where 
            item-fornec.cod-emitente = doc-fisico.cod-emitente and 
            item-fornec.item-do-forn = input frame {&frame-name} fi-item-do-forn
            no-lock no-error.

        if not available item-fornec then do:
            {utp/ut-table.i mgind item-fornec 1}
            run utp/ut-msgs.p (input "show",input 2,input return-value).
            apply "entry" to fi-item-do-forn in frame {&frame-name}.
            return no-apply.
        end.
        assign it-doc-fisico.it-codigo:screen-value in frame {&frame-name} = item-fornec.it-codigo.
    end.        
    else         
        assign it-doc-fisico.it-codigo:screen-value in frame {&frame-name} = "".

    find item where 
        item.it-codigo = input frame {&frame-name} it-doc-fisico.it-codigo
        no-lock no-error.
    if not available item then do:
        run utp/ut-msgs.p (input "show",input 166,input return-value).
        apply "entry" to fi-item-do-forn in frame {&frame-name}.
        return no-apply.
    end.
    assign c-desc-it-codigo:screen-value in frame {&FRAME-NAME} = item.desc-item.

    run pi-passa-item ( input input frame {&frame-name} it-doc-fisico.sequencia,
                        input input frame {&frame-name} it-doc-fisico.it-codigo ).

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


&Scoped-define SELF-NAME it-doc-fisico.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.it-codigo V-table-Win
ON F5 OF it-doc-fisico.it-codigo IN FRAME f-main /* Item */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                       &campo=it-doc-fisico.it-codigo
                       &campozoom=it-codigo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.it-codigo V-table-Win
ON LEAVE OF it-doc-fisico.it-codigo IN FRAME f-main /* Item */
DO:

    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=c-desc-it-codigo
                     &where="item.it-codigo = input frame {&frame-name}
                             it-doc-fisico.it-codigo"}

    find item where 
        item.it-codigo = input frame {&frame-name} it-doc-fisico.it-codigo
        no-lock no-error.
    if not available item then do:
        run utp/ut-msgs.p (input "show",input 166,input return-value).
        apply "entry" to it-doc-fisico.it-codigo in frame {&frame-name}.
        return no-apply.
    end.

    find first item-fornec where 
        item-fornec.cod-emitente = doc-fisico.cod-emitente and 
        item-fornec.it-codigo    = input frame {&frame-name} it-doc-fisico.it-codigo
        no-lock no-error.
    if avail item-fornec then 
        assign fi-item-do-forn:screen-value in frame {&frame-name} = item-fornec.item-do-forn.

    run pi-passa-item ( input input frame {&frame-name} it-doc-fisico.sequencia,
                        input input frame {&frame-name} it-doc-fisico.it-codigo ).

    disable it-doc-fisico.it-codigo with frame {&frame-name}.

    run pi-cod-refer.
    if it-doc-fisico.cod-refer:sensitive in frame {&frame-name} = yes then do:
        apply "entry" to it-doc-fisico.cod-refer in frame {&frame-name}.
        return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-doc-fisico.it-codigo IN FRAME f-main /* Item */
DO:

    apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.sequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.sequencia V-table-Win
ON LEAVE OF it-doc-fisico.sequencia IN FRAME f-main /* Seq */
DO:

    disable it-doc-fisico.sequencia with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF         

    if it-doc-fisico.it-codigo:load-mouse-pointer("image/lupa.cur")
        in frame {&frame-name} then .
    if fi-item-do-forn:load-mouse-pointer("image/lupa.cur")
        in frame {&frame-name} then .
    if it-doc-fisico.cod-refer:load-mouse-pointer("image/lupa.cur")
        in frame {&frame-name} then .

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
  {src/adm/template/row-list.i "it-doc-fisico"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "it-doc-fisico"}

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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    find last b-it-doc-fisico where 
        b-it-doc-fisico.cod-emitente = doc-fisico.cod-emitente and
        b-it-doc-fisico.nro-docto    = doc-fisico.nro-docto    and
        b-it-doc-fisico.tipo-nota    = doc-fisico.tipo-nota    and
        b-it-doc-fisico.serie-docto  = doc-fisico.serie-docto  
        no-lock no-error.
    if available b-it-doc-fisico then
        assign it-doc-fisico.sequencia:screen-value in frame {&frame-name} = 
            string(b-it-doc-fisico.sequencia + param-re.inc-seq).
    else
        assign it-doc-fisico.sequencia:screen-value in frame {&frame-name} = 
            string(param-re.seq-item-um).

    if valid-handle(h_b06in367) then
        run pi-novo-registro in h_b06in367 (input yes).

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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    for each rat-lote 
        use-index documento where
        rat-lote.serie-docto  = it-doc-fisico.serie-docto  and
        rat-lote.nro-docto    = it-doc-fisico.nro-docto    and
        rat-lote.cod-emitente = it-doc-fisico.cod-emitente and
        rat-lote.nat-operacao = "" and
        rat-lote.tipo-nota    = it-doc-fisico.tipo-nota and
        rat-lote.sequencia    = it-doc-fisico.sequencia exclusive-lock:

        if rat-lote.int-2 = 3 then 
            delete rat-lote.
        else 
            assign rat-lote.int-2 = 0
                   rat-lote.dec-2 = 0.
    end.                   

    /**  Monta temp-table saldo estoque no browse de estoque.  
    **/
    if valid-handle(h_b06in367) then do:
        if adm-new-record = no then 
            run pi-novo-registro in h_b06in367 (input no).
    end.

    if valid-handle(h_principal) then
        run pi-altera-reg in h_principal.

    &if  defined(bf_mat_unidade_negocio) &then
         if  avail param-mat 
         and param-mat.ind-unid-neg 
         and connected("emsuni")
         and connected("emsbas")  then do:

            run cdp/cd9760.p ( input 4,   /* it-doc-fisico */
                       input it-doc-fisico.it-codigo,
                       input rowid(it-doc-fisico) ).

         end.
    &endif         

    if not adm-new-record and
        it-doc-fisico.quant-conf > 0 then do:
        run utp/ut-msgs.p (input "show",input 17360,input "").
        assign it-doc-fisico.quant-conf = 0.
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

    for each rat-lote EXCLUSIVE-LOCK
        use-index documento where
        rat-lote.serie-docto  = doc-fisico.serie-docto  and
        rat-lote.nro-docto    = doc-fisico.nro-docto    and
        rat-lote.cod-emitente = doc-fisico.cod-emitente and
        rat-lote.nat-operacao = "" and
        rat-lote.tipo-nota    = doc-fisico.tipo-nota and
        rat-lote.sequencia    = input frame {&frame-name} it-doc-fisico.sequencia:

        if rat-lote.int-2 = 1 or  
            adm-new-record then do:  /**  Inclusao  **/
            delete rat-lote.
            next.
        end.
        else 
        if rat-lote.int-2 = 2 then 
            assign rat-lote.quantidade = rat-lote.dec-2.

        assign rat-lote.int-2 = 0 
               rat-lote.dec-2 = 0.        
    end.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

    assign l-novo-reg = no.

    /**  Habilita/Desabilita browse de estoque.  
    **/
    if valid-handle(h_b06in367) then do:
        run pi-novo-registro   in h_b06in367 (input no).
        run pi-habilita-sal-re in h_b06in367 (input no).
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

  &IF "{&mgind_dbtype}" = "progress" &THEN
    ASSIGN it-doc-fisico.cod-emitente = doc-fisico.cod-emitente
           it-doc-fisico.nro-docto    = doc-fisico.nro-docto
           it-doc-fisico.tipo-nota    = doc-fisico.tipo-nota
           it-doc-fisico.serie-docto  = doc-fisico.serie-docto.
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    if  can-find (first doc-fisico
            where doc-fisico.serie-docto  = it-doc-fisico.serie-docto
              and doc-fisico.nro-docto    = it-doc-fisico.nro-docto
              and doc-fisico.cod-emitente = it-doc-fisico.cod-emitente
              and doc-fisico.tipo-nota    = it-doc-fisico.tipo-nota
              and doc-fisico.situacao    <> 1 ) then do:
        run utp/ut-msgs.p (input "show", input 7183, input "").
        return error.
    end.

    /**********************************************************
    ** Desenvolvimento Engenharia Controle de Seriais        **
    ** Variavel indicara se a funcao SPP-SERIAIS-NF estara   **
    ** ativa ou nao.                                         **
    **********************************************************/
    DEFINE VARIABLE l-funcao-spp-seriais-nf AS LOGICAL NO-UNDO.

    FIND FIRST funcao
         WHERE funcao.cd-funcao = "spp-seriais-nf":U
           AND funcao.ativo     = YES NO-LOCK NO-ERROR.

    IF AVAIL funcao THEN
        ASSIGN l-funcao-spp-seriais-nf = YES.
    ELSE
        ASSIGN l-funcao-spp-seriais-nf = NO.

    /*****************************************
    ** Nova Funcionalidade Controle Seriais **
    *****************************************/
    &IF '{&bf_mat_versao_ems}' >= '2.05' &THEN
        IF l-funcao-spp-seriais-nf THEN DO:
            FOR EACH it-doc-fisico-serial EXCLUSIVE-LOCK
               WHERE it-doc-fisico-serial.cod-ser-docto = it-doc-fisico.serie-docto  
                 AND it-doc-fisico-serial.cod-docto     = it-doc-fisico.nro-docto    
                 AND it-doc-fisico-serial.cdn-emitente  = it-doc-fisico.cod-emitente
                 AND it-doc-fisico-serial.idi-tip-nf    = it-doc-fisico.tipo-nota
                 AND it-doc-fisico-serial.num-seq       = it-doc-fisico.sequencia:

                DELETE it-doc-fisico-serial.
            END.
        END.
    &ENDIF

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

    if valid-handle(h_principal) then 
        run pi-altera-reg in h_principal.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    assign l-novo-reg = no.

    /**  Habilita/Desabilita browse de estoque.  
    **/
    if valid-handle(h_b06in367) then
        run pi-habilita-sal-re in h_b06in367 (input no).

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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    if available it-doc-fisico and available doc-fisico then do:

        find item where 
            item.it-codigo = it-doc-fisico.it-codigo
            no-lock no-error.
        if available item then
            assign c-desc-it-codigo:screen-value in frame {&frame-name} =
                item.desc-item.
        else
            assign c-desc-it-codigo:screen-value in frame {&frame-name} = "".

        find item-fornec where
            item-fornec.it-codigo    = it-doc-fisico.it-codigo and
            item-fornec.cod-emitente = doc-fisico.cod-emitente 
            no-lock no-error.
        if available item-fornec then
            assign fi-item-do-forn:screen-value in frame {&frame-name} =
                item-fornec.item-do-forn.
        else
            assign fi-item-do-forn:screen-value in frame {&frame-name} = "".
        if valid-handle(h_b06in367) then do:
            run pi-passa-item in h_b06in367 
                (input it-doc-fisico.sequencia,
                 input it-doc-fisico.it-codigo).
            run pi-habilita-sal-re in h_b06in367 (input no).
        end.         

        assign gr-it-doc-fisico = rowid(it-doc-fisico).

        /********************************
        ** Docto Devolucao? (= 2)      **
        ********************************/
        IF  doc-fisico.tipo-nota = 2 THEN
            ASSIGN l-docto-devolucao = YES.
        ELSE
            ASSIGN l-docto-devolucao = NO.
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

    if valid-handle(h_principal) then
        run pi-primeira-pagina in h_principal.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    assign l-novo-reg = yes.

    run pi-recebimento.

    disable it-doc-fisico.sequencia
            it-doc-fisico.it-codigo
            fi-item-do-forn
            it-doc-fisico.cod-refer with frame {&frame-name}.

    if l-pede-cab-item then do:
        if param-re.pd-seq then
            enable it-doc-fisico.sequencia with frame {&frame-name}.

        if not l-material-agregado or  
            param-re.pede-it-agreg  then do:
            if param-re.cod-ent-item = 1 then 
                enable it-doc-fisico.it-codigo with frame {&frame-name}.
            else 
                enable fi-item-do-forn with frame {&frame-name}.
        end.
    end.

    if l-material-agregado and not param-re.pede-it-agreg then do:
        if adm-new-record then do:
            find item where 
                item.it-codigo = "":U 
                no-lock no-error.
            assign c-desc-it-codigo:screen-value in frame {&frame-name} = item.desc-item.
        end.
    end.

    /**  Habilita/Desabilita browse de estoque.   
    **/
    if valid-handle(h_b06in367) then do:
        run pi-habilita-sal-re in h_b06in367 (input yes).
        run pi-novo-registro   in h_b06in367 (input no).
    end.

    if adm-new-record = yes then do:
        &if defined(ADM-MODIFY-FIELDS) &then do:
            enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
        &endif
        run pi-passa-item ( 0, "" ).
    end.
    else if avail it-doc-fisico then do:
        for each rat-lote 
            use-index documento where
            rat-lote.serie-docto  = it-doc-fisico.serie-docto  and
            rat-lote.nro-docto    = it-doc-fisico.nro-docto    and
            rat-lote.cod-emitente = it-doc-fisico.cod-emitente and
            rat-lote.nat-operacao = "" and
            rat-lote.tipo-nota    = it-doc-fisico.tipo-nota and
            rat-lote.sequencia    = it-doc-fisico.sequencia exclusive-lock:

            assign rat-lote.int-2 = 0
                   rat-lote.dec-2 = rat-lote.quantidade.
        end.
        run pi-passa-item ( it-doc-fisico.sequencia, it-doc-fisico.it-codigo ).
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    def var de-tot-unid as decimal no-undo.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


    /* Unidade de Neg¢cio */
    &if  defined(bf_mat_unidade_negocio) &then 

        if  avail param-mat 
        and param-mat.ind-unid-neg
        and connected("emsuni")
        and connected("emsbas")  then do:

             assign de-tot-unid = 0.

             if  not param-mat.pede-unid-neg-cc then do:
                 for each unid-neg-nota 
                      where unid-neg-nota.cod-emitente = it-doc-fisico.cod-emitente 
                        and unid-neg-nota.serie-docto  = it-doc-fisico.serie-docto 
                        and unid-neg-nota.nro-docto    = it-doc-fisico.nro-docto 
                        and unid-neg-nota.nat-operacao = " " 
                        and unid-neg-nota.sequencia    = it-doc-fisico.sequencia 
                        and unid-neg-nota.tipo-nota    = it-doc-fisico.tipo-nota no-lock:

                       assign de-tot-unid = de-tot-unid + unid-neg-nota.perc-unid-neg.
                 end.
             end.                 
             if  de-tot-unid <> 100 then 
                 run cdp/cd9767.w ( input rowid(it-doc-fisico) ).
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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    find doc-fisico where
        rowid(doc-fisico) = gr-doc-fisico
        no-lock no-error.

    if avail doc-fisico then do:
        find emitente where
            emitente.cod-emitente = doc-fisico.cod-emitente
            no-lock no-error.
    end.

    if available it-doc-fisico and available doc-fisico then do:

        find item where 
            item.it-codigo = it-doc-fisico.it-codigo
            no-lock no-error.

        if available item then
            assign c-desc-it-codigo:screen-value in frame {&frame-name} =
                item.desc-item.
        else
            assign c-desc-it-codigo:screen-value in frame {&frame-name} = "".

        find item-fornec where
             item-fornec.it-codigo    = it-doc-fisico.it-codigo and
             item-fornec.cod-emitente = doc-fisico.cod-emitente 
             no-lock no-error.
        if available item-fornec then
            assign fi-item-do-forn:screen-value in frame {&frame-name} =
                item-fornec.item-do-forn.
        else
            assign fi-item-do-forn:screen-value in frame {&frame-name} = "".

    end.

    find param-re where
        param-re.usuario = c-seg-usuario
        no-lock no-error.        

    find first param-global
         no-lock no-error.

    find first param-compra
         no-lock no-error.        

    find first param-mat no-lock no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-reset-record V-table-Win 
PROCEDURE local-reset-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'reset-record':U ) .

    if valid-handle(h_b06in367) then do:
        run pi-novo-registro   in h_b06in367 (input no).
        run pi-habilita-sal-re in h_b06in367 (input no).
    end.

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
        where item.it-codigo = input frame {&frame-name} it-doc-fisico.it-codigo
        no-lock no-error.

    if (available item and item.tipo-con-est = 4) then do:
        enable it-doc-fisico.cod-refer with frame {&frame-name}.
        apply "entry" to it-doc-fisico.cod-refer in frame {&frame-name}.
        return "adm-error".
    end.
    else
        disable it-doc-fisico.cod-refer with frame {&frame-name}.

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

    if l-habilita = yes and
        (available item and item.tipo-con-est = 4) then 
        assign it-doc-fisico.cod-refer:sensitive in frame {&frame-name} = yes.
    else 
        assign it-doc-fisico.cod-refer:sensitive in frame {&frame-name} = no.

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

    def input param p-it-codigo like it-doc-fisico.it-codigo no-undo.

    if not l-material-agregado then 
        assign it-doc-fisico.it-codigo:screen-value in frame {&frame-name} = p-it-codigo.

    apply "leave" to it-doc-fisico.it-codigo in frame {&frame-name}.

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

    assign h_principal = p-handle-1
           h_b06in367  = p-handle-2
           h_v05in163  = p-handle-3
           h_v06in163  = p-handle-4.

    if valid-handle(h_b06in367) then do:
        run pi-passa-handle    in h_b06in367 (input this-procedure).
        run pi-novo-registro   in h_b06in367 (input no).
        run pi-habilita-sal-re in h_b06in367 (input no).
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

    def input parameter p-sequencia like it-doc-fisico.sequencia no-undo.
    def input parameter p-it-codigo like it-doc-fisico.it-codigo no-undo.

    /**  Browse Estoque 
    **/
    if valid-handle(h_b06in367) then
       run pi-passa-item in h_b06in367 ( p-sequencia,
                                         p-it-codigo ).

    /**  Ordem de Compra/Produá∆o 
    **/
    if valid-handle(h_v05in163) then
       run pi-passa-item in h_v05in163 ( p-sequencia,
                                         p-it-codigo).

    /**  Quantidade e Valores 
    **/
    if valid-handle(h_v06in163) then
       run pi-passa-item in h_v06in163 ( p-sequencia,
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

    assign it-doc-fisico.it-codigo:screen-value in frame {&frame-name} = p-it-codigo.
    assign fi-item-do-forn:screen-value         in frame {&frame-name} = p-item-do-forn.

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

    define output parameter c-item like it-doc-fisico.it-codigo.
    assign c-item = input frame {&frame-name} it-doc-fisico.it-codigo.

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

    if adm-new-record then
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

    {include/i-vldfrm.i} 

    RUN Who-Is-The-Container IN adm-broker-hdl (INPUT this-procedure, 
                                                OUTPUT c-handle).
    ASSIGN wh_re2001 = WIDGET-HANDLE(c-handle).

    find item where 
        item.it-codigo = input frame {&frame-name} it-doc-fisico.it-codigo
        no-lock no-error.

    if adm-new-record then do:
        find b-it-doc-fisico where 
            b-it-doc-fisico.nro-docto    = doc-fisico.nro-docto    and 
            b-it-doc-fisico.serie-docto  = doc-fisico.serie-docto  and 
            b-it-doc-fisico.cod-emitente = doc-fisico.cod-emitente and 
            b-it-doc-fisico.tipo-nota    = doc-fisico.tipo-nota    and
            b-it-doc-fisico.sequencia    = input frame {&frame-name} it-doc-fisico.sequencia
            no-lock no-error.
        if available b-it-doc-fisico then do:
            /**  Sequencia do item ja cadastrada 
            **/
            {include/i-vldprg.i}
            {utp/ut-field.i mgind it-doc-fisico sequencia 01}
            run utp/ut-msgs.p (input "show",input 24,input return-value).
            apply 'entry' to it-doc-fisico.sequencia in frame {&frame-name}.
            return 'adm-error':U.
        end.                
    end.

    if not available item then do:
        /**  Item nao cadastrado 
        **/
        {include/i-vldprg.i}
        {utp/ut-field.i mgind it-doc-fisico it-codigo 01}
        run utp/ut-msgs.p (input "show",input 47,input return-value).
        apply 'entry' to it-doc-fisico.it-codigo in frame {&frame-name} .
        return 'adm-error':U.
    end.

    /** Consiste quantidades no browse do estoque. 
    **/
    assign de-tot = 0.
    for each rat-lote NO-LOCK
        use-index documento where
        rat-lote.serie-docto  = doc-fisico.serie-docto  and
        rat-lote.nro-docto    = doc-fisico.nro-docto    and
        rat-lote.cod-emitente = doc-fisico.cod-emitente and
        rat-lote.nat-operacao = "" and
        rat-lote.tipo-nota    = doc-fisico.tipo-nota and
        rat-lote.sequencia = input frame {&frame-name} it-doc-fisico.sequencia
        and rat-lote.int-2 <> 3:
        assign de-tot = de-tot + rat-lote.quantidade.

        IF doc-fisico.tipo-nota <> 2 AND
           rat-lote.it-codigo   <> input frame {&frame-name} it-doc-fisico.it-codigo THEN
            ASSIGN l-verifica-item = YES.
    end.    

    {utp/ut-field.i mgind it-doc-fisico baixa-ce 4}
    assign c-formato = return-value.
    RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure, INPUT "baixa-ce").

    assign l-baixa-ce = yes.
    assign l-baixa-ce = if return-value = string(l-baixa-ce,c-formato) 
                        then yes else no.

    RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure, INPUT "quantidade").

    assign l-ok = if (de-tot = dec(return-value)) 
                  or not l-baixa-ce 
                  then yes
                  else no.

    IF l-verifica-item THEN DO:
        /**  item para entrada no estoque difere do item da ordem de compra informada
        **/
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input 31222,input "").
        RUN select-page IN wh_re2001 (3).                    
        return 'adm-error':U.
    END.
    if not l-ok and 
        avail doc-fisico then do:
        /**  Quantidades informadas diferem da quantidade informada para o item. 
        **/
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input 15224,input " ").
        apply 'entry' to it-doc-fisico.it-codigo in frame {&frame-name} .
        return 'adm-error':U.
    end.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvar_chave V-table-Win 
PROCEDURE salvar_chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN it-doc-fisico.cod-emitente = doc-fisico.cod-emitente
           it-doc-fisico.nro-docto    = doc-fisico.nro-docto
           it-doc-fisico.tipo-nota    = doc-fisico.tipo-nota
           it-doc-fisico.serie-docto  = doc-fisico.serie-docto.

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
  {src/adm/template/snd-list.i "it-doc-fisico"}

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

