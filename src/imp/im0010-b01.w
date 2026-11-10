&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0010-B01 2.00.00.014 } /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0010-B01 MIM}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/browserd.w

def var v-row-parent    as rowid no-undo.
def var v-row-table  as rowid no-undo.

{include/boerrtab.i}
{cxbo/bocx085.i tt-cotacao-item-cex}

/* vari veis para o open-query */
def var i-numero-ordem as integer no-undo.
def var i-cod-emitente as integer no-undo.
def var c-it-codigo    as char no-undo.
def var i-seq-cotac    as integer no-undo.
def var d-data-cotacao as date no-undo.
def var i-mapa-cotacao as integer no-undo.

/* vari veis para o browser */
def var c-nome-abrev like emitente.nome-abrev no-undo.
def var c-descricao  like desp-imp.descricao no-undo.
def var c-moeda      like moeda.descricao no-undo.
def var c-descricao2 like cond-pagto.descricao no-undo.

def var r-chave           as rowid no-undo.
def var r-chave-criada    as rowid no-undo.
def var l-aprovado        as logical no-undo.
def var h-v02cx085        as handle no-undo.
def var l-disable-buttons as logical no-undo.

/* Global Variable Definitions */
def new global shared var gi-numero-ordem-alt like ordem-compra.numero-ordem no-undo.
def new global shared var gr-im0010-cotacao-item-cex as rowid no-undo.

{cdp/cdcfgmat.i}
&if "{&bf_mat_versao_ems}" >= "2.05" &then
  def var h-boad259 as handle no-undo.
  def var c-desc-tp-despesa like tipo-rec-desp.descricao no-undo.
  def var c-return          as character no-undo.
&endif

DEF BUFFER bfcotacao-item-cex FOR cotacao-item-cex.

def var h-bocx085         as handle no-undo.
def var l-mapa-aprovado   as logical no-undo.

&if "{&bf_mat_versao_ems}" >= "2.04" &then
  def var c-msg             as char no-undo.
  def var h-bocx225         as handle no-undo.
  
  run cxbo/bocx225.p persistent set h-bocx225.
  run cxbo/bocx085.p persistent set h-bocx085.

  def temp-table tt-embarque NO-UNDO
      field embarque as char format "x(16)".

&endif

&if "{&bf_mat_versao_ems}" >= "2.062" &then
    def temp-table tt-erro no-undo
        field i-sequen as int             
        field cd-erro  as int
        field mensagem as char format "x(255)"
        field c-param    as char .
    
    def var l-cotacao-aprovada as logical no-undo.
&endif

DEFINE VARIABLE l-permite-alter-cotac        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-permite-alter-cotac-despes AS LOGICAL    NO-UNDO.

def var h-im0010-v01 as handle no-undo.
def var h-window     as handle no-undo. /* handle da window que chama a viewer */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE BrowserCadastro2
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cotacao-item-cex

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table cotacao-item-cex.sequencia cotacao-item-cex.cod-emitente-desp fn-emitente(cotacao-item-cex.cod-emitente-desp) @ c-nome-abrev cotacao-item-cex.cod-desp fn-desp-imp(cotacao-item-cex.cod-desp) @ c-descricao cotacao-item-cex.val-desp cotacao-item-cex.mo-codigo fn-moeda(cotacao-item-cex.mo-codigo) @ c-moeda &if "{&bf_mat_versao_ems}" >= "2.062" &then cotacao-item-cex.log-recalc-val &ENDIF cotacao-item-cex.cod-cond-pag fn-cond-pagto(cotacao-item-cex.cod-cond-pag) @ c-descricao2 cotacao-item-cex.nr-tab &if "{&bf_mat_versao_ems}" >= "2.05" &then cotacao-item-cex.tp-despesa fn-desc-tp-despesa(cotacao-item-cex.tp-despesa) @ c-desc-tp-despesa &endif   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define QUERY-STRING-br-table FOR EACH cotacao-item-cex NO-LOCK where   cotacao-item-cex.numero-ordem = i-numero-ordem and   cotacao-item-cex.cod-emitente = i-cod-emitente and   cotacao-item-cex.it-codigo    = c-it-codigo and   cotacao-item-cex.seq-cotac    = i-seq-cotac and   cotacao-item-cex.mapa-cotacao = i-mapa-cotacao and   cotacao-item-cex.data-cotacao = d-data-cotacao
&Scoped-define OPEN-QUERY-br-table OPEN QUERY {&SELF-NAME} FOR EACH cotacao-item-cex NO-LOCK where   cotacao-item-cex.numero-ordem = i-numero-ordem and   cotacao-item-cex.cod-emitente = i-cod-emitente and   cotacao-item-cex.it-codigo    = c-it-codigo and   cotacao-item-cex.seq-cotac    = i-seq-cotac and   cotacao-item-cex.mapa-cotacao = i-mapa-cotacao and   cotacao-item-cex.data-cotacao = d-data-cotacao.
&Scoped-define TABLES-IN-QUERY-br-table cotacao-item-cex
&Scoped-define FIRST-TABLE-IN-QUERY-br-table cotacao-item-cex


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-table bt-incluir bt-modificar bt-eliminar ~
bt-calcula 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS
><EXECUTING-CODE>
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS>
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE>
<FILTER-ATTRIBUTES>
************************
* Initialize Filter Attributes */
RUN set-attribute-list IN THIS-PROCEDURE ('
  Filter-Value=':U).
/************************
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-cond-pagto B-table-Win 
FUNCTION fn-cond-pagto RETURNS CHARACTER
  ( input i-cod-cond-pag as integer ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-tp-despesa B-table-Win 
FUNCTION fn-desc-tp-despesa RETURNS CHARACTER
  ( input i-tp-despesa as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desp-imp B-table-Win 
FUNCTION fn-desp-imp RETURNS CHARACTER
  (input p-cod-desp as integer ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-emitente B-table-Win 
FUNCTION fn-emitente RETURNS CHARACTER
  (input p-cod-emitente as integer ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-moeda B-table-Win 
FUNCTION fn-moeda RETURNS CHARACTER
  ( input i-mo-codigo as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-calcula 
     LABEL "&Calc Valor" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-eliminar 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-incluir 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-modificar 
     LABEL "&Modificar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      cotacao-item-cex SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _FREEFORM
  QUERY br-table NO-LOCK DISPLAY
      cotacao-item-cex.sequencia
      cotacao-item-cex.cod-emitente-desp
      fn-emitente(cotacao-item-cex.cod-emitente-desp) @ c-nome-abrev
      cotacao-item-cex.cod-desp
      fn-desp-imp(cotacao-item-cex.cod-desp) @ c-descricao
      cotacao-item-cex.val-desp
      cotacao-item-cex.mo-codigo
      fn-moeda(cotacao-item-cex.mo-codigo) @ c-moeda      
      &if "{&bf_mat_versao_ems}" >= "2.062" &then
        cotacao-item-cex.log-recalc-val COLUMN-LABEL "Recalcula Valor"
      &ENDIF
      cotacao-item-cex.cod-cond-pag
      fn-cond-pagto(cotacao-item-cex.cod-cond-pag) @ c-descricao2
      cotacao-item-cex.nr-tab
      &if "{&bf_mat_versao_ems}" >= "2.05" &then
        cotacao-item-cex.tp-despesa COLUMN-LABEL "Tp Desp"
        fn-desc-tp-despesa(cotacao-item-cex.tp-despesa) @ c-desc-tp-despesa
      &endif
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 88 BY 6.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br-table AT ROW 1 COL 1
     bt-incluir AT ROW 7.5 COL 1
     bt-modificar AT ROW 7.5 COL 11
     bt-eliminar AT ROW 7.5 COL 21
     bt-calcula AT ROW 7.5 COL 31
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: BrowserCadastro2
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: External-Tables
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 7.5
         WIDTH              = 88.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
/* BROWSE-TAB br-table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH cotacao-item-cex NO-LOCK where
  cotacao-item-cex.numero-ordem = i-numero-ordem and
  cotacao-item-cex.cod-emitente = i-cod-emitente and
  cotacao-item-cex.it-codigo    = c-it-codigo and
  cotacao-item-cex.seq-cotac    = i-seq-cotac and
  cotacao-item-cex.mapa-cotacao = i-mapa-cotacao and
  cotacao-item-cex.data-cotacao = d-data-cotacao.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Query            is NOT OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-table
&Scoped-define SELF-NAME br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-table IN FRAME F-Main
DO:
  RUN New-State("DblClick, SELF":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-ENTRY OF br-table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-LEAVE OF br-table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON VALUE-CHANGED OF br-table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  /* run new-state('New-Line|':U + string(rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-calcula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-calcula B-table-Win
ON CHOOSE OF bt-calcula IN FRAME F-Main /* Calc Valor */
DO:

    &if "{&bf_mat_versao_ems}" >= "2.062" &then

        DEF VAR pval-desp LIKE cotacao-item-cex.val-desp.
      
        assign r-chave = rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).

        RUN emptyTtBoErro IN h-bocx085.
        RUN pi-calcula-despesa IN h-bocx085 (INPUT r-chave,
                                             OUTPUT pval-desp).

        RUN getTtBoErro IN h-bocx085(OUTPUT TABLE tt-bo-erro).
    
        FOR EACH tt-erro:
            DELETE tt-erro.
        END.

        FOR EACH tt-bo-erro:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = tt-bo-erro.i-sequen 
                   tt-erro.cd-erro  = tt-bo-erro.cd-erro
                   tt-erro.mensagem = tt-bo-erro.mensagem
                   tt-erro.c-param  = tt-bo-erro.parametros.
        END.

        IF  CAN-FIND(FIRST tt-erro) THEN
            RUN cdp/cd0669.w(INPUT TABLE tt-erro).

        IF  CAN-FIND(FIRST tt-bo-erro
                     WHERE tt-bo-erro.errorSubType <> "INFORMATION":U
                       AND tt-bo-erro.errorSubType <> "WARNING":U) THEN
            RETURN NO-APPLY.


        FIND FIRST bfcotacao-item-cex 
             WHERE ROWID(bfcotacao-item-cex) = r-chave EXCLUSIVE-LOCK NO-ERROR.
    
        ASSIGN bfcotacao-item-cex.val-desp       = pval-desp.
    
        IF  VALID-HANDLE(h-im0010-v01) THEN DO:
            ASSIGN gr-im0010-cotacao-item-cex = r-chave.
            RUN pi-principal IN h-im0010-v01("pri":U).
            /*RUN local-display-fields IN h-im0010-v01.
            MESSAGE 'depois local-display no bowser.'
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RUN pi-enable-panel IN h-window.*/
            
        END.

    &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar B-table-Win
ON CHOOSE OF bt-eliminar IN FRAME F-Main /* Eliminar */
DO:
    def var h-bocx085 as handle no-undo.

    

    run cxbo/bocx085.p persistent set h-bocx085.
    assign r-chave = rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
    
        RUN findRowid      IN h-bocx085 (INPUT r-chave).
        RUN validateImport IN h-bocx085. 
        IF RETURN-VALUE = "NOK" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 30099,
                               INPUT c-seg-usuario + "~~" + STRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.cod-desp)).
            RETURN.   
        END.
    &ENDIF                                                         
  
    {utp/ut-table.i mgcex cotacao-item-cex 1}
    run utp/ut-msgs.p (input "show":U,
                       input 4350,
                       input return-value).
    if return-value = "yes":U then do:
        RUN validateDelete in h-bocx085(input-output r-chave,output table tt-bo-erro).

        &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
    
            FOR EACH tt-erro:
                DELETE tt-erro.
            END.
        
            FOR EACH tt-bo-erro:
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = tt-bo-erro.i-sequen 
                       tt-erro.cd-erro  = tt-bo-erro.cd-erro
                       tt-erro.mensagem = tt-bo-erro.mensagem
                       tt-erro.c-param  = tt-bo-erro.parametros.
            END.
        
            IF  CAN-FIND(FIRST tt-erro) THEN
                RUN cdp/cd0669.w(INPUT TABLE tt-erro).
        
            IF  CAN-FIND(FIRST tt-bo-erro
                         WHERE tt-bo-erro.errorSubType <> "INFORMATION":U
                           AND tt-bo-erro.errorSubType <> "WARNING":U) THEN
                RETURN NO-APPLY.
    
        &ELSE
        
            find first tt-bo-erro no-error.
            if avail tt-bo-erro then do:
                run utp/ut-msgs.p (input "show":U,
                                   input tt-bo-erro.cd-erro,
                                   input tt-bo-erro.parametros).
            end.
    
        &ENDIF

    end.    
    run pi-atualiza.         
    &if "{&bf_mat_versao_ems}" >= "2.04" &then
        
        /* -- Verifica a tabela de emitentes -- */
        find first emitente where emitente.cod-emitente = cotacao-item-cex.cod-emitente no-lock no-error.
        find first ordem-compra where ordem-compra.numero-ordem = cotacao-item-cex.numero-ordem no-lock no-error.
        find first param-global no-lock no-error.

        /* -- Verifica se o mapa est  aprovado -- */
        RUN pi-verifica-mapa-aprovado.

        /* -- Verifica altera‡äes na ordem de compra -- */
        if (l-mapa-aprovado) and (param-global.modulo-07) and (emitente.natureza = 3 or emitente.natureza = 4) then
            run procuraEmbarqueCompras in h-bocx225 
                (input ordem-compra.num-pedido, 
                 input ordem-compra.numero-ordem, 
                 input ?, 
                 output table tt-embarque). 

       /* -- Se existir algum registro na tt-Embarque --*/
        assign c-msg = "".
        for each tt-embarque:
        if c-msg = "" then
            assign c-msg = tt-embarque.embarque.
        else
            assign c-msg = c-msg + ", " + tt-embarque.embarque.
        end.
        
        if c-msg <> "" then
        /* Inicio -- Projeto Internacional */
        DO:
        {utp/ut-liter.i "Despesas_do_Embarque" *}
        run utp/ut-msgs.p (input "show":U,
                           input 28558, 
                           input c-msg + "~~" + RETURN-VALUE).
        END. 

        FOR EACH tt-embarque:
            DELETE tt-embarque.
        END.

  &endif

  if valid-handle(h-bocx085) then
    delete procedure h-bocx085.
  assign h-bocx085 = ?.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir B-table-Win
ON CHOOSE OF bt-incluir IN FRAME F-Main /* Incluir */
DO:
  
  assign r-chave = rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).      
  RUN imp/im0010b.w(input r-chave,                    
                    input "add":U,
                    input table tt-cotacao-item-cex,
                    output r-chave-criada).
                                        
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  run pi-atualiza.  
  &if "{&bf_mat_versao_ems}" >= "2.04" &then
        
        /* -- Verifica a tabela de emitentes -- */
        find first emitente where emitente.cod-emitente = cotacao-item-cex.cod-emitente no-lock no-error.
        find first ordem-compra where ordem-compra.numero-ordem = cotacao-item-cex.numero-ordem no-lock no-error.
        find first param-global no-lock no-error.

        /* -- Verifica se o mapa est  aprovado -- */
        RUN pi-verifica-mapa-aprovado.

        /* -- Verifica altera‡äes na ordem de compra -- */
        if (l-mapa-aprovado) and (param-global.modulo-07) and (emitente.natureza = 3 or emitente.natureza = 4) then
            run procuraEmbarqueCompras in h-bocx225 
                (input ordem-compra.num-pedido, 
                 input ordem-compra.numero-ordem, 
                 input ?, 
                 output table tt-embarque). 

            /* -- Se existir algum registro na tt-Embarque --*/
            assign c-msg = "".
            for each tt-embarque:
                if c-msg = "" then
                    assign c-msg = tt-embarque.embarque.
                else
                    assign c-msg = c-msg + ", " + tt-embarque.embarque.
            end.
            
            if c-msg <> "" then do:
            
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Material_em_Trƒnsito" *}
                run utp/ut-msgs.p (input "show":U,
                                   input 28558, 
                                   input c-msg + "~~" + RETURN-VALUE).
            end.
            FOR EACH tt-embarque:
                DELETE tt-embarque.
            END.

  &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-modificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar B-table-Win
ON CHOOSE OF bt-modificar IN FRAME F-Main /* Modificar */
DO:
    
    ASSIGN r-chave = ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).
    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        
        RUN findRowid      IN h-bocx085 (INPUT r-chave).
        RUN validateImport IN h-bocx085. 
        IF RETURN-VALUE = "NOK" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 30099,
                               INPUT c-seg-usuario + "~~" + STRING({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.cod-desp)).
            RETURN.   
        END.
    &ENDIF                                                         
    if {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.cod-emitente-desp = 0 then
        RUN imp/im0010b.w(input r-chave,
                          input "mod":U,
                          input table tt-cotacao-item-cex,
                          output r-chave-criada).
    else
        RUN imp/im0010c.w(input r-chave,
                          input "mod":U,
                          input table tt-cotacao-item-cex,
                          output r-chave-criada).                        
  
    run pi-atualiza.

    &if "{&bf_mat_versao_ems}" >= "2.04" &then
  
        /* -- Verifica a tabela de emitentes -- */
        find first emitente where emitente.cod-emitente = cotacao-item-cex.cod-emitente no-lock no-error.
        find first ordem-compra where ordem-compra.numero-ordem = cotacao-item-cex.numero-ordem no-lock no-error.
        find first param-global no-lock no-error.

        /* -- Verifica se o mapa est  aprovado -- */
        RUN pi-verifica-mapa-aprovado.

        /* -- Verifica altera‡äes na ordem de compra -- */
        if (l-mapa-aprovado) and (param-global.modulo-07) and (emitente.natureza = 3 or emitente.natureza = 4) then
            run procuraEmbarqueCompras in h-bocx225 
                (input ordem-compra.num-pedido, 
                 input ordem-compra.numero-ordem, 
                 input ?, 
                 output table tt-embarque). 

       /* -- Se existir algum registro na tt-Embarque --*/
        assign c-msg = "".
        for each tt-embarque:
        if c-msg = "" then
            assign c-msg = tt-embarque.embarque.
        else
            assign c-msg = c-msg + ", " + tt-embarque.embarque.
        end.
        
        if c-msg <> "" then do:
                
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Material_em_Trƒnsito" *}
            run utp/ut-msgs.p (input "show":U,
                           input 28558, 
                           input c-msg + "~~" + RETURN-VALUE).
        end.

        FOR EACH tt-embarque:
            DELETE tt-embarque.
        END.

  &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

{utp/ut-field.i mgadm emitente nome-abrev 1}
assign c-nome-abrev:label in browse {&browse-name} = return-value.

{utp/ut-field.i mgcex desp-imp descricao 1}
assign c-descricao:label in browse {&browse-name} = return-value.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy B-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  &if "{&bf_mat_versao_ems}" >= "2.05" &then
      if valid-handle(h-boad259) then
          delete procedure h-boad259.
      assign h-boad259 = ?.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  if l-disable-buttons then   
    assign bt-incluir:sensitive in frame {&frame-name}   = no
           bt-modificar:sensitive in frame {&frame-name} = no
           bt-eliminar:sensitive in frame {&frame-name}  = no
           bt-calcula:SENSITIVE IN FRAME {&FRAME-NAME}   = NO.
  
  else 
    assign bt-incluir:sensitive in frame {&frame-name}   = yes
           bt-modificar:sensitive in frame {&frame-name} = yes
           bt-eliminar:sensitive in frame {&frame-name}  = yes
           bt-calcula:SENSITIVE IN FRAME {&FRAME-NAME}   = YES.         

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit B-table-Win 
PROCEDURE local-exit :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'exit':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */  


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &if "{&bf_mat_versao_ems}" < "2.062" &then
  
      ASSIGN bt-calcula:VISIBLE IN FRAME f-main = NO.
  
  &endif

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view B-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  apply 'value-changed':U to {&browse-name} in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza B-table-Win 
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN dispatch IN THIS-PROCEDURE ('open-query':U).  
  
    if valid-handle(h-v02cx085) then do:
        RUN pi-atualiza-parent in h-v02cx085(input r-chave).
        RUN pi-principal in h-v02cx085(input "atualiza":U). 
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle B-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter p-im0010-v01 as handle no-undo.
  def input parameter p-window     as handle no-undo. /* handle da window que chama a viewer */

  assign h-im0010-v01 = p-im0010-v01
         h-window     = p-window.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-set-constraint B-table-Win 
PROCEDURE pi-set-constraint :
def input parameter p-numero-ordem as integer no-undo.
    def input parameter p-cod-emitente as integer no-undo.
    def input parameter p-it-codigo as char no-undo.
    def input parameter p-seq-cotac as integer no-undo.
    def input parameter p-data-cotacao as date no-undo.
    def input parameter p-mapa-cotacao as integer no-undo.
    def input parameter p-handle as handle no-undo.
  
    assign i-numero-ordem = p-numero-ordem
           i-cod-emitente = p-cod-emitente
           c-it-codigo    = p-it-codigo
           i-seq-cotac    = p-seq-cotac
           d-data-cotacao = p-data-cotacao
           i-mapa-cotacao = p-mapa-cotacao
           h-v02cx085     = p-handle.
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-mapa-aprovado B-table-Win 
PROCEDURE pi-verifica-mapa-aprovado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        run verificaMapaCotAprovado in h-bocx085 (input rowid(cotacao-item-cex), 
                                                  output l-mapa-aprovado,
                                                  OUTPUT l-cotacao-aprovada). 
        IF l-mapa-aprovado AND l-cotacao-aprovada THEN 
            run utp/ut-msgs.p (input "show":U,
                               input 30077, 
                               input "").
    &ELSE
        run verificaMapaAprovado in h-bocx085 (input rowid(cotacao-item-cex), 
                                               output l-mapa-aprovado). 
    &ENDIF
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cotacao-item-cex"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
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
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verifica-buttons B-table-Win 
PROCEDURE verifica-buttons :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter p-disable-buttons as logical no-undo.    
  
  assign l-disable-buttons = p-disable-buttons.  
  
  if gi-numero-ordem-alt <> 0 and
     gi-numero-ordem-alt = i-numero-ordem then
    assign l-disable-buttons = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-cond-pagto B-table-Win 
FUNCTION fn-cond-pagto RETURNS CHARACTER
  ( input i-cod-cond-pag as integer ):
  
  find cond-pagto where cond-pagto.cod-cond-pag = i-cod-cond-pag no-lock no-error.
  if avail cond-pagto then
    RETURN cond-pagto.descricao.
  else 
    RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-tp-despesa B-table-Win 
FUNCTION fn-desc-tp-despesa RETURNS CHARACTER
  ( input i-tp-despesa as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  &if "{&bf_mat_versao_ems}" >= "2.05" &then
      if not valid-handle(h-boad259) then
          run adbo/boad259.p persistent set h-boad259.

      run findCodigo in h-boad259 (input i-tp-despesa, output c-return).
    
      if c-return = "" then
          run getCharField in h-boad259 (input "descricao", output c-return).
      else
          assign c-return = "".
      
      return c-return.
  &else
    RETURN "".   /* Function return value. */
  &endif.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desp-imp B-table-Win 
FUNCTION fn-desp-imp RETURNS CHARACTER
  (input p-cod-desp as integer ):
  
  find desp-imp where desp-imp.cod-desp = p-cod-desp no-lock no-error.
  if avail desp-imp then 
    RETURN desp-imp.descricao.
  else 
    RETURN "".       

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-emitente B-table-Win 
FUNCTION fn-emitente RETURNS CHARACTER
  (input p-cod-emitente as integer ):
      
  find emitente where emitente.cod-emitente = p-cod-emitente no-lock no-error.
  if avail emitente then  
    RETURN emitente.nome-abrev.
  else 
    RETURN "".             

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-moeda B-table-Win 
FUNCTION fn-moeda RETURNS CHARACTER
  ( input i-mo-codigo as integer ) :
  
  find moeda where moeda.mo-codigo = i-mo-codigo no-lock no-error.
  if avail moeda then
    RETURN moeda.descricao.
  else 
    RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

