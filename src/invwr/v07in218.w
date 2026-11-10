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
{include/i-prgvrs.i V07IN218 2.00.00.044 } /*** "010044" 02/05/2025 15:55:20 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v07in218 MUT}
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

/*def new global shared var c-it-cod like movto-estoq.it-codigo.*/

def buffer b-movto for movto-estoq.
def buffer b-saldo for saldo-estoq.
def buffer b-movto-mat for movto-mat.
/* global variable definitions */
define new global shared var v-row-parent    as rowid                   no-undo.
define new global shared var c-it-codigo   like item.it-codigo          no-undo.
define new global shared var c-estab       like saldo-estoq.cod-estabel no-undo.
def    new global shared var gr-argext-sdo-estoq as rowid no-undo.
/* Parameters Definitions ---                                           */

def var l-criou          as l init no.
def var i-cont-import    as int init 0.
def var i-nr-trans       as i init 0.
def var c-it-descricao   as character format "x(36)".
def var c-it-un          like item.un.
def var i-ge-codigo      like item.ge-codigo.
def var c-fm-codigo      like item.fm-codigo.
def var c-cod-estabel    like estabelec.cod-estabel.
def var de-aux-1 as decimal decimals 2 no-undo.
def var r-saldo-estoq    as rowid.
def var c-ct-codigo like movto-estoq.ct-codigo.
def var c-sc-codigo like movto-estoq.sc-codigo.

def var c-it-codigo-ant        as char no-undo.
def var c-cod-estabel-ant      as char no-undo.
def var c-cod-depos-ant        as char no-undo.
def var c-ordem-servic         as char no-undo.
def var l-executou-zoom-item   as log  no-undo.
def var l-executou-zoom-estab  as log  no-undo.
def var l-executou-zoom-depos  as log  no-undo.

def var dt-trans      like movto-estoq.dt-trans no-undo.

def var i-tp-comprov-doc like movto-estoq-internac.cdn-tip-comprov no-undo.
def var i-tp-operacao    like movto-estoq-internac.cdn-tip-operac  no-undo.

def var i-empresa like param-global.empresa-prin no-undo.
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

def var c-deposito       like deposito.cod-depos.
def var i-saldo-neg      as integer no-undo.

define var c-referencia  like saldo-estoq.cod-refer.
define var c-lote-serie  like saldo-estoq.lote.
define var c-cod-localiz like saldo-estoq.cod-localiz.
define var  c-zoom as character extent 2  no-undo.

DEF VAR c-cod-estabel-usuar LIKE estabelec.cod-estabel.

def var c-cod-depos         as char    no-undo.
def var c-cod-localizacao   as char    no-undo.
def var l-loc-unica         as log     no-undo.

def var c-emit-abrev     like emitente.nome-abrev.
def var i-emit-cod       like emitente.cod-emitente.
def var l-f4             as logical init no.

/*-- Investimento --*/
def new shared var i-emp-inv like empresa.ep-codigo.
def new shared var i-ord-inv as int format ">>>,>>9".
def new shared var r-mov-inv as rowid.
def new shared var i-ct-inv as char format "x(20)" no-undo.
def new shared var i-sc-inv as char format "x(20)" no-undo.
/*------------------*/ 
def var de-dt-vali-lote
                   like saldo-estoq.dt-vali-lote label "Dt.Validade" no-undo.
def var c-dt-trans        as character format "x(10)" 
                                        column-label "Dt.Trans" no-undo.
def var de-tipo-trans     like movto-estoq.tipo-trans no-undo.
def var de-ct-codigo-apli like movto-estoq.ct-codigo no-undo.
def var de-sc-codigo-apli like movto-estoq.sc-codigo
                                          column-label "Aplic".

def var de-it-codigo     like item.it-codigo no-undo.
def var de-esp-docto     like movto-estoq.esp-docto no-undo.
def var de-cod-estabel   like movto-estoq.cod-estabel no-undo.
def var de-cod-depos     like movto-estoq.cod-depos no-undo.
def var de-cod-localiz   like movto-estoq.cod-localiz no-undo.
def var de-lote          like movto-estoq.lote no-undo.
def var de-ct-codigo     like movto-estoq.ct-codigo no-undo.
def var de-sc-codigo     like movto-estoq.sc-codigo
                                         column-label "Sub  ".

def var de-cod-emite     like movto-estoq.cod-emitente no-undo.
def var de-serie-docto   like movto-estoq.serie-docto no-undo.
def var de-nro-docto     like movto-estoq.nro-docto no-undo.
def var de-dt-trans      like movto-estoq.dt-trans 
                                    column-label "Dt.Trans" no-undo.
def var de-un            like movto-estoq.un no-undo.
def var de-quantidade    like movto-estoq.quantidade no-undo.
def var de-valor-mat     like movto-estoq.valor-mat-m no-undo.
def var de-valor-mob     like movto-estoq.valor-mob-m no-undo.
def var de-referencia    like movto-estoq.referencia no-undo.
def var de-mess         as character format "x(50)" label "Mensagem".
def var de-ordem         like ord-prod.nr-ord-produ no-undo.

def var r-conta-contab   as rowid no-undo.
def var i-mo-origem      like cotacao.mo-codigo no-undo.
def var i-mo-destino     like cotacao.mo-codigo no-undo.
def var i-cod040         like movto-estoq.sc-codigo.
def var i-emp050         as char format "x(3)" no-undo.
def var i-cta050         as char format "x(20)" no-undo.
def var i-sbc050         as char format "x(20)" no-undo.
def var i-red050         as int format ">>>>>>9" no-undo.
def var cg-tipo-z        as character.
def var cg-sis-z         as character.    
def var i-cont-erro      as integer no-undo.
def var c-arq-msg        as char format "x(8)" no-undo.

def var l-tem            as logical no-undo.
def var l-resposta       as logical no-undo init no format "Sim/Nao".
def var l-entrada        as logical no-undo init no format "Sim/Nao".
def var i-ct-codigo      like movto-estoq.ct-codigo no-undo.
def var i-sc-codigo      like movto-estoq.sc-codigo no-undo.
def var r-registro       as rowid no-undo.
def var r-item           as rowid no-undo.
def var de-valor-aux     as decimal no-undo.
def var de-tx-1 as decimal format ">>>,>>9.9999" decimals 4 no-undo.
def var de-tx-2 like de-tx-1 no-undo.
def var de-cotacao like de-tx-1 no-undo.                    
def var da-dt-vali       like saldo-estoq.dt-vali-lote.
def var i-ent            as i format "9".
def var de-qtd           like movto-estoq.quantidade.
def var c-lb-cod-localiz as c format "x(10)".
def var h_v09in218 as handle.
def var h_v10in218 as handle.
def var h_v14in218 as handle.
def var h_window   as handle.


/*********************************************************
** Para a release 2.04A foi implementado um browser de  **
** saldos para os itens que possuirem metodo de custeio **
** FIFO/LIFO                                            **
*********************************************************/
def var h_b01in702 as handle.

def var c-handle     as char.
def var c-tp-trans   as char.
def var c-quantidade as char.
def var de-saldo-atual     like saldo-estoq.qtidade-atu.
def var de-saldo-calc      like saldo-estoq.qtidade-atu.
def var i-ep-codigo-usuario-old like empresa.ep-codigo no-undo.
def var i-num-ord-inv-old  as integer no-undo.
DEF VAR i-cenario     AS INT NO-UNDO.

def buffer b-saldo-estoq for saldo-estoq.

def var l-primeira    as logical initial yes no-undo.

def var i-ep-codigo   like empresa.ep-codigo no-undo.

{cep/ceapi001k.i}    /* Definicao de temp-table do movto-estoq */

{cep/ceapi001j.i1}   /* Definicao de temp-table do tt-movto-un */

{cdp/cd0666.i}      /* Definicao da temp-table de erros */

{cep/ce0101.i3} /* funcao spp-fechto-gerencial - seta variavel l-fechto-gerencial*/

/* Local Variable Definitions ---                                       */
def var l-achou             as logical no-undo.
def var c-conta-inv         AS CHAR FORMAT "X(20)" no-undo.
def var c-ccusto-inv         AS CHAR FORMAT "X(20)" no-undo.
def var c-par-inv           as char no-undo.
def var c-desc-ord-inv      as char no-undo.
def var l-zoom-inv          as logical no-undo.
def var h-boin029           as handle no-undo.
DEF VAR num-prod            LIKE ord-prod.nr-ord-produ NO-UNDO.

DEFINE VARIABLE i-cont                    AS INTEGER NO-UNDO.
DEFINE VARIABLE de-valor-mat-m            AS DECIMAL EXTENT 3 NO-UNDO.
DEFINE VARIABLE de-difere-valor-mat-m     AS DECIMAL EXTENT 3 NO-UNDO.
DEFINE VARIABLE de-valor-ggf-m            AS DECIMAL EXTENT 3 NO-UNDO.
DEFINE VARIABLE de-difere-valor-ggf-m     AS DECIMAL EXTENT 3 NO-UNDO.
DEFINE VARIABLE de-valor-mob-m            AS DECIMAL EXTENT 3 NO-UNDO.
DEFINE VARIABLE de-difere-valor-mob-m     AS DECIMAL EXTENT 3 NO-UNDO.
DEFINE VARIABLE de-val-quantidade         AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-difere-val-quantidade  AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-fracao-val-quantidade  AS DECIMAL NO-UNDO.

DEFINE VARIABLE h-ceapi001k               AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-cod-unid-negoc          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE h-cdapi024                AS HANDLE     NO-UNDO.

{cdp/cd9590.i}    /*Include verificaá∆o Unidade Neg¢cio*/

DEF TEMP-TABLE tt-matriz NO-UNDO
    FIELD cod-unid-neg AS CHAR
    FIELD perc-rateio  AS DEC.

/* Compatibilidade CD0666.i */
DEF TEMP-TABLE tt-erro-aux NO-UNDO
    FIELD i-sequen AS INT              
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "x(255)".

DEF VAR rw-saldo        AS ROWID       NO-UNDO.
DEF VAR l-habilita      AS LOG INIT NO NO-UNDO.
DEF VAR h-boar202155    AS HANDLE      NO-UNDO.
DEF VAR c-novo-despacho AS CHAR        NO-UNDO.

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
def var h-handle        as handle no-undo.
def var h-ceapi030      as handle no-undo.
def var l-retorno       as handle no-undo.
def var l-lote-avancado as log    no-undo.
def var l-sugere-lote   as log    no-undo.
def var l-amostra       as log    no-undo.
def var i-tp-amostra    as int    no-undo.

{cep/ceapi030.i}
&endif

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Número" column-label "Nﬂmero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistºncia".

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.
def var c-formato-conta      as char no-undo.
def var c-formato-ccusto     as char no-undo. 

/* Variˇveis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Variˇveis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.

DEF VAR h-boar2016   AS HANDLE no-undo.
DEF VAR h-boin01067  AS HANDLE NO-UNDO.
DEF VAR h-boin01098  AS HANDLE NO-UNDO.
DEF VAR h-boin01068  AS HANDLE NO-UNDO.

{utp/ut-glob.i}
{inbo/boin01098.i tt-dados-aduana}
{METHOD/dbotterr.i}
DEFINE VARIABLE hShowMsg AS HANDLE     NO-UNDO.

DEF VAR l-control-aduana-internac AS LOG INIT NO NO-UNDO.
ASSIGN l-control-aduana-internac = (i-pais-impto-usuario <> 1 AND CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-controle-aduana-internac":U AND funcao.ativo)).

/* Variavel utilizada para movimentaá‰es manuais ce0206/ce0220 */
DEF NEW GLOBAL SHARED VAR g-declar-control-aduana LIKE sdo-estoq-internac.declaracao-import NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-chave

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-estoq
&Scoped-define FIRST-EXTERNAL-TABLE movto-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-estoq.it-codigo movto-estoq.cod-estabel ~
movto-estoq.cod-depos movto-estoq.cod-localiz 
&Scoped-define ENABLED-TABLES movto-estoq
&Scoped-define FIRST-ENABLED-TABLE movto-estoq
&Scoped-Define ENABLED-OBJECTS rt-mold rt-cenario 
&Scoped-Define DISPLAYED-FIELDS movto-estoq.it-codigo movto-estoq.cod-refer ~
movto-estoq.cod-estabel movto-estoq.cod-depos movto-estoq.cod-localiz ~
movto-estoq.lote movto-estoq.num-ord-inv 
&Scoped-define DISPLAYED-TABLES movto-estoq
&Scoped-define FIRST-DISPLAYED-TABLE movto-estoq
&Scoped-Define DISPLAYED-OBJECTS c-desc-item c-desc-ref c-desc-est ~
c-desc-dep c-desc-loc da-dt-vali-lote c-despacho c-desc-ord rs-cenario 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS movto-estoq.cod-refer movto-estoq.lote ~
da-dt-vali-lote 
&Scoped-define ADM-MODIFY-FIELDS movto-estoq.cod-refer movto-estoq.lote ~
da-dt-vali-lote rs-cenario 

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
DEFINE MENU POPUP-MENU-cod-depos 
       MENU-ITEM mZoomDepos     LABEL "Zoom de Dep¢sitos"
       MENU-ITEM mZoomSalDep    LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-cod-estabel 
       MENU-ITEM mZoomSaldosEst LABEL "Zoom de Saldos"
       MENU-ITEM mZoomEstabel   LABEL "Zoom de Estabelecimentos".

DEFINE MENU POPUP-MENU-cod-localiz 
       MENU-ITEM mZoomLocal     LABEL "Zoom de Localizaá‰es"
       MENU-ITEM mZoomSalLoc    LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-cod-refer 
       MENU-ITEM mZoomSaldosRef LABEL "Zoom de Saldos"
       MENU-ITEM mZoomRefer     LABEL "Zoom de Referància".


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-new-dp 
     IMAGE-UP FILE "image/im-inl.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-inl.bmp":U
     LABEL "Despacho Plaza" 
     SIZE 4 BY 1.21.

DEFINE VARIABLE c-desc-dep AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-est AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-loc AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 34.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ord AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ref AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-despacho AS CHARACTER FORMAT "X(20)":U 
     LABEL "DP" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-vali-lote AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE tx-cenario AS CHARACTER FORMAT "X(256)":U INITIAL "Cen†rio" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE rs-cenario AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Fiscal", 1,
"Gerencial", 2
     SIZE 13.86 BY 1.75 NO-UNDO.

DEFINE RECTANGLE rt-cenario
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.29 BY 7.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-chave
     tx-cenario AT ROW 2.42 COL 69 NO-LABEL
     movto-estoq.it-codigo AT ROW 1.29 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-desc-item AT ROW 1.29 COL 30.57 COLON-ALIGNED NO-LABEL
     movto-estoq.cod-refer AT ROW 2.29 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-desc-ref AT ROW 2.29 COL 25.57 COLON-ALIGNED NO-LABEL
     movto-estoq.cod-estabel AT ROW 3.29 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-desc-est AT ROW 3.29 COL 20.57 COLON-ALIGNED NO-LABEL
     movto-estoq.cod-depos AT ROW 4.29 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-desc-dep AT ROW 4.29 COL 20.57 COLON-ALIGNED NO-LABEL
     movto-estoq.cod-localiz AT ROW 5.29 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25.43 BY .88
     c-desc-loc AT ROW 5.29 COL 38.57 COLON-ALIGNED NO-LABEL
     movto-estoq.lote AT ROW 6.29 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25.43 BY .88
     da-dt-vali-lote AT ROW 6.29 COL 46.86 COLON-ALIGNED
     c-despacho AT ROW 6.25 COL 65.29 COLON-ALIGNED WIDGET-ID 2
     bt-new-dp AT ROW 6.04 COL 84.57 WIDGET-ID 6
     movto-estoq.num-ord-inv AT ROW 7.29 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     c-desc-ord AT ROW 7.29 COL 22.29 COLON-ALIGNED NO-LABEL
     rs-cenario AT ROW 3.13 COL 71 HELP
          "Tipo de Emiss∆o do Relat¢rio" NO-LABEL WIDGET-ID 12
     rt-mold AT ROW 1 COL 1
     rt-cenario AT ROW 2.75 COL 68 WIDGET-ID 8
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
         HEIGHT             = 7.33
         WIDTH              = 88.29.
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
/* SETTINGS FOR FRAME f-chave
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-chave:SCROLLABLE       = FALSE
       FRAME f-chave:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON bt-new-dp IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-dep IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-est IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-loc IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ord IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ref IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-despacho IN FRAME f-chave
   NO-ENABLE                                                            */
ASSIGN 
       c-despacho:HIDDEN IN FRAME f-chave           = TRUE
       c-despacho:READ-ONLY IN FRAME f-chave        = TRUE.

ASSIGN 
       movto-estoq.cod-depos:POPUP-MENU IN FRAME f-chave       = MENU POPUP-MENU-cod-depos:HANDLE.

ASSIGN 
       movto-estoq.cod-estabel:POPUP-MENU IN FRAME f-chave       = MENU POPUP-MENU-cod-estabel:HANDLE.

ASSIGN 
       movto-estoq.cod-localiz:POPUP-MENU IN FRAME f-chave       = MENU POPUP-MENU-cod-localiz:HANDLE.

/* SETTINGS FOR FILL-IN movto-estoq.cod-refer IN FRAME f-chave
   NO-ENABLE 2 3                                                        */
ASSIGN 
       movto-estoq.cod-refer:POPUP-MENU IN FRAME f-chave       = MENU POPUP-MENU-cod-refer:HANDLE.

/* SETTINGS FOR FILL-IN da-dt-vali-lote IN FRAME f-chave
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN movto-estoq.lote IN FRAME f-chave
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN movto-estoq.num-ord-inv IN FRAME f-chave
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET rs-cenario IN FRAME f-chave
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN tx-cenario IN FRAME f-chave
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       tx-cenario:PRIVATE-DATA IN FRAME f-chave     = 
                "Cen†rio".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-chave
/* Query rebuild information for FRAME f-chave
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-chave */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bt-new-dp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-new-dp V-table-Win
ON CHOOSE OF bt-new-dp IN FRAME f-chave /* Despacho Plaza */
DO:
    IF  i-pais-impto-usuario = 2
    AND CAN-FIND(FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-cod-despacho-plaza" AND funcao.ativo) THEN DO:

        RUN local/arg/arg0215b.w (INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel,
                                  INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-depos,
                                  INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-localiz,
                                  INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.it-codigo,
                                  INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-refer,
                                  INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.lote,
                                  OUTPUT c-novo-despacho).
        ASSIGN c-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-novo-despacho
               rw-saldo = ?.
    END.

    IF  l-control-aduana-internac THEN DO:
        {&WINDOW-NAME}:SENSITIVE = NO.
        RUN cep/ce0220int.w (INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel,
                             INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-depos,
                             INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-localiz,
                             INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.it-codigo,
                             INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-refer,
                             INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.lote,
                             /*OUTPUT c-novo-despacho*/
                             INPUT-OUTPUT TABLE tt-dados-aduana).
        FIND FIRST tt-dados-aduana NO-LOCK NO-ERROR.
        ASSIGN c-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF  AVAIL tt-dados-aduana THEN tt-dados-aduana.declaracao-import ELSE "".
        {&WINDOW-NAME}:SENSITIVE = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-despacho
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-despacho V-table-Win
ON F5 OF c-despacho IN FRAME f-chave /* DP */
DO:
    IF  i-pais-impto-usuario = 2 /* Argentina */
    AND CAN-FIND(FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-cod-despacho-plaza":U AND funcao.ativo) THEN DO:

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
ON MOUSE-SELECT-DBLCLICK OF c-despacho IN FRAME f-chave /* DP */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-depos V-table-Win
ON ENTRY OF movto-estoq.cod-depos IN FRAME f-chave /* Dep¢sito */
DO:
    if not l-executou-zoom-depos then
        assign c-cod-depos-ant = input frame {&frame-name} movto-estoq.cod-depos.
    assign l-executou-zoom-depos = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-depos V-table-Win
ON F5 OF movto-estoq.cod-depos IN FRAME f-chave /* Dep¢sito */
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
        
    assign l-executou-zoom-depos = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-depos V-table-Win
ON LEAVE OF movto-estoq.cod-depos IN FRAME f-chave /* Dep¢sito */
DO:
    {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=c-desc-dep
                   &where="deposito.cod-depos = input frame {&frame-name} 
                           movto-estoq.cod-depos"}

   /*Unidade de Neg¢cio*/
   if l-unidade-negocio then do:
       
       assign c-cod-unid-negoc = "".

       /*Se j† tiver conte£do, n∆o ir† sugerir*/
       run Get-Field-screen-value in adm-broker-hdl (input this-procedure,
                                                     input "cod-unid-negoc").
       assign c-cod-unid-negoc = string(return-value).

       RUN Get-Field-Screen-Value IN adm-broker-hdl
           (INPUT THIS-PROCEDURE,
            INPUT "i-ord-prod").
       ASSIGN c-ordem-servic = RETURN-VALUE.

       if (c-cod-unid-negoc = "" OR 
           input frame {&frame-name} movto-estoq.cod-depos <> c-cod-depos-ant) AND
          (c-ordem-servic = "" OR
           c-ordem-servic = "0") then do:
           if valid-handle(h-cdapi024) THEN
               run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input input frame {&frame-name} movto-estoq.cod-estabel,
                                                                  input input frame {&frame-name} movto-estoq.it-codigo,
                                                                  input input frame {&frame-name} movto-estoq.cod-depos,
                                                                  output c-cod-unid-negoc).
           if valid-handle(h_v09in218) THEN
               run pi-mostra-unid-negoc in h_v09in218 (input c-cod-unid-negoc).
       end.
   end.
   RUN pi-despacho.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-depos IN FRAME f-chave /* Dep¢sito */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON ENTRY OF movto-estoq.cod-estabel IN FRAME f-chave /* Estabel */
DO:
    if not l-executou-zoom-estab then
        assign c-cod-estabel-ant = input frame {&frame-name} movto-estoq.cod-estabel.

    assign l-executou-zoom-estab = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON F5 OF movto-estoq.cod-estabel IN FRAME f-chave /* Estabel */
DO:
 /*{include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
 *                      &campo=movto-estoq.cod-estabel
 *                      &campo2=c-desc-est
 *                      &campozoom=cod-estabel
 *                      &campozoom2=nome}   */ 

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
        
    assign l-executou-zoom-estab = yes
           l-executou-zoom-depos = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON LEAVE OF movto-estoq.cod-estabel IN FRAME f-chave /* Estabel */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-desc-est
                   &where="estabelec.cod-estabel = input frame {&frame-name} 
                           movto-estoq.cod-estabel"}  
  assign c-estab = input frame {&frame-name} movto-estoq.cod-estabel.                           

  run pi-recebe-est in h_v09in218 (input self:screen-value).
  run pi-recebe-est in h_v10in218 (input self:screen-value).

  &if defined(bf_mat_custeio_item) &then
      /*********************************************************
      ** Para a release 2.04A foi implementado um browser de  **
      ** saldos para os itens que possuirem metodo de custeio **
      ** FIFO/LIFO                                            **
      *********************************************************/
      run pi-passa-item-estab in h_b01in702(input frame {&frame-name} movto-estoq.it-codigo, 
                                            c-estab).
  &endif
  
  IF  c-cod-estabel-ant <> INPUT movto-estoq.cod-estabel OR
      INPUT movto-estoq.cod-depos = "" THEN
      RUN pi-trata-dep-localiz IN THIS-PROCEDURE.

  /*Unidade de Neg¢cio*/
  if l-unidade-negocio then do:

      assign c-cod-unid-negoc = "".

      /*Se j† tiver conte£do, n∆o ir† sugerir*/
      run Get-Field-screen-value in adm-broker-hdl (input this-procedure,
                                                    input "cod-unid-negoc").
      assign c-cod-unid-negoc = string(return-value).

      RUN Get-Field-Screen-Value IN adm-broker-hdl
          (INPUT THIS-PROCEDURE,
           INPUT "i-ord-prod").
      ASSIGN c-ordem-servic = RETURN-VALUE.

      if (c-cod-unid-negoc = "" OR 
          input frame {&frame-name} movto-estoq.cod-estabel <> c-cod-estabel-ant) AND
         (c-ordem-servic = "" OR
          c-ordem-servic = "0") then do:
          if valid-handle(h-cdapi024) then
              run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input input frame {&frame-name} movto-estoq.cod-estabel,
                                                                 input input frame {&frame-name} movto-estoq.it-codigo,
                                                                 input input frame {&frame-name} movto-estoq.cod-depos,
                                                                 output c-cod-unid-negoc).
          if valid-handle(h_v09in218) then
              run pi-mostra-unid-negoc in h_v09in218 (input c-cod-unid-negoc).
      end.
  end.

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    if item.tipo-con-est > 2 then do:

        if not valid-handle(h-ceapi030) then do:
            run Who-Is-The-Container in adm-broker-hdl (input this-procedure, 
                                                        output h-handle).
    
            run pi-retorna-lote-avancado in h-handle (output h-ceapi030).
        end.

        if valid-handle(h-ceapi030) then do:

            empty temp-table tt-dados-fda.
            empty temp-table tt-valores.
            empty temp-table tt-erro.
    
            create tt-dados-fda.
            assign tt-dados-fda.cod-estabel     = input frame {&frame-name} movto-estoq.cod-estabel
                   tt-dados-fda.it-codigo       = input frame {&frame-name} movto-estoq.it-codigo
                   tt-dados-fda.cod-refer       = input frame {&frame-name} movto-estoq.cod-refer
                   tt-dados-fda.cod-modul-dtsul = "MCE"
                   tt-dados-fda.cod-usuario     = c-seg-usuario
                   tt-dados-fda.cod-depos       = input frame {&frame-name} movto-estoq.cod-depos
                   tt-dados-fda.cod-localiz     = input frame {&frame-name} movto-estoq.cod-localiz
                   tt-dados-fda.fm-codigo       = item.fm-codigo.
    
            if l-unidade-negocio then
                assign tt-dados-fda.cod-unid-negoc = c-cod-unid-negoc.

            run pi-executar in h-ceapi030 (input table tt-dados-fda,
                                           output table tt-valores,
                                           output table tt-erro).    
            if return-value = "ok":u then do:

                find first tt-valores no-lock no-error.
                if avail tt-valores then do:

                    run pi-param-esp in h-ceapi030 (input input frame {&frame-name} movto-estoq.it-codigo,
                                                    input "",
                                                    input input frame {&frame-name} movto-estoq.cod-estabel,
                                                    output l-sugere-lote,
                                                    output l-amostra,
                                                    output i-tp-amostra).
                    if l-sugere-lote and
                       tt-valores.lote <> "" then
                        assign movto-estoq.lote:screen-value in frame {&frame-name} = tt-valores.lote.                                    

                    if tt-valores.dt-val <> ? then
                        assign da-dt-vali-lote:screen-value in frame {&frame-name} = string(tt-valores.dt-val).
                end.

                apply "leave" to movto-estoq.lote in frame {&frame-name}.
                apply "entry" to movto-estoq.cod-depos in frame {&frame-name}.
            end.
            else do:
                run cdp/cd0666.w (input table tt-erro).
                empty temp-table tt-erro.
            end.
        end.
    end.
  &endif
  RUN pi-despacho.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-estabel IN FRAME f-chave /* Estabel */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON F5 OF movto-estoq.cod-localiz IN FRAME f-chave /* Localizaá∆o */
DO:
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} movto-estoq.cod-depos

    assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} movto-estoq.cod-estabel
        c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = movto-estoq.cod-refer
        &campozoom  = cod-refer    
        &campo2     = movto-estoq.cod-depos
        &campozoom2 = cod-depos
        &campo3     = movto-estoq.cod-localiz
        &campozoom3 = cod-localiz
        &campo4     = movto-estoq.lote
        &campozoom4 = lote
        &parametros = "run pi-inicializa-paginas in wh-pesquisa.
                       run pi-set-faixa-dep in wh-pesquisa                       
                                        ({&deposito}, {&deposito})."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON LEAVE OF movto-estoq.cod-localiz IN FRAME f-chave /* Localizaá∆o */
DO:

  {include/leave.i &tabela=localizacao
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-loc
                   &where="localizacao.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz and
                           localizacao.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos   and
                           localizacao.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel"}
RUN pi-despacho.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-localiz IN FRAME f-chave /* Localizaá∆o */
DO:
  apply "F5" to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-refer V-table-Win
ON F5 OF movto-estoq.cod-refer IN FRAME f-chave /* Referància */
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
ON LEAVE OF movto-estoq.cod-refer IN FRAME f-chave /* Referància */
DO:
  {include/leave.i &tabela=referencia
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-ref
                   &where="referencia.cod-refer = input frame {&frame-name} movto-estoq.cod-refer"}         
  RUN pi-despacho.                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-refer IN FRAME f-chave /* Referància */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON ENTRY OF movto-estoq.it-codigo IN FRAME f-chave /* Item */
DO:
  if c-it-codigo <> ? then
      assign c-it-codigo = input frame {&frame-name} movto-estoq.it-codigo.
  
  if not l-executou-zoom-item then
      assign c-it-codigo-ant = input frame {&frame-name} movto-estoq.it-codigo.
  assign l-executou-zoom-item = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON F5 OF movto-estoq.it-codigo IN FRAME f-chave /* Item */
DO:
    {include/zoom.i &prog-zoom="inzoom/z02in172.w"
                     &tabela=movto-estoq
                     &atributo=it-codigo} 
    assign l-executou-zoom-item = yes.                                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON LEAVE OF movto-estoq.it-codigo IN FRAME f-chave /* Item */
DO:
  find first param-estoq no-lock no-error.
  if movto-estoq.cod-estabel:screen-value in frame {&frame-name} = "" then do:
    ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.
  end.
  else do:
    assign c-cod-estabel-usuar = movto-estoq.cod-estabel:screen-value in frame {&frame-name}.
  end.

  /* Funcao Super/Minas */
  &IF DEFINED(Bf_dis_usuario_estab) &THEN
      IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                           AND funcao.ativo     = YES) THEN DO:
         RUN cdp/cd8702.p (input c-seg-usuario,
                                INPUT-OUTPUT c-cod-estabel-usuar).
      END.
  &ENDIF

  {include/leave.i &tabela=item
                   &atributo-ref=desc-item
                   &variavel-ref=c-desc-item
                   &where="item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo"}

  {include/leave.i &tabela=estabelec 
         &atributo-ref=nome
         &variavel-ref=c-desc-est
         &where="estabelec.cod-estabel=c-cod-estabel-usuar"}     
                           
  run pi-recebe-est in h_v09in218 (input c-cod-estabel-usuar).
  run pi-recebe-est in h_v10in218 (input c-cod-estabel-usuar).

  find first item
     where item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo 
     no-lock no-error.
  if  avail item and
      c-it-codigo <> item.it-codigo then do with frame {&frame-name}:
      assign c-it-codigo = item.it-codigo.
      if param-estoq.estab-uni then do:

           assign  movto-estoq.cod-estabel:screen-value in frame {&frame-name} = param-estoq.estabel-pad.
           disable movto-estoq.cod-estabel with frame {&frame-name}.
           
           run pi-recebe-est in h_v09in218 (INPUT param-estoq.estabel-pad).
           apply "leave" to movto-estoq.cod-estabel in frame {&frame-name}. /*jucinei*/
           
           {include/leave.i &tabela=estabelec 
                   &atributo-ref=nome
                   &variavel-ref=c-desc-est
                   &where="estabelec.cod-estabel=c-cod-estabel-usuar"} 
      end.
      else
         assign movto-estoq.cod-estabel:screen-value in frame {&frame-name} = c-cod-estabel-usuar.

      if item.tipo-con-est <> 4 then do:
         assign movto-estoq.cod-refer:screen-value in frame {&frame-name} = "".
         disable movto-estoq.cod-refer with frame {&frame-name}.

      end.
      else do:
         enable movto-estoq.cod-refer with frame {&frame-name}.
         assign movto-estoq.cod-refer:screen-value in frame {&frame-name} = "".
         apply "entry" to movto-estoq.cod-refer in frame {&frame-name}.
      end.

      if item.tipo-con-est = 1 then do:
         assign movto-estoq.lote:screen-value in frame {&frame-name} = "".
         disable movto-estoq.lote with frame {&frame-name}.
      end.
      else do:
         enable movto-estoq.lote with frame {&frame-name}.
      end.

      if  item.tipo-con-est = 1 or item.tipo-con-est = 2 then do: /*item SERIAL ou controlado por NÈMERO DE S?RIE*/
          assign da-dt-vali-lote:screen-value in frame {&frame-name} = "".
          disable da-dt-vali-lote with frame {&frame-name}.
      end.
      
      assign r-item = rowid(item).

      if item.tipo-contr = 1 or 
         item.tipo-contr = 4 then do:
          run pi-habilita in h_v10in218 (input yes).

                  
                  find estabelec where
                           estabelec.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel no-lock no-error.
                  assign i-empresa = estabelec.ep-codigo when avail estabelec.            

          /* Busca dados da conta contˇbil */
          ASSIGN v_cod_cta_ctbl = ITEM.ct-codigo.
          IF valid-handle(h_v09in218) THEN
            run pi-getDt-trans in h_v09in218 (output dt-trans).
          else
            assign dt-trans = today.
          run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                         input        "",                 /* PLANO DE CONTAS */
                                                         input-output v_cod_cta_ctbl,     /* CONTA */
                                                         input        dt-trans,              /* DATA TRANSACAO */   
                                                         output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                         output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                         output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */
                                                         output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                         output table tt_log_erro).       /* ERROS */ 

          /* Busca dados do centro de custo */
          ASSIGN v_cod_ccusto = ITEM.sc-codigo.
          run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                     input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                     input  v_cod_ccusto,       /* CCUSTO */
                                                     input  dt-trans,              /* DATA DE TRANSACAO */
                                                     output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                     output table tt_log_erro). /* ERROS */

      end.
      else do:
          run pi-habilita in h_v10in218 (input no).
      end.
      run pi-passa-item in h_v14in218 (input rowid(item)).
      run pi-passa-item in h_v09in218 (input rowid(item)).
      &if defined(bf_mat_custeio_item) &then
          /*********************************************************
          ** Para a release 2.04A foi implementado um browser de  **
          ** saldos para os itens que possuirem metodo de custeio **
          ** FIFO/LIFO                                            **
          *********************************************************/
          run pi-passa-item-estab in h_b01in702(input item.it-codigo, 
                                                input frame {&frame-name} movto-estoq.cod-estabel).
      &endif
  end.

  IF  c-it-codigo-ant   <> INPUT movto-estoq.it-codigo   OR
      INPUT movto-estoq.cod-depos = "" then
      RUN pi-trata-dep-localiz IN THIS-PROCEDURE.
  run pi-mostra-un in h_v14in218 ( input frame {&frame-name} movto-estoq.it-codigo ).

  if movto-estoq.cod-refer:sensitive in frame {&frame-name} = yes then do:  
     apply "entry" to movto-estoq.cod-refer in frame {&frame-name}.
     return no-apply.
  end.     

  /*Unidade de Neg¢cio*/
  if l-unidade-negocio then do:

      assign c-cod-unid-negoc = "".

      /*Se j† tiver conte£do, n∆o ir† sugerir*/
      run Get-Field-screen-value in adm-broker-hdl (input this-procedure,
                                                    input "cod-unid-negoc").
      assign c-cod-unid-negoc = string(return-value).

      RUN Get-Field-Screen-Value IN adm-broker-hdl
          (INPUT THIS-PROCEDURE,
           INPUT "i-ord-prod").
      ASSIGN c-ordem-servic = RETURN-VALUE.

      if (c-cod-unid-negoc = "" OR 
          input frame {&frame-name} movto-estoq.it-codigo <> c-it-codigo-ant) AND
         (c-ordem-servic = "" OR
          c-ordem-servic = "0") then do:
          if valid-handle(h-cdapi024) then
              run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input input frame {&frame-name} movto-estoq.cod-estabel,
                                                                 input input frame {&frame-name} movto-estoq.it-codigo,
                                                                 input input frame {&frame-name} movto-estoq.cod-depos,
                                                                 output c-cod-unid-negoc).
          if valid-handle(h_v09in218) then
              run pi-mostra-unid-negoc in h_v09in218 (input c-cod-unid-negoc).
      end.
  end.

  RUN pi-despacho.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.it-codigo IN FRAME f-chave /* Item */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.lote V-table-Win
ON F5 OF movto-estoq.lote IN FRAME f-chave /* Lote/SÇrie */
DO:
    /*apply "F5" to movto-estoq.cod-localiz in frame {&FRAME-NAME}.*/

      {include/zoomvar.i &prog-zoom="inzoom/z02in403.w"
                     &campo=movto-estoq.lote
                     &campozoom=lote}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.lote V-table-Win
ON LEAVE OF movto-estoq.lote IN FRAME f-chave /* Lote/SÇrie */
DO:
    do with frame {&FRAME-NAME}:
        /* Verifica se o lote j† existe -------------------------------------------*/
        find first saldo-estoq
            where saldo-estoq.it-codigo    = input frame {&frame-name} movto-estoq.it-codigo
                  and saldo-estoq.lote     = input frame {&frame-name} movto-estoq.lote no-lock no-error.
        if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do: /*item controlado por LOTE ou REFER“NCIA*/
            if avail saldo-estoq then do:
                
                &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                    if valid-handle(h-handle) then do:
                        run Who-Is-The-Container     in adm-broker-hdl (input this-procedure, 
                                                                        output h-handle).
                        run pi-retorna-lote-avancado in h-handle (output h-ceapi030).
                    end.
                    
                    if valid-handle(h-ceapi030) and not avail tt-valores then do:

                        run pi-identifica-saldo in h-ceapi030 (input 0,
                                                               input saldo-estoq.it-codigo,
                                                               input saldo-estoq.cod-estabel,
                                                               input saldo-estoq.lote,
                                                               input 0,
                                                               output l-retorno,
                                                               output table tt-valores2,
                                                               output table tt-erro).

                        if return-value = "ok":u then do:
                            find first tt-valores2 no-lock no-error.
                            display tt-valores2.dt-val @ da-dt-vali-lote with frame {&frame-name}.
                            disable da-dt-vali-lote with frame {&frame-name}.
                        end.
                        else do:
                            run cdp/cd0666.w (input table tt-erro).
                            apply "entry" to da-dt-vali-lote in frame {&frame-name}.
                            return no-apply.
                        end.
                    end.
                    else do:
                &endif
                        display saldo-estoq.dt-vali-lote @ da-dt-vali-lote with frame {&frame-name}.
                        disable da-dt-vali-lote with frame {&frame-name}.
                
                        &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                    end.
                        &endif
              
            end.
            else do:
                enable da-dt-vali-lote with frame {&frame-name}.
                apply "entry" to da-dt-vali-lote in frame {&frame-name}.
                RUN pi-carregaDesPlaz (Input false).
                return no-apply.
            end.
        end.

        /* validaá∆o data */
        if  input frame {&frame-name} movto-estoq.lote <> ""  then do :
            if (item.tipo-con-est = 3 or item.tipo-con-est = 4)
                and input frame {&frame-name} da-dt-vali-lote  = ? then do:
                    run utp/ut-msgs.p (input "show":u, input 1786, input return-value).
                    apply "entry" to da-dt-vali-lote in frame {&frame-name}.
                    return 'ADM-ERROR':U.
            end.
        end.

        /* Verifica se o n£mero de sÇrie foi informado ----------------------------*/
        if item.tipo-con-est      = 2  and 
            input frame {&frame-name} movto-estoq.lote = "" then do:
                {utp/ut-liter.i N£mero_SÇrie * r}
                run utp/ut-msgs.p (input "show":u, input 164, input return-value).
                return no-apply.
        end.    
        RUN pi-despacho.
    end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.lote V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.lote IN FRAME f-chave /* Lote/SÇrie */
DO:
    Apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomDepos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomDepos V-table-Win
ON CHOOSE OF MENU-ITEM mZoomDepos /* Zoom de Dep¢sitos */
DO:
    assign c-cod-depos-ant = movto-estoq.cod-depos:screen-value in frame {&frame-name}.

    {include/zoomvar.i &prog-zoom  = "inzoom/z01in084.w"
                     &campo      = "movto-estoq.cod-depos"
                     &campo2     = "c-desc-dep"
                     &campozoom  = "cod-depos"
                     &campozoom2 = "nome"}
                     
    assign l-executou-zoom-depos = yes.                  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomEstabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomEstabel V-table-Win
ON CHOOSE OF MENU-ITEM mZoomEstabel /* Zoom de Estabelecimentos */
DO:
    assign c-cod-estabel-ant = input frame {&frame-name} movto-estoq.cod-estabel.

    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=movto-estoq.cod-estabel
                     &campo2=c-desc-est
                     &campozoom=cod-estabel
                     &campozoom2=nome}    
    assign l-executou-zoom-estab = yes.                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomLocal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomLocal V-table-Win
ON CHOOSE OF MENU-ITEM mZoomLocal /* Zoom de Localizaá‰es */
DO:

assign l-implanta = yes.

    &SCOPED-DEFINE estab    input frame {&FRAME-NAME} movto-estoq.cod-estabel
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} movto-estoq.cod-depos

/*   {include/zoomvar.i
 *         &prog-zoom  = "inzoom/z02in189.w"
 *         &campo      = "movto-estoq.cod-localiz"
 *         &campozoom  = "cod-localiz"
 *         &parametros = "run pi-faixa in wh-pesquisa
 *                            ({&estab}, {&deposito}, {&deposito})."}   */       

   {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in189.w"
        &campo      = "movto-estoq.cod-localiz"
        &campozoom  = "cod-localiz"}    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomRefer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomRefer V-table-Win
ON CHOOSE OF MENU-ITEM mZoomRefer /* Zoom de Referància */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in377.w"
                     &campo=movto-estoq.cod-refer
                     &campozoom=cod-refer}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalDep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalDep V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalDep /* Zoom de Saldos */
DO:
    assign c-cod-depos-ant = movto-estoq.cod-depos:screen-value in frame {&frame-name}.
    apply "F5" to movto-estoq.cod-depos in frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSaldosEst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSaldosEst V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSaldosEst /* Zoom de Saldos */
DO:
    assign c-cod-depos-ant   = input frame {&frame-name} movto-estoq.cod-depos.
    apply "F5" to movto-estoq.cod-estabel in frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSaldosRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSaldosRef V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSaldosRef /* Zoom de Saldos */
DO:
  apply "F5" to movto-estoq.cod-refer in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalLoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalLoc V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalLoc /* Zoom de Saldos */
DO:
    apply "F5" to movto-estoq.cod-localiz in frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.num-ord-inv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.num-ord-inv V-table-Win
ON ENTRY OF movto-estoq.num-ord-inv IN FRAME f-chave /* Ordem Invest */
DO:
  assign i-num-ord-inv-old = input frame {&frame-name} movto-estoq.num-ord-inv.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.num-ord-inv V-table-Win
ON F5 OF movto-estoq.num-ord-inv IN FRAME f-chave /* Ordem Invest */
DO:
  find first estabelec where estabelec.cod-estabel = input frame {&frame-name} 
                                         movto-estoq.cod-estabel no-lock no-error.
  if avail estabelec then
     assign i-ep-codigo = estabelec.ep-codigo.
  else
     assign i-ep-codigo = ?.    

  {include/zoomvar.i &prog-zoom=ivzoom/z05iv043.w       
                     &campo=movto-estoq.num-ord-inv
                     &campozoom=num-ord-magnus
                     &parametros="run pi-seta-inicial in wh-pesquisa 
                                  (input i-ep-codigo)."}
  assign l-zoom-inv = yes.            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.num-ord-inv V-table-Win
ON LEAVE OF movto-estoq.num-ord-inv IN FRAME f-chave /* Ordem Invest */
DO:

if input frame {&frame-name} movto-estoq.num-ord-inv <> i-num-ord-inv-old 
   or l-zoom-inv  then do:
   assign l-zoom-inv = no.
   run pi-valida-ordem-investimento(input yes).   
   if return-value = "nok" then return no-apply.
end. 

run habilita-ordem in h_v09in218.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.num-ord-inv V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.num-ord-inv IN FRAME f-chave /* Ordem Invest */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-cenario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-cenario V-table-Win
ON VALUE-CHANGED OF rs-cenario IN FRAME f-chave
DO:
  RUN pi-troca-cenario IN h_v14in218 (INPUT SELF:SCREEN-VALUE).
  ASSIGN i-cenario = int(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */


  if movto-estoq.it-codigo:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.
  if movto-estoq.cod-refer:load-mouse-pointer   ("image~\rbm.cur" ) in frame {&frame-name} then.  
  if movto-estoq.cod-estabel:load-mouse-pointer ("image~\rbm.cur" ) in frame {&frame-name} then.
  if movto-estoq.cod-depos:load-mouse-pointer   ("image~\rbm.cur" ) in frame {&frame-name} then.
  if movto-estoq.cod-localiz:load-mouse-pointer ("image~\rbm.cur" ) in frame {&frame-name} then.
  if movto-estoq.num-ord-inv:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if movto-estoq.lote:load-mouse-pointer        ("image/lupa.cur") in frame {&frame-name} then.
  if c-despacho:load-mouse-pointer              ("image/lupa.cur")                        then.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  find first param-global no-lock no-error.

/************************ INTERNAL PROCEDURES ********************/

{utp/ut-liter.i Zoom_de_Dep¢sitos  MCE }
ASSIGN MENU-ITEM mZoomDepos:LABEL IN MENU POPUP-MENU-cod-depos = RETURN-VALUE.

{utp/ut-liter.i Zoom_de_Saldos  MCE }
ASSIGN MENU-ITEM mZoomSalDep:LABEL IN MENU POPUP-MENU-cod-depos      = RETURN-VALUE.
ASSIGN MENU-ITEM mZoomSalLoc:LABEL IN MENU POPUP-MENU-cod-localiz    = RETURN-VALUE.
ASSIGN MENU-ITEM mZoomSaldosRef:LABEL IN MENU POPUP-MENU-cod-refer   = RETURN-VALUE.
ASSIGN MENU-ITEM mZoomSaldosEst:LABEL IN MENU POPUP-MENU-cod-estabel = RETURN-VALUE.

{utp/ut-liter.i Zoom_de_Localizaá‰es  MCE } 
ASSIGN MENU-ITEM mZoomLocal:LABEL IN MENU POPUP-MENU-cod-localiz = RETURN-VALUE.

{utp/ut-liter.i Zoom_de_Estabelecimentos  MCE } 
ASSIGN MENU-ITEM mZoomEstabel:LABEL IN MENU POPUP-MENU-cod-estabel = RETURN-VALUE.

{utp/ut-liter.i Zoom_de_Referància  MCE } 
ASSIGN MENU-ITEM mZoomRefer:LABEL IN MENU POPUP-MENU-cod-refer = RETURN-VALUE.

{utp/ut-field.i mgind saldo-estoq cod-estabel 1}
assign movto-estoq.cod-estabel:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Cen†rio *}
ASSIGN tx-cenario:screen-value in frame {&frame-name} = RETURN-VALUE.

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
  HIDE FRAME f-chave.
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
/* A cada nova transaá∆o, limpa a vari†vel */
    ASSIGN c-novo-despacho = "".
    EMPTY TEMP-TABLE tt-dados-aduana.

  /* Code placed here will execute PRIOR to standard behavior. */
    /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  disable movto-estoq.cod-refer 
          movto-estoq.lote 
          da-dt-vali-lote
           with frame {&frame-name}.

  {utp/ut-liter.i Cen†rio *}
  ASSIGN tx-cenario:screen-value in frame {&frame-name} = RETURN-VALUE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  for each tt-erro:
      delete tt-erro.
  end.
  for each tt-movto:
      delete tt-movto.
  end.
  for each tt-movto-un:
      delete tt-movto-un.
  end.
  find first param-estoq no-lock no-error.       


  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
   Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */ 
  /* Code placed here will execute AFTER standard behavior.    */
  /* Chamada EPC para a assign record */
  {include/i-epc003.i}
  if valid-handle(h_v09in218) then
     run pi-epc in h_v09in218.
  if valid-handle(h_v10in218) then
     run pi-epc in h_v10in218.
  if valid-handle(h_v14in218) then
     run pi-epc in h_v14in218.   

  find estabelec where
    estabelec.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel
    no-lock no-error.
  
   RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "i-ord-prod").
          assign num-prod    = int(return-value).

   FOR FIRST ord-prod 
       WHERE ord-prod.nr-ord-produ = num-prod NO-LOCK:
   END.

   IF AVAIL ord-prod AND ord-prod.origem = "MI" THEN DO:
          RUN pi-cria-tt-movto (INPUT "",
                                INPUT 100).

          IF  c-nom-prog-upc-mg97 <> "" 
          AND c-nom-prog-upc-mg97 <> ? then do:                 
  
              run value(c-nom-prog-upc-mg97) (input "UPDATE-TT-MOVTO":U, 
                                              input "",
                                              input TEMP-TABLE tt-movto:HANDLE,
                                              input TEMP-TABLE tt-movto-un:HANDLE,
                                              input "",                                       
                                              input ?).     
              if return-value = "ERRO-EPC" then
                  return 'ERRO-EPC':U.
          end. 
          
          run cep/ceapi001k.p persistent set h-ceapi001k.
          RUN pi-execute in h-ceapi001k (input-output table tt-movto,
                                         input-output table tt-erro,
                                         input yes).
          delete procedure h-ceapi001k. 
        
          if can-find(first tt-erro no-lock) THEN DO:
              run cdp/cd0666.w (input table tt-erro).
          
              
              IF  CAN-FIND(FIRST tt-erro 
                           WHERE tt-erro.cd-erro <> 56847 /*mensagem de alerta*/ )  THEN DO:
                      apply "entry" to movto-estoq.it-codigo in frame {&frame-name}.
                      return 'ADM-ERROR':U.
              end.

          END.
        
          for each tt-movto exclusive-lock:
              assign r-mov-inv = tt-movto.r-mov-inv.
              delete tt-movto.
          end.
        /*-----------------------------------------------------------------*/
          release item.
        
          /*----------- Modulo de Investimento -----------*/
          if  param-global.modulo-in
          and input frame {&frame-name} movto-estoq.num-ord-inv <> 0 then do:
              find first estabelec where 
                   estabelec.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel no-lock no-error.
              if avail estabelec then
                  assign i-ep-codigo = estabelec.ep-codigo.
              else
                  assign i-ep-codigo = ?.   
        
              assign i-emp-inv = i-ep-codigo
                     i-ord-inv = input frame {&frame-name} movto-estoq.num-ord-inv.
              run inp/in2108.p.
              if return-value = "NOK" then 
                 undo, return "ADM-ERROR":U.
          end.
        
          /*----------------------------------------------*/
        
          find movto-estoq where rowid(movto-estoq) = r-mov-inv no-lock no-error.
          &if defined(bf_mat_custeio_item) &then
              /************************************************
              ** Release 2.04A - Metodo de custeio FIFO/LIFO **
              ************************************************/
              if avail item-uni-estab and
                 (item-uni-estab.metodo-custeio = 2 /* LIFO */ or
                  item-uni-estab.metodo-custeio = 3 /* FIFO */) and 
                 movto-estoq.quantidade = 0 then do:
                  run pi-atualiza-saldo-custo in h_b01in702 (input rowid(movto-estoq)).
        
              end.
              run pi-passa-item-estab in h_b01in702(input " ", 
                                                    input " ").
          &endif
   END.

   ELSE DO:
    
       IF  l-control-aduana-internac
       AND c-despacho:SCREEN-VALUE IN FRAME {&frame-name} <> "" THEN DO:

           ASSIGN g-declar-control-aduana = c-despacho:SCREEN-VALUE IN FRAME {&frame-name}.

           IF  CAN-FIND(FIRST tt-dados-aduana) THEN DO:
           
               /* Novo controle aduana, cria na tabela internac-decla-aduana */
               IF  NOT VALID-HANDLE(h-boin01098) THEN
                   RUN inbo/boin01098.p PERSISTENT SET h-boin01098.
                                                                                                                             
               RUN openQueryStatic IN h-boin01098 (INPUT "Main":U).
               RUN emptyRowErrors  IN h-boin01098.
               RUN setRecord       IN h-boin01098 (INPUT TABLE tt-dados-aduana).
               
               RUN validateRecord  IN h-boin01098 (INPUT "create":U).
               IF  RETURN-VALUE = "NOK":U THEN DO:
               
                   RUN getRowErrors    IN h-boin01098 (OUTPUT TABLE RowErrors).
    
                   IF CAN-FIND(FIRST RowErrors) THEN DO:
                       {method/showmessage.i1}
                       {method/showmessage.i2}
                       APPLY "entry" TO movto-estoq.it-codigo IN FRAME {&frame-name}.
                       RETURN 'ADM-ERROR':U.
                   END.
               END.
    
               RUN createRecord IN h-boin01098.
               IF  RETURN-VALUE = "NOK":U THEN DO:
               
                   RUN getRowErrors    IN h-boin01098 (OUTPUT TABLE RowErrors).
    
                   IF CAN-FIND(FIRST RowErrors) THEN DO:
                       {method/showmessage.i1}
                       {method/showmessage.i2}
                       APPLY "entry" TO movto-estoq.it-codigo IN FRAME {&frame-name}.
                       RETURN 'ADM-ERROR':U.
                   END.
               END.
           END.
       END.

       EMPTY TEMP-TABLE tt-matriz.

       IF  l-unidade-negocio AND INPUT FRAME {&FRAME-NAME} movto-estoq.num-ord-inv <> 0 THEN DO:
              RUN ivbo/boiv029.p PERSISTENT SET h-boin029.
              RUN retornaMatrizUnidNegoc IN h-boin029 (INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.num-ord-inv,
                                                       OUTPUT TABLE tt-matriz,
                                                       OUTPUT TABLE tt-erro-aux).
              DELETE PROCEDURE h-boin029.
       END.
           
       if item.fraciona                                      = no  and 
          item.tipo-contr                                   <> 4   and  
          l-unidade-negocio                                  = yes and 
          INPUT FRAME {&FRAME-NAME} movto-estoq.num-ord-inv <> 0   and 
          can-find(first tt-matriz)                                then do:
           for each tt-matriz:
               create tt-movto-un.
               assign tt-movto-un.i-sequen      = 0
                      tt-movto-un.cod-unid-neg  = tt-matriz.cod-unid-neg
                      tt-movto-un.perc-unid-neg = tt-matriz.perc-rateio.
           end.                                        
           for each tt-matriz:
               delete tt-matriz.
           end.
       end.

       IF  l-unidade-negocio                                      AND 
           INPUT FRAME {&FRAME-NAME} movto-estoq.num-ord-inv <> 0 and 
           not can-find(first tt-movto-un)                        THEN DO:

           IF  CAN-FIND(FIRST tt-erro-aux NO-LOCK) THEN DO:
               RUN cdp/cd0666.w (INPUT TABLE tt-erro-aux).
               APPLY "entry" TO movto-estoq.it-codigo IN FRAME {&frame-name}.
               RETURN 'ADM-ERROR':U.
           END.
           
           RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mat1").
           ASSIGN de-valor-mat-m[1] = DEC(RETURN-VALUE)
                  de-difere-valor-mat-m[1] = DEC(RETURN-VALUE).
           
           RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mat2").
           ASSIGN de-valor-mat-m[2] = DEC(RETURN-VALUE)
                  de-difere-valor-mat-m[2] = DEC(RETURN-VALUE).
           
           RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mat3").
           ASSIGN de-valor-mat-m[3] = DEC(RETURN-VALUE)
                  de-difere-valor-mat-m[3] = DEC(RETURN-VALUE).
           
           RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mob1").
           ASSIGN de-valor-mob-m[1] = DEC(RETURN-VALUE)
                  de-difere-valor-mob-m[1] = DEC(RETURN-VALUE).
           
           RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mob2").
           ASSIGN de-valor-mob-m[2] = DEC(RETURN-VALUE)
                  de-difere-valor-mob-m[2] = DEC(RETURN-VALUE).
           
           RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mob3").
           ASSIGN de-valor-mob-m[3] = DEC(RETURN-VALUE)
                  de-difere-valor-mob-m[3] = DEC(RETURN-VALUE).
           
           RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-ggf1").
           ASSIGN de-valor-ggf-m[1] = DEC(RETURN-VALUE)
                  de-difere-valor-ggf-m[1] = DEC(RETURN-VALUE).
           
           RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-ggf2").
           ASSIGN de-valor-ggf-m[2] = DEC(RETURN-VALUE)
                  de-difere-valor-ggf-m[2] = DEC(RETURN-VALUE).
           
           RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-ggf3").
           ASSIGN de-valor-ggf-m[3] = DEC(RETURN-VALUE)
                  de-difere-valor-ggf-m[3] = DEC(RETURN-VALUE).
           
           RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "quantidade":U).
           ASSIGN de-val-quantidade = dec(return-value)
                  de-difere-val-quantidade = dec(return-value).
           
           FOR EACH tt-matriz:
               RUN pi-cria-tt-movto (INPUT tt-matriz.cod-unid-neg,
                                     INPUT tt-matriz.perc-rateio).
           END.
      
           FIND FIRST tt-movto NO-ERROR.
           IF  AVAIL tt-movto THEN DO:
               IF  de-difere-val-quantidade <> 0
               AND de-difere-val-quantidade < tt-movto.quantidade THEN
                   ASSIGN tt-movto.quantidade = tt-movto.quantidade + de-difere-val-quantidade.
               
               DO i-cont = 1 TO 3:
                  IF i-cenario = 2 THEN DO: //gerencial

                      IF  de-difere-valor-mat-m[i-cont] <> 0
                      AND de-difere-valor-mat-m[i-cont] < tt-movto.valor-mat-p[i-cont] THEN
                          ASSIGN tt-movto.valor-mat-p[i-cont] = tt-movto.valor-mat-p[i-cont] + de-difere-valor-mat-m[i-cont].
                      
                      IF  de-difere-valor-ggf-m[i-cont] <> 0
                      AND de-difere-valor-ggf-m[i-cont] < tt-movto.valor-ggf-p[i-cont] THEN
                          ASSIGN tt-movto.valor-ggf-p[i-cont] = tt-movto.valor-ggf-p[i-cont] + de-difere-valor-ggf-m[i-cont].
                      
                      IF  de-difere-valor-mob-m[i-cont] <> 0
                      AND de-difere-valor-mob-m[i-cont] < tt-movto.valor-mob-p[i-cont] THEN
                          ASSIGN tt-movto.valor-mob-p[i-cont] = tt-movto.valor-mob-p[i-cont] + de-difere-valor-mob-m[i-cont].

                  END.
                  ELSE DO:
                  
                      IF  de-difere-valor-mat-m[i-cont] <> 0
                      AND de-difere-valor-mat-m[i-cont] < tt-movto.valor-mat-m[i-cont] THEN
                          ASSIGN tt-movto.valor-mat-m[i-cont] = tt-movto.valor-mat-m[i-cont] + de-difere-valor-mat-m[i-cont].
                      
                      IF  de-difere-valor-ggf-m[i-cont] <> 0
                      AND de-difere-valor-ggf-m[i-cont] < tt-movto.valor-ggf-m[i-cont] THEN
                          ASSIGN tt-movto.valor-ggf-m[i-cont] = tt-movto.valor-ggf-m[i-cont] + de-difere-valor-ggf-m[i-cont].
                      
                      IF  de-difere-valor-mob-m[i-cont] <> 0
                      AND de-difere-valor-mob-m[i-cont] < tt-movto.valor-mob-m[i-cont] THEN
                          ASSIGN tt-movto.valor-mob-m[i-cont] = tt-movto.valor-mob-m[i-cont] + de-difere-valor-mob-m[i-cont].
                      END.

               END.
           END.
           
       END.
       ELSE
            RUN pi-cria-tt-movto (INPUT "",
                                  INPUT 100).
      ASSIGN gr-argext-sdo-estoq = rw-saldo.      
      run cep/ceapi001k.p persistent set h-ceapi001k.

      run pi-valida-movto-uneg in h-ceapi001k (input table tt-movto-un).

      RUN pi-execute in h-ceapi001k (input-output table tt-movto,
                                     input-output table tt-erro,
                                     input yes).
      delete procedure h-ceapi001k. 
      
      if can-find(first tt-erro no-lock) THEN DO:
          run cdp/cd0666.w (input table tt-erro).

          IF  CAN-FIND(FIRST tt-erro 
                       WHERE tt-erro.cd-erro <> 56847 /*mensagem de alerta*/ )  THEN DO:
              apply "entry" to movto-estoq.it-codigo in frame {&frame-name}.
              return 'ADM-ERROR':U.
          END.
      end.
      
      for each tt-movto exclusive-lock:
          assign r-mov-inv = tt-movto.r-mov-inv.
          delete tt-movto.
      end.
      for each tt-movto-un:
          delete tt-movto-un.
      end.
/*    -----------------------------------------------------------------*/
      release item.
      
      /*----------- Modulo de Investimento -----------*/
      if  param-global.modulo-in
      and input frame {&frame-name} movto-estoq.num-ord-inv <> 0 then do:
          find first estabelec where 
               estabelec.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel no-lock no-error.
          if avail estabelec then
              assign i-ep-codigo = estabelec.ep-codigo.
          else
              assign i-ep-codigo = ?.   
      
          assign i-emp-inv = i-ep-codigo
                 i-ord-inv = input frame {&frame-name} movto-estoq.num-ord-inv.
          run inp/in2108.p.
          if return-value = "NOK" then 
             undo, return "ADM-ERROR":U.
      end.
      
      /*----------------------------------------------*/
      
      find movto-estoq where rowid(movto-estoq) = r-mov-inv no-lock no-error.
      &if defined(bf_mat_custeio_item) &then
          /************************************************
          ** Release 2.04A - Metodo de custeio FIFO/LIFO **
          ************************************************/
          if avail item-uni-estab AND
             (item-uni-estab.metodo-custeio = 2 /* LIFO */ or
              item-uni-estab.metodo-custeio = 3 /* FIFO */) and 
             movto-estoq.quantidade = 0 then do:
              run pi-atualiza-saldo-custo in h_b01in702 (input rowid(movto-estoq)).
      
          end.
          run pi-passa-item-estab in h_b01in702(input " ", 
                                                input " ").
      &endif
  END.

  IF  l-control-aduana-internac THEN 
      ASSIGN g-declar-control-aduana = "".
      
  /* Colocar aqui a chamada para a boin01068 e salvar na movto-estoq-internac */
  IF i-pais-impto-usuario = 33 THEN DO: /* Peru */
  
    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "i-tp-comprov-doc").
          assign i-tp-comprov-doc  = int(return-value).
    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "i-tp-operacao").
          assign i-tp-operacao  = int(return-value).
    
    /* Cria na tabela movto-estoq-internac */
    IF NOT VALID-HANDLE(h-boin01068) THEN
      RUN inbo/boin01068.p PERSISTENT SET h-boin01068.
        
    RUN atualizaMovtoEstoqInternac IN h-boin01068 (INPUT ROWID(movto-estoq),
                                                   INPUT i-tp-comprov-doc,
                                                   INPUT i-tp-operacao,
                                                   OUTPUT TABLE rowErrors).

    IF  RETURN-VALUE = "NOK":U THEN DO:
        
        RUN getRowErrors IN h-boin01068 (OUTPUT TABLE RowErrors).
    
        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2}
            APPLY "entry" TO movto-estoq.it-codigo IN FRAME {&frame-name}.
            RETURN 'ADM-ERROR':U.
        END.
    END.
  END. 

  RUN local-disable-fields IN THIS-PROCEDURE.
      
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
  &if defined(bf_mat_custeio_item) &then
      /*********************************************************
      ** Para a release 2.04A foi implementado um browser de  **
      ** saldos para os itens que possuirem metodo de custeio **
      ** FIFO/LIFO                                            **
      *********************************************************/
      run pi-passa-item-estab in h_b01in702(input " ", 
                                            input " ").
  &endif
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

  
  if valid-handle(h-cdapi024) then
      delete procedure h-cdapi024.

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    if valid-handle(h-ceapi030) then
        delete procedure h-ceapi030.
  &endif
  
    IF  VALID-HANDLE(h-boar202155) THEN
        RUN destroy IN h-boar202155.

  if valid-handle(h_api_cta_ctbl) then
    delete object h_api_cta_ctbl.
  if valid-handle(h_api_ccusto) then
    delete object h_api_ccusto.   

  IF  VALID-HANDLE(h-boin01067) THEN RUN destroy IN h-boin01067.
  IF  VALID-HANDLE(h-boin01098) THEN RUN destroy IN h-boin01098.

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
  assign c-it-codigo = ?.
  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif


  RUN local-display-fields.

  assign movto-estoq.num-ord-inv:sensitive in frame {&frame-name} = no.

    IF  i-pais-impto-usuario = 2 /* Argentina */
    AND CAN-FIND(FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-cod-despacho-plaza":U AND funcao.ativo) THEN
        ASSIGN c-despacho:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               bt-new-dp:SENSITIVE  IN FRAME {&FRAME-NAME} = NO.

    IF  l-control-aduana-internac THEN DO:
        ASSIGN c-despacho:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               bt-new-dp:SENSITIVE  IN FRAME {&FRAME-NAME} = NO.

        {utp/ut-liter.i "DI" *}
        ASSIGN c-despacho:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
    END.

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
  find first param-global no-lock no-error. 
  find first param-estoq no-lock no-error.

  if avail movto-estoq then do:
     find item where item.it-codigo = movto-estoq.it-codigo no-lock no-error.
     if avail item then
        assign c-desc-item = item.desc-item.

     find estabelec
        where estabelec.cod-estabel = movto-estoq.cod-estabel no-lock no-error.
     if avail estabelec then
        assign c-desc-est = estabelec.nome.

     find referencia
        where referencia.cod-refer = movto-estoq.cod-refer no-lock no-error.
     if avail referencia then
        assign c-desc-ref = referencia.descricao.

     find deposito
        where deposito.cod-depos = movto-estoq.cod-depos no-lock no-error.
     if avail deposito then
        assign c-desc-dep = deposito.nome.
     find localizacao
        where localizacao.cod-localiz = movto-estoq.cod-localiz no-lock no-error.
     if avail localizacao then
        assign c-desc-loc:screen-value in frame {&FRAME-NAME} = localizacao.descricao.
  end.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  clear frame {&frame-name}.

  
  find estabelec where
           estabelec.cod-estabel = c-estab no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec.  

  /* Handle da API Conta Contòbil */
  run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
  /* Handle da API Centro Custo */
  run prgint/utb/utb742za.py persistent set h_api_ccusto.

  /* Retorna formato da conta contabil */
  IF valid-handle(h_v09in218) THEN
    run pi-getDt-trans in h_v09in218 (output dt-trans).
  else
    assign dt-trans = today.
  run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                     input  "",                 /* PLANO CONTAS */
                                                     input  dt-trans,              /* DATA DE TRANSACAO */
                                                     output c-formato-conta,    /* FORMATO CONTA */
                                                     output table tt_log_erro). /* ERROS */
  /* Retorna formato do centro de custo */
  run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* PLANO CCUSTO */
                                                 input  dt-trans,              /* DATA DE TRANSACAO */
                                                 output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */

  {utp/ut-liter.i Cen†rio *}
  ASSIGN tx-cenario:screen-value in frame {&frame-name} = RETURN-VALUE.

  IF l-fechto-gerencial THEN
      apply "value-changed" to rs-cenario in frame {&frame-name}.

  IF NOT l-fechto-gerencial THEN
      ASSIGN rs-cenario:VISIBLE in frame {&frame-name} = NO
             rt-cenario:VISIBLE in frame {&frame-name} = NO
             tx-cenario:VISIBLE in frame {&frame-name} = NO.

  
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
  if param-global.modulo-in and
     connected("mginv") then do:
     assign movto-estoq.num-ord-inv:sensitive in frame {&frame-name} = yes.
  end.  
  else do: 
   assign movto-estoq.num-ord-inv:sensitive in frame {&frame-name} = no.
  end. 

  ASSIGN c-despacho:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         bt-new-dp:SENSITIVE  IN FRAME {&FRAME-NAME} = NO.

  IF NOT l-fechto-gerencial THEN
      ASSIGN rs-cenario:VISIBLE in frame {&frame-name} = NO
             rt-cenario:VISIBLE in frame {&frame-name} = NO
             tx-cenario:VISIBLE in frame {&frame-name} = NO.

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

  assign l-criou = no.
  {utp/ut-liter.i Validade * L}
  assign da-dt-vali-lote:label in frame {&frame-name} = return-value
         c-it-codigo = ?.


  /*{utp/ut-liter.i Corrente mce L}
  assign c-moeda = return-value.
  if  param-estoq.tem-moeda1 then do:
    assign
      c-moeda1 = param-global.moeda[param-estoq.moeda1]
      c-moeda1 = fill(" ",10 - length(c-moeda1))
                 + substring(c-moeda1,1,length(c-moeda1)).
  end.
  if  param-estoq.tem-moeda2 then do:
    assign
      c-moeda2 = param-global.moeda[param-estoq.moeda2]
      c-moeda2 = fill(" ",10 - length(c-moeda2))
                 + substring(c-moeda2,1,length(c-moeda2)).
  end.*/


  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  run cdp/cdapi024.p  persistent set h-cdapi024.

  /* Code placed here will execute AFTER standard behavior.    */

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    if can-find(funcao where funcao.cd-funcao = "lote-avancado":u and
                             funcao.ativo) then do:
        assign l-lote-avancado = yes.

        if not valid-handle(h-ceapi030) then
            run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                          output table tt-valores,
                                                          output table tt-erro).
    end.
  &endif
  
    IF (i-pais-impto-usuario = 2 /* Argentina */
    AND CAN-FIND(FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-cod-despacho-plaza":U AND funcao.ativo))
    OR  l-control-aduana-internac THEN DO:
    
        ASSIGN c-despacho:HIDDEN IN FRAME {&FRAME-NAME} = NO
               bt-new-dp:HIDDEN  IN FRAME {&FRAME-NAME} = NO.

        IF  l-control-aduana-internac THEN DO:
            {utp/ut-liter.i "DI" *}
            ASSIGN c-despacho:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

            IF  NOT VALID-HANDLE(h-boin01067) THEN
                RUN inbo/boin01067.p PERSISTENT SET h-boin01067.
        END.
    END.
    ELSE 
        ASSIGN c-despacho:HIDDEN IN FRAME {&FRAME-NAME} = YES
               bt-new-dp:HIDDEN  IN FRAME {&FRAME-NAME} = YES.
                
  find estabelec where
           estabelec.cod-estabel = c-estab no-lock no-error.
  assign i-empresa = estabelec.ep-codigo when avail estabelec.   

  /* Handle da API Conta Contòbil */
  run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
  /* Handle da API Centro Custo */
  run prgint\utb\utb742za.py persistent set h_api_ccusto.

  /* Retorna formato da conta contabil */
  IF valid-handle(h_v09in218) THEN
    run pi-getDt-trans in h_v09in218 (output dt-trans).
  else
    assign dt-trans = today.
  run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                     input  "",                 /* PLANO CONTAS */
                                                     input  dt-trans,              /* DATA DE TRANSACAO */
                                                     output c-formato-conta,    /* FORMATO CONTA */
                                                     output table tt_log_erro). /* ERROS */
  /* Retorna formato do centro de custo */
  run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* PLANO CCUSTO */
                                                 input  dt-trans,              /* DATA DE TRANSACAO */
                                                 output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */ 

  IF &if defined (spp-cod-despacho-plaza) &then  YES 
  &else  CAN-FIND(first  funcao where funcao.cd-funcao = "spp-cod-despacho-plaza" and  funcao.ativo)&endif  THEN DO:
      if i-pais-impto-usuario = 2 then do:
          Assign c-despacho:hidden in frame {&frame-name} = no.
      end.
  END.

  IF NOT l-fechto-gerencial THEN
      ASSIGN rs-cenario:VISIBLE in frame {&frame-name} = NO
             rt-cenario:VISIBLE in frame {&frame-name} = NO
             tx-cenario:VISIBLE in frame {&frame-name} = NO.
  ELSE DO:
      /*Busca cen†rio gerencial para alterar opá∆o*/
      DEFINE VARIABLE c-rs-cenario AS CHARACTER NO-UNDO.
    
      {utp/ut-liter.i Fiscal}
      ASSIGN c-rs-cenario = RETURN-VALUE + ",1,".
      ASSIGN c-rs-cenario = c-rs-cenario + param-estoq.cod-cenar-geren + ",2".
      ASSIGN rs-cenario:RADIO-BUTTONS IN FRAME {&frame-name} = c-rs-cenario.
  END.

  

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
    
    /* Ponha aqui a validaá∆o de chave duplicada */
    
    /* Ponha aqui as demais validaá‰es */
    
    /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

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

    if valid-handle(h_v09in218) then 
      run pi-desformata-campos in h_v09in218.
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-ccusto V-table-Win 
PROCEDURE pi-atualiza-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter c-cod-ccusto as CHAR FORMAT "x(20)"  no-undo.
def input parameter c-titulo-ccusto as CHAR FORMAT "x(40)"  no-undo.

ASSIGN v_cod_ccusto = c-cod-ccusto
       v_titulo_ccusto = c-titulo-ccusto.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-conta V-table-Win 
PROCEDURE pi-atualiza-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter c-cod-conta as CHAR FORMAT "x(20)"  no-undo.
def input parameter c-titulo-conta as CHAR FORMAT "x(40)"  no-undo.
def input parameter c-finalid-conta as CHAR FORMAT "x(256)"  no-undo.

ASSIGN v_cod_cta_ctbl = c-cod-conta
       v_titulo_cta_ctbl = c-titulo-conta
       v_ind_finalid_cta = c-finalid-conta.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carregaDesPlaz V-table-Win 
PROCEDURE pi-carregaDesPlaz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter l-mostra-erro as logical  no-undo.
def var c-desplaz as char format "x(16)":U    no-undo.
  IF &if defined (spp-cod-despacho-plaza) &then  YES 
  &else  CAN-FIND(first  funcao where funcao.cd-funcao = "spp-cod-despacho-plaza" and  funcao.ativo)&endif  THEN DO:
      if i-pais-impto-usuario = 2 then do:
          IF da-dt-vali-lote:screen-value in frame {&frame-name} <> '' THEN DO:          
              IF  NOT VALID-HANDLE(h-boar2016) THEN DO:
                  run local/arg/boar2016.p persistent set h-boar2016.
              END.
              
              run carregaDesPlaz  in h-boar2016 (INPUT  movto-estoq.cod-depos:screen-value,    
                                                        movto-estoq.cod-estabel:screen-value,  
                                                        movto-estoq.it-codigo:screen-value,    
                                                        movto-estoq.lote:screen-value,         
                                                        movto-estoq.cod-refer:screen-value,
                                                        l-mostra-erro,                           /*n„o exibe erro em tela*/
                                                 OUTPUT c-desplaz).
              Assign c-despacho:screen-value = c-desplaz.
              if  valid-handle(h-boar2016) THEN DO:
                  delete procedure h-boar2016.
                  ASSIGN h-boar2016 = ?.
              END.
          end.
      end.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-movto V-table-Win 
PROCEDURE pi-cria-tt-movto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAM p-cod-unid-negoc LIKE tt-matriz.cod-unid-neg   NO-UNDO.
  DEF INPUT PARAM p-perc-rateio    LIKE tt-matriz.perc-rateio    NO-UNDO.
  
  create tt-movto. 
  assign tt-movto.cod-versao-integracao = 1
         tt-movto.it-codigo       = input frame {&frame-name} movto-estoq.it-codigo
         tt-movto.cod-refer       = input frame {&frame-name} movto-estoq.cod-refer
         tt-movto.cod-estabel     = input frame {&frame-name} movto-estoq.cod-estabel
         tt-movto.cod-depos       = input frame {&frame-name} movto-estoq.cod-depos
         tt-movto.lote            = input frame {&frame-name} movto-estoq.lote
         tt-movto.cod-localiz     = input frame {&frame-name} movto-estoq.cod-localiz
         tt-movto.dt-vali-lote    = input frame {&frame-name} da-dt-vali-lote
         tt-movto.num-ord-inv     = input frame {&frame-name} movto-estoq.num-ord-inv
         tt-movto.esp-docto       = 6
         tt-movto.cod-prog-orig   = "v07in218"
         tt-movto.atualiza-ul-ent = l-entrada 
         tt-movto.usuario         = c-seg-usuario.

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "quantidade":U).
  assign tt-movto.quantidade   = dec(return-value) * (p-perc-rateio / 100).

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "referencia").
  assign tt-movto.referencia   = return-value.

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "descricao-db").
  assign tt-movto.descricao-db   = return-value.

  DEFINE var p-cod-un-db AS char format "x(3)"  NO-UNDO.
  DEFINE var p-ct-db     AS char format "x(20)" NO-UNDO. 
  DEFINE var p-sc-db     AS char format "x(20)" NO-UNDO.
    
  run getDadosAplicacao in h_v10in218 (output p-cod-un-db,
                                       output p-ct-db,
                                       output p-sc-db).

  assign tt-movto.ct-codigo = v_cod_cta_ctbl
         tt-movto.sc-codigo = v_cod_ccusto.
  if item.tipo-contr = 4
     or item.tipo-contr = 1
     or item.it-codigo = "" then do with frame {&frame-name}:

      assign tt-movto.ct-db    = p-ct-db
             tt-movto.sc-db    = p-sc-db.
  end.

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "i-ord-prod").
  assign tt-movto.nr-ord-produ    = int(return-value).

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "i-operacao").
  assign tt-movto.op-codigo    = int(return-value).

  FIND FIRST oper-ord WHERE oper-ord.nr-ord-produ = tt-movto.nr-ord-produ
                    AND oper-ord.op-codigo = tt-movto.op-codigo NO-LOCK NO-ERROR.
  IF AVAIL oper-ord THEN DO:
      ASSIGN tt-movto.op-seq = oper-ord.sequencia.
  END. 

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "cod-emitente").
  assign tt-movto.cod-emitente = int(return-value).

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "serie-docto").
  assign tt-movto.serie-docto = return-value.

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "nro-docto").
  assign tt-movto.nro-docto = return-value.

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "tipo-trans").
  assign tt-movto.tipo-trans = int(return-value).

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "dt-trans").
  assign tt-movto.dt-trans = date(return-value).

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "un").
  assign tt-movto.un = return-value.

  IF i-cenario = 2 THEN DO: //gerencial

      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mat1").
      assign tt-movto.valor-mat-p[1] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mat2").
      assign tt-movto.valor-mat-p[2] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mat3").
      assign tt-movto.valor-mat-p[3] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mob1").
      assign tt-movto.valor-mob-p[1] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mob2").
      assign tt-movto.valor-mob-p[2] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mob3").
      assign tt-movto.valor-mob-p[3] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-ggf1").
      assign tt-movto.valor-ggf-p[1] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-ggf2").
      assign tt-movto.valor-ggf-p[2] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-ggf3").
      assign tt-movto.valor-ggf-p[3] = dec(return-value) * (p-perc-rateio / 100).

  END.
  ELSE DO:

      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mat1").
      assign tt-movto.valor-mat-m[1] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mat2").
      assign tt-movto.valor-mat-m[2] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mat3").
      assign tt-movto.valor-mat-m[3] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mob1").
      assign tt-movto.valor-mob-m[1] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mob2").
      assign tt-movto.valor-mob-m[2] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-mob3").
      assign tt-movto.valor-mob-m[3] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-ggf1").
      assign tt-movto.valor-ggf-m[1] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-ggf2").
      assign tt-movto.valor-ggf-m[2] = dec(return-value) * (p-perc-rateio / 100).
    
      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "de-val-ggf3").
      assign tt-movto.valor-ggf-m[3] = dec(return-value) * (p-perc-rateio / 100).

  END.

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "c-cod-un-db").
  assign tt-movto.cod-unid-negoc-db = return-value. 

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "cod-unid-negoc").
  ASSIGN tt-movto.cod-unid-negoc = IF  p-cod-unid-negoc <> "" THEN p-cod-unid-negoc ELSE RETURN-VALUE. 
  
  ASSIGN de-difere-valor-mat-m[1] = de-difere-valor-mat-m[1] - (de-valor-mat-m[1] * (p-perc-rateio / 100))
         de-difere-valor-mat-m[2] = de-difere-valor-mat-m[2] - (de-valor-mat-m[2] * (p-perc-rateio / 100))
         de-difere-valor-mat-m[3] = de-difere-valor-mat-m[3] - (de-valor-mat-m[3] * (p-perc-rateio / 100))
         de-difere-valor-mob-m[1] = de-difere-valor-mob-m[1] - (de-valor-mob-m[1] * (p-perc-rateio / 100))
         de-difere-valor-mob-m[2] = de-difere-valor-mob-m[2] - (de-valor-mob-m[2] * (p-perc-rateio / 100))
         de-difere-valor-mob-m[3] = de-difere-valor-mob-m[3] - (de-valor-mob-m[3] * (p-perc-rateio / 100))
         de-difere-valor-ggf-m[1] = de-difere-valor-ggf-m[1] - (de-valor-ggf-m[1] * (p-perc-rateio / 100))
         de-difere-valor-ggf-m[2] = de-difere-valor-ggf-m[2] - (de-valor-ggf-m[2] * (p-perc-rateio / 100))
         de-difere-valor-ggf-m[3] = de-difere-valor-ggf-m[3] - (de-valor-ggf-m[3] * (p-perc-rateio / 100))
         de-difere-val-quantidade = de-difere-val-quantidade - (de-val-quantidade * (p-perc-rateio / 100)).

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
    DEF VAR l-item-dp AS LOG NO-UNDO.
    
    IF  i-pais-impto-usuario = 2 /* Argentina */
    AND CAN-FIND(FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-cod-despacho-plaza" AND funcao.ativo) THEN DO:

        /* Somente atualiza o despacho em tela se n∆o foi inclu°do um novo */
        IF  c-novo-despacho = "" THEN DO:
        
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
            
            IF  l-habilita = NO THEN
                ASSIGN c-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-despacho
                       c-despacho:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
            ELSE
                ASSIGN c-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       c-despacho:SENSITIVE    IN FRAME {&FRAME-NAME} = YES.
        END.
    
        /* Habilitar ou n∆o o bot∆o de inclus∆o de despacho */
        RUN pi-item-despacho IN h-boar202155 (INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.it-codigo,
                                              OUTPUT l-item-dp).
        ASSIGN bt-new-dp:SENSITIVE IN FRAME {&FRAME-NAME} = l-item-dp.
    END.

    IF  l-control-aduana-internac THEN DO:

        /* N∆o foi inclu°do uma nova declaraá∆o */
        IF  NOT CAN-FIND(FIRST tt-dados-aduana) THEN DO:
            RUN retornaSdoDisponDeclar IN h-boin01067 (INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel,
                                                       INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-depos,
                                                       INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-localiz,
                                                       INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.it-codigo,
                                                       INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-refer,
                                                       INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.lote,
                                                       OUTPUT c-despacho,
                                                       OUTPUT l-habilita).
    
            IF  l-habilita  = NO 
            AND c-despacho <> "" THEN
                ASSIGN c-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-despacho
                       c-despacho:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
                       bt-new-dp:SENSITIVE     IN FRAME {&FRAME-NAME} = NO.
            ELSE
                ASSIGN c-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
                       c-despacho:SENSITIVE    IN FRAME {&FRAME-NAME} = YES
                       bt-new-dp:SENSITIVE IN FRAME {&FRAME-NAME}     = YES.
        END.
    END.

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
&if defined(bf_mat_custeio_item) &then
    /*********************************************************
    ** Para a release 2.04A foi implementado um browser de  **
    ** saldos para os itens que possuirem metodo de custeio **
    ** FIFO/LIFO                                            **
    *********************************************************/
    def input param p-handle5 as handle.
&endif    

&if defined(bf_mat_custeio_item) &then
    assign h_b01in702 = p-handle5.
&endif

assign h_v09in218 = p-handle1
       h_v10in218 = p-handle2
       h_v14in218 = p-handle3
       h_window   = p-handle4.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-dep-localiz V-table-Win 
PROCEDURE pi-trata-dep-localiz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN cep/ceapi014.p (input input frame {&frame-name} movto-estoq.it-codigo,
                        INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-estabel,
                        OUTPUT c-cod-depos,
                        OUTPUT c-cod-localizacao,
                        OUTPUT l-loc-unica).

    assign movto-estoq.cod-depos:screen-value   in frame {&frame-name} = c-cod-depos
           movto-estoq.cod-localiz:screen-value in frame {&frame-name} = c-cod-localizacao.

    if  l-loc-unica then
        disable movto-estoq.cod-localiz
                with frame {&frame-name}.
    else
        enable movto-estoq.cod-localiz
               with frame {&frame-name}.

    APPLY "LEAVE":U TO movto-estoq.cod-depos   IN FRAME {&FRAME-NAME}.
    APPLY "LEAVE":U TO movto-estoq.cod-localiz IN FRAME {&FRAME-NAME}.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ordem-investimento V-table-Win 
PROCEDURE pi-valida-ordem-investimento :
/*------------------------------------------------------------------------------
  Purpose: Validar ordem de investimento se a mesma for digitada.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-altera-conta as logical.

find first estabelec where estabelec.cod-estabel = input frame {&frame-name} 
                                         movto-estoq.cod-estabel no-lock no-error.
if avail estabelec then
   assign i-ep-codigo = estabelec.ep-codigo.
else
   assign i-ep-codigo = ?. 

run inp/in2112b.p (input i-ep-codigo,
                   input "habilita-conta",
                   output c-par-inv).   

assign c-desc-ord:screen-value in frame {&frame-name} = "":U.

if input frame {&frame-name} movto-estoq.num-ord-inv <> 0 then do:
   run inp/in2112a.p (input estabelec.ep-codigo,
                      input frame {&frame-name} movto-estoq.num-ord-inv,
                      output c-desc-ord-inv,
                      output l-achou,
                      output c-conta-inv,
                      output c-ccusto-inv).


   if not l-achou then do:
      {utp/ut-table.i mginv ordem-inv 1 }
      run utp/ut-msgs.p("show",56,return-value).
      apply 'entry' to  movto-estoq.num-ord-inv in frame {&frame-name}.
      return "nok":U.
   end.
   assign c-desc-ord:screen-value in frame {&frame-name} = c-desc-ord-inv. 
   if valid-handle(h_v09in218) and p-altera-conta then 
      run pi-sugere-contas in h_v09in218(c-conta-inv,
                                         c-ccusto-inv,
                                         c-par-inv = "yes":U).
end.              
else do:
  if valid-handle(h_v09in218) then 
     run pi-sugere-contas in h_v09in218("",
                                        "",
                                        yes).
end.

return "ok":U.

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
  def var l-seleciona as logical init no no-undo.
  DEF VAR l-erro-fifo AS LOGICAL INIT no NO-UNDO.

  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
  /* Chamada EPC para a assign record */

     
   /* Chamada EPC para a pi-validate */
  {include/i-epc002.i}


/* Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":u, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

if  not avail item then do:
   {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":u, input 166, input return-value).
    apply "entry" to movto-estoq.it-codigo in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.

if item.tipo-con-est = 4  
    and not can-find(first ref-item 
                     where ref-item.it-codigo = input frame {&frame-name} movto-estoq.it-codigo 
                       and ref-item.cod-refer = input frame {&frame-name} movto-estoq.cod-refer) then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 33928,
                       input input frame {&frame-name} movto-estoq.cod-refer + "~~" + input frame {&frame-name} movto-estoq.it-codigo).
    apply 'entry' to movto-estoq.cod-refer in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.

FOR FIRST estabelec FIELDS(cod-estabel) WHERE estabelec.cod-estabel = movto-estoq.cod-estabel:SCREEN-VALUE IN FRAME {&frame-name} NO-LOCK: END.

IF NOT AVAIL estabelec OR movto-estoq.cod-estabel:SCREEN-VALUE IN FRAME {&frame-name} = "" THEN DO:

    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 4802,
                       input "").
    apply 'entry' to movto-estoq.cod-estabel in frame {&frame-name}.
    return 'ADM-ERROR':U.

END.

if  avail item then do with frame {&frame-name}:
    if item.tipo-con-est <> 4 then do:
        if input frame {&frame-name} movto-estoq.cod-refer <> " " and
           input frame {&frame-name} movto-estoq.cod-refer <> ? then do:
           {include/i-vldprg.i}
           run utp/ut-msgs.p (input "show":u, input 4158, input return-value).
           return 'ADM-ERROR':U.
        end.
    end.
end.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "tipo-trans").
assign i-ent = int(return-value).

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "quantidade":U).
assign de-qtd = dec(return-value).

FOR FIRST deposito FIELDS(cod-depos log-gera-wms) WHERE deposito.cod-depos = input frame {&frame-name} movto-estoq.cod-depos NO-LOCK: END.

if avail deposito AND
    deposito.log-gera-wms = yes AND
    de-qtd         > 0 then do:     
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":u, 
                       input 27697, 
                       input frame {&frame-name} movto-estoq.cod-depos).
    if return-value = "no" then
        return 'ADM-ERROR':U.   
end.

IF NOT AVAIL deposito OR input frame {&frame-name} movto-estoq.cod-depos = "" THEN DO:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":u, 
                       input 530, 
                       input "").
    apply 'entry' to movto-estoq.cod-depos in frame {&frame-name}.
    return 'ADM-ERROR':U.  
END.

if  item.tipo-con-est = 2 and de-qtd <> 0 and i-ent = 1 then do:
    find first b-saldo use-index lote
        where b-saldo.lote        = input frame {&frame-name} movto-estoq.lote
        and   b-saldo.it-codigo   = item.it-codigo
        and   b-saldo.qtidade-atu > 0
        no-lock no-error.
    if  avail b-saldo
    and b-saldo.qtidade-atu > 0 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":u, input 2704, input return-value).
        return 'ADM-ERROR':U.
    end.
end.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "dt-trans").

/* Validaá∆o da ordem de Investimento */
if input frame {&frame-name} movto-estoq.num-ord-inv <> 0 then do:
   run pi-valida-ordem-investimento (input no).
   if return-value = "nok" then return 'ADM-ERROR':U.
end.   

find localizacao
    where localizacao.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel
    and   localizacao.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos
    and   localizacao.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz
    no-lock no-error.
if  not avail localizacao
and movto-estoq.cod-localiz:sensitive in frame {&frame-name} = yes then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":u, input 6662, input return-value).
    apply "entry" to movto-estoq.cod-localiz in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.

if  avail item and item.cod-obsoleto = 3 then do:
   {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":u, 
                       input 1779, 
                       input return-value).
    if return-value = "no" then return 'ADM-ERROR':U.  
end.

if substring(param-estoq.char-2,1,1) <> "#" then do:
    find first saldo-estoq
        where saldo-estoq.cod-refer = input frame {&frame-name} movto-estoq.cod-refer
        and   saldo-estoq.it-codigo = input frame {&frame-name} movto-estoq.it-codigo
        no-lock no-error.
    if  avail saldo-estoq
    and saldo-estoq.cod-refer <> input frame {&frame-name} movto-estoq.cod-refer then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":u, input 1785, input return-value).
        return 'ADM-ERROR':U.
    end.
end.

if  item.tipo-con-est <> 1
and input frame {&frame-name} movto-estoq.lote = " " 
and movto-estoq.lote:sensitive in frame {&frame-name} = yes then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":u, input 1818, input return-value).
    apply "entry" to movto-estoq.lote in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "tipo-trans").

assign c-tp-trans = return-value.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "quantidade":U).
assign c-quantidade = return-value.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "tipo-trans").
if  int(return-value) = 1  and 
    dec(c-quantidade) <> 0 and
    v_titulo_cta_ctbl <> "" and
   (lookup({adinc/i05ad049.i 4 2}, v_ind_finalid_cta) <> 0 or
    lookup({adinc/i05ad049.i 4 7}, v_ind_finalid_cta) <> 0 or
    lookup({adinc/i05ad049.i 4 8}, v_ind_finalid_cta) <> 0 ) then do:
    /* can-do("2,7,8",string(conta -contab.estoque) */ 
   {include/i-vldprg.i}
   run utp/ut-msgs.p (input "show":u, 
                      input 1789,
                      input " ").
   if return-value = "no" then
      assign l-entrada = no.
   else                 
      assign l-entrada = yes.
end.

assign de-saldo-atual = 0
       de-saldo-calc  = 0.

FOR FIRST saldo-estoq FIELDS(qtidade-atu qt-aloc-prod qt-alocada qt-aloc-ped)    where 
     saldo-estoq.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo   and
     saldo-estoq.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel and
     saldo-estoq.cod-depos   = input frame {&frame-name} movto-estoq.cod-depos   and
     saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz and
     saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote        and
     saldo-estoq.cod-refer   = input frame {&frame-name} movto-estoq.cod-refer NO-LOCK: END.

/* Verificacao de saldo negativo */

if avail saldo-estoq THEN
   assign de-saldo-atual = (saldo-estoq.qtidade-atu 
                         -  saldo-estoq.qt-aloc-prod
                         -  saldo-estoq.qt-alocada
                         -  saldo-estoq.qt-aloc-ped). 

assign de-saldo-calc  = if c-tp-trans = "1" then
                            de-saldo-atual + decimal(c-quantidade)
                         else 
                            de-saldo-atual - decimal(c-quantidade).

RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT this-procedure,
     OUTPUT c-handle).

FOR FIRST item-uni-estab FIELDS(perm-saldo-neg metodo-custeio) where
          item-uni-estab.it-codigo   = input frame {&frame-name} movto-estoq.it-codigo and
          item-uni-estab.cod-estabel = input frame {&frame-name} movto-estoq.cod-estabel NO-LOCK:
END.

if avail item-uni-estab and item-uni-estab.perm-saldo-neg = 2 and /* Permite Saldo Negado = Sim Confirmado*/
  (de-saldo-calc < 0) and 
  i-ent = 2 then do: /*SaÌda*/
  run utp/ut-msgs.p (input "show",
                      input 1897,
                      input string(de-saldo-atual)).
  if return-value = "no" then do:
      run select-page in widget-handle(c-handle) (2).
      run pi-focu-campo in h_v14in218.
      return "adm-error".      
  end.
end.

&if defined(bf_mat_custeio_item) &then
    /************************************************
    ** Release 2.04A - Metodo de custeio FIFO/LIFO **
    ** Verifica se foi selecionado o saldo-custo   **
    ** para sofrer o acerto pela TD                **
    ************************************************/
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "quantidade":U).
    if avail item-uni-estab and
       (item-uni-estab.metodo-custeio = 2 /* LIFO */ or
        item-uni-estab.metodo-custeio = 3 /* FIFO */) AND 
        dec(return-value) = 0 then do:
        assign l-seleciona = no
               l-erro-fifo = NO.
        run pi-verifica-saldo-custo in h_b01in702 (output l-seleciona,
                                                   OUTPUT l-erro-fifo).
        IF i-ent = 2 and
           l-erro-fifo = YES THEN DO:
            /***************************************************
            ** Saida que deixou o saldo-custo zerado/negativo **
            ***************************************************/
            run utp/ut-msgs.p (input "show",
                   input 26238,
                   input "").
            run select-page in widget-handle(c-handle) (3).
            return "adm-error".

        END.
        if not l-seleciona then do:
            /*****************************************************
            ** valor digitado no folder Valores nao confere com **
            ** os totais dos valores rateados para os  saldos-  **
            ** custos                                           **
            *****************************************************/
            run utp/ut-msgs.p (input "show",
                               input 26116,
                               input "").
            run select-page in widget-handle(c-handle) (3).
            return "adm-error".
        end.
    end.

&endif

    IF  i-pais-impto-usuario = 2
    AND CAN-FIND(FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-cod-despacho-plaza" AND funcao.ativo) THEN DO:

        IF  c-tp-trans = "2" /* Sa°da */ THEN DO:
            IF  NOT VALID-HANDLE(h-boar202155) THEN
                RUN local/arg/boar202155.p PERSISTENT SET h-boar202155.

            /* o saldo da retirada deve estar dispon°vel no lote original */
            RUN pi-valida-saldo-despacho IN h-boar202155 (INPUT rw-saldo,
                                                          INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.it-codigo,
                                                          INPUT de-qtd,
                                                          OUTPUT TABLE tt-erro).
            IF  RETURN-VALUE = "NOK":U 
            AND CAN-FIND(FIRST tt-erro) THEN DO:
                RUN cdp/cd0666.w (INPUT TABLE tt-erro).
                RETURN "ADM-ERROR":U.
            END.
        END.
    END.

    IF  l-control-aduana-internac 
    AND c-tp-trans = "2" /* Sa°da */ THEN DO:
        RUN validaSaldoDeclar IN h-boin01067 (INPUT movto-estoq.cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                              INPUT movto-estoq.cod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                              INPUT movto-estoq.cod-localiz:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                              INPUT movto-estoq.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                              INPUT movto-estoq.cod-refer:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                              INPUT movto-estoq.lote:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                              INPUT c-despacho:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                              INPUT de-qtd,
                                              OUTPUT TABLE tt-erro).
        IF  RETURN-VALUE = "NOK":U 
        AND CAN-FIND(FIRST tt-erro) THEN DO:
            RUN cdp/cd0666.w (INPUT TABLE tt-erro).
            RETURN "ADM-ERROR":U.
        END.
    END.

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

