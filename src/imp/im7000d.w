&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-duimp-item NO-UNDO LIKE duimp-item
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-duimp-siscomex NO-UNDO LIKE duimp-siscomex
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM7000D 2.00.00.003} /* 14/11/2025 16:15:34 */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM7000D MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM7000D
&GLOBAL-DEFINE Version          2.00.00.003

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Embarques

&GLOBAL-DEFINE ttParent         tt-duimp-siscomex
&GLOBAL-DEFINE hDBOParent       h-bocx00487
&GLOBAL-DEFINE DBOParentTable   duimp-siscomex

&GLOBAL-DEFINE ttSon2           tt-duimp-item
&GLOBAL-DEFINE hDBOSon2         h-bocx00488
&GLOBAL-DEFINE DBOSon2Table     duimp-item

&GLOBAL-DEFINE page0Fields      

&GLOBAL-DEFINE page1Browse      
&GLOBAL-DEFINE page2Browse      

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAM pcod-duimp-dts         LIKE duimp-siscomex.cod-duimp-dts NO-UNDO.
DEFINE INPUT PARAM pcod-duimp-siscomex    LIKE duimp-siscomex.cod-duimp-siscomex NO-UNDO.
DEFINE INPUT PARAM phCaller               as handle NO-UNDO.


/* Local Variable Definitions ---                                       */
DEFINE variable c-cod-estabel-ini         LIKE duimp-item.cod-estabel NO-UNDO.
DEFINE variable c-cod-estabel-fim         LIKE duimp-item.cod-estabel NO-UNDO.
DEFINE variable i-cod-emitente-ini        LIKE duimp-item.cod-emitente NO-UNDO.
DEFINE variable i-cod-emitente-fim        LIKE duimp-item.cod-emitente NO-UNDO.
DEFINE variable c-nome-abrev-ini          LIKE emitente.nome-abrev NO-UNDO.
DEFINE variable c-nome-abrev-fim          LIKE emitente.nome-abrev NO-UNDO.
DEFINE variable c-embarque-ini            LIKE duimp-item.embarque NO-UNDO.
DEFINE variable c-embarque-fim            LIKE duimp-item.embarque NO-UNDO.
DEFINE VARIABLE l-inicializacao           AS logical NO-UNDO.
DEFINE VARIABLE l-ok                      as logical no-undo.
DEFINE VARIABLE c-return                  as char no-undo.
DEFINE VARIABLE c-unid-med                LIKE ITEM.un NO-UNDO.
DEFINE VARIABLE c-class-fisc              LIKE ITEM.class-fiscal NO-UNDO.
DEFINE VARIABLE c-desc-item               LIKE ITEM.descricao-1 NO-UNDO.
DEFINE VARIABLE c-nome-abrev              LIKE emitente.nome-abre NO-UNDO.
DEFINE VARIABLE c-lb-acomp                AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-embarque             AS CHAR NO-UNDO.
DEFINE VARIABLE l-filtro-a-vinc           AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-filtro-vincul           AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-nao-vinc                AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-desvincula              AS LOGICAL NO-UNDO.

DEFINE VARIABLE i-cod-cond-pag            like cond-pagto.cod-cond-pag no-undo.
DEFINE VARIABLE c-cond-pagto1             like cond-pagto.descricao no-undo.
DEFINE VARIABLE i-cod-cond-pag1           like cond-pagto.cod-cond-pag no-undo.
DEFINE VARIABLE c-cond-pagto              like cond-pagto.descricao no-undo.
DEFINE VARIABLE c-return-ordem-compr      AS CHAR NO-UNDO.
DEFINE VARIABLE c-return-item             AS CHAR NO-UNDO.
DEFINE VARIABLE c-texto                   AS CHAR NO-UNDO.
DEFINE VARIABLE c-texto2                  AS CHAR NO-UNDO.

DEFINE VARIABLE r-chave                   as ROWID no-undo.
DEFINE VARIABLE c-char-1                  as CHAR no-undo.
DEFINE VARIABLE c-it-codigo               like item.it-codigo no-undo.
DEFINE VARIABLE c-it-codigo1              like item.it-codigo no-undo.
DEFINE VARIABLE i-num-pedido              like pedido-compr.num-pedido no-undo.
DEFINE VARIABLE i-num-pedido1             like pedido-compr.num-pedido no-undo.
DEFINE VARIABLE i-mo-codigo               like cotacao-item.mo-codigo no-undo.
DEFINE VARIABLE i-mo-codigo1              like cotacao-item.mo-codigo no-undo.
DEFINE VARIABLE de-preco-unit             like cotacao-item.preco-unit no-undo.
DEFINE VARIABLE c-un-nosso                like item.un no-undo.
DEFINE VARIABLE c-un-fornec               like cotacao-item.un no-undo.
DEFINE VARIABLE de-pre-unit-for           like cotacao-item.pre-unit-for no-undo.
DEFINE VARIABLE de-aliquota-ipi           like cotacao-item.aliquota-ipi no-undo.
DEFINE VARIABLE c-desc-moeda              AS CHAR NO-UNDO.
DEFINE VARIABLE d-quantidade              LIKE ordens-embarque.quantidade NO-UNDO.
DEFINE VARIABLE d-qt-do-forn              LIKE ordens-embarque.qt-do-forn NO-UNDO.

{cdp/cd4300.i3}
{ccp/cc9019.i50}

define temp-table tt-embarque-imp no-undo
    field cod-estabel  like duimp-item.cod-estabel
    field numero-ordem like duimp-item.numero-ordem
    field cod-emitente like duimp-item.cod-emitente
    field embarque     like duimp-item.embarque
    index ttid cod-estabel embarque numero-ordem cod-emitente.

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.    
    
//{cxbo/bocx00488.i1} /* tt-param-ordens e tt-ordens-embarque */    
DEFINE TEMP-TABLE tt-param-ordens NO-UNDO
    FIELD cod-estabel-ini        LIKE duimp-item.cod-estabel
    FIELD cod-estabel-fim        LIKE duimp-item.cod-estabel
    FIELD cod-emitente-ini       LIKE duimp-item.cod-emitente
    FIELD cod-emitente-fim       LIKE duimp-item.cod-emitente
    FIELD nome-abrev-ini         LIKE emitente.nome-abrev
    FIELD nome-abrev-fim         LIKE emitente.nome-abrev
    FIELD embarque-ini           LIKE duimp-item.embarque
    FIELD embarque-fim           LIKE duimp-item.embarque.

/*TT com as ordens a serem vinculadas a DUIMP*/
DEFINE TEMP-TABLE tt-ordens-embarque NO-UNDO
    FIELD embarque          LIKE ordens-embarque.embarque
    FIELD cod-estabel       LIKE ordens-embarque.cod-estabel
    FIELD numero-ordem      LIKE ordens-embarque.numero-ordem
    FIELD cod-item          LIKE ordem-compra.it-codigo
    FIELD cod-emitente      LIKE ordem-compra.cod-emitente
    FIELD nr-proc-imp       like ordens-embarque.nr-proc-imp.

DEFINE BUFFER btt-ordens-embarque FOR tt-ordens-embarque.
DEFINE BUFFER btt-ordens-embarque2 FOR tt-ordens-embarque.
DEFINE BUFFER btt-duimp-item FOR tt-duimp-item.
DEFINE BUFFER btt-duimp-item2 FOR tt-duimp-item.

DEFINE BUFFER bf-ordens-embarque FOR ordens-embarque.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin172     AS HANDLE NO-UNDO.        
DEFINE VARIABLE h-boad098     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx140     as handle no-undo.
DEFINE VARIABLE h-boin274     as handle no-undo.
DEFINE VARIABLE h-boin082     as handle no-undo.
DEFINE VARIABLE h-boun005     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad039     AS handle no-undo.
DEFINE VARIABLE h-bocx110     as handle no-undo.
DEFINE VARIABLE h-bocx220na   as handle no-undo.

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
&Scoped-define INTERNAL-TABLES tt-ordens-embarque tt-duimp-item

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-ordens-embarque.cod-estabel tt-ordens-embarque.embarque tt-ordens-embarque.cod-emitente fnNomeAbrev (tt-ordens-embarque.cod-emitente) @ c-nome-abrev tt-ordens-embarque.numero-ordem tt-ordens-embarque.nr-proc-imp fnPedido() @ i-num-pedido tt-ordens-embarque.cod-item fnDescItem (tt-ordens-embarque.cod-item) @ c-desc-item fnQuantidade(1) @ d-quantidade fnUnItem () @ c-un-nosso fnQuantidade(2) @ d-qt-do-forn fnUnFornec () @ c-un-fornec fnClasFiscItem (tt-ordens-embarque.cod-item) @ c-class-fisc fn-moeda() @ i-mo-codigo fn-descmoeda() @ c-desc-moeda fn-cond-pagto() @ i-cod-cond-pag fn-desc-cond-pagto(fn-cond-pagto()) @ c-cond-pagto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-ordens-embarque
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-embarque.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-ordens-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-ordens-embarque


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-duimp-item.cod-estabel tt-duimp-item.embarque tt-duimp-item.cod-emitente fnNomeAbrev (tt-duimp-item.cod-emitente) @ c-nome-abrev tt-duimp-item.numero-ordem tt-duimp-item.cod-item fnDescItem (tt-duimp-item.cod-item) @ c-desc-item fnUnidMedItem (tt-duimp-item.cod-item) @ c-unid-med fnClasFiscItem (tt-duimp-item.cod-item) @ c-class-fisc tt-duimp-item.serie-docto tt-duimp-item.nro-docto tt-duimp-item.nat-operacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2   
&Scoped-define SELF-NAME brSon2
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-duimp-item by tt-duimp-item.cod-estabel by tt-duimp-item.embarque by tt-duimp-item.numero-ordem
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY {&SELF-NAME} FOR EACH tt-duimp-item by tt-duimp-item.cod-estabel by tt-duimp-item.embarque by tt-duimp-item.numero-ordem.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-duimp-item
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-duimp-item


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-duimp-siscomex.cod-duimp-dts ~
tt-duimp-siscomex.cod-duimp-siscomex 
&Scoped-define ENABLED-TABLES tt-duimp-siscomex
&Scoped-define FIRST-ENABLED-TABLE tt-duimp-siscomex
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btQueryJoins ~
btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-duimp-siscomex.cod-duimp-dts ~
tt-duimp-siscomex.cod-duimp-siscomex 
&Scoped-define DISPLAYED-TABLES tt-duimp-siscomex
&Scoped-define FIRST-DISPLAYED-TABLE tt-duimp-siscomex


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-cond-pagto wMasterDetail 
FUNCTION fn-cond-pagto RETURNS INTEGER
    ( ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-cond-pagto wMasterDetail 
FUNCTION fn-desc-cond-pagto RETURNS CHARACTER
  ( input p-cod-cond-pag as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-descmoeda wMasterDetail 
FUNCTION fn-descmoeda RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-moeda wMasterDetail 
FUNCTION fn-moeda RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnClasFiscItem wMasterDetail 
FUNCTION fnClasFiscItem RETURNS CHARACTER
  ( input c-it-codigo as character)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wMasterDetail 
FUNCTION fnDescItem RETURNS CHARACTER
  ( input c-it-codigo as character)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
    ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeAbrev wMasterDetail 
FUNCTION fnNomeAbrev RETURNS CHARACTER
  ( input i-cod-emitente as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPedido wMasterDetail 
FUNCTION fnPedido RETURNS integer
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnQuantidade wMasterDetail 
FUNCTION fnQuantidade RETURNS DECIMAL
  ( INPUT p-tipo as INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnFornec wMasterDetail 
FUNCTION fnUnFornec RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnidMedItem wMasterDetail 
FUNCTION fnUnidMedItem RETURNS CHARACTER
  ( input c-it-codigo as character)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnItem wMasterDetail 
FUNCTION fnUnItem RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
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

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btDesvincula 
     IMAGE-UP FILE "image/im-acm1.bmp":U
     LABEL "":L 
     SIZE 4 BY 1.25 TOOLTIP "Desvincula Embarque".

DEFINE BUTTON btDesvinculaTodos 
     IMAGE-UP FILE "image/im-remall.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Desvincula Todos".

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image/im-fil.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro Embarques a Vincular".

DEFINE BUTTON btFiltro2 
     IMAGE-UP FILE "image/im-fil.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro Embarques Vinculados".

DEFINE BUTTON btVincula 
     IMAGE-UP FILE "image/im-down2.bmp":U
     LABEL "":L 
     SIZE 4 BY 1.25 TOOLTIP "Vincula Embarque".

DEFINE BUTTON btVinculaTodos 
     IMAGE-UP FILE "image/im-addall.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Vincula Todos".

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-ordens-embarque SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-duimp-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 DISPLAY
      tt-ordens-embarque.cod-estabel column-label "Estab" format "x(5)":U width 7
     tt-ordens-embarque.embarque column-label "Embarque" format "X(16)":U width 16     
     tt-ordens-embarque.cod-emitente column-label "Emitente" format ">>>>>>>>9":U width 9
     fnNomeAbrev (tt-ordens-embarque.cod-emitente) @ c-nome-abrev COLUMN-LABEL "Nome Abreviado" FORMAT "x(12)":U width 14     
     tt-ordens-embarque.numero-ordem FORMAT ">>>>>9,99":U WIDTH 8.72
     tt-ordens-embarque.nr-proc-imp FORMAT "X(12)":U
     fnPedido() @ i-num-pedido COLUMN-LABEL "Pedido"
     tt-ordens-embarque.cod-item column-label "Item" format "x(16)":U width 18
     fnDescItem (tt-ordens-embarque.cod-item) @ c-desc-item column-label "Descri‡Æo" format "x(18)":U width 20          
     fnQuantidade(1) @ d-quantidade COLUMN-LABEL "Nossa Qtde" FORMAT ">>>>>,>>9.9999":U
     fnUnItem () @ c-un-nosso WIDTH 8.57
     fnQuantidade(2) @ d-qt-do-forn COLUMN-LABEL "Qtde" FORMAT ">>>>>,>>9.9999":U    
     fnUnFornec () @ c-un-fornec COLUMN-LABEL "Un Fornec" WIDTH 8.57
     fnClasFiscItem (tt-ordens-embarque.cod-item) @ c-class-fisc column-label "Class Fiscal" format "9999.99.99":U width 12          
     fn-moeda() @ i-mo-codigo
     fn-descmoeda() @ c-desc-moeda COLUMN-LABEL "Descri‡Æo" FORMAT "x(12)":U
     fn-cond-pagto() @ i-cod-cond-pag COLUMN-LABEL "Cond Pagto"
     fn-desc-cond-pagto(fn-cond-pagto()) @ c-cond-pagto
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 6.29
         FONT 2 ROW-HEIGHT-CHARS .5.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _FREEFORM
  QUERY brSon2 DISPLAY
      tt-duimp-item.cod-estabel column-label "Estab" format "x(5)":U width 7
     tt-duimp-item.embarque column-label "Embarque" format "X(16)":U width 16
     tt-duimp-item.cod-emitente column-label "Emitente" format ">>>>>>>>9":U width 9
     fnNomeAbrev (tt-duimp-item.cod-emitente) @ c-nome-abrev COLUMN-LABEL "Nome Abreviado" FORMAT "x(12)":U width 14
     tt-duimp-item.numero-ordem column-label "Ordem" format "zzzzz9,99":U width 10
     tt-duimp-item.cod-item column-label "Item" format "x(16)":U width 18
     fnDescItem (tt-duimp-item.cod-item) @ c-desc-item column-label "Descri‡Æo" format "x(18)":U width 20     
     fnUnidMedItem (tt-duimp-item.cod-item) @ c-unid-med column-label "Un" format "x(02)":U  width 4
     fnClasFiscItem (tt-duimp-item.cod-item) @ c-class-fisc column-label "Class Fiscal" format "9999.99.99":U width 12
     tt-duimp-item.serie-docto column-label "S‚rie" format "x(5)":U width 7
     tt-duimp-item.nro-docto column-label "Documento" format "x(16)":U width 18
     tt-duimp-item.nat-operacao column-label "Nat Opera‡Æo" format "x(06)":U width 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 6.29
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-duimp-siscomex.cod-duimp-dts AT ROW 3.25 COL 25.14 COLON-ALIGNED WIDGET-ID 2
          LABEL "N£mero Interno DUIMP"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-duimp-siscomex.cod-duimp-siscomex AT ROW 3.25 COL 57.14 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 20.67
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.42 COL 2.57 WIDGET-ID 200
     btVincula AT ROW 1.75 COL 81.14 HELP
          "Vincula" WIDGET-ID 10
     btVinculaTodos AT ROW 3.25 COL 81.14 HELP
          "Vincula Todas" WIDGET-ID 12
     btFiltro AT ROW 4.75 COL 81.14 HELP
          "Filtro Notas Fiscais a Vincular" WIDGET-ID 6
     brSon2 AT ROW 8.92 COL 2.57 WIDGET-ID 300
     btDesvincula AT ROW 9.38 COL 81.14 HELP
          "Desvincula Nota Fiscal" WIDGET-ID 14
     btDesvinculaTodos AT ROW 10.88 COL 81.14 HELP
          "Desvincula Todas" WIDGET-ID 4
     btFiltro2 AT ROW 12.38 COL 81.14 HELP
          "Filtro Notas Fiscais Vinculadas" WIDGET-ID 8
     "Embarques Vinculados" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 8.25 COL 3 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 84.43 BY 14.63
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-duimp-item T "?" NO-UNDO mgcex duimp-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-duimp-siscomex T "?" NO-UNDO mgcex duimp-siscomex
      ADDITIONAL-FIELDS:
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
         HEIGHT             = 20.67
         WIDTH              = 90
         MAX-HEIGHT         = 20.67
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 20.67
         VIRTUAL-WIDTH      = 90
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

{masterdetail/masterdetail.i}

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
/* SETTINGS FOR FILL-IN tt-duimp-siscomex.cod-duimp-dts IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 TEXT-1 fPage1 */
/* BROWSE-TAB brSon2 btFiltro fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens-embarque.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-duimp-item by tt-duimp-item.cod-estabel by tt-duimp-item.embarque by tt-duimp-item.numero-ordem
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brSon2 */
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
&Scoped-define SELF-NAME btDesvincula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesvincula wMasterDetail
ON CHOOSE OF btDesvincula IN FRAME fPage1
DO:
    EMPTY TEMP-TABLE rowErrors.

    {utp/ut-liter.i desvincula‡Æo * }
    ASSIGN c-texto = RETURN-VALUE.
    {utp/ut-liter.i da_DUIMP * }
    ASSIGN c-texto2 = RETURN-VALUE.    
    {utp/ut-liter.i desvinculadas_da_DUIMP * }    
    run utp/ut-msgs.p (input "show":U, 
                       input 57934, 
                       input c-texto + "~~" + c-texto2 + "~~" + RETURN-VALUE).

    IF  RETURN-VALUE = "YES":U   
    AND AVAIL tt-duimp-item THEN DO:      
   
        IF NOT VALID-HANDLE(h-acomp) THEN DO:
            RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        END.

        {utp/ut-liter.i Embarques * }
        RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
        {utp/ut-liter.i Desvinculando_Embarques * }
        RUN pi-acompanhar  in h-acomp (INPUT TRIM(RETURN-VALUE)).

        {utp/ut-liter.i Estab * }
        ASSIGN c-lb-embarque = TRIM(RETURN-VALUE).
        {utp/ut-liter.i Embarque * }
        ASSIGN c-lb-embarque = c-lb-embarque + "/":U + TRIM(RETURN-VALUE).
        {utp/ut-liter.i Ordem * }
        ASSIGN c-lb-embarque = c-lb-embarque + "/":U + TRIM(RETURN-VALUE).         
        
        FOR EACH btt-duimp-item2
            WHERE btt-duimp-item2.cod-estabel = tt-duimp-item.cod-estabel
            AND   btt-duimp-item2.embarque    = tt-duimp-item.embarque:
            RUN pi-acompanhar IN h-acomp (INPUT c-lb-embarque + ": ":U + btt-duimp-item2.cod-estabel + "/":U + btt-duimp-item2.embarque  + "/":U + string(btt-duimp-item2.numero-ordem,"zzzzz9,99":U)).
        
            RUN piDesvinculaEmbarque IN THIS-PROCEDURE (INPUT btt-duimp-item2.r-rowid,
                                                        INPUT tt-duimp-item.cod-estabel,
                                                        INPUT tt-duimp-item.embarque).
        END.
        
        RUN pi-finalizar IN h-acomp.
        
        {utp/ut-liter.i Atualizando_Embarques_na_DUIMP *}
        ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
        ASSIGN l-filtro-a-vinc = NO
               l-filtro-vincul = NO.
        RUN openQueriesSon IN THIS-PROCEDURE.
    END.
    
    IF CAN-FIND(FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesvinculaTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesvinculaTodos wMasterDetail
ON CHOOSE OF btDesvinculaTodos IN FRAME fPage1
DO:
    EMPTY TEMP-TABLE rowErrors.

    {utp/ut-liter.i desvincula‡Æo * }
    ASSIGN c-texto = RETURN-VALUE.
    {utp/ut-liter.i da_DUIMP * }
    ASSIGN c-texto2 = RETURN-VALUE.    
    {utp/ut-liter.i desvinculadas_da_DUIMP * }    
    run utp/ut-msgs.p (input "show":U, 
                       input 57934, 
                       input c-texto + "~~" + c-texto2 + "~~" + RETURN-VALUE).

    IF  RETURN-VALUE = "YES":U THEN DO:    
        IF NOT VALID-HANDLE(h-acomp) THEN DO:
            RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        END.

        {utp/ut-liter.i Embarques * }
        RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
        {utp/ut-liter.i Desvinculando_Embarques * }
        RUN pi-acompanhar  in h-acomp (INPUT TRIM(RETURN-VALUE)).

        {utp/ut-liter.i Estab * }
        ASSIGN c-lb-embarque = TRIM(RETURN-VALUE).
        {utp/ut-liter.i Embarque * }
        ASSIGN c-lb-embarque = c-lb-embarque + "/":U + TRIM(RETURN-VALUE).
        {utp/ut-liter.i Ordem * }
        ASSIGN c-lb-embarque = c-lb-embarque + "/":U + TRIM(RETURN-VALUE). 

        FOR EACH tt-duimp-item NO-LOCK:
            RUN pi-acompanhar IN h-acomp (INPUT c-lb-embarque + ": ":U + tt-duimp-item.cod-estabel + "/":U + tt-duimp-item.embarque  + "/":U + string(tt-duimp-item.numero-ordem,"zzzzz9,99":U)).        
            RUN piDesvinculaEmbarque IN THIS-PROCEDURE (INPUT tt-duimp-item.r-rowid,
                                                        INPUT tt-duimp-item.cod-estabel,
                                                        INPUT tt-duimp-item.embarque).
        END.
        
        RUN pi-finalizar IN h-acomp.
            
        {utp/ut-liter.i Atualizando_Embarques_na_DUIMP *}
        ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
        ASSIGN l-filtro-a-vinc = NO
               l-filtro-vincul = NO.
        RUN openQueriesSon IN THIS-PROCEDURE.
    END.
    
    IF  CAN-FIND(FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2}
    END.    
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wMasterDetail
ON CHOOSE OF btFiltro IN FRAME fPage1
DO:
  /*--- Seta cursor do mouse para espera ---*/
  SESSION:SET-WAIT-STATE("GENERAL":U).
  ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

  RUN imp/im7000d1.w (INPUT-OUTPUT c-cod-estabel-ini,
                      INPUT-OUTPUT c-cod-estabel-fim,
                      INPUT-OUTPUT c-embarque-ini,
                      INPUT-OUTPUT c-embarque-fim,
                      INPUT-OUTPUT i-cod-emitente-ini,
                      INPUT-OUTPUT i-cod-emitente-fim,
                      INPUT-OUTPUT c-nome-abrev-ini,
                      INPUT-OUTPUT c-nome-abrev-fim,
                      OUTPUT l-ok).

  /*Variavel para controlar se filtro est  sendo executado na inicializa‡Æo do programa ou nÆo*/
  IF  l-ok THEN DO:
      {utp/ut-liter.i "Buscando_Embarques_a_Vincular"}
      ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
      
      RUN pi-carrega-embarques-a-vincular IN THIS-PROCEDURE.
  END.

  /*--- Seta cursor do mouse para normal ---*/
  SESSION:SET-WAIT-STATE("":U). 
  ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

  ASSIGN l-filtro-a-vinc = YES.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro2 wMasterDetail
ON CHOOSE OF btFiltro2 IN FRAME fPage1
DO:
  /*--- Seta cursor do mouse para espera ---*/
  SESSION:SET-WAIT-STATE("GENERAL":U).
  ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

  RUN imp/im7000d1.w (INPUT-OUTPUT c-cod-estabel-ini,
                      INPUT-OUTPUT c-cod-estabel-fim,
                      INPUT-OUTPUT c-embarque-ini,
                      INPUT-OUTPUT c-embarque-fim,
                      INPUT-OUTPUT i-cod-emitente-ini,
                      INPUT-OUTPUT i-cod-emitente-fim,
                      INPUT-OUTPUT c-nome-abrev-ini,
                      INPUT-OUTPUT c-nome-abrev-fim,
                      OUTPUT l-ok).

  /*Variavel para controlar se filtro foi executado*/
  IF l-ok THEN DO:
      {utp/ut-liter.i "Filtrando_Embarques_Vinculados"}
      ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
      ASSIGN l-filtro-vincul = YES.
      RUN pi-carrega-embarques-vinculados IN THIS-PROCEDURE.
  END.
      
  /*--- Seta cursor do mouse para normal ---*/
  SESSION:SET-WAIT-STATE("":U). 
  ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.  
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btVincula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVincula wMasterDetail
ON CHOOSE OF btVincula IN FRAME fPage1
DO:
    EMPTY TEMP-TABLE rowErrors.
    EMPTY TEMP-TABLE rowErrorsAux.

    {utp/ut-liter.i vincula‡Æo * }
    ASSIGN c-texto = RETURN-VALUE.
    {utp/ut-liter.i …_DUIMP * }
    ASSIGN c-texto2 = RETURN-VALUE.    
    {utp/ut-liter.i vinculadas_…_DUIMP * }    
    run utp/ut-msgs.p (input "show":U, 
                       input 57934, 
                       input c-texto + "~~" + c-texto2 + "~~" + RETURN-VALUE).
                       
    IF  RETURN-VALUE = "YES":U
    AND AVAIL tt-ordens-embarque THEN DO:
        IF NOT VALID-HANDLE(h-acomp) THEN DO:
            RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        END.

        {utp/ut-liter.i Embarques * }
        RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
        {utp/ut-liter.i Vinculando_Embarques * }
        RUN pi-acompanhar  in h-acomp (INPUT TRIM(RETURN-VALUE)).
        
        {utp/ut-liter.i Estab * }
        ASSIGN c-lb-embarque = TRIM(RETURN-VALUE).
        {utp/ut-liter.i Embarque * }
        ASSIGN c-lb-embarque = c-lb-embarque + "/":U + TRIM(RETURN-VALUE).
        {utp/ut-liter.i Ordem * }
        ASSIGN c-lb-embarque = c-lb-embarque + "/":U + TRIM(RETURN-VALUE). 
        
        RUN piSelecDespEmbarque IN {&hDBOSon2} (INPUT pcod-duimp-dts,
                                                INPUT tt-ordens-embarque.cod-estabel,
                                                INPUT tt-ordens-embarque.embarque).

        FOR EACH btt-ordens-embarque2
            WHERE btt-ordens-embarque2.cod-estabel = tt-ordens-embarque.cod-estabel
            AND   btt-ordens-embarque2.embarque    = tt-ordens-embarque.embarque:
            RUN pi-acompanhar IN h-acomp (INPUT c-lb-embarque + ": ":U + btt-ordens-embarque2.cod-estabel + "/":U + btt-ordens-embarque2.embarque  + "/":U + string(btt-ordens-embarque2.numero-ordem,"zzzzz9,99":U)).

            RUN piVinculaEmbarque IN THIS-PROCEDURE (INPUT btt-ordens-embarque2.cod-estabel,
                                                     INPUT btt-ordens-embarque2.embarque,
                                                     INPUT btt-ordens-embarque2.numero-ordem).
        END.
        
        RUN pi-finalizar IN h-acomp.
            
        IF NOT l-nao-vinc THEN DO:
            {utp/ut-liter.i Atualizando_Embarques_na_DUIMP *}
            ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
            ASSIGN l-filtro-a-vinc = NO
                   l-filtro-vincul = NO.
            RUN openQueriesSon IN THIS-PROCEDURE.
        END.
    END.
    FOR EACH rowErrorsAux:
        CREATE rowErrors.
        BUFFER-COPY rowErrorsAux TO rowErrors.
        DELETE rowErrorsAux.
    END.    
    IF CAN-FIND(FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVinculaTodos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVinculaTodos wMasterDetail
ON CHOOSE OF btVinculaTodos IN FRAME fPage1
DO:
    EMPTY TEMP-TABLE rowErrors.
    EMPTY TEMP-TABLE rowErrorsAux.

    {utp/ut-liter.i vincula‡Æo * }
    ASSIGN c-texto = RETURN-VALUE.
    {utp/ut-liter.i …_DUIMP * }
    ASSIGN c-texto2 = RETURN-VALUE.    
    {utp/ut-liter.i vinculadas_…_DUIMP * }    
    run utp/ut-msgs.p (input "show":U, 
                       input 57934, 
                       input c-texto + "~~" + c-texto2 + "~~" + RETURN-VALUE).

    IF  RETURN-VALUE = "YES":U THEN DO:
        IF  NOT VALID-HANDLE(h-acomp) THEN DO:
            RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        END.

        {utp/ut-liter.i Embarques * }
        RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
        {utp/ut-liter.i Vinculando_Embarques * }
        RUN pi-acompanhar  in h-acomp (INPUT TRIM(RETURN-VALUE)).

        {utp/ut-liter.i Estab * }
        ASSIGN c-lb-embarque = TRIM(RETURN-VALUE).
        {utp/ut-liter.i Embarque * }
        ASSIGN c-lb-embarque = c-lb-embarque + "/":U + TRIM(RETURN-VALUE).
        {utp/ut-liter.i Ordem * }
        ASSIGN c-lb-embarque = c-lb-embarque + "/":U + TRIM(RETURN-VALUE). 
        
        FOR EACH btt-ordens-embarque2
            BREAK BY btt-ordens-embarque2.cod-estabel
                  BY btt-ordens-embarque2.embarque:

            RUN pi-acompanhar IN h-acomp (INPUT c-lb-embarque + ": ":U + btt-ordens-embarque2.cod-estabel + "/":U + btt-ordens-embarque2.embarque  + "/":U + string(btt-ordens-embarque2.numero-ordem,"zzzzz9,99":U)).
            
            IF  FIRST-OF(btt-ordens-embarque2.embarque) THEN DO:
                RUN piSelecDespEmbarque IN {&hDBOSon2} (INPUT pcod-duimp-dts,
                                                        INPUT btt-ordens-embarque2.cod-estabel,
                                                        INPUT btt-ordens-embarque2.embarque).
            END.

            RUN piVinculaEmbarque IN THIS-PROCEDURE (INPUT btt-ordens-embarque2.cod-estabel,
                                                     INPUT btt-ordens-embarque2.embarque,
                                                     INPUT btt-ordens-embarque2.numero-ordem).
        END.

        RUN pi-finalizar IN h-acomp.
                
        {utp/ut-liter.i Atualizando_Embarques_na_DUIMP *}
        ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
        ASSIGN l-filtro-a-vinc = NO
               l-filtro-vincul = NO.
        RUN openQueriesSon IN THIS-PROCEDURE.
    END.
    FOR EACH rowErrorsAux:
        CREATE rowErrors.
        BUFFER-COPY rowErrorsAux TO rowErrors.
        DELETE rowErrorsAux.
    END.    
    IF CAN-FIND(FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMasterDetail
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
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
    IF VALID-HANDLE({&hDBOSon2}) THEN DO:
        DELETE PROCEDURE {&hDBOSon2}.
        ASSIGN {&hDBOSon2} = ?.
    END. 

    IF VALID-HANDLE(h-boad098) THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.    

    IF VALID-HANDLE(h-boin172) THEN DO:
        DELETE PROCEDURE h-boin172.
        ASSIGN h-boin172 = ?.
    END.

    IF  VALID-HANDLE(h-bocx140) THEN DO:
        DELETE PROCEDURE h-bocx140.
        ASSIGN h-bocx140 = ?.
    END.

    IF  VALID-HANDLE(h-boad039) THEN DO:
        DELETE PROCEDURE h-boad039.
        ASSIGN h-boad039 = ?.
    END.

    IF  VALID-HANDLE(h-bocx110) THEN DO:
        DELETE PROCEDURE h-bocx110.
        ASSIGN h-bocx110 = ?.
    END.

    IF  VALID-HANDLE(h-boin082) THEN DO:
        DELETE PROCEDURE h-boin082.
        ASSIGN h-boin082 = ?.
    END.

    IF  VALID-HANDLE(h-boin274) THEN DO:
        DELETE PROCEDURE h-boin274.
        ASSIGN h-boin274 = ?.
    END.

    IF  VALID-HANDLE(h-bocx220na) THEN DO:
        DELETE PROCEDURE h-bocx220na.
        ASSIGN h-bocx220na = ?.
    END.
    
    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose: Regras executadas ap«s apresentar campos em tela   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN btFiltro  :SENSITIVE IN FRAME fPage1 = YES
           btFiltro2 :SENSITIVE IN FRAME fPage1 = YES.

    RETURN "OK":U.       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMasterDetail 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN tt-duimp-siscomex.cod-duimp-dts:SCREEN-VALUE IN FRAME {&FRAME-NAME}      = string(pcod-duimp-dts)
           tt-duimp-siscomex.cod-duimp-siscomex:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(pcod-duimp-siscomex).

   RUN pi-inicializa-filtro IN THIS-PROCEDURE.
   ASSIGN l-inicializacao = YES.
   APPLY "choose":U TO btFiltro IN FRAME fPage1.
   ASSIGN l-inicializacao = NO.

   RETURN "OK":U.           
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "cxbo/bocx00487.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00487.p YES}
        {btb/btb008za.i2 cxbo/bocx00487.p '' {&hDBOParent}} 
    END.
    
    RUN setConstraintDuimpKey IN {&hDBOParent} (input pcod-duimp-dts) NO-ERROR.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "DuimpByKey":U) NO-ERROR.    

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "cxbo/bocx00488.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx00488.p YES}
        {btb/btb008za.i2 cxbo/bocx00488.p '' {&hDBOSon2}} 
    END.    

    IF NOT VALID-HANDLE(h-boad098) OR
       h-boad098:TYPE <> "PROCEDURE":U OR
       h-boad098:FILE-NAME <> "adbo/boad098.p":U THEN DO:
        {btb/btb008za.i1 adbo/boad098.p YES}
        {btb/btb008za.i2 adbo/boad098.p '' h-boad098}
    END.    

    IF NOT VALID-HANDLE(h-boin172) OR
       h-boin172:TYPE <> "PROCEDURE":U OR
       h-boin172:FILE-NAME <> "inbo/boin172.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin172.p YES}
        {btb/btb008za.i2 inbo/boin172.p '' h-boin172}
    END.

    IF NOT VALID-HANDLE(h-bocx220na) OR
       h-bocx220na:TYPE <> "PROCEDURE":U OR
       h-bocx220na:FILE-NAME <> "cxbo/bocx220na.p":U THEN
        RUN cxbo/bocx220na.p  PERSISTENT SET h-bocx220na.    

    RUN inbo/boin274.p  persistent set h-boin274.
    RUN cxbo/bocx140.p  persistent set h-bocx140.    
    RUN inbo/boin082.p  persistent set h-boin082.
    RUN unbo/boun005.p  PERSISTENT SET h-boun005.
    RUN adbo/boad039.p  persistent set h-boad039.
    RUN cxbo/bocx110.p  persistent set h-bocx110.    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /*Se for utilizado o filtro nao executa novamente a pi-carrega-embarques-a-vincular*/
     IF NOT l-filtro-a-vinc THEN
        RUN pi-carrega-embarques-a-vincular IN THIS-PROCEDURE.
     ASSIGN l-filtro-a-vinc = NO.

     IF NOT l-filtro-vincul THEN
        RUN pi-carrega-embarques-vinculados IN THIS-PROCEDURE.
     ASSIGN l-filtro-vincul = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-embarques-a-vincular wMasterDetail 
PROCEDURE pi-carrega-embarques-a-vincular :
/*------------------------------------------------------------------------------
  Purpose: Carrega os embarques a vincular a DUIMP    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   /* Browser com embarques a vincular */
    IF NOT VALID-HANDLE(h-acomp) THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    END.

    {utp/ut-liter.i "Embarques"}
    RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
    IF c-lb-acomp = "":U THEN DO:
       {utp/ut-liter.i "Buscando_Embarques_a_Vincular"}
       ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
    END.
    RUN pi-acompanhar  in h-acomp (INPUT c-lb-acomp).
    ASSIGN c-lb-acomp = "":U.

    EMPTY TEMP-TABLE tt-param-ordens.
    CREATE tt-param-ordens.
    ASSIGN tt-param-ordens.cod-estabel-ini          = c-cod-estabel-ini            
           tt-param-ordens.cod-estabel-fim          = c-cod-estabel-fim            
           tt-param-ordens.cod-emitente-ini         = i-cod-emitente-ini          
           tt-param-ordens.cod-emitente-fim         = i-cod-emitente-fim          
           tt-param-ordens.nome-abrev-ini           = c-nome-abrev-ini            
           tt-param-ordens.nome-abrev-fim           = c-nome-abrev-fim            
           tt-param-ordens.embarque-ini             = c-embarque-ini
           tt-param-ordens.embarque-fim             = c-embarque-fim.

    RUN piBuscaOrdensVincular IN {&hDBOSon2} (INPUT  TABLE tt-param-ordens,
                                              INPUT  tt-duimp-siscomex.cod-duimp-dts:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                              OUTPUT TABLE tt-ordens-embarque).

    {utp/ut-liter.i "Carregando_Embarques_a_Vincular"}
    RUN pi-acompanhar in h-acomp (input RETURN-VALUE).
    {&OPEN-QUERY-brSon1}
    RUN pi-finalizar in h-acomp.

    IF AVAIL tt-ordens-embarque THEN DO:
        ASSIGN btVincula     :SENSITIVE IN FRAME fPage1 = YES
               btVinculaTodos:SENSITIVE IN FRAME fPage1 = YES.

        ENABLE brSon1 WITH FRAME fPage1.
    END.
    ELSE DO:
        ASSIGN btVincula     :SENSITIVE IN FRAME fPage1 = NO
               btVinculaTodos:SENSITIVE IN FRAME fPage1 = NO.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-embarques-vinculados wMasterDetail 
PROCEDURE pi-carrega-embarques-vinculados :
/*------------------------------------------------------------------------------
  Purpose: Carrega os embarques vinculados a DUIMP    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   /* Browser com embarques a vincular */
    IF NOT VALID-HANDLE(h-acomp) THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    END.

    {utp/ut-liter.i "Embarques"}
    RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
    IF c-lb-acomp = "":U THEN DO:
       {utp/ut-liter.i "Buscando_Embarques_Vinculados"}
       ASSIGN c-lb-acomp = TRIM(RETURN-VALUE).
    END.
    RUN pi-acompanhar  in h-acomp (INPUT c-lb-acomp).
    ASSIGN c-lb-acomp = "":U.

    EMPTY TEMP-TABLE tt-param-ordens.
    CREATE tt-param-ordens.
    ASSIGN tt-param-ordens.cod-estabel-ini    = c-cod-estabel-ini            
           tt-param-ordens.cod-estabel-fim    = c-cod-estabel-fim            
           tt-param-ordens.cod-emitente-ini   = i-cod-emitente-ini          
           tt-param-ordens.cod-emitente-fim   = i-cod-emitente-fim          
           tt-param-ordens.nome-abrev-ini     = c-nome-abrev-ini            
           tt-param-ordens.nome-abrev-fim     = c-nome-abrev-fim            
           tt-param-ordens.embarque-ini       = c-embarque-ini
           tt-param-ordens.embarque-fim       = c-embarque-fim.

    RUN piBuscaOrdensVinculadas IN {&hDBOSon2} (INPUT TABLE tt-param-ordens,
                                                INPUT l-filtro-vincul,
                                                INPUT tt-duimp-siscomex.cod-duimp-dts:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                                OUTPUT TABLE tt-duimp-item).

    {utp/ut-liter.i "Carregando_Embarques_Vinculados"}
    RUN pi-acompanhar in h-acomp (input RETURN-VALUE).
    {&OPEN-QUERY-brSon2}
    RUN pi-finalizar in h-acomp.

    IF AVAIL tt-duimp-item THEN DO:
        ASSIGN btDesvincula     :SENSITIVE IN FRAME fPage1 = YES
               btDesvinculaTodos:SENSITIVE IN FRAME fPage1 = YES.

        ENABLE brSon2 WITH FRAME fPage1.
    END.
    ELSE DO:
        ASSIGN btDesvincula     :SENSITIVE IN FRAME fPage1 = NO
               btDesvinculaTodos:SENSITIVE IN FRAME fPage1 = NO.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-filtro wMasterDetail 
PROCEDURE pi-inicializa-filtro :
/*------------------------------------------------------------------------------
  Purpose: Inicializar os parametros para abertura do filtro do browser    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-cod-estabel-ini        = "":U
           c-cod-estabel-fim        = "ZZZZZ":U
           i-cod-emitente-ini       = 0
           i-cod-emitente-fim       = 999999999
           c-nome-abrev-ini         = "":U
           c-nome-abrev-fim         = "ZZZZZZZZZZZZ":U
           c-embarque-ini           = "":U
           c-embarque-fim           = "ZZZZZZZZZZZZZZZZ":U.
           
    RUN findCodigo IN {&hDBOParent} (INPUT pcod-duimp-dts, OUTPUT c-return).
    IF  c-return = "":U THEN DO:
        RUN getCharField IN {&hDBOParent} (INPUT "cod-estabel":U, OUTPUT c-cod-estabel-ini).
        ASSIGN c-cod-estabel-fim = c-cod-estabel-ini.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDesVinculaEmbarque wMasterDetail 
PROCEDURE piDesVinculaEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     Desvincula Embarques da Declara‡Æo énica de Importa‡Æo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pr-rowid        AS ROWID                         NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel  LIKE ordens-embarque.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-embarque     LIKE ordens-embarque.embarque    NO-UNDO.

    RUN emptyRowErrors  IN {&hDBOSon2}.
    RUN emptyRowObject  IN {&hDBOSon2}.

    FOR FIRST btt-duimp-item EXCLUSIVE-LOCK
        WHERE btt-duimp-item.r-rowid = pr-rowid:

        RUN emptyRowErrors     IN {&hDBOSon2}.
        RUN repositionRecord   IN {&hDBOSon2} (INPUT btt-duimp-item.r-rowid).
        RUN deleteRecord       IN {&hDBOSon2}.

        RUN setDesVinculoEmbarqueDuimp IN h-bocx220na (INPUT pc-cod-estabel,
                                                       INPUT pc-embarque).
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVinculaEmbarque wMasterDetail 
PROCEDURE piVinculaEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     Vincula Embarques … Declara‡Æo énica de Importa‡Æo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel  LIKE ordens-embarque.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-embarque     LIKE ordens-embarque.embarque NO-UNDO.
    DEFINE INPUT PARAMETER pi-numero-ordem LIKE ordens-embarque.numero-ordem NO-UNDO.
    
    RUN emptyRowErrors  IN {&hDBOSon2}.
    RUN emptyRowObject  IN {&hDBOSon2}.
    
    ASSIGN l-nao-vinc = NO.
    FOR FIRST btt-ordens-embarque EXCLUSIVE-LOCK
        WHERE btt-ordens-embarque.cod-estabel  = pc-cod-estabel
          AND btt-ordens-embarque.embarque     = pc-embarque 
          AND btt-ordens-embarque.numero-ordem = pi-numero-ordem:

        RUN piCriaTTDuimpItem IN {&hDBOSon2} (INPUT pcod-duimp-dts,
                                              INPUT btt-ordens-embarque.cod-estabel,
                                              INPUT btt-ordens-embarque.embarque,
                                              INPUT btt-ordens-embarque.numero-ordem,
                                              OUTPUT TABLE rowErrors).

        IF  CAN-FIND(FIRST rowErrors WHERE rowErrors.ErrorSubType = "ERROR":U) THEN DO:
            ASSIGN l-nao-vinc = yes.

            FOR EACH rowErrors:
                CREATE rowErrorsAux.
                BUFFER-COPY rowErrors TO rowErrorsAux.
                DELETE rowErrors.
            END.
        END.
        ELSE DO:
            RUN setVinculoEmbarqueDuimp IN h-bocx220na (INPUT pc-cod-estabel,
                                                        INPUT pc-embarque,
                                                        INPUT pcod-duimp-dts).
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-cond-pagto wMasterDetail 
FUNCTION fn-cond-pagto RETURNS INTEGER
    ( ):
     
    IF AVAIL tt-ordens-embarque THEN DO:
        run findCotacaoAprovada in h-boin082 (input tt-ordens-embarque.numero-ordem,
                                              output c-return).
        if c-return = "" then
            run getIntfield in h-boin082(input "cod-cond-pag":U,output i-cod-cond-pag1).
    END.

  RETURN i-cod-cond-pag1.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-cond-pagto wMasterDetail 
FUNCTION fn-desc-cond-pagto RETURNS CHARACTER
  ( input p-cod-cond-pag as integer ) :
  
    run findCodigo in h-boad039(input p-cod-cond-pag,output c-return).
    if c-return = "" then
        run getCharfield in h-boad039(input "descricao":U,output c-cond-pagto1).

    RETURN c-cond-pagto1.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-descmoeda wMasterDetail 
FUNCTION fn-descmoeda RETURNS CHARACTER
  (  ) :

/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
    RUN findCodigo IN h-boun005 (INPUT i-mo-codigo1, 
                                 OUTPUT c-return).
    IF c-return = "" THEN DO:
        RUN GetCharField IN h-boun005 (INPUT "descricao":U,
                                       OUTPUT c-desc-moeda).
    END.

  RETURN c-desc-moeda.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-moeda wMasterDetail 
FUNCTION fn-moeda RETURNS INTEGER
  (  ) :
  
    IF AVAIL tt-ordens-embarque THEN DO:
        run findCotacaoAprovada in h-boin082 (input tt-ordens-embarque.numero-ordem,
                                              output c-return).
        if c-return = "" then
            run getIntfield in h-boin082(input "mo-codigo":U,output i-mo-codigo1).
    END.

    RETURN i-mo-codigo1.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnClasFiscItem wMasterDetail 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wMasterDetail 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
    ( ) :
  
    IF AVAIL tt-ordens-embarque THEN DO:
        RUN findOrdem in h-boin274 (input tt-ordens-embarque.numero-ordem, 
                                    output c-return).
                                    
        if c-return = "" then  
            RUN getCharField in h-boin274 (input "it-codigo":U, output c-it-codigo1).
    END.

    RETURN c-it-codigo1.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeAbrev wMasterDetail 
FUNCTION fnNomeAbrev RETURNS CHARACTER
  ( input i-cod-emitente as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   ASSIGN c-nome-abrev = "":U.
   
   RUN findCodigo IN h-boad098 (INPUT i-cod-emitente, OUTPUT c-return).
   IF  c-return = "":U THEN
       RUN getCharField IN h-boad098 (input "nome-abrev", OUTPUT c-nome-abrev).

    return c-nome-abrev.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPedido wMasterDetail 
FUNCTION fnPedido RETURNS integer
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    IF AVAIL tt-ordens-embarque THEN DO:
        RUN findPk_nr_processo IN h-bocx140 (INPUT  tt-ordens-embarque.nr-proc-imp,
                                             OUTPUT c-return).
    
        /* Retorno OK? */
        IF  c-return = "":U THEN DO:
            RUN getIntField IN h-bocx140 (INPUT "num-pedido":U, OUTPUT i-num-pedido1).
        END.
    END.

    RETURN i-num-pedido1.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnQuantidade wMasterDetail 
FUNCTION fnQuantidade RETURNS DECIMAL
  ( INPUT p-tipo as INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    ASSIGN d-quantidade = 0.
    for each bf-ordens-embarque fields(quantidade qt-do-forn)
        where bf-ordens-embarque.cod-estabel  = tt-ordens-embarque.cod-estabel
        AND   bf-ordens-embarque.embarque     = tt-ordens-embarque.embarque
        AND   bf-ordens-embarque.numero-ordem = tt-ordens-embarque.numero-ordem NO-LOCK:
        assign d-quantidade = d-quantidade 
                            + (IF p-tipo = 1 THEN bf-ordens-embarque.quantidade 
                               ELSE bf-ordens-embarque.qt-do-forn).
    end.
    
    RETURN d-quantidade.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnFornec wMasterDetail 
FUNCTION fnUnFornec RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF AVAIL tt-ordens-embarque THEN DO:
      run findCotacaoAprovada in h-boin082 (input tt-ordens-embarque.numero-ordem,
                                            output c-return).
      if c-return = "" then do:
        run getCharfield in h-boin082(input "un":U,output c-return).
        return c-return.
      end.
  END.
  
  return "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnidMedItem wMasterDetail 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnItem wMasterDetail 
FUNCTION fnUnItem RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  assign c-it-codigo1 = fnItem().

  run findCodigo in h-boin172 (input c-it-codigo1, output c-return).

  if c-return = "" then do:
      run getCharField in h-boin172 (input "un":U, output c-return).
      return c-return.
  end.
  
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


