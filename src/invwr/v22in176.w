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
{include/i-prgvrs.i V22IN176 2.00.00.020}  /*** "010020" ***/
 
 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v22in176 MUT}
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
def temp-table tt-rat-ordem like rat-ordem
     index codigo   
           int-1.
 
 
 
/* Local Variable Definitions ---                                       */
 
    def var v-row-parent        as rowid    no-undo.
    def var c-nat-operacao      as char     no-undo.
    def var l-pede-qtd          as logical  no-undo.
    def var l-pede-peso         as logical  no-undo.
    def var l-pede-valor        as logical  no-undo.
    def var rw-docum-est        as rowid    no-undo.
 
    def new global shared var gr-docum-est  as rowid   no-undo.
    def new global shared var i-programa-re as integer no-undo.
    /**
    ***  Recebimento    1 - Normal
    ***                 2 - F°sico
    ***                 3 - Internacional
    **/
 
    def buffer b-item-doc-est for item-doc-est.
 
    {rep/re9800.i}
    {rep/re1001.i07}
    {cdp/cd0666.i}
    {cdp/cd4329.i2} /* Aloca/Desaloca parcela de Compra */
 
    def var i-sequencia        as integer no-undo.
    def var c-it-codigo        as char    no-undo.
    def var c-cod-refer        as char    no-undo.
    def var i-num-pedido       as integer no-undo.
    def var i-numero-ordem     as integer no-undo.
    def var i-parcela          as integer no-undo.
    def var c-serie-comp       as char    no-undo.
    def var c-nro-comp         as char    no-undo.
    def var c-nat-comp         as char    no-undo.
    def var i-seq-comp         as integer no-undo.
    def var de-qtd-aux         as decimal no-undo.
    def var de-indice          as decimal no-undo.
    def var c-un               as char    no-undo.
    def var de-preco-unit      as decimal no-undo.
    def var de-desconto        as decimal no-undo.
    def var de-val-contrato    as decimal no-undo.
    def var de-val-aux         as decimal no-undo.
    def var de-val-formula     as decimal no-undo.
    def var de-vl-merc-liq     like item-doc-est.preco-unit[1] no-undo.
    def var de-vl-preuni       as decimal no-undo.
    def var i-round            as integer no-undo.
    def var de-preco-total     as decimal no-undo.
    def var de-qtd-max         as decimal no-undo.
    def var de-vl-merc-liq-aux like item-doc-est.preco-total[1] no-undo.
    def var de-var-min         as decimal no-undo.
    def var l-contrato         as logical no-undo.
    def var de-var-max         as decimal no-undo.
    def var l-erro-co          as logical no-undo.
    def var de-despesa         as decimal no-undo.    
    def var de-frete           as decimal no-undo.
    def var l-novo-reg         as logical no-undo.
    def var c-un-aux           as char    no-undo.
    def var h_b03in367         as handle  no-undo.
    def var h_b07in368         as handle  no-undo.
    def var h_v21in176         as handle  no-undo.
    def var h_v16in176         as handle  no-undo.
    def var de-qt-aux          like  item-doc-est.quantidade no-undo.
    def var l-erro-qtd         as logical no-undo.
    def var de-taxa            as decimal no-undo.
    def var de-vl-aux          as decimal no-undo.
    def var i-moeda            like docum-est.mo-codigo no-undo.
    def var l-fifo             like item-doc-est.log-1 no-undo init no.
    def var c-formato as char no-undo.
    def var l-devol-fornec     as logical no-undo init no.
    def var l-alter-itens      as logical no-undo init no.

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
&Scoped-Define ENABLED-FIELDS item-doc-est.preco-unit-me ~
item-doc-est.qt-do-forn item-doc-est.preco-total-me item-doc-est.quantidade ~
item-doc-est.desconto-me item-doc-est.un item-doc-est.peso-liquido 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}preco-unit-me ~{&FP2}preco-unit-me ~{&FP3}~
 ~{&FP1}qt-do-forn ~{&FP2}qt-do-forn ~{&FP3}~
 ~{&FP1}preco-total-me ~{&FP2}preco-total-me ~{&FP3}~
 ~{&FP1}quantidade ~{&FP2}quantidade ~{&FP3}~
 ~{&FP1}desconto-me ~{&FP2}desconto-me ~{&FP3}~
 ~{&FP1}un ~{&FP2}un ~{&FP3}~
 ~{&FP1}peso-liquido ~{&FP2}peso-liquido ~{&FP3}
&Scoped-define ENABLED-TABLES item-doc-est
&Scoped-define FIRST-ENABLED-TABLE item-doc-est
&Scoped-Define ENABLED-OBJECTS rt-key-4 rt-key-2 
&Scoped-Define DISPLAYED-FIELDS item-doc-est.preco-unit-me ~
item-doc-est.qt-do-forn item-doc-est.preco-total-me item-doc-est.quantidade ~
item-doc-est.desconto-me item-doc-est.un item-doc-est.peso-liquido 
&Scoped-Define DISPLAYED-OBJECTS de-cotacao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS de-cotacao 
&Scoped-define ADM-ASSIGN-FIELDS de-cotacao 
&Scoped-define ADM-MODIFY-FIELDS de-cotacao 

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
DEFINE VARIABLE de-cotacao AS DECIMAL FORMAT ">>>,>9.99999999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.14 BY 9.17.

DEFINE RECTANGLE rt-key-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.86 BY 9.17.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-cotacao AT ROW 3.46 COL 17 COLON-ALIGNED
     item-doc-est.preco-unit-me AT ROW 3.46 COL 61.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .88
     item-doc-est.qt-do-forn AT ROW 4.46 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     item-doc-est.preco-total-me AT ROW 4.46 COL 61.72 COLON-ALIGNED FORMAT ">>>>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88
     item-doc-est.quantidade AT ROW 5.46 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     item-doc-est.desconto-me AT ROW 5.46 COL 61.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     item-doc-est.un AT ROW 6.46 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     item-doc-est.peso-liquido AT ROW 6.46 COL 61.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     rt-key-4 AT ROW 1 COL 1
     rt-key-2 AT ROW 1 COL 44.43
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
         HEIGHT             = 9.17
         WIDTH              = 86.72.
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

/* SETTINGS FOR FILL-IN de-cotacao IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN item-doc-est.preco-total-me IN FRAME f-main
   EXP-FORMAT                                                           */
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

&Scoped-define SELF-NAME item-doc-est.desconto-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.desconto-me V-table-Win
ON LEAVE OF item-doc-est.desconto-me IN FRAME f-main /* Desconto ME */
DO:
 
  run pi-apos-preco.
  run pi-atualiza-imposto in h_v21in176.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.preco-total-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.preco-total-me V-table-Win
ON LEAVE OF item-doc-est.preco-total-me IN FRAME f-main /* Preáo Total ME */
DO:
 
    if  input frame {&frame-name} item-doc-est.qt-do-forn = 0 then
        assign item-doc-est.preco-unit-me:screen-value in frame {&frame-name} =
            string(input frame {&frame-name} item-doc-est.preco-total-me).
    else
        assign item-doc-est.preco-unit-me:screen-value in frame {&frame-name} =
            string(input frame {&frame-name} item-doc-est.preco-total-me /
                   input frame {&frame-name} item-doc-est.qt-do-forn).
 
 
    if adm-new-record then do:
        if param-re.rateia-desc and
            l-devolucao = no and
            available docum-est then do:
            run rep/re1001r.p (rowid(docum-est),
                               input frame {&frame-name} item-doc-est.preco-total-me,
                               1,
                               output de-desconto).
            if  de-desconto <> 0 then do:                               
                assign item-doc-est.desconto-me:screen-value in frame {&frame-name} =
                       string(de-desconto).
            end.                       
        end.                
    end.            
 
    run pi-apos-preco.            
    run pi-atualiza-imposto in h_v21in176.        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.preco-unit-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.preco-unit-me V-table-Win
ON LEAVE OF item-doc-est.preco-unit-me IN FRAME f-main /* Preáo Unit ME */
DO:
 
    assign item-doc-est.preco-total-me:screen-value in frame {&frame-name} =
        string(round(input frame {&frame-name} item-doc-est.preco-unit-me *
                     (input frame {&frame-name} item-doc-est.qt-do-forn +
                     int(input frame {&frame-name} item-doc-est.qt-do-forn = 0)),2)).
    run pi-atualiza-imposto in h_v21in176.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.qt-do-forn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.qt-do-forn V-table-Win
ON LEAVE OF item-doc-est.qt-do-forn IN FRAME f-main /* Qtde Emitente */
DO:
 
    if adm-new-record then do:
        assign item-doc-est.quantidade:screen-value in frame {&frame-name} =
            string((input frame {&frame-name} item-doc-est.qt-do-forn / de-indice)).
        if item.fraciona = no then
            assign item-doc-est.quantidade:screen-value in frame {&frame-name} = 
                string(truncate(input frame {&frame-name} item-doc-est.quantidade,0)).
        /** Passa nova quantidade para o browse de estoque.  */
        if valid-handle(h_b03in367) then
            run pi-dados-complement in h_b03in367 (input frame {&frame-name} item-doc-est.quantidade).

    end.                            
 
    if l-devolucao then do:
        /* Calcula quantidade m†xima para devoluá∆o cliente - re1001.i04 */
        find it-nota-fisc where
            it-nota-fisc.cod-estabel = docum-est.cod-estabel and
            it-nota-fisc.serie       = c-serie-comp and
            it-nota-fisc.nr-nota-fis = docum-est.nro-docto and
            it-nota-fisc.it-codigo   = c-it-codigo and
            it-nota-fisc.nr-seq-fat  = i-seq-comp
            no-lock no-error.
        if available it-nota-fisc then do:
            assign de-qtd-max = it-nota-fisc.qt-faturada[1].
            for each devol-cli where
                devol-cli.cod-estabel  = it-nota-fisc.cod-estabel and
                devol-cli.nr-nota-fis  = it-nota-fisc.nr-nota-fis and
                devol-cli.serie        = it-nota-fisc.serie and
                devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat and
                devol-cli.it-codigo    = it-nota-fisc.it-codigo
                no-lock:
                assign de-qtd-max = de-qtd-max - devol-cli.qt-devolvida.
            end.
        end.
        else
            assign de-qtd-max = ?.
    end.            
 
    assign item-doc-est.preco-total-me:screen-value in frame {&frame-name} =
        string(round(input frame {&frame-name} item-doc-est.preco-unit-me *
                     (input frame {&frame-name} item-doc-est.qt-do-forn +
                     int(input frame {&frame-name} item-doc-est.qt-do-forn = 0)),2)).
    run pi-atualiza-imposto in h_v21in176.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.quantidade V-table-Win
ON LEAVE OF item-doc-est.quantidade IN FRAME f-main /* Nossa Qtde */
DO:
 
/*A l¢gica de alocaá∆o do saldo-terc ir† ficar somente na assign-records*/
/*  if  l-retorno then do:
 *       /* Atualiza quantidade alocada no saldo terceiros - cd4326.i1 */
 *       find saldo-terc where 
 *           saldo-terc.cod-emitente = docum-est.cod-emitente and 
 *           saldo-terc.nro-docto    = c-nro-comp and 
 *           saldo-terc.serie-docto  = c-serie-comp and 
 *           saldo-terc.nat-operacao = c-nat-comp and 
 *           saldo-terc.it-codigo    = c-it-codigo and 
 *           saldo-terc.cod-refer    = c-cod-refer and 
 *           saldo-terc.sequencia    = i-seq-comp
 *           exclusive-lock no-error.
 *       if  avail saldo-terc then 
 *           assign saldo-terc.dec-1   = saldo-terc.dec-1 + input frame {&frame-name} item-doc-est.quantidade
 *                  item-doc-est.dec-2 = input frame {&frame-name} item-doc-est.quantidade.     
 *   end.        
 *   */
 
 
  if  not available natur-oper 
  or  ( l-devolucao or l-retorno ) 
  or  param-re.pede-quant then
      assign item-doc-est.qt-do-forn:screen-value in frame {&frame-name} =
                                 string(input frame {&frame-name} item-doc-est.quantidade * de-indice).
    /** Passa nova quantidade para o browse de estoque.  */
  if valid-handle(h_b03in367) then
      run pi-dados-complement in h_b03in367 (input frame {&frame-name} item-doc-est.quantidade).
 
    assign item-doc-est.preco-total-me:screen-value in frame {&frame-name} =
        string(round(input frame {&frame-name} item-doc-est.preco-unit-me *
                     (input frame {&frame-name} item-doc-est.qt-do-forn +
                     int(input frame {&frame-name} item-doc-est.qt-do-forn = 0)),2)).
    run pi-atualiza-imposto in h_v21in176.
 
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
 
    do with frame {&frame-name}:
        {utp/ut-liter.i Preáo_Unit * L}
        assign item-doc-est.preco-unit-me:label  = return-value.
        {utp/ut-liter.i Preáo_Total * L}
        assign item-doc-est.preco-total-me:label  = return-value.
        {utp/ut-liter.i Desconto * L}
        assign item-doc-est.desconto-me:label  = return-value.
 
    end.

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
  {utp/ut-field.i mgind docum-est cotacao-dia 1}
  assign de-cotacao:label in frame {&frame-name} = return-value
         de-cotacao:screen-value in frame {&frame-name} = string(docum-est.cotacao-dia).
    for each tt-erro:
        delete tt-erro.
    end.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  def var de-desconto    as decimal no-undo.
  def var de-valor       as decimal no-undo.
  def var de-desconto-me as decimal no-undo.
  def var de-valor-me    as decimal no-undo.
 
  assign input frame {&frame-name} de-cotacao.
 
  {include/i-valid.i}
 
  if  adm-new-record = no then do:
      assign de-qt-aux      = item-doc-est.quantidade
             de-desconto    = item-doc-est.desconto-me
             de-valor       = item-doc-est.preco-total-me
             de-desconto-me = item-doc-est.desconto-me
             de-valor-me    = item-doc-est.preco-total-me.
  end.
  else
      assign de-qt-aux      = item-doc-est.quantidade
             de-desconto    = 0
             de-valor       = 0
             de-desconto-me = 0
             de-valor-me    = 0.
 
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
      return 'ADM-ERROR':U.
 
  find docum-est where rowid(docum-est) = rw-docum-est no-error.
  assign item-doc-est.cod-emitente = docum-est.cod-emitente
         item-doc-est.nro-docto    = docum-est.nro-docto
         item-doc-est.serie-docto  = docum-est.serie-docto
         item-doc-est.nat-operacao = docum-est.nat-operacao
         item-doc-est.qt-saldo     = if docum-est.nff or
                                          (not docum-est.nff and avail natur-oper and
                                           not natur-oper.emite-duplic) then 0
                                     else ( item-doc-est.qt-saldo 
                                          + item-doc-est.quantidade 
                                          - de-qt-aux)
         l-novo-reg                = no.
 
  if i-moeda <> docum-est.mo-codigo then do:
        assign docum-est.mo-codigo = i-moeda
               docum-est.cotacao-dia = input frame {&frame-name} de-cotacao
               docum-est.valor-frete     = docum-est.valor-frete-me  * input frame {&frame-name} de-cotacao
               docum-est.valor-seguro    = docum-est.valor-seguro-me * input frame {&frame-name} de-cotacao
               docum-est.valor-embal     = docum-est.valor-embal-me  * input frame {&frame-name} de-cotacao
               docum-est.valor-outras    = docum-est.valor-outras-me * input frame {&frame-name} de-cotacao
               docum-est.despesa-nota    = docum-est.valor-frete  + docum-est.valor-seguro
                                         + docum-est.valor-embal  + docum-est.valor-outras.
  end.
 
  if l-retorno then do:
      /* Atualiza quantidade alocada no saldo terceiros - cd4326.i1 */
        find saldo-terc 
            where saldo-terc.cod-emitente = docum-est.cod-emitente  
              and saldo-terc.nro-docto    = item-doc-est.nro-comp   
              and saldo-terc.serie-docto  = item-doc-est.serie-comp 
              and saldo-terc.nat-operacao = item-doc-est.nat-comp   
              and saldo-terc.it-codigo    = item-doc-est.it-codigo  
              and saldo-terc.cod-refer    = item-doc-est.cod-refer  
              and saldo-terc.sequencia    = item-doc-est.seq-comp   
            exclusive-lock no-error.
 
      if avail saldo-terc then 
           assign saldo-terc.dec-1 = saldo-terc.dec-1 + item-doc-est.quantidade - de-qt-aux
                  saldo-terc.dec-1 = if  saldo-terc.dec-1 < 0 then 0 
                                     else saldo-terc.dec-1.
  end.        
  if  item-doc-est.log-1 = yes then 
      run pi-efetiva-alteracoes-fifo in h_b07in368 (input rowid(item-doc-est)).
  if adm-new-record then do:
    if  item-doc-est.log-1 = yes then do:
        run rep/re1001p.p (input rowid(item-doc-est)).
        find docum-est where rowid(docum-est) = rw-docum-est no-error.
        if item-doc-est.preco-total-me = 0 then do:
           run pi-calcula-preco-fifo (output item-doc-est.preco-total-me,
                                      output item-doc-est.desconto-me).
           assign item-doc-est.preco-unit-me = item-doc-est.preco-total-me / item-doc-est.qt-do-forn
                  item-doc-est.preco-total-me:screen-value in frame {&FRAME-NAME} = string(item-doc-est.preco-total-me)
                  item-doc-est.desconto-me:screen-value    in frame {&FRAME-NAME} = string(item-doc-est.desconto-me)
                  item-doc-est.preco-unit-me:screen-value  in frame {&FRAME-NAME} = string(item-doc-est.preco-unit-me).
           run pi-atualiza-imposto in h_v21in176.         
        end.         
    end.      
    else do:
        if item-doc-est.preco-total-me = 0 then do:
           run pi-calcula-preco-medio (output item-doc-est.preco-unit-me).
           assign item-doc-est.preco-total-me = item-doc-est.preco-unit-me * item-doc-est.qt-do-forn
                  item-doc-est.preco-total-me:screen-value in frame {&FRAME-NAME} = string(item-doc-est.preco-total-me)
                  item-doc-est.preco-unit-me:screen-value  in frame {&FRAME-NAME} = string(item-doc-est.preco-unit-me).
           run pi-atualiza-imposto in h_v21in176.         
        end.         
    end.
  end.      
 
  for each tt-erro:
      delete tt-erro.
  end.
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure, INPUT "numero-ordem").
  assign i-numero-ordem = integer(return-value).        
  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure, INPUT "parcela").
  assign i-parcela = integer(return-value).
  find prazo-compra
       where prazo-compra.numero-ordem = i-numero-ordem
         and prazo-compra.parcela      = i-parcela
       exclusive-lock no-error.
  if      avail prazo-compra
  and not l-devol-fornec then do:
      if adm-new-record then 
          run pi-aloca-ordem-cc (input yes,
                                 input item-doc-est.quantidade,
                                 input rowid(prazo-compra)).
      else do:
          run pi-aloca-ordem-cc (input no,
                                 input de-qt-aux,
                                 input rowid(prazo-compra)).
          run pi-aloca-ordem-cc (input yes,
                                 input item-doc-est.quantidade,
                                 input rowid(prazo-compra)).
      end.
  end.
 
  assign item-doc-est.preco-unit[1]  = item-doc-est.preco-unit-me * docum-est.cotacao-dia
         item-doc-est.preco-total[1] = item-doc-est.preco-total-me * docum-est.cotacao-dia
         item-doc-est.desconto[1]    = item-doc-est.desconto-me * docum-est.cotacao-dia
         item-doc-est.sit-item       = if docum-est.nff or (    not docum-est.nff 
                                                            and not natur-oper.emite-duplic) then 1 else 2.
 
  assign docum-est.tot-desconto    = docum-est.tot-desconto 
                                   + item-doc-est.desconto[1] - de-desconto
         docum-est.tot-valor       = docum-est.tot-valor
                                   + item-doc-est.preco-total[1] - de-valor      
         docum-est.tot-desconto-me = docum-est.tot-desconto-me
                                   + item-doc-est.desconto-me - de-desconto-me 
         docum-est.tot-valor-me    = docum-est.tot-valor-me
                                   + item-doc-est.preco-total-me - de-valor-me
         docum-est.valor-mercad    = docum-est.tot-valor
         docum-est.valor-mercad-me = docum-est.tot-valor-me.
 
 
   assign l-erro-qtd = no.
 
  if  not param-re.sem-pedido
  and item-doc-est.log-1 then do:
      assign de-qtd-aux = 0.
 
      for each rat-ordem {cdp/cd8900.i rat-ordem item-doc-est}
           and rat-ordem.sequencia = item-doc-est.sequencia no-lock:
          assign de-qtd-aux = de-qtd-aux + rat-ordem.quantidade.
      end.
      if  de-qtd-aux < item-doc-est.quantidade then 
          assign l-erro-qtd = yes.
 
      run rep/re9995.p ( rowid(docum-est),
                         de-qtd-aux,
                         item-doc-est.quantidade,
                         15455,
                         de-qtd-aux = item-doc-est.quantidade,
                         item-doc-est.sequencia,
                         1 ).
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .
 
    for each tt-erro:
        delete tt-erro.
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
  disable de-cotacao with frame {&frame-name}.
  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 
 
  assign l-novo-reg = no.
 
    for each tt-erro:
        delete tt-erro.
    end.
 
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
  {utp/ut-field.i mgind docum-est cotacao-dia 1}
  assign de-cotacao:label in frame {&frame-name} = return-value.
 
 
  /** Monta temp-table saldo estoque no browse de estoque.  
 
    if valid-handle(h_b03in367) and 
        not l-novo-reg then
        run pi-monta-sal-re in h_b03in367.*/
 
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
 
  {utp/ut-field.i mgind docum-est cotacao-dia 1}
  assign de-cotacao:label in frame {&frame-name} = return-value.
  /* Code placed here will execute AFTER standard behavior.    */
 
  disable item-doc-est.preco-unit-me
          item-doc-est.preco-total-me
          item-doc-est.desconto-me    with frame {&frame-name}.
 
  assign l-novo-reg = yes.
 
  if adm-new-record = yes then do:
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  end.
 
  if  avail item-doc-est then do:
      if not adm-new-record then
            run pi-monta-browse in h_b07in368 (input rowid(item-doc-est)).
      find saldo-terc 
          where saldo-terc.cod-emitente = item-doc-est.cod-emitente 
            and saldo-terc.serie-docto  = item-doc-est.serie-comp 
            and saldo-terc.nat-operacao = item-doc-est.nat-comp 
            and saldo-terc.nro-docto    = item-doc-est.nro-comp 
            and saldo-terc.it-codigo    = item-doc-est.it-codigo 
            and saldo-terc.sequencia    = item-doc-est.seq-comp 
            and saldo-terc.cod-refer    = item-doc-est.cod-refer
          no-lock no-error.
  end.
  find item-fornec 
      where item-fornec.cod-emitente = docum-est.cod-emitente 
        and item-fornec.it-codigo    = c-it-codigo  no-lock no-error.
 
  if  available natur-oper then do:
      assign l-retorno = natur-oper.terceiros
                         and ( natur-oper.tp-oper-terc = 2 or
                               natur-oper.tp-oper-terc = 4 or
                               natur-oper.tp-oper-terc = 5 OR
                               natur-oper.tp-oper-terc = 9 OR
                               natur-oper.tp-oper-terc = 11) .           
                               
      /* Indica se Altera valor do itens em operacao com terceiros */
      assign l-alter-itens = int(substr(natur-oper.char-2,36,5)) = 1.
  end.
                         
 
  run pi-internacional.
 
  if  not l-transf then do:
      if  l-pede-qtd then do:
          if  avail natur-oper and not l-devolucao and not l-retorno then
              enable item-doc-est.qt-do-forn with frame {&frame-name}.
 
          enable item-doc-est.quantidade with frame {&frame-name}.
      end.
 
      if  not available natur-oper 
      or  not natur-oper.terceiros 
      or  l-alter-itens
      or ( natur-oper.tp-oper-terc <> 2 AND natur-oper.tp-oper-terc <> 9 AND natur-oper.tp-oper-terc <> 11
      and  natur-oper.tp-oper-terc <> 4 
      and  natur-oper.tp-oper-terc <> 5) then do:
           if  param-re.preco-unit then
               enable item-doc-est.preco-unit-me  with frame {&frame-name}.
           if docum-est.nff or param-re.ajusta-vl then             
               enable item-doc-est.preco-total-me with frame {&frame-name}.
           if param-re.pede-desc-it then
               enable item-doc-est.desconto-me    with frame {&frame-name}.
      end.
 
      if  l-pede-peso then
          enable item-doc-est.peso-liquido with frame {&frame-name}.
 
 
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
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
  if  l-erro-qtd then do:
      /* {include/i-vldprg.i} */
       run utp/ut-msgs.p (input "show",input 15455,input " ").
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
  /* Code placed here will execute PRIOR to standard behavior. */
  assign rw-docum-est = gr-docum-est.
  find docum-est where
       rowid(docum-est) = rw-docum-est
       no-lock no-error.
  if avail docum-est then do:
      find emitente where
          emitente.cod-emitente = docum-est.cod-emitente
          no-lock no-error.
      find natur-oper where
          natur-oper.nat-operacao = docum-est.nat-operacao
          no-lock no-error.
      assign i-moeda = docum-est.mo-codigo
             l-devol-fornec =  docum-est.esp-docto = 20 /*Devoluá∆o*/
                           and avail natur-oper         
                           and natur-oper.tipo = 2.     /*sa°da*/
 
  end.
  find param-re where
      param-re.usuario = c-seg-usuario
      no-lock no-error.        
  find first param-global
      no-lock no-error.
  find first param-compra
       no-lock no-error.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  do with frame {&frame-name}:
     {utp/ut-liter.i Preáo_Unit * L}
     assign item-doc-est.preco-unit-me:label  = return-value.
     {utp/ut-liter.i Preáo_Total * L}
     assign item-doc-est.preco-total-me:label  = return-value.
     {utp/ut-liter.i Desconto * L}
     assign item-doc-est.desconto-me:label  = return-value.
 
  end.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apos-preco V-table-Win 
PROCEDURE pi-apos-preco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*  Ordem de Compra de Serviáo */
    if  available ordem-compra 
    and ordem-compra.natureza = 2 
    and input frame {&frame-name} item-doc-est.qt-do-forn = 0    
    and input frame {&frame-name} item-doc-est.quantidade = 0 
    and not l-devol-fornec then do:
 
        assign item-doc-est.qt-do-forn:screen-value in frame {&frame-name} =
                            string( (input frame {&frame-name} item-doc-est.preco-total-me -
                                     input frame {&frame-name} item-doc-est.desconto-me) /
                                     de-vl-preuni)
               item-doc-est.quantidade:screen-value in frame {&frame-name} = 
                            string(input frame {&frame-name} item-doc-est.qt-do-forn / de-indice)
               item-doc-est.preco-unit-me:screen-value in frame {&frame-name} = 
                            string( input frame {&frame-name} item-doc-est.preco-total-me /
                                  ( input frame {&frame-name} item-doc-est.qt-do-forn +
                                    int( input frame {&frame-name} item-doc-est.qt-do-forn = 0))).
    end.        
 
    if  adm-new-record and 
        natur-oper.transf = no then 
        assign item-doc-est.peso-liquido:screen-value in frame {&frame-name} =
                       string( if not l-servicos then
                                    input frame {&frame-name} item-doc-est.quantidade * item.peso-liquido
                               else 0).
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-ordem-cc V-table-Win 
PROCEDURE pi-atualiza-ordem-cc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param i-ordem-cc   like item-doc-est.numero-ordem no-undo.
    def input param i-parcela-cc like item-doc-est.parcela      no-undo.
 
    def var de-preco-cc          as decimal no-undo.
    def var de-desconto-cc       as decimal no-undo.
    def var de-qtd-aux           as decimal no-undo.
 
    assign i-numero-ordem = i-ordem-cc
           i-parcela      = i-parcela-cc.
 
    find ordem-compra 
        where ordem-compra.numero-ordem = i-ordem-cc no-lock.
 
    if  avail ordem-compra then do:
        /*  C†lculo Preáo Unit†rio */
        run pi-verifica-cotacao.
        run rep/re1908.p (rowid(ordem-compra),
                          docum-est.dt-emissao,
                          output de-preco-cc,  
                          output de-desconto-cc,
                          output de-taxa).
        find item 
            where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
 
        find prazo-compra 
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem
              and prazo-compra.parcela      = i-parcela-cc no-lock no-error.
 
        if  avail prazo-compra then do: 
            if l-devol-fornec = no then 
                assign de-qtd-aux = prazo-compra.quant-saldo 
                                  - prazo-compra.dec-1
                                  + prazo-compra.quant-rejei. /*Descontando a quantidade devolvida*/
            else 
                assign de-qtd-aux = prazo-compra.quant-receb.
 
            assign     de-qtd-aux = if  de-qtd-aux < 0 then 0 
                                     else de-qtd-aux
                       item-doc-est.qt-do-forn:screen-value in frame {&frame-name} =
                                           string( de-qtd-aux * de-indice )
 
                       de-qtd-aux = if  item.fraciona then de-qtd-aux
                                    else truncate( de-qtd-aux, 0 )
 
                       item-doc-est.quantidade:screen-value in frame {&frame-name} =
                                            string( de-qtd-aux ).
 
 
        end.
 
        assign de-qtd-aux =(input frame {&frame-name} item-doc-est.qt-do-forn +
                            int(input frame {&frame-name} item-doc-est.qt-do-forn = 0)).
 
 
        assign item-doc-est.preco-unit-me:screen-value in frame {&frame-name} = string(de-preco-cc)
               item-doc-est.desconto-me:screen-value in frame {&frame-name} = 
                                       string(de-desconto-cc * de-qtd-aux)
               item-doc-est.preco-total-me:screen-value in frame {&frame-name} = 
                                       string(de-preco-cc * de-qtd-aux )
               de-vl-merc-liq = de-preco-cc - de-desconto-cc.                                       
 
 
        if  valid-handle(h_b03in367) then
            run pi-dados-complement in h_b03in367 (input frame {&frame-name} item-doc-est.quantidade).
 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-preco V-table-Win 
PROCEDURE pi-atualiza-preco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Esta procedure Ç utilizada pelo FIFO (B07IN368).      
------------------------------------------------------------------------------*/
    def input parameter table for tt-rat-ordem.

/*************** Comentado by C†ssio  27/03/99 pois essa rotina n∆o est† 
                 mais sendo chamada no browse. 
    def var de-preco-cc          as decimal no-undo.
    def var de-desconto-cc       as decimal no-undo.
    def var de-qtd-aux           as decimal no-undo.
    def var de-preco-cc-acum     as decimal no-undo.
    def var de-desconto-cc-acum  as decimal no-undo.
 
    for each tt-rat-ordem where tt-rat-ordem.log-2 no-lock:
 
        find ordem-compra 
             where ordem-compra.numero-ordem = tt-rat-ordem.numero-ordem no-lock.
 
        if  avail ordem-compra then do:
            run pi-verifica-cotacao.
            /*  C†lculo Preáo Unit†rio */
            run rep/re1908.p (rowid(ordem-compra),
                              docum-est.dt-emissao,
                              output de-preco-cc,  
                              output de-desconto-cc,
                              output de-taxa).
            assign de-preco-cc-acum = de-preco-cc-acum + de-preco-cc
                   de-desconto-cc-acum = de-desconto-cc-acum + de-desconto-cc.
 
            find item 
                where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
 
            find prazo-compra 
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                  and prazo-compra.parcela      = tt-rat-ordem.parcela no-lock no-error.
 
            if  avail prazo-compra then
                assign de-qtd-aux = de-qtd-aux + tt-rat-ordem.quantidade
                       de-qtd-aux = (if  item.fraciona then de-qtd-aux
                                     else truncate( de-qtd-aux, 0 )).
 
            assign de-qtd-aux = ((de-qtd-aux) + int((de-qtd-aux * de-indice) = 0)).
 
        end.
    end.
    assign item-doc-est.qt-do-forn:screen-value in frame {&frame-name} =
                                   string(de-qtd-aux * de-indice)
           item-doc-est.quantidade:screen-value in frame {&frame-name} =
                                   string(de-qtd-aux)
           item-doc-est.preco-unit-me:screen-value in frame {&frame-name} = string(de-preco-cc-acum)
           item-doc-est.desconto-me:screen-value in frame {&frame-name} = 
                                    string(de-desconto-cc-acum * de-qtd-aux)
           item-doc-est.preco-total-me:screen-value in frame {&frame-name} =
                                       string(round(input frame {&frame-name} item-doc-est.preco-unit-me *
                                              input frame {&frame-name} item-doc-est.qt-do-forn, 2)).
 
    if  valid-handle(h_b03in367) then
        run pi-dados-complement in h_b03in367 (input frame {&frame-name} item-doc-est.quantidade).
 *********************************/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-un V-table-Win 
PROCEDURE pi-atualiza-un :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    find item-fornec
        where item-fornec.cod-emitente = docum-est.cod-emitente 
          and item-fornec.it-codigo    = item.it-codigo no-lock no-error.
 
    assign c-un = if  available item-fornec 
                  and not l-devolucao   then
                      item-fornec.unid-med-for
                  else
                      item.un.
 
    if  adm-new-record then 
        assign item-doc-est.un:screen-value in frame {&frame-name} = c-un.    
 
    assign c-un-aux = input frame {&frame-name} item-doc-est.un.
    {cdp/cd9950.i item.un 
                  c-un-aux
                  docum-est.cod-emitente}
 
    if  de-indice = 0 or de-indice = ? then 
        assign de-indice = 1.                  

  assign item-doc-est.un:sensitive in frame {&frame-name} = (avail item and
                                                            item.tipo-contr = 4 and
                                                            not avail item-fornec).
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-preco-fifo V-table-Win 
PROCEDURE pi-calcula-preco-fifo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param de-preco-total-me like item-doc-est.preco-total-me.
def output param de-desconto-me    like item-doc-est.desconto-me.
 
    def var de-preco-cc          as decimal no-undo.
    def var de-desconto-cc       as decimal no-undo.
    def var de-qtd-aux           as decimal no-undo.
 
    assign de-preco-total-me = 0
           de-desconto-me    = 0.
    for each rat-ordem {cdp/cd8900.i rat-ordem item-doc-est} 
             and       rat-ordem.sequencia = item-doc-est.sequencia no-lock:
        find ordem-compra 
            where ordem-compra.numero-ordem = rat-ordem.numero-ordem no-lock.
 
        if  avail ordem-compra then do:
            /*  C†lculo Preáo Unit†rio */
            run rep/re1908.p (rowid(ordem-compra),
                              docum-est.dt-emissao,
                              output de-preco-cc,  
                              output de-desconto-cc,
                              output de-taxa).

            assign de-preco-total-me = de-preco-total-me + round(de-preco-cc    * rat-ordem.qtidade-forn,2)
                   de-desconto-me    = de-desconto-me    + (de-desconto-cc * rat-ordem.qtidade-forn).
        end.
    end.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-preco-medio V-table-Win 
PROCEDURE pi-calcula-preco-medio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param de-preco-unit-me like item-doc-est.preco-total-me.
 
    assign de-preco-unit-me = 0.
    find estab-mat where estab-mat.cod-estabel = docum-est.cod-estabel no-lock no-error.
    find item-estab 
        where item-estab.it-codigo    = item.it-codigo
        and   item-estab.cod-estabel  = docum-est.cod-estabel no-lock no-error.
    if avail item-estab then do:
        if  avail estab-mat 
        and estab-mat.custo-contab = 1 then
            assign de-preco-unit-me = (item-estab.val-unit-mat-m[1]
                                    + item-estab.val-unit-mob-m[1] 
                                    + item-estab.val-unit-ggf-m[1]) / docum-est.cotacao-dia.
        if  avail estab-mat and
            estab-mat.custo-contab = 2 then
            assign de-preco-unit-me = (item-estab.val-unit-mat-o[1]
                                    + item-estab.val-unit-mob-o[1]
                                    + item-estab.val-unit-ggf-o[1]) / docum-est.cotacao-dia.
 
        if  avail estab-mat and
            estab-mat.custo-contab = 3 then
            assign de-preco-unit-me = (item-estab.val-unit-mat-p[1]
                                    + item-estab.val-unit-mob-p[1]
                                    + item-estab.val-unit-ggf-p[1]) / docum-est.cotacao-dia.
 
    end.
 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-internacional V-table-Win 
PROCEDURE pi-internacional :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  run pi-seta-flags-observacao (docum-est.cod-observa, 
                                docum-est.nat-operacao).
  assign l-pede-qtd   = (not docum-est.rec-fisico and natur-oper.tp-oper-terc <> 6)
         l-pede-peso  = (not l-servicos)
         l-pede-valor = param-re.pd-despesa.                                
 
/* Consistàncias Internacional */
  assign de-cotacao:screen-value in frame {&frame-name} = string(docum-est.cotacao-dia)
         de-cotacao:sensitive    in frame {&frame-name} = no. /*a l¢gica de habilitaá∆o deste campo 
                                                                est† na procedure pi-verifica-cotacao*/
 
/****** Esta rotina est† sendo desativada **********
  if  adm-new-record then do:
      if  not l-transf  and
          not l-retorno and
          not l-ent-cons and
          available ordem-compra and 
          ordem-compra.mo-codigo <> 0 and not docum-est.nff and 
          ordem-compra.mo-codigo = docum-est.mo-codigo then do:
          find first moeda where moeda.mo-codigo = ordem-compra.mo-codigo
               no-lock no-error.
          find cotacao where
               cotacao.mo-codigo = ordem-compra.mo-codigo and
               cotacao.ano-periodo = (string(year(today),'9999') +
                                      string(month(today),'99')) no-error.
          if not available cotacao or 
            (avail cotacao and docum-est.cotacao-dia = 0) then 
              enable de-cotacao with frame {&frame-name}.
          else 
              disable de-cotacao with frame {&frame-name}.
      end.
      else 
         disp docum-est.cotacao-dia @ de-cotacao with frame {&frame-name}.
  end.
  else
      disp docum-est.cotacao-dia @ de-cotacao with frame {&frame-name}. 
****** Esta rotina est† sendo desativada ***********/    
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
 
    def input parameter p-handle  as handle no-undo.
    def input parameter p-handle1 as handle no-undo.
    def input parameter p-handle3 as handle no-undo.
    def input parameter p-handle4 as handle no-undo.
 
    assign h_b03in367 = p-handle
           h_b07in368 = p-handle1
           h_v21in176 = p-handle3
           h_v16in176 = p-handle4.
 
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
    def input parameter p-it-codigo     like item.it-codigo         no-undo.
    assign c-it-codigo = p-it-codigo
           i-sequencia = p-sequencia.
 
    find item where item.it-codigo = c-it-codigo no-lock no-error.
 
    run pi-atualiza-un.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-quantidade V-table-Win 
PROCEDURE pi-passa-quantidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    def input parameter de-quant as decimal no-undo.
    assign item-doc-est.quantidade:screen-value in frame {&frame-name} =
        string(de-quant).
 
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
 
    def input parameter p-quantidade as decimal no-undo.
    def input parameter p-qt-do-forn as decimal no-undo.
 
    assign item-doc-est.quantidade:screen-value in frame {&frame-name} =
        string(p-quantidade).
    assign item-doc-est.qt-do-forn:screen-value in frame {&frame-name} = 
        string(p-qt-do-forn).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-quant-maxima V-table-Win 
PROCEDURE pi-quant-maxima :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    find prazo-compra
        where prazo-compra.numero-ordem = i-numero-ordem
          and prazo-compra.parcela      = i-parcela
        exclusive-lock no-error.
 
    find ordem-compra
        where ordem-compra.numero-ordem = i-numero-ordem no-lock no-error.
 
    if not l-contrato then
        run pi-variacao-quant (prazo-compra.quant-saldo,
                               output de-qtd-max).
 
    run rep/re9995.p (rowid(docum-est),
                      de-qtd-max,
                      input frame {&frame-name} item-doc-est.quantidade,
                      19,
                      not (input frame {&frame-name} item-doc-est.quantidade > de-qtd-max),
                      i-sequencia,
                      2).
 
    /*run pi-aloca-ordem-compra(yes).*/
 
 
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
 
    if valid-handle(h_v16in176) then
        run pi-fifo in h_v16in176 (output l-fifo).
 
    find item where item.it-codigo = c-it-codigo no-lock no-error.
 
    find familia
        where familia.fm-codigo = item.fm-codigo no-lock no-error.
 
    /* Indica se Altera valor do itens em operacao com terceiros */
    if  avail natur-oper then
        assign l-alter-itens = int(substr(natur-oper.char-2,36,5)) = 1.
    
    if  l-retorno 
    and not adm-new-record then do:       
        find saldo-terc 
            where saldo-terc.cod-emitente = docum-est.cod-emitente  
              and saldo-terc.nro-docto    = item-doc-est.nro-comp   
              and saldo-terc.serie-docto  = item-doc-est.serie-comp 
              and saldo-terc.nat-operacao = item-doc-est.nat-comp   
              and saldo-terc.it-codigo    = item-doc-est.it-codigo  
              and saldo-terc.cod-refer    = item-doc-est.cod-refer  
              and saldo-terc.sequencia    = item-doc-est.seq-comp   
            no-lock no-error.
 
        find componente of saldo-terc no-lock no-error.
    end.            
 
    if  l-pede-qtd then do:   
        if  l-retorno 
        and not adm-new-record then do:
            if  input frame {&frame-name} item-doc-est.quantidade > (saldo-terc.quantidade - saldo-terc.dec-1 + item-doc-est.quantidade) then do:
                /* mensagem: Quantidade superior ao saldo em poder de terceiros */
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 15192,input " ").
                apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
                return 'adm-error':U.
            end.                
        end.
        if  item.fraciona = no 
        and integer( input frame {&frame-name} item-doc-est.quantidade) <>
                     input frame {&frame-name} item-doc-est.quantidade then do:
            /* mensagem: Quantidade n∆o pode ser fracionada */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 1892,input " ").
            apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if  (not available natur-oper 
        or  (natur-oper.terceiros and natur-oper.tp-oper-terc <> 6)) 
        and  input frame {&frame-name} item-doc-est.quantidade = 0 then do:
            /* mensagem: Quantidade deve ser diferente de zero */
            {include/i-vldprg.i}
            {utp/ut-liter.i Quantidade * L}
            run utp/ut-msgs.p (input "show",input 1491,input return-value).
            apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
            return 'adm-error':U.
        end.
 
        if  not adm-new-record and avail item-doc-est and l-devolucao then do:
            {rep/re1001.i04 docum-est.cod-estabel
                            item-doc-est.serie-comp
                            item-doc-est.nro-comp
                            item-doc-est.it-codigo
                            item-doc-est.seq-comp}
 
            if  de-qtd-max <> ?                             
            and input frame {&frame-name} item-doc-est.quantidade > de-qtd-max then do:        
                /* mensagem: Quantidade devolvida maior que quantidade faturada */
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 15024,input " ").
                apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
                return 'adm-error':U.
            end.
        end.            
    end.

    if  input frame {&frame-name} item-doc-est.un <> c-un 
    and (available item-fornec or item.tipo-contr <> 4) then do:            
 
        /* mensagem: Unidade de medida n∆o confere */
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input 7346,input " ").
        apply 'entry' to item-doc-est.un in frame {&frame-name}.
        return 'adm-error':U.
    end.
 
    if  not available natur-oper 
    or  (    not natur-oper.terceiros
         and not natur-oper.transf
         and docum-est.cod-observa <> 3) then do:
 
        /*quando for fifo e o preáo tiver = 0, o preco ser† calculado na assign records*/
        if  not ((l-fifo and input frame {&frame-name} item-doc-est.preco-total-me = 0 and adm-new-record) 
             or (not l-fifo and i-numero-ordem = 0 and input frame {&frame-name} item-doc-est.preco-total-me = 0 and adm-new-record)) then do:
 
            if  input frame {&frame-name} item-doc-est.preco-total-me = 0 
            and input frame {&frame-name} item-doc-est.quantidade <> 0 then do:
                /* mensagem: Preco total deve ser diferente de zero */
                {include/i-vldprg.i}
                {utp/ut-liter.i Preco_Total * L}
                run utp/ut-msgs.p (input "show",input 1491,input return-value).
                apply 'entry' to item-doc-est.preco-total-me in frame {&frame-name}.
                return 'adm-error':U.
            end.
            if  input frame {&frame-name} item-doc-est.qt-do-forn <> 0 then do:
                assign de-val-aux = round(input frame {&frame-name} item-doc-est.preco-unit-me *
                                          input frame {&frame-name} item-doc-est.qt-do-forn, 2).
                if  de-val-aux <> input frame {&frame-name} item-doc-est.preco-total-me 
                and param-re.preco-unit then do:
                    /* mensagem: Preco total n∆o confere com calculado. Confirma? */
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show",input 15193,input " ").
                    if  return-value <> "yes" then do:                                   
                        apply 'entry' to item-doc-est.un in frame {&frame-name}.
                        return 'adm-error':U.
                    end.
                    assign item-doc-est.preco-unit-me:screen-value in frame {&frame-name} =
                                string(input frame {&frame-name} item-doc-est.preco-total-me /
                                       input frame {&frame-name} item-doc-est.qt-do-forn ).
                end.
            end.                
        end.
    end.        
 
 
    if  i-numero-ordem <> 0 then do:
        assign de-vl-merc-liq-aux = input frame {&frame-name} item-doc-est.preco-total-me 
                                  - input frame {&frame-name} item-doc-est.desconto-me.
        if  not l-contrato then do:
            assign de-vl-aux = de-vl-merc-liq * ( input frame {&frame-name} item-doc-est.qt-do-forn
                                           + int( input frame {&frame-name} item-doc-est.qt-do-forn = 0 )).
 
            run pi-variacao-valor (input de-vl-aux,
                                   output de-var-max,
                                   output de-var-min).
        end.                                   
 
 
 
        if  de-vl-merc-liq-aux > de-var-max 
        or  de-vl-merc-liq-aux < de-var-min then do:
            if  param-re.aceita-var = no then do:                               
                /* mensagem: Valor l°quido fora da variacao permitida */
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 15195,input " ").
                apply 'entry' to item-doc-est.preco-unit-me in frame {&frame-name}.
                return 'adm-error':U.
            end.
            /* mensagem: Valor l°quido fora da variacao permitida. Confirma? */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15196,input " ").
            if return-value <> "yes" then do:                                
                apply 'entry' to item-doc-est.preco-unit-me in frame {&frame-name}.
                return 'adm-error':U.
            end.
        end.
        run rep/re9995.p (rowid(docum-est),
                          de-var-max,
                          de-vl-merc-liq-aux,
                          15196,
                          ( not (de-vl-merc-liq-aux > de-var-max or de-vl-merc-liq-aux < de-var-min)),
                          i-sequencia,
                          1).
    end.                                            
    if  l-retorno 
    and available natur-oper 
    and l-alter-itens then do:
        assign de-vl-merc-liq = input frame {&frame-name} item-doc-est.preco-total-me 
                              - input frame {&frame-name} item-doc-est.desconto-me
               de-vl-merc-liq-aux = ( componente.preco-total[1] / componente.quantidade )
                                  * input frame {&frame-name} item-doc-est.quantidade
               de-var-max     = de-vl-merc-liq-aux 
                              + (de-vl-merc-liq-aux * natur-oper.dec-1 / 100)
               de-var-min     = de-vl-merc-liq-aux 
                              - (de-vl-merc-liq-aux * natur-oper.dec-1 / 100).
 
        if  de-vl-merc-liq > de-var-max 
        or  de-vl-merc-liq < de-var-min then do:                                
            /* mensagem: Valor l°quido nota terceiros fora da variaá∆o permitida */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15197,input " ").
            apply 'entry' to item-doc-est.preco-unit-me in frame {&frame-name}.
            return 'adm-error':U.
        end.
    end.
 
    if  l-pede-qtd then do:
        if  i-numero-ordem <> 0 then do:
            if not l-erro-co then do:
                if not l-contrato then                    
                    run pi-variacao-quant (input prazo-compra.quant-saldo -
                                                 prazo-compra.dec-1,
                                           output de-qtd-max).
 
                if  input frame {&frame-name} item-doc-est.quantidade > de-qtd-max then do:                                    
                    if  param-re.aceita-var = no then do:                               
                        /* mensagem: Quantidade fora da variacao permitida */
                        {include/i-vldprg.i}
                        run utp/ut-msgs.p (input "show",input 5928,input " ").
                        apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
                        return 'adm-error':U.
                    end.
                    /* mensagem: Quantidade fora da variacao permitida. Confirma? */
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show",input 5698,input " ").
                    if return-value <> "yes" then do:                                
                        apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
                        return 'adm-error':U.
                    end.
                end.
            end.
            run rep/re9995.p (rowid(docum-est),
                              de-qtd-max,
                              input frame {&frame-name} item-doc-est.quantidade,
                              5698,
                              not (input frame {&frame-name} item-doc-est.quantidade > de-qtd-max),
                              i-sequencia,
                              1).
        end.
    end.
 
    find first tt-erro 
        no-lock no-error.
    if available tt-erro then do:
        /* mensagem: Erro da tt-erro */
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input tt-erro.cd-erro,input " ").
        for each tt-erro:
            delete tt-erro.
        end.
        apply 'entry' to item-doc-est.qt-do-forn in frame {&frame-name}.
        return 'adm-error':U.
    end.     

     if  not adm-new-record 
     and not param-re.sem-pedido
     and avail item-doc-est 
     and item-doc-est.log-1 
     and not natur-oper.terceiros 
     and not natur-oper.transf 
     and docum-est.cod-observa <> 3 then do:
        run pi-devolve-temp-table in h_b07in368 (output table tt-rat-ordem).
        assign de-qtd-aux = 0.
        for each tt-rat-ordem where tt-rat-ordem.log-2 = yes no-lock:
            assign de-qtd-aux = de-qtd-aux + tt-rat-ordem.quantidade.
        end.
        if  de-qtd-aux <> input frame {&frame-name} item-doc-est.quantidade then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15455,input " ").
            apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
            return 'adm-error':U.
        end.            
    end.

 
    if  avail ordem-compra 
    and ordem-compra.mo-codigo <> i-moeda then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",
                           input 15474,
                           input string(ordem-compra.mo-codigo) + "~~" +
                                 string(docum-est.mo-codigo)).
        apply 'entry' to item-doc-est.quantidade in frame {&frame-name}.
        return 'adm-error':U.
    end.
    if de-cotacao:sensitive in frame {&FRAME-NAME} 
       and (not avail cotacao 
            or docum-est.mo-codigo <> 0 and
               input frame {&frame-name} de-cotacao = 0) then do:
        find moeda where moeda.mo-codigo   = i-moeda no-lock no-error.
        {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show":U, input 316, input moeda.descricao + "~~" + string(docum-est.dt-emissao)).
        apply "entry" to de-cotacao in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-variacao-valor V-table-Win 
PROCEDURE pi-variacao-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    def input param de-valor-orig like item-doc-est.preco-total-me.
    def output param de-valor-max like item-doc-est.preco-total-me.
    def output param de-valor-min like item-doc-est.preco-total-me.
 
    if param-re.aceita-var then
        assign de-valor-max = round(de-valor-orig +
                              (de-valor-orig * familia.var-pre-perm / 100), 2)
               de-valor-min = round(de-valor-orig -
                              (de-valor-orig * familia.var-pre-perm / 100), 2).
    else
        assign de-valor-max = de-valor-orig
               de-valor-min = de-valor-orig.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-cotacao V-table-Win 
PROCEDURE pi-verifica-cotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    /* Atualiza a MOEDA no DOCUM-EST para a primeira entrada de item */
    find first b-item-doc-est {cdp/cd8900.i b-item-doc-est docum-est} no-lock no-error.
 
    if not available b-item-doc-est 
    and docum-est.mo-codigo = 0 then do:
        assign i-moeda = if available ordem-compra 
                                   then ordem-compra.mo-codigo
                                   else 0.
 
        if  available ordem-compra then do with frame {&FRAME-NAME}:
 
            if  ordem-compra.mo-codigo <> 0 and 
                ordem-compra.mo-codigo = i-moeda then do:
                find first cotacao 
                     where cotacao.mo-codigo = i-moeda
                     and   cotacao.ano-periodo = string(year (docum-est.dt-emissao),'9999')
                                              +  string(month(docum-est.dt-emissao),'99') no-lock no-error.
                assign de-cotacao:screen-value = if available cotacao then
                                                 string(cotacao.cotacao[day(docum-est.dt-emissao)])
                                                        else "0"
                       de-cotacao:sensitive    = yes.
            end.
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


