&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL,  sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0100 2.00.01.025 } /*** "010125" 02/10/2026 17:42:36 ***/
 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0100 MIM}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

{cdp/cdcfgmat.i} /* Definiá∆o de prÇ-processadores */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA f-pg-cla
&GLOBAL-DEFINE PGPAR 
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP 

&glob bf_nr_nota yes /*Pre-processador utilizado no aumento do formato da nota fiscal*/

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{utp/ut-glob.i}
{cdp/cdcfgdis.i} /* Definiá∆o dos prÇ-processadores */

DEFINE VARIABLE c-arq-digita               AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-terminal                 AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-formato                  AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-num-embarque             AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-return                   AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-titulo                   AS   CHARACTER FORMAT "X(30)":U         NO-UNDO. /*like conta-contab.conta-titulo*/
DEFINE VARIABLE c-embarques-gerados        AS   CHARACTER                          NO-UNDO.  
DEFINE VARIABLE c-formato-cta-ctbl         AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-formato-nf               AS   CHARACTER FORMAT "x(16)":U         NO-UNDO.
DEFINE VARIABLE ccalculo-faltante          AS   CHARACTER FORMAT "x(20)":U         NO-UNDO.
DEFINE VARIABLE c-retorno                  AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-char-1                   AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-desc-msg                 AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE de-cotacao-dia             AS   DECIMAL FORMAT ">>>,>9.99999999":U NO-UNDO.
DEFINE VARIABLE hProgramZoom               AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE h-bocx220                  AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE h-boin292                  AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE h-bocx220a                 AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE h-bocx225                  AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE h-bocx220c                 AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE h-boad049                  AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE h-boin682                  AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE h-boin375                  AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE h-boin245                  AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE hShowMsg                   AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE h-acomp                    AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE h-im0100aa                 AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE h-bocx402                  AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE h-bocx383                  AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE h-bocx383a                 AS   HANDLE                             NO-UNDO.
DEFINE VARIABLE i-cambial                  AS   INTEGER                            NO-UNDO.
DEFINE VARIABLE i-cont                     AS   INTEGER                            NO-UNDO.
DEFINE VARIABLE i-cont-nr-serie            AS   INTEGER    FORMAT 9999             NO-UNDO.
DEFINE VARIABLE i-seq-erro                 AS   INTEGER                            NO-UNDO.
DEFINE VARIABLE rs-classif-nf-aux          AS   INTEGER                            NO-UNDO.
DEFINE VARIABLE i-seq-item-serie           AS   INTEGER                            NO-UNDO.
DEFINE VARIABLE i-quebra                   AS   INTEGER                            NO-UNDO.
DEFINE VARIABLE i-tp-nacionaliz            AS   INTEGER                            NO-UNDO.
DEFINE VARIABLE i-empresa-prin             AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-estabelec                AS   CHARACTER                          NO-UNDO.                                                                        
DEFINE VARIABLE l-primeira-exec            AS   LOGICAL INITIAL YES                NO-UNDO.
DEFINE VARIABLE l-carrega-embarques        AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-primeiro-emb             AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-ok                       AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-formato                  AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-verifica-nota-filha      AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-verifica-nota-mae        AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-executar                 AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-valida-decl-imp          AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-emit-diferente           AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-fornec-fundap            AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-criou                    AS   LOGICAL INITIAL NO                 NO-UNDO.
DEFINE VARIABLE l-verifica-erro            AS   LOGICAL INITIAL NO                 NO-UNDO.
DEFINE VARIABLE l-chama-carregado          AS   LOGICAL INITIAL NO                 NO-UNDO.
DEFINE VARIABLE l-alterou-di               AS   LOGICAL INITIAL NO                 NO-UNDO.
DEFINE VARIABLE l-carrega-tt               AS   LOGICAL INITIAL NO                 NO-UNDO.
DEFINE VARIABLE l-gera-remessa-mae         AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-embarque-vinc-di         AS   LOGICAL INITIAL NO                 NO-UNDO.
DEFINE VARIABLE l-abriu-zoom               AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE llog-situacao              AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-encontrou                AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-erro                     AS   LOGICAL INITIAL NO                 NO-UNDO.
DEFINE VARIABLE l-natur-rateio             AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE r-maior-item               AS   ROWID                              NO-UNDO.
DEFINE VARIABLE c-proximo-nro              LIKE docum-est.nro-docto                NO-UNDO.
DEFINE VARIABLE vnum-di-siscomex           LIKE decla-import.cod-di-siscomex       NO-UNDO.
DEFINE VARIABLE c-di-old                   LIKE decla-import.cod-di-siscomex       NO-UNDO.
DEFINE VARIABLE c-numero-docto             LIKE docum-est.nro-docto                NO-UNDO.
DEFINE VARIABLE c-serie-docto              LIKE docum-est.serie-docto              NO-UNDO.
DEFINE VARIABLE c-emitente-docto           LIKE docum-est.cod-emitente             NO-UNDO.
DEFINE VARIABLE c-nat-operacao             LIKE docum-est.nat-operacao             NO-UNDO.
DEFINE VARIABLE c-cod-refer                LIKE item-doc-est.cod-refer             NO-UNDO.
DEFINE VARIABLE c-conta-transit-import     LIKE param-imp.ct-transit-import        NO-UNDO.
DEFINE VARIABLE c-conta-transit-import-aux LIKE param-imp.ct-transit-import        NO-UNDO.
DEFINE VARIABLE c-ccusto-transit-import    LIKE param-imp.sc-transit-import        NO-UNDO.
DEFINE VARIABLE i-cod-cond-pag             LIKE cond-pagto.cod-cond-pag            NO-UNDO.
DEFINE VARIABLE de-maior-item              LIKE item-doc-est.preco-total[1]        NO-UNDO.
DEFINE VARIABLE de-preco-sub-tot-mn-2      LIKE item-doc-est.preco-total[1]        NO-UNDO.
DEFINE VARIABLE de-residuo                 LIKE item-doc-est.preco-total[1]        NO-UNDO.
DEFINE VARIABLE i-mo-codigo                LIKE moeda.mo-codigo                    NO-UNDO.
DEFINE VARIABLE i-moeda-negoc              LIKE moeda.mo-codigo                    NO-UNDO.
DEFINE VARIABLE de-preco-sub-tot-mn        LIKE item-doc-est.preco-total[1]        NO-UNDO.
DEFINE VARIABLE de-preco-sub-tot-me        LIKE item-doc-est.preco-total[1]        NO-UNDO.
DEFINE VARIABLE i-pto-contr-base           LIKE pto-contr.cod-pto-contr            NO-UNDO.
DEFINE VARIABLE i-cod-itiner               LIKE itinerario.cod-itiner              NO-UNDO.
DEFINE VARIABLE c-estab-fisc               LIKE processo-imp.estab-fisc            NO-UNDO.
DEFINE VARIABLE i-cod-emitente             LIKE processo-imp.cod-exportador        NO-UNDO.
DEFINE VARIABLE c-nome-abrev               LIKE emitente.nome-abrev                NO-UNDO.
DEFINE VARIABLE c-ct-transit               LIKE param-imp.ct-transit-import        NO-UNDO.
DEFINE VARIABLE c-sc-transit               LIKE param-imp.sc-transit-import        NO-UNDO.
DEFINE VARIABLE c-decla-import             LIKE embarque-imp.declaracao-import     NO-UNDO.
DEFINE VARIABLE d-dat-di                   LIKE embarque-imp.data-di               NO-UNDO.
DEFINE VARIABLE vdat-di                    LIKE decla-import.dat-di                NO-UNDO.
DEFINE VARIABLE vnat-operacao              LIKE decla-import.cod-natur-operac      NO-UNDO.
DEFINE VARIABLE i-empresa                  LIKE param-global.empresa-prin          NO-UNDO.

DEF VAR wh-label-cla  AS WIDGET-HANDLE NO-UNDO. 
DEF VAR wh-label-sel AS WIDGET-HANDLE NO-UNDO.

FIND FIRST param-global NO-LOCK NO-ERROR.
ASSIGN i-empresa = param-global.empresa-prin.

{method/dbotterr.i}
{include/boerrtab.i}

/*{cxbo/bocx220a.i}*/
{imp/im0100x.i tt-parametros}
{cxbo/bocx220c.i tt-item-doc-est}
{imp/im0100.i}
{adbo/boad107.i tt-estabelec}
{cdp/cd0667.i -conting-nfe}  /* Definiá∆o tt-erro-conting-nfe */
{cxbo/bocx220c.i tt-itens-aux} /* Temp-table auxiliar para criaá∆o dos itens do desembarque */  
{cxbo/bocx220q02.i tt-embarque-imp} /* Temp-table auxiliar para criaá∆o desembarque */  

DEFINE TEMP-TABLE tt-docum-est-aux NO-UNDO
    FIELD declaracao-import LIKE docum-est.declaracao-import
    FIELD cod-estabel       LIKE docum-est.cod-estabel
    FIELD cod-embarq        LIKE decla-import-embarq.cod-embarq
    FIELD idi-nf-simples-remes LIKE docum-est.idi-nf-simples-remes
    FIELD ce-atual          LIKE docum-est.ce-atual
    INDEX embarque cod-estabel
                   cod-embarq.

{cdp~/cd2508.i}
def temp-table tt-retorno no-undo like tt-bo-erro.

DEF TEMP-TABLE tt-item-doc-est-aux NO-UNDO LIKE tt-item-doc-est.

DEF TEMP-TABLE tt-embarques-gerados NO-UNDO
    FIELD cod-embarq LIKE decla-import-embarq.cod-embarq.

DEFINE TEMP-TABLE tt-embarqueDI NO-UNDO 
    FIELD num-di-ems       LIKE decla-import.num-di-ems
    FIELD cod-estab        LIKE decla-import.cod-estab
    FIELD cod-embarq       LIKE decla-import-embarq.cod-embarq
    FIELD nro-docto        LIKE docum-est.nro-docto
    FIELD serie-docto      LIKE docum-est.serie-docto
    FIELD nat-operacao     LIKE docum-est.nat-operacao
    FIELD cod-emitente     LIKE docum-est.cod-emitente
    FIELD cod-estab-fiscal LIKE docum-est.cod-estabel
    FIELD dt-emissao       LIKE docum-est.dt-emissao
    FIELD dt-trans         LIKE docum-est.dt-trans
    FIELD dt-venc-icm      LIKE docum-est.dt-venc-icm
    FIELD dt-venc-ipi      LIKE docum-est.dt-venc-ipi
    FIELD ct-transit       AS   CHARACTER FORMAT "X(20)":U 
    FIELD sc-transit       AS   CHARACTER FORMAT "X(20)":U
    FIELD tot-desconto     AS   DECIMAL FORMAT ">>>>>9.99":U 
    FIELD aliquota-icm     AS   LOGICAL
    FIELD observacao       AS   CHARACTER FORMAT "x(2000)":U
    FIELD log-marcado      AS   LOGICAL 
    FIELD log-nf-gerada    AS   LOGICAL.

DEFINE TEMP-TABLE tt-embarqueDI-aux NO-UNDO 
    FIELD num-di-ems       LIKE decla-import.num-di-ems
    FIELD cod-estab        LIKE decla-import.cod-estab
    FIELD cod-embarq       LIKE decla-import-embarq.cod-embarq
    FIELD nro-docto        LIKE docum-est.nro-docto
    FIELD serie-docto      LIKE docum-est.serie-docto
    FIELD nat-operacao     LIKE docum-est.nat-operacao
    FIELD cod-emitente     LIKE docum-est.cod-emitente
    FIELD cod-estab-fiscal LIKE docum-est.cod-estabel
    FIELD dt-emissao       LIKE docum-est.dt-emissao
    FIELD dt-trans         LIKE docum-est.dt-trans
    FIELD dt-venc-icm      LIKE docum-est.dt-venc-icm
    FIELD dt-venc-ipi      LIKE docum-est.dt-venc-ipi
    FIELD ct-transit       AS   CHARACTER FORMAT "X(20)":U 
    FIELD sc-transit       AS   CHARACTER FORMAT "X(20)":U
    FIELD tot-desconto     AS   DECIMAL FORMAT ">>>>>9.99":U
    FIELD aliquota-icm     AS   LOGICAL
    FIELD observacao       AS   CHARACTER FORMAT "x(2000)":U
    FIELD log-marcado      AS   LOGICAL 
    FIELD log-nf-gerada    AS   LOGICAL.




def new global shared var adm-broker-hdl as handle no-undo.
def new global shared var l-nff          as log init no no-undo.
DEF BUFFER bf-tt-embarqueDI  FOR tt-embarqueDI.
DEF BUFFER b-tt-item-doc-est FOR tt-item-doc-est.
DEF BUFFER b-ordens-embarque FOR ordens-embarque.

/* Definiá∆o de PrÇ-Processadores */

{include/i_dbvers.i} /*Include de PrÇ-Processadores*/

IF  i-pais-impto-usuario <> 1 THEN DO:
    RUN utp/ut-msgs.p (INPUT "show":U, INPUT 31458, INPUT "IM0100":U + "~~":U + "IM3100":U).
    RETURN "NOK":U.
END.

/***********API FINANCAS****************/
def var h_api_cta          as handle no-undo.
def var h_api_ccust        as handle no-undo.
def var p_cod_format_cta_ctbl   as char   no-undo.
DEF VAR p_cod_format_ccusto     AS CHAR NO-UNDO.
DEF VAR p_des_titulo        AS CHAR NO-UNDO.
DEF VAR v_des_ccusto        AS CHAR NO-UNDO.
DEF VAR v_cod_cta_ctbl AS CHAR NO-UNDO.
DEF VAR v_cod_ccusto AS CHAR NO-UNDO.
DEF VAR v_des_cta_ctbl AS CHAR NO-UNDO.
DEF VAR v_num_tip_cta_ctbl AS CHAR NO-UNDO.
DEF VAR v_num_sit_cta_ctbl AS CHAR NO-UNDO.
DEF VAR v_ind_finalid_cta AS CHAR NO-UNDO.
DEF VAR v_log_utz_ccusto AS CHAR NO-UNDO.

run prgint/utb/utb743za.py persistent set h_api_cta.
run prgint/utb/utb742za.py persistent set h_api_ccust.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Nﬂmero" column-label "Nﬂmero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¨ncia".

/***************************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-cla
&Scoped-define BROWSE-NAME brNota

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-embarqueDI

/* Definitions for BROWSE brNota                                        */
&Scoped-define FIELDS-IN-QUERY-brNota tt-embarqueDI.log-nf-gerada tt-embarqueDI.serie-docto tt-embarqueDI.nro-docto tt-embarqueDI.cod-embarq tt-embarqueDI.nat-operacao tt-embarqueDI.cod-emitente tt-embarqueDI.cod-estab-fiscal tt-embarqueDI.dt-emissao tt-embarqueDI.dt-trans tt-embarqueDI.dt-venc-icm tt-embarqueDI.dt-venc-ipi tt-embarqueDI.ct-transit tt-embarqueDI.sc-transit tt-embarqueDI.aliquota-icm tt-embarqueDI.observacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brNota tt-embarqueDI.serie-docto ~
tt-embarqueDI.nro-docto ~
tt-embarqueDI.cod-estab-fiscal ~
tt-embarqueDI.dt-emissao ~
tt-embarqueDI.dt-trans ~
tt-embarqueDI.dt-venc-icm ~
tt-embarqueDI.dt-venc-ipi ~
 tt-embarqueDI.ct-transit ~
tt-embarqueDI.sc-transit ~
tt-embarqueDI.aliquota-icm ~
tt-embarqueDI.observacao   
&Scoped-define ENABLED-TABLES-IN-QUERY-brNota tt-embarqueDI
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brNota tt-embarqueDI
&Scoped-define SELF-NAME brNota
&Scoped-define QUERY-STRING-brNota FOR EACH tt-embarqueDI
&Scoped-define OPEN-QUERY-brNota OPEN QUERY {&SELF-NAME} FOR EACH tt-embarqueDI.
&Scoped-define TABLES-IN-QUERY-brNota tt-embarqueDI
&Scoped-define FIRST-TABLE-IN-QUERY-brNota tt-embarqueDI


/* Definitions for FRAME f-decl-imp                                     */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-decl-imp ~
    ~{&OPEN-QUERY-brNota}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS l-nf-simples-remessa ~
l-gera-prim-remes-nf-mae l-nf-ajuste 
&Scoped-Define DISPLAYED-OBJECTS l-nf-simples-remessa rs-classif-nf ~
l-gera-prim-remes-nf-mae c-cta-aplic-nf desc-cta-aplic-nf c-ccusto-aplic-nf ~
desc-ccusto-aplic-nf l-nf-ajuste 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image/im-sav":U
     LABEL "Button 1" 
     SIZE 5.14 BY 1.

DEFINE BUTTON bt-marcar 
     LABEL "Marcar" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-nenhum 
     LABEL "Nenhum" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-todos 
     LABEL "Todos" 
     SIZE 15 BY 1.

DEFINE VARIABLE ccod-decl-imp-1 AS CHARACTER FORMAT "x(20)":U 
     LABEL "DI/DUIMP Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-estabel-1 AS CHARACTER FORMAT "x(05)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-cotacao-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Cotaá∆o Moeda" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-di-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Data DI/DUIMP EMS" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE icod-di-ems AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "DI/DUIMP EMS" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE EDITOR-2 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 61 BY 2.42 NO-UNDO.

DEFINE VARIABLE c-label-obs AS CHARACTER FORMAT "X(256)":U INITIAL "Observaá∆o:" 
      VIEW-AS TEXT 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE cccusto-trans AS CHARACTER FORMAT "X(20)":U 
     LABEL "CCusto Transit¢ria" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-decl-imp AS CHARACTER FORMAT "X(20)":U 
     LABEL "Declaraá∆o Importaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-emitente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .88 NO-UNDO.

DEFINE VARIABLE ccod-estabel LIKE estabelec.cod-estabel
     LABEL "Estab":R7 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE ccod-estabel-fisc LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE cconta-trans AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta Transit¢ria" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE cdesc-tot AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Total Desconto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE cembarque AS CHARACTER FORMAT "X(16)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cnatureza AS CHARACTER FORMAT "x(6)":U 
     LABEL "Natureza Operaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE cnr-docto AS CHARACTER FORMAT "X(15)":U 
     LABEL "Nro Docto" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE cserie AS CHARACTER FORMAT "X(10)":U 
     LABEL "SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-cotacao AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Cotac∆o Moeda" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-di AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data DI" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-emissao AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-trans AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Transaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-vencto-icms AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Vencimento ICMS" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE ddata-vencto-ipi AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Vencimento IPI" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE l-nota-fisc-fat AS LOGICAL INITIAL no 
     LABEL "Nota Fiscal Fatura" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE licms-diferido AS LOGICAL INITIAL no 
     LABEL "Al°quota 0 - ICMS Diferido" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-ccusto-aplic-nf AS CHARACTER FORMAT "X(20)":U 
     LABEL "CCusto Aplicaá∆o NF Simples Remessa" 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cta-aplic-nf AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta Aplicaá∆o NF Simples Remessa" 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE desc-ccusto-aplic-nf AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE desc-cta-aplic-nf AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE rs-classif-nf AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Nota M∆e", 1,
"Nota Filha", 2
     SIZE 10.86 BY 2 NO-UNDO.

DEFINE VARIABLE l-gera-prim-remes-nf-mae AS LOGICAL INITIAL no 
     LABEL "Gera Primeira Remessa com NF M∆e" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.

DEFINE VARIABLE l-nf-ajuste AS LOGICAL INITIAL no 
     LABEL "Nota Fiscal Ajuste" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE l-nf-simples-remessa AS LOGICAL INITIAL no 
     LABEL "Nota Fiscal Simples Remessa" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.72 BY 1.08 NO-UNDO.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-tipo 
     IMAGE-UP FILE "image/im-fil.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-fil.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btconferencia 
     LABEL "&Conferància" 
     SIZE 11 BY 1.

DEFINE BUTTON btimpostos 
     LABEL "&Impostos" 
     SIZE 10 BY 1.

DEFINE BUTTON btpesoscubagem 
     LABEL "&Pesos e &Cubagem" 
     SIZE 15 BY 1.
/*
DEFINE VARIABLE c-label-cla AS CHARACTER FORMAT "x(10)" INITIAL "Simples Remessa" 
      VIEW-AS TEXT 
     SIZE 13 BY .88 NO-UNDO.
DEFINE VARIABLE c-label-des AS CHARACTER FORMAT "x(7)" INITIAL "Desembarque" 
      VIEW-AS TEXT 
     SIZE 13 BY .88 NO-UNDO.
*/

DEFINE IMAGE im-pg-cla
     FILENAME "image/im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image/im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 88 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 87.86 BY .21
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 13.75
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .86 BY 13.71
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 13.58
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 87.86 BY .21
     BGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brNota FOR 
      tt-embarqueDI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brNota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brNota w-relat _FREEFORM
  QUERY brNota DISPLAY
      tt-embarqueDI.log-nf-gerada    COLUMN-LABEL 'NF':U       FORMAT "Sim/N∆o":U  WIDTH 03
      tt-embarqueDI.serie-docto    COLUMN-LABEL 'SÇrie':U                        WIDTH 07
    tt-embarqueDI.nro-docto        COLUMN-LABEL 'Documento':U                    WIDTH 18
    tt-embarqueDI.cod-embarq       COLUMN-LABEL 'Embarque':U                     WIDTH 16
    tt-embarqueDI.nat-operacao     COLUMN-LABEL 'Nat.Oper.':U                    WIDTH 08
    tt-embarqueDI.cod-emitente     COLUMN-LABEL 'Emitente':U                     WIDTH 11
    tt-embarqueDI.cod-estab-fiscal COLUMN-LABEL 'Est.Fiscal':U                   WIDTH 10
    tt-embarqueDI.dt-emissao       COLUMN-LABEL 'Dt Emiss∆o':U                   WIDTH 10
    tt-embarqueDI.dt-trans         COLUMN-LABEL 'Dt Trans':U                     WIDTH 10
    tt-embarqueDI.dt-venc-icm      COLUMN-LABEL 'Dt Vencto ICMS':U               WIDTH 10
    tt-embarqueDI.dt-venc-ipi      COLUMN-LABEL 'Dt Vencto IPI':U                WIDTH 10
    tt-embarqueDI.ct-transit       COLUMN-LABEL 'Conta Transit':U                WIDTH 19
    tt-embarqueDI.sc-transit       COLUMN-LABEL 'CCusto Transit':U               WIDTH 19
    tt-embarqueDI.aliquota-icm     COLUMN-LABEL 'Aliq ICMS':U FORMAT "Sim/N∆o":U WIDTH 08
    tt-embarqueDI.observacao       COLUMN-LABEL 'Observaá∆o':U

ENABLE tt-embarqueDI.serie-docto
       tt-embarqueDI.nro-docto
       tt-embarqueDI.cod-estab-fiscal
       tt-embarqueDI.dt-emissao
       tt-embarqueDI.dt-trans
       tt-embarqueDI.dt-venc-icm
       tt-embarqueDI.dt-venc-ipi 
       tt-embarqueDI.ct-transit
       tt-embarqueDI.sc-transit
       tt-embarqueDI.aliquota-icm
       tt-embarqueDI.observacao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 83 BY 7.88
         FONT 1 ROW-HEIGHT-CHARS .63 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-executar AT ROW 16.58 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 16.58 COL 14 HELP
          "Fechar"
     btpesoscubagem AT ROW 16.58 COL 25
     btimpostos AT ROW 16.58 COL 40.86
     btconferencia AT ROW 16.58 COL 51.86
     bt-tipo AT ROW 16.58 COL 64
     bt-ajuda AT ROW 16.58 COL 79 HELP
          "Ajuda"
  
     rt-folder-right AT ROW 2.67 COL 89.29
     RECT-6 AT ROW 15.96 COL 2.14
     rt-folder-top AT ROW 2.46 COL 2.14
     RECT-1 AT ROW 16.33 COL 2
     rt-folder-left AT ROW 2.54 COL 1.72
     im-pg-cla AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.83
         BGCOLOR 17 FONT 1
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-cla
     l-nf-simples-remessa AT ROW 1.29 COL 31
     rs-classif-nf AT ROW 2.29 COL 31 NO-LABEL
     l-gera-prim-remes-nf-mae AT ROW 4.29 COL 31
     c-cta-aplic-nf AT ROW 5.33 COL 29 COLON-ALIGNED
     desc-cta-aplic-nf AT ROW 5.33 COL 45.86 COLON-ALIGNED NO-LABEL
     c-ccusto-aplic-nf AT ROW 6.33 COL 29 COLON-ALIGNED
     desc-ccusto-aplic-nf AT ROW 6.33 COL 45.86 COLON-ALIGNED NO-LABEL
     l-nf-ajuste AT ROW 7.54 COL 31
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 86.29 BY 13.04
         BGCOLOR 17 FONT 1.

DEFINE FRAME f-pg-sel
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 86.29 BY 13.13
         BGCOLOR 17 FONT 1.

DEFINE FRAME f-decl-imp
     ccod-decl-imp-1 AT ROW 1.5 COL 19 COLON-ALIGNED HELP
          "Declaraá∆o Importaá∆o SISCOMEX"
     ccod-estabel-1 AT ROW 1.5 COL 56 COLON-ALIGNED HELP
          "Estabelecimento"
     icod-di-ems AT ROW 2.5 COL 19 COLON-ALIGNED HELP
          "DI/DUIMP EMS"
     bt-confirma AT ROW 3.42 COL 70
     ddata-di-1 AT ROW 3.5 COL 19 COLON-ALIGNED HELP
          "Data DI"
     ddata-cotacao-1 AT ROW 3.5 COL 57 COLON-ALIGNED HELP
          "Data Cotaá∆o Moeda"
     brNota AT ROW 4.63 COL 3
     bt-marcar AT ROW 12.75 COL 3
     bt-todos AT ROW 12.75 COL 18
     bt-nenhum AT ROW 12.75 COL 33
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 86 BY 13
         BGCOLOR 17 FONT 1.

DEFINE FRAME f-embarq
     cembarque AT ROW 1.25 COL 18 COLON-ALIGNED
     ccod-estabel AT ROW 1.25 COL 59.14 COLON-ALIGNED HELP
          ""
          LABEL "Estab":R7
          FONT 1
     ccod-emitente AT ROW 2.25 COL 18 COLON-ALIGNED
     ddata-trans AT ROW 2.25 COL 59.14 COLON-ALIGNED
     ddata-emissao AT ROW 3.25 COL 18 COLON-ALIGNED
     ddata-vencto-ipi AT ROW 3.25 COL 59.14 COLON-ALIGNED
     ddata-vencto-icms AT ROW 4.25 COL 18 COLON-ALIGNED
     cnr-docto AT ROW 4.25 COL 59.14 COLON-ALIGNED
     cserie AT ROW 5.25 COL 18 COLON-ALIGNED
     cnatureza AT ROW 5.25 COL 59.14 COLON-ALIGNED
     ccod-estabel-fisc AT ROW 6.25 COL 18 COLON-ALIGNED HELP
          ""
     cconta-trans AT ROW 6.25 COL 59.14 COLON-ALIGNED
     ccod-decl-imp AT ROW 7.25 COL 18 COLON-ALIGNED
     cccusto-trans AT ROW 7.25 COL 59 COLON-ALIGNED
     cdesc-tot AT ROW 8.25 COL 18 COLON-ALIGNED
     ddata-cotacao AT ROW 8.25 COL 59 COLON-ALIGNED
     ddata-di AT ROW 9.25 COL 18 COLON-ALIGNED
     licms-diferido AT ROW 10.25 COL 20
     l-nota-fisc-fat AT ROW 10.25 COL 61
     EDITOR-2 AT ROW 11.25 COL 20 NO-LABEL
     c-label-obs AT ROW 11 COL 6 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 86 BY 13
         BGCOLOR 17 FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.83
         WIDTH              = 90
         MAX-HEIGHT         = 22.33
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.33
         VIRTUAL-WIDTH      = 114.29
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-relat 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-relat
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME f-decl-imp:FRAME = FRAME f-pg-sel:HANDLE
       FRAME f-embarq:FRAME = FRAME f-pg-sel:HANDLE.

/* SETTINGS FOR FRAME f-decl-imp
                                                                        */
/* BROWSE-TAB brNota ddata-cotacao-1 f-decl-imp */
/* SETTINGS FOR FILL-IN ccod-estabel-1 IN FRAME f-decl-imp
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ddata-cotacao-1 IN FRAME f-decl-imp
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ddata-di-1 IN FRAME f-decl-imp
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN icod-di-ems IN FRAME f-decl-imp
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-embarq
                                                                        */
/* SETTINGS FOR FILL-IN ccod-estabel IN FRAME f-embarq
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN ccod-estabel-fisc IN FRAME f-embarq
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FRAME f-pg-cla
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-ccusto-aplic-nf IN FRAME f-pg-cla
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cta-aplic-nf IN FRAME f-pg-cla
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN desc-ccusto-aplic-nf IN FRAME f-pg-cla
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN desc-cta-aplic-nf IN FRAME f-pg-cla
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET rs-classif-nf IN FRAME f-pg-cla
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME f-embarq:MOVE-BEFORE-TAB-ITEM (FRAME f-decl-imp:HANDLE)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brNota
/* Query rebuild information for BROWSE brNota
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-embarqueDI.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brNota */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON END-ERROR OF w-relat
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brNota
&Scoped-define FRAME-NAME f-decl-imp
&Scoped-define SELF-NAME brNota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNota w-relat
ON MOUSE-SELECT-CLICK OF brNota IN FRAME f-decl-imp
DO:
    APPLY 'value-changed':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNota w-relat
ON MOUSE-SELECT-DBLCLICK OF brNota IN FRAME f-decl-imp
DO:
  RUN piMarcaEmbarque. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNota w-relat
ON ROW-DISPLAY OF brNota IN FRAME f-decl-imp
DO:
  RUN pi-mudaFonteCor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNota w-relat
ON ROW-LEAVE OF brNota IN FRAME f-decl-imp
DO:
    /* N∆o executar a row-leave ao executar o zoom */ 
    if  l-abriu-zoom then return 'NOK':U.  
    
    IF  AVAIL tt-embarqueDI THEN
        ASSIGN INPUT BROWSE brNota tt-embarqueDI.serie-docto     
               INPUT BROWSE brNota tt-embarqueDI.nro-docto       
               INPUT BROWSE brNota tt-embarqueDI.cod-estab-fiscal
               INPUT BROWSE brNota tt-embarqueDI.dt-emissao      
               INPUT BROWSE brNota tt-embarqueDI.dt-trans        
               INPUT BROWSE brNota tt-embarqueDI.dt-venc-icm     
               INPUT BROWSE brNota tt-embarqueDI.dt-venc-ipi     
               INPUT BROWSE brNota tt-embarqueDI.ct-transit
               INPUT BROWSE brNota tt-embarqueDI.sc-transit
               INPUT BROWSE brNota tt-embarqueDI.aliquota-icm    
               INPUT BROWSE brNota tt-embarqueDI.observacao.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNota w-relat
ON VALUE-CHANGED OF brNota IN FRAME f-decl-imp
DO:
    IF  AVAIL tt-embarqueDI THEN
        ASSIGN ccod-estabel   = tt-embarqueDI.cod-estab
               cembarque      = tt-embarqueDI.cod-embarq
               cnatureza      = tt-embarqueDI.nat-operacao
               licms-diferido = tt-embarqueDI.aliquota-icm.

    IF AVAIL tt-embarqueDI THEN
        ASSIGN bt-marcar:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
        ASSIGN bt-marcar:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-relat
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-decl-imp
&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma w-relat
ON CHOOSE OF bt-confirma IN FRAME f-decl-imp /* Button 1 */
DO:

    RUN pi-carregaTT. /* Carregar temp-table dos embarques relacionados a Declaraá∆o de Importaá∆o */

    ASSIGN l-carrega-tt = YES
           l-alterou-di = NO.

    IF CAN-FIND(FIRST tt-embarqueDI)
    THEN ASSIGN btconferencia:SENSITIVE  IN FRAME f-relat = YES 
                btimpostos:SENSITIVE     IN FRAME f-relat = YES.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:    
    RUN pi-btExecutar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-decl-imp
&Scoped-define SELF-NAME bt-marcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marcar w-relat
ON CHOOSE OF bt-marcar IN FRAME f-decl-imp /* Marcar */
DO:  
  RUN piMarcaEmbarque. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum w-relat
ON CHOOSE OF bt-nenhum IN FRAME f-decl-imp /* Nenhum */
DO:
    FOR EACH tt-embarqueDI:
        ASSIGN tt-embarqueDI.log-marcado = NO.        
    END.                    

    {&OPEN-QUERY-brNota}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-tipo w-relat
ON CHOOSE OF bt-tipo IN FRAME f-relat
DO:
    RUN pi-TipoInicial.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-decl-imp
&Scoped-define SELF-NAME bt-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos w-relat
ON CHOOSE OF bt-todos IN FRAME f-decl-imp /* Todos */
DO:
  FOR EACH tt-embarqueDI:
      ASSIGN tt-embarqueDI.log-marcado = YES.
  END.  

  {&OPEN-QUERY-brNota}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME     
     
&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME btconferencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btconferencia w-relat
ON CHOOSE OF btconferencia IN FRAME f-relat /* Conferància */
DO:
    EMPTY TEMP-TABLE RowErrors.

    assign l-executar = no.           
    do  transaction:
        IF  c-nom-prog-upc-mg97 <> "" THEN DO:
            RUN VALUE(c-nom-prog-upc-mg97) ("ExecDesNok",
                                            "Container",
                                            {&WINDOW-NAME}:HANDLE,
                                            FRAME f-pg-sel:HANDLE,
                                            "",
                                            "") NO-ERROR.
        END. 
        IF VALID-HANDLE(h-bocx402) THEN 
            DELETE PROCEDURE h-bocx402.
        RUN cxbo/bocx402.p PERSISTENT SET h-bocx402.

        CASE i-tp-nacionaliz:
            WHEN 1 /*---[ EMBARQUE ]---*/ THEN DO:
                ASSIGN INPUT FRAME f-embarq cembarque
                       INPUT FRAME f-embarq ccod-estabel.
                RUN verificaRelacionamentos IN h-bocx402 (INPUT cembarque, INPUT ccod-estabel, OUTPUT vnum-di-siscomex, OUTPUT l-encontrou, OUTPUT vdat-di, OUTPUT vnat-operacao).

                IF  l-encontrou THEN DO:
                    /* Como existe DI relacionada ao embarque, ent∆o a l¢gica segue a linha do Tipo de Nacionalizaá∆o DI (tipo 2)*/
                    IF NOT VALID-HANDLE(h-bocx220a) THEN RUN cxbo/bocx220a.p PERSISTENT SET h-bocx220a.
                    RUN pi-recebe-tp-nacionaliz IN h-bocx220a (INPUT 2).

                    RUN verificaCalculosDI IN h-bocx402 (INPUT vnum-di-siscomex, OUTPUT llog-situacao, OUTPUT ccalculo-faltante). 
                    
                    IF  NOT llog-situacao THEN DO:
                        RUN utp/ut-msgs.p (INPUT 'show', INPUT 52260, INPUT string(vnum-di-siscomex) + '~~' + ccalculo-faltante).
                        RETURN NO-APPLY.
                    END. /* IF  NOT llog-situacao */
                END. /* IF  l-encontrou */

                assign input frame f-embarq
                       cembarque
                       cnr-docto
                       cserie
                       cnatureza
                       ccod-estabel
                       ccod-decl-imp
                       ddata-di
                       ddata-cotacao
                       ccod-emitente
                       ddata-trans
                       ddata-emissao 
                       ddata-vencto-ipi
                       ddata-vencto-icms 
                       ccod-estabel-fisc 
                       cconta-trans
                       cccusto-trans
                       cdesc-tot
                       licms-diferido
                       editor-2.
                
                RUN pi-executar.
            END. /* WHEN 1 */
            WHEN 2 /*---[ DECLARAÄ«O DE IMPORTAÄ«O ]---*/ OR 
            WHEN 3 /*---[ Declaraá∆o Ènica de Importaá∆o - DUIMP ]---*/ THEN DO:
                ASSIGN INPUT FRAME f-decl-imp 
                                   ccod-decl-imp-1 
                                   ccod-estabel-1 
                                   ddata-cotacao-1 
                                   ddata-di-1.

                RUN verificaCalculosDI IN h-bocx402 (INPUT ccod-decl-imp-1, OUTPUT llog-situacao, OUTPUT ccalculo-faltante). 
                IF  NOT llog-situacao THEN DO:
                    RUN utp/ut-msgs.p (INPUT 'show', INPUT 52260, INPUT ccod-decl-imp-1 + '~~' + ccalculo-faltante).
                    RETURN NO-APPLY.
                END. /* IF  NOT llog-situacao */
                
                ASSIGN ccod-estabel      = ccod-estabel-1
                       ddata-di          = ddata-di-1
                       ddata-cotacao     = ddata-cotacao-1.
                
                IF  AVAIL  param-imp THEN 
                    ASSIGN c-conta-transit-import = param-imp.ct-transit-import.
                
                IF NOT VALID-HANDLE(h-bocx220a) THEN RUN cxbo/bocx220a.p PERSISTENT SET h-bocx220a.
                RUN pi-recebe-tp-nacionaliz IN h-bocx220a (INPUT i-tp-nacionaliz).
                
                /*no bot∆o conferencia s¢ precisa ler o primeiro embarque para gerar o relatorio*/
                FOR FIRST  tt-embarqueDI
                    WHERE  tt-embarqueDI.log-marcado: 
                    ASSIGN cembarque         = tt-embarqueDI.cod-embarq
                           cnr-docto         = tt-embarqueDI.nro-docto
                           cserie            = tt-embarqueDI.serie-docto
                           cnatureza         = tt-embarqueDI.nat-operacao
                           ccod-emitente     = tt-embarqueDI.cod-emitente
                           ccod-decl-imp     = string(tt-embarqueDI.num-di-ems)
                           ddata-trans       = tt-embarqueDI.dt-trans
                           ddata-emissao     = tt-embarqueDI.dt-emissao
                           ddata-vencto-ipi  = tt-embarqueDI.dt-venc-ipi
                           ddata-vencto-icms = tt-embarqueDI.dt-venc-icm
                           ccod-estabel-fisc = tt-embarqueDI.cod-estab-fiscal
                           cconta-trans      = tt-embarqueDI.ct-transit
                           cccusto-trans     = tt-embarqueDI.sc-transit
                           licms-diferido    = tt-embarqueDI.aliquota-icm
                           editor-2          = tt-embarqueDI.observacao.
                    RUN pi-executar.
                END.  /* FOR EACH  tt-embarqueDI */
            END. /* WHEN 2 ou 3*/
        END CASE. /* CASE i-tp-nacionaliz: */

        FOR EACH tt-parametros EXCLUSIVE-LOCK: 
            DELETE tt-parametros. 
        END. /* FOR EACH tt-parametros */

        IF  CAN-FIND(FIRST RowErrors 
                     WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:

            IF  CAN-FIND(FIRST RowErrors 
                         WHERE RowErrors.ErrorNumber = 29560)THEN 
                UNDO,LEAVE.

            {method/showmessage.i1}
            {method/showmessage.i2 &Modal=YES}
        END.               

        undo, leave.
    end. /* do  transaction: */
    IF VALID-HANDLE(h-bocx402) THEN DO:
        DELETE PROCEDURE h-bocx402.
        ASSIGN h-bocx402 = ?.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btimpostos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btimpostos w-relat
ON CHOOSE OF btimpostos IN FRAME f-relat /* Impostos */
DO:
    CASE i-tp-nacionaliz:
        WHEN 1 /* Embarque */ THEN DO:
            run pi-valida-chamada-prog.

            IF return-value <> "OK" 
            THEN apply "entry" to cembarque in frame f-embarq.
            ELSE DO:
                run imp/im0100d.w (input ccod-estabel,
                                   input cembarque,
                                   input c-seg-usuario,
                                   input cnatureza,
                                   input licms-diferido,
                                   INPUT i-tp-nacionaliz,
                                   INPUT "").
            END. /* ELSE DO: */
        END. /* WHEN 1 */
        WHEN 2 /* DI */ OR 
        WHEN 3 /* DUIMP */ THEN DO:
            ASSIGN INPUT FRAME f-decl-imp ccod-decl-imp-1 ccod-estabel-1 ddata-cotacao-1 ddata-di-1.

            IF  CAN-FIND(FIRST tt-embarqueDI) THEN
            FOR FIRST tt-embarqueDI:
                ASSIGN ccod-estabel    = tt-embarqueDI.cod-estab
                       cembarque       = tt-embarqueDI.cod-embarq
                       cnatureza       = tt-embarqueDI.nat-operacao
                       licms-diferido  = tt-embarqueDI.aliquota-icm.
            END. /* FOR FIRST tt-embarqueDI: */
            
            run imp/im0100d.w (input ccod-estabel,
                               input cembarque,
                               input c-seg-usuario,
                               input cnatureza,
                               input licms-diferido,
                               INPUT i-tp-nacionaliz,
                               INPUT ccod-decl-imp-1).
        END. /* WHEN 2 ou 3 */
    END CASE. /* CASE i-tp-nacionaliz: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btpesoscubagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btpesoscubagem w-relat
ON CHOOSE OF btpesoscubagem IN FRAME f-relat /* Pesos e Cubagem */
DO:
    CASE i-tp-nacionaliz:
        WHEN 1 /* Embarque */ THEN DO:
            run pi-valida-chamada-prog.
        
            IF return-value <> "OK" 
            THEN apply "entry" to cembarque in frame f-embarq.
            ELSE DO:
                run imp/im0100c.w (input ccod-estabel,
                                   input cembarque,
                                   input c-seg-usuario,
                                   input cnatureza,
                                   input licms-diferido).
            END. /* ELSE DO: */
        END. /* WHEN 1 */
        WHEN 2 /* DI */ OR 
        WHEN 3 /* DUIMP */ THEN DO:
            ASSIGN INPUT FRAME f-decl-imp ccod-decl-imp-1 ccod-estabel-1 ddata-cotacao-1 ddata-di-1.

            IF  CAN-FIND(FIRST tt-embarqueDI) THEN
            FOR FIRST tt-embarqueDI:
                ASSIGN ccod-estabel    = tt-embarqueDI.cod-estab
                       cembarque       = tt-embarqueDI.cod-embarq
                       cnatureza       = tt-embarqueDI.nat-operacao
                       licms-diferido  = tt-embarqueDI.aliquota-icm.
            END. /* FOR FIRST tt-embarqueDI: */
        
            run imp/im0100c.w (input ccod-estabel,
                               input cembarque,
                               input c-seg-usuario,
                               input cnatureza,
                               input licms-diferido).
                               /*
                               ,
                               INPUT i-tp-nacionaliz,
                               INPUT ccod-decl-imp-1).
                               */
        END. /* WHEN 2 ou 3 */
    END CASE. /* CASE i-tp-nacionaliz: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-cla
&Scoped-define SELF-NAME c-ccusto-aplic-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplic-nf w-relat
ON ENTRY OF c-ccusto-aplic-nf IN FRAME f-pg-cla /* CCusto Aplicaá∆o NF Simples Remessa */
DO:
    ASSIGN c-ccusto-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplic-nf w-relat
ON F5 OF c-ccusto-aplic-nf IN FRAME f-pg-cla /* CCusto Aplicaá∆o NF Simples Remessa */
DO:
   ASSIGN c-ccusto-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)"
          c-cta-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)" .
    
   run pi_zoom_ccusto_x_cta_ctbl in h_api_ccust (input              i-empresa,                      /* EMPRESA EMS2 */
                                                 input INPUT FRAME  f-embarq ccod-estabel,          /* ESTABELECIMENTO EMS2 */
                                                 input              yes,                            /* TODOS ESTABELECIMENTOS ? */
                                                 input              "",                             /* UNIDADE DE NEGOCIO */
                                                 input              "",                             /* PLANO CONTAS */
                                                 input              c-cta-aplic-nf:SCREEN-VALUE,    /* CONTA */
                                                 input              "",                             /* CODIGO DO PLANO CCUSTO */
                                                 input INPUT FRAME  f-embarq ddata-trans,           /* DATA DE TRANSACAO */
                                                 output             v_cod_ccusto,                   /* CODIGO CCUSTO */
                                                 output             v_des_ccusto,                   /* DESCRICAO CCUSTO */
                                                 output table       tt_log_erro).                   /* ERROS */


   
   IF RETURN-VALUE  = "OK" THEN
        ASSIGN c-ccusto-aplic-nf = v_cod_ccusto
               c-ccusto-aplic-nf:SCREEN-VALUE = v_cod_ccusto
               desc-ccusto-aplic-nf:SCREEN-VALUE = v_des_ccusto.

    IF p_cod_format_cta_ctbl <> "" then
        ASSIGN c-cta-aplic-nf:FORMAT IN FRAME f-pg-cla = p_cod_format_cta_ctbl.                    
                           
   DISP c-ccusto-aplic-nf desc-ccusto-aplic-nf WITH FRAME f-pg-cla.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplic-nf w-relat
ON LEAVE OF c-ccusto-aplic-nf IN FRAME f-pg-cla /* CCusto Aplicaá∆o NF Simples Remessa */
DO:    
    ASSIGN c-ccusto-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)".
    ASSIGN c-ccusto-aplic-nf = c-ccusto-aplic-nf:SCREEN-VALUE.
    
    IF c-ccusto-aplic-nf <> ""  THEN DO:
        run pi_busca_dados_ccusto in h_api_ccust (input             i-empresa,                           /* EMPRESA EMS2 */
                                                  input             "",                                  /* CODIGO DO PLANO CCUSTO */
                                                  input             c-ccusto-aplic-nf,                   /* CCUSTO */
                                                  INPUT INPUT FRAME f-embarq ddata-trans,                /* DATA DE TRANSACAO */
                                                  output            v_des_ccusto,                        /* DESCRICAO DO CCUSTO */
                                                  output table      tt_log_erro).                        /* ERROS */ 
        IF RETURN-VALUE = "OK" THEN do:
            IF  p_cod_format_ccusto <> ""  THEN
                ASSIGN c-ccusto-aplic-nf:FORMAT IN FRAME f-pg-cla = p_cod_format_ccusto.
            ASSIGN desc-ccusto-aplic-nf:SCREEN-VALUE = v_des_ccusto. 
        END.
        ELSE DO:
            
            ASSIGN c-ccusto-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)".
            ASSIGN desc-ccusto-aplic-nf:SCREEN-VALUE = "".
        END.
    END.
    ELSE DO:
        ASSIGN desc-ccusto-aplic-nf:SCREEN-VALUE = "".
        
    END.
     
    
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplic-nf w-relat
ON MOUSE-SELECT-DBLCLICK OF c-ccusto-aplic-nf IN FRAME f-pg-cla /* CCusto Aplicaá∆o NF Simples Remessa */
DO:
    APPLY "f5":U TO SELF IN FRAME f-pg-cla.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cta-aplic-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cta-aplic-nf w-relat
ON ENTRY OF c-cta-aplic-nf IN FRAME f-pg-cla /* Conta Aplicaá∆o NF Simples Remessa */
DO:
    ASSIGN c-cta-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)"
           c-ccusto-aplic-nf:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cta-aplic-nf w-relat
ON F5 OF c-cta-aplic-nf IN FRAME f-pg-cla /* Conta Aplicaá∆o NF Simples Remessa */
DO:
    ASSIGN c-cta-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)":U.
    run pi_zoom_cta_ctbl_integr in h_api_cta (input                 i-empresa,              /* EMPRESA EMS2 */
                                              input                 "CEP",                  /* MÖDULO */         
                                              input                 "",                     /* PLANO DE CONTAS */
                                              input                 "(nenhum)",             /* FINALIDADES */ 
                                              input  INPUT FRAME    f-embarq ddata-trans,   /* DATA TRANSACAO */ 
                                              output                v_cod_cta_ctbl,         /* CODIGO CONTA */   
                                              output                v_des_cta_ctbl,         /* DESCRICAO CONTA */
                                              output                v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table          tt_log_erro).           /* ERROS */ 
   
    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN c-cta-aplic-nf = v_cod_cta_ctbl
               c-cta-aplic-nf:SCREEN-VALUE = v_cod_cta_ctbl
               desc-cta-aplic-nf = v_des_cta_ctbl
               desc-cta-aplic-nf:SCREEN-VALUE = v_des_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cta-aplic-nf w-relat
ON LEAVE OF c-cta-aplic-nf IN FRAME f-pg-cla /* Conta Aplicaá∆o NF Simples Remessa */
DO:
    ASSIGN c-cta-aplic-nf:FORMAT IN FRAME f-pg-cla = "x(20)"
           v_cod_cta_ctbl = c-cta-aplic-nf:SCREEN-VALUE.

     run pi_busca_dados_cta_ctbl in h_api_cta (INPUT                i-empresa,                                      /* EMPRESA EMS2 */
                                               INPUT                "",                                             /* PLANO DE CONTAS */
                                               INPUT-OUTPUT         v_cod_cta_ctbl,                                 /* CONTA */
                                               INPUT INPUT FRAME    f-embarq ddata-trans,                           /* DATA TRANSACAO */   
                                               OUTPUT               v_des_cta_ctbl,                                 /* DESCRICAO CONTA */
                                               OUTPUT               v_num_tip_cta_ctbl,                             /* TIPO DA CONTA */
                                               OUTPUT               v_num_sit_cta_ctbl,                             /* SITUAÄ«O DA CONTA */
                                               OUTPUT               v_ind_finalid_cta,                              /* FINALIDADES DA CONTA */
                                               OUTPUT TABLE         tt_log_erro).                                   /* ERROS */     
  
      IF RETURN-VALUE = "OK" THEN DO:
         ASSIGN c-cta-aplic-nf:SCREEN-VALUE = v_cod_cta_ctbl
                             c-cta-aplic-nf = v_cod_cta_ctbl
                          desc-cta-aplic-nf = v_des_cta_ctbl.
         IF p_cod_format_cta_ctbl <> "" THEN 
             ASSIGN c-cta-aplic-nf:FORMAT IN FRAME f-pg-cla = p_cod_format_cta_ctbl.
         ELSE
             ASSIGN c-cta-aplic-nf:FORMAT IN FRAME f-pg-cla = "X(20)":U.
     END.
     ELSE
       
    
     ASSIGN c-cta-aplic-nf    = v_cod_cta_ctbl
            desc-cta-aplic-nf = v_des_cta_ctbl.
     

     IF c-cta-aplic-nf:SENSITIVE <> NO THEN DO:
         run pi_verifica_utilizacao_ccusto in h_api_ccust (input i-empresa,                 /* EMPRESA EMS 2 */
                                                           input INPUT FRAME f-embarq ccod-estabel,                 /* ESTABELECIMENTO EMS2 */
                                                           input "",             /* PLANO CONTAS */
                                                           input c-cta-aplic-nf,          /* CONTA */
                                                           input  today,              /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro). /* ERROS */
         IF NOT AVAIL tt_log_erro THEN DO:             
             IF v_log_utz_ccusto = "NO" THEN
                 ASSIGN c-ccusto-aplic-nf:SENSITIVE = NO
                        c-ccusto-aplic-nf:SCREEN-VALUE = ""
                        c-ccusto-aplic-nf = ""
                        desc-ccusto-aplic-nf:SCREEN-VALUE = ""
                        desc-ccusto-aplic-nf = "".
             ELSE
                 ASSIGN c-ccusto-aplic-nf:SENSITIVE = YES.
         END.
     END.
     disp c-cta-aplic-nf desc-cta-aplic-nf with frame f-pg-cla.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cta-aplic-nf w-relat
ON MOUSE-SELECT-DBLCLICK OF c-cta-aplic-nf IN FRAME f-pg-cla /* Conta Aplicaá∆o NF Simples Remessa */
DO:
    APPLY "f5":U TO SELF IN FRAME f-pg-cla.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&Scoped-define FRAME-NAME f-decl-imp
&Scoped-define SELF-NAME ccod-decl-imp-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-decl-imp-1 w-relat
ON ENTRY OF ccod-decl-imp-1 IN FRAME f-decl-imp /* DI Siscomex */
DO:
    /*RUN pi-verifica-nota-simples-remessa.  */

    IF i-tp-nacionaliz = 2  
    OR i-tp-nacionaliz = 3 THEN
        DISABLE btpesoscubagem WITH FRAME f-relat.
    ELSE
        ENABLE btpesoscubagem WITH FRAME f-relat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-decl-imp-1 w-relat
ON F5 OF ccod-decl-imp-1 IN FRAME f-decl-imp /* DI Siscomex */
DO:
    {method/zoomfields.i &ProgramZoom  = "cxzoom/z02cx400.w"
                         &FieldZoom1   = "cod-di-siscomex"
                         &FieldScreen1 = "ccod-decl-imp-1"
                         &Frame1       = "f-decl-imp"
                         &FieldZoom2   = "cod-estab"
                         &FieldScreen2 = "ccod-estabel-1"
                         &Frame2       = "f-decl-imp"
                         &FieldZoom3   = "dat-di"
                         &FieldScreen3 = "ddata-di-1"
                         &Frame3       = "f-decl-imp"
                         &FieldZoom4   = "dat-di"
                         &FieldScreen4 = "ddata-cotacao-1"
                         &Frame4       = "f-decl-imp"
                         &FieldZoom5   = "num-di-ems"
                         &FieldScreen5 = "icod-di-ems"
                         &Frame5       = "f-decl-imp"
                         &EnableImplant="NO"
                         &RunMethod    = "RUN setaTpNacionaliz IN hProgramZoom (input i-tp-nacionaliz)."} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-decl-imp-1 w-relat
ON LEAVE OF ccod-decl-imp-1 IN FRAME f-decl-imp /* DI Siscomex */
DO:
    IF  VALID-HANDLE(h-bocx383) THEN DELETE PROCEDURE h-bocx383.
    RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.
    RUN openQueryStatic IN h-bocx383 (INPUT "Main":U) NO-ERROR.

    IF c-di-old <> "" 
        AND (c-di-old <> INPUT FRAME f-decl-imp ccod-decl-imp-1) THEN
        ASSIGN l-alterou-di = YES.

    RUN pi-seta-tp-nacionaliz IN h-bocx383 (INPUT i-tp-nacionaliz).
    RUN goToKeyByDiDuimp IN h-bocx383 (INPUT INPUT FRAME f-decl-imp ccod-decl-imp-1).
    IF  RETURN-VALUE = "OK" THEN DO:
        RUN getCharField IN h-bocx383(INPUT "cod-estab":U, OUTPUT c-retorno).  
        ASSIGN ccod-estabel-1:SCREEN-VALUE IN FRAME f-decl-imp = c-retorno.

        RUN getDateField IN h-bocx383(INPUT "dat-di":U, OUTPUT c-retorno).
        ASSIGN ddata-di-1:SCREEN-VALUE IN FRAME f-decl-imp = c-retorno.

        RUN getDateField IN h-bocx383(INPUT "dat-di":U, OUTPUT c-retorno). 
        ASSIGN ddata-cotacao-1:SCREEN-VALUE IN FRAME f-decl-imp = c-retorno.

        RUN getIntField IN h-bocx383(INPUT "num-di-ems":U, OUTPUT c-retorno). 
        ASSIGN icod-di-ems:SCREEN-VALUE IN FRAME f-decl-imp = c-retorno.

    END. /* IF  RETURN-VALUE */

    RUN pi-carregaTT. /* Carregar temp-table dos embarques relacionados a Declaraá∆o de Importaá∆o */

    IF CAN-FIND(FIRST tt-embarqueDI)
    THEN ASSIGN btconferencia:SENSITIVE  IN FRAME f-relat = YES 
                btimpostos:SENSITIVE     IN FRAME f-relat = YES.

    IF VALID-HANDLE(h-bocx383) THEN DO:
        DELETE PROCEDURE h-bocx383.
        ASSIGN h-bocx383 = ?.
    END.

    ASSIGN c-di-old = INPUT FRAME f-decl-imp ccod-decl-imp-1. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-decl-imp-1 w-relat
ON MOUSE-SELECT-DBLCLICK OF ccod-decl-imp-1 IN FRAME f-decl-imp /* DI Siscomex */
DO:
    APPLY 'F5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-embarq
&Scoped-define SELF-NAME ccod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-emitente w-relat
ON F5 OF ccod-emitente IN FRAME f-embarq /* Emitente */
DO:
    {method/ZoomFields.i
     &ProgramZoom="adzoom/z13ad098.w"
     &FieldZoom1="cod-emitente"
     &FieldScreen1="ccod-emitente"
     &Frame1="f-embarq"
     &EnableImplant="no"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-emitente w-relat
ON MOUSE-SELECT-DBLCLICK OF ccod-emitente IN FRAME f-embarq /* Emitente */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ccod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel w-relat
ON F5 OF ccod-estabel IN FRAME f-embarq /* Estab */
DO:
    &if defined(bf-mat-comex) &then
        {method/ZoomFields.i
         &ProgramZoom="adzoom/z10ad107.w"
         &FieldZoom1="cod-estabel"
         &FieldScreen1="ccod-estabel"
         &Frame1="f-embarq"
         &EnableImplant="no"} 
    &else
        {method/ZoomFields.i
         &ProgramZoom="adzoom/z10ad107.w"
         &FieldZoom1="cod-estabel"
         &FieldScreen1="ccod-estabel"
         &Frame1="f-embarq"}
    &endif     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel w-relat
ON LEAVE OF ccod-estabel IN FRAME f-embarq /* Estab */
DO:
    RUN pi-leave-ccod-estabel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel w-relat
ON MOUSE-SELECT-DBLCLICK OF ccod-estabel IN FRAME f-embarq /* Estab */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-decl-imp
&Scoped-define SELF-NAME ccod-estabel-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel-1 w-relat
ON LEAVE OF ccod-estabel-1 IN FRAME f-decl-imp /* Estabelecimento */
DO:

    RUN pi-retorna-empresa.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-embarq
&Scoped-define SELF-NAME ccod-estabel-fisc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel-fisc w-relat
ON F5 OF ccod-estabel-fisc IN FRAME f-embarq /* Estab */
DO:
    &if defined(bf-mat-comex) &then
        {method/ZoomFields.i
         &ProgramZoom="adzoom/z10ad107.w"
         &FieldZoom1="cod-estabel"
         &FieldScreen1="ccod-estabel-fisc"
         &Frame1="f-embarq"
         &EnableImplant="no"}
    &else
        {method/ZoomFields.i
         &ProgramZoom="adzoom/z10ad107.w"
         &FieldZoom1="cod-estabel"
         &FieldScreen1="ccod-estabel-fisc"
         &Frame1="f-embarq"}
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ccod-estabel-fisc w-relat
ON MOUSE-SELECT-DBLCLICK OF ccod-estabel-fisc IN FRAME f-embarq /* Estab */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cconta-trans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cconta-trans w-relat
ON ENTRY OF cconta-trans IN FRAME f-embarq /* Conta Transit¢ria */
DO:
  ASSIGN cconta-trans:FORMAT IN FRAME f-embarq = "X(20)"
         cccusto-trans:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cconta-trans w-relat
ON F5 OF cconta-trans IN FRAME f-embarq /* Conta Transit¢ria */
DO:
    &if defined(bf-mat-comex) &then
        assign l-implanta = no.
    &else
        assign l-implanta = yes.
    &endif                   

    run pi_zoom_cta_ctbl_integr in h_api_cta (input                 i-empresa,              /* EMPRESA EMS2 */
                                              input                 "CEP",                  /* MÖDULO */
                                              input                 "",                     /* PLANO DE CONTAS */
                                              input                 "(nenhum)",             /* FINALIDADES */
                                              input  INPUT FRAME    f-embarq ddata-trans,   /* DATA TRANSACAO */
                                              output                v_cod_cta_ctbl,         /* CODIGO CONTA */
                                              output                v_des_cta_ctbl,         /* DESCRICAO CONTA */
                                              output                v_ind_finalid_cta,      /* FINALIDADE DA CONTA */
                                              output table          tt_log_erro).           /* ERROS */ 
    IF v_cod_cta_ctbl <> "" THEN DO:
        ASSIGN cconta-trans = v_cod_cta_ctbl
               cconta-trans:SCREEN-VALUE = v_cod_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cconta-trans w-relat
ON LEAVE OF cconta-trans IN FRAME f-embarq /* Conta Transit¢ria */
DO:
    ASSIGN cccusto-trans:SENSITIVE = YES.
    ASSIGN cconta-trans:FORMAT = "x(20)"
           v_cod_cta_ctbl = cconta-trans:SCREEN-VALUE.
  
    IF v_cod_cta_ctbl <> "" THEN DO:
  
        run pi_busca_dados_cta_ctbl in h_api_cta (INPUT               i-empresa,                                      /* EMPRESA EMS2 */
                                                  INPUT               "",                                             /* PLANO DE CONTAS */
                                                  INPUT-OUTPUT        v_cod_cta_ctbl,                                 /* CONTA */
                                                  INPUT INPUT FRAME   f-embarq ddata-trans,                           /* DATA TRANSACAO */   
                                                  OUTPUT              v_des_cta_ctbl,                                 /* DESCRICAO CONTA */
                                                  OUTPUT              v_num_tip_cta_ctbl,                             /* TIPO DA CONTA */
                                                  OUTPUT              v_num_sit_cta_ctbl,                             /* SITUAÄ«O DA CONTA */
                                                  OUTPUT              v_ind_finalid_cta,                              /* FINALIDADES DA CONTA */
                                                  OUTPUT TABLE        tt_log_erro).                                   /* ERROS */     
        IF RETURN-VALUE ="OK" THEN DO:
            ASSIGN cconta-trans:SCREEN-VALUE = v_cod_cta_ctbl
                   cconta-trans = v_cod_cta_ctbl.
            IF p_cod_format_cta_ctbl <> "" THEN DO:
            
                ASSIGN cconta-trans:FORMAT = p_cod_format_cta_ctbl.
                ASSIGN cccusto-trans:FORMAT IN FRAME f-embarq = p_cod_format_ccusto.
                  
            END.
            ELSE 
                ASSIGN  cconta-trans:FORMAT = "X(20)":U.
        END.
        ELSE DO: 
            
            ASSIGN cccusto-trans:SENSITIVE = NO
                   cccusto-trans:SCREEN-VALUE = ""
                   cccusto-trans = "".
           
        END.
    END.
   
    IF cccusto-trans:SENSITIVE <> NO THEN DO:
        run pi_verifica_utilizacao_ccusto in h_api_ccust (input i-empresa,                 /* EMPRESA EMS 2 */
                                                          input INPUT FRAME f-embarq ccod-estabel,                 /* ESTABELECIMENTO EMS2 */
                                                          input "",             /* PLANO CONTAS */
                                                          input v_cod_cta_ctbl,          /* CONTA */
                                                          input  INPUT FRAME  f-embarq ddata-trans,              /* DT TRANSACAO */
                                                          output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                          output table tt_log_erro). /* ERROS */
        IF NOT AVAIL tt_log_erro THEN DO:  
            IF v_log_utz_ccusto = "NO" THEN DO:
                ASSIGN cccusto-trans:SENSITIVE = NO
                       cccusto-trans:SCREEN-VALUE = ""
                       cccusto-trans = "".
               
            END.        
            ELSE
                ASSIGN cccusto-trans:SENSITIVE = YES.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cconta-trans w-relat
ON MOUSE-SELECT-DBLCLICK OF cconta-trans IN FRAME f-embarq /* Conta Transit¢ria */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cembarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cembarque w-relat
ON ENTRY OF cembarque IN FRAME f-embarq /* Embarque */
DO:

  RUN pi-verifica-nota-simples-remessa.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cembarque w-relat
ON F5 OF cembarque IN FRAME f-embarq /* Embarque */
DO:
    {method/zoomfields.i 
     &ProgramZoom="cxzoom/z04cx220.w"
     &FieldZoom1="embarque"
     &FieldScreen1="cembarque"
     &Frame1="f-embarq"
     &FieldZoom2="cod-estabel"
     &FieldScreen2="ccod-estabel"
     &Frame2="f-embarq"
     &FieldZoom3="cod-emitente"
     &FieldScreen3="ccod-emitente"
     &Frame3="f-embarq"
     &FieldZoom4="cod-estab-fisc"
     &FieldScreen4="ccod-estabel-fisc"
     &Frame4="f-embarq"
     &FieldZoom5="ct-transit-import"
     &FieldScreen5="cconta-trans"
     &Frame5="f-embarq"
     &FieldZoom6="sc-transit-import"
     &FieldScreen6="cccusto-trans"
     &Frame6="f-embarq"
     &FieldZoom7="declaracao-import"
     &FieldScreen7="ccod-decl-imp"
     &Frame7="f-embarq"
     &FieldZoom8="data-di"
     &FieldScreen8="ddata-di"
     &Frame8="f-embarq"
     &EnableImplant="no"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cembarque w-relat
ON LEAVE OF cembarque IN FRAME f-embarq /* Embarque */
DO:
    RUN pi-leave-cembarque.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cembarque w-relat
ON MOUSE-SELECT-DBLCLICK OF cembarque IN FRAME f-embarq /* Embarque */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cnatureza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cnatureza w-relat
ON F5 OF cnatureza IN FRAME f-embarq /* Natureza Operaá∆o */
DO:
    &if defined(bf-mat-comex) &then
        assign l-implanta = no.
    &else
        assign l-implanta = yes.
    &endif

      {include/zoomvar.i &prog-zoom="inzoom/z01in245.w"
                   &campo="cnatureza"
                   &campozoom="nat-operacao"
                   &frame="f-embarq"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cnatureza w-relat
ON MOUSE-SELECT-DBLCLICK OF cnatureza IN FRAME f-embarq /* Natureza Operaá∆o */
DO:  
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cnr-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cnr-docto w-relat
ON LEAVE OF cnr-docto IN FRAME f-embarq /* Nro Docto */
DO:
  &IF defined(bf_nr_nota) &THEN
       IF  cnr-docto:SCREEN-VALUE IN FRAME f-embarq <> "0"
       AND cnr-docto:SCREEN-VALUE IN FRAME f-embarq <> "" THEN DO:

           if length(left-trim(string(input frame f-embarq cnr-docto, c-formato-nf))) > length(c-formato-nf) then do:
              run utp/ut-msgs.p (input "show":U, 
                                 input 36151, 
                                 input length(c-formato-nf)).

                apply "entry":U to cnr-docto in frame f-embarq.
                return "NOK":U.
            end. 

            assign cnr-docto:screen-value in frame f-embarq = left-trim(string(dec(input frame f-embarq cnr-docto),c-formato-nf)).
       END.
    &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cserie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cserie w-relat
ON F5 OF cserie IN FRAME f-embarq /* SÇrie */
DO:
    &if defined(bf-mat-comex) &then
        {method/zoomfields.i 
         &ProgramZoom="inzoom/z10in407.w"
         &FieldZoom1="serie"
         &FieldScreen1="cserie"
         &Frame1="f-embarq"
         &EnableImplant="no"}
    &else
        assign l-implanta = yes.    
        {include/zoomvar.i &prog-zoom="inzoom/z01in407.w"
                       &campo="cserie"
                       &campozoom="serie"
                       &frame="f-embarq"}
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cserie w-relat
ON MOUSE-SELECT-DBLCLICK OF cserie IN FRAME f-embarq /* SÇrie */
DO:
  apply 'F5' to self in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ddata-trans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ddata-trans w-relat
ON LEAVE OF ddata-trans IN FRAME f-embarq /* Data Transaá∆o */
DO:
  RUN pi-retorna-formato.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-cla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-cla w-relat
ON MOUSE-SELECT-CLICK OF im-pg-cla IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel w-relat
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-cla
&Scoped-define SELF-NAME l-nf-simples-remessa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-nf-simples-remessa w-relat
ON VALUE-CHANGED OF l-nf-simples-remessa IN FRAME f-pg-cla /* Nota Fiscal Simples Remessa */
DO:
    assign rs-classif-nf = 1.
    disp rs-classif-nf with frame f-pg-cla.
    assign l-nf-ajuste:screen-value in frame f-pg-cla = "no":U.

    if  input l-nf-simples-remessa then do:
        enable  rs-classif-nf with frame f-pg-cla.
        if i-tp-nacionaliz = 1 then  
           disable l-nf-ajuste with frame f-pg-cla.          
    end.
    else do:
        disable rs-classif-nf c-cta-aplic-nf l-gera-prim-remes-nf-mae with frame f-pg-cla.
        if i-tp-nacionaliz = 1 then 
           enable l-nf-ajuste with frame f-pg-cla.
    end.

    ASSIGN l-carrega-embarques = YES. 

    apply "VALUE-CHANGED":U to rs-classif-nf in frame f-pg-cla.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-classif-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-classif-nf w-relat
ON VALUE-CHANGED OF rs-classif-nf IN FRAME f-pg-cla
DO:
    assign c-cta-aplic-nf:screen-value in frame f-pg-cla = ''
           c-cta-aplic-nf = ''
           desc-cta-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla = ''
           desc-cta-aplic-nf = ''
           c-ccusto-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla = ''
           c-ccusto-aplic-nf = ''
           desc-ccusto-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla = ''
           desc-ccusto-aplic-nf = ''
           l-carrega-embarques = YES. 

    if  rs-classif-nf:sensitive then do:
        enable c-cta-aplic-nf with frame f-pg-cla.
        enable c-ccusto-aplic-nf with frame f-pg-cla.

        find first param-imp no-lock
             where param-imp.cod-estabel = IF i-tp-nacionaliz = 1 THEN input frame f-embarq ccod-estabel ELSE input frame f-decl-imp ccod-estabel-1 no-error.
        if  avail param-imp then do:
            assign c-cta-aplic-nf:screen-value    in frame f-pg-cla = param-imp.cod-cta-aplic-nf-simples-remes
                   c-ccusto-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla = param-imp.cod-subconta-nf-simples-remes
                   c-conta-transit-import                           = param-imp.ct-transit-import
                   c-ccusto-transit-import                          = param-imp.sc-transit-import
                   l-gera-remessa-mae                               = IF trim(substring(param-imp.char-1,169,1)) = "S":U THEN YES ELSE NO.
        end.
        ELSE
            ASSIGN l-gera-remessa-mae = NO.
        if  input rs-classif-nf = 2 then do:
            assign cconta-trans:screen-value in frame f-embarq = c-cta-aplic-nf:screen-value in frame f-pg-cla
                   cccusto-trans:SCREEN-VALUE IN FRAME f-embarq = c-ccusto-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla
                   l-gera-prim-remes-nf-mae:CHECKED IN FRAME f-pg-cla = NO.
            disable c-cta-aplic-nf c-ccusto-aplic-nf l-gera-prim-remes-nf-mae with frame f-pg-cla.
        end.
        ELSE DO:
            ASSIGN cconta-trans:SCREEN-VALUE IN FRAME f-embarq = c-conta-transit-import
                   cccusto-trans:SCREEN-VALUE IN FRAM f-embarq = c-ccusto-transit-import
                   l-gera-prim-remes-nf-mae:SENSITIVE IN FRAME f-pg-cla = YES
                   l-gera-prim-remes-nf-mae:CHECKED   IN FRAME f-pg-cla = l-gera-remessa-mae.
        END.
    end.
    ELSE
        ASSIGN cconta-trans:SCREEN-VALUE IN FRAME f-embarq = c-conta-transit-import
               cccusto-trans:SCREEN-VALUE IN FRAME f-embarq = c-ccusto-transit-import
               l-gera-prim-remes-nf-mae:CHECKED   IN FRAME f-pg-cla = NO
               l-gera-prim-remes-nf-mae:SENSITIVE IN FRAME f-pg-cla = NO.
   /*
   ** Variavel "rs-classif-nf-aux" utilizada na trigger "on leave of cembarque"
   */
    ASSIGN rs-classif-nf-aux = rs-classif-nf.

    /*apply "LEAVE":U to c-cta-aplic-nf in frame f-pg-cla.  */ 
    APPLY "LEAVE":U TO cembarque IN FRAME f-embarq.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
RUN pi_aplica_facelift_thin IN h-facelift ( INPUT FRAME f-relat:handle ).
RUN pi_aplica_facelift_thin IN h-facelift ( INPUT FRAME f-pg-sel:handle ).
RUN pi_aplica_facelift_thin IN h-facelift ( INPUT FRAME f-pg-cla:handle ).
RUN pi_aplica_facelift_thin IN h-facelift ( INPUT FRAME f-embarq:handle ).
RUN pi_aplica_facelift_thin IN h-facelift ( INPUT FRAME f-decl-imp:handle ).
/* ******* Editado automaticamente para o projeto de facelift ******* */

{utp/ut9000.i "IM0100" "2.00.01.025"} /* 02/10/2026 17:42:36 */

APPLY 'mouse-select-click':U TO im-pg-sel IN FRAME f-relat.
/*
 do with frame f-relat:
    &IF "{&PGSEL}" <> "" &THEN
        if  im-pg-sel:load-image("image/im-fldup") then.
        assign im-pg-sel:height = 1.20
               im-pg-sel:row    = 1.50.
    &ENDIF
    &IF "{&PGCLA}" <> "" &THEN
        if  im-pg-cla:load-image("image/im-flddn") then.
        if  im-pg-cla:move-to-bottom() then.
        assign im-pg-cla:height = 1
               im-pg-cla:row    = 1.6.
    &ENDIF
end.
*/
/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.


/************************************************************************************/
/************************************************************************************/
/* Parte da include {include/i-rplbl.i} que faz a troca de folder no Smart - inicio */
/************************************************************************************/
/************************************************************************************/
def var c-list-folders   as char no-undo.
def var i-current-folder as int  no-undo.



/**********************************************************
** Troca de pˇgina por CTRL-TAB e SHIFT-CTRL-TAB
**********************************************************/
&if "{&PGSEL}" <> "" &then
    assign c-list-folders = c-list-folders + "im-pg-sel,":U.
&endif

&if "{&PGCLA}" <> "" &then
    assign c-list-folders = c-list-folders + "im-pg-cla,":U.
&endif

if  substring(c-list-folders, length(c-list-folders)) = "," then
    assign c-list-folders = substring(c-list-folders, 1, length(c-list-folders) - 1).

on  CTRL-TAB,SHIFT-CTRL-TAB anywhere do:
    def var h_handle  as handle no-undo.
    def var c_imagem  as char   no-undo.
    def var l_direita as log    no-undo.
    l_direita = last-event:label = 'CTRL-TAB':U.

    block1:
    repeat:
        if  l_direita then
            assign i-current-folder = if i-current-folder = num-entries(c-list-folders) then 1 else i-current-folder + 1.
        else
            assign i-current-folder = if i-current-folder = 1 then num-entries(c-list-folders) else i-current-folder - 1.

        assign c_imagem = entry(i-current-folder, c-list-folders)
               h_handle = frame f-relat:first-child
               h_handle = h_handle:first-child.

        do  while valid-handle(h_handle):
            if  h_handle:type = 'image':U and
                h_handle:name = c_imagem  then do:
                if  h_handle:sensitive = no then next block1.
                apply 'mouse-select-click':U to h_handle.
                leave block1.
            end.
            h_handle = h_handle:next-sibling.
        end.
    end.
end.

/**********************************************************
** Procedure de troca de pˇgina por CTRL-TAB
**********************************************************/
procedure pi-first-child:
{include/i-rpfch.i relDtv}
    /*
&IF "{&product_version}" >= "12.1.X.2307" &THEN
    
&ELSE
/* **** Editado automaticamente para o projeto de facelift **** */
    def input param wh-entry-folder as widget-handle.

    assign wh-entry-folder = wh-entry-folder:first-child
           wh-entry-folder = wh-entry-folder:first-child.

    do  while(valid-handle(wh-entry-folder)):
        if  wh-entry-folder:sensitive = yes       and
            wh-entry-folder:type <> 'rectangle':U and
            wh-entry-folder:type <> 'image':U     and
            wh-entry-folder:type <> 'browse':U    then do:
            apply 'entry':U to wh-entry-folder.
            leave.
        end.
        else
            assign wh-entry-folder = wh-entry-folder:next-sibling.
    end.
&ENDIF
*/
end.
/************************************************************************************/
/************************************************************************************/
/* Parte da include {include/i-rplbl.i} que faz a troca de folder no Smart - final  */
/************************************************************************************/
/************************************************************************************/

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    ccod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-embarq.
    cembarque:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-embarq.
    ccod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-embarq.
    cserie:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-embarq.
    cnatureza:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-embarq.
    ccod-estabel-fisc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-embarq.
    cconta-trans:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-embarq.
    cccusto-trans:LOAD-MOUSE-POINTER("IMAGE/lupa.cur":U) IN FRAME f-embarq.
    c-cta-aplic-nf:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-cla.
    c-ccusto-aplic-nf:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-pg-cla.
    ccod-decl-imp-1:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-decl-imp.

    RUN enable_UI.

    {imp/im0100b.i3 ERROR}

     {utp/ut-liter.i Estabelecimento * R}
     assign ccod-estabel:LABEL IN FRAME f-embarq = TRIM(RETURN-VALUE).

    {utp/ut-liter.i Estabelecimento_Fiscal * R}
     assign ccod-estabel-fisc:LABEL IN FRAME f-embarq = TRIM(RETURN-VALUE).


    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.


/* Ajuste do formato do campo conta de acordo com o produto - EMS ou Magnus */    

/*find first param-global no-lock no-error.*/
/*IF p_cod_format_cta_ctbl <> "" THEN
    assign cconta-trans:format in frame f-embarq = p_cod_format_cta_ctbl.
ELSE
    ASSIGN cconta-trans:FORMAT IN FRAME f-embarq = "X(20)".*/


/* inicializaá∆o dos valores de tela */
assign ddata-trans:screen-value in frame f-embarq       = string(today)
       ddata-emissao:screen-value in frame f-embarq     = string(today)
       ddata-vencto-ipi:screen-value in frame f-embarq  = string(today)
       ddata-vencto-icms:screen-value in frame f-embarq = string(today)
       ddata-di:screen-value in frame f-embarq          = string(today)
       ddata-cotacao:screen-value in frame f-embarq     = string(today)
       btimpostos:visible in frame f-relat              = true
       btpesoscubagem:visible in frame f-relat          = true.

IF NOT l-EMS2-IMP-MEXICO THEN
    ASSIGN btconferencia:HIDDEN   IN FRAME f-relat  = NO
           l-nota-fisc-fat:HIDDEN IN FRAME f-embarq = YES.
ELSE 
    ASSIGN btconferencia:HIDDEN   IN FRAME f-relat  = YES
           l-nota-fisc-fat:HIDDEN IN FRAME f-embarq = NO.

PROCEDURE WinExec  EXTERNAL  "kernel32.dll":
  DEF INPUT PARAM prg_name      AS CHARACTER.
  DEF INPUT PARAM prg_style     AS SHORT.
END PROCEDURE.

RUN pi-retorna-formato.

/* Inicialmente a tela carrega "Embarque" */
RUN setaTipoNacionaliz (INPUT 1).

/*---[ Verifica Tipo Nacionalizaá∆o: 1-Embarque 2-DI ]---*/
RUN pi-TipoInicial.
/*-------------------------------------------------------*/

IF  i-tp-nacionaliz = 0 /* clicou no bot∆o Cancelar, ent∆o fecha as telas ... */ THEN APPLY 'choose':U TO bt-cancelar IN FRAME f-relat.

IF  i-tp-nacionaliz = 2 /* DI */ 
OR  i-tp-nacionaliz = 3 /* DUIMP */ THEN DO:
    tt-embarqueDI.serie-docto:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brNota.
    tt-embarqueDI.cod-estab-fiscal:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brNota.
    tt-embarqueDI.ct-transit:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brNota.

    /*---[ SêRIE ]----------------------------------------------------------------------------*/
    ON  LEAVE OF tt-embarqueDI.serie-docto IN BROWSE brNota DO:
        IF VALID-HANDLE(h-bocx402) THEN DELETE PROCEDURE h-bocx402.
        RUN cxbo/bocx402.p PERSISTENT SET h-bocx402.

        ASSIGN c-proximo-nro = "".

        ASSIGN INPUT FRAME f-decl-imp ccod-estabel-1.

        IF tt-embarqueDI.nro-docto:SCREEN-VALUE IN BROWSE brNota = "" THEN 
            run retornaProxNota in h-bocx402 (input input browse brNota tt-embarqueDI.nat-operacao, 
                                              input ccod-estabel-1,
                                              input input browse brNota tt-embarqueDI.serie-docto,
                                              input input browse brNota tt-embarqueDI.cod-embarq,
                                              INPUT TABLE tt-embarqueDI,
                                              output c-proximo-nro).
        IF  c-proximo-nro <> "" 
        THEN DO :
            ASSIGN tt-embarqueDI.nro-docto = c-proximo-nro.

            DISP tt-embarqueDI.nro-docto WITH BROWSE brNota.
        END.
    END. /* ON  LEAVE OF tt-embarqueDI.serie-docto */
    
    /*---[ nro docto ]----------------------------------------------------------------------------*/
    ON  LEAVE OF tt-embarqueDI.nro-docto IN BROWSE brNota DO:
            assign tt-embarqueDI.nro-docto:SCREEN-VALUE IN BROWSE brNota = left-trim(string(dec(tt-embarqueDI.nro-docto:SCREEN-VALUE IN BROWSE brNota),c-formato-nf)).
    END. /* ON  LEAVE OF tt-embarqueDI.nro-docto */
    
    ON  'F5', mouse-select-dblclick OF tt-embarqueDI.serie-docto IN BROWSE brNota DO:
        if  num-results("brNota") > 0 then do:
            ASSIGN l-abriu-zoom = YES.
            {method/zoomfields.i &ProgramZoom   = "inzoom/z10in407.w"
                                 &FieldZoom1    = "serie"
                                 &FieldScreen1  = "tt-embarqueDI.serie-docto"
                                 &Browse1       = "brNota"
                                 &EnableImplant = "NO"}
            ASSIGN l-abriu-zoom = NO.
        end. /* if  num-results("brNota") > 0 */
    END. /* ON  'F5', mouse-select-dblclick OF */

    ON  MOUSE-SELECT-DBLCLICK OF tt-embarqueDI.serie-docto IN BROWSE brNota DO:
        apply 'F5' to self IN BROWSE brNota. 
    END. /* ON  MOUSE-SELECT-DBLCLICK OF tt-embarqueDI.serie-docto */
    
    /*---[ ESTABELECIMENTO FISCAL ]-----------------------------------------------------------*/
    ON  F5 OF tt-embarqueDI.cod-estab-fiscal IN BROWSE brNota DO:
        if  num-results("brNota") > 0 then do:
            {method/ZoomFields.i &ProgramZoom   = "adzoom/z10ad107.w"
                                 &FieldZoom1    = "cod-estabel"
                                 &FieldScreen1  = "tt-embarqueDI.cod-estab-fiscal"
                                 &Browse1       = "brNota"
                                 &EnableImplant = "NO"}
        END.
    END. /* ON  F5 OF tt-embarqueDI.cod-estab-fiscal */

    ON  MOUSE-SELECT-DBLCLICK OF tt-embarqueDI.cod-estab-fiscal IN BROWSE brNota DO:
        apply 'F5' to self IN BROWSE brNota. 
    END. /* ON  MOUSE-SELECT-DBLCLICK OF tt-embarqueDI.cod-estab-fiscal */


    /*---[ CONTA TRANSIT‡RIA ]----------------------------------------------------------------*/
    ON ENTRY OF tt-embarqueDI.ct-transit IN BROWSE brNota DO:
        ASSIGN tt-embarqueDI.sc-transit:READ-ONLY IN BROWSE brNota = NO.
        RETURN.
    END.


    ON F5 OF tt-embarqueDI.ct-transit IN BROWSE brNota DO:
        IF NUM-RESULTS("brNota") > 0 THEN DO:
            RUN pi_zoom_cta_ctbl_integr IN h_api_cta (INPUT  i-empresa,                /* EMPRESA EMS2 */
                                                      INPUT  "CEP",              /* MÖDULO */         
                                                      INPUT  "",            /* PLANO DE CONTAS */
                                                      INPUT  "(nenhum)",         /* FINALIDADES */ 
                                                      INPUT  INPUT FRAME f-decl-imp ddata-di-1, /* DATA TRANSACAO */ 
                                                      OUTPUT v_cod_cta_ctbl,     /* CODIGO CONTA */   
                                                      OUTPUT v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                      OUTPUT v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                      OUTPUT TABLE tt_log_erro). /* ERROS */ 
            IF v_cod_cta_ctbl <> "" THEN DO:
                ASSIGN tt-embarqueDI.ct-transit = v_cod_cta_ctbl
                       tt-embarqueDI.ct-transit:SCREEN-VALUE IN BROWSE brNota = v_cod_cta_ctbl.
                IF p_cod_format_cta_ctbl <> "" THEN
                    tt-embarqueDI.ct-transit:FORMAT IN BROWSE brNota = p_cod_format_cta_ctbl.
                ELSE
                    tt-embarqueDI.ct-transit:FORMAT IN BROWSE brNota = "X(20)":U.
            END.
        END.
    END. /* ON  F5 OF tt-embarqueDI.ct-transit */

    ON  MOUSE-SELECT-DBLCLICK OF tt-embarqueDI.ct-transit IN BROWSE brNota DO:
        APPLY "f5":U TO SELF IN BROWSE brNota .
    END. /* ON  MOUSE-SELECT-DBLCLICK OF tt-embarqueDI.ct-transit */


    /* LEAVE do campo ct-transit do browse brNota */
    ON LEAVE OF tt-embarqueDI.ct-transit IN BROWSE brNota DO:
          ASSIGN tt-embarqueDI.ct-transit:FORMAT IN BROWSE brNota = "x(20)"
                 v_cod_cta_ctbl = tt-embarqueDI.ct-transit:SCREEN-VALUE IN BROWSE brNota.
        
          run pi_busca_dados_cta_ctbl in h_api_cta (INPUT               i-empresa,                                      /* EMPRESA EMS2 */
                                                    INPUT               "",                                             /* PLANO DE CONTAS */
                                                    INPUT-OUTPUT        v_cod_cta_ctbl,                                 /* CONTA */
                                                    INPUT INPUT FRAME   f-decl-imp ddata-di-1,                          /* DATA TRANSACAO */   
                                                    OUTPUT              v_des_cta_ctbl,                                 /* DESCRICAO CONTA */
                                                    OUTPUT              v_num_tip_cta_ctbl,                             /* TIPO DA CONTA */
                                                    OUTPUT              v_num_sit_cta_ctbl,                             /* SITUAÄ«O DA CONTA */
                                                    OUTPUT              v_ind_finalid_cta,                              /* FINALIDADES DA CONTA */
                                                    OUTPUT TABLE        tt_log_erro).                                   /* ERROS */     

          IF RETURN-VALUE ="OK" THEN DO:
              ASSIGN tt-embarqueDI.ct-transit:SCREEN-VALUE  IN BROWSE brNota = v_cod_cta_ctbl
                     tt-embarqueDI.ct-transit = v_cod_cta_ctbl.
              IF p_cod_format_cta_ctbl <> "" THEN
                  ASSIGN tt-embarqueDI.ct-transit:FORMAT IN BROWSE brNota = p_cod_format_cta_ctbl.
              ELSE 
                  ASSIGN  tt-embarqueDI.ct-transit:FORMAT IN BROWSE brNota = "X(20)":U.
          END.

          /* verifica se a conta informada utiliza centro de custo */
          RUN pi_verifica_utilizacao_ccusto IN h_api_ccust (INPUT  i-empresa,                              /* EMPRESA EMS 2 */
                                                            INPUT  INPUT FRAME f-decl-imp ccod-estabel-1,  /* ESTABELECIMENTO EMS2 */
                                                            INPUT  "",                                     /* PLANO CONTAS */
                                                            INPUT  v_cod_cta_ctbl,                         /* CONTA */
                                                            INPUT  INPUT FRAME f-decl-imp ddata-di-1,      /* DT TRANSACAO */
                                                            OUTPUT v_log_utz_ccusto,                       /* UTILIZA CCUSTO ? */
                                                            OUTPUT TABLE tt_log_erro).                     /* ERROS */
          
          IF NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
              IF v_log_utz_ccusto = "NO" THEN DO:
                ASSIGN tt-embarqueDI.sc-transit:READ-ONLY IN BROWSE brNota = YES
                       tt-embarqueDI.sc-transit:FORMAT IN BROWSE brNota = "X(20)"
                       tt-embarqueDI.sc-transit = ""
                       tt-embarqueDI.sc-transit:SCREEN-VALUE IN BROWSE brNota = "".
                APPLY "ROW-LEAVE" TO brNota.
              END.
              ELSE
                ASSIGN tt-embarqueDI.sc-transit:READ-ONLY IN BROWSE brNota = NO.
          END.

    END. /* on leave tt-embarqueDI.ct-transit */
    /*---[ fim - CONTA TRANSIT‡RIA ]----------------------------------------------------------------*/


    /*---[ CCUSTO TRANSIT‡RIA ]----------------------------------------------------------------*/
    ON ENTRY OF tt-embarqueDI.sc-transit DO:
        ASSIGN tt-embarqueDI.sc-transit:FORMAT IN BROWSE brNota = "X(20)".
    END.

    ON f5 OF tt-embarqueDI.sc-transit DO:
        IF NUM-RESULTS("brNota") > 0 THEN DO:
            RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccust (INPUT              i-empresa,                         /* EMPRESA EMS2 */
                                                          INPUT INPUT FRAME  f-decl-imp ccod-estabel-1,         /* ESTABELECIMENTO EMS2 */
                                                          INPUT              YES,                               /* TODOS ESTABELECIMENTOS ? */
                                                          INPUT              "",                                /* UNIDADE DE NEGOCIO */
                                                          INPUT              "",                                /* PLANO CONTAS */
                                                          INPUT              tt-embarqueDI.ct-transit,          /* CONTA */
                                                          INPUT              "",                                /* CODIGO DO PLANO CCUSTO */
                                                          INPUT INPUT FRAME f-decl-imp ddata-di-1,              /* DATA DE TRANSACAO */
                                                          OUTPUT             v_cod_ccusto,                      /* CODIGO CCUSTO */
                                                          OUTPUT             v_des_ccusto,                      /* DESCRICAO CCUSTO */
                                                          OUTPUT TABLE       tt_log_erro).                      /* ERROS */

            IF NOT CAN-FIND(FIRST tt_log_erro) AND v_cod_ccusto <> "" THEN
                ASSIGN tt-embarqueDI.sc-transit = v_cod_ccusto
                       tt-embarqueDI.sc-transit:SCREEN-VALUE IN BROWSE brNota = v_cod_ccusto.
                       tt-embarqueDI.sc-transit:FORMAT IN BROWSE brNota = p_cod_format_ccusto.
        END.

        RETURN "OK":U.
    END.

    ON LEAVE OF tt-embarqueDI.sc-transit DO:
        ASSIGN v_cod_ccusto = INPUT BROWSE brNota tt-embarqueDI.sc-transit.
        RUN pi_busca_dados_ccusto in h_api_ccust (INPUT             i-empresa,                           /* EMPRESA EMS2 */
                                                  INPUT             "",                                  /* CODIGO DO PLANO CCUSTO */
                                                  INPUT             v_cod_ccusto,                        /* CCUSTO */
                                                  INPUT INPUT FRAME f-decl-imp ddata-di-1,               /* DATA DE TRANSACAO */
                                                  OUTPUT            v_des_ccusto,                        /* DESCRICAO DO CCUSTO */
                                                  OUTPUT TABLE      tt_log_erro).                        /* ERROS */ 
        IF NOT CAN-FIND(FIRST tt_log_erro) THEN
            ASSIGN tt-embarqueDI.sc-transit = v_cod_ccusto
                   tt-embarqueDI.sc-transit:SCREEN-VALUE IN BROWSE brNota = v_cod_ccusto
                   tt-embarqueDI.sc-transit:FORMAT IN BROWSE brNota = p_cod_format_ccusto.

        RETURN "OK":U.
    END.

    ON  MOUSE-SELECT-DBLCLICK OF tt-embarqueDI.sc-transit IN BROWSE brNota DO:
        APPLY "f5":U TO SELF IN BROWSE brNota .
    END.

    /*---[ fim - CCUSTO TRANSIT‡RIA ]----------------------------------------------------------------*/

END. /* IF  i-tp-nacionaliz = 2 ou 3 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-relat  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-relat  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-relat  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
  THEN DELETE WIDGET w-relat.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-relat  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY ccod-decl-imp-1 ccod-estabel-1 icod-di-ems ddata-di-1 ddata-cotacao-1 
      WITH FRAME f-decl-imp IN WINDOW w-relat.
  ENABLE ccod-decl-imp-1 bt-confirma brNota bt-marcar bt-todos bt-nenhum 
      WITH FRAME f-decl-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-decl-imp}
  DISPLAY cembarque ccod-estabel ccod-emitente ddata-trans ddata-emissao 
          ddata-vencto-ipi ddata-vencto-icms cnr-docto cserie cnatureza 
          ccod-estabel-fisc cconta-trans ccod-decl-imp cccusto-trans cdesc-tot 
          ddata-cotacao ddata-di licms-diferido l-nota-fisc-fat EDITOR-2 
          c-label-obs 
      WITH FRAME f-embarq IN WINDOW w-relat.
  ENABLE cembarque ccod-estabel ccod-emitente ddata-trans ddata-emissao 
         ddata-vencto-ipi ddata-vencto-icms cnr-docto cserie cnatureza 
         ccod-estabel-fisc cconta-trans ccod-decl-imp cccusto-trans cdesc-tot 
         ddata-cotacao ddata-di licms-diferido l-nota-fisc-fat EDITOR-2 
         c-label-obs 
      WITH FRAME f-embarq IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-embarq}

  ENABLE im-pg-cla im-pg-sel bt-executar bt-cancelar btpesoscubagem btimpostos 
         btconferencia bt-tipo bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY l-nf-simples-remessa rs-classif-nf l-gera-prim-remes-nf-mae 
          c-cta-aplic-nf desc-cta-aplic-nf c-ccusto-aplic-nf 
          desc-ccusto-aplic-nf l-nf-ajuste 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  ENABLE l-nf-simples-remessa l-gera-prim-remes-nf-mae l-nf-ajuste 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-cla}
  VIEW FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  VIEW w-relat.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-relat 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/

    APPLY "CLOSE":U TO THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-relat 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    IF NOT l-EMS2-IMP-MEXICO THEN
        ASSIGN btconferencia:VISIBLE IN FRAME f-relat = TRUE.
    
    IF i-pais-impto-usuario <> 1 THEN
        ASSIGN l-gera-prim-remes-nf-mae:HIDDEN IN FRAME f-pg-cla = YES.
    ELSE
        ASSIGN l-gera-prim-remes-nf-mae:HIDDEN    IN FRAME f-pg-cla = NO
               l-gera-prim-remes-nf-mae:SENSITIVE IN FRAME f-pg-cla = NO.

    run inbo/boin682.p persistent set h-boin682.
    run openQueryStatic in h-boin682 (input "MAIN":U) no-error.
    run findfirst       in h-boin682.
    run GetCharField in h-boin682 (input "formato-conta-contabil":U,
                                   output c-formato-cta-ctbl).
    run GetIntField in h-boin682  (input "empresa-prin":U,
                                   output i-empresa-prin).

    IF  c-nom-prog-upc-mg97 <> "" THEN DO:
        run value(c-nom-prog-upc-mg97) (input "AFTER-INITIALIZE", 
                                        input "CONTAINER",
                                        input this-procedure,
                                        input frame {&FRAME-NAME}:handle,
                                        input ?,
                                        input ?) NO-ERROR.
    END. /* IF  c-nom-prog-upc-mg97 <> "" THEN */
    
    &if '{&bf_libera_15_posicoes}' = 'yes' &then
        assign c-formato-nf = ">>>>>>>>9999999". /* Formato de 15 posiªÑes */
    &else
        assign c-formato-nf = ">>>9999999". /* Formato de 10 posiªÑes */
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-btExecutar w-relat 
PROCEDURE pi-btExecutar :
/* -----------------------------------------------------------
  Purpose:     
    Notes:       
-------------------------------------------------------------*/

    EMPTY TEMP-TABLE RowErrors.
    ASSIGN l-executar = YES
           l-primeira-exec = YES.
    
    DO TRANS:
        IF  c-nom-prog-upc-mg97 <> "" THEN DO:
            RUN VALUE(c-nom-prog-upc-mg97) ("ExecDesOkCla", "Container", {&WINDOW-NAME}:HANDLE, FRAME f-pg-cla:HANDLE, "", "") NO-ERROR.
            RUN VALUE(c-nom-prog-upc-mg97) ("ExecDesOk",    "Container", {&WINDOW-NAME}:HANDLE, FRAME f-pg-sel:HANDLE, "", "") NO-ERROR.
        END. /* IF  c-nom-prog-upc-mg97 <> "" THEN DO: */

        IF VALID-HANDLE(h-bocx402) THEN 
            DELETE PROCEDURE h-bocx402.
        RUN cxbo/bocx402.p PERSISTENT SET h-bocx402.

        CASE i-tp-nacionaliz:
            WHEN 1 /*---[ EMBARQUE ]---*/ THEN DO:
                ASSIGN INPUT FRAME f-embarq cembarque
                       INPUT FRAME f-embarq ccod-estabel.

                RUN pi-valida-embarque-filho.
                IF RETURN-VALUE <> "OK":U THEN
                RETURN NO-APPLY.

                RUN verificaRelacionamentos IN h-bocx402 (INPUT cembarque, INPUT ccod-estabel, OUTPUT vnum-di-siscomex, OUTPUT l-encontrou, OUTPUT vdat-di, OUTPUT vnat-operacao).

                IF  l-encontrou THEN DO:
                    /* Como existe DI relacionada ao embarque, ent∆o a l¢gica segue a linha do Tipo de Nacionalizaá∆o DI (tipo 2)*/
                    IF NOT VALID-HANDLE(h-bocx220a) THEN RUN cxbo/bocx220a.p PERSISTENT SET h-bocx220a.
                    RUN pi-recebe-tp-nacionaliz IN h-bocx220a (INPUT 2).

                    RUN verificaCalculosDI IN h-bocx402 (INPUT vnum-di-siscomex, OUTPUT llog-situacao, OUTPUT ccalculo-faltante). 
                    
                    IF  NOT llog-situacao THEN DO:
                        RUN utp/ut-msgs.p (INPUT 'show', INPUT 52260, INPUT string(vnum-di-siscomex) + '~~' + ccalculo-faltante).
                        RETURN NO-APPLY.
                    END. /* IF  NOT llog-situacao */
                END. /* IF  l-encontrou */

                assign input frame f-embarq
                       cembarque
                       cnr-docto
                       cserie
                       cnatureza
                       ccod-estabel
                       ccod-decl-imp
                       ddata-di
                       ddata-cotacao
                       ccod-emitente
                       ddata-trans
                       ddata-emissao 
                       ddata-vencto-ipi
                       ddata-vencto-icms 
                       ccod-estabel-fisc 
                       cconta-trans
                       cccusto-trans
                       cdesc-tot
                       licms-diferido
                       editor-2.              

                RUN pi-executar.
            END. /* WHEN 1 */
            WHEN 2 /*---[ DECLARAÄ«O DE IMPORTAÄ«O ]---*/ OR 
            WHEN 3 /*---[ Declaraá∆o Ènica de Importaá∆o - DUIMP ]---*/ THEN DO:
                ASSIGN INPUT FRAME f-decl-imp ccod-decl-imp-1 ccod-estabel-1 ddata-cotacao-1 ddata-di-1.
                RUN verificaCalculosDI IN h-bocx402 (INPUT ccod-decl-imp-1, OUTPUT llog-situacao, OUTPUT ccalculo-faltante). 

                IF  NOT llog-situacao THEN DO:
                    RUN utp/ut-msgs.p (INPUT 'show', INPUT 52260, INPUT ccod-decl-imp-1 + '~~' + ccalculo-faltante).
                    RETURN NO-APPLY.
                END. /* IF  NOT llog-situacao */

                ASSIGN ccod-estabel      = ccod-estabel-1
                       ddata-di          = ddata-di-1
                       ddata-cotacao     = ddata-cotacao-1.

                FIND FIRST param-imp NO-LOCK
                    WHERE  param-imp.cod-estabel = ccod-estabel-1 NO-ERROR.
                IF  AVAIL  param-imp THEN ASSIGN c-conta-transit-import = param-imp.ct-transit-import.
                
                IF NOT VALID-HANDLE(h-bocx220a) THEN RUN cxbo/bocx220a.p PERSISTENT SET h-bocx220a.
                RUN pi-recebe-tp-nacionaliz IN h-bocx220a (INPUT i-tp-nacionaliz).

                IF  NOT CAN-FIND(FIRST tt-embarqueDI 
                                 WHERE tt-embarqueDI.log-marcado) THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-processo-interrompido AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Processo_interrompido" *}
                    ASSIGN c-lbl-liter-processo-interrompido = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-nenhum-registro-selecionado-pa AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Nenhum_registro_selecionado_para_execuá∆o._Para_isso,_clique_duas_vezes_sobre_os_registros_desejados" *}
                    ASSIGN c-lbl-liter-nenhum-registro-selecionado-pa = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p (INPUT 'show', INPUT 17006, INPUT c-lbl-liter-processo-interrompido + '.' + '~~' + 
                                                                        c-lbl-liter-nenhum-registro-selecionado-pa + '.').
                    RETURN NO-APPLY.
                END. /* IF  NOT CAN-FIND(FIRST tt-embarqueDI */

                FOR EACH  tt-embarqueDI
                    WHERE tt-embarqueDI.log-marcado:

                    ASSIGN cembarque         = tt-embarqueDI.cod-embarq
                           cnr-docto         = tt-embarqueDI.nro-docto     
                           cserie            = tt-embarqueDI.serie-docto
                           cnatureza         = tt-embarqueDI.nat-operacao
                           ccod-emitente     = tt-embarqueDI.cod-emitente
                           ddata-trans       = tt-embarqueDI.dt-trans
                           ddata-emissao     = tt-embarqueDI.dt-emissao
                           ddata-vencto-ipi  = tt-embarqueDI.dt-venc-ipi
                           ddata-vencto-icms = tt-embarqueDI.dt-venc-icm
                           ccod-estabel-fisc = tt-embarqueDI.cod-estab-fiscal
                           cconta-trans      = REPLACE(tt-embarqueDI.ct-transit,".","")
                           cccusto-trans     = REPLACE(tt-embarqueDI.sc-transit,".","")
                           licms-diferido    = tt-embarqueDI.aliquota-icm
                           editor-2          = tt-embarqueDI.observacao
                           ccod-decl-imp     = ccod-decl-imp-1.
                    RUN pi-executar.
                END.  /* FOR EACH  tt-embarqueDI */
            END. /* WHEN 2 */
        END CASE. /* CASE i-tp-nacionaliz: */

        /*
         * o erro 52512 refere-se apenas uma mensagem de aviso ao usu†rio, que o n£mero da nota foi alterado, seguindo as regras do faturamento.
         * Como n∆o Ç uma mensagem de erro n∆o pode interromper o processo de geraá∆o da nota.
         */
        IF  CAN-FIND(FIRST RowErrors 
                        WHERE RowErrors.ErrorType <> "INTERNAL":U
                        AND   RowErrors.ErrorSubType <> "INFORMATION") OR
            CAN-FIND(FIRST tt-bo-erro WHERE tt-bo-erro.cd-erro <> 52512)
            THEN DO:
                    /*29560 Natureza_de_operaÁ„o_n„o pode emitir duplicatas*/
                IF  CAN-FIND(FIRST RowErrors 
                             WHERE RowErrors.ErrorNumber = 29560)THEN 
                    UNDO,LEAVE.

                IF CAN-FIND(FIRST RowErrors 
                                WHERE RowErrors.ErrorType <> "INTERNAL":U
                                AND   RowErrors.ErrorSubType <> "INFORMATION") THEN
                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal=YES}

                IF  CAN-FIND(FIRST RowErrors 
                             WHERE RowErrors.ErrorSubType     <> "WARNING") THEN
                    UNDO,LEAVE.
        END.
        ELSE DO:
            /* mostrar mensagem que atualizou o numero do documento */
            IF CAN-FIND(FIRST RowErrors) THEN DO: 
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal=YES}

            END.         

            IF i-tp-nacionaliz = 2 
            OR i-tp-nacionaliz = 3 THEN DO:
                ASSIGN c-embarques-gerados = "".
    
                FOR EACH  tt-embarqueDI
                    WHERE tt-embarqueDI.log-marcado:
    
                    IF CAN-FIND(FIRST tt-embarques-gerados
                                WHERE tt-embarques-gerados.cod-embarq = tt-embarqueDI.cod-embarq) THEN DO:
    
                        ASSIGN tt-embarqueDI.log-nf-gerada = YES
                               tt-embarqueDI.log-marcado   = NO.
    
                        IF c-embarques-gerados = "" THEN
                            ASSIGN c-embarques-gerados = tt-embarqueDI.cod-embarq.
                        ELSE 
                            ASSIGN c-embarques-gerados = c-embarques-gerados + "," + tt-embarqueDI.cod-embarq.
    
                    END.
                END.
    
                IF c-embarques-gerados <> "" THEN
                    run utp/ut-msgs.p (input "Show":U, input 54554, input c-embarques-gerados).
            END.
            ELSE
                run utp/ut-msgs.p (input "Show":U, input 17673, input "").
            
            {&OPEN-QUERY-brNota}
        END.

    END. /* do trans */
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carregaTT w-relat 
PROCEDURE pi-carregaTT :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE l-simples-remessa         AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-idi-tip-simples-remessa AS INTEGER     NO-UNDO.
    

    EMPTY TEMP-TABLE tt-embarqueDI NO-ERROR.
    
    ASSIGN l-simples-remessa         = l-nf-simples-remessa:CHECKED IN FRAME f-pg-cla
           i-idi-tip-simples-remessa = INT(rs-classif-nf:SCREEN-VALUE IN FRAME f-pg-cla).
    
    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar in h-acomp(input "Buscando Embarques").
    
    IF i-tp-nacionaliz = 3 /* DUIMP */ THEN 
        FOR FIRST decla-import NO-LOCK
            WHERE decla-import.cod-di-siscomex = INPUT FRAME f-decl-imp ccod-decl-imp-1
            AND   decla-import.num-seq-retif   = 99
            AND   decla-import.log-ativo: END.
    ELSE 
        FOR FIRST decla-import NO-LOCK
            WHERE decla-import.cod-di-siscomex = INPUT FRAME f-decl-imp ccod-decl-imp-1
            AND   decla-import.num-seq-retif  <> 99
            AND   decla-import.log-ativo: END.

    /*Inclu°do para resolver problema de performance na busca dos documentos para filtro*/
    FOR EACH docum-est NO-LOCK
        WHERE docum-est.declaracao-import = INPUT FRAME f-decl-imp ccod-decl-imp-1:

        IF NOT CAN-FIND(FIRST tt-docum-est-aux 
                        WHERE tt-docum-est-aux.declaracao-import = docum-est.declaracao-import) THEN DO:
            CREATE tt-docum-est-aux.
            ASSIGN tt-docum-est-aux.declaracao-import    = docum-est.declaracao-import
                   tt-docum-est-aux.cod-estabel          = docum-est.cod-estabel
                   tt-docum-est-aux.cod-embarq           = SUBSTRING(docum-est.char-1,1,20)
                   tt-docum-est-aux.ce-atual             = docum-est.ce-atual
                   tt-docum-est-aux.idi-nf-simples-remes = docum-est.idi-nf-simples-remes.
        END.
    END.
    
    FOR EACH  decla-import-embarq NO-LOCK
        WHERE decla-import-embarq.cod-estab  = INPUT FRAME f-decl-imp ccod-estabel-1
        AND   decla-import-embarq.num-di-ems = decla-import.num-di-ems
        AND   decla-import-embarq.cdd-siscomex-dts = decla-import.cdd-siscomex-dts,
        FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = decla-import-embarq.cod-estab
        AND   embarque-imp.embarque    = decla-import-embarq.cod-embarq:
    
        /*Caso n∆o seja simples remessa nÖo deve mostrar embarques que j† possuam NF geradas e atualizadas no estoque*/
        IF NOT l-simples-remessa THEN DO:
            IF CAN-FIND(FIRST tt-docum-est-aux
                       WHERE tt-docum-est-aux.cod-estabel       = decla-import-embarq.cod-estab
                       AND   tt-docum-est-aux.declaracao-import = INPUT FRAME f-decl-imp ccod-decl-imp-1
                       AND   tt-docum-est-aux.cod-embarq        = decla-import-embarq.cod-embarq
                       AND   tt-docum-est-aux.ce-atual) 
               OR CAN-FIND(FIRST tt-docum-est-aux
                           WHERE tt-docum-est-aux.cod-estabel       = decla-import-embarq.cod-estab             
                           AND   tt-docum-est-aux.declaracao-import = INPUT FRAME f-decl-imp ccod-decl-imp-1    
                           AND   tt-docum-est-aux.cod-embarq        = SUBSTRING(embarque-imp.char-1,61,20)            
                           AND   tt-docum-est-aux.ce-atual
                           AND   tt-docum-est-aux.idi-nf-simples-remes  = 1) THEN DO:
                NEXT.
            END.
        END.
        ELSE DO:
            IF i-idi-tip-simples-remessa = 1 THEN DO:
                /*Se marcado NF M«E n∆o deve ser mostrado embarques que j† geraram NF M∆e e que estejam atualizadas no estoque ou embarques filhos pois estes n∆o devem gerar nf m∆e*/
                IF CAN-FIND(FIRST tt-docum-est-aux
                            WHERE tt-docum-est-aux.cod-estabel       = decla-import-embarq.cod-estab             
                            AND   tt-docum-est-aux.declaracao-import = INPUT FRAME f-decl-imp ccod-decl-imp-1    
                            AND   tt-docum-est-aux.cod-embarq        = decla-import-embarq.cod-embarq            
                            AND   tt-docum-est-aux.ce-atual
                            AND   tt-docum-est-aux.idi-nf-simples-remes  = 1) OR 
                    CAN-FIND(FIRST tt-docum-est-aux
                             WHERE tt-docum-est-aux.cod-estabel       = decla-import-embarq.cod-estab             
                             AND   tt-docum-est-aux.declaracao-import = INPUT FRAME f-decl-imp ccod-decl-imp-1    
                             AND   tt-docum-est-aux.cod-embarq        = SUBSTRING(embarque-imp.char-1,61,20)            
                             AND   tt-docum-est-aux.ce-atual
                             AND   tt-docum-est-aux.idi-nf-simples-remes  = 1) THEN DO:
                    NEXT.

                END.
            END.
            ELSE DO:
                /*Se marcado NF Filha n∆o deve ser mostrado embarques que j† geraram NF Filha e que estejam atualizadas no estoque*/
                IF CAN-FIND(FIRST tt-docum-est-aux
                            WHERE tt-docum-est-aux.cod-estabel       = decla-import-embarq.cod-estab             
                            AND   tt-docum-est-aux.declaracao-import = INPUT FRAME f-decl-imp ccod-decl-imp-1    
                            AND   tt-docum-est-aux.cod-embarq        = decla-import-embarq.cod-embarq            
                            AND   tt-docum-est-aux.ce-atual
                            AND   tt-docum-est-aux.idi-nf-simples-remes  <> 1) THEN DO:
                    NEXT.
                END.
            END.
        END.

        {utp/ut-liter.i "Embarque" *}
        RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE +  decla-import-embarq.cod-embarq).

        FOR EACH  decla-import-ord NO-LOCK
            WHERE decla-import-ord.num-di-ems = decla-import-embarq.num-di-ems
            AND   decla-import-ord.cod-estab  = decla-import-embarq.cod-estab
            AND   decla-import-ord.cod-embarq = decla-import-embarq.cod-embarq
            AND   decla-import-ord.cdd-siscomex-dts = decla-import-embarq.cdd-siscomex-dts
            BREAK BY decla-import-ord.cod-estab   
                  BY decla-import-ord.cod-embarq: 
    
            FOR FIRST ordem-compra NO-LOCK
                WHERE ordem-compra.numero-ordem = decla-import-ord.num-ordem,
                EACH  prazo-compra NO-LOCK
                WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                AND   prazo-compra.parcela      = decla-import-ord.num-parcela
                AND   prazo-compra.situacao     = 2 /* Confirmada */:
    
                IF  FIRST-OF(decla-import-ord.cod-embarq) THEN DO:
                    RUN pi-tempTable-aux (INPUT decla-import-embarq.cod-estab, INPUT decla-import-embarq.cod-embarq).
                END. /* IF  FIRST-OF(decla-import-ord... */
        
                IF  CAN-FIND(FIRST tt-embarque-imp                                              
                             WHERE tt-embarque-imp.cod-estabel = decla-import-embarq.cod-estab  
                             AND   tt-embarque-imp.embarque    = decla-import-embarq.cod-embarq) THEN
                    FOR FIRST tt-embarque-imp
                        WHERE tt-embarque-imp.cod-estabel = decla-import-embarq.cod-estab 
                        AND   tt-embarque-imp.embarque    = decla-import-embarq.cod-embarq: 
                    END. /* FOR FIRST tt-embarque-imp */
        
                IF  NOT CAN-FIND(FIRST tt-embarqueDI
                                 WHERE tt-embarqueDI.num-di-ems = decla-import.num-di-ems
                                 AND   tt-embarqueDI.cod-estab  = decla-import-embarq.cod-estab 
                                 AND   tt-embarqueDI.cod-embarq = decla-import-embarq.cod-embarq) THEN DO:
        
                    CREATE tt-embarqueDI.
                    ASSIGN tt-embarqueDI.num-di-ems       = decla-import.num-di-ems
                           tt-embarqueDI.cod-estab        = decla-import-embarq.cod-estab
                           tt-embarqueDI.cod-embarq       = decla-import-embarq.cod-embarq
                           tt-embarqueDI.nat-operacao     = decla-import-ord.cod-natur-operac.
        
                    IF  AVAIL  tt-embarque-imp THEN
                        ASSIGN tt-embarqueDI.cod-estab-fiscal = tt-embarque-imp.cod-estab-fisc
                           tt-embarqueDI.ct-transit       = tt-embarque-imp.ct-transit-import /*.conta-transit-import*/
                           tt-embarqueDI.sc-transit       = tt-embarque-imp.sc-transit-import
                               tt-embarqueDI.dt-emissao       = TODAY
                               tt-embarqueDI.dt-trans         = TODAY
                               tt-embarqueDI.dt-venc-icm      = TODAY
                               tt-embarqueDI.dt-venc-ipi      = TODAY.
    
                    IF CAN-FIND(FIRST tt-docum-est-aux
                                WHERE tt-docum-est-aux.cod-estabel       = tt-embarqueDI.cod-estab
                                AND   tt-docum-est-aux.declaracao-import = INPUT FRAME f-decl-imp ccod-decl-imp-1
                                AND   tt-docum-est-aux.cod-embarq        = tt-embarqueDI.cod-embarq
                                AND   NOT tt-docum-est-aux.ce-atual) THEN
                        ASSIGN tt-embarqueDI.log-nf-gerada = YES.
        
                    FOR FIRST decla-import-adic NO-LOCK
                        WHERE decla-import-adic.num-di-ems = decla-import-embarq.num-di-ems                        
                        AND   decla-import-adic.num-adic   = decla-import-ord.num-adic
                        AND   decla-import-adic.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts:
                        ASSIGN tt-embarqueDI.cod-emitente = decla-import-adic.cdn-fornec.
                    END. /* FOR FIRST decla-import-adic  */
                END. /* IF  NOT CAN-FIND(FIRST tt-embarqueDI */
            END. /* FOR FIRST ordem-compra NO-LOCK */
        END. /* FOR EACH  decla-import-embarqq NO-LOCK */
    END.

    RUN pi-verifica-nota-simples-remessa.

    
    {&OPEN-QUERY-brNota}
    
    if  num-results("brNota") > 0 
    then ASSIGN tt-embarqueDI.serie-docto:READ-ONLY IN BROWSE brNota = NO
                tt-embarqueDI.nro-docto:READ-ONLY   IN BROWSE brNota = NO.
    else ASSIGN tt-embarqueDI.serie-docto:READ-ONLY IN BROWSE brNota = YES
                tt-embarqueDI.nro-docto:READ-ONLY   IN BROWSE brNota = YES.

    RUN pi-mudaFonteCor.
    
    FOR EACH tt-docum-est-aux:
        DELETE tt-docum-est-aux.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ContingenciaNFe w-relat 
PROCEDURE pi-ContingenciaNFe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-serie-SCAN   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-bodi317ef    AS HANDLE      NO-UNDO.

    IF  NOT VALID-HANDLE(h-bodi317ef) THEN
        RUN dibo/bodi317ef.p PERSISTENT SET h-bodi317ef.

    CASE i-tp-nacionaliz:
        WHEN 1 THEN /* Emabrque */
            RUN verificaContingenciaNFe IN h-bodi317ef (INPUT  "PERGUNTA":U, /*Tipo de Msg*/
                                                        INPUT  INPUT FRAME f-embarq ccod-emitente,
                                                        INPUT  INPUT FRAME f-embarq cnatureza,
                                                        INPUT  INPUT FRAME f-embarq ccod-estabel,
                                                        INPUT  INPUT FRAME f-embarq cserie,
                                                        OUTPUT c-serie-SCAN,
                                                        OUTPUT TABLE tt-erro-conting-nfe).
        WHEN 2 /* DI */ OR
        WHEN 3 /* DUIMP */ THEN
            RUN verificaContingenciaNFe IN h-bodi317ef (INPUT  "PERGUNTA":U, /*Tipo de Msg*/
                                                        INPUT  input browse brNota tt-embarqueDI.cod-emitente,
                                                        INPUT  input browse brNota tt-embarqueDI.nat-operacao,
                                                        INPUT  INPUT FRAME f-decl-imp ccod-estabel-1,
                                                        INPUT  input browse brNota tt-embarqueDI.serie-docto,
                                                        OUTPUT c-serie-SCAN,
                                                        OUTPUT TABLE tt-erro-conting-nfe).
        OTHERWISE
            RUN verificaContingenciaNFe IN h-bodi317ef (INPUT  "PERGUNTA":U, /*Tipo de Msg*/
                                                        INPUT  INPUT FRAME f-embarq ccod-emitente,
                                                        INPUT  INPUT FRAME f-embarq cnatureza,
                                                        INPUT  INPUT FRAME f-embarq ccod-estabel,
                                                        INPUT  INPUT FRAME f-embarq cserie,
                                                        OUTPUT c-serie-SCAN,
                                                        OUTPUT TABLE tt-erro-conting-nfe).
    END CASE.
        

    IF  VALID-HANDLE(h-bodi317ef) THEN DO:
        DELETE PROCEDURE h-bodi317ef.
        ASSIGN h-bodi317ef = ?.
    END.

    IF  CAN-FIND (FIRST tt-erro-conting-nfe) THEN
        FOR EACH tt-erro-conting-nfe NO-LOCK:

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT tt-erro-conting-nfe.cd-erro,
                               INPUT tt-erro-conting-nfe.mensagem).

            /*Pergunta*/
            IF  RETURN-VALUE <> "yes":U THEN
                RETURN "NOK":U.

            /*Erro*/                                                                     
            IF  CAN-FIND (FIRST cadast_msg NO-LOCK                                      
                          WHERE cadast_msg.cdn_msg     = tt-erro-conting-nfe.cd-erro    
                          AND   cadast_msg.idi_tip_msg = 1) /* 1 - Erro */              
                THEN RETURN "NOK":U.      
        END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-bo-errors w-relat 
PROCEDURE pi-cria-bo-errors:
/*------------------------------------------------------------------------------
  Purpose: Criacao da temp-table de erros retornada na execucao das procedures
  Parameters: INPUT - pi-cod-error (integer) - codigo do erro
              INPUT - pc-parameters (character) - parametros da mensagem de erro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-cod-error  AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER pc-parameters AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE i-sequencia-erro AS INTEGER NO-UNDO.

    FIND LAST tt-bo-erro NO-LOCK NO-ERROR.

    ASSIGN i-sequencia-erro = IF AVAIL tt-bo-erro THEN tt-bo-erro.i-sequen + 1 ELSE 1.
    
    RUN utp/ut-msgs.p (INPUT "msg":U, INPUT pi-cod-error, INPUT pc-parameters).

    CREATE tt-bo-erro.
    ASSIGN tt-bo-erro.i-sequen   = i-sequencia-erro
           tt-bo-erro.cd-erro    = pi-cod-error
           tt-bo-erro.mensagem   = RETURN-VALUE
           tt-bo-erro.parametros = pc-parameters
           tt-bo-erro.errortype  = "EMS":U.

    RUN utp/ut-msgs.p (INPUT "help":U, INPUT pi-cod-error, INPUT pc-parameters).

    ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "CodType":U, INPUT pi-cod-error, INPUT pc-parameters).
    
    CASE RETURN-VALUE:
        WHEN '1':U THEN
            ASSIGN tt-bo-erro.errorsubtype = "ERROR":U.
        WHEN '2':U THEN
            ASSIGN tt-bo-erro.errorsubtype = "WARNING":U.
        WHEN '3':U THEN
            ASSIGN tt-bo-erro.errorsubtype = "QUESTION":U.
        WHEN '4':U THEN
            ASSIGN tt-bo-erro.errorsubtype = "INFORMATION":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-row-errors w-relat 
PROCEDURE pi-cria-row-errors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM pErrorNumber      LIKE rowErrors.errorNumber     NO-UNDO.
DEFINE INPUT PARAM pErrorParameter   LIKE rowErrors.ErrorParameters NO-UNDO.
DEFINE INPUT PARAM pErrorDescription LIKE tt-bo-erro.mensagem       NO-UNDO.

DEFINE VARIABLE l-alterou AS LOGICAL  NO-UNDO.

ASSIGN l-alterou = NO.

IF pErrorDescription = "" THEN DO:
    RUN utp/ut-msgs.p (INPUT 'msg',
                       INPUT pErrorNumber,
                       INPUT pErrorParameter).
    ASSIGN pErrorDescription = RETURN-VALUE.

    ASSIGN l-alterou = YES.

END.

IF NOT CAN-FIND(FIRST RowErrors
                WHERE RowErrors.errorNumber = pErrorNumber) THEN DO:
    CREATE RowErrors.
    ASSIGN RowErrors.ErrorNumber      = pErrorNumber
           RowErrors.ErrorType        = "EMS"
           RowErrors.ErrorParameters  = pErrorParameter
           RowErrors.errorDescription = pErrorDescription.
    IF l-alterou THEN DO:
        RUN utp/ut-msgs.p (INPUT 'help',
                           INPUT pErrorNumber,
                           INPUT pErrorParameter).
        ASSIGN pErrorDescription = RETURN-VALUE.
    END.
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Embarque(s)" *}
    ASSIGN RowErrors.ErrorHelp        = pErrorDescription + CHR(10) + RETURN-VALUE + ": " + cembarque.
END.
ELSE DO:
    FOR FIRST RowErrors
        WHERE RowErrors.errorNumber = pErrorNumber :

        IF RowErrors.ErrorHelp BEGINS "Embaque(s)" THEN
            ASSIGN RowErrors.ErrorHelp = RowErrors.ErrorHelp + " , " + cembarque.
        ELSE DO:
            {utp/ut-liter.i "Embarque(s)" *}
            ASSIGN RowErrors.ErrorHelp = RETURN-VALUE + ": " + cembarque.
        END.
    END.
END.

RUN utp/ut-msgs.p (INPUT 'CodType',
                INPUT pErrorNumber,
                INPUT pErrorParameter).

CASE RETURN-VALUE:
    WHEN '1' THEN
        ASSIGN RowErrors.ErrorSubType     = "ERROR".
    WHEN '2' THEN
        ASSIGN RowErrors.ErrorSubType     = "WARNING".
    WHEN '3' THEN
        ASSIGN RowErrors.ErrorSubType     = "QUESTION".
    WHEN '4' THEN
        ASSIGN RowErrors.ErrorSubType     = "INFORMATION".
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{imp/im0100.i2}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-relat-acomp w-relat 
PROCEDURE pi-gera-relat-acomp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    SESSION:SET-WAIT-STATE("general":U).

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = 3
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.arquivo         = session:temp-directory + "im0100.tmp".
    FIND FIRST tt-retorno EXCLUSIVE-LOCK NO-ERROR.
    IF  AVAIL tt-retorno 
    AND tt-parametros.nro-docto = "" 
    THEN ASSIGN tt-parametros.nro-docto = tt-retorno.parametros. /*numero do documento qndo controle pro ser-estab, gera nota faturamento*/

    IF  NOT VALID-HANDLE(h-bocx402) THEN 
        RUN cxbo/bocx402.p PERSISTENT SET h-bocx402.

    RUN verificaRelacionamentos IN h-bocx402 (INPUT cembarque, INPUT ccod-estabel, OUTPUT vnum-di-siscomex, OUTPUT l-encontrou, OUTPUT vdat-di, OUTPUT vnat-operacao).

    IF NOT l-encontrou THEN DO:
        RUN imp/im0100brp.p (INPUT TABLE tt-parametros, INPUT TABLE tt-embarque-filho).
    END.
    ELSE
        RUN imp/im0100arp.p (INPUT TABLE tt-parametros, INPUT TABLE tt-param, INPUT TABLE tt-embarqueDI). 

    SESSION:SET-WAIT-STATE("":U).

    IF l-encontrou THEN DO:
        {include/i-rptrm.i}
    END.

    return "OK":U.           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mudaFonteCor w-relat 
PROCEDURE pi-mudaFonteCor :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    IF  AVAIL tt-embarqueDI THEN DO:
        IF  tt-embarqueDI.log-marcado = YES
        THEN ASSIGN tt-embarqueDI.serie-docto:FONT         IN BROWSE brNota = 0    
                    tt-embarqueDI.nro-docto:FONT           IN BROWSE brNota = 0    
                    tt-embarqueDI.cod-embarq:FONT          IN BROWSE brNota = 0        
                    tt-embarqueDI.nat-operacao:FONT        IN BROWSE brNota = 0    
                    tt-embarqueDI.cod-emitente:FONT        IN BROWSE brNota = 0    
                    tt-embarqueDI.cod-estab-fiscal:FONT    IN BROWSE brNota = 0    
                    tt-embarqueDI.dt-emissao:FONT          IN BROWSE brNota = 0    
                    tt-embarqueDI.dt-trans:FONT            IN BROWSE brNota = 0    
                    tt-embarqueDI.dt-venc-icm:FONT         IN BROWSE brNota = 0    
                    tt-embarqueDI.dt-venc-ipi:FONT         IN BROWSE brNota = 0    
                    tt-embarqueDI.ct-transit:FONT          IN BROWSE brNota = 0    
                    tt-embarqueDI.sc-transit:FONT          IN BROWSE brNota = 0    
                    tt-embarqueDI.aliquota-icm:FONT        IN BROWSE brNota = 0    
                    tt-embarqueDI.observacao:FONT          IN BROWSE brNota = 0    
                    tt-embarqueDI.log-nf-gerada:FONT       IN BROWSE brNota = 0
                    tt-embarqueDI.serie-docto:FGCOLOR      IN BROWSE brNota = 9   
                    tt-embarqueDI.nro-docto:FGCOLOR        IN BROWSE brNota = 9   
                    tt-embarqueDI.cod-embarq:FGCOLOR       IN BROWSE brNota = 9   
                    tt-embarqueDI.nat-operacao:FGCOLOR     IN BROWSE brNota = 9
                    tt-embarqueDI.cod-emitente:FGCOLOR     IN BROWSE brNota = 9
                    tt-embarqueDI.cod-estab-fiscal:FGCOLOR IN BROWSE brNota = 9
                    tt-embarqueDI.dt-emissao:FGCOLOR       IN BROWSE brNota = 9
                    tt-embarqueDI.dt-trans:FGCOLOR         IN BROWSE brNota = 9
                    tt-embarqueDI.dt-venc-icm:FGCOLOR      IN BROWSE brNota = 9
                    tt-embarqueDI.dt-venc-ipi:FGCOLOR      IN BROWSE brNota = 9
                    tt-embarqueDI.ct-transit:FGCOLOR       IN BROWSE brNota = 9
                    tt-embarqueDI.sc-transit:FGCOLOR       IN BROWSE brNota = 9
                    tt-embarqueDI.aliquota-icm:FGCOLOR     IN BROWSE brNota = 9
                    tt-embarqueDI.observacao:FGCOLOR       IN BROWSE brNota = 9
                    tt-embarqueDI.log-nf-gerada:FGCOLOR    IN BROWSE brNota = 9.
        ELSE ASSIGN tt-embarqueDI.serie-docto:FONT         IN BROWSE brNota = 1 
                    tt-embarqueDI.nro-docto:FONT           IN BROWSE brNota = 1 
                    tt-embarqueDI.cod-embarq:FONT          IN BROWSE brNota = 1 
                    tt-embarqueDI.nat-operacao:FONT        IN BROWSE brNota = 1 
                    tt-embarqueDI.cod-emitente:FONT        IN BROWSE brNota = 1 
                    tt-embarqueDI.cod-estab-fiscal:FONT    IN BROWSE brNota = 1 
                    tt-embarqueDI.dt-emissao:FONT          IN BROWSE brNota = 1 
                    tt-embarqueDI.dt-trans:FONT            IN BROWSE brNota = 1 
                    tt-embarqueDI.dt-venc-icm:FONT         IN BROWSE brNota = 1 
                    tt-embarqueDI.dt-venc-ipi:FONT         IN BROWSE brNota = 1 
                    tt-embarqueDI.ct-transit:FONT          IN BROWSE brNota = 1 
                    tt-embarqueDI.sc-transit:FONT          IN BROWSE brNota = 1 
                    tt-embarqueDI.aliquota-icm:FONT        IN BROWSE brNota = 1 
                    tt-embarqueDI.observacao:FONT          IN BROWSE brNota = 1 
                    tt-embarqueDI.log-nf-gerada:FONT       IN BROWSE brNota = 1
                    tt-embarqueDI.serie-docto:FGCOLOR      IN BROWSE brNota = 0
                    tt-embarqueDI.nro-docto:FGCOLOR        IN BROWSE brNota = 0
                    tt-embarqueDI.cod-embarq:FGCOLOR       IN BROWSE brNota = 0
                    tt-embarqueDI.nat-operacao:FGCOLOR     IN BROWSE brNota = 0
                    tt-embarqueDI.cod-emitente:FGCOLOR     IN BROWSE brNota = 0
                    tt-embarqueDI.cod-estab-fiscal:FGCOLOR IN BROWSE brNota = 0
                    tt-embarqueDI.dt-emissao:FGCOLOR       IN BROWSE brNota = 0
                    tt-embarqueDI.dt-trans:FGCOLOR         IN BROWSE brNota = 0
                    tt-embarqueDI.dt-venc-icm:FGCOLOR      IN BROWSE brNota = 0
                    tt-embarqueDI.dt-venc-ipi:FGCOLOR      IN BROWSE brNota = 0
                    tt-embarqueDI.ct-transit:FGCOLOR       IN BROWSE brNota = 0
                    tt-embarqueDI.sc-transit:FGCOLOR       IN BROWSE brNota = 0
                    tt-embarqueDI.aliquota-icm:FGCOLOR     IN BROWSE brNota = 0
                    tt-embarqueDI.observacao:FGCOLOR       IN BROWSE brNota = 0
                    tt-embarqueDI.log-nf-gerada:FGCOLOR    IN BROWSE brNota = 0.
    END. /* IF  AVAIL tt-embarqueDI THEN DO: */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-empresa w-relat 
PROCEDURE pi-retorna-empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-return        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE r-rowid-estabel AS ROWID       NO-UNDO.
    DEFINE VARIABLE h-boad107       AS HANDLE      NO-UNDO.

    ASSIGN i-empresa       = i-empresa-prin.
           r-rowid-estabel = ?.

    IF NOT VALID-HANDLE(h-boad107) THEN
        RUN adbo/boad107.p PERSISTENT SET h-boad107.

    EMPTY TEMP-TABLE tt-estabelec.

    CASE i-tp-nacionaliz:
        WHEN 1 /* Embarque */ THEN DO:
            RUN findCodigo IN h-boad107 (INPUT INPUT FRAME f-embarq ccod-estabel, OUTPUT c-return).
        END.
        WHEN 2 /* DI */ OR 
        WHEN 3 /* DUIMP */ THEN DO:
            RUN findCodigo IN h-boad107 (INPUT INPUT FRAME f-decl-imp ccod-estabel-1, OUTPUT c-return).
        END.
        OTHERWISE DO:
            RUN findCodigo IN h-boad107 (INPUT INPUT FRAME f-embarq ccod-estabel, OUTPUT c-return).
        END.
    END CASE.
    
    IF c-return = "":U THEN RUN GetCurrent IN h-boad107 (OUTPUT TABLE tt-estabelec).

    FOR FIRST tt-estabelec:
        ASSIGN r-rowid-estabel = tt-estabelec.r-rowid
               c-estabelec = tt-estabelec.cod-estabel
               i-empresa = tt-estabelec.ep-codigo.
    END.
    
    RUN pi-retorna-formato.

    DELETE PROCEDURE h-boad107.
    ASSIGN h-boad107 = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-formato w-relat 
PROCEDURE pi-retorna-formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*### Formato conta contabil*/
run pi_retorna_formato_cta_ctbl in h_api_cta (input  i-empresa,                 /* EMPRESA EMS 2 */
                                              input  "",                 /* PLANO CONTAS */
                                              INPUT INPUT FRAME f-embarq ddata-trans, /* DATA DE TRANSACAO */
                                              output p_cod_format_cta_ctbl,   /* FORMATO cta */
                                              output table tt_log_erro). /* ERROS */

/* formato centro de custo*/
run pi_retorna_formato_ccusto in h_api_ccust (input  i-empresa,                 /* EMPRESA EMS2 */
                                              input  "",             /* PLANO CCUSTO */
                                              input  INPUT FRAME f-embarq ddata-trans,              /* DATA DE TRANSACAO */
                                              output p_cod_format_ccusto, /* FORMATO CCUSTO */
                                              output table tt_log_erro). /* ERROS */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-tempTable-aux w-relat 
PROCEDURE pi-tempTable-aux :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pcod-estabel LIKE embarque-imp.cod-estabel NO-UNDO.
    DEF INPUT PARAM pembarque    LIKE embarque-imp.embarque    NO-UNDO.

    FOR EACH  embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = pcod-estabel
        AND   embarque-imp.embarque    = pembarque:
        
        /*if embarque-imp.situacao = 2 /* Encerrado */ then next. */

        FIND FIRST param-imp /*FIELDS(ct-transit-import sc-transit-import)*/
            WHERE param-imp.cod-estabel = embarque-imp.cod-estabel NO-LOCK NO-ERROR.
        
        FOR FIRST historico-embarque FIELDS(cod-itiner)
            WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
            AND   historico-embarque.embarque    = embarque-imp.embarque NO-LOCK: END.
        /*IF NOT AVAIL historico-embarque THEN NEXT.*/

        FOR FIRST itinerario FIELDS(cod-itiner pto-desembarque)
            WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK: END.
        /*IF NOT AVAIL itinerario THEN NEXT.*/
        
        RELEASE historico-embarque.
        
        FIND historico-embarque NO-LOCK
            WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
            AND   historico-embarque.embarque      = embarque-imp.embarque    
            AND   historico-embarque.cod-itiner    = itinerario.cod-itiner    
            AND   historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar USE-INDEX pto-contr NO-ERROR.
        /*IF NOT AVAIL historico-embarque THEN NEXT.*/

        FIND FIRST ordens-embarque NO-LOCK 
            WHERE  ordens-embarque.cod-estabel = embarque-imp.cod-estabel 
            AND    ordens-embarque.embarque    = embarque-imp.embarque NO-ERROR.
        IF  AVAIL ordens-embarque THEN DO:
            FIND processo-imp NO-LOCK
                WHERE processo-imp.cod-estabel = ordens-embarque.cod-estabel 
                AND   processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp NO-ERROR.
            IF  AVAIL processo-imp THEN DO:
                ASSIGN c-estab-fisc   = processo-imp.estab-fisc.
                
                FIND FIRST emitente NO-LOCK 
                    WHERE  emitente.cod-emitente = processo-imp.cod-exportador NO-ERROR.
                IF  AVAIL emitente THEN ASSIGN i-cod-emitente = processo-imp.cod-exportador
                                               c-nome-abrev   = emitente.nome-abrev.
            END. /* IF  AVAIL processo-imp THEN DO: */
        END. /* IF  AVAIL ordens-embarque THEN DO: */
        
        FIND FIRST tt-embarque-imp 
            WHERE  tt-embarque-imp.cod-estabel = embarque-imp.cod-estabel 
            AND    tt-embarque-imp.embarque    = embarque-imp.embarque NO-ERROR.
        IF  NOT AVAIL tt-embarque-imp THEN DO:
            CREATE tt-embarque-imp.
            ASSIGN tt-embarque-imp.embarque             = embarque-imp.embarque
                   tt-embarque-imp.cod-estabel          = embarque-imp.cod-estabel
                   tt-embarque-imp.cod-emitente         = i-cod-emitente
                   tt-embarque-imp.nome-abrev           = c-nome-abrev
                   tt-embarque-imp.cod-incoterm         = embarque-imp.cod-incoterm
                   tt-embarque-imp.cod-despachante      = embarque-imp.cod-despachante
                   tt-embarque-imp.cod-transportador    = embarque-imp.cod-transportador
                   tt-embarque-imp.cod-banco            = embarque-imp.cod-banco
                   tt-embarque-imp.declaracao-import    = embarque-imp.declaracao-import
                   tt-embarque-imp.data-di              = embarque-imp.data-di
                   tt-embarque-imp.dt-efetiva           = IF AVAIL historico-embarque THEN historico-embarque.dt-efetiva ELSE TODAY
                   tt-embarque-imp.ct-transit           = param-imp.ct-transit-import WHEN AVAIL param-imp
                   tt-embarque-imp.sc-transit           = param-imp.sc-transit-import WHEN AVAIL param-imp
                   tt-embarque-imp.cod-estab-fisc       = c-estab-fisc
                   tt-embarque-imp.cod-via-transp       = int(embarque-imp.cod-via-transp)
                   tt-embarque-imp.r-rowid              = rowid(embarque-imp)
                   i-cod-emitente = 0
                   c-nome-abrev   = ""
                   c-estab-fisc   = "".
        END. /* IF  AVAIL ordens-embarque THEN DO: */
    END. /* FOR EACH  embarque-imp NO-LOCK */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-TipoInicial w-relat 
PROCEDURE pi-TipoInicial :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN imp/im0100aa.w PERSISTENT SET h-im0100aa (INPUT THIS-PROCEDURE).

    IF  VALID-HANDLE (h-im0100aa) THEN DO:
        RUN initializeInterface IN h-im0100aa.
        WAIT-FOR CLOSE OF h-im0100aa FOCUS CURRENT-WINDOW.            
    END. /* IF  VALID-HANDLE (h-im0100aa) */
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.  
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/* *** Editado automaticamente para o projeto de facelift *** */
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF l-carrega-embarques 
        AND l-carrega-tt
        AND NOT l-alterou-di THEN
        case self:name:
            when "im-pg-sel" then do with frame f-relat:
                &IF "{&PGSEL}" <> "" &THEN
                    IF i-tp-nacionaliz = 2 
                    OR i-tp-nacionaliz = 3 THEN DO:
    
                        IF NOT VALID-HANDLE(h-acomp) THEN
                            RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
                        RUN pi-inicializar in h-acomp(input "Atualizando Lista de Embarques").
                    END.
                &ENDIF
                
            END.        
        END.
    {include/i-rptrp.i}

    IF l-carrega-embarques 
        AND l-carrega-tt
        AND NOT l-alterou-di THEN
        case self:name:
            when "im-pg-sel" then do with frame f-relat:
                &IF "{&PGSEL}" <> "" &THEN
                    IF i-tp-nacionaliz = 2 
                    OR i-tp-nacionaliz = 3 THEN DO:
                        RUN pi-carregaTT.
                    END.
                &ENDIF
                
            END.
        
        END.

    ASSIGN l-carrega-embarques = NO.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-chamada-prog w-relat 
PROCEDURE pi-valida-chamada-prog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-return AS CHARACTER NO-UNDO.

    EMPTY TEMP-TABLE tt-bo-erro.

    ASSIGN INPUT FRAME f-embarq cembarque
                                ccod-estabel
                                cnatureza
                                licms-diferido.
    IF  cembarque = "" THEN DO:
        
        {utp/ut-liter.i "Embarque" *}
        RUN pi-cria-bo-errors(265, RETURN-VALUE).
    END.

    IF  ccod-estabel = "" THEN DO:
        
        {utp/ut-liter.i "Estabelecimento" *}
        RUN pi-cria-bo-errors(265, RETURN-VALUE).
    END.

    IF  cnatureza = "" THEN DO:

        {utp/ut-liter.i "Natureza_de_operaá∆o" *}
        RUN pi-cria-bo-errors(265, RETURN-VALUE).
    END.
    ELSE DO:
        IF NOT VALID-HANDLE(h-boin245) THEN
            RUN inbo/boin245.p PERSISTENT SET h-boin245.

        RUN setConstraintRangePage1 IN h-boin245 (INPUT cnatureza, INPUT cnatureza).
        RUN openQuery               IN h-boin245 (INPUT 1).
        RUN goToKey                 IN h-boin245 (INPUT cnatureza).

        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i Natureza_de_Operaá∆o * L}
            RUN pi-cria-bo-errors(2, RETURN-VALUE).
        END.

        IF VALID-HANDLE(h-boin245)THEN DO:
            DELETE PROCEDURE h-boin245.
            ASSIGN h-boin245 = ?.
        END.
    END.

    IF  cembarque    <> "" 
    AND ccod-estabel <> ""
    AND cnatureza    <> "" THEN DO:

        IF NOT VALID-HANDLE(h-boin292) THEN
            RUN inbo/boin292.p PERSISTENT SET h-boin292.

        RUN openQueryStatic IN h-boin292 ("main":U).
        RUN goToKey         IN h-boin292 (INPUT c-seg-usuario).

        IF RETURN-VALUE = "NOK":U THEN DO:
             
            /*Usu†rio "" n∆o cadastrado.*/
            RUN pi-cria-bo-errors(16482, c-seg-usuario).
        END.

        IF VALID-HANDLE(h-boin292) THEN DO:
            DELETE PROCEDURE h-boin292.
            ASSIGN h-boin292 = ?.
        END.

        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.
        RUN findPk_Codigo IN h-bocx220 (INPUT ccod-estabel,
                                        INPUT cembarque,
                                        OUTPUT c-return).
        IF  c-return <> "" THEN DO:
            
            {utp/ut-liter.i "Embarque" *}
            RUN pi-cria-bo-errors(2, RETURN-VALUE).
        END.

        DELETE PROCEDURE h-bocx220.
        ASSIGN h-bocx220 = ?.
    END.

    IF  CAN-FIND(FIRST tt-bo-erro) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            run utp/showmessage.w PERSISTENT SET hShowMsg.
        ELSE DO:
            DELETE PROCEDURE hShowMsg.
            run utp/showmessage.w PERSISTENT SET hShowMsg.
        END.
        RUN setModal     IN hShowMsg (INPUT YES).
        run showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
        return "NOK".
    END.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validaDados-tela w-relat 
PROCEDURE pi-validaDados-tela :
/* -----------------------------------------------------------
  Purpose:     
    Notes:       
-------------------------------------------------------------*/

    /** Verifica se natureza de operaá∆o Ç de rateio **/
    if not valid-handle(h-boin245) then
        run inbo/boin245.p persistent set h-boin245.

    run setConstraintRangePage1 in h-boin245 (INPUT cnatureza, INPUT cnatureza).
    run openQuery               in h-boin245 (INPUT 1).
    run goToKey                 in h-boin245 (INPUT cnatureza).

    if return-value = "OK":U then do:
        run getLogField in h-boin245 (INPUT "nota-rateio":U, OUTPUT l-natur-rateio).
        if l-natur-rateio then do:

            IF NOT l-encontrou THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 15331, INPUT "").
                ASSIGN l-erro = YES.
                assign i-seq-erro = i-seq-erro + 1.
                create tt-bo-erro.  
                assign tt-bo-erro.i-sequen  = i-seq-erro
                       tt-bo-erro.cd-erro   = 15331
                       tt-bo-erro.mensagem  = RETURN-VALUE.
                APPLY "entry" TO cnatureza IN FRAME f-embarq.
            end.
            ELSE DO:
                RUN pi-cria-row-errors(INPUT 15331,
                                       INPUT "",
                                       INPUT "").
            END.
            RETURN no-apply.
        end.
    end.

    if valid-handle(h-boin245) then do:
        delete procedure h-boin245.
        assign h-boin245 = ?.
    end.
        
    if  ccod-decl-imp = "" and l-valida-decl-imp then do:
        IF NOT l-encontrou THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            create tt-bo-erro.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Declaraá∆o_de_Importaá∆o_n∆o_foi_informada" *}
            assign tt-bo-erro.parametros   = RETURN-VALUE
                   tt-bo-erro.errorsubtype = "Question".
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Declaraá∆o_de_Importaá∆o_n∆o_foi_informada" *}
            run utp/ut-msgs.p (input "show":U, input 27847, input RETURN-VALUE).
            if  return-value = "NO" then do:
                ASSIGN l-erro = YES.
                SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                return no-apply.        
            end. /* if  return-value = "NO" */
        END.
    end. /* if  ccod-decl-imp = "" */

    
    /* Caso o embarque esteja vinculado a um DI, o campo Declaraá∆o de Importaá∆o n∆o poder† ficar em branco */
    IF ccod-decl-imp = "" AND l-encontrou THEN DO:
        RUN pi-cria-row-errors (INPUT 3553,
                                INPUT "Declaraá∆o de Importaá∆o",
                                INPUT "").
    END.
    
    if valid-handle(h-bocx220a) then delete procedure h-bocx220a.
    run cxbo/bocx220a.p persistent set h-bocx220a.

    RUN validaNumAdicaoSiscomex IN h-bocx220a (INPUT ccod-estabel, INPUT cembarque).
    IF  RETURN-VALUE = "NOK":U THEN DO:
        IF NOT l-encontrou THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 33778, INPUT "").
            ASSIGN l-erro = YES.
        END.
        ELSE DO:
            RUN pi-cria-row-errors (INPUT 33778,
                                    INPUT "",
                                    INPUT "").
        END.
    END. /* IF  RETURN-VALUE = "NOK":U */

    if valid-handle(h-bocx225) then delete procedure h-bocx225.
    run cxbo/bocx225.p persistent set h-bocx225.

    RUN validaNumAdicao IN h-bocx225 (INPUT ccod-estabel, INPUT cembarque).  
    IF  RETURN-VALUE = "NOK":U THEN DO:
        IF NOT l-encontrou THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 33778, INPUT "").
            RETURN NO-APPLY.
        END.
        ELSE DO:
            RUN pi-cria-row-errors (INPUT 33778,
                                    INPUT "",
                                    INPUT "").
        END.
    END. /* IF  RETURN-VALUE = "NOK":U */

    RUN validateSiscomex IN h-bocx225 (INPUT ccod-estabel, INPUT cembarque).
    IF  RETURN-VALUE = "NOK":U THEN DO:
        IF NOT l-encontrou THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 33684, INPUT "").
            ASSIGN l-erro = YES.
        END.
        ELSE DO:
            RUN pi-cria-row-errors (INPUT 33684,
                                    INPUT "",
                                    INPUT "").            
        END.
    END. /* IF  RETURN-VALUE = "NOK":U */

    RUN validateSeqAdicao IN h-bocx225 (INPUT ccod-estabel, INPUT cembarque).
    IF  RETURN-VALUE = "NOK":U THEN DO:
        IF NOT l-encontrou THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "SeqÅància_da_Adiá∆o" *}
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 265, INPUT RETURN-VALUE).
            ASSIGN l-erro = YES.
        END.
        ELSE DO:
            RUN pi-cria-row-errors (INPUT 33778,
                                    INPUT "",
                                    INPUT ""). 
        END.
    END. /* IF  RETURN-VALUE = "NOK":U */

    IF NOT VALID-HANDLE(h-bocx220) THEN 
        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.
    
    RUN findPk_codigo IN h-bocx220 (INPUT ccod-estabel, INPUT cembarque, OUTPUT c-return).
    IF c-return = "":U THEN
        RUN getIntField IN h-bocx220 (INPUT "int-1":U, OUTPUT i-cambial).
    
    IF i-cambial = 2 THEN
        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 54429, cembarque).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-nota-simples-remessa w-relat 
PROCEDURE pi-verifica-nota-simples-remessa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  INPUT FRAME f-pg-cla l-nf-simples-remessa THEN DO:
        IF  c-conta-transit-import = "" THEN 
            ASSIGN c-conta-transit-import = cconta-trans:SCREEN-VALUE IN FRAME f-embarq.
          /* 
          ** A vari†vel rs-classif-nf-aux Ç carregada 
          ** com o valor inicial da vari†vel rs-classif-nf
          */
          IF rs-classif-nf-aux <> 1 OR
             rs-classif-nf-aux <> 2 THEN
              ASSIGN rs-classif-nf-aux = INPUT FRAME f-pg-cla rs-classif-nf.

          /*
          ** Caso o usu†rio tenha gerado um Docto de Entrada de Simples Remessa "Filha",
          ** e ira gerar novamente outro Docto de Entrada Simples Remessa "Filha"
          ** a vari†vel "rs-classif-nf" vem carregada como "Nota M∆e", apesar de 
          ** estar setado para geraá∆o da Nota Filha.
          */
          IF rs-classif-nf-aux <> rs-classif-nf THEN
              ASSIGN rs-classif-nf = rs-classif-nf-aux.
        /* Conta transitoria recebe como valor, a conta de 
        ** aplicaá∆o que foi informada na pasta "Simples Remessa" */
        IF rs-classif-nf = 2 THEN DO:
            IF i-tp-nacionaliz = 2 
            OR i-tp-nacionaliz = 3 THEN DO:
                FOR EACH tt-embarqueDI:
                    ASSIGN tt-embarqueDI.ct-transit = c-cta-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla.
                END.
            END.
            ELSE 
                ASSIGN cconta-trans:SCREEN-VALUE IN FRAME  f-embarq = c-cta-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla.
                       cccusto-trans:SCREEN-VALUE IN FRAME f-embarq = c-ccusto-aplic-nf:SCREEN-VALUE IN FRAME f-pg-cla.
        END.
            
    END. /* IF  INPUT FRAME f-pg-cla l-nf-simples-remessa */
    ELSE DO:
        IF   c-conta-transit-import-aux <> "" 
        AND  c-conta-transit-import-aux <> c-conta-transit-import THEN 
            IF i-tp-nacionaliz = 2 
            OR i-tp-nacionaliz = 3 THEN DO:
                FOR EACH tt-embarqueDI:
                    ASSIGN tt-embarqueDI.ct-transit = c-conta-transit-import-aux.
                END.
            END.
            ELSE
                ASSIGN cconta-trans:SCREEN-VALUE IN FRAME f-embarq = c-conta-transit-import-aux.
    END. /* ELSE DO: */

    IF i-tp-nacionaliz = 2 
    OR i-tp-nacionaliz = 3 THEN
        {&OPEN-QUERY-brNota}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zera-campos w-relat 
PROCEDURE pi-zera-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM i-tip-nac AS INTEGER NO-UNDO.

IF i-tip-nac = 1 THEN DO: /* Embarque */
    /* se a nacionalizaá∆o Ç por embarque, zerar os campos da nacionalizaá∆o por DI */
    ASSIGN ccod-decl-imp-1:SCREEN-VALUE IN FRAME f-decl-imp = ""
           ccod-estabel-1 :SCREEN-VALUE IN FRAME f-decl-imp = ""
           icod-di-ems    :SCREEN-VALUE IN FRAME f-decl-imp = "0"
           ddata-di-1     :SCREEN-VALUE IN FRAME f-decl-imp = ""
           ddata-cotacao-1:SCREEN-VALUE IN FRAME f-decl-imp = "".
    EMPTY TEMP-TABLE tt-embarqueDI.
    ENABLE btpesoscubagem
        WITH FRAME f-relat.
END.
ELSE DO: /* DI / DUIMP */
    /* se a nacionalizaá∆o Ç por DI, zerar os campos da nacionalizaá∆o por embarque */
    assign cembarque        :SCREEN-VALUE IN FRAME f-embarq = ""
           cnr-docto        :SCREEN-VALUE IN FRAME f-embarq = ""
           cserie           :SCREEN-VALUE IN FRAME f-embarq = ""
           cnatureza        :SCREEN-VALUE IN FRAME f-embarq = ""
           ccod-estabel     :SCREEN-VALUE IN FRAME f-embarq = ""
           ccod-decl-imp    :SCREEN-VALUE IN FRAME f-embarq = ""
           ddata-di         :SCREEN-VALUE IN FRAME f-embarq = STRING(TODAY)
           ddata-cotacao    :SCREEN-VALUE IN FRAME f-embarq = STRING(TODAY)
           ccod-emitente    :SCREEN-VALUE IN FRAME f-embarq = "0"
           ddata-trans      :SCREEN-VALUE IN FRAME f-embarq = STRING(TODAY)
           ddata-emissao    :SCREEN-VALUE IN FRAME f-embarq = STRING(TODAY)
           ddata-vencto-ipi :SCREEN-VALUE IN FRAME f-embarq = STRING(TODAY)
           ddata-vencto-icms:SCREEN-VALUE IN FRAME f-embarq = STRING(TODAY) 
           ccod-estabel-fisc:SCREEN-VALUE IN FRAME f-embarq = "" 
           cconta-trans     :SCREEN-VALUE IN FRAME f-embarq = ""
           cccusto-trans    :SCREEN-VALUE IN FRAME f-embarq = ""
           cdesc-tot        :SCREEN-VALUE IN FRAME f-embarq = "0,00"
           licms-diferido   :CHECKED IN FRAME f-embarq = FALSE
           editor-2         :SCREEN-VALUE IN FRAME f-embarq = "".

    ENABLE cnr-docto
           ccod-decl-imp
           ddata-cotacao
           ddata-di
        WITH FRAME f-embarq.

    ENABLE btpesoscubagem
        WITH FRAME f-relat.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMarcaEmbarque w-relat 
PROCEDURE piMarcaEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  AVAIL  tt-embarqueDI THEN 
        IF tt-embarqueDI.log-marcado 
        THEN ASSIGN tt-embarqueDI.log-marcado = NO.
        ELSE ASSIGN tt-embarqueDI.log-marcado = YES.

    RUN pi-mudaFonteCor.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-embarqueDI"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaTipoNacionaliz w-relat 
PROCEDURE setaTipoNacionaliz :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-tp-nacionaliz AS INTEGER NO-UNDO.
    
    ASSIGN i-tp-nacionaliz = p-tp-nacionaliz.

    CASE i-tp-nacionaliz:
        WHEN 1 /*---[ EMBARQUE ]---*/ THEN DO:                         
            HIDE FRAME f-decl-imp.
            VIEW FRAME f-embarq.
            ASSIGN l-nf-ajuste:HIDDEN IN FRAME f-pg-cla = NO. 
            ASSIGN btpesoscubagem:SENSITIVE  IN FRAME f-relat = YES. 
            IF  NOT l-EMS2-IMP-MEXICO 
            THEN ASSIGN btconferencia:HIDDEN   IN FRAME f-relat  = NO
                        l-nota-fisc-fat:HIDDEN IN FRAME f-embarq = YES.
            ELSE ASSIGN btconferencia:HIDDEN   IN FRAME f-relat  = YES
                        l-nota-fisc-fat:HIDDEN IN FRAME f-embarq = NO. 
            
            {utp/ut-liter.i  Desembarque *}
            create text wh-label-sel
                assign frame        = frame f-relat:handle
                       format       = "x(15)"
                       font         = 1
                       screen-value = Return-value
                       width        = 18
                       row          = 1.8
                       col          = im-pg-sel:col in frame f-relat + 1.86
                       visible      = yes
                 triggers:
                     on mouse-select-click
                        apply "mouse-select-click" to im-pg-sel in frame f-relat.           
                 end triggers.    
            {utp/ut-liter.i  Simples_Remessa *}
            create text wh-label-cla
                assign frame        = frame f-relat:handle
                       format       = "x(20)"
                       font         = 1
                       screen-value = Return-value
                       width        = 15
                       row          = 1.8
                       col          = im-pg-cla:col in frame f-relat + 1.86
                       visible      = yes
                 triggers:
                     on mouse-select-click
                        apply "mouse-select-click" to im-pg-cla in frame f-relat.           
                 end triggers.
        
        END. /* WHEN 1 */
        WHEN 2 /*---[ DECLARAÄ«O DE IMPORTAÄ«O ]---*/ OR
        WHEN 3 /*---[ Declaraá∆o Ènica de Importaá∆o - DUIMP ]---*/ THEN DO:
            ASSIGN tt-embarqueDI.serie-docto:READ-ONLY IN BROWSE brNota = YES
                   tt-embarqueDI.nro-docto:READ-ONLY   IN BROWSE brNota = YES
                   btpesoscubagem:SENSITIVE            IN FRAME f-relat = NO.
            HIDE FRAME f-embarq.
            VIEW FRAME f-decl-imp.
            ASSIGN l-nf-ajuste = NO.
            ASSIGN l-nf-ajuste:HIDDEN IN FRAME f-pg-cla = YES.
            
        END. /* WHEN 2 */
    END CASE. /* CASE i-tp-nacionaliz: */

    RUN pi-zera-campos(INPUT i-tp-nacionaliz). /* zera os campos da frame que n∆o ser† usada */

    APPLY "mouse-select-click":U TO im-pg-cla IN FRAME f-relat.
    APPLY "mouse-select-click":U TO im-pg-sel IN FRAME f-relat.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-relat 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    def input param p-issuer-hdl as handle no-undo.
    def input param p-state      as char   no-undo.

    run pi-trata-state (p-issuer-hdl, p-state).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-ccod-estabel w-relat 
PROCEDURE pi-leave-ccod-estabel:
    RUN pi-retorna-empresa.
    APPLY "leave":U TO  cconta-trans IN FRAME  f-embarq .
    /*---[ IPP3 ]------------------------------------------------------------------*/
    ASSIGN INPUT FRAME f-embarq cembarque
           INPUT FRAME f-embarq ccod-estabel.

    IF  NOT VALID-HANDLE(h-bocx402) THEN 
        RUN cxbo/bocx402.p PERSISTENT SET h-bocx402.

    RUN verificaRelacionamentos IN h-bocx402 (INPUT cembarque, INPUT ccod-estabel, OUTPUT vnum-di-siscomex, OUTPUT l-encontrou, OUTPUT vdat-di, OUTPUT vnat-operacao).

    IF  l-encontrou THEN DO:
        ASSIGN ccod-decl-imp:SENSITIVE    IN FRAME f-embarq = NO
               ccod-decl-imp:SCREEN-VALUE IN FRAME f-embarq = vnum-di-siscomex
               /*ccod-decl-imp:FORMAT       IN FRAME f-embarq = "99/9999999-9"*/
               ddata-di:SENSITIVE         IN FRAME f-embarq = NO
               ddata-di:SCREEN-VALUE      IN FRAME f-embarq = STRING(vdat-di, '99/99/9999')
               ddata-cotacao:SENSITIVE    IN FRAME f-embarq = NO
               ddata-cotacao:SCREEN-VALUE IN FRAME f-embarq = STRING(vdat-di, '99/99/9999')
               cnatureza:SENSITIVE        IN FRAME f-embarq = NO
               btpesoscubagem:SENSITIVE   IN FRAME f-relat  = NO 
               cnatureza:SCREEN-VALUE     IN FRAME f-embarq = vnat-operacao
               l-embarque-vinc-di                           = YES.
    END. /* IF  l-encontrou THEN DO: */
    ELSE DO:
        ASSIGN ccod-decl-imp:SENSITIVE    IN FRAME f-embarq = YES
               ddata-di:SENSITIVE         IN FRAME f-embarq = YES
               ddata-cotacao:SENSITIVE    IN FRAME f-embarq = YES
               cnatureza:SENSITIVE        IN FRAME f-embarq = YES
               btpesoscubagem:SENSITIVE   IN FRAME f-relat  = YES
               l-embarque-vinc-di                           = NO.
    END. /* ELSE DO: */
    /*-----------------------------------------------------------------------------*/
    
    /* busca os dados do embarque */
    /* s¢ entra neste if caso tenha informado o embarque e o estabelecimento. 
       A verificaá∆o do cod-emitente serve apenas para n∆o aplicar o leave mais de uma vez, pois o usuario pode ter alterado algum dado na m∆o e se aplicasse o leave no campo estas 
       alteraá‰es seriam perdidas*/
    IF cembarque:SCREEN-VALUE     IN FRAME f-embarq <> "" AND
       ccod-estabel:SCREEN-VALUE  IN FRAME f-embarq <> "" AND
       ccod-emitente:SCREEN-VALUE IN FRAME f-embarq = "0"  THEN DO:

        IF NOT VALID-HANDLE(h-bocx220) THEN
            RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.
        RUN busca-dados-im0100 IN h-bocx220 (INPUT  cembarque:SCREEN-VALUE IN FRAME f-embarq,
                                             INPUT  ccod-estabel:SCREEN-VALUE IN FRAME f-embarq,
                                             OUTPUT i-cod-emitente,
                                             OUTPUT c-estab-fisc,
                                             OUTPUT c-ct-transit,
                                             output c-sc-transit,
                                             OUTPUT c-decla-import,
                                             OUTPUT d-dat-di).

        ASSIGN ccod-emitente      :SCREEN-VALUE IN FRAME f-embarq = STRING(i-cod-emitente )
               ccod-estabel-fisc  :SCREEN-VALUE IN FRAME f-embarq = STRING(c-estab-fisc   )
               cconta-trans       :SCREEN-VALUE IN FRAME f-embarq = STRING(c-ct-transit   ) WHEN INPUT FRAME f-pg-cla rs-classif-nf <> 2
               cccusto-trans      :SCREEN-VALUE IN FRAME f-embarq = STRING(c-sc-transit   ) WHEN INPUT FRAME f-pg-cla rs-classif-nf <> 2
               ccod-decl-imp      :SCREEN-VALUE IN FRAME f-embarq = STRING(c-decla-import )
               /*ccod-decl-imp      :FORMAT       IN FRAME f-embarq = "99/9999999-9"*/
               ddata-di           :SCREEN-VALUE IN FRAME f-embarq = STRING(d-dat-di       ).

        IF VALID-HANDLE(h-bocx220) THEN DO:
            DELETE PROCEDURE h-bocx220.
            ASSIGN h-bocx220 = ?.
        END.
    END. /*fim busca dados do embarque */

    IF VALID-HANDLE(h-bocx402) THEN DO:
        DELETE PROCEDURE h-bocx402.
        ASSIGN h-bocx402 = ?.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-embarque w-relat 
PROCEDURE pi-leave-cembarque:
    RUN pi-verifica-nota-simples-remessa.
    IF  NOT VALID-HANDLE(h-bocx402) THEN 
        RUN cxbo/bocx402.p PERSISTENT SET h-bocx402.

    RUN verificaRelacionamentos IN h-bocx402 (INPUT INPUT FRAME f-embarq cembarque, 
                                              INPUT INPUT FRAME f-embarq ccod-estabel, 
                                              OUTPUT vnum-di-siscomex, 
                                              OUTPUT l-encontrou, 
                                              OUTPUT vdat-di, 
                                              OUTPUT vnat-operacao).

    IF l-encontrou THEN DO:
        DISABLE btpesoscubagem 
            WITH FRAME f-relat.
        ASSIGN l-embarque-vinc-di = YES.
    END.                                          
    ELSE DO:
        ENABLE btpesoscubagem 
            WITH FRAME f-relat.
        ASSIGN l-embarque-vinc-di = NO.
    END.                                         
    APPLY "leave":U TO ccod-estabel.

    IF VALID-HANDLE(h-bocx402) THEN DO:
        DELETE PROCEDURE h-bocx402.
        ASSIGN h-bocx402 = ?.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-embarque-filho w-relat
PROCEDURE pi-valida-embarque-filho :
/*------------------------------------------------------------------------------
  Purpose: Verifica se o embarque informado possui embarque m∆e direto e se os
           parÉmetros de Nota Fiscal Simples Remessa e Nota Filha foram
           selecionados.
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-embarque-mae-direta AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-simples-remessa     AS LOG NO-UNDO INIT NO.
    DEFINE VARIABLE i-emitente            AS INT NO-UNDO.

    IF i-tp-nacionaliz <> 1 THEN
        RETURN "OK":U.

    ASSIGN c-embarque-mae-direta = ""
           i-emitente = int(ccod-emitente:SCREEN-VALUE IN FRAME f-embarq).

    FIND FIRST embarque-imp NO-LOCK
         WHERE embarque-imp.cod-estabel = ccod-estabel
           AND embarque-imp.embarque    = cembarque
         NO-ERROR.

    IF NOT AVAILABLE embarque-imp THEN
        RETURN "OK":U.
    
    FIND FIRST docum-est NO-LOCK
                 WHERE docum-est.cod-estabel = embarque-imp.cod-estabel
                   AND docum-est.cod-emitente = i-emitente
                   AND TRIM(SUBSTRING(docum-est.char-1,1,20)) =
                       TRIM(SUBSTRING(embarque-imp.char-1,61,20))          /*Nota M∆e raiz*/
                   AND docum-est.idi-nf-simples-remes = 1
                   NO-ERROR.
    IF AVAIL docum-est THEN ASSIGN l-simples-remessa = YES.

    ASSIGN c-embarque-mae-direta =
        TRIM(SUBSTRING(embarque-imp.char-1, 21, 20)).

    IF c-embarque-mae-direta = "" THEN
        RETURN "OK":U.

    IF l-simples-remessa 
       AND (NOT l-nf-simples-remessa:CHECKED IN FRAME f-pg-cla
       OR INT(rs-classif-nf:SCREEN-VALUE IN FRAME f-pg-cla) <> 2) 
       THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 58624, INPUT c-embarque-mae-direta).
            IF RETURN-VALUE <> "yes" THEN RETURN "NOK":U.
       END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
