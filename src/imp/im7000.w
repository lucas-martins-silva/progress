&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance
                              

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-desp-embarque NO-UNDO LIKE desp-embarque
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-despes-decla-import NO-UNDO LIKE despes-decla-import
       field r-Rowid as rowid
       FIELD desc-tipo AS CHAR format "x(15)".
DEFINE TEMP-TABLE tt-despes-decla-import-aux NO-UNDO LIKE despes-decla-import
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-docto NO-UNDO LIKE duimp-docto
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-docto2 NO-UNDO LIKE duimp-docto
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-docto3 NO-UNDO LIKE duimp-docto
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-docto4 NO-UNDO LIKE duimp-docto
       field num-declaracao as char
       field cod-item-ini as char
       field cod-item-fim as char
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-item NO-UNDO LIKE duimp-item
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-siscomex NO-UNDO LIKE duimp-siscomex
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-histor-decla-import NO-UNDO LIKE histor-decla-import
       field r-rowid as rowid
       index codigo
       num-di-ems
       num-seq
       cdd-siscomex-dts
       r-rowid.
DEFINE TEMP-TABLE tt-histor-decla-import-aux NO-UNDO LIKE histor-decla-import
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-historico-embarque NO-UNDO LIKE historico-embarque
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-historico-embarque-aux NO-UNDO LIKE historico-embarque
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/


{include/i-prgvrs.i IM7000 2.00.00.017} /* 11/08/2026 08:51:58 */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM7000 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM7000
&GLOBAL-DEFINE Version        2.00.00.017

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Principal, Identifica‡Æo, Documentos, Itiner rio, Despesas, Impostos, Impostos 2, Valores

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

&GLOBAL-DEFINE ttTable        tt-duimp-siscomex
&GLOBAL-DEFINE hDBOTable      h-bocx00487
&GLOBAL-DEFINE DBOTable       duimp-siscomex

&GLOBAL-DEFINE ttSon3         tt-duimp-docto
&GLOBAL-DEFINE hDBOSon3       h-bocx00489
&GLOBAL-DEFINE DBOSon3Table   duimp-docto
&GLOBAL-DEFINE DBOSon3Destroy YES

&GLOBAL-DEFINE ttSon4         tt-duimp-docto2
&GLOBAL-DEFINE hDBOSon4       h-bocx00489
&GLOBAL-DEFINE DBOSon4Table   duimp-docto
&GLOBAL-DEFINE DBOSon4Destroy YES

&GLOBAL-DEFINE ttSon5         tt-duimp-docto4
&GLOBAL-DEFINE hDBOSon5       h-bocx00489
&GLOBAL-DEFINE DBOSon5Table   duimp-docto
&GLOBAL-DEFINE DBOSon5Destroy YES

&GLOBAL-DEFINE page3Browse    brSonDocto brSonProc brSonDec
&GLOBAL-DEFINE page4Browse    brHistorico 
&GLOBAL-DEFINE page5Browse    brDespesa
&GLOBAL-DEFINE page6Browse    

&GLOBAL-DEFINE VALUE-CHANGED4 YES
&GLOBAL-DEFINE VALUE-CHANGED5 YES
&GLOBAL-DEFINE VALUE-CHANGED6 YES

&GLOBAL-DEFINE page0KeyFields  tt-duimp-siscomex.cod-duimp-dts
&GLOBAL-DEFINE page0Fields     tt-duimp-siscomex.cod-duimp-siscomex dat-reg-duimp tt-duimp-siscomex.cod-estabel tt-duimp-siscomex.num-versao-duimp 
&GLOBAL-DEFINE page1Fields     cb-tipo-declaracao cb-carac-oper cb-mod-desp fi-cdn-consign fi-cod-despachante c-cod-natur-operac da-dtz-create tt-duimp-siscomex.cod-usuar 
&GLOBAL-DEFINE page2Fields     tt-duimp-siscomex.cdn-importador c-tipo-importador tt-duimp-siscomex.ni-importador tt-duimp-siscomex.end-importador ed-inf-compl ~
                               tt-duimp-siscomex.cdn-urf-despch tg-sitEspDespch lbl-tip-ident-carga cb-motDespch tt-duimp-siscomex.tp-identific-carga tt-duimp-siscomex.cod-identific-carga ~
                               cb-via-transporte tt-duimp-siscomex.cdn-pais tt-duimp-siscomex.des-pais-proced tt-duimp-siscomex.cod-pais-iso de-cod-identific-carga 
&GLOBAL-DEFINE page3Fields     
&GLOBAL-DEFINE page4Fields    rs-tipo-apresentacao  
&GLOBAL-DEFINE page5Fields    rs-apres-despesa 
&GLOBAL-DEFINE page6Fields    label-fcp label-fcp-st label-icms-st label-icms-compl
&GLOBAL-DEFINE page7Fields    v-base-ibsuf
&GLOBAL-DEFINE page8Fields    c-cdn-moed-vmcv

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-retorno                        AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-habilita-bt-conf               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-data-diferente                 AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE c-lbl-duimp-dts                  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-format-id-pessoal              AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-format-id-federal              AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-return                         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ant                LIKE estabelec.cod-estabel NO-UNDO.
DEFINE VARIABLE i-cod-emitente                   LIKE emitente.cod-emitente NO-UNDO.
DEFINE VARIABLE c-cpf-cnpj                       LIKE emitente.cgc NO-UNDO.
DEFINE VARIABLE i-natureza                       LIKE emitente.natureza NO-UNDO.
DEFINE VARIABLE c-end-importador                 LIKE duimp-siscomex.end-importador NO-UNDO.
DEFINE VARIABLE c-formato-cpf                    AS CHARACTER FORMAT "x(19)":U NO-UNDO.
DEFINE VARIABLE c-formato-id-federal             AS CHARACTER FORMAT "x(19)":U NO-UNDO.
DEFINE VARIABLE v-desc-tipo-docto                AS CHARACTER FORMAT "x(20)":U NO-UNDO.
DEFINE VARIABLE l-troca-cor                      AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE c-unid-med                       LIKE ITEM.un NO-UNDO.
DEFINE VARIABLE c-class-fisc                     LIKE ITEM.class-fiscal NO-UNDO.
DEFINE VARIABLE c-desc-item                      LIKE ITEM.descricao-1 NO-UNDO.
DEFINE VARIABLE c-nome-abrev-emit                LIKE emitente.nome-abrev NO-UNDO.
DEFINE VARIABLE iRowsReturned                    AS INTEGER NO-UNDO.
DEFINE VARIABLE r-rowid                          AS ROWID NO-UNDO.
DEFINE VARIABLE r-hist-emb                       AS ROWID                           NO-UNDO.
DEFINE VARIABLE r-desp-emb                       AS ROWID                           NO-UNDO.
DEFINE VARIABLE r-chave                          AS ROWID                           NO-UNDO.
DEFINE VARIABLE c-documento                      LIKE siscomex-tipo-docto.descricao NO-UNDO.
DEFINE VARIABLE c-valores                        AS CHAR NO-UNDO.
DEFINE VARIABLE c-desc-pto-control               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-brw-desc-pto-control           AS character format 'x(40)'        NO-UNDO.
DEFINE VARIABLE c-brw-desc-despes                AS character format 'x(40)'        NO-UNDO.
DEFINE VARIABLE c-brw-nome-abrev                 AS character format 'x(40)'        NO-UNDO.
DEFINE VARIABLE c-brw-desc-pagto                 AS character format 'x(40)'        NO-UNDO.
DEFINE VARIABLE i-diferenca                      AS INTEGER                         NO-UNDO.
DEFINE VARIABLE c-cod-uf                         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE log-perm-pto-control-imp         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-embarq-vinc                    AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-encontrou                      AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-alterando                      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-modificacao                    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-linha-anterior                 AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq-pto-nacionaliz             AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-pto-ant                        AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-itiner                     AS INTEGER     NO-UNDO.
DEFINE VARIABLE rGoTo                            AS ROWID       NO-UNDO.
DEFINE VARIABLE l-tipo-apres                     AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-apres-desp                     AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE i-reg-retornados                 as integer no-undo.
DEFINE VARIABLE rowsreturn                       AS INTEGER                         NO-UNDO.
DEFINE VARIABLE i-pto-nacionalizacao             AS INT                             NO-UNDO.                                                 
DEFINE VARIABLE i-cont                           AS integer NO-UNDO.
DEFINE VARIABLE i-cdn-despes-siscomex            AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cdn-emit-siscomex              AS INTEGER NO-UNDO.
DEFINE VARIABLE l-taxa-siscomex                  AS LOGICAL NO-UNDO.
DEFINE VARIABLE c-lit-trad-emb                   AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE l-rateio                         AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-gera-relat                     AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-calcula-impostos               AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-existe-adic                    AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-rateio-desp-comp               AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-regera-default-impostos        AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-param-ativo                    AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE l-displayFields                  AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE d-val-peso-embal                 LIKE embalag.peso-embal            NO-UNDO.
DEFINE VARIABLE c-nat-operacao                   LIKE natur-oper.nat-operacao       NO-UNDO.
DEFINE VARIABLE h-im0400i                        AS HANDLE                          NO-UNDO.
DEFINE VARIABLE l-nt2024002                      AS LOGICAL                         NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).

DEFINE BUFFER bf-tt-histor-decla-import FOR tt-histor-decla-import.

/*--- Variaveis definidas para que se possa utilizar o zoom 
      feito em Smart Objects ---*/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-window                         AS handle NO-UNDO.

DEFINE BUFFER bfduimp-docto FOR duimp-docto.
/*---------------------------------------------------------------*/

DEFINE TEMP-TABLE tt-duimp-docto-decla NO-UNDO
    FIELD cod-duimp-dts  LIKE duimp-docto.cod-duimp-dts
    FIELD documento      LIKE duimp-docto.documento
    FIELD cod-tipo-docto LIKE duimp-docto.cod-tipo-docto
    FIELD seq-docto      LIKE duimp-docto.seq-docto
    FIELD cod-chave      LIKE duimp-docto.cod-chave
    FIELD num-declaracao LIKE duimp-docto.valor
    FIELD cod-item-ini   LIKE duimp-docto.valor
    FIELD cod-item-fim   LIKE duimp-docto.valor
    FIELD r-rowid        AS ROWID.

DEFINE TEMP-TABLE tt-duimp-docto-aux LIKE tt-duimp-docto.

/* Iniciando Variaveis --- */
{utp/ut-liter.i N£mero_Interno_DUIMP *}
ASSIGN c-lbl-duimp-dts = TRIM(RETURN-VALUE).

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon3}   AS HANDLE NO-UNDO.
//DEFINE VARIABLE {&hDBOSon6}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx402 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx250 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx404 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx403 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx383a AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad098na AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx406 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx110na AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad107     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx401     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin295desc AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad098     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx336     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boun005     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin682     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin172     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-im7000e     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-im0055 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-im7000a     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-im7010      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin245     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx230     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx407     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx110     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx310     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx384     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx095     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad039na   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx3842    AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx230a  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx383   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-im0400e   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-im7000aa  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-im7000f   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-im0400g   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-im7000a1  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-im7000f2  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-im7000f3  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-cd0763    AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boun006   AS HANDLE      NO-UNDO.

{utp/ut-glob.i}
{include/boerrtab.i} /* tt-bo-erro */
{imp/im0400.i} /*Temp Tables - tt-desp-rateio-item*/

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
&Scoped-define INTERNAL-TABLES tt-despes-decla-import ~
tt-histor-decla-import tt-duimp-docto4 tt-duimp-docto tt-duimp-docto2

/* Definitions for BROWSE brDespesa                                     */
&Scoped-define FIELDS-IN-QUERY-brDespesa tt-despes-decla-import.desc-tipo tt-despes-decla-import.cdn-pto-control fnDescricaoPtoControle(tt-despes-decla-import.num-di-ems, tt-despes-decla-import.cdd-siscomex-dts, tt-despes-decla-import.cdn-pto-control) @ c-brw-desc-pto-control tt-despes-decla-import.cdn-despes fnDescDespes(tt-despes-decla-import.cdn-despes, tt-despes-decla-import.num-di-ems, tt-despes-decla-import.cdd-siscomex-dts) @ c-brw-desc-despes tt-despes-decla-import.cdn-emit-despes fnNomeAbrev(tt-despes-decla-import.cdn-emit-despes) @ c-brw-nome-abrev tt-despes-decla-import.cdn-cond-pagto fnDescPagto(tt-despes-decla-import.cdn-cond-pagto) @ c-brw-desc-pagto tt-despes-decla-import.cdn-moed tt-despes-decla-import.val-desp tt-despes-decla-import.val-cotac-despes-compltar tt-despes-decla-import.log-incid-vmle   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDespesa tt-despes-decla-import.desc-tipo VALIDATE(tt-despes-decla-import.desc-tipo = "Nacionaliza‡Æo" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
  tt-despes-decla-import.desc-tipo = "Complementar", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 "Tipo deve ser N ou C") ~
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


/* Definitions for BROWSE brHistorico                                   */
&Scoped-define FIELDS-IN-QUERY-brHistorico tt-histor-decla-import.num-seq tt-histor-decla-import.cdn-pto-control tt-histor-decla-import.descricao tt-histor-decla-import.dat-prev-origin tt-histor-decla-import.dat-ult-prev tt-histor-decla-import.dat-efetiva fnCalculaDiferenca(tt-histor-decla-import.num-seq,tt-histor-decla-import.dat-efetiva) @ i-diferenca tt-histor-decla-import.cod-meio-transp tt-histor-decla-import.nr-dias fnUF(tt-histor-decla-import.num-di-ems, tt-histor-decla-import.cdd-siscomex-dts, tt-histor-decla-import.cdn-pto-control) @ c-cod-uf tt-histor-decla-import.dsl-obs   
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


/* Definitions for BROWSE brSonDec                                      */
&Scoped-define FIELDS-IN-QUERY-brSonDec tt-duimp-docto4.seq-docto tt-duimp-docto4.cod-livre-1 tt-duimp-docto4.num-declaracao tt-duimp-docto4.cod-item-ini tt-duimp-docto4.cod-item-fim   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSonDec   
&Scoped-define SELF-NAME brSonDec
&Scoped-define QUERY-STRING-brSonDec FOR EACH tt-duimp-docto4 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSonDec OPEN QUERY {&SELF-NAME} FOR EACH tt-duimp-docto4 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSonDec tt-duimp-docto4
&Scoped-define FIRST-TABLE-IN-QUERY-brSonDec tt-duimp-docto4


/* Definitions for BROWSE brSonDocto                                    */
&Scoped-define FIELDS-IN-QUERY-brSonDocto tt-duimp-docto.seq-docto ~
fnDocumento(tt-duimp-docto.cod-tipo-docto) @ c-documento ~
tt-duimp-docto.valor 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSonDocto 
&Scoped-define QUERY-STRING-brSonDocto FOR EACH tt-duimp-docto NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSonDocto OPEN QUERY brSonDocto FOR EACH tt-duimp-docto NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSonDocto tt-duimp-docto
&Scoped-define FIRST-TABLE-IN-QUERY-brSonDocto tt-duimp-docto


/* Definitions for BROWSE brSonProc                                     */
&Scoped-define FIELDS-IN-QUERY-brSonProc tt-duimp-docto2.seq-docto fnCodTipoDocto(tt-duimp-docto2.cod-tipo-docto) @ v-desc-tipo-docto tt-duimp-docto2.valor   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSonProc   
&Scoped-define SELF-NAME brSonProc
&Scoped-define QUERY-STRING-brSonProc FOR EACH tt-duimp-docto2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSonProc OPEN QUERY {&SELF-NAME} FOR EACH tt-duimp-docto2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSonProc tt-duimp-docto2
&Scoped-define FIRST-TABLE-IN-QUERY-brSonProc tt-duimp-docto2


/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brSonDec}~
    ~{&OPEN-QUERY-brSonDocto}~
    ~{&OPEN-QUERY-brSonProc}

/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-brHistorico}

/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brDespesa}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-duimp-siscomex.cod-duimp-dts ~
tt-duimp-siscomex.cod-duimp-siscomex tt-duimp-siscomex.cod-estabel ~
tt-duimp-siscomex.num-versao-duimp 
&Scoped-define ENABLED-TABLES tt-duimp-siscomex
&Scoped-define FIRST-ENABLED-TABLE tt-duimp-siscomex
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btConfTrib btCotacaoDi btRateio btVincEmb btItensDuimp ~
bt-gerar-arquivo btDocRelac btQueryJoins btReportsJoins btExit btHelp ~
dat-reg-duimp fi-situacao 
&Scoped-Define DISPLAYED-FIELDS tt-duimp-siscomex.cod-duimp-dts ~
tt-duimp-siscomex.cod-duimp-siscomex tt-duimp-siscomex.cod-estabel ~
tt-duimp-siscomex.num-versao-duimp 
&Scoped-define DISPLAYED-TABLES tt-duimp-siscomex
&Scoped-define FIRST-DISPLAYED-TABLE tt-duimp-siscomex
&Scoped-Define DISPLAYED-OBJECTS dat-reg-duimp cNomeEstab fi-situacao ~
v-base-ibsmun v-susp-ibsmun v-recolhe-ibsmun v-outros-ibsmun v-susp-cbs ~
v-recolhe-cbs v-outros-cbs v-total-susp-trib v-total-recolhe-trib ~
v-total-outros-trib 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCalculaDiferenca wMaintenance 
FUNCTION fnCalculaDiferenca RETURNS INTEGER
( INPUT i-num-seq  AS INTEGER,
  INPUT dt-efetiva AS DATE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnClasFiscItem wMaintenance 
FUNCTION fnClasFiscItem RETURNS CHARACTER
  ( input c-it-codigo as character)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCodTipoDocto wMaintenance 
FUNCTION fnCodTipoDocto RETURNS CHARACTER
  ( input pCodTipoDocto as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescDespes wMaintenance 
FUNCTION fnDescDespes RETURNS CHARACTER
  ( p-cdn-despes AS INT,
    p-num-di-ems AS INT,
    pcdd-siscomex-dts AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wMaintenance 
FUNCTION fnDescItem RETURNS CHARACTER
  ( input c-it-codigo as character)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescPagto wMaintenance 
FUNCTION fnDescPagto RETURNS CHARACTER
( INPUT i-cdn-pagto as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricaoPtoControle wMaintenance 
FUNCTION fnDescricaoPtoControle RETURNS CHARACTER
( input num-di-ems AS int,
  INPUT pcdd-siscomex-dts AS DECIMAL,
  input p-pto-control AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDocumento wMaintenance 
FUNCTION fnDocumento RETURNS CHARACTER
  ( INPUT pCodTipoDocto AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeAbrev wMaintenance 
FUNCTION fnNomeAbrev RETURNS CHARACTER
  ( input i-cod-emitente as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUF wMaintenance 
FUNCTION fnUF RETURNS CHARACTER
  (input pnum-di-ems AS INTEGER,
   INPUT pcdd-siscomex-dts AS DECIMAL,
   input pcdn-pto-control AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnidMedItem wMaintenance 
FUNCTION fnUnidMedItem RETURNS CHARACTER
  ( input c-it-codigo as character)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnValores wMaintenance 
FUNCTION fnValores RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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
DEFINE BUTTON bt-gerar-arquivo 
     IMAGE-UP FILE "image/im-grava.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-grava.bmp":U
     LABEL "Gerar Arquivo Siscomex" 
     SIZE 4 BY 1.25 TOOLTIP "Gerar Arquivo".

DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
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

DEFINE BUTTON btItensDuimp 
     IMAGE-UP FILE "image/im-carga.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-carga.bmp":U
     LABEL "Itens" 
     SIZE 4 BY 1.25 TOOLTIP "Itens DUIMP"
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

DEFINE VARIABLE cNomeEstab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE dat-reg-duimp AS DATE FORMAT "99/99/9999":U 
     LABEL "Registro Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-situacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 48.86 BY .88 NO-UNDO.

DEFINE VARIABLE v-base-ibsmun AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-cbs AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-outros-ibsmun AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-cbs AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-recolhe-ibsmun AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-cbs AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-susp-ibsmun AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-total-outros-trib AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-total-recolhe-trib AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE v-total-susp-trib AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102.57 BY 3.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 103.72 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btObservacao 
     LABEL "Observa‡Æo" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-carac-oper AS CHARACTER FORMAT "X(256)":U 
     LABEL "Caracter¡stica Opera‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-mod-desp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Modalidade Despacho" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-declaracao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Declara‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 51 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-natur-operac AS CHARACTER FORMAT "X(6)":U 
     LABEL "Natureza Opera‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-nat-operacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev-desp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE cNomeUsuar AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE da-dtz-create AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Cria‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cdn-consign AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Consignat rio" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-despachante AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Despachante" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-itens AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "N£mero Itens" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98.29 BY 1.33.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98.29 BY 5.83.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98.29 BY 4.63.

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

DEFINE VARIABLE cb-motDespch AS CHARACTER FORMAT "X(256)":U 
     LABEL "Motivo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 58.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-via-transporte AS CHARACTER FORMAT "X(256)":U 
     LABEL "Via Transporte"
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE ed-inf-compl AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 500 SCROLLBAR-VERTICAL
     SIZE 68.86 BY 2.5 TOOLTIP "Info. Complementares" NO-UNDO.

DEFINE VARIABLE c-nome-importador AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-importador AS CHARACTER FORMAT "X(20)":U 
     LABEL "Tipo Importador" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE cNomeUnidDespch AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE de-cod-identific-carga AS DECIMAL FORMAT ">>>>>>>>>>>>>>9":U INITIAL 0 
     LABEL "Identifica‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE lbl-inf-compl AS CHARACTER FORMAT "X(256)":U INITIAL "Info. Complementares:" 
      VIEW-AS TEXT 
     SIZE 15 BY .67 NO-UNDO.

DEFINE VARIABLE lbl-tip-ident-carga AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo de Identifica‡Æo:" 
      VIEW-AS TEXT 
     SIZE 15 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-97
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98.29 BY 7.29.

DEFINE RECTANGLE RECT-99
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98.29 BY 6.13.

DEFINE VARIABLE tg-sitEspDespch AS LOGICAL INITIAL no 
     LABEL "Situa‡Æo Especial de Despacho" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY 1 NO-UNDO.

DEFINE BUTTON btAddDec 
     LABEL "Incluir" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btAddDocto 
     LABEL "Incluir" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btAddProc 
     LABEL "Incluir" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btDelDec 
     LABEL "Eliminar" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btDelDocto 
     LABEL "Eliminar" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btDelProc 
     LABEL "Eliminar" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btModDec 
     LABEL "Modificar" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btModDocto 
     LABEL "Modificar" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btModProc 
     LABEL "Modificar" 
     SIZE 10 BY 1
     FONT 1.

DEFINE RECTANGLE RECT-104
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 6.5 TOOLTIP "Processo/Dossiˆ".

DEFINE RECTANGLE RECT-105
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 6.5.

DEFINE RECTANGLE RECT-98
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98.29 BY 6.88.

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
     SIZE 10 BY 1.

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

DEFINE BUTTON btDeleteSon2 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

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
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-emb-desp AS CHARACTER FORMAT "x(16)" 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE rs-apres-despesa AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "DI", 1,
"Embarque", 2
     SIZE 14.72 BY .75 TOOLTIP "Tipo Apresenta‡Æo" NO-UNDO.

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

DEFINE RECTANGLE RECT-108
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98.29 BY 13.5.

DEFINE VARIABLE v-base-cbs AS DECIMAL FORMAT "->>>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

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

DEFINE QUERY brHistorico FOR 
      tt-histor-decla-import SCROLLING.

DEFINE QUERY brSonDec FOR 
      tt-duimp-docto4 SCROLLING.

DEFINE QUERY brSonDocto FOR 
      tt-duimp-docto SCROLLING.

DEFINE QUERY brSonProc FOR 
      tt-duimp-docto2 SCROLLING.
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
        tt-despes-decla-import.desc-tipo HELP "N-Nacionaliza‡Æo C-Complementar" VALIDATE(tt-despes-decla-import.desc-tipo = "Nacionaliza‡Æo" OR 
                                                                                         tt-despes-decla-import.desc-tipo = "Complementar",
                                                                                        "Tipo deve ser N ou C")
        tt-despes-decla-import.cdn-despes 
        tt-despes-decla-import.cdn-emit-despes 
        tt-despes-decla-import.cdn-cond-pagto 
        tt-despes-decla-import.cdn-moed 
        tt-despes-decla-import.val-desp
        tt-despes-decla-import.val-cotac-despes-compltar
        tt-despes-decla-import.log-incid-vmle
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 93 BY 7.92
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brHistorico wMaintenance _FREEFORM
  QUERY brHistorico NO-LOCK DISPLAY
      tt-histor-decla-import.num-seq         FORMAT ">>9":U
      tt-histor-decla-import.cdn-pto-control FORMAT ">>,>>9":U
      tt-histor-decla-import.descricao
      tt-histor-decla-import.dat-prev-origin FORMAT "99/99/9999":U
      tt-histor-decla-import.dat-ult-prev    FORMAT "99/99/9999":U
      tt-histor-decla-import.dat-efetiva     FORMAT "99/99/9999":U
      fnCalculaDiferenca(tt-histor-decla-import.num-seq,tt-histor-decla-import.dat-efetiva) @ i-diferenca COLUMN-LABEL "Diferen‡a" WIDTH 8
      tt-histor-decla-import.cod-meio-transp FORMAT "x(20)":U
      tt-histor-decla-import.nr-dias
      fnUF(tt-histor-decla-import.num-di-ems, tt-histor-decla-import.cdd-siscomex-dts, tt-histor-decla-import.cdn-pto-control) @ c-cod-uf FORMAT "x(04)":U COLUMN-LABEL "UF":U
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
    WITH NO-ROW-MARKERS SEPARATORS SIZE 93 BY 7.92
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE brSonDec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSonDec wMaintenance _FREEFORM
  QUERY brSonDec NO-LOCK DISPLAY
      tt-duimp-docto4.seq-docto COLUMN-LABEL "Seq" FORMAT ">>>>9":U
            WIDTH 6
      tt-duimp-docto4.cod-livre-1 COLUMN-LABEL "Pa¡s Procedˆncia" FORMAT "x(20)":U WIDTH 25
      tt-duimp-docto4.num-declaracao COLUMN-LABEL "N£mero da Declara‡Æo" FORMAT "x(70)":U
      tt-duimp-docto4.cod-item-ini COLUMN-LABEL "In¡cio" FORMAT "x(16)":U
      tt-duimp-docto4.cod-item-fim COLUMN-LABEL "Fim" FORMAT "x(16)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 47.29 BY 4.79
         FONT 1.

DEFINE BROWSE brSonDocto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSonDocto wMaintenance _STRUCTURED
  QUERY brSonDocto NO-LOCK DISPLAY
      tt-duimp-docto.seq-docto COLUMN-LABEL "Seq" FORMAT ">>>>9":U
            WIDTH 3
      fnDocumento(tt-duimp-docto.cod-tipo-docto) @ c-documento COLUMN-LABEL "Documento" FORMAT "x(90)":U
            WIDTH 40
      tt-duimp-docto.valor COLUMN-LABEL "Valores" FORMAT "x(500)":U
            WIDTH 500
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 96.14 BY 5.54
         FONT 1.

DEFINE BROWSE brSonProc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSonProc wMaintenance _FREEFORM
  QUERY brSonProc NO-LOCK DISPLAY
      tt-duimp-docto2.seq-docto COLUMN-LABEL "Seq" FORMAT ">>>>9":U
            WIDTH 6
      fnCodTipoDocto(tt-duimp-docto2.cod-tipo-docto) @ v-desc-tipo-docto COLUMN-LABEL "Tipo de Processo/Dossiˆ" FORMAT "x(20)":U      
      tt-duimp-docto2.valor COLUMN-LABEL "Processo/Dossiˆ" FORMAT "x(17)":U WIDTH 20
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 47.29 BY 4.79
         FONT 1.


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
     btAdd AT ROW 1.13 COL 25.57 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 29.57 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 33.57 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 37.57 HELP
          "Elimina ocorrˆncia corrente"
     btUndo AT ROW 1.13 COL 41.57 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 45.57 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 49.57 HELP
          "Confirma altera‡äes"
     btConfTrib AT ROW 1.13 COL 58.96 HELP
          "Confirma altera‡äes" WIDGET-ID 2
     btCotacaoDi AT ROW 1.13 COL 63 HELP
          "Confirma altera‡äes" WIDGET-ID 58
     btRateio AT ROW 1.13 COL 67.14 HELP
          "Confirma altera‡äes" WIDGET-ID 60
     btVincEmb AT ROW 1.13 COL 71.29 HELP
          "Confirma altera‡äes" WIDGET-ID 56
     btItensDuimp AT ROW 1.13 COL 75.43 WIDGET-ID 62
     bt-gerar-arquivo AT ROW 1.13 COL 79.57 WIDGET-ID 52
     btDocRelac AT ROW 1.13 COL 83.72 HELP
          "Confirma altera‡äes" WIDGET-ID 272
     btQueryJoins AT ROW 1.13 COL 87.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 92 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 96.14 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 100.29 HELP
          "Ajuda"
     tt-duimp-siscomex.cod-duimp-dts AT ROW 2.83 COL 17 COLON-ALIGNED WIDGET-ID 26
          LABEL "N£mero Interno DUIMP"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-duimp-siscomex.cod-duimp-siscomex AT ROW 2.83 COL 49.86 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     dat-reg-duimp AT ROW 2.83 COL 81.29 COLON-ALIGNED WIDGET-ID 48
     tt-duimp-siscomex.cod-estabel AT ROW 3.83 COL 17 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cNomeEstab AT ROW 3.83 COL 24.43 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     tt-duimp-siscomex.num-versao-duimp AT ROW 3.83 COL 81.29 COLON-ALIGNED WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-situacao AT ROW 4.83 COL 17 COLON-ALIGNED WIDGET-ID 44
     v-base-ibsmun AT ROW 10.38 COL 16.29 COLON-ALIGNED NO-LABEL WIDGET-ID 264
     v-susp-ibsmun AT ROW 10.38 COL 34.57 COLON-ALIGNED NO-LABEL WIDGET-ID 266
     v-recolhe-ibsmun AT ROW 10.38 COL 52.86 COLON-ALIGNED NO-LABEL WIDGET-ID 270
     v-outros-ibsmun AT ROW 10.38 COL 71.14 COLON-ALIGNED NO-LABEL WIDGET-ID 268
     v-susp-cbs AT ROW 11.38 COL 34.57 COLON-ALIGNED NO-LABEL WIDGET-ID 250
     v-recolhe-cbs AT ROW 11.38 COL 52.86 COLON-ALIGNED NO-LABEL WIDGET-ID 244
     v-outros-cbs AT ROW 11.38 COL 71.14 COLON-ALIGNED NO-LABEL WIDGET-ID 238
     v-total-susp-trib AT ROW 12.88 COL 34.57 COLON-ALIGNED NO-LABEL WIDGET-ID 260
     v-total-recolhe-trib AT ROW 12.88 COL 52.86 COLON-ALIGNED NO-LABEL WIDGET-ID 258
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 103.76 BY 21.33
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     v-total-outros-trib AT ROW 12.88 COL 71.14 COLON-ALIGNED NO-LABEL WIDGET-ID 256
     "IBS Mun" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 10.5 COL 10 WIDGET-ID 262
     "Total" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 13.04 COL 10 WIDGET-ID 224
     "CBS" VIEW-AS TEXT
          SIZE 5.29 BY .54 AT ROW 11.5 COL 10 WIDGET-ID 216
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 103.76 BY 21.33
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage8
     c-cdn-moed-vmcv AT ROW 2.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto" WIDGET-ID 14
     d-val-vmcv-me AT ROW 2.25 COL 42 COLON-ALIGNED HELP
          "Valor Mercadoria na Condi‡Æo Venda" NO-LABEL WIDGET-ID 46
     d-val-vmcv AT ROW 2.25 COL 59 COLON-ALIGNED HELP
          "Valor Mercadoria na Condi‡Æo Venda" NO-LABEL WIDGET-ID 44
     c-cdn-moed-vmle AT ROW 3.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto" WIDGET-ID 18
     d-val-vmle-me AT ROW 3.25 COL 42 COLON-ALIGNED HELP
          "Valor VMLE" NO-LABEL WIDGET-ID 54
     d-val-vmle AT ROW 3.25 COL 59 COLON-ALIGNED HELP
          "Valor VMLE" NO-LABEL WIDGET-ID 52
     c-cdn-moed-vmld AT ROW 4.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto" WIDGET-ID 16
     d-val-vmld-me AT ROW 4.25 COL 42 COLON-ALIGNED HELP
          "Valor mercadoria no local despacho" NO-LABEL WIDGET-ID 50
     d-val-vmld AT ROW 4.25 COL 59 COLON-ALIGNED HELP
          "Valor mercadoria no local despacho" NO-LABEL WIDGET-ID 48
     c-cdn-moed-frete AT ROW 5.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto" WIDGET-ID 4
     d-val-frete-me AT ROW 5.25 COL 42 COLON-ALIGNED HELP
          "Informe o valor do frete" NO-LABEL WIDGET-ID 38
     d-val-frete AT ROW 5.25 COL 59 COLON-ALIGNED HELP
          "Informe o valor do frete" NO-LABEL WIDGET-ID 36
     c-cdn-moed-seguro AT ROW 6.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto" WIDGET-ID 6
     d-val-seguro-me AT ROW 6.25 COL 42 COLON-ALIGNED HELP
          "Valor do seguro" NO-LABEL WIDGET-ID 42
     d-val-seguro AT ROW 6.25 COL 59.14 COLON-ALIGNED HELP
          "Valor do seguro" NO-LABEL WIDGET-ID 40
     c-cdn-moed-acresc AT ROW 7.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto" WIDGET-ID 2
     d-val-acresc-me AT ROW 7.25 COL 42 COLON-ALIGNED HELP
          "Valor Acr‚scimo" NO-LABEL WIDGET-ID 34
     d-val-acresc AT ROW 7.25 COL 59.14 COLON-ALIGNED HELP
          "Valor Acr‚scimo" NO-LABEL WIDGET-ID 32
     c-cdn-moed-tot-desp-nac AT ROW 8.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto" WIDGET-ID 12
     d-tot-val-desp-nacion-me AT ROW 8.25 COL 42 COLON-ALIGNED HELP
          "Valor Acr‚scimos" NO-LABEL WIDGET-ID 30
     d-tot-val-desp-nacion AT ROW 8.25 COL 59 COLON-ALIGNED HELP
          "Valor Acr‚scimos" NO-LABEL WIDGET-ID 28
     c-cdn-moed-tot-desp-compl AT ROW 9.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto" WIDGET-ID 8
     d-tot-val-desp-compl-me AT ROW 9.25 COL 42 COLON-ALIGNED HELP
          "Valor Acr‚scimos" NO-LABEL WIDGET-ID 22
     d-tot-val-desp-compl AT ROW 9.25 COL 59 COLON-ALIGNED HELP
          "Valor Acr‚scimos" NO-LABEL WIDGET-ID 20
     c-cdn-moed-tot-desp-di AT ROW 10.25 COL 25 COLON-ALIGNED HELP
          "Codigo da moeda do produto" WIDGET-ID 10
     d-tot-val-desp-di-me AT ROW 10.25 COL 42 COLON-ALIGNED HELP
          "Valor Acr‚scimos" NO-LABEL WIDGET-ID 26
     d-tot-val-desp-di AT ROW 10.25 COL 59 COLON-ALIGNED HELP
          "Valor Acr‚scimos" NO-LABEL WIDGET-ID 24
     "Reais (R$)" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.5 COL 70 WIDGET-ID 58
     "Moeda" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.5 COL 38 WIDGET-ID 56
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 7.3
         SIZE 100 BY 14
         FONT 1 WIDGET-ID 800.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage8
     "Valor" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.5 COL 56 WIDGET-ID 60
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 7.3
         SIZE 100 BY 14
         FONT 1 WIDGET-ID 800.

DEFINE FRAME fPage7
     v-base-ibsuf AT ROW 3.04 COL 14.29 COLON-ALIGNED NO-LABEL WIDGET-ID 302
     v-susp-ibsuf AT ROW 3.04 COL 32.57 COLON-ALIGNED NO-LABEL WIDGET-ID 314
     v-recolhe-ibsuf AT ROW 3.04 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 310
     v-outros-ibsuf AT ROW 3.04 COL 69.14 COLON-ALIGNED NO-LABEL WIDGET-ID 306
     v-base-ibsmun AT ROW 4 COL 14.29 COLON-ALIGNED NO-LABEL WIDGET-ID 264 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     v-susp-ibsmun AT ROW 4 COL 32.57 COLON-ALIGNED NO-LABEL WIDGET-ID 266 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     v-recolhe-ibsmun AT ROW 4 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 270 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     v-outros-ibsmun AT ROW 4 COL 69.14 COLON-ALIGNED NO-LABEL WIDGET-ID 268 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     v-base-cbs AT ROW 5 COL 14.29 COLON-ALIGNED NO-LABEL WIDGET-ID 324
     v-susp-cbs AT ROW 5 COL 32.57 COLON-ALIGNED NO-LABEL WIDGET-ID 250 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     v-recolhe-cbs AT ROW 5 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 244 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     v-outros-cbs AT ROW 5 COL 69.14 COLON-ALIGNED NO-LABEL WIDGET-ID 238 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     v-base-is AT ROW 6 COL 14.29 COLON-ALIGNED NO-LABEL WIDGET-ID 328
     v-susp-is AT ROW 6 COL 32.57 COLON-ALIGNED NO-LABEL WIDGET-ID 330
     v-recolhe-is AT ROW 6 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 332
     v-outros-is AT ROW 6 COL 69.14 COLON-ALIGNED NO-LABEL WIDGET-ID 334
     v-total-susp-trib AT ROW 7.33 COL 32.57 COLON-ALIGNED NO-LABEL WIDGET-ID 260 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     v-total-recolhe-trib AT ROW 7.33 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 258 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     v-total-outros-trib AT ROW 7.33 COL 69.14 COLON-ALIGNED NO-LABEL WIDGET-ID 256 FORMAT "->>>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     "Outros" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 2 COL 76 WIDGET-ID 298
     "Imposto" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 2 COL 8.14 WIDGET-ID 296
     "IBS UF" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 3.17 COL 8 WIDGET-ID 290
     "Base C lculo" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 2 COL 20.14 WIDGET-ID 286
     "IS" VIEW-AS TEXT
          SIZE 5.29 BY .54 AT ROW 6.13 COL 8 WIDGET-ID 326
     "Suspenso" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 2 COL 39.72 WIDGET-ID 322
     "Total" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 7.5 COL 8 WIDGET-ID 224
     "CBS" VIEW-AS TEXT
          SIZE 5.29 BY .54 AT ROW 5.13 COL 8 WIDGET-ID 216
     "IBS Mun" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 4.13 COL 8 WIDGET-ID 262
     "A Recolher" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 2 COL 57 WIDGET-ID 288
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 7.3
         SIZE 100 BY 14
         FONT 1 WIDGET-ID 1100.

DEFINE FRAME fPage6
     v-base-II AT ROW 2.46 COL 13 COLON-ALIGNED NO-LABEL WIDGET-ID 242
     v-susp-ii AT ROW 2.46 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 272
     v-recolhe-ii AT ROW 2.46 COL 49.57 COLON-ALIGNED NO-LABEL WIDGET-ID 262
     v-outros-ii AT ROW 2.46 COL 67.86 COLON-ALIGNED NO-LABEL WIDGET-ID 252
     v-base-ipi AT ROW 3.46 COL 13 COLON-ALIGNED NO-LABEL WIDGET-ID 244
     v-susp-ipi AT ROW 3.46 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 274
     v-recolhe-ipi AT ROW 3.46 COL 49.57 COLON-ALIGNED NO-LABEL WIDGET-ID 264
     v-outros-ipi AT ROW 3.46 COL 67.86 COLON-ALIGNED NO-LABEL WIDGET-ID 254
     v-base-pis AT ROW 4.46 COL 13 COLON-ALIGNED NO-LABEL WIDGET-ID 246
     v-susp-pis AT ROW 4.46 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 276
     v-recolhe-pis AT ROW 4.46 COL 49.57 COLON-ALIGNED NO-LABEL WIDGET-ID 266
     v-outros-pis AT ROW 4.46 COL 67.86 COLON-ALIGNED NO-LABEL WIDGET-ID 256
     v-base-cofins AT ROW 5.46 COL 13 COLON-ALIGNED NO-LABEL WIDGET-ID 238
     v-susp-cofins AT ROW 5.46 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 268
     v-recolhe-cofins AT ROW 5.46 COL 49.57 COLON-ALIGNED NO-LABEL WIDGET-ID 258
     v-outros-cofins AT ROW 5.46 COL 67.86 COLON-ALIGNED NO-LABEL WIDGET-ID 248
     v-base-icms AT ROW 6.46 COL 13 COLON-ALIGNED NO-LABEL WIDGET-ID 240
     v-susp-icms AT ROW 6.46 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 270
     v-recolhe-icms AT ROW 6.46 COL 49.57 COLON-ALIGNED NO-LABEL WIDGET-ID 260
     v-outros-icms AT ROW 6.46 COL 67.86 COLON-ALIGNED NO-LABEL WIDGET-ID 250
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
     v-total-suspenso AT ROW 11.75 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 282
     v-total-recolhe AT ROW 11.75 COL 49.57 COLON-ALIGNED NO-LABEL WIDGET-ID 280
     v-total-outros AT ROW 11.75 COL 67.86 COLON-ALIGNED NO-LABEL WIDGET-ID 278
     label-fcp AT ROW 7.46 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 174
     label-fcp-st AT ROW 8.46 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 176
     label-icms-st AT ROW 9.46 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 180
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 7.3
         SIZE 100 BY 14
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage6
     label-icms-compl AT ROW 10.46 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 178
     "ICMS" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 6.46 COL 5 WIDGET-ID 222
     "Suspenso" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.46 COL 38.57 WIDGET-ID 220
     "COFINS" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 5.46 COL 5 WIDGET-ID 216
     "Outros" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.46 COL 74.86 WIDGET-ID 224
     "PIS/PASEP" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 4.46 COL 5 WIDGET-ID 232
     "Total" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 11.75 COL 5 WIDGET-ID 218
     "II" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 2.46 COL 5 WIDGET-ID 226
     "Base C lculo" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 1.46 COL 19 WIDGET-ID 236
     "IPI" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3.46 COL 5 WIDGET-ID 234
     "A Recolher" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1.46 COL 55.86 WIDGET-ID 230
     "Imposto" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.46 COL 5 WIDGET-ID 228
     RECT-108 AT ROW 1.21 COL 1.86 WIDGET-ID 284
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 7.3
         SIZE 100 BY 14
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage5
     btAtualizaEmb-desp AT ROW 1 COL 55 HELP
          "Confirma altera‡äes" WIDGET-ID 60
     rs-apres-despesa AT ROW 1.25 COL 2 NO-LABEL WIDGET-ID 70
     c-cod-emb-desp AT ROW 1.25 COL 35 COLON-ALIGNED HELP
          "C¢digo Embarque" WIDGET-ID 68
     brDespesa AT ROW 2.29 COL 2 WIDGET-ID 1000
     btAddDespesa AT ROW 2.33 COL 96 HELP
          "Confirma altera‡äes" WIDGET-ID 80
     btUpdateDespesa AT ROW 3.54 COL 96 HELP
          "Confirma altera‡äes" WIDGET-ID 66
     btCanDespesa AT ROW 4.75 COL 96 HELP
          "Confirma altera‡äes" WIDGET-ID 62
     btSaveDespesa AT ROW 5.96 COL 96 HELP
          "Confirma altera‡äes" WIDGET-ID 64
     btAddSon2 AT ROW 10.5 COL 2 WIDGET-ID 74
     btUpdateSon2 AT ROW 10.5 COL 12.14 WIDGET-ID 78
     btDeleteSon2 AT ROW 10.5 COL 22.29 WIDGET-ID 76
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 7.3
         SIZE 100 BY 14
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     i-cdn-pto-nacionaliz AT ROW 1.21 COL 15.14 COLON-ALIGNED HELP
          "C¢digo - Num‚rico Ponto Nacionaliza‡Æo" WIDGET-ID 52
     c-desc-ponto-nacionaliz AT ROW 1.21 COL 22.29 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     c-cod-embarq AT ROW 1.21 COL 68 COLON-ALIGNED HELP
          "C¢digo Embarque" WIDGET-ID 48
     rs-tipo-apresentacao AT ROW 1.25 COL 46.86 NO-LABEL WIDGET-ID 60
     btAtualizaEmb AT ROW 1 COL 96 HELP
          "Confirma altera‡äes" WIDGET-ID 64
     btn-efetiva AT ROW 2.25 COL 96 WIDGET-ID 38
     btn-muda-sequencia AT ROW 3.46 COL 96 WIDGET-ID 40
     btAddHistorico AT ROW 4.67 COL 96 HELP
          "Confirma altera‡äes" WIDGET-ID 28
     btUpdateHistorico AT ROW 5.88 COL 96 HELP
          "Confirma altera‡äes" WIDGET-ID 44
     btCanHistorico AT ROW 7.08 COL 96 HELP
          "Confirma altera‡äes" WIDGET-ID 34
     btSaveHistorico AT ROW 8.29 COL 96 HELP
          "Confirma altera‡äes" WIDGET-ID 42
     btAddSon1 AT ROW 10.38 COL 2.14 WIDGET-ID 30
     btUpdateSon1 AT ROW 10.38 COL 12.14 WIDGET-ID 46
     btDeleteSon1 AT ROW 10.38 COL 22.14 WIDGET-ID 36
     brHistorico AT ROW 2.25 COL 2 WIDGET-ID 900
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 7.3
         SIZE 100 BY 14
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     brSonDocto AT ROW 1.29 COL 3 WIDGET-ID 200
     btAddDocto AT ROW 6.83 COL 2.86 WIDGET-ID 54
     btModDocto AT ROW 6.83 COL 12.86 WIDGET-ID 58
     btDelDocto AT ROW 6.83 COL 22.86 WIDGET-ID 56
     brSonProc AT ROW 8.75 COL 2.57 WIDGET-ID 300
     brSonDec AT ROW 8.75 COL 51.86 WIDGET-ID 400
     btAddProc AT ROW 13.54 COL 2.43 WIDGET-ID 60
     btModProc AT ROW 13.54 COL 12.43 WIDGET-ID 64
     btDelProc AT ROW 13.54 COL 22.43 WIDGET-ID 62
     btAddDec AT ROW 13.54 COL 51.72 WIDGET-ID 14
     btModDec AT ROW 13.54 COL 61.72 WIDGET-ID 16
     btDelDec AT ROW 13.54 COL 71.72 WIDGET-ID 18
     "Processo/Dossiˆ" VIEW-AS TEXT
          SIZE 13 BY .67 AT ROW 7.96 COL 2.86 WIDGET-ID 22
          FONT 1
     "Declara‡Æo Exporta‡Æo Estrangeira" VIEW-AS TEXT
          SIZE 24.86 BY .67 AT ROW 7.96 COL 52.29 WIDGET-ID 26
          FONT 1
     RECT-104 AT ROW 8.25 COL 1.72 WIDGET-ID 20
     RECT-105 AT ROW 8.25 COL 51 WIDGET-ID 24
     RECT-98 AT ROW 1.13 COL 2 WIDGET-ID 66
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 7.3
         SIZE 100 BY 14
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     tt-duimp-siscomex.cdn-importador AT ROW 1.5 COL 18.43 COLON-ALIGNED WIDGET-ID 74
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-nome-importador AT ROW 1.5 COL 28.86 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     c-tipo-importador AT ROW 2.5 COL 18.43 COLON-ALIGNED WIDGET-ID 72
     tt-duimp-siscomex.ni-importador AT ROW 2.5 COL 59.57 COLON-ALIGNED WIDGET-ID 80
          VIEW-AS FILL-IN 
          SIZE 27.86 BY .88
     tt-duimp-siscomex.end-importador AT ROW 3.5 COL 18.43 COLON-ALIGNED WIDGET-ID 78
          VIEW-AS FILL-IN 
          SIZE 69 BY .88
     ed-inf-compl AT ROW 4.5 COL 20.43 NO-LABEL WIDGET-ID 76
     cb-via-transporte AT ROW 7.71 COL 18.43 COLON-ALIGNED WIDGET-ID 120
     tt-duimp-siscomex.cdn-urf-despch AT ROW 8.71 COL 18.43 COLON-ALIGNED WIDGET-ID 50
          LABEL "Unidade Despacho"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cNomeUnidDespch AT ROW 8.71 COL 26.86 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     tg-sitEspDespch AT ROW 9.67 COL 20.57 WIDGET-ID 22
     cb-motDespch AT ROW 10.71 COL 18.43 COLON-ALIGNED WIDGET-ID 28
     tt-duimp-siscomex.tp-identific-carga AT ROW 11.71 COL 20.57 NO-LABEL WIDGET-ID 18
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "CE", 1,
"RUC", 2
          SIZE 20 BY 1
     tt-duimp-siscomex.cod-identific-carga AT ROW 11.71 COL 49.29 COLON-ALIGNED WIDGET-ID 118
          LABEL "Identifica‡Æo"
          VIEW-AS FILL-IN 
          SIZE 34 BY .88
     de-cod-identific-carga AT ROW 11.71 COL 49.29 COLON-ALIGNED WIDGET-ID 110
     tt-duimp-siscomex.cdn-pais AT ROW 12.71 COL 18.43 COLON-ALIGNED WIDGET-ID 112
          LABEL "Pa¡s Procedˆncia"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-duimp-siscomex.des-pais-proced AT ROW 12.71 COL 27.86 NO-LABEL WIDGET-ID 116
          VIEW-AS FILL-IN 
          SIZE 32.57 BY .88
     tt-duimp-siscomex.cod-pais-iso AT ROW 12.71 COL 70.29 COLON-ALIGNED WIDGET-ID 114
          LABEL "Pa¡s ISO"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     lbl-inf-compl AT ROW 4.58 COL 5 NO-LABEL WIDGET-ID 68
     lbl-tip-ident-carga AT ROW 11.88 COL 3.14 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     RECT-97 AT ROW 7.42 COL 1.86 WIDGET-ID 2
     RECT-99 AT ROW 1.17 COL 1.86 WIDGET-ID 82
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 7.3
         SIZE 100 BY 14
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     cb-tipo-declaracao AT ROW 1.38 COL 18.43 COLON-ALIGNED WIDGET-ID 56
     cb-mod-desp AT ROW 2.83 COL 18.43 COLON-ALIGNED WIDGET-ID 50
     cb-carac-oper AT ROW 3.83 COL 18.43 COLON-ALIGNED WIDGET-ID 48
     fi-cdn-consign AT ROW 4.83 COL 18.43 COLON-ALIGNED WIDGET-ID 74
     c-nome-abrev AT ROW 4.83 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     fi-cod-despachante AT ROW 5.83 COL 18.43 COLON-ALIGNED WIDGET-ID 58
     c-nome-abrev-desp AT ROW 5.83 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     c-cod-natur-operac AT ROW 6.83 COL 18.43 COLON-ALIGNED WIDGET-ID 40
     c-des-nat-operacao AT ROW 6.83 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     i-num-itens AT ROW 8.92 COL 18.43 COLON-ALIGNED WIDGET-ID 60
     tt-duimp-siscomex.cod-usuar AT ROW 9.92 COL 18.43 COLON-ALIGNED WIDGET-ID 64
          LABEL "Usu rio Respons vel"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     cNomeUsuar AT ROW 9.92 COL 32.86 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     da-dtz-create AT ROW 9.92 COL 77 COLON-ALIGNED WIDGET-ID 66
     btObservacao AT ROW 11.21 COL 3.29 WIDGET-ID 38
     cb-rateio-desp-nacio AT ROW 11.25 COL 14.86 WIDGET-ID 54
     cb-rateio-desp-comp AT ROW 11.25 COL 42.29 WIDGET-ID 52
     cb-calculo-impostos AT ROW 11.25 COL 69.57 WIDGET-ID 46
     RECT-1 AT ROW 1.17 COL 2 WIDGET-ID 28
     RECT-2 AT ROW 2.67 COL 2 WIDGET-ID 30
     RECT-5 AT ROW 8.63 COL 2 WIDGET-ID 36
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 7.3
         SIZE 100 BY 14
         FONT 1 WIDGET-ID 600.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decla-import T "?" NO-UNDO mgcex decla-import
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-desp-embarque T "?" NO-UNDO mgcex desp-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-despes-decla-import T "?" NO-UNDO mgcex despes-decla-import
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
          FIELD desc-tipo AS CHAR format "x(15)"
      END-FIELDS.
      TABLE: tt-despes-decla-import-aux T "?" NO-UNDO mgcex despes-decla-import
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-duimp-docto T "?" NO-UNDO mgcex duimp-docto
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-duimp-docto2 T "?" NO-UNDO mgcex duimp-docto
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-duimp-docto3 T "?" NO-UNDO mgcex duimp-docto
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-duimp-docto4 T "?" NO-UNDO mgcex duimp-docto
      ADDITIONAL-FIELDS:
          field num-declaracao as char
          field cod-item-ini as char
          field cod-item-fim as char
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-duimp-item T "?" NO-UNDO mgcex duimp-item
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-duimp-siscomex T "?" NO-UNDO mgcex duimp-siscomex
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-histor-decla-import T "?" NO-UNDO mgcex histor-decla-import
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          index codigo
          num-di-ems
          num-seq
          cdd-siscomex-dts
          r-rowid
      END-FIELDS.
      TABLE: tt-histor-decla-import-aux T "?" NO-UNDO mgcex histor-decla-import
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-historico-embarque T "?" NO-UNDO mgcex historico-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-historico-embarque-aux T "?" NO-UNDO mgcex historico-embarque
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
         HEIGHT             = 20.33
         WIDTH              = 103.57
         MAX-HEIGHT         = 40.5
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 40.5
         VIRTUAL-WIDTH      = 274.29
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
/* SETTINGS FOR FILL-IN cNomeEstab IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-siscomex.cod-duimp-dts IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN v-base-ibsmun IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-cbs IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-outros-ibsmun IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-cbs IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-recolhe-ibsmun IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-cbs IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-susp-ibsmun IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-outros-trib IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-recolhe-trib IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-total-susp-trib IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN cNomeUsuar IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-siscomex.cod-usuar IN FRAME fPage1
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN da-dtz-create IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN tt-duimp-siscomex.cdn-pais IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-siscomex.cdn-urf-despch IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cNomeUnidDespch IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-siscomex.cod-identific-carga IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-siscomex.cod-pais-iso IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-siscomex.des-pais-proced IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN lbl-inf-compl IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN lbl-tip-ident-carga IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brSonDocto RECT-98 fPage3 */
/* BROWSE-TAB brSonProc btDelDocto fPage3 */
/* BROWSE-TAB brSonDec brSonProc fPage3 */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* BROWSE-TAB brHistorico btDeleteSon1 fPage4 */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDespesa c-cod-emb-desp fPage5 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brHistorico
/* Query rebuild information for BROWSE brHistorico
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-histor-decla-import NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brHistorico */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSonDec
/* Query rebuild information for BROWSE brSonDec
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-duimp-docto4 NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSonDec */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSonDocto
/* Query rebuild information for BROWSE brSonDocto
     _TblList          = "Temp-Tables.tt-duimp-docto"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-duimp-docto.seq-docto
"tt-duimp-docto.seq-docto" "Seq" ? "integer" ? ? ? ? ? ? no ? no no "3" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fnDocumento(tt-duimp-docto.cod-tipo-docto) @ c-documento" "Documento" "x(90)" ? ? ? ? ? ? ? no "Documento" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-duimp-docto.valor
"tt-duimp-docto.valor" "Valores" "x(500)" "character" ? ? ? ? ? ? no "Valores das Palavras Chaves" no no "500" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSonDocto */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSonProc
/* Query rebuild information for BROWSE brSonProc
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-duimp-docto2 NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSonProc */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
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
     _Query            is NOT OPENED
*/  /* FRAME fPage7 */
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
            RUN findFirstEmbarque IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel,
                                                INPUT INPUT FRAME fPage4 c-cod-embarq,
                                                OUTPUT c-return).
            IF  c-return = "" THEN DO:
                RUN getIntField              IN h-bocx230 (INPUT 'cod-itiner', OUTPUT i-cod-itiner).
                RUN retornaHistoricoEmbarque IN h-bocx407 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel,
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


&Scoped-define BROWSE-NAME brSonDec
&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME brSonDec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSonDec wMaintenance
ON VALUE-CHANGED OF brSonDec IN FRAME fPage3
DO:
    run piEnableButtons in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSonDocto
&Scoped-define SELF-NAME brSonDocto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSonDocto wMaintenance
ON VALUE-CHANGED OF brSonDocto IN FRAME fPage3
DO:
    run piEnableButtons in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSonProc
&Scoped-define SELF-NAME brSonProc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSonProc wMaintenance
ON VALUE-CHANGED OF brSonProc IN FRAME fPage3
DO:
    run piEnableButtons in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-gerar-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gerar-arquivo wMaintenance
ON CHOOSE OF bt-gerar-arquivo IN FRAME fpage0 /* Gerar Arquivo Siscomex */
DO:
    IF  AVAIL tt-duimp-siscomex THEN DO:
        ASSIGN h-window:SENSITIVE = no.
        RUN imp\im7000f.w (INPUT tt-duimp-siscomex.cod-duimp-dts).
        ASSIGN h-window:SENSITIVE = YES.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    ASSIGN cb-via-transporte:SCREEN-VALUE IN FRAME fPage2  = {adinc/i01ad268.i 04 1}.
    
    RUN addRecord IN THIS-PROCEDURE.
    RUN pi-botoes (INPUT NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btAddDec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddDec wMaintenance
ON CHOOSE OF btAddDec IN FRAME fPage3 /* Incluir */
DO:
    ASSIGN h-window:SENSITIVE = NO.
    RUN imp\im7000c.w (input table tt-duimp-siscomex,
                       input table tt-duimp-docto4,
                       INPUT ?,
                       INPUT "ADD":U).
    ASSIGN h-window:SENSITIVE = YES.
    run openQueryDeclaracao in this-procedure.    
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
&Scoped-define SELF-NAME btAddDocto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddDocto wMaintenance
ON CHOOSE OF btAddDocto IN FRAME fPage3 /* Incluir */
DO:
    ASSIGN h-window:SENSITIVE = NO.
    RUN imp/im7000a.w PERSISTENT SET h-im7000a (INPUT ?,                          /* prTable  */
                                                INPUT tt-duimp-siscomex.r-Rowid,  /* prParent */
                                                INPUT 'ADD',                      /* pcAction */
                                                INPUT THIS-PROCEDURE,             /* phCaller */
                                                INPUT 3).                         /* pageNumber */
    IF  VALID-HANDLE(h-im7000a) THEN DO:   
        RUN initializeInterface IN h-im7000a.
        WAIT-FOR CLOSE OF h-im7000a FOCUS CURRENT-WINDOW.
    END. 
    ASSIGN h-window:SENSITIVE = YES.
    RUN openQueryDocto.
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


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btAddProc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddProc wMaintenance
ON CHOOSE OF btAddProc IN FRAME fPage3 /* Incluir */
DO:
    ASSIGN h-window:SENSITIVE = no.
    RUN imp\im7000b.w (input table tt-duimp-siscomex,
                       input table tt-duimp-docto2,
                       input ?,
                       INPUT "ADD":U).

    ASSIGN h-window:SENSITIVE = YES.
    run openQueryDossie in this-procedure.
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btCanHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCanHistorico wMaintenance
ON CHOOSE OF btCanHistorico IN FRAME fPage4 /* Save */
DO:
    RUN pi-canc-historico.
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

    RUN pi-retorna-chave-cd0763 IN h-bocx402 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts,
                                              INPUT tt-duimp-siscomex.cdd-siscomex-dts,
                                              OUTPUT i-cod-emitente,
                                              OUTPUT c-nat-operacao).

    RUN pi-set-chave-importacao IN h-cd0763   (INPUT YES, 
                                               INPUT i-cod-emitente,
                                               INPUT "", /*s‚rie do documento*/
                                               INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts,
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
    IF AVAIL tt-duimp-siscomex THEN DO:
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        RUN imp/im7000a1.w PERSISTENT SET h-im7000a1 (INPUT tt-duimp-siscomex.r-Rowid,
                                                      INPUT THIS-PROCEDURE,
                                                      INPUT {&hDBOTable}). 
        IF  VALID-HANDLE (h-im7000a1) THEN DO:
            RUN initializeInterface IN h-im7000a1.
            WAIT-FOR CLOSE OF h-im7000a1 FOCUS CURRENT-WINDOW.
        END.
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btDelDec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelDec wMaintenance
ON CHOOSE OF btDelDec IN FRAME fPage3 /* Eliminar */
DO:
    IF  AVAIL tt-duimp-docto4 THEN DO:
        run utp/ut-msgs.p(input "show":U,
                          input 550,
                          input "":U).
        if  return-value = "yes":U then do:
            RUN setConstraintSeqDocto IN h-bocx00489 (INPUT tt-duimp-docto4.cod-duimp-dts, INPUT 3, INPUT tt-duimp-docto4.seq-docto).
            RUN openQueryStatic    IN h-bocx00489 (INPUT "SeqDocto":U) NO-ERROR.
            RUN goToKey IN h-bocx00489(INPUT tt-duimp-docto4.cod-duimp-dts,   
                                       INPUT tt-duimp-docto4.documento,
                                       INPUT tt-duimp-docto4.seq-docto,
                                       INPUT tt-duimp-docto4.cod-tipo-docto,
                                       INPUT tt-duimp-docto4.cod-chave).    
            RUN piDeleteDeclaracao in this-procedure.
            RUN openQueryDeclaracao in this-procedure.
        end.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelDocto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelDocto wMaintenance
ON CHOOSE OF btDelDocto IN FRAME fPage3 /* Eliminar */
DO:
    IF  AVAIL tt-duimp-docto THEN DO:
        RUN utp/ut-msgs.p(INPUT "show":U,
                          INPUT 550,
                          INPUT "":U).
        IF RETURN-VALUE = "yes":U THEN DO:
            RUN setConstraintSeqDocto IN h-bocx00489 (INPUT tt-duimp-docto.cod-duimp-dts, INPUT 1, INPUT tt-duimp-docto.seq-docto).
            RUN openQueryStatic    IN h-bocx00489 (INPUT "SeqDocto":U) NO-ERROR.
            FOR EACH bfduimp-docto NO-LOCK
               WHERE bfduimp-docto.cod-duimp-dts  = tt-duimp-docto.cod-duimp-dts
                 AND bfduimp-docto.documento      = tt-duimp-docto.documento
                 AND bfduimp-docto.seq-docto      = tt-duimp-docto.seq-docto
                 AND bfduimp-docto.cod-tipo-docto = tt-duimp-docto.cod-tipo-docto:
                
                RUN repositionRecord IN h-bocx00489 (INPUT ROWID(bfduimp-docto)).
                RUN deleteRecord IN h-bocx00489.        
            END.
            RUN openQueryDocto IN THIS-PROCEDURE.
        END.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
    IF  NOT AVAIL tt-duimp-siscomex THEN
        RUN pi-botoes (INPUT NO).
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


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btDelProc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelProc wMaintenance
ON CHOOSE OF btDelProc IN FRAME fPage3 /* Eliminar */
DO:
    IF  AVAIL tt-duimp-docto2 THEN DO:
        run utp/ut-msgs.p(input "show":U,
                          input 550,
                          input "":U).
        if  return-value = "yes":U then do:
            RUN setConstraintSeqDocto IN h-bocx00489 (INPUT tt-duimp-docto2.cod-duimp-dts, INPUT 2, INPUT tt-duimp-docto2.seq-docto).
            RUN openQueryStatic    IN h-bocx00489 (INPUT "SeqDocto":U) NO-ERROR.
            RUN goToKey IN h-bocx00489(INPUT tt-duimp-docto2.cod-duimp-dts,   
                                       INPUT tt-duimp-docto2.documento,
                                       INPUT tt-duimp-docto2.seq-docto,
                                       INPUT tt-duimp-docto2.cod-tipo-docto,
                                       INPUT tt-duimp-docto2.cod-chave).    
            RUN deleteRecord IN h-bocx00489.
            run openQueryDossie in this-procedure.
        end.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btDocRelac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDocRelac wMaintenance
ON CHOOSE OF btDocRelac IN FRAME fpage0
DO:
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


&Scoped-define SELF-NAME btItensDuimp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btItensDuimp wMaintenance
ON CHOOSE OF btItensDuimp IN FRAME fpage0 /* Itens */
DO:
  
    IF AVAIL tt-duimp-siscomex THEN
         ASSIGN gr-duimp-siscomex  = tt-duimp-siscomex.r-Rowid.
    ELSE ASSIGN gr-duimp-siscomex  = ?.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN imp/im7000g.w.
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    RUN pi-atualiza-registro-tela.

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


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btModDec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModDec wMaintenance
ON CHOOSE OF btModDec IN FRAME fPage3 /* Modificar */
DO:
    IF  AVAIL tt-duimp-docto4 THEN DO:
        ASSIGN h-window:SENSITIVE = no.
        RUN imp\im7000c.w (input table tt-duimp-siscomex,
                           input table tt-duimp-docto4,
                           INPUT tt-duimp-docto4.r-rowid,
                           INPUT "MOD":U).

        ASSIGN h-window:SENSITIVE = YES.

        RUN openQueryDeclaracao in this-procedure.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btModDocto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModDocto wMaintenance
ON CHOOSE OF btModDocto IN FRAME fPage3 /* Modificar */
DO:
    IF AVAIL tt-duimp-docto THEN DO:
        ASSIGN h-window:SENSITIVE = NO.
        RUN imp/im7000a.w PERSISTENT SET h-im7000a (input tt-duimp-docto.r-Rowid,     /* prTable  */
                                                    INPUT tt-duimp-siscomex.r-Rowid,  /* prParent */
                                                    INPUT 'UPDATE',                   /* pcAction */
                                                    INPUT THIS-PROCEDURE,             /* phCaller */
                                                    INPUT 3).                         /* pageNumber */
        IF  VALID-HANDLE(h-im7000a) THEN DO:   
            RUN initializeInterface IN h-im7000a.
            WAIT-FOR CLOSE OF h-im7000a FOCUS CURRENT-WINDOW.
        END. 
        ASSIGN h-window:SENSITIVE = YES.
        RUN openQueryDocto.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btModProc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModProc wMaintenance
ON CHOOSE OF btModProc IN FRAME fPage3 /* Modificar */
DO:
    IF  AVAIL tt-duimp-docto2 THEN DO:
        ASSIGN h-window:SENSITIVE = no.
        RUN imp\im7000b.w (input table tt-duimp-siscomex,
                           input table tt-duimp-docto2,
                           INPUT tt-duimp-docto2.r-rowid,
                           INPUT "MOD":U).

        ASSIGN h-window:SENSITIVE = YES.

        run openQueryDossie in this-procedure.
    END.
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
    DISABLE btn-efetiva btAddHistorico btUpdateHistorico btn-muda-sequencia WITH FRAME fPage4.
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


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    RUN saveRecord IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "OK" THEN DO:        
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btSaveHistorico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaveHistorico wMaintenance
ON CHOOSE OF btSaveHistorico IN FRAME fPage4 /* Save */
DO:
    RUN pi-salva-historico.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="cxzoom/z01cx00487.w"}
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
    RUN updateRecord IN THIS-PROCEDURE.
    RUN pi-botoes (INPUT NO).
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
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN imp/im7010.w PERSISTENT SET h-im7010.
    IF  VALID-HANDLE (h-im7010) 
    AND AVAIL tt-duimp-siscomex THEN DO:
        RUN setaDUIMP   IN h-im7010 (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                     INPUT tt-duimp-siscomex.num-versao,
                                     INPUT tt-duimp-siscomex.cdd-siscomex-dts,
                                     INPUT THIS-PROCEDURE).
        RUN initializeInterface IN h-im7010.
        WAIT-FOR CLOSE OF h-im7010 FOCUS CURRENT-WINDOW.
    END. 
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    RUN pi-atualiza-registro-tela.
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
                         &RunMethod     = "RUN setaEstabelecimento IN hProgramZoom (input input frame fPage0 tt-duimp-siscomex.cod-estab, input input frame fPage0 tt-duimp-siscomex.cod-duimp-dts)."
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
                         &RunMethod="RUN setaEstabelecimento IN hProgramZoom (input input frame fPage0 tt-duimp-siscomex.cod-estabel, input input frame fPage0 tt-duimp-siscomex.cod-duimp-dts)."
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
&Scoped-define SELF-NAME c-cod-natur-operac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-natur-operac wMaintenance
ON F5 OF c-cod-natur-operac IN FRAME fPage1 /* Natureza Opera‡Æo */
DO:
    {method/ZoomFields.i
             &ProgramZoom="inzoom/z04in245.w"
             &FieldZoom1="nat-operacao"
             &FieldScreen1="c-cod-natur-operac"
             &Frame1="fpage1"
             &FieldZoom2="denominacao"
             &FieldScreen2="c-des-nat-operacao"
             &Frame2="fpage1"
             &EnableImplant="no"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-natur-operac wMaintenance
ON LEAVE OF c-cod-natur-operac IN FRAME fPage1 /* Natureza Opera‡Æo */
DO:
    assign input frame fpage1 c-cod-natur-operac.
    
    run findNatureza in h-boin245 (input c-cod-natur-operac,
                                   output c-return).
    if c-return = "":U then
        run getCharfield in h-boin245 (input "denominacao":U,output c-des-nat-operacao).
    else 
        assign c-des-nat-operacao = "":U.
    
    disp c-des-nat-operacao with frame fpage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-natur-operac wMaintenance
ON MOUSE-SELECT-DBLCLICK OF c-cod-natur-operac IN FRAME fPage1 /* Natureza Opera‡Æo */
DO:
    APPLY 'F5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-carac-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-carac-oper wMaintenance
ON VALUE-CHANGED OF cb-carac-oper IN FRAME fPage1 /* Caracter¡stica Opera‡Æo */
DO:
    RUN pi-trata-operacao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME cb-motDespch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-motDespch wMaintenance
ON VALUE-CHANGED OF cb-motDespch IN FRAME fPage2 /* Motivo */
DO:
    ASSIGN cb-motDespch:TOOLTIP IN FRAME fPage2 = INPUT FRAME fPage2 cb-motDespch.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-duimp-siscomex.cdn-importador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.cdn-importador wMaintenance
ON F5 OF tt-duimp-siscomex.cdn-importador IN FRAME fPage2 /* Importador */
DO:
    /*--- Zoom Smart Object ---*/
    assign l-implanta = yes.

    {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                       &campo=tt-duimp-siscomex.cdn-importador
                       &campozoom=cod-emitente
                       &campo2="c-nome-importador"
                       &campozoom2="nome-abrev"}.

     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.cdn-importador wMaintenance
ON LEAVE OF tt-duimp-siscomex.cdn-importador IN FRAME fPage2 /* Importador */
DO:
    RUN pi-leave-fornecedor IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.cdn-importador wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-duimp-siscomex.cdn-importador IN FRAME fPage2 /* Importador */
DO:
    apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-duimp-siscomex.cdn-pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.cdn-pais wMaintenance
ON F5 OF tt-duimp-siscomex.cdn-pais IN FRAME fPage2 /* Pa¡s Procedˆncia */
DO:
    {method/zoomfields.i &ProgramZoom="unzoom/z11un006.w"
                         &FieldZoom1="cod-pais"
                         &FieldScreen1="tt-duimp-siscomex.cdn-pais"
                         &Frame1="fPage2"
                         &FieldZoom2="nome-pais"
                         &FieldScreen2="tt-duimp-siscomex.des-pais-proced"
                         &Frame2="fPage2"
                         &FieldZoom3="iso-3166-2"
                         &FieldScreen3="tt-duimp-siscomex.cod-pais-iso"
                         &Frame3="fPage2"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.cdn-pais wMaintenance
ON LEAVE OF tt-duimp-siscomex.cdn-pais IN FRAME fPage2 /* Pa¡s Procedˆncia */
DO:
    ASSIGN INPUT FRAME fPage2 tt-duimp-siscomex.cdn-pais
           tt-duimp-siscomex.des-pais-proced = ""
           tt-duimp-siscomex.cod-pais-iso    = "".
    
    RUN findCh_pais IN h-boun006 (INPUT  tt-duimp-siscomex.cdn-pais, 
                                  OUTPUT c-return).
    IF  c-return = "" THEN DO:
        RUN getCharField IN h-boun006 (INPUT "nome-pais" , OUTPUT tt-duimp-siscomex.des-pais-proced).
        RUN getCharField IN h-boun006 (INPUT "iso-3166-2", OUTPUT tt-duimp-siscomex.cod-pais-iso).
    END.
    
    DISP tt-duimp-siscomex.des-pais-proced
         tt-duimp-siscomex.cod-pais-iso
        WITH FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.cdn-pais wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-duimp-siscomex.cdn-pais IN FRAME fPage2 /* Pa¡s Procedˆncia */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-duimp-siscomex.cdn-urf-despch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.cdn-urf-despch wMaintenance
ON F5 OF tt-duimp-siscomex.cdn-urf-despch IN FRAME fPage2 /* Unidade Despacho */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z01cx401.w"
                         &FieldZoom1="cdn-unid-recta-feder"
                         &FieldScreen1="tt-duimp-siscomex.cdn-urf-despch"
                         &Frame1="fPage2"
                         &EnableImplant="YES"} 

    APPLY "leave":U TO tt-duimp-siscomex.cdn-urf-despch IN FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.cdn-urf-despch wMaintenance
ON LEAVE OF tt-duimp-siscomex.cdn-urf-despch IN FRAME fPage2 /* Unidade Despacho */
DO:
    RUN goToKey IN h-bocx401(INPUT INPUT FRAME fPage2 tt-duimp-siscomex.cdn-urf-despch).
    IF RETURN-VALUE = "OK":U THEN
        RUN getCharField IN h-bocx401(INPUT "des-descr":U, OUTPUT cNomeUnidDespch).
    ELSE
        ASSIGN cNomeUnidDespch = "".
    DISP cNomeUnidDespch WITH FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.cdn-urf-despch wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-duimp-siscomex.cdn-urf-despch IN FRAME fPage2 /* Unidade Despacho */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-duimp-siscomex.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.cod-estabel wMaintenance
ON F5 OF tt-duimp-siscomex.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                     &campo=tt-duimp-siscomex.cod-estabel
                     &campozoom=cod-estabel
                     &campo2=cNomeEstab
                     &campozoom2=nome
                     &frame=fPage0}.                    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.cod-estabel wMaintenance
ON LEAVE OF tt-duimp-siscomex.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  {method/referencefields.i &HandleDBOLeave="h-boad107"
                            &FindMethod="findCodigo"
                            &KeyValue1="tt-duimp-siscomex.cod-estabel:SCREEN-VALUE IN FRAME fPage0"
                            &FieldName1="nome"
                            &FieldScreen1="cNomeEstab"
                            &Frame1="fPage0"}  

    IF  cAction = "ADD":U OR cAction = "COPY":U THEN DO:
        RUN findCodigo IN h-boad107 (INPUT tt-duimp-siscomex.cod-estabel:SCREEN-VALUE IN FRAME fPage0,
                                     OUTPUT c-return).
        IF  c-return = "":U THEN DO:
            RUN getIntField IN h-boad107 (INPUT "cod-emitente":U, OUTPUT i-cod-emitente). 

            IF  CAN-FIND(FIRST emitente NO-LOCK
                         WHERE emitente.cod-emitente = i-cod-emitente 
                         AND   emitente.identific <> 1 /* Cliente */) THEN DO:

                IF  INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel <> c-cod-estabel-ant THEN DO:
                    ASSIGN tt-duimp-siscomex.cdn-importador:screen-value in frame fPage2 = STRING(i-cod-emitente).
                    RUN pi-leave-fornecedor IN THIS-PROCEDURE.

                    ASSIGN c-cod-estabel-ant = INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel.
                END.
            END.
            ELSE
                assign tt-duimp-siscomex.cdn-importador:screen-value in frame fPage2  = STRING(0)
                       c-nome-importador:screen-value in frame fPage2                 = ""
                       c-tipo-importador:screen-value in frame fPage2                 = ""
                       tt-duimp-siscomex.ni-importador:SCREEN-VALUE in frame fPage2   = ""
                       tt-duimp-siscomex.end-importador:screen-value in frame fPage2  = "".
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-duimp-siscomex.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-duimp-siscomex.cod-usuar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.cod-usuar wMaintenance
ON LEAVE OF tt-duimp-siscomex.cod-usuar IN FRAME fPage1 /* Usu rio Respons vel */
DO:
    ASSIGN cNomeUsuar = "".
    
    IF  tt-duimp-siscomex.cod-usuar:SCREEN-VALUE IN FRAME fPage1 <> "" THEN DO:
        RUN returnNameUsuar IN h-bocx336 (INPUT tt-duimp-siscomex.cod-usuar:SCREEN-VALUE IN FRAME fPage1,
                                          OUTPUT cNomeUsuar).
    END.
    
    DISPLAY cNomeUsuar WITH FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME de-cod-identific-carga
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-cod-identific-carga wMaintenance
ON LEAVE OF de-cod-identific-carga IN FRAME fPage2 /* Identifica‡Æo */
DO:
    ASSIGN INPUT FRAME fPage2 de-cod-identific-carga.
    
    IF  de-cod-identific-carga = 0 THEN
        ASSIGN tt-duimp-siscomex.cod-identific-carga:SCREEN-VALUE IN FRAME fPage2 = "".
    ELSE
        ASSIGN tt-duimp-siscomex.cod-identific-carga:SCREEN-VALUE IN FRAME fPage2 = STRING(INPUT FRAME fPage2 de-cod-identific-carga).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-cod-identific-carga wMaintenance
ON VALUE-CHANGED OF de-cod-identific-carga IN FRAME fPage2 /* Identifica‡Æo */
DO:
    ASSIGN INPUT FRAME fPage2 de-cod-identific-carga.
    
    IF  de-cod-identific-carga = 0 THEN
        ASSIGN tt-duimp-siscomex.cod-identific-carga:SCREEN-VALUE IN FRAME fPage2 = "".
    ELSE
        ASSIGN tt-duimp-siscomex.cod-identific-carga:SCREEN-VALUE IN FRAME fPage2 = STRING(INPUT FRAME fPage2 de-cod-identific-carga).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-cdn-consign
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-consign wMaintenance
ON F5 OF fi-cdn-consign IN FRAME fPage1 /* Consignat rio */
DO:
    &if defined(bf-mat-comex) &then
        assign l-implanta = no.
    &else
        assign l-implanta = yes.
    &endif

    {include/zoomvar.i
        &prog-zoom="adzoom/z03ad098.w"
        &campo="fi-cdn-consign"
        &campozoom="cod-emitente"
        &frame="fPage1"
        &campo2="c-nome-abrev"
        &campozoom2="nome-abrev"
        &Frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-consign wMaintenance
ON LEAVE OF fi-cdn-consign IN FRAME fPage1 /* Consignat rio */
DO:
    {method/referencefields.i 
        &HandleDBOLeave="h-boad098"
        &FindMethod="findCodigo"
        &KeyValue1="fi-cdn-consign:SCREEN-VALUE IN FRAME fPage1"
        &FieldName1="nome-abrev"
        &FieldScreen1="c-nome-abrev"
        &Frame1="fPage1"}  
     
    IF fi-cdn-consign:SCREEN-VALUE IN FRAME fPage1 = "0" THEN
        ASSIGN c-nome-abrev:SCREEN-VALUE IN FRAME fPage1 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cdn-consign wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-cdn-consign IN FRAME fPage1 /* Consignat rio */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-despachante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-despachante wMaintenance
ON F5 OF fi-cod-despachante IN FRAME fPage1 /* Despachante */
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
ON LEAVE OF fi-cod-despachante IN FRAME fPage1 /* Despachante */
DO:
    DEFINE VARIABLE c-descricao AS CHARACTER   NO-UNDO.

    IF  VALID-HANDLE(h-boad098)
    //AND AVAIL tt-decla-import
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
ON MOUSE-SELECT-DBLCLICK OF fi-cod-despachante IN FRAME fPage1 /* Despachante */
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
    IF i-cdn-pto-nacionaliz <> 0 THEN DO:
        
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
    ELSE 
        ASSIGN c-desc-ponto-nacionaliz:SCREEN-VALUE IN FRAME fPage4 = "".
        
        
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tg-sitEspDespch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-sitEspDespch wMaintenance
ON VALUE-CHANGED OF tg-sitEspDespch IN FRAME fPage2 /* Situa‡Æo Especial de Despacho */
DO:
    IF  tg-sitEspDespch:CHECKED IN FRAME fPage2 = YES THEN DO:
        ASSIGN cb-motDespch:SENSITIVE                             IN FRAME fPage2 = YES
               tt-duimp-siscomex.tp-identific-carga:SENSITIVE     IN FRAME fPage2 = NO
               tt-duimp-siscomex.cod-identific-carga:SENSITIVE    IN FRAME fPage2 = NO
               tt-duimp-siscomex.cod-identific-carga:SCREEN-VALUE IN FRAME fPage2 = "":U
               de-cod-identific-carga:SCREEN-VALUE                IN FRAME fPage2 = "0":U.
    END.
    ELSE DO:
        ASSIGN cb-motDespch:SENSITIVE                          IN FRAME fPage2 = NO
               tt-duimp-siscomex.tp-identific-carga:SENSITIVE  IN FRAME fPage2 = YES
               tt-duimp-siscomex.cod-identific-carga:SENSITIVE IN FRAME fPage2 = YES.
    END.
    
    ASSIGN de-cod-identific-carga:SENSITIVE IN FRAME fPage2 = tt-duimp-siscomex.cod-identific-carga:SENSITIVE IN FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-duimp-siscomex.tp-identific-carga
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.tp-identific-carga wMaintenance
ON ENTRY OF tt-duimp-siscomex.tp-identific-carga IN FRAME fPage2
DO:
    ASSIGN l-displayFields = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-siscomex.tp-identific-carga wMaintenance
ON VALUE-CHANGED OF tt-duimp-siscomex.tp-identific-carga IN FRAME fPage2
DO:
    IF  NOT l-displayFields THEN
        ASSIGN tt-duimp-siscomex.cod-identific-carga:SCREEN-VALUE IN FRAME fPage2 = ""
               de-cod-identific-carga:SCREEN-VALUE                 IN FRAME fPage2 = "0".
               
    IF  INPUT FRAME fPage2 tt-duimp-siscomex.tp-identific-carga = 1 /* CE */ THEN DO:
        de-cod-identific-carga:MOVE-TO-TOP().
    END.
    ELSE DO:
        tt-duimp-siscomex.cod-identific-carga:MOVE-TO-TOP().
    END.
    
    ASSIGN l-displayFields = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDespesa
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}


    /*FOR EACH duimp-siscomex
    WHERE duimp-siscomex.cdd-siscomex-dts = 0:
        ASSIGN duimp-siscomex.cdd-siscomex-dts = duimp-siscomex.cod-duimp-dts.
    END.*/
    
tt-duimp-siscomex.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-duimp-siscomex.cdn-importador:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
tt-duimp-siscomex.cdn-urf-despch:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
fi-cod-despachante:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
fi-cdn-consign:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
c-cod-natur-operac:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-duimp-siscomex.cdn-pais:LOAD-MOUSE-POINTER ("image/lupa.cur")        IN FRAME fPage2.


/* Funcionalidade nÆo est  liberada para o Internacional. */
if i-pais-impto-usuario <> 1 then do:
   run utp/ut-msgs.p(input "show",
                     input 55282,
                     input return-value).
   apply 'close' to this-procedure.
   return no-apply.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterChangePage wMaintenance 
PROCEDURE afterChangePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-current-folder AS INTEGER     NO-UNDO.
    
    IF AVAIL tt-duimp-siscomex THEN
        ASSIGN cb-motDespch:TOOLTIP IN FRAME fPage2 = {cxinc/i04cx00487.i 04 tt-duimp-siscomex.mot-esp-despacho}.
        
    RUN getCurrentFolder IN hFolder (OUTPUT i-current-folder).

    IF i-current-folder = 4 /* Itinerÿrio */ THEN
        APPLY "VALUE-CHANGED":U TO brHistorico IN FRAME fPage4.        

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
    IF VALID-HANDLE({&hDBOSon3}) THEN DO:
        DELETE PROCEDURE {&hDBOSon3}.
        ASSIGN {&hDBOSon3} = ?.
    END.    

/*     IF VALID-HANDLE({&hDBOSon6}) THEN DO: */
/*         DELETE PROCEDURE {&hDBOSon6}.     */
/*         ASSIGN {&hDBOSon6} = ?.           */
/*     END.                                  */
    
    IF  VALID-HANDLE(h-boad107) THEN DO:
        DELETE PROCEDURE h-boad107.
        ASSIGN h-boad107 = ?.
    END.

    IF VALID-HANDLE(h-bocx401) THEN DO:
        DELETE PROCEDURE h-bocx401.
        ASSIGN h-bocx401 = ?.
    END.

   IF  VALID-HANDLE(h-boin295desc) THEN DO:
        DELETE PROCEDURE h-boin295desc.
        ASSIGN h-boin295desc = ?.
    END.

    IF VALID-HANDLE(h-boad098) THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.    

    IF VALID-HANDLE(h-bocx336) THEN DO:
        DELETE PROCEDURE h-bocx336.
        ASSIGN h-bocx336 = ?.
    END.    

    IF VALID-HANDLE(h-boin682) THEN DO:
        DELETE PROCEDURE h-boin682.
        ASSIGN h-boin682 = ?.
    END.    

    IF VALID-HANDLE(h-boin172) THEN DO:
        DELETE PROCEDURE h-boin172.
        ASSIGN h-boin172 = ?.
    END.
    
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

    IF VALID-HANDLE(h-boun006) THEN DO:
        DELETE PROCEDURE h-boun006.
        ASSIGN h-boun006 = ?.
    END.

    
/*     IF VALID-HANDLE(h-cd0763) THEN DO: */
/*         DELETE PROCEDURE h-cd0763.     */
/*         ASSIGN  h-cd0763 = ?.          */
/*     END.                               */
    
    
    
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

    DISABLE btObservacao WITH FRAME fPage1.
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
    THEN ENABLE  btAddSon2 btDeleteSon2 btUpdateSon2 WITH FRAME fPage5.
    ELSE DISABLE btAddSon2 btDeleteSon2 btUpdateSon2 WITH FRAME fPage5.

    DISABLE btAddDespesa btCanDespesa btSaveDespesa btUpdateDespesa c-cod-emb-desp btAtualizaEmb-desp WITH FRAME fPage5.

    ASSIGN c-cod-emb-desp   = ""
           rs-apres-despesa = 1.
    DISP c-cod-emb-desp rs-apres-despesa WITH FRAME fPage5.

    RUN pi-busca-Despesas-di.
    RUN pi-botoes (INPUT YES).

    RUN pi-trata-browser-Despesa   (INPUT YES).
    RUN pi-trata-browser-historico (INPUT YES).
    RUN pi-altera-duimp. /* desabilita os campos quando tem documento gerado no recebimento. */

    
    run piEnableButtons.
    
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
    ASSIGN l-displayFields = YES.

    IF  AVAIL tt-duimp-siscomex THEN DO:
        ASSIGN INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts.
        
        IF  cAction = "ADD":U OR cAction = "COPY":U THEN DO:
            ASSIGN tt-duimp-siscomex.mot-esp-despacho = 1
                   tt-duimp-siscomex.dtz-create       = DATETIME-TZ(TODAY, MTIME, TIMEZONE)
                   tt-duimp-siscomex.cod-usuar:SCREEN-VALUE IN FRAME fPage1 = c-seg-usuario.
        END.
        
        IF INPUT FRAME fPage2 tt-duimp-siscomex.tp-identific-carga = 1 /* CE */ THEN DO:
            de-cod-identific-carga:MOVE-TO-TOP().
            ASSIGN de-cod-identific-carga:SCREEN-VALUE IN FRAME fPage2 = tt-duimp-siscomex.cod-identific-carga.
        END.
        ELSE DO:
            tt-duimp-siscomex.cod-identific-carga:MOVE-TO-TOP().
        END.

        ASSIGN fi-situacao:SCREEN-VALUE IN FRAME fpage0       = {cxinc/i01cx00487.i 04 tt-duimp-siscomex.idi-sit-siscomex}
               dat-reg-duimp:SCREEN-VALUE IN FRAME fPage0     = STRING(DATE(tt-duimp-siscomex.dtz-reg-siscomex),"99/99/9999":U)
               c-cod-natur-operac:SCREEN-VALUE IN FRAME fPage1 = tt-duimp-siscomex.nat-operacao
               da-dtz-create:SCREEN-VALUE IN FRAME fPage1     = string(DATE(tt-duimp-siscomex.dtz-create),"99/99/9999":U)
               ed-inf-compl:SCREEN-VALUE IN FRAME fPage2      = tt-duimp-siscomex.des-inform-compl
               cb-motDespch:SCREEN-VALUE IN FRAME fPage2      = {cxinc/i04cx00487.i 04 tt-duimp-siscomex.mot-esp-despacho}
               cb-motDespch:TOOLTIP IN FRAME fPage2           = {cxinc/i04cx00487.i 04 tt-duimp-siscomex.mot-esp-despacho}
               tg-sitEspDespch:CHECKED IN FRAME fPage2        = tt-duimp-siscomex.sit-esp-despacho               
               c-tipo-importador:SCREEN-VALUE IN FRAME fPage2 = {adinc/i03ad098.i 04 tt-duimp-siscomex.tipo-importador}.
                              
        run getDescCGCEmitente in h-boin295desc ( INPUT tt-duimp-siscomex.cdn-importador,
                                                  OUTPUT c-nome-importador,
                                                  OUTPUT c-cpf-cnpj).

        IF tt-duimp-siscomex.ni-importador <> "":U THEN DO:
            RUN pi-retornaFormatoCgc(INPUT tt-duimp-siscomex.ni-importador,
                                     OUTPUT c-format-id-pessoal).                             
            ASSIGN tt-duimp-siscomex.ni-importador:FORMAT IN FRAME fPage2       = c-format-id-pessoal
                   tt-duimp-siscomex.ni-importador:SCREEN-VALUE IN FRAME fPage2 = tt-duimp-siscomex.ni-importador.
        END.

        DISP lbl-inf-compl 
             c-nome-importador
             WITH FRAME fPage2.

        RUN pi-botoes (INPUT YES).
    END.
    ELSE DO:
         ASSIGN dat-reg-duimp:SCREEN-VALUE IN FRAME fPage0          = "":U
                c-nome-importador:SCREEN-VALUE IN FRAME fPage2      = "":U
                ed-inf-compl:SCREEN-VALUE IN FRAME fPage2           = "":U
                c-tipo-importador:SCREEN-VALUE IN FRAME fPage2      = "":U
                c-cod-natur-operac:SCREEN-VALUE IN FRAME fPage1     = "":U
                fi-cod-despachante:SCREEN-VALUE IN FRAME fPage1     = "":U
                cb-via-transporte:SCREEN-VALUE IN FRAME fPage2      = {adinc/i01ad268.i 04 1}
                de-cod-identific-carga:SCREEN-VALUE IN FRAME fPage2 = "":U.

        RUN pi-botoes (INPUT NO).
    END.

    APPLY "leave":U TO tt-duimp-siscomex.cod-estabel    IN FRAME fPage0.
    APPLY "leave":U TO tt-duimp-siscomex.cod-usuar      IN FRAME fPage1.
    APPLY "leave":U TO tt-duimp-siscomex.cdn-urf-despch IN FRAME fPage2.
    APPLY "leave":U TO c-cod-natur-operac               IN FRAME fPage1.
    APPLY "leave":U TO fi-cod-despachante               IN FRAME fPage1.
    
    RUN openQueryDocto.
    run openQueryDossie.
    RUN openQueryDeclaracao.
        
   ASSIGN brSonDocto:SENSITIVE IN FRAME fPage3 = YES
          brSonProc:SENSITIVE IN FRAME fPage3 = YES
          brSonDec:SENSITIVE IN FRAME fPage3  = yes          .
          
    /************************************************************/
    RUN pi-atualiza-registro-tela.

    run piEnableButtons.

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
    
    IF  cAction = "ADD":U OR cAction = "COPY":U THEN DO:
    
        IF  cAction = "COPY":U THEN DO:
            assign tt-duimp-siscomex.dtz-create                             = DATETIME-TZ(TODAY, MTIME, TIMEZONE)
                   da-dtz-create:SCREEN-VALUE IN FRAME fPage1               = string(date(tt-duimp-siscomex.dtz-create),"99/99/9999":U)
                   tt-duimp-siscomex.cod-usuar:SCREEN-VALUE IN FRAME fPage1 = c-seg-usuario.        
            APPLY "leave":U TO tt-duimp-siscomex.cod-usuar IN FRAME fPage1.            
        END.
        
        ASSIGN fi-situacao:SCREEN-VALUE IN FRAME fPage0 = {cxinc/i01cx00487.i 04 01}.
               
        
        RUN piProximaDUIMP IN {&hDBOTable} (OUTPUT tt-duimp-siscomex.cod-duimp-dts).
        DISP tt-duimp-siscomex.cod-duimp-dts WITH FRAME fPage0.
        ASSIGN tt-duimp-siscomex.cdd-siscomex-dts = tt-duimp-siscomex.cod-duimp-dts
               c-cod-estabel-ant = "".

        IF  cAction = "ADD":U THEN DO:
            assign tt-duimp-siscomex.cod-duimp-siscomex:SCREEN-VALUE IN FRAME fPage0 = "":U
                   dat-reg-duimp:SCREEN-VALUE IN FRAME fPage0                        = "":U /*Data Registro Siscomex*/
                   c-tipo-importador:screen-value in frame fPage2                    = "":U
                   tt-duimp-siscomex.ni-importador:SCREEN-VALUE IN FRAME fPage2      = "":U
                   tt-duimp-siscomex.end-importador:SCREEN-VALUE IN FRAME fPage2     = "":U
                   fi-cod-despachante:SCREEN-VALUE IN FRAME fPage1                   = "0"
                   fi-cdn-consign:SCREEN-VALUE IN FRAME fPage1                       = "0"
                   c-cod-natur-operac:SCREEN-VALUE IN FRAME fPage1                   = ""
                   cb-motDespch:SCREEN-VALUE IN FRAME fPage2                         = {cxinc/i04cx00487.i 04 01}
                   cb-tipo-declaracao:SCREEN-VALUE IN FRAME fPage1                   = {cxinc/i02cx383.i 04 01}
                   cb-carac-oper:SCREEN-VALUE IN FRAME fPage1                        = {cxinc/i03cx383.i 04 01}
                   cb-mod-desp:SCREEN-VALUE IN FRAME fPage1                          = {cxinc/i04cx383.i 04 01}.

            ASSIGN tt-duimp-siscomex.ni-importador:FORMAT IN FRAME fPage2 = "x(19)":U.
        END.
    END.
 
    IF  cAction = "UPDATE":U then do:
        DISABLE tt-duimp-siscomex.cod-estabel WITH FRAME fPage0.
        ASSIGN cb-tipo-declaracao:SENSITIVE IN FRAME fPage1 = NO.
        ASSIGN cod-identific-carga:SCREEN-VALUE IN FRAME fPage2 = tt-duimp-siscomex.cod-identific-carga.
        RUN pi-verifica-embarques-vinculados. 

        APPLY 'ENTRY':U TO tt-duimp-siscomex.cod-duimp-siscomex IN FRAME fPage0.
    end.

    ASSIGN tt-duimp-siscomex.cod-duimp-siscomex:SENSITIVE IN FRAME fPage0 = YES
           dat-reg-duimp:SENSITIVE IN FRAME fPage0                        = YES.  /*Data Registro Siscomex*/

    DISABLE fi-situacao
            cNomeEstab
            WITH FRAME fPage0. 

    DISABLE tt-duimp-siscomex.cod-usuar
            da-dtz-create 
            WITH FRAME fPage1.
            
    DISABLE c-tipo-importador
            tt-duimp-siscomex.ni-importador 
            tt-duimp-siscomex.des-pais-proced 
            tt-duimp-siscomex.cod-pais-iso
            WITH FRAME fPage2.

    IF  cAction = "ADD":U OR cAction = "UPDATE":U  OR cAction = "COPY":U THEN DO:
        APPLY "VALUE-CHANGED":U TO tg-sitEspDespch IN FRAME fPage2.
    END.            
    
    APPLY 'VALUE-CHANGED' TO cb-carac-oper        IN FRAME fPage1.
    APPLY 'VALUE-CHANGED' TO rs-tipo-apresentacao IN FRAME fPage4.
    APPLY 'VALUE-CHANGED' TO rs-apres-despesa     IN FRAME fPage5.  

    DISABLE btAddSon1 btDeleteSon1 btUpdateSon1 WITH FRAME fPage4.
    DISABLE btAddSon2 btDeleteSon2 btUpdateSon2 WITH FRAME fPage5.

    DISABLE v-base-ibsuf WITH FRAME fPage7.
    DISABLE c-cdn-moed-vmcv WITH FRAME fPage8.

    RUN pi-tipo-apresentacao.
    RUN pi-apres-despesa.
    run pi-busca-impostos.
    run pi-busca-valores.
    RUN pi-busca-logs.
    RUN pi-altera-duimp. /* desabilita os campos quando tem documento gerado no recebimento. */

    RUN openQueryDocto.
    run openQueryDossie.
    RUN openQueryDeclaracao.    

    run piDisableButtons.
    
    RETURN "OK":U.           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose: Regras para execuvso apos a inicializacao do programa.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN h-window = CURRENT-WINDOW.
    
    IF  NOT l-nt2024002 THEN 
        RUN deleteFolder IN hFolder (INPUT 7).
    
    IF CAN-FIND(tt-duimp-siscomex) THEN
        RUN pi-botoes (INPUT YES).
    ELSE
        RUN pi-botoes (INPUT NO).
        
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
    ELSE DISABLE btDeleteSon2 btUpdateSon2 WITH FRAME fPage5.
    
    ENABLE brDespesa WITH FRAME fPage5.

    RUN pi-trata-browser-despesa (INPUT YES).
    
    RUN pi-busca-impostos.
    RUN pi-busca-valores.
    RUN pi-busca-logs.
    RUN pi-altera-duimp. /* desabilita os campos quando tem documento gerado no recebimento. */
    
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

    APPLY "leave":U TO tt-duimp-siscomex.cod-estabel IN FRAME fPage0.
    APPLY "leave":U TO fi-cod-despachante   IN FRAME fPage1.
    APPLY "leave":U TO fi-cdn-consign       IN FRAME fPage1.
    APPLY "leave":U TO c-cod-natur-operac   IN FRAME fPage1.
    APPLY "leave":U TO tt-duimp-siscomex.cod-usuar IN FRAME fPage1.
    

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
    ASSIGN cb-motDespch:LIST-ITEMS IN FRAME fPage2 = {cxinc/i04cx00487.i 03}.
    ASSIGN cb-tipo-declaracao:list-items        in frame fPage1 = {cxinc/i02cx383.i 03} /*PASTA PRINCIPAL*/
           cb-carac-oper:list-items             in frame fPage1 = {cxinc/i03cx383.i 03}
           cb-mod-desp:list-items               in frame fPage1 = {cxinc/i04cx383.i 03}
           cb-via-transporte:list-items         in frame fPage2 = {adinc/i01ad268.i 03} /*PASTA IDENTIFICA€ÇO*/
           /*cb-docto-carg:list-items             in frame fPage3 = {cxinc/i06cx383.i 03}
           cb-tipo-conhecto:list-items          in frame fPage3 = {cxinc/i07cx383.i 03}
           cb-ind-utiliz:list-items             in frame fPage3 = {cxinc/i08cx383.i 03}.*/
           .

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

    IF  AVAIL tt-duimp-siscomex THEN DO:

        ASSIGN INPUT FRAME fPage0 fi-situacao
               INPUT FRAME fPage0 dat-reg-duimp
               tt-duimp-siscomex.cdd-siscomex-dts   = INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts
               tt-duimp-siscomex.cod-duimp-siscomex = INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-siscomex
               tt-duimp-siscomex.idi-sit-siscomex = {cxinc/i01cx00487.i 06 fi-situacao}
               tt-duimp-siscomex.dtz-reg-siscomex = dat-reg-duimp /*Data de Registro da DUIMP no Siscomex*/.

        ASSIGN INPUT FRAME fPage1 c-cod-natur-operac
               tt-duimp-siscomex.nat-operacao = c-cod-natur-operac.               
        
        APPLY "leave":U TO tt-duimp-siscomex.cdn-importador IN FRAME fPage2.
            
        ASSIGN INPUT FRAME fPage2 ed-inf-compl
               tt-duimp-siscomex.des-inform-compl = ed-inf-compl
               tt-duimp-siscomex.tipo-importador  = i-natureza
               tt-duimp-siscomex.ni-importador    = REPLACE(REPLACE(REPLACE(REPLACE(tt-duimp-siscomex.ni-importador, ".":U, "":U), "/":U, "":U), "\":U, "":U), "-":U, "":U).               

        ASSIGN INPUT FRAME fPage2 tg-sitEspDespch
               INPUT FRAME fPage2 cb-motDespch
               tt-duimp-siscomex.sit-esp-despacho = tg-sitEspDespch
               tt-duimp-siscomex.mot-esp-despacho = {cxinc/i04cx00487.i 06 cb-motDespch}.
        
        FIND FIRST tt-decla-import
             WHERE tt-decla-import.num-di-ems       = INT(INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts)
               AND tt-decla-import.num-seq-retif    = 99
               AND tt-decla-import.cdd-siscomex-dts = DEC(tt-duimp-siscomex.cdd-siscomex-dts) NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-decla-import THEN DO:
            
            CREATE tt-decla-import.
            ASSIGN tt-decla-import.num-di-ems                 = INT(INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts)
                   tt-decla-import.num-seq-retif              = 99
                   tt-decla-import.cdd-siscomex-dts           = DEC(tt-duimp-siscomex.cdd-siscomex-dts)
                   tt-decla-import.log-ativo                  = YES.
               
        END.
        
        ASSIGN tt-decla-import.cod-estab                  = INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel
               OVERLAY(tt-decla-import.cod-livre-1,3,9)   = INPUT FRAME fPage1 fi-cod-despachante
               tt-decla-import.dat-di                     = date(STRING(DATE(tt-duimp-siscomex.dtz-reg-siscomex),"99/99/9999":U))
               tt-decla-import.cod-natur-operac           = tt-duimp-siscomex.nat-operacao
               tt-decla-import.cdn-consign                = INPUT FRAME fPage1 fi-cdn-consign
               tt-decla-import.cod-di-siscomex            = tt-duimp-siscomex.cod-duimp-siscomex.
               
        RUN pi-trata-combos (INPUT NO).

        RUN piSetTT-decla-import IN {&hDBOTable} (INPUT TABLE tt-decla-import).
    END.
    
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

    ASSIGN pDBOHandle = h-bocx00487.
    
    IF PROGRAM-NAME(2) MATCHES ("*im0400i.w") THEN 
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
        WHEN 3 THEN DO:
            ASSIGN pDBOHandle = h-bocx00489.
        END.
        /*WHEN 5 THEN DO:
            ASSIGN pDBOHandle = h-bocx00488.
        END.*/
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
    
    DEFINE variable de-cod-duimp-dts LIKE {&ttTable}.cod-duimp-dts NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        de-cod-duimp-dts  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para DUIMP Siscomex" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_DUIMP_Siscomex"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ASSIGN de-cod-duimp-dts:WIDTH IN FRAME fGoToRecord = 20.
    ASSIGN de-cod-duimp-dts:label in frame fGoToRecord = c-lbl-duimp-dts.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN de-cod-duimp-dts.
        
        RUN goToKey IN {&hDBOTable} (INPUT de-cod-duimp-dts).
        IF RETURN-VALUE = "NOK":U THEN DO:
            {utp/ut-liter.i "Declara‡Æo_énica_de_Importa‡Æo"}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE de-cod-duimp-dts btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "cxbo/bocx00487.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00487.p YES}
        {btb/btb008za.i2 cxbo/bocx00487.p '' {&hDBOTable}}
    END.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE({&hDBOSon3}) OR
       {&hDBOSon3}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon3}:FILE-NAME <> "cxbo/bocx00489.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00489.p YES}
        {btb/btb008za.i2 cxbo/bocx00489.p '' {&hDBOSon3}}
    END.    

/*     IF NOT VALID-HANDLE({&hDBOSon6}) OR                       */
/*        {&hDBOSon6}:TYPE <> "PROCEDURE":U OR                   */
/*        {&hDBOSon6}:FILE-NAME <> "cxbo/bocx00488.p":U THEN DO: */
/*         {btb/btb008za.i1 cxbo/bocx00488.p YES}                */
/*         {btb/btb008za.i2 cxbo/bocx00488.p '' {&hDBOSon6}}     */
/*     END.                                                      */
    
    IF NOT VALID-HANDLE(h-bocx401) OR
       h-bocx401:TYPE <> "PROCEDURE":U OR
       h-bocx401:FILE-NAME <> "cxbo/bocx401.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx401.p YES}
        {btb/btb008za.i2 cxbo/bocx401.p '' h-bocx401}
    END.
    RUN openQueryStatic IN h-bocx401 (INPUT "Main":U) NO-ERROR.    

    IF  NOT VALID-HANDLE(h-boin295desc) THEN DO:
        RUN inbo/boin295desc.p PERSISTENT SET h-boin295desc.
        RUN openQueryStatic IN h-boin295desc (INPUT "Main":U ).
    END.    

    IF NOT VALID-HANDLE(h-boad098) OR
       h-boad098:TYPE <> "PROCEDURE":U OR
       h-boad098:FILE-NAME <> "adbo/boad098.p":U THEN DO:
        {btb/btb008za.i1 adbo/boad098.p YES}
        {btb/btb008za.i2 adbo/boad098.p '' h-boad098}
    END.    

    IF NOT VALID-HANDLE(h-boad107) OR
       h-boad107:TYPE <> "PROCEDURE":U OR
       h-boad107:FILE-NAME <> "adbo/boad107.p":U THEN DO:
        {btb/btb008za.i1 adbo/boad107.p YES}
        {btb/btb008za.i2 adbo/boad107.p '' h-boad107}
    END.
    RUN openQuery IN h-boad107 (INPUT 1) NO-ERROR.    

    IF  NOT VALID-HANDLE(h-bocx336) OR
        h-bocx336:TYPE <> "PROCEDURE":U OR
        h-bocx336:FILE-NAME <> "cxbo/bocx336.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx336.p YES}
        {btb/btb008za.i2 cxbo/bocx336.p '' h-bocx336}
    END.    
    RUN openQueryStatic IN h-bocx336 (INPUT "Main":U) NO-ERROR.    

    IF NOT VALID-HANDLE(h-boun005) THEN
       run unbo/boun005.p persistent set h-boun005.
    RUN openquery IN h-boun005 (INPUT 1).    

    IF NOT VALID-HANDLE(h-boin682) OR
       h-boin682:TYPE <> "PROCEDURE":U OR
       h-boin682:FILE-NAME <> "inbo/boin682.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin682.p YES}
        {btb/btb008za.i2 inbo/boin682.p '' h-boin682}
    END.
    
    RUN openQueryStatic IN h-boin682 (INPUT "Main":U) NO-ERROR.
    RUN findFirst       IN h-boin682.
    RUN getCharField    IN h-boin682 (INPUT "formato-id-federal":U,
                                      OUTPUT c-formato-id-federal).
    RUN getCharField    IN h-boin682 (INPUT "formato-id-pessoal":U,
                                      OUTPUT c-formato-cpf).    

    IF NOT VALID-HANDLE(h-boin172) OR
       h-boin172:TYPE <> "PROCEDURE":U OR
       h-boin172:FILE-NAME <> "inbo/boin172.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin172.p YES}
        {btb/btb008za.i2 inbo/boin172.p '' h-boin172}
    END.                                      
    
    IF NOT VALID-HANDLE (h-boad098) THEN RUN adbo/boad098.p PERSISTENT SET h-boad098.
    IF NOT VALID-HANDLE (h-boin245) THEN RUN inbo/boin245.p PERSISTENT SET h-boin245.
    
    IF  NOT VALID-HANDLE (h-bocx384) THEN DO:
        RUN cxbo/bocx384.p PERSISTENT SET h-bocx384.
        RUN openQueryStatic IN h-bocx384 (INPUT "Main":U) NO-ERROR.
    END.

    IF NOT VALID-HANDLE(h-bocx3842) THEN DO:
        RUN cxbo/bocx384.p PERSISTENT SET h-bocx3842.
        RUN openQueryStatic IN h-bocx3842 (INPUT "Main":U) NO-ERROR.
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
    END.
    
    IF NOT VALID-HANDLE (h-bocx383) THEN DO:
        RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.
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
                                      
                                      
    IF NOT VALID-HANDLE(h-boun006) THEN
        RUN unbo/boun006.p PERSISTENT SET h-boun006.

        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDeclaracao wMaintenance 
PROCEDURE openQueryDeclaracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iRowsReturned AS INTEGER NO-UNDO.

    IF  AVAIL tt-duimp-siscomex THEN DO:
        RUN setConstraintDocto  IN {&hDBOSon5} (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts,
                                                INPUT 3 /* Declara‡Æo */).
        RUN openQueryStatic     IN {&hDBOSon5} (INPUT "Docto":U) NO-ERROR.
        RUN getBatchRecords     IN {&hDBOSon5} (INPUT  ?,
                                                INPUT  NO,
                                                INPUT  ?,
                                                OUTPUT iRowsReturned,
                                                OUTPUT TABLE tt-duimp-docto3).

        EMPTY TEMP-TABLE tt-duimp-docto4.
        
        FOR EACH tt-duimp-docto3 NO-LOCK:
            IF NOT CAN-FIND(FIRST tt-duimp-docto4 NO-LOCK
                            WHERE tt-duimp-docto4.cod-duimp-dts  = tt-duimp-docto3.cod-duimp-dts
                            AND   tt-duimp-docto4.documento      = tt-duimp-docto3.documento
                            AND   tt-duimp-docto4.cod-tipo-docto = tt-duimp-docto3.cod-tipo-docto
                            AND   tt-duimp-docto4.seq-docto      = tt-duimp-docto3.seq-docto) THEN DO:
                CREATE tt-duimp-docto4.
                BUFFER-COPY tt-duimp-docto3 TO tt-duimp-docto4.
            END.

            IF  tt-duimp-docto3.cod-chave = 1 THEN /* N£mero da declara‡Æo */
                ASSIGN tt-duimp-docto4.num-declaracao = tt-duimp-docto3.valor.
            ELSE 
            IF  tt-duimp-docto3.cod-chave = 2 THEN /* Item Inicial */
                ASSIGN tt-duimp-docto4.cod-item-ini = tt-duimp-docto3.valor.
            ELSE                                   /* Item Final */
                ASSIGN tt-duimp-docto4.cod-item-fim = tt-duimp-docto3.valor.
        END.
                                                
        {&OPEN-QUERY-brSonDec}
        APPLY "VALUE-CHANGED":U TO BROWSE brSonDec.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDocto wMaintenance 
PROCEDURE openQueryDocto :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza browser referente aos documentos e processos
  Parameters:
  Notes:       
------------------------------------------------------------------------------*/
    IF  AVAIL tt-duimp-siscomex THEN DO:
        RUN setConstraintDocto IN {&hDBOSon3} (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts, INPUT 1).
        RUN openQueryStatic    IN {&hDBOSon3} (INPUT "Docto":U) NO-ERROR.
        RUN getBatchRecords    IN {&hDBOSon3} (INPUT  ?,
                                               INPUT  NO,
                                               INPUT  ?,
                                               OUTPUT iRowsReturned,
                                               OUTPUT TABLE tt-duimp-docto-aux).
        EMPTY TEMP-TABLE tt-duimp-docto.
        FOR EACH tt-duimp-docto-aux,
           FIRST siscomex-chave NO-LOCK
           WHERE siscomex-chave.cod-tip-docto = tt-duimp-docto-aux.cod-tipo-docto
             AND siscomex-chave.cod-chave     = tt-duimp-docto-aux.cod-chave:
            FIND FIRST tt-duimp-docto
                 WHERE tt-duimp-docto.seq-docto      = tt-duimp-docto-aux.seq-docto
                   AND tt-duimp-docto.cod-tipo-docto = tt-duimp-docto-aux.cod-tipo-docto NO-ERROR.
            IF AVAIL tt-duimp-docto THEN
               ASSIGN tt-duimp-docto.valor = tt-duimp-docto.valor + " | " + TRIM(siscomex-chave.descricao) + " | " + TRIM(tt-duimp-docto-aux.valor).
            ELSE DO:
                CREATE tt-duimp-docto.
                BUFFER-COPY tt-duimp-docto-aux EXCEPT valor TO tt-duimp-docto.
                ASSIGN tt-duimp-docto.valor = TRIM(siscomex-chave.descricao) + " | " + TRIM(tt-duimp-docto-aux.valor).
            END.
        END.
                                               
        {&OPEN-QUERY-brSonDocto}
        APPLY "VALUE-CHANGED":U TO BROWSE brSonDocto.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDossie wMaintenance 
PROCEDURE openQueryDossie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iRowsReturned AS INTEGER NO-UNDO.

    IF  AVAIL tt-duimp-siscomex THEN DO:
        RUN setConstraintDocto  IN {&hDBOSon4} (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts,
                                                INPUT 2 /* Processo */).
        RUN openQueryStatic     IN {&hDBOSon4} (INPUT "Docto":U) NO-ERROR.
        RUN getBatchRecords     IN {&hDBOSon4} (INPUT  ?,
                                                INPUT  NO,
                                                INPUT  ?,
                                                OUTPUT iRowsReturned,
                                                OUTPUT TABLE tt-duimp-docto2).
        {&OPEN-QUERY-brSonProc}
        APPLY "VALUE-CHANGED":U TO BROWSE brSonProc.
    END.

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
        RUN imp/im7000f3.w PERSISTENT SET h-im7000f3 (INPUT ?,
                                                      INPUT tt-decla-import.r-Rowid,
                                                      INPUT 'ADD',
                                                      INPUT THIS-PROCEDURE,
                                                      INPUT 6).
        IF  VALID-HANDLE (h-im7000f3) THEN DO:
            RUN initializeInterface IN h-im7000f3.
            WAIT-FOR CLOSE OF h-im7000f3 FOCUS CURRENT-WINDOW.
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

    RUN findFirstEmbarque IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel,
                                        INPUT INPUT FRAME fPage5 c-cod-emb-desp,
                                        OUTPUT c-return).
    IF  c-return = "" THEN DO:
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner', OUTPUT i-cod-itiner).
        RUN trazrowidhistemb IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-estab,
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
    RUN imp/im7000f2.w PERSISTENT SET h-im7000f2 (INPUT ?,
                                                  INPUT tt-decla-import.r-Rowid,
                                                  INPUT 'ADD',
                                                  INPUT THIS-PROCEDURE,
                                                  INPUT 5).
    IF  VALID-HANDLE (h-im7000f2) THEN DO:
        RUN initializeInterface IN h-im7000f2.
        WAIT-FOR CLOSE OF h-im7000f2 FOCUS CURRENT-WINDOW.
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

    RUN findFirstEmbarque IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel,
                                        INPUT INPUT FRAME fPage4 c-cod-embarq,
                                        OUTPUT c-return).
    IF c-return = "" THEN DO:
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner',
                                      OUTPUT i-cod-itiner).
        
        RUN trazrowidhistemb IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel,
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-duimp wMaintenance 
PROCEDURE pi-altera-duimp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Altera‡Æo da DI ------------------------------------------------------------------*/
    IF  VALID-HANDLE(h-bocx383a) AND AVAIL tt-decla-import and avail tt-duimp-siscomex THEN DO:
        RUN piDoctoRecebimento IN h-bocx383a(INPUT tt-duimp-siscomex.cod-duimp-siscomex, OUTPUT l-encontrou).
        
        IF  l-encontrou THEN DO:
            DISABLE btCotacaoDI
                    /*btRateio pode calcular os impostos pois a nota mae altera a tributacao dos impostos*/
            WITH FRAME fPage0.

            IF  cAction = "UPDATE" THEN DO:
                DISABLE cb-carac-oper
                        cb-mod-desp
                        WITH FRAME fPage1.

                DISABLE cb-via-transporte 
                        WITH FRAME fPage2.

                FOR FIRST histor-decla-import NO-LOCK
                    WHERE histor-decla-import.num-di-ems       = int(INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts)
                      AND histor-decla-import.cdd-siscomex-dts = tt-duimp-siscomex.cdd-siscomex-dts:
                    ASSIGN i-pto-nacionalizacao = histor-decla-import.cdn-pto-nacionaliz.
                END. /* FOR FIRST histor-decla-import */
            END. /* IF cAction = "UPDATE" THEN DO: */            
        END. /* IF  l-encontrou THEN DO: */
        ELSE DO:
            ENABLE  btCotacaoDI
                    btRateio
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
RUN imp/im0400e.w PERSISTENT SET h-im0400e (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts,
                                            INPUT tt-duimp-siscomex.cdd-siscomex-dts,
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

    
END.
ELSE DO:
    DISABLE btAddDespesa btCanDespesa btSaveDespesa btUpdateDespesa
        btAddSon2 btUpdateSon2 btDeleteSon2
        WITH FRAME fPage5.
    ENABLE c-cod-emb-desp btAtualizaEmb-desp WITH FRAME fPage5.
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
    END. /* IF  INPUT FRAME fPage5 rs-tipo-apresentacao = 1 */
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
    EMPTY TEMP-TABLE tt-decla-import.

    IF AVAIL tt-duimp-siscomex THEN DO:

        RUN emptyRowObject  IN h-bocx383.
        RUN emptyRowErrors  IN h-bocx383.
        RUN openQueryStatic IN h-bocx383 (INPUT "Main") NO-ERROR.
        RUN goToKey         IN h-bocx383 (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                          INPUT 99,
                                          INPUT tt-duimp-siscomex.cdd-siscomex-dts).
        IF RETURN-VALUE = "OK":U THEN
            RUN getRecord IN h-bocx383 (OUTPUT TABLE tt-decla-import).

        IF tt-duimp-siscomex.dtz-reg-siscomex <> ? THEN
            ASSIGN btCotacaoDi   :SENSITIVE IN FRAME fPage0 = YES.
        ELSE
            ASSIGN btCotacaoDi   :SENSITIVE IN FRAME fPage0 = NO.

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

        FIND FIRST tt-decla-import NO-LOCK NO-ERROR.
        IF AVAIL tt-decla-import THEN DO:
            ASSIGN i-pto-ant = 0.    

            RUN pi-trata-combos (INPUT YES). 

            ASSIGN fi-cod-despachante:SCREEN-VALUE IN FRAME fPage1 = SUBSTRING(tt-decla-import.cod-livre-1,3,9)
                   fi-cdn-consign:SCREEN-VALUE IN FRAME fPage1     = string(tt-decla-import.cdn-consign)
                   i-num-itens:SCREEN-VALUE IN FRAME fPage1 = string(tt-decla-import.num-adicoes).

            APPLY 'VALUE-CHANGED' TO cb-carac-oper                 IN FRAME fPage1.
            APPLY 'LEAVE' TO fi-cod-despachante                    IN FRAME fPage1.
            APPLY 'LEAVE' TO fi-cdn-consign                        IN FRAME fPage1.
            
            RUN pi-busca-impostos. /* busca os impostos */
            RUN pi-busca-valores. /* busca os valores */
            RUN pi-busca-logs.
            
            RUN pi-altera-duimp. /* desabilita os campos quando tem documento gerado no recebimento. */

            /*Habilita o botÆo de Configurador de Tributos sempre que houver Impostos calculados atrav‚s dele*/
            ASSIGN l-habilita-bt-conf = YES.
               
            /* Desabilita de a natureza de opera‡Æo for de nota complementar */ 
            IF CAN-FIND(FIRST natur-oper 
                        WHERE natur-oper.nat-operacao = c-cod-natur-operac 
                        AND   natur-oper.nota-rateio)THEN
               ASSIGN l-habilita-bt-conf = NO.

            ASSIGN btConfTrib:SENSITIVE IN FRAME fPage0 = l-habilita-bt-conf. 

            IF i-modificacao <> 0 THEN
                APPLY "CHOOSE":U TO btCanHistorico IN FRAME fPage4.
            ASSIGN l-alterando = NO.
            APPLY "VALUE-CHANGED":U TO brHistorico IN FRAME fPage4.

        END.
        /*************************************************************/
        ELSE DO:
            ASSIGN cb-motDespch:SCREEN-VALUE IN FRAME fPage2       = {cxinc/i04cx00487.i 04 01}
                   cb-tipo-declaracao:SCREEN-VALUE IN FRAME fPage1 = {cxinc/i02cx383.i 04 01}
                   cb-carac-oper:SCREEN-VALUE IN FRAME fPage1      = {cxinc/i03cx383.i 04 01}
                   cb-mod-desp:SCREEN-VALUE IN FRAME fPage1        = {cxinc/i04cx383.i 04 01}
                   cb-via-transporte:SCREEN-VALUE IN FRAME fPage2  = {adinc/i01ad268.i 04 1}.
        END.

        APPLY 'LEAVE' TO fi-cod-despachante   IN FRAME fPage1.
        APPLY 'LEAVE' TO fi-cdn-consign       IN FRAME fPage1.
        APPLY 'LEAVE' TO c-cod-natur-operac   IN FRAME fPage1.
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
    RUN imp/im0400g.w PERSISTENT SET h-im0400g (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts,
                                                INPUT tt-decla-import.num-seq-retif,
                                                INPUT tt-duimp-siscomex.cdd-siscomex-dts).
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

    ASSIGN btConfTrib        :SENSITIVE IN FRAME fPage0 = lHabilita
           btRateio          :SENSITIVE IN FRAME fPage0 = lHabilita
           btCotacaoDi       :SENSITIVE IN FRAME fPage0 = lHabilita
           btVincEmb         :SENSITIVE IN FRAME fPage0 = lHabilita
           btItensDuimp      :SENSITIVE IN FRAME fPage0 = lHabilita
           btDocRelac        :SENSITIVE IN FRAME fPage0 = lHabilita.

    IF  AVAIL tt-duimp-siscomex
    AND tt-duimp-siscomex.dtz-reg-siscomex <> ? THEN
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
    
    IF AVAIL tt-duimp-siscomex THEN DO:
                
        RUN setConstraintByDeclaImport IN h-bocx406 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts,
                                                     INPUT tt-duimp-siscomex.cdd-siscomex-dts).
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
    
    RUN goToKey IN h-bocx407(INPUT INPUT FRAME fPAge0 tt-duimp-siscomex.cod-duimp-dts,
                             INPUT tt-duimp-siscomex.cdd-siscomex-dts,
                             INPUT INPUT FRAME fPage5 c-cod-emb-desp).
    IF  RETURN-VALUE = "NOK" THEN DO:
        IF  cAction <> "" 
        THEN /* Inicio -- Projeto Internacional */
 DO:
     {utp/ut-liter.i "Embarque_selecionado_nÆo_est _vinculado_a_DUIMP" *}
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
    
        RUN findFirstEmbarque IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel,
                                            INPUT INPUT FRAME fPage5 c-cod-emb-desp,
                                            OUTPUT c-return).
        IF  c-return = "" THEN DO:
            EMPTY TEMP-TABLE tt-desp-embarque.
            EMPTY TEMP-TABLE tt-despes-decla-import.
                
            RUN setConstraint3 IN h-bocx310 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel,
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
                       tt-despes-decla-import.num-di-ems                = tt-duimp-siscomex.cod-duimp-dts
                       tt-despes-decla-import.cdd-siscomex-dts          = tt-duimp-siscomex.cdd-siscomex-dts
                       tt-despes-decla-import.val-despes                = tt-desp-embarque.val-desp.
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
    IF  AVAIL tt-decla-import THEN DO:
        
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        RUN imp/im0400i.w PERSISTENT SET h-im0400i (INPUT tt-decla-import.r-Rowid,
                                                    INPUT 'update',
                                                    INPUT THIS-PROCEDURE).
        IF  VALID-HANDLE (h-im0400i) THEN DO:
            RUN initializeInterface IN h-im0400i.
            WAIT-FOR CLOSE OF h-im0400i FOCUS CURRENT-WINDOW.
        END.        
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.        
        
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
    
    RUN setConstraintByDeclaImport IN h-bocx384 (INPUT tt-duimp-siscomex.cod-duimp-dts, INPUT tt-duimp-siscomex.cdd-siscomex-dts).
    RUN openQueryStatic            IN h-bocx384 (INPUT "ByDeclaImport":U).
    RUN getBatchRecords            IN h-bocx384 (INPUT  ?,
                                                 INPUT  ?,
                                                 INPUT  99999,
                                                 OUTPUT i-reg-retornados,
                                                 OUTPUT TABLE tt-histor-decla-import).
    {&OPEN-QUERY-brHistorico}

    IF CAN-FIND(FIRST tt-histor-decla-import) THEN
        ENABLE btAddSon1 btDeleteSon1 btUpdateSon1 WITH FRAME fPage4.
    ELSE 
        DISABLE btAddSon1 btDeleteSon1 btUpdateSon1 WITH FRAME fPage4.

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

RUN goToKey IN h-bocx407(INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts,
                         INPUT INPUT FRAME fPage4 c-cod-embarq,
                         INPUT tt-duimp-siscomex.cdd-siscomex-dts).
IF RETURN-VALUE = "NOK" THEN DO:
    IF cAction <> "" THEN
        /* Inicio -- Projeto Internacional */
        DO:
        {utp/ut-liter.i "Embarque_selecionado_nÆo_est _vinculado_a_DUIMP" *}
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

    RUN findFirstEmbarque IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel,
                                        INPUT INPUT FRAME fPage4 c-cod-embarq,
                                        OUTPUT c-return).
    IF c-return = "" THEN DO:
        RUN getIntField IN h-bocx230 (INPUT 'cod-itiner',
                                      OUTPUT i-cod-itiner).
    
        EMPTY TEMP-TABLE tt-historico-embarque.
        EMPTY TEMP-TABLE tt-histor-decla-import.
        
        RUN trazrowidhistemb IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel,
                                           INPUT INPUT FRAME fPage4 c-cod-embarq,
                                           INPUT i-cod-itiner,
                                           OUTPUT r-hist-emb).
    
        run setConstraint4 IN h-bocx230a (INPUT r-hist-emb,
                                          INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel,
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
            ASSIGN tt-histor-decla-import.num-di-ems          = tt-duimp-siscomex.cod-duimp-dts
                   tt-histor-decla-import.num-seq             = tt-historico-embarque.sequencia
                   tt-histor-decla-import.cdd-siscomex-dts    = tt-duimp-siscomex.cdd-siscomex-dts
                   tt-histor-decla-import.descricao           = tt-historico-embarque.descricao
                   tt-histor-decla-import.cdn-pto-control     = tt-historico-embarque.cod-pto-contr
                   tt-histor-decla-import.cdn-pto-nacionaliz  = INPUT FRAME fPage4 i-cdn-pto-nacionaliz
                   tt-histor-decla-import.cod-meio-transp     = tt-historico-embarque.id-meio-transp
                   tt-histor-decla-import.dat-efetiva         = tt-historico-embarque.dt-efetiva
                   tt-histor-decla-import.nr-dias             = tt-historico-embarque.nr-dias
                   tt-histor-decla-import.dat-prev-origin     = tt-historico-embarque.dt-previsao
                   tt-histor-decla-import.dat-ult-prev        = tt-historico-embarque.dt-ult-previsao
                   tt-histor-decla-import.dsl-obs             = tt-historico-embarque.observacao
                   overlay(tt-histor-decla-import.cod-livre-1,6,2) = SUBSTR(tt-historico-embarque.char-1,1,2).
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
      
    assign de-v-base-ii             = 0
           de-v-susp-ii             = 0
           de-v-recolhe-ii          = 0
           de-v-outros-ii           = 0

           de-v-base-ipi            = 0
           de-v-susp-ipi            = 0
           de-v-recolhe-ipi         = 0
           de-v-outros-ipi          = 0

           de-v-base-pis            = 0
           de-v-susp-pis            = 0
           de-v-recolhe-pis         = 0
           de-v-outros-pis          = 0

           de-v-base-cofins         = 0
           de-v-susp-cofins         = 0
           de-v-recolhe-cofins      = 0
           de-v-outros-cofins       = 0

           de-v-base-icms           = 0
           de-v-susp-icms           = 0
           de-v-recolhe-icms        = 0
           de-v-outros-icms         = 0
 
           de-v-base-fcp            = 0
           de-v-susp-fcp            = 0
           de-v-recolhe-fcp         = 0
           de-v-outros-fcp          = 0

           de-v-base-fcp-st         = 0
           de-v-susp-fcp-st         = 0
           de-v-recolhe-fcp-st      = 0
           de-v-outros-fcp-st       = 0

           de-v-base-icms-st        = 0
           de-v-susp-icms-st        = 0
           de-v-recolhe-icms-st     = 0
           de-v-outros-icms-st      = 0

           de-v-base-icms-compl     = 0
           de-v-susp-icms-compl     = 0
           de-v-recolhe-icms-compl  = 0
           de-v-outros-icms-compl   = 0.

    IF AVAIL tt-decla-import THEN DO:
        RUN pi-busca-impostos IN h-bocx383 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts,
                                            INPUT tt-duimp-siscomex.cdd-siscomex-dts,
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
    END.

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
               
        FOR EACH decla-import-trib NO-LOCK
           WHERE decla-import-trib.num-di-ems       = tt-decla-import.num-di-ems
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-valores wMaintenance 
PROCEDURE pi-busca-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF VAR c-moeda-adic  AS CHAR FORMAT "X(30)" NO-UNDO.
    DEF VAR c-moeda-param AS CHAR FORMAT "X(30)" NO-UNDO.
    

    assign c-moeda-adic              = ""
           c-cdn-moed-frete          = ""
           c-cdn-moed-seguro         = ""
           c-moeda-param             = ""
           d-val-vmcv                = 0
           d-val-vmcv-me             = 0
           d-val-vmle                = 0
           d-val-vmle-me             = 0
           d-val-vmld                = 0
           d-val-vmld-me             = 0
           d-val-frete               = 0
           d-val-frete-me            = 0
           d-val-seguro              = 0
           d-val-seguro-me           = 0
           d-val-acresc              = 0
           d-val-acresc-me           = 0
           d-tot-val-desp-nacion-me  = 0
           d-tot-val-desp-nacion     = 0
           d-tot-val-desp-compl-me   = 0
           d-tot-val-desp-compl      = 0
           d-tot-val-desp-di-me      = 0
           d-tot-val-desp-di         = 0.

    IF AVAIL tt-decla-import THEN DO:
        
        RUN pi-busca-valores IN h-bocx383 (INPUT  INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts,
                                           INPUT  INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel,
                                           INPUT  tt-duimp-siscomex.cdd-siscomex-dts,
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
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cotacao wMaintenance 
PROCEDURE pi-cotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN imp/im7000a1.w PERSISTENT SET h-im7000a1 (INPUT tt-duimp-siscomex.r-Rowid,
                                                  INPUT THIS-PROCEDURE,
                                                  INPUT h-bocx383).
    IF  VALID-HANDLE (h-im7000a1) THEN DO:
        RUN initializeInterface IN h-im7000a1.
        WAIT-FOR CLOSE OF h-im7000a1 FOCUS CURRENT-WINDOW.
    END. 
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

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
                RUN pi-busca-despes-siscomex IN h-bocx406(INPUT tt-duimp-siscomex.cod-duimp-dts,
                                                          INPUT tt-duimp-siscomex.cdd-siscomex-dts,
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
                            WHERE decla-import-embarq.num-di-ems       = int(tt-duimp-siscomex.cod-duimp-dts)
                              AND decla-import-embarq.cdd-siscomex-dts = tt-duimp-siscomex.cdd-siscomex-dts NO-LOCK:

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
                                {utp/ut-liter.i "As_informa‡äes_podem_estar_sendo_validadas_referente_aos_embarques_relacionados_a_DUIMP_Lembre-se_de_verifica-los."}

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
                  WHERE decla-import-embarq.num-di-ems       = int(tt-duimp-siscomex.cod-duimp-dts)
                    AND decla-import-embarq.cdd-siscomex-dts = tt-duimp-siscomex.cdd-siscomex-dts NO-LOCK:

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-fornecedor wMaintenance 
PROCEDURE pi-leave-fornecedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-format-id-pessoal = ""
           c-cpf-cnpj = "".
    
    run getDescCGCEmitente in h-boin295desc ( input frame fPage2 tt-duimp-siscomex.cdn-importador,
                                              output c-nome-importador,
                                              output c-cpf-cnpj).

    RUN findCodigo IN h-boad098 (INPUT input frame fPage2 tt-duimp-siscomex.cdn-importador, OUTPUT c-return).
    IF  c-return = "":U THEN DO:
        RUN getCharField IN h-boad098 (INPUT "endereco":U, OUTPUT c-end-importador).
        RUN getIntField IN h-boad098 (INPUT "natureza":U, OUTPUT i-natureza).
        
        RUN pi-retornaFormatoCgc(INPUT c-cpf-cnpj,
                                 OUTPUT c-format-id-pessoal).
        
        ASSIGN c-tipo-importador:screen-value in frame fPage2                = {adinc/i03ad098.i 04 i-natureza}
               tt-duimp-siscomex.ni-importador:format in frame fPage2        = c-format-id-pessoal
               tt-duimp-siscomex.ni-importador:screen-value in frame fPage2  = c-cpf-cnpj
               tt-duimp-siscomex.end-importador:screen-value in frame fPage2 = c-end-importador.
    END.
    else do:
        ASSIGN tt-duimp-siscomex.end-importador:screen-value in frame fPage2 = ""
               tt-duimp-siscomex.ni-importador:screen-value in frame fPage2  = ""
               c-tipo-importador:screen-value in frame fPage2                = "".
    end.

    RUN pi-retornaFormatoCgc(INPUT c-cpf-cnpj,
                             OUTPUT c-format-id-pessoal).                             
    ASSIGN tt-duimp-siscomex.ni-importador:format in frame fPage2 = c-format-id-pessoal.               
               
    DISPLAY c-nome-importador
            WITH FRAME fPage2.

    RETURN "OK":U.
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
IF AVAIL tt-decla-import THEN DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN imp/im7000f1.w PERSISTENT SET h-im7000f (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts,              
                                                 INPUT 99,
                                                 INPUT tt-duimp-siscomex.cdd-siscomex-dts,
                                                 INPUT tt-decla-import.cod-inf-compltar,
                                                 INPUT THIS-PROCEDURE).
    IF  VALID-HANDLE (h-im7000f) THEN DO:
        RUN initializeInterface IN h-im7000f.
        WAIT-FOR CLOSE OF h-im7000f FOCUS CURRENT-WINDOW.
    END. 
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

END.
    
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
       
IF AVAIL tt-decla-import THEN DO:
    
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN imp/im7000aa.w PERSISTENT SET h-im7000aa (INPUT THIS-PROCEDURE,
                                                  INPUT tt-duimp-siscomex.cod-duimp-dts,
                                                  INPUT tt-duimp-siscomex.cdd-siscomex-dts,
                                                  INPUT 99).
    IF  VALID-HANDLE (h-im7000aa) THEN DO:
        RUN initializeInterface IN h-im7000aa.
        WAIT-FOR CLOSE OF h-im7000aa FOCUS CURRENT-WINDOW.            
    END.     
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    DO TRANS:
        IF l-rateio THEN DO:
            RUN emptyRowErrors IN h-bocx383a.
            RUN pi-rateio-di   IN h-bocx383a(INPUT tt-duimp-siscomex.cod-duimp-dts,
                                             INPUT tt-duimp-siscomex.cdd-siscomex-dts,
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
            RUN pi-calcula-impostos     IN h-bocx383a (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                                       INPUT tt-duimp-siscomex.cdd-siscomex-dts).
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
    IF l-rateio-realizado THEN  DO:
        IF l-rateio-desp-comp THEN DO:
            DO TRANS:
                RUN emptyRowErrors IN h-bocx383a.
                RUN pi-rateio-di   IN h-bocx383a(INPUT tt-duimp-siscomex.cod-duimp-dts,
                                                 INPUT tt-duimp-siscomex.cdd-siscomex-dts,
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
            RUN pi-atual-val-rat-compl-embarque  IN h-bocx383a (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                                                INPUT tt-duimp-siscomex.cdd-siscomex-dts,
                                                                INPUT TABLE tt-desp-rateio-item).
        END.
        IF l-gera-relat THEN DO:
            RUN imp/im0400rp.p (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts, input tt-duimp-siscomex.cdd-siscomex-dts). 
        END.
    END.

    /* verifica se h  ? ou 0 nos valores do rateio*/
    IF l-rateio THEN
        RUN validaCalculoRateio IN h-bocx383a (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                               INPUT tt-duimp-siscomex.cdd-siscomex-dts).

    RUN getRowErrors   IN h-bocx383a(OUTPUT TABLE RowErrors).
    IF  CAN-FIND(FIRST RowErrors 
                     WHERE RowErrors.ErrorType    <> "INTERNAL":U
                     AND   (RowErrors.ErrorSubType  = "ERROR":U OR RowErrors.ErrorSubType  = "WARNING":U)  ) OR
                     RETURN-VALUE = "NOK":U THEN DO:
        
            {method/showmessage.i1}
            {method/showmessage.i2}
    END.
END.
/* fim - verifica se h  ? ou 0 nos valores do rateio ou no calculo dos impostos */
RUN pi-atualiza-registro-tela.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retornaFormatoCgc wMaintenance 
PROCEDURE pi-retornaFormatoCgc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-cnpj-cpf LIKE tt-duimp-siscomex.ni-importador NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-formato AS CHARACTER FORMAT "x(19)":U NO-UNDO.

    ASSIGN pc-cod-cnpj-cpf = REPLACE(REPLACE(REPLACE(REPLACE(pc-cod-cnpj-cpf, ".":U, "":U), "/":U, "":U), "\":U, "":U), "-":U, "":U)
           pc-formato      = "":U.

    IF  LENGTH(pc-cod-cnpj-cpf) <> 0 THEN DO:
        IF  LENGTH(pc-cod-cnpj-cpf) = 11 THEN DO:
            ASSIGN pc-formato = c-formato-cpf NO-ERROR.
        END.
        ELSE DO:
            IF LENGTH(pc-cod-cnpj-cpf) = 14 THEN DO:
                ASSIGN pc-formato = c-formato-id-federal NO-ERROR.
            END.
            ELSE 
                ASSIGN pc-formato = "x(19)":U.
        END.
    END.

    IF ERROR-STATUS:ERROR THEN
        ASSIGN pc-formato = "x(19)":U NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retornaMoeda wMaintenance 
PROCEDURE pi-retornaMoeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    DEFINE INPUT PARAMETER p-cdn-moeda LIKE moeda.mo-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER p-desc-moeda LIKE moeda.descricao NO-UNDO.

    RUN findCodigo IN h-boun005 (p-cdn-moeda, OUTPUT c-return).
    IF  c-return = "" THEN DO:
        RUN getCharField in h-boun005 (input "descricao":U, output p-desc-moeda).
    END.

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
    ASSIGN tt-despes-decla-import-aux.num-di-ems                = tt-duimp-siscomex.cod-duimp-dts
           tt-despes-decla-import-aux.cdd-siscomex-dts          = tt-duimp-siscomex.cdd-siscomex-dts
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-historico wMaintenance 
PROCEDURE pi-salva-historico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF  VALID-HANDLE(h-bocx383a) THEN DO:
        RUN piDoctoRecebimento IN h-bocx383a(INPUT tt-duimp-siscomex.cod-duimp-siscomex, OUTPUT l-encontrou).

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
            ASSIGN tt-histor-decla-import-aux.num-di-ems      = tt-duimp-siscomex.cod-duimp-dts
                   tt-histor-decla-import-aux.cdd-siscomex-dts = tt-duimp-siscomex.cdd-siscomex-dts
                   tt-histor-decla-import-aux.num-seq         = INPUT BROWSE brHistorico tt-histor-decla-import.num-seq
                   tt-histor-decla-import-aux.cdn-pto-control = INPUT BROWSE brHistorico tt-histor-decla-import.cdn-pto-control 
                   tt-histor-decla-import-aux.descricao       = INPUT BROWSE brHistorico tt-histor-decla-import.descricao
                   tt-histor-decla-import-aux.nr-dias         = INPUT BROWSE brHistorico tt-histor-decla-import.nr-dias
                   tt-histor-decla-import-aux.cod-meio-transp = INPUT BROWSE brHistorico tt-histor-decla-import.cod-meio-transp 
                   tt-histor-decla-import-aux.dat-efetiva     = INPUT BROWSE brHistorico tt-histor-decla-import.dat-efetiva     
                   tt-histor-decla-import-aux.dat-prev-origin = INPUT BROWSE brHistorico tt-histor-decla-import.dat-prev-origin  
                   tt-histor-decla-import-aux.dat-ult-prev    = INPUT BROWSE brHistorico tt-histor-decla-import.dat-ult-prev    
                   tt-histor-decla-import-aux.dsl-obs         = INPUT BROWSE brHistorico tt-histor-decla-import.dsl-obs
                   overlay(tt-histor-decla-import-aux.cod-livre-1,6,2) = c-cod-uf.

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
                            AND   bf-tt-histor-decla-import.cdd-siscomex-dts    =  tt-histor-decla-import.cdd-siscomex-dts
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
    END. /* IF  INPUT FRAME fPage5 rs-tipo-apresentacao = 1 */
    ELSE DO: /* Embarque */

        RUN findFirstEmbarque IN h-bocx230 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel,
                                            INPUT INPUT FRAME fPage4 c-cod-embarq,
                                            OUTPUT c-return).
        IF  c-return = "" THEN RUN getIntField IN h-bocx230 (INPUT 'cod-itiner', OUTPUT i-cod-itiner).

        EMPTY TEMP-TABLE tt-historico-embarque-aux.
        CREATE tt-historico-embarque-aux.
        ASSIGN tt-historico-embarque-aux.cod-estabel     = INPUT FRAME fPage0 tt-duimp-siscomex.cod-estabel
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
                   .
        END.
        ELSE DO:
            ASSIGN INPUT FRAME fPage1 cb-tipo-declaracao
                   INPUT FRAME fPage1 cb-carac-oper
                   INPUT FRAME fPage1 cb-mod-desp
                   INPUT FRAME fPage2 cb-via-transporte
                   tt-decla-import.idi-tip-decla-import = {cxinc/i02cx383.i 06 cb-tipo-declaracao}
                   tt-decla-import.idi-caract-operac    = {cxinc/i03cx383.i 06 cb-carac-oper}
                   tt-decla-import.idi-modalid-despch   = {cxinc/i04cx383.i 06 cb-mod-desp}
                   tt-decla-import.idi-via-transp-di    = {adinc/i01ad268.i 06 cb-via-transporte}
                   .

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
        ASSIGN fi-cdn-consign:SENSITIVE IN FRAME fPage1    = NO
               fi-cdn-consign:SCREEN-VALUE IN FRAME fPage1 = "".

        APPLY 'LEAVE' TO fi-cdn-consign IN FRAME fPage1.
    END.
    ELSE DO:
        IF cAction <> '' THEN
            ASSIGN fi-cdn-consign:SENSITIVE IN FRAME fPage1 = YES.
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
                RUN imp/im7000f3.w PERSISTENT SET h-im7000f3 (INPUT tt-despes-decla-import.r-Rowid,
                                                            INPUT tt-decla-import.r-Rowid,
                                                            INPUT 'UPDATE',
                                                            INPUT THIS-PROCEDURE,
                                                            INPUT 6).
                IF  VALID-HANDLE (h-im7000f3) THEN DO:
                    RUN initializeInterface IN h-im7000f3.
                    WAIT-FOR CLOSE OF h-im7000f3 FOCUS CURRENT-WINDOW.
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
    
    /*--- Altera‡Æo da DI ------------------------------------------------------------------*/
    IF  VALID-HANDLE(h-bocx383a) THEN DO:
        RUN piDoctoRecebimento IN h-bocx383a(INPUT tt-duimp-siscomex.cod-duimp-siscomex, OUTPUT l-encontrou).

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
            RUN imp/im7000f2.w PERSISTENT SET h-im7000f2 (INPUT tt-histor-decla-import.r-Rowid,
                                                        INPUT tt-decla-import.r-Rowid,
                                                        INPUT 'UPDATE',
                                                        INPUT THIS-PROCEDURE,
                                                        INPUT 5).
            IF  VALID-HANDLE (h-im7000f2) THEN DO:
                RUN initializeInterface IN h-im7000f2.
                WAIT-FOR CLOSE OF h-im7000f2 FOCUS CURRENT-WINDOW.
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
    RUN pi-valida-ponto-controle-chegada IN h-bocx406 (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                                       INPUT tt-duimp-siscomex.cdd-siscomex-dts, 
                                                       INPUT pPtoControle,
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
RUN pi-valida-alteracao-data-duimp IN h-bocx383 (INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts,
                                                 INPUT 99,
                                                 INPUT tt-duimp-siscomex.cdd-siscomex-dts,
                                                 INPUT INPUT FRAME fPage0 dat-reg-duimp,
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
        
        RUN pi-verifica-despesas-embarque IN h-bocx406 (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                                        INPUT tt-despes-decla-import.cdn-desp,
                                                        INPUT tt-duimp-siscomex.cdd-siscomex-dts,
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
    RUN pi-valida-embarques-di IN h-bocx407 (input tt-duimp-siscomex.cod-duimp-dts,
                                             INPUT tt-duimp-siscomex.cdd-siscomex-dts,
                                             OUTPUT l-embarq-vinc).

    ASSIGN tt-duimp-siscomex.cod-estab:SENSITIVE IN FRAME fPage0 = NOT l-embarq-vinc.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDeleteDeclaracao wMaintenance 
PROCEDURE piDeleteDeclaracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 

    FOR EACH bfduimp-docto NO-LOCK
        WHERE bfduimp-docto.cod-duimp-dts  = tt-duimp-docto4.cod-duimp-dts
        AND   bfduimp-docto.documento      = tt-duimp-docto4.documento
        AND   bfduimp-docto.cod-tipo-docto = tt-duimp-docto4.cod-tipo-docto
        AND   bfduimp-docto.seq-docto      = tt-duimp-docto4.seq-docto:
        
        RUN repositionRecord IN h-bocx00489 (INPUT ROWID(bfduimp-docto)).
        RUN deleteRecord IN h-bocx00489.        
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDisableButtons wMaintenance 
PROCEDURE piDisableButtons :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO with frame fPage3:
        disable btAddDocto 
        btModDocto btDelDocto .
    END.

    DO with frame fPage3:
        disable btAddProc btModProc btDelProc 
                btAddDec btModDec btDelDec .
    END.

    if  can-find(first tt-duimp-siscomex)
    AND NOT (cAction = "ADD":U OR cAction = "UPDATE":U  OR cAction = "COPY":U) then
        enable bt-gerar-arquivo with frame fPage0.
    else
        disable bt-gerar-arquivo with frame fPage0.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnableButtons wMaintenance 
PROCEDURE piEnableButtons :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    enable btAddDocto WITH FRAME fPage3.
    enable btAddProc btAddDec with frame fPage3.
    
    if  can-find(first tt-duimp-docto) then
        enable btModDocto btDelDocto with frame fPage3.
    else
        disable btModDocto btDelDocto with frame fPage3.

    if  can-find(first tt-duimp-docto2) then
        enable btModProc btDelProc with frame fPage3.
    else
        disable btModProc btDelProc with frame fPage3.

    if  can-find(first tt-duimp-docto4) then
        enable btModDec btDelDec with frame fPage3.
    else
        disable btModDec btDelDec with frame fPage3.        


    if  can-find(first tt-duimp-siscomex)
    AND NOT (cAction = "ADD":U OR cAction = "UPDATE":U  OR cAction = "COPY":U) then
        enable bt-gerar-arquivo with frame fPage0.
    else
        disable bt-gerar-arquivo with frame fPage0.
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

    /*--- Atualiza browse filho mas somente da p˜gina iRepositionPageNumber ---*/
    CASE pPageNumber:
        WHEN 3 THEN DO:
            RUN openQueryDocto.
        END.
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
        RUN pi-recarrega-impostos IN h-bocx383a (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                                 INPUT tt-duimp-siscomex.cdd-siscomex-dts,
                                                 INPUT INPUT FRAME fPage1 c-cod-natur-operac).
    
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
( INPUT i-num-seq  AS INTEGER,
  INPUT dt-efetiva AS DATE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var num-dif as integer no-undo.
  DEFINE VARIABLE dt-ult-prev AS DATE        NO-UNDO.
  
  RUN goToKey IN h-bocx384(INPUT INPUT FRAME fPage0 tt-duimp-siscomex.cod-duimp-dts,
                           INPUT tt-duimp-siscomex.cdd-siscomex-dts,
                           INPUT i-num-seq).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnClasFiscItem wMaintenance 
FUNCTION fnClasFiscItem RETURNS CHARACTER
  ( input c-it-codigo as character) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   ASSIGN c-class-fisc = "":U.
   
   RUN findCodigo IN h-boin172 (INPUT c-it-codigo, OUTPUT c-return).
   IF  c-return = "":U THEN
       RUN getCharField IN h-boin172 (input "class-fiscal", OUTPUT c-class-fisc).

    return c-class-fisc.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCodTipoDocto wMaintenance 
FUNCTION fnCodTipoDocto RETURNS CHARACTER
  ( input pCodTipoDocto as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    {utp/ut-liter.i Administrativo }
    assign v-desc-tipo-docto = trim(string(pcodTipoDocto)) + " - ":U + return-value.

    return v-desc-tipo-docto.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescDespes wMaintenance 
FUNCTION fnDescDespes RETURNS CHARACTER
  ( p-cdn-despes AS INT,
    p-num-di-ems AS INT,
    pcdd-siscomex-dts AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc-despesa AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-estab AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-embarque AS CHARACTER   NO-UNDO.

    RUN goToFirstEmbarque IN h-bocx407 (INPUT p-num-di-ems,
                                        INPUT pcdd-siscomex-dts).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wMaintenance 
FUNCTION fnDescItem RETURNS CHARACTER
  ( input c-it-codigo as character) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   ASSIGN c-desc-item = "":U.
   
   RUN findCodigo IN h-boin172 (INPUT c-it-codigo, OUTPUT c-return).
   IF  c-return = "":U THEN
       RUN getCharField IN h-boin172 (input "desc-item", OUTPUT c-desc-item).

    return c-desc-item.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescPagto wMaintenance 
FUNCTION fnDescPagto RETURNS CHARACTER
( INPUT i-cdn-pagto as integer ) :
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
  INPUT pcdd-siscomex-dts AS DECIMAL,
  input p-pto-control AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN c-desc-pto-control = "":U.
    
    RUN goToKeyByPto IN h-bocx3842 (INPUT num-di-ems,
                                    INPUT pcdd-siscomex-dts,
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDocumento wMaintenance 
FUNCTION fnDocumento RETURNS CHARACTER
  ( INPUT pCodTipoDocto AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST siscomex-tipo-docto NO-LOCK
         WHERE siscomex-tipo-docto.cod-tipo-docto = pCodTipoDocto NO-ERROR.
    IF AVAIL siscomex-tipo-docto THEN 
        RETURN siscomex-tipo-docto.descricao.
    ELSE 
        RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeAbrev wMaintenance 
FUNCTION fnNomeAbrev RETURNS CHARACTER
  ( input i-cod-emitente as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   ASSIGN c-nome-abrev-emit = "":U.
   
   RUN findCodigo IN h-boad098 (INPUT i-cod-emitente, OUTPUT c-return).
   IF  c-return = "":U THEN
       RUN getCharField IN h-boad098 (input "nome-abrev", OUTPUT c-nome-abrev-emit).

    return c-nome-abrev-emit.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUF wMaintenance 
FUNCTION fnUF RETURNS CHARACTER
  (input pnum-di-ems AS INTEGER,
   INPUT pcdd-siscomex-dts AS DECIMAL,
   input pcdn-pto-control AS INTEGER):
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
                                        INPUT pcdn-pto-control,
                                        INPUT pcdd-siscomex-dts).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnidMedItem wMaintenance 
FUNCTION fnUnidMedItem RETURNS CHARACTER
  ( input c-it-codigo as character) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   ASSIGN c-unid-med = "":U.
   
   RUN findCodigo IN h-boin172 (INPUT c-it-codigo, OUTPUT c-return).
   IF  c-return = "":U THEN
       RUN getCharField IN h-boin172 (input "un", OUTPUT c-unid-med).

    return c-unid-med.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnValores wMaintenance 
FUNCTION fnValores RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN c-valores = "":U.
    FOR EACH bfduimp-docto NO-LOCK
       WHERE bfduimp-docto.cod-duimp-dts  = tt-duimp-docto.cod-duimp-dts
         AND bfduimp-docto.documento      = tt-duimp-docto.documento
         AND bfduimp-docto.seq-docto      = tt-duimp-docto.seq-docto
         AND bfduimp-docto.cod-tipo-docto = tt-duimp-docto.cod-tipo-docto,
       FIRST siscomex-chave NO-LOCK
       WHERE siscomex-chave.cod-chave = bfduimp-docto.cod-chave:
        IF c-valores = "":U THEN 
            ASSIGN c-valores = TRIM(siscomex-chave.descricao) + "|" + TRIM(bfduimp-docto.valor).
        ELSE
            ASSIGN c-valores = c-valores + "|" + TRIM(siscomex-chave.descricao) + "|" + TRIM(bfduimp-docto.valor).
    END.
    RETURN c-valores.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


