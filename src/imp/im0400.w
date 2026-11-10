&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-imp-proc NO-UNDO LIKE decla-import-proc
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-decla-imp-proc-aux NO-UNDO LIKE decla-import-proc
       FIELD r-Rowid AS ROWID
       FIELD desc-tipo AS CHAR.
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-embal NO-UNDO LIKE decla-import-embal
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-decla-import-embal-aux NO-UNDO LIKE decla-import-embal
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-desp-embarque NO-UNDO LIKE desp-embarque
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-despes-decla-import NO-UNDO LIKE despes-decla-import
       field r-Rowid as rowid
       FIELD desc-tipo AS CHAR format "x(15)".
DEFINE TEMP-TABLE tt-despes-decla-import-aux NO-UNDO LIKE despes-decla-import
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-histor-decla-import NO-UNDO LIKE histor-decla-import
       FIELD r-Rowid AS ROWID
       index codigo
       num-di-ems
       num-seq
       r-rowid.
DEFINE TEMP-TABLE tt-histor-decla-import-aux NO-UNDO LIKE histor-decla-import
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-historico-embarque NO-UNDO LIKE historico-embarque
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-historico-embarque-aux NO-UNDO LIKE historico-embarque
       field r-Rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0400 2.00.00.088 } /*** "010088" 02/09/2026 18:24:36 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0400 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        im0400
&GLOBAL-DEFINE Version        2.00.00.088

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Principal,B sica/Transp,Carga,Itiner rio,Despesas,Impostos,Impostos 2,Valores

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

&GLOBAL-DEFINE ttTable        tt-decla-import
&GLOBAL-DEFINE hDBOTable      h-bocx383
&GLOBAL-DEFINE DBOTable       decla-import

&GLOBAL-DEFINE page0KeyFields tt-decla-import.num-di-ems
&GLOBAL-DEFINE page0Fields    tt-decla-import.cod-estab tt-decla-import.cod-di-siscomex tt-decla-import.dat-di
&GLOBAL-DEFINE page1Fields    cb-carac-oper cb-mod-desp cb-tipo-declaracao tt-decla-import.cdn-consign tt-decla-import.log-fundap tt-decla-import.num-adicoes tt-decla-import.cod-natur-operac fi-cod-despachante
&GLOBAL-DEFINE page2Fields    tt-decla-import.cdn-urf-entr tt-decla-import.cdn-urf-despch ~
                              cb-via-transporte cb-docto-carg cb-tipo-conhecto cb-ind-utiliz tt-decla-import.cdn-transpdor tt-decla-import.cod-conhecto-house tt-decla-import.cod-conhecto-master tt-decla-import.cod-identif
&GLOBAL-DEFINE page3Fields    tt-decla-import.cdn-agent-carg-import tt-decla-import.cdn-pais-proceden tt-decla-import.cdn-recinto-alfand tt-decla-import.cdn-setor-armaz tt-decla-import.val-peso-liq-di tt-decla-import.val-peso-embal-di tt-decla-import.val-peso-brut-tot-di tt-decla-import.val-peso-brut-merc
&GLOBAL-DEFINE page4Fields    rs-tipo-apresentacao
&GLOBAL-DEFINE page5Fields    rs-apres-despesa
&GLOBAL-DEFINE page6Fields    label-fcp label-fcp-st label-icms-st label-icms-compl
&GLOBAL-DEFINE page7Fields
&GLOBAL-DEFINE page8Fields

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VAR gr-{&DBOTABLE} AS ROWID NO-UNDO.
/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl        AS HANDLE         NO-UNDO.
DEFINE VARIABLE c-return               AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE c-lit-trad-emb         AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE l-retorno              AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE wh-pesquisa            AS HANDLE                          NO-UNDO.
DEFINE VARIABLE h-bocx402              AS HANDLE                          NO-UNDO.
DEFINE VARIABLE h-cd0763               AS HANDLE                          NO-UNDO.
DEFINE VARIABLE i-reg-retornados       AS INTEGER                         NO-UNDO.
DEFINE VARIABLE i-num-di-ems           LIKE decla-import.num-di-ems       NO-UNDO.
DEFINE VARIABLE i-cod-emitente         LIKE emitente.cod-emitente         NO-UNDO.
DEFINE VARIABLE c-nat-operacao         LIKE natur-oper.nat-operacao       NO-UNDO.
DEFINE VARIABLE c-desc-processo        AS CHARACTER FORMAT "X(23)"        NO-UNDO.
DEFINE VARIABLE c-descricao            LIKE transporte.nome               NO-UNDO.
DEFINE VARIABLE i-tipo                 AS INTEGER                         NO-UNDO.
DEFINE VARIABLE l-zoom                 AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE i-cod-itiner           AS INTEGER                         NO-UNDO.
DEFINE VARIABLE rowsreturn             AS INTEGER                         NO-UNDO.
DEFINE VARIABLE r-hist-emb             AS ROWID                           NO-UNDO.
DEFINE VARIABLE i-cont                 AS INTEGER                         NO-UNDO.
DEFINE VARIABLE l-tipo-apres           AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE c-retorno-inf-compltar LIKE decla-import.cod-inf-compltar NO-UNDO.
DEFINE VARIABLE l-apres-desp           AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE c-desc-pto-control     LIKE pto-contr.descricao           NO-UNDO.
DEFINE VARIABLE i-diferenca            AS INTEGER                         NO-UNDO.
DEFINE VARIABLE r-desp-emb             AS ROWID                           NO-UNDO.
DEFINE VARIABLE r-chave                AS ROWID                           NO-UNDO.
DEFINE VARIABLE c-brw-desc-pto-control AS character format 'x(40)'        NO-UNDO.
DEFINE VARIABLE c-brw-desc-despes      AS character format 'x(40)'        NO-UNDO.
DEFINE VARIABLE c-brw-nome-abrev       AS character format 'x(40)'        NO-UNDO.
DEFINE VARIABLE c-brw-desc-pagto       AS character format 'x(40)'        NO-UNDO.
DEFINE VARIABLE l-troca-cor            AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-embarq-vinc          AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-data-diferente       AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-nat-operacao         AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-param-ativo          AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE i-pto-nacionalizacao   AS INT                             NO-UNDO.
DEFINE VARIABLE l-rateio               AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-gera-relat           AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-calcula-impostos     AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-existe-adic          AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-rateio-desp-comp     AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-regera-default-impostos AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE d-val-peso-embal       LIKE embalag.peso-embal            NO-UNDO.
DEFINE VARIABLE l-habilita-bt-conf     AS LOGICAL                         NO-UNDO.

DEFINE VARIABLE i-cdn-despes-siscomex AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cdn-emit-siscomex   AS INTEGER NO-UNDO.
DEFINE VARIABLE l-taxa-siscomex       AS LOGICAL NO-UNDO.

/* Vari veis do z01di040 */
{cdp/cd9098.i}
{imp/im0400.i} /*Temp Tables - tt-desp-rateio-item*/
{include/boerrtab.i} /* tt-bo-erro */

DEFINE TEMP-TABLE tt-docum-est NO-UNDO
    field embarque                   LIKE docum-est.embarque
    field cod-estabel                LIKE docum-est.cod-estabel
    field nro-docto                  LIKE docum-est.nro-docto
    field serie-docto                LIKE docum-est.serie-docto
    field cod-emitente               LIKE docum-est.cod-emitente
    field nat-operacao               LIKE docum-est.nat-operacao
    field idi-nf-simples-remes       LIKE docum-est.idi-nf-simples-remes
    field dt-emissao                 LIKE docum-est.dt-emissao
    field usuario                    LIKE docum-est.usuario
    field ce-atual                   LIKE docum-est.ce-atual
    field embarque-ori               LIKE docum-est.embarque
    field cod-tipo-nf-cred-deb       LIKE docum-est.cod-tipo-nf-cred-deb
    field cod-finalidade             LIKE docum-est.cod-finalidade
    field char-1                     LIKE docum-est.char-1
    FIELD observacao                 AS CHAR
    field r-rowid as rowid
.

DEFINE BUFFER bf-tt-histor-decla-import FOR tt-histor-decla-import.
/* Local Variable Definitions (DBOs Handles) --- */
DEF VAR {&hDBOTable} AS HANDLE  NO-UNDO.
DEF VAR h-boad098    AS HANDLE  NO-UNDO.
DEF VAR h-boin245    AS HANDLE  NO-UNDO.
DEF VAR h-bocx396    AS HANDLE  NO-UNDO.
DEF VAR h-boad268    AS HANDLE  NO-UNDO.
DEF VAR h-bocx386    AS HANDLE  NO-UNDO.
DEF VAR h-bocx384    AS HANDLE  NO-UNDO.
DEF VAR h-bocx3842   AS HANDLE  NO-UNDO.
DEF VAR h-bocx250    AS HANDLE  NO-UNDO.
DEF VAR h-im0400a    AS HANDLE  NO-UNDO.
DEF VAR h-im0400aa   AS HANDLE  NO-UNDO.
DEF VAR h-im0400b    AS HANDLE  NO-UNDO.
DEF VAR h-im0400c    AS HANDLE  NO-UNDO.
DEF VAR h-im0400d    AS HANDLE  NO-UNDO.
DEF VAR h-im0400e    AS HANDLE  NO-UNDO.
DEF VAR h-im0400f    AS HANDLE  NO-UNDO.
DEF VAR h-im0400g    AS HANDLE  NO-UNDO.
DEF VAR h-im0400i    AS HANDLE  NO-UNDO.
DEF VAR h-im0420     AS HANDLE  NO-UNDO.
DEF VAR h-im0055     AS HANDLE  NO-UNDO.
DEF VAR h-bocx110    AS HANDLE  NO-UNDO.
DEF VAR h-bocx230    AS HANDLE  NO-UNDO.
DEF VAR h-bocx230a   AS HANDLE  NO-UNDO.
DEF VAR h-bocx407    AS HANDLE  NO-UNDO.
DEF VAR h-bocx110na  AS HANDLE  NO-UNDO.
DEF VAR h-bocx406    AS HANDLE  NO-UNDO.
DEF VAR h-bocx095    AS HANDLE  NO-UNDO.
DEF VAR h-boad039na  AS HANDLE  NO-UNDO.
DEF VAR h-boad098na  AS HANDLE  NO-UNDO.
DEF VAR h-bocx310    AS HANDLE  NO-UNDO.
DEF VAR h-bocx383a   AS HANDLE  NO-UNDO.
DEF VAR h-bocx403    AS HANDLE  NO-UNDO.
DEF VAR h-bocx336    AS HANDLE  NO-UNDO.
DEF VAR h-bocx404    AS HANDLE  NO-UNDO.
DEF VAR l-encontrou  AS LOGICAL NO-UNDO.
DEF VAR l-saldo-positivo AS LOGICAL NO-UNDO.
DEF VAR cStatus      AS CHARACTER NO-UNDO.
DEF VAR rGoTo        AS ROWID NO-UNDO.
DEFINE VARIABLE l-integra-di AS LOGICAL  INITIAL NO   NO-UNDO.

DEFINE VARIABLE log-perm-pto-control-imp AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-alterando              AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-modificacao            AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-linha-anterior         AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq-pto-nacionaliz     AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-pto-ant                AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-lbl-pto-contr     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-cadastra-pto  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-uf            AS CHARACTER   NO-UNDO.

DEF VAR l-nt2024002 AS LOGICAL NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDespesa

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-despes-decla-import tt-decla-import-embal ~
tt-histor-decla-import tt-decla-imp-proc-aux

/* Definitions for BROWSE brDespesa                                     */
&Scoped-define FIELDS-IN-QUERY-brDespesa tt-despes-decla-import.desc-tipo tt-despes-decla-import.cdn-pto-control fnDescricaoPtoControle(tt-despes-decla-import.num-di-ems, tt-despes-decla-import.cdd-siscomex-dts, tt-despes-decla-import.cdn-pto-control) @ c-brw-desc-pto-control tt-despes-decla-import.cdn-despes fnDescDespes(tt-despes-decla-import.cdn-despes, tt-despes-decla-import.num-di-ems, tt-despes-decla-import.cdd-siscomex-dts) @ c-brw-desc-despes tt-despes-decla-import.cdn-emit-despes fnNomeAbrev(tt-despes-decla-import.cdn-emit-despes) @ c-brw-nome-abrev tt-despes-decla-import.cdn-cond-pagto fnDescPagto(tt-despes-decla-import.cdn-cond-pagto) @ c-brw-desc-pagto tt-despes-decla-import.cdn-moed tt-despes-decla-import.val-desp tt-despes-decla-import.val-cotac-despes-compltar tt-despes-decla-import.log-incid-vmle
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDespesa tt-despes-decla-import.desc-tipo ~
 ~
 ~
 ~
 ~
 VALIDATE(tt-despes-decla-import.desc-tipo = "Nacionaliza‡Æo" OR tt-despes-decla-import.desc-tipo = "Complementar", "Tipo deve ser N ou C") ~
 tt-despes-decla-import.cdn-despes ~
 tt-despes-decla-import.cdn-emit-despes ~
 tt-despes-decla-import.cdn-cond-pagto ~
 tt-despes-decla-import.cdn-moed ~
 tt-despes-decla-import.val-desp ~
 tt-despes-decla-import.val-cotac-despes-compltar ~
 tt-despes-decla-import.log-incid-vmle
&Scoped-define ENABLED-TABLES-IN-QUERY-brDespesa tt-despes-decla-import ~
VALIDATE(tt-despes-decla-import
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDespesa tt-despes-decla-import
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-brDespesa VALIDATE(tt-despes-decla-import
&Scoped-define SELF-NAME brDespesa
&Scoped-define QUERY-STRING-brDespesa FOR EACH tt-despes-decla-import NO-LOCK
&Scoped-define OPEN-QUERY-brDespesa OPEN QUERY {&SELF-NAME} FOR EACH tt-despes-decla-import NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brDespesa tt-despes-decla-import
&Scoped-define FIRST-TABLE-IN-QUERY-brDespesa tt-despes-decla-import


/* Definitions for BROWSE brEmbalagem                                   */
&Scoped-define FIELDS-IN-QUERY-brEmbalagem tt-decla-import-embal.qtd-vol-embal tt-decla-import-embal.cod-sig-embal
&Scoped-define ENABLED-FIELDS-IN-QUERY-brEmbalagem tt-decla-import-embal.qtd-vol-embal ~
  tt-decla-import-embal.cod-sig-embal
&Scoped-define ENABLED-TABLES-IN-QUERY-brEmbalagem tt-decla-import-embal
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brEmbalagem tt-decla-import-embal
&Scoped-define SELF-NAME brEmbalagem
&Scoped-define QUERY-STRING-brEmbalagem FOR EACH tt-decla-import-embal NO-LOCK
&Scoped-define OPEN-QUERY-brEmbalagem OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-embal NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brEmbalagem tt-decla-import-embal
&Scoped-define FIRST-TABLE-IN-QUERY-brEmbalagem tt-decla-import-embal


/* Definitions for BROWSE brHistorico                                   */
&Scoped-define FIELDS-IN-QUERY-brHistorico tt-histor-decla-import.num-seq tt-histor-decla-import.cdn-pto-control tt-histor-decla-import.descricao tt-histor-decla-import.dat-prev-origin tt-histor-decla-import.dat-ult-prev tt-histor-decla-import.dat-efetiva fnCalculaDiferenca(tt-histor-decla-import.num-seq,tt-histor-decla-import.cdd-siscomex-dts,tt-histor-decla-import.dat-efetiva) @ i-diferenca tt-histor-decla-import.cod-meio-transp tt-histor-decla-import.nr-dias fnUF(tt-histor-decla-import.num-di-ems, tt-histor-decla-import.cdn-pto-control, tt-histor-decla-import.cdd-siscomex-dts) @ c-cod-uf tt-histor-decla-import.dsl-obs
&Scoped-define ENABLED-FIELDS-IN-QUERY-brHistorico tt-histor-decla-import.num-seq ~
 ~
 tt-histor-decla-import.cdn-pto-control ~
 tt-histor-decla-import.descricao ~
 tt-histor-decla-import.dat-prev-origin ~
 tt-histor-decla-import.dat-efetiva ~
   tt-histor-decla-import.cod-meio-transp ~
 tt-histor-decla-import.dsl-obs ~
 tt-histor-decla-import.dat-ult-prev ~
 tt-histor-decla-import.nr-dias
&Scoped-define ENABLED-TABLES-IN-QUERY-brHistorico tt-histor-decla-import
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brHistorico tt-histor-decla-import
&Scoped-define SELF-NAME brHistorico
&Scoped-define QUERY-STRING-brHistorico FOR EACH tt-histor-decla-import NO-LOCK
&Scoped-define OPEN-QUERY-brHistorico OPEN QUERY {&SELF-NAME} FOR EACH tt-histor-decla-import NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brHistorico tt-histor-decla-import
&Scoped-define FIRST-TABLE-IN-QUERY-brHistorico tt-histor-decla-import


/* Definitions for BROWSE brProcessoVinc                                */
&Scoped-define FIELDS-IN-QUERY-brProcessoVinc tt-decla-imp-proc-aux.desc-tipo tt-decla-imp-proc-aux.cod-proces-vincul
&Scoped-define ENABLED-FIELDS-IN-QUERY-brProcessoVinc tt-decla-imp-proc-aux.desc-tipo ~
  tt-decla-imp-proc-aux.cod-proces-vincul
&Scoped-define ENABLED-TABLES-IN-QUERY-brProcessoVinc tt-decla-imp-proc-aux
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brProcessoVinc tt-decla-imp-proc-aux
&Scoped-define SELF-NAME brProcessoVinc
&Scoped-define QUERY-STRING-brProcessoVinc FOR EACH tt-decla-imp-proc-aux NO-LOCK
&Scoped-define OPEN-QUERY-brProcessoVinc OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-imp-proc-aux NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brProcessoVinc tt-decla-imp-proc-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brProcessoVinc tt-decla-imp-proc-aux


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brProcessoVinc}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brEmbalagem}

/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-brHistorico}

/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brDespesa}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-decla-import.num-di-ems ~
tt-decla-import.cod-di-siscomex tt-decla-import.num-seq-retif ~
tt-decla-import.cod-estab tt-decla-import.dat-di tt-decla-import.dat-retif
&Scoped-define ENABLED-TABLES tt-decla-import
&Scoped-define FIRST-ENABLED-TABLE tt-decla-import
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btFiltro btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btConfTrib btCotacaoDi btRateio btVincEmb btAdicoes ~
btRetificacao btDocRelac btQueryJoins btReportsJoins btExit btHelp ~
cb-motivo-retif
&Scoped-Define DISPLAYED-FIELDS tt-decla-import.num-di-ems ~
tt-decla-import.cod-di-siscomex tt-decla-import.num-seq-retif ~
tt-decla-import.cod-estab tt-decla-import.dat-di tt-decla-import.dat-retif
&Scoped-define DISPLAYED-TABLES tt-decla-import
&Scoped-define FIRST-DISPLAYED-TABLE tt-decla-import
&Scoped-Define DISPLAYED-OBJECTS cb-motivo-retif v-base-ibsmun ~
v-base-ibsmun-2 v-susp-ibsmun-2 v-susp-ibsmun v-recolhe-ibsmun-2 ~
v-recolhe-ibsmun v-outros-ibsmun-2 v-outros-ibsmun v-base-cbs v-base-cbs-2 ~
v-susp-cbs-2 v-susp-cbs v-recolhe-cbs-2 v-recolhe-cbs v-outros-cbs ~
v-outros-cbs-2 v-total-susp-trib v-total-susp-trib-2 v-total-recolhe-trib-2 ~
v-total-recolhe-trib v-total-outros-trib-2 v-total-outros-trib

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCalculaDiferenca wMaintenance
FUNCTION fnCalculaDiferenca RETURNS INTEGER
  ( i-num-seq    AS INTEGER,
    pcdd-siscomex-dts AS DECIMAL,
    dt-efetiva AS DATE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescDespes wMaintenance
FUNCTION fnDescDespes RETURNS CHARACTER
  ( p-cdn-despes AS INT,
    p-num-di-ems AS INT,
    p-cdd-siscomex-dts AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescPagto wMaintenance
FUNCTION fnDescPagto RETURNS CHARACTER
  ( i-cdn-pagto as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricaoPtoControle wMaintenance
FUNCTION fnDescricaoPtoControle RETURNS CHARACTER
  ( input num-di-ems AS int,
    INPUT p-cdd-siscomex-dts AS DEC,
    input p-pto-control AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeAbrev wMaintenance
FUNCTION fnNomeAbrev RETURNS CHARACTER
  ( p-cod-emitente AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipoProcesso wMaintenance
FUNCTION fnTipoProcesso RETURNS INTEGER
  ( pTipo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUF wMaintenance
FUNCTION fnUF RETURNS CHARACTER
  (input pnum-di-ems AS INTEGER,
   input pcdn-pto-control AS INTEGER,
   INPUT p-cdd-siscomex-dts AS DEC) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       MENU-ITEM m_Filtro       LABEL "&Filtro"
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
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add"
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btAdicoes
     IMAGE-UP FILE "image/im-carga.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-carga.bmp":U
     LABEL "Adi‡äes"
     SIZE 4 BY 1.25 TOOLTIP "Adi‡äes"
     FONT 4.

DEFINE BUTTON btCancel
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel"
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btConfTrib
     IMAGE-UP FILE "image/im-mov.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-mov.bmp":U
     LABEL "Configurador de Tributos"
     SIZE 4 BY 1.25 TOOLTIP "Configurador de Tributos"
     FONT 4.

DEFINE BUTTON btCopy
     IMAGE-UP FILE "image\im-copy":U
     IMAGE-INSENSITIVE FILE "image\ii-copy":U
     LABEL "Copy"
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCotacaoDi
     IMAGE-UP FILE "image/im-aval.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-amort.bmp":U
     LABEL "Cota‡Æo DI"
     SIZE 4 BY 1.25 TOOLTIP "Cota‡Æo DI"
     FONT 4.

DEFINE BUTTON btDelete
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Delete"
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDocRelac
     IMAGE-UP FILE "image/im-cotof.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-cotof.bmp":U
     LABEL ""
     SIZE 4 BY 1.25 TOOLTIP "Documentos Relacionados"
     FONT 4.

DEFINE BUTTON btExit
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit"
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro
     IMAGE-UP FILE "image/im-fil.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-fil.bmp":U
     LABEL "Filtro"
     SIZE 4 BY 1.25 TOOLTIP "Filtro".

DEFINE BUTTON btFirst
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To"
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help"
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins"
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btRateio
     IMAGE-UP FILE "image/im-aloca.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-aloci.bmp":U
     LABEL "Atualiza Rateio Embarques"
     SIZE 4 BY 1.25 TOOLTIP "Atualiza Valores e Impostos"
     FONT 4.

DEFINE BUTTON btReportsJoins
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins"
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btRetificacao
     IMAGE-UP FILE "image/ii-respl.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-respl.bmp":U
     LABEL "Retifica‡Æo"
     SIZE 4 BY 1.25 TOOLTIP "Retifica‡Æo"
     FONT 4.

DEFINE BUTTON btSave
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save"
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search"
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo
     IMAGE-UP FILE "image\im-undo":U
     IMAGE-INSENSITIVE FILE "image\ii-undo":U
     LABEL "Undo"
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update"
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btVincEmb
     IMAGE-UP FILE "image/im-forma.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-forma.bmp":U
     LABEL "Vincular Embarques"
     SIZE 4 BY 1.25 TOOLTIP "Vincular Embarques"
     FONT 4.

DEFINE VARIABLE cb-motivo-retif AS CHARACTER FORMAT "X(256)":U
     LABEL "Motivo"
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 31.43 BY 1 NO-UNDO.

DEFINE VARIABLE v-base-cbs AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-base-cbs-2 AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-base-ibsmun AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-base-ibsmun-2 AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-cbs AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-cbs-2 AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-ibsmun AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-ibsmun-2 AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-cbs AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-cbs-2 AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-ibsmun AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-ibsmun-2 AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-cbs AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-cbs-2 AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-ibsmun AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-ibsmun-2 AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-total-outros-trib AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-total-outros-trib-2 AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-total-recolhe-trib AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-total-recolhe-trib-2 AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-total-susp-trib AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-total-susp-trib-2 AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 103 BY 2.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE
     SIZE 103 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btObservacao
     LABEL "Observa‡Æo"
     SIZE 10 BY 1.

DEFINE VARIABLE cb-carac-oper AS CHARACTER FORMAT "X(256)":U
     LABEL "Caracter¡stica Opera‡Æo"
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 28.86 BY 1 NO-UNDO.

DEFINE VARIABLE cb-mod-desp AS CHARACTER FORMAT "X(256)":U
     LABEL "Modalidade Despacho"
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 27.86 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-declaracao AS CHARACTER FORMAT "X(256)":U
     LABEL "Tipo Declara‡Æo"
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 51 BY 1 NO-UNDO.

DEFINE VARIABLE c-des-nat-operacao AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 41.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 31.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev-desp AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 31.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-despachante AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0
     LABEL "C¢digo Despachante"
     VIEW-AS FILL-IN
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 95 BY 1.33.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 95 BY 3.67.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 45 BY 1.33.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 49.86 BY 1.33.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 95 BY 2.46.

DEFINE VARIABLE cb-calculo-impostos AS LOGICAL INITIAL no
     LABEL "C lculo Impostos"
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE cb-rateio-desp-comp AS LOGICAL INITIAL no
     LABEL "Rateio Despesas Complementares"
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE cb-rateio-desp-nacio AS LOGICAL INITIAL no
     LABEL "Rateio Despesas Nacionaliza‡Æo"
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE BUTTON btAddProcessoVinc
     IMAGE-UP FILE "image/im-add.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-add.bmp":U
     LABEL "Adiciona Processo Vinculado"
     SIZE 4 BY 1.25 TOOLTIP "Adiciona Processo Vinculado"
     FONT 4.

DEFINE BUTTON btCanProcVinc
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Save"
     SIZE 4 BY 1.25 TOOLTIP "Cancela InclusÆo Processo Vinculado"
     FONT 4.

DEFINE BUTTON btDelProcessoVinc
     IMAGE-UP FILE "image/im-era.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-era.bmp":U
     LABEL "Excluir"
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSaveProcessoVinc
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save"
     SIZE 4 BY 1.25 TOOLTIP "Salva Processo Vinculado"
     FONT 4.

DEFINE VARIABLE cb-docto-carg AS CHARACTER FORMAT "X(256)":U
     LABEL "Doc. Chegada Carga"
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ind-utiliz AS CHARACTER FORMAT "X(256)":U
     LABEL "Indicativo Utiliza‡Æo"
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-conhecto AS CHARACTER FORMAT "X(256)":U
     LABEL "Tipo"
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE cb-via-transporte AS CHARACTER FORMAT "X(256)":U
     LABEL "Via Transporte"
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-transp AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 98 BY 1.25.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 98 BY 5.17.

DEFINE RECTANGLE RECT-77
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 31 BY 4.

DEFINE RECTANGLE RECT-78
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 98 BY 2.21.

DEFINE RECTANGLE RECT-80
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 98 BY 2.33.

DEFINE BUTTON btAddEmbalagem
     IMAGE-UP FILE "image/im-add.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-add.bmp":U
     LABEL "Adiciona Embalagem"
     SIZE 4 BY 1.25 TOOLTIP "Adiciona Embalagem"
     FONT 4.

DEFINE BUTTON btCanEmbalagem
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Save"
     SIZE 4 BY 1.25 TOOLTIP "Cancela InclusÆo de Embalagem"
     FONT 4.

DEFINE BUTTON btDelEmbalagem
     IMAGE-UP FILE "image/im-era.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-era.bmp":U
     LABEL "Excluir"
     SIZE 4 BY 1.25 TOOLTIP "Remove Embalagem"
     FONT 4.

DEFINE BUTTON btSaveEmbalagem
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save"
     SIZE 4 BY 1.25 TOOLTIP "Salva Embalagem"
     FONT 4.

DEFINE VARIABLE c-desc-agente-carga AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 44.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-pais-proced AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 44.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-81
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 93 BY 1.29.

DEFINE RECTANGLE RECT-82
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 93 BY 1.25.

DEFINE RECTANGLE RECT-83
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 39 BY 4.75.

DEFINE RECTANGLE RECT-84
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 39 BY 2.63.

DEFINE RECTANGLE RECT-85
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 53 BY 7.58.

DEFINE BUTTON btAddHistorico
     IMAGE-UP FILE "image/im-add.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-add.bmp":U
     LABEL "Adiciona Processo Vinculado"
     SIZE 4 BY 1.25 TOOLTIP "Adiciona Hist¢rico"
     FONT 4.

DEFINE BUTTON btAddSon1
     LABEL "Incluir"
     SIZE 10 BY 1.

DEFINE BUTTON btAtualizaEmb
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-enter.bmp":U
     LABEL "Atualizar"
     SIZE 4 BY 1.25 TOOLTIP "Atualizar"
     FONT 4.

DEFINE BUTTON btCanHistorico
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Save"
     SIZE 4 BY 1.25 TOOLTIP "Cancela InclusÆo Hist¢rico"
     FONT 4.

DEFINE BUTTON btDeleteSon1
     LABEL "Eliminar"
     SIZE 10 BY 1.

DEFINE BUTTON btn-efetiva
     IMAGE-UP FILE "image/im-edl.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-edl.bmp":U
     LABEL ""
     SIZE 4 BY 1.25 TOOLTIP "Efetiva Automaticamente Ponto de Controle".

DEFINE BUTTON btn-muda-sequencia
     IMAGE-UP FILE "image/im-seqni":U
     IMAGE-INSENSITIVE FILE "image/ii-seqhi.bmp":U
     LABEL ""
     SIZE 4 BY 1.25 TOOLTIP "Altera Sequˆncias".

DEFINE BUTTON btSaveHistorico
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save"
     SIZE 4 BY 1.25 TOOLTIP "Salva Hist¢rico"
     FONT 4.

DEFINE BUTTON btUpdateHistorico
     IMAGE-UP FILE "image/im-clr.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-clr.bmp":U
     LABEL ""
     SIZE 4 BY 1.25 TOOLTIP "Alterar Hist¢rico"
     FONT 4.

DEFINE BUTTON btUpdateSon1
     LABEL "Alterar"
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-embarq AS CHARACTER FORMAT "x(16)"
     LABEL "Embarque"
     VIEW-AS FILL-IN
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ponto-nacionaliz AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-pto-nacionaliz AS INTEGER FORMAT ">>>>9" INITIAL 0
     LABEL "Ponto Nacionaliza‡Æo"
     VIEW-AS FILL-IN
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE rs-tipo-apresentacao AS INTEGER
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS
          "DI", 1,
"Embarque", 2
     SIZE 15 BY .75 TOOLTIP "Tipo Apresenta‡Æo" NO-UNDO.

DEFINE BUTTON btAddDespesa
     IMAGE-UP FILE "image/im-add.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-add.bmp":U
     LABEL "Adiciona Despesa"
     SIZE 4 BY 1.25 TOOLTIP "Adiciona Despesa"
     FONT 4.

DEFINE BUTTON btAddSon2
     LABEL "Incluir"
     SIZE 12 BY 1.

DEFINE BUTTON btAtualizaEmb-desp
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-enter.bmp":U
     LABEL "Atualizar"
     SIZE 4 BY 1.25 TOOLTIP "Atualizar"
     FONT 4.

DEFINE BUTTON btCanDespesa
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Save"
     SIZE 4 BY 1.25 TOOLTIP "Cancela InclusÆo Despesa"
     FONT 4.

DEFINE BUTTON btConfere-desp
     LABEL "Conferˆncia"
     SIZE 12 BY 1.

DEFINE BUTTON btDeleteSon2
     LABEL "Eliminar"
     SIZE 12 BY 1.

DEFINE BUTTON btSaveDespesa
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save"
     SIZE 4 BY 1.25 TOOLTIP "Salva Despesa"
     FONT 4.

DEFINE BUTTON btUpdateDespesa
     IMAGE-UP FILE "image/im-clr.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-clr.bmp":U
     LABEL ""
     SIZE 4 BY 1.25 TOOLTIP "Altera Despesa"
     FONT 4.

DEFINE BUTTON btUpdateSon2
     LABEL "Alterar"
     SIZE 12 BY 1.

DEFINE VARIABLE c-cod-emb-desp AS CHARACTER FORMAT "x(16)"
     LABEL "Embarque"
     VIEW-AS FILL-IN
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE rs-apres-despesa AS INTEGER
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS
          "DI", 1,
"Embarque", 2
     SIZE 26 BY .75 TOOLTIP "Tipo Apresenta‡Æo" NO-UNDO.

DEFINE VARIABLE label-fcp AS CHARACTER FORMAT "X(256)":U INITIAL "FCP"
      VIEW-AS TEXT
     SIZE 5 BY .54 NO-UNDO.

DEFINE VARIABLE label-fcp-st AS CHARACTER FORMAT "X(256)":U INITIAL "FCP ST"
      VIEW-AS TEXT
     SIZE 6.57 BY .54 NO-UNDO.

DEFINE VARIABLE label-icms-compl AS CHARACTER FORMAT "X(256)":U INITIAL "ICMS Compl"
      VIEW-AS TEXT
     SIZE 9.57 BY .54 NO-UNDO.

DEFINE VARIABLE label-icms-st AS CHARACTER FORMAT "X(256)":U INITIAL "ICMS ST"
      VIEW-AS TEXT
     SIZE 6.57 BY .54 NO-UNDO.

DEFINE VARIABLE v-base-cofins AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-base-fcp AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-base-fcp-st AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-base-icms AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-base-icms-compl AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-base-icms-st AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-base-II AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-base-ipi AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-base-pis AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-cofins AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-fcp AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-fcp-st AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-icms AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-icms-compl AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-icms-st AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-ii AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-ipi AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-pis AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-cofins AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-fcp AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-fcp-st AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-icms AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-icms-compl AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-icms-st AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-ii AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-ipi AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-pis AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-cofins AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-fcp AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-fcp-st AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-icms AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-icms-compl AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-icms-st AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-ii AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-ipi AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-pis AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-total-outros AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-total-recolhe AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-total-suspenso AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-86
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 96 BY 11.75.

DEFINE VARIABLE v-base-ibsuf AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-base-is AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-ibsuf AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-is AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-ibsuf AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-is AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-ibsuf AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-is AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-cdn-moed-acresc AS CHARACTER FORMAT "X(30)"
     LABEL "Acr‚scimos"
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cdn-moed-frete AS CHARACTER FORMAT "X(30)"
     LABEL "Frete"
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cdn-moed-seguro AS CHARACTER FORMAT "X(30)"
     LABEL "Seguro"
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cdn-moed-tot-desp-compl AS CHARACTER FORMAT "X(30)"
     LABEL "Tot. Desp. Complementar"
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cdn-moed-tot-desp-di AS CHARACTER FORMAT "X(30)"
     LABEL "Tot. Despesa DI"
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cdn-moed-tot-desp-nac AS CHARACTER FORMAT "X(30)"
     LABEL "Tot. Desp. At‚ Nacion."
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cdn-moed-vmcv AS CHARACTER FORMAT "X(30)"
     LABEL "VMCV"
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cdn-moed-vmld AS CHARACTER FORMAT "X(30)"
     LABEL "VMLD"
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cdn-moed-vmle AS CHARACTER FORMAT "X(30)"
     LABEL "VMLE"
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-tot-val-desp-compl AS DECIMAL FORMAT "->>,>>>,>>>,>>9.9999999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-tot-val-desp-compl-me AS DECIMAL FORMAT "->>,>>>,>>>,>>9.9999999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-tot-val-desp-di AS DECIMAL FORMAT "->>,>>>,>>>,>>9.9999999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-tot-val-desp-di-me AS DECIMAL FORMAT "->>,>>>,>>>,>>9.9999999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-tot-val-desp-nacion AS DECIMAL FORMAT "->>,>>>,>>>,>>9.9999999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-tot-val-desp-nacion-me AS DECIMAL FORMAT "->>,>>>,>>>,>>9.9999999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-acresc AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .79 NO-UNDO.

DEFINE VARIABLE d-val-acresc-me AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .79 NO-UNDO.

DEFINE VARIABLE d-val-frete AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-frete-me AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-seguro AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-seguro-me AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-vmcv AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-vmcv-me AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-vmld AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-vmld-me AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-vmle AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-vmle-me AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0
     VIEW-AS FILL-IN
     SIZE 16 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDespesa FOR
      tt-despes-decla-import SCROLLING.

DEFINE QUERY brEmbalagem FOR
      tt-decla-import-embal SCROLLING.

DEFINE QUERY brHistorico FOR
      tt-histor-decla-import SCROLLING.

DEFINE QUERY brProcessoVinc FOR
      tt-decla-imp-proc-aux SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDespesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDespesa wMaintenance _FREEFORM
  QUERY brDespesa NO-LOCK DISPLAY
      tt-despes-decla-import.desc-tipo                   column-label 'Tipo Incide NF'
        tt-despes-decla-import.cdn-pto-control           column-label 'Pto. Controle'
        fnDescricaoPtoControle(tt-despes-decla-import.num-di-ems, tt-despes-decla-import.cdd-siscomex-dts, tt-despes-decla-import.cdn-pto-control) @ c-brw-desc-pto-control      column-label 'Descri‡Æo'
        tt-despes-decla-import.cdn-despes                column-label 'Despesa'
        fnDescDespes(tt-despes-decla-import.cdn-despes, tt-despes-decla-import.num-di-ems, tt-despes-decla-import.cdd-siscomex-dts) @ c-brw-desc-despes column-label 'Descri‡Æo'
        tt-despes-decla-import.cdn-emit-despes           column-label 'Fornec'
        fnNomeAbrev(tt-despes-decla-import.cdn-emit-despes) @ c-brw-nome-abrev column-label 'Nome Abreviado'
        tt-despes-decla-import.cdn-cond-pagto            column-label 'Cond Pagto'
        fnDescPagto(tt-despes-decla-import.cdn-cond-pagto) @ c-brw-desc-pagto column-label 'Descri‡Æo'
        tt-despes-decla-import.cdn-moed                  column-label 'Moeda'
        tt-despes-decla-import.val-desp                  column-label 'Vlr Desp'
        tt-despes-decla-import.val-cotac-despes-compltar column-label 'Cota‡Æo Desp. Compl.'
        tt-despes-decla-import.log-incid-vmle               column-label 'Incide VMLE' FORMAT "S/N"
    ENABLE
        tt-despes-decla-import.desc-tipo HELP "N-Nacionaliza‡Æo C-Complementar"
                                         VALIDATE(tt-despes-decla-import.desc-tipo = "Nacionaliza‡Æo" OR tt-despes-decla-import.desc-tipo = "Complementar", "Tipo deve ser N ou C")
        tt-despes-decla-import.cdn-despes
        tt-despes-decla-import.cdn-emit-despes
        tt-despes-decla-import.cdn-cond-pagto
        tt-despes-decla-import.cdn-moed
        tt-despes-decla-import.val-desp
        tt-despes-decla-import.val-cotac-despes-compltar
        tt-despes-decla-import.log-incid-vmle
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 85 BY 7.92
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brEmbalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brEmbalagem wMaintenance _FREEFORM
  QUERY brEmbalagem NO-LOCK DISPLAY
      tt-decla-import-embal.qtd-vol-embal FORMAT ">>>,>>9":U COLUMN-LABEL "Volume Embalagem"
      tt-decla-import-embal.cod-sig-embal FORMAT "!xx":U     COLUMN-LABEL "Sigla"
      ENABLE
          tt-decla-import-embal.qtd-vol-embal
          tt-decla-import-embal.cod-sig-embal
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 38 BY 6
         FONT 1 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE brHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brHistorico wMaintenance _FREEFORM
  QUERY brHistorico NO-LOCK DISPLAY
      tt-histor-decla-import.num-seq         FORMAT ">>9":U
      tt-histor-decla-import.cdn-pto-control FORMAT ">>,>>9":U
      tt-histor-decla-import.descricao
      tt-histor-decla-import.dat-prev-origin FORMAT "99/99/9999":U
      tt-histor-decla-import.dat-ult-prev    FORMAT "99/99/9999":U
      tt-histor-decla-import.dat-efetiva     FORMAT "99/99/9999":U
      fnCalculaDiferenca(tt-histor-decla-import.num-seq,tt-histor-decla-import.cdd-siscomex-dts,tt-histor-decla-import.dat-efetiva) @ i-diferenca COLUMN-LABEL "Diferen‡a" WIDTH 8
      tt-histor-decla-import.cod-meio-transp FORMAT "x(20)":U
      tt-histor-decla-import.nr-dias
      fnUF(tt-histor-decla-import.num-di-ems, tt-histor-decla-import.cdn-pto-control, tt-histor-decla-import.cdd-siscomex-dts) @ c-cod-uf FORMAT "x(04)":U COLUMN-LABEL "UF":U
      tt-histor-decla-import.dsl-obs         FORMAT "x(2000)":U
    ENABLE
        tt-histor-decla-import.num-seq
        tt-histor-decla-import.cdn-pto-control
        tt-histor-decla-import.descricao
        tt-histor-decla-import.dat-prev-origin
        tt-histor-decla-import.dat-efetiva
        tt-histor-decla-import.cod-meio-transp
        tt-histor-decla-import.dsl-obs

        tt-histor-decla-import.dat-ult-prev
        tt-histor-decla-import.nr-dias
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 85 BY 7.92
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brProcessoVinc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brProcessoVinc wMaintenance _FREEFORM
  QUERY brProcessoVinc NO-LOCK DISPLAY
      tt-decla-imp-proc-aux.desc-tipo         FORMAT "X(23)" COLUMN-LABEL "Tipo"
      tt-decla-imp-proc-aux.cod-proces-vincul FORMAT "x(20)":U
      ENABLE
          tt-decla-imp-proc-aux.desc-tipo
          tt-decla-imp-proc-aux.cod-proces-vincul
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 40 BY 4.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btFiltro AT ROW 1.13 COL 25.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 29.57 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 33.57 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 37.57 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 41.57 HELP
          "Elimina ocorrˆncia corrente"
     btUndo AT ROW 1.13 COL 45.57 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 49.57 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 53.57 HELP
          "Confirma altera‡äes"
     btConfTrib AT ROW 1.13 COL 59 HELP
          "Confirma altera‡äes" WIDGET-ID 2
     btCotacaoDi AT ROW 1.13 COL 63.14 HELP
          "Confirma altera‡äes"
     btRateio AT ROW 1.13 COL 67.14 HELP
          "Confirma altera‡äes"
     btVincEmb AT ROW 1.13 COL 71.29 HELP
          "Confirma altera‡äes"
     btAdicoes AT ROW 1.13 COL 75.29 HELP
          "Confirma altera‡äes"
     btRetificacao AT ROW 1.13 COL 79.29 HELP
          "Confirma altera‡äes"
     btDocRelac AT ROW 1.13 COL 83.43 HELP
          "Confirma altera‡äes"
     btQueryJoins AT ROW 1.13 COL 87.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 91.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 95.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 99.57 HELP
          "Ajuda"
     tt-decla-import.num-di-ems AT ROW 2.88 COL 13.43 COLON-ALIGNED
          LABEL "DI EMS"
          VIEW-AS FILL-IN
          SIZE 9 BY .88
     tt-decla-import.cod-di-siscomex AT ROW 2.88 COL 33.57 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 21 BY .88
     tt-decla-import.num-seq-retif AT ROW 2.88 COL 54.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN
          SIZE 4 BY .88
     cb-motivo-retif AT ROW 2.88 COL 67.29 COLON-ALIGNED
     tt-decla-import.cod-estab AT ROW 3.88 COL 13.43 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 9 BY .88
     tt-decla-import.dat-di AT ROW 3.88 COL 33.57 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 12 BY .88
     tt-decla-import.dat-retif AT ROW 3.88 COL 67.29 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 12 BY .88
     v-base-ibsmun AT ROW 8.75 COL 14.29 COLON-ALIGNED NO-LABEL WIDGET-ID 264
     v-base-ibsmun-2 AT ROW 8.75 COL 14.29 COLON-ALIGNED NO-LABEL WIDGET-ID 280
     v-susp-ibsmun-2 AT ROW 8.75 COL 32.57 COLON-ALIGNED NO-LABEL WIDGET-ID 292
     v-susp-ibsmun AT ROW 8.75 COL 32.57 COLON-ALIGNED NO-LABEL WIDGET-ID 266
     v-recolhe-ibsmun-2 AT ROW 8.75 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 288
     v-recolhe-ibsmun AT ROW 8.75 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 270
     v-outros-ibsmun-2 AT ROW 8.75 COL 69.14 COLON-ALIGNED NO-LABEL WIDGET-ID 284
     v-outros-ibsmun AT ROW 8.75 COL 69.14 COLON-ALIGNED NO-LABEL WIDGET-ID 268
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 104 BY 17.75
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     v-base-cbs AT ROW 9.75 COL 14.29 COLON-ALIGNED NO-LABEL WIDGET-ID 232
     v-base-cbs-2 AT ROW 9.75 COL 14.29 COLON-ALIGNED NO-LABEL WIDGET-ID 278
     v-susp-cbs-2 AT ROW 9.75 COL 32.57 COLON-ALIGNED NO-LABEL WIDGET-ID 290
     v-susp-cbs AT ROW 9.75 COL 32.57 COLON-ALIGNED NO-LABEL WIDGET-ID 250
     v-recolhe-cbs-2 AT ROW 9.75 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 286
     v-recolhe-cbs AT ROW 9.75 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 244
     v-outros-cbs AT ROW 9.75 COL 69.14 COLON-ALIGNED NO-LABEL WIDGET-ID 238
     v-outros-cbs-2 AT ROW 9.75 COL 69.14 COLON-ALIGNED NO-LABEL WIDGET-ID 282
     v-total-susp-trib AT ROW 11.25 COL 32.57 COLON-ALIGNED NO-LABEL WIDGET-ID 260
     v-total-susp-trib-2 AT ROW 11.25 COL 32.57 COLON-ALIGNED NO-LABEL WIDGET-ID 298
     v-total-recolhe-trib-2 AT ROW 11.25 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 296
     v-total-recolhe-trib AT ROW 11.25 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 258
     v-total-outros-trib-2 AT ROW 11.25 COL 69.14 COLON-ALIGNED NO-LABEL WIDGET-ID 294
     v-total-outros-trib AT ROW 11.25 COL 69.14 COLON-ALIGNED NO-LABEL WIDGET-ID 256
     "IBS Mun" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 8.88 COL 8 WIDGET-ID 272
     "CBS" VIEW-AS TEXT
          SIZE 5.29 BY .54 AT ROW 9.88 COL 8 WIDGET-ID 216
     "Total" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 11.42 COL 8 WIDGET-ID 224
     "IBS Mun" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 8.88 COL 8 WIDGET-ID 262
     "CBS" VIEW-AS TEXT
          SIZE 5.29 BY .54 AT ROW 9.88 COL 8 WIDGET-ID 276
     "Total" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 11.42 COL 8 WIDGET-ID 274
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 104 BY 17.75
         FONT 1.

DEFINE FRAME fPage7
     v-base-ibsuf AT ROW 2.5 COL 11.57 COLON-ALIGNED NO-LABEL WIDGET-ID 236
     v-susp-ibsuf AT ROW 2.5 COL 29.86 COLON-ALIGNED NO-LABEL WIDGET-ID 254
     v-recolhe-ibsuf AT ROW 2.5 COL 48.14 COLON-ALIGNED NO-LABEL WIDGET-ID 248
     v-outros-ibsuf AT ROW 2.5 COL 66.43 COLON-ALIGNED NO-LABEL WIDGET-ID 242
     v-base-ibsmun AT ROW 3.5 COL 11.57 COLON-ALIGNED NO-LABEL WIDGET-ID 264 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN
          SIZE 18 BY .88
     v-susp-ibsmun AT ROW 3.5 COL 29.86 COLON-ALIGNED NO-LABEL WIDGET-ID 266 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN
          SIZE 18 BY .88
     v-recolhe-ibsmun AT ROW 3.5 COL 48.14 COLON-ALIGNED NO-LABEL WIDGET-ID 270 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN
          SIZE 18 BY .88
     v-outros-ibsmun AT ROW 3.5 COL 66.43 COLON-ALIGNED NO-LABEL WIDGET-ID 268 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN
          SIZE 18 BY .88
     v-base-cbs AT ROW 4.5 COL 11.57 COLON-ALIGNED NO-LABEL WIDGET-ID 232 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN
          SIZE 18 BY .88
     v-susp-cbs AT ROW 4.5 COL 29.86 COLON-ALIGNED NO-LABEL WIDGET-ID 250 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN
          SIZE 18 BY .88
     v-recolhe-cbs AT ROW 4.5 COL 48.14 COLON-ALIGNED NO-LABEL WIDGET-ID 244 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN
          SIZE 18 BY .88
     v-outros-cbs AT ROW 4.5 COL 66.43 COLON-ALIGNED NO-LABEL WIDGET-ID 238 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN
          SIZE 18 BY .88
     v-base-is AT ROW 5.5 COL 11.57 COLON-ALIGNED NO-LABEL WIDGET-ID 274
     v-susp-is AT ROW 5.5 COL 29.86 COLON-ALIGNED NO-LABEL WIDGET-ID 276
     v-recolhe-is AT ROW 5.5 COL 48.14 COLON-ALIGNED NO-LABEL WIDGET-ID 278
     v-outros-is AT ROW 5.5 COL 66.43 COLON-ALIGNED NO-LABEL WIDGET-ID 280
     v-total-susp-trib AT ROW 6.83 COL 29.86 COLON-ALIGNED NO-LABEL WIDGET-ID 260 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN
          SIZE 18 BY .88
     v-total-recolhe-trib AT ROW 6.83 COL 48.14 COLON-ALIGNED NO-LABEL WIDGET-ID 258 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN
          SIZE 18 BY .88
     v-total-outros-trib AT ROW 6.83 COL 66.43 COLON-ALIGNED NO-LABEL WIDGET-ID 256 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN
          SIZE 18 BY .88
     "Base C lculo" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 1.46 COL 17.43 WIDGET-ID 214
     "A Recolher" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1.46 COL 54.29 WIDGET-ID 228
     "IBS UF" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 2.63 COL 5.29 WIDGET-ID 230
     "Imposto" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.46 COL 5.43 WIDGET-ID 226
     "Outros" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.46 COL 73.29 WIDGET-ID 218
     "IS" VIEW-AS TEXT
          SIZE 5.29 BY .54 AT ROW 5.63 COL 5.29 WIDGET-ID 272
     "Suspenso" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.46 COL 37 WIDGET-ID 222
     "IBS Mun" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 3.63 COL 5.29 WIDGET-ID 262
     "Total" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 7 COL 5.29 WIDGET-ID 224
     "CBS" VIEW-AS TEXT
          SIZE 5.29 BY .54 AT ROW 4.63 COL 5.29 WIDGET-ID 216
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 3.57 ROW 6.25
         SIZE 99.43 BY 12.25
         FONT 1.

DEFINE FRAME fPage1
     cb-tipo-declaracao AT ROW 1.38 COL 17.14 COLON-ALIGNED
     cb-carac-oper AT ROW 3 COL 17.14 COLON-ALIGNED
     tt-decla-import.cdn-consign AT ROW 4 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 10 BY .88
     c-nome-abrev AT ROW 4 COL 27.14 COLON-ALIGNED NO-LABEL
     fi-cod-despachante AT ROW 5.04 COL 17.14 COLON-ALIGNED
     c-nome-abrev-desp AT ROW 5.04 COL 27.14 COLON-ALIGNED NO-LABEL
     cb-mod-desp AT ROW 6.63 COL 62 COLON-ALIGNED
     tt-decla-import.log-fundap AT ROW 6.67 COL 19.14
          VIEW-AS TOGGLE-BOX
          SIZE 11.86 BY .88
     tt-decla-import.num-adicoes AT ROW 8 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 10 BY .88
     tt-decla-import.cod-natur-operac AT ROW 9 COL 17.14 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 10 BY .88
     c-des-nat-operacao AT ROW 9 COL 27.14 COLON-ALIGNED NO-LABEL
     btObservacao AT ROW 10.5 COL 2
     cb-rateio-desp-nacio AT ROW 10.54 COL 13.57
     cb-rateio-desp-comp AT ROW 10.54 COL 41
     cb-calculo-impostos AT ROW 10.54 COL 68.29
     RECT-1 AT ROW 1.17 COL 1
     RECT-2 AT ROW 2.67 COL 1
     RECT-3 AT ROW 6.42 COL 1
     RECT-4 AT ROW 6.42 COL 46
     RECT-5 AT ROW 7.79 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 3.57 ROW 6.25
         SIZE 99.43 BY 12.25
         FONT 1.

DEFINE FRAME fPage2
     tt-decla-import.cdn-urf-entr AT ROW 1.33 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 8 BY .88
     tt-decla-import.cdn-urf-despch AT ROW 1.33 COL 50.86 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 8 BY .88
     cb-via-transporte AT ROW 2.71 COL 17 COLON-ALIGNED
     tt-decla-import.cdn-transpdor AT ROW 2.71 COL 50.86 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 6 BY .88
     c-desc-transp AT ROW 2.71 COL 57 COLON-ALIGNED NO-LABEL
     cb-docto-carg AT ROW 3.71 COL 17 COLON-ALIGNED
     tt-decla-import.cod-identif AT ROW 3.71 COL 50.86 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 25 BY .88
     cb-tipo-conhecto AT ROW 5.5 COL 17 COLON-ALIGNED
     cb-ind-utiliz AT ROW 6.5 COL 17 COLON-ALIGNED
     tt-decla-import.cod-conhecto-master AT ROW 5.5 COL 70 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 19 BY .88
     tt-decla-import.cod-conhecto-house AT ROW 6.5 COL 70 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 19 BY .88
     btAddProcessoVinc AT ROW 7.96 COL 43.72 HELP
          "Confirma altera‡äes"
     brProcessoVinc AT ROW 8.25 COL 3
     btCanProcVinc AT ROW 9.17 COL 43.72 HELP
          "Confirma altera‡äes"
     btSaveProcessoVinc AT ROW 10.38 COL 43.72 HELP
          "Confirma altera‡äes"
     btDelProcessoVinc AT ROW 11.58 COL 43.72 HELP
          "Confirma altera‡äes"
     "Conhecimento Transporte" VIEW-AS TEXT
          SIZE 19.43 BY .54 AT ROW 4.88 COL 4
     "Tipos Processo Vinculado" VIEW-AS TEXT
          SIZE 22 BY .54 AT ROW 8.21 COL 53.86
     "4 - Judicial Exclusivo DARF" VIEW-AS TEXT
          SIZE 27 BY .54 AT ROW 11.58 COL 52.86
     "2 - Judicial" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 9.96 COL 52.86
     "1 - Administrativo" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 9.13 COL 52.86
     "Processo Vinculado" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 7.58 COL 4
     "3 - Declara‡Æo Preliminar" VIEW-AS TEXT
          SIZE 25 BY .54 AT ROW 10.75 COL 52.86
     RECT-78 AT ROW 2.54 COL 1.72
     RECT-80 AT ROW 5.21 COL 1.72
     RECT-6 AT ROW 1.17 COL 1.72
     RECT-7 AT ROW 7.83 COL 1.72
     RECT-77 AT ROW 8.5 COL 50.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 3.57 ROW 6.25
         SIZE 99.43 BY 12.25
         FONT 1.

DEFINE FRAME fPage3
     tt-decla-import.cdn-pais-proceden AT ROW 1.38 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 8 BY .88
     c-desc-pais-proced AT ROW 1.38 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     tt-decla-import.cdn-agent-carg-import AT ROW 2.63 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 8 BY .88
     c-desc-agente-carga AT ROW 2.63 COL 24.14 COLON-ALIGNED NO-LABEL
     tt-decla-import.val-peso-liq-di AT ROW 4.33 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 19.72 BY .88
     brEmbalagem AT ROW 4.5 COL 44.86
     btAddEmbalagem AT ROW 5.04 COL 83.86 HELP
          "Confirma altera‡äes"
     tt-decla-import.val-peso-brut-merc AT ROW 5.33 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 19.72 BY .88
     btCanEmbalagem AT ROW 6.25 COL 83.86 HELP
          "Confirma altera‡äes"
     tt-decla-import.val-peso-embal-di AT ROW 6.33 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 19.72 BY .88
     tt-decla-import.val-peso-brut-tot-di AT ROW 7.33 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 19.72 BY .88
     btSaveEmbalagem AT ROW 7.46 COL 83.86 HELP
          "Confirma altera‡äes"
     btDelEmbalagem AT ROW 8.67 COL 83.86 HELP
          "Confirma altera‡äes"
     tt-decla-import.cdn-recinto-alfand AT ROW 9.38 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 10 BY .88
     tt-decla-import.cdn-setor-armaz AT ROW 10.38 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 10 BY .88
     "Pesos" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3.75 COL 3.57
     "Local Armazenagem" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 8.71 COL 5
     RECT-81 AT ROW 1.21 COL 2
     RECT-82 AT ROW 2.5 COL 2
     RECT-83 AT ROW 3.92 COL 2
     RECT-84 AT ROW 8.88 COL 2
     RECT-85 AT ROW 3.92 COL 42
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 3.57 ROW 6.25
         SIZE 99.43 BY 12.25
         FONT 1.

DEFINE FRAME fPage4
     btAtualizaEmb AT ROW 1 COL 88 HELP
          "Confirma altera‡äes"
     c-cod-embarq AT ROW 1.17 COL 69 COLON-ALIGNED HELP
          "C¢digo Embarque"
     i-cdn-pto-nacionaliz AT ROW 1.21 COL 15.29 COLON-ALIGNED HELP
          "C¢digo - Num‚rico Ponto Nacionaliza‡Æo"
     c-desc-ponto-nacionaliz AT ROW 1.21 COL 22 COLON-ALIGNED NO-LABEL
     rs-tipo-apresentacao AT ROW 1.25 COL 46.72 NO-LABEL
     btn-efetiva AT ROW 2.21 COL 88
     brHistorico AT ROW 2.25 COL 2
     btn-muda-sequencia AT ROW 3.46 COL 88
     btAddHistorico AT ROW 4.71 COL 88 HELP
          "Confirma altera‡äes"
     btUpdateHistorico AT ROW 5.92 COL 88 HELP
          "Confirma altera‡äes"
     btCanHistorico AT ROW 7.13 COL 88 HELP
          "Confirma altera‡äes"
     btSaveHistorico AT ROW 8.33 COL 88 HELP
          "Confirma altera‡äes"
     btAddSon1 AT ROW 10.33 COL 2
     btUpdateSon1 AT ROW 10.33 COL 12
     btDeleteSon1 AT ROW 10.33 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 3.57 ROW 6.25
         SIZE 99.43 BY 12.25
         FONT 1.

DEFINE FRAME fPage5
     btAtualizaEmb-desp AT ROW 1 COL 54.57 HELP
          "Confirma altera‡äes"
     c-cod-emb-desp AT ROW 1.21 COL 35 COLON-ALIGNED HELP
          "C¢digo Embarque"
     rs-apres-despesa AT ROW 1.25 COL 2 NO-LABEL
     brDespesa AT ROW 2.25 COL 2
     btAddDespesa AT ROW 2.25 COL 88 HELP
          "Confirma altera‡äes"
     btUpdateDespesa AT ROW 3.46 COL 88 HELP
          "Confirma altera‡äes"
     btCanDespesa AT ROW 4.67 COL 88 HELP
          "Confirma altera‡äes"
     btSaveDespesa AT ROW 5.88 COL 88 HELP
          "Confirma altera‡äes"
     btAddSon2 AT ROW 10.33 COL 2
     btUpdateSon2 AT ROW 10.33 COL 13.86
     btDeleteSon2 AT ROW 10.33 COL 25.72
     btConfere-desp AT ROW 10.33 COL 37.57
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 3.57 ROW 6.25
         SIZE 99.43 BY 12.25
         FONT 1.

DEFINE FRAME fPage6
     v-base-II AT ROW 2.46 COL 13 COLON-ALIGNED NO-LABEL
     v-susp-ii AT ROW 2.46 COL 31.29 COLON-ALIGNED NO-LABEL
     v-recolhe-ii AT ROW 2.46 COL 49.57 COLON-ALIGNED NO-LABEL
     v-outros-ii AT ROW 2.46 COL 67.86 COLON-ALIGNED NO-LABEL
     v-base-ipi AT ROW 3.46 COL 13 COLON-ALIGNED NO-LABEL
     v-susp-ipi AT ROW 3.46 COL 31.29 COLON-ALIGNED NO-LABEL
     v-recolhe-ipi AT ROW 3.46 COL 49.57 COLON-ALIGNED NO-LABEL
     v-outros-ipi AT ROW 3.46 COL 67.86 COLON-ALIGNED NO-LABEL
     v-base-pis AT ROW 4.46 COL 13 COLON-ALIGNED NO-LABEL
     v-susp-pis AT ROW 4.46 COL 31.29 COLON-ALIGNED NO-LABEL
     v-recolhe-pis AT ROW 4.46 COL 49.57 COLON-ALIGNED NO-LABEL
     v-outros-pis AT ROW 4.46 COL 67.86 COLON-ALIGNED NO-LABEL
     v-base-cofins AT ROW 5.46 COL 13 COLON-ALIGNED NO-LABEL
     v-susp-cofins AT ROW 5.46 COL 31.29 COLON-ALIGNED NO-LABEL
     v-recolhe-cofins AT ROW 5.46 COL 49.57 COLON-ALIGNED NO-LABEL
     v-outros-cofins AT ROW 5.46 COL 67.86 COLON-ALIGNED NO-LABEL
     v-base-icms AT ROW 6.46 COL 13 COLON-ALIGNED NO-LABEL
     v-susp-icms AT ROW 6.46 COL 31.29 COLON-ALIGNED NO-LABEL
     v-recolhe-icms AT ROW 6.46 COL 49.57 COLON-ALIGNED NO-LABEL
     v-outros-icms AT ROW 6.46 COL 67.86 COLON-ALIGNED NO-LABEL
     v-base-fcp AT ROW 7.46 COL 13 COLON-ALIGNED NO-LABEL WIDGET-ID 182
     v-susp-fcp AT ROW 7.46 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 198
     v-recolhe-fcp AT ROW 7.46 COL 49.57 COLON-ALIGNED NO-LABEL WIDGET-ID 190
     v-outros-fcp AT ROW 7.46 COL 67.86 COLON-ALIGNED NO-LABEL WIDGET-ID 206
     v-base-fcp-st AT ROW 8.46 COL 13 COLON-ALIGNED NO-LABEL WIDGET-ID 184
     v-susp-fcp-st AT ROW 8.46 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 200
     v-recolhe-fcp-st AT ROW 8.46 COL 49.57 COLON-ALIGNED NO-LABEL WIDGET-ID 192
     v-outros-fcp-st AT ROW 8.46 COL 67.86 COLON-ALIGNED NO-LABEL WIDGET-ID 208
     v-base-icms-st AT ROW 9.46 COL 13 COLON-ALIGNED NO-LABEL WIDGET-ID 186
     v-susp-icms-st AT ROW 9.46 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 202
     v-recolhe-icms-st AT ROW 9.46 COL 49.57 COLON-ALIGNED NO-LABEL WIDGET-ID 194
     v-outros-icms-st AT ROW 9.46 COL 67.86 COLON-ALIGNED NO-LABEL WIDGET-ID 210
     v-base-icms-compl AT ROW 10.46 COL 13 COLON-ALIGNED NO-LABEL WIDGET-ID 188
     v-susp-icms-compl AT ROW 10.46 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 204
     v-recolhe-icms-compl AT ROW 10.46 COL 49.57 COLON-ALIGNED NO-LABEL WIDGET-ID 196
     v-outros-icms-compl AT ROW 10.46 COL 67.86 COLON-ALIGNED NO-LABEL WIDGET-ID 212
     v-total-suspenso AT ROW 11.75 COL 31.29 COLON-ALIGNED NO-LABEL
     v-total-recolhe AT ROW 11.75 COL 49.57 COLON-ALIGNED NO-LABEL
     v-total-outros AT ROW 11.75 COL 67.86 COLON-ALIGNED NO-LABEL
     label-fcp AT ROW 7.46 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 174
     label-fcp-st AT ROW 8.46 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 176
     label-icms-st AT ROW 9.46 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 180
     label-icms-compl AT ROW 10.46 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 178
     "Imposto" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.46 COL 5
     "IPI" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3.46 COL 5
     "A Recolher" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1.46 COL 55.86
     "COFINS" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 5.46 COL 5
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 3.57 ROW 6.25
         SIZE 99.43 BY 12.25
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage6
     "Suspenso" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.46 COL 38.57
     "PIS/PASEP" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 4.46 COL 5
     "Outros" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.46 COL 74.86
     "ICMS" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 6.46 COL 5
     "II" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 2.46 COL 5
     "Total" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 11.75 COL 5
     "Base C lculo" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 1.46 COL 19
     RECT-86 AT ROW 1.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 3.57 ROW 6.25
         SIZE 99.43 BY 12.25
         FONT 1.

DEFINE FRAME fPage8
     c-cdn-moed-vmcv AT ROW 2.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto"
     d-val-vmcv-me AT ROW 2.25 COL 42 COLON-ALIGNED HELP
          "Valor Mercadoria na Condi‡Æo Venda" NO-LABEL
     d-val-vmcv AT ROW 2.25 COL 59 COLON-ALIGNED HELP
          "Valor Mercadoria na Condi‡Æo Venda" NO-LABEL
     c-cdn-moed-vmle AT ROW 3.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto"
     d-val-vmle-me AT ROW 3.25 COL 42 COLON-ALIGNED HELP
          "Valor VMLE" NO-LABEL
     d-val-vmle AT ROW 3.25 COL 59 COLON-ALIGNED HELP
          "Valor VMLE" NO-LABEL
     c-cdn-moed-vmld AT ROW 4.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto"
     d-val-vmld-me AT ROW 4.25 COL 42 COLON-ALIGNED HELP
          "Valor mercadoria no local despacho" NO-LABEL
     d-val-vmld AT ROW 4.25 COL 59 COLON-ALIGNED HELP
          "Valor mercadoria no local despacho" NO-LABEL
     c-cdn-moed-frete AT ROW 5.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto"
     d-val-frete-me AT ROW 5.25 COL 42 COLON-ALIGNED HELP
          "Informe o valor do frete" NO-LABEL
     d-val-frete AT ROW 5.25 COL 59 COLON-ALIGNED HELP
          "Informe o valor do frete" NO-LABEL
     c-cdn-moed-seguro AT ROW 6.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto"
     d-val-seguro-me AT ROW 6.25 COL 42 COLON-ALIGNED HELP
          "Valor do seguro" NO-LABEL
     d-val-seguro AT ROW 6.25 COL 59.14 COLON-ALIGNED HELP
          "Valor do seguro" NO-LABEL
     c-cdn-moed-acresc AT ROW 7.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto"
     d-val-acresc-me AT ROW 7.25 COL 42 COLON-ALIGNED HELP
          "Valor Acr‚scimo" NO-LABEL
     d-val-acresc AT ROW 7.25 COL 59.14 COLON-ALIGNED HELP
          "Valor Acr‚scimo" NO-LABEL
     c-cdn-moed-tot-desp-nac AT ROW 8.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto"
     d-tot-val-desp-nacion-me AT ROW 8.25 COL 42 COLON-ALIGNED HELP
          "Valor Acr‚scimos" NO-LABEL
     d-tot-val-desp-nacion AT ROW 8.25 COL 59 COLON-ALIGNED HELP
          "Valor Acr‚scimos" NO-LABEL
     c-cdn-moed-tot-desp-compl AT ROW 9.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto"
     d-tot-val-desp-compl-me AT ROW 9.25 COL 42 COLON-ALIGNED HELP
          "Valor Acr‚scimos" NO-LABEL
     d-tot-val-desp-compl AT ROW 9.25 COL 59 COLON-ALIGNED HELP
          "Valor Acr‚scimos" NO-LABEL
     c-cdn-moed-tot-desp-di AT ROW 10.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto"
     d-tot-val-desp-di-me AT ROW 10.25 COL 42 COLON-ALIGNED HELP
          "Valor Acr‚scimos" NO-LABEL
     d-tot-val-desp-di AT ROW 10.25 COL 59 COLON-ALIGNED HELP
          "Valor Acr‚scimos" NO-LABEL
     "Valor" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.5 COL 56
     "Reais (R$)" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.5 COL 70
     "Moeda" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.5 COL 38
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 3.57 ROW 6.25
         SIZE 99.43 BY 12.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decla-imp-proc T "?" NO-UNDO mgcex decla-import-proc
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-decla-imp-proc-aux T "?" NO-UNDO mgcex decla-import-proc
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
          FIELD desc-tipo AS CHAR
      END-FIELDS.
      TABLE: tt-decla-import T "?" NO-UNDO mgcex decla-import
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-embal T "?" NO-UNDO mgcex decla-import-embal
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-decla-import-embal-aux T "?" NO-UNDO mgcex decla-import-embal
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-desp-embarque T "?" NO-UNDO mgcex desp-embarque
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-despes-decla-import T "?" NO-UNDO mgcex despes-decla-import
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
          FIELD desc-tipo AS CHAR format "x(15)"
      END-FIELDS.
      TABLE: tt-despes-decla-import-aux T "?" NO-UNDO mgcex despes-decla-import
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-histor-decla-import T "?" NO-UNDO mgcex histor-decla-import
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
          index codigo
          num-di-ems
          num-seq
          r-rowid
      END-FIELDS.
      TABLE: tt-histor-decla-import-aux T "?" NO-UNDO mgcex histor-decla-import
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-historico-embarque T "?" NO-UNDO mgcex historico-embarque
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-historico-embarque-aux T "?" NO-UNDO mgcex historico-embarque
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
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
         HEIGHT             = 17.75
         WIDTH              = 104
         MAX-HEIGHT         = 27.54
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.54
         VIRTUAL-WIDTH      = 195.14
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE
       FRAME fPage7:FRAME = FRAME fpage0:HANDLE
       FRAME fPage8:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import.num-di-ems IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN v-base-cbs IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-cbs-2 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-ibsmun IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-ibsmun-2 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-cbs IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-cbs-2 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-ibsmun IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-ibsmun-2 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-cbs IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-cbs-2 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-ibsmun IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-ibsmun-2 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-cbs IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-cbs-2 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-ibsmun IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-ibsmun-2 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-outros-trib IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-outros-trib-2 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-recolhe-trib IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-recolhe-trib-2 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-susp-trib IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-susp-trib-2 IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FRAME fPage2
   Custom                                                               */
/* BROWSE-TAB brProcessoVinc btAddProcessoVinc fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brEmbalagem val-peso-liq-di fPage3 */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB brHistorico btn-efetiva fPage4 */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDespesa rs-apres-despesa fPage5 */
/* SETTINGS FOR FRAME fPage6
                                                                        */
/* SETTINGS FOR FILL-IN label-fcp IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-fcp-st IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-icms-compl IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-icms-st IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-cofins IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-fcp IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-fcp-st IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-icms IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-icms-compl IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-icms-st IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-II IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-ipi IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-pis IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-cofins IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-fcp IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-fcp-st IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-icms IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-icms-compl IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-icms-st IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-ii IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-ipi IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-pis IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-cofins IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-fcp IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-fcp-st IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-icms IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-icms-compl IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-icms-st IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-ii IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-ipi IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-pis IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-cofins IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-fcp IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-fcp-st IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-icms IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-icms-compl IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-icms-st IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-ii IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-ipi IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-pis IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-outros IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-recolhe IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-suspenso IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage7
                                                                        */
/* SETTINGS FOR FILL-IN v-base-cbs IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-ibsmun IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-ibsuf IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-base-is IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-cbs IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-ibsmun IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-ibsuf IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-is IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-cbs IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-ibsmun IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-ibsuf IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-is IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-cbs IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-ibsmun IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-ibsuf IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-is IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-outros-trib IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-recolhe-trib IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-susp-trib IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage8
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDespesa
/* Query rebuild information for BROWSE brDespesa
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-despes-decla-import NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brDespesa */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brEmbalagem
/* Query rebuild information for BROWSE brEmbalagem
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-embal NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brEmbalagem */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brHistorico
/* Query rebuild information for BROWSE brHistorico
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-histor-decla-import NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brHistorico */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brProcessoVinc
/* Query rebuild information for BROWSE brProcessoVinc
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-imp-proc-aux NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brProcessoVinc */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage5
/* Query rebuild information for FRAME fPage5
     _Query            is NOT OPENED
*/  /* FRAME fPage5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage7
/* Query rebuild information for FRAME fPage7
     _Options          = "SHARE-LOCK KEEP-EMPTY"
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


&Scoped-define BROWSE-NAME brDespesa
&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME brDespesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDespesa wMaintenance
ON ROW-DISPLAY OF brDespesa IN FRAME fPage5
DO:
    RUN pi-verifica-despesas-embarque.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brEmbalagem
&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME brEmbalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brEmbalagem wMaintenance
ON END-ERROR OF brEmbalagem IN FRAME fPage3
DO:
    if  brEmbalagem:new-row in frame {&frame-name} then do:
        if  avail tt-decla-import-embal then
            delete tt-decla-import-embal.
        if  brEmbalagem:delete-current-row() in frame {&frame-name} then.
    end.
    else do:
       get current brEmbalagem.
       DISPLAY tt-decla-import-embal.qtd-vol-embal
               tt-decla-import-embal.cod-sig-embal with browse brEmbalagem.
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brEmbalagem wMaintenance
ON INS OF brEmbalagem IN FRAME fPage3
DO:
  apply 'choose' to btAddEmbalagem in frame fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brEmbalagem wMaintenance
ON OFF-END OF brEmbalagem IN FRAME fPage3
DO:
  apply 'entry' to btSaveEmbalagem in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brEmbalagem wMaintenance
ON ROW-LEAVE OF brEmbalagem IN FRAME fPage3
DO:
    if  l-zoom = yes /* NÆo executar a row-leave ao executar o zoom */ then
    return no-apply.

    do  transaction on error undo, return no-apply:
        if  brEmbalagem:new-row in frame fPage3 then
            IF NOT CAN-FIND (FIRST tt-decla-import-embal
                             WHERE tt-decla-import-embal.num-di-ems    = tt-decla-import.num-di-ems
                             AND   tt-decla-import-embal.cod-sig-embal = input browse brEmbalagem tt-decla-import-embal.cod-sig-embal
                             AND   tt-decla-import-embal.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts) THEN DO:
                create tt-decla-import-embal.
                assign tt-decla-import-embal.num-di-ems = tt-decla-import.num-di-ems
                       input browse brEmbalagem tt-decla-import-embal.qtd-vol-embal
                       INPUT browse brEmbalagem tt-decla-import-embal.cod-sig-embal
                       tt-decla-import-embal.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts.
            END.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brHistorico
&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME brHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brHistorico wMaintenance
ON MOUSE-SELECT-CLICK OF brHistorico IN FRAME fPage4
DO:
    APPLY 'value-changed':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brHistorico wMaintenance
ON VALUE-CHANGED OF brHistorico IN FRAME fPage4
DO:

    IF  AVAIL tt-histor-decla-import THEN DO:
        /* Se estiver modificando a sequˆncia ou o ponto de controle */
        IF i-modificacao <> 0 THEN DO:
            IF i-modificacao = 1 /* altera‡Æo de sequˆncias */ THEN DO:
                IF tt-histor-decla-import.cdn-pto-control = tt-histor-decla-import.cdn-pto-nacionaliz THEN DO:
                    SELF:SELECT-ROW(i-linha-anterior) NO-ERROR.
                    RETURN.
                END.
            END.
            ELSE IF i-modificacao = 2 /* alterando pto controle */ AND NOT l-alterando THEN DO:
                SELF:SELECT-ROW(i-linha-anterior) NO-ERROR.
                RETURN.
            END.
            ASSIGN i-linha-anterior = brHistorico:FOCUSED-ROW.
        END.

        IF  INPUT FRAME fPage4 rs-tipo-apresentacao = 2 /* Embarque */ THEN DO:
            RUN findFirstEmbarque IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-decla-import.cod-estab,
                                                INPUT INPUT FRAME fPage4 c-cod-embarq,
                                                OUTPUT c-return).
            IF  c-return = "" THEN DO:
                RUN getIntField              IN h-bocx230 (INPUT 'cod-itiner', OUTPUT i-cod-itiner).
                RUN retornaHistoricoEmbarque IN h-bocx407 (INPUT INPUT FRAME fPage0 tt-decla-import.cod-estab,
                                                           INPUT INPUT FRAME fPage4 c-cod-embarq,
                                                           INPUT i-cod-itiner,
                                                           INPUT tt-histor-decla-import.num-seq,
                                                           OUTPUT rGoTo).
            END. /* IF  c-return = "" */

            IF  tt-histor-decla-import.num-seq >= INPUT FRAME fPage4 i-cdn-pto-nacionaliz
            THEN DISABLE btUpdateHistorico WITH FRAME fPage4.
            ELSE ENABLE  btUpdateHistorico WITH FRAME fPage4.
        END. /* IF  rs-tipo-apresentacao = 2 */
        ELSE DO: /* visÆo DI */
            IF i-modificacao = 0 AND log-perm-pto-control-imp THEN DO: /* NÆo est  modificando  e possui permissÆo para alterar */
                ASSIGN btn-efetiva:SENSITIVE IN FRAME fPage4 = IF tt-histor-decla-import.dat-efetiva = ? AND NOT l-alterando THEN YES ELSE NO /* Efetiva‡Æo autom tica */
                       btn-muda-sequencia:SENSITIVE IN FRAME fPage4 = IF tt-histor-decla-import.dat-efetiva = ? AND tt-histor-decla-import.num-seq > i-seq-pto-nacionaliz AND NOT l-alterando THEN YES ELSE NO /* Altera‡Æo de sequencia */.
            END.
            ELSE DO:
                ASSIGN btn-efetiva:SENSITIVE IN FRAME fPage4 = NO
                       btn-muda-sequencia:SENSITIVE IN FRAME fPage4 = NO.
            END.

            /* Verifica se o parƒmetro Permite altera‡Æo pto controle est  ativo, e se a data de efetica‡Æo est  em branco, se sim, libera o botÆo de altra‡Æo do ponto de controle*/
            IF (tt-histor-decla-import.dat-efetiva = ? AND log-perm-pto-control-imp AND i-modificacao = 0) OR l-alterando THEN DO:
                ENABLE  btUpdateHistorico WITH FRAME fPage4.
                ASSIGN btUpdateHistorico:SENSITIVE IN FRAME fPage4 = YES.
            END.
            ELSE DO:
                DISABLE  btUpdateHistorico WITH FRAME fPage4.
                ASSIGN btUpdateHistorico:SENSITIVE IN FRAME fPage4 = NO.
            END.
        END.

        ASSIGN c-cod-uf = SUBSTR(tt-histor-decla-import.cod-livre-1,6,2).
    END. /* IF  AVAIL tt-histor-decla-import */
    ELSE
        ASSIGN c-cod-uf = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brProcessoVinc
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME brProcessoVinc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brProcessoVinc wMaintenance
ON END-ERROR OF brProcessoVinc IN FRAME fPage2
DO:
    if  brProcessoVinc:new-row in frame {&frame-name} then do:
        if  avail tt-decla-imp-proc-aux then
            delete tt-decla-imp-proc-aux.
        if  brProcessoVinc:delete-current-row() in frame {&frame-name} then.
    end.
    else do:
       get current brProcessoVinc.
       DISPLAY tt-decla-imp-proc-aux.desc-tipo
               tt-decla-imp-proc-aux.cod-proces-vincul with browse brProcessoVinc.
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brProcessoVinc wMaintenance
ON INS OF brProcessoVinc IN FRAME fPage2
DO:
    apply 'choose' to btAddProcessoVinc in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brProcessoVinc wMaintenance
ON OFF-END OF brProcessoVinc IN FRAME fPage2
DO:
  apply 'entry' to btSaveProcessoVinc in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brProcessoVinc wMaintenance
ON ROW-DISPLAY OF brProcessoVinc IN FRAME fPage2
DO:
  RUN pi-row-display-processo-vinc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brProcessoVinc wMaintenance
ON ROW-LEAVE OF brProcessoVinc IN FRAME fPage2
DO:
    do  transaction on error undo, return no-apply:
        if  brProcessoVinc:new-row in frame fPage2 then
            IF NOT CAN-FIND (FIRST tt-decla-imp-proc-aux
                             WHERE tt-decla-imp-proc-aux.num-di-ems        = tt-decla-import.num-di-ems
                             AND   tt-decla-imp-proc-aux.cod-proces-vincul = input browse brProcessoVinc tt-decla-imp-proc-aux.cod-proces-vincul
                             AND   tt-decla-imp-proc-aux.cdd-siscomex-dts  = tt-decla-import.cdd-siscomex-dts) THEN DO:
                create tt-decla-imp-proc-aux.
                assign tt-decla-imp-proc-aux.num-di-ems = tt-decla-import.num-di-ems
                       input browse brProcessoVinc tt-decla-imp-proc-aux.desc-tipo
                       INPUT browse brProcessoVinc tt-decla-imp-proc-aux.cod-proces-vincul
                       tt-decla-imp-proc-aux.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts.
            END.
    end.
    /*if brProcessoVinc:new-row then brProcessoVinc:CREATE-RESULT-LIST-ENTRY() in frame {&frame-name}. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.
    RUN pi-botoes (INPUT NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btAddDespesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddDespesa wMaintenance
ON CHOOSE OF btAddDespesa IN FRAME fPage5 /* Adiciona Despesa */
DO:
  RUN pi-add-despesa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btAddEmbalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddEmbalagem wMaintenance
ON CHOOSE OF btAddEmbalagem IN FRAME fPage3 /* Adiciona Embalagem */
DO:
  RUN pi-add-embalagem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btAddHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddHistorico wMaintenance
ON CHOOSE OF btAddHistorico IN FRAME fPage4 /* Adiciona Processo Vinculado */
DO:
  RUN pi-add-historico.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddProcessoVinc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddProcessoVinc wMaintenance
ON CHOOSE OF btAddProcessoVinc IN FRAME fPage2 /* Adiciona Processo Vinculado */
DO:
  RUN pi-add-processo-vinc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMaintenance
ON CHOOSE OF btAddSon1 IN FRAME fPage4 /* Incluir */
DO:
  IF INPUT FRAME fPage4 rs-tipo-apresentacao = 1 THEN
    RUN pi-add-historico-di.
  ELSE
    RUN pi-add-historico-embarque.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btAddSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon2 wMaintenance
ON CHOOSE OF btAddSon2 IN FRAME fPage5 /* Incluir */
DO:
    IF INPUT FRAME fPage5 rs-apres-despesa = 1 /* DI */
    THEN RUN pi-add-despesa-di.
    ELSE RUN pi-add-despesa-embarque.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btAdicoes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdicoes wMaintenance
ON CHOOSE OF btAdicoes IN FRAME fpage0 /* Adi‡äes */
DO:
  RUN pi-Chama410a.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btAtualizaEmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualizaEmb wMaintenance
ON CHOOSE OF btAtualizaEmb IN FRAME fPage4 /* Atualizar */
DO:
  RUN pi-atualiza.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btAtualizaEmb-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualizaEmb-desp wMaintenance
ON CHOOSE OF btAtualizaEmb-desp IN FRAME fPage5 /* Atualizar */
DO:
    RUN pi-atualiza-desp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    ASSIGN l-alterando = FALSE.
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btCanDespesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCanDespesa wMaintenance
ON CHOOSE OF btCanDespesa IN FRAME fPage5 /* Save */
DO:
    RUN pi-canc-despesa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btCanEmbalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCanEmbalagem wMaintenance
ON CHOOSE OF btCanEmbalagem IN FRAME fPage3 /* Save */
DO:
  RUN pi-canc-embalagem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btCanHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCanHistorico wMaintenance
ON CHOOSE OF btCanHistorico IN FRAME fPage4 /* Save */
DO:
    RUN pi-canc-historico.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCanProcVinc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCanProcVinc wMaintenance
ON CHOOSE OF btCanProcVinc IN FRAME fPage2 /* Save */
DO:
  RUN pi-canc-processo-vinc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btConfTrib
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfTrib wMaintenance
ON CHOOSE OF btConfTrib IN FRAME fpage0 /* Configurador de Tributos */
DO:
    IF NOT VALID-HANDLE(h-cd0763) THEN
        RUN cdp/cd0763.w PERSISTENT SET h-cd0763.

    RUN pi-retorna-chave-cd0763 IN h-bocx402 (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                              INPUT tt-decla-import.cdd-siscomex-dts,
                                              OUTPUT i-cod-emitente,
                                              OUTPUT c-nat-operacao).

    RUN pi-set-chave-importacao IN h-cd0763   (INPUT YES,
                                               INPUT i-cod-emitente,
                                               INPUT "", /*s‚rie do documento*/
                                               INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                               INPUT c-nat-operacao,
                                               INPUT "",
                                               INPUT NO).

    RUN initializeInterface IN h-cd0763.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
    RUN pi-botoes (INPUT NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCotacaoDi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCotacaoDi wMaintenance
ON CHOOSE OF btCotacaoDi IN FRAME fpage0 /* Cota‡Æo DI */
DO:
    RUN pi-cotacao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btDelEmbalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelEmbalagem wMaintenance
ON CHOOSE OF btDelEmbalagem IN FRAME fPage3 /* Excluir */
DO:
  RUN pi-exclui-embalagem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMaintenance
ON CHOOSE OF btDeleteSon1 IN FRAME fPage4 /* Eliminar */
DO:
  RUN pi-delete-historico-di.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDeleteSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon2 wMaintenance
ON CHOOSE OF btDeleteSon2 IN FRAME fPage5 /* Eliminar */
DO:
    RUN pi-delete-despesa-di.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDelProcessoVinc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelProcessoVinc wMaintenance
ON CHOOSE OF btDelProcessoVinc IN FRAME fPage2 /* Excluir */
DO:
  RUN pi-exclui-processo-vinc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btDocRelac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDocRelac wMaintenance
ON CHOOSE OF btDocRelac IN FRAME fpage0
DO:
    IF AVAIL tt-decla-import THEN
        RUN pi-busca-doc-relacs.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wMaintenance
ON CHOOSE OF btFiltro IN FRAME fpage0 /* Filtro */
OR CHOOSE OF MENU-ITEM m_Filtro in MENU mbMain DO:
    RUN pi-filtro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btn-efetiva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-efetiva wMaintenance
ON CHOOSE OF btn-efetiva IN FRAME fPage4
DO:
    ASSIGN i-modificacao = 3. /* efetiva‡Æo de ponto */
    RUN pi-salva-historico.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-muda-sequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-muda-sequencia wMaintenance
ON CHOOSE OF btn-muda-sequencia IN FRAME fPage4
DO:
    ASSIGN tt-histor-decla-import.num-seq:READ-ONLY IN BROWSE brHistorico = NO
           i-modificacao = 1
           i-linha-anterior = brHistorico:FOCUSED-ROW
           SELF:SENSITIVE IN FRAME fPage1 = NO.
    APPLY "ENTRY":U TO tt-histor-decla-import.num-seq IN BROWSE brHistorico.
    ENABLE btCanHistorico btSaveHistorico WITH FRAME fPage4.
    DISABLE btn-efetiva btAddHistorico btUpdateHistorico btn-muda-sequencia btUpdateHistorico WITH FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btObservacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btObservacao wMaintenance
ON CHOOSE OF btObservacao IN FRAME fPage1 /* Observa‡Æo */
DO:
  RUN pi-observacao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRateio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRateio wMaintenance
ON CHOOSE OF btRateio IN FRAME fpage0 /* Atualiza Rateio Embarques */
DO:
    IF AVAIL tt-decla-import THEN
        RUN pi-rateio-embarques.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRetificacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRetificacao wMaintenance
ON CHOOSE OF btRetificacao IN FRAME fpage0 /* Retifica‡Æo */
DO:
    RUN pi-retificacao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    RUN pi-valida-data.
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK" THEN DO:
        IF INPUT FRAME fPage1 tt-decla-import.cod-natur-oper <> "" THEN DO:
            RUN pi-verifica-altera-natur IN h-bocx383 (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                                       INPUT INPUT FRAME fPage0 tt-decla-import.num-seq-retif,
                                                       INPUT INPUT FRAME fPage1 tt-decla-import.cod-natur-oper,
                                                       INPUT tt-decla-import.cdd-siscomex-dts, //cdd-siscomex-dts
                                                       OUTPUT l-nat-operacao).
            IF l-nat-operacao THEN
                RUN pi-altera-nat-operacao-ordens.
        END.
        APPLY "CHOOSE" TO btCancel IN FRAME fPage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btSaveDespesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaveDespesa wMaintenance
ON CHOOSE OF btSaveDespesa IN FRAME fPage5 /* Save */
DO:
    RUN pi-salva-despesa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btSaveEmbalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaveEmbalagem wMaintenance
ON CHOOSE OF btSaveEmbalagem IN FRAME fPage3 /* Save */
DO:
  RUN pi-salva-embalagem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btSaveHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaveHistorico wMaintenance
ON CHOOSE OF btSaveHistorico IN FRAME fPage4 /* Save */
DO:
    RUN pi-salva-historico.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btSaveProcessoVinc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaveProcessoVinc wMaintenance
ON CHOOSE OF btSaveProcessoVinc IN FRAME fPage2 /* Save */
DO:
  RUN pi-salva-processo-vinc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
   {method/zoomreposition.i &ProgramZoom="cxzoom/z01cx400.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
  RUN pi-canc-historico.
    /* verifica se tem documento gerado no recebimento para esta DI */
    RUN piDoctoRecebimento IN h-bocx383a(INPUT tt-decla-import.cod-di-siscomex, OUTPUT l-encontrou).


    /* so deixa alterar a DI se nÆo houver documento gerado no recebimento */
    IF NOT l-encontrou THEN DO:
        RUN updateRecord IN THIS-PROCEDURE.
        RUN pi-botoes (INPUT NO).

        ASSIGN l-alterando = TRUE.
        APPLY "VALUE-CHANGED":U TO brHistorico IN FRAME fPage4.

        RUN pi-verifica-adic IN h-bocx403(INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                          INPUT tt-decla-import.cdd-siscomex-dts,
                                          OUTPUT l-existe-adic).
        IF l-existe-adic THEN
            ASSIGN tt-decla-import.cod-natur-operac:SENSITIVE IN FRAME fPage1 = NO.
    END.
    ELSE DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "NÆo_‚_permitido_alterar_a_Declara‡Æo_de_Importa‡Æo_pois_existe_documento_gerado_no_recebimento" *}
        RUN utp/ut-msgs.p (INPUT 'show',
                        INPUT 19085,
                        INPUT RETURN-VALUE + '!').
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btUpdateDespesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateDespesa wMaintenance
ON CHOOSE OF btUpdateDespesa IN FRAME fPage5
DO:
    RUN pi-update-despesa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btUpdateHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateHistorico wMaintenance
ON CHOOSE OF btUpdateHistorico IN FRAME fPage4
DO:
    ASSIGN i-modificacao = 2 /* altera‡Æo de ponto de controle */
           i-linha-anterior = brHistorico:FOCUSED-ROW.
    RUN pi-update-historico.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMaintenance
ON CHOOSE OF btUpdateSon1 IN FRAME fPage4 /* Alterar */
DO:
  RUN pi-update-historico-di.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btUpdateSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon2 wMaintenance
ON CHOOSE OF btUpdateSon2 IN FRAME fPage5 /* Alterar */
DO:
    RUN pi-update-despesa-di.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btVincEmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVincEmb wMaintenance
ON CHOOSE OF btVincEmb IN FRAME fpage0 /* Vincular Embarques */
DO:
  RUN pi-vincula-embarque.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME c-cod-emb-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-emb-desp wMaintenance
ON F5 OF c-cod-emb-desp IN FRAME fPage5 /* Embarque */
DO:
    {method/zoomfields.i &ProgramZoom   = "cxzoom/z11cx220.w"
                         &FieldZoom1    = "embarque"
                         &FieldScreen1  = "c-cod-emb-desp"
                         &frame1        = "fPage5"
                         &RunMethod     = "RUN setaEstabelecimento IN hProgramZoom (input input frame fPage0 tt-decla-import.cod-estab, input input frame fPage0 tt-decla-import.num-di-ems)."
                         &EnableImplant = "NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-emb-desp wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-cod-emb-desp IN FRAME fPage5 /* Embarque */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME c-cod-embarq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-embarq wMaintenance
ON F5 OF c-cod-embarq IN FRAME fPage4 /* Embarque */
DO:
{method/zoomfields.i &ProgramZoom="cxzoom/z11cx220.w"
                         &FieldZoom1="embarque"
                         &FieldScreen1="c-cod-embarq"
                         &frame1="fPage4"
                         &RunMethod="RUN setaEstabelecimento IN hProgramZoom (input input frame fPage0 tt-decla-import.cod-estab, input input frame fPage0 tt-decla-import.num-di-ems)."
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-embarq wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-cod-embarq IN FRAME fPage4 /* Embarque */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-carac-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-carac-oper wMaintenance
ON VALUE-CHANGED OF cb-carac-oper IN FRAME fPage1 /* Caracter¡stica Opera‡Æo */
DO:
    RUN pi-trata-operacao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME tt-decla-import.cdn-agent-carg-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-agent-carg-import wMaintenance
ON F5 OF tt-decla-import.cdn-agent-carg-import IN FRAME fPage3 /* Agente Cargas */
DO:
  {method/zoomfields.i
     &ProgramZoom="adzoom/z10ad268.w"
     &FieldZoom1="cod-transp"
     &FieldScreen1="tt-decla-import.cdn-agent-carg-import"
     &FRAME1="fPage3"
     &FieldZoom2="nome"
     &FieldScreen2="c-desc-agente-carga"
     &FRAME2="fPage3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-agent-carg-import wMaintenance
ON LEAVE OF tt-decla-import.cdn-agent-carg-import IN FRAME fPage3 /* Agente Cargas */
DO:
    {method/referencefields.i
        &HandleDBOLeave="h-boad268"
        &KeyValue1="tt-decla-import.cdn-agent-carg:screen-value in frame fPage3"
        &FieldName1="nome"
        &FieldScreen1="c-desc-agente-carga"
        &Frame1="fPage3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-agent-carg-import wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import.cdn-agent-carg-import IN FRAME fPage3 /* Agente Cargas */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-decla-import.cdn-consign
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-consign wMaintenance
ON F5 OF tt-decla-import.cdn-consign IN FRAME fPage1 /* Cod Consignat rio */
DO:
    &if defined(bf-mat-comex) &then
        assign l-implanta = no.
    &else
        assign l-implanta = yes.
    &endif

    {include/zoomvar.i
        &prog-zoom="adzoom/z03ad098.w"
        &campo="tt-decla-import.cdn-consign"
        &campozoom="cod-emitente"
        &frame="fPage1"
        &campo2="c-nome-abrev"
        &campozoom2="nome-abrev"
        &Frame2="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-consign wMaintenance
ON LEAVE OF tt-decla-import.cdn-consign IN FRAME fPage1 /* Cod Consignat rio */
DO:
    {method/referencefields.i
        &HandleDBOLeave="h-boad098"
        &FindMethod="findCodigo"
        &KeyValue1="tt-decla-import.cdn-consign:SCREEN-VALUE IN FRAME fPage1"
        &FieldName1="nome-abrev"
        &FieldScreen1="c-nome-abrev"
        &Frame1="fPage1"}

    IF tt-decla-import.cdn-consign:SCREEN-VALUE IN FRAME fPage1 = "0" THEN
        ASSIGN c-nome-abrev:SCREEN-VALUE IN FRAME fPage1 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-consign wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import.cdn-consign IN FRAME fPage1 /* Cod Consignat rio */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME tt-decla-import.cdn-pais-proceden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-pais-proceden wMaintenance
ON F5 OF tt-decla-import.cdn-pais-proceden IN FRAME fPage3 /* Pais Procedencia */
DO:
  {method/zoomfields.i
      &ProgramZoom="unzoom/z11un006.w"
      &FieldZoom1="cod-pais-siscomex"
      &FieldScreen1="tt-decla-import.cdn-pais-proceden"
      &Frame1="fPage3"
      &FieldZoom2="nome-pais"
      &FieldScreen2="c-desc-pais-proced"
      &FRAME2="fPage3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-pais-proceden wMaintenance
ON LEAVE OF tt-decla-import.cdn-pais-proceden IN FRAME fPage3 /* Pais Procedencia */
DO:
    ASSIGN c-desc-pais-proced = "".
    FOR FIRST pais NO-LOCK
        WHERE pais.cod-pais-siscomex = STRING(INPUT FRAME fpage3 tt-decla-import.cdn-pais-proceden):
        ASSIGN c-desc-pais-proced = pais.nome-pais.
    END.
    DISP c-desc-pais-proced WITH FRAME fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-pais-proceden wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import.cdn-pais-proceden IN FRAME fPage3 /* Pais Procedencia */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt-decla-import.cdn-transpdor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-transpdor wMaintenance
ON F5 OF tt-decla-import.cdn-transpdor IN FRAME fPage2 /* Transportador */
DO:
  {method/zoomfields.i
     &ProgramZoom="adzoom/z10ad268.w"
     &FieldZoom1="cod-transp"
     &FieldScreen1="tt-decla-import.cdn-transpdor"
     &FRAME1="fPage2"
     &FieldZoom2="nome"
     &FieldScreen2="c-desc-transp"
     &FRAME2="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-transpdor wMaintenance
ON LEAVE OF tt-decla-import.cdn-transpdor IN FRAME fPage2 /* Transportador */
DO:
    {method/referencefields.i
        &HandleDBOLeave="h-boad268"
        &KeyValue1="tt-decla-import.cdn-transpdor:screen-value in frame fPage2"
        &FieldName1="nome"
        &FieldScreen1="c-desc-transp"
        &Frame1="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-transpdor wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import.cdn-transpdor IN FRAME fPage2 /* Transportador */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import.cdn-urf-despch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-urf-despch wMaintenance
ON F5 OF tt-decla-import.cdn-urf-despch IN FRAME fPage2 /* URF Despacho */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z01cx401.w"
                         &FieldZoom1="cdn-unid-recta-feder"
                         &FieldScreen1="tt-decla-import.cdn-urf-despch"
                         &Frame1="fPage2"
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-urf-despch wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import.cdn-urf-despch IN FRAME fPage2 /* URF Despacho */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import.cdn-urf-entr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-urf-entr wMaintenance
ON F5 OF tt-decla-import.cdn-urf-entr IN FRAME fPage2 /* URF Entrada Pa¡s */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z01cx401.w"
                         &FieldZoom1="cdn-unid-recta-feder"
                         &FieldScreen1="tt-decla-import.cdn-urf-entr"
                         &Frame1="fPage2"
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cdn-urf-entr wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import.cdn-urf-entr IN FRAME fPage2 /* URF Entrada Pa¡s */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-decla-import.cod-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cod-estab wMaintenance
ON F5 OF tt-decla-import.cod-estab IN FRAME fpage0 /* Estabelecimento */
DO:
    {method/zoomfields.i &ProgramZoom="adzoom/z10ad107.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="tt-decla-import.cod-estab"
                         &Frame1="fPage0"
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cod-estab wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import.cod-estab IN FRAME fpage0 /* Estabelecimento */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-decla-import.cod-natur-operac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cod-natur-operac wMaintenance
ON F5 OF tt-decla-import.cod-natur-operac IN FRAME fPage1 /* Natureza Opera‡Æo */
DO:
    {method/ZoomFields.i
             &ProgramZoom="inzoom/z04in245.w"
             &FieldZoom1="nat-operacao"
             &FieldScreen1="tt-decla-import.cod-natur-operac"
             &Frame1="fpage1"
             &FieldZoom2="denominacao"
             &FieldScreen2="c-des-nat-operacao"
             &Frame2="fpage1"
             &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cod-natur-operac wMaintenance
ON LEAVE OF tt-decla-import.cod-natur-operac IN FRAME fPage1 /* Natureza Opera‡Æo */
DO:
    assign input frame fpage1 tt-decla-import.cod-natur-operac.

    run findNatureza in h-boin245 (input tt-decla-import.cod-natur-operac,
                                   output c-return).
    if c-return = "":U then
        run getCharfield in h-boin245 (input "denominacao":U,output c-des-nat-operacao).
    else
        assign c-des-nat-operacao = "":U.

    disp c-des-nat-operacao with frame fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.cod-natur-operac wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import.cod-natur-operac IN FRAME fPage1 /* Natureza Opera‡Æo */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-despachante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-despachante wMaintenance
ON F5 OF fi-cod-despachante IN FRAME fPage1 /* C¢digo Despachante */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                       &campo="fi-cod-despachante"
                       &campozoom="cod-emitente"
                       &frame="fPage1"
                       &campo2="c-nome-abrev-desp"
                       &campozoom2="nome-abrev"
                       &frame2="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-despachante wMaintenance
ON LEAVE OF fi-cod-despachante IN FRAME fPage1 /* C¢digo Despachante */
DO:
    DEFINE VARIABLE c-descricao AS CHARACTER   NO-UNDO.

    IF  VALID-HANDLE(h-boad098)
    AND AVAIL tt-decla-import
    AND INPUT FRAME fPage1 fi-cod-despachante <> 0 THEN DO:
        RUN findCodigo in h-boad098 (INPUT INPUT FRAME fpage1 fi-cod-despachante, OUTPUT c-return).
        IF c-return = "":U THEN DO:
            RUN getcharfield IN h-boad098 (INPUT "nome-abrev":U, OUTPUT c-descricao).
            ASSIGN c-nome-abrev-desp:SCREEN-VALUE IN FRAME fpage1 = c-descricao.
        END.
        ELSE DO:
            ASSIGN c-nome-abrev-desp:SCREEN-VALUE IN FRAME fpage1 = "":U.
        END.
    END.
    ELSE DO:
        ASSIGN c-nome-abrev-desp:SCREEN-VALUE IN FRAME fpage1 = "":U.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-despachante wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-cod-despachante IN FRAME fPage1 /* C¢digo Despachante */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME i-cdn-pto-nacionaliz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-pto-nacionaliz wMaintenance
ON LEAVE OF i-cdn-pto-nacionaliz IN FRAME fPage4 /* Ponto Nacionaliza‡Æo */
DO:
  /**/
    FOR FIRST tt-histor-decla-import
        WHERE tt-histor-decla-import.cdn-pto-control = integer(i-cdn-pto-nacionaliz:SCREEN-VALUE IN FRAME fPage4):
        ASSIGN c-desc-ponto-nacionaliz = tt-histor-decla-import.descricao.
        DISPLAY c-desc-ponto-nacionaliz WITH FRAME fPage4.
    END.

    IF TRIM(c-desc-ponto-nacionaliz) = "":U THEN DO:
        {method/referencefields.i &HandleDBOLeave="h-bocx110"
                                  &FindMethod="findCodigo"
                                  &KeyValue1="integer(i-cdn-pto-nacionaliz:SCREEN-VALUE IN FRAME fPage4)"
                                  &FieldName1="descricao"
                                  &FieldScreen1="c-desc-ponto-nacionaliz"
                                  &Frame1="fPage4"}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMaintenance
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME rs-apres-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-apres-despesa wMaintenance
ON VALUE-CHANGED OF rs-apres-despesa IN FRAME fPage5
DO:
  RUN pi-apres-despesa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME rs-tipo-apresentacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo-apresentacao wMaintenance
ON VALUE-CHANGED OF rs-tipo-apresentacao IN FRAME fPage4
DO:
  RUN pi-tipo-apresentacao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME tt-decla-import.val-peso-embal-di
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import.val-peso-embal-di wMaintenance
ON LEAVE OF tt-decla-import.val-peso-embal-di IN FRAME fPage3 /* Peso Embalagem */
DO:
  ASSIGN tt-decla-import.val-peso-brut-tot-di = INPUT FRAME fPage3 tt-decla-import.val-peso-brut-merc + INPUT FRAME fPage3 tt-decla-import.val-peso-embal-di.
  DISP tt-decla-import.val-peso-brut-tot-di
      WITH FRAME fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDespesa
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance


tt-decla-import.cod-estab  :LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage0.
tt-decla-import.cdn-consign:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.
fi-cod-despachante:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.
tt-decla-import.cod-natur-oper:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.
tt-decla-import.cdn-urf-entr:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage2.
tt-decla-import.cdn-urf-despch:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage2.
tt-decla-import.cdn-transpdor:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
tt-decla-import.cdn-pais-proceden:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage3.
tt-decla-import.cdn-agent-carg-import:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage3.
c-cod-embarq  :LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.
c-cod-emb-desp:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5.
tt-decla-import-embal.cod-sig-embal:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brEmbalagem.
tt-histor-decla-import.cdn-pto-control:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brHistorico.
tt-despes-decla-import.cdn-despes:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brDespesa.
tt-despes-decla-import.cdn-emit-despes:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brDespesa.
tt-despes-decla-import.cdn-cond-pagto:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brDespesa.
tt-despes-decla-import.cdn-moed:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brDespesa.

{utp/ut-liter.i "Ponto de controle"}
ASSIGN c-lbl-pto-contr = RETURN-VALUE.
{utp/ut-liter.i "Caso confirme, o registro ser  criado no Cadastro de Pontos de Controle com este C¢digo e esta Descri‡Æo."}
ASSIGN c-lbl-cadastra-pto = RETURN-VALUE.

ASSIGN tt-decla-import.cod-di-siscomex:FORMAT IN FRAME fpage0 = "X(20)".

on  leave of tt-decla-imp-proc-aux.desc-tipo in browse brProcessoVinc do:
    /*ASSIGN tt-decla-imp-proc-aux.idi-tip-proces-vincul = INT(tt-decla-imp-proc-aux.desc-tipo:screen-value in browse brProcessoVinc).*/
    CASE tt-decla-imp-proc-aux.desc-tipo:screen-value in browse brProcessoVinc:
        WHEN "1" THEN
            ASSIGN tt-decla-imp-proc-aux.desc-tipo:screen-value in browse brProcessoVinc = "Administrativo".
        WHEN "2" THEN
            ASSIGN tt-decla-imp-proc-aux.desc-tipo:screen-value in browse brProcessoVinc = "Judicial".
        WHEN "3" THEN
            ASSIGN tt-decla-imp-proc-aux.desc-tipo:screen-value in browse brProcessoVinc = "Declara‡Æo Preliminar".
        WHEN "4" THEN
            ASSIGN tt-decla-imp-proc-aux.desc-tipo:screen-value in browse brProcessoVinc = "Judicial Exclusivo DARF".
    END CASE.
end.

on  'F5', mouse-select-dblclick of tt-decla-import-embal.cod-sig-embal in browse brEmbalagem do:

    if  num-results("brEmbalagem") > 0 then do:
        assign i-filtro = 1
               l-zoom   = yes.

        {include/zoomvar.i &prog-zoom="dizoom/z01di040.w"
                           &campo=tt-decla-import-embal.cod-sig-embal
                           &campozoom=sigla-emb
                           &browse=brEmbalagem}
        assign l-zoom = no.
    end.
end.

on  'F5', mouse-select-dblclick of tt-histor-decla-import.cdn-pto-control in browse brHistorico do:

    if num-results("brHistorico") > 0 then do:

        assign i-filtro = 1
               l-zoom   = yes.

      {method/zoomfields.i
         &ProgramZoom="cxzoom/z10cx110.w"
         &FieldZoom1="cod-pto-contr"
         &FieldScreen1="tt-histor-decla-import.cdn-pto-control"
         &browse1="brHistorico"
         &FieldZoom2="descricao"
         &FieldScreen2="tt-histor-decla-import.descricao"
         &browse2="brHistorico"}
         WAIT-FOR CLOSE OF hProgramZoom.
       assign l-zoom = no.
    end.
end.

ON  "ENTRY" OF tt-histor-decla-import.cdn-pto-control IN BROWSE brHistorico
DO:
    IF i-pto-ant = 0 THEN
        ASSIGN i-pto-ant = INTEGER(tt-histor-decla-import.cdn-pto-control:SCREEN-VALUE IN BROWSE brHistorico).
END.

/* Leave pto controle - acompanhamento processo fpage1 */
ON  "LEAVE" OF tt-histor-decla-import.cdn-pto-control IN BROWSE brHistorico
DO:
    RUN findCodigo IN h-bocx110 (INPUT tt-histor-decla-import.cdn-pto-contr:SCREEN-VALUE IN BROWSE brHistorico,
                                 OUTPUT c-return).
    IF c-return <> "":U AND INT(tt-histor-decla-import.cdn-pto-contr:SCREEN-VALUE IN BROWSE brHistorico) <> i-pto-ant THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 54562,
                           INPUT c-lbl-pto-contr + "~~"  + c-lbl-cadastra-pto).
        IF RETURN-VALUE <> "yes":U THEN DO:
            ASSIGN tt-histor-decla-import.cdn-pto-control:SCREEN-VALUE IN BROWSE brHistorico = STRING(i-pto-ant).
            RETURN NO-APPLY.
        END.
        ELSE
            ASSIGN tt-histor-decla-import.descricao:SCREEN-VALUE IN BROWSE brHistorico = ""
                   tt-histor-decla-import.descricao.
    END.
    ELSE DO:
        IF TRIM(tt-histor-decla-import.descricao:SCREEN-VALUE IN BROWSE brHistorico) = "":U OR
            INT(tt-histor-decla-import.cdn-pto-contr:SCREEN-VALUE IN BROWSE brHistorico) <> i-pto-ant THEN DO:
            RUN retornaDescricao IN h-bocx110 (INPUT tt-histor-decla-import.cdn-pto-contr:SCREEN-VALUE IN BROWSE brHistorico,
                                               OUTPUT c-return).
            ASSIGN tt-histor-decla-import.descricao:SCREEN-VALUE IN BROWSE brHistorico = c-return
                   tt-histor-decla-import.descricao
                   i-pto-ant = INTEGER(tt-histor-decla-import.cdn-pto-control:SCREEN-VALUE IN BROWSE brHistorico).

            RUN getCharField IN h-bocx110 (INPUT "cod-uf":U, OUTPUT c-cod-uf).

            ASSIGN OVERLAY(tt-histor-decla-import.cod-livre-1,6,2) = c-cod-uf.

            DISP c-cod-uf WITH BROWSE brHistorico.

        END.
    END.
END.

/*--- Despesa ----------------------------------------------------------------------------------------------------*/
/*--- PONTO DE CONTROLE ------------------------------------------------------------------------*/
/*on  'F5', mouse-select-dblclick of tt-despes-decla-import.cdn-pto-control in browse brDespesa do:
    if  num-results("brDespesa") > 0 then do:
        assign i-filtro = 1
               l-zoom   = yes.

        {method/zoomfields.i &ProgramZoom="cxzoom/z10cx110.w"
                             &FieldZoom1="cod-pto-contr"
                             &FieldScreen1="tt-despes-decla-import.cdn-pto-control"
                             &browse1="brDespesa"
                             &FieldZoom2="descricao"
                             &FieldScreen2="c-brw-desc-pto-control"
                             &browse2="brDespesa"}
                             WAIT-FOR CLOSE OF hProgramZoom.
        assign l-zoom = no.
    end. /* if  num-results("brDespesa") > 0 then do: */
end. /* on  'F5', mouse-select-dblclick of */ */

on  'LEAVE' of tt-despes-decla-import.desc-tipo in browse brDespesa do:
    if  num-results("brDespesa") > 0 then do:
        IF  SUBSTRING(tt-despes-decla-import.desc-tipo:SCREEN-VALUE IN BROWSE brDespesa,1,1) = 'N'  THEN
            ASSIGN tt-despes-decla-import.log-incid-vmle :READ-ONLY IN BROWSE brDespesa = NO
                   tt-despes-decla-import.desc-tipo:SCREEN-VALUE IN BROWSE brDespesa = "Nacionaliza‡Æo".
        ELSE
            ASSIGN tt-despes-decla-import.log-incid-vmle :READ-ONLY IN BROWSE brDespesa = YES
                   tt-despes-decla-import.desc-tipo:SCREEN-VALUE IN BROWSE brDespesa = "Complementar".
    end.  /* if  num-results("brDespesa") */
end.  /* on  'LEAVE' of tt-despes-decla-import.cdn-pto-control */

/*--- FORNECEDOR -------------------------------------------------------------------------------*/
on  'F5', mouse-select-dblclick of tt-despes-decla-import.cdn-emit-despes in browse brDespesa do:
    if  num-results("brDespesa") > 0 then do:
        assign i-filtro = 1
               l-zoom   = yes.

        {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                           &campo="tt-despes-decla-import.cdn-emit-despes"
                           &campozoom="cod-emitente"
                           &browse="brDespesa"
                           &campo2="c-brw-nome-abrev"
                           &campozoom2="nome-abrev"
                           &browse2="brDespesa"}

        assign l-zoom = no.
    end. /* if  num-results("brDespesa") > 0 then do: */
end. /* on  'F5', mouse-select-dblclick of */

on  'LEAVE' of tt-despes-decla-import.cdn-emit-despes in browse brDespesa do:
    if num-results("brDespesa") > 0 then do:
        RUN goToKey IN h-boad098na (INPUT INTEGER(tt-despes-decla-import.cdn-emit-despes:SCREEN-VALUE IN BROWSE brDespesa)).
        IF RETURN-VALUE = "OK" THEN DO:
          RUN getCharField IN h-boad098na(INPUT 'nome-emit',
                                          OUTPUT c-brw-nome-abrev).
        END.
        ELSE
          ASSIGN c-brw-nome-abrev = "".

        DISP c-brw-nome-abrev WITH BROWSE brDespesa.

    end.
end.

/*--- CàDIGO DESPESA ---------------------------------------------------------------------------*/
on  'F5', mouse-select-dblclick of tt-despes-decla-import.cdn-despes in browse brDespesa do:
    if  num-results("brDespesa") > 0 then do:
        assign i-filtro = 1
               l-zoom   = yes.

        {method/zoomfields.i &ProgramZoom="cxzoom/z10cx095.w"
                             &FieldZoom1="cod-desp"
                             &FieldScreen1="tt-despes-decla-import.cdn-despes"
                             &browse1="brDespesa"
                             &FieldZoom2="descricao"
                             &FieldScreen2="c-brw-desc-despes"
                             &browse2="brDespesa"}
                             WAIT-FOR CLOSE OF hProgramZoom.
        assign l-zoom = no.
    end. /* if  num-results("brDespesa") > 0 then do: */
end. /* on  'F5', mouse-select-dblclick of */

on  'LEAVE' of tt-despes-decla-import.cdn-despes in browse brDespesa do:
    if num-results("brHistorico") > 0 then do:
        IF VALID-HANDLE(h-bocx095) THEN
        RUN retornaDescDespesa IN h-bocx095 (INPUT INTEGER(tt-despes-decla-import.cdn-despes:SCREEN-VALUE IN BROWSE brDespesa), output c-brw-desc-despes).

        DISP c-brw-desc-despes WITH BROWSE brDespesa.

    end.
end.

/*--- CONDI€ÇO PAGAMENTO -----------------------------------------------------------------------*/
on  'F5', mouse-select-dblclick of tt-despes-decla-import.cdn-cond-pagto in browse brDespesa do:
    if  num-results("brDespesa") > 0 then do:
        assign i-filtro = 1
               l-zoom   = yes.

        {method/zoomfields.i &ProgramZoom="adzoom/z10ad039.w"
                             &FieldZoom1="cod-cond-pag"
                             &FieldScreen1="tt-despes-decla-import.cdn-cond-pagto"
                             &browse1="brDespesa"
                             &FieldZoom2="descricao"
                             &FieldScreen2="c-brw-desc-pagto"
                             &browse2="brDespesa"}
                             WAIT-FOR CLOSE OF hProgramZoom.
        assign l-zoom = no.
    end. /* if  num-results("brDespesa") > 0 then do: */
end. /* on  'F5', mouse-select-dblclick of */

on  'LEAVE' of tt-despes-decla-import.cdn-cond-pagto in browse brDespesa do:
    if num-results("brDespesa") > 0 then do:
        RUN goToKey IN h-boad039na (INPUT string(INPUT BROWSE brDespesa tt-despes-decla-import.cdn-cond-pagto)).
        IF  RETURN-VALUE = "OK" THEN DO:
            RUN getCharField IN h-boad039na(INPUT 'descricao', OUTPUT c-brw-desc-pagto).
        END.
        ELSE ASSIGN c-brw-desc-pagto = "".

        DISP c-brw-desc-pagto WITH BROWSE brDespesa.

    end.
end.

/*--- MOEDA -----------------------------------------------------------------------*/
on  'F5', mouse-select-dblclick of tt-despes-decla-import.cdn-moed in browse brDespesa do:
    if  num-results("brDespesa") > 0 then do:
        assign i-filtro = 1
               l-zoom   = yes.

        {include/zoomvar.i &prog-zoom="adzoom/z01ad178.w"
                           &campo=tt-despes-decla-import.cdn-moed
                           &campozoom=mo-codigo
                           &browse=brDespesa}
        assign l-zoom = no.
    end. /* if  num-results("brDespesa") > 0 */
end. /* on  'F5', mouse-select-dblclick */

/*on  'LEAVE' of tt-despes-decla-import.cdn-moed in browse brDespesa do:
    if num-results("brDespesa") > 0 then do:
        RUN pi-valida-cot-desp-compl(INPUT INPUT BROWSE brDespesa tt-despes-decla-import.cdn-pto-control,
                                     INPUT INPUT BROWSE brDespesa tt-despes-decla-import.cdn-moed).
    end.
end.*/



/* MESSAGE "Atualiza‡Æo Necess ria? " CAN-FIND(FIRST decla-import WHERE decla-import.cdd-siscomex-dts = 0) */
/*     VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.                                                           */

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fPage6:HANDLE).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterChangePage wMaintenance
PROCEDURE afterChangePage :
/*------------------------------------------------------------------------------
  Purpose: Executada ap¢s a troca de p gina. (folder)
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-current-folder AS INTEGER     NO-UNDO.
    RUN getCurrentFolder IN hFolder (OUTPUT i-current-folder).

    IF i-current-folder = 5 /* Itiner rio */ THEN
        APPLY "VALUE-CHANGED":U TO brHistorico IN FRAME fPage4.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-bocx383a) THEN DO:
        DELETE PROCEDURE h-bocx383a.
        ASSIGN h-bocx383a = ?.
    END.

    IF VALID-HANDLE(h-boad098) THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    IF VALID-HANDLE(h-boin245) THEN DO:
        DELETE PROCEDURE h-boin245  .
        ASSIGN h-boin245 = ?.
    END.

    IF VALID-HANDLE(h-bocx396) THEN DO:
        DELETE PROCEDURE h-bocx396.
        ASSIGN h-bocx396 = ?.
    END.

    IF VALID-HANDLE(h-boad268) THEN DO:
        DELETE PROCEDURE h-boad268.
        ASSIGN h-boad268 = ?.
    END.

    IF VALID-HANDLE(h-bocx386) THEN DO:
        DELETE PROCEDURE h-bocx386.
        ASSIGN h-bocx386 = ?.
    END.

    IF VALID-HANDLE(h-bocx384) THEN DO:
        DELETE PROCEDURE h-bocx384.
        ASSIGN h-bocx384 = ?.
    END.

    IF VALID-HANDLE(h-bocx3842) THEN DO:
        DELETE PROCEDURE h-bocx3842.
        ASSIGN h-bocx3842 = ?.
    END.

    IF VALID-HANDLE(h-bocx110) THEN DO:
        DELETE PROCEDURE h-bocx110.
        ASSIGN h-bocx110 = ?.
    END.

    IF VALID-HANDLE(h-bocx230) THEN DO:
        DELETE PROCEDURE h-bocx230.
        ASSIGN h-bocx230 = ?.
    END.

    IF VALID-HANDLE(h-bocx407) THEN DO:
        DELETE PROCEDURE h-bocx407.
        ASSIGN h-bocx407 = ?.
    END.

    IF VALID-HANDLE(h-bocx110na) THEN DO:
        DELETE PROCEDURE h-bocx110na.
        ASSIGN h-bocx110na = ?.
    END.

    IF VALID-HANDLE(h-bocx406) THEN DO:
        DELETE PROCEDURE h-bocx406.
        ASSIGN h-bocx406 = ?.
    END.

    IF VALID-HANDLE(h-bocx406) THEN DO:
        DELETE PROCEDURE h-bocx406.
        ASSIGN h-bocx406 = ?.
    END.

    IF VALID-HANDLE(h-bocx095) THEN DO:
        DELETE PROCEDURE h-bocx095.
        ASSIGN h-bocx095 = ?.
    END.

    IF VALID-HANDLE(h-boad039na) THEN DO:
        DELETE PROCEDURE h-boad039na.
        ASSIGN h-boad039na = ?.
    END.

    IF VALID-HANDLE(h-boad098na) THEN DO:
        DELETE PROCEDURE h-boad098na.
        ASSIGN h-boad098na = ?.
    END.

    IF VALID-HANDLE(h-bocx310) THEN DO:
        DELETE PROCEDURE h-bocx310.
        ASSIGN h-bocx310 = ?.
    END.

    IF VALID-HANDLE(h-bocx403) THEN DO:
        DELETE PROCEDURE h-bocx403.
        ASSIGN h-bocx403 = ?.
    END.

    IF VALID-HANDLE(h-bocx336) THEN DO:
        DELETE PROCEDURE h-bocx336.
        ASSIGN h-bocx336 = ?.
    END.

    IF VALID-HANDLE(h-bocx404) THEN DO:
        DELETE PROCEDURE h-bocx404.
        ASSIGN h-bocx404 = ?.
    END.

    IF VALID-HANDLE(h-bocx250) THEN DO:
        DELETE PROCEDURE h-bocx250.
        ASSIGN h-bocx250 = ?.
    END.

    IF VALID-HANDLE(h-bocx402) THEN DO:
        DELETE PROCEDURE h-bocx402.
        ASSIGN h-bocx402 = ?.
    END.

    IF VALID-HANDLE(h-cd0763) THEN DO:
        DELETE PROCEDURE h-cd0763.
        ASSIGN  h-cd0763 = ?.
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
DISABLE brProcessoVinc WITH FRAME fPage2.
DISABLE brEmbalagem WITH FRAME fPage3.

DISABLE btObservacao WITH FRAME fPage1.

DISABLE btAddProcessoVinc
        btDelProcessoVinc
        btCanProcVinc
        btSaveProcessoVinc WITH FRAME fPage2.

DISABLE btAddEmbalagem
        btDelEmbalagem
        btCanEmbalagem
        btSaveEmbalagem WITH FRAME fPage3.

/*--- Hist¢rico --------------------------------------------------------------*/
IF CAN-FIND(FIRST tt-histor-decla-import) THEN
    ENABLE btAddSon1 btDeleteSon1 btUpdateSon1 WITH FRAME fPage4.
ELSE
    DISABLE btAddSon1 btDeleteSon1 btUpdateSon1 WITH FRAME fPage4.

DISABLE btAddHistorico btCanHistorico btSaveHistorico btUpdateHistorico
        c-cod-embarq btAtualizaEmb
    WITH FRAME fPage4.

ASSIGN c-cod-embarq         = ""
       rs-tipo-apresentacao = 1.
DISP c-cod-embarq rs-tipo-apresentacao WITH FRAME fPage4.

RUN pi-busca-historicos-di.

/*--- Despesas ---------------------------------------------------------------*/
IF   CAN-FIND(FIRST tt-despes-decla-import)
THEN ENABLE  btAddSon2 btDeleteSon2 btUpdateSon2 btConfere-desp WITH FRAME fPage5.
ELSE DISABLE btAddSon2 btDeleteSon2 btUpdateSon2 btConfere-desp WITH FRAME fPage5.

DISABLE btAddDespesa btCanDespesa btSaveDespesa btUpdateDespesa c-cod-emb-desp btAtualizaEmb-desp WITH FRAME fPage5.

ASSIGN c-cod-emb-desp   = ""
       rs-apres-despesa = 1.
DISP c-cod-emb-desp rs-apres-despesa WITH FRAME fPage5.

RUN pi-busca-Despesas-di.

RUN pi-botoes (INPUT YES).
RUN pi-trata-browser-Despesa   (INPUT YES).
RUN pi-trata-browser-historico (INPUT YES).
RUN pi-altera-di. /* desabilita os campos quando tem documento gerado no recebimento. */
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

IF AVAIL tt-decla-import THEN DO:
    ASSIGN i-pto-ant = 0.

    RUN pi-buscaValoresRetificacao.
    RUN pi-trata-combos (INPUT YES).
    RUN pi-busca-processos-vinculados.
    RUN pi-busca-embalagens.
    /* Hist¢rico */
    IF INPUT FRAME fPage4 rs-tipo-apresentacao = 1 THEN
        RUN pi-busca-historicos-di.
    ELSE
        RUN pi-busca-historicos-embarque.

    /* Despesa */
    IF INPUT FRAME fPage5 rs-apres-despesa = 1 THEN
        RUN pi-busca-despesas-di.
    ELSE
        RUN pi-busca-despesas-embarque.

    RUN pi-tipo-apresentacao.
    RUN pi-apres-despesa.

    IF INT(tt-decla-import.num-seq-retif:SCREEN-VALUE IN FRAME fPage0) = 0 THEN
        RUN pi-controla-retif(INPUT NO,
                              INPUT YES).
    ELSE DO:
        RUN pi-controla-retif(INPUT NO,
                              INPUT NO).
    END.

    IF tt-decla-import.dat-di <> ? THEN
        ASSIGN btCotacaoDi   :SENSITIVE IN FRAME fPage0 = YES.
    ELSE
        ASSIGN btCotacaoDi   :SENSITIVE IN FRAME fPage0 = NO.

    ASSIGN fi-cod-despachante:SCREEN-VALUE IN FRAME fPage1 = SUBSTRING(tt-decla-import.cod-livre-1, 3, 9).

    APPLY 'VALUE-CHANGED' TO cb-carac-oper                 IN FRAME fPage1.
    APPLY 'LEAVE' TO tt-decla-import.cdn-consign           IN FRAME fPage1.
    APPLY 'LEAVE' TO fi-cod-despachante                    IN FRAME fPage1.
    APPLY 'LEAVE' TO tt-decla-import.cod-natur-operac      IN FRAME fPage1.
    APPLY 'LEAVE' TO tt-decla-import.cdn-transpdor         IN FRAME fPage2.
    APPLY 'LEAVE' TO tt-decla-import.cdn-agent-carg-import IN FRAME fPage3.
    APPLY 'LEAVE' TO tt-decla-import.cdn-pais-proceden     IN FRAME fPage3.

    RUN pi-busca-impostos. /* busca os impostos */
    RUN pi-busca-valores. /* busca os valores */
    RUN pi-busca-logs.
    RUN pi-altera-di. /* desabilita os campos quando tem documento gerado no recebimento. */

    ASSIGN l-habilita-bt-conf = YES.

    /* Desabilita de a natureza de opera‡Æo for de nota complementar */
    IF CAN-FIND(FIRST natur-oper
                WHERE natur-oper.nat-operacao = tt-decla-import.cod-natur-operac
                AND   natur-oper.nota-rateio)THEN
                ASSIGN l-habilita-bt-conf = NO.

    ASSIGN btConfTrib:SENSITIVE IN FRAME fPage0 = l-habilita-bt-conf.

    IF i-modificacao <> 0 THEN
        APPLY "CHOOSE":U TO btCanHistorico IN FRAME fPage4.
    ASSIGN l-alterando = NO.
    APPLY "VALUE-CHANGED":U TO brHistorico IN FRAME fPage4.

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

ENABLE btObservacao WITH FRAME fPage1.

IF cAction = "ADD":U THEN DO:
    RUN geraUltimaSeqDi IN {&hDBOTable} (OUTPUT tt-decla-import.num-di-ems).

    ASSIGN tt-decla-import.num-di-ems:SCREEN-VALUE IN FRAME fPage0 = STRING(tt-decla-import.num-di-ems)
           tt-decla-import.cdd-siscomex-dts = 0
           tt-decla-import.num-seq-retif    = 0
           tt-decla-import.num-seq-retif:SCREEN-VALUE IN FRAME fPage0 = STRING(tt-decla-import.num-seq-retif)
           /*cb-tipo-declaracao:SCREEN-VALUE IN FRAME fPage1 = "0"*/ .
END.

IF  cAction = "UPDATE" THEN DO:
    RUN pi-verifica-embarques-vinculados.

    APPLY 'ENTRY':U TO tt-decla-import.cod-di-siscomex IN FRAME fPage0.
END.

IF INT(tt-decla-import.num-seq-retif:SCREEN-VALUE IN FRAME fPage0) = 0 THEN
    RUN pi-controla-retif(INPUT NO,
                          INPUT YES).
ELSE DO:
    IF cAction <> "ADD" THEN
        RUN pi-controla-retif(INPUT YES,
                              INPUT NO).
    ELSE
        RUN pi-controla-retif(INPUT NO,
                              INPUT NO).
END.

IF cAction = "UPDATE":U THEN
    ASSIGN cb-tipo-declaracao:SENSITIVE IN FRAME fPage1 = NO.

ENABLE brProcessoVinc WITH FRAME fPage2.
ASSIGN tt-decla-imp-proc-aux.desc-tipo         :READ-ONLY IN BROWSE brProcessoVinc = YES
       tt-decla-imp-proc-aux.cod-proces-vincul :READ-ONLY IN BROWSE brProcessoVinc = YES.

ENABLE brEmbalagem    WITH FRAME fPage3.
ASSIGN tt-decla-import-embal.cod-sig-embal     :READ-ONLY IN BROWSE brEmbalagem = YES
       tt-decla-import-embal.qtd-vol-embal     :READ-ONLY IN BROWSE brEmbalagem = YES.

IF NOT CAN-FIND(FIRST tt-decla-imp-proc) THEN
    ENABLE btAddProcessoVinc WITH FRAME fPage2.
ELSE
    ENABLE btAddProcessoVinc
           btDelProcessoVinc WITH FRAME fPage2.

IF NOT CAN-FIND(FIRST tt-decla-import-embal) THEN
    ENABLE btAddEmbalagem WITH FRAME fPage3.
ELSE
    ENABLE btAddEmbalagem
           btDelEmbalagem WITH FRAME fPage3.

DISABLE tt-decla-import.val-peso-liq-di
        tt-decla-import.val-peso-brut-tot-di
        tt-decla-import.val-peso-brut-merc WITH FRAME fPage3.

APPLY 'VALUE-CHANGED' TO cb-carac-oper        IN FRAME fPage1.
APPLY 'VALUE-CHANGED' TO rs-tipo-apresentacao IN FRAME fPage4.
APPLY 'VALUE-CHANGED' TO rs-apres-despesa     IN FRAME fPage5.

DISABLE btAddSon1 btDeleteSon1 btUpdateSon1 WITH FRAME fPage4.
DISABLE btAddSon2 btDeleteSon2 btUpdateSon2 btConfere-desp WITH FRAME fPage5.

RUN pi-tipo-apresentacao.
RUN pi-apres-despesa.
RUN pi-botoes (INPUT NO).
RUN pi-busca-logs.
RUN pi-altera-di. /* desabilita os campos quando tem documento gerado no recebimento. */

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
    IF NOT l-nt2024002 THEN DO:
        RUN deletefolder IN hFolder (INPUT 7).
    END.

    /*---[ Inicializa a tela mostrando todas as ativas ]---*/
    ASSIGN l-param-ativo = YES.
    RUN pi-buscaByFiltro.
    /*-----------------------------------------------------*/
    RUN pi-botoes (INPUT YES).

    IF AVAIL tt-decla-import THEN DO:
        ASSIGN tt-decla-import.num-di-ems   :SENSITIVE IN FRAME fPage0 = NO
               tt-decla-import.num-seq-retif:SENSITIVE IN FRAME fPage0 = NO.
    END.

    /* Hist¢rico */
    IF CAN-FIND(FIRST tt-histor-decla-import) THEN
        ENABLE btAddSon1 btDeleteSon1 btUpdateSon1 WITH FRAME fPage4.
    ELSE
        DISABLE btAddSon1 btDeleteSon1 btUpdateSon1 WITH FRAME fPage4.

    ENABLE brHistorico WITH FRAME fPage4.

    RUN pi-trata-browser-historico (INPUT YES).

    /* Despesa */
    IF  CAN-FIND(FIRST tt-despes-decla-import)
    THEN ENABLE btAddSon2 btDeleteSon2 btUpdateSon2 WITH FRAME fPage5.
    ELSE DISABLE btDeleteSon2 btUpdateSon2 btConfere-desp WITH FRAME fPage5.

    ENABLE brDespesa WITH FRAME fPage5.

    RUN pi-trata-browser-despesa (INPUT YES).

    RUN pi-busca-impostos.
    RUN pi-busca-valores.
    RUN pi-busca-logs.
    RUN pi-altera-di. /* desabilita os campos quando tem documento gerado no recebimento. */

    RUN goToKey IN h-bocx336 (INPUT c-seg-usuario).
    IF RETURN-VALUE = "OK":U THEN
        RUN GetLogField IN h-bocx336(INPUT "log-perm-pto-control-imp":U, OUTPUT log-perm-pto-control-imp).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenance
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF INT(tt-decla-import.num-seq-retif:SCREEN-VALUE IN FRAME fPage0) = 0 THEN
        RUN pi-controla-retif(INPUT NO,
                              INPUT YES).
    ELSE DO:
        RUN pi-controla-retif(INPUT NO,
                              INPUT NO).
    END.

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
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                        ASSIGN cAuxTraducao001 = {cxinc/i01cx383.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-motivo-retif:LIST-ITEM-PAIRS         in frame fPage0 = cAuxTraducao001
                           cAuxTraducao001 = ""
               cAuxTraducao001 = {cxinc/i02cx383.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-tipo-declaracao:LIST-ITEM-PAIRS         in frame fPage1 = cAuxTraducao001 /*PASTA PRINCIPAL*/
                           cAuxTraducao001 = ""
               cAuxTraducao001 = {cxinc/i03cx383.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-carac-oper:LIST-ITEM-PAIRS         in frame fPage1 = cAuxTraducao001
                           cAuxTraducao001 = ""
               cAuxTraducao001 = {cxinc/i04cx383.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-mod-desp:LIST-ITEM-PAIRS         in frame fPage1 = cAuxTraducao001
                           cAuxTraducao001 = ""
                cAuxTraducao001 = {adinc/i01ad268.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-via-transporte:LIST-ITEM-PAIRS         in frame fPage2 = cAuxTraducao001 /*PASTA TRANSPORTE*/
                           cAuxTraducao001 = ""
               cAuxTraducao001 = {cxinc/i06cx383.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-docto-carg:LIST-ITEM-PAIRS         in frame fPage2 = cAuxTraducao001
                           cAuxTraducao001 = ""
               cAuxTraducao001 = {cxinc/i07cx383.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-tipo-conhecto:LIST-ITEM-PAIRS         in frame fPage2 = cAuxTraducao001
                           cAuxTraducao001 = ""
               cAuxTraducao001 = {cxinc/i08cx383.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-ind-utiliz:LIST-ITEM-PAIRS         in frame fPage2 = cAuxTraducao001.
    &else
        ASSIGN cb-motivo-retif:list-items           in frame fPage0 = {cxinc/i01cx383.i 03}
               cb-tipo-declaracao:list-items        in frame fPage1 = {cxinc/i02cx383.i 03} /*PASTA PRINCIPAL*/
               cb-carac-oper:list-items             in frame fPage1 = {cxinc/i03cx383.i 03}
               cb-mod-desp:list-items               in frame fPage1 = {cxinc/i04cx383.i 03}
               cb-via-transporte:list-items         in frame fPage2 = {adinc/i01ad268.i 03} /*PASTA TRANSPORTE*/
               cb-docto-carg:list-items             in frame fPage2 = {cxinc/i06cx383.i 03}
               cb-tipo-conhecto:list-items          in frame fPage2 = {cxinc/i07cx383.i 03}
               cb-ind-utiliz:list-items             in frame fPage2 = {cxinc/i08cx383.i 03}.
    &endif

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenance
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF cb-motivo-retif:HIDDEN IN FRAME fPage0 = NO THEN
        assign input frame fPage0 cb-motivo-retif
               tt-decla-import.idi-motiv-retif = {cxinc/i01cx383.i 06 cb-motivo-retif}
               tt-decla-import.dat-retif       = INPUT FRAME fPage0 tt-decla-import.dat-retif.
    ELSE
        ASSIGN tt-decla-import.idi-motiv-retif = 0
               tt-decla-import.dat-retif       = ?.

    ASSIGN OVERLAY(tt-decla-import.cod-livre-1, 3, 9) = INPUT FRAME fPage1 fi-cod-despachante.

    RUN pi-trata-combos (INPUT NO).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOParentHandle wMaintenance
PROCEDURE getDBOParentHandle :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pDBOHandle  AS HANDLE  NO-UNDO.

    ASSIGN pDBOHandle = h-bocx383.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOSonHandle wMaintenance
PROCEDURE getDBOSonHandle :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE  INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pDBOHandle  AS HANDLE  NO-UNDO.

    CASE pPageNumber:
        WHEN 5 THEN DO:
            ASSIGN pDBOHandle = h-bocx384.
        END.
        WHEN 6 THEN DO:
            ASSIGN pDBOHandle = h-bocx406.
        END.
    END CASE.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogPendRatDi wMaintenance
PROCEDURE getLogPendRatDi :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM p-log-pend-rat AS LOGICAL NO-UNDO.

ASSIGN p-log-pend-rat = tt-decla-import.log-pend-rat.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParentRecord wMaintenance
PROCEDURE getParentRecord :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-decla-import.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
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
         SIZE 58 BY 1.42
         BGCOLOR 7.

    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    DEFINE VARIABLE num-di-ems LIKE {&ttTable}.num-di-ems NO-UNDO.

    DEFINE FRAME fGoToRecord
        num-di-ems        LABEL "DI EMS" AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE
             THREE-D SCROLLABLE TITLE "V  Para Declara‡Æo Importa‡Æo" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    ASSIGN num-di-ems:WIDTH IN FRAME fGoToRecord = 12.

/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Declara‡Æo_Importa‡Æo"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN num-di-ems.

        RUN goToKeyCustom IN {&hDBOTable} (INPUT num-di-ems,
                                           INPUT 0). //cdd-siscomex-dts
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Declara‡Æo_Importa‡Æo" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).

            RETURN NO-APPLY.
        END.

        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).

        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ENABLE num-di-ems btGoToOK btGoToCancel
        WITH FRAME fGoToRecord.

    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "cxbo/bocx383.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx383.p YES}
        {btb/btb008za.i2 cxbo/bocx383.p '' {&hDBOTable}}
    END.

    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE (h-boad098) THEN RUN adbo/boad098.p PERSISTENT SET h-boad098.
    IF NOT VALID-HANDLE (h-boin245) THEN RUN inbo/boin245.p PERSISTENT SET h-boin245.
    IF NOT VALID-HANDLE (h-bocx396) THEN RUN cxbo/bocx396.p PERSISTENT SET h-bocx396.
    IF NOT VALID-HANDLE (h-bocx386) THEN RUN cxbo/bocx386.p PERSISTENT SET h-bocx386.

    IF  NOT VALID-HANDLE (h-bocx384) THEN DO:
        RUN cxbo/bocx384.p PERSISTENT SET h-bocx384.
        RUN openQueryStatic IN h-bocx384 (INPUT "Main":U) NO-ERROR.
    END.

    IF NOT VALID-HANDLE(h-bocx3842) THEN DO:
        RUN cxbo/bocx384.p PERSISTENT SET h-bocx3842.
        RUN openQueryStatic IN h-bocx3842 (INPUT "Main":U) NO-ERROR.
    END.

    IF  NOT VALID-HANDLE(h-boad268) THEN DO:
        RUN adbo/boad268na.p PERSISTENT SET h-boad268.
        RUN openQueryStatic IN h-boad268 (INPUT "Main":U) NO-ERROR.
    END.

    IF  NOT VALID-HANDLE(h-bocx407) THEN DO:
        RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.
        RUN openQueryStatic IN h-bocx407 (INPUT "Main":U) NO-ERROR.
    END.

    IF  NOT VALID-HANDLE(h-bocx110na) THEN DO:
        RUN cxbo/bocx110na.p PERSISTENT SET h-bocx110na.
        RUN openQueryStatic IN h-bocx110na (INPUT "Main":U) NO-ERROR.
    END.

    IF NOT VALID-HANDLE(h-bocx110)  THEN RUN cxbo/bocx110.p  PERSISTENT SET h-bocx110.
    IF NOT VALID-HANDLE(h-bocx230)  THEN RUN cxbo/bocx230.p  PERSISTENT SET h-bocx230.
    IF NOT VALID-HANDLE(h-bocx230a) THEN RUN cxbo/bocx230a.p PERSISTENT SET h-bocx230a.
    IF NOT VALID-HANDLE(h-bocx310)  THEN RUN cxbo/bocx310.p PERSISTENT SET h-bocx310.

        RUN openQueryStatic IN h-bocx110na (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-bocx406) THEN DO:
        RUN cxbo/bocx406.p PERSISTENT SET h-bocx406.
        RUN openQueryStatic IN h-bocx406 (INPUT "Main":U) NO-ERROR.
    END.

    IF NOT VALID-HANDLE (h-boad098na) THEN RUN adbo/boad098na.p PERSISTENT SET h-boad098na.
        RUN openQueryStatic IN h-boad098na (INPUT "Main":U) NO-ERROR.
    IF NOT VALID-HANDLE (h-boad039na) THEN RUN adbo/boad039na.p PERSISTENT SET h-boad039na.
        RUN openQueryStatic IN h-boad039na (INPUT "Main":U) NO-ERROR.
    IF NOT VALID-HANDLE (h-bocx095) THEN RUN cxbo/bocx095.p PERSISTENT SET h-bocx095.
        RUN openQueryStatic IN h-bocx095 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE (h-bocx383a) THEN DO:
        RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.
        RUN openQueryStatic IN h-bocx383a (INPUT "Main":U) NO-ERROR.
    END.

    IF NOT VALID-HANDLE (h-bocx403) THEN DO:
        RUN cxbo/bocx403.p PERSISTENT SET h-bocx403.
        RUN openQueryStatic IN h-bocx403 (INPUT "Main":U) NO-ERROR.
    END.

    IF NOT VALID-HANDLE(h-bocx336) THEN DO:
        RUN cxbo/bocx336.p PERSISTENT SET h-bocx336.
        RUN openQueryStatic IN h-bocx336 (INPUT "Main":U).
    END.

    IF NOT VALID-HANDLE(h-bocx404) THEN
        RUN cxbo/bocx404.p PERSISTENT SET h-bocx404.

    IF NOT VALID-HANDLE(h-bocx250) THEN DO:
        RUN cxbo/bocx250na.p PERSISTENT SET h-bocx250.
        RUN openQueryStatic IN h-bocx250 (INPUT "Main":U).
    END.

    IF NOT VALID-HANDLE(h-bocx402) THEN
        RUN cxbo/bocx402.p PERSISTENT SET h-bocx402.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-despesa wMaintenance
PROCEDURE pi-add-despesa :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    DISABLE btAddDespesa btUpdateDespesa WITH FRAME fPage5.
    ENABLE  btCanDespesa btSaveDespesa WITH FRAME fPage5.
    RUN pi-trata-browser-Despesa (INPUT NO).

    if  num-results("brDespesa") > 0 then do:
        find last tt-despes-decla-import no-error.
        if  avail tt-despes-decla-import then reposition brDespesa to rowid rowid(tt-despes-decla-import) no-error.
        brDespesa:insert-row("after") in frame fPage5.
    end. /* if  num-results("brDespesa") > 0 */
    else do trans:
        create tt-despes-decla-import.
        open query brDespesa for each tt-despes-decla-import.
        apply "entry" to tt-despes-decla-import.desc-tipo in browse brDespesa.
    end. /* else do trans: */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-despesa-di wMaintenance
PROCEDURE pi-add-despesa-di :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    IF  AVAIL tt-decla-import THEN DO:
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        RUN imp/im0400a.w PERSISTENT SET h-im0400a (INPUT ?,
                                                    INPUT tt-decla-import.r-Rowid,
                                                    INPUT 'ADD',
                                                    INPUT THIS-PROCEDURE,
                                                    INPUT 6).
        IF  VALID-HANDLE (h-im0400a) THEN DO:
            RUN initializeInterface IN h-im0400a.
            WAIT-FOR CLOSE OF h-im0400a FOCUS CURRENT-WINDOW.
        END.
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    END.

    RUN pi-apres-despesa.
    RUN pi-atualiza-registro-tela.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-despesa-embarque wMaintenance
PROCEDURE pi-add-despesa-embarque :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

ASSIGN i-cod-itiner = 0
       c-return     = ""
       r-desp-emb   = ?.

IF  AVAIL tt-decla-import THEN DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    RUN findFirstEmbarque IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-decla-import.cod-estab,
                                        INPUT INPUT FRAME fPage5 c-cod-emb-desp,
                                        OUTPUT c-return).
    IF  c-return = "" THEN DO:
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner', OUTPUT i-cod-itiner).
        RUN trazrowidhistemb IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-decla-import.cod-estab,
                                           INPUT INPUT FRAME fPage5 c-cod-emb-desp,
                                           INPUT i-cod-itiner,
                                           OUTPUT r-desp-emb).
    END.
    RUN imp/im0055.w PERSISTENT SET h-im0055.

    IF  VALID-HANDLE (h-im0055) THEN DO:
        IF r-desp-emb <> ? THEN RUN setaHistoricoEmbarque IN h-im0055(INPUT r-desp-emb).

        RUN initializeInterface   IN h-im0055.
        WAIT-FOR CLOSE OF h-im0055 FOCUS CURRENT-WINDOW.
    END.
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
END.

RUN pi-busca-despesas-embarque.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-embalagem wMaintenance
PROCEDURE pi-add-embalagem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DISABLE btAddEmbalagem
        btDelEmbalagem WITH FRAME fPage3.

ENABLE btCanEmbalagem
       btSaveEmbalagem WITH FRAME fPage3.

ASSIGN tt-decla-import-embal.cod-sig-embal          :READ-ONLY IN BROWSE brEmbalagem = NO
       tt-decla-import-embal.qtd-vol-embal          :READ-ONLY IN BROWSE brEmbalagem = NO.

if  num-results("brEmbalagem") > 0 then do:
    find last tt-decla-import-embal no-error.
    if  avail tt-decla-import-embal then
        reposition brEmbalagem to rowid rowid(tt-decla-import-embal) no-error.
    brEmbalagem:insert-row("after") in frame fPage3.
end.
else do trans:
    create tt-decla-import-embal.
    open query brEmbalagem for each tt-decla-import-embal.
    apply "entry" to tt-decla-import-embal.qtd-vol-embal in browse brEmbalagem.
end.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-historico wMaintenance
PROCEDURE pi-add-historico :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DISABLE btAddHistorico
        btUpdateHistorico WITH FRAME fPage4.

ENABLE btCanHistorico
       btSaveHistorico WITH FRAME fPage4.
RUN pi-trata-browser-historico (INPUT NO).

if  num-results("brHistorico") > 0 then do:
    find last tt-histor-decla-import no-error.
    if  avail tt-histor-decla-import then
        reposition brHistorico to rowid rowid(tt-histor-decla-import) no-error.
    brHistorico:insert-row("after") in frame fPage4.
end.
else do trans:
    create tt-histor-decla-import.
    open query brHistorico for each tt-histor-decla-import.
    apply "entry" to tt-histor-decla-import.num-seq in browse brHistorico.
end.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-historico-di wMaintenance
PROCEDURE pi-add-historico-di :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
IF AVAIL tt-decla-import THEN DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN imp/im0400b.w PERSISTENT SET h-im0400b (INPUT ?,
                                                INPUT tt-decla-import.r-Rowid,
                                                INPUT 'ADD',
                                                INPUT THIS-PROCEDURE,
                                                INPUT 5).
    IF  VALID-HANDLE (h-im0400b) THEN DO:
        RUN initializeInterface IN h-im0400b.
        WAIT-FOR CLOSE OF h-im0400b FOCUS CURRENT-WINDOW.
    END.
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-historico-embarque wMaintenance
PROCEDURE pi-add-historico-embarque :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
ASSIGN i-cod-itiner = 0
       c-return     = ""
       r-hist-emb   = ?.

IF AVAIL tt-decla-import THEN DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    RUN findFirstEmbarque IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-decla-import.cod-estab,
                                        INPUT INPUT FRAME fPage4 c-cod-embarq,
                                        OUTPUT c-return).
    IF c-return = "" THEN DO:
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner',
                                      OUTPUT i-cod-itiner).

        RUN trazrowidhistemb IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-decla-import.cod-estab,
                                           INPUT INPUT FRAME fPage4 c-cod-embarq,
                                           INPUT i-cod-itiner,
                                           OUTPUT r-hist-emb).
    END.
    RUN imp/im0055.w PERSISTENT SET h-im0055.
        /*(INPUT ?,INPUT tt-historico-embarque.r-Rowid,INPUT 'ADD',INPUT THIS-PROCEDURE,INPUT 5).*/
    IF  VALID-HANDLE (h-im0055) THEN DO:
        IF r-hist-emb <> ? THEN
            RUN setaHistoricoEmbarque IN h-im0055(INPUT r-hist-emb).

        RUN initializeInterface   IN h-im0055.
        WAIT-FOR CLOSE OF h-im0055 FOCUS CURRENT-WINDOW.
    END.
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
END.

RUN pi-busca-historicos-embarque.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-processo-vinc wMaintenance
PROCEDURE pi-add-processo-vinc :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DISABLE btAddProcessoVinc
        btDelProcessoVinc WITH FRAME fPage2.

ENABLE btCanProcVinc
       btSaveProcessoVinc WITH FRAME fPage2.
ASSIGN tt-decla-imp-proc-aux.desc-tipo         :READ-ONLY IN BROWSE brProcessoVinc = NO
       tt-decla-imp-proc-aux.cod-proces-vincul :READ-ONLY IN BROWSE brProcessoVinc = NO.

if  num-results("brProcessoVinc") > 0 then do:
    find last tt-decla-imp-proc-aux no-error.
    if  avail tt-decla-imp-proc-aux then
        reposition brProcessoVinc to rowid rowid(tt-decla-imp-proc-aux) no-error.
    brProcessoVinc:insert-row("after") in frame fPage2.
end.
else do trans:
    create tt-decla-imp-proc-aux.
    open query brProcessoVinc for each tt-decla-imp-proc-aux.
    apply "entry" to tt-decla-imp-proc-aux.desc-tipo in browse brProcessoVinc.
end.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-di wMaintenance
PROCEDURE pi-altera-di :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    /*--- Altera‡Æo da DI ------------------------------------------------------------------*/
    IF  VALID-HANDLE(h-bocx383a) AND AVAIL tt-decla-import THEN DO:
        RUN piDoctoRecebimento IN h-bocx383a(INPUT tt-decla-import.cod-di-siscomex, OUTPUT l-encontrou).
        /*RUN pi-verifica-saldo-positivo IN h-bocx404 (INPUT tt-decla-import.num-di-ems, INPUT tt-decla-import.cdd-siscomex-dts, OUTPUT l-saldo-positivo).
        ASSIGN btRetificacao:SENSITIVE IN FRAME fPage0 = l-saldo-positivo.
        */
        IF  l-encontrou THEN DO:
            DISABLE btCotacaoDI
                    /*btRateio pode calcular os impostos pois a nota mae altera a tributacao dos impostos*/
                    //btRetificacao
            WITH FRAME fPage0.

            IF  cAction = "UPDATE" THEN DO:
                DISABLE cb-carac-oper
                        tt-decla-import.log-fundap
                        cb-mod-desp
                        tt-decla-import.num-adicoes
                        tt-decla-import.cod-natur-operac
                    WITH FRAME fPage1.

                DISABLE tt-decla-import.cdn-urf-entr
                        tt-decla-import.cdn-urf-despch
                        brProcessoVinc
                        btAddProcessoVinc
                        btCanProcVinc
                        btSaveProcessoVinc
                        btDelProcessoVinc
                    WITH FRAME fPage2.

                DISABLE cb-via-transporte
                        cb-docto-carg
                        tt-decla-import.cod-identif
                        tt-decla-import.cdn-transpdor
                        cb-tipo-conhecto
                        cb-ind-utiliz
                        tt-decla-import.cod-conhecto-master
                        tt-decla-import.cod-conhecto-house
                    WITH FRAME fPage2.

                DISABLE tt-decla-import.cdn-pais-proceden
                        tt-decla-import.cdn-agent-carg-import
                        tt-decla-import.val-peso-liq-di
                        tt-decla-import.val-peso-brut-merc
                        tt-decla-import.val-peso-embal-di
                        tt-decla-import.val-peso-brut-tot-di
                        tt-decla-import.cdn-recinto-alfand
                        tt-decla-import.cdn-setor-armaz
                        brEmbalagem
                        btAddEmbalagem
                        btCanEmbalagem
                        btSaveEmbalagem
                        btDelEmbalagem
                    WITH FRAME fPage3.

                FOR FIRST histor-decla-import NO-LOCK
                    WHERE histor-decla-import.num-di-ems = tt-decla-import.num-di-ems
                       AND histor-decla-import.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts:
                    ASSIGN i-pto-nacionalizacao = histor-decla-import.cdn-pto-nacionaliz.
                END. /* FOR FIRST histor-decla-import */
            END. /* IF cAction = "UPDATE" THEN DO: */
        END. /* IF  l-encontrou THEN DO: */
        ELSE DO:
            ENABLE  btCotacaoDI
                    btRateio
                    //btRetificacao
                WITH FRAME fPage0.
        END.
    END. /* IF  VALID-HANDLE(h-bocx383a) THEN DO: */
    /*--- FIM - Altera‡Æo da DI ------------------------------------------------------------*/
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-nat-operacao-ordens wMaintenance
PROCEDURE pi-altera-nat-operacao-ordens :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
RUN imp/im0400e.w PERSISTENT SET h-im0400e (INPUT tt-decla-import.num-di-ems,
                                            INPUT tt-decla-import.cdd-siscomex-dts,
                                            INPUT THIS-PROCEDURE,
                                            INPUT h-bocx383).
IF  VALID-HANDLE (h-im0400e) THEN DO:
    RUN initializeInterface IN h-im0400e.
    WAIT-FOR CLOSE OF h-im0400e FOCUS CURRENT-WINDOW.
END.
ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apres-despesa wMaintenance
PROCEDURE pi-apres-despesa :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
IF INPUT FRAME fPage5 rs-apres-despesa = 1 THEN DO:
    ASSIGN c-cod-emb-desp = "".
    DISP c-cod-emb-desp WITH FRAME fPage5.
    DISABLE c-cod-emb-desp WITH FRAME fPage5.

    IF NOT l-apres-desp THEN DO:
        IF cAction <> '' THEN
            IF NOT CAN-FIND(FIRST tt-despes-decla-import) THEN
                DISABLE btAddDespesa btCanDespesa btUpdateDespesa btSaveDespesa WITH FRAME fPage5.

            ELSE DO:
                ENABLE  btAddDespesa btUpdateDespesa WITH FRAME fPage5.
                DISABLE btCanDespesa btSaveDespesa    WITH FRAME fPage5.
            END.

        RUN pi-busca-despesas-di.

        IF cAction = '' THEN DO:
            ENABLE btAddSon2 WITH FRAME fPage5.

            IF NOT CAN-FIND(FIRST tt-despes-decla-import) THEN DO:
                DISABLE btUpdateSon2 btDeleteSon2
                        WITH FRAME fPage5.
            END.
            ELSE DO:
                ENABLE btUpdateSon2 btDeleteSon2
                       WITH FRAME fPage5.
            END.

        END.
    END.
    ELSE DO:
        DISABLE btAddDespesa btCanDespesa btSaveDespesa btUpdateDespesa
                btAddSon2 btUpdateSon2 btDeleteSon2
            WITH FRAME fPage5.
    END.

    DISABLE btConfere-desp
        WITH FRAME fPage5.

END.
ELSE DO:
    DISABLE btAddDespesa btCanDespesa btSaveDespesa btUpdateDespesa
        btAddSon2 btUpdateSon2 btDeleteSon2
        WITH FRAME fPage5.
    ENABLE c-cod-emb-desp btAtualizaEmb-desp btConfere-desp WITH FRAME fPage5.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza wMaintenance
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF  INPUT FRAME fPage4 rs-tipo-apresentacao = 1 THEN DO:
        RUN pi-busca-historicos-di.

        IF  NOT CAN-FIND(FIRST tt-histor-decla-import) THEN DO:
            ENABLE btAddHistorico WITH FRAME fPage4.
            DISABLE btCanHistorico btUpdateHistorico btSaveHistorico WITH FRAME fPage4.
        END. /* IF  NOT CAN-FIND(FIRST tt-histor-decla-import) */
        ELSE DO:
            ENABLE  btAddHistorico btUpdateHistorico WITH FRAME fPage4.
            DISABLE btCanHistorico btSaveHistorico    WITH FRAME fPage4.
        END. /* ELSE DO: */
    END. /* IF  INPUT FRAME fPage4 rs-tipo-apresentacao = 1 */
    ELSE DO:
        RUN pi-busca-historicos-embarque.
        ENABLE btUpdateHistorico WITH FRAME fPage4.
    END. /* ELSE DO: */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-desp wMaintenance
PROCEDURE pi-atualiza-desp :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    IF  INPUT FRAME fPage5 rs-apres-despesa = 1 /* DI */ THEN DO:
        RUN pi-busca-despesas-di.

        IF  NOT CAN-FIND(FIRST tt-despes-decla-import) THEN DO:
            ENABLE btAdddespesa WITH FRAME fPage5.
            DISABLE btCandespesa btUpdatedespesa btSavedespesa WITH FRAME fPage5.
        END.
        ELSE DO:
            ENABLE  btAdddespesa btUpdatedespesa WITH FRAME fPage5.
            DISABLE btCandespesa btSavedespesa    WITH FRAME fPage5.
        END.
    END.
    ELSE RUN pi-busca-despesas-embarque.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-registro-tela wMaintenance
PROCEDURE pi-atualiza-registro-tela :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
IF AVAIL tt-decla-import THEN DO:
    RUN goToKey IN h-bocx383(INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                            INPUT INPUT FRAME fPage0 tt-decla-import.num-seq-retif,
                            INPUT tt-decla-import.cdd-siscomex-dts). //decla-import.cdd-siscomex-dts
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getRecord IN h-bocx383(OUTPUT TABLE tt-decla-import).
        RUN displayFields.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-valores wMaintenance
PROCEDURE pi-atualiza-valores :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
IF AVAIL tt-decla-import THEN DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN imp/im0400g.w PERSISTENT SET h-im0400g (INPUT tt-decla-import.num-di-ems,
                                                INPUT tt-decla-import.num-seq-retif,
                                                INPUT tt-decla-import.cdd-siscomex-dts).
    IF  VALID-HANDLE (h-im0400g) THEN DO:
        RUN initializeInterface IN h-im0400g.
        WAIT-FOR CLOSE OF h-im0400g FOCUS CURRENT-WINDOW.
    END.
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-botoes wMaintenance
PROCEDURE pi-botoes :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT PARAM lHabilita AS LOGICAL NO-UNDO.

    ASSIGN btAdicoes         :SENSITIVE IN FRAME fPage0 = lHabilita
           btRateio          :SENSITIVE IN FRAME fPage0 = lHabilita
           btCotacaoDi       :SENSITIVE IN FRAME fPage0 = lHabilita
           btFiltro          :SENSITIVE IN FRAME fPage0 = lHabilita
           MENU-ITEM m_Filtro:SENSITIVE IN MENU  mbMain = lHabilita
           btRetificacao     :SENSITIVE IN FRAME fPage0 = NO
           btVincEmb         :SENSITIVE IN FRAME fPage0 = lHabilita
           btDocRelac        :SENSITIVE IN FRAME fPage0 = lHabilita.

    IF AVAIL tt-decla-import THEN
        IF tt-decla-import.dat-di <> ? THEN
            ASSIGN btCotacaoDi   :SENSITIVE IN FRAME fPage0 = YES.
        ELSE
            ASSIGN btCotacaoDi   :SENSITIVE IN FRAME fPage0 = NO.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-despesas-di wMaintenance
PROCEDURE pi-busca-despesas-di :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-despes-decla-import.

    ASSIGN l-apres-desp = NO.

    RUN setConstraintByDeclaImport IN h-bocx406 (INPUT tt-decla-import.num-di-ems, INPUT tt-decla-import.cdd-siscomex-dts).
    RUN openQueryStatic            IN h-bocx406 (INPUT "ByDeclaImport":U).
    RUN getBatchRecords            IN h-bocx406 (INPUT  ?,
                                                 INPUT  ?,
                                                 INPUT  99999,
                                                 OUTPUT i-reg-retornados,
                                                 OUTPUT TABLE tt-despes-decla-import-aux).
    FOR EACH tt-despes-decla-import-aux:
        CREATE tt-despes-decla-import.
        BUFFER-COPY tt-despes-decla-import-aux TO tt-despes-decla-import.

        IF tt-despes-decla-import-aux.idi-tip-incid-nf = 1 THEN
            ASSIGN tt-despes-decla-import.desc-tipo = 'Nacionaliza‡Æo'.
        ELSE
            ASSIGN tt-despes-decla-import.desc-tipo = 'Complementar'.

        DELETE tt-despes-decla-import-aux.
    END.

    IF CAN-FIND(FIRST tt-despes-decla-import) THEN DO:
        ASSIGN tt-despes-decla-import.cdn-pto-control:VISIBLE IN BROWSE brDespesa = YES
               c-brw-desc-pto-control:VISIBLE IN BROWSE brDespesa = YES
               tt-despes-decla-import.desc-tipo:VISIBLE IN BROWSE brDespesa = YES.
    END.

    {&OPEN-QUERY-brDespesa}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-despesas-embarque wMaintenance
PROCEDURE pi-busca-despesas-embarque :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    ASSIGN i-cod-itiner = 0
           c-return     = "".

    RUN goToKey IN h-bocx407(INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                             INPUT INPUT FRAME fPage5 c-cod-emb-desp,
                             INPUT tt-decla-import.cdd-siscomex-dts). //cdd-siscomex-dts
    IF  RETURN-VALUE = "NOK" THEN DO:
        IF  cAction <> ""
        THEN /* Inicio -- Projeto Internacional */
 DO:
     {utp/ut-liter.i "Embarque_selecionado_nÆo_est _vinculado_a_DI" *}
     RUN utp/ut-msgs.p (INPUT 'show', INPUT 17006, INPUT RETURN-VALUE + '.').
 END.
        ELSE DO:
            EMPTY TEMP-TABLE tt-desp-embarque.
            EMPTY TEMP-TABLE tt-despes-decla-import.
            {&OPEN-QUERY-brDespesa}
        END. /* ELSE DO: */
    END. /* IF  RETURN-VALUE = "NOK" */
    ELSE DO:
        ASSIGN l-apres-desp = YES.

        RUN findFirstEmbarque IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-decla-import.cod-estab,
                                            INPUT INPUT FRAME fPage5 c-cod-emb-desp,
                                            OUTPUT c-return).
        IF  c-return = "" THEN DO:
            EMPTY TEMP-TABLE tt-desp-embarque.
            EMPTY TEMP-TABLE tt-despes-decla-import.

            RUN setConstraint3 IN h-bocx310 (INPUT INPUT FRAME fPage0 tt-decla-import.cod-estab,
                                             INPUT INPUT FRAME fPage5 c-cod-emb-desp).

                /*--- Abre query do DBO filho ---*/
            RUN openQuery IN h-bocx310 (INPUT 3).

                /*--- Posiciona DBO filho no primeiro registro, caso necess rio ---*/
            RUN findFirst IN h-bocx310.

                /*--- Retorna faixa de registro do DBO Filho ---*/
            RUN serverSendRows IN h-bocx310 (INPUT ?,
                                             INPUT ?,
                                             INPUT NO,
                                             INPUT ?,
                                             OUTPUT rowsreturn,
                                             OUTPUT TABLE tt-desp-embarque).
            FOR EACH tt-desp-embarque:
                CREATE tt-despes-decla-import.
                ASSIGN tt-despes-decla-import.cdn-cond-pagto            = tt-desp-embarque.cod-cond-pag
                       tt-despes-decla-import.cdn-despes                = tt-desp-embarque.cod-desp
                       tt-despes-decla-import.cdn-emit-despes           = tt-desp-embarque.cod-emitente-desp
                       tt-despes-decla-import.cdn-itiner                = tt-desp-embarque.cod-itiner
                       tt-despes-decla-import.cdn-moeda                 = tt-desp-embarque.mo-codigo
                       tt-despes-decla-import.cdn-pto-control           = tt-desp-embarque.cod-pto-contr
                       tt-despes-decla-import.cod-incoterm-rat          = tt-desp-embarque.cod-incoterm-rat
                       tt-despes-decla-import.log-forma-preco-compra    = tt-desp-embarque.log-forma-preco-compra
                       tt-despes-decla-import.num-di-ems                = INPUT FRAME fPage0 tt-decla-import.num-di-ems
                       tt-despes-decla-import.val-despes                = tt-desp-embarque.val-desp
                       tt-despes-decla-import.cdd-siscomex-dts          = tt-decla-import.cdd-siscomex-dts.
            END.

            IF CAN-FIND(FIRST tt-despes-decla-import) THEN DO:
                ENABLE btAddSon2 WITH FRAME fPage5.
                ASSIGN tt-despes-decla-import.cdn-pto-control:VISIBLE IN BROWSE brDespesa = YES
                       c-brw-desc-pto-control:VISIBLE IN BROWSE brDespesa = YES
                       tt-despes-decla-import.desc-tipo:VISIBLE IN BROWSE brDespesa = NO.
            END.
            ELSE
                DISABLE btAddSon2 WITH FRAME fPage5.

                {&OPEN-QUERY-brDespesa}
        END.
        ELSE DO:
            IF  cAction <> "" THEN
                /* Inicio -- Projeto Internacional */
                DO:
                {utp/ut-liter.i "Embarque_Importa‡Æo" *}
                RUN utp/ut-msgs.p (INPUT 'show', INPUT 2, INPUT RETURN-VALUE).
                END.
            ELSE DO:
                EMPTY TEMP-TABLE tt-desp-embarque.
                EMPTY TEMP-TABLE tt-despes-decla-import.
                {&OPEN-QUERY-brDespesa}
            END.
        END.
    END. /* ELSE DO: */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-doc-relacs wMaintenance
PROCEDURE pi-busca-doc-relacs :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN imp/im0400i.w PERSISTENT SET h-im0400i (INPUT tt-decla-import.r-Rowid,
                                                INPUT 'UPDATE',
                                                INPUT THIS-PROCEDURE).
    IF  VALID-HANDLE (h-im0400i) THEN DO:
        RUN initializeInterface IN h-im0400i.
        WAIT-FOR CLOSE OF h-im0400i FOCUS CURRENT-WINDOW.
    END.
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-embalagens wMaintenance
PROCEDURE pi-busca-embalagens :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
FOR EACH tt-decla-import-embal:
    DELETE tt-decla-import-embal.
END.
IF AVAIL tt-decla-import THEN DO:
    ASSIGN INPUT FRAME fPage0 tt-decla-import.num-di-ems.

    /*BUSCA PROCESSOS RELACIONADOS*/
    RUN setConstraintByNumDiEms IN h-bocx386 (INPUT tt-decla-import.num-di-ems, INPUT tt-decla-import.cdd-siscomex-dts).
    RUN openQueryStatic         IN h-bocx386 (INPUT "ByNumDiEms":U).
    RUN getBatchRecords         IN h-bocx386 (INPUT  ?,
                                              INPUT  ?,
                                              INPUT  99999,
                                              OUTPUT i-reg-retornados,
                                              OUTPUT TABLE tt-decla-import-embal).

    {&OPEN-QUERY-brEmbalagem}
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-historicos-di wMaintenance
PROCEDURE pi-busca-historicos-di :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-histor-decla-import.

    ASSIGN l-tipo-apres = NO.

    RUN setConstraintByDeclaImport IN h-bocx384 (INPUT tt-decla-import.num-di-ems, INPUT tt-decla-import.cdd-siscomex-dts).
    RUN openQueryStatic            IN h-bocx384 (INPUT "ByDeclaImport":U).
    RUN getBatchRecords            IN h-bocx384 (INPUT  ?,
                                                 INPUT  ?,
                                                 INPUT  99999,
                                                 OUTPUT i-reg-retornados,
                                                 OUTPUT TABLE tt-histor-decla-import).

    {&OPEN-QUERY-brHistorico}

    /*IF CAN-FIND(FIRST tt-histor-decla-import) THEN
        ENABLE btAddSon1 btDeleteSon1 btUpdateSon1 WITH FRAME fPage4.
    ELSE
        DISABLE btAddSon1 btDeleteSon1 btUpdateSon1 WITH FRAME fPage4.*/

    RUN pi-pto-nacionaliz.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-historicos-embarque wMaintenance
PROCEDURE pi-busca-historicos-embarque :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
ASSIGN i-cod-itiner = 0
       c-return     = "".

RUN goToKey IN h-bocx407(INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                         INPUT INPUT FRAME fPage4 c-cod-embarq,
                         INPUT tt-decla-import.cdd-siscomex-dts). //cdd-siscomex-dts
IF RETURN-VALUE = "NOK" THEN DO:
    IF cAction <> "" THEN
        /* Inicio -- Projeto Internacional */
        DO:
        {utp/ut-liter.i "Embarque_selecionado_nÆo_est _vinculado_a_DI" *}
        RUN utp/ut-msgs.p (INPUT 'show',
                        INPUT 17006,
                        INPUT RETURN-VALUE + '.').
        END.
    ELSE DO:
        EMPTY TEMP-TABLE tt-historico-embarque.
        EMPTY TEMP-TABLE tt-histor-decla-import.
        {&OPEN-QUERY-brHistorico}
    END.
END.
ELSE DO:
    ASSIGN l-tipo-apres = YES.

    RUN findFirstEmbarque IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-decla-import.cod-estab,
                                        INPUT INPUT FRAME fPage4 c-cod-embarq,
                                        OUTPUT c-return).
    IF c-return = "" THEN DO:
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner',
                                      OUTPUT i-cod-itiner).

        EMPTY TEMP-TABLE tt-historico-embarque.
        EMPTY TEMP-TABLE tt-histor-decla-import.

        RUN trazrowidhistemb IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-decla-import.cod-estab,
                                           INPUT INPUT FRAME fPage4 c-cod-embarq,
                                           INPUT i-cod-itiner,
                                           OUTPUT r-hist-emb).

        run setConstraint4 IN h-bocx230a (INPUT r-hist-emb,
                                          INPUT INPUT FRAME fPage0 tt-decla-import.cod-estab,
                                          INPUT i-cod-itiner,
                                          INPUT INPUT FRAME fPage4 c-cod-embarq).

        run OpenQuery in h-bocx230a (input 4).

        run findFirst in h-bocx230a.
        run serverSendRows in h-bocx230a (input ?,
                                          input ?,
                                          input no,
                                          input ?,
                                          output rowsreturn,
                                          output table tt-historico-embarque).

        FOR EACH tt-historico-embarque:
            CREATE tt-histor-decla-import.
            ASSIGN tt-histor-decla-import.num-di-ems          = INPUT FRAME fPage0 tt-decla-import.num-di-ems
                   tt-histor-decla-import.num-seq             = tt-historico-embarque.sequencia
                   tt-histor-decla-import.descricao           = tt-historico-embarque.descricao
                   tt-histor-decla-import.cdn-pto-control     = tt-historico-embarque.cod-pto-contr
                   tt-histor-decla-import.cdn-pto-nacionaliz  = INPUT FRAME fPage4 i-cdn-pto-nacionaliz
                   tt-histor-decla-import.cod-meio-transp     = tt-historico-embarque.id-meio-transp
                   tt-histor-decla-import.dat-efetiva         = tt-historico-embarque.dt-efetiva
                   tt-histor-decla-import.nr-dias             = tt-historico-embarque.nr-dias
                   tt-histor-decla-import.dat-prev-origin     = tt-historico-embarque.dt-previsao
                   tt-histor-decla-import.dat-ult-prev        = tt-historico-embarque.dt-ult-previsao
                   tt-histor-decla-import.dsl-obs             = tt-historico-embarque.observacao
                   overlay(tt-histor-decla-import.cod-livre-1,6,2) = SUBSTR(tt-historico-embarque.char-1,1,2)
                   tt-histor-decla-import.cdd-siscomex-dts    = tt-decla-import.cdd-siscomex-dts.
        END.

        IF CAN-FIND(FIRST tt-histor-decla-import) THEN DO:
            {&OPEN-QUERY-brHistorico}
            ENABLE btAddSon1 WITH FRAME fPage4.
        END.
        ELSE
            DISABLE btAddSon1 WITH FRAME fPage4.

    END.
    ELSE DO:
        IF cAction <> "" THEN
            /* Inicio -- Projeto Internacional */
            DO:
            {utp/ut-liter.i "Embarque_Importa‡Æo" *}
            RUN utp/ut-msgs.p (INPUT 'show',
                            INPUT 2,
                            INPUT RETURN-VALUE).
            END.
        ELSE DO:
            EMPTY TEMP-TABLE tt-historico-embarque.
            EMPTY TEMP-TABLE tt-histor-decla-import.
            {&OPEN-QUERY-brHistorico}
        END.

    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-impostos wMaintenance
PROCEDURE pi-busca-impostos :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEF VAR de-v-base-ii            LIKE decla-import.val-base-ii           NO-UNDO.
    DEF VAR de-v-susp-ii            LIKE decla-import.val-ii-nao-tribut     NO-UNDO.
    DEF VAR de-v-recolhe-ii         LIKE decla-import.val-ii-db-cr          NO-UNDO.
    DEF VAR de-v-outros-ii          LIKE decla-import.val-ii-outras         NO-UNDO.

    DEF VAR de-v-base-ipi           LIKE decla-import.val-base-ipi          NO-UNDO.
    DEF VAR de-v-susp-ipi           LIKE decla-import.val-ipi-nao-tribut    NO-UNDO.
    DEF VAR de-v-recolhe-ipi        LIKE decla-import.val-ipi-db-cr         NO-UNDO.
    DEF VAR de-v-outros-ipi         LIKE decla-import.val-ipi-outras        NO-UNDO.

    DEF VAR de-v-base-pis           LIKE decla-import.val-base-pis          NO-UNDO.
    DEF VAR de-v-susp-pis           LIKE decla-import.val-pis-nao-tribut    NO-UNDO.
    DEF VAR de-v-recolhe-pis        LIKE decla-import.val-pis-db-cr         NO-UNDO.
    DEF VAR de-v-outros-pis         LIKE decla-import.val-pis-outras        NO-UNDO.

    DEF VAR de-v-base-cofins        LIKE decla-import.val-base-cofins       NO-UNDO.
    DEF VAR de-v-susp-cofins        LIKE decla-import.val-cofins-nao-tribut NO-UNDO.
    DEF VAR de-v-recolhe-cofins     LIKE decla-import.val-cofins-db-cr      NO-UNDO.
    DEF VAR de-v-outros-cofins      LIKE decla-import.val-cofins-outras     NO-UNDO.

    DEF VAR de-v-base-icms          LIKE decla-import.val-base-icms         NO-UNDO.
    DEF VAR de-v-susp-icms          LIKE decla-import.val-icms-nao-tribut   NO-UNDO.
    DEF VAR de-v-recolhe-icms       LIKE decla-import.val-icms-db-cr        NO-UNDO.
    DEF VAR de-v-outros-icms        LIKE decla-import.val-icms-outras       NO-UNDO.

    DEF VAR de-v-base-fcp           LIKE decla-import.val-base-icms         NO-UNDO.
    DEF VAR de-v-susp-fcp           LIKE decla-import.val-icms-nao-tribut   NO-UNDO.
    DEF VAR de-v-recolhe-fcp        LIKE decla-import.val-icms-db-cr        NO-UNDO.
    DEF VAR de-v-outros-fcp         LIKE decla-import.val-icms-outras       NO-UNDO.

    DEF VAR de-v-base-fcp-st        LIKE decla-import.val-base-icms         NO-UNDO.
    DEF VAR de-v-susp-fcp-st        LIKE decla-import.val-icms-nao-tribut   NO-UNDO.
    DEF VAR de-v-recolhe-fcp-st     LIKE decla-import.val-icms-db-cr        NO-UNDO.
    DEF VAR de-v-outros-fcp-st      LIKE decla-import.val-icms-outras       NO-UNDO.

    DEF VAR de-v-base-icms-st       LIKE decla-import.val-base-icms         NO-UNDO.
    DEF VAR de-v-susp-icms-st       LIKE decla-import.val-icms-nao-tribut   NO-UNDO.
    DEF VAR de-v-recolhe-icms-st    LIKE decla-import.val-icms-db-cr        NO-UNDO.
    DEF VAR de-v-outros-icms-st     LIKE decla-import.val-icms-outras       NO-UNDO.

    DEF VAR de-v-base-icms-compl    LIKE decla-import.val-base-icms         NO-UNDO.
    DEF VAR de-v-susp-icms-compl    LIKE decla-import.val-icms-nao-tribut   NO-UNDO.
    DEF VAR de-v-recolhe-icms-compl LIKE decla-import.val-icms-db-cr        NO-UNDO.
    DEF VAR de-v-outros-icms-compl  LIKE decla-import.val-icms-outras       NO-UNDO.

    IF AVAIL tt-decla-import THEN
    RUN pi-busca-impostos IN {&hDBOTable} (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                           INPUT tt-decla-import.cdd-siscomex-dts, //cdd-siscomex-dts
                                           OUTPUT de-v-base-ii,
                                           OUTPUT de-v-susp-ii,
                                           OUTPUT de-v-recolhe-ii,
                                           OUTPUT de-v-outros-ii,

                                           OUTPUT de-v-base-ipi,
                                           OUTPUT de-v-susp-ipi,
                                           OUTPUT de-v-recolhe-ipi,
                                           OUTPUT de-v-outros-ipi,

                                           OUTPUT de-v-base-pis,
                                           OUTPUT de-v-susp-pis,
                                           OUTPUT de-v-recolhe-pis,
                                           OUTPUT de-v-outros-pis,

                                           OUTPUT de-v-base-cofins,
                                           OUTPUT de-v-susp-cofins,
                                           OUTPUT de-v-recolhe-cofins,
                                           OUTPUT de-v-outros-cofins,

                                           OUTPUT de-v-base-icms,
                                           OUTPUT de-v-susp-icms,
                                           OUTPUT de-v-recolhe-icms,
                                           OUTPUT de-v-outros-icms,

                                           OUTPUT de-v-base-fcp,
                                           OUTPUT de-v-susp-fcp,
                                           OUTPUT de-v-recolhe-fcp,
                                           OUTPUT de-v-outros-fcp,

                                           OUTPUT de-v-base-fcp-st,
                                           OUTPUT de-v-susp-fcp-st,
                                           OUTPUT de-v-recolhe-fcp-st,
                                           OUTPUT de-v-outros-fcp-st,

                                           OUTPUT de-v-base-icms-st,
                                           OUTPUT de-v-susp-icms-st,
                                           OUTPUT de-v-recolhe-icms-st,
                                           OUTPUT de-v-outros-icms-st,

                                           OUTPUT de-v-base-icms-compl,
                                           OUTPUT de-v-susp-icms-compl,
                                           OUTPUT de-v-recolhe-icms-compl,
                                           OUTPUT de-v-outros-icms-compl).


    ASSIGN v-base-II            = de-v-base-ii
           v-susp-ii            = de-v-susp-ii
           v-recolhe-ii         = de-v-recolhe-ii
           v-outros-ii          = de-v-outros-ii

           v-base-ipi           = de-v-base-ipi
           v-susp-ipi           = de-v-susp-ipi
           v-recolhe-ipi        = de-v-recolhe-ipi
           v-outros-ipi         = de-v-outros-ipi

           v-base-pis           = de-v-base-pis
           v-susp-pis           = de-v-susp-pis
           v-recolhe-pis        = de-v-recolhe-pis
           v-outros-pis         = de-v-outros-pis

           v-base-cofins        = de-v-base-cofins
           v-susp-cofins        = de-v-susp-cofins
           v-recolhe-cofins     = de-v-recolhe-cofins
           v-outros-cofins      = de-v-outros-cofins

           v-base-icms          = de-v-base-icms
           v-susp-icms          = de-v-susp-icms
           v-recolhe-icms       = de-v-recolhe-icms
           v-outros-icms        = de-v-outros-icms

           v-base-fcp           = de-v-base-fcp
           v-susp-fcp           = de-v-susp-fcp
           v-recolhe-fcp        = de-v-recolhe-fcp
           v-outros-fcp         = de-v-outros-fcp

           v-base-fcp-st        = de-v-base-fcp-st
           v-susp-fcp-st        = de-v-susp-fcp-st
           v-recolhe-fcp-st     = de-v-recolhe-fcp-st
           v-outros-fcp-st      = de-v-outros-fcp-st

           v-base-icms-st       = de-v-base-icms-st
           v-susp-icms-st       = de-v-susp-icms-st
           v-recolhe-icms-st    = de-v-recolhe-icms-st
           v-outros-icms-st     = de-v-outros-icms-st

           v-base-icms-compl    = de-v-base-icms-compl
           v-susp-icms-compl    = de-v-susp-icms-compl
           v-recolhe-icms-compl = de-v-recolhe-icms-compl
           v-outros-icms-compl  = de-v-outros-icms-compl


           v-total-suspenso = de-v-susp-ii    + de-v-susp-ipi    + de-v-susp-pis    + de-v-susp-cofins    + de-v-susp-icms    + de-v-susp-fcp-st    + de-v-susp-icms-st
           v-total-recolhe  = de-v-recolhe-ii + de-v-recolhe-ipi + de-v-recolhe-pis + de-v-recolhe-cofins + de-v-recolhe-icms + de-v-recolhe-fcp-st + de-v-recolhe-icms-st
           v-total-outros   = de-v-outros-ii  + de-v-outros-ipi  + de-v-outros-pis  + de-v-outros-cofins  + de-v-outros-icms  + de-v-outros-fcp-st  + de-v-outros-icms-st
        .


    DISP v-base-II
         v-susp-ii
         v-recolhe-ii
         v-outros-ii

         v-base-ipi
         v-susp-ipi
         v-recolhe-ipi
         v-outros-ipi

         v-base-pis
         v-susp-pis
         v-recolhe-pis
         v-outros-pis

         v-base-cofins
         v-susp-cofins
         v-recolhe-cofins
         v-outros-cofins

         v-base-icms
         v-susp-icms
         v-recolhe-icms
         v-outros-icms

         v-base-fcp
         v-susp-fcp
         v-recolhe-fcp
         v-outros-fcp

         v-base-fcp-st
         v-susp-fcp-st
         v-recolhe-fcp-st
         v-outros-fcp-st

         v-base-icms-st
         v-susp-icms-st
         v-recolhe-icms-st
         v-outros-icms-st

         v-base-icms-compl
         v-susp-icms-compl
         v-recolhe-icms-compl
         v-outros-icms-compl

         v-total-suspenso
         v-total-recolhe
         v-total-outros
        WITH FRAME fPage6.

    IF l-nt2024002 THEN DO:
        ASSIGN v-base-ibsuf       = 0
               v-susp-ibsuf       = 0
               v-recolhe-ibsuf    = 0
               v-outros-ibsuf     = 0
               v-base-ibsmun      = 0
               v-susp-ibsmun      = 0
               v-recolhe-ibsmun   = 0
               v-outros-ibsmun    = 0
               v-base-cbs         = 0
               v-susp-cbs         = 0
               v-recolhe-cbs      = 0
               v-outros-cbs       = 0
               v-base-is          = 0
               v-susp-is          = 0
               v-recolhe-is       = 0
               v-outros-is        = 0.

        IF AVAIL tt-decla-import THEN
        FOR EACH decla-import-trib NO-LOCK
           WHERE decla-import-trib.num-di-ems       = tt-decla-import.num-di-ems
             AND decla-import-trib.num-seq-retif    = tt-decla-import.num-seq-retif
             AND decla-import-trib.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts:

            CASE decla-import-trib.nom-trib:
                WHEN "IBSUF":U THEN DO:
                    CASE decla-import-trib.cod-campo:
                        WHEN "BASE":U THEN DO:
                            ASSIGN v-base-ibsuf = DEC(decla-import-trib.cod-conteudo).
                        END.
                        WHEN "SUSPENSO":U THEN DO:
                            ASSIGN v-susp-ibsuf = DEC(decla-import-trib.cod-conteudo).
                        END.
                        WHEN "VALOR":U THEN DO:
                            ASSIGN v-recolhe-ibsuf = DEC(decla-import-trib.cod-conteudo).
                        END.
                        WHEN "OUTROS":U THEN DO:
                            ASSIGN v-outros-ibsuf = DEC(decla-import-trib.cod-conteudo).
                        END.
                    END CASE.
                END.
                WHEN "IBSMUN":U THEN DO:
                    CASE decla-import-trib.cod-campo:
                        WHEN "BASE":U THEN DO:
                            ASSIGN v-base-ibsmun = DEC(decla-import-trib.cod-conteudo).
                        END.
                        WHEN "SUSPENSO":U THEN DO:
                            ASSIGN v-susp-ibsmun = DEC(decla-import-trib.cod-conteudo).
                        END.
                        WHEN "VALOR":U THEN DO:
                            ASSIGN v-recolhe-ibsmun = DEC(decla-import-trib.cod-conteudo).
                        END.
                        WHEN "OUTROS":U THEN DO:
                            ASSIGN v-outros-ibsmun = DEC(decla-import-trib.cod-conteudo).
                        END.
                    END CASE.
                END.
                WHEN "CBS":U THEN DO:
                    CASE decla-import-trib.cod-campo:
                        WHEN "BASE":U THEN DO:
                            ASSIGN v-base-cbs = DEC(decla-import-trib.cod-conteudo).
                        END.
                        WHEN "SUSPENSO":U THEN DO:
                            ASSIGN v-susp-cbs =  DEC(decla-import-trib.cod-conteudo).
                        END.
                        WHEN "VALOR":U THEN DO:
                            ASSIGN v-recolhe-cbs = DEC(decla-import-trib.cod-conteudo).
                        END.
                        WHEN "OUTROS":U THEN DO:
                            ASSIGN v-outros-cbs = DEC(decla-import-trib.cod-conteudo).
                        END.
                    END CASE.
                END.
                WHEN "IS":U THEN DO:
                    CASE decla-import-trib.cod-campo:
                        WHEN "BASE":U THEN DO:
                            ASSIGN v-base-is = DEC(decla-import-trib.cod-conteudo).
                        END.
                        WHEN "SUSPENSO":U THEN DO:
                            ASSIGN v-susp-is =  DEC(decla-import-trib.cod-conteudo).
                        END.
                        WHEN "VALOR":U THEN DO:
                            ASSIGN v-recolhe-is = DEC(decla-import-trib.cod-conteudo).
                        END.
                        WHEN "OUTROS":U THEN DO:
                            ASSIGN v-outros-is = DEC(decla-import-trib.cod-conteudo).
                        END.
                    END CASE.
                END.
            END CASE.
        END.


        ASSIGN v-total-susp-trib    = v-susp-ibsuf    + v-susp-ibsmun    + v-susp-cbs    + v-susp-is
               v-total-recolhe-trib = v-recolhe-ibsuf + v-recolhe-ibsmun + v-recolhe-cbs + v-recolhe-is
               v-total-outros-trib  = v-outros-ibsuf  + v-outros-ibsmun  + v-outros-cbs  + v-outros-is.

        DISP v-base-ibsuf    v-susp-ibsuf    v-recolhe-ibsuf    v-outros-ibsuf
             v-base-ibsmun   v-susp-ibsmun   v-recolhe-ibsmun   v-outros-ibsmun
             v-base-cbs      v-susp-cbs      v-recolhe-cbs      v-outros-cbs
             v-base-is       v-susp-is       v-recolhe-is       v-outros-is
             v-total-susp-trib v-total-recolhe-trib v-total-outros-trib WITH FRAME fpage7.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-logs wMaintenance
PROCEDURE pi-busca-logs :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes: esta procedure busca os valores do checkbox de rateio e calculo dos impostos
         para verificar se j  foram realizados
------------------------------------------------------------------------------*/
    IF AVAIL tt-decla-import THEN DO:
        ASSIGN cb-rateio-desp-nacio = tt-decla-import.log-pend-rat
               cb-calculo-impostos  = &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
                                          tt-decla-import.log-pend-impto
                                      &ELSE
                                          tt-decla-import.log-livre-2
                                      &ENDIF .

        &IF "{&bf_mat_versao_ems}" < "2.09" &THEN
                IF(SUBSTRING(tt-decla-import.cod-livre-1,1,1) = "S") THEN
                    ASSIGN cb-rateio-desp-comp = YES.
                ELSE
                    ASSIGN cb-rateio-desp-comp = NO.
        &ELSE
              ASSIGN cb-rateio-desp-comp = tt-decla-import.log-pend-despes-compltar.
        &ENDIF.
    END.

    DISP cb-rateio-desp-nacio
         cb-rateio-desp-comp
         cb-calculo-impostos
        WITH FRAME fPage1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-processos-vinculados wMaintenance
PROCEDURE pi-busca-processos-vinculados :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
FOR EACH tt-decla-imp-proc:
    DELETE tt-decla-imp-proc.
END.

FOR EACH tt-decla-imp-proc-aux:
    DELETE tt-decla-imp-proc-aux.
END.
IF AVAIL tt-decla-import THEN DO:
    ASSIGN INPUT FRAME fPage0 tt-decla-import.num-di-ems.

    /*BUSCA PROCESSOS RELACIONADOS*/
    RUN setConstraintByNumDiEms IN h-bocx396 (INPUT tt-decla-import.num-di-ems, INPUT tt-decla-import.cdd-siscomex-dts).
    RUN openQueryStatic         IN h-bocx396 (INPUT "ByNumDiEms":U).
    RUN getBatchRecords         IN h-bocx396 (INPUT  ?,
                                              INPUT  ?,
                                              INPUT  99999,
                                              OUTPUT i-reg-retornados,
                                              OUTPUT TABLE tt-decla-imp-proc).

    FOR EACH tt-decla-imp-proc:
        CREATE tt-decla-imp-proc-aux.
        BUFFER-COPY tt-decla-imp-proc TO tt-decla-imp-proc-aux.
        ASSIGN tt-decla-imp-proc-aux.desc-tipo = STRING(tt-decla-imp-proc.idi-tip-proces-vincul).
    END.

    {&OPEN-QUERY-brProcessoVinc}
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-valores wMaintenance
PROCEDURE pi-busca-valores :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEF VAR c-moeda-adic  AS CHAR FORMAT "X(30)" NO-UNDO.
    DEF VAR c-moeda-param AS CHAR FORMAT "X(30)" NO-UNDO.

    IF AVAIL tt-decla-import THEN
    RUN pi-busca-valores IN {&hDBOTable} (INPUT  INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                          INPUT  INPUT FRAME fPage0 tt-decla-import.cod-estab,
                                          INPUT  tt-decla-import.cdd-siscomex-dts,
                                          OUTPUT c-moeda-adic,
                                          OUTPUT c-cdn-moed-frete,
                                          OUTPUT c-cdn-moed-seguro,
                                          OUTPUT c-moeda-param,
                                          OUTPUT d-val-vmcv,
                                          OUTPUT d-val-vmcv-me,
                                          OUTPUT d-val-vmle,
                                          OUTPUT d-val-vmle-me,
                                          OUTPUT d-val-vmld,
                                          OUTPUT d-val-vmld-me,
                                          OUTPUT d-val-frete,
                                          OUTPUT d-val-frete-me,
                                          OUTPUT d-val-seguro,
                                          OUTPUT d-val-seguro-me,
                                          OUTPUT d-val-acresc,
                                          OUTPUT d-val-acresc-me,
                                          OUTPUT d-tot-val-desp-nacion-me,
                                          OUTPUT d-tot-val-desp-nacion,
                                          OUTPUT d-tot-val-desp-compl-me,
                                          OUTPUT d-tot-val-desp-compl,
                                          OUTPUT d-tot-val-desp-di-me,
                                          OUTPUT d-tot-val-desp-di).

    ASSIGN c-cdn-moed-vmcv                  = c-moeda-adic
           c-cdn-moed-vmle                  = c-moeda-adic
           c-cdn-moed-vmld                  = c-moeda-adic
           c-cdn-moed-acresc                = c-moeda-param
           c-cdn-moed-tot-desp-nac          = c-moeda-param
           c-cdn-moed-tot-desp-compl        = c-moeda-param
           c-cdn-moed-tot-desp-di           = c-moeda-param.

    DISP c-cdn-moed-vmcv            WHEN c-cdn-moed-vmcv           <> ?
         c-cdn-moed-vmle            WHEN c-cdn-moed-vmle           <> ?
         c-cdn-moed-vmld            WHEN c-cdn-moed-vmld           <> ?
         c-cdn-moed-frete           WHEN c-cdn-moed-frete          <> ?
         c-cdn-moed-seguro          WHEN c-cdn-moed-seguro         <> ?
         c-cdn-moed-acresc          WHEN c-cdn-moed-acresc         <> ?
         c-cdn-moed-tot-desp-nac    WHEN c-cdn-moed-tot-desp-nac   <> ?
         c-cdn-moed-tot-desp-compl  WHEN c-cdn-moed-tot-desp-compl <> ?
         c-cdn-moed-tot-desp-di     WHEN c-cdn-moed-tot-desp-di    <> ?
         d-val-vmcv                 WHEN d-val-vmcv                <> ?
         d-val-vmcv-me              WHEN d-val-vmcv-me             <> ?
         d-val-vmle                 WHEN d-val-vmle                <> ?
         d-val-vmle-me              WHEN d-val-vmle-me             <> ?
         d-val-vmld                 WHEN d-val-vmld                <> ?
         d-val-vmld-me              WHEN d-val-vmld-me             <> ?
         d-val-frete                WHEN d-val-frete               <> ?
         d-val-frete-me             WHEN d-val-frete-me            <> ?
         d-val-seguro               WHEN d-val-seguro              <> ?
         d-val-seguro-me            WHEN d-val-seguro-me           <> ?
         d-val-acresc               WHEN d-val-acresc              <> ?
         d-val-acresc-me            WHEN d-val-acresc-me           <> ?
         d-tot-val-desp-nacion-me   WHEN d-tot-val-desp-nacion-me  <> ?
         d-tot-val-desp-nacion      WHEN d-tot-val-desp-nacion     <> ?
         d-tot-val-desp-compl-me    WHEN d-tot-val-desp-compl-me   <> ?
         d-tot-val-desp-compl       WHEN d-tot-val-desp-compl      <> ?
         d-tot-val-desp-di-me       WHEN d-tot-val-desp-di-me      <> ?
         d-tot-val-desp-di          WHEN d-tot-val-desp-di         <> ?
        WITH FRAME fPage8.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-buscaByFiltro wMaintenance
PROCEDURE pi-buscaByFiltro :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

IF l-param-ativo THEN DO:
    RUN setConstraintByLogAtivo IN h-bocx383 (INPUT l-param-ativo).
    RUN openQueryStatic         IN h-bocx383 (INPUT "ByLogAtivo").
END.
ELSE DO:
    RUN openQueryStatic IN h-bocx383 (INPUT "Main").
END.

RUN getFirst IN THIS-PROCEDURE.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-buscaValoresRetificacao wMaintenance
PROCEDURE pi-buscaValoresRetificacao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    IF AVAIL tt-decla-import THEN DO:
        ASSIGN tt-decla-import.num-seq-retif:SCREEN-VALUE IN FRAME fPage0 = STRING(tt-decla-import.num-seq-retif)
               tt-decla-import.dat-retif    :SCREEN-VALUE IN FRAME fPage0 = STRING(tt-decla-import.dat-retif,"99/99/9999").

        IF tt-decla-import.idi-motiv-retif > 0 THEN
            ASSIGN cb-motivo-retif:screen-value  in frame fPage0 = {cxinc/i01cx383.i 04 tt-decla-import.idi-motiv-retif}.

    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-canc-despesa wMaintenance
PROCEDURE pi-canc-despesa :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    RUN pi-busca-despesas-di.

    RUN pi-trata-browser-despesa (INPUT YES).

    IF  NOT CAN-FIND(FIRST tt-despes-decla-import) THEN DO:
        ENABLE btAdddespesa WITH FRAME fPage5.
        DISABLE btCandespesa btUpdatedespesa btSavedespesa WITH FRAME fPage5.
    END.
    ELSE DO:
        ENABLE  btAdddespesa btUpdatedespesa WITH FRAME fPage5.
        DISABLE btCandespesa btSavedespesa    WITH FRAME fPage5.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-canc-embalagem wMaintenance
PROCEDURE pi-canc-embalagem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
RUN pi-busca-embalagens.

ASSIGN tt-decla-import-embal.cod-sig-embal          :READ-ONLY IN BROWSE brEmbalagem = YES
       tt-decla-import-embal.qtd-vol-embal          :READ-ONLY IN BROWSE brEmbalagem = YES.

IF NOT CAN-FIND(FIRST tt-decla-import-embal) THEN DO:
    ENABLE btAddEmbalagem WITH FRAME fPage3.
    DISABLE btCanEmbalagem btDelEmbalagem btSaveEmbalagem WITH FRAME fPage3.
END.
ELSE DO:
    ENABLE  btAddEmbalagem btDelEmbalagem WITH FRAME fPage3.
    DISABLE btCanEmbalagem btSaveEmbalagem    WITH FRAME fPage3.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-canc-historico wMaintenance
PROCEDURE pi-canc-historico :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    RUN pi-busca-historicos-di.

    RUN pi-trata-browser-historico (INPUT YES).


    IF NOT CAN-FIND(FIRST tt-histor-decla-import) THEN DO:
        IF i-modificacao = 0 THEN
            ENABLE btAddHistorico WITH FRAME fPage4.
        DISABLE btCanHistorico btUpdateHistorico btSaveHistorico WITH FRAME fPage4.
    END.
    ELSE DO:
        IF i-modificacao = 0 THEN DO:
            IF log-perm-pto-control-imp AND NOT l-alterando THEN
                ENABLE  btUpdateHistorico WITH FRAME fPage4.
            ELSE
                ENABLE  btAddHistorico btUpdateHistorico WITH FRAME fPage4.
        END.
        DISABLE btCanHistorico btSaveHistorico    WITH FRAME fPage4.
    END.


    ASSIGN i-modificacao = 0
           i-pto-ant = 0.
    APPLY "VALUE-CHANGED":U TO brHistorico IN FRAME fPage4.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-canc-processo-vinc wMaintenance
PROCEDURE pi-canc-processo-vinc :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
RUN pi-busca-processos-vinculados.

IF NOT CAN-FIND(FIRST tt-decla-imp-proc) THEN DO:
    ENABLE btAddProcessoVinc WITH FRAME fPage2.
    DISABLE btCanProcVinc btDelProcessoVinc btSaveProcessoVinc WITH FRAME fPage2.
END.
ELSE DO:
    ENABLE  btAddProcessoVinc btDelProcessoVinc WITH FRAME fPage2.
    DISABLE btCanProcVinc btSaveProcessoVinc    WITH FRAME fPage2.
END.

ASSIGN tt-decla-imp-proc-aux.desc-tipo         :READ-ONLY IN BROWSE brProcessoVinc = YES
       tt-decla-imp-proc-aux.cod-proces-vincul :READ-ONLY IN BROWSE brProcessoVinc = YES.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Chama410a wMaintenance
PROCEDURE pi-Chama410a :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

IF AVAIL tt-decla-import THEN
     ASSIGN gr-{&DBOTABLE} = tt-decla-import.r-Rowid.
ELSE ASSIGN gr-{&DBOTABLE} = ?.

ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
RUN imp/im0410.w.
ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

RUN pi-atualiza-registro-tela.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-controla-retif wMaintenance
PROCEDURE pi-controla-retif :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pHabDesCampos AS LOGICAL NO-UNDO.
    DEF INPUT PARAM pHiddenCampos AS LOGICAL NO-UNDO.

    ASSIGN cb-motivo-retif                :SENSITIVE IN FRAME fPage0 = pHabDesCampos
           tt-decla-import.dat-retif      :SENSITIVE IN FRAME fPage0 = pHabDesCampos
           tt-decla-import.num-seq-retif  :SENSITIVE IN FRAME fPage0 = pHabDesCampos
           cb-motivo-retif                :HIDDEN IN FRAME fPage0    = pHiddenCampos
           tt-decla-import.dat-retif      :HIDDEN IN FRAME fPage0    = pHiddenCampos
           tt-decla-import.num-seq-retif  :HIDDEN IN FRAME fPage0    = pHiddenCampos.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cotacao wMaintenance
PROCEDURE pi-cotacao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-nro-retif AS INTEGER     NO-UNDO.

IF AVAIL tt-decla-import THEN DO:
    RUN buscaUltimaRetificacao IN {&hDBOTable} (INPUT  tt-decla-import.num-di-ems,
                                                INPUT  tt-decla-import.cdd-siscomex-dts,
                                                OUTPUT i-nro-retif).

    IF i-nro-retif > tt-decla-import.num-seq-retif THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show',
                        INPUT 52163,
                        INPUT '').
    END.
    ELSE DO:
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        RUN imp/im0400c.w PERSISTENT SET h-im0400c (INPUT tt-decla-import.r-Rowid,
                                                    INPUT THIS-PROCEDURE,
                                                    INPUT h-bocx383).
        IF  VALID-HANDLE (h-im0400c) THEN DO:
            RUN initializeInterface IN h-im0400c.
            WAIT-FOR CLOSE OF h-im0400c FOCUS CURRENT-WINDOW.
        END.
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-delete-despesa-di wMaintenance
PROCEDURE pi-delete-despesa-di :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    IF  AVAIL tt-decla-import THEN DO:
        DO  i-cont = 1 TO brDespesa:NUM-SELECTED-ROWS IN FRAME fPage5:
            IF  brDespesa:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage5 THEN DO:

                /*--- Exibe mensagem de confirma»’o de elimina»’o ---*/

                /* busca o codigo da despesa da taxa siscomex do parametro */
                RUN pi-busca-despes-siscomex IN h-bocx406(INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                                          INPUT tt-decla-import.cdd-siscomex-dts, //cdd-siscomex-dts
                                                          OUTPUT i-cdn-despes-siscomex,
                                                          OUTPUT i-cdn-emit-siscomex,
                                                          OUTPUT l-taxa-siscomex).

                IF tt-despes-decla-import.cdn-despes = i-cdn-despes-siscomex AND
                   l-taxa-siscomex THEN
                    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 33679, INPUT "":U).
                ELSE
                    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 550, INPUT "":U).

                IF  RETURN-VALUE = "YES":U THEN DO:
                    /* NÆo permite remover Despesa Nacionaliza‡Æo quando a DI possui nota fiscal gerada */
                    IF tt-despes-decla-import.idi-tip-incid-nf = 1 THEN DO:
                        EMPTY TEMP-TABLE tt-docum-est.
                        RUN pi-busca-doc-relacs IN h-bocx383(INPUT tt-decla-import.r-Rowid,
                                                             OUTPUT TABLE tt-docum-est).
                        IF CAN-FIND(FIRST tt-docum-est) THEN DO:
                            /*Despesa nao pode ser removida, DI possui nota fiscal gerada*/
                            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 56368, INPUT "":U).
                            undo, return no-apply.
                        END.
                    END.

                    RUN emptyRowErrors   IN h-bocx406.
                    RUN openQueryStatic  IN h-bocx406 (INPUT 'Main':U).
                    RUN repositionRecord IN h-bocx406 (INPUT tt-despes-decla-import.r-Rowid).
                    /*--- Elima registro corrente do DBO filho ---*/
                    RUN deleteRecord IN h-bocx406.


                    RUN getRowErrors IN h-bocx406 (OUTPUT TABLE RowErrors).

                    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                       /*--- Inicializa janela de mensagens de erro ---*/
                       {method/showmessage.i1}
                       {method/showmessage.i2}
                    END.
                    ELSE DO:
                        /* eliminacao das despesas nos embarques relacionados a DI */
                        FOR EACH decla-import-embarq
                            WHERE decla-import-embarq.num-di-ems = tt-decla-import.num-di-ems
                              AND decla-import-embarq.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts NO-LOCK:

                            RUN setConstraint5 IN h-bocx310(INPUT decla-import-embarq.cod-estab,
                                                            INPUT decla-import-embarq.cod-embarq,
                                                            INPUT INPUT BROWSE brDespesa tt-despes-decla-import.cdn-despes,
                                                            INPUT INPUT BROWSE brDespesa tt-despes-decla-import.cdn-emit-despes,
                                                            INPUT INPUT BROWSE brDespesa tt-despes-decla-import.cdn-pto-control).

                            RUN openQuery IN h-bocx310(INPUT 5).

                            RUN findFirst IN h-bocx310.

                            RUN getRowid IN h-bocx310(OUTPUT r-chave).

                            RUN validateDelete IN h-bocx310(INPUT-OUTPUT r-chave,
                                                            OUTPUT TABLE tt-bo-erro).

                            EMPTY TEMP-TABLE RowErrors.

                            FOR EACH tt-bo-erro
                                WHERE tt-bo-erro.errortype <> "INTERNAL":U EXCLUSIVE-LOCK:
                                {utp/ut-liter.i "Embarque"}
                                assign c-lit-trad-emb = return-value.
                                {utp/ut-liter.i "As_informa‡äes_podem_estar_sendo_validadas_referente_aos_embarques_relacionados_a_DI_Lembre-se_de_verifica-los."}

                                CREATE RowErrors.
                                ASSIGN RowErrors.ErrorSequence    = tt-bo-erro.i-sequen
                                       RowErrors.ErrorNumber      = tt-bo-erro.cd-erro
                                       RowErrors.ErrorDescription = tt-bo-erro.mensagem
                                       RowErrors.ErrorParameters  = tt-bo-erro.parametros
                                       RowErrors.ErrorType        = tt-bo-erro.errortype
                                       RowErrors.ErrorHelp        = tt-bo-erro.errorhelp + CHR(10) + RETURN-VALUE + CHR(10) + c-lit-trad-emb + ": " + decla-import-embarq.cod-embarq
                                       RowErrors.ErrorSubType     = tt-bo-erro.errorsubtype.

                                DELETE tt-bo-erro.

                                {method/showmessage.i1}
                                {method/showmessage.i2}
                                undo, return no-apply.
                            END.
                        END.

                    END.

                    RUN pi-busca-despesas-di.

                END.
            END.
        END.
    END.
    RUN pi-apres-despesa.
    RUN pi-atualiza-registro-tela.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-delete-historico-di wMaintenance
PROCEDURE pi-delete-historico-di :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

IF AVAIL tt-decla-import THEN DO:
    DO  i-cont = 1 TO brHistorico:NUM-SELECTED-ROWS IN FRAME fPage4:
        IF  brHistorico:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage4 THEN DO:

            /*--- Exibe mensagem de confirma»’o de elimina»’o ---*/
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 550, INPUT "":U).
            IF RETURN-VALUE = "YES":U THEN DO:
               /* Eliminacao dos pontos de controles dos embarque relacionados a DI */
               FOR EACH decla-import-embarq
                  WHERE decla-import-embarq.num-di-ems = tt-decla-import.num-di-ems
                    AND decla-import-embarq.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts NO-LOCK:

                   RUN findFirstEmbarque IN h-bocx230 (INPUT decla-import-embarq.cod-estab,
                                                       INPUT decla-import-embarq.cod-embarq,
                                                       OUTPUT c-return).
                   IF  c-return = "" THEN RUN getIntField IN h-bocx230 (INPUT 'cod-itiner', OUTPUT i-cod-itiner).

                   /*RUN emptyRowErrors IN h-bocx230a.- no validateDelete a tt-bo-erro é limpa*/
                   RUN setConstraint2 IN h-bocx230a(INPUT "2",
                                                    INPUT ?,
                                                    INPUT decla-import-embarq.cod-estab,
                                                    INPUT i-cod-itiner,
                                                    INPUT decla-import-embarq.cod-embarq).
                   RUN openQuery IN h-bocx230a(INPUT 4).
                   RUN goToPtoCont IN h-bocx230a(INPUT decla-import-embarq.cod-estab,
                                                 INPUT decla-import-embarq.cod-embarq,
                                                 INPUT i-cod-itiner,
                                                 INPUT tt-histor-decla-import.cdn-pto-control).

                   /* O ponto que esta sendo eliminado na DI pode nao existir no embarque */
                   IF RETURN-VALUE = "OK":U THEN DO:

                       RUN getRowid IN h-bocx230a(OUTPUT r-chave).

                       RUN validateDelete IN h-bocx230a (INPUT-OUTPUT r-chave,
                                                         OUTPUT TABLE tt-bo-erro).

                       EMPTY TEMP-TABLE RowErrors.

                       IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
                           FOR EACH tt-bo-erro
                              WHERE tt-bo-erro.errortype <> "INTERNAL":U EXCLUSIVE-LOCK:
                               {utp/ut-liter.i "Embarque"}
                               assign c-lit-trad-emb = return-value.
                               {utp/ut-liter.i "As_informa‡äes_podem_estar_sendo_validadas_referente_aos_embarques_relacionados_a_DI_Lembre-se_de_verifica-los."}

                               CREATE RowErrors.
                               ASSIGN RowErrors.ErrorSequence    = tt-bo-erro.i-sequen
                                      RowErrors.ErrorNumber      = tt-bo-erro.cd-erro
                                      RowErrors.ErrorDescription = tt-bo-erro.mensagem
                                      RowErrors.ErrorParameters  = tt-bo-erro.parametros
                                      RowErrors.ErrorType        = tt-bo-erro.errortype
                                      RowErrors.ErrorHelp        = tt-bo-erro.errorhelp + CHR(10) + RETURN-VALUE + CHR(10) + c-lit-trad-emb + ": " + decla-import-embarq.cod-embarq
                                      RowErrors.ErrorSubType     = tt-bo-erro.errorsubtype.

                               DELETE tt-bo-erro.
                           END.
                           {method/showmessage.i1}
                           {method/showmessage.i2}
                           undo, return no-apply.
                       END.

                       RUN atualSitEmb IN h-bocx230a(INPUT decla-import-embarq.cod-estab,
                                                     INPUT decla-import-embarq.cod-embarq).
                   END.
               END.

               RUN emptyRowErrors   IN h-bocx384.
               RUN openQueryStatic  IN h-bocx384 (INPUT 'Main':U).
               RUN repositionRecord IN h-bocx384 (INPUT tt-histor-decla-import.r-Rowid).
               /*--- Elima registro corrente do DBO filho ---*/
               RUN deleteRecord IN h-bocx384.

               RUN getRowErrors IN h-bocx384 (OUTPUT TABLE RowErrors).

               IF CAN-FIND(FIRST RowErrors
                           WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                   /*--- Inicializa janela de mensagens de erro ---*/
                  {method/showmessage.i1}
                  {method/showmessage.i2}
                   undo, return no-apply.
               END.

               RUN pi-busca-historicos-di.

            END.
        END.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exclui-embalagem wMaintenance
PROCEDURE pi-exclui-embalagem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

RUN goToKey IN h-bocx386 (INPUT tt-decla-import-embal.num-di-ems,
                          INPUT tt-decla-import-embal.cod-sig-embal,
                          INPUT tt-decla-import-embal.cdd-siscomex-dts).

/* busca o valor da embalagem e subtrai do peso da embalagem e peso bruto total */
RUN pi-busca-peso-embal-deletada IN h-bocx386(INPUT  tt-decla-import-embal.num-di-ems,
                                              INPUT  tt-decla-import-embal.cod-sig-embal,
                                              INPUT  tt-decla-import-embal.cdd-siscomex-dts,
                                              OUTPUT d-val-peso-embal).

IF d-val-peso-embal > 0 THEN DO:
    ASSIGN tt-decla-import.val-peso-embal-di = INPUT FRAME fPage3 tt-decla-import.val-peso-embal-di - (d-val-peso-embal * tt-decla-import-embal.qtd-vol-embal).
    DISP tt-decla-import.val-peso-embal-di
      WITH FRAME fPage3.
    APPLY 'LEAVE':u TO tt-decla-import.val-peso-embal-di IN FRAME fPage3.
END.


IF RETURN-VALUE = "OK":U THEN
    RUN deleteRecord IN h-bocx386.

RUN pi-busca-embalagens.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exclui-processo-vinc wMaintenance
PROCEDURE pi-exclui-processo-vinc :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

RUN goToKey IN h-bocx396 (INPUT tt-decla-imp-proc-aux.num-di-ems,
                          INPUT tt-decla-imp-proc-aux.cod-proces-vincul,
                          INPUT tt-decla-imp-proc-aux.cdd-siscomex-dts).
IF RETURN-VALUE = "OK":U THEN
    RUN deleteRecord IN h-bocx396.

RUN pi-busca-processos-vinculados.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filtro wMaintenance
PROCEDURE pi-filtro :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN imp/im0400d.w PERSISTENT SET h-im0400d (INPUT THIS-PROCEDURE).
    IF  VALID-HANDLE (h-im0400d) THEN DO:
        RUN initializeInterface IN h-im0400d.
        WAIT-FOR CLOSE OF h-im0400d FOCUS CURRENT-WINDOW.

        RUN pi-buscaByFiltro.
    END.
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-impostos-DI wMaintenance
PROCEDURE pi-impostos-DI :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    do  with frame fPage6:
        assign v-total-suspenso = dec(v-susp-cofins:screen-value)    + dec(v-susp-icms:screen-value)    + dec(v-susp-ii:screen-value)    + dec(v-susp-ipi:screen-value)    + dec(v-susp-pis:screen-value)
               v-total-recolhe  = dec(v-recolhe-cofins:screen-value) + dec(v-recolhe-icms:screen-value) + dec(v-recolhe-ii:screen-value) + dec(v-recolhe-ipi:screen-value) + dec(v-recolhe-pis:screen-value)
               v-total-outros   = dec(v-outros-cofins:screen-value)  + dec(v-outros-icms:screen-value)  + dec(v-outros-ii:screen-value)  + dec(v-outros-ipi:screen-value)  + dec(v-outros-pis:screen-value).

        disp v-total-suspenso v-total-recolhe v-total-outros.
    end.

    IF l-nt2024002 THEN
    DO WITH FRAME fpage7:
        ASSIGN v-total-susp-trib    =  DEC(v-susp-ibsuf:SCREEN-VALUE) + DEC(v-susp-ibsmun:SCREEN-VALUE) + DEC(v-susp-cbs:SCREEN-VALUE) + DEC(v-susp-is:SCREEN-VALUE)
               v-total-recolhe-trib =  DEC(v-recolhe-ibsuf:SCREEN-VALUE) + DEC(v-recolhe-ibsmun:SCREEN-VALUE) + DEC(v-recolhe-cbs:SCREEN-VALUE) + DEC(v-recolhe-is:SCREEN-VALUE)
               v-total-outros-trib  =  DEC(v-outros-ibsuf:SCREEN-VALUE) + DEC(v-outros-ibsmun:SCREEN-VALUE) + DEC(v-outros-cbs:SCREEN-VALUE) + DEC(v-outros-is:SCREEN-VALUE).

        DISP v-total-susp-trib v-total-recolhe-trib v-total-outros-trib.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-observacao wMaintenance
PROCEDURE pi-observacao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
RUN imp/im0400f.w PERSISTENT SET h-im0400f (INPUT tt-decla-import.num-di-ems,
                                            INPUT tt-decla-import.num-seq-retif,
                                            INPUT tt-decla-import.cdd-siscomex-dts,
                                            INPUT tt-decla-import.cod-inf-compltar,
                                            INPUT THIS-PROCEDURE).
IF  VALID-HANDLE (h-im0400f) THEN DO:
    RUN initializeInterface IN h-im0400f.
    WAIT-FOR CLOSE OF h-im0400f FOCUS CURRENT-WINDOW.
END.
ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pto-nacionaliz wMaintenance
PROCEDURE pi-pto-nacionaliz :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    ASSIGN i-seq-pto-nacionaliz = 0.
    IF CAN-FIND(FIRST tt-histor-decla-import) THEN DO:
        FOR FIRST tt-histor-decla-import:
            ASSIGN i-cdn-pto-nacionaliz = tt-histor-decla-import.cdn-pto-nacionaliz.
        END.
        FOR FIRST tt-histor-decla-import
            WHERE tt-histor-decla-import.cdn-pto-control = i-cdn-pto-nacionaliz:
            ASSIGN i-seq-pto-nacionaliz = tt-histor-decla-import.num-seq.
        END.
    END.
    ELSE
        ASSIGN i-cdn-pto-nacionaliz = 0.

    DISP i-cdn-pto-nacionaliz WITH FRAME fPage4.
    APPLY 'LEAVE' TO i-cdn-pto-nacionaliz IN FRAME fPage4.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-rateio-embarques wMaintenance
PROCEDURE pi-rateio-embarques :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

DEFINE VARIABLE l-rateio-realizado   AS LOGICAL INIT NO NO-UNDO.
ASSIGN l-rateio           = NO
       l-gera-relat       = NO
       l-calcula-impostos = NO
       l-rateio-desp-comp = NO.

ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
RUN imp/im0400aa.w PERSISTENT SET h-im0400aa (INPUT THIS-PROCEDURE,
                                              INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                              INPUT INPUT FRAME fPage0 tt-decla-import.num-seq-retif,
                                              INPUT tt-decla-import.cdd-siscomex-dts). //cdd-siscomex-dts
IF  VALID-HANDLE (h-im0400aa) THEN DO:
    RUN initializeInterface IN h-im0400aa.
    WAIT-FOR CLOSE OF h-im0400aa FOCUS CURRENT-WINDOW.
END.
ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

DO TRANS:
    IF l-rateio THEN DO:
        RUN emptyRowErrors IN h-bocx383a.
        RUN pi-rateio-di   IN h-bocx383a(INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                         INPUT tt-decla-import.cdd-siscomex-dts, //cdd-siscomex-dts
                                         INPUT 1). /*Rateia Despesas Nacionaliza‡Æo*/
        RUN getRowErrors   IN h-bocx383a(OUTPUT TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType     <> "INTERNAL":U
                                    AND   RowErrors.ErrorSubType  = "ERROR":U) THEN DO:
           UNDO,LEAVE.
        END.
    END.
    IF  l-calcula-impostos THEN DO:

        RUN emptyRowErrors          IN h-bocx383a.
        RUN piSetaRecalculoImpostos IN h-bocx383a (INPUT l-regera-default-impostos).
        RUN pi-calcula-impostos     IN h-bocx383a (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems, INPUT tt-decla-import.cdd-siscomex-dts).
        RUN getRowErrors            IN h-bocx383a (OUTPUT TABLE RowErrors).
        IF  CAN-FIND(FIRST RowErrors
                     WHERE RowErrors.ErrorType    <> "INTERNAL":U
                     AND   RowErrors.ErrorSubType  = "ERROR":U    ) OR
                     RETURN-VALUE = "NOK":U THEN DO:
            UNDO,LEAVE.
        END. /* IF  CAN-FIND(FIRST RowErrors */
    END.
    /* fim - calculo dos impostos */

    ASSIGN l-rateio-realizado = YES.
END.
IF l-rateio-realizado THEN DO:
    IF l-rateio-desp-comp THEN DO:
        DO TRANS:
            RUN emptyRowErrors IN h-bocx383a.
            RUN pi-rateio-di   IN h-bocx383a(INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                             INPUT tt-decla-import.cdd-siscomex-dts, //cdd-siscomex-dts
                                             INPUT 2). /*Rateia Despesas Complementares*/
            RUN getRowErrors   IN h-bocx383a(OUTPUT TABLE RowErrors).
            IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
               IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType     <> "INTERNAL":U
                                           AND   RowErrors.ErrorSubType  = "ERROR":U) THEN DO:
                  UNDO,LEAVE.
               END.
            END.
            ELSE DO:
                RUN getTTdesp-rateio-item IN h-bocx383a (OUTPUT TABLE tt-desp-rateio-item).
                UNDO,LEAVE.
            END.
        END.
        RUN pi-atual-val-rat-compl-embarque  IN h-bocx383a (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                                            INPUT tt-decla-import.cdd-siscomex-dts, //cdd-siscomex-dts
                                                            INPUT TABLE tt-desp-rateio-item).
    END.
    IF l-gera-relat THEN DO:
        RUN imp/im0400rp.p (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems, INPUT tt-decla-import.cdd-siscomex-dts). //cdd-sicomex-dts
    END.
END.

/* verifica se h  ? ou 0 nos valores do rateio*/
IF l-rateio THEN
    RUN validaCalculoRateio IN h-bocx383a (INPUT tt-decla-import.num-di-ems,
                                           INPUT tt-decla-import.cdd-siscomex-dts).

RUN getRowErrors   IN h-bocx383a(OUTPUT TABLE RowErrors).
IF  CAN-FIND(FIRST RowErrors
                 WHERE RowErrors.ErrorType    <> "INTERNAL":U
                 AND   (RowErrors.ErrorSubType  = "ERROR":U OR RowErrors.ErrorSubType  = "WARNING":U)  ) OR
                 RETURN-VALUE = "NOK":U THEN DO:

        {method/showmessage.i1}
        {method/showmessage.i2}
END.
/* fim - verifica se h  ? ou 0 nos valores do rateio ou no calculo dos impostos */
RUN pi-atualiza-registro-tela.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retificacao wMaintenance
PROCEDURE pi-retificacao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
RUN pi-controla-retif(INPUT YES,
                      INPUT NO).

RUN copyRecord IN THIS-PROCEDURE.

RUN pi-botoes (INPUT NO).

RUN getNewSeqRetif IN {&hDBOTable} (INPUT  tt-decla-import.num-di-ems,
                                    INPUT  tt-decla-import.cdd-siscomex-dts,
                                    OUTPUT tt-decla-import.num-seq-retif).

ASSIGN tt-decla-import.dat-retif     = ?
       tt-decla-import.num-seq-retif :SCREEN-VALUE IN FRAME fPage0 = STRING(tt-decla-import.num-seq-retif)
       tt-decla-import.num-seq-retif :SENSITIVE IN FRAME fPage0 = NO
       tt-decla-import.num-di-ems    :SENSITIVE IN FRAME fPage0 = NO
       tt-decla-import.idi-motiv-retif = 1
       cb-motivo-retif:SCREEN-VALUE  IN FRAME fPage0 = {cxinc/i01cx383.i 04 tt-decla-import.idi-motiv-retif}
       tt-decla-import.log-ativo = YES.

RUN pi-controla-retif(INPUT YES,
                      INPUT NO).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-row-display-processo-vinc wMaintenance
PROCEDURE pi-row-display-processo-vinc :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
IF AVAIL tt-decla-imp-proc-aux THEN DO:
    CASE tt-decla-imp-proc-aux.desc-tipo:
        WHEN "1" THEN
            ASSIGN tt-decla-imp-proc-aux.desc-tipo = "Administrativo".
        WHEN "2" THEN
            ASSIGN tt-decla-imp-proc-aux.desc-tipo = "Judicial".
        WHEN "3" THEN
            ASSIGN tt-decla-imp-proc-aux.desc-tipo = "Declara‡Æo Preliminar".
        WHEN "4" THEN
            ASSIGN tt-decla-imp-proc-aux.desc-tipo = "Judicial Exclusivo DARF".
    END CASE.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-despesa wMaintenance
PROCEDURE pi-salva-despesa :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-despes-decla-import-aux.

    CREATE tt-despes-decla-import-aux.
    ASSIGN tt-despes-decla-import-aux.num-di-ems                = tt-decla-import.num-di-ems
           tt-despes-decla-import-aux.cdd-siscomex-dts          = tt-decla-import.cdd-siscomex-dts
           /*tt-despes-decla-import-aux.cdn-pto-control           = INPUT BROWSE brDespesa tt-despes-decla-import.cdn-pto-control*/
           tt-despes-decla-import-aux.cdn-despes                = INPUT BROWSE brDespesa tt-despes-decla-import.cdn-despes
           tt-despes-decla-import-aux.cdn-emit-despes           = INPUT BROWSE brDespesa tt-despes-decla-import.cdn-emit-despes
           tt-despes-decla-import-aux.cdn-cond-pagto            = INPUT BROWSE brDespesa tt-despes-decla-import.cdn-cond-pagto
           tt-despes-decla-import-aux.cdn-moed                  = INPUT BROWSE brDespesa tt-despes-decla-import.cdn-moed
           tt-despes-decla-import-aux.val-cotac-despes-compltar = INPUT BROWSE brDespesa tt-despes-decla-import.val-cotac-despes-compltar
           tt-despes-decla-import-aux.val-desp                  = INPUT BROWSE brDespesa tt-despes-decla-import.val-desp.

    IF SUBSTRING(INPUT BROWSE brDespesa tt-despes-decla-import.desc-tipo,1,1) = 'N' THEN
        ASSIGN tt-despes-decla-import-aux.idi-tip-incid-nf = 1.
    ELSE
        ASSIGN tt-despes-decla-import-aux.idi-tip-incid-nf = 2
                    tt-despes-decla-import-aux.log-incid-vmle   = YES.

    RUN emptyRowErrors  IN h-bocx406.
    RUN emptyRowObject  IN h-bocx406.
    RUN openQueryStatic IN h-bocx406 (INPUT "Main":U).
    RUN goToKey         IN h-bocx406 (INPUT tt-despes-decla-import-aux.num-di-ems,
                                      INPUT tt-despes-decla-import-aux.cdn-pto-control,
                                      INPUT tt-despes-decla-import-aux.cdn-despes,
                                      INPUT tt-despes-decla-import-aux.cdn-emit-despes,
                                      INPUT tt-despes-decla-import-aux.cdd-siscomex-dts).
    IF  RETURN-VALUE = "NOK" THEN DO:
        RUN setRecord    IN h-bocx406 (INPUT TABLE tt-despes-decla-import-aux).
        RUN createRecord IN h-bocx406.
    END. /* IF  RETURN-VALUE = "NOK" */
    ELSE DO:
        RUN setRecord    IN h-bocx406 (INPUT TABLE tt-despes-decla-import-aux).
        RUN updateRecord IN h-bocx406.
    END. /* ELSE DO: */

    IF  RETURN-VALUE = "OK":U THEN DO:
        DISABLE btCanDespesa btSaveDespesa WITH FRAME fPage5.
        ENABLE btAddDespesa btUpdateDespesa WITH FRAME fPage5.
        RUN pi-busca-despesas-di.
        RUN pi-trata-browser-Despesa (INPUT YES).
        APPLY 'entry' TO btAddDespesa IN FRAME fPage5.
    END.
    ELSE DO:
        RUN getRowErrors IN h-bocx406(OUTPUT TABLE RowErrors).
        IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
        END. /* IF  CAN-FIND(FIRST RowErrors */
    END. /* ELSE DO: */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-embalagem wMaintenance
PROCEDURE pi-salva-embalagem :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-decla-import-embal-aux.

    CREATE tt-decla-import-embal-aux.
    ASSIGN tt-decla-import-embal-aux.num-di-ems    = tt-decla-import.num-di-ems
           tt-decla-import-embal-aux.cod-sig-embal = INPUT BROWSE brEmbalagem tt-decla-import-embal.cod-sig-embal
           tt-decla-import-embal-aux.qtd-vol-embal = INPUT BROWSE brEmbalagem tt-decla-import-embal.qtd-vol-embal
           tt-decla-import-embal-aux.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts.

    RUN emptyRowErrors IN h-bocx386.
    RUN emptyRowObject IN h-bocx386.
    RUN setRecord      IN h-bocx386 (INPUT TABLE tt-decla-import-embal-aux).
    RUN createRecord   IN h-bocx386.
    IF RETURN-VALUE = "OK":U THEN DO:
        DISABLE btCanEmbalagem
                btSaveEmbalagem WITH FRAME fPage3.
        ENABLE btAddEmbalagem
               btDelEmbalagem WITH FRAME fPage3.

        ASSIGN tt-decla-import-embal.cod-sig-embal          :READ-ONLY IN BROWSE brEmbalagem = YES
               tt-decla-import-embal.qtd-vol-embal          :READ-ONLY IN BROWSE brEmbalagem = YES.

        RUN pi-busca-embalagens.
        APPLY 'entry' TO btAddEmbalagem IN FRAME fPage3.
    END.
    ELSE DO:
        RUN getRowErrors IN h-bocx386(OUTPUT TABLE RowErrors).
        IF  CAN-FIND(FIRST RowErrors
                     WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
        END.
    END.

    FIND FIRST tt-decla-import-embal-aux NO-LOCK NO-ERROR.
    /* busca o peso da embalagem para somar no "Peso Embalagem" e "Peso Bruto Total" */
    RUN pi-busca-peso-embal IN h-bocx386(INPUT tt-decla-import.num-di-ems,
                                         INPUT tt-decla-import.cdd-siscomex-dts,
                                         OUTPUT d-val-peso-embal).

    IF d-val-peso-embal > 0 THEN DO:
        ASSIGN tt-decla-import.val-peso-embal-di = INPUT FRAME fPage3 tt-decla-import.val-peso-embal-di + (d-val-peso-embal * tt-decla-import-embal-aux.qtd-vol-embal).
        DISP tt-decla-import.val-peso-embal-di
          WITH FRAME fPage3.
        APPLY 'LEAVE':u TO tt-decla-import.val-peso-embal-di IN FRAME fPage3.
    END.
    /* fim  - busca o peso da embalagem para somar no "Peso Embalagem" e "Peso Bruto Total" */

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-historico wMaintenance
PROCEDURE pi-salva-historico :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    /*--- Altera‡Æo da DI ------------------------------------------------------------------*/
    IF  VALID-HANDLE(h-bocx383a) THEN DO:
        RUN piDoctoRecebimento IN h-bocx383a(INPUT tt-decla-import.cod-di-siscomex, OUTPUT l-encontrou).

        IF  l-encontrou THEN DO:
            DEF VAR i-cdn-pto-control LIKE histor-decla-import.cdn-pto-control NO-UNDO.

            ASSIGN i-cdn-pto-control = INPUT BROWSE brHistorico tt-histor-decla-import.cdn-pto-control.
            IF  i-cdn-pto-control <= i-pto-nacionalizacao THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-insercao-nao-permitida AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Inser‡Æo_nÆo_permitida" *}
                ASSIGN c-lbl-liter-insercao-nao-permitida = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-nao-e-possivel-inserir-despesa AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "NÆo_‚_poss¡vel_inserir_despesas_antes_do_ponto_de_nacionaliza‡Æo" *}
                ASSIGN c-lbl-liter-nao-e-possivel-inserir-despesa = TRIM(RETURN-VALUE).
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT c-lbl-liter-insercao-nao-permitida + "~~" + c-lbl-liter-nao-e-possivel-inserir-despesa + "!").
                RETURN "NOK":U.
            END. /* IF  i-cdn-pto-control <= i-pto-nacionalizacao */
        END. /* IF  l-encontrou THEN DO: */
    END. /* IF  VALID-HANDLE(h-bocx383a) THEN DO: */
    /*--- FIM - Altera‡Æo da DI ------------------------------------------------------------*/

    IF  INPUT FRAME fPage4 rs-tipo-apresentacao = 1 /* DI */ THEN DO:

        IF l-alterando OR (NOT l-alterando AND i-modificacao = 3 /* efetiva automaticamente*/)
                       OR (NOT l-alterando AND i-modificacao = 2 /* alterar registro */ )THEN DO:
            EMPTY TEMP-TABLE tt-histor-decla-import-aux.
            CREATE tt-histor-decla-import-aux.
            ASSIGN tt-histor-decla-import-aux.num-di-ems      = tt-decla-import.num-di-ems
                   tt-histor-decla-import-aux.num-seq         = INPUT BROWSE brHistorico tt-histor-decla-import.num-seq
                   tt-histor-decla-import-aux.cdn-pto-control = INPUT BROWSE brHistorico tt-histor-decla-import.cdn-pto-control
                   tt-histor-decla-import-aux.descricao       = INPUT BROWSE brHistorico tt-histor-decla-import.descricao
                   tt-histor-decla-import-aux.nr-dias         = INPUT BROWSE brHistorico tt-histor-decla-import.nr-dias
                   tt-histor-decla-import-aux.cod-meio-transp = INPUT BROWSE brHistorico tt-histor-decla-import.cod-meio-transp
                   tt-histor-decla-import-aux.dat-efetiva     = INPUT BROWSE brHistorico tt-histor-decla-import.dat-efetiva
                   tt-histor-decla-import-aux.dat-prev-origin = INPUT BROWSE brHistorico tt-histor-decla-import.dat-prev-origin
                   tt-histor-decla-import-aux.dat-ult-prev    = INPUT BROWSE brHistorico tt-histor-decla-import.dat-ult-prev
                   tt-histor-decla-import-aux.dsl-obs         = INPUT BROWSE brHistorico tt-histor-decla-import.dsl-obs
                   overlay(tt-histor-decla-import-aux.cod-livre-1,6,2) = c-cod-uf
                   tt-histor-decla-import-aux.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts.

            IF i-modificacao = 2 THEN DO: /* modifica‡Æo de registro */
                RUN setCriacaoPto IN h-bocx384 (INPUT YES). /* cria ponto caso nÆo exista */
            END.
            ELSE IF i-modificacao = 3 /* efetivar automaticamente */ THEN DO:
                ASSIGN tt-histor-decla-import-aux.dat-efetiva = TODAY.
            END.

            RUN emptyRowErrors  IN h-bocx384.
            RUN emptyRowObject  IN h-bocx384.
            RUN openQueryStatic IN h-bocx384 (INPUT "Main":U).
            RUN goToKey         IN h-bocx384 (INPUT tt-histor-decla-import-aux.num-di-ems, INPUT tt-histor-decla-import-aux.num-seq, INPUT tt-histor-decla-import-aux.cdd-siscomex-dts).
            IF  RETURN-VALUE = "NOK" THEN DO:
                RUN setRecord    IN h-bocx384 (INPUT TABLE tt-histor-decla-import-aux).
                RUN createRecord IN h-bocx384.
            END. /* IF  RETURN-VALUE = "NOK" */
            ELSE DO:
                RUN setRecord    IN h-bocx384 (INPUT TABLE tt-histor-decla-import-aux).
                RUN updateRecord IN h-bocx384.
            END. /* ELSE DO: */

            IF  RETURN-VALUE = "OK":U THEN DO:
                DISABLE btCanHistorico btSaveHistorico   WITH FRAME fPage4.
                IF i-modificacao = 0 THEN DO:
                    IF l-alterando THEN
                        ENABLE  btAddHistorico btUpdateHistorico WITH FRAME fPage4.
                    ELSE IF log-perm-pto-control-imp THEN
                        ENABLE  btUpdateHistorico WITH FRAME fPage4.
                END.
                ASSIGN i-modificacao = 0.
                RUN pi-busca-historicos-di.
                APPLY 'entry' TO btAddHistorico IN FRAME fPage4.
                RUN pi-trata-browser-historico (INPUT YES).
            END. /* IF  RETURN-VALUE = "OK":U */
            ELSE DO:
                RUN getRowErrors IN h-bocx384(OUTPUT TABLE RowErrors).
                IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                    IF i-modificacao = 3 /* efetivar automaticamente */ THEN
                        ASSIGN i-modificacao = 0.
                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal="YES"}
                END. /* IF  CAN-FIND(FIRST RowErrors */
            END. /* ELSE DO: */
        END.
        ELSE IF i-modificacao = 1 /* altera‡Æo de sequˆncias */ THEN DO:
            /*--- Valida se nÆo h  sequˆncias duplicadas na tt-histor-decla-import -----------------*/
            EMPTY TEMP-TABLE tt-bo-erro.
            APPLY "LEAVE":U TO tt-histor-decla-import.num-seq IN BROWSE brHistorico.
            FOR EACH tt-histor-decla-import :
                IF CAN-FIND(FIRST bf-tt-histor-decla-import
                            WHERE bf-tt-histor-decla-import.num-di-ems =  tt-histor-decla-import.num-di-ems
                            AND   bf-tt-histor-decla-import.num-seq    =  tt-histor-decla-import.num-seq
                            AND   bf-tt-histor-decla-import.cdd-siscomex-dts =  tt-histor-decla-import.cdd-siscomex-dts
                            AND   bf-tt-histor-decla-import.r-rowid   <> tt-histor-decla-import.r-rowid)
                    AND NOT CAN-FIND(FIRST tt-bo-erro
                                         WHERE tt-bo-erro.cd-erro = 51975) THEN DO:

                    RUN utp/ut-msgs.p (INPUT "msg":U,
                                       INPUT 51975,
                                       INPUT ?).
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.i-sequen     = 1
                           tt-bo-erro.cd-erro      = 51975
                           tt-bo-erro.mensagem     = RETURN-VALUE.

                    RUN utp/ut-msgs.p (INPUT "HELP":U,
                                       INPUT 51975,
                                       INPUT STRING(tt-histor-decla-import.num-seq)).
                    ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.
                END.
            END.

            /* Se ocorrerem erros, exibe em tela */
            IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
                IF NOT VALID-HANDLE(hShowMsg) THEN
                   RUN utp/showmessage.w PERSISTENT SET hShowMsg.
                RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).
                WAIT-FOR CLOSE OF hShowMsg FOCUS CURRENT-WINDOW.
                IF VALID-HANDLE(hShowMsg) THEN
                    DELETE PROCEDURE hShowMsg.
                APPLY "ROW-ENTRY":U TO BROWSE brHistorico.
                APPLY "ENTRY":U TO tt-histor-decla-import.num-seq IN BROWSE brHistorico.
                RETURN NO-APPLY.
            END.

            IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
                RUN cxbo/bocx384.p PERSISTENT SET h-bocx384.
                RUN validateUpdateAcomp IN h-bocx384 (INPUT TABLE tt-histor-decla-import).
                RUN getRowErrors IN h-bocx384(OUTPUT TABLE RowErrors).
            END.

            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="YES"}
                APPLY "ROW-ENTRY":U TO BROWSE brHistorico.
                APPLY "ENTRY":U TO tt-histor-decla-import.num-seq IN BROWSE brHistorico.
            END.
            ELSE IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
                DISABLE btCanHistorico btSaveHistorico   WITH FRAME fPage4.
                ASSIGN i-modificacao = 0.
                RUN pi-busca-historicos-di.
                RUN pi-trata-browser-historico (INPUT YES).
            END.
        END.
    END. /* IF  INPUT FRAME fPage4 rs-tipo-apresentacao = 1 */
    ELSE DO: /* Embarque */

        RUN findFirstEmbarque IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-decla-import.cod-estab,
                                            INPUT INPUT FRAME fPage4 c-cod-embarq,
                                            OUTPUT c-return).
        IF  c-return = "" THEN RUN getIntField IN h-bocx230 (INPUT 'cod-itiner', OUTPUT i-cod-itiner).

        EMPTY TEMP-TABLE tt-historico-embarque-aux.
        CREATE tt-historico-embarque-aux.
        ASSIGN tt-historico-embarque-aux.cod-estabel     = INPUT FRAME fPage0 tt-decla-import.cod-estab
               tt-historico-embarque-aux.embarque        = INPUT FRAME fPage4 c-cod-embarq
               tt-historico-embarque-aux.cod-itiner      = i-cod-itiner
               tt-historico-embarque-aux.sequencia       = INPUT BROWSE brHistorico tt-histor-decla-import.num-seq
               tt-historico-embarque-aux.cod-pto-contr   = INPUT BROWSE brHistorico tt-histor-decla-import.cdn-pto-control
               tt-historico-embarque-aux.descricao       = INPUT BROWSE brHistorico tt-histor-decla-import.descricao
               tt-historico-embarque-aux.id-meio-transp  = INPUT BROWSE brHistorico tt-histor-decla-import.cod-meio-transp
               tt-histor-decla-import-aux.nr-dias        = INPUT BROWSE brHistorico tt-histor-decla-import.nr-dias
               tt-historico-embarque-aux.dt-previsao     = INPUT BROWSE brHistorico tt-histor-decla-import.dat-prev-origin
               tt-historico-embarque-aux.dt-ult-previsao = INPUT BROWSE brHistorico tt-histor-decla-import.dat-ult-prev
               tt-historico-embarque-aux.dt-efetiva      = INPUT BROWSE brHistorico tt-histor-decla-import.dat-efetiva
               tt-historico-embarque-aux.observacao      = INPUT BROWSE brHistorico tt-histor-decla-import.dsl-obs
               overlay(tt-historico-embarque-aux.char-1,1,2) = c-cod-uf.

        /*--- Altera o registro corrente do BO 1.1 ---*/
        RUN validateUpdate IN h-bocx230a (INPUT TABLE tt-historico-embarque-aux,
                                          INPUT rGoTo,
                                          OUTPUT TABLE RowErrors).

        IF  CAN-FIND(FIRST RowErrors) THEN DO:
            IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="YES"}
            END. /* IF  CAN-FIND(FIRST RowErrors */
        END. /* IF  CAN-FIND(FIRST RowErrors) THEN DO: */
        ELSE DO:
            DISABLE btCanHistorico btSaveHistorico WITH FRAME fPage4.
            ENABLE  btUpdateHistorico              WITH FRAME fPage4.

            ASSIGN tt-histor-decla-import.num-seq        :READ-ONLY  IN BROWSE brHistorico = YES
                   tt-histor-decla-import.cdn-pto-control:READ-ONLY  IN BROWSE brHistorico = YES
                   tt-histor-decla-import.descricao      :READ-ONLY  IN BROWSE brHistorico = YES
                   tt-histor-decla-import.dat-prev-orig  :READ-ONLY  IN BROWSE brHistorico = YES
                   tt-histor-decla-import.dat-efetiva    :READ-ONLY  IN BROWSE brHistorico = YES
                   tt-histor-decla-import.cod-meio-transp:READ-ONLY  IN BROWSE brHistorico = YES
                   tt-histor-decla-import.dsl-obs        :READ-ONLY  IN BROWSE brHistorico = YES
                   tt-histor-decla-import.dat-ult-prev   :READ-ONLY  IN BROWSE brHistorico = YES
                   tt-histor-decla-import.nr-dias        :READ-ONLY  IN BROWSE brHistorico = YES.

        END. /* ELSE DO: */
    END. /* ELSE DO: */

    ASSIGN i-pto-ant = 0.
    APPLY "VALUE-CHANGED":U TO brHistorico IN FRAME fPage4.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-processo-vinc wMaintenance
PROCEDURE pi-salva-processo-vinc :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-decla-imp-proc.

    CREATE tt-decla-imp-proc.
    ASSIGN tt-decla-imp-proc.num-di-ems            = tt-decla-import.num-di-ems
           tt-decla-imp-proc.cod-proces-vincul     = INPUT BROWSE brProcessoVinc tt-decla-imp-proc-aux.cod-proces-vincul
           tt-decla-imp-proc.cdd-siscomex-dts      = tt-decla-import.cdd-siscomex-dts.

    ASSIGN tt-decla-imp-proc.idi-tip-proces-vincul = fnTipoProcesso(INPUT BROWSE brProcessoVinc tt-decla-imp-proc-aux.desc-tipo).

    RUN emptyRowErrors IN h-bocx396.
    RUN emptyRowObject IN h-bocx396.
    RUN setRecord      IN h-bocx396 (INPUT TABLE tt-decla-imp-proc).
    RUN createRecord   IN h-bocx396.
    IF RETURN-VALUE = "OK":U THEN DO:
        DISABLE btCanProcVinc
                btSaveProcessoVinc WITH FRAME fPage2.
        ENABLE btAddProcessoVinc
               btDelProcessoVinc WITH FRAME fPage2.

        ASSIGN tt-decla-imp-proc-aux.desc-tipo         :READ-ONLY IN BROWSE brProcessoVinc = YES
               tt-decla-imp-proc-aux.cod-proces-vincul :READ-ONLY IN BROWSE brProcessoVinc = YES.

        RUN pi-busca-processos-vinculados.
        APPLY 'entry' TO btAddProcessoVinc IN FRAME fPage2.
    END.
    ELSE DO:
        RUN getRowErrors IN h-bocx396(OUTPUT TABLE RowErrors).
        IF  CAN-FIND(FIRST RowErrors
                     WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
        END.
    END.
    /*END.*/




    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-inf-compl wMaintenance
PROCEDURE pi-seta-inf-compl :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-retorno-inf-compltar LIKE decla-import.cod-inf-compltar NO-UNDO.

ASSIGN tt-decla-import.cod-inf-compltar = p-retorno-inf-compltar.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-param-ativo wMaintenance
PROCEDURE pi-seta-param-ativo :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-param-ativo AS LOGICAL NO-UNDO.

ASSIGN l-param-ativo = p-param-ativo.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-tipo-apresentacao wMaintenance
PROCEDURE pi-tipo-apresentacao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

IF INPUT FRAME fPage4 rs-tipo-apresentacao = 1 THEN DO:
    ASSIGN c-cod-embarq = "".
    DISP c-cod-embarq WITH FRAME fPage4.
    DISABLE c-cod-embarq WITH FRAME fPage4.

    IF NOT l-tipo-apres THEN DO:
        IF cAction <> '' THEN
            IF NOT CAN-FIND(FIRST tt-histor-decla-import) THEN
                DISABLE btAddHistorico btCanHistorico btUpdateHistorico btSaveHistorico WITH FRAME fPage4.

            ELSE DO:
                ENABLE  btAddHistorico btUpdateHistorico WITH FRAME fPage4.
                DISABLE btCanHistorico btSaveHistorico    WITH FRAME fPage4.
            END.

        RUN pi-busca-historicos-di.

        IF cAction = '' THEN
            IF NOT CAN-FIND(FIRST tt-histor-decla-import) THEN DO:
                DISABLE btAddSon1 btUpdateSon1 btDeleteSon1
                            WITH FRAME fPage4.
            END.
            ELSE DO:
                ENABLE btAddSon1 btUpdateSon1 btDeleteSon1
                            WITH FRAME fPage4.
            END.

    END.
    ELSE DO:
        DISABLE btAddHistorico btCanHistorico btSaveHistorico btUpdateHistorico
                btAddSon1 btUpdateSon1 btDeleteSon1
            WITH FRAME fPage4.
    END.
END.
ELSE DO:
    DISABLE btAddHistorico btCanHistorico btSaveHistorico btUpdateHistorico
        btAddSon1 btUpdateSon1 btDeleteSon1
        WITH FRAME fPage4.
    ENABLE c-cod-embarq btAtualizaEmb WITH FRAME fPage4.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-browser-despesa wMaintenance
PROCEDURE pi-trata-browser-despesa :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pReadyOnly AS LOGICAL NO-UNDO.

    ASSIGN tt-despes-decla-import.desc-tipo                :READ-ONLY IN BROWSE brDespesa = pReadyOnly
           tt-despes-decla-import.log-incid-vmle              :READ-ONLY IN BROWSE brDespesa = pReadyOnly
           tt-despes-decla-import.cdn-despes               :READ-ONLY IN BROWSE brDespesa = pReadyOnly
           tt-despes-decla-import.cdn-emit-despes          :READ-ONLY IN BROWSE brDespesa = pReadyOnly
           tt-despes-decla-import.cdn-cond-pagto           :READ-ONLY IN BROWSE brDespesa = pReadyOnly
           tt-despes-decla-import.cdn-moed                 :READ-ONLY IN BROWSE brDespesa = pReadyOnly
           tt-despes-decla-import.val-desp                 :READ-ONLY IN BROWSE brDespesa = pReadyOnly
           tt-despes-decla-import.val-cotac-despes-compltar:READ-ONLY IN BROWSE brDespesa = pReadyOnly.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-browser-historico wMaintenance
PROCEDURE pi-trata-browser-historico :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM pReadyOnly AS LOGICAL NO-UNDO.

ASSIGN tt-histor-decla-import.num-seq             :READ-ONLY  IN BROWSE brHistorico = pReadyOnly
       tt-histor-decla-import.cdn-pto-control     :READ-ONLY  IN BROWSE brHistorico = pReadyOnly
       tt-histor-decla-import.descricao           :READ-ONLY  IN BROWSE brHistorico = pReadyOnly
       tt-histor-decla-import.dat-prev-origin     :READ-ONLY  IN BROWSE brHistorico = pReadyOnly
       tt-histor-decla-import.dat-efetiva         :READ-ONLY  IN BROWSE brHistorico = pReadyOnly
       tt-histor-decla-import.cod-meio-transp     :READ-ONLY  IN BROWSE brHistorico = pReadyOnly
       tt-histor-decla-import.dsl-obs             :READ-ONLY  IN BROWSE brHistorico = pReadyOnly
       tt-histor-decla-import.dat-ult-prev        :READ-ONLY  IN BROWSE brHistorico = pReadyOnly
       tt-histor-decla-import.nr-dias             :READ-ONLY  IN BROWSE brHistorico = pReadyOnly.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-combos wMaintenance
PROCEDURE pi-trata-combos :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pLogGravarMostrar AS LOGICAL NO-UNDO.

    IF AVAIL tt-decla-import THEN
        IF pLogGravarMostrar THEN DO:
            ASSIGN cb-tipo-declaracao    :screen-value  in frame fPage1 = {cxinc/i02cx383.i 04 tt-decla-import.idi-tip-decla-import}
                   cb-carac-oper         :screen-value  in frame fPage1 = {cxinc/i03cx383.i 04 tt-decla-import.idi-caract-operac}
                   cb-mod-desp           :screen-value  in frame fPage1 = {cxinc/i04cx383.i 04 tt-decla-import.idi-modalid-despch}
                   cb-via-transporte     :screen-value  in frame fPage2 = {adinc/i01ad268.i 04 tt-decla-import.idi-via-transp-di}
                   cb-docto-carg         :screen-value  in frame fPage2 = {cxinc/i06cx383.i 04 tt-decla-import.idi-docto-carg}
                   cb-tipo-conhecto      :screen-value  in frame fPage2 = {cxinc/i07cx383.i 04 tt-decla-import.idi-tip-conhecto}
                   cb-ind-utiliz         :screen-value  in frame fPage2 = {cxinc/i08cx383.i 04 tt-decla-import.idi-ind-utiliz}.
        END.
        ELSE DO:
            ASSIGN INPUT FRAME fPage1 cb-tipo-declaracao
                   INPUT FRAME fPage1 cb-carac-oper
                   INPUT FRAME fPage1 cb-mod-desp
                   INPUT FRAME fPage2 cb-via-transporte
                   INPUT FRAME fPage2 cb-docto-carg
                   INPUT FRAME fPage2 cb-tipo-conhecto
                   INPUT FRAME fPage2 cb-ind-utiliz
                   tt-decla-import.idi-tip-decla-import = {cxinc/i02cx383.i 06 cb-tipo-declaracao}
                   tt-decla-import.idi-caract-operac    = {cxinc/i03cx383.i 06 cb-carac-oper}
                   tt-decla-import.idi-modalid-despch   = {cxinc/i04cx383.i 06 cb-mod-desp}
                   tt-decla-import.idi-via-transp-di    = {adinc/i01ad268.i 06 cb-via-transporte}
                   tt-decla-import.idi-docto-carg       = {cxinc/i06cx383.i 06 cb-docto-carg}
                   tt-decla-import.idi-tip-conhecto     = {cxinc/i07cx383.i 06 cb-tipo-conhecto}
                   tt-decla-import.idi-ind-utiliz       = {cxinc/i08cx383.i 06 cb-ind-utiliz}.

            RUN pi-trata-transporte.
        END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-operacao wMaintenance
PROCEDURE pi-trata-operacao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-carac-oper AS INTEGER     NO-UNDO.

    ASSIGN INPUT FRAME fPage1 cb-carac-oper
           i-carac-oper = {cxinc/i03cx383.i 06 cb-carac-oper}.

    IF i-carac-oper = 1
        AND cAction <> '' THEN DO:
        ASSIGN tt-decla-import.cdn-consign:SENSITIVE IN FRAME fPage1    = NO
               tt-decla-import.cdn-consign:SCREEN-VALUE IN FRAME fPage1 = "".

        APPLY 'LEAVE' TO tt-decla-import.cdn-consign IN FRAME fPage1.
    END.
    ELSE DO:
        IF cAction <> '' THEN
            ASSIGN tt-decla-import.cdn-consign:SENSITIVE IN FRAME fPage1 = YES.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-transporte wMaintenance
PROCEDURE pi-trata-transporte :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-via-transp AS INTEGER     NO-UNDO.

    ASSIGN i-via-transp = {adinc/i01ad268.i 06 cb-via-transporte}.

    CASE i-via-transp:

        WHEN 1 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 7
                   tt-decla-import.log-multimod      = NO.

        WHEN 2 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 4
                   tt-decla-import.log-multimod      = YES.

        WHEN 3 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 1
                   tt-decla-import.log-multimod      = NO.

        WHEN 4 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 6
                   tt-decla-import.log-multimod      = NO.

        WHEN 5 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 6
                   tt-decla-import.log-multimod      = YES.

        WHEN 6 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 2
                   tt-decla-import.log-multimod      = YES.

        WHEN 7 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 7
                   tt-decla-import.log-multimod      = YES.

        WHEN 8 THEN
            ASSIGN tt-decla-import.cdn-via-transp-di = 11
                   tt-decla-import.log-multimod      = NO.

    END CASE.



RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-update-despesa wMaintenance
PROCEDURE pi-update-despesa :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    IF  AVAIL tt-decla-import THEN DO:
        DO  i-cont = 1 TO brDespesa:NUM-SELECTED-ROWS IN FRAME fPage5:
            IF  brDespesa:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage5 THEN DO:
                DISABLE btAddDespesa btUpdateDespesa WITH FRAME fPage5.
                ENABLE btCanDespesa btSaveDespesa WITH FRAME fPage5.

                ASSIGN tt-despes-decla-import.desc-tipo          :READ-ONLY IN BROWSE brDespesa = YES
                       tt-despes-decla-import.cdn-despes               :READ-ONLY IN BROWSE brDespesa = YES
                       tt-despes-decla-import.cdn-emit-despes          :READ-ONLY IN BROWSE brDespesa = YES
                       tt-despes-decla-import.log-incid-vmle           :READ-ONLY IN BROWSE brDespesa = NO
                       tt-despes-decla-import.cdn-cond-pagto           :READ-ONLY IN BROWSE brDespesa = NO
                       tt-despes-decla-import.cdn-moed                 :READ-ONLY IN BROWSE brDespesa = NO
                       tt-despes-decla-import.val-desp                 :READ-ONLY IN BROWSE brDespesa = NO.

                reposition brDespesa to rowid rowid(tt-despes-decla-import) no-error.
                apply "entry" to tt-despes-decla-import.cdn-cond-pagto in browse brDespesa.
            END. /* IF  brDespesa:FETCH-SELECTED-ROW(i-cont) */
        END. /* DO  i-cont = 1 TO brDespesa */
    END. /* IF  AVAIL tt-decla-import */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-update-despesa-di wMaintenance
PROCEDURE pi-update-despesa-di :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    IF  AVAIL tt-decla-import THEN DO:
        DO  i-cont = 1 TO brDespesa:NUM-SELECTED-ROWS IN FRAME fPage5:
            IF  brDespesa:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage5 THEN DO:
                ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
                RUN imp/im0400a.w PERSISTENT SET h-im0400a (INPUT tt-despes-decla-import.r-Rowid,
                                                            INPUT tt-decla-import.r-Rowid,
                                                            INPUT 'UPDATE',
                                                            INPUT THIS-PROCEDURE,
                                                            INPUT 6).
                IF  VALID-HANDLE (h-im0400a) THEN DO:
                    RUN initializeInterface IN h-im0400a.
                    WAIT-FOR CLOSE OF h-im0400a FOCUS CURRENT-WINDOW.
                END.
                ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
            END. /* IF  brDespesa:FETCH-SELECTED-ROW(i-cont) */
        END. /* DO  i-cont = 1 TO brDespesa */
    END. /* IF  AVAIL tt-decla-import */

    RUN pi-atualiza-registro-tela.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-update-historico wMaintenance
PROCEDURE pi-update-historico :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF  AVAIL tt-decla-import THEN DO:
        /*--- Altera‡Æo da DI ------------------------------------------------------------------*/
        IF  VALID-HANDLE(h-bocx383a) THEN DO:
            RUN piDoctoRecebimento IN h-bocx383a(INPUT tt-decla-import.cod-di-siscomex, OUTPUT l-encontrou).

            IF  l-encontrou THEN DO:
            IF  tt-histor-decla-import.cdn-pto-control <= i-pto-nacionalizacao THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-alteracao-nao-permitida AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Altera‡Æo_nÆo_permitida" *}
                ASSIGN c-lbl-liter-alteracao-nao-permitida = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-nao-e-possivel-alterar-este-re AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "NÆo_‚_poss¡vel_alterar_este_registro_pois_j _foram_geradas_as_notas_fiscais_para_os_embarques_vinculados" *}
                ASSIGN c-lbl-liter-nao-e-possivel-alterar-este-re = TRIM(RETURN-VALUE).
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT c-lbl-liter-alteracao-nao-permitida + "~~" + c-lbl-liter-nao-e-possivel-alterar-este-re + "!").
                RETURN "NOK":U.
            END. /* IF  tt-histor-decla-import.cdn-pto-control <= i-pto-nacionalizacao */
            END. /* IF  l-encontrou THEN DO: */
        END. /* IF  VALID-HANDLE(h-bocx383a) THEN DO: */
    END. /* IF  AVAIL tt-decla-import */

    DO  i-cont = 1 TO brHistorico:NUM-SELECTED-ROWS IN FRAME fPage4:
        IF  brHistorico:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage4 THEN DO:

            DISABLE btAddHistorico
                    btUpdateHistorico
                    btn-muda-sequencia WITH FRAME fPage4.

            ENABLE btCanHistorico
                   btSaveHistorico WITH FRAME fPage4.
            reposition brHistorico to rowid rowid(tt-histor-decla-import) no-error.
            ASSIGN tt-histor-decla-import.num-seq             :READ-ONLY  IN BROWSE brHistorico = YES
                   tt-histor-decla-import.cdn-pto-control     :READ-ONLY  IN BROWSE brHistorico = YES
                   tt-histor-decla-import.dat-prev-orig       :READ-ONLY  IN BROWSE brHistorico = YES
                   tt-histor-decla-import.dat-ult-prev        :READ-ONLY  IN BROWSE brHistorico = YES
                   tt-histor-decla-import.nr-dias             :READ-ONLY  IN BROWSE brHistorico = YES.

            IF l-alterando THEN DO:
                ASSIGN tt-histor-decla-import.dat-efetiva         :READ-ONLY  IN BROWSE brHistorico = NO
                       tt-histor-decla-import.cod-meio-transp     :READ-ONLY  IN BROWSE brHistorico = NO
                       tt-histor-decla-import.dsl-obs             :READ-ONLY  IN BROWSE brHistorico = NO.
                apply "entry" to tt-histor-decla-import.dat-efetiva in browse brHistorico.
            END.

            /* Verifica se o parƒmetro Permite altera‡Æo pto controle est  ativo, e se a data de efetica‡Æo est  em branco, se sim, libera o botÆo de altra‡Æo do ponto de controle*/
            IF log-perm-pto-control-imp AND NOT l-alterando AND i-modificacao = 2 /* modifica‡Æo de pto */ THEN DO:
                ASSIGN tt-histor-decla-import.cdn-pto-control     :READ-ONLY  IN BROWSE brHistorico = NO
                       tt-histor-decla-import.descricao           :READ-ONLY  IN BROWSE brHistorico = NO
                       tt-histor-decla-import.dat-efetiva         :READ-ONLY  IN BROWSE brHistorico = NO
                       tt-histor-decla-import.nr-dias             :READ-ONLY  IN BROWSE brHistorico = NO.
                apply "entry" to tt-histor-decla-import.cdn-pto-control in browse brHistorico.
            END.
        END.
    END.

    IF  INPUT FRAME fPage4 rs-tipo-apresentacao = 2 /* Embarque */ THEN DO:
        APPLY 'value-changed':U TO brHistorico IN FRAME fPage4.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-update-historico-di wMaintenance
PROCEDURE pi-update-historico-di :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
IF AVAIL tt-decla-import THEN DO:
    DO  i-cont = 1 TO brHistorico:NUM-SELECTED-ROWS IN FRAME fPage4:
        IF  brHistorico:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage4 THEN DO:
            ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
            RUN imp/im0400b.w PERSISTENT SET h-im0400b (INPUT tt-histor-decla-import.r-Rowid,
                                                        INPUT tt-decla-import.r-Rowid,
                                                        INPUT 'UPDATE',
                                                        INPUT THIS-PROCEDURE,
                                                        INPUT 5).
            IF  VALID-HANDLE (h-im0400b) THEN DO:
                RUN initializeInterface IN h-im0400b.
                WAIT-FOR CLOSE OF h-im0400b FOCUS CURRENT-WINDOW.
            END.
            ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        END.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-cot-desp-compl wMaintenance
PROCEDURE pi-valida-cot-desp-compl :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM pPtoControle LIKE despes-decla-import.cdn-pto-control NO-UNDO.
DEF INPUT PARAM pMoeda       LIKE despes-decla-import.cdn-moed        NO-UNDO.

IF pMoeda <> 0 THEN
    ASSIGN tt-despes-decla-import.val-cotac-despes-compltar:READ-ONLY IN BROWSE brDespesa = YES.
ELSE DO:
    ASSIGN l-retorno = NO.
    RUN pi-valida-ponto-controle-chegada IN h-bocx406 (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                                       INPUT pPtoControle,
                                                       INPUT tt-decla-import.cdd-siscomex-dts, //cdd-siscomex-dts
                                                       OUTPUT l-retorno).
    IF l-retorno THEN
        ASSIGN tt-despes-decla-import.val-cotac-despes-compltar:READ-ONLY IN BROWSE brDespesa = NO.
    ELSE DO:
        ASSIGN tt-despes-decla-import.val-cotac-despes-compltar:READ-ONLY IN BROWSE brDespesa = YES.

        APPLY 'ENTRY' TO btSaveDespesa IN FRAME fPage5.

    END.


END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-data wMaintenance
PROCEDURE pi-valida-data :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
RUN pi-valida-alteracao-data-di IN h-bocx383 (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                              INPUT INPUT FRAME fPage0 tt-decla-import.num-seq-retif,
                                              INPUT tt-decla-import.cdd-siscomex-dts, //cdd-sicomex-dts
                                              INPUT INPUT FRAME fPage0 tt-decla-import.dat-di,
                                              OUTPUT l-data-diferente).
IF l-data-diferente THEN DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Deseja_atualizar_cota‡Æo_conforme_nova_data_informada?" *}
    RUN utp/ut-msgs.p (INPUT 'show',
                    INPUT 27100,
                    INPUT RETURN-VALUE).

    RUN pi-seta-atualiza-cotac IN h-bocx383 (INPUT LOGICAL(RETURN-VALUE)).
END.
ELSE
    RUN pi-seta-atualiza-cotac IN h-bocx383 (INPUT NO).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-despesas-embarque wMaintenance
PROCEDURE pi-verifica-despesas-embarque :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    IF  INPUT FRAME fPage5 rs-apres-despesa = 2 /* EMBARQUE */ THEN DO:

        RUN pi-verifica-despesas-embarque IN h-bocx406 (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                                        INPUT tt-despes-decla-import.cdn-desp,
                                                        INPUT tt-decla-import.cdd-siscomex-dts, //cdd-siscomex-dts
                                                        OUTPUT l-troca-cor).
        IF l-troca-cor THEN
            RUN trocaCorDespesa(INPUT 12).
        ELSE
            RUN trocaCorDespesa(INPUT ?).

    END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-embarques-vinculados wMaintenance
PROCEDURE pi-verifica-embarques-vinculados :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
RUN pi-valida-embarques-di IN h-bocx407 (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                         INPUT tt-decla-import.cdd-siscomex-dts, //cdd-siscomex-dts
                                         OUTPUT l-embarq-vinc).

ASSIGN tt-decla-import.cod-estab:SENSITIVE IN FRAME fPage0 = NOT l-embarq-vinc.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vincula-embarque wMaintenance
PROCEDURE pi-vincula-embarque :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-nro-retif AS INTEGER     NO-UNDO.

IF AVAIL tt-decla-import THEN DO:
    RUN buscaUltimaRetificacao IN {&hDBOTable} (INPUT  tt-decla-import.num-di-ems,
                                                INPUT  tt-decla-import.cdd-siscomex-dts,
                                                OUTPUT i-nro-retif).

    IF i-nro-retif > tt-decla-import.num-seq-retif THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show',
                        INPUT 52163,
                        INPUT '').
    END.
    ELSE DO:
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        RUN imp/im0420.w PERSISTENT SET h-im0420.
        IF  VALID-HANDLE (h-im0420) THEN DO:
            RUN setaDI              IN h-im0420(INPUT tt-decla-import.num-di-ems,
                                                INPUT tt-decla-import.num-seq-retif,
                                                INPUT tt-decla-import.cdd-siscomex-dts,
                                                INPUT THIS-PROCEDURE).
            RUN initializeInterface IN h-im0420.
            WAIT-FOR CLOSE OF h-im0420 FOCUS CURRENT-WINDOW.
        END.
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    END.
    RUN pi-atualiza-registro-tela.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionRecordSon wMaintenance
PROCEDURE repositionRecordSon :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid      AS ROWID   NO-UNDO.
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

    /*--- Atualiza browse filho mas somente da pÿgina iRepositionPageNumber ---*/
    CASE pPageNumber:
        WHEN 5 THEN DO:
            RUN pi-busca-historicos-di.
        END.
        WHEN 6 THEN DO:
            RUN pi-busca-despesas-di.
        END.
    END CASE.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaTipoGeracaoRateio wMaintenance
PROCEDURE setaTipoGeracaoRateio :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-rateio           AS LOGICAL NO-UNDO.
DEF INPUT PARAM p-gera-relat       AS LOGICAL NO-UNDO.
DEF INPUT PARAM p-calcula-impostos AS LOGICAL NO-UNDO.
DEF INPUT PARAM p-rateio-desp-comp AS LOGICAL NO-UNDO.
DEF INPUT PARAM p-regera-default-impostos AS LOGICAL NO-UNDO.

    ASSIGN l-rateio           = p-rateio
           l-gera-relat       = p-gera-relat
           l-calcula-impostos = p-calcula-impostos
           l-rateio-desp-comp = p-rateio-desp-comp
           l-regera-default-impostos = p-regera-default-impostos.

    IF l-regera-default-impostos THEN
        RUN pi-recarrega-impostos IN h-bocx383a (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                                 INPUT INPUT FRAME fPage1 tt-decla-import.cod-natur-operac,
                                                 INPUT tt-decla-import.cdd-siscomex-dts).  //cdd-siscomex-dts

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trocaCorDespesa wMaintenance
PROCEDURE trocaCorDespesa :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM pColor AS INTEGER NO-UNDO.

ASSIGN c-brw-desc-pto-control                           :FGCOLOR IN BROWSE brDespesa = pColor
       c-brw-desc-despes                                :FGCOLOR IN BROWSE brDespesa = pColor
       c-brw-nome-abrev                                 :FGCOLOR IN BROWSE brDespesa = pColor
       c-brw-desc-pagto                                 :FGCOLOR IN BROWSE brDespesa = pColor
       tt-despes-decla-import.desc-tipo                 :FGCOLOR IN BROWSE brDespesa = pColor
       tt-despes-decla-import.cdn-despes                :FGCOLOR IN BROWSE brDespesa = pColor
       tt-despes-decla-import.cdn-emit-despes           :FGCOLOR IN BROWSE brDespesa = pColor
       tt-despes-decla-import.cdn-cond-pagto            :FGCOLOR IN BROWSE brDespesa = pColor
       tt-despes-decla-import.cdn-moed                  :FGCOLOR IN BROWSE brDespesa = pColor
       tt-despes-decla-import.val-desp                  :FGCOLOR IN BROWSE brDespesa = pColor
       tt-despes-decla-import.val-cotac-despes-compltar :FGCOLOR IN BROWSE brDespesa = pColor
       tt-despes-decla-import.cdn-pto-control           :FGCOLOR IN BROWSE brDespesa = pColor.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCalculaDiferenca wMaintenance
FUNCTION fnCalculaDiferenca RETURNS INTEGER
  ( i-num-seq    AS INTEGER,
    pcdd-siscomex-dts AS DECIMAL,
    dt-efetiva AS DATE) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
  def var num-dif as integer no-undo.
  DEFINE VARIABLE dt-ult-prev AS DATE        NO-UNDO.

  RUN goToKey IN h-bocx384(INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                           INPUT i-num-seq,
                           INPUT pcdd-siscomex-dts).
  IF RETURN-VALUE = "OK":U THEN DO:

      RUN getDateField IN h-bocx384(INPUT 'dat-ult-prev',
                                    OUTPUT dt-ult-prev).

      if dt-efetiva <> ? then
         assign num-dif = dt-efetiva - tt-histor-decla-import.dat-prev-origin.
      else
         assign num-dif = dt-ult-prev - tt-histor-decla-import.dat-prev-origin.
  END.

  RETURN num-dif.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescDespes wMaintenance
FUNCTION fnDescDespes RETURNS CHARACTER
  ( p-cdn-despes AS INT,
    p-num-di-ems AS INT,
    p-cdd-siscomex-dts AS DEC) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc-despesa AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-estab AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-embarque AS CHARACTER   NO-UNDO.

    RUN goToFirstEmbarque IN h-bocx407 (INPUT p-num-di-ems,
                                        INPUT p-cdd-siscomex-dts).

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-bocx407 (INPUT "cod-embarq":U, OUTPUT c-embarque).
        RUN getCharField IN h-bocx407 (INPUT "cod-estab":U, OUTPUT c-cod-estab).

        RUN findDespesa IN h-bocx310 (INPUT c-cod-estab,
                                      INPUT c-embarque,
                                      INPUT p-cdn-despes,
                                      OUTPUT c-return).

        IF c-return = "":U THEN DO:
            RUN getCharField IN h-bocx310 (INPUT "descricao":U,
                                           OUTPUT c-desc-despesa).
        END.
    END.

    IF c-desc-despesa = "":U AND VALID-HANDLE(h-bocx095) THEN DO:
        RUN retornaDescDespesa IN h-bocx095 (INPUT p-cdn-despes, output c-desc-despesa).
    END.

    RETURN c-desc-despesa. /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescPagto wMaintenance
FUNCTION fnDescPagto RETURNS CHARACTER
  ( i-cdn-pagto as integer ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    def var c-descricao like cond-pagto.descricao no-undo.

    RUN goToKey IN h-boad039na (INPUT string(i-cdn-pagto)).
    IF  RETURN-VALUE = "OK" THEN DO:
        RUN getCharField IN h-boad039na(INPUT 'descricao', OUTPUT c-descricao).
    END.
    ELSE ASSIGN c-descricao = "".

    RETURN c-descricao. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricaoPtoControle wMaintenance
FUNCTION fnDescricaoPtoControle RETURNS CHARACTER
  ( input num-di-ems AS int,
    INPUT p-cdd-siscomex-dts AS DEC,
    input p-pto-control AS INT) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    ASSIGN c-desc-pto-control = "":U.

    RUN goToKeyByPto IN h-bocx3842 (INPUT num-di-ems,
                                    INPUT p-cdd-siscomex-dts,
                                    INPUT p-pto-control).
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-bocx3842(INPUT "descricao":U,
                                       OUTPUT  c-desc-pto-control).
    END.

    IF RETURN-VALUE <> "OK":U OR TRIM(c-desc-pto-control) = "":U THEN DO:
        RUN goToKey IN h-bocx110na (INPUT p-pto-control).
        IF RETURN-VALUE = "OK" THEN DO:
            RUN getCharField IN h-bocx110na(INPUT 'descricao',
                                            OUTPUT c-desc-pto-control).
        END.
        ELSE
            ASSIGN c-desc-pto-control = "".
    END.

    RETURN c-desc-pto-control.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeAbrev wMaintenance
FUNCTION fnNomeAbrev RETURNS CHARACTER
  ( p-cod-emitente AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    def var c-nome-abreviado like emitente.nome-abrev no-undo.

    RUN goToKey IN h-boad098na (INPUT p-cod-emitente).
    IF  RETURN-VALUE = "OK" THEN DO:
        RUN getCharField IN h-boad098na(INPUT 'nome-emit', OUTPUT c-nome-abreviado).
    END.
    ELSE ASSIGN c-nome-abreviado = "".

    RETURN c-nome-abreviado. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipoProcesso wMaintenance
FUNCTION fnTipoProcesso RETURNS INTEGER
  ( pTipo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    CASE pTipo:
        WHEN "Administrativo":U THEN
            ASSIGN i-tipo = 1.
        WHEN "Judicial":U THEN
            ASSIGN i-tipo = 2.
        WHEN "Declara‡Æo Preliminar":U THEN
            ASSIGN i-tipo = 3.
        WHEN "Judicial Exclusivo DARF":U THEN
            ASSIGN i-tipo = 4.
    END CASE.


  RETURN i-tipo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUF wMaintenance
FUNCTION fnUF RETURNS CHARACTER
  (input pnum-di-ems AS INTEGER,
   input pcdn-pto-control AS INTEGER,
   INPUT p-cdd-siscomex-dts AS DEC):
/*------------------------------------------------------------------------------
  Purpose:  Retorna UF do ponto de controle do Acompanhamento da DI
    Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-cod-livre-1 AS CHARACTER NO-UNDO.

    IF   l-tipo-apres THEN DO: /* Embarque */
        ASSIGN c-cod-livre-1 = SUBSTR(tt-histor-decla-import.cod-livre-1,6,2).
    END.
    ELSE DO: /* DI */
        RUN goToKeyByPto IN h-bocx3842 (INPUT pnum-di-ems,
                                        INPUT p-cdd-siscomex-dts,
                                        INPUT pcdn-pto-control).
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN getCharField IN h-bocx3842(INPUT "cod-livre-1":U,
                                           OUTPUT c-cod-livre-1).
        END.

        ASSIGN c-cod-livre-1 = SUBSTRING(c-cod-livre-1,6,2).
    END.

    RETURN c-cod-livre-1.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

