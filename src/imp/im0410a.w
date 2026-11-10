&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-decla-import-adic NO-UNDO LIKE decla-import-adic
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-ord NO-UNDO LIKE decla-import-ord
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-ord-trib NO-UNDO LIKE decla-import-ord-trib
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-licenciam-import-oc NO-UNDO LIKE licenciam-import-oc
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-licenciam-import-oc-aux NO-UNDO LIKE licenciam-import-oc
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-ordens-embarque NO-UNDO LIKE ordens-embarque
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
{include/i-prgvrs.i IM0410A 2.00.00.051 } /*** "010051" 15/07/2026 13:37:33 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0410A MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM0410A
&GLOBAL-DEFINE Version        2.00.00.051

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Principal, Fiscal, Financeiro, Impostos, Impostos 2, Especificaá∆o

&GLOBAL-DEFINE ttTable           tt-decla-import-ord
&GLOBAL-DEFINE hDBOTable         h-bocx404
&GLOBAL-DEFINE DBOTable          decla-import-ord

&GLOBAL-DEFINE ttParent          tt-decla-import
&GLOBAL-DEFINE DBOParentTable    decla-import

&GLOBAL-DEFINE page0KeyFields tt-decla-import-ord.cod-estab tt-decla-import-ord.num-ordem tt-decla-import-ord.num-adic tt-decla-import-ord.cod-embarq tt-decla-import-ord.num-parcela 
&GLOBAL-DEFINE page0Fields 
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields tt-decla-import-ord.cdn-fornec tt-decla-import-ord.log-emite-fabrican tt-decla-import-ord.cdn-fabrican tt-decla-import-ord.cdn-pais-proceden tt-decla-import-ord.cod-item tt-decla-import-ord.qtd-item tt-decla-import-ord.cod-unid-med-fornec /*tt-decla-import-ord.cod-especif*/ tt-decla-import-ord.qtd-fornec tt-decla-import-ord.cod-unid-medid-item tt-decla-import-ord.val-peso-liq tt-decla-import-ord.val-peso-brut-merc tt-decla-import-ord.val-cub-tot val-peso-liq-unit val-peso-brut-unit
&GLOBAL-DEFINE page2Fields c-cod-class-fisc c-class-fisc-ex d-desc-class tt-decla-import-ord.cdn-naladi-sist-harmon tt-decla-import-ord.cod-naladi-ncca tt-decla-import-ord.cod-nbm tt-decla-import-ord.cod-licenc-import tt-decla-import-ord.dat-livre-1 tt-decla-import-ord.cod-aladi c-cod-incoterm c-desc-incoterm c-desc-nat-op tt-decla-import-ord.cod-tip-recip tt-decla-import-ord.qtd-capac-recip tt-decla-import-ord.cod-natur-operac
&GLOBAL-DEFINE page3Fields d-val-vucv i-cdn-moed-vucv cb-idi-metod-val cb-idi-ind-pagto
&GLOBAL-DEFINE page4Fields cb-suspens-impto-import cb-suspens-ipi-import cb-suspens-icms cb-suspens-pis cb-suspens-cofins cb-idi-tributac-impto-import tt-decla-import-ord.val-aliq-ii tt-decla-import-ord.val-perc-reduc-impto-import cb-idi-tributac-ipi tt-decla-import-ord.val-aliq-ipi tt-decla-import-ord.val-perc-reduc-ipi tt-decla-import-ord.val-unit-ipi cb-idi-tributac-icms tt-decla-import-ord.val-aliq-icms tt-decla-import-ord.val-perc-reduc-icms cb-idi-tributac-pis tt-decla-import-ord.val-aliq-pis tt-decla-import-ord.val-perc-reduc-pis tt-decla-import-ord.val-unit-pis cb-idi-tributac-cofins tt-decla-import-ord.val-aliq-cofins tt-decla-import-ord.val-perc-reduc-cofins tt-decla-import-ord.val-unit-cofins 

&GLOBAL-DEFINE page5Fields cb-idi-tributac-ibs-uf de-aliq-ibs-uf de-aliq-red-ibs-uf c-cst-ibs-uf c-class-trib-ibs-uf ~
                           cb-idi-tributac-ibs-mun de-aliq-ibs-mun de-aliq-red-ibs-mun c-cst-ibs-mun c-class-trib-ibs-mun ~
                           cb-idi-tributac-cbs de-aliq-cbs de-aliq-red-cbs c-cst-cbs c-class-trib-cbs ~
                           cb-idi-tributac-is c-class-trib-is c-cst-is de-aliq-is de-aliq-un-is de-qtde-trib-is c-un-trib-is ~
                           c-class-trib-ibs-uf-reg c-cst-ibs-uf-reg c-class-trib-ibs-mun-reg c-cst-ibs-mun-reg c-cst-cbs-reg c-class-trib-cbs-reg

&GLOBAL-DEFINE page6Fields tt-decla-import-ord.cod-especif 

{utp/ut-glob.i}
{cdp/cdcfgmat.i}                        /* Include Pre-processadores */

{cxbo/bocx404.i tt-decla-import-ord-aux}
{cxbo/bocx00507.i tt-decla-import-ord-trib-aux}
{imp/imapi017.i}  /*tt-tributo-import*/

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.


/* Local Variable Definitions ---                                       */
DEFINE VARIABLE i-cdn-fabrican     LIKE decla-import-ord.cdn-fabrican NO-UNDO.
DEFINE VARIABLE i-num-linha-browse AS INTEGER NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad098      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx403      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx407      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boun006      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin172na    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin245      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boun005      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx351      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx225e     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx225      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx383      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx383a     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00507    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-imapi017     AS HANDLE NO-UNDO.

DEFINE VARIABLE c-numeroLI-aux LIKE {&ttTable}.cod-licenc-import NO-UNDO.
DEFINE VARIABLE dt-restric-emb LIKE {&ttTable}.dat-livre-1 NO-UNDO.

/* Programa de pesquisa */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.

DEFINE VARIABLE l-atualiza-campo         AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE i-nr-registro            AS INTEGER                         NO-UNDO.
DEFINE VARIABLE c-return                 AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE c-descItem-aux           LIKE item.desc-item                NO-UNDO.
DEFINE VARIABLE d-qtde-item              LIKE reg-export-item.qtd-unid-item NO-UNDO.
DEFINE VARIABLE c-un-item                LIKE item.un                       NO-UNDO.
DEFINE VARIABLE c-return-nome-pais       LIKE pais.nome-pais                NO-UNDO.
DEFINE VARIABLE c-class-fisc-aux         LIKE classif-fisc.class-fiscal     NO-UNDO.
DEFINE VARIABLE i-cod-ncm-aux            AS INTEGER                         NO-UNDO.
DEFINE VARIABLE c-desc-class-aux         LIKE classif-fisc.descricao        NO-UNDO.
DEFINE VARIABLE c-incoterm-aux           LIKE embarque-imp.cod-incoterm     NO-UNDO.      
DEFINE VARIABLE c-desc-incoterm-aux      AS CHARACTER FORMAT 'x(40)'        NO-UNDO.
DEFINE VARIABLE d-vucv-forn-aux          LIKE ordem-compra.pre-unit-for     NO-UNDO.
DEFINE VARIABLE c-mo-aux                 LIKE ordem-compra.mo-codigo        NO-UNDO.
DEFINE VARIABLE d-peso-bruto             LIKE item.peso-bruto               NO-UNDO.
DEFINE VARIABLE d-peso-liquido           LIKE item.peso-liquido             NO-UNDO.
DEFINE VARIABLE l-log-necessita-li       LIKE item.log-necessita-li         NO-UNDO.
DEFINE VARIABLE iRowsReturned            AS INTEGER                         NO-UNDO.
DEFINE VARIABLE vRowidAuxiliar           AS ROWID                           NO-UNDO.
DEFINE VARIABLE rRowid                   AS ROWID                           NO-UNDO.
DEFINE VARIABLE cReturn                  AS CHAR                            NO-UNDO.
DEFINE VARIABLE cClassTrib               LIKE relac-class-trib.cod-cclass-trib NO-UNDO.
DEFINE VARIABLE cCST                     LIKE relac-class-trib.cod-cst         NO-UNDO.
DEFINE VARIABLE cClassTrib-reg           LIKE relac-class-trib.cod-cclass-trib NO-UNDO.
DEFINE VARIABLE cCST-reg                 LIKE relac-class-trib.cod-cst         NO-UNDO.
DEFINE VARIABLE i-trib-cbs               AS INTEGER                         NO-UNDO.
DEFINE VARIABLE i-trib-ibs-uf            AS INTEGER                         NO-UNDO.
    
DEFINE VARIABLE l-quebra-alterada        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-encontrou              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-alt-pesos              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cPagamentoAnterior       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lAlterouPagamento        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i-situacao-integ-desp    AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-char-param-imp         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-nt2024002              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i-reg-retornados         AS INTEGER    NO-UNDO.
                                 
/* Reforma Tribut†ria */                                 
ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-nt2024002":U AND funcao.ativo).

{include/boerrtab.i} /* tt-bo-erro */
{imp/im0410a.i} /* Definiá‰es necess†rias para o folder Impostos */

{imp/im0410a.i2} /* define a temp-table tt-campos-quebra */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-decla-import-ord.cod-estab ~
tt-decla-import-ord.num-ordem tt-decla-import-ord.num-adic ~
tt-decla-import-ord.cod-embarq tt-decla-import-ord.num-parcela 
&Scoped-define DISPLAYED-TABLES tt-decla-import-ord
&Scoped-define FIRST-DISPLAYED-TABLE tt-decla-import-ord
&Scoped-Define DISPLAYED-OBJECTS c-registro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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
     SIZE 89 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btRecarregaPeso 
     IMAGE-UP FILE "image/im-undo":U
     IMAGE-INSENSITIVE FILE "image/ii-undo":U
     LABEL "" 
     SIZE 5.14 BY 1 TOOLTIP "Recarregar Pesos".

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-pais-origem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-fabrican AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE val-peso-brut-unit AS DECIMAL FORMAT ">>>,>>>,>>9.99999" INITIAL 0 
     LABEL "Peso Bruto Unit" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE val-peso-liq-unit AS DECIMAL FORMAT ">>>,>>>,>>9.99999" INITIAL 0 
     LABEL "Peso Liquido Unit" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.42.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 6.21.

DEFINE VARIABLE c-class-fisc-ex AS CHARACTER FORMAT "X(3)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-class-fisc AS CHARACTER FORMAT "X(10)":U 
     LABEL "Classificaá∆o Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-incoterm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Incoterm" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-incoterm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-nat-op AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.14 BY .88 NO-UNDO.

DEFINE VARIABLE d-desc-class AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 8.33.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.5.

DEFINE VARIABLE cb-idi-ind-pagto AS CHARACTER FORMAT "X(256)" 
     LABEL "Pagamento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-metod-val AS CHARACTER FORMAT "X(256)" 
     LABEL "MÇtodo Valoraá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-moeda-vucv AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 14.43 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-vucv AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" INITIAL 0 
     LABEL "VUCV Forn" 
     VIEW-AS FILL-IN 
     SIZE 18.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-moed-vucv AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Moeda" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.33.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.58.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.42.

DEFINE BUTTON btRecarImpostos 
     LABEL "Recarregar Impostos" 
     SIZE 28 BY 1.

DEFINE VARIABLE cb-idi-tributac-cofins AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-icms AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-impto-import AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-ipi AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-pis AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-cofins AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","N∆o" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-icms AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","N∆o" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-impto-import AS CHARACTER FORMAT "X(256)":U INITIAL "N∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","N∆o" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-ipi-import AS CHARACTER FORMAT "X(256)":U INITIAL "N∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","N∆o" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-pis AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","N∆o" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE label-aliquota AS CHARACTER FORMAT "X(256)":U INITIAL "Al°quota" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE label-cofins AS CHARACTER FORMAT "X(256)":U INITIAL "COFINS" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE label-icms AS CHARACTER FORMAT "X(256)":U INITIAL "ICMS" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE label-ii AS CHARACTER FORMAT "X(256)":U INITIAL "II" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE label-ipi AS CHARACTER FORMAT "X(256)":U INITIAL "IPI" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE label-pis AS CHARACTER FORMAT "X(256)":U INITIAL "PIS" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE label-reducao AS CHARACTER FORMAT "X(256)":U INITIAL "Reduá∆o" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE label-suspenso AS CHARACTER FORMAT "X(256)":U INITIAL "Suspenso" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE label-tributacao AS CHARACTER FORMAT "X(256)":U INITIAL "Tributaá∆o" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE label-vl-unit AS CHARACTER FORMAT "X(256)":U INITIAL "Vl. Unit. Imp." 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 10.5.

DEFINE BUTTON btRecImpostosRT 
     LABEL "Recarregar Impostos" 
     SIZE 28 BY 1.

DEFINE VARIABLE cb-idi-tributac-cbs AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-ibs-mun AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-ibs-uf AS CHARACTER FORMAT "X(256)" 
     LABEL "Tributaá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE cb-idi-tributac-is AS CHARACTER FORMAT "X(256)" 
     LABEL "Tributaá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-cbs AS CHARACTER FORMAT "X(256)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-class-trib-cbs-reg AS CHARACTER FORMAT "X(256)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-class-trib-ibs-mun AS CHARACTER FORMAT "X(256)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-class-trib-ibs-mun-reg AS CHARACTER FORMAT "X(256)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-class-trib-ibs-uf AS CHARACTER FORMAT "X(256)" 
     LABEL "Class Trib" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-class-trib-ibs-uf-reg AS CHARACTER FORMAT "X(256)" 
     LABEL "Class Trib" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-class-trib-is AS CHARACTER FORMAT "X(256)" 
     LABEL "Class Trib" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE c-cst-cbs AS CHARACTER FORMAT "X(256)" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE c-cst-cbs-reg AS CHARACTER FORMAT "X(256)" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE c-cst-ibs-mun AS CHARACTER FORMAT "X(256)" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE c-cst-ibs-mun-reg AS CHARACTER FORMAT "X(256)" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE c-cst-ibs-uf AS CHARACTER FORMAT "X(256)" 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE c-cst-ibs-uf-reg AS CHARACTER FORMAT "X(256)" 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE c-cst-is AS CHARACTER FORMAT "X(256)" 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE c-un-trib-is AS CHARACTER FORMAT "X(256)" 
     LABEL "Un Tribut†vel" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE de-aliq-cbs AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-aliq-cbs-reg AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-aliq-ibs-mun AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-aliq-ibs-mun-reg AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-aliq-ibs-uf AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Al°quota" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-aliq-ibs-uf-reg AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Al°quota" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-aliq-is AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Al°quota" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-aliq-red-cbs AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-aliq-red-ibs-mun AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-aliq-red-ibs-uf AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Reduá∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-aliq-red-ibs-uf-2 AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Reduá∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-aliq-un-is AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Aliq Espec Un" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE de-qtde-trib-is AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Qtde Tribut†vel" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE label-cbs AS CHARACTER FORMAT "X(256)":U INITIAL "CBS" 
      VIEW-AS TEXT 
     SIZE 5 BY .67 NO-UNDO.

DEFINE VARIABLE label-ibs AS CHARACTER FORMAT "X(256)":U INITIAL "IBS UF" 
      VIEW-AS TEXT 
     SIZE 5 BY .67 NO-UNDO.

DEFINE VARIABLE label-ibs-mun AS CHARACTER FORMAT "X(256)":U INITIAL "IBS Mun" 
      VIEW-AS TEXT 
     SIZE 6.86 BY .67 NO-UNDO.

DEFINE VARIABLE label-is AS CHARACTER FORMAT "X(256)":U INITIAL "IS" 
      VIEW-AS TEXT 
     SIZE 2 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 3.5.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26 BY 7.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-decla-import-ord.cod-estab AT ROW 1.25 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-decla-import-ord.num-ordem AT ROW 1.25 COL 41.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-decla-import-ord.num-adic AT ROW 1.25 COL 73 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-decla-import-ord.cod-embarq AT ROW 2.25 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-decla-import-ord.num-parcela AT ROW 2.25 COL 41.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-registro AT ROW 2.25 COL 73 COLON-ALIGNED
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     bt-pre AT ROW 16.63 COL 52 HELP
          "Ocorrància anterior"
     bt-nex AT ROW 16.63 COL 56.43 HELP
          "Pr¢xima ocorrància"
     btHelp AT ROW 16.63 COL 80
     rtKeys AT ROW 1.13 COL 1.57
     rtToolBar AT ROW 16.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 17
         FONT 1.

DEFINE FRAME fPage5
     cb-idi-tributac-ibs-uf AT ROW 2.08 COL 12 COLON-ALIGNED HELP
          "C¢digo de tributaá∆o IBS UF" WIDGET-ID 6
     de-aliq-ibs-uf AT ROW 3.08 COL 12 COLON-ALIGNED WIDGET-ID 34
     de-aliq-red-ibs-uf AT ROW 4.08 COL 12 COLON-ALIGNED WIDGET-ID 40
     c-class-trib-ibs-uf AT ROW 5.08 COL 12 COLON-ALIGNED WIDGET-ID 56
     c-cst-ibs-uf AT ROW 6.08 COL 12 COLON-ALIGNED WIDGET-ID 50
     de-aliq-ibs-uf-reg AT ROW 7.79 COL 12 COLON-ALIGNED WIDGET-ID 64
     c-class-trib-ibs-uf-reg AT ROW 8.79 COL 12 COLON-ALIGNED WIDGET-ID 68
     c-cst-ibs-uf-reg AT ROW 9.79 COL 12 COLON-ALIGNED WIDGET-ID 72
     cb-idi-tributac-ibs-mun AT ROW 2.08 COL 26 COLON-ALIGNED HELP
          "C¢digo de tributaá∆o IBS Mun" NO-LABEL WIDGET-ID 102
     de-aliq-ibs-mun AT ROW 3.08 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 104
     de-aliq-red-ibs-mun AT ROW 4.08 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 106
     c-class-trib-ibs-mun AT ROW 5.08 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 98
     c-cst-ibs-mun AT ROW 6.08 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 100
     de-aliq-ibs-mun-reg AT ROW 7.79 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 94
     c-class-trib-ibs-mun-reg AT ROW 8.79 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     c-cst-ibs-mun-reg AT ROW 9.79 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     btRecImpostosRT AT ROW 10.96 COL 27 WIDGET-ID 2
     cb-idi-tributac-cbs AT ROW 2.08 COL 41 COLON-ALIGNED HELP
          "C¢digo de Tributaá∆o CBS" NO-LABEL WIDGET-ID 8
     de-aliq-cbs AT ROW 3.08 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     de-aliq-red-cbs AT ROW 4.08 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     c-class-trib-cbs AT ROW 5.08 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     c-cst-cbs AT ROW 6.08 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     de-aliq-cbs-reg AT ROW 7.79 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     c-class-trib-cbs-reg AT ROW 8.79 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     c-cst-cbs-reg AT ROW 9.79 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     cb-idi-tributac-is AT ROW 2 COL 69 COLON-ALIGNED HELP
          "C¢digo de tributaá∆o IS" WIDGET-ID 132
     de-aliq-is AT ROW 3 COL 69 COLON-ALIGNED WIDGET-ID 134
     de-aliq-red-ibs-uf-2 AT ROW 4 COL 69 COLON-ALIGNED WIDGET-ID 136
     de-aliq-un-is AT ROW 4 COL 69 COLON-ALIGNED WIDGET-ID 142
     de-qtde-trib-is AT ROW 5 COL 69 COLON-ALIGNED WIDGET-ID 144
     c-un-trib-is AT ROW 6 COL 69 COLON-ALIGNED WIDGET-ID 146
     c-class-trib-is AT ROW 7 COL 69 COLON-ALIGNED WIDGET-ID 128
     c-cst-is AT ROW 8 COL 69 COLON-ALIGNED WIDGET-ID 130
     label-ibs AT ROW 1.25 COL 14.57 NO-LABEL WIDGET-ID 20
     label-ibs-mun AT ROW 1.25 COL 28.57 NO-LABEL WIDGET-ID 108
     label-cbs AT ROW 1.25 COL 43.57 NO-LABEL WIDGET-ID 22
     label-is AT ROW 1.25 COL 60 NO-LABEL WIDGET-ID 140
     "Tributaá∆o Regular" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 7.08 COL 3 WIDGET-ID 112
     RECT-12 AT ROW 7.33 COL 2 WIDGET-ID 110
     RECT-13 AT ROW 1.75 COL 58 WIDGET-ID 114
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.71
         SIZE 84.43 BY 11.29
         FONT 1.

DEFINE FRAME fPage4
     cb-idi-tributac-impto-import AT ROW 3.25 COL 14 COLON-ALIGNED HELP
          "Informar a Tributaá∆o do Imposto de Importaá∆o" NO-LABEL
     tt-decla-import-ord.val-aliq-ii AT ROW 3.25 COL 31 COLON-ALIGNED NO-LABEL FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-decla-import-ord.val-perc-reduc-impto-import AT ROW 3.25 COL 42 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cb-suspens-impto-import AT ROW 3.25 COL 53 COLON-ALIGNED NO-LABEL
     cb-idi-tributac-ipi AT ROW 4.25 COL 14 COLON-ALIGNED HELP
          "C¢digo de tributaá∆o do IPI" NO-LABEL
     tt-decla-import-ord.val-aliq-ipi AT ROW 4.25 COL 31 COLON-ALIGNED NO-LABEL FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-decla-import-ord.val-perc-reduc-ipi AT ROW 4.25 COL 42 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cb-suspens-ipi-import AT ROW 4.25 COL 53 COLON-ALIGNED NO-LABEL
     tt-decla-import-ord.val-unit-ipi AT ROW 4.25 COL 64 COLON-ALIGNED NO-LABEL FORMAT "->>,>>>,>>>,>>9.99999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cb-idi-tributac-icms AT ROW 5.25 COL 14 COLON-ALIGNED HELP
          "C¢digo de tributaá∆o do ICMS" NO-LABEL
     tt-decla-import-ord.val-aliq-icms AT ROW 5.25 COL 31 COLON-ALIGNED NO-LABEL FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-decla-import-ord.val-perc-reduc-icms AT ROW 5.25 COL 42 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cb-suspens-icms AT ROW 5.25 COL 53 COLON-ALIGNED NO-LABEL
     cb-idi-tributac-pis AT ROW 6.25 COL 14 COLON-ALIGNED HELP
          "C¢digo de Tributaá∆o PIS" NO-LABEL
     tt-decla-import-ord.val-aliq-pis AT ROW 6.25 COL 31 COLON-ALIGNED NO-LABEL FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-decla-import-ord.val-perc-reduc-pis AT ROW 6.25 COL 42 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cb-suspens-pis AT ROW 6.25 COL 53 COLON-ALIGNED NO-LABEL
     tt-decla-import-ord.val-unit-pis AT ROW 6.25 COL 64 COLON-ALIGNED NO-LABEL FORMAT "->>,>>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cb-idi-tributac-cofins AT ROW 7.25 COL 14 COLON-ALIGNED HELP
          "C¢digo de Tributaá∆o COFINS" NO-LABEL
     tt-decla-import-ord.val-aliq-cofins AT ROW 7.25 COL 31 COLON-ALIGNED NO-LABEL FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-decla-import-ord.val-perc-reduc-cofins AT ROW 7.25 COL 42 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cb-suspens-cofins AT ROW 7.25 COL 53 COLON-ALIGNED NO-LABEL
     tt-decla-import-ord.val-unit-cofins AT ROW 7.25 COL 64 COLON-ALIGNED NO-LABEL FORMAT "->>,>>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     btRecarImpostos AT ROW 9 COL 30
     label-tributacao AT ROW 2.25 COL 16 COLON-ALIGNED NO-LABEL
     label-aliquota AT ROW 2.25 COL 32 COLON-ALIGNED NO-LABEL
     label-reducao AT ROW 2.25 COL 43 COLON-ALIGNED NO-LABEL
     label-suspenso AT ROW 2.25 COL 54 COLON-ALIGNED NO-LABEL
     label-vl-unit AT ROW 2.25 COL 65 COLON-ALIGNED NO-LABEL
     label-ii AT ROW 3.25 COL 7 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 4.7
         SIZE 84.43 BY 11
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage4
     label-ipi AT ROW 4.25 COL 7 COLON-ALIGNED NO-LABEL
     label-icms AT ROW 5.25 COL 7 COLON-ALIGNED NO-LABEL
     label-pis AT ROW 6.25 COL 7 COLON-ALIGNED NO-LABEL
     label-cofins AT ROW 7.25 COL 7 COLON-ALIGNED NO-LABEL
     RECT-9 AT ROW 1.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 4.7
         SIZE 84.43 BY 11
         FONT 1.

DEFINE FRAME fPage6
     tt-decla-import-ord.cod-especif AT ROW 2 COL 2 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 82 BY 9.75
     "Especificaá∆o:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 1.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.71
         SIZE 84.43 BY 11
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-decla-import-ord.cdn-fornec AT ROW 1.42 COL 14 COLON-ALIGNED
          LABEL "Fornecedor"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-nome-fornec AT ROW 1.42 COL 25.14 COLON-ALIGNED NO-LABEL
     tt-decla-import-ord.log-emite-fabrican AT ROW 2.71 COL 16
          LABEL "Fornecedor Ç Fabricante?"
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .63
     tt-decla-import-ord.cdn-fabrican AT ROW 3.5 COL 14 COLON-ALIGNED
          LABEL "Fabricante"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-nome-fabrican AT ROW 3.5 COL 25.14 COLON-ALIGNED NO-LABEL
     tt-decla-import-ord.cdn-pais-proceden AT ROW 4.5 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-desc-pais-origem AT ROW 4.5 COL 25.14 COLON-ALIGNED NO-LABEL
     tt-decla-import-ord.cod-item AT ROW 5.71 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     c-desc-item AT ROW 5.71 COL 32.14 COLON-ALIGNED NO-LABEL
     tt-decla-import-ord.qtd-item AT ROW 6.71 COL 14 COLON-ALIGNED
          LABEL "Quantidade"
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-decla-import-ord.cod-unid-medid-item AT ROW 6.71 COL 29.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-decla-import-ord.qtd-fornec AT ROW 7.71 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-decla-import-ord.cod-unid-med-fornec AT ROW 7.71 COL 29.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-decla-import-ord.val-peso-liq AT ROW 8.71 COL 14 COLON-ALIGNED
          LABEL "Peso L°quido (Kg)" FORMAT "->>,>>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     val-peso-liq-unit AT ROW 8.71 COL 53.57 COLON-ALIGNED HELP
          "Peso l°quido"
     tt-decla-import-ord.val-peso-brut-merc AT ROW 9.71 COL 14 COLON-ALIGNED
          LABEL "Peso Bruto (Kg)" FORMAT "->>,>>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     val-peso-brut-unit AT ROW 9.75 COL 53.57 COLON-ALIGNED HELP
          "Valor Peso Bruto Mercadoria (Kg)"
     btRecarregaPeso AT ROW 10.67 COL 55.57
     tt-decla-import-ord.val-cub-tot AT ROW 10.71 COL 14 COLON-ALIGNED
          LABEL "Cubagem (m¸)"
          VIEW-AS FILL-IN 
          SIZE 19 BY .88
     RECT-1 AT ROW 1.17 COL 2
     RECT-3 AT ROW 5.54 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.71
         SIZE 84.43 BY 11
         FONT 1.

DEFINE FRAME fPage2
     c-cod-class-fisc AT ROW 1.5 COL 14.72 COLON-ALIGNED
     c-class-fisc-ex AT ROW 1.5 COL 26.86 COLON-ALIGNED NO-LABEL
     d-desc-class AT ROW 1.5 COL 31 COLON-ALIGNED NO-LABEL
     tt-decla-import-ord.cdn-naladi-sist-harmon AT ROW 2.5 COL 14.72 COLON-ALIGNED
          LABEL "Naladi/SH"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-decla-import-ord.cod-naladi-ncca AT ROW 3.5 COL 14.72 COLON-ALIGNED
          LABEL "Naladi NCCA"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-decla-import-ord.cod-nbm AT ROW 4.5 COL 14.72 COLON-ALIGNED
          LABEL "NBM"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-decla-import-ord.cod-licenc-import AT ROW 5.5 COL 14.72 COLON-ALIGNED
          LABEL "Nr. LI"
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     tt-decla-import-ord.dat-livre-1 AT ROW 5.5 COL 71.14 COLON-ALIGNED HELP
          "Atributo livre para uso interno" WIDGET-ID 2
          LABEL "Dt Restriá∆o Embarque" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 9.86 BY .88
     tt-decla-import-ord.cod-aladi AT ROW 6.5 COL 14.72 COLON-ALIGNED
          LABEL "Acordo ALADI"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-cod-incoterm AT ROW 7.5 COL 14.72 COLON-ALIGNED
     c-desc-incoterm AT ROW 7.5 COL 19.86 COLON-ALIGNED NO-LABEL
     tt-decla-import-ord.cod-natur-operac AT ROW 8.5 COL 14.72 COLON-ALIGNED
          LABEL "Natureza Operaá∆o"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-nat-op AT ROW 8.5 COL 22.86 COLON-ALIGNED NO-LABEL
     tt-decla-import-ord.cod-tip-recip AT ROW 10 COL 14.72 COLON-ALIGNED
          LABEL "Tipo Recipiente"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     tt-decla-import-ord.qtd-capac-recip AT ROW 10 COL 54 COLON-ALIGNED
          LABEL "Capacidade Recipiente (ml)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     RECT-4 AT ROW 1.5 COL 2
     RECT-5 AT ROW 9.75 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 4.7
         SIZE 84.43 BY 11
         FONT 1.

DEFINE FRAME fPage3
     d-val-vucv AT ROW 1.5 COL 14.29 COLON-ALIGNED
     i-cdn-moed-vucv AT ROW 2.5 COL 14.29 COLON-ALIGNED
     c-desc-moeda-vucv AT ROW 2.5 COL 18.43 COLON-ALIGNED NO-LABEL
     cb-idi-metod-val AT ROW 4 COL 14 COLON-ALIGNED HELP
          "MÇtodo Valoraá∆o"
     cb-idi-ind-pagto AT ROW 5.75 COL 14 COLON-ALIGNED HELP
          "Indicativo Pagamento"
     RECT-6 AT ROW 1.25 COL 2
     RECT-7 AT ROW 3.75 COL 2
     RECT-8 AT ROW 5.5 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 4.7
         SIZE 84.43 BY 11
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
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-decla-import-adic T "?" NO-UNDO mgcex decla-import-adic
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-ord T "?" NO-UNDO mgcex decla-import-ord
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-ord-trib T "?" NO-UNDO mgcex decla-import-ord-trib
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-licenciam-import-oc T "?" NO-UNDO mgcex licenciam-import-oc
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-licenciam-import-oc-aux T "?" NO-UNDO mgcex licenciam-import-oc
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-ordens-embarque T "?" NO-UNDO mgcex ordens-embarque
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
         HEIGHT             = 17
         WIDTH              = 90.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 92.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 92.14
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
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON bt-nex IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-pre IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-registro IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cod-embarq IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cod-estab IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.num-adic IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.num-ordem IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.num-parcela IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-pais-origem IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-fornec IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cdn-fabrican IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cdn-fornec IN FRAME fPage1
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cod-item IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cod-unid-medid-item IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-decla-import-ord.log-emite-fabrican IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.qtd-item IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.val-cub-tot IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.val-peso-brut-merc IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.val-peso-liq IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-desc-nat-op IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cdn-naladi-sist-harmon IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cod-aladi IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cod-licenc-import IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cod-naladi-ncca IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cod-natur-operac IN FRAME fPage2
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cod-nbm IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cod-tip-recip IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.dat-livre-1 IN FRAME fPage2
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.qtd-capac-recip IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FILL-IN c-desc-moeda-vucv IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-val-vucv IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cdn-moed-vucv IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.val-aliq-cofins IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.val-aliq-icms IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.val-aliq-ii IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.val-aliq-ipi IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.val-aliq-pis IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.val-unit-cofins IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.val-unit-ipi IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.val-unit-pis IN FRAME fPage4
   EXP-FORMAT                                                           */
/* SETTINGS FOR FRAME fPage5
   L-To-R,COLUMNS                                                       */
/* SETTINGS FOR FILL-IN label-cbs IN FRAME fPage5
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN label-ibs IN FRAME fPage5
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN label-ibs-mun IN FRAME fPage5
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN label-is IN FRAME fPage5
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage6
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage5
/* Query rebuild information for FRAME fPage5
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
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


&Scoped-define SELF-NAME bt-nex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nex wMaintenanceNoNavigation
ON CHOOSE OF bt-nex IN FRAME fpage0 /* Next */
DO:
    IF NOT l-encontrou THEN
        RUN pi-salva-registro. /* salva os registros da tela */

    EMPTY TEMP-TABLE tt-decla-import-ord        NO-ERROR.
    EMPTY TEMP-TABLE tt-decla-import-ord-trib   NO-ERROR.

    assign i-num-linha-browse = i-num-linha-browse + 1.
    if bt-pre:sensitive in frame fPage0 = no then assign bt-pre:sensitive in frame fPage0 = yes.

    RUN repositionRecord IN {&hDBOTable} (INPUT rRowid).
    RUN getNext   IN {&hDBOTable}.
    RUN getRecord IN {&hDBOTable} (OUTPUT TABLE tt-decla-import-ord).
    FIND FIRST tt-decla-import-ord NO-LOCK NO-ERROR.
    
    if l-nt2024002 THEN
        RUN piBuscaOrdTrib.
    
    RUN DisplayFields IN THIS-PROCEDURE.
    
    if  i-num-linha-browse = i-nr-registro then do:
        RUN getLast IN {&hDBOTable}.
        assign bt-nex:sensitive in frame fPage0 = no.
    end.

    IF NOT l-encontrou THEN
        RUN carrega-tt-quebra. /* recarrega a temp-table com os valores iniciais */

    RETURN "ok".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pre wMaintenanceNoNavigation
ON CHOOSE OF bt-pre IN FRAME fpage0 /* Prev */
DO:
    IF NOT l-encontrou THEN
        RUN pi-salva-registro. /* salva os registros da tela */

    EMPTY TEMP-TABLE tt-decla-import-ord        NO-ERROR.
    EMPTY TEMP-TABLE tt-decla-import-ord-trib   NO-ERROR.

    assign i-num-linha-browse = i-num-linha-browse - 1.
    if bt-nex:sensitive in frame fPage0 = no then assign bt-nex:sensitive in frame fPage0 = yes.
    
    RUN repositionRecord IN {&hDBOTable} (INPUT rRowid).
    RUN getPrev   IN {&hDBOTable}.
    RUN getRecord IN {&hDBOTable} (OUTPUT TABLE tt-decla-import-ord).
    FIND FIRST tt-decla-import-ord NO-LOCK NO-ERROR.
    
    IF l-nt2024002 THEN 
        RUN piBuscaOrdTrib.
    
    RUN DisplayFields IN THIS-PROCEDURE.

    if  i-num-linha-browse = 1 then do:
        RUN getFirst IN {&hDBOTable}.
        assign bt-pre:sensitive in frame fPage0 = no.
    end.
    
    IF NOT l-encontrou THEN
        RUN carrega-tt-quebra. /* recarrega a temp-table com os valores iniciais */

    RETURN "ok".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    
    ASSIGN vRowidAuxiliar = tt-decla-import-ord.r-Rowid.
    
    IF ((c-numeroLi-aux <> INPUT FRAME fPage2 tt-decla-import-ord.cod-licenc-import)
    OR  (dt-restric-emb <> INPUT FRAME fPage2 tt-decla-import-ord.dat-livre-1))
    AND NOT l-encontrou THEN DO:
        RUN piPergunta. /* Exporta LI? */
    END. /* IF  c-numeroLi-aux <> */

    RUN pi-saveRecord.      
    RUN repositionRecord IN {&hDBOTable} (INPUT vRowidAuxiliar).
    
    IF NOT l-encontrou THEN DO:
        RUN carrega-tt-quebra. /* recarrega a temp-table com os valores iniciais */
        RUN verifica-att-quebra. /* verifica se os campos da quebra foram modificados */
    END.
    RUN saveRecord IN THIS-PROCEDURE.

    IF RETURN-VALUE = "OK":U THEN APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btRecarImpostos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRecarImpostos wMaintenanceNoNavigation
ON CHOOSE OF btRecarImpostos IN FRAME fPage4 /* Recarregar Impostos */
DO:
    run findNatureza in {&hDBOTable} (input input frame fPage2 tt-decla-import-ord.cod-natur-operac).
    if  return-value = 'NOK':U then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Natureza_de_Operaá∆o" *}
        run utp/ut-msgs.p (input 'show', input 2, input RETURN-VALUE).
        return no-apply.
    end.
    else do:
        run setConstraint4 in h-bocx225 (input input frame fPage0 tt-decla-import-ord.cod-embarq, input input frame fPage0 tt-decla-import-ord.cod-estab).
        run OpenQuery in h-bocx225 (input 4).
        run findFirst in h-bocx225.
        run serverSendRows in h-bocx225 (input ?, input ?, input no, input ?, output iRowsReturned, output table tt-ordens-embarque).
    
        if  can-find(first tt-ordens-embarque) then
            RUN loadOrdensDesemb IN h-bocx225e (INPUT TABLE tt-ordens-embarque,                              /* tt-ordens-embarque */
                                                INPUT input frame fPage2 tt-decla-import-ord.cod-natur-operac, /* nat-operacao       */
                                                INPUT c-seg-usuario,                                         /* usuario            */ 
                                                INPUT yes,                                                   /* recarrega          */
                                                INPUT NO,                                                   /* icms-diferido      */
                                                INPUT NO,                                                    /* total              */
                                                INPUT yes,                                                   /* recarrega-II       */
                                                INPUT yes,                                                   /* recarrega-ipi      */
                                                INPUT yes,                                                   /* recarrega-icms     */
                                                INPUT yes,                                                   /* recarrega-pis      */
                                                INPUT yes,                                                   /* recarrega-cof      */
                                                INPUT YES,                                                   /* recarrega IBS UF   */
                                                INPUT YES,                                                   /* recarrega IBS Mun  */
                                                INPUT YES,                                                   /* recarrega CBS      */
                                                INPUT YES,                                                   /* recarrega IS       */
                                                INPUT yes,   /* peso-bruto   */                              /* recarrega-p-bruto  */
                                                INPUT yes,   /* peso-liquido */                              /* recarrega-p-liqui  */
                                                INPUT yes,   /* cubagem      */                              /* recarrega-cubagem  */
                                                OUTPUT TABLE tt-ordens-desemb,                               /* tt-ordens-desemb   */
                                                OUTPUT TABLE tt-bo-erro).                                    /* tt-bo-erro         */
    
        FOR FIRST tt-ordens-desemb 
            WHERE tt-ordens-desemb.cod-estabel  = tt-decla-import-ord.cod-estab
            AND   tt-ordens-desemb.embarque     = tt-decla-import-ord.cod-embarq
            AND   tt-ordens-desemb.numero-ordem = tt-decla-import-ord.num-ordem
            AND   tt-ordens-desemb.parcela      = tt-decla-import-ord.num-parcela:
    
            assign tt-decla-import-ord.idi-tributac-impto-import = tt-ordens-desemb.i-trib-ii
                   tt-decla-import-ord.idi-tributac-ipi          = tt-ordens-desemb.i-trib-ipi
                   tt-decla-import-ord.idi-tributac-icms         = tt-ordens-desemb.i-trib-icms
                   tt-decla-import-ord.idi-tributac-pis          = tt-ordens-desemb.i-trib-pis
                   tt-decla-import-ord.idi-tributac-cofins       = tt-ordens-desemb.i-trib-cofins
                   tt-decla-import-ord.val-aliq-ii               = tt-ordens-desemb.de-aliq-ii
                   tt-decla-import-ord.val-aliq-ipi              = tt-ordens-desemb.de-aliq-ipi
                   tt-decla-import-ord.val-aliq-icms             = tt-ordens-desemb.de-aliq-icms
                   tt-decla-import-ord.val-aliq-pis              = tt-ordens-desemb.de-aliq-pis
                   tt-decla-import-ord.val-aliq-cofins           = tt-ordens-desemb.de-aliq-cofins.
            
            &IF DEFINED(bf-mat-comex) &THEN
            &ELSE
            assign tt-decla-import-ord.log-suspens-impto-import = tt-ordens-desemb.l-suspensao-II
                   tt-decla-import-ord.log-suspens-ipi-import   = tt-ordens-desemb.l-suspensao-IPI.
            &ENDIF
            
            RUN buscaValoresUnitImpostos IN h-bocx404 (INPUT tt-decla-import-ord.cod-item,
                                                       OUTPUT tt-decla-import-ord.val-unit-ipi   ,
                                                       OUTPUT tt-decla-import-ord.val-unit-pis   ,
                                                       OUTPUT tt-decla-import-ord.val-unit-cofins).

        end. /* for first tt-ordens-desemb */
    
        assign cb-idi-tributac-impto-import:screen-value in frame fPage4 = {cxinc/i01cx402.i 04 tt-decla-import-ord.idi-tributac-impto-import}
               cb-idi-tributac-ipi:screen-value          in frame fPage4 = {cxinc/i01cx402.i 04 tt-decla-import-ord.idi-tributac-ipi}
               cb-idi-tributac-icms:screen-value         in frame fPage4 = {cxinc/i02cx402.i 04 tt-decla-import-ord.idi-tributac-icms}
               cb-idi-tributac-pis:screen-value          in frame fPage4 = {cxinc/i01cx402.i 04 tt-decla-import-ord.idi-tributac-pis}
               cb-idi-tributac-cofins:screen-value       in frame fPage4 = {cxinc/i01cx402.i 04 tt-decla-import-ord.idi-tributac-cofins}
               cb-suspens-impto-import:screen-value      in frame fPage4 = if  tt-decla-import-ord.log-suspens-impto-import then 'Sim' else 'N∆o'
               cb-suspens-ipi-import:screen-value        in frame fPage4 = if  tt-decla-import-ord.log-suspens-ipi-import then 'Sim' else 'N∆o'.
        &if '{&bf_mat_versao_ems}' >= '2.09' &then
            ASSIGN cb-suspens-icms:SCREEN-VALUE IN FRAME   fPage4 = IF tt-decla-import-ord.log-suspens-icms   THEN 'Sim' ELSE 'N∆o'
                   cb-suspens-pis:SCREEN-VALUE IN FRAME    fPage4 = IF tt-decla-import-ord.log-suspens-pis    THEN 'Sim' ELSE 'N∆o'
                   cb-suspens-cofins:SCREEN-VALUE IN FRAME fPage4 = IF tt-decla-import-ord.log-suspens-cofins THEN 'Sim' ELSE 'N∆o'.
        &else
            ASSIGN cb-suspens-icms:SCREEN-VALUE IN FRAME   fPage4 = IF SUBSTRING(tt-decla-import-ord.cod-livre-1,1,1) = '1' THEN 'Sim' ELSE 'N∆o'
                   cb-suspens-pis:SCREEN-VALUE IN FRAME    fPage4 = IF SUBSTRING(tt-decla-import-ord.cod-livre-1,2,1) = '1' THEN 'Sim' ELSE 'N∆o'
                   cb-suspens-cofins:SCREEN-VALUE IN FRAME fPage4 = IF SUBSTRING(tt-decla-import-ord.cod-livre-1,3,1) = '1' THEN 'Sim' ELSE 'N∆o'.
        &endif
    
        disp tt-decla-import-ord.val-aliq-ii              
             tt-decla-import-ord.val-aliq-ipi             
             tt-decla-import-ord.val-aliq-icms            
             tt-decla-import-ord.val-aliq-pis             
             tt-decla-import-ord.val-aliq-cofins 
             tt-decla-import-ord.val-unit-ipi   
             tt-decla-import-ord.val-unit-pis   
             tt-decla-import-ord.val-unit-cofins with frame fPage4.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btRecarregaPeso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRecarregaPeso wMaintenanceNoNavigation
ON CHOOSE OF btRecarregaPeso IN FRAME fPage1
DO: 
  RUN pi-recarrega-peso.

  /*RUN pi-calcula-peso-liq.  calula os pesos unitarios */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btRecImpostosRT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRecImpostosRT wMaintenanceNoNavigation
ON CHOOSE OF btRecImpostosRT IN FRAME fPage5 /* Recarregar Impostos */
DO:
    run findNatureza in {&hDBOTable} (input input frame fPage2 tt-decla-import-ord.cod-natur-operac).
    if  return-value = 'NOK':U then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Natureza_de_Operaá∆o" *}
        run utp/ut-msgs.p (input 'show', input 2, input RETURN-VALUE).
        return no-apply.
    end.
    else do:
        run setConstraint4 in h-bocx225 (input input frame fPage0 tt-decla-import-ord.cod-embarq, input input frame fPage0 tt-decla-import-ord.cod-estab).
        run OpenQuery in h-bocx225 (input 4).
        run findFirst in h-bocx225.
        run serverSendRows in h-bocx225 (input ?, input ?, input no, input ?, output iRowsReturned, output table tt-ordens-embarque).
    
        if  can-find(first tt-ordens-embarque) then
            RUN loadOrdensDesemb IN h-bocx225e (INPUT TABLE tt-ordens-embarque,                              /* tt-ordens-embarque */
                                                INPUT input frame fPage2 tt-decla-import-ord.cod-natur-operac, /* nat-operacao       */
                                                INPUT c-seg-usuario,                                         /* usuario            */ 
                                                INPUT yes,                                                   /* recarrega          */
                                                INPUT NO,                                                    /* icms-diferido      */
                                                INPUT NO,                                                    /* total              */
                                                INPUT yes,                                                   /* recarrega-II       */
                                                INPUT yes,                                                   /* recarrega-ipi      */
                                                INPUT yes,                                                   /* recarrega-icms     */
                                                INPUT yes,                                                   /* recarrega-pis      */
                                                INPUT yes,                                                   /* recarrega-cof      */
                                                INPUT YES,                                                   /* recarrega IBS UF   */
                                                INPUT YES,                                                   /* recarrega IBS Mun  */
                                                INPUT YES,                                                   /* recarrega CBS      */
                                                INPUT YES,                                                   /* recarrega IS       */
                                                INPUT yes,   /* peso-bruto   */                              /* recarrega-p-bruto  */
                                                INPUT yes,   /* peso-liquido */                              /* recarrega-p-liqui  */
                                                INPUT yes,   /* cubagem      */                              /* recarrega-cubagem  */
                                                OUTPUT TABLE tt-ordens-desemb,                               /* tt-ordens-desemb   */
                                                OUTPUT TABLE tt-bo-erro).                                    /* tt-bo-erro         */
    
        FOR FIRST tt-ordens-desemb 
            WHERE tt-ordens-desemb.cod-estabel  = tt-decla-import-ord.cod-estab
            AND   tt-ordens-desemb.embarque     = tt-decla-import-ord.cod-embarq
            AND   tt-ordens-desemb.numero-ordem = tt-decla-import-ord.num-ordem
            AND   tt-ordens-desemb.parcela      = tt-decla-import-ord.num-parcela:
                                                                            
            ASSIGN c-class-trib-ibs-uf:SCREEN-VALUE     IN FRAME fPage5 = tt-ordens-desemb.cClassTrib-IBSUF    
                   c-cst-ibs-uf:SCREEN-VALUE            IN FRAME fPage5 = tt-ordens-desemb.cCST-IBSUF          
                   de-aliq-ibs-uf:SCREEN-VALUE          IN FRAME fPage5 = string(tt-ordens-desemb.de-aliq-IBSUF)
                   de-aliq-red-ibs-uf:SCREEN-VALUE      IN FRAME fPage5 = string(tt-ordens-desemb.de-aliq-red-IBSUF)
                   c-class-trib-ibs-uf-reg:SCREEN-VALUE IN FRAME fPage5 = tt-ordens-desemb.cClassTribReg-IBSUF
                   c-cst-ibs-uf-reg:SCREEN-VALUE        IN FRAME fPage5 = tt-ordens-desemb.cCSTReg-IBSUF
                   de-aliq-ibs-uf-reg:SCREEN-VALUE      IN FRAME fPage5 = string(tt-ordens-desemb.de-aliq-Reg-IBSUF)
                    
                   c-class-trib-ibs-mun:SCREEN-VALUE     IN FRAME fPage5 = tt-ordens-desemb.cClassTrib-IBSMun
                   c-cst-ibs-mun:SCREEN-VALUE            IN FRAME fPage5 = tt-ordens-desemb.cCST-IBSMun
                   de-aliq-ibs-mun:SCREEN-VALUE          IN FRAME fPage5 = string(tt-ordens-desemb.de-aliq-IBSMun)
                   de-aliq-red-ibs-mun:SCREEN-VALUE      IN FRAME fPage5 = string(tt-ordens-desemb.de-aliq-red-IBSMun)
                   c-class-trib-ibs-mun-reg:SCREEN-VALUE IN FRAME fPage5 = tt-ordens-desemb.cClassTribReg-IBSMun
                   c-cst-ibs-mun-reg:SCREEN-VALUE        IN FRAME fPage5 = tt-ordens-desemb.cCSTReg-IBSMun
                   de-aliq-ibs-mun-reg:SCREEN-VALUE      IN FRAME fPage5 = string(tt-ordens-desemb.de-aliq-Reg-IBSMun)
                   
                   c-class-trib-cbs:SCREEN-VALUE        IN FRAME fPage5 = tt-ordens-desemb.cClassTrib-CBS      
                   c-cst-cbs:SCREEN-VALUE               IN FRAME fPage5 = tt-ordens-desemb.cCST-CBS            
                   de-aliq-cbs:SCREEN-VALUE             IN FRAME fPage5 = string(tt-ordens-desemb.de-aliq-CBS)
                   de-aliq-red-cbs:SCREEN-VALUE         IN FRAME fPage5 = string(tt-ordens-desemb.de-aliq-red-CBS)
                   c-class-trib-cbs-reg:SCREEN-VALUE    IN FRAME fPage5 = tt-ordens-desemb.cClassTribReg-CBS
                   c-cst-cbs-reg:SCREEN-VALUE           IN FRAME fPage5 = tt-ordens-desemb.cCSTReg-CBS
                   de-aliq-cbs-reg:SCREEN-VALUE         IN FRAME fPage5 = string(tt-ordens-desemb.de-aliq-Reg-CBS)
                   
                   c-class-trib-is:SCREEN-VALUE        IN FRAME fPage5 = tt-ordens-desemb.cClassTrib-IS      
                   c-cst-is:SCREEN-VALUE               IN FRAME fPage5 = tt-ordens-desemb.cCST-IS           
                   de-aliq-is:SCREEN-VALUE             IN FRAME fPage5 = string(tt-ordens-desemb.de-aliq-IS)
                   de-aliq-un-is:SCREEN-VALUE          IN FRAME fPage5 = string(tt-ordens-desemb.de-aliq-espec-IS)              
                   de-qtde-trib-is:SCREEN-VALUE        IN FRAME fPage5 = string(tt-ordens-desemb.de-qtde-trib-IS)
                   c-un-trib-is:SCREEN-VALUE           IN FRAME fPage5 = tt-ordens-desemb.c-un-trib-IS

                   cb-idi-tributac-is     :SCREEN-VALUE  IN FRAME fPage5 = {diinc/i01di628.i 04 INT(tt-ordens-desemb.c-trib-IS)}
                   cb-idi-tributac-cbs    :SCREEN-VALUE  IN FRAME fPage5 = {diinc/i01di628.i 04 INT(tt-ordens-desemb.c-trib-CBS)}
                   cb-idi-tributac-ibs-uf :SCREEN-VALUE  IN FRAME fPage5 = {diinc/i01di628.i 04 INT(tt-ordens-desemb.c-trib-IBSUF)}.
                   cb-idi-tributac-ibs-mun:SCREEN-VALUE  IN FRAME fPage5 = {diinc/i01di628.i 04 INT(tt-ordens-desemb.c-trib-IBSMun)}.
        end. /* for first tt-ordens-desemb */
        
        apply 'LEAVE' to c-class-trib-ibs-uf in frame fPage5.
        apply 'LEAVE' to c-class-trib-ibs-mun in frame fPage5.
        apply 'LEAVE' to c-class-trib-cbs in frame fPage5.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    
    ASSIGN vRowidAuxiliar = tt-decla-import-ord.r-Rowid.
    IF c-numeroLi-aux <> INPUT FRAME fPage2 tt-decla-import-ord.cod-licenc-import
    OR dt-restric-emb <> INPUT FRAME fPage2 tt-decla-import-ord.dat-livre-1 THEN DO:
        RUN piPergunta. /* Exporta LI? */
    END. /* IF  c-numeroLi-aux <> */

    RUN pi-saveRecord.  
    RUN repositionRecord IN {&hDBOTable} (INPUT vRowidAuxiliar).
    RUN carrega-tt-quebra. /* recarrega a temp-table com os valores iniciais */
    RUN verifica-att-quebra. /* verifica se os campos da quebra foram modificados */
    RUN saveRecord IN THIS-PROCEDURE.

    RUN carrega-tt-quebra. /* recarrega a temp-table com os valores iniciais */

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
    IF INPUT FRAME fPage5 c-class-trib-cbs <> ""       AND 
       LENGTH(INPUT FRAME fPage5 c-class-trib-cbs) > 3 THEN
       ASSIGN c-cst-cbs:SCREEN-VALUE IN FRAME fPage5 = SUBSTRING(INPUT FRAME fPage5 c-class-trib-cbs,1,3).
              
    IF CAN-FIND(FIRST class-trib NO-LOCK
                WHERE class-trib.cod-cclass-trib = c-class-trib-cbs:SCREEN-VALUE IN FRAME fPage5
                  AND class-trib.ind-tributo     = 1 /* IBS/CBS */
                  AND class-trib.trib-regular    = 1) THEN DO:
                  
        ENABLE c-class-trib-cbs-reg c-cst-cbs-reg WITH FRAME fPage5.  
        
        IF  INPUT FRAME fPage5 de-aliq-cbs <> 0 THEN
            ASSIGN de-aliq-cbs-reg:SCREEN-VALUE IN FRAME fPage5 = de-aliq-cbs:SCREEN-VALUE IN FRAME fPage5.
    END.
    ELSE DO:
        ASSIGN c-class-trib-cbs-reg:SCREEN-VALUE IN FRAME fPage5 = ""
               c-cst-cbs-reg:SCREEN-VALUE IN FRAME fPage5        = ""
               de-aliq-cbs-reg:SCREEN-VALUE IN FRAME fPage5      = "0".
        DISABLE c-class-trib-cbs-reg c-cst-cbs-reg WITH FRAME fPage5.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-cbs wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-cbs IN FRAME fPage5
DO:
    APPLY 'F5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-class-trib-cbs-reg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-cbs-reg wMaintenanceNoNavigation
ON F5 OF c-class-trib-cbs-reg IN FRAME fPage5
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z02in01127.w"
                         &FieldZoom1="cod-cclass-trib"
                         &FieldScreen1="c-class-trib-cbs-reg"
                         &Frame1="fPage5"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-cbs-reg wMaintenanceNoNavigation
ON LEAVE OF c-class-trib-cbs-reg IN FRAME fPage5
DO:
    IF INPUT FRAME fPage5 c-class-trib-cbs-reg <> "" THEN DO:
        IF  NOT CAN-FIND(FIRST class-trib NO-LOCK
                         WHERE class-trib.cod-cclass-trib = c-class-trib-cbs-reg:SCREEN-VALUE IN FRAME fPage5
                         AND   class-trib.ind-tributo     = 1 /* IBS/CBS */) then do:                     
            run utp/ut-msgs.p (input 'show', input 2, input "Class Trib":U + "~~" + c-class-trib-cbs-reg:SCREEN-VALUE IN FRAME fPage5).
            apply "entry" to c-class-trib-cbs-reg in frame fPage5.
            return no-apply.
        END.

        IF LENGTH(INPUT FRAME fPage5 c-class-trib-cbs-reg) > 3 THEN
           ASSIGN c-cst-cbs-reg:SCREEN-VALUE IN FRAME fPage5 = SUBSTRING(INPUT FRAME fPage5 c-class-trib-cbs-reg,1,3).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-cbs-reg wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-cbs-reg IN FRAME fPage5
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-class-trib-ibs-mun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibs-mun wMaintenanceNoNavigation
ON F5 OF c-class-trib-ibs-mun IN FRAME fPage5
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z01in01127.w"
                         &FieldZoom1="cod-cclass-trib"
                         &FieldScreen1="c-class-trib-ibs-mun"
                         &Frame1="fPage5"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibs-mun wMaintenanceNoNavigation
ON LEAVE OF c-class-trib-ibs-mun IN FRAME fPage5
DO:
    IF INPUT FRAME fPage5 c-class-trib-ibs-mun <> ""       AND 
       LENGTH(INPUT FRAME fPage5 c-class-trib-ibs-mun) > 3 THEN
       ASSIGN c-cst-ibs-mun:SCREEN-VALUE IN FRAME fPage5 = SUBSTRING(INPUT FRAME fPage5 c-class-trib-ibs-mun,1,3).
       
    IF CAN-FIND(FIRST class-trib NO-LOCK
                WHERE class-trib.cod-cclass-trib = c-class-trib-ibs-mun:SCREEN-VALUE IN FRAME fPage5
                  AND class-trib.ind-tributo     = 1 /* IBS/CBS */
                  AND class-trib.trib-regular    = 1) THEN DO:
                  
        ENABLE c-class-trib-ibs-mun-reg c-cst-ibs-mun-reg WITH FRAME fPage5.  
        
        IF  INPUT FRAME fPage5 de-aliq-ibs-mun <> 0 THEN
            ASSIGN de-aliq-ibs-mun-reg:SCREEN-VALUE IN FRAME fPage5 = de-aliq-ibs-mun:SCREEN-VALUE IN FRAME fPage5.
    END.
    ELSE DO:
        ASSIGN c-class-trib-ibs-mun-reg:SCREEN-VALUE IN FRAME fPage5 = ""
               c-cst-ibs-mun-reg:SCREEN-VALUE IN FRAME fPage5        = ""
               de-aliq-ibs-mun-reg:SCREEN-VALUE IN FRAME fPage5      = "0".
        DISABLE c-class-trib-ibs-mun-reg c-cst-ibs-mun-reg WITH FRAME fPage5.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibs-mun wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-ibs-mun IN FRAME fPage5
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-class-trib-ibs-mun-reg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibs-mun-reg wMaintenanceNoNavigation
ON F5 OF c-class-trib-ibs-mun-reg IN FRAME fPage5
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z02in01127.w"
                       &FieldZoom1="cod-cclass-trib"
                       &FieldScreen1="c-class-trib-ibs-mun-reg"
                       &Frame1="fPage5"
                       &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibs-mun-reg wMaintenanceNoNavigation
ON LEAVE OF c-class-trib-ibs-mun-reg IN FRAME fPage5
DO:
    IF INPUT FRAME fPage5 c-class-trib-ibs-mun-reg <> "" THEN DO: 
        IF  NOT CAN-FIND(FIRST class-trib NO-LOCK
                         WHERE class-trib.cod-cclass-trib = c-class-trib-ibs-mun-reg:SCREEN-VALUE IN FRAME fPage5
                         AND   class-trib.ind-tributo     = 1 /* IBS/CBS */) then do:                     
            run utp/ut-msgs.p (input 'show', input 2, input "Class Trib ":U + "~~" + c-class-trib-ibs-mun-reg:SCREEN-VALUE IN FRAME fPage5).
            apply "entry" to c-class-trib-ibs-mun-reg in frame fPage5.
            return no-apply.
        END.

        IF LENGTH(INPUT FRAME fPage5 c-class-trib-ibs-mun-reg) > 3 THEN
           ASSIGN c-cst-ibs-mun-reg:SCREEN-VALUE IN FRAME fPage5 = SUBSTRING(INPUT FRAME fPage5 c-class-trib-ibs-mun-reg,1,3).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibs-mun-reg wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-ibs-mun-reg IN FRAME fPage5
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-class-trib-ibs-uf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibs-uf wMaintenanceNoNavigation
ON F5 OF c-class-trib-ibs-uf IN FRAME fPage5 /* Class Trib */
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z01in01127.w"
                         &FieldZoom1="cod-cclass-trib"
                         &FieldScreen1="c-class-trib-ibs-uf"
                         &Frame1="fPage5"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibs-uf wMaintenanceNoNavigation
ON LEAVE OF c-class-trib-ibs-uf IN FRAME fPage5 /* Class Trib */
DO:
    IF INPUT FRAME fPage5 c-class-trib-ibs-uf <> ""       AND 
       LENGTH(INPUT FRAME fPage5 c-class-trib-ibs-uf) > 3 THEN
       ASSIGN c-cst-ibs-uf:SCREEN-VALUE IN FRAME fPage5 = SUBSTRING(INPUT FRAME fPage5 c-class-trib-ibs-uf,1,3).
       
    IF CAN-FIND(FIRST class-trib NO-LOCK
                WHERE class-trib.cod-cclass-trib = c-class-trib-ibs-uf:SCREEN-VALUE IN FRAME fPage5
                  AND class-trib.ind-tributo     = 1 /* IBS/CBS */
                  AND class-trib.trib-regular    = 1) THEN DO:
                  
        ENABLE c-class-trib-ibs-uf-reg c-cst-ibs-uf-reg WITH FRAME fPage5.  
        
        IF  INPUT FRAME fPage5 de-aliq-ibs-uf <> 0 THEN
            ASSIGN de-aliq-ibs-uf-reg:SCREEN-VALUE IN FRAME fPage5 = de-aliq-ibs-uf:SCREEN-VALUE IN FRAME fPage5.
    END.
    ELSE DO:
        ASSIGN c-class-trib-ibs-uf-reg:SCREEN-VALUE IN FRAME fPage5 = ""
               c-cst-ibs-uf-reg:SCREEN-VALUE IN FRAME fPage5        = ""
               de-aliq-ibs-uf-reg:SCREEN-VALUE IN FRAME fPage5      = "0".
        DISABLE c-class-trib-ibs-uf-reg c-cst-ibs-uf-reg WITH FRAME fPage5.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibs-uf wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-ibs-uf IN FRAME fPage5 /* Class Trib */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-class-trib-ibs-uf-reg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibs-uf-reg wMaintenanceNoNavigation
ON F5 OF c-class-trib-ibs-uf-reg IN FRAME fPage5 /* Class Trib */
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z02in01127.w"
                       &FieldZoom1="cod-cclass-trib"
                       &FieldScreen1="c-class-trib-ibs-uf-reg"
                       &Frame1="fPage5"
                       &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibs-uf-reg wMaintenanceNoNavigation
ON LEAVE OF c-class-trib-ibs-uf-reg IN FRAME fPage5 /* Class Trib */
DO:
    IF INPUT FRAME fPage5 c-class-trib-ibs-uf-reg <> "" THEN DO:
        IF  not CAN-FIND(FIRST class-trib NO-LOCK
                         WHERE class-trib.cod-cclass-trib = c-class-trib-ibs-uf-reg:SCREEN-VALUE IN FRAME fPage5
                         AND   class-trib.ind-tributo     = 1 /* IBS/CBS */) then do:                     
            run utp/ut-msgs.p (input 'show', input 2, input "Class Trib":U + "~~" + c-class-trib-ibs-uf-reg:SCREEN-VALUE IN FRAME fPage5).
            apply "entry" to c-class-trib-ibs-uf-reg in frame fPage5.
            return no-apply.
        END.

        IF LENGTH(INPUT FRAME fPage5 c-class-trib-ibs-uf-reg) > 3 THEN
           ASSIGN c-cst-ibs-uf-reg:SCREEN-VALUE IN FRAME fPage5 = SUBSTRING(INPUT FRAME fPage5 c-class-trib-ibs-uf-reg,1,3).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-trib-ibs-uf-reg wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-ibs-uf-reg IN FRAME fPage5 /* Class Trib */
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
ON MOUSE-SELECT-DBLCLICK OF c-class-trib-is IN FRAME fPage5 /* Class Trib */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-un-trib-is
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-trib-is wMaintenanceNoNavigation
ON F5 OF c-un-trib-is IN FRAME fPage5 
DO:
  {include/zoomvar.i   &prog-zoom="inzoom\z01in417.w"
                       &campo=c-un-trib-is
                       &campozoom=un
                       &frame="fPage5"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-trib-is wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-un-trib-is IN FRAME fPage5 
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME cb-idi-ind-pagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-idi-ind-pagto wMaintenanceNoNavigation
ON ENTRY OF cb-idi-ind-pagto IN FRAME fPage3 /* Pagamento */
DO:
    ASSIGN cPagamentoAnterior = SELF:SCREEN-VALUE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-idi-ind-pagto wMaintenanceNoNavigation
ON LEAVE OF cb-idi-ind-pagto IN FRAME fPage3 /* Pagamento */
DO:
    IF cPagamentoAnterior <> SELF:SCREEN-VALUE THEN DO:
        ASSIGN lAlterouPagamento = YES.
        RUN utp/ut-msgs.p (INPUT "show", 
                           INPUT 54435, 
                           INPUT "").
    END.
    ELSE 
        ASSIGN lAlterouPagamento = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME cb-idi-tributac-cofins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-idi-tributac-cofins wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-idi-tributac-cofins IN FRAME fPage4
DO:
  RUN pi-valida-tributac(INPUT "cb-idi-tributac-cofins",
                         INPUT INPUT FRAME fPage4 cb-idi-tributac-cofins).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-idi-tributac-icms
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-idi-tributac-icms wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-idi-tributac-icms IN FRAME fPage4
DO:
  RUN pi-valida-tributac(INPUT "cb-idi-tributac-icms",
                         INPUT INPUT FRAME fPage4 cb-idi-tributac-icms).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-idi-tributac-pis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-idi-tributac-pis wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-idi-tributac-pis IN FRAME fPage4
DO:
  RUN pi-valida-tributac(INPUT "cb-idi-tributac-pis",
                         INPUT INPUT FRAME fPage4 cb-idi-tributac-pis).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-suspens-cofins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-suspens-cofins wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-suspens-cofins IN FRAME fPage4
DO:
  RUN pi-trata-impostos("cofins",INPUT FRAME fPage4 cb-suspens-cofins).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-suspens-icms
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-suspens-icms wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-suspens-icms IN FRAME fPage4
DO:
  RUN pi-trata-impostos("icms",INPUT FRAME fPage4 cb-suspens-icms).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-suspens-pis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-suspens-pis wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-suspens-pis IN FRAME fPage4
DO:
  RUN pi-trata-impostos("pis",INPUT FRAME fPage4 cb-suspens-pis).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-decla-import-ord.cdn-fabrican
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.cdn-fabrican wMaintenanceNoNavigation
ON F5 OF tt-decla-import-ord.cdn-fabrican IN FRAME fPage1 /* Fabricante */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-decla-import-ord.cdn-fabrican"
     &campozoom="cod-emitente"
     &frame="fPage1"
     &campo2="c-nome-fabrican"
     &campozoom2="nome-abrev"
     &frame2="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.cdn-fabrican wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-ord.cdn-fabrican IN FRAME fPage1 /* Fabricante */
DO:
    {method/referencefields.i &HandleDBOLeave="h-boad098"
                              &FindMethod="findemitente"
                              &KeyValue1="int(tt-decla-import-ord.cdn-fabrican:SCREEN-VALUE IN FRAME fPage1)"
                              &FieldName1="nome-abrev" 
                              &FieldScreen1="c-nome-fabrican"
                              &Frame1="fPage1"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.cdn-fabrican wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import-ord.cdn-fabrican IN FRAME fPage1 /* Fabricante */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import-ord.cdn-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.cdn-fornec wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-ord.cdn-fornec IN FRAME fPage1 /* Fornecedor */
DO:
    {method/referencefields.i &HandleDBOLeave="h-boad098"
                              &FindMethod="findemitente"
                              &KeyValue1="int(tt-decla-import-ord.cdn-fornec:SCREEN-VALUE IN FRAME fPage1)"
                              &FieldName1="nome-abrev" 
                              &FieldScreen1="c-nome-fornec"
                              &Frame1="fPage1"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import-ord.cdn-pais-proceden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.cdn-pais-proceden wMaintenanceNoNavigation
ON F5 OF tt-decla-import-ord.cdn-pais-proceden IN FRAME fPage1 /* Pais Procedencia */
DO:
    {method/zoomfields.i &ProgramZoom="unzoom/z11un006.w"
                         &FieldZoom1="cod-pais"
                         &FieldScreen1="tt-decla-import-ord.cdn-pais-proceden"
                         &Frame1="fPage1"
                         &FieldZoom2="nome-pais"
                         &FieldScreen2="c-desc-pais-origem"
                         &Frame2="fPage1"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.cdn-pais-proceden wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-ord.cdn-pais-proceden IN FRAME fPage1 /* Pais Procedencia */
DO:
    RUN findCh_Pais IN h-boun006 (INPUT tt-decla-import-ord.cdn-pais-proceden:screen-value in frame fPage1, 
                                  OUTPUT c-return).
    IF  c-return = "" THEN DO:
        RUN getCharField IN h-boun006 (INPUT "nome-pais", OUTPUT c-return-nome-pais).
        ASSIGN c-desc-pais-origem:SCREEN-VALUE IN FRAME fPage1 = c-return-nome-pais.
    END.
    ELSE ASSIGN c-desc-pais-origem:SCREEN-VALUE IN FRAME fPage1 = "".


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.cdn-pais-proceden wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import-ord.cdn-pais-proceden IN FRAME fPage1 /* Pais Procedencia */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import-ord.cod-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.cod-item wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-ord.cod-item IN FRAME fPage1 /* Item */
DO:
    run findCodigo in h-boin172na (input tt-decla-import-ord.cod-item:screen-value in frame fPage1, output c-return).
    if  c-return = "" then do:
        run getCharField in h-boin172na (input "desc-item", output c-descItem-aux).
        assign c-desc-item:screen-value in frame fPage1 = c-descItem-aux.
    end. /* if c-return ... */
    else assign c-desc-item:screen-value in frame fPage1 = "".

    run retornaDadosItem in {&hDBOTable} (input tt-decla-import-ord.cod-estab,
                                          input tt-decla-import-ord.cod-embarq, 
                                          input tt-decla-import-ord.num-ordem,  
                                          input tt-decla-import-ord.num-parcela,    
                                          input tt-decla-import-ord.cod-item,   
                                          output d-qtde-item,                   
                                          output c-un-item,
                                          output c-class-fisc-aux,
                                          output i-cod-ncm-aux,
                                          output c-desc-class-aux,
                                          output d-vucv-forn-aux,
                                          output c-mo-aux,
                                          output d-peso-bruto,    
                                          output d-peso-liquido,
                                          output l-log-necessita-li). 

    assign tt-decla-import-ord.qtd-item:screen-value in frame fPage1 = string(d-qtde-item)
           tt-decla-import-ord.cod-unid-medid-item:screen-value        in frame fPage1 = c-un-item
           c-cod-class-fisc:screen-value in frame fPage2 = c-class-fisc-aux
           c-class-fisc-ex:screen-value  in frame fPage2 = string(i-cod-ncm-aux)
           d-desc-class:screen-value     in frame fPage2 = c-desc-class-aux
           i-cdn-moed-vucv:screen-value  in frame fPage3 = string(c-mo-aux)
           d-val-vucv:screen-value       in frame fPage3 = string(d-vucv-forn-aux).

    /* Somente habilita ou n∆o dependendo do par∆metro no cd0204 - Manutená∆o de Itens */
    IF NOT l-encontrou THEN /* verifica se ha nota gerada para esta di */
        assign tt-decla-import-ord.cod-licenc-import:sensitive in frame fPage2 = l-log-necessita-li
               tt-decla-import-ord.dat-livre-1:sensitive in frame fPage2 = l-log-necessita-li.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME tt-decla-import-ord.cod-natur-operac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.cod-natur-operac wMaintenanceNoNavigation
ON F5 OF tt-decla-import-ord.cod-natur-operac IN FRAME fPage2 /* Natureza Operaá∆o */
DO:
    {method/ZoomFields.i
             &ProgramZoom="inzoom/z04in245.w"
             &FieldZoom1="nat-operacao"
             &FieldScreen1="tt-decla-import-ord.cod-natur-operac"
             &Frame1="fpage2"
             &FieldZoom2="denominacao"
             &FieldScreen2="c-desc-nat-op"
             &Frame2="fpage2"
             &EnableImplant="no"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.cod-natur-operac wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-ord.cod-natur-operac IN FRAME fPage2 /* Natureza Operaá∆o */
DO:
    run findNatureza in h-boin245 (input tt-decla-import-ord.cod-natur-operac:screen-value in frame fPage2,
                                   output c-return).
    if  c-return = "":U 
    then run getCharfield in h-boin245 (input "denominacao":U,output c-desc-nat-op).
    else assign c-desc-nat-op = "":U.
    
    disp c-desc-nat-op with frame fpage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.cod-natur-operac wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-decla-import-ord.cod-natur-operac IN FRAME fPage2 /* Natureza Operaá∆o */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME de-aliq-cbs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-aliq-cbs wMaintenanceNoNavigation
ON LEAVE OF de-aliq-cbs IN FRAME fPage5
DO:
   IF  CAN-FIND(FIRST class-trib NO-LOCK
                WHERE class-trib.cod-cclass-trib = c-class-trib-cbs:SCREEN-VALUE IN FRAME fPage5
                  AND class-trib.ind-tributo     = 1 /* IBS/CBS */
                  AND class-trib.trib-regular    = 1) 
    AND INPUT FRAME fPage5 de-aliq-cbs <> 0 THEN DO:                  
        ASSIGN de-aliq-cbs-reg:SCREEN-VALUE IN FRAME fPage5 = de-aliq-cbs:SCREEN-VALUE IN FRAME fPage5.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-aliq-ibs-mun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-aliq-ibs-mun wMaintenanceNoNavigation
ON LEAVE OF de-aliq-ibs-mun IN FRAME fPage5
DO:
   IF  CAN-FIND(FIRST class-trib NO-LOCK
                WHERE class-trib.cod-cclass-trib = c-class-trib-ibs-mun:SCREEN-VALUE IN FRAME fPage5
                  AND class-trib.ind-tributo     = 1 /* IBS/CBS */
                  AND class-trib.trib-regular    = 1)
    AND INPUT FRAME fPage5 de-aliq-ibs-mun <> 0 THEN DO:
        ASSIGN de-aliq-ibs-mun-reg:SCREEN-VALUE IN FRAME fPage5 = de-aliq-ibs-mun:SCREEN-VALUE IN FRAME fPage5.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-aliq-ibs-uf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-aliq-ibs-uf wMaintenanceNoNavigation
ON LEAVE OF de-aliq-ibs-uf IN FRAME fPage5 /* Al°quota */
DO:
   IF  CAN-FIND(FIRST class-trib NO-LOCK
                WHERE class-trib.cod-cclass-trib = c-class-trib-ibs-uf:SCREEN-VALUE IN FRAME fPage5
                  AND class-trib.ind-tributo     = 1 /* IBS/CBS */
                  AND class-trib.trib-regular    = 1)
    AND INPUT FRAME fPage5 de-aliq-ibs-uf <> 0 THEN DO:
        ASSIGN de-aliq-ibs-uf-reg:SCREEN-VALUE IN FRAME fPage5 = de-aliq-ibs-uf:SCREEN-VALUE IN FRAME fPage5.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME i-cdn-moed-vucv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-moed-vucv wMaintenanceNoNavigation
ON LEAVE OF i-cdn-moed-vucv IN FRAME fPage3 /* Moeda */
DO:
    run findCodigo in h-boun005 (input int(i-cdn-moed-vucv:screen-value in frame fPage3), output c-return).
    if  c-return = "" 
    then run getCharfield in h-boun005 (input "descricao":U, output c-desc-moeda-vucv).
    else assign c-desc-moeda-vucv = "".

    disp c-desc-moeda-vucv with frame fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-decla-import-ord.log-emite-fabrican
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.log-emite-fabrican wMaintenanceNoNavigation
ON VALUE-CHANGED OF tt-decla-import-ord.log-emite-fabrican IN FRAME fPage1 /* Fornecedor Ç Fabricante? */
DO:
    if tt-decla-import-ord.log-emite-fabrican:screen-value in frame fPage1 = 'yes' then do:
        assign tt-decla-import-ord.cdn-fabrican:screen-value in frame fPage1 = string(tt-decla-import-ord.cdn-fornec)
               tt-decla-import-ord.cdn-fabrican = tt-decla-import-ord.cdn-fornec.
        apply 'leave' to tt-decla-import-ord.cdn-fabrican in frame fPage1.
               
        disable tt-decla-import-ord.cdn-fabrican with frame fPage1.
    end.
    else enable tt-decla-import-ord.cdn-fabrican with frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import-ord.qtd-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.qtd-item wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-ord.qtd-item IN FRAME fPage1 /* Quantidade */
DO:

    RUN pi-calcula-qtd-fornec IN h-bocx404 (INPUT INPUT FRAME fPage0 tt-decla-import-ord.num-ordem,
                                            INPUT INPUT FRAME fPage1 tt-decla-import-ord.cod-item,
                                            INPUT INPUT FRAME fPage1 tt-decla-import-ord.cdn-fornec,
                                            INPUT INPUT FRAME fPage1 tt-decla-import-ord.qtd-item,
                                            OUTPUT tt-decla-import-ord.qtd-fornec).

    DISP tt-decla-import-ord.qtd-fornec WITH FRAME fPage1.

    /*assign tt-decla-import-ord.val-peso-liq:screen-value       in frame fPage1 = string(input frame fPage1 tt-decla-import-ord.qtd-item * d-peso-liquido)
           tt-decla-import-ord.val-peso-brut-merc:screen-value in frame fPage1 = string(input frame fPage1 tt-decla-import-ord.qtd-item * d-peso-bruto). */
    RUN pi-calcula-peso-liq.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import-ord.val-peso-brut-merc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.val-peso-brut-merc wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-ord.val-peso-brut-merc IN FRAME fPage1 /* Peso Bruto (Kg) */
DO:
  RUN pi-calcula-peso-liq. /* calula os pesos unitarios */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decla-import-ord.val-peso-liq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decla-import-ord.val-peso-liq wMaintenanceNoNavigation
ON LEAVE OF tt-decla-import-ord.val-peso-liq IN FRAME fPage1 /* Peso L°quido (Kg) */
DO:
  RUN pi-calcula-peso-liq. /* calula os pesos unitarios */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

if tt-decla-import-ord.cdn-fabrican:load-mouse-pointer ("image/lupa.cur") in frame fPage1 then.
if tt-decla-import-ord.cdn-pais-proceden:load-mouse-pointer ("image/lupa.cur") in frame fPage1 then.
if tt-decla-import-ord.cod-natur-operac:load-mouse-pointer ("image/lupa.cur") in frame fPage2 then.

IF c-class-trib-ibs-uf     :LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.
IF c-class-trib-ibs-mun    :LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.
IF c-class-trib-cbs        :LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.
IF c-class-trib-ibs-uf-reg :LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.
IF c-class-trib-ibs-mun-reg:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.
IF c-class-trib-cbs-reg    :LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.
IF c-class-trib-is         :LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.
IF c-un-trib-is            :LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage5 THEN.

{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE (h-bocx383)   THEN DO: /* decla-import */   
        DELETE PROCEDURE h-bocx383. 
        ASSIGN h-bocx383 = ?. 
    END.

    IF VALID-HANDLE (h-bocx403)   THEN DO: /* decla-import-adic */ 
        DELETE PROCEDURE h-bocx403.  
        ASSIGN h-bocx403 = ?. 
    END.

    IF VALID-HANDLE (h-bocx407)   THEN DO: /* decla-import-embarq */ 
        DELETE PROCEDURE h-bocx407.  
        ASSIGN h-bocx407 = ?. 
    END.

    IF VALID-HANDLE (h-boad098)   THEN DO: /* emitente */
        DELETE PROCEDURE h-boad098.   
        ASSIGN h-boad098 = ?. 
    END.

    IF VALID-HANDLE (h-boin172na) THEN DO: /* itens */
        DELETE PROCEDURE h-boin172na.  
        ASSIGN h-boin172na = ?. 
    END.

    IF VALID-HANDLE (h-boun006)   THEN DO: /* pais */  
        DELETE PROCEDURE h-boun006.        
        ASSIGN h-boun006 = ?. 
    END.

    IF VALID-HANDLE (h-boin245)   THEN DO: /* natureza operaá∆o */  
        DELETE PROCEDURE h-boin245.    
        ASSIGN h-boin245 = ?. 
    END.

    IF VALID-HANDLE (h-boun005)   THEN DO: /* moeda */   
        DELETE PROCEDURE h-boun005.      
        ASSIGN h-boun005 = ?. 
    END.

    IF VALID-HANDLE (h-bocx351)   THEN DO: /* licenciam-import-oc */ 
        DELETE PROCEDURE h-bocx351.   
        ASSIGN h-bocx351 = ?. 
    END.

    IF VALID-HANDLE (h-bocx225e)  THEN DO: /* ordens-embarque */  
        DELETE PROCEDURE h-bocx225e.    
        ASSIGN h-bocx225e = ?. 
    END.

    IF VALID-HANDLE (h-bocx225)   THEN DO: /* ordens-embarque */ 
        DELETE PROCEDURE h-bocx225. 
        ASSIGN h-bocx225 = ?.  
    END.
    
    IF VALID-HANDLE (h-imapi017)   THEN DO: /* sugere cst e classtrib da RT */ 
        DELETE PROCEDURE h-imapi017.
        ASSIGN h-imapi017 = ?.  
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisableFields wMaintenanceNoNavigation 
PROCEDURE afterDisableFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    run piContaRegistro in {&hDBOTable} (INPUT tt-decla-import-ord.num-di-ems,
                                         INPUT tt-decla-import-ord.cdd-siscomex-dts,
                                         output i-nr-registro).
    assign c-registro:screen-value in frame fPage0 = string(i-num-linha-browse) + "/" + string(i-nr-registro).

    ASSIGN cb-idi-metod-val:screen-value             in frame fPage3 = {cxinc/i01cx404.i 04 tt-decla-import-ord.idi-metod-val}
           cb-idi-ind-pagto:screen-value             in frame fPage3 = {cxinc/i02cx404.i 04 tt-decla-import-ord.idi-ind-pagto}
           cb-idi-tributac-icms:screen-value         in frame fPage4 = {cxinc/i02cx402.i 04 tt-decla-import-ord.idi-tributac-icms}
           cb-idi-tributac-ipi:screen-value          in frame fPage4 = {cxinc/i01cx402.i 04 tt-decla-import-ord.idi-tributac-ipi}
           cb-idi-tributac-pis:screen-value          in frame fPage4 = {cxinc/i01cx402.i 04 tt-decla-import-ord.idi-tributac-pis}
           cb-idi-tributac-cofins:screen-value       in frame fPage4 = {cxinc/i01cx402.i 04 tt-decla-import-ord.idi-tributac-cofins}
           cb-idi-tributac-impto-import:screen-value in frame fPage4 = {cxinc/i01cx402.i 04 tt-decla-import-ord.idi-tributac-impto-import}
           cb-suspens-impto-import:screen-value      in frame fPage4 = if tt-decla-import-ord.log-suspens-impto-import then 'Sim' else 'N∆o'
           cb-suspens-ipi-import:screen-value        in frame fPage4 = if tt-decla-import-ord.log-suspens-ipi-import then 'Sim' else 'N∆o'
           rRowid = tt-decla-import-ord.r-Rowid
           .
    &if '{&bf_mat_versao_ems}' >= '2.09' &then
        ASSIGN cb-suspens-icms:SCREEN-VALUE   IN FRAME fPage4   = IF tt-decla-import-ord.log-suspens-icms   THEN 'Sim' ELSE 'N∆o'
               cb-suspens-pis:SCREEN-VALUE    IN FRAME fPage4   = IF tt-decla-import-ord.log-suspens-pis    THEN 'Sim' ELSE 'N∆o'
               cb-suspens-cofins:SCREEN-VALUE IN FRAME fPage4   = IF tt-decla-import-ord.log-suspens-cofins THEN 'Sim' ELSE 'N∆o'.
    &else
        ASSIGN cb-suspens-icms:SCREEN-VALUE   IN FRAME fPage4   = IF SUBSTRING(tt-decla-import-ord.cod-livre-1,1,1) = '1' THEN 'Sim' ELSE 'N∆o'
               cb-suspens-pis:SCREEN-VALUE    IN FRAME fPage4   = IF SUBSTRING(tt-decla-import-ord.cod-livre-1,2,1) = '1' THEN 'Sim' ELSE 'N∆o'
               cb-suspens-cofins:SCREEN-VALUE IN FRAME fPage4   = IF SUBSTRING(tt-decla-import-ord.cod-livre-1,3,1) = '1' THEN 'Sim' ELSE 'N∆o'.
    &endif

    run pi-Dados.
    
    APPLY 'LEAVE' TO tt-decla-import-ord.cdn-fornec IN FRAME fPage1.
    APPLY 'LEAVE' TO tt-decla-import-ord.cdn-fabrican IN FRAME fPage1. 
    APPLY 'LEAVE' TO tt-decla-import-ord.cdn-pais-proceden IN FRAME fPage1.
    APPLY 'LEAVE' TO tt-decla-import-ord.cod-item IN FRAME fPage1.
    APPLY 'LEAVE' TO c-cod-class-fisc IN FRAME fPage2.
    APPLY 'LEAVE' TO c-cod-incoterm IN FRAME fPage2.
    APPLY 'LEAVE' TO tt-decla-import-ord.cod-natur-operac IN FRAME fPage2.
    APPLY 'LEAVE' TO i-cdn-moed-vucv IN FRAME fPage3.
    
    DISP label-tributacao label-aliquota label-reducao label-suspenso label-vl-unit label-ii label-ipi label-icms label-pis label-cofins WITH FRAME fPage4.

    /* Reforma Tribut†ria */
    IF l-nt2024002 THEN DO:    
        RUN pi-dados-tributosRT.
        DISABLE cb-idi-tributac-ibs-uf cb-idi-tributac-ibs-mun cb-idi-tributac-cbs cb-idi-tributac-is WITH FRAME fPage5.   

        DISP label-ibs label-ibs-mun label-cbs label-is WITH FRAME fPage5.
        
        IF NOT l-encontrou THEN DO:
            APPLY 'LEAVE':U TO c-class-trib-ibs-uf IN FRAME fPage5.
            APPLY 'LEAVE':U TO c-class-trib-ibs-mun IN FRAME fPage5.
            APPLY 'LEAVE':U TO c-class-trib-cbs IN FRAME fPage5.
        END.
    END.
    
    apply 'value-changed' to tt-decla-import-ord.log-emite-fabrican in frame fPage1.
    /* Para que somente faáa a pergunta de exportaá∆o do Nr.LI se houver alteraá∆o no campo */
    ASSIGN c-numeroLI-aux = INPUT FRAME fPage2 tt-decla-import-ord.cod-licenc-import
           dt-restric-emb = INPUT FRAME fPage2 tt-decla-import-ord.dat-livre-1.

    RUN pi-calcula-peso-liq. /* calula os pesos unitarios */


    /* carrega temp-table auxiliar que ser† usada na validaá∆o da alteraá∆o dos campos de quebra */
    FIND FIRST tt-decla-import-ord NO-ERROR.
    BUFFER-COPY tt-decla-import-ord TO tt-decla-import-ord-aux.

    RUN carrega-tt-quebra. /* carrega uma temp-table com os valores iniciais */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN carrega-tt-quebra. /* carrega uma temp-table com os valores iniciais */
    RUN pi-verifica-docto. /* verifica se h† nota gerada para esta DI. Se houver desabilita todos os campos da tela. */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-decla-import-ord-trib.
    
    RUN setConstraintByDI IN {&hDBOTable} (INPUT tt-decla-import-ord.num-di-ems,
                                           INPUT tt-decla-import-ord.cdd-siscomex-dts).
    RUN openQueryStatic   IN {&hDBOTable} (INPUT 'ByDI':U).

    /* Reforma Tribut†ria */
    if l-nt2024002 THEN DO:
        DISABLE cb-idi-tributac-ibs-uf cb-idi-tributac-ibs-mun cb-idi-tributac-cbs cb-idi-tributac-is WITH FRAME fPage5. 
        
        RUN piBuscaOrdTrib.
    END.
    ELSE
        RUN deleteFolder IN hFolder (INPUT 5).
    
    run piContaRegistro in {&hDBOTable} (INPUT tt-decla-import-ord.num-di-ems,
                                         INPUT tt-decla-import-ord.cdd-siscomex-dts,
                                         output i-nr-registro).
    assign c-registro:screen-value in frame fPage0 = string(i-num-linha-browse) + "/" + string(i-nr-registro).
    
    if i-num-linha-browse = 1 and i-nr-registro = 1 
    then disable btSave bt-nex bt-pre with frame fPage0.
    else  enable btSave bt-nex bt-pre with frame fPage0.

    run pi-Dados.

    APPLY 'LEAVE' TO tt-decla-import-ord.cdn-fornec IN FRAME fPage1.
    APPLY 'LEAVE' TO tt-decla-import-ord.cdn-fabrican IN FRAME fPage1. 
    APPLY 'LEAVE' TO tt-decla-import-ord.cdn-pais-proceden IN FRAME fPage1.
    APPLY 'LEAVE' TO tt-decla-import-ord.cod-item IN FRAME fPage1.
    APPLY 'LEAVE' TO c-cod-class-fisc IN FRAME fPage2.
    APPLY 'LEAVE' TO c-cod-incoterm IN FRAME fPage2.
    APPLY 'LEAVE' TO tt-decla-import-ord.cod-natur-operac IN FRAME fPage2.
    APPLY 'LEAVE' TO i-cdn-moed-vucv IN FRAME fPage3.

    DISP label-tributacao label-aliquota label-reducao label-suspenso label-vl-unit label-ii label-ipi label-icms label-pis label-cofins WITH FRAME fPage4.
    
    enable btRecarImpostos   with frame fPage4.

    /* Reforma Tribut†ria */
    IF l-nt2024002 THEN DO:    
        RUN pi-dados-tributosRT.
        enable btRecImpostosRT   with frame fPage5.
        DISP label-ibs label-ibs-mun label-cbs label-is WITH FRAME fPage5.        
        
        apply 'LEAVE' to c-class-trib-ibs-uf in frame fPage5.
        apply 'LEAVE' to c-class-trib-ibs-mun in frame fPage5.
        apply 'LEAVE' to c-class-trib-cbs in frame fPage5.
    END.

    disable tt-decla-import-ord.cdn-fornec c-nome-fornec tt-decla-import-ord.cod-item c-desc-item tt-decla-import-ord.cod-unid-medid-item tt-decla-import-ord.qtd-fornec tt-decla-import-ord.cod-unid-med-fornec with frame fPage1.
    disable c-class-fisc-ex c-cod-class-fisc c-cod-incoterm c-desc-incoterm d-desc-class tt-decla-import-ord.cod-natur-operac c-desc-nat-op with frame fPage2.
    disable i-cdn-moed-vucv d-val-vucv with frame fPage3.
    
    apply 'value-changed' to tt-decla-import-ord.log-emite-fabrican in frame fPage1.

    if  i-num-linha-browse = 1 
    then disable bt-pre with frame fPage0.
    else if i-num-linha-browse = i-nr-registro then disable bt-nex with frame fPage0.
    
    ENABLE btRecarregaPeso WITH FRAME fPage1.

    DISABLE val-peso-liq-unit
            val-peso-brut-unit
        WITH FRAME fPage1.
    RUN pi-calcula-peso-liq. /* calula os pesos unitarios */

    RUN pi-verifica-docto. /* verifica se h† nota gerada para esta DI. Se houver desabilita todos os campos da tela. */

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

        /* MÇtodo de Valoraá∆o */
        ASSIGN cAuxTraducao001 = {cxinc/i01cx404.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN cb-idi-metod-val:LIST-ITEM-PAIRS in frame fPage3 = cAuxTraducao001.

        /* Pagamento */
        ASSIGN cAuxTraducao002 = {cxinc/i02cx404.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
        ASSIGN cb-idi-ind-pagto:LIST-ITEM-PAIRS in frame fPage3 = cAuxTraducao002.

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
        
        /*Reforma Tribut†ria*/ 
        IF l-nt2024002 THEN DO:
            ASSIGN cAuxTraducao008 = {diinc/i01di628.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao008).
            
            ASSIGN cb-idi-tributac-cbs:LIST-ITEM-PAIRS     in frame fPage5 = cAuxTraducao008.
            ASSIGN cb-idi-tributac-ibs-uf:LIST-ITEM-PAIRS  in frame fPage5 = cAuxTraducao008.
            ASSIGN cb-idi-tributac-ibs-mun:LIST-ITEM-PAIRS in frame fPage5 = cAuxTraducao008.
            ASSIGN cb-idi-tributac-is:LIST-ITEM-PAIRS      in frame fPage5 = cAuxTraducao008.
        END.
    &else
        ASSIGN cb-idi-metod-val:LIST-ITEMS             in frame fPage3 = {cxinc/i01cx404.i 03}
               cb-idi-ind-pagto:LIST-ITEMS             in frame fPage3 = {cxinc/i02cx404.i 03}
               cb-idi-tributac-impto-import:LIST-ITEMS in frame fPage4 = {cxinc/i01cx402.i 03}
               cb-idi-tributac-ipi:LIST-ITEMS          in frame fPage4 = {cxinc/i01cx402.i 03}
               cb-idi-tributac-icms:LIST-ITEMS         in frame fPage4 = {cxinc/i02cx402.i 03}
               cb-idi-tributac-pis:LIST-ITEMS          in frame fPage4 = {cxinc/i01cx402.i 03}
               cb-idi-tributac-cofins:LIST-ITEMS       in frame fPage4 = {cxinc/i01cx402.i 03}.
        
        IF l-nt2024002 THEN DO:   
            ASSIGN cb-idi-tributac-cbs:LIST-ITEMS      in frame fPage5 = {diinc/i01di628.i 03}.
            ASSIGN cb-idi-tributac-ibs-uf:LIST-ITEMS   in frame fPage5 = {diinc/i01di628.i 03}.
            ASSIGN cb-idi-tributac-ibs-mun:LIST-ITEMS  in frame fPage5 = {diinc/i01di628.i 03}.
            ASSIGN cb-idi-tributac-is:LIST-ITEMS       in frame fPage5 = {diinc/i01di628.i 03}.
        END.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carrega-tt-quebra wMaintenanceNoNavigation 
PROCEDURE carrega-tt-quebra :
/*:T------------------------------------------------------------------------------
  Purpose:     esta procedure pega os valores dos campos em tela e carrega a temp-table usada na verificaá∆o da alteraá∆o da quebra das adiá‰es.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-campos-quebra.

    assign input frame fPage4 cb-idi-tributac-cofins
           input frame fPage4 cb-idi-tributac-icms
           input frame fPage4 cb-idi-tributac-impto-import
           input frame fPage4 cb-idi-tributac-ipi
           input frame fPage4 cb-idi-tributac-pis.

    CREATE tt-campos-quebra.
    ASSIGN tt-campos-quebra.num-di-ems                  = tt-decla-import-ord.num-di-ems
           tt-campos-quebra.cdd-siscomex-dts            = tt-decla-import-ord.cdd-siscomex-dts
           tt-campos-quebra.num-ordem                   = INPUT FRAME fPage0 tt-decla-import-ord.num-ordem
           tt-campos-quebra.num-parcela                 = INPUT FRAME fPage0 tt-decla-import-ord.num-parcela
           tt-campos-quebra.cdn-naladi-sist-harmon      = INPUT FRAME fPage2 tt-decla-import-ord.cdn-naladi-sist-harmon
           tt-campos-quebra.cod-naladi-ncca             = INPUT FRAME fPage2 tt-decla-import-ord.cod-naladi-ncca            
           tt-campos-quebra.cod-nbm                     = INPUT FRAME fPage2 tt-decla-import-ord.cod-nbm                    
           tt-campos-quebra.cod-licenc-import           = INPUT FRAME fPage2 tt-decla-import-ord.cod-licenc-import          
           tt-campos-quebra.cdn-fabrican                = INPUT FRAME fPage1 tt-decla-import-ord.cdn-fabrican               
           tt-campos-quebra.cdn-pais-proceden           = INPUT FRAME fPage1 tt-decla-import-ord.cdn-pais-proceden
           tt-campos-quebra.cod-aladi                   = INPUT FRAME fPage2 tt-decla-import-ord.cod-aladi                  
           tt-campos-quebra.qtd-capac-recip             = INPUT FRAME fPage2 tt-decla-import-ord.qtd-capac-recip            
                                                                                                                            
           tt-campos-quebra.log-suspens-impto-import    = if input frame fPage4 cb-suspens-impto-import = 'Sim' then yes else no
           tt-campos-quebra.log-suspens-ipi-import      = if input frame fPage4 cb-suspens-ipi-import   = 'Sim' then yes else no   
           &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN 
               tt-campos-quebra.log-suspens-icms            = INPUT FRAME fPage4 cb-suspens-icms
               tt-campos-quebra.log-suspens-pis             = INPUT FRAME fPage4 cb-suspens-pis
               tt-campos-quebra.log-suspens-cofins          = INPUT FRAME fPage4 cb-suspens-cofins
           &ELSE                                                                                                                 
               OVERLAY(tt-campos-quebra.cod-livre-1,1,1)    = IF INPUT FRAME fPage4 cb-suspens-icms   = 'Sim' THEN '1' ELSE '2'
               OVERLAY(tt-campos-quebra.cod-livre-1,2,1)    = IF INPUT FRAME fPage4 cb-suspens-pis    = 'Sim' THEN '1' ELSE '2'
               OVERLAY(tt-campos-quebra.cod-livre-1,3,1)    = IF INPUT FRAME fPage4 cb-suspens-cofins = 'Sim' THEN '1' ELSE '2'

           &ENDIF                                                                                                                 
           tt-campos-quebra.idi-tributac-icms           = {cxinc/i01cx402.i 06 cb-idi-tributac-icms}
           tt-campos-quebra.idi-tributac-ipi            = {cxinc/i01cx402.i 06 cb-idi-tributac-ipi}
           tt-campos-quebra.idi-tributac-pis            = {cxinc/i01cx402.i 06 cb-idi-tributac-pis}
           tt-campos-quebra.idi-tributac-cofins         = {cxinc/i01cx402.i 06 cb-idi-tributac-cofins}
           tt-campos-quebra.idi-tributac-impto-import   = {cxinc/i01cx402.i 06 cb-idi-tributac-impto-import}

           tt-campos-quebra.val-aliq-cofins             = INPUT FRAME fPage4 tt-decla-import-ord.val-aliq-cofins            
           tt-campos-quebra.val-aliq-icms               = INPUT FRAME fPage4 tt-decla-import-ord.val-aliq-icms              
           tt-campos-quebra.val-aliq-ii                 = INPUT FRAME fPage4 tt-decla-import-ord.val-aliq-ii                
           tt-campos-quebra.val-aliq-ipi                = INPUT FRAME fPage4 tt-decla-import-ord.val-aliq-ipi               
           tt-campos-quebra.val-aliq-pis                = INPUT FRAME fPage4 tt-decla-import-ord.val-aliq-pis
                                                                                                                            
           tt-campos-quebra.val-perc-reduc-cofins       = INPUT FRAME fPage4 tt-decla-import-ord.val-perc-reduc-cofins      
           tt-campos-quebra.val-perc-reduc-icms         = INPUT FRAME fPage4 tt-decla-import-ord.val-perc-reduc-icms        
           tt-campos-quebra.val-perc-reduc-impto-import = INPUT FRAME fPage4 tt-decla-import-ord.val-perc-reduc-impto-import
           tt-campos-quebra.val-perc-reduc-ipi          = INPUT FRAME fPage4 tt-decla-import-ord.val-perc-reduc-ipi         
           tt-campos-quebra.val-perc-reduc-pis          = INPUT FRAME fPage4 tt-decla-import-ord.val-perc-reduc-pis
                   
           tt-campos-quebra.val-peso-liq                = INPUT FRAME fPage1 tt-decla-import-ord.val-peso-liq
           tt-campos-quebra.val-peso-brut-merc          = INPUT FRAME fPage1 tt-decla-import-ord.val-peso-brut-merc
           
           tt-campos-quebra.c-class-trib-ibs-uf         = INPUT FRAME fPage5 c-class-trib-ibs-uf
           tt-campos-quebra.c-cst-ibs-uf                = INPUT FRAME fPage5 c-cst-ibs-uf
           tt-campos-quebra.cb-idi-tributac-ibs-uf      = INPUT FRAME fPage5 cb-idi-tributac-ibs-uf
           tt-campos-quebra.de-aliq-ibs-uf              = INPUT FRAME fPage5 de-aliq-ibs-uf
           tt-campos-quebra.de-aliq-red-ibs-uf          = INPUT FRAME fPage5 de-aliq-red-ibs-uf
    
           tt-campos-quebra.c-class-trib-ibs-mun        = INPUT FRAME fPage5 c-class-trib-ibs-mun
           tt-campos-quebra.c-cst-ibs-mun               = INPUT FRAME fPage5 c-cst-ibs-mun
           tt-campos-quebra.cb-idi-tributac-ibs-mun     = INPUT FRAME fPage5 cb-idi-tributac-ibs-mun
           tt-campos-quebra.de-aliq-ibs-mun             = INPUT FRAME fPage5 de-aliq-ibs-mun
           tt-campos-quebra.de-aliq-red-ibs-mun         = INPUT FRAME fPage5 de-aliq-red-ibs-mun

           tt-campos-quebra.c-class-trib-cbs            = INPUT FRAME fPage5 c-class-trib-cbs
           tt-campos-quebra.c-cst-cbs                   = INPUT FRAME fPage5 c-cst-cbs
           tt-campos-quebra.cb-idi-tributac-cbs         = INPUT FRAME fPage5 cb-idi-tributac-cbs
           tt-campos-quebra.de-aliq-cbs                 = INPUT FRAME fPage5 de-aliq-cbs
           tt-campos-quebra.de-aliq-red-cbs             = INPUT FRAME fPage5 de-aliq-red-cbs

           tt-campos-quebra.c-class-trib-ibs-uf-reg     = INPUT FRAME fPage5 c-class-trib-ibs-uf-reg
           tt-campos-quebra.c-cst-ibs-uf-reg            = INPUT FRAME fPage5 c-cst-ibs-uf-reg
           tt-campos-quebra.de-aliq-ibs-uf-reg          = INPUT FRAME fPage5 de-aliq-ibs-uf-reg
           tt-campos-quebra.c-class-trib-ibs-mun-reg    = INPUT FRAME fPage5 c-class-trib-ibs-mun-reg
           tt-campos-quebra.c-cst-ibs-mun-reg           = INPUT FRAME fPage5 c-cst-ibs-mun-reg
           tt-campos-quebra.de-aliq-ibs-mun-reg         = INPUT FRAME fPage5 de-aliq-ibs-mun-reg
           tt-campos-quebra.c-class-trib-cbs-reg        = INPUT FRAME fPage5 c-class-trib-cbs-reg
           tt-campos-quebra.c-cst-cbs-reg               = INPUT FRAME fPage5 c-cst-cbs-reg
           tt-campos-quebra.de-aliq-cbs-reg             = INPUT FRAME fPage5 de-aliq-cbs-reg.

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
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE (h-bocx383)   THEN RUN cxbo/bocx383.p   PERSISTENT SET h-bocx383.   /* decla-import */
    IF NOT VALID-HANDLE (h-bocx403)   THEN RUN cxbo/bocx403.p   PERSISTENT SET h-bocx403.   /* decla-import-adic */
    IF NOT VALID-HANDLE (h-bocx407)   THEN RUN cxbo/bocx407.p   PERSISTENT SET h-bocx407.   /* decla-import-embarq */
    IF NOT VALID-HANDLE (h-boad098)   THEN RUN adbo/boad098.p   PERSISTENT SET h-boad098.   /* emitente */
    IF NOT VALID-HANDLE (h-boin172na) THEN RUN inbo/boin172na.p PERSISTENT SET h-boin172na. /* itens */
    IF NOT VALID-HANDLE (h-boun006)   THEN RUN unbo/boun006.p   PERSISTENT SET h-boun006.   /* pais */ 
    IF NOT VALID-HANDLE (h-boin245)   THEN RUN inbo/boin245.p   PERSISTENT SET h-boin245.   /* natureza operaá∆o */ 
    IF NOT VALID-HANDLE (h-boun005)   THEN RUN unbo/boun005.p   PERSISTENT SET h-boun005.   /* moeda */
    IF NOT VALID-HANDLE (h-bocx351)   THEN RUN cxbo/bocx351.p   PERSISTENT SET h-bocx351.   /* licenciam-import-oc */
    IF NOT VALID-HANDLE (h-bocx225e)  THEN RUN cxbo/bocx225e.p  PERSISTENT SET h-bocx225e.  /* ordens-embarque */
    IF NOT VALID-HANDLE (h-bocx225)   THEN RUN cxbo/bocx225.p   PERSISTENT SET h-bocx225.   /* ordens-embarque */
    IF NOT VALID-HANDLE (h-bocx00507) THEN RUN cxbo/bocx00507.p PERSISTENT SET h-bocx00507. /* decla-import-ord-trib */
    IF NOT VALID-HANDLE (h-imapi017)  THEN RUN imp/imapi017.p   PERSISTENT SET h-imapi017.  /* sugere cst e classtrib RT */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-peso-liq wMaintenanceNoNavigation 
PROCEDURE pi-calcula-peso-liq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR peso-liq-tot   LIKE tt-decla-import-ord.val-peso-liq       NO-UNDO.
    DEF VAR peso-brut-tot  LIKE tt-decla-import-ord.val-peso-brut-merc NO-UNDO.
    DEF VAR qtd            LIKE tt-decla-import-ord.qtd-item           NO-UNDO.

    ASSIGN peso-liq-tot  = decimal(tt-decla-import-ord.val-peso-liq:SCREEN-VALUE IN FRAME fPage1)
           peso-brut-tot = decimal(tt-decla-import-ord.val-peso-brut-merc:SCREEN-VALUE IN FRAME fPage1)
           qtd           = decimal(tt-decla-import-ord.qtd-item:SCREEN-VALUE IN FRAME fPage1).

    ASSIGN val-peso-liq-unit:SCREEN-VALUE IN FRAME fPage1  = string(peso-liq-tot  / qtd)
           val-peso-brut-unit:SCREEN-VALUE IN FRAME fPage1 = string(peso-brut-tot / qtd).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Dados wMaintenanceNoNavigation 
PROCEDURE pi-Dados :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    run retornaDados-incoterm in {&hDBOTable} (input tt-decla-import-ord.cod-estab,
                                               input tt-decla-import-ord.cod-embarq,
                                               input tt-decla-import-ord.num-ordem,
                                               input tt-decla-import-ord.num-parcela,
                                               output c-incoterm-aux,
                                               output c-desc-incoterm-aux).

    assign c-cod-incoterm:screen-value  in frame fpage2 = c-incoterm-aux
           c-desc-incoterm:screen-value in frame fPage2 = c-desc-incoterm-aux.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dados-tributosRT wMaintenanceNoNavigation 
PROCEDURE pi-dados-tributosRT :
/*------------------------------------------------------------------------------
  Purpose:     Tributo: IBSUF
                Campos: CST, TRIBUTACAO, ALIQUOTA, ALIQ-RED, SUSPENSO, C-CLASS-TRIB
               Tributo: CBS
               Campos: CST, TRIBUTACAO, ALIQUOTA, ALIQ-RED, SUSPENSO, C-CLASS-TRIB, VAL-UNIT
                        
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR vincideIS AS LOG NO-UNDO INIT FALSE.
    DEFINE VARIABLE cValorIS AS CHARACTER NO-UNDO.


    FOR EACH tt-decla-import-ord-trib 
       WHERE tt-decla-import-ord-trib.num-di-ems       = tt-decla-import-ord.num-di-ems
         AND tt-decla-import-ord-trib.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts
         AND tt-decla-import-ord-trib.num-ordem        = tt-decla-import-ord.num-ordem
         AND tt-decla-import-ord-trib.num-parcela      = tt-decla-import-ord.num-parcela NO-LOCK:

        /* cClassTrib */
        CASE tt-decla-import-ord-trib.nom-trib:
            WHEN "IBSUF" THEN DO:
                CASE tt-decla-import-ord-trib.cod-campo:
                    WHEN "C-CLASS-TRIB" THEN DO:
                        ASSIGN c-class-trib-ibs-uf:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "CST":U THEN DO:
                        ASSIGN c-cst-ibs-uf:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "COD-TRIB":U THEN DO:                        
                        ASSIGN cb-idi-tributac-ibs-uf:SCREEN-VALUE IN FRAME fPage5 = {diinc/i01di628.i 04 INT(tt-decla-import-ord-trib.cod-conteudo)}.
                    END.
                    WHEN "ALIQUOTA":U THEN DO:
                        ASSIGN de-aliq-ibs-uf:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "ALIQ-RED":U THEN DO:
                        ASSIGN de-aliq-red-ibs-uf:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                     WHEN "C-CLASS-TRIB-REG" THEN DO:
                        ASSIGN c-class-trib-ibs-uf-reg:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "CST-REG":U THEN DO:
                        ASSIGN c-cst-ibs-uf-reg:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "ALIQ-EFETIVA-REG":U THEN DO:
                        ASSIGN de-aliq-ibs-uf-reg:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                END CASE.
            END.
            WHEN "IBSMUN" THEN DO:
                CASE tt-decla-import-ord-trib.cod-campo:
                    WHEN "C-CLASS-TRIB" THEN DO:
                        ASSIGN c-class-trib-ibs-mun:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "CST":U THEN DO:
                        ASSIGN c-cst-ibs-mun:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "COD-TRIB":U THEN DO:                        
                        ASSIGN cb-idi-tributac-ibs-mun:SCREEN-VALUE IN FRAME fPage5 = {diinc/i01di628.i 04 INT(tt-decla-import-ord-trib.cod-conteudo)}.
                    END.
                    WHEN "ALIQUOTA":U THEN DO:
                        ASSIGN de-aliq-ibs-mun:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "ALIQ-RED":U THEN DO:
                        ASSIGN de-aliq-red-ibs-mun:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                     WHEN "C-CLASS-TRIB-REG" THEN DO:
                        ASSIGN c-class-trib-ibs-mun-reg:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "CST-REG":U THEN DO:
                        ASSIGN c-cst-ibs-mun-reg:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "ALIQ-EFETIVA-REG":U THEN DO:
                        ASSIGN de-aliq-ibs-mun-reg:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                END CASE.
            END.
            WHEN "CBS" THEN DO:
                CASE tt-decla-import-ord-trib.cod-campo:
                    WHEN "C-CLASS-TRIB":U THEN DO:
                        ASSIGN c-class-trib-cbs:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "CST":U THEN DO:
                        ASSIGN c-cst-cbs:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "COD-TRIB":U THEN DO:
                        ASSIGN cb-idi-tributac-cbs:SCREEN-VALUE IN FRAME fPage5 = {diinc/i01di628.i 04 INT(tt-decla-import-ord-trib.cod-conteudo)}.
                    END.
                    WHEN "ALIQUOTA":U THEN DO:
                        ASSIGN de-aliq-cbs:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "ALIQ-RED":U THEN DO:
                        ASSIGN de-aliq-red-cbs:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "C-CLASS-TRIB-REG":U THEN DO:
                        ASSIGN c-class-trib-cbs-reg:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "CST-REG":U THEN DO:
                        ASSIGN c-cst-cbs-reg:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                    WHEN "ALIQ-EFETIVA-REG":U THEN DO:
                        ASSIGN de-aliq-cbs-reg:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    END.
                END CASE.
            END.
            WHEN "IS" THEN DO:
                CASE tt-decla-import-ord-trib.cod-campo:
                    WHEN "C-CLASS-TRIB" THEN
                        ASSIGN c-class-trib-is:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    WHEN "CST":U THEN
                        ASSIGN c-cst-is:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    WHEN "COD-TRIB":U THEN DO:
                        ASSIGN cb-idi-tributac-is:SCREEN-VALUE IN FRAME fPage5 = {diinc/i01di628.i 04 INT(tt-decla-import-ord-trib.cod-conteudo)}.
                        IF cb-idi-tributac-is:SCREEN-VALUE IN FRAME fPage5 = ? OR cb-idi-tributac-is:SCREEN-VALUE IN FRAME fPage5 = "" THEN
                        DO:
                           ASSIGN cb-idi-tributac-is:SCREEN-VALUE IN FRAME fPage5 = "Tributado". 
                        END.
                    END.
                    WHEN "ALIQUOTA":U THEN
                        ASSIGN de-aliq-is:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    WHEN "ALIQ-ESPEC-UN":U THEN
                        ASSIGN de-aliq-un-is:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                    WHEN "QTDE-TRIBUT":U THEN
                        ASSIGN de-qtde-trib-is:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.  
                    WHEN "UN-TRIBUT":U THEN
                        ASSIGN c-un-trib-is:SCREEN-VALUE IN FRAME fPage5 = tt-decla-import-ord-trib.cod-conteudo.
                END CASE.
            END.
        END CASE.
    END.
    FOR FIRST cotacao-item FIELDS(numero-ordem cot-aprovada it-codigo char-1)
        WHERE cotacao-item.numero-ordem = tt-decla-import-ord.num-ordem
          AND cotacao-item.cot-aprovada NO-LOCK:
    END.
    RUN piEnviaCodNBS IN h-imapi017 (INPUT TRIM(SUBSTRING(cotacao-item.char-1,101,20))).
    FIND FIRST ITEM WHERE ITEM.it-codigo = cotacao-item.it-codigo NO-LOCK NO-ERROR.
    IF AVAIL ITEM THEN
    DO:
       ASSIGN vincideIS = (SUBSTRING(item.char-1,289,1) = "S"). 
    END.
    IF INPUT FRAME fPage5 c-class-trib-ibs-uf  = "" 
    OR INPUT FRAME fPage5 c-class-trib-ibs-mun = "" 
    OR INPUT FRAME fPage5 c-class-trib-cbs     = ""
    OR ((INPUT FRAME fPage5 c-class-trib-is   = "") 
         AND vincideIS /* Incide IS */ )THEN DO:
    
        RUN pi-sugere-cClassTrib IN h-imapi017 (INPUT tt-decla-import-ord.cod-estab,
                                                INPUT tt-decla-import-ord.cod-natur-operac,
                                                INPUT tt-decla-import-ord.cod-item,
                                                INPUT tt-decla-import-ord.cdn-fornec,
                                                OUTPUT cClassTrib,
                                                OUTPUT cCST,
                                                OUTPUT cClassTrib-reg,
                                                OUTPUT cCST-reg).
                                                
        IF INPUT FRAME fPage5 c-class-trib-ibs-uf = "" THEN
            ASSIGN c-class-trib-ibs-uf      = cClassTrib
                   c-cst-ibs-uf             = cCST
                   c-class-trib-ibs-uf-reg  = cClassTrib-reg
                   c-cst-ibs-uf-reg         = cCST-reg.
    
        IF INPUT FRAME fPage5 c-class-trib-ibs-mun = "" THEN
            ASSIGN c-class-trib-ibs-mun      = cClassTrib
                   c-cst-ibs-mun             = cCST
                   c-class-trib-ibs-mun-reg  = cClassTrib-reg
                   c-cst-ibs-mun-reg         = cCST-reg.
        
        IF INPUT FRAME fPage5 c-class-trib-cbs = "" THEN
            ASSIGN c-class-trib-cbs      = cClassTrib
                   c-cst-cbs             = cCST
                   c-class-trib-cbs-reg  = cClassTrib-reg
                   c-cst-cbs-reg         = cCST-reg.
        IF INPUT FRAME fPage5 c-class-trib-is = "" AND vincideIS THEN 
            ASSIGN c-class-trib-is = cClassTrib 
                   c-cst-is        = cCST.
            ASSIGN c-class-trib-is:SCREEN-VALUE IN FRAME fPage5 = cClassTrib
                   c-cst-is:SCREEN-VALUE       IN FRAME fPage5 = cCST.
    END.

    IF INPUT FRAME fPage5 de-aliq-ibs-uf  = 0 
    OR INPUT FRAME fPage5 de-aliq-ibs-mun = 0 
    OR INPUT FRAME fPage5 de-aliq-cbs     = 0 
    OR (INPUT FRAME fpage5 de-aliq-is      = 0 AND  vincideIS) THEN DO:
        RUN pi-sugere-aliquotas IN h-imapi017 (INPUT 1, //CBS
                                               INPUT tt-decla-import-ord.cod-estab,
                                               INPUT tt-decla-import-ord.cod-natur-operac,
                                               INPUT tt-decla-import-ord.cod-item,
                                               INPUT tt-decla-import-ord.cdn-fornec,
                                               OUTPUT TABLE tt-tributo-import).
                                               
        IF CAN-FIND(FIRST tt-tributo-import 
                    WHERE tt-tributo-import.nom-trib = "CBS":U) THEN DO:
            FOR EACH tt-tributo-import 
                WHERE tt-tributo-import.nom-trib = "CBS":U NO-LOCK:
                
                IF tt-tributo-import.cod-campo = "dPercRed":U THEN
                    ASSIGN de-aliq-red-cbs:SCREEN-VALUE IN FRAME fPage5 = tt-tributo-import.cod-conteudo.
                    
                IF tt-tributo-import.cod-campo = "dAliq":U THEN 
                    ASSIGN de-aliq-cbs:SCREEN-VALUE IN FRAME fPage5 = tt-tributo-import.cod-conteudo.
                         
           END.
        END.
        
        RUN pi-sugere-aliquotas IN h-imapi017 (INPUT 2, //IBS UF
                                               INPUT tt-decla-import-ord.cod-estab,
                                               INPUT tt-decla-import-ord.cod-natur-operac,
                                               INPUT tt-decla-import-ord.cod-item,
                                               INPUT tt-decla-import-ord.cdn-fornec,
                                               OUTPUT TABLE tt-tributo-import).
        IF CAN-FIND(FIRST tt-tributo-import
                    WHERE tt-tributo-import.nom-trib = "IBS UF":U) THEN DO:
            FOR EACH tt-tributo-import 
                WHERE tt-tributo-import.nom-trib = "IBS UF":U NO-LOCK:
                
                IF tt-tributo-import.cod-campo = "dPercRed":U THEN
                    ASSIGN de-aliq-red-ibs-uf:SCREEN-VALUE IN FRAME fPage5 = tt-tributo-import.cod-conteudo.
                    
                IF tt-tributo-import.cod-campo = "dAliq":U THEN 
                    ASSIGN de-aliq-ibs-uf:SCREEN-VALUE IN FRAME fPage5 = tt-tributo-import.cod-conteudo.
            END.
        END.
        
        RUN pi-sugere-aliquotas IN h-imapi017 (INPUT 3, //IBS Mun
                                               INPUT tt-decla-import-ord.cod-estab,
                                               INPUT tt-decla-import-ord.cod-natur-operac,
                                               INPUT tt-decla-import-ord.cod-item,
                                               INPUT tt-decla-import-ord.cdn-fornec,
                                               OUTPUT TABLE tt-tributo-import).
        IF CAN-FIND(FIRST tt-tributo-import
                    WHERE tt-tributo-import.nom-trib = "IBS MUN":U) THEN DO:
            FOR EACH tt-tributo-import 
                WHERE tt-tributo-import.nom-trib = "IBS MUN":U NO-LOCK:
                
                IF tt-tributo-import.cod-campo = "dPercRed":U THEN
                    ASSIGN de-aliq-red-ibs-mun:SCREEN-VALUE IN FRAME fPage5 = tt-tributo-import.cod-conteudo.
                    
                IF tt-tributo-import.cod-campo = "dAliq":U THEN 
                    ASSIGN de-aliq-ibs-mun:SCREEN-VALUE IN FRAME fPage5 = tt-tributo-import.cod-conteudo.
            END.
        END.
        
        RUN pi-sugere-aliquotas IN h-imapi017 (INPUT 4, //IS
                                               INPUT tt-decla-import-ord.cod-estab,
                                               INPUT tt-decla-import-ord.cod-natur-operac,
                                               INPUT tt-decla-import-ord.cod-item,
                                               INPUT tt-decla-import-ord.cdn-fornec,
                                               OUTPUT TABLE tt-tributo-import) NO-ERROR.
        IF CAN-FIND(FIRST tt-tributo-import
                    WHERE tt-tributo-import.nom-trib = "IS":U) THEN DO:
            FOR EACH tt-tributo-import 
                WHERE tt-tributo-import.nom-trib = "IS":U NO-LOCK:
                    
                IF tt-tributo-import.cod-campo = "dAliq":U THEN 
                    ASSIGN de-aliq-is:SCREEN-VALUE IN FRAME fPage5 = tt-tributo-import.cod-conteudo.
                IF tt-tributo-import.cod-campo = "dAliqEspecUN":U THEN 
                    ASSIGN de-aliq-un-is:SCREEN-VALUE IN FRAME fPage5 = tt-tributo-import.cod-conteudo.
                IF tt-tributo-import.cod-campo = "cUnTrib":U THEN 
                    ASSIGN c-un-trib-is:SCREEN-VALUE IN FRAME fPage5 = tt-tributo-import.cod-conteudo.
                IF tt-tributo-import.cod-campo = "dQtdeTrib":U THEN 
                    ASSIGN de-qtde-trib-is:SCREEN-VALUE IN FRAME fPage5 = tt-tributo-import.cod-conteudo.
            END.
        END.
    END.
                
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-decla-import-ord-trib wMaintenanceNoNavigation 
PROCEDURE pi-grava-decla-import-ord-trib :
/*------------------------------------------------------------------------------
  Purpose: Cria/atualiza a tabela de extensío tt-decla-import-ord-trib
  Parameters: p-nom-trib - nome do tributo
              p-cod-campo - nome do campo
              p-cod-conteudo - valor/conteudo do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nom-trib      AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-campo     AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-conteudo  AS CHAR  NO-UNDO.
    
    EMPTY TEMP-TABLE tt-decla-import-ord-trib.
           
    IF  LOOKUP(p-cod-campo, "C-CLASS-TRIB-REG,CST-REG,ALIQ-EFETIVA-REG,ALIQ-RED") > 0
    AND (p-cod-conteudo = "" OR p-cod-conteudo = "0") THEN DO:

        RUN emptyRowObject  IN h-bocx00507.
        RUN openQueryStatic IN h-bocx00507 (INPUT "Main":U) NO-ERROR.
        RUN goToKey         IN h-bocx00507 (INPUT tt-decla-import-ord.num-di-ems,      
                                            INPUT tt-decla-import-ord.num-ordem,       
                                            INPUT tt-decla-import-ord.num-parcela,     
                                            INPUT tt-decla-import-ord.cdd-siscomex-dts,
                                            INPUT p-nom-trib,  
                                            INPUT p-cod-campo).
        IF RETURN-VALUE = "OK" THEN
            RUN deleteRecord IN h-bocx00507.
    END.
    ELSE DO:    

        FIND FIRST tt-decla-import-ord-trib
             WHERE tt-decla-import-ord-trib.num-di-ems          = tt-decla-import-ord.num-di-ems
               AND tt-decla-import-ord-trib.num-ordem           = tt-decla-import-ord.num-ordem
               AND tt-decla-import-ord-trib.num-parcela         = tt-decla-import-ord.num-parcela 
               AND tt-decla-import-ord-trib.cdd-siscomex-dts    = tt-decla-import-ord.cdd-siscomex-dts           
               AND tt-decla-import-ord-trib.nom-trib            = p-nom-trib 
               AND tt-decla-import-ord-trib.cod-campo           = p-cod-campo EXCLUSIVE-LOCK NO-ERROR.
    
        IF NOT AVAIL tt-decla-import-ord-trib THEN DO:
            CREATE tt-decla-import-ord-trib.
            ASSIGN tt-decla-import-ord-trib.num-di-ems          = tt-decla-import-ord.num-di-ems
                   tt-decla-import-ord-trib.num-ordem           = tt-decla-import-ord.num-ordem
                   tt-decla-import-ord-trib.num-parcela         = tt-decla-import-ord.num-parcela 
                   tt-decla-import-ord-trib.cdd-siscomex-dts    = tt-decla-import-ord.cdd-siscomex-dts           
                   tt-decla-import-ord-trib.nom-trib            = p-nom-trib 
                   tt-decla-import-ord-trib.cod-campo           = p-cod-campo.
                   
        END.
        ASSIGN tt-decla-import-ord-trib.cod-conteudo = p-cod-conteudo.
        
        RUN emptyRowObject  IN h-bocx00507.
        RUN openQueryStatic IN h-bocx00507 (INPUT "Main":U) NO-ERROR.
        RUN emptyRowErrors  IN h-bocx00507.
        RUN goToKey         IN h-bocx00507 (INPUT tt-decla-import-ord-trib.num-di-ems,      
                                            INPUT tt-decla-import-ord-trib.num-ordem,       
                                            INPUT tt-decla-import-ord-trib.num-parcela,     
                                            INPUT tt-decla-import-ord-trib.cdd-siscomex-dts,
                                            INPUT tt-decla-import-ord-trib.nom-trib,  
                                            INPUT tt-decla-import-ord-trib.cod-campo).
                                                
        IF  RETURN-VALUE = "NOK":U THEN DO:
            RUN setRecord    IN h-bocx00507 (INPUT TABLE tt-decla-import-ord-trib).
            RUN createRecord IN h-bocx00507.
        END.
        ELSE DO:
            RUN setRecord    IN h-bocx00507 (INPUT TABLE tt-decla-import-ord-trib).
            RUN updateRecord IN h-bocx00507.   
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recarrega-peso wMaintenanceNoNavigation 
PROCEDURE pi-recarrega-peso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run setConstraint4 in h-bocx225 (input input frame fPage0 tt-decla-import-ord.cod-embarq, input input frame fPage0 tt-decla-import-ord.cod-estab).
    run OpenQuery in h-bocx225 (input 4).
    run findFirst in h-bocx225.
    run serverSendRows in h-bocx225 (input ?, input ?, input no, input ?, output iRowsReturned, output table tt-ordens-embarque).
    RUN loadOrdensDesemb IN h-bocx225e  (INPUT TABLE tt-ordens-embarque,
                                         INPUT "",
                                         INPUT "",
                                         INPUT NO,
                                         INPUT NO,
                                         INPUT NO, /*(i-peso = 2),*/
                                         INPUT NO, /* II   */
                                         INPUT NO, /* ipi  */
                                         INPUT NO, /* icms */
                                         INPUT NO, /* pis  */
                                         INPUT NO, /* cof  */
                                         INPUT NO, /* IBS UF */
                                         INPUT NO, /* IBS Mun */
                                         INPUT NO, /* CBS */
                                         INPUT NO, /* IS */
                                         INPUT YES,
                                         INPUT YES,
                                         INPUT YES,
                                         OUTPUT TABLE tt-ordens-desemb,
                                         OUTPUT TABLE tt-bo-erro).

    FOR FIRST tt-ordens-desemb 
        WHERE tt-ordens-desemb.cod-estabel  = tt-decla-import-ord.cod-estab
        AND   tt-ordens-desemb.embarque     = tt-decla-import-ord.cod-embarq
        AND   tt-ordens-desemb.numero-ordem = tt-decla-import-ord.num-ordem
        AND   tt-ordens-desemb.parcela      = tt-decla-import-ord.num-parcela:

        ASSIGN val-peso-liq-unit:SCREEN-VALUE IN FRAME fPage1               = string(tt-ordens-desemb.de-peso-liquido-unit)
               val-peso-brut-unit:SCREEN-VALUE IN FRAME fPage1              = string(tt-ordens-desemb.de-peso-bruto)
               tt-decla-import-ord.val-cub-tot:SCREEN-VALUE IN FRAME fPage1 = string(tt-ordens-desemb.de-cubagem).

        ASSIGN tt-decla-import-ord.val-peso-liq:SCREEN-VALUE IN FRAME fPage1       = string(tt-ordens-desemb.de-peso-liquido-unit * decimal(tt-decla-import-ord.qtd-item:SCREEN-VALUE IN FRAME fPage1))
               tt-decla-import-ord.val-peso-brut-merc:SCREEN-VALUE IN FRAME fPage1 = string(tt-ordens-desemb.de-peso-bruto        * decimal(tt-decla-import-ord.qtd-item:SCREEN-VALUE IN FRAME fPage1)).
    END.
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
    /* salva os registro da tela */
    ASSIGN vRowidAuxiliar = tt-decla-import-ord.r-Rowid.
    IF c-numeroLi-aux <> INPUT FRAME fPage2 tt-decla-import-ord.cod-licenc-import
    OR dt-restric-emb <> INPUT FRAME fPage2 tt-decla-import-ord.dat-livre-1 THEN DO:
        RUN piPergunta. /* Exporta LI? */
    END. /* IF  c-numeroLi-aux <> */

    RUN pi-saveRecord.  
    RUN repositionRecord IN {&hDBOTable} (INPUT vRowidAuxiliar).
    RUN carrega-tt-quebra.   /* recarrega a temp-table com os valores iniciais */
    RUN verifica-att-quebra. /* verifica se os campos da quebra foram modificados */
    RUN saveRecord IN THIS-PROCEDURE.

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

    assign input frame fPage3 cb-idi-metod-val
           input frame fPage3 cb-idi-ind-pagto
           input frame fPage4 cb-idi-tributac-cofins
           input frame fPage4 cb-idi-tributac-icms
           input frame fPage4 cb-idi-tributac-impto-import
           input frame fPage4 cb-idi-tributac-ipi
           input frame fPage4 cb-idi-tributac-pis.

    assign tt-decla-import-ord.idi-metod-val             = {cxinc/i01cx404.i 06 cb-idi-metod-val}
           tt-decla-import-ord.idi-ind-pagto             = {cxinc/i02cx404.i 06 cb-idi-ind-pagto}
           tt-decla-import-ord.idi-tributac-cofins       = {cxinc/i01cx402.i 06 cb-idi-tributac-cofins}
           tt-decla-import-ord.idi-tributac-icms         = {cxinc/i02cx402.i 06 cb-idi-tributac-icms}
           tt-decla-import-ord.idi-tributac-impto-import = {cxinc/i01cx402.i 06 cb-idi-tributac-impto-import}
           tt-decla-import-ord.idi-tributac-ipi          = {cxinc/i01cx402.i 06 cb-idi-tributac-ipi}
           tt-decla-import-ord.idi-tributac-pis          = {cxinc/i01cx402.i 06 cb-idi-tributac-pis}
           tt-decla-import-ord.log-suspens-ipi-import    = if input frame fPage4 cb-suspens-ipi-import   = 'Sim' then yes else no
           tt-decla-import-ord.log-suspens-impto-import  = if input frame fPage4 cb-suspens-impto-import = 'Sim' then yes else no.
    
    &if '{&bf_mat_versao_ems}' >= '2.09' &then
        ASSIGN tt-decla-import-ord.log-suspens-icms   = IF INPUT FRAME fPage4 cb-suspens-icms   = 'Sim' THEN YES ELSE NO
               tt-decla-import-ord.log-suspens-pis    = IF INPUT FRAME fPage4 cb-suspens-pis    = 'Sim' THEN YES ELSE NO
               tt-decla-import-ord.log-suspens-cofins = IF INPUT FRAME fPage4 cb-suspens-cofins = 'Sim' THEN YES ELSE NO.
    &else
        ASSIGN OVERLAY(tt-decla-import-ord.cod-livre-1,1,1) = IF INPUT FRAME fPage4 cb-suspens-icms   = 'Sim' THEN '1' ELSE '2' 
               OVERLAY(tt-decla-import-ord.cod-livre-1,2,1) = IF INPUT FRAME fPage4 cb-suspens-pis    = 'Sim' THEN '1' ELSE '2' 
               OVERLAY(tt-decla-import-ord.cod-livre-1,3,1) = IF INPUT FRAME fPage4 cb-suspens-cofins = 'Sim' THEN '1' ELSE '2'.
    &endif
    
    IF lAlterouPagamento THEN DO: 

        RUN pi-atualiza-pagto-embarq IN h-bocx404(INPUT tt-decla-import-ord.cod-embarq,
                                                  INPUT tt-decla-import-ord.cod-estab,
                                                  INPUT tt-decla-import-ord.idi-ind-pagto).

        RUN pi-atualiza-pagto-ordens IN h-bocx404(INPUT tt-decla-import-ord.cod-embarq,
                                                  INPUT tt-decla-import-ord.cod-estab,
                                                  INPUT tt-decla-import-ord.idi-ind-pagto).
    END.
    
    /* Reforma Tribut†ria */
    IF l-nt2024002 THEN DO:
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSUF",  INPUT "C-CLASS-TRIB",     INPUT INPUT FRAME fPage5 c-class-trib-ibs-uf).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSUF",  INPUT "CST",              INPUT INPUT FRAME fPage5 c-cst-ibs-uf).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSUF",  INPUT "COD-TRIB",         INPUT {diinc/i01di628.i 06 cb-idi-tributac-ibs-uf:SCREEN-VALUE IN FRAME fpage5}).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSUF",  INPUT "ALIQUOTA",         INPUT INPUT FRAME fPage5 de-aliq-ibs-uf).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSUF",  INPUT "ALIQ-RED",         INPUT INPUT FRAME fPage5 de-aliq-red-ibs-uf).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSUF",  INPUT "C-CLASS-TRIB-REG", INPUT INPUT FRAME fPage5 c-class-trib-ibs-uf-reg).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSUF",  INPUT "CST-REG",          INPUT INPUT FRAME fPage5 c-cst-ibs-uf-reg).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSUF",  INPUT "ALIQ-EFETIVA-REG", INPUT INPUT FRAME fPage5 de-aliq-ibs-uf-reg).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSMUN", INPUT "C-CLASS-TRIB",     INPUT INPUT FRAME fPage5 c-class-trib-ibs-mun).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSMUN", INPUT "CST",              INPUT INPUT FRAME fPage5 c-cst-ibs-mun).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSMUN", INPUT "COD-TRIB",         INPUT {diinc/i01di628.i 06 cb-idi-tributac-ibs-mun:SCREEN-VALUE IN FRAME fpage5}).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSMUN", INPUT "ALIQUOTA",         INPUT INPUT FRAME fPage5 de-aliq-ibs-mun).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSMUN", INPUT "ALIQ-RED",         INPUT INPUT FRAME fPage5 de-aliq-red-ibs-mun).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSMUN", INPUT "C-CLASS-TRIB-REG", INPUT INPUT FRAME fPage5 c-class-trib-ibs-mun-reg).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSMUN", INPUT "CST-REG",          INPUT INPUT FRAME fPage5 c-cst-ibs-mun-reg).
        RUN pi-grava-decla-import-ord-trib (INPUT "IBSMUN", INPUT "ALIQ-EFETIVA-REG", INPUT INPUT FRAME fPage5 de-aliq-ibs-mun-reg).
        RUN pi-grava-decla-import-ord-trib (INPUT "CBS",    INPUT "C-CLASS-TRIB",     INPUT INPUT FRAME fPage5 c-class-trib-cbs).
        RUN pi-grava-decla-import-ord-trib (INPUT "CBS",    INPUT "CST",              INPUT INPUT FRAME fPage5 c-cst-cbs).
        RUN pi-grava-decla-import-ord-trib (INPUT "CBS",    INPUT "COD-TRIB",         INPUT {diinc/i01di628.i 06 cb-idi-tributac-cbs:SCREEN-VALUE IN FRAME fpage5}).
        RUN pi-grava-decla-import-ord-trib (INPUT "CBS",    INPUT "ALIQUOTA",         INPUT INPUT FRAME fPage5 de-aliq-cbs).
        RUN pi-grava-decla-import-ord-trib (INPUT "CBS",    INPUT "ALIQ-RED",         INPUT INPUT FRAME fPage5 de-aliq-red-cbs).        
        RUN pi-grava-decla-import-ord-trib (INPUT "CBS",    INPUT "C-CLASS-TRIB-REG", INPUT INPUT FRAME fPage5 c-class-trib-cbs-reg).
        RUN pi-grava-decla-import-ord-trib (INPUT "CBS",    INPUT "CST-REG",          INPUT INPUT FRAME fPage5 c-cst-cbs-reg).
        RUN pi-grava-decla-import-ord-trib (INPUT "CBS",    INPUT "ALIQ-EFETIVA-REG", INPUT INPUT FRAME fPage5 de-aliq-cbs-reg).
        RUN pi-grava-decla-import-ord-trib (INPUT "IS",     INPUT "C-CLASS-TRIB",     INPUT INPUT FRAME fPage5 c-class-trib-is).
        RUN pi-grava-decla-import-ord-trib (INPUT "IS",     INPUT "CST",              INPUT INPUT FRAME fPage5 c-cst-is).
        RUN pi-grava-decla-import-ord-trib (INPUT "IS",     INPUT "COD-TRIB",         INPUT {diinc/i01di628.i 06 cb-idi-tributac-is:SCREEN-VALUE IN FRAME fpage5}).
        RUN pi-grava-decla-import-ord-trib (INPUT "IS",     INPUT "ALIQUOTA",         INPUT INPUT FRAME fPage5 de-aliq-is).
        RUN pi-grava-decla-import-ord-trib (INPUT "IS",     INPUT "ALIQ-ESPEC-UN",    INPUT INPUT FRAME fPage5 de-aliq-un-is).
        RUN pi-grava-decla-import-ord-trib (INPUT "IS",     INPUT "QTDE-TRIBUT",      INPUT INPUT FRAME fPage5 de-qtde-trib-is).
        RUN pi-grava-decla-import-ord-trib (INPUT "IS",     INPUT "UN-TRIBUT",        INPUT INPUT FRAME fPage5 c-un-trib-is).   
    END.
    
    RETURN "OK":U.                                              
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-impostos wMaintenanceNoNavigation 
PROCEDURE pi-trata-impostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM c-campo AS CHARACTER NO-UNDO.
    DEF INPUT PARAM c-susp  AS CHARACTER NO-UNDO.

    DEF VAR c-valor         AS CHARACTER NO-UNDO.

    ASSIGN c-valor = "Outros".

    IF c-susp = "Sim" THEN DO:
        CASE c-campo:
            WHEN "icms"   THEN ASSIGN cb-idi-tributac-icms:SCREEN-VALUE   IN FRAME fPage4 = c-valor.
            WHEN "pis"    THEN ASSIGN cb-idi-tributac-pis:SCREEN-VALUE    IN FRAME fPage4 = c-valor.
            WHEN "cofins" THEN ASSIGN cb-idi-tributac-cofins:SCREEN-VALUE IN FRAME fPage4 = c-valor.
        END CASE.
    END.

              
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-tributac wMaintenanceNoNavigation 
PROCEDURE pi-valida-tributac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM c-campo    AS CHARACTER NO-UNDO.
    DEF INPUT PARAM c-tributac AS CHARACTER NO-UNDO.

    IF c-tributac <> "Outros" THEN DO:
        CASE c-campo:
            WHEN "cb-idi-tributac-icms"   THEN ASSIGN cb-suspens-icms:SCREEN-VALUE   IN FRAME fPage4 = "N∆o".
            WHEN "cb-idi-tributac-pis"    THEN ASSIGN cb-suspens-pis:SCREEN-VALUE    IN FRAME fPage4 = "N∆o".
            WHEN "cb-idi-tributac-cofins" THEN ASSIGN cb-suspens-cofins:SCREEN-VALUE IN FRAME fPage4 = "N∆o".
        END CASE.
    END.
    

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-docto wMaintenanceNoNavigation 
PROCEDURE pi-verifica-docto :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    IF  NOT VALID-HANDLE(h-bocx383a) THEN
        RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.

    RUN piDoctoRecebimento IN h-bocx383a(INPUT tt-decla-import.cod-di-siscomex, OUTPUT l-encontrou).

    IF  l-encontrou THEN DO:

        DISABLE btSave
            WITH FRAME fPage0.
        
        DISABLE tt-decla-import-ord.cdn-fornec 
                tt-decla-import-ord.log-emite-fabrican 
                tt-decla-import-ord.cdn-fabrican 
                tt-decla-import-ord.cdn-pais-proceden 
                tt-decla-import-ord.cod-item 
                tt-decla-import-ord.qtd-item 
                tt-decla-import-ord.cod-unid-med-fornec 
                tt-decla-import-ord.qtd-fornec 
                tt-decla-import-ord.cod-unid-medid-item 
                tt-decla-import-ord.val-peso-liq 
                tt-decla-import-ord.val-peso-brut-merc 
                tt-decla-import-ord.val-cub-tot 
                val-peso-liq-unit 
                val-peso-brut-unit
                btRecarregaPeso
            WITH FRAME fPage1.

        DISABLE c-cod-class-fisc 
                c-class-fisc-ex 
                d-desc-class 
                tt-decla-import-ord.cdn-naladi-sist-harmon 
                tt-decla-import-ord.cod-naladi-ncca 
                tt-decla-import-ord.cod-nbm 
                tt-decla-import-ord.cod-licenc-import 
                tt-decla-import-ord.dat-livre-1
                tt-decla-import-ord.cod-aladi 
                c-cod-incoterm 
                c-desc-incoterm 
                c-desc-nat-op 
                tt-decla-import-ord.cod-tip-recip 
                tt-decla-import-ord.qtd-capac-recip 
                tt-decla-import-ord.cod-natur-operac
            WITH FRAME fPage2.

        DISABLE d-val-vucv 
                i-cdn-moed-vucv 
                cb-idi-metod-val 
                cb-idi-ind-pagto
            WITH FRAME fPage3.

        DISABLE cb-suspens-impto-import 
                cb-suspens-ipi-import 
                cb-suspens-icms 
                cb-suspens-pis 
                cb-suspens-cofins 
                cb-idi-tributac-impto-import 
                tt-decla-import-ord.val-aliq-ii 
                tt-decla-import-ord.val-perc-reduc-impto-import 
                cb-idi-tributac-ipi 
                tt-decla-import-ord.val-aliq-ipi 
                tt-decla-import-ord.val-perc-reduc-ipi 
                tt-decla-import-ord.val-unit-ipi 
                cb-idi-tributac-icms 
                tt-decla-import-ord.val-aliq-icms 
                tt-decla-import-ord.val-perc-reduc-icms 
                cb-idi-tributac-pis 
                tt-decla-import-ord.val-aliq-pis 
                tt-decla-import-ord.val-perc-reduc-pis 
                tt-decla-import-ord.val-unit-pis 
                cb-idi-tributac-cofins 
                tt-decla-import-ord.val-aliq-cofins 
                tt-decla-import-ord.val-perc-reduc-cofins 
                tt-decla-import-ord.val-unit-cofins 
                btRecarImpostos
         WITH FRAME fPage4.

        /* Reforma Tribut†ria */   
        IF l-nt2024002 THEN
             DISABLE cb-idi-tributac-ibs-uf 
                     de-aliq-ibs-uf 
                     de-aliq-red-ibs-uf 
                     de-aliq-ibs-uf-reg
                     c-cst-ibs-uf 
                     c-class-trib-ibs-uf
                     c-cst-ibs-uf-reg
                     c-class-trib-ibs-uf-reg
                     cb-idi-tributac-ibs-mun 
                     de-aliq-ibs-mun
                     de-aliq-red-ibs-mun
                     de-aliq-ibs-mun-reg
                     c-cst-ibs-mun
                     c-class-trib-ibs-mun
                     c-cst-ibs-mun-reg
                     c-class-trib-ibs-mun-reg
                     cb-idi-tributac-cbs 
                     de-aliq-cbs 
                     de-aliq-red-cbs 
                     de-aliq-cbs-reg
                     c-cst-cbs 
                     c-class-trib-cbs
                     c-cst-cbs-reg
                     c-class-trib-cbs-reg
                     c-class-trib-is 
                     c-cst-is  
                     de-aliq-is 
                     de-aliq-un-is  
                     de-qtde-trib-is
                     c-un-trib-is  
                     cb-idi-tributac-is
                     btRecImpostosRT 
             WITH FRAME fPage5.

        ASSIGN tt-decla-import-ord.cod-especif:READ-ONLY IN FRAME fPage6 = YES. 

    END.

    IF VALID-HANDLE (h-bocx383a) THEN DO: 
        DELETE PROCEDURE h-bocx383a.
        ASSIGN h-bocx383a = ?.
    END.
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaOrdTrib wMaintenanceNoNavigation 
PROCEDURE piBuscaOrdTrib :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN setConstraintByOrdem IN h-bocx00507 (INPUT tt-decla-import-ord.num-di-ems,
                                             INPUT tt-decla-import-ord.num-ordem,
                                             INPUT tt-decla-import-ord.num-parcela,
                                             INPUT tt-decla-import-ord.cdd-siscomex-dts).
    RUN openQueryStatic      IN h-bocx00507 (INPUT 'ByOrdem':U).    
    RUN getBatchRecords      IN h-bocx00507 (INPUT  ?,
                                             INPUT  ?,
                                             INPUT  99999,
                                             OUTPUT i-reg-retornados,
                                             OUTPUT TABLE tt-decla-import-ord-trib).
                                             
    EMPTY TEMP-TABLE tt-decla-import-ord-trib-aux.
    
    /* carrega temp-table auxiliar que ser† usada na validaá∆o da alteraá∆o dos campos de quebra */
    FOR EACH tt-decla-import-ord-trib:
        CREATE tt-decla-import-ord-trib-aux.
        BUFFER-COPY tt-decla-import-ord-trib TO tt-decla-import-ord-trib-aux.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPergunta wMaintenanceNoNavigation 
PROCEDURE piPergunta :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    /* Sendo SIM ou N∂O, sempre ser† atualizado o registro atual da Ordem DI e o da LI no im0041, 
       quando clicar no SIM, tambÇm ser† exportado para os demais registros com mesma ordem e classificaá∆o fiscal */
       
    empty temp-table tt-licenciam-import-oc-aux.
    CREATE tt-licenciam-import-oc-aux.
    ASSIGN tt-licenciam-import-oc-aux.licenca-import = INPUT FRAME fPage2 tt-decla-import-ord.cod-licenc-import
           tt-licenciam-import-oc-aux.dat-livre-1    = INPUT FRAME fPage2 tt-decla-import-ord.dat-livre-1
           tt-licenciam-import-oc-aux.numero-ordem   = INPUT FRAME fPage0 tt-decla-import-ord.num-ordem
           tt-licenciam-import-oc-aux.parcela        = INPUT FRAME fPage0 tt-decla-import-ord.num-parcela
           tt-licenciam-import-oc-aux.cod-livre-1    = INPUT FRAME fPage1 tt-decla-import-ord.cod-item.

    FOR FIRST item NO-LOCK WHERE item.it-codigo = INPUT FRAME fPage1 tt-decla-import-ord.cod-item:
        ASSIGN tt-licenciam-import-oc-aux.cod-livre-2 = item.class-fiscal.
    END. /* FOR FIRST item */

    RUN openQueryStatic IN h-bocx351 (INPUT 'Main':U).
    RUN goToKey IN h-bocx351 (INPUT INPUT FRAME fPage0 tt-decla-import-ord.num-ordem, INPUT INPUT FRAME fPage0 tt-decla-import-ord.num-parcela). 
    
    IF  RETURN-VALUE = "NOK":U 
        AND INPUT FRAME fPage2 tt-decla-import-ord.cod-licenc-import <> '' THEN DO:
        RUN setRecord    IN h-bocx351 (INPUT TABLE tt-licenciam-import-oc-aux).
        RUN createRecord IN h-bocx351.
    END.
    ELSE DO:
        RUN setRecord       IN h-bocx351 (INPUT TABLE tt-licenciam-import-oc-aux).
        IF INPUT FRAME fPage2 tt-decla-import-ord.cod-licenc-import = '' THEN
            RUN deleteRecord IN h-bocx351.
        ELSE
            RUN updateRecord IN h-bocx351.   
    END.

    /*--- Dispara a pergunta se exporta ou n∆o ------------------------------------------------*/
    RUN utp/ut-msgs.p (INPUT 'show', 
                       INPUT 56586, 
                       INPUT '').
    IF  RETURN-VALUE = 'yes' THEN DO:
        run piRetornaLi in h-bocx351 (input 2,  /*Embarque Importacao*/
                                      input yes,
                                      input ?,  /*Processo Importacao*/
                                      input tt-decla-import-ord.cod-estab,
                                      input tt-decla-import-ord.cod-embarq,
                                      input ?,  /*Parcela*/
                                      input NO, /*Considera Parcelas Eliminadas*/
                                      input NO, /*Considera Parcelas Recebidas*/
                                      input 0,
                                      input 99999999,
                                      input "",
                                      input "ZZZZZZZZZZZZZZZZ",
                                      input 0,
                                      input 999999999,
                                      input "",
                                      input "ZZZZZZZZZZZZZZZZZZZZ",
                                      output table tt-licenciam-import-oc).

        FIND FIRST tt-licenciam-import-oc NO-LOCK NO-ERROR.
        if  can-find(first tt-licenciam-import-oc) then 
            RUN piExportaLI in h-bocx351 (input input frame fPage2 c-cod-class-fisc, 
                                          input input frame fPage2 tt-decla-import-ord.cod-licenc-import,
                                          input IF AVAIL tt-licenciam-import-oc THEN tt-licenciam-import-oc.dat-livre-1 ELSE ?,
                                          input table tt-licenciam-import-oc).
    END. /* IF  RETURN-VALUE = 'yes' THEN DO: */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este mÇtodo somente Ç executado quando a vari†vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    ASSIGN tt-decla-import-ord.num-di-ems = tt-decla-import.num-di-ems.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verifica-att-quebra wMaintenanceNoNavigation 
PROCEDURE verifica-att-quebra :
/*:T------------------------------------------------------------------------------
  Purpose:     verifica se os campos da quebra da adiá∆o foram atualizados e se o usu†rio quer reger†-las automaticamente.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-pergunta            AS LOGICAL         INITIAL NO         NO-UNDO.
    
    IF CAN-FIND(FIRST decla-import-adic WHERE decla-import-adic.num-di-ems       = tt-decla-import-ord.num-di-ems
                                        AND   decla-import-adic.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts) THEN
        ASSIGN l-pergunta = YES.
        
    RUN validaUpdateQuebra IN {&hDBOTable} (INPUT TABLE tt-campos-quebra,
                                            INPUT TABLE tt-decla-import-ord-aux,
                                            INPUT TABLE tt-decla-import-ord-trib-aux,
                                            OUTPUT l-quebra-alterada).
    
    RUN validaAltPesos IN {&hDBOTable} (INPUT TABLE tt-campos-quebra,
                                        INPUT TABLE tt-decla-import-ord-aux,
                                        OUTPUT l-alt-pesos).

    IF l-alt-pesos THEN DO:
        
        RUN atualiza-sitRatCalc-DI IN h-bocx383(INPUT tt-decla-import-ord.num-di-ems,
                                                INPUT tt-decla-import-ord.cdd-siscomex-dts,
                                                INPUT "NO", 
                                                INPUT "NO", 
                                                INPUT "NO").
        
        {utp/ut-liter.i "Os valores dos pesos foram alterados! Por isso, o c†lculo dos Impostos e o Rateio das Despesas ser∆o reabertos!" *}
        RUN utp/ut-msgs.p ( INPUT "show",
                            INPUT 19085,
                            INPUT return-value).
    END.

    IF l-quebra-alterada THEN DO:
        RUN pi-deleta-relacs IN {&hDBOTable} (INPUT tt-decla-import-ord.num-di-ems,
                                              INPUT tt-decla-import-ord.cdd-siscomex-dts).
        
        ASSIGN tt-decla-import-ord.num-seq  = 0
               tt-decla-import-ord.num-adic = 0
               tt-decla-import-ord.num-adic:SCREEN-VALUE IN FRAME fPage0 = "0". 
        
        IF l-pergunta THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-as-adicoes-serao-eliminadas-de AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "As_Adiá‰es_ser∆o_eliminadas._Deseja_ger†-las_novamente?" *}
            ASSIGN c-lbl-liter-as-adicoes-serao-eliminadas-de = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-foram-alterados-campos-que-faz AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Foram_alterados_campos_que_fazem_parte_da_rotina_de_quebra_das_adiá‰es!_As_adiá‰es_ser∆o_eliminadas_para_que_sejam_considerados_os_novos_valores" *}
            ASSIGN c-lbl-liter-foram-alterados-campos-que-faz = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p (INPUT 'show',
                               INPUT 27100,
                               INPUT c-lbl-liter-as-adicoes-serao-eliminadas-de
                                      + '~~' + 
                                     c-lbl-liter-foram-alterados-campos-que-faz + '.').
                                                                   
            IF RETURN-VALUE = "YES" THEN
                RUN pi-seta-l-quebra-alterada IN {&hDBOTable} (INPUT YES).
            ELSE
                RUN pi-seta-l-quebra-alterada IN {&hDBOTable} (INPUT NO).
        END.
        ELSE 
            RUN pi-seta-l-quebra-alterada IN {&hDBOTable} (INPUT NO).
        
    END.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

