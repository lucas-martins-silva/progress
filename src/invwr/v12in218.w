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
{include/i-prgvrs.i V12IN218 2.00.02.074 } /*** "010274" 09/01/2026 14:41:40  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v12in218 MUT}
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
def new global shared var g-item       like saldo-estoq.it-codigo   no-undo.
def new global shared var g-estab      like saldo-estoq.cod-estabel no-undo.
def new global shared var c-it-codigo  like saldo-estoq.it-codigo   no-undo.
def new global shared var c-estab      like saldo-estoq.cod-estabel no-undo.
def new global shared var gc-cod-dep   like saldo-estoq.cod-depos   no-undo.
def new global shared var gr-argext-sdo-estoq as rowid no-undo.
def new shared var i-emp050 as char format "x(03)" no-undo.
def new shared var i-cta050 like movto-estoq.ct-codigo no-undo.
def new shared var i-sbc050 like movto-estoq.sc-codigo no-undo.

/* Variavel utilizada para movimenta‡äes manuais ce0206/ce0220 */
DEF NEW GLOBAL SHARED VAR g-declar-control-aduana LIKE sdo-estoq-internac.declaracao-import NO-UNDO.

DEF NEW GLOBAL SHARED VAR g-cod-depos-aux AS CHAR FORMAT "x(3)" NO-UNDO.

/* Definicao de pre processador */
{cdp/cdcfgmat.i} /* defini‡Æo pr‚-processadores materiais */
{bcp/bcapi001.i} /* definicao Temp-table TT-TRANS    */
{bcp/bcapi002.i} /* definicao Temp-Table TT-ETIQUETA */
{bcp/bcapi004.i} /*definicao da temp-table tt-prog-bc */
{bcp/bcapi011.i} /*definicao da temp-table tt-prog-bc */
{cdp/cd0666.i}   /* Definicao da temp-table de erros */
{cdp/cdcfgdis.i} /* defini‡Æo pr‚-processadores distribui‡Æo */
{utp/ut-glob.i}

&if "{&bf_mat_versao_ems}" >= "2.04" &then
    {cqp/cqapi001.i}
&else
    {cqp/cq9050.i}
&endif

&if "{&bf_mat_versao_ems}" >= "2.062" &then
    {cep/ceapi001k.i} /* Definicao de temp-table do movto-estoq */
    {cdp/cd9590.i}

    DEF VAR h-ceapi001k      AS HANDLE NO-UNDO.
    DEF VAR h-cdapi024       AS HANDLE NO-UNDO.
    DEF VAR c-unid-negoc     AS CHAR   NO-UNDO.
&else
    {cep/ceapi001.i} /* Definicao de temp-table do movto-estoq */
&endif

def buffer b-movto   for movto-estoq.
def buffer b-movto-1 for movto-estoq.
def buffer b-aloca   for aloca-reserva.

/* Local Variable Definitions ---                                       */
def var de-diferenca              like saldo-estoq.qt-aloc-prod        no-undo.
def var de-difer-saldo            like de-diferenca                    no-undo.
def var de-transfere              like aloca-reserva.quant-aloc        no-undo.
def var de-dispo                  like saldo-estoq.qtidade-atu  init 0 no-undo.
def var da-data-aux               like saldo-estoq.dt-vali-lote        no-undo.
def var i-ficha-cq                like ficha-cq.nr-ficha               no-undo.
def var i-operacao                like oper-ord.op-codigo              no-undo.
def var l-primeira                  as logical  init yes               no-undo.
def var l-confirma                  as logical  init no                no-undo.
def var l-repetiu                   as logical  init no                no-undo.
def var i-reduz-rep                 as integer                         no-undo.
def var i-ind-tipo-dep-saida        as integer                         no-undo.
def var c-ant-it-codigo             as char init "?"                   no-undo.
def var c-ant-estab-sai             as char                            no-undo.
def var c-ant-estab-ent             as char                            no-undo.
def var l-executou-zoom-item        as log                             no-undo.
def var l-executou-zoom-estab       as log                             no-undo.
def var l-executou-zoom-estab-ent   as log                             no-undo.
def var dt-trans-rep                as date                            no-undo.
def var c-docto-rep                 as char                            no-undo.
def var c-serie-rep                 as char                            no-undo.
def var c-conta-rep                 as char                            no-undo.
def var c-titulo-rep                as char                            no-undo.
def var c-ccusto-rep                as char                            no-undo.
def var c-tit-cc-rep                as char                            no-undo.
def var i-tp-etiqueta               as inte                            no-undo.
def var i-erro-status               as inte                            no-undo.
def var c-estabelec                 as char                            no-undo.
def var c-unid-medida               as char                            no-undo.
def var i-empresa                 like param-global.empresa-prin       no-undo.
def var c-cod-depos                 as char                            no-undo.
def var c-cod-localiz               as char                            no-undo.
def var l-loc-unica                 as log                             no-undo.
def var h-acomp                     as handle                          no-undo.
def VAR i-fim as integer no-undo.
DEF VAR rw-saldo     AS ROWID       NO-UNDO.
DEF VAR l-habilita   AS LOG INIT NO NO-UNDO.
DEF VAR h-boar202155 AS HANDLE      NO-UNDO.
DEF VAR h-boin01067  AS HANDLE      NO-UNDO.

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
def var h-ceapi030      as handle no-undo.
def var l-lote-avancado as log    no-undo.
def var l-retorno       as log    no-undo.
def var h-handle        as handle no-undo.

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.

define var c-formato-conta  as char no-undo.
define var c-formato-ccusto as char no-undo. 

def temp-table tt_log_erro no-undo
         field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
         field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
         field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia".

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

/* Handle da API Conta Contÿbil */
run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
/* Handle da API Centro Custo */
run prgint\utb\utb742za.py persistent set h_api_ccusto.  

DEF VAR c-cod-estabel-usuar LIKE estabelec.cod-estabel.

{cep/ceapi030.i}
&endif

/* SEGURANCA POR ESTABELECIMENTO */
{cdp/cd0031.i "MCE"}/* Include da nova seguranca por estabelecimento */
DEFINE VARIABLE c-estabel-pad LIKE estabelec.cod-estabel NO-UNDO.

DEF VAR l-control-aduana-internac AS LOG INIT NO NO-UNDO.
ASSIGN l-control-aduana-internac = (i-pais-impto-usuario <> 1 AND CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-controle-aduana-internac":U AND funcao.ativo)).

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
&Scoped-define EXTERNAL-TABLES movto-estoq
&Scoped-define FIRST-EXTERNAL-TABLE movto-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-estoq.dt-trans movto-estoq.nro-docto ~
movto-estoq.serie-docto movto-estoq.ct-codigo movto-estoq.sc-codigo ~
movto-estoq.it-codigo movto-estoq.cod-estabel movto-estoq.cod-depos ~
movto-estoq.cod-localiz movto-estoq.lote movto-estoq.cod-refer ~
movto-estoq.un movto-estoq.quantidade 
&Scoped-define ENABLED-TABLES movto-estoq
&Scoped-define FIRST-ENABLED-TABLE movto-estoq
&Scoped-Define ENABLED-OBJECTS c-despacho rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS movto-estoq.dt-trans movto-estoq.nro-docto ~
movto-estoq.serie-docto movto-estoq.ct-codigo movto-estoq.sc-codigo ~
movto-estoq.it-codigo movto-estoq.cod-estabel movto-estoq.cod-depos ~
movto-estoq.cod-localiz movto-estoq.lote movto-estoq.cod-refer ~
movto-estoq.un movto-estoq.quantidade 
&Scoped-define DISPLAYED-TABLES movto-estoq
&Scoped-define FIRST-DISPLAYED-TABLE movto-estoq
&Scoped-Define DISPLAYED-OBJECTS c-titulo-conta c-titulo-ccusto c-desc-item ~
c-desc-est-sai c-desc-dep-sai c-desc-loc-sai da-dt-vali-lote-sai c-despacho ~
c-desc-est-ent c-cod-depos-ent c-desc-dep-ent c-cod-localiz-ent ~
c-desc-loc-ent c-lote-ent da-dt-vali-lote-ent c-cod-refer-ent c-desc-tab ~
i-nr-etiquetas 

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
DEFINE MENU POPUP-MENU-c-cod-depos-ent 
       MENU-ITEM mZoomDeposE    LABEL "Zoom de Dep¢sitos"
       MENU-ITEM mZoomSalDepE   LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-c-cod-localiz-ent 
       MENU-ITEM mZoomLocalE    LABEL "Zoom de Localiza‡äes"
       MENU-ITEM mZoomSalLocE   LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-c-cod-refer-ent 
       MENU-ITEM mZoomReferE    LABEL "Zoom de Referˆncia"
       MENU-ITEM mZoomSalRefE   LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-cod-depos 
       MENU-ITEM mZoomDeposS    LABEL "Zoom de Dep¢sitos"
       MENU-ITEM mZoomSalDepS   LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-cod-localiz 
       MENU-ITEM mZoomLocalS    LABEL "Zoom de Localiza‡äes"
       MENU-ITEM mZoomSalLocS   LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-cod-refer 
       MENU-ITEM mZoomReferS    LABEL "Zoom de Referˆncia"
       MENU-ITEM mZoomSalRefS   LABEL "Zoom de Saldos".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cod-depos-ent AS CHARACTER FORMAT "x(3)" 
     LABEL "":R10 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ent LIKE estabelec.cod-estabel
     LABEL "":R7 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-localiz-ent AS CHARACTER FORMAT "X(20)" 
     LABEL "":R14 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-refer-ent AS CHARACTER FORMAT "x(8)" 
     LABEL "Ref Ent" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-dep-ent AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-dep-sai AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-est-ent AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-est-sai AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 44.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-loc-ent AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 37.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-loc-sai AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tab AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-despacho AS CHARACTER FORMAT "X(20)":U 
     LABEL "Despacho Plaza" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-lote-ent AS CHARACTER FORMAT "X(40)" 
     LABEL "Lote Ent":R12 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-ccusto AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE VARIABLE c-titulo-conta AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE VARIABLE da-dt-vali-lote-ent AS DATE FORMAT "99/99/9999" 
     LABEL "Val Lote" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-vali-lote-sai AS DATE FORMAT "99/99/9999" 
     LABEL "Val Lote" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-etiquetas AS CHARACTER FORMAT "X(256)":U 
     LABEL "Qt.Etiquetas" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 11.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-estoq.dt-trans AT ROW 1.33 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     movto-estoq.nro-docto AT ROW 1.33 COL 44.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     movto-estoq.serie-docto AT ROW 1.33 COL 77 COLON-ALIGNED
          LABEL "":R18
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     movto-estoq.ct-codigo AT ROW 2.33 COL 17.57 COLON-ALIGNED
          LABEL "Conta":R10
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-titulo-conta AT ROW 2.33 COL 38 COLON-ALIGNED NO-LABEL
     movto-estoq.sc-codigo AT ROW 3.33 COL 17.57 COLON-ALIGNED
          LABEL "Centro Custo":R12
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-titulo-ccusto AT ROW 3.33 COL 38 COLON-ALIGNED NO-LABEL
     movto-estoq.it-codigo AT ROW 4.75 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-desc-item AT ROW 4.75 COL 35.29 COLON-ALIGNED NO-LABEL
     movto-estoq.cod-estabel AT ROW 5.75 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-desc-est-sai AT ROW 5.75 COL 25.43 COLON-ALIGNED NO-LABEL
     movto-estoq.cod-depos AT ROW 6.75 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-desc-dep-sai AT ROW 6.75 COL 25.43 COLON-ALIGNED NO-LABEL
     movto-estoq.cod-localiz AT ROW 7.75 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     c-desc-loc-sai AT ROW 7.75 COL 42.86 COLON-ALIGNED NO-LABEL
     movto-estoq.lote AT ROW 8.75 COL 17.57 COLON-ALIGNED
          LABEL "Lote Sai":R12
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     da-dt-vali-lote-sai AT ROW 8.75 COL 50.14 COLON-ALIGNED
     movto-estoq.cod-refer AT ROW 9.75 COL 17.57 COLON-ALIGNED
          LABEL "Ref Sai":R12
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-despacho AT ROW 9.75 COL 51.72 COLON-ALIGNED WIDGET-ID 2
     c-cod-estabel-ent AT ROW 10.75 COL 17.57 COLON-ALIGNED HELP
          ""
          LABEL "":R7
     c-desc-est-ent AT ROW 10.75 COL 25.57 COLON-ALIGNED NO-LABEL
     c-cod-depos-ent AT ROW 11.75 COL 17.57 COLON-ALIGNED HELP
          "Codigo do Deposito"
     c-desc-dep-ent AT ROW 11.75 COL 25.57 COLON-ALIGNED NO-LABEL
     c-cod-localiz-ent AT ROW 12.75 COL 17.57 COLON-ALIGNED
     c-desc-loc-ent AT ROW 12.75 COL 43.14 COLON-ALIGNED NO-LABEL
     c-lote-ent AT ROW 13.75 COL 17.57 COLON-ALIGNED
     da-dt-vali-lote-ent AT ROW 13.75 COL 50.14 COLON-ALIGNED
     c-cod-refer-ent AT ROW 14.75 COL 17.57 COLON-ALIGNED
     movto-estoq.un AT ROW 14.75 COL 63.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     c-desc-tab AT ROW 14.75 COL 69 COLON-ALIGNED NO-LABEL
     movto-estoq.quantidade AT ROW 13.75 COL 68.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     i-nr-etiquetas AT ROW 8.75 COL 72.57 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.movto-estoq
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
         HEIGHT             = 15
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-cod-depos-ent IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-depos-ent:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-cod-depos-ent:HANDLE.

/* SETTINGS FOR FILL-IN c-cod-estabel-ent IN FRAME f-main
   NO-DISPLAY NO-ENABLE LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FILL-IN c-cod-localiz-ent IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-localiz-ent:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-cod-localiz-ent:HANDLE.

/* SETTINGS FOR FILL-IN c-cod-refer-ent IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-refer-ent:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-cod-refer-ent:HANDLE.

/* SETTINGS FOR FILL-IN c-desc-dep-ent IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-dep-sai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-est-ent IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-est-sai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-loc-ent IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-loc-sai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tab IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-despacho:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-lote-ent IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-ccusto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-conta IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       movto-estoq.cod-depos:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-cod-depos:HANDLE.

ASSIGN 
       movto-estoq.cod-localiz:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-cod-localiz:HANDLE.

/* SETTINGS FOR FILL-IN movto-estoq.cod-refer IN FRAME f-main
   EXP-LABEL                                                            */
ASSIGN 
       movto-estoq.cod-refer:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-cod-refer:HANDLE.

/* SETTINGS FOR FILL-IN movto-estoq.ct-codigo IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN da-dt-vali-lote-ent IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-dt-vali-lote-sai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-nr-etiquetas IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.lote IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.sc-codigo IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.serie-docto IN FRAME f-main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME c-cod-depos-ent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos-ent V-table-Win
ON F5 OF c-cod-depos-ent IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom = "inzoom/z01in084.w"
                       &campo     = c-cod-depos-ent
                       &campozoom = cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos-ent V-table-Win
ON LEAVE OF c-cod-depos-ent IN FRAME f-main
DO:
  {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=c-desc-dep-ent
                   &where="deposito.cod-depos = input frame {&frame-name} c-cod-depos-ent"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos-ent V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-depos-ent IN FRAME f-main
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-estabel-ent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel-ent V-table-Win
ON ENTRY OF c-cod-estabel-ent IN FRAME f-main
DO:
    if not l-executou-zoom-estab-ent then
        assign c-ant-estab-ent = input frame {&frame-name} c-cod-estabel-ent.

    assign l-executou-zoom-estab-ent = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel-ent V-table-Win
ON F5 OF c-cod-estabel-ent IN FRAME f-main
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=c-cod-estabel-ent
                     &campo2=c-desc-est-ent
                     &campozoom=cod-estabel
                     &campozoom2=nome}
                     
    assign l-executou-zoom-estab-ent = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel-ent V-table-Win
ON LEAVE OF c-cod-estabel-ent IN FRAME f-main
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-desc-est-ent
                   &where="estabelec.cod-estabel = input frame {&frame-name}
                                                         c-cod-estabel-ent"}

  assign c-estab = input frame {&frame-name} movto-estoq.cod-estabel.
  find first estabelec
      where  estabelec.cod-estabel = input frame {&frame-name} c-cod-estabel-ent
      no-lock no-error.

  &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
      if  c-ant-estab-ent <> input frame {&frame-name} c-cod-estabel-ent     OR
          INPUT c-cod-depos-ent  = "" then
          RUN pi-trata-dep-localiz-ent IN THIS-PROCEDURE.
  &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel-ent V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel-ent IN FRAME f-main
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-localiz-ent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz-ent V-table-Win
ON F5 OF c-cod-localiz-ent IN FRAME f-main
DO:
  &SCOPED-DEFINE estab    input frame {&FRAME-NAME} c-cod-estabel-ent
  &SCOPED-DEFINE deposito input frame {&FRAME-NAME} c-cod-depos-ent

  assign l-implanta = yes. 
  {include/zoomvar.i &prog-zoom   = "inzoom/z02in189.w"
                     &campo       = c-cod-localiz-ent
                     &campozoom   = cod-localiz
                     &campo2      = c-desc-loc-ent
                     &campozoom2  = descricao
                     &campo3      = c-cod-depos-ent
                     &campozoom3  = cod-depos
                     &campo4      = c-cod-refer-ent
                     &campozoom4  = cod-refer
                     &parametros  = "run pi-faixa in wh-pesquisa ({&estab},
                                                                  {&deposito},
                                                                  {&deposito})."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz-ent V-table-Win
ON LEAVE OF c-cod-localiz-ent IN FRAME f-main
DO:
  {include/leave.i &tabela=localizacao
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-loc-ent
                   &where="localizacao.cod-estabel = input frame {&frame-name} c-cod-estabel-ent and
                           localizacao.cod-depos   = input frame {&frame-name} c-cod-depos-ent   and
                           localizacao.cod-localiz = input frame {&frame-name} c-cod-localiz-ent"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz-ent V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-localiz-ent IN FRAME f-main
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-refer-ent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-refer-ent V-table-Win
ON F5 OF c-cod-refer-ent IN FRAME f-main /* Ref Ent */
DO:
      assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} movto-estoq.cod-estabel
        c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = c-cod-refer-ent
        &campo2     = c-cod-depos-ent
        &campo3     = c-cod-localiz-ent
        &campo4     = c-lote-ent
        &campozoom  = cod-refer
        &campozoom2 = cod-depos
        &campozoom3 = cod-localiz
        &campozoom4 = lote}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-refer-ent V-table-Win
ON LEAVE OF c-cod-refer-ent IN FRAME f-main /* Ref Ent */
DO:
    RUN pi-leave-c-cod-refer.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-refer-ent V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-refer-ent IN FRAME f-main /* Ref Ent */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-despacho
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-despacho V-table-Win
ON F5 OF c-despacho IN FRAME f-main /* Despacho Plaza */
DO:
    IF (i-pais-impto-usuario = 2 /* Argentina */
    AND CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-cod-despacho-plaza":U AND funcao.ativo)) THEN DO:
    
        RUN local/arg/arg0220.w (INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel,
                                 INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-depos,
                                 INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-localiz,
                                 INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.it-codigo,
                                 INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-refer,
                                 INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.lote,
                                 OUTPUT c-despacho,
                                 OUTPUT rw-saldo).
        ASSIGN c-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-despacho.
    END.

    IF  l-control-aduana-internac THEN DO:
        RUN cep/ce0830int.w (INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel,
                             INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-depos,
                             INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-localiz,
                             INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.it-codigo,
                             INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-refer,
                             INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.lote,
                             OUTPUT c-despacho).
        ASSIGN c-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-despacho.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-despacho V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-despacho IN FRAME f-main /* Despacho Plaza */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-lote-ent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-lote-ent V-table-Win
ON F5 OF c-lote-ent IN FRAME f-main /* Lote Ent */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = "c-cod-depos-ent"
        &campozoom  = "cod-depos"
        &campo2     = "c-cod-refer-ent"
        &campozoom2 = "cod-refer"
        &campo3     = "c-cod-localiz-ent"
        &campozoom3 = "cod-localiz"
        &campo4     = "c-lote-ent"
        &campozoom4 = "lote"
        &campo5     = "c-desc-dep-ent"
        &campozoom5 = "nome"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-lote-ent V-table-Win
ON LEAVE OF c-lote-ent IN FRAME f-main /* Lote Ent */
DO:
if avail param-estoq then
    do  with frame {&FRAME-NAME}:
        if input frame {&frame-name} c-cod-refer-ent = "" then do:
            find first saldo-estoq
                  where saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
                    and saldo-estoq.lote        = input frame {&frame-name} c-lote-ent
                    and saldo-estoq.cod-depos   = input frame {&frame-name} c-cod-depos-ent
                    and saldo-estoq.cod-localiz = input frame {&frame-name} c-cod-localiz-ent
                    and saldo-estoq.cod-estabel = input frame {&frame-name} c-cod-estabel-ent
              no-lock no-error.
        end.
        else do:
            find first saldo-estoq
                  where saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
                    and saldo-estoq.lote        = input frame {&frame-name} c-lote-ent
                    and saldo-estoq.cod-depos   = input frame {&frame-name} c-cod-depos-ent
                    and saldo-estoq.cod-localiz = input frame {&frame-name} c-cod-localiz-ent
                    and saldo-estoq.cod-estabel = input frame {&frame-name} c-cod-estabel-ent
                    and saldo-estoq.cod-refer   = input frame {&frame-name} c-cod-refer-ent
                no-lock no-error.
        end.

        if  avail saldo-estoq then do:
            disp saldo-estoq.dt-vali-lote @ da-dt-vali-lote-ent
                 saldo-estoq.cod-refer    @ c-cod-refer-ent.
            disable da-dt-vali-lote-ent.
            if substring(param-estoq.char-2,1,1) <> "#" then
                disable c-cod-refer-ent.
        end.
        else do:
            if input frame {&frame-name} c-lote-ent = input frame {&frame-name} movto-estoq.lote then do:
                disable da-dt-vali-lote-ent.
                assign da-dt-vali-lote-ent = input frame {&frame-name} da-dt-vali-lote-sai.
                display da-dt-vali-lote-ent.
            end.
            else
                enable da-dt-vali-lote-ent.

        end.
        if da-dt-vali-lote-ent:sensitive = yes then do:
            apply "entry" to da-dt-vali-lote-ent.
            return no-apply.
        end.
    end.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-lote-ent V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-lote-ent IN FRAME f-main /* Lote Ent */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-depos V-table-Win
ON F5 OF movto-estoq.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  /*{include/zoomvar.i &prog-zoom="inzoom/z02in403.w"
                     &campo=movto-estoq.cod-depos
                     &campo2=c-desc-dep-sai
                     &campo3=movto-estoq.cod-localiz
                     &campo4=movto-estoq.lote
                     &campo5=movto-estoq.cod-refer
                     &campozoom=cod-depos
                     &campozoom2=nome
                     &campozoom3=cod-localiz
                     &campozoom4=lote
                     &campozoom5=cod-refer} */
                     


    /*  assign
    l-implanta  = yes
    c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo
    gc-cod-dep  = input frame {&frame-name} movto-estoq.cod-depos.*/

   /* movto-estoq.it-codigo:screen value {&frame-name} c-it-codigo.*/

  {include/zoomvar.i &prog-zoom  = "inzoom/z02in403.w"
                     &campo      = movto-estoq.cod-depos
                     &campozoom  = cod-depos
                     &campo2     = c-desc-dep-sai
                     &campozoom2 = nome
                     &campo3     = movto-estoq.cod-localiz
                     &campozoom3 = cod-localiz
                     &campo4     = movto-estoq.lote
                     &campozoom4 = lote
                     &campo5     = movto-estoq.cod-refer
                     &campozoom5 = cod-refer}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-depos V-table-Win
ON LEAVE OF movto-estoq.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
/*   apply "entry" to movto-estoq.cod-depos. */
  {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=c-desc-dep-sai
                   &where="deposito.cod-depos = input frame {&frame-name} movto-estoq.cod-depos"}
    RUN pi-despacho.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON ENTRY OF movto-estoq.cod-estabel IN FRAME f-main /* Estabel */
DO:
/*    IF RETURN-VALUE = 'ADM-ERROR':U OR RETURN-VALUE = 'NOK':U THEN DO:  */
/*        apply "ENTRY":U to movto-estoq.it-codigo in frame {&frame-name}.*/
/*        RETURN NO-APPLY.                                                */
/*    END.                                                                */
    IF RETURN-VALUE = '':U THEN DO:
        if  not can-find(first item where  item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo) then do:
            apply "ENTRY":U to movto-estoq.it-codigo in frame {&frame-name}.
            RETURN NO-APPLY.
        end.
    END.
    if not l-executou-zoom-estab then
        assign c-ant-estab-sai = input frame {&frame-name} movto-estoq.cod-estabel.

    assign l-executou-zoom-estab = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON F5 OF movto-estoq.cod-estabel IN FRAME f-main /* Estabel */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=movto-estoq.cod-estabel
                     &campo2=c-desc-est-sai
                     &campozoom=cod-estabel
                     &campozoom2=nome}
                     
   assign l-executou-zoom-estab = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON LEAVE OF movto-estoq.cod-estabel IN FRAME f-main /* Estabel */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-desc-est-sai
                   &where="estabelec.cod-estabel = input frame {&frame-name}
                                                   movto-estoq.cod-estabel"}

  if not avail estabelec then
    assign movto-estoq.cod-estabel:screen-value in frame {&frame-name} = "":u.

  assign c-estab = input frame {&frame-name} movto-estoq.cod-estabel
         c-ant-estab-ent = input frame {&frame-name} c-cod-estabel-ent
         c-cod-estabel-ent:screen-value in frame {&frame-name} =
                   input frame {&frame-name} movto-estoq.cod-estabel
         c-desc-est-ent:screen-value in frame {&frame-name} = 
                   estabelec.nome when avail estabelec
         c-it-codigo  = ""
         c-estab      = ""
         c-it-codigo  = input frame {&frame-name} movto-estoq.it-codigo
         c-estab      = input frame {&FRAME-NAME} movto-estoq.cod-estabel
         c-estabelec  = input frame {&FRAME-NAME} movto-estoq.cod-estabel.

  /*********************************************************************************
  * Pr‚-processador para informar conta cont bil conforme estabelec - release 2.03 *   
  **********************************************************************************/
  &if defined(bf_mat_conta_estab) &then 
      find estab-mat where estab-mat.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel 
         no-lock no-error.

      assign movto-estoq.ct-codigo:format = "x(20)".
      ASSIGN v_cod_cta_ctbl = movto-estoq.ct-codigo:screen-value.
      
      find estabelec where
            estabelec.cod-estabel = c-estabelec no-lock no-error.
      assign i-empresa = estabelec.ep-codigo when avail estabelec.  
    
      /* Retorna formato da conta contabil */
      run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                         input  "",                 /* PLANO CONTAS */
                                                         input  TODAY,              /* DATA DE TRANSACAO */
                                                         output c-formato-conta,    /* FORMATO CONTA */
                                                         output table tt_log_erro). /* ERROS */
      if c-formato-conta <> "" then
        assign movto-estoq.ct-codigo:format = c-formato-conta.

      if avail estab-mat and 
          /* S¢ altera Conta se for diferente de branco */
          estab-mat.cod-cta-transf-unif <> "" AND
          estab-mat.cod-cta-transf-unif <> v_cod_cta_ctbl        
        then do:
         run utp/ut-msgs.p (input "show", 
                            input "18700", 
                            input ""). /*Deseja alterar a conta de transf? */               
         if return-value = "yes" then do:
            do  with frame {&FRAME-NAME}:

               assign movto-estoq.ct-codigo:screen-value = estab-mat.cod-cta-transf-unif.
               apply "leave" to movto-estoq.ct-codigo.

               /* S¢ altera Centro de custo se for diferente de branco */
               IF estab-mat.cod-ccusto-transf-unif <> "" THEN DO:
                   assign movto-estoq.sc-codigo:screen-value = estab-mat.cod-ccusto-transf-unif.
                   apply "leave" to movto-estoq.sc-codigo.
               END.

            end.
         end.                           
      end.      
      else do:
         if not avail estab-mat and movto-estoq.cod-estabel:screen-value <> "" then do:
                run utp/ut-msgs.p (input "show":u,
                                   input 537,
                                   input "").
                return 'ADM-ERROR':U.
         end.
      end.
  &endif
  /*********************************************************************************/

    IF RETURN-VALUE = 'ADM-ERROR':U OR RETURN-VALUE = 'NOK':U THEN DO:
        apply "ENTRY":U to movto-estoq.cod-estabel in frame {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
    IF RETURN-VALUE = '':U THEN DO:
        if  not can-find(estab-mat where estab-mat.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel) then do:
            apply "ENTRY":U to movto-estoq.cod-estabel in frame {&FRAME-NAME}.
            RETURN NO-APPLY.
        end.
    END.

  &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
      if  c-ant-estab-sai      <> input frame {&frame-name} movto-estoq.cod-estabel OR
          input frame {&frame-name} movto-estoq.cod-depos = "" then
          RUN pi-trata-dep-localiz-sai IN THIS-PROCEDURE.

      if  c-ant-estab-ent <> input frame {&frame-name} c-cod-estabel-ent     OR
          input frame {&frame-name} c-cod-depos-ent  = "" then
          RUN pi-trata-dep-localiz-ent IN THIS-PROCEDURE.
  &ENDIF
      apply "entry" to movto-estoq.it-codigo.
    RUN pi-despacho.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-estabel IN FRAME f-main /* Estabel */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON F5 OF movto-estoq.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:

/*    implementada a variavel global gc-cod-dep pelo motivo  */
/*    do zoom retornar registro errado quando utilizados os  */
/*    metodos pi-inicializa-paginas e pi-set-faixa-dep na    */
/*    wh-pesquisa, quando nao ha interacao do usuario com o  */
/*    zoom.                                                  */

  assign
    l-implanta  = yes
    c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo
    gc-cod-dep  = input frame {&frame-name} movto-estoq.cod-depos.

  {include/zoomvar.i &prog-zoom  = "inzoom/z02in403.w"
                     &campo      = movto-estoq.cod-localiz
                     &campozoom  = cod-localiz
                     &campo2     = c-desc-loc-sai
                     &campozoom2 = descricao
                     &campo3     = movto-estoq.cod-localiz
                     &campozoom3 = cod-localiz
                     &campo4     = movto-estoq.lote
                     &campozoom4 = lote
                     &campo5     = movto-estoq.cod-refer
                     &campozoom5 = cod-refer}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON LEAVE OF movto-estoq.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:

  {include/leave.i &tabela       = localizacao
                   &atributo-ref = descricao
                   &variavel-ref = c-desc-loc-sai
                   &where="localizacao.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel and
                           localizacao.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos   and
                           localizacao.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz"}
      RUN pi-despacho.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-refer V-table-Win
ON F5 OF movto-estoq.cod-refer IN FRAME f-main /* Ref Sai */
DO:
    assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} movto-estoq.cod-estabel
        c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = movto-estoq.cod-refer
        &campo2     = movto-estoq.cod-depos
        &campo3     = movto-estoq.cod-localiz
        &campo4     = movto-estoq.lote
        &campozoom  = cod-refer
        &campozoom2 = cod-depos
        &campozoom3 = cod-localiz
        &campozoom4 = lote}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-refer V-table-Win
ON LEAVE OF movto-estoq.cod-refer IN FRAME f-main /* Ref Sai */
DO:
    RUN pi-leave-cod-refer.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-refer IN FRAME f-main /* Ref Sai */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON ENTRY OF movto-estoq.ct-codigo IN FRAME f-main /* Conta */
DO:
  assign self:format = "x(20)"
         movto-estoq.sc-codigo:FORMAT = "x(20)".
  ENABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON F5 OF movto-estoq.ct-codigo IN FRAME f-main /* Conta */
DO:
    /*
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin
         i-emp050            = param-global.empresa-prin
          l-implanta         = yes.
   */                  


   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,           /* EMPRESA EMS2 */
                                                  input  "CEP",               /* M…DULO */
                                                  input  "",                  /* PLANO DE CONTAS */
                                                  input  {adinc/i05ad049.i 4 4}, /* FINALIDADES */ 
                                               /*   input  "(nenhum)", */
                                                  input  today,               /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro).  /* ERROS */ 

   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN movto-estoq.ct-codigo:SCREEN-VALUE = v_cod_cta_ctbl.
       ASSIGN c-titulo-conta:SCREEN-VALUE = v_titulo_cta_ctbl.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON LEAVE OF movto-estoq.ct-codigo IN FRAME f-main /* Conta */
DO:
    do  with frame {&FRAME-NAME}:

        find estabelec where
                 estabelec.cod-estabel = c-estabelec no-lock no-error.
        assign i-empresa = estabelec.ep-codigo when avail estabelec.            
        
        /* Busca dados da conta cont bil */
        assign self:format = "x(20)".
        ASSIGN v_cod_cta_ctbl = input frame {&frame-name} movto-estoq.ct-codigo.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                       input        "",                 /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,     /* CONTA */
                                                       input        movto-estoq.dt-trans:screen-value, /* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl, /* SITUA›øO DA CONTA */
                                                       output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).       /* ERROS */

        IF RETURN-VALUE = "OK" THEN DO:
            
            run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                               input  "",                 /* PLANO CONTAS */
                                                               input  TODAY,              /* DATA DE TRANSACAO */
                                                               output c-formato-conta,    /* FORMATO CONTA */
                                                               output table tt_log_erro). /* ERROS */
            ASSIGN SELF:FORMAT = c-formato-conta.
            ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl NO-ERROR.
    
            /* Verifica se a conta utiliza centro de custo */
            run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                               input  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                               input  "",                 /* PLANO CONTAS */
                                                               input  v_cod_cta_ctbl,     /* CONTA */
                                                               input  movto-estoq.dt-trans:screen-value, /* DT TRANSACAO */
                                                               output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                               output table tt_log_erro). /* ERROS */
            IF v_log_utz_ccusto THEN DO:
                ENABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
            END.
            ELSE DO:
                ASSIGN movto-estoq.sc-codigo:SCREEN-VALUE = "".
                ASSIGN c-titulo-ccusto:SCREEN-VALUE = "".
                DISABLE movto-estoq.sc-codigo WITH FRAME {&FRAME-NAME}.
            END.
            /************************************************/
        END.
    
        ASSIGN c-titulo-conta:SCREEN-VALUE = v_titulo_cta_ctbl.         

    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.ct-codigo IN FRAME f-main /* Conta */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-dt-vali-lote-sai
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-dt-vali-lote-sai V-table-Win
ON LEAVE OF da-dt-vali-lote-sai IN FRAME f-main /* Val Lote */
DO:
    assign da-dt-vali-lote-ent = input frame {&frame-name} da-dt-vali-lote-sai.
    display da-dt-vali-lote-ent with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.dt-trans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.dt-trans V-table-Win
ON ENTRY OF movto-estoq.dt-trans IN FRAME f-main /* Data Transa‡Æo */
DO:
    do with frame {&FRAME-NAME}:
        
                IF movto-estoq.dt-trans:SCREEN-VALUE = "" THEN
            ASSIGN movto-estoq.dt-trans:screen-value       = string(today).
        
        assign            
            movto-estoq.ct-codigo:screen-value = param-estoq.ct-tr-transf
            movto-estoq.sc-codigo:screen-value = param-estoq.sc-tr-transf.
            
        apply "leave" to movto-estoq.ct-codigo.
        apply "leave" to movto-estoq.sc-codigo.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON ENTRY OF movto-estoq.it-codigo IN FRAME f-main /* Item */
DO:
    if not l-executou-zoom-item then
        assign c-ant-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    assign l-executou-zoom-item = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON F5 OF movto-estoq.it-codigo IN FRAME f-main /* Item */
DO:
  {include/zoomvar.i &prog-zoom  = "inzoom/z02in172.w"
                     &campo      = movto-estoq.it-codigo
                     &campozoom  = it-codigo
                     &campo2     = c-desc-item
                     &campozoom2 = descr-item}
                     
 /* assign l-executou-zoom-item = yes.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON LEAVE OF movto-estoq.it-codigo IN FRAME f-main /* Item */
DO:
/*     if c-ant-it-codigo <> input movto-estoq.it-codigo then do: */

        {include/leave.i &tabela=item
                         &atributo-ref=desc-item
                         &variavel-ref=c-desc-item
                         &where="item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo"}

        find first item
            where  item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo
            no-lock no-error.
        if  avail item then do:
            if  not avail param-estoq then do:
                run utp/ut-msgs.p (input "show":u, input 1059, input return-value).
                return 'ADM-ERROR':U.
            end.

            if  param-estoq.estab-uni then do:
                assign movto-estoq.cod-estabel:screen-value in frame {&frame-name} = c-estabel-pad
                       c-cod-estabel-ent:screen-value       in frame {&frame-name} = c-estabel-pad.
                disable movto-estoq.cod-estabel c-cod-estabel-ent with frame {&frame-name}.
            end.
            else do:
                assign movto-estoq.cod-estabel:screen-value in frame {&frame-name} = c-estabel-pad
                       c-cod-estabel-ent:screen-value       in frame {&frame-name} = c-estabel-pad.
                enable movto-estoq.cod-estabel c-cod-estabel-ent with frame {&frame-name}.
            end.

            if  item.tipo-con-est = 2 then do:
                assign movto-estoq.quantidade:screen-value in frame {&frame-name} = string(1).
                disable movto-estoq.quantidade with frame {&frame-name}.
            end.
            else enable movto-estoq.quantidade with frame {&frame-name}.

            &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
            &ELSE
                assign movto-estoq.cod-depos:screen-value   in frame {&frame-name} = item.deposito-pad
                       movto-estoq.cod-localiz:screen-value in frame {&frame-name} = item.cod-localiz
                       c-cod-localiz-ent:screen-value       in frame {&frame-name} = item.cod-localiz.
    
                if  item.loc-unica then
                    disable movto-estoq.cod-localiz
                            c-cod-localiz-ent
                            with frame {&frame-name}.
                else
                    enable movto-estoq.cod-localiz
                           c-cod-localiz-ent
                           with frame {&frame-name}.
            &ENDIF

            if  item.tipo-con-est = 4 then do:
                enable movto-estoq.cod-refer with frame {&frame-name}.
                enable c-cod-refer-ent       with frame {&frame-name}.
            end.
            else do:
                ASSIGN movto-estoq.cod-refer:screen-value in frame {&frame-name} = ""
                       c-cod-refer-ent:screen-value in frame {&frame-name} = "".
                disable movto-estoq.cod-refer with frame {&frame-name}.
                disable c-cod-refer-ent       with frame {&frame-name}.
            end.

            if  item.tipo-con-est = 1 then do:
                assign movto-estoq.lote:screen-value      in frame {&frame-name} = ""
                       c-lote-ent:screen-value            in frame {&frame-name} = ""
                       movto-estoq.cod-refer:screen-value in frame {&frame-name} = ""
                       c-cod-refer-ent:screen-value       in frame {&frame-name} = "".
                disable movto-estoq.lote with frame {&frame-name}.
                disable c-lote-ent       with frame {&frame-name}.
            end.
            else do:
                enable movto-estoq.lote with frame {&frame-name}.
                enable c-lote-ent       with frame {&frame-name}.
            end.
            enable c-cod-depos-ent with frame {&frame-name}.

            if  item.tipo-contr = 4 then
                enable c-cod-estabel-ent with frame {&frame-name}.
            else do:
                find first estabelec
                    where estabelec.cod-estabel = input frame {&frame-name} c-cod-estabel-ent
                    no-lock no-error.
                if  avail estabelec then do:
                    assign  c-desc-est-sai = estabelec.nome
                            c-desc-est-ent = estabelec.nome.
                    disp c-desc-est-sai 
                         c-desc-est-ent with frame {&frame-name}.
                end.
                disable c-cod-estabel-ent with frame {&frame-name}.
            end.
        end.
        else do:
            run utp/ut-msgs.p (input "show":u,
                               input 166,
                               input "").
            RETURN NO-APPLY.
            /* return 'ADM-ERROR':U. */
        end.

        assign c-it-codigo  = ""
               c-estab      = ""
               c-it-codigo  = input frame {&frame-name} movto-estoq.it-codigo
               c-estab      = input frame {&FRAME-NAME} movto-estoq.cod-estabel.

        &if defined(bf_dis_default_UN) &then

            find param-mat no-lock no-error.
            if  avail param-mat and
                param-mat.ind-sit-un = 2 then do:

                {include/leave.i &tabela=item
                       &atributo-ref=un
                       &variavel-ref=movto-estoq.un
                       &where="item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo"}
            end.
        &endif       
/*      end. */

    IF RETURN-VALUE = 'ADM-ERROR':U OR RETURN-VALUE = 'NOK':U THEN DO:
        apply "ENTRY":U to movto-estoq.it-codigo in frame {&frame-name}.
        RETURN NO-APPLY.
    END.
    IF RETURN-VALUE = '':U THEN DO:
        if  not can-find(first item where  item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo) then do:
            apply "ENTRY":U to movto-estoq.it-codigo in frame {&frame-name}.
            RETURN NO-APPLY.
        end.
    END.

    &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
/*         if  c-ant-it-codigo      <> input movto-estoq.it-codigo   OR */
/*             INPUT movto-estoq.cod-depos = "" then                    */
            RUN pi-trata-dep-localiz-sai IN THIS-PROCEDURE.

/*         if  c-ant-it-codigo <> input movto-estoq.it-codigo OR */
/*             INPUT c-cod-depos-ent  = "" then                  */
            RUN pi-trata-dep-localiz-ent IN THIS-PROCEDURE.
    &ENDIF
    RUN pi-despacho.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.it-codigo IN FRAME f-main /* Item */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.lote V-table-Win
ON F5 OF movto-estoq.lote IN FRAME f-main /* Lote Sai */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z02in403.w"
                     &campo=movto-estoq.cod-depos
                     &campo2=c-desc-dep-sai
                     &campo3=movto-estoq.cod-localiz
                     &campo4=movto-estoq.lote
                     &campo5=movto-estoq.cod-refer
                     &campozoom=cod-depos
                     &campozoom2=nome
                     &campozoom3=cod-localiz
                     &campozoom4=lote
                     &campozoom5=cod-refer}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.lote V-table-Win
ON LEAVE OF movto-estoq.lote IN FRAME f-main /* Lote Sai */
DO:

assign c-lote-ent:screen-value in frame {&frame-name} = input frame {&frame-name} movto-estoq.lote.

if avail param-estoq then do:
    if avail item then do with frame {&FRAME-NAME}:
        if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
            if input frame {&frame-name} movto-estoq.cod-refer = "" then do:
                find first saldo-estoq
                  where saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
                    and saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote
                    and saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos
                    and saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz
                    and saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel 
                  no-lock no-error.
            end.

            else do:
                find first saldo-estoq
                  where saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
                    and saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote
                    and saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos
                    and saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz
                    and saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel 
                    and saldo-estoq.cod-refer   = input frame {&frame-name} movto-estoq.cod-refer
                  no-lock no-error.
            end.

            if avail saldo-estoq then do:
                display saldo-estoq.dt-vali-lote @ da-dt-vali-lote-sai
                        saldo-estoq.cod-refer    @ movto-estoq.cod-refer.

                disable da-dt-vali-lote-sai.
                if substring(param-estoq.char-2,1,1) <> "#" then
                  disable movto-estoq.cod-refer.
            end.
            else do:
                enable da-dt-vali-lote-sai.
                if item.tipo-con-est = 4 then do:
                    enable movto-estoq.cod-refer.
                    display "" @ movto-estoq.cod-refer.
                end.
                else do:
                    disable movto-estoq.cod-refer.
                end.
            end.
        end.
        if da-dt-vali-lote-sai:sensitive = yes then do:
            apply "entry" to da-dt-vali-lote-sai.
            return no-apply.
        end.
    end.
end.
RUN pi-despacho.

apply "leave" to c-lote-ent.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.lote V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.lote IN FRAME f-main /* Lote Sai */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomDeposE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomDeposE V-table-Win
ON CHOOSE OF MENU-ITEM mZoomDeposE /* Zoom de Dep¢sitos */
DO:
    apply "F5" to c-cod-depos-ent in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomDeposS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomDeposS V-table-Win
ON CHOOSE OF MENU-ITEM mZoomDeposS /* Zoom de Dep¢sitos */
DO:
    {include/zoomvar.i &prog-zoom = "inzoom/z01in084.w"
                       &campo     = movto-estoq.cod-depos
                       &campozoom = cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomLocalE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomLocalE V-table-Win
ON CHOOSE OF MENU-ITEM mZoomLocalE /* Zoom de Localiza‡äes */
DO:
    apply "F5" to c-cod-localiz-ent in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomLocalS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomLocalS V-table-Win
ON CHOOSE OF MENU-ITEM mZoomLocalS /* Zoom de Localiza‡äes */
DO:
    &SCOPED-DEFINE estab    input frame {&FRAME-NAME} movto-estoq.cod-estabel
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} movto-estoq.cod-depos

    assign l-implanta = yes.
    {include/zoomvar.i
        &prog-zoom   = "inzoom/z02in189.w"
        &campo       = movto-estoq.cod-localiz
        &campozoom   = cod-localiz
        &campo2      = c-desc-loc-sai
        &campozoom2  = descricao
        &campo3      = movto-estoq.cod-depos
        &campozoom3  = cod-depos
        &parametros  = "run pi-faixa in wh-pesquisa
                            ({&estab},
                             {&deposito}, {&deposito})."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomReferE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomReferE V-table-Win
ON CHOOSE OF MENU-ITEM mZoomReferE /* Zoom de Referˆncia */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in377.w"
                     &campo=c-cod-refer-ent
                     &campozoom=cod-refer}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomReferS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomReferS V-table-Win
ON CHOOSE OF MENU-ITEM mZoomReferS /* Zoom de Referˆncia */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in377.w"
                     &campo=movto-estoq.cod-refer
                     &campozoom=cod-refer}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalDepE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalDepE V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalDepE /* Zoom de Saldos */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = "c-cod-depos-ent"
        &campozoom  = "cod-depos"
        &campo2     = "c-cod-refer-ent"
        &campozoom2 = "cod-refer"
        &campo3     = "c-cod-localiz-ent"
        &campozoom3 = "cod-localiz"
        &campo4     = "c-lote-ent"
        &campozoom4 = "lote"
        &campo5     = "c-desc-dep-ent"
        &campozoom5 = "nome"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalDepS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalDepS V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalDepS /* Zoom de Saldos */
DO:
    apply "F5" to movto-estoq.cod-depos in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalLocE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalLocE V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalLocE /* Zoom de Saldos */
DO:
    apply 'F5' to movto-estoq.lote in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalLocS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalLocS V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalLocS /* Zoom de Saldos */
DO:
    apply "F5" to movto-estoq.cod-localiz in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalRefE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalRefE V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalRefE /* Zoom de Saldos */
DO:
  apply "F5" to c-cod-refer-ent in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalRefS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalRefS V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalRefS /* Zoom de Saldos */
DO:
    apply "F5" to movto-estoq.cod-refer in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.quantidade V-table-Win
ON ENTRY OF movto-estoq.quantidade IN FRAME f-main /* Qtde */
DO:
    IF RETURN-VALUE = 'ADM-ERROR':U OR RETURN-VALUE = 'NOK':U THEN DO:
        apply "ENTRY":U to movto-estoq.it-codigo in frame {&frame-name}.
        RETURN NO-APPLY.
    END.
    IF RETURN-VALUE = '':U THEN DO:
        if  not can-find(first item where  item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo) then do:
            apply "ENTRY":U to movto-estoq.it-codigo in frame {&frame-name}.
            RETURN NO-APPLY.
        end.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.quantidade V-table-Win
ON LEAVE OF movto-estoq.quantidade IN FRAME f-main /* Qtde */
DO:

    if  avail param-global
    and param-global.modulo-cl
    then do:

        for each tt-etq-item:
            delete tt-etq-item.
        end.

        for each tt-prog-bc:
            delete tt-prog-bc.
        end.

        create tt-prog-bc.
        assign tt-prog-bc.cod-prog-dtsul        = "ce0206"
               tt-prog-bc.cod-versao-integracao = 1
               tt-prog-bc.usuario               = c-seg-usuario
               tt-prog-bc.opcao                 = 1.

        run bcp/bcapi004.p (input-output table tt-prog-bc,
                            input-output table tt-erro).

        if return-value = "OK" then do:

            find first tt-prog-bc no-error.

            create tt-etq-item.
            assign tt-etq-item.cod-versao-integracao = 1
                   tt-etq-item.it-codigo = movto-estoq.it-codigo:screen-value
                   tt-etq-item.qt-item   = decimal(movto-estoq.quantidade:screen-value)
                   tt-etq-item.cd-trans  = if avail tt-prog-bc then tt-prog-bc.cd-trans else "".

            run bcp/bcapi011.p (input-output table tt-etq-item).

            find first tt-etq-item no-error.

            assign i-nr-etiquetas:screen-value = string(tt-etq-item.qt-etiqueta)
                   i-tp-etiqueta               = tt-etq-item.tipo-etiq.
        end.             
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rt-mold
&Scoped-define SELF-NAME movto-estoq.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.sc-codigo V-table-Win
ON ENTRY OF movto-estoq.sc-codigo IN FRAME f-main /* Centro Custo */
DO:
  assign self:format = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.sc-codigo V-table-Win
ON F5 OF movto-estoq.sc-codigo IN FRAME f-main /* Centro Custo */
DO:
    run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                        input "",                  /* CODIGO DO PLANO CCUSTO */
                                        input "",                  /* UNIDADE DE NEGOCIO */
                                        input today,               /* DATA DE TRANSACAO */
                                        output v_cod_ccusto,       /* CODIGO CCUSTO */
                                        output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                        output table tt_log_erro). /* ERROS */ 

   ASSIGN movto-estoq.sc-codigo:SCREEN-VALUE = v_cod_ccusto.
   ASSIGN c-titulo-ccusto:SCREEN-VALUE = v_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.sc-codigo V-table-Win
ON LEAVE OF movto-estoq.sc-codigo IN FRAME f-main /* Centro Custo */
DO:
    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN SELF:FORMAT = "x(20)".
        ASSIGN v_cod_ccusto = input frame {&frame-name} movto-estoq.sc-codigo.

        run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,       /* CCUSTO */
                                                   input  today,              /* DATA DE TRANSACAO */
                                                   output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */
        IF RETURN-VALUE = "OK" THEN DO:
            
            ASSIGN c-titulo-ccusto:SCREEN-VALUE = v_titulo_ccusto.
            
            /* Retorna formato do centro de custo */
            run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                           input  "",                 /* PLANO CCUSTO */
                                                           input  TODAY,              /* DATA DE TRANSACAO */
                                                           output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                           output table tt_log_erro). /* ERROS */
            if c-formato-ccusto <> "" then
                assign SELF:format = c-formato-ccusto.  
        END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.sc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.sc-codigo IN FRAME f-main /* Centro Custo */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.un V-table-Win
ON F5 OF movto-estoq.un IN FRAME f-main /* Unid Medid */
DO:
    {include/zoomvar.i
        &prog-zoom  = "inzoom/z01in417.w"
        &campo      = movto-estoq.un
        &campozoom  = un
        &campo2     = c-desc-tab
        &campozoom2 = descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.un V-table-Win
ON LEAVE OF movto-estoq.un IN FRAME f-main /* Unid Medid */
DO:
  {include/leave.i &tabela=tab-unidade
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-tab
                   &where="tab-unidade.un = input frame {&frame-name}
                           movto-estoq.un"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.un IN FRAME f-main /* Unid Medid */
DO:
  apply "f5" to self.
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
  run pi-traducao.

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

    disp today @ movto-estoq.dt-trans with frame {&frame-name}.

    find first param-estoq no-lock no-error.
    if not avail param-estoq then do:
        run utp/ut-msgs.p (input "show",
                           input 1059,
                           input "").
        return 'adm-error'.
    end.

    if avail param-estoq then do:        
        ASSIGN c-estabel-pad = IF l-seg-ativa-modulo THEN 
                                   IF CAN-FIND(tt_estab_ems2 WHERE tt_estab_ems2.tta_cod_estab = param-estoq.estabel-pad) THEN param-estoq.estabel-pad ELSE "":U       
                               ELSE param-estoq.estabel-pad
               c-cod-estabel-usuar = c-estabel-pad.                            

        /* Funcao Super/Minas */
        &IF DEFINED(Bf_dis_usuario_estab) &THEN
            IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                                  AND funcao.ativo     = YES) THEN DO:
                RUN cdp/cd8702.p (input c-seg-usuario,
                                  INPUT-OUTPUT c-cod-estabel-usuar).
            END.
        &ENDIF
        disp c-cod-estabel-usuar @ movto-estoq.cod-estabel with frame {&frame-name}.
         apply "leave" to movto-estoq.nro-docto in frame {&frame-name}. 
    end.
    
    assign movto-estoq.serie-docto:SCREEN-VALUE = input frame {&frame-name} movto-estoq.serie-docto.

  /* Code placed here will execute AFTER standard behavior.    */
  if l-repetiu then do with frame {&FRAME-NAME}:
      display dt-trans-rep @ movto-estoq.dt-trans
              c-docto-rep  @ movto-estoq.nro-docto
              c-serie-rep  @ movto-estoq.serie-docto
              c-conta-rep  @ movto-estoq.ct-codigo
              c-titulo-rep @ c-titulo-conta
              c-ccusto-rep @ movto-estoq.sc-codigo
              c-tit-cc-rep @ c-titulo-ccusto
              c-unid-medida @ movto-estoq.un.

      /* apply "ENTRY":U to movto-estoq.it-codigo:handle in frame {&FRAME-NAME}.
       nao ta avail */
  run pi-set-focus(movto-estoq.it-codigo:handle).
  end.

  ELSE
  ASSIGN movto-estoq.dt-trans:SCREEN-VALUE = string(today).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/
    /*--- Define se o estoque utiliza o conceito de deposito fechado/armazem geral (liberado na 12.1.28).
          Caso positivo, nao sera permitido movimentar o deposito marcado como externo por
          qualquer movimento que nao seja faturamento, recebimento, act ou DIV ---*/
    DEF VAR l-dep-fech-estoque  AS LOGICAL NO-UNDO.
    DEF VAR l-arm-geral-estoque AS LOGICAL NO-UNDO.
    
    IF NOT AVAIL param-estoq THEN
        FIND FIRST param-estoq NO-LOCK NO-ERROR.

    ASSIGN l-dep-fech-estoque  = IF SUBSTRING(param-estoq.char-2,116,1) = "S" THEN YES ELSE NO 
           l-arm-geral-estoque = IF SUBSTRING(param-estoq.char-2,115,1) = "S" THEN YES ELSE NO.

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e
    nem na PI-validate. */
    empty temp-table tt-movto.
    empty temp-table tt-erro.
    
    /* Efetua as validacoes necessarias -------------------------------------*/
    run pi-validate in this-procedure.

    if  return-value = "ADM-ERROR" then
        return "ADM-ERROR".

     IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
         RUN pi-validate-arg IN THIS-PROCEDURE.
         if  return-value = "ADM-ERROR" then
             return "ADM-ERROR".
     END.

     IF  l-control-aduana-internac THEN DO:

         RUN pi-validate-declar IN THIS-PROCEDURE.
         if  return-value = "ADM-ERROR" then
             return "ADM-ERROR".

         ASSIGN g-declar-control-aduana = c-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
     END.

    IF  input frame {&frame-name} movto-estoq.cod-depos = input frame {&FRAME-NAME} c-cod-depos-ent
    AND CAN-FIND(FIRST deposito
                 WHERE deposito.cod-depos = input frame {&frame-name} movto-estoq.cod-depos
                   AND deposito.ind-tipo-dep = 2 /* externo */)
    AND (l-dep-fech-estoque OR l-arm-geral-estoque)
    THEN DO:
        run utp/ut-msgs.p (input "show",
                           input 56963,
                           input "").
    END.

    do  with frame {&FRAME-NAME}:
        /* Gera a movimenta‡Æo de estoque -----------------------------------------*/
        run pi-gera-movimentacao.

        if  return-value = "ADM-ERROR" then
            undo, return "ADM-ERROR".

        find first tt-movto    where tt-movto.tipo-trans = 2                  no-lock no-error.
        find first movto-estoq where rowid(movto-estoq)  = tt-movto.r-mov-inv no-lock no-error.
        find first tt-movto    where tt-movto.tipo-trans = 1                  no-lock no-error.
        find b-movto-1         where rowid(b-movto-1)    = tt-movto.r-mov-inv no-lock no-error.

        /* Procura pelo saldo de Sa¡da --------------------------------------*/
        find first saldo-estoq no-lock 
            where saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
              and saldo-estoq.cod-refer   = input frame {&frame-name} movto-estoq.cod-refer
              and saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel
              and saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos
              and saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz
              and saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote no-error.

       &if '{&bf_mat_versao_ems}' >= '2.04' &then
            if not can-find(first item-uni-estab
                            where item-uni-estab.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
                              and item-uni-estab.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel) then do:
                run utp/ut-msgs.p (input "show",
                                   input 5101,
                                   input "").
                return 'adm-error'.
            end.
       &endif
       
       find first deposito no-lock
           where deposito.cod-depos = input frame {&frame-name} c-cod-depos-ent no-error.

       if  param-global.modulo-cq = yes
       and deposito.ind-dep-cq    = yes
       &IF '{&bf_mat_versao_ems}' < '2.04' &THEN 
           and item.contr-qualid 
       &else
           and item-uni-estab.contr-qualid 
       &endif then do:
           
           empty temp-table tt-ficha.

           create tt-ficha.
           assign tt-ficha.cod-depos    = input frame {&frame-name} c-cod-depos-ent
                  tt-ficha.cod-estabel  = input frame {&frame-name} c-cod-estabel-ent
                  tt-ficha.it-codigo    = input frame {&frame-name} movto-estoq.it-codigo
                  tt-ficha.cod-localiz  = input frame {&frame-name} c-cod-localiz-ent
                  tt-ficha.lote         = input frame {&frame-name} c-lote-ent
                  tt-ficha.nro-docto    = input frame {&frame-name} movto-estoq.nro-docto
                  tt-ficha.origem       = 2
                  tt-ficha.ct-destino   = input frame {&frame-name} movto-estoq.ct-codigo
                  tt-ficha.sc-destino   = input frame {&frame-name} movto-estoq.sc-codigo
                  tt-ficha.qt-original  = input frame {&frame-name} movto-estoq.quantidade
                  tt-ficha.serie-docto  = input frame {&frame-name} movto-estoq.serie-docto
                  tt-ficha.baixa-estoq  = yes.

           &if "{&bf_mat_versao_ems}" >= "2.04" &then
               assign tt-ficha.cod-refer = input frame {&frame-name} c-cod-refer-ent
                      tt-ficha.data-1    = input frame {&frame-name} movto-estoq.dt-trans.  /*tratamento para posterior gravacao no campo dt-ficha da tabela ficha-cq na cqapi001.*/
                
               run cqp/cqapi001.p  (input-output table tt-ficha,
                                    input-output table tt-erro,
                                    input-output i-ficha-cq,
                                    input-output i-operacao).
           &else
               run cqp/cq9050.p  (input-output table tt-ficha,
                                  input-output table tt-erro,
                                  input-output i-ficha-cq,
                                  input-output i-operacao).
           &endif

           find first tt-erro no-lock no-error.
           if  avail tt-erro then do:
               run cdp/cd0666.w (input table tt-erro).
               /* Este foi comentado pois os programa CQ9050.p s¢ retorna mensagens de advertˆncia, nÆo devendo retornar */
               /* return "ADM-ERROR".                                                                                    */
            end.
        end.

        /* GERA ETIQUETAS PARA O MODULO DE COLETA DE DADOS */
        if  avail param-global
        and param-global.modulo-cl then do:
            run utp/ut-acomp.p persistent set h-acomp.
            {utp/ut-liter.i Etiquetas MRE R}
            run pi-inicializar in h-acomp (input return-value).

            create tt-prog-bc.
            assign tt-prog-bc.cod-prog-dtsul        = "ce0206"
                   tt-prog-bc.cod-versao-integracao = 1
                   tt-prog-bc.usuario               = c-seg-usuario
                   tt-prog-bc.opcao                 = 1.

            run bcp/bcapi004.p (input-output table tt-prog-bc,
                                input-output table tt-erro).

            find first tt-prog-bc no-error.
            if  return-value = "OK" then do:
                {utp/ut-liter.i Gerando_Etiquetas  MRE R}
                run pi-acompanhar in h-acomp (input return-value).

                erro:
                do  on stop     undo erro,leave erro
                    on quit     undo erro,leave erro
                    on error    undo erro,leave erro
                    on endkey   undo erro,leave erro:

                    run value(tt-prog-bc.prog-criacao) (input        tt-prog-bc.cd-trans,
                                                        input        table tt-movto,
                                                        input        int(i-nr-etiquetas:screen-value),
                                                        input        i-tp-etiqueta,
                                                        input-output table tt-erro) no-error.

                    if  ERROR-STATUS:ERROR 
                    or  (    error-status:get-number(1) <> 138
                         and error-status:num-messages  <> 0) then do:
                        assign  i-erro-status = error-status:get-number(1).
                        {utp/ut-liter.i "Ocorreu Erro Progress na Gera‡Æo de Etiquetas:" MRE R}
                        create  tt-erro.
                        assign  tt-erro.i-sequen    = 1
                                tt-erro.cd-erro     = i-erro-status
                                tt-erro.mensagem    = trim(return-value) + string(i-erro-status).
                    end.

                    if  return-value = "NOK" then do:
                        assign  i-erro-status = error-status:get-number(1).
                        {utp/ut-liter.i "Ocorreu Erro Progress na Gera‡Æo de Etiquetas:" MRE R}
                        create  tt-erro.
                        assign  tt-erro.i-sequen    = 1
                                tt-erro.cd-erro     = i-erro-status
                                tt-erro.mensagem    = trim(return-value) + string(i-erro-status).
                    end.
                end.
            end.
            else do:
                /**** caso tenha integra‡Æo com o coleta e ocorreu erros ***/
                find first tt-erro no-error.
                if  avail tt-erro then do:
                    {utp/ut-liter.i "Ocorreu Erro Progress na Gera‡Æo de Etiquetas:" MRE R}
                    create  tt-erro.
                    assign  tt-erro.i-sequen    = 1
                            tt-erro.cd-erro     = error-status:get-number(1)
                            tt-erro.mensagem    = trim(return-value) + string(error-status:get-number(1)).

                end.
            end.
            run pi-finalizar in h-acomp.

            find first tt-erro no-lock no-error.
            if  avail tt-erro THEN
                run cdp/cd0666.w (input table tt-erro).

        end.
        /*************************************************/

        empty temp-table tt-movto.
        empty temp-table tt-erro.

        /* Guarda os dados para proxima inclusao ---------------------------------*/
        assign l-repetiu        = yes
               dt-trans-rep     = input frame {&frame-name} movto-estoq.dt-trans
               c-docto-rep      = input frame {&frame-name} movto-estoq.nro-docto
               c-serie-rep      = input frame {&frame-name} movto-estoq.serie-docto
               c-conta-rep      = input frame {&frame-name} movto-estoq.ct-codigo
               c-titulo-rep     = input frame {&frame-name} c-titulo-conta
               c-ccusto-rep     = input frame {&frame-name} movto-estoq.sc-codigo
               c-tit-cc-rep     = input frame {&frame-name} c-titulo-ccusto
               c-unid-medida    = input frame {&frame-name} movto-estoq.un.
    end.

    IF  l-control-aduana-internac THEN
        ASSIGN g-declar-control-aduana = "".

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
  assign l-primeira = yes.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  clear frame {&frame-name}.
  assign l-repetiu = no.
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

    IF  VALID-HANDLE(h-boar202155) THEN RUN destroy IN h-boar202155.
    IF  VALID-HANDLE(h-boin01067)  THEN RUN destroy IN h-boin01067.

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
  disable all with frame {&frame-name}.

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  disable i-nr-etiquetas with frame {&FRAME-NAME}.
  
    IF (i-pais-impto-usuario = 2 /* Argentina */
    AND CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-cod-despacho-plaza":U AND funcao.ativo))
    OR  l-control-aduana-internac THEN
        ASSIGN c-despacho:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
  if l-primeira then do:
     RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
     assign l-primeira = no.
  end.

  assign movto-estoq.cod-estabel:screen-value in frame {&frame-name} = c-estabel-pad
         movto-estoq.dt-trans:screen-value in frame {&frame-name}    = string(today).

  find estabelec where
           estabelec.cod-estabel = c-estabel-pad no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec.  

  /* Retorna formato da conta contabil */
  run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                     input  "",                 /* PLANO CONTAS */
                                                     input  TODAY,              /* DATA DE TRANSACAO */
                                                     output c-formato-conta,    /* FORMATO CONTA */
                                                     output table tt_log_erro). /* ERROS */
  /* Retorna formato do centro de custo */
  run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* PLANO CCUSTO */
                                                 input  TODAY,              /* DATA DE TRANSACAO */
                                                 output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */
  if c-formato-conta <> "" then
     assign movto-estoq.ct-codigo:format in frame {&FRAME-NAME} = c-formato-conta.
  if c-formato-ccusto <> "" then
     assign movto-estoq.sc-codigo:format in frame {&FRAME-NAME} = c-formato-ccusto.  
  /* Code placed here will execute AFTER standard behavior.    */
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
  assign movto-estoq.dt-trans:screen-value in frame {&frame-name} = return-value.
  
  if  avail param-global
  and param-global.modulo-cl then
      enable i-nr-etiquetas with frame {&FRAME-NAME}.

  IF  i-pais-impto-usuario = 2 /* Argentina */
  AND CAN-FIND(FIRST funcao 
               WHERE funcao.cd-funcao = "spp-cod-despacho-plaza":U AND funcao.ativo) THEN
      ASSIGN c-despacho:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  ELSE 
      ASSIGN c-despacho:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/
  {include/i-valid.i}
  /* Code placed here will execute PRIOR to standard behavior. */
  find first param-global no-lock no-error.
  if not avail param-global then do:
     run utp/ut-msgs.p (input "show":u,
                        input 16,
                        input return-value).
     return 'ADM-ERROR':U.
  end.

  find first param-estoq no-lock no-error.
  if  avail param-estoq then
      ASSIGN c-estabel-pad = IF l-seg-ativa-modulo THEN 
                                 IF CAN-FIND(tt_estab_ems2 WHERE tt_estab_ems2.tta_cod_estab = param-estoq.estabel-pad) THEN param-estoq.estabel-pad ELSE "":U       
                             ELSE param-estoq.estabel-pad  
             c-estabelec = c-estabel-pad.  

  
  find estabelec where
           estabelec.cod-estabel = c-estabelec no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec.  

  find first empresa where empresa.ep-codigo = i-empresa no-lock no-error.
  find first param-cq no-lock no-error.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
  if can-find(first funcao where funcao.cd-funcao = "lote-avancado":u and
                                 funcao.ativo) then do:
      assign l-lote-avancado = yes.

      run Who-Is-The-Container in adm-broker-hdl (input this-procedure, 
                                                  output h-handle).

      run pi-retorna-lote-avancado in h-handle (output h-ceapi030).
  end.
&endif

    IF (i-pais-impto-usuario = 2 /* Argentina */
    AND CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-cod-despacho-plaza":U AND funcao.ativo))
    OR  l-control-aduana-internac THEN DO:
        ASSIGN c-despacho:HIDDEN IN FRAME {&FRAME-NAME} = NO.

        IF  l-control-aduana-internac THEN DO:
            {utp/ut-liter.i Declara‡Æo_Importa‡Æo *}
            ASSIGN c-despacho:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

            IF  NOT VALID-HANDLE(h-boin01067) THEN
                RUN inbo/boin01067.p PERSISTENT SET h-boin01067.
        END.
    END.
    ELSE 
        ASSIGN c-despacho:HIDDEN IN FRAME {&FRAME-NAME} = YES.

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
    if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
    
    /* Ponha aqui a valida‡Æo de chave duplicada */
    
    /* Ponha aqui as demais valida‡äes */    
    
    /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
    
    DO TRANSACTION ON STOP  UNDO, RETURN "ADM-ERROR":U
                   ON ERROR UNDO, RETURN "ADM-ERROR":U :

        /* Dispatch standard ADM method.                             */
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
        
        IF RETURN-VALUE = "ADM-ERROR":U OR
           RETURN-VALUE = "ERROR":U OR
           RETURN-VALUE = "ERRO-EPC":U OR
           RETURN-VALUE = "NOK":U THEN DO:
            RETURN "ADM-ERROR":U.
        END.

    END. 

    IF NOT TRANSACTION THEN DO:

        /* EPC - End-update da Viewer */ 
        &IF  DEFINED(adm-viewer) <> 0 &THEN   
           {include/i-epc010.i}
        &ENDIF
        
        /* EPC - After End-update da Viewer */ 
        &IF  DEFINED(adm-viewer) <> 0 &THEN   
           {include/i-epc027.i}
        &ENDIF 

    END.                        
    
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-despacho V-table-Win 
PROCEDURE pi-despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  i-pais-impto-usuario = 2 /* Argentina */
    AND CAN-FIND(FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-cod-despacho-plaza" AND funcao.ativo) THEN DO:

        IF  NOT VALID-HANDLE(h-boar202155) THEN
            RUN local/arg/boar202155.p PERSISTENT SET h-boar202155.

        RUN pi-despacho IN h-boar202155 (INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel,
                                         INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-depos,
                                         INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-localiz,
                                         INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.it-codigo,
                                         INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-refer,
                                         INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.lote,
                                         OUTPUT c-despacho,
                                         OUTPUT rw-saldo,
                                         OUTPUT l-habilita).
    END.

    IF  l-control-aduana-internac THEN DO:

        RUN retornaSdoDisponDeclar IN h-boin01067 (INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel,
                                                   INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-depos,
                                                   INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-localiz,
                                                   INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.it-codigo,
                                                   INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-refer,
                                                   INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.lote,
                                                   OUTPUT c-despacho,
                                                   OUTPUT l-habilita).
    END.

    IF  l-habilita = NO THEN
        ASSIGN c-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-despacho
               c-despacho:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    ELSE
        ASSIGN c-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               c-despacho:SENSITIVE    IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-movimentacao V-table-Win 
PROCEDURE pi-gera-movimentacao :
/*------------------------------------------------------------------------------
  Purpose: Gera a movimenta‡Æo de Estoque
  Parameters:  <none>
  Notes: Executar depois de todas as valida‡äes j  efetuadas
         Retorna "ADM-ERROR" se algum erro retornar da API
------------------------------------------------------------------------------*/

do transaction with frame {&FRAME-NAME}:

    /**************************Sa¡da********************************/

    find estabelec where
             estabelec.cod-estabel = c-estabelec no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec. 

    create tt-movto.
    assign tt-movto.cod-versao-integracao  = 1
           tt-movto.cod-prog-orig          = "CE0206"
           tt-movto.tipo-trans             = 2
           tt-movto.esp-docto              = 33
           tt-movto.ct-codigo              = input frame {&frame-name} movto-estoq.ct-codigo
           tt-movto.dt-trans               = input frame {&FRAME-NAME} movto-estoq.dt-trans
           tt-movto.dt-vali-lote           = input frame {&FRAME-NAME} da-dt-vali-lote-sai
           tt-movto.nro-docto              = input frame {&FRAME-NAME} movto-estoq.nro-docto
           tt-movto.sc-codigo              = input frame {&FRAME-NAME} movto-estoq.sc-codigo
           tt-movto.serie-docto            = input frame {&FRAME-NAME} movto-estoq.serie-docto
           tt-movto.cod-depos              = input frame {&FRAME-NAME} movto-estoq.cod-depos
           tt-movto.cod-estabel            = input frame {&FRAME-NAME} movto-estoq.cod-estabel
           tt-movto.it-codigo              = item.it-codigo
           tt-movto.cod-refer              = input frame {&FRAME-NAME} movto-estoq.cod-refer
           tt-movto.cod-localiz            = input frame {&FRAME-NAME} movto-estoq.cod-localiz
           tt-movto.lote                   = input frame {&FRAME-NAME} movto-estoq.lote
           tt-movto.quantidade             = input frame {&FRAME-NAME} movto-estoq.quantidade
           tt-movto.un                     = input frame {&FRAME-NAME} movto-estoq.un
           tt-movto.usuario                = c-seg-usuario.

    /* Ticket: 9149636 - DMANESTOQ-7999 - armazenar o c¢digo do dep¢sito original e permitir 
       realizar TRA em dep¢sitos externos quando alterar apenas a localiza‡Æo ou lote. */
    ASSIGN g-cod-depos-aux = input frame {&FRAME-NAME} c-cod-depos-ent.

    /*** Seta Unidade de Neg¢cio ***/
    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        IF  l-unidade-negocio
        AND l-mat-unid-negoc THEN DO:
            run cdp/cdapi024.p persistent set h-cdapi024.
            if  valid-handle(h-cdapi024) then do:
                run retornaUnidadeNegocio IN h-cdapi024 (input tt-movto.cod-estabel,
                                                         input tt-movto.it-codigo,
                                                         input tt-movto.cod-depos,
                                                         output tt-movto.cod-unid-negoc).

                delete procedure h-cdapi024.
                assign h-cdapi024 = ?.
            end.

            ASSIGN c-unid-negoc = tt-movto.cod-unid-negoc.
        end.
        ELSE
            ASSIGN c-unid-negoc = "".
    &ENDIF

    /**************************entrada***************************/
    
    find estabelec where
             estabelec.cod-estabel = c-estabelec no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec. 

    assign da-data-aux = input frame {&frame-name} da-dt-vali-lote-ent.

    create tt-movto.
    assign tt-movto.cod-versao-integracao = 1
           tt-movto.ct-codigo             = input frame {&FRAME-NAME} movto-estoq.ct-codigo
           tt-movto.cod-prog-orig         = "CE0206"
           tt-movto.dt-trans              = input frame {&FRAME-NAME} movto-estoq.dt-trans
           tt-movto.dt-vali-lote          = input frame {&FRAME-NAME} da-dt-vali-lote-ent
           tt-movto.nro-docto             = input frame {&FRAME-NAME} movto-estoq.nro-docto
           tt-movto.sc-codigo             = input frame {&FRAME-NAME} movto-estoq.sc-codigo
           tt-movto.serie-docto           = input frame {&FRAME-NAME} movto-estoq.serie-docto
           tt-movto.cod-depos             = input frame {&FRAME-NAME} c-cod-depos-ent
           tt-movto.cod-estabel           = input frame {&FRAME-NAME} c-cod-estabel-ent
           tt-movto.it-codigo             = item.it-codigo
           tt-movto.cod-refer             = input frame {&FRAME-NAME} c-cod-refer-ent
           tt-movto.cod-localiz           = input frame {&FRAME-NAME} c-cod-localiz-ent
           tt-movto.lote                  = input frame {&FRAME-NAME} c-lote-ent
           tt-movto.quantidade            = input frame {&FRAME-NAME} movto-estoq.quantidade
           tt-movto.un                    = input frame {&FRAME-NAME} movto-estoq.un
           tt-movto.tipo-trans            = 1
           tt-movto.esp-docto             = 33
           &if "{&bf_mat_versao_ems}" >= "2.062" &then
           tt-movto.cod-unid-negoc        = IF  l-unidade-negocio AND l-mat-unid-negoc THEN c-unid-negoc ELSE ""
           &ENDIF
           tt-movto.usuario               = c-seg-usuario.

    /* Ticket: 9149636 - DMANESTOQ-7999 - armazenar o c¢digo do dep¢sito original e permitir 
       realizar TRA em dep¢sitos externos quando alterar apenas a localiza‡Æo ou lote. */
    ASSIGN g-cod-depos-aux = input frame {&FRAME-NAME} movto-estoq.cod-depos.

    /*** Seta Unidade de Neg¢cio ***/
    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        IF  l-unidade-negocio
        AND l-mat-unid-negoc THEN DO:
            run cdp/cdapi024.p persistent set h-cdapi024.
            if  valid-handle(h-cdapi024) then do:
                run retornaUnidadeNegocio IN h-cdapi024 (input tt-movto.cod-estabel,
                                                         input tt-movto.it-codigo,
                                                         input tt-movto.cod-depos,
                                                         output tt-movto.cod-unid-negoc).

                delete procedure h-cdapi024.
                assign h-cdapi024 = ?.
            end.

            ASSIGN c-unid-negoc = tt-movto.cod-unid-negoc.
        end.
        ELSE
            ASSIGN c-unid-negoc = "".
    &ENDIF

    ASSIGN gr-argext-sdo-estoq = rw-saldo.

    /* Efetua a atualizacao de Estoque ---------------------------------------*/
    find first saldo-estoq exclusive-lock
        where saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
          and saldo-estoq.cod-estabel = input frame {&FRAME-NAME} movto-estoq.cod-estabel
          and saldo-estoq.cod-depos   = input frame {&FRAME-NAME} movto-estoq.cod-depos
          and saldo-estoq.cod-localiz = input frame {&FRAME-NAME} movto-estoq.cod-localiz
          and saldo-estoq.lote        = input frame {&FRAME-NAME} movto-estoq.lote
          and saldo-estoq.cod-refer   = input frame {&FRAME-NAME} movto-estoq.cod-refer no-error.
    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        run cep/ceapi001k.p persistent set h-ceapi001k.
        if  valid-handle (h-ceapi001k) then do:
            run pi-execute IN h-ceapi001k (input-output table tt-movto,
                                           input-output table tt-erro, 
                                           input        yes).

            delete procedure h-ceapi001k.
            assign h-ceapi001k = ?.
        end.
    &ELSE
        run cep/ceapi001.p (input-output table tt-movto,
                            input-output table tt-erro, 
                            input        YES).
    &ENDIF
    if avail saldo-estoq then
        release saldo-estoq.

    find first tt-erro no-lock no-error.
    if avail tt-erro 
        or  return-value = "NOK":U then do:
        run cdp/cd0666.w (input table tt-erro).
        apply "entry" to movto-estoq.it-codigo.
        undo, return 'ADM-ERROR':U.
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-c-cod-refer V-table-Win 
PROCEDURE pi-leave-c-cod-refer :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

if  avail param-estoq 
and substring(param-estoq.char-2,1,1) = "#" then do with frame {&frame-name}:
    if input frame {&frame-name} c-cod-refer-ent = "" then
        find first saldo-estoq no-lock 
              where saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
                and saldo-estoq.lote        = input frame {&frame-name} c-lote-ent
                and saldo-estoq.cod-depos   = input frame {&frame-name} c-cod-depos-ent
                and saldo-estoq.cod-localiz = input frame {&frame-name} c-cod-localiz-ent
                and saldo-estoq.cod-estabel = input frame {&frame-name} c-cod-estabel-ent no-error.
    else
        find first saldo-estoq no-lock 
              where saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
                and saldo-estoq.lote        = input frame {&frame-name} c-lote-ent
                and saldo-estoq.cod-depos   = input frame {&frame-name} c-cod-depos-ent
                and saldo-estoq.cod-localiz = input frame {&frame-name} c-cod-localiz-ent
                and saldo-estoq.cod-estabel = input frame {&frame-name} c-cod-estabel-ent
                and saldo-estoq.cod-refer   = input frame {&frame-name} c-cod-refer-ent no-error.
    if  avail saldo-estoq then do:
        disp saldo-estoq.dt-vali-lote @ da-dt-vali-lote-ent.
        disable da-dt-vali-lote-ent.
    end.
    else do:
        if input frame {&frame-name} c-lote-ent = input frame {&frame-name} movto-estoq.lote then do:
            disable da-dt-vali-lote-ent.
            assign da-dt-vali-lote-ent = input frame {&frame-name} da-dt-vali-lote-sai.
            display da-dt-vali-lote-ent.
        end.
        else
            enable da-dt-vali-lote-ent.
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-cod-refer V-table-Win 
PROCEDURE pi-leave-cod-refer :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

assign c-cod-refer-ent:screen-value in frame {&frame-name} = input frame {&frame-name} movto-estoq.cod-refer.

if  avail param-estoq 
and substring(param-estoq.char-2,1,1) = "#" then do with frame {&frame-name}:
    find first saldo-estoq no-lock 
        where saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
          and saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote
          and saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos
          and saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz
          and saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel 
          and saldo-estoq.cod-refer   = input frame {&frame-name} movto-estoq.cod-refer no-error.
    if  avail saldo-estoq then do:
        disp saldo-estoq.dt-vali-lote @ da-dt-vali-lote-sai.
        disable da-dt-vali-lote-sai.
    end.
    else
        enable da-dt-vali-lote-sai.
end.
RUN pi-despacho.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-set-focus V-table-Win 
PROCEDURE pi-set-focus :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    define input param hdl-alvo as handle  no-undo.

    define variable hdl-inicial as handle  no-undo.
    define variable hdl-proximo as handle  no-undo.
    define variable hdl-atual   as handle  no-undo.

    assign hdl-atual   = focus.

    repeat: 
    /* Verifica se retornou para o primeiro campo ------------------------*/
    if hdl-atual = hdl-inicial then
        leave.
    /* Se hdl-inicial for nulo, inicializa a variavel --------------------*/
    if not valid-handle(hdl-inicial) then
        ASSIGN hdl-inicial = hdl-atual.
    /* Se o widget atual for o widget-alvo, entao retorna ----------------*/
    if hdl-atual = hdl-alvo then
        leave.
    /* Se o campo atual estiver sensitive, aplica o evento de saida ------*/
    if hdl-atual:sensitive = YES then
        apply "leave" to hdl-atual.
    /* Troca o foco para o proximo campo ---------------------------------*/
    ASSIGN hdl-atual = hdl-atual:next-tab-item.
    if hdl-atual:SENSITIVE = YES then
        apply "entry" to hdl-atual.
    end. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-traducao V-table-Win 
PROCEDURE pi-traducao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  do  with frame {&FRAME-NAME}:
      {utp/ut-liter.i "Referˆncia_Sa¡da" * L}
      assign movto-estoq.cod-refer:label = trim(return-value).
      {utp/ut-liter.i "Referˆncia_Entrada" * L}
      assign c-cod-refer-ent:label = trim(return-value).
      {utp/ut-liter.i "Val_Lote" * L}
      assign da-dt-vali-lote-ent:label = trim(return-value).
             da-dt-vali-lote-sai:label = trim(return-value).
      {utp/ut-liter.i "Estabelecimento_PadrÆo" * L}
      assign movto-estoq.cod-estabel:label = trim(return-value).
      {utp/ut-liter.i "Dep¢sito_Sa¡da" * L}
      assign movto-estoq.cod-depos:label = trim(return-value).
      {utp/ut-liter.i "Estabelecimento_Entrada" * L}
      assign c-cod-estabel-ent:label = trim(return-value).
      {utp/ut-liter.i "Dep¢sito_Entrada" * L}
      assign c-cod-depos-ent:label = trim(return-value).
      {utp/ut-liter.i "Localiza‡Æo_Sa¡da" * L}
      assign movto-estoq.cod-localiz:label = trim(return-value).
      {utp/ut-liter.i "Localiza‡Æo_Entrada" * L}
      assign c-cod-localiz-ent:label = trim(return-value).
      {utp/ut-liter.i "Lote_Entrada" * L}
      assign c-lote-ent:label = TRIM(return-value).
      {utp/ut-liter.i "Lote_Sa¡da" * L}
      assign movto-estoq.lote:label = trim(return-value).
      {utp/ut-liter.i "S‚rie" * L}
      assign movto-estoq.serie-docto:label = trim(return-value).
      {utp/ut-liter.i "Conta"}
      assign movto-estoq.ct-codigo:label = trim(return-value).
      {utp/ut-liter.i "Centro_Custo"}
      assign movto-estoq.sc-codigo:label = trim(return-value).      
      {utp/ut-liter.i "Qt.Etiquetas" * R}
      assign i-nr-etiquetas:label     in frame {&FRAME-NAME} = trim(return-value).

      if movto-estoq.it-codigo:load-mouse-pointer ("image/lupa.cur")      then.
      if movto-estoq.cod-refer:load-mouse-pointer ("image~\rbm.cur")      then.
      if movto-estoq.cod-estabel:load-mouse-pointer ("image/lupa.cur")    then.
      if movto-estoq.cod-depos:load-mouse-pointer ("image~\rbm.cur")      then.
      if movto-estoq.cod-localiz:load-mouse-pointer ("image~\rbm.cur")    then.
      if movto-estoq.un:load-mouse-pointer ("image/lupa.cur")             then.
      if movto-estoq.ct-codigo:load-mouse-pointer ("image/lupa.cur")      then.
      if movto-estoq.sc-codigo:load-mouse-pointer ("image/lupa.cur")      then.
      if movto-estoq.lote:load-mouse-pointer ("image/lupa.cur")           then.
      if c-cod-refer-ent:load-mouse-pointer ("image~\rbm.cur")            then.
      if c-cod-estabel-ent:load-mouse-pointer ("image/lupa.cur")          then.
      if c-cod-depos-ent:load-mouse-pointer ("image~\rbm.cur")            then.
      if c-cod-localiz-ent:load-mouse-pointer ("image~\rbm.cur")          then.
      if c-lote-ent:load-mouse-pointer ("image/lupa.cur")                 then.
      if c-despacho:load-mouse-pointer ("image/lupa.cur")                 then.
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-dep-localiz-ent V-table-Win 
PROCEDURE pi-trata-dep-localiz-ent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
        RUN cep/ceapi014.p (input input frame {&frame-name} movto-estoq.it-codigo,
                            INPUT INPUT FRAME {&FRAME-NAME} c-cod-estabel-ent,
                            OUTPUT c-cod-depos,
                            OUTPUT c-cod-localiz,
                            OUTPUT l-loc-unica).
    
        assign c-cod-localiz-ent:screen-value in frame {&frame-name} = c-cod-localiz.
    
        if  l-loc-unica then
            disable c-cod-localiz-ent with frame {&frame-name}.
        else
            enable c-cod-localiz-ent  with frame {&frame-name}.
    
        APPLY "LEAVE":U TO c-cod-localiz-ent IN FRAME {&FRAME-NAME}.
    &ENDIF

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-dep-localiz-sai V-table-Win 
PROCEDURE pi-trata-dep-localiz-sai :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
        RUN cep/ceapi014.p (input input frame {&frame-name} movto-estoq.it-codigo,
                            INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel,
                            OUTPUT c-cod-depos,
                            OUTPUT c-cod-localiz,
                            OUTPUT l-loc-unica).
    
        assign movto-estoq.cod-depos:screen-value   in frame {&frame-name} = c-cod-depos
               movto-estoq.cod-localiz:screen-value in frame {&frame-name} = c-cod-localiz.
    
        if  l-loc-unica then
            disable movto-estoq.cod-localiz with frame {&frame-name}.
        else
            enable movto-estoq.cod-localiz  with frame {&frame-name}.
    
        APPLY "LEAVE":U TO movto-estoq.cod-depos   IN FRAME {&FRAME-NAME}.
        APPLY "LEAVE":U TO movto-estoq.cod-localiz IN FRAME {&FRAME-NAME}.
    &ENDIF
    
    RETURN "OK":U.

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
    define variable h-erro    as handle                                 no-undo.
    define variable de-qtidade like saldo-estoq.qtidade-atu             no-undo.

    &SCOPED-DEFINE retorna-erro apply "entry" to h-erro.     ~
                                return "ADM-ERROR":U.

    do with frame {&FRAME-NAME}:

        /* Valida se quantidade ‚ diferente de 0 -----------------------------------*/
        h-erro = movto-estoq.quantidade:handle.

        if input frame {&frame-name} movto-estoq.quantidade = 0 then do:
            {utp/ut-field.i mgind movto-estoq quantidade 1}
            run utp/ut-msgs.p (input "show":u,
                               input 36,
                               input trim(return-value)).
            {&retorna-erro}
        end.

        /* Valida‡äes sobre o item ------------------------------------------------*/
        h-erro = movto-estoq.it-codigo:handle.

        find item where item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo
            no-lock no-error.

        if  not avail item then do:
            run utp/ut-msgs.p (input "show":u,
                               input 166,
                               input "").
            {&retorna-erro}
        end.

        if item.tipo-contr = 4 then do:
            run utp/ut-msgs.p (input "show":u,
                               input 1673,
                               input "").
            {&retorna-erro}
        end.

       &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN 
            FIND FIRST item-uni-estab
                 WHERE item-uni-estab.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
                 AND   item-uni-estab.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel NO-LOCK NO-ERROR.
    
            if not avail item-uni-estab then do:
                 run utp/ut-msgs.p (input "show",
                                    input 5101,
                                    input "").
                return 'ADM-ERROR':U.
             END.
        &endif
        
        /* Valida‡äes sobre Estabelecimento de Entrada ----------------------------*/
        h-erro = c-cod-estabel-ent:handle.

        find estabelec where estabelec.cod-estabel = input frame {&frame-name} c-cod-estabel-ent
            no-lock no-error.
        if not avail estabelec then do:
            run utp/ut-msgs.p (input "show":u,
                               input 537,
                               input "").
            {&retorna-erro}
        end.

        if input frame {&frame-name} movto-estoq.cod-estabel <>
           input frame {&frame-name} c-cod-estabel-ent       then do:
            {utp/ut-field.i mgadm estabelec cod-estabel 1}
            run utp/ut-msgs.p (input "show":u,
                               input  9017,
                               input trim(return-value) +
                                     c-cod-estabel-ent:screen-value + "~~" +
                                     trim(return-value) +
                                     movto-estoq.cod-estabel:screen-value).
            {&retorna-erro}
        end.

        /* Valida‡äes sobre a data de Transa‡Æo -----------------------------------*/
        h-erro = movto-estoq.dt-trans:handle.
        if input frame {&frame-name} movto-estoq.dt-trans > today then do:
            run utp/ut-msgs.p (input "show":u,
                               input 1788,
                               input "").
            apply "entry" to movto-estoq.dt-trans.
            return 'ADM-ERROR':U.
        end.

        /* Valida‡äes sobre o n£mero do documento ---------------------------------*/
        for first b-movto field (serie-docto nro-docto esp-docto)
            where b-movto.serie-docto = input frame {&frame-name} movto-estoq.serie-docto
              and b-movto.nro-docto   = input frame {&frame-name} movto-estoq.nro-docto
              and b-movto.esp-docto   = 33
            no-lock: end.

        if avail b-movto then do:
            run utp/ut-msgs.p (input "show":u,
                               input 2628,
                               input "").

        end.

        /* Valida‡Æo sobre a conta cont bil ---------------------------------------*/
        h-erro = movto-estoq.ct-codigo:handle.

        
                IF (c-estabelec = "") THEN DO: /* --- F.O.: 1676.460 --- */
                          find first param-estoq no-lock no-error.
                          if  avail param-estoq then
                              ASSIGN c-estabel-pad = IF l-seg-ativa-modulo THEN 
                                                         IF CAN-FIND(tt_estab_ems2 WHERE tt_estab_ems2.tta_cod_estab = param-estoq.estabel-pad) THEN param-estoq.estabel-pad ELSE "":U       
                                                     ELSE param-estoq.estabel-pad
                                     c-estabelec = c-estabel-pad.
                END.
                find estabelec where
                     estabelec.cod-estabel = c-estabelec no-lock no-error.
                assign i-empresa = estabelec.ep-codigo when avail estabelec. 
        
&IF "{&mguni_version}" >= "2.071" &THEN
        IF i-empresa = "" THEN /* --- F.O.: 1676.460 --- */
&ELSE
        IF i-empresa = 0 THEN /* --- F.O.: 1676.460 --- */
&ENDIF
            
            
        /* Busca dados da conta cont bil */
        ASSIGN v_cod_cta_ctbl = input frame {&frame-name} movto-estoq.ct-codigo.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                       input        "",                 /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,     /* CONTA */
                                                       input        movto-estoq.dt-trans:screen-value, /* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl, /* SITUA›øO DA CONTA */
                                                       output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).             
        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
             run utp/ut-msgs.p (input "show":u,
                               input 17006,
                               STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
            {&retorna-erro}           
        end.
        if v_titulo_cta_ctbl = "" then do:
            run utp/ut-msgs.p (input "show":u,
                               input 1781,
                               input "").
            {&retorna-erro}
        end.

        if v_num_sit_cta_ctbl <> 3 then do:
            run utp/ut-msgs.p (input "show":u,
                               input 443,
                              input "").
            {&retorna-erro}
        end.

        if v_ind_finalid_cta = "" /* conta -contab.estoque = 0 */ then do:
            run utp/ut-msgs.p (input "show":u,
                               input 445,
                               input "").
            {&retorna-erro}
        end.

        if lookup({adinc/i05ad049.i 4 9}, v_ind_finalid_cta) <> 0 then do:
            run utp/ut-msgs.p (input "show":u,
                               input 1784,
                               input "").
            {&retorna-erro}
        end.

        /* if not can-do("4",string(conta -contab.estoque)) then do: */
/*         if not can-do({adinc/i05ad049.i 4 4}, v_ind_finalid_cta) then do: */
        assign i-fim = 0.
        assign i-fim = index(v_ind_finalid_cta,"Transferˆncia").
        if i-fim     = 0 then do:
            run utp/ut-msgs.p (input "show":u,
                               input 439,
                               input "").
            {&retorna-erro}
        end.

        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  movto-estoq.dt-trans:screen-value, /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            /* Busca dados do centro de custo */
            h-erro = movto-estoq.sc-codigo:handle.
            ASSIGN v_cod_ccusto = input frame {&frame-name} movto-estoq.sc-codigo.
            run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                       input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                       input  v_cod_ccusto,       /* CCUSTO */
                                                       input  movto-estoq.dt-trans:screen-value, /* DATA DE TRANSACAO */
                                                       output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                       output table tt_log_erro). /* ERROS */
                                                     
            find first tt_log_erro no-lock no-error.
            if avail tt_log_erro then do:
               run utp/ut-msgs.p (input "show":U,
                                  input 17006,
                                  STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
               {&retorna-erro}      
            end.
        END.

        /* Valida Deposito de Saida -----------------------------------------------*/
        h-erro = movto-estoq.cod-depos:handle.

        find deposito where deposito.cod-depos = input frame {&frame-name} movto-estoq.cod-depos
             no-lock no-error.

        if not avail deposito then do:
           run utp/ut-msgs.p (input "show":u,
                              input 530,
                              input "").
           {&retorna-erro}
        end.

        if deposito.ind-dep-cq = yes 
            &IF '{&bf_mat_versao_ems}' < '2.04' &THEN 
                and item.contr-qualid 
            &else
                and item-uni-estab.contr-qualid 
            &endif then do:
            
            run utp/ut-msgs.p (input "show":u,
                               input 755,
                               input "").
            {&retorna-erro}
        end.

        if  deposito.ind-dep-rej = yes 
            &IF '{&bf_mat_versao_ems}' < '2.04' &THEN 
                and item.contr-qualid 
            &else
                and item-uni-estab.contr-qualid 
            &endif then do:
            run utp/ut-msgs.p (input "show":u,
                              input 755,
                              input "").
            {&retorna-erro}
        end.

        assign i-ind-tipo-dep-saida = deposito.ind-tipo-dep.

/*         Valida Localiza‡Æo de Saida -------------------------------------------- 
        h-erro = movto-estoq.cod-localiz:handle.
        find localizacao where 
             localizacao.cod-estabel = input movto-estoq.cod-estabel and 
             localizacao.cod-depos   = input movto-estoq.cod-depos   and 
             localizacao.cod-localiz = input movto-estoq.cod-localiz
             no-lock no-error.

        if not available localizacao then do:
            {utp/ut-table.i mgind localizacao 1}
            run utp/ut-msgs.p (input "show",
                               input 56,
                               input return-value). 
            {&retorna-erro}
        end.*/
        
        /* Valida Deposito de Entrada ---------------------------------------------*/
        h-erro = c-cod-depos-ent:handle.
        find deposito where deposito.cod-depos = input frame {&frame-name} c-cod-depos-ent
              no-lock no-error.

        if not avail deposito then do:
           run utp/ut-msgs.p (input "show":u,
                              input 530,
                              input "").
            {&retorna-erro}
        end.
        else do:
            if deposito.ind-dep-rej = yes 
               &IF '{&bf_mat_versao_ems}' < '2.04' &THEN 
                    and item.contr-qualid 
                &else
                    and item-uni-estab.contr-qualid 
                &endif then do:
                
                run utp/ut-msgs.p (input "show":u,
                              input 2403,
                              input "").
                {&retorna-erro}
            end.

            /* Implementa‡Æo para a Grendene. O c¢digo abaixo ir  verificar
               se est ÿdispon¡vel a fun‡Æo de "Dep¢sito de Terceiros" para que 
               possa ser transferido materiais entre dep¢sitos de tipos diferentes. */

            if can-find(funcao no-lock where funcao.cd-funcao = "cep_depos_terc") and 
               deposito.ind-tipo-dep <> i-ind-tipo-dep-saida then do:
                run utp/ut-msgs.p (input "show":u,
                              input 26536, /* Dep¢sitos origem/destino deve ser do mesmo tipo */
                              input "").
                {&retorna-erro}
            end.        
        end.



           /*inicio valiadcao da integracao EMX x HIS*/
            &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
            
                IF CAN-FIND (FIRST funcao 
                             WHERE funcao.cd-funcao = "spp-integra-ems-his"
                             AND   funcao.ativo     = YES) THEN DO:
    
                    /*inicio - Valida Deposito de Entrada*/
                    &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
                        IF (deposito.log-orig-ext) AND 
                            deposito.ind-dep-cq = NO THEN DO:
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-deposito-de-entrada-nao-pode-s AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Dep¢sito_de_entrada_nÆo_pode_ser_movimentado" *}
                            ASSIGN c-lbl-liter-deposito-de-entrada-nao-pode-s = TRIM(RETURN-VALUE).
                            DEFINE VARIABLE c-lbl-liter-deposito-nao-pode-ser-moviment AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Dep¢sito_nÆo_pode_ser_movimentado_pela_transferˆncia_entre_dep¢sitos,_pois_foi_criado_pelo_Sistema_Hospitalar" *}
                            ASSIGN c-lbl-liter-deposito-nao-pode-ser-moviment = TRIM(RETURN-VALUE).
                            RUN utp/ut-msgs.p (INPUT "show",
                                               INPUT 17006,
                                               INPUT c-lbl-liter-deposito-de-entrada-nao-pode-s + "." + "~~" + 
                                                      c-lbl-liter-deposito-nao-pode-ser-moviment ).
                            RETURN 'adm-error'.
                        END.                  
                    &ELSE
                       &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
                          IF TRIM(SUBSTRING(deposito.char-1,2,1)) = "S" AND 
                                  deposito.ind-dep-cq = NO THEN DO:
                              /* Inicio -- Projeto Internacional */
                              DEFINE VARIABLE c-lbl-liter-deposito-de-entrada-nao-pode-s-2 AS CHARACTER NO-UNDO.
                              {utp/ut-liter.i "Dep¢sito_de_entrada_nÆo_pode_ser_movimentado" *}
                              ASSIGN c-lbl-liter-deposito-de-entrada-nao-pode-s-2 = TRIM(RETURN-VALUE).
                              DEFINE VARIABLE c-lbl-liter-deposito-nao-pode-ser-moviment-2 AS CHARACTER NO-UNDO.
                              {utp/ut-liter.i "Dep¢sito_nÆo_pode_ser_movimentado_pela_transferˆncia_entre_dep¢sitos,_pois_foi_criado_pelo_Sistema_Hospitalar" *}
                              ASSIGN c-lbl-liter-deposito-nao-pode-ser-moviment-2 = TRIM(RETURN-VALUE).
                              RUN utp/ut-msgs.p (INPUT "show",
                                                 INPUT 17006,
                                                 INPUT c-lbl-liter-deposito-de-entrada-nao-pode-s-2 + "." + "~~" + 
                                                 c-lbl-liter-deposito-nao-pode-ser-moviment-2 ).
                             RETURN 'adm-error'.
                          END.
                       &ENDIF
                    &ENDIF.
                    /*fim - Valida Deposito de Entrada (rodinei)*/
                
                    /*validacao do item*/
                    IF AVAIL ITEM THEN DO:
            
                        &IF '{&bf_mat_versao_ems}':U >= '2.08':U &THEN
                            IF  ITEM.log-orig-ext = YES AND 
                                deposito.ind-dep-cq = NO THEN DO:
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-item-nao-pode-ser-movimentado AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Item_nÆo_pode_ser_movimentado" *}
                                ASSIGN c-lbl-liter-item-nao-pode-ser-movimentado = TRIM(RETURN-VALUE).
                                DEFINE VARIABLE c-lbl-liter-item-nao-pode-ser-movimentado-2 AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Item_nÆo_pode_ser_movimentado_pela_transferˆncia_entre_dep¢sitos,_pois_foi_criado_pelo_Sistema_Hospitalar" *}
                                ASSIGN c-lbl-liter-item-nao-pode-ser-movimentado-2 = TRIM(RETURN-VALUE).
                                RUN utp/ut-msgs.p(INPUT 'show':U,
                                                  INPUT 17006,
                                                  INPUT c-lbl-liter-item-nao-pode-ser-movimentado + '~~':U +
                                                        c-lbl-liter-item-nao-pode-ser-movimentado-2 + '.').
                                RETURN 'adm-error':U.
                            END.
                        &ELSE
                            &IF '{&bf_mat_versao_ems}':U >= '2.062':U &THEN
                                IF TRIM(SUBSTRING(ITEM.char-1,267,1)) = 'S':U AND 
                                   deposito.ind-dep-cq = NO THEN DO:
                                    /* Inicio -- Projeto Internacional */
                                    DEFINE VARIABLE c-lbl-liter-item-nao-pode-ser-movimentado-3 AS CHARACTER NO-UNDO.
                                    {utp/ut-liter.i "Item_nÆo_pode_ser_movimentado" *}
                                    ASSIGN c-lbl-liter-item-nao-pode-ser-movimentado-3 = TRIM(RETURN-VALUE).
                                    DEFINE VARIABLE c-lbl-liter-item-nao-pode-ser-movimentado-4 AS CHARACTER NO-UNDO.
                                    {utp/ut-liter.i "Item_nÆo_pode_ser_movimentado_pela_transferˆncia_entre_dep¢sitos,_pois_foi_criado_pelo_Sistema_Hospitalar" *}
                                    ASSIGN c-lbl-liter-item-nao-pode-ser-movimentado-4 = TRIM(RETURN-VALUE).
                                    RUN utp/ut-msgs.p(INPUT 'show':U,
                                                      INPUT 17006,
                                                      INPUT c-lbl-liter-item-nao-pode-ser-movimentado-3 + '~~':U +
                                                            c-lbl-liter-item-nao-pode-ser-movimentado-4 + '.').
                                    RETURN 'adm-error':U.
                                END.
                            &ENDIF
                        &ENDIF
                    END.
                END.
         &ENDIF
         /*fim valiadcao da integracao EMX x HIS*/


        /* Valida Localiza‡Æo de Entrada ------------------------------------------*/
        h-erro = movto-estoq.cod-localiz:handle.
        find localizacao where 
             localizacao.cod-estabel = input frame {&frame-name} c-cod-estabel-ent and 
             localizacao.cod-depos   = input frame {&frame-name} c-cod-depos-ent   and 
             localizacao.cod-localiz = input frame {&frame-name} c-cod-localiz-ent
             no-lock no-error.

        if not available localizacao then do:
            {utp/ut-table.i mgind localizacao 1}
            run utp/ut-msgs.p (input "show",
                               input 56,
                               input return-value).
            {&retorna-erro}
        end.
        
        /* Valida o Lote de Saida ------------------------------------*/
        h-erro = movto-estoq.lote:handle.

        if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
            for first saldo-estoq field (it-codigo lote cod-depos cod-localiz cod-estabel
                                         qtidade-atu qt-alocada qt-aloc-prod)
                where saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel
                  and saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
                  and saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote
                  and saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos
                  and saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz
                  and saldo-estoq.cod-refer   = input frame {&frame-name} movto-estoq.cod-refer
                no-lock: end.

            if avail saldo-estoq then do:

              &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                if l-lote-avancado then do:

                    run pi-identifica-saldo in h-ceapi030 (input 1,
                                                           input saldo-estoq.it-codigo,
                                                           input saldo-estoq.cod-estabel,
                                                           input saldo-estoq.lote,
                                                           input 0,
                                                           output l-retorno,
                                                           output table tt-valores2,
                                                           output table tt-erro).

                    if return-value = "nok":u then do:
                        run cdp/cd0666.w (input table tt-erro).
                        {&retorna-erro}
                    end.
                    else
                        assign de-qtidade = (saldo-estoq.qtidade-atu -
                                             saldo-estoq.qt-alocada -
                                             saldo-estoq.qt-aloc-prod).
                                  
                end.
                else
                &endif

                assign de-qtidade = (saldo-estoq.qtidade-atu -
                                     saldo-estoq.qt-alocada -
                                     saldo-estoq.qt-aloc-prod).

                if avail saldo-estoq  and input frame {&frame-name} movto-estoq.lote = ""      and
                   de-qtidade <= 0  then do:
                    run utp/ut-msgs.p (input "show":u,
                                       input 2633,
                                       input "").
                    {&retorna-erro}
                end.
            end.
            else if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:

                if input frame {&frame-name} movto-estoq.lote = ""  then do:
                    run utp/ut-msgs.p (input "show":u,
                                       input 2158,
                                       input "").
                    {&retorna-erro}
                end.

                if  item.tipo-con-est = 4  
                     and not can-find(first ref-item 
                                      where ref-item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo 
                                        and ref-item.cod-refer = input frame {&frame-name} movto-estoq.cod-refer) then do:   
                    run utp/ut-msgs.p (input "show",
                                       input 33928,
                                       input input frame {&frame-name} movto-estoq.cod-refer + "~~" + input frame {&frame-name} movto-estoq.it-codigo).
                    apply 'entry' to movto-estoq.cod-refer in frame {&frame-name}.
                    h-erro = movto-estoq.cod-refer:handle.
                    {&retorna-erro}
                end.
            end.

           if input frame {&frame-name} da-dt-vali-lote-sai < input frame {&frame-name} movto-estoq.dt-trans then
              run utp/ut-msgs.p (input "show":u,
                                 input 2659,
                                 input "").

        end.

        /* Verifica se os dados de saida e entrada sÆo iguais ---------------------*/
        if input frame {&frame-name} movto-estoq.cod-estabel = input frame {&frame-name} c-cod-estabel-ent and
           input frame {&frame-name} movto-estoq.cod-depos   = input frame {&frame-name} c-cod-depos-ent   and
           input frame {&frame-name} movto-estoq.cod-localiz = input frame {&frame-name} c-cod-localiz-ent and
           input frame {&frame-name} movto-estoq.lote        = input frame {&frame-name} c-lote-ent        and
           input frame {&frame-name} movto-estoq.cod-refer   = input frame {&frame-name} c-cod-refer-ent   then do:
            run utp/ut-msgs.p (input "show":u,
                               input 2685,
                               input "").
            return 'ADM-ERROR':U.
        end.
        &if defined(bf_mat_custeio_item) &then 
            find estab-mat where
                 estab-mat.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel
                 no-lock no-error.


            if avail estab-mat         and 
               estab-mat.usa-on-line   AND
               item-uni-estab.metodo-custeio <> 5 AND
               (item.tipo-con-est = 3  or 
                item.tipo-con-est = 4) and
               (input frame {&frame-name} movto-estoq.lote      <> input frame {&frame-name} c-lote-ent or
                input frame {&frame-name} movto-estoq.cod-refer <> input frame {&frame-name} c-cod-refer-ent) then do:
                /************************************************************************ 
                ** Para custeio On-Line, o lote e a referencia nao podem ser alterados **
                ************************************************************************/
                run utp/ut-msgs.p (input "show":u,
                                   input 26336,
                                   input "").
                return 'ADM-ERROR':U.
            end. 
       &endif
       
        /* Valida Lote de Entrada -------------------------------------------------*/
        h-erro = c-lote-ent:handle.
        if input frame {&frame-name} c-lote-ent = ""        and
           (item.tipo-con-est = 3 or
            item.tipo-con-est = 4)      then do:
            run utp/ut-msgs.p (input "show":u,
                               input 2158,
                               input "").
            {&retorna-erro}
        end.

        if  item.tipo-con-est = 2                      and
            input frame {&frame-name} c-lote-ent <> input frame {&frame-name} movto-estoq.lote then do:
            run utp/ut-msgs.p (input "show":u,
                              input 2690,
                              input "").
            {&retorna-erro}
        end.

        /* Valida a data de validade do lote --------------------------------------*/
        h-erro = da-dt-vali-lote-ent:handle.
        if input frame {&frame-name} da-dt-vali-lote-ent = ? and
           item.tipo-con-est > 2         then do:
            run utp/ut-msgs.p (input "show":u,
                               input 1786,
                               input "").
            {&retorna-erro}
        end.

        /* Valida a referencia de entrada -----------------------------------------*/
        h-erro = c-cod-refer-ent:handle.
        if  item.tipo-con-est = 4  
             and not can-find(first ref-item 
                              where ref-item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo 
                                and ref-item.cod-refer = input frame {&frame-name} c-cod-refer-ent) then do:   
            run utp/ut-msgs.p (input "show",
                               input 33928,
                               input input c-cod-refer-ent + "~~" + input frame {&frame-name} movto-estoq.it-codigo).
            apply 'entry' to c-cod-refer-ent in frame {&frame-name}.
            {&retorna-erro}
        end.

        /* Valida a quantidade movimentada ----------------------------------------*/
        if not(item.fraciona) and
           input frame {&frame-name} movto-estoq.quantidade <> integer(input frame {&frame-name} movto-estoq.quantidade) then do:
            run utp/ut-msgs.p (input "show":u,
                               input 847,
                               input "").
            {&retorna-erro}
        end.

        /* Valida Unidade de Medida -----------------------------------------------*/
        h-erro = movto-estoq.un:handle.
        if item.it-codigo <> "" and
           input frame {&frame-name} movto-estoq.un <> item.un then do:
            run utp/ut-msgs.p (input "show":u,
                               input 1302,
                               input "").
            {&retorna-erro}
        end.
    end.

if  c-nom-prog-upc-mg97 <> "" then do:                  
    run value(c-nom-prog-upc-mg97) (input "VALIDATE", 
                                    input "VIEWER",
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "{&FIRST-EXTERNAL-TABLE}",
    &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                     input ?).
    &ELSE
                                     input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
    &ENDIF                                 
    if  return-value = "NOK" then
        return "ADM-ERROR".
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate-arg V-table-Win 
PROCEDURE pi-validate-arg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  CAN-FIND(FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-cod-despacho-plaza" AND funcao.ativo) THEN DO:

        IF  NOT VALID-HANDLE(h-boar202155) THEN
            RUN local/arg/boar202155.p PERSISTENT SET h-boar202155.

        RUN pi-valida-saldo-despacho IN h-boar202155 (INPUT rw-saldo,
                                                      INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.it-codigo,
                                                      INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.quantidade,
                                                      OUTPUT TABLE tt-erro).
        IF  RETURN-VALUE = "NOK":U 
        AND CAN-FIND(FIRST tt-erro) THEN DO:
            RUN cdp/cd0666.w (INPUT TABLE tt-erro).
            RETURN "ADM-ERROR":U.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate-declar V-table-Win 
PROCEDURE pi-validate-declar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  l-control-aduana-internac THEN DO:

        RUN validaSaldoDeclar IN h-boin01067 (INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel,
                                              INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-depos,
                                              INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-localiz,
                                              INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.it-codigo,
                                              INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-refer,
                                              INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.lote,
                                              INPUT INPUT FRAME {&FRAME-NAME} c-despacho,
                                              INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.quantidade,
                                              OUTPUT TABLE tt-erro).
        IF  RETURN-VALUE = "NOK":U 
        AND CAN-FIND(FIRST tt-erro) THEN DO:
            RUN cdp/cd0666.w (INPUT TABLE tt-erro).
            RETURN "ADM-ERROR":U.
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

