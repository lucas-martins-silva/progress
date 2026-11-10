&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V05IN218 2.00.00.046 } /*** "010046" 15/08/2023 13:17:28  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v05in218 MUT}
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

def new global shared var c-estab       like saldo-estoq.cod-estabel no-undo.
def new global shared var c-it-codigo   like item.it-codigo no-undo. 

/* Parameters Definitions ---                           */

def buffer b-saldo for saldo-estoq.

/* Local Variable Definitions ---                                       */
def var i-ficha-cq     like ficha-cq.nr-ficha  no-undo.
def var i-operacao     like oper-ord.op-codigo no-undo.
def var de-qtde-lib    as decimal no-undo.
def var l-deleta-erros as logical no-undo.
def var h-janela1      as handle  no-undo.
def var da-inspecao    as date    no-undo.
def var c-op-des1      as char    no-undo.
def var c-dep-rej      as char    no-undo.
def var c-resp         as char    no-undo.

{cdp/cd0666.i}
{cdp/cdcfgman.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

&if "{&bf_mat_versao_ems}" >= "2.062" &then

    {cep/ceapi001k.i}
    {cdp/cd9590.i}

    DEF BUFFER b-tt-movto FOR tt-movto.

    DEF VAR h-ceapi001k      AS HANDLE NO-UNDO.
    DEF VAR h-cdapi024       AS HANDLE NO-UNDO.
    DEF VAR c-unid-negoc     AS CHAR NO-UNDO.
    DEF VAR c-unid-negoc-des AS CHAR NO-UNDO.

&ELSE
    {cep/ceapi001.i}
&ENDIF

&IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
    {cqp/cqapi001.i}
&ELSE
    {cqp/cq9050.i}
&ENDIF

&IF  "{&bf_mat_versao_ems}" >= "2.04" &THEN
     DEF VAR c-movto-estoq-lote-ant LIKE movto-estoq.lote       NO-UNDO.
     DEF VAR c-lote-ant             LIKE c-movto-estoq-lote-ant NO-UNDO.
&ENDIF

 def var c-cod-deposito      as char    no-undo.
 def var c-cod-localizacao   as char    no-undo.
 def var l-loc-unica         as log     no-undo.

/**************  Unifica‡Æo de conceitos ****************/
def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Numero" column-label "Numero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistencia".

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.
def var c-formato-conta      as char no-undo.
def var c-formato-ccusto     as char no-undo. 

/* Variÿveis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Variÿveis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo. 
/**************  Unifica‡Æo de conceitos ****************/

def var i-empresa like param-global.empresa-prin no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-estoq item saldo-estoq
&Scoped-define FIRST-EXTERNAL-TABLE movto-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-estoq, item, saldo-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-estoq.dt-trans movto-estoq.quantidade ~
movto-estoq.un 
&Scoped-define ENABLED-TABLES movto-estoq
&Scoped-define FIRST-ENABLED-TABLE movto-estoq
&Scoped-Define ENABLED-OBJECTS RECT-15 RECT-16 RECT-2 rt-mold c-cod-depos 
&Scoped-Define DISPLAYED-FIELDS movto-estoq.dt-trans ~
movto-estoq.serie-docto movto-estoq.nro-docto movto-estoq.it-codigo ~
item.desc-item item.cod-localiz movto-estoq.quantidade movto-estoq.un ~
movto-estoq.cod-estabel movto-estoq.cod-depos movto-estoq.cod-localiz ~
movto-estoq.lote saldo-estoq.dt-vali-lote movto-estoq.cod-refer 
&Scoped-define DISPLAYED-TABLES movto-estoq item saldo-estoq
&Scoped-define FIRST-DISPLAYED-TABLE movto-estoq
&Scoped-define SECOND-DISPLAYED-TABLE item
&Scoped-define THIRD-DISPLAYED-TABLE saldo-estoq
&Scoped-Define DISPLAYED-OBJECTS c-conta c-ccusto c-cod-estabel c-cod-depos ~
c-cod-localiz c-lote dt-vali c-cod-refer i-saldo-estoq-per-ppm i-per-ppm 

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
DEFINE MENU POPUP-MENU-c-cod-depos 
       MENU-ITEM mZoomDep       LABEL "Zoom de Dep¢sito"
       MENU-ITEM mZoomSalDep    LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-c-cod-localiz 
       MENU-ITEM mZoomLoc       LABEL "Zoom de Localiza‡Æo"
       MENU-ITEM mZoomSalLoc    LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-c-cod-refer 
       MENU-ITEM mZoomRef       LABEL "Zoom de Referˆncia"
       MENU-ITEM mZoomSalRef    LABEL "Zoom de Saldos".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-ccusto AS CHARACTER FORMAT "x(20)":U 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 23.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-depos AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-localiz AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-refer AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-conta AS CHARACTER FORMAT "x(20)":U 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 23.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-entrada AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10.29 BY .67 NO-UNDO.

DEFINE VARIABLE c-lote AS CHARACTER FORMAT "X(40)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-saida AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9.72 BY .67 NO-UNDO.

DEFINE VARIABLE dt-vali AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-per-ppm AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "Concentracao/Ppm" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE i-saldo-estoq-per-ppm AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "Concentracao/Ppm" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 7.71.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37.57 BY 7.71.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 5.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-estoq.dt-trans AT ROW 1.17 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     movto-estoq.serie-docto AT ROW 2.17 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     movto-estoq.nro-docto AT ROW 3.17 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-conta AT ROW 4.17 COL 30 COLON-ALIGNED
     c-ccusto AT ROW 5.17 COL 30 COLON-ALIGNED WIDGET-ID 2
     movto-estoq.it-codigo AT ROW 6.58 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     item.desc-item AT ROW 7.58 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 60 BY .88
     item.cod-localiz AT ROW 8.58 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     movto-estoq.quantidade AT ROW 8.58 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.29 BY .88
     movto-estoq.un AT ROW 8.58 COL 67.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     movto-estoq.cod-estabel AT ROW 10.58 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-cod-estabel AT ROW 10.58 COL 59 COLON-ALIGNED
     movto-estoq.cod-depos AT ROW 11.58 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-cod-depos AT ROW 11.58 COL 59 COLON-ALIGNED
     movto-estoq.cod-localiz AT ROW 12.58 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     c-cod-localiz AT ROW 12.58 COL 59 COLON-ALIGNED
     movto-estoq.lote AT ROW 13.58 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     c-lote AT ROW 13.58 COL 59 COLON-ALIGNED
     saldo-estoq.dt-vali-lote AT ROW 14.58 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     dt-vali AT ROW 14.58 COL 59 COLON-ALIGNED
     movto-estoq.cod-refer AT ROW 15.58 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-cod-refer AT ROW 15.58 COL 59 COLON-ALIGNED
     i-saldo-estoq-per-ppm AT ROW 16.58 COL 20 COLON-ALIGNED HELP
          "Fator de Concentra‡Æo / Ppm"
     i-per-ppm AT ROW 16.67 COL 59 COLON-ALIGNED HELP
          "Fator de Concentra‡Æo / Ppm"
     c-saida AT ROW 9.92 COL 1.29 COLON-ALIGNED NO-LABEL
     c-entrada AT ROW 9.92 COL 40.14 COLON-ALIGNED NO-LABEL
     RECT-15 AT ROW 10.21 COL 1
     RECT-16 AT ROW 10.21 COL 39.29
     RECT-2 AT ROW 1 COL 1
     rt-mold AT ROW 6.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.04 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.movto-estoq,mgind.item,movind.saldo-estoq
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
         HEIGHT             = 17
         WIDTH              = 76.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-ccusto IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-depos:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-cod-depos:HANDLE.

/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-localiz:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-cod-localiz:HANDLE.

/* SETTINGS FOR FILL-IN c-cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-refer:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-cod-refer:HANDLE.

/* SETTINGS FOR FILL-IN c-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-entrada IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-saida IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN movto-estoq.cod-depos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.cod-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dt-vali IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN saldo-estoq.dt-vali-lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-per-ppm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-saldo-estoq-per-ppm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.nro-docto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.serie-docto IN FRAME f-main
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

&Scoped-define SELF-NAME c-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto V-table-Win
ON F5 OF c-ccusto IN FRAME f-main /* Centro Custo */
DO:
   IF v_log_utz_ccusto THEN DO:
       run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                           input "",                  /* CODIGO DO PLANO CCUSTO */
                                           input "",                  /* UNIDADE DE NEGOCIO */
                                           input INPUT movto-estoq.dt-trans, /* DATA DE TRANSACAO */
                                           output v_cod_ccusto,       /* CODIGO CCUSTO */
                                           output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                           output table tt_log_erro). /* ERROS */ 
       if return-value = "OK" then
           ASSIGN SELF:SCREEN-VALUE = v_cod_ccusto.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto V-table-Win
ON LEAVE OF c-ccusto IN FRAME f-main /* Centro Custo */
DO:
    {cdp/cd9998.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-ccusto IN FRAME f-main /* Centro Custo */
DO:
    apply 'F5' to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos V-table-Win
ON F5 OF c-cod-depos IN FRAME f-main
DO:
   assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} c-cod-estabel
        c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = c-cod-depos
        &campo2     = c-cod-localiz
        &campo3     = c-lote
        &campo4     = c-cod-refer
        &campozoom  = cod-depos
        &campozoom2 = cod-localiz
        &campozoom3 = lote
        &campozoom4 = cod-refer}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-depos IN FRAME f-main
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON F5 OF c-cod-estabel IN FRAME f-main
DO:
    {include/zoomvar.i &prog-zoom = adzoom/z01ad107.w
                       &campo     = c-cod-estabel
                       &campozoom = cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME f-main
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz V-table-Win
ON F5 OF c-cod-localiz IN FRAME f-main
DO:
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} c-cod-depos

    assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} c-cod-estabel
        c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = c-cod-localiz
        &campozoom  = cod-localiz
        &campo2     = c-cod-depos
        &campozoom2 = cod-depos
        &campo3     = c-lote
        &campozoom3 = lote
        &campo4     = c-cod-refer
        &campozoom4 = cod-refer
        &parametros = "run pi-inicializa-paginas in wh-pesquisa.
                       run pi-set-faixa-dep in wh-pesquisa
                                        ({&deposito}, {&deposito})."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-localiz IN FRAME f-main
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-refer V-table-Win
ON F5 OF c-cod-refer IN FRAME f-main
DO:
&SCOPED-DEFINE deposito input frame {&FRAME-NAME} c-cod-depos

    assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} c-cod-estabel
        c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = c-cod-localiz
        &campozoom  = cod-localiz
        &campo2     = c-cod-depos
        &campozoom2 = cod-depos
        &campo3     = c-lote
        &campozoom3 = lote
        &campo4     = c-cod-refer
        &campozoom4 = cod-refer
        &parametros = "run pi-inicializa-paginas in wh-pesquisa.
                       run pi-set-faixa-dep in wh-pesquisa
                                        ({&deposito}, {&deposito})."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-refer IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-conta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta V-table-Win
ON ENTRY OF c-conta IN FRAME f-main /* Conta */
DO:
  ASSIGN c-conta:FORMAT in frame {&FRAME-NAME} = "x(20)".
  ENABLE c-ccusto WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta V-table-Win
ON F5 OF c-conta IN FRAME f-main /* Conta */
DO:
   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                  input  "CEP",              /* M…DULO */
                                                  input  "",                 /* PLANO DE CONTAS */
                                                  input  "(nenhum)",         /* FINALIDADES */
                                                  input  INPUT movto-estoq.dt-trans, /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro). /* ERROS */ 
   if return-value = "OK" then
       ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta V-table-Win
ON LEAVE OF c-conta IN FRAME f-main /* Conta */
DO:
    assign self:format = "x(20)".
    ASSIGN v_cod_cta_ctbl = INPUT c-conta.

    /* Busca dados da conta contÙbil */
    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                   input        "",                 /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,     /* CONTA */
                                                   input        INPUT movto-estoq.dt-trans, /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl, /* SITUA›øO DA CONTA */
                                                   output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).       /* ERROS */
   
    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
        ASSIGN SELF:FORMAT = c-formato-conta.

        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                           input  INPUT movto-estoq.cod-estabel, /* ESTABELECIMENTO EMS2 */
                                                           input  "",                 /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,     /* CONTA */
                                                           input  INPUT movto-estoq.dt-trans, /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
        IF v_log_utz_ccusto THEN DO:
            ENABLE c-ccusto WITH FRAME {&FRAME-NAME}.
        END.
        ELSE DO:
            ASSIGN c-ccusto:SCREEN-VALUE = "".
            DISABLE c-ccusto WITH FRAME {&FRAME-NAME}.
        END.
        /************************************************/
    END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta IN FRAME f-main /* Conta */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-lote V-table-Win
ON ENTRY OF c-lote IN FRAME f-main
DO:
    &IF  "{&bf_mat_versao_ems}" >= "2.04" &THEN
          ASSIGN c-lote-ant = input frame {&FRAME-NAME} c-lote.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-lote V-table-Win
ON LEAVE OF c-lote IN FRAME f-main
DO:
    if  item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
        find first saldo-estoq use-index lote
            where saldo-estoq.lote      = input frame {&frame-name} c-lote
            and   saldo-estoq.it-codigo = item.it-codigo no-lock no-error.
        if  avail saldo-estoq then do:
            disp saldo-estoq.dt-vali-lote @ dt-vali with frame {&frame-name}.

            &IF  "{&bf_mat_versao_ems}" < "2.04" &THEN
                IF input frame {&frame-name} c-cod-refer = "" THEN DO:
            &ELSE
                IF  input frame {&frame-name} c-cod-refer = ""
                OR  input frame {&frame-name} c-lote <> c-lote-ant THEN DO:
            &endif 

                    disp saldo-estoq.dt-vali-lote @ dt-vali
                         saldo-estoq.cod-refer    @ c-cod-refer with frame {&frame-name}.

                END.
        end.  
        else do:
            enable dt-vali with frame {&frame-name}.
            if  item.tipo-con-est = 4 then 
                enable  c-cod-refer with frame {&frame-name}.       
        end.
    end.

 &if defined (bf_man_per_ppm) &then
    find first b-saldo
           where  b-saldo.it-codigo   = movto-estoq.it-codigo:SCREEN-VALUE IN frame {&frame-name} 
           and    b-saldo.lote        = input frame {&frame-name} c-lote
           and    b-saldo.cod-depos  <> movto-estoq.cod-depos:SCREEN-VALUE IN frame {&frame-name} 
           no-lock no-error.
    if item.tipo-con-est = 3 AND item.tipo-formula = 2 OR item.tipo-formula =3 then do: /* lote */

       if  avail b-saldo then do:
           ASSIGN i-per-ppm = b-saldo.per-ppm.      
           disp b-saldo.per-ppm @ i-per-ppm with frame {&frame-name}.
           disable i-per-ppm with frame {&frame-name}.
       end.         
       else do:
           ASSIGN i-per-ppm = ITEM.per-ppm.
           DISP ITEM.per-ppm @ i-per-ppm WITH FRAME {&frame-name}.
           enable i-per-ppm with frame {&frame-name}.
       end.
    end.
    ELSE DO:
        ASSIGN i-per-ppm = 0.
        IF  AVAIL b-saldo THEN
            disp b-saldo.per-ppm @ i-per-ppm with frame {&frame-name}.
        ELSE 
            disp i-per-ppm with frame {&frame-name}.
        disable i-per-ppm with frame {&frame-name}.
    END.
 &endif




END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-depos V-table-Win
ON F5 OF movto-estoq.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
    {include/zoom.i &prog-zoom="inzoom/z01in084.w"
                    &tabela=movto-estoq
                    &atributo=cod-depos}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON F5 OF movto-estoq.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
    &SCOPED-DEFINE estab    input frame {&FRAME-NAME} movto-estoq.cod-estabel
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} movto-estoq.cod-depos

    {include/zoom.i
        &prog-zoom   = "inzoom/z02in189.w"
        &tabela      = movto-estoq
        &atributo    = cod-localiz
        &parametros  = "run pi-faixa in wh-pesquisa
                            ({&estab}, {&deposito}, {&deposito})."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.lote V-table-Win
ON ENTRY OF movto-estoq.lote IN FRAME f-main /* Lote/S‚rie */
DO:
  &IF  "{&bf_mat_versao_ems}" >= "2.04" &THEN
       ASSIGN c-movto-estoq-lote-ant = INPUT FRAME {&FRAME-NAME} movto-estoq.lote.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomDep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomDep V-table-Win
ON CHOOSE OF MENU-ITEM mZoomDep /* Zoom de Dep¢sito */
DO:
      {include/zoomvar.i &prog-zoom = inzoom/z01in084.w
                       &campo     = c-cod-depos
                       &campozoom = cod-depos}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomLoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomLoc V-table-Win
ON CHOOSE OF MENU-ITEM mZoomLoc /* Zoom de Localiza‡Æo */
DO:
    &SCOPED-DEFINE estab    input frame {&FRAME-NAME} c-cod-estabel
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} c-cod-depos

    {include/zoom.i
        &prog-zoom   = "inzoom/z02in189.w"
        &tabela      = movto-estoq
        &atributo    = cod-localiz
        &parametros  = "run pi-faixa in wh-pesquisa
                            ({&estab}, {&deposito}, {&deposito})."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomRef V-table-Win
ON CHOOSE OF MENU-ITEM mZoomRef /* Zoom de Referˆncia */
DO:
    {include/zoomvar.i &prog-zoom = inzoom/z01in377.w
                     &campo     = c-cod-refer
                     &campozoom = cod-refer}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalDep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalDep V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalDep /* Zoom de Saldos */
DO:
  apply "F5" to c-cod-depos in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalLoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalLoc V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalLoc /* Zoom de Saldos */
DO:
  apply "F5" to c-cod-localiz in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalRef V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalRef /* Zoom de Saldos */
DO:
  apply "F5" to c-cod-refer in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.un V-table-Win
ON F5 OF movto-estoq.un IN FRAME f-main /* Unid Medid */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in417.w"
                   &tabela=movto-estoq
                   &atributo=un}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.un IN FRAME f-main /* Unid Medid */
DO:
    apply 'F5' to self.
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

{utp/ut-liter.i Conta * L}
assign c-conta:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Centro_Custo * L}
assign c-ccusto:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Sa¡da MCQ C}
assign c-saida:screen-value in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Entrada MCQ C}
assign c-entrada:screen-value in frame {&frame-name} = trim(return-value).
{utp/ut-field.i mgind movto-estoq cod-estabel 1}
assign c-cod-estabel:label in frame {&frame-name} = trim(return-value).
{utp/ut-field.i mgind movto-estoq cod-depos 1}
assign c-cod-depos:label in frame {&frame-name} = trim(return-value).
{utp/ut-field.i mgind movto-estoq cod-localiz 1}
assign c-cod-localiz:label in frame {&frame-name} = trim(return-value).
{utp/ut-field.i mgind movto-estoq lote 1}
assign c-lote:label in frame {&frame-name} = trim(return-value).
{utp/ut-field.i mgind saldo-estoq dt-vali-lote 1}
assign dt-vali:label in frame {&frame-name} = trim(return-value).
{utp/ut-field.i mgind movto-estoq cod-refer 1}
assign c-cod-refer:label in frame {&frame-name} = trim(return-value).

if c-cod-estabel :load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if c-cod-depos   :load-mouse-pointer ("image~\rbm.cur")  in frame {&frame-name} then.
if c-cod-refer   :load-mouse-pointer ("image~\rbm.cur")  in frame {&frame-name} then.
if c-cod-localiz :load-mouse-pointer ("image~\rbm.cur")  in frame {&frame-name} then.
if movto-estoq.un:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if movto-estoq.cod-localiz:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "item"}
  {src/adm/template/row-list.i "saldo-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-estoq"}
  {src/adm/template/row-find.i "item"}
  {src/adm/template/row-find.i "saldo-estoq"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a valida‡Æo de chave duplicada */

  /* Ponha aqui as demais valida‡„es */



  /* Obs.: CASO A VALIDA°€O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

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

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
    
        IF  VALID-HANDLE(h-ceapi001k) THEN DELETE PROCEDURE h-ceapi001k.
        IF  VALID-HANDLE(h-cdapi024)  THEN RUN pi-finalizar IN h-cdapi024.

        ASSIGN h-ceapi001k = ?
               h-cdapi024  = ?.
    &endif

  IF  VALID-HANDLE(h_api_cta_ctbl) THEN delete object h_api_cta_ctbl.
  IF  VALID-HANDLE(h_api_ccusto)   THEN delete object h_api_ccusto.

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

  find first param-global no-lock no-error.
  find first param-cq     no-lock no-error.
  find first param-estoq  no-lock no-error.

  &if defined(bf_dis_default_UN) &then
      FIND FIRST param-mat    NO-LOCK NO-ERROR.
  &endif

  find item where item.it-codigo = ficha-cq.it-codigo no-lock no-error.

  assign c-conta  = param-estoq.ct-tr-transf
         c-ccusto = param-estoq.sc-tr-transf.

  &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
      RUN cep/ceapi014.p (input ficha-cq.it-codigo,
                          INPUT ficha-cq.cod-estabel,
                          OUTPUT c-cod-deposito,
                          OUTPUT c-cod-localizacao,
                          OUTPUT l-loc-unica).

      disp c-cod-deposito           @ c-cod-depos
           c-cod-localizacao        @ c-cod-localiz
           with frame {&frame-name}.
  &ELSE
      disp item.deposito-pad                               @ c-cod-depos
           item.cod-localiz                                @ c-cod-localiz
       with  frame {&frame-name}.
  &ENDIF

  disp ficha-cq.serie-docto                            @ movto-estoq.serie-docto
       ficha-cq.nro-docto                              @ movto-estoq.nro-docto
       da-inspecao                                     @ movto-estoq.dt-trans
       c-conta
       c-ccusto
       ficha-cq.it-codigo                              @ movto-estoq.it-codigo
       item.desc-item
       item.cod-localiz
       ficha-cq.cod-estabel                            @ movto-estoq.cod-estabel
       c-dep-rej                                       @ movto-estoq.cod-depos
       ficha-cq.cod-localiz                            @ movto-estoq.cod-localiz
       ficha-cq.lote                                   @ movto-estoq.lote 
       ficha-cq.cod-estabel                            @ c-cod-estabel
/*     input frame {&frame-name} movto-estoq.lote      @ c-lote*/
       &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
           &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN
               ficha-cq.cod-refer                         @ c-cod-refer
               ficha-cq.cod-refer                         @ movto-estoq.cod-refer
           &ELSE
               substr(ficha-cq.char-1,1,8)                @ c-cod-refer
               substr(ficha-cq.char-1,1,8)                @ movto-estoq.cod-refer
           &ENDIF
       &ELSE
           item.cod-refer                                       @ movto-estoq.cod-refer
           input frame {&frame-name} movto-estoq.cod-refer      @ c-cod-refer
       &ENDIF
       with  frame {&frame-name}.

  &if defined(bf_dis_default_UN) &then
      IF AVAIL param-mat AND param-mat.ind-sit-un = 2 THEN /*unidade de medida default do item*/
          DISP ITEM.un       @ movto-estoq.un WITH FRAME {&FRAME-NAME}.
  &endif

  enable movto-estoq.cod-localiz with frame {&frame-name}.

  &if defined (bf_man_per_ppm) &then    
      ASSIGN  i-saldo-estoq-per-ppm = ficha-cq.per-ppm.
      DISPLAY i-saldo-estoq-per-ppm with frame {&frame-name}.
  &endif

  if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
     enable movto-estoq.lote
            /*movto-estoq.cod-localiz*/
            with frame {&frame-name}.           
     disable c-cod-estabel with frame {&frame-name}.       
  end.

  if item.tipo-con-est = 2 then  do:
     enable movto-estoq.lote
            /*movto-estoq.cod-localiz*/               
            with frame {&frame-name}.           
     disable c-cod-estabel with frame {&frame-name}.       
  end.   

  if item.tipo-con-est = 4 then do:
     enable movto-estoq.cod-refer             
            with frame {&frame-name}.
     disable c-cod-estabel with frame {&frame-name}.        
  end.                    

  &if defined (bf_man_per_ppm) &then    
    if item.tipo-con-est = 3 then do:
       IF ITEM.tipo-formula = 2 THEN DO:
           ASSIGN i-per-ppm:FORMAT               IN FRAME {&frame-name} = ">>9.9999". 
           ASSIGN i-per-ppm:LABEL                in frame {&frame-name} = 'Concentra‡Æo(%)'.
           ASSIGN i-saldo-estoq-per-ppm:FORMAT   IN FRAME {&frame-name} = ">>9.9999".  
           ASSIGN i-saldo-estoq-per-ppm:LABEL    in frame {&frame-name} = 'Concentra‡Æo(%)'.
       END.
       IF ITEM.tipo-formula = 3 THEN DO:
          ASSIGN i-per-ppm:LABEL             in frame {&frame-name} = 'PPM'.
          ASSIGN i-saldo-estoq-per-ppm:label in frame {&frame-name} = 'PPM'.
       END.
       ASSIGN i-per-ppm = ficha-cq.per-ppm.
       DISPLAY i-per-ppm with frame {&frame-name}.
       disable i-per-ppm with frame {&frame-name}.
    END.
    ELSE DO:
       IF ITEM.TIPO-FORMULA = 1 THEN do:
          ASSIGN i-per-ppm:LABEL             IN FRAME {&frame-name} = 'NÆo Utiliza'.
          ASSIGN i-saldo-estoq-per-ppm:LABEL in frame {&frame-name} = 'NÆo Utiliza'.
       END.
       IF ITEM.tipo-formula = 4 THEN do:
          ASSIGN i-per-ppm:LABEL             in frame {&frame-name} = 'Ve¡culo'.
          ASSIGN i-saldo-estoq-per-ppm:LABEL in frame {&frame-name} = 'Ve¡culo'.
       END.
    END.
  &endif

  &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
      DISABLE c-cod-refer 
              movto-estoq.cod-refer with frame {&frame-name}.

      /* HABILITA OS CAMPOS SE NECESSARIO */
      IF item.tipo-con-est = 4 THEN DO:
          IF substr(param-estoq.char-2,1,1) = "#" THEN
              ENABLE c-cod-refer 
                     movto-estoq.cod-refer with frame {&frame-name}.
          ELSE
              IF  NOT CAN-FIND(FIRST saldo-estoq
                               WHERE saldo-estoq.it-codigo = ficha-cq.it-codigo
                               AND   saldo-estoq.lote      = ficha-cq.lote) THEN
                  ENABLE c-cod-refer 
                         movto-estoq.cod-refer with frame {&frame-name}.

      END.
  &ENDIF

  run pi-atualiza.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &if defined (bf_man_per_ppm) &then    
  &else
     ASSIGN i-saldo-estoq-per-ppm:HIDDEN IN FRAME f-main = YES.
     ASSIGN i-per-ppm:HIDDEN IN FRAME f-main = YES.
  &endif

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
    
        IF  NOT VALID-HANDLE(h-ceapi001k) THEN
            RUN cep/ceapi001k.p persistent set h-ceapi001k.

        IF  NOT VALID-HANDLE(h-cdapi024) THEN
            RUN cdp/cdapi024.p persistent set h-cdapi024.
    &endif
    
  /* Handle da API Conta Contÿbil */
  run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
  /* Handle da API Centro Custo */
  run prgint\utb\utb742za.py persistent set h_api_ccusto.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza V-table-Win 
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if item.tipo-contr <> 4 then do:
       if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
          find first saldo-estoq where 
                     saldo-estoq.it-codigo = item.it-codigo and   
                     saldo-estoq.lote      = input frame {&frame-name} movto-estoq.lote
                     no-lock no-error.
          IF  AVAIL saldo-estoq THEN DO:
              DISP saldo-estoq.dt-vali-lote 
                   &IF  "{&bf_mat_versao_ems}" < "2.04" &THEN
                        saldo-estoq.cod-refer  @ movto-estoq.cod-refer
                   &endif
                   WITH FRAME {&frame-name}.

              &IF  "{&bf_mat_versao_ems}" >= "2.04" &THEN
                  IF  INPUT FRAME {&FRAME-NAME} movto-estoq.cod-refer = "" THEN
                      DISP  saldo-estoq.cod-refer  @ movto-estoq.cod-refer  
                            WITH FRAME {&FRAME-NAME}.
              &ENDIF

          END.
          else do:
             enable dt-vali with frame {&frame-name}.
             if item.tipo-con-est = 4 then
                enable c-cod-refer with frame {&frame-name}.          
          end.
       end.
    end.

    if item.tipo-con-est <> 1 then 
       enable c-lote with frame {&frame-name}.

    &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
        IF NOT l-loc-unica THEN
    &ELSE
        if item.loc-unica = no then 
    &ENDIF
       enable c-cod-localiz with frame {&frame-name}.

    if item.tipo-con-est <> 2 then 
       enable movto-estoq.quantidade with frame {&frame-name}.

    if item.tipo-con-est     = 2  then
       disp 1 @ movto-estoq.quantidade with frame {&frame-name}.

    find estabelec where 
         estabelec.cod-estabel = ficha-cq.cod-estabel 
         no-lock no-error.
    if avail estabelec then do:

        IF  c-op-des1 = "3" THEN DO:

            &if "{&bf_mat_versao_ems}" >= "2.062" &then
                IF  l-unidade-negocio
                AND l-mat-unid-negoc THEN DO:

                    IF  VALID-HANDLE(h-cdapi024) THEN
                        RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT input frame {&frame-name} movto-estoq.cod-estabel,
                                                                 INPUT input frame {&frame-name} movto-estoq.it-codigo,
                                                                 INPUT input frame {&frame-name} movto-estoq.cod-depos,
                                                                 OUTPUT c-unid-negoc).

                    FIND unid-negoc-cq
                        WHERE unid-negoc-cq.cod-estabel    = input frame {&frame-name} movto-estoq.cod-estabel
                          AND unid-negoc-cq.cod-unid-negoc = c-unid-negoc NO-LOCK NO-ERROR.
                    IF  AVAIL unid-negoc-cq
                    AND unid-negoc-cq.cod-depos-rej <> "" THEN
                        DISP unid-negoc-cq.cod-depos-rej @ c-cod-depos with frame {&frame-name}.
                    ELSE
                        disp estabelec.dep-rej-cq @ c-cod-depos with frame {&frame-name}.
                END.
                ELSE
                    disp estabelec.dep-rej-cq @ c-cod-depos with frame {&frame-name}.
            &ELSE
                if  estabelec.dep-rej-cq <> "" then
                    disp estabelec.dep-rej-cq @ c-cod-depos with frame {&frame-name}.
            &ENDIF
        END.
    end.

    /* SE ITEM FOR LOTE OU REFERãNCIA, ATUALIZA DATA DE VALIDADE E COD-REFER */
    if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
       find first saldo-estoq where 
                  saldo-estoq.lote      = input frame {&frame-name} c-lote and   
                  saldo-estoq.it-codigo = item.it-codigo
                  no-lock no-error.
       if avail saldo-estoq then do:
          disp saldo-estoq.dt-vali-lote @ dt-vali
               saldo-estoq.cod-refer    @ c-cod-refer
               with frame {&frame-name}.
       end.              
       else do:
          disp today @ dt-vali with frame {&frame-name}.
          enable dt-vali with frame {&frame-name}.
          if item.tipo-con-est = 4 then
             enable  c-cod-refer with frame {&frame-name}.        
        end.
    end.

    apply 'entry' to movto-estoq.dt-trans in frame {&frame-name}.

    /*localiza‡Æo de sa¡da*/
    if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
       find first saldo-estoq where 
                  saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo   and   
                  saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel and   
                  saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos   and   
                  saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz and   
                  saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote        and
                  saldo-estoq.cod-refer   = input frame {&frame-name} movto-estoq.cod-refer
                  no-lock no-error.
       if avail saldo-estoq then DO:
          disp saldo-estoq.lote         @ c-lote
               &IF  "{&bf_mat_versao_ems}" < "2.04" &THEN
                    saldo-estoq.cod-refer  @ c-cod-refer
               &ENDIF
               saldo-estoq.dt-vali-lote @ dt-vali with frame {&frame-name}.

          &IF  "{&bf_mat_versao_ems}" >= "2.04" &THEN
              IF  INPUT FRAME {&FRAME-NAME} c-cod-refer = "" THEN
                  DISP saldo-estoq.cod-refer  @ c-cod-refer with frame {&frame-name}.
          &ENDIF
       END.
    end.

    run pi-atualiza-empresa (INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel).
  
    /* Retorna formato da conta contabil */
    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  input frame {&frame-name} movto-estoq.dt-trans, /* DATA DE TRANSACAO */
                                                       output c-formato-conta,    /* FORMATO CONTA */
                                                       output table tt_log_erro). /* ERROS */
    /* Retorna formato do centro de custo */
    run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* PLANO CCUSTO */
                                                   input  input frame {&frame-name} movto-estoq.dt-trans, /* DATA DE TRANSACAO */
                                                   output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */ 

    /* Formatando conta e centro de custo */
    if c-formato-conta <> "" then do:
        assign c-conta:format  in frame {&FRAME-NAME} = c-formato-conta.
    end.
    if c-formato-ccusto <> "" then do:
        assign c-ccusto:format in frame {&FRAME-NAME} = c-formato-ccusto.
    end.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-empresa V-table-Win 
PROCEDURE pi-atualiza-empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-cod-estabel LIKE ficha-cq.cod-estabel NO-UNDO.
  
  assign i-empresa = "".
  find estabelec where
       estabelec.cod-estabel = p-cod-estabel no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorno V-table-Win 
PROCEDURE pi-retorno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input parameter r-ficha-cq  as rowid   no-undo.
  def input parameter de-inspecao as date    no-undo.
  def input parameter c-deposito  as char    no-undo.
  def input parameter de-qt-a-lib as decimal no-undo.
  def input parameter h-janela    as handle  no-undo.

  assign da-inspecao = de-inspecao
         h-janela1   = h-janela
         c-dep-rej   = c-deposito
         de-qtde-lib = de-qt-a-lib.

  find ficha-cq where rowid(ficha-cq) = r-ficha-cq no-lock no-error.
  if avail ficha-cq then run local-enable-fields.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica V-table-Win 
PROCEDURE pi-verifica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAMETER de-qt-ant  AS DECIMAL NO-UNDO.

    def var i-insp        as integer no-undo.
    def var i-var-aux     as integer no-undo.
    def var i-var-aux-tot as integer no-undo.
    def var de-saldo      as decimal no-undo.
    def var de-quantid    as decimal no-undo.
    def var de-aux        as decimal no-undo.

    find first saldo-estoq where 
               saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo   and   
               saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel and   
               saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos   and   
               saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz and   
               saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote        and   
               saldo-estoq.cod-refer   = input frame {&frame-name} movto-estoq.cod-refer
               no-lock no-error.
    if not avail saldo-estoq then do:          
       run utp/ut-msgs.p (input "show", input 18258, input "").
       apply 'entry' to movto-estoq.lote in frame {&frame-name}. 
       return error.   
    end.

    if input frame {&frame-name} quantidade = "" or
       input frame {&frame-name} quantidade <= 0 then do:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Qtde_(quantidade)" *}
       run utp/ut-msgs.p (input "show", input 30555, input RETURN-VALUE).
       apply 'entry' to movto-estoq.quantidade in frame {&frame-name}. 
       return error.   
    end.

    if input frame {&frame-name} dt-vali < input frame {&frame-name} movto-estoq.dt-trans then do:
       run utp/ut-msgs.p (input "show", input 1290, input "").
       if return-value = 'no' then do:
          enable dt-vali with frame {&frame-name}.
          apply 'entry' to dt-vali in frame {&frame-name}.
          return error.
       end.
    end.

    find estabelec where 
         estabelec.cod-estabel = input frame {&frame-name} c-cod-estabel 
         no-lock no-error.
    if  not avail estabelec then do:
        {utp/ut-liter.i Estabelecimento * r}
        run utp/ut-msgs.p (input "show", input 558, input trim(return-value)).
        apply 'entry' to c-cod-estabel in frame {&frame-name}.
        return error.
    end.

    find item where 
         item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo 
         no-lock no-error.

    if  de-qtde-lib < input frame {&frame-name} movto-estoq.quantidade then do:
        run utp/ut-msgs.p (input "show", input 1630, input "").
        apply 'entry' to movto-estoq.quantidade in frame {&frame-name}.
        return error.
    end. 

    /* VERIFICA SE LOCALIZA°€O ORIGEM ? IGUAL A DESTINO */
    if  input frame {&frame-name} movto-estoq.cod-estabel = input frame {&frame-name} c-cod-estabel
    and input frame {&frame-name} movto-estoq.cod-depos   = input frame {&frame-name} c-cod-depos
    and input frame {&frame-name} movto-estoq.cod-localiz = input frame {&frame-name} c-cod-localiz
    and input frame {&frame-name} movto-estoq.lote        = input frame {&frame-name} c-lote then do:
        run utp/ut-msgs.p (input "show", input 1305, input "").
        return error.
    end.

    if  input frame {&frame-name} movto-estoq.cod-depos = input frame {&frame-name} c-cod-depos then do:
        run utp/ut-msgs.p (input "show", input 1306, input "").
        return 'adm-error'.
    end.

    find first deposito
        where deposito.cod-depos = input frame {&frame-name} c-cod-depos
        no-lock no-error.

    if  not avail deposito then do:
        run utp/ut-msgs.p (input "show", input 530, input "").
          apply 'entry' to c-cod-depos in frame {&frame-name}.
          return error.   
    end.

    /* VALIDA REFERENCIA CONTRA TABELA REFERENCIA */
    &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
        IF  item.tipo-con-est = 4 THEN DO:
            IF NOT CAN-FIND(FIRST referencia
                            WHERE referencia.cod-refer = input frame {&frame-name} movto-estoq.cod-refer 
                            NO-LOCK) THEN DO:
                {utp/ut-table.i mgind referencia 1}
                RUN utp/ut-msgs.p("show",56,return-value).

                APPLY 'entry' TO movto-estoq.cod-refer IN FRAME {&FRAME-NAME}.
                RETURN ERROR.
            END.

            IF NOT CAN-FIND(FIRST referencia
                            WHERE referencia.cod-refer = input frame {&frame-name} c-cod-refer 
                            NO-LOCK) THEN DO:
                {utp/ut-table.i mgind referencia 1}
                RUN utp/ut-msgs.p("show",56,return-value).

                APPLY 'entry' TO c-cod-refer IN FRAME {&FRAME-NAME}.
                RETURN ERROR.
            END.
        END.
    &ENDIF
    /* ATUALIZA MOVIMENTA°€O DO ESTOQUE - SA™DA DO CQ - ORIGEM */
    create tt-movto.
    assign tt-movto.cod-versao-integracao = 1
           tt-movto.dt-trans      = input frame {&frame-name} movto-estoq.dt-trans
           tt-movto.nro-docto     = input frame {&frame-name} movto-estoq.nro-docto
           tt-movto.ct-codigo     = input frame {&frame-name} c-conta
           tt-movto.sc-codigo     = input frame {&frame-name} c-ccusto
           tt-movto.serie-docto   = input frame {&frame-name} movto-estoq.serie-docto
           tt-movto.cod-depos     = input frame {&frame-name} movto-estoq.cod-depos
           tt-movto.cod-estabel   = input frame {&frame-name} movto-estoq.cod-estabel
           tt-movto.it-codigo     = input frame {&frame-name} movto-estoq.it-codigo
           tt-movto.cod-localiz   = input frame {&frame-name} movto-estoq.cod-localiz
           tt-movto.lote          = input frame {&frame-name} movto-estoq.lote
           tt-movto.cod-refer     = input frame {&frame-name} movto-estoq.cod-refer
           tt-movto.quantidade    = input frame {&frame-name} movto-estoq.quantidade
           tt-movto.un            = input frame {&frame-name} movto-estoq.un
           tt-movto.esp-docto     = 33
           tt-movto.tipo-trans    = 2
           tt-movto.nat-operacao  = ficha-cq.nat-operacao
           tt-movto.cod-emitente  = ficha-cq.cod-emitente
           tt-movto.descricao-db  = ficha-cq.narrativa
           tt-movto.cod-prog-orig = "v05in218"
           tt-movto.usuario       = c-seg-usuario
           tt-movto.cod-emitente  = ficha-cq.cod-emitente
           tt-movto.dt-vali-lote  = (if avail saldo-estoq
                                        then input frame {&frame-name} saldo-estoq.dt-vali-lote
                                        else ?).

    &if defined (bf_man_per_ppm) &then    
       ASSIGN tt-movto.per-ppm   = input frame {&frame-name} i-saldo-estoq-per-ppm.
    &endif

    /*** Seta Unidade de Neg¢cio ***/
    &if "{&bf_mat_versao_ems}" >= "2.062" &then
    
        IF  l-unidade-negocio
        AND l-mat-unid-negoc THEN DO:
            IF  VALID-HANDLE(h-cdapi024) THEN
                RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT tt-movto.cod-estabel,
                                                         INPUT tt-movto.it-codigo,
                                                         INPUT tt-movto.cod-depos,
                                                         OUTPUT tt-movto.cod-unid-negoc).
            ASSIGN c-unid-negoc = tt-movto.cod-unid-negoc.
        END.
        ELSE
            ASSIGN c-unid-negoc = "".
    &ENDIF

    /* ATUALIZA MOVIMENTA°€O DE ESTOQUE - DESTINO */
    create tt-movto.
    assign tt-movto.cod-versao-integracao = 1
           tt-movto.dt-trans      = input frame {&frame-name} movto-estoq.dt-trans
           tt-movto.nro-docto     = input frame {&frame-name} movto-estoq.nro-docto
           tt-movto.ct-codigo     = input frame {&frame-name} c-conta
           tt-movto.sc-codigo     = input frame {&frame-name} c-ccusto
           tt-movto.serie-docto   = input frame {&frame-name} movto-estoq.serie-docto
           tt-movto.cod-depos     = input frame {&frame-name} c-cod-depos
           tt-movto.cod-estabel   = input frame {&frame-name} c-cod-estabel
           tt-movto.it-codigo     = input frame {&frame-name} movto-estoq.it-codigo
           tt-movto.cod-localiz   = input frame {&frame-name} c-cod-localiz
           tt-movto.lote          = input frame {&frame-name} c-lote
           tt-movto.cod-refer     = input frame {&frame-name} c-cod-refer
           tt-movto.dt-vali-lote  = input frame {&frame-name} dt-vali
           tt-movto.quantidade    = input frame {&frame-name} movto-estoq.quantidade
           tt-movto.un            = input frame {&frame-name} movto-estoq.un
           tt-movto.esp-docto     = 33
           tt-movto.tipo-trans    = 1
           tt-movto.nat-operacao  = ficha-cq.nat-operacao
           tt-movto.cod-emitente  = ficha-cq.cod-emitente
           tt-movto.descricao-db  = ficha-cq.narrativa
           tt-movto.cod-prog-orig = "v05in218"
           tt-movto.cod-emitente  = ficha-cq.cod-emitente
           &if "{&bf_mat_versao_ems}" >= "2.062" &then
           tt-movto.cod-unid-negoc = IF  l-unidade-negocio AND l-mat-unid-negoc THEN c-unid-negoc ELSE ""
           &ENDIF
           tt-movto.usuario       = c-seg-usuario.

    &if defined (bf_man_per_ppm) &then    
       ASSIGN tt-movto.per-ppm   = input frame {&frame-name} i-per-ppm.
    &endif
	
	blk_transacao:
	do transaction:
	

		if  deposito.ind-dep-cq = yes then do:

			run cqp/cq9031a.w (output c-resp).
			if  c-resp = "yes":U then do:
				for each tt-erro:
					delete tt-erro.
				end.

				FOR FIRST item-uni-estab FIELDS(contr-qualid)
					WHERE item-uni-estab.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo
					  AND item-uni-estab.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel NO-LOCK:  END.

				if  item.contr-qualid = YES OR item-uni-estab.contr-qualid = YES then do:
					create tt-ficha.
					assign tt-ficha.cod-depos    = input frame {&frame-name} c-cod-depos
						   tt-ficha.cod-estabel  = input frame {&frame-name} c-cod-estabel
						   tt-ficha.cod-localiz  = input frame {&frame-name} c-cod-localiz
						   tt-ficha.lote         = input frame {&frame-name} c-lote
						   tt-ficha.it-codigo    = input frame {&frame-name} movto-estoq.it-codigo
						   tt-ficha.nro-docto    = input frame {&frame-name} movto-estoq.nro-docto
						   tt-ficha.serie-docto  = input frame {&frame-name} movto-estoq.serie-docto
						   tt-ficha.qt-original  = input frame {&frame-name} movto-estoq.quantidade
						   tt-ficha.ct-destino   = input frame {&frame-name} c-conta
						   tt-ficha.sc-destino   = input frame {&frame-name} c-ccusto
						   tt-ficha.nr-ord-produ = ficha-cq.nr-ord-produ
						   tt-ficha.op-seq       = ficha-cq.op-seq
						   tt-ficha.nr-ordem     = ficha-cq.nr-ordem
						   tt-ficha.nat-operacao = ficha-cq.nat-operacao
						   tt-ficha.cod-emitente = ficha-cq.cod-emitente
						   tt-ficha.baixa-estoq  = yes
						   tt-ficha.origem       = 1.

					&if defined (bf_man_per_ppm) &then
						ASSIGN tt-ficha.per-ppm  = input frame {&frame-name} i-per-ppm.
					&endif


					&IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
						ASSIGN tt-movto.cod-refer = INPUT FRAME {&FRAME-NAME} c-cod-refer.
					&ENDIF

					&IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
						run cqp/cqapi001.p  (input-output table tt-ficha,
											 input-output table tt-erro,
											 input-output i-ficha-cq,
											 input-output i-operacao).
					&ELSE
						run cqp/cq9050.p  (input-output table tt-ficha,
										   input-output table tt-erro,
										   input-output i-ficha-cq,
										   input-output i-operacao).
				   &ENDIF

					find first tt-erro no-lock no-error.
					if  avail tt-erro then
						run cdp/cd0666.w (input table tt-erro).
				end.
			end.
			if  c-resp = "cancel":U then do:
				apply "entry" to c-cod-depos in frame {&frame-name}.
				return error.
			end.
		end.
		for each tt-erro:
			delete tt-erro.
		end.


		&if "{&bf_mat_versao_ems}" >= "2.062" &then
		
			IF  l-unidade-negocio
			AND l-mat-unid-negoc THEN DO:
				IF  VALID-HANDLE(h-cdapi024) THEN DO:
					/*** Posiciona no registro de saida (origem) ***/
					FIND FIRST b-tt-movto
						WHERE b-tt-movto.tipo-trans = 2 NO-LOCK NO-ERROR.

					/*** Localiza unidade de negocio origem ***/
					RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT b-tt-movto.cod-estabel,
															 INPUT b-tt-movto.it-codigo,
															 INPUT b-tt-movto.cod-depos,
															 OUTPUT c-unid-negoc).

					/*** Localiza unidade de negocio destino ***/
					RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT tt-movto.cod-estabel,
															 INPUT tt-movto.it-codigo,
															 INPUT tt-movto.cod-depos,
															 OUTPUT c-unid-negoc-des).

					/*** Se a unidade de negocio origem for diferente da unidade destino, emite mensagem e solicita confirma‡Æo ***/
					IF  c-unid-negoc <> c-unid-negoc-des THEN DO:
						run utp/ut-msgs.p (input "show", 
										   input 31334, 
										   INPUT c-unid-negoc + "~~" + c-unid-negoc-des).
						IF  RETURN-VALUE = "no":U THEN DO:
							apply 'entry' to c-cod-estabel in frame {&frame-name}.
							return error.
						END.
					END.
				END.
			END.

			IF  VALID-HANDLE (h-ceapi001k) THEN
				RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
											   input-output table tt-erro, 
											   input        l-deleta-erros).
		&ELSE
			run cep/ceapi001.p (input-output table tt-movto,
								input-output table tt-erro, 
								input        l-deleta-erros).
		&ENDIF

		/* CHAMADA DO BROWSE QUE MOSTRA AS INCONSISTãNCIAS DE CRIA°€O DO MOVTO-ESTOQ */
		for each tt-erro:
			find first cadast_msg where
				 cadast_msg.cdn_msg = tt-erro.cd-erro no-lock no-error.

			if avail cadast_msg and cadast_msg.idi_tip_msg = 1 then do:
				run cdp/cd0666.w (input table tt-erro).
				undo blk_transacao,return 'adm-error'.	
			end.			
		end.
		
		find first tt-erro no-error.
		if  avail tt-erro then do:
			run cdp/cd0666.w (input table tt-erro).
			return 'adm-error'.	
		end.

		assign ficha-cq.qt-a-liberar = ficha-cq.qt-a-liberar
									 - input frame {&frame-name} movto-estoq.quantidade.

		if  ficha-cq.qt-a-liberar = 0 and ficha-cq.inspecionado then
			assign ficha-cq.liberada = yes.
		if  input frame {&frame-name} movto-estoq.dt-trans > ficha-cq.dt-inspecao
		or  ficha-cq.dt-inspecao = ? then
			assign ficha-cq.dt-inspecao = input frame {&frame-name} movto-estoq.dt-trans.

		assign de-quantid = input frame {&frame-name} movto-estoq.quantidade
			   de-qt-ant  = input frame {&frame-name} movto-estoq.quantidade.

		for each rej-ficha where 
				 rej-ficha.nr-ficha  = ficha-cq.nr-ficha                               and   
				 rej-ficha.dep-rej   = input frame {&frame-name} movto-estoq.cod-depos and   
				 rej-ficha.quant-rej > 0
				 exclusive-lock :

		   if rej-ficha.quant-rej <= de-quantid then
			  assign de-aux              = rej-ficha.quant-rej
					 rej-ficha.quant-rej = 0 
					 de-quantid          = de-quantid - de-aux.

		   if rej-ficha.quant-rej > de-quantid then do:
			  assign rej-ficha.quant-rej = rej-ficha.quant-rej - de-quantid.
			  leave.
		   end.   
		end.
	end.
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
  {src/adm/template/snd-list.i "item"}
  {src/adm/template/snd-list.i "saldo-estoq"}

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


