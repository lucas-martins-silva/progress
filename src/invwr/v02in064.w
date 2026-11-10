&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V02IN064 2.00.00.005 } /*** "010005" 09/01/2026 14:41:39  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in064 MUT}
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
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

def var l-erro as logical.
/* Local Variable Definitions ---                                       */

def var i-empresa like param-global.empresa-prin no-undo.

/* Vari veis de formato da conta */
/*def var c-format-conta    as char no-undo.*/

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.

define var c-formato-conta  as char no-undo.
define var c-formato-ccusto as char no-undo. 
/* Variáveis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Variáveis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo. 
def var v_log_utz_ccusto     as log    no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia".

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 RECT-1 ~
rt-mold c-estabel i-ge-ini i-ge-fim c-depos-ini c-depos-fim ~
c-conta-ctbl c-sc-codigo c-conta-var-saldo c-sc-saldo c-conta-movto ~
c-sc-movto 
&Scoped-Define DISPLAYED-OBJECTS c-estabel i-ge-ini i-ge-fim ~
c-depos-ini c-depos-fim c-conta-ctbl c-tit-cta-contab c-sc-codigo ~
c-tit-sc-codigo c-conta-var-saldo c-tit-cta-saldo c-sc-saldo ~
c-tit-sc-var-saldo c-conta-movto c-tit-cta-movto c-sc-movto ~
c-tit-sc-var-movto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS c-estabel i-ge-ini i-ge-fim ~
c-depos-ini c-depos-fim 
&Scoped-define ADM-ASSIGN-FIELDS c-estabel i-ge-ini i-ge-fim ~
c-depos-ini c-depos-fim 
&Scoped-define ADM-MODIFY-FIELDS c-estabel i-ge-ini i-ge-fim ~
c-depos-ini c-depos-fim 

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
DEFINE VARIABLE c-conta-ctbl AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta Cont bil":R17 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY .88.

DEFINE VARIABLE c-conta-movto AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta Movimento":R18 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-conta-var-saldo AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta Var Saldo":R18 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-depos-fim AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88.

DEFINE VARIABLE c-depos-ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito":R10 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88.

DEFINE VARIABLE c-estabel LIKE estabelec.cod-estabel
     LABEL "Estab":R7 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-codigo AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo":R17 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY .88.

DEFINE VARIABLE c-sc-movto AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo Movimento":R18 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-saldo AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo Saldo":R18 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-cta-contab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-cta-movto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-cta-saldo AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-codigo AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-var-movto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-sc-var-saldo AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE i-ge-fim AS INTEGER FORMAT "99" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88.

DEFINE VARIABLE i-ge-ini AS INTEGER FORMAT "99" INITIAL 0 
     LABEL "Grupo Estoque":R16 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\ii-las":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-4
     FILENAME "image\ii-las":U
     SIZE 3 BY .83.

DEFINE IMAGE IMAGE-5
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-6
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY .75.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 6.75.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-estabel AT ROW 1.25 COL 25 COLON-ALIGNED HELP
          ""
          LABEL "Estab":R7
     i-ge-ini AT ROW 2.25 COL 25 COLON-ALIGNED
     i-ge-fim AT ROW 2.25 COL 48.43 COLON-ALIGNED NO-LABEL
     c-depos-ini AT ROW 3.21 COL 25 COLON-ALIGNED
     c-depos-fim AT ROW 3.25 COL 48.43 COLON-ALIGNED NO-LABEL
     c-conta-ctbl AT ROW 4.96 COL 24.72 COLON-ALIGNED
     c-tit-cta-contab AT ROW 4.96 COL 43.57 COLON-ALIGNED NO-LABEL
     c-sc-codigo AT ROW 5.96 COL 24.72 COLON-ALIGNED
     c-tit-sc-codigo AT ROW 5.96 COL 43.57 COLON-ALIGNED NO-LABEL
     c-conta-var-saldo AT ROW 6.96 COL 24.72 COLON-ALIGNED HELP
          "Conta cont bil de varia‡Æo do saldo"
     c-tit-cta-saldo AT ROW 6.96 COL 43.57 COLON-ALIGNED NO-LABEL
     c-sc-saldo AT ROW 7.96 COL 24.72 COLON-ALIGNED HELP
          "Conta cont bil de varia‡Æo do saldo"
     c-tit-sc-var-saldo AT ROW 7.96 COL 43.57 COLON-ALIGNED NO-LABEL
     c-conta-movto AT ROW 8.96 COL 24.72 COLON-ALIGNED HELP
          "Conta cont bil de movimento"
     c-tit-cta-movto AT ROW 8.96 COL 43.57 COLON-ALIGNED NO-LABEL
     c-sc-movto AT ROW 9.96 COL 24.72 COLON-ALIGNED HELP
          "Conta cont bil de varia‡Æo do saldo"
     c-tit-sc-var-movto AT ROW 9.96 COL 43.57 COLON-ALIGNED NO-LABEL
     IMAGE-3 AT ROW 2.25 COL 47
     IMAGE-4 AT ROW 3.25 COL 47
     IMAGE-5 AT ROW 2.17 COL 35
     IMAGE-6 AT ROW 3.25 COL 35
     RECT-1 AT ROW 4.5 COL 1
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 10.42
         WIDTH              = 89.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-depos-fim IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN c-depos-ini IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN c-estabel IN FRAME f-main
   1 2 3 LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE          */
/* SETTINGS FOR FILL-IN c-tit-cta-contab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-cta-movto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-cta-saldo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-sc-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-sc-var-movto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-sc-var-saldo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-ge-fim IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN i-ge-ini IN FRAME f-main
   1 2 3                                                                */
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

&Scoped-define SELF-NAME c-conta-ctbl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-ctbl V-table-Win
ON ENTRY OF c-conta-ctbl IN FRAME f-main /* Conta Cont bil */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE c-sc-codigo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-ctbl V-table-Win
ON F5 OF c-conta-ctbl IN FRAME f-main /* Conta Cont bil */
DO:
  assign i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = yes.

   def var v_cod_finalid as char no-undo.                                               
   assign v_cod_finalid = {adinc/i05ad049.i 4 9}. /* 9 - Saldo por grupo de estoque */

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* M…DULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  v_cod_finalid,      /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 

   ASSIGN c-conta-ctbl:SCREEN-VALUE = v_cod_cta_ctbl.
   ASSIGN c-tit-cta-contab:SCREEN-VALUE = v_titulo_cta_ctbl.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-ctbl V-table-Win
ON LEAVE OF c-conta-ctbl IN FRAME f-main /* Conta Cont bil */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT c-conta-ctbl.

    /* Busca dados da conta cont bil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUAø°O DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN SELF:FORMAT = c-formato-conta.

        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  c-estabel:screen-value in frame {&FRAME-NAME},        /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            ENABLE c-sc-codigo WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            ASSIGN c-sc-codigo:SCREEN-VALUE = "".
            DISABLE c-sc-codigo WITH FRAME {&FRAME-NAME}.
        END.
        /************************************************/
    END.

    ASSIGN c-tit-cta-contab:SCREEN-VALUE = v_titulo_cta_ctbl.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-ctbl V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta-ctbl IN FRAME f-main /* Conta Cont bil */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-conta-movto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-movto V-table-Win
ON ENTRY OF c-conta-movto IN FRAME f-main /* Conta Movimento */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE c-sc-movto WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-movto V-table-Win
ON F5 OF c-conta-movto IN FRAME f-main /* Conta Movimento */
DO:
  assign i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = yes.

   def var v_cod_finalid as char no-undo.                                               
   /* Consumo e nÆo consumo */
   assign v_cod_finalid = {adinc/i05ad049.i 4 1} + "," + {adinc/i05ad049.i 4 2}.

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* M…DULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  v_cod_finalid,      /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 

   ASSIGN c-conta-movto:SCREEN-VALUE = v_cod_cta_ctbl.
   ASSIGN c-tit-cta-movto:SCREEN-VALUE = v_titulo_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-movto V-table-Win
ON LEAVE OF c-conta-movto IN FRAME f-main /* Conta Movimento */
DO:

    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT c-conta-movto.

    /* Busca dados da conta cont˜bil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUAø°O DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN SELF:FORMAT = c-formato-conta.

        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  c-estabel:screen-value in frame {&FRAME-NAME},        /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            ENABLE c-sc-movto WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            ASSIGN c-sc-movto:SCREEN-VALUE = "".
            DISABLE c-sc-movto WITH FRAME {&FRAME-NAME}.
        END.
        /************************************************/
    END.

    ASSIGN c-tit-cta-movto:SCREEN-VALUE = v_titulo_cta_ctbl.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-movto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta-movto IN FRAME f-main /* Conta Movimento */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-conta-var-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-var-saldo V-table-Win
ON ENTRY OF c-conta-var-saldo IN FRAME f-main /* Conta Var Saldo */
DO:
  ASSIGN SELF:FORMAT = "x(20)".
  ENABLE c-sc-saldo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-var-saldo V-table-Win
ON F5 OF c-conta-var-saldo IN FRAME f-main /* Conta Var Saldo */
DO:
  assign i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = yes.

   def var v_cod_finalid as char no-undo.                                       
   /* Consumo e nÆo consumo */
   assign v_cod_finalid = {adinc/i05ad049.i 4 1} + "," + {adinc/i05ad049.i 4 2}.

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* M…DULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  v_cod_finalid,      /* FINALIDADES */
                                                  input  today,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 

   ASSIGN c-conta-var-saldo:SCREEN-VALUE = v_cod_cta_ctbl.
   ASSIGN c-tit-cta-saldo:SCREEN-VALUE = v_titulo_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-var-saldo V-table-Win
ON LEAVE OF c-conta-var-saldo IN FRAME f-main /* Conta Var Saldo */
DO:

    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT c-conta-var-saldo.

    /* Busca dados da conta cont˜bil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUAø°O DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN SELF:FORMAT = c-formato-conta.

        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  c-estabel:screen-value in frame {&FRAME-NAME},        /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            ENABLE c-sc-saldo WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            ASSIGN c-sc-saldo:SCREEN-VALUE = "".
            DISABLE c-sc-saldo WITH FRAME {&FRAME-NAME}.
        END.
        /************************************************/
    END.

    ASSIGN c-tit-cta-saldo:SCREEN-VALUE = v_titulo_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-var-saldo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta-var-saldo IN FRAME f-main /* Conta Var Saldo */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-depos-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-fim V-table-Win
ON F5 OF c-depos-fim IN FRAME f-main
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in084.w
                       &campo=c-depos-fim
                       &campozoom=cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-fim V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-depos-fim IN FRAME f-main
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-depos-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-ini V-table-Win
ON F5 OF c-depos-ini IN FRAME f-main /* Dep¢sito */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in084.w
                       &campo=c-depos-ini
                       &campozoom=cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-ini V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-depos-ini IN FRAME f-main /* Dep¢sito */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estabel V-table-Win
ON F5 OF c-estabel IN FRAME f-main /* Estab */
DO:

{include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=c-estabel
                       &campozoom=cod-estabel}          

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-estabel IN FRAME f-main /* Estab */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo V-table-Win
ON ENTRY OF c-sc-codigo IN FRAME f-main /* Centro Custo */
DO:
    assign c-sc-codigo:format in frame {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo V-table-Win
ON F5 OF c-sc-codigo IN FRAME f-main /* Centro Custo */
DO:
  
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 

   ASSIGN c-sc-codigo:SCREEN-VALUE     = v_cod_ccusto.
   ASSIGN c-tit-sc-codigo:SCREEN-VALUE = v_titulo_ccusto.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo V-table-Win
ON LEAVE OF c-sc-codigo IN FRAME f-main /* Centro Custo */
DO:
    ASSIGN c-sc-saldo:format in frame {&FRAME-NAME} = "x(20)".
    ASSIGN v_cod_ccusto = c-sc-codigo:SCREEN-VALUE.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

    ASSIGN c-sc-codigo:SCREEN-VALUE     = v_cod_ccusto.
    ASSIGN c-tit-sc-codigo:SCREEN-VALUE = v_titulo_ccusto.
    IF not can-find(tt_log_erro) THEN
        assign c-sc-codigo:format    in frame {&FRAME-NAME} = c-formato-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-sc-codigo IN FRAME f-main /* Centro Custo */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo V-table-Win
ON ENTRY OF c-sc-codigo IN FRAME f-main /* Conta */
DO:
    assign c-sc-codigo:format in frame {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-sc-movto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-movto V-table-Win
ON ENTRY OF c-sc-movto IN FRAME f-main /* Centro Custo Movimento */
DO:
    assign c-sc-movto:format in frame {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-movto V-table-Win
ON F5 OF c-sc-movto IN FRAME f-main /* Centro Custo Movimento */
DO:
     run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                         input "",                  /* CODIGO DO PLANO CCUSTO */
                                         input "",                  /* UNIDADE DE NEGOCIO */
                                         input today,               /* DATA DE TRANSACAO */
                                         output v_cod_ccusto,       /* CODIGO CCUSTO */
                                         output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                         output table tt_log_erro). /* ERROS */ 

     ASSIGN c-sc-movto:SCREEN-VALUE     = v_cod_ccusto.
     ASSIGN c-tit-sc-var-movto:SCREEN-VALUE = v_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-movto V-table-Win
ON LEAVE OF c-sc-movto IN FRAME f-main /* Centro Custo Movimento */
DO:
    ASSIGN c-sc-movto:format in frame {&FRAME-NAME} = "x(20)".
    ASSIGN v_cod_ccusto = INPUT c-sc-movto.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

     ASSIGN c-sc-movto:SCREEN-VALUE     = v_cod_ccusto.
     ASSIGN c-tit-sc-var-movto:SCREEN-VALUE = v_titulo_ccusto.
     IF not can-find(tt_log_erro) THEN
        assign c-sc-movto:format    in frame {&FRAME-NAME} = c-formato-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-movto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-sc-movto IN FRAME f-main /* Centro Custo Movimento */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-sc-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-saldo V-table-Win
ON ENTRY OF c-sc-saldo IN FRAME f-main /* Centro Custo Saldo */
DO:
    assign c-sc-movto:format in frame {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-saldo V-table-Win
ON F5 OF c-sc-saldo IN FRAME f-main /* Centro Custo Saldo */
DO:
     run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                         input "",                  /* CODIGO DO PLANO CCUSTO */
                                         input "",                  /* UNIDADE DE NEGOCIO */
                                         input today,               /* DATA DE TRANSACAO */
                                         output v_cod_ccusto,       /* CODIGO CCUSTO */
                                         output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                         output table tt_log_erro). /* ERROS */ 

     ASSIGN c-sc-saldo:SCREEN-VALUE         = v_cod_ccusto.
     ASSIGN c-tit-sc-var-saldo:SCREEN-VALUE = v_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-saldo V-table-Win
ON LEAVE OF c-sc-saldo IN FRAME f-main /* Centro Custo Saldo */
DO:
    ASSIGN c-sc-saldo:format in frame {&FRAME-NAME} = "x(20)".
    ASSIGN v_cod_ccusto = INPUT c-sc-saldo.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

     ASSIGN c-sc-saldo:SCREEN-VALUE         = v_cod_ccusto.
     ASSIGN c-tit-sc-var-saldo:SCREEN-VALUE = v_titulo_ccusto.
     IF not can-find(tt_log_erro) THEN
        assign c-sc-saldo:format    in frame {&FRAME-NAME} = c-formato-ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-saldo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-sc-saldo IN FRAME f-main /* Centro Custo Saldo */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-saldo V-table-Win
ON ENTRY OF c-sc-saldo IN FRAME f-main /* Conta */
DO:
    assign c-sc-saldo:format in frame {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME i-ge-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ge-fim V-table-Win
ON F5 OF i-ge-fim IN FRAME f-main
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in142.w
                       &campo=i-ge-fim
                       &campozoom=ge-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ge-fim V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-ge-fim IN FRAME f-main
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-ge-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ge-ini V-table-Win
ON F5 OF i-ge-ini IN FRAME f-main /* Grupo Estoque */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in142.w"
                       &campo=i-ge-ini
                       &campozoom=ge-codigo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ge-ini V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-ge-ini IN FRAME f-main /* Grupo Estoque */
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

    if i-ge-ini:load-mouse-pointer          ("image~\lupa.cur") in frame {&frame-name} then.
    if c-depos-ini:load-mouse-pointer       ("image~\lupa.cur") in frame {&frame-name} then.
    if c-estabel:load-mouse-pointer     ("image~\lupa.cur") in frame {&frame-name} then.
    if i-ge-fim:load-mouse-pointer          ("image~\lupa.cur") in frame {&frame-name} then.
    if c-depos-fim:load-mouse-pointer       ("image~\lupa.cur") in frame {&frame-name} then.
/*    if c-estabel-fim:load-mouse-pointer     ("image~\lupa.cur") in frame {&frame-name} then.*/
    if c-conta-ctbl:load-mouse-pointer  ("image~\lupa.cur") in frame {&frame-name} then.
    if c-conta-var-saldo:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then. 
    if c-conta-movto:load-mouse-pointer     ("image~\lupa.cur") in frame {&frame-name} then.
    if c-sc-codigo:load-mouse-pointer       ("image~\lupa.cur") in frame {&frame-name} then.
    if c-sc-saldo:load-mouse-pointer        ("image~\lupa.cur") in frame {&frame-name} then. 
    if c-sc-movto:load-mouse-pointer        ("image~\lupa.cur") in frame {&frame-name} then.    

 /************************ INTERNAL PROCEDURES ********************/

find first param-global no-lock no-error.

/*&IF "{&mguni_version}" >= "2.071" &THEN                            */
/*ASSIGN c-estabel-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "ZZZZZ".*/
/*&ELSE                                                              */
/*ASSIGN c-estabel-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "ZZZ".  */
/*&ENDIF                                                             */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  find first param-global no-lock no-error.
  
  assign i-empresa = "".
  find estabelec where
       estabelec.cod-estabel = c-estabel:screen-value in frame {&FRAME-NAME} no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec.         
  
  /* Handle da API Conta Cont bil */
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
  /* formatando campos */
  run pi-formata-campos.

  assign i-ge-ini:screen-value      in frame {&frame-name} = string(0)
         i-ge-fim:screen-value      in frame {&frame-name} = string(99)
         c-depos-fim:screen-value   in frame {&frame-name} = "ZZZ".
/*&IF "{&mguni_version}" >= "2.071" &THEN                              */
/*         c-estabel-fim:screen-value in frame {&frame-name} = "ZZZZZ".*/
/*&ELSE                                                                */
/*         c-estabel-fim:screen-value in frame {&frame-name} = "ZZZ".  */
/*&ENDIF                                                               */

  {utp/ut-liter.i Conta}
  assign c-conta-ctbl:label in frame {&FRAME-NAME} = trim(return-value).         

  {utp/ut-liter.i Conta_Var_Saldo}
  assign c-conta-var-saldo:label in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-liter.i Conta_Movimento}
  assign c-conta-movto:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind grup-estoque ge-codigo 1}
  assign i-ge-ini:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind deposito cod-depos 1}
  assign c-depos-ini:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Estabelecimento}
  assign c-estabel:label in frame {&FRAME-NAME} = trim(return-value).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desformata-campos V-table-Win 
PROCEDURE pi-desformata-campos :
/* Altera formato da Conta para fazer as valida‡äes */
    assign c-conta-ctbl:format      in frame {&frame-name} = "x(20)":U
           c-conta-var-saldo:format in frame {&frame-name} = "x(20)":U
           c-conta-movto:format     in frame {&frame-name} = "x(20)":U
           c-sc-codigo:format       in frame {&frame-name} = "x(20)":U
           c-sc-saldo:format        in frame {&frame-name} = "x(20)":U
           c-sc-movto:format        in frame {&frame-name} = "x(20)":U. 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campos V-table-Win 
PROCEDURE pi-formata-campos :
/* Formatando conta e centro de custo */
  if c-formato-conta <> "" then do:
    assign c-conta-ctbl:FORMAT in frame {&FRAME-NAME} = c-formato-conta. 
    assign c-conta-var-saldo:FORMAT in frame {&FRAME-NAME} = c-formato-conta.
    assign c-conta-movto:FORMAT in frame {&FRAME-NAME} = c-formato-conta.
  end.
  if c-formato-ccusto <> "" then do:
    assign c-sc-codigo:FORMAT in frame {&FRAME-NAME} = c-formato-ccusto.
    assign c-sc-saldo:FORMAT in frame {&FRAME-NAME} = c-formato-ccusto.
    assign c-sc-movto:FORMAT in frame {&FRAME-NAME} = c-formato-ccusto.
  end.    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-geracao V-table-Win 
PROCEDURE pi-geracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param l-erro as logical.
    def var v_cod_finalid as char no-undo.    
    
/*    run pi-desformata-campos.*/

    /* Busca dados da conta cont bil */
    assign c-conta-ctbl:format      in frame {&frame-name} = "x(20)":U.
    ASSIGN v_cod_cta_ctbl = c-conta-ctbl:screen-value in frame {&frame-name}.
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        today,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA€ÇO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */ 
 
    find first tt_log_erro no-lock no-error.
    if avail tt_log_erro then do:
       run utp/ut-msgs.p (input "show":U,
                          input 17006,
                          STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        
       assign l-erro = yes.                
       apply "entry" to c-conta-ctbl in frame {&frame-name}.
       return NO-APPLY.       
    end.
                                              
    /* 9 - Saldo por grupo de estoque */
    assign v_cod_finalid = {adinc/i05ad049.i 4 9}.
    if lookup(v_cod_finalid, v_ind_finalid_cta) = 0 then do:
        run utp/ut-msgs.p (input "show":U, input 5769, input "").
        assign l-erro = yes.
        apply "entry" to c-conta-ctbl in frame {&frame-name}.
        return no-apply.       
    end.   
    assign c-conta-ctbl:FORMAT in frame {&FRAME-NAME} = c-formato-conta.
             
    /* Verifica se a conta utiliza centro de custo */
    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  c-estabel:screen-value in frame {&FRAME-NAME},        /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  v_cod_cta_ctbl,     /* CONTA */
                                                       input  today,              /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */
    IF v_log_utz_ccusto THEN DO:
        /* Busca dados do centro de custo */
        assign c-sc-codigo:format       in frame {&frame-name} = "x(20)":U.
        ASSIGN v_cod_ccusto = c-sc-codigo:screen-value.
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
           assign l-erro = yes.                
           apply "entry" to c-sc-codigo in frame {&frame-name}.
           return NO-APPLY.       
        end.
        assign c-sc-codigo:FORMAT in frame {&FRAME-NAME} = c-formato-ccusto.
    END.

    assign c-conta-var-saldo:format in frame {&frame-name} = "x(20)":U.
    assign c-conta-movto:format     in frame {&frame-name} = "x(20)":U.
    FOR EACH  estab-mat
        WHERE estab-mat.cod-estabel = INPUT FRAME {&FRAME-NAME} c-estabel NO-LOCK:

        IF  estab-mat.usa-on-line                                AND
            (INPUT FRAME {&FRAME-NAME} c-conta-var-saldo = "":U  OR
             INPUT FRAME {&FRAME-NAME} c-conta-movto     = "":U) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-contas-de-variacao-devem-ser-i AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Contas_de_Varia‡Æo_devem_ser_informadas" *}
            ASSIGN c-lbl-liter-contas-de-variacao-devem-ser-i = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-contas-de-variacao-devem-ser-i-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Contas_de_Varia‡Æo_devem_ser_informadas_para_Estabelecimento_com_Custo_PadrÆo_implantado" *}
            ASSIGN c-lbl-liter-contas-de-variacao-devem-ser-i-2 = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 15825,
                               INPUT c-lbl-liter-contas-de-variacao-devem-ser-i + "." + "~~" + c-lbl-liter-contas-de-variacao-devem-ser-i-2 + "." ).
            ASSIGN l-erro = YES.
            APPLY "entry":U TO c-conta-var-saldo IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
    END.
    assign c-conta-var-saldo:FORMAT in frame {&FRAME-NAME} = c-formato-conta.
    assign c-conta-movto:FORMAT in frame {&FRAME-NAME} = c-formato-conta.

    FIND FIRST estab-mat
         WHERE estab-mat.cod-estabel = INPUT FRAME {&FRAME-NAME} c-estabel AND
               estab-mat.usa-on-line  = YES                                     NO-LOCK NO-ERROR.

    if  avail estab-mat then do:
        assign c-conta-var-saldo:format in frame {&frame-name} = "x(20)":U.
        if  input frame {&frame-name} c-conta-var-saldo <> '' then do:
            
            /* Busca dados da conta cont bil */
            ASSIGN v_cod_cta_ctbl = c-conta-var-saldo:screen-value.
            run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                           input        "",                 /* PLANO DE CONTAS */
                                                           input-output v_cod_cta_ctbl,     /* CONTA */
                                                           input        today,              /* DATA TRANSACAO */   
                                                           output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                           output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                           output       v_num_sit_cta_ctbl, /* SITUA€ÇO DA CONTA */
                                                           output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                           output table tt_log_erro).       /* ERROS */ 

            find first tt_log_erro no-lock no-error.
            if avail tt_log_erro then do:
               run utp/ut-msgs.p (input "show":U,
                                  input 17006,
                                  STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        
               assign l-erro = yes.                
               apply "entry" to c-conta-var-saldo in frame {&frame-name}.
               return NO-APPLY.       
            end.
            
            if  v_num_tip_cta_ctbl <> 1 and v_num_tip_cta_ctbl <> 5 then do:
                run utp/ut-msgs.p (input "show":U, input 4187 , input c-conta-var-saldo:label).
                assign l-erro = yes.
                apply "entry" to c-conta-var-saldo in frame {&frame-name}.
                return no-apply.
            end.

           /* if  conta -contab.estado <> 3 then do:*/
            if  v_num_sit_cta_ctbl <> 3 then do:
                run utp/ut-msgs.p (input "show":U, input 912, input c-conta-var-saldo:label).
                assign l-erro = yes.
                apply "entry" to c-conta-var-saldo in frame {&frame-name}.
                return no-apply.
            end.

           /* if  conta -contab.estoque <> 1 and
                conta -contab.estoque <> 2 then do: */
            if lookup({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) = 0 and 
               lookup({adinc/i05ad049.i 4 2}, v_ind_finalid_cta) = 0 then do: 
                run utp/ut-msgs.p (input "show":U, input 6559, input "").
                assign l-erro = yes.
                apply "entry" to c-conta-var-saldo in frame {&frame-name}.
                return no-apply.
            end. 
            assign c-conta-var-saldo:FORMAT in frame {&FRAME-NAME} = c-formato-conta.
            /* Verifica se a conta utiliza centro de custo */
            run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                               input  c-estabel:screen-value in frame {&FRAME-NAME},        /* ESTABELECIMENTO EMS2 */
                                                               input  "",                 /* PLANO CONTAS */
                                                               input  v_cod_cta_ctbl,     /* CONTA */
                                                               input  today,              /* DT TRANSACAO */
                                                               output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                               output table tt_log_erro). /* ERROS */
            IF v_log_utz_ccusto THEN DO:
                /* Busca dados do centro de custo */
                assign c-sc-saldo:format        in frame {&frame-name} = "x(20)":U.
                ASSIGN v_cod_ccusto = c-sc-saldo:screen-value.
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
                   assign l-erro = yes.                
                   apply "entry" to c-sc-saldo in frame {&frame-name}.
                   return NO-APPLY.       
                end.
                assign c-sc-saldo:FORMAT in frame {&FRAME-NAME} = c-formato-ccusto.
            END.
        end.

        assign c-conta-movto:format     in frame {&frame-name} = "x(20)":U.
        if  input frame {&frame-name} c-conta-movto <> '' then do:
            /* Busca dados da conta cont bil */
            ASSIGN v_cod_cta_ctbl = c-conta-movto:screen-value.
            run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                           input        "",                 /* PLANO DE CONTAS */
                                                           input-output v_cod_cta_ctbl,     /* CONTA */
                                                           input        today,              /* DATA TRANSACAO */   
                                                           output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                           output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                           output       v_num_sit_cta_ctbl, /* SITUA€ÇO DA CONTA */
                                                           output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                           output table tt_log_erro).       /* ERROS */ 
         
            find first tt_log_erro no-lock no-error.
            if avail tt_log_erro then do:
               run utp/ut-msgs.p (input "show":U,
                                  input 17006,
                                  STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        
               assign l-erro = yes.                
               apply "entry" to c-conta-movto in frame {&frame-name}.
               return NO-APPLY.       
            end.
            
            if  v_num_tip_cta_ctbl <> 1 and v_num_tip_cta_ctbl <> 5 then do:
                run utp/ut-msgs.p (input "show":U, input 4187 , input c-conta-movto:label).
                assign l-erro = yes.
                apply "entry" to c-conta-movto in frame {&frame-name}.
                return no-apply.
            end.

           /* if  conta -contab.estado <> 3 then do:*/
            if  v_num_sit_cta_ctbl <> 3 then do:
                run utp/ut-msgs.p (input "show":U, input 912, input c-conta-movto:label).
                assign l-erro = yes.
                apply "entry" to c-conta-movto in frame {&frame-name}.
                return no-apply.
            end.

           /* if  conta -contab.estoque <> 1 and
                conta -contab.estoque <> 2 then do: */
            if lookup({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) = 0 and 
               lookup({adinc/i05ad049.i 4 2}, v_ind_finalid_cta) = 0 then do:              
                run utp/ut-msgs.p (input "show":U, input 6559, input "").
                assign l-erro = yes.
                apply "entry" to c-conta-movto in frame {&frame-name}.
                return no-apply.
            end.
            assign c-conta-movto:FORMAT in frame {&FRAME-NAME} = c-formato-conta.
            /* Verifica se a conta utiliza centro de custo */
            run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                               input  c-estabel:screen-value in frame {&FRAME-NAME},        /* ESTABELECIMENTO EMS2 */
                                                               input  "",                 /* PLANO CONTAS */
                                                               input  v_cod_cta_ctbl,     /* CONTA */
                                                               input  today,              /* DT TRANSACAO */
                                                               output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                               output table tt_log_erro). /* ERROS */
            IF v_log_utz_ccusto THEN DO:
                /* Busca dados do centro de custo */
                assign c-sc-movto:format        in frame {&frame-name} = "x(20)":U.
                ASSIGN v_cod_ccusto = c-sc-movto:screen-value.
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
                   assign l-erro = yes.                
                   apply "entry" to c-sc-movto in frame {&frame-name}.
                   return NO-APPLY.       
                end.
                assign c-sc-movto:FORMAT in frame {&FRAME-NAME} = c-formato-ccusto.
            END.
        end.

    end.

    assign c-conta-ctbl:format      in frame {&frame-name} = "x(20)":U
           c-sc-codigo:format       in frame {&frame-name} = "x(20)":U
           c-conta-var-saldo:format in frame {&frame-name} = "x(20)":U
           c-sc-saldo:format        in frame {&frame-name} = "x(20)":U
           c-conta-movto:format     in frame {&frame-name} = "x(20)":U
           c-sc-movto:format        in frame {&frame-name} = "x(20)":U.
    for each  grup-estoque
        where grup-estoque.ge-codigo >= input frame {&frame-name} i-ge-ini and
              grup-estoque.ge-codigo <= input frame {&frame-name} i-ge-fim no-lock:

        for each  deposito
            where deposito.cod-depos >= input frame {&frame-name} c-depos-ini and
                  deposito.cod-depos <= input frame {&frame-name} c-depos-fim no-lock:

            for each  estab-mat
                where estab-mat.cod-estabel = input frame {&frame-name} c-estabel no-lock:

                find contabiliza 
                    where contabiliza.ge-codigo = grup-estoque.ge-codigo  and
                          contabiliza.cod-depos = deposito.cod-depos    and
                          contabiliza.cod-estabel = estab-mat.cod-estabel no-lock no-error.

                if  not available contabiliza then do:
                    create contabiliza.
                    assign contabiliza.ge-codigo       = grup-estoque.ge-codigo
                           contabiliza.cod-depos       = deposito.cod-depos
                           contabiliza.cod-estabel      = estab-mat.cod-estabel
                           contabiliza.ct-codigo       = c-conta-ctbl:screen-value
                           contabiliza.sc-codigo       = c-sc-codigo:screen-value.

                    if  estab-mat.usa-on-line then do:
                        assign contabiliza.ct-var-saldo    = c-conta-var-saldo:screen-value
                               contabiliza.sc-var-saldo    = c-sc-saldo:screen-value
                               contabiliza.ct-var-movto    = c-conta-movto:screen-value
                               contabiliza.sc-var-movto    = c-sc-movto:screen-value.
                    end.
                end.
            end.
        end.
    end.
    assign c-conta-ctbl:FORMAT in frame {&FRAME-NAME} = c-formato-conta
           c-sc-codigo:FORMAT in frame {&FRAME-NAME} = c-formato-ccusto
           c-conta-var-saldo:FORMAT in frame {&FRAME-NAME} = c-formato-conta
           c-sc-saldo:FORMAT in frame {&FRAME-NAME} = c-formato-ccusto
           c-conta-movto:FORMAT in frame {&FRAME-NAME} = c-formato-conta
           c-sc-movto:FORMAT in frame {&FRAME-NAME} = c-formato-ccusto.
    run pi-formata-campos.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-param V-table-Win 
PROCEDURE pi-passa-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input param p-ct-codigo          like contabiliza.ct-codigo no-undo.
  def input param p-conta-var-saldo    like contabiliza.ct-codigo no-undo.
  def input param p-conta-movto        like contabiliza.ct-codigo no-undo.
  def input param p-c-tit-cta-contab   as char  format "x(40)"    no-undo.
  def input param p-c-tit-cta-saldo    as char  format "x(40)"    no-undo.
  def input param p-c-tit-cta-movto    as char  format "x(40)"    no-undo.
  def input param p-c-sc-codigo        like contabiliza.sc-codigo no-undo.
  def input param p-c-sc-var-saldo     like contabiliza.sc-codigo no-undo.
  def input param p-c-sc-var-movto     like contabiliza.sc-codigo no-undo.
  def input param p-c-titulo-ccusto-1  as char  format "x(40)"    no-undo.
  def input param p-c-titulo-ccusto-2  as char  format "x(40)"    no-undo.
  def input param p-c-titulo-ccusto-3  as char  format "x(40)"    no-undo.
  def input param p-c-estabelec        as char                    no-undo.

  assign c-conta-ctbl:screen-value       in frame {&frame-name} = p-ct-codigo
         c-conta-var-saldo:screen-value  in frame {&frame-name} = p-conta-var-saldo
         c-conta-movto:screen-value      in frame {&frame-name} = p-conta-movto
         c-tit-cta-contab:screen-value   in frame {&frame-name} = p-c-tit-cta-contab
         c-tit-cta-saldo:screen-value    in frame {&frame-name} = p-c-tit-cta-saldo
         c-tit-cta-movto:screen-value    in frame {&frame-name} = p-c-tit-cta-movto
         c-sc-codigo:screen-value        in frame {&frame-name} = p-c-sc-codigo
         c-sc-saldo:screen-value         in frame {&frame-name} = p-c-sc-var-saldo
         c-sc-movto:screen-value         in frame {&frame-name} = p-c-sc-var-movto
         c-tit-sc-codigo:screen-value    in frame {&frame-name} = p-c-titulo-ccusto-1
         c-tit-sc-var-saldo:screen-value in frame {&frame-name} = p-c-titulo-ccusto-2
         c-tit-sc-var-movto:screen-value in frame {&frame-name} = p-c-titulo-ccusto-3
         c-estabel:screen-value          in frame {&FRAME-NAME} = p-c-estabelec.
         
  find estabelec where
       estabelec.cod-estabel = c-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec.
         
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

