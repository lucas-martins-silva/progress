&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1 
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
{include/i-prgvrs.i V08IN218 2.00.00.103} /*** "010003" 07/10/2026 13:43:11 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v08in218 MUT}
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
     cleanup will occur on deletion of the procedure.  */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var i-ordem       like oper-ord.nr-ord-produ   no-undo.
def new global shared var c-serie-movto like movto-estoq.serie       no-undo.
def new global shared var c-it-codigo   like saldo-estoq.it-codigo   no-undo.
def new global shared var v-nr-trans    like movto-estoq.nr-trans.   
def new global shared var c-estab       like saldo-estoq.cod-estabel no-undo.
def new global shared var l-alerta      as log init yes              no-undo.
def new global shared var v-row-parent  as rowid                     no-undo.                                
def new global shared var r-item-docto  as rowid                     no-undo.
def new global shared var i-nr-ord-prod as integer                   no-undo.

def new shared var c-cod-roteiro  like rot-fabric.cod-roteiro.
def new shared var c-op-descricao like operacao.descricao.
def new shared var c-cod-estabel  like estabelec.cod-estabel.
def new shared var c-it-un        like item.un.
def new shared var c-gm-codigo    like operacao.gm-codigo.
def new shared var c-lote-serie   like saldo-estoq.lote.
def new shared var c-deposito     like saldo-estoq.cod-depos.
def new shared var c-fm-codigo    like item.fm-codigo.
def new shared var c-referencia   like saldo-estoq.cod-refer.
def new shared var i-op-codigo    like operacao.op-codigo.
def new shared var i-fi-codigo    like operacao.fi-codigo.
def new shared var i-requis       like movto-estoq.nro-docto.
def new shared var i-ge-codigo    like item.ge-codigo.
def new shared var i-emp050       as char format "x(3)".
def new shared var i-cta050       as char format "x(20)".
def new shared var i-sbc050       as char format "x(20)".
def new shared var c-it-descricao as character format "x(36)".

/* Parameters Definitions ---                                           */

{cdp/cdcfgmat.i}  /* Defini‡Æo preprocessadores materiais*/
{cdp/cdcfgman.i}  /* Defini‡Æo preprocessadores */
{cdp/cdcfgmnt.i}  /* Defini‡Æo preprocessadores manuten‡Æo industrial */
{cdp/cdcfgdis.i}  /* Defini‡Æo preprocessadores Distribuicao*/

/* Include da nova seguran‡a por estabelecimento */
{cdp/cd0031.i "MCE"}

/* Local Variable Definitions ---                                       */

def var i-empresa                        like param-global.empresa-prin  no-undo.
def var i-ficha-cq                       like ficha-cq.nr-ficha          no-undo.
def var i-seq                            like oper-ord.sequencia         no-undo.
def var c-cod-estabel-usuar              like estabelec.cod-estabel      no-undo.
def var c-cod-unid-negoc                 like movto-estoq.cod-unid-negoc no-undo.
def var c-depos-ant                      like movto-estoq.cod-depos      no-undo. /* Dep¢sito Anterior */
def var c-estab-ant                      like movto-estoq.cod-estabel    no-undo. /* Estabelecimento Anterior */
def var de-aux-1                         like ficha-cq.nr-ficha          no-undo.
def var de-saldo-calc                    like aloca-reserva.quant-aloc   no-undo.
def var serie-docto                      like movto-estoq.serie-docto    no-undo.
def var nro-docto                        like movto-estoq.nro-docto      no-undo.
def var numero-ord                       like movto-estoq.nr-ord-produ   no-undo.
def var lote                             like movto-estoq.lote           no-undo.
def var pcod-deposito-pad                like item.deposito-pad          no-undo.
def var pcod-localiz                     like item.cod-localiz           no-undo.
def var ploc-unica                       like item.loc-unica             no-undo.
def var r-saldo-estoq                    as rowid                        no-undo.
def var r-item                           as rowid                        no-undo.
def var r-registro                       as rowid                        no-undo.
def var c-opcao                          as character                    no-undo.
def var c-ant-it-codigo                  as character initial "?"        no-undo.
def var c-conta-inv                      as character format "x(20)"     no-undo.
def var c-ccusto-inv                     as character format "x(20)"     no-undo.
def var c-titulo                         as character format "x(33)"     no-undo.
def var c-par-inv                        as character                    no-undo.
def var c-desc-ord-inv                   as character                    no-undo.
def var c-estabelec                      as character                    no-undo.
def var c_pl_cta_ctbl_atual              as character                    no-undo.
def var c_pl_cta_ctbl_novo               as character                    no-undo.
def var c-docto-repet                    as character                    no-undo.
def var c-serie-repet                    as character                    no-undo.
def var c-conta-repet                    as character                    no-undo.
def var c-descr-repet                    as character                    no-undo.
def var c-ccusto-repet                   as character                    no-undo.
def var c-desc-cc-repet                  as character                    no-undo.
def var c-formato                        as character                    no-undo.
def var c-unid-negoc-repet               as character                    no-undo.
def var c-formato-conta                  as character                    no-undo.
def var c-formato-ccusto                 as character                    no-undo. 
def var v_cod_cta_ctbl                   as character                    no-undo.
def var v_titulo_cta_ctbl                as character                    no-undo.
def var v_ind_finalid_cta                as character                    no-undo.
def var v_cod_ccusto                     as character                    no-undo.
def var v_titulo_ccusto                  as character                    no-undo.
def var i-nr-ord-prod-ant                as integer                      no-undo.
def var i-cont                           as integer                      no-undo.
def var i-conta                          as integer                      no-undo.
def var i-subconta                       as integer                      no-undo.
def var i-ant-anterior                   as integer                      no-undo.
def var i-ordem-repet                    as integer                      no-undo.
def var i-num-inv-repet                  as integer                      no-undo.
def var i-reduz-repet                    as integer                      no-undo.
def var v_num_tip_cta_ctbl               as integer                      no-undo.
def var v_num_sit_cta_ctbl               as integer                      no-undo.
def var l-executou-zoom-ordprod          as logical                      no-undo.
def var l-executou-zoom-item             as logical                      no-undo.
def var l-executou-zoom-estab            as logical                      no-undo.
def var l-executou-zoom-depos            as logical                      no-undo.
def var l-integra-his                    as logical                      no-undo.
def var l-sistema-his-rm                 as logical                      no-undo.
def var l-saldo-novo                     as logical                      no-undo.
def var v_log_utz_ccusto                 as logical                      no-undo.
def var l-x                              as logical                      no-undo.
def var l-achou                          as logical                      no-undo.
def var l-erro-x                         as logical initial no           no-undo.
def var l-implantado-invest              as logical initial no           no-undo.
def var l-primeira                       as logical initial yes          no-undo.
def var l-repetiu                        as logical initial no           no-undo.
def var l-flag                           as logical initial yes          no-undo.
def var l-resp                           as logical format "Sim/Nao"     no-undo.
def var l-confirma                       as logical format "Sim/Nao"     no-undo.
def var l-resposta                       as logical format "Sim/Nao"     no-undo.
def var da-data-repet                    as date                         no-undo.
def var h-cpapi013                       as handle                       no-undo. /* Utilizada na include ce0205.i */ 
def var h-cdapi024                       as handle                       no-undo.
def var h-ceapi001k                      as handle                       no-undo.
def var h-boin029                        as handle                       no-undo.
def var h-boiv029                        as handle                       no-undo.
def var hprogramzoom                     as handle                       no-undo.
def var h_api_cta_ctbl                   as handle                       no-undo.
def var h_api_ccusto                     as handle                       no-undo.
def var de-qtde-atualizada-aloca-reserva as decimal                      no-undo. 
def var de-val-quantidade                as decimal                      no-undo.
def var de-difere-val-quantidade         as decimal                      no-undo.
def var de-fracao-val-quantidade         as decimal                      no-undo.
def var wh-pop-menu                      as widget-handle                no-undo.
def var wh-item1                         as widget-handle                no-undo.
def var wh-item2                         as widget-handle                no-undo.
DEF VAR l-local-assign                   AS LOGICAL                      NO-UNDO.
def var de-saldo-atual                   like saldo-estoq.qtidade-atu    NO-UNDO.
def var de-saldo-movto-calc              like saldo-estoq.qtidade-atu    NO-UNDO.
def var fnc-bloq-movimento               as logical                      no-undo.

def temp-table tt-ficha no-undo
    field cod-depos    like ficha-cq.cod-depos
    field cod-estabel  like ficha-cq.cod-estabel
    field it-codigo    like ficha-cq.it-codigo
    field cod-localiz  like ficha-cq.cod-localiz
    field lote         like ficha-cq.lote
    field nr-ficha     like ficha-cq.nr-ficha
    field nr-ord-produ like ficha-cq.nr-ord-produ
    field op-seq       like ficha-cq.op-seq   
    field nr-ordem     like ficha-cq.nr-ordem
    field nro-docto    like ficha-cq.nro-docto
    field origem       like ficha-cq.origem
    field qt-original  like ficha-cq.qt-original
    field ct-destino   like ficha-cq.ct-destino
    field sc-destino   like ficha-cq.sc-destino
    field serie-docto  like ficha-cq.serie-docto
    field cod-emitente like ficha-cq.cod-emitente
    field nat-operacao like ficha-cq.nat-operacao
    field parcela      like ficha-cq.parcela
    field baixa-estoq  like ficha-cq.baixa-estoq
    field inspecionado like ficha-cq.inspecionado
    field liberada     like ficha-cq.liberada
    field estado       like ficha-cq.estado
    field qt-aprovada  like ficha-cq.qt-aprovada
    field narrativa    like ficha-cq.narrativa.

def temp-table tt-matriz no-undo
    field cod-unid-neg as char
    field perc-rateio  as dec.

def temp-table tt-erro-inv no-undo
    field i-sequen as int
    field cd-erro  as int
    field mensagem as char format "x(255)".

def temp-table tt-erro-aux no-undo
        field i-sequen as int             
        field cd-erro  as int
        field mensagem as char format "x(255)"
        field c-param  as char. 

def temp-table tt-erro-aux2 no-undo
    field i-sequen as int              
    field cd-erro  as int
    field mensagem as char format "x(255)".

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer   format ">>>>,>>9" label "N£mero"         column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)"    label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)"    label "Mensagem Erro"  column-label "Inconsistˆncia".

{cep/ceapi001k.i}  /* Definicao de temp-table do movto-estoq                       */
{cep/ceapi001j.i1} /* Definicao de temp-table tt-movto-un                          */   
{cpp/cpapi013.i}   /* Definicao da temp-table tt-alocacao tt-deposito              */
{cdp/cd0666.i}     /* Definicao da temp-table de erros tt-erro                     */      
{cdp/cd9731.i3}    /* Verifica se utiliza o modulo de investimento l-ce0205-invest */
{cdp/cd9590.i}     /* Include verifica‡Æo Unidade Neg¢cio                          */     

&if defined (bf_man_205) &then
    {cpp/cpapi012.i19} /* Definicao da ttReqOrd */
&endif
&if defined (bf_man_per_ppm) &then
    {cpp/cpapi020.i}
    {cpp/cpapi020.i1} /* Fun‡äes p/ Fator de Concentra‡Æo                    */
&endif

def buffer b-mov-es    for movto-estoq.
def buffer b-movto     for movto-mat.
def buffer b-saldo     for saldo-estoq.
def buffer b-ordem     for ord-prod.     
def buffer b-ord-manut for ord-manut. 

&if defined (bf_man_per_ppm) &then
    if param-global.modulo-per-ppm then
        run cpp/cpapi020.p persistent set h-cpapi020(input-output table tt-balanceia,
                                                     input-output table tt-erro,
                                                     input        yes,
                                                     input-output table tt-veiculos).
&endif

assign l-integra-his = can-find(first funcao where funcao.cd-funcao = "spp-integra-ems-his" and funcao.ativo).
ASSIGN l-sistema-his-rm = CAN-FIND (FIRST funcao WHERE funcao.cd-funcao = "spp-sistema-his-rm":U AND funcao.ativo).

IF CAN-FIND (FIRST funcao 
       WHERE funcao.cd-funcao = "SPP-BLOQ-MOVIMENTO-CE0205" AND funcao.ativo) THEN 
       ASSIGN fnc-bloq-movimento = yes.

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
&Scoped-Define ENABLED-FIELDS movto-estoq.nr-ord-produ ~
movto-estoq.num-ord-inv movto-estoq.cod-unid-negoc 
&Scoped-define ENABLED-TABLES movto-estoq
&Scoped-define FIRST-ENABLED-TABLE movto-estoq
&Scoped-Define ENABLED-OBJECTS RECT-1 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS movto-estoq.dt-trans ~
movto-estoq.nr-ord-produ movto-estoq.num-ord-inv movto-estoq.nro-docto ~
movto-estoq.serie-docto movto-estoq.cod-localiz movto-estoq.cod-refer ~
movto-estoq.lote movto-estoq.quantidade movto-estoq.cod-unid-negoc 
&Scoped-define DISPLAYED-TABLES movto-estoq
&Scoped-define FIRST-DISPLAYED-TABLE movto-estoq
&Scoped-Define DISPLAYED-OBJECTS c-conta-ctbl c-titulo-conta c-ccusto ~
c-titulo-ccusto c-it-codigo-movto c-descricao c-cod-estabel-movto ~
c-desc-estab da-devol c-cod-depos-movto c-desc-depos c-desc-local ~
c-desc-ref dt-vali-lote tog-atualiza c-unid-med-movto c-desc-unid c-desc-un ~
c-it-pai c-roteiro i-operacao c-titulo1 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS movto-estoq.dt-trans movto-estoq.nro-docto ~
movto-estoq.serie-docto c-conta-ctbl c-ccusto movto-estoq.quantidade 
&Scoped-define ADM-ASSIGN-FIELDS c-conta-ctbl c-ccusto 
&Scoped-define ADM-MODIFY-FIELDS c-conta-ctbl c-ccusto 

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
       MENU-ITEM mZoomDep       LABEL "Zoom de Dep¢sitos"
       MENU-ITEM mZoomSalDep    LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-cod-localiz 
       MENU-ITEM mZoomLocal     LABEL "Zoom de Localiza‡äes"
       MENU-ITEM mZoomSalLoc    LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-cod-refer 
       MENU-ITEM mZoomRef       LABEL "Zoom de Referˆncia"
       MENU-ITEM mZoomSalRef    LABEL "Zoom de Saldos".

DEFINE MENU POPUP-MENU-num-ord-inv 
       MENU-ITEM mZoomInv       LABEL "Zoom de Ordem de Investimento"
       MENU-ITEM mZoomOrdProd   LABEL "Zoom de Ord. Inv. X Ord. Prod.".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-ccusto AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-depos-movto AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-movto LIKE estabelec.cod-estabel
     LABEL "Estabel":R7 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-conta-ctbl AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta Cont bil" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-depos AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-local AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ref AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-un AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-unid AS CHARACTER FORMAT "x(15)" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 51.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo-movto AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-pai AS CHARACTER FORMAT "x(16)" 
     LABEL "":R5 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-roteiro AS CHARACTER FORMAT "x(16)" 
     LABEL "Roteiro":R9 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-ccusto AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo-conta AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .58 NO-UNDO.

DEFINE VARIABLE c-unid-med-movto AS CHARACTER FORMAT "xx":U 
     LABEL "Unid Medid" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE da-devol AS DATE FORMAT "99/99/9999":U 
     LABEL "Data de sa¡da" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE dt-vali-lote AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-operacao AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.43 BY 1.67.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 4.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 11.63.

DEFINE VARIABLE tog-atualiza AS LOGICAL INITIAL no 
     LABEL "Atualiza Quantidade Atendida" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.14 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-estoq.dt-trans AT ROW 1.17 COL 16.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     movto-estoq.nr-ord-produ AT ROW 1.21 COL 52.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     movto-estoq.num-ord-inv AT ROW 1.21 COL 78.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     movto-estoq.nro-docto AT ROW 2.21 COL 16.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     movto-estoq.serie-docto AT ROW 2.21 COL 52.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     c-conta-ctbl AT ROW 3.21 COL 16.86 COLON-ALIGNED HELP
          "F5 para zoom"
     c-titulo-conta AT ROW 3.21 COL 37.14 COLON-ALIGNED NO-LABEL
     c-ccusto AT ROW 4.21 COL 16.86 COLON-ALIGNED HELP
          "F5 para zoom"
     c-titulo-ccusto AT ROW 4.21 COL 37.14 COLON-ALIGNED NO-LABEL
     c-it-codigo-movto AT ROW 5.71 COL 17.57 COLON-ALIGNED
     c-descricao AT ROW 5.71 COL 35.14 COLON-ALIGNED NO-LABEL
     c-cod-estabel-movto AT ROW 6.71 COL 17.57 COLON-ALIGNED HELP
          ""
          LABEL "Estabel":R7
     c-desc-estab AT ROW 6.71 COL 29 COLON-ALIGNED NO-LABEL
     da-devol AT ROW 7.71 COL 17.57 COLON-ALIGNED
     c-cod-depos-movto AT ROW 8.71 COL 17.57 COLON-ALIGNED
     c-desc-depos AT ROW 8.71 COL 25.29 COLON-ALIGNED HELP
          "Descri‡Æo do Dep¢sito" NO-LABEL
     movto-estoq.cod-localiz AT ROW 9.71 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     c-desc-local AT ROW 9.71 COL 42.57 COLON-ALIGNED NO-LABEL
     movto-estoq.cod-refer AT ROW 10.71 COL 17.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-desc-ref AT ROW 10.71 COL 30.29 COLON-ALIGNED HELP
          "Descricao da Referencia" NO-LABEL
     movto-estoq.lote AT ROW 11.71 COL 17.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     dt-vali-lote AT ROW 11.71 COL 42.43 COLON-ALIGNED NO-LABEL
     tog-atualiza AT ROW 11.75 COL 59
     movto-estoq.quantidade AT ROW 12.71 COL 17.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     c-unid-med-movto AT ROW 12.71 COL 55 COLON-ALIGNED
     c-desc-unid AT ROW 12.71 COL 60.72 COLON-ALIGNED NO-LABEL
     movto-estoq.cod-unid-negoc AT ROW 13.71 COL 17.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     c-desc-un AT ROW 13.71 COL 23.14 COLON-ALIGNED NO-LABEL
     c-it-pai AT ROW 15.71 COL 9.86 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-roteiro AT ROW 15.71 COL 39.57 COLON-ALIGNED HELP
          "Roteiro de fabrica‡Æo do Item"
     i-operacao AT ROW 15.71 COL 68.14 COLON-ALIGNED
     c-titulo1 AT ROW 14.88 COL 4 NO-LABEL
     RECT-1 AT ROW 15.17 COL 1.57
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 5.5 COL 1
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
         HEIGHT             = 16.13
         WIDTH              = 88.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-ccusto IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN c-cod-depos-movto IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-depos-movto:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-cod-depos:HANDLE.

/* SETTINGS FOR FILL-IN c-cod-estabel-movto IN FRAME f-main
   NO-ENABLE LIKE = mgadm.estabelec.cod-estabel EXP-LABEL               */
/* SETTINGS FOR FILL-IN c-conta-ctbl IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN c-desc-depos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-local IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ref IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-unid IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo-movto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-pai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-roteiro IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-ccusto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-unid-med-movto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       movto-estoq.cod-localiz:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-cod-localiz:HANDLE.

/* SETTINGS FOR FILL-IN movto-estoq.cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       movto-estoq.cod-refer:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-cod-refer:HANDLE.

/* SETTINGS FOR FILL-IN da-devol IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.dt-trans IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN dt-vali-lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-operacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-estoq.nro-docto IN FRAME f-main
   NO-ENABLE 1                                                          */
ASSIGN 
       movto-estoq.num-ord-inv:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-num-ord-inv:HANDLE.

/* SETTINGS FOR FILL-IN movto-estoq.quantidade IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN movto-estoq.serie-docto IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR TOGGLE-BOX tog-atualiza IN FRAME f-main
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
ON ENTRY OF c-ccusto IN FRAME f-main /* Centro Custo */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto V-table-Win
ON ENTRY OF movto-estoq.num-ord-inv IN FRAME f-main /* Ordem Invest */
DO:
    ASSIGN c-par-inv = "".    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto V-table-Win
ON F5 OF c-ccusto IN FRAME f-main /* Centro Custo */
DO:

   run pi_zoom_ccusto in h_api_ccusto (input i-empresa,                                             /* EMPRESA EMS2 */
                                       input "",                                                    /* CODIGO DO PLANO CCUSTO */
                                       input input frame {&frame-name} movto-estoq.cod-unid-negoc,  /* UNIDADE DE NEGOCIO */
                                       input input frame {&frame-name} movto-estoq.dt-trans,        /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,                                         /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,                                      /* DESCRICAO CCUSTO */
                                       output table tt_log_erro).                                   /* ERROS */ 

   ASSIGN c-ccusto:SCREEN-VALUE        = v_cod_ccusto
          c-titulo-ccusto:SCREEN-VALUE = v_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto V-table-Win
ON LEAVE OF c-ccusto IN FRAME f-main /* Centro Custo */
DO:
    
    assign c-ccusto
           c-ccusto:format in frame f-main = "x(20)".
    if c-ccusto:SCREEN-VALUE <> '' then do:
        ASSIGN v_cod_ccusto = INPUT c-ccusto.
        
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,                                      /* EMPRESA EMS2 */
                                                   input  "",                                             /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,                                   /* CCUSTO */
                                                   input input frame {&frame-name} movto-estoq.dt-trans,  /* DATA DE TRANSACAO */
                                                   output v_titulo_ccusto,                                /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro).                             /* ERROS */
        
        ASSIGN c-titulo-ccusto:SCREEN-VALUE    = v_titulo_ccusto.

        /* Retorna formato do centro de custo */
          run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                 input  "",                 /* PLANO CCUSTO */
                                                 input  input frame {&frame-name} movto-estoq.dt-trans,  /* DATA DE TRANSACAO */
                                                 output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                 output table tt_log_erro). /* ERROS */
       if c-formato-ccusto <> "" then
           assign self:format = c-formato-ccusto.
    end.
    else
        assign c-titulo-ccusto:SCREEN-VALUE = ""
               c-ccusto:SCREEN-VALUE = ""
               c-ccusto:format in frame f-main = "x(20)".  
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


&Scoped-define SELF-NAME c-cod-depos-movto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos-movto V-table-Win
ON ENTRY OF c-cod-depos-movto IN FRAME f-main /* Dep¢sito */
DO:
    if not l-executou-zoom-depos then
        assign c-depos-ant = c-cod-depos-movto:screen-value in frame f-main.
    assign l-executou-zoom-depos = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos-movto V-table-Win
ON F5 OF c-cod-depos-movto IN FRAME f-main /* Dep¢sito */
DO:
    assign l-implanta  = yes
           c-estab     = input frame {&FRAME-NAME} c-cod-estabel-movto
           c-it-codigo = input frame {&frame-name} c-it-codigo-movto.

    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = c-cod-depos-movto
        &campo2     = movto-estoq.cod-localiz
        &campo3     = movto-estoq.lote
        &campo4     = movto-estoq.cod-refer
        &campozoom  = cod-depos
        &campozoom2 = cod-localiz
        &campozoom3 = lote
        &campozoom4 = cod-refer}
        
    assign l-executou-zoom-depos = yes.                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos-movto V-table-Win
ON LEAVE OF c-cod-depos-movto IN FRAME f-main /* Dep¢sito */
DO: 
  FOR EACH deposito
     WHERE deposito.cod-depos = input frame {&frame-name} c-cod-depos-movto:

     IF COMPARE(deposito.cod-depos,"MATCHES",input frame {&frame-name} c-cod-depos-movto,"CASE-INSENSITIVE") THEN
         ASSIGN c-desc-depos:screen-value in frame f-main = deposito.nome.
     ELSE DO:
         ASSIGN c-desc-depos:screen-value in frame f-main = "".
     END. 
  END.
  
  /* UNIDADE DE NEGàCIO - 206B
        l-unidade-negocio - Fun‡Æo EMS2-UNIDADE-NEGOCIO cadastrada
   Ordem de produ‡Æo nÆo informada - busca UN pelo dep¢sito
   Unidade de neg¢cio ainda nÆo informada*/
  IF c-desc-depos:screen-value in frame f-main <> "" THEN DO:
      IF   l-unidade-negocio 
      and  input frame {&frame-name} movto-estoq.nr-ord-produ = 0 
      and (input frame {&frame-name} movto-estoq.cod-unid-negoc = "" OR 
           input frame {&frame-name} c-cod-depos-movto <> c-depos-ant) then do:
      
        if valid-handle(h-cdapi024) then
            run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input input frame {&frame-name} c-cod-estabel-movto,
                                                               input input frame {&frame-name} c-it-codigo-movto,
                                                               input input frame {&frame-name} c-cod-depos-movto,
                                                               output c-cod-unid-negoc).
        assign movto-estoq.cod-unid-negoc:screen-value in frame {&frame-name} = c-cod-unid-negoc.
        apply 'leave' to movto-estoq.cod-unid-negoc in frame {&frame-name}.
      END.
      
      {include/leave.i &tabela=tab-unidade
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-unid
                     &where="tab-unidade.un = input frame {&frame-name} c-unid-med-movto"}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos-movto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-depos-movto IN FRAME f-main /* Dep¢sito */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-estabel-movto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel-movto V-table-Win
ON ENTRY OF c-cod-estabel-movto IN FRAME f-main /* Estabel */
DO:
    if not l-executou-zoom-estab then
        assign c-estab-ant = c-cod-estabel-movto:screen-value in frame f-main.

    assign l-executou-zoom-estab = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel-movto V-table-Win
ON F5 OF c-cod-estabel-movto IN FRAME f-main /* Estabel */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=c-cod-estabel-movto
                     &campozoom=cod-estabel}
    assign l-executou-zoom-estab = yes.                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel-movto V-table-Win
ON LEAVE OF c-cod-estabel-movto IN FRAME f-main /* Estabel */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-desc-estab
                   &where="estabelec.cod-estabel = input frame {&frame-name} c-cod-estabel-movto"}.
  if not avail estabelec THEN DO:
      assign c-cod-estabel-movto:screen-value in frame f-main = "":U.
      RUN pi-desformata-campos.
  END.
  ELSE DO:
      IF i-empresa <> estabelec.ep-codigo THEN DO:
          /*Andre*/
          IF  NOT VALID-HANDLE(h_api_cta_ctbl) THEN
              RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
              
          RUN pi_busca_plano_cta_ctbl_empresa IN h_api_cta_ctbl (INPUT i-empresa,
                                                                 INPUT input frame {&frame-name} movto-estoq.dt-trans,
                                                                 OUTPUT c_pl_cta_ctbl_atual,
                                                                 OUTPUT TABLE tt_log_erro).
          
          RUN pi_busca_plano_cta_ctbl_empresa IN h_api_cta_ctbl (INPUT estabelec.ep-codigo,
                                                                 INPUT input frame {&frame-name} movto-estoq.dt-trans,
                                                                 OUTPUT c_pl_cta_ctbl_novo,
                                                                 OUTPUT TABLE tt_log_erro).
          
          ASSIGN i-empresa = estabelec.ep-codigo.
          IF c_pl_cta_ctbl_atual <> c_pl_cta_ctbl_novo THEN DO:
              RUN pi-desformata-campos.
              RUN pi-desformato.
              assign c-conta-ctbl:screen-value in frame {&frame-name}    = "".     
                     c-titulo-conta:screen-value in frame {&frame-name}  = "".
                     c-ccusto:screen-value in frame {&frame-name}        = "".           
                     c-titulo-ccusto:screen-value in frame {&frame-name} = "".
              RUN pi-formato.
          END.
      END.
  END.

  assign c-estabelec = input frame {&frame-name} c-cod-estabel-movto.

  if  l-unidade-negocio and
      input frame {&frame-name} movto-estoq.nr-ord-produ = 0           and  
      input frame {&frame-name} c-cod-estabel-movto <> c-estab-ant and 
      c-cod-depos-movto:screen-value in frame {&frame-name}   <> "" then do:

      if valid-handle(h-cdapi024) then
          run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input input frame {&frame-name} c-cod-estabel-movto,
                                                             input input frame {&frame-name} c-it-codigo-movto,
                                                             input input frame {&frame-name} c-cod-depos-movto,
                                                             output c-cod-unid-negoc).
      assign movto-estoq.cod-unid-negoc:screen-value in frame {&frame-name} = c-cod-unid-negoc.
      apply 'leave' to movto-estoq.cod-unid-negoc in frame {&frame-name}.
  end.
  IF (c-cod-depos-movto:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = "" OR 
      INPUT FRAME {&FRAME-NAME} c-cod-estabel-movto <> c-estab-ant) THEN
      RUN pi-trata-dep-localiz IN THIS-PROCEDURE.

  APPLY "LEAVE" TO c-conta-ctbl IN FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel-movto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel-movto IN FRAME f-main /* Estabel */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-conta-ctbl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-ctbl V-table-Win
ON ENTRY OF c-conta-ctbl IN FRAME f-main /* Conta Cont bil */
DO:
    ASSIGN SELF:FORMAT = "x(20)".
    ENABLE c-ccusto WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-ctbl V-table-Win
ON F5 OF c-conta-ctbl IN FRAME f-main /* Conta Cont bil */
DO:

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,                                      /* EMPRESA EMS2 */
                                                  input  "CEP",                                          /* MàDULO */
                                                  input  "",                                             /* PLANO DE CONTAS */
                                                  input  "(nenhum)",                                     /* FINALIDADES */
                                                  input input frame {&frame-name} movto-estoq.dt-trans,  /* DATA DE TRANSACAO */
                                                  output v_cod_cta_ctbl,                                 /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,                              /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,                              /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro).                             /* ERROS */ 
                                                                                                        
   IF v_titulo_cta_ctbl <> "" THEN
       ASSIGN c-conta-ctbl:SCREEN-VALUE   = v_cod_cta_ctbl
              c-titulo-conta:SCREEN-VALUE = v_titulo_cta_ctbl.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-ctbl V-table-Win
ON LEAVE OF c-conta-ctbl IN FRAME f-main /* Conta Cont bil */
DO:

 if l-flag then do :
    do with frame {&FRAME-NAME}:

        ASSIGN SELF:FORMAT    = "x(20)"
               c-conta-ctbl
               v_cod_cta_ctbl = INPUT c-conta-ctbl.

        /* Busca dados da conta cont bil */
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,                              /* EMPRESA EMS2 */
                                                       input        "",                                     /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,                         /* CONTA */
                                                       input input frame {&frame-name} movto-estoq.dt-trans,/* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,                      /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl,                     /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl,                     /* SITUA›øO DA CONTA */
                                                       output       v_ind_finalid_cta,                      /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).                           /* ERROS */

        IF RETURN-VALUE = "OK" THEN DO:
            IF AVAIL param-global AND param-global.modulo-cp OR
               param-global.modulo-mi THEN
                enable movto-estoq.nr-ord-produ WITH FRAME f-main. 

            ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl
                   SELF:FORMAT       = c-formato-conta WHEN NOT c-formato-conta = "" AND NOT SELF:SCREEN-VALUE = "".
    
            /* Verifica se a conta utiliza centro de custo */
            run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,                                    /* EMPRESA EMS 2 */
                                                               input  c-estabelec,                                  /* ESTABELECIMENTO EMS2 */
                                                               input  "",                                           /* PLANO CONTAS */
                                                               input  v_cod_cta_ctbl,                               /* CONTA */
                                                               input input frame {&frame-name} movto-estoq.dt-trans,/* DATA TRANSACAO */  
                                                               output v_log_utz_ccusto,                             /* UTILIZA CCUSTO ? */
                                                               output table tt_log_erro).                           /* ERROS */


            IF c-par-inv <> "no" THEN
                IF v_log_utz_ccusto THEN
                    ENABLE c-ccusto WITH FRAME {&FRAME-NAME}.
                ELSE DO:
                    ASSIGN c-ccusto:SCREEN-VALUE        = ""
                           c-titulo-ccusto:SCREEN-VALUE = "".
                    DISABLE c-ccusto WITH FRAME {&FRAME-NAME}.
                END.
        END.           
    END.

        ASSIGN c-titulo-conta:SCREEN-VALUE = v_titulo_cta_ctbl.   
 end. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-ctbl V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta-ctbl IN FRAME f-main /* Conta Cont bil */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-it-codigo-movto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo-movto V-table-Win
ON entry OF c-it-codigo-movto IN FRAME f-main /* Item */
DO:
    if not l-executou-zoom-item then
        assign c-ant-it-codigo = input c-it-codigo-movto.
    assign l-executou-zoom-item = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo-movto V-table-Win
ON F5 OF c-it-codigo-movto IN FRAME f-main /* Item */
DO:
   {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                      &campo=c-it-codigo-movto
                      &campozoom=it-codigo
                      &campo2=c-descricao  
                      &campozoom2=desc-item
                      &campo3=c-unid-med-movto  
                      &campozoom3=un} 
   
   assign l-executou-zoom-item = yes.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo-movto V-table-Win
ON F7 OF c-it-codigo-movto IN FRAME f-main /* Item */
DO:
  &if defined (bf_mnt_ems204) &then  
  DEFINE VARIABLE iNrProd LIKE  i-nr-ord-prod NO-UNDO.
  if input frame {&frame-name} movto-estoq.nr-ord-produ <> 0 then do:
      ASSIGN  iNrProd = i-nr-ord-prod
              i-nr-ord-prod = input frame {&frame-name} movto-estoq.nr-ord-produ.
      assign l-implanta = no.
     {include/zoomvar.i &prog-zoom  = "inzoom/z01in390.w"
                        &campo      = c-it-codigo-movto
                        &campozoom  = it-codigo}  

      ASSIGN i-nr-ord-prod = iNrProd
             l-executou-zoom-item = yes.                
  end.
  &endif        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo-movto V-table-Win
ON LEAVE OF c-it-codigo-movto IN FRAME f-main /* Item */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=c-descricao
                     &where="item.it-codigo = input frame {&frame-name} c-it-codigo-movto"}.
                     
    if c-ant-it-codigo <> input c-it-codigo-movto then do:
       &if  defined(bf_dis_default_UN) &then   
            find first param-mat no-lock no-error.
            if  avail param-mat and
                param-mat.ind-sit-un = 2 then do:
                {include/leave.i &tabela                = item
                                 &atributo-ref          = un
                                 &variavel-ref          = c-unid-med-movto
                                 &where="item.it-codigo = input frame {&frame-name} c-it-codigo-movto"}.
            end.
       &endif
		
		FIND FIRST item no-lock
			 WHERE item.it-codigo   = input frame {&frame-name} c-it-codigo-movto NO-ERROR.		
						
	   {include/leave.i &tabela=tab-unidade
	   				    &atributo-ref=descricao
	   				    &variavel-ref=c-desc-unid
	   				    &where="tab-unidade.un = c-unid-med-movto"}.							

       find ord-prod where ord-prod.nr-ord-produ = input frame {&frame-name} movto-estoq.nr-ord-produ no-lock no-error.
       if avail item then do:
          
          assign c-unid-med-movto = item.un.
          
          if not avail ord-prod then do:
              assign c-cod-estabel-movto:screen-value in frame f-main = item.cod-estabel.
    
              find estabelec where estabelec.cod-estabel = c-cod-estabel-movto:screen-value in frame f-main no-lock no-error.
          
              if avail estabelec then do: 
                  assign c-desc-estab:screen-value in frame f-main = estabelec.nome.
              end.
              else do:
                  assign c-desc-estab:screen-value in frame f-main = "":U.
              end.
          end.		  

          if item.tipo-con-est = 4 then do:
             if avail ord-prod then do:
                disp ord-prod.cod-refer @ movto-estoq.cod-refer with frame {&frame-name}.
                disp ord-prod.cod-estabel @ c-cod-estabel-movto with frame {&frame-name}.
             end.
             enable movto-estoq.cod-refer with frame {&frame-name}.
          end.
          else do:
             assign movto-estoq.cod-refer:screen-value in frame {&frame-name} = string(" ").
             disable movto-estoq.cod-refer with frame {&frame-name}.
          end.         

          if item.tipo-con-est <> 1 then do:
             enable movto-estoq.lote with frame {&frame-name}.
          end.
          else do:
             assign movto-estoq.cod-refer:screen-value in frame {&frame-name} = string(" ")
                    movto-estoq.lote     :screen-value in frame {&frame-name} = string(" ").
             APPLY 'leave' TO movto-estoq.lote IN FRAME {&frame-name}.
             disable movto-estoq.lote with frame {&frame-name}.
          end.

          if item.tipo-con-est <> 2 then do:
             enable movto-estoq.quantidade with frame {&frame-name}.
          end.
          else do:
             assign movto-estoq.quantidade:screen-value in frame {&frame-name} = string(1).
             disable movto-estoq.quantidade with frame {&frame-name}.
          end.

          if item.tipo-con-est = 2 then do:
             disp 1 @ movto-estoq.quantidade with frame {&frame-name}.
          end.      
       end.

       IF (c-cod-depos-movto:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = "" OR 
        c-ant-it-codigo <> INPUT FRAME {&frame-name} c-it-codigo-movto) then
        RUN pi-trata-dep-localiz IN THIS-PROCEDURE.

       if  l-unidade-negocio and
           input frame {&frame-name} movto-estoq.nr-ord-produ = 0             and
           c-cod-estabel-movto:screen-value in frame {&frame-name} <> ""  and
           c-cod-depos-movto:screen-value   in frame {&frame-name} <> ""  then do:
           if valid-handle(h-cdapi024) then
              run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input input frame {&frame-name} c-cod-estabel-movto,
                                                                 input input frame {&frame-name} c-it-codigo-movto,
                                                                 input input frame {&frame-name} c-cod-depos-movto,
                                                                 output c-cod-unid-negoc).
          assign movto-estoq.cod-unid-negoc:screen-value in frame {&frame-name} = c-cod-unid-negoc.
          apply 'leave' to movto-estoq.cod-unid-negoc in frame {&frame-name}.
       end.
    end.

    APPLY "LEAVE" TO c-conta-ctbl IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo-movto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-it-codigo-movto IN FRAME f-main /* Item */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-it-pai
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-pai V-table-Win
ON LEAVE OF c-it-pai IN FRAME f-main
DO:
    FIND FIRST reservas 
        WHERE reservas.nr-ord-produ =  INPUT FRAME {&FRAME-NAME} movto-estoq.nr-ord-produ 
              AND reservas.it-codigo      =  INPUT FRAME {&frame-name} c-it-pai NO-LOCK NO-ERROR.
  IF NOT AVAIL reservas THEN DO:
      FIND FIRST ord-prod 
           WHERE ord-prod.nr-ord-produ = INPUT FRAME {&FRAME-NAME} movto-estoq.nr-ord-produ 
           AND   ord-prod.it-codigo   = INPUT FRAME {&frame-name} c-it-pai NO-LOCK NO-ERROR. 
      IF NOT AVAIL ord-prod THEN DO:
             /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Item nao pertence a ordem." *}
          RUN utp/ut-msgs.p (INPUT "show":U,
                             INPUT  17242,  
                             INPUT RETURN-VALUE).
          ASSIGN c-it-pai:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".    
      END.
  END.
  IF c-it-pai:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
    FIND FIRST ord-prod 
            WHERE ord-prod.nr-ord-produ = INPUT FRAME {&FRAME-NAME} movto-estoq.nr-ord-produ NO-LOCK NO-ERROR.
    ASSIGN c-it-pai:SCREEN-VALUE IN FRAME {&frame-name} = ord-prod.it-codigo.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-roteiro V-table-Win
ON F5 OF c-roteiro IN FRAME f-main /* Roteiro */
DO:
     {include/zoomvar.i &prog-zoom=inzoom/z01in400.w
                      &campo=c-roteiro
                                &campozoom=cod-roteiro
                                &parametros="run pi-seta-inicial in wh-pesquisa (input INPUT FRAME {&FRAME-NAME} c-it-pai)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-roteiro V-table-Win
ON LEAVE OF c-roteiro IN FRAME f-main /* Roteiro */
DO:
  ASSIGN c-roteiro = INPUT FRAME {&FRAME-NAME} c-roteiro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-roteiro IN FRAME f-main /* Roteiro */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-unid-med-movto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-med-movto V-table-Win
ON F5 OF c-unid-med-movto IN FRAME f-main /* Unid Medid */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in417.w"
                   &campo=c-unid-med-movto
                   &campozoom=un
				   &campo2=c-desc-unid
                   &campozoom2=descricao}				   
  				   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-med-movto V-table-Win
ON LEAVE OF c-unid-med-movto IN FRAME f-main /* Unid Medid */
DO:
  {include/leave.i &tabela=tab-unidade
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-unid
                   &where="tab-unidade.un = input frame {&frame-name} c-unid-med-movto"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-med-movto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-unid-med-movto IN FRAME f-main /* Unid Medid */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON F5 OF movto-estoq.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} c-cod-depos-movto

    assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} c-cod-estabel-movto
        c-it-codigo = input frame {&frame-name} c-it-codigo-movto.

    {include/zoomvar.i &prog-zoom  = "inzoom/z02in403.w"
        &campo      = movto-estoq.cod-localiz
        &campozoom  = cod-localiz
        &campo2     = c-cod-depos-movto
        &campozoom2 = cod-depos
        &campo3     = movto-estoq.lote
        &campozoom3 = lote
        &campo4     = movto-estoq.cod-refer
        &campozoom4 = cod-refer
        &parametros = "run pi-inicializa-paginas in wh-pesquisa.
                       run pi-set-faixa-dep in wh-pesquisa
                                        ({&deposito}, {&deposito})."}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON LEAVE OF movto-estoq.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
  {include/leave.i &tabela=localizacao
                   &atributo-ref=descricao 
                   &variavel-ref=c-desc-local
                   &where="localizacao.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-refer V-table-Win
ON F5 OF movto-estoq.cod-refer IN FRAME f-main /* Referˆncia */
DO:
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} c-cod-depos-movto

    assign
        l-implanta = yes
        c-estab     = input frame {&FRAME-NAME} c-cod-estabel-movto
        c-it-codigo = input frame {&frame-name} c-it-codigo-movto.

    {include/zoomvar.i  &prog-zoom  = "inzoom/z02in403.w"
        &campo      = movto-estoq.cod-localiz
        &campozoom  = cod-localiz
        &campo2     = c-cod-depos-movto
        &campozoom2 = cod-depos
        &campo3     = movto-estoq.lote
        &campozoom3 = lote
        &campo4     = movto-estoq.cod-refer
        &campozoom4 = cod-refer
        &parametros = "run pi-inicializa-paginas in wh-pesquisa.
                       run pi-set-faixa-dep in wh-pesquisa
                                        ({&deposito}, {&deposito})."}                   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-refer V-table-Win
ON LEAVE OF movto-estoq.cod-refer IN FRAME f-main /* Referˆncia */
DO:
  {include/leave.i &tabela=referencia
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-ref
                   &where="referencia.cod-refer = input frame {&frame-name} movto-estoq.cod-refer"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-refer IN FRAME f-main /* Referˆncia */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-unid-negoc V-table-Win
ON F5 OF movto-estoq.cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
   {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                             &FieldZoom1="cod-unid-negoc"
                             &FieldScreen1="movto-estoq.cod-unid-negoc"
                             &Frame1="f-main"
                             &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-unid-negoc V-table-Win
ON LEAVE OF movto-estoq.cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
  {include/leave.i &tabela=unid-negoc
                         &atributo-ref=des-unid-negoc
                         &variavel-ref=c-desc-un
                         &where="unid-negoc.cod-unid-negoc = input frame {&frame-name} movto-estoq.cod-unid-negoc"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.cod-unid-negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-operacao V-table-Win
ON F5 OF i-operacao IN FRAME f-main
DO:
   ASSIGN i-ordem = INPUT FRAME {&FRAME-NAME} movto-estoq.nr-ord-produ.
   {include/zoomvar.i &prog-zoom="inzoom/z02in260.w"
                      &campo=i-operacao
                      &campozoom=op-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-operacao V-table-Win
ON LEAVE OF i-operacao IN FRAME f-main
DO:
  ASSIGN i-operacao = INPUT FRAME {&FRAME-NAME} i-operacao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-operacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-operacao IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.lote V-table-Win
ON F5 OF movto-estoq.lote IN FRAME f-main /* Lote/S‚rie */
DO:
    Apply "F5" to movto-estoq.cod-localiz in frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.lote V-table-Win
ON LEAVE OF movto-estoq.lote IN FRAME f-main /* Lote/S‚rie */
DO:
  find first saldo-estoq where
        saldo-estoq.lote         = input frame {&frame-name} movto-estoq.lote        and
        saldo-estoq.it-codigo    = input frame {&frame-name} c-it-codigo-movto   
        no-lock no-error.
   if not avail saldo-estoq then do:
      if item.tipo-con-est = 3 or
         item.tipo-con-est = 4 then do:
         enable dt-vali-lote with frame {&frame-name}.
         apply "entry" TO dt-vali-lote IN FRAME {&frame-name}.
         return no-apply.
      end.
   end.
   else do:  
      disable dt-vali-lote with frame {&frame-name}.
      assign  dt-vali-lote:screen-value in frame {&frame-name} = string(saldo-estoq.dt-vali-lote).
   end.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.lote V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.lote IN FRAME f-main /* Lote/S‚rie */
DO:
    Apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomDep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomDep V-table-Win
ON CHOOSE OF MENU-ITEM mZoomDep /* Zoom de Dep¢sitos */
DO:
{include/zoomvar.i &prog-zoom  = "inzoom/z01in084.w"
                   &campo       = "c-cod-depos-movto"
                   &campo2      = "c-desc-depos"
                   &campozoom   = "cod-depos"
                   &campozoom2  = "nome"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomInv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomInv V-table-Win
ON CHOOSE OF MENU-ITEM mZoomInv /* Zoom de Ordem de Investimento */
DO:
    {include/zoomvar.i &prog-zoom = "ivzoom/z05iv043.w"
                     &campo     = movto-estoq.num-ord-inv
                     &campozoom = num-ord-magnus}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomLocal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomLocal V-table-Win
ON CHOOSE OF MENU-ITEM mZoomLocal /* Zoom de Localiza‡äes */
DO:
    &SCOPED-DEFINE estab    input frame {&FRAME-NAME} c-cod-estabel-movto
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} c-cod-depos-movto

    {include/zoom.i  &prog-zoom   = "inzoom/z02in189.w"
        &tabela      = movto-estoq
        &atributo    = cod-localiz
        &parametros  = "run pi-faixa in wh-pesquisa
                            ({&estab}, {&deposito}, {&deposito})."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomOrdProd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomOrdProd V-table-Win
ON CHOOSE OF MENU-ITEM mZoomOrdProd /* Zoom de Ord. Inv. X Ord. Prod. */
DO:
    IF AVAIL param-global AND (param-global.modulo-cp OR param-global.modulo-mi) THEN DO:
        {include/zoomvar.i &prog-zoom = "ivzoom/z09iv043.w"
                     &campo      = movto-estoq.num-ord-inv
                     &campozoom  = num-ord-magnus
                     &campo2     = movto-estoq.nr-ord-produ
                     &campozoom2 = nr-ord-produ}
    END.
    ELSE DO:
        {utp/ut-liter.i "Controle_Produ��o_ou_Manuten��o_Industrial_do_Aplicativo_Manufatura" * r}
        RUN utp/ut-msgs.p("show",2082,return-value).
        APPLY 'entry' TO movto-estoq.num-ord-inv IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomRef V-table-Win
ON CHOOSE OF MENU-ITEM mZoomRef /* Zoom de Referˆncia */
DO:
   {include/zoom.i &prog-zoom="inzoom/z01in377.w"
                   &tabela=movto-estoq
                   &atributo=cod-refer} 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mZoomSalDep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalDep V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalDep /* Zoom de Saldos */
DO:
    apply "F5" to  c-cod-depos-movto in frame {&FRAME-NAME}.
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


&Scoped-define SELF-NAME mZoomSalRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mZoomSalRef V-table-Win
ON CHOOSE OF MENU-ITEM mZoomSalRef /* Zoom de Saldos */
DO:
  apply "F5" to movto-estoq.cod-refer in frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.nr-ord-produ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.nr-ord-produ V-table-Win
ON ENTRY OF movto-estoq.nr-ord-produ IN FRAME f-main /* Ordem Produ‡Æo */
DO:
    if not l-executou-zoom-ordprod then
        assign i-nr-ord-prod-ant = input frame {&frame-name} movto-estoq.nr-ord-produ.

    assign l-executou-zoom-ordprod = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.nr-ord-produ V-table-Win
ON F5 OF movto-estoq.nr-ord-produ IN FRAME f-main /* Ordem Produ‡Æo */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in271.w"
                     &campo=movto-estoq.nr-ord-produ
                     &campozoom=nr-ord-produ}

  assign l-executou-zoom-ordprod = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.nr-ord-produ V-table-Win
ON LEAVE OF movto-estoq.nr-ord-produ IN FRAME f-main /* Ordem Produ‡Æo */
DO:
 define var dt-transacao as date no-undo.
   assign dt-transacao = INPUT FRAME {&FRAME-NAME} movto-estoq.dt-trans.
   
   IF  NOT AVAIL param-global  THEN
       FIND FIRST param-global NO-LOCK NO-ERROR.
  
   /**** Verifica se foi informado o n£mero da ordem e habilita F7 p/ zoom das
        reservas da ordem, somente apartir da 2.04 *****/

     &if defined (bf_mnt_ems204) &then  
         if input frame {&frame-name} movto-estoq.nr-ord-produ <> 0 then
            assign  wh-item2:SENSITIVE = YES.
         else
            assign  wh-item2:SENSITIVE = NO.
     &endif 

   ASSIGN tog-atualiza = NO.
   DISP tog-atualiza with frame {&frame-name}.
   DISABLE tog-atualiza WITH FRAME {&FRAME-NAME}.
   find ord-prod where ord-prod.nr-ord-produ = input frame {&frame-name} movto-estoq.nr-ord-produ no-lock no-error.
   
   if avail ord-prod then do:
       assign c-cod-estabel-movto:screen-value in frame f-main = ord-prod.cod-estabel.
       apply "leave" to c-cod-estabel-movto in frame f-main.
   end.	   
   
   if avail ord-prod then do:
        DEF VAR l-unica AS LOGICAL INITIAL YES NO-UNDO.
        FOR EACH oper-ord WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ	
                                AND oper-ord.cod-roteiro    <> "" NO-LOCK:
            IF l-unica = NO THEN DO: 
                 ASSIGN c-it-pai     = ""
                        c-roteiro    = ""
                        i-operacao   = 0.
                DISABLE c-it-pai
                        i-operacao
                        c-roteiro with frame {&frame-name}.
                LEAVE.
            END.
            ELSE DO:
                ASSIGN c-it-pai = ord-prod.it-codigo
                       c-roteiro = oper-ord.cod-roteiro
                       i-operacao = oper-ord.op-codigo.
                ENABLE c-it-pai
                       i-operacao
                       c-roteiro with frame {&frame-name}.
                 ASSIGN l-unica = NO.
            END.
        END.     
       if ord-prod.num-ord-inv > 0 and movto-estoq.num-ord-inv:hidden = NO then
           assign movto-estoq.num-ord-inv:screen-value in frame {&frame-name} = string(ord-prod.num-ord-inv).
       else
           assign movto-estoq.num-ord-inv:screen-value in frame {&frame-name} = "".

       IF  movto-estoq.nr-ord-produ:SCREEN-VALUE <> "0" THEN DO:
           ASSIGN movto-estoq.cod-unid-negoc:SCREEN-VALUE in FRAME {&FRAME-NAME} = ord-prod.cod-unid-negoc.
           DISABLE movto-estoq.cod-unid-negoc WITH FRAME {&FRAME-NAME}.
           APPLY 'LEAVE' TO movto-estoq.cod-unid-negoc IN FRAME {&FRAME-NAME}.
       END.
          
      &IF DEFINED (bf_man_linha_estab) &THEN
        find lin-prod 
            where lin-prod.cod-estabel = ord-prod.cod-estabel
              and lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.                  
        FIND FIRST oper-ord 
            WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ 
              AND oper-ord.cod-roteiro     <> "" NO-LOCK NO-ERROR.
        IF AVAIL oper-ord THEN
            ENABLE c-it-pai i-operacao c-roteiro WITH FRAME {&FRAME-NAME}.
        ELSE
            ENABLE c-it-pai i-operacao WITH FRAME {&FRAME-NAME}.
        IF AVAIL lin-prod 
            AND lin-prod.sum-requis = 2 THEN DO:
            ENABLE tog-atualiza WITH FRAME {&FRAME-NAME}.
            ASSIGN tog-atualiza = YES.
            DISP tog-atualiza with frame {&frame-name}.
        END.
      &ELSE
        FIND lin-prod 
            WHERE lin-prod.nr-linha = ord-prod.nr-linha NO-LOCK NO-ERROR.
        IF AVAIL lin-prod 
            AND lin-prod.sum-requis = 2 THEN DO:
            ENABLE tog-atualiza WITH FRAME {&FRAME-NAME}.
            ASSIGN tog-atualiza = YES.
            DISP tog-atualiza with frame {&frame-name}.
        END.
      &ENDIF
      FIND FIRST oper-ord 
        WHERE oper-ord.nr-ord-produ = INPUT FRAME {&FRAME-NAME} movto-estoq.nr-ord-produ NO-LOCK NO-ERROR.
        ASSIGN c-it-pai = ord-prod.it-codigo.
        display c-it-pai
                i-operacao
                c-roteiro with frame {&frame-name}.
      
      disable c-conta-ctbl with frame {&frame-name}.
      disable c-ccusto with frame {&frame-name}.
      disp ord-prod.ct-codigo @ c-conta-ctbl with frame {&frame-name}.
      disp ord-prod.sc-codigo @ c-ccusto with frame {&frame-name}. 

      IF AVAIL param-global THEN DO:
          
          /* Busca dados da conta contÿbil */
          ASSIGN v_cod_cta_ctbl = ord-prod.ct-codigo.
          run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,           /* EMPRESA EMS2 */
                                                         input        "",                  /* PLANO DE CONTAS */
                                                         input-output v_cod_cta_ctbl,      /* CONTA */
                                                         input        dt-transacao,        /* DATA TRANSACAO */   
                                                         output       v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                         output       v_num_tip_cta_ctbl,  /* TIPO DA CONTA */
                                                         output       v_num_sit_cta_ctbl,  /* SITUA°€O DA CONTA */
                                                         output       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                         output table tt_log_erro).        /* ERROS */ 
        
          /* Busca dados do centro de custo */
          ASSIGN v_cod_ccusto = ord-prod.sc-codigo.
          run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,            /* EMPRESA EMS2 */
                                                     input  "",                   /* CODIGO DO PLANO CCUSTO */
                                                     input  v_cod_ccusto,         /* CCUSTO */
                                                     input  dt-transacao,         /* DATA DE TRANSACAO */
                                                     output v_titulo_ccusto,      /* DESCRICAO DO CCUSTO */
                                                     output table tt_log_erro).   /* ERROS */
            
          assign c-conta-ctbl:screen-value in frame {&frame-name} = v_cod_cta_ctbl.
          assign c-titulo-conta:screen-value in frame {&frame-name} = v_titulo_cta_ctbl.
          assign c-ccusto:screen-value in frame {&frame-name} = v_cod_ccusto.
          assign c-titulo-ccusto:screen-value in frame {&frame-name} = v_titulo_ccusto.          
          
      END.
      disp    tog-atualiza with frame {&frame-name}.
   end. 
   else do:
      ASSIGN  tog-atualiza = NO.
      disp    tog-atualiza with frame {&frame-name}.
      disable tog-atualiza with frame {&frame-name}.
      IF (NOT AVAIL ord-prod)    OR 
       (ord-prod.rep-prod = 1  OR
        ord-prod.rep-prod = 4) THEN DO:
        disp "" @ c-it-pai with frame {&frame-name}.
        disp "" @ c-roteiro with frame {&frame-name}.
        disp 0  @ i-operacao with frame {&frame-name}.
        disable c-it-pai i-operacao c-roteiro with frame {&frame-name}.
    END.
      enable c-conta-ctbl with frame {&frame-name}.
      /*enable c-ccusto with frame {&frame-name}.*/
      assign movto-estoq.num-ord-inv:screen-value in frame {&frame-name} = "".

      /*UNIDADE DE NEGàCIO - 206B*/
      /* l-unidade-negocio - Fun‡Æo EMS2-UNIDADE-NEGOCIO cadastrada*/
      if i-nr-ord-prod-ant <> input frame {&frame-name} movto-estoq.nr-ord-produ and
         l-unidade-negocio then do:
          enable movto-estoq.cod-unid-negoc with frame {&frame-name}.
          if valid-handle(h-cdapi024) then
                        run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input input frame {&frame-name} c-cod-estabel-movto,
                                                             input input frame {&frame-name} c-it-codigo-movto,
                                                             input input frame {&frame-name} c-cod-depos-movto,
                                                             output c-cod-unid-negoc).
          assign movto-estoq.cod-unid-negoc:screen-value in frame {&frame-name} = c-cod-unid-negoc.
          apply 'leave' to movto-estoq.cod-unid-negoc in frame {&frame-name}.
      end.
   end.
   if l-ce0205-invest then do:
       run pi-mostra-invest.
       if movto-estoq.num-ord-inv:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
           apply "entry":U TO movto-estoq.num-ord-inv IN FRAME {&FRAME-NAME}.
           return no-apply.
       end.
   end.
  IF AVAIL ord-prod THEN DO:
    if (ord-prod.rep-prod = 1 or ord-prod.rep-prod = 4) /*and avail reservas*/ then do:
       if avail ord-prod and AVAIL param-global AND param-global.modulo-cp then do:
         &IF DEFINED (bf_man_linha_estab) &THEN
        find lin-prod 
            where lin-prod.cod-estabel = ord-prod.cod-estabel
              and lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.                  
        FIND FIRST oper-ord 
            WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ 
              AND oper-ord.cod-roteiro     <> "" NO-LOCK NO-ERROR.
        IF AVAIL oper-ord THEN
            ENABLE c-it-pai i-operacao c-roteiro WITH FRAME {&FRAME-NAME}.
        ELSE
            ENABLE c-it-pai i-operacao WITH FRAME {&FRAME-NAME}.
        IF AVAIL lin-prod 
            AND lin-prod.sum-requis = 2 THEN DO:
            ENABLE tog-atualiza WITH FRAME {&FRAME-NAME}.
            ASSIGN tog-atualiza = YES.
            DISP tog-atualiza with frame {&frame-name}.
        END.
      &ELSE
        FIND lin-prod 
            WHERE lin-prod.nr-linha = ord-prod.nr-linha NO-LOCK NO-ERROR.
        IF AVAIL lin-prod 
            AND lin-prod.sum-requis = 2 THEN DO:
            ENABLE tog-atualiza WITH FRAME {&FRAME-NAME}.
            ASSIGN tog-atualiza = YES.
            DISP tog-atualiza with frame {&frame-name}.
        END.
      &ENDIF
      FIND FIRST oper-ord 
        WHERE oper-ord.nr-ord-produ = INPUT FRAME {&FRAME-NAME} movto-estoq.nr-ord-produ NO-LOCK NO-ERROR.
        ASSIGN c-it-pai = ord-prod.it-codigo.
        display c-it-pai
                i-operacao
                c-roteiro with frame {&frame-name}.                   
            ENABLE c-it-pai WITH FRAME {&FRAME-NAME}.
            FIND FIRST oper-ord 
                WHERE oper-ord.nr-ord-produ = INPUT FRAME {&FRAME-NAME} movto-estoq.nr-ord-produ NO-LOCK NO-ERROR.
            ASSIGN c-it-pai = ord-prod.it-codigo.
            display c-it-pai
                    i-operacao
                    c-roteiro with frame {&frame-name}.
       end.   
    end.
  END.
  IF (NOT AVAIL ord-prod)    OR 
        (ord-prod.rep-prod = 1  OR
        ord-prod.rep-prod = 4) THEN DO:
        disp "" @ c-it-pai with frame {&frame-name}.
        disp "" @ c-roteiro with frame {&frame-name}.
        disp 0  @ i-operacao with frame {&frame-name}.
        disable c-it-pai i-operacao c-roteiro with frame {&frame-name}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.nr-ord-produ V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.nr-ord-produ IN FRAME f-main /* Ordem Produ‡Æo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.num-ord-inv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.num-ord-inv V-table-Win
ON F5 OF movto-estoq.num-ord-inv IN FRAME f-main /* Ordem Invest */
DO:
    {include/zoomvar.i &prog-zoom = "ivzoom/z05iv043.w"
                       &campo     = movto-estoq.num-ord-inv
                       &campozoom = num-ord-magnus}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.num-ord-inv V-table-Win
ON LEAVE OF movto-estoq.num-ord-inv IN FRAME f-main /* Ordem Invest */
DO:

    if movto-estoq.num-ord-inv:screen-value in frame f-main <> "0" then do:
        
        if movto-estoq.nr-ord-produ:screen-value in frame f-main = "0" then 
            disable movto-estoq.nr-ord-produ with frame f-main.

        IF INPUT FRAME {&FRAME-NAME} movto-estoq.nr-ord-produ <> 0 THEN DO:
            APPLY "leave":U TO movto-estoq.nr-ord-produ IN FRAME {&FRAME-NAME}.
                                
            if l-ce0205-invest then
                run pi-mostra-invest.
        END.
        ELSE DO:
            run inp/in2112b.p (input i-ep-codigo-usuario,
                               input "habilita-conta",
                               output c-par-inv).   

            run inp/in2112a.p (input i-ep-codigo-usuario,
                               input frame {&frame-name} movto-estoq.num-ord-inv,
                               output c-desc-ord-inv,
                               output l-achou,
                               output c-conta-inv,
                               output c-ccusto-inv).
            if l-achou then do:                                         
                
                IF NOT l-local-assign THEN
                     ASSIGN c-conta-ctbl:screen-value in frame {&frame-name} = c-conta-inv
                            c-ccusto:screen-value in frame {&frame-name}     = c-ccusto-inv.
                
                
                APPLY "leave":U TO c-conta-ctbl IN FRAME {&FRAME-NAME}.
                APPLY "leave":U TO c-ccusto IN FRAME {&FRAME-NAME}.
            end.

            IF c-par-inv = "yes" THEN
                ENABLE c-conta-ctbl WITH frame {&frame-name}.
            ELSE DO:  
                DISABLE c-conta-ctbl WITH frame {&frame-name}.
                DISABLE c-ccusto     WITH frame {&frame-name}.
            END.
        end.
        ASSIGN l-local-assign = FALSE.
    END.
    ELSE DO:
        IF AVAIL param-global AND param-global.modulo-cp OR  param-global.modulo-mi THEN 
            enable movto-estoq.nr-ord-produ WITH FRAME f-main.
        ENABLE c-conta-ctbl with frame f-main.
    END.

        RUN recebeEmpresa IN h-boiv029 (INPUT i-empresa).
        RUN retornaMatrizUnidNegoc IN h-boiv029 (INPUT  INPUT FRAME {&FRAME-NAME} movto-estoq.num-ord-inv,
                                                 OUTPUT TABLE tt-matriz,
                                                 OUTPUT TABLE tt-erro-aux2).
 
        for each tt-matriz:
            assign movto-estoq.cod-unid-negoc:screen-value in frame {&Frame-name} = tt-matriz.cod-unid-neg.
            apply "leave" to movto-estoq.cod-unid-negoc.
        end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.num-ord-inv V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.num-ord-inv IN FRAME f-main /* Ordem Invest */
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

    do with frame {&FRAME-NAME}:
        if c-it-codigo-movto:load-mouse-pointer("image/lupa.cur")    then.
        if c-cod-estabel-movto:load-mouse-pointer("image/lupa.cur")  then.
        if c-cod-depos-movto:load-mouse-pointer("image~\rbm.cur")         then.
        if movto-estoq.cod-localiz:load-mouse-pointer("image~\rbm.cur")        then.
        if movto-estoq.cod-refer:load-mouse-pointer("image~\rbm.cur")           then.
        if c-unid-med-movto:load-mouse-pointer("image/lupa.cur")           then.
        if movto-estoq.nr-ord-produ:load-mouse-pointer("image/lupa.cur") then.  
        if c-ccusto:load-mouse-pointer("image/lupa.cur")               then. 
        if c-conta-ctbl:load-mouse-pointer("image/lupa.cur")         then.
        if c-roteiro:load-mouse-pointer("image/lupa.cur")                then.
        if i-operacao:load-mouse-pointer("image/lupa.cur")               then.
        if movto-estoq.lote:load-mouse-pointer("image/lupa.cur")         then.
        if movto-estoq.num-ord-inv:load-mouse-pointer("image~\rbm.cur")    then.
        if movto-estoq.cod-unid-negoc:load-mouse-pointer("image/lupa.cur") then.


        {utp/ut-liter.i Zoom_de_Dep�sitos * L}
        ASSIGN MENU-ITEM mZoomDep:LABEL IN MENU POPUP-MENU-cod-depos = RETURN-VALUE.

        {utp/ut-liter.i Zoom_de_Saldos * L}
        ASSIGN MENU-ITEM mZoomSalDep:LABEL IN MENU POPUP-MENU-cod-depos = TRIM(RETURN-VALUE).

        {utp/ut-liter.i Zoom_de_Localiza��es * L}
        ASSIGN MENU-ITEM mZoomLocal:LABEL IN MENU POPUP-MENU-cod-localiz = TRIM(RETURN-VALUE).

        {utp/ut-liter.i Zoom_de_Saldos * L}
        ASSIGN MENU-ITEM mZoomSalLoc:LABEL IN MENU POPUP-MENU-cod-Localiz = TRIM(RETURN-VALUE).

        {utp/ut-liter.i Zoom_de_Refer�ncias * L}
        ASSIGN MENU-ITEM mZoomRef:LABEL IN MENU POPUP-MENU-cod-refer = TRIM(RETURN-VALUE).

        {utp/ut-liter.i Zoom_de_Saldos * L}
        ASSIGN MENU-ITEM mZoomSalRef:LABEL IN MENU POPUP-MENU-cod-refer = TRIM(RETURN-VALUE).

        {utp/ut-liter.i Zoom_de_Investimentos * L}
        ASSIGN MENU-ITEM mZoomInv:LABEL IN MENU POPUP-MENU-num-ord-inv = RETURN-VALUE.

    end.

    &IF DEFINED (bf_mnt_ems204) &THEN

        create menu wh-pop-menu
            assign popup-only = true
                   title = "popup".
        create menu-item wh-item1
            assign parent = wh-pop-menu
                   label  = "F5 - Zoom de Itens".
        create menu-item wh-item2
            assign parent = wh-pop-menu
                   label  = "F7 - Zoom de Reservas da Ordem".

        ASSIGN c-it-codigo-movto:POPUP-MENU IN FRAME {&frame-name} = wh-pop-menu.

        ON 'CHOOSE' OF wh-item1 DO:
            apply "F5" to c-it-codigo-movto in frame {&frame-name}.
        END.

        ON 'CHOOSE' OF wh-item2 DO:
            apply "F7" to c-it-codigo-movto in frame {&frame-name}.
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

  ASSIGN l-local-assign = NO.

  {utp/ut-liter.i Ordem_Produ��o * C}
  assign c-titulo1:screen-value in frame {&frame-name} = return-value
         c-titulo1                                     = return-value.

  find first param-global no-lock no-error.
  if not avail param-global then do:
     run utp/ut-msgs.p (input "show",
                       input 16,
                       input "").
     return 'adm-error'. 
  end.

  if AVAIL param-global AND param-global.modulo-cp or param-global.modulo-mi then do:
     enable movto-estoq.nr-ord-produ with frame {&frame-name}.
  end.
  else do:
     disable movto-estoq.nr-ord-produ with frame {&frame-name}.
     enable c-conta-ctbl with frame {&frame-name}.
     enable c-ccusto with frame {&frame-name}.
  end.  

  IF AVAIL param-global THEN
      find first empresa where empresa.ep-codigo = param-global.empresa-prin no-lock no-error.

  find first param-estoq no-lock no-error.
  if not avail param-estoq then do:
     run utp/ut-msgs.p (input "show",
                       input 1059,
                       input "").
     return 'adm-error'. 
  end.

  find first param-cq no-lock no-error.

  disp today @ movto-estoq.dt-trans with frame {&frame-name}.

  if  l-repetiu then do:

      FIND movto-estoq WHERE movto-estoq.nr-trans = v-nr-trans NO-LOCK NO-ERROR.

      disp serie-docto @ movto-estoq.serie-docto
           nro-docto @ movto-estoq.nro-docto
           nr-ord-produ @ movto-estoq.nr-ord-produ 
           num-ord-inv @ movto-estoq.num-ord-inv with frame {&frame-name}.
  end.
  if avail param-estoq then do:
     ASSIGN c-cod-estabel-usuar = IF l-seg-ativa-modulo THEN 
                                      IF CAN-FIND(tt_estab_ems2 WHERE tt_estab_ems2.tta_cod_estab = param-estoq.estabel-pad) THEN 
                                          param-estoq.estabel-pad 
                                      ELSE "":U       
                                  ELSE param-estoq.estabel-pad. 
     
     /* Funcao Super/Minas */
     &IF DEFINED(Bf_dis_usuario_estab) &THEN
         IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                              AND funcao.ativo     = YES) THEN DO:
            RUN cdp/cd8702.p (input c-seg-usuario,
                                   INPUT-OUTPUT c-cod-estabel-usuar).
         END.
     &ENDIF
     FOR FIRST estabelec FIELDS(cod-estabel)
         WHERE estabelec.cod-estabel = c-cod-estabel-usuar NO-LOCK:
     END.
     IF NOT AVAIL estabelec THEN
         FOR FIRST estabelec FIELDS(cod-estabel) NO-LOCK:
             ASSIGN c-cod-estabel-usuar = estabelec.cod-estabel.
         END.
     ASSIGN c-estabelec = c-cod-estabel-usuar.
     disp c-cod-estabel-usuar @ c-cod-estabel-movto with frame {&frame-name}.
     apply "leave" to c-cod-estabel-movto in frame {&frame-name}.
  end.

  assign c-serie-movto = input frame {&frame-name} movto-estoq.serie-docto.

    /* Code placed here will execute AFTER standard behavior.    */

  /* Verifica se ‚ a primeira vez que o usu rio entra. Se ele j  efetuou uma vez a 
     uma requisi‡Æo, mostra os dados anteriores nos seus respectivos campos e se
     posiciona no campo item  

                                                               */
  if l-repetiu then do with frame {&FRAME-NAME}:

      display da-data-repet      @ movto-estoq.dt-trans
              i-ordem-repet      @ movto-estoq.nr-ord-produ
              c-docto-repet      @ movto-estoq.nro-docto
              c-serie-repet      @ movto-estoq.serie-docto
              c-conta-repet      @ c-conta-ctbl
              c-descr-repet      @ c-titulo-conta
              c-ccusto           @ c-ccusto
              c-desc-cc-repet    @ c-titulo-ccusto              
              i-num-inv-repet    @ movto-estoq.num-ord-inv
              c-unid-negoc-repet @ movto-estoq.cod-unid-negoc.

      /* Posiciona o cursor no campo it-codigo. Ao inves de simplesmente dar um 
         Apply "Entry" no campo, esta procedure percorre os campos anteriores, 
         aplicando leave --------------------------------------------------------*/
				
	  if input frame {&frame-name} movto-estoq.nr-ord-produ <> "" then	
		 apply 'leave' to movto-estoq.nr-ord-produ in frame {&frame-name}.	

      if c-conta-ctbl <> "" then
         apply 'leave' TO c-conta-ctbl IN FRAME {&FRAME-NAME}.
     
     assign l-flag = no.
     run pi-set-focus(c-it-codigo-movto:handle).
     assign l-flag = yes.

     if i-ordem-repet > 0 then do:
        apply 'leave' to movto-estoq.nr-ord-produ in frame {&frame-name}.
     end.
  end.

  IF input frame {&frame-name} movto-estoq.nro-docto <> "" THEN
    apply "entry":U TO c-it-codigo-movto IN FRAME {&FRAME-NAME}.
  ELSE
    apply "entry":U TO movto-estoq.dt-trans IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN l-local-assign = YES.
apply "LEAVE":U to movto-estoq.num-ord-inv in frame {&frame-name}.

apply "leave":u TO c-conta-ctbl in frame {&frame-name}.

assign de-saldo-atual       = 0
       de-saldo-movto-calc  = 0.

FOR FIRST saldo-estoq FIELDS(qtidade-atu qt-aloc-prod qt-alocada qt-aloc-ped) where 
     saldo-estoq.it-codigo   = input frame {&frame-name} c-it-codigo-movto       and
     saldo-estoq.cod-estabel = input frame {&frame-name} c-cod-estabel-movto     and
     saldo-estoq.cod-depos   = input frame {&frame-name} c-cod-depos-movto       and
     saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz and
     saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote        and
     saldo-estoq.cod-refer   = input frame {&frame-name} movto-estoq.cod-refer NO-LOCK: END.

/* Verificacao de saldo negativo */

if avail saldo-estoq THEN
   assign de-saldo-atual = (saldo-estoq.qtidade-atu 
                         -  saldo-estoq.qt-aloc-prod
                         -  saldo-estoq.qt-alocada
                         -  saldo-estoq.qt-aloc-ped).  

assign de-saldo-movto-calc  = de-saldo-atual - decimal(input frame {&frame-name} movto-estoq.quantidade).

FOR FIRST item-uni-estab FIELDS(perm-saldo-neg metodo-custeio) where
          item-uni-estab.it-codigo   = input frame {&frame-name} c-it-codigo-movto   and
          item-uni-estab.cod-estabel = input frame {&frame-name} c-cod-estabel-movto
          NO-LOCK:
END.

if item-uni-estab.perm-saldo-neg = 2 and /* Permite Saldo Negado = Sim Confirmado*/
  (de-saldo-movto-calc < 0) then do:
  run utp/ut-msgs.p (input "show",
                      input 1897,
                      input string(de-saldo-atual)).
  if return-value = "no" THEN
     return 'ADM-ERROR':U.
end.

IF AVAIL ord-prod THEN DO:
    IF (ord-prod.rep-prod > 1 and ord-prod.rep-prod < 4) THEN DO:
        ASSIGN i-operacao   = INPUT FRAME {&FRAME-NAME} i-operacao
                     c-roteiro      = INPUT FRAME {&FRAME-NAME} c-roteiro.
        IF i-operacao = 0 AND c-roteiro = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            IF fnc-bloq-movimento THEN DO:
                 run utp/ut-msgs.p (input "show", input 57406, INPUT ""). 
                 apply 'entry' to i-operacao in frame {&frame-name}.
                 return 'adm-error':u.        
            END.
            ELSE DO:
                {utp/ut-liter.i "Deseja informar codigo Operacaoo/Roteiro ? ~~ Nao foi informado o cadigo da Operacao ou de Roteiro." *}
                run utp/ut-msgs.p (input "show", input 27100, input RETURN-VALUE).
                IF RETURN-VALUE = "YES" THEN DO:
                    apply 'entry' to i-operacao in frame {&frame-name}.
                    return 'adm-error':u. 
                END.
            END.
        END.
        ELSE DO:
            FIND FIRST oper-ord 
                 WHERE oper-ord.nr-ord-produ = input frame {&frame-name} movto-estoq.nr-ord-produ
                   AND oper-ord.it-codigo   = input frame {&frame-name} c-it-pai 
                   AND oper-ord.op-codigo   = input frame {&frame-name} i-operacao 
                   AND oper-ord.cod-roteiro     = input frame {&frame-name} c-roteiro 
                NO-LOCK NO-ERROR.
               IF NOT AVAIL oper-ord THEN DO:
                   /* Inicio -- Projeto Internacional */
                   {utp/ut-liter.i "Operacao/Roteiro Invalido para Item-Pai." *}
                  run utp/ut-msgs.p (input "show", input 17006, input RETURN-VALUE).
                  apply 'entry' to i-operacao in frame {&frame-name}.
                  return 'adm-error':u. 
               END.
               ELSE
                   ASSIGN i-seq = oper-ord.sequencia.
        END.
    END.
    ELSE
        ASSIGN i-seq = 0.
END.
find ord-prod where ord-prod.nr-ord-produ = input frame {&frame-name} movto-estoq.nr-ord-produ no-lock no-error.
if avail ord-prod then do:
    find ord-manut OF ORD-PROD no-lock no-error.
        assign i-ant-anterior = int(ord-prod.estado).
end.
for each tt-movto exclusive-lock: 
    delete tt-movto. 
end. 
for each tt-movto-un:
    delete tt-movto-un.
end.

if  not frame {&frame-name}:validate() then return 'ADM-ERROR':U.
/***chamada epc/upc de VALIDATE. NÆo retirar pois nÆo est  executando o dispath da assign-records ***/                        
{include/i-epc002.i}
if return-value = "nok" then return 'adm-error'.
 if input frame {&frame-name} movto-estoq.dt-trans > today then do:
    run utp/ut-msgs.p (input "show", input 1788, input "").
     apply 'entry' to movto-estoq.dt-trans in frame {&frame-name}.
     return 'adm-error'.      
 end.
 if l-alerta then do:
    find first b-mov-es where (b-mov-es.esp-docto = 28 or b-mov-es.esp-docto = 5) and
                               b-mov-es.serie-docto = input frame {&frame-name} movto-estoq.serie-docto and
                               b-mov-es.nro-docto   = input frame {&frame-name} movto-estoq.nro-docto no-lock no-error.
    if avail b-mov-es then do:
       run utp/ut-msgs.p (input "show", input 3175, input "").
    end.
 end.

 if AVAIL param-global AND param-global.modulo-cp or 
    param-global.modulo-mi then do on error undo, retry: 

    RUN pi-testa-calib.
    if return-value = "nok" then
        undo, return 'adm-error'.


    if input frame {&frame-name} movto-estoq.nr-ord-produ <> 0 then do:
       find ord-prod where ord-prod.nr-ord-produ = input frame {&frame-name} movto-estoq.nr-ord-produ no-lock no-error.
       if  not avail ord-prod then do:
           run utp/ut-msgs.p (input "show", input 1879, input "").
           apply 'entry' to movto-estoq.nr-ord-produ in frame {&frame-name}.
           return 'adm-error':u. 
       end.
       else do:
          if ord-prod.estado = 8  then do:
             run utp/ut-msgs.p (input "show", input 26830, input "").
             apply 'entry' to movto-estoq.nr-ord-produ in frame {&frame-name}.
             return 'adm-error':u.
          end.
          if ord-prod.estado = 7 then do:
             run utp/ut-msgs.p (input "show",input 26831,input "").
             apply 'entry' to movto-estoq.nr-ord-produ in frame {&frame-name}.
             return 'adm-error'.
          end.

          /*** Verifica se a produ‡Æo trabalha com libera‡Æo de ordens e se a OP est  liberada ****/

          &if defined (bf_man_204) &then 
              find first param-cp no-lock no-error.

              if avail param-cp and
                 substring(param-cp.char-1,8,1) = "1" and
                 (ord-prod.estado = 1 or
                 (ord-prod.estado = 3 and ord-prod.log-1 = no)) then do:
                 run utp/ut-msgs.p (input "show":u, 
                                    input 27723, 
                                    input "" ).
                 apply "entry" to movto-estoq.nr-ord-produ in frame {&frame-name}.
                 return "ADM-ERROR":U.
              end. 

          &endif 
       end.
    end.
 end.

 def var dt-transacao as date no-undo.
 assign dt-transacao = input frame {&frame-name} movto-estoq.dt-trans.
 
/*** Busca dados da conta contÿbil *****************/
 assign c-conta-ctbl:format in frame {&FRAME-NAME} = "x(20)".
 ASSIGN v_cod_cta_ctbl = input frame {&frame-name} c-conta-ctbl.
 
 run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                input        "",                 /* PLANO DE CONTAS */
                                                input-output v_cod_cta_ctbl,     /* CONTA */
                                                input        dt-transacao,       /* DATA TRANSACAO */   
                                                output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                output       v_num_sit_cta_ctbl, /* SITUA°€O DA CONTA */
                                                output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                output table tt_log_erro).       /* ERROS */
 /* Erros Conta Contÿbil */
 FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
 IF AVAIL tt_log_erro THEN DO:
    run utp/ut-msgs.p (input "show", input 17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
    apply 'entry' to c-conta-ctbl in frame {&frame-name}.
    return 'adm-error'.
 END.
         
 if  v_num_sit_cta_ctbl <> 3 then do:
     run utp/ut-msgs.p (input "show",input 443,input "").
     apply 'entry' to c-conta-ctbl in frame {&frame-name}.
     return 'adm-error'.
 end.              

 RUN pi_busca_dados_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        i-empresa,           /* EMPRESA EMS2 */
                                                       INPUT        "CEP":U,             /* M…DULO */
                                                       INPUT        "",                  /* PLANO DE CONTAS */
                                                       INPUT        v_cod_cta_ctbl,      /* CONTA */
                                                       INPUT        dt-transacao,        /* DATA TRANSACAO */   
                                                       OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                       OUTPUT TABLE tt_log_erro).        /* ERROS */ 

 /* Erros Conta Contÿbil */
 FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
 IF AVAIL tt_log_erro THEN DO:
    run utp/ut-msgs.p (input "show", input 17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
    apply 'entry' to c-conta-ctbl in frame {&frame-name}.
    return 'adm-error'.
 END.

  if  v_ind_finalid_cta = "" then do:
     run utp/ut-msgs.p (input "show",input 1884,input "").
     apply 'entry' to c-conta-ctbl in frame {&frame-name}.
     return 'adm-error'.
 end. 

 if lookup({adinc/i05ad049.i 4 4}, v_ind_finalid_cta) <> 0 or
    lookup({adinc/i05ad049.i 4 7}, v_ind_finalid_cta) <> 0 or
    lookup({adinc/i05ad049.i 4 8}, v_ind_finalid_cta) <> 0 or
    lookup({adinc/i05ad049.i 4 9}, v_ind_finalid_cta) <> 0 or
    lookup({adinc/i05ad049.i 4 10}, v_ind_finalid_cta) <> 0 then do:

      run utp/ut-msgs.p (input "show",input 1884,input "").
      apply 'entry' to c-conta-ctbl in frame {&frame-name}.
      return 'adm-error'.
 end.
 if lookup({adinc/i05ad049.i 4 5}, v_ind_finalid_cta) <> 0 then do:
     run utp/ut-msgs.p (input "show",input 8629,input "").
     apply 'entry' to c-conta-ctbl in frame {&frame-name}.
     return 'adm-error'.
 end.      

 IF (input frame {&frame-name} movto-estoq.nr-ord-produ = 0 OR
     input frame {&frame-name} movto-estoq.nr-ord-produ = ?) and
    lookup({adinc/i05ad049.i 4 3}, v_ind_finalid_cta) <> 0 THEN DO:

     run utp/ut-msgs.p (input "show",input 6107,input "").
     apply 'entry' to c-conta-ctbl in frame {&frame-name}.
     return 'adm-error'.

 END.

 /* Verifica se a conta utiliza centro de custo */
 run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                    input  c-estabelec,        /* ESTABELECIMENTO EMS2 */
                                                    input  "",                 /* PLANO CONTAS */
                                                    input  v_cod_cta_ctbl,     /* CONTA */
                                                    input  dt-transacao,       /* DT TRANSACAO */
                                                    output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                    output table tt_log_erro). /* ERROS */
 IF v_log_utz_ccusto THEN DO:
     assign v_cod_ccusto = input c-ccusto.
     run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                input  v_cod_ccusto,       /* CCUSTO */
                                                input  dt-transacao,       /* DATA DE TRANSACAO */
                                                output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                output table tt_log_erro). /* ERROS */
     FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
     IF AVAIL tt_log_erro THEN DO:
        run utp/ut-msgs.p (input "show", input 17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
        apply 'entry' to c-ccusto in frame {&frame-name}.
        return 'adm-error'.
     END.                                               
 END.

 find item where item.it-codigo = input frame {&frame-name} c-it-codigo-movto no-lock no-error.
 IF AVAIL ITEM THEN DO:

     IF l-integra-his AND l-sistema-his-rm = NO  
     AND input frame {&frame-name} movto-estoq.quantidade <> 0
     AND (item.log-orig-ext) THEN DO:
         
         {utp/ut-liter.i "Item" *}
         RUN utp/ut-msgs.p (INPUT "show",
                            INPUT 55079,
                            INPUT RETURN-VALUE).

         apply "entry" to movto-estoq.quantidade in frame {&frame-name}. 
         RETURN "adm-error".

     END.

     find first grup-estoque 
          where grup-estoque.ge-codigo = item.ge-codigo no-lock no-error.

     if  l-integra-his AND l-sistema-his-rm = NO
     and avail grup-estoque 
     and (grup-estoque.log-orig-ext) 
     and input frame {&frame-name} movto-estoq.quantidade <> 0 then do:

         {utp/ut-liter.i "Grupo_de_Estoque" *}
         run utp/ut-msgs.p (input "show",
                            input 55079,
                            input return-value).
         return 'adm-error'.
     end.

     FIND FIRST item-uni-estab no-lock
          WHERE item-uni-estab.it-codigo   = ITEM.it-codigo
            AND item-uni-estab.cod-estabel = input frame {&frame-name} c-cod-estabel-movto NO-ERROR.
     IF AVAIL item-uni-estab THEN DO:
         IF item-uni-estab.cod-obsoleto = 4 THEN DO:
             run utp/ut-msgs.p (input "show",input 25983,input item-uni-estab.it-codigo).
             apply 'entry' to c-it-codigo-movto in frame {&frame-name}.
             return 'adm-error'.
         END.
     END.
     ELSE DO:
         {utp/ut-liter.i "Item x Estabelecimento" *}
         run utp/ut-msgs.p (input "show",input 2,input RETURN-VALUE).
         apply 'entry' to c-it-codigo-movto in frame {&frame-name}.
         return 'adm-error'.
     END.
     if item.it-codigo = "" or item.tipo-contr = 4 then do:
        run utp/ut-msgs.p (input "show",input 1886,input "").
        disp 0 @ movto-estoq.quantidade with frame {&frame-name}.        
        apply 'entry' to c-it-codigo-movto in frame {&frame-name}.
        return 'adm-error'.
     end.
 END.
 ELSE DO:
     {utp/ut-field.i mgind ITEM it-codigo 1}
     RUN utp/ut-msgs.p (input "show",input 2,input RETURN-VALUE).
     apply 'entry' to c-it-codigo-movto in frame {&frame-name}.
     return 'adm-error'.
 END.

 if  avail ord-prod then do:

     if  item.it-codigo = ord-prod.it-codigo and 
         ord-prod.tipo <> 5 and 
         ord-prod.tipo <> 9 then do:
         run utp/ut-msgs.p (input "show", input 2008, input "").
         apply 'entry' to c-it-codigo-movto in frame {&frame-name}.
         return 'adm-error'. 
     end.                     
     find first reservas where reservas.nr-ord-produ = ord-prod.nr-ord-produ and
                               reservas.it-codigo    = input frame {&frame-name} c-it-codigo-movto no-lock no-error.
     if  not avail reservas then do:
         run utp/ut-msgs.p (input "show", input 2148, input return-value).
         if return-value = "no" then do:
            apply 'entry' to c-it-codigo-movto in frame {&frame-name}.
            return 'adm-error'.
         end.
     end.
     else do:
        if  item.tipo-requis = 2 then do:
            run utp/ut-msgs.p (input "show",
                               input 5675,
                               input "").
/*            apply 'entry' to c-it-codigo-movto in frame {&frame-name}.
            return 'adm-error'.*/
        end.
     end.
     if (ord-prod.rep-prod > 1 and ord-prod.rep-prod < 4) or avail reservas then do:
        {cep/ce0205.i1 tog-atualiza}
     end.
     &IF DEFINED (bf_man_linha_estab) &THEN
     find lin-prod 
          where lin-prod.cod-estabel = ord-prod.cod-estabel
            and lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.                  
     &ELSE
     find lin-prod where lin-prod.nr-linha = ord-prod.nr-linha no-lock no-error.
     &ENDIF     

     /*if avail lin-prod and 
        lin-prod.sum-requis = 2 and 
        item.tipo-requis    = 1 then do:*/

        IF tog-atualiza = YES THEN DO:
         find first reservas where 
              reservas.nr-ord-produ = ord-prod.nr-ord-produ and
              reservas.item-pai     = c-it-pai              and
              reservas.cod-roteiro  = c-cod-roteiro         and
              reservas.op-codigo    = i-operacao            and
              reservas.it-codigo    = item.it-codigo no-lock no-error.
         if avail reservas then do:
             find first aloca-reserva where 
                  aloca-reserva.nr-ord-produ = ord-prod.nr-ord-produ and
                  aloca-reserva.it-codigo    = item.it-codigo and
                  aloca-reserva.cod-estabel  = input frame {&frame-name} c-cod-estabel-movto and
                  aloca-reserva.cod-depos    = input frame {&frame-name} c-cod-depos-movto   and
                  aloca-reserva.item-pai     = c-it-pai                                          and
                  aloca-reserva.cod-roteiro  = c-cod-roteiro                                     and
                  aloca-reserva.op-codigo    = i-operacao                                        and
                  aloca-reserva.cod-localiz  = input frame {&frame-name} movto-estoq.cod-localiz and
                  aloca-reserva.lote-serie   = input frame {&frame-name} movto-estoq.lote
                  no-lock no-error.
             if avail aloca-reserva then do:
                 if input frame {&frame-name} movto-estoq.quantidade > aloca-reserva.quant-aloc then do:
                     run utp/ut-msgs.p (input "show",input 1893,input string(input frame {&frame-name} movto-estoq.quantidade) + "~~"
                                                            + string(aloca-reserva.quant-aloc)).
                     if return-value = "no" then do:
                         apply 'entry' to movto-estoq.quantidade in frame {&frame-name}. 
                         return 'adm-error'.
                     end.
                 end.
             end.
         end.
     end.
 end.    
 find estabelec where estabelec.cod-estabel = input c-cod-estabel-movto no-lock no-error.
 IF NOT AVAIL estabelec THEN DO:
     {utp/ut-field.i mgadm estabelec cod-estabel 1}
     RUN utp/ut-msgs.p (input "show",input 2,input RETURN-VALUE).
     apply 'entry' to c-cod-estabel-movto in frame {&frame-name}.
     return 'adm-error'.
 END.
 
 find deposito where deposito.cod-depos = input frame {&frame-name} c-cod-depos-movto no-lock no-error.
 if avail deposito then do:


     IF l-integra-his AND l-sistema-his-rm = NO
     AND (deposito.log-orig-ext) 
     AND INPUT FRAME {&FRAME-NAME} movto-estoq.quantidade <> 0 then do:
         
         {utp/ut-liter.i "Deposito" *}
         run utp/ut-msgs.p (input "show",
                            input 55079,
                            input return-value).
         return 'adm-error'.
     end. 

     if avail estabelec then do:    
         for first item-uni-estab
             fields (contr-qualid)
             where item-uni-estab.it-codigo   = item.it-codigo
             and   item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock.
         end.
     end.

    if deposito.ind-dep-cq = yes and (avail item-uni-estab and item-uni-estab.contr-qualid) then do:
       run utp/ut-msgs.p (input "show",input 1887,input "").
       apply 'entry' to c-it-codigo-movto in frame {&frame-name}.  
       return 'adm-error'. 
    end.
    if deposito.ind-dep-rej = yes and (avail item-uni-estab and item-uni-estab.contr-qualid) then do:
       run utp/ut-msgs.p (input "show",input 1888,input "").
       apply 'entry' to c-cod-depos-movto in frame {&frame-name}.  
       return 'adm-error'. 
    end.
 end.
 ELSE DO:
     {utp/ut-field.i mgind deposito cod-depos 1}
     RUN utp/ut-msgs.p (input "show",input 2,input RETURN-VALUE).
     apply 'entry' to c-cod-depos-movto in frame {&frame-name}.
     return 'adm-error'.
 END.
if item.tipo-con-est > 1 and input frame {&frame-name} movto-estoq.lote = "" then do:
    run utp/ut-msgs.p (input "show",input 2158,input "").
    apply 'entry' to movto-estoq.lote in frame {&frame-name}.
    return 'adm-error'.
 end.

 if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
    find first b-saldo /* use-index lote */
         where b-saldo.lote      = input frame {&frame-name} movto-estoq.lote 
           and b-saldo.cod-refer = input frame {&frame-name} movto-estoq.cod-refer
           and b-saldo.it-codigo = item.it-codigo no-lock no-error.
    if avail b-saldo then do:
       assign dt-vali-lote:screen-value          in frame {&frame-name} = string(b-saldo.dt-vali-lote, "99/99/9999")
              movto-estoq.cod-refer:screen-value in frame {&frame-name} = b-saldo.cod-refer.
       if b-saldo.dt-vali-lote < input frame {&frame-name} movto-estoq.dt-trans then do:
          run utp/ut-msgs.p (input "show",input 1890,input return-value).
          if return-value = "no" then do:
             apply 'entry' to movto-estoq.dt-trans in frame {&frame-name}.  
             return 'adm-error'. 
          end.
       end.
    end.
    else do:
       if input frame {&frame-name} dt-vali-lote = ? then do:
          run utp/ut-msgs.p (input "show",input 2205,input return-value).
          apply 'entry' to dt-vali-lote in frame {&frame-name}.  
          return "ADM-ERROR".
       end.                             
       if input frame {&frame-name} dt-vali-lote < input frame {&frame-name} movto-estoq.dt-trans then do:
          run utp/ut-msgs.p (input "show",  /* data de validade e menor que data da transacao.deseja proseguir? */
                             input 1890,
                             input return-value).
          if return-value = "no" then do:
             apply 'entry' to movto-estoq.dt-trans in frame {&frame-name}.  
             return 'adm-error'. 
          end.
       end. 
       if item.tipo-con-est = 4 then do:
          find referencia where referencia.cod-refer = input frame {&frame-name} movto-estoq.cod-refer no-lock no-error.
          if not avail referencia then do:
             {utp/ut-table.i mgind referencia 1}
             run utp/ut-msgs.p (input "show", input 2, input return-value).
             apply 'entry' to movto-estoq.cod-refer in frame {&frame-name}. 
             return 'adm-error'.
          end.
       end.
    end. 
 end.
 do on error undo, retry:
    FIND tab-unidade WHERE tab-unidade.un = INPUT FRAME {&FRAME-NAME} c-unid-med-movto NO-LOCK NO-ERROR.
    IF AVAIL tab-unidade THEN DO:
        if input frame {&frame-name} c-unid-med-movto <> item.un then do:
           run utp/ut-msgs.p (input "show",input 1571,input "").
           apply 'entry' to c-unid-med-movto in frame {&frame-name}. 
           return 'adm-error':u.
        end.
    END.
    ELSE DO:
        {utp/ut-field.i mgind tab-unidade un 1}
         RUN utp/ut-msgs.p (input "show",input 2,input RETURN-VALUE).
         apply 'entry' to c-unid-med-movto in frame {&frame-name}.
         return 'adm-error'.
    END.
    if input frame {&frame-name} movto-estoq.quantidade <= 0 then do:
       run utp/ut-msgs.p (input "show",input 1368,input "").
       apply 'entry' to movto-estoq.quantidade in frame {&frame-name}. 
       return 'adm-error':u.
    end.

    assign l-resposta = no.        
 end.

 /*UNIDADE DE NEGàCIO - 206B*/
 /* l-unidade-negocio - Fun‡Æo EMS2-UNIDADE-NEGOCIO cadastrada*/
 if l-unidade-negocio 
     and input frame {&frame-name} movto-estoq.cod-unid-negoc <> "" then do: /*UN informada*/


     if not can-find (first unid-negoc
                      where unid-negoc.cod-unid-negoc = input frame {&frame-name} movto-estoq.cod-unid-negoc) then do:
         {utp/ut-table.i mgind unid-negoc 1}
         run utp/ut-msgs.p (input "show", 
                            input 2, 
                            input return-value + '~~' + movto-estoq.cod-unid-negoc:screen-value in frame {&frame-name}).
         apply 'entry' to movto-estoq.cod-unid-negoc in frame {&frame-name}.
         return 'adm-error'.
     end.
 end.

 find saldo-estoq use-index estabel-dep where saldo-estoq.cod-estabel = input frame {&frame-name} c-cod-estabel-movto and
                                              saldo-estoq.cod-depos   = input frame {&frame-name} c-cod-depos-movto   and
                                              saldo-estoq.cod-localiz = input frame {&frame-name} movto-estoq.cod-localiz and
                                              saldo-estoq.lote        = input frame {&frame-name} movto-estoq.lote        and
                                              saldo-estoq.cod-refer   = input frame {&frame-name} movto-estoq.cod-refer   and
                                              saldo-estoq.it-codigo   = item.it-codigo no-lock no-error. /*Alterado para no-lock pois estava causando erro de registro preso*/
 
 {cep/ce0205.i2 tog-atualiza} /* Valida‡Æo de Saldo-Estoq/Quantidade */

 assign lote     = input frame {&frame-name} movto-estoq.lote.

 EMPTY TEMP-TABLE tt-matriz.

  if l-unidade-negocio AND INPUT FRAME {&FRAME-NAME} movto-estoq.num-ord-inv <> 0 then do:
      RUN ivbo/boiv029.p PERSISTENT SET h-boin029.
      FIND FIRST ord-prod 
           WHERE ord-prod.nr-ord-produ = INPUT FRAME {&FRAME-NAME} movto-estoq.nr-ord-produ NO-LOCK NO-ERROR.
      IF AVAIL ord-prod AND ord-prod.origem = "MI"  THEN DO:
      END.
      ELSE DO:
         RUN retornaMatrizUnidNegoc IN h-boin029 (INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.num-ord-inv,
                                                  OUTPUT TABLE tt-matriz,
                                                  OUTPUT TABLE tt-erro-inv).
      END.
      DELETE PROCEDURE h-boin029.
  end.

  if item.fraciona                                      = no  and 
     item.tipo-contr                                   <> 4   and  
     l-unidade-negocio                                  = yes and 
     INPUT FRAME {&FRAME-NAME} movto-estoq.num-ord-inv <> 0   and 
     can-find(first tt-matriz)        then do:
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

bloco: do on error undo:

  IF  l-unidade-negocio                                         AND 
      INPUT FRAME {&FRAME-NAME} movto-estoq.num-ord-inv <> 0    and 
      not can-find(first tt-movto-un)                           THEN DO:

      FIND FIRST ord-prod 
          WHERE ord-prod.nr-ord-produ = INPUT FRAME {&FRAME-NAME} movto-estoq.nr-ord-produ NO-LOCK NO-ERROR.
      IF AVAIL ord-prod AND ord-prod.origem = "MI"  THEN DO:
      END.
      
      IF  CAN-FIND(FIRST tt-erro-inv NO-LOCK) THEN DO:
          RUN cdp/cd0666.w (INPUT TABLE tt-erro-inv).
          APPLY "entry" TO c-it-codigo-movto IN FRAME {&frame-name}.
          RETURN 'ADM-ERROR':U.
      END.
      
      ASSIGN de-val-quantidade = input frame {&frame-name} movto-estoq.quantidade
             de-difere-val-quantidade = input frame {&frame-name} movto-estoq.quantidade.

      IF AVAIL ord-prod AND ord-prod.origem = "MI"  THEN DO:
          RUN pi-cria-tt-movto (INPUT ord-prod.cod-unid-negoc,
                                INPUT 100).
      END.
      ELSE DO:
        FOR EACH tt-matriz:
            RUN pi-cria-tt-movto (INPUT tt-matriz.cod-unid-neg,
                                  INPUT tt-matriz.perc-rateio).
        END.
      END.
      
      FIND FIRST tt-movto NO-ERROR.
      IF   AVAIL tt-movto THEN DO:
           IF  de-difere-val-quantidade <> 0
           AND de-difere-val-quantidade < tt-movto.quantidade THEN
               ASSIGN tt-movto.quantidade = tt-movto.quantidade + de-difere-val-quantidade.
      END.
      
      /* Ajusta quantidade(decimal) caso item nÆo fraciona */
      IF  NOT item.fraciona THEN DO:
          ASSIGN de-fracao-val-quantidade = 0.
          FOR EACH tt-movto
              BREAK BY tt-movto.quantidade:

              ASSIGN de-fracao-val-quantidade = de-fracao-val-quantidade + (tt-movto.quantidade - TRUNC(tt-movto.quantidade,0))
                     tt-movto.quantidade = TRUNC(tt-movto.quantidade,0).

              IF  LAST(tt-movto.quantidade) THEN
                  ASSIGN tt-movto.quantidade = tt-movto.quantidade + de-fracao-val-quantidade.
          END.
      END.

  END.
  ELSE
      RUN pi-cria-tt-movto (INPUT INPUT FRAME {&FRAME-NAME} movto-estoq.cod-unid-negoc,
                            INPUT 100).

    IF  c-nom-prog-upc-mg97 <> "" 
    AND c-nom-prog-upc-mg97 <> ? THEN DO:
    
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "BEFORE-EXECUTE":U, 
                                        INPUT "",
                                        INPUT TEMP-TABLE tt-movto:HANDLE,
                                        INPUT THIS-PROCEDURE, // pssar handle viewer
                                        INPUT "",                                       
                                        INPUT ?).
        IF RETURN-VALUE = "NAO-EXECUTA":U THEN
            RETURN "OK":U.            
    END.                            
 
    run cep/ceapi001k.p persistent set h-ceapi001k.

    run pi-valida-movto-uneg in h-ceapi001k (input table tt-movto-un).

    run pi-execute in h-ceapi001k (input-output table tt-movto,
                                   input-output table tt-erro,
                                   input yes).   

    /* Elimina o handle da ceapi001j, que estava ocasionando bloqueio do registro */
    IF VALID-HANDLE(h-ceapi001k) THEN
        DELETE PROCEDURE h-ceapi001k.

    FIND FIRST tt-erro NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-erro THEN DO:
        if l-ce0205-invest then do:
            IF movto-estoq.num-ord-inv:SCREEN-VALUE IN FRAME f-main <> "0" THEN DO:
                run inp/in2115.p(input-output table tt-movto,
                                 input-output table tt-erro-aux).
                find first tt-erro-aux no-lock no-error.
                if avail tt-erro-aux then do:
                    run cdp/cd0669.w (input table tt-erro-aux).
                    apply "entry" to movto-estoq.num-ord-inv in frame {&frame-name}. 
                    undo bloco, return 'ADM-ERROR':U.
                end.
            END.
        end.
    END.
    ELSE DO:
        run cdp/cd0666.w (input table tt-erro).
        apply "entry" to c-it-codigo-movto in frame {&frame-name}.
        undo bloco, return 'ADM-ERROR':U.
    END.

 end.

 /***chamada epc/upc de ASSIGN. NÆo retirar pois nÆo est  executando o dispath da assign-records ***/                        
FIND FIRST tt-movto NO-ERROR.
FIND FIRST movto-estoq WHERE rowid(movto-estoq) = tt-movto.r-mov-inv NO-LOCK NO-ERROR.
if avail movto-estoq then  
    assign v-nr-trans = movto-estoq.nr-trans.

{include/i-epc003.i}
if return-value = "nok" then
   undo, return 'adm-error'.


RELEASE ord-prod.
RELEASE b-ordem.
RELEASE reservas.

    run pi-registra-dados.
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
  ASSIGN tog-atualiza = NO.
  DISP tog-atualiza with frame {&frame-name}.
  DISABLE tog-atualiza WITH FRAME {&FRAME-NAME}.

  /*assign l-primeira = yes.*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  clear frame {&frame-name}.
  
  disp c-titulo1 with frame {&frame-name}.

  l-repetiu = no.

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

  if VALID-HANDLE (h-cpapi013) then
    run pi-finalizar in h-cpapi013.

  if VALID-HANDLE (h-cdapi024) then
      delete procedure h-cdapi024.

  IF VALID-HANDLE (h-boiv029) THEN
      DELETE PROCEDURE h-boiv029.

  /* Elimina handle's */
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

  disable movto-estoq.cod-localiz with frame {&frame-name}.

  DISABLE c-it-codigo-movto
          c-cod-estabel-movto
          c-cod-depos-movto
          c-unid-med-movto WITH FRAME {&FRAME-NAME}.

  if l-ce0205-invest then
    run pi-mostra-invest.

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

  /* Handle da API Conta Contÿbil */
  run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
  /* Handle da API Centro Custo */
  run prgint/utb/utb742za.py persistent set h_api_ccusto.  

  FOR FIRST estabelec FIELDS(ep-codigo)
      WHERE estabelec.cod-estabel = c-estabelec NO-LOCK:
      ASSIGN i-empresa = estabelec.ep-codigo.
      RUN pi-formato.
      RUN pi-formata-campos.
  END.
  IF NOT AVAIL estabelec THEN DO:
      RUN pi-desformata-campos.
      RUN pi-desformato.
  END.

  if avail movto-estoq then do:

     find item where item.it-codigo = c-it-codigo-movto no-lock no-error.
     if avail item then do:
        assign c-descricao = item.desc-item.
     end.
     else do:
        assign c-descricao = "":U.
     end.

     find estabelec where estabelec.cod-estabel = c-cod-estabel-movto no-lock no-error.
     if avail estabelec then do:    
        assign c-desc-estab = estabelec.nome.
     end.
     else do:
        assign c-desc-estab = "":U.
     end.

     find tab-unidade where tab-unidade.un = c-unid-med-movto no-lock no-error.
     if avail tab-unidade then do:
        assign c-desc-unid = tab-unidade.descricao.
     end.
     else do:
        assign c-desc-unid = "":U.
     end.

     find localizacao where localizacao.cod-localiz = movto-estoq.cod-localiz no-lock no-error.
     if avail localizacao then do:
        assign c-desc-local = localizacao.descricao.   
     end.
     else do:
        assign c-desc-local = "":U.
     end.

     find referencia where referencia.cod-refer = movto-estoq.cod-refer no-lock no-error.
     if avail referencia then do:
        assign c-desc-ref = referencia.descricao.
     end.
     else do:
        assign c-desc-ref = "":U.
     end.

     FOR EACH deposito
         WHERE deposito.cod-depos = input frame {&frame-name} c-cod-depos-movto:
    
         IF COMPARE(deposito.cod-depos,"MATCHES",input frame {&frame-name} c-cod-depos-movto,"CASE-INSENSITIVE") THEN
             ASSIGN c-desc-depos = deposito.nome.
         ELSE
             ASSIGN c-desc-depos = "".
     END.

  end.

  disable movto-estoq.lote
          movto-estoq.cod-refer 
          dt-vali-lote 
          c-it-pai
          c-roteiro
          i-operacao with frame {&frame-name}.

  /* Dispatch standard ADM method.                             */
  if avail movto-estoq then do:   

      
      FOR FIRST estabelec FIELDS(ep-codigo)
          WHERE estabelec.cod-estabel = movto-estoq.cod-estabel NO-LOCK:
          ASSIGN i-empresa = estabelec.ep-codigo.
          RUN pi-formato.
      END.
      IF NOT AVAIL estabelec THEN DO:
          RUN pi-desformata-campos.
          RUN pi-desformato.
      END.

      /* Busca dados da conta contÿbil */
      ASSIGN v_cod_cta_ctbl = movto-estoq.ct-codigo.
      run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,               /* EMPRESA EMS2 */
                                                     input        "",                      /* PLANO DE CONTAS */
                                                     input-output v_cod_cta_ctbl,          /* CONTA */
                                                     input        movto-estoq.dt-trans,    /* DATA TRANSACAO */   
                                                     output       v_titulo_cta_ctbl,       /* DESCRICAO CONTA */
                                                     output       v_num_tip_cta_ctbl,      /* TIPO DA CONTA */
                                                     output       v_num_sit_cta_ctbl,      /* SITUA°€O DA CONTA */
                                                     output       v_ind_finalid_cta,       /* FINALIDADES DA CONTA */
                                                     output table tt_log_erro).            /* ERROS */ 
    
      /* Busca dados do centro de custo */
      ASSIGN v_cod_ccusto = movto-estoq.sc-codigo.
      run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,               /* EMPRESA EMS2 */
                                                 input  "",                      /* CODIGO DO PLANO CCUSTO */
                                                 input  v_cod_ccusto,            /* CCUSTO */
                                                 input  movto-estoq.dt-trans,    /* DATA DE TRANSACAO */
                                                 output v_titulo_ccusto,         /* DESCRICAO DO CCUSTO */
                                                 output table tt_log_erro).      /* ERROS */
        
      assign c-conta-ctbl:screen-value in frame {&frame-name} = v_cod_cta_ctbl.
      assign c-titulo-conta:screen-value in frame {&frame-name} = v_titulo_cta_ctbl.
      assign c-ccusto:screen-value in frame {&frame-name} = v_cod_ccusto.
      assign c-titulo-ccusto:screen-value in frame {&frame-name} = v_titulo_ccusto.
                                                                    
      RUN pi-formata-campos.
  end.

  clear frame {&frame-name}.

 {utp/ut-liter.i Ordem_Produ��o * R}
  assign c-titulo1:screen-value in frame {&FRAME-NAME} = return-value.

  if l-ce0205-invest then
      run pi-mostra-invest.

  /* Code placed here will execute AFTER standard behavior.    */
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

  IF NOT l-implantado-invest THEN
      disable movto-estoq.num-ord-inv with frame f-main.

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
   
  ENABLE  c-it-codigo-movto
          c-cod-estabel-movto
          c-cod-depos-movto
          c-unid-med-movto WITH FRAME {&FRAME-NAME}.

  /*UNIDADE DE NEGàCIO - 206B*/
  /* l-unidade-negocio - Fun‡Æo EMS2-UNIDADE-NEGOCIO cadastrada*/
  if l-unidade-negocio then
      enable movto-estoq.cod-unid-negoc with frame {&frame-name}.
  else
      disable movto-estoq.cod-unid-negoc with frame {&frame-name}.  

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

  {utp/ut-liter.i Conta_Contabil MCE}
  assign c-conta-ctbl:label in frame {&FRAME-NAME} = trim(return-value).
  
  {utp/ut-liter.i Centro_Custo MCE}
  assign c-ccusto:label in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-liter.i Data_de_Sa�da MCE}
  assign da-devol:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind movto-estoq cod-roteiro 1}
  assign c-roteiro:label in frame {&FRAME-NAME} = trim(return-value).

  find first param-global no-lock no-error.
  IF AVAIL param-global THEN DO:

      ASSIGN l-implantado-invest = param-global.modulo-in
             i-empresa = param-global.empresa-prin.
   END.
  {utp/ut-liter.i Item-Pai * L}
  assign c-it-pai:label in frame {&frame-name} = return-value. 

  {utp/ut-liter.i Opera��o * L}
  assign i-operacao:label in frame {&frame-name} = return-value. 

  {utp/ut-liter.i Ordem_Produ��o * C}
  assign    
    c-titulo1:screen-value in frame {&frame-name} = return-value
    c-titulo1 = RETURN-VALUE.
    

  find first param-estoq no-lock no-error.
  if  avail param-estoq THEN DO:
      ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.

      /* Funcao Super/Minas */
      &IF DEFINED(Bf_dis_usuario_estab) &THEN
          IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                               AND funcao.ativo     = YES) THEN DO:
             RUN cdp/cd8702.p (input        c-seg-usuario,
                               INPUT-OUTPUT c-cod-estabel-usuar).
          END.
      &ENDIF
      
      FOR FIRST estabelec FIELDS(cod-estabel)
          WHERE estabelec.cod-estabel = c-cod-estabel-usuar NO-LOCK:
      END.
      IF NOT AVAIL estabelec THEN
          FOR FIRST estabelec FIELDS(cod-estabel) NO-LOCK:
              ASSIGN c-cod-estabel-usuar = estabelec.cod-estabel.
          END.
      ASSIGN c-estabelec = c-cod-estabel-usuar.
  END.


   /**** Verifica se foi informado o n£mero da ordem e habilita F7 p/ zoom das
        reservas da ordem, somente apartir da 2.04 *****/

  &if defined (bf_mnt_ems204) &then  
      if input frame {&frame-name} movto-estoq.nr-ord-produ <> 0 then
         assign  wh-item2:SENSITIVE = YES.
      else
         assign  wh-item2:SENSITIVE = NO.
  &endif 

  /*verifica se utiliza o modulo investimento para mostrar o campo */
  if not l-ce0205-invest then 
      movto-estoq.num-ord-inv:hidden in frame f-main = yes.

  run cdp/cdapi024.p persistent set h-cdapi024.

  assign c-ant-it-codigo = "INICIO".
  /* Code placed here will execute AFTER standard behavior.    */
  
  if movto-estoq.num-ord-inv:screen-value in frame f-main <> "0" then 
  
      RUN ivbo/boiv029.p PERSISTENT SET h-boiv029.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

    run pi-desformata-campos.

    create tt-movto.  
    assign tt-movto.cod-versao-integracao = 1
           tt-movto.dt-trans         = input frame {&frame-name} movto-estoq.dt-trans
           tt-movto.nr-ord-produ     = input frame {&frame-name} movto-estoq.nr-ord-produ
           tt-movto.num-ord-inv      = input frame {&frame-name} movto-estoq.num-ord-inv
           tt-movto.nro-docto        = input frame {&frame-name} movto-estoq.nro-docto
           tt-movto.serie-docto      = input frame {&frame-name} movto-estoq.serie-docto
           tt-movto.ct-codigo        = input frame {&frame-name} c-conta-ctbl
           tt-movto.sc-codigo        = input frame {&frame-name} c-ccusto
           tt-movto.it-codigo        = input frame {&frame-name} c-it-codigo-movto
           tt-movto.cod-estabel      = input frame {&frame-name} c-cod-estabel-movto
           tt-movto.cod-depos        = input frame {&frame-name} c-cod-depos-movto
           tt-movto.cod-localiz      = input frame {&frame-name} movto-estoq.cod-localiz
           tt-movto.cod-refer        = input frame {&frame-name} movto-estoq.cod-refer
           tt-movto.lote             = input frame {&frame-name} movto-estoq.lote
           tt-movto.quantidade       = input frame {&frame-name} movto-estoq.quantidade
           tt-movto.un               = input frame {&frame-name} c-unid-med-movto
           tt-movto.tipo-trans       = 2
           tt-movto.esp-docto        = 28 /* requisicao */
           tt-movto.cod-prog-orig    = "v08in218"
           tt-movto.dt-vali-lote     = input frame {&frame-name} dt-vali-lote
           tt-movto.op-seq           = i-seq
           tt-movto.usuario          = c-seg-usuario. 
           
    run pi-formata-campos.
    
    IF  p-perc-rateio > 0 THEN
        ASSIGN tt-movto.quantidade = tt-movto.quantidade * p-perc-rateio / 100.
    
    if movto-estoq.quantidade:sensitive in frame {&frame-name} = no then do:
       assign tt-movto.quantidade = 1.
    end.
    
    /*UNIDADE aDE NEGàCIO - 206B*/
    /* l-unidade-negocio - Fun‡Æo EMS2-UNIDADE-NEGOCIO cadastrada*/
    if l-unidade-negocio then
        assign tt-movto.cod-unid-negoc = p-cod-unid-negoc.
    
    
    if avail ord-prod then do:
       if c-conta-ctbl:sensitive in frame {&frame-name} = no then do:
          assign tt-movto.ct-codigo =  ord-prod.ct-codigo.
          assign tt-movto.sc-codigo =  ord-prod.sc-codigo.
       end.
    end.

    if avail ord-prod and AVAIL param-global AND param-global.modulo-cs then do:
       find last b-movto use-index num-seq where
                 b-movto.nr-ord-produ = ord-prod.nr-ord-produ no-lock no-error.
       if  avail b-movto then do:
           assign tt-movto.num-sequen = b-movto.num-sequen + 1.
       end.
       else do:
           assign tt-movto.num-sequen = 1.
       end.
    end.
    if avail ord-prod and tt-movto.nr-ord-produ <> 0 then do:
       assign tt-movto.ct-codigo =  ord-prod.ct-codigo.
       assign tt-movto.sc-codigo =  ord-prod.sc-codigo.
    end.
    
    find deposito where deposito.cod-depos = tt-movto.cod-depos no-lock no-error.
    for each tt-erro exclusive-lock:
        delete tt-erro.
    end.
    for each tt-erro-aux exclusive-lock:
        delete tt-erro-aux.
    end.

    if  c-nom-prog-upc-mg97 <> "" 
    and c-nom-prog-upc-mg97 <> ? then do:                  

        run value(c-nom-prog-upc-mg97) (input "UPDATE-TT-MOVTO":U, 
                                        input "",
                                        input TEMP-TABLE tt-movto:HANDLE,
                                        input ?,
                                        input "",                                       
                                        input ?).
        IF RETURN-VALUE = "RETURN-ERROR":U THEN
            RETURN "NOK":U.
    end.

    /* efetua as baixas das reservas*/
    find first tt-movto no-error.
    if  not avail ord-manut or
           (avail ord-manut and ord-manut.estado < 7) then do:
        {cep/ce0205.i tog-atualiza}
    end.
    
    ASSIGN de-difere-val-quantidade = de-difere-val-quantidade - (de-val-quantidade * (p-perc-rateio / 100)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desformata-campos V-table-Win 
PROCEDURE pi-desformata-campos :
assign c-conta-ctbl:format in frame {&frame-name} = "x(20)":U
           c-ccusto:format         in frame {&frame-name} = "x(20)":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desformato V-table-Win 
PROCEDURE pi-desformato :

    ASSIGN c-formato-conta  = ""
           c-formato-ccusto = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campos V-table-Win 
PROCEDURE pi-formata-campos :
/* Formatando conta e centro de custo */
  IF  NOT c-formato-conta = ""
  AND NOT c-conta-ctbl    = "" then do:
      assign c-conta-ctbl:format in frame {&FRAME-NAME} = c-formato-conta.
  end.
  IF  NOT c-formato-ccusto = ""
  AND NOT c-ccusto         = "" then do:
      assign c-ccusto:format     in frame {&FRAME-NAME} = c-formato-ccusto.
  end.
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formato V-table-Win 
PROCEDURE pi-formato :

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
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-invest V-table-Win 
PROCEDURE pi-mostra-invest :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if movto-estoq.nr-ord-produ:screen-value in frame f-main <> "0" or
        NOT l-implantado-invest then 
        disable movto-estoq.num-ord-inv with frame f-main.
    else enable movto-estoq.num-ord-inv with frame f-main .

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-registra-dados V-table-Win 
PROCEDURE pi-registra-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    do with frame {&FRAME-NAME}:
        assign
            l-repetiu          = yes
            da-data-repet      = input movto-estoq.dt-trans
            i-ordem-repet      = input movto-estoq.nr-ord-produ
            c-docto-repet      = input movto-estoq.nro-docto
            c-serie-repet      = input movto-estoq.serie-docto
            c-conta-repet      = input c-conta-ctbl
            c-descr-repet      = input c-titulo-conta
            c-ccusto-repet     = input c-ccusto
            c-desc-cc-repet    = input c-titulo-ccusto            
            i-num-inv-repet    = input movto-estoq.num-ord-inv
            c-unid-negoc-repet = INPUT movto-estoq.cod-unid-negoc.
    end.

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
    define input param hdl-alvo as handle                               no-undo.

    define variable hdl-inicial as handle                               no-undo.
    define variable hdl-proximo as handle                               no-undo.
    define variable hdl-atual   as handle                               no-undo.

    assign hdl-atual   = focus.

    repeat:
        /* Verifica se retornou para o primeiro campo ------------------------*/
        if hdl-atual = hdl-inicial then
            leave.

        IF hdl-atual:NAME = "c-conta-ctbl" THEN
            ASSIGN hdl-atual = hdl-atual:NEXT-TAB-ITEM.

        /* Se hdl-inicial for nulo, inicializa a variavel --------------------*/
        if not valid-handle(hdl-inicial) then
            hdl-inicial = hdl-atual.

        /* Se o widget atual for o widget-alvo, entao retorna ----------------*/
        if hdl-atual = hdl-alvo then
            leave.

        /* Se o campo atual estiver sensitive, aplica o evento de saida ------*/
        if hdl-atual:sensitive then
            apply "leave" to hdl-atual.

        /* Troca o foco para o proximo campo ---------------------------------*/
        hdl-atual = hdl-atual:next-tab-item.

        if hdl-atual:sensitive then
            apply "entry" to hdl-atual.

    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-testa-calib V-table-Win 
PROCEDURE pi-testa-calib :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /* Calibracao */
 &if defined (bf_mnt_calib) &then
    IF AVAIL ord-prod  THEN DO:
        FIND ord-manut WHERE ord-manut.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK NO-ERROR.
        IF &IF DEFINED (bf_mnt_ems205) &THEN
             AVAIL param-global AND param-global.log-modul-calib 
           &else
             AVAIL param-global AND substr(param-global.char-2,100,1) = "2" 
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
            return 'nok'.
        end.
    END.
 &endif

 /*-------------------*/

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
    RUN cep/ceapi014.p( input input frame {&frame-name} c-it-codigo-movto,
                        INPUT INPUT FRAME {&FRAME-NAME} c-cod-estabel-movto,
                        OUTPUT pcod-deposito-pad, 
                        OUTPUT pcod-localiz,      
                        OUTPUT ploc-unica).
    IF pcod-deposito-pad <> "" THEN DO:
        ASSIGN c-cod-depos-movto:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = pcod-deposito-pad.
        APPLY "leave" TO c-cod-depos-movto.
    END.

    ASSIGN movto-estoq.cod-localiz:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pcod-localiz.
    APPLY "leave" TO movto-estoq.cod-localiz.

    IF ploc-unica THEN
        DISABLE movto-estoq.cod-localiz WITH FRAME {&FRAME-NAME}.
    ELSE 
        ENABLE movto-estoq.cod-localiz WITH FRAME {&FRAME-NAME}.
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

   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":u, input 7, input return-value).
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

