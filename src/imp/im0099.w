&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-ordens-embarque NO-UNDO LIKE ordens-embarque
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-ordens-nac NO-UNDO LIKE ordens-embarque
       field c-it-codigo       like item.it-codigo
       field de-quantidade-nac as decimal format ">>>>>,>>9.9999"
       field i-parcela-nova    as integer
       field de-quant-nova     like prazo-compra.quantidade
       field de-qt-fn-nova     like prazo-compra.quantidade
       field r-rowid as rowid
	   field c-un-fornec       as character format "xx"
       field c-un-nosso        as character format "xx"
       field c-un-nac          as character format "xx"
       field d-qtd-sd-item     as decimal   format ">>>>>,>>9.9999".
	   
DEFINE TEMP-TABLE tt-ordens-nac-bo NO-UNDO LIKE ordens-embarque
       FIELD c-it-codigo       LIKE item.it-codigo
       FIELD de-quantidade-nac AS DECIMAL FORMAT ">>>>>,>>9.9999"
       FIELD i-parcela-nova    AS INTEGER
       FIELD de-quant-nova     LIKE prazo-compra.quantidade
       FIELD de-qt-fn-nova     LIKE prazo-compra.quantidade
       FIELD r-rowid           AS ROWID.

DEFINE TEMP-TABLE tt-ordens-embarque-aux-bo NO-UNDO LIKE tt-ordens-nac-bo.	   



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0099 2.00.00.051 } /*** "010051" 19/02/2026 11:40:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0099 MIM}
&ENDIF

/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 04/02/03 -  9:51 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

CREATE WIDGET-POOL.

{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0099
&GLOBAL-DEFINE Version        2.00.00.051
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Ordens

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        NO
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     NO

&GLOBAL-DEFINE AddSon1          NO
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       NO
&GLOBAL-DEFINE DeleteSon1       NO

&GLOBAL-DEFINE ttParent         tt-embarque-imp
&GLOBAL-DEFINE hDBOParent       h-bocx220f
&GLOBAL-DEFINE DBOParentTable   embarque-imp
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           tt-ordens-embarque
&GLOBAL-DEFINE hDBOSon1         h-bocx225
&GLOBAL-DEFINE DBOSon1Table     ordens-embarque
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE page0Fields      tt-embarque-imp.cod-estabel ~
                                tt-embarque-imp.embarque ~
                                da-entrega ~
                                c-embarque-novo ~
                                da-nova-entrega ~
                                c-fatura
&GLOBAL-DEFINE page1Fields      btConfirma ~
                                tb-atualiza-qtde
&GLOBAL-DEFINE page1Browse      brSon1

&GLOBAL-DEFINE numRowsReturned  inumRowsReturned

&GLOBAL-DEFINE EXCLUDE-ApplyOffEnd


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx230     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx383     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx115     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin274     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx250     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin082     AS HANDLE NO-UNDO. /* Utilizada para obter a Unidade do Fornecedor */
DEFINE VARIABLE h-boin172     AS HANDLE NO-UNDO. /* Utilizada para obter a Unidade do Item       */
DEFINE VARIABLE h-bocx312     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx315     AS HANDLE NO-UNDO.
DEFINE VARIABLE inumRowsReturned AS INT NO-UNDO.

DEFINE VARIABLE gcLastParentKey           AS CHARACTER NO-UNDO.
DEFINE VARIABLE glForceOpenQueriesSon     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE glSuppressAfterDisplay    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE glApplyingValueChanged    AS LOGICAL   NO-UNDO.


DEFINE VARIABLE c-return              AS   CHARACTER             NO-UNDO.
DEFINE VARIABLE c-it-codigo           LIKE item.it-codigo        NO-UNDO.
DEFINE VARIABLE i-seq-erro            AS   INTEGER               NO-UNDO.
DEFINE VARIABLE c-un-fornec           AS   CHARACTER             NO-UNDO.
DEFINE VARIABLE c-un-nosso            AS   CHARACTER             NO-UNDO.
DEFINE VARIABLE c-un-nac              AS   CHARACTER             NO-UNDO.
DEFINE VARIABLE l-not-atualizado      AS   LOGICAL               NO-UNDO.
DEFINE VARIABLE l-contabilizado       AS   LOGICAL INITIAL NO    NO-UNDO.
DEFINE VARIABLE l-ok                  AS   LOGICAL               NO-UNDO.
DEFINE VARIABLE l-tax-siscomex        AS   LOGICAL               NO-UNDO.
DEFINE VARIABLE i-numero-ordem-ini    AS   INTEGER               NO-UNDO.
DEFINE VARIABLE i-numero-ordem-fim    AS   INTEGER               NO-UNDO.
DEFINE VARIABLE i-parcela-ini         AS   INTEGER               NO-UNDO.
DEFINE VARIABLE i-parcela-fim         AS   INTEGER               NO-UNDO.
DEFINE VARIABLE c-item-ini            AS   CHARACTER             NO-UNDO.
DEFINE VARIABLE c-item-fim            AS   CHARACTER             NO-UNDO.
DEFINE VARIABLE c-tax-siscomex        AS   CHARACTER             NO-UNDO.
DEFINE VARIABLE c-pedido-drb          AS   CHARACTER             NO-UNDO.
DEFINE VARIABLE l-permite-quebra      AS   LOGICAL               NO-UNDO.
DEFINE VARIABLE l-possui-antecip      AS   LOGICAL               NO-UNDO.
DEFINE VARIABLE l-possui-nota         AS   LOGICAL               NO-UNDO.
DEFINE VARIABLE d-return              AS   DECIMAL format ">>>>>,>>9.9999"  NO-UNDO.
DEFINE VARIABLE d-qtd-sd-item         AS   DECIMAL format ">>>>>,>>9.9999"  NO-UNDO.
DEFINE VARIABLE l-drb                 AS   LOGICAL                          NO-UNDO.
DEFINE VARIABLE c-embarque-principal  LIKE embarque-imp.embarque            NO-UNDO.
DEFINE VARIABLE d-cdd-siscomex-dts    LIKE decla-import.cdd-siscomex-dts    NO-UNDO.

{cdp/cdcfgmat.i} /* Include pr‚-processadores */
{include/boerrtab.i}

{cxbo/bocx220f.i1 tt-embarque-novo} /* Temp-table tt-embarque-novo */

def temp-table tt-retorno-erro NO-UNDO
    field embarque          like embarque-imp.embarque
    field cod-estabel       like embarque-imp.cod-estabel
    field cod-erro          as integer     format ">>>>>>>>9" label "C¢digo"
    field mensagem          as character   format "x(80)" label "Mensagem"
    field sequen            as integer     
    INDEX codigo IS PRIMARY embarque
                            cod-estabel
                            sequen.

&IF DEFINED(bf-mat-comex) &THEN
&else
    def temp-table tt-embarque-contab NO-UNDO
        field embarque          like embarque-imp.embarque
        field cod-estabel       like lin-i-ap.cod-estabel
        field ep-codigo         like lin-i-ap.ep-codigo
        field cod-esp           like lin-i-ap.cod-esp
        field serie             like lin-i-ap.serie
        field nr-docto          like lin-i-ap.nr-docto
        field parcela           like lin-i-ap.parcela
        field cod-fornec        like lin-i-ap.cod-fornec.
&ENDIF

DEFINE TEMP-TABLE tt-ordens-embarque-aux NO-UNDO LIKE tt-ordens-nac.

/* Cache unidade por item */
DEFINE TEMP-TABLE tt-cache-un-item NO-UNDO
    FIELD it-codigo LIKE item.it-codigo
    FIELD un        AS CHARACTER FORMAT "xx"
    INDEX pk IS PRIMARY it-codigo.

/* Cache unidade do fornecedor por ordem */
DEFINE TEMP-TABLE tt-cache-un-fornec NO-UNDO
    FIELD numero-ordem AS INTEGER
    FIELD un           AS CHARACTER FORMAT "xx"
    INDEX pk IS PRIMARY numero-ordem.

/* Cache do nr-pedido-drb por (estabel + DIT) */
DEFINE TEMP-TABLE tt-cache-pedido-drb NO-UNDO
    FIELD cod-estabel  LIKE estabelec.cod-estabel
    FIELD dit          AS CHARACTER FORMAT "x(20)"
    FIELD nr-pedido-drb AS CHARACTER
    INDEX pk IS PRIMARY cod-estabel dit.

/* Cache saldo por (estabel + pedido-drb + item) */
DEFINE TEMP-TABLE tt-cache-qtd-sdo NO-UNDO
    FIELD cod-estabel   LIKE estabelec.cod-estabel
    FIELD nr-pedido-drb AS CHARACTER
    FIELD it-codigo     LIKE item.it-codigo
    FIELD qtd-sdo-item  AS DECIMAL FORMAT ">>>>>,>>9.9999"
    INDEX pk IS PRIMARY cod-estabel nr-pedido-drb it-codigo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ordens-nac

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 	tt-ordens-nac.numero-ordem  	tt-ordens-nac.parcela  	tt-ordens-nac.c-it-codigo tt-ordens-nac.qt-do-forn tt-ordens-nac.c-un-fornec tt-ordens-nac.quantidade tt-ordens-nac.c-un-nosso tt-ordens-nac.de-quantidade-nac tt-ordens-nac.c-un-nac tt-ordens-nac.nr-proc-imp tt-ordens-nac.d-qtd-sd-item      
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 tt-ordens-nac.de-quantidade-nac   
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon1 tt-ordens-nac
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon1 tt-ordens-nac
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-ordens-nac NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-nac NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-ordens-nac
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-ordens-nac


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define ENABLED-TABLES tt-embarque-imp
&Scoped-define FIRST-ENABLED-TABLE tt-embarque-imp
&Scoped-Define ENABLED-OBJECTS RECT-1 rtParent rtToolBar btFirst btPrev ~
btNext btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
da-entrega c-embarque-novo da-nova-entrega c-fatura 
&Scoped-Define DISPLAYED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define DISPLAYED-TABLES tt-embarque-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-embarque-imp
&Scoped-Define DISPLAYED-OBJECTS da-entrega tb-integr-visao-di ~
c-embarque-novo da-nova-entrega c-fatura 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-item wMasterDetail 
FUNCTION fn-item RETURNS CHARACTER
  ( input p-numero-ordem as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnParentKey wMasterDetail 
FUNCTION fnParentKey RETURNS CHARACTER ( )  FORWARD.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUM

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnQtdSdItem wMasterDetail 
FUNCTION fnQtdSdItem RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnFornec wMasterDetail 
FUNCTION fnUnFornec RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnItem wMasterDetail 
FUNCTION fnUnItem RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

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

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE c-embarque-novo AS CHARACTER FORMAT "X(16)":U 
     LABEL "Novo Embarque" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-fatura AS CHARACTER FORMAT "X(12)":U 
     LABEL "Fatura" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE da-entrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Entrega" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE da-nova-entrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Nova Dt Entrega" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-di-ems AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "DI/DUIMP EMS" 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.63.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.67.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tb-integr-visao-di AS LOGICAL INITIAL no 
     LABEL "Integrado VisÆo DI/DUIMP" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE BUTTON btConfirma 
     LABEL "&Confirma" 
     SIZE 15 BY 1 TOOLTIP "Confirma".

DEFINE BUTTON btSelecao 
     LABEL "&Sele‡Æo" 
     SIZE 15 BY 1.

DEFINE VARIABLE tb-atualiza-qtde AS LOGICAL INITIAL no 
     LABEL "Atualiza Qtde Total a Nacionalizar" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.57 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-ordens-nac SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 DISPLAY
      tt-ordens-nac.numero-ordem
      tt-ordens-nac.parcela
      tt-ordens-nac.c-it-codigo
      tt-ordens-nac.qt-do-forn          LABEL "Quant. Fornec"
      tt-ordens-nac.c-un-fornec         LABEL "Un Fornec" FORMAT "xx"
      tt-ordens-nac.quantidade
      tt-ordens-nac.c-un-nosso          LABEL "Un"        FORMAT "xx"
      tt-ordens-nac.de-quantidade-nac   LABEL "Qtde a Nacionalizar"
      tt-ordens-nac.c-un-nac            LABEL "Un"        FORMAT "xx"
      tt-ordens-nac.nr-proc-imp         LABEL "Processo Imp"
      tt-ordens-nac.d-qtd-sd-item       LABEL "Qtde Saldo DIT"

    ENABLE
      tt-ordens-nac.de-quantidade-nac
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82.43 BY 7.42
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
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
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-embarque-imp.cod-estabel AT ROW 3 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-embarque-imp.embarque AT ROW 3 COL 41.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     da-entrega AT ROW 3 COL 76.57 COLON-ALIGNED
     tb-integr-visao-di AT ROW 4 COL 3
     fi-num-di-ems AT ROW 4 COL 41.43 COLON-ALIGNED
     c-embarque-novo AT ROW 5.63 COL 13 COLON-ALIGNED
     da-nova-entrega AT ROW 5.63 COL 43 COLON-ALIGNED
     c-fatura AT ROW 5.63 COL 76.57 COLON-ALIGNED
     RECT-1 AT ROW 5.25 COL 1
     rtParent AT ROW 2.58 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 2 COL 3
     btSelecao AT ROW 9.54 COL 3.29
     btConfirma AT ROW 9.54 COL 70.43
     tb-atualiza-qtde AT ROW 9.63 COL 41.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.17
         SIZE 86.86 BY 10.33
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-ordens-embarque T "?" NO-UNDO mgcex ordens-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-ordens-nac T "?" NO-UNDO mgcex ordens-embarque
      ADDITIONAL-FIELDS:
          field c-it-codigo       like item.it-codigo
          field de-quantidade-nac as decimal format ">>>>>,>>9.9999"
          field i-parcela-nova    as integer
          field de-quant-nova     like prazo-compra.quantidade
          field de-qt-fn-nova     like prazo-compra.quantidade
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18
         WIDTH              = 90
         MAX-HEIGHT         = 38.21
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.21
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{imp/im0100b.i3 ERROR}
{masterdetail/masterdetail.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-num-di-ems IN FRAME fPage0
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-num-di-ems:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tb-integr-visao-di IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-nac NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btConfirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirma wMasterDetail
ON CHOOSE OF btConfirma IN FRAME fPage1 /* Confirma */
DO:    
    DEF VAR c-nr-ato-concessorio AS CHAR FORMAT "X(30)" NO-UNDO.
       
    &if '{&bf_mat_versao_ems}' < '2.09' &then
       ASSIGN c-embarque-principal = IF SUBSTRING(tt-embarque-imp.char-1,61,20) <> "" THEN 
                                       SUBSTRING(tt-embarque-imp.char-1,61,20) 
                                     ELSE tt-embarque-imp.embarque.
    &ELSE   
       ASSIGN c-embarque-principal = IF tt-embarque-imp.cod-embarq-inicial-quebra <> "" THEN 
                                       tt-embarque-imp.cod-embarq-inicial-quebra 
                                     ELSE tt-embarque-imp.embarque.                                        
    &ENDIF

    IF  i-pais-impto-usuario <> 1 THEN DO:
        
        RUN getAtoConcessorioEmbarque IN h-bocx225 (input tt-embarque-imp.cod-estabel,
                                                    INPUT tt-embarque-imp.embarque,
                                                    OUTPUT c-nr-ato-concessorio).
        IF  c-nr-ato-concessorio = ""
        OR  c-nr-ato-concessorio = ? THEN
            ASSIGN c-embarque-principal = tt-embarque-imp.embarque. 
    END.

    /*Verifica se existe nota gerada para o embarque, caso haja e 
      nÆo seja de simples remessa mÆe, nÆo permite quebra do embarque*/
    RUN pi-ver-embarque-possui-nota IN h-bocx220f ( INPUT tt-embarque-imp.cod-estabel,
                                                    INPUT c-embarque-principal,
                                                    INPUT fi-num-di-ems:SCREEN-VALUE IN FRAME fPage0,
                                                    INPUT d-cdd-siscomex-dts,
                                                    OUTPUT l-possui-nota,
                                                    OUTPUT l-permite-quebra).
    IF NOT l-permite-quebra THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-desembarque-parcial-nao-permit AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Desembarque_Parcial_nÆo_permitido" *}
        ASSIGN c-lbl-liter-desembarque-parcial-nao-permit = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-nao-e-permitido-realizar-este AS CHARACTER NO-UNDO.        
        {utp/ut-liter.i "NÆo_‚_permitido_realizar_este_procedimento_pois_o_embarque_principal_possui_nota_fiscal_no_recebimento_diferente_de_Simples_Remessa_MÆe" *}
        ASSIGN c-lbl-liter-nao-e-permitido-realizar-este = TRIM(RETURN-VALUE).

        IF i-pais-impto-usuario = 1 /* Brasil */ OR NOT l-drb THEN 
            run utp/ut-msgs.p (input "show":U,
                               input 17006,
                               input c-lbl-liter-desembarque-parcial-nao-permit + " " + "~~ " +
                                     c-lbl-liter-nao-e-permitido-realizar-este ).
        ELSE
            run utp/ut-msgs.p (input "show":U,
                               input 55797,
                               input "").
        RETURN NO-APPLY.
    END.
    assign i-seq-erro = i-seq-erro + 1.
    create tt-bo-erro.
    assign tt-bo-erro.errorsubtype = "Question".

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Desembarque_Parcial" *}
    run utp/ut-msgs.p (input "show":U,
                       input 701,
                       input RETURN-VALUE).

    if return-value = "YES" then
       run piConfirma.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="cxzoom/z03cx220.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao wMasterDetail
ON CHOOSE OF btSelecao IN FRAME fPage1 /* Sele‡Æo */
DO:

  FOR EACH tt-ordens-nac:
      FIND FIRST tt-ordens-embarque-aux
           WHERE tt-ordens-embarque-aux.cod-estabel  = tt-ordens-nac.cod-estabel
             AND tt-ordens-embarque-aux.embarque     = tt-ordens-nac.embarque
             AND tt-ordens-embarque-aux.numero-ordem = tt-ordens-nac.numero-ordem
             AND tt-ordens-embarque-aux.parcela      = tt-ordens-nac.parcela NO-LOCK NO-ERROR.

      IF AVAIL tt-ordens-embarque-aux THEN
         ASSIGN tt-ordens-embarque-aux.de-quantidade-nac =  tt-ordens-nac.de-quantidade-nac.

  END.

  ASSIGN l-ok = NO.
  RUN imp/im0099aa.w (INPUT-OUTPUT i-numero-ordem-ini,
                      INPUT-OUTPUT i-numero-ordem-fim,
                      INPUT-OUTPUT i-parcela-ini,
                      INPUT-OUTPUT i-parcela-fim,
                      INPUT-OUTPUT c-item-ini,
                      INPUT-OUTPUT c-item-fim,
                      OUTPUT l-ok).

  IF l-ok = YES THEN DO:

     run setConstraintSelecao in {&hDBOSon1} (INPUT tt-embarque-imp.cod-estabel,
                                              INPUT tt-embarque-imp.embarque,
                                              INPUT i-numero-ordem-ini,
                                              INPUT i-numero-ordem-fim,
                                              INPUT i-parcela-ini,
                                              INPUT i-parcela-fim,
                                              INPUT c-item-ini,
                                              INPUT c-item-fim).


     /* Monta TTs compatíveis para conversar com o BO */
	EMPTY TEMP-TABLE tt-ordens-embarque-aux-bo.
	FOR EACH tt-ordens-embarque-aux NO-LOCK:
		CREATE tt-ordens-embarque-aux-bo.
		BUFFER-COPY tt-ordens-embarque-aux TO tt-ordens-embarque-aux-bo.
	END.

	EMPTY TEMP-TABLE tt-ordens-nac-bo.
	FOR EACH tt-ordens-nac NO-LOCK:
		CREATE tt-ordens-nac-bo.
		BUFFER-COPY tt-ordens-nac TO tt-ordens-nac-bo.
	END.

	RUN cria-tt-ordens-nac-selecao IN {&hDBOSon1} (INPUT  TABLE tt-ordens-embarque-aux-bo,
												  INPUT-OUTPUT TABLE tt-ordens-nac-bo).

	/* Volta para TT de tela e recalcula campos extras */
	EMPTY TEMP-TABLE tt-ordens-nac.
	FOR EACH tt-ordens-nac-bo NO-LOCK:
		CREATE tt-ordens-nac.
		BUFFER-COPY tt-ordens-nac-bo TO tt-ordens-nac.
	END.

	RUN piPreencheCamposBrowse IN THIS-PROCEDURE.
     
	 
     {&OPEN-QUERY-brSon1}
     APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME c-embarque-novo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-embarque-novo wMasterDetail
ON LEAVE OF c-embarque-novo IN FRAME fpage0 /* Novo Embarque */
DO:
    ASSIGN c-embarque-novo:screen-value in frame fpage0 = TRIM(c-embarque-novo:screen-value in frame fpage0).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-atualiza-qtde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-atualiza-qtde wMasterDetail
ON VALUE-CHANGED OF tb-atualiza-qtde IN FRAME fPage1 /* Atualiza Qtde Total a Nacionalizar */
DO:
  IF tb-atualiza-qtde:CHECKED IN FRAME fPage1 THEN
      FOR EACH tt-ordens-nac:
          ASSIGN tt-ordens-nac.de-quantidade-nac = tt-ordens-nac.quantidade.
      END.
  ELSE
      FOR EACH tt-ordens-nac:
          ASSIGN tt-ordens-nac.de-quantidade-nac = 0.
      END.

  {&OPEN-QUERY-brSon1}
  
  ASSIGN glApplyingValueChanged = TRUE.
  APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
  ASSIGN glApplyingValueChanged = FALSE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if valid-handle(h-bocx115) then
        delete procedure h-bocx115.
    
    if valid-handle(h-bocx230) then
        delete procedure h-bocx230.
        
    if valid-handle(h-bocx383) then
        delete procedure h-bocx383.
    if valid-handle(h-boin274) then 
        delete procedure h-boin274. 

    if valid-handle(h-boin172) then
        delete procedure h-boin172.

    if valid-handle(h-boin082) then
        delete procedure h-boin082.

    if valid-handle(h-bocx315) then
        RUN destroy IN h-bocx315.

    if valid-handle(h-bocx312) then
        RUN destroy IN h-bocx312.

    ASSIGN h-bocx115 = ?
           h-bocx230 = ?
           h-boin274 = ?
           h-boin172 = ?
           h-boin082 = ?
           h-bocx383 = ?
           h-bocx312 = ?
           h-bocx315 = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-return           as char    no-undo.
    def var i-cod-itiner       as integer no-undo.
    def var i-pto-chegada      as integer no-undo.
    DEF VAR i-num-di-ems       AS INTEGER NO-UNDO.

	/* Se estou em atualização/confirmando ou numa reposição programática, não rodar refresh pesado */
	IF glSuppressAfterDisplay THEN
		RETURN "OK":U.
    
    assign da-entrega = ?
           c-embarque-principal = ""
           d-cdd-siscomex-dts = 0.

    if avail tt-embarque-imp then do:
    
        /*
        ** Busca data prevista/efetiva de entrega do embarque
        */
        run findFirstEmbarque in h-bocx230 (input tt-embarque-imp.cod-estabel,
                                            input tt-embarque-imp.embarque,
                                            output c-return).
        RUN openQueryStatic IN h-bocx383 ("Main").
        /*Verifica se embarque est  relacionado a DI, se estiver traz o n£mero da DI,
          grava no campo em tela e deixa vis¡vel o mesmo*/
        RUN pi-busca-di-embarque IN h-bocx383 (INPUT tt-embarque-imp.embarque,
                                               INPUT tt-embarque-imp.cod-estabel,
                                               OUTPUT i-num-di-ems).
        IF  i-num-di-ems = 0 THEN DO:
            /*Verifica se embarque est  relacionado a DUIMP, se estiver traz o n£mero da DUIMP,
              grava no campo em tela e deixa vis¡vel o mesmo*/
            RUN pi-busca-duimp-embarque IN h-bocx383 (INPUT tt-embarque-imp.embarque,
                                                      INPUT tt-embarque-imp.cod-estabel,
                                                      OUTPUT i-num-di-ems).
            ASSIGN d-cdd-siscomex-dts = i-num-di-ems.
        END.

        IF i-num-di-ems <> 0 THEN DO:
            ASSIGN fi-num-di-ems:SCREEN-VALUE IN FRAME fPage0 = string(i-num-di-ems)
                   fi-num-di-ems:HIDDEN IN FRAME fPage0 = FALSE
                   tb-integr-visao-di:CHECKED IN FRAME fPage0 = TRUE.
        END.
        ELSE DO:
            ASSIGN fi-num-di-ems:SCREEN-VALUE IN FRAME fPage0 = ""
                   fi-num-di-ems:HIDDEN IN FRAME fPage0 = TRUE
                   tb-integr-visao-di:CHECKED IN FRAME fPage0 = FALSE.
        END.
        if c-return = "" then
            run getIntfield in h-bocx230 (input "cod-itiner":U,output i-cod-itiner).
        run findCodigo in h-bocx115 (input i-cod-itiner,output c-return).
        if c-return = "" then 
            run getIntfield in h-bocx115 (input "pto-chegada":U,output i-pto-chegada).
        run findCh-itiner in h-bocx230 (input tt-embarque-imp.cod-estabel,
                                        input tt-embarque-imp.embarque,
                                        input i-cod-itiner,
                                        input i-pto-chegada,
                                        output c-return).
        if c-return = "":U then
            run getDateField in h-bocx230 (input "dt-efetiva":U,output da-entrega).
        if da-entrega = ? and c-return = "":U then
            run getDateField in h-bocx230 (input "dt-ult-previsao":U,output da-entrega).


        IF i-pais-impto-usuario <> 1 THEN DO:
            &if '{&bf_mat_versao_ems}' < '2.09' &then
               ASSIGN c-embarque-principal = IF SUBSTRING(tt-embarque-imp.char-1,61,20) <> "" THEN 
                                               SUBSTRING(tt-embarque-imp.char-1,61,20) 
                                             ELSE tt-embarque-imp.embarque.
            &ELSE   
               ASSIGN c-embarque-principal = IF tt-embarque-imp.cod-embarq-inicial-quebra <> "" THEN 
                                               tt-embarque-imp.cod-embarq-inicial-quebra 
                                             ELSE tt-embarque-imp.embarque.                                        
            &ENDIF
        END.
    end.
    
    disp da-entrega with frame fPage0.

    ASSIGN brSon1:NUM-LOCKED-COLUMNS IN FRAME fPage1 = 3.
      
    IF i-pais-impto-usuario <> 1 THEN DO:
    
        ASSIGN l-drb = AVAIL tt-ordens-embarque AND SUBSTRING(tt-ordens-embarque.char-1,1,20) <> "" /*DIT*/.
    
        IF NOT l-drb THEN DO:
            {utp/ut-liter.i "Qtde_a_Nacionalizar" *}
            ASSIGN tt-ordens-nac.de-quantidade-nac:LABEL IN BROWSE {&browse-name} = RETURN-VALUE
                   tt-ordens-nac.d-qtd-sd-item:VISIBLE IN BROWSE {&browse-name} = NO.
            {utp/ut-liter.i "Atualiza Qtde Total a Nacionalizar" *}
            ASSIGN tb-atualiza-qtde:LABEL IN frame fPage1 = trim(return-value).
        END.
        ELSE DO:
            {utp/ut-liter.i "Qtde_Isenta"}            
            ASSIGN tt-ordens-nac.de-quantidade-nac:LABEL IN BROWSE {&browse-name} = RETURN-VALUE
                   tt-ordens-nac.d-qtd-sd-item:VISIBLE IN BROWSE {&browse-name} = YES.
            {utp/ut-liter.i "Atualiza Qtde Total Isenta" *}
            ASSIGN tb-atualiza-qtde:LABEL IN frame fPage1 = trim(return-value).
        END.
    END.

    APPLY "ENTRY":U TO tt-ordens-nac.de-quantidade-nac IN BROWSE {&browse-name}.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyoffend wMasterDetail 
PROCEDURE applyoffend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
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

    DEFINE VARIABLE c-cod-estabel LIKE {&ttParent}.cod-estabel NO-UNDO.    
    DEFINE VARIABLE c-embarque    LIKE {&ttParent}.embarque    NO-UNDO.
    
    def var cStatus as char no-undo.
    
    DEFINE FRAME fGoToRecord
        c-cod-estabel  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        c-embarque     AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK       AT ROW 3.63 COL 2.14
        btGoToCancel   AT ROW 3.63 COL 13
        rtGoToButton   AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Embarque a Nacionalizar" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Embarque_a_Nacionalizar"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-estabel c-embarque.
            
        RUN findCodigo IN h-bocx220f (INPUT c-cod-estabel,
                                     INPUT c-embarque, 
                                     OUTPUT cStatus).
        IF cStatus <> "":U THEN DO:
           /* Inicio -- Projeto Internacional */
           {utp/ut-liter.i "Embarque" *}
           RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                              INPUT 2, 
                              INPUT RETURN-VALUE).           
           RETURN NO-APPLY.
        END.
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN h-bocx220f (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    assign c-cod-estabel:width  in frame fGoToRecord = 5
           c-cod-estabel:height in frame fGoToRecord = 0.88
           c-embarque:width     in frame fGoToRecord = 17
           c-cod-estabel:height in frame fGoToRecord = 0.88.
    
    ENABLE c-cod-estabel c-embarque btGoToOK btGoToCancel
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /*
    ** BO Espec¡fica para Desembarque Parcial/EADI
    */
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "cxbo/bocx220f.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx220f.p YES}
        {btb/btb008za.i2 cxbo/bocx220f.p '' {&hDBOParent}} 
    END.
    
    RUN setConstraint1  IN {&hDBOParent}           NO-ERROR.
    RUN openQuery       IN {&hDBOParent} (INPUT 1) NO-ERROR.
    
    /*
    ** BO Ordens Embarque
    */    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "cxbo/bocx225.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx225.p YES}
        {btb/btb008za.i2 cxbo/bocx225.p '' {&hDBOSon1}} 
    END.
    
    /*
    ** BO Historico Embarque
    */    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-bocx230) OR 
       h-bocx230:TYPE <> "PROCEDURE":U OR
       h-bocx230:FILE-NAME <> "cxbo/bocx230.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx230.p YES}
        {btb/btb008za.i2 cxbo/bocx230.p '' h-bocx230} 
    END.    
    
    /*
    ** BO Declara‡Æo Importa‡Æo
    */    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-bocx383) OR 
       h-bocx383:TYPE <> "PROCEDURE":U OR
       h-bocx383:FILE-NAME <> "cxbo/bocx383.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx383.p YES}
        {btb/btb008za.i2 cxbo/bocx383.p '' h-bocx383} 
    END.   
    /** BO Itiner rio
    */    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-bocx115) OR 
       h-bocx115:TYPE <> "PROCEDURE":U OR
       h-bocx115:FILE-NAME <> "cxbo/bocx115.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx115.p YES}
        {btb/btb008za.i2 cxbo/bocx115.p '' h-bocx115} 
    END.
    
    /*
    ** BO Ordem de Compra
    */    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boin274) OR 
       h-boin274:TYPE <> "PROCEDURE":U OR
       h-boin274:FILE-NAME <> "inbo/boin274.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin274.p YES}
        {btb/btb008za.i2 inbo/boin274.p '' h-boin274} 
    END.
    

    run inbo/boin172.p persistent set h-boin172.
    run inbo/boin082.p persistent set h-boin082.
    RUN cxbo/bocx315.p persistent set h-bocx315.
    RUN cxbo/bocx312.p persistent set h-bocx312.

    RUN openQueryStatic IN h-bocx315 (INPUT "Main":U) NO-ERROR.
    RUN openQueryStatic IN h-bocx312 (INPUT "Main":U) NO-ERROR.

    enable c-embarque-novo
           da-nova-entrega
           c-fatura with frame fPage0.
    enable btConfirma 
           btSelecao  
           tb-atualiza-qtde with frame fPage1.

    &IF '{&mgdis_version}' < '2.06f' &THEN
        /*Tecnica para implementar valida‡Æo produto Estendido*/
        {cdp/cdapi558.i1}
    &endif
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    def var p-cod-estabel like estabelec.cod-estabel no-undo.
    def var p-embarque    like embarque-imp.embarque no-undo.
	def var cKey 		  as CHARACTER NO-UNDO.
	
	assign cKey = fnParentKey().
	
	IF cKey = "":U THEN
		ASSIGN cKey = "<SEM-PAI>":U.
	
	IF NOT glForceOpenQueriesSon
		AND cKey = gcLastParentKey THEN
	  RETURN "OK":U.
	  
	ASSIGN 
		gcLastParentKey = cKey
		glForceOpenQueriesSon = FALSE.
		
    if avail tt-embarque-imp then
        assign p-cod-estabel = tt-embarque-imp.cod-estabel
               p-embarque    = tt-embarque-imp.embarque.
    else
        assign p-cod-estabel = "":U
               p-embarque    = "":U.
	
	FOR EACH tt-ordens-nac:
		DELETE tt-ordens-nac.
	END.
   
    RUN Return_numRowsReturned IN {&hDBOSon1}(INPUT p-cod-estabel,
                                              INPUT p-embarque,
                                              OUTPUT inumRowsReturned).

   {masterdetail/OpenQueriesSon.i
            &Parent="tt-embarque-imp"
            &Query="ordens-embarque"
            &PageNumber="1"
            &QueryConstraint="4"
            &ConstraintParameters="p-embarque, p-cod-estabel"}
    
    find first tt-ordens-embarque no-error.        
    if avail tt-ordens-embarque then do:
        ENABLE btConfirma 
               btSelecao  
            WITH FRAME fPage1.
        ASSIGN tb-atualiza-qtde:CHECKED IN FRAME fPage1 = NO.
	END.
	ELSE DO:
		DISABLE btConfirma btSelecao WITH FRAME fPage1.
		ASSIGN tb-atualiza-qtde:CHECKED IN FRAME fPage1 = NO.
	END.
	
	IF CAN-FIND (FIRST tt-ordens-embarque) THEN DO:

		EMPTY TEMP-TABLE tt-ordens-nac-bo.
		EMPTY TEMP-TABLE tt-ordens-embarque-aux-bo.

		/* BO preenche a TT compatível (assinatura original) */
		RUN createOrdensNac IN {&hDBOSon1} (INPUT  TABLE tt-ordens-embarque,
										   OUTPUT TABLE tt-ordens-nac-bo,
										   OUTPUT TABLE tt-ordens-embarque-aux-bo).

		/* Copia para as TTs de tela (que têm campos extras) */
		EMPTY TEMP-TABLE tt-ordens-nac.
		FOR EACH tt-ordens-nac-bo NO-LOCK:
			CREATE tt-ordens-nac.
			BUFFER-COPY tt-ordens-nac-bo TO tt-ordens-nac.
		END.

		EMPTY TEMP-TABLE tt-ordens-embarque-aux.
		FOR EACH tt-ordens-embarque-aux-bo NO-LOCK:
			CREATE tt-ordens-embarque-aux.
			BUFFER-COPY tt-ordens-embarque-aux-bo TO tt-ordens-embarque-aux.
		END.

		/* Agora sim preenche os campos extras (unidades/saldo/cache) */
		RUN piPreencheCamposBrowse IN THIS-PROCEDURE.

	END.

	{&OPEN-QUERY-{&page1browse}}
	
	ASSIGN GLaPPLYINGvALUEcHANGED = TRUE.
    APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
	ASSIGN glApplyingValueChanged = FALSE.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConfirma wMasterDetail 
PROCEDURE piConfirma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var r-embarque-imp      as rowid no-undo.
    def var r-embarque-imp-orig as rowid no-undo.   
    DEF VAR l-relaciona-di      AS LOG NO-UNDO.
    /*
    ** Limpa tabela de parƒmetros para novo embarque
    */
    FOR EACH tt-embarque-novo:
        DELETE tt-embarque-novo.
    END.
      
    FOR EACH  tt-ordens-embarque-aux:
        FIND FIRST tt-ordens-nac
             WHERE tt-ordens-nac.cod-estabel  = tt-ordens-embarque-aux.cod-estabel  
               AND tt-ordens-nac.embarque     = tt-ordens-embarque-aux.embarque     
               AND tt-ordens-nac.numero-ordem = tt-ordens-embarque-aux.numero-ordem 
               AND tt-ordens-nac.parcela      = tt-ordens-embarque-aux.parcela EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAIL tt-ordens-nac THEN DO:
           CREATE tt-ordens-nac.
           BUFFER-COPY tt-ordens-embarque-aux TO tt-ordens-nac.
        END.
    END.

    /*
    ** Grava valores da tela
    */       
    assign input frame fPage0 c-embarque-novo
                              da-nova-entrega
                              c-fatura.
    
    create tt-embarque-novo.
    assign tt-embarque-novo.c-cod-estabel   = tt-embarque-imp.cod-estabel
           tt-embarque-novo.c-embarque      = tt-embarque-imp.embarque
           tt-embarque-novo.c-embarque-novo = trim(c-embarque-novo)
           tt-embarque-novo.da-nova-entrega = da-nova-entrega
           tt-embarque-novo.c-fatura        = c-fatura
           r-embarque-imp-orig              = tt-embarque-imp.r-rowid.

    IF i-pais-impto-usuario <> 1 AND l-drb THEN 
        ASSIGN tt-embarque-novo.log-embarq-transf-draw = YES.
    
    /*Grava o embarque principal no novo embarque(Embarque da Nota MÆe) */
    &if '{&bf_mat_versao_ems}' < '2.09' &then
       ASSIGN tt-embarque-novo.c-embarque-inicial = IF substring(tt-embarque-imp.char-1,61,20) <> "" THEN 
                                                       substring(tt-embarque-imp.char-1,61,20) 
                                                    ELSE 
                                                        tt-embarque-imp.embarque.
    &ELSE                                           
       ASSIGN tt-embarque-novo.c-embarque-inicial = IF tt-embarque-imp.cod-embarq-inicial-quebra <> "" THEN 
                                                      tt-embarque-imp.cod-embarq-inicial-quebra 
                                                    ELSE 
                                                       tt-embarque-imp.embarque.
    &ENDIF
    RUN cxbo/bocx250.p PERSISTENT SET h-bocx250.
    RUN findCodigo IN h-bocx250 (INPUT tt-embarque-imp.cod-estabel, OUTPUT c-return).
    
    &if '{&bf_mat_versao_ems}' >= '2.07' &then
     RUN getLogField IN h-bocx250 (INPUT "log-tax-siscomex", OUTPUT l-tax-siscomex).
    &else
     RUN getCharField IN h-bocx250 (INPUT "char-1", OUTPUT c-tax-siscomex).
     ASSIGN l-tax-siscomex  = IF INT(SUBSTR(c-tax-siscomex, 105, 1)) = 1 THEN YES ELSE NO.
    &endif
    DELETE PROCEDURE h-bocx250.
    
    IF  l-tax-siscomex THEN DO:
        RUN utp/ut-msgs.p (INPUT "show", INPUT 33880, INPUT "").
        IF  RETURN-VALUE <> "yes" THEN DO:
            SESSION:SET-WAIT-STATE("":U).
            RETURN NO-APPLY.
        END.
    END.
    
    /*
    ** Valida parƒmetros informados em tela
    */

    RUN verificaembarquecontabilizado IN h-bocx220f (INPUT TABLE tt-embarque-novo,
                                                     OUTPUT l-contabilizado).
    
    IF l-contabilizado THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Embarque_j _contabilizado" *}
        run utp/ut-msgs.p (input "show":U,
                           input 29637,
                           input RETURN-VALUE + "!").
        &IF DEFINED(bf-mat-comex) &THEN
        &else
            RUN verificanotamaeatual IN h-bocx220f (INPUT tt-embarque-imp.cod-estabel,
                                                    INPUT tt-embarque-imp.embarque,
                                                    OUTPUT l-not-atualizado).
            IF  l-not-atualizado THEN DO:
    
                    ASSIGN i-seq-erro = i-seq-erro + 1.
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.errorsubtype = "Question".
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Embarque_selecionado_possui_nota_mÆe_nÆo_atualizada_no_AP" *}
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 30413,
                                       INPUT RETURN-VALUE + "!").
                    IF RETURN-VALUE = "NO" THEN DO:
                       SESSION:SET-WAIT-STATE("":U).
                       RETURN NO-APPLY.
                    END.

            END.
        &ENDIF

    END.
    
    /* Passa para o BO uma TT compatível (sem campos extras de tela) */
	EMPTY TEMP-TABLE tt-ordens-nac-bo.
	FOR EACH tt-ordens-nac NO-LOCK:
		CREATE tt-ordens-nac-bo.
		BUFFER-COPY tt-ordens-nac TO tt-ordens-nac-bo.
	END.

	RUN preparaDesembarqueParcial IN h-bocx220f (INPUT TABLE tt-embarque-novo,
												INPUT TABLE tt-ordens-nac-bo,
												OUTPUT r-embarque-imp,
												OUTPUT TABLE rowErrors).
    

    if return-value = "NOK":U then do:
        IF CAN-FIND(FIRST rowErrors) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="yes"}
            RETURN "NOK":U.
        end.
    end.
    else do:
        /**************VisÆo DI - Vincula novo embarque a DI********************************/
        IF (tb-integr-visao-di:CHECKED IN FRAME fPage0) THEN DO:
    
            IF NOT l-possui-nota THEN DO: /*Se embarque nÆo possuir Nota de Simples Remessa MÆe no Recebimento*/
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-embarque-vinculado-a-di AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Embarque_vinculado_a_DI" *}
                ASSIGN c-lbl-liter-embarque-vinculado-a-di = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-embarque AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Embarque" *}
                ASSIGN c-lbl-liter-embarque = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-esta-vinculado-a-di AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "est _vinculado_a_DI" *}
                ASSIGN c-lbl-liter-esta-vinculado-a-di = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-deseja-vincular-o-novo-embarqu AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "deseja_vincular_o_novo_embarque?" *}
                ASSIGN c-lbl-liter-deseja-vincular-o-novo-embarqu = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-as-adicoes-e-itens-da-di-serao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "As_Adi‡äes_e_Itens_da_DI_serÆo_regerados,_a_fun‡Æo_de_rateio_deve_ser_executada_novamente" *}
                ASSIGN c-lbl-liter-as-adicoes-e-itens-da-di-serao = TRIM(RETURN-VALUE).
                
                IF  d-cdd-siscomex-dts <> 0 THEN DO:
                    {utp/ut-liter.i "Embarque_vinculado_a_DUIMP" *}
                    ASSIGN c-lbl-liter-embarque-vinculado-a-di = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i "est _vinculado_a_DUIMP" *}
                    ASSIGN c-lbl-liter-esta-vinculado-a-di = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i "Os_Itens_da_DUIMP_serÆo_regerados,_a_fun‡Æo_de_rateio_deve_ser_executada_novamente" *}
                    ASSIGN c-lbl-liter-as-adicoes-e-itens-da-di-serao = TRIM(RETURN-VALUE).
                END.                    
                
                RUN utp/ut-msgs.p (INPUT 'show',
                                   INPUT 27100,
                                   INPUT c-lbl-liter-embarque-vinculado-a-di + ' ' + fi-num-di-ems:SCREEN-VALUE IN FRAME fPage0 + '!' + '~~' 
                                       + c-lbl-liter-embarque + ' '+ tt-embarque-imp.embarque + ' ' + c-lbl-liter-esta-vinculado-a-di + ' ' + fi-num-di-ems:SCREEN-VALUE IN FRAME fPage0 
                                       + ', ' + c-lbl-liter-deseja-vincular-o-novo-embarqu + ' ' + CHR(10) 
                                       + c-lbl-liter-as-adicoes-e-itens-da-di-serao + '!').
                IF RETURN-VALUE = "yes":U THEN
                    ASSIGN l-relaciona-di = YES.
            END.
            ELSE
                ASSIGN l-relaciona-di = YES.

            RUN emptyRowErrors                 IN h-bocx383.
            RUN pi-seta-desemb-parc            IN h-bocx383 (INPUT YES).
            run pi-seta-l-im0099               IN h-bocx383 (INPUT YES).
            RUN pi-seta-tp-nacionaliz          IN h-bocx383 (INPUT IF d-cdd-siscomex-dts = 0 THEN 2 ELSE 3). /* 2-DI/3-DUIMP */
            RUN pi-vincula-embarque-desem-parc IN h-bocx383(input int(fi-num-di-ems:SCREEN-VALUE IN FRAME fPage0),
                                                            INPUT d-cdd-siscomex-dts,
                                                            input r-embarque-imp,
                                                            INPUT l-relaciona-di).
            RUN getRowErrors                   IN h-bocx383(OUTPUT TABLE RowErrors APPEND).
        END.
        /*********************FIM - VisÆo DI*************************************************/

        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType    <> "INTERNAL":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}    
        END.
        
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Novo_Embarque_criado_com_sucesso" *}
        run utp/ut-msgs.p (input "show":U,
                   input 15825,
                   input RETURN-VALUE + "!").
        &IF DEFINED(bf-mat-comex) &THEN
        &else
            RUN LOAD-tt-embarque-contab IN h-bocx220f(OUTPUT TABLE tt-embarque-contab).
    
            FIND FIRST tt-embarque-contab NO-LOCK NO-ERROR.
    
            IF AVAIL tt-embarque-contab THEN DO:
                run utp/ut-msgs.p (input "show":U,
                           input 29643,
                           input tt-embarque-contab.embarque + "~~" +
                                 string(tt-embarque-contab.ep-codigo) + "~~" +   
                                 tt-embarque-contab.cod-estabel + "~~" + 
                                 string(tt-embarque-contab.cod-esp) + "~~" +  
                                 tt-embarque-contab.serie + "~~" +      
                                 string(tt-embarque-contab.nr-docto) + "~~" + 
                                 string(tt-embarque-contab.cod-fornec)).
    
            END.
        &ENDIF
        
        ASSIGN glSuppressAfterDisplay = TRUE.

		RUN openQuery        IN {&hDBOParent} (INPUT 1) NO-ERROR.
		RUN repositionRecord IN THIS-PROCEDURE (INPUT r-embarque-imp-orig) NO-ERROR.

		/* Reabilita afterDisplayFields e força recarga dos filhos 1x */
		ASSIGN glSuppressAfterDisplay = FALSE
			   glForceOpenQueriesSon = TRUE.

		run openQueriesSon in this-procedure.

		ASSIGN glForceOpenQueriesSon = FALSE.
       
        
        assign c-embarque-novo = ""
               da-nova-entrega = ?
               c-fatura        = "".
               
        disp c-embarque-novo
             da-nova-entrega
             c-fatura with frame fPage0.
             
        apply "entry":U to c-embarque-novo in frame fPage0.             
        
        
    end.
    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


PROCEDURE piPreencheCamposBrowse :
    DEFINE VARIABLE cDit     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cPedido  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cUnItem  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cUnFor   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dQtd     AS DECIMAL   NO-UNDO.

    FOR EACH tt-ordens-nac EXCLUSIVE-LOCK:

        /* -----------------------------
           Unidade do Item (cache)
           ----------------------------- */
        IF tt-ordens-nac.c-it-codigo <> "" THEN DO:
            FIND FIRST tt-cache-un-item
                 WHERE tt-cache-un-item.it-codigo = tt-ordens-nac.c-it-codigo
                 NO-ERROR.

            IF NOT AVAILABLE tt-cache-un-item THEN DO:
                ASSIGN cUnItem = "".

                RUN findCodigo IN h-boin172 (INPUT tt-ordens-nac.c-it-codigo, OUTPUT c-return).
                IF c-return = "" THEN
                    RUN getCharField IN h-boin172 (INPUT "un":U, OUTPUT cUnItem).

                CREATE tt-cache-un-item.
                ASSIGN tt-cache-un-item.it-codigo = tt-ordens-nac.c-it-codigo
                       tt-cache-un-item.un       = cUnItem.
            END.

            ASSIGN tt-ordens-nac.c-un-nosso = tt-cache-un-item.un
                   tt-ordens-nac.c-un-nac   = tt-cache-un-item.un.
        END.

        /* -----------------------------
           Unidade do Fornecedor (cache)
           ----------------------------- */
        FIND FIRST tt-cache-un-fornec
             WHERE tt-cache-un-fornec.numero-ordem = tt-ordens-nac.numero-ordem
             NO-ERROR.

        IF NOT AVAILABLE tt-cache-un-fornec THEN DO:
            ASSIGN cUnFor = "".

            RUN findCotacaoAprovada IN h-boin082 (INPUT tt-ordens-nac.numero-ordem, OUTPUT c-return).
            IF c-return = "" THEN
                RUN getCharField IN h-boin082 (INPUT "un":U, OUTPUT cUnFor).

            CREATE tt-cache-un-fornec.
            ASSIGN tt-cache-un-fornec.numero-ordem = tt-ordens-nac.numero-ordem
                   tt-cache-un-fornec.un          = cUnFor.
        END.

        ASSIGN tt-ordens-nac.c-un-fornec = tt-cache-un-fornec.un.

        /* -----------------------------
           Saldo DIT (cache em 2 níveis)
           ----------------------------- */
        ASSIGN tt-ordens-nac.d-qtd-sd-item = 0.

        ASSIGN cDit = TRIM(SUBSTRING(tt-ordens-nac.char-1, 1, 20)).
        IF cDit <> "" THEN DO:

            /* (estabel+DIT) -> nr-pedido-drb */
            FIND FIRST tt-cache-pedido-drb
                 WHERE tt-cache-pedido-drb.cod-estabel = tt-ordens-nac.cod-estabel
                   AND tt-cache-pedido-drb.dit        = cDit
                 NO-ERROR.

            IF NOT AVAILABLE tt-cache-pedido-drb THEN DO:
                ASSIGN cPedido = "".

                RUN goToKey IN h-bocx312 (INPUT tt-ordens-nac.cod-estabel,
                                         INPUT "",
                                         INPUT cDit).

                IF RETURN-VALUE = "OK":U THEN
                    RUN getCharField IN h-bocx312 (INPUT "nr-pedido-drb", OUTPUT cPedido).

                CREATE tt-cache-pedido-drb.
                ASSIGN tt-cache-pedido-drb.cod-estabel   = tt-ordens-nac.cod-estabel
                       tt-cache-pedido-drb.dit          = cDit
                       tt-cache-pedido-drb.nr-pedido-drb = cPedido.
            END.

            ASSIGN cPedido = tt-cache-pedido-drb.nr-pedido-drb.

            IF cPedido <> "" THEN DO:
                /* (estabel+pedido+item) -> qtd-sdo */
                FIND FIRST tt-cache-qtd-sdo
                     WHERE tt-cache-qtd-sdo.cod-estabel   = tt-ordens-nac.cod-estabel
                       AND tt-cache-qtd-sdo.nr-pedido-drb = cPedido
                       AND tt-cache-qtd-sdo.it-codigo     = tt-ordens-nac.c-it-codigo
                     NO-ERROR.

                IF NOT AVAILABLE tt-cache-qtd-sdo THEN DO:
                    ASSIGN dQtd = 0.

                    RUN goToKey IN h-bocx315 (INPUT tt-ordens-nac.cod-estabel,
                                             INPUT cPedido,
                                             INPUT tt-ordens-nac.c-it-codigo).

                    RUN getDecField IN h-bocx315 (INPUT "qtd-sdo-item":U, OUTPUT dQtd).

                    CREATE tt-cache-qtd-sdo.
                    ASSIGN tt-cache-qtd-sdo.cod-estabel   = tt-ordens-nac.cod-estabel
                           tt-cache-qtd-sdo.nr-pedido-drb = cPedido
                           tt-cache-qtd-sdo.it-codigo     = tt-ordens-nac.c-it-codigo
                           tt-cache-qtd-sdo.qtd-sdo-item  = dQtd.
                END.

                ASSIGN tt-ordens-nac.d-qtd-sd-item = tt-cache-qtd-sdo.qtd-sdo-item.
            END.
        END.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-item wMasterDetail 
FUNCTION fn-item RETURNS CHARACTER
  ( input p-numero-ordem as integer ) :
  
/*     run findOrdem in h-boin274 (input p-numero-ordem,output c-return).          */
/*     if c-return = "" then                                                       */
/*         run getCharfield in h-boin274 (input "it-codigo":U,output c-it-codigo). */
/*     else                                                                        */
/*         assign c-it-codigo = "".                                                */
        
    return c-it-codigo.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnParentKey wMasterDetail 
FUNCTION fnParentKey RETURNS CHARACTER ( ) :
    IF AVAILABLE tt-embarque-imp THEN
        RETURN TRIM(tt-embarque-imp.cod-estabel) + "|"
             + TRIM(tt-embarque-imp.embarque).

    RETURN "":U.
END FUNCTION.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnQtdSdItem wMasterDetail 
FUNCTION fnQtdSdItem RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RUN goToKey IN h-bocx312 (INPUT tt-ordens-nac.cod-estabel,
                              INPUT "",
                              INPUT (trim(SUBSTRING(tt-ordens-nac.char-1,1,20)))).

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getCharField IN h-bocx312 (INPUT "nr-pedido-drb",
                                       OUTPUT c-pedido-drb).

        RUN goToKey IN h-bocx315 (INPUT tt-ordens-nac.cod-estabel,
                                  INPUT c-pedido-drb,
                                  INPUT tt-ordens-nac.c-it-codigo).

        ASSIGN d-return = 0.
        run getDecField in h-bocx315 (input "qtd-sdo-item":U, 
                                      output d-return).
    END.
    ELSE
        ASSIGN d-return = 0.

    return d-return.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnFornec wMasterDetail 
FUNCTION fnUnFornec RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/


  run findCotacaoAprovada in h-boin082 (input tt-ordens-nac.numero-ordem,
                                        output c-return).
  if c-return = "" then do:
    run getCharfield in h-boin082(input "un":U,output c-return).
    return c-return.
  end.

  
  return "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnItem wMasterDetail 
FUNCTION fnUnItem RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  run findCodigo in h-boin172 (input tt-ordens-nac.c-it-codigo, output c-return).

  if c-return = "" then do:
      run getCharField in h-boin172 (input "un":U, output c-return).
      return c-return.
  end.

  return "".   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

