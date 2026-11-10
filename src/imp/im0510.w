&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cotacao-item-cex NO-UNDO LIKE cotacao-item-cex
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-cotacao-item-cex2 NO-UNDO LIKE cotacao-item-cex
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
{include/i-prgvrs.i IM0510 2.00.00.017 } /*** 010017 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0510 MIM}
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

{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif
/* Preprocessors Definitions ---                                      */

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

&GLOBAL-DEFINE Program          IM0510
&GLOBAL-DEFINE Version        2.00.00.017
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FramesHandle     STRING(FRAME fPage1:HANDLE)
&GLOBAL-DEFINE FolderLabels     Despesas

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE ttParent         tt-cotacao-item-cex
&GLOBAL-DEFINE hDBOParent       h-bocx085
&GLOBAL-DEFINE DBOParentTable   cotacao-item-cex

&GLOBAL-DEFINE ttSon1           tt-cotacao-item-cex2
&GLOBAL-DEFINE hDBOSon1         h-bocx0852
&GLOBAL-DEFINE DBOSon1Table     cotacao-item-cex


&GLOBAL-DEFINE page0Fields      tt-cotacao-item-cex.numero-ordem ~
                                tt-cotacao-item-cex.cod-incoterm ~
                                tt-cotacao-item-cex.cod-emitente ~
                                tt-cotacao-item-cex.seq-cotac ~
                                tt-cotacao-item-cex.cod-itiner ~
                                tt-cotacao-item-cex.it-codigo ~
                                tt-cotacao-item-cex.mapa-cotacao ~
                                tt-cotacao-item-cex.data-cotacao ~
                                i-mo-codigo ~
                                fc-desc-emitente ~
                                fc-desc-moeda ~
                                c-un ~
                                l-aprovado ~
                                de-preco-cotacao ~
                                fc-desc-itinerario ~
                                fc-desc-it-codigo
                                    
&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def new global shared var i-moeda-g      as integer initial 0 no-undo.
def new global shared var l-conv-g       as logical initial yes no-undo.
def new global shared var da-conv-g      as date format "99/99/9999" no-undo.
def new global shared var da-conv-g-aux2 as date format "99/99/9999" no-undo.

/* def new global shared var gr-cotacao-item as rowid no-undo. */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
def var h-bocx095 as handle no-undo.
def var h-boad098 as handle no-undo.
def var h-boin082 as handle no-undo.
def var h-boin172 as handle no-undo.
def var h-boad039 as handle no-undo.
def var h-boun005 as handle no-undo.
def var h-bocx110 as handle no-undo.
def var h-bocx115 as handle no-undo.
def var h-boin274 as handle no-undo.
def var c-desc-itinerario like itinerario.descricao no-undo.
DEF VAR c-desc-it-codigo  LIKE ITEM.descricao-1     NO-UNDO.
def var c-desc-emitente like emitente.nome-abrev no-undo.
def var c-desc-moeda    like moeda.descricao no-undo.
def var c-desc-despesa  like desp-imp.descricao no-undo.
def var c-desc-condicao like cond-pagto.descricao no-undo.
def var c-desc-pto-contr like pto-contr.descricao no-undo.
def var c-desc-emitente1 like emitente.nome-abrev no-undo.
def var c-desc-moeda1    like moeda.descricao no-undo.
def var c-desc-despesa1  like desp-imp.descricao no-undo.
def var c-desc-condicao1 like cond-pagto.descricao no-undo.
def var c-desc-pto-contr1 like pto-contr.descricao no-undo.
DEF VAR c-incide-vl     AS CHAR FORMAT "x(03)"     NO-UNDO.
def var c-return        as char no-undo.
def var h-mo-codigo     as handle no-undo.
def var h-seq-cotac     as handle no-undo.
def var i-numero-ordem   like ordem-compra.numero-ordem no-undo.
def var r-chave         as rowid no-undo.
def new global shared var gr-ordem-compra as rowid no-undo.
DEF NEW GLOBAL SHARED VAR gr-cotacao-item AS ROWID NO-UNDO.
DEF VAR c-recalcula   AS CHAR FORMAT "x(16)"       NO-UNDO.
DEF VAR l-inc-val-embal       LIKE desp-imp.inc-val-embal       NO-UNDO.
DEF VAR l-inc-val-seguro      LIKE desp-imp.inc-val-seguro      NO-UNDO. 
DEF VAR l-inc-val-frete       LIKE desp-imp.inc-val-frete       NO-UNDO.
DEF VAR l-inc-val-outras-desp LIKE desp-imp.inc-val-outras-desp NO-UNDO.
DEF VAR fc-desc-item-1        LIKE ITEM.descricao-1             NO-UNDO.
DEF VAR fc-desc-item-2        LIKE ITEM.descricao-2             NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-cotacao-item-cex2

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-cotacao-item-cex2.sequencia ~
tt-cotacao-item-cex2.cod-emitente-desp ~
fnEmitente(input tt-cotacao-item-cex2.cod-emitente-desp) @ c-desc-emitente1 ~
tt-cotacao-item-cex2.cod-desp ~
fnDespesa(input tt-cotacao-item-cex2.cod-desp) @ c-desc-despesa ~
tt-cotacao-item-cex2.val-desp tt-cotacao-item-cex2.mo-codigo ~
fnMoeda(input tt-cotacao-item-cex2.mo-codigo) @ c-desc-moeda1 ~
tt-cotacao-item-cex2.log-recalc-val tt-cotacao-item-cex2.cod-cond-pag ~
fnCondicao(input tt-cotacao-item-cex2.cod-cond-pag) @ c-desc-condicao1 ~
tt-cotacao-item-cex2.cod-pto-contr ~
fnPto-contr(input tt-cotacao-item-cex2.cod-pto-contr) @ c-desc-pto-contr1 ~
fnIncide-vl(input tt-cotacao-item-cex2.cod-desp) @ c-incide-vl 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-cotacao-item-cex2 NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-cotacao-item-cex2 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-cotacao-item-cex2
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-cotacao-item-cex2


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-cotacao-item-cex.numero-ordem ~
tt-cotacao-item-cex.cod-emitente tt-cotacao-item-cex.it-codigo ~
tt-cotacao-item-cex.seq-cotac tt-cotacao-item-cex.data-cotacao ~
tt-cotacao-item-cex.cod-itiner tt-cotacao-item-cex.cod-incoterm ~
tt-cotacao-item-cex.mapa-cotacao 
&Scoped-define ENABLED-TABLES tt-cotacao-item-cex
&Scoped-define FIRST-ENABLED-TABLE tt-cotacao-item-cex
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btParam btQueryJoins btReportsJoins btExit btHelp ~
fc-desc-emitente fc-desc-it-codigo c-un fc-desc-itinerario l-aprovado ~
de-preco-cotacao i-mo-codigo fc-desc-moeda 
&Scoped-Define DISPLAYED-FIELDS tt-cotacao-item-cex.numero-ordem ~
tt-cotacao-item-cex.cod-emitente tt-cotacao-item-cex.it-codigo ~
tt-cotacao-item-cex.seq-cotac tt-cotacao-item-cex.data-cotacao ~
tt-cotacao-item-cex.cod-itiner tt-cotacao-item-cex.cod-incoterm ~
tt-cotacao-item-cex.mapa-cotacao 
&Scoped-define DISPLAYED-TABLES tt-cotacao-item-cex
&Scoped-define FIRST-DISPLAYED-TABLE tt-cotacao-item-cex
&Scoped-Define DISPLAYED-OBJECTS fc-desc-emitente fc-desc-it-codigo c-un ~
fc-desc-itinerario l-aprovado de-preco-cotacao i-mo-codigo fc-desc-moeda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCondicao wMasterDetail 
FUNCTION fnCondicao RETURNS CHARACTER
    ( input p-cod-cond-pag as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDespesa wMasterDetail 
FUNCTION fnDespesa RETURNS CHARACTER
    (input p-cod-desp as integer) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEmitente wMasterDetail 
FUNCTION fnEmitente RETURNS CHARACTER
    (input p-cod-emitente as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnIncide-vl wMasterDetail 
FUNCTION fnIncide-vl RETURNS CHARACTER
    ( input p-cod-desp as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMoeda wMasterDetail 
FUNCTION fnMoeda RETURNS CHARACTER
    ( input p-mo-codigo as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPto-contr wMasterDetail 
FUNCTION fnPto-contr RETURNS CHARACTER
    ( input p-cod-pto-contr as integer )  FORWARD.

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
       MENU-ITEM miParam        LABEL "&Parƒmetros"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
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

DEFINE BUTTON btParam 
     IMAGE-UP FILE "IMAGE\im-param":U
     IMAGE-INSENSITIVE FILE "IMAGE\ii-param":U
     LABEL "Parƒmetros":L 
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

DEFINE VARIABLE c-un AS CHARACTER FORMAT "X(256)":U 
     LABEL "Un" 
     VIEW-AS FILL-IN 
     SIZE 4.72 BY .88 NO-UNDO.

DEFINE VARIABLE de-preco-cotacao AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999":U INITIAL 0 
     LABEL "Pre‡o" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fc-desc-emitente AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 38.57 BY .88 NO-UNDO.

DEFINE VARIABLE fc-desc-it-codigo AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE fc-desc-itinerario AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fc-desc-moeda AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE i-mo-codigo AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Moeda" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.54.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE l-aprovado AS LOGICAL INITIAL no 
     LABEL "Aprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 10 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-cotacao-item-cex2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 DISPLAY
      tt-cotacao-item-cex2.sequencia FORMAT ">>9":U
      tt-cotacao-item-cex2.cod-emitente-desp FORMAT ">>>>>>>>9":U
      fnEmitente(input tt-cotacao-item-cex2.cod-emitente-desp) @ c-desc-emitente1 COLUMN-LABEL "Fornecedor" FORMAT "x(12)":U
      tt-cotacao-item-cex2.cod-desp FORMAT ">>,>>9":U
      fnDespesa(input tt-cotacao-item-cex2.cod-desp) @ c-desc-despesa COLUMN-LABEL "Descri‡Æo" FORMAT "x(25)":U
      tt-cotacao-item-cex2.val-desp FORMAT ">>>>>,>>>,>>9.99999":U
      tt-cotacao-item-cex2.mo-codigo FORMAT ">9":U
      fnMoeda(input tt-cotacao-item-cex2.mo-codigo) @ c-desc-moeda1 COLUMN-LABEL "Descricao" FORMAT "x(12)":U
      tt-cotacao-item-cex2.log-recalc-val FORMAT "Sim/NÆo":U
      tt-cotacao-item-cex2.cod-cond-pag FORMAT ">>>9":U
      fnCondicao(input tt-cotacao-item-cex2.cod-cond-pag) @ c-desc-condicao1 COLUMN-LABEL "Descricao" FORMAT "x(30)":U
      tt-cotacao-item-cex2.cod-pto-contr FORMAT ">>,>>9":U
      fnPto-contr(input tt-cotacao-item-cex2.cod-pto-contr) @ c-desc-pto-contr1 COLUMN-LABEL "Descricao" FORMAT "x(30)":U
      fnIncide-vl(input tt-cotacao-item-cex2.cod-desp) @ c-incide-vl COLUMN-LABEL "Incide Valor" FORMAT "x(03)":U
            WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 5
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
     btParam AT ROW 1.13 COL 68 HELP
          "Parƒmetros"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-cotacao-item-cex.numero-ordem AT ROW 2.83 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-cotacao-item-cex.cod-emitente AT ROW 2.83 COL 40 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     fc-desc-emitente AT ROW 2.83 COL 50.29 COLON-ALIGNED NO-LABEL
     tt-cotacao-item-cex.it-codigo AT ROW 3.83 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     fc-desc-it-codigo AT ROW 3.83 COL 32 COLON-ALIGNED NO-LABEL
     tt-cotacao-item-cex.seq-cotac AT ROW 4.83 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-cotacao-item-cex.data-cotacao AT ROW 4.83 COL 40 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     c-un AT ROW 4.83 COL 68.43 COLON-ALIGNED
     tt-cotacao-item-cex.cod-itiner AT ROW 5.83 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fc-desc-itinerario AT ROW 5.83 COL 24.86 COLON-ALIGNED NO-LABEL
     tt-cotacao-item-cex.cod-incoterm AT ROW 5.83 COL 68.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-cotacao-item-cex.mapa-cotacao AT ROW 6.83 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.86 BY .88
     l-aprovado AT ROW 6.83 COL 27
     de-preco-cotacao AT ROW 6.83 COL 40 COLON-ALIGNED
     i-mo-codigo AT ROW 6.83 COL 68.43 COLON-ALIGNED
     fc-desc-moeda AT ROW 6.83 COL 73.43 COLON-ALIGNED NO-LABEL
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.13
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.21 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.71
         SIZE 85.43 BY 6.04
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Temp-Tables and Buffers:
      TABLE: tt-cotacao-item-cex T "?" NO-UNDO mgcex cotacao-item-cex
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-cotacao-item-cex2 T "?" NO-UNDO mgcex cotacao-item-cex
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
         HEIGHT             = 14.13
         WIDTH              = 90.29
         MAX-HEIGHT         = 15.83
         MAX-WIDTH          = 95.14
         VIRTUAL-HEIGHT     = 15.83
         VIRTUAL-WIDTH      = 95.14
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
     _TblList          = "Temp-Tables.tt-cotacao-item-cex2"
     _FldNameList[1]   = Temp-Tables.tt-cotacao-item-cex2.sequencia
     _FldNameList[2]   = Temp-Tables.tt-cotacao-item-cex2.cod-emitente-desp
     _FldNameList[3]   > "_<CALC>"
"fnEmitente(input tt-cotacao-item-cex2.cod-emitente-desp) @ c-desc-emitente1" "Fornecedor" "x(12)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[4]   = Temp-Tables.tt-cotacao-item-cex2.cod-desp
     _FldNameList[5]   > "_<CALC>"
"fnDespesa(input tt-cotacao-item-cex2.cod-desp) @ c-desc-despesa" "Descri‡Æo" "x(25)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[6]   = Temp-Tables.tt-cotacao-item-cex2.val-desp
     _FldNameList[7]   = Temp-Tables.tt-cotacao-item-cex2.mo-codigo
     _FldNameList[8]   > "_<CALC>"
"fnMoeda(input tt-cotacao-item-cex2.mo-codigo) @ c-desc-moeda1" "Descricao" "x(12)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[9]   = Temp-Tables.tt-cotacao-item-cex2.log-recalc-val
     _FldNameList[10]   = Temp-Tables.tt-cotacao-item-cex2.cod-cond-pag
     _FldNameList[11]   > "_<CALC>"
"fnCondicao(input tt-cotacao-item-cex2.cod-cond-pag) @ c-desc-condicao1" "Descricao" "x(30)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[12]   = Temp-Tables.tt-cotacao-item-cex2.cod-pto-contr
     _FldNameList[13]   > "_<CALC>"
"fnPto-contr(input tt-cotacao-item-cex2.cod-pto-contr) @ c-desc-pto-contr1" "Descricao" "x(30)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[14]   > "_<CALC>"
"fnIncide-vl(input tt-cotacao-item-cex2.cod-desp) @ c-incide-vl" "Incide Valor" "x(03)" ? ? ? ? ? ? ? no ? no no "12" yes no no "U" "" ""
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


&Scoped-define SELF-NAME btParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam wMasterDetail
ON CHOOSE OF btParam IN FRAME fPage0 /* Parƒmetros */
OR CHOOSE OF MENU-ITEM miParam IN MENU mbMain DO:
   run ccp/cc9022.w.
   RUN repositionRecord IN THIS-PROCEDURE (input r-chave).
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
    {method/zoomreposition.i &ProgramZoom="cxzoom/z10cx085.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyinterface wMasterDetail 
PROCEDURE afterDestroyinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin082) THEN
        delete procedure h-boin082.
    ASSIGN h-boin082 = ?.

    IF VALID-HANDLE(h-boin172) THEN
        delete procedure h-boin172.
    ASSIGN h-boin172 = ?.

    IF VALID-HANDLE(h-boad098) THEN
        delete procedure h-boad098.
    ASSIGN h-boad098 = ?.

    IF VALID-HANDLE(h-bocx095) THEN
        delete procedure h-bocx095.
    ASSIGN h-bocx095 = ?.

    IF VALID-HANDLE(h-boun005) THEN
        delete procedure h-boun005.   
    ASSIGN h-boun005 = ?.

    IF VALID-HANDLE(h-boad039) THEN
        delete procedure h-boad039.
    ASSIGN h-boad039 = ?.

    IF VALID-HANDLE(h-bocx110) THEN
        delete procedure h-bocx110.
    ASSIGN h-bocx110 = ?.

    IF VALID-HANDLE(h-bocx115) THEN
        delete procedure h-bocx115.
    ASSIGN h-bocx115 = ?.
    
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
    if avail tt-cotacao-item-cex then do:
        
        /* Busca nome abreviado do emitente */
        run findCodigo in h-boad098 (input tt-cotacao-item-cex.cod-emitente,
                                     output c-return).
        if c-return = "" then
            run getCharfield in h-boad098 (input "nome-abrev":U,output fc-desc-emitente).                
        
        /* Busca moeda da cotacao do material */                
        &if defined(bf-mat-comex) &then        
            run findCotacao in h-boin082(input tt-cotacao-item-cex.numero-ordem,
                                         input tt-cotacao-item-cex.cod-emitente,
                                         input tt-cotacao-item-cex.it-codigo,
                                         input tt-cotacao-item-cex.data-cotacao,
                                         output c-return).        
        &else
            run findCotacao in h-boin082(input tt-cotacao-item-cex.numero-ordem,
                                         input tt-cotacao-item-cex.cod-emitente,
                                         input tt-cotacao-item-cex.it-codigo,
                                         input tt-cotacao-item-cex.seq-cotac,
                                         output c-return).
        &endif
        if c-return = "" then do:
            run getIntfield in h-boin082(input "mo-codigo", output i-mo-codigo).
            run getCharfield in h-boin082(input "un":U, output c-un).
        end.
                          
        &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
            assign btParam:SENSITIVE in frame fPage0 = YES
                   i-mo-codigo   = i-moeda-g.
            run findCodigo in h-boun005 (input i-moeda-g,
                                         output c-return).
            if c-return = "" then
               run getCharfield in h-boun005 (input "descricao",
                                              output fc-desc-moeda).
            
            run findCodigo in h-boin172 (input tt-cotacao-item-cex.it-codigo,
                                         output c-return).
            
            IF c-return = "" THEN DO:
                
               run getCharfield in h-boin172 (input "descricao-1",
                                              output fc-desc-item-1).

               run getCharfield in h-boin172 (input "descricao-2",
                                              output fc-desc-item-2).

               ASSIGN fc-desc-it-codigo = fc-desc-item-1 + fc-desc-item-2.
            END.
        &endif

        /* Busca descricao do itinerario */
        run findCodigo in h-bocx115(input tt-cotacao-item-cex.cod-itiner,
                                    output c-return).
        if c-return = "" then
            run getCharfield in h-bocx115(input "descricao",
                                          output fc-desc-itinerario).                    
                         
        /* Verifica se o mapa est  aprovado */            
        RUN verificaMapaaprovado in h-bocx085 (input tt-cotacao-item-cex.r-rowid, output l-aprovado).
        
        /* Calcula o preco total das despesas da cotacao na moeda da cotacao do material */
        &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
        
            RUN NovocalculoPrecoCotacao  in h-bocx085 (INPUT i-moeda-g,
                                                       INPUT l-conv-g,
                                                       INPUT da-conv-g,
                                                       input tt-cotacao-item-cex.r-rowid,
                                                       output de-preco-cotacao).
        &else
            RUN calculoPrecoCotacao  in h-bocx085 (input tt-cotacao-item-cex.r-rowid, output de-preco-cotacao).
        &endif
        
        
        disp fc-desc-emitente
             i-mo-codigo 
             fnMoeda(input i-mo-codigo)       @ fc-desc-moeda          
             fc-desc-itinerario
             l-aprovado 
             de-preco-cotacao
             c-un
             fc-desc-emitente with frame fPage0.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterinitializeinterface wMasterDetail 
PROCEDURE afterinitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {utp/ut-liter.i "Moeda_Parametrizada"}
  assign i-mo-codigo:label in frame fPage0 = trim(return-value).
  
  &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
      IF gr-cotacao-item <> ? THEN DO:
         run findOrdemaprovada in h-bocx085(input gr-cotacao-item,
                                            output r-chave).
         RUN repositionRecord IN THIS-PROCEDURE (input r-chave).       
      END.
      ELSE DO:
           RUN getFirst IN THIS-PROCEDURE.
      END.

      assign btParam:hidden in frame fPage0 = no.
  &ENDIF
  
  
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
         SIZE 35 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE cStatus AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE inum-ordem like tt-cotacao-item-cex.numero-ordem NO-UNDO.
    DEFINE VARIABLE icod-emitente like tt-cotacao-item-cex.cod-emitente NO-UNDO.
    DEFINE VARIABLE iit-codigo like tt-cotacao-item-cex.it-codigo NO-UNDO.        
    &if defined(bf-mat-comex) &then    
        DEFINE VARIABLE da-data-cotacao like tt-cotacao-item-cex.data-cotacao NO-UNDO.
    &else            
        DEFINE VARIABLE iseq-cotac like tt-cotacao-item-cex.seq-cotac NO-UNDO.    
    &endif
    DEFINE VARIABLE imapa-cotacao like tt-cotacao-item-cex.mapa-cotacao NO-UNDO.    
    
    DEFINE FRAME fGoToRecord
        inum-ordem AT ROW 1.21 COL 15 COLON-ALIGNED
        icod-emitente AT ROW 2.21 COL 15 COLON-ALIGNED
        iit-codigo AT ROW 3.21 COL 15 COLON-ALIGNED
        &if defined(bf-mat-comex) &then    
            da-data-cotacao AT ROW 4.21 COL 15 COLON-ALIGNED
        &else   
            iseq-cotac AT ROW 4.21 COL 15 COLON-ALIGNED
        &endif      
        imapa-cotacao AT ROW 5.21 COL 15 COLON-ALIGNED
        btGoToOK      AT ROW 6.63 COL 2.14
        btGoToCancel  AT ROW 6.63 COL 13
        rtGoToButton  AT ROW 6.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE FONT 1 TITLE "V  Para Cotacao Item Cex"
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Cotacao_Item_Cex"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN inum-ordem
               icod-emitente
               iit-codigo
               &if defined(bf-mat-comex) &then                   
                   da-data-cotacao
               &else
                   iseq-cotac
               &endif                   
               imapa-cotacao.
        
        &IF DEFINED(DBOVersion) <> 0 &THEN
           RUN findVapara IN {&hDBOParent} (INPUT iit-codigo, 
                                            INPUT icod-emitente,           
                                            &if defined(bf-mat-comex) &then    
                                                INPUT da-data-cotacao,
                                            &else
                                                INPUT iseq-cotac,                                            
                                            &endif                                                
                                            INPUT inum-ordem,
                                            INPUT imapa-cotacao,
                                            OUTPUT cStatus).
           IF cStatus <> "":U THEN DO:
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Cota‡Æo_Despesas_item" *}
              RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                 INPUT 2, 
                                 INPUT RETURN-VALUE).
              
              RETURN NO-APPLY.
           END.
        &ENDIF
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    assign icod-emitente:width = 10.
    
    ENABLE inum-ordem icod-emitente iit-codigo 
        &if defined(bf-mat-comex) &then    
            da-data-cotacao
        &else
            iseq-cotac 
        &endif    
            
        imapa-cotacao btGoToOK btGoToCancel 
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
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:
       RUN cxbo/bocx085.p persistent set h-bocx085.
    END.

    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOParent} (INPUT 1).
    &ELSE
        RUN openQueryStatic IN {&hDBOParent} (INPUT "cod-itiner":U).
    &ENDIF
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) THEN DO:
       RUN cxbo/bocx085.p persistent set h-bocx0852.
    END.    
    
    IF NOT VALID-HANDLE(h-boin082) THEN
        RUN inbo/boin082.p persistent set h-boin082.

    IF NOT VALID-HANDLE(h-boin172) THEN
        RUN inbo/boin172.p persistent set h-boin172.

    IF NOT VALID-HANDLE(h-boad098) THEN
        RUN adbo/boad098.p persistent set h-boad098.

    IF NOT VALID-HANDLE(h-bocx095) THEN
        RUN cxbo/bocx095.p persistent set h-bocx095.

    IF NOT VALID-HANDLE(h-boun005) THEN
        RUN unbo/boun005.p persistent set h-boun005.   

    IF NOT VALID-HANDLE(h-boad039) THEN
        RUN adbo/boad039.p persistent set h-boad039.

    IF NOT VALID-HANDLE(h-bocx110) THEN
        RUN cxbo/bocx110.p persistent set h-bocx110.

    IF NOT VALID-HANDLE(h-bocx115) THEN
        RUN cxbo/bocx115.p persistent set h-bocx115.
    
    if gr-cotacao-item <> ? then do:
       run findOrdemaprovada in h-bocx085(input gr-cotacao-item,
                                          output r-chave).
       RUN repositionRecord IN THIS-PROCEDURE (input r-chave).                                            
    end.

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
    
   DEFINE VARIABLE r-cotacao as rowid NO-UNDO.
   
   IF AVAILABLE tt-cotacao-item-cex THEN
       ASSIGN r-cotacao = tt-cotacao-item-cex.r-rowid.
   ELSE
       ASSIGN r-cotacao = ?.


   {masterdetail/OpenQueriesSon.i
        &Parent="tt-cotacao-item-cex"
        &Query="CodCotacao"
        &PageNumber="1"
        &QueryConstraint="4"
        &ConstraintParameters="r-cotacao"}
        
       
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCondicao wMasterDetail 
FUNCTION fnCondicao RETURNS CHARACTER
    ( input p-cod-cond-pag as integer ) :
    
    run findCodigo in h-boad039 (input p-cod-cond-pag,
                                 output c-return).
    if c-return = "" then
        run getCharfield in h-boad039 (input "descricao",
                                       output c-desc-condicao).

    RETURN c-desc-condicao.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDespesa wMasterDetail 
FUNCTION fnDespesa RETURNS CHARACTER
    (input p-cod-desp as integer):
  
    RUN findCodigo in h-bocx095 (input p-cod-desp, 
                                 output c-return).
                                 
    if c-return = "" then
        run getCharField in h-bocx095 (input "descricao", 
                                       output c-desc-despesa).

    RETURN c-desc-despesa.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEmitente wMasterDetail 
FUNCTION fnEmitente RETURNS CHARACTER
    (input p-cod-emitente as integer) :
    
    RUN findCodigo in h-boad098 (input p-cod-emitente, output c-return).
    
    if c-return = "" then    
        RUN getCharField in h-boad098 (input "nome-abrev", output c-desc-emitente).
  
    RETURN c-desc-emitente.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnIncide-vl wMasterDetail 
FUNCTION fnIncide-vl RETURNS CHARACTER
    ( input p-cod-desp as integer ) :

    ASSIGN c-incide-vl = "NÆo".

    run findCodigo in h-bocx095 (input p-cod-desp,
                                 output c-return).
    if c-return = "" THEN DO:
       run getLogfield in h-bocx095 (input "inc-val-embal":U, 
                                     OUTPUT l-inc-val-embal).
       run getLogfield in h-bocx095 (input "inc-val-seguro":U, 
                                     OUTPUT l-inc-val-seguro).
       run getLogfield in h-bocx095 (input "inc-val-frete":U, 
                                     OUTPUT l-inc-val-frete).
       run getLogfield in h-bocx095 (input "inc-val-outras-desp":U, 
                                     OUTPUT l-inc-val-outras-desp).
       IF l-inc-val-embal       = YES OR
          l-inc-val-seguro      = YES OR
          l-inc-val-frete       = YES OR
          l-inc-val-outras-desp = YES THEN
          ASSIGN c-incide-vl = "Sim".
    END.

    RETURN c-incide-vl.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMoeda wMasterDetail 
FUNCTION fnMoeda RETURNS CHARACTER
    ( input p-mo-codigo as integer ) :
    
    run findCodigo in h-boun005 (input p-mo-codigo,
                                 output c-return).
    if c-return = "" then
        run getCharfield in h-boun005 (input "descricao",
                                       output c-desc-moeda).
                                       
    RETURN c-desc-moeda.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPto-contr wMasterDetail 
FUNCTION fnPto-contr RETURNS CHARACTER
    ( input p-cod-pto-contr as integer ) :
        
    run findCodigo in h-bocx110(input p-cod-pto-contr,
                                output c-return).
    if c-return = "" then
        run getCharfield in h-bocx110(input "descricao",
                                      output c-desc-pto-contr).                                                                              

    RETURN c-desc-pto-contr.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

