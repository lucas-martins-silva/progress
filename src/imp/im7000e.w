&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic NO-UNDO LIKE decla-import-adic
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic-itens NO-UNDO LIKE decla-import-adic-itens
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-ord NO-UNDO LIKE decla-import-ord
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-acres-deduc-it NO-UNDO LIKE duimp-acres-deduc-it
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-item NO-UNDO LIKE duimp-item
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-siscomex NO-UNDO LIKE duimp-siscomex
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-tributo-it NO-UNDO LIKE duimp-tributo-it
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM7000E 2.00.00.016} /* 16/09/2026 15:58:58 */

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM7000E MIM}
&ENDIF                                                            

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM7000E
&GLOBAL-DEFINE Version           2.00.00.016

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1    

&GLOBAL-DEFINE FolderLabels      Dados, Mercadoria, Cond.Venda, Cambiais, Valores, Impostos, Tributos

&GLOBAL-DEFINE ttTable           tt-decla-import-ord
&GLOBAL-DEFINE hDBOTable         h-bocx404
&GLOBAL-DEFINE DBOTable          decla-import-ord

&GLOBAL-DEFINE ttParent          tt-decla-import
&GLOBAL-DEFINE DBOParentTable    decla-import

&GLOBAL-DEFINE page0KeyFields    tt-duimp-item.cod-duimp-dts tt-decla-import-ord.cod-estab tt-decla-import-ord.num-adic ~
                                 tt-decla-import-ord.num-ordem tt-decla-import-ord.cod-item c-cod-duimp-siscomex tt-decla-import-ord.cod-embarq
&GLOBAL-DEFINE page0Fields        
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       tt-duimp-item.ni-responsavel cb-caract-import tt-duimp-item.num-identific ~
                                 cb-ind-vincul cb-export-fabric tt-duimp-item.cdn-exporta tt-duimp-item.cdn-fabrican ~
                                 tt-duimp-item.versao-exporta tt-duimp-item.versao-fabric tt-duimp-item.ni-oper-exporta ~
                                 tt-duimp-item.ni-oper-fabric tt-duimp-item.cod-pais-iso-exporta tt-duimp-item.cod-pais-iso-fabric
&GLOBAL-DEFINE page2Fields       cb-aplicacao cb-condicao tt-duimp-item.unid-com tt-duimp-item.peso-liq ~
                                 tt-duimp-item.qtd-com tt-duimp-item.qtd-med tt-duimp-item.vlr-unit-mo tt-duimp-item.desc-comp 
&GLOBAL-DEFINE page3Fields       tt-duimp-item.cod-met-valora tt-duimp-item.compl-incoterm
&GLOBAL-DEFINE page3Browse       brAcresDeduc 
&GLOBAL-DEFINE page3Widgets      btAddAcresDeduc btUpdateAcresDeduc btCancelAcresDeduc btSaveAcresDeduc btDeleteAcresDeduc
&GLOBAL-DEFINE page4Fields       cb-cobertura tt-duimp-item.cod-mot-sem-cob tt-duimp-item.cod-institut-finan ~
                                 tt-duimp-item.val-cob-camb tt-duimp-item.numero-rof
&GLOBAL-DEFINE page5Fields       d-val-vmcv-me1 c-cdn-moed-vmcv d-val-vmcv-me2 d-val-vmcv ~
                                 d-val-vmle-me1 c-cdn-moed-vmle d-val-vmle-me2 d-val-vmle ~
                                 d-val-vmld-me1 c-cdn-moed-vmld d-val-vmld-me2 d-val-vmld ~
                                 d-val-frete-me1 c-cdn-moed-frete d-val-frete-me2 d-val-frete ~
                                 d-val-seguro-me1 c-cdn-moed-seguro d-val-seguro-me2 d-val-seguro ~
                                 d-val-acresc-me1 c-cdn-moed-acresc d-val-acresc-me2 d-val-acresc ~
                                 label-valores label-moeda label-dolar label-reais label-vmcv label-vmle label-vmld label-frete label-seguro label-acresc 
&GLOBAL-DEFINE page6Fields       label-tributac label-aliq label-susp label-reduc label-vl-unit label-base-calc label-valor label-ii label-ipi label-icms label-pis label-cofins ~
                                 label-fcp label-fcp-st label-icms-compl label-icms-st cb-idi-tributac-impto-import cb-suspens-impto-import cb-suspens-icms cb-suspens-pis cb-suspens-cofins ~
                                 tt-decla-import-adic.val-aliq-ii tt-decla-import-adic.val-perc-reduc-impto-import tt-decla-import-adic.val-base-ii d-valor-impostos-ii cb-idi-tributac-ipi ~
                                 tt-decla-import-adic.val-aliq-ipi cb-suspens-ipi-import tt-decla-import-adic.val-perc-reduc-ipi tt-decla-import-adic.val-unit-ipi ~
                                 tt-decla-import-adic.val-base-ipi d-valor-impostos-ipi cb-idi-tributac-icms tt-decla-import-adic.val-aliq-icms ~
                                 tt-decla-import-adic.val-perc-reduc-icms tt-decla-import-adic.val-base-icms d-valor-impostos-icms cb-idi-tributac-pis ~
                                 tt-decla-import-adic.val-aliq-pis tt-decla-import-adic.val-perc-reduc-pis tt-decla-import-adic.val-unit-pis ~
                                 tt-decla-import-adic.val-base-pis d-valor-impostos-pis cb-idi-tributac-cofins tt-decla-import-adic.val-aliq-cofins ~
                                 tt-decla-import-adic.val-perc-reduc-cofins tt-decla-import-adic.val-unit-cofins tt-decla-import-adic.val-base-cofins d-valor-impostos-cofins 
&GLOBAL-DEFINE page7Browse       brTributos 


/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-return              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tipo                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-desc-moeda          AS CHARACTER  FORMAT "x(12)":U   NO-UNDO.
DEFINE VARIABLE c-desc-AcreDed        AS CHARACTER  FORMAT "x(40)":U   NO-UNDO.
DEFINE VARIABLE i-seq-acres-deduc     AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-add-acres-deduc     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i-linhas-return       AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-tributo             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-formato             AS CHARACTER  FORMAT "x(19)":U   NO-UNDO.
DEFINE VARIABLE c-cnpj-cpf            AS CHARACTER  FORMAT "x(19)":U   NO-UNDO.
DEFINE VARIABLE c-formato-cpf         AS CHARACTER  FORMAT "x(19)":U   NO-UNDO.
DEFINE VARIABLE c-formato-id-federal  AS CHARACTER  FORMAT "x(19)":U   NO-UNDO.
DEFINE VARIABLE c-moeda-iso4217       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-emitente            AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-num-linha-browse    AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-ni-oper-exporta     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-pais-iso-exporta AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-versao-exporta      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-tipo-contr          AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-char-aux            AS CHAR       NO-UNDO.
DEFINE VARIABLE c-nbs-limpo           AS CHAR       NO-UNDO.

/*--- Variaveis definidas para que se possa utilizar o zoom 
      feito em Smart Objects ---*/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
/*-----------------------------------------------------------------*/

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin172     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin682     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin046     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad098     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00490   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00492   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boun005     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boun006     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx402     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx403     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00496   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00495   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00497   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00488   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00480   AS HANDLE NO-UNDO.
DEFINE VARIABLE i-trib-ibsuf  AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE i-trib-ibsmun AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE i-trib-cbs    AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE h-bocx00479   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bodi01157   AS HANDLE NO-UNDO.

DEFINE VARIABLE l-nt2024002   AS LOGICAL           NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).
                              
/* Definiá∆o temp-tables */
{cxbo/bocx00497.i tt-duimp-tributo-it-aux}
{cxbo/bocx00479.i tt-emitente-siscomex}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brAcresDeduc

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-duimp-acres-deduc-it tt-duimp-tributo-it

/* Definitions for BROWSE brAcresDeduc                                  */
&Scoped-define FIELDS-IN-QUERY-brAcresDeduc ~
tt-duimp-acres-deduc-it.seq-acres-deduc tt-duimp-acres-deduc-it.idi-tipo ~
fnTipo(tt-duimp-acres-deduc-it.idi-tipo) @ c-tipo ~
tt-duimp-acres-deduc-it.cdn-acres-deduc ~
fnAcresDeduc(tt-duimp-acres-deduc-it.idi-tipo, tt-duimp-acres-deduc-it.cdn-acres-deduc) @ c-desc-AcreDed ~
tt-duimp-acres-deduc-it.cdn-moeda ~
fnMoeda(int(tt-duimp-acres-deduc-it.cdn-moeda)) @ c-desc-moeda ~
tt-duimp-acres-deduc-it.valor 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brAcresDeduc ~
tt-duimp-acres-deduc-it.idi-tipo tt-duimp-acres-deduc-it.cdn-acres-deduc ~
tt-duimp-acres-deduc-it.cdn-moeda tt-duimp-acres-deduc-it.valor 
&Scoped-define ENABLED-TABLES-IN-QUERY-brAcresDeduc tt-duimp-acres-deduc-it
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brAcresDeduc tt-duimp-acres-deduc-it
&Scoped-define QUERY-STRING-brAcresDeduc FOR EACH tt-duimp-acres-deduc-it NO-LOCK ~
    BY tt-duimp-acres-deduc-it.seq-acres-deduc INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brAcresDeduc OPEN QUERY brAcresDeduc FOR EACH tt-duimp-acres-deduc-it NO-LOCK ~
    BY tt-duimp-acres-deduc-it.seq-acres-deduc INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brAcresDeduc tt-duimp-acres-deduc-it
&Scoped-define FIRST-TABLE-IN-QUERY-brAcresDeduc tt-duimp-acres-deduc-it


/* Definitions for BROWSE brTributo                                     */
&Scoped-define FIELDS-IN-QUERY-brTributo tt-duimp-tributo-it.seq-tributo ~
fnTributo(tt-duimp-tributo-it.idi-tributo) @ c-tributo ~
tt-duimp-tributo-it.regime tt-duimp-tributo-it.fundamento ~
tt-duimp-tributo-it.cod-atributo tt-duimp-tributo-it.valor 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTributo tt-duimp-tributo-it.regime ~
tt-duimp-tributo-it.fundamento 
&Scoped-define ENABLED-TABLES-IN-QUERY-brTributo tt-duimp-tributo-it
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brTributo tt-duimp-tributo-it
&Scoped-define QUERY-STRING-brTributo FOR EACH tt-duimp-tributo-it NO-LOCK ~
    BY tt-duimp-tributo-it.seq-tributo INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTributo OPEN QUERY brTributo FOR EACH tt-duimp-tributo-it NO-LOCK ~
    BY tt-duimp-tributo-it.seq-tributo INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTributo tt-duimp-tributo-it
&Scoped-define FIRST-TABLE-IN-QUERY-brTributo tt-duimp-tributo-it


/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brAcresDeduc}

/* Definitions for FRAME fpage7                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage7 ~
    ~{&OPEN-QUERY-brTributo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-duimp-item.cod-duimp-dts ~
tt-decla-import-ord.num-adic tt-decla-import-ord.cod-item 
&Scoped-define ENABLED-TABLES tt-duimp-item tt-decla-import-ord
&Scoped-define FIRST-ENABLED-TABLE tt-duimp-item
&Scoped-define SECOND-ENABLED-TABLE tt-decla-import-ord
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar c-cod-duimp-siscomex btOK ~
btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-decla-import-ord.cod-estab ~
tt-duimp-item.cod-duimp-dts tt-decla-import-ord.num-adic ~
tt-decla-import-ord.num-ordem tt-decla-import-ord.cod-embarq ~
tt-decla-import-ord.cod-item 
&Scoped-define DISPLAYED-TABLES tt-decla-import-ord tt-duimp-item
&Scoped-define FIRST-DISPLAYED-TABLE tt-decla-import-ord
&Scoped-define SECOND-DISPLAYED-TABLE tt-duimp-item
&Scoped-Define DISPLAYED-OBJECTS c-cod-duimp-siscomex c-desc-item 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnAcresDeduc wMaintenanceNoNavigation 
FUNCTION fnAcresDeduc RETURNS CHARACTER
  ( pTipo AS INTEGER, pCodigo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMoeda wMaintenanceNoNavigation 
FUNCTION fnMoeda RETURNS CHARACTER
  ( pMoeda AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipo wMaintenanceNoNavigation 
FUNCTION fnTipo RETURNS CHARACTER
  ( pTipo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTributo wMaintenanceNoNavigation 
FUNCTION fnTributo RETURNS CHARACTER
  ( pTributo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
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

DEFINE VARIABLE c-cod-duimp-siscomex AS CHARACTER FORMAT "x(15)" 
     LABEL "DUIMP Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.43 BY 3.63.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cb-caract-import AS CHARACTER FORMAT "X(256)":U 
     LABEL "Caracterizaá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 33 BY 1 NO-UNDO.

DEFINE VARIABLE cb-export-fabric AS CHARACTER FORMAT "X(256)":U 
     LABEL "Relaá∆o Exportador Fabricante" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 33 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ind-vincul AS CHARACTER FORMAT "X(256)":U 
     LABEL "Vinculaá∆o Comprador Vendedor" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 33 BY 1 NO-UNDO.

DEFINE VARIABLE c-ender-export AS CHARACTER FORMAT "X(80)":U 
     LABEL "Endereáo" 
     VIEW-AS FILL-IN 
     SIZE 74.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-ender-fabric AS CHARACTER FORMAT "X(80)":U 
     LABEL "Endereáo" 
     VIEW-AS FILL-IN 
     SIZE 74.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-adquirente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-export AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-fabric AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-pais-export AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-pais-fabric AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 3.79.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 3.75.

DEFINE VARIABLE cb-aplicacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Aplicaá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE cb-condicao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Condiá∆o Mercadoria" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-ncm AS CHARACTER FORMAT "9999.99.99":U 
     LABEL "NCM" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-versao AS CHARACTER FORMAT "X(8)" 
     LABEL "Vers∆o" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE c-desc-class-fiscal AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 42.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-nbs AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 42.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda-iso AS CHARACTER FORMAT "X(3)":U 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda-neg AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-nbs AS CHARACTER FORMAT "x(20)":U 
     LABEL "NBS" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE fi-municipio AS CHARACTER FORMAT "x(50)":U 
     LABEL "Local de Consumo" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .88 NO-UNDO.

DEFINE VARIABLE fi-uf AS CHARACTER FORMAT "x(2)":U 
     LABEL "UF" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE de-cdd-item-siscomex AS DECIMAL FORMAT ">>>>>>>>>9":U INITIAL 0 
     LABEL "Item Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE i-mo-codigo AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Moeda" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88.

DEFINE BUTTON btAddAcresDeduc 
     IMAGE-UP FILE "image/im-add.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-add.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Incluir".

DEFINE BUTTON btCancelAcresDeduc 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Cancelar".

DEFINE BUTTON btDeleteAcresDeduc 
     IMAGE-UP FILE "image/im-era.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-era.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Eliminar".

DEFINE BUTTON btSaveAcresDeduc 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sav.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Salvar".

DEFINE BUTTON btUpdateAcresDeduc 
     IMAGE-UP FILE "image/im-clr.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-clr.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Modificar".

DEFINE VARIABLE c-desc-metodo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .88 NO-UNDO.

DEFINE VARIABLE c-incoterm AS CHARACTER FORMAT "x(3)" 
     LABEL "Incoterm" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.86 BY 7.

DEFINE VARIABLE cb-cobertura AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cobertura Cambial" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-instituicao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-motivo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .88 NO-UNDO.

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

DEFINE VARIABLE label-acresc AS CHARACTER FORMAT "X(256)":U INITIAL "AcrÇscimos" 
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

DEFINE BUTTON btTributos 
     LABEL "Tributos" 
     SIZE 10 BY 1.

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
     LIST-ITEMS "Sim","N∆o" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-icms AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","N∆o" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-impto-import AS CHARACTER FORMAT "X(256)":U INITIAL "N∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","N∆o" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-ipi-import AS CHARACTER FORMAT "X(256)":U INITIAL "N∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","N∆o" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE cb-suspens-pis AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Sim","N∆o" 
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

DEFINE VARIABLE label-aliq AS CHARACTER FORMAT "X(256)":U INITIAL "Al°quota" 
      VIEW-AS TEXT 
     SIZE 6.57 BY .67 NO-UNDO.

DEFINE VARIABLE label-base-calc AS CHARACTER FORMAT "X(256)":U INITIAL "Base C†lculo" 
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

DEFINE VARIABLE label-reduc AS CHARACTER FORMAT "X(256)":U INITIAL "Reduá∆o" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE label-susp AS CHARACTER FORMAT "X(256)":U INITIAL "Suspenso" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE label-tributac AS CHARACTER FORMAT "X(256)":U INITIAL "Tributaá∆o" 
      VIEW-AS TEXT 
     SIZE 8.43 BY .67 NO-UNDO.

DEFINE VARIABLE label-valor AS CHARACTER FORMAT "X(256)":U INITIAL "Valor" 
      VIEW-AS TEXT 
     SIZE 4.29 BY .67 NO-UNDO.

DEFINE VARIABLE label-vl-unit AS CHARACTER FORMAT "X(256)":U INITIAL "Vl. Unit. Imp." 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 13.5.

DEFINE BUTTON btCancelTributo 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Cancelar".

DEFINE BUTTON btSaveTributo 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sav.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Salvar".

DEFINE BUTTON btUpdateTributo 
     IMAGE-UP FILE "image/im-clr.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-clr.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Modificar".

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brAcresDeduc FOR 
      tt-duimp-acres-deduc-it SCROLLING.

DEFINE QUERY brTributo FOR 
      tt-duimp-tributo-it SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brAcresDeduc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brAcresDeduc wMaintenanceNoNavigation _STRUCTURED
  QUERY brAcresDeduc NO-LOCK DISPLAY
      tt-duimp-acres-deduc-it.seq-acres-deduc COLUMN-LABEL "Seq" FORMAT ">>9":U
            WIDTH 3
      tt-duimp-acres-deduc-it.idi-tipo COLUMN-LABEL "Tipo" FORMAT ">9":U
      fnTipo(tt-duimp-acres-deduc-it.idi-tipo) @ c-tipo COLUMN-LABEL "Descriá∆o" FORMAT "x(10)":U
            WIDTH 10
      tt-duimp-acres-deduc-it.cdn-acres-deduc COLUMN-LABEL "C¢digo" FORMAT ">9":U
            WIDTH 5
      fnAcresDeduc(tt-duimp-acres-deduc-it.idi-tipo, tt-duimp-acres-deduc-it.cdn-acres-deduc) @ c-desc-AcreDed COLUMN-LABEL "Descriá∆o" FORMAT "x(40)":U
            WIDTH 12
      tt-duimp-acres-deduc-it.cdn-moeda COLUMN-LABEL "Moeda" FORMAT "x(3)":U
            WIDTH 5
      fnMoeda(int(tt-duimp-acres-deduc-it.cdn-moeda)) @ c-desc-moeda COLUMN-LABEL "Descriá∆o" FORMAT "x(12)":U
            WIDTH 12
      tt-duimp-acres-deduc-it.valor COLUMN-LABEL "Valor" FORMAT ">>>,>>>,>>>,>>9.99":U
            WIDTH 18
  ENABLE
      tt-duimp-acres-deduc-it.idi-tipo HELP "Tipo de Operaá∆o (1-AcrÇscimo 2-Deduá∆o)"
      tt-duimp-acres-deduc-it.cdn-acres-deduc
      tt-duimp-acres-deduc-it.cdn-moeda
      tt-duimp-acres-deduc-it.valor
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 79.72 BY 6.38
         FONT 1.

DEFINE BROWSE brTributo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTributo wMaintenanceNoNavigation _STRUCTURED
  QUERY brTributo NO-LOCK DISPLAY
      tt-duimp-tributo-it.seq-tributo COLUMN-LABEL "Seq" FORMAT ">>>>9":U
            WIDTH 3
      fnTributo(tt-duimp-tributo-it.idi-tributo) @ c-tributo COLUMN-LABEL "Tributo" FORMAT "x(15)":U
            WIDTH 15
      tt-duimp-tributo-it.regime COLUMN-LABEL "Regime" FORMAT ">>>>9":U
            WIDTH 6
      tt-duimp-tributo-it.fundamento COLUMN-LABEL "Fundamento" FORMAT ">>>>9":U
            WIDTH 9
      tt-duimp-tributo-it.cod-atributo FORMAT "x(20)":U
      tt-duimp-tributo-it.valor FORMAT "x(20)":U WIDTH 24.57
  ENABLE
      tt-duimp-tributo-it.regime
      tt-duimp-tributo-it.fundamento
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 11.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-decla-import-ord.cod-estab AT ROW 1.42 COL 12.72 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-duimp-item.cod-duimp-dts AT ROW 1.42 COL 38 COLON-ALIGNED WIDGET-ID 30
          LABEL "N£mero Interno DUIMP"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     c-cod-duimp-siscomex AT ROW 1.42 COL 71.86 COLON-ALIGNED HELP
          "C¢digo da Declaraá∆o Ènica de Importaá∆o Siscomex" WIDGET-ID 12
     tt-decla-import-ord.num-adic AT ROW 2.42 COL 12.72 COLON-ALIGNED WIDGET-ID 32
          LABEL "Seq"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-decla-import-ord.num-ordem AT ROW 2.42 COL 38 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-decla-import-ord.cod-embarq AT ROW 2.42 COL 71.86 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     tt-decla-import-ord.cod-item AT ROW 3.42 COL 12.72 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     c-desc-item AT ROW 3.42 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     btOK AT ROW 21 COL 2
     btSave AT ROW 21 COL 13
     btCancel AT ROW 21 COL 24
     btHelp AT ROW 21 COL 80
     rtKeys AT ROW 1.13 COL 1.29
     rtToolBar AT ROW 20.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.86 BY 21.67
         FONT 1 WIDGET-ID 100.


DEFINE FRAME fPage2
     de-cdd-item-siscomex AT ROW 1.25 COL 15 COLON-ALIGNED WIDGET-ID 42
     c-cod-versao AT ROW 1.25 COL 38.29 COLON-ALIGNED WIDGET-ID 36
     c-cod-ncm AT ROW 2.25 COL 15 COLON-ALIGNED WIDGET-ID 38
     c-desc-class-fiscal AT ROW 2.25 COL 38.29 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     c-nbs AT ROW 3.25 COL 15 COLON-ALIGNED WIDGET-ID 44
     c-desc-nbs AT ROW 3.25 COL 38.29 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     cb-aplicacao AT ROW 4.25 COL 15 COLON-ALIGNED WIDGET-ID 26
     cb-condicao AT ROW 4.25 COL 64 COLON-ALIGNED WIDGET-ID 28
     tt-duimp-item.unid-com AT ROW 5.25 COL 15 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     tt-duimp-item.qtd-com AT ROW 5.25 COL 64 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-duimp-item.peso-liq AT ROW 6.25 COL 15 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     tt-duimp-item.qtd-med AT ROW 6.25 COL 64 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     i-mo-codigo AT ROW 7.25 COL 15 COLON-ALIGNED WIDGET-ID 12
     c-moeda-neg AT ROW 7.25 COL 18.29 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     c-moeda-iso AT ROW 7.25 COL 33.57 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     tt-duimp-item.vlr-unit-mo AT ROW 7.25 COL 64 COLON-ALIGNED WIDGET-ID 22
          LABEL "Valor Unit†rio Moeda Negociada"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     fi-municipio AT ROW 8.25 COL 15 COLON-ALIGNED WIDGET-ID 202
     fi-uf AT ROW 8.25 COL 38.29 COLON-ALIGNED NO-LABEL WIDGET-ID 200
     tt-duimp-item.desc-comp AT ROW 9.25 COL 17 NO-LABEL WIDGET-ID 24
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 66 BY 4.75
     "Desc. Complementar:" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 9.25 COL 2 WIDGET-ID 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 5.5
         SIZE 88 BY 14.35
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     tt-duimp-item.cod-met-valora AT ROW 1.25 COL 17 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .88
     c-desc-metodo AT ROW 1.25 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     c-incoterm AT ROW 2.25 COL 17 COLON-ALIGNED HELP
          "C¢digo da Condiá∆o de Venda - Incoterm" WIDGET-ID 36
     tt-duimp-item.compl-incoterm AT ROW 3.25 COL 19 NO-LABEL WIDGET-ID 30
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 65 BY 2.5
     brAcresDeduc AT ROW 6.63 COL 3 WIDGET-ID 500
     btAddAcresDeduc AT ROW 6.63 COL 83 WIDGET-ID 10
     btUpdateAcresDeduc AT ROW 7.88 COL 83 WIDGET-ID 18
     btCancelAcresDeduc AT ROW 9.13 COL 83 WIDGET-ID 12
     btSaveAcresDeduc AT ROW 10.38 COL 83 WIDGET-ID 16
     btDeleteAcresDeduc AT ROW 11.63 COL 83 WIDGET-ID 14
     "Complemento Incoterm:" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 3.38 COL 2.72 WIDGET-ID 34
     " AcrÇscimos/Deduá‰es" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 5.96 COL 3.72 WIDGET-ID 28
     RECT-3 AT ROW 6.33 COL 2 WIDGET-ID 26
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 5.5
         SIZE 88 BY 14.35
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage1
     tt-duimp-item.ni-responsavel AT ROW 1.25 COL 17.72 COLON-ALIGNED HELP
          "Informe a Raiz do CNPJ ou CPF do Respons†vel" WIDGET-ID 16
          LABEL "CNPJ/CPF Respons†vel"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     cb-caract-import AT ROW 1.21 COL 49.14 COLON-ALIGNED WIDGET-ID 30
     tt-duimp-item.num-identific AT ROW 2.25 COL 17.72 COLON-ALIGNED WIDGET-ID 18
          LABEL "Adquirente"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     c-nome-adquirente AT ROW 2.25 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     cb-ind-vincul AT ROW 3.25 COL 23.72 COLON-ALIGNED WIDGET-ID 32
     cb-export-fabric AT ROW 4.25 COL 23.72 COLON-ALIGNED WIDGET-ID 34
     tt-duimp-item.cdn-fabrican AT ROW 6.13 COL 7.72 COLON-ALIGNED WIDGET-ID 36
          LABEL "C¢digo"
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     c-nome-fabric AT ROW 6.13 COL 33.14 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     tt-duimp-item.versao-fabric AT ROW 7.13 COL 7.72 COLON-ALIGNED WIDGET-ID 48
          LABEL "Vers∆o"
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     tt-duimp-item.ni-oper-fabric AT ROW 7.13 COL 33.14 COLON-ALIGNED HELP
          "Informe N£mero Identificaá∆o (TIN) do Operador Fabricante" WIDGET-ID 44
          LABEL "N£mero Identificaá∆o"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-duimp-item.cod-pais-iso-fabric AT ROW 7.13 COL 58.86 COLON-ALIGNED WIDGET-ID 40
          LABEL "Pa°s ISO"
          VIEW-AS FILL-IN 
          SIZE 3 BY .88
     c-pais-fabric AT ROW 7.13 COL 62.14 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     c-ender-fabric AT ROW 8.13 COL 7.72 COLON-ALIGNED WIDGET-ID 70
     tt-duimp-item.cdn-exporta AT ROW 10.42 COL 7.72 COLON-ALIGNED WIDGET-ID 6
          LABEL "C¢digo"
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     c-nome-export AT ROW 10.42 COL 33.29 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     tt-duimp-item.versao-exporta AT ROW 11.42 COL 7.72 COLON-ALIGNED WIDGET-ID 46
          LABEL "Vers∆o"
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     tt-duimp-item.ni-oper-exporta AT ROW 11.42 COL 33.14 COLON-ALIGNED HELP
          "Informe o N£mero Identificaá∆o (CPF/CNPJ/TIN) do Exportador" WIDGET-ID 42
          LABEL "N£mero Identificaá∆o"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-duimp-item.cod-pais-iso-exporta AT ROW 11.42 COL 58.86 COLON-ALIGNED WIDGET-ID 38
          LABEL "Pa°s ISO"
          VIEW-AS FILL-IN 
          SIZE 3 BY .88
     c-pais-export AT ROW 11.42 COL 62.14 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     c-ender-export AT ROW 12.42 COL 7.72 COLON-ALIGNED WIDGET-ID 72
     " Fabricante" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 5.42 COL 3 WIDGET-ID 60
     " Exportador" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 9.71 COL 2.86 WIDGET-ID 62
     RECT-1 AT ROW 5.71 COL 1.86 WIDGET-ID 56
     RECT-2 AT ROW 10 COL 1.72 WIDGET-ID 58
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 5.5
         SIZE 88 BY 14.35
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage5
     d-val-vmcv-me1 AT ROW 2.5 COL 13 COLON-ALIGNED HELP
          "Valor Mercadoria Condiá∆o Venda moeda estrangeira" NO-LABEL WIDGET-ID 206
     c-cdn-moed-vmcv AT ROW 2.5 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 180
     d-val-vmcv-me2 AT ROW 2.5 COL 47 COLON-ALIGNED HELP
          "Valor Mercadoria Condiá∆o Venda moeda estrangeira" NO-LABEL WIDGET-ID 208
     d-val-vmcv AT ROW 2.5 COL 64 COLON-ALIGNED HELP
          "Valor Mercadoria na Condiá∆o Venda" NO-LABEL WIDGET-ID 204
     d-val-vmle-me1 AT ROW 3.5 COL 13 COLON-ALIGNED HELP
          "Valor VMLE ME" NO-LABEL WIDGET-ID 218
     c-cdn-moed-vmle AT ROW 3.5 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 184
     d-val-vmle-me2 AT ROW 3.5 COL 47 COLON-ALIGNED HELP
          "Valor VMLE ME" NO-LABEL WIDGET-ID 220
     d-val-vmle AT ROW 3.5 COL 64 COLON-ALIGNED HELP
          "Valor VMLE" NO-LABEL WIDGET-ID 216
     d-val-vmld-me1 AT ROW 4.5 COL 13 COLON-ALIGNED HELP
          "Valor mercadoria local de despacho ME" NO-LABEL WIDGET-ID 212
     c-cdn-moed-vmld AT ROW 4.5 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 182
     d-val-vmld-me2 AT ROW 4.5 COL 47 COLON-ALIGNED HELP
          "Valor mercadoria local de despacho ME" NO-LABEL WIDGET-ID 214
     d-val-vmld AT ROW 4.5 COL 64 COLON-ALIGNED HELP
          "Valor mercadoria no local despacho" NO-LABEL WIDGET-ID 210
     d-val-frete-me1 AT ROW 5.5 COL 13 COLON-ALIGNED HELP
          "Valor Frete moeda estrangeira" NO-LABEL WIDGET-ID 194
     c-cdn-moed-frete AT ROW 5.5 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 176
     d-val-frete-me2 AT ROW 5.5 COL 47 COLON-ALIGNED HELP
          "Valor Frete moeda estrangeira" NO-LABEL WIDGET-ID 196
     d-val-frete AT ROW 5.5 COL 64 COLON-ALIGNED HELP
          "Informe o valor do frete" NO-LABEL WIDGET-ID 192
     d-val-seguro-me1 AT ROW 6.5 COL 13 COLON-ALIGNED HELP
          "Valor Seguro Moeda Estrangeira" NO-LABEL WIDGET-ID 200
     c-cdn-moed-seguro AT ROW 6.5 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 178
     d-val-seguro-me2 AT ROW 6.5 COL 47 COLON-ALIGNED HELP
          "Valor Seguro Moeda Estrangeira" NO-LABEL WIDGET-ID 202
     d-val-seguro AT ROW 6.5 COL 64 COLON-ALIGNED HELP
          "Valor do seguro" NO-LABEL WIDGET-ID 198
     d-val-acresc-me2 AT ROW 7.5 COL 13 COLON-ALIGNED HELP
          "Valor AcrÇscimo Moeda Estrangeiro" NO-LABEL WIDGET-ID 190
     c-cdn-moed-acresc AT ROW 7.5 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 174
     d-val-acresc-me1 AT ROW 7.5 COL 47 COLON-ALIGNED HELP
          "Valor AcrÇscimo Moeda Estrangeiro" NO-LABEL WIDGET-ID 188
     d-val-acresc AT ROW 7.5 COL 64 COLON-ALIGNED HELP
          "Valor AcrÇscimo" NO-LABEL WIDGET-ID 186
     label-valores AT ROW 1.5 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 234
     label-moeda AT ROW 1.5 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 228
     label-dolar AT ROW 1.5 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 224
     label-reais AT ROW 1.5 COL 71 COLON-ALIGNED NO-LABEL WIDGET-ID 230
     label-vmcv AT ROW 2.5 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 236
     label-vmle AT ROW 3.5 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 240
     label-vmld AT ROW 4.5 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 238
     label-frete AT ROW 5.5 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 226
     label-seguro AT ROW 6.5 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 232
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 5.5
         SIZE 88 BY 14.35
         FONT 1 WIDGET-ID 400.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage5
     label-acresc AT ROW 7.5 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 222
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 5.5
         SIZE 88 BY 14.35
         FONT 1 WIDGET-ID 400.

DEFINE FRAME fPage4
     cb-cobertura AT ROW 1.25 COL 25.43 COLON-ALIGNED WIDGET-ID 16
     tt-duimp-item.cod-mot-sem-cob AT ROW 2.25 COL 25.43 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .88
     c-desc-motivo AT ROW 2.25 COL 30.57 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     tt-duimp-item.cod-institut-finan AT ROW 3.25 COL 25.43 COLON-ALIGNED WIDGET-ID 8
          LABEL "Instituiá∆o Financiadora"
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .88
     c-desc-instituicao AT ROW 3.25 COL 30.57 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     tt-duimp-item.val-cob-camb AT ROW 4.25 COL 25.43 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-duimp-item.numero-rof AT ROW 5.25 COL 25.43 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 5.5
         SIZE 88 BY 14.35
         FONT 1 WIDGET-ID 300.

DEFINE FRAME fpage7
     brTributo AT ROW 1.5 COL 2 WIDGET-ID 600
     btUpdateTributo AT ROW 1.54 COL 80.43 WIDGET-ID 18
     btCancelTributo AT ROW 2.79 COL 80.43 WIDGET-ID 12
     btSaveTributo AT ROW 4.04 COL 80.43 WIDGET-ID 16
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.57 ROW 5.5
         SIZE 88 BY 14.35
         FONT 1 WIDGET-ID 800.

DEFINE FRAME fPage6
     cb-idi-tributac-impto-import AT ROW 2.5 COL 8 COLON-ALIGNED HELP
          "Informar a Tributaá∆o do Imposto de Importaá∆o" NO-LABEL WIDGET-ID 176
     tt-decla-import-adic.val-aliq-ii AT ROW 2.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 232 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-impto-import AT ROW 2.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 186
     tt-decla-import-adic.val-perc-reduc-impto-import AT ROW 2.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 252 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic.val-base-ii AT ROW 2.5 COL 53.14 COLON-ALIGNED NO-LABEL WIDGET-ID 242 FORMAT ">,>>>,>>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-ii AT ROW 2.5 COL 68 COLON-ALIGNED HELP
          "Valor II" NO-LABEL WIDGET-ID 196
     cb-idi-tributac-ipi AT ROW 3.5 COL 8 COLON-ALIGNED HELP
          "C¢digo de tributaá∆o do IPI" NO-LABEL WIDGET-ID 178
     tt-decla-import-adic.val-aliq-ipi AT ROW 3.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 234 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-ipi-import AT ROW 3.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 188
     tt-decla-import-adic.val-perc-reduc-ipi AT ROW 3.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 254 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic.val-unit-ipi AT ROW 3.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 260
          VIEW-AS FILL-IN 
          SIZE 9.57 BY .88
     tt-decla-import-adic.val-base-ipi AT ROW 3.5 COL 53.14 COLON-ALIGNED NO-LABEL WIDGET-ID 244 FORMAT ">,>>>,>>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-ipi AT ROW 3.5 COL 68 COLON-ALIGNED HELP
          "Valor IPI" NO-LABEL WIDGET-ID 198
     cb-idi-tributac-icms AT ROW 4.5 COL 8 COLON-ALIGNED HELP
          "C¢digo de tributaá∆o do ICMS" NO-LABEL WIDGET-ID 174
     tt-decla-import-adic.val-aliq-icms AT ROW 4.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 230 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-icms AT ROW 4.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 184
     tt-decla-import-adic.val-perc-reduc-icms AT ROW 4.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 250 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic.val-base-icms AT ROW 4.5 COL 53.14 COLON-ALIGNED NO-LABEL WIDGET-ID 240 FORMAT ">,>>>,>>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-icms AT ROW 4.5 COL 68.14 COLON-ALIGNED HELP
          "Valor ICMS" NO-LABEL WIDGET-ID 194
     cb-idi-tributac-pis AT ROW 5.5 COL 8 COLON-ALIGNED HELP
          "C¢digo de Tributaá∆o PIS" NO-LABEL WIDGET-ID 180
     tt-decla-import-adic.val-aliq-pis AT ROW 5.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 236 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-pis AT ROW 5.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 190
     tt-decla-import-adic.val-perc-reduc-pis AT ROW 5.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 256 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic.val-unit-pis AT ROW 5.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 262 FORMAT ">>,>>>,>>>,>>>,>>9.99999"
          VIEW-AS FILL-IN 
          SIZE 9.57 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 5.5
         SIZE 88 BY 14.35
         FONT 1 WIDGET-ID 600.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage6
     tt-decla-import-adic.val-base-pis AT ROW 5.5 COL 53.14 COLON-ALIGNED NO-LABEL WIDGET-ID 246 FORMAT ">,>>>,>>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-pis AT ROW 5.5 COL 68 COLON-ALIGNED HELP
          "Valor PIS" NO-LABEL WIDGET-ID 200
     cb-idi-tributac-cofins AT ROW 6.5 COL 8 COLON-ALIGNED HELP
          "C¢digo de Tributaá∆o COFINS" NO-LABEL WIDGET-ID 264
     tt-decla-import-adic.val-aliq-cofins AT ROW 6.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 228 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     cb-suspens-cofins AT ROW 6.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 182
     tt-decla-import-adic.val-perc-reduc-cofins AT ROW 6.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 248 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-decla-import-adic.val-unit-cofins AT ROW 6.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 258 FORMAT ">>,>>>,>>>,>>>,>>>,>>9.99999"
          VIEW-AS FILL-IN 
          SIZE 9.57 BY .88
     tt-decla-import-adic.val-base-cofins AT ROW 6.5 COL 53.14 COLON-ALIGNED NO-LABEL WIDGET-ID 238 FORMAT ">,>>>,>>>,>>9.99999999"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     d-valor-impostos-cofins AT ROW 6.5 COL 68 COLON-ALIGNED HELP
          "Valor Cofins" NO-LABEL WIDGET-ID 192
     de-val-aliq-fcp AT ROW 7.5 COL 21 COLON-ALIGNED HELP
          "Al°quota Fundo de Combate Ö Pobreza" NO-LABEL WIDGET-ID 266
     de-val-base-fcp AT ROW 7.5 COL 53.14 COLON-ALIGNED HELP
          "Base de C†lculo do Fundo de Combate Ö Pobreza" NO-LABEL WIDGET-ID 270
     de-val-fcp AT ROW 7.5 COL 68 COLON-ALIGNED HELP
          "Valor Fundo de Combate Ö Pobreza" NO-LABEL WIDGET-ID 278
     de-val-aliq-fcp-substto AT ROW 8.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 268
     de-val-base-fcp-substto AT ROW 8.5 COL 53.14 COLON-ALIGNED HELP
          "Base do FCP ST" NO-LABEL WIDGET-ID 272
     de-val-fcp-substto AT ROW 8.5 COL 68 COLON-ALIGNED HELP
          "Valor do FCP ST" NO-LABEL WIDGET-ID 280
     de-val-base-icms-substto AT ROW 9.5 COL 53.14 COLON-ALIGNED HELP
          "Base ICMS Substituto" NO-LABEL WIDGET-ID 276
     de-val-icms-substto AT ROW 9.5 COL 68 COLON-ALIGNED HELP
          "Valor ICMS Substituto" NO-LABEL WIDGET-ID 284
     de-val-base-icms-compltar AT ROW 10.5 COL 53.14 COLON-ALIGNED HELP
          "Base ICMS Complementar" NO-LABEL WIDGET-ID 274
     de-val-icms-compltar AT ROW 10.5 COL 68 COLON-ALIGNED HELP
          "Valor ICMS Complementar" NO-LABEL WIDGET-ID 282
     btTributos AT ROW 12 COL 74 HELP
          "Tributos" WIDGET-ID 298
     label-tributac AT ROW 1.5 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 220
     label-aliq AT ROW 1.5 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 202
     label-susp AT ROW 1.5 COL 28.72 COLON-ALIGNED NO-LABEL WIDGET-ID 218
     label-reduc AT ROW 1.5 COL 36.43 COLON-ALIGNED NO-LABEL WIDGET-ID 216
     label-vl-unit AT ROW 1.5 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 224
     label-base-calc AT ROW 1.5 COL 56 COLON-ALIGNED NO-LABEL WIDGET-ID 204
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 5.5
         SIZE 88 BY 14.35
         FONT 1 WIDGET-ID 600.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage6
     label-valor AT ROW 1.5 COL 74.86 COLON-ALIGNED NO-LABEL WIDGET-ID 222
     label-ii AT ROW 2.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 210
     label-ipi AT ROW 3.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 212
     label-icms AT ROW 4.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 208
     label-pis AT ROW 5.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 214
     label-cofins AT ROW 6.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 206
     label-fcp AT ROW 7.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 286
     label-fcp-st AT ROW 8.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 288
     label-icms-st AT ROW 9.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 292
     label-icms-compl AT ROW 10.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 290
     RECT-30 AT ROW 1.25 COL 2 WIDGET-ID 296
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.5 ROW 5.5
         SIZE 88 BY 14.35
         FONT 1 WIDGET-ID 600.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decla-import T "?" NO-UNDO mgcex decla-import
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic T "?" NO-UNDO mgcex decla-import-adic
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic-itens T "?" NO-UNDO mgcex decla-import-adic-itens
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-ord T "?" NO-UNDO mgcex decla-import-ord
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-duimp-acres-deduc-it T "?" NO-UNDO mgcex duimp-acres-deduc-it
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-duimp-item T "?" NO-UNDO mgcex duimp-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-duimp-siscomex T "?" NO-UNDO mgcex duimp-siscomex
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-duimp-tributo-it T "?" NO-UNDO mgcex duimp-tributo-it
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
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
         HEIGHT             = 21.63
         WIDTH              = 91
         MAX-HEIGHT         = 25.04
         MAX-WIDTH          = 145.57
         VIRTUAL-HEIGHT     = 25.04
         VIRTUAL-WIDTH      = 145.57
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
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE
       FRAME fpage7:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-item.cod-duimp-dts IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cod-embarq IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.cod-estab IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.num-adic IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-ord.num-ordem IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FILL-IN c-nome-adquirente IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-export IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-fabric IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-pais-export IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-pais-fabric IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-item.cdn-exporta IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-item.cdn-fabrican IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-item.cod-pais-iso-exporta IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-item.cod-pais-iso-fabric IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-item.ni-oper-exporta IN FRAME fPage1
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR FILL-IN tt-duimp-item.ni-oper-fabric IN FRAME fPage1
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR FILL-IN tt-duimp-item.ni-responsavel IN FRAME fPage1
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR FILL-IN tt-duimp-item.num-identific IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-item.versao-exporta IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-item.versao-fabric IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-moeda-iso IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda-neg IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-item.vlr-unit-mo IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brAcresDeduc compl-incoterm fPage3 */
ASSIGN 
       brAcresDeduc:COLUMN-MOVABLE IN FRAME fPage3         = TRUE.

/* SETTINGS FOR FILL-IN c-desc-metodo IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-incoterm IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN c-desc-instituicao IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-motivo IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-duimp-item.cod-institut-finan IN FRAME fPage4
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* SETTINGS FOR FILL-IN label-acresc IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-dolar IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-frete IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-moeda IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-reais IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-seguro IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-valores IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-vmcv IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-vmld IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-vmle IN FRAME fPage5
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage6
                                                                        */
/* SETTINGS FOR FILL-IN label-aliq IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-base-calc IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-cofins IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-fcp IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-fcp-st IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-icms IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-icms-compl IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-icms-st IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-ii IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-ipi IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-pis IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-reduc IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-susp IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-tributac IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-valor IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN label-vl-unit IN FRAME fPage6
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-aliq-cofins IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-aliq-icms IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-aliq-ii IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-aliq-ipi IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-aliq-pis IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-base-cofins IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-base-icms IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-base-ii IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-base-ipi IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-base-pis IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-perc-reduc-cofins IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-perc-reduc-icms IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-perc-reduc-impto-import IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-perc-reduc-ipi IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-perc-reduc-pis IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-unit-cofins IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-decla-import-adic.val-unit-pis IN FRAME fPage6
   EXP-FORMAT                                                           */
/* SETTINGS FOR FRAME fpage7
                                                                        */
/* BROWSE-TAB brTributo 1 fpage7 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brAcresDeduc
/* Query rebuild information for BROWSE brAcresDeduc
     _TblList          = "Temp-Tables.tt-duimp-acres-deduc-it"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-duimp-acres-deduc-it.seq-acres-deduc|yes"
     _FldNameList[1]   > Temp-Tables.tt-duimp-acres-deduc-it.seq-acres-deduc
"tt-duimp-acres-deduc-it.seq-acres-deduc" "Seq" ">>9" "integer" ? ? ? ? ? ? no ? no no "3" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-duimp-acres-deduc-it.idi-tipo
"tt-duimp-acres-deduc-it.idi-tipo" "Tipo" ? "integer" ? ? ? ? ? ? yes "Tipo de Operaá∆o (1-AcrÇscimo 2-Deduá∆o)" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fnTipo(tt-duimp-acres-deduc-it.idi-tipo) @ c-tipo" "Descriá∆o" "x(10)" ? ? ? ? ? ? ? no "Descriá∆o do Tipo de Operaá∆o" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-duimp-acres-deduc-it.cdn-acres-deduc
"tt-duimp-acres-deduc-it.cdn-acres-deduc" "C¢digo" ? "integer" ? ? ? ? ? ? yes ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fnAcresDeduc(tt-duimp-acres-deduc-it.idi-tipo, tt-duimp-acres-deduc-it.cdn-acres-deduc) @ c-desc-AcreDed" "Descriá∆o" "x(40)" ? ? ? ? ? ? ? no "Descriá∆o do AcrÇscimo/Deduá∆o" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-duimp-acres-deduc-it.cdn-moeda
"tt-duimp-acres-deduc-it.cdn-moeda" "Moeda" ? "character" ? ? ? ? ? ? yes ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fnMoeda(int(tt-duimp-acres-deduc-it.cdn-moeda)) @ c-desc-moeda" "Descriá∆o" "x(12)" ? ? ? ? ? ? ? no "Descriá∆o da Moeda" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-duimp-acres-deduc-it.valor
"tt-duimp-acres-deduc-it.valor" "Valor" ? "decimal" ? ? ? ? ? ? yes ? no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brAcresDeduc */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTributo
/* Query rebuild information for BROWSE brTributo
     _TblList          = "Temp-Tables.tt-duimp-tributo-it"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-duimp-tributo-it.seq-tributo|yes"
     _FldNameList[1]   > Temp-Tables.tt-duimp-tributo-it.seq-tributo
"tt-duimp-tributo-it.seq-tributo" "Seq" ? "integer" ? ? ? ? ? ? no ? no no "3" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fnTributo(tt-duimp-tributo-it.idi-tributo) @ c-tributo" "Tributo" "x(15)" ? ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-duimp-tributo-it.regime
"tt-duimp-tributo-it.regime" "Regime" ? "integer" ? ? ? ? ? ? yes ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-duimp-tributo-it.fundamento
"tt-duimp-tributo-it.fundamento" "Fundamento" ? "integer" ? ? ? ? ? ? yes ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.tt-duimp-tributo-it.cod-atributo
     _FldNameList[6]   > Temp-Tables.tt-duimp-tributo-it.valor
"tt-duimp-tributo-it.valor" ? ? "character" ? ? ? ? ? ? no ? no no "24.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTributo */
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
     _Options          = "SHARE-LOCK KEEP-EMPTY"
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage7
/* Query rebuild information for FRAME fpage7
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage7 */
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


&Scoped-define BROWSE-NAME brAcresDeduc
&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME brAcresDeduc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAcresDeduc wMaintenanceNoNavigation
ON END-ERROR OF brAcresDeduc IN FRAME fPage3
DO:
    IF brAcresDeduc:NEW-ROW IN FRAME fPage3 THEN DO:
        IF AVAIL tt-duimp-acres-deduc-it THEN
            DELETE tt-duimp-acres-deduc-it.
        IF brAcresDeduc:DELETE-CURRENT-ROW() IN FRAME fPage3 THEN. 
    END.
    ELSE DO:
        GET CURRENT brAcresDeduc.
        DISP tt-duimp-acres-deduc-it.seq-acres-deduc
             tt-duimp-acres-deduc-it.idi-tipo
             tt-duimp-acres-deduc-it.cdn-acres-deduc
             tt-duimp-acres-deduc-it.cdn-moeda
             tt-duimp-acres-deduc-it.valor
             WITH BROWSE brAcresDeduc. 
    END.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAcresDeduc wMaintenanceNoNavigation
ON INS OF brAcresDeduc IN FRAME fPage3
DO:
  APPLY "CHOOSE":U to btAddAcresDeduc IN FRAME fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAcresDeduc wMaintenanceNoNavigation
ON OFF-END OF brAcresDeduc IN FRAME fPage3
DO:
  APPLY "ENTRY":U TO btSaveAcresDeduc IN FRAME fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAcresDeduc wMaintenanceNoNavigation
ON ROW-LEAVE OF brAcresDeduc IN FRAME fPage3
DO:
    DO TRANSACTION ON ERROR UNDO, RETURN NO-APPLY:
        IF brAcresDeduc:NEW-ROW IN frame fPage3 THEN DO:
            IF NOT CAN-FIND (FIRST tt-duimp-acres-deduc-it
                             WHERE tt-duimp-acres-deduc-it.cod-duimp-dts   = tt-duimp-item.cod-duimp-dts      
                             AND   tt-duimp-acres-deduc-it.cod-item        = tt-duimp-item.cod-item
                             AND   tt-duimp-acres-deduc-it.seq-item        = tt-duimp-item.seq-item
                             AND   tt-duimp-acres-deduc-it.seq-acres-deduc = INPUT BROWSE brAcresDeduc tt-duimp-acres-deduc-it.seq-acres-deduc) THEN DO:
                CREATE tt-duimp-acres-deduc-it.
                ASSIGN tt-duimp-acres-deduc-it.cod-duimp-dts   = tt-duimp-item.cod-duimp-dts               
                       tt-duimp-acres-deduc-it.cod-item        = tt-duimp-item.cod-item          
                       tt-duimp-acres-deduc-it.seq-item        = tt-duimp-item.seq-item 
                       INPUT BROWSE brAcresDeduc tt-duimp-acres-deduc-it.seq-acres-deduc
                       INPUT BROWSE brAcresDeduc tt-duimp-acres-deduc-it.idi-tipo
                       INPUT BROWSE brAcresDeduc tt-duimp-acres-deduc-it.cdn-acres-deduc
                       INPUT BROWSE brAcresDeduc tt-duimp-acres-deduc-it.cdn-moeda
                       INPUT BROWSE brAcresDeduc tt-duimp-acres-deduc-it.valor.
            END.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddAcresDeduc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddAcresDeduc wMaintenanceNoNavigation
ON CHOOSE OF btAddAcresDeduc IN FRAME fPage3
DO:
   RUN piAddAcresDeduc.
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


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btCancelAcresDeduc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancelAcresDeduc wMaintenanceNoNavigation
ON CHOOSE OF btCancelAcresDeduc IN FRAME fPage3
DO:
   RUN piCancelAcresDeduc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage7
&Scoped-define SELF-NAME btCancelTributo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancelTributo wMaintenanceNoNavigation
ON CHOOSE OF btCancelTributo IN FRAME fpage7
DO:
   RUN piCancelTributo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btDeleteAcresDeduc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteAcresDeduc wMaintenanceNoNavigation
ON CHOOSE OF btDeleteAcresDeduc IN FRAME fPage3
DO:
   RUN piDeleteAcresDeduc.  
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


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    IF tt-duimp-item.nro-docto = "":U THEN DO:
        IF tt-duimp-item.cdn-fabrican:SCREEN-VALUE IN FRAME fPage1 = "" 
        OR tt-duimp-item.cdn-exporta:SCREEN-VALUE IN FRAME fPage1 = "" THEN DO:
            {utp/ut-liter.i C¢digo_Fabricante/Exportador * }
            RUN utp/ut-msgs.p (INPUT 'show',
                               INPUT '57315',
                               INPUT RETURN-VALUE).
            RETURN "NOK":U.
        END.

        ASSIGN c-nbs-limpo = REPLACE(c-nbs:SCREEN-VALUE IN FRAME fpage2,".","").
        IF  c-nbs-limpo <> ""
        AND NOT CAN-FIND(FIRST cad-nbs
                         WHERE cad-nbs.cod-nbs = c-nbs-limpo) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 2,
                               INPUT "NBS":U + "~~" + c-nbs:SCREEN-VALUE IN FRAME fpage2).
            RETURN "NOK":U.
        END.
        
        RUN saveRecord IN THIS-PROCEDURE.
        IF RETURN-VALUE = "OK":U THEN
            APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
    ELSE
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btSaveAcresDeduc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaveAcresDeduc wMaintenanceNoNavigation
ON CHOOSE OF btSaveAcresDeduc IN FRAME fPage3
DO:
   RUN piSaveAcresDeduc.
   IF RETURN-VALUE = "NOK" THEN DO:
        RETURN NO-APPLY.       
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage7
&Scoped-define SELF-NAME btSaveTributo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaveTributo wMaintenanceNoNavigation
ON CHOOSE OF btSaveTributo IN FRAME fpage7
DO:
   RUN piSaveTributo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btTributos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btTributos wMaintenanceNoNavigation
ON CHOOSE OF btTributos IN FRAME fPage6 /* Tributos */
DO:
    
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN imp/im7000et.w (INPUT tt-decla-import-ord.cod-estab:SCREEN-VALUE IN FRAME fPage0,
                         INPUT tt-duimp-item.cod-duimp-dts:SCREEN-VALUE IN FRAME fPage0,
                         INPUT c-cod-duimp-siscomex:SCREEN-VALUE IN FRAME fPage0,
                         INPUT tt-decla-import-ord.num-adic:SCREEN-VALUE IN FRAME fPage0,
                         INPUT tt-decla-import-ord.num-ordem:SCREEN-VALUE IN FRAME fPage0,
                         INPUT tt-decla-import-ord.cod-embarq:SCREEN-VALUE IN FRAME fPage0,
                         INPUT tt-decla-import-ord.cod-item:SCREEN-VALUE IN FRAME fPage0,
                         INPUT c-desc-item:SCREEN-VALUE IN FRAME fPage0,
                         INPUT tt-decla-import-adic.num-di-ems,
                         INPUT tt-decla-import-adic.num-adic,
                         INPUT tt-decla-import-adic.cdd-siscomex-dts,
                         INPUT tt-decla-import-ord.num-ordem,
                         INPUT tt-decla-import-ord.num-parcela,
                         INPUT tt-decla-import-ord.num-seq).
       
                            
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btUpdateAcresDeduc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateAcresDeduc wMaintenanceNoNavigation
ON CHOOSE OF btUpdateAcresDeduc IN FRAME fPage3
DO:
   RUN piUpdateAcresDeduc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage7
&Scoped-define SELF-NAME btUpdateTributo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateTributo wMaintenanceNoNavigation
ON CHOOSE OF btUpdateTributo IN FRAME fpage7
DO:
   RUN piUpdateTributo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME c-nbs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nbs wMaintenanceNoNavigation
ON F5 OF c-nbs IN FRAME fPage2 /* NBS */
DO:
   {method/zoomfields.i &ProgramZoom="dizoom/z01di01157.w"
                         &FieldZoom1="cod-nbs"
                         &FieldScreen1="c-nbs"
                         &Frame1="fpage2"
                         &FieldZoom2="desc-nbs"
                         &FieldScreen2="c-desc-nbs"
                         &Frame2="fpage2"
                         &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nbs wMaintenanceNoNavigation
ON LEAVE OF c-nbs IN FRAME fPage2 /* NBS */
DO:
    ASSIGN c-nbs-limpo = REPLACE(c-nbs:SCREEN-VALUE IN FRAME fpage2,".","").

    IF  c-nbs-limpo <> ""
    AND LENGTH(c-nbs-limpo) >= 9 THEN
       ASSIGN c-nbs:FORMAT IN FRAME fpage2 = "9.9999.99.99" NO-ERROR.
    ELSE 
       ASSIGN c-nbs:FORMAT IN FRAME fpage2 = "x(9)" NO-ERROR.
              
    {method/referencefields.i &HandleDBOLeave="h-bodi01157"
                              &KeyValue1="c-nbs-limpo"
                              &FieldName1="desc-nbs"
                              &FieldScreen1="c-desc-nbs"
                              &Frame1="fpage2"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nbs wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-nbs IN FRAME fPage2 /* NBS */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME fi-municipio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-municipio wMaintenanceNoNavigation
ON F5 OF fi-municipio IN FRAME fPage2 /* Local de Consumo */
DO:
   {method/zoomfields.i &ProgramZoom="dizoom/z01di341.w"
                        &FieldZoom1="cidade"
                        &FieldScreen1="fi-municipio"
                        &Frame1="fPage2"
                        &FieldZoom2="estado"
                        &FieldScreen2="fi-uf"
                        &Frame2="fPage2"
                        &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-municipio wMaintenanceNoNavigation
ON LEAVE OF fi-municipio IN FRAME fPage2 /* Local de Consumo */
DO:
    FOR FIRST cidade FIELDS(estado) NO-LOCK
        WHERE cidade.cidade = INPUT FRAME fPage2 fi-municipio:
    END.
    ASSIGN fi-uf:SCREEN-VALUE IN FRAME fPage2 = IF AVAIL cidade THEN cidade.estado ELSE "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-municipio wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-municipio IN FRAME fPage2 /* Local de Consumo */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-caract-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-caract-import wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-caract-import IN FRAME fPage1 /* Caracterizaá∆o */
DO:
  ASSIGN INPUT FRAME fPage1 cb-caract-import.
  IF {cxinc/i01cx00488.i 06 cb-caract-import} = 1 THEN
      DISABLE tt-duimp-item.num-identific WITH FRAME fPage1.
  ELSE
      ENABLE tt-duimp-item.num-identific WITH FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME cb-cobertura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cobertura wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-cobertura IN FRAME fPage4 /* Cobertura Cambial */
DO:
  ASSIGN INPUT FRAME fPage4 cb-cobertura.
  IF {cxinc/i07cx00488.i 06 cb-cobertura} = 4 /* Sem cobertura */ THEN
      ENABLE tt-duimp-item.cod-mot-sem-cob WITH FRAME fPage4.
  ELSE DO:
      ASSIGN tt-duimp-item.cod-mot-sem-cob:SCREEN-VALUE IN FRAME fPage4 = "0"
             c-desc-motivo:SCREEN-VALUE IN FRAME fPage4 = "".
      DISABLE tt-duimp-item.cod-mot-sem-cob WITH FRAME fPage4.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-export-fabric
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-export-fabric wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-export-fabric IN FRAME fPage1 /* Relaá∆o Exportador Fabricante */
DO:
  ASSIGN INPUT FRAME fPage1 cb-export-fabric.
  IF {cxinc/i02cx00488.i 06 cb-export-fabric} = 1 /* Diferente*/ THEN DO:
     ENABLE tt-duimp-item.cdn-exporta
            tt-duimp-item.versao-exporta
            tt-duimp-item.ni-oper-exporta
            tt-duimp-item.cod-pais-iso-exporta WITH FRAME fPage1.
  END.
  ELSE DO:
     ASSIGN tt-duimp-item.cdn-exporta:SCREEN-VALUE IN FRAME fPage1          = INPUT FRAME fPage1 tt-duimp-item.cdn-fabrican
            tt-duimp-item.versao-exporta:SCREEN-VALUE IN FRAME fPage1       = INPUT FRAME fPage1 tt-duimp-item.versao-fabric
            tt-duimp-item.ni-oper-exporta:SCREEN-VALUE IN FRAME fPage1      = INPUT FRAME fPage1 tt-duimp-item.ni-oper-fabric
            tt-duimp-item.cod-pais-iso-exporta:SCREEN-VALUE IN FRAME fPage1 = INPUT FRAME fPage1 tt-duimp-item.cod-pais-iso-fabric
            c-nome-export:SCREEN-VALUE IN FRAME fPage1                      = INPUT FRAME fPage1 c-nome-fabric
            c-pais-export:SCREEN-VALUE IN FRAME fPage1                      = INPUT FRAME fPage1 c-pais-fabric.

     DISABLE tt-duimp-item.cdn-exporta
             tt-duimp-item.versao-exporta
             tt-duimp-item.ni-oper-exporta
             tt-duimp-item.cod-pais-iso-exporta WITH FRAME fPage1.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-duimp-item.cdn-exporta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cdn-exporta wMaintenanceNoNavigation
ON F5 OF tt-duimp-item.cdn-exporta IN FRAME fPage1 /* C¢digo */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                     &campo="tt-duimp-item.cdn-exporta"
                     &campozoom="cod-emitente"
                     &frame="fPage1"
                     &campo2="c-nome-export"
                     &campozoom2="nome-abrev"
                     &frame2="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cdn-exporta wMaintenanceNoNavigation
ON LEAVE OF tt-duimp-item.cdn-exporta IN FRAME fPage1 /* C¢digo */
DO:
    EMPTY TEMP-TABLE tt-emitente-siscomex.
    
    IF tt-duimp-item.cdn-exporta:SCREEN-VALUE IN FRAME fPage1 <> "" THEN DO:
        FIND FIRST emitente WHERE emitente.cod-emitente = int(tt-duimp-item.cdn-exporta:SCREEN-VALUE IN FRAME fPage1) NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
            {method/referencefields.i &HandleDBOLeave="h-boad098"
                                      &FindMethod="findEmitente2"
                                      &KeyValue1="int(tt-duimp-item.cdn-exporta:SCREEN-VALUE IN FRAME fPage1)"
                                      &FieldName1="nome-abrev" 
                                      &FieldScreen1="c-nome-export"
                                      &Frame1="fPage1"
                                      &FieldName2="endereco" 
                                      &FieldScreen2="c-ender-export"
                                      &Frame2="fPage1"}
            
            RUN goToKey IN h-bocx00479 (INPUT INPUT FRAME fPage1 tt-duimp-item.cdn-exporta).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN h-bocx00479 (INPUT "cod-cnpj-cpf":U, OUTPUT c-ni-oper-exporta).
                RUN getCharField IN h-bocx00479 (INPUT "cod-pais-iso":U, OUTPUT c-cod-pais-iso-exporta).
                RUN getCharField IN h-bocx00479 (INPUT "cod-versao":U,   OUTPUT c-versao-exporta).
                ASSIGN tt-duimp-item.ni-oper-exporta   :SCREEN-VALUE IN FRAME fPage1  = c-ni-oper-exporta
                       tt-duimp-item.cod-pais-iso-exporta:SCREEN-VALUE IN FRAME fPage1  = c-cod-pais-iso-exporta
                       tt-duimp-item.versao-exporta      :SCREEN-VALUE IN FRAME fPage1  = c-versao-exporta.
                
            END.
        END.
        ELSE DO:   
            {utp/ut-liter.i Exportador *}
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 54461,
                               INPUT RETURN-VALUE).

            RETURN NO-APPLY.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cdn-exporta wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-duimp-item.cdn-exporta IN FRAME fPage1 /* C¢digo */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-duimp-item.cdn-fabrican
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cdn-fabrican wMaintenanceNoNavigation
ON F5 OF tt-duimp-item.cdn-fabrican IN FRAME fPage1 /* C¢digo */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                     &campo="tt-duimp-item.cdn-fabrican"
                     &campozoom="cod-emitente"
                     &frame="fPage1"
                     &campo2="c-nome-fabric"
                     &campozoom2="nome-abrev"
                     &frame2="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cdn-fabrican wMaintenanceNoNavigation
ON LEAVE OF tt-duimp-item.cdn-fabrican IN FRAME fPage1 /* C¢digo */
DO:
    IF tt-duimp-item.cdn-fabrican:SCREEN-VALUE IN FRAME fPage1 <> "" THEN DO:
        FIND FIRST emitente WHERE emitente.cod-emitente = int(tt-duimp-item.cdn-fabrican:SCREEN-VALUE IN FRAME fPage1) NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
            
            {method/referencefields.i &HandleDBOLeave="h-boad098"
                                      &FindMethod="findEmitente2"
                                      &KeyValue1="int(tt-duimp-item.cdn-fabrican:SCREEN-VALUE IN FRAME fPage1)"
                                      &FieldName1="nome-abrev" 
                                      &FieldScreen1="c-nome-fabric"
                                      &Frame1="fPage1"
                                      &FieldName2="endereco" 
                                      &FieldScreen2="c-ender-fabric"
                                      &Frame2="fPage1"}   
        
            ASSIGN INPUT FRAME fpage1 cb-export-fabric.
            IF {cxinc/i02cx00488.i 06 cb-export-fabric} = 2 /* igual */ THEN
                ASSIGN tt-duimp-item.cdn-exporta:SCREEN-VALUE IN FRAME fPage1 = INPUT FRAME fPage1 tt-duimp-item.cdn-fabrican
                       c-nome-export:SCREEN-VALUE IN FRAME fPage1             = INPUT FRAME fpage1 c-nome-fabric
                       c-ender-export:SCREEN-VALUE IN FRAME fPage1            = INPUT FRAME fPage1 c-ender-fabric.
                       
                       
        END.
        ELSE DO:
            {utp/ut-liter.i Fabricante *}
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 54461,
                               INPUT RETURN-VALUE).

            RETURN NO-APPLY.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cdn-fabrican wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-duimp-item.cdn-fabrican IN FRAME fPage1 /* C¢digo */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tt-duimp-item.cod-institut-finan
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-institut-finan wMaintenanceNoNavigation
ON F5 OF tt-duimp-item.cod-institut-finan IN FRAME fPage4 /* Instituiá∆o Financiadora */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z01cx00495.w"
                         &FieldZoom1="codigo"
                         &FieldScreen1="tt-duimp-item.cod-institut-finan"
                         &Frame1="fPage4"
                         &FieldZoom2="descricao"
                         &FieldScreen2="c-desc-instituicao"
                         &Frame2="fPage4"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-institut-finan wMaintenanceNoNavigation
ON LEAVE OF tt-duimp-item.cod-institut-finan IN FRAME fPage4 /* Instituiá∆o Financiadora */
DO:
    {method/referencefields.i &HandleDBOLeave="h-bocx00495"
                              &KeyValue1="int(tt-duimp-item.cod-institut-finan:SCREEN-VALUE IN FRAME fPage4)"
                              &FieldName1="descricao" 
                              &FieldScreen1="c-desc-instituicao"
                              &Frame1="fPage4"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-institut-finan wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-duimp-item.cod-institut-finan IN FRAME fPage4 /* Instituiá∆o Financiadora */
DO:
   APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME tt-duimp-item.cod-met-valora
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-met-valora wMaintenanceNoNavigation
ON F5 OF tt-duimp-item.cod-met-valora IN FRAME fPage3 /* MÇtodo Valoraá∆o */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z01cx00490.w"
                         &FieldZoom1="cod-met-val"
                         &FieldScreen1="tt-duimp-item.cod-met-valora"
                         &Frame1="fPage3"
                         &FieldZoom2="descricao"
                         &FieldScreen2="c-desc-metodo"
                         &Frame2="fPage3"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-met-valora wMaintenanceNoNavigation
ON LEAVE OF tt-duimp-item.cod-met-valora IN FRAME fPage3 /* MÇtodo Valoraá∆o */
DO:
    {method/referencefields.i &HandleDBOLeave="h-bocx00490"
                              &KeyValue1="int(tt-duimp-item.cod-met-valora:SCREEN-VALUE IN FRAME fPage3)"
                              &FieldName1="descricao" 
                              &FieldScreen1="c-desc-metodo"
                              &Frame1="fPage3"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-met-valora wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-duimp-item.cod-met-valora IN FRAME fPage3 /* MÇtodo Valoraá∆o */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tt-duimp-item.cod-mot-sem-cob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-mot-sem-cob wMaintenanceNoNavigation
ON F5 OF tt-duimp-item.cod-mot-sem-cob IN FRAME fPage4 /* Motivo Ausància Cobertura Cambial */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z01cx00496.w"
                         &FieldZoom1="codigo"
                         &FieldScreen1="tt-duimp-item.cod-mot-sem-cob"
                         &Frame1="fPage4"
                         &FieldZoom2="descricao"
                         &FieldScreen2="c-desc-motivo"
                         &Frame2="fPage4"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-mot-sem-cob wMaintenanceNoNavigation
ON LEAVE OF tt-duimp-item.cod-mot-sem-cob IN FRAME fPage4 /* Motivo Ausància Cobertura Cambial */
DO:
    {method/referencefields.i &HandleDBOLeave="h-bocx00496"
                              &KeyValue1="int(tt-duimp-item.cod-mot-sem-cob:SCREEN-VALUE IN FRAME fPage4)"
                              &FieldName1="descricao" 
                              &FieldScreen1="c-desc-motivo"
                              &Frame1="fPage4"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-mot-sem-cob wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-duimp-item.cod-mot-sem-cob IN FRAME fPage4 /* Motivo Ausància Cobertura Cambial */
DO:
   APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-duimp-item.cod-pais-iso-exporta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-pais-iso-exporta wMaintenanceNoNavigation
ON F5 OF tt-duimp-item.cod-pais-iso-exporta IN FRAME fPage1 /* Pa°s ISO */
DO:
    {include/zoomvar.i &prog-zoom="unzoom/z01un006.w"
                       &campo=tt-duimp-item.cod-pais-iso-exporta
                       &campozoom=cod-pais-iso-3166-2
                       &FRAME1="fPage1"
                       &campo2=c-pais-export
                       &campozoom2=nome-pais
                       &FRAME1="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-pais-iso-exporta wMaintenanceNoNavigation
ON LEAVE OF tt-duimp-item.cod-pais-iso-exporta IN FRAME fPage1 /* Pa°s ISO */
DO:
    ASSIGN INPUT FRAME fPage1 tt-duimp-item.cod-pais-iso-exporta
           c-pais-export = "".
    IF tt-duimp-item.cod-pais-iso-exporta <> "":U THEN DO:
        RUN findCh_pais_ISO-3166-2 IN h-boun006 (INPUT tt-duimp-item.cod-pais-iso-exporta,
                                                 OUTPUT c-return).
        IF c-return = "":U THEN DO:
            RUN getCharField IN h-boun006 (INPUT  "nome-pais":U,
                                           OUTPUT c-pais-export).
        END.
        ELSE
            ASSIGN c-pais-export = "":U.
    END.
    DISPLAY c-pais-export WITH FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-pais-iso-exporta wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-duimp-item.cod-pais-iso-exporta IN FRAME fPage1 /* Pa°s ISO */
DO:
   APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-duimp-item.cod-pais-iso-fabric
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-pais-iso-fabric wMaintenanceNoNavigation
ON F5 OF tt-duimp-item.cod-pais-iso-fabric IN FRAME fPage1 /* Pa°s ISO */
DO:
    {include/zoomvar.i &prog-zoom="unzoom/z01un006.w"
                       &campo=tt-duimp-item.cod-pais-iso-fabric
                       &campozoom=cod-pais-iso-3166-2
                       &FRAME1="fPage1"
                       &campo2=c-pais-fabric
                       &campozoom2=nome-pais
                       &FRAME1="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-pais-iso-fabric wMaintenanceNoNavigation
ON LEAVE OF tt-duimp-item.cod-pais-iso-fabric IN FRAME fPage1 /* Pa°s ISO */
DO:
    ASSIGN INPUT FRAME fPage1 tt-duimp-item.cod-pais-iso-fabric
           c-pais-fabric = "".
    IF tt-duimp-item.cod-pais-iso-fabric <> "":U THEN DO:
        RUN findCh_pais_ISO-3166-2 IN h-boun006 (INPUT tt-duimp-item.cod-pais-iso-fabric,
                                                 OUTPUT c-return).
        IF c-return = "":U THEN DO:
            RUN getCharField IN h-boun006 (INPUT  "nome-pais":U,
                                           OUTPUT c-pais-fabric).
        END.
        ELSE
            ASSIGN c-pais-fabric = "":U.
    END.
    DISPLAY c-pais-fabric WITH FRAME fPage1.

    ASSIGN INPUT FRAME fPage1 cb-export-fabric.
    IF {cxinc/i02cx00488.i 06 cb-export-fabric} = 2 /* igual */ THEN
        ASSIGN tt-duimp-item.cod-pais-iso-exporta:SCREEN-VALUE IN FRAME fPage1 = INPUT FRAME fPage1 tt-duimp-item.cod-pais-iso-fabric
               c-pais-export:SCREEN-VALUE IN FRAME fPage1                      = c-pais-fabric.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.cod-pais-iso-fabric wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-duimp-item.cod-pais-iso-fabric IN FRAME fPage1 /* Pa°s ISO */
DO:
   APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME i-mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo wMaintenanceNoNavigation
ON F5 OF i-mo-codigo IN FRAME fPage2 /* Moeda */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad178.w"
                       &campo=i-mo-codigo
                       &campozoom=mo-codigo
                       &campo2=c-moeda-neg
                       &campozoom2=descricao
                       &frame=fPage2
                       &campo3=c-moeda-iso
                       &campozoom3=cod-moeda-iso4217
                       &frame=fPage2}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo wMaintenanceNoNavigation
ON LEAVE OF i-mo-codigo IN FRAME fPage2 /* Moeda */
DO:
    RUN findCodigo IN h-boun005 (INPUT INT(i-mo-codigo:SCREEN-VALUE IN FRAME fPage2), OUTPUT c-return).
    IF  c-return = "" THEN DO: 
        RUN getCharfield IN h-boun005 (INPUT "descricao":U, OUTPUT c-moeda-neg).
        RUN getCharfield IN h-boun005 (INPUT "char-2":U, OUTPUT c-moeda-iso4217).
        ASSIGN c-moeda-iso = TRIM(SUBSTRING(c-moeda-iso4217,43,3)).
    END.
    ELSE 
        ASSIGN c-moeda-neg = ""
               c-moeda-iso  = "".
              
    DISPLAY c-moeda-neg c-moeda-iso WITH FRAME fPage2.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF i-mo-codigo IN FRAME fPage2 /* Moeda */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-duimp-item.ni-oper-exporta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.ni-oper-exporta wMaintenanceNoNavigation
ON ENTRY OF tt-duimp-item.ni-oper-exporta IN FRAME fPage1 /* N£mero Identificaá∆o */
DO:
    ASSIGN tt-duimp-item.ni-oper-exporta:FORMAT IN FRAME fPage1 = "x(19)":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.ni-oper-exporta wMaintenanceNoNavigation
ON LEAVE OF tt-duimp-item.ni-oper-exporta IN FRAME fPage1 /* N£mero Identificaá∆o */
DO:
    IF  tt-duimp-item.ni-oper-exporta:SCREEN-VALUE IN FRAME fPage1 <> "":U THEN DO:
        RUN piFormatoCnpjCpf (INPUT  tt-duimp-item.ni-oper-exporta:SCREEN-VALUE IN FRAME fPage1,
                              OUTPUT c-formato).
        ASSIGN tt-duimp-item.ni-oper-exporta:FORMAT IN FRAME fPage1 = c-formato.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-duimp-item.ni-oper-fabric
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.ni-oper-fabric wMaintenanceNoNavigation
ON ENTRY OF tt-duimp-item.ni-oper-fabric IN FRAME fPage1 /* N£mero Identificaá∆o */
DO:
    ASSIGN tt-duimp-item.ni-oper-fabric:FORMAT IN FRAME fPage1 = "x(19)":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.ni-oper-fabric wMaintenanceNoNavigation
ON LEAVE OF tt-duimp-item.ni-oper-fabric IN FRAME fPage1 /* N£mero Identificaá∆o */
DO:
    IF  tt-duimp-item.ni-oper-fabric:SCREEN-VALUE IN FRAME fPage1 <> "":U THEN DO:
        RUN piFormatoCnpjCpf (INPUT  tt-duimp-item.ni-oper-fabric:SCREEN-VALUE IN FRAME fPage1,
                              OUTPUT c-formato).
        ASSIGN tt-duimp-item.ni-oper-fabric:FORMAT IN FRAME fPage1 = c-formato.
    END.

    ASSIGN INPUT FRAME fPage1 cb-export-fabric.
    IF {cxinc/i02cx00488.i 06 cb-export-fabric} = 2 /* igual */ THEN DO:
        IF c-formato <> "" THEN
            ASSIGN tt-duimp-item.ni-oper-exporta:FORMAT IN FRAME fPage1 = c-formato
                   tt-duimp-item.ni-oper-exporta:SCREEN-VALUE IN FRAME fPage1 = INPUT FRAME fPage1 tt-duimp-item.ni-oper-fabric.
    END.
               
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-duimp-item.ni-responsavel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.ni-responsavel wMaintenanceNoNavigation
ON ENTRY OF tt-duimp-item.ni-responsavel IN FRAME fPage1 /* CNPJ/CPF Respons†vel */
DO:
    ASSIGN tt-duimp-item.ni-responsavel:FORMAT IN FRAME fPage1 = "x(19)":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.ni-responsavel wMaintenanceNoNavigation
ON LEAVE OF tt-duimp-item.ni-responsavel IN FRAME fPage1 /* CNPJ/CPF Respons†vel */
DO:
    IF  tt-duimp-item.ni-responsavel:SCREEN-VALUE IN FRAME fPage1 <> "":U THEN DO:
       RUN piFormatoCnpjCpf (INPUT  tt-duimp-item.ni-responsavel:SCREEN-VALUE IN FRAME fPage1,
                             OUTPUT c-formato).
       ASSIGN tt-duimp-item.ni-responsavel:FORMAT IN FRAME fPage1 = c-formato.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-duimp-item.num-identific
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.num-identific wMaintenanceNoNavigation
ON F5 OF tt-duimp-item.num-identific IN FRAME fPage1 /* Adquirente */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                     &campo="tt-duimp-item.num-identific"
                     &campozoom="cod-emitente"
                     &frame="fPage1"
                     &campo2="c-nome-adquirente"
                     &campozoom2="nome-abrev"
                     &frame2="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.num-identific wMaintenanceNoNavigation
ON LEAVE OF tt-duimp-item.num-identific IN FRAME fPage1 /* Adquirente */
DO:
    ASSIGN i-emitente = INT(tt-duimp-item.num-identific:SCREEN-VALUE IN FRAME fPage1) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT "Adquirente":U).
        RETURN NO-APPLY.
    END.
    IF tt-duimp-item.num-identific:SCREEN-VALUE IN FRAME fPage1 <> "" THEN DO:
        {method/referencefields.i &HandleDBOLeave="h-boad098"
                                  &FindMethod="findEmitente2"
                                  &KeyValue1="int(tt-duimp-item.num-identific:SCREEN-VALUE IN FRAME fPage1)"
                                  &FieldName1="nome-abrev" 
                                  &FieldScreen1="c-nome-adquirente"
                                  &Frame1="fPage1"}   
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.num-identific wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-duimp-item.num-identific IN FRAME fPage1 /* Adquirente */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-duimp-item.versao-fabric
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-duimp-item.versao-fabric wMaintenanceNoNavigation
ON LEAVE OF tt-duimp-item.versao-fabric IN FRAME fPage1 /* Vers∆o */
DO:
    ASSIGN INPUT FRAME fPage1 cb-export-fabric.
    IF {cxinc/i02cx00488.i 06 cb-export-fabric} = 2 /* igual */ THEN
        ASSIGN tt-duimp-item.versao-exporta:SCREEN-VALUE IN FRAME fPage1 = INPUT FRAME fPage1 tt-duimp-item.versao-fabric.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
IF tt-duimp-item.num-identific:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage1 THEN.
IF tt-duimp-item.cdn-fabrican:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage1 THEN.
IF tt-duimp-item.cdn-exporta:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage1 THEN.
IF tt-duimp-item.cod-pais-iso-fabric:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage1 THEN.
IF tt-duimp-item.cod-pais-iso-exporta:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage1 THEN.
IF i-mo-codigo:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage2 THEN.
IF tt-duimp-item.cod-met-valora:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage3 THEN.
IF tt-duimp-item.cod-mot-sem-cob:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage4 THEN.
IF tt-duimp-item.cod-institut-finan:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME fPage4 THEN.

tt-duimp-acres-deduc-it.cdn-acres-deduc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brAcresDeduc.
tt-duimp-acres-deduc-it.cdn-moeda:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN BROWSE brAcresDeduc.
c-nbs:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.

ON "F5":U, mouse-select-dblclick OF tt-duimp-acres-deduc-it.cdn-acres-deduc IN BROWSE brAcresDeduc DO:
    RUN piZoomAcresDeduc.
END.

ON "F5":U, mouse-select-dblclick OF tt-duimp-acres-deduc-it.cdn-moeda IN BROWSE brAcresDeduc DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad178.w"
                       &campo=tt-duimp-acres-deduc-it.cdn-moeda
                       &campozoom=mo-codigo
                       &campo2=c-desc-moeda
                       &campozoom2=descricao
                       &browse=brAcresDeduc}    
END.

ON "LEAVE":U OF tt-duimp-acres-deduc-it.idi-tipo IN BROWSE brAcresDeduc DO:   
    IF LOOKUP(tt-duimp-acres-deduc-it.idi-tipo:SCREEN-VALUE IN BROWSE brAcresDeduc,"1,2") = 0 THEN
        ASSIGN c-tipo = "".
    ELSE 
        ASSIGN c-tipo = fnTipo(INT(tt-duimp-acres-deduc-it.idi-tipo:SCREEN-VALUE IN BROWSE brAcresDeduc)).
    DISPLAY c-tipo WITH BROWSE brAcresDeduc.
END.

ON "LEAVE":U OF tt-duimp-acres-deduc-it.cdn-acres-deduc IN BROWSE brAcresDeduc DO:
    ASSIGN c-desc-AcreDed = fnAcresDeduc(INT(tt-duimp-acres-deduc-it.idi-tipo:SCREEN-VALUE IN BROWSE brAcresDeduc),
                                             INT(tt-duimp-acres-deduc-it.cdn-acres-deduc:SCREEN-VALUE IN BROWSE brAcresDeduc)).
    DISPLAY c-desc-AcreDed WITH BROWSE brAcresDeduc.
END.

ON "LEAVE":U OF tt-duimp-acres-deduc-it.cdn-moeda IN BROWSE brAcresDeduc DO: 
    IF  tt-duimp-acres-deduc-it.cdn-moeda:SCREEN-VALUE IN BROWSE brAcresDeduc = "" THEN DO:
        ASSIGN c-desc-moeda = "".
        DISPLAY c-desc-moeda WITH BROWSE brAcresDeduc.
    END.
    ELSE DO:
        ASSIGN c-desc-moeda = fnMoeda(INT(tt-duimp-acres-deduc-it.cdn-moeda:SCREEN-VALUE IN BROWSE brAcresDeduc)).
        DISPLAY c-desc-moeda WITH BROWSE brAcresDeduc.
    END.
END.

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
    IF VALID-HANDLE(h-boin172) THEN
        RUN destroy IN h-boin172.

    IF VALID-HANDLE(h-boin046) THEN DO:
        DELETE PROCEDURE h-boin046.
        ASSIGN h-boin046 = ?.
    END.
    
    IF VALID-HANDLE(h-boad098) THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.
    
    IF VALID-HANDLE(h-bocx00488) THEN DO:
        DELETE PROCEDURE h-bocx00488.
        ASSIGN h-bocx00488 = ?.
    END.
    
    IF VALID-HANDLE(h-bocx00480) THEN DO:
        DELETE PROCEDURE h-bocx00480.
        ASSIGN h-bocx00480 = ?.
    END.
    
    IF VALID-HANDLE(h-bocx402) THEN DO:
        DELETE PROCEDURE h-bocx402.
        ASSIGN h-bocx402 = ?.
    END.
    
    IF VALID-HANDLE(h-bocx403) THEN DO:
        DELETE PROCEDURE h-bocx403.
        ASSIGN h-bocx403 = ?.
    END.

    IF VALID-HANDLE(h-bocx00490) THEN
        RUN destroy IN h-bocx00490.
        
    IF VALID-HANDLE(h-bocx00492) THEN
        RUN destroy IN h-bocx00492.

    IF VALID-HANDLE(h-boun005) THEN DO:
        DELETE PROCEDURE h-boun005.
        ASSIGN h-boun005 = ?.
    END.
        
    IF VALID-HANDLE(h-boun006) THEN DO:
        DELETE PROCEDURE h-boun006.
        ASSIGN h-boun006 = ?.
    END.

    IF VALID-HANDLE(h-bocx00496) THEN
        RUN destroy IN h-bocx00496.

    IF VALID-HANDLE(h-bocx00495) THEN
        RUN destroy IN h-bocx00495.
        
    IF  VALID-HANDLE(h-bocx00479) then do:
        DELETE PROCEDURE h-bocx00479.
        ASSIGN h-bocx00479 = ?.
    END.    

    IF VALID-HANDLE(h-bodi01157) THEN DO:
        DELETE PROCEDURE h-bodi01157.
        ASSIGN h-bodi01157 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    //esconder aba Atributo
    RUN deleteFolder IN hFolder (INPUT 7). 
    IF NOT l-nt2024002 THEN DISABLE btTributos WITH FRAME fPage6.
    ELSE ENABLE btTributos WITH FRAME fPage6.
    
    assign btCancelTributo:HIDDEN IN FRAME fpage7 = YES
           btUpdateTributo:HIDDEN IN FRAME fpage7 = YES
           btSaveTributo:HIDDEN IN FRAME fpage7 = YES.

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
        WITH FRAME fPage6.
    ENABLE btTributos WITH FRAME fPage6.   
    
    
    IF AVAIL tt-decla-import-ord THEN DO:
       RUN findCodigo IN h-boin172 (INPUT tt-decla-import-ord.cod-item:SCREEN-VALUE IN FRAME fPage0, OUTPUT c-return).
       IF c-return = "":U THEN DO:
            RUN getCharField IN h-boin172 (input "desc-item":U, OUTPUT c-desc-item).
            RUN getIntfield  IN h-boin172 (input "tipo-contr":U, OUTPUT i-tipo-contr).
            RUN getCharField IN h-boin172 (input "class-fiscal":U, OUTPUT c-cod-ncm).
            RUN findClass_fiscal IN h-boin046 (INPUT c-cod-ncm, OUTPUT c-return).
            IF c-return = "" THEN
                RUN getCharField IN h-boin046 (INPUT "descricao":U, OUTPUT c-desc-class-fiscal).    
       END.
       
       DISPLAY c-desc-item WITH FRAME fPage0.
       DISPLAY c-cod-ncm
               c-desc-class-fiscal WITH FRAME fPage2.
       
       FIND FIRST duimp-siscomex NO-LOCK
           WHERE duimp-siscomex.cod-duimp-dts = tt-decla-import-ord.num-di-ems NO-ERROR.
       IF  AVAIL duimp-siscomex THEN DO:
           ASSIGN c-cod-duimp-siscomex:SCREEN-VALUE IN FRAME fPage0 = duimp-siscomex.cod-duimp-siscomex.
       END.

       IF AVAIL tt-duimp-item THEN DO:
           RUN getCharfield IN h-boin172 (INPUT "char-1":U, OUTPUT c-char-aux).
           ASSIGN c-nbs = TRIM(SUBSTR(c-char-aux,342,20)).
           FOR FIRST ordem-compra NO-LOCK
               WHERE ordem-compra.numero-ordem = tt-decla-import-ord.num-ordem:
               FOR FIRST cotacao-item NO-LOCK
                   WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                     AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                     AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                     AND cotacao-item.cot-aprovada = YES:
                     IF SUBSTRING(cotacao-item.char-1,101,20) <> "" THEN 
                         ASSIGN c-nbs = TRIM(SUBSTRING(cotacao-item.char-1,101,20)).
               END.
           END.
           DISPLAY c-nbs WITH FRAME fPage2.
       
           ASSIGN i-mo-codigo:SCREEN-VALUE IN FRAME fPage2 = STRING(tt-duimp-item.mo-codigo)
                  c-incoterm:SCREEN-VALUE IN FRAME fPage3  = tt-duimp-item.incoterm.

           ASSIGN cb-caract-import:SCREEN-VALUE  IN FRAME fPage1 = {cxinc/i01cx00488.i 04 tt-duimp-item.caract-import}
                  cb-ind-vincul:SCREEN-VALUE     IN FRAME fPage1 = {cxinc/i03cx00488.i 04 tt-duimp-item.idi-ind-vincul}
                  cb-export-fabric:SCREEN-VALUE  IN FRAME fPage1 = {cxinc/i02cx00488.i 04 tt-duimp-item.ind-export-fabric}
                  cb-aplicacao:SCREEN-VALUE      IN FRAME fPage2 = {cxinc/i04cx00488.i 04 tt-duimp-item.aplicacao}
                  cb-condicao:SCREEN-VALUE       IN FRAME fPage2 = {cxinc/i05cx00488.i 04 tt-duimp-item.condicao}
                  cb-cobertura:SCREEN-VALUE      IN FRAME fPage4 = {cxinc/i07cx00488.i 04 tt-duimp-item.cobertura-camb}.
                  
           APPLY 'LEAVE':U TO tt-duimp-item.num-identific IN FRAME fPage1.
           APPLY 'LEAVE':U TO tt-duimp-item.ni-responsavel IN FRAME fPage1.
           APPLY 'LEAVE':U TO tt-duimp-item.ni-oper-fabric IN FRAME fPage1.
           APPLY 'LEAVE':U TO tt-duimp-item.ni-oper-exporta IN FRAME fPage1.
           APPLY 'LEAVE':U TO tt-duimp-item.cdn-fabrican IN FRAME fPage1.
           APPLY 'LEAVE':U TO tt-duimp-item.cdn-exporta IN FRAME fPage1.
           APPLY 'LEAVE':U TO tt-duimp-item.cod-pais-iso-fabric IN FRAME fPage1.
           APPLY 'LEAVE':U TO tt-duimp-item.cod-pais-iso-exporta IN FRAME fPage1.
           APPLY 'LEAVE':U TO c-nbs IN FRAME fPage2.
           APPLY 'LEAVE':U TO i-mo-codigo IN FRAME fPage2.
           APPLY 'LEAVE':U TO tt-duimp-item.cod-met-valora IN FRAME fPage3.
           APPLY 'LEAVE':U TO tt-duimp-item.cod-mot-sem-cob IN FRAME fPage4.
           APPLY 'LEAVE':U TO tt-duimp-item.cod-institut-finan IN FRAME fPage4.
     
           /* Local de Consumo: le UF (pos 1-2) + IBGE (pos 3-9) de cod-livre-1 */
           ASSIGN fi-uf:SCREEN-VALUE        IN FRAME fPage2 = SUBSTRING(tt-duimp-item.cod-livre-1,1,2)
                  fi-municipio:SCREEN-VALUE IN FRAME fPage2 = "".
           IF TRIM(SUBSTRING(tt-duimp-item.cod-livre-1,3,7)) <> "" THEN
           FOR FIRST cidade FIELDS(cidade) NO-LOCK
               WHERE cidade.cdn-munpio-ibge = INTEGER(SUBSTRING(tt-duimp-item.cod-livre-1,3,7)):
               ASSIGN fi-municipio:SCREEN-VALUE IN FRAME fPage2 = cidade.cidade.
           END.

           RUN piBuscaAcresDeduc.
           RUN piBuscaTributo.
        END.
   END.

   RETURN "OK":U.
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
    /* Aba Dados Imp */
    
    APPLY 'VALUE-CHANGED':U TO cb-caract-import IN FRAME fPage1.
    APPLY 'VALUE-CHANGED':U TO cb-export-fabric IN FRAME fPage1.

    /* Aba Mercadoria */
    IF AVAIL tt-duimp-item THEN DO:
        DISABLE tt-duimp-item.unid-com
                tt-duimp-item.peso-liq
                i-mo-codigo
                tt-duimp-item.qtd-com
                tt-duimp-item.qtd-med
                tt-duimp-item.vlr-unit-mo WITH FRAME fPage2.
        
        IF i-tipo-contr = 4 THEN 
            ENABLE c-nbs WITH FRAME fPage2.

        ENABLE fi-municipio WITH FRAME fPage2.
        DISABLE fi-uf WITH FRAME fPage2.
    END.
    
    /* Aba Cond.Venda */
    ENABLE brAcresDeduc
           btAddAcresDeduc WITH FRAME fPage3.
    DISABLE btCancelAcresDeduc
            btSaveAcresDeduc 
            WITH FRAME fPage3.
    IF CAN-FIND(FIRST tt-duimp-acres-deduc-it) THEN
        ENABLE btUpdateAcresDeduc 
               btDeleteAcresDeduc WITH FRAME fPage3.
    ELSE
        DISABLE btUpdateAcresDeduc 
                btDeleteAcresDeduc WITH FRAME fPage3.
    ASSIGN tt-duimp-acres-deduc-it.idi-tipo:READ-ONLY IN BROWSE brAcresDeduc = YES
           tt-duimp-acres-deduc-it.cdn-acres-deduc:READ-ONLY IN BROWSE brAcresDeduc = YES
           tt-duimp-acres-deduc-it.cdn-moeda:READ-ONLY IN BROWSE brAcresDeduc = YES
           tt-duimp-acres-deduc-it.valor:READ-ONLY IN BROWSE brAcresDeduc = YES.

    /* Aba Cambiais */
    APPLY 'VALUE-CHANGED':U TO cb-cobertura IN FRAME fPage4.
    
     /* Aba Tributos */
    /*disable brTributo WITH FRAME fpage7.
    DISABLE btCancelTributo
            btSaveTributo WITH FRAME fpage7.
    IF CAN-FIND(FIRST tt-duimp-tributo-it) THEN
        ENABLE btUpdateTributo WITH FRAME fpage7.
    ELSE 
        DISABLE btUpdateTributo WITH FRAME fpage7.
    ASSIGN tt-duimp-tributo-it.regime:READ-ONLY IN BROWSE brTributo = YES
           tt-duimp-tributo-it.fundamento:READ-ONLY IN BROWSE brTributo = YES.*/
           
    /* Desabilita todos os campos da tela se tem nota gerada */
    IF  AVAIL tt-duimp-item 
    AND tt-duimp-item.nro-docto <> "":U THEN DO:
        DISABLE ALL WITH FRAME fpage1.
        DISABLE ALL WITH FRAME fpage2.
        DISABLE ALL WITH FRAME fpage3.
        DISABLE ALL WITH FRAME fpage4.
        DISABLE ALL WITH FRAME fpage5.
    END.
    
    RUN pi-trata-combos.
    RUN pi-busca-valores.
    RUN pi-busca-valor-impostos.
    
    //ASSIGN FRAME fPage5:HIDDEN = YES.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforedisplayfields wMaintenanceNoNavigation 
PROCEDURE beforedisplayfields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if avail tt-decla-import-ord then do:
        run goToKey    in h-bocx00488 (input tt-decla-import-ord.num-di-ems,
                                       input tt-decla-import-ord.cod-item,
                                       input tt-decla-import-ord.num-adic).
        if return-value = "OK":U then do:
            run getRecord  in h-bocx00488 (OUTPUT TABLE tt-duimp-item).
        
            for first tt-duimp-item no-lock:
            end.
        end.    
        
        run goToKey    in h-bocx403 (input tt-decla-import-ord.num-di-ems,
                                     input tt-decla-import-ord.num-adic,
                                     input tt-decla-import-ord.cdd-siscomex-dts).
                                
        IF return-value = "OK":U THEN DO:
            run getRecord in h-bocx403 (output table tt-decla-import-adic).            
            
            FOR first tt-decla-import-adic no-lock:
            END.
        END.
        
        RUN goToKey IN h-bocx00480 (INPUT tt-decla-import-ord.cod-item).

        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getDecField  IN h-bocx00480 (INPUT "cdd-produt":U, OUTPUT de-cdd-item-siscomex).
            RUN getCharField IN h-bocx00480 (INPUT "cod-versao":U, OUTPUT c-cod-versao).
            
        END.
        DISP de-cdd-item-siscomex
             c-cod-versao WITH FRAME fPage2.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN cb-caract-import:LIST-ITEMS IN FRAME fPage1 = {cxinc/i01cx00488.i 03}
           cb-ind-vincul:LIST-ITEMS    IN FRAME fPage1 = {cxinc/i03cx00488.i 03}
           cb-export-fabric:LIST-ITEMS IN FRAME fPage1 = {cxinc/i02cx00488.i 03}
           cb-aplicacao:LIST-ITEMS     IN FRAME fPage2 = {cxinc/i04cx00488.i 03}
           cb-condicao:LIST-ITEMS      IN FRAME fPage2 = {cxinc/i05cx00488.i 03}                     
           cb-cobertura:LIST-ITEMS     IN FRAME fPage4 = {cxinc/i07cx00488.i 03}.


        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao006 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao007 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cAuxTraducao008 AS CHARACTER NO-UNDO.

        /* Impto-Import */
        ASSIGN cAuxTraducao003 = {cxinc/i01cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao003).
        ASSIGN cb-idi-tributac-impto-import:LIST-ITEM-PAIRS in frame fPage6 = cAuxTraducao003.

        /* IPI */
        ASSIGN cAuxTraducao004 = {cxinc/i01cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao004).
        ASSIGN cb-idi-tributac-ipi:LIST-ITEM-PAIRS in frame fPage6 = cAuxTraducao004.

        /* ICMS */
        ASSIGN cAuxTraducao005 = {cxinc/i02cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao005).
        ASSIGN cb-idi-tributac-icms:LIST-ITEM-PAIRS in frame fPage6 = cAuxTraducao005.

        /* PIS */
        ASSIGN cAuxTraducao006 = {cxinc/i01cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao006).
        ASSIGN cb-idi-tributac-pis:LIST-ITEM-PAIRS in frame fPage6 = cAuxTraducao006.

        /* COFINS */
        ASSIGN cAuxTraducao007 = {cxinc/i01cx402.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao007).
        ASSIGN cb-idi-tributac-cofins:LIST-ITEM-PAIRS in frame fPage6 = cAuxTraducao007.
    &else
        ASSIGN cb-idi-tributac-impto-import:LIST-ITEMS in frame fPage6 = {cxinc/i01cx402.i 03}
               cb-idi-tributac-ipi:LIST-ITEMS          in frame fPage6 = {cxinc/i01cx402.i 03}
               cb-idi-tributac-icms:LIST-ITEMS         in frame fPage6 = {cxinc/i02cx402.i 03}
               cb-idi-tributac-pis:LIST-ITEMS          in frame fPage6 = {cxinc/i01cx402.i 03}
               cb-idi-tributac-cofins:LIST-ITEMS       in frame fPage6 = {cxinc/i01cx402.i 03}.
    &endif
 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF AVAIL tt-duimp-item THEN DO:
        ASSIGN INPUT FRAME fPage1 cb-caract-import
               INPUT FRAME fPage1 cb-ind-vincul
               INPUT FRAME fPage1 cb-export-fabric
               INPUT FRAME fPage2 cb-aplicacao
               INPUT FRAME fPage2 cb-condicao
               INPUT FRAME fPage4 cb-cobertura
               tt-duimp-item.caract-import          = {cxinc/i01cx00488.i 06 cb-caract-import} 
               tt-duimp-item.idi-ind-vincul         = {cxinc/i03cx00488.i 06 cb-ind-vincul} 
               tt-duimp-item.ind-export-fabric      = {cxinc/i02cx00488.i 06 cb-export-fabric} 
               tt-duimp-item.aplicacao              = {cxinc/i04cx00488.i 06 cb-aplicacao} 
               tt-duimp-item.condicao               = {cxinc/i05cx00488.i 06 cb-condicao} 
               tt-duimp-item.cobertura-camb         = {cxinc/i07cx00488.i 06 cb-cobertura} 
               INPUT FRAME fPage1 tt-duimp-item.ni-responsavel 
               INPUT FRAME fPage1 tt-duimp-item.num-identific 
               INPUT FRAME fPage1 tt-duimp-item.cdn-exporta 
               INPUT FRAME fPage1 tt-duimp-item.cdn-fabrican 
               INPUT FRAME fPage1 tt-duimp-item.versao-exporta 
               INPUT FRAME fPage1 tt-duimp-item.versao-fabric 
               INPUT FRAME fPage1 tt-duimp-item.ni-oper-exporta 
               INPUT FRAME fPage1 tt-duimp-item.ni-oper-fabric 
               INPUT FRAME fPage1 tt-duimp-item.cod-pais-iso-exporta 
               INPUT FRAME fPage1 tt-duimp-item.cod-pais-iso-fabric
               INPUT FRAME fPage2 tt-duimp-item.unid-com 
               INPUT FRAME fPage2 tt-duimp-item.peso-liq 
               INPUT FRAME fPage2 tt-duimp-item.qtd-com 
               INPUT FRAME fPage2 tt-duimp-item.qtd-med 
               INPUT FRAME fPage2 tt-duimp-item.vlr-unit-mo 
               INPUT FRAME fPage2 tt-duimp-item.desc-comp 
               INPUT FRAME fPage3 tt-duimp-item.cod-met-valora 
               INPUT FRAME fPage3 tt-duimp-item.compl-incoterm
               INPUT FRAME fPage4 tt-duimp-item.cod-mot-sem-cob 
               INPUT FRAME fPage4 tt-duimp-item.cod-institut-finan
               INPUT FRAME fPage4 tt-duimp-item.val-cob-camb 
               INPUT FRAME fPage4 tt-duimp-item.numero-rof.
               
        RUN emptyRowErrors IN h-bocx00488.
        RUN emptyRowObject IN h-bocx00488.
        /* Local de Consumo: grava UF (pos 1-2) + IBGE (pos 3-9) em cod-livre-1 */
        ASSIGN INPUT FRAME fPage2 fi-uf
               INPUT FRAME fPage2 fi-municipio.
        IF fi-municipio <> "" THEN DO:
            FOR FIRST cidade FIELDS(estado cdn-munpio-ibge) NO-LOCK
                WHERE cidade.cidade = fi-municipio
                AND   cidade.estado = fi-uf:
                ASSIGN OVERLAY(tt-duimp-item.cod-livre-1,1,2) = cidade.estado
                       OVERLAY(tt-duimp-item.cod-livre-1,3,7) = STRING(cidade.cdn-munpio-ibge,"9999999").
            END.
        END.
        ELSE
            ASSIGN OVERLAY(tt-duimp-item.cod-livre-1,1,2) = ""
                   OVERLAY(tt-duimp-item.cod-livre-1,3,7) = "".

    
        run goToKey    in h-bocx00488 (input tt-decla-import-ord.num-di-ems,
                                       input tt-decla-import-ord.cod-item,
                                       input tt-decla-import-ord.num-adic).
                                       
        if return-value = "OK":U then do:   
            RUN setRecord      IN h-bocx00488 (INPUT TABLE tt-duimp-item).
            RUN updateRecord   IN h-bocx00488.
        END.
        
        ASSIGN input frame fPage6 cb-idi-tributac-cofins
               input frame fPage6 cb-idi-tributac-icms
               input frame fPage6 cb-idi-tributac-impto-import
               input frame fPage6 cb-idi-tributac-ipi
               input frame fPage6 cb-idi-tributac-pis
               INPUT FRAME fPage6 tt-decla-import-adic.val-aliq-ii 
               INPUT FRAME fPage6 tt-decla-import-adic.val-perc-reduc-impto-import 
               INPUT FRAME fPage6 tt-decla-import-adic.val-base-ii 
               INPUT FRAME fPage6 tt-decla-import-adic.val-aliq-ipi 
               INPUT FRAME fPage6 tt-decla-import-adic.val-perc-reduc-ipi 
               INPUT FRAME fPage6 tt-decla-import-adic.val-unit-ipi
               INPUT FRAME fPage6 tt-decla-import-adic.val-base-ipi 
               INPUT FRAME fPage6 tt-decla-import-adic.val-aliq-icms 
               INPUT FRAME fPage6 tt-decla-import-adic.val-perc-reduc-icms
               INPUT FRAME fPage6 tt-decla-import-adic.val-base-icms 
               INPUT FRAME fPage6 tt-decla-import-adic.val-aliq-pis 
               INPUT FRAME fPage6 tt-decla-import-adic.val-perc-reduc-pis 
               INPUT FRAME fPage6 tt-decla-import-adic.val-unit-pis
               INPUT FRAME fPage6 tt-decla-import-adic.val-base-pis  
               INPUT FRAME fPage6 tt-decla-import-adic.val-aliq-cofins 
               INPUT FRAME fPage6 tt-decla-import-adic.val-perc-reduc-cofins 
               INPUT FRAME fPage6 tt-decla-import-adic.val-unit-cofins 
               INPUT FRAME fPage6 tt-decla-import-adic.val-base-cofins.
        
        ASSIGN tt-decla-import-adic.idi-tributac-cofins       = {cxinc/i01cx402.i 06 cb-idi-tributac-cofins}
               tt-decla-import-adic.idi-tributac-icms         = {cxinc/i02cx402.i 06 cb-idi-tributac-icms}
               tt-decla-import-adic.idi-tributac-impto-import = {cxinc/i01cx402.i 06 cb-idi-tributac-impto-import}
               tt-decla-import-adic.idi-tributac-ipi          = {cxinc/i01cx402.i 06 cb-idi-tributac-ipi}
               tt-decla-import-adic.idi-tributac-pis          = {cxinc/i01cx402.i 06 cb-idi-tributac-pis}
               tt-decla-import-adic.log-suspens-ipi-import    = if input frame fPage6 cb-suspens-ipi-import   = 'Sim' then yes else no
               tt-decla-import-adic.log-suspens-impto-import  = if input frame fPage6 cb-suspens-impto-import = 'Sim' then yes else no.

    &if '{&bf_mat_versao_ems}' >= '2.09' &then
        ASSIGN tt-decla-import-adic.log-suspens-icms   = IF INPUT FRAME fPage6 cb-suspens-icms   = 'Sim' THEN YES ELSE NO
               tt-decla-import-adic.log-suspens-pis    = IF INPUT FRAME fPage6 cb-suspens-pis    = 'Sim' THEN YES ELSE NO
               tt-decla-import-adic.log-suspens-cofins = IF INPUT FRAME fPage6 cb-suspens-cofins = 'Sim' THEN YES ELSE NO.
    &else
        ASSIGN OVERLAY(tt-decla-import-adic.cod-livre-1,1,1) = IF INPUT FRAME fPage6 cb-suspens-icms   = 'Sim' THEN '1' ELSE '0' 
               OVERLAY(tt-decla-import-adic.cod-livre-1,2,1) = IF INPUT FRAME fPage6 cb-suspens-pis    = 'Sim' THEN '1' ELSE '0' 
               OVERLAY(tt-decla-import-adic.cod-livre-1,3,1) = IF INPUT FRAME fPage6 cb-suspens-cofins = 'Sim' THEN '1' ELSE '0'.
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
    IF INPUT FRAME fPage6 cb-suspens-impto-import = 'Sim' THEN
        ASSIGN tt-decla-import-adic.val-ii-nao-tribut = INPUT FRAME fPage6 d-valor-impostos-ii.
    ELSE DO:
        IF tt-decla-import-adic.idi-tributac-impto-import = 1 OR
           tt-decla-import-adic.idi-tributac-impto-import = 4  THEN
            ASSIGN tt-decla-import-adic.val-ii-db-cr = INPUT FRAME fPage6 d-valor-impostos-ii.
        ELSE DO:
            IF tt-decla-import-adic.idi-tributac-impto-import = 2 THEN
                ASSIGN tt-decla-import-adic.val-ii-db-cr = INPUT FRAME fPage6 d-valor-impostos-ipi.
            ELSE
                IF tt-decla-import-adic.idi-tributac-impto-import = 3 THEN
                    ASSIGN tt-decla-import-adic.val-ii-outras = INPUT FRAME fPage6 d-valor-impostos-ii.
        END.
     END. /* else do */
     /* fim - ii */

     /* ipi */ 
     IF INPUT FRAME fPage6 cb-suspens-ipi-import = 'Sim' THEN
        ASSIGN tt-decla-import-adic.val-ipi-nao-tribut = INPUT FRAME fPage6 d-valor-impostos-ipi.
     ELSE DO:
        IF tt-decla-import-adic.idi-tributac-ipi = 1 OR
           tt-decla-import-adic.idi-tributac-ipi = 4  THEN
            ASSIGN tt-decla-import-adic.val-ipi-db-cr = INPUT FRAME fPage6 d-valor-impostos-ipi.
        ELSE DO:
            IF tt-decla-import-adic.idi-tributac-ipi = 2 THEN
                ASSIGN tt-decla-import-adic.val-ipi-db-cr = INPUT FRAME fPage6 d-valor-impostos-ipi.
            ELSE
                IF tt-decla-import-adic.idi-tributac-ipi = 3 THEN
                    ASSIGN tt-decla-import-adic.val-ipi-outras = INPUT FRAME fPage6 d-valor-impostos-ipi.
        END.
     END. /* else do */
     /* fim - ipi */ 

     /* pis */
     IF INPUT FRAME fPage6 cb-suspens-pis = 'Sim' THEN
        ASSIGN tt-decla-import-adic.val-pis-nao-tribut = INPUT FRAME fPage6 d-valor-impostos-pis.
     ELSE DO:
        IF tt-decla-import-adic.idi-tributac-pis = 1 OR
           tt-decla-import-adic.idi-tributac-pis = 4  THEN
            ASSIGN tt-decla-import-adic.val-pis-db-cr = INPUT FRAME fPage6 d-valor-impostos-pis.
        ELSE DO:
            IF tt-decla-import-adic.idi-tributac-pis = 2 THEN
                ASSIGN tt-decla-import-adic.val-pis-db-cr = INPUT FRAME fPage6 d-valor-impostos-ipi.
            ELSE
                IF tt-decla-import-adic.idi-tributac-pis = 3 THEN
                    ASSIGN tt-decla-import-adic.val-pis-outras = INPUT FRAME fPage6 d-valor-impostos-pis.
        END.
     END.
     /* fim - pis */

     /* cofins */
     IF INPUT FRAME fPage6 cb-suspens-cofins = 'Sim' THEN
        ASSIGN tt-decla-import-adic.val-cofins-nao-tribut = INPUT FRAME fPage6 d-valor-impostos-cofins.
     ELSE DO:
        IF tt-decla-import-adic.idi-tributac-cofins = 1 OR
           tt-decla-import-adic.idi-tributac-cofins = 4  THEN
            ASSIGN tt-decla-import-adic.val-cofins-db-cr = INPUT FRAME fPage6 d-valor-impostos-cofins.
        ELSE DO:
            IF tt-decla-import-adic.idi-tributac-cofins = 2 THEN
                ASSIGN tt-decla-import-adic.val-cofins-db-cr = INPUT FRAME fPage6 d-valor-impostos-ipi.
            ELSE
                IF tt-decla-import-adic.idi-tributac-cofins = 3 THEN
                    ASSIGN tt-decla-import-adic.val-cofins-outras = INPUT FRAME fPage6 d-valor-impostos-cofins.
        END.
     END.
     /* fim - cofins */

     /* icms */
     IF INPUT FRAME fPage6 cb-suspens-icms = 'Sim' THEN
        ASSIGN tt-decla-import-adic.val-icms-nao-tribut = INPUT FRAME fPage6 d-valor-impostos-icms.
     ELSE DO:
        IF tt-decla-import-adic.idi-tributac-icms = 1 OR
           tt-decla-import-adic.idi-tributac-icms = 4  THEN
            ASSIGN tt-decla-import-adic.val-icms-db-cr = INPUT FRAME fPage6 d-valor-impostos-icms.
        ELSE DO:
            IF tt-decla-import-adic.idi-tributac-icms = 2 THEN
                ASSIGN tt-decla-import-adic.val-icms-db-cr = INPUT FRAME fPage6 d-valor-impostos-ipi.
            ELSE
                IF tt-decla-import-adic.idi-tributac-icms = 3 THEN
                    ASSIGN tt-decla-import-adic.val-icms-outras = INPUT FRAME fPage6 d-valor-impostos-icms.
        END.
     END.
     /* fim - icms */

     RUN emptyRowErrors IN h-bocx403.
     RUN emptyRowObject IN h-bocx403.
    
     run goToKey    in h-bocx403 (input tt-decla-import-adic.num-di-ems,
                                  input tt-decla-import-adic.num-adic,
                                  input tt-decla-import-adic.cdd-siscomex-dts).
                                       
     if return-value = "OK":U then do:   
         RUN setRecord      IN h-bocx403 (INPUT TABLE tt-decla-import-adic).
         RUN updateRecord   IN h-bocx403.
     END.
        
     /* NBS */
     FOR FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = tt-decla-import-ord.num-ordem:
         FOR FIRST cotacao-item EXCLUSIVE-LOCK
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
               AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
               AND cotacao-item.it-codigo    = ordem-compra.it-codigo
               AND cotacao-item.cot-aprovada = YES:
               ASSIGN OVERLAY(cotacao-item.char-1,101,20) = TRIM(REPLACE(c-nbs:SCREEN-VALUE IN FRAME fPage2,".","")).
         END.
     END.
     
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT VALID-HANDLE({&hDBOTable})
    OR {&hDBOTable}:TYPE <> "PROCEDURE":U 
    OR {&hDBOTable}:FILE-NAME <> "cxbo/bocx404.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx404.p YES}
        {btb/btb008za.i2 cxbo/bocx404.p '' {&hDBOTable}}
    END.
    
    IF NOT VALID-HANDLE(h-boin172)
    OR h-boin172:TYPE <> "PROCEDURE":U 
    OR h-boin172:FILE-NAME <> "inbo/boin172.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin172.p YES}
        {btb/btb008za.i2 inbo/boin172.p '' h-boin172}
    END.
    
    IF NOT VALID-HANDLE(h-boin172)
    OR h-boin172:TYPE <> "PROCEDURE":U 
    OR h-boin172:FILE-NAME <> "inbo/boin172.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin172.p YES}
        {btb/btb008za.i2 inbo/boin172.p '' h-boin172}
    END.
    
    IF NOT VALID-HANDLE(h-boin046)
    OR h-boin046:TYPE <> "PROCEDURE":U 
    OR h-boin046:FILE-NAME <> "inbo/boin046.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin046.p YES}
        {btb/btb008za.i2 inbo/boin046.p '' h-boin046}
    END.

    IF NOT VALID-HANDLE(h-boad098) 
    OR h-boad098:TYPE <> "PROCEDURE":U 
    OR h-boad098:FILE-NAME <> "adbo/boad098.p":U THEN DO:
        {btb/btb008za.i1 adbo/boad098.p YES}
        {btb/btb008za.i2 adbo/boad098.p '' h-boad098}
    END.    

    IF  NOT VALID-HANDLE(h-bocx00490) 
    OR  h-bocx00490:TYPE <> "PROCEDURE":U 
    OR  h-bocx00490:FILE-NAME <> "cxbo/bocx00490.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00490.p YES}
        {btb/btb008za.i2 cxbo/bocx00490.p '' h-bocx00490}
    END.    
    RUN openQueryStatic IN h-bocx00490 (INPUT "Main":U) NO-ERROR.  
    
    IF NOT VALID-HANDLE(h-boin682) THEN
        RUN inbo/boin682.p PERSISTENT SET h-boin682.
    
    RUN openQueryStatic IN h-boin682 (INPUT "Main":U) NO-ERROR.
    RUN findFirst       IN h-boin682.
    RUN getCharField    IN h-boin682 (INPUT "formato-id-federal":U,
                                      OUTPUT c-formato-id-federal).
    RUN getCharField    IN h-boin682 (INPUT "formato-id-pessoal":U,
                                      OUTPUT c-formato-cpf).
                                      
    IF NOT VALID-HANDLE(h-bocx00492) THEN
        RUN cxbo/bocx00492.p PERSISTENT SET h-bocx00492.

    IF NOT VALID-HANDLE(h-boun005) THEN 
        RUN unbo/boun005.p PERSISTENT SET h-boun005.

    IF NOT VALID-HANDLE(h-boun006) THEN 
        RUN unbo/boun006.p PERSISTENT SET h-boun006.

    IF  NOT VALID-HANDLE(h-bocx00496) 
    OR  h-bocx00496:TYPE <> "PROCEDURE":U 
    OR  h-bocx00496:FILE-NAME <> "cxbo/bocx00496.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00496.p YES}
        {btb/btb008za.i2 cxbo/bocx00496.p '' h-bocx00496}
    END.    
    RUN openQueryStatic IN h-bocx00496 (INPUT "Main":U) NO-ERROR.  

    IF  NOT VALID-HANDLE(h-bocx00495) 
    OR  h-bocx00495:TYPE <> "PROCEDURE":U 
    OR  h-bocx00495:FILE-NAME <> "cxbo/bocx00495.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00495.p YES}
        {btb/btb008za.i2 cxbo/bocx00495.p '' h-bocx00495}
    END.    
    RUN openQueryStatic IN h-bocx00495 (INPUT "Main":U) NO-ERROR.  

    IF  NOT VALID-HANDLE(h-bocx00497) 
    OR  h-bocx00497:TYPE <> "PROCEDURE":U 
    OR  h-bocx00497:FILE-NAME <> "cxbo/bocx00497.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00497.p YES}
        {btb/btb008za.i2 cxbo/bocx00497.p '' h-bocx00497}
    END.    
    
    IF  NOT VALID-HANDLE(h-bocx00488) 
    OR  h-bocx00488:TYPE <> "PROCEDURE":U 
    OR  h-bocx00488:FILE-NAME <> "cxbo/bocx00488.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00488.p YES}
        {btb/btb008za.i2 cxbo/bocx00488.p '' h-bocx00488}
    END.    
    RUN openQueryStatic IN h-bocx00488 (INPUT "Main":U) NO-ERROR.  
    
    
    IF  NOT VALID-HANDLE(h-bocx402) 
    OR  h-bocx402:TYPE <> "PROCEDURE":U 
    OR  h-bocx402:FILE-NAME <> "cxbo/bocx402.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx402.p YES}
        {btb/btb008za.i2 cxbo/bocx402.p '' h-bocx402}
    END.    
    RUN openQueryStatic IN h-bocx402 (INPUT "Main":U) NO-ERROR.  
    
    IF  NOT VALID-HANDLE(h-bocx403) 
    OR  h-bocx403:TYPE <> "PROCEDURE":U 
    OR  h-bocx403:FILE-NAME <> "cxbo/bocx403.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx403.p YES}
        {btb/btb008za.i2 cxbo/bocx403.p '' h-bocx403}
    END. 
    RUN openQueryStatic IN h-bocx403 (INPUT "Main":U) NO-ERROR.  
    
    IF  NOT VALID-HANDLE(h-bocx00480) 
    OR  h-bocx00480:TYPE <> "PROCEDURE":U                         
    OR  h-bocx00480:FILE-NAME <> "cxbo/bocx00488.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00480.p YES}
        {btb/btb008za.i2 cxbo/bocx00480.p '' h-bocx00480}
    END.    
    RUN openQueryStatic IN h-bocx00480 (INPUT "Main":U) NO-ERROR.  
    
    IF NOT VALID-HANDLE(h-bocx00479) THEN
        run cxbo/bocx00479.p persistent set h-bocx00479.

    RUN openQueryStatic IN h-bocx00479 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-bodi01157)
    OR h-bodi01157:TYPE <> "PROCEDURE":U
    OR h-bodi01157:FILE-NAME <> "dibo/bodi01157.p":U THEN DO:
        {btb/btb008za.i1 dibo/bodi01157.p YES}
        {btb/btb008za.i2 dibo/bodi01157.p '' h-bodi01157}
    END.
    RUN openQueryStatic IN h-bodi01157 (INPUT "Main":U) NO-ERROR.
    
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
/*  valores do combo-box de tributaªío:
        0 - tributado
        1 - Isento
        2 - Outros
        3 - Reduzido
    */
    
    ASSIGN INPUT FRAME fPage6 cb-idi-tributac-impto-import
           INPUT FRAME fPage6 cb-idi-tributac-ipi
           INPUT FRAME fPage6 cb-idi-tributac-pis
           INPUT FRAME fPage6 cb-idi-tributac-cofins
           INPUT FRAME fPage6 cb-idi-tributac-icms
           
           INPUT FRAME fPage6 cb-suspens-impto-import
           INPUT FRAME fPage6 cb-suspens-ipi-import 
           INPUT FRAME fPage6 cb-suspens-pis 
           INPUT FRAME fPage6 cb-suspens-cofins
           INPUT FRAME fPage6 cb-suspens-icms.

    
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
    DISP d-valor-impostos-ii 
         d-valor-impostos-ipi 
         d-valor-impostos-pis 
         d-valor-impostos-cofins 
         d-valor-impostos-icms 
         de-val-aliq-fcp
         de-val-base-fcp
         de-val-fcp
         de-val-aliq-fcp-substto
         de-val-base-fcp-substto
         de-val-fcp-substto
         de-val-base-icms-substto
         de-val-icms-substto
         de-val-base-icms-compltar
         de-val-icms-compltar
        WITH FRAME fPage6.       
        
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

RUN pi-busca-valores IN h-bocx403 (INPUT tt-duimp-item.cod-duimp-dts,
                                   INPUT tt-decla-import-ord.num-adic,
                                   INPUT tt-decla-import-ord.cdd-siscomex-dts,
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
    WITH FRAME fPage5.

    
RUN pi-desabilita-valores.

return "OK":U.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita-valores wMaintenanceNoNavigation 
PROCEDURE pi-desabilita-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* desabilita os campos do folder valores (fPage5) */
      
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
        WITH FRAME fPage5.

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

    ASSIGN i-num-linha-browse = p-num-linha-browse.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-combos wMaintenanceNoNavigation 
PROCEDURE pi-trata-combos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN cb-idi-tributac-icms:screen-value         in frame fPage6 = {cxinc/i02cx402.i 04 tt-decla-import-adic.idi-tributac-icms}
           cb-idi-tributac-ipi:screen-value          in frame fPage6 = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-ipi}
           cb-idi-tributac-pis:screen-value          in frame fPage6 = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-pis}
           cb-idi-tributac-cofins:screen-value       in frame fPage6 = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-cofins}
           cb-idi-tributac-impto-import:screen-value in frame fPage6 = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-impto-import}
           cb-suspens-impto-import:screen-value      in frame fPage6 = if tt-decla-import-adic.log-suspens-impto-import then 'Sim' else 'N∆o'
           cb-suspens-ipi-import:screen-value        in frame fPage6 = if tt-decla-import-adic.log-suspens-ipi-import   then 'Sim' else 'N∆o'
           .
    &if '{&bf_mat_versao_ems}' >= '2.09' &then
        ASSIGN cb-suspens-icms:SCREEN-VALUE IN FRAME   fPage6 = IF tt-decla-import-adic.log-suspens-icms   THEN 'Sim' ELSE 'N∆o'
               cb-suspens-pis:SCREEN-VALUE IN FRAME    fPage6 = IF tt-decla-import-adic.log-suspens-pis    THEN 'Sim' ELSE 'N∆o'
               cb-suspens-cofins:SCREEN-VALUE IN FRAME fPage6 = IF tt-decla-import-adic.log-suspens-cofins THEN 'Sim' ELSE 'N∆o'.
    &else
        ASSIGN cb-suspens-icms:SCREEN-VALUE IN FRAME   fPage6 = IF SUBSTRING(tt-decla-import-adic.cod-livre-1,1,1) = '1' THEN 'Sim' ELSE 'N∆o'
               cb-suspens-pis:SCREEN-VALUE IN FRAME    fPage6 = IF SUBSTRING(tt-decla-import-adic.cod-livre-1,2,1) = '1' THEN 'Sim' ELSE 'N∆o'
               cb-suspens-cofins:SCREEN-VALUE IN FRAME fPage6 = IF SUBSTRING(tt-decla-import-adic.cod-livre-1,3,1) = '1' THEN 'Sim' ELSE 'N∆o'.
    &endif
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAddAcresDeduc wMaintenanceNoNavigation 
PROCEDURE piAddAcresDeduc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DISABLE btAddAcresDeduc 
            btUpdateAcresDeduc
            btDeleteAcresDeduc WITH FRAME fPage3.
    
    ENABLE btCancelAcresDeduc
           btSaveAcresDeduc WITH FRAME fPage3.
    
    ASSIGN tt-duimp-acres-deduc-it.idi-tipo:READ-ONLY IN BROWSE brAcresDeduc = NO
           tt-duimp-acres-deduc-it.cdn-acres-deduc:READ-ONLY IN BROWSE brAcresDeduc = NO
           tt-duimp-acres-deduc-it.cdn-moeda:READ-ONLY IN BROWSE brAcresDeduc = NO
           tt-duimp-acres-deduc-it.valor:READ-ONLY IN BROWSE brAcresDeduc = NO.
          
    IF NUM-RESULTS("brAcresDeduc":U) > 0 THEN DO:
        FIND LAST tt-duimp-acres-deduc-it NO-ERROR.
        IF  AVAIL tt-duimp-acres-deduc-it THEN DO:
            ASSIGN i-seq-acres-deduc =  tt-duimp-acres-deduc-it.seq-acres-deduc + 1.
            REPOSITION brAcresDeduc TO ROWID ROWID(tt-duimp-acres-deduc-it) NO-ERROR.
        END.
        brAcresDeduc:INSERT-ROW("after":U) IN FRAME fPage3.
        APPLY "entry":U TO tt-duimp-acres-deduc-it.idi-tipo IN BROWSE brAcresDeduc.
        DISPLAY i-seq-acres-deduc @ tt-duimp-acres-deduc-it.seq-acres-deduc WITH BROWSE brAcresDeduc.
    END.
    ELSE DO TRANS:
        CREATE tt-duimp-acres-deduc-it.
        ASSIGN tt-duimp-acres-deduc-it.seq-acres-deduc = 1
               tt-duimp-acres-deduc-it.idi-tipo = 0
               i-seq-acres-deduc = 1.
        OPEN QUERY brAcresDeduc FOR EACH tt-duimp-acres-deduc-it.
        DISPLAY "" @ tt-duimp-acres-deduc-it.idi-tipo WITH BROWSE brAcresDeduc.
        DISPLAY "" @ tt-duimp-acres-deduc-it.cdn-moeda WITH BROWSE brAcresDeduc.
        DISPLAY "" @ c-desc-moeda WITH BROWSE brAcresDeduc.
        APPLY "entry":U TO tt-duimp-acres-deduc-it.idi-tipo IN BROWSE brAcresDeduc. 
    END.

    ASSIGN l-add-acres-deduc = YES.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaAcresDeduc wMaintenanceNoNavigation 
PROCEDURE piBuscaAcresDeduc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-duimp-acres-deduc-it:
        DELETE tt-duimp-acres-deduc-it.
    END.

    IF AVAIL tt-duimp-item THEN DO:
        RUN setConstraintByDuimpItem IN h-bocx00492 (INPUT tt-duimp-item.cod-duimp-dts,
                                                     INPUT tt-duimp-item.cod-item,
                                                     INPUT tt-duimp-item.seq-item).
        RUN openQueryStatic        IN h-bocx00492 (INPUT "ByDuimpItem":U).
        RUN getBatchRecords        IN h-bocx00492 (INPUT  ?,
                                                   INPUT  ?,
                                                   INPUT  99999,
                                                   OUTPUT i-linhas-return,
                                                   OUTPUT TABLE tt-duimp-acres-deduc-it).
        
        {&OPEN-QUERY-brAcresDeduc}
    END.

    IF NOT CAN-FIND(FIRST tt-duimp-acres-deduc-it) THEN
        DISABLE btUpdateAcresDeduc
                btDeleteAcresDeduc
                WITH FRAME fPage3.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaTributo wMaintenanceNoNavigation 
PROCEDURE piBuscaTributo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*FOR EACH tt-duimp-tributo-it:
        DELETE tt-duimp-tributo-it.
    END.

    IF AVAIL tt-duimp-item THEN DO:
        
        RUN setConstraintByDuimpItem IN h-bocx00497 (INPUT tt-duimp-item.cod-duimp-dts,
                                                     INPUT tt-duimp-item.cod-item,
                                                     INPUT tt-duimp-item.seq-item).
        RUN openQueryStatic        IN h-bocx00497 (INPUT "ByDuimpItem":U).
        RUN getBatchRecords        IN h-bocx00497 (INPUT  ?,
                                                   INPUT  ?,
                                                   INPUT  99999,
                                                   OUTPUT i-linhas-return,
                                                   OUTPUT TABLE tt-duimp-tributo-it).
        
        {&OPEN-QUERY-brTributo}
    END.

    IF CAN-FIND(FIRST tt-duimp-tributo-it) THEN
        ENABLE btUpdateTributo WITH FRAME fPage5.
    ELSE 
        DISABLE btUpdateTributo WITH FRAME fPage5.
    */
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCancelAcresDeduc wMaintenanceNoNavigation 
PROCEDURE piCancelAcresDeduc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN piBuscaAcresDeduc.
    ASSIGN tt-duimp-acres-deduc-it.idi-tipo:READ-ONLY IN BROWSE brAcresDeduc = YES
           tt-duimp-acres-deduc-it.cdn-acres-deduc:READ-ONLY IN BROWSE brAcresDeduc = YES
           tt-duimp-acres-deduc-it.cdn-moeda:READ-ONLY IN BROWSE brAcresDeduc = YES
           tt-duimp-acres-deduc-it.valor:READ-ONLY IN BROWSE brAcresDeduc = YES.
    
    IF NOT CAN-FIND(FIRST tt-duimp-acres-deduc-it) THEN DO:
        ENABLE btAddAcresDeduc WITH FRAME fPage3.
        DISABLE btCancelAcresDeduc btUpdateAcresDeduc btDeleteAcresDeduc btSaveAcresDeduc WITH FRAME fPage3.
    END.
    ELSE DO:
        ENABLE  btAddAcresDeduc btUpdateAcresDeduc btDeleteAcresDeduc  WITH FRAME fPage3.
        DISABLE btCancelAcresDeduc btSaveAcresDeduc WITH FRAME fPage3.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCancelTributo wMaintenanceNoNavigation 
PROCEDURE piCancelTributo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*RUN piBuscaTributo.
    ASSIGN tt-duimp-tributo-it.regime:READ-ONLY IN BROWSE brTributo = YES
           tt-duimp-tributo-it.fundamento:READ-ONLY IN BROWSE brTributo = YES.
    
    IF NOT CAN-FIND(FIRST tt-duimp-tributo-it) THEN DO:
        DISABLE btCancelTributo btUpdateTributo btSaveTributo WITH FRAME fPage5.
    END.
    ELSE DO:
        ENABLE  btUpdateTributo WITH FRAME fPage5.
        DISABLE btCancelTributo btSaveTributo WITH FRAME fPage5.
    END.*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDeleteAcresDeduc wMaintenanceNoNavigation 
PROCEDURE piDeleteAcresDeduc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN goToKey IN h-bocx00492 (INPUT tt-duimp-acres-deduc-it.cod-duimp-dts,   
                                INPUT tt-duimp-acres-deduc-it.cod-item,
                                INPUT tt-duimp-acres-deduc-it.seq-item,
                                INPUT tt-duimp-acres-deduc-it.seq-acres-deduc).      
    
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 550,
                           INPUT "":U).
        IF RETURN-VALUE = "yes":U THEN DO:
            RUN emptyRowErrors IN h-bocx00492.
            RUN deleteRecord   IN h-bocx00492.
        END.
    END.
    RUN piBuscaAcresDeduc.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFormatoCnpjCpf wMaintenanceNoNavigation 
PROCEDURE piFormatoCnpjCpf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cnpj-cpf AS CHARACTER FORMAT "x(19)":U NO-UNDO.
    DEFINE OUTPUT PARAMETER p-formato  AS CHARACTER FORMAT "x(19)":U NO-UNDO.

    DEFINE VARIABLE l-niEstrangeiro AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE i              AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cChar          AS CHARACTER NO-UNDO.

    DO i = 1 TO LENGTH(p-cnpj-cpf):

        cChar = SUBSTRING(p-cnpj-cpf, i, 1).

        /* verifica se n∆o Ç n£mero */
        IF ASC(cChar) < 48 OR ASC(cChar) > 57 THEN DO:
            ASSIGN l-niEstrangeiro = TRUE.
            LEAVE.
        END.

    END.
    
    ASSIGN c-cnpj-cpf = REPLACE(REPLACE(REPLACE(REPLACE(p-cnpj-cpf, ".":U, "":U), "/":U, "":U), "\":U, "":U), "-":U, "":U)
               p-formato  = "":U.
    
    
    IF NOT l-niEstrangeiro THEN DO:
    
        IF LENGTH(c-cnpj-cpf) <> 0 THEN DO:
            IF LENGTH(c-cnpj-cpf) = 11 THEN
                ASSIGN p-formato = c-formato-cpf NO-ERROR.
            ELSE 
                IF LENGTH(c-cnpj-cpf) = 14 THEN
                    ASSIGN p-formato = c-formato-id-federal NO-ERROR.
                ELSE 
                    IF LENGTH(c-cnpj-cpf) = 8 THEN
                        ASSIGN p-formato = "XX.XXX.XXX":U.
                    ELSE
                        ASSIGN p-formato = "x(19)":U.
        END.
    END.
    ELSE
        ASSIGN p-formato = "x(19)":U.
    IF ERROR-STATUS:ERROR THEN
        ASSIGN p-formato = "x(19)":U NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSaveAcresDeduc wMaintenanceNoNavigation 
PROCEDURE piSaveAcresDeduc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-duimp-acres-deduc-it.

    CREATE tt-duimp-acres-deduc-it.
    ASSIGN tt-duimp-acres-deduc-it.cod-duimp-dts = tt-duimp-item.cod-duimp-dts
           tt-duimp-acres-deduc-it.cod-item      = tt-duimp-item.cod-item
           tt-duimp-acres-deduc-it.seq-item      = tt-duimp-item.seq-item
           tt-duimp-acres-deduc-it.seq-acres-deduc = IF l-add-acres-deduc THEN i-seq-acres-deduc
                                                     ELSE INPUT BROWSE brAcresDeduc tt-duimp-acres-deduc-it.seq-acres-deduc
           tt-duimp-acres-deduc-it.idi-tipo        = INPUT BROWSE brAcresDeduc tt-duimp-acres-deduc-it.idi-tipo
           tt-duimp-acres-deduc-it.cdn-acres-deduc = INPUT BROWSE brAcresDeduc tt-duimp-acres-deduc-it.cdn-acres-deduc
           tt-duimp-acres-deduc-it.cdn-moeda       = INPUT BROWSE brAcresDeduc tt-duimp-acres-deduc-it.cdn-moeda
           tt-duimp-acres-deduc-it.valor           = INPUT BROWSE brAcresDeduc tt-duimp-acres-deduc-it.valor.
    
    RUN emptyRowErrors IN h-bocx00492.
    RUN emptyRowObject IN h-bocx00492.
    RUN goToKey        IN h-bocx00492 (INPUT tt-duimp-acres-deduc-it.cod-duimp-dts,   
                                       INPUT tt-duimp-acres-deduc-it.cod-item,
                                       INPUT tt-duimp-acres-deduc-it.seq-item,
                                       INPUT tt-duimp-acres-deduc-it.seq-acres-deduc).      
    
    IF  l-add-acres-deduc THEN DO:
        RUN setRecord      IN h-bocx00492 (INPUT TABLE tt-duimp-acres-deduc-it).
        RUN createRecord   IN h-bocx00492.
    END.
    ELSE DO:
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN setRecord      IN h-bocx00492 (INPUT TABLE tt-duimp-acres-deduc-it).
            RUN updateRecord   IN h-bocx00492.
        END.
    END.
    IF RETURN-VALUE = "OK":U THEN DO:
        DISABLE btCancelAcresDeduc
                btSaveAcresDeduc WITH FRAME fPage3.

        ENABLE btAddAcresDeduc
               btUpdateAcresDeduc 
               btDeleteAcresDeduc WITH FRAME fPage3.

        ASSIGN tt-duimp-acres-deduc-it.idi-tipo:READ-ONLY IN BROWSE brAcresDeduc = YES
               tt-duimp-acres-deduc-it.cdn-acres-deduc:READ-ONLY IN BROWSE brAcresDeduc = YES
               tt-duimp-acres-deduc-it.cdn-moeda:READ-ONLY IN BROWSE brAcresDeduc = YES
               tt-duimp-acres-deduc-it.valor:READ-ONLY IN BROWSE brAcresDeduc = YES.
        
        RUN piBuscaAcresDeduc.
    END.
    ELSE DO:
        RUN getRowErrors IN h-bocx00492 (OUTPUT TABLE RowErrors).
        IF  CAN-FIND(FIRST RowErrors
                     WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
            IF l-add-acres-deduc THEN
                APPLY "ENTRY" TO tt-duimp-acres-deduc-it.idi-tipo IN BROWSE brAcresDeduc.
            ELSE 
                APPLY "ENTRY" TO tt-duimp-acres-deduc-it.cdn-moeda IN BROWSE brAcresDeduc.
            RETURN "NOK".
        END.
    END.

    RETURN "OK":U.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSaveTributo wMaintenanceNoNavigation 
PROCEDURE piSaveTributo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*EMPTY TEMP-TABLE tt-duimp-tributo-it-aux.
    CREATE tt-duimp-tributo-it-aux.
    BUFFER-COPY tt-duimp-tributo-it TO tt-duimp-tributo-it-aux.
    ASSIGN tt-duimp-tributo-it-aux.regime        = INPUT BROWSE brTributo tt-duimp-tributo-it.regime
           tt-duimp-tributo-it-aux.fundamento    = INPUT BROWSE brTributo tt-duimp-tributo-it.fundamento.
    
    RUN emptyRowErrors IN h-bocx00497.
    RUN emptyRowObject IN h-bocx00497.
    RUN goToKey        IN h-bocx00497 (INPUT tt-duimp-tributo-it-aux.cod-duimp-dts,   
                                       INPUT tt-duimp-tributo-it-aux.cod-item,
                                       INPUT tt-duimp-tributo-it-aux.seq-item,
                                       INPUT tt-duimp-tributo-it-aux.seq-tributo).      
    
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN setRecord      IN h-bocx00497 (INPUT TABLE tt-duimp-tributo-it-aux).
        RUN updateRecord   IN h-bocx00497.
    END.
    IF RETURN-VALUE = "OK":U THEN DO:
        DISABLE btCancelTributo
                btSaveTributo WITH FRAME fPage5.

        ENABLE btUpdateTributo WITH FRAME fPage5.

        ASSIGN tt-duimp-tributo-it.regime:READ-ONLY IN BROWSE brTributo = YES
               tt-duimp-tributo-it.fundamento:READ-ONLY IN BROWSE brTributo = YES.
        
        RUN piBuscaTributo.
    END.
    ELSE DO:
        RUN getRowErrors IN h-bocx00497 (OUTPUT TABLE RowErrors).
        IF  CAN-FIND(FIRST RowErrors
                     WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
        END.
    END.*/

    RETURN "OK":U.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piUpdateAcresDeduc wMaintenanceNoNavigation 
PROCEDURE piUpdateAcresDeduc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN brAcresDeduc:READ-ONLY IN FRAME fPage3 = NO
           tt-duimp-acres-deduc-it.idi-tipo:READ-ONLY IN BROWSE brAcresDeduc = YES
           tt-duimp-acres-deduc-it.cdn-acres-deduc:READ-ONLY IN BROWSE brAcresDeduc = YES
           tt-duimp-acres-deduc-it.cdn-moeda:READ-ONLY IN BROWSE brAcresDeduc = NO
           tt-duimp-acres-deduc-it.valor:READ-ONLY IN BROWSE brAcresDeduc = NO.
                                                                                          
    ASSIGN btAddAcresDeduc:SENSITIVE     IN FRAME fPage3 = NO
           btDeleteAcresDeduc:SENSITIVE  IN FRAME fPage3 = NO
           btUpdateAcresDeduc:SENSITIVE  IN FRAME fPage3 = NO
           btSaveAcresDeduc:SENSITIVE    IN FRAME fPage3 = YES
           btCancelAcresDeduc:SENSITIVE  IN FRAME fPage3 = YES
           l-add-acres-deduc                             = NO.

    APPLY "ENTRY":U TO tt-duimp-acres-deduc-it.cdn-moeda IN BROWSE brAcresDeduc.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piUpdateTributo wMaintenanceNoNavigation 
PROCEDURE piUpdateTributo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*ASSIGN brTributo:READ-ONLY IN FRAME fpage7 = NO
           tt-duimp-tributo-it.regime:READ-ONLY IN BROWSE brTributo = NO 
           tt-duimp-tributo-it.fundamento:READ-ONLY IN BROWSE brTributo = NO.
                                                                                          
    ASSIGN btUpdateTributo:SENSITIVE  IN FRAME fPage5 = NO
           btSaveTributo:SENSITIVE    IN FRAME fPage5 = YES
           btCancelTributo:SENSITIVE  IN FRAME fPage5 = YES.

    APPLY "ENTRY":U TO tt-duimp-tributo-it.regime IN BROWSE brTributo.*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piZoomAcresDeduc wMaintenanceNoNavigation 
PROCEDURE piZoomAcresDeduc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NUM-RESULTS("brAcresDeduc":U) > 0 THEN DO:
        IF tt-duimp-acres-deduc-it.idi-tipo:SCREEN-VALUE IN BROWSE brAcresDeduc = "1" 
        OR tt-duimp-acres-deduc-it.idi-tipo:SCREEN-VALUE IN BROWSE brAcresDeduc = "2" THEN DO:
            {method/zoomfields.i &ProgramZoom="cxzoom/z01cx00491.w"
                                 &FieldZoom1="id-tipo"
                                 &FieldScreen1="tt-duimp-acres-deduc-it.idi-tipo"
                                 &Browse1="brAcresDeduc"
                                 &FieldZoom2="codigo"
                                 &FieldScreen2="tt-duimp-acres-deduc-it.cdn-acres-deduc"
                                 &Browse2="brAcresDeduc"
                                 &FieldZoom3="descricao"
                                 &FieldScreen3="c-desc-AcreDed"
                                 &Browse3="brAcresDeduc"
                                 &RunMethod="RUN setaTipo IN hProgramZoom (INPUT INT(tt-duimp-acres-deduc-it.idi-tipo:SCREEN-VALUE IN BROWSE brAcresDeduc))."
                                 &EnableImplant="NO"}
        END.
        ELSE DO:
            {method/zoomfields.i &ProgramZoom="cxzoom/z01cx00491.w"
                                 &FieldZoom1="id-tipo"
                                 &FieldScreen1="tt-duimp-acres-deduc-it.idi-tipo"
                                 &Browse1="brAcresDeduc"
                                 &FieldZoom2="codigo"
                                 &FieldScreen2="tt-duimp-acres-deduc-it.cdn-acres-deduc"
                                 &Browse2="brAcresDeduc"
                                 &FieldZoom3="descricao"
                                 &FieldScreen3="c-desc-AcreDed"
                                 &Browse3="brAcresDeduc"
                                 &EnableImplant="NO"}
        END.
    END.
    
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
  Notes:       Este mÇtodo somente Ç executado quando a vari†vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnAcresDeduc wMaintenanceNoNavigation 
FUNCTION fnAcresDeduc RETURNS CHARACTER
  ( pTipo AS INTEGER, pCodigo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND FIRST siscomex-acres-deduc
       WHERE siscomex-acres-deduc.id-tipo = pTipo
         AND siscomex-acres-deduc.codigo  = pCodigo NO-LOCK NO-ERROR.
  IF AVAIL siscomex-acres-deduc THEN
      ASSIGN c-desc-AcreDed = siscomex-acres-deduc.descricao.
  ELSE 
      ASSIGN c-desc-AcreDed = "".
      
  RETURN c-desc-AcreDed.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMoeda wMaintenanceNoNavigation 
FUNCTION fnMoeda RETURNS CHARACTER
  ( pMoeda AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   RUN findCodigo IN h-boun005 (INPUT pMoeda, OUTPUT c-return).
   IF  c-return = "" THEN
       RUN getCharfield IN h-boun005 (INPUT "descricao":U, OUTPUT c-desc-moeda).
   ELSE 
       ASSIGN c-desc-moeda = "".

   RETURN c-desc-moeda.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipo wMaintenanceNoNavigation 
FUNCTION fnTipo RETURNS CHARACTER
  ( pTipo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF  pTipo = 0 THEN
      RETURN "".
  ELSE DO:
      RETURN {cxinc/i01cx00492.i 4 pTipo}. 
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTributo wMaintenanceNoNavigation 
FUNCTION fnTributo RETURNS CHARACTER
  ( pTributo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {cxinc/i01cx00497.i 4 pTributo}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

