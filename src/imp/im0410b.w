&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic NO-UNDO LIKE decla-import-adic
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic-docto NO-UNDO LIKE decla-import-adic-docto
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic-docto-aux NO-UNDO LIKE decla-import-adic-docto
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic-itens NO-UNDO LIKE decla-import-adic-itens
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic-itens-aux NO-UNDO LIKE decla-import-adic-itens
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic-nve NO-UNDO LIKE decla-import-adic-nve
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic-nve-aux NO-UNDO LIKE decla-import-adic-nve
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic-parc NO-UNDO LIKE decla-import-adic-parc
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic-parc-aux NO-UNDO LIKE decla-import-adic-parc
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-despes-adic NO-UNDO LIKE despes-adic
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-despes-adic-aux NO-UNDO LIKE despes-adic
       field r-Rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0410B 2.00.00.047 } /*** "010047" 31/07/2026 16:24:32 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0410B MEX}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM0410B
&GLOBAL-DEFINE Version           2.00.00.047

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Fornecedor,Mercadoria,Itens,Impostos,Impostos 2,Valores,Cƒmbio,Despesa

&GLOBAL-DEFINE ttTable           tt-decla-import-adic
&GLOBAL-DEFINE hDBOTable         h-bocx403
&GLOBAL-DEFINE DBOTable          decla-import-adic

&GLOBAL-DEFINE ttParent          tt-decla-import
&GLOBAL-DEFINE DBOParentTable    h-bocx383

&GLOBAL-DEFINE page0KeyFields    tt-decla-import-adic.num-adic
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-decla-import.num-di-ems tt-decla-import.cod-di-siscomex tt-decla-import.num-seq-retif tt-decla-import.cod-estab tt-decla-import.dat-di
&GLOBAL-DEFINE page1Fields       tt-decla-import-adic.cdn-fornec cb-idi-ind-vincul tt-decla-import-adic.log-emite-fabrican tt-decla-import-adic.cdn-fabrican  
&GLOBAL-DEFINE page2Fields       tt-decla-import-adic.cod-classif-fisc tt-decla-import-adic.cdn-classif-fisc-ex tt-decla-import-adic.cdn-naladi-sist-harmon ~
                                 tt-decla-import-adic.cod-naladi-ncca tt-decla-import-adic.cod-nbm  tt-decla-import-adic.cod-aladi ~
                                 tt-decla-import-adic.cod-licenc-import tt-decla-import-adic.dat-livre-1 ~
                                 cb-idi-metod-val tt-decla-import-adic.cod-tip-recip tt-decla-import-adic.qtd-capac-recip
&GLOBAL-DEFINE page3Fields       tt-decla-import-adic.cod-incoterm tt-decla-import-adic.qtd-ncm tt-decla-import-adic.val-peso-liq tt-decla-import-adic.log-mater-encomen ~
                                 tt-decla-import-adic.log-mater-usado                          
&GLOBAL-DEFINE page4Fields       cb-idi-tributac-impto-import tt-decla-import-adic.val-aliq-ii ~
                                 cb-suspens-impto-import cb-suspens-icms cb-suspens-pis cb-suspens-cofins ~
                                 tt-decla-import-adic.val-perc-reduc-impto-import tt-decla-import-adic.val-base-ii d-valor-impostos-ii cb-idi-tributac-ipi ~
                                 tt-decla-import-adic.val-aliq-ipi cb-suspens-ipi-import tt-decla-import-adic.val-perc-reduc-ipi tt-decla-import-adic.val-unit-ipi ~
                                 tt-decla-import-adic.val-base-ipi d-valor-impostos-ipi cb-idi-tributac-icms tt-decla-import-adic.val-aliq-icms ~
                                 tt-decla-import-adic.val-perc-reduc-icms tt-decla-import-adic.val-base-icms d-valor-impostos-icms cb-idi-tributac-pis ~
                                 tt-decla-import-adic.val-aliq-pis tt-decla-import-adic.val-perc-reduc-pis tt-decla-import-adic.val-unit-pis ~
                                 tt-decla-import-adic.val-base-pis d-valor-impostos-pis cb-idi-tributac-cofins tt-decla-import-adic.val-aliq-cofins ~
                                 tt-decla-import-adic.val-perc-reduc-cofins tt-decla-import-adic.val-unit-cofins tt-decla-import-adic.val-base-cofins d-valor-impostos-cofins ~
                                 label-fcp label-fcp-st label-icms label-icms-compl label-icms-st de-val-aliq-fcp de-val-base-fcp de-val-fcp ~
                                 de-val-aliq-fcp-substto de-val-base-fcp-substto de-val-fcp-substto de-val-base-icms-substto de-val-icms-substto ~
                                 de-val-base-icms-compltar de-val-icms-compltar 
&GLOBAL-DEFINE page5Fields       label-tributac-2 label-aliq-2 label-reduc-2 label-base-calc-2 label-valor-2 ~
                                 label-cst label-class-trib label-ibsuf label-ibsmun label-cbs cb-idi-tributac-ibsuf cb-idi-tributac-ibsmun cb-idi-tributac-cbs ~
                                 de-val-aliq-ibsuf de-val-aliq-ibsmun de-val-aliq-cbs de-perc-reduc-ibsuf de-perc-reduc-ibsmun de-perc-reduc-cbs ~
                                 de-base-ibsuf de-base-ibsmun de-base-cbs de-valor-impostos-ibsuf de-valor-impostos-ibsmun de-valor-impostos-cbs ~
                                 c-cst-ibsuf c-cst-ibsmun c-cst-cbs c-class-trib-ibsuf c-class-trib-ibsmun c-class-trib-cbs ~
                                 label-IS label-aliq-reg label-base-calc-reg label-valor-reg label-class-trib-reg label-cst-reg ~
                                 cb-idi-tributac-is de-val-aliq-is de-val-aliq-espec-is de-qtde-is c-un-trib-is de-base-is de-valor-impostos-is c-class-trib-is c-cst-is
&GLOBAL-DEFINE page6Fields       d-val-vmcv-me1 c-cdn-moed-vmcv d-val-vmcv-me2 d-val-vmcv ~
                                 d-val-vmle-me1 c-cdn-moed-vmle d-val-vmle-me2 d-val-vmle ~
                                 d-val-vmld-me1 c-cdn-moed-vmld d-val-vmld-me2 d-val-vmld ~
                                 d-val-frete-me1 c-cdn-moed-frete d-val-frete-me2 d-val-frete ~
                                 d-val-seguro-me1 c-cdn-moed-seguro d-val-seguro-me2 d-val-seguro ~
                                 d-val-acresc-me1 c-cdn-moed-acresc d-val-acresc-me2 d-val-acresc 
&GLOBAL-DEFINE page7Fields       cb-idi-ind-pagto tt-decla-import-adic.cdn-modal-pagto tt-decla-import-adic.cdn-corretor tt-decla-import-adic.cdn-banco tt-decla-import-adic.log-moed-nac tt-decla-import-adic.cdn-praca tt-decla-import-adic.cod-contrat-cambio tt-decla-import-adic.cdn-agent tt-decla-import-adic.cdn-bco-agent tt-decla-import-adic.cod-agenc-agent tt-decla-import-adic.cod-rof 
&GLOBAL-DEFINE page8Fields       rs-mostra-tela tt-decla-import-adic.dsl-compl-adic

{utp/ut-glob.i}
{cdp/cdcfgmat.i}                        /* Include Pre-processadores */
{cxbo/bocx403.i tt-decla-import-adic-impostos}

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
def new global shared var adm-broker-hdl as handle no-undo.
def var wh-pesquisa as handle  no-undo.
def var iRowsReturned as integer no-undo.
DEF VAR c-desc-un AS CHAR NO-UNDO.
DEF VAR i-cont AS INTEGER NO-UNDO.
DEF VAR c-desc-item AS CHAR FORMAT 'x(40)' NO-UNDO.
DEF VAR i-filtro AS INTEGER NO-UNDO.
DEF VAR l-zoom AS LOGICAL NO-UNDO.
DEFINE VARIABLE c-desc-atributo LIKE nve-atrib.des-atributo NO-UNDO.
DEFINE VARIABLE c-desc-especif LIKE nve-especif.des-especif NO-UNDO.
DEFINE VARIABLE c-desc-nivel AS CHAR FORMAT "X(30)" NO-UNDO.
DEF VAR p-idi-niv AS INT NO-UNDO.
DEF VAR p-cod-atrib AS CHAR NO-UNDO.
DEF VAR p-cod-ident AS CHAR NO-UNDO.
DEF VAR p-cdn-especif AS INT NO-UNDO.
DEF VAR i-ind-pagto-aux AS INT NO-UNDO.
DEF VAR i-banco-agente-aux AS INT NO-UNDO.
DEF VAR c-agencia-agente-aux AS CHAR NO-UNDO.
DEFINE VARIABLE i-num-linha-browse AS INTEGER     NO-UNDO.
DEF VAR i-nr-registro AS INTEGER NO-UNDO.
DEF VAR vRowid-Auxiliar AS ROWID NO-UNDO.
DEF VAR i-conta-reg AS INTEGER NO-UNDO.
DEF VAR rRowid AS ROWID NO-UNDO.

DEF VAR c-desc-despes      LIKE desp-imp.descricao     NO-UNDO. 
DEF VAR c-nome-fornecedor  LIKE emitente.nome-abrev    NO-UNDO. 
DEF VAR c-nome-moeda       LIKE moeda.descricao        NO-UNDO. 
DEF VAR i-pagamento        AS INT                      NO-UNDO.
DEF VAR c-descricao        AS CHAR                     NO-UNDO.
DEF VAR c-return           AS CHAR                     NO-UNDO.

DEF VAR i-cdn-despes-siscomex AS INTEGER NO-UNDO.

DEF VAR i-pagina AS INTEGER NO-UNDO.

DEF VAR l-imposto-alterado AS LOGICAL NO-UNDO.


/* Local Variable Definitions (DBOs Handles) --- */
define variable {&hDBOTable} as handle no-undo.  
define variable h-bocx025     as handle no-undo.  
define variable h-bocx225     as handle no-undo.  
define variable h-bocx225e    as handle no-undo.  
define variable h-bocx351     as handle no-undo.
define variable h-bocx390     as handle no-undo.
define variable h-bocx392     as handle no-undo.  
define variable h-bocx393     as handle no-undo.  
define variable h-bocx394     as handle no-undo.  
define variable h-bocx397     as handle no-undo.  
define variable h-bocx398     as handle no-undo.  
define variable h-bocx402     as handle no-undo.  
define variable h-bocx404     as handle no-undo.  
define variable h-bocx407     as handle no-undo.  
define variable h-boad098     as handle no-undo.  
define variable h-boin172na   as handle no-undo. 
define variable h-boin172desc as handle no-undo.
define variable h-boun005     as handle no-undo.
define variable h-boun006     as handle no-undo.
define variable h-boin245     as handle no-undo.
define variable h-im0410c     as handle no-undo.
DEFINE VARIABLE h-im0410d     AS HANDLE NO-UNDO.
define variable h-bocx383a    as handle no-undo.  
define variable h-bocx389     as handle no-undo.

DEF TEMP-TABLE tt-itens-auxiliar NO-UNDO
    FIELD num-di-ems LIKE decla-import-adic-itens.num-di-ems
    FIELD num-adic   LIKE decla-import-adic-itens.num-adic
    FIELD num-seq    LIKE decla-import-adic-itens.num-seq
    FIELD num-conta  AS INTEGER.

DEF TEMP-TABLE tt-acres-auxiliar NO-UNDO
    FIELD num-di-ems      LIKE despes-adic.num-di-ems
    FIELD num-adic        LIKE despes-adic.num-adic
    FIELD cdn-despes      LIKE despes-adic.cdn-despes
    FIELD cdn-emit-despes LIKE despes-adic.cdn-emit-despes
    FIELD num-conta       AS INTEGER.

DEFINE VARIABLE i-trib-ibsuf  AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE i-trib-ibsmun AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE i-trib-cbs    AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE l-nt2024002   AS LOGICAL           NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brAcres

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-despes-adic-aux ~
tt-decla-import-adic-docto-aux tt-decla-import-adic-itens-aux ~
tt-decla-import-adic-nve-aux tt-decla-import-adic-parc-aux

/* Definitions for BROWSE brAcres                                       */
&Scoped-define FIELDS-IN-QUERY-brAcres tt-despes-adic-aux.cdn-despes fnDescDespes(tt-despes-adic-aux.cdn-despes) @ c-desc-despes tt-despes-adic-aux.cdn-emit-despes fnNomeFornec(tt-despes-adic-aux.cdn-emit-despes) @ c-nome-fornecedor tt-despes-adic-aux.cdn-cond-pag tt-despes-adic-aux.cdn-moeda fnNomeMoeda(tt-despes-adic-aux.cdn-moeda) @ c-nome-moeda tt-despes-adic-aux.val-despes tt-despes-adic-aux.val-cotac-despes-compltar tt-despes-adic-aux.log-forma-preco-compra tt-despes-adic-aux.log-incid-vmle tt-despes-adic-aux.cod-incoterm-rat   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brAcres   
&Scoped-define SELF-NAME brAcres
&Scoped-define QUERY-STRING-brAcres FOR EACH tt-despes-adic-aux BY tt-despes-adic-aux.cdn-despes
&Scoped-define OPEN-QUERY-brAcres OPEN QUERY {&SELF-NAME} FOR EACH tt-despes-adic-aux BY tt-despes-adic-aux.cdn-despes.
&Scoped-define TABLES-IN-QUERY-brAcres tt-despes-adic-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brAcres tt-despes-adic-aux


/* Definitions for BROWSE brDoctoVinc                                   */
&Scoped-define FIELDS-IN-QUERY-brDoctoVinc tt-decla-import-adic-docto-aux.cod-num-docto tt-decla-import-adic-docto-aux.idi-tip-docto-vincul   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDoctoVinc tt-decla-import-adic-docto-aux.cod-num-docto tt-decla-import-adic-docto-aux.idi-tip-docto-vincul VALIDATE(tt-decla-import-adic-docto-aux.idi-tip-docto-vincul = "1" OR ~
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
 ~
 ~
 ~
 ~
 tt-decla-import-adic-docto-aux.idi-tip-docto-vincul = "2", ~
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
 ~
 ~
 ~
 ~
 "Tipo deve ser 1 ou 2")   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDoctoVinc ~
tt-decla-import-adic-docto-aux VALIDATE(tt-decla-import-adic-docto-aux
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDoctoVinc tt-decla-import-adic-docto-aux
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-brDoctoVinc VALIDATE(tt-decla-import-adic-docto-aux
&Scoped-define SELF-NAME brDoctoVinc
&Scoped-define QUERY-STRING-brDoctoVinc FOR EACH tt-decla-import-adic-docto-aux
&Scoped-define OPEN-QUERY-brDoctoVinc OPEN QUERY brDoctoVinc FOR EACH tt-decla-import-adic-docto-aux.
&Scoped-define TABLES-IN-QUERY-brDoctoVinc tt-decla-import-adic-docto-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brDoctoVinc tt-decla-import-adic-docto-aux


/* Definitions for BROWSE brItens                                       */
&Scoped-define FIELDS-IN-QUERY-brItens tt-decla-import-adic-itens-aux.num-seq tt-decla-import-adic-itens-aux.cod-item tt-decla-import-adic-itens-aux.dsl-especif tt-decla-import-adic-itens-aux.qtd-adic[1] fnUN(tt-decla-import-adic-itens-aux.cod-item) @ c-desc-un tt-decla-import-adic-itens-aux.cdn-moeda tt-decla-import-adic-itens-aux.val-vucv tt-decla-import-adic-itens-aux.val-peso-liq tt-decla-import-adic-itens-aux.cod-natur-operac   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brItens   
&Scoped-define SELF-NAME brItens
&Scoped-define QUERY-STRING-brItens FOR EACH tt-decla-import-adic-itens-aux
&Scoped-define OPEN-QUERY-brItens OPEN QUERY brItens FOR EACH tt-decla-import-adic-itens-aux.
&Scoped-define TABLES-IN-QUERY-brItens tt-decla-import-adic-itens-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brItens tt-decla-import-adic-itens-aux


/* Definitions for BROWSE brNVE                                         */
&Scoped-define FIELDS-IN-QUERY-brNVE tt-decla-import-adic-nve-aux.idi-niv fnNivel(tt-decla-import-adic-nve-aux.idi-niv) @ c-desc-nivel tt-decla-import-adic-nve-aux.cod-ident tt-decla-import-adic-nve-aux.cod-atributo fnDescAtributo(tt-decla-import-adic-nve-aux.idi-niv,tt-decla-import-adic-nve-aux.cod-ident,tt-decla-import-adic-nve-aux.cod-atributo) @ c-desc-atributo tt-decla-import-adic-nve-aux.cdn-especif fnDescEspecif(tt-decla-import-adic-nve-aux.idi-niv,tt-decla-import-adic-nve-aux.cod-ident,tt-decla-import-adic-nve-aux.cod-atributo,tt-decla-import-adic-nve-aux.cdn-especif) @ c-desc-especif   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brNVE tt-decla-import-adic-nve-aux.idi-niv   tt-decla-import-adic-nve-aux.cod-ident   tt-decla-import-adic-nve-aux.cod-atributo   tt-decla-import-adic-nve-aux.cdn-especif   
&Scoped-define ENABLED-TABLES-IN-QUERY-brNVE tt-decla-import-adic-nve-aux
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brNVE tt-decla-import-adic-nve-aux
&Scoped-define SELF-NAME brNVE
&Scoped-define QUERY-STRING-brNVE FOR EACH tt-decla-import-adic-nve-aux NO-LOCK
&Scoped-define OPEN-QUERY-brNVE OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-adic-nve-aux NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brNVE tt-decla-import-adic-nve-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brNVE tt-decla-import-adic-nve-aux


/* Definitions for BROWSE brParcelas                                    */
&Scoped-define FIELDS-IN-QUERY-brParcelas tt-decla-import-adic-parc-aux.idi-tip-pagto tt-decla-import-adic-parc-aux.num-seq-parc tt-decla-import-adic-parc-aux.num-mes-parc tt-decla-import-adic-parc-aux.num-ano-parc tt-decla-import-adic-parc-aux.val-parc   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brParcelas tt-decla-import-adic-parc-aux.idi-tip-pagto VALIDATE(tt-decla-import-adic-parc-aux.idi-tip-pagto = "1" OR ~
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
 ~
 ~
tt-decla-import-adic-parc-aux.idi-tip-pagto = "2" OR ~
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
 ~
 ~
tt-decla-import-adic-parc-aux.idi-tip-pagto = "3", ~
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
 ~
 ~
"Tipo deve ser 1, 2 ou 3")   tt-decla-import-adic-parc-aux.num-seq-parc   tt-decla-import-adic-parc-aux.num-mes-parc VALIDATE(tt-decla-import-adic-parc-aux.num-mes-parc = "1" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-decla-import-adic-parc-aux.num-mes-parc = "2" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-decla-import-adic-parc-aux.num-mes-parc = "3" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-decla-import-adic-parc-aux.num-mes-parc = "4" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-decla-import-adic-parc-aux.num-mes-parc = "5" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-decla-import-adic-parc-aux.num-mes-parc = "6" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-decla-import-adic-parc-aux.num-mes-parc = "7" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-decla-import-adic-parc-aux.num-mes-parc = "8" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-decla-import-adic-parc-aux.num-mes-parc = "9" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-decla-import-adic-parc-aux.num-mes-parc = "10" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   tt-decla-import-adic-parc-aux.num-mes-parc = "11" OR ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
tt-decla-import-adic-parc-aux.num-mes-parc = "12", ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
 ~
   "Mˆs deve estar entre 1 e 12")   tt-decla-import-adic-parc-aux.num-ano-parc   tt-decla-import-adic-parc-aux.val-parc   
&Scoped-define ENABLED-TABLES-IN-QUERY-brParcelas ~
tt-decla-import-adic-parc-aux VALIDATE(tt-decla-import-adic-parc-aux
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brParcelas tt-decla-import-adic-parc-aux
&Scoped-define SECOND-ENABLED-TABLE-IN-QUERY-brParcelas VALIDATE(tt-decla-import-adic-parc-aux
&Scoped-define SELF-NAME brParcelas
&Scoped-define QUERY-STRING-brParcelas FOR EACH tt-decla-import-adic-parc-aux NO-LOCK
&Scoped-define OPEN-QUERY-brParcelas OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-adic-parc-aux NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brParcelas tt-decla-import-adic-parc-aux
&Scoped-define FIRST-TABLE-IN-QUERY-brParcelas tt-decla-import-adic-parc-aux


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brDoctoVinc}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brNVE}

/* Definitions for FRAME fpage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage3 ~
    ~{&OPEN-QUERY-brItens}

/* Definitions for FRAME fPage7                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage7 ~
    ~{&OPEN-QUERY-brParcelas}

/* Definitions for FRAME fPage8                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage8 ~
    ~{&OPEN-QUERY-brAcres}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-decla-import.num-di-ems ~
tt-decla-import.cod-di-siscomex tt-decla-import.num-seq-retif ~
tt-decla-import-adic.num-adic tt-decla-import.cod-estab ~
tt-decla-import.dat-di 
&Scoped-define ENABLED-TABLES tt-decla-import tt-decla-import-adic
&Scoped-define FIRST-ENABLED-TABLE tt-decla-import
&Scoped-define SECOND-ENABLED-TABLE tt-decla-import-adic
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-decla-import.num-di-ems ~
tt-decla-import.cod-di-siscomex tt-decla-import.num-seq-retif ~
tt-decla-import-adic.num-adic tt-decla-import.cod-estab ~
tt-decla-import.dat-di 
&Scoped-define DISPLAYED-TABLES tt-decla-import tt-decla-import-adic
&Scoped-define FIRST-DISPLAYED-TABLE tt-decla-import
&Scoped-define SECOND-DISPLAYED-TABLE tt-decla-import-adic
&Scoped-Define DISPLAYED-OBJECTS c-registro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDesc wMaintenanceNoNavigation 
FUNCTION fnDesc RETURNS CHARACTER
  ( c-cod-item as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescAtributo wMaintenanceNoNavigation 
FUNCTION fnDescAtributo RETURNS CHARACTER
  (   pNivel       AS INT,
      pCodIdent    AS CHAR,
      pCodAtributo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescDespes wMaintenanceNoNavigation 
FUNCTION fnDescDespes RETURNS CHARACTER
  ( pCodDespes AS INT ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescEspecif wMaintenanceNoNavigation 
FUNCTION fnDescEspecif RETURNS CHARACTER
  ( pNivel       AS INT,
    pCodIdent    AS CHAR,
    pCodAtributo AS CHAR,
    pCodEspecif  AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNivel wMaintenanceNoNavigation 
FUNCTION fnNivel RETURNS CHARACTER
  ( pCodNivel AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeFornec wMaintenanceNoNavigation 
FUNCTION fnNomeFornec RETURNS CHARACTER
  ( pCodFornec AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeMoeda wMaintenanceNoNavigation 
FUNCTION fnNomeMoeda RETURNS CHARACTER
  ( pCodMoeda AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUN wMaintenanceNoNavigation 
FUNCTION fnUN RETURNS CHARACTER
  ( c-cod-item as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-nex 
     IMAGE-UP FILE "image/im-nex":U
     IMAGE-INSENSITIVE FILE "image/ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.

DEFINE BUTTON bt-pre 
     IMAGE-UP FILE "image/im-pre":U
     IMAGE-INSENSITIVE FILE "image/ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-registro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Registro" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.42.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btAddDocumento 
     IMAGE-UP FILE "image/im-add.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-add.bmp":U
     LABEL "Adiciona Processo Vinculado" 
     SIZE 4 BY 1.25 TOOLTIP "Adiciona Processo Vinculado"
     FONT 4.

DEFINE BUTTON btCanDocumento 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Cancela InclusÆo Processo Vinculado"
     FONT 4.

DEFINE BUTTON btDelDocumento 
     IMAGE-UP FILE "image/im-era.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-era.bmp":U
     LABEL "Excluir" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSaveDocumento 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Salva Processo Vinculado"
     FONT 4.

DEFINE VARIABLE cb-idi-ind-vincul AS CHARACTER FORMAT "X(256)":U 
     LABEL "Indicativo de Vincula‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE c-nome-fabrican AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE label-docto AS CHARACTER FORMAT "X(256)":U INITIAL "Documento Vinculado" 
      VIEW-AS TEXT 
     SIZE 16 BY .58 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.33.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.5.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 5.25.

DEFINE RECTANGLE RECT-77
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28 BY 3.

DEFINE BUTTON btAddNVE 
     IMAGE-UP FILE "image/im-add.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-add.bmp":U
     LABEL "Adiciona NVE" 
     SIZE 4 BY 1.25 TOOLTIP "Adiciona Processo Vinculado"
     FONT 4.

DEFINE BUTTON btCanNVE 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Cancela InclusÆo Processo Vinculado"
     FONT 4.

DEFINE BUTTON btDelNVE 
     IMAGE-UP FILE "image/im-era.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-era.bmp":U
     LABEL "Excluir" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSaveNVE 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Salva Processo Vinculado"
     FONT 4.

DEFINE VARIABLE cb-idi-metod-val AS CHARACTER FORMAT "X(256)":U 
     LABEL "M‚todo Valora‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-class-fis AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54.57 BY .88 NO-UNDO.

DEFINE VARIABLE label-NVE AS CHARACTER FORMAT "X(256)":U INITIAL "NVE" 
      VIEW-AS TEXT 
     SIZE 4 BY .67 NO-UNDO.

DEFINE VARIABLE label-recip AS CHARACTER FORMAT "X(256)":U INITIAL "Recipiente" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 5.25.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 1.25.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 1.29.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 3.33.

DEFINE BUTTON btModificaItens 
     LABEL "Modificar" 
     SIZE 17 BY 1.

DEFINE VARIABLE c-desc-incoterm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-ncm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16.86 BY 2.21.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 2.75.

DEFINE VARIABLE cb-idi-tributac-cofins AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-icms AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-impto-import AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-ipi AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-pis AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-cofins AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","NÆo" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-icms AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","NÆo" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-impto-import AS CHARACTER FORMAT "X(256)":U INITIAL "NÆo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","NÆo" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-ipi-import AS CHARACTER FORMAT "X(256)":U INITIAL "NÆo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","NÆo" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-pis AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","NÆo" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE d-valor-impostos-cofins AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE d-valor-impostos-icms AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE d-valor-impostos-ii AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE d-valor-impostos-ipi AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE d-valor-impostos-pis AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE de-val-aliq-fcp AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-aliq-fcp-substto AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE de-val-base-fcp AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-base-fcp-substto AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-base-icms-compltar AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-base-icms-substto AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-fcp AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-fcp-substto AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-icms-compltar AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-icms-substto AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE label-aliq AS CHARACTER FORMAT "X(256)":U INITIAL "Al¡quota" 
      VIEW-AS TEXT 
     SIZE 6.57 BY .67 NO-UNDO.

DEFINE VARIABLE label-base-calc AS CHARACTER FORMAT "X(256)":U INITIAL "Base C lculo" 
      VIEW-AS TEXT 
     SIZE 9.57 BY .67 NO-UNDO.

DEFINE VARIABLE label-cofins AS CHARACTER FORMAT "X(256)":U INITIAL "COFINS" 
      VIEW-AS TEXT 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE label-fcp AS CHARACTER FORMAT "X(256)":U INITIAL "FCP" 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE label-fcp-st AS CHARACTER FORMAT "X(256)":U INITIAL "FCP ST" 
      VIEW-AS TEXT 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE VARIABLE label-icms AS CHARACTER FORMAT "X(256)":U INITIAL "ICMS" 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE label-icms-compl AS CHARACTER FORMAT "X(256)":U INITIAL "ICMS Compl" 
      VIEW-AS TEXT 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE VARIABLE label-icms-st AS CHARACTER FORMAT "X(256)":U INITIAL "ICMS ST" 
      VIEW-AS TEXT 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE VARIABLE label-ii AS CHARACTER FORMAT "X(256)":U INITIAL "II" 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE label-ipi AS CHARACTER FORMAT "X(256)":U INITIAL "IPI" 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE label-pis AS CHARACTER FORMAT "X(256)":U INITIAL "PIS" 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE label-reduc AS CHARACTER FORMAT "X(256)":U INITIAL "Redu‡Æo" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE label-susp AS CHARACTER FORMAT "X(256)":U INITIAL "Suspenso" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE label-tributac AS CHARACTER FORMAT "X(256)":U INITIAL "Tributa‡Æo" 
      VIEW-AS TEXT 
     SIZE 8.43 BY .67 NO-UNDO.

DEFINE VARIABLE label-valor AS CHARACTER FORMAT "X(256)":U INITIAL "Valor" 
      VIEW-AS TEXT 
     SIZE 4.29 BY .67 NO-UNDO.

DEFINE VARIABLE label-vl-unit AS CHARACTER FORMAT "X(256)":U INITIAL "Vl. Unit. Imp." 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.29 BY 10.5.

DEFINE VARIABLE cb-idi-tributac-cbs AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-ibsmun AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-ibsuf AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-is AS CHARACTER FORMAT "X(256)" 
     LABEL "Tributa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-class-trib-cbs AS CHARACTER FORMAT "X(09)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-ibsmun AS CHARACTER FORMAT "X(09)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-ibsuf AS CHARACTER FORMAT "X(09)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-is AS CHARACTER FORMAT "X(09)":U 
     LABEL "Class Trib" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-reg-cbs AS CHARACTER FORMAT "X(09)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-reg-ibsmun AS CHARACTER FORMAT "X(09)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-reg-ibsuf AS CHARACTER FORMAT "X(09)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-cbs AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-ibsmun AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-ibsuf AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-is AS CHARACTER FORMAT "X(09)":U 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-reg-cbs AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-reg-ibsmun AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-reg-ibsuf AS CHARACTER FORMAT "X(03)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-trib-is AS CHARACTER FORMAT "X(09)":U 
     LABEL "Un Tribut vel" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-base-cbs AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-base-ibsmun AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-base-ibsuf AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-base-is AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Base C lculo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-base-reg-cbs AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-base-reg-ibsmun AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-base-reg-ibsuf AS DECIMAL FORMAT ">,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-perc-reduc-cbs AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-perc-reduc-ibsmun AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-perc-reduc-ibsuf AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-qtde-is AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Qtde Tribut vel" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-cbs AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-espec-is AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Aliq Espec Un" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-ibsmun AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-ibsuf AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-is AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Al¡quota" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-reg-cbs AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-reg-ibsmun AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-val-aliq-reg-ibsuf AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-valor-impostos-cbs AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-valor-impostos-ibsmun AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-valor-impostos-ibsuf AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-impostos-is AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-impostos-reg-cbs AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-valor-impostos-reg-ibsmun AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE de-valor-impostos-reg-ibsuf AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE label-aliq-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Al¡quota" 
      VIEW-AS TEXT 
     SIZE 6.43 BY .67 NO-UNDO.

DEFINE VARIABLE label-aliq-Reg AS CHARACTER FORMAT "X(20)":U INITIAL "Al¡quota" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE label-base-calc-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Base C lculo" 
      VIEW-AS TEXT 
     SIZE 9.57 BY .67 NO-UNDO.

DEFINE VARIABLE label-base-calc-Reg AS CHARACTER FORMAT "X(20)":U INITIAL "Base C lculo" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE label-CBS AS CHARACTER FORMAT "X(256)":U INITIAL "CBS" 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE label-class-trib AS CHARACTER FORMAT "X(10)":U INITIAL "Class Trib" 
      VIEW-AS TEXT 
     SIZE 7.29 BY .67 NO-UNDO.

DEFINE VARIABLE label-class-trib-Reg AS CHARACTER FORMAT "X(18)":U INITIAL "Class Trib" 
      VIEW-AS TEXT 
     SIZE 6.72 BY .67 NO-UNDO.

DEFINE VARIABLE label-cst AS CHARACTER FORMAT "X(5)":U INITIAL "CST" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE label-cst-Reg AS CHARACTER FORMAT "X(11)":U INITIAL "CST" 
      VIEW-AS TEXT 
     SIZE 3.14 BY .67 NO-UNDO.

DEFINE VARIABLE label-IBSMUN AS CHARACTER FORMAT "X(256)":U INITIAL "IBS Mun" 
      VIEW-AS TEXT 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE VARIABLE label-IBSUF AS CHARACTER FORMAT "X(256)":U INITIAL "IBS UF" 
      VIEW-AS TEXT 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE label-IS AS CHARACTER FORMAT "X(256)":U INITIAL "IS" 
      VIEW-AS TEXT 
     SIZE 2 BY .88 NO-UNDO.

DEFINE VARIABLE label-reduc-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Redu‡Æo" 
      VIEW-AS TEXT 
     SIZE 6.86 BY .67 NO-UNDO.

DEFINE VARIABLE label-tributac-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Tributa‡Æo" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE label-valor-2 AS CHARACTER FORMAT "X(20)":U INITIAL "Valor" 
      VIEW-AS TEXT 
     SIZE 4.29 BY .67 NO-UNDO.

DEFINE VARIABLE label-valor-Reg AS CHARACTER FORMAT "X(20)":U INITIAL "Valor" 
      VIEW-AS TEXT 
     SIZE 3.72 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-78
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 5.46.

DEFINE RECTANGLE RECT-79
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 10.75.

DEFINE VARIABLE c-cdn-moed-acresc AS CHARACTER FORMAT "X(256)" INITIAL "0" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE c-cdn-moed-frete AS CHARACTER FORMAT "X(256)" INITIAL "0" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE c-cdn-moed-seguro AS CHARACTER FORMAT "X(256)" INITIAL "0" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE c-cdn-moed-vmcv AS CHARACTER FORMAT "X(256)" INITIAL "0" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE c-cdn-moed-vmld AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cdn-moed-vmle AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-acresc AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE d-val-acresc-me1 AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE d-val-acresc-me2 AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-frete AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE d-val-frete-me1 AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-frete-me2 AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE d-val-seguro AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE d-val-seguro-me1 AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-seguro-me2 AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE d-val-vmcv AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE d-val-vmcv-me1 AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-vmcv-me2 AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE d-val-vmld AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE d-val-vmld-me1 AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-vmld-me2 AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE d-val-vmle AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE d-val-vmle-me1 AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-vmle-me2 AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99999999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE label-acresc AS CHARACTER FORMAT "X(256)":U INITIAL "Acr‚scimos" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE VARIABLE label-dolar AS CHARACTER FORMAT "X(256)":U INITIAL "D¢lar (US$)" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE label-frete AS CHARACTER FORMAT "X(256)":U INITIAL "Frete" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE VARIABLE label-moeda AS CHARACTER FORMAT "X(256)":U INITIAL "Moeda" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE label-reais AS CHARACTER FORMAT "X(256)":U INITIAL "Reais (R$)" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE label-seguro AS CHARACTER FORMAT "X(256)":U INITIAL "Seguro" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE VARIABLE label-valores AS CHARACTER FORMAT "X(256)":U INITIAL "Valor" 
      VIEW-AS TEXT 
     SIZE 4 BY .67 NO-UNDO.

DEFINE VARIABLE label-vmcv AS CHARACTER FORMAT "X(256)":U INITIAL "VMCV" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE VARIABLE label-vmld AS CHARACTER FORMAT "X(256)":U INITIAL "VMLD" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE VARIABLE label-vmle AS CHARACTER FORMAT "X(256)":U INITIAL "VMLE" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE BUTTON btAddParcela 
     IMAGE-UP FILE "image/im-add.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-add.bmp":U
     LABEL "Adiciona NVE" 
     SIZE 4 BY 1.25 TOOLTIP "Adiciona Processo Vinculado"
     FONT 4.

DEFINE BUTTON btCanParcela 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Cancela InclusÆo Processo Vinculado"
     FONT 4.

DEFINE BUTTON btDelParcela 
     IMAGE-UP FILE "image/im-era.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-era.bmp":U
     LABEL "Excluir" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSaveParcela 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Salva Processo Vinculado"
     FONT 4.

DEFINE VARIABLE cb-idi-ind-pagto AS CHARACTER FORMAT "X(256)" 
     LABEL "Pagamento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 41 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-agente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-corretor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .88 NO-UNDO.

DEFINE VARIABLE label-parc AS CHARACTER FORMAT "X(256)":U INITIAL "Parcelas" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.25.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 8.29.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 3.96.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 1.21.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 3.04.

DEFINE BUTTON btAltAcres 
     LABEL "Alterar" 
     SIZE 17 BY 1.

DEFINE BUTTON btExcAcres 
     LABEL "Excluir" 
     SIZE 17 BY 1.

DEFINE BUTTON btIncAcres 
     LABEL "Incluir" 
     SIZE 17 BY 1.

DEFINE VARIABLE rs-mostra-tela AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Acr‚scimos", 1,
"Complemento", 2
     SIZE 31 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 9.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brAcres FOR 
      tt-despes-adic-aux SCROLLING.

DEFINE QUERY brDoctoVinc FOR 
      tt-decla-import-adic-docto-aux SCROLLING.

DEFINE QUERY brItens FOR 
      tt-decla-import-adic-itens-aux SCROLLING.

DEFINE QUERY brNVE FOR 
      tt-decla-import-adic-nve-aux SCROLLING.

DEFINE QUERY brParcelas FOR 
      tt-decla-import-adic-parc-aux SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brAcres
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brAcres wMaintenanceNoNavigation _FREEFORM
  QUERY brAcres DISPLAY
      tt-despes-adic-aux.cdn-despes COLUMN-LABEL 'Despesa':U
      fnDescDespes(tt-despes-adic-aux.cdn-despes) @ c-desc-despes COLUMN-LABEL 'Descri‡Æo':U
      tt-despes-adic-aux.cdn-emit-despes COLUMN-LABEL 'Fornecedor':U
      fnNomeFornec(tt-despes-adic-aux.cdn-emit-despes) @ c-nome-fornecedor COLUMN-LABEL 'Nome Fornecedor':U
      tt-despes-adic-aux.cdn-cond-pag COLUMN-LABEL 'Condi‡Æo Pagamento':U
      tt-despes-adic-aux.cdn-moeda COLUMN-LABEL 'Moeda':U
      fnNomeMoeda(tt-despes-adic-aux.cdn-moeda) @ c-nome-moeda COLUMN-LABEL 'Descri‡Æo':U
      tt-despes-adic-aux.val-despes COLUMN-LABEL 'Valor Despesa':U
      tt-despes-adic-aux.val-cotac-despes-compltar COLUMN-LABEL 'Cota‡Æo Desp.Compl.':U
      tt-despes-adic-aux.log-forma-preco-compra COLUMN-LABEL 'Forma Pre‡o Compra':U
      tt-despes-adic-aux.log-incid-vmle COLUMN-LABEL 'Incide VMLE':U
      tt-despes-adic-aux.cod-incoterm-rat COLUMN-LABEL 'Incoterm de Rateio':U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 80 BY 7.5
         FONT 2.

DEFINE BROWSE brDoctoVinc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDoctoVinc wMaintenanceNoNavigation _FREEFORM
  QUERY brDoctoVinc DISPLAY
      tt-decla-import-adic-docto-aux.cod-num-docto
tt-decla-import-adic-docto-aux.idi-tip-docto-vincul
ENABLE
tt-decla-import-adic-docto-aux.cod-num-docto
tt-decla-import-adic-docto-aux.idi-tip-docto-vincul HELP "1-Declara‡Æo de Importa‡Æo 2-Registro de Exporta‡Æo" VALIDATE(tt-decla-import-adic-docto-aux.idi-tip-docto-vincul = "1" OR 
                                                                                                                        tt-decla-import-adic-docto-aux.idi-tip-docto-vincul = "2",
                                                                                                                        "Tipo deve ser 1 ou 2")
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 40 BY 4.75
         BGCOLOR 15 FONT 2 FIT-LAST-COLUMN.

DEFINE BROWSE brItens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brItens wMaintenanceNoNavigation _FREEFORM
  QUERY brItens DISPLAY
      tt-decla-import-adic-itens-aux.num-seq COLUMN-LABEL 'Seq'
      tt-decla-import-adic-itens-aux.cod-item COLUMN-LABEL 'Item'
      tt-decla-import-adic-itens-aux.dsl-especif COLUMN-LABEL 'Especifica‡Æo' WIDTH 40
      tt-decla-import-adic-itens-aux.qtd-adic[1] COLUMN-LABEL 'Quantidade'
      fnUN(tt-decla-import-adic-itens-aux.cod-item) @ c-desc-un COLUMN-LABEL 'Un'
      tt-decla-import-adic-itens-aux.cdn-moeda COLUMN-LABEL 'Moeda'
      tt-decla-import-adic-itens-aux.val-vucv COLUMN-LABEL 'VUCV'
      tt-decla-import-adic-itens-aux.val-peso-liq COLUMN-LABEL 'Peso L¡quido'
      tt-decla-import-adic-itens-aux.cod-natur-operac COLUMN-LABEL 'Natur Oper'
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 85 BY 7.42
         BGCOLOR 15 FONT 2 FIT-LAST-COLUMN.

DEFINE BROWSE brNVE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brNVE wMaintenanceNoNavigation _FREEFORM
  QUERY brNVE DISPLAY
      tt-decla-import-adic-nve-aux.idi-niv      column-label 'N¡vel':U
    fnNivel(tt-decla-import-adic-nve-aux.idi-niv) @ c-desc-nivel COLUMN-LABEL "Descri‡Æo" WIDTH 13
    tt-decla-import-adic-nve-aux.cod-ident    column-label 'Identifica‡Æo':U
    tt-decla-import-adic-nve-aux.cod-atributo column-label 'Atributo':U
    fnDescAtributo(tt-decla-import-adic-nve-aux.idi-niv,tt-decla-import-adic-nve-aux.cod-ident,tt-decla-import-adic-nve-aux.cod-atributo) @ c-desc-atributo COLUMN-LABEL "Descri‡Æo" WIDTH 20
    tt-decla-import-adic-nve-aux.cdn-especif  column-label 'Especifica‡Æo':U
    fnDescEspecif(tt-decla-import-adic-nve-aux.idi-niv,tt-decla-import-adic-nve-aux.cod-ident,tt-decla-import-adic-nve-aux.cod-atributo,tt-decla-import-adic-nve-aux.cdn-especif) @ c-desc-especif COLUMN-LABEL "Descri‡Æo" WIDTH 20
          ENABLE
    tt-decla-import-adic-nve-aux.idi-niv
    tt-decla-import-adic-nve-aux.cod-ident
    tt-decla-import-adic-nve-aux.cod-atributo
    tt-decla-import-adic-nve-aux.cdn-especif
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78.57 BY 4.5
         BGCOLOR 15 FONT 2.

DEFINE BROWSE brParcelas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brParcelas wMaintenanceNoNavigation _FREEFORM
  QUERY brParcelas NO-LOCK DISPLAY
      tt-decla-import-adic-parc-aux.idi-tip-pagto 
    tt-decla-import-adic-parc-aux.num-seq-parc        
    tt-decla-import-adic-parc-aux.num-mes-parc        
    tt-decla-import-adic-parc-aux.num-ano-parc        
    tt-decla-import-adic-parc-aux.val-parc            
    ENABLE 
    tt-decla-import-adic-parc-aux.idi-tip-pagto HELP "1- · Vista  2- Antecipado  3- Parcela" VALIDATE(tt-decla-import-adic-parc-aux.idi-tip-pagto = "1" OR 
                                                                                                      tt-decla-import-adic-parc-aux.idi-tip-pagto = "2" OR
                                                                                                      tt-decla-import-adic-parc-aux.idi-tip-pagto = "3",
                                                                                                      "Tipo deve ser 1, 2 ou 3")
    tt-decla-import-adic-parc-aux.num-seq-parc
    tt-decla-import-adic-parc-aux.num-mes-parc  HELP "Meses do ano" VALIDATE(tt-decla-import-adic-parc-aux.num-mes-parc = "1"  OR
                                                                             tt-decla-import-adic-parc-aux.num-mes-parc = "2"  OR
                                                                             tt-decla-import-adic-parc-aux.num-mes-parc = "3"  OR
                                                                             tt-decla-import-adic-parc-aux.num-mes-parc = "4"  OR
                                                                             tt-decla-import-adic-parc-aux.num-mes-parc = "5"  OR
                                                                             tt-decla-import-adic-parc-aux.num-mes-parc = "6"  OR
                                                                             tt-decla-import-adic-parc-aux.num-mes-parc = "7"  OR
                                                                             tt-decla-import-adic-parc-aux.num-mes-parc = "8"  OR
                                                                             tt-decla-import-adic-parc-aux.num-mes-parc = "9"  OR
                                                                             tt-decla-import-adic-parc-aux.num-mes-parc = "10" OR
                                                                             tt-decla-import-adic-parc-aux.num-mes-parc = "11" OR 
                                                                             tt-decla-import-adic-parc-aux.num-mes-parc = "12",
                                                                             "Mˆs deve estar entre 1 e 12")
    tt-decla-import-adic-parc-aux.num-ano-parc
    tt-decla-import-adic-parc-aux.val-parc
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 35 BY 7
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-decla-import.num-di-ems AT ROW 1.25 COL 10 COLON-ALIGNED
          LABEL "DI EMS"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-decla-import.cod-di-siscomex AT ROW 1.25 COL 35.57 COLON-ALIGNED
          LABEL "DI Siscomex"
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     tt-decla-import.num-seq-retif AT ROW 1.25 COL 56.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-decla-import-adic.num-adic AT ROW 1.25 COL 71 COLON-ALIGNED
          LABEL "Adi‡Æo"
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .88
     tt-decla-import.cod-estab AT ROW 2.25 COL 10 COLON-ALIGNED
          LABEL "Estab"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-decla-import.dat-di AT ROW 2.25 COL 35.57 COLON-ALIGNED
          LABEL "Data DI"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-registro AT ROW 2.25 COL 71 COLON-ALIGNED
     bt-pre AT ROW 19.13 COL 52 HELP
          "Ocorrˆncia anterior"
     bt-nex AT ROW 19.13 COL 56.43 HELP
          "Pr¢xima ocorrˆncia"
     btOK AT ROW 19.33 COL 2
     btSave AT ROW 19.33 COL 13
     btCancel AT ROW 19.33 COL 24
     btHelp AT ROW 19.33 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 19.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.72 BY 19.5
         FONT 1.

DEFINE FRAME fPage4
     cb-idi-tributac-impto-import AT ROW 2.5 COL 8 COLON-ALIGNED HELP
          "Informar a Tributa‡Æo do Imposto de Importa‡Æo" NO-LABEL WIDGET-ID 176
     tt-decla-import-adic.val-aliq-ii AT ROW 2.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 232 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-impto-import AT ROW 2.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 186
     tt-decla-import-adic.val-perc-reduc-impto-import AT ROW 2.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 252 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic.val-base-ii AT ROW 2.5 COL 51.72 COLON-ALIGNED NO-LABEL WIDGET-ID 242 FORMAT ">,>>>,>>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-ii AT ROW 2.5 COL 66.57 COLON-ALIGNED HELP
          "Valor II" NO-LABEL WIDGET-ID 196
     cb-idi-tributac-ipi AT ROW 3.5 COL 8 COLON-ALIGNED HELP
          "C¢digo de tributa‡Æo do IPI" NO-LABEL WIDGET-ID 178
     tt-decla-import-adic.val-aliq-ipi AT ROW 3.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 234 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-ipi-import AT ROW 3.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 188
     tt-decla-import-adic.val-perc-reduc-ipi AT ROW 3.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 254 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic.val-unit-ipi AT ROW 3.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 260
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-decla-import-adic.val-base-ipi AT ROW 3.5 COL 51.72 COLON-ALIGNED NO-LABEL WIDGET-ID 244 FORMAT ">,>>>,>>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-ipi AT ROW 3.5 COL 66.57 COLON-ALIGNED HELP
          "Valor IPI" NO-LABEL WIDGET-ID 198
     cb-idi-tributac-icms AT ROW 4.5 COL 8 COLON-ALIGNED HELP
          "C¢digo de tributa‡Æo do ICMS" NO-LABEL WIDGET-ID 174
     tt-decla-import-adic.val-aliq-icms AT ROW 4.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 230 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-icms AT ROW 4.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 184
     tt-decla-import-adic.val-perc-reduc-icms AT ROW 4.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 250 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic.val-base-icms AT ROW 4.5 COL 51.72 COLON-ALIGNED NO-LABEL WIDGET-ID 240 FORMAT ">,>>>,>>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-icms AT ROW 4.5 COL 66.57 COLON-ALIGNED HELP
          "Valor ICMS" NO-LABEL WIDGET-ID 194
     cb-idi-tributac-pis AT ROW 5.5 COL 8 COLON-ALIGNED HELP
          "C¢digo de Tributa‡Æo PIS" NO-LABEL WIDGET-ID 180
     tt-decla-import-adic.val-aliq-pis AT ROW 5.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 236 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-pis AT ROW 5.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 190
     tt-decla-import-adic.val-perc-reduc-pis AT ROW 5.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 256 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic.val-unit-pis AT ROW 5.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 262 FORMAT ">>,>>>,>>>,>>>,>>9.99999"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 4.7
         SIZE 88 BY 13.7
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage4
     tt-decla-import-adic.val-base-pis AT ROW 5.5 COL 51.72 COLON-ALIGNED NO-LABEL WIDGET-ID 246 FORMAT ">,>>>,>>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-pis AT ROW 5.5 COL 66.57 COLON-ALIGNED HELP
          "Valor PIS" NO-LABEL WIDGET-ID 200
     cb-idi-tributac-cofins AT ROW 6.5 COL 8 COLON-ALIGNED HELP
          "C¢digo de Tributa‡Æo COFINS" NO-LABEL WIDGET-ID 172
     tt-decla-import-adic.val-aliq-cofins AT ROW 6.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 228 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-cofins AT ROW 6.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 182
     tt-decla-import-adic.val-perc-reduc-cofins AT ROW 6.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 248 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic.val-unit-cofins AT ROW 6.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 258 FORMAT ">>,>>>,>>>,>>>,>>>,>>9.99999"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-decla-import-adic.val-base-cofins AT ROW 6.5 COL 51.72 COLON-ALIGNED NO-LABEL WIDGET-ID 238 FORMAT ">,>>>,>>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-cofins AT ROW 6.5 COL 66.57 COLON-ALIGNED HELP
          "Valor Cofins" NO-LABEL WIDGET-ID 192
     de-val-aliq-fcp AT ROW 7.5 COL 21 COLON-ALIGNED HELP
          "Al¡quota Fundo de Combate … Pobreza" NO-LABEL WIDGET-ID 154
     de-val-base-fcp AT ROW 7.5 COL 51.72 COLON-ALIGNED HELP
          "Base de C lculo do Fundo de Combate … Pobreza" NO-LABEL WIDGET-ID 158
     de-val-fcp AT ROW 7.5 COL 66.57 COLON-ALIGNED HELP
          "Valor Fundo de Combate … Pobreza" NO-LABEL WIDGET-ID 164
     de-val-aliq-fcp-substto AT ROW 8.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 156
     de-val-base-fcp-substto AT ROW 8.5 COL 51.72 COLON-ALIGNED HELP
          "Base do FCP ST" NO-LABEL WIDGET-ID 160
     de-val-fcp-substto AT ROW 8.5 COL 66.57 COLON-ALIGNED HELP
          "Valor do FCP ST" NO-LABEL WIDGET-ID 166
     de-val-base-icms-substto AT ROW 9.5 COL 51.72 COLON-ALIGNED HELP
          "Base ICMS Substituto" NO-LABEL WIDGET-ID 134
     de-val-icms-substto AT ROW 9.5 COL 66.57 COLON-ALIGNED HELP
          "Valor ICMS Substituto" NO-LABEL WIDGET-ID 170
     de-val-base-icms-compltar AT ROW 10.5 COL 51.72 COLON-ALIGNED HELP
          "Base ICMS Complementar" NO-LABEL WIDGET-ID 162
     de-val-icms-compltar AT ROW 10.5 COL 66.57 COLON-ALIGNED HELP
          "Valor ICMS Complementar" NO-LABEL WIDGET-ID 168
     label-tributac AT ROW 1.5 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 220
     label-aliq AT ROW 1.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 202
     label-susp AT ROW 1.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 218
     label-reduc AT ROW 1.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 216
     label-vl-unit AT ROW 1.5 COL 43.57 COLON-ALIGNED NO-LABEL WIDGET-ID 224
     label-base-calc AT ROW 1.5 COL 54.43 COLON-ALIGNED NO-LABEL WIDGET-ID 204
     label-valor AT ROW 1.5 COL 72.14 COLON-ALIGNED NO-LABEL WIDGET-ID 222
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 4.7
         SIZE 88 BY 13.7
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage4
     label-ii AT ROW 2.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 210
     label-ipi AT ROW 3.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 212
     label-icms AT ROW 4.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 208
     label-pis AT ROW 5.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 214
     label-cofins AT ROW 6.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 206
     label-fcp AT ROW 7.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 146
     label-fcp-st AT ROW 8.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 148
     label-icms-st AT ROW 9.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 152
     label-icms-compl AT ROW 10.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 150
     RECT-21 AT ROW 1.25 COL 2 WIDGET-ID 226
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 4.7
         SIZE 88 BY 13.7
         FONT 1.

DEFINE FRAME fPage1
     tt-decla-import-adic.cdn-fornec AT ROW 1.5 COL 19 COLON-ALIGNED
          LABEL "Fornecedor"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-nome-fornec AT ROW 1.5 COL 30.14 COLON-ALIGNED NO-LABEL
     cb-idi-ind-vincul AT ROW 2.5 COL 19 COLON-ALIGNED
     tt-decla-import-adic.log-emite-fabrican AT ROW 4 COL 21
          LABEL "Fornecedor ‚ Fabricante"
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     tt-decla-import-adic.cdn-fabrican AT ROW 5 COL 19 COLON-ALIGNED
          LABEL "Fabricante"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-nome-fabrican AT ROW 5 COL 30.14 COLON-ALIGNED NO-LABEL
     btAddDocumento AT ROW 6.75 COL 43.72 HELP
          "Confirma altera‡äes"
     brDoctoVinc AT ROW 6.83 COL 3
     btCanDocumento AT ROW 7.96 COL 43.72 HELP
          "Confirma altera‡äes"
     btSaveDocumento AT ROW 9.17 COL 43.72 HELP
          "Confirma altera‡äes"
     btDelDocumento AT ROW 10.38 COL 43.72 HELP
          "Confirma altera‡äes"
     label-docto AT ROW 6.25 COL 2 COLON-ALIGNED NO-LABEL
     "Tipos Documento Vinculado" VIEW-AS TEXT
          SIZE 20 BY .54 AT ROW 7.5 COL 54.86
     "1 - Declara‡Æo de Importa‡Æo [ DI ]" VIEW-AS TEXT
          SIZE 25 BY .54 AT ROW 8.75 COL 53.86
     "2 - Registro de Exporta‡Æo [ RE ]" VIEW-AS TEXT
          SIZE 25 BY .54 AT ROW 9.75 COL 53.86
     RECT-13 AT ROW 1.25 COL 2
     RECT-14 AT ROW 3.75 COL 2
     RECT-15 AT ROW 6.5 COL 2
     RECT-77 AT ROW 7.75 COL 51.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 4.7
         SIZE 88 BY 13.7
         FONT 1.

DEFINE FRAME fPage2
     tt-decla-import-adic.cod-classif-fisc AT ROW 1.5 COL 12.57 COLON-ALIGNED
          LABEL "Class Fiscal"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-decla-import-adic.cdn-classif-fisc-ex AT ROW 1.5 COL 24.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-desc-class-fis AT ROW 1.5 COL 28.86 COLON-ALIGNED NO-LABEL
     tt-decla-import-adic.cdn-naladi-sist-harmon AT ROW 2.5 COL 12.57 COLON-ALIGNED
          LABEL "NALADI/SH"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-decla-import-adic.cod-naladi-ncca AT ROW 2.5 COL 40.14 COLON-ALIGNED
          LABEL "NALADI/NCCA"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-decla-import-adic.cod-nbm AT ROW 2.5 COL 71.43 COLON-ALIGNED
          LABEL "NBM"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-decla-import-adic.cod-aladi AT ROW 3.5 COL 12.57 COLON-ALIGNED
          LABEL "Acordo ALADI"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-decla-import-adic.cod-licenc-import AT ROW 3.5 COL 30.14 COLON-ALIGNED
          LABEL "LI"
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     tt-decla-import-adic.dat-livre-1 AT ROW 3.5 COL 71.43 COLON-ALIGNED HELP
          "Data Restri‡Æo Embarque" WIDGET-ID 2
          LABEL "Dt Restri‡Æo Embarque" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     btAddNVE AT ROW 5.17 COL 81.43 HELP
          "Confirma altera‡äes" WIDGET-ID 6
     brNVE AT ROW 5.5 COL 2.43 WIDGET-ID 100
     btCanNVE AT ROW 6.38 COL 81.43 HELP
          "Confirma altera‡äes" WIDGET-ID 8
     btSaveNVE AT ROW 7.58 COL 81.43 HELP
          "Confirma altera‡äes" WIDGET-ID 12
     btDelNVE AT ROW 8.79 COL 81.43 HELP
          "Confirma altera‡äes" WIDGET-ID 10
     cb-idi-metod-val AT ROW 10.54 COL 14.57 COLON-ALIGNED WIDGET-ID 18
     tt-decla-import-adic.cod-tip-recip AT ROW 12.17 COL 14.57 COLON-ALIGNED WIDGET-ID 20
          LABEL "Tipo"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     tt-decla-import-adic.qtd-capac-recip AT ROW 12.17 COL 55 COLON-ALIGNED WIDGET-ID 24
          LABEL "Capacidade (ml)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     label-NVE AT ROW 4.71 COL 3.43 NO-LABEL WIDGET-ID 14
     label-recip AT ROW 11.67 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     RECT-4 AT ROW 1.25 COL 1.57
     RECT-17 AT ROW 4.96 COL 1.57 WIDGET-ID 16
     RECT-18 AT ROW 12 COL 1.57 WIDGET-ID 26
     RECT-19 AT ROW 10.33 COL 1.57 WIDGET-ID 28
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 4.7
         SIZE 88 BY 13.7
         FONT 1.

DEFINE FRAME fpage3
     tt-decla-import-adic.cod-incoterm AT ROW 1.92 COL 12 COLON-ALIGNED WIDGET-ID 10
          LABEL "Incoterm"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-desc-incoterm AT ROW 1.92 COL 17.14 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     tt-decla-import-adic.log-mater-encomen AT ROW 2.08 COL 69.57 WIDGET-ID 12
          LABEL "Sob Encomenda"
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .63
     tt-decla-import-adic.qtd-ncm AT ROW 2.92 COL 12 COLON-ALIGNED WIDGET-ID 16
          LABEL "Qtde UN NCM"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     c-un-ncm AT ROW 2.92 COL 28.14 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     tt-decla-import-adic.val-peso-liq AT ROW 2.92 COL 47 COLON-ALIGNED WIDGET-ID 20
          LABEL "Peso L¡quido (Kg)"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-decla-import-adic.log-mater-usado AT ROW 3.04 COL 69.57 WIDGET-ID 14
          LABEL "Usado"
          VIEW-AS TOGGLE-BOX
          SIZE 8.72 BY .63
     brItens AT ROW 4.33 COL 1.57 WIDGET-ID 200
     btModificaItens AT ROW 12 COL 2 WIDGET-ID 22
     "Material" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.42 COL 70.14 WIDGET-ID 4
     RECT-5 AT ROW 1.25 COL 1.57 WIDGET-ID 2
     RECT-16 AT ROW 1.63 COL 68.43 WIDGET-ID 18
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 4.7
         SIZE 88 BY 13.7
         FONT 1.

DEFINE FRAME fPage8
     rs-mostra-tela AT ROW 1.5 COL 2.29 NO-LABEL
     tt-decla-import-adic.dsl-compl-adic AT ROW 2.75 COL 2.72 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 80 BY 7.5
     brAcres AT ROW 2.75 COL 2.72
     btIncAcres AT ROW 10.25 COL 2.43
     btAltAcres AT ROW 10.25 COL 19.29
     btExcAcres AT ROW 10.25 COL 36.14
     RECT-20 AT ROW 2.5 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 4.7
         SIZE 88 BY 13.7
         FONT 1.

DEFINE FRAME fPage7
     cb-idi-ind-pagto AT ROW 1.5 COL 20 COLON-ALIGNED HELP
          "Indicativo Pagamento"
     tt-decla-import-adic.cdn-motivo AT ROW 1.5 COL 74 COLON-ALIGNED
          LABEL "Motivo"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-decla-import-adic.cdn-modal-pagto AT ROW 2.5 COL 20 COLON-ALIGNED
          LABEL "Modalidade Pagamento"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     tt-decla-import-adic.cdn-corretor AT ROW 3.71 COL 53 COLON-ALIGNED
          LABEL "Cor.Cƒmbio"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-desc-corretor AT ROW 3.71 COL 64.14 COLON-ALIGNED NO-LABEL
     tt-decla-import-adic.cdn-banco AT ROW 4.63 COL 53 COLON-ALIGNED
          LABEL "Banco"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-decla-import-adic.log-moed-nac AT ROW 4.63 COL 61
          LABEL "Moeda Nacional"
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .88
     tt-decla-import-adic.cdn-praca AT ROW 5.54 COL 53 COLON-ALIGNED
          LABEL "Pra‡a"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-decla-import-adic.cod-contrat-cambio AT ROW 6.46 COL 53 COLON-ALIGNED
          LABEL "Contrato"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-decla-import-adic.cdn-agent AT ROW 7.71 COL 53 COLON-ALIGNED
          LABEL "Agente"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-desc-agente AT ROW 7.71 COL 60 COLON-ALIGNED NO-LABEL
     tt-decla-import-adic.cdn-bco-agent AT ROW 8.63 COL 53 COLON-ALIGNED
          LABEL "Banco"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-decla-import-adic.cod-agenc-agent AT ROW 9.54 COL 53 COLON-ALIGNED
          LABEL "Agencia"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-decla-import-adic.cod-rof AT ROW 10.79 COL 53 COLON-ALIGNED
          LABEL "No. ROF"
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     brParcelas AT ROW 4.46 COL 3
     btAddParcela AT ROW 4.5 COL 38.86 HELP
          "Confirma altera‡äes"
     btCanParcela AT ROW 5.71 COL 38.86 HELP
          "Confirma altera‡äes"
     btSaveParcela AT ROW 6.92 COL 38.86 HELP
          "Confirma altera‡äes"
     btDelParcela AT ROW 8.13 COL 38.86 HELP
          "Confirma altera‡äes"
     label-parc AT ROW 3.71 COL 1 COLON-ALIGNED NO-LABEL
     RECT-22 AT ROW 1.29 COL 2
     RECT-23 AT ROW 3.54 COL 2
     RECT-24 AT ROW 3.54 COL 44
     RECT-25 AT ROW 10.63 COL 44
     RECT-26 AT ROW 7.54 COL 44
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 4.7
         SIZE 88 BY 13.7
         FONT 1.

DEFINE FRAME fPage5
     cb-idi-tributac-ibsuf AT ROW 1.88 COL 11.86 COLON-ALIGNED HELP
          "C¢digo de tributa‡Æo do IBS UF" NO-LABEL WIDGET-ID 174
     cb-idi-tributac-ibsmun AT ROW 1.88 COL 29.29 COLON-ALIGNED HELP
          "C¢digo de Tributa‡Æo CBS" NO-LABEL WIDGET-ID 328
     cb-idi-tributac-cbs AT ROW 1.88 COL 46.43 COLON-ALIGNED HELP
          "C¢digo de Tributa‡Æo CBS" NO-LABEL WIDGET-ID 180
     cb-idi-tributac-is AT ROW 2 COL 76 COLON-ALIGNED HELP
          "C¢digo de tributa‡Æo do IBS UF" WIDGET-ID 344
     de-val-aliq-ibsuf AT ROW 2.88 COL 11.86 COLON-ALIGNED NO-LABEL WIDGET-ID 230
     de-val-aliq-ibsmun AT ROW 2.88 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 336
     de-val-aliq-cbs AT ROW 2.88 COL 46.43 COLON-ALIGNED NO-LABEL WIDGET-ID 236
     de-val-aliq-is AT ROW 3 COL 76 COLON-ALIGNED WIDGET-ID 350
     de-perc-reduc-ibsuf AT ROW 3.88 COL 11.86 COLON-ALIGNED NO-LABEL WIDGET-ID 250
     de-perc-reduc-ibsmun AT ROW 3.88 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 334
     de-perc-reduc-cbs AT ROW 3.88 COL 46.43 COLON-ALIGNED NO-LABEL WIDGET-ID 256
     de-val-aliq-espec-is AT ROW 4 COL 76 COLON-ALIGNED WIDGET-ID 352
     de-base-ibsuf AT ROW 4.88 COL 11.86 COLON-ALIGNED NO-LABEL WIDGET-ID 240
     de-base-ibsmun AT ROW 4.88 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 330
     de-base-cbs AT ROW 4.88 COL 46.43 COLON-ALIGNED NO-LABEL WIDGET-ID 246
     de-qtde-is AT ROW 5 COL 76 COLON-ALIGNED WIDGET-ID 354
     de-valor-impostos-ibsuf AT ROW 5.88 COL 11.86 COLON-ALIGNED HELP
          "Valor IBS UF" NO-LABEL WIDGET-ID 194
     de-valor-impostos-ibsmun AT ROW 5.88 COL 29.29 COLON-ALIGNED HELP
          "Valor CBS" NO-LABEL WIDGET-ID 340
     de-valor-impostos-cbs AT ROW 5.88 COL 46.43 COLON-ALIGNED HELP
          "Valor CBS" NO-LABEL WIDGET-ID 200
     c-un-trib-is AT ROW 6 COL 76 COLON-ALIGNED WIDGET-ID 356
     c-class-trib-ibsuf AT ROW 6.88 COL 11.86 COLON-ALIGNED NO-LABEL WIDGET-ID 268
     c-class-trib-ibsmun AT ROW 6.88 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 320
     c-class-trib-cbs AT ROW 6.88 COL 46.43 COLON-ALIGNED NO-LABEL WIDGET-ID 270
     de-base-is AT ROW 7 COL 76 COLON-ALIGNED WIDGET-ID 360
     c-cst-ibsuf AT ROW 7.88 COL 11.86 COLON-ALIGNED NO-LABEL WIDGET-ID 264
     c-cst-ibsmun AT ROW 7.88 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 324
     c-cst-cbs AT ROW 7.88 COL 46.43 COLON-ALIGNED NO-LABEL WIDGET-ID 266
     de-valor-impostos-is AT ROW 8 COL 76 COLON-ALIGNED HELP
          "Valor IBS UF" WIDGET-ID 362
     c-class-trib-is AT ROW 9 COL 76 COLON-ALIGNED WIDGET-ID 358
     de-val-aliq-reg-ibsuf AT ROW 9.25 COL 11.86 COLON-ALIGNED NO-LABEL WIDGET-ID 290
     de-val-aliq-reg-ibsmun AT ROW 9.25 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 338
     de-val-aliq-reg-cbs AT ROW 9.25 COL 46.43 COLON-ALIGNED NO-LABEL WIDGET-ID 292
     c-cst-is AT ROW 10 COL 76 COLON-ALIGNED WIDGET-ID 364
     de-base-reg-ibsuf AT ROW 10.25 COL 11.86 COLON-ALIGNED NO-LABEL WIDGET-ID 294
     de-base-reg-ibsmun AT ROW 10.25 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 332
     de-base-reg-cbs AT ROW 10.25 COL 46.43 COLON-ALIGNED NO-LABEL WIDGET-ID 296
     de-valor-impostos-reg-ibsuf AT ROW 11.25 COL 11.86 COLON-ALIGNED HELP
          "Valor IBS UF" NO-LABEL WIDGET-ID 298
     de-valor-impostos-reg-ibsmun AT ROW 11.25 COL 29.29 COLON-ALIGNED HELP
          "Valor CBS" NO-LABEL WIDGET-ID 342
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.57 ROW 4.71
         SIZE 94.43 BY 13.71
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage5
     de-valor-impostos-reg-cbs AT ROW 11.25 COL 46.43 COLON-ALIGNED HELP
          "Valor CBS" NO-LABEL WIDGET-ID 300
     c-class-trib-reg-ibsuf AT ROW 12.25 COL 11.86 COLON-ALIGNED NO-LABEL WIDGET-ID 302
     c-class-trib-reg-ibsmun AT ROW 12.25 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 322
     c-class-trib-reg-cbs AT ROW 12.25 COL 46.43 COLON-ALIGNED NO-LABEL WIDGET-ID 304
     c-cst-reg-ibsuf AT ROW 13.25 COL 11.86 COLON-ALIGNED NO-LABEL WIDGET-ID 306
     c-cst-reg-ibsmun AT ROW 13.25 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 326
     c-cst-reg-cbs AT ROW 13.25 COL 46.43 COLON-ALIGNED NO-LABEL WIDGET-ID 308
     label-IBSUF AT ROW 1 COL 13.86 NO-LABEL WIDGET-ID 208
     label-IBSMUN AT ROW 1 COL 31.57 NO-LABEL WIDGET-ID 318
     label-CBS AT ROW 1 COL 48.43 NO-LABEL WIDGET-ID 214
     label-IS AT ROW 1 COL 67 NO-LABEL WIDGET-ID 348
     label-tributac-2 AT ROW 1.96 COL 5.57 NO-LABEL WIDGET-ID 220
     label-aliq-2 AT ROW 2.96 COL 7.14 NO-LABEL WIDGET-ID 202
     label-reduc-2 AT ROW 3.96 COL 4.57 COLON-ALIGNED NO-LABEL WIDGET-ID 216
     label-base-calc-2 AT ROW 4.96 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 204
     label-valor-2 AT ROW 5.96 COL 7.43 COLON-ALIGNED NO-LABEL WIDGET-ID 222
     label-class-trib AT ROW 6.96 COL 4.43 COLON-ALIGNED NO-LABEL WIDGET-ID 274
     label-cst AT ROW 7.96 COL 7.86 COLON-ALIGNED NO-LABEL WIDGET-ID 272
     label-aliq-Reg AT ROW 9.46 COL 5.14 COLON-ALIGNED NO-LABEL WIDGET-ID 280
     label-base-calc-Reg AT ROW 10.46 COL 4.14 NO-LABEL WIDGET-ID 282
     label-valor-Reg AT ROW 11.46 COL 7.43 COLON-ALIGNED NO-LABEL WIDGET-ID 284
     label-class-trib-Reg AT ROW 12.46 COL 6.14 NO-LABEL WIDGET-ID 286
     label-cst-Reg AT ROW 13.46 COL 7.86 COLON-ALIGNED NO-LABEL WIDGET-ID 288 DEBLANK 
     "Tributa‡Æo Regular" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 8.75 COL 3.29 WIDGET-ID 312
     RECT-78 AT ROW 9 COL 2 WIDGET-ID 310
     RECT-79 AT ROW 1.75 COL 66 WIDGET-ID 346
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.57 ROW 4.71
         SIZE 94.43 BY 13.71
         FONT 1.

DEFINE FRAME fPage6
     d-val-vmcv-me1 AT ROW 2.5 COL 13 COLON-ALIGNED HELP
          "Valor Mercadoria Condi‡Æo Venda moeda estrangeira" NO-LABEL
     c-cdn-moed-vmcv AT ROW 2.5 COL 30 COLON-ALIGNED NO-LABEL
     d-val-vmcv-me2 AT ROW 2.5 COL 47 COLON-ALIGNED HELP
          "Valor Mercadoria Condi‡Æo Venda moeda estrangeira" NO-LABEL
     d-val-vmcv AT ROW 2.5 COL 64 COLON-ALIGNED HELP
          "Valor Mercadoria na Condi‡Æo Venda" NO-LABEL
     d-val-vmle-me1 AT ROW 3.5 COL 13 COLON-ALIGNED HELP
          "Valor VMLE ME" NO-LABEL
     c-cdn-moed-vmle AT ROW 3.5 COL 30 COLON-ALIGNED NO-LABEL
     d-val-vmle-me2 AT ROW 3.5 COL 47 COLON-ALIGNED HELP
          "Valor VMLE ME" NO-LABEL
     d-val-vmle AT ROW 3.5 COL 64 COLON-ALIGNED HELP
          "Valor VMLE" NO-LABEL
     d-val-vmld-me1 AT ROW 4.5 COL 13 COLON-ALIGNED HELP
          "Valor mercadoria local de despacho ME" NO-LABEL
     c-cdn-moed-vmld AT ROW 4.5 COL 30 COLON-ALIGNED NO-LABEL
     d-val-vmld-me2 AT ROW 4.5 COL 47 COLON-ALIGNED HELP
          "Valor mercadoria local de despacho ME" NO-LABEL
     d-val-vmld AT ROW 4.5 COL 64 COLON-ALIGNED HELP
          "Valor mercadoria no local despacho" NO-LABEL
     d-val-frete-me1 AT ROW 5.5 COL 13 COLON-ALIGNED HELP
          "Valor Frete moeda estrangeira" NO-LABEL
     c-cdn-moed-frete AT ROW 5.5 COL 30 COLON-ALIGNED NO-LABEL
     d-val-frete-me2 AT ROW 5.5 COL 47 COLON-ALIGNED HELP
          "Valor Frete moeda estrangeira" NO-LABEL
     d-val-frete AT ROW 5.5 COL 64 COLON-ALIGNED HELP
          "Informe o valor do frete" NO-LABEL
     d-val-seguro-me1 AT ROW 6.5 COL 13 COLON-ALIGNED HELP
          "Valor Seguro Moeda Estrangeira" NO-LABEL
     c-cdn-moed-seguro AT ROW 6.5 COL 30 COLON-ALIGNED NO-LABEL
     d-val-seguro-me2 AT ROW 6.5 COL 47 COLON-ALIGNED HELP
          "Valor Seguro Moeda Estrangeira" NO-LABEL
     d-val-seguro AT ROW 6.5 COL 64 COLON-ALIGNED HELP
          "Valor do seguro" NO-LABEL
     d-val-acresc-me2 AT ROW 7.5 COL 13 COLON-ALIGNED HELP
          "Valor Acr‚scimo Moeda Estrangeiro" NO-LABEL
     c-cdn-moed-acresc AT ROW 7.5 COL 30 COLON-ALIGNED NO-LABEL
     d-val-acresc-me1 AT ROW 7.5 COL 47 COLON-ALIGNED HELP
          "Valor Acr‚scimo Moeda Estrangeiro" NO-LABEL
     d-val-acresc AT ROW 7.5 COL 64 COLON-ALIGNED HELP
          "Valor Acr‚scimo" NO-LABEL
     label-valores AT ROW 1.5 COL 25 COLON-ALIGNED NO-LABEL
     label-moeda AT ROW 1.5 COL 40 COLON-ALIGNED NO-LABEL
     label-dolar AT ROW 1.5 COL 54 COLON-ALIGNED NO-LABEL
     label-reais AT ROW 1.5 COL 71 COLON-ALIGNED NO-LABEL
     label-vmcv AT ROW 2.5 COL 3 COLON-ALIGNED NO-LABEL
     label-vmle AT ROW 3.5 COL 3 COLON-ALIGNED NO-LABEL
     label-vmld AT ROW 4.5 COL 3 COLON-ALIGNED NO-LABEL
     label-frete AT ROW 5.5 COL 3 COLON-ALIGNED NO-LABEL
     label-seguro AT ROW 6.5 COL 3 COLON-ALIGNED NO-LABEL
     label-acresc AT ROW 7.5 COL 3 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 4.7
         SIZE 88 BY 13.7
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-decla-import T "?" NO-UNDO mgcex decla-import
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic T "?" NO-UNDO mgcex decla-import-adic
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic-docto T "?" NO-UNDO mgcex decla-import-adic-docto
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic-docto-aux T "?" NO-UNDO mgcex decla-import-adic-docto
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic-itens T "?" NO-UNDO mgcex decla-import-adic-itens
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic-itens-aux T "?" NO-UNDO mgcex decla-import-adic-itens
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic-nve T "?" NO-UNDO mgcex decla-import-adic-nve
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic-nve-aux T "?" NO-UNDO mgcex decla-import-adic-nve
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic-parc T "?" NO-UNDO mgcex decla-import-adic-parc
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic-parc-aux T "?" NO-UNDO mgcex decla-import-adic-parc
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-despes-adic T "?" NO-UNDO mgcex despes-adic
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-despes-adic-aux T "?" NO-UNDO mgcex despes-adic
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 19.5
         WIDTH              = 96.72
         MAX-HEIGHT         = 21.04
         MAX-WIDTH          = 97.57
         VIRTUAL-HEIGHT     = 21.04
         VIRTUAL-WIDTH      = 97.57
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fpage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE
       FRAME fPage7:FRAME = FRAME fpage0:HANDLE
       FRAME fPage8:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON bt-nex IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-pre IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-registro IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import.cod-di-siscomex IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import.cod-estab IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import.dat-di IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.num-adic IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import.num-di-ems IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brDoctoVinc btAddDocumento fPage1 */
/* SETTINGS FOR FILL-IN c-nome-fabrican IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-fornec IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cdn-fabrican IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cdn-fornec IN FRAME fPage1
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX tt-decla-import-adic.log-emite-fabrican IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brNVE btAddNVE fPage2 */
/* SETTINGS FOR FILL-IN c-desc-class-fis IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cdn-classif-fisc-ex IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cdn-naladi-sist-harmon IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cod-aladi IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cod-classif-fisc IN FRAME fPage2
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cod-licenc-import IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cod-naladi-ncca IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cod-nbm IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cod-tip-recip IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.dat-livre-1 IN FRAME fPage2
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN label-NVE IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.qtd-capac-recip IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fpage3
                                                                        */
/* BROWSE-TAB brItens log-mater-usado fpage3 */
/* SETTINGS FOR FILL-IN c-desc-incoterm IN FRAME fpage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cod-incoterm IN FRAME fpage3
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX tt-decla-import-adic.log-mater-encomen IN FRAME fpage3
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-decla-import-adic.log-mater-usado IN FRAME fpage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.qtd-ncm IN FRAME fpage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-peso-liq IN FRAME fpage3
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN label-aliq IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-base-calc IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-cofins IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-fcp IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-fcp-st IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-icms IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-icms-compl IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-icms-st IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-ii IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-ipi IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-pis IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-reduc IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-susp IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-tributac IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-valor IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-vl-unit IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-aliq-cofins IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-aliq-icms IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-aliq-ii IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-aliq-ipi IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-aliq-pis IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-base-cofins IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-base-icms IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-base-ii IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-base-ipi IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-base-pis IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-perc-reduc-cofins IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-perc-reduc-icms IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-perc-reduc-impto-import IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-perc-reduc-ipi IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-perc-reduc-pis IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-unit-cofins IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-unit-pis IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* SETTINGS FOR FILL-IN label-aliq-2 IN FRAME fPage5
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN label-aliq-Reg IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-base-calc-2 IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-base-calc-Reg IN FRAME fPage5
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN label-CBS IN FRAME fPage5
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN label-class-trib IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-class-trib-Reg IN FRAME fPage5
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN label-cst IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-cst-Reg IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-IBSMUN IN FRAME fPage5
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN label-IBSUF IN FRAME fPage5
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN label-IS IN FRAME fPage5
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN label-reduc-2 IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-tributac-2 IN FRAME fPage5
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN label-valor-2 IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-valor-Reg IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage6
                                                                        */
/* SETTINGS FOR FILL-IN label-acresc IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-dolar IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-frete IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-moeda IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-reais IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-seguro IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-valores IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-vmcv IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-vmld IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-vmle IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage7
   Custom                                                               */
/* BROWSE-TAB brParcelas cod-rof fPage7 */
/* SETTINGS FOR FILL-IN c-desc-agente IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-corretor IN FRAME fPage7
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cdn-agent IN FRAME fPage7
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cdn-banco IN FRAME fPage7
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cdn-bco-agent IN FRAME fPage7
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cdn-corretor IN FRAME fPage7
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cdn-modal-pagto IN FRAME fPage7
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cdn-motivo IN FRAME fPage7
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cdn-praca IN FRAME fPage7
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cod-agenc-agent IN FRAME fPage7
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cod-contrat-cambio IN FRAME fPage7
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.cod-rof IN FRAME fPage7
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-decla-import-adic.log-moed-nac IN FRAME fPage7
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage8
                                                                        */
/* BROWSE-TAB brAcres dsl-compl-adic fPage8 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brAcres
/* Query rebuild information for BROWSE brAcres
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-despes-adic-aux BY tt-despes-adic-aux.cdn-despes
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brAcres */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDoctoVinc
/* Query rebuild information for BROWSE brDoctoVinc
     _START_FREEFORM
OPEN QUERY brDoctoVinc FOR EACH tt-decla-import-adic-docto-aux.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDoctoVinc */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brItens
/* Query rebuild information for BROWSE brItens
     _START_FREEFORM
OPEN QUERY brItens FOR EACH tt-decla-import-adic-itens-aux.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brItens */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brNVE
/* Query rebuild information for BROWSE brNVE
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-adic-nve-aux NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brNVE */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brParcelas
/* Query rebuild information for BROWSE brParcelas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-adic-parc-aux NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brParcelas */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage3
/* Query rebuild information for FRAME fpage3
     _Query            is NOT OPENED
*/  /* FRAME fpage3 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage8
/* Query rebuild information for FRAME fPage8
     _Query            is NOT OPENED
*/  /* FRAME fPage8 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fPage8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fPage8 wMaintenanceNoNavigation
ON GO OF FRAME fPage8
DO:
    APPLY 'value-changed' TO rs-mostra-tela IN FRAME fPage8.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brAcres
&Scoped-define FRAME-NAME fPage8
&Scoped-define SELF-NAME brAcres
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAcres wMaintenanceNoNavigation
ON ROW-DISPLAY OF brAcres IN FRAME fPage8
DO:
   IF tt-despes-adic-aux.idi-orig-despes = 1 THEN
       RUN pi-troca-cor(INPUT ?).
   ELSE
       RUN pi-troca-cor(INPUT 12).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAcres wMaintenanceNoNavigation
ON VALUE-CHANGED OF brAcres IN FRAME fPage8
DO:
    RUN pi-verifica-despes-acresc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDoctoVinc
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brDoctoVinc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDoctoVinc wMaintenanceNoNavigation
ON END-ERROR OF brDoctoVinc IN FRAME fPage1
DO:
    if  brDoctoVinc:new-row in frame fPage1 then do:
        if  avail tt-decla-import-adic-docto-aux then delete tt-decla-import-adic-docto-aux.
        if  brDoctoVinc:delete-current-row() in frame fPage1 then. 
    end.                                                               
    else do:
       get current brDoctoVinc.
       DISPLAY tt-decla-import-adic-docto-aux.cod-num-docto
               tt-decla-import-adic-docto-aux.idi-tip-docto-vincul with browse brDoctoVinc. 
    end.
    return no-apply.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDoctoVinc wMaintenanceNoNavigation
ON INS OF brDoctoVinc IN FRAME fPage1
DO:
   apply 'choose' to btAddDocumento in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDoctoVinc wMaintenanceNoNavigation
ON OFF-END OF brDoctoVinc IN FRAME fPage1
DO:
   apply 'entry' to btAddDocumento in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDoctoVinc wMaintenanceNoNavigation
ON ROW-LEAVE OF brDoctoVinc IN FRAME fPage1
DO:
    do  transaction on error undo, return no-apply:
        if  brDoctoVinc:new-row in frame fPage1 then
            IF NOT CAN-FIND (FIRST tt-decla-import-adic-docto-aux
                             WHERE tt-decla-import-adic-docto-aux.num-di-ems       = tt-decla-import-adic.num-di-ems
                             AND   tt-decla-import-adic-docto-aux.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
                             AND   tt-decla-import-adic-docto-aux.num-adic         = tt-decla-import-adic.num-adic 
                             AND   tt-decla-import-adic-docto-aux.cod-num-docto    = input browse brDoctoVinc tt-decla-import-adic-docto-aux.cod-num-docto) THEN DO:
                create tt-decla-import-adic-docto-aux.
                assign tt-decla-import-adic-docto-aux.num-di-ems           = tt-decla-import-adic.num-di-ems
                       tt-decla-import-adic-docto-aux.cdd-siscomex-dts     = tt-decla-import-adic.cdd-siscomex-dts
                       tt-decla-import-adic-docto-aux.num-adic             = tt-decla-import-adic.num-adic                                  
                       tt-decla-import-adic-docto-aux.cod-num-docto        = input browse brDoctoVinc tt-decla-import-adic-docto-aux.cod-num-docto
                       tt-decla-import-adic-docto-aux.idi-tip-docto-vincul = input browse brDoctoVinc tt-decla-import-adic-docto-aux.idi-tip-docto-vincul.
            END. /* IF NOT CAN-FIND (FIRST tt-decla-import-adic-docto-aux */
    END. /* do  transaction */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brItens
&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME brItens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItens wMaintenanceNoNavigation
ON VALUE-CHANGED OF brItens IN FRAME fpage3
DO:
    IF  AVAIL tt-decla-import-adic-itens-aux THEN DO:
        ASSIGN c-desc-item = DYNAMIC-FUNCTION('fnDesc':U, tt-decla-import-adic-itens-aux.cod-item).
        STATUS INPUT caps(c-desc-item) IN WINDOW CURRENT-WINDOW.
    END.
    ELSE STATUS INPUT "" IN WINDOW CURRENT-WINDOW.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brNVE
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME brNVE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNVE wMaintenanceNoNavigation
ON END-ERROR OF brNVE IN FRAME fPage2
DO:
    if  brNVE:new-row in frame fPage2 then do:
        if  avail tt-decla-import-adic-nve-aux then delete tt-decla-import-adic-nve-aux.
        if  brNVE:delete-current-row() in frame fPage2 then. 
    end.                                                               
    else do:
       get current brNVE.
       DISPLAY tt-decla-import-adic-nve-aux.idi-niv
               tt-decla-import-adic-nve-aux.cod-ident
               tt-decla-import-adic-nve-aux.cod-atributo 
               tt-decla-import-adic-nve-aux.cdn-especif with browse brNVE. 
    end.
    return no-apply.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNVE wMaintenanceNoNavigation
ON INS OF brNVE IN FRAME fPage2
DO:
   apply 'choose' to btAddNVE in frame fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNVE wMaintenanceNoNavigation
ON OFF-END OF brNVE IN FRAME fPage2
DO:
   apply 'entry' to btAddNVE in frame fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brNVE wMaintenanceNoNavigation
ON ROW-LEAVE OF brNVE IN FRAME fPage2
DO:
    do  transaction on error undo, return no-apply:
        if  brNVE:new-row in frame fPage2 then
            IF NOT CAN-FIND (FIRST tt-decla-import-adic-nve-aux
                             WHERE tt-decla-import-adic-nve-aux.num-di-ems       = tt-decla-import-adic.num-di-ems
                             AND   tt-decla-import-adic-nve-aux.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
                             AND   tt-decla-import-adic-nve-aux.num-adic         = tt-decla-import-adic.num-adic                                  
                             AND   tt-decla-import-adic-nve-aux.idi-niv          = input browse brNVE tt-decla-import-adic-nve-aux.idi-niv
                             AND   tt-decla-import-adic-nve-aux.cod-ident        = input browse brNVE tt-decla-import-adic-nve-aux.cod-ident
                             AND   tt-decla-import-adic-nve-aux.cod-atributo     = input browse brNVE tt-decla-import-adic-nve-aux.cod-atributo
                             AND   tt-decla-import-adic-nve-aux.cdn-especif      = input browse brNVE tt-decla-import-adic-nve-aux.cdn-especif) THEN DO:
                create tt-decla-import-adic-nve-aux.
                assign tt-decla-import-adic-nve-aux.num-di-ems       = tt-decla-import-adic.num-di-ems
                       tt-decla-import-adic-nve-aux.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
                       tt-decla-import-adic-nve-aux.num-adic         = tt-decla-import-adic.num-adic                             
                       tt-decla-import-adic-nve-aux.idi-niv          = input browse brNVE tt-decla-import-adic-nve-aux.idi-niv     
                       tt-decla-import-adic-nve-aux.cod-ident        = input browse brNVE tt-decla-import-adic-nve-aux.cod-ident   
                       tt-decla-import-adic-nve-aux.cod-atributo     = input browse brNVE tt-decla-import-adic-nve-aux.cod-atributo
                       tt-decla-import-adic-nve-aux.cdn-especif      = INPUT browse brNVE tt-decla-import-adic-nve-aux.cdn-especif.
            END. /* IF NOT CAN-FIND (FIRST tt-decla-import-adic-nve-aux */
    END. /* do  transaction */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-nex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nex wMaintenanceNoNavigation
ON CHOOSE OF bt-nex IN FRAME fpage0 /* Next */
DO:
    /* guarda o id da fPage que estava antes de navegar */
    RUN GetCurrentFolder IN hFolder (OUTPUT i-pagina).

    RUN pi-valida (INPUT NO).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.

    RUN pi-salva-registro. /* salva as altera‡äes da tela */
    
    EMPTY TEMP-TABLE tt-decla-import-adic NO-ERROR.
    assign i-num-linha-browse = i-num-linha-browse + 1.
    if bt-pre:sensitive in frame fPage0 = no then assign bt-pre:sensitive in frame fPage0 = yes.
    RUN repositionRecord IN {&hDBOTable} (INPUT rRowid).
    RUN getNext   IN {&hDBOTable}.
    RUN getRecord IN {&hDBOTable} (OUTPUT TABLE tt-decla-import-adic).
    
    find first tt-decla-import-adic EXCLUSIVE-LOCK no-error.
    run DisplayFields IN THIS-PROCEDURE.
    if  i-num-linha-browse = i-nr-registro then do:
        RUN getLast IN {&hDBOTable}.
        assign bt-nex:sensitive in frame fPage0 = no.
    end.
    RUN pi-habilita-campos.

    /* muda para a fPage que estava antes de navegar */
    RUN SetFolder IN hFolder (INPUT i-pagina). 
      
    RETURN "OK":U. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pre wMaintenanceNoNavigation
ON CHOOSE OF bt-pre IN FRAME fpage0 /* Prev */
DO:
    /* guarda o id da fPage que estava antes de navegar */
    RUN GetCurrentFolder IN hFolder (OUTPUT i-pagina).

    RUN pi-valida (INPUT NO).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.

    RUN pi-salva-registro. /* salva as altera‡äes da tela */

    EMPTY TEMP-TABLE tt-decla-import-adic NO-ERROR.

    IF i-num-linha-browse = 1 THEN DO:
         RUN getFirst IN {&hDBOTable}.
         assign bt-pre:sensitive in frame fPage0 = no.
    END.
    ELSE DO:
        assign i-num-linha-browse = i-num-linha-browse - 1.
    
        if bt-nex:sensitive in frame fPage0 = no then assign bt-nex:sensitive in frame fPage0 = yes.
        
        RUN repositionRecord IN {&hDBOTable} (INPUT rRowid).
        RUN getPrev   IN {&hDBOTable}.
        RUN getRecord IN {&hDBOTable} (OUTPUT TABLE tt-decla-import-adic).
        FIND FIRST tt-decla-import-adic EXCLUSIVE-LOCK NO-ERROR.

        RUN DisplayFields IN THIS-PROCEDURE.
        
        if  i-num-linha-browse = 1 OR i-num-linha-browse = 0 then do:
            RUN getFirst IN {&hDBOTable}.
            assign bt-pre:sensitive in frame fPage0 = no.
        end.
    
        RUN pi-habilita-campos.
    END.

    /* muda para a fPage que estava antes de navegar */
    RUN SetFolder IN hFolder (INPUT i-pagina). 

    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddDocumento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddDocumento wMaintenanceNoNavigation
ON CHOOSE OF btAddDocumento IN FRAME fPage1 /* Adiciona Processo Vinculado */
DO:
  RUN pi-add-documento.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddNVE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddNVE wMaintenanceNoNavigation
ON CHOOSE OF btAddNVE IN FRAME fPage2 /* Adiciona NVE */
DO:
  RUN pi-add-nve.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btAddParcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddParcela wMaintenanceNoNavigation
ON CHOOSE OF btAddParcela IN FRAME fPage7 /* Adiciona NVE */
DO:
  RUN pi-add-parcela.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage8
&Scoped-define SELF-NAME btAltAcres
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAltAcres wMaintenanceNoNavigation
ON CHOOSE OF btAltAcres IN FRAME fPage8 /* Alterar */
DO:
    RUN pi-carregaTTAcres-aux.
    run pi-modificaAcres.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCanDocumento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCanDocumento wMaintenanceNoNavigation
ON CHOOSE OF btCanDocumento IN FRAME fPage1 /* Save */
DO:
  RUN pi-canc-documento.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCanNVE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCanNVE wMaintenanceNoNavigation
ON CHOOSE OF btCanNVE IN FRAME fPage2 /* Save */
DO:
  RUN pi-canc-nve.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btCanParcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCanParcela wMaintenanceNoNavigation
ON CHOOSE OF btCanParcela IN FRAME fPage7 /* Save */
DO:
  RUN pi-canc-parcela.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDelDocumento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelDocumento wMaintenanceNoNavigation
ON CHOOSE OF btDelDocumento IN FRAME fPage1 /* Excluir */
DO:
  RUN pi-exclui-documento.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDelNVE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelNVE wMaintenanceNoNavigation
ON CHOOSE OF btDelNVE IN FRAME fPage2 /* Excluir */
DO:
  RUN pi-exclui-nve.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btDelParcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelParcela wMaintenanceNoNavigation
ON CHOOSE OF btDelParcela IN FRAME fPage7 /* Excluir */
DO:
  RUN pi-exclui-parcela.
  
  IF NOT CAN-FIND(FIRST tt-decla-import-adic-parc-aux
                WHERE tt-decla-import-adic-parc-aux.num-di-ems       = tt-decla-import-adic.num-di-ems
                AND   tt-decla-import-adic-parc-aux.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
                AND   tt-decla-import-adic-parc-aux.num-adic         = tt-decla-import-adic.num-adic
                AND   tt-decla-import-adic-parc-aux.idi-tip-pagto    = 1
                OR    tt-decla-import-adic-parc-aux.idi-tip-pagto    = 2 ) THEN DO:

      ASSIGN c-desc-corretor:SCREEN-VALUE IN FRAME fPage7                         = ""
             tt-decla-import-adic.cdn-corretor                                    = 0
             tt-decla-import-adic.cdn-banco                                       = 0
             tt-decla-import-adic.cdn-praca                                       = 0
             tt-decla-import-adic.cod-contrat-cambio                              = ""
             tt-decla-import-adic.log-moed-nac                                    = NO
             tt-decla-import-adic.cdn-corretor:SCREEN-VALUE IN FRAME fPage7       = '0'       
             tt-decla-import-adic.cdn-banco:SCREEN-VALUE IN FRAME fPage7          = '0'
             tt-decla-import-adic.cdn-praca:SCREEN-VALUE IN FRAME fPage7          = '0'
             tt-decla-import-adic.cod-contrat-cambio:SCREEN-VALUE IN FRAME fPage7 = ''
             tt-decla-import-adic.log-moed-nac:CHECKED IN FRAME fPage7            = NO.

      /*RUN saveRecord IN THIS-PROCEDURE.        */
      APPLY 'CHOOSE' TO btSave IN FRAME fPage0.
      RUN SetFolder IN hFolder (INPUT 7).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage8
&Scoped-define SELF-NAME btExcAcres
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcAcres wMaintenanceNoNavigation
ON CHOOSE OF btExcAcres IN FRAME fPage8 /* Excluir */
DO:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-confirma-a-exclusao AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Confirma_a_exclusÆo?" *}
    ASSIGN c-lbl-liter-confirma-a-exclusao = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-a-confirmacao-ira-eliminar-o-r AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "A_confirma‡Æo_ir _eliminar_o_registro_selecionado_de_Despesas_da_Adi‡Æo._Continua?" *}
    ASSIGN c-lbl-liter-a-confirmacao-ira-eliminar-o-r = TRIM(RETURN-VALUE).
    RUN utp/ut-msgs.p (INPUT 'show', INPUT 27100, c-lbl-liter-confirma-a-exclusao + '~~' + 
                                                  c-lbl-liter-a-confirmacao-ira-eliminar-o-r).
    IF  RETURN-VALUE = 'yes' THEN DO:
        RUN pi-excluiAcres.  
    END. /* IF  RETURN-VALUE = 'yes' THEN DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage8
&Scoped-define SELF-NAME btIncAcres
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncAcres wMaintenanceNoNavigation
ON CHOOSE OF btIncAcres IN FRAME fPage8 /* Incluir */
DO:
    RUN pi-addAcres.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME btModificaItens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModificaItens wMaintenanceNoNavigation
ON CHOOSE OF btModificaItens IN FRAME fpage3 /* Modificar */
DO:
    RUN pi-carregaTTItens-aux.
    run pi-modificaItens.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

    RUN pi-valida (INPUT YES).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.

    ASSIGN vRowid-Auxiliar = tt-decla-import-adic.r-Rowid.
    RUN pi-saveRecord.
    RUN repositionRecord IN {&hDBOTable} (INPUT vRowid-Auxiliar).
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:

    RUN pi-valida (INPUT YES).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.

    RUN pi-posiciona-registro IN {&hDBOTable} (INPUT tt-decla-import-adic.num-di-ems,
                                               INPUT tt-decla-import-adic.num-adic,
                                               INPUT tt-decla-import-adic.cdd-siscomex-dts).
    RUN GetCurrentFolder IN hFolder (OUTPUT i-pagina). /*salva o numero da frame que o usuario esta*/
    ASSIGN vRowid-Auxiliar = tt-decla-import-adic.r-Rowid.

    RUN pi-saveRecord.
    RUN repositionRecord IN {&hDBOTable} (INPUT vRowid-Auxiliar).
    RUN saveRecord IN THIS-PROCEDURE.
    find first tt-decla-import-adic EXCLUSIVE-LOCK no-error.

    RUN SetFolder IN hFolder (INPUT i-pagina).  /* seta o folder que o usu rios estava */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btSaveDocumento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaveDocumento wMaintenanceNoNavigation
ON CHOOSE OF btSaveDocumento IN FRAME fPage1 /* Save */
DO:
  RUN pi-salva-documento.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btSaveNVE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaveNVE wMaintenanceNoNavigation
ON CHOOSE OF btSaveNVE IN FRAME fPage2 /* Save */
DO:
  RUN pi-salva-nve.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btSaveParcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaveParcela wMaintenanceNoNavigation
ON CHOOSE OF btSaveParcela IN FRAME fPage7 /* Save */
DO:
  RUN pi-salva-parcela.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME c-class-trib-cbs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-cbs wMaintenanceNoNavigation
ON F5 OF c-class-trib-cbs IN FRAME fPage5
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in01127.w"
                       &FieldZoom1="cod-cclass-trib"
                       &FieldScreen1="c-class-trib-cbs"
                       &Frame1="fPage5"
                       &EnableImplant="NO"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-cbs wMaintenanceNoNavigation
ON LEAVE OF c-class-trib-cbs IN FRAME fPage5
DO:
    ASSIGN c-cst-cbs:SCREEN-VALUE IN FRAME fPage5 = SUBSTRING(c-class-trib-cbs:SCREEN-VALUE IN FRAME fPage5,1,3).
    
    FIND FIRST class-trib NO-LOCK
         WHERE class-trib.cod-cclass-trib = c-class-trib-cbs:SCREEN-VALUE IN FRAME fpage5
           AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
    IF AVAIL class-trib
    AND class-trib.trib-regular = 1 THEN DO:
        IF INPUT FRAME fPage5 de-val-aliq-cbs <> 0 THEN
            ASSIGN de-val-aliq-reg-cbs:SCREEN-VALUE IN FRAME fPage5 = de-val-aliq-cbs:SCREEN-VALUE IN FRAME fPage5.
        
        ENABLE c-class-trib-reg-cbs c-cst-reg-cbs WITH FRAME fPage5.
    END.
    ELSE DO:
        ASSIGN de-val-aliq-reg-cbs:SCREEN-VALUE IN FRAME fPage5 = "0"
               c-class-trib-reg-cbs:SCREEN-VALUE IN FRAME fPage5 = ""
               c-cst-reg-cbs:SCREEN-VALUE IN FRAME fPage5 = "".
        DISABLE c-class-trib-reg-cbs c-cst-reg-cbs WITH FRAME fPage5.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-cbs wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-cbs IN FRAME fPage5
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-class-trib-ibsmun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibsmun wMaintenanceNoNavigation
ON F5 OF c-class-trib-ibsmun IN FRAME fPage5
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in01127.w"
                       &FieldZoom1="cod-cclass-trib"
                       &FieldScreen1="c-class-trib-ibsmun"
                       &Frame1="fPage5"
                       &EnableImplant="NO"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibsmun wMaintenanceNoNavigation
ON LEAVE OF c-class-trib-ibsmun IN FRAME fPage5
DO:
    ASSIGN c-cst-ibsmun:SCREEN-VALUE IN FRAME fPage5 = SUBSTRING(c-class-trib-ibsmun:SCREEN-VALUE IN FRAME fPage5,1,3).
    
    FIND FIRST class-trib NO-LOCK
         WHERE class-trib.cod-cclass-trib = c-class-trib-ibsmun:SCREEN-VALUE IN FRAME fpage5
           AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
    IF AVAIL class-trib
    AND class-trib.trib-regular = 1 THEN DO:
        IF INPUT FRAME fPage5 de-val-aliq-ibsmun <> 0 THEN
            ASSIGN de-val-aliq-reg-ibsmun:SCREEN-VALUE IN FRAME fPage5 = de-val-aliq-ibsmun:SCREEN-VALUE IN FRAME fPage5.
        
        ENABLE c-class-trib-reg-ibsmun c-cst-reg-ibsmun WITH FRAME fPage5.
    END.
    ELSE DO:
        ASSIGN de-val-aliq-reg-ibsmun:SCREEN-VALUE IN FRAME fPage5 = "0"
               c-class-trib-reg-ibsmun:SCREEN-VALUE IN FRAME fPage5 = ""
               c-cst-reg-ibsmun:SCREEN-VALUE IN FRAME fPage5 = "".
        DISABLE c-class-trib-reg-ibsmun c-cst-reg-ibsmun WITH FRAME fPage5.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibsmun wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-ibsmun IN FRAME fPage5
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-class-trib-ibsuf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibsuf wMaintenanceNoNavigation
ON F5 OF c-class-trib-ibsuf IN FRAME fPage5
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in01127.w"
                       &FieldZoom1="cod-cclass-trib"
                       &FieldScreen1="c-class-trib-ibsuf"
                       &Frame1="fPage5"
                       &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibsuf wMaintenanceNoNavigation
ON LEAVE OF c-class-trib-ibsuf IN FRAME fPage5
DO:
    ASSIGN c-cst-ibsuf:SCREEN-VALUE IN FRAME fPage5 = SUBSTRING(c-class-trib-ibsuf:SCREEN-VALUE IN FRAME fPage5,1,3).
    
    FIND FIRST class-trib NO-LOCK
         WHERE class-trib.cod-cclass-trib = c-class-trib-ibsuf:SCREEN-VALUE IN FRAME fpage5
           AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
    IF AVAIL class-trib
    AND class-trib.trib-regular = 1 THEN DO:
        IF INPUT FRAME fPage5 de-val-aliq-ibsuf <> 0 THEN
            ASSIGN de-val-aliq-reg-ibsuf:SCREEN-VALUE IN FRAME fPage5 = de-val-aliq-ibsuf:SCREEN-VALUE IN FRAME fPage5.
        
        ENABLE c-class-trib-reg-ibsuf c-cst-reg-ibsuf WITH FRAME fPage5.
    END.
    ELSE DO:
        ASSIGN de-val-aliq-reg-ibsuf:SCREEN-VALUE IN FRAME fPage5 = "0"
               c-class-trib-reg-ibsuf:SCREEN-VALUE IN FRAME fPage5 = ""
               c-cst-reg-ibsuf:SCREEN-VALUE IN FRAME fPage5 = "".
        DISABLE c-class-trib-reg-ibsuf c-cst-reg-ibsuf WITH FRAME fPage5.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibsuf wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-ibsuf IN FRAME fPage5
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-class-trib-is
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-is wMaintenanceNoNavigation
ON F5 OF c-class-trib-is IN FRAME fPage5 /* Class Trib */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in01127.w"
                       &FieldZoom1="cod-cclass-trib"
                       &FieldScreen1="c-class-trib-is"
                       &Frame1="fPage5"
                       &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-is wMaintenanceNoNavigation
ON LEAVE OF c-class-trib-is IN FRAME fPage5 /* Class Trib */
DO:
    ASSIGN c-cst-is:SCREEN-VALUE IN FRAME fPage5 = SUBSTRING(c-class-trib-is:SCREEN-VALUE IN FRAME fPage5,1,3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-is wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-is IN FRAME fPage5 /* Class Trib */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-class-trib-reg-cbs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-reg-cbs wMaintenanceNoNavigation
ON F5 OF c-class-trib-reg-cbs IN FRAME fPage5
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z02in01127.w"
                       &FieldZoom1="cod-cclass-trib"
                       &FieldScreen1="c-class-trib-reg-cbs"
                       &Frame1="fPage5"
                       &EnableImplant="NO"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-reg-cbs wMaintenanceNoNavigation
ON LEAVE OF c-class-trib-reg-cbs IN FRAME fPage5
DO:
    ASSIGN c-cst-reg-cbs:SCREEN-VALUE IN FRAME fPage5 = SUBSTRING(c-class-trib-reg-cbs:SCREEN-VALUE IN FRAME fPage5,1,3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-reg-cbs wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-reg-cbs IN FRAME fPage5
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-class-trib-reg-ibsmun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-reg-ibsmun wMaintenanceNoNavigation
ON F5 OF c-class-trib-reg-ibsmun IN FRAME fPage5
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z02in01127.w"
                       &FieldZoom1="cod-cclass-trib"
                       &FieldScreen1="c-class-trib-reg-ibsmun"
                       &Frame1="fPage5"
                       &EnableImplant="NO"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-reg-ibsmun wMaintenanceNoNavigation
ON LEAVE OF c-class-trib-reg-ibsmun IN FRAME fPage5
DO:
    ASSIGN c-cst-reg-ibsmun:SCREEN-VALUE IN FRAME fPage5 = SUBSTRING(c-class-trib-reg-ibsmun:SCREEN-VALUE IN FRAME fPage5,1,3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-reg-ibsmun wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-reg-ibsmun IN FRAME fPage5
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-class-trib-reg-ibsuf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-reg-ibsuf wMaintenanceNoNavigation
ON F5 OF c-class-trib-reg-ibsuf IN FRAME fPage5
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z02in01127.w"
                       &FieldZoom1="cod-cclass-trib"
                       &FieldScreen1="c-class-trib-reg-ibsuf"
                       &Frame1="fPage5"
                       &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-reg-ibsuf wMaintenanceNoNavigation
ON LEAVE OF c-class-trib-reg-ibsuf IN FRAME fPage5
DO:
    ASSIGN c-cst-reg-ibsuf:SCREEN-VALUE IN FRAME fPage5 = SUBSTRING(c-class-trib-reg-ibsuf:SCREEN-VALUE IN FRAME fPage5,1,3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-reg-ibsuf wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-reg-ibsuf IN FRAME fPage5
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cst-is
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cst-is wMaintenanceNoNavigation
ON F5 OF c-cst-is IN FRAME fPage5 /* CST */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z01in01127.w"
                       &FieldZoom1="cod-cclass-trib"
                       &FieldScreen1="c-class-trib-ibsuf"
                       &Frame1="fPage5"
                       &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cst-is wMaintenanceNoNavigation
ON LEAVE OF c-cst-is IN FRAME fPage5 /* CST */
DO:
    ASSIGN c-cst-ibsuf:SCREEN-VALUE IN FRAME fPage5 = SUBSTRING(c-class-trib-ibsuf:SCREEN-VALUE IN FRAME fPage5,1,3).
    
    FIND FIRST class-trib NO-LOCK
         WHERE class-trib.cod-cclass-trib = c-class-trib-ibsuf:SCREEN-VALUE IN FRAME fpage5
           AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
    IF AVAIL class-trib
    AND class-trib.trib-regular = 1 THEN DO:
        IF INPUT FRAME fPage5 de-val-aliq-ibsuf <> 0 THEN
            ASSIGN de-val-aliq-reg-ibsuf:SCREEN-VALUE IN FRAME fPage5 = de-val-aliq-ibsuf:SCREEN-VALUE IN FRAME fPage5.
        
        ENABLE c-class-trib-reg-ibsuf c-cst-reg-ibsuf WITH FRAME fPage5.
    END.
    ELSE DO:
        ASSIGN de-val-aliq-reg-ibsuf:SCREEN-VALUE IN FRAME fPage5 = "0"
               c-class-trib-reg-ibsuf:SCREEN-VALUE IN FRAME fPage5 = ""
               c-cst-reg-ibsuf:SCREEN-VALUE IN FRAME fPage5 = "".
        DISABLE c-class-trib-reg-ibsuf c-cst-reg-ibsuf WITH FRAME fPage5.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cst-is wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-cst-is IN FRAME fPage5 /* CST */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-un-trib-is
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-trib-is wMaintenanceNoNavigation
ON F5 OF c-un-trib-is IN FRAME fPage5 /* Un Tribut vel */
DO:
  {include/zoomvar.i   &prog-zoom="inzoom\z01in417.w"
                       &campo=c-un-trib-is
                       &campozoom=un
                       &frame="fPage5"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-trib-is wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-un-trib-is IN FRAME fPage5 /* Un Tribut vel */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME cb-idi-ind-pagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-idi-ind-pagto wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-idi-ind-pagto IN FRAME fPage7 /* Pagamento */
DO:
    RUN piValue-changed-pgto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import-adic.cdn-agent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cdn-agent wMaintenanceNoNavigation
ON F5 OF tt-decla-import-adic.cdn-agent IN FRAME fPage7 /* Agente */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                       &campo="tt-decla-import-adic.cdn-agent"
                       &campozoom="cod-emitente"
                       &frame="fPage7"
                       &campo2="c-desc-agente"
                       &campozoom2="nome-abrev"
                       &frame2="fPage7"}
                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cdn-agent wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-adic.cdn-agent IN FRAME fPage7 /* Agente */
DO:
    if  input frame fPage7 tt-decla-import-adic.cdn-agent <> 0 then do:
        {method/referencefields.i &HandleDBOLeave="h-boad098"
                                  &FindMethod="findemitente"
                                  &KeyValue1="int(tt-decla-import-adic.cdn-agent:SCREEN-VALUE IN FRAME fPage7)"
                                  &FieldName1="nome-abrev" 
                                  &FieldScreen1="c-desc-agente"
                                  &Frame1="fPage7"}  
   end.    
   else assign c-desc-agente:screen-value in frame fPage7 = "".  

   RUN pi-buscaDados-emitente IN {&hDBOTable} (INPUT INPUT FRAME fPage7 tt-decla-import-adic.cdn-agent,
                                               OUTPUT i-banco-agente-aux,    
                                               OUTPUT c-agencia-agente-aux). 

   ASSIGN tt-decla-import-adic.cdn-bco-agent:screen-value   in frame fPage7 = string(i-banco-agente-aux)
          tt-decla-import-adic.cod-agenc-agent:screen-value in frame fPage7 = c-agencia-agente-aux.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cdn-agent wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import-adic.cdn-agent IN FRAME fPage7 /* Agente */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import-adic.cdn-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cdn-banco wMaintenanceNoNavigation
ON F5 OF tt-decla-import-adic.cdn-banco IN FRAME fPage7 /* Banco */
DO:
    {method/zoomfields.i 
     &ProgramZoom="adzoom/z10ad018.w"
     &FieldZoom1="cod-banco"
     &FieldScreen1="tt-decla-import-adic.cdn-banco"
     &Frame1="fPage7"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cdn-banco wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import-adic.cdn-banco IN FRAME fPage7 /* Banco */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import-adic.cdn-bco-agent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cdn-bco-agent wMaintenanceNoNavigation
ON F5 OF tt-decla-import-adic.cdn-bco-agent IN FRAME fPage7 /* Banco */
DO:
    {method/zoomfields.i 
     &ProgramZoom="adzoom/z10ad018.w"
     &FieldZoom1="cod-banco"
     &FieldScreen1="tt-decla-import-adic.cdn-bco-agent"
     &Frame1="fPage7"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cdn-bco-agent wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import-adic.cdn-bco-agent IN FRAME fPage7 /* Banco */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import-adic.cdn-corretor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cdn-corretor wMaintenanceNoNavigation
ON F5 OF tt-decla-import-adic.cdn-corretor IN FRAME fPage7 /* Cor.Cƒmbio */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                       &campo="tt-decla-import-adic.cdn-corretor"
                       &campozoom="cod-emitente"
                       &frame="fPage7"
                       &campo2="c-desc-corretor"
                       &campozoom2="nome-abrev"
                       &frame2="fPage7"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cdn-corretor wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-adic.cdn-corretor IN FRAME fPage7 /* Cor.Cƒmbio */
DO:
   if  valid-handle(h-boad098)
       and input frame fPage7 tt-decla-import-adic.cdn-corretor <> 0 then do:

        run findCodigo in h-boad098 (input input frame fPage7 tt-decla-import-adic.cdn-corretor, output c-return).
        if c-return = "" then do:
            run getcharfield in h-boad098 (input "nome-abrev", output c-descricao).
            assign c-desc-corretor:screen-value in frame fPage7 = c-descricao.
        end.
        else assign c-desc-corretor:screen-value in frame fPage7 = ''.
    end.
    else
        assign c-desc-corretor:screen-value in frame fPage7 = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cdn-corretor wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import-adic.cdn-corretor IN FRAME fPage7 /* Cor.Cƒmbio */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-decla-import-adic.cdn-fabrican
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cdn-fabrican wMaintenanceNoNavigation
ON F5 OF tt-decla-import-adic.cdn-fabrican IN FRAME fPage1 /* Fabricante */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-decla-import-adic.cdn-fabrican"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="c-nome-fabrican"
     &campozoom2="nome-abrev"
     &frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cdn-fabrican wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-adic.cdn-fabrican IN FRAME fPage1 /* Fabricante */
DO:
    {method/referencefields.i &HandleDBOLeave="h-boad098"
                              &FindMethod="findemitente"
                              &KeyValue1="int(tt-decla-import-adic.cdn-fabrican:SCREEN-VALUE IN FRAME fPage1)"
                              &FieldName1="nome-abrev" 
                              &FieldScreen1="c-nome-fabrican"
                              &Frame1="fPage1"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cdn-fabrican wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import-adic.cdn-fabrican IN FRAME fPage1 /* Fabricante */
DO:
    APPLY 'f5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import-adic.cdn-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cdn-fornec wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-adic.cdn-fornec IN FRAME fPage1 /* Fornecedor */
DO:
    {method/referencefields.i &HandleDBOLeave="h-boad098"
                              &FindMethod="findemitente"
                              &KeyValue1="int(tt-decla-import-adic.cdn-fornec:SCREEN-VALUE IN FRAME fPage1)"
                              &FieldName1="nome-abrev" 
                              &FieldScreen1="c-nome-fornec"
                              &Frame1="fPage1"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME tt-decla-import-adic.cod-agenc-agent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cod-agenc-agent wMaintenanceNoNavigation
ON F5 OF tt-decla-import-adic.cod-agenc-agent IN FRAME fPage7 /* Agencia */
DO:
    {include/zoomvar.i &prog-zoom= adzoom/z01ad009.w
                       &campo=tt-decla-import-adic.cod-agenc-agent
                       &campozoom=agencia
                       &parametros= "run pi-seta-inicial in wh-pesquisa (input input frame fPage7 tt-decla-import-adic.cdn-bco-agent)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cod-agenc-agent wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import-adic.cod-agenc-agent IN FRAME fPage7 /* Agencia */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt-decla-import-adic.cod-classif-fisc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cod-classif-fisc wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-adic.cod-classif-fisc IN FRAME fPage2 /* Class Fiscal */
DO:
    def var c-descClassif as char no-undo.

    ASSIGN tt-decla-import-adic.cod-classif-fisc:FORMAT IN FRAME fPage2 = "x(08)".
    RUN piTrataClassFiscItem IN  h-boin172desc ( input input frame fPage2 tt-decla-import-adic.cod-classif-fisc).

    IF RETURN-VALUE = "OK" THEN ASSIGN tt-decla-import-adic.cod-classif-fisc:FORMAT IN FRAME fPage2 = "9999.99.99".
    
    run getDescClassFiscal in h-boin172desc ( input  input frame fPage2 tt-decla-import-adic.cod-classif-fisc, output c-descClassif ).
    IF RETURN-VALUE = "NOK":U 
    THEN ASSIGN c-desc-class-fis:SCREEN-VALUE IN FRAME fPage2  = "".
    ELSE assign c-desc-class-fis:SCREEN-VALUE IN FRAME fPage2  = c-descClassif.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME tt-decla-import-adic.cod-incoterm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.cod-incoterm wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-adic.cod-incoterm IN FRAME fpage3 /* Incoterm */
DO:
    {method/referencefields.i &HandleDBOLeave="h-bocx025"
                              &FindMethod="findPK_incoterm" NO-LOCK
                              &KeyValue1="tt-decla-import-adic.cod-incoterm:SCREEN-VALUE IN FRAME fPage3"
                              &FieldName1="descricao"
                              &FieldScreen1="c-desc-incoterm"
                              &Frame1="fPage3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME de-qtde-is
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-qtde-is wMaintenanceNoNavigation
ON LEAVE OF de-qtde-is IN FRAME fPage5 /* Qtde Tribut vel */
DO:
    IF INPUT FRAME fPage5 de-val-aliq-ibsuf <> 0 THEN DO:
        FIND FIRST class-trib NO-LOCK
             WHERE class-trib.cod-cclass-trib = c-class-trib-ibsuf:SCREEN-VALUE IN FRAME fpage5
               AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
        IF AVAIL class-trib
        AND class-trib.trib-regular = 1 THEN DO:
            ASSIGN de-val-aliq-reg-ibsuf:SCREEN-VALUE IN FRAME fPage5 = de-val-aliq-ibsuf:SCREEN-VALUE IN FRAME fPage5.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-aliq-cbs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-aliq-cbs wMaintenanceNoNavigation
ON LEAVE OF de-val-aliq-cbs IN FRAME fPage5
DO:
    IF INPUT FRAME fPage5 de-val-aliq-cbs <> 0 THEN DO:
        FIND FIRST class-trib NO-LOCK
             WHERE class-trib.cod-cclass-trib = c-class-trib-cbs:SCREEN-VALUE IN FRAME fpage5
               AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
        IF AVAIL class-trib
        AND class-trib.trib-regular = 1 THEN DO:
            ASSIGN de-val-aliq-reg-cbs:SCREEN-VALUE IN FRAME fPage5 = de-val-aliq-cbs:SCREEN-VALUE IN FRAME fPage5.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-aliq-espec-is
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-aliq-espec-is wMaintenanceNoNavigation
ON LEAVE OF de-val-aliq-espec-is IN FRAME fPage5 /* Aliq Espec Un */
DO:
    IF INPUT FRAME fPage5 de-val-aliq-ibsuf <> 0 THEN DO:
        FIND FIRST class-trib NO-LOCK
             WHERE class-trib.cod-cclass-trib = c-class-trib-ibsuf:SCREEN-VALUE IN FRAME fpage5
               AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
        IF AVAIL class-trib
        AND class-trib.trib-regular = 1 THEN DO:
            ASSIGN de-val-aliq-reg-ibsuf:SCREEN-VALUE IN FRAME fPage5 = de-val-aliq-ibsuf:SCREEN-VALUE IN FRAME fPage5.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-aliq-ibsmun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-aliq-ibsmun wMaintenanceNoNavigation
ON LEAVE OF de-val-aliq-ibsmun IN FRAME fPage5
DO:
    IF INPUT FRAME fPage5 de-val-aliq-ibsmun <> 0 THEN DO:
        FIND FIRST class-trib NO-LOCK
             WHERE class-trib.cod-cclass-trib = c-class-trib-ibsmun:SCREEN-VALUE IN FRAME fpage5
               AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
        IF AVAIL class-trib
        AND class-trib.trib-regular = 1 THEN DO:
            ASSIGN de-val-aliq-reg-ibsmun:SCREEN-VALUE IN FRAME fPage5 = de-val-aliq-ibsmun:SCREEN-VALUE IN FRAME fPage5.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-aliq-ibsuf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-aliq-ibsuf wMaintenanceNoNavigation
ON LEAVE OF de-val-aliq-ibsuf IN FRAME fPage5
DO:
    IF INPUT FRAME fPage5 de-val-aliq-ibsuf <> 0 THEN DO:
        FIND FIRST class-trib NO-LOCK
             WHERE class-trib.cod-cclass-trib = c-class-trib-ibsuf:SCREEN-VALUE IN FRAME fpage5
               AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
        IF AVAIL class-trib
        AND class-trib.trib-regular = 1 THEN DO:
            ASSIGN de-val-aliq-reg-ibsuf:SCREEN-VALUE IN FRAME fPage5 = de-val-aliq-ibsuf:SCREEN-VALUE IN FRAME fPage5.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-decla-import-adic.log-emite-fabrican
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.log-emite-fabrican wMaintenanceNoNavigation
ON VALUE-CHANGED OF tt-decla-import-adic.log-emite-fabrican IN FRAME fPage1 /* Fornecedor ‚ Fabricante */
DO:
    if tt-decla-import-adic.log-emite-fabrican:screen-value in frame fPage1 = 'sim' 
    then do:
        assign tt-decla-import-adic.cdn-fabrican:screen-value in frame fPage1 = string(tt-decla-import-adic.cdn-fabrican).
        apply 'leave' to tt-decla-import-adic.cdn-fabrican in frame fPage1.
               
        disable tt-decla-import-adic.cdn-fabrican with frame fPage1.
    end.
    else enable tt-decla-import-adic.cdn-fabrican with frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME tt-decla-import-adic.log-mater-encomen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.log-mater-encomen wMaintenanceNoNavigation
ON VALUE-CHANGED OF tt-decla-import-adic.log-mater-encomen IN FRAME fpage3 /* Sob Encomenda */
DO:
  IF tt-decla-import-adic.log-mater-encomen:CHECKED 
     AND tt-decla-import-adic.log-mater-usado:CHECKED THEN
      ASSIGN tt-decla-import-adic.log-mater-usado:CHECKED = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import-adic.log-mater-usado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-adic.log-mater-usado wMaintenanceNoNavigation
ON VALUE-CHANGED OF tt-decla-import-adic.log-mater-usado IN FRAME fpage3 /* Usado */
DO:
  IF tt-decla-import-adic.log-mater-encomen:CHECKED 
     AND tt-decla-import-adic.log-mater-usado:CHECKED THEN
      ASSIGN tt-decla-import-adic.log-mater-encomen:CHECKED = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage8
&Scoped-define SELF-NAME rs-mostra-tela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-mostra-tela wMaintenanceNoNavigation
ON VALUE-CHANGED OF rs-mostra-tela IN FRAME fPage8
DO:
    ASSIGN INPUT FRAME fPage8 rs-mostra-tela.

    IF  INPUT FRAME fPage8 rs-mostra-tela = 1 /* Acr‚scimos */ THEN DO:
        ASSIGN tt-decla-import-adic.dsl-compl-adic:VISIBLE   IN FRAME fPage8 = NO
               tt-decla-import-adic.dsl-compl-adic:SENSITIVE IN FRAME fPage8 = NO
               brAcres:VISIBLE      IN FRAME fPage8 = yes
               btIncAcres:VISIBLE   IN FRAME fPage8 = yes  
               btAltAcres:VISIBLE   IN FRAME fPage8 = yes  
               btExcAcres:VISIBLE   IN FRAME fPage8 = yes.  
    END. /* IF  INPUT FRAME fPage8 rs-mostra-tela */
    ELSE DO: /* Complementos */
        ASSIGN tt-decla-import-adic.dsl-compl-adic:VISIBLE   IN FRAME fPage8 = YES
               tt-decla-import-adic.dsl-compl-adic:SENSITIVE IN FRAME fPage8 = YES
               brAcres:VISIBLE      IN FRAME fPage8 = no
               btIncAcres:VISIBLE   IN FRAME fPage8 = no  
               btAltAcres:VISIBLE   IN FRAME fPage8 = no  
               btExcAcres:VISIBLE   IN FRAME fPage8 = no.  
    END. /* ELSE DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brAcres
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

if tt-decla-import-adic.cdn-fabrican:load-mouse-pointer ("image/lupa.cur") in frame fPage1 then.
if tt-decla-import-adic.cdn-fornec:load-mouse-pointer ("image/lupa.cur") in frame fPage1 then.
if tt-decla-import-adic.cod-classif-fisc:load-mouse-pointer ("image/lupa.cur") in frame fPage2 then.
if tt-decla-import-adic.cod-incoterm:load-mouse-pointer ("image/lupa.cur") in frame fPage3 then.
if tt-decla-import-adic.cdn-corretor:load-mouse-pointer ("image/lupa.cur") in frame fPage7 then.
if tt-decla-import-adic.cdn-agent:load-mouse-pointer ("image/lupa.cur") in frame fPage7 then.
if tt-decla-import-adic.cdn-banco:load-mouse-pointer ("image/lupa.cur") in frame fPage7 then.
if tt-decla-import-adic.cdn-bco-agent:load-mouse-pointer ("image/lupa.cur") in frame fPage7 then.
if tt-decla-import-adic.cod-agenc-agent:load-mouse-pointer ("image/lupa.cur") in frame fPage7 then.

IF c-class-trib-ibsuf:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.
IF c-class-trib-ibsmun:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.
IF c-class-trib-cbs:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.
IF c-class-trib-reg-ibsuf:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.
IF c-class-trib-reg-ibsmun:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.
IF c-class-trib-reg-cbs:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.
IF c-class-trib-is:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.
IF c-un-trib-is:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.

/*---[Browse NVE fPage3 ]-------------------------------------------------------------------------------------------------*/

ON 'F5', mouse-select-dblclick OF tt-decla-import-adic-nve-aux.idi-niv IN BROWSE brNVE DO:
    if  num-results("brNVE") > 0 then do:
        assign i-filtro = 1
               l-zoom   = yes.

              {method/zoomfields.i 
                 &ProgramZoom="cxzoom/z10cx090.w"
                 &FieldZoom1="cod-ident"
                 &FieldScreen1="tt-decla-import-adic-nve-aux.cod-ident"
                 &browse1="brNVE"
                 &FieldZoom2="cod-atrib"
                 &FieldScreen2="tt-decla-import-adic-nve-aux.cod-atrib"
                 &browse2="brNVE"
                 &FieldZoom3="cdn-especif"
                 &FieldScreen3="tt-decla-import-adic-nve-aux.cdn-especif"
                 &browse3="brNVE"
                 &FieldZoom4="idi-niv"
                 &FieldScreen4="tt-decla-import-adic-nve-aux.idi-niv"
                 &browse4="brNVE"}
                WAIT-FOR CLOSE OF hProgramZoom.   
                IF RETURN-VALUE = "OK":U THEN DO:
                    APPLY 'LEAVE' TO tt-decla-import-adic-nve-aux.idi-niv IN BROWSE brNVE.
                    APPLY 'LEAVE' TO tt-decla-import-adic-nve-aux.cod-atrib IN BROWSE brNVE.
                    APPLY 'LEAVE' TO tt-decla-import-adic-nve-aux.cdn-especif IN BROWSE brNVE.
                END.

        assign l-zoom = no.
    end.
END.

ON 'F5', mouse-select-dblclick OF tt-decla-import-adic-nve-aux.cod-ident IN BROWSE brNVE DO:
    if  num-results("brNVE") > 0 then do:
        assign i-filtro = 1
               l-zoom   = yes.

              {method/zoomfields.i 
                 &ProgramZoom="cxzoom/z10cx090.w"
                 &FieldZoom1="cod-ident"
                 &FieldScreen1="tt-decla-import-adic-nve-aux.cod-ident"
                 &browse1="brNVE"
                 &FieldZoom2="cod-atrib"
                 &FieldScreen2="tt-decla-import-adic-nve-aux.cod-atrib"
                 &browse2="brNVE"
                 &FieldZoom3="cdn-especif"
                 &FieldScreen3="tt-decla-import-adic-nve-aux.cdn-especif"
                 &browse3="brNVE"
                 &FieldZoom4="idi-niv"
                 &FieldScreen4="tt-decla-import-adic-nve-aux.idi-niv"
                 &browse4="brNVE"}
                WAIT-FOR CLOSE OF hProgramZoom.   
                IF RETURN-VALUE = "OK":U THEN DO:
                    APPLY 'LEAVE' TO tt-decla-import-adic-nve-aux.idi-niv IN BROWSE brNVE.
                    APPLY 'LEAVE' TO tt-decla-import-adic-nve-aux.cod-atrib IN BROWSE brNVE.
                    APPLY 'LEAVE' TO tt-decla-import-adic-nve-aux.cdn-especif IN BROWSE brNVE.
                END.

        assign l-zoom = no.
    end.
END.

on  'F5', mouse-select-dblclick of tt-decla-import-adic-nve-aux.cod-atrib in browse brNVE do:

    if  num-results("brNVE") > 0 then do:
        assign i-filtro = 1
               l-zoom   = yes.

              {method/zoomfields.i 
                 &ProgramZoom="cxzoom/z10cx090.w"
                 &FieldZoom1="cod-ident"
                 &FieldScreen1="tt-decla-import-adic-nve-aux.cod-ident"
                 &browse1="brNVE"
                 &FieldZoom2="cod-atrib"
                 &FieldScreen2="tt-decla-import-adic-nve-aux.cod-atrib"
                 &browse2="brNVE"
                 &FieldZoom3="cdn-especif"
                 &FieldScreen3="tt-decla-import-adic-nve-aux.cdn-especif"
                 &browse3="brNVE"
                 &FieldZoom4="idi-niv"
                 &FieldScreen4="tt-decla-import-adic-nve-aux.idi-niv"
                 &browse4="brNVE"}
                WAIT-FOR CLOSE OF hProgramZoom.   
                IF RETURN-VALUE = "OK":U THEN DO:
                    APPLY 'LEAVE' TO tt-decla-import-adic-nve-aux.idi-niv IN BROWSE brNVE.
                    APPLY 'LEAVE' TO tt-decla-import-adic-nve-aux.cod-atrib IN BROWSE brNVE.
                    APPLY 'LEAVE' TO tt-decla-import-adic-nve-aux.cdn-especif IN BROWSE brNVE.
                END.

        assign l-zoom = no.
    end.
end.

on  'F5', mouse-select-dblclick of tt-decla-import-adic-nve-aux.cdn-especif in browse brNVE do:

    if  num-results("brNVE") > 0 then do:
        assign i-filtro = 1
               l-zoom   = yes.

              {method/zoomfields.i 
                 &ProgramZoom="cxzoom/z10cx090.w"
                 &FieldZoom1="cod-ident"
                 &FieldScreen1="tt-decla-import-adic-nve-aux.cod-ident"
                 &browse1="brNVE"
                 &FieldZoom2="cod-atrib"
                 &FieldScreen2="tt-decla-import-adic-nve-aux.cod-atrib"
                 &browse2="brNVE"
                 &FieldZoom3="cdn-especif"
                 &FieldScreen3="tt-decla-import-adic-nve-aux.cdn-especif"
                 &browse3="brNVE"
                 &FieldZoom4="idi-niv"
                 &FieldScreen4="tt-decla-import-adic-nve-aux.idi-niv"
                 &browse4="brNVE"}
                WAIT-FOR CLOSE OF hProgramZoom.   
                IF RETURN-VALUE = "OK":U THEN DO:
                    APPLY 'LEAVE' TO tt-decla-import-adic-nve-aux.idi-niv IN BROWSE brNVE.
                    APPLY 'LEAVE' TO tt-decla-import-adic-nve-aux.cod-atrib IN BROWSE brNVE.
                    APPLY 'LEAVE' TO tt-decla-import-adic-nve-aux.cdn-especif IN BROWSE brNVE.
                END.

        assign l-zoom = no.
    end.
end.

ON LEAVE OF tt-decla-import-adic-nve-aux.idi-niv IN BROWSE brNVE DO:
    ASSIGN p-idi-niv = INPUT BROWSE brNVE tt-decla-import-adic-nve-aux.idi-niv.
    ASSIGN c-desc-nivel = fnNivel(p-idi-niv) WHEN p-idi-niv <> 0
           c-desc-nivel:SCREEN-VALUE IN BROWSE brNVE = fnNivel(INPUT p-idi-niv) WHEN p-idi-niv <> 0.

END.

ON LEAVE OF tt-decla-import-adic-nve-aux.cod-atrib IN BROWSE brNVE DO:
  ASSIGN p-idi-niv = INPUT BROWSE brNVE tt-decla-import-adic-nve-aux.idi-niv
         p-cod-ident = INPUT BROWSE brNVE tt-decla-import-adic-nve-aux.cod-ident
         p-cod-atrib = INPUT BROWSE brNVE tt-decla-import-adic-nve-aux.cod-atrib.
  
  ASSIGN c-desc-atributo = fnDescAtributo(p-idi-niv,p-cod-ident,p-cod-atrib).
         c-desc-atributo:SCREEN-VALUE IN BROWSE brNVE = fnDescAtributo(p-idi-niv,p-cod-ident,p-cod-atrib).

END.

ON LEAVE OF tt-decla-import-adic-nve-aux.cdn-especif IN BROWSE brNVE DO:
  ASSIGN p-idi-niv = INPUT BROWSE brNVE tt-decla-import-adic-nve-aux.idi-niv
         p-cod-ident = INPUT BROWSE brNVE tt-decla-import-adic-nve-aux.cod-ident
         p-cod-atrib = INPUT BROWSE brNVE tt-decla-import-adic-nve-aux.cod-atrib
         p-cdn-especif = INPUT BROWSE brNVE tt-decla-import-adic-nve-aux.cdn-especif.

  ASSIGN c-desc-especif = fnDescEspecif(p-idi-niv,p-cod-ident,p-cod-atrib,p-cdn-especif).
         c-desc-especif:SCREEN-VALUE IN BROWSE brNVE = fnDescEspecif(p-idi-niv,p-cod-ident,p-cod-atrib,p-cdn-especif).

END.

/*---[Browse NVE fPage3 ]-------------------------------------------------------------------------------------------------*/

/*---[Browse brParcelas fPage7 ]------------------------------------------------------------------------------------------*/
ON ENTRY OF tt-decla-import-adic-parc-aux.idi-tip-pagto IN BROWSE brParcelas DO:
    ASSIGN tt-decla-import-adic-parc-aux.num-mes-parc:READ-ONLY IN BROWSE brParcelas = NO
           tt-decla-import-adic-parc-aux.num-ano-parc:READ-ONLY IN BROWSE brParcelas = NO.
END.

ON LEAVE OF tt-decla-import-adic-parc-aux.idi-tip-pagto IN BROWSE brParcelas DO:
    ASSIGN INPUT FRAME fPage7 cb-idi-ind-pagto
           i-pagamento = {cxinc/i02cx404.i 06 cb-idi-ind-pagto}.
    
        IF tt-decla-import-adic-parc-aux.idi-tip-pagto:SCREEN-VALUE IN BROWSE brParcelas = "3" 
           AND (i-pagamento = 1 OR i-pagamento = 2)  THEN DO:
            ASSIGN tt-decla-import-adic-parc-aux.num-mes-parc:READ-ONLY IN BROWSE brParcelas = NO
                   tt-decla-import-adic-parc-aux.num-ano-parc:READ-ONLY IN BROWSE brParcelas = NO.
        END.
        ELSE DO: 
            ASSIGN tt-decla-import-adic-parc-aux.num-mes-parc:READ-ONLY IN BROWSE brParcelas = YES
                   tt-decla-import-adic-parc-aux.num-ano-parc:READ-ONLY IN BROWSE brParcelas = YES.
        END.
END.

ASSIGN tt-decla-import.cod-di-siscomex:FORMAT IN FRAME fPage0 = "x(20)".

/*---[Browse brParcelas fPage7 ]------------------------------------------------------------------------------------------*/
{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF VALID-HANDLE(h-bocx025) THEN DO:
    DELETE PROCEDURE h-bocx025.
    ASSIGN h-bocx025 = ?.
END.

IF VALID-HANDLE(h-bocx225) THEN DO:
    DELETE PROCEDURE h-bocx225.
    ASSIGN h-bocx225 = ?.
END.

IF VALID-HANDLE(h-bocx225e) THEN DO:
    DELETE PROCEDURE h-bocx225e.
    ASSIGN h-bocx225e = ?.
END.

IF VALID-HANDLE(h-bocx351) THEN DO:
    DELETE PROCEDURE h-bocx351.
    ASSIGN h-bocx351 = ?.
END.

IF VALID-HANDLE(h-bocx390) THEN DO:
    DELETE PROCEDURE h-bocx390.
    ASSIGN h-bocx390 = ?.
END.

IF VALID-HANDLE(h-bocx392) THEN DO:
    DELETE PROCEDURE h-bocx392.
    ASSIGN h-bocx392 = ?.
END.

IF VALID-HANDLE(h-bocx393) THEN DO:
    DELETE PROCEDURE h-bocx393.
    ASSIGN h-bocx393 = ?.
END.

IF VALID-HANDLE(h-bocx394) THEN DO:
    DELETE PROCEDURE h-bocx394.
    ASSIGN h-bocx394 = ?.
END.

IF VALID-HANDLE(h-bocx397) THEN DO:
    DELETE PROCEDURE h-bocx397.
    ASSIGN h-bocx397 = ?.
END.

IF VALID-HANDLE(h-bocx398) THEN DO:
    DELETE PROCEDURE h-bocx398.
    ASSIGN h-bocx398 = ?.
END.

IF VALID-HANDLE(h-bocx402) THEN DO:
    DELETE PROCEDURE h-bocx402.
    ASSIGN h-bocx402 = ?.
END.

IF VALID-HANDLE(h-bocx404) THEN DO:
    DELETE PROCEDURE h-bocx404.
    ASSIGN h-bocx404 = ?.
END.

IF VALID-HANDLE(h-bocx407) THEN DO:
    DELETE PROCEDURE h-bocx407.
    ASSIGN h-bocx407 = ?.
END.

IF VALID-HANDLE(h-boad098) THEN DO:
    DELETE PROCEDURE h-boad098.
    ASSIGN h-boad098 = ?.
END.

IF VALID-HANDLE(h-boin172na) THEN DO:
    DELETE PROCEDURE h-boin172na.
    ASSIGN h-boin172na = ?.
END.

IF VALID-HANDLE(h-boin172desc) THEN DO:
    DELETE PROCEDURE h-boin172desc.
    ASSIGN h-boin172desc = ?.
END.

IF VALID-HANDLE(h-boun005) THEN DO:
    DELETE PROCEDURE h-boun005.
    ASSIGN h-boun005 = ?.
END.

IF VALID-HANDLE(h-boun006) THEN DO:
    DELETE PROCEDURE h-boun006.
    ASSIGN h-boun006 = ?.
END.

IF VALID-HANDLE(h-boin245) THEN DO:
    DELETE PROCEDURE h-boin245.
    ASSIGN h-boin245 = ?.
END.

IF VALID-HANDLE(h-im0410c) THEN DO:
    DELETE PROCEDURE h-im0410c.
    ASSIGN h-im0410c = ?.
END.

IF VALID-HANDLE(h-im0410d) THEN DO:
    DELETE PROCEDURE h-im0410d.
    ASSIGN h-im0410d = ?.
END.

IF VALID-HANDLE(h-bocx383a) THEN DO:
    DELETE PROCEDURE h-bocx383a.
    ASSIGN h-bocx383a = ?.
END.

IF VALID-HANDLE(h-bocx389) THEN DO:
    DELETE PROCEDURE h-bocx389.
    ASSIGN h-bocx389 = ?.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisableFields wMaintenanceNoNavigation 
PROCEDURE afterDisableFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DISABLE brNVE WITH FRAME fPage2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF  AVAIL tt-decla-import-adic THEN DO:
    
        run piContaRegistro in {&hDBOTable} (input tt-decla-import-adic.num-di-ems,
                                             input tt-decla-import-adic.cdd-siscomex-dts,
                                             output i-nr-registro).
        assign c-registro:screen-value in frame fPage0 = string(i-num-linha-browse) + "/" + string(i-nr-registro).
    
        ASSIGN rRowid = tt-decla-import-adic.r-Rowid.

        DISP label-docto WITH FRAME fPage1.
        DISP label-nve label-recip WITH FRAME fPage2.
        DISP label-valores label-moeda label-dolar label-reais label-vmcv label-vmle label-vmld label-frete label-seguro label-acresc  WITH FRAME fPage6.
        DISP label-tributac label-aliq label-susp label-reduc label-vl-unit label-base-calc label-valor label-ii label-ipi label-icms label-pis label-cofins WITH FRAME fPage4.
        DISP label-parc WITH FRAME fPage7.

        APPLY 'LEAVE'         TO tt-decla-import-adic.cdn-fornec       IN FRAME fPage1.
        APPLY 'LEAVE'         TO tt-decla-import-adic.cdn-fabrican     IN FRAME fPage1. 
        APPLY 'LEAVE'         TO tt-decla-import-adic.cod-classif-fisc IN FRAME fPage2.
        APPLY 'LEAVE'         TO tt-decla-import-adic.cod-incoterm     IN FRAME fPage3.
        APPLY 'LEAVE'         TO tt-decla-import-adic.cdn-corretor     IN FRAME fPage7.
        APPLY 'LEAVE'         TO tt-decla-import-adic.cdn-agent        IN FRAME fPage7.
        APPLY 'value-changed' TO brItens                               IN FRAME fPage3.
        APPLY 'value-changed' TO cb-idi-ind-pagto                      IN FRAME fPage7.
        APPLY 'VALUE-CHANGED' TO rs-mostra-tela                        IN FRAME fPage8.
        
        /*--- UN NCM ---*/
        RUN piRetornaUnidadeNCM IN {&hDBOTable} (INPUT tt-decla-import-adic.num-di-ems, 
                                                 INPUT tt-decla-import-adic.num-adic,
                                                 INPUT tt-decla-import-adic.cdd-siscomex-dts,
                                                 OUTPUT c-un-ncm).
        DISP c-un-ncm WITH FRAME fPage3.
        /*--- UN NCM ---*/

        RUN pi-trata-combos.
        RUN pi-busca-documentos-vinculados.
        RUN pi-busca-NVE.
        RUN pi-busca-itens.
        RUN pi-busca-parcelas.
        RUN pi-busca-despesas.
        
        RUN pi-busca-valores.

        RUN pi-altera-di. /* altera di */

        RUN pi-busca-valor-impostos. /* busca os valores dos impostos */
    END. /* IF  AVAIL tt-decla-import-adic */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    /*---[ Documentos Vinculados ]--------------------------------------------*/
    IF  AVAIL tt-decla-import-adic-docto-aux THEN DO: 
        ENABLE brDoctoVinc btAddDocumento btDelDocumento WITH FRAME fPage1.
        DISABLE btCanDocumento btSaveDocumento WITH FRAME fPage1.
    END.
    ELSE DO:
        ENABLE btAddDocumento WITH FRAME fPage1.
        DISABLE btDelDocumento btCanDocumento btSaveDocumento WITH FRAME fPage1.
    END.

    /*---[ NVE ]--------------------------------------------------------------*/
    IF  AVAIL tt-decla-import-adic-nve-aux THEN DO: 
        ENABLE brNVE btAddNVE btDelNVE WITH FRAME fPage2.
        DISABLE btCanNVE btSaveNVE WITH FRAME fPage2.
    END.
    ELSE DO:
        ENABLE btAddNVE WITH FRAME fPage2.
        DISABLE btDelNVE btCanNVE btSaveNVE WITH FRAME fPage2.
    END.

    /*---[ Itens ]------------------------------------------------------------*/
    IF  AVAIL tt-decla-import-adic-itens-aux 
    THEN  ENABLE brItens btModificaItens WITH FRAME fPage3.
    ELSE DISABLE brItens btModificaItens WITH FRAME fPage3.
    
    DISABLE tt-decla-import-adic.cdn-motivo tt-decla-import-adic.cod-rof WITH FRAME fPage7.

    /*---[ Parcelas ]---------------------------------------------------------*/
    IF  AVAIL tt-decla-import-adic-parc-aux THEN DO: 
        ENABLE brParcelas btAddParcela btDelParcela WITH FRAME fPage7.
        DISABLE btCanParcela btSaveParcela WITH FRAME fPage7.
    END.
    ELSE DO:
        ENABLE btAddParcela WITH FRAME fPage7.
        DISABLE btDelParcela btCanParcela btSaveParcela WITH FRAME fPage7.
    END.

    /*---[ Despesas ]--------------------------------------------------------*/
    IF  AVAIL tt-despes-adic-aux THEN do:
        ENABLE btIncAcres btAltAcres btExcAcres WITH FRAME fPage8.
    END.
    ELSE do:
        DISABLE brAcres btAltAcres btExcAcres WITH FRAME fPage8.
        ENABLE btIncAcres WITH FRAME fPage8.
    END.

    ENABLE brNVE WITH FRAME fPage2.
    ENABLE brAcres WITH FRAME fPage8.
    ASSIGN tt-decla-import-adic-docto-aux.cod-num-docto:READ-ONLY        IN BROWSE brDoctoVinc = yes
           tt-decla-import-adic-docto-aux.idi-tip-docto-vincul:READ-ONLY IN BROWSE brDoctoVinc = yes
           tt-decla-import-adic-nve-aux.idi-niv:READ-ONLY                IN BROWSE brNVE = yes
           tt-decla-import-adic-nve-aux.cod-ident:READ-ONLY              IN BROWSE brNVE = yes
           tt-decla-import-adic-nve-aux.cod-atributo:READ-ONLY           IN BROWSE brNVE = yes
           tt-decla-import-adic-nve-aux.cdn-especif:READ-ONLY            IN BROWSE brNVE = yes
           tt-decla-import-adic-parc-aux.idi-tip-pagto:READ-ONLY         IN BROWSE brParcelas = yes
           tt-decla-import-adic-parc-aux.num-seq-parc:READ-ONLY          IN BROWSE brParcelas = yes
           tt-decla-import-adic-parc-aux.num-mes-parc:READ-ONLY          IN BROWSE brParcelas = yes
           tt-decla-import-adic-parc-aux.num-ano-parc:READ-ONLY          IN BROWSE brParcelas = yes
           tt-decla-import-adic-parc-aux.val-parc:READ-ONLY              IN BROWSE brParcelas = yes.

    RUN pi-altera-di. /* altera di */

    RUN pi-busca-valores.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    IF NOT l-nt2024002 THEN
        RUN DeleteFolder IN hFolder (INPUT 5).
    ELSE DO:
        DISABLE cb-idi-tributac-ibsuf       cb-idi-tributac-ibsmun       cb-idi-tributac-cbs     cb-idi-tributac-is
                de-base-ibsuf               de-base-ibsmun               de-base-cbs             de-base-is
                de-valor-impostos-ibsuf     de-valor-impostos-ibsmun     de-valor-impostos-cbs   de-valor-impostos-is
                de-val-aliq-reg-ibsuf       de-val-aliq-reg-ibsmun       de-val-aliq-reg-cbs
                de-base-reg-ibsuf           de-base-reg-ibsmun           de-base-reg-cbs
                de-valor-impostos-reg-ibsuf de-valor-impostos-reg-ibsmun de-valor-impostos-reg-cbs WITH FRAME fPage5.
    END.
    
    RUN setConstraintByDI IN {&hDBOTable} (INPUT tt-decla-import-adic.num-di-ems,
                                           INPUT tt-decla-import-adic.cdd-siscomex-dts).
    RUN openQueryStatic   IN {&hDBOTable} (INPUT 'ByDI':U).
    
    run piContaRegistro in {&hDBOTable} (input tt-decla-import-adic.num-di-ems, 
                                         INPUT tt-decla-import-adic.cdd-siscomex-dts,
                                         output i-nr-registro).
    assign c-registro:screen-value in frame fPage0 = string(i-num-linha-browse) + "/" + string(i-nr-registro).
    
    if i-num-linha-browse = 1 and i-nr-registro = 1 
    then disable btSave bt-nex bt-pre with frame fPage0.
    else  enable btSave bt-nex bt-pre with frame fPage0.

    APPLY 'VALUE-CHANGED' TO tt-decla-import-adic.log-emite-fabrican IN FRAME fPage1.
    
    DISABLE cb-idi-ind-pagto WITH FRAME fPage7.
    DISABLE tt-decla-import-adic.cdn-fornec WITH FRAME fPage1.
    DISABLE tt-decla-import-adic.cdn-classif-fisc-ex 
            tt-decla-import-adic.cod-classif-fisc WITH FRAME fPage2. 
    DISABLE tt-decla-import-adic.cod-incoterm 
            tt-decla-import-adic.val-peso-liq 
            tt-decla-import-adic.qtd-ncm WITH FRAME fPage3.

    DISABLE de-val-aliq-fcp 
            de-val-base-fcp 
            de-val-fcp
            de-val-aliq-fcp-substto 
            de-val-base-fcp-substto 
            de-val-fcp-substto 
            de-val-base-icms-substto 
            de-val-icms-substto
            de-val-base-icms-compltar 
            de-val-icms-compltar 
        WITH FRAME fPage4.

    /* se for primeiro registro desabilita botao bt-pre */
    if  i-num-linha-browse = 1 OR i-num-linha-browse = 0 then do:
        RUN getFirst IN {&hDBOTable}.
        assign bt-pre:sensitive in frame fPage0 = no.
    end.
    /* se for o ultimo registro desabilita o botao bt-nex */
    IF i-num-linha-browse = i-nr-registro THEN DO:
        RUN getLast IN {&hDBOTable}.
        ASSIGN bt-nex:SENSITIVE IN FRAME fPage0 = NO.
    END.
    
    RUN pi-verifica-despes-acresc.

    RUN pi-habilita-campos.

    RUN pi-busca-valor-impostos. /* busca os valores dos impostos */

    RUN pi-cria-impostos-aux. /* cria tt com os valores iniciais dos impostos */
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao006 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao007 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao008 AS CHARACTER NO-UNDO.

        /* M‚todo de Valora‡Æo */
        ASSIGN cAuxTraducao001 = {cxinc/i01cx404.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-idi-metod-val:LIST-ITEM-PAIRS in frame fPage2 = cAuxTraducao001.

        /* Pagamento */
        ASSIGN cAuxTraducao002 = {cxinc/i02cx404.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
        ASSIGN cb-idi-ind-pagto:LIST-ITEM-PAIRS in frame fPage7 = cAuxTraducao002.

        /* Impto-Import */
        ASSIGN cAuxTraducao003 = {cxinc/i01cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao003).
        ASSIGN cb-idi-tributac-impto-import:LIST-ITEM-PAIRS in frame fPage4 = cAuxTraducao003.

        /* IPI */
        ASSIGN cAuxTraducao004 = {cxinc/i01cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao004).
        ASSIGN cb-idi-tributac-ipi:LIST-ITEM-PAIRS in frame fPage4 = cAuxTraducao004.

        /* ICMS */
        ASSIGN cAuxTraducao005 = {cxinc/i02cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao005).
        ASSIGN cb-idi-tributac-icms:LIST-ITEM-PAIRS in frame fPage4 = cAuxTraducao005.

        /* PIS */
        ASSIGN cAuxTraducao006 = {cxinc/i01cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao006).
        ASSIGN cb-idi-tributac-pis:LIST-ITEM-PAIRS in frame fPage4 = cAuxTraducao006.

        /* COFINS */
        ASSIGN cAuxTraducao007 = {cxinc/i01cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao007).
        ASSIGN cb-idi-tributac-cofins:LIST-ITEM-PAIRS in frame fPage4 = cAuxTraducao007.

        /* INDICADOR DE VINCULA€ÇO */
        ASSIGN cAuxTraducao008 = {cxinc/i03cx403.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao008).
        ASSIGN cb-idi-ind-vincul:LIST-ITEM-PAIRS in frame fPage1 = cAuxTraducao008.
    &else
        ASSIGN cb-idi-metod-val:LIST-ITEMS             in frame fPage3 = {cxinc/i01cx404.i 03}
               cb-idi-ind-pagto:LIST-ITEMS             in frame fPage7 = {cxinc/i02cx404.i 03}
               cb-idi-tributac-impto-import:LIST-ITEMS in frame fPage4 = {cxinc/i01cx402.i 03}
               cb-idi-tributac-ipi:LIST-ITEMS          in frame fPage4 = {cxinc/i01cx402.i 03}
               cb-idi-tributac-icms:LIST-ITEMS         in frame fPage4 = {cxinc/i02cx402.i 03}
               cb-idi-tributac-pis:LIST-ITEMS          in frame fPage4 = {cxinc/i01cx402.i 03}
               cb-idi-tributac-cofins:LIST-ITEMS       in frame fPage4 = {cxinc/i01cx402.i 03}
               cb-idi-ind-vincul:LIST-ITEMS            in frame fPage1 = {cxinc/i03cx403.i 03} .
    &endif

    ASSIGN cb-idi-tributac-ibsuf:LIST-ITEMS  IN FRAME fPage5 = {diinc/i01di628.i 03}
           cb-idi-tributac-ibsmun:LIST-ITEMS IN FRAME fPage5 = {diinc/i01di628.i 03}
           cb-idi-tributac-cbs:LIST-ITEMS    IN FRAME fPage5 = {diinc/i01di628.i 03}
           cb-idi-tributac-is:LIST-ITEMS    IN FRAME fPage5 = {diinc/i01di628.i 03}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOSonHandle wMaintenanceNoNavigation 
PROCEDURE getDBOSonHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE  INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pDBOHandle  AS HANDLE  NO-UNDO.

    CASE pPageNumber:        
        WHEN 4 THEN DO:
            ASSIGN pDBOHandle = h-bocx402. /* itens */
        END.
        WHEN 8 THEN DO:
            ASSIGN pDBOHandle = h-bocx390. /* despesas */
        END.
    END CASE.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParentRecord wMaintenanceNoNavigation 
PROCEDURE getParentRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-decla-import-adic.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
    Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF  NOT VALID-HANDLE({&hDBOTable}) OR
        {&hDBOTable}:TYPE      <> "PROCEDURE":U OR
        {&hDBOTable}:FILE-NAME <> "cxbo/bocx403.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx403.p YES}
        {btb/btb008za.i2 cxbo/bocx403.p '' {&hDBOTable}}
    END.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE (h-bocx025)     THEN RUN cxbo/bocx025.p     PERSISTENT SET h-bocx025.     /* inco-cx */
    IF NOT VALID-HANDLE (h-bocx225)     THEN RUN cxbo/bocx225.p     PERSISTENT SET h-bocx225.     /* ordens-embarque */
    IF NOT VALID-HANDLE (h-bocx225e)    THEN RUN cxbo/bocx225e.p    PERSISTENT SET h-bocx225e.    /* ordens-embarque */
    IF NOT VALID-HANDLE (h-bocx351)     THEN RUN cxbo/bocx351.p     PERSISTENT SET h-bocx351.     /* licenciam-import-oc */
    IF NOT VALID-HANDLE (h-bocx390)     THEN RUN cxbo/bocx390.p     PERSISTENT SET h-bocx390.     /* despes-adic */
    IF NOT VALID-HANDLE (h-bocx392)     THEN RUN cxbo/bocx392.p     PERSISTENT SET h-bocx392.     /* decla-import-adic-parc */
    IF NOT VALID-HANDLE (h-bocx393)     THEN RUN cxbo/bocx393.p     PERSISTENT SET h-bocx393.     /* decla-import-adic-NVE */
    IF NOT VALID-HANDLE (h-bocx394)     THEN RUN cxbo/bocx394.p     PERSISTENT SET h-bocx394.     /* decla-import-adic-docto */
    IF NOT VALID-HANDLE (h-bocx402)     THEN RUN cxbo/bocx402.p     PERSISTENT SET h-bocx402.     /* decla-import-adic-itens */
    IF NOT VALID-HANDLE (h-bocx404)     THEN RUN cxbo/bocx404.p     PERSISTENT SET h-bocx404.     /* decla-import-ord */
    IF NOT VALID-HANDLE (h-bocx407)     THEN RUN cxbo/bocx407.p     PERSISTENT SET h-bocx407.     /* decla-import-embarq */
    IF NOT VALID-HANDLE (h-boad098)     THEN RUN adbo/boad098.p     PERSISTENT SET h-boad098.     /* emitente */
    IF NOT VALID-HANDLE (h-boin172na)   THEN RUN inbo/boin172na.p   PERSISTENT SET h-boin172na.   /* itens */
    IF NOT VALID-HANDLE (h-boin172desc) THEN RUN inbo/boin172desc.p PERSISTENT SET h-boin172desc. /* classifica‡Æo fiscal */
    IF NOT VALID-HANDLE (h-boun005)     THEN RUN unbo/boun005.p     PERSISTENT SET h-boun005.     /* moeda */
    IF NOT VALID-HANDLE (h-boun006)     THEN RUN unbo/boun006.p     PERSISTENT SET h-boun006.     /* pais */ 
    IF NOT VALID-HANDLE (h-boin245)     THEN RUN inbo/boin245.p     PERSISTENT SET h-boin245.     /* natureza opera‡Æo */ 
    IF NOT VALID-HANDLE (h-bocx389)     THEN RUN cxbo/bocx389.p     PERSISTENT SET h-bocx389.     /* despes-adic-itens */ 
    
    IF  NOT VALID-HANDLE (h-bocx383a) THEN DO:
        RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.
        RUN openQueryStatic IN h-bocx383a (INPUT "Main":U) NO-ERROR.
    END. /* IF  NOT VALID-HANDLE (h-bocx383a) */

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-documento wMaintenanceNoNavigation 
PROCEDURE pi-add-documento :
/*------------------------------------------------------------------------------
    Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DISABLE btAddDocumento btDelDocumento WITH FRAME fPage1.
    ENABLE  brDoctoVinc btCanDocumento btSaveDocumento WITH FRAME fPage1.

    ASSIGN tt-decla-import-adic-docto-aux.cod-num-docto:READ-ONLY        IN BROWSE brDoctoVinc = no
           tt-decla-import-adic-docto-aux.idi-tip-docto-vincul:READ-ONLY IN BROWSE brDoctoVinc = no.

    if  num-results("brDoctoVinc") > 0 then do:
        find last tt-decla-import-adic-docto-aux no-error.
        if  avail tt-decla-import-adic-docto-aux 
        then reposition brDoctoVinc to rowid rowid(tt-decla-import-adic-docto-aux) no-error.
        brDoctoVinc:insert-row("after") in frame fPage1.
    end.
    else do trans:
        create tt-decla-import-adic-docto-aux.
        open query brDoctoVinc for each tt-decla-import-adic-docto-aux.
        apply "entry" to tt-decla-import-adic-docto-aux.cod-num-docto in browse brDoctoVinc. 
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-nve wMaintenanceNoNavigation 
PROCEDURE pi-add-nve :
/*------------------------------------------------------------------------------
    Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DISABLE btAddNVE btDelNVE WITH FRAME fPage2.
    ENABLE  btCanNVE btSaveNVE WITH FRAME fPage2.
    
    ASSIGN tt-decla-import-adic-nve-aux.idi-niv:READ-ONLY      IN BROWSE brNVE = no
           tt-decla-import-adic-nve-aux.cod-ident:READ-ONLY    IN BROWSE brNVE = no
           tt-decla-import-adic-nve-aux.cod-atributo:READ-ONLY IN BROWSE brNVE = no
           tt-decla-import-adic-nve-aux.cdn-especif:READ-ONLY  IN BROWSE brNVE = no.

    if  num-results("brNVE") > 0 then do:
        find last tt-decla-import-adic-nve-aux no-error.
        if  avail tt-decla-import-adic-nve-aux 
        then reposition brNVE to rowid rowid(tt-decla-import-adic-nve-aux) no-error.
        brNVE:insert-row("after") in frame fPage2.
    end.
    else do trans:
        create tt-decla-import-adic-nve-aux.
        open query brNVE for each tt-decla-import-adic-nve-aux.
        apply "entry" to tt-decla-import-adic-nve-aux.idi-niv in browse brNVE. 
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-parcela wMaintenanceNoNavigation 
PROCEDURE pi-add-parcela :
/*------------------------------------------------------------------------------
    Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DISABLE btAddParcela btDelParcela WITH FRAME fPage7.
    ENABLE  brParcelas btCanParcela btSaveParcela WITH FRAME fPage7.
    
    ASSIGN tt-decla-import-adic-parc-aux.idi-tip-pagto:READ-ONLY         IN BROWSE brParcelas = no
           tt-decla-import-adic-parc-aux.num-seq-parc:READ-ONLY          IN BROWSE brParcelas = no
           tt-decla-import-adic-parc-aux.num-mes-parc:READ-ONLY          IN BROWSE brParcelas = no
           tt-decla-import-adic-parc-aux.num-ano-parc:READ-ONLY          IN BROWSE brParcelas = no
           tt-decla-import-adic-parc-aux.val-parc:READ-ONLY              IN BROWSE brParcelas = no.

    if  num-results("brParcelas") > 0 then do:
        find last tt-decla-import-adic-parc-aux no-error.
        if  avail tt-decla-import-adic-parc-aux 
        then reposition brParcelas to rowid rowid(tt-decla-import-adic-parc-aux) no-error.
        brParcelas:insert-row("after") in frame fPage7.
    end.
    else do trans:
        create tt-decla-import-adic-parc-aux.
        open query brParcelas for each tt-decla-import-adic-parc-aux.
        apply "entry" to tt-decla-import-adic-parc-aux.idi-tip-pagto in browse brParcelas. 
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-addAcres wMaintenanceNoNavigation 
PROCEDURE pi-addAcres :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN imp/im0410d.w PERSISTENT SET h-im0410d (INPUT ?,  /* prTable  */
                                                INPUT tt-decla-import-adic.r-Rowid, /* prParent*/
                                                INPUT 'ADD', /* pcAction */
                                                INPUT THIS-PROCEDURE,
                                                INPUT 8).

    IF  VALID-HANDLE (h-im0410d) THEN DO:
        RUN initializeInterface IN h-im0410d.
        WAIT-FOR CLOSE OF h-im0410d FOCUS CURRENT-WINDOW.
    END. 
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    {&OPEN-QUERY-brAcres}
    IF  CAN-FIND(FIRST tt-despes-adic-aux) 
    THEN ENABLE  btAltAcres btExcAcres WITH FRAME fPage8.
    ELSE DISABLE btAltAcres btExcAcres WITH FRAME fPage8.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-di wMaintenanceNoNavigation 
PROCEDURE pi-altera-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Altera‡Æo da di -------------------------------------------*/
    DEF VAR l-encontrou AS LOGICAL NO-UNDO.

    /*--- Alterar di -------------------------------------------------*/
    IF  VALID-HANDLE(h-bocx383a) THEN DO:
        RUN piDoctoRecebimento IN h-bocx383a(INPUT tt-decla-import.cod-di-siscomex, OUTPUT l-encontrou).
    
        IF  l-encontrou THEN DO:
            DISABLE tt-decla-import-adic.cdn-fornec
                    c-nome-fornec
                    cb-idi-ind-vincul
                    tt-decla-import-adic.log-emite-fabrican
                    tt-decla-import-adic.cdn-fabrican
                    c-nome-fabrican
                    /*brDoctoVinc*/
                    btAddDocumento
                    btCanDocumento
                    btSaveDocumento
                    btDelDocumento
                    WITH FRAME fPage1.

            DISABLE tt-decla-import-adic.cod-classif-fisc
                    tt-decla-import-adic.cdn-classif-fisc-ex
                    c-desc-class-fis
                    tt-decla-import-adic.cdn-naladi-sist-harmon
                    tt-decla-import-adic.cod-naladi-ncca
                    tt-decla-import-adic.cod-nbm
                    tt-decla-import-adic.cod-aladi
                    tt-decla-import-adic.cod-licenc-import
                    tt-decla-import-adic.dat-livre-1 WITH FRAME fPage2.
            
            DISABLE tt-decla-import-adic.cod-incoterm
                    tt-decla-import-adic.qtd-ncm
                    tt-decla-import-adic.val-peso-liq
                    tt-decla-import-adic.log-mater-encomen
                    tt-decla-import-adic.log-mater-usado WITH FRAME fPage3.
            
            DISABLE /*brNVE*/
                    btAddNVE
                    btCanNVE
                    btSaveNVE
                    btDelNVE
                    cb-idi-metod-val
                    tt-decla-import-adic.cod-tip-recip
                    tt-decla-import-adic.qtd-capac-recip
                    WITH FRAME fPage2.

            DISABLE /*cb-idi-tributac-impto-import */
                    tt-decla-import-adic.val-aliq-ii
                    cb-suspens-impto-import 
                    cb-suspens-icms 
                    cb-suspens-pis 
                    cb-suspens-cofins
                    tt-decla-import-adic.val-perc-reduc-impto-import 
                    /*tt-decla-import-adic.val-unit-ii */
                    tt-decla-import-adic.val-base-ii 
                    d-valor-impostos-ii 
                    /*cb-idi-tributac-ipi */
                    tt-decla-import-adic.val-aliq-ipi 
                    cb-suspens-ipi-import 
                    tt-decla-import-adic.val-perc-reduc-ipi 
                    tt-decla-import-adic.val-unit-ipi 
                    tt-decla-import-adic.val-base-ipi 
                    d-valor-impostos-ipi 
                    /*cb-idi-tributac-icms */
                    tt-decla-import-adic.val-aliq-icms 
                    tt-decla-import-adic.val-perc-reduc-icms 
                    /*tt-decla-import-adic.val-unit-icms */
                    tt-decla-import-adic.val-base-icms 
                    d-valor-impostos-icms 
                    /*cb-idi-tributac-pis */
                    tt-decla-import-adic.val-aliq-pis 
                    tt-decla-import-adic.val-perc-reduc-pis 
                    tt-decla-import-adic.val-unit-pis 
                    tt-decla-import-adic.val-base-pis 
                    d-valor-impostos-pis 
                    /*cb-idi-tributac-cofins */
                    tt-decla-import-adic.val-aliq-cofins 
                    tt-decla-import-adic.val-perc-reduc-cofins 
                    tt-decla-import-adic.val-unit-cofins 
                    tt-decla-import-adic.val-base-cofins 
                    d-valor-impostos-cofins
                    WITH FRAME fPage4.

            DISABLE cb-idi-ind-pagto 
                    tt-decla-import-adic.cdn-modal-pagto 
                    tt-decla-import-adic.cdn-corretor 
                    tt-decla-import-adic.cdn-banco 
                    tt-decla-import-adic.log-moed-nac 
                    tt-decla-import-adic.cdn-praca 
                    tt-decla-import-adic.cod-contrat-cambio 
                    tt-decla-import-adic.cdn-agent 
                    tt-decla-import-adic.cdn-bco-agent 
                    tt-decla-import-adic.cod-agenc-agent 
                    tt-decla-import-adic.cod-rof 
                    btAddParcela
                    btCanParcela
                    btSaveParcela
                    btDelParcela
                    WITH FRAME fPage7.
            
            DISABLE btIncAcres
                    btAltAcres
                    btExcAcres
                    WITH FRAME fPage8.
                    
            IF l-nt2024002 THEN 
                DISABLE de-val-aliq-ibsuf               de-val-aliq-ibsmun              de-val-aliq-cbs               de-val-aliq-is
                        de-perc-reduc-ibsuf             de-perc-reduc-ibsmun            de-perc-reduc-cbs             de-base-is
                        de-base-ibsuf                   de-base-ibsmun                  de-base-cbs                   de-valor-impostos-is
                        de-valor-impostos-ibsuf         de-valor-impostos-ibsmun        de-valor-impostos-cbs         de-val-aliq-espec-is
                        c-cst-ibsuf                     c-cst-ibsmun                    c-cst-cbs                     de-qtde-is
                        c-class-trib-ibsuf              c-class-trib-ibsmun             c-class-trib-cbs              c-class-trib-is
                        de-val-aliq-reg-ibsuf           de-val-aliq-reg-ibsmun          de-val-aliq-reg-cbs           c-cst-is
                        de-base-reg-ibsuf               de-base-reg-ibsmun              de-base-reg-cbs               c-un-trib-is
                        de-valor-impostos-reg-ibsuf     de-valor-impostos-reg-ibsmun    de-valor-impostos-reg-cbs
                        c-class-trib-reg-ibsuf          c-class-trib-reg-ibsmun         c-class-trib-reg-cbs
                        c-cst-reg-ibsuf                 c-cst-reg-ibsmun                c-cst-reg-cbs 
                        WITH FRAME fPage5.
        END.
    END. /* IF  VALID-HANDLE(h-bocx383a) THEN DO: */
    /*--- FIM - Altera‡Æo da di -------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-despesas wMaintenanceNoNavigation 
PROCEDURE pi-busca-despesas :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-despes-adic:     DELETE tt-despes-adic.     END.
FOR EACH tt-despes-adic-aux: DELETE tt-despes-adic-aux. END.

IF  AVAIL tt-decla-import-adic THEN DO:
    RUN setConstraintByNumDiEms IN h-bocx390 (INPUT tt-decla-import-adic.num-di-ems,
                                              INPUT tt-decla-import-adic.num-adic,
                                              INPUT tt-decla-import-adic.cdd-siscomex-dts).
    RUN openQueryStatic         IN h-bocx390 (INPUT "ByNumDiEms":U).
    RUN getBatchRecords         IN h-bocx390 (INPUT  ?,
                                              INPUT  ?,
                                              INPUT  99999,
                                              OUTPUT iRowsReturned,
                                              OUTPUT TABLE tt-despes-adic).
    
    FOR EACH tt-despes-adic:
        CREATE tt-despes-adic-aux.
        BUFFER-COPY tt-despes-adic TO tt-despes-adic-aux.
    END. /* FOR EACH tt-despes-adic: */
    
    {&OPEN-QUERY-brAcres}
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-documentos-vinculados wMaintenanceNoNavigation 
PROCEDURE pi-busca-documentos-vinculados :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-decla-import-adic-docto:     DELETE tt-decla-import-adic-docto.     END.
FOR EACH tt-decla-import-adic-docto-aux: DELETE tt-decla-import-adic-docto-aux. END.

IF  AVAIL tt-decla-import-adic THEN DO:
    RUN setConstraintByNumDiEms IN h-bocx394 (INPUT tt-decla-import-adic.num-di-ems,
                                              INPUT tt-decla-import-adic.cdd-siscomex-dts,
                                              INPUT tt-decla-import-adic.num-adic).
    RUN openQueryStatic         IN h-bocx394 (INPUT "ByNumDiEms":U).
    RUN getBatchRecords         IN h-bocx394 (INPUT  ?,
                                              INPUT  ?,
                                              INPUT  99999,
                                              OUTPUT iRowsReturned,
                                              OUTPUT TABLE tt-decla-import-adic-docto).
    
    FOR EACH tt-decla-import-adic-docto:
        CREATE tt-decla-import-adic-docto-aux.
        BUFFER-COPY tt-decla-import-adic-docto TO tt-decla-import-adic-docto-aux.
    END. /* FOR EACH tt-decla-import-adic-docto: */
    
    {&OPEN-QUERY-brDoctoVinc}
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-itens wMaintenanceNoNavigation 
PROCEDURE pi-busca-itens :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-decla-import-adic-itens:     DELETE tt-decla-import-adic-itens.     END.
    FOR EACH tt-decla-import-adic-itens-aux: DELETE tt-decla-import-adic-itens-aux. END.
    
    RUN setConstraintByAdicao IN h-bocx402 (INPUT tt-decla-import-adic.num-di-ems,
                                            INPUT tt-decla-import-adic.num-adic, 
                                            INPUT tt-decla-import-adic.cdd-siscomex-dts).
    RUN openQueryStatic       IN h-bocx402 (INPUT 'ByAdicao':U).
    RUN getBatchRecords       IN h-bocx402 (INPUT  ?, INPUT  ?, INPUT  99999, OUTPUT iRowsReturned, OUTPUT TABLE tt-decla-import-adic-itens).
    
    FOR EACH tt-decla-import-adic-itens:
        CREATE tt-decla-import-adic-itens-aux.
        BUFFER-COPY tt-decla-import-adic-itens TO tt-decla-import-adic-itens-aux.
    END. /* FOR EACH tt-decla-import-adic-itens: */
    
    {&OPEN-QUERY-brItens}
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-NVE wMaintenanceNoNavigation 
PROCEDURE pi-busca-NVE :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-decla-import-adic-NVE:     DELETE tt-decla-import-adic-NVE.     END.
FOR EACH tt-decla-import-adic-NVE-aux: DELETE tt-decla-import-adic-NVE-aux. END.

IF  AVAIL tt-decla-import-adic THEN DO:
    RUN setConstraintByNumDiEms IN h-bocx393 (INPUT tt-decla-import-adic.num-di-ems,
                                              INPUT tt-decla-import-adic.cdd-siscomex-dts,
                                              INPUT tt-decla-import-adic.num-adic).
    RUN openQueryStatic         IN h-bocx393 (INPUT "ByNumDiEms":U).
    RUN getBatchRecords         IN h-bocx393 (INPUT  ?, INPUT  ?, INPUT  99999, OUTPUT iRowsReturned, OUTPUT TABLE tt-decla-import-adic-NVE).
    
    FOR EACH tt-decla-import-adic-NVE:
        CREATE tt-decla-import-adic-NVE-aux.
        BUFFER-COPY tt-decla-import-adic-NVE TO tt-decla-import-adic-NVE-aux.
    END. /* FOR EACH tt-decla-import-adic-NVE: */
    {&OPEN-QUERY-brNVE}
END.

IF  NOT CAN-FIND(FIRST tt-decla-import-adic-NVE-aux) 
THEN DISABLE btCanNVE btDelNVE btSaveNVE WITH FRAME fPage2.
ELSE ENABLE btDelNVE WITH FRAME fPage2.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-parcelas wMaintenanceNoNavigation 
PROCEDURE pi-busca-parcelas :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-decla-import-adic-parc:     DELETE tt-decla-import-adic-parc.     END.
FOR EACH tt-decla-import-adic-parc-aux: DELETE tt-decla-import-adic-parc-aux. END.

IF  AVAIL tt-decla-import-adic THEN DO:
    RUN setConstraintByNumDiEms IN h-bocx392 (INPUT tt-decla-import-adic.num-di-ems,
                                              INPUT tt-decla-import-adic.cdd-siscomex-dts,
                                              INPUT tt-decla-import-adic.num-adic).
    RUN openQueryStatic         IN h-bocx392 (INPUT "ByNumDiEms":U).
    RUN getBatchRecords         IN h-bocx392 (INPUT  ?,
                                              INPUT  ?,
                                              INPUT  99999,
                                              OUTPUT iRowsReturned,
                                              OUTPUT TABLE tt-decla-import-adic-parc).
    
    FOR EACH tt-decla-import-adic-parc:
        CREATE tt-decla-import-adic-parc-aux.
        BUFFER-COPY tt-decla-import-adic-parc TO tt-decla-import-adic-parc-aux.
    END. /* FOR EACH tt-decla-import-adic-parc: */
    
    {&OPEN-QUERY-brParcelas}
END.
IF  NOT CAN-FIND(FIRST tt-decla-import-adic-parc-aux) 
THEN do:
    DISABLE btCanParcela btDelParcela btSaveParcela WITH FRAME fPage7.
    ENABLE btAddParcela WITH FRAME fPage7.
END.
ELSE ENABLE btDelParcela WITH FRAME fPage7.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-valor-impostos wMaintenanceNoNavigation 
PROCEDURE pi-busca-valor-impostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*  valores do combo-box de tributa‡Æo:
        0 - tributado
        1 - Isento
        2 - Outros
        3 - Reduzido
    */
    
ASSIGN INPUT FRAME fPage4 cb-idi-tributac-impto-import
       INPUT FRAME fPage4 cb-idi-tributac-ipi
       INPUT FRAME fPage4 cb-idi-tributac-pis
       INPUT FRAME fPage4 cb-idi-tributac-cofins
       INPUT FRAME fPage4 cb-idi-tributac-icms
       INPUT FRAME fPage4 cb-suspens-impto-import
       INPUT FRAME fPage4 cb-suspens-ipi-import 
       INPUT FRAME fPage4 cb-suspens-pis 
       INPUT FRAME fPage4 cb-suspens-cofins
       INPUT FRAME fPage4 cb-suspens-icms.

    
    /* busca valor do II */
    IF cb-suspens-impto-import <> 'Sim' THEN
        IF {cxinc/i01cx402.i 06 cb-idi-tributac-impto-import} = 1 OR 
           {cxinc/i01cx402.i 06 cb-idi-tributac-impto-import} = 2 OR
           {cxinc/i01cx402.i 06 cb-idi-tributac-impto-import} = 4 THEN
            ASSIGN d-valor-impostos-ii = tt-decla-import-adic.val-ii-db-cr.
        ELSE 
            ASSIGN d-valor-impostos-ii = tt-decla-import-adic.val-ii-outras.
    ELSE
        ASSIGN d-valor-impostos-ii = tt-decla-import-adic.val-ii-nao-tribut.
    /* fim - busca valor do II */

    /* busca valor do IPI */
    IF cb-suspens-ipi-import <> 'Sim' THEN
        IF {cxinc/i01cx402.i 06 cb-idi-tributac-ipi} = 1 OR 
           {cxinc/i01cx402.i 06 cb-idi-tributac-ipi} = 2 OR
           {cxinc/i01cx402.i 06 cb-idi-tributac-ipi} = 4 THEN
            ASSIGN d-valor-impostos-ipi = tt-decla-import-adic.val-ipi-db-cr.
        ELSE 
            ASSIGN d-valor-impostos-ipi = tt-decla-import-adic.val-ipi-outras.
    ELSE
        ASSIGN d-valor-impostos-ipi = tt-decla-import-adic.val-ipi-nao-tribut.
    /* fim - busca valor do IPI */

    /* busca valor do ICMS */
    IF cb-suspens-icms <> 'Sim' THEN
        IF {cxinc/i01cx402.i 06 cb-idi-tributac-icms} = 1 OR 
           {cxinc/i01cx402.i 06 cb-idi-tributac-icms} = 2 OR
           {cxinc/i01cx402.i 06 cb-idi-tributac-icms} = 4 THEN
            ASSIGN d-valor-impostos-icms = tt-decla-import-adic.val-icms-db-cr.
        ELSE 
            ASSIGN d-valor-impostos-icms = tt-decla-import-adic.val-icms-outras.
    ELSE
        ASSIGN d-valor-impostos-icms = tt-decla-import-adic.val-icms-nao-tribut.
    /* fim - busca valor do ICMS */

    /* busca valor do PIS */
    IF cb-suspens-pis <> 'Sim' THEN
        IF {cxinc/i01cx402.i 06 cb-idi-tributac-pis} = 1 OR 
           {cxinc/i01cx402.i 06 cb-idi-tributac-pis} = 2 OR
           {cxinc/i01cx402.i 06 cb-idi-tributac-pis} = 4 THEN
            ASSIGN d-valor-impostos-pis = tt-decla-import-adic.val-pis-db-cr.
        ELSE 
            ASSIGN d-valor-impostos-pis = tt-decla-import-adic.val-pis-outras.
    ELSE
        ASSIGN d-valor-impostos-pis = tt-decla-import-adic.val-pis-nao-tribut.
    /* fim - busca valor do PIS */

    /* busca valor do COFINS */
    IF cb-suspens-cofins <> 'Sim' THEN
        IF {cxinc/i01cx402.i 06 cb-idi-tributac-cofins} = 1 OR 
           {cxinc/i01cx402.i 06 cb-idi-tributac-cofins} = 2 OR
           {cxinc/i01cx402.i 06 cb-idi-tributac-cofins} = 4 THEN
            ASSIGN d-valor-impostos-cofins = tt-decla-import-adic.val-cofins-db-cr.
        ELSE 
            ASSIGN d-valor-impostos-cofins = tt-decla-import-adic.val-cofins-outras.
    ELSE
        ASSIGN d-valor-impostos-cofins = tt-decla-import-adic.val-cofins-nao-tribut.
    /* fim - busca valor do COFINS */


    DISP d-valor-impostos-ii
         d-valor-impostos-ipi
         d-valor-impostos-icms
         d-valor-impostos-pis
         d-valor-impostos-cofins
        WITH FRAME fPage4.


    RUN pi-busca-valores-impostos IN h-bocx402 (INPUT  tt-decla-import-adic.num-di-ems,
                                                INPUT  tt-decla-import-adic.num-adic,
                                                INPUT  tt-decla-import-adic.cdd-siscomex-dts,
                                                OUTPUT de-val-aliq-fcp,          
                                                OUTPUT de-val-base-fcp,          
                                                OUTPUT de-val-fcp,               
                                                OUTPUT de-val-aliq-fcp-substto,  
                                                OUTPUT de-val-base-fcp-substto,  
                                                OUTPUT de-val-fcp-substto,       
                                                OUTPUT de-val-base-icms-substto, 
                                                OUTPUT de-val-icms-substto,      
                                                OUTPUT de-val-base-icms-compltar,
                                                OUTPUT de-val-icms-compltar).
    DISP de-val-aliq-fcp
         de-val-base-fcp
         de-val-fcp
         de-val-aliq-fcp-substto
         de-val-base-fcp-substto
         de-val-fcp-substto
         de-val-base-icms-substto
         de-val-icms-substto
         de-val-base-icms-compltar
         de-val-icms-compltar
        WITH FRAME fPage4.

    IF l-nt2024002 THEN DO:
        ASSIGN de-val-aliq-ibsuf        = 0
               de-val-aliq-ibsmun       = 0
               de-val-aliq-cbs          = 0
               de-perc-reduc-ibsuf      = 0
               de-perc-reduc-ibsmun     = 0
               de-perc-reduc-cbs        = 0
               de-base-ibsuf            = 0
               de-base-ibsmun           = 0
               de-base-cbs              = 0
               de-valor-impostos-ibsuf  = 0
               de-valor-impostos-ibsmun = 0
               de-valor-impostos-cbs    = 0
               c-cst-ibsuf              = ""
               c-cst-ibsmun             = ""
               c-cst-cbs                = ""
               c-class-trib-ibsuf       = ""
               c-class-trib-ibsmun      = ""
               c-class-trib-cbs         = ""
               i-trib-ibsuf             = 1
               i-trib-ibsmun            = 1
               i-trib-cbs               = 1
               de-val-aliq-reg-ibsuf    = 0
               de-val-aliq-reg-ibsmun   = 0
               de-val-aliq-reg-cbs      = 0
               de-base-reg-ibsuf        = 0
               de-base-reg-ibsmun       = 0
               de-base-reg-cbs          = 0
               de-valor-impostos-reg-ibsuf  = 0
               de-valor-impostos-reg-ibsmun = 0
               de-valor-impostos-reg-cbs    = 0
               c-class-trib-reg-ibsuf       = ""
               c-class-trib-reg-ibsmun      = ""
               c-class-trib-reg-cbs         = ""
               c-cst-reg-ibsuf              = ""
               c-cst-reg-ibsmun             = ""
               c-cst-reg-cbs                = "".

        FOR EACH decla-import-adic-trib NO-LOCK
           WHERE decla-import-adic-trib.num-di-ems       = tt-decla-import-adic.num-di-ems
             AND decla-import-adic-trib.num-adic         = tt-decla-import-adic.num-adic
             AND decla-import-adic-trib.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts:
            
            CASE decla-import-adic-trib.nom-trib:
                WHEN "IBSUF":U THEN DO:
                    CASE decla-import-adic-trib.cod-campo:
                        WHEN "COD-TRIB":U THEN
                            ASSIGN i-trib-ibsuf = INT(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-val-aliq-ibsuf = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQ-RED":U THEN
                            ASSIGN de-perc-reduc-ibsuf = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "BASE":U THEN
                            ASSIGN de-base-ibsuf = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "VALOR":U OR 
                        WHEN "OUTROS":U THEN
                            ASSIGN de-valor-impostos-ibsuf = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "CST":U THEN
                            ASSIGN c-cst-ibsuf = decla-import-adic-trib.cod-conteudo.
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-ibsuf = decla-import-adic-trib.cod-conteudo.
                        WHEN "ALIQ-EFETIVA-REG":U THEN
                            ASSIGN de-val-aliq-reg-ibsuf = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "BASE-REG":U THEN
                            ASSIGN de-base-reg-ibsuf = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "VALOR-REG":U THEN
                            ASSIGN de-valor-impostos-reg-ibsuf = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "C-CLASS-TRIB-REG":U THEN
                            ASSIGN c-class-trib-reg-ibsuf = decla-import-adic-trib.cod-conteudo.
                        WHEN "CST-REG":U THEN
                            ASSIGN c-cst-reg-ibsuf = decla-import-adic-trib.cod-conteudo.
                    END CASE.
                END.
                WHEN "IBSMUN":U THEN DO:
                    CASE decla-import-adic-trib.cod-campo:
                        WHEN "COD-TRIB":U THEN
                            ASSIGN i-trib-ibsmun = INT(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-val-aliq-ibsmun = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQ-RED":U THEN
                            ASSIGN de-perc-reduc-ibsmun = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "BASE":U THEN
                            ASSIGN de-base-ibsmun = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "VALOR":U OR 
                        WHEN "OUTROS":U THEN
                            ASSIGN de-valor-impostos-ibsmun = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "CST":U THEN
                            ASSIGN c-cst-ibsmun = decla-import-adic-trib.cod-conteudo.
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-ibsmun = decla-import-adic-trib.cod-conteudo.
                        WHEN "ALIQ-EFETIVA-REG":U THEN
                            ASSIGN de-val-aliq-reg-ibsmun = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "BASE-REG":U THEN
                            ASSIGN de-base-reg-ibsmun = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "VALOR-REG":U THEN
                            ASSIGN de-valor-impostos-reg-ibsmun = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "C-CLASS-TRIB-REG":U THEN
                            ASSIGN c-class-trib-reg-ibsmun = decla-import-adic-trib.cod-conteudo.
                        WHEN "CST-REG":U THEN
                            ASSIGN c-cst-reg-ibsmun = decla-import-adic-trib.cod-conteudo.
                    END CASE.
                END.
                WHEN "CBS":U THEN DO:
                    CASE decla-import-adic-trib.cod-campo:
                        WHEN "COD-TRIB":U THEN
                            ASSIGN i-trib-cbs = INT(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-val-aliq-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQ-RED":U THEN
                            ASSIGN de-perc-reduc-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "BASE":U THEN
                            ASSIGN de-base-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "VALOR":U OR 
                        WHEN "OUTROS":U THEN
                            ASSIGN de-valor-impostos-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "CST":U THEN
                            ASSIGN c-cst-cbs = decla-import-adic-trib.cod-conteudo.
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-cbs = decla-import-adic-trib.cod-conteudo.
                        WHEN "ALIQ-EFETIVA-REG":U THEN
                            ASSIGN de-val-aliq-reg-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "BASE-REG":U THEN
                            ASSIGN de-base-reg-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "VALOR-REG":U THEN
                            ASSIGN de-valor-impostos-reg-cbs = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "C-CLASS-TRIB-REG":U THEN
                            ASSIGN c-class-trib-reg-cbs = decla-import-adic-trib.cod-conteudo.
                        WHEN "CST-REG":U THEN
                            ASSIGN c-cst-reg-cbs = decla-import-adic-trib.cod-conteudo.
                    END CASE.
                END. 
                WHEN "IS":U THEN DO:
                    CASE decla-import-adic-trib.cod-campo:
                        WHEN "C-CLASS-TRIB":U THEN
                            ASSIGN c-class-trib-is = decla-import-adic-trib.cod-conteudo.
                        WHEN "CST":U THEN
                            ASSIGN c-cst-is = decla-import-adic-trib.cod-conteudo.
                        WHEN "COD-TRIB":U THEN DO:
                            ASSIGN cb-idi-tributac-is:SCREEN-VALUE IN FRAME fPage5 = {diinc/i01di628.i 04 INT(decla-import-adic-trib.cod-conteudo)}.
                            IF cb-idi-tributac-is:SCREEN-VALUE IN FRAME fPage5 = ? OR cb-idi-tributac-is:SCREEN-VALUE IN FRAME fPage5 = "" THEN
                            DO:
                               ASSIGN cb-idi-tributac-is:SCREEN-VALUE IN FRAME fPage5 = "Tributado". 
                            END.
                        END.
                        WHEN "ALIQUOTA":U THEN
                            ASSIGN de-val-aliq-is = dec(decla-import-adic-trib.cod-conteudo).
                        WHEN "ALIQ-ESPEC-UN":U THEN
                            ASSIGN de-val-aliq-espec-is = dec(decla-import-adic-trib.cod-conteudo).
                        WHEN "QTDE-TRIBUT":U THEN
                            ASSIGN de-qtde-is = dec(decla-import-adic-trib.cod-conteudo).  
                        WHEN "UN-TRIBUT":U THEN
                            ASSIGN c-un-trib-is = decla-import-adic-trib.cod-conteudo.
                        WHEN "BASE":U THEN
                            ASSIGN de-base-is = DEC(decla-import-adic-trib.cod-conteudo).
                        WHEN "VALOR":U OR 
                        WHEN "OUTROS":U THEN
                            ASSIGN de-valor-impostos-is = DEC(decla-import-adic-trib.cod-conteudo).
                    END CASE.
                END.
            END CASE.
        END.
        
        ASSIGN cb-idi-tributac-ibsuf:SCREEN-VALUE  IN FRAME fPage5 = {diinc/i01di628.i 04 i-trib-ibsuf}
               cb-idi-tributac-ibsmun:SCREEN-VALUE IN FRAME fPage5 = {diinc/i01di628.i 04 i-trib-ibsmun}
               cb-idi-tributac-cbs:SCREEN-VALUE    IN FRAME fPage5 = {diinc/i01di628.i 04 i-trib-cbs}.
        
        DISP de-val-aliq-ibsuf            de-val-aliq-ibsmun            de-val-aliq-cbs            de-val-aliq-is
             de-perc-reduc-ibsuf          de-perc-reduc-ibsmun          de-perc-reduc-cbs          de-base-is
             de-base-ibsuf                de-base-ibsmun                de-base-cbs                de-valor-impostos-is
             de-valor-impostos-ibsuf      de-valor-impostos-ibsmun      de-valor-impostos-cbs      de-val-aliq-espec-is
             c-cst-ibsuf                  c-cst-ibsmun                  c-cst-cbs                  de-qtde-is
             c-class-trib-ibsuf           c-class-trib-ibsmun           c-class-trib-cbs           c-class-trib-is
             de-val-aliq-reg-ibsuf        de-val-aliq-reg-ibsmun        de-val-aliq-reg-cbs        c-cst-is
             de-base-reg-ibsuf            de-base-reg-ibsmun            de-base-reg-cbs            c-un-trib-is
             de-valor-impostos-reg-ibsuf  de-valor-impostos-reg-ibsmun  de-valor-impostos-reg-cbs
             c-class-trib-reg-ibsuf       c-class-trib-reg-ibsmun       c-class-trib-reg-cbs
             c-cst-reg-ibsuf              c-cst-reg-ibsmun              c-cst-reg-cbs WITH FRAME fPage5.

        APPLY "LEAVE":U TO c-class-trib-ibsuf  IN FRAME fPage5.
        APPLY "LEAVE":U TO c-class-trib-ibsmun IN FRAME fPage5.
        APPLY "LEAVE":U TO c-class-trib-cbs    IN FRAME fPage5.
        APPLY "LEAVE":U TO c-class-trib-is    IN FRAME fPage5.
        
        DISABLE cb-idi-tributac-ibsuf       cb-idi-tributac-ibsmun       cb-idi-tributac-cbs      cb-idi-tributac-is
                de-base-ibsuf               de-base-ibsmun               de-base-cbs              de-base-is
                de-valor-impostos-ibsuf     de-valor-impostos-ibsmun     de-valor-impostos-cbs    de-valor-impostos-is
                de-val-aliq-reg-ibsuf       de-val-aliq-reg-ibsmun       de-val-aliq-reg-cbs
                de-base-reg-ibsuf           de-base-reg-ibsmun           de-base-reg-cbs
                de-valor-impostos-reg-ibsuf de-valor-impostos-reg-ibsmun de-valor-impostos-reg-cbs WITH FRAME fPage5.
        DISABLE cb-idi-tributac-is de-base-is de-valor-impostos-is WITH FRAME fPage5.
    END.
        
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-valores wMaintenanceNoNavigation 
PROCEDURE pi-busca-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN pi-busca-valores IN h-bocx403 (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                   INPUT INPUT FRAME fPage0 tt-decla-import-adic.num-adic,
                                   INPUT tt-decla-import.cdd-siscomex-dts,
                                   OUTPUT d-val-vmcv-me1,
                                   OUTPUT c-cdn-moed-vmcv,
                                   OUTPUT d-val-vmcv-me2,
                                   OUTPUT d-val-vmcv,

                                   OUTPUT d-val-vmle-me1,
                                   OUTPUT c-cdn-moed-vmle,
                                   OUTPUT d-val-vmle-me2,
                                   OUTPUT d-val-vmle,

                                   OUTPUT d-val-vmld-me1,
                                   OUTPUT c-cdn-moed-vmld,
                                   OUTPUT d-val-vmld-me2,
                                   OUTPUT d-val-vmld,

                                   OUTPUT d-val-frete-me1,
                                   OUTPUT c-cdn-moed-frete,
                                   OUTPUT d-val-frete-me2,
                                   OUTPUT d-val-frete,

                                   OUTPUT d-val-seguro-me1,
                                   OUTPUT c-cdn-moed-seguro,
                                   OUTPUT d-val-seguro-me2,
                                   OUTPUT d-val-seguro,

                                   OUTPUT d-val-acresc-me1,
                                   OUTPUT c-cdn-moed-acresc,
                                   OUTPUT d-val-acresc-me2,
                                   OUTPUT d-val-acresc).     
DISP d-val-vmcv-me1
     c-cdn-moed-vmcv
     d-val-vmcv-me2
     d-val-vmcv

     d-val-vmle-me1
     c-cdn-moed-vmle
     d-val-vmle-me2
     d-val-vmle
     
     d-val-vmld-me1
     c-cdn-moed-vmld
     d-val-vmld-me2
     d-val-vmld

     d-val-frete-me1
     c-cdn-moed-frete
     d-val-frete-me2
     d-val-frete

     d-val-seguro-me1
     c-cdn-moed-seguro
     d-val-seguro-me2
     d-val-seguro

     d-val-acresc-me1
     c-cdn-moed-acresc
     d-val-acresc-me2
     d-val-acresc
    WITH FRAME fPage6.

RUN pi-desabilita-valores.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-canc-documento wMaintenanceNoNavigation 
PROCEDURE pi-canc-documento :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    RUN pi-busca-documentos-vinculados.
    
    ASSIGN tt-decla-import-adic-docto-aux.cod-num-docto:READ-ONLY        IN BROWSE brDoctoVinc = yes 
           tt-decla-import-adic-docto-aux.idi-tip-docto-vincul:READ-ONLY IN BROWSE brDoctoVinc = yes. 
    
    IF  NOT CAN-FIND(FIRST tt-decla-import-adic-docto-aux) THEN DO:
        ENABLE btAddDocumento WITH FRAME fPage1.
        DISABLE btCanDocumento btDelDocumento btSaveDocumento WITH FRAME fPage1.
    END. /* IF  NOT CAN-FIND */
    ELSE DO:
        ENABLE  btAddDocumento btDelDocumento  WITH FRAME fPage1.
        DISABLE btCanDocumento btSaveDocumento WITH FRAME fPage1.
    END. /* ELSE DO: */
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-canc-NVE wMaintenanceNoNavigation 
PROCEDURE pi-canc-NVE :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
RUN pi-busca-NVE.

ASSIGN tt-decla-import-adic-nve-aux.idi-niv:READ-ONLY      IN BROWSE brNVE = yes
       tt-decla-import-adic-nve-aux.cod-ident:READ-ONLY    IN BROWSE brNVE = yes
       tt-decla-import-adic-nve-aux.cod-atributo:READ-ONLY IN BROWSE brNVE = yes
       tt-decla-import-adic-nve-aux.cdn-especif:READ-ONLY  IN BROWSE brNVE = yes. 

IF  NOT CAN-FIND(FIRST tt-decla-import-adic-nve-aux) THEN DO:
    ENABLE btAddNVE WITH FRAME fPage2.
    DISABLE btCanNVE btDelNVE btSaveNVE WITH FRAME fPage2.
END. /* IF  NOT CAN-FIND */
ELSE DO:
    ENABLE  btAddNVE btDelNVE  WITH FRAME fPage2.
    DISABLE btCanNVE btSaveNVE WITH FRAME fPage2.
END. /* ELSE DO: */

RETURN "OK":U.
END PROCEDURE.

/*

/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN pi-busca-embalagens.

ASSIGN tt-decla-import-embal.cod-sig-embal          :READ-ONLY IN BROWSE brEmbalagem = YES
       tt-decla-import-embal.qtd-vol-embal          :READ-ONLY IN BROWSE brEmbalagem = YES.

IF NOT CAN-FIND(FIRST tt-decla-import-embal) THEN DO:
    ENABLE btAddEmbalagem WITH FRAME fPage4.
    DISABLE btCanEmbalagem btDelEmbalagem btSaveEmbalagem WITH FRAME fPage4.
END.
ELSE DO:
    ENABLE  btAddEmbalagem btDelEmbalagem WITH FRAME fPage4.
    DISABLE btCanEmbalagem btSaveEmbalagem    WITH FRAME fPage4.
END.

RETURN "OK":U.
END PROCEDURE.


*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-canc-parcela wMaintenanceNoNavigation 
PROCEDURE pi-canc-parcela :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
RUN pi-busca-parcelas.

ASSIGN tt-decla-import-adic-parc-aux.idi-tip-pagto:READ-ONLY IN BROWSE brParcelas = yes  
       tt-decla-import-adic-parc-aux.num-seq-parc:READ-ONLY  IN BROWSE brParcelas = yes  
       tt-decla-import-adic-parc-aux.num-mes-parc:READ-ONLY  IN BROWSE brParcelas = yes  
       tt-decla-import-adic-parc-aux.num-ano-parc:READ-ONLY  IN BROWSE brParcelas = yes  
       tt-decla-import-adic-parc-aux.val-parc:READ-ONLY      IN BROWSE brParcelas = yes. 

IF  NOT CAN-FIND(FIRST tt-decla-import-adic-parc-aux) THEN DO:
    ENABLE btAddParcela WITH FRAME fPage7.
    DISABLE btCanParcela btDelParcela btSaveParcela WITH FRAME fPage7.
END. /* IF  NOT CAN-FIND */
ELSE DO:
    ENABLE  btAddParcela btDelParcela  WITH FRAME fPage7.
    DISABLE btCanParcela btSaveParcela WITH FRAME fPage7.
END. /* ELSE DO: */

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carregaTTAcres-aux wMaintenanceNoNavigation 
PROCEDURE pi-carregaTTAcres-aux :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-acres-auxiliar NO-ERROR.
    ASSIGN i-conta-reg = 0.

    IF  AVAIL tt-despes-adic-aux THEN 
        FOR EACH tt-despes-adic-aux:

            ASSIGN i-conta-reg = i-conta-reg + 1.

            CREATE tt-acres-auxiliar.
            ASSIGN tt-acres-auxiliar.num-di-ems     = tt-despes-adic-aux.num-di-ems
                   tt-acres-auxiliar.num-adic       = tt-despes-adic-aux.num-adic
                   tt-acres-auxiliar.cdn-despes     = tt-despes-adic-aux.cdn-despes
                   tt-acres-auxiliar.cdn-emit-despes = tt-despes-adic-aux.cdn-emit-despes
                   tt-acres-auxiliar.num-conta  = i-conta-reg.

        END. /* FOR EACH tt-despes-adic-aux: */
    
    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carregaTTItens-aux wMaintenanceNoNavigation 
PROCEDURE pi-carregaTTItens-aux :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-itens-auxiliar NO-ERROR.
    ASSIGN i-conta-reg = 0.

    IF  AVAIL tt-decla-import-adic-itens-aux THEN 
        FOR EACH tt-decla-import-adic-itens-aux:

            ASSIGN i-conta-reg = i-conta-reg + 1.

            CREATE tt-itens-auxiliar.
            ASSIGN tt-itens-auxiliar.num-di-ems = tt-decla-import-adic-itens-aux.num-di-ems
                   tt-itens-auxiliar.num-adic   = tt-decla-import-adic-itens-aux.num-adic
                   tt-itens-auxiliar.num-seq    = tt-decla-import-adic-itens-aux.num-seq
                   tt-itens-auxiliar.num-conta  = i-conta-reg.

        END. /* FOR EACH tt-decla-import-adic-itens-aux: */
    
    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-impostos-aux wMaintenanceNoNavigation 
PROCEDURE pi-cria-impostos-aux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-decla-import-adic-impostos.
    CREATE tt-decla-import-adic-impostos.
    BUFFER-COPY tt-decla-import-adic TO tt-decla-import-adic-impostos.

    FIND FIRST tt-decla-import-adic-impostos NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita-valores wMaintenanceNoNavigation 
PROCEDURE pi-desabilita-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* desabilita os campos do folder valores (fPage6) */
    
    DISABLE d-val-vmcv-me1
            c-cdn-moed-vmcv
            d-val-vmcv-me2
            d-val-vmcv

            d-val-vmle-me1
            c-cdn-moed-vmle
            d-val-vmle-me2
            d-val-vmle
            
            d-val-vmld-me1
            c-cdn-moed-vmld
            d-val-vmld-me2
            d-val-vmld

            d-val-frete-me1
            c-cdn-moed-frete
            d-val-frete-me2
            d-val-frete

            d-val-seguro-me1
            c-cdn-moed-seguro
            d-val-seguro-me2
            d-val-seguro

            d-val-acresc-me1
            c-cdn-moed-acresc
            d-val-acresc-me2
            d-val-acresc
        WITH FRAME fPage6.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-todas-parcelas wMaintenanceNoNavigation 
PROCEDURE pi-elimina-todas-parcelas :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
FOR EACH tt-decla-import-adic-parc: DELETE tt-decla-import-adic-parc. END.

IF  AVAIL tt-decla-import-adic THEN DO:
    RUN setConstraintByNumDiEms IN h-bocx392 (INPUT tt-decla-import-adic.num-di-ems,
                                              INPUT tt-decla-import-adic.cdd-siscomex-dts,
                                              INPUT tt-decla-import-adic.num-adic).
    RUN openQueryStatic         IN h-bocx392 (INPUT "ByNumDiEms":U).
    RUN getBatchRecords         IN h-bocx392 (INPUT  ?, INPUT  ?, INPUT  99999, OUTPUT iRowsReturned, OUTPUT TABLE tt-decla-import-adic-parc).

    RUN openQueryStatic IN h-bocx392 (INPUT 'Main':U).
    RUN setRecord       IN h-bocx392 (INPUT TABLE tt-decla-import-adic-parc).
    RUN deleterecord    IN h-bocx392.

    RUN pi-busca-parcelas.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exclui-documento wMaintenanceNoNavigation 
PROCEDURE pi-exclui-documento :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DO  i-cont = 1 TO brDoctoVinc:NUM-SELECTED-ROWS IN FRAME fPage1:
        IF  brDoctoVinc:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage1 THEN DO:  
            RUN openQueryStatic IN h-bocx394 (INPUT 'Main':U).
            RUN goToKey IN h-bocx394 (INPUT tt-decla-import-adic-docto-aux.num-di-ems, 
                                      INPUT tt-decla-import-adic-docto-aux.cdd-siscomex-dts, 
                                      INPUT tt-decla-import-adic-docto-aux.num-adic,
                                      INPUT tt-decla-import-adic-docto-aux.cod-num-docto).
            IF  RETURN-VALUE = "OK":U THEN do: 
                RUN emptyRowErrors IN h-bocx394.
                RUN deleteRecord IN h-bocx394.
                RUN pi-busca-documentos-vinculados.
                {&OPEN-QUERY-brDoctoVinc}
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exclui-NVE wMaintenanceNoNavigation 
PROCEDURE pi-exclui-NVE :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DO  i-cont = 1 TO brNVE:NUM-SELECTED-ROWS IN FRAME fPage2:
        IF  brNVE:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage2 THEN DO:  
            RUN openQueryStatic IN h-bocx393 (INPUT 'Main':U).
            RUN goToKey IN h-bocx393 (INPUT tt-decla-import-adic-nve-aux.num-di-ems,
                                      INPUT tt-decla-import-adic-nve-aux.cdd-siscomex-dts,
                                      INPUT tt-decla-import-adic-nve-aux.num-adic,
                                      INPUT tt-decla-import-adic-nve-aux.idi-niv,
                                      INPUT tt-decla-import-adic-nve-aux.cod-ident,
                                      INPUT tt-decla-import-adic-nve-aux.cod-atributo,
                                      INPUT tt-decla-import-adic-nve-aux.cdn-especif).
            IF  RETURN-VALUE = "OK":U THEN do: 
                RUN emptyRowErrors IN h-bocx393.
                RUN deleteRecord IN h-bocx393.
                RUN pi-busca-NVE.
                {&OPEN-QUERY-brNVE}
            END.
        END.
    END.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exclui-parcela wMaintenanceNoNavigation 
PROCEDURE pi-exclui-parcela :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DO  i-cont = 1 TO brParcelas:NUM-SELECTED-ROWS IN FRAME fPage7:
        IF  brParcelas:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage7 THEN DO:  
            RUN openQueryStatic IN h-bocx392 (INPUT 'Main':U).
            RUN goToKey IN h-bocx392 (INPUT tt-decla-import-adic-parc-aux.num-di-ems, 
                                      INPUT tt-decla-import-adic-parc-aux.cdd-siscomex-dts, 
                                      INPUT tt-decla-import-adic-parc-aux.num-adic,
                                      INPUT tt-decla-import-adic-parc-aux.num-seq-parc).
            IF  RETURN-VALUE = "OK":U THEN do: 
                RUN emptyRowErrors IN h-bocx392.
                RUN deleteRecord IN h-bocx392.
                RUN pi-busca-parcelas.
                {&OPEN-QUERY-brParcelas}
            END.
        END.
    END.

    RUN pi-habilita-campos.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-excluiAcres wMaintenanceNoNavigation 
PROCEDURE pi-excluiAcres :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DO  i-cont = 1 TO brAcres:NUM-SELECTED-ROWS IN FRAME fPage8:
        IF  brAcres:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage8 THEN DO:  
            RUN openQueryStatic IN h-bocx390 (INPUT 'Main':U).
            RUN goToKey IN h-bocx390 (INPUT tt-despes-adic-aux.num-di-ems,
                                      INPUT tt-despes-adic-aux.num-adic,
                                      INPUT tt-despes-adic-aux.cdn-despes,
                                      INPUT tt-despes-adic-aux.cdn-emit-despes,
                                      INPUT tt-despes-adic-aux.cdd-siscomex-dts).
            IF  RETURN-VALUE = "OK":U THEN do: 
                RUN emptyRowErrors IN h-bocx390.
                RUN deleteRecord IN h-bocx390.
            END.
            /* Eliminar tamb‚m a despes-adic-itens */
            RUN openQueryStatic IN h-bocx389 (INPUT 'Main':U) NO-ERROR.
            FOR EACH tt-decla-import-adic-itens-aux
               WHERE tt-decla-import-adic-itens-aux.num-di-ems       = tt-despes-adic-aux.num-di-ems
                 AND tt-decla-import-adic-itens-aux.cdd-siscomex-dts = tt-despes-adic-aux.cdd-siscomex-dts
                 AND tt-decla-import-adic-itens-aux.num-adic         = tt-despes-adic-aux.num-adic NO-LOCK:

                RUN emptyRowObject IN h-bocx389.
                RUN goToKey IN h-bocx389 (INPUT tt-despes-adic-aux.num-di-ems,
                                          INPUT tt-despes-adic-aux.cdd-siscomex-dts,
                                          INPUT tt-despes-adic-aux.num-adic,
                                          INPUT tt-decla-import-adic-itens-aux.num-seq,
                                          INPUT tt-despes-adic-aux.cdn-despes,
                                          INPUT tt-despes-adic-aux.cdn-emit-despes).
                IF  RETURN-VALUE = "OK":U THEN do: 
                    RUN emptyRowErrors IN h-bocx389.
                    RUN deleteRecord IN h-bocx389.
                END.
            END.
            /* Fim da Elimina‡Æo da despes-adic-itens */
            RUN pi-busca-despesas.
            {&OPEN-QUERY-brAcres}

        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-decla-import-adic-trib wMaintenanceNoNavigation 
PROCEDURE pi-grava-decla-import-adic-trib :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nom-trib      AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-campo     AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-conteudo  AS CHAR  NO-UNDO.

    IF LOOKUP(p-cod-campo,"ALIQ-EFETIVA-REG,BASE-REG,VALOR-REG,C-CLASS-TRIB-REG,CST-REG") > 0 
    AND (p-cod-conteudo = "" OR p-cod-conteudo = "0") THEN DO:
        FOR FIRST decla-import-adic-trib
            WHERE decla-import-adic-trib.num-di-ems       = tt-decla-import-adic.num-di-ems
              AND decla-import-adic-trib.num-adic         = tt-decla-import-adic.num-adic
              AND decla-import-adic-trib.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
              AND decla-import-adic-trib.nom-trib         = p-nom-trib 
              AND decla-import-adic-trib.cod-campo        = p-cod-campo EXCLUSIVE-LOCK:
            DELETE decla-import-adic-trib NO-ERROR.
        END.
    END.
    ELSE DO:
        FIND FIRST decla-import-adic-trib
             WHERE decla-import-adic-trib.num-di-ems       = tt-decla-import-adic.num-di-ems
               AND decla-import-adic-trib.num-adic         = tt-decla-import-adic.num-adic
               AND decla-import-adic-trib.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
               AND decla-import-adic-trib.nom-trib         = p-nom-trib 
               AND decla-import-adic-trib.cod-campo        = p-cod-campo EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL decla-import-adic-trib THEN DO:
            CREATE decla-import-adic-trib.
            ASSIGN decla-import-adic-trib.num-di-ems       = tt-decla-import-adic.num-di-ems
                   decla-import-adic-trib.num-adic         = tt-decla-import-adic.num-adic
                   decla-import-adic-trib.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
                   decla-import-adic-trib.nom-trib         = p-nom-trib 
                   decla-import-adic-trib.cod-campo        = p-cod-campo.
        END.
        ASSIGN decla-import-adic-trib.cod-conteudo = p-cod-conteudo.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos wMaintenanceNoNavigation 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT CAN-FIND(FIRST tt-decla-import-adic-parc-aux
                WHERE tt-decla-import-adic-parc-aux.num-di-ems       = tt-decla-import-adic.num-di-ems
                AND   tt-decla-import-adic-parc-aux.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
                AND   tt-decla-import-adic-parc-aux.num-adic         = tt-decla-import-adic.num-adic
                AND   tt-decla-import-adic-parc-aux.idi-tip-pagto    = 1
                OR    tt-decla-import-adic-parc-aux.idi-tip-pagto    = 2 ) THEN DO:

        
        DISABLE tt-decla-import-adic.cdn-corretor
                tt-decla-import-adic.cdn-banco
                tt-decla-import-adic.cdn-praca
                tt-decla-import-adic.cod-contrat-cambio
                tt-decla-import-adic.log-moed-nac
            WITH FRAME fPage7.
    END.
    ELSE DO:
         ENABLE tt-decla-import-adic.cdn-corretor
                tt-decla-import-adic.cdn-banco
                tt-decla-import-adic.cdn-praca
                tt-decla-import-adic.cod-contrat-cambio
                tt-decla-import-adic.log-moed-nac
            WITH FRAME fPage7.  
         
    END.
    RETURN "OK":U.
    /*IF AVAIL tt-decla-import-adic-parc-aux THEN DO:
        IF tt-decla-import-adic-parc-aux.idi-tip-pagto = 3 
           AND (cb-idi-ind-pagto = "1" OR cb-idi-ind-pagto = "2")  THEN
            ASSIGN tt-decla-import-adic-parc-aux.num-mes-parc:READ-ONLY IN BROWSE brParcelas = NO
                   tt-decla-import-adic-parc-aux.num-ano-parc:READ-ONLY IN BROWSE brParcelas = NO.
        ELSE 
            ASSIGN tt-decla-import-adic-parc-aux.num-mes-parc:READ-ONLY IN BROWSE brParcelas = YES
                   tt-decla-import-adic-parc-aux.num-ano-parc:READ-ONLY IN BROWSE brParcelas = YES.
    END.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-modificaAcres wMaintenanceNoNavigation 
PROCEDURE pi-modificaAcres :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DO  i-cont = 1 TO brAcres:NUM-SELECTED-ROWS IN FRAME fPage8:
        IF  brAcres:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage8 THEN DO:  
            ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

            RUN imp/im0410d.w PERSISTENT SET h-im0410d (INPUT tt-despes-adic-aux.r-Rowid, /* prTable  */
                                                        input tt-decla-import-adic.r-Rowid, /* prParent*/
                                                        INPUT 'UPDATE', /* pcAction */
                                                        INPUT THIS-PROCEDURE,
                                                        INPUT 8). /* phCaller */

            FOR FIRST tt-acres-auxiliar 
                WHERE tt-acres-auxiliar.num-di-ems      = tt-despes-adic-aux.num-di-ems
                AND   tt-acres-auxiliar.num-adic        = tt-despes-adic-aux.num-adic
                AND   tt-acres-auxiliar.cdn-despes      = tt-despes-adic-aux.cdn-despes
                AND   tt-acres-auxiliar.cdn-emit-despes = tt-despes-adic-aux.cdn-emit-despes:
                run pi-seta-linha-browse in h-im0410d(input tt-acres-auxiliar.num-conta).
            END. /* FOR FIRST tt-acres-auxiliar */
            
            IF  VALID-HANDLE(h-im0410d) THEN DO:   
                RUN initializeInterface IN h-im0410d.
                WAIT-FOR CLOSE OF h-im0410d FOCUS CURRENT-WINDOW.
            END. 
            ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        END. /* IF  brAcres:FETCH-SELECTED-ROW(i-cont) */
    END. /* DO  i-cont = 1 TO brAcres */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-modificaItens wMaintenanceNoNavigation 
PROCEDURE pi-modificaItens :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DO  i-cont = 1 TO brItens:NUM-SELECTED-ROWS IN FRAME fPage3:
        IF  brItens:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage3 THEN DO:  
            ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

            RUN imp/im0410c.w PERSISTENT SET h-im0410c (INPUT tt-decla-import-adic-itens-aux.r-Rowid, /* prTable  */
                                                        input tt-decla-import-adic.r-Rowid, /* prParent*/
                                                        INPUT 'UPDATE', /* pcAction */
                                                        INPUT THIS-PROCEDURE,
                                                        INPUT 4). /* phCaller */

            FOR FIRST tt-itens-auxiliar 
                WHERE tt-itens-auxiliar.num-di-ems = tt-decla-import-adic-itens-aux.num-di-ems
                AND   tt-itens-auxiliar.num-adic   = tt-decla-import-adic-itens-aux.num-adic
                AND   tt-itens-auxiliar.num-seq    = tt-decla-import-adic-itens-aux.num-seq:
                run pi-seta-linha-browse in h-im0410c(input tt-itens-auxiliar.num-conta).
            END. /* FOR FIRST tt-itens-auxiliar */
            
            IF  VALID-HANDLE(h-im0410c) THEN DO:   
                RUN initializeInterface IN h-im0410c.
                WAIT-FOR CLOSE OF h-im0410c FOCUS CURRENT-WINDOW.
            END. 
            ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        END. /* IF  brItens:FETCH-SELECTED-ROW(i-cont) */
    END. /* DO  i-cont = 1 TO brItens */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-documento wMaintenanceNoNavigation 
PROCEDURE pi-salva-documento :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-decla-import-adic-docto.

    CREATE tt-decla-import-adic-docto.
    ASSIGN tt-decla-import-adic-docto.num-di-ems           = tt-decla-import-adic.num-di-ems
           tt-decla-import-adic-docto.cdd-siscomex-dts     = tt-decla-import-adic.cdd-siscomex-dts
           tt-decla-import-adic-docto.num-adic             = tt-decla-import-adic.num-adic
           tt-decla-import-adic-docto.cod-num-docto        = INPUT BROWSE brDoctoVinc tt-decla-import-adic-docto-aux.cod-num-docto
           tt-decla-import-adic-docto.idi-tip-docto-vincul = INPUT BROWSE brDoctoVinc tt-decla-import-adic-docto-aux.idi-tip-docto-vincul.

    RUN emptyRowErrors IN h-bocx394.
    RUN emptyRowObject IN h-bocx394.
    RUN setRecord      IN h-bocx394 (INPUT TABLE tt-decla-import-adic-docto).
    RUN createRecord   IN h-bocx394.
    IF  RETURN-VALUE = "OK":U THEN DO:
        DISABLE btCanDocumento btSaveDocumento WITH FRAME fPage1.
        ENABLE btAddDocumento btDelDocumento WITH FRAME fPage1.  

        ASSIGN tt-decla-import-adic-docto-aux.cod-num-docto:READ-ONLY IN BROWSE brDoctoVinc = YES
               tt-decla-import-adic-docto-aux.idi-tip-docto-vincul:READ-ONLY IN BROWSE brDoctoVinc = YES.

        RUN pi-busca-documentos-vinculados.
        APPLY 'entry' TO btAddDocumento IN FRAME fPage1.
    END.
    ELSE DO:
        RUN getRowErrors IN h-bocx394(OUTPUT TABLE RowErrors).
        IF  CAN-FIND(FIRST RowErrors
                     WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-NVE wMaintenanceNoNavigation 
PROCEDURE pi-salva-NVE :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-decla-import-adic-nve.

    CREATE tt-decla-import-adic-nve.
    ASSIGN tt-decla-import-adic-nve.num-di-ems       = tt-decla-import-adic.num-di-ems
           tt-decla-import-adic-nve.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
           tt-decla-import-adic-nve.num-adic         = tt-decla-import-adic.num-adic
           tt-decla-import-adic-nve.idi-niv          = INPUT BROWSE brNVE tt-decla-import-adic-nve-aux.idi-niv
           tt-decla-import-adic-nve.cod-ident        = INPUT BROWSE brNVE tt-decla-import-adic-nve-aux.cod-ident
           tt-decla-import-adic-nve.cod-atributo     = INPUT BROWSE brNVE tt-decla-import-adic-nve-aux.cod-atributo
           tt-decla-import-adic-nve.cdn-especif      = INPUT BROWSE brNVE tt-decla-import-adic-nve-aux.cdn-especif.

    RUN emptyRowErrors IN h-bocx393.
    RUN emptyRowObject IN h-bocx393.
    RUN setRecord      IN h-bocx393 (INPUT TABLE tt-decla-import-adic-nve).
    RUN createRecord   IN h-bocx393.
    IF  RETURN-VALUE = "OK":U THEN DO:
        DISABLE btCanNVE btSaveNVE WITH FRAME fPage2.
        ENABLE btAddNVE btDelNVE WITH FRAME fPage2.  

        ASSIGN tt-decla-import-adic-nve-aux.idi-niv:READ-ONLY      IN BROWSE brNVE = YES
               tt-decla-import-adic-nve-aux.cod-ident:READ-ONLY    IN BROWSE brNVE = YES
               tt-decla-import-adic-nve-aux.cod-atributo:READ-ONLY IN BROWSE brNVE = YES
               tt-decla-import-adic-nve-aux.cdn-especif:READ-ONLY  IN BROWSE brNVE = YES.

        RUN pi-busca-NVE.
        APPLY 'entry' TO btAddNVE IN FRAME fPage2.
    END.
    ELSE DO:
        RUN getRowErrors IN h-bocx393(OUTPUT TABLE RowErrors).
        IF  CAN-FIND(FIRST RowErrors
                     WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-parcela wMaintenanceNoNavigation 
PROCEDURE pi-salva-parcela :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-decla-import-adic-parc.

    CREATE tt-decla-import-adic-parc.
    ASSIGN tt-decla-import-adic-parc.num-di-ems       = tt-decla-import-adic.num-di-ems
           tt-decla-import-adic-parc.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
           tt-decla-import-adic-parc.num-adic         = tt-decla-import-adic.num-adic
           tt-decla-import-adic-parc.idi-tip-pagto    = INPUT BROWSE brParcelas tt-decla-import-adic-parc-aux.idi-tip-pagto
           tt-decla-import-adic-parc.num-seq-parc     = INPUT BROWSE brParcelas tt-decla-import-adic-parc-aux.num-seq-parc
           tt-decla-import-adic-parc.num-mes-parc     = INPUT BROWSE brParcelas tt-decla-import-adic-parc-aux.num-mes-parc
           tt-decla-import-adic-parc.num-ano-parc     = INPUT BROWSE brParcelas tt-decla-import-adic-parc-aux.num-ano-parc
           tt-decla-import-adic-parc.val-parc         = INPUT BROWSE brParcelas tt-decla-import-adic-parc-aux.val-parc.

    RUN emptyRowErrors IN h-bocx392.
    RUN emptyRowObject IN h-bocx392.
    RUN setRecord      IN h-bocx392 (INPUT TABLE tt-decla-import-adic-parc).
    RUN createRecord   IN h-bocx392.
    IF  RETURN-VALUE = "OK":U THEN DO:
        DISABLE btCanParcela btSaveParcela WITH FRAME fPage7.
        ENABLE btAddParcela btDelParcela WITH FRAME fPage7.  

        ASSIGN tt-decla-import-adic-parc-aux.idi-tip-pagto:READ-ONLY IN BROWSE brParcelas = YES
               tt-decla-import-adic-parc-aux.num-seq-parc:READ-ONLY IN BROWSE brParcelas = YES
               tt-decla-import-adic-parc-aux.num-mes-parc:READ-ONLY IN BROWSE brParcelas = YES
               tt-decla-import-adic-parc-aux.num-ano-parc:READ-ONLY IN BROWSE brParcelas = YES
               tt-decla-import-adic-parc-aux.val-parc:READ-ONLY IN BROWSE brParcelas = YES.
        
        RUN pi-busca-parcelas.
        APPLY 'entry' TO btAddParcela IN FRAME fPage7.
        IF tt-decla-import-adic-parc-aux.idi-tip-pagto = 1 OR 
           tt-decla-import-adic-parc-aux.idi-tip-pagto = 2 THEN        
            ENABLE tt-decla-import-adic.cdn-corretor
                   tt-decla-import-adic.cdn-banco
                   tt-decla-import-adic.cdn-praca
                   tt-decla-import-adic.cod-contrat-cambio
                   tt-decla-import-adic.log-moed-nac 
                WITH FRAME fPage7.
        ELSE
            RUN pi-habilita-campos.
    END.
    ELSE DO:
        RUN getRowErrors IN h-bocx392(OUTPUT TABLE RowErrors).
        IF  CAN-FIND(FIRST RowErrors
                     WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-registro wMaintenanceNoNavigation 
PROCEDURE pi-salva-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* salva as altera‡äes */
    ASSIGN vRowid-Auxiliar = tt-decla-import-adic.r-Rowid.
    RUN pi-saveRecord.
    RUN repositionRecord IN {&hDBOTable} (INPUT vRowid-Auxiliar).

    RUN pi-posiciona-registro IN {&hDBOTable} (INPUT tt-decla-import-adic.num-di-ems,
                                               INPUT tt-decla-import-adic.num-adic,
                                               INPUT tt-decla-import-adic.cdd-siscomex-dts).
    RUN saveRecord IN THIS-PROCEDURE.
    /*RELEASE decla-import-adic.*/

    RUN pi-posiciona-registro IN {&hDBOTable} (INPUT tt-decla-import-adic.num-di-ems,
                                               INPUT tt-decla-import-adic.num-adic,
                                               INPUT tt-decla-import-adic.cdd-siscomex-dts).
    RUN GetCurrentFolder IN hFolder (OUTPUT i-pagina). /*salva o numero da frame que o usuario esta*/
    ASSIGN vRowid-Auxiliar = tt-decla-import-adic.r-Rowid.

    RUN pi-saveRecord.
    RUN repositionRecord IN {&hDBOTable} (INPUT vRowid-Auxiliar).
    RUN saveRecord IN THIS-PROCEDURE.
    find first tt-decla-import-adic EXCLUSIVE-LOCK no-error.

    RUN SetFolder IN hFolder (INPUT i-pagina).  /* seta o folder que o usu rios estava */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-saveRecord wMaintenanceNoNavigation 
PROCEDURE pi-saveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    assign input frame fPage1 cb-idi-ind-vincul
           input frame fPage2 cb-idi-metod-val
           input frame fPage7 cb-idi-ind-pagto
           input frame fPage4 cb-idi-tributac-cofins
           input frame fPage4 cb-idi-tributac-icms
           input frame fPage4 cb-idi-tributac-impto-import
           input frame fPage4 cb-idi-tributac-ipi
           input frame fPage4 cb-idi-tributac-pis.

    assign tt-decla-import-adic.idi-ind-vincul            = {cxinc/i03cx403.i 06 cb-idi-ind-vincul}
           tt-decla-import-adic.idi-metod-val             = {cxinc/i01cx404.i 06 cb-idi-metod-val}
           tt-decla-import-adic.idi-ind-pagto             = {cxinc/i02cx404.i 06 cb-idi-ind-pagto}
           tt-decla-import-adic.idi-tributac-cofins       = {cxinc/i01cx402.i 06 cb-idi-tributac-cofins}
           tt-decla-import-adic.idi-tributac-icms         = {cxinc/i02cx402.i 06 cb-idi-tributac-icms}
           tt-decla-import-adic.idi-tributac-impto-import = {cxinc/i01cx402.i 06 cb-idi-tributac-impto-import}
           tt-decla-import-adic.idi-tributac-ipi          = {cxinc/i01cx402.i 06 cb-idi-tributac-ipi}
           tt-decla-import-adic.idi-tributac-pis          = {cxinc/i01cx402.i 06 cb-idi-tributac-pis}
           tt-decla-import-adic.log-suspens-ipi-import    = if input frame fPage4 cb-suspens-ipi-import   = 'Sim' then yes else no
           tt-decla-import-adic.log-suspens-impto-import  = if input frame fPage4 cb-suspens-impto-import = 'Sim' then yes else no.

    &if '{&bf_mat_versao_ems}' >= '2.09' &then
        ASSIGN tt-decla-import-adic.log-suspens-icms   = IF INPUT FRAME fPage4 cb-suspens-icms   = 'Sim' THEN YES ELSE NO
               tt-decla-import-adic.log-suspens-pis    = IF INPUT FRAME fPage4 cb-suspens-pis    = 'Sim' THEN YES ELSE NO
               tt-decla-import-adic.log-suspens-cofins = IF INPUT FRAME fPage4 cb-suspens-cofins = 'Sim' THEN YES ELSE NO.
    &else
        ASSIGN OVERLAY(tt-decla-import-adic.cod-livre-1,1,1) = IF INPUT FRAME fPage4 cb-suspens-icms   = 'Sim' THEN '1' ELSE '0' 
               OVERLAY(tt-decla-import-adic.cod-livre-1,2,1) = IF INPUT FRAME fPage4 cb-suspens-pis    = 'Sim' THEN '1' ELSE '0' 
               OVERLAY(tt-decla-import-adic.cod-livre-1,3,1) = IF INPUT FRAME fPage4 cb-suspens-cofins = 'Sim' THEN '1' ELSE '0'.
    &endif           

    /* valores dos impostos */
    /* 
        tributacao: 1 - tributado (val-xx-db-cr)
                    2 - isento (val-xx-db-cr = 0)
                    3 - outras (val-xxx-outras)
                    4 - reduzido (val-xxx-db-cr)
        suspenso: val-xxx-nao-tribut
    */
    /* zerar valores dos impostos */
    ASSIGN tt-decla-import-adic.val-ii-db-cr          = 0
           tt-decla-import-adic.val-ii-outras         = 0
           tt-decla-import-adic.val-ii-nao-tribut     = 0

           tt-decla-import-adic.val-ipi-db-cr         = 0
           tt-decla-import-adic.val-ipi-outras        = 0
           tt-decla-import-adic.val-ipi-nao-tribut    = 0
                                                      
           tt-decla-import-adic.val-pis-db-cr         = 0
           tt-decla-import-adic.val-pis-outras        = 0
           tt-decla-import-adic.val-pis-nao-tribut    = 0

           tt-decla-import-adic.val-cofins-db-cr      = 0
           tt-decla-import-adic.val-cofins-outras     = 0
           tt-decla-import-adic.val-cofins-nao-tribut = 0

           tt-decla-import-adic.val-icms-db-cr        = 0
           tt-decla-import-adic.val-icms-outras       = 0
           tt-decla-import-adic.val-icms-nao-tribut   = 0.

    /* ii */
    IF INPUT FRAME fPage4 cb-suspens-impto-import = 'Sim' THEN
        ASSIGN tt-decla-import-adic.val-ii-nao-tribut = INPUT FRAME fPage4 d-valor-impostos-ii.
    ELSE DO:
        IF tt-decla-import-adic.idi-tributac-impto-import = 1 OR
           tt-decla-import-adic.idi-tributac-impto-import = 4  THEN
            ASSIGN tt-decla-import-adic.val-ii-db-cr = INPUT FRAME fPage4 d-valor-impostos-ii.
        ELSE DO:
            IF tt-decla-import-adic.idi-tributac-impto-import = 2 THEN
                ASSIGN tt-decla-import-adic.val-ii-db-cr = INPUT FRAME fPage4 d-valor-impostos-ipi.
            ELSE
                IF tt-decla-import-adic.idi-tributac-impto-import = 3 THEN
                    ASSIGN tt-decla-import-adic.val-ii-outras = INPUT FRAME fPage4 d-valor-impostos-ii.
        END.
     END. /* else do */
     /* fim - ii */

     /* ipi */ 
     IF INPUT FRAME fPage4 cb-suspens-ipi-import = 'Sim' THEN
        ASSIGN tt-decla-import-adic.val-ipi-nao-tribut = INPUT FRAME fPage4 d-valor-impostos-ipi.
     ELSE DO:
        IF tt-decla-import-adic.idi-tributac-ipi = 1 OR
           tt-decla-import-adic.idi-tributac-ipi = 4  THEN
            ASSIGN tt-decla-import-adic.val-ipi-db-cr = INPUT FRAME fPage4 d-valor-impostos-ipi.
        ELSE DO:
            IF tt-decla-import-adic.idi-tributac-ipi = 2 THEN
                ASSIGN tt-decla-import-adic.val-ipi-db-cr = INPUT FRAME fPage4 d-valor-impostos-ipi.
            ELSE
                IF tt-decla-import-adic.idi-tributac-ipi = 3 THEN
                    ASSIGN tt-decla-import-adic.val-ipi-outras = INPUT FRAME fPage4 d-valor-impostos-ipi.
        END.
     END. /* else do */
     /* fim - ipi */ 

     /* pis */
     IF INPUT FRAME fPage4 cb-suspens-pis = 'Sim' THEN
        ASSIGN tt-decla-import-adic.val-pis-nao-tribut = INPUT FRAME fPage4 d-valor-impostos-pis.
     ELSE DO:
        IF tt-decla-import-adic.idi-tributac-pis = 1 OR
           tt-decla-import-adic.idi-tributac-pis = 4  THEN
            ASSIGN tt-decla-import-adic.val-pis-db-cr = INPUT FRAME fPage4 d-valor-impostos-pis.
        ELSE DO:
            IF tt-decla-import-adic.idi-tributac-pis = 2 THEN
                ASSIGN tt-decla-import-adic.val-pis-db-cr = INPUT FRAME fPage4 d-valor-impostos-ipi.
            ELSE
                IF tt-decla-import-adic.idi-tributac-pis = 3 THEN
                    ASSIGN tt-decla-import-adic.val-pis-outras = INPUT FRAME fPage4 d-valor-impostos-pis.
        END.
     END.
     /* fim - pis */

     /* cofins */
     IF INPUT FRAME fPage4 cb-suspens-cofins = 'Sim' THEN
        ASSIGN tt-decla-import-adic.val-cofins-nao-tribut = INPUT FRAME fPage4 d-valor-impostos-cofins.
     ELSE DO:
        IF tt-decla-import-adic.idi-tributac-cofins = 1 OR
           tt-decla-import-adic.idi-tributac-cofins = 4  THEN
            ASSIGN tt-decla-import-adic.val-cofins-db-cr = INPUT FRAME fPage4 d-valor-impostos-cofins.
        ELSE DO:
            IF tt-decla-import-adic.idi-tributac-cofins = 2 THEN
                ASSIGN tt-decla-import-adic.val-cofins-db-cr = INPUT FRAME fPage4 d-valor-impostos-ipi.
            ELSE
                IF tt-decla-import-adic.idi-tributac-cofins = 3 THEN
                    ASSIGN tt-decla-import-adic.val-cofins-outras = INPUT FRAME fPage4 d-valor-impostos-cofins.
        END.
     END.
     /* fim - cofins */

     /* icms */
     IF INPUT FRAME fPage4 cb-suspens-icms = 'Sim' THEN
        ASSIGN tt-decla-import-adic.val-icms-nao-tribut = INPUT FRAME fPage4 d-valor-impostos-icms.
     ELSE DO:
        IF tt-decla-import-adic.idi-tributac-icms = 1 OR
           tt-decla-import-adic.idi-tributac-icms = 4  THEN
            ASSIGN tt-decla-import-adic.val-icms-db-cr = INPUT FRAME fPage4 d-valor-impostos-icms.
        ELSE DO:
            IF tt-decla-import-adic.idi-tributac-icms = 2 THEN
                ASSIGN tt-decla-import-adic.val-icms-db-cr = INPUT FRAME fPage4 d-valor-impostos-ipi.
            ELSE
                IF tt-decla-import-adic.idi-tributac-icms = 3 THEN
                    ASSIGN tt-decla-import-adic.val-icms-outras = INPUT FRAME fPage4 d-valor-impostos-icms.
        END.
     END.
     /* fim - icms */

     IF l-nt2024002 THEN DO:
         ASSIGN INPUT FRAME fPage5 cb-idi-tributac-ibsuf
                INPUT FRAME fPage5 cb-idi-tributac-ibsmun
                INPUT FRAME fPage5 cb-idi-tributac-cbs
                INPUT FRAME fPage5 cb-idi-tributac-is.
                
         /* IBS UF */
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "COD-TRIB",     INPUT {diinc/i01di628.i 06 cb-idi-tributac-ibsuf:SCREEN-VALUE IN FRAME fPage5}).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "ALIQUOTA",     INPUT INPUT FRAME fPage5 de-val-aliq-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "ALIQ-RED",     INPUT INPUT FRAME fPage5 de-perc-reduc-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "BASE",         INPUT INPUT FRAME fPage5 de-base-ibsuf).
         IF SUBSTRING(INPUT FRAME fPage5 cb-idi-tributac-ibsuf,1,1) = "O":U THEN //Outros
            RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "OUTROS",    INPUT INPUT FRAME fPage5 de-valor-impostos-ibsuf). 
         ELSE
            RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "VALOR",     INPUT INPUT FRAME fPage5 de-valor-impostos-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "CST",          INPUT INPUT FRAME fPage5 c-cst-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "C-CLASS-TRIB", INPUT INPUT FRAME fPage5 c-class-trib-ibsuf).
         
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "ALIQ-EFETIVA-REG", INPUT INPUT FRAME fPage5 de-val-aliq-reg-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "BASE-REG",         INPUT INPUT FRAME fPage5 de-base-reg-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "VALOR-REG",        INPUT INPUT FRAME fPage5 de-valor-impostos-reg-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "C-CLASS-TRIB-REG", INPUT INPUT FRAME fPage5 c-class-trib-reg-ibsuf).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSUF", INPUT "CST-REG",          INPUT INPUT FRAME fPage5 c-cst-reg-ibsuf).

         /* IBS Mun */
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "COD-TRIB",     INPUT {diinc/i01di628.i 06 cb-idi-tributac-ibsmun:SCREEN-VALUE IN FRAME fPage5}).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "ALIQUOTA",     INPUT INPUT FRAME fPage5 de-val-aliq-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "ALIQ-RED",     INPUT INPUT FRAME fPage5 de-perc-reduc-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "BASE",         INPUT INPUT FRAME fPage5 de-base-ibsmun).
         IF SUBSTRING(INPUT FRAME fPage5 cb-idi-tributac-ibsmun,1,1) = "O":U THEN //Outros
            RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "OUTROS",    INPUT INPUT FRAME fPage5 de-valor-impostos-ibsmun). 
         ELSE
            RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "VALOR",     INPUT INPUT FRAME fPage5 de-valor-impostos-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "CST",          INPUT INPUT FRAME fPage5 c-cst-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "C-CLASS-TRIB", INPUT INPUT FRAME fPage5 c-class-trib-ibsmun).
         
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "ALIQ-EFETIVA-REG", INPUT INPUT FRAME fPage5 de-val-aliq-reg-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "BASE-REG",         INPUT INPUT FRAME fPage5 de-base-reg-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "VALOR-REG",        INPUT INPUT FRAME fPage5 de-valor-impostos-reg-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "C-CLASS-TRIB-REG", INPUT INPUT FRAME fPage5 c-class-trib-reg-ibsmun).
         RUN pi-grava-decla-import-adic-trib (INPUT "IBSMUN", INPUT "CST-REG",          INPUT INPUT FRAME fPage5 c-cst-reg-ibsmun).

         /* CBS */
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "COD-TRIB",     INPUT {diinc/i01di628.i 06 cb-idi-tributac-cbs:SCREEN-VALUE IN FRAME fPage5}).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "ALIQUOTA",     INPUT INPUT FRAME fPage5 de-val-aliq-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "ALIQ-RED",     INPUT INPUT FRAME fPage5 de-perc-reduc-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "BASE",         INPUT INPUT FRAME fPage5 de-base-cbs).
         IF SUBSTRING(INPUT FRAME fPage5 cb-idi-tributac-cbs,1,1) = "O":U THEN //Outros
            RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "OUTROS",    INPUT INPUT FRAME fPage5 de-valor-impostos-cbs). 
         ELSE
            RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "VALOR",     INPUT INPUT FRAME fPage5 de-valor-impostos-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "CST",          INPUT INPUT FRAME fPage5 c-cst-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "C-CLASS-TRIB", INPUT INPUT FRAME fPage5 c-class-trib-cbs).

         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "ALIQ-EFETIVA-REG", INPUT INPUT FRAME fPage5 de-val-aliq-reg-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "BASE-REG",         INPUT INPUT FRAME fPage5 de-base-reg-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "VALOR-REG",        INPUT INPUT FRAME fPage5 de-valor-impostos-reg-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "C-CLASS-TRIB-REG", INPUT INPUT FRAME fPage5 c-class-trib-reg-cbs).
         RUN pi-grava-decla-import-adic-trib (INPUT "CBS", INPUT "CST-REG",          INPUT INPUT FRAME fPage5 c-cst-reg-cbs).
         
         /*IS*/
        RUN pi-grava-decla-import-adic-trib (INPUT "IS",     INPUT "C-CLASS-TRIB",     INPUT INPUT FRAME fPage5 c-class-trib-is).
        RUN pi-grava-decla-import-adic-trib (INPUT "IS",     INPUT "CST",              INPUT INPUT FRAME fPage5 c-cst-is).
        RUN pi-grava-decla-import-adic-trib (INPUT "IS",     INPUT "COD-TRIB",         INPUT {diinc/i01di628.i 06 cb-idi-tributac-is:SCREEN-VALUE IN FRAME fpage5}).
        RUN pi-grava-decla-import-adic-trib (INPUT "IS",     INPUT "ALIQUOTA",         INPUT INPUT FRAME fPage5 de-val-aliq-is).
        RUN pi-grava-decla-import-adic-trib (INPUT "IS",     INPUT "ALIQ-ESPEC-UN",    INPUT INPUT FRAME fPage5 de-val-aliq-espec-is).
        RUN pi-grava-decla-import-adic-trib (INPUT "IS",     INPUT "QTDE-TRIBUT",      INPUT INPUT FRAME fPage5 de-qtde-is).
        RUN pi-grava-decla-import-adic-trib (INPUT "IS",     INPUT "UN-TRIBUT",        INPUT INPUT FRAME fPage5 c-un-trib-is).
        RUN pi-grava-decla-import-adic-trib (INPUT "IS",     INPUT "BASE",             INPUT INPUT FRAME fPage5 de-base-is).
        IF SUBSTRING(INPUT FRAME fPage5 cb-idi-tributac-is,1,1) = "O":U THEN //Outros
           RUN pi-grava-decla-import-adic-trib (INPUT "IS", INPUT "OUTROS",    INPUT INPUT FRAME fPage5 de-valor-impostos-is). 
        ELSE
           RUN pi-grava-decla-import-adic-trib (INPUT "IS", INPUT "VALOR",     INPUT INPUT FRAME fPage5 de-valor-impostos-is).
     END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-linha-browse wMaintenanceNoNavigation 
PROCEDURE pi-seta-linha-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-num-linha-browse AS INTEGER   NO-UNDO.

assign i-num-linha-browse = p-num-linha-browse.

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-combos wMaintenanceNoNavigation 
PROCEDURE pi-trata-combos :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/


    ASSIGN cb-idi-ind-vincul:screen-value            in frame fPage1 = {cxinc/i03cx403.i 04 tt-decla-import-adic.idi-ind-vincul}
           cb-idi-metod-val:screen-value             in frame fPage2 = {cxinc/i01cx404.i 04 tt-decla-import-adic.idi-metod-val}
           cb-idi-ind-pagto:screen-value             in frame fPage7 = {cxinc/i02cx404.i 04 tt-decla-import-adic.idi-ind-pagto}
           cb-idi-tributac-icms:screen-value         in frame fPage4 = {cxinc/i02cx402.i 04 tt-decla-import-adic.idi-tributac-icms}
           cb-idi-tributac-ipi:screen-value          in frame fPage4 = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-ipi}
           cb-idi-tributac-pis:screen-value          in frame fPage4 = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-pis}
           cb-idi-tributac-cofins:screen-value       in frame fPage4 = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-cofins}
           cb-idi-tributac-impto-import:screen-value in frame fPage4 = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-impto-import}
           cb-suspens-impto-import:screen-value      in frame fPage4 = if tt-decla-import-adic.log-suspens-impto-import then 'Sim' else 'NÆo'
           cb-suspens-ipi-import:screen-value        in frame fPage4 = if tt-decla-import-adic.log-suspens-ipi-import   then 'Sim' else 'NÆo'
           .
    &if '{&bf_mat_versao_ems}' >= '2.09' &then
        ASSIGN cb-suspens-icms:SCREEN-VALUE IN FRAME   fPage4 = IF tt-decla-import-adic.log-suspens-icms   THEN 'Sim' ELSE 'NÆo'
               cb-suspens-pis:SCREEN-VALUE IN FRAME    fPage4 = IF tt-decla-import-adic.log-suspens-pis    THEN 'Sim' ELSE 'NÆo'
               cb-suspens-cofins:SCREEN-VALUE IN FRAME fPage4 = IF tt-decla-import-adic.log-suspens-cofins THEN 'Sim' ELSE 'NÆo'.
    &else
        ASSIGN cb-suspens-icms:SCREEN-VALUE IN FRAME   fPage4 = IF SUBSTRING(tt-decla-import-adic.cod-livre-1,1,1) = '1' THEN 'Sim' ELSE 'NÆo'
               cb-suspens-pis:SCREEN-VALUE IN FRAME    fPage4 = IF SUBSTRING(tt-decla-import-adic.cod-livre-1,2,1) = '1' THEN 'Sim' ELSE 'NÆo'
               cb-suspens-cofins:SCREEN-VALUE IN FRAME fPage4 = IF SUBSTRING(tt-decla-import-adic.cod-livre-1,3,1) = '1' THEN 'Sim' ELSE 'NÆo'.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-cor wMaintenanceNoNavigation 
PROCEDURE pi-troca-cor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pColor AS INTEGER NO-UNDO.

ASSIGN tt-despes-adic-aux.cdn-despes                 :FGCOLOR IN BROWSE brAcres = pColor
       c-desc-despes                                 :FGCOLOR IN BROWSE brAcres = pColor
       tt-despes-adic-aux.cdn-emit-despes            :FGCOLOR IN BROWSE brAcres = pColor
       c-nome-fornecedor                             :FGCOLOR IN BROWSE brAcres = pColor
       tt-despes-adic-aux.cdn-cond-pag               :FGCOLOR IN BROWSE brAcres = pColor
       tt-despes-adic-aux.cdn-moeda                  :FGCOLOR IN BROWSE brAcres = pColor
       c-nome-moeda                                  :FGCOLOR IN BROWSE brAcres = pColor
       tt-despes-adic-aux.val-despes                 :FGCOLOR IN BROWSE brAcres = pColor
       tt-despes-adic-aux.val-cotac-despes-compltar  :FGCOLOR IN BROWSE brAcres = pColor
       tt-despes-adic-aux.cod-incoterm-rat           :FGCOLOR IN BROWSE brAcres = pColor
       tt-despes-adic-aux.log-forma-preco-compra     :FGCOLOR IN BROWSE brAcres = pColor
       tt-despes-adic-aux.log-incid-vmle             :FGCOLOR IN BROWSE brAcres = pColor.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida wMaintenanceNoNavigation 
PROCEDURE pi-valida :
/*:T---------------------------------------------------------------------------
  Purpose:     Realiza valida‡äes 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-valida-emitente AS LOGICAL NO-UNDO.

    IF p-valida-emitente THEN DO:

        IF  input frame fPage7 tt-decla-import-adic.cdn-agent <> 0 then do:
             FIND FIRST emitente
                  WHERE emitente.cod-emitente = tt-decla-import-adic.cdn-agent NO-LOCK NO-ERROR.
             IF NOT AVAIL emitente THEN DO:
                run utp/ut-msgs.p (input "show",
                                   input 3486,
                                   input tt-decla-import-adic.cdn-agent).
                return "NOK":U.
             END.
        END.
    END.
    
    IF TRIM(INPUT FRAME fPage2 tt-decla-import-adic.cod-licenc-import) = "" THEN DO:
        
        FOR EACH tt-decla-import-adic-itens-aux:
            IF CAN-FIND(FIRST ITEM
                        WHERE ITEM.it-codigo = tt-decla-import-adic-itens-aux.cod-item
                          AND ITEM.log-necessita-li) THEN DO:
                RUN utp/ut-msgs.p (INPUT 'show':U, 
                                   INPUT 56581,
                                   INPUT tt-decla-import-adic-itens-aux.cod-item).
                RETURN "NOK":U.
            END.
        END.

        IF  TRIM(INPUT FRAME fPage2 tt-decla-import-adic.dat-livre-1) <> ""
        AND TRIM(INPUT FRAME fPage2 tt-decla-import-adic.dat-livre-1) <> ?
        AND TRIM(INPUT FRAME fPage2 tt-decla-import-adic.dat-livre-1) <> "/  /" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 56574,
                               INPUT "").
            RETURN "NOK":U.
        END.
    END.
    
    IF l-nt2024002 THEN DO:
        IF c-class-trib-ibsuf:SCREEN-VALUE IN FRAME fpage5 <> "":U THEN DO:
            FIND FIRST class-trib NO-LOCK
                 WHERE class-trib.cod-cclass-trib = c-class-trib-ibsuf:SCREEN-VALUE IN FRAME fpage5
                   AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
            IF NOT AVAIL class-trib THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 2,
                                   INPUT "Class Trib":U + "~~" + c-class-trib-ibsuf:SCREEN-VALUE IN FRAME fpage5).
                RETURN "NOK":U.
            END.
        END.

        IF c-class-trib-ibsmun:SCREEN-VALUE IN FRAME fpage5 <> "":U THEN DO:
            FIND FIRST class-trib NO-LOCK
                 WHERE class-trib.cod-cclass-trib = c-class-trib-ibsmun:SCREEN-VALUE IN FRAME fpage5
                   AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
            IF NOT AVAIL class-trib THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 2,
                                   INPUT "Class Trib":U + "~~" + c-class-trib-ibsmun:SCREEN-VALUE IN FRAME fpage5).
                RETURN "NOK":U.
            END.
        END.
        
        IF c-class-trib-cbs:SCREEN-VALUE IN FRAME fpage5 <> "":U THEN DO:
            FIND FIRST class-trib NO-LOCK
                 WHERE class-trib.cod-cclass-trib = c-class-trib-cbs:SCREEN-VALUE IN FRAME fpage5
                   AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
            IF NOT AVAIL class-trib THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 2,
                                   INPUT "Class Trib":U + "~~" + c-class-trib-cbs:SCREEN-VALUE IN FRAME fpage5).
                RETURN "NOK":U.
            END.
        END.
        
        IF c-class-trib-reg-ibsuf:SCREEN-VALUE IN FRAME fpage5 <> "":U THEN DO:
            FIND FIRST class-trib NO-LOCK
                 WHERE class-trib.cod-cclass-trib = c-class-trib-reg-ibsuf:SCREEN-VALUE IN FRAME fpage5
                   AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
            IF NOT AVAIL class-trib THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 2,
                                   INPUT "Class Trib Regular":U + "~~" + c-class-trib-reg-ibsuf:SCREEN-VALUE IN FRAME fpage5).
                RETURN "NOK":U.
            END.
        END.

        IF c-class-trib-reg-ibsmun:SCREEN-VALUE IN FRAME fpage5 <> "":U THEN DO:
            FIND FIRST class-trib NO-LOCK
                 WHERE class-trib.cod-cclass-trib = c-class-trib-reg-ibsmun:SCREEN-VALUE IN FRAME fpage5
                   AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
            IF NOT AVAIL class-trib THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 2,
                                   INPUT "Class Trib Regular":U + "~~" + c-class-trib-reg-ibsmun:SCREEN-VALUE IN FRAME fpage5).
                RETURN "NOK":U.
            END.
        END.
        
        IF c-class-trib-reg-cbs:SCREEN-VALUE IN FRAME fpage5 <> "":U THEN DO:
            FIND FIRST class-trib NO-LOCK
                 WHERE class-trib.cod-cclass-trib = c-class-trib-reg-cbs:SCREEN-VALUE IN FRAME fpage5
                   AND class-trib.ind-tributo = 1 /* IBS/CBS */ NO-ERROR.
            IF NOT AVAIL class-trib THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 2,
                                   INPUT "Class Trib Regular":U + "~~" + c-class-trib-reg-cbs:SCREEN-VALUE IN FRAME fpage5).
                RETURN "NOK":U.
            END.
        END.
    END.

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-att-impostos wMaintenanceNoNavigation 
PROCEDURE pi-verifica-att-impostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*RUN validaUpdateImpostos IN {&hDBOTable} (INPUT TABLE tt-decla-import-adic-impostos, /* valores antes do update */
                                              INPUT TABLE tt-decla-import-adic, /* valores depois do update */
                                              OUTPUT l-imposto-alterado).
    IF l-imposto-alterado THEN DO:
        RUN utp/ut-msgs.p ( INPUT "SHOW",
                            INPUT 19085,
                            INPUT 'Os valores dos impostos foram alterados, por isso o c lculo dos impostos ser  reaberto!').
        
        RUN pi-atualiza-pend-imp IN h-bocx383a(INPUT tt-decla-import-adic.num-di-ems).
    END.*/
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-despes-acresc wMaintenanceNoNavigation 
PROCEDURE pi-verifica-despes-acresc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST param-imp NO-LOCK
        WHERE param-imp.cod-estabel = INPUT FRAME fPage0 tt-decla-import.cod-estab NO-ERROR.
  
    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.07' &THEN
        ASSIGN i-cdn-despes-siscomex = param-imp.cdn-despes-siscomex.
    &ELSE
        ASSIGN i-cdn-despes-siscomex = INTEGER(SUBSTRING(param-imp.char-1,91,5)).
    &ENDIF
    
    IF AVAIL tt-despes-adic-aux THEN DO:
        IF i-cdn-despes-siscomex = tt-despes-adic-aux.cdn-despes THEN DO:
            DISABLE btExcAcres
                WITH FRAME fPage8.

            ENABLE btAltAcres 
                WITH FRAME fPage8.
        END.
        ELSE DO:
            IF tt-despes-adic-aux.idi-orig = 2 THEN
                DISABLE btAltAcres btExcAcres WITH FRAME fPage8. 
            ELSE
                ENABLE btAltAcres btExcAcres WITH FRAME fPage8.
        END.
    END.   

RETURN "OK":U.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValue-changed-pgto wMaintenanceNoNavigation 
PROCEDURE piValue-changed-pgto :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    ASSIGN INPUT FRAME fPage7 cb-idi-ind-pagto
           i-ind-pagto-aux = {cxinc/i02cx404.i 06 cb-idi-ind-pagto}.

    IF  i-ind-pagto-aux = 4 /* Sem Cobertura */ THEN do: 
        RUN pi-elimina-todas-parcelas.

        ENABLE  tt-decla-import-adic.cdn-motivo WITH FRAME fPage7.
        
        ASSIGN tt-decla-import-adic.cdn-modal-pagto:screen-value    IN FRAME fPage7 = '00'
               tt-decla-import-adic.cdn-corretor:screen-value       IN FRAME fPage7 = '0'
               tt-decla-import-adic.cdn-banco:screen-value          IN FRAME fPage7 = '0'
               tt-decla-import-adic.log-moed-nac:CHECKED            IN FRAME fPage7 = NO
               tt-decla-import-adic.cdn-praca:screen-value          IN FRAME fPage7 = '0'
               tt-decla-import-adic.cod-contrat-cambio:screen-value IN FRAME fPage7 = ""
               tt-decla-import-adic.cdn-agent:screen-value          IN FRAME fPage7 = '0000'
               tt-decla-import-adic.cdn-bco-agent:screen-value      IN FRAME fPage7 = '000'
               tt-decla-import-adic.cod-agenc-agent:screen-value    IN FRAME fPage7 = ""
               tt-decla-import-adic.cod-rof:screen-value            IN FRAME fPage7 = "".

        APPLY 'LEAVE' TO tt-decla-import-adic.cdn-corretor     IN FRAME fPage7.
        APPLY 'LEAVE' TO tt-decla-import-adic.cdn-agent        IN FRAME fPage7.

        DISABLE brParcelas btAddParcela btCanParcela btSaveParcela btDelParcela tt-decla-import-adic.cdn-modal-pagto tt-decla-import-adic.cdn-corretor tt-decla-import-adic.cdn-banco tt-decla-import-adic.log-moed-nac tt-decla-import-adic.cdn-praca 
                tt-decla-import-adic.cod-contrat-cambio tt-decla-import-adic.cdn-agent tt-decla-import-adic.cdn-bco-agent tt-decla-import-adic.cod-agenc-agent tt-decla-import-adic.cod-rof WITH FRAME fPage7.
    END. /* IF  i-ind-pagto-aux = 4 */
    ELSE do: 

        /* desabilita campo n§ ROF */
        IF  i-ind-pagto-aux = 3 THEN DO:
            /*FIND FIRST embarque-imp
                    WHERE embarque-imp.cod-estabel = tt-decla-import.cod-estab
                    AND   embarque-imp.embarque = NO-LOCK NO-ERROR.           */
            ASSIGN tt-decla-import-adic.cod-rof:screen-value IN FRAME fPage7 = "".
            ENABLE tt-decla-import-adic.cod-rof
                WITH FRAME fPage7.
        END.
        ELSE DO:
            ASSIGN tt-decla-import-adic.cod-rof:screen-value IN FRAME fPage7 = "".
            DISABLE tt-decla-import-adic.cod-rof
                WITH FRAME fPage7.
        END.
        /* fim - desabilita campo n§ ROF */

        RUN pi-habilita-campos.
        ASSIGN tt-decla-import-adic.cdn-motivo:SCREEN-VALUE IN FRAME fPage7 = '00'.
        DISABLE tt-decla-import-adic.cdn-motivo WITH FRAME fPage7.
        
        
        ENABLE brParcelas tt-decla-import-adic.cdn-modal-pagto tt-decla-import-adic.log-moed-nac
               tt-decla-import-adic.cdn-agent tt-decla-import-adic.cdn-bco-agent tt-decla-import-adic.cod-agenc-agent WITH FRAME fPage7.

        /*---[ Parcelas ]---------------------------------------------------------*/
        /* evitar que os botoes de confirmar e cancelar sejam desabilitados quando troca o tipo do pagamento*/
        RUN pi-canc-parcela. 
        IF  AVAIL tt-decla-import-adic-parc-aux THEN DO: 
            ENABLE btAddParcela btDelParcela WITH FRAME fPage7.
            DISABLE btCanParcela btSaveParcela WITH FRAME fPage7.
        END.
        ELSE DO:
            ENABLE btAddParcela WITH FRAME fPage7.
            DISABLE btDelParcela btCanParcela btSaveParcela WITH FRAME fPage7.
        END.
    END. /* ELSE do: */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionRecordSon wMaintenanceNoNavigation 
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
        WHEN 4 THEN DO:
            RUN pi-busca-itens.
        END.
        WHEN 8 THEN DO:
            RUN pi-busca-despesas.
        END.
    END CASE.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
    ASSIGN tt-decla-import-adic.num-di-ems = tt-decla-import.num-di-ems.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDesc wMaintenanceNoNavigation 
FUNCTION fnDesc RETURNS CHARACTER
  ( c-cod-item as character ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var c-descricao as character format 'x(40)' no-undo.

    run retornaDescItem in h-bocx404 (input c-cod-item, output c-descricao).

    return c-descricao.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescAtributo wMaintenanceNoNavigation 
FUNCTION fnDescAtributo RETURNS CHARACTER
  (   pNivel       AS INT,
      pCodIdent    AS CHAR,
      pCodAtributo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR p-desc-atributo LIKE nve-atrib.des-atributo NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx398) THEN
        RUN cxbo/bocx398.p PERSISTENT SET h-bocx398.

    RUN openQueryStatic IN h-bocx398 (INPUT 'Main':U).

    RUN goToKey IN h-bocx398 (INPUT pNivel,
                              INPUT pCodIdent,
                              INPUT pCodAtributo).
    IF RETURN-VALUE = "OK":U THEN
        RUN getCharField IN h-bocx398 (INPUT 'des-atributo',
                                       OUTPUT p-desc-atributo).
    ELSE
        ASSIGN p-desc-atributo = "".




  RETURN p-desc-atributo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescDespes wMaintenanceNoNavigation 
FUNCTION fnDescDespes RETURNS CHARACTER
  ( pCodDespes AS INT ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR pDescDespes LIKE desp-imp.descricao NO-UNDO.

    /* verifica descri‡Æo da despesa no embarque */
    FOR EACH decla-import-embarq FIELDS(cod-embarq) NO-LOCK 
       WHERE decla-import-embarq.num-di-ems       = tt-decla-import.num-di-ems
       AND   decla-import-embarq.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts:
    
        IF CAN-FIND(FIRST desp-embarque
                    WHERE desp-embarque.cod-estabel = tt-decla-import.cod-estab
                    AND   desp-embarque.embarque    = decla-import-embarq.cod-embarq
                    AND   desp-embarque.cod-desp    = pCodDespes ) THEN DO:
            FOR FIRST desp-embarque FIELDS (descricao)
                WHERE desp-embarque.cod-estabel = tt-decla-import.cod-estab
                 AND desp-embarque.embarque    = decla-import-embarq.cod-embarq
                 AND desp-embarque.cod-desp    = pCodDespes:
                IF  desp-embarque.descricao <> "":U THEN
                    RETURN desp-embarque.descricao.
            END.
        END.
    END.

    FOR FIRST desp-imp FIELDS(descricao)
        WHERE desp-imp.cod-desp = pCodDespes NO-LOCK:
        ASSIGN pDescDespes = desp-imp.descricao.
    END.
  
    RETURN pDescDespes.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescEspecif wMaintenanceNoNavigation 
FUNCTION fnDescEspecif RETURNS CHARACTER
  ( pNivel       AS INT,
    pCodIdent    AS CHAR,
    pCodAtributo AS CHAR,
    pCodEspecif  AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR p-desc-especif LIKE nve-especif.des-especif NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx397) THEN
        RUN cxbo/bocx397.p PERSISTENT SET h-bocx397.

    RUN openQueryStatic IN h-bocx397 (INPUT 'Main':U).

    RUN goToKey IN h-bocx397 (INPUT pNivel,
                              INPUT pCodIdent,
                              INPUT pCodAtributo,
                              INPUT pCodEspecif).
    IF RETURN-VALUE = "OK":U THEN
        RUN getCharField IN h-bocx397 (INPUT 'des-especif',
                                       OUTPUT p-desc-especif).
    ELSE
        ASSIGN p-desc-especif = "".
                                                        
  RETURN p-desc-especif.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNivel wMaintenanceNoNavigation 
FUNCTION fnNivel RETURNS CHARACTER
  ( pCodNivel AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR pNomeNivel AS CHAR FORMAT "X(256)".
  
  /* ASSIGN pNomeNivel = STRING({cxinc/i01cx399.i 06 pNivel}). */
  IF pCodNivel >= 1 AND pCodNivel <= 6 THEN
      ASSIGN pNomeNivel = {cxinc/i01cx399.i 04 pCodNivel}.
  
  RETURN pNomeNivel.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeFornec wMaintenanceNoNavigation 
FUNCTION fnNomeFornec RETURNS CHARACTER
  ( pCodFornec AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR pNomeFornec LIKE emitente.nome-abrev NO-UNDO.

  FIND FIRST emitente 
            WHERE emitente.cod-emitente = pCodFornec NO-LOCK NO-ERROR.
  ASSIGN pNomeFornec = emitente.nome-abrev WHEN AVAIL emitente.

  RETURN pNomeFornec.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeMoeda wMaintenanceNoNavigation 
FUNCTION fnNomeMoeda RETURNS CHARACTER
  ( pCodMoeda AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR pNomeMoeda LIKE moeda.descricao NO-UNDO.

  FIND FIRST moeda 
            WHERE moeda.mo-codigo = pCodMoeda NO-LOCK NO-ERROR.
  ASSIGN pNomeMoeda = moeda.descricao WHEN AVAIL moeda.

  RETURN pNomeMoeda.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUN wMaintenanceNoNavigation 
FUNCTION fnUN RETURNS CHARACTER
  ( c-cod-item as character ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var c-un as character format 'x(40)' no-undo.

    run retornaUnidMed in h-bocx404 (input c-cod-item, output c-un).
    return c-un.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

