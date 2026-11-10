&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
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
{include/i-prgvrs.i V09IN218 2.00.00.030 } /*** "010030" 02/05/2025 15:55:20 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v09in218 MUT}
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

{cdp/cdcfgman.i}    /* Defini‡Æo preprocessadores */

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.

/* Parameters Definitions ---                                           */
def buffer b-saldo for saldo-estoq.
def buffer b-movto for movto-estoq.
def buffer b-movto-mat for movto-mat.
/* Local Variable Definitions ---                                       */

def new shared var i-ct-inv         as char format "x(20)".
def new shared var i-sc-inv         as char format "x(20)".
def new shared var r-mov-inv        as rowid.
def new shared var i-emp-inv        like empresa.ep-codigo.
def new shared var i-ord-inv        as int format ">>>,>>9".
def new global shared var i-ordem LIKE ord-prod.nr-ord-produ no-undo.

/*def new global shared var c-it-cod like movto-estoq.it-codigo.*/

def var r-registro      as rowid.
def var r-saldo-estoq   as rowid.
def var i-nr-trans      as i.
def var de-aux-1        as decimal decimals 2 no-undo.
def var de-aux-2        as decimal decimals 2 no-undo.
def var l-entrada       as logical.
def var l-resposta      as l.
def var h_v07in218      as handle.
def var h_v10in218      as handle.
def var h_v14in218      as handle.
def var h_window        as handle.
def var i-saldo-neg     as i.
def var c-container     as c.
DEF VAR c-ordem-servic-ant AS CHAR NO-UNDO.
DEF VAR c-cod-unid-negoc   AS CHAR NO-UNDO.
DEF VAR c-it-codigo        AS CHAR NO-UNDO.
DEF VAR c-cod-estabel      AS CHAR NO-UNDO.
DEF VAR c-cod-depos        AS CHAR NO-UNDO.

def var c-data-valida as date format "99/99/9999".
def var c-lote        like saldo-estoq.lote.

{cep/ceapi001k.i}    /* Definicao de temp-table do movto-estoq */

def var i-empresa   like param-global.empresa-prin no-undo.
def var c-estabelec as char                        no-undo.

def var c-aux-it-codigo like item.it-codigo no-undo.

{cdp/cdcfgdis.i}
{cdp/cdcfgmnt.i} /* calibracao */

DEFINE VARIABLE hProgramZoom AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-cdapi024   AS HANDLE     NO-UNDO.

{cdp/cd9590.i}    /*Include verifica‡Æo Unidade Neg¢cio*/

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia".

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.
def var c-formato-conta      as char no-undo.
def var c-formato-ccusto     as char no-undo. 

/* Vari veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Vari veis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo.

{cep/ce0101.i3}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-inclui

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-estoq
&Scoped-define FIRST-EXTERNAL-TABLE movto-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-estoq.dt-trans movto-estoq.referencia ~
movto-estoq.ct-codigo movto-estoq.sc-codigo movto-estoq.cod-unid-negoc ~
movto-estoq.serie-docto movto-estoq.nro-docto movto-estoq.cod-emitente 
&Scoped-define ENABLED-TABLES movto-estoq
&Scoped-define FIRST-ENABLED-TABLE movto-estoq
&Scoped-Define ENABLED-OBJECTS rt-mold i-tp-comprov-doc i-tp-operacao
&Scoped-Define DISPLAYED-FIELDS movto-estoq.dt-trans movto-estoq.referencia ~
movto-estoq.ct-codigo movto-estoq.sc-codigo movto-estoq.cod-unid-negoc ~
movto-estoq.serie-docto movto-estoq.nro-docto movto-estoq.cod-emitente 
&Scoped-define DISPLAYED-TABLES movto-estoq
&Scoped-define FIRST-DISPLAYED-TABLE movto-estoq
&Scoped-Define DISPLAYED-OBJECTS i-ord-prod i-operacao c-desc-ct-codigo ~
c-desc-sc-codigo c-desc-un c-desc-fornec i-tp-comprov-doc i-tp-operacao

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
DEFINE VARIABLE c-desc-ct-codigo AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-sc-codigo AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-un AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE i-operacao AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-ord-prod AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.14 BY 7.25.

DEFINE VARIABLE i-tp-comprov-doc AS INTEGER FORMAT "999":U INITIAL 0
     LABEL "Tp Comprov Doc"
     VIEW-AS FILL-IN
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-tp-operacao AS INTEGER FORMAT "999":U INITIAL 0
     LABEL "Tipo Opera‡Æo"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-inclui
     movto-estoq.dt-trans AT ROW 1.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     i-ord-prod AT ROW 2.17 COL 18.43 COLON-ALIGNED
     i-operacao AT ROW 2.17 COL 41.43 COLON-ALIGNED
     movto-estoq.referencia AT ROW 2.17 COL 58.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     movto-estoq.ct-codigo AT ROW 3.17 COL 18.43 COLON-ALIGNED
          LABEL "Conta Cont bil"
          VIEW-AS FILL-IN 
          SIZE 18.43 BY .88
     c-desc-ct-codigo AT ROW 3.17 COL 37.29 COLON-ALIGNED NO-LABEL
     movto-estoq.sc-codigo AT ROW 4.17 COL 18.43 COLON-ALIGNED
          LABEL "Centro de Custo"
          VIEW-AS FILL-IN 
          SIZE 18.43 BY .88
     c-desc-sc-codigo AT ROW 4.17 COL 37.29 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     movto-estoq.cod-unid-negoc AT ROW 5.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-un AT ROW 5.17 COL 26.72 COLON-ALIGNED NO-LABEL
     movto-estoq.serie-docto AT ROW 6.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .92
     movto-estoq.nro-docto AT ROW 6.17 COL 51.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     movto-estoq.cod-emitente AT ROW 7.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     c-desc-fornec AT ROW 7.17 COL 30.43 COLON-ALIGNED NO-LABEL
     i-tp-comprov-doc AT ROW 1.17 COL 47.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     i-tp-operacao AT ROW 1.17 COL 65.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.movto-estoq
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
         HEIGHT             = 7.25
         WIDTH              = 85.14.
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
/* SETTINGS FOR FRAME f-inclui
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-inclui:SCROLLABLE       = FALSE
       FRAME f-inclui:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-ct-codigo IN FRAME f-inclui
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-fornec IN FRAME f-inclui
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-sc-codigo IN FRAME f-inclui
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-un IN FRAME f-inclui
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.ct-codigo IN FRAME f-inclui
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN i-operacao IN FRAME f-inclui
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-ord-prod IN FRAME f-inclui
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.sc-codigo IN FRAME f-inclui
   EXP-LABEL                                                            */
ASSIGN 
       i-tp-comprov-doc:HIDDEN IN FRAME f-inclui = TRUE.
ASSIGN 
       i-tp-operacao:HIDDEN IN FRAME f-inclui = TRUE.
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-inclui
/* Query rebuild information for FRAME f-inclui
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-inclui */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME movto-estoq.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-emitente V-table-Win
ON F5 OF movto-estoq.cod-emitente IN FRAME f-inclui /* Fornecedor */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                         &campo=movto-estoq.cod-emitente
                         &campozoom=cod-emitente}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-emitente V-table-Win
ON LEAVE OF movto-estoq.cod-emitente IN FRAME f-inclui /* Fornecedor */
DO:
  {include/leave.i &tabela=emitente
                   &atributo-ref=nome-emit
                   &variavel-ref=c-desc-fornec
                   &where="emitente.cod-emitente = input frame {&frame-name} movto-estoq.cod-emitente"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-emitente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-emitente IN FRAME f-inclui /* Fornecedor */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-unid-negoc V-table-Win
ON F5 OF movto-estoq.cod-unid-negoc IN FRAME f-inclui /* Unidade Neg¢cio */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                             &FieldZoom1="cod-unid-negoc"
                             &FieldScreen1="movto-estoq.cod-unid-negoc"
                             &Frame1="f-inclui"
                             &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-unid-negoc V-table-Win
ON LEAVE OF movto-estoq.cod-unid-negoc IN FRAME f-inclui /* Unidade Neg¢cio */
DO:
    {include/leave.i &tabela=unid-negoc
                   &atributo-ref=des-unid-negoc
                   &variavel-ref=c-desc-un
                   &where="unid-negoc.cod-unid-negoc = input frame {&frame-name} movto-estoq.cod-unid-negoc"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-unid-negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-unid-negoc IN FRAME f-inclui /* Unidade Neg¢cio */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON ENTRY OF movto-estoq.ct-codigo IN FRAME f-inclui /* Conta Cont bil */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
    ENABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON F5 OF movto-estoq.ct-codigo IN FRAME f-inclui /* Conta Cont bil */
DO:
   def var v_cod_finalid as char no-undo.                                               
  /* assign v_cod_finalid = {adinc/i05ad049.i 4 9}. */ /* 9 - Saldo por grupo de estoque */
   assign v_cod_finalid = "(nenhum)".


   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* MûDULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  v_cod_finalid,      /* FINALIDADES */
                                                  input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 

    if v_titulo_cta_ctbl <> "" then do:
        ASSIGN movto-estoq.ct-codigo:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN c-desc-ct-codigo:SCREEN-VALUE = v_titulo_cta_ctbl.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON LEAVE OF movto-estoq.ct-codigo IN FRAME f-inclui /* Conta Cont bil */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT movto-estoq.ct-codigo.
    
    /* Busca dados da conta cont˜bil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA TRANSACAO */   
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
                                                           input  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input input frame {&frame-name} movto-estoq.dt-trans,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            ENABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            ASSIGN movto-estoq.sc-codigo:SCREEN-VALUE = "".
            ASSIGN c-desc-sc-codigo:SCREEN-VALUE = "".
            DISABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
            RUN pi-atualiza-ccusto IN h_v07in218(INPUT "",
                                                 INPUT "").
        END.
        /************************************************/


        disable i-ord-prod WITH frame {&FRAME-NAME}.
        ASSIGN i-ord-prod:SCREEN-VALUE = "0".

        run pi-atualiza-conta in h_v07in218 (input v_cod_cta_ctbl,
                                             input v_titulo_cta_ctbl,
                                             input v_ind_finalid_cta). 
    END.
    else do:

        RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                                      INPUT "num-ord-inv").    
        if  return-value <> "0" and return-value <> "" then
            disable i-ord-prod WITH frame {&FRAME-NAME}.
        else
            ENABLE i-ord-prod i-operacao WITH frame {&FRAME-NAME}.                

    end.

    ASSIGN c-desc-ct-codigo:SCREEN-VALUE = v_titulo_cta_ctbl. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.ct-codigo IN FRAME f-inclui /* Conta Cont bil */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.dt-trans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.dt-trans V-table-Win
ON LEAVE OF movto-estoq.dt-trans IN FRAME f-inclui /* Data Transa‡Æo */
do:
   run pi-atualiza-formatos.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-operacao V-table-Win
ON F5 OF i-operacao IN FRAME f-inclui
DO:
  ASSIGN i-ordem = INPUT FRAME {&FRAME-NAME} i-ord-prod.
  {include/zoomvar.i &prog-zoom="inzoom/z02in260.w"
                     &campo=i-operacao
                     &campozoom=op-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-operacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-operacao IN FRAME f-inclui
DO:
  apply "f5" to self.
END.

&Scoped-define SELF-NAME movto-estoq.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.sc-codigo V-table-Win
ON F5 OF movto-estoq.sc-codigo IN FRAME f-inclui /* Centro de Custo */
DO:
   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input input frame {&frame-name} movto-estoq.dt-trans,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 

   if v_titulo_ccusto <> "" then do:

       ASSIGN movto-estoq.sc-codigo:SCREEN-VALUE = v_cod_ccusto.
       ASSIGN c-desc-sc-codigo:SCREEN-VALUE = v_titulo_ccusto.       
       
       run pi-atualiza-ccusto in h_v07in218 (input v_cod_ccusto,
                                             input v_titulo_ccusto).       
   end. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-ord-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-prod V-table-Win
ON ENTRY OF i-ord-prod IN FRAME f-inclui
DO:
    ASSIGN c-ordem-servic-ant = i-ord-prod:screen-value in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-prod V-table-Win
ON F5 OF i-ord-prod IN FRAME f-inclui
DO:
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin.

  {include/zoomvar.i &prog-zoom="inzoom/z01in271.w"
                     &campo=i-ord-prod
                     &campozoom=nr-ord-produ}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-prod V-table-Win
ON LEAVE OF i-ord-prod IN FRAME f-inclui
DO:
    if movto-estoq.ct-codigo:sensitive in frame {&frame-name} then do:
        do with frame {&FRAME-NAME}:
            if input i-ord-prod = 0 and
                (i-ct-inv = "" and i-sc-inv = "") then do with frame {&frame-name}:
                IF movto-estoq.ct-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" AND c-formato-conta <> "" THEN 
                    assign movto-estoq.ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.

                ASSIGN movto-estoq.ct-codigo:screen-value = ""
                       c-desc-ct-codigo:screen-value      = "".
                RUN pi-desformata-campos.

                enable movto-estoq.ct-codigo
                    with frame {&frame-name}.
            end.
            else do:
                IF movto-estoq.ct-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" AND c-formato-conta <> "" THEN
                    assign movto-estoq.ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.

                disable movto-estoq.ct-codigo.

                find ord-prod
                    where ord-prod.nr-ord-produ = input i-ord-prod
                    no-lock no-error.

                if avail ord-prod then do:
                    assign movto-estoq.ct-codigo:screen-value = ord-prod.ct-codigo.

                     
                     find estabelec where
                              estabelec.cod-estabel = c-estabelec no-lock no-error.
                     assign i-empresa = estabelec.ep-codigo when avail estabelec.                                    
                     
                    /* Busca dados da conta contÿbil */
                    ASSIGN v_cod_cta_ctbl = ord-prod.ct-codigo.
                    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                                   input        "",                 /* PLANO DE CONTAS */
                                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                                   input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA TRANSACAO */   
                                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                                   output       v_num_sit_cta_ctbl, /* SITUA°€O DA CONTA */
                                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                                   output table tt_log_erro).       /* ERROS */                        
                    display  v_titulo_cta_ctbl @ c-desc-ct-codigo.

                    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                                       input  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                                       input  "",                 /* PLANO CONTAS */
                                                                       input  v_cod_cta_ctbl,     /* CONTA */
                                                                       input input frame {&frame-name} movto-estoq.dt-trans,              /* DT TRANSACAO */
                                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                                       output table tt_log_erro). /* ERROS */
                    IF v_log_utz_ccusto THEN DO:
                         assign movto-estoq.sc-codigo:screen-value = ord-prod.sc-codigo.
                         DISABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
                    END.
                    ELSE DO:
                        ASSIGN movto-estoq.sc-codigo:SCREEN-VALUE = "".
                        ASSIGN c-desc-sc-codigo:SCREEN-VALUE = "".
                        DISABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
                        RUN pi-atualiza-ccusto IN h_v07in218(INPUT "",
                                                             INPUT "").
                    END.
                            


                end.
                else
                    display "" @ movto-estoq.ct-codigo
                            "" @ c-desc-ct-codigo.
            end.

            IF movto-estoq.ct-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" AND c-formato-conta <> "" THEN 
                assign movto-estoq.ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.

        end.
    end.
    else do with frame {&frame-name}:
        if input i-ord-prod =  0 and
            movto-estoq.ct-codigo:sensitive = no then do:
            assign movto-estoq.ct-codigo:screen-value = ""
                   movto-estoq.ct-codigo:sensitive = yes
                   c-desc-ct-codigo:screen-value = ""
                   movto-estoq.ct-codigo:FORMAT IN FRAME {&FRAME-NAME} = "X(20)".
        end.
        else if input i-ord-prod <> 0 then do:
            IF c-formato-conta <> "" THEN
                assign movto-estoq.ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.
            disable movto-estoq.ct-codigo. 
            find ord-prod
                where ord-prod.nr-ord-produ = input i-ord-prod
                no-lock no-error.

            if avail ord-prod then do:
                assign movto-estoq.ct-codigo:screen-value = ord-prod.ct-codigo.

                find estabelec where estabelec.cod-estabel = c-estabelec no-lock no-error.
                assign i-empresa = estabelec.ep-codigo when avail estabelec. 

                ASSIGN v_cod_cta_ctbl = ord-prod.ct-codigo.
                run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                               input        "",                 /* PLANO DE CONTAS */
                                                               input-output v_cod_cta_ctbl,     /* CONTA */
                                                               input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA TRANSACAO */   
                                                               output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                               output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                               output       v_num_sit_cta_ctbl, /* SITUA°€O DA CONTA */
                                                               output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                               output table tt_log_erro).       /* ERROS */                        

                display  v_titulo_cta_ctbl @ c-desc-ct-codigo.
                    
                IF v_log_utz_ccusto THEN DO:
                    assign movto-estoq.sc-codigo:screen-value = ord-prod.sc-codigo.
                    DISABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
                     
                END.
                ELSE DO:
                    ASSIGN movto-estoq.sc-codigo:SCREEN-VALUE = "".
                    ASSIGN c-desc-sc-codigo:SCREEN-VALUE = "".
                    DISABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
                    RUN pi-atualiza-ccusto IN h_v07in218(INPUT "",
                                                         INPUT "").
                END.

            end.
            else
                display "" @ movto-estoq.ct-codigo
                        "" @ c-desc-ct-codigo.
        end.
        IF movto-estoq.ct-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" AND c-formato-conta <> "" THEN 
            assign movto-estoq.ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.
    end.

    DEFINE var p-cod-un-db AS char format "x(3)"  NO-UNDO.
    DEFINE var p-ct-db     AS char format "x(20)" NO-UNDO. 
    DEFINE var p-sc-db     AS char format "x(20)" NO-UNDO.
    
    run getDadosAplicacao in h_v10in218 (output p-cod-un-db,
                                         output p-ct-db,
                                         output p-sc-db).

    /*Unidade de Neg¢cio*/
    if avail ord-prod 
        and i-ord-prod:screen-value in frame {&frame-name} <> "" 
        and i-ord-prod:screen-value in frame {&frame-name} <> "0" then do:

        /*Unid Neg¢cio DB
        A unidade de neg¢cio de aplica‡Æo poder  ser alterada pelo usu rio mesmo com ordem de produ‡Æo informada,
        para tanto, ser  sugerida a unidade de neg¢cio da ordem de produ‡Æo somente quando a unidade de neg¢cio de aplica‡Æo 
        estiver em branco ou quando estiver igual … unidade de neg¢cio. Ser  feito o tratamento pelo campo "Unidade de Neg¢cio"
        pois este SEMPRE assume a unidade de neg¢cio da ordem de produ‡Æo e fica desabilitado nesta situa‡Æo, entÆo, 
        quando for alterada a unidade de neg¢cio de aplica‡Æo, esta nÆo mais receber  a unidade de neg¢cio da ordem de produ‡Æo.
        Isto garante que possa ser informada uma unidade de neg¢cio diferente no campo Unidade de neg¢cio de aplica‡Æo. */
        if p-cod-un-db = "" or
           p-cod-un-db = movto-estoq.cod-unid-negoc:screen-value in frame {&frame-name}
            then do:
            
            run set-unid-negoc-db in h_v10in218 (input ord-prod.cod-unid-negoc).
        end.

        /*Unidade de Neg¢cio*/
        IF l-unidade-negocio THEN
            assign movto-estoq.cod-unid-negoc:screen-value in frame {&frame-name} = ord-prod.cod-unid-negoc
                   movto-estoq.cod-unid-negoc:sensitive    in frame {&frame-name} = no.

        apply 'leave' to movto-estoq.cod-unid-negoc in frame {&frame-name}.
    END.
    ELSE DO:
        /*Unidade de Neg¢cio*/
        IF l-unidade-negocio THEN
            assign movto-estoq.cod-unid-negoc:sensitive in frame {&frame-name} = YES.

        /* Se existia a Ordem de SErvi‡o e o usu rio limpou o campo deve buscar novamente */
        /* a UN atrav‚s do relacionamento Item x Estabelecimento x Dep¢sito               */

        IF (c-ordem-servic-ant <> "" AND c-ordem-servic-ant <> "0") AND
           (i-ord-prod:screen-value in frame {&frame-name} = "" OR i-ord-prod:screen-value in frame {&frame-name} = "0") THEN DO:
            
            /*Unidade de Neg¢cio*/
            if l-unidade-negocio then do:
    
                assign c-cod-unid-negoc = "".
    
                if valid-handle(h-cdapi024) THEN DO:
                   RUN Get-Field-Screen-Value IN adm-broker-hdl
                     (INPUT THIS-PROCEDURE,
                      INPUT "it-codigo").
                   ASSIGN c-it-codigo = RETURN-VALUE.
                   
                   RUN Get-Field-Screen-Value IN adm-broker-hdl
                     (INPUT THIS-PROCEDURE,
                      INPUT "cod-estabel").
                   ASSIGN c-cod-estabel = RETURN-VALUE.
                   
                   RUN Get-Field-Screen-Value IN adm-broker-hdl
                     (INPUT THIS-PROCEDURE,
                      INPUT "cod-depos").
                   ASSIGN c-cod-depos = RETURN-VALUE.

                   run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input c-cod-estabel,
                                                                      input c-it-codigo,
                                                                      input c-cod-depos,
                                                                      output c-cod-unid-negoc).
                   run pi-mostra-unid-negoc (input c-cod-unid-negoc).
                end.
            end.

        END.

        apply 'leave' to movto-estoq.cod-unid-negoc in frame {&frame-name}.

    end.

    find ord-prod
        where ord-prod.nr-ord-produ = int(i-ord-prod:SCREEN-VALUE IN FRAME {&FRAME-NAME})
        no-lock no-error.
                
    if movto-estoq.cod-unid-negoc:sensitive in frame {&frame-name} = no
        and not avail ord-prod 
        and l-unidade-negocio then
        assign movto-estoq.cod-unid-negoc:sensitive in frame {&frame-name} = yes.               
                
    IF AVAIL ord-prod THEN
        IF ord-prod.rep-prod = 2 OR ord-prod.rep-prod = 3 THEN DO:
            enable i-operacao with frame {&frame-name}.
            ASSIGN i-operacao:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        
            apply 'entry' to i-operacao in frame {&frame-name}.

            return no-apply.

        END.
        ELSE DO:
            DISABLE i-operacao with frame {&frame-name}.

            ASSIGN i-operacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".
                        
        END.


end.

apply 'entry' to i-operacao in frame {&frame-name}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ord-prod V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-ord-prod IN FRAME f-inclui
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME i-tp-comprov-doc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-comprov-doc V-table-Win
ON ENTRY OF i-tp-comprov-doc IN FRAME f-inclui
DO:
    ASSIGN i-tp-comprov-doc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(input frame {&frame-name} i-tp-comprov-doc).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-comprov-doc V-table-Win
ON F5 OF i-tp-comprov-doc IN FRAME f-inclui
DO:
    {method/zoomfields.i &ProgramZoom=inzoom/z01in01158.w
                         &FieldZoom1=cdn-tip-comprov
                         &FieldScreen1=i-tp-comprov-doc
                         &Frame1=f-inclui
                         &EnableImplant="no"} 
     wait-for "CLOSE":U of hProgramZoom.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-comprov-doc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-tp-comprov-doc IN FRAME f-inclui
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME i-tp-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-operacao V-table-Win
ON ENTRY OF i-tp-operacao IN FRAME f-inclui
DO:
    ASSIGN i-tp-operacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(input frame {&frame-name} i-tp-operacao).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-operacao V-table-Win
ON F5 OF i-tp-operacao IN FRAME f-inclui
DO:
    {method/zoomfields.i &ProgramZoom=inzoom/z01in01159.w
                         &FieldZoom1=cdn-tip-operacao
                         &FieldScreen1=i-tp-operacao
                         &Frame1=f-inclui
                         &EnableImplant="no"} 
     wait-for "CLOSE":U of hProgramZoom.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-operacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-tp-operacao IN FRAME f-inclui
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME movto-estoq.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.sc-codigo V-table-Win
ON ENTRY OF movto-estoq.sc-codigo IN FRAME f-inclui /* Centro de Custo */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.sc-codigo V-table-Win
ON LEAVE OF movto-estoq.sc-codigo IN FRAME f-inclui /* Centro de Custo */
DO:
    ASSIGN v_cod_ccusto = INPUT movto-estoq.sc-codigo.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */
    
    IF RETURN-VALUE = "OK" THEN DO:
        run pi-atualiza-ccusto in h_v07in218 (input v_cod_ccusto,
                                              input v_titulo_ccusto).
        assign self:format = c-formato-ccusto.
    END.
    ASSIGN c-desc-sc-codigo:SCREEN-VALUE = v_titulo_ccusto.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.sc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.sc-codigo IN FRAME f-inclui /* Centro de Custo */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/****************************  Main Block  ****************************/

    do with frame {&FRAME-NAME}:
        {utp/ut-liter.i Descri‡Æo * L}
        assign movto-estoq.referencia:label = return-value.

        {utp/ut-liter.i Ordem * L}
        assign i-ord-prod:label = return-value.

        {utp/ut-liter.i Opera‡Æo * L}
        assign i-operacao:label = return-value.

        if movto-estoq.ct-codigo:load-mouse-pointer ("image/lupa.cur") then.
        if i-ord-prod:load-mouse-pointer ("image/lupa.cur")                    then.
        if i-operacao:load-mouse-pointer ("image/lupa.cur")                    then.
        if movto-estoq.cod-emitente:load-mouse-pointer ("image/lupa.cur")   then.
        if movto-estoq.sc-codigo:load-mouse-pointer("image/lupa.cur")                  then.
        if movto-estoq.cod-unid-negoc:load-mouse-pointer ("image/lupa.cur") then.
        
        IF i-pais-impto-usuario = 33 THEN DO: /* Peru */
            IF i-tp-comprov-doc:LOAD-MOUSE-POINTER("image/lupa.cur") THEN.
            IF i-tp-operacao:LOAD-MOUSE-POINTER("image/lupa.cur") THEN.
        END.
        
        &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
          RUN dispatch IN THIS-PROCEDURE ('initialize':U).
        &ENDIF
        
        
    end.
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
  {src/adm/template/row-list.i "movto-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-estoq"}

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
  HIDE FRAME f-inclui.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilita-ordem V-table-Win 
PROCEDURE habilita-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT "num-ord-inv").

  if (param-global.modulo-cp = yes or param-global.modulo-mi = yes) 
      and return-value = "0" then do:
      enable i-ord-prod i-operacao with frame {&frame-name}.
  end. else do:    
      disable i-ord-prod with frame {&frame-name}.
      assign i-ord-prod:screen-value in frame {&frame-name} = "0".
      disable i-operacao with frame {&frame-name}.
      assign i-operacao:screen-value in frame {&frame-name} = "0".

  end.    



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
  

  /* Handle da API Conta Contÿbil */
  if NOT valid-handle(h_api_cta_ctbl) then
      run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
  /* Handle da API Centro Custo */
  if NOT valid-handle(h_api_ccusto) then
      run prgint\utb\utb742za.py persistent set h_api_ccusto.

  /*
  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "it-codigo").
  find first item where item.it-codigo = return-value no-lock no-error.
  if avail item then do:
      if item.tipo-contr = 4 or
         item.tipo-contr = 1 or
         item.it-codigo = "" then do with frame {&frame-name}:
             
         run setDadosAplicacao in h_v10in218 (input item.ct-codigo,
                                              input item.sc-codigo,
                                              input true).                                
      end.
      else do:
         run setDadosAplicacao in h_v10in218 (input ?,
                                              input ?,
                                              input false).                                                
      end.
   end. */
   
  assign movto-estoq.dt-trans:screen-value in frame {&frame-name} = string(today).
  find first param-global no-lock no-error.
  if param-global.modulo-cp = yes then do:
     enable i-ord-prod i-operacao with frame {&frame-name}.
  end.
  else do:
     assign i-ord-prod = 0.
     disable i-ord-prod with frame {&frame-name}.
     assign i-operacao = 0.
     disable i-operacao with frame {&frame-name}.
  end.

  assign movto-estoq.ct-codigo:screen-value in frame {&frame-name} = " ".

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
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e
  nem na PI-validate. */


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

  if valid-handle(h-cdapi024) then
      RUN pi-finalizar IN h-cdapi024.

  if valid-handle(h_api_cta_ctbl) then
    delete object h_api_cta_ctbl.
  if valid-handle(h_api_ccusto) then
    delete object h_api_ccusto.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
  
  IF i-pais-impto-usuario = 33 THEN /* Peru */
      ASSIGN i-tp-comprov-doc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             i-tp-operacao:SENSITIVE IN FRAME {&FRAME-NAME}    = NO.
  
  /* Incluido para limpar os campos quando clicar no X, de cancelado */
  RUN local-display-fields.

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

  find emitente where emitente.cod-emitente = input frame {&frame-name} movto-estoq.cod-emitente no-lock no-error.
  if avail emitente then do:
     assign c-desc-fornec = emitente.nome-emit.
     display c-desc-fornec with frame {&frame-name}.
  end.
  else do:
     assign c-desc-fornec = " ".
     display c-desc-fornec with frame {&frame-name}.
  end.

  find first param-global no-lock no-error.
  
  assign i-empresa = "".
  find estabelec where
       estabelec.cod-estabel = c-estabelec no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec. 


/*  run pi-atualiza-formatos.*/

  IF AVAIL movto-estoq THEN DO:
    /* Busca dados da conta contÙbil */
    ASSIGN v_cod_cta_ctbl = movto-estoq.ct-codigo.
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA›øO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */

    assign c-desc-ct-codigo = v_titulo_cta_ctbl.
    display c-desc-ct-codigo with frame {&frame-name}.

    ASSIGN v_cod_ccusto = movto-estoq.sc-codigo.
    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

    assign c-desc-sc-codigo = v_titulo_ccusto.
    display c-desc-sc-codigo with frame {&frame-name}.

  END.

  /* Code placed here will execute AFTER standard behavior.    */

  disable i-ord-prod i-operacao with frame {&frame-name}.

    if available movto-estoq THEN do:
        display movto-estoq.nr-ord-produ @ i-ord-prod with frame {&frame-name}.

        FIND FIRST oper-ord WHERE oper-ord.nr-ord-produ = movto-estoq.nr-ord-produ
                            AND oper-ord.sequencia = movto-estoq.op-seq NO-LOCK NO-ERROR.
        IF AVAIL oper-ord THEN 
            display oper-ord.op-codigo @ i-operacao with frame {&frame-name}.

    END.

  clear frame {&frame-name}.

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

  disable i-ord-prod with frame {&frame-name}.
  disable i-operacao with frame {&frame-name}.


  if l-unidade-negocio then
      assign movto-estoq.cod-unid-negoc:sensitive in frame f-inclui = yes
/*             c-cod-un-db:sensitive                in frame f-inclui = yes*/ .
  else
      assign movto-estoq.cod-unid-negoc:sensitive in frame f-inclui = no
/*             c-cod-un-db:sensitive                in frame f-inclui = no*/ .
  
  IF i-pais-impto-usuario = 33 THEN /* Peru */
      ASSIGN i-tp-comprov-doc:SENSITIVE IN FRAME {&FRAME-NAME} = YES
             i-tp-operacao:SENSITIVE IN FRAME {&FRAME-NAME}    = YES.
  ELSE
      ASSIGN i-tp-comprov-doc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             i-tp-operacao:SENSITIVE IN FRAME {&FRAME-NAME}    = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  find first param-global no-lock no-error.
  find first param-estoq no-lock no-error.
  find first empresa where 
             empresa.ep-codigo = param-global.empresa-prin no-lock no-error.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  disable i-ord-prod with frame {&frame-name}.
  disable i-operacao with frame {&frame-name}.

  run cdp/cdapi024.p persistent set h-cdapi024.

  
  find estabelec where
       estabelec.cod-estabel = c-estabelec no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec. 
  
  IF i-pais-impto-usuario = 33 THEN /* Peru */
      ASSIGN i-tp-comprov-doc:HIDDEN IN FRAME {&FRAME-NAME} = NO
             i-tp-operacao:HIDDEN IN FRAME {&FRAME-NAME}    = NO.
  ELSE
      ASSIGN i-tp-comprov-doc:HIDDEN IN FRAME {&FRAME-NAME} = YES
             i-tp-operacao:HIDDEN IN FRAME {&FRAME-NAME}    = YES.

  /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-formatos V-table-Win 
PROCEDURE pi-atualiza-formatos :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

  /* Retorna formato da conta contabil */
  run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                     input  "",                 /* PLANO CONTAS */
                                                     input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA DE TRANSACAO */
                                                     output c-formato-conta,    /* FORMATO CONTA */
                                                     output table tt_log_erro). /* ERROS */
  /* Retorna formato do centro de custo */
  run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* PLANO CCUSTO */
                                                 input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA DE TRANSACAO */
                                                 output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */ 

  IF movto-estoq.ct-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" AND c-formato-conta <> "" THEN
        ASSIGN movto-estoq.ct-codigo:FORMAT IN FRAME {&FRAME-NAME} = c-formato-conta.   
  
  IF movto-estoq.sc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" AND  c-formato-ccusto <> "" THEN 
        ASSIGN movto-estoq.sc-codigo:FORMAT IN FRAME {&FRAME-NAME} = c-formato-ccusto.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desformata-campos V-table-Win 
PROCEDURE pi-desformata-campos :
assign movto-estoq.ct-codigo:format    in frame {&frame-name} = "x(20)":U
           movto-estoq.sc-codigo:format    in frame {&frame-name} = "x(20)":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dt-validade V-table-Win 
PROCEDURE pi-dt-validade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var tipo-trans like movto-estoq.tipo-trans no-undo.

run pi-getTipo-trans in h_v14in218 (output tipo-trans).
if tipo-trans = 2 then do:   
    if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
        find first b-saldo use-index lote where b-saldo.lote      = c-lote and
                                                b-saldo.it-codigo = c-it-codigo no-lock no-error.
        if avail b-saldo then do:
            if b-saldo.dt-vali-lote < input frame {&frame-name} movto-estoq.dt-trans then do:
                run utp/ut-msgs.p (input "show",
                                   input 1890,
                                   input return-value).
                    if return-value = "no":U then 
                        RETURN 'NOK':U.
                    else
                        RETURN "OK":U.
            end.
        end.

        else do:
            if c-data-valida < input frame {&frame-name} movto-estoq.dt-trans then do:
                run utp/ut-msgs.p (input "show",  /* Data de Validade e menor que data da transacao.Deseja proseguir? */
                                   input 1890,
                                   input return-value).       
                if return-value = "no" then do:
                    apply 'entry' to movto-estoq.dt-trans in frame {&frame-name}.  
                    return 'adm-error'. 
                end.
            end.
        end.
        
    end.
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-epc V-table-Win 
PROCEDURE pi-epc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Chamada EPC para a assign record */
  {include/i-epc003.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-focus V-table-Win 
PROCEDURE pi-focus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

APPLY 'entry' TO i-operacao IN FRAME f-inclui.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campos V-table-Win 
PROCEDURE pi-formata-campos :
/* Formatando conta e centro de custo */
  if c-formato-conta <> "" then 
      assign movto-estoq.ct-codigo:format    in frame {&FRAME-NAME} = c-formato-conta.
  
  if c-formato-ccusto <> "" then 
      assign movto-estoq.sc-codigo:format    in frame {&FRAME-NAME} = c-formato-ccusto.
            
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-getDt-trans V-table-Win 
PROCEDURE pi-getDt-trans :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def output parameter p-dt-trans like movto-estoq.dt-trans no-undo.
  
  assign p-dt-trans = input frame {&frame-name} movto-estoq.dt-trans.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-getFinalidadeConta V-table-Win 
PROCEDURE pi-getFinalidadeConta :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

    def output parameter p-finalidade as char format "x(256)" no-undo.
    
    def var c-conta-aux like movto-estoq.ct-codigo no-undo.  
    assign c-conta-aux = input frame {&frame-name} movto-estoq.ct-codigo.
 
    /* Busca finalidade da conta na api de financas */
    run pi_busca_dados_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                          input  "CEP",              /* MODULO */
                                                          input  "",                 /* PLANO DE CONTAS */
                                                          input  c-conta-aux,        /* CONTA */
                                                          input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA TRANSACAO */   
                                                          output p-finalidade,       /* FINALIDADES DA CONTA */
                                                          output table tt_log_erro). /* ERROS */                                                            
    if return-value = "OK" then
        return "OK".
    
    return "NOK".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-unid-negoc V-table-Win 
PROCEDURE pi-mostra-unid-negoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-cod-un AS CHARACTER  NO-UNDO.

assign movto-estoq.cod-unid-negoc:screen-value in frame {&frame-name} = p-cod-un.

apply 'leave' to movto-estoq.cod-unid-negoc in frame {&frame-name}.

/*Unid Neg¢cio DB*/
run set-unid-negoc-db in h_v10in218 (input p-cod-un).

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
def input param p-handle1 as handle.
def input param p-handle2 as handle.
def input param p-handle3 as handle.
def input param p-handle4 as handle.

assign h_v07in218 = p-handle1
       h_v10in218 = p-handle2
       h_v14in218 = p-handle3
       h_window   = p-handle4.

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
def input parameter rw-it-codigo as rowid no-undo.

find item where
     rowid(item) = rw-it-codigo no-lock no-error.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posiciona V-table-Win 
PROCEDURE pi-posiciona :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

apply "entry" to movto-estoq.dt-trans in frame {&frame-name}.
return no-apply.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-est V-table-Win 
PROCEDURE pi-recebe-est :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input parameter p-estabelec as char no-undo.

  assign c-estabelec = p-estabelec.
  find first estabelec where
       estabelec.cod-estabel = c-estabelec no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec. 
  
  run pi-atualiza-formatos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-sugere-contas V-table-Win 
PROCEDURE pi-sugere-contas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter c-ct-codigo as char format "x(20)" no-undo.
def input parameter c-sc-codigo as char format "x(20)" no-undo.
def input parameter l-hab       as logical no-undo.

IF c-sc-codigo = "" OR c-ct-codigo = "" THEN
    RUN pi-desformata-campos.
find first param-global no-lock no-error.

find estabelec where
         estabelec.cod-estabel = c-estabelec no-lock no-error.
assign i-empresa = estabelec.ep-codigo when avail estabelec. 

/* Busca dados da conta cont˜bil */
assign v_cod_cta_ctbl = c-ct-codigo.
run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                               input        "",                 /* PLANO DE CONTAS */
                                               input-output v_cod_cta_ctbl,     /* CONTA */
                                               input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA TRANSACAO */   
                                               output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                               output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                               output       v_num_sit_cta_ctbl, /* SITUAø°O DA CONTA */
                                               output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                               output table tt_log_erro).       /* ERROS */

if v_titulo_cta_ctbl = "" then do:     
   if movto-estoq.ct-codigo:sensitive in frame {&frame-name} = no then
      assign movto-estoq.ct-codigo:screen-value in frame {&frame-name} = "".              
   assign movto-estoq.ct-codigo:sensitive in frame {&frame-name} = yes.

   apply 'leave' to movto-estoq.ct-codigo in frame {&frame-name}.
end.

/* Busca dados do centro de custo */
assign v_cod_ccusto = c-sc-codigo.
run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                           input  "",                 /* CODIGO DO PLANO CCUSTO */
                                           input  v_cod_ccusto,       /* CCUSTO */
                                           input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA DE TRANSACAO */
                                           output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                           output table tt_log_erro). /* ERROS */

assign movto-estoq.ct-codigo:screen-value in frame {&frame-name} = c-ct-codigo
       movto-estoq.sc-codigo:screen-value in frame {&frame-name} = c-sc-codigo
       movto-estoq.ct-codigo:sensitive    in frame {&frame-name} = l-hab
       movto-estoq.sc-codigo:sensitive    in frame {&frame-name} = l-hab.


if movto-estoq.ct-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" AND c-formato-conta <> "" THEN
    assign movto-estoq.ct-codigo:format in frame {&frame-name} = c-formato-conta.
    
if movto-estoq.sc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" AND c-formato-ccusto <> "" THEN 
    assign movto-estoq.sc-codigo:format in frame {&frame-name} = c-formato-ccusto.

apply 'leave' to movto-estoq.ct-codigo in frame {&frame-name}.
apply 'leave' to movto-estoq.sc-codigo in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro
  ainda nÆo foi criado.
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
  
  /* Chamada EPC para a pi-validate */
  {include/i-epc002.i}

   /*Segue um exemplo de valida‡Æo de programa
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
  DEFINE var p-cod-un-db AS char format "x(3)"  NO-UNDO.
  DEFINE var p-ct-db AS char format "x(20)"  NO-UNDO.
  DEFINE var p-sc-db AS char format "x(20)"  NO-UNDO.
    
  DEFINE VARIABLE i-cenario AS INTEGER     NO-UNDO.
  run getDadosAplicacao in h_v10in218 (output p-cod-un-db,
                                       output p-ct-db,
                                       output p-sc-db). 

  find first param-estoq no-lock no-error.
  
  if c-formato-conta = "" then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show", input 2744, input "").
      apply 'entry' to movto-estoq.ct-codigo in frame {&frame-name}.
      return "adm-error":U.
  end.

  if input frame {&frame-name} movto-estoq.dt-trans > today then do:
     {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show":U, 
                        input 1788, 
                        input return-value).
     apply "entry" to movto-estoq.dt-trans in frame {&frame-name}.                       
     return 'ADM-ERROR':U.  
  end.  

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "lote").
  assign c-lote   = return-value.

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "it-codigo").
  assign c-it-codigo   = return-value.

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "da-data-valid").
  assign c-data-valida = date(return-value).  

    RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "rs-cenario").
  assign i-cenario = INT(return-value) NO-ERROR.  


  run pi-dt-validade.

  IF RETURN-VALUE = "NOK":U THEN DO:
      {include/i-vldprg.i}
      apply "entry" to movto-estoq.dt-trans in frame {&frame-name}.                       
      return 'ADM-ERROR':U.  
  END.
  
  find estabelec where
       estabelec.cod-estabel = c-estabelec no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec. 

  create tt-movto.
  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "it-codigo").
  assign tt-movto.it-codigo      = return-value.

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "cod-refer").
  assign tt-movto.cod-refer      = return-value.

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "cod-estabel").
  assign tt-movto.cod-estabel    = return-value.

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "cod-depos").
  assign tt-movto.cod-depos = return-value.

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "lote").
  assign tt-movto.lote = return-value.

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "cod-localiz").
  assign tt-movto.cod-localiz = return-value.

  assign tt-movto.usuario     = c-seg-usuario.
  find first saldo-estoq where
       saldo-estoq.it-codigo = tt-movto.it-codigo and
       saldo-estoq.cod-refer = tt-movto.cod-refer and
       saldo-estoq.cod-estabel = tt-movto.cod-estabel and
       saldo-estoq.cod-depos   = tt-movto.cod-depos and
       saldo-estoq.lote        = tt-movto.lote and
       saldo-estoq.cod-localiz = tt-movto.cod-localiz 
       no-lock no-error.

/*UNIDADE DE NEGàCIO (l-unidade-negocio - Fun‡Æo EMS2-UNIDADE-NEGOCIO cadastrada)*/
 if l-unidade-negocio then do:
     /*UN informada*/
     if input frame {&frame-name} movto-estoq.cod-unid-negoc <> "" then do: 

         if not can-find (first unid-negoc
                          where unid-negoc.cod-unid-negoc = input frame {&frame-name} movto-estoq.cod-unid-negoc) then do:
             {utp/ut-table.i mgind unid-negoc 1}
             run utp/ut-msgs.p (input "show", 
                                input 2, 
                                input return-value + "~~" + input frame {&frame-name} movto-estoq.cod-unid-negoc).
             apply 'entry' to movto-estoq.cod-unid-negoc in frame {&frame-name}.
             return 'adm-error'.
         end.
     end.
 end.
 /* if  input frame {&frame-name} movto-estoq.quantidade > 0 and
     input frame {&frame-name} de-val-mat2 = 0 and
     input frame {&frame-name} de-val-mat1 > 0 then do:
    {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show":U,
                        input 1802,
                        input "2").
     return 'ADM-ERROR':U.
 end.
 if input frame {&frame-name} movto-estoq.quantidade > 0 and
     input frame {&frame-name} de-val-mat3 = 0 and
     input frame {&frame-name} de-val-mat1 > 0 then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U,
                       input 1802,
                       input "3").
    return 'ADM-ERROR':U.
 end.
 if input frame {&frame-name} de-val-mat1 <= 0 and
    input frame {&frame-name} de-val-mob1 <= 0 and
    input frame {&frame-name} movto-estoq.quantidade   <= 0  then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U,
                       input 1811,
                       input "3").
    return 'ADM-ERROR':U.
 end.
 if input frame {&frame-name} movto-estoq.quantidade > 0 and
    input frame {&frame-name} de-val-mob2 = 0 and
    input frame {&frame-name} de-val-mob1 > 0 then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U,
                       input 1803,
                       input "2").
    return 'ADM-ERROR':U.
 end.
 if input frame {&frame-name} movto-estoq.quantidade > 0 and
    input frame {&frame-name} de-val-mob3 = 0 and
    input frame {&frame-name} de-val-mob1 > 0 then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U,
                       input 1803,
                       input "3").
    return 'ADM-ERROR':U.
 end.  */

 
 find first ord-prod where ord-prod.nr-ord-produ = input frame {&frame-name} i-ord-prod no-lock no-error.
 if not avail ord-prod and
    input frame {&frame-name} i-ord-prod <> 0 then do:
    {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show":U,
                        input 124,
                        input input frame {&frame-name} i-ord-prod).
     apply "entry" to i-ord-prod in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.

 /**** Verifica se produ‡Æo trabalha com ordens liberadas e se a OP est  liberada - 2.04 ****/ 

 &if defined (bf_man_204) &then 
    if avail ord-prod then DO:
     find first param-cp no-lock no-error.

     if avail param-cp and
        substring(param-cp.char-1,8,1) = "1" and
       (ord-prod.estado = 1 or
       (ord-prod.estado = 3 and ord-prod.log-1 = no)) then do:
        run utp/ut-msgs.p (input "show":U, 
                           input 27723, 
                           input "" ).
        apply "entry" to i-ord-prod in frame {&frame-name}.
        return "ADM-ERROR":U.
     end. 
    END.
 &endif 
 
 IF AVAIL ord-prod THEN DO:
     IF ord-prod.rep-prod = 2 OR ord-prod.rep-prod = 3 THEN DO:
        FIND FIRST oper-ord WHERE oper-ord.nr-ord-produ = input frame {&frame-name} i-ord-prod
                            AND oper-ord.op-codigo = int(input frame {&frame-name} i-operacao) NO-LOCK NO-ERROR.
        IF AVAIL oper-ord THEN DO:
            ASSIGN tt-movto.op-seq = oper-ord.sequencia
                   tt-movto.op-codigo = oper-ord.op-codigo
                   .
        END. ELSE DO:
            IF input frame {&frame-name} i-operacao = 0 THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-operacao-zero AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Opera‡Æo_Zero" *}
                ASSIGN c-lbl-liter-operacao-zero = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-a-operacao-informada-igual-a-z AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "A_Opera‡Æo_informada_igual_a_zero._Confirma?" *}
                ASSIGN c-lbl-liter-a-operacao-informada-igual-a-z = TRIM(RETURN-VALUE).
                run utp/ut-msgs.p (input "show",
                   input 27702,
                   input c-lbl-liter-operacao-zero + "~~" + c-lbl-liter-a-operacao-informada-igual-a-z).
                if return-value = "no" then return "adm-error".

                ASSIGN tt-movto.op-seq = 0.
            END. ELSE DO:
                {utp/ut-field.i mgind oper-ord op-codigo 1}
                run utp/ut-msgs.p (input "show":U,
                                   input 2,
                                   input return-value).
    
                return 'ADM-ERROR':U.
            END.
        END.
     END.
 END.
 
  /* Calibracao */
 &if defined (bf_mnt_calib) &then
    IF AVAIL ord-prod  THEN DO:
        FIND ord-manut WHERE ord-manut.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK NO-ERROR.
        IF &IF DEFINED (bf_mnt_ems205) &THEN
             param-global.log-modul-calib 
           &else
             substr(param-global.char-2,100,1) = "2" 
           &endif
        AND AVAIL ord-manut 
        &IF DEFINED (bf_mnt_ems208) &THEN
            AND ord-manut.tp-manut = 3
        &else
            AND ord-manut.dec-1 = 3
        &endif
        and ord-manut.estado = 1 THEN DO:
            {utp/ut-table.i mgind ord-prod 1}
            run utp/ut-msgs.p("show", 28075, return-value).    /* ordem de calibracao nao liberada*/
            return 'ADM-ERROR':U.
        end.
    END.
 &endif
 /*-------------------*/

 if input frame {&frame-name} movto-estoq.ct-codigo = p-ct-db AND
    input frame {&frame-name} movto-estoq.sc-codigo = p-sc-db then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U,
                       input 1832,
                       input return-value).
                       
    apply "entry" to movto-estoq.ct-codigo in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end.

 if avail ord-prod and
    ord-prod.estado = 8 
    then do:

     IF (i-cenario = 2 AND ord-prod.val-per = NO) THEN 
         LEAVE.

     {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show":U,
                        input 1201,
                        input input frame {&frame-name} i-ord-prod).
     apply "entry" to i-ord-prod in frame {&frame-name}.
     return 'ADM-ERROR':U.

 end.


 if input frame {&frame-name} i-ord-prod = 0 and
    (i-ct-inv = "" and i-sc-inv = "") then do:

    
    find estabelec where
         estabelec.cod-estabel = c-estabelec no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec. 
    
    run pi-desformata-campos.
    /* Conta */
    ASSIGN v_cod_cta_ctbl = movto-estoq.ct-codigo:screen-value.
    /* Centro de custo */
    ASSIGN v_cod_ccusto = movto-estoq.sc-codigo:screen-value.
    run pi-formata-campos.
    
    /* Busca dados da conta cont bil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA€ÇO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */
                                                    
    find first tt_log_erro no-lock no-error.
    if avail tt_log_erro then do:
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show":U,
                          input 17006,
                          STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        
                           
       apply "entry" to movto-estoq.ct-codigo in frame {&frame-name}.
       return 'ADM-ERROR':U.       
    end.                                                   

    /*if conta - contab.estado <> 3 then do:*/
    if v_num_sit_cta_ctbl <> 3 then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U,
                         input 443,
                         input return-value).
      apply "entry" to movto-estoq.ct-codigo in frame {&frame-name}.                          
      return 'ADM-ERROR':U.
    end.
     /*if conta - contab.estoque = 0 then do:*/
    if lookup("(nenhum)", v_ind_finalid_cta) <> 0 then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U,
                         input 445,
                         input return-value).
      apply "entry" to movto-estoq.ct-codigo in frame {&frame-name}.                          
      return 'ADM-ERROR':U.
    end.
    /*if conta - contab.estoque = 9 then do:*/
    if lookup({adinc/i05ad049.i 4 9}, v_ind_finalid_cta) <> 0 then do:
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show":U,
                          input 1784,
                          input return-value).
       apply "entry" to movto-estoq.ct-codigo in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end.

      RUN pi_busca_dados_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        i-empresa,           /* EMPRESA EMS2 */
                                                       INPUT        "CEP":U,             /* M…DULO */
                                                       INPUT        "",                  /* PLANO DE CONTAS */
                                                       INPUT        v_cod_cta_ctbl,      /* CONTA */
                                                       input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA TRANSACAO */    
                                                       OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                       OUTPUT TABLE tt_log_erro).        /* ERROS */ 

       /* Erros Conta Contÿbil */
       FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
       IF AVAIL tt_log_erro THEN DO:
          run utp/ut-msgs.p (input "show", input 17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
          apply 'entry' to movto-estoq.ct-codigo in frame {&frame-name}.
          return 'adm-error'.
       END.

        if  v_ind_finalid_cta = "" then do:
           run utp/ut-msgs.p (input "show",input 1884,input "").
           apply 'entry' to movto-estoq.ct-codigo in frame {&frame-name}.
           return 'adm-error'.
       end. 


    /* Verifica se a conta utiliza centro de custo */
    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  v_cod_cta_ctbl,     /* CONTA */
                                                       input input frame {&frame-name} movto-estoq.dt-trans,              /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */
    IF v_log_utz_ccusto THEN DO:
         /* Busca dados do centro de custo */
         run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                    input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                    input  v_cod_ccusto,       /* CCUSTO */
                                                    input input frame {&frame-name} movto-estoq.dt-trans,              /* DATA DE TRANSACAO */
                                                    output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                    output table tt_log_erro). /* ERROS */
    
         find first tt_log_erro no-lock no-error.
         if avail tt_log_erro then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show":U,
                               input 17006,
                               STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).        
    
            apply "entry" to movto-estoq.sc-codigo in frame {&frame-name}.
            return 'ADM-ERROR':U.       
         end.
    END.
 end.
 
 if i-pais-impto-usuario = 33 then do: /* Peru */
    IF i-tp-comprov-doc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " " OR
       i-tp-comprov-doc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ? then do:
        {utp/ut-liter.i "Tipo_do_comprovante" *}
        run utp/ut-msgs.p (input "show":U, input 5793, input RETURN-VALUE). /* &1 deve ser diferente de branco */
        apply "entry" to i-tp-comprov-doc in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    ELSE DO:
        find first internac-tip-comprov no-lock
             where internac-tip-comprov.cdn-tip-comprov = input frame {&frame-name} i-tp-comprov-doc no-error.
        IF NOT AVAIL internac-tip-comprov THEN DO:
            {utp/ut-liter.i "Tipo_do_comprovante" *}
            run utp/ut-msgs.p (input "show":U, input 47, input RETURN-VALUE). /* &1 nÆo cadastrado(a) */
            apply "entry" to i-tp-comprov-doc in frame {&frame-name}.
            return 'ADM-ERROR':U.
        END.
    END.
    
    IF i-tp-operacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " " OR
       i-tp-operacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ? then do:
        {utp/ut-liter.i "Tipo_de_opera‡Æo" *}
        run utp/ut-msgs.p (input "show":U, input 5793, input RETURN-VALUE). /* &1 deve ser diferente de branco */
        apply "entry" to i-tp-operacao in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    ELSE DO:
        find first internac-tip-operacao no-lock
             where internac-tip-operacao.cdn-tip-operacao = input frame {&frame-name} i-tp-operacao no-error.
        IF NOT AVAIL internac-tip-operacao THEN DO:
            {utp/ut-liter.i "Tipo_de_opera‡Æo" *}
            run utp/ut-msgs.p (input "show":U, INPUT 47, input RETURN-VALUE). /* &1 nÆo cadastrado(a) */
            apply "entry" to i-tp-operacao in frame {&frame-name}.
            return 'ADM-ERROR':U.
        END.
    END.
 end.

  /* Chamada EPC para a after validate */
  {include/i-epc019.i}

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
  {src/adm/template/snd-list.i "movto-estoq"}

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

