&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic NO-UNDO LIKE decla-import-adic
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-adic-itens NO-UNDO LIKE decla-import-adic-itens
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-embarq NO-UNDO LIKE decla-import-embarq
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-ord NO-UNDO LIKE decla-import-ord
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-ord-aux NO-UNDO LIKE decla-import-ord
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-decla-import-proc NO-UNDO LIKE decla-import-proc
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
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
{include/i-prgvrs.i IM0410 2.00.00.030 } /*** "010030" 03/02/2026 09:09:05 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0410 MEX}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0410
&GLOBAL-DEFINE Version        2.00.00.030

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Ordens,Adiá‰es

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        tt-decla-import
&GLOBAL-DEFINE hDBOTable      h-BOCX383
&GLOBAL-DEFINE DBOTable       decla-import

&GLOBAL-DEFINE page0KeyFields tt-decla-import.cod-di-siscomex tt-decla-import.cod-estab tt-decla-import.dat-di tt-decla-import.num-di-ems tt-decla-import.num-seq-retif
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

&GLOBAL-DEFINE page1Widgets   rs-order-brSon1

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VAR gr-{&DBOTABLE} AS ROWID NO-UNDO.

/* Local Variable Definitions ---                                       */
define variable c-unid-med  as character no-undo.
define variable c-desc-item as character format 'x(40)' no-undo.
define variable i-cont      as integer no-undo.
define variable c-class-fiscal like item.class-fiscal no-undo.
define variable c-nr-proc-imp  like processo-imp.nr-proc-imp no-undo.

/* Local Variable Definitions (DBOs Handles) --- */
define variable {&hDBOTable}  as handle  no-undo.
define variable h-bocx402     as handle  no-undo.
define variable h-bocx403     as handle  no-undo.
define variable h-bocx404     as handle  no-undo.
define variable h-im0410a     as handle  no-undo.
define variable h-im0410b     as handle  no-undo.
define variable h-im0410e     as handle  no-undo.
DEFINE VARIABLE h-im0400d     AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx407     AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx383a    AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx00507   AS HANDLE  NO-UNDO.
define variable iRowsReturned as integer no-undo.
define variable i-conta-reg   as integer no-undo.
DEFINE VARIABLE i-tipo-geracao AS INTEGER INITIAL 0    NO-UNDO.
DEFINE VARIABLE l-encontrou   AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE tt-ordem-auxiliar NO-UNDO
    FIELD num-di-ems       LIKE decla-import-ord.num-di-ems
    FIELD cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts
    FIELD num-ordem        LIKE decla-import-ord.num-ordem
    FIELD num-parcela      LIKE decla-import-ord.num-parcela
    FIELD num-seq          AS   INTEGER.

DEFINE TEMP-TABLE tt-adicoes-auxiliar NO-UNDO
    FIELD num-di-ems       LIKE decla-import-adic.num-di-ems
    FIELD cdd-siscomex-dts LIKE decla-import-adic.cdd-siscomex-dts
    FIELD num-adic         LIKE decla-import-adic.num-adic
    FIELD num-conta        AS   INTEGER.

DEFINE TEMP-TABLE tt-decla-import-ord-class NO-UNDO
    FIELD num-ordem    LIKE decla-import-ord.num-ordem
    FIELD class-fiscal LIKE item.class-fiscal.

DEFINE VARIABLE c-descUN-NCM        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-param-ativo       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-reg-retornados    AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-nt2024002         AS LOGICAL     NO-UNDO.

/* Reforma Tribut†ria */
ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-nt2024002":U AND funcao.ativo).

{cxbo/bocx00507.i tt-decla-import-ord-trib}
{cxbo/bocx00507.i tt-decla-import-ord-trib-aux}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-decla-import-ord ~
tt-decla-import-ord-class tt-decla-import-adic

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-decla-import-ord.num-adic tt-decla-import-ord.num-seq //fnClassFis(tt-decla-import-ord.num-ordem) @ c-class-fiscal tt-decla-import-ord-class.class-fiscal tt-decla-import-ord.num-ordem tt-decla-import-ord.num-parcela tt-decla-import-ord.cod-item tt-decla-import-ord.qtd-item fnUN(tt-decla-import-ord.cod-item) @ c-unid-med tt-decla-import-ord.cod-embarq fnProcImp(tt-decla-import-ord.num-di-ems, tt-decla-import-ord.cdd-siscomex-dts, tt-decla-import-ord.cod-embarq) @ c-nr-proc-imp fnDescItem(tt-decla-import-ord.cod-item) @ c-desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 tt-decla-import-ord.num-adic ~
tt-decla-import-ord.num-seq   
&Scoped-define ENABLED-TABLES-IN-QUERY-brSon1 tt-decla-import-ord
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brSon1 tt-decla-import-ord
&Scoped-define SELF-NAME brSon1
&Scoped-define OPEN-QUERY-brSon1 IF rs-order-brSon1:SCREEN-VALUE IN FRAME fPage1 = '1':U /* Por Adiá∆o/Seq */ THEN      OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-ord, ~
                                       FIRST tt-decla-import-ord-class                                 WHERE tt-decla-import-ord-class.num-ordem = tt-decla-import-ord.num-ordem NO-LOCK                                 BY tt-decla-import-ord.num-adic                                 BY tt-decla-import-ord.num-seq. ELSE /* Por Classificaá∆o Fiscal */     OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-ord, ~
                                       FIRST tt-decla-import-ord-class                                 WHERE tt-decla-import-ord-class.num-ordem = tt-decla-import-ord.num-ordem NO-LOCK                                 BY tt-decla-import-ord-class.class-fiscal                                 BY tt-decla-import-ord.num-adic                                 BY tt-decla-import-ord.num-seq.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-decla-import-ord ~
tt-decla-import-ord-class
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-decla-import-ord
&Scoped-define SECOND-TABLE-IN-QUERY-brSon1 tt-decla-import-ord-class


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-decla-import-adic.num-adic tt-decla-import-adic.cod-classif-fisc tt-decla-import-adic.cdn-fornec tt-decla-import-adic.cod-incoterm tt-decla-import-adic.val-peso-liq tt-decla-import-adic.qtd-ncm fnUN-NCM(tt-decla-import-adic.num-di-ems, tt-decla-import-adic.num-adic, tt-decla-import-adic.cdd-siscomex-dts) @ c-descUN-NCM tt-decla-import-adic.val-vmcv-me[1] tt-decla-import-adic.cdn-moeda   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2   
&Scoped-define SELF-NAME brSon2
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-decla-import-adic NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-adic NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-decla-import-adic
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-decla-import-adic


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-decla-import.num-di-ems ~
tt-decla-import.cod-di-siscomex tt-decla-import.num-seq-retif ~
tt-decla-import.cod-estab tt-decla-import.dat-di 
&Scoped-define ENABLED-TABLES tt-decla-import
&Scoped-define FIRST-ENABLED-TABLE tt-decla-import
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btFiltro btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-decla-import.num-di-ems ~
tt-decla-import.cod-di-siscomex tt-decla-import.num-seq-retif ~
tt-decla-import.cod-estab tt-decla-import.dat-di 
&Scoped-define DISPLAYED-TABLES tt-decla-import
&Scoped-define FIRST-DISPLAYED-TABLE tt-decla-import


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnClassFis wMaintenance 
FUNCTION fnClassFis RETURNS CHARACTER
  ( i-num-ordem as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wMaintenance 
FUNCTION fnDescItem RETURNS CHARACTER
  ( c-cod-item as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnProcImp wMaintenance 
FUNCTION fnProcImp RETURNS CHARACTER
  ( i-num-di as integer, d-cdd-siscomex-dts AS DECIMAL, cCod-Embarq AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUN wMaintenance 
FUNCTION fnUN RETURNS CHARACTER
  ( c-cod-item as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUN-NCM wMaintenance 
FUNCTION fnUN-NCM RETURNS CHARACTER
  ( pnum-di-ems AS INTEGER, pnum-adic AS INTEGER, pcdd-siscomex-dts AS DECIMAL )  FORWARD.

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
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       MENU-ITEM m_Filtro       LABEL "&Filtro"       
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
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image/im-fil.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-fil.bmp":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro".

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

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-can 
     IMAGE-UP FILE "image/im-can":U
     IMAGE-INSENSITIVE FILE "image/im-can":U
     LABEL "Can" 
     SIZE 4 BY 1
     FONT 4.

DEFINE BUTTON bt-sav 
     IMAGE-UP FILE "image/im-sav":U
     IMAGE-INSENSITIVE FILE "image/ii-sav":U
     LABEL "Sav" 
     SIZE 4 BY 1
     FONT 4.

DEFINE BUTTON btAlterar 
     LABEL "Alterar" 
     SIZE 12.57 BY 1.

DEFINE BUTTON btExcluir 
     LABEL "Excluir" 
     SIZE 12.57 BY 1.

DEFINE BUTTON btGeraItens 
     LABEL "Gera Itens" 
     SIZE 12.57 BY 1.

DEFINE BUTTON btGerarAdic 
     LABEL "Gerar Adiá‰es" 
     SIZE 12.57 BY 1.

DEFINE BUTTON btInformAdic 
     LABEL "Informar Adiá‰es" 
     SIZE 12.57 BY 1.

DEFINE BUTTON btLimpaAdic 
     LABEL "Limpar Adiá∆o" 
     SIZE 12.57 BY 1.

DEFINE VARIABLE rs-order-brSon1 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Adiá∆o/Seq", 1,
"Classificaá∆o Fiscal", 2
     SIZE 32.14 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.13.

DEFINE BUTTON btAlteraAdic 
     LABEL "Alterar" 
     SIZE 12 BY 1.

DEFINE BUTTON btDeleteAdic 
     LABEL "Eliminar" 
     SIZE 12 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-decla-import-ord, 
      tt-decla-import-ord-class SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-decla-import-adic SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMaintenance _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      tt-decla-import-ord.num-adic COLUMN-LABEL "Adiá∆o" 
      tt-decla-import-ord.num-seq COLUMN-LABEL "Seq" 
      //fnClassFis(tt-decla-import-ord.num-ordem) @ c-class-fiscal COLUMN-LABEL "Classific Fiscal" FORMAT "x(20)":U
      tt-decla-import-ord-class.class-fiscal COLUMN-LABEL "Classific Fiscal" FORMAT "x(20)":U
      tt-decla-import-ord.num-ordem COLUMN-LABEL "Ordem de Compra"
      tt-decla-import-ord.num-parcela COLUMN-LABEL "Parc" 
      tt-decla-import-ord.cod-item 
      tt-decla-import-ord.qtd-item COLUMN-LABEL "Nossa Qtde" 
      fnUN(tt-decla-import-ord.cod-item) @ c-unid-med COLUMN-LABEL "UN" FORMAT "x(20)":U
      tt-decla-import-ord.cod-embarq COLUMN-LABEL "Embarque"       
      fnProcImp(tt-decla-import-ord.num-di-ems, tt-decla-import-ord.cdd-siscomex-dts, tt-decla-import-ord.cod-embarq) @ c-nr-proc-imp COLUMN-LABEL "Proc Import" FORMAT "x(12)":U
      fnDescItem(tt-decla-import-ord.cod-item) @ c-desc-item COLUMN-LABEL "Descriá∆o Item" FORMAT "x(30)":U WIDTH 30
      ENABLE
      tt-decla-import-ord.num-adic 
      tt-decla-import-ord.num-seq
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.25
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMaintenance _FREEFORM
  QUERY brSon2 NO-LOCK DISPLAY
      tt-decla-import-adic.num-adic FORMAT "999":U COLUMN-LABEL 'Adiá∆o':U
      tt-decla-import-adic.cod-classif-fisc FORMAT "9999.99.99":U COLUMN-LABEL 'Classificaá∆o Fiscal':U
      tt-decla-import-adic.cdn-fornec FORMAT ">>>>>>>>9":U COLUMN-LABEL 'Fornecedor':U
      tt-decla-import-adic.cod-incoterm FORMAT "X(3)":U COLUMN-LABEL 'Incoterm':U
      tt-decla-import-adic.val-peso-liq FORMAT ">>>,>>>,>>9.99999":U COLUMN-LABEL 'Peso L°quido':U
      tt-decla-import-adic.qtd-ncm FORMAT "->>>>,>>9.9999":U COLUMN-LABEL 'Quantidade':U
      fnUN-NCM(tt-decla-import-adic.num-di-ems, tt-decla-import-adic.num-adic, tt-decla-import-adic.cdd-siscomex-dts) @ c-descUN-NCM COLUMN-LABEL 'Unidade':U
      tt-decla-import-adic.val-vmcv-me[1] FORMAT "->>,>>>,>>>,>>9.999999999":U COLUMN-LABEL 'VMCV':U
      tt-decla-import-adic.cdn-moeda FORMAT "999":U COLUMN-LABEL 'Moeda':U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 81 BY 10
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
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
     btFiltro AT ROW 1.13 COL 25.57 HELP
          "Pesquisa"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-decla-import.num-di-ems AT ROW 2.75 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-decla-import.cod-di-siscomex AT ROW 2.75 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     tt-decla-import.num-seq-retif AT ROW 2.75 COL 75.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     tt-decla-import.cod-estab AT ROW 3.75 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-decla-import.dat-di AT ROW 3.75 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.58
         FONT 1.

DEFINE FRAME fPage1
     rs-order-brSon1 AT ROW 1.33 COL 13.86 NO-LABEL
     brSon1 AT ROW 2.5 COL 2
     btGeraItens AT ROW 11.79 COL 1.72
     btAlterar AT ROW 11.79 COL 14.14
     btExcluir AT ROW 11.79 COL 26.57
     btGerarAdic AT ROW 11.79 COL 39
     btInformAdic AT ROW 11.79 COL 51.43
     btLimpaAdic AT ROW 11.79 COL 63.86
     bt-can AT ROW 11.79 COL 76.29 HELP
          "Cancela alteraá‰es"
     bt-sav AT ROW 11.79 COL 80.14 HELP
          "Confirma alteraá‰es"
     "Ordenaá∆o" VIEW-AS TEXT
          SIZE 9.72 BY .54 AT ROW 1.04 COL 4.29 
     RECT-1 AT ROW 1.21 COL 2 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
         SIZE 84.43 BY 12.14
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.5 COL 3
     btAlteraAdic AT ROW 11.67 COL 2
     btDeleteAdic AT ROW 11.67 COL 14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 6.38
         SIZE 84.43 BY 12.14
         FONT 1.


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
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic T "?" NO-UNDO mgcex decla-import-adic
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-adic-itens T "?" NO-UNDO mgcex decla-import-adic-itens
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-embarq T "?" NO-UNDO mgcex decla-import-embarq
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-ord T "?" NO-UNDO mgcex decla-import-ord
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-ord-aux T "?" NO-UNDO mgcex decla-import-ord
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-decla-import-proc T "?" NO-UNDO mgcex decla-import-proc
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
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
         HEIGHT             = 18.58
         WIDTH              = 90
         MAX-HEIGHT         = 18.88
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.88
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
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 rs-order-brSon1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
IF rs-order-brSon1:SCREEN-VALUE IN FRAME fPage1 = '1':U /* Por Adiá∆o/Seq */ THEN

    OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-ord,
                                FIRST tt-decla-import-ord-class
                                WHERE tt-decla-import-ord-class.num-ordem = tt-decla-import-ord.num-ordem NO-LOCK
                                BY tt-decla-import-ord.num-adic
                                BY tt-decla-import-ord.num-seq.
ELSE /* Por Classificaá∆o Fiscal */
    OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-ord,
                                FIRST tt-decla-import-ord-class
                                WHERE tt-decla-import-ord-class.num-ordem = tt-decla-import-ord.num-ordem NO-LOCK
                                BY tt-decla-import-ord-class.class-fiscal
                                BY tt-decla-import-ord.num-adic
                                BY tt-decla-import-ord.num-seq.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-adic NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSon2 */
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


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMaintenance
ON VALUE-CHANGED OF brSon1 IN FRAME fPage1
DO:
    if  avail tt-decla-import-ord 
    then STATUS INPUT caps(c-desc-item:screen-value in browse brSon1) IN WINDOW CURRENT-WINDOW.
    else STATUS INPUT "" IN WINDOW CURRENT-WINDOW.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon2
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon2 wMaintenance
ON MOUSE-SELECT-CLICK OF brSon2 IN FRAME fPage2
DO:
    IF AVAIL tt-decla-import-adic AND 
       NOT l-encontrou THEN  
        ENABLE btDeleteAdic WITH FRAME fPage2.
    ELSE 
        DISABLE btDeleteAdic WITH FRAME fPage2.
    
    STATUS INPUT "" IN WINDOW CURRENT-WINDOW.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon2 wMaintenance
ON VALUE-CHANGED OF brSon2 IN FRAME fPage2
DO:
    STATUS INPUT "" IN WINDOW CURRENT-WINDOW.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-can
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-can wMaintenance
ON CHOOSE OF bt-can IN FRAME fPage1 /* Can */
DO:
  RUN pi-cancela-gerar-adicao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sav
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sav wMaintenance
ON CHOOSE OF bt-sav IN FRAME fPage1 /* Sav */
DO:
  RUN pi-gera-adicoes(INPUT NO).
  RELEASE decla-import-adic.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAlteraAdic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlteraAdic wMaintenance
ON CHOOSE OF btAlteraAdic IN FRAME fPage2 /* Alterar */
DO:
    RUN pi-carregaTTAdic-aux.
    run pi-altera-adic.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAlterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlterar wMaintenance
ON CHOOSE OF btAlterar IN FRAME fPage1 /* Alterar */
DO:
    RUN pi-carregaTTAuxiliar.
    run pi-alteraOrdens.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDeleteAdic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteAdic wMaintenance
ON CHOOSE OF btDeleteAdic IN FRAME fPage2 /* Eliminar */
DO: 
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-confirma-a-exclusao AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Confirma_a_exclus∆o?" *}
    ASSIGN c-lbl-liter-confirma-a-exclusao = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-a-confirmacao-ira-eliminar-o-r AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "A_confirmaá∆o_ir†_eliminar_o_registro_selecionado_de_Adiá∆o_da_DI._Continua?" *}
    ASSIGN c-lbl-liter-a-confirmacao-ira-eliminar-o-r = TRIM(RETURN-VALUE).
    RUN utp/ut-msgs.p (INPUT 'show', INPUT 27100, c-lbl-liter-confirma-a-exclusao + '~~' + 
                                                  c-lbl-liter-a-confirmacao-ira-eliminar-o-r).
    IF  RETURN-VALUE = 'yes' THEN DO:
        RUN pi-exclui-adic.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluir wMaintenance
ON CHOOSE OF btExcluir IN FRAME fPage1 /* Excluir */
DO: 
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-confirma-a-exclusao-2 AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Confirma_a_exclus∆o?" *}
    ASSIGN c-lbl-liter-confirma-a-exclusao-2 = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-a-confirmacao-ira-eliminar-o-r-2 AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "A_confirmaá∆o_ir†_eliminar_o_registro_selecionado_de_Ordens_DI._Continua?" *}
    ASSIGN c-lbl-liter-a-confirmacao-ira-eliminar-o-r-2 = TRIM(RETURN-VALUE).
    RUN utp/ut-msgs.p (INPUT 'show', INPUT 27100, c-lbl-liter-confirma-a-exclusao-2 + '~~' + 
                                                  c-lbl-liter-a-confirmacao-ira-eliminar-o-r-2).
    IF  RETURN-VALUE = 'yes' THEN DO:
        RUN pi-excluiOrdens.
    END. /* IF  RETURN-VALUE = 'yes' */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btGeraItens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGeraItens wMaintenance
ON CHOOSE OF btGeraItens IN FRAME fPage1 /* Gera Itens */
DO:
    IF NOT valid-handle(h-acomp) THEN
        RUN utp/ut-acomp PERSISTENT SET h-acomp.      
    
    ASSIGN i-tipo-geracao = 0.

    IF CAN-FIND(FIRST tt-decla-import-ord) THEN DO:
        ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
        RUN imp/im0410e.w PERSISTENT SET h-im0410e (INPUT THIS-PROCEDURE).
        IF  VALID-HANDLE (h-im0410e) THEN DO:
            RUN initializeInterface IN h-im0410e.
            WAIT-FOR CLOSE OF h-im0410e FOCUS CURRENT-WINDOW.            
        END.     
        ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        
        RUN pi-inicializar IN h-acomp ("Gerando itens"). 
        RUN pi-desabilita-cancela IN h-acomp.

        IF  i-tipo-geracao = 2 THEN DO:
            RUN piDeletaRelacs IN {&hDBOTable} (INPUT tt-decla-import.num-di-ems,
                                                INPUT tt-decla-import.cdd-siscomex-dts).
            RUN pi-GerarItens.
        END. /* IF  RETURN-VALUE = 'yes' THEN DO: */
        ELSE DO:
            IF i-tipo-geracao = 1 THEN
                RUN pi-GerarItens.
        END.
    END.
    ELSE DO:
        RUN pi-inicializar IN h-acomp ("Gerando itens"). 
        RUN pi-desabilita-cancela IN h-acomp.
        RUN pi-GerarItens.
    END.
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    RUN pi-atualiza-pend-rat IN h-bocx383a(INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                           INPUT tt-decla-import.cdd-siscomex-dts).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGerarAdic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGerarAdic wMaintenance
ON CHOOSE OF btGerarAdic IN FRAME fPage1 /* Gerar Adiá‰es */
DO:
    DO  TRANS:
        run pi-gera-adicoes(INPUT YES).
        IF RETURN-VALUE = "NOK":U THEN 
            UNDO,LEAVE.
        ELSE
            RUN pi-atualiza-pend-rat IN h-bocx383a(INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                                   INPUT tt-decla-import.cdd-siscomex-dts).
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btInformAdic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInformAdic wMaintenance
ON CHOOSE OF btInformAdic IN FRAME fPage1 /* Informar Adiá‰es */
DO: 
    IF CAN-FIND(FIRST tt-decla-import-ord) THEN DO:
        disable btAlterar btExcluir btGeraItens btGerarAdic btInformAdic with frame fPage1.
        enable bt-sav bt-can btLimpaAdic with frame fPage1.

        ASSIGN tt-decla-import-ord.num-adic:READ-ONLY IN BROWSE brSon1 = NO
               tt-decla-import-ord.num-seq :READ-ONLY IN BROWSE brSon1 = NO.
        
        browse brSon1:select-row(1) no-error.
        apply 'entry' to tt-decla-import-ord.num-adic in browse brSon1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btLimpaAdic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLimpaAdic wMaintenance
ON CHOOSE OF btLimpaAdic IN FRAME fPage1 /* Limpar Adiá∆o */
DO:
    IF CAN-FIND(FIRST tt-decla-import-ord) THEN DO:
        for each  tt-decla-import-ord
            where tt-decla-import-ord.num-di-ems       = tt-decla-import.num-di-ems
            AND   tt-decla-import-ord.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts:
            assign tt-decla-import-ord.num-adic = 0
                   tt-decla-import-ord.num-seq  = 0.
        end.

        {&OPEN-QUERY-brSon1}

        browse brSon1:select-row(1) no-error.
        apply 'entry' to tt-decla-import-ord.num-adic in browse brSon1.

    END.
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


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
   {method/zoomreposition.i &ProgramZoom="cxzoom/z01cx400.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMaintenance
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME rs-order-brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-order-brSon1 wMaintenance
ON VALUE-CHANGED OF rs-order-brSon1 IN FRAME fPage1
DO:
  {&OPEN-QUERY-brSon1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
ASSIGN tt-decla-import.cod-di-siscomex:FORMAT IN FRAME fpage0 = "x(20)".

{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    if valid-handle(h-bocx402)  then delete procedure h-bocx402.
    if valid-handle(h-bocx403)  then delete procedure h-bocx403.
    if valid-handle(h-bocx404)  then delete procedure h-bocx404.
    if valid-handle(h-bocx407)  then delete procedure h-bocx407.
    if valid-handle(h-im0410a)  then delete procedure h-im0410a.
    if valid-handle(h-im0410b)  then delete procedure h-im0410b.
    if valid-handle(h-im0410e)  then delete procedure h-im0410e.
    if valid-handle(h-im0400d)  then delete procedure h-im0400d.
    if valid-handle(h-bocx383a) then delete procedure h-bocx383a.
    if valid-handle(h-bocx00507) then delete procedure h-bocx00507.
        
    ASSIGN h-bocx402 = ?
           h-bocx403 = ?
           h-bocx404 = ?
           h-bocx407 = ?
           h-im0410a = ?
           h-im0410b = ?
           h-bocx00507 = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    RUN pi-buscaOrdens.
    RUN pi-busca-adic.
    
    if  avail tt-decla-import 
    then enable  btGeraItens with frame fPage1.
    else disable btGeraItens with frame fPage1.
        
    if  avail tt-decla-import-ord
    then enable  btAlterar btExcluir btGerarAdic btInformAdic with frame fPage1.
    else disable btAlterar btExcluir btGerarAdic btInformAdic with frame fPage1.

    IF CAN-FIND(FIRST tt-decla-import-adic) THEN
        ENABLE btAlteraAdic 
               btDeleteAdic WITH FRAME fPage2.
    ELSE
        DISABLE btAlteraAdic 
                btDeleteAdic WITH FRAME fPage2.

    RUN pi-trata-gera-adic-manual (INPUT YES).
    
    RUN pi-altera-di. /* alterar di */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenance 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
   ENABLE rs-order-brSon1 WITH FRAME fPage1.
   ASSIGN rs-order-brSon1:SCREEN-VALUE IN FRAME fPage1 = '1':U.

  /*---[ Inicializa a tela mostrando todas as ativas ]---*/
    IF  l-param-ativo THEN DO:
        RUN setConstraintByLogAtivo IN h-bocx383 (INPUT l-param-ativo).
        RUN openQueryStatic         IN h-bocx383 (INPUT "ByLogAtivo").
    END. /* IF  l-param-ativo */
    ELSE DO:
        RUN openQueryStatic IN h-bocx383 (INPUT "Main").
    END. /* ELSE DO: */

    IF  gr-{&DBOTABLE} <> ? THEN DO:
        RUN repositionRecord IN THIS-PROCEDURE (INPUT gr-{&DBOTABLE}).
    END. /* IF  gr-{&DBOTABLE} <> ? */
    ELSE DO:
        RUN getFirst IN THIS-PROCEDURE.
    END. /* ELSE DO: */
  /*-----------------------------------------------------*/
    
    ASSIGN btFiltro:SENSITIVE IN FRAME fPage0 = YES.

    enable brSon1 with frame fPage1.
    enable brSon2 with frame fPage2.

    apply 'entry' to btGeraItens in frame fPage1.

    IF CAN-FIND(FIRST tt-decla-import-adic) 
    THEN ENABLE  btAlteraAdic btDeleteAdic WITH FRAME fPage2.
    ELSE DISABLE btAlteraAdic btDeleteAdic WITH FRAME fPage2.

    RUN pi-trata-gera-adic-manual (INPUT YES).
    RUN pi-altera-di. /* alterar di */
   
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
        WHEN 1 THEN DO:
            ASSIGN pDBOHandle = h-bocx404.
        END.
        WHEN 2 THEN DO:
            ASSIGN pDBOHandle = h-bocx403.
        END.
    END CASE.

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
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON    btGoToCancel       AUTO-END-KEY LABEL "&Cancelar" SIZE 10 BY 1 BGCOLOR 8.
    DEFINE BUTTON    btGoToOK           AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToButton       EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 58 BY 1.42 BGCOLOR 7.
    DEFINE VARIABLE  rGoTo              AS ROWID                         NO-UNDO.
    DEFINE VARIABLE  num-di-ems         LIKE {&ttTable}.num-di-ems       NO-UNDO.
    DEFINE VARIABLE  d-cdd-siscomex-dts LIKE {&ttTable}.cdd-siscomex-dts NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        num-di-ems        AT ROW 1.21 COL 29 COLON-ALIGNED view-as fill-in size 11 by .88
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1.25
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Declaraá∆o Importaá∆o" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Declaraá∆o_Importaá∆o"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN num-di-ems.
        
        RUN goToKeyCustom IN {&hDBOTable} (INPUT num-di-ems,
                                           INPUT d-cdd-siscomex-dts).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Declaraá∆o_Importaá∆o" *}
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
    Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF  NOT VALID-HANDLE({&hDBOTable}) OR
        {&hDBOTable}:TYPE      <> "PROCEDURE":U OR
        {&hDBOTable}:FILE-NAME <> "cxbo/bocx383.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx383.p YES}
        {btb/btb008za.i2 cxbo/bocx383.p '' {&hDBOTable}}
    END.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE (h-bocx402) THEN RUN cxbo/bocx402.p PERSISTENT SET h-bocx402. /* decla-import-adic-itens */
    IF NOT VALID-HANDLE (h-bocx403) THEN RUN cxbo/bocx403.p PERSISTENT SET h-bocx403. /* decla-import-adic */
    IF NOT VALID-HANDLE (h-bocx404) THEN RUN cxbo/bocx404.p PERSISTENT SET h-bocx404. /* decla-import-ord */
        RUN openQueryStatic IN h-bocx404 (INPUT 'Main':U).
    IF NOT VALID-HANDLE (h-bocx407) THEN RUN cxbo/bocx407.p PERSISTENT SET h-bocx407. /* decla-import-embarq */

     IF NOT VALID-HANDLE (h-bocx383a) THEN DO:
        RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.
        RUN openQueryStatic IN h-bocx383a (INPUT "Main":U) NO-ERROR.
    END.
    
    IF NOT VALID-HANDLE(h-bocx00507) THEN 
        RUN cxbo/bocx00507.p PERSISTENT SET h-bocx00507.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-adic wMaintenance 
PROCEDURE pi-altera-adic :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DO  i-cont = 1 TO brSon2:NUM-SELECTED-ROWS IN FRAME fPage2:
        IF  brSon2:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage2 THEN DO:  
            ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
            RUN imp/im0410b.w PERSISTENT SET h-im0410b (INPUT tt-decla-import-adic.r-Rowid,
                                                        INPUT tt-decla-import.r-Rowid,
                                                        INPUT 'UPDATE',
                                                        INPUT THIS-PROCEDURE,
                                                        INPUT 2).
            IF  VALID-HANDLE (h-im0410b) THEN DO:
                FOR FIRST tt-adicoes-auxiliar 
                    WHERE tt-adicoes-auxiliar.num-di-ems       = tt-decla-import-adic.num-di-ems
                    AND   tt-adicoes-auxiliar.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
                    AND   tt-adicoes-auxiliar.num-adic         = tt-decla-import-adic.num-adic:
                    run pi-seta-linha-browse in h-im0410b(input tt-adicoes-auxiliar.num-conta).
                END. /* FOR FIRST tt-adicoes-auxiliar */
                RUN initializeInterface IN h-im0410b.
                WAIT-FOR CLOSE OF h-im0410b FOCUS CURRENT-WINDOW.
            END. 
            ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        END. /* IF  brSon2:FETCH-SELECTED-ROW(i-cont) */
    END. /* DO  i-cont = 1 TO brSon2 */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-di wMaintenance 
PROCEDURE pi-altera-di :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    IF  VALID-HANDLE(h-bocx383a) AND 
        AVAIL tt-decla-import    THEN DO:
        RUN piDoctoRecebimento IN h-bocx383a(INPUT tt-decla-import.cod-di-siscomex, OUTPUT l-encontrou).
    
        IF  l-encontrou THEN DO:
            DISABLE btGeraItens btExcluir btGerarAdic btInformAdic btLimpaAdic bt-can bt-sav WITH FRAME fPage1.
            DISABLE btDeleteAdic WITH FRAME fPage2.
        END. /* IF  tt-decla-import.log-livre-1 THEN DO: */
    END. /* IF  VALID-HANDLE(h-bocx383a) THEN DO: */
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-alteraOrdens wMaintenance 
PROCEDURE pi-alteraOrdens :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DO  i-cont = 1 TO brSon1:NUM-SELECTED-ROWS IN FRAME fPage1:
        IF  brSon1:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage1 THEN DO:  
            ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
            RUN imp/im0410a.w PERSISTENT SET h-im0410a (INPUT tt-decla-import-ord.r-Rowid, /* prTable  */
                                                        INPUT tt-decla-import.r-Rowid,
                                                        INPUT 'UPDATE',                    /* pcAction */
                                                        INPUT THIS-PROCEDURE,
                                                        INPUT 1).             /* phCaller */
            IF  VALID-HANDLE(h-im0410a) THEN DO:   

                FOR FIRST tt-ordem-auxiliar 
                    WHERE tt-ordem-auxiliar.num-di-ems        = tt-decla-import-ord.num-di-ems
                    AND   tt-ordem-auxiliar.cdd-siscomex-dts  = tt-decla-import-ord.cdd-siscomex-dts
                    AND   tt-ordem-auxiliar.num-ordem         = tt-decla-import-ord.num-ordem
                    AND   tt-ordem-auxiliar.num-parcela       = tt-decla-import-ord.num-parcela:
                    run pi-seta-linha-browse in h-im0410a(input tt-ordem-auxiliar.num-seq).
                END. /* FOR FIRST tt-ordem-auxiliar */
                
                RUN initializeInterface IN h-im0410a.
                WAIT-FOR CLOSE OF h-im0410a FOCUS CURRENT-WINDOW.
            END. 
            ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        END. /* IF  brSon1:FETCH-SELECTED-ROW(i-cont) */
    END. /* DO  i-cont = 1 TO brSon1 */
    RUN pi-busca-adic.
    RUN pi-buscaOrdens.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-adic wMaintenance 
PROCEDURE pi-busca-adic :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    empty temp-table tt-decla-import-adic.

    IF AVAIL tt-decla-import THEN DO:

        RUN setConstraintByDI IN h-bocx403 (INPUT tt-decla-import.num-di-ems,
                                            INPUT tt-decla-import.cdd-siscomex-dts).
        RUN openQueryStatic   IN h-bocx403 (INPUT "ByDI":U).
        RUN getBatchRecords   IN h-bocx403 (INPUT ?, 
                                            INPUT ?, 
                                            INPUT 99999, 
                                            OUTPUT iRowsReturned, 
                                            OUTPUT TABLE tt-decla-import-adic).
        {&OPEN-QUERY-brSon2}
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-buscaByFiltro wMaintenance 
PROCEDURE pi-buscaByFiltro :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF  l-param-ativo THEN DO:
        RUN setConstraintByLogAtivo IN h-bocx383 (INPUT l-param-ativo).
        RUN openQueryStatic         IN h-bocx383 (INPUT "ByLogAtivo").
    END. /* IF  l-param-ativo */
    ELSE DO:
        RUN openQueryStatic IN h-bocx383 (INPUT "Main").
    END. /* ELSE DO: */

    IF  gr-{&DBOTABLE} <> ? THEN DO:
        RUN repositionRecord IN THIS-PROCEDURE (INPUT gr-{&DBOTABLE}).
    END. /* IF  gr-{&DBOTABLE} <> ? */
    ELSE DO:
        RUN getFirst IN THIS-PROCEDURE.
    END. /* ELSE DO: */
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-buscaOrdens wMaintenance 
PROCEDURE pi-buscaOrdens :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    empty temp-table tt-decla-import-ord.
    EMPTY TEMP-TABLE tt-decla-import-ord.

    IF AVAIL tt-decla-import THEN DO:

        RUN setConstraintByDI IN h-bocx404 (INPUT tt-decla-import.num-di-ems,
                                            INPUT tt-decla-import.cdd-siscomex-dts) NO-ERROR.
        RUN openQueryStatic   IN h-bocx404 (INPUT "ByDI":U) NO-ERROR.
        RUN getBatchRecords   IN h-bocx404 (INPUT ?, 
                                            INPUT ?, 
                                            INPUT 99999, 
                                            OUTPUT iRowsReturned, 
                                            OUTPUT TABLE tt-decla-import-ord).
        /* Reforma Tribut†ria */                                    
        IF l-nt2024002 THEN DO:
            FOR FIRST tt-decla-import-ord NO-LOCK:
                
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
                                                      
            END.
        END.
        RUN pi-carregaTTClassFiscal.

        {&OPEN-QUERY-brSon1}
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cancela-gerar-adicao wMaintenance 
PROCEDURE pi-cancela-gerar-adicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN pi-busca-adic.
RUN pi-buscaOrdens.
RUN pi-trata-gera-adic-manual (INPUT YES).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carregaTTAdic-aux wMaintenance 
PROCEDURE pi-carregaTTAdic-aux :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-adicoes-auxiliar NO-ERROR.
    ASSIGN i-conta-reg = 0.

    IF  AVAIL tt-decla-import-adic THEN 
        FOR EACH tt-decla-import-adic:

            ASSIGN i-conta-reg = i-conta-reg + 1.

            CREATE tt-adicoes-auxiliar.
            ASSIGN tt-adicoes-auxiliar.num-di-ems       = tt-decla-import-adic.num-di-ems
                   tt-adicoes-auxiliar.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
                   tt-adicoes-auxiliar.num-adic         = tt-decla-import-adic.num-adic
                   tt-adicoes-auxiliar.num-conta        = i-conta-reg.

        END. /* FOR EACH tt-decla-import-adic: */
    
    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carregaTTAuxiliar wMaintenance 
PROCEDURE pi-carregaTTAuxiliar :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-ordem-auxiliar NO-ERROR.
    ASSIGN i-conta-reg = 0.

    IF  AVAIL tt-decla-import-ord THEN 
        FOR EACH tt-decla-import-ord:

            ASSIGN i-conta-reg = i-conta-reg + 1.

            CREATE tt-ordem-auxiliar.
            ASSIGN tt-ordem-auxiliar.num-di-ems       = tt-decla-import-ord.num-di-ems
                   tt-ordem-auxiliar.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts
                   tt-ordem-auxiliar.num-ordem        = tt-decla-import-ord.num-ordem
                   tt-ordem-auxiliar.num-parcela      = tt-decla-import-ord.num-parcela
                   tt-ordem-auxiliar.num-seq          = i-conta-reg.

        END. /* FOR EACH tt-decla-import-ord: */
    
    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carregaTTClassFiscal wMaintenance 
PROCEDURE pi-carregaTTClassFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-decla-import-ord-class.
    FOR EACH tt-decla-import-ord:
        FIND FIRST tt-decla-import-ord-class
            WHERE tt-decla-import-ord-class.num-ordem = tt-decla-import-ord.num-ordem NO-ERROR.
        IF NOT AVAIL tt-decla-import-ord-class THEN DO:
            CREATE tt-decla-import-ord-class.
            ASSIGN tt-decla-import-ord-class.num-ordem    = tt-decla-import-ord.num-ordem
                   tt-decla-import-ord-class.class-fiscal = fnClassFis(tt-decla-import-ord.num-ordem).
        END.
    END.
    
    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exclui-adic wMaintenance 
PROCEDURE pi-exclui-adic :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DO  i-cont = 1 TO brSon2:NUM-SELECTED-ROWS IN FRAME fPage2:
        IF  brSon2:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage2 THEN DO:  
            RUN openQueryStatic IN h-bocx403 (INPUT 'Main':U).
            RUN goToKey IN h-bocx403 (input tt-decla-import-adic.num-di-ems,
                                      input tt-decla-import-adic.num-adic,
                                      INPUT tt-decla-import-adic.cdd-siscomex-dts).
            IF  RETURN-VALUE = "OK":U THEN do: 
                RUN emptyRowErrors IN h-bocx403.
                RUN deleteRecord IN h-bocx403.
                /* Reforma Tributaria */
                FOR EACH decla-import-adic-trib EXCLUSIVE-LOCK
                   WHERE decla-import-adic-trib.num-di-ems       = tt-decla-import-adic.num-di-ems
                     AND decla-import-adic-trib.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
                     AND decla-import-adic-trib.num-adic         = tt-decla-import-adic.num-adic:
                    DELETE decla-import-adic-trib.
                END.
                FOR EACH decla-imp-adic-it-trib WHERE decla-imp-adic-it-trib.num-di-ems       = tt-decla-import-adic.num-di-ems
                                                AND   decla-imp-adic-it-trib.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
                                                AND   decla-imp-adic-it-trib.num-adic         = tt-decla-import-adic.num-adic
                                                EXCLUSIVE-LOCK:
                    DELETE decla-imp-adic-it-trib.
                END.
                RUN pi-busca-adic.
                {&OPEN-QUERY-brSon2}
            END.
        END.
    END.

    RELEASE decla-import-adic-trib.
    RELEASE decla-imp-adic-it-trib.
    
    /* recarregar o browse da fPage1 (ordens) */
    RUN setConstraintByDI IN h-bocx404 (INPUT tt-decla-import.num-di-ems,
                                        INPUT tt-decla-import.cdd-siscomex-dts).
    RUN openQueryStatic   IN h-bocx404 (INPUT "ByDI":U).
    RUN getBatchRecords   IN h-bocx404 (INPUT ?, 
                                        INPUT ?, 
                                        INPUT 99999, 
                                        OUTPUT iRowsReturned, 
                                        OUTPUT TABLE tt-decla-import-ord).
    RUN pi-carregaTTClassFiscal.

    {&OPEN-QUERY-brSon1}
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-excluiOrdens wMaintenance 
PROCEDURE pi-excluiOrdens :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DO  i-cont = 1 TO brSon1:NUM-SELECTED-ROWS IN FRAME fPage1:
        IF  brSon1:FETCH-SELECTED-ROW(i-cont) IN FRAME fPage1 THEN DO:  
            RUN openQueryStatic IN h-bocx404 (INPUT 'Main':U).
            RUN goToKey IN h-bocx404 (input tt-decla-import-ord.num-di-ems,
                                      input tt-decla-import-ord.num-ordem,
                                      input tt-decla-import-ord.num-parcela,
                                      INPUT tt-decla-import-ord.cdd-siscomex-dts).
            
            IF  RETURN-VALUE = "OK":U THEN do: 
                RUN emptyRowErrors  IN h-bocx404.
                RUN deleteRecord    IN h-bocx404.
                /* Reforma Tribut†ria */
                IF l-nt2024002 THEN DO:
                    RUN piDeleteRegistro IN h-bocx00507 (INPUT tt-decla-import-ord.num-di-ems,
                                                         INPUT tt-decla-import-ord.cdd-siscomex-dts,
                                                         INPUT tt-decla-import-ord.num-ordem,
                                                         INPUT tt-decla-import-ord.num-parcela).
                END.
                RUN pi-busca-adic.
                {&OPEN-QUERY-brSon2} 
            END.
            
            RUN pi-buscaOrdens.
            RUN pi-trata-gera-adic-manual (INPUT YES).
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filtro wMaintenance 
PROCEDURE pi-filtro :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    RUN imp/im0400d.w PERSISTENT SET h-im0400d (INPUT THIS-PROCEDURE).
    IF  VALID-HANDLE (h-im0400d) THEN DO:
        RUN initializeInterface IN h-im0400d.
        WAIT-FOR CLOSE OF h-im0400d FOCUS CURRENT-WINDOW.

        RUN pi-buscaByFiltro.

    END. /* IF  VALID-HANDLE (h-im0400d) */
    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-adicoes wMaintenance 
PROCEDURE pi-gera-adicoes :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-geracao-automatica AS LOGICAL NO-UNDO.

    DEFINE VARIABLE l-gera   AS LOGICAL     NO-UNDO.
    EMPTY TEMP-TABLE RowErrors.
    IF CAN-FIND(FIRST tt-decla-import-adic) THEN DO:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-confirma-a-execucao-deste-bota AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Confirma_a_execuá∆o_deste_bot∆o?" *}
    ASSIGN c-lbl-liter-confirma-a-execucao-deste-bota = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-a-confirmacao-ira-eliminar-os AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "A_confirmaá∆o_ir†_eliminar_os_registros_relacionados_Adiá‰es_e_Itens_das_Adiá‰es._Continua?" *}
    ASSIGN c-lbl-liter-a-confirmacao-ira-eliminar-os = TRIM(RETURN-VALUE).
    RUN utp/ut-msgs.p (INPUT 'show', INPUT 27100, c-lbl-liter-confirma-a-execucao-deste-bota + '~~' + 
                                                  c-lbl-liter-a-confirmacao-ira-eliminar-os).
        IF  RETURN-VALUE = 'YES' THEN
            ASSIGN l-gera = YES.
        ELSE
            ASSIGN l-gera = NO.

    END.
    ELSE
        ASSIGN l-gera = YES.

    IF  l-gera THEN DO:
        IF NOT valid-handle(h-acomp) THEN
           RUN utp/ut-acomp PERSISTENT SET h-acomp. 
        
        RUN pi-inicializar IN h-acomp ("Gerando adiá‰es"). 
        RUN pi-desabilita-cancela IN h-acomp.

        IF p-geracao-automatica THEN DO:
            RUN pi-deleta-relacs IN h-bocx383 (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                               INPUT tt-decla-import.cdd-siscomex-dts).
            RUN emptyRowErrors   IN h-bocx383.
            RUN gerarAdicoes     IN h-bocx383  (INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                                INPUT tt-decla-import.cdd-siscomex-dts).    
            RUN getRowErrors     IN h-bocx383  (OUTPUT TABLE RowErrors).
        END.
        ELSE DO:
            RUN emptyRowErrors          IN h-bocx403.
            RUN pi-valida-quebra-adicao IN h-bocx403(INPUT TABLE tt-decla-import-ord).
            IF RETURN-VALUE = "NOK":U THEN
                RUN getRowErrors IN h-bocx403(OUTPUT TABLE RowErrors).
        END.
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar IN h-acomp.

        RUN pi-atualiza-pend-rat IN h-bocx383a(INPUT INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                               INPUT tt-decla-import.cdd-siscomex-dts).
    END.
    ELSE
        RETURN "NOK":U.

    IF CAN-FIND(FIRST RowErrors
                WHERE RowErrors.ErrorsubType  = "Error":U
                AND   RowErrors.ErrorType    <> "INTERNAL":U) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        RETURN "NOK":U.
    END. 

    /*busca ordens atualizadas e adiá‰es*/
    RUN pi-busca-adic.
    RUN pi-buscaOrdens.
    RUN pi-trata-gera-adic-manual (INPUT YES).
    
    RUN afterDisplayFields IN THIS-PROCEDURE.
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-GeraDeclaImportOrdTrib wMaintenance 
PROCEDURE pi-GeraDeclaImportOrdTrib :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-decla-import-ord-trib.

    FOR EACH tt-decla-import-ord-trib NO-LOCK:
    
        empty temp-table tt-decla-import-ord-trib-aux.
        create tt-decla-import-ord-trib-aux.
        buffer-copy tt-decla-import-ord-trib to tt-decla-import-ord-trib-aux.

        RUN openQueryStatic  IN h-bocx00507 (INPUT "Main":U) no-error.
        RUN emptyRowErrors   IN h-bocx00507.
        RUN emptyRowObject   IN h-bocx00507.
        RUN goToKey          IN h-bocx00507 (INPUT tt-decla-import-ord-trib.num-di-ems,      
                                             INPUT tt-decla-import-ord-trib.num-ordem,       
                                             INPUT tt-decla-import-ord-trib.num-parcela,     
                                             INPUT tt-decla-import-ord-trib.cdd-siscomex-dts,
                                             INPUT tt-decla-import-ord-trib.nom-trib,  
                                             INPUT tt-decla-import-ord-trib.cod-campo).
        
        IF  RETURN-VALUE = "NOK":U THEN DO:
            RUN setRecord    IN h-bocx00507 (INPUT TABLE tt-decla-import-ord-trib-aux).
            RUN createRecord IN h-bocx00507.
        END.
        ELSE DO:
            RUN setRecord    IN h-bocx00507 (INPUT TABLE tt-decla-import-ord-trib-aux).
            RUN updateRecord IN h-bocx00507.
        END.
        DELETE tt-decla-import-ord-trib.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-GerarItens wMaintenance 
PROCEDURE pi-GerarItens :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

if  avail tt-decla-import then do:
    empty temp-table tt-decla-import-embarq.
    empty temp-table RowErrors.
    RUN setConstraintByDI IN h-bocx407 (INPUT tt-decla-import.num-di-ems,
                                        INPUT tt-decla-import.cdd-siscomex-dts).
    RUN openQueryStatic   IN h-bocx407 (INPUT "ByDI":U).
    RUN getBatchRecords   IN h-bocx407 (INPUT ?, INPUT ?, INPUT 99999, OUTPUT iRowsReturned, OUTPUT TABLE tt-decla-import-embarq).
    RUN emptyRowErrors    IN h-bocx383.
    RUN retornaRegistros  IN {&hDBOTable} (input table tt-decla-import-embarq, output table tt-decla-import-ord, OUTPUT TABLE tt-decla-import-ord-trib).
    
    if  can-find(first tt-decla-import-ord) then do:
        enable  btAlterar btExcluir btGerarAdic btInformAdic with frame fPage1.
            
        for each tt-decla-import-ord:
            empty temp-table tt-decla-import-ord-aux.
            create tt-decla-import-ord-aux.
            buffer-copy tt-decla-import-ord to tt-decla-import-ord-aux.
            RUN emptyRowErrors IN h-bocx404.
            RUN emptyRowObject IN h-bocx404.

            /*i-tipo-geracao = parametro da tela im0410e*/
            IF i-tipo-geracao = 1 THEN DO:
                /*apenas cria as ordens que ainda n∆o foram integradas com a di*/
                RUN goToKey        IN h-bocx404 (INPUT tt-decla-import-ord-aux.num-di-ems,
                                                 INPUT tt-decla-import-ord-aux.num-ordem,
                                                 INPUT tt-decla-import-ord-aux.num-parcela,
                                                 INPUT tt-decla-import-ord-aux.cdd-siscomex-dts).
                IF RETURN-VALUE = "NOK" THEN DO:
                    RUN setRecord      IN h-bocx404 (INPUT TABLE tt-decla-import-ord-aux).
                    RUN createRecord   IN h-bocx404.
                    if  return-value = "NOK":U then DO:
                        RUN getRowErrors IN h-bocx404(OUTPUT TABLE RowErrors APPEND).
                    end. /* if  return-value = "NOK":U */
                END.
            END.
            ELSE DO:
                RUN setRecord      IN h-bocx404 (INPUT TABLE tt-decla-import-ord-aux).
                RUN createRecord   IN h-bocx404.
                if  return-value = "NOK":U then DO:
                    RUN getRowErrors IN h-bocx404(OUTPUT TABLE RowErrors append).
    
                end. /* if  return-value = "NOK":U */
            END.
        end.

        if can-find(first RowErrors
                    where RowErrors.ErrorType <> "INTERNAL") then do:
            
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-finalizar IN h-acomp.
            
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
            
        end.
        else do:           
            /*busca ordens atualizadas e adiá‰es*/
            /* Reforma Tribut†ria */
            IF l-nt2024002 THEN
               RUN pi-GeraDeclaImportOrdTrib (INPUT TABLE tt-decla-import-ord-trib).
            
            RUN pi-busca-adic.
            RUN pi-buscaOrdens.
        end.

    end. /* if  avail tt-decla-import-ord */
    else disable btAlterar btExcluir btGerarAdic btInformAdic btLimpaAdic bt-can bt-sav with frame fPage1.

    RELEASE decla-import.
    RELEASE decla-import-adic.
    RELEASE decla-import-ord.
    RELEASE decla-import-adic-itens.
    RELEASE despes-decla-import.
    RELEASE despes-adic.
    RELEASE decla-import-cotac.

end. /* if  avail tt-decla-import */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-param-ativo wMaintenance 
PROCEDURE pi-seta-param-ativo :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-param-ativo AS LOGICAL NO-UNDO.

    ASSIGN l-param-ativo = p-param-ativo.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-gera-adic-manual wMaintenance 
PROCEDURE pi-trata-gera-adic-manual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-habilita AS LOGICAL NO-UNDO.

    ASSIGN tt-decla-import-ord.num-adic:READ-ONLY IN BROWSE brSon1 = p-habilita
           tt-decla-import-ord.num-seq :READ-ONLY IN BROWSE brSon1 = p-habilita.

    IF p-habilita THEN DO:
        DISABLE bt-can
                bt-sav WITH FRAME fPage1.

        IF CAN-FIND(FIRST tt-decla-import-ord) THEN
            ENABLE btGeraItens btAlterar btExcluir btGerarAdic WITH FRAME fPage1.
        ELSE
            DISABLE btAlterar btExcluir btGerarAdic WITH FRAME fPage1.

    END.
    ELSE 
        ENABLE bt-can
               bt-sav WITH FRAME fPage1.

    IF CAN-FIND(FIRST tt-decla-import-ord) THEN
        ENABLE btInformAdic WITH FRAME fPage1.
    ELSE
        DISABLE btInformAdic WITH FRAME fPage1.

    DISABLE btLimpaAdic WITH FRAME fPage1.


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

    /*--- Atualiza browse filho mas somente da pˇgina iRepositionPageNumber ---*/
    CASE pPageNumber:
        WHEN 1 THEN DO:
            RUN pi-buscaOrdens.
        END.
        WHEN 2 THEN DO:
            RUN pi-busca-adic.
        END.
    END CASE.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaTipoGeracao wMaintenance 
PROCEDURE setaTipoGeracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-tipo-geracao AS INTEGER NO-UNDO.

ASSIGN i-tipo-geracao = p-tipo-geracao.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnClassFis wMaintenance 
FUNCTION fnClassFis RETURNS CHARACTER
  ( i-num-ordem as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var c-classfis like item.class-fiscal no-undo.

    run retornaClassFisc in h-bocx404 (input i-num-ordem, output c-classfis).

    return c-classfis.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wMaintenance 
FUNCTION fnDescItem RETURNS CHARACTER
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnProcImp wMaintenance 
FUNCTION fnProcImp RETURNS CHARACTER
  ( i-num-di as integer, d-cdd-siscomex-dts AS DECIMAL, cCod-Embarq AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var cProcess like processo-imp.nr-proc-imp no-undo.

    RUN retornaProcesso IN h-bocx404 (INPUT i-num-di, INPUT cCod-Embarq, INPUT d-cdd-siscomex-dts, OUTPUT cProcess).
    RETURN cProcess.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUN wMaintenance 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUN-NCM wMaintenance 
FUNCTION fnUN-NCM RETURNS CHARACTER
  ( pnum-di-ems AS INTEGER, pnum-adic AS INTEGER, pcdd-siscomex-dts AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR cDesc AS CHAR NO-UNDO.

    IF VALID-HANDLE(h-bocx403) THEN RUN piRetornaUnidadeNCM IN h-bocx403(INPUT pnum-di-ems, INPUT pnum-adic, INPUT pcdd-siscomex-dts, OUTPUT cDesc).
    RETURN cDesc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

