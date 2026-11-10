&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          ems2mov          PROGRESS
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
{include/i-prgvrs.i IM0994A-V01 2.00.00.013 } /*** "010013" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0994a-v01 MRE}
&ENDIF

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
def var v-row-parent as rowid no-undo.

def buffer b-doc for docum-est.

def var rw-docum-est  as rowid no-undo.

def var i-emitente like emitente.cod-emitente.
def var l-inclui    as logical no-undo init no.
def var c-per-cotacao as char        no-undo.
def var d-dt-emissao    like docum-est.dt-emissao no-undo.
def var l-nff         as logical     no-undo.
def var l-atualizou-nff as l init no no-undo.
def var c-parametro     as char      no-undo.

def new global shared var l-mostra-fornec as logical init no no-undo.
DEF NEW GLOBAL SHARED VAR GR-DOCUM-EST AS ROWID NO-UNDO.
def var c-docto-aux   like docum-est.nro-docto.
def var l-mensagem    as logical no-undo init no.
def var c-label      as handle  no-undo.
DEF VAR i-moeda-ant LIKE docum-est.mo-codigo NO-UNDO.

DEF VAR c-estabelec AS CHAR NO-UNDO.

DEFINE VARIABLE c-teste-aux AS CHARACTER  NO-UNDO.
DEFINE VARIABLE tg-ent-fut-aux AS LOG NO-UNDO.
DEFINE VARIABLE c-nat-oper-aux AS CHAR NO-UNDO.
DEFINE VARIABLE l-gasto-aduana-aux AS LOGICAL     NO-UNDO.

def var i-empresa like param-global.empresa-prin no-undo.

{cdp/cd4300.i3}                         /* Variaveis para Quebra CHAR-1 */
{cdp/cd0101.i50} /*Variˇveis para o re1001b.i51*/
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

def temp-table tt-inicializa NO-UNDO
    field cod-emitente      like docum-est.cod-emitente     
    field uf                like docum-est.uf               
    field nat-operacao      like docum-est.nat-operacao     
    field esp-docto         like docum-est.esp-docto        
    field cod-observa       like docum-est.cod-observa      
    field despesa-nota      like docum-est.despesa-nota     
    field tot-peso          like docum-est.tot-peso             
    field valor-frete       like docum-est.valor-frete          
    field valor-mercad      like docum-est.valor-mercad     
    field tot-desconto      like docum-est.tot-desconto     . 

DEFINE VARIABLE h_v17in090      AS HANDLE NO-UNDO.
DEFINE VARIABLE h_re3001a       AS HANDLE NO-UNDO.
DEFINE VARIABLE h_im0994a-v03   AS HANDLE NO-UNDO.
DEFINE VARIABLE c-formato-conta AS CHAR   NO-UNDO.

DEFINE VARIABLE c-empresa LIKE param-global.empresa-prin NO-UNDO.
{cdp/cdunif001.i} /* Vari†veis da unificaá∆o de conceito Conta Cont†bil e Centro de Custo */

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
&Scoped-define EXTERNAL-TABLES docum-est
&Scoped-define FIRST-EXTERNAL-TABLE docum-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR docum-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS docum-est.cod-estabel docum-est.dt-trans ~
docum-est.dt-emissao docum-est.ct-transit docum-est.sc-transit ~
docum-est.mo-codigo docum-est.cotacao-dia 
&Scoped-define ENABLED-TABLES docum-est
&Scoped-define FIRST-ENABLED-TABLE docum-est
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold c-uf tg-gasto-aduana 
&Scoped-Define DISPLAYED-FIELDS docum-est.cod-emitente ~
docum-est.serie-docto docum-est.nro-docto docum-est.cod-estabel ~
docum-est.dt-trans docum-est.dt-emissao docum-est.ct-transit ~
docum-est.sc-transit docum-est.mo-codigo docum-est.cotacao-dia 
&Scoped-define DISPLAYED-TABLES docum-est
&Scoped-define FIRST-DISPLAYED-TABLE docum-est
&Scoped-Define DISPLAYED-OBJECTS fi-emitente fi-estabel c-uf fi-uf ~
fi-c-desc-conta fi-c-desc-ccusto fi-moeda tg-ent-fut tg-gasto-aduana ~
c-nat-oper c-desc-nat-oper 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS docum-est.cod-emitente ~
docum-est.serie-docto docum-est.nro-docto 
&Scoped-define ADM-ASSIGN-FIELDS docum-est.cod-estabel docum-est.dt-trans ~
docum-est.dt-emissao 

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
DEFINE VARIABLE c-desc-nat-oper AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-oper AS CHARACTER FORMAT "X(6)":U 
     LABEL "Fill 1" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-uf AS CHARACTER FORMAT "X(4)":U 
     LABEL "State" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fi-c-desc-ccusto AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-c-desc-conta AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-moeda AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-uf AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.57 BY 3.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.57 BY 9.5.

DEFINE VARIABLE tg-ent-fut AS LOGICAL INITIAL no 
     LABEL "Toggle 1" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE tg-gasto-aduana AS LOGICAL INITIAL no 
     LABEL "Desp. Aduana" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     docum-est.cod-emitente AT ROW 1.33 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     fi-emitente AT ROW 1.33 COL 36 COLON-ALIGNED NO-LABEL
     docum-est.serie-docto AT ROW 2.33 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     docum-est.nro-docto AT ROW 3.33 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     docum-est.cod-estabel AT ROW 5 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     fi-estabel AT ROW 5 COL 31.57 COLON-ALIGNED NO-LABEL
     c-uf AT ROW 6 COL 24 COLON-ALIGNED
     fi-uf AT ROW 6 COL 32.57 COLON-ALIGNED NO-LABEL
     docum-est.dt-trans AT ROW 7 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     docum-est.dt-emissao AT ROW 8 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     docum-est.ct-transit AT ROW 9 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fi-c-desc-conta AT ROW 9 COL 40.29 COLON-ALIGNED NO-LABEL
     docum-est.sc-transit AT ROW 10 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fi-c-desc-ccusto AT ROW 10 COL 40.29 COLON-ALIGNED NO-LABEL
     docum-est.mo-codigo AT ROW 11 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     fi-moeda AT ROW 11 COL 27.57 COLON-ALIGNED NO-LABEL
     docum-est.cotacao-dia AT ROW 12 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     tg-ent-fut AT ROW 12 COL 51
     tg-gasto-aduana AT ROW 12 COL 70.43
     c-nat-oper AT ROW 13 COL 24 COLON-ALIGNED
     c-desc-nat-oper AT ROW 13 COL 34.57 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.docum-est
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
         HEIGHT             = 13.29
         WIDTH              = 86.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

DEF VAR c-cod-estabel-usuar LIKE estabelec.cod-estabel.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-nat-oper IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nat-oper IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN docum-est.cod-emitente IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN docum-est.cod-estabel IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.dt-emissao IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.dt-trans IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-c-desc-ccusto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-c-desc-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-uf IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN docum-est.nro-docto IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN docum-est.serie-docto IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR TOGGLE-BOX tg-ent-fut IN FRAME f-main
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

&Scoped-define SELF-NAME c-nat-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper V-table-Win
ON F5 OF c-nat-oper IN FRAME f-main /* Fill 1 */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                       &campo=c-nat-oper
                       &campozoom=nat-operacao
                       &campo2=c-desc-nat-oper
                       &campozoom2=denominacao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper V-table-Win
ON LEAVE OF c-nat-oper IN FRAME f-main /* Fill 1 */
DO:
    {include/leave.i &tabela=natur-oper
                     &atributo-ref=denominacao
                     &variavel-ref=c-desc-nat-oper
                     &where="natur-oper.nat-operacao = input frame {&frame-name} c-nat-oper"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-nat-oper IN FRAME f-main /* Fill 1 */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-uf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-uf V-table-Win
ON LEAVE OF c-uf IN FRAME f-main /* State */
DO:
    if avail estabelec then do:
      {include/leave.i &tabela=unid-feder
                       &atributo-ref=no-estado
                       &variavel-ref=fi-uf
                       &where="unid-feder.pais = estabelec.pais and
                               unid-feder.estado = input frame {&frame-name}
                               c-uf"}
  end.                             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.cod-emitente V-table-Win
ON F5 OF docum-est.cod-emitente IN FRAME f-main /* Emitente */
DO:
    assign l-mostra-fornec = yes.
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                       &campo=docum-est.cod-emitente
                       &campozoom=cod-emitente}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.cod-emitente V-table-Win
ON LEAVE OF docum-est.cod-emitente IN FRAME f-main /* Emitente */
DO:
    {include/leave.i &tabela=emitente
                     &atributo-ref=nome-emit
                     &variavel-ref=fi-emitente
                     &where="emitente.cod-emitente = input frame {&frame-name}
                             docum-est.cod-emitente"}

     if avail emitente  and l-inclui then do:
        for each tt-inicializa:
            delete tt-inicializa.
        end.
        create tt-inicializa.
        assign tt-inicializa.cod-emitente = input frame {&frame-name} docum-est.cod-emitente.

        RUN pi-inicializa-campos 
          (INPUT table tt-inicializa,
           input input frame {&frame-name} docum-est.dt-emissao). 
     end.                             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.cod-emitente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.cod-emitente IN FRAME f-main /* Emitente */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.cod-estabel V-table-Win
ON F5 OF docum-est.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=docum-est.cod-estabel
                       &campozoom=cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.cod-estabel V-table-Win
ON LEAVE OF docum-est.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=fi-estabel
                     &where="estabelec.cod-estabel = input frame {&frame-name}
                             docum-est.cod-estabel"}

      if avail estabelec and adm-new-record then
         assign c-uf:screen-value in frame {&frame-name} = estabelec.estado.

      if not l-ut-ser
      and i-pais-impto-usuario <> 1 /*brasil*/ then 
         assign docum-est.serie-docto:screen-value = SUBSTRING(param-estoq.char-2,69,5).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.ct-transit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.ct-transit V-table-Win
ON ENTRY OF docum-est.ct-transit IN FRAME f-main /* Conta Transit¢ria */
DO:
    ASSIGN SELF:FORMAT = "X(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.ct-transit V-table-Win
ON F5 OF docum-est.ct-transit IN FRAME f-main /* Conta Transit¢ria */
DO:
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.
    
    IF  AVAIL docum-est AND docum-est.dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = docum-est.dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    /* Unificaá∆o de conceito conta cont†bil e centro de custo */
    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  c-empresa,          /* EMPRESA EMS2*/
                                                   INPUT  "CEP":U,            /* MODULO */
                                                   INPUT  "",                 /* PLANO DE CONTAS */
                                                   INPUT  "(nenhum)":U,       /* FINALIDADES */
                                                   INPUT  dt-trans-aux,       /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro). /* ERROS */
    IF  v_des_cta_ctbl <> "" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN fi-c-desc-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.ct-transit V-table-Win
ON LEAVE OF docum-est.ct-transit IN FRAME f-main /* Conta Transit¢ria */
DO:
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.

    ASSIGN SELF:FORMAT = "X(20)".

    IF  AVAIL docum-est AND docum-est.dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = docum-est.dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    /* Unificaá∆o de conceito conta cont†bil e centro de custo */
    ASSIGN v_cod_cta_ctbl = INPUT FRAME f-main docum-est.ct-transit.
    
    /* Busca dados da conta cont†bil */
    EMPTY TEMP-TABLE tt_log_erro.
    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        c-empresa,          /* EMPRESA EMS2 */
                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                   INPUT        dt-trans-aux,       /* DATA TRANSACAO */
                                                   OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUA?ÄO DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA*/
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */
    IF  RETURN-VALUE = "OK" THEN DO:
        /* Busca formato de apresentaá∆o da conta cont†bil */
        RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT  c-empresa,            /* EMPRESA EMS2 */
                                                           INPUT  "",                   /* PLANO CONTAS */
                                                           INPUT  dt-trans-aux,         /* DATA DE TRANSACAO */
                                                           OUTPUT p_cod_format_cta_ctbl,/* FORMATO CONTA */
                                                           OUTPUT TABLE tt_log_erro).   /* ERROS */
        
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl
               fi-c-desc-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_cta_ctbl.

        /* Aplica a mascara no campo */
        IF  p_cod_format_cta_ctbl <> "" AND SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN
            ASSIGN SELF:FORMAT = p_cod_format_cta_ctbl.

        /* Verifica se a conta utiliza centro de custo */
        ASSIGN c-estabelec = INPUT FRAME f-main docum-est.cod-estabel.
        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS 2 */
                                                           INPUT  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                           INPUT  "",                 /* PLANO CONTAS */
                                                           INPUT  v_cod_cta_ctbl,     /* CONTA */
                                                           INPUT  dt-trans-aux,       /* DT TRANSACAO */
                                                           OUTPUT p_log_ccusto,       /* UTILIZA CCUSTO ? */
                                                           OUTPUT TABLE tt_log_erro). /* ERROS */
        IF  NOT p_log_ccusto THEN
            ASSIGN docum-est.sc-transit:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                   fi-c-desc-ccusto:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = ""
                   docum-est.sc-transit:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
        ELSE DO:
            ASSIGN docum-est.sc-transit:SENSITIVE   IN FRAME {&FRAME-NAME} = YES.
            APPLY "ENTRY":U TO docum-est.sc-transit IN FRAME {&FRAME-NAME}.
        END.
    END.
    ELSE DO:
        ASSIGN fi-c-desc-conta:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = ""
               fi-c-desc-ccusto:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = ""
               docum-est.sc-transit:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

        ASSIGN docum-est.sc-transit:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.ct-transit V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.ct-transit IN FRAME f-main /* Conta Transit¢ria */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.dt-emissao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.dt-emissao V-table-Win
ON LEAVE OF docum-est.dt-emissao IN FRAME f-main /* Data Emiss∆o */
DO:

    assign c-per-cotacao = string(year(input frame {&FRAME-NAME} docum-est.dt-emissao),'9999')
                         +  string(month(input frame {&FRAME-NAME} docum-est.dt-emissao),'99').


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.mo-codigo V-table-Win
ON ENTRY OF docum-est.mo-codigo IN FRAME f-main /* Moeda */
DO:
   ASSIGN i-moeda-ant = int(docum-est.mo-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

END.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.mo-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.mo-codigo IN FRAME f-main /* Moeda */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.mo-codigo V-table-Win
ON F5 OF docum-est.mo-codigo IN FRAME f-main /* Moeda */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad178.w"
                     &campo=docum-est.mo-codigo
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.mo-codigo V-table-Win
ON LEAVE OF docum-est.mo-codigo IN FRAME f-main /* Moeda */
DO:
    {include/leave.i &tabela=moeda
                     &atributo-ref=descricao
                     &variavel-ref=fi-moeda
                     &where="moeda.mo-codigo = input frame {&frame-name} docum-est.mo-codigo"}
    if input frame {&frame-name} docum-est.mo-codigo = 0 then 
        assign docum-est.cotacao-dia:screen-value in frame {&frame-name} = "1"
               docum-est.cotacao-dia:sensitive in frame {&frame-name} = no.
    else do:
         IF i-moeda-ant <> int(docum-est.mo-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
             IF adm-new-record THEN DO:
                find first cotacao 
                     where cotacao.mo-codigo = input frame {&frame-name} docum-est.mo-codigo
                     and   cotacao.ano-periodo = c-per-cotacao no-lock no-error.
                ASSIGN d-dt-emissao = INPUT FRAME {&FRAME-NAME} docum-est.dt-emissao
                       docum-est.cotacao-dia:screen-value in frame {&FRAME-NAME} = if available cotacao then
                                                                                   string(cotacao.cotacao[day(d-dt-emissao)])
                                                                                   else "0".
             END.
             ELSE
                 ASSIGN docum-est.cotacao-dia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(docum-est.cotacao-dia).
         END.
    END.
    assign docum-est.cotacao-dia:sensitive in frame {&frame-name} = yes.
    apply 'entry' to docum-est.cotacao-dia in frame {&frame-name}.       
    return no-apply.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.nro-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.nro-docto V-table-Win
ON LEAVE OF docum-est.nro-docto IN FRAME f-main /* Documento */
DO:
    if input frame {&frame-name} docum-est.nro-docto = "" then do:
       run utp/ut-msgs.p (input "show",
                        input 30511,
                        input "").
       return no-apply.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.sc-transit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.sc-transit V-table-Win
ON ENTRY OF docum-est.sc-transit IN FRAME f-main /* Sub-Conta Transit */
DO:
    ASSIGN SELF:FORMAT = "X(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.sc-transit V-table-Win
ON F5 OF docum-est.sc-transit IN FRAME f-main /* Sub-Conta Transit */
DO:
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.
    
    IF  AVAIL docum-est AND docum-est.dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = docum-est.dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    ASSIGN c-estabelec = INPUT FRAME f-main docum-est.cod-estabel.
    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT c-empresa,           /* Empresa */
                                                   INPUT c-estabelec,         /* Estabelecimento */
                                                   INPUT NO,                  /* Considera Todos os Estabelecimentos ?*/
                                                   INPUT "",                  /* Unidade de Negocio*/
                                                   INPUT "",                  /* Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,      /* CΩdigo da Conta*/
                                                   INPUT "",                  /* CΩdigo do Plano de Centro de Custo*/
                                                   INPUT dt-trans-aux,        /* Data da Transacao*/
                                                   OUTPUT v_cod_ccusto,       /* Codigo CCusto*/
                                                   OUTPUT v_des_ccusto,       /* Descricao CCusto*/
                                                   OUTPUT TABLE tt_log_erro). /* Erros*/

    IF  v_des_ccusto <> "" THEN
        ASSIGN SELF:SCREEN-VALUE = v_cod_ccusto
               fi-c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.sc-transit V-table-Win
ON LEAVE OF docum-est.sc-transit IN FRAME f-main /* Sub-Conta Transit */
DO:
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.
    
    IF  AVAIL docum-est AND docum-est.dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = docum-est.dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    EMPTY TEMP-TABLE tt_log_erro.
    ASSIGN v_cod_ccusto = INPUT FRAME f-main docum-est.sc-transit.
    
    RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS2 */
                                               INPUT  "",                 /* CODIGO DO PLANO CCUSTO */
                                               INPUT  v_cod_ccusto,       /* CCUSTO */
                                               INPUT  dt-trans-aux,       /* DATA DE TRANSACAO */
                                               OUTPUT v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                               OUTPUT TABLE tt_log_erro). /* ERROS */
    
    IF  NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
        /* Busca m†scara para o campo centro de custo */
        RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT  c-empresa,           /* EMPRESA EMS2 */
                                                       INPUT  "",                  /* PLANO CONTAS */
                                                       INPUT  dt-trans-aux,        /* DATA DE TRANSACAO */ 
                                                       OUTPUT p_cod_format_ccusto, /* FORMATO CONTA */
                                                       OUTPUT TABLE tt_log_erro).  /* ERROS */
        
        ASSIGN fi-c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
        /* Aplica a m†scara no campo */
        IF  p_cod_format_ccusto <> "" THEN
            ASSIGN SELF:FORMAT IN FRAME {&FRAME-NAME} = p_cod_format_ccusto.
    END.
    ELSE
        ASSIGN fi-c-desc-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.sc-transit V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.sc-transit IN FRAME f-main /* Sub-Conta Transit */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.serie-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.serie-docto V-table-Win
ON F5 OF docum-est.serie-docto IN FRAME f-main /* SÇrie */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in407.w
                       &campo=docum-est.serie-docto
                       &campozoom=serie}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.serie-docto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.serie-docto IN FRAME f-main /* SÇrie */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-ent-fut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-ent-fut V-table-Win
ON VALUE-CHANGED OF tg-ent-fut IN FRAME f-main /* Toggle 1 */
DO:
  IF INPUT FRAME {&FRAME-NAME} {&SELF-NAME} = NO THEN DO:
      ASSIGN c-nat-oper:SENSITIVE         IN FRAME {&FRAME-NAME} = NO
             c-nat-oper:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = ""
             c-desc-nat-oper:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  END.
  ELSE
      ASSIGN c-nat-oper:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
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

  if docum-est.cod-emitente:load-mouse-pointer("image/lupa.cur") then .
  if docum-est.cod-estabel:load-mouse-pointer("image/lupa.cur") then .
  if docum-est.serie-docto:load-mouse-pointer("image/lupa.cur") then .
  if docum-est.ct-transit:load-mouse-pointer("image/lupa.cur") then .
  if docum-est.sc-transit:load-mouse-pointer("image/lupa.cur") then .
    
  if c-nat-oper:load-mouse-pointer("image/lupa.cur") then .
  {utp/ut-liter.i Entrega_Futura mre l}
  ASSIGN tg-ent-fut:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
  {utp/ut-liter.i Natur_Vinculada mre r}
  ASSIGN c-nat-oper:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE. 
  
  find first param-global no-lock no-error.
  find first param-estoq  no-lock no-error.
  find param-re where param-re.usuario = c-seg-usuario no-lock no-error.

  ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.

  &IF DEFINED(Bf_dis_usuario_estab) &THEN
      IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                           AND funcao.ativo     = YES) THEN DO:
         RUN cdp/cd8702.p (INPUT c-seg-usuario,
                           INPUT-OUTPUT c-cod-estabel-usuar).
      END.
  &ENDIF

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
  {src/adm/template/row-list.i "docum-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "docum-est"}

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

  assign l-inclui = yes.  
  /* Code placed here will execute AFTER standard behavior.    */
  do with frame {&FRAME-NAME}:
                    
      find estabelec where 
           estabelec.cod-estabel = c-cod-estabel-usuar
           no-lock no-error.
      if avail estabelec then do:
         find unid-feder where unid-feder.pais   = estabelec.pais   and
                               unid-feder.estado = estabelec.estado no-lock no-error.   
         assign c-uf:screen-value  = estabelec.estado
                fi-uf:screen-value         = if avail unid-feder then unid-feder.no-estado else "".
      end.

      assign docum-est.dt-emissao:screen-value  = string(today)
             docum-est.dt-trans:screen-value    = string(today)
             docum-est.cod-estabel:screen-value = c-cod-estabel-usuar
             fi-estabel:screen-value            = if avail estabelec then estabelec.nome else "".

      if  not l-ut-ser and i-pais-impto-usuario <> 1 /*brasil*/ then 
         assign docum-est.serie-docto:screen-value = SUBSTRING(param-estoq.char-2,69,5).

      assign docum-est.cotacao-dia:screen-value = "1"
             docum-est.cotacao-dia:sensitive    = no.

      assign i-empresa = param-global.empresa-prin.

      &if defined (bf_dis_consiste_conta) &then

          find estabelec where
               estabelec.cod-estabel = c-cod-estabel-usuar no-lock no-error.

          run cdp/cd9970.p (input rowid(estabelec),
                            output i-empresa).
      &endif
      
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
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  
  ASSIGN c-teste-aux = c-uf:SCREEN-VALUE IN frame {&frame-name}.
  
  IF i-pais-impto-usuario <> 1 /*brasil*/ THEN
      ASSIGN tg-ent-fut-aux = INPUT FRAME {&FRAME-NAME} tg-ent-fut
             c-nat-oper-aux = INPUT FRAME {&FRAME-NAME} c-nat-oper
             l-gasto-aduana-aux = INPUT FRAME {&FRAME-NAME} tg-gasto-aduana.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.


  find emitente where emitente.cod-emitente = docum-est.cod-emitente no-lock no-error. 

  assign docum-est.nat-operacao = " "
         docum-est.esp-docto    = 21
         docum-est.cod-observa  = 1
         docum-est.sit-docum    = 1 
         docum-est.nff          = yes
         docum-est.uf           = c-teste-aux.


  assign docum-est.tipo-docto  = 0
         docum-est.usuario     = c-seg-usuario
         docum-est.pais-origem = "IM0994":U
         docum-est.sit-atual   = 2.
  
  IF i-pais-impto-usuario <> 1 /*brasil*/ THEN DO:
      ASSIGN docum-est.log-entreg-fut   = tg-ent-fut-aux
             docum-est.cod-natur-vincul = c-nat-oper-aux
             OVERLAY(docum-est.char-2,235,1) = IF l-gasto-aduana-aux THEN '1' ELSE '0'.
                                                                                  
      IF param-global.modulo-07 THEN
          ASSIGN OVERLAY(docum-est.char-1,1,20) = docum-est.nro-docto.
  END.  
      
  IF i-pais-impto-usuario = 21 /* Equador */ THEN DO:      
      FIND FIRST docto-estoq-internac EXCLUSIVE-LOCK
           WHERE docto-estoq-internac.serie-docto  = docum-est.serie-docto
             AND docto-estoq-internac.nro-docto    = docum-est.nro-docto   
             AND docto-estoq-internac.cod-emitente = docum-est.cod-emitente
             AND docto-estoq-internac.nat-operacao = docum-est.nat-operacao NO-ERROR.
     
      IF NOT AVAIL docto-estoq-internac THEN DO:
          CREATE docto-estoq-internac.
          ASSIGN docto-estoq-internac.cod-emitente = docum-est.cod-emitente
                 docto-estoq-internac.nat-operacao = docum-est.nat-operacao
                 docto-estoq-internac.nro-docto    = docum-est.nro-docto
                 docto-estoq-internac.serie-docto  = docum-est.serie-docto
                 docto-estoq-internac.data-di      = 01/01/0001. /* Campo obrigat¢rio */
      END.
     
      ASSIGN docto-estoq-internac.idi-tip-comprov = 6.
     
      RELEASE docto-estoq-internac.
  END.

  ASSIGN rw-docum-est = rowid(docum-est).  

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  VALID-HANDLE(h_api_cta_ctbl) THEN DO: /* API Finanáas -> handle Conta Cont†bil */
        DELETE PROCEDURE h_api_cta_ctbl.
        ASSIGN h_api_cta_ctbl = ?.
    END.

    IF  VALID-HANDLE(h_api_ccusto) THEN DO:   /* API Finanáas -> handle Centro de Custo */
        DELETE PROCEDURE h_api_ccusto.
        ASSIGN h_api_ccusto = ?.
    END.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE (INPUT 'destroy':U).
    
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
    
    IF i-pais-impto-usuario <> 1 /*brasil*/ THEN
        ASSIGN tg-ent-fut:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               c-nat-oper:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               tg-gasto-aduana:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    
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
  
  if  avail docum-est then do:
      
      find emitente where 
           emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.
      find estabelec where
           estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
      find unid-feder where 
           unid-feder.pais   = estabelec.pais and
           unid-feder.estado = docum-est.uf no-lock no-error.
      if avail emitente then
         assign fi-emitente     = emitente.nome-emit.
      if avail estabelec then
         assign fi-estabel      = estabelec.nome.
      if avail unid-feder then
         assign fi-uf           = unid-feder.no-estado.   
      if avail docum-est then
         assign c-uf           = docum-est.uf. 
      
      IF i-pais-impto-usuario <> 1 /*brasil*/ THEN DO:
         ASSIGN tg-ent-fut = docum-est.log-entreg-fut 
                c-nat-oper = docum-est.cod-natur-vincul
                tg-gasto-aduana = IF trim(substring(docum-est.char-2,235,1)) = "1":U THEN YES ELSE NO.
         FIND natur-oper NO-LOCK WHERE
             natur-oper.nat-operacao = c-nat-oper NO-ERROR.
         IF AVAILABLE natur-oper THEN
             ASSIGN c-desc-nat-oper = natur-oper.denominacao.
            
      END.

 END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  ASSIGN c-uf:SCREEN-VALUE IN FRAME f-main = docum-est.uf.
  
  APPLY 'LEAVE':U TO docum-est.dt-emissao IN FRAME {&FRAME-NAME}.
  APPLY 'LEAVE':U TO docum-est.mo-codigo  IN FRAME {&FRAME-NAME}.
  APPLY 'LEAVE':U TO docum-est.ct-transit IN FRAME {&FRAME-NAME}.
  APPLY 'LEAVE':U TO docum-est.sc-transit IN FRAME {&FRAME-NAME}.
  
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
      &endif.
    else do:
        assign docum-est.mo-codigo:sensitive in frame {&frame-name} = no
               fi-moeda:sensitive in frame {&frame-name} = no
               docum-est.cotacao-dia:sensitive in frame {&frame-name} = no. 

        IF i-pais-impto-usuario <> 1 /*brasil*/ THEN
            ASSIGN tg-gasto-aduana:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    end.
    
    IF i-pais-impto-usuario <> 1 /*brasil*/ THEN DO:
        ASSIGN tg-ent-fut:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               tg-ent-fut:CHECKED   IN FRAME {&FRAME-NAME} = NO WHEN adm-new-record.
        IF tg-ent-fut = YES THEN
           ASSIGN c-nat-oper:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END.
        
    APPLY 'LEAVE':U TO docum-est.ct-transit IN FRAME {&FRAME-NAME}.


   /* run pi-inicializa-campos in this-procedure. */
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
  find first param-global no-lock.
  find first param-estoq  no-lock.
  /*Quando tem valor na param-estoq deve ser considerado o que est† nesse campo e n∆o na param-global*/
  IF SUBSTRING(param-estoq.char-2,68,1) <> "" THEN
      ASSIGN l-ut-ser = (SUBSTRING(param-estoq.char-2,68,1) = "S").
  ELSE DO:
  {cdp/cd4300.i4  "yes" param-global.char-2}             
  {cdp/cd0101.i51 "yes"}
  END.
  do with frame {&FRAME-NAME}:
      if not l-ut-ser  /*n∆o utiliza serie*/
        and i-pais-impto-usuario <> 1 /*brasil*/ then 
        assign    docum-est.nro-docto:row = docum-est.serie-docto:row 
                  c-label          = docum-est.nro-docto:SIDE-LABEL-HANDLE  /*pega o handle do label*/
                  c-label:row      = docum-est.serie-docto:row  /*move o label para a mesma linha do fill-in*/

                  docum-est.serie-docto:visible  = no. /*esconde a sÇrie*/

 
  end.

  IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
      RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
  IF  NOT VALID-HANDLE(h_api_ccusto) THEN
      RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i Fornecedor *}
  ASSIGN docum-est.cod-emitente:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  IF  NOT AVAIL param-global THEN
      FIND FIRST param-global NO-LOCK NO-ERROR.
  ASSIGN c-empresa = param-global.empresa-prin.
  
  ASSIGN tg-gasto-aduana:VISIBLE IN FRAME {&FRAME-NAME} = YES.  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita V-table-Win 
PROCEDURE pi-desabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 disable all with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campos V-table-Win 
PROCEDURE pi-inicializa-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param table for tt-inicializa.
def input param da-dt-emissao like docum-est.dt-emissao no-undo.  
find first tt-inicializa no-error.

do with frame {&FRAME-NAME}:

    assign c-per-cotacao = string(year(input docum-est.dt-emissao),'9999')
                         +  string(month(input docum-est.dt-emissao),'99').

    if input frame {&frame-name} docum-est.mo-codigo = 0 then 
       assign docum-est.cotacao-dia:screen-value in frame {&frame-name} = "1"
              docum-est.cotacao-dia:sensitive in frame {&frame-name} = no.
    else do:

        find cotacao where
             cotacao.mo-codigo  = input frame {&frame-name} docum-est.mo-codigo and
             cotacao.ano-periodo = c-per-cotacao no-lock no-error.

        assign docum-est.cotacao-dia:screen-value in frame {&frame-name} = 
                                     if avail cotacao then
                                        string(cotacao.cotacao[day(da-dt-emissao)])
                                     else "0". 

         if avail cotacao then 
             enable  docum-est.cotacao-dia with frame {&frame-name}.
         else 
             disable docum-est.cotacao-dia with frame {&frame-name}.
    end.

end.

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
def input param h-handle-1 as handle no-undo.
def input param h-handle-2 as handle no-undo.
def input param h-handle-3 as handle no-undo.

assign h_v17in090    = h-handle-1
       h_im0994a-v03 = h-handle-2
       h_re3001a     = h-handle-3.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-inclusao V-table-Win 
PROCEDURE pi-retorna-inclusao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output parameter l-incluir as logical no-undo.

    assign l-incluir = adm-new-record.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-conta-ccusto V-table-Win 
PROCEDURE pi-valida-conta-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-num-finalid-cta AS INTEGER                NO-UNDO.
    DEFINE VARIABLE v_log_utz_ccusto  AS LOGICAL                NO-UNDO.
    DEFINE VARIABLE c-ct-transit-aux  LIKE docum-est.ct-transit NO-UNDO.
    DEFINE VARIABLE c-sc-transit-aux  LIKE docum-est.sc-transit NO-UNDO.
    DEFINE VARIABLE dt-trans-aux AS DATE NO-UNDO.
    DEFINE VARIABLE l-transf     AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-ent-cons   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-retorno    AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-devolucao  AS LOGICAL     NO-UNDO.
    
    IF  AVAIL docum-est AND docum-est.dt-trans <> ? THEN 
        ASSIGN dt-trans-aux = docum-est.dt-trans.
    ELSE 
        ASSIGN dt-trans-aux = TODAY.

    ASSIGN c-ct-transit-aux = INPUT FRAME f-main docum-est.ct-transit
           c-sc-transit-aux = INPUT FRAME f-main docum-est.sc-transit.
    
    EMPTY TEMP-TABLE tt_log_erro.
    RUN pi_valida_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  c-empresa,          /* EMPRESA EMS2 */
                                                     INPUT  "CEP":U,            /* MODULO */
                                                     INPUT  "",                 /* PLANO CONTAS */ 
                                                     INPUT  c-ct-transit-aux,   /* CONTA */
                                                     INPUT  "(nenhum)":U,       /* FINALIDADES */
                                                     INPUT  dt-trans-aux,       /* DATA DE TRANSACAO */ 
                                                     OUTPUT TABLE tt_log_erro). /* ERROS */

    FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
    IF  AVAIL tt_log_erro THEN DO:
        /*{include/i-vldprg.i}*/
        {utp/ut-liter.i "'Conta Contabil'" *}
        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT TRIM(RETURN-VALUE)).
        APPLY "ENTRY":U TO docum-est.ct-transit IN FRAME {&FRAME-NAME}.
        RETURN "NOK":U.
    END.
    ELSE DO:
        EMPTY TEMP-TABLE tt_log_erro.
        ASSIGN c-estabelec = INPUT FRAME f-main docum-est.cod-estabel.
        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS 2 */
                                                           INPUT  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                           INPUT  "",                 /* PLANO CONTAS */
                                                           INPUT  c-ct-transit-aux,   /* CONTA */
                                                           INPUT  dt-trans-aux,       /* DT TRANSACAO */
                                                           OUTPUT v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           OUTPUT TABLE tt_log_erro). /* ERROS */
        IF  v_log_utz_ccusto THEN DO:
            EMPTY TEMP-TABLE tt_log_erro.
            RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  c-empresa,          /* EMPRESA EMS2 */
                                                       INPUT  "",                 /* CODIGO DO PLANO CCUSTO */
                                                       INPUT  c-sc-transit-aux,   /* CCUSTO */
                                                       INPUT  dt-trans-aux,       /* DATA DE TRANSACAO */
                                                       OUTPUT v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                                       OUTPUT TABLE tt_log_erro). /* ERROS */ 
            FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
            IF  AVAIL tt_log_erro THEN DO:
                /*{include/i-vldprg.i}*/
                {utp/ut-liter.i "'Centro Custo'" *}
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT TRIM(RETURN-VALUE)).
                APPLY "ENTRY":U TO docum-est.sc-transit IN FRAME {&FRAME-NAME}.
                RETURN "NOK":U.
            END.
        END.
    END.

    
    EMPTY TEMP-TABLE tt_log_erro.
    ASSIGN v_cod_cta_ctbl = c-ct-transit-aux.   

    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        c-empresa,          /* EMPRESA EMS2 */
                                                   INPUT        "",                 /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                   INPUT        dt-trans-aux,       /* DATA TRANSACAO */   
                                                   OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).       /* ERROS */

    RUN pi_busca_dados_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        c-empresa,         /* EMPRESA EMS2 */
                                                          INPUT        "CEP":U,           /* M‡DULO */
                                                          INPUT        "",                /* PLANO DE CONTAS */
                                                          INPUT        v_cod_cta_ctbl,    /* CONTA */
                                                          INPUT        dt-trans-aux,      /* DATA TRANSACAO */   
                                                          OUTPUT       v_ind_finalid_cta, /* FINALIDADES DA CONTA */
                                                          OUTPUT TABLE tt_log_erro).      /* ERROS */ 
    FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
    IF  NOT AVAIL tt_log_erro THEN DO:
        
        ASSIGN i-num-finalid-cta = {adinc/i05ad049.i 6 v_ind_finalid_cta}.
        
        IF  v_num_sit_cta_ctbl <> 3 THEN DO: /* Sistema */
            /*{include/i-vldprg.i}*/
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 1062, INPUT "").
            APPLY "ENTRY":U TO docum-est.ct-transit IN FRAME {&FRAME-NAME}.
            RETURN "NOK":U.
        END.    
        IF  i-num-finalid-cta = 10 THEN DO: /* Nao Aceita Lanáamentos */
            /*{include/i-vldprg.i}*/
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 445, INPUT "").
            APPLY "ENTRY":U TO docum-est.ct-transit IN FRAME {&FRAME-NAME}.
            RETURN "NOK":U.
        END.
        IF  l-transf THEN DO:
            IF  i-num-finalid-cta <> 4 THEN DO: /* Transferància */
                /*{include/i-vldprg.i}*/
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 747, INPUT "").
                APPLY "ENTRY":U TO docum-est.ct-transit IN FRAME {&FRAME-NAME}.
                RETURN "NOK":U.
            END.
        END.
        ELSE IF l-ent-cons THEN DO:
            IF  i-num-finalid-cta <> 2 THEN DO: /* N∆o Consumo */
                /*{include/i-vldprg.i}*/
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 6323, INPUT "").
                APPLY "ENTRY":U TO docum-est.ct-transit IN FRAME {&FRAME-NAME}.
                RETURN "NOK":U.
            END.
        END.
        
        IF  l-retorno THEN DO:
            /*--- se a natureza eh de retorno beneficiamento nao precisa verificar se eh consumo ou nao consumo ---*/
            IF  i-num-finalid-cta <> 1          /* Consumo */
            AND i-num-finalid-cta <> 2 THEN DO: /* N∆o Consumo */
                /*{include/i-vldprg.i}*/
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 6325, INPUT "").
                APPLY "ENTRY":U TO docum-est.ct-transit IN FRAME {&FRAME-NAME}.
                RETURN "NOK":U.
            END.
        END.        
        ELSE IF l-devolucao THEN DO:
            IF  i-num-finalid-cta <> 2          /* N∆o Consumo */
            AND i-num-finalid-cta <> 6          /* CPV */
            AND i-num-finalid-cta <> 8 THEN DO: /* Transit¢ria Devoluá∆o */
                /*{include/i-vldprg.i}*/
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 6317, INPUT "").
                APPLY "ENTRY":U TO docum-est.ct-transit IN FRAME {&FRAME-NAME}.
                RETURN "NOK":U.
            END.
        END.  
        ELSE DO:
            IF  i-num-finalid-cta <> 2          /* N∆o Consumo */
            AND i-num-finalid-cta <> 4          /* Transferància */
            AND i-num-finalid-cta <> 7 THEN DO: /* Transit¢ria Compras */
                /*{include/i-vldprg.i}*/
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 438, INPUT "").
                APPLY "ENTRY":U TO docum-est.ct-transit IN FRAME {&FRAME-NAME}.
                RETURN "NOK":U.
            END.
        END.
    END.

    RETURN "OK":U.
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
def var l-erro as logical no-undo.
def var c-label as char no-undo.

{include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

IF  INPUT FRAME {&FRAME-NAME} docum-est.nro-docto = "" THEN DO:
    RUN utp/ut-msgs.p (INPUT "show", INPUT 30511, INPUT "").
    APPLY "entry" TO docum-est.nro-docto IN FRAME {&FRAME-NAME}.
    RETURN 'ADM-ERROR':U.
END.

find estabelec where 
     estabelec.cod-estabel = input frame {&frame-name} docum-est.cod-estabel
     no-lock no-error.
find emitente where 
     emitente.cod-emitente = input frame {&frame-name} docum-est.cod-emitente
     no-lock no-error.
find serie where serie.serie = input frame {&frame-name} docum-est.serie-docto
     no-lock no-error.
if  not avail serie then do:
    {include/i-vldprg.i} 
    {utp/ut-table.i mgind serie 1}
    run utp/ut-msgs.p (input "show":U, input 2, input return-value).
    apply "entry" to docum-est.serie-docto in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.     

find ser-estab where
     ser-estab.serie = input frame {&frame-name} docum-est.serie-docto and
     ser-estab.cod-estabel = input frame {&frame-name} docum-est.cod-estabel 
     no-lock no-error.

if  docum-est.cod-emitente:sensitive in frame {&frame-name} then do:
    find b-doc no-lock where
         b-doc.cod-emitente = input frame {&FRAME-NAME} docum-est.cod-emitente and
         b-doc.serie-docto  = input frame {&FRAME-NAME} docum-est.serie-docto  and
         b-doc.nro-docto    = input frame {&FRAME-NAME} docum-est.nro-docto and
         b-doc.nat-operacao = "" no-error.
    if  avail b-doc then do: 
        {include/i-vldprg.i} 
        {utp/ut-table.i mgind docum-est 1}
        run utp/ut-msgs.p (input "show":U, input 7, input return-value).
        apply "entry" to docum-est.cod-emitente in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
end.

RUN pi-valida-conta-ccusto.
IF  RETURN-VALUE = "NOK":U THEN
    RETURN 'ADM-ERROR':U.


do with frame {&FRAME-NAME}:

    if docum-est.dt-emissao:sensitive and input docum-est.dt-emissao < (today - param-re.var-emis) then do:
        {include/i-vldprg.i} 
        {utp/ut-field.i mgind docum-est dt-emissao 2}       
        run utp/ut-msgs.p (input "show":U, input 8824, input return-value).
        apply "entry" to docum-est.dt-emissao in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    if docum-est.dt-trans:sensitive and input docum-est.dt-trans > today then do:
        {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show":U, input 1788, input "").
        apply "entry" to docum-est.dt-trans in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    if docum-est.dt-trans:sensitive and input docum-est.dt-trans  < input docum-est.dt-emissao then do:
        {include/i-vldprg.i} 
        {utp/ut-field.i mgind docum-est dt-emissao 2}       
        assign c-label = return-value.
        {utp/ut-field.i mgind docum-est dt-transacao 2}       
        run utp/ut-msgs.p (input "show":U, input 89, input return-value + "~~" + c-label).
        apply "entry" to docum-est.dt-trans in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    if docum-est.dt-trans:sensitive and input docum-est.dt-trans < (today - param-re.var-atual)  then do:
        {include/i-vldprg.i} 
        {utp/ut-field.i mgind docum-est dt-transacao 2}       
        run utp/ut-msgs.p (input "show":U, input 8824, input return-value).
        apply "entry" to docum-est.dt-trans in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    FIND dist-emitente WHERE
         dist-emitente.cod-emitente = input frame {&frame-name} docum-est.cod-emitente
         NO-LOCK NO-ERROR.
    IF  AVAIL dist-emitente
    AND dist-emitente.extra-fornec THEN DO:
        {utp/ut-liter.i "Documento_para_emitente_Extra" * r }
        RUN utp/ut-msgs.p("show",6861,RETURN-VALUE).
        APPLY "entry" TO docum-est.cod-emitente IN FRAME {&FRAME-NAME}.
        RETURN "adm-error":U.
    END.

end.


IF INPUT FRAME {&FRAME-NAME} tg-ent-fut = YES THEN DO:
    IF INPUT FRAME {&FRAME-NAME} c-nat-oper <> "" THEN DO:
        FIND natur-oper NO-LOCK WHERE
            natur-oper.nat-operacao = INPUT FRAME {&FRAME-NAME} c-nat-oper NO-ERROR.
        IF AVAILABLE natur-oper THEN DO:
            IF natur-oper.tipo <> 2 /* saida */ OR
               natur-oper.ind-entfut <> YES THEN DO:
                RUN utp/ut-msgs.p("show",31918,"").
                APPLY "entry" TO c-nat-oper IN FRAME {&FRAME-NAME}.
                RETURN "adm-error":U.
            END.
        END.
        ELSE DO:
            RUN utp/ut-msgs.p("show",31974,"").
            APPLY "entry" TO c-nat-oper IN FRAME {&FRAME-NAME}.
            RETURN "adm-error":U.
        END.
    END.
    ELSE DO:
        {utp/ut-liter.i natureza_vinculada * r}
        RUN utp/ut-msgs.p("show",2,RETURN-VALUE).
        APPLY "entry" TO c-nat-oper IN FRAME {&FRAME-NAME}.
        RETURN "adm-error":U.
    END.
END.

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
  {src/adm/template/snd-list.i "docum-est"}

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

