&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-docum-est NO-UNDO LIKE docum-est
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-docum-est-cex NO-UNDO LIKE docum-est-cex
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-dupli-apagar-cex NO-UNDO LIKE dupli-apagar-cex
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-item-doc-est NO-UNDO LIKE item-doc-est
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
{include/i-prgvrs.i IM1001AM 2.00.00.005}  /*** 010005 ***/
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
&GLOBAL-DEFINE Program          IM1001AM
&GLOBAL-DEFINE Version          2.00.00.005

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Itens , Desp Nota , Duplicatas

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

&GLOBAL-DEFINE AddSon2          YES
&GLOBAL-DEFINE CopySon2         NO
&GLOBAL-DEFINE UpdateSon2       yes
&GLOBAL-DEFINE DeleteSon2       Yes

&GLOBAL-DEFINE AddSon3          YES
&GLOBAL-DEFINE CopySon3         NO
&GLOBAL-DEFINE UpdateSon3       yes
&GLOBAL-DEFINE DeleteSon3       yes

&GLOBAL-DEFINE ttParent         TT-DOCUM-EST
&GLOBAL-DEFINE hDBOParent       h-boin090
&GLOBAL-DEFINE DBOParentTable   DOCUM-EST
&GLOBAL-DEFINE DBOParentDestroy no

&GLOBAL-DEFINE ttSon1           TT-ITEM-DOC-EST
&GLOBAL-DEFINE hDBOSon1         h-boin176
&GLOBAL-DEFINE DBOSon1Table     ITEM-DOC-EST
&GLOBAL-DEFINE DBOSon1Destroy   no

&GLOBAL-DEFINE ttSon2           TT-DOCUM-EST-CEX
&GLOBAL-DEFINE hDBOSon2         h-bocx090
&GLOBAL-DEFINE DBOSon2Table     DOCUM-EST-CEX
&GLOBAL-DEFINE DBOSon2Destroy   no

&GLOBAL-DEFINE ttSon3           TT-DUPLI-APAGAR-CEX
&GLOBAL-DEFINE hDBOSon3         h-bocx255
&GLOBAL-DEFINE DBOSon3Table     DUPLI-APAGAR-CEX
&GLOBAL-DEFINE DBOSon3Destroy   no

&GLOBAL-DEFINE page0Fields      TT-DOCUM-EST.COD-EMITENTE~
                                TT-DOCUM-EST.SERIE-DOCTO~
                                TT-DOCUM-EST.NRO-DOCTO~
                                TT-DOCUM-EST.NAT-OPERACAO
                                

&GLOBAL-DEFINE page1Browse BRSon1      
&GLOBAL-DEFINE page2Browse BRSon2
&GLOBAL-DEFINE page3Browse BRSon3

/*
&GLOBAL-DEFINE DetailSon1 Yes
&GLOBAL-DEFINE DetailSon2 Yes
&GLOBAL-DEFINE DetailSon3 Yes
*/

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon3}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin092     AS HANDLE NO-UNDO.

def temp-table tt-dupli-apagar-generic no-undo like dupli-apagar-cex
    field r-rowid   as rowid
    field sequencia as integer
    index documento as primary unique sequencia.

def var i-cod-emitente  like item-doc-est.cod-emitente no-undo.
def var c-serie-docto   like item-doc-est.serie-docto  no-undo.
def var c-nro-docto     like item-doc-est.nro-docto    no-undo.
def var c-nat-operacao  like item-doc-est.nat-operacao no-undo.
def var c-fornec        like emitente.nome-emit        no-undo.
def var c-desp          like desp-imp.descricao        no-undo.
def var rDocumEst       as rowid                       no-undo.

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
&Scoped-define INTERNAL-TABLES tt-item-doc-est tt-docum-est-cex ~
tt-dupli-apagar-generic

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-item-doc-est.sequencia ~
tt-item-doc-est.num-pedido tt-item-doc-est.it-codigo ~
tt-item-doc-est.qt-do-forn tt-item-doc-est.quantidade ~
tt-item-doc-est.preco-total[1] tt-item-doc-est.numero-ordem ~
tt-item-doc-est.parcela tt-item-doc-est.nr-ord-produ ~
tt-item-doc-est.valor-ipi[1] tt-item-doc-est.valor-icm[1] ~
FnDescItem1(tt-item-doc-est.it-codigo,                       tt-item-doc-est.r-rowid) @ tt-item-doc-est.char-1 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-item-doc-est NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-item-doc-est NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-item-doc-est
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-item-doc-est


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-docum-est-cex.cod-emitente-desp ~
fnFornec(tt-docum-est-cex.cod-emitente-desp) @ c-fornec ~
tt-docum-est-cex.cod-desp fnDespesa(tt-docum-est-cex.cod-desp) @ c-desp ~
tt-docum-est-cex.val-desp 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-docum-est-cex NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH tt-docum-est-cex NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-docum-est-cex
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-docum-est-cex


/* Definitions for BROWSE brSon3                                        */
&Scoped-define FIELDS-IN-QUERY-brSon3 tt-dupli-apagar-generic.cod-emitente-desp tt-dupli-apagar-generic.parcela tt-dupli-apagar-generic.cod-esp tt-dupli-apagar-generic.vl-a-pagar tt-dupli-apagar-generic.dt-emissao tt-dupli-apagar-generic.dt-vencim tt-dupli-apagar-generic.vl-desconto tt-dupli-apagar-generic.dt-venc-desc fnFornec(tt-dupli-apagar-generic.cod-emitente-desp) @ c-fornec   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon3   
&Scoped-define SELF-NAME brSon3
&Scoped-define QUERY-STRING-brSon3 FOR EACH tt-dupli-apagar-generic NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon3 OPEN QUERY {&SELF-NAME} FOR EACH tt-dupli-apagar-generic NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon3 tt-dupli-apagar-generic
&Scoped-define FIRST-TABLE-IN-QUERY-brSon3 tt-dupli-apagar-generic


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brSon3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-docum-est.cod-emitente ~
tt-docum-est.serie-docto tt-docum-est.nro-docto tt-docum-est.nat-operacao 
&Scoped-define ENABLED-TABLES tt-docum-est
&Scoped-define FIRST-ENABLED-TABLE tt-docum-est
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btFirst btPrev btNext ~
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
c-nome-emit c-denominacao 
&Scoped-Define DISPLAYED-FIELDS tt-docum-est.cod-emitente ~
tt-docum-est.serie-docto tt-docum-est.nro-docto tt-docum-est.nat-operacao 
&Scoped-define DISPLAYED-TABLES tt-docum-est
&Scoped-define FIRST-DISPLAYED-TABLE tt-docum-est
&Scoped-Define DISPLAYED-OBJECTS c-nome-emit c-denominacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem1 wMasterDetail 
FUNCTION fnDescItem1 RETURNS CHARACTER
  ( input c-it-codigo  as char,
    input r-rowid-item as rowid )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fndespesa wMasterDetail 
FUNCTION fndespesa RETURNS CHARACTER
  ( input i-cd-despesa as int  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnfornec wMasterDetail 
FUNCTION fnfornec RETURNS CHARACTER
  ( input i-cd-fornec as int )  FORWARD.

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

DEFINE VARIABLE c-denominacao AS CHARACTER FORMAT "X(25)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.63.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btItens 
     LABEL "Itens" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon2 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon2 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon2 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon3 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon3 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon3 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-item-doc-est SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-docum-est-cex SCROLLING.

DEFINE QUERY brSon3 FOR 
      tt-dupli-apagar-generic SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 DISPLAY
      tt-item-doc-est.sequencia
      tt-item-doc-est.num-pedido
      tt-item-doc-est.it-codigo
      tt-item-doc-est.qt-do-forn
      tt-item-doc-est.quantidade
      tt-item-doc-est.preco-total[1]
      tt-item-doc-est.numero-ordem
      tt-item-doc-est.parcela
      tt-item-doc-est.nr-ord-produ
      tt-item-doc-est.valor-ipi[1]
      tt-item-doc-est.valor-icm[1]
      FnDescItem1(tt-item-doc-est.it-codigo,
                      tt-item-doc-est.r-rowid) @ tt-item-doc-est.char-1 COLUMN-LABEL "Descri‡Æo" FORMAT "x(60)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.21
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 DISPLAY
      tt-docum-est-cex.cod-emitente-desp
      fnFornec(tt-docum-est-cex.cod-emitente-desp) @ c-fornec
      tt-docum-est-cex.cod-desp
      fnDespesa(tt-docum-est-cex.cod-desp) @ c-desp
      tt-docum-est-cex.val-desp
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.

DEFINE BROWSE brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon3 wMasterDetail _FREEFORM
  QUERY brSon3 NO-LOCK DISPLAY
      tt-dupli-apagar-generic.cod-emitente-desp COLUMN-LABEL "Fornecedor"
      tt-dupli-apagar-generic.parcela
      tt-dupli-apagar-generic.cod-esp
      tt-dupli-apagar-generic.vl-a-pagar
      tt-dupli-apagar-generic.dt-emissao
      tt-dupli-apagar-generic.dt-vencim
      tt-dupli-apagar-generic.vl-desconto
      tt-dupli-apagar-generic.dt-venc-desc
      fnFornec(tt-dupli-apagar-generic.cod-emitente-desp) @ c-fornec
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
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
     tt-docum-est.cod-emitente AT ROW 3 COL 15.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     c-nome-emit AT ROW 3 COL 26.86 COLON-ALIGNED NO-LABEL
     tt-docum-est.serie-docto AT ROW 4 COL 15.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .88
     tt-docum-est.nro-docto AT ROW 5 COL 15.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-docum-est.nat-operacao AT ROW 6 COL 15.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     c-denominacao AT ROW 6 COL 26.86 COLON-ALIGNED NO-LABEL
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.25
         SIZE 90 BY 19.33
         FONT 1.

DEFINE FRAME fPage3
     brSon3 AT ROW 1.17 COL 2
     btAddSon3 AT ROW 10.33 COL 2
     btUpdateSon3 AT ROW 10.33 COL 12
     btDeleteSon3 AT ROW 10.33 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 8.5
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.13 COL 1.72
     btItens AT ROW 10.33 COL 1.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 8.5
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.17 COL 2
     btAddSon2 AT ROW 10.33 COL 2
     btUpdateSon2 AT ROW 10.33 COL 12
     btDeleteSon2 AT ROW 10.33 COL 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 8.5
         SIZE 84.43 BY 10.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-docum-est T "?" NO-UNDO movind docum-est
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-docum-est-cex T "?" NO-UNDO mgcex docum-est-cex
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-dupli-apagar-cex T "?" NO-UNDO mgcex dupli-apagar-cex
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-item-doc-est T "?" NO-UNDO movind item-doc-est
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
         HEIGHT             = 18.58
         WIDTH              = 90
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
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE
       FRAME fPage2:FRAME = FRAME fPage0:HANDLE
       FRAME fPage3:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brSon3 1 fPage3 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.tt-item-doc-est"
     _FldNameList[1]   = Temp-Tables.tt-item-doc-est.sequencia
     _FldNameList[2]   = Temp-Tables.tt-item-doc-est.num-pedido
     _FldNameList[3]   = Temp-Tables.tt-item-doc-est.it-codigo
     _FldNameList[4]   = Temp-Tables.tt-item-doc-est.qt-do-forn
     _FldNameList[5]   = Temp-Tables.tt-item-doc-est.quantidade
     _FldNameList[6]   = Temp-Tables.tt-item-doc-est.preco-total[1]
     _FldNameList[7]   = Temp-Tables.tt-item-doc-est.numero-ordem
     _FldNameList[8]   = Temp-Tables.tt-item-doc-est.parcela
     _FldNameList[9]   = Temp-Tables.tt-item-doc-est.nr-ord-produ
     _FldNameList[10]   = Temp-Tables.tt-item-doc-est.valor-ipi[1]
     _FldNameList[11]   = Temp-Tables.tt-item-doc-est.valor-icm[1]
     _FldNameList[12]   > "_<CALC>"
"FnDescItem1(tt-item-doc-est.it-codigo,
                      tt-item-doc-est.r-rowid) @ tt-item-doc-est.char-1" "Descri‡Æo" "x(60)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.tt-docum-est-cex"
     _FldNameList[1]   = Temp-Tables.tt-docum-est-cex.cod-emitente-desp
     _FldNameList[2]   > "_<CALC>"
"fnFornec(tt-docum-est-cex.cod-emitente-desp) @ c-fornec" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   = Temp-Tables.tt-docum-est-cex.cod-desp
     _FldNameList[4]   > "_<CALC>"
"fnDespesa(tt-docum-est-cex.cod-desp) @ c-desp" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[5]   = Temp-Tables.tt-docum-est-cex.val-desp
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon3
/* Query rebuild information for BROWSE brSon3
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-dupli-apagar-generic NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon3 */
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon2 wMasterDetail
ON CHOOSE OF btAddSon2 IN FRAME fPage2 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="imp/im1001c.w"
                           &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btAddSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon3 wMasterDetail
ON CHOOSE OF btAddSon3 IN FRAME fPage3 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="imp/im1001dm.w"
                           &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDeleteSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon2 wMasterDetail
ON CHOOSE OF btDeleteSon2 IN FRAME fPage2 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btDeleteSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon3 wMasterDetail
ON CHOOSE OF btDeleteSon3 IN FRAME fPage3 /* Eliminar */
DO:
    
    IF AVAIL tt-dupli-apagar-generic THEN DO:

        FIND FIRST tt-dupli-apagar-cex 
             WHERE tt-dupli-apagar-cex.r-rowid = tt-dupli-apagar-generic.r-rowid NO-ERROR.
        IF AVAIL tt-dupli-apagar-cex THEN DO:
            {masterdetail/deleteson.i &PageNumber="3"}
        END.
        ELSE DO:

            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 550, INPUT "":U).

            IF RETURN-VALUE = "YES":U THEN DO:
    
                IF NOT VALID-HANDLE (h-boin092) THEN DO:
                    RUN inbo/boin092.p PERSISTENT SET h-boin092.
                    RUN openQueryStatic in h-boin092 (INPUT "Main":U).
                END.
    
                RUN gotokey IN h-boin092 (INPUT tt-dupli-apagar-generic.serie-docto, 
                                          INPUT tt-dupli-apagar-generic.nro-docto, 
                                          INPUT tt-dupli-apagar-generic.cod-emitente,
                                          INPUT tt-dupli-apagar-generic.nat-operacao, 
                                          INPUT tt-dupli-apagar-generic.parcela).
    
                RUN deleteRecord IN h-boin092.
                RUN getRowErrors IN h-boin092 (OUTPUT TABLE RowErrors).
    
                FOR EACH RowErrors WHERE RowErrors.ErrorSubType <> "Error":U:
                    DELETE RowErrors.
                END.
                
                IF CAN-FIND (FIRST RowErrors) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2}            
                    RETURN "NOK".
                END.
    
                IF VALID-HANDLE(h-boin092) then
                    RUN destroy IN h-boin092.
    
                DELETE tt-dupli-apagar-generic.
    
            END.
            {&OPEN-QUERY-brSon3}
        END.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btItens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btItens wMasterDetail
ON CHOOSE OF btItens IN FRAME fPage1 /* Itens */
DO:

    def var h-im1001b as handle no-undo.
               
    if  not avail tt-docum-est then
        return no-apply.
    
    run imp/im1001b.w persistent set h-im1001b.
    
    if  valid-handle(h-im1001b) then do:
    
        {&window-name}:sensitive = no.
        
        session:set-wait-state("general":U).

        /*--- seta parametros no programa de itens ---*/
        run setParameters in h-im1001b( input h-boin090,
                                        input h-boin176 ) .
        
        /*--- inicializa o programa ---*/
        run initializeInterface in h-im1001b .
        
        if  return-value = "NOK":U then do:
            
            if  valid-handle ( h-im1001b) then
                delete procedure h-im1001b. 
                
            {&window-name}:sensitive = yes.
            session:set-wait-state("":U).
            return no-apply.
            
        end.
        else do:
        
            session:set-wait-state("":U).
            wait-for close of h-im1001b focus current-window.
            {&window-name}:sensitive = yes.
            
        end.
    end.
   
   /* run openQueriesSon in this-procedure.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
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
   /*--- Executa programa de pesquisa ---*/
    RUN inzoom/z13in090.w PERSISTENT SET hProgramZoom.
    
    IF VALID-HANDLE(hProgramZoom) THEN DO:
        /*--- Seta, no programa de pesquisa, os campos que devem ser retornados
              Neste caso ser˜ retornado o ROWID do registro selecionado ---*/
        RUN setFieldNamesHandles IN hProgramZoom (INPUT "ROWID":U, INPUT STRING(THIS-PROCEDURE)).
 
        /*--- seta flag informando o tipo de documento que deve ser exibido no zoom ---*/
        run setParameters in hProgramZoom ( no ). /*--- no = documentos nÆo atualizados ---*/
        
        /*--- Inicializa programa de pesquisa ---*/
        RUN initializeInterface IN hProgramZoom.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btUpdateSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon2 wMasterDetail
ON CHOOSE OF btUpdateSon2 IN FRAME fPage2 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="imp/im1001c.w"
                              &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btUpdateSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon3 wMasterDetail
ON CHOOSE OF btUpdateSon3 IN FRAME fPage3 /* Alterar */
DO:

    if can-find(first dupli-apagar-cex no-lock
                where rowid(dupli-apagar-cex) = tt-dupli-apagar-generic.r-rowid) then    
        run imp/im1001dm.w (input tt-dupli-apagar-generic.r-rowid,
                            input tt-docum-est.r-rowid,
                            input "update",
                            input this-procedure,
                            input 3).
    else do:
        run imp/im1001dm.w (input tt-dupli-apagar-generic.r-rowid,
                            input tt-docum-est.r-rowid,
                            input "update-Dupli-apagar",
                            input this-procedure,
                            input 3).
    end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterdisplayfields wMasterDetail 
PROCEDURE afterdisplayfields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def var c-nom-emit  as char no-undo.
   def var c-desc-nat  as char no-undo.

   run findEmitente in {&hDBOParent}(input frame fPage0 {&ttParent}.cod-emitente).
   
   if return-value <> "NOK":U then do:
      run getDescriptionFields in {&hDBOParent} ( input "nome-emit":U,
                                                  output c-nom-emit ).
      assign c-nome-emit:screen-value in frame fPage0 = c-nom-emit.
   end.
   else
      assign c-nome-emit:screen-value in frame fPage0 = "".


   run findNaturOper in {&hDBOParent}(input frame fPage0 {&ttParent}.nat-operacao).
   
   if return-value <> "NOK":U then do:
      run getDescriptionFields in {&hDBOParent} ( input "desc-natur":U,
                                                  output c-desc-nat ).
      assign c-denominacao:screen-value in frame fPage0 = c-desc-nat.
   end.
   else
      assign c-denominacao:screen-value in frame fPage0 = "".

   run changeStateButtons in this-procedure.                   
                   
   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTDupliApagarGeneric wMasterDetail 
PROCEDURE carregaTTDupliApagarGeneric :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var i-seq as int init 0 no-undo.
    
    empty temp-table tt-dupli-apagar-generic.
    
    for each dupli-apagar-cex no-lock
       where dupli-apagar-cex.serie-docto  = input frame {&frame-name} tt-docum-est.serie-docto  
         and dupli-apagar-cex.nro-docto    = input frame {&frame-name} tt-docum-est.nro-docto                          
         and dupli-apagar-cex.cod-emitente = input frame {&frame-name} tt-docum-est.cod-emitente 
         and dupli-apagar-cex.nat-operacao = input frame {&frame-name} tt-docum-est.nat-operacao:
        
        assign i-seq = i-seq + 1.

        create tt-dupli-apagar-generic.
        assign tt-dupli-apagar-generic.sequencia         = i-seq
               tt-dupli-apagar-generic.r-rowid           = rowid(dupli-apagar-cex)
               tt-dupli-apagar-generic.serie-docto       = dupli-apagar-cex.serie-docto  
               tt-dupli-apagar-generic.nro-docto         = dupli-apagar-cex.nro-docto    
               tt-dupli-apagar-generic.cod-emitente      = dupli-apagar-cex.cod-emitente-desp
               tt-dupli-apagar-generic.nat-operacao      = dupli-apagar-cex.nat-operacao 
               tt-dupli-apagar-generic.cod-emitente-desp = dupli-apagar-cex.cod-emitente-desp
               tt-dupli-apagar-generic.parcela           = dupli-apagar-cex.parcela
               tt-dupli-apagar-generic.cod-esp           = dupli-apagar-cex.cod-esp
               tt-dupli-apagar-generic.vl-a-pagar        = dupli-apagar-cex.vl-a-pagar
               tt-dupli-apagar-generic.dt-emissao        = dupli-apagar-cex.dt-emissao
               tt-dupli-apagar-generic.vl-desconto       = dupli-apagar-cex.vl-desconto
               tt-dupli-apagar-generic.dt-venc-desc      = dupli-apagar-cex.dt-venc-desc.
    end.

    for each dupli-apagar no-lock
       where dupli-apagar.serie-docto  = input frame {&frame-name} tt-docum-est.serie-docto  
         and dupli-apagar.nro-docto    = input frame {&frame-name} tt-docum-est.nro-docto                         
         and dupli-apagar.cod-emitente = input frame {&frame-name} tt-docum-est.cod-emitente 
         and dupli-apagar.nat-operacao = input frame {&frame-name} tt-docum-est.nat-operacao:
                
        assign i-seq = i-seq + 1.

        create tt-dupli-apagar-generic.
        assign tt-dupli-apagar-generic.sequencia         = i-seq
               tt-dupli-apagar-generic.r-rowid           = rowid(dupli-apagar)
               tt-dupli-apagar-generic.serie-docto       = dupli-apagar.serie-docto  
               tt-dupli-apagar-generic.nro-docto         = dupli-apagar.nro-docto    
               tt-dupli-apagar-generic.cod-emitente      = dupli-apagar.cod-emitente 
               tt-dupli-apagar-generic.nat-operacao      = dupli-apagar.nat-operacao 
               tt-dupli-apagar-generic.cod-emitente-desp = dupli-apagar.cod-emitente
               tt-dupli-apagar-generic.parcela           = dupli-apagar.parcela
               tt-dupli-apagar-generic.cod-esp           = dupli-apagar.cod-esp
               tt-dupli-apagar-generic.vl-a-pagar        = dupli-apagar.vl-a-pagar
               tt-dupli-apagar-generic.dt-emissao        = dupli-apagar.dt-emissao
               tt-dupli-apagar-generic.vl-desconto       = dupli-apagar.vl-desconto
               tt-dupli-apagar-generic.dt-venc-desc      = dupli-apagar.dt-venc-desc.
    end.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeStateButtons wMasterDetail 
PROCEDURE changeStateButtons :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var i-enable-bt as int.
    
    run enableButtons in h-boin090 ( input  "btImportacao":U,
                                     output i-enable-bt ).
    if  i-enable-bt = 0 then do:
    
        assign btAddSon2:sensitive in frame fPage2    = no
               btAddSon3:sensitive in frame fPage3    = no
               btUpdateSon2:sensitive in frame fPage2 = no
               btUpdateSon3:sensitive in frame fPage3 = no
               btDeleteSon2:sensitive in frame fPage2 = no
               btDeleteSon3:sensitive in frame fPage3 = no.
               
        if avail tt-item-doc-est then
           assign btItens:sensitive in frame fPage1 = yes.
        else
           assign btItens:sensitive in frame fPage1 = no.

    end.
    else do:
        assign btAddSon2:sensitive in frame fPage2    = yes
               btAddSon3:sensitive in frame fPage3    = yes
               btUpdateSon2:sensitive in frame fPage2 = yes
               btUpdateSon3:sensitive in frame fPage3 = yes
               btDeleteSon2:sensitive in frame fPage2 = yes
               btDeleteSon3:sensitive in frame fPage3 = yes.
               
        if avail tt-item-doc-est then
           assign btItens:sensitive in frame fPage1 = yes.
        else
           assign btItens:sensitive in frame fPage1 = no.
           
        if not can-find(first tt-docum-est-cex) then
            assign btUpdateSon2:sensitive in frame fPage2 = no
                   btDeleteSon2:sensitive in frame fPage2 = no.
                   
        if not can-find(first tt-dupli-apagar-cex) then
            assign btUpdateSon3:sensitive in frame fPage3 = no
                   btDeleteSon3:sensitive in frame fPage3 = no.
                   
    end.
    
    return "OK":U.                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayerrors wMasterDetail 
PROCEDURE displayerrors :
/*------------------------------------------------------------------------------
  Notes: Exibe os erros que estiverem contidos na temp-table RowErrors
------------------------------------------------------------------------------*/

/*    /*--- Seta cursor do mouse para espera ---*/
 *     SESSION:SET-WAIT-STATE("general":U).
 * 
 *     /*--- inicializa a tela de erros ---*/
 *     
 *     {method/showmessage.i1}
 *     
 *     /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
 *     {method/showmessage.i2}
 * 
 *     /*--- Seta cursor do mouse para normal ---*/
 *     SESSION:SET-WAIT-STATE("":U).*/
    
    return "OK":U.
    
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
         SIZE 58 BY 1.38
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE i-cod-emitente LIKE tt-docum-est.cod-emitente NO-UNDO.
    DEFINE VARIABLE c-serie-docto  LIKE tt-docum-est.serie-docto  NO-UNDO.
    DEFINE VARIABLE c-nro-docto    LIKE tt-docum-est.nro-docto    NO-UNDO.
    DEFINE VARIABLE c-nat-operacao LIKE tt-docum-est.nat-operacao NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        i-cod-emitente  AT ROW 1.55 COL 17.72 COLON-ALIGNED
        c-serie-docto   AT ROW 2.55 COL 17.72 COLON-ALIGNED
        c-nro-docto     AT ROW 3.55 COL 17.72 COLON-ALIGNED
        c-nat-operacao  AT ROW 4.55 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 6 COL 2.14
        btGoToCancel      AT ROW 6 COL 13
        rtGoToButton      AT ROW 5.70 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Despesas do Item" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN input i-cod-emitente  
               input c-serie-docto   
               input c-nro-docto     
               input c-nat-operacao.
        
        /* Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT c-serie-docto,   
                                      INPUT c-nro-docto,     
                                      INPUT i-cod-emitente,
                                      INPUT c-nat-operacao).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Documento" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            RETURN NO-APPLY.
        END.
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE     i-cod-emitente  
               c-serie-docto   
               c-nro-docto     
               c-nat-operacao 
               btGoToOK 
               btGoToCancel      WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitaBotoesDespesas wMasterDetail 
PROCEDURE habilitaBotoesDespesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    enable btAddSon3
           btUpdateSon3
           btDeleteSon3 with frame fPage3.

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
    
  /*--- Verifica se o DBO jÿ estÿ inicializado ---*/

    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:  
        {btb/btb008za.i1 inbo/boin090.p}
        {btb/btb008za.i2 inbo/boin090.p '' {&hDBOParent}} 
    END.    
  
   /* RUN openQueryStatic IN {&hDBOParent} (INPUT "Docto":U).*/

    /*--- Verifica se o DBO jÿ estÿ inicializado ---*/
    /* Folder 1 */
    IF NOT VALID-HANDLE({&hDBOSon1}) THEN DO:
        {btb/btb008za.i1 inbo/boin176.p}
        {btb/btb008za.i2 inbo/boin176.p '' {&hDBOSon1}}        
    END.
    
    /*--- Verifica se o DBO jÿ estÿ inicializado ---*/
    /* Folder 2 */
    
    IF NOT VALID-HANDLE({&hDBOSon2}) THEN DO:
        {btb/btb008za.i1 cxbo/bocx090.p}
        {btb/btb008za.i2 cxbo/bocx090.p '' {&hDBOSon2}}    
    END.

    /*--- Verifica se o DBO jÿ estÿ inicializado ---*/
    /* Folder 3 */
    
    IF NOT VALID-HANDLE({&hDBOSon3}) THEN DO:
        {btb/btb008za.i1 cxbo/bocx255.p}
        {btb/btb008za.i2 cxbo/bocx255.p '' {&hDBOSon3}}    
    END.
    
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
    
    /*--- itens ---*/
    {masterdetail/openqueriesson.i &Parent="DocumEst"
                                   &Query="OfDocumEst"
                                   &PageNumber="1"}
    

    {masterdetail/openqueriesson.i &Parent="DocumEst"
                                   &Query="OfDocum"
                                   &PageNumber="2"}

    {masterdetail/openqueriesson.i &Parent="DocumEst"
                                   &Query="ofDocum"
                                   &PageNumber="3"}
                                   
    run carregaTTDupliApagarGeneric.

    {&OPEN-QUERY-brSon3}
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositiondocumest wMasterDetail 
PROCEDURE repositiondocumest :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    run repositionRecord in h-boin090 (input tt-docum-est.r-rowid).
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setParameters wMasterDetail 
PROCEDURE setParameters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piHboin090  as handle no-undo.
    def input param piHboin176  as handle no-undo.

    assign h-boin090  = piHboin090
           h-boin176  = piHboin176.

    /* Retorna rowid do registro corrente do DBO */

    run getRowid in h-boin090( output rDocumEst ).
    

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem1 wMasterDetail 
FUNCTION fnDescItem1 RETURNS CHARACTER
  ( input c-it-codigo  as char,
    input r-rowid-item as rowid ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var c-desc-item as char no-undo.
    
    run findItem in {&hDBOSon1}(input c-it-codigo).
  
    run repositionRecord in {&hDBOSon1} (r-rowid-item).
    
    run setDescItem in {&hDBOSon1}( input c-it-codigo,
                                    output c-desc-item ).

    RETURN c-desc-item.   /* Function return value. */
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fndespesa wMasterDetail 
FUNCTION fndespesa RETURNS CHARACTER
  ( input i-cd-despesa as int  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    def var c-return  as char   no-undo. 
    def var h-bocx095 as handle no-undo.
    def var c-descricao like desp-imp.descricao no-undo.
        
    run cxbo/bocx095.p persistent set h-bocx095.
    
    run findCodigo in h-bocx095(input i-cd-despesa,output c-return).
    
    if c-return = "" then
        run getCharfield in h-bocx095(input "descricao",output c-descricao).
   
    delete procedure h-bocx095.
    
    RETURN c-descricao.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnfornec wMasterDetail 
FUNCTION fnfornec RETURNS CHARACTER
  ( input i-cd-fornec as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
    def var c-return                as char   no-undo.
    def var h-boad098               as handle no-undo.
    def var c-desc-aux              as char   no-undo.
    
    run adbo/boad098.p persistent set h-boad098.
    
    run findCodigo in h-boad098(input i-cd-fornec,output c-return).
    
    if c-return = "" then
        run getCharfield in h-boad098(input "nome-abrev",output c-desc-aux).  
        
    delete procedure h-boad098.
        
    return c-desc-aux. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

