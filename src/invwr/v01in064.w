&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V01IN064 2.00.00.009 } /*** "010009" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in064 MUT}
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

def buffer b-movto for movto-estoq.

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
 
def var i-empresa like param-global.empresa-prin no-undo.
def var h-acomp           as handle  no-undo.
def var l-adm-new-record  as logical no-undo.
def var da-sumar-ate     like param-estoq.contab-ate.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància".

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.
def var c-formato-conta      as char no-undo.
def var c-formato-ccusto     as char no-undo. 

/* Vari·veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
def var v_des_plano_cta_ctbl as char   no-undo.
def var v_dt_plano_ini       as date   no-undo.
def var v_dt_plano_fim       as date   no-undo.
/* Vari·veis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo. 
def var v_log_utz_ccusto     as log    no-undo.

def var v_cod_estabel        as char   no-undo.

DEF VAR c-ct-codigo-ant      AS CHAR   NO-UNDO.
DEF VAR c-sc-codigo-ant      AS CHAR   NO-UNDO.

DEF VAR c-ct-codigo-camb      AS CHAR   NO-UNDO.
DEF VAR c-sc-codigo-camb      AS CHAR   NO-UNDO.
DEF VAR c-ct-codigo-camb-imp  AS CHAR   NO-UNDO.
DEF VAR c-sc-codigo-camb-imp  AS CHAR   NO-UNDO.

def var h_handle_container   as handle no-undo.

{cdp/cdcfgmat.i}

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
&Scoped-define EXTERNAL-TABLES contabiliza
&Scoped-define FIRST-EXTERNAL-TABLE contabiliza


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR contabiliza.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS contabiliza.ct-codigo contabiliza.sc-codigo ~
contabiliza.ct-var-saldo contabiliza.sc-var-saldo contabiliza.ct-var-movto ~
contabiliza.sc-var-movto 
&Scoped-define ENABLED-TABLES contabiliza
&Scoped-define FIRST-ENABLED-TABLE contabiliza
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-1 ct-var-camb sc-var-camb ~
ct-var-camb-impto sc-var-camb-impto 
&Scoped-Define DISPLAYED-FIELDS contabiliza.ge-codigo contabiliza.cod-depos ~
contabiliza.cod-estabel contabiliza.ct-codigo contabiliza.sc-codigo ~
contabiliza.ct-var-saldo contabiliza.sc-var-saldo contabiliza.ct-var-movto ~
contabiliza.sc-var-movto 
&Scoped-define DISPLAYED-TABLES contabiliza
&Scoped-define FIRST-DISPLAYED-TABLE contabiliza
&Scoped-Define DISPLAYED-OBJECTS c-descricao c-nome-deposito ~
c-nome-estabelec ct-var-camb sc-var-camb ct-var-camb-impto ~
sc-var-camb-impto c-titulo-1 c-titulo-ccusto-1 c-titulo-2 c-titulo-ccusto-2 ~
c-titulo-3 c-titulo-ccusto-3 c-titulo-4 c-titulo-ccusto-4 c-titulo-5 ~
c-titulo-ccusto-5 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS contabiliza.ge-codigo ~
contabiliza.cod-depos contabiliza.cod-estabel 

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
DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-deposito AS CHARACTER FORMAT "X(42)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-estabelec AS CHARACTER FORMAT "X(42)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-1 AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-2 AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-3 AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-ccusto-1 AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-ccusto-2 AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-ccusto-3 AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-ccusto-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-ccusto-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE ct-var-camb AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta Variac Cambial" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88 NO-UNDO.

DEFINE VARIABLE ct-var-camb-impto AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta Variac Cambial Impto" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88 NO-UNDO.

DEFINE VARIABLE sc-var-camb AS CHARACTER FORMAT "X(20)":U 
     LABEL "Sub-Conta Variac Cambial" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88 NO-UNDO.

DEFINE VARIABLE sc-var-camb-impto AS CHARACTER FORMAT "X(20)":U 
     LABEL "Sub-Conta Variac Cambial Impto" 
     VIEW-AS FILL-IN 
     SIZE 18.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 10.67.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     contabiliza.ge-codigo AT ROW 1.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     contabiliza.cod-depos AT ROW 2.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     contabiliza.cod-estabel AT ROW 3.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-descricao AT ROW 1.17 COL 29.29 COLON-ALIGNED NO-LABEL
     c-nome-deposito AT ROW 2.17 COL 33 COLON-ALIGNED NO-LABEL
     c-nome-estabelec AT ROW 3.17 COL 33 COLON-ALIGNED NO-LABEL
     contabiliza.ct-codigo AT ROW 4.63 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.43 BY .88
     contabiliza.sc-codigo AT ROW 5.63 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.43 BY .88
     contabiliza.ct-var-saldo AT ROW 6.63 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.43 BY .88
     contabiliza.sc-var-saldo AT ROW 7.63 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.43 BY .88
     contabiliza.ct-var-movto AT ROW 8.63 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.43 BY .88
     contabiliza.sc-var-movto AT ROW 9.63 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.43 BY .88
     ct-var-camb AT ROW 10.63 COL 30.29 COLON-ALIGNED WIDGET-ID 2
     sc-var-camb AT ROW 11.63 COL 30.29 COLON-ALIGNED WIDGET-ID 6
     ct-var-camb-impto AT ROW 12.63 COL 30.29 COLON-ALIGNED WIDGET-ID 14
     sc-var-camb-impto AT ROW 13.63 COL 30.29 COLON-ALIGNED WIDGET-ID 16
     c-titulo-1 AT ROW 4.63 COL 49.29 COLON-ALIGNED NO-LABEL
     c-titulo-ccusto-1 AT ROW 5.63 COL 49.29 COLON-ALIGNED NO-LABEL
     c-titulo-2 AT ROW 6.63 COL 49.29 COLON-ALIGNED NO-LABEL
     c-titulo-ccusto-2 AT ROW 7.63 COL 49.29 COLON-ALIGNED NO-LABEL
     c-titulo-3 AT ROW 8.63 COL 49.29 COLON-ALIGNED NO-LABEL
     c-titulo-ccusto-3 AT ROW 9.63 COL 49.29 COLON-ALIGNED NO-LABEL
     c-titulo-4 AT ROW 10.63 COL 49.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     c-titulo-ccusto-4 AT ROW 11.63 COL 49.29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     c-titulo-5 AT ROW 12.63 COL 49.29 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     c-titulo-ccusto-5 AT ROW 13.63 COL 49.29 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     rt-mold AT ROW 1 COL 1
     RECT-1 AT ROW 4.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.contabiliza
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
         HEIGHT             = 14.08
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{btb/btb008za.i0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-deposito IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-estabelec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-ccusto-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-ccusto-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-ccusto-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-ccusto-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-ccusto-5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN contabiliza.cod-depos IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN contabiliza.cod-estabel IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN contabiliza.ge-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME contabiliza.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.cod-depos V-table-Win
ON F5 OF contabiliza.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in084.w
                       &campo=contabiliza.cod-depos
                       &campozoom=cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.cod-depos V-table-Win
ON LEAVE OF contabiliza.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=c-nome-deposito
                     &where="deposito.cod-depos = input frame {&frame-name} contabiliza.cod-depos"}


find first deposito where
     deposito.cod-depos = input frame {&frame-name} contabiliza.cod-depos no-lock no-error.
   if not avail deposito
     then do:
          run utp/ut-msgs.p (input "show",
                             input 56,
                             input return-value).
         apply "entry" to contabiliza.cod-depos in frame {&frame-name}.
         return no-apply.
     end.                                  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF contabiliza.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME contabiliza.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.cod-estabel V-table-Win
ON F5 OF contabiliza.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    assign l-implanta = yes. 
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=contabiliza.cod-estabel
                       &campozoom=cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.cod-estabel V-table-Win
ON LEAVE OF contabiliza.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=c-nome-estabelec
                     &where="estabelec.cod-estabel = input frame {&frame-name} contabiliza.cod-estabel"}
  

    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF  NOT AVAIL param-global THEN DO:
      RUN utp/utmsgs.p (input "show", input 16, input "").
      RETURN 'adm-error'.
    END.
 
    find first estabelec where
         estabelec.cod-estabel = input frame {&frame-name} contabiliza.cod-estabel no-lock no-error.
    if not avail estabelec
    then do:
          {utp/ut-table.i mgadm estabelec 1}
          run utp/ut-msgs.p (input "show":U,
                             input 56,
                             input return-value).
         apply "entry" to contabiliza.cod-estabel in frame {&frame-name}.
         return no-apply.
    end.                                  

    run pi-atribui-empresa.
     
    run pi-habilita-contas.
    if  return-value = "NOK":U then
        return no-apply.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF contabiliza.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME contabiliza.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ct-codigo V-table-Win
ON ENTRY OF contabiliza.ct-codigo IN FRAME f-main /* Conta */
DO:
    assign self:format = "x(20)".
    ENABLE contabiliza.sc-codigo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ct-codigo V-table-Win
ON F5 OF contabiliza.ct-codigo IN FRAME f-main /* Conta */
DO:
  assign i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = yes.

   def var v_cod_finalid as char no-undo.                                               
   assign v_cod_finalid = {adinc/i05ad049.i 4 9}. /* 9 - Saldo por grupo de estoque */

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* MπDULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  v_cod_finalid,      /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 

   ASSIGN contabiliza.ct-codigo:SCREEN-VALUE = v_cod_cta_ctbl.
   ASSIGN c-titulo-1:SCREEN-VALUE = v_titulo_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ct-codigo V-table-Win
ON LEAVE OF contabiliza.ct-codigo IN FRAME f-main /* Conta */
DO:
    assign self:format = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT contabiliza.ct-codigo.

    /* Busca dados da conta contˇbil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */
   
    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN SELF:FORMAT = c-formato-conta.

        /* Verifica se a conta utiliza centro de custo */
        assign v_cod_estabel = input frame {&frame-name} contabiliza.cod-estabel.
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  v_cod_estabel,      /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            ENABLE contabiliza.sc-codigo WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            ASSIGN contabiliza.sc-codigo:SCREEN-VALUE = "".
            ASSIGN c-titulo-ccusto-1:SCREEN-VALUE = "".
            DISABLE contabiliza.sc-codigo WITH FRAME {&FRAME-NAME}.
        END.
        /************************************************/
    END.

    ASSIGN c-titulo-1:SCREEN-VALUE = v_titulo_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF contabiliza.ct-codigo IN FRAME f-main /* Conta */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ct-var-camb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-var-camb V-table-Win
ON ENTRY OF ct-var-camb IN FRAME f-main /* Conta Variac Cambial */
DO:
  assign self:format = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-var-camb V-table-Win
ON F5 OF ct-var-camb IN FRAME f-main /* Conta Variac Cambial */
DO:
    assign i-ep-codigo-usuario = param-global.empresa-prin
           l-implanta          = yes.

     def var v_cod_finalid as char no-undo.                                               
     assign v_cod_finalid = {adinc/i05ad049.i 4 1} + "," + {adinc/i05ad049.i 4 2}.


     run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                    input  "CEP",              /* MπDULO */
                                                    input  "",                 /* PLANO DE CONTAS */
                                                    input  v_cod_finalid,      /* FINALIDADES */
                                                    input  today,              /* DATA TRANSACAO */
                                                    output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                    output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                    output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                    output table tt_log_erro). /* ERROS */ 

     ASSIGN ct-var-camb:SCREEN-VALUE = v_cod_cta_ctbl.
     ASSIGN c-titulo-4:SCREEN-VALUE = v_titulo_cta_ctbl.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-var-camb V-table-Win
ON LEAVE OF ct-var-camb IN FRAME f-main /* Conta Variac Cambial */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT ct-var-camb.

    IF  v_cod_cta_ctbl <> "" THEN DO:

        /* Busca dados da conta contˇbil */
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                       input        "",                 /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,     /* CONTA */
                                                       input        today,              /* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */
                                                       output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).       /* ERROS */
    
        IF RETURN-VALUE = "OK" THEN DO:
            ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
            ASSIGN SELF:FORMAT = c-formato-conta.
    
            /* Verifica se a conta utiliza centro de custo */
            assign v_cod_estabel = input frame {&frame-name} contabiliza.cod-estabel.
            run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                               input  v_cod_estabel,      /* ESTABELECIMENTO EMS2 */
                                                               input  "",                 /* PLANO CONTAS */
                                                               input  v_cod_cta_ctbl,     /* CONTA */
                                                               input  today,              /* DT TRANSACAO */
                                                               output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                               output table tt_log_erro). /* ERROS */
            IF v_log_utz_ccusto THEN DO:
                ENABLE sc-var-camb WITH FRAME {&FRAME-NAME}.
            END.
            ELSE DO:
                ASSIGN sc-var-camb:SCREEN-VALUE = "".
                ASSIGN c-titulo-ccusto-4:SCREEN-VALUE = "".
                DISABLE sc-var-camb WITH FRAME {&FRAME-NAME}.
            END.
            /************************************************/
        END.
    
        ASSIGN c-titulo-4:SCREEN-VALUE = v_titulo_cta_ctbl.

    END.
    ELSE
        ASSIGN c-titulo-4:SCREEN-VALUE = "". 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-var-camb V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ct-var-camb IN FRAME f-main /* Conta Variac Cambial */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ct-var-camb-impto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-var-camb-impto V-table-Win
ON ENTRY OF ct-var-camb-impto IN FRAME f-main /* Conta Variac Cambial Impto */
DO:
  assign self:format = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-var-camb-impto V-table-Win
ON F5 OF ct-var-camb-impto IN FRAME f-main /* Conta Variac Cambial Impto */
DO:
    assign i-ep-codigo-usuario = param-global.empresa-prin
           l-implanta          = yes.

     def var v_cod_finalid as char no-undo.                                               
     assign v_cod_finalid = {adinc/i05ad049.i 4 1} + "," + {adinc/i05ad049.i 4 2}.


     run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                    input  "CEP",              /* MπDULO */
                                                    input  "",                 /* PLANO DE CONTAS */
                                                    input  v_cod_finalid,      /* FINALIDADES */
                                                    input  today,              /* DATA TRANSACAO */
                                                    output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                    output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                    output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                    output table tt_log_erro). /* ERROS */ 

     ASSIGN ct-var-camb-impto:SCREEN-VALUE = v_cod_cta_ctbl.
     ASSIGN c-titulo-5:SCREEN-VALUE = v_titulo_cta_ctbl.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-var-camb-impto V-table-Win
ON LEAVE OF ct-var-camb-impto IN FRAME f-main /* Conta Variac Cambial Impto */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT ct-var-camb-impto.

    IF  v_cod_cta_ctbl <> "" THEN DO:

        /* Busca dados da conta contˇbil */
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                       input        "",                 /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,     /* CONTA */
                                                       input        today,              /* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */
                                                       output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).       /* ERROS */
    
        IF RETURN-VALUE = "OK" THEN DO:
            ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
            ASSIGN SELF:FORMAT = c-formato-conta.
    
            /* Verifica se a conta utiliza centro de custo */
            assign v_cod_estabel = input frame {&frame-name} contabiliza.cod-estabel.
            run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                               input  v_cod_estabel,      /* ESTABELECIMENTO EMS2 */
                                                               input  "",                 /* PLANO CONTAS */
                                                               input  v_cod_cta_ctbl,     /* CONTA */
                                                               input  today,              /* DT TRANSACAO */
                                                               output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                               output table tt_log_erro). /* ERROS */
            IF v_log_utz_ccusto THEN DO:
                ENABLE sc-var-camb-impto WITH FRAME {&FRAME-NAME}.
            END.
            ELSE DO:
                ASSIGN sc-var-camb-impto:SCREEN-VALUE = "".
                ASSIGN c-titulo-ccusto-5:SCREEN-VALUE = "".
                DISABLE sc-var-camb-impto WITH FRAME {&FRAME-NAME}.
            END.
            /************************************************/
        END.
    
        ASSIGN c-titulo-5:SCREEN-VALUE = v_titulo_cta_ctbl.

    END.
    ELSE
        ASSIGN c-titulo-5:SCREEN-VALUE = "". 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ct-var-camb-impto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ct-var-camb-impto IN FRAME f-main /* Conta Variac Cambial Impto */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME contabiliza.ct-var-movto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ct-var-movto V-table-Win
ON ENTRY OF contabiliza.ct-var-movto IN FRAME f-main /* Conta Variaá∆o Movimento */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE contabiliza.sc-var-movto WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ct-var-movto V-table-Win
ON F5 OF contabiliza.ct-var-movto IN FRAME f-main /* Conta Variaá∆o Movimento */
DO:
  assign i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = yes.

   def var v_cod_finalid as char no-undo.                                               
   assign v_cod_finalid = {adinc/i05ad049.i 4 1} + "," + {adinc/i05ad049.i 4 2}.
   

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* MπDULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  v_cod_finalid,      /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 

   ASSIGN contabiliza.ct-var-movto:SCREEN-VALUE = v_cod_cta_ctbl.
   ASSIGN c-titulo-3:SCREEN-VALUE = v_titulo_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ct-var-movto V-table-Win
ON LEAVE OF contabiliza.ct-var-movto IN FRAME f-main /* Conta Variaá∆o Movimento */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT contabiliza.ct-var-movto.

    /* Busca dados da conta contˇbil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN SELF:FORMAT = c-formato-conta.

        /* Verifica se a conta utiliza centro de custo */
        assign v_cod_estabel = input frame {&frame-name} contabiliza.cod-estabel.
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  v_cod_estabel,      /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            ENABLE contabiliza.sc-var-movto WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            ASSIGN contabiliza.sc-var-movto:SCREEN-VALUE = "".
            ASSIGN c-titulo-ccusto-3:SCREEN-VALUE = "".
            DISABLE contabiliza.sc-var-movto WITH FRAME {&FRAME-NAME}.
        END.
        /************************************************/
    END.

    ASSIGN c-titulo-3:SCREEN-VALUE = v_titulo_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ct-var-movto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF contabiliza.ct-var-movto IN FRAME f-main /* Conta Variaá∆o Movimento */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME contabiliza.ct-var-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ct-var-saldo V-table-Win
ON ENTRY OF contabiliza.ct-var-saldo IN FRAME f-main /* Conta Variaá∆o Saldo */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE contabiliza.sc-var-saldo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ct-var-saldo V-table-Win
ON F5 OF contabiliza.ct-var-saldo IN FRAME f-main /* Conta Variaá∆o Saldo */
DO:
  assign i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = yes.

   def var v_cod_finalid as char no-undo.                                               
   assign v_cod_finalid = {adinc/i05ad049.i 4 1} + "," + {adinc/i05ad049.i 4 2}.

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* MπDULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  v_cod_finalid,      /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 

   ASSIGN contabiliza.ct-var-saldo:SCREEN-VALUE = v_cod_cta_ctbl.
   ASSIGN c-titulo-2:SCREEN-VALUE = v_titulo_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ct-var-saldo V-table-Win
ON LEAVE OF contabiliza.ct-var-saldo IN FRAME f-main /* Conta Variaá∆o Saldo */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT contabiliza.ct-var-saldo.

    /* Busca dados da conta contˇbil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN SELF:FORMAT = c-formato-conta.

        /* Verifica se a conta utiliza centro de custo */
        assign v_cod_estabel = input frame {&frame-name} contabiliza.cod-estabel.
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  v_cod_estabel,      /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            ENABLE contabiliza.sc-var-saldo WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            ASSIGN contabiliza.sc-var-saldo:SCREEN-VALUE = "".
            ASSIGN c-titulo-ccusto-2:SCREEN-VALUE = "".
            DISABLE contabiliza.sc-var-saldo WITH FRAME {&FRAME-NAME}.
        END.
        /************************************************/
    END.

    ASSIGN c-titulo-2:SCREEN-VALUE = v_titulo_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ct-var-saldo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF contabiliza.ct-var-saldo IN FRAME f-main /* Conta Variaá∆o Saldo */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME contabiliza.ge-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ge-codigo V-table-Win
ON ENTRY OF contabiliza.ge-codigo IN FRAME f-main /* Grupo Estoque */
DO:
  {include/leave.i &tabela=grup-estoque
                     &atributo-ref=descricao
                     &variavel-ref=c-descricao
                     &where="grup-estoque.ge-codigo = input frame {&frame-name} contabiliza.ge-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ge-codigo V-table-Win
ON F5 OF contabiliza.ge-codigo IN FRAME f-main /* Grupo Estoque */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in142.w
                       &campo=contabiliza.ge-codigo
                       &campozoom=ge-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ge-codigo V-table-Win
ON LEAVE OF contabiliza.ge-codigo IN FRAME f-main /* Grupo Estoque */
DO:
    {include/leave.i &tabela=grup-estoque
                     &atributo-ref=descricao
                     &variavel-ref=c-descricao
                     &where="grup-estoque.ge-codigo = input frame {&frame-name} contabiliza.ge-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.ge-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF contabiliza.ge-codigo IN FRAME f-main /* Grupo Estoque */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME contabiliza.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.sc-codigo V-table-Win
ON ENTRY OF contabiliza.sc-codigo IN FRAME f-main /* Sub-Conta */
DO:
    assign self:format = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.sc-codigo V-table-Win
ON F5 OF contabiliza.sc-codigo IN FRAME f-main /* Sub-Conta */
DO:
   IF v_log_utz_ccusto THEN DO:
       run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                           input "",                  /* CODIGO DO PLANO CCUSTO */
                                           input "",                  /* UNIDADE DE NEGOCIO */
                                           input today,               /* DATA DE TRANSACAO */
                                           output v_cod_ccusto,       /* CODIGO CCUSTO */
                                           output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                           output table tt_log_erro). /* ERROS */ 
    
       ASSIGN contabiliza.sc-codigo:SCREEN-VALUE     = v_cod_ccusto.
       ASSIGN c-titulo-ccusto-1:SCREEN-VALUE = v_titulo_ccusto.   
   END.
   ELSE DO:
     /* Inicio -- Projeto Internacional */
     DEFINE VARIABLE c-lbl-liter-a-conta-informada-nao-utiliza AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "A_Conta_informada_n∆o_utiliza_centro_de_custo" *}
     ASSIGN c-lbl-liter-a-conta-informada-nao-utiliza = TRIM(RETURN-VALUE).
     DEFINE VARIABLE c-lbl-liter-para-consultar-o-criterio-que AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "Para_consultar_o_critÇrio_que_est†_sendo_utilizado_para_esta_conta" *}
     ASSIGN c-lbl-liter-para-consultar-o-criterio-que = TRIM(RETURN-VALUE).
     DEFINE VARIABLE c-lbl-liter-basta-seguir-os-passos-abaixo AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "basta_seguir_os_passos_abaixo" *}
     ASSIGN c-lbl-liter-basta-seguir-os-passos-abaixo = TRIM(RETURN-VALUE).
     DEFINE VARIABLE c-lbl-liter-vinculo-do-centro-de-custo-com AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "V°nculo_do_Centro_de_Custo_com_a_Conta_Cont†bil" *}
     ASSIGN c-lbl-liter-vinculo-do-centro-de-custo-com = TRIM(RETURN-VALUE).
     DEFINE VARIABLE c-lbl-liter-1-acessar-o-programa-manutenca AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "1)_Acessar_o_programa:_Manutená∆o_CritÇrios_Distribuiá∆o_Conta" *}
     ASSIGN c-lbl-liter-1-acessar-o-programa-manutenca = TRIM(RETURN-VALUE).
     DEFINE VARIABLE c-lbl-liter-2-selecionar-a-conta-desejada AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "2)_Selecionar_a_Conta_desejada" *}
     ASSIGN c-lbl-liter-2-selecionar-a-conta-desejada = TRIM(RETURN-VALUE).
     DEFINE VARIABLE c-lbl-liter-3-ir-no-botao-va-para AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "3)_Ir_no_bot∆o_V†_Para" *}
     ASSIGN c-lbl-liter-3-ir-no-botao-va-para = TRIM(RETURN-VALUE).
     DEFINE VARIABLE c-lbl-liter-4-escolher-o-estabelecimento-e AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "4)_Escolher_o_estabelecimento_e_a_Data_de_Validade" *}
     ASSIGN c-lbl-liter-4-escolher-o-estabelecimento-e = TRIM(RETURN-VALUE).
     DEFINE VARIABLE c-lbl-liter-5-verificar-o-criterio-que-pod AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "5)_Verificar_o_critÇrio,_que_podem_ser_tràs" *}
     ASSIGN c-lbl-liter-5-verificar-o-criterio-que-pod = TRIM(RETURN-VALUE).
     DEFINE VARIABLE c-lbl-liter-a-nao-utiliza-a-conta-nao-ira AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "a._N∆o_Utiliza_=_A_conta_n∆o_ir†_utilizar_Centro_de_Custo" *}
     ASSIGN c-lbl-liter-a-nao-utiliza-a-conta-nao-ira = TRIM(RETURN-VALUE).
     DEFINE VARIABLE c-lbl-liter-b-utiliza-todos-todos-os-cent AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "b._Utiliza_Todos_=_Todos_os_Centros_de_Custos_ser∆o_v†lidos_para_a_Conta" *}
     ASSIGN c-lbl-liter-b-utiliza-todos-todos-os-cent = TRIM(RETURN-VALUE).
     DEFINE VARIABLE c-lbl-liter-c-definidos-e-possivel-inform AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "c._Definidos_=_ê_poss°vel_informar_uma_lista_de_Centro_de_Custos._Esta_lista_Ç_cadastrada" *}
     ASSIGN c-lbl-liter-c-definidos-e-possivel-inform = TRIM(RETURN-VALUE).
     DEFINE VARIABLE c-lbl-liter-no-mapa-de-distribuicao-de-cen AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "no_'Mapa_de_Distribuiá∆o_de_Centro_de_Custo'" *}
     ASSIGN c-lbl-liter-no-mapa-de-distribuicao-de-cen = TRIM(RETURN-VALUE).
     DEFINE VARIABLE c-lbl-liter-obs-este-programa-tambem-permi AS CHARACTER NO-UNDO.
     {utp/ut-liter.i "OBS:_Este_programa_tambÇm_permite_fazer_a_manutená∆o_deste_v°nculo_conforme_a_necessidade" *}
     ASSIGN c-lbl-liter-obs-este-programa-tambem-permi = TRIM(RETURN-VALUE).
     run utp/ut-msgs.p (input "show":U,
                        input 17006,
      input c-lbl-liter-a-conta-informada-nao-utiliza + '!' + "~~" +
        c-lbl-liter-para-consultar-o-criterio-que + ', ' +
        c-lbl-liter-basta-seguir-os-passos-abaixo + '.' + CHR(10) + CHR(10) +
        c-lbl-liter-vinculo-do-centro-de-custo-com + ':' + CHR(10) +
        c-lbl-liter-1-acessar-o-programa-manutenca + '.' + CHR(10) +
        c-lbl-liter-2-selecionar-a-conta-desejada + '.' + CHR(10) +
        c-lbl-liter-3-ir-no-botao-va-para + '.' + CHR(10) +
        c-lbl-liter-4-escolher-o-estabelecimento-e + '.' + CHR(10) +
        c-lbl-liter-5-verificar-o-criterio-que-pod + ':' + CHR(10) +
        '   ' + c-lbl-liter-a-nao-utiliza-a-conta-nao-ira + '.' + CHR(10) +
        '   ' + c-lbl-liter-b-utiliza-todos-todos-os-cent + '.' + CHR(10) +
        '   ' + c-lbl-liter-c-definidos-e-possivel-inform + ' ' + 
        ' ' + c-lbl-liter-no-mapa-de-distribuicao-de-cen + '.' + CHR(10) + CHR(10) +
        c-lbl-liter-obs-este-programa-tambem-permi + '.').

     apply "entry" to contabiliza.ct-codigo in frame {&frame-name}.
     return 'ADM-ERROR':U.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.sc-codigo V-table-Win
ON LEAVE OF contabiliza.sc-codigo IN FRAME f-main /* Sub-Conta */
DO:   
    ASSIGN v_cod_ccusto = INPUT contabiliza.sc-codigo.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

    ASSIGN c-titulo-ccusto-1:SCREEN-VALUE = v_titulo_ccusto.
    IF not can-find(tt_log_erro) THEN
        assign contabiliza.sc-codigo:format    in frame {&FRAME-NAME} = c-formato-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.sc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF contabiliza.sc-codigo IN FRAME f-main /* Sub-Conta */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME sc-var-camb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-var-camb V-table-Win
ON ENTRY OF sc-var-camb IN FRAME f-main /* Sub-Conta Variac Cambial */
DO:
    assign self:format = "x(20)".  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-var-camb V-table-Win
ON F5 OF sc-var-camb IN FRAME f-main /* Sub-Conta Variac Cambial */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 

   ASSIGN sc-var-camb:SCREEN-VALUE      = v_cod_ccusto.
   ASSIGN c-titulo-ccusto-4:SCREEN-VALUE = v_titulo_ccusto.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-var-camb V-table-Win
ON LEAVE OF sc-var-camb IN FRAME f-main /* Sub-Conta Variac Cambial */
DO:
    ASSIGN SELF:FORMAT  = "x(20)" 
           v_cod_ccusto = INPUT sc-var-camb.

    IF  v_cod_ccusto <> "" THEN DO:
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,       /* CCUSTO */
                                                   input  today,              /* DATA DE TRANSACAO */
                                                   output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */
    
        ASSIGN c-titulo-ccusto-4:SCREEN-VALUE = v_titulo_ccusto.
        IF not can-find(tt_log_erro) THEN
            assign sc-var-camb:format in frame {&FRAME-NAME} = c-formato-ccusto.  
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-var-camb V-table-Win
ON MOUSE-SELECT-DBLCLICK OF sc-var-camb IN FRAME f-main /* Sub-Conta Variac Cambial */
DO:
  APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME sc-var-camb-impto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-var-camb-impto V-table-Win
ON ENTRY OF sc-var-camb-impto IN FRAME f-main /* Sub-Conta Variac Cambial Impto */
DO:
    assign self:format = "x(20)".  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-var-camb-impto V-table-Win
ON F5 OF sc-var-camb-impto IN FRAME f-main /* Sub-Conta Variac Cambial Impto */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 

   ASSIGN sc-var-camb-impto:SCREEN-VALUE = v_cod_ccusto.
   ASSIGN c-titulo-ccusto-5:SCREEN-VALUE = v_titulo_ccusto.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-var-camb-impto V-table-Win
ON LEAVE OF sc-var-camb-impto IN FRAME f-main /* Sub-Conta Variac Cambial Impto */
DO:
    ASSIGN SELF:FORMAT  = "x(20)" 
           v_cod_ccusto = INPUT sc-var-camb-impto.

    IF  v_cod_ccusto <> "" THEN DO:
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,       /* CCUSTO */
                                                   input  today,              /* DATA DE TRANSACAO */
                                                   output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */
    
        ASSIGN c-titulo-ccusto-5:SCREEN-VALUE = v_titulo_ccusto.
        IF not can-find(tt_log_erro) THEN
            assign sc-var-camb-impto:format in frame {&FRAME-NAME} = c-formato-ccusto.  
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sc-var-camb-impto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF sc-var-camb-impto IN FRAME f-main /* Sub-Conta Variac Cambial Impto */
DO:
  APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME contabiliza.sc-var-movto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.sc-var-movto V-table-Win
ON ENTRY OF contabiliza.sc-var-movto IN FRAME f-main /* Sub-Conta Variac Movto */
DO:
    assign self:format = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.sc-var-movto V-table-Win
ON F5 OF contabiliza.sc-var-movto IN FRAME f-main /* Sub-Conta Variac Movto */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 

   ASSIGN contabiliza.sc-var-movto:SCREEN-VALUE     = v_cod_ccusto.
   ASSIGN c-titulo-ccusto-3:SCREEN-VALUE = v_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.sc-var-movto V-table-Win
ON LEAVE OF contabiliza.sc-var-movto IN FRAME f-main /* Sub-Conta Variac Movto */
DO:
    ASSIGN v_cod_ccusto = INPUT contabiliza.sc-var-movto.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

    ASSIGN c-titulo-ccusto-3:SCREEN-VALUE = v_titulo_ccusto.
    IF not can-find(tt_log_erro) THEN
        assign contabiliza.sc-var-movto:format    in frame {&FRAME-NAME} = c-formato-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.sc-var-movto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF contabiliza.sc-var-movto IN FRAME f-main /* Sub-Conta Variac Movto */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME contabiliza.sc-var-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.sc-var-saldo V-table-Win
ON ENTRY OF contabiliza.sc-var-saldo IN FRAME f-main /* Sub-Conta Variac Saldo */
DO:
    assign self:format = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.sc-var-saldo V-table-Win
ON F5 OF contabiliza.sc-var-saldo IN FRAME f-main /* Sub-Conta Variac Saldo */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 

   ASSIGN contabiliza.sc-var-saldo:SCREEN-VALUE     = v_cod_ccusto.
   ASSIGN c-titulo-ccusto-2:SCREEN-VALUE = v_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.sc-var-saldo V-table-Win
ON LEAVE OF contabiliza.sc-var-saldo IN FRAME f-main /* Sub-Conta Variac Saldo */
DO:
    ASSIGN v_cod_ccusto = INPUT contabiliza.sc-var-saldo.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

    ASSIGN c-titulo-ccusto-2:SCREEN-VALUE = v_titulo_ccusto.
    IF not can-find(tt_log_erro) THEN
        assign contabiliza.sc-var-saldo:format    in frame {&FRAME-NAME} = c-formato-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contabiliza.sc-var-saldo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF contabiliza.sc-var-saldo IN FRAME f-main /* Sub-Conta Variac Saldo */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF  

  {utp/ut-liter.i Conta_Var_Movimento *}
  assign contabiliza.ct-var-movto:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Conta_Var_Saldo *}
  assign contabiliza.ct-var-saldo:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Conta *}
  assign contabiliza.ct-codigo:label in frame {&frame-name} = return-value.  
  
  {utp/ut-liter.i Centro_Custo_Var_Movto *}
  assign contabiliza.sc-var-movto:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Centro_Custo_Var_Saldo *}
  assign contabiliza.sc-var-saldo:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Centro_Custo *}
  assign contabiliza.sc-codigo:label in frame {&frame-name} = return-value.   
  
  contabiliza.ge-codigo:load-mouse-pointer       ("image~\lupa.cur") in frame {&frame-name}.
  contabiliza.cod-depos:load-mouse-pointer       ("image~\lupa.cur") in frame {&frame-name}.
  contabiliza.cod-estabel:load-mouse-pointer     ("image~\lupa.cur") in frame {&frame-name}.
  contabiliza.ct-codigo:load-mouse-pointer       ("image~\lupa.cur") in frame {&frame-name}.
  contabiliza.ct-var-saldo:load-mouse-pointer    ("image~\lupa.cur") in frame {&frame-name}.
  contabiliza.ct-var-movto:load-mouse-pointer    ("image~\lupa.cur") in frame {&frame-name}.
  contabiliza.sc-codigo:load-mouse-pointer       ("image~\lupa.cur") in frame {&frame-name}.
  contabiliza.sc-var-saldo:load-mouse-pointer    ("image~\lupa.cur") in frame {&frame-name}.
  contabiliza.sc-var-movto:load-mouse-pointer    ("image~\lupa.cur") in frame {&frame-name}.  
  ct-var-camb:LOAD-MOUSE-POINTER                 ("image~\lupa.cur") in frame {&frame-name}.
  sc-var-camb:load-mouse-pointer                 ("image~\lupa.cur") in frame {&frame-name}.  
  ct-var-camb-impto:LOAD-MOUSE-POINTER           ("image~\lupa.cur") in frame {&frame-name}.
  sc-var-camb-impto:load-mouse-pointer           ("image~\lupa.cur") in frame {&frame-name}.  
  /************************ INTERNAL PROCEDURES ********************/

 
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
  {src/adm/template/row-list.i "contabiliza"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "contabiliza"}

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

FIND FIRST param-global NO-LOCK NO-ERROR.
IF  NOT AVAIL param-global THEN DO:
    BELL.
    RUN utp/utmsgs.p (input "show", input 16, input "").
    RETURN 'adm-error'.
END.
 
RUN pi-habilita-ct-var-camb.

  /* Code placed here will execute AFTER standard behavior.    */

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
  def var v_cod_finalid as char no-undo.

  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Altera formato da Conta para fazer as validaá‰es */
  run pi-desformata-campos.

  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */
 
  if contabiliza.ge-codigo:sensitive in frame {&frame-name} then do:
     find contabiliza  where 
          contabiliza.ge-codigo   = input frame {&frame-name} contabiliza.ge-codigo and
          contabiliza.cod-depos   = input frame {&frame-name} contabiliza.cod-depos and
          contabiliza.cod-estabel = input frame {&frame-name} contabiliza.cod-estabel 
          no-lock no-error.
     if avail contabiliza then do:
          run utp/ut-msgs.p (input "show":U, input 4042, input "").
          apply "entry" to contabiliza.ge-codigo in frame {&frame-name}.
          return 'ADM-ERROR':U.
     end.  
  end.  
  
  /* Busca dados da conta cont†bil */
  ASSIGN v_cod_cta_ctbl = contabiliza.ct-codigo:screen-value.
  run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                 input        "",                 /* PLANO DE CONTAS */
                                                 input-output v_cod_cta_ctbl,     /* CONTA */
                                                 input        today,              /* DATA TRANSACAO */   
                                                 output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                 output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                 output       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                 output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                 output table tt_log_erro).       /* ERROS */   
 
  find first tt_log_erro no-lock no-error.
  if avail tt_log_erro then do:
     run utp/ut-msgs.p (input "show":U,
                        input 17006,
                        STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        
                       
     apply "entry" to contabiliza.ct-codigo in frame {&frame-name}.
     return 'ADM-ERROR':U.       
  end.
    
  /* 9 - Saldo por grupo de estoque */
  assign v_cod_finalid = {adinc/i05ad049.i 4 9}.
  if lookup(v_cod_finalid, v_ind_finalid_cta) = 0 then do:
     run utp/ut-msgs.p (input "show":U, input 5769, input "").
     apply "entry" to contabiliza.ct-codigo in frame {&frame-name}.
     return 'ADM-ERROR':U.      
  end. 
  
  /* Verifica se a conta utiliza centro de custo */
  assign v_cod_estabel = input frame {&frame-name} contabiliza.cod-estabel.
  run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                     input  v_cod_estabel,      /* ESTABELECIMENTO EMS2 */
                                                     input  "",                 /* PLANO CONTAS */
                                                     input  v_cod_cta_ctbl,     /* CONTA */
                                                     input  today,              /* DT TRANSACAO */
                                                     output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                     output table tt_log_erro). /* ERROS */
  IF v_log_utz_ccusto THEN DO:
      /* Busca dados do centro de custo */
      ASSIGN v_cod_ccusto = contabiliza.sc-codigo:screen-value.
      run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                 input  v_cod_ccusto,       /* CCUSTO */
                                                 input  today,              /* DATA DE TRANSACAO */
                                                 output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */

      find first tt_log_erro no-lock no-error.
      if avail tt_log_erro then do:
         run utp/ut-msgs.p (input "show":U,
                            input 17006,
                            STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        

         apply "entry" to contabiliza.sc-codigo in frame {&frame-name}.
         return 'ADM-ERROR':U.       
      end.

  END.
   
  if contabiliza.ct-var-saldo:sensitive in frame {&frame-name} then do: 
     find estab-mat where
          estab-mat.cod-estabel = input frame {&frame-name} contabiliza.cod-estabel no-lock no-error.
          
     if avail estab-mat and
        estab-mat.usa-on-line then do:
            
        /* Busca dados da conta cont†bil */
        ASSIGN v_cod_cta_ctbl = contabiliza.ct-var-saldo:screen-value.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                       input        "",                 /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,     /* CONTA */
                                                       input        today,              /* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                       output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).       /* ERROS */ 
     
        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
           run utp/ut-msgs.p (input "show":U,
                              input 17006,
                              STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        

           apply "entry" to contabiliza.ct-var-saldo in frame {&frame-name}.
           return 'ADM-ERROR':U.       
        end.
        
        if  v_num_tip_cta_ctbl <> 1 and v_num_tip_cta_ctbl <> 5 then do:
           run utp/ut-msgs.p (input "show":U, input 4187 , input contabiliza.ct-var-saldo:label).
           apply "entry" to contabiliza.ct-var-saldo in frame {&frame-name}.
           return 'ADM-ERROR':U.
        end.

       /* if  conta -contab.estado <> 3 then do:*/
        if  v_num_sit_cta_ctbl <> 3 then do:
           run utp/ut-msgs.p (input "show":U, input 912, input contabiliza.ct-var-saldo:label).
           apply "entry" to contabiliza.ct-var-saldo in frame {&frame-name}.
           return 'ADM-ERROR':U.
        end.

       /* if  conta -contab.estoque <> 1 and
            conta -contab.estoque <> 2 then do: */
        if lookup({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) = 0 and 
           lookup({adinc/i05ad049.i 4 2}, v_ind_finalid_cta) = 0 then do:           
            run utp/ut-msgs.p (input "show":U, input 6559, input "").
            apply "entry" to contabiliza.ct-var-saldo in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        
        /* Verifica se a conta utiliza centro de custo */
        assign v_cod_estabel = input frame {&frame-name} contabiliza.cod-estabel.
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  v_cod_estabel,      /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            /* Busca dados do centro de custo */
            ASSIGN v_cod_ccusto = contabiliza.sc-var-saldo:screen-value.
            run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                       input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                       input  v_cod_ccusto,       /* CCUSTO */
                                                       input  today,              /* DATA DE TRANSACAO */
                                                       output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                       output table tt_log_erro). /* ERROS */

            find first tt_log_erro no-lock no-error.
            if avail tt_log_erro then do:
               run utp/ut-msgs.p (input "show":U,
                                  input 17006,
                                  STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        
    
               apply "entry" to contabiliza.sc-var-saldo in frame {&frame-name}.
               return 'ADM-ERROR':U.       
            end.
        END.
     end.
  end.
  
  if contabiliza.ct-var-movto:sensitive in frame {&frame-name} then do:
     
    /* Busca dados da conta cont†bil */
    ASSIGN v_cod_cta_ctbl = contabiliza.ct-var-movto:screen-value.
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */  
    
    find first tt_log_erro no-lock no-error.
    if avail tt_log_erro then do:
       run utp/ut-msgs.p (input "show":U,
                          input 17006,
                          STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        

       apply "entry" to contabiliza.ct-var-movto in frame {&frame-name}.
       return 'ADM-ERROR':U.       
    end.
    
    if  v_num_tip_cta_ctbl <> 1 and v_num_tip_cta_ctbl <> 5 then do:
        run utp/ut-msgs.p (input "show":U, input 4187 , input contabiliza.ct-var-movto:label).
        apply "entry" to contabiliza.ct-var-movto in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    if  v_num_sit_cta_ctbl <> 3 then do:
        run utp/ut-msgs.p (input "show":U, input 912, input contabiliza.ct-var-movto:label).
        apply "entry" to contabiliza.ct-var-movto in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    
    if lookup({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) = 0 and 
       lookup({adinc/i05ad049.i 4 2}, v_ind_finalid_cta) = 0 then do:               
        run utp/ut-msgs.p (input "show":U, input 6559, input "").
        apply "entry" to contabiliza.ct-var-movto in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    
    /* Verifica se a conta utiliza centro de custo */
    assign v_cod_estabel = input frame {&frame-name} contabiliza.cod-estabel.
    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  v_cod_estabel,      /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  v_cod_cta_ctbl,     /* CONTA */
                                                       input  today,              /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */
    IF v_log_utz_ccusto THEN DO:
        /* Busca dados do centro de custo */
        ASSIGN v_cod_ccusto = contabiliza.sc-var-movto:screen-value.
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,       /* CCUSTO */
                                                   input  today,              /* DATA DE TRANSACAO */
                                                   output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */
    
        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
           run utp/ut-msgs.p (input "show":U,
                              input 17006,
                              STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        
    
           apply "entry" to contabiliza.sc-var-movto in frame {&frame-name}.
           return 'ADM-ERROR':U.       
        end.
    END.
  end.    
  
  &if defined (bf_mat_fech_estab) &then
    if param-estoq.tp-fech = 2 then do:
       find estab-mat 
            where estab-mat.cod-estabel = input frame {&frame-name} contabiliza.cod-estabel
            no-lock no-error.
       if avail estab-mat then
          assign da-sumar-ate = estab-mat.sumar-ate.
    end.
    else 
      assign da-sumar-ate = param-estoq.data-1.
  &else
    assign da-sumar-ate = param-estoq.data-1.
  &endif

  if adm-new-record = no and 
     input frame {&frame-name} contabiliza.ct-codigo <> contabiliza.ct-codigo then do:
      run utp/ut-msgs.p (input "show":U, input 16115, input string(da-sumar-ate)).
      if return-value = "no" then do:
          apply "entry" to contabiliza.ct-codigo in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end. 
  end.

  RUN pi-valida-ct-var-camb.
  IF  RETURN-VALUE = "ADM-ERROR":U THEN
      RETURN "ADM-ERROR":U.

  ASSIGN c-ct-codigo-camb     = ct-var-camb:SCREEN-VALUE IN FRAME {&FRAME-NAME}
         c-sc-codigo-camb     = sc-var-camb:SCREEN-VALUE IN FRAME {&FRAME-NAME}
         c-ct-codigo-camb-imp = ct-var-camb-impto:SCREEN-VALUE IN FRAME {&FRAME-NAME}
         c-sc-codigo-camb-imp = sc-var-camb-impto:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

   /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
  
  assign contabiliza.cod-depos    = input frame {&frame-name} contabiliza.cod-depos
         contabiliza.ge-codigo    = input frame {&frame-name} contabiliza.ge-codigo
         contabiliza.cod-estabel  = input frame {&frame-name} contabiliza.cod-estabel
         contabiliza.ct-codigo    = input frame {&frame-name} contabiliza.ct-codigo
         contabiliza.ct-var-saldo = input frame {&frame-name} contabiliza.ct-var-saldo
         contabiliza.ct-var-movto = input frame {&frame-name} contabiliza.ct-var-movto.

  ASSIGN ct-var-camb:FORMAT       IN FRAME {&FRAME-NAME} = "x(20)"
         sc-var-camb:FORMAT       IN FRAME {&FRAME-NAME} = "x(20)"
         ct-var-camb-impto:FORMAT IN FRAME {&FRAME-NAME} = "x(20)"
         sc-var-camb-impto:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".

 
  ASSIGN ct-var-camb:SCREEN-VALUE IN FRAME {&FRAME-NAME}      = c-ct-codigo-camb        
         sc-var-camb:SCREEN-VALUE IN FRAME {&FRAME-NAME}      =  c-sc-codigo-camb       
         ct-var-camb-impto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-ct-codigo-camb-imp   
         sc-var-camb-impto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-sc-codigo-camb-imp . 


  
         
  run pi-formata-campos.
   
  assign l-adm-new-record = adm-new-record.

  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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
  
   for each item where  item.ge-codigo = contabiliza.ge-codigo no-lock :    
    for each movto-estoq where   
             movto-estoq.cod-estabel   = contabiliza.cod-estabel and
             movto-estoq.it-codigo = item.it-codigo and            
             movto-estoq.cod-depos     = contabiliza.cod-depos no-lock :             
                 
            run utp/ut-msgs.p (input "show":U, input 18241, input "").
            /*Registro n∆o pode ser eliminado, possui movimentaá‰es estoque*/        
            return 'ADM-ERROR':U.
      end.    
   end. 
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
      DISABLE ct-var-camb
              sc-var-camb 
              ct-var-camb-impto 
              sc-var-camb-impto WITH FRAME {&FRAME-NAME}.

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

  for first estabelec no-lock
      where estabelec.cod-estabel = contabiliza.cod-estabel.
  end.

  run pi-atribui-empresa.

  /* Handle da API Conta Cont†bil */
  run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
  /* Handle da API Centro Custo */
  run prgint\utb\utb742za.py persistent set h_api_ccusto.

  /* Retorna formato da conta contabil */
  run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                     input  "",                 /* PLANO CONTAS */
                                                     input  today,              /* DATA DE TRANSACAO */
                                                     output c-formato-conta,    /* FORMATO CONTA */
                                                     output table tt_log_erro). /* ERROS */
  /* Retorna formato do centro de custo */
  run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* PLANO CCUSTO */
                                                 input  today,              /* DATA DE TRANSACAO */
                                                 output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */ 
                                                 
  run pi-formata-campos.

  {utp/ut-liter.i Conta_Var_Movimento *}
  assign contabiliza.ct-var-movto:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Conta_Var_Saldo *}
  assign contabiliza.ct-var-saldo:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Conta *}
  assign contabiliza.ct-codigo:label in frame {&frame-name} = return-value.  
  
  {utp/ut-liter.i Centro_Custo_Var_Movto *}
  assign contabiliza.sc-var-movto:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Centro_Custo_Var_Saldo *}
  assign contabiliza.sc-var-saldo:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Centro_Custo *}
  assign contabiliza.sc-codigo:label in frame {&frame-name} = return-value. 

  if avail contabiliza then do:
      find grup-estoque where
           grup-estoque.ge-codigo = contabiliza.ge-codigo no-lock no-error.
      assign c-descricao = if avail grup-estoque then grup-estoque.descricao else "":U.
     
      find deposito where
           deposito.cod-depos = contabiliza.cod-depos no-lock no-error.
      assign c-nome-deposito = if avail deposito then deposito.nome else "":U.
     
      find estabelec where
           estabelec.cod-estabel = contabiliza.cod-estabel no-lock no-error.
      assign c-nome-estabelec = if avail estabelec then estabelec.nome else "":U.
 
      /*** Busca dados da conta cont†bil *****************/
      ASSIGN v_cod_cta_ctbl  = contabiliza.ct-codigo
             c-ct-codigo-ant = contabiliza.ct-codigo.
      run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                     input        "",                 /* PLANO DE CONTAS */
                                                     input-output v_cod_cta_ctbl,     /* CONTA */
                                                     input        today,              /* DATA TRANSACAO */   
                                                     output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                     output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                     output       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                     output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                     output table tt_log_erro).       /* ERROS */ 

      /* Busca dados do centro de custo */
      ASSIGN v_cod_ccusto    = contabiliza.sc-codigo
             c-sc-codigo-ant = contabiliza.sc-codigo.
      run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                 input  v_cod_ccusto,       /* CCUSTO */
                                                 input  today,              /* DATA DE TRANSACAO */
                                                 output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */
  
      /* Setando titulos da conta contabil e do centro de custo */    
      assign c-titulo-1 = v_titulo_cta_ctbl.
      assign c-titulo-ccusto-1 = v_titulo_ccusto.
      /****************************************************/

      ASSIGN v_cod_cta_ctbl = contabiliza.ct-var-saldo.
      run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                     input        "",                 /* PLANO DE CONTAS */
                                                     input-output v_cod_cta_ctbl,     /* CONTA */
                                                     input        today,              /* DATA TRANSACAO */   
                                                     output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                     output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                     output       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                     output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                     output table tt_log_erro).       /* ERROS */ 

      /* Busca dados do centro de custo */
      ASSIGN v_cod_ccusto = contabiliza.sc-var-saldo.
      run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                 input  v_cod_ccusto,       /* CCUSTO */
                                                 input  today,              /* DATA DE TRANSACAO */
                                                 output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */
  
      /* Setando titulos da conta contabil e do centro de custo */    
      assign c-titulo-2 = v_titulo_cta_ctbl.
      assign c-titulo-ccusto-2 = v_titulo_ccusto.
      /****************************************************/     
      
      ASSIGN v_cod_cta_ctbl = contabiliza.ct-var-movto.
      run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                     input        "",                 /* PLANO DE CONTAS */
                                                     input-output v_cod_cta_ctbl,     /* CONTA */
                                                     input        today,              /* DATA TRANSACAO */   
                                                     output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                     output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                     output       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                     output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                     output table tt_log_erro).       /* ERROS */ 

      /* Busca dados do centro de custo */
      ASSIGN v_cod_ccusto = contabiliza.sc-var-movto.
      run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                 input  v_cod_ccusto,       /* CCUSTO */
                                                 input  today,              /* DATA DE TRANSACAO */
                                                 output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */
  
      /* Setando titulos da conta contabil e do centro de custo */    
      assign c-titulo-3 = v_titulo_cta_ctbl.
      assign c-titulo-ccusto-3 = v_titulo_ccusto.


      /*** Busca dados da conta cont†bil de variacao cambial *****************/
      ASSIGN v_cod_cta_ctbl = substr(contabiliza.char-1,1,20)
             ct-var-camb    = v_cod_cta_ctbl.
      run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                     input        "",                 /* PLANO DE CONTAS */
                                                     input-output v_cod_cta_ctbl,     /* CONTA */
                                                     input        today,              /* DATA TRANSACAO */   
                                                     output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                     output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                     output       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                     output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                     output table tt_log_erro).       /* ERROS */ 

      /* Busca dados do centro de custo */
      ASSIGN v_cod_ccusto = substr(contabiliza.char-1,21,20)
             sc-var-camb  = v_cod_ccusto.
      run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                 input  v_cod_ccusto,       /* CCUSTO */
                                                 input  today,              /* DATA DE TRANSACAO */
                                                 output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */
  
      /* Setando titulos da conta contabil e do centro de custo */    
      assign c-titulo-4 = v_titulo_cta_ctbl.
      assign c-titulo-ccusto-4 = v_titulo_ccusto.
      /****************************************************/

      /*** Busca dados da conta cont†bil de variacao cambial imposto*****************/
      ASSIGN v_cod_cta_ctbl    = substr(contabiliza.char-1,41,20)
             ct-var-camb-impto = v_cod_cta_ctbl.
      run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                     input        "",                 /* PLANO DE CONTAS */
                                                     input-output v_cod_cta_ctbl,     /* CONTA */
                                                     input        today,              /* DATA TRANSACAO */   
                                                     output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                     output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                     output       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                     output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                     output table tt_log_erro).       /* ERROS */ 

      /* Busca dados do centro de custo */
      ASSIGN v_cod_ccusto = substr(contabiliza.char-1,61,20)
             sc-var-camb-impto = v_cod_ccusto.
      run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                 input  v_cod_ccusto,       /* CCUSTO */
                                                 input  today,              /* DATA DE TRANSACAO */
                                                 output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */
  
      /* Setando titulos da conta contabil e do centro de custo */    
      assign c-titulo-5 = v_titulo_cta_ctbl.
      assign c-titulo-ccusto-5 = v_titulo_ccusto.
      /****************************************************/

 
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if avail contabiliza then
      run pi-hab-bt-ct-adiant in h_handle_container (input rowid(contabiliza)).

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
  
  run get-attribute ('adm-new-record').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  if  contabiliza.cod-estabel:sensitive in frame {&frame-name} = no then
      run pi-habilita-contas.
      if  return-value = "NOK":U then
          return "ADM-ERROR":U.
      
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
   
  FIND FIRST param-global NO-LOCK NO-ERROR.
  IF  NOT AVAIL param-global THEN DO:
      BELL.
      RUN utp/utmsgs.p (input "show", input 16, input "").
      RETURN 'adm-error'.
  END.
  find first param-estoq no-lock no-error.

  DISABLE ct-var-camb
          sc-var-camb 
          ct-var-camb-impto
          sc-var-camb-impto WITH FRAME {&FRAME-NAME}.

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

  if RETURN-VALUE = 'ADM-ERROR':U then 
    RETURN 'ADM-ERROR':U. 

  if  not l-adm-new-record then do:
      session:set-wait-state("GENERAL").
      run utp/ut-acomp.p persistent set h-acomp.
      {utp/ut-liter.i Processando_Movimentaá‰es_dos_Itens * l}
      run pi-inicializar in h-acomp(input return-value).
      run pi-atribui-empresa.
      run pi_busca_dados_plano_cta_ctbl in h_api_cta_ctbl (input  i-empresa,            /* EMPRESA EMS2 */
                                                           input  "",                   /* PLANO DE CONTAS */
                                                           input  today,                /* DATA TRANSACAO */   
                                                           output v_des_plano_cta_ctbl, /* DESCRICAO PLANO DE CONTA */
                                                           output v_dt_plano_ini,       /* DATA INICIO PLANO*/
                                                           output v_dt_plano_fim,       /* DATA FIM PLANO */
                                                           output table tt_log_erro).   /* ERROS */ 
      for each item where
          item.ge-codigo = contabiliza.ge-codigo no-lock: 
          {utp/ut-field.i mgind item it-codigo 1}
          run pi-acompanhar in h-acomp (return-value + ": " + item.it-codigo).

          for each movto-estoq where
              movto-estoq.contabilizado = no and
              movto-estoq.it-codigo     = item.it-codigo and
              movto-estoq.cod-estabel   = contabiliza.cod-estabel and
              movto-estoq.cod-depos     = contabiliza.cod-depos no-lock:
            &if defined (bf_mat_fech_estab) &then
              if param-estoq.tp-fech = 2 then do:
                 find estab-mat 
                      where estab-mat.cod-estabel = movto-estoq.cod-estabel
                      no-lock no-error.
                 if avail estab-mat then
                    if movto-estoq.dt-trans <= estab-mat.sumar-ate then next.
              end.
              else 
                if movto-estoq.dt-trans <= param-estoq.data-1 then next.
            &else
              if movto-estoq.dt-trans <= param-estoq.data-1 then next.
            &endif
              if movto-estoq.dt-trans < v_dt_plano_ini then next.
              do trans:
                  CASE movto-estoq.cod-prog-orig:
                      WHEN "CE0108" THEN NEXT.
                      WHEN "CEAPI006" THEN DO:
                        IF  movto-estoq.ct-saldo <> c-ct-codigo-ant
                        AND movto-estoq.sc-saldo <> c-sc-codigo-ant THEN
                            NEXT.
                      END.
                      OTHERWISE DO:
                          FIND FIRST b-movto 
                               WHERE ROWID(b-movto) = ROWID(movto-estoq) EXCLUSIVE-LOCK NO-ERROR.
                              
                          ASSIGN b-movto.ct-saldo    = contabiliza.ct-codigo
                                 b-movto.sc-saldo    = contabiliza.sc-codigo.
                                 
                          RELEASE b-movto.
                      END.
                  END.
              END.
              
          end.
      end.
      session:set-wait-state("").
      run pi-finalizar in h-acomp.      
  end. 
    
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atribui-empresa V-table-Win 
PROCEDURE pi-atribui-empresa :
/*------------------------------------------------------------------------------
  Purpose: atribuir valor a variavel i-empresa    
  Parameters: n/a 
  Notes: E necessario validar as contas informadas contra as respectivas 
         empresas com as quais estao relacionadas, quando no CD0101 estiver 
         parametrizado como Conta Contabil = "Empresa X Estabelecimento" 
------------------------------------------------------------------------------*/

/* run cdp/cd9970.p (input  rowid(estabelec),
                  output i-empresa). */
ASSIGN i-empresa = estabelec.ep-codigo WHEN AVAIL estabelec.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desformata-campos V-table-Win 
PROCEDURE pi-desformata-campos :
assign contabiliza.ct-codigo:format    in frame {&frame-name} = "x(20)":U
       contabiliza.ct-var-saldo:format in frame {&frame-name} = "x(20)":U
       contabiliza.ct-var-movto:format in frame {&frame-name} = "x(20)":U
       contabiliza.sc-codigo:format    in frame {&frame-name} = "x(20)":U
       contabiliza.sc-var-saldo:format in frame {&frame-name} = "x(20)":U
       contabiliza.sc-var-movto:format in frame {&frame-name} = "x(20)":U
       ct-var-camb:FORMAT              IN FRAME {&FRAME-NAME} = "x(20)":U
       sc-var-camb:FORMAT              IN FRAME {&FRAME-NAME} = "x(20)":U
       ct-var-camb-impto:FORMAT        IN FRAME {&FRAME-NAME} = "x(20)":U
       sc-var-camb-impto:FORMAT        IN FRAME {&FRAME-NAME} = "x(20)":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campos V-table-Win 
PROCEDURE pi-formata-campos :
/* Formatando conta e centro de custo */
  if c-formato-conta <> "" then do:
      assign contabiliza.ct-codigo:format    in frame {&FRAME-NAME} = c-formato-conta.
      assign contabiliza.ct-var-saldo:format in frame {&FRAME-NAME} = c-formato-conta.
      assign contabiliza.ct-var-movto:format in frame {&FRAME-NAME} = c-formato-conta.
      assign ct-var-camb:format              in frame {&FRAME-NAME} = c-formato-conta.
      assign ct-var-camb-impto:format        in frame {&FRAME-NAME} = c-formato-conta.
  end.
  if c-formato-ccusto <> "" then do:
      assign contabiliza.sc-codigo:format    in frame {&FRAME-NAME} = c-formato-ccusto.
      assign contabiliza.sc-var-saldo:format in frame {&FRAME-NAME} = c-formato-ccusto.
      assign contabiliza.sc-var-movto:format in frame {&FRAME-NAME} = c-formato-ccusto.
      assign sc-var-camb:format              in frame {&FRAME-NAME} = c-formato-ccusto.
      assign sc-var-camb-impto:format        in frame {&FRAME-NAME} = c-formato-ccusto.
  end.           
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-contas V-table-Win 
PROCEDURE pi-habilita-contas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF  NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.
    
    IF  NOT AVAIL param-global THEN DO:
      RUN utp/utmsgs.p (input "show":U, input 16, input "").
      RETURN 'adm-error'.
/*      APPLY "close":U TO THIS-PROCEDURE.*/
    END.
 
    find first estab-mat 
         where estab-mat.cod-estabel = input frame {&frame-name} contabiliza.cod-estabel 
         no-lock no-error.

    if  not avail estab-mat then do:
        {utp/ut-table.i mgind estab-mat 1}
        run utp/ut-msgs.p (input "show":U,
                           input 56,
                           input return-value).
        return "NOK":U.
    end.
  
  
    if estab-mat.usa-on-line then
       enable contabiliza.ct-var-saldo 
              contabiliza.ct-var-movto
              contabiliza.sc-var-saldo 
              contabiliza.sc-var-movto with frame {&frame-name}.
    else  
       disable contabiliza.ct-var-saldo 
               contabiliza.ct-var-movto
               contabiliza.sc-var-saldo 
               contabiliza.sc-var-movto with frame {&frame-name}.
                   
    RUN pi-habilita-ct-var-camb.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-ct-var-camb V-table-Win 
PROCEDURE pi-habilita-ct-var-camb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   IF  NOT AVAIL param-estoq THEN
       FIND FIRST param-estoq NO-LOCK NO-ERROR.

   IF  AVAIL param-estoq 
   AND SUBSTRING(param-estoq.char-2,100,1) = "S":U /* utiliza moeda funcional */ THEN
       ENABLE ct-var-camb
              sc-var-camb 
              ct-var-camb-impto 
              sc-var-camb-impto WITH FRAME {&FRAME-NAME}.
   ELSE
       DISABLE ct-var-camb
               sc-var-camb 
               ct-var-camb-impto
               sc-var-camb-impto WITH FRAME {&FRAME-NAME}.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pega-valor V-table-Win 
PROCEDURE pi-pega-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output param p-c-contabil  as char.
def output param p-c-var-saldo as char.
def output param p-c-movto     as char.
def output param p-c-titulo-1  as char.
def output param p-c-titulo-2  as char.
def output param p-c-titulo-3  as char.
def output param p-c-sc-codigo    as char.
def output param p-c-sc-var-saldo as char.
def output param p-c-sc-var-movto as char.
def output param p-c-titulo-ccusto-1  as char.
def output param p-c-titulo-ccusto-2  as char.
def output param p-c-titulo-ccusto-3  as char.
def output param p-c-estabelec as char.

run pi-desformata-campos.

assign p-c-contabil  = input frame {&frame-name} contabiliza.ct-codigo.
assign p-c-var-saldo = input frame {&frame-name} contabiliza.ct-var-saldo.
assign p-c-movto     = input frame {&frame-name} contabiliza.ct-var-movto.
assign p-c-titulo-1  = input frame {&frame-name} c-titulo-1.
assign p-c-titulo-2  = input frame {&frame-name} c-titulo-2.
assign p-c-titulo-3  = input frame {&frame-name} c-titulo-3.
assign p-c-sc-codigo    = input frame {&frame-name} contabiliza.sc-codigo.
assign p-c-sc-var-saldo = input frame {&frame-name} contabiliza.sc-var-saldo.
assign p-c-sc-var-movto = input frame {&frame-name} contabiliza.sc-var-movto.
assign p-c-titulo-ccusto-1  = input frame {&frame-name} c-titulo-ccusto-1.
assign p-c-titulo-ccusto-2  = input frame {&frame-name} c-titulo-ccusto-2.
assign p-c-titulo-ccusto-3  = input frame {&frame-name} c-titulo-ccusto-3.
assign p-c-estabelec = input frame {&frame-name} contabiliza.cod-estabel.

run pi-formata-campos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ct-var-camb V-table-Win 
PROCEDURE pi-valida-ct-var-camb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /*--- Valida Conta Variacao Cambial ---*/
   IF  NOT AVAIL param-estoq THEN
       FIND FIRST param-estoq NO-LOCK NO-ERROR.

   IF  AVAIL param-estoq 
   AND SUBSTRING(param-estoq.char-2,100,1) = "S":U /* utiliza moeda funcional */ 
   AND ct-var-camb:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN 
   DO WITH FRAME {&FRAME-NAME}:

        /* Busca dados da conta cont†bil */
        ASSIGN v_cod_cta_ctbl = ct-var-camb:screen-value.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                       input        "",                 /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,     /* CONTA */
                                                       input        today,              /* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                       output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).       /* ERROS */  
        
        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
           run utp/ut-msgs.p (input "show":U,
                              input 17006,
                              STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        
    
           apply "entry" to ct-var-camb in frame {&frame-name}.
           return 'ADM-ERROR':U.       
        end.

        if lookup({adinc/i05ad049.i 4 2}, v_ind_finalid_cta) = 0  then do:               
            run utp/ut-msgs.p (input "show":U, INPUT 19027, input "").
            apply "entry" to ct-var-camb in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        /*--------*/
  
        /* Verifica se a conta utiliza centro de custo */
        assign v_cod_estabel = input frame {&frame-name} contabiliza.cod-estabel.
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  v_cod_estabel,      /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            /* Busca dados do centro de custo */
            ASSIGN v_cod_ccusto = sc-var-camb:screen-value.
            run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                       input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                       input  v_cod_ccusto,       /* CCUSTO */
                                                       input  today,              /* DATA DE TRANSACAO */
                                                       output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                       output table tt_log_erro). /* ERROS */

            find first tt_log_erro no-lock no-error.
            if avail tt_log_erro then do:
               run utp/ut-msgs.p (input "show":U,
                                  input 17006,
                                  STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        

               apply "entry" to sc-var-camb in frame {&frame-name}.
               return 'ADM-ERROR':U.       
            end.

        END.
   END.
   /*----------------*/

   /*--- Valida Conta Variacao Cambial Imposto ---*/
   IF  NOT AVAIL param-estoq THEN
       FIND FIRST param-estoq NO-LOCK NO-ERROR.

   IF  AVAIL param-estoq 
   AND SUBSTRING(param-estoq.char-2,100,1) = "S":U /* utiliza moeda funcional */ 
   AND ct-var-camb-impto:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN 
   DO WITH FRAME {&FRAME-NAME}:

        /* Busca dados da conta cont†bil */
        ASSIGN v_cod_cta_ctbl = ct-var-camb-impto:screen-value.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                       input        "",                 /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,     /* CONTA */
                                                       input        today,              /* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                       output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).       /* ERROS */  
        
        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
           run utp/ut-msgs.p (input "show":U,
                              input 17006,
                              STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        
    
           apply "entry" to ct-var-camb-impto in frame {&frame-name}.
           return 'ADM-ERROR':U.       
        end.

        if lookup({adinc/i05ad049.i 4 2}, v_ind_finalid_cta) = 0  then do:               
            run utp/ut-msgs.p (input "show":U, INPUT 19027, input "").
            apply "entry" to ct-var-camb-impto in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        /*--------*/
  
        /* Verifica se a conta utiliza centro de custo */
        assign v_cod_estabel = input frame {&frame-name} contabiliza.cod-estabel.
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  v_cod_estabel,      /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            /* Busca dados do centro de custo */
            ASSIGN v_cod_ccusto = sc-var-camb-impto:screen-value.
            run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                       input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                       input  v_cod_ccusto,       /* CCUSTO */
                                                       input  today,              /* DATA DE TRANSACAO */
                                                       output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                       output table tt_log_erro). /* ERROS */

            find first tt_log_erro no-lock no-error.
            if avail tt_log_erro then do:
               run utp/ut-msgs.p (input "show":U,
                                  input 17006,
                                  STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        

               apply "entry" to sc-var-camb-impto in frame {&frame-name}.
               return 'ADM-ERROR':U.       
            end.

        END.
        /*----------------*/

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
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
   
   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
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
  {src/adm/template/snd-list.i "contabiliza"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
------------------------------------------------------------------------------*/

    def input parameter h_container as handle no-undo.
    
    assign h_handle_container = h_container.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
