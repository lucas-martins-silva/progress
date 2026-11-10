&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i IM7000G 2.00.00.002 } /*** "010002" 03/02/2026 09:09:06 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM7000G MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM7000G
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Itens

&GLOBAL-DEFINE First          NO
&GLOBAL-DEFINE Prev           NO
&GLOBAL-DEFINE Next           NO
&GLOBAL-DEFINE Last           NO
&GLOBAL-DEFINE GoTo           NO
&GLOBAL-DEFINE Search         NO

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

&GLOBAL-DEFINE page0KeyFields i-num-duimp-dts c-cod-estabel da-data-duimp c-cod-duimp-siscomex i-num-versao
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    

&GLOBAL-DEFINE page1Widgets   rs-order-brSon1

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VAR gr-duimp-siscomex AS ROWID NO-UNDO.

/* Local Variable Definitions ---                                       */
define variable c-unid-med  as character no-undo.
define variable c-desc-item as character format 'x(40)' no-undo.
define variable i-cont      as integer no-undo.
DEFINE VARIABLE c-return    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-abrev  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie-docto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro-docto   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-oper    AS CHARACTER   NO-UNDO.
define variable c-class-fiscal like item.class-fiscal no-undo.
define variable c-nr-proc-imp  like processo-imp.nr-proc-imp no-undo.

/* Local Variable Definitions (DBOs Handles) --- */
define variable {&hDBOTable}  as handle  no-undo.
define variable h-bocx402     as handle  no-undo.
define variable h-bocx403     as handle  no-undo.
define variable h-bocx404     as handle  no-undo.
define variable h-im7000e     as handle  no-undo.
define variable h-im0410e     as handle  no-undo.
DEFINE VARIABLE h-im0400d     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx407     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx383a    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00487   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00488   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx00507   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin172     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad098     AS HANDLE NO-UNDO.

define variable iRowsReturned as integer no-undo.
define variable i-conta-reg   as integer no-undo.
DEFINE VARIABLE l-encontrou   AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE tt-ordem-auxiliar NO-UNDO
    FIELD num-di-ems  LIKE decla-import-ord.num-di-ems
    FIELD num-ordem   LIKE decla-import-ord.num-ordem
    FIELD num-parcela LIKE decla-import-ord.num-parcela
    FIELD num-seq     AS   INTEGER
    FIELD cdd-siscomex-dts LIKE decla-import-ord.cdd-siscomex-dts.

DEFINE TEMP-TABLE tt-decla-import-ord-class NO-UNDO
    FIELD num-ordem    LIKE decla-import-ord.num-ordem
    FIELD class-fiscal LIKE item.class-fiscal.

DEF VAR c-descUN-NCM AS CHAR NO-UNDO.
DEF VAR l-param-ativo AS LOGICAL NO-UNDO.

DEFINE VARIABLE l-nt2024002         AS LOGICAL     NO-UNDO.

/* Reforma Tribut ria */
ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-nt2024002":U AND funcao.ativo).
                              
{cxbo/bocx00487.i tt-duimp-siscomex}
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
tt-decla-import-ord-class

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-decla-import-ord.num-adic tt-decla-import-ord.num-ordem tt-decla-import-ord.num-parcela tt-decla-import-ord.cod-item tt-decla-import-ord.qtd-item fnUN(tt-decla-import-ord.cod-item) @ c-unid-med tt-decla-import-ord-class.class-fiscal tt-decla-import-ord.cod-embarq fnProcImp(tt-decla-import-ord.num-di-ems, tt-decla-import-ord.cod-embarq, tt-decla-import-ord.cdd-siscomex-dts) @ c-nr-proc-imp fnDescItem(tt-decla-import-ord.cod-item) @ c-desc-item fnNomeAbrev(tt-decla-import-ord.cdn-fornec) @ c-nome-abrev fnSerieDocto(tt-decla-import-ord.num-ordem, tt-decla-import-ord.num-parcela) @ c-serie-docto fnNroDocto(tt-decla-import-ord.num-ordem, tt-decla-import-ord.num-parcela) @ c-nro-docto fnNatOper(tt-decla-import-ord.num-ordem, tt-decla-import-ord.num-parcela) @ c-nat-oper   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define OPEN-QUERY-brSon1 IF rs-order-brSon1:SCREEN-VALUE IN FRAME fPage1 = '1':U /* Por Seq */ THEN      OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-ord, ~
                                       FIRST tt-decla-import-ord-class                                 WHERE tt-decla-import-ord-class.num-ordem = tt-decla-import-ord.num-ordem NO-LOCK                                 BY tt-decla-import-ord.num-adic                                 BY tt-decla-import-ord.num-seq. ELSE /* Por Classifica‡Æo Fiscal */     OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-ord, ~
                                       FIRST tt-decla-import-ord-class                                 WHERE tt-decla-import-ord-class.num-ordem = tt-decla-import-ord.num-ordem NO-LOCK                                 BY tt-decla-import-ord-class.class-fiscal                                 BY tt-decla-import-ord.num-adic                                 BY tt-decla-import-ord.num-seq.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-decla-import-ord ~
tt-decla-import-ord-class
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-decla-import-ord
&Scoped-define SECOND-TABLE-IN-QUERY-brSon1 tt-decla-import-ord-class


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
i-num-duimp-dts c-cod-duimp-siscomex i-num-versao c-cod-estabel ~
da-data-duimp 
&Scoped-Define DISPLAYED-OBJECTS i-num-duimp-dts c-cod-duimp-siscomex ~
i-num-versao c-cod-estabel da-data-duimp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnClassFis wMaintenance 
FUNCTION fnClassFis RETURNS CHARACTER
  ( input c-it-codigo as character)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wMaintenance 
FUNCTION fnDescItem RETURNS CHARACTER
  ( c-cod-item as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNatOper wMaintenance 
FUNCTION fnNatOper RETURNS CHARACTER
  ( INPUT c-cod-estab  AS INTEGER,
    INPUT c-cod-embarq AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeAbrev wMaintenance 
FUNCTION fnNomeAbrev RETURNS CHARACTER
  ( INPUT cod-emitente AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNroDocto wMaintenance 
FUNCTION fnNroDocto RETURNS CHARACTER
  ( INPUT c-numero-ordem AS INTEGER, INPUT c-parcela AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnProcImp wMaintenance 
FUNCTION fnProcImp RETURNS CHARACTER
  ( i-num-di as integer, cCod-Embarq AS CHAR, d-Cdd-Siscomex-Dts AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSerieDocto wMaintenance 
FUNCTION fnSerieDocto RETURNS CHARACTER
  ( INPUT c-numero-ordem AS INTEGER, INPUT c-parcela AS INTEGER)  FORWARD.

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

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-sea":U
     IMAGE-INSENSITIVE FILE "image/ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE c-cod-duimp-siscomex AS CHARACTER FORMAT "x(15)" 
     LABEL "DUIMP Siscomex" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE da-data-duimp AS DATE FORMAT "99/99/9999" 
     LABEL "Data DUIMP" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-num-duimp-dts AS DECIMAL FORMAT ">>>>>>>>>>>>>>>9" INITIAL 0 
     LABEL "N£mero Interno DUIMP" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE i-num-versao AS INTEGER FORMAT "9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAlterar 
     LABEL "Alterar" 
     SIZE 12.57 BY 1.

DEFINE BUTTON btExcluir 
     LABEL "Excluir" 
     SIZE 12.57 BY 1.

DEFINE BUTTON btGeraItens 
     LABEL "Gera Itens" 
     SIZE 12.57 BY 1.

DEFINE VARIABLE rs-order-brSon1 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Seq", 1,
"Classifica‡Æo Fiscal", 2
     SIZE 32.14 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.13.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-decla-import-ord, 
      tt-decla-import-ord-class SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMaintenance _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      tt-decla-import-ord.num-adic COLUMN-LABEL "Seq" FORMAT "999"
      tt-decla-import-ord.num-ordem COLUMN-LABEL "Ordem de Compra"
      tt-decla-import-ord.num-parcela COLUMN-LABEL "Parc" 
      tt-decla-import-ord.cod-item 
      tt-decla-import-ord.qtd-item COLUMN-LABEL "Nossa Qtde" 
      fnUN(tt-decla-import-ord.cod-item) @ c-unid-med COLUMN-LABEL "UN" FORMAT "x(20)":U
      tt-decla-import-ord-class.class-fiscal COLUMN-LABEL "Classific Fiscal" FORMAT "x(20)":U
      tt-decla-import-ord.cod-embarq COLUMN-LABEL "Embarque"       
      fnProcImp(tt-decla-import-ord.num-di-ems, tt-decla-import-ord.cod-embarq, tt-decla-import-ord.cdd-siscomex-dts) @ c-nr-proc-imp COLUMN-LABEL "Proc Import" FORMAT "x(12)":U
      fnDescItem(tt-decla-import-ord.cod-item) @ c-desc-item COLUMN-LABEL "Descri‡Æo Item" FORMAT "x(30)":U 
      fnNomeAbrev(tt-decla-import-ord.cdn-fornec) @ c-nome-abrev COLUMN-LABEL "Nome Abreviado" FORMAT "x(12)":U 
      fnSerieDocto(tt-decla-import-ord.num-ordem, tt-decla-import-ord.num-parcela) @ c-serie-docto column-label "S‚rie" format "x(5)":U width 7
      fnNroDocto(tt-decla-import-ord.num-ordem, tt-decla-import-ord.num-parcela) @ c-nro-docto column-label "Documento" format "x(16)":U width 18
      fnNatOper(tt-decla-import-ord.num-ordem, tt-decla-import-ord.num-parcela) @ c-nat-oper column-label "Nat Opera‡Æo" format "x(06)":U width 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.25
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
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     i-num-duimp-dts AT ROW 2.83 COL 23 COLON-ALIGNED HELP
          "N£mero Interno DUIMP" WIDGET-ID 10
     c-cod-duimp-siscomex AT ROW 2.83 COL 53.57 COLON-ALIGNED HELP
          "C¢digo DI Siscomex" WIDGET-ID 4
     i-num-versao AT ROW 2.83 COL 72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     c-cod-estabel AT ROW 3.83 COL 23 COLON-ALIGNED WIDGET-ID 6
     da-data-duimp AT ROW 3.83 COL 53.57 COLON-ALIGNED HELP
          "Data da DI" WIDGET-ID 8
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
     "Ordena‡Æo" VIEW-AS TEXT
          SIZE 9.72 BY .54 AT ROW 1.04 COL 4.29
     RECT-1 AT ROW 1.21 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.38
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 rs-order-brSon1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
IF rs-order-brSon1:SCREEN-VALUE IN FRAME fPage1 = '1':U /* Por Seq */ THEN

    OPEN QUERY {&SELF-NAME} FOR EACH tt-decla-import-ord,
                                FIRST tt-decla-import-ord-class
                                WHERE tt-decla-import-ord-class.num-ordem = tt-decla-import-ord.num-ordem NO-LOCK
                                BY tt-decla-import-ord.num-adic
                                BY tt-decla-import-ord.num-seq.
ELSE /* Por Classifica‡Æo Fiscal */
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


&Scoped-define SELF-NAME btAlterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlterar wMaintenance
ON CHOOSE OF btAlterar IN FRAME fPage1 /* Alterar */
DO:
    RUN pi-carregaTTAuxiliar.
    run pi-alteraOrdens.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluir wMaintenance
ON CHOOSE OF btExcluir IN FRAME fPage1 /* Excluir */
DO: 
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-confirma-a-exclusao-2 AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Confirma_a_exclusÆo?" *}
    ASSIGN c-lbl-liter-confirma-a-exclusao-2 = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-a-confirmacao-ira-eliminar-o-r-2 AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "A_confirma‡Æo_ir _eliminar_o_registro_selecionado_de_Ordens_DUIMP._Continua?" *}
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
    
    RUN pi-inicializar IN h-acomp ("Gerando itens"). 
    RUN pi-desabilita-cancela IN h-acomp.
    
    RUN piDeletaRelacs IN {&hDBOTable} (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                        INPUT tt-duimp-siscomex.cdd-siscomex-dts).
    RUN pi-GerarItens.
    RUN pi-gera-adicoes.
    
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
        
    IF RETURN-VALUE = "NOK":U THEN 
        UNDO,LEAVE.
    ELSE
        RUN pi-atualiza-pend-rat IN h-bocx383a (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                                INPUT tt-duimp-siscomex.cdd-siscomex-dts).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:

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
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
ASSIGN c-cod-duimp-siscomex:FORMAT IN FRAME fpage0 = "x(20)".

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
    if valid-handle(h-im7000e)  then delete procedure h-im7000e.
    if valid-handle(h-im0410e)  then delete procedure h-im0410e.
    if valid-handle(h-im0400d)  then delete procedure h-im0400d.
    if valid-handle(h-bocx383a) then delete procedure h-bocx383a.
    IF VALID-HANDLE(h-bocx00487) THEN DELETE PROCEDURE h-bocx00487.
    IF VALID-HANDLE(h-bocx00488) THEN DELETE PROCEDURE h-bocx00488.
    IF VALID-HANDLE(h-bocx00507) THEN DELETE PROCEDURE h-bocx00507.
    IF VALID-HANDLE(h-boin172) THEN DELETE PROCEDURE h-boin172.
    IF VALID-HANDLE(h-boad098) THEN DELETE PROCEDURE h-boad098.
        
    ASSIGN h-bocx402 = ?
           h-bocx403 = ?
           h-bocx404 = ?
           h-bocx407 = ?
           h-im7000e = ?
           h-bocx00487 = ?
           h-boin172   = ?
           h-boad098   = ?.

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

    IF gr-duimp-siscomex <> ? THEN DO:
        RUN repositionRecord IN h-bocx00487 (INPUT gr-duimp-siscomex).        
        RUN getRecord        IN h-bocx00487 (OUTPUT TABLE tt-duimp-siscomex).        
    END.
    FOR FIRST tt-duimp-siscomex NO-LOCK: END.
    
    IF AVAIL tt-duimp-siscomex THEN DO:
       ASSIGN i-num-duimp-dts:SCREEN-VALUE      IN FRAME fPage0 = string(tt-duimp-siscomex.cod-duimp-dts)
              c-cod-duimp-siscomex:SCREEN-VALUE IN FRAME fPage0 = tt-duimp-siscomex.cod-duimp-siscomex
              i-num-versao:SCREEN-VALUE         IN FRAME fPage0 = string(tt-duimp-siscomex.num-versao)
              c-cod-estabel:SCREEN-VALUE        IN FRAME fPage0 = tt-duimp-siscomex.cod-estabel
              da-data-duimp:SCREEN-VALUE        IN FRAME fPage0 = string(DATE(tt-duimp-siscomex.dtz-reg-siscomex),"99/99/9999":U).
   
        RUN openQueryStatic IN h-bocx383 (INPUT "Main":U) NO-ERROR.
        RUN goToKey         IN h-bocx383 (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                          INPUT 99, 
                                          INPUT tt-duimp-siscomex.cdd-siscomex-dts). 
                                
        IF RETURN-VALUE = "OK":U THEN
            RUN getRecord IN h-bocx383(OUTPUT TABLE tt-decla-import).
        
        FOR FIRST tt-decla-import NO-LOCK: END.
        
        RUN pi-buscaOrdens.
            
        if  avail tt-decla-import 
        then enable  btGeraItens with frame fPage1.
        else disable btGeraItens with frame fPage1.
            
        if  avail tt-decla-import-ord
        then enable  btAlterar btExcluir with frame fPage1.
        else disable btAlterar btExcluir with frame fPage1.

        RUN pi-trata-gera-adic-manual (INPUT YES).
        
        RUN pi-altera-duimp. /* alterar di */
    END.
    
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

   enable brSon1 with frame fPage1.
       
   apply 'entry' to btGeraItens in frame fPage1.

   ASSIGN btGoTo:HIDDEN IN FRAME fPage0 = YES
          btSearch:HIDDEN IN FRAME fPage0 = YES.

   RUN pi-trata-gera-adic-manual (INPUT YES).
   RUN pi-altera-duimp. /* alterar di */
   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
    Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
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
        RUN openQueryStatic IN h-bocx404 (INPUT 'Main':U) NO-ERROR.
        
    IF NOT VALID-HANDLE (h-bocx407) THEN RUN cxbo/bocx407.p PERSISTENT SET h-bocx407. /* decla-import-embarq */

     IF NOT VALID-HANDLE (h-bocx383a) THEN DO:
        RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.
        RUN openQueryStatic IN h-bocx383a (INPUT "Main":U) NO-ERROR.
    END.
    
    IF NOT VALID-HANDLE(h-bocx00487) THEN DO:
        RUN cxbo/bocx00487.p PERSISTENT SET h-bocx00487.
    END.
    RUN openQueryStatic IN h-bocx00487 (INPUT "Main":U) NO-ERROR.
    
    IF NOT VALID-HANDLE(h-bocx00488) THEN 
        RUN cxbo/bocx00488.p PERSISTENT SET h-bocx00488.
    
    IF NOT VALID-HANDLE(h-boin172) THEN 
        RUN inbo/boin172.p PERSISTENT SET h-boin172.
        
    IF NOT VALID-HANDLE(h-boad098) THEN 
        RUN adbo/boad098.p PERSISTENT SET h-boad098.
        
    IF NOT VALID-HANDLE(h-bocx00507) THEN
        RUN cxbo/bocx00507.p PERSISTENT SET h-bocx00507.        
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-duimp wMaintenance 
PROCEDURE pi-altera-duimp :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    IF  VALID-HANDLE(h-bocx383a) AND 
        AVAIL tt-decla-import    THEN DO:
        RUN piDoctoRecebimento IN h-bocx383a(INPUT tt-decla-import.cod-di-siscomex, OUTPUT l-encontrou).
    
        IF  l-encontrou THEN DO:
            DISABLE btGeraItens btExcluir WITH FRAME fPage1.
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
            RUN imp/im7000e.w PERSISTENT SET h-im7000e (INPUT tt-decla-import-ord.r-Rowid, /* prTable  */
                                                        INPUT tt-decla-import.r-Rowid,
                                                        INPUT 'UPDATE',                    /* pcAction */
                                                        INPUT THIS-PROCEDURE,
                                                        INPUT 1).             /* phCaller */
            IF  VALID-HANDLE(h-im7000e) THEN DO:   

                FOR FIRST tt-ordem-auxiliar 
                    WHERE tt-ordem-auxiliar.num-di-ems  = tt-decla-import-ord.num-di-ems
                    AND   tt-ordem-auxiliar.num-ordem   = tt-decla-import-ord.num-ordem
                    AND   tt-ordem-auxiliar.num-parcela = tt-decla-import-ord.num-parcela
                    AND   tt-ordem-auxiliar.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts:
                    
                    run pi-seta-linha-browse in h-im7000e(input tt-ordem-auxiliar.num-seq).
                END. /* FOR FIRST tt-ordem-auxiliar */
                
                RUN initializeInterface IN h-im7000e.
                WAIT-FOR CLOSE OF h-im7000e FOCUS CURRENT-WINDOW.
            END. 
            ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
        END. /* IF  brSon1:FETCH-SELECTED-ROW(i-cont) */
    END. /* DO  i-cont = 1 TO brSon1 */
    RUN pi-buscaOrdens.


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
    
    IF AVAIL tt-duimp-siscomex THEN DO:

        RUN setConstraintByDI IN h-bocx404 (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                            INPUT tt-duimp-siscomex.cdd-siscomex-dts).
        RUN openQueryStatic   IN h-bocx404 (INPUT "ByDI":U) NO-ERROR.
        RUN getBatchRecords   IN h-bocx404 (INPUT ?, 
                                            INPUT ?, 
                                            INPUT 99999, 
                                            OUTPUT iRowsReturned, 
                                            OUTPUT TABLE tt-decla-import-ord).
                                            
        RUN pi-carregaTTClassFiscal.
                                                                                     
        {&OPEN-QUERY-brSon1}
    END.

    RETURN "OK":U.

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
            ASSIGN tt-ordem-auxiliar.num-di-ems  = tt-decla-import-ord.num-di-ems
                   tt-ordem-auxiliar.num-ordem   = tt-decla-import-ord.num-ordem
                   tt-ordem-auxiliar.num-parcela = tt-decla-import-ord.num-parcela
                   tt-ordem-auxiliar.num-seq     = i-conta-reg
                   tt-ordem-auxiliar.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts.

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
                   tt-decla-import-ord-class.class-fiscal = fnClassFis(tt-decla-import-ord.cod-item).
        END.
    END.
    
    RETURN 'OK':U.

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
                RUN emptyRowErrors IN h-bocx404.
                RUN deleteRecord   IN h-bocx404.
            END.
            
            /*Reforma Tribut ria*/
            IF l-nt2024002 THEN DO:
                RUN piDeleteRegistro IN h-bocx00507 (INPUT tt-decla-import-ord.num-di-ems,
                                                     INPUT tt-decla-import-ord.num-ordem,
                                                     INPUT tt-decla-import-ord.num-parcela,
                                                     INPUT tt-decla-import-ord.cdd-siscomex-dts).
            END.
            
            RUN pi-buscaOrdens.
            RUN pi-trata-gera-adic-manual (INPUT YES).
        END.
    END.

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
    EMPTY TEMP-TABLE RowErrors.
    
    RUN pi-deleta-relacs        IN h-bocx383 (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                              INPUT tt-duimp-siscomex.cdd-siscomex-dts).
    RUN emptyRowErrors          IN h-bocx383.
    RUN gerarItensDuimpAdic     IN h-bocx383  (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                               INPUT tt-duimp-siscomex.cdd-siscomex-dts).
    RUN getRowErrors            IN h-bocx383  (OUTPUT TABLE RowErrors).

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    RUN pi-atualiza-pend-rat IN h-bocx383a(INPUT tt-duimp-siscomex.cod-duimp-dts,
                                           INPUT tt-duimp-siscomex.cdd-siscomex-dts).

    IF CAN-FIND(FIRST RowErrors
                WHERE RowErrors.ErrorsubType  = "Error":U
                AND   RowErrors.ErrorType    <> "INTERNAL":U) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        RETURN "NOK":U.
    END. 

    /*busca ordens atualizadas e adi‡äes*/
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

if  avail tt-duimp-siscomex then do:
    empty temp-table tt-decla-import-embarq.
    empty temp-table RowErrors.
    
    RUN setConstraintByDI IN h-bocx407 (INPUT tt-duimp-siscomex.cod-duimp-dts,
                                        INPUT tt-duimp-siscomex.cdd-siscomex-dts).
    RUN openQueryStatic   IN h-bocx407 (INPUT "ByDI":U).
    RUN getBatchRecords   IN h-bocx407 (INPUT ?, INPUT ?, INPUT 99999, OUTPUT iRowsReturned, OUTPUT TABLE tt-decla-import-embarq).
    RUN emptyRowErrors    IN h-bocx383.
    RUN retornaRegistros  IN {&hDBOTable} (input table tt-decla-import-embarq, output table tt-decla-import-ord, OUTPUT TABLE tt-decla-import-ord-trib).
    
    if  can-find(first tt-decla-import-ord) then do:
        enable  btAlterar btExcluir with frame fPage1.
            
        for each tt-decla-import-ord:
            empty temp-table tt-decla-import-ord-aux.
            create tt-decla-import-ord-aux.
            buffer-copy tt-decla-import-ord to tt-decla-import-ord-aux.
            RUN emptyRowErrors IN h-bocx404.
            RUN emptyRowObject IN h-bocx404.

            
                RUN openQueryStatic IN h-bocx404 (INPUT "Main":U) NO-ERROR.
                RUN setRecord       IN h-bocx404 (INPUT TABLE tt-decla-import-ord-aux).
                RUN createRecord   IN h-bocx404.
                if  return-value = "NOK":U then DO:
                    RUN getRowErrors IN h-bocx404(OUTPUT TABLE RowErrors append).
                end. /* if  return-value = "NOK":U */
            
        END.
        if can-find(first RowErrors
                    where RowErrors.ErrorType <> "INTERNAL") then do:
            
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-finalizar IN h-acomp.
            
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
            
        end.
        else do:           
            /*busca ordens atualizadas e adi‡äes*/
            IF l-nt2024002 THEN
               RUN pi-GeraDeclaImportOrdTrib (INPUT TABLE tt-decla-import-ord-trib).
               
            RUN pi-buscaOrdens.
        end.

    end. /* if  avail tt-decla-import-ord */
    else disable btAlterar btExcluir with frame fPage1.

    RELEASE decla-import.
    RELEASE decla-import-adic.
    RELEASE decla-import-ord.
    RELEASE decla-import-adic-itens.
    RELEASE despes-decla-import.
    RELEASE despes-adic.
    RELEASE decla-import-cotac.
    RELEASE decla-import-ord-trib.

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

    IF p-habilita THEN DO:
        IF CAN-FIND(FIRST tt-decla-import-ord) THEN
            ENABLE btGeraItens btAlterar btExcluir WITH FRAME fPage1.
        ELSE
            DISABLE btAlterar btExcluir WITH FRAME fPage1.

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
        WHEN 1 THEN DO:
            RUN pi-buscaOrdens.
        END.
    END CASE.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnClassFis wMaintenance 
FUNCTION fnClassFis RETURNS CHARACTER
  ( input c-it-codigo as character) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   ASSIGN c-class-fiscal = "":U.
   
   RUN findCodigo IN h-boin172 (INPUT c-it-codigo, OUTPUT c-return).
   IF  c-return = "":U THEN
       RUN getCharField IN h-boin172 (input "class-fiscal", OUTPUT c-class-fiscal).

    return c-class-fiscal.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNatOper wMaintenance 
FUNCTION fnNatOper RETURNS CHARACTER
  ( INPUT c-numero-ordem AS INTEGER,
    INPUT c-parcela AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RUN piRetornaNFDuimp IN h-bocx00488 (INPUT c-numero-ordem,
                                         INPUT c-parcela,
                                         OUTPUT c-serie-docto,
                                         OUTPUT c-nro-docto,
                                         OUTPUT c-nat-oper).
                                         
  RETURN c-nat-oper.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeAbrev wMaintenance 
FUNCTION fnNomeAbrev RETURNS CHARACTER
  ( INPUT cod-emitente AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RUN findEmitente2 IN h-boad098 (INPUT cod-emitente,
                                    OUTPUT c-return).
    IF c-return = "" THEN
        RUN getCharField IN h-boad098 (INPUT "nome-abrev", OUTPUT c-nome-abrev).

  RETURN c-nome-abrev.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNroDocto wMaintenance 
FUNCTION fnNroDocto RETURNS CHARACTER
  ( INPUT c-numero-ordem AS INTEGER, INPUT c-parcela AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RUN piRetornaNFDuimp IN h-bocx00488 (INPUT c-numero-ordem,
                                         INPUT c-parcela,
                                         OUTPUT c-serie-docto,
                                         OUTPUT c-nro-docto,
                                         OUTPUT c-nat-oper).


  RETURN c-nro-docto.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnProcImp wMaintenance 
FUNCTION fnProcImp RETURNS CHARACTER
  ( i-num-di as integer, cCod-Embarq AS CHAR, d-Cdd-Siscomex-Dts AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var cProcess like processo-imp.nr-proc-imp no-undo.

    RUN retornaProcesso IN h-bocx404 (INPUT i-num-di, INPUT cCod-Embarq, INPUT d-Cdd-Siscomex-Dts, OUTPUT cProcess).
    RETURN cProcess.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSerieDocto wMaintenance 
FUNCTION fnSerieDocto RETURNS CHARACTER
  ( INPUT c-numero-ordem AS INTEGER, INPUT c-parcela AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RUN piRetornaNFDuimp IN h-bocx00488 (INPUT c-numero-ordem,
                                         INPUT c-parcela,
                                         OUTPUT c-serie-docto,
                                         OUTPUT c-nro-docto,
                                         OUTPUT c-nat-oper).
                                         
  RETURN c-serie-docto.   /* Function return value. */

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

    IF VALID-HANDLE(h-bocx403) THEN 
        RUN piRetornaUnidadeNCM IN h-bocx403(INPUT pnum-di-ems, INPUT pnum-adic, INPUT pcdd-siscomex-dts, OUTPUT cDesc).
    
    RETURN cDesc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



