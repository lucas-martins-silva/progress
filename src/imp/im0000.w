&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-param-imp NO-UNDO LIKE param-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-param-imp-trib NO-UNDO LIKE param-imp-trib
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**    
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0000 2.00.00.090 } /*** "010090" 18/06/2026 13:20:12 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0000 MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.  
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{cdp/cdcfgdis.i} /* Definiá∆o de prÇ-processadores */
{cdp/cdcfgmat.i} /* Definiá∆o de prÇ-processadores */
{include/i_dbvers.i} /*Include de PrÇ-Processadores*/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0000
&GLOBAL-DEFINE Version        2.00.00.090
&GLOBAL-DEFINE DBOVersion     1.1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Geral, PIS/COFINS

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        tt-param-imp
&GLOBAL-DEFINE hDBOTable      h-bocx250
&GLOBAL-DEFINE DBOTable       param-imp

&GLOBAL-DEFINE page0KeyFields 
&GLOBAL-DEFINE page0Fields    tt-param-imp.cod-estabel 
&GLOBAL-DEFINE page1Fields    tt-param-imp.esp-tit-transit ~
                              tt-param-imp.esp-tit-rec ~
                              tt-param-imp.hp-codigo ~
                              tt-param-imp.ct-transit-import ~
                              tt-param-imp.sc-transit-import ~
                              texto-informa ~
                              tt-param-imp.int-1 ~
                              texto-relaciona ~
                              texto-despes-itiner ~
                              tb-desp-itiner-autom ~
                              tt-param-imp.log-1 ~
                              tg-sugere-loc-padrao ~
                              lb-nf-simples-remessa ~
                              l-gera-primeira-remessa-nf-mae

&GLOBAL-DEFINE page2Fields    d-dt-ini-pis ~
                              c-trib-pis ~
                              d-dt-ini-cofins ~
                              c-trib-cofins ~
                              c-formula-pis ~
                              c-formula-cofins ~
                              l-inc-pis-base-icms ~
                              l-inc-cofins-base-icms ~
                              tg-base-reduzida-pis ~
                              tg-base-reduzida-cofins

/** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/

&GLOBAL-DEFINE page3Fields log-geracao c-nat-oper log-cotac-impto log-cotac-ipi fi-despes-ipi fi-cd-fornec-ipi ~
                           log-cotac-pis fi-despes-pis fi-cd-fornec-pis log-cotac-cofins fi-despes-cofins fi-cd-fornec-cofins ~
                           log-cotac-icms fi-despes-icms fi-cd-fornec-icms lb-ipi lb-pis lb-cofins lb-icms lb-isd ~
                           i-emitente-ii i-desp-ii c-lbl-cotacao-automatica c-lbl-antecip tt-param-imp.cod-espec-antecip tt-param-imp.cod-ser-antecip ~
                           tt-param-imp.perc-max-antecip c-lbl-despesas-impostos c-lbl-ii

&GLOBAL-DEFINE page4Fields tt-param-imp.des-layout-origin-licenc-import ~
                           tt-param-imp.des-layout-autoriz-import ~
                           c-des-senha-docto c-confirma-senha-docto ~
                           c-des-senha-pch c-confirma-senha-pch

&GLOBAL-DEFINE page5Fields c-cpf-repres ~
                           l-util-rat-sis ~
                           i-desp-siscomex ~
                           i-forn-siscomex ~
                           i-mo-codigo ~
                           c-nome ~
                           tg-solicita-li-itens

&GLOBAL-DEFINE page6Fields tg-ger-pro ~
                           c-classe ~
                           tg-ger-estq-emb

&GLOBAL-DEFINE page7Fields tg-ato-conces tg-itens-ato-conces tg-doc-relacionados i-nr-dias-venc c-usuario-email

&GLOBAL-DEFINE page8Fields tt-param-imp-trib.cod-natur-operac-novo-impto tt-param-imp-trib.log-gerac-cot-desp-novo-impto ~
                           tt-param-imp-trib.log-cotac-autom-CBS tt-param-imp-trib.log-cotac-autom-IBSUF tt-param-imp-trib.log-cotac-autom-IBSMun tt-param-imp-trib.log-cotac-autom-IS ~
                           tt-param-imp-trib.cdn-despes-impto-CBS tt-param-imp-trib.cdn-despes-impto-IBSUF tt-param-imp-trib.cdn-despes-impto-IBSMun tt-param-imp-trib.cdn-despes-impto-IS ~
                           tt-param-imp-trib.cdn-fornec-CBS tt-param-imp-trib.cdn-fornec-IBSUF tt-param-imp-trib.cdn-fornec-IBSMun tt-param-imp-trib.cdn-fornec-IS ~
                           lb-cbs lb-ibsuf lb-ibsmun lb-is ~
                           c-lbl-desp-imp-novo c-lbl-cot-aut-novo

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
/*def var c-titulo like conta-contab.titulo no-undo.*/
DEFINE VARIABLE c-titulo        AS CHARACTER   NO-UNDO FORMAT "X(32)":U.
DEFINE VARIABLE c-val-1         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-estab-copy    LIKE param-imp.cod-estabel NO-UNDO.
DEFINE VARIABLE cFile           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE m-cripto        AS MEMPTR      NO-UNDO.
DEFINE VARIABLE m-cripto-arq    AS MEMPTR      NO-UNDO.
DEFINE VARIABLE m-cripto-chave  AS MEMPTR      NO-UNDO.

/*
** Vari†veis utilizadas pela include cd9998.i, 
** respons†vel pelo tratamento do formato
*/

DEF VAR i_page-viewer AS INTEGER   NO-UNDO.
DEF VAR i_page-atual  AS INTEGER   NO-UNDO.
DEF VAR h_Container   AS HANDLE    NO-UNDO.
DEF VAR h_aux         AS HANDLE    NO-UNDO.
/*TÇrmino das vari†veis utilizadas pela include cd9998.i*/

/* Local Variable Definitions (DBOs Handles) --- */

DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
def var h-boad107            as handle no-undo.
def var h-boad104            as handle no-undo.
def var h-boad142            as handle no-undo.
def var h-boad098            as handle no-undo.
def var h-boad355            as handle no-undo.
def var h-bocx095            as handle no-undo.
def var h-boin682            as handle no-undo.
def var h-boar2084           as handle no-undo.
DEFINE VARIABLE h-im0000ac AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-im0007  AS HANDLE      NO-UNDO.
def var l-implantar          as char   no-undo.
def var l-ems50-erro         as log    no-undo init no.
def var l-emsbas             as log    no-undo init no.
def var l-emsfin             as log    no-undo init no.
def var l-emsuni             as log    no-undo init no.
def var l-formato            as log    no-undo.
def var h-esp-rec            as handle no-undo.
def var h-conta              as handle no-undo.
def var h-emitente-ii        as handle no-undo.
def var h-desp-ii            as handle no-undo.
def var i-cont               as int    no-undo.
def var c-formato            as char   no-undo.
def var i-empresa-prin       like param-global.empresa-prin no-undo.
def var c-return             as char   no-undo.
def var v-pagar              as char   no-undo.
def var v-receber            as char   no-undo.
def var l-modulo-mec         as log    no-undo.
def var r-rowid-temp         as rowid  no-undo.
def var l-ok                 as logical no-undo.
DEF VAR i-empresa            LIKE param-global.empresa-prin NO-UNDO.
DEF VAR r-rowid-estabel      AS ROWID NO-UNDO.
DEF VAR l-utz-rat-sis-ant    AS LOGICAL NO-UNDO.
DEF VAR l-fn-antecip         AS LOGICAL NO-UNDO.

DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-ger-pro       AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-ger-estq-emb  AS LOGICAL NO-UNDO.

DEFINE VARIABLE c-lbl-impto-faixa    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE l-trata-dep-externos AS LOGICAL       NO-UNDO.
DEFINE VARIABLE wg-lb-desp-isd       AS WIDGET-HANDLE NO-UNDO.

DEF VAR h-bocx00476 AS HANDLE NO-UNDO.

{cdp/cd4300.i3}    /* include tratamento atributo livre */
{cxbo/bocx250.i50} /* include tratamento atributo livre */
{include/i-win.i}  /* altera caracter de senha */
{cdp/cd2508.i} /*Funá∆o - EMS2-COMEX-MEXICO*/
{adbo/boad107.i tt-estabelec}

{cxbo/bocx00476.i tt-param-imp-internac}

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE                   VARIABLE wh-pesquisa    AS HANDLE NO-UNDO.


FIND FIRST param-global NO-LOCK NO-ERROR.
ASSIGN i-empresa = param-global.empresa-prin.

ASSIGN l-fn-antecip = CAN-FIND(FIRST funcao
                               WHERE funcao.cd-funcao = "spp-imp-antecip":U
                                 AND funcao.ativo     = YES).

/***********API FINANCAS****************/
def var h_api_cta          as handle no-undo.
def var h_api_ccust        as handle no-undo.
def var p_cod_format_cta_ctbl   as char   no-undo.
DEF VAR p_cod_format_ccusto     AS CHAR NO-UNDO.
DEF VAR p_des_titulo        AS CHAR NO-UNDO.
DEF VAR v_cod_ccusto        AS CHAR NO-UNDO.
DEF VAR v_des_ccusto        AS CHAR NO-UNDO.
DEF VAR v_cod_cta_ctbl      AS CHAR NO-UNDO.
DEF VAR v_des_cta_ctbl      AS CHAR NO-UNDO.   
DEF VAR v_num_tip_cta_ctbl  AS CHAR NO-UNDO.
DEF VAR v_num_sit_cta_ctbl  AS CHAR NO-UNDO.
DEF VAR v_ind_finalid_cta   AS CHAR NO-UNDO.
DEF VAR v_log_utz_ccusto    AS LOG NO-UNDO.

run prgint/utb/utb743za.py persistent set h_api_cta.
run prgint/utb/utb742za.py persistent set h_api_ccust.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància".

def temp-table tt_cta_integr no-undo
    field ttv_cod_cta_ctbl         as char format "x(20)" label "Conta Contˇbil"
    field ttv_des_titulo           as char format "x(40)"
    field ttv_num_tip_cta_ctbl     as int  format ">9" label "Tipo Conta" column-label "Tipo Conta"
    field ttv_num_sit_cta_ctbl     as int  format ">9" label "Situaá∆o Conta" column-label "Situaá∆o Cta"
    field ttv_ind_finalid_ctbl_cta as char format "X(40)" label "Finalidade Contˇbil".

def temp-table tt_ccusto_integr no-undo
    field ttv_cod_ccusto as char format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_des_titulo as char format "x(40)".

/***************************************/
 /*### Formato conta contabil*/
  run pi_retorna_formato_cta_ctbl in h_api_cta (input  i-empresa,                 /* EMPRESA EMS 2 */
                                                input  "",                 /* PLANO CONTAS */
                                                input  TODAY, /* DATA DE TRANSACAO */
                                                output p_cod_format_cta_ctbl,   /* FORMATO cta */
                                                output table tt_log_erro). /* ERROS */
  
  /* formato centro de custo*/
  run pi_retorna_formato_ccusto in h_api_ccust (input  i-empresa,                 /* EMPRESA EMS2 */
                                                input  "",             /* PLANO CCUSTO */
                                                input  TODAY,              /* DATA DE TRANSACAO */
                                                output p_cod_format_ccusto, /* FORMATO CCUSTO */
                                                output table tt_log_erro). /* ERROS */
  

/** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
DEF VAR h-boin245 AS HANDLE NO-UNDO.
DEF VAR h-boun005 AS HANDLE NO-UNDO.

DEF VAR h-bocx00511 AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-param-imp.cod-estabel 
&Scoped-define ENABLED-TABLES tt-param-imp
&Scoped-define FIRST-ENABLED-TABLE tt-param-imp
&Scoped-Define ENABLED-OBJECTS RECT-29 rtKeys rtToolBar btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btQueryJoins btReportsJoins btExit btHelp FILL-IN-1 
&Scoped-Define DISPLAYED-FIELDS tt-param-imp.cod-estabel 
&Scoped-define DISPLAYED-TABLES tt-param-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-param-imp
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image/im-add":U
     IMAGE-INSENSITIVE FILE "image/ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image/im-can":U
     IMAGE-INSENSITIVE FILE "image/im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image/im-copy":U
     IMAGE-INSENSITIVE FILE "image/ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image/im-era":U
     IMAGE-INSENSITIVE FILE "image/ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image/im-fir":U
     IMAGE-INSENSITIVE FILE "image/ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image/im-enter":U
     IMAGE-INSENSITIVE FILE "image/ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image/im-las":U
     IMAGE-INSENSITIVE FILE "image/ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image/im-nex":U
     IMAGE-INSENSITIVE FILE "image/ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image/im-pre":U
     IMAGE-INSENSITIVE FILE "image/ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri":U
     IMAGE-INSENSITIVE FILE "image/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image/im-undo":U
     IMAGE-INSENSITIVE FILE "image/ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image/im-mod":U
     IMAGE-INSENSITIVE FILE "image/ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 2.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 19.83.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-ccusto-aplic-nf AS CHARACTER FORMAT "X(20)":U 
     LABEL "CCusto Aplicaá∆o NF Simples Remessa" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-cta-aplic-nf AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta Aplicaá∆o NF Simples Remessa" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE desc-ccusto-aplic-nf AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE desc-ccusto-transit AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE desc-conta-transit AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE desc-cta-aplic-nf AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE lb-nf-simples-remessa AS CHARACTER FORMAT "X(20)":U INITIAL "NF Simples Remessa" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE texto-despes-itiner AS CHARACTER FORMAT "X(256)":U INITIAL "Despesas Itiner†rio" 
      VIEW-AS TEXT 
     SIZE 15 BY .67 NO-UNDO.

DEFINE VARIABLE texto-informa AS CHARACTER FORMAT "X(10)":U INITIAL "Informa:" 
      VIEW-AS TEXT 
     SIZE 6.43 BY .63 NO-UNDO.

DEFINE VARIABLE texto-relaciona AS CHARACTER FORMAT "X(256)":U INITIAL "Relaciona:" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 3.25.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 2.25.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27 BY 1.25.

DEFINE RECTANGLE RECT-81
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.43 BY 3.29.

DEFINE RECTANGLE RECT-83
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.43 BY 5.21.

DEFINE VARIABLE l-dep-externo AS LOGICAL INITIAL no 
     LABEL "Trata Dep¢sitos Externos" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .75 NO-UNDO.

DEFINE VARIABLE l-gera-primeira-remessa-nf-mae AS LOGICAL INITIAL no 
     LABEL "Gera Primeira Remessa com NF M∆e" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .83 NO-UNDO.

DEFINE VARIABLE tb-desp-itiner-autom AS LOGICAL INITIAL no 
     LABEL "Busca Despesas Itiner†rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.72 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sugere-loc-padrao AS LOGICAL INITIAL no 
     LABEL "Sugere localizaá∆o padr∆o para dep¢sito CQ" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.57 BY .83 NO-UNDO.

DEFINE BUTTON bt-calcula-cofins 
     IMAGE-UP FILE "image/im-calc4.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-calc4.bmp":U
     LABEL "Button 2" 
     SIZE 5 BY 1.13.

DEFINE BUTTON bt-calcula-pis 
     IMAGE-UP FILE "image/im-calc4.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-calc4.bmp":U
     LABEL "Button 1" 
     SIZE 5 BY 1.13.

DEFINE VARIABLE c-trib-cofins AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributaá∆o COFINS" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-trib-pis AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributaá∆o PIS" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-formula-cofins AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 57 BY 2.75 NO-UNDO.

DEFINE VARIABLE c-formula-pis AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 57 BY 2.75 NO-UNDO.

DEFINE VARIABLE d-dt-ini-cofins AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt In°cio COFINS" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-ini-pis AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt In°cio PIS" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 6.29.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 6.13.

DEFINE VARIABLE l-inc-cofins-base-icms AS LOGICAL INITIAL no 
     LABEL "Incide COFINS na Base do ICMS" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE l-inc-pis-base-icms AS LOGICAL INITIAL no 
     LABEL "Incide Pis na Base do ICMS" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-base-reduzida-cofins AS LOGICAL INITIAL no 
     LABEL "Calcula Base COFINS Reduzida" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-base-reduzida-pis AS LOGICAL INITIAL no 
     LABEL "Calcula Base PIS Reduzida" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE BUTTON btFaixaImpto 
     IMAGE-UP FILE "image/im-amort.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-amort.bmp":U
     LABEL "Faixa Imposto" 
     SIZE 4 BY 1.25 TOOLTIP "Informar Valor Faixa Imposto"
     FONT 4.

DEFINE VARIABLE c-desc-desp-cofins AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-desp-est AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-desp-icms AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-desp-ipi AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-desp-iva AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-desp-pis AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-espec AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornec-cofins AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornec-est AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornec-icms AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornec-ipi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornec-iva AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornec-pais AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornec-pis AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-isd AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-natur AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE c-desp-ii AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-emitente-ii AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-lbl-antecip AS CHARACTER FORMAT "X(256)":U INITIAL "Antecipaá‰es" 
      VIEW-AS TEXT 
     SIZE 11.29 BY .67 NO-UNDO.

DEFINE VARIABLE c-lbl-cotacao-automatica AS CHARACTER FORMAT "X(256)":U INITIAL "Cotaá∆o Autom†tica" 
      VIEW-AS TEXT 
     SIZE 15 BY .67 NO-UNDO.

DEFINE VARIABLE c-lbl-despesas-impostos AS CHARACTER FORMAT "X(256)":U INITIAL "DESPESAS E IMPOSTOS" 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE c-lbl-faixa-imposto AS CHARACTER FORMAT "X(256)":U INITIAL "Faixa Imposto" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE c-lbl-ii AS CHARACTER FORMAT "X(256)":U INITIAL "II" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE c-nat-oper AS CHARACTER FORMAT "X(6)":U 
     LABEL "Nat. Operaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE cdn-despes-saida-div-aux AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Despesa" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cd-fornec-cofins AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cd-fornec-icms AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cd-fornec-ipi AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cd-fornec-pis AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-fornec-pais AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-despes-cofins AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Despesa" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-despes-icms AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Despesa" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-despes-ipi AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Despesa" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-despes-pis AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Despesa" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-desp-ii AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Despesa" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-emitente-ii AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE lb-cofins AS CHARACTER FORMAT "X(8)":U INITIAL "COFINS" 
      VIEW-AS TEXT 
     SIZE 6.14 BY .67 NO-UNDO.

DEFINE VARIABLE lb-icms AS CHARACTER FORMAT "X(5)":U INITIAL "ICMS" 
      VIEW-AS TEXT 
     SIZE 4.86 BY .67 NO-UNDO.

DEFINE VARIABLE lb-ipi AS CHARACTER FORMAT "X(5)":U INITIAL "IPI" 
      VIEW-AS TEXT 
     SIZE 3.57 BY .67 NO-UNDO.

DEFINE VARIABLE lb-isd AS CHARACTER FORMAT "X(5)":U INITIAL "ISD" 
      VIEW-AS TEXT 
     SIZE 3.72 BY .67 NO-UNDO.

DEFINE VARIABLE lb-pis AS CHARACTER FORMAT "X(5)":U INITIAL "PIS" 
      VIEW-AS TEXT 
     SIZE 3.72 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.72 BY 9.33.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67.86 BY 1.21.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67.86 BY 1.21.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67.86 BY 1.21.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 1.21.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67.86 BY 1.21.

DEFINE RECTANGLE RECT-74
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.72 BY 1.13.

DEFINE RECTANGLE RECT-76
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16.43 BY 6.29.

DEFINE RECTANGLE RECT-77
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.72 BY 3.58.

DEFINE RECTANGLE RECT-82
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16.43 BY 1.75.

DEFINE VARIABLE l-inc-icms-ipi-outros AS LOGICAL INITIAL no 
     LABEL "ICMS incide IPI Outros (OF)" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE log-cotac-cofins AS LOGICAL INITIAL no 
     LABEL "COFINS" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE log-cotac-icms AS LOGICAL INITIAL no 
     LABEL "ICMS" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE log-cotac-impto AS LOGICAL INITIAL no 
     LABEL "II" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE log-cotac-ipi AS LOGICAL INITIAL no 
     LABEL "IPI" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE log-cotac-pis AS LOGICAL INITIAL no 
     LABEL "PIS" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE log-geracao AS LOGICAL INITIAL no 
     LABEL "Geraá∆o Autom†tica" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .88 NO-UNDO.

DEFINE BUTTON bt-arq1 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Escolha do nome do arquivo".

DEFINE BUTTON bt-arq2 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Escolha do nome do arquivo".

DEFINE VARIABLE c-confirma-senha-docto AS CHARACTER FORMAT "X(15)":U 
     LABEL "Confirmar Senha Documentos Gr†ficos" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-confirma-senha-pch AS CHARACTER FORMAT "X(15)":U 
     LABEL "Confirmar Senha Purchase Order" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-senha-docto AS CHARACTER FORMAT "x(15)" 
     LABEL "Senha Documentos Gr†ficos":R30 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-senha-pch AS CHARACTER FORMAT "x(15)" 
     LABEL "Senha Purchase Order":R30 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 1.58.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 1.58.

DEFINE RECTANGLE RECT-75
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 2.5.

DEFINE BUTTON btTaxa 
     IMAGE-UP FILE "image/im-amort.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-amort.bmp":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Informar Valor Taxa Siscomex"
     FONT 4.

DEFINE VARIABLE c-cpf-repres AS CHARACTER FORMAT "X(19)":U 
     LABEL "CPF Representante" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-despesa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-forn AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nome" 
     VIEW-AS FILL-IN 
     SIZE 45.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-desp-siscomex AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Despesa" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-forn-siscomex AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-mo-codigo AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Moeda":R7 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.5.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 3.83.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.92.

DEFINE RECTANGLE RECT-37
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.

DEFINE VARIABLE l-util-rat-sis AS LOGICAL INITIAL no 
     LABEL "Utiliza Rateio Siscomex" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE tg-solicita-li-itens AS LOGICAL INITIAL no 
     LABEL "Solicita LI para todos os itens" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.29 BY .83 NO-UNDO.

DEFINE VARIABLE c-classe AS CHARACTER FORMAT "X(2)":U 
     LABEL "Classe" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-classe AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE tg-ger-estq-emb AS LOGICAL INITIAL no 
     LABEL "Gera Estoque em Transito por Embarque" 
     VIEW-AS TOGGLE-BOX
     SIZE 38 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ger-pro AS LOGICAL INITIAL no 
     LABEL "Gera Provis‰es de Gastos Aduana" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE c-usuario-email AS CHARACTER FORMAT "X(12)":U 
     LABEL "Usu†rio E-mail" 
     VIEW-AS FILL-IN 
     SIZE 14.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-dias-venc AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Nr. Dias para Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE lb-drawback AS CHARACTER FORMAT "X(30)":U INITIAL "Drawback Internacional" 
      VIEW-AS TEXT 
     SIZE 18 BY .67 NO-UNDO.

DEFINE VARIABLE lb-email-ato-concessorio AS CHARACTER FORMAT "X(40)":U INITIAL "E-mail Notificaá∆o Ato Concess¢rio" 
      VIEW-AS TEXT 
     SIZE 25 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-78
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 3.25.

DEFINE RECTANGLE RECT-79
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 3.25.

DEFINE RECTANGLE RECT-84
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 2.5.

DEFINE VARIABLE tg-ato-conces AS LOGICAL INITIAL no 
     LABEL "Tabela Ato Concess¢rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE tg-doc-relacionados AS LOGICAL INITIAL no 
     LABEL "Tabela Documentos Relacionados" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE tg-itens-ato-conces AS LOGICAL INITIAL no 
     LABEL "Tabela Itens do Ato Concess¢rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .88 NO-UNDO.

DEFINE VARIABLE tg-vincula-drb-emb AS LOGICAL INITIAL no 
     LABEL "Vincula Drawback por Embarque" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-desp-cbs AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-desp-ibs-uf AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-desp-ibsmun AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-desp-is AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornec-cbs AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornec-ibs-uf AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornec-ibsmun AS CHARACTER FORMAT "x(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornec-is AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-natur-novo AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE c-lbl-cot-aut-novo AS CHARACTER FORMAT "X(256)":U INITIAL "Cotaá∆o Autom†tica" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-lbl-desp-imp-novo AS CHARACTER FORMAT "X(256)":U INITIAL "DESPESAS E IMPOSTOS" 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE lb-cbs AS CHARACTER FORMAT "X(5)":U INITIAL "CBS" 
      VIEW-AS TEXT 
     SIZE 3.57 BY .67 NO-UNDO.

DEFINE VARIABLE lb-ibsmun AS CHARACTER FORMAT "X(7)":U INITIAL "IBS Mun" 
      VIEW-AS TEXT 
     SIZE 6.14 BY .67 NO-UNDO.

DEFINE VARIABLE lb-ibsuf AS CHARACTER FORMAT "X(7)":U INITIAL "IBS UF" 
      VIEW-AS TEXT 
     SIZE 6.14 BY .67 NO-UNDO.

DEFINE VARIABLE lb-is AS CHARACTER FORMAT "X(5)":U INITIAL "IS" 
      VIEW-AS TEXT 
     SIZE 3.14 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.72 BY 8.88.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 1.21.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 1.21.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 1.21.

DEFINE RECTANGLE RECT-85
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16.43 BY 5.95.

DEFINE RECTANGLE RECT-86
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 1.21.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma alteraá‰es"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-param-imp.cod-estabel AT ROW 3.38 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     FILL-IN-1 AT ROW 3.38 COL 42.14 COLON-ALIGNED NO-LABEL
     RECT-29 AT ROW 2.83 COL 2.14
     rtKeys AT ROW 2.25 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 21.58
         FONT 1.

DEFINE FRAME fPage8
     tt-param-imp-trib.cod-natur-operac-novo-impto AT ROW 1.71 COL 29.72 COLON-ALIGNED
          LABEL "Natureza Operaá∆o"
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     c-desc-natur-novo AT ROW 1.71 COL 38.72 COLON-ALIGNED NO-LABEL
     tt-param-imp-trib.log-gerac-cot-desp-novo-impto AT ROW 2.71 COL 31.72
          LABEL "Geraá∆o Autom†tica Cotaá∆o de Despesas"
          VIEW-AS TOGGLE-BOX
          SIZE 34.29 BY .88
     tt-param-imp-trib.cdn-despes-impto-CBS AT ROW 4.13 COL 24.57 COLON-ALIGNED WIDGET-ID 40
          LABEL "Despesa"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-desp-cbs AT ROW 4.13 COL 30.72 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     tt-param-imp-trib.cdn-fornec-CBS AT ROW 4.13 COL 57.57 COLON-ALIGNED WIDGET-ID 38
          LABEL "Fornecedor"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-desc-fornec-cbs AT ROW 4.13 COL 66.72 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     tt-param-imp-trib.log-cotac-autom-CBS AT ROW 4.38 COL 5
          LABEL "CBS"
          VIEW-AS TOGGLE-BOX
          SIZE 9 BY .88
     tt-param-imp-trib.log-cotac-autom-IBSUF AT ROW 5.38 COL 5
          LABEL "IBS UF"
          VIEW-AS TOGGLE-BOX
          SIZE 9 BY .88
     tt-param-imp-trib.cdn-despes-impto-IBSUF AT ROW 5.75 COL 24.57 COLON-ALIGNED
          LABEL "Despesa"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-desp-ibs-uf AT ROW 5.75 COL 30.72 COLON-ALIGNED NO-LABEL
     tt-param-imp-trib.cdn-fornec-IBSUF AT ROW 5.75 COL 57.57 COLON-ALIGNED WIDGET-ID 56
          LABEL "Fornecedor"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-desc-fornec-ibs-uf AT ROW 5.75 COL 66.72 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     tt-param-imp-trib.log-cotac-autom-IBSMun AT ROW 6.38 COL 5 WIDGET-ID 60
          LABEL "IBS Mun"
          VIEW-AS TOGGLE-BOX
          SIZE 9 BY .88
     tt-param-imp-trib.cdn-despes-impto-IBSMun AT ROW 7.33 COL 24.57 COLON-ALIGNED WIDGET-ID 66
          LABEL "Despesa"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-desp-ibsmun AT ROW 7.33 COL 30.72 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     tt-param-imp-trib.cdn-fornec-IBSMun AT ROW 7.33 COL 57.57 COLON-ALIGNED WIDGET-ID 72
          LABEL "Fornecedor"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-desc-fornec-ibsmun AT ROW 7.33 COL 66.72 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     tt-param-imp-trib.log-cotac-autom-IS AT ROW 7.38 COL 5
          LABEL "IS"
          VIEW-AS TOGGLE-BOX
          SIZE 9 BY .88
     tt-param-imp-trib.cdn-despes-impto-IS AT ROW 8.92 COL 24.57 COLON-ALIGNED
          LABEL "Despesa"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-desp-is AT ROW 8.92 COL 30.72 COLON-ALIGNED NO-LABEL
     tt-param-imp-trib.cdn-fornec-IS AT ROW 8.92 COL 57.57 COLON-ALIGNED
          LABEL "Fornecedor"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-desc-fornec-is AT ROW 8.92 COL 66.72 COLON-ALIGNED NO-LABEL
     c-lbl-desp-imp-novo AT ROW 1.04 COL 2 NO-LABEL WIDGET-ID 28
     c-lbl-cot-aut-novo AT ROW 3.63 COL 3 NO-LABEL WIDGET-ID 8
     lb-cbs AT ROW 3.63 COL 20 NO-LABEL
     lb-ibsuf AT ROW 5.25 COL 20 NO-LABEL
     lb-ibsmun AT ROW 6.83 COL 20 NO-LABEL WIDGET-ID 76
     lb-is AT ROW 8.46 COL 20 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.08
         SIZE 87.43 BY 14.67
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage8
     RECT-24 AT ROW 1.29 COL 1
     RECT-36 AT ROW 4 COL 19.14
     RECT-39 AT ROW 5.58 COL 19.14
     RECT-40 AT ROW 8.75 COL 19.14
     RECT-85 AT ROW 4 COL 2 WIDGET-ID 4
     RECT-86 AT ROW 7.17 COL 19.14 WIDGET-ID 62
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.08
         SIZE 87.43 BY 14.67
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage7
     tg-ato-conces AT ROW 2 COL 8 WIDGET-ID 2
     tg-itens-ato-conces AT ROW 2.75 COL 8 WIDGET-ID 6
     tg-doc-relacionados AT ROW 3.5 COL 8 WIDGET-ID 8
     i-nr-dias-venc AT ROW 5.88 COL 22.57 COLON-ALIGNED WIDGET-ID 16
     c-usuario-email AT ROW 6.88 COL 22.57 COLON-ALIGNED WIDGET-ID 18
     tt-param-imp.log-trata-depos-draw AT ROW 9.5 COL 8 WIDGET-ID 20
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .83
     tg-vincula-drb-emb AT ROW 10.29 COL 8 WIDGET-ID 32
     lb-email-ato-concessorio AT ROW 5 COL 6 NO-LABEL WIDGET-ID 30
     lb-drawback AT ROW 8.75 COL 6 NO-LABEL WIDGET-ID 26
     " Gera Hist¢rico Criaá∆o/Alteraá∆o" VIEW-AS TEXT
          SIZE 24 BY .54 AT ROW 1.25 COL 6 WIDGET-ID 10
     RECT-78 AT ROW 1.5 COL 4 WIDGET-ID 4
     RECT-79 AT ROW 5.25 COL 4 WIDGET-ID 12
     RECT-84 AT ROW 9 COL 4 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 6.08
         SIZE 87.43 BY 14.67
         FONT 1.

DEFINE FRAME fpage3
     tt-param-imp.inc-icms-tot-nf AT ROW 10.63 COL 2
          VIEW-AS TOGGLE-BOX
          SIZE 15.14 BY .88
     tt-param-imp.log-2 AT ROW 10.63 COL 20
          LABEL "ICMS integra base ICMS"
          VIEW-AS TOGGLE-BOX
          SIZE 20.86 BY .88 TOOLTIP "ICMS integra base ICMS"
     l-inc-icms-ipi-outros AT ROW 10.63 COL 43
     tt-param-imp.cod-espec-antecip AT ROW 12.38 COL 9.57 COLON-ALIGNED HELP
          "EspÇcie do t°tulo de Antecipaá∆o no Contas a Pagar" WIDGET-ID 24
          LABEL "EspÇcie" FORMAT "x(2)"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-lbl-despesas-impostos AT ROW 1 COL 2 NO-LABEL WIDGET-ID 28
     c-desc-espec AT ROW 12.38 COL 15.86 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     tt-param-imp.cod-ser-antecip AT ROW 13.38 COL 9.57 COLON-ALIGNED HELP
          "SÇrie do t°tulo de Antecipaá∆o no Contas a Pagar" WIDGET-ID 22
          LABEL "SÇrie"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-lbl-ii AT ROW 2 COL 19.86 NO-LABEL WIDGET-ID 30
     tt-param-imp.perc-max-antecip AT ROW 14.38 COL 9.57 COLON-ALIGNED WIDGET-ID 32
          LABEL "% M†x Perm"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     log-geracao AT ROW 2.38 COL 2
     log-cotac-impto AT ROW 4.25 COL 5
     log-cotac-ipi AT ROW 5.25 COL 5
     log-cotac-pis AT ROW 6.25 COL 5
     log-cotac-cofins AT ROW 7.25 COL 5
     log-cotac-icms AT ROW 8.25 COL 5
     c-nat-oper AT ROW 1.33 COL 31.29 COLON-ALIGNED
     c-lbl-antecip AT ROW 11.67 COL 2 NO-LABEL WIDGET-ID 16
     c-desc-natur AT ROW 1.33 COL 40.29 COLON-ALIGNED NO-LABEL
     i-desp-ii AT ROW 2.54 COL 24.57 COLON-ALIGNED
     c-desp-ii AT ROW 2.54 COL 30.72 COLON-ALIGNED NO-LABEL
     c-lbl-cotacao-automatica AT ROW 3.46 COL 3 NO-LABEL WIDGET-ID 8
     i-emitente-ii AT ROW 2.54 COL 57.57 COLON-ALIGNED
     c-emitente-ii AT ROW 2.54 COL 66.72 COLON-ALIGNED NO-LABEL
     fi-despes-ipi AT ROW 4.17 COL 24.57 COLON-ALIGNED
     c-desc-desp-ipi AT ROW 4.17 COL 30.72 COLON-ALIGNED NO-LABEL
     fi-cd-fornec-ipi AT ROW 4.17 COL 57.57 COLON-ALIGNED
     c-desc-fornec-ipi AT ROW 4.17 COL 66.72 COLON-ALIGNED NO-LABEL
     lb-cofins AT ROW 6.92 COL 19.86 NO-LABEL
     fi-despes-pis AT ROW 5.83 COL 24.57 COLON-ALIGNED
     c-desc-desp-pis AT ROW 5.83 COL 30.72 COLON-ALIGNED NO-LABEL
     fi-cd-fornec-pis AT ROW 5.83 COL 57.57 COLON-ALIGNED
     lb-icms AT ROW 8.54 COL 19.86 NO-LABEL
     c-desc-fornec-pis AT ROW 5.83 COL 66.72 COLON-ALIGNED NO-LABEL
     fi-despes-cofins AT ROW 7.46 COL 24.57 COLON-ALIGNED
     c-desc-desp-cofins AT ROW 7.46 COL 30.72 COLON-ALIGNED NO-LABEL
     fi-cd-fornec-cofins AT ROW 7.46 COL 57.57 COLON-ALIGNED
     c-desc-fornec-cofins AT ROW 7.46 COL 66.72 COLON-ALIGNED NO-LABEL
     fi-despes-icms AT ROW 9.13 COL 24.57 COLON-ALIGNED
     lb-ipi AT ROW 3.67 COL 20 NO-LABEL
     c-desc-desp-icms AT ROW 9.13 COL 30.72 COLON-ALIGNED NO-LABEL
     fi-cd-fornec-icms AT ROW 9.08 COL 57.57 COLON-ALIGNED
     lb-pis AT ROW 5.29 COL 19.86 NO-LABEL
     c-desc-fornec-icms AT ROW 9.08 COL 66.72 COLON-ALIGNED NO-LABEL
     tt-param-imp.cdn-despes-iva AT ROW 4.17 COL 24.57 COLON-ALIGNED WIDGET-ID 40
          LABEL "Despesa"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-desp-iva AT ROW 4.17 COL 30.72 COLON-ALIGNED NO-LABEL WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 6.08
         SIZE 87.43 BY 14.67
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage3
     lb-isd AT ROW 5.29 COL 19.86 NO-LABEL
     tt-param-imp.cdn-emit-iva AT ROW 4.17 COL 57.57 COLON-ALIGNED WIDGET-ID 38
          LABEL "Fornecedor"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-desc-fornec-iva AT ROW 4.17 COL 66.72 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     tt-param-imp.cdn-despes-tax-estatis AT ROW 5.83 COL 24.57 COLON-ALIGNED WIDGET-ID 48
          LABEL "Despesa"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-desp-est AT ROW 5.83 COL 30.72 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     tt-param-imp.cdn-emit-tax-estatis AT ROW 5.83 COL 57.57 COLON-ALIGNED WIDGET-ID 46
          LABEL "Fornecedor"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-desc-fornec-est AT ROW 5.83 COL 66.72 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     cdn-despes-saida-div-aux AT ROW 5.83 COL 24.57 COLON-ALIGNED WIDGET-ID 48
     c-desc-isd AT ROW 5.83 COL 30.72 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     fi-cod-fornec-pais AT ROW 7.46 COL 57.57 COLON-ALIGNED WIDGET-ID 56
     c-desc-fornec-pais AT ROW 7.46 COL 66.72 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     btFaixaImpto AT ROW 5.63 COL 7.43 HELP
          "Informar Valor Faixa Imposto" WIDGET-ID 52
     c-lbl-faixa-imposto AT ROW 5 COL 3.14 NO-LABEL WIDGET-ID 54
     RECT-23 AT ROW 1.13 COL 1
     RECT-25 AT ROW 4.04 COL 19.14
     RECT-26 AT ROW 5.67 COL 19
     RECT-27 AT ROW 7.29 COL 19.14
     RECT-28 AT ROW 8.92 COL 19.14
     RECT-30 AT ROW 2.33 COL 19.14
     RECT-74 AT ROW 10.5 COL 1 WIDGET-ID 2
     RECT-76 AT ROW 3.88 COL 2 WIDGET-ID 4
     RECT-77 AT ROW 11.88 COL 1 WIDGET-ID 10
     RECT-82 AT ROW 5.33 COL 2 WIDGET-ID 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 6.08
         SIZE 87.43 BY 14.67
         FONT 1.

DEFINE FRAME fpage2
     d-dt-ini-pis AT ROW 2.21 COL 19 COLON-ALIGNED
     c-trib-pis AT ROW 3.21 COL 19 COLON-ALIGNED
     l-inc-pis-base-icms AT ROW 3.21 COL 52
     c-formula-pis AT ROW 4.21 COL 21 NO-LABEL
     bt-calcula-pis AT ROW 4.46 COL 78
     tg-base-reduzida-pis AT ROW 7.13 COL 21 WIDGET-ID 2
     d-dt-ini-cofins AT ROW 8.79 COL 19 COLON-ALIGNED
     c-trib-cofins AT ROW 9.79 COL 19 COLON-ALIGNED
     l-inc-cofins-base-icms AT ROW 9.79 COL 52
     c-formula-cofins AT ROW 10.79 COL 21 NO-LABEL
     bt-calcula-cofins AT ROW 11.13 COL 78
     tg-base-reduzida-cofins AT ROW 13.75 COL 21 WIDGET-ID 6
     "COFINS" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 8.38 COL 5
     "C†lculo Valor PIS:" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 5.5 COL 9
     "C†lculo Valor COFINS:" VIEW-AS TEXT
          SIZE 15.57 BY .75 AT ROW 11.13 COL 5.43
     "PIS" VIEW-AS TEXT
          SIZE 3 BY .54 AT ROW 1.71 COL 6
     RECT-4 AT ROW 1.96 COL 2
     RECT-5 AT ROW 8.63 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 6.08
         SIZE 87.43 BY 13.92
         FONT 1.

DEFINE FRAME fPage6
     tg-ger-pro AT ROW 3 COL 23
     c-classe AT ROW 4.25 COL 21 COLON-ALIGNED
     c-desc-classe AT ROW 4.25 COL 27.14 COLON-ALIGNED NO-LABEL
     tg-ger-estq-emb AT ROW 5.5 COL 23.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 6.08
         SIZE 87.43 BY 14.67
         FONT 1.

DEFINE FRAME fpage5
     c-cpf-repres AT ROW 2.13 COL 23.29 COLON-ALIGNED
     c-nome AT ROW 3.13 COL 23.29 COLON-ALIGNED
     btTaxa AT ROW 4.63 COL 51 HELP
          "Confirma alteraá‰es"
     l-util-rat-sis AT ROW 5 COL 25.72
     i-desp-siscomex AT ROW 6 COL 23.72 COLON-ALIGNED
     c-des-despesa AT ROW 6 COL 29.72 COLON-ALIGNED NO-LABEL
     i-forn-siscomex AT ROW 7 COL 23.72 COLON-ALIGNED
     c-des-forn AT ROW 7 COL 33.14 COLON-ALIGNED NO-LABEL
     i-mo-codigo AT ROW 9.17 COL 23.72 COLON-ALIGNED HELP
          "F5 para zoom"
     c-desc-moeda AT ROW 9.17 COL 33.14 COLON-ALIGNED NO-LABEL
     tg-solicita-li-itens AT ROW 11.33 COL 25.72 HELP
          "Todos os itens desse estabelecimento necessitam Li?"
     "Convers∆o" VIEW-AS TEXT
          SIZE 11.72 BY .92 AT ROW 8.33 COL 6.29
     "Rateio Siscomex" VIEW-AS TEXT
          SIZE 11.72 BY .83 AT ROW 4.25 COL 6.29
     RECT-33 AT ROW 1.75 COL 3
     RECT-34 AT ROW 4.5 COL 3
     RECT-35 AT ROW 8.58 COL 3
     RECT-37 AT ROW 10.75 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 6.08
         SIZE 87.43 BY 14.67
         FONT 1.

DEFINE FRAME fpage4
     tt-param-imp.des-layout-origin-licenc-import AT ROW 1.83 COL 32 COLON-ALIGNED
          LABEL "Layout PrÇ-Licenáa de Importaá∆o":R35
          VIEW-AS FILL-IN 
          SIZE 48 BY .88
     bt-arq1 AT ROW 1.75 COL 82.29 HELP
          "Escolha do nome do arquivo"
     tt-param-imp.des-layout-autoriz-import AT ROW 3.67 COL 32 COLON-ALIGNED
          LABEL "Layout Solicitaá∆o Autorizaá∆o Importaá∆o":R41
          VIEW-AS FILL-IN 
          SIZE 48 BY .88
     bt-arq2 AT ROW 3.67 COL 82.29 HELP
          "Escolha do nome do arquivo"
     c-des-senha-docto AT ROW 5.5 COL 23 COLON-ALIGNED HELP
          "Senha para documento protegido"
     c-confirma-senha-docto AT ROW 5.5 COL 66 COLON-ALIGNED HELP
          "Confirmar Senha Documentos Gr†ficos"
     c-des-senha-pch AT ROW 6.5 COL 23 COLON-ALIGNED HELP
          "Senha Purchase Order Protegida"
     c-confirma-senha-pch AT ROW 6.5 COL 66 COLON-ALIGNED HELP
          "Confirmar Senha Purchase Order"
     RECT-31 AT ROW 1.5 COL 2
     RECT-32 AT ROW 3.33 COL 2
     RECT-75 AT ROW 5.21 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 6.08
         SIZE 87.43 BY 14.67
         FONT 1.

DEFINE FRAME fPage1
     tt-param-imp.esp-tit-transit AT ROW 1.5 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     FILL-IN-2 AT ROW 1.5 COL 36.14 COLON-ALIGNED NO-LABEL
     tt-param-imp.esp-tit-rec AT ROW 2.5 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     FILL-IN-3 AT ROW 2.5 COL 36.14 COLON-ALIGNED NO-LABEL
     tt-param-imp.hp-codigo AT ROW 3.5 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     FILL-IN-4 AT ROW 3.5 COL 36.14 COLON-ALIGNED NO-LABEL
     tt-param-imp.ct-transit-import AT ROW 4.5 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     desc-conta-transit AT ROW 4.5 COL 51.14 COLON-ALIGNED NO-LABEL
     tt-param-imp.sc-transit-import AT ROW 5.5 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     desc-ccusto-transit AT ROW 5.5 COL 51.14 COLON-ALIGNED NO-LABEL
     c-cta-aplic-nf AT ROW 7.13 COL 31 COLON-ALIGNED
     desc-cta-aplic-nf AT ROW 7.13 COL 51.14 COLON-ALIGNED NO-LABEL
     c-ccusto-aplic-nf AT ROW 8.08 COL 31 COLON-ALIGNED
     desc-ccusto-aplic-nf AT ROW 8.08 COL 51.14 COLON-ALIGNED NO-LABEL
     l-gera-primeira-remessa-nf-mae AT ROW 9.08 COL 33 WIDGET-ID 24
     tt-param-imp.hist-processo AT ROW 10.08 COL 33
          VIEW-AS TOGGLE-BOX
          SIZE 20.29 BY .88
     tg-sugere-loc-padrao AT ROW 11.08 COL 33
     tt-param-imp.int-1 AT ROW 12.54 COL 4.72 HELP
          "" NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Prazo Entrega", 1,
"Data  Embarque", 2,
"Data  Entrega", 3
          SIZE 16 BY 2.63
     tt-param-imp.log-1 AT ROW 13.58 COL 33.14 HELP
          "Informe  se usario relacionar† Ordens ou Parcelas ao Embarque" NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Ordens de Compra ", no,
"Parcelas de Compra", yes
          SIZE 20 BY 1.75
     l-dep-externo AT ROW 12.08 COL 33 WIDGET-ID 14
     tb-desp-itiner-autom AT ROW 14.42 COL 62.43 WIDGET-ID 20
     texto-informa AT ROW 11.88 COL 4.57 NO-LABEL
     texto-relaciona AT ROW 13 COL 31.29 COLON-ALIGNED NO-LABEL
     texto-despes-itiner AT ROW 13.79 COL 60.14 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     lb-nf-simples-remessa AT ROW 6.58 COL 6 COLON-ALIGNED NO-LABEL
     tt-param-imp.log-descons-iva-tit-mercad AT ROW 11.08 COL 33 WIDGET-ID 34
          LABEL "Desconsidera IVA T°tulo Mercadoria"
          VIEW-AS TOGGLE-BOX
          SIZE 33.57 BY .83
     RECT-1 AT ROW 12.13 COL 3.57
     RECT-3 AT ROW 13.29 COL 32
     RECT-6 AT ROW 14.21 COL 61 WIDGET-ID 16
     RECT-81 AT ROW 6.79 COL 3 WIDGET-ID 28
     RECT-83 AT ROW 1.33 COL 3 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 6.08
         SIZE 87.43 BY 14.67
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-param-imp T "?" NO-UNDO mgcex param-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-param-imp-trib T "?" NO-UNDO mgcex param-imp-trib
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 19.83
         WIDTH              = 90.43
         MAX-HEIGHT         = 37.21
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 37.21
         VIRTUAL-WIDTH      = 182.86
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE
       FRAME fpage2:FRAME = FRAME fPage0:HANDLE
       FRAME fpage3:FRAME = FRAME fPage0:HANDLE
       FRAME fpage4:FRAME = FRAME fPage0:HANDLE
       FRAME fpage5:FRAME = FRAME fPage0:HANDLE
       FRAME fPage6:FRAME = FRAME fPage0:HANDLE
       FRAME fPage7:FRAME = FRAME fPage0:HANDLE
       FRAME fPage8:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR RADIO-SET tt-param-imp.int-1 IN FRAME fPage1
   EXP-HELP                                                             */
ASSIGN 
       l-dep-externo:HIDDEN IN FRAME fPage1           = TRUE.

/* SETTINGS FOR RADIO-SET tt-param-imp.log-1 IN FRAME fPage1
   EXP-HELP                                                             */
/* SETTINGS FOR TOGGLE-BOX tt-param-imp.log-descons-iva-tit-mercad IN FRAME fPage1
   EXP-LABEL                                                            */
ASSIGN 
       tt-param-imp.log-descons-iva-tit-mercad:HIDDEN IN FRAME fPage1           = TRUE.

/* SETTINGS FOR FILL-IN texto-informa IN FRAME fPage1
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FRAME fpage2
   Custom                                                               */
/* SETTINGS FOR FRAME fpage3
   Custom                                                               */
ASSIGN 
       btFaixaImpto:HIDDEN IN FRAME fpage3           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-desp-cofins IN FRAME fpage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-desp-est IN FRAME fpage3
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-desp-est:HIDDEN IN FRAME fpage3           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-desp-icms IN FRAME fpage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-desp-ipi IN FRAME fpage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-desp-iva IN FRAME fpage3
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-desp-iva:HIDDEN IN FRAME fpage3           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-desp-pis IN FRAME fpage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-espec IN FRAME fpage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-fornec-cofins IN FRAME fpage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-fornec-est IN FRAME fpage3
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-fornec-est:HIDDEN IN FRAME fpage3           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-fornec-icms IN FRAME fpage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-fornec-ipi IN FRAME fpage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-fornec-iva IN FRAME fpage3
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-fornec-iva:HIDDEN IN FRAME fpage3           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-fornec-pais IN FRAME fpage3
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-fornec-pais:HIDDEN IN FRAME fpage3           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-fornec-pis IN FRAME fpage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-natur IN FRAME fpage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-lbl-antecip IN FRAME fpage3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-lbl-cotacao-automatica IN FRAME fpage3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-lbl-despesas-impostos IN FRAME fpage3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-lbl-faixa-imposto IN FRAME fpage3
   ALIGN-L                                                              */
ASSIGN 
       c-lbl-faixa-imposto:HIDDEN IN FRAME fpage3           = TRUE.

/* SETTINGS FOR FILL-IN c-lbl-ii IN FRAME fpage3
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN tt-param-imp.cdn-despes-iva IN FRAME fpage3
   EXP-LABEL                                                            */
ASSIGN 
       tt-param-imp.cdn-despes-iva:HIDDEN IN FRAME fpage3           = TRUE.

ASSIGN 
       cdn-despes-saida-div-aux:HIDDEN IN FRAME fpage3           = TRUE.

/* SETTINGS FOR FILL-IN tt-param-imp.cdn-despes-tax-estatis IN FRAME fpage3
   EXP-LABEL                                                            */
ASSIGN 
       tt-param-imp.cdn-despes-tax-estatis:HIDDEN IN FRAME fpage3           = TRUE.

/* SETTINGS FOR FILL-IN tt-param-imp.cdn-emit-iva IN FRAME fpage3
   EXP-LABEL                                                            */
ASSIGN 
       tt-param-imp.cdn-emit-iva:HIDDEN IN FRAME fpage3           = TRUE.

/* SETTINGS FOR FILL-IN tt-param-imp.cdn-emit-tax-estatis IN FRAME fpage3
   EXP-LABEL                                                            */
ASSIGN 
       tt-param-imp.cdn-emit-tax-estatis:HIDDEN IN FRAME fpage3           = TRUE.

/* SETTINGS FOR FILL-IN tt-param-imp.cod-espec-antecip IN FRAME fpage3
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN tt-param-imp.cod-ser-antecip IN FRAME fpage3
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR FILL-IN fi-cod-fornec-pais IN FRAME fpage3
   NO-ENABLE                                                            */
ASSIGN 
       fi-cod-fornec-pais:HIDDEN IN FRAME fpage3           = TRUE.

/* SETTINGS FOR FILL-IN lb-cofins IN FRAME fpage3
   ALIGN-L                                                              */
ASSIGN 
       lb-cofins:READ-ONLY IN FRAME fpage3        = TRUE.

/* SETTINGS FOR FILL-IN lb-icms IN FRAME fpage3
   ALIGN-L                                                              */
ASSIGN 
       lb-icms:READ-ONLY IN FRAME fpage3        = TRUE.

/* SETTINGS FOR FILL-IN lb-ipi IN FRAME fpage3
   ALIGN-L                                                              */
ASSIGN 
       lb-ipi:READ-ONLY IN FRAME fpage3        = TRUE.

/* SETTINGS FOR FILL-IN lb-isd IN FRAME fpage3
   ALIGN-L                                                              */
ASSIGN 
       lb-isd:READ-ONLY IN FRAME fpage3        = TRUE.

/* SETTINGS FOR FILL-IN lb-pis IN FRAME fpage3
   ALIGN-L                                                              */
ASSIGN 
       lb-pis:READ-ONLY IN FRAME fpage3        = TRUE.

/* SETTINGS FOR TOGGLE-BOX tt-param-imp.log-2 IN FRAME fpage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-param-imp.perc-max-antecip IN FRAME fpage3
   EXP-LABEL                                                            */
ASSIGN 
       RECT-82:HIDDEN IN FRAME fpage3           = TRUE.

/* SETTINGS FOR FRAME fpage4
   Custom                                                               */
/* SETTINGS FOR FILL-IN tt-param-imp.des-layout-autoriz-import IN FRAME fpage4
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-param-imp.des-layout-origin-licenc-import IN FRAME fpage4
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fpage5
                                                                        */
/* SETTINGS FOR FILL-IN c-des-despesa IN FRAME fpage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-forn IN FRAME fpage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-moeda IN FRAME fpage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage6
                                                                        */
/* SETTINGS FOR FRAME fPage7
                                                                        */
/* SETTINGS FOR FILL-IN lb-drawback IN FRAME fPage7
   ALIGN-L                                                              */
ASSIGN 
       lb-drawback:HIDDEN IN FRAME fPage7           = TRUE
       lb-drawback:READ-ONLY IN FRAME fPage7        = TRUE.

/* SETTINGS FOR FILL-IN lb-email-ato-concessorio IN FRAME fPage7
   ALIGN-L                                                              */
ASSIGN 
       lb-email-ato-concessorio:READ-ONLY IN FRAME fPage7        = TRUE.

ASSIGN 
       tt-param-imp.log-trata-depos-draw:HIDDEN IN FRAME fPage7           = TRUE.

ASSIGN 
       RECT-84:HIDDEN IN FRAME fPage7           = TRUE.

ASSIGN 
       tg-vincula-drb-emb:HIDDEN IN FRAME fPage7           = TRUE.

/* SETTINGS FOR FRAME fPage8
   L-To-R                                                               */
/* SETTINGS FOR FILL-IN c-desc-desp-cbs IN FRAME fPage8
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-desp-ibs-uf IN FRAME fPage8
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-desp-is IN FRAME fPage8
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-fornec-cbs IN FRAME fPage8
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-fornec-ibs-uf IN FRAME fPage8
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-fornec-is IN FRAME fPage8
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-natur-novo IN FRAME fPage8
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-lbl-cot-aut-novo IN FRAME fPage8
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-lbl-desp-imp-novo IN FRAME fPage8
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN tt-param-imp-trib.cdn-despes-impto-CBS IN FRAME fPage8
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-param-imp-trib.cdn-despes-impto-IBSMun IN FRAME fPage8
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-param-imp-trib.cdn-despes-impto-IBSUF IN FRAME fPage8
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-param-imp-trib.cdn-despes-impto-IS IN FRAME fPage8
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-param-imp-trib.cdn-fornec-CBS IN FRAME fPage8
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-param-imp-trib.cdn-fornec-IBSMun IN FRAME fPage8
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-param-imp-trib.cdn-fornec-IBSUF IN FRAME fPage8
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-param-imp-trib.cdn-fornec-IS IN FRAME fPage8
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-param-imp-trib.cod-natur-operac-novo-impto IN FRAME fPage8
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN lb-cbs IN FRAME fPage8
   ALIGN-L                                                              */
ASSIGN 
       lb-cbs:READ-ONLY IN FRAME fPage8        = TRUE.

/* SETTINGS FOR FILL-IN lb-ibsmun IN FRAME fPage8
   ALIGN-L                                                              */
ASSIGN 
       lb-ibsmun:READ-ONLY IN FRAME fPage8        = TRUE.

/* SETTINGS FOR FILL-IN lb-ibsuf IN FRAME fPage8
   ALIGN-L                                                              */
ASSIGN 
       lb-ibsuf:READ-ONLY IN FRAME fPage8        = TRUE.

/* SETTINGS FOR FILL-IN lb-is IN FRAME fPage8
   ALIGN-L                                                              */
ASSIGN 
       lb-is:READ-ONLY IN FRAME fPage8        = TRUE.

/* SETTINGS FOR TOGGLE-BOX tt-param-imp-trib.log-cotac-autom-CBS IN FRAME fPage8
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-param-imp-trib.log-cotac-autom-IBSMun IN FRAME fPage8
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-param-imp-trib.log-cotac-autom-IBSUF IN FRAME fPage8
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-param-imp-trib.log-cotac-autom-IS IN FRAME fPage8
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-param-imp-trib.log-gerac-cot-desp-novo-impto IN FRAME fPage8
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage3
/* Query rebuild information for FRAME fpage3
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage4
/* Query rebuild information for FRAME fpage4
     _Query            is NOT OPENED
*/  /* FRAME fpage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage5
/* Query rebuild information for FRAME fpage5
     _Query            is NOT OPENED
*/  /* FRAME fpage5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage7
/* Query rebuild information for FRAME fPage7
     _Query            is NOT OPENED
*/  /* FRAME fPage7 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage8
/* Query rebuild information for FRAME fPage8
     _Query            is NOT OPENED
*/  /* FRAME fPage8 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME bt-arq1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq1 wMaintenance
ON CHOOSE OF bt-arq1 IN FRAME fpage4
DO:
    {utp/ut-liter.i Escolha_um_diret¢rio}
    RUN utp/ut-dir.p (INPUT RETURN-VALUE,
                      OUTPUT tt-param-imp.des-layout-origin-licenc-import,
                      OUTPUT l-ok). /* se cancelado = yes */
    IF NOT l-ok THEN
        DISP tt-param-imp.des-layout-origin-licenc-import WITH FRAME fpage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arq2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq2 wMaintenance
ON CHOOSE OF bt-arq2 IN FRAME fpage4
DO:
    {utp/ut-liter.i Escolha_um_diret¢rio}
    RUN utp/ut-dir.p (INPUT RETURN-VALUE,
                      OUTPUT tt-param-imp.des-layout-autoriz-import,
                      OUTPUT l-ok). /* se cancelado = yes */
    IF NOT l-ok THEN
        DISP tt-param-imp.des-layout-autoriz-import WITH FRAME fpage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME bt-calcula-cofins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-calcula-cofins wMaintenance
ON CHOOSE OF bt-calcula-cofins IN FRAME fpage2 /* Button 2 */
DO:
    ASSIGN INPUT FRAME fpage2 c-formula-cofins.
    RUN imp/im0000a.w (INPUT "C†lculo valor do COFINS":U,
                       INPUT-OUTPUT c-formula-cofins).
    DISP c-formula-cofins WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-calcula-pis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-calcula-pis wMaintenance
ON CHOOSE OF bt-calcula-pis IN FRAME fpage2 /* Button 1 */
DO:
    ASSIGN INPUT FRAME fpage2 c-formula-pis.
    RUN imp/im0000a.w (INPUT "C†lculo valor do PIS":U,
                       INPUT-OUTPUT c-formula-pis).
    DISP c-formula-pis WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.

    ASSIGN c-cpf-repres:FORMAT IN FRAME fpage5 = "X(19)":U.
    ASSIGN tt-param-imp.ct-transit-import:FORMAT IN FRAME fPage1 = "X(20)":U
           tt-param-imp.sc-transit-import:FORMAT IN FRAME fPage1 = "X(20)":U.

    ASSIGN c-cta-aplic-nf:format in frame fPage1 = "X(20)":U
           c-ccusto-aplic-nf:FORMAT IN FRAME fPage1 = "X(20)":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME btFaixaImpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFaixaImpto wMaintenance
ON CHOOSE OF btFaixaImpto IN FRAME fpage3 /* Faixa Imposto */
DO:
    IF  AVAIL tt-param-imp 
        AND CAN-FIND(FIRST estabelec
                     WHERE estabelec.cod-estabel = tt-param-imp.cod-estabel)THEN DO:

        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        RUN imp/im0007.w PERSISTENT SET h-im0007.
        IF  VALID-HANDLE (h-im0007) THEN DO:
            RUN pi-seta-param-imp   IN h-im0007 (INPUT tt-param-imp.cod-estabel).
            RUN initializeInterface IN h-im0007.
            WAIT-FOR CLOSE OF h-im0007 FOCUS CURRENT-WINDOW.
        END. 
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fPage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    
    {method/custom.i &Event="before-validate"
                     &Object="CONTAINER"
                     &ObjectHandle="THIS-PROCEDURE:HANDLE"
                     &FrameHandle="FRAME fPage0:HANDLE"
                     &Table="param-imp"
                     &RowidTable=tt-param-imp.r-rowid} 

    IF i-pais-impto-usuario = 1 THEN DO:
        run cdp/cd6666.p (input input frame fpage5 c-cpf-repres, 1).
        if return-value = "NOK" then return no-apply.
    END.
    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        IF  VALID-HANDLE(h-boar2084) THEN DO:

            IF NOT CAN-FIND (FIRST espec-ap 
                             WHERE espec-ap.cod-esp = c-classe:SCREEN-VALUE IN FRAME fPage6 NO-LOCK) THEN DO:

                {utp/ut-liter.i "Classe" *}
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 2,
                                   INPUT RETURN-VALUE). /*N∆o encontrado(a) &1 para chave informada. ~~ N∆o foi encontrada ocorrància em &1 com a chave informada. &2*/

                RUN SetFolder IN hFolder (INPUT 5).
                APPLY "ENTRY":U TO c-classe IN FRAME fPage6.
                RETURN "NOK".

            END.


            RUN pi-gera-reg-arg.
        END.
    END.

    ASSIGN c-estab-copy = tt-param-imp.cod-estabel.

    ASSIGN FRAME fPage0
          tt-param-imp.cod-estabel.

    ASSIGN FRAME fPage1
           tt-param-imp.esp-tit-transit
           tt-param-imp.esp-tit-rec
           tt-param-imp.hp-codigo
           tt-param-imp.ct-transit-import
           tt-param-imp.sc-transit-import
           tt-param-imp.hist-processo
           tt-param-imp.int-1
           tt-param-imp.log-1
           tt-param-imp.log-descons-iva-tit-mercad.

    ASSIGN FRAME fPage3 tt-param-imp.inc-icms-tot-nf
                        tt-param-imp.log-2
                        tt-param-imp.cod-espec-antecip
                        tt-param-imp.cod-ser-antecip
                        tt-param-imp.perc-max-antecip
                        i-emitente-ii
                        i-desp-ii
                        tt-param-imp.cdn-despes-iva
                        tt-param-imp.cdn-emit-iva
                        tt-param-imp.cdn-despes-tax-estatis
                        cdn-despes-saida-div-aux
                        tt-param-imp.cdn-emit-tax-estatis
                        fi-cod-fornec-pais.

    ASSIGN FRAME fPage7 tt-param-imp.log-trata-depos-draw.           
           
    assign input frame fPage4
           c-des-senha-docto
           c-des-senha-pch.

    assign input frame fpage4
          tt-param-imp.des-layout-origin-licenc-import 
          tt-param-imp.des-layout-autoriz-import.

    &if '{&bf_mat_versao_ems}' >= '2.09' &then
        ASSIGN tt-param-imp.cdn-moed-dolar    = INPUT FRAME fPage5 i-mo-codigo 
               tt-param-imp.des-respons-legal = INPUT FRAME fPage5 c-nome.
    &else
        ASSIGN tt-param-imp.int-2                  = INPUT FRAME fPage5 i-mo-codigo 
               OVERLAY(tt-param-imp.char-1,106,60) = INPUT FRAME fPage5 c-nome.      
    &endif

    ASSIGN tt-param-imp.log-gerac-cotac-despes-impto = INPUT FRAME fpage3 log-geracao
           tt-param-imp.cod-natur-operac-padr        = INPUT FRAME fpage3 c-nat-oper.

    /* Drawback */ 
    ASSIGN OVERLAY(tt-param-imp.char-1,227,1)  = IF INPUT FRAME fPage7 tg-ato-conces       = YES THEN "1":U ELSE "0":U
           OVERLAY(tt-param-imp.char-1,228,1)  = IF INPUT FRAME fPage7 tg-itens-ato-conces = YES THEN "1":U ELSE "0":U
           OVERLAY(tt-param-imp.char-1,229,1)  = IF INPUT FRAME fPage7 tg-doc-relacionados = YES THEN "1":U ELSE "0":U
           OVERLAY(tt-param-imp.char-1,230,3)  = INPUT FRAME fPage7 i-nr-dias-venc
           OVERLAY(tt-param-imp.char-1,233,12) = INPUT FRAME fPage7 c-usuario-email.

    ASSIGN OVERLAY(tt-param-imp.char-1,169,1) = IF INPUT FRAME fPage1 l-gera-primeira-remessa-nf-mae THEN "S":U ELSE "N":U.

    IF i-pais-impto-usuario = 1 THEN DO:
        /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
        ASSIGN  tt-param-imp.log-cotac-autom-impto-import = INPUT FRAME fpage3 log-cotac-impto
                tt-param-imp.log-cotac-autom-ipi          = INPUT FRAME fpage3 log-cotac-ipi
                tt-param-imp.log-cotac-autom-pis          = INPUT FRAME fpage3 log-cotac-pis
                tt-param-imp.log-cotac-autom-cofins       = INPUT FRAME fpage3 log-cotac-cofins
                tt-param-imp.log-cotac-autom-icms         = INPUT FRAME fpage3 log-cotac-icms
                tt-param-imp.cdn-despes-impto-ipi         = INPUT FRAME fpage3 fi-despes-ipi
                tt-param-imp.cdn-fornec-ipi               = INPUT FRAME fpage3 fi-cd-fornec-ipi
                tt-param-imp.cdn-despes-impto-pis         = INPUT FRAME fpage3 fi-despes-pis
                tt-param-imp.cdn-fornec-pis               = INPUT FRAME fpage3 fi-cd-fornec-pis
                tt-param-imp.cdn-despes-impto-cofins      = INPUT FRAME fpage3 fi-despes-cofins
                tt-param-imp.cdn-fornec-cofins            = INPUT FRAME fpage3 fi-cd-fornec-cofins
                tt-param-imp.cdn-despes-impto-icms        = INPUT FRAME fpage3 fi-despes-icms
                tt-param-imp.cdn-fornec-icms              = INPUT FRAME fpage3 fi-cd-fornec-icms
                tt-param-imp.cod-cpf-repres               = INPUT FRAME fpage5 c-cpf-repres.               

        &if '{&bf_mat_versao_ems}' >= '2.07' &then
            IF  tt-param-imp.cdn-despes-siscomex <> INPUT FRAME fpage5 i-desp-siscomex THEN
                IF CAN-FIND(FIRST desp-embarque
                            WHERE desp-embarque.cod-estabel = tt-param-imp.cod-estabel
                              AND desp-embarque.cod-desp    = tt-param-imp.cdn-despes-siscomex) THEN DO:
        &ELSE
            IF  INT(SUBSTR(tt-param-imp.char-1, 91,5)) <> INPUT FRAME fpage5 i-desp-siscomex THEN
                IF CAN-FIND(FIRST desp-embarque
                            WHERE desp-embarque.cod-estabel = tt-param-imp.cod-estabel
                              AND desp-embarque.cod-desp    = INT(SUBSTR(tt-param-imp.char-1, 91,5))) THEN DO:
        &ENDIF
      
        
                RUN utp/ut-msgs.p (INPUT "show", 
                                   INPUT 33879,
                                   INPUT "").
                RETURN NO-APPLY.
            END.

        ASSIGN 
              &IF "{&BF_MAT_VERSAO_EMS}" >= "2.07" &THEN
                   l-utz-rat-sis-ant                = tt-param-imp.log-tax-siscomex
                   tt-param-imp.log-tax-siscomex    = INPUT FRAME fpage5 l-util-rat-sis
                   tt-param-imp.cdn-despes-siscomex = INPUT FRAME fpage5 i-desp-siscomex
                   tt-param-imp.cdn-emit-siscomex   = INPUT FRAME fpage5 i-forn-siscomex
              &ELSE
                   l-utz-rat-sis-ant                   = IF SUBSTR(tt-param-imp.char-1,105,1) = '1' THEN YES ELSE NO
                   OVERLAY (tt-param-imp.char-1,105,1) = IF INPUT FRAME fpage5 l-util-rat-sis = YES THEN '1' ELSE '0'
                   OVERLAY (tt-param-imp.char-1,91,5)  =    INPUT FRAME fpage5 i-desp-siscomex
                   OVERLAY (tt-param-imp.char-1,96,9)  =    INPUT FRAME fpage5 i-forn-siscomex
              &ENDIF.

        IF i-pais-impto-usuario = 1 THEN DO:
            &if "{&bf_mat_versao_ems}" < "2.07" &then 
            
                IF  SUBSTR(tt-param-imp.char-1,105,1) = '1' AND l-utz-rat-sis-ant <> INPUT FRAME fpage5 l-util-rat-sis THEN DO:

                    {utp/ut-liter.i Para_utilizacao_da_Taxa_Rateio_Siscomex_novo_codigo_de_Despesa *}
                    ASSIGN c-val-1 = RETURN-VALUE.
                    {utp/ut-liter.i Para_utilizacao_da_Taxa_Rateio_Siscomex_deve_ser_informado_o_codigo_de_uma_nova_Despesa_para_Rateio,_pois_caso_informado_uma_ja_utilizada,_nao_sera_possivel_desativar_a_utilizacao_desse_parametro}
      
                    RUN utp/ut-msgs.p (INPUT "Show", 
                                       INPUT 56116,
                                       INPUT c-val-1 + "~~" + RETURN-VALUE ).
                END.
            &else
                IF  tt-param-imp.log-tax-siscomex AND 
                    l-utz-rat-sis-ant <> INPUT FRAME fpage5 l-util-rat-sis THEN DO:
                    
                    {utp/ut-liter.i Para_utilizacao_da_Taxa_Rateio_Siscomex_novo_codigo_de_Despesa *}
                    ASSIGN c-val-1 = RETURN-VALUE.
                    {utp/ut-liter.i Para_utilizacao_da_Taxa_Rateio_Siscomex_deve_ser_informado_o_codigo_de_uma_nova_Despesa_para_Rateio,_pois_caso_informado_uma_ja_utilizada,_nao_sera_possivel_desativar_a_utilizacao_desse_parametro}
                    
                    RUN utp/ut-msgs.p (INPUT "Show", 
                                       INPUT 56116,
                                       INPUT c-val-1 + "~~" + RETURN-VALUE).
                END.
            &endif
        END.
             
        IF  c-cpf-repres:SCREEN-VALUE = "" THEN 
            ASSIGN c-cpf-repres:FORMAT IN FRAME fpage5 = "x(19)":U.
    
        IF  c-cpf-repres:SCREEN-VALUE <> "" THEN
            ASSIGN c-cpf-repres:FORMAT IN FRAME fpage5 = IF AVAIL param-global
                                                         THEN param-global.formato-id-pessoal
                                                         ELSE "x(19)":U.
    
        
        /*##############validacao conta*/
         ASSIGN v_cod_cta_ctbl = INPUT tt-param-imp.ct-transit-import.
         RUN valida_conta(INPUT-OUTPUT v_cod_cta_ctbl, OUTPUT v_log_utz_ccusto).
         IF RETURN-VALUE <> "OK" THEN DO:  
            RUN SetFolder IN hFolder (INPUT 1).
            run utp/ut-msgs.p (input "show", 
                               input 17006, 
                               STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
            apply 'entry' to tt-param-imp.ct-transit-import in frame fPage1.
            RETURN "NOK":U.
         END.
         ELSE DO:
             IF v_log_utz_ccusto = YES THEN DO:
                 ASSIGN v_cod_ccusto = INPUT tt-param-imp.sc-transit-import.
                 RUN valida_ccusto(INPUT v_cod_ccusto).
                 IF RETURN-VALUE <> "OK" THEN DO:
                     RUN SetFolder IN hFolder (INPUT 1).
                     run utp/ut-msgs.p (input "show", 
                                        input 17006, 
                                        STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).       
                     apply 'entry' to tt-param-imp.sc-transit-import in frame fPage1.
                     RETURN "NOK":U.
                 END.
             END.
         END.

         
         /*############*/


        ASSIGN INPUT FRAME fpage2 c-trib-cofins
               INPUT FRAME fpage2 c-trib-pis.
    
       ASSIGN tt-param-imp.idi-tributac-cofins  = {ininc/i04in176.i 06 c-trib-cofins} 
              tt-param-imp.idi-tributac-pis     = {ininc/i04in176.i 06 c-trib-pis}.
    
       IF  INPUT FRAME fpage2 d-dt-ini-pis <> ? THEN
           ASSIGN tt-param-imp.dat-pis-recup    = INPUT FRAME fpage2 d-dt-ini-pis.
    
       IF INPUT FRAME fpage2 d-dt-ini-cofins <> ? THEN
           ASSIGN tt-param-imp.dat-cofins-recup = INPUT FRAME fpage2 d-dt-ini-cofins.

       assign tt-param-imp.dsl-formul-base-calc-pis       = input frame fpage2 c-formula-pis    
              tt-param-imp.dsl-formul-base-calc-cofins    = input frame fpage2 c-formula-cofins 
              tt-param-imp.log-incid-pis-base-icms        = input frame fpage2 l-inc-pis-base-icms
              tt-param-imp.log-incid-cofins-base-icms     = input frame fpage2 l-inc-cofins-base-icms
              tt-param-imp.log-incid-icms-ipi-outros-of   = input frame fPage3 l-inc-icms-ipi-outros
              OVERLAY(tt-param-imp.char-1,245,1)          = IF tg-base-reduzida-pis:CHECKED    IN FRAME fPage2 THEN "1":U ELSE "":U
              OVERLAY(tt-param-imp.char-1,246,1)          = IF tg-base-reduzida-cofins:CHECKED IN FRAME fPage2 THEN "1":U ELSE "":U.
    END.
    ELSE
        ASSIGN OVERLAY(tt-param-imp.char-1,249,1) = IF INPUT FRAME fPage7 tg-vincula-drb-emb THEN "S":U ELSE "N":U.


    ASSIGN v_cod_cta_ctbl = INPUT c-cta-aplic-nf.
    IF v_cod_cta_ctbl <> "" THEN DO:
        RUN valida_conta(INPUT-OUTPUT v_cod_cta_ctbl, OUTPUT v_log_utz_ccusto).
        IF RETURN-VALUE <> "OK" THEN DO:
           RUN SetFolder IN hFolder (INPUT 1).
           run utp/ut-msgs.p (input "show", 
                              input 17006, 
                              STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).       
           apply 'entry' to c-cta-aplic-nf in frame fPage1.
           RETURN "NOK":U.
        END.
        ELSE DO:
            IF v_log_utz_ccusto = YES THEN DO:
                ASSIGN v_cod_ccusto = INPUT c-ccusto-aplic-nf.
                RUN valida_ccusto(INPUT v_cod_ccusto).
                IF RETURN-VALUE <> "OK" THEN DO:
                    RUN SetFolder IN hFolder (INPUT 1).
                    run utp/ut-msgs.p (INPUT "show", 
                                       INPUT 17006, 
                                       STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).       
                    apply 'entry' to c-ccusto-aplic-nf in frame fPage1.
                    RETURN "NOK":U.
                END.
            END.
        END.
    END.

    ASSIGN tt-param-imp.cod-cta-aplic-nf-simples-remes = INPUT FRAME fPage1 c-cta-aplic-nf
           tt-param-imp.cod-subconta-nf-simples-remes = INPUT FRAME fPage1 c-ccusto-aplic-nf.

    assign i-emitente-ii-i50                  = i-emitente-ii
           i-desp-ii-i50                      = i-desp-ii
           tt-param-imp.des-senha-docto       = c-des-senha-docto
           tt-param-imp.des-senha-pch-order   = c-des-senha-pch.


    ASSIGN OVERLAY(tt-param-imp.char-1,167,1) = IF INPUT FRAME fPage5 tg-solicita-li-itens THEN "S":U ELSE "N":U.

    IF i-pais-impto-usuario <> 2 THEN
           ASSIGN OVERLAY(tt-param-imp.char-1,166,1) = IF INPUT FRAME fPage1 tg-sugere-loc-padrao THEN "S":U ELSE "N":U.

    {cxbo/bocx250.i51 "no"}
    {cdp/cd4300.i4 "no" tt-param-imp.char-1}

   /*### IF  tt-param-imp.ct-transit-import:SCREEN-VALUE <> "" THEN 
        ASSIGN tt-param-imp.ct-transit-import:FORMAT IN FRAME fPage1 = IF p_cod_format_cta_ctbl <> "" 
                                                                          THEN p_cod_format_cta_ctbl
                                                                          ELSE "x(20)":U.           */

    IF l-trata-dep-externos THEN
        ASSIGN OVERLAY(tt-param-imp.char-1,226,1) = IF l-dep-externo:CHECKED IN FRAME fPage1 THEN "S" ELSE "N".
    ELSE
        ASSIGN OVERLAY(tt-param-imp.char-1,226,1) = "N".

    IF tb-desp-itiner-autom:CHECKED IN FRAME fPage1 THEN
        ASSIGN OVERLAY(tt-param-imp.char-1,168,1) = "S".
    ELSE
        ASSIGN OVERLAY(tt-param-imp.char-1,168,1) = "N".
    /* EMS5 */
    if  can-find(FIRST funcao 
                 WHERE funcao.cd-funcao = "adm-apb-ems-5.00" 
                   AND funcao.ativo = yes 
                   AND funcao.log-1 = yes) then
        run pi-conecta-bases-EMS5 in h-bocx250 (output l-emsbas,
                                                output l-emsfin,
                                                output l-emsuni,
                                                output l-ems50-erro).

    run setConfirmaSenha    in h-bocx250 (input frame fPage4 c-confirma-senha-docto).
    run setConfirmaSenhaPch in h-bocx250 (input frame fPage4 c-confirma-senha-pch).
    
    {method/custom.i &Event="before-save"
                     &Object="CONTAINER"
                     &ObjectHandle="THIS-PROCEDURE:HANDLE"
                     &FrameHandle="FRAME fPage0:HANDLE"
                     &Table="param-imp"
                     &RowidTable=tt-param-imp.r-rowid}                    
    
    IF  cAction = "ADD":U OR cAction = "COPY":U THEN DO: 
        run validateCreate in h-bocx250 (input table tt-param-imp,
                                         input l-ems50-erro,
                                         output table RowErrors,
                                         output r-rowid-temp).
       ASSIGN tt-param-imp.r-rowid = r-rowid-temp.

       IF cAction = "COPY":U THEN DO:
           RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17475, INPUT c-lbl-impto-faixa).
           IF RETURN-VALUE = "yes":U THEN DO:
               RUN piCopiaIternacImptoFaixa IN h-bocx250 (INPUT c-estab-copy,
                                                          INPUT tt-param-imp.cod-estabel,
                                                          OUTPUT TABLE RowErrors APPEND).
           END.
       END.
    END.
    ELSE DO:
        run validateUpdate in h-bocx250 (input table tt-param-imp,
                                         input tt-param-imp.r-rowid,
                                         input l-ems50-erro,
                                         output table RowErrors).
    END.

    /* Impostos2 */
    IF i-pais-impto-usuario = 1 AND NOT CAN-FIND(FIRST RowErrors) THEN DO:
        ASSIGN tt-param-imp-trib.cod-estabel = tt-param-imp.cod-estabel.
        ASSIGN INPUT FRAME fPage8
                tt-param-imp-trib.cod-natur-operac-novo-impto
                tt-param-imp-trib.log-gerac-cot-desp-novo-impto
                tt-param-imp-trib.log-cotac-autom-CBS
                tt-param-imp-trib.log-cotac-autom-IBSUF
                tt-param-imp-trib.log-cotac-autom-IBSMun
                tt-param-imp-trib.log-cotac-autom-IS
                tt-param-imp-trib.cdn-despes-impto-CBS
                tt-param-imp-trib.cdn-despes-impto-IBSUF
                tt-param-imp-trib.cdn-despes-impto-IBSMun
                tt-param-imp-trib.cdn-despes-impto-IS
                tt-param-imp-trib.cdn-fornec-CBS
                tt-param-imp-trib.cdn-fornec-IBSUF
                tt-param-imp-trib.cdn-fornec-IBSMun
                tt-param-imp-trib.cdn-fornec-IS.
                
        RUN goToKey IN h-bocx00511 (INPUT tt-param-imp.cod-estabel).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN emptyRowErrors IN h-bocx00511.
            RUN setRecord IN h-bocx00511 (INPUT TABLE tt-param-imp-trib).
            RUN updateRecord IN h-bocx00511.
        END.
        ELSE DO:
            RUN emptyRowErrors IN h-bocx00511.
            RUN setRecord IN h-bocx00511 (INPUT TABLE tt-param-imp-trib).
            RUN createRecord IN h-bocx00511.
        END.
        IF  RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-bocx00511 (OUTPUT TABLE RowErrors).
            {method/showmessage.i1}
            {method/showmessage.i2}
            RETURN "NOK":U.    
        END.
    END.
    
    IF i-pais-impto-usuario = 2 /* Argentina */ OR i-pais-impto-usuario = 21 THEN DO: /* Equador */

        EMPTY TEMP-TABLE tt-param-imp-internac.
        
        RUN goToKey IN h-bocx00476 (INPUT tt-param-imp.cod-estabel).
        IF RETURN-VALUE = "OK":U THEN
            RUN getRecord IN h-bocx00476 (OUTPUT TABLE tt-param-imp-internac).

        FIND FIRST tt-param-imp-internac NO-LOCK
            WHERE tt-param-imp-internac.cod-estabel = tt-param-imp.cod-estabel NO-ERROR.

        IF NOT AVAIL tt-param-imp-internac THEN DO:
            CREATE tt-param-imp-internac.
            ASSIGN tt-param-imp-internac.cdn-despes-saida-div = cdn-despes-saida-div-aux
                   tt-param-imp-internac.cod-estabel          = tt-param-imp.cod-estabel
                   tt-param-imp-internac.num-livre-1          = fi-cod-fornec-pais.

            RUN emptyRowErrors IN h-bocx00476.
            RUN setRecord IN h-bocx00476 (INPUT TABLE tt-param-imp-internac).
            RUN createRecord IN h-bocx00476.
        END.
        ELSE DO:
            ASSIGN tt-param-imp-internac.cdn-despes-saida-div = cdn-despes-saida-div-aux
                   tt-param-imp-internac.num-livre-1          = fi-cod-fornec-pais.
            RUN emptyRowErrors IN h-bocx00476.
            RUN setRecord IN h-bocx00476 (INPUT TABLE tt-param-imp-internac).
            RUN updateRecord IN h-bocx00476.
        END.
        
        IF  RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-bocx00476 ( OUTPUT TABLE RowErrors ).
            {method/showmessage.i1}
            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
            {method/showmessage.i2}
            RETURN "NOK":U.    
        END.
    END.

    /* EMS5 */
    if  can-find(FIRST funcao 
                 WHERE funcao.cd-funcao = "adm-apb-ems-5.00" 
                   AND funcao.ativo = yes 
                   AND funcao.log-1 = yes) 
    and not l-ems50-erro then
        run pi-desconecta-bases-EMS5 in h-bocx250 (input l-emsbas,
                                                   input l-emsfin,
                                                   input l-emsuni).

    IF  CAN-FIND(FIRST RowErrors) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/showmessage.w PERSISTENT SET hShowMsg.
        ELSE
            DELETE PROCEDURE hShowMsg.
        
        RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
        
        LEAVE.
    END.
    ELSE DO:
        IF i-pais-impto-usuario = 1 THEN DO:
            &if "{&bf_mat_versao_ems}" < "2.07" &then
                IF  SUBSTR(tt-param-imp.char-1,105,1) = '1' AND 
                    l-utz-rat-sis-ant <> INPUT FRAME fpage5 l-util-rat-sis THEN           
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 33665,
                                       INPUT "").   
                ELSE IF l-utz-rat-sis-ant <> INPUT FRAME fpage5 l-util-rat-sis THEN
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 33666,
                                       INPUT "").
            &else
                IF  tt-param-imp.log-tax-siscomex AND 
                    l-utz-rat-sis-ant <> INPUT FRAME fpage5 l-util-rat-sis THEN
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 33665,
                                       INPUT "").
                ELSE IF l-utz-rat-sis-ant <> INPUT FRAME fpage5 l-util-rat-sis THEN
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 33666,
                                       INPUT "").
            &endif
        END.
        
        RUN getRowid IN h-bocx250 (OUTPUT r-rowid-temp).
        RUN repositionRecord IN THIS-PROCEDURE (INPUT tt-param-imp.r-rowid).

        IF RETURN-VALUE = "NOK":U  THEN DO:
            /*Quando o registro n∆o vem selecionado pelo rowid*/
            &IF DEFINED(DBOVersion) <> 0 &THEN
                RUN openQuery IN {&hDBOTable} (INPUT 1).
            &ELSE
                RUN openQueryStatic IN {&hDBOTable} (INPUT "cod-emitente":U).
            &ENDIF
            RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid-temp).
        END.

        /*--- Seta estado das frames ---*/
        RUN disableFields IN THIS-PROCEDURE.

    END.
    
    {method/custom.i &Event="after-save"
                     &Object="CONTAINER"
                     &ObjectHandle="THIS-PROCEDURE:HANDLE"
                     &FrameHandle="FRAME fPage0:HANDLE"
                     &Table="param-imp"
                     &RowidTable=tt-param-imp.r-rowid}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="cxzoom/z01cx250.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME btTaxa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTaxa wMaintenance
ON CHOOSE OF btTaxa IN FRAME fpage5 /* Save */
DO:
    IF  AVAIL tt-param-imp 
        AND CAN-FIND(FIRST estabelec
                     WHERE estabelec.cod-estabel = tt-param-imp.cod-estabel)THEN DO:

        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        RUN imp/im0000ac.w PERSISTENT SET h-im0000ac (INPUT tt-param-imp.cod-estabel).
        IF  VALID-HANDLE (h-im0000ac) THEN DO:
            RUN initializeInterface IN h-im0000ac.
            WAIT-FOR CLOSE OF h-im0000ac FOCUS CURRENT-WINDOW.
        END. 
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fPage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:

    RUN updateRecord IN THIS-PROCEDURE.
    ASSIGN c-cpf-repres:FORMAT IN FRAME fpage5 = "X(19)":U.
    
    IF p_cod_format_cta_ctbl = "" THEN DO:                
        ASSIGN c-cta-aplic-nf:format in frame fPage1 = 'x(20)':U
               tt-param-imp.ct-transit-import:FORMAT IN FRAME fPage1 = "X(20)":U.
    END.
    ELSE DO:

        
        ASSIGN  c-cta-aplic-nf:format in frame fPage1 = IF c-cta-aplic-nf <> "" THEN 
                                                           p_cod_format_cta_ctbl
                                                        ELSE "X(20)":U.

        ASSIGN  tt-param-imp.ct-transit-import:FORMAT IN FRAME fPage1 = IF tt-param-imp.ct-transit-import <> "" THEN
                                                                            p_cod_format_cta_ctbl
                                                                        ELSE "X(20)":U.
    END.

    IF p_cod_format_ccusto = "" THEN DO: 
        ASSIGN c-ccusto-aplic-nf:FORMAT IN FRAME fPage1 = "X(20)":U
               tt-param-imp.sc-transit-import:FORMAT IN FRAME fPage1 = "X(20)":U.
    END.
    ELSE DO:
        ASSIGN  c-ccusto-aplic-nf:format in frame fPage1 = IF c-ccusto-aplic-nf <> "" THEN 
                                                             p_cod_format_ccusto
                                                           ELSE "X(20)":U.

        ASSIGN  tt-param-imp.sc-transit-import:FORMAT IN FRAME fPage1 = IF tt-param-imp.sc-transit-import <> "" THEN
                                                                            p_cod_format_ccusto
                                                                        ELSE "X(20)":U.
    END.

    IF  i-pais-impto-usuario = 2 OR i-pais-impto-usuario = 21 THEN
        APPLY "leave" TO cdn-despes-saida-div-aux IN FRAME fPage3.

    APPLY "entry" TO tt-param-imp.esp-tit-transit IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME c-ccusto-aplic-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplic-nf wMaintenance
ON ENTRY OF c-ccusto-aplic-nf IN FRAME fPage1 /* CCusto Aplicaá∆o NF Simples Remessa */
DO:
    ASSIGN c-ccusto-aplic-nf:FORMAT IN FRAME fPage1 = "x(20)":U.
    
    display c-ccusto-aplic-nf with frame fPage1.
    APPLY "ENTRY" TO SELF IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplic-nf wMaintenance
ON F5 OF c-ccusto-aplic-nf IN FRAME fPage1 /* CCusto Aplicaá∆o NF Simples Remessa */
DO:
      run pi_zoom_ccusto_x_cta_ctbl in h_api_ccust (input i-empresa,           /* EMPRESA EMS2 */
                                                    input "",                  /* ESTABELECIMENTO EMS2 */
                                                    input yes,                 /* TODOS ESTABELECIMENTOS ? */
                                                    input "",                  /* UNIDADE DE NEGOCIO */
                                                    input "",                  /* PLANO CONTAS */
                                                    input c-cta-aplic-nf,      /* CONTA */
                                                    input "",                  /* CODIGO DO PLANO CCUSTO */
                                                    input today,               /* DATA DE TRANSACAO */
                                                    output v_cod_ccusto,       /* CODIGO CCUSTO */
                                                    output v_des_ccusto,       /* DESCRICAO CCUSTO */
                                                    output table tt_log_erro). /* ERROS */ 
    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN c-ccusto-aplic-nf = v_cod_ccusto
               c-ccusto-aplic-nf:SCREEN-VALUE = v_cod_ccusto
               c-ccusto-aplic-nf:FORMAT IN FRAME fPage1 = IF v_cod_ccusto <> "" THEN 
                                                                p_cod_format_ccusto
                                                          ELSE
                                                              "X(20)":U.
    END.
    ELSE 
        ASSIGN c-ccusto-aplic-nf:FORMAT IN FRAME fPage1 = "x(20)".
    /*ASSIGN c-ccusto-aplic-nf = v_cod_ccusto
           c-ccusto-aplic-nf:SCREEN-VALUE = v_cod_ccusto
           c-ccusto-aplic-nf:FORMAT IN FRAME fPage1 = p_cod_format_ccusto.*/
    
    ASSIGN desc-ccusto-aplic-nf = v_des_ccusto.
    
    disp c-ccusto-aplic-nf desc-ccusto-aplic-nf with frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplic-nf wMaintenance
ON LEAVE OF c-ccusto-aplic-nf IN FRAME fPage1 /* CCusto Aplicaá∆o NF Simples Remessa */
DO:
    ASSIGN v_cod_ccusto = INPUT c-ccusto-aplic-nf.
    IF v_cod_ccusto <> "" THEN DO:
        run pi_busca_dados_ccusto in h_api_ccust (input  i-empresa,                /* EMPRESA EMS2 */
                                                  input  "",         /* CODIGO DO PLANO CCUSTO */
                                                  input  v_cod_ccusto, /* CCUSTO */
                                                  input  today,              /* DATA DE TRANSACAO */
                                                  output v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                                  output table tt_log_erro). /* ERROS */ 

         IF RETURN-VALUE = "NOK":U THEN
             RETURN NO-APPLY.

        FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
        IF NOT AVAIL tt_log_erro THEN
            ASSIGN c-ccusto-aplic-nf = v_cod_ccusto
                   c-ccusto-aplic-nf:FORMAT IN FRAME fPage1 = p_cod_format_ccusto
                   desc-ccusto-aplic-nf = v_des_ccusto.
        ELSE
            ASSIGN  c-ccusto-aplic-nf = v_cod_ccusto
                    desc-ccusto-aplic-nf = "". 
    END.
    ELSE
        ASSIGN  c-ccusto-aplic-nf = ""
                c-ccusto-aplic-nf:FORMAT IN FRAME fPage1 = "X(20)":U
                desc-ccusto-aplic-nf = "".

    disp c-ccusto-aplic-nf desc-ccusto-aplic-nf with frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplic-nf wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-ccusto-aplic-nf IN FRAME fPage1 /* CCusto Aplicaá∆o NF Simples Remessa */
DO:
    APPLY "f5":U TO SELF IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME c-classe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-classe wMaintenance
ON F5 OF c-classe IN FRAME fPage6 /* Classe */
DO:
  {include/zoomvar.i &prog-zoom= "adzoom/z01ad104.w"
                       &campo= c-classe IN FRAME {&FRAME-NAME}
                       &campozoom= "cod-esp"
                       &campo2= c-desc-classe IN FRAME {&FRAME-NAME}
                       &campozoom2=descricao
                       &frame= "fPage6"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-classe wMaintenance
ON LEAVE OF c-classe IN FRAME fPage6 /* Classe */
DO:
  
    FIND FIRST espec-ap WHERE espec-ap.cod-esp = c-classe:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.

    IF AVAIL espec-ap THEN
        ASSIGN c-desc-classe:SCREEN-VALUE IN FRAME {&FRAME-NAME} = espec-ap.descricao.
    ELSE
        ASSIGN c-desc-classe:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-classe wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-classe IN FRAME fPage6 /* Classe */
DO:
  APPLY 'f5':U TO c-classe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME c-confirma-senha-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-confirma-senha-docto wMaintenance
ON CTRL-C OF c-confirma-senha-docto IN FRAME fpage4 /* Confirmar Senha Documentos Gr†ficos */
DO:
    return no-apply.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-confirma-senha-docto wMaintenance
ON CTRL-INS OF c-confirma-senha-docto IN FRAME fpage4 /* Confirmar Senha Documentos Gr†ficos */
DO:
    return no-apply.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-confirma-senha-pch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-confirma-senha-pch wMaintenance
ON CTRL-C OF c-confirma-senha-pch IN FRAME fpage4 /* Confirmar Senha Purchase Order */
DO:
    return no-apply.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-confirma-senha-pch wMaintenance
ON CTRL-INS OF c-confirma-senha-pch IN FRAME fpage4 /* Confirmar Senha Purchase Order */
DO:
    return no-apply.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME c-cpf-repres
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cpf-repres wMaintenance
ON ENTRY OF c-cpf-repres IN FRAME fpage5 /* CPF Representante */
DO:
    
    ASSIGN INPUT FRAME fpage5 c-cpf-repres.

    ASSIGN c-cpf-repres:FORMAT IN FRAME fpage5 = IF AVAIL param-global 
                                                    THEN param-global.formato-id-pessoal
                                                 ELSE "x(19)":U.
    display c-cpf-repres with frame fpage5.
    {cdp/cd9998.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cpf-repres wMaintenance
ON LEAVE OF c-cpf-repres IN FRAME fpage5 /* CPF Representante */
DO:
    IF ERROR-STATUS:GET-NUMBER(1) <> 0 THEN
        ASSIGN c-cpf-repres:FORMAT IN FRAME fpage5 = "x(19)":U.
    ELSE DO:
        ASSIGN c-cpf-repres:FORMAT IN FRAME fpage5 = IF AVAIL param-global 
                                                     THEN param-global.formato-id-pessoal
                                                     ELSE "x(19)":U.
    END.
    {cdp/cd9998.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME c-cta-aplic-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cta-aplic-nf wMaintenance
ON ENTRY OF c-cta-aplic-nf IN FRAME fPage1 /* Conta Aplicaá∆o NF Simples Remessa */
DO:
    ASSIGN c-cta-aplic-nf:FORMAT IN FRAME fPage1 = "x(20)":U.
    ASSIGN c-ccusto-aplic-nf:SENSITIVE = YES.
    
    /*display c-cta-aplic-nf with frame fPage1.*/
    APPLY "ENTRY" TO SELF IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cta-aplic-nf wMaintenance
ON F5 OF c-cta-aplic-nf IN FRAME fPage1 /* Conta Aplicaá∆o NF Simples Remessa */
DO:

    run pi_zoom_cta_ctbl_integr in h_api_cta (input  i-empresa,                /* EMPRESA EMS2 */
                                              input  "CEP",              /* MπDULO */         
                                              input  "",            /* PLANO DE CONTAS */
                                              input  "(nenhum)",         /* FINALIDADES */ 
                                              input  today,              /* DATA TRANSACAO */ 
                                              output v_cod_cta_ctbl,     /* CODIGO CONTA */   
                                              output v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                              output table tt_log_erro). /* ERROS */ 
    IF v_cod_cta_ctbl <> "" THEN DO:
        ASSIGN c-cta-aplic-nf = v_cod_cta_ctbl
               c-cta-aplic-nf:SCREEN-VALUE = v_cod_cta_ctbl
               desc-cta-aplic-nf = v_des_cta_ctbl
               desc-cta-aplic-nf:SCREEN-VALUE = v_des_cta_ctbl.
        IF p_cod_format_cta_ctbl <> "" THEN
            c-cta-aplic-nf:FORMAT IN FRAME fPage1 = p_cod_format_cta_ctbl.
        ELSE
            c-cta-aplic-nf:FORMAT IN FRAME fPage1 = "X(20)":U.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cta-aplic-nf wMaintenance
ON LEAVE OF c-cta-aplic-nf IN FRAME fPage1 /* Conta Aplicaá∆o NF Simples Remessa */
DO:

    ASSIGN  c-cta-aplic-nf:FORMAT IN FRAME fPage1 = "X(20)"
            v_cod_cta_ctbl = INPUT c-cta-aplic-nf.
    
    run pi_busca_dados_cta_ctbl in h_api_cta (input        i-empresa,          /* EMPRESA EMS2 */
                                              input        "",                 /* PLANO DE CONTAS */
                                              input-output v_cod_cta_ctbl,     /* CONTA */
                                              input        today,              /* DATA TRANSACAO */   
                                              output       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                              output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                              output       v_num_sit_cta_ctbl, /* SITUA¯∞O DA CONTA */
                                              output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                              output table tt_log_erro).       /* ERROS */ 
    FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
    IF NOT AVAIL tt_log_erro THEN DO:
        ASSIGN c-cta-aplic-nf = v_cod_cta_ctbl
               c-cta-aplic-nf:SCREEN-VALUE = v_cod_cta_ctbl.
        IF p_cod_format_cta_ctbl <> "" THEN
            ASSIGN c-cta-aplic-nf:FORMAT IN FRAME fPage1 = p_cod_format_cta_ctbl.
        ELSE
            ASSIGN c-cta-aplic-nf:FORMAT IN FRAME fPage1 = "X(20)":U.
    
    
        ASSIGN desc-cta-aplic-nf = v_des_cta_ctbl
               desc-cta-aplic-nf:SCREEN-VALUE = v_des_cta_ctbl.                           
    
        /*Verifica utilizacao de centro de custo para a conta informada */
        run pi_verifica_utilizacao_ccusto in h_api_ccust (input i-empresa,                 /* EMPRESA EMS 2 */
                                                          input tt-param-imp.cod-estabel:SCREEN-VALUE IN FRAME fPage0,                 /* ESTABELECIMENTO EMS2 */
                                                          input "",             /* PLANO CONTAS */
                                                          input v_cod_cta_ctbl,          /* CONTA */
                                                          input  today,              /* DT TRANSACAO */
                                                          output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                          output table tt_log_erro). /* ERROS */
        FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
        IF NOT AVAIL tt_log_erro THEN DO:
            IF v_log_utz_ccusto = NO THEN
                ASSIGN  c-ccusto-aplic-nf:SENSITIVE = NO
                        c-ccusto-aplic-nf = ""
                        c-ccusto-aplic-nf:SCREEN-VALUE = ""
                        desc-ccusto-aplic-nf:SENSITIVE = NO
                        desc-ccusto-aplic-nf = ""
                        desc-ccusto-aplic-nf:SCREEN-VALUE = "".
        END.
        /*####*/
    END.
    ELSE 
        ASSIGN c-cta-aplic-nf:FORMAT IN FRAME fPage1 = "x(20)"
               desc-cta-aplic-nf = ""
               desc-cta-aplic-nf:SCREEN-VALUE = ""
               c-cta-aplic-nf = v_cod_cta_ctbl
               c-cta-aplic-nf:SCREEN-VALUE = v_cod_cta_ctbl.

    disp desc-cta-aplic-nf with frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cta-aplic-nf wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-cta-aplic-nf IN FRAME fPage1 /* Conta Aplicaá∆o NF Simples Remessa */
DO:
    APPLY "f5":U TO SELF IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME c-des-senha-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-des-senha-docto wMaintenance
ON CTRL-C OF c-des-senha-docto IN FRAME fpage4 /* Senha Documentos Gr†ficos */
DO:
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-des-senha-docto wMaintenance
ON CTRL-INS OF c-des-senha-docto IN FRAME fpage4 /* Senha Documentos Gr†ficos */
DO:
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-des-senha-pch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-des-senha-pch wMaintenance
ON CTRL-C OF c-des-senha-pch IN FRAME fpage4 /* Senha Purchase Order */
DO:
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-des-senha-pch wMaintenance
ON CTRL-INS OF c-des-senha-pch IN FRAME fpage4 /* Senha Purchase Order */
DO:
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME c-nat-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper wMaintenance
ON F5 OF c-nat-oper IN FRAME fpage3 /* Nat. Operaá∆o */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/ZoomFields.i
             &ProgramZoom="inzoom/z04in245.w"
             &FieldZoom1="nat-operacao"
             &FieldScreen1="c-nat-oper"
             &Frame1="fpage3"
             &FieldZoom2="denominacao"
             &FieldScreen2="c-desc-natur"
             &Frame2="fpage3"
             &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper wMaintenance
ON LEAVE OF c-nat-oper IN FRAME fpage3 /* Nat. Operaá∆o */
DO:
  
    assign input frame fpage3 c-nat-oper.
    
    run findNatureza in h-boin245 (input c-nat-oper,
                                   output c-return).
    if c-return = "":U then
        run getCharfield in h-boin245 (input "denominacao":U,output c-desc-natur).
    else 
        assign c-desc-natur = "":U.
    ASSIGN c-desc-natur:SCREEN-VALUE IN FRAME fPage3 = c-desc-natur.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nat-oper wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-nat-oper IN FRAME fpage3 /* Nat. Operaá∆o */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME c-usuario-email
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuario-email wMaintenance
ON F5 OF c-usuario-email IN FRAME fPage7 /* Usu†rio E-mail */
DO:
    {include/zoomvar.i &prog-zoom=unzoom/z01un178.w
                       &campo=c-usuario-email
                       &campozoom=cod_usuario
                       &frame=fpage7}                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuario-email wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-usuario-email IN FRAME fPage7 /* Usu†rio E-mail */
DO:
    APPLY "F5":U TO SELF IN FRAME fpage7.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage8
&Scoped-define SELF-NAME tt-param-imp-trib.cdn-despes-impto-CBS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-despes-impto-CBS wMaintenance
ON F5 OF tt-param-imp-trib.cdn-despes-impto-CBS IN FRAME fPage8 /* Despesa */
DO:
    {method/zoomfields.i 
      &ProgramZoom="cxzoom/z10cx095.w"
      &FieldZoom1="cod-desp"
      &FieldScreen1="tt-param-imp-trib.cdn-despes-impto-CBS"
      &Frame1="fpage8"
      &FieldZoom2="descricao"
      &FieldScreen2="c-desc-desp-cbs"
      &Frame2="fpage8"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-despes-impto-CBS wMaintenance
ON LEAVE OF tt-param-imp-trib.cdn-despes-impto-CBS IN FRAME fPage8 /* Despesa */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-bocx095"
        &FindMethod="findCodigo"
        &KeyValue1="tt-param-imp-trib.cdn-despes-impto-CBS:SCREEN-VALUE IN FRAME fpage8"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-desp-cbs"
        &Frame1="fpage8"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-despes-impto-CBS wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp-trib.cdn-despes-impto-CBS IN FRAME fPage8 /* Despesa */
DO:
  
   APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp-trib.cdn-despes-impto-IBSUF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-despes-impto-IBSUF wMaintenance
ON F5 OF tt-param-imp-trib.cdn-despes-impto-IBSUF IN FRAME fPage8 /* Despesa */
DO:
    {method/zoomfields.i 
    &ProgramZoom="cxzoom/z10cx095.w"
    &FieldZoom1="cod-desp"
    &FieldScreen1="tt-param-imp-trib.cdn-despes-impto-IBSUF"
    &Frame1="fpage8"
    &FieldZoom2="descricao"
    &FieldScreen2="c-desc-desp-ibs-uf"
    &Frame2="fpage8"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-despes-impto-IBSUF wMaintenance
ON LEAVE OF tt-param-imp-trib.cdn-despes-impto-IBSUF IN FRAME fPage8 /* Despesa */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-bocx095"
        &FindMethod="findCodigo"
        &KeyValue1="tt-param-imp-trib.cdn-despes-impto-IBSUF:SCREEN-VALUE IN FRAME fpage8"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-desp-ibs-uf"
        &Frame1="fpage8"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-despes-impto-IBSUF wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp-trib.cdn-despes-impto-IBSUF IN FRAME fPage8 /* Despesa */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp-trib.cdn-despes-impto-IBSMun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-despes-impto-IBSMun wMaintenance
ON F5 OF tt-param-imp-trib.cdn-despes-impto-IBSMun IN FRAME fPage8 /* Despesa */
DO:
    {method/zoomfields.i 
    &ProgramZoom="cxzoom/z10cx095.w"
    &FieldZoom1="cod-desp"
    &FieldScreen1="tt-param-imp-trib.cdn-despes-impto-IBSMun"
    &Frame1="fpage8"
    &FieldZoom2="descricao"
    &FieldScreen2="c-desc-desp-ibsmun"
    &Frame2="fpage8"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-despes-impto-IBSMun wMaintenance
ON LEAVE OF tt-param-imp-trib.cdn-despes-impto-IBSMun IN FRAME fPage8 /* Despesa */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-bocx095"
        &FindMethod="findCodigo"
        &KeyValue1="tt-param-imp-trib.cdn-despes-impto-IBSMun:SCREEN-VALUE IN FRAME fpage8"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-desp-ibsmun"
        &Frame1="fpage8"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-despes-impto-IBSMun wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp-trib.cdn-despes-impto-IBSMun IN FRAME fPage8 /* Despesa */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp-trib.cdn-despes-impto-IS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-despes-impto-IS wMaintenance
ON F5 OF tt-param-imp-trib.cdn-despes-impto-IS IN FRAME fPage8 /* Despesa */
DO:
    {method/zoomfields.i 
      &ProgramZoom="cxzoom/z10cx095.w"
      &FieldZoom1="cod-desp"
      &FieldScreen1="tt-param-imp-trib.cdn-despes-impto-IS"
      &Frame1="fpage8"
      &FieldZoom2="descricao"
      &FieldScreen2="c-desc-desp-is"
      &Frame2="fpage8"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-despes-impto-IS wMaintenance
ON LEAVE OF tt-param-imp-trib.cdn-despes-impto-IS IN FRAME fPage8 /* Despesa */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-bocx095"
        &FindMethod="findCodigo"
        &KeyValue1="tt-param-imp-trib.cdn-despes-impto-IS:SCREEN-VALUE IN FRAME fpage8"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-desp-is"
        &Frame1="fpage8"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-despes-impto-IS wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp-trib.cdn-despes-impto-IS IN FRAME fPage8 /* Despesa */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME tt-param-imp.cdn-despes-iva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cdn-despes-iva wMaintenance
ON F5 OF tt-param-imp.cdn-despes-iva IN FRAME fpage3 /* Despesa */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/zoomfields.i 
      &ProgramZoom="cxzoom/z10cx095.w"
      &FieldZoom1="cod-desp"
      &FieldScreen1="tt-param-imp.cdn-despes-iva"
      &Frame1="fpage3"
      &FieldZoom2="descricao"
      &FieldScreen2="c-desc-desp-iva"
      &Frame2="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cdn-despes-iva wMaintenance
ON LEAVE OF tt-param-imp.cdn-despes-iva IN FRAME fpage3 /* Despesa */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/referencefields.i 
        &HandleDBOLeave="h-bocx095"
        &FindMethod="findCodigo"
        &KeyValue1="tt-param-imp.cdn-despes-iva:SCREEN-VALUE IN FRAME fpage3"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-desp-iva"
        &Frame1="fpage3"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cdn-despes-iva wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp.cdn-despes-iva IN FRAME fpage3 /* Despesa */
DO:
  
   APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cdn-despes-saida-div-aux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cdn-despes-saida-div-aux wMaintenance
ON F5 OF cdn-despes-saida-div-aux IN FRAME fpage3 /* Despesa */
DO:     /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/

    {method/zoomfields.i 
        &ProgramZoom="cxzoom/z10cx095.w"
        &FieldZoom1="cod-desp"
        &FieldScreen1="cdn-despes-saida-div-aux"
        &Frame1="fPage3"
        &FieldZoom2="descricao"
        &FieldScreen2="c-desc-isd"
        &Frame2="fPage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cdn-despes-saida-div-aux wMaintenance
ON LEAVE OF cdn-despes-saida-div-aux IN FRAME fpage3 /* Despesa */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/

    IF  INPUT FRAME fPage3 cdn-despes-saida-div-aux > 0 THEN DO:
        {method/referencefields.i 
            &HandleDBOLeave="h-bocx095"
            &FindMethod="findCodigo"
            &KeyValue1="cdn-despes-saida-div-aux:SCREEN-VALUE IN FRAME fPage3"
            &FieldName1="descricao"
            &FieldScreen1="c-desc-isd"
            &Frame1="fPage3"}
    END.
    ELSE
        ASSIGN c-desc-isd:SCREEN-VALUE IN FRAME fPage3 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cdn-despes-saida-div-aux wMaintenance
ON MOUSE-SELECT-DBLCLICK OF cdn-despes-saida-div-aux IN FRAME fpage3 /* Despesa */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp.cdn-despes-tax-estatis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cdn-despes-tax-estatis wMaintenance
ON F5 OF tt-param-imp.cdn-despes-tax-estatis IN FRAME fpage3 /* Despesa */
DO:     /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/

    {method/zoomfields.i 
    &ProgramZoom="cxzoom/z10cx095.w"
    &FieldZoom1="cod-desp"
    &FieldScreen1="tt-param-imp.cdn-despes-tax-estatis"
    &Frame1="fpage3"
    &FieldZoom2="descricao"
    &FieldScreen2="c-desc-desp-est"
    &Frame2="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cdn-despes-tax-estatis wMaintenance
ON LEAVE OF tt-param-imp.cdn-despes-tax-estatis IN FRAME fpage3 /* Despesa */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/referencefields.i 
        &HandleDBOLeave="h-bocx095"
        &FindMethod="findCodigo"
        &KeyValue1="tt-param-imp.cdn-despes-tax-estatis:SCREEN-VALUE IN FRAME fpage3"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-desp-est"
        &Frame1="fpage3"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cdn-despes-tax-estatis wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp.cdn-despes-tax-estatis IN FRAME fpage3 /* Despesa */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp.cdn-emit-iva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cdn-emit-iva wMaintenance
ON F5 OF tt-param-imp.cdn-emit-iva IN FRAME fpage3 /* Fornecedor */
DO:
  
    {include/zoomvar.i
        &prog-zoom="adzoom/z03ad098.w"
        &campo="tt-param-imp.cdn-emit-iva"   
        &campozoom="cod-emitente"              
        &frame="fpage3"
        &campo2="c-desc-fornec-iva"
        &campozoom2="nome-abrev"
        &Frame2="fpage3"}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cdn-emit-iva wMaintenance
ON LEAVE OF tt-param-imp.cdn-emit-iva IN FRAME fpage3 /* Fornecedor */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boad098"
      &FindMethod="findCodigo"
      &KeyValue1="tt-param-imp.cdn-emit-iva:SCREEN-VALUE IN FRAME fpage3"
      &FieldName1="nome-abrev"
      &FieldScreen1="c-desc-fornec-iva"
      &Frame1="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cdn-emit-iva wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp.cdn-emit-iva IN FRAME fpage3 /* Fornecedor */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp.cdn-emit-tax-estatis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cdn-emit-tax-estatis wMaintenance
ON F5 OF tt-param-imp.cdn-emit-tax-estatis IN FRAME fpage3 /* Fornecedor */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {include/zoomvar.i
      &prog-zoom="adzoom/z03ad098.w"
      &campo="tt-param-imp.cdn-emit-tax-estatis"   
      &campozoom="cod-emitente"              
      &frame="fpage3"
      &campo2="c-desc-fornec-est"
      &campozoom2="nome-abrev"
      &Frame2="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cdn-emit-tax-estatis wMaintenance
ON LEAVE OF tt-param-imp.cdn-emit-tax-estatis IN FRAME fpage3 /* Fornecedor */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/referencefields.i 
    &HandleDBOLeave="h-boad098"
    &FindMethod="findCodigo"
    &KeyValue1="tt-param-imp.cdn-emit-tax-estatis:SCREEN-VALUE IN FRAME fpage3"
    &FieldName1="nome-abrev"
    &FieldScreen1="c-desc-fornec-est"
    &Frame1="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cdn-emit-tax-estatis wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp.cdn-emit-tax-estatis IN FRAME fpage3 /* Fornecedor */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage8
&Scoped-define SELF-NAME tt-param-imp-trib.cdn-fornec-CBS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-fornec-CBS wMaintenance
ON F5 OF tt-param-imp-trib.cdn-fornec-CBS IN FRAME fPage8 /* Fornecedor */
DO:
    {include/zoomvar.i
        &prog-zoom="adzoom/z03ad098.w"
        &campo="tt-param-imp-trib.cdn-fornec-cbs"   
        &campozoom="cod-emitente"              
        &frame="fpage8"
        &campo2="c-desc-fornec-cbs"
        &campozoom2="nome-abrev"
        &Frame2="fpage8"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-fornec-CBS wMaintenance
ON LEAVE OF tt-param-imp-trib.cdn-fornec-CBS IN FRAME fPage8 /* Fornecedor */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boad098"
      &FindMethod="findCodigo"
      &KeyValue1="tt-param-imp-trib.cdn-fornec-cbs:SCREEN-VALUE IN FRAME fpage8"
      &FieldName1="nome-abrev"
      &FieldScreen1="c-desc-fornec-cbs"
      &Frame1="fpage8"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-fornec-CBS wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp-trib.cdn-fornec-CBS IN FRAME fPage8 /* Fornecedor */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp-trib.cdn-fornec-IBSUF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-fornec-IBSUF wMaintenance
ON F5 OF tt-param-imp-trib.cdn-fornec-IBSUF IN FRAME fPage8 /* Fornecedor */
DO:
    {include/zoomvar.i
      &prog-zoom="adzoom/z03ad098.w"
      &campo="tt-param-imp-trib.cdn-fornec-IBSUF"   
      &campozoom="cod-emitente"              
      &frame="fpage8"
      &campo2="c-desc-fornec-ibs-uf"
      &campozoom2="nome-abrev"
      &Frame2="fpage8"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-fornec-IBSUF wMaintenance
ON LEAVE OF tt-param-imp-trib.cdn-fornec-IBSUF IN FRAME fPage8 /* Fornecedor */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-boad098"
        &FindMethod="findCodigo"
        &KeyValue1="tt-param-imp-trib.cdn-fornec-IBSUF:SCREEN-VALUE IN FRAME fpage8"
        &FieldName1="nome-abrev"
        &FieldScreen1="c-desc-fornec-ibs-uf"
        &Frame1="fpage8"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-fornec-IBSUF wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp-trib.cdn-fornec-IBSUF IN FRAME fPage8 /* Fornecedor */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp-trib.cdn-fornec-IBSMun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-fornec-IBSMun wMaintenance
ON F5 OF tt-param-imp-trib.cdn-fornec-IBSMun IN FRAME fPage8 /* Fornecedor */
DO:
    {include/zoomvar.i
      &prog-zoom="adzoom/z03ad098.w"
      &campo="tt-param-imp-trib.cdn-fornec-IBSMun"   
      &campozoom="cod-emitente"              
      &frame="fpage8"
      &campo2="c-desc-fornec-ibsmun"
      &campozoom2="nome-abrev"
      &Frame2="fpage8"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-fornec-IBSMun wMaintenance
ON LEAVE OF tt-param-imp-trib.cdn-fornec-IBSMun IN FRAME fPage8 /* Fornecedor */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-boad098"
        &FindMethod="findCodigo"
        &KeyValue1="tt-param-imp-trib.cdn-fornec-IBSMun:SCREEN-VALUE IN FRAME fpage8"
        &FieldName1="nome-abrev"
        &FieldScreen1="c-desc-fornec-ibsmun"
        &Frame1="fpage8"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-fornec-IBSMun wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp-trib.cdn-fornec-IBSMun IN FRAME fPage8 /* Fornecedor */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp-trib.cdn-fornec-IS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-fornec-IS wMaintenance
ON F5 OF tt-param-imp-trib.cdn-fornec-IS IN FRAME fPage8 /* Fornecedor */
DO:
    {include/zoomvar.i
      &prog-zoom="adzoom/z03ad098.w"
      &campo="tt-param-imp-trib.cdn-fornec-IS"   
      &campozoom="cod-emitente"              
      &frame="fpage8"
      &campo2="c-desc-fornec-is"
      &campozoom2="nome-abrev"
      &Frame2="fpage8"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-fornec-IS wMaintenance
ON LEAVE OF tt-param-imp-trib.cdn-fornec-IS IN FRAME fPage8 /* Fornecedor */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boad098"
      &FindMethod="findCodigo"
      &KeyValue1="tt-param-imp-trib.cdn-fornec-IS:SCREEN-VALUE IN FRAME fpage8"
      &FieldName1="nome-abrev"
      &FieldScreen1="c-desc-fornec-is"
      &Frame1="fpage8"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cdn-fornec-IS wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp-trib.cdn-fornec-IS IN FRAME fPage8 /* Fornecedor */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME tt-param-imp.cod-espec-antecip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cod-espec-antecip wMaintenance
ON ENTRY OF tt-param-imp.cod-espec-antecip IN FRAME fpage3 /* EspÇcie */
DO:
  IF SELF:SCREEN-VALUE = "":U OR 
     SELF:SCREEN-VALUE = ?    OR 
     SELF:SCREEN-VALUE = "  ":U THEN 
   ASSIGN SELF:FORMAT       = "X(2)":U
          SELF:SCREEN-VALUE = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cod-espec-antecip wMaintenance
ON F5 OF tt-param-imp.cod-espec-antecip IN FRAME fpage3 /* EspÇcie */
DO:
    {include/zoomvar.i 
        &prog-zoom=adzoom/z01ad103.w
        &campo=tt-param-imp.cod-espec-antecip
        &campozoom=cod-esp
        &frame=fPage3
        &campo2=c-desc-espec
        &campozoom2=descricao
        &frame2=fPage3}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cod-espec-antecip wMaintenance
ON LEAVE OF tt-param-imp.cod-espec-antecip IN FRAME fpage3 /* EspÇcie */
DO:
    IF  LENGTH(SELF:SCREEN-VALUE) <> 2 OR
        ERROR-STATUS:ERROR THEN 
        ASSIGN SELF:FORMAT = "X(2)":U.
    ELSE
        ASSIGN SELF:FORMAT = "!(2)":U.

    {method/referencefields.i 
        &HandleDBOLeave="h-boad104"
        &FindMethod="findEspecie"
        &KeyValue1="tt-param-imp.cod-espec-antecip:SCREEN-VALUE IN FRAME fPage3"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-espec"
        &Frame1="fPage3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cod-espec-antecip wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp.cod-espec-antecip IN FRAME fpage3 /* EspÇcie */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME tt-param-imp.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cod-estabel wMaintenance
ON F5 OF tt-param-imp.cod-estabel IN FRAME fPage0 /* Estabelecimento */
DO:
    {method/ZoomFields.i
        &ProgramZoom="adzoom/z10ad107.w"
        &FieldZoom1="cod-estabel"
        &FieldScreen1="tt-param-imp.cod-estabel"
        &Frame1="fPage0"
        &FieldZoom2="nome"
        &FieldScreen2="fill-in-1"
        &Frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cod-estabel wMaintenance
ON LEAVE OF tt-param-imp.cod-estabel IN FRAME fPage0 /* Estabelecimento */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-boad107"
        &FindMethod="findCodigo"
        &KeyValue1="tt-param-imp.cod-estabel:SCREEN-VALUE IN FRAME fPage0"
        &FieldName1="nome"
        &FieldScreen1="fill-in-1"
        &Frame1="fPage0"}
        
   ASSIGN i-empresa = i-empresa-prin.
          r-rowid-estabel = ?.

   IF VALID-HANDLE(h-boad107) THEN DO:
        EMPTY TEMP-TABLE tt-estabelec.
        RUN findCodigo IN h-boad107 (INPUT INPUT FRAME fpage0 tt-param-imp.cod-estabel,
                                     OUTPUT c-return).
        IF c-return = "":U THEN
            RUN GetCurrent IN h-boad107 (OUTPUT TABLE tt-estabelec).

        FOR FIRST tt-estabelec:
            ASSIGN r-rowid-estabel = tt-estabelec.r-rowid.
        END.
    END.

    RUN cdp/cd9970.p (INPUT r-rowid-estabel,
                      OUTPUT i-empresa).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp.cod-estabel IN FRAME fPage0 /* Estabelecimento */
DO:
    APPLY "F5":U TO SELF IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage8
&Scoped-define SELF-NAME tt-param-imp-trib.cod-natur-operac-novo-impto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cod-natur-operac-novo-impto wMaintenance
ON F5 OF tt-param-imp-trib.cod-natur-operac-novo-impto IN FRAME fPage8 /* Natureza Operaá∆o */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/ZoomFields.i
             &ProgramZoom="inzoom/z04in245.w"
             &FieldZoom1="nat-operacao"
             &FieldScreen1="tt-param-imp-trib.cod-natur-operac-novo-impto"
             &Frame1="fpage8"
             &FieldZoom2="denominacao"
             &FieldScreen2="c-desc-natur-novo"
             &Frame2="fpage8"
             &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cod-natur-operac-novo-impto wMaintenance
ON LEAVE OF tt-param-imp-trib.cod-natur-operac-novo-impto IN FRAME fPage8 /* Natureza Operaá∆o */
DO:
  
    ASSIGN INPUT FRAME fpage8 tt-param-imp-trib.cod-natur-operac-novo-impto.
    
    RUN findNatureza IN h-boin245 (INPUT tt-param-imp-trib.cod-natur-operac-novo-impto,
                                   OUTPUT c-return).
    IF c-return = "":U THEN
        RUN getCharfield IN h-boin245 (INPUT "denominacao":U,OUTPUT c-desc-natur-novo).
    ELSE 
        ASSIGN c-desc-natur-novo = "":U.
        
    ASSIGN c-desc-natur-novo:SCREEN-VALUE IN FRAME fPage8 = c-desc-natur-novo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.cod-natur-operac-novo-impto wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp-trib.cod-natur-operac-novo-impto IN FRAME fPage8 /* Natureza Operaá∆o */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME tt-param-imp.cod-ser-antecip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cod-ser-antecip wMaintenance
ON F5 OF tt-param-imp.cod-ser-antecip IN FRAME fpage3 /* SÇrie */
DO:
    {include/zoomvar.i 
        &prog-zoom=dizoom/z01di182.w
        &campo=tt-param-imp.cod-ser-antecip
        &campozoom=serie
        &frame="fPage3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.cod-ser-antecip wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp.cod-ser-antecip IN FRAME fpage3 /* SÇrie */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-param-imp.ct-transit-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.ct-transit-import wMaintenance
ON ENTRY OF tt-param-imp.ct-transit-import IN FRAME fPage1 /* Conta Transitoria Importacao */
DO: 
    ASSIGN  tt-param-imp.ct-transit-import:FORMAT IN FRAME fPage1 = "X(20)".
    ASSIGN  tt-param-imp.sc-transit-import:SENSITIVE = YES.
          
    display tt-param-imp.ct-transit-import with frame fPage1.
    APPLY "ENTRY" TO SELF IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.ct-transit-import wMaintenance
ON F5 OF tt-param-imp.ct-transit-import IN FRAME fPage1 /* Conta Transitoria Importacao */
DO:
    run pi_zoom_cta_ctbl_integr in h_api_cta (input  i-empresa,                /* EMPRESA EMS2 */
                                              input  "CEP",              /* MÖDULO */
                                              input  "",            /* PLANO DE CONTAS */
                                              input  "(nenhum)",            /* FINALIDADES */
                                              input  today,              /* DATA TRANSACAO */
                                              output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                              output v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                              output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                              output table tt_log_erro). /* ERROS */ 
    IF v_cod_cta_ctbl <> "" THEN DO:
        ASSIGN tt-param-imp.ct-transit-import = v_cod_cta_ctbl
               tt-param-imp.ct-transit-import:SCREEN-VALUE = v_cod_cta_ctbl
               desc-conta-transit = v_des_cta_ctbl
               desc-conta-transit:SCREEN-VALUE = v_des_cta_ctbl.
        IF p_cod_format_cta_ctbl <> "" THEN
            tt-param-imp.ct-transit-import:FORMAT IN FRAME fPage1 = p_cod_format_cta_ctbl.
        ELSE
            tt-param-imp.ct-transit-import:FORMAT IN FRAME fPage1 = "X(20)":U.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.ct-transit-import wMaintenance
ON LEAVE OF tt-param-imp.ct-transit-import IN FRAME fPage1 /* Conta Transitoria Importacao */
DO: 

    ASSIGN  tt-param-imp.ct-transit-import:FORMAT IN FRAME fPage1 = "X(20)"
            v_cod_cta_ctbl = tt-param-imp.ct-transit-import:SCREEN-VALUE.
    run pi_busca_dados_cta_ctbl in h_api_cta (input        i-empresa,                /* EMPRESA EMS2 */
                                              input        "",                 /* PLANO DE CONTAS */
                                              input-output v_cod_cta_ctbl,     /* CONTA */
                                              input        today,              /* DATA TRANSACAO */   
                                              output       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                              output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                              output       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */
                                              output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                              output table tt_log_erro).       /* ERROS */ 
    FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
    IF NOT AVAIL tt_log_erro THEN DO:
        ASSIGN tt-param-imp.ct-transit-import = v_cod_cta_ctbl
               tt-param-imp.ct-transit-import:SCREEN-VALUE = v_cod_cta_ctbl
               tt-param-imp.ct-transit-import:FORMAT IN FRAME fPage1 = p_cod_format_cta_ctbl WHEN p_cod_format_cta_ctbl <> "".
    
        ASSIGN desc-conta-transit = v_des_cta_ctbl.
       
         /*Verifica utilizacao de centro de custo para a conta informada */
        run pi_verifica_utilizacao_ccusto in h_api_ccust (input i-empresa,                 /* EMPRESA EMS 2 */
                                                          input tt-param-imp.cod-estabel:SCREEN-VALUE IN FRAME fPage0,                 /* ESTABELECIMENTO EMS2 */
                                                          input "",             /* PLANO CONTAS */
                                                          input v_cod_cta_ctbl,          /* CONTA */
                                                          input  today,              /* DT TRANSACAO */
                                                          output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                          output table tt_log_erro). /* ERROS */
        FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
        IF NOT AVAIL tt_log_erro THEN DO:
            IF v_log_utz_ccusto = NO THEN
                ASSIGN  tt-param-imp.sc-transit-import:SENSITIVE = NO
                        tt-param-imp.sc-transit-import = ""
                        tt-param-imp.sc-transit-import:SCREEN-VALUE = ""
                        desc-ccusto-transit:SENSITIVE = NO
                        desc-ccusto-transit = ""
                        desc-ccusto-transit:SCREEN-VALUE = "".
        END.
        /*####*/
    END.
    ELSE DO:
        IF AVAIL tt-param-imp THEN DO:
            ASSIGN desc-conta-transit = ""
                   desc-conta-transit:SCREEN-VALUE = ""
                   tt-param-imp.ct-transit-import = v_cod_cta_ctbl
                   tt-param-imp.ct-transit-import:SCREEN-VALUE = v_cod_cta_ctbl
                   tt-param-imp.ct-transit-import:FORMAT IN FRAME fPage1 = "x(20)".
        END.
    END.

    disp desc-conta-transit
         with frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.ct-transit-import wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp.ct-transit-import IN FRAME fPage1 /* Conta Transitoria Importacao */
DO:
    APPLY "F5":U TO SELF IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp.esp-tit-rec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.esp-tit-rec wMaintenance
ON F5 OF tt-param-imp.esp-tit-rec IN FRAME fPage1 /* Esp Titulo Recebimento */
DO:
        {method/ZoomFields.i
           &ProgramZoom="adzoom/z10ad104.w"
           &FieldZoom1="cod-esp"
           &FieldScreen1="tt-param-imp.esp-tit-rec"
           &Frame1="fPage1"
           &FieldZoom2="descricao"
           &FieldScreen2="fill-in-3"
           &Frame2="fPage1"
           &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.esp-tit-rec wMaintenance
ON LEAVE OF tt-param-imp.esp-tit-rec IN FRAME fPage1 /* Esp Titulo Recebimento */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-boad104"
        &FindMethod="findEspecie"
        &KeyValue1="tt-param-imp.esp-tit-rec:SCREEN-VALUE IN FRAME fPage1"
        &FieldName1="descricao"
        &FieldScreen1="fill-in-3"
        &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.esp-tit-rec wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp.esp-tit-rec IN FRAME fPage1 /* Esp Titulo Recebimento */
DO:
    APPLY "F5":U TO SELF IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp.esp-tit-transit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.esp-tit-transit wMaintenance
ON F5 OF tt-param-imp.esp-tit-transit IN FRAME fPage1 /* Esp Titulo TrÉnsito */
DO:
    {method/zoomfields.i 
        &ProgramZoom="adzoom/z10ad104.w"
        &FieldZoom1="cod-esp"
        &FieldScreen1="tt-param-imp.esp-tit-transit"
        &Frame1="fPage1"
        &FieldZoom2="descricao"
        &FieldScreen2="fill-in-2"
        &Frame2="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.esp-tit-transit wMaintenance
ON LEAVE OF tt-param-imp.esp-tit-transit IN FRAME fPage1 /* Esp Titulo TrÉnsito */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-boad104"
        &FindMethod="findEspecie"
        &KeyValue1="tt-param-imp.esp-tit-transit:SCREEN-VALUE IN FRAME fPage1"
        &FieldName1="descricao"
        &FieldScreen1="fill-in-2"
        &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.esp-tit-transit wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp.esp-tit-transit IN FRAME fPage1 /* Esp Titulo TrÉnsito */
DO:
    APPLY "F5":U TO SELF IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME fi-cd-fornec-cofins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-fornec-cofins wMaintenance
ON F5 OF fi-cd-fornec-cofins IN FRAME fpage3 /* Fornecedor */
DO:
    {include/zoomvar.i
    &prog-zoom="adzoom/z03ad098.w"
    &campo="fi-cd-fornec-cofins"   
    &campozoom="cod-emitente"              
    &frame="fpage3"
    &campo2="c-desc-fornec-cofins"
    &campozoom2="nome-abrev"
    &Frame2="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-fornec-cofins wMaintenance
ON LEAVE OF fi-cd-fornec-cofins IN FRAME fpage3 /* Fornecedor */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/referencefields.i 
      &HandleDBOLeave="h-boad098"
      &FindMethod="findCodigo"
      &KeyValue1="fi-cd-fornec-cofins:SCREEN-VALUE IN FRAME fpage3"
      &FieldName1="nome-abrev"
      &FieldScreen1="c-desc-fornec-cofins"
      &Frame1="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-fornec-cofins wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-cd-fornec-cofins IN FRAME fpage3 /* Fornecedor */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-fornec-icms
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-fornec-icms wMaintenance
ON F5 OF fi-cd-fornec-icms IN FRAME fpage3 /* Fornecedor */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {include/zoomvar.i
      &prog-zoom="adzoom/z03ad098.w"
      &campo="fi-cd-fornec-icms"   
      &campozoom="cod-emitente"              
      &frame="fpage3"
      &campo2="c-desc-fornec-icms"
      &campozoom2="nome-abrev"
      &Frame2="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-fornec-icms wMaintenance
ON LEAVE OF fi-cd-fornec-icms IN FRAME fpage3 /* Fornecedor */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/referencefields.i 
      &HandleDBOLeave="h-boad098"
      &FindMethod="findCodigo"
      &KeyValue1="fi-cd-fornec-icms:SCREEN-VALUE IN FRAME fpage3"
      &FieldName1="nome-abrev"
      &FieldScreen1="c-desc-fornec-icms"
      &Frame1="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-fornec-icms wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-cd-fornec-icms IN FRAME fpage3 /* Fornecedor */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-fornec-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-fornec-ipi wMaintenance
ON F5 OF fi-cd-fornec-ipi IN FRAME fpage3 /* Fornecedor */
DO:
  
    {include/zoomvar.i
        &prog-zoom="adzoom/z03ad098.w"
        &campo="fi-cd-fornec-ipi"   
        &campozoom="cod-emitente"              
        &frame="fpage3"
        &campo2="c-desc-fornec-ipi"
        &campozoom2="nome-abrev"
        &Frame2="fpage3"}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-fornec-ipi wMaintenance
ON LEAVE OF fi-cd-fornec-ipi IN FRAME fpage3 /* Fornecedor */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boad098"
      &FindMethod="findCodigo"
      &KeyValue1="fi-cd-fornec-ipi:SCREEN-VALUE IN FRAME fpage3"
      &FieldName1="nome-abrev"
      &FieldScreen1="c-desc-fornec-ipi"
      &Frame1="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-fornec-ipi wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-cd-fornec-ipi IN FRAME fpage3 /* Fornecedor */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-fornec-pis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-fornec-pis wMaintenance
ON F5 OF fi-cd-fornec-pis IN FRAME fpage3 /* Fornecedor */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {include/zoomvar.i
      &prog-zoom="adzoom/z03ad098.w"
      &campo="fi-cd-fornec-pis"   
      &campozoom="cod-emitente"              
      &frame="fpage3"
      &campo2="c-desc-fornec-pis"
      &campozoom2="nome-abrev"
      &Frame2="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-fornec-pis wMaintenance
ON LEAVE OF fi-cd-fornec-pis IN FRAME fpage3 /* Fornecedor */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/referencefields.i 
    &HandleDBOLeave="h-boad098"
    &FindMethod="findCodigo"
    &KeyValue1="fi-cd-fornec-pis:SCREEN-VALUE IN FRAME fpage3"
    &FieldName1="nome-abrev"
    &FieldScreen1="c-desc-fornec-pis"
    &Frame1="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-fornec-pis wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-cd-fornec-pis IN FRAME fpage3 /* Fornecedor */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-fornec-pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fornec-pais wMaintenance
ON F5 OF fi-cod-fornec-pais IN FRAME fpage3 /* Fornecedor */
DO:
    {include/zoomvar.i
      &prog-zoom="adzoom/z03ad098.w"
      &campo="fi-cod-fornec-pais"   
      &campozoom="cod-emitente"              
      &frame="fpage3"
      &campo2="c-desc-fornec-pais"
      &campozoom2="nome-abrev"
      &Frame2="fpage3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fornec-pais wMaintenance
ON LEAVE OF fi-cod-fornec-pais IN FRAME fpage3 /* Fornecedor */
DO:
    {method/referencefields.i 
    &HandleDBOLeave="h-boad098"
    &FindMethod="findCodigo"
    &KeyValue1="fi-cod-fornec-pais:SCREEN-VALUE IN FRAME fpage3"
    &FieldName1="nome-abrev"
    &FieldScreen1="c-desc-fornec-pais"
    &Frame1="fpage3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fornec-pais wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-cod-fornec-pais IN FRAME fpage3 /* Fornecedor */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-despes-cofins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-despes-cofins wMaintenance
ON F5 OF fi-despes-cofins IN FRAME fpage3 /* Despesa */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/zoomfields.i 
    &ProgramZoom="cxzoom/z10cx095.w"
    &FieldZoom1="cod-desp"
    &FieldScreen1="fi-despes-cofins"
    &Frame1="fpage3"
    &FieldZoom2="descricao"
    &FieldScreen2="c-desc-desp-cofins"
    &Frame2="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-despes-cofins wMaintenance
ON LEAVE OF fi-despes-cofins IN FRAME fpage3 /* Despesa */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/referencefields.i 
        &HandleDBOLeave="h-bocx095"
        &FindMethod="findCodigo"
        &KeyValue1="fi-despes-cofins:SCREEN-VALUE IN FRAME fpage3"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-desp-cofins"
        &Frame1="fpage3"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-despes-cofins wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-despes-cofins IN FRAME fpage3 /* Despesa */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-despes-icms
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-despes-icms wMaintenance
ON F5 OF fi-despes-icms IN FRAME fpage3 /* Despesa */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/zoomfields.i 
      &ProgramZoom="cxzoom/z10cx095.w"
      &FieldZoom1="cod-desp"
      &FieldScreen1="fi-despes-icms"
      &Frame1="fpage3"
      &FieldZoom2="descricao"
      &FieldScreen2="c-desc-desp-icms"
      &Frame2="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-despes-icms wMaintenance
ON LEAVE OF fi-despes-icms IN FRAME fpage3 /* Despesa */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/referencefields.i 
        &HandleDBOLeave="h-bocx095"
        &FindMethod="findCodigo"
        &KeyValue1="fi-despes-icms:SCREEN-VALUE IN FRAME fpage3"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-desp-icms"
        &Frame1="fpage3"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-despes-icms wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-despes-icms IN FRAME fpage3 /* Despesa */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-despes-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-despes-ipi wMaintenance
ON F5 OF fi-despes-ipi IN FRAME fpage3 /* Despesa */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/zoomfields.i 
      &ProgramZoom="cxzoom/z10cx095.w"
      &FieldZoom1="cod-desp"
      &FieldScreen1="fi-despes-ipi"
      &Frame1="fpage3"
      &FieldZoom2="descricao"
      &FieldScreen2="c-desc-desp-ipi"
      &Frame2="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-despes-ipi wMaintenance
ON LEAVE OF fi-despes-ipi IN FRAME fpage3 /* Despesa */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/referencefields.i 
        &HandleDBOLeave="h-bocx095"
        &FindMethod="findCodigo"
        &KeyValue1="fi-despes-ipi:SCREEN-VALUE IN FRAME fpage3"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-desp-ipi"
        &Frame1="fpage3"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-despes-ipi wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-despes-ipi IN FRAME fpage3 /* Despesa */
DO:
  
   APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-despes-pis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-despes-pis wMaintenance
ON F5 OF fi-despes-pis IN FRAME fpage3 /* Despesa */
DO:     /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/

    {method/zoomfields.i 
    &ProgramZoom="cxzoom/z10cx095.w"
    &FieldZoom1="cod-desp"
    &FieldScreen1="fi-despes-pis"
    &Frame1="fpage3"
    &FieldZoom2="descricao"
    &FieldScreen2="c-desc-desp-pis"
    &Frame2="fpage3"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-despes-pis wMaintenance
ON LEAVE OF fi-despes-pis IN FRAME fpage3 /* Despesa */
DO:
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    {method/referencefields.i 
        &HandleDBOLeave="h-bocx095"
        &FindMethod="findCodigo"
        &KeyValue1="fi-despes-pis:SCREEN-VALUE IN FRAME fpage3"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-desp-pis"
        &Frame1="fpage3"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-despes-pis wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-despes-pis IN FRAME fpage3 /* Despesa */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-param-imp.hp-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.hp-codigo wMaintenance
ON F5 OF tt-param-imp.hp-codigo IN FRAME fPage1 /* Histor Padr∆o */
DO:
    {method/zoomfields.i 
        &ProgramZoom="adzoom/z10ad142.w"
        &FieldZoom1="hp-codigo"
        &FieldScreen1="tt-param-imp.hp-codigo"
        &Frame1="fPage1"
        &FieldZoom2="descricao"
        &FieldScreen2="fill-in-4"
        &Frame2="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.hp-codigo wMaintenance
ON LEAVE OF tt-param-imp.hp-codigo IN FRAME fPage1 /* Histor Padr∆o */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-boad142"
        &FindMethod="findCodigo"
        &KeyValue1="tt-param-imp.hp-codigo:SCREEN-VALUE IN FRAME fPage1"
        &FieldName1="descricao"
        &FieldScreen1="fill-in-4"
        &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.hp-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp.hp-codigo IN FRAME fPage1 /* Histor Padr∆o */
DO:
    APPLY "F5":U TO SELF IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME i-desp-ii
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-desp-ii wMaintenance
ON F5 OF i-desp-ii IN FRAME fpage3 /* Despesa */
DO:
    {method/zoomfields.i 
        &ProgramZoom="cxzoom/z10cx095.w"
        &FieldZoom1="cod-desp"
        &FieldScreen1="i-desp-ii"
        &Frame1="fPage3"
        &FieldZoom2="descricao"
        &FieldScreen2="c-desp-ii"
        &Frame2="fPage3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-desp-ii wMaintenance
ON LEAVE OF i-desp-ii IN FRAME fpage3 /* Despesa */
DO:
    IF  INPUT FRAME fPage3 i-desp-ii > 0 THEN DO:
        {method/referencefields.i 
            &HandleDBOLeave="h-bocx095"
            &FindMethod="findCodigo"
            &KeyValue1="i-desp-ii:SCREEN-VALUE IN FRAME fPage3"
            &FieldName1="descricao"
            &FieldScreen1="c-desp-ii"
            &Frame1="fPage3"}
    END.
    ELSE
        ASSIGN c-desp-ii:SCREEN-VALUE IN FRAME fPage3 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-desp-ii wMaintenance
ON MOUSE-SELECT-DBLCLICK OF i-desp-ii IN FRAME fpage3 /* Despesa */
DO:
    apply "F5":U to self in frame fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME i-desp-siscomex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-desp-siscomex wMaintenance
ON F5 OF i-desp-siscomex IN FRAME fpage5 /* Despesa */
DO:
    {method/zoomfields.i
        &ProgramZoom="cxzoom/z10cx095.w"
        &FieldZoom1="cod-desp"
        &FieldScreen1="i-desp-siscomex"
        &Frame1="fpage5"
        &FieldZoom2="descricao"
        &FieldScreen2="c-des-despesa"
        &Frame2="fpage5"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-desp-siscomex wMaintenance
ON LEAVE OF i-desp-siscomex IN FRAME fpage5 /* Despesa */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-bocx095"
        &FindMethod="findCodigo"
        &KeyValue1="i-desp-siscomex:SCREEN-VALUE IN FRAME fpage5"
        &FieldName1="descricao"
        &FieldScreen1="c-des-despesa"
        &Frame1="fpage5"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-desp-siscomex wMaintenance
ON MOUSE-SELECT-DBLCLICK OF i-desp-siscomex IN FRAME fpage5 /* Despesa */
DO:
  APPLY "F5":U TO SELF IN FRAME fpage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME i-emitente-ii
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-emitente-ii wMaintenance
ON F5 OF i-emitente-ii IN FRAME fpage3 /* Fornecedor */
DO:
    &if defined(bf-mat-comex) &then
        assign l-implanta = no.
    &else
        assign l-implanta = yes.
    &endif

    {include/zoomvar.i
        &prog-zoom="adzoom/z03ad098.w"
        &campo="i-emitente-ii"
        &campozoom="cod-emitente"
        &frame="fPage3"
        &campo2="c-emitente-ii"
        &campozoom2="nome-abrev"
        &Frame2="fPage3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-emitente-ii wMaintenance
ON LEAVE OF i-emitente-ii IN FRAME fpage3 /* Fornecedor */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-boad098"
        &FindMethod="findCodigo"
        &KeyValue1="i-emitente-ii:SCREEN-VALUE IN FRAME fPage3"
        &FieldName1="nome-abrev"
        &FieldScreen1="c-emitente-ii"
        &Frame1="fPage3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-emitente-ii wMaintenance
ON MOUSE-SELECT-DBLCLICK OF i-emitente-ii IN FRAME fpage3 /* Fornecedor */
DO:
    apply "F5":U to self in frame fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME i-forn-siscomex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-forn-siscomex wMaintenance
ON F5 OF i-forn-siscomex IN FRAME fpage5 /* Fornecedor */
DO:
    ASSIGN l-implanta = NO.
    {include/zoomvar.i
        &prog-zoom="adzoom/z03ad098.w"
        &campo="i-forn-siscomex"
        &campozoom="cod-emitente"
        &frame="fpage5"
        &campo2="c-des-forn"
        &campozoom2="nome-abrev"
        &Frame2="fpage5"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-forn-siscomex wMaintenance
ON LEAVE OF i-forn-siscomex IN FRAME fpage5 /* Fornecedor */
DO:
    {method/referencefields.i
        &HandleDBOLeave="h-boad098"
        &FindMethod="findCodigo"
        &KeyValue1="i-forn-siscomex:SCREEN-VALUE IN FRAME fpage5"
        &FieldName1="nome-abrev"
        &FieldScreen1="c-des-forn"
        &Frame1="fpage5"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-forn-siscomex wMaintenance
ON MOUSE-SELECT-DBLCLICK OF i-forn-siscomex IN FRAME fpage5 /* Fornecedor */
DO:
  APPLY "F5":U TO SELF IN FRAME fpage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo wMaintenance
ON F5 OF i-mo-codigo IN FRAME fpage5 /* Moeda */
DO:
    {include/zoomvar.i &prog-zoom=unzoom/z01un005.w
                               &campo=i-mo-codigo
                               &campozoom=mo-codigo
                               &frame=fpage5}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo wMaintenance
ON LEAVE OF i-mo-codigo IN FRAME fpage5 /* Moeda */
DO:
    {method/referencefields.i
        &HandleDBOLeave="h-boun005"
        &FindMethod="findCodigo"
        &KeyValue1="int(i-mo-codigo:SCREEN-VALUE IN FRAME fPage5)"
        &FieldName1="descricao"
        &FieldScreen1="c-desc-moeda"
        &Frame1="fPage5"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF i-mo-codigo IN FRAME fpage5 /* Moeda */
DO:
  APPLY "F5":U TO SELF IN FRAME fpage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-util-rat-sis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-util-rat-sis wMaintenance
ON VALUE-CHANGED OF l-util-rat-sis IN FRAME fpage5 /* Utiliza Rateio Siscomex */
DO:
  IF  l-util-rat-sis :CHECKED = YES THEN
      ENABLE i-desp-siscomex i-forn-siscomex btTaxa WITH FRAME fpage5.
  ELSE DO:
      DISABLE i-desp-siscomex i-forn-siscomex btTaxa WITH FRAME fpage5.
      ASSIGN i-desp-siscomex:SCREEN-VALUE IN FRAME fpage5   = ""
             c-des-despesa:SCREEN-VALUE IN FRAME fpage5     = ""
             i-forn-siscomex:SCREEN-VALUE IN FRAME fpage5   = ""
             c-des-forn:SCREEN-VALUE IN FRAME fpage5        = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage8
&Scoped-define SELF-NAME tt-param-imp-trib.log-cotac-autom-CBS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.log-cotac-autom-CBS wMaintenance
ON VALUE-CHANGED OF tt-param-imp-trib.log-cotac-autom-CBS IN FRAME fPage8 /* CBS */
DO:
    IF tt-param-imp-trib.log-cotac-autom-cbs:CHECKED = YES THEN
        ENABLE tt-param-imp-trib.cdn-despes-impto-cbs 
               tt-param-imp-trib.cdn-fornec-cbs WITH FRAME fpage8.
    ELSE DO:
        DISABLE tt-param-imp-trib.cdn-despes-impto-cbs 
                tt-param-imp-trib.cdn-fornec-cbs WITH FRAME fpage8.
        ASSIGN tt-param-imp-trib.cdn-despes-impto-cbs:SCREEN-VALUE IN FRAME fpage8 = ""
               c-desc-desp-cbs:SCREEN-VALUE IN FRAME fpage8 = ""
               tt-param-imp-trib.cdn-fornec-cbs:SCREEN-VALUE IN FRAME fpage8 = ""
               c-desc-fornec-cbs:SCREEN-VALUE IN FRAME fpage8 = "".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp-trib.log-cotac-autom-IBSUF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.log-cotac-autom-IBSUF wMaintenance
ON VALUE-CHANGED OF tt-param-imp-trib.log-cotac-autom-IBSUF IN FRAME fPage8 /* IBS UF */
DO:
  
    IF tt-param-imp-trib.log-cotac-autom-IBSUF:CHECKED = YES THEN
        ENABLE tt-param-imp-trib.cdn-despes-impto-IBSUF 
               tt-param-imp-trib.cdn-fornec-IBSUF WITH FRAME fpage8.
    ELSE DO:
        DISABLE tt-param-imp-trib.cdn-despes-impto-IBSUF 
                tt-param-imp-trib.cdn-fornec-IBSUF WITH FRAME fpage8.
        ASSIGN tt-param-imp-trib.cdn-despes-impto-IBSUF:SCREEN-VALUE IN FRAME fpage8 = ""
               c-desc-desp-ibs-uf:SCREEN-VALUE IN FRAME fpage8 = ""
               tt-param-imp-trib.cdn-fornec-IBSUF:SCREEN-VALUE IN FRAME fpage8 = ""
               c-desc-fornec-ibs-uf:SCREEN-VALUE IN FRAME fpage8 = "".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp-trib.log-cotac-autom-IBSMun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.log-cotac-autom-IBSMun wMaintenance
ON VALUE-CHANGED OF tt-param-imp-trib.log-cotac-autom-IBSMun IN FRAME fPage8 /* IBS UF */
DO:
  
    IF tt-param-imp-trib.log-cotac-autom-IBSMun:CHECKED = YES THEN
        ENABLE tt-param-imp-trib.cdn-despes-impto-IBSMun 
               tt-param-imp-trib.cdn-fornec-IBSMun WITH FRAME fpage8.
    ELSE DO:
        DISABLE tt-param-imp-trib.cdn-despes-impto-IBSMun 
                tt-param-imp-trib.cdn-fornec-IBSMun WITH FRAME fpage8.
        ASSIGN tt-param-imp-trib.cdn-despes-impto-IBSMun:SCREEN-VALUE IN FRAME fpage8 = ""
               c-desc-desp-ibsmun:SCREEN-VALUE IN FRAME fpage8 = ""
               tt-param-imp-trib.cdn-fornec-IBSMun:SCREEN-VALUE IN FRAME fpage8 = ""
               c-desc-fornec-ibsmun:SCREEN-VALUE IN FRAME fpage8 = "".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp-trib.log-cotac-autom-IS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp-trib.log-cotac-autom-IS wMaintenance
ON VALUE-CHANGED OF tt-param-imp-trib.log-cotac-autom-IS IN FRAME fPage8 /* IS */
DO:
  
    IF tt-param-imp-trib.log-cotac-autom-IS:CHECKED = YES THEN
        ENABLE tt-param-imp-trib.cdn-despes-impto-IS 
               tt-param-imp-trib.cdn-fornec-IS WITH FRAME fpage8.
    ELSE DO:
        DISABLE tt-param-imp-trib.cdn-despes-impto-IS 
                tt-param-imp-trib.cdn-fornec-IS WITH FRAME fpage8.
        ASSIGN tt-param-imp-trib.cdn-despes-impto-IS:SCREEN-VALUE IN FRAME fpage8 = ""
               c-desc-desp-is:SCREEN-VALUE IN FRAME fpage8 = ""
               tt-param-imp-trib.cdn-fornec-IS:SCREEN-VALUE IN FRAME fpage8 = ""
               c-desc-fornec-is:SCREEN-VALUE IN FRAME fpage8 = "".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME log-cotac-cofins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL log-cotac-cofins wMaintenance
ON VALUE-CHANGED OF log-cotac-cofins IN FRAME fpage3 /* COFINS */
DO:
  
    IF log-cotac-cofins:CHECKED = YES THEN
        ENABLE fi-despes-cofins fi-cd-fornec-cofins WITH FRAME fpage3.
    ELSE DO:
        DISABLE fi-despes-cofins fi-cd-fornec-cofins WITH FRAME fpage3.
        ASSIGN fi-despes-cofins:SCREEN-VALUE IN FRAME fpage3     = ""
               c-desc-desp-cofins:SCREEN-VALUE IN FRAME fpage3   = ""
               fi-cd-fornec-cofins:SCREEN-VALUE IN FRAME fpage3  = ""
               c-desc-fornec-cofins:SCREEN-VALUE IN FRAME fpage3 = "".
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME log-cotac-icms
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL log-cotac-icms wMaintenance
ON VALUE-CHANGED OF log-cotac-icms IN FRAME fpage3 /* ICMS */
DO:
  
    IF log-cotac-icms:CHECKED = YES THEN
        ENABLE fi-despes-icms fi-cd-fornec-icms WITH FRAME fpage3.
    ELSE DO:
        DISABLE fi-despes-icms fi-cd-fornec-icms WITH FRAME fpage3.
        ASSIGN fi-despes-icms:SCREEN-VALUE IN FRAME fpage3     = ""
               c-desc-desp-icms:SCREEN-VALUE IN FRAME fpage3   = ""
               fi-cd-fornec-icms:SCREEN-VALUE IN FRAME fpage3  = ""
               c-desc-fornec-icms:SCREEN-VALUE IN FRAME fpage3 = "".
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME log-cotac-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL log-cotac-ipi wMaintenance
ON VALUE-CHANGED OF log-cotac-ipi IN FRAME fpage3 /* IPI */
DO:
  
    IF log-cotac-ipi:CHECKED = YES THEN
        ENABLE fi-despes-ipi fi-cd-fornec-ipi WITH FRAME fpage3.
    ELSE DO:
        DISABLE fi-despes-ipi fi-cd-fornec-ipi WITH FRAME fpage3.
        ASSIGN fi-despes-ipi:SCREEN-VALUE IN FRAME fpage3     = ""
               c-desc-desp-ipi:SCREEN-VALUE IN FRAME fpage3   = ""
               fi-cd-fornec-ipi:SCREEN-VALUE IN FRAME fpage3  = ""
               c-desc-fornec-ipi:SCREEN-VALUE IN FRAME fpage3 = "".
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME log-cotac-pis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL log-cotac-pis wMaintenance
ON VALUE-CHANGED OF log-cotac-pis IN FRAME fpage3 /* PIS */
DO:
  
    IF log-cotac-pis:CHECKED = YES THEN
        ENABLE fi-despes-pis fi-cd-fornec-pis WITH FRAME fpage3.
    ELSE DO:
        DISABLE fi-despes-pis fi-cd-fornec-pis WITH FRAME fpage3.
        ASSIGN fi-despes-pis:SCREEN-VALUE IN FRAME fpage3     = ""
               c-desc-desp-pis:SCREEN-VALUE IN FRAME fpage3   = ""
               fi-cd-fornec-pis:SCREEN-VALUE IN FRAME fpage3  = ""
               c-desc-fornec-pis:SCREEN-VALUE IN FRAME fpage3 = "".
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-param-imp.log-descons-iva-tit-mercad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.log-descons-iva-tit-mercad wMaintenance
ON VALUE-CHANGED OF tt-param-imp.log-descons-iva-tit-mercad IN FRAME fPage1 /* Desconsidera IVA T°tulo Mercadoria */
DO:
  IF NOT tt-param-imp.log-descons-iva-tit-mercad:CHECKED IN FRAME fPage1 THEN DO:
      ASSIGN tt-param-imp.cdn-despes-iva:SCREEN-VALUE IN FRAME fPage3 = "0"
             tt-param-imp.cdn-emit-iva:SCREEN-VALUE IN FRAME fPage3 = "0"
             tt-param-imp.cdn-despes-iva:SENSITIVE IN FRAME fPage3 = NO
             tt-param-imp.cdn-emit-iva:SENSITIVE IN FRAME fPage3 = NO.

      APPLY "LEAVE":U TO tt-param-imp.cdn-emit-iva   IN FRAME fpage3.
      APPLY "LEAVE":U TO tt-param-imp.cdn-despes-iva IN FRAME fpage3.
  END.
  ELSE
      ASSIGN tt-param-imp.cdn-despes-iva:SENSITIVE IN FRAME fPage3 = YES
             tt-param-imp.cdn-emit-iva:SENSITIVE IN FRAME fPage3 = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-param-imp.sc-transit-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.sc-transit-import wMaintenance
ON ENTRY OF tt-param-imp.sc-transit-import IN FRAME fPage1 /* Subconta Transit Importaá∆o */
DO: 
    IF tt-param-imp.sc-transit-import <> "" THEN DO:
        IF p_cod_format_ccusto = "" THEN
            ASSIGN tt-param-imp.sc-transit-import:FORMAT IN FRAME fPage1 = "x(20)":U.
        ELSE
            ASSIGN tt-param-imp.sc-transit-import:FORMAT IN FRAME fPage1 = p_cod_format_ccusto.
    END.
    ELSE
        ASSIGN tt-param-imp.sc-transit-import:FORMAT IN FRAME fPage1 = "X(20)":U.
    
    display tt-param-imp.sc-transit-import with frame fPage1.
    APPLY "ENTRY" TO SELF IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.sc-transit-import wMaintenance
ON F5 OF tt-param-imp.sc-transit-import IN FRAME fPage1 /* Subconta Transit Importaá∆o */
DO:
    run pi_zoom_ccusto_x_cta_ctbl in h_api_ccust (input i-empresa,                 /* EMPRESA EMS2 */
                                                      input "",                 /* ESTABELECIMENTO EMS2 */
                                                      input yes,                 /* TODOS ESTABELECIMENTOS ? */
                                                      input "",               /* UNIDADE DE NEGOCIO */
                                                      input "",             /* PLANO CONTAS */
                                                      input tt-param-imp.ct-transit-import,          /* CONTA */
                                                      input "",          /* CODIGO DO PLANO CCUSTO */
                                                      input today,               /* DATA DE TRANSACAO */
                                                      output v_cod_ccusto,       /* CODIGO CCUSTO */
                                                      output v_des_ccusto,       /* DESCRICAO CCUSTO */
                                                      output table tt_log_erro). /* ERROS */ 
    IF v_cod_ccusto <> "" THEN DO:
        ASSIGN tt-param-imp.sc-transit-import = v_cod_ccusto
               tt-param-imp.sc-transit-import:SCREEN-VALUE = v_cod_ccusto.
        IF p_cod_format_ccusto <> "" THEN
            ASSIGN tt-param-imp.sc-transit-import:FORMAT IN FRAME fPage1 = p_cod_format_ccusto.
        ELSE
            ASSIGN tt-param-imp.sc-transit-import:FORMAT IN FRAME fPage1 = "X(20)":U.
    END.
    
    ASSIGN desc-ccusto-transit = v_des_ccusto.
   
    disp tt-param-imp.sc-transit-import desc-ccusto-transit with frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.sc-transit-import wMaintenance
ON LEAVE OF tt-param-imp.sc-transit-import IN FRAME fPage1 /* Subconta Transit Importaá∆o */
DO: 

    IF AVAIL tt-param-imp THEN DO:
        run pi_busca_dados_ccusto in h_api_ccust (input  i-empresa,                /* EMPRESA EMS2 */
                                                  input  "",         /* CODIGO DO PLANO CCUSTO */
                                                  input  INPUT FRAME fpage1 tt-param-imp.sc-transit-import, /* CCUSTO */
                                                  input  today,              /* DATA DE TRANSACAO */
                                                  output v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                                  output table tt_log_erro). /* ERROS */ 
        
        IF tt-param-imp.sc-transit-import:SCREEN-VALUE <> "" THEN
            ASSIGN tt-param-imp.sc-transit-import = INPUT FRAME fpage1 tt-param-imp.sc-transit-import 
                   tt-param-imp.sc-transit-import:FORMAT IN FRAME fPage1 = p_cod_format_ccusto.
        ELSE 
            ASSIGN  tt-param-imp.sc-transit-import = ""
                    tt-param-imp.sc-transit-import:FORMAT IN FRAME fPage1 = "X(20)":U.
        
        ASSIGN desc-ccusto-transit = v_des_ccusto.
        
        disp tt-param-imp.sc-transit-import desc-ccusto-transit with frame fPage1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-param-imp.sc-transit-import wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-param-imp.sc-transit-import IN FRAME fPage1 /* Subconta Transit Importaá∆o */
DO:
    APPLY "F5":U TO SELF IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/* ***************************  Main Block  *************************** */
/*--- L¢gica para inicializaá∆o do programam ---*/

    tt-param-imp.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage0.
    tt-param-imp.esp-tit-transit:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.
    tt-param-imp.esp-tit-rec:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.
    tt-param-imp.hp-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.
    tt-param-imp.ct-transit-import:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.

    tt-param-imp.sc-transit-import:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.

    i-emitente-ii:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage3.
    i-desp-ii:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage3.

    c-cta-aplic-nf:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage1.
    c-ccusto-aplic-nf:LOAD-MOUSE-POINTER("IMAGE/lupa.cur":U)
    IN FRAME fPage1.
    
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    c-nat-oper:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    fi-despes-ipi:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    fi-despes-pis:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    fi-despes-cofins:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    fi-despes-icms:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    fi-cd-fornec-ipi:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    fi-cd-fornec-pis:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    fi-cd-fornec-cofins:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    fi-cd-fornec-icms:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    tt-param-imp.cod-espec-antecip:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    tt-param-imp.cod-ser-antecip:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    i-desp-siscomex:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage5.
    i-forn-siscomex:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage5.
    c-classe:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage6.
    c-usuario-email:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage7.
    tt-param-imp.cdn-emit-iva:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    tt-param-imp.cdn-despes-iva:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    tt-param-imp.cdn-despes-tax-estatis:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    tt-param-imp.cdn-emit-tax-estatis:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    IF i-pais-impto-usuario = 2 OR i-pais-impto-usuario = 21 THEN cdn-despes-saida-div-aux:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    IF i-pais-impto-usuario = 2 THEN fi-cod-fornec-pais:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage3.
    {utp/ut-liter.i "Solicita_LI_para_todos_os_itens"}
    ASSIGN tg-solicita-li-itens:LABEL IN FRAME fPage5 = RETURN-VALUE.
    {utp/ut-liter.i "Cotaá∆o_Autom†tica"}
    ASSIGN c-lbl-cotacao-automatica = RETURN-VALUE.
    {utp/ut-liter.i "Antecipaá‰es"}
    ASSIGN c-lbl-antecip = RETURN-VALUE.
    {utp/ut-liter.i "EspÇcie"}
    ASSIGN tt-param-imp.cod-espec-antecip:LABEL IN FRAME fPage3 = RETURN-VALUE.
    {utp/ut-liter.i "EspÇcie do t°tulo de Antecipaá∆o no Contas a Pagar"}
    ASSIGN tt-param-imp.cod-espec-antecip:HELP IN FRAME fPage3 = RETURN-VALUE.
    {utp/ut-liter.i "SÇrie"}
    ASSIGN tt-param-imp.cod-ser-antecip:LABEL IN FRAME fPage3 = RETURN-VALUE.
    {utp/ut-liter.i "SÇrie do t°tulo de Antecipaá∆o no Contas a Pagar"}
    ASSIGN tt-param-imp.cod-ser-antecip:HELP IN FRAME fPage3 = RETURN-VALUE.

    tt-param-imp-trib.cod-natur-operac-novo-impto:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage8.
    tt-param-imp-trib.cdn-despes-impto-CBS:LOAD-MOUSE-POINTER("image/lupa.cur":U)        IN FRAME fPage8.
    tt-param-imp-trib.cdn-fornec-CBS:LOAD-MOUSE-POINTER("image/lupa.cur":U)              IN FRAME fPage8.
    tt-param-imp-trib.cdn-despes-impto-IBSUF:LOAD-MOUSE-POINTER("image/lupa.cur":U)      IN FRAME fPage8.
    tt-param-imp-trib.cdn-despes-impto-IBSMun:LOAD-MOUSE-POINTER("image/lupa.cur":U)     IN FRAME fPage8.
    tt-param-imp-trib.cdn-fornec-IBSUF:LOAD-MOUSE-POINTER("image/lupa.cur":U)            IN FRAME fPage8.
    tt-param-imp-trib.cdn-fornec-IBSMun:LOAD-MOUSE-POINTER("image/lupa.cur":U)           IN FRAME fPage8.
    tt-param-imp-trib.cdn-despes-impto-IS:LOAD-MOUSE-POINTER("image/lupa.cur":U)         IN FRAME fPage8.
    tt-param-imp-trib.cdn-fornec-IS:LOAD-MOUSE-POINTER("image/lupa.cur":U)               IN FRAME fPage8.
    
    {maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyinterface wMaintenance 
PROCEDURE afterDestroyinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    delete procedure h-boad107.
    delete procedure h-boad104.
    delete procedure h-boad142.
    delete procedure h-boad098.
    delete procedure h-bocx095.
    DELETE PROCEDURE h-boin245.
    DELETE PROCEDURE h-boun005.

    IF i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        RUN destroy IN h-boar2084.
        ASSIGN h-boar2084 = ?.
    END.

    IF i-pais-impto-usuario = 2 /* Argentina */ OR i-pais-impto-usuario = 21 /* Equador */ THEN DO:
        RUN destroy IN h-bocx00476.
        ASSIGN h-bocx00476 = ?.
    END.

    IF VALID-HANDLE(h-bocx00511) THEN DO:
        RUN destroy IN h-bocx00511.
        ASSIGN h-bocx00511 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisableFields wMaintenance 
PROCEDURE afterDisableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign bt-calcula-pis:sensitive     in frame fpage2 = no
           bt-calcula-cofins:sensitive  in frame fpage2 = no.

    DISABLE bt-arq1 bt-arq2 WITH FRAME fpage4.

    ASSIGN c-cta-aplic-nf:SENSITIVE    IN FRAME fPage1 = NO
           c-ccusto-aplic-nf:SENSITIVE IN FRAME fPage1 = NO.

    IF i-pais-impto-usuario = 1 THEN DO:
        ASSIGN l-inc-icms-ipi-outros:SENSITIVE          IN FRAME fPage3 = NO
               tt-param-imp.hist-processo:SENSITIVE     IN FRAME fPage1 = NO              
               tt-param-imp.log-2:SENSITIVE             IN FRAME fPage3 = NO
               tt-param-imp.inc-icms-tot-nf:SENSITIVE   IN FRAME fPage3 = NO
               tt-param-imp.cod-espec-antecip:SENSITIVE IN FRAME fPage3 = NO
               tt-param-imp.cod-ser-antecip:SENSITIVE   IN FRAME fPage3 = NO
               tt-param-imp.perc-max-antecip:SENSITIVE  IN FRAME fPage3 = NO
               tt-param-imp.cod-espec-antecip:SENSITIVE IN FRAME fPage3 = NO
               tt-param-imp.cod-ser-antecip:SENSITIVE   IN FRAME fPage3 = NO
               tt-param-imp.perc-max-antecip:SENSITIVE  IN FRAME fPage3 = NO.
    END.
    ELSE DO:
       IF  i-pais-impto-usuario = 2 /* Argentina */ THEN
            ASSIGN c-desc-classe:SENSITIVE IN FRAME fPage6              = NO.

       ASSIGN tt-param-imp.hist-processo:SENSITIVE  IN FRAME fPage1 = NO
              tg-sugere-loc-padrao:HIDDEN           IN FRAME fPage1 = YES             
              log-cotac-ipi:HIDDEN                  IN FRAME fPage3 = YES
              fi-despes-ipi:HIDDEN                  IN FRAME fPage3 = YES
              fi-cd-fornec-ipi:HIDDEN               IN FRAME fPage3 = YES
              log-cotac-pis:HIDDEN                  IN FRAME fPage3 = YES
              fi-despes-pis:HIDDEN                  IN FRAME fPage3 = YES
              fi-cd-fornec-pis:HIDDEN               IN FRAME fPage3 = YES
              log-cotac-cofins:HIDDEN               IN FRAME fPage3 = YES
              fi-despes-cofins:HIDDEN               IN FRAME fPage3 = YES
              fi-cd-fornec-cofins:HIDDEN            IN FRAME fPage3 = YES               
              log-cotac-icms:HIDDEN                 IN FRAME fPage3 = YES
              fi-despes-icms:HIDDEN                 IN FRAME fPage3 = YES
              fi-cd-fornec-icms:HIDDEN              IN FRAME fPage3 = YES
              c-desc-desp-pis:HIDDEN                IN FRAME fPage3 = YES  
              c-desc-fornec-pis:HIDDEN              IN FRAME fPage3 = YES  
              c-desc-fornec-ipi:HIDDEN              IN FRAME fPage3 = YES  
              c-desc-desp-ipi:HIDDEN                IN FRAME fPage3 = YES  
              c-desc-desp-cofins:HIDDEN             IN FRAME fPage3 = YES  
              c-desc-fornec-cofins:HIDDEN           IN FRAME fPage3 = YES  
              c-desc-desp-icms:HIDDEN               IN FRAME fPage3 = YES  
              c-desc-fornec-icms:HIDDEN             IN FRAME fPage3 = YES
              lb-ipi:HIDDEN                         IN FRAME fPage3 = NO
              RECT-25:HIDDEN                        IN FRAME fPage3 = NO
              lb-pis:HIDDEN                         IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2
              lb-isd:HIDDEN                         IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2 AND i-pais-impto-usuario <> 21
              RECT-26:HIDDEN                        IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2 AND i-pais-impto-usuario <> 21
              lb-cofins:HIDDEN                      IN FRAME fPage3 = YES
              RECT-27:HIDDEN                        IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2
              lb-icms:HIDDEN                        IN FRAME fPage3 = YES
              RECT-28:HIDDEN                        IN FRAME fPage3 = YES
              c-lbl-antecip:HIDDEN                  IN FRAME fPage3 = YES
              RECT-77:HIDDEN                        IN FRAME fPage3 = YES
              tt-param-imp.cod-espec-antecip:HIDDEN IN FRAME fPage3 = YES
              tt-param-imp.cod-ser-antecip:HIDDEN   IN FRAME fPage3 = YES
              tt-param-imp.perc-max-antecip:HIDDEN  IN FRAME fPage3 = YES
              l-gera-primeira-remessa-nf-mae:HIDDEN IN FRAME fPage1 = YES
              tt-param-imp.log-descons-iva-tit-mercad:SENSITIVE  IN FRAME fPage1 = NO
              tt-param-imp.cdn-despes-iva:SENSITIVE          IN FRAME fPage3 = NO
              tt-param-imp.cdn-emit-iva  :SENSITIVE          IN FRAME fPage3 = NO
              cdn-despes-saida-div-aux:SENSITIVE             IN FRAME fPage3 = NO
              c-desc-isd:HIDDEN                              IN FRAME fPage3 = NO WHEN i-pais-impto-usuario = 2 OR i-pais-impto-usuario = 21
              fi-cod-fornec-pais:SENSITIVE                   IN FRAME fPage3 = NO WHEN i-pais-impto-usuario = 2
              c-desc-fornec-pais:HIDDEN                      IN FRAME fPage3 = NO WHEN i-pais-impto-usuario = 2
              tt-param-imp.cdn-despes-tax-estatis:SENSITIVE  IN FRAME fPage3 = NO WHEN i-pais-impto-usuario = 2
              tt-param-imp.cdn-emit-tax-estatis:SENSITIVE    IN FRAME fPage3 = NO WHEN i-pais-impto-usuario = 2
              btFaixaImpto:SENSITIVE                         IN FRAME fPage3 = NO WHEN i-pais-impto-usuario = 2
              tt-param-imp.log-trata-depos-draw:SENSITIVE    IN FRAME fPage7 = NO
              tg-vincula-drb-emb               :SENSITIVE    IN FRAME fPage7 = NO.
        
    END.
    IF l-trata-dep-externos THEN
        ASSIGN l-dep-externo:SENSITIVE IN FRAME fPage1 = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {utp/ut-liter.i E-mail_Notificaá∆o_Ato_Concess¢rio *}
    ASSIGN lb-email-ato-concessorio:SCREEN-VALUE IN FRAME fPage7 = RETURN-VALUE.

    IF i-pais-impto-usuario <> 1 THEN DO:

        IF i-pais-impto-usuario = 2 THEN DO:
            {utp/ut-liter.i "Taxa_Estat°stica" *}
            ASSIGN lb-pis:SCREEN-VALUE IN FRAME fPage3 = RETURN-VALUE.
            {utp/ut-liter.i "Tabela_DIT" *}
            ASSIGN tg-ato-conces:LABEL IN FRAME fPage7 = RETURN-VALUE.
            {utp/ut-liter.i "Tabela_Itens_do_DIT" *}
            ASSIGN tg-itens-ato-conces:LABEL IN FRAME fPage7 = RETURN-VALUE.
            {utp/ut-liter.i "E-mail_Notificaá∆o_DIT" *}
            ASSIGN lb-email-ato-concessorio:SCREEN-VALUE IN FRAME fPage7 = RETURN-VALUE
                   lb-email-ato-concessorio:WIDTH        IN FRAME fPage7 = 17.00.
        END.

        IF  i-pais-impto-usuario = 2 OR i-pais-impto-usuario = 21 THEN DO:
            
            ASSIGN cdn-despes-saida-div-aux = 0
                   fi-cod-fornec-pais       = 0.

            RUN goToKey IN h-bocx00476 (INPUT tt-param-imp.cod-estabel).
            IF  RETURN-VALUE = "OK":U THEN DO:            
                RUN getIntField IN h-bocx00476 (INPUT "cdn-despes-saida-div", OUTPUT cdn-despes-saida-div-aux).
                RUN getIntField IN h-bocx00476 (INPUT "num-livre-1", OUTPUT fi-cod-fornec-pais).
            END.   
            
            ASSIGN cdn-despes-saida-div-aux:SCREEN-VALUE IN FRAME fPage3 = string(cdn-despes-saida-div-aux).
            APPLY "LEAVE":U TO cdn-despes-saida-div-aux IN FRAME fPage3.
            
            IF  i-pais-impto-usuario = 2 THEN DO:
                ASSIGN fi-cod-fornec-pais:SCREEN-VALUE IN FRAME fPage3 = string(fi-cod-fornec-pais).
                APPLY "LEAVE":U TO fi-cod-fornec-pais IN FRAME fPage3.
            END.
        END.

        {utp/ut-liter.i "Drawback_Internacional" *}
        ASSIGN lb-drawback                      :HIDDEN IN FRAME fPage7 = NO
               rect-84                          :HIDDEN IN FRAME fPage7 = NO
               tt-param-imp.log-trata-depos-draw:HIDDEN IN FRAME fPage7 = NO              
               tg-vincula-drb-emb               :HIDDEN IN FRAME fPage7 = NO
               lb-drawback:SCREEN-VALUE = RETURN-VALUE.

        {utp/ut-liter.i "IPI" *}
        assign lb-ipi:screen-value in frame fPage3 = UPPER(RETURN-VALUE).

        {utp/ut-liter.i "DESPESAS_E_IMPOSTOS" *}
        assign c-lbl-despesas-impostos:screen-value in frame fPage3 = RETURN-VALUE.

        {utp/ut-liter.i "Despesas_Itiner†rio" *}
        assign texto-despes-itiner:screen-value in frame fPage1 = RETURN-VALUE.

        ASSIGN tg-sugere-loc-padrao:HIDDEN IN FRAME fPage1 = YES
               tt-param-imp.log-descons-iva-tit-mercad:HIDDEN  IN FRAME fPage1 = NO.

        IF l-trata-dep-externos THEN
            ASSIGN l-dep-externo:HIDDEN IN FRAME fPage1 = NO.

        ASSIGN c-lbl-antecip:HIDDEN                  IN FRAME fPage3 = YES
               RECT-77:HIDDEN                        IN FRAME fPage3 = YES
               tt-param-imp.cod-espec-antecip:HIDDEN IN FRAME fPage3 = YES
               c-desc-espec:HIDDEN                   IN FRAME fPage3 = YES
               tt-param-imp.cod-ser-antecip:HIDDEN   IN FRAME fPage3 = YES
               tt-param-imp.perc-max-antecip:HIDDEN  IN FRAME fPage3 = YES.

        ASSIGN RECT-74:HIDDEN                      IN FRAME fPage3 = YES
               log-cotac-ipi:HIDDEN                IN FRAME fPage3 = YES
               fi-despes-ipi:HIDDEN                IN FRAME fPage3 = YES
               fi-cd-fornec-ipi:HIDDEN             IN FRAME fPage3 = YES
               log-cotac-pis:HIDDEN                IN FRAME fPage3 = YES
               fi-despes-pis:HIDDEN                IN FRAME fPage3 = YES
               fi-cd-fornec-pis:HIDDEN             IN FRAME fPage3 = YES
               log-cotac-cofins:HIDDEN             IN FRAME fPage3 = YES
               fi-despes-cofins:HIDDEN             IN FRAME fPage3 = YES
               fi-cd-fornec-cofins:HIDDEN          IN FRAME fPage3 = YES               
               log-cotac-icms:HIDDEN               IN FRAME fPage3 = YES
               fi-despes-icms:HIDDEN               IN FRAME fPage3 = YES
               fi-cd-fornec-icms:HIDDEN            IN FRAME fPage3 = YES
               c-desc-desp-pis:HIDDEN              IN FRAME fPage3 = YES  
               c-desc-fornec-pis:HIDDEN            IN FRAME fPage3 = YES  
               c-desc-fornec-ipi:HIDDEN            IN FRAME fPage3 = YES  
               c-desc-desp-ipi:HIDDEN              IN FRAME fPage3 = YES  
               c-desc-desp-cofins:HIDDEN           IN FRAME fPage3 = YES  
               c-desc-fornec-cofins:HIDDEN         IN FRAME fPage3 = YES  
               c-desc-desp-icms:HIDDEN             IN FRAME fPage3 = YES  
               c-desc-fornec-icms:HIDDEN           IN FRAME fPage3 = YES
               lb-ipi:HIDDEN                       IN FRAME fPage3 = NO
               RECT-25:HIDDEN                      IN FRAME fPage3 = NO
               lb-pis:HIDDEN                       IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2
               lb-isd:HIDDEN                       IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2 AND i-pais-impto-usuario <> 21
               RECT-26:HIDDEN                      IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2 AND i-pais-impto-usuario <> 21
               lb-cofins:HIDDEN                    IN FRAME fPage3 = YES
               RECT-27:HIDDEN                      IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2
               lb-icms:HIDDEN                      IN FRAME fPage3 = YES
               RECT-28:HIDDEN                      IN FRAME fPage3 = YES
               tt-param-imp.cdn-despes-iva:HIDDEN  IN FRAME fPage3 = NO
               tt-param-imp.cdn-emit-iva  :HIDDEN  IN FRAME fPage3 = NO
               tt-param-imp.cdn-despes-tax-estatis:HIDDEN IN FRAME fPage3   = NO WHEN i-pais-impto-usuario = 2
               tt-param-imp.cdn-emit-tax-estatis:HIDDEN   IN FRAME fPage3   = NO WHEN i-pais-impto-usuario = 2
               cdn-despes-saida-div-aux:HIDDEN            IN FRAME fPage3   = NO WHEN i-pais-impto-usuario = 2 OR i-pais-impto-usuario = 21
               c-desc-isd:HIDDEN                          IN FRAME fPage3   = NO WHEN i-pais-impto-usuario = 2 OR i-pais-impto-usuario = 21
               fi-cod-fornec-pais:HIDDEN                  IN FRAME fPage3   = NO WHEN i-pais-impto-usuario = 2 
               c-desc-fornec-pais:HIDDEN                  IN FRAME fPage3   = NO WHEN i-pais-impto-usuario = 2 
               btFaixaImpto                     :HIDDEN   IN FRAME fPage3   = NO WHEN i-pais-impto-usuario = 2               
               c-desc-fornec-iva          :HIDDEN  IN FRAME fPage3 = NO 
               c-desc-desp-iva            :HIDDEN  IN FRAME fPage3 = NO
               c-desc-fornec-est          :HIDDEN  IN FRAME fPage3 = NO WHEN i-pais-impto-usuario = 2
               c-desc-desp-est            :HIDDEN  IN FRAME fPage3 = NO WHEN i-pais-impto-usuario = 2
               l-gera-primeira-remessa-nf-mae:HIDDEN IN FRAME fPage1 = YES.
    END.
    ELSE DO:
        IF l-fn-antecip THEN
            ASSIGN c-lbl-antecip:HIDDEN                     IN FRAME fPage3 = NO
                   RECT-77:HIDDEN                           IN FRAME fPage3 = NO
                   tt-param-imp.cod-espec-antecip:HIDDEN    IN FRAME fPage3 = NO
                   c-desc-espec:HIDDEN                      IN FRAME fPage3 = NO
                   tt-param-imp.cod-ser-antecip:HIDDEN      IN FRAME fPage3 = NO
                   tt-param-imp.perc-max-antecip:HIDDEN     IN FRAME fPage3 = NO.
        ELSE
            ASSIGN c-lbl-antecip:HIDDEN                     IN FRAME fPage3 = YES
                   RECT-77:HIDDEN                           IN FRAME fPage3 = YES
                   tt-param-imp.cod-espec-antecip:HIDDEN    IN FRAME fPage3 = YES
                   c-desc-espec:HIDDEN                      IN FRAME fPage3 = YES
                   tt-param-imp.cod-ser-antecip:HIDDEN      IN FRAME fPage3 = YES
                   tt-param-imp.perc-max-antecip:HIDDEN     IN FRAME fPage3 = YES.

        ASSIGN tt-param-imp.log-descons-iva-tit-mercad:HIDDEN IN FRAME fPage1 = YES.
    END.

    if  avail tt-param-imp then do:
   
        {cdp/cd4300.i4 "yes" tt-param-imp.char-1}
        {cxbo/bocx250.i51 "yes"}

        assign i-emitente-ii:SCREEN-VALUE IN FRAME fPage3 = STRING(i-emitente-ii-i50)
               i-desp-ii:SCREEN-VALUE IN FRAME fPage3 = STRING(i-desp-ii-i50)
               c-des-senha-docto      = fill("*", length(tt-param-imp.des-senha-docto))
               c-confirma-senha-docto = fill("*", length(tt-param-imp.des-senha-docto))
               c-des-senha-pch        = fill("*", length(tt-param-imp.des-senha-pch-order))
               c-confirma-senha-pch   = fill("*", length(tt-param-imp.des-senha-pch-order))
               tb-desp-itiner-autom:CHECKED IN FRAME fPage1   = IF SUBSTRING(tt-param-imp.char-1,168,1) = "S":U THEN YES ELSE NO.

        DISP c-des-senha-docto
             c-confirma-senha-docto
             c-des-senha-pch      
             c-confirma-senha-pch
            WITH FRAME fPage4.


        IF l-trata-dep-externos THEN
            ASSIGN l-dep-externo:CHECKED IN FRAME fPage1 = IF SUBSTRING(tt-param-imp.char-1,226,1) = "S":U THEN YES ELSE NO.
    
        if  tt-param-imp.int-1 = ?  
        or  tt-param-imp.int-1 = 0 THEN
            ASSIGN tt-param-imp.int-1 = 1.

        IF  tt-param-imp.int-1 = ? THEN
            ASSIGN tt-param-imp.log-1 = no.

        disp tt-param-imp.int-1 
             tt-param-imp.log-1 with frame fPage1.

        ASSIGN c-cpf-repres:FORMAT IN FRAME fpage5 = IF AVAIL param-global 
                                                     THEN param-global.formato-id-pessoal
                                                     ELSE "x(19)":U.

        IF i-pais-impto-usuario = 1 THEN 
            ASSIGN tg-sugere-loc-padrao:CHECKED IN FRAME fpage1 = IF SUBSTRING(tt-param-imp.char-1, 166,1) = "S":U THEN TRUE ELSE FALSE.

        ASSIGN l-gera-primeira-remessa-nf-mae:CHECKED IN FRAME fpage1 = IF SUBSTRING(tt-param-imp.char-1, 169,1) = "S":U THEN TRUE ELSE FALSE.
    
        APPLY "LEAVE":U TO tt-param-imp.cod-estabel          IN FRAME fPage0.
        APPLY "LEAVE":U TO tt-param-imp.esp-tit-rec          IN FRAME fPage1.
        APPLY "LEAVE":U TO i-emitente-ii                     IN FRAME fPage3.
        APPLY "LEAVE":U TO i-desp-ii                         IN FRAME fPage3.
        
        APPLY "LEAVE":U TO tt-param-imp.esp-tit-transit      in frame fPage1.
        apply "LEAVE":U TO tt-param-imp.hp-codigo            in frame fPage1.
        
        IF NOT l-EMS2-IMP-MEXICO THEN
            ASSIGN c-cpf-repres:HIDDEN IN FRAME fpage5 = NO.

        assign c-cpf-repres = tt-param-imp.cod-cpf-repres.
        display c-cpf-repres with frame fpage5.

        
        assign c-cta-aplic-nf = substring(tt-param-imp.char-2,35,20).
        display c-ccusto-aplic-nf
                tt-param-imp.hist-processo    
            with frame fPage1.

        IF i-pais-impto-usuario = 1 THEN DO:
            DISPLAY tt-param-imp.log-2
                    tt-param-imp.inc-icms-tot-nf 
                    WITH FRAME fPage3.
        END.

        apply "LEAVE":U to c-cta-aplic-nf in frame fPage1.
        

        run adbo/boad355.p persistent set h-boad355.
        run pi-verificar-produto in h-boad355 (output v-pagar, output v-receber).
        delete procedure h-boad355.
    
        run inbo/boin682.p persistent set h-boin682.
        run openQueryStatic in h-boin682 ("Main").
        run getFirst in h-boin682.
        run getLogField in h-boin682 (input "modulo-mec", output l-modulo-mec).
        delete procedure h-boin682.
        assign h-boin682 = ?.
    
        /*
            Busca os campos PIS/COFINS da include {ininc/i04in176.i 03}  Tributado/Isento/Outros
        */
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            ASSIGN cAuxTraducao001 = {ininc/i04in176.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
            ASSIGN c-trib-cofins:LIST-ITEM-PAIRS in frame fpage2 = cAuxTraducao001 .
        &else
            ASSIGN c-trib-cofins:LIST-ITEMS in frame fpage2 =  {ininc/i04in176.i 03} .
        &endif
        
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            ASSIGN cAuxTraducao002 = {ininc/i04in176.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
            ASSIGN c-trib-pis:LIST-ITEM-PAIRS in frame fpage2    = cAuxTraducao002. 
        &else
            ASSIGN c-trib-pis:LIST-ITEMS in frame fpage2    =  {ininc/i04in176.i 03}.
        &endif
    
        IF  tt-param-imp.idi-tributac-cofins = 0 then  DO:
                ASSIGN c-trib-cofins:SCREEN-VALUE in frame fpage2 =  STRING({ininc/i04in176.i 04 1}).
        END.
        ELSE  DO:
                ASSIGN c-trib-cofins:SCREEN-VALUE in frame fpage2 = STRING({ininc/i04in176.i 04 tt-param-imp.idi-tributac-cofins}).
        END.

        IF  tt-param-imp.idi-tributac-pis = 0 THEN DO:
            ASSIGN c-trib-pis:SCREEN-VALUE in frame fpage2 =  STRING({ininc/i04in176.i 04 1}).
        END.
        ELSE  DO:
                ASSIGN c-trib-pis:SCREEN-VALUE    in frame fpage2   = STRING({ininc/i04in176.i 04 tt-param-imp.idi-tributac-pis}).
        END.

        ASSIGN d-dt-ini-pis:SCREEN-VALUE       IN FRAME fpage2 = string(tt-param-imp.dat-pis-recup)
               d-dt-ini-cofins:SCREEN-VALUE    IN FRAME fpage2 = string(tt-param-imp.dat-cofins-recup)
               c-formula-pis:SCREEN-VALUE      IN FRAME fpage2 = tt-param-imp.dsl-formul-base-calc-pis
               c-formula-cofins:SCREEN-VALUE   IN FRAME fpage2 = tt-param-imp.dsl-formul-base-calc-cofins
               l-inc-pis-base-icms                             = tt-param-imp.log-incid-pis-base-icms
               l-inc-cofins-base-icms                          = tt-param-imp.log-incid-cofins-base-icms
               l-inc-icms-ipi-outros                           = tt-param-imp.log-incid-icms-ipi-outros-of
               tg-base-reduzida-pis:CHECKED    IN FRAME fPage2 = IF trim(substring(tt-param-imp.char-1,245,1)) = "1":U THEN YES ELSE NO
               tg-base-reduzida-cofins:CHECKED IN FRAME fPage2 = IF trim(substring(tt-param-imp.char-1,246,1)) = "1":U THEN YES ELSE NO.

        disp l-inc-cofins-base-icms l-inc-pis-base-icms with frame fpage2.
        IF  NOT l-ems2-imp-mexico 
        AND i-pais-impto-usuario = 1 THEN
            display l-inc-icms-ipi-outros with frame fPage3.

        ASSIGN c-cta-aplic-nf:SCREEN-VALUE IN FRAME fPage1 =    tt-param-imp.cod-cta-aplic-nf-simples-remes
               c-ccusto-aplic-nf:SCREEN-VALUE IN FRAME fPage1 = tt-param-imp.cod-subconta-nf-simples-remes.
        
        IF i-pais-impto-usuario = 1 THEN
            APPLY "LEAVE":U TO tt-param-imp.cod-espec-antecip    in frame fPage3.
        

        /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
        ASSIGN log-geracao:SCREEN-VALUE IN FRAME fpage3         = string(tt-param-imp.log-gerac-cotac-despes-impto)
               c-nat-oper:SCREEN-VALUE IN FRAME fpage3          = tt-param-imp.cod-natur-operac-padr
               log-cotac-impto:SCREEN-VALUE IN FRAME fpage3     = string(tt-param-imp.log-cotac-autom-impto-import)
               log-cotac-ipi:SCREEN-VALUE IN FRAME fpage3       = string(tt-param-imp.log-cotac-autom-ipi)
               fi-despes-ipi:SCREEN-VALUE IN FRAME fpage3       = string(tt-param-imp.cdn-despes-impto-ipi)
               fi-cd-fornec-ipi:SCREEN-VALUE IN FRAME fpage3    = string(tt-param-imp.cdn-fornec-ipi)
               log-cotac-pis:SCREEN-VALUE IN FRAME fpage3       = string(tt-param-imp.log-cotac-autom-pis)
               fi-despes-pis:SCREEN-VALUE IN FRAME fpage3       = string(tt-param-imp.cdn-despes-impto-pis)
               fi-cd-fornec-pis:SCREEN-VALUE IN FRAME fpage3    = string(tt-param-imp.cdn-fornec-pis)
               log-cotac-cofins:SCREEN-VALUE IN FRAME fpage3    = string(tt-param-imp.log-cotac-autom-cofins)
               fi-despes-cofins:SCREEN-VALUE IN FRAME fpage3    = string(tt-param-imp.cdn-despes-impto-cofins)
               fi-cd-fornec-cofins:SCREEN-VALUE IN FRAME fpage3 = string(tt-param-imp.cdn-fornec-cofins)
               log-cotac-icms:SCREEN-VALUE IN FRAME fpage3      = string(tt-param-imp.log-cotac-autom-icms)
               fi-despes-icms:SCREEN-VALUE IN FRAME fpage3      = string(tt-param-imp.cdn-despes-impto-icms)
               fi-cd-fornec-icms:SCREEN-VALUE IN FRAME fpage3   = string(tt-param-imp.cdn-fornec-icms).

        ASSIGN tg-solicita-li-itens:CHECKED IN FRAME fPage5 = IF SUBSTRING(tt-param-imp.char-1,167,1) = "S":U THEN YES ELSE NO.

        &if '{&bf_mat_versao_ems}' < '2.07' &then
            ASSIGN i-desp-siscomex:SCREEN-VALUE IN FRAME fpage5 = SUBSTR(tt-param-imp.char-1, 91,5)
                   i-forn-siscomex:SCREEN-VALUE IN FRAME fpage5 = SUBSTR(tt-param-imp.char-1, 96,9)
                   l-util-rat-sis:CHECKED       IN FRAME fpage5 = IF SUBSTR(tt-param-imp.char-1,105,1) = '1' THEN YES ELSE NO.
        &else
            ASSIGN l-util-rat-sis:CHECKED       IN FRAME fpage5 = tt-param-imp.log-tax-siscomex
                   i-forn-siscomex:SCREEN-VALUE IN FRAME fpage5 = STRING(tt-param-imp.cdn-emit-siscomex)
                   i-desp-siscomex:SCREEN-VALUE IN FRAME fpage5 = STRING(tt-param-imp.cdn-despes-siscomex).
        &endif
        
        &if '{&bf_mat_versao_ems}' >= '2.09' &then
            ASSIGN i-mo-codigo:SCREEN-VALUE IN FRAME fpage5 = STRING(tt-param-imp.cdn-moed-dolar)
                   c-nome:SCREEN-VALUE IN FRAME fpage5 = tt-param-imp.des-respons-legal.        
        &else
            ASSIGN i-mo-codigo:SCREEN-VALUE IN FRAME fpage5 = STRING(tt-param-imp.int-2)
                   c-nome:SCREEN-VALUE IN FRAME fpage5 = SUBSTRING(tt-param-imp.char-1,106,60).        
        &endif
        
        IF i-pais-impto-usuario <> 1 THEN DO: 
            DISP tt-param-imp.log-descons-iva-tit-mercad
                WITH FRAME fPage1.

            DISP tt-param-imp.cdn-emit-iva
                 tt-param-imp.cdn-despes-iva
                WITH FRAME fPage3.

            IF i-pais-impto-usuario = 2 THEN DO:
                DISP tt-param-imp.cdn-despes-tax-estatis
                     tt-param-imp.cdn-emit-tax-estatis
                    WITH FRAME fPage3.

                APPLY "LEAVE":U TO tt-param-imp.cdn-despes-tax-estatis   IN FRAME fpage3.
                APPLY "LEAVE":U TO tt-param-imp.cdn-emit-tax-estatis     IN FRAME fpage3.           
            END.

            ASSIGN tt-param-imp.log-trata-depos-draw:CHECKED IN FRAME fPage7 = tt-param-imp.log-trata-depos-draw
                   tg-vincula-drb-emb               :CHECKED IN FRAME fPage7 = IF trim(SUBSTRING(tt-param-imp.char-1,249,1)) = "S":U THEN YES ELSE NO.

            APPLY "LEAVE":U TO tt-param-imp.cdn-emit-iva   IN FRAME fpage3.
            APPLY "LEAVE":U TO tt-param-imp.cdn-despes-iva IN FRAME fpage3.           

        END.

        /* Drawback */
        ASSIGN tg-ato-conces:CHECKED                     IN FRAME fPage7 = IF trim(SUBSTRING(tt-param-imp.char-1,227,1)) = "1":U THEN YES ELSE NO
               tg-itens-ato-conces:CHECKED               IN FRAME fPage7 = IF trim(SUBSTRING(tt-param-imp.char-1,228,1)) = "1":U THEN YES ELSE NO
               tg-doc-relacionados:CHECKED               IN FRAME fPage7 = IF trim(SUBSTRING(tt-param-imp.char-1,229,1)) = "1":U THEN YES ELSE NO
               i-nr-dias-venc:SCREEN-VALUE               IN FRAME fPage7 = trim(SUBSTRING(tt-param-imp.char-1,230,3))
               c-usuario-email:SCREEN-VALUE              IN FRAME fPage7 = trim(SUBSTRING(tt-param-imp.char-1,233,12)).

        /* Reforma Tribut†ria */
        IF i-pais-impto-usuario = 1 THEN DO:
            APPLY "LEAVE":U TO tt-param-imp-trib.cod-natur-operac-novo-impto IN FRAME fPage8.
            APPLY "LEAVE":U TO tt-param-imp-trib.cdn-despes-impto-CBS        IN FRAME fPage8.
            APPLY "LEAVE":U TO tt-param-imp-trib.cdn-fornec-CBS              IN FRAME fPage8.
            APPLY "LEAVE":U TO tt-param-imp-trib.cdn-despes-impto-IBSUF      IN FRAME fPage8.
            APPLY "LEAVE":U TO tt-param-imp-trib.cdn-despes-impto-IBSMun     IN FRAME fPage8.
            APPLY "LEAVE":U TO tt-param-imp-trib.cdn-fornec-IBSUF            IN FRAME fPage8.
            APPLY "LEAVE":U TO tt-param-imp-trib.cdn-fornec-IBSMun           IN FRAME fPage8.
            APPLY "LEAVE":U TO tt-param-imp-trib.cdn-despes-impto-IS         IN FRAME fPage8.
            APPLY "LEAVE":U TO tt-param-imp-trib.cdn-fornec-IS               IN FRAME fPage8.
        END.
        
        APPLY "LEAVE":U TO c-nat-oper          IN FRAME fpage3.
        APPLY "LEAVE":U TO fi-despes-ipi       IN FRAME fpage3.
        APPLY "LEAVE":U TO fi-despes-pis       IN FRAME fpage3.
        APPLY "LEAVE":U TO fi-despes-cofins    IN FRAME fpage3.
        APPLY "LEAVE":U TO fi-despes-icms      IN FRAME fpage3.
        APPLY "LEAVE":U TO fi-cd-fornec-ipi    IN FRAME fpage3.
        APPLY "LEAVE":U TO fi-cd-fornec-pis    IN FRAME fpage3.
        APPLY "LEAVE":U TO fi-cd-fornec-cofins IN FRAME fpage3.
        APPLY "LEAVE":U TO fi-cd-fornec-icms   IN FRAME fpage3.
    END.
    else do:

        assign fill-in-1:SCREEN-VALUE          IN FRAME fPage0 = ""
               fill-in-2:SCREEN-VALUE          IN FRAME fPage1 = ""
               fill-in-3:SCREEN-VALUE          IN FRAME fPage1 = ""
               fill-in-4:SCREEN-VALUE          IN FRAME fPage1 = ""
               desc-conta-transit:SCREEN-VALUE IN FRAME fPage1 = ""
               i-emitente-ii:SCREEN-VALUE      IN FRAME fPage3 = "0"
               c-emitente-ii:SCREEN-VALUE      IN FRAME fPage3 = ""
               i-desp-ii:SCREEN-VALUE          IN FRAME fPage3 = "0"
               c-desp-ii:SCREEN-VALUE          IN FRAME fPage3 = ""
               c-cpf-repres:SCREEN-VALUE       IN FRAME fpage5 = ""
               l-util-rat-sis:CHECKED          IN FRAME fpage5 = NO
               i-forn-siscomex:SCREEN-VALUE    IN FRAME fpage5 = "0"
               i-desp-siscomex:SCREEN-VALUE    IN FRAME fpage5 = "0".
         
         ASSIGN c-cta-aplic-nf:SCREEN-VALUE     IN FRAME fPage1 = ""
                desc-cta-aplic-nf:SCREEN-VALUE  IN FRAME fPage1 = ""
                c-ccusto-aplic-nf:SCREEN-VALUE     IN FRAME fPage1 = ""
                desc-ccusto-aplic-nf:SCREEN-VALUE  IN FRAME fPage1 = "".

         IF  i-pais-impto-usuario = 2 THEN
            ASSIGN c-desc-classe:SCREEN-VALUE          IN FRAME fPage6 = "".

        /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
        assign log-geracao:checked              in frame fpage3 = no
               c-nat-oper:screen-value          in frame fpage3 = ""
               log-cotac-impto:checked          in frame fpage3 = no
               log-cotac-ipi:checked            in frame fpage3 = no
               fi-despes-ipi:screen-value       in frame fpage3 = "0"
               fi-cd-fornec-ipi:screen-value    in frame fpage3 = "0"
               log-cotac-pis:checked            in frame fpage3 = no
               fi-despes-pis:screen-value       in frame fpage3 = "0"
               fi-cd-fornec-pis:screen-value    in frame fpage3 = "0"
               log-cotac-cofins:checked         in frame fpage3 = no
               fi-despes-cofins:screen-value    in frame fpage3 = "0"
               fi-cd-fornec-cofins:screen-value in frame fpage3 = "0"
               log-cotac-icms:checked           in frame fpage3 = no
               fi-despes-icms:screen-value      in frame fpage3 = "0"
               fi-cd-fornec-icms:screen-value   in frame fpage3 = "0".
        /* Drawback */
        ASSIGN tg-ato-conces:CHECKED                     IN FRAME fPage7 = NO
               tg-itens-ato-conces:CHECKED               IN FRAME fPage7 = NO
               tg-doc-relacionados:CHECKED               IN FRAME fPage7 = NO
               i-nr-dias-venc:SCREEN-VALUE               IN FRAME fPage7 = "0":U
               c-usuario-email:SCREEN-VALUE              IN FRAME fPage7 = "":U
               tt-param-imp.log-trata-depos-draw:CHECKED IN FRAME fPage7 = NO
               tg-vincula-drb-emb:CHECKED                IN FRAME fPage7 = NO.

        apply "LEAVE":U to c-nat-oper          in frame fpage3.
        apply "LEAVE":U to fi-despes-ipi       in frame fpage3.
        apply "LEAVE":U to fi-despes-pis       in frame fpage3.
        apply "LEAVE":U to fi-despes-cofins    in frame fpage3.
        apply "LEAVE":U to fi-despes-icms      in frame fpage3.
        apply "LEAVE":U to fi-cd-fornec-ipi    in frame fpage3.
        apply "LEAVE":U to fi-cd-fornec-pis    in frame fpage3.
        apply "LEAVE":U to fi-cd-fornec-cofins in frame fpage3.
        apply "LEAVE":U to fi-cd-fornec-icms   in frame fpage3.
    end.

    APPLY 'leave' TO i-forn-siscomex IN FRAME fpage5.
    APPLY 'leave' TO i-desp-siscomex IN FRAME fpage5.
    APPLY "LEAVE":U TO i-mo-codigo   IN FRAME fPage5.
    APPLY "LEAVE":U TO tt-param-imp.ct-transit-import    IN FRAME fPage1.
    APPLY "LEAVE":U TO tt-param-imp.sc-transit-import    IN FRAME fPage1.
    
    APPLY "LEAVE":U TO c-cta-aplic-nf IN FRAME fPage1.
    APPLY "LEAVE":U TO c-ccusto-aplic-nf IN FRAME fPage1.
    

    IF AVAIL tt-param-imp THEN DO:

        IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
            IF  VALID-HANDLE(h-boar2084) THEN DO:
                RUN Buscaargext IN h-boar2084 (INPUT  i-empresa,
                                               INPUT  tt-param-imp.cod-estabel,
                                               OUTPUT c-classe,
                                               OUTPUT l-ger-pro, 
                                               OUTPUT l-ger-estq-emb).
                DISPLAY c-classe        WITH FRAME fPage6.

                APPLY "LEAVE":U TO c-classe IN FRAME fPage6.
    
                IF l-ger-pro THEN DO:
                    ASSIGN tg-ger-pro:CHECKED IN FRAME fPage6 = YES.
                END.
                ELSE DO:
                    ASSIGN tg-ger-pro:CHECKED IN FRAME fPage6 = NO.
                END.
    
                IF l-ger-estq-emb THEN DO:
                    ASSIGN tg-ger-estq-emb:CHECKED IN FRAME fPage6 = YES.
                END.
                ELSE DO:
                    ASSIGN tg-ger-estq-emb:CHECKED IN FRAME fPage6 = NO.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenance 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-pagina AS INTEGER     NO-UNDO.
    
    IF i-pais-impto-usuario <> 1 THEN DO:
        ASSIGN l-inc-icms-ipi-outros:HIDDEN           IN FRAME fPage3 = YES
               l-inc-icms-ipi-outros:SENSITIVE        IN FRAME fPage3 = NO
               tt-param-imp.hist-processo:HIDDEN      IN FRAME fPage1 = NO
               tt-param-imp.hist-processo:SENSITIVE   IN FRAME fPage1 = YES
               tt-param-imp.log-2:HIDDEN              IN FRAME fPage3 = YES
               tt-param-imp.log-2:SENSITIVE           IN FRAME fPage3 = NO
               tt-param-imp.inc-icms-tot-nf:HIDDEN    IN FRAME fPage3 = YES
               tt-param-imp.inc-icms-tot-nf:SENSITIVE IN FRAME fPage3 = NO              
               tg-sugere-loc-padrao:HIDDEN            IN FRAME fPage1 = YES               
               log-cotac-ipi:HIDDEN                   IN FRAME fPage3 = YES
               fi-despes-ipi:HIDDEN                   IN FRAME fPage3 = YES
               fi-cd-fornec-ipi:HIDDEN                IN FRAME fPage3 = YES
               log-cotac-pis:HIDDEN                   IN FRAME fPage3 = YES
               fi-despes-pis:HIDDEN                   IN FRAME fPage3 = YES
               fi-cd-fornec-pis:HIDDEN                IN FRAME fPage3 = YES
               log-cotac-cofins:HIDDEN                IN FRAME fPage3 = YES
               fi-despes-cofins:HIDDEN                IN FRAME fPage3 = YES
               fi-cd-fornec-cofins:HIDDEN             IN FRAME fPage3 = YES               
               log-cotac-icms:HIDDEN                  IN FRAME fPage3 = YES
               fi-despes-icms:HIDDEN                  IN FRAME fPage3 = YES
               fi-cd-fornec-icms:HIDDEN               IN FRAME fPage3 = YES
               c-desc-desp-pis:HIDDEN                 IN FRAME fPage3 = YES  
               c-desc-fornec-pis:HIDDEN               IN FRAME fPage3 = YES  
               c-desc-fornec-ipi:HIDDEN               IN FRAME fPage3 = YES  
               c-desc-desp-ipi:HIDDEN                 IN FRAME fPage3 = YES  
               c-desc-desp-cofins:HIDDEN              IN FRAME fPage3 = YES  
               c-desc-fornec-cofins:HIDDEN            IN FRAME fPage3 = YES  
               c-desc-desp-icms:HIDDEN                IN FRAME fPage3 = YES  
               c-desc-fornec-icms:HIDDEN              IN FRAME fPage3 = YES
               lb-ipi:HIDDEN                          IN FRAME fPage3 = NO
               RECT-25:HIDDEN                         IN FRAME fPage3 = NO
               lb-pis:HIDDEN                          IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2
               lb-isd:HIDDEN                          IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2 AND i-pais-impto-usuario <> 21
               cdn-despes-saida-div-aux:SENSITIVE     IN FRAME fPage3 = YES WHEN i-pais-impto-usuario  = 2  OR i-pais-impto-usuario  = 21
               c-desc-isd:HIDDEN                      IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2 AND i-pais-impto-usuario <> 21
               RECT-26:HIDDEN                         IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2 AND i-pais-impto-usuario <> 21
               lb-cofins:HIDDEN                       IN FRAME fPage3 = YES
               RECT-27:HIDDEN                         IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2
               lb-icms:HIDDEN                         IN FRAME fPage3 = YES
               RECT-28:HIDDEN                         IN FRAME fPage3 = YES
               c-lbl-antecip:HIDDEN                   IN FRAME fPage3 = YES
               RECT-77:HIDDEN                         IN FRAME fPage3 = YES
               tt-param-imp.cod-espec-antecip:HIDDEN    IN FRAME fPage3 = YES
               tt-param-imp.cod-espec-antecip:SENSITIVE IN FRAME fPage3 = NO
               c-desc-espec:HIDDEN                      IN FRAME fPage3 = YES
               tt-param-imp.cod-ser-antecip:HIDDEN      IN FRAME fPage3 = YES
               tt-param-imp.cod-ser-antecip:SENSITIVE   IN FRAME fPage3 = NO
               tt-param-imp.perc-max-antecip:HIDDEN     IN FRAME fPage3 = YES
               tt-param-imp.perc-max-antecip:SENSITIVE  IN FRAME fPage3 = NO
               l-gera-primeira-remessa-nf-mae:HIDDEN    IN FRAME fPage1 = YES
               tt-param-imp.log-descons-iva-tit-mercad:SENSITIVE  IN FRAME fPage1 = YES
               tt-param-imp.cdn-despes-iva:SENSITIVE  IN FRAME fPage3 = YES
               tt-param-imp.cdn-emit-iva  :SENSITIVE  IN FRAME fPage3 = YES
               tt-param-imp.cdn-despes-tax-estatis:SENSITIVE  IN FRAME fPage3 = YES WHEN i-pais-impto-usuario = 2
               tt-param-imp.cdn-emit-tax-estatis  :SENSITIVE  IN FRAME fPage3 = YES WHEN i-pais-impto-usuario = 2
               fi-cod-fornec-pais                 :SENSITIVE  IN FRAME fPage3 = YES WHEN i-pais-impto-usuario = 2
               btFaixaImpto                       :SENSITIVE  IN FRAME fPage3 = YES WHEN i-pais-impto-usuario = 2 AND cAction = "UPDATE":U
               tt-param-imp.log-trata-depos-draw  :SENSITIVE  IN FRAME fPage7 = YES
               tg-vincula-drb-emb                 :SENSITIVE  IN FRAME fPage7 = YES. 

        APPLY "VALUE-CHANGED" TO tt-param-imp.log-descons-iva-tit-mercad IN FRAME fpage1.
    END.
    ELSE DO:
        ASSIGN l-inc-icms-ipi-outros:HIDDEN           IN FRAME fPage3 = NO
               l-inc-icms-ipi-outros:SENSITIVE        IN FRAME fPage3 = YES
               tt-param-imp.hist-processo:HIDDEN      IN FRAME fPage1 = NO
               tt-param-imp.hist-processo:SENSITIVE   IN FRAME fPage1 = YES
               tt-param-imp.log-2:HIDDEN              IN FRAME fPage3 = NO
               tt-param-imp.log-2:SENSITIVE           IN FRAME fPage3 = YES
               tt-param-imp.inc-icms-tot-nf:HIDDEN    IN FRAME fPage3 = NO
               tt-param-imp.inc-icms-tot-nf:SENSITIVE IN FRAME fPage3 = YES
               c-cta-aplic-nf:HIDDEN                  IN FRAME fPage1 = NO
               c-cta-aplic-nf:SENSITIVE               IN FRAME fPage1 = YES
               desc-cta-aplic-nf:HIDDEN               IN FRAME fPage1 = NO
               desc-cta-aplic-nf:SENSITIVE            IN FRAME fPage1 = NO
               c-ccusto-aplic-nf:HIDDEN               IN FRAME fPage1 = NO
               c-ccusto-aplic-nf:SENSITIVE            IN FRAME fPage1 = YES
               desc-ccusto-aplic-nf:HIDDEN            IN FRAME fPage1 = NO
               desc-ccusto-aplic-nf:SENSITIVE         IN FRAME fPage1 = NO.

            IF l-fn-antecip THEN 
               ASSIGN c-lbl-antecip:HIDDEN                     IN FRAME fPage3 = NO
                      RECT-77:HIDDEN                           IN FRAME fPage3 = NO
                      tt-param-imp.cod-espec-antecip:HIDDEN    IN FRAME fPage3 = NO
                      tt-param-imp.cod-espec-antecip:SENSITIVE IN FRAME fPage3 = YES
                      c-desc-espec:HIDDEN                      IN FRAME fPage3 = NO
                      tt-param-imp.cod-ser-antecip:HIDDEN      IN FRAME fPage3 = NO
                      tt-param-imp.cod-ser-antecip:SENSITIVE   IN FRAME fPage3 = YES
                      tt-param-imp.perc-max-antecip:HIDDEN     IN FRAME fPage3 = NO
                      tt-param-imp.perc-max-antecip:SENSITIVE  IN FRAME fPage3 = YES.
            ELSE 
                ASSIGN c-lbl-antecip:HIDDEN                    IN FRAME fPage3 = YES
                      RECT-77:HIDDEN                           IN FRAME fPage3 = YES
                      tt-param-imp.cod-espec-antecip:HIDDEN    IN FRAME fPage3 = YES
                      tt-param-imp.cod-espec-antecip:SENSITIVE IN FRAME fPage3 = NO
                      c-desc-espec:HIDDEN                      IN FRAME fPage3 = YES
                      tt-param-imp.cod-ser-antecip:HIDDEN      IN FRAME fPage3 = YES
                      tt-param-imp.cod-ser-antecip:SENSITIVE   IN FRAME fPage3 = NO
                      tt-param-imp.perc-max-antecip:HIDDEN     IN FRAME fPage3 = YES
                      tt-param-imp.perc-max-antecip:SENSITIVE  IN FRAME fPage3 = NO.
        
        IF cAction = "ADD":U OR cAction = "UPDATE":U OR cAction = "COPY":U THEN DO:
            APPLY 'VALUE-CHANGED':U TO tt-param-imp-trib.log-cotac-autom-CBS    IN FRAME fpage8.
            APPLY 'VALUE-CHANGED':U TO tt-param-imp-trib.log-cotac-autom-IBSUF  IN FRAME fpage8.
            APPLY 'VALUE-CHANGED':U TO tt-param-imp-trib.log-cotac-autom-IBSMun IN FRAME fpage8.
            APPLY 'VALUE-CHANGED':U TO tt-param-imp-trib.log-cotac-autom-IS     IN FRAME fpage8.
        END.
    END.

    IF cAction = "UPDATE":U THEN DO:
        DISABLE tt-param-imp.cod-estabel WITH FRAME fPage0.
        ASSIGN  c-des-senha-docto      = tt-param-imp.des-senha-docto
                c-confirma-senha-docto = tt-param-imp.des-senha-docto
                c-des-senha-pch        = tt-param-imp.des-senha-pch-order  
                c-confirma-senha-pch   = tt-param-imp.des-senha-pch-order.

        DISP c-des-senha-docto     
             c-confirma-senha-docto
             c-des-senha-pch
             c-confirma-senha-pch WITH FRAME fPage4.
    END.

    IF  cAction = "ADD":U THEN
        ASSIGN d-dt-ini-pis:screen-value in frame fpage2    = string(TODAY)
               d-dt-ini-cofins:SCREEN-VALUE IN FRAME fpage2 = string(TODAY).

    IF  cAction = "COPY":U THEN
        ASSIGN c-des-senha-docto:SCREEN-VALUE      IN FRAME fPage4 = "":U
               c-confirma-senha-docto:SCREEN-VALUE IN FRAME fPage4 = "":U
               c-des-senha-pch:SCREEN-VALUE        IN FRAME fPage4 = "":U
               c-confirma-senha-pch:SCREEN-VALUE   IN FRAME fPage4 = "":U.

    IF NOT l-EMS2-IMP-MEXICO THEN
        ASSIGN c-cpf-repres:HIDDEN IN FRAME fpage5 = NO.

    ASSIGN bt-calcula-pis:SENSITIVE IN FRAME fpage2 = YES
           bt-calcula-cofins:SENSITIVE IN FRAME fpage2 = YES.

    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    IF cAction = "ADD":U OR cAction = "UPDATE":U OR cAction = "COPY":U THEN DO:
        APPLY 'value-changed':U TO log-cotac-impto  IN FRAME fpage3.
        APPLY 'value-changed':U TO log-cotac-ipi    IN FRAME fpage3.
        APPLY 'value-changed':U TO log-cotac-pis    IN FRAME fpage3.
        APPLY 'value-changed':U TO log-cotac-cofins IN FRAME fpage3.
        APPLY 'value-changed':U TO log-cotac-icms   IN FRAME fpage3.
        APPLY 'value-changed':U TO l-util-rat-sis   IN FRAME fpage5.
    END.

    ENABLE bt-arq1 bt-arq2 WITH FRAME fpage4.
    
    APPLY "LEAVE":U TO tt-param-imp.ct-transit-import    IN FRAME fPage1.
    APPLY "LEAVE":U TO tt-param-imp.sc-transit-import    IN FRAME fPage1.
    
     ASSIGN c-cta-aplic-nf:SENSITIVE    IN FRAME fPage1 = YES            
            c-ccusto-aplic-nf:SENSITIVE IN FRAME fPage1 = YES.

    APPLY "LEAVE":U TO c-cta-aplic-nf IN FRAME fPage1.
    APPLY "LEAVE":U TO c-ccusto-aplic-nf IN FRAME fPage1.    

    IF l-trata-dep-externos THEN
        ASSIGN l-dep-externo:SENSITIVE IN FRAME fPage1 = YES.

    IF cAction = "ADD":U THEN
        APPLY "ENTRY":U TO tt-param-imp.cod-estabel IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
find first param-global no-lock no-error. 
assign tt-param-imp.ct-transit-import:label in frame fPage1  = "Conta Material em TrÉnsito".
assign tt-param-imp.sc-transit-import:label in frame fPage1  = "CCusto Material em TrÉnsito".

{utp/ut-liter.i Informa_: * r}
assign texto-informa:screen-value in frame fPage1 = return-value.
{utp/ut-liter.i Relaciona_: * r}
assign texto-relaciona:screen-value in frame fPage1 = return-value.
{utp/ut-liter.i Despesas_Itiner†rio_: * r}
assign texto-despes-itiner:screen-value in frame fPage1 = return-value.
{utp/ut-liter.i Faixas_Impostos *}
ASSIGN c-lbl-impto-faixa = TRIM(RETURN-VALUE).

IF NOT l-EMS2-IMP-MEXICO THEN
   ASSIGN c-cpf-repres:HIDDEN IN FRAME fpage5 = NO.

if avail tt-param-imp then do:
   assign c-cpf-repres:format in frame fpage5 = if avail param-global 
                                                then param-global.formato-id-pessoal
                                                else "x(19)":U.
   display c-cpf-repres with frame fpage5.
end.

{utp/ut-liter.i Informe_o_CPF_Representante * R}
ASSIGN c-cpf-repres:HELP IN FRAME fpage5 = TRIM(RETURN-VALUE).

/** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
IF i-pais-impto-usuario = 1 THEN DO:

    IF l-fn-antecip THEN DO:
        {utp/ut-liter.i "Impt/Antecip"}
    END.
    ELSE DO:
        {utp/ut-liter.i "Impostos"}
    END.
    RUN insertFolder IN hFolder (INPUT 4,
                                 INPUT FRAME fPage0:HANDLE,
                                 INPUT FRAME fpage3:HANDLE,
                                 INPUT RETURN-VALUE).

    RUN insertFolder IN hFolder (INPUT 5,
                                 INPUT FRAME fPage0:HANDLE,
                                 INPUT FRAME fpage8:HANDLE,
                                 INPUT "Impostos 2").    

    RUN insertFolder IN hFolder (INPUT 6,
                                 INPUT FRAME fPage0:HANDLE,
                                 INPUT FRAME fpage4:HANDLE,
                                 INPUT "Documentos").
    
    RUN insertFolder IN hFolder (INPUT 7,
                                 INPUT FRAME fPage0:HANDLE,
                                 INPUT FRAME fpage5:HANDLE,
                                 INPUT "Siscomex").

    RUN insertFolder IN hFolder (INPUT 8,
                                 INPUT FRAME fPage0:HANDLE,
                                 INPUT FRAME fpage7:HANDLE,
                                 INPUT "Drawback").    
END.
ELSE DO:
    RUN deleteFolder IN hFolder (INPUT 2). /* Camb EMS 5*/
    
    RUN insertFolder IN hFolder (INPUT 2,
                                 INPUT FRAME fPage0:HANDLE,
                                 INPUT FRAME fpage3:HANDLE,
                                 INPUT "Impostos").
    
    RUN insertFolder IN hFolder (INPUT 3,
                                 INPUT FRAME fPage0:HANDLE,
                                 INPUT FRAME fpage4:HANDLE,
                                 INPUT "Documentos").

    RUN insertFolder IN hFolder (INPUT 4,
                                 INPUT FRAME fPage0:HANDLE,
                                 INPUT FRAME fpage7:HANDLE,
                                 INPUT "Drawback").  
        
    IF i-pais-impto-usuario = 2 THEN DO:
        RUN insertFolder IN hFolder (INPUT 5,
                                     INPUT FRAME fPage0:HANDLE,
                                     INPUT FRAME fpage6:HANDLE,
                                     INPUT "Argentina").
    END.
END.

IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
    HIDE FRAME fPage5. /* Siscomex */
    HIDE FRAME fPage8. /* Impostos 2 */
END.

IF i-pais-impto-usuario <> 2  /* Argentina */ THEN
    HIDE FRAME fPage6. /* Argentina */
    
RUN setfolder    IN hFolder (INPUT 1).

&IF '{&window-system}' = 'MS-WIN95':U or '{&window-system}' = 'MS-WINDOWS':U OR '{&window-system}' = 'MS-WINXP':U &THEN
    /* Preenche os campos senha com asterisco na digitacao */
    run SendMessage{&A} in hpApi(input c-des-senha-docto:hwnd in frame fPage4,
                                 input {&EM_SETPASSWORDCHAR}, /* EM_SetPasswordChar*/
                                 input 42,
                                 input 0).
    run SendMessage{&A} in hpApi (input c-confirma-senha-docto:hwnd in frame fPage4,
                                  input {&EM_SETPASSWORDCHAR}, /* EM_SetPasswordChar*/
                                  input 42,
                                  input 0).
    run SendMessage{&A} in hpApi(input c-des-senha-pch:hwnd in frame fPage4,
                                 input {&EM_SETPASSWORDCHAR}, /* EM_SetPasswordChar*/
                                 input 42,
                                 input 0).
    run SendMessage{&A} in hpApi (input c-confirma-senha-pch:hwnd in frame fPage4,
                                  input {&EM_SETPASSWORDCHAR}, /* EM_SetPasswordChar*/
                                  input 42,
                                  input 0).
&endif 

    IF i-pais-impto-usuario <> 1 THEN DO:
        ASSIGN RECT-74:HIDDEN                      IN FRAME fPage3 = YES
               l-inc-icms-ipi-outros:HIDDEN        IN FRAME fPage3 = YES
               tt-param-imp.hist-processo:HIDDEN   IN FRAME fPage1 = NO
               tt-param-imp.log-2:HIDDEN           IN FRAME fPage3 = YES
               tt-param-imp.inc-icms-tot-nf:HIDDEN IN FRAME fPage3 = YES              
               tg-sugere-loc-padrao:HIDDEN         IN FRAME fPage1 = YES
               log-cotac-ipi:HIDDEN                IN FRAME fPage3 = YES
               fi-despes-ipi:HIDDEN                IN FRAME fPage3 = YES
               fi-cd-fornec-ipi:HIDDEN             IN FRAME fPage3 = YES
               log-cotac-pis:HIDDEN                IN FRAME fPage3 = YES
               fi-despes-pis:HIDDEN                IN FRAME fPage3 = YES
               fi-cd-fornec-pis:HIDDEN             IN FRAME fPage3 = YES
               log-cotac-cofins:HIDDEN             IN FRAME fPage3 = YES
               fi-despes-cofins:HIDDEN             IN FRAME fPage3 = YES
               fi-cd-fornec-cofins:HIDDEN          IN FRAME fPage3 = YES               
               log-cotac-icms:HIDDEN               IN FRAME fPage3 = YES
               fi-despes-icms:HIDDEN               IN FRAME fPage3 = YES
               fi-cd-fornec-icms:HIDDEN            IN FRAME fPage3 = YES
               c-desc-desp-pis:HIDDEN              IN FRAME fPage3 = YES  
               c-desc-fornec-pis:HIDDEN            IN FRAME fPage3 = YES  
               c-desc-fornec-ipi:HIDDEN            IN FRAME fPage3 = YES  
               c-desc-desp-ipi:HIDDEN              IN FRAME fPage3 = YES  
               c-desc-desp-cofins:HIDDEN           IN FRAME fPage3 = YES  
               c-desc-fornec-cofins:HIDDEN         IN FRAME fPage3 = YES  
               c-desc-desp-icms:HIDDEN             IN FRAME fPage3 = YES  
               c-desc-fornec-icms:HIDDEN           IN FRAME fPage3 = YES
               lb-ipi:HIDDEN                       IN FRAME fPage3 = NO
               RECT-25:HIDDEN                      IN FRAME fPage3 = NO
               lb-pis:HIDDEN                       IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2
               lb-isd:HIDDEN                       IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2 AND i-pais-impto-usuario <> 21
               RECT-26:HIDDEN                      IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2 AND i-pais-impto-usuario <> 21
               c-desc-isd:HIDDEN                   IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2 AND i-pais-impto-usuario <> 21
               lb-cofins:HIDDEN                    IN FRAME fPage3 = YES
               RECT-27:HIDDEN                      IN FRAME fPage3 = YES WHEN i-pais-impto-usuario <> 2
               lb-icms:HIDDEN                      IN FRAME fPage3 = YES
               RECT-28:HIDDEN                      IN FRAME fPage3 = YES
               c-lbl-antecip:HIDDEN                  IN FRAME fPage3 = YES
               RECT-77:HIDDEN                        IN FRAME fPage3 = YES
               tt-param-imp.cod-espec-antecip:HIDDEN IN FRAME fPage3 = YES
               c-desc-espec:HIDDEN                   IN FRAME fPage3 = YES
               tt-param-imp.cod-ser-antecip:HIDDEN   IN FRAME fPage3 = YES
               tt-param-imp.perc-max-antecip:HIDDEN  IN FRAME fPage3 = YES
               tt-param-imp.log-descons-iva-tit-mercad:HIDDEN  IN FRAME fPage1 = NO
               tt-param-imp.cdn-despes-iva :HIDDEN  IN FRAME fPage3 = NO
               tt-param-imp.cdn-emit-iva   :HIDDEN  IN FRAME fPage3 = NO
               c-desc-fornec-iva           :HIDDEN  IN FRAME fPage3 = NO
               c-desc-desp-iva             :HIDDEN  IN FRAME fPage3 = NO
               tt-param-imp.cdn-despes-tax-estatis:HIDDEN  IN FRAME fPage3 = NO WHEN i-pais-impto-usuario = 2
               tt-param-imp.cdn-emit-tax-estatis  :HIDDEN  IN FRAME fPage3 = NO WHEN i-pais-impto-usuario = 2
               btFaixaImpto                       :HIDDEN  IN FRAME fPage3 = NO WHEN i-pais-impto-usuario = 2
               c-desc-fornec-est           :HIDDEN  IN FRAME fPage3 = NO        WHEN i-pais-impto-usuario = 2
               c-desc-desp-est             :HIDDEN  IN FRAME fPage3 = NO        WHEN i-pais-impto-usuario = 2
               l-gera-primeira-remessa-nf-mae:HIDDEN IN FRAME fPage1 = YES.

        IF i-pais-impto-usuario = 2 THEN DO:
            {utp/ut-liter.i "Taxa_Estat°stica" *}
            assign lb-pis:FORMAT IN FRAME fPage3 = "x(20)"
                   lb-pis:WIDTH IN FRAME fPage3 = 13.00
                   lb-pis:screen-value in frame fPage3 = RETURN-VALUE
                   rect-82:HIDDEN IN FRAME fPage3 = NO.

            {utp/ut-liter.i "Faixa_Imposto"}
            ASSIGN c-lbl-faixa-imposto:SCREEN-VALUE IN FRAME fPage3 = RETURN-VALUE
                   c-lbl-faixa-imposto:HIDDEN       IN FRAME fPage3 = NO.
                   
            {utp/ut-liter.i "Imposto_Pa°s" *}
            ASSIGN lb-isd:FORMAT IN FRAME fPage3 = "x(20)"
                   lb-isd:SCREEN-VALUE IN FRAME fPage3 = RETURN-VALUE
                   lb-isd = RETURN-VALUE
                   lb-isd:ROW IN FRAME fPage3 = 6.89
                   lb-isd:WIDTH IN FRAME fPage3 = 11.00
                   lb-isd:HEIGHT IN FRAME fPage3 = 0.63
                   cdn-despes-saida-div-aux:ROW IN FRAME fPage3 = 7.48
                   c-desc-isd:ROW IN FRAME fPage3 = 7.48
                   RECT-27:ROW IN FRAME fPage3 = 7.30
                   wg-lb-desp-isd = cdn-despes-saida-div-aux:SIDE-LABEL-HANDLE 
                   wg-lb-desp-isd:ROW = 7.48.
                   
        END.

        ASSIGN rect-76:HEIGHT IN FRAME fPage3 = 1.38.

        {utp/ut-liter.i "IPI" *}
        assign lb-ipi:screen-value in frame fPage3 = UPPER(RETURN-VALUE).

        {utp/ut-liter.i "DESPESAS_E_IMPOSTOS" *}
        assign c-lbl-despesas-impostos:screen-value in frame fPage3 = RETURN-VALUE.

        {utp/ut-liter.i "Despesas_Itiner†rio" *}
        assign texto-despes-itiner:screen-value in frame fPage1 = RETURN-VALUE.

        IF param-global.log-modul-draw THEN
           RUN setEnabled IN hFolder(4,YES).
        ELSE
           RUN setEnabled IN hFolder(4,NO).
    END.
    ELSE DO:
        ASSIGN l-inc-icms-ipi-outros:HIDDEN        IN FRAME fPage3 = NO
               tt-param-imp.hist-processo:HIDDEN   IN FRAME fPage1 = NO
               tt-param-imp.log-2:HIDDEN           IN FRAME fPage3 = NO
               tt-param-imp.inc-icms-tot-nf:HIDDEN IN FRAME fPage3 = NO
               c-cta-aplic-nf:HIDDEN               IN FRAME fPage1 = NO
               desc-cta-aplic-nf:HIDDEN            IN FRAME fPage1 = NO
               c-ccusto-aplic-nf:HIDDEN            IN FRAME fPage1 = NO
               desc-ccusto-aplic-nf:HIDDEN         IN FRAME fPage1 = NO.

        IF l-fn-antecip THEN
           ASSIGN c-lbl-antecip:HIDDEN                  IN FRAME fPage3 = NO
                  RECT-77:HIDDEN                        IN FRAME fPage3 = NO
                  tt-param-imp.cod-espec-antecip:HIDDEN IN FRAME fPage3 = NO
                  c-desc-espec:HIDDEN                   IN FRAME fPage3 = NO
                  tt-param-imp.cod-ser-antecip:HIDDEN   IN FRAME fPage3 = NO
                  tt-param-imp.perc-max-antecip:HIDDEN  IN FRAME fPage3 = NO.
        ELSE
           ASSIGN c-lbl-antecip:HIDDEN                  IN FRAME fPage3 = YES
                  RECT-77:HIDDEN                        IN FRAME fPage3 = YES
                  tt-param-imp.cod-espec-antecip:HIDDEN IN FRAME fPage3 = YES
                  c-desc-espec:HIDDEN                   IN FRAME fPage3 = YES
                  tt-param-imp.cod-ser-antecip:HIDDEN   IN FRAME fPage3 = YES
                  tt-param-imp.perc-max-antecip:HIDDEN  IN FRAME fPage3 = YES.
        
        IF param-global.log-modul-draw THEN
           RUN setEnabled IN hFolder(7,YES).
        ELSE
           RUN setEnabled IN hFolder(7,NO).
    END.

    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMaintenance 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Impostos 2 */
    EMPTY TEMP-TABLE tt-param-imp-trib.
    IF i-pais-impto-usuario = 1 THEN DO:
        RUN goToKey IN h-bocx00511 (INPUT tt-param-imp.cod-estabel).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getRecord IN h-bocx00511 (OUTPUT TABLE tt-param-imp-trib).
            FIND FIRST tt-param-imp-trib.
        END.
        ELSE 
            CREATE tt-param-imp-trib.
    END.
    ELSE
        CREATE tt-param-imp-trib.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenance 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN l-trata-dep-externos = CAN-FIND(FIRST funcao
                                       WHERE funcao.cd-funcao = "spp-trata-dep-ext-internac"
                                       AND   funcao.ativo)
                              AND i-pais-impto-usuario <> 1.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 35 BY 1.42
         BGCOLOR 7.

    DEFINE VARIABLE cStatus AS CHARACTER NO-UNDO.
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    DEFINE VARIABLE ccod-estabel LIKE tt-param-imp.cod-estabel NO-UNDO.

    DEFINE FRAME fGoToRecord
        ccod-estabel AT ROW 1.21 COL 15 COLON-ALIGNED
        btGoToOK      AT ROW 2.63 COL 2.14
        btGoToCancel  AT ROW 2.63 COL 13
        rtGoToButton  AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE FONT 1 TITLE "V† Para Param Imp"
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Param_Imp"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN ccod-estabel.

        &IF DEFINED(DBOVersion) <> 0 &THEN
           RUN findCodigo IN {&hDBOTable} (INPUT ccod-estabel,
                                           OUTPUT cStatus).
           IF cStatus <> "":U THEN DO:
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "ParÉmetros_de_Importaá∆o" *}
              RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                 INPUT 2, 
                                 INPUT RETURN-VALUE).

              RETURN NO-APPLY.
           END.
        /*&ELSE
 *            RUN goToKey IN {&hDBOTable} (INPUT iCustNum).
 *            IF RETURN-VALUE = "NOK":U THEN DO:
 *               RUN utp/ut-msgs.p (INPUT "SHOW":U, 
 *                                  INPUT 2, 
 *                                  INPUT "Customer":U).
 *               
 *               RETURN NO-APPLY.
 *            END.*/
        &ENDIF

        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).

        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    assign ccod-estabel:width = 4.

    ENABLE ccod-estabel btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 

    WAIT-FOR "GO":U OF FRAME fGoToRecord.
    END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
        RUN cxbo/bocx250.p persistent set h-bocx250.
    END.

    IF NOT VALID-HANDLE(h-bocx00511) THEN DO:
        RUN cxbo/bocx00511.p PERSISTENT SET h-bocx00511.
    END.
    RUN openQueryStatic IN h-bocx00511 (INPUT "Main":U).

    RUN adbo/boad107.p   persistent set h-boad107.
    RUN adbo/boad104.p   persistent set h-boad104.
    RUN adbo/boad142.p   persistent set h-boad142.
    RUN adbo/boad098.p   persistent set h-boad098.
    RUN cxbo/bocx095.p   persistent set h-bocx095.

    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        IF  NOT VALID-HANDLE(h-boar2084) THEN
            RUN local/arg/boar2084.p PERSISTENT SET h-boar2084.
    END.

    IF  i-pais-impto-usuario = 2 /* Argentina */ OR i-pais-impto-usuario = 21 THEN DO: /* Ecu */
        IF NOT VALID-HANDLE(h-bocx00476) THEN DO:
            RUN cxbo/bocx00476.p PERSISTENT SET h-bocx00476.
            RUN openQueryStatic IN h-bocx00476 (INPUT "Main":U) NO-ERROR.
        END.
    END.

    RUN unbo/boun005na.p persistent set h-boun005.
    RUN openQueryStatic IN h-boun005 (INPUT "Main":U).
    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    run inbo/boin245.p persistent set h-boin245.

    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOTable} (INPUT 1).
    &ELSE
        RUN openQueryStatic IN {&hDBOTable} (INPUT "cod-emitente":U).
    &ENDIF

    find first param-global no-lock no-error.
    if avail param-global then
        assign i-empresa-prin = param-global.empresa-prin.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-reg-arg wMaintenance 
PROCEDURE pi-gera-reg-arg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN gravaArgExt IN h-boar2084 (INPUT  i-empresa,
                               INPUT  tt-param-imp.cod-estabel:SCREEN-VALUE IN FRAME fPage0,
                               INPUT  c-classe:SCREEN-VALUE IN FRAME fPage6,
                               INPUT  tg-ger-pro:CHECKED IN FRAME fPage6,
                               INPUT  tg-ger-estq-emb:CHECKED IN FRAME fPage6).

    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida_ccusto wMaintenance 
PROCEDURE valida_ccusto :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER v_cod_ccusto AS CHAR NO-UNDO.
  
  run pi_busca_dados_ccusto in h_api_ccust (input  i-empresa,          /* EMPRESA EMS2 */
                                            input  "",                 /* CODIGO DO PLANO CCUSTO */
                                            input  v_cod_ccusto,       /* CCUSTO */
                                            input  today,              /* DATA DE TRANSACAO */
                                            output v_des_ccusto,       /* DESCRICAO DO CCUSTO */
                                            output table tt_log_erro). /* ERROS */ 
  FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
  IF AVAIL tt_log_erro THEN
      RETURN "NOK":U.
  ELSE
      RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida_conta wMaintenance 
PROCEDURE valida_conta :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER v_cod_cta_ctbl AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER v_log_utz_ccusto AS LOGICAL NO-UNDO.

  ASSIGN v_log_utz_ccusto = YES.

  run pi_busca_dados_cta_ctbl in h_api_cta (INPUT        i-empresa,                                      /* EMPRESA EMS2 */
                                            INPUT        "",                                             /* PLANO DE CONTAS */
                                            INPUT-OUTPUT v_cod_cta_ctbl,                                 /* CONTA */
                                            INPUT        TODAY,    /* DATA TRANSACAO */   
                                            OUTPUT       v_des_cta_ctbl,                                 /* DESCRICAO CONTA */
                                            OUTPUT       v_num_tip_cta_ctbl,                             /* TIPO DA CONTA */
                                            OUTPUT       v_num_sit_cta_ctbl,                             /* SITUAÄ«O DA CONTA */
                                            OUTPUT       v_ind_finalid_cta,                              /* FINALIDADES DA CONTA */
                                            OUTPUT TABLE tt_log_erro).
  FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
  IF AVAIL tt_log_erro THEN
      RETURN "NOK":U.
  ELSE DO:   
      run pi_verifica_utilizacao_ccusto in h_api_ccust (input i-empresa,                /* EMPRESA EMS 2 */
                                                        input tt-param-imp.cod-estabel:SCREEN-VALUE IN FRAME fPage0, /* ESTABELECIMENTO EMS2 */
                                                        input "",                       /* PLANO CONTAS */
                                                        input v_cod_cta_ctbl,           /* CONTA */
                                                        input  today,                   /* DT TRANSACAO */
                                                        output v_log_utz_ccusto,        /* UTILIZA CCUSTO ? */
                                                        output table tt_log_erro).      /* ERROS */
      RETURN "OK":U.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

