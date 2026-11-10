&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V05IN163 2.00.00.071 } /*** "010071" 09/08/2024 18:01:21 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v05in163 MUT}
&ENDIF

    CREATE WIDGET-POOL.
    &Scop adm-attribute-dlg support/viewerd.w

    def var v-row-parent        as rowid    no-undo.
    def var l-pede-compra       as logical  no-undo.
    def var l-consiste-item     as logical  no-undo.
    def var l-pede-ord-prod     as logical  no-undo.
    def var l-pede-conta        as logical  no-undo.
    def var l-pede-pedordem     as logical  no-undo.
    def var l-pede-baixa-ce     as logical  no-undo.
    def var l-pede-reserva      as logical  no-undo.
    def var l-pendente          as logical  no-undo.

    def var i-sequencia         as integer  no-undo.
    def var c-it-codigo         as char     no-undo.
    def var c-item-do-forn      as char     no-undo.
    def var c-cod-refer         as char     no-undo.  
    def var l-evento            as logical  no-undo.
    def var l-erro-co           as logical  no-undo.
    def var l-resposta          as logical  no-undo.
    def var de-val-aux          as decimal  no-undo.
    def var l-contrato          as logical  no-undo.
    def var i-num-ord-inv       as integer  no-undo.
    def var h_v04in163          as handle   no-undo.
    def var h_v06in163          as handle   no-undo.  
    def var h_v08in163          as handle   no-undo.  
    def var h_b09in368          as handle   no-undo.
    def var c-nro-comp          as char     no-undo.
    def var l-novo-reg          as logical  no-undo.
    def var l-rateio            as logical  no-undo.
    def var de-quantidade       as decimal  no-undo.
    def var de-qtd-forn         as decimal  no-undo.
    def var l-habilita-fifo     as logical  no-undo.
    def var l-conta-matriz      as logical  no-undo.
    def var l-consiste-conta    as logical  no-undo.
    def var l-zoom              as logical  no-undo.
    def var c-item              like it-doc-fisico.it-codigo no-undo. 
    def var i-empresa           like param-global.empresa-prin no-undo.
    def var c-estabelec         as char     no-undo.
    def var l-multi-unid        as log      no-undo.
    def var l-erro              as log      no-undo.
    def var c-sequencia         as char     no-undo.
    DEF VAR l-alt-ordem-compra  AS LOG      NO-UNDO.
    DEF VAR l-sem-pedido        AS LOG      NO-UNDO.

    DEF VAR i-num-pedido-aux    AS INT      NO-UNDO.

    /*Auxilia alteraá∆o da conta*/
    DEFINE VARIABLE c-num-conta   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-conta-modif AS LOGICAL     NO-UNDO.
    
    def new global shared var gr-doc-fisico    as rowid no-undo.
    def new global shared var gr-pedido-compr as rowid no-undo.
    def new global shared var gr-ordem-compra as rowid no-undo.

    def new global shared var l-material-agregado as logical no-undo.

    def buffer b-it-doc-fisico for it-doc-fisico.
    DEF BUFFER b-prazo-compra  FOR prazo-compra.

    {cdp/cd0666.i}      /**  temp-table tt-erros     **/
    {bcp/bcapi011.i}    /**  temp-table tt-etq-item  **/
    {bcp/bcapi004.i}    /**  temp-table tt-prog-bc   **/
    {cdp/cdcfgdis.i}
    {cdp/cdcfgmat.i}
    {cdp/cd9731.i6}
    {cdp/cdcfgmnt.i} /* Verifica Versao */
    {cdp/cd9911.i}      /*Unidade de Nerg¢cio*/ 
    {include/tt-edit.i}
	{method/dbotterr.i}
    {cdp/cd4329.i2}   /**  Aloca/Desaloca parcela de Compra    **/
	
&if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
    {utp/ut-glob.i}
    {cdp/cd9590.i}

    DEF VAR h-cdapi024            AS HANDLE NO-UNDO.
    DEF VAR hProgramZoom          AS HANDLE NO-UNDO.
    DEF VAR c-cod-unid-negoc      AS CHAR   NO-UNDO.
    DEF VAR l-usa-unid-negoc-fifo AS LOG NO-UNDO.
    DEF VAR l-receb-unid-negoc    AS LOG INIT NO NO-UNDO.
    DEF VAR c-unid-informada      AS CHAR   NO-UNDO.
    DEF VAR c-desc-informada      AS CHAR   NO-UNDO.
    DEF VAR hMMVUnidNegoc         AS HANDLE NO-UNDO.
    DEF VAR l-desabilita          AS LOG    NO-UNDO.
    DEF VAR l-frotas              AS LOG    NO-UNDO.
    DEF VAR i-ped-alt             AS INT    NO-UNDO.
    DEF VAR i-ord-alt             AS INT    NO-UNDO.
    DEF VAR i-eve-alt             AS INT    NO-UNDO.
    DEF VAR i-par-alt             AS INT    NO-UNDO.
    DEF VAR l-calcula             AS LOG    NO-UNDO.
    
    find first param-re no-lock 
        WHERE param-re.usuario = c-seg-usuario no-error.
    if  avail param-re then
        assign l-receb-unid-negoc = param-re.log-pedir-unid-negoc.
&ENDIF

&IF "{&mguni_version}" >= "2.071" &THEN
    def var i-ep-codigo-usuario   LIKE empresa.ep-codigo   no-undo.
&ELSE
    def var i-ep-codigo-usuario   as int   no-undo.
&ENDIF

    def var h_api_cta_ctbl       as handle no-undo.
    def var h_api_ccusto         as handle no-undo.

    define var c-formato-conta  as char no-undo.
    define var c-formato-ccusto as char no-undo. 

    def temp-table tt_log_erro no-undo
        field ttv_num_cod_erro  as integer   format ">>>>,>>9" label "N£mero"         column-label "N£mero"
        field ttv_des_msg_ajuda as character format "x(40)"    label "Mensagem Ajuda" column-label "Mensagem Ajuda"
        field ttv_des_msg_erro  as character format "x(60)"    label "Mensagem Erro"  column-label "Inconsistància".

    /* Vari·veis conta ctbl */
    def var v_cod_cta_ctbl       as char   no-undo.
    def var v_titulo_cta_ctbl    as char   no-undo.
    def var v_num_tip_cta_ctbl   as int    no-undo.
    def var v_num_sit_cta_ctbl   as int    no-undo.
    def var v_ind_finalid_cta    as char   no-undo.
    /* Vari·veis centro de custo */ 
    def var v_cod_ccusto         as char   no-undo.
    def var v_titulo_ccusto      as char   no-undo.
    def var v_log_utz_ccusto     as log    no-undo.

    DEF VAR i-ordem-ant          AS INT  INIT 0  NO-UNDO.
    DEF VAR i-pedido-ant         AS INT  INIT 0  NO-UNDO.
    DEF VAR c-compl-msg          AS CHAR         NO-UNDO.

    DEFINE VARIABLE c-pedido-old AS CHARACTER   NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS it-doc-fisico.num-pedido ~
it-doc-fisico.numero-ordem it-doc-fisico.num-seq-event ~
it-doc-fisico.parcela it-doc-fisico.fifo-oc it-doc-fisico.encerra-pa ~
it-doc-fisico.baixa-ce it-doc-fisico.nr-ord-produ it-doc-fisico.item-pai ~
it-doc-fisico.cod-roteiro it-doc-fisico.op-codigo ~
it-doc-fisico.qt-etiquetas it-doc-fisico.ct-codigo it-doc-fisico.sc-codigo 
&Scoped-define ENABLED-TABLES it-doc-fisico
&Scoped-define FIRST-ENABLED-TABLE it-doc-fisico
&Scoped-Define ENABLED-OBJECTS fi-cod-unid-negoc rt-key rt-key-2 rt-key-3 ~
RECT-1 
&Scoped-Define DISPLAYED-FIELDS it-doc-fisico.num-pedido ~
it-doc-fisico.numero-ordem it-doc-fisico.num-seq-event ~
it-doc-fisico.parcela it-doc-fisico.fifo-oc it-doc-fisico.encerra-pa ~
it-doc-fisico.baixa-ce it-doc-fisico.nr-ord-produ it-doc-fisico.item-pai ~
it-doc-fisico.cod-roteiro it-doc-fisico.op-codigo ~
it-doc-fisico.qt-etiquetas it-doc-fisico.ct-codigo it-doc-fisico.sc-codigo 
&Scoped-define DISPLAYED-TABLES it-doc-fisico
&Scoped-define FIRST-DISPLAYED-TABLE it-doc-fisico
&Scoped-Define DISPLAYED-OBJECTS tg-log-usa-unid-negoc-fifo ~
c-desc-conta-ctbl c-desc-ccusto fi-cod-unid-negoc fi-des-unid-negoc 

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-num-pedido 
       MENU-ITEM m_F5           LABEL "F5 - Zoom"     
       MENU-ITEM m_F7           LABEL "F7 - Consulta" .

DEFINE MENU POPUP-MENU-numero-ordem 
       MENU-ITEM m_F5_O         LABEL "F5 - Zoom"     
       MENU-ITEM m_F7_O         LABEL "F7 - Consulta" .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-ccusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.53 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-conta-ctbl AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.53 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-unid-negoc AS CHARACTER FORMAT "X(3)" 
     LABEL "Unidade Neg¢cio":R18 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-unid-negoc AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.08.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 6.5.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 3.33.

DEFINE RECTANGLE rt-key-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 4.33.

DEFINE VARIABLE tg-log-usa-unid-negoc-fifo AS LOGICAL INITIAL no 
     LABEL "Considera Unid Neg FIFO":L29 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     it-doc-fisico.num-pedido AT ROW 1.25 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     it-doc-fisico.numero-ordem AT ROW 2.25 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     it-doc-fisico.num-seq-event AT ROW 3.25 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     it-doc-fisico.parcela AT ROW 4.25 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     it-doc-fisico.fifo-oc AT ROW 5.58 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 22.29 BY .83
     tg-log-usa-unid-negoc-fifo AT ROW 6.5 COL 2 HELP
          "Usa Unidade Negocio FIFO"
     it-doc-fisico.encerra-pa AT ROW 5.58 COL 29
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .83
     it-doc-fisico.baixa-ce AT ROW 6.5 COL 29
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .83
     it-doc-fisico.nr-ord-produ AT ROW 1.25 COL 66.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     it-doc-fisico.item-pai AT ROW 2.25 COL 66.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     it-doc-fisico.cod-roteiro AT ROW 3.25 COL 66.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     it-doc-fisico.op-codigo AT ROW 4.25 COL 66.72 COLON-ALIGNED FORMAT ">>>>9"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     it-doc-fisico.qt-etiquetas AT ROW 5.25 COL 66.72 COLON-ALIGNED FORMAT ">>>>>>>9"
          LABEL "Quantidade Etiqueta":R19
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     it-doc-fisico.ct-codigo AT ROW 7.92 COL 18.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     c-desc-conta-ctbl AT ROW 7.92 COL 37.72 COLON-ALIGNED NO-LABEL
     it-doc-fisico.sc-codigo AT ROW 8.92 COL 18.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     c-desc-ccusto AT ROW 8.92 COL 37.72 COLON-ALIGNED NO-LABEL
     fi-cod-unid-negoc AT ROW 9.92 COL 18.29 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio"
     fi-des-unid-negoc AT ROW 9.92 COL 23.43 COLON-ALIGNED HELP
          "Descriá∆o Unidade Negocio" NO-LABEL
     rt-key AT ROW 1 COL 47.72
     rt-key-2 AT ROW 7.67 COL 1
     rt-key-3 AT ROW 1 COL 1
     RECT-1 AT ROW 5.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.it-doc-fisico
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 10
         WIDTH              = 85.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-ccusto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-conta-ctbl IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-cod-unid-negoc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-des-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-des-unid-negoc:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       it-doc-fisico.num-pedido:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-num-pedido:HANDLE.

ASSIGN 
       it-doc-fisico.numero-ordem:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-numero-ordem:HANDLE.

/* SETTINGS FOR FILL-IN it-doc-fisico.op-codigo IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN it-doc-fisico.qt-etiquetas IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-log-usa-unid-negoc-fifo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       tg-log-usa-unid-negoc-fifo:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME it-doc-fisico.baixa-ce
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.baixa-ce V-table-Win
ON LEAVE OF it-doc-fisico.baixa-ce IN FRAME f-main /* Baixa Estoque */
DO:
    if doc-fisico.tipo-nota >= 4 and doc-fisico.tipo-nota <= 8 then
        if it-doc-fisico.baixa-ce:checked in frame {&frame-name} = no then do:
            enable it-doc-fisico.ct-codigo with frame {&frame-name}.
            apply 'entry' to it-doc-fisico.ct-codigo in frame {&frame-name}.
            return no-apply.
        end.
        else if item.tipo-contr <> 1 and item.tipo-contr <> 4 then
            disable it-doc-fisico.ct-codigo with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.baixa-ce V-table-Win
ON VALUE-CHANGED OF it-doc-fisico.baixa-ce IN FRAME f-main /* Baixa Estoque */
DO:

    if it-doc-fisico.baixa-ce:checked in frame {&frame-name} and l-pede-ord-prod then 
        enable it-doc-fisico.nr-ord-prod with frame {&frame-name}.
    else do with frame {&frame-name}:
        assign it-doc-fisico.nr-ord-prod:screen-value = " ".
        disable it-doc-fisico.nr-ord-prod.
    end.        

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        APPLY "leave":U TO it-doc-fisico.nr-ord-prod IN FRAME {&FRAME-NAME}.
    &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.ct-codigo V-table-Win
ON ENTRY OF it-doc-fisico.ct-codigo IN FRAME f-main /* Conta */
DO:
    ASSIGN it-doc-fisico.ct-codigo:FORMAT = "x(20)"
           it-doc-fisico.sc-codigo:FORMAT = "x(20)".
    ENABLE it-doc-fisico.sc-codigo WITH FRAME {&FRAME-NAME}.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.ct-codigo V-table-Win
ON F5 OF it-doc-fisico.ct-codigo IN FRAME f-main /* Conta */
DO:
    
    ASSIGN i-ep-codigo-usuario = i-empresa
           l-implanta = yes.

    ASSIGN it-doc-fisico.ct-codigo:FORMAT = "x(20)"
           it-doc-fisico.sc-codigo:FORMAT = "x(20)".

    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* MñDULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  "(nenhum)",         /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 
    
    IF v_titulo_cta_ctbl <> "" THEN DO:
        ASSIGN it-doc-fisico.ct-codigo:SCREEN-VALUE = v_cod_cta_ctbl
               c-desc-conta-ctbl:SCREEN-VALUE = v_titulo_cta_ctbl.
    END.

    IF c-num-conta <> it-doc-fisico.ct-codigo:SCREEN-VALUE THEN
        ASSIGN c-num-conta = it-doc-fisico.ct-codigo:SCREEN-VALUE
               l-conta-modif = YES.
    ELSE ASSIGN l-conta-modif = NO. 

END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.ct-codigo V-table-Win
ON LEAVE OF it-doc-fisico.ct-codigo IN FRAME f-main /* Conta */
DO:
    
    ASSIGN it-doc-fisico.ct-codigo:FORMAT = "x(20)"
           it-doc-fisico.sc-codigo:FORMAT = "x(20)".

    ASSIGN v_cod_cta_ctbl = it-doc-fisico.ct-codigo:SCREEN-VALUE. /* SELF:SCREEN-VALUE. */

    /* Busca dados da conta contabil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUAõ¯O DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */
    if not can-find(first tt_log_erro) then do:
        assign it-doc-fisico.ct-codigo:screen-value = v_cod_cta_ctbl.

        if v_cod_cta_ctbl <> "" then do:
            run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,            /* EMPRESA EMS2 */
                                                               input  "",                   /* PLANO CONTAS */
                                                               input  today,                /* DATA DE TRANSACAO */
                                                               output c-formato-conta,      /* FORMATO CONTA */
                                                               output table tt_log_erro).   /* ERROS */
            if c-formato-conta <> "" then assign it-doc-fisico.ct-codigo:format = c-formato-conta.
        end.
    end.

    IF RETURN-VALUE = "OK" THEN DO:
        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF NOT v_log_utz_ccusto THEN DO:
            ASSIGN it-doc-fisico.sc-codigo:SCREEN-VALUE = "".
            ASSIGN c-desc-ccusto:SCREEN-VALUE = "".

            DISABLE it-doc-fisico.sc-codigo WITH FRAME {&FRAME-NAME}.
        END.
    END.
    ELSE DO:
        ASSIGN it-doc-fisico.sc-codigo:SCREEN-VALUE = ""
               c-desc-ccusto:SCREEN-VALUE           = "".

        DISABLE it-doc-fisico.sc-codigo WITH FRAME {&FRAME-NAME}.
    END.

    ASSIGN c-desc-conta-ctbl:SCREEN-VALUE = v_titulo_cta_ctbl.

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        RUN piHabilitaUnidNeg.
        IF fi-cod-unid-negoc:SENSITIVE IN FRAME {&FRAME-NAME} = YES THEN DO:
            APPLY "entry":U TO fi-cod-unid-negoc IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
    &ENDIF
    
    IF c-num-conta <> it-doc-fisico.ct-codigo:SCREEN-VALUE THEN 
        ASSIGN c-num-conta = it-doc-fisico.ct-codigo:SCREEN-VALUE
               l-conta-modif = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-doc-fisico.ct-codigo IN FRAME f-main /* Conta */
DO:

    apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc V-table-Win
ON F5 OF fi-cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        {method/zoomfields.i &ProgramZoom  = "inzoom/z01in745.w"
                             &FieldZoom1   = "cod-unid-negoc"
                             &FieldScreen1 = "fi-cod-unid-negoc"
                             &Frame1       = {&frame-name}
                             &FieldZoom2   = "des-unid-negoc"
                             &FieldScreen2 = "fi-des-unid-negoc"
                             &Frame2       = {&frame-name}}
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc V-table-Win
ON LEAVE OF fi-cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        {include/leave.i &tabela=unid-negoc
                         &atributo-ref=des-unid-negoc
                         &variavel-ref=fi-des-unid-negoc
                         &where="unid-negoc.cod-unid-negoc = input frame {&frame-name} fi-cod-unid-negoc"}
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
    APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.fifo-oc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.fifo-oc V-table-Win
ON VALUE-CHANGED OF it-doc-fisico.fifo-oc IN FRAME f-main /* FIFO Ordem Compra */
DO:
    IF CAN-FIND(FIRST rat-ordem 
                WHERE rat-ordem.serie-docto  = doc-fisico.serie-docto
                  AND rat-ordem.nro-docto    = doc-fisico.nro-docto
                  AND rat-ordem.cod-emitente = doc-fisico.cod-emitente
                  AND rat-ordem.tipo-nota    = doc-fisico.tipo-nota    
                  AND rat-ordem.nat-operacao = ""                      
                  AND rat-ordem.sequencia    = it-doc-fisico.sequencia) THEN
        ASSIGN it-doc-fisico.fifo-oc:CHECKED   IN FRAME {&FRAME-NAME} = YES.
    ELSE DO:
        if it-doc-fisico.fifo-oc:CHECKED in frame {&frame-name} then
            assign it-doc-fisico.num-pedido:sensitive   in frame {&frame-name} = no
                   it-doc-fisico.numero-ordem:sensitive in frame {&frame-name} = no
                   it-doc-fisico.parcela:sensitive      in frame {&frame-name} = no
                   tg-log-usa-unid-negoc-fifo:SENSITIVE IN FRAME {&FRAME-NAME} = l-mat-unid-negoc.
        else             
            assign it-doc-fisico.num-pedido:sensitive   in frame {&frame-name} = yes
                   it-doc-fisico.numero-ordem:sensitive in frame {&frame-name} = yes
                   it-doc-fisico.parcela:sensitive      in frame {&frame-name} = YES
                   tg-log-usa-unid-negoc-fifo:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                   tg-log-usa-unid-negoc-fifo:CHECKED   IN FRAME {&FRAME-NAME} = NO.
    END.
               
    if i-num-pedido-aux <> 0 and
       valid-handle(h_b09in368) then 
        run pi-habilita-fifo in h_b09in368 (YES).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.item-pai
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.item-pai V-table-Win
ON F5 OF it-doc-fisico.item-pai IN FRAME f-main /* Item Pai */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z02in390.w
                       &campo=it-doc-fisico.nr-ord-prod
                       &campozoom=nr-ord-produ
                       &campo2=it-doc-fisico.item-pai
                       &campozoom2=item-pai
                       &campo3=it-doc-fisico.cod-roteiro
                       &campozoom3=cod-roteiro}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.item-pai V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-doc-fisico.item-pai IN FRAME f-main /* Item Pai */
DO:

    apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_F5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_F5 V-table-Win
ON CHOOSE OF MENU-ITEM m_F5 /* F5 - Zoom */
DO:

    apply "F5" to it-doc-fisico.num-pedido in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_F5_O
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_F5_O V-table-Win
ON CHOOSE OF MENU-ITEM m_F5_O /* F5 - Zoom */
DO:

    apply "F5" to it-doc-fisico.numero-ordem in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_F7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_F7 V-table-Win
ON CHOOSE OF MENU-ITEM m_F7 /* F7 - Consulta */
DO:

    apply "F7" to it-doc-fisico.num-pedido in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_F7_O
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_F7_O V-table-Win
ON CHOOSE OF MENU-ITEM m_F7_O /* F7 - Consulta */
DO:

    apply "F7" to it-doc-fisico.numero-ordem in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.nr-ord-produ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.nr-ord-produ V-table-Win
ON F5 OF it-doc-fisico.nr-ord-produ IN FRAME f-main /* Ordem Produá∆o */
DO:

    {include/zoomvar.i &prog-zoom="inzoom/z01in271.w"
                       &campo=it-doc-fisico.nr-ord-prod
                       &campozoom=nr-ord-produ}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.nr-ord-produ V-table-Win
ON LEAVE OF it-doc-fisico.nr-ord-produ IN FRAME f-main /* Ordem Produá∆o */
DO:

    def var l-pede-reversar as log no-undo.

    if  input frame {&frame-name} it-doc-fisico.nr-ord-prod <> 0 then do:
        find reservas 
            where reservas.nr-ord-prod = input frame {&frame-name} it-doc-fisico.nr-ord-prod 
              and reservas.it-codigo   = c-it-codigo no-lock no-error.
        if  not available reservas 
        and ambiguous reservas then do:
            assign l-pede-reserva = yes.
            find first reservas
                 where reservas.nr-ord-prod = input frame {&frame-name} it-doc-fisico.nr-ord-prod 
                   and reservas.it-codigo   = c-it-codigo no-lock no-error.
        end.                   
        else 
            assign l-pede-reserva = no.                   

        if  available reservas then 
            assign it-doc-fisico.item-pai:screen-value    in frame {&frame-name} = reservas.item-pai
                   it-doc-fisico.cod-roteiro:screen-value in frame {&frame-name} = reservas.cod-roteiro
                   it-doc-fisico.op-codigo:screen-value   in frame {&frame-name} = string(reservas.op-codigo).

        if  l-pede-reserva then                 
            enable it-doc-fisico.item-pai 
                   it-doc-fisico.cod-roteiro
                   it-doc-fisico.op-codigo with frame {&frame-name}.
        else
            disable it-doc-fisico.item-pai 
                    it-doc-fisico.cod-roteiro
                    it-doc-fisico.op-codigo with frame {&frame-name}.

        find ord-prod where 
             ord-prod.nr-ord-prod = input frame {&frame-name} it-doc-fisico.nr-ord-prod no-lock no-error.

        if  avail ord-prod 
        AND l-conta-modif = NO then do:

            ASSIGN it-doc-fisico.ct-codigo:screen-value in frame {&frame-name} = ord-prod.ct-codigo
                   it-doc-fisico.sc-codigo:screen-value in frame {&frame-name} = ord-prod.sc-codigo
                   c-num-conta = it-doc-fisico.ct-codigo:screen-value in frame {&frame-name}.

        end.
        disable it-doc-fisico.ct-codigo with frame {&frame-name}.                
    end.                                                 
    else do:
         assign it-doc-fisico.item-pai:screen-value    in frame {&frame-name} = " "
                it-doc-fisico.cod-roteiro:screen-value in frame {&frame-name} = " "
                it-doc-fisico.op-codigo:screen-value   in frame {&frame-name} = " "
                it-doc-fisico.item-pai:sensitive       in frame {&frame-name} = no
                it-doc-fisico.cod-roteiro:sensitive    in frame {&frame-name} = no
                it-doc-fisico.op-codigo:sensitive      in frame {&frame-name} = no.

         if it-doc-fisico.ct-codigo:sensitive in frame {&frame-name} = no and i-num-ord-inv = 0 then do:

             assign it-doc-fisico.ct-codigo:screen-value in frame {&frame-name} = " "
                    it-doc-fisico.sc-codigo:screen-value in frame {&frame-name} = " "
                    c-desc-conta-ctbl:screen-value in frame {&frame-name} = " "
                    c-num-conta = ""
                    l-conta-modif = NO.
            
            if ( l-pede-conta or 
               ( avail item and (item.tipo-contr = 1 or item.tipo-contr = 4) ) or 
               ( (doc-fisico.tipo-nota >= 4 and doc-fisico.tipo-nota <= 8) 
                and it-doc-fisico.baixa-ce:checked in frame {&frame-name} = no ) ) then DO:
                 assign it-doc-fisico.ct-codigo:sensitive in frame {&frame-name} = yes.

                 if  it-doc-fisico.ct-codigo:sensitive in frame {&frame-name} = YES 
                 and i-num-ord-inv = 0 THEN
                     ASSIGN it-doc-fisico.ct-codigo:screen-value in frame {&frame-name} = " "
                            it-doc-fisico.sc-codigo:screen-value in frame {&frame-name} = " "
                            c-desc-conta-ctbl:screen-value in frame {&frame-name} = " "
                            c-num-conta = ""
                            l-conta-modif = NO.

            END.
         end.
    end.

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        RUN piHabilitaUnidNeg.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.nr-ord-produ V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-doc-fisico.nr-ord-produ IN FRAME f-main /* Ordem Produá∆o */
DO:
      apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME it-doc-fisico.num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.num-pedido V-table-Win
ON ENTRY OF it-doc-fisico.num-pedido IN FRAME f-main /* Pedido */
DO:
    ASSIGN it-doc-fisico.num-pedido:modified in frame {&FRAME-NAME} = NO.
    IF l-zoom THEN DO:
        IF it-doc-fisico.num-pedido:modified in frame {&FRAME-NAME} THEN DO:
             ASSIGN it-doc-fisico.num-pedido:modified in frame {&FRAME-NAME} = NO
                    l-zoom = YES.

        END.
    END.
    ELSE 
        ASSIGN l-zoom = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.num-pedido V-table-Win
ON F5 OF it-doc-fisico.num-pedido IN FRAME f-main /* Pedido */
DO:

    run pi-recebe-handle in h_v04in163 (output c-item).

    {include/zoomvar.i &prog-zoom=inzoom/z13in274.w
                       &campo=it-doc-fisico.numero-ordem                      
                       &campo2=it-doc-fisico.num-pedido    
                       &campozoom=numero-ordem
                       &campozoom2=num-pedido
                       &parametros="run pi-recebe-parametros in wh-pesquisa 
                                        (input doc-fisico.cod-emitente, 
                                         input 1,
                                         input c-item)."}

    assign l-zoom = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.num-pedido V-table-Win
ON F7 OF it-doc-fisico.num-pedido IN FRAME f-main /* Pedido */
DO:

    find pedido-compr where 
        pedido-compr.num-pedido = input frame {&frame-name} it-doc-fisico.num-pedido 
        no-lock no-error.

    assign gr-pedido-compr = if avail pedido-compr then 
        rowid(pedido-compr) 
        else ?.

    run ccp/cc0509.w.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.num-pedido V-table-Win
ON LEAVE OF it-doc-fisico.num-pedido IN FRAME f-main /* Pedido */
DO:


    IF adm-new-record = NO THEN
        ASSIGN i-num-pedido-aux = IF AVAIL it-doc-fisico THEN it-doc-fisico.num-pedido ELSE 0.

    IF it-doc-fisico.num-pedido:modified in frame {&FRAME-NAME} = YES THEN
        ASSIGN l-zoom = NO.

    IF l-zoom = NO THEN DO:
       IF it-doc-fisico.num-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> c-pedido-old THEN DO:

           /*Campos s∆o zerados para buscar o novo numero de ordem e numero de parcela referente ao numero do pedido*/
           assign it-doc-fisico.numero-ordem:screen-value in frame {&frame-name} = string( 0 ).
           IF  (it-doc-fisico.num-pedido:modified in frame {&FRAME-NAME} = YES)  THEN
                 ASSIGN it-doc-fisico.parcela:screen-value in frame {&frame-name} = string( 0 ).
           
           ASSIGN c-pedido-old = it-doc-fisico.num-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

       END.

       run pi-pedido-ordem.

       IF c-pedido-old = "0" THEN
           disable it-doc-fisico.encerra-pa   
                   tg-log-usa-unid-negoc-fifo with frame {&frame-name}.

    END.

    

    APPLY "ENTRY" TO it-doc-fisico.numero-ordem IN FRAME {&FRAME-NAME}.
    APPLY "LEAVE" TO it-doc-fisico.numero-ordem IN FRAME {&FRAME-NAME}.

    ASSIGN tg-log-usa-unid-negoc-fifo:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.num-pedido V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-doc-fisico.num-pedido IN FRAME f-main /* Pedido */
DO:

    apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.num-seq-event
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.num-seq-event V-table-Win
ON LEAVE OF it-doc-fisico.num-seq-event IN FRAME f-main /* SeqÅància */
DO:
    IF  VALID-HANDLE(h_v06in163) THEN DO:
        /* Atualizar Preco da Ordem de Compra */

        RUN pi-ver-alt-ped-ordem.

        IF l-calcula THEN
            RUN pi-atualiza-ordem-cc IN h_v06in163 (INPUT INPUT FRAME {&FRAME-NAME} it-doc-fisico.numero-ordem,
                                                    INPUT INPUT FRAME {&FRAME-NAME} it-doc-fisico.parcela).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.numero-ordem V-table-Win
ON ENTRY OF it-doc-fisico.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:

    if  not l-zoom then   
        assign it-doc-fisico.numero-ordem:modified in frame {&FRAME-NAME} = no.

    apply "Value-Changed" to self. /*habilita/desabilita toggle-box FIFO Ordem Compra*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.numero-ordem V-table-Win
ON F5 OF it-doc-fisico.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:

    run pi-recebe-handle in h_v04in163 (output c-item).

    {include/zoomvar.i &prog-zoom=inzoom/z13in274.w
                       &campo=it-doc-fisico.numero-ordem
                       &campozoom=numero-ordem
                       &parametros="run pi-recebe-parametros in wh-pesquisa
                                        (input doc-fisico.cod-emitente,
                                         input 1,
                                         input c-item)."}

    assign l-zoom = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.numero-ordem V-table-Win
ON F7 OF it-doc-fisico.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:

    find ordem-compra where 
        ordem-compra.numero-ordem = input frame {&frame-name} it-doc-fisico.numero-ordem 
        no-lock no-error.
    assign gr-ordem-compra = if avail ordem-compra then 
        rowid(ordem-compra) 
        else ?.
    run ccp/cc0505.w.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.numero-ordem V-table-Win
ON LEAVE OF it-doc-fisico.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:
    if it-doc-fisico.numero-ordem:modified in frame {&FRAME-NAME} or  
        input frame {&frame-name} it-doc-fisico.numero-ordem = 0  then DO:
        run pi-pedido-ordem.
        ASSIGN c-pedido-old = it-doc-fisico.num-pedido:SCREEN-VALUE IN FRAME f-main. /* A variaval c-pedido-old estava sendo zerada e fazendo com que fosse feita uma nova busca
                                                                                        nas ordens do pedido. Se a ordem que o usuˇrio tinha escolhido n∆o fosse a primeira, o sistema
                                                                                        selecionava a primeira do pedido sobrepondo a escolha do usu†rio e deixava aquela que o usu†rio
                                                                                        escolheu alocada */
    END.


    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF AVAIL ord-prod THEN DO:
            IF ord-prod.origem = "MI"  AND CAN-FIND (FIRST unid-negoc-om
                                                     WHERE unid-negoc-om.num-ord = ord-prod.nr-ord-produ NO-LOCK) THEN DO:
            
                ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                       fi-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                APPLY "leave":U TO  fi-cod-unid-negoc IN FRAME {&FRAME-NAME}. 
                       

            END.
            ELSE DO:
                IF ord-prod.origem = "MV" THEN DO:

                    IF NOT VALID-HANDLE(hMMVUnidNegoc) THEN
                        RUN frbo/bofr134.p PERSISTENT SET hMmvUnidNegoc.

                    RUN canFindMatrizMMV IN hMMVUnidNegoc (INPUT ord-prod.nr-ord-produ).

                    IF RETURN-VALUE = "OK":U THEN DO:
                         ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                                fi-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                                APPLY "leave":U TO  fi-cod-unid-negoc IN FRAME {&FRAME-NAME}. 
                    END.
                    ELSE 
                        ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
                END.
                ELSE
                    ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            END.
        END.
        ELSE
            ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = YES.


       IF it-doc-fisico.numero-ordem:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0.00" THEN
           ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

    &ENDIF.

    IF INPUT FRAME {&FRAME-NAME} it-doc-fisico.numero-ordem = 0 THEN
        ASSIGN it-doc-fisico.fifo-oc:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE 
        ASSIGN it-doc-fisico.fifo-oc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               it-doc-fisico.fifo-oc:CHECKED   IN FRAME {&FRAME-NAME} = NO.


    ASSIGN tg-log-usa-unid-negoc-fifo:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.numero-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-doc-fisico.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:

    apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.numero-ordem V-table-Win
ON VALUE-CHANGED OF it-doc-fisico.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:
    /*habilita/desabilita toggle-box FIFO Ordem Compra*/

    if  it-doc-fisico.numero-ordem:screen-value in frame {&frame-name} <> "0.00" then
        assign it-doc-fisico.fifo-oc:sensitive in frame {&frame-name} = no
               &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
               tg-log-usa-unid-negoc-fifo:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               &ENDIF .
    ELSE
        assign it-doc-fisico.fifo-oc:sensitive in frame {&frame-name} = yes.
    
    ASSIGN tg-log-usa-unid-negoc-fifo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    IF it-doc-fisico.numero-ordem:MODIFIED IN FRAME {&FRAME-NAME} THEN
        ASSIGN l-alt-ordem-compra = YES. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.op-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.op-codigo V-table-Win
ON LEAVE OF it-doc-fisico.op-codigo IN FRAME f-main /* Operaá∆o */
DO:

    run pi-conta-ctbl.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.parcela V-table-Win
ON ENTRY OF it-doc-fisico.parcela IN FRAME f-main /* Parcela */
DO:

    if not l-zoom THEN DO:
        assign it-doc-fisico.parcela:modified in frame {&FRAME-NAME} = no.
        assign l-zoom = no.
    END.

    ELSE DO:
        assign it-doc-fisico.parcela:modified in frame {&FRAME-NAME} = YES.
        assign l-zoom = YES.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.parcela V-table-Win
ON F5 OF it-doc-fisico.parcela IN FRAME f-main /* Parcela */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z01in356.w
                       &campo=it-doc-fisico.parcela
                       &campozoom=parcela
                       &parametros="run pi-seta-inicial in wh-pesquisa 
                                        (input (if avail ordem-compra then rowid(ordem-compra)
                                                   else ?))."}

    assign l-zoom = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.parcela V-table-Win
ON LEAVE OF it-doc-fisico.parcela IN FRAME f-main /* Parcela */
DO:

    IF input frame {&frame-name} it-doc-fisico.numero-ordem <> 0 THEN DO:
        find prazo-compra where 
            prazo-compra.numero-ordem = input frame {&frame-name} it-doc-fisico.numero-ordem and 
            prazo-compra.parcela      = input frame {&frame-name} it-doc-fisico.parcela
            no-lock no-error.

        if not avail prazo-compra then do:
            /**  Parcela n∆o cadastrada 
            **/
            {utp/ut-table.i mgind prazo-compra 01}
            run utp/ut-msgs.p (input "show",input 47,input return-value).
            apply 'entry' to it-doc-fisico.parcela in frame {&frame-name}.
            return no-apply.
        end.
    END.

    find ordem-compra where 
        ordem-compra.numero-ordem = prazo-compra.numero-ordem 
        no-lock no-error.

    if avail ordem-compra and param-global.modulo-cn and ordem-compra.nr-contrato <> 0 then do:
        run cnp/cn9074.p (input frame {&frame-name} it-doc-fisico.numero-ordem,
                          1,
                          input frame {&frame-name} it-doc-fisico.num-seq-event,
                          0,
                          doc-fisico.dt-emissao,
                          output de-val-aux,
                          output l-erro-co,
                          output l-contrato,
                          input-output table tt-erro).
    end.                          

    if it-doc-fisico.parcela:modified in frame {&FRAME-NAME} then do:

        RUN pi-ver-alt-ped-ordem.

        IF l-calcula THEN
            run pi-atualiza-ordem-cc in h_v06in163 ( input frame {&frame-name} it-doc-fisico.numero-ordem,
                                                     input frame {&frame-name} it-doc-fisico.parcela ).
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.parcela V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-doc-fisico.parcela IN FRAME f-main /* Parcela */
DO:

    apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-doc-fisico.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.sc-codigo V-table-Win
ON ENTRY OF it-doc-fisico.sc-codigo IN FRAME f-main /* Sub-Conta */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.sc-codigo V-table-Win
ON F5 OF it-doc-fisico.sc-codigo IN FRAME f-main /* Sub-Conta */
DO:
    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT i-empresa,                             /*Empresa*/
                                                   INPUT c-estabelec,                           /*Estabelecimento */
                                                   INPUT NO,                                    /*Considera Todos os Estabelecimentos ?*/
                                                   INPUT c-cod-unid-negoc,                      /*Unidade de Negæcio*/
                                                   INPUT "",                                    /*Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,                        /*Cædigo da Conta*/
                                                   INPUT "",                                    /*Cædigo do Plano de Centro de Custo*/
                                                   INPUT today,                                 /*Data da Transa˛“o*/
                                                   OUTPUT v_cod_ccusto,                         /*Cædigo CCusto*/
                                                   OUTPUT v_titulo_ccusto,                      /*Descri˛“o CCusto*/
                                                   OUTPUT TABLE tt_log_erro ).
   
    IF v_titulo_ccusto <> "" THEN DO:
        ASSIGN SELF:SCREEN-VALUE          = v_cod_ccusto
               c-desc-ccusto:SCREEN-VALUE = v_titulo_ccusto.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.sc-codigo V-table-Win
ON LEAVE OF it-doc-fisico.sc-codigo IN FRAME f-main /* Sub-Conta */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_ccusto = input frame {&frame-name} it-doc-fisico.sc-codigo no-error.
    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

    if not can-find(tt_log_erro) then do:
        assign it-doc-fisico.sc-codigo:screen-value in frame {&frame-name} = if not can-find(first tt_log_erro) then v_cod_ccusto else "".
        assign c-desc-ccusto:screen-value           in frame {&frame-name} = if not can-find(first tt_log_erro) then v_titulo_ccusto else "".

        if v_cod_ccusto <> "" then do:
            run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,           /* EMPRESA EMS2 */
                                                           input  "",                  /* PLANO CCUSTO */
                                                           input  today, /* DATA DE TRANSACAO */
                                                           output c-formato-ccusto,    /* FORMATO CCUSTO */
                                                           output table tt_log_erro).  /* ERROS */
            if c-formato-ccusto <> "" then assign it-doc-fisico.sc-codigo:format in frame {&frame-name} = c-formato-ccusto.
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.sc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-doc-fisico.sc-codigo IN FRAME f-main /* Sub-Conta */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF         

    {utp/ut-liter.i Seq_Evento MRE L}  
    assign it-doc-fisico.num-seq-event:label in frame {&FRAME-NAME}  = return-value.

    if it-doc-fisico.num-pedido:load-mouse-pointer("image/rbm.cur")      in frame {&frame-name} then .
    if it-doc-fisico.numero-ordem:load-mouse-pointer("image/rbm.cur")    in frame {&frame-name} then .
    if it-doc-fisico.parcela:load-mouse-pointer("image/lupa.cur")        in frame {&frame-name} then .
    if it-doc-fisico.ct-codigo:load-mouse-pointer("image/lupa.cur")      in frame {&frame-name} then .
    if it-doc-fisico.sc-codigo:load-mouse-pointer("image/lupa.cur")      in frame {&frame-name} then .
    if it-doc-fisico.nr-ord-prod:load-mouse-pointer("image/lupa.cur")    in frame {&frame-name} then .
    if it-doc-fisico.item-pai:load-mouse-pointer("image/lupa.cur")       in frame {&frame-name} then .

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        if  fi-cod-unid-negoc:load-mouse-pointer("image/lupa.cur")       in frame {&frame-name} then .
    &ENDIF

    find first param-global no-lock no-error.

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

    ASSIGN tg-log-usa-unid-negoc-fifo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    assign i-num-ord-inv = 0.

    for each tt-erro:
        delete tt-erro.
    end.

    run pi-habilita-fifo in h_b09in368 (no).
    run pi-limpa-browse  in h_b09in368.

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        RUN piHabilitaUnidNeg.
    &ENDIF

    disable it-doc-fisico.encerra-pa   
            tg-log-usa-unid-negoc-fifo with frame {&frame-name}.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        FOR FIRST ord-prod
            WHERE ord-prod.nr-ord-produ = int(it-doc-fisico.nr-ord-produ:SCREEN-VALUE IN frame {&frame-name}) NO-LOCK.
        END.

        IF AVAIL ord-prod THEN DO:
            IF ord-prod.origem = "MI"  AND CAN-FIND (FIRST unid-negoc-om
                                                     WHERE unid-negoc-om.num-ord = ord-prod.nr-ord-produ NO-LOCK) THEN DO:
                
                ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
                       
            END.
            ELSE DO:
                IF ord-prod.origem = "MV" THEN DO:

                    IF NOT VALID-HANDLE(hMMVUnidNegoc) THEN
                        RUN frbo/bofr134.p PERSISTENT SET hMmvUnidNegoc.

                    RUN canFindMatrizMMV IN hMMVUnidNegoc (INPUT ord-prod.nr-ord-produ).

                    IF RETURN-VALUE = "OK":U THEN 
                        ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
                    ELSE 
                        ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
                END.
                ELSE
                    ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
            END.
        END.
        ELSE
             ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    &ENDIF.
    
    IF AVAIL doc-fisico AND doc-fisico.tipo-nota <> 4 THEN /* Entrada de Beneficiamento */
        ASSIGN it-doc-fisico.numero-ordem:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               it-doc-fisico.num-pedido:SENSITIVE IN FRAME {&FRAME-NAME}   = YES
               it-doc-fisico.parcela:SENSITIVE IN FRAME {&FRAME-NAME}      = YES.
    
    
    
    
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
    
    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        ASSIGN c-cod-unid-negoc      = fi-cod-unid-negoc:SCREEN-VALUE     IN FRAME {&FRAME-NAME}
               l-usa-unid-negoc-fifo = tg-log-usa-unid-negoc-fifo:CHECKED IN FRAME {&FRAME-NAME}.
    &ENDIF

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    if it-doc-fisico.num-pedido <> 0 then do:
        find ordem-compra where 
            ordem-compra.numero-ordem = it-doc-fisico.numero-ordem
            no-lock no-error.
        assign it-doc-fisico.num-ord-inv = IF AVAIL ordem-compra THEN ordem-compra.num-ord-inv ELSE 0.
    end.
    else
        assign it-doc-fisico.num-ord-inv = 0.

    assign l-novo-reg = no.

    /**  Grava a resposta do usuario quando a ordem de manutencao estiver 
    ***  finalizada, utilizado na atualizacao da nota (RE1005A)           
    **/
    assign it-doc-fisico.int-2 = int(l-resposta).

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        
        IF  l-mat-unid-negoc THEN
            ASSIGN it-doc-fisico.cod-unid-negoc          = c-cod-unid-negoc
                   it-doc-fisico.log-usa-unid-negoc-fifo = l-usa-unid-negoc-fifo.
    &ENDIF

    for each tt-erro:
        delete tt-erro.
    end.

    RELEASE ordem-compra.
    RELEASE ord-prod.
    RELEASE ITEM.
    /*****
    if substring(param-estoq.char-2,2,1) = "@" and 
        (can-find(funcao where funcao.cd-funcao = "adm-apb-ems-5.00" and 
        funcao.ativo = yes and 
        funcao.log-1 = yes) or    
        can-find(funcao where funcao.cd-funcao = "adm-cfl-ems-5.00" and 
        funcao.ativo = yes and 
        funcao.log-1 = yes)  )  and  
        connected("emsuni") and  
        connected("emsbas")  then do:
        run cdp/cd9765.w ( input rowid(it-doc-fisico) ).
    end.
    *****/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

    RUN pi-limpa-browse IN h_b09in368.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        IF  VALID-HANDLE(h-cdapi024) THEN
            DELETE PROCEDURE h-cdapi024.
        ASSIGN h-cdapi024 = ?.
    &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* Elimina handle's */
  delete object h_api_cta_ctbl.
  delete object h_api_ccusto.    

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
    
    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        DISABLE fi-cod-unid-negoc
                tg-log-usa-unid-negoc-fifo WITH frame {&frame-name}.
    &ENDIF

    disable it-doc-fisico.qt-etiquetas with frame {&frame-name}.

    assign l-novo-reg = no.

    for each tt-erro:
        delete tt-erro.
    end.

    /**  Consistància para habilitar fifo 
    **/
    run pi-fifo (output l-habilita-fifo).    
    run pi-habilita-fifo in h_b09in368 (l-habilita-fifo).

    ASSIGN tg-log-usa-unid-negoc-fifo:SENSITIVE IN FRAME {&FRAME-NAME} = NO. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Handle da API Conta Cont†bil */
    run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
    /* Handle da API Centro Custo */
    run prgint\utb\utb742za.py persistent set h_api_ccusto.    
 
    /* Dispatch standard ADM method.                             */

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    if available it-doc-fisico and
        not adm-new-record then do:
        /**  Consistància para habilitar fifo 
        **/
        run pi-fifo (output l-habilita-fifo).   
        if valid-handle(h_b09in368) then 
            run pi-habilita-fifo in h_b09in368 (l-habilita-fifo).
    end.

    if  available it-doc-fisico then do:
        assign i-num-ord-inv = it-doc-fisico.num-ord-inv
               c-num-conta   = it-doc-fisico.ct-codigo
               l-conta-modif = NO. 
    end.

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        if avail it-doc-fisico then
            assign fi-cod-unid-negoc:screen-value     in frame {&frame-name} = it-doc-fisico.cod-unid-negoc
                   tg-log-usa-unid-negoc-fifo:checked in frame {&frame-name} = it-doc-fisico.log-usa-unid-negoc.
        else
            assign fi-cod-unid-negoc:screen-value     in frame {&frame-name} = ""
                   tg-log-usa-unid-negoc-fifo:checked in frame {&frame-name} = no.

        ASSIGN fi-cod-unid-negoc = fi-cod-unid-negoc:SCREEN-VALUE in frame {&frame-name}.
        
        find first unid-negoc 
             where unid-negoc.cod-unid-negoc = input frame {&frame-name} fi-cod-unid-negoc
             no-lock no-error.
        if avail unid-negoc then
            assign fi-des-unid-negoc:screen-value in frame {&frame-name} = unid-negoc.des-unid-negoc.
        else
            assign fi-des-unid-negoc:screen-value in frame {&frame-name} = "".
    &endif
    
    find first doc-fisico no-lock 
         where rowid(doc-fisico) = gr-doc-fisico no-error.
    if avail doc-fisico and avail it-doc-fisico then do:
        
        find first estabelec no-lock 
             where estabelec.cod-estabel = doc-fisico.cod-estabel no-error.

        assign i-empresa = estabelec.ep-codigo when avail estabelec.

        /* CONTA */
        assign v_cod_cta_ctbl = it-doc-fisico.ct-codigo.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,           /* EMPRESA EMS2 */
                                                       input        "",                  /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,      /* CONTA */
                                                       input        doc-fisico.dt-trans, /* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl,  /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl,  /* SITUAÄ«O DA CONTA */
                                                       output       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).        /* ERROS */
        assign c-desc-conta-ctbl:screen-value in frame {&frame-name} = v_titulo_cta_ctbl.

        run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,             /* EMPRESA EMS2 */
                                                           input  "",                    /* PLANO CONTAS */
                                                           input  doc-fisico.dt-trans,   /* DATA DE TRANSACAO */
                                                           output c-formato-conta,       /* FORMATO CONTA */
                                                           output table tt_log_erro).    /* ERROS */
        if c-formato-conta <> "" then  assign it-doc-fisico.ct-codigo:format in frame {&frame-name} = c-formato-conta.

        /* CENTRO CUSTO */
        assign v_cod_ccusto = it-doc-fisico.sc-codigo.
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,               /* EMPRESA EMS2 */
                                                   input  "",                      /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,            /* CCUSTO */
                                                   input  doc-fisico.dt-trans,     /* DATA DE TRANSACAO */
                                                   output v_titulo_ccusto,         /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro).      /* ERROS */
        assign c-desc-ccusto:screen-value in frame {&frame-name} = v_titulo_ccusto.
        
        /* Formato centro de custo */
        run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,           /* EMPRESA EMS2 */
                                                       input  "",                  /* PLANO CCUSTO */
                                                       input  doc-fisico.dt-trans, /* DATA DE TRANSACAO */
                                                       output c-formato-ccusto,    /* FORMATO CCUSTO */
                                                       output table tt_log_erro).  /* ERROS */
        if c-formato-ccusto <> "" then assign it-doc-fisico.sc-codigo:format in frame {&frame-name} = c-formato-ccusto.
    END.
    ELSE DO:
        /* Retorna formato da conta contabil */
        run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                           input  "",                  /* PLANO CONTAS */
                                                           input  TODAY,               /* DATA DE TRANSACAO */
                                                           output c-formato-conta,     /* FORMATO CONTA */
                                                           output table tt_log_erro).  /* ERROS */
        if c-formato-conta <> "" then  assign it-doc-fisico.ct-codigo:format in frame {&frame-name} = c-formato-conta.

        /* Retorna formato do centro de custo */
        run pi_retorna_formato_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,     /* EMPRESA EMS2 */
                                                       input  "",                      /* PLANO CCUSTO */
                                                       input  TODAY,                   /* DATA DE TRANSACAO */
                                                       output c-formato-ccusto,        /* FORMATO CCUSTO */
                                                       output table tt_log_erro).      /* ERROS */  
        if c-formato-ccusto <> "" then assign it-doc-fisico.sc-codigo:format in frame {&frame-name} = c-formato-ccusto.
    END.

    /*Alimenta das variaveis na inicializaá∆o do programa*/
    ASSIGN c-pedido-old = IF adm-new-record = NO 
                          THEN it-doc-fisico.num-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                          ELSE "". 
           l-conta-modif = NO. 

    ASSIGN i-ped-alt = INT(it-doc-fisico.num-pedido:SCREEN-VALUE    IN FRAME {&frame-name})
           i-ord-alt = INT(it-doc-fisico.numero-ordem:SCREEN-VALUE  IN FRAME {&frame-name})
           i-eve-alt = INT(it-doc-fisico.num-seq-event:SCREEN-VALUE IN FRAME {&frame-name})
           i-par-alt = INT(it-doc-fisico.parcela:SCREEN-VALUE       IN FRAME {&frame-name}).

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    assign it-doc-fisico.qt-etiquetas:sensitive in frame {&frame-name} = param-global.modulo-cl.

    disable all with frame {&frame-name}.

    assign l-novo-reg = yes.

    run pi-habilita-fifo in h_b09in368 (no).

    if adm-new-record = yes then do:
        &if defined(ADM-MODIFY-FIELDS) &then
            enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
        &endif
    end.

    find doc-fisico where 
        rowid(doc-fisico) = gr-doc-fisico 
        no-lock no-error.

    assign l-pede-compra = (doc-fisico.tipo-nota = 1 or
                           doc-fisico.tipo-nota = 6 ) and
                           param-global.modulo-cc
           c-estabelec   = doc-fisico.cod-estabel.

    run pi-recebimento.

    if l-pede-compra then 
        enable it-doc-fisico.num-pedido
               it-doc-fisico.numero-ordem
               it-doc-fisico.parcela with frame {&frame-name}.

    if l-pede-baixa-ce then
        enable it-doc-fisico.baixa-ce with frame {&frame-name}.

    if l-pede-ord-prod and
        ( param-global.modulo-cp or param-global.modulo-mi) then 
        enable it-doc-fisico.nr-ord-prod with frame {&frame-name}.

    run pi-conta-ctbl. 

    if l-novo-reg and 
        param-re.log-1 = yes and 
        input frame {&frame-name} it-doc-fisico.numero-ordem = 0 and 
        l-pede-compra and 
        doc-fisico.tipo-nota <> 9 then do:
        if not adm-new-record and avail it-doc-fisico then do:
            find first rat-ordem where
                rat-ordem.serie-docto  = doc-fisico.serie-docto  and
                rat-ordem.nro-docto    = doc-fisico.nro-docto    and
                rat-ordem.cod-emitente = doc-fisico.cod-emitente and
                rat-ordem.tipo-nota    = doc-fisico.tipo-nota and
                rat-ordem.nat-operacao = ""                      and
                rat-ordem.sequencia    = it-doc-fisico.sequencia 
                no-lock no-error.
            if avail rat-ordem then 
                disable it-doc-fisico.num-pedido
                        it-doc-fisico.numero-ordem
                        it-doc-fisico.parcela with frame {&frame-name}.
        end.                   
        if  not avail rat-ordem or adm-new-record then DO:
        
            enable it-doc-fisico.fifo-oc with frame {&frame-name}.

            &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
                IF  l-mat-unid-negoc THEN
                    enable tg-log-usa-unid-negoc-fifo with frame {&frame-name}.
            &ENDIF
        END.
    end.  

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        RUN piHabilitaUnidNeg.
    &ENDIF

    if avail it-doc-fisico and 
       param-re.encerra-cc and
       it-doc-fisico.numero-ordem <> 0 and
       it-doc-fisico.numero-ordem:sensitive in frame {&frame-name} then
       enable it-doc-fisico.encerra-pa with frame {&frame-name}.
    else
       disable it-doc-fisico.encerra-pa with frame {&frame-name}.


    &IF DEFINED(bf_mnt_ems206b) &THEN
        FOR FIRST ord-prod
            WHERE ord-prod.nr-ord-produ = it-doc-fisico.nr-ord-produ NO-LOCK.
        END.

        IF AVAIL ord-prod THEN DO:
            IF ord-prod.origem = "MI"  AND CAN-FIND (FIRST unid-negoc-om
                                                     WHERE unid-negoc-om.num-ord = ord-prod.nr-ord-produ NO-LOCK) THEN DO:

                ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                       it-doc-fisico.numero-ordem:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                       it-doc-fisico.num-pedido:SENSITIVE IN FRAME {&FRAME-NAME}   = NO
                       it-doc-fisico.parcela:SENSITIVE IN FRAME {&FRAME-NAME}      = NO.
                disable it-doc-fisico.fifo-oc with frame {&frame-name}.
                disable tg-log-usa-unid-negoc-fifo with frame {&frame-name}.
                
                ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
                       
            END.
            ELSE DO:

                IF ord-prod.origem = "MV" THEN DO:

                    IF NOT VALID-HANDLE(hMMVUnidNegoc) THEN
                        RUN frbo/bofr134.p PERSISTENT SET hMmvUnidNegoc.

                    RUN canFindMatrizMMV IN hMMVUnidNegoc (INPUT ord-prod.nr-ord-produ).

                    IF RETURN-VALUE = "OK":U THEN DO:
                        ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                               it-doc-fisico.numero-ordem:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                               it-doc-fisico.num-pedido:SENSITIVE IN FRAME {&FRAME-NAME}   = NO
                               it-doc-fisico.parcela:SENSITIVE IN FRAME {&FRAME-NAME}      = NO.

                        DISABLE it-doc-fisico.fifo-oc WITH FRAME {&FRAME-NAME}.
                        DISABLE tg-log-usa-unid-negoc-fifo WITH FRAME {&FRAME-NAME}.
                    END.
                    ELSE
                        ASSIGN l-desabilita = YES.
                END.
                ELSE
                    ASSIGN l-desabilita = YES.
                
                IF l-desabilita THEN DO:
                    ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                           it-doc-fisico.numero-ordem:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                           it-doc-fisico.num-pedido:SENSITIVE IN FRAME {&FRAME-NAME}   = YES
                           it-doc-fisico.parcela:SENSITIVE IN FRAME {&FRAME-NAME}      = YES.
                    ENABLE it-doc-fisico.fifo-oc with frame {&frame-name}.
                    ENABLE tg-log-usa-unid-negoc-fifo with frame {&frame-name}.
                END.
            END.
        END.
        ELSE DO:
             ASSIGN it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                    it-doc-fisico.numero-ordem:SENSITIVE IN FRAME {&FRAME-NAME} = YES
                    it-doc-fisico.num-pedido:SENSITIVE IN FRAME {&FRAME-NAME}   = YES
                    it-doc-fisico.parcela:SENSITIVE IN FRAME {&FRAME-NAME}      = YES.
             ENABLE it-doc-fisico.fifo-oc with frame {&frame-name}.
             ENABLE tg-log-usa-unid-negoc-fifo with frame {&frame-name}.
        END.
        IF AVAIL doc-fisico AND (doc-fisico.tipo-nota <> 1 OR doc-fisico.tipo-nota <> 6)  THEN             
            ASSIGN it-doc-fisico.numero-ordem:SENSITIVE IN FRAME {&FRAME-NAME}     = NO       
                   it-doc-fisico.num-pedido:SENSITIVE IN FRAME {&FRAME-NAME}       = NO       
                   it-doc-fisico.parcela:SENSITIVE IN FRAME {&FRAME-NAME}          = NO.  
                   it-doc-fisico.fifo-oc:SENSITIVE IN FRAME {&FRAME-NAME}          = NO.      
                   tg-log-usa-unid-negoc-fifo:SENSITIVE IN FRAME {&FRAME-NAME}     = NO.  
    &ENDIF.

    IF l-pede-compra THEN DO:

         if it-doc-fisico.fifo-oc:checked in frame {&frame-name} then
            assign it-doc-fisico.num-pedido:sensitive   in frame {&frame-name} = no
                   it-doc-fisico.numero-ordem:sensitive in frame {&frame-name} = no
                   it-doc-fisico.parcela:sensitive      in frame {&frame-name} = no
                   tg-log-usa-unid-negoc-fifo:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        else             
            assign it-doc-fisico.num-pedido:sensitive   in frame {&frame-name} = yes
                   it-doc-fisico.numero-ordem:sensitive in frame {&frame-name} = yes
                   it-doc-fisico.parcela:sensitive      in frame {&frame-name} = YES
                   tg-log-usa-unid-negoc-fifo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        
        IF CAN-FIND(FIRST rat-ordem 
                    WHERE rat-ordem.serie-docto  = doc-fisico.serie-docto
                      AND rat-ordem.nro-docto    = doc-fisico.nro-docto
                      AND rat-ordem.cod-emitente = doc-fisico.cod-emitente
                      AND rat-ordem.tipo-nota    = doc-fisico.tipo-nota    
                      AND rat-ordem.nat-operacao = ""                      
                      AND rat-ordem.sequencia    = it-doc-fisico.sequencia) THEN DO:
            DISABLE it-doc-fisico.fifo-oc
                    tg-log-usa-unid-negoc-fifo WITH FRAME {&FRAME-NAME}.
        END.

    END.

    run local-display-fields. 

    ASSIGN i-ped-alt = 0
           i-ord-alt = 0
           i-eve-alt = 0
           i-par-alt = 0.
    
    IF INPUT FRAME {&FRAME-NAME} it-doc-fisico.numero-ordem > 0 THEN
        ASSIGN it-doc-fisico.fifo-oc:SENSITIVE IN FRAME {&FRAME-NAME} = NO.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.*/

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        IF  NOT VALID-HANDLE(h-cdapi024) THEN
            RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
    &ENDIF

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    find first doc-fisico no-lock 
         where rowid(doc-fisico) = gr-doc-fisico no-error.
    if avail doc-fisico then do:
        find first emitente no-lock 
             where emitente.cod-emitente = doc-fisico.cod-emitente no-error.
    end.

    find first param-re no-lock 
         where param-re.usuario = c-seg-usuario no-error.
    find first param-global no-lock no-error.
    
    find first estabelec no-lock 
         where estabelec.cod-estabel = doc-fisico.cod-estabel no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec.
    
    find first param-compra no-lock no-error.
    find first param-estoq no-lock no-error.  

    for first param-contrat fields ( log-1 ) no-lock: end.

    assign l-multi-unid = avail param-compra and param-compra.log-multi-unid-medid.
    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        {utp/ut-liter.i Considera_Unid_Neg_FIFO * R}
        assign tg-log-usa-unid-negoc-fifo:label  in frame {&frame-name} = trim(return-value).
        
        {utp/ut-liter.i Unidade_de_Neg¢cio * R}
        assign fi-cod-unid-negoc:label           in frame {&frame-name} = trim(return-value)
               tg-log-usa-unid-negoc-fifo:hidden in frame {&frame-name} = no
               fi-cod-unid-negoc:hidden          in frame {&frame-name} = no
               fi-des-unid-negoc:hidden          in frame {&frame-name} = no.
    &else
        assign tg-log-usa-unid-negoc-fifo:hidden in frame {&frame-name} = yes
               fi-cod-unid-negoc:hidden          in frame {&frame-name} = yes
               fi-des-unid-negoc:hidden          in frame {&frame-name} = yes.
    &endif.
        
        
    {utp/ut-liter.i Centro_de_Custo * R}
    assign it-doc-fisico.sc-codigo:label      in frame {&frame-name} = trim(return-value).
    {utp/ut-liter.i Conta * R}
    assign it-doc-fisico.ct-codigo:label      in frame {&frame-name} = trim(return-value). 
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conta-ctbl V-table-Win 
PROCEDURE pi-conta-ctbl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if (l-pede-conta or  
        (avail item and (item.tipo-contr = 1 or item.tipo-contr = 4) ) or  
        ((doc-fisico.tipo-nota >= 4 and doc-fisico.tipo-nota <= 8) 
        and it-doc-fisico.baixa-ce:checked in frame {&frame-name} = no ) ) then do:

        if  input frame {&frame-name} it-doc-fisico.nr-ord-prod = 0 then do:
            if adm-new-record then do:

                if available ordem-compra then do:

                    IF  ordem-compra.ct-codigo <> ""
                    AND l-conta-modif = NO THEN DO:
                        ASSIGN it-doc-fisico.ct-codigo:screen-value in frame {&frame-name} = ordem-compra.ct-codigo
                               c-num-conta = it-doc-fisico.ct-codigo:screen-value in frame {&frame-name}. 
                        
                        IF l-alt-ordem-compra THEN
                            ASSIGN it-doc-fisico.sc-codigo:screen-value in frame {&frame-name} = ordem-compra.sc-codigo
                                   it-doc-fisico.numero-ordem:MODIFIED IN FRAME {&FRAME-NAME}  = NO
                                   l-alt-ordem-compra                                          = NO.
                    END.
                    ELSE IF AVAIL ITEM
                    AND ITEM.tipo-contr = 4 /*DÇbito direto*/
                    AND l-conta-modif = NO THEN DO:
                        ASSIGN it-doc-fisico.ct-codigo:screen-value in frame {&frame-name} = item.ct-codigo
                               it-doc-fisico.sc-codigo:screen-value in frame {&frame-name} = item.sc-codigo
                               c-num-conta = it-doc-fisico.ct-codigo:screen-value in frame {&frame-name}.
                    END.
                    ELSE DO:
                        IF l-conta-modif = NO THEN
                            ASSIGN it-doc-fisico.ct-codigo:screen-value in frame {&frame-name} = ordem-compra.ct-codigo
                                   it-doc-fisico.sc-codigo:screen-value in frame {&frame-name} = ordem-compra.sc-codigo
                                   c-num-conta = it-doc-fisico.ct-codigo:screen-value in frame {&frame-name}. 
                    END.
                END.
                else 
                if available item then do:
                    IF item.ct-codigo <> "" 
                    AND l-conta-modif = NO THEN
                        ASSIGN it-doc-fisico.ct-codigo:screen-value in frame {&frame-name} = item.ct-codigo
                               it-doc-fisico.sc-codigo:screen-value in frame {&frame-name} = item.sc-codigo
                               c-num-conta = it-doc-fisico.ct-codigo:screen-value in frame {&frame-name}.
                end.
            end.    
            enable it-doc-fisico.ct-codigo with frame {&frame-name}.
        end.
        else do:
            if not adm-new-record then DO:
                disable it-doc-fisico.ct-codigo with frame {&frame-name}.
                disable it-doc-fisico.sc-codigo with frame {&frame-name}.
            END.
        end.
    end.
    else DO:
        IF  input frame {&frame-name} it-doc-fisico.nr-ord-prod = 0
        AND NOT adm-new-record then
            ASSIGN it-doc-fisico.ct-codigo:SCREEN-VALUE IN FRAME {&frame-name} = ""
                   it-doc-fisico.sc-codigo:SCREEN-VALUE IN FRAME {&frame-name} = ""
                   c-num-conta   = ""
                   l-conta-modif = NO.

        disable it-doc-fisico.ct-codigo with frame {&frame-name}.                
        disable it-doc-fisico.sc-codigo with frame {&frame-name}.                
    END.

    if  input frame {&frame-name} it-doc-fisico.nr-ord-prod <> 0 
    AND NOT adm-new-record then DO:
        disable it-doc-fisico.ct-codigo with frame {&frame-name}.
        disable it-doc-fisico.sc-codigo with frame {&frame-name}.
    END.

    IF NOT param-global.log-req-autom-recebto /*CD0101 - Requisicao automatica no recebimento*/
        AND CAN-FIND(FIRST ord-prod 
                     WHERE ord-prod.nr-ord-produ = int(it-doc-fisico.nr-ord-produ:SCREEN-VALUE IN frame {&frame-name})
                       AND ord-prod.origem = "MI":U) THEN DO:  /*Somente deve executar para ordens de manutencao industrial*/
        ASSIGN it-doc-fisico.ct-codigo:screen-value    IN frame {&frame-name} = ""
               c-desc-conta-ctbl:screen-value          in frame {&frame-name} = ""
               it-doc-fisico.sc-codigo:screen-value    in frame {&frame-name} = ""
               it-doc-fisico.nr-ord-produ:screen-value in frame {&frame-name} = ""
               fi-cod-unid-negoc:SCREEN-VALUE          IN FRAME {&FRAME-NAME} = "".
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-determina-depos V-table-Win 
PROCEDURE pi-determina-depos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then

    DEF OUTPUT PARAM p-depos AS CHAR NO-UNDO.
    
    DEF BUFFER b-item FOR ITEM.

    IF  NOT AVAIL param-global THEN FIND FIRST param-global NO-LOCK NO-ERROR.
    IF  NOT AVAIL param-cq     THEN FIND FIRST param-cq     NO-LOCK NO-ERROR.

    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "it-codigo").
    FIND b-item
        WHERE b-item.it-codigo = RETURN-VALUE NO-LOCK NO-ERROR.
    
    /*  Notas do Recebimento Fiscal  */
    if  AVAIL param-global AND param-global.modulo-cq 
    and AVAIL param-cq     AND param-cq.tipo-cq > 1 
    and doc-fisico.tipo-nota <> 5
    and AVAIL b-item 
    AND (b-item.contr-qualid and b-item.it-codigo <> " ") then DO:

        RUN pi-skip-lote (BUFFER b-item,
                          OUTPUT p-depos).

    END.
    else do:
        RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "num-pedido").
        if  int(return-value) <> 0 then do:
            find ordem-compra where
                 ordem-compra.numero-ordem = int(it-doc-fisico.numero-ordem:SCREEN-VALUE IN FRAME {&FRAME-NAME}) no-lock no-error.

            if  avail ordem-compra then
                assign p-depos = ordem-compra.dep-almoxar.
        end.
    end.

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fifo V-table-Win 
PROCEDURE pi-fifo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output parameter p-habilita-fifo as logical no-undo.

    if it-doc-fisico.fifo-oc:checked in frame {&frame-name} then
        assign p-habilita-fifo = yes.
    else
        assign p-habilita-fifo = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-muda-qt-etiqueta V-table-Win 
PROCEDURE pi-muda-qt-etiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param de-quant-etq like it-doc-fisico.qt-etiqueta no-undo.

    assign it-doc-fisico.qt-etiqueta:screen-value in frame {&frame-name} = string(de-quant-etq). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-baixa-estoq V-table-Win 
PROCEDURE pi-passa-baixa-estoq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param l-baixa-estoq as logical no-undo.

    assign l-baixa-estoq = it-doc-fisico.baixa-ce:checked in frame {&frame-name}.

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

    def input parameter p-handle-1 as handle no-undo.
    def input parameter p-handle-2 as handle no-undo.
    def input parameter p-handle-3 as handle no-undo.
    def input parameter p-handle-4 as handle no-undo.

    assign h_v04in163 = p-handle-1
           h_v06in163 = p-handle-2    
           h_v08in163 = p-handle-3
           h_b09in368 = p-handle-4.

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
    def input parameter p-it-codigo like item.it-codigo         no-undo.

    assign c-it-codigo = p-it-codigo
           i-sequencia = p-sequencia.

    find item where 
        item.it-codigo = c-it-codigo 
        no-lock no-error.

/*     &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then */
/*     RUN piDeterminaUnidNeg.                     */
/*     &ENDIF                                      */

    run pi-conta-ctbl. 

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
    RUN piDeterminaUnidNeg.
    &ENDIF

    /*  Consistencia do coleta de dados */

    if avail param-global and 
        param-global.modulo-cl then do:

        for each tt-etq-item:
            delete tt-etq-item.
        end.

        for each tt-prog-bc:
            delete tt-prog-bc.
        end.

        create tt-prog-bc.
        assign tt-prog-bc.cod-prog-dtsul        = "re1001"
               tt-prog-bc.cod-versao-integracao = 1
               tt-prog-bc.usuario               = c-seg-usuario
               tt-prog-bc.opcao                 = 1.

        run bcp/bcapi004.p (input-output table tt-prog-bc,
                            input-output table tt-erro).
        if return-value = "OK" then do:

            find first tt-prog-bc no-error.

            create tt-etq-item.
            assign tt-etq-item.it-codigo             = c-it-codigo
                   tt-etq-item.cod-versao-integracao = 1
                   tt-etq-item.cd-trans              = if avail tt-prog-bc then tt-prog-bc.cd-trans else "".

            run bcp/bcapi011.p (input-output table tt-etq-item).

        end.
    end.

    assign it-doc-fisico.qt-etiquetas:screen-value in frame {&frame-name} = (if  adm-new-record = yes
                                                                            then "0"
                                                                            else it-doc-fisico.qt-etiquetas:screen-value in frame {&frame-name})
           it-doc-fisico.qt-etiquetas:sensitive in frame {&frame-name}    = (if return-value <> "OK"
                                                                            then no
                                                                            else yes ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pedido-ordem V-table-Win 
PROCEDURE pi-pedido-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  input frame {&frame-name} it-doc-fisico.num-pedido <> 0 and 
        input frame {&frame-name} it-doc-fisico.numero-ordem = 0 then do:

        /* Busca primeira ordem com data de entrega mais antiga */
        for each ordem-compra
           where ordem-compra.num-pedido    = input frame {&frame-name} it-doc-fisico.num-pedido
             and ordem-compra.situacao      = 2
             and (   ordem-compra.it-codigo = c-it-codigo 
                   or c-it-codigo = " " )      no-lock,
            EACH prazo-compra no-lock
                where prazo-compra.numero-ordem  = ordem-compra.numero-ordem
                  and prazo-compra.situacao      = 2
                  and ( prazo-compra.quant-saldo - prazo-compra.dec-1 > 0 )
                by prazo-compra.data-entrega
                by prazo-compra.numero-ordem
                BY prazo-compra.parcela:

            assign it-doc-fisico.numero-ordem:screen-value in frame {&frame-name} = string(ordem-compra.numero-ordem).
                   IF  (it-doc-fisico.num-pedido:modified in frame {&FRAME-NAME} = YES)  THEN
                        it-doc-fisico.parcela:screen-value in frame {&frame-name}      = string(prazo-compra.parcela).
            leave.
        end.
    end.  

    IF it-doc-fisico.numero-ordem:MODIFIED IN FRAME {&FRAME-NAME} THEN
        ASSIGN l-alt-ordem-compra = YES.

    if input frame {&frame-name} it-doc-fisico.num-pedido = 0 and 
        input frame {&frame-name} it-doc-fisico.numero-ordem <> 0 then do:
        find ordem-compra where 
            ordem-compra.numero-ordem = input frame {&frame-name} it-doc-fisico.numero-ordem
            no-lock no-error.
        if available ordem-compra and 
            ordem-compra.num-pedido <> 0 then
            assign it-doc-fisico.num-pedido:screen-value in frame {&frame-name} = string(ordem-compra.num-pedido).
    end. 

    find ordem-compra where 
        ordem-compra.numero-ordem = input frame {&frame-name} it-doc-fisico.numero-ordem
        no-lock no-error.

    if available ordem-compra then do:
        if input frame {&frame-name} it-doc-fisico.parcela = 0 or 
            it-doc-fisico.numero-ordem:modified in frame {&FRAME-NAME} then do:
            FOR EACH prazo-compra NO-LOCK
               WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                 AND prazo-compra.situacao     = 2
                 AND ( prazo-compra.quant-saldo - prazo-compra.dec-1 ) > 0
                  by prazo-compra.data-entrega
                  by prazo-compra.numero-ordem
                  BY prazo-compra.parcela:
                IF  (it-doc-fisico.num-pedido:modified in frame {&FRAME-NAME} = YES)  THEN
                    assign it-doc-fisico.parcela:screen-value in frame {&frame-name} = string(prazo-compra.parcela).
                   
                LEAVE.
            END.
        end.

        enable it-doc-fisico.parcela with frame {&frame-name}.

        assign it-doc-fisico.nr-ord-prod:screen-value in frame {&frame-name} = string(ordem-compra.ordem-servic). 

        if  ordem-compra.ordem-servic <> 0 then do:

            find ord-prod where 
                 ord-prod.nr-ord-prod = input frame {&frame-name} it-doc-fisico.nr-ord-prod no-lock no-error.

            if  avail ord-prod then do:

                IF l-conta-modif = NO THEN
                    ASSIGN it-doc-fisico.ct-codigo:screen-value in frame {&frame-name} = ord-prod.ct-codigo
                           it-doc-fisico.sc-codigo:screen-value in frame {&frame-name} = ord-prod.sc-codigo
                           c-num-conta = it-doc-fisico.ct-codigo:screen-value in frame {&frame-name}.

                disable it-doc-fisico.ct-codigo with frame {&frame-name}.
                disable it-doc-fisico.sc-codigo with frame {&frame-name}.

                /* Busca dados da conta cont†bil */
                ASSIGN v_cod_cta_ctbl = ord-prod.ct-codigo.
                run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,               /* EMPRESA EMS2 */
                                                               input        "",                      /* PLANO DE CONTAS */
                                                               input-output v_cod_cta_ctbl,          /* CONTA */
                                                               input        ord-prod.dt-emissao,     /* DATA TRANSACAO */   
                                                               output       v_titulo_cta_ctbl,       /* DESCRICAO CONTA */
                                                               output       v_num_tip_cta_ctbl,      /* TIPO DA CONTA */
                                                               output       v_num_sit_cta_ctbl,      /* SITUAÄ«O DA CONTA */
                                                               output       v_ind_finalid_cta,       /* FINALIDADES DA CONTA */
                                                               output table tt_log_erro).            /* ERROS */ 
            
                /* Busca dados do centro de custo */
                ASSIGN v_cod_ccusto = ord-prod.sc-codigo.
                run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,               /* EMPRESA EMS2 */
                                                           input  "",                      /* CODIGO DO PLANO CCUSTO */
                                                           input  v_cod_ccusto,            /* CCUSTO */
                                                           input  ord-prod.dt-emissao,     /* DATA DE TRANSACAO */
                                                           output v_titulo_ccusto,         /* DESCRICAO DO CCUSTO */
                                                           output table tt_log_erro).      /* ERROS */
                
                assign c-desc-conta-ctbl:screen-value in frame {&frame-name} = v_titulo_cta_ctbl.
                assign c-desc-ccusto:screen-value in frame {&frame-name} = v_titulo_ccusto.

            end.
        end.            

        assign l-evento = no.
        if ordem-compra.nr-contrato <> 0 and param-global.modulo-cn then do:
            run cnp/cn9071.p (input frame {&frame-name} it-doc-fisico.numero-ordem,
                              input frame {&frame-name} it-doc-fisico.num-pedido,
                              2,
                              output l-evento,
                              output l-erro-co,
                              input-output table tt-erro).
        end.

        if l-evento and adm-new-record then                
            enable it-doc-fisico.num-seq-event with frame {&frame-name}.
        if param-re.encerra-cc = yes and 
            not l-contrato then 
            enable it-doc-fisico.encerra-pa with frame {&frame-name}.

        
        if  adm-new-record THEN
            run pi-item-cc in h_v04in163 ( ordem-compra.it-codigo ).

        /*  Atualiza Preáo da Ordem de Compra */
        RUN pi-ver-alt-ped-ordem.

        IF l-calcula THEN DO:
            run pi-atualiza-ordem-cc in h_v06in163 ( input frame {&frame-name} it-doc-fisico.numero-ordem,
                                                     input frame {&frame-name} it-doc-fisico.parcela ).

            run pi-atualiza-ordem-cc in h_v08in163 ( input frame {&frame-name} it-doc-fisico.numero-ordem ).
        END.

        if  input frame {&frame-name} it-doc-fisico.nr-ord-prod = 0 then 
            run pi-conta-ctbl.
        ELSE
            disable it-doc-fisico.ct-codigo with frame {&frame-name}.
        
        if l-multi-unid and not adm-new-record and avail ordem-compra then do:

            RUN pi-mudou-ordem-ou-pedido.
            IF RETURN-VALUE = "OK" THEN
                run pi-atualiza-un in h_v06in163.
        end.

        APPLY "leave":U TO it-doc-fisico.nr-ord-produ IN FRAME {&FRAME-NAME}.
    end.         
    else do:
        disable it-doc-fisico.parcela 
                it-doc-fisico.encerra-pa with frame {&frame-name}.

        if  not adm-new-record 
        and avail it-doc-fisico 
        and it-doc-fisico.numero-ordem <> 0 
        and input frame {&frame-name} it-doc-fisico.numero-ordem = 0 then DO:
        
            RUN pi-ver-alt-ped-ordem.

            IF l-calcula THEN
                run pi-atualiza-ordem-cc in h_v06in163 ( input frame {&frame-name} it-doc-fisico.numero-ordem,
                                                         input frame {&frame-name} it-doc-fisico.parcela ).
        END.

        if l-multi-unid then do:
            RUN pi-mudou-ordem-ou-pedido.
            IF RETURN-VALUE = "OK" THEN            
                run pi-atualiza-un in h_v06in163.
        end.
    end.

    disable it-doc-fisico.fifo-oc with frame {&frame-name}.

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
         DISABLE tg-log-usa-unid-negoc-fifo with frame {&frame-name}.
    &ENDIF

    if param-re.log-1 = yes and 
        input frame {&frame-name} it-doc-fisico.numero-ordem = 0 and 
        input frame {&frame-name} it-doc-fisico.num-pedido = 0 then do:
        if not adm-new-record and avail it-doc-fisico then 
            find first rat-ordem where
                rat-ordem.serie-docto  = it-doc-fisico.serie-docto  and
                rat-ordem.nro-docto    = it-doc-fisico.nro-docto    and
                rat-ordem.cod-emitente = it-doc-fisico.cod-emitente and
                rat-ordem.tipo-nota    = it-doc-fisico.tipo-nota and
                rat-ordem.nat-operacao = ""                         and
                rat-ordem.sequencia    = it-doc-fisico.sequencia 
                no-lock no-error.
        if  not avail rat-ordem or adm-new-record then DO:
            enable it-doc-fisico.fifo-oc with frame {&frame-name}.
                                                       
            IF  l-mat-unid-negoc
            AND it-doc-fisico.fifo-oc:CHECKED IN FRAME {&FRAME-NAME} THEN
                enable tg-log-usa-unid-negoc-fifo with frame {&frame-name}.
        END.
    end.                    

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        RUN piHabilitaUnidNeg.
    &ENDIF

    /** Hering    
    if input frame {&frame-name} it-doc-fisico.num-pedido = 0 and 
        input frame {&frame-name} it-doc-fisico.numero-ordem = 0 and
        input frame {&frame-name} it-doc-fisico.nr-ord-prod = 0 then 
        assign it-doc-fisico.ct-codigo:screen-value in frame {&frame-name} = ""
               c-desc-conta-ctbl:screen-value in frame {&frame-name} = "".
               **/               


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

    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "nro-comp").
    assign c-nro-comp = return-value.

    assign l-consiste-item = yes
           l-pede-pedordem = l-pede-compra 
           l-pede-baixa-ce = (param-re.baixa-estoq = no 
                             and ( doc-fisico.tipo-nota <> 2
                             or    c-nro-comp = "") 
                             and doc-fisico.tipo-nota <> 3
                             and doc-fisico.tipo-nota <> 7)
           l-pede-conta    = (doc-fisico.tipo-nota = 1    /*compra*/
                            OR doc-fisico.tipo-nota = 3   /*transferància*/
                            OR doc-fisico.tipo-nota = 4   /*entrada beneficiamento*/
                            OR doc-fisico.tipo-nota = 5   /*retorno beneficiamento*/
                            OR doc-fisico.tipo-nota = 6   /*entrada consignaá∆o*/
                            OR doc-fisico.tipo-nota = 8   /*devoluá∆o consignaá∆o*/
                            OR doc-fisico.tipo-nota = 9   /*nota rateio*/
                            OR doc-fisico.tipo-nota = 10  /*remessa entrega futura*/
                            OR doc-fisico.tipo-nota = 11  /*remessa faturamento antecipado*/
                            OR doc-fisico.tipo-nota = 12  /*entrada dep¢sito fechado*/
                            OR doc-fisico.tipo-nota = 13  /*retorno dep¢sito fechado*/
                            OR doc-fisico.tipo-nota = 14  /*entrada armazÇm geral*/
                            OR doc-fisico.tipo-nota = 15) /*retorno armazÇm geral*/ 
           l-pede-ord-prod = doc-fisico.tipo-nota <> 2. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-skip-lote V-table-Win 
PROCEDURE pi-skip-lote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEF PARAM BUFFER b-item-1 FOR ITEM.
    DEF OUTPUT PARAM p-depos AS CHAR NO-UNDO.

    DEF VAR l-sugere-cq AS LOG NO-UNDO.
    DEF VAR i-indice-cq AS INT NO-UNDO.
    DEF VAR i-ind       AS INT NO-UNDO.
    DEF VAR c-cod-unid-negoc-aux AS CHAR NO-UNDO.
    DEF VAR i-tp-skip-lote-aux AS INT NO-UNDO.
        
    assign l-sugere-cq = yes.
    
    if  AVAIL param-cq
    AND param-cq.tipo-cq = 3 then do:
                
                &IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
                        FIND FIRST item-fornec-estab
                WHERE item-fornec-estab.it-codigo    = b-item-1.it-codigo
                AND   item-fornec-estab.cod-emitente = doc-fisico.cod-emitente
                AND   item-fornec-estab.cod-estabel  = doc-fisico.cod-estabel NO-LOCK NO-ERROR.

            if  AVAIL item-fornec-estab 
            AND item-fornec-estab.tp-inspecao > 3 then do:
                        ASSIGN i-ind = item-fornec-estab.tp-inspecao - 3.
                                IF CAN-FIND(FIRST funcao 
                                                        WHERE funcao.cd-funcao = "lote-avancado" 
                                                        AND   funcao.ativo     = true NO-LOCK) THEN DO:
                                        FIND fda-param-inspec-fornec WHERE fda-param-inspec-fornec.cdn-emit = doc-fisico.cod-emitente NO-LOCK NO-ERROR .
                                        IF AVAIL fda-param-inspec-fornec THEN DO:
                                                CASE item.criticidade:
                                                        WHEN 1 THEN do:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-3.
                                END CASE.
                                
                            END.
                                                        WHEN 2 THEN do:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-3.
                                END CASE.
                            end. 
                                                        WHEN 3 THEN DO:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-3.
                                END CASE.
                            END.
                                                END CASE.
                                                ASSIGN i-tp-skip-lote-aux = fda-param-inspec-fornec.idi-tip-skip-lote.
                                        END.
                                        ELSE DO:
                                                FIND emitente WHERE emitente.cod-emitente = doc-fisico.cod-emitente NO-LOCK NO-ERROR.
                                                FIND fda-param-inspec WHERE fda-param-inspec.cdn-grp-emit = emitente.cod-gr-forn NO-LOCK NO-ERROR.
                                                IF AVAIL fda-param-inspec THEN DO:
                                                        CASE item.criticidade:
                                                                WHEN 1 THEN do:
                                    CASE i-ind:
                                        WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-1.
                                        WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-2.
                                        WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-3.
                                    END CASE.
                                END.
                                                        WHEN 2 THEN do:
                                    CASE i-ind:
                                        WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-1.
                                        WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-2.
                                        WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-3.
                                    END CASE.
                                end. 
                                                        WHEN 3 THEN DO:
                                    CASE i-ind:
                                        WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-1.
                                        WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-2.
                                        WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-3.
                                    END CASE.
                                END.
                                                        END CASE.
                                                        ASSIGN i-tp-skip-lote-aux = fda-param-inspec.idi-tip-skip-lote.
                                                END.
                                                ELSE DO:
                                                        CASE item.criticidade:
                                                                WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3].
                                                                WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3].
                                                                WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3].
                                                        END CASE.
                                                        ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
                                                END.
                                        END.
                                END.
                                ELSE DO:
                                        CASE item.criticidade:
                                                WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3].
                                                WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3].
                                                WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3].
                                        END CASE.
                                        ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
                                END.
                                        
                                if  i-tp-skip-lote-aux = 1 then
                                        assign l-sugere-cq = ( random(0,100) <= i-indice-cq ).
                                else do:
                                         assign l-sugere-cq = no.
                                         if  i-indice-cq <= item-fornec-estab.niv-inspecao then 
                                                 assign l-sugere-cq = yes.
                                end.
            end.
            else
                assign l-sugere-cq = yes.
                        
        &ELSE &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
            FIND FIRST item-fornec-estab
                WHERE item-fornec-estab.it-codigo    = b-item-1.it-codigo
                AND   item-fornec-estab.cod-emitente = doc-fisico.cod-emitente
                AND   item-fornec-estab.cod-estabel  = doc-fisico.cod-estabel NO-LOCK NO-ERROR.

            if  AVAIL item-fornec-estab 
            AND item-fornec-estab.tp-inspecao > 3 then do:
    
                    CASE b-item-1.criticidade:
                        WHEN 1 then assign i-indice-cq = param-cq.ins-pref-x [item-fornec-estab.tp-inspecao - 3].
                        WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y [item-fornec-estab.tp-inspecao - 3].
                        WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z [item-fornec-estab.tp-inspecao - 3].
                    END CASE.
        
                    if  param-cq.tp-skip-lot = 1 then
                        assign l-sugere-cq = ( random(0,100) <= i-indice-cq ).
                    else do:
                         assign l-sugere-cq = no.
                         if  i-indice-cq <= item-fornec-estab.niv-inspecao then 
                             assign l-sugere-cq = yes.
                    end.
            end.
            else
                assign l-sugere-cq = yes.
        &else
            &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
                IF CAN-FIND(FIRST funcao
                            WHERE funcao.cd-funcao = "spp-cq-itfornest":U
                            AND   funcao.ativo     = YES NO-LOCK) THEN DO:
    
                    FIND FIRST item-fornec-estab
                        WHERE item-fornec-estab.it-codigo    = b-item-1.it-codigo
                        AND   item-fornec-estab.cod-emitente = doc-fisico.cod-emitente
                        AND   item-fornec-estab.cod-estabel  = doc-fisico.cod-estabel NO-LOCK NO-ERROR.

                    if  AVAIL item-fornec-estab 
                    AND item-fornec-estab.tp-inspecao > 3 then do:
            
                            CASE b-item-1.criticidade:
                                WHEN 1 then assign i-indice-cq = param-cq.ins-pref-x [item-fornec-estab.tp-inspecao - 3].
                                WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y [item-fornec-estab.tp-inspecao - 3].
                                WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z [item-fornec-estab.tp-inspecao - 3].
                            END CASE.
                
                            if  param-cq.tp-skip-lot = 1 then
                                assign l-sugere-cq = ( random(0,100) <= i-indice-cq ).
                            else do:
                                 assign l-sugere-cq = no.
                                 if  i-indice-cq <= item-fornec-estab.niv-inspecao then 
                                     assign l-sugere-cq = yes.
                            end.
                    end.
                    else
                        assign l-sugere-cq = yes.
                END.
            &else
                find item-fornec 
                    where item-fornec.it-codigo = b-item-1.it-codigo
                    and item-fornec.cod-emite = doc-fisico.cod-emitente NO-LOCK no-error.
    
                    if  avail item-fornec then do:
                        if  item-fornec.tp-inspecao > 3 then do:
                            
                            CASE b-item-1.criticidade:
                                WHEN 1 then assign i-indice-cq = param-cq.ins-pref-x [item-fornec.tp-inspecao - 3].
                                WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y [item-fornec.tp-inspecao - 3].
                                WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z [item-fornec.tp-inspecao - 3].
                            END CASE.
                
                            if  param-cq.tp-skip-lot = 1 then
                                assign l-sugere-cq = ( random(0,100) <= i-indice-cq ).
                            else do:
                                 assign l-sugere-cq = no.
                                 if  i-indice-cq <= item-fornec.niv-inspecao then 
                                     assign l-sugere-cq = yes.
                            END.
                        END.
                        else
                            assign l-sugere-cq = yes.
                    END.
            &endif                              
         &endif
                 &ENDIF

        &if "{&BF_MAT_VERSAO_EMS}" >= "2.04" &then
            if  l-sugere-cq then do:
        
        
                IF  fi-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
                    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
                        IF  VALID-HANDLE(h-cdapi024) THEN
                            RUN RetornaUnidadeNegocioExternaliz IN h-cdapi024 (INPUT doc-fisico.cod-estabel,
                                                                               INPUT b-item-1.it-codigo,
                                                                               INPUT "",
                                                                               OUTPUT c-cod-unid-negoc-aux).
                    &else
                        ASSIGN c-cod-unid-negoc-aux = fi-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
                    &endif
                END.
                ELSE
                    ASSIGN c-cod-unid-negoc-aux = fi-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        
                &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
                    FIND unid-negoc-cq
                        WHERE unid-negoc-cq.cod-estabel    = doc-fisico.cod-estabel
                          AND unid-negoc-cq.cod-unid-negoc = c-cod-unid-negoc NO-LOCK NO-ERROR.
                    IF  AVAIL unid-negoc-cq THEN
                        ASSIGN p-depos = unid-negoc-cq.cod-depos-cq.
                    ELSE DO:
                        FIND estabelec
                            WHERE estabelec.cod-estabel = doc-fisico.cod-estabel NO-LOCK NO-ERROR.
                        IF  AVAIL estabelec THEN
                            assign p-depos = estabelec.deposito-cq.
                    END.
                &else
                    FIND estabelec
                        WHERE estabelec.cod-estabel = doc-fisico.cod-estabel NO-LOCK NO-ERROR.
                    IF  AVAIL estabelec THEN
                        assign p-depos = estabelec.deposito-cq.                
                &endif
            end.
        &endif

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-estado-ord-prod V-table-Win 
PROCEDURE pi-valida-estado-ord-prod :
/*------------------------------------------------------------------------------
  Purpose:     pi-valida-estado-ord-prod
  Parameters:  <none>
  Notes:       Verificaá∆o do Estado da Ordem de Produá∆o ~\ Manutená∆o
------------------------------------------------------------------------------*/
/*****************************************************************
** Ordens de Manutená∆o Industrial (MI)
*****************************************************************/
if param-global.modulo-mi then do:
    /** Busca a Ordem de Manutená∆o **/
    find FIRST ord-manut 
         where ord-manut.nr-ord-prod = ord-prod.nr-ord-prod no-lock no-error.
    if avail ord-manut then do:
        /** Estado Suspensa **/
        if ord-manut.estado-om = 3 then do:
            /**  PERGUNTA: Ordem de manutená∆o Suspensa **/
            run utp/ut-msgs.p (input "show",input 30673,input " ").
            assign l-resposta = if  return-value = "yes"
                                then yes
                                else no.
            /** Resposta negativa, retorna erro **/
            if not(l-resposta) then do:
                return 'adm-error':U.
            end.
        end.    
        /** Estado Terminada **/
        if ord-manut.estado-om = 4 then do:
            /** ERRO: Ordem de manutená∆o terminada **/
            if ord-manut.estado = 8 then do:
                run utp/ut-msgs.p (input "show",input 5676,input " ").
                return 'adm-error':U.
            end.    
            /** PERGUNTA: Ordem de manutená∆o finalizada **/
            if ord-manut.estado = 7 then do:
                IF CAN-FIND(first funcao 
                            where funcao.cd-funcao = "spp-ativa-ordem-term":U
                            and  funcao.ativo no-lock) THEN DO:
                    run utp/ut-msgs.p (input "show",input 16314,input " ").
                    assign l-resposta = if  return-value = "yes"
                                        then yes
                                        else no.
                    /** Resposta negativa, retorna erro **/
                    if not l-resposta then
                        return 'adm-error':U.
                END.
                ELSE DO:
                    run utp/ut-msgs.p (input "show",input 26831,input " ").
                    return 'adm-error':U.
                END.
            end.          
        end.    
    end.
end.
if not avail ord-manut and (ord-prod.estado = 7 or ord-prod.estado = 8 ) then do:
    /*****************************************************************
    ** Ordens de Manutená∆o Mecanica (MV)
    *****************************************************************/
    IF ord-prod.origem = "MV":U THEN DO:
        /** PERGUNTA: Ordem de manutená∆o finalizada **/
        IF ord-prod.estado = 7 THEN DO:
            run utp/ut-msgs.p (input "show",input 16314,input " ").
            assign l-resposta = if  return-value = "yes"
                                then yes
                                else no.
            /** Resposta negativa, retorna erro **/
            if not l-resposta then do:
                return 'adm-error':U.
            end.
        END.
        /** ERRO: Ordem de manutená∆o terminada **/
        ELSE DO:
            run utp/ut-msgs.p (input "show",input 5676,input " ").
            return 'adm-error':U.
        END.
    END.
    /*****************************************************************
    ** Ordens de Produá∆o (CP, SF, CF, DP, PD, IN, PL,....)
    *****************************************************************/
    ELSE DO:
        /**  ERRO: Ordem de produá∆o j† esta finalizada **/
        IF ord-prod.estado = 7 THEN DO:
            run utp/ut-msgs.p (input "show",input 1202,input " ").
            return 'adm-error':U.
        END.
        /**  ERRO: Ordem de produá∆o j† esta terminada **/
        IF ord-prod.estado = 8 THEN DO:
            run utp/ut-msgs.p (input "show",input 1201,input " ").
            return 'adm-error':U.
        END.
    END.
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

    DEF VAR l-erro-refer AS LOGICAL NO-UNDO.
	DEFINE VARIABLE h-re1008       AS HANDLE	  NO-UNDO.

    APPLY "leave":U TO it-doc-fisico.numero-ordem in frame {&frame-name}.
    APPLY "leave":U TO it-doc-fisico.parcela in frame {&frame-name}.

    IF it-doc-fisico.nr-ord-produ:SENSITIVE IN FRAME {&FRAME-NAME} = YES THEN DO:
        APPLY 'leave':U to it-doc-fisico.nr-ord-produ in frame {&FRAME-NAME}.
    END.

    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

    ASSIGN it-doc-fisico.ct-codigo:FORMAT = "x(20)"
           it-doc-fisico.sc-codigo:FORMAT = "x(20)".

    /*** Valida Formato Conta ***/
    if c-formato-conta = "" then do:
        run utp/ut-msgs.p (input "show",
                           input 9,
                           input " ").
         apply 'entry':U to it-doc-fisico.ct-codigo in frame {&FRAME-NAME}.
         return 'adm-error'.
    end.       

    find first item no-lock 
         where item.it-codigo = c-it-codigo no-error.

    run pi-recebe-refer in h_v04in163 (output c-cod-refer).

    if input frame {&frame-name} it-doc-fisico.num-pedido   <> 0 or  
       input frame {&frame-name} it-doc-fisico.numero-ordem <> 0 then do:

        find first ordem-compra no-lock 
             where ordem-compra.numero-ordem = input frame {&frame-name} it-doc-fisico.numero-ordem no-error.
        if not available ordem-compra then do:
            /* Ordem de compra n∆o cadastrada */
            {include/i-vldprg.i}
            {utp/ut-table.i mgind ordem-compra 01}
            run utp/ut-msgs.p (input "show",input 47,input return-value).
            apply 'entry' to it-doc-fisico.numero-ordem in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if ordem-compra.num-pedido = 0 then do:
            /* Ordem de compra n∆o possui pedido */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15185,input " ").
            apply 'entry' to it-doc-fisico.numero-ordem in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if not l-min-mmi then do:
            if ordem-compra.num-ord-inv <> 0 and input frame {&frame-name} it-doc-fisico.nr-ord-produ <> 0 then do:
                /**  Ordem Compra relacionada a Ordem Inv n∆o permite relacionamento com Ordem Prod **/
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 28223, input " ").
                apply 'entry' to it-doc-fisico.nr-ord-produ in frame {&frame-name}.
                return 'adm-error':U.
            end.
        end.

        find first pedido-compr no-lock 
             where pedido-compr.num-pedido = input frame {&frame-name} it-doc-fisico.num-pedido no-error.
        if not available pedido-compr then do:
            /**  Pedido de compra n∆o cadastrado **/
            {include/i-vldprg.i}
            {utp/ut-table.i mgind pedido-compr 01}
            run utp/ut-msgs.p (input "show",input 47,input return-value).
            apply 'entry' to it-doc-fisico.num-pedido in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if pedido-compr.situacao = 3 then do:
            /**  Pedido de compra eliminado **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 7169,input " ").
            apply 'entry' to it-doc-fisico.num-pedido in frame {&frame-name}.
            return 'adm-error':U.
        end.
		
	    /*
	    Valida bloqueio quando estabelecimento de entrega do pedido for diferente do estabelecimento do documento
	    */
        empty temp-table RowErrors.
	    run rep/re1008.p persistent set h-re1008.
	    run pi-execute in h-re1008 (input pedido-compr.num-pedido,
								    input doc-fisico.cod-estabel,
								    input "",
		  	    				    OUTPUT TABLE RowErrors APPEND).
	    delete procedure h-re1008.
	    h-re1008 = ?.				
	    if can-find(first RowErrors where RowErrors.ErrorNumber = 57853) then
	        for first rowerrors:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT RowErrors.errornumber,
                                   INPUT "").
				apply 'entry' to it-doc-fisico.num-pedido in frame {&frame-name}.
                RETURN 'adm-error':U.
            end.
	    else 
			if pedido-compr.end-entrega <> doc-fisico.cod-estabel then do:
				/**  Estabelecimento de entrega do pedido Ç diferente do estabelecimento do documento. Confirma? **/
				{include/i-vldprg.i}
				run utp/ut-msgs.p (input "show",input 6814,input " ").
				if return-value <> "yes" then do:
					apply 'entry' to it-doc-fisico.num-pedido in frame {&frame-name}.
					return 'adm-error':U.
				end.
			end.                
        
        empty temp-table RowErrors.
        run rep/re1007.p (input pedido-compr.cod-emitente,
                          input doc-fisico.cod-emitente,
                          input-output table RowErrors).
        if can-find (first RowErrors where RowErrors.errornumber = 18801) then do:
            /**  usu rio pode receber pedidos de um outro fornecedor **/
            {include/i-vldprg.i} 
            run utp/ut-msgs.p (input "show":U, input 5696, input "").
            if return-value = "no" then do:
                APPLY "entry" to it-doc-fisico.num-pedido in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
        end.
        if can-find (first RowErrors where RowErrors.errornumber = 8851) then do:
            {include/i-vldprg.i} 
            RUN utp/ut-msgs.p (input "show":U, input 8851, input "").
            apply "entry" to it-doc-fisico.num-pedido in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.

        if input frame {&frame-name} it-doc-fisico.num-pedido <> ordem-compra.num-pedido then do:
            /**  Ordem de compra n∆o pertence ao pedido **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 7342,input " ").
            apply 'entry' to it-doc-fisico.numero-ordem in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if c-it-codigo <> ordem-compra.it-codigo and doc-fisico.char-1 <> "re3001h" then do:
            /**  Item da ordem n∆o confere com item da nota fiscal **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15187,input " ").
            apply 'entry' to it-doc-fisico.numero-ordem in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if ordem-compra.situacao <> 2 then do:
            /**  Situaá∆o da ordem n∆o permite movimentaá∆o **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15188,input " ").
            apply 'entry' to it-doc-fisico.numero-ordem in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if param-compra.log-1 then do:
            run cdp/cdapi172.p (input 4, input rowid(ordem-compra), output l-pendente).
            if not l-pendente then
                run cdp/cdapi172.p (input 6, input rowid(ordem-compra), output l-pendente).
            if l-pendente then do:
                run utp/ut-msgs.p (input "show", input 17022, input "").
                return 'adm-error':U.
            end.
        end.

        find first prazo-compra no-lock 
             where prazo-compra.numero-ordem = input frame {&frame-name} it-doc-fisico.numero-ordem 
               and prazo-compra.parcela      = input frame {&frame-name} it-doc-fisico.parcela no-error.
        if not available prazo-compra then do:
            /**  Parcela n∆o cadastrada **/
            {include/i-vldprg.i}
            {utp/ut-table.i mgind prazo-compra 01}
            run utp/ut-msgs.p (input "show",input 47,input return-value).
            apply 'entry' to it-doc-fisico.parcela in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if prazo-compra.situacao <> 2 then do:
            /**  Situaá∆o da parcela n∆o permite movimentá∆o **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 6897,input " ").
            apply 'entry' to it-doc-fisico.parcela in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if avail ordem-compra and ordem-compra.nr-contrato <> 0 and param-global.modulo-cn then do:
            run cnp/cn9074.p (input frame {&frame-name} it-doc-fisico.numero-ordem,
                              1,
                              input frame {&frame-name} it-doc-fisico.num-seq-event,
                              0,
                              doc-fisico.dt-emissao,
                              output de-val-aux,
                              output l-erro-co,
                              output l-contrato,
                              input-output table tt-erro).
        end.
        if not l-contrato then do:
            if prazo-compra.data-entrega > doc-fisico.dt-emissao + param-re.variacao or  
               prazo-compra.data-entrega < doc-fisico.dt-emissao - param-re.variacao then do:
                /**  Data de entrega da parcela esta fora da variaá∆o. Confirma? **/
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",input 7179,input " ").
                if return-value <> "yes" then do:                               
                    apply 'entry' to it-doc-fisico.parcela in frame {&frame-name}.
                    return 'adm-error':U.
                end.
            end.
        end.

        if  avail prazo-compra
        and prazo-compra.cod-refer <> c-cod-refer then do:
            /*Referencia da parcela da OC eh diferente do item da nota*/
            run utp/ut-msgs.p (input "show",input 56951,input " ").
            assign l-erro-refer = yes.
        end.
        else
            assign l-erro-refer = no.

        if can-find(funcao where
                    funcao.cd-funcao = "spp-consist-refer-nf" and
                    funcao.ativo) then do:
            run rep/re8885.p (rowid(doc-fisico),
                              0,
                              0,
                              56951, /*Referencia da parcela da OC eh diferente do item da nota*/
                              (not l-erro-refer), /*elimina consit nota*/
                              i-sequencia,
                              2). /*tipo 1=erro 2=advertencia*/
        end.
    end.
    else do:
        RUN executarEngineRecSemPedido.
        if l-pede-pedordem and 
            input frame {&frame-name} it-doc-fisico.numero-ordem = 0 and 
            not l-sem-pedido and not input frame {&frame-name} it-doc-fisico.fifo-oc then do:
            /**  Deve ser informado Pedido/Ordem de compra **/
            {include/i-vldprg.i}
            {utp/ut-liter.i Pedido/Ordem * L}
            run utp/ut-msgs.p (input "show",input 54,input return-value).
            apply 'entry' to it-doc-fisico.num-pedido in frame {&frame-name}.
            return 'adm-error':U.
        end.

        /* Somente por FIFO. Valida se os pedidos est∆o aprovados. */
        if  it-doc-fisico.fifo-oc:checked in frame {&frame-name} then do:
            assign l-erro-refer = no.

            for each  rat-ordem 
                where rat-ordem.serie-docto  = doc-fisico.serie-docto
                and   rat-ordem.nro-docto    = doc-fisico.nro-docto
                and   rat-ordem.cod-emitente = doc-fisico.cod-emitente
                and   rat-ordem.tipo-nota    = doc-fisico.tipo-nota
                and   rat-ordem.nat-operacao = ""
                and   rat-ordem.sequencia    = it-doc-fisico.sequencia no-lock:
                for first ordem-compra
                    where ordem-compra.numero-ordem = rat-ordem.numero-ordem no-lock: end.

                if  param-compra.log-1 and avail ordem-compra then do:
                    run cdp/cdapi172.p (input 4, input rowid(ordem-compra), output l-pendente).
                    if not l-pendente then
                        run cdp/cdapi172.p (input 6, input rowid(ordem-compra), output l-pendente).
                    if l-pendente then do:
                        run utp/ut-msgs.p (input "show", input 17022, input "").
                        return 'adm-error':U.
                    end.
                end.

                for first prazo-compra fields (numero-ordem parcela cod-refer)
                    where prazo-compra.numero-ordem = rat-ordem.numero-ordem
                      and prazo-compra.parcela      = rat-ordem.parcela
                      and prazo-compra.cod-refer   <> c-cod-refer no-lock:
                    /*Referencia da parcela da OC eh diferente do item da nota*/
                    run utp/ut-msgs.p (input "show",input 56951,input " ").
                    assign l-erro-refer = yes.
                end.
            end.

            if can-find(funcao where
                        funcao.cd-funcao = "spp-consist-refer-nf" and
                        funcao.ativo) then do:
                run rep/re8885.p (rowid(doc-fisico),
                                  0,
                                  0,
                                  56951, /*Referencia da parcela da OC eh diferente do item da nota*/
                                  (not l-erro-refer), /*elimina consit nota*/
                                  i-sequencia,
                                  2). /*tipo 1=erro 2=advertencia*/
            end.
        end.
    end.

    if input frame {&frame-name} it-doc-fisico.nr-ord-prod <> 0 then do:
        find first ord-prod no-lock 
             where ord-prod.nr-ord-prod = input frame {&frame-name} it-doc-fisico.nr-ord-prod no-error.
        if not avail ord-prod then do:
            /**  Ordem de produá∆o n∆o cadastrada **/
            {include/i-vldprg.i}
            {utp/ut-table.i mgind ord-prod 01}
            run utp/ut-msgs.p (input "show",input 47,input return-value).
            apply 'entry' to it-doc-fisico.nr-ord-prod in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if ord-prod.cod-estabel <> doc-fisico.cod-estabel then do:
            /**  Ordem de produá∆o n∆o pertence ao estabelecimento da nota **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15189,input " ").
            apply 'entry' to it-doc-fisico.nr-ord-prod in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if avail item and item.tipo-requis = 2 then do:
            /**  Item possui tipo de requisiá∆o por transferància **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 5675,input " ").
        end.

        /********************************************************
        ** Validaá∆o dos Estados das Ordens Produá∆o ~\ Manutená∆o
        ********************************************************/
        RUN pi-valida-estado-ord-prod IN THIS-PROCEDURE.
        IF RETURN-VALUE = "ADM-ERROR":U THEN DO:
            {include/i-vldprg.i}
            apply 'entry' to it-doc-fisico.nr-ord-prod in frame {&frame-name}.
            RETURN "ADM-ERROR":U.
        END.
        /*******************************************************/
    end.                

    run pi-verifica-conta.

    /* chamado: TGBRMH */
    find first estabelec no-lock 
        where estabelec.cod-estabel = doc-fisico.cod-estabel no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec.

    if l-usa-unid-negoc                        /*Param materiais - utiliza UN*/
        AND (doc-fisico.tipo-nota    = 1       /*Nota Compra*/
             OR doc-fisico.tipo-nota = 9)      /*Nota Rateio*/
        AND input frame {&frame-name} it-doc-fisico.ct-codigo <> "" then do:
            run pi_valida_conta_contabil in h_api_cta_ctbl (input  string(i-empresa),            /* EMPRESA EMS2 */
                                                            input  c-estabelec,                  /* ESTABELECIMENTO EMS2 */
                                                            input  fi-cod-unid-negoc,            /* UNIDADE NEGOCIO */
                                                            input  "",                           /* PLANO CONTAS */ 
                                                            input  input frame {&frame-name} it-doc-fisico.ct-codigo,      /* CONTA */
                                                            input  "",                           /* PLANO CCUSTO */ 
                                                            input  input frame {&frame-name} it-doc-fisico.sc-codigo,      /* CCUSTO */
                                                            input  doc-fisico.dt-trans,          /* DATA TRANSACAO */
                                                            output table tt_log_erro).           /* ERROS */

        if  can-find(first tt_log_erro) then do:
            RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "sequencia").
            ASSIGN c-sequencia = RETURN-VALUE.

            RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "it-codigo").

            assign c-compl-msg = RETURN-VALUE + "~~" + c-sequencia.

            for each tt_log_erro:

                run utp/ut-msgs.p ( input "show",
                                    input 34452,
                                    input c-compl-msg ).

                run utp/ut-msgs.p ( input "show",
                                    input 17006,
                                    input tt_log_erro.ttv_des_msg_erro + "~~" + tt_log_erro.ttv_des_msg_ajuda ).
                return 'adm-error':U.
            end.
            empty temp-table tt_log_erro.
        end.
    end.

    if input frame {&frame-name} it-doc-fisico.nr-ord-prod = 0 and 
       input frame {&frame-name} it-doc-fisico.ct-codigo <> "" then do:

        /* Busca dados da conta cont†bil */
        ASSIGN v_cod_cta_ctbl = input frame {&frame-name} it-doc-fisico.ct-codigo.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,               /* EMPRESA EMS2 */
                                                       input        "",                      /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,          /* CONTA */
                                                       input        doc-fisico.dt-trans,     /* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,       /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl,      /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl,      /* SITUAÄ«O DA CONTA */
                                                       output       v_ind_finalid_cta,       /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).            /* ERROS */
        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
            {include/i-vldprg.i} 
            run utp/ut-msgs.p (input "show", input 17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
            apply 'entry' to it-doc-fisico.ct-codigo in frame {&frame-name}.
            return "adm-error":U.    
        end.

        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        
        if v_num_sit_cta_ctbl <> 3 then do:
            /**  Conta n∆o Ç de sistema **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 443,input " ").
            apply 'entry' to it-doc-fisico.ct-codigo in frame {&frame-name}.
            return 'adm-error':U.
        end.

        if not can-do("1,2,4,5",string(v_num_tip_cta_ctbl)) then do:
            /**  Conta deve ser de despesa, receita, ativo ou passivo **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 5543,input " ").
            apply 'entry' to it-doc-fisico.ct-codigo in frame {&frame-name}.
            return 'adm-error':U.
        end.

        /* chamado: TGBRMH
        if lookup({adinc/i05ad049.i 4 10}, v_ind_finalid_cta) <> 0*/ 
        IF v_ind_finalid_cta = {adinc/i05ad049.i 4 10} then do:
            /**  Conta n∆o aceita lancamentos do estoque **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 15190,input " ").
            apply 'entry' to it-doc-fisico.ct-codigo in frame {&frame-name}.
            return 'adm-error':U.
        end.

        /*if not can-do("1,2,3,6",string(conta -contab.estoq)) then do:*/
        if not (lookup({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) <> 0 or
                lookup({adinc/i05ad049.i 4 2}, v_ind_finalid_cta) <> 0 or
                lookup({adinc/i05ad049.i 4 3}, v_ind_finalid_cta) <> 0 or
                lookup({adinc/i05ad049.i 4 6}, v_ind_finalid_cta) <> 0) then do:
            /**  Conta n∆o aceita lancamentos de requisiá‰es **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 107,input " ").
            apply 'entry' to it-doc-fisico.ct-codigo in frame {&frame-name}.
            return 'adm-error':U.
        end.

        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */

        if v_log_utz_ccusto then do:
            /* Busca dados do centro de custo */
            ASSIGN v_cod_ccusto = input frame {&frame-name} it-doc-fisico.sc-codigo.
            run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,               /* EMPRESA EMS2 */
                                                       input  "",                      /* CODIGO DO PLANO CCUSTO */
                                                       input  v_cod_ccusto,            /* CCUSTO */
                                                       input  today,                   /* DATA DE TRANSACAO */
                                                       output v_titulo_ccusto,         /* DESCRICAO DO CCUSTO */
                                                       output table tt_log_erro).      /* ERROS */

            find first tt_log_erro no-lock no-error.
            if avail tt_log_erro then do:
                    {include/i-vldprg.i} 
                    run utp/ut-msgs.p (input "show", input 17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
                    apply 'entry' to it-doc-fisico.sc-codigo in frame {&frame-name}.
                    return "adm-error":U.    
            end. 
        end.

/*        if i-num-ord-inv = 0 and conta -contab.investimento = 2 then do:
 *             /**  Conta cont†bil Ç de investimentos. N∆o pode receber outros lanáamentos 
 *             **/
 *             {include/i-vldprg.i}
 *             run utp/ut-msgs.p (input "show",input 15191,input " ").
 *             apply 'entry' to it-doc-fisico.ct-codigo in frame {&frame-name}.
 *             return 'adm-error':U.
 *         end.*/
    end.        

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
    
        RUN piValidaUnidNeg.

        IF RETURN-VALUE = "ADM-ERROR":U THEN DO:

            /* Esta variavel Ç necessaria para mostrar a unid. negoc que deu problema, uma vez que ao executar a include 
               i-vldprg.i, Ç posicionado no primeiro campo da viewer (pedido), e neste campo Ç feita a consistencia para 
               alterar a unidade de negocio, "limpando" a unidade informada anteriormente pelo usuario, e que ocasionou erro. */
            ASSIGN c-unid-informada = fi-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                   c-desc-informada = fi-des-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

            {include/i-vldprg.i}

            apply 'entry' to fi-cod-unid-negoc in frame {&frame-name}.

            /* Atualiza a unid. negocio com a unid. que deu erro, para o usuario corrigir. */
            ASSIGN fi-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-unid-informada
                   fi-des-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-desc-informada
                   fi-cod-unid-negoc = c-unid-informada
                   fi-des-unid-negoc = c-desc-informada.

            RETURN "ADM-ERROR":U.
        END.
    &ENDIF

    if avail ordem-compra and ordem-compra.nr-contrato <> 0 and param-global.modulo-cn then do:
        /* Verifica se h† contrato pendende de aprovaá∆o */
        if param-compra.log-1  = yes and param-contrat.log-1 = yes then do:
            assign l-pendente = no.

            if ordem-compra.num-seq-item <> 0 then do: 

                for first item-contrat fields(val-total)
                    where item-contrat.nr-contrato  = ordem-compra.nr-contrato
                      and item-contrat.num-seq-item = ordem-compra.num-seq-item no-lock: end.

                for first contrato-for fields(dec-2)
                    where contrato-for.nr-contrato = ordem-compra.nr-contrato no-lock: end.

                if avail contrato-for and contrato-for.dec-2     = 0 and
                   avail item-contrat and item-contrat.val-total = 0 then  
                         run cdp/cdapi172.p (8, rowid(ordem-compra), output l-pendente).
                 else
                         run cdp/cdapi172.p (8, rowid(item-contrat), output l-pendente).
            end.
            else for each item-contrat no-lock 
                    where item-contrat.nr-contrato = ordem-compra.nr-contrato: 

                         run cdp/cdapi172.p (8, rowid(item-contrat), output l-pendente).
                         if l-pendente = yes then leave.
            end.            

            if l-pendente = yes then do:
               run utp/ut-msgs.p (input "show",
                                  input 16326,
                                  input string(ordem-compra.numero-ordem) + "~~" + ordem-compra.it-codigo + "~~" +
                                   trim(string(ordem-compra.qt-solic,">>>,>>>,>>>,>>>,>>9.9999")) + "~~" +
                                        string(ordem-compra.nr-contrato)  + "~~" + ordem-compra.cod-estabel).
               apply 'entry' to it-doc-fisico.numero-ordem in frame {&frame-name}.
               return 'adm-error':U.
            end.

        end.

        run cnp/cn9072.p (input input frame {&frame-name} it-doc-fisico.numero-ordem,
                          input rowid(doc-fisico),
                          input 12,                        
                          output l-conta-matriz,
                          input-output table tt-erro ).
    end.

    if (( item.tipo-contr = 1 or item.tipo-contr = 4 ) or  
        ( it-doc-fisico.baixa-ce:checked in frame {&frame-name} = no and l-consiste-conta )) 
    AND NOT (doc-fisico.tipo-nota = 2 AND it-doc-fisico.baixa-ce:CHECKED IN FRAME {&FRAME-NAME} = NO)
    and input frame {&frame-name} it-doc-fisico.ct-codigo = " " 
    and not l-conta-matriz then do:
        /**  Conta cont†bil deve ser informada **/
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show", input 6726, input " ").
        apply 'entry' to it-doc-fisico.ct-codigo in frame {&frame-name}.
        return 'adm-error':U.
    end.

    find first tt-erro 
        no-lock no-error.

    if available tt-erro then do:

        /**  Erro da tt-erro 
        **/
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input tt-erro.cd-erro,input " ").

        if tt-erro.cd-erro <> 15221 then do:
            apply 'entry' to it-doc-fisico.num-pedido in frame {&frame-name}.

            for each tt-erro:
                delete tt-erro.
            end.
            return 'adm-error':U. 
                end.
        else do:        
            for each tt-erro:
                delete tt-erro.
            end.
        end.
    end.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-conta V-table-Win 
PROCEDURE pi-verifica-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign l-consiste-conta = yes.  

    /**  Notas de Faturamento de Consignacao permitem que seja informado conta 
    ***  de aplicacao zero para itens que nao possuiam conta na remessa.       
    **/

    if doc-fisico.tipo-nota = 7 then do:
        find componente where 
            componente.cod-emitente = it-doc-fisico.cod-emitente and 
            componente.nro-docto    = it-doc-fisico.nro-comp     and 
            componente.serie-docto  = it-doc-fisico.serie-comp   and 
            componente.it-codigo    = it-doc-fisico.it-codigo    and 
            componente.cod-refer    = it-doc-fisico.cod-refer
            no-lock no-error.

        if avail componente and 
            componente.ct-codigo = " " and 
            componente.sc-codigo = " " and 
            input frame {&frame-name} it-doc-fisico.ct-codigo = " " then
            assign l-consiste-conta = no.
     end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDeterminaUnidNeg V-table-Win 
PROCEDURE piDeterminaUnidNeg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
    
        DEF BUFFER b-ord-prod FOR ord-prod.
        DEF BUFFER b-ordem-compra FOR ordem-compra.

        DEF VAR c-depos AS CHAR NO-UNDO.
    
        /*** Se for inclus∆o, consiste a unidade de neg¢cio conforme as regras abaixo ***/
        IF  adm-new-record THEN
            ASSIGN fi-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" 
                   fi-cod-unid-negoc = "".

        IF  l-mat-unid-negoc THEN DO WITH FRAME {&FRAME-NAME}:

            IF  INT(it-doc-fisico.nr-ord-produ:SCREEN-VALUE) <> 0
            AND (l-unidade-negocio 
                 OR (doc-fisico.tipo-nota <> 1 AND doc-fisico.tipo-nota <> 9)) THEN DO:

                FOR FIRST b-ord-prod FIELDS (nr-ord-produ cod-unid-negoc)
                    WHERE b-ord-prod.nr-ord-produ = INT(it-doc-fisico.nr-ord-produ:SCREEN-VALUE) NO-LOCK:
                    ASSIGN fi-cod-unid-negoc = b-ord-prod.cod-unid-negoc.
                END.
            END.
            ELSE DO:

                IF  doc-fisico.tipo-nota = 4 /* Ent Benef  */ 
                OR  doc-fisico.tipo-nota = 6 /* Ent Consig */
                OR  doc-fisico.tipo-nota = 2 /* Devoluá∆o  */ THEN DO:

                    IF  fi-cod-unid-negoc:SCREEN-VALUE = "" THEN DO:

                        RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "it-codigo").

                        IF  VALID-HANDLE(h-cdapi024) THEN
                            RUN RetornaUnidadeNegocioExternaliz IN h-cdapi024 (INPUT doc-fisico.cod-estabel,
                                                                               INPUT RETURN-VALUE, /*it-doc-fisico.it-codigo */
                                                                               INPUT "",
                                                                               OUTPUT fi-cod-unid-negoc).

                        /* Para Entrada Beneficimento, somente sugere se a funá∆o estiver ativa */
                        IF  doc-fisico.tipo-nota = 4 /* Ent Benef  */ 
                        AND NOT l-unidade-negocio THEN
                            ASSIGN fi-cod-unid-negoc = "".
                    END.
                END.
                ELSE DO:

                    /* Se a nota for de retorno benef, faturamento consig. ou devoluá∆o consig, n∆o sugere a unidade de negocio */
                    IF  doc-fisico.tipo-nota = 5 /* Retorno Benef */
                    OR  doc-fisico.tipo-nota = 7 /* Fatur. Consig */
                    OR  doc-fisico.tipo-nota = 8 /* Devoluá∆o Consig */ THEN DO:
                        ASSIGN fi-cod-unid-negoc = "".  
                    END.
                    ELSE DO:
                        assign it-doc-fisico.ct-codigo:format in frame {&FRAME-NAME} = "x(20)".

                        /*** Faz o tratamento de UN com a conta ***/
                        IF it-doc-fisico.ct-codigo:SCREEN-VALUE <> "" THEN DO:

                            IF fi-cod-unid-negoc:SCREEN-VALUE = "" THEN
                                IF INT(it-doc-fisico.numero-ordem:SCREEN-VALUE) <> 0 THEN DO:
                                    FOR FIRST b-ordem-compra FIELDS(numero-ordem cod-unid-negoc)
                                        WHERE b-ordem-compra.numero-ordem = INT(it-doc-fisico.numero-ordem:SCREEN-VALUE) NO-LOCK:
    
                                        ASSIGN fi-cod-unid-negoc = b-ordem-compra.cod-unid-negoc.
                                    END.
                                END.
                                ELSE DO:
                                    RUN pi-determina-depos (OUTPUT c-depos).
    
                                    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "it-codigo").
    
                                    IF  VALID-HANDLE(h-cdapi024) THEN
                                        RUN RetornaUnidadeNegocioExternaliz IN h-cdapi024 (INPUT doc-fisico.cod-estabel,
                                                                                           INPUT RETURN-VALUE, /*it-doc-fisico.it-codigo */
                                                                                           INPUT c-depos,
                                                                                           OUTPUT fi-cod-unid-negoc).
                                END.
    
                            /*** Recoloca formato da conta, somente se foi informado valor na conta ***/
                            run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                                           input        "",                 /* PLANO DE CONTAS */
                                                                           input-output v_cod_cta_ctbl,     /* CONTA */
                                                                           input        today,              /* DATA TRANSACAO */   
                                                                           output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                                           output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                                           output       v_num_sit_cta_ctbl, /* SITUAõ¯O DA CONTA */
                                                                           output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                                           output table tt_log_erro).       /* ERROS */
                            if not can-find(first tt_log_erro) and c-formato-conta <> "" then
                                assign it-doc-fisico.ct-codigo:format in frame {&frame-name} = c-formato-conta.
                        END.
                        ELSE DO:
                            IF doc-fisico.tipo-nota <> 7 /* Faturamento Consignaá∆o */
                            AND fi-cod-unid-negoc:SCREEN-VALUE <> "" THEN
                                ASSIGN fi-cod-unid-negoc = "".
                        END.
                    END.
                END.
            END.
        END.
        
        IF nr-ord-produ:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" AND l-usa-unid-negoc THEN DO:
            ASSIGN l-frotas = NO.
            
            RUN cdp/cd9902.p (INPUT 3).

            IF RETURN-VALUE = "OK":U THEN DO:

                IF NOT VALID-HANDLE(hMMVUnidNegoc) THEN
                    RUN frbo/bofr134.p PERSISTENT SET hMmvUnidNegoc.

                RUN canFindMatrizMMV IN hMMVUnidNegoc (INPUT INT(nr-ord-produ:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

                IF RETURN-VALUE = "OK":U AND (doc-fisico.tipo-nota = 1 OR doc-fisico.tipo-nota = 9) THEN
                    ASSIGN fi-cod-unid-negoc = ""
                           l-frotas          = YES.
                ELSE
                    ASSIGN fi-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = fi-cod-unid-negoc
                           l-frotas =  NO.

                IF VALID-HANDLE(hMMVUnidNegoc)THEN
                    RUN destroy IN hMMVUnidNegoc.
            END.

            IF NOT l-frotas THEN DO:
            
                FOR FIRST unid-negoc-om
                    WHERE unid-negoc-om.num-ord-manut = int(nr-ord-produ:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-LOCK:
                END.
                IF AVAIL unid-negoc-om 
                    AND (doc-fisico.tipo-nota = 1 OR doc-fisico.tipo-nota = 9) THEN DO:
                    ASSIGN fi-cod-unid-negoc = "".
                END.
                ELSE DO:
                    ASSIGN fi-cod-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = fi-cod-unid-negoc.
                END.
            END.
        END.

        APPLY "leave":U TO fi-cod-unid-negoc IN FRAME {&FRAME-NAME}.
    &ENDIF
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHabilitaUnidNeg V-table-Win 
PROCEDURE piHabilitaUnidNeg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        DEF VAR c-conta-aux AS CHAR NO-UNDO.
        DEF VAR l-habilita AS LOG INIT NO NO-UNDO.

        /*** Logica nova, respeitando passo a passo a regra de neg¢cio da engenharia, e N«O a metodologia de implementaá∆o da engenharia ***/
        CASE doc-fisico.tipo-nota:
            /* Tratamento para recebimento de notas de compra e de entrada de consignaá∆o */
            WHEN 1 /* Compra */ OR 
            WHEN 6 /* entrada consignaá∆o */ THEN DO WITH FRAME {&FRAME-NAME}:
                /*** Se n∆o utiliza unidade de neg¢cio, ou o usuario do recebimento n∆o permite atualizaá∆o, n∆o habilita o campo ***/
                IF NOT l-mat-unid-negoc OR NOT l-receb-unid-negoc THEN
                    ASSIGN l-habilita = NO.
                ELSE DO:
                    /* Se foi informada ordem de produá∆o, ir† habilitar o campo apenas se a funá∆o EMS2-UNIDADE-NEGOCIO N«O estiver ativa. 
                       Se a funá∆o estiver ativa, a UNeg vir† da ordem e n∆o poder† ser alterada */
                    IF  INT(it-doc-fisico.nr-ord-produ:SCREEN-VALUE) <> 0 THEN DO:
                        ASSIGN l-habilita = NOT l-unidade-negocio.
                    END.
                    ELSE DO:
                        /* N∆o foi informada ordem de produá∆o, verifica se foi informada conta cont†bil */
                        /*** Retira o formato da conta cont†bil ***/
                        assign it-doc-fisico.ct-codigo:format in frame {&FRAME-NAME} = "x(20)".
                        
                        /* Material permanecer† no estoque, n∆o foi informada a conta -> UNeg n∆o habilitada.
                           Se foi informada a conta, somente habilita se o usuario do receb. permite informar UNeg. */
                        IF it-doc-fisico.ct-codigo:SCREEN-VALUE = "" THEN
                            ASSIGN l-habilita = NO.
                        ELSE
                            ASSIGN l-habilita = l-receb-unid-negoc.
                    END.
                END.
            END. /* tipo de nota: Compra */

            WHEN 2 /* devoluá∆o */ THEN DO:
                /* Existe nota fiscal de venda (sa°da) */
                RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "nro-comp").
                IF  RETURN-VALUE <> "" THEN DO:
                
                    /*** Retira o formato da conta cont†bil ***/
                    assign it-doc-fisico.ct-codigo:format in frame {&FRAME-NAME} = "x(20)".
    
                    /* Material permanecer† no estoque, n∆o foi informada a conta -> UNeg n∆o habilitada.
                       Se foi informada a conta, somente habilita se o usuario do receb. permite informar UNeg. */
                    IF  it-doc-fisico.ct-codigo:SCREEN-VALUE = "" THEN
                        ASSIGN l-habilita = NO.
                    ELSE
                        ASSIGN l-habilita = l-receb-unid-negoc.
                END.
                ELSE
                    ASSIGN l-habilita = l-receb-unid-negoc.
            END.

            WHEN 4 /* entrada beneficiamento */ THEN DO:
                ASSIGN l-habilita = l-unidade-negocio. /* Somente habilita se a funá∆o estiver ativa */
            END.

            WHEN 3 /* transferància          */ OR 
            WHEN 5 /* retorno beneficiamento */ OR
            WHEN 8 /* devoluá∆o consignaá∆o  */ THEN DO WITH FRAME {&FRAME-NAME}:

                /* Se foi informada ordem de produá∆o, n∆o habilita a UNeg. */
                IF  INT(it-doc-fisico.nr-ord-produ:SCREEN-VALUE) <> 0 THEN
                    ASSIGN l-habilita = NO.
                ELSE DO:
                    
                    /* N∆o foi informada ordem de produá∆o, verifica se foi informada conta cont†bil */

                    /*** Retira o formato da conta cont†bil ***/
                    assign it-doc-fisico.ct-codigo:format in frame {&FRAME-NAME} = "x(20)".
    
                    /* Material permanecer† no estoque, n∆o foi informada a conta -> UNeg n∆o habilitada.
                       Se foi informada a conta, somente habilita se o usuario do receb. permite informar UNeg. */
                    IF  it-doc-fisico.ct-codigo:SCREEN-VALUE = "" THEN
                        ASSIGN l-habilita = NO.
                    ELSE
                        ASSIGN l-habilita = l-receb-unid-negoc AND l-unidade-negocio. /* Somente habilita se o usuario permite alterar
                                                                                         e a funá∆o est† ativa */
                END.
            END.

            WHEN 7 /* faturamento consignaá∆o */ THEN DO:

                /* Se foi informada ordem de produá∆o, n∆o habilita a UNeg. */
                IF  INT(it-doc-fisico.nr-ord-produ:SCREEN-VALUE) <> 0 THEN
                    ASSIGN l-habilita = NO.
                ELSE
                    ASSIGN l-habilita = l-receb-unid-negoc AND l-unidade-negocio. /* Somente habilita se o usuario permite alterar
                                                                                     e a funá∆o est† ativa */
            END.

            /* Na engenharia n∆o menciona nenhum tratamento espec°fico para habilitar ou n∆o o campo unidade de negocio qdo 
               a nota Ç de rateio. Ser† assumido que n∆o habilita, uma vez que Ç feito um tratamento atravÇs do prog. re2904. */
            WHEN 9 /* Rateio */ THEN
                ASSIGN l-habilita = NO. 

        END CASE.
        /************ Logica sugerida pela engenharia. 

        IF  NOT l-mat-unid-negoc THEN
            ASSIGN l-habilita = NO.
        ELSE DO WITH FRAME {&FRAME-NAME}:

            IF  INT(it-doc-fisico.nr-ord-produ:SCREEN-VALUE) <> 0
            AND (l-unidade-negocio 
                 OR (doc-fisico.tipo-nota <> 1 AND doc-fisico.tipo-nota <> 9)) THEN
                ASSIGN l-habilita = NO.
            ELSE DO:

                /*** Retira o formato da conta cont†bil se estiver com erro ***/
                assign it-doc-fisico.ct-codigo:format in frame {&FRAME-NAME} = "x(20)".

                /*** Faz o tratamento de habilitar UN conforme conta cont†bil ***/
                IF  it-doc-fisico.ct-codigo:SCREEN-VALUE <> "" THEN
                    ASSIGN l-habilita = l-receb-unid-negoc.
                ELSE DO:

                    RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "nro-comp").
                
                    IF  doc-fisico.tipo-nota = 4
                    OR  doc-fisico.tipo-nota = 6
                    OR  doc-fisico.tipo-nota = 7
                    OR (doc-fisico.tipo-nota = 2 AND RETURN-VALUE /*it-doc-fisico.nro-comp*/ = "") THEN
                        ASSIGN l-habilita = l-receb-unid-negoc.
                    ELSE DO:
                    
                        /*ASSIGN l-habilita = NO.*/

                        /*** Se a funá∆o de unidade de neg¢cio n∆o estiver ativa, e o usa UNeg nos param. materiais (else do),
                             somente ir† habilitar a UNeg se a nota for de compra ou de rateio. ***/
                        IF  NOT l-unidade-negocio THEN
                            IF  doc-fisico.tipo-nota = 1 /* Compra */ 
                            OR  doc-fisico.tipo-nota = 9 /* Rateio */ THEN
                                ASSIGN l-habilita = YES.
                            ELSE
                                ASSIGN l-habilita = NO.
                        ELSE
                            ASSIGN l-habilita = NO.
                    END.
                END.

                /*
                /*** Recoloca o formato da conta ***/
                if  avail param-global then
                    assign it-doc-fisico.ct-codigo:format in frame {&frame-name} = param-global.formato-conta -contabil.
                    */
                                assign it-doc-fisico.ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.
            END.

            /*** Se a funá∆o de unidade de neg¢cio n∆o estiver ativa, e o usa UNeg nos param. materiais (else do),
                 somente ir† habilitar a UNeg se a nota for de compra ou de rateio. ***/
            IF  NOT l-unidade-negocio THEN
                IF  doc-fisico.tipo-nota = 1 /* Compra */
                OR  doc-fisico.tipo-nota = 9 /* Rateio */ THEN
                    ASSIGN l-habilita = YES.
                ELSE
                    ASSIGN l-habilita = NO.
        END.
        *********/

        IF l-habilita THEN
            ENABLE fi-cod-unid-negoc WITH FRAME {&FRAME-NAME} . 
        ELSE
            DISABLE fi-cod-unid-negoc WITH FRAME {&FRAME-NAME} . 
        /*ASSIGN fi-cod-unid-negoc:SENSITIVE IN FRAME {&FRAME-NAME} = l-habilita.*/
        
        RUN piDeterminaUnidNeg.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaUnidNeg V-table-Win 
PROCEDURE piValidaUnidNeg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then

    IF  l-mat-unid-negoc THEN DO WITH FRAME {&FRAME-NAME}:

        IF (doc-fisico.tipo-nota = 4 /* Entrada Benef */ AND l-unidade-negocio)
        OR  doc-fisico.tipo-nota = 6 /* Entrada Consig */
        OR  doc-fisico.tipo-nota = 2 /* Devoluá∆o */ THEN DO:
            
            IF  fi-cod-unid-negoc:SCREEN-VALUE = ""
            AND l-unidade-negocio THEN DO:
                {utp/ut-table.i mgind unid-negoc 1}
                run utp/ut-msgs.p (input "show",input 2,input RETURN-VALUE).
                return 'adm-error':U.
            END.
            ELSE DO:

                IF  INT(it-doc-fisico.nr-ord-produ:SCREEN-VALUE) <> 0
                AND fi-cod-unid-negoc:SCREEN-VALUE = "" THEN DO:
                    {utp/ut-table.i mgind unid-negoc 1}
                    run utp/ut-msgs.p (input "show",input 2,input RETURN-VALUE).
                    return 'adm-error':U.
                END.
                ELSE DO:
                    IF  it-doc-fisico.ct-codigo:SCREEN-VALUE <> ""
                    AND fi-cod-unid-negoc:SCREEN-VALUE = "" THEN 
                        run utp/ut-msgs.p (input "show",input 31391,input ""). /* Advertencia */
                END.
            END.
        END.

        IF  fi-cod-unid-negoc:SCREEN-VALUE <> "" THEN DO:

            FIND unid-negoc
                WHERE unid-negoc.cod-unid-negoc = fi-cod-unid-negoc:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF  NOT AVAIL unid-negoc THEN DO:
                {utp/ut-table.i mgind unid-negoc 1}
                run utp/ut-msgs.p (input "show",input 2,input RETURN-VALUE).
                return 'adm-error':U.
            END.

            IF  VALID-HANDLE(h-cdapi024) THEN DO:
                
                run ValidaUnidadeNegocioEstabel in h-cdapi024 (input  doc-fisico.cod-estabel,
                                                               input  doc-fisico.dt-trans,
                                                               input  fi-cod-unid-negoc:SCREEN-VALUE,
                                                               output table tt-erro).

                run ValidaUnidadeNegocioUsuario in h-cdapi024 (input c-seg-usuario,
                                                               input fi-cod-unid-negoc:SCREEN-VALUE,
                                                               output table tt-erro append).

                FIND FIRST tt-erro NO-LOCK NO-ERROR.
                IF  AVAIL tt-erro THEN DO:
                    RUN cdp/cd0666.w (INPUT TABLE tt-erro).
                    return 'adm-error':U.
                END.
            END.
        END.
    END.

&ENDIF

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mudou-ordem-ou-pedido V-table-Win 
PROCEDURE pi-mudou-ordem-ou-pedido :
/*------------------------------------------------------------------------------
  Purpose: Verificar se foi alterado o pedido ou ordem na digitaá∆o    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-ordem-tela  AS INTEGER NO-UNDO.
    DEF VAR i-pedido-tela AS INTEGER NO-UNDO.

    ASSIGN i-ordem-tela  = input frame {&frame-name} it-doc-fisico.numero-ordem
           i-pedido-tela = input frame {&frame-name} it-doc-fisico.num-pedido.

    /* Alterado Pedido ou Ordem na digitaá∆o */
    IF i-pedido-ant <> i-pedido-tela OR 
       i-ordem-ant  <> i-ordem-tela  THEN DO:
        
        ASSIGN i-ordem-ant  = i-ordem-tela
               i-pedido-ant = i-pedido-tela.

        RETURN "OK". /* Mudou ordem ou pedido */
    END.

    RETURN "NOK". /* N∆o foi alterado */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-numero-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define output parameter i-numero-ordem like it-doc-fisico.numero-ordem.
    assign i-numero-ordem = input frame {&frame-name} it-doc-fisico.numero-ordem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executarEngineRecSemPedido V-table-Win 
PROCEDURE executarEngineRecSemPedido:
    
    DEFINE VARIABLE h-reapi427  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cChaveDocto AS CHARACTER   NO-UNDO.

    ASSIGN cChaveDocto = STRING(doc-fisico.cod-emitente) + "|" + doc-fisico.serie-docto + "|" + doc-fisico.nro-docto + "|" + string(doc-fisico.tipo-nota) + "|" + STRING(i-sequencia).
    
    RUN rep/reapi427.p PERSISTENT SET h-reapi427.

    RUN setChaveDocto  IN h-reapi427 (INPUT cChaveDocto).
    RUN setCodEstabel  IN h-reapi427 (INPUT doc-fisico.cod-estabel).
    RUN setCodEmitente IN h-reapi427 (INPUT doc-fisico.cod-emitente).
    RUN setCodObserva  IN h-reapi427 (INPUT doc-fisico.tipo-nota).
    RUN setUsuario     IN h-reapi427 (INPUT c-seg-usuario).

    RUN setItCodigo    IN h-reapi427 (INPUT c-it-codigo).
    RUN setSeqItem     IN h-reapi427 (INPUT i-sequencia).

    RUN engineRegrasRecSemPedido IN h-reapi427 (OUTPUT l-sem-pedido).

    RETURN "OK":U.
    FINALLY:
        DELETE PROCEDURE h-reapi427 NO-ERROR.
        ASSIGN h-reapi427 = ?.
    END FINALLY.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ver-alt-ped-ordem V-table-Win 
PROCEDURE pi-ver-alt-ped-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     IF i-ped-alt <> INT(it-doc-fisico.num-pedido:SCREEN-VALUE    IN FRAME {&frame-name})
     OR i-ord-alt <> INT(it-doc-fisico.numero-ordem:SCREEN-VALUE  IN FRAME {&frame-name})
     OR i-eve-alt <> INT(it-doc-fisico.num-seq-event:SCREEN-VALUE IN FRAME {&frame-name})
     OR i-par-alt <> INT(it-doc-fisico.parcela:SCREEN-VALUE       IN FRAME {&frame-name}) THEN
         ASSIGN l-calcula = YES.
     ELSE
         ASSIGN l-calcula = NO.

    ASSIGN i-ped-alt = INT(it-doc-fisico.num-pedido:SCREEN-VALUE    IN FRAME {&frame-name})
           i-ord-alt = INT(it-doc-fisico.numero-ordem:SCREEN-VALUE  IN FRAME {&frame-name})
           i-eve-alt = INT(it-doc-fisico.num-seq-event:SCREEN-VALUE IN FRAME {&frame-name})
           i-par-alt = INT(it-doc-fisico.parcela:SCREEN-VALUE       IN FRAME {&frame-name}).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{include/pi-edit.i}
{rep/re2005.i}
