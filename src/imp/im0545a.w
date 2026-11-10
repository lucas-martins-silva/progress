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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0545A 2.00.00.026 } /*** 010026 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0545a MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0545A
&GLOBAL-DEFINE Version        2.00.00.025
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FramesHandle     STRING(FRAME fPage1:HANDLE)
&GLOBAL-DEFINE FolderLabels     Ordens

&GLOBAL-DEFINE ttParent         tt-embarque-imp
&GLOBAL-DEFINE hDBOParent       h-bocx220
&GLOBAL-DEFINE DBOParentTable   embarque-imp

&GLOBAL-DEFINE ttSon1           tt-ordens-embarque
&GLOBAL-DEFINE hDBOSon1         h-bocx225
&GLOBAL-DEFINE DBOSon1Table     ordens-embarque

&GLOBAL-DEFINE page0Fields      tt-embarque-imp.cod-estabel ~
                                tt-embarque-imp.embarque
&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      

&global-define VALUE-CHANGED1    yes
/* Parameters Definitions ---                                           */
def input param pcod-estabel as char no-undo.
def input param pembarque as char no-undo.

DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.

def var h-boin274  as handle no-undo.
def var h-bocx225d as handle no-undo.
def var h-bocx140  as handle no-undo.
def var h-boad039  as handle no-undo.
def var h-bocx085  as handle no-undo.
def var h-bocx110  as handle no-undo.
def var h-boin082  as handle no-undo.
def var h-boin172  as handle no-undo.
DEF VAR h-boun005  AS HANDLE NO-UNDO.
DEF VAR h-bocx351  as handle no-undo.

def var rowsreturn as integer no-undo.

def var iValor like cotacao-item.preco-unit no-undo.
def var i-cod-cond-pag  like cond-pagto.cod-cond-pag no-undo.
def var c-cond-pagto1   like cond-pagto.descricao    no-undo.
def var i-cod-cond-pag1 like cond-pagto.cod-cond-pag no-undo.
def var c-cond-pagto    like cond-pagto.descricao    no-undo.
def var c-desc-item     as CHAR FORMAT "x(60)" no-undo.
DEF VAR c-return-ordem-compr AS CHAR NO-UNDO.
DEF VAR c-return-item        AS CHAR NO-UNDO.

def var c-pto-contr-base  like pto-contr.descricao     no-undo.
def var i-pto-contr-base like pto-contr.cod-pto-contr no-undo.
def var c-pto-contr-base1  like pto-contr.descricao     no-undo.
def var i-pto-contr-base1 like pto-contr.cod-pto-contr no-undo.
def var r-chave   as rowid  no-undo.
def var c-return  as char   no-undo.
def var c-char-1  as char   no-undo.
def var c-it-codigo like item.it-codigo no-undo.
def var c-it-codigo1 like item.it-codigo no-undo.
def var i-num-pedido like pedido-compr.num-pedido no-undo.
def var i-num-pedido1 like pedido-compr.num-pedido no-undo.
def var i-mo-codigo like cotacao-item.mo-codigo no-undo.
def var i-mo-codigo1 like cotacao-item.mo-codigo no-undo.
def var de-preco-unit like cotacao-item.preco-unit no-undo.
def var c-un-nosso like item.un no-undo.
def var c-un-fornec like cotacao-item.un no-undo.
def var de-pre-unit-for like cotacao-item.pre-unit-for no-undo.
def var de-aliquota-ipi like cotacao-item.aliquota-ipi no-undo.
DEF VAR c-desc-moeda    AS CHAR NO-UNDO.

&if "{&bf_mat_versao_ems}" >= "2.062" &then
DEF VAR iLog-necessita-Li LIKE ITEM.log-necessita-li              NO-UNDO.
DEF VAR iLicenca-import   LIKE licenciam-import-oc.licenca-import NO-UNDO.
&endif

def var de-peso-liq-tot   AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" no-undo.
def var de-peso-bruto-tot AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" no-undo.
def var de-cubagem-tot    AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99999" no-undo.

def var v-peso-liq-emb   AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" no-undo.
def var v-peso-bruto-emb AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" no-undo.
def var v-cubagem-emb    AS DECIMAL FORMAT ">>>>>,>>>,>>9.999999" no-undo.
    
{cdp/cd4300.i3}
{ccp/cc9019.i50}

DEFINE VARIABLE c-licenca-import AS CHARACTER FORMAT "X(20)":U NO-UNDO.
DEFINE VARIABLE l-necessita-li   AS LOGICAL                    NO-UNDO.

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
&Scoped-define INTERNAL-TABLES tt-ordens-embarque

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-ordens-embarque.numero-ordem ~
tt-ordens-embarque.parcela tt-ordens-embarque.nr-proc-imp ~
fnPedido() @ i-num-pedido fnItem() @ c-it-codigo ~
tt-ordens-embarque.quantidade fnUnItem () @ c-un-nosso ~
tt-ordens-embarque.qt-do-forn fnUnFornec () @ c-un-fornec ~
tt-ordens-embarque.identific-container fnDescItem() @ c-desc-item ~
fnValor() @ iValor fnPesoLiq() @ de-peso-liq-tot ~
fnPesoBruto() @ de-peso-bruto-tot fnCubagem() @ de-cubagem-tot ~
fn-moeda() @ i-mo-codigo fn-descmoeda() @ c-desc-moeda ~
fn-cond-pagto() @ i-cod-cond-pag ~
fn-desc-cond-pagto(fn-cond-pagto()) @ c-cond-pagto ~
fn-pto-contr-base() @ i-pto-contr-base ~
fn-desc-pto-contr-base(fn-pto-contr-base()) @ c-pto-contr-base ~
fn-necessita-li() @ l-necessita-li fn-licenca-import() @ c-licenca-import 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-ordens-embarque NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-ordens-embarque NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-ordens-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-ordens-embarque


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define ENABLED-TABLES tt-embarque-imp
&Scoped-define FIRST-ENABLED-TABLE tt-embarque-imp
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define DISPLAYED-TABLES tt-embarque-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-embarque-imp


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-pto-contr-base wMasterDetail 
FUNCTION fn-desc-pto-contr-base RETURNS CHARACTER
    ( input p-pto-contr-base as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-descmoeda wMasterDetail 
FUNCTION fn-descmoeda RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-licenca-import wMasterDetail 
FUNCTION fn-licenca-import RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-moeda wMasterDetail 
FUNCTION fn-moeda RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-necessita-li wMasterDetail 
FUNCTION fn-necessita-li RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-pto-contr-base wMasterDetail 
FUNCTION fn-pto-contr-base RETURNS INTEGER
    ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCubagem wMasterDetail 
FUNCTION fnCubagem RETURNS DECIMAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wMasterDetail 
FUNCTION fnDescItem RETURNS CHARACTER FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
    ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNecessitaLi wMasterDetail 
FUNCTION fnNecessitaLi RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNumeroLi wMasterDetail 
FUNCTION fnNumeroLi RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPedido wMasterDetail 
FUNCTION fnPedido RETURNS integer
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPesoBruto wMasterDetail 
FUNCTION fnPesoBruto RETURNS DECIMAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPesoLiq wMasterDetail 
FUNCTION fnPesoLiq RETURNS DECIMAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnFornec wMasterDetail 
FUNCTION fnUnFornec RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnItem wMasterDetail 
FUNCTION fnUnItem RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnValor wMasterDetail 
FUNCTION fnValor RETURNS DECIMAL
  ( )  FORWARD.

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
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image~\im-joi":U
     IMAGE-INSENSITIVE FILE "image~\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image~\im-pri":U
     IMAGE-INSENSITIVE FILE "image~\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 93.29 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 93.72 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btItens 
     LABEL "&Itens" 
     SIZE 9 BY 1.

DEFINE VARIABLE de-cubagem-tot-emb AS DECIMAL FORMAT ">>>>>,>>>,>>9.999999":U INITIAL ? 
     LABEL "Cubagem Emb" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .79 NO-UNDO.

DEFINE VARIABLE de-peso-bruto-tot-emb AS DECIMAL FORMAT ">>>>>,>>>,>>9.999999":U INITIAL ? 
     LABEL "Peso Bruto Emb" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .79 NO-UNDO.

DEFINE VARIABLE de-peso-liq-tot-emb AS DECIMAL FORMAT ">>>>>,>>>,>>9.999999":U INITIAL ? 
     LABEL "Peso L¡q Emb" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .79 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-ordens-embarque SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 DISPLAY
      tt-ordens-embarque.numero-ordem FORMAT ">>>>>9,99":U WIDTH 8.72
      tt-ordens-embarque.parcela FORMAT ">>>>9":U
      tt-ordens-embarque.nr-proc-imp FORMAT "X(12)":U
      fnPedido() @ i-num-pedido COLUMN-LABEL "Pedido"
      fnItem() @ c-it-codigo COLUMN-LABEL "Item"
      tt-ordens-embarque.quantidade FORMAT ">>>>>,>>9.9999":U
      fnUnItem () @ c-un-nosso WIDTH 8.57
      tt-ordens-embarque.qt-do-forn COLUMN-LABEL "Qtde" FORMAT ">>>>>,>>9.9999":U
      fnUnFornec () @ c-un-fornec COLUMN-LABEL "Un Fornec" WIDTH 8.57
      tt-ordens-embarque.identific-container FORMAT "X(20)":U
      fnDescItem() @ c-desc-item COLUMN-LABEL "Descri‡Æo" FORMAT "x(60)":U
      fnValor() @ iValor COLUMN-LABEL "Valor Total"
      fnPesoLiq() @ de-peso-liq-tot COLUMN-LABEL "Peso Liq Total" FORMAT ">>>>>,>>>,>>9.999999":U
      fnPesoBruto() @ de-peso-bruto-tot COLUMN-LABEL "Peso Bruto Total" FORMAT ">>>>>,>>>,>>9.999999":U
      fnCubagem() @ de-cubagem-tot COLUMN-LABEL "Cubagem Total" FORMAT ">>>>>>,>>>,>>9.99999":U
      fn-moeda() @ i-mo-codigo
      fn-descmoeda() @ c-desc-moeda COLUMN-LABEL "Descri‡Æo" FORMAT "x(12)":U
      fn-cond-pagto() @ i-cod-cond-pag
      fn-desc-cond-pagto(fn-cond-pagto()) @ c-cond-pagto
      fn-pto-contr-base() @ i-pto-contr-base
      fn-desc-pto-contr-base(fn-pto-contr-base()) @ c-pto-contr-base
      fn-necessita-li() @ l-necessita-li COLUMN-LABEL "Necessita LI" FORMAT "Sim/NÆo":U
      fn-licenca-import() @ c-licenca-import COLUMN-LABEL "Nr LI" FORMAT "X(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 91 BY 5.96
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btQueryJoins AT ROW 1.21 COL 77.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.21 COL 81.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.21 COL 85.57 HELP
          "Sair"
     btHelp AT ROW 1.21 COL 89.57 HELP
          "Ajuda"
     tt-embarque-imp.cod-estabel AT ROW 2.83 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-embarque-imp.embarque AT ROW 3.83 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     rtParent AT ROW 2.67 COL 1.29
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 94.14 BY 13.25
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.08 COL 1.43
     btItens AT ROW 7.13 COL 1.43
     de-peso-liq-tot-emb AT ROW 7.25 COL 19.14 COLON-ALIGNED
     de-peso-bruto-tot-emb AT ROW 7.25 COL 47.29 COLON-ALIGNED
     de-cubagem-tot-emb AT ROW 7.25 COL 74.43 COLON-ALIGNED
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.14 ROW 6.38
         SIZE 91.72 BY 7.33
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
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 13.33
         WIDTH              = 94.43
         MAX-HEIGHT         = 21.21
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.21
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
     _TblList          = "Temp-Tables.tt-ordens-embarque"
     _FldNameList[1]   > Temp-Tables.tt-ordens-embarque.numero-ordem
"numero-ordem" ? ">>>>>9,99" "integer" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" ""
     _FldNameList[2]   = Temp-Tables.tt-ordens-embarque.parcela
     _FldNameList[3]   = Temp-Tables.tt-ordens-embarque.nr-proc-imp
     _FldNameList[4]   > "_<CALC>"
"fnPedido() @ i-num-pedido" "Pedido" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[5]   > "_<CALC>"
"fnItem() @ c-it-codigo" "Item" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[6]   = Temp-Tables.tt-ordens-embarque.quantidade
     _FldNameList[7]   > "_<CALC>"
"fnUnItem () @ c-un-nosso" ? ? ? ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" ""
     _FldNameList[8]   > Temp-Tables.tt-ordens-embarque.qt-do-forn
"qt-do-forn" "Qtde" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[9]   > "_<CALC>"
"fnUnFornec () @ c-un-fornec" "Un Fornec" ? ? ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" ""
     _FldNameList[10]   = Temp-Tables.tt-ordens-embarque.identific-container
     _FldNameList[11]   > "_<CALC>"
"fnDescItem() @ c-desc-item" "Descri‡Æo" "x(60)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[12]   > "_<CALC>"
"fnValor() @ iValor" "Valor Total" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[13]   > "_<CALC>"
"fnPesoLiq() @ de-peso-liq-tot" "Peso Liq Total" ">>>>>,>>>,>>9.999999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[14]   > "_<CALC>"
"fnPesoBruto() @ de-peso-bruto-tot" "Peso Bruto Total" ">>>>>,>>>,>>9.999999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[15]   > "_<CALC>"
"fnCubagem() @ de-cubagem-tot" "Cubagem Total" ">>>>>>,>>>,>>9.99999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[16]   > "_<CALC>"
"fn-moeda() @ i-mo-codigo" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[17]   > "_<CALC>"
"fn-descmoeda() @ c-desc-moeda" "Descri‡Æo" "x(12)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[18]   > "_<CALC>"
"fn-cond-pagto() @ i-cod-cond-pag" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[19]   > "_<CALC>"
"fn-desc-cond-pagto(fn-cond-pagto()) @ c-cond-pagto" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[20]   > "_<CALC>"
"fn-pto-contr-base() @ i-pto-contr-base" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[21]   > "_<CALC>"
"fn-desc-pto-contr-base(fn-pto-contr-base()) @ c-pto-contr-base" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[22]   > "_<CALC>"
"fn-necessita-li() @ l-necessita-li" "Necessita LI" "Sim/NÆo" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[23]   > "_<CALC>"
"fn-licenca-import() @ c-licenca-import" "Nr LI" "X(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
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


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON VALUE-CHANGED OF brSon1 IN FRAME fPage1
DO:

  
  &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &THEN
      {masterdetail/valuechanged.i &PageNumber="1"}

      IF AVAIL tt-ordens-embarque THEN DO:
          RUN findOrdem IN h-boin274 (INPUT tt-ordens-embarque.numero-ordem,
                                      OUTPUT c-return-ordem-compr).
          IF c-return-ordem-compr = "" THEN
              RUN getcharfield IN h-boin274 ("it-codigo":U, OUTPUT c-it-codigo).
    
          RUN findcodigo IN h-boin172 (INPUT c-it-codigo,
                                       OUTPUT c-return-item).
          IF c-return-item = ""  THEN
              RUN getcharfield IN h-boin172 ("desc-item":U,
                                             OUTPUT c-desc-item).
          STATUS INPUT c-desc-item .
      END.
  &endif   
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


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btItens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btItens wMasterDetail
ON CHOOSE OF btItens IN FRAME fPage1 /* Itens */
DO:
 RUN imp/im0545b.w (input pcod-estabel, input pembarque).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/* ***************************  Main Block  *************************** */

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

    IF  VALID-HANDLE(h-bocx225d) THEN DO:
        DELETE PROCEDURE h-bocx225d.
        ASSIGN h-bocx225d = ?.
    END.

    IF  VALID-HANDLE(h-boin274) THEN DO:
        DELETE PROCEDURE h-boin274.
        ASSIGN h-boin274 = ?.
    END.

    IF  VALID-HANDLE(h-bocx140) THEN DO:
        DELETE PROCEDURE h-bocx140.
        ASSIGN h-bocx140 = ?.
    END.

    IF  VALID-HANDLE(h-bocx085) THEN DO:
        DELETE PROCEDURE h-bocx085.
        ASSIGN h-bocx085 = ?.
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

    IF  VALID-HANDLE(h-boin172) THEN DO:
        DELETE PROCEDURE h-boin172.
        ASSIGN h-boin172 = ?.
    END.

    IF  VALID-HANDLE (h-bocx351) THEN DO:
        DELETE PROCEDURE h-bocx351.
        ASSIGN h-bocx351 = ?.
    END.

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

    &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &THEN
    
        ASSIGN de-peso-liq-tot-emb:SENSITIVE   IN FRAME fPage1 = NO
               de-peso-bruto-tot-emb:SENSITIVE IN FRAME fPage1 = NO
               de-cubagem-tot-emb:SENSITIVE    IN FRAME fPage1 = NO.
    
        RUN calculaTotaisEmb in h-bocx225d (input pcod-estabel,
                                            input pembarque,
                                            output v-peso-liq-emb,
                                            output v-peso-bruto-emb,
                                            output v-cubagem-emb).

        ASSIGN tt-embarque-imp.cod-estabel:screen-value in frame fPage0 = pcod-estabel 
               tt-embarque-imp.embarque:screen-value    in frame fpage0 = pembarque   
               de-peso-liq-tot-emb:screen-value         in frame fPage1 = string(v-peso-liq-emb)
               de-peso-bruto-tot-emb:screen-value       in frame fPage1 = string(v-peso-bruto-emb)
               de-cubagem-tot-emb:screen-value          in frame fPage1 = string(v-cubagem-emb).
    &ELSE
          
        ASSIGN de-peso-liq-tot-emb:HIDDEN   IN FRAME fPage1 = YES
               de-peso-bruto-tot-emb:HIDDEN IN FRAME fPage1 = YES
               de-cubagem-tot-emb:HIDDEN    IN FRAME fPage1 = YES.
        
        assign tt-embarque-imp.cod-estabel:screen-value in frame fPage0 = pcod-estabel
               tt-embarque-imp.embarque:screen-value    in frame fpage0 = pembarque.
    
    &ENDIF
    
    find first {&ttSon1} no-error.
    if not avail {&ttSon1} then
        disable btitens with frame fPage1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
        ASSIGN brSon1:COLUMN-RESIZABLE   IN FRAME fPage1 = TRUE
               brSon1:COLUMN-MOVABLE     IN FRAME fPage1 = TRUE
               brSon1:NUM-LOCKED-COLUMNS IN FRAME fPage1 = 3.

        /* Mover coluna Item - apos coluna Parcela */
        brSon1:MOVE-COLUMN(5, 3).
    &ELSE
        ASSIGN l-necessita-li  :VISIBLE IN BROWSE brSon1 = NO
               c-licenca-import:VISIBLE IN BROWSE brSon1 = NO.
    &ENDIF
    
    RUN utp/ut-trcampos.p.

    RETURN "OK":U.

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
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:
       RUN cxbo/bocx220.p persistent set h-bocx220.
    END.  
    
    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOParent} (INPUT 2).
    &ELSE
        RUN openQueryStatic IN {&hDBOParent} (INPUT "cod-estabel":U).
    &ENDIF
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) THEN DO:
       RUN cxbo/bocx225.p persistent set h-bocx225.
    END.

    &if "{&bf_mat_versao_ems}" >= "2.062" &THEN
        if  not valid-handle(h-bocx351) 
        or  h-bocx351:type      <> "PROCEDURE":U
        or  h-bocx351:file-name <> "cxbo/bocx351.p":U then 
            run cxbo/bocx351.p persistent set h-bocx351.
    
        run openQueryStatic in h-bocx351 (input "Main":U).
    &endif
    
    RUN cxbo/bocx225d.p persistent set h-bocx225d.
    RUN inbo/boin274.p  persistent set h-boin274.
    RUN cxbo/bocx140.p  persistent set h-bocx140.
    RUN cxbo/bocx085.p  persistent set h-bocx085.
    RUN adbo/boad039.p  persistent set h-boad039.
    RUN cxbo/bocx110.p  persistent set h-bocx110.
    RUN inbo/boin082.p  persistent set h-boin082.
    run inbo/boin172.p  persistent set h-boin172.
    RUN unbo/boun005.p  PERSISTENT SET h-boun005.
    
    enable btItens 
        with frame fPage1.

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
    RUN setConstraint4 in h-bocx225 (input pembarque,
                                     input pcod-estabel).
        
    RUN OpenQuery in h-bocx225 (input 2).
    RUN findFirst in h-bocx225.
    
    RUN serverSendRows in h-bocx225 (input ?,
                                     input ?,
                                     input no,
                                     input ?,
                                     output rowsreturn,
                                     output table {&ttSon1}).
    {&OPEN-QUERY-brSon1}
    APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-pto-contr-base wMasterDetail 
FUNCTION fn-desc-pto-contr-base RETURNS CHARACTER
    ( input p-pto-contr-base as integer ) :
  
    run findCodigo in h-bocx110 (input p-pto-contr-base,
                                 output c-return).
    if c-return = "" then
        run getCharfield in h-bocx110 (input "descricao":U,
                                       output c-pto-contr-base1).  

    RETURN c-pto-contr-base1.   /* Function return value. */
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-licenca-import wMasterDetail 
FUNCTION fn-licenca-import RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    &IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
        ASSIGN c-licenca-import = "":U.

        IF  AVAIL tt-ordens-embarque THEN DO:
            RUN goToKey IN h-bocx351 (INPUT tt-ordens-embarque.numero-ordem,
                                      INPUT tt-ordens-embarque.parcela).

            IF  RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN h-bocx351 (INPUT  "licenca-import":U,
                                               OUTPUT c-licenca-import).
            END.
        END.
    &ENDIF
    
    RETURN c-licenca-import.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-necessita-li wMasterDetail 
FUNCTION fn-necessita-li RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    /* Definicao de Variaveis */
    DEFINE VARIABLE c-retorno AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-item    AS CHARACTER NO-UNDO.

    ASSIGN c-retorno      = "":U
           c-item         = "":U
           l-necessita-li = NO.

    &IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
        IF  AVAIL tt-ordens-embarque THEN DO:

            FIND FIRST param-imp NO-LOCK
                 WHERE param-imp.cod-estabel = tt-ordens-embarque.cod-estabel NO-ERROR.

            IF AVAIL param-imp AND SUBSTRING(param-imp.char-1,167,1) = "S":U THEN
                ASSIGN l-necessita-li = YES.
            ELSE IF  c-retorno = "":U THEN DO:
                RUN findOrdem IN h-boin274 (INPUT  tt-ordens-embarque.numero-ordem,
                                            OUTPUT c-retorno).
                IF c-retorno = "" THEN DO:
                    RUN getCharField IN h-boin274 (INPUT "it-codigo":U, OUTPUT c-item).
                    RUN findcodigo   IN h-boin172 (INPUT c-item       , OUTPUT c-retorno).
    
                    IF c-retorno = "":U THEN
                        RUN getLogField IN h-boin172 (INPUT  "log-necessita-li":U,
                                                      OUTPUT l-necessita-li).
                END.
            END.
        END.
    &ENDIF
    
    RETURN l-necessita-li.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-pto-contr-base wMasterDetail 
FUNCTION fn-pto-contr-base RETURNS INTEGER
    ( ) :
  
    IF AVAIL tt-ordens-embarque THEN DO:
        run findCotacaoaprovada in h-boin082 (input tt-ordens-embarque.numero-ordem,
                                              output c-return).
        if c-return = "" then do:
            run getCharfield in h-boin082 (input "char-1":U,
                                           output c-char-1).
            &if defined(bf-mat-comex) &then
                assign i-mapa-cotacao-i50  = int(substring(c-char-1,6,2))
                       c-cod-incoterm-i50  = substring(c-char-1,8,3)
                       i-cod-pto-contr-i50 = int(substring(c-char-1,11,5)).
            &else
                {cdp/cd4300.i4 "yes" c-char-1}
                {ccp/cc9019.i51 "yes"}
            &endif                                       
        end.
    END.
                                            
    RETURN i-cod-pto-contr-i50.  /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCubagem wMasterDetail 
FUNCTION fnCubagem RETURNS DECIMAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &THEN
   IF AVAIL tt-ordens-embarque THEN DO:
       ASSIGN de-cubagem-tot = &IF "{&BF_DIS_VERSAO_EMS}" >= "2.062" &THEN tt-ordens-embarque.val-cub-tot &ELSE tt-ordens-embarque.val-cub-uni * tt-ordens-embarque.quantidade &endif .
   END.
   RETURN de-cubagem-tot.
 &ENDIF

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wMasterDetail 
FUNCTION fnDescItem RETURNS CHARACTER:
  
  def var c-descricao-1 as char no-undo.
  def var c-descricao-2 as char no-undo.
  
  run FindCodigo in h-boin172 (input c-it-codigo1, output c-return).
  
  &if defined(bf-mat-comex) &then 
     if c-return = "" then do:
         run getcharfield in h-boin172 ("descricao-1", output c-descricao-1).     
         run getcharfield in h-boin172 ("descricao-2", output c-descricao-2).
         assign c-desc-item = c-descricao-1 + c-descricao-2.
     end.
  &else
     if c-return = "" then
        run getcharfield in h-boin172 ("desc-item", output c-desc-item).
  &endif

  RETURN c-desc-item.   /* Function return value. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNecessitaLi wMasterDetail 
FUNCTION fnNecessitaLi RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        run goToKey in h-boin172 (input c-it-codigo1).
                              
        if  return-value = "OK":U then do:

            run getLogField in h-boin172 (input "log-necessita-li":U,
                                          output iLog-necessita-li).
        end.

        RETURN iLog-necessita-Li.
    &endif

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNumeroLi wMasterDetail 
FUNCTION fnNumeroLi RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        assign iLicenca-import = "".

        if  avail tt-ordens-embarque then do:

           run goToKey in h-bocx351 (input tt-ordens-embarque.numero-ordem,
                                     input tt-ordens-embarque.parcela).   
           if  return-value = "OK":U then do:

               run getCharField in h-bocx351 (input "licenca-import":U,
                                              output iLicenca-import).
           end.
        end.

        return iLicenca-import.   /* Function return value. */
    &endif


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPesoBruto wMasterDetail 
FUNCTION fnPesoBruto RETURNS DECIMAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/    
    IF AVAIL tt-ordens-embarque THEN DO:
        ASSIGN de-peso-bruto-tot = &IF "{&BF_DIS_VERSAO_EMS}" >= "2.062" &THEN  tt-ordens-embarque.peso-bruto &else DEC(SUBSTR(tt-ordens-embarque.char-2,26,17)) &endif.
    END.
    ELSE
        ASSIGN de-peso-bruto-tot = 0.
    RETURN de-peso-bruto-tot.
        
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPesoLiq wMasterDetail 
FUNCTION fnPesoLiq RETURNS DECIMAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    IF AVAIL tt-ordens-embarque THEN DO:
        ASSIGN de-peso-liq-tot = &IF "{&BF_DIS_VERSAO_EMS}" >= "2.062" &THEN  tt-ordens-embarque.peso-liquido &else DEC(SUBSTR(tt-ordens-embarque.char-2,09,17)) &endif.
    END.
    ELSE
        ASSIGN de-peso-liq-tot = 0.
    RETURN de-peso-liq-tot.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnValor wMasterDetail 
FUNCTION fnValor RETURNS DECIMAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    assign de-preco-unit = 0.

    IF AVAIL tt-ordens-embarque THEN DO:
        /* Calcula pre‡o sem o IPI */
        run calculaValorOrdem in h-bocx225d (input tt-ordens-embarque.numero-ordem ,
                                             input tt-ordens-embarque.qt-do-forn,
                                             output de-preco-unit).
    END.
        
                                         
    RETURN de-preco-unit.                                         

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

