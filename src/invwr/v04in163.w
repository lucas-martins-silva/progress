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
{include/i-prgvrs.i V04IN163 2.00.00.022 } /*** "010022" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v04in163 MUT}
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
    def var i-indice-cq         as int       no-undo.
    def buffer b-item           for item.
    def var i-numero-ordem      like it-doc-fisico.numero-ordem no-undo.

    &IF '{&mgscm_version}' >= '2.06B' &THEN
        DEF VAR hdboin089wms        AS HANDLE NO-UNDO.
        DEF VAR hDBOWMS             AS HANDLE NO-UNDO.
        DEFINE VARIABLE l-conecta   AS LOGICAL     NO-UNDO.
        {method/dbotterr.i}  /* RowErrors */
    &ENDIF
    def new global shared var l-material-agregado as logical no-undo.
    def new global shared var gr-doc-fisico       as rowid   no-undo.
    def new global shared var gr-it-doc-fisico    as rowid   no-undo.

    def buffer b-it-doc-fisico for it-doc-fisico.
    DEFINE BUFFER bf-ordem-compra FOR ordem-compra.

    DEFINE TEMP-TABLE tt-erro NO-UNDO
        FIELD i-sequen AS INTEGER
        FIELD cd-erro  AS INTEGER
        FIELD mensagem AS CHARACTER FORMAT "x(255)".
    
    {cdp/cdcfgmat.i}
    {cdp/cdcfgdis.i}

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
    {cdp/cd9590.i}    
    &ENDIF

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
         HEIGHT             = 3.38
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
    /*--- ZOOM SMART OBJECT ---*/
    {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                       &campo=it-doc-fisico.cod-refer
                       &campozoom=cod-refer
                       &parametros="run pi-seta-inicial in wh-pesquisa (input it-doc-fisico.it-codigo:screen-value in frame {&frame-name})."} 
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
                     &where="item.it-codigo = input frame {&frame-name} it-doc-fisico.it-codigo"}

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

    &IF '{&bf_dis_versao_ems}' >= '2.05' &then
        FIND FIRST funcao 
            WHERE funcao.cd-funcao = "spp-seriais-nf" NO-LOCK NO-ERROR.
        IF AVAIL funcao THEN DO:
            IF funcao.ativo THEN DO:
                FIND FIRST item-dist 
                    WHERE item-dist.it-codigo = input frame {&frame-name} it-doc-fisico.it-codigo
                    AND   item-dist.log-1     = YES NO-LOCK NO-ERROR.

                IF  AVAIL item-dist   AND
                    l-docto-devolucao THEN
                    RUN pi-habilita-serial IN h_principal (INPUT YES).  
                ELSE
                    RUN pi-habilita-serial IN h_principal (INPUT NO).
            END.
        END.    
    &ENDIF

    disable it-doc-fisico.it-codigo with frame {&frame-name}.

    run pi-cod-refer.
    if it-doc-fisico.cod-refer:sensitive in frame {&frame-name} = yes then do:
        apply "entry" to it-doc-fisico.cod-refer in frame {&frame-name}.
        return no-apply.
    end.

    {include/i-epcgeneric.i LEAVE-ITEM VIEWER THIS-PROCEDURE {&FRAME-NAME} it-doc-fisico ROWID(it-doc-fisico)}

    IF RETURN-VALUE <> "OK":U THEN
        RETURN NO-APPLY.

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

find first param-cq no-lock no-error.

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

    find item no-lock 
        where item.it-codigo = input frame {&frame-name} it-doc-fisico.it-codigo no-error.

    run pi-recebe-numero-ordem in h_v05in163 (output i-numero-ordem).

    IF AVAIL ITEM AND item.tipo-contr <> 4 AND 
       (i-numero-ordem > 0)
       OR CAN-FIND(rat-ordem WHERE  rat-ordem.serie-docto  = doc-fisico.serie-docto 
                                AND rat-ordem.nro-docto    = doc-fisico.nro-docto   
                                AND rat-ordem.cod-emitente = doc-fisico.cod-emitente
                                AND rat-ordem.nat-operacao = ""
                                AND rat-ordem.sequencia    = input frame {&frame-name} it-doc-fisico.sequencia) THEN DO:
   
          find item-fornec where 
               item-fornec.it-codigo    = item.it-codigo and
               item-fornec.cod-emitente = doc-fisico.cod-emitente
               no-lock no-error.
          if not avail item-fornec then do:
              run utp/ut-msgs.p (input "show",input 3306,input return-value).
              apply 'entry' to it-doc-fisico.it-codigo in frame {&frame-name} .
              return 'adm-error':U.
          end.
    END.
 
    for each rat-lote 
        use-index documento where
        rat-lote.serie-docto  = it-doc-fisico.serie-docto  and
        rat-lote.nro-docto    = it-doc-fisico.nro-docto    and
        rat-lote.cod-emitente = it-doc-fisico.cod-emitente and
        rat-lote.nat-operacao = "" and
        rat-lote.tipo-nota    = it-doc-fisico.tipo-nota and
        rat-lote.sequencia    = it-doc-fisico.sequencia exclusive-lock:

        if rat-lote.int-2 = 3 THEN DO:

            /*Atualiza situaá∆o da Ficha gerada pelo CQ0240 para Pendente de NF */
            IF rat-lote.nr-ficha <> 0 THEN DO:
                FIND FIRST ficha-cq EXCLUSIVE-LOCK
                     WHERE ficha-cq.idi-orig-restdo = 2 /*CQ0240*/
                       AND ficha-cq.nr-ficha = rat-lote.nr-ficha NO-ERROR. 
                IF AVAIL ficha-cq THEN
                    ASSIGN ficha-cq.situacao = 6. /*Pendente NF*/
            END.
            
            delete rat-lote.
        END.

        else 
            assign rat-lote.int-2 = 0
                   rat-lote.dec-2 = 0.

        ASSIGN rat-lote.qtd-origin = rat-lote.quantidade WHEN rat-lote.qtd-origin <> rat-lote.quantidade.
    end.      

    

    /**  Monta temp-table saldo estoque no browse de estoque.  
    **/
    if valid-handle(h_b06in367) then do:
        if adm-new-record = no then 
            run pi-novo-registro in h_b06in367 (input no).
    end.

    if valid-handle(h_principal) then
        run pi-altera-reg in h_principal.

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        IF  l-unidade-negocio AND l-mat-unid-negoc 
        AND AVAIL doc-fisico
        AND (doc-fisico.tipo-nota = 1 OR doc-fisico.tipo-nota = 9) THEN
            run cdp/cd9760.p (input 4,   /* it-doc-fisico */
                              input it-doc-fisico.it-codigo,
                              input rowid(it-doc-fisico) ).
    &ELSE
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
    &ENDIF
    
    if not adm-new-record and
        it-doc-fisico.quant-conf > 0 then do:
        run utp/ut-msgs.p (input "show",input 17360,input "").
        assign it-doc-fisico.quant-conf = 0.
        &IF '{&mgscm_version}' >= '2.06B' &THEN
            FIND FIRST param-estoq NO-LOCK NO-ERROR.
            IF AVAIL param-estoq AND
               SUBSTR(param-estoq.char-2,6,1) = "1" THEN DO:
                RUN inbo/boin287a.p PERSISTENT SET hDBOWMS.
                ASSIGN l-conecta = NO.
                RUN connectWMS IN hDBOWMS (OUTPUT l-conecta).
                IF RETURN-VALUE = "OK":U THEN DO:        
                    IF NOT VALID-HANDLE(hdboin089wms) THEN
                        RUN inbo/boin089wm.p PERSISTENT SET hdboin089wms.          
                    EMPTY TEMP-TABLE RowErrors.
                    RUN reabreContagemWMS IN hdboin089wms (INPUT it-doc-fisico.nro-docto,
                                                           INPUT it-doc-fisico.serie-docto,
                                                           INPUT it-doc-fisico.tipo-nota,
                                                           INPUT it-doc-fisico.cod-emitente,
                                                           INPUT it-doc-fisico.sequencia,
                                                           OUTPUT TABLE RowErrors).
                    FIND FIRST rowErrors NO-ERROR.
                    IF AVAIL rowErrors THEN DO:
                        RUN utp/ut-msgs.p (INPUT "show",
                                           INPUT rowErrors.ErrorNumber, 
                                           INPUT rowErrors.ErrorParameters).
                    END.    

                    IF l-conecta = YES THEN
                        RUN disconnectWMS IN hDBOWMS.

                    IF VALID-HANDLE(hDBOWMS) THEN DO:
                        DELETE PROCEDURE hDBOWMS NO-ERROR.
                        ASSIGN hDBOWMS = ?.
                    END.
                    IF VALID-HANDLE(hdboin089wms) THEN DO:
                        DELETE PROCEDURE hdboin089wms NO-ERROR.
                        ASSIGN hdboin089wms = ?.
                    END.              
                END.
            END.
        &ENDIF
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

    DEF VAR l-vinc-rot-pend AS LOG NO-UNDO.

    run pi-AtualizaNVInsp (INPUT doc-fisico.cod-emitente,
                       INPUT doc-fisico.nro-docto,
                       INPUT doc-fisico.serie-docto,
                       INPUT input frame {&frame-name} it-doc-fisico.sequencia,
                       INPUT input frame {&frame-name} it-doc-fisico.it-codigo).

    for first item-uni-estab FIELDS(log-rotei-pend)
        where item-uni-estab.it-codigo   = input frame {&frame-name} it-doc-fisico.it-codigo
          and item-uni-estab.cod-estabel = doc-fisico.cod-estabel no-lock:
        ASSIGN l-vinc-rot-pend = item-uni-estab.log-rotei-pend.
    end.
    
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

            IF l-vinc-rot-pend THEN DO:
                
                IF rat-lote.nr-ficha <> 0 THEN DO:
                    FIND FIRST ficha-cq EXCLUSIVE-LOCK
                         WHERE ficha-cq.idi-orig-restdo = 2 /*CQ0240*/
                           AND ficha-cq.nr-ficha = rat-lote.nr-ficha NO-ERROR. 
                    IF AVAIL ficha-cq THEN
                        ASSIGN ficha-cq.situacao = 6. /*Pendente NF*/

                END.
            END.

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
        IF  AVAIL it-doc-fisico THEN DO:
            RUN pi-controle-transacao IN h_b06in367 (INPUT ROWID(it-doc-fisico),
                                                     INPUT NO).
            RUN dispatch IN h_b06in367 ('open-query':U).
            RUN Get-Field-Screen-Value IN adm-broker-hdl
               (INPUT this-procedure, INPUT "quantidade").
            run pi-dados-complement IN h_b06in367 (input IF it-doc-fisico.quant-conf > 0 THEN it-doc-fisico.quant-conf ELSE dec(return-value)).
        END.
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
    DEF VAR h-bodi578 AS HANDLE NO-UNDO.

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

    run pi-AtualizaNVInsp (INPUT it-doc-fisico.cod-emitente,
                           INPUT it-doc-fisico.nro-docto,
                           INPUT it-doc-fisico.serie-docto,
                           INPUT it-doc-fisico.sequencia,
                           INPUT it-doc-fisico.it-codigo).


    /* atualiza saldo faturamento antecipado, voltando o saldo da nota eliminada */
    IF  NOT VALID-HANDLE(h-bodi578) THEN
        RUN dibo/bodi578.p PERSISTENT SET h-bodi578.

    IF  VALID-HANDLE(h-bodi578) THEN DO:

        RUN openQueryStatic IN h-bodi578("main").

        IF  it-doc-fisico.tipo-nota = 11 /* faturamento antecipado */ THEN
            RUN atualizaSaldoFisicoItem IN h-bodi578(it-doc-fisico.seq-comp, /* ID do sdo-fatur-antecip */
                                                     "",                   /* cod-estabel  */
                                                     "",                   /* serie-docto  */  
                                                     "",                   /* nr-nota-fis  */  
                                                     0,                    /* cod-emitente */
                                                     "",                   /* it-codigo    */                        
                                                     "",                   /* cod-refer    */ 
                                                     0,                    /* num-seq      */
                                                     (it-doc-fisico.quantidade * -1)). /* qtd-saldo    */

        DELETE PROCEDURE h-bodi578 NO-ERROR.

    END.


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

        &IF '{&bf_dis_versao_ems}' >= '2.05' &then
            FIND FIRST funcao 
                WHERE funcao.cd-funcao = "spp-seriais-nf" NO-LOCK NO-ERROR.
            IF  AVAIL funcao THEN DO:
                IF funcao.ativo THEN DO:
                    FIND FIRST item-dist
                        WHERE item-dist.it-codigo = input frame {&frame-name} it-doc-fisico.it-codigo
                        AND   item-dist.log-1     = YES NO-LOCK NO-ERROR.

                    IF  AVAIL item-dist   AND
                        l-docto-devolucao THEN
                        RUN pi-habilita-serial IN h_principal (INPUT YES).
                    ELSE
                        RUN pi-habilita-serial IN h_principal (INPUT NO).
                END.
            END.
        &ENDIF

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
        IF  AVAIL it-doc-fisico THEN DO:
            RUN pi-elimina-tt         IN h_b06in367.
            RUN pi-controle-transacao IN h_b06in367 (INPUT ROWID(it-doc-fisico),
                                                     INPUT YES).
        END.
    end.

    if adm-new-record = yes then do:
        &if defined(ADM-MODIFY-FIELDS) &then do:
            enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
        &endif
        run pi-passa-item ( 0, "" ).

        &IF '{&bf_dis_versao_ems}' >= '2.05' &then
            FIND FIRST funcao 
                WHERE funcao.cd-funcao = "spp-seriais-nf" NO-LOCK NO-ERROR.
            IF AVAIL funcao THEN DO:
                IF funcao.ativo THEN
                    RUN pi-habilita-serial IN h_principal (INPUT NO).
            END.
        &ENDIF
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


    &if "{&BF_MAT_VERSAO_EMS}" < "2.062" &then
    
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
                 if  de-tot-unid <> 100 then do:
                     assign {&window-name}:sensitive = no.
                     run cdp/cd9767.w ( input rowid(it-doc-fisico) ).
                     assign {&window-name}:sensitive = yes.
                 end.

            end.
        &endif 
    &ENDIF
    
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

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
    
        IF  l-mat-unid-negoc THEN
            IF  AVAIL it-doc-fisico
            AND (doc-fisico.tipo-nota       = 1 /* Compra */ OR doc-fisico.tipo-nota = 9) /* Rateio */
            AND  it-doc-fisico.nr-ord-produ = 0
            AND ((ITEM.tipo-contr           = 1  /* Fisico */ 
              OR  ITEM.tipo-contr           = 4) /* DD */
              OR (ITEM.tipo-contr           = 2  /* Total  */ AND it-doc-fisico.conta-contab <> "")) THEN

                RUN new-state("habilitar":U).
            ELSE
                RUN new-state("desabilitar":U).

        ELSE
            RUN new-state("desabilitar":U).

    &ENDIF
    
    IF  AVAIL it-doc-fisico THEN
        ASSIGN gr-it-doc-fisico = ROWID(it-doc-fisico).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-AtualizaNVInsp V-table-Win 
PROCEDURE pi-AtualizaNVInsp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-cod-emitente   LIKE it-doc-fisico.cod-emitente     NO-UNDO.
DEF INPUT PARAM p-nro-docto      LIKE it-doc-fisico.nro-docto        NO-UNDO.
DEF INPUT PARAM p-serie-docto    LIKE it-doc-fisico.serie-docto      NO-UNDO.
DEF INPUT PARAM p-sequencia      LIKE it-doc-fisico.sequencia        NO-UNDO.
DEF INPUT PARAM p-it-codigo      LIKE it-doc-fisico.it-codigo        NO-UNDO.

if  avail param-cq
    and param-cq.tipo-cq = 3 then do:
    
    find first item
         where item.it-codigo = p-it-codigo no-lock no-error.
    
    for each rat-lote
        where rat-lote.cod-emitente = p-cod-emitente
        and   rat-lote.nro-docto    = p-nro-docto
        and   rat-lote.nat-operacao = ""
        and   rat-lote.serie-docto  = p-serie-docto
        and   rat-lote.sequencia    = p-sequencia  no-lock:
    
    
        find first item-fornec-estab
            where  item-fornec-estab.it-codigo    = p-it-codigo
            and    item-fornec-estab.cod-emitente = p-cod-emitente
            and    item-fornec-estab.cod-estabel  = doc-fisico.cod-estabel exclusive-lock no-error.
    
        if avail item-fornec-estab
        and  item-fornec-estab.tp-inspecao > 3 then do:
            if item-fornec-estab.niv-inspecao > 0 then do:
               assign item-fornec-estab.niv-inspecao =  item-fornec-estab.niv-inspecao - 1.
            end.
            else do:
                assign i-indice-cq = if  item.criticidade = 1 
                                     then param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3]
                                     else 
                                         if  item.criticidade = 2 
                                         then param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3]
                                         else 
                                             if  item.criticidade = 3 
                                             then param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3]
                                             else 0.
                
                assign item-fornec-estab.niv-inspecao =  i-indice-cq.
            end.
        end.
    
        if not avail item-fornec-estab then do:
            find first item-fornec
                where  item-fornec.it-codigo    = p-it-codigo
                and    item-fornec.cod-emitente = p-cod-emitente exclusive-lock no-error.
            if avail item-fornec
            and  item-fornec.tp-inspecao > 3 then do:
                if item-fornec.niv-inspecao > 0 then
                    assign item-fornec.niv-inspecao =  item-fornec.niv-inspecao - 1.
                else do:
                    assign i-indice-cq = if  item.criticidade = 1 
                                         then param-cq.ins-pref-x[item-fornec.tp-inspecao - 3]
                                         else 
                                             if  item.criticidade = 2 
                                             then param-cq.ins-pref-y[item-fornec.tp-inspecao - 3]
                                             else 
                                                 if  item.criticidade = 3 
                                                 then param-cq.ins-pref-z[item-fornec.tp-inspecao - 3]
                                                 else 0.

                    assign item-fornec.niv-inspecao =  i-indice-cq.
                end.
            end.
        end.
    end.
end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-refer V-table-Win 
PROCEDURE pi-recebe-refer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-cod-refer LIKE it-doc-fisico.cod-refer NO-UNDO.
    ASSIGN p-cod-refer = input frame {&frame-name} it-doc-fisico.cod-refer.


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
    DEF VAR l-baixa-estoque AS LOG NO-UNDO.
    DEFINE VARIABLE l-conta-matriz AS LOGICAL     NO-UNDO.

    {include/i-vldfrm.i} 

    RUN Who-Is-The-Container IN adm-broker-hdl (INPUT this-procedure, 
                                                OUTPUT c-handle).
    ASSIGN wh_re2001 = WIDGET-HANDLE(c-handle).

    find item no-lock 
        where item.it-codigo = input frame {&frame-name} it-doc-fisico.it-codigo no-error.

    run pi-recebe-numero-ordem in h_v05in163 (output i-numero-ordem).
    
    IF AVAIL ITEM AND item.tipo-contr <> 4 AND 
       (i-numero-ordem > 0)
       OR CAN-FIND(rat-ordem WHERE rat-ordem.serie-docto   = doc-fisico.serie-docto 
                                AND rat-ordem.nro-docto    = doc-fisico.nro-docto   
                                AND rat-ordem.cod-emitente = doc-fisico.cod-emitente
                                AND rat-ordem.nat-operacao = ""
                                AND rat-ordem.sequencia    = input frame {&frame-name} it-doc-fisico.sequencia) THEN DO:
    
         find item-fornec where 
               item-fornec.it-codigo    = input frame {&frame-name} it-doc-fisico.it-codigo and
               item-fornec.cod-emitente = doc-fisico.cod-emitente
               no-lock no-error.
          if not avail item-fornec then do:
              run utp/ut-msgs.p (input "show",input 3306,input return-value).
              apply 'entry' to it-doc-fisico.it-codigo in frame {&frame-name} .
              return 'adm-error':U.
          end.

    END.

    /* Validaá∆o de item n∆o configurado para CQ e dep¢sito informado de CQ*/
    FOR EACH rat-lote NO-LOCK
        WHERE rat-lote.serie-docto  = doc-fisico.serie-docto 
          AND rat-lote.nro-docto    = doc-fisico.nro-docto   
          AND rat-lote.cod-emitente = doc-fisico.cod-emitente
          AND rat-lote.nat-operacao = ""
          AND rat-lote.sequencia    = input frame {&frame-name} it-doc-fisico.sequencia:
        
        IF  CAN-FIND(FIRST item-uni-estab NO-LOCK
                     WHERE item-uni-estab.it-codigo      = rat-lote.it-codigo       AND
                           item-uni-estab.cod-estabel    = doc-fisico.cod-estabel   AND
                           item-uni-estab.contr-qualid   = NO)                      AND
                CAN-FIND(FIRST deposito NO-LOCK
                         WHERE deposito.cod-depos = rat-lote.cod-depos AND
                               deposito.ind-dep-cq) THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 57097,
                                       INPUT RETURN-VALUE).
                    RETURN 'adm-error':U.
        END.
    END.
        
    if not available item then do:
        /**  Item nao cadastrado **/
        {include/i-vldprg.i}
        {utp/ut-field.i mgind it-doc-fisico it-codigo 01}
        run utp/ut-msgs.p (input "show",input 47,input return-value).
        apply 'entry' to it-doc-fisico.it-codigo in frame {&frame-name} .
        return 'adm-error':U.
    end.

    IF AVAIL ITEM AND item.tipo-contr = 4 AND i-numero-ordem > 0 THEN DO:
        IF CAN-FIND (FIRST contrato-for
                     WHERE contrato-for.nr-contrato     = i-numero-ordem
                     AND   contrato-for.ind-control-rec = 1) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 56920,
                               INPUT "":U).
            RETURN 'adm-error':U.
        END. 
        
        FOR FIRST ordem-compra FIELDS (nr-contrato  num-seq-item)
            WHERE ordem-compra.numero-ordem   = i-numero-ordem NO-LOCK:
        END.
        IF CAN-FIND (FIRST item-contrat
                     WHERE item-contrat.num-seq-item     = ordem-compra.num-seq-item  
                       AND item-contrat.nr-contrato      = ordem-compra.nr-contrato
                       AND item-contrat.ind-tipo-control = 1) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 56920,
                               INPUT "":U).
            RETURN 'adm-error':U.
        END.

        RUN cnp/cn9072.p (INPUT i-numero-ordem,
                          INPUT ?,
                          input 12,                    /* Conta-Atual   */
                          OUTPUT l-conta-matriz,
                          INPUT-OUTPUT TABLE tt-erro ).

        IF l-conta-matriz THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 56902,
                               INPUT "":U).
            RETURN 'adm-error':U.
        END.
    END.


    if adm-new-record then do:
        if can-find(first b-it-doc-fisico
                    where b-it-doc-fisico.nro-docto    = doc-fisico.nro-docto    
                      and b-it-doc-fisico.serie-docto  = doc-fisico.serie-docto  
                      and b-it-doc-fisico.cod-emitente = doc-fisico.cod-emitente 
                      and b-it-doc-fisico.tipo-nota    = doc-fisico.tipo-nota    
                      and b-it-doc-fisico.sequencia    = input frame {&frame-name} it-doc-fisico.sequencia) then do:
            /**  Sequencia do item ja cadastrada **/
            {include/i-vldprg.i}
            {utp/ut-field.i mgind it-doc-fisico sequencia 01}
            run utp/ut-msgs.p (input "show",input 24,input return-value).
            apply 'entry' to it-doc-fisico.sequencia in frame {&frame-name}.
            return 'adm-error':U.
        end.                

        /** Verifica Item x Referància - CD1506 **/
        if  item.tipo-con-est = 4 /* Referància */ 
        and not can-find(first ref-item 
                         where ref-item.it-codigo = input frame {&frame-name} it-doc-fisico.it-codigo 
                           and ref-item.cod-refer = input frame {&frame-name} it-doc-fisico.cod-refer) then do:   
            /**  Sequencia do item ja cadastrada **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 33928,
                               input input frame {&frame-name} it-doc-fisico.cod-refer + "~~" + input frame {&frame-name} it-doc-fisico.it-codigo).
            apply 'entry' to it-doc-fisico.it-codigo in frame {&frame-name}.
            return 'adm-error':U.
        end.
    end.

    /** Consiste quantidades no browse do estoque. **/
    assign de-tot = 0.
    for each rat-lote use-index documento 
        where rat-lote.serie-docto  = doc-fisico.serie-docto  
          and rat-lote.nro-docto    = doc-fisico.nro-docto    
          and rat-lote.cod-emitente = doc-fisico.cod-emitente 
          and rat-lote.nat-operacao = "" 
          and rat-lote.tipo-nota    = doc-fisico.tipo-nota 
          and rat-lote.sequencia    = input frame {&frame-name} it-doc-fisico.sequencia
          and rat-lote.int-2       <> 3 no-lock:
        assign de-tot = de-tot + rat-lote.quantidade.

        if  doc-fisico.tipo-nota <> 2 
        and rat-lote.it-codigo   <> input frame {&frame-name} it-doc-fisico.it-codigo then 
            assign l-verifica-item = yes.
    end.    

    {utp/ut-field.i mgind it-doc-fisico baixa-ce 4}
    assign c-formato = return-value.
    
    run Get-Field-Screen-Value in adm-broker-hdl (input this-procedure, input "baixa-ce").
    assign l-baixa-ce = if return-value = string(l-baixa-ce,c-formato) 
                        then yes else no.

    run Get-Field-Screen-Value in adm-broker-hdl (input this-procedure, input "quantidade").
    assign l-ok = if (de-tot = dec(return-value))
                  OR l-baixa-ce 
                  then yes
                  else no.

    if l-verifica-item then do:
        /** item para entrada no estoque difere do item da ordem de compra informada **/
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input 31222,input "").
        run select-page IN wh_re2001 (3).                    
        return 'adm-error':U.
    end.

    if  not l-ok 
    and avail doc-fisico then do:
        /**  Quantidades informadas diferem da quantidade informada para o item.  **/
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input 15224,input " ").
        apply 'entry' to it-doc-fisico.it-codigo in frame {&frame-name} .
        return 'adm-error':U.
    end.        

    IF NOT CAN-FIND(FIRST rat-lote 
            WHERE rat-lote.serie-docto  = doc-fisico.serie-docto  AND 
                  rat-lote.nro-docto    = doc-fisico.nro-docto    AND 
                  rat-lote.cod-emitente = doc-fisico.cod-emitente AND 
                  rat-lote.tipo-nota    = doc-fisico.tipo-nota AND
                  rat-lote.sequencia    = input frame {&frame-name} it-doc-fisico.sequencia) THEN DO:
        
        RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "baixa-ce":U).
        ASSIGN l-baixa-estoque = IF RETURN-VALUE = "sim":U 
                                 OR RETURN-VALUE = "yes":U THEN YES ELSE NO.
        
        IF doc-fisico.tipo-nota <> 8 AND l-baixa-estoque THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 36046, INPUT "":U).
            RUN select-page IN wh_re2001 (3).                    
            RETURN 'adm-error':U.
        END.
    END.
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
