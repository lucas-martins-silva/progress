&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-antecip-import NO-UNDO LIKE antecip-import
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-decl-hist-embarq-imp NO-UNDO LIKE decl-hist-embarq-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-desp-embarque NO-UNDO LIKE desp-embarque
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-historico-embarque NO-UNDO LIKE historico-embarque
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-historico-embarque2 NO-UNDO LIKE historico-embarque
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
{include/i-prgvrs.i IM0555 2.00.00.034 } /*** "010034" 21/03/2025 09:24:36  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0555 MIM}
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

/* Include pre-processadores */
{cdp/cdcfgmat.i}
{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0555
&GLOBAL-DEFINE Version        2.00.00.034
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FramesHandle     STRING(FRAME fPage1:HANDLE)
&GLOBAL-DEFINE FolderLabels     Ptos Contr, Despesas, Comunic, Antecipa‡Æo

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE bt-observacao    YES

&GLOBAL-DEFINE ttParent         tt-historico-embarque
&GLOBAL-DEFINE hDBOParent       h-bocx230
&GLOBAL-DEFINE DBOParentTable   historico-embarque

&GLOBAL-DEFINE ttSon1           tt-historico-embarque2
&GLOBAL-DEFINE hDBOSon1         h-bocx2302
&GLOBAL-DEFINE DBOSon1Table     historico-embarque

&GLOBAL-DEFINE ttSon2           tt-desp-embarque
&GLOBAL-DEFINE hDBOSon2         h-bocx310
&GLOBAL-DEFINE DBOSon2Table     desp-embarque

&GLOBAL-DEFINE ttSon3           tt-decl-hist-embarq-imp
&GLOBAL-DEFINE hDBOSon3         h-bocx280
&GLOBAL-DEFINE DBOSon3Table     decl-hist-embarq-imp

&GLOBAL-DEFINE ttSon4           tt-antecip-import
&GLOBAL-DEFINE hDBOSon4         h-bocx00451
&GLOBAL-DEFINE DBOSon4Table     antecip-import

&GLOBAL-DEFINE page0Fields      tt-historico-embarque.cod-estabel ~
                                tt-historico-embarque.embarque ~
                                tt-historico-embarque.cod-itiner ~
                                fill-in-1 ~
                                fill-in-2 ~
                                fill-in-3
&GLOBAL-DEFINE page1Fields      bt-observacao    
&GLOBAL-DEFINE page2Widgets     btn-filter-desp
&GLOBAL-DEFINE page3Widgets     btn-filter-decl

&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      brSon2
&GLOBAL-DEFINE page3Browse      brSon3
&GLOBAL-DEFINE page4Browse      brSon4
                                
&GLOBAL-DEFINE EXCLUDE-applyOffEnd
&GLOBAL-DEFINE EXCLUDE-applyEnd

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent}  AS HANDLE  NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}    AS HANDLE  NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}    AS HANDLE  NO-UNDO.
DEFINE VARIABLE {&hDBOSon3}    AS HANDLE  NO-UNDO.
DEFINE VARIABLE {&hDBOSon4}    AS HANDLE  NO-UNDO.

def var i-sit-embarque         as integer no-undo.
def var cDiferenca             as integer no-undo.
def var cDescricao             as char    no-undo.
def var h-bocx110              as handle  no-undo.
def var h-bocx1102             as handle  no-undo.
def var h-bocx220              as handle  no-undo.
def var de-valor               as decimal no-undo.
def var i-moeda                as integer no-undo.
def var h-boun005              as HANDLE  no-undo.
def var c-embarque             LIKE embarque-imp.embarque no-undo.
def var i-cod-itiner           as integer no-undo.
def var c-cod-estabel          as char    no-undo.
def var r-teste                as char    format "x(30)".
DEF VAR r-rowid                AS ROWID   NO-UNDO.
DEF VAR c-cod-estabelecimento  LIKE historico-embarque.cod-estabel NO-UNDO.
DEF VAR i-embarque             LIKE historico-embarque.embarque    NO-UNDO.
DEF VAR c-cod-estabel-imp      AS CHAR    NO-UNDO.
DEF VAR c-embarque-imp         LIKE embarque-imp.embarque no-undo.
DEF VAR h-bocx2301             AS HANDLE  NO-UNDO.
DEF VAR h-bocx2303             AS HANDLE  NO-UNDO.
def var h-eq1002               as handle  no-undo.

DEFINE VARIABLE h-bocx010       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad098       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx095       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad039       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx3101      AS HANDLE      NO-UNDO.
DEFINE VARIABLE cNomeAbrev      LIKE emitente.nome-abrev              NO-UNDO.
DEFINE VARIABLE cDescDesp       LIKE desp-embarque.descricao          NO-UNDO.
DEFINE VARIABLE cMoDesc         LIKE moeda.descricao                  NO-UNDO.
DEFINE VARIABLE cCondPagto      LIKE cond-pagto.descricao             NO-UNDO.
DEFINE VARIABLE cDespComplRec   AS CHARACTER   FORMAT "X(03)":U       NO-UNDO.
DEFINE VARIABLE cIncoterm       AS CHARACTER   FORMAT "x(03)":U       NO-UNDO.
DEFINE VARIABLE cTipoDesp       AS CHARACTER   FORMAT "x(21)"         NO-UNDO.
DEFINE VARIABLE iPtoContr       LIKE historico-embarque.cod-pto-contr NO-UNDO.
DEFINE VARIABLE i-pto-desp-ini  LIKE historico-embarque.cod-pto-contr INIT 0        NO-UNDO.
DEFINE VARIABLE i-pto-desp-fim  LIKE historico-embarque.cod-pto-contr INIT 99999    NO-UNDO.
DEFINE VARIABLE i-pto-decl-ini  LIKE historico-embarque.cod-pto-contr INIT 0        NO-UNDO.
DEFINE VARIABLE i-pto-decl-fim  LIKE historico-embarque.cod-pto-contr INIT 99999    NO-UNDO.

&IF "{&DBOParentTable}":U <> "":U &THEN
    &GLOBAL-DEFINE rTable gr-{&DBOParentTable}
    DEFINE NEW GLOBAL SHARED VARIABLE gr-{&DBOParentTable} AS ROWID NO-UNDO.
&ENDIF
DEFINE NEW GLOBAL SHARED VARIABLE gr-embarque-imp     AS ROWID   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gr-embarque-imp-aux AS ROWID   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gl-im0044           AS LOGICAL NO-UNDO.

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
&Scoped-define INTERNAL-TABLES tt-historico-embarque2 tt-desp-embarque ~
tt-decl-hist-embarq-imp tt-antecip-import

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-historico-embarque2.sequencia ~
tt-historico-embarque2.cod-pto-contr ~
fnDescricao(input tt-historico-embarque2.cod-estabel, input tt-historico-embarque2.embarque, input tt-historico-embarque2.cod-itiner, input tt-historico-embarque2.cod-pto-contr) @ cDescricao ~
tt-historico-embarque2.dt-previsao tt-historico-embarque2.dt-ult-previsao ~
tt-historico-embarque2.dt-efetiva ~
fnDiferenca(input tt-historico-embarque2.dt-efetiva) @ cDiferenca ~
tt-historico-embarque2.id-meio-transp tt-historico-embarque2.nr-dias 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-historico-embarque2 NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-historico-embarque2 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-historico-embarque2
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-historico-embarque2


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-desp-embarque.cod-pto-contr fnDescricao(tt-desp-embarque.cod-estabel, tt-desp-embarque.embarque, tt-desp-embarque.cod-itiner, tt-desp-embarque.cod-pto-contr) @ cDescricao tt-desp-embarque.cod-emitente-desp fnEmitente(tt-desp-embarque.cod-emitente-desp) @ cNomeAbrev tt-desp-embarque.cod-desp fnDescDesp() @ tt-desp-embarque.descricao tt-desp-embarque.val-desp tt-desp-embarque.cod-cond-pag fnCondPagto(tt-desp-embarque.cod-cond-pag) @ cCondPagto tt-desp-embarque.mo-codigo fnMoeda(tt-desp-embarque.mo-codigo) @ cMoDesc fnTipoDesp(tt-desp-embarque.cod-desp) @ cTipoDesp fnIncoterm() @ cIncoterm fnDespComplRec() @ cDespComplRec   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2   
&Scoped-define SELF-NAME brSon2
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-desp-embarque NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY {&SELF-NAME} FOR EACH tt-desp-embarque NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-desp-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-desp-embarque


/* Definitions for BROWSE brSon3                                        */
&Scoped-define FIELDS-IN-QUERY-brSon3 tt-decl-hist-embarq-imp.sequencia fnPtoSeq({&ttSon3}.cod-estabel, {&ttSon3}.embarque, {&ttSon3}.cod-itiner, {&ttSon3}.sequencia) @ iPtoContr fnDescricao(input {&ttSon3}.cod-estabel, input {&ttSon3}.embarque, input {&ttSon3}.cod-itiner, input fnPtoSeq({&ttSon3}.cod-estabel, {&ttSon3}.embarque, {&ttSon3}.cod-itiner, {&ttSon3}.sequencia)) @ cDescricao tt-decl-hist-embarq-imp.de-codigo fnDescDecl() @ tt-decl-hist-embarq-imp.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon3   
&Scoped-define SELF-NAME brSon3
&Scoped-define QUERY-STRING-brSon3 FOR EACH tt-decl-hist-embarq-imp NO-LOCK
&Scoped-define OPEN-QUERY-brSon3 OPEN QUERY {&SELF-NAME} FOR EACH tt-decl-hist-embarq-imp NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon3 tt-decl-hist-embarq-imp
&Scoped-define FIRST-TABLE-IN-QUERY-brSon3 tt-decl-hist-embarq-imp


/* Definitions for BROWSE brSon4                                        */
&Scoped-define FIELDS-IN-QUERY-brSon4 tt-antecip-import.cdd-id-antecip ~
tt-antecip-import.cod-refer-antecip-ap tt-antecip-import.cod-estab-ap ~
tt-antecip-import.cod-espec-docto-ap tt-antecip-import.cod-ser-docto-ap ~
tt-antecip-import.cod-tit-ap tt-antecip-import.cod-parc-ap ~
tt-antecip-import.cdn-emitente-ap tt-antecip-import.nom-abrev-ap ~
tt-antecip-import.cod-moed-ap tt-antecip-import.val-vinc-embarq ~
tt-antecip-import.dat-transacao tt-antecip-import.val-cotac-tit 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon4 
&Scoped-define QUERY-STRING-brSon4 FOR EACH tt-antecip-import NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon4 OPEN QUERY brSon4 FOR EACH tt-antecip-import NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon4 tt-antecip-import
&Scoped-define FIRST-TABLE-IN-QUERY-brSon4 tt-antecip-import


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brSon3}

/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-brSon4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-historico-embarque.cod-estabel ~
tt-historico-embarque.embarque tt-historico-embarque.cod-itiner 
&Scoped-define ENABLED-TABLES tt-historico-embarque
&Scoped-define FIRST-ENABLED-TABLE tt-historico-embarque
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btOrdem btItem btFatura btVeiculo btQueryJoins ~
btReportsJoins btExit btHelp COMBO-BOX-1 FILL-IN-1 FILL-IN-2 FILL-IN-3 
&Scoped-Define DISPLAYED-FIELDS tt-historico-embarque.cod-estabel ~
tt-historico-embarque.embarque tt-historico-embarque.cod-itiner 
&Scoped-define DISPLAYED-TABLES tt-historico-embarque
&Scoped-define FIRST-DISPLAYED-TABLE tt-historico-embarque
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-1 FILL-IN-1 FILL-IN-2 FILL-IN-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCondPagto wMasterDetail 
FUNCTION fnCondPagto RETURNS CHARACTER
  ( INPUT p-cod-cond-pag AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescDecl wMasterDetail 
FUNCTION fnDescDecl RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescDesp wMasterDetail 
FUNCTION fnDescDesp RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricao wMasterDetail 
FUNCTION fnDescricao RETURNS CHARACTER
  (input pcod-estabel AS CHAR,
   input pembarque AS CHAR,
   input pcod-itiner AS INT,
   input pcod-pto-contr as integer) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDespComplRec wMasterDetail 
FUNCTION fnDespComplRec RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDiferenca wMasterDetail 
FUNCTION fnDiferenca RETURNS INTEGER
  (input dt-efetiva as date)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEmitente wMasterDetail 
FUNCTION fnEmitente RETURNS CHARACTER
  ( INPUT p-cod-emitente AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnIncoterm wMasterDetail 
FUNCTION fnIncoterm RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMoeda wMasterDetail 
FUNCTION fnMoeda RETURNS CHARACTER
  ( INPUT p-mo-codigo AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPtoSeq wMasterDetail 
FUNCTION fnPtoSeq RETURNS INTEGER ( INPUT p-cod-est AS CHAR,
    INPUT p-embarque AS CHAR,
    INPUT p-cod-itiner AS INT,
    input p-seq as int ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipoDesp wMasterDetail 
FUNCTION fnTipoDesp RETURNS CHARACTER
  ( INPUT p-cod-desp AS INT )  FORWARD.

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

DEFINE BUTTON btFatura 
     IMAGE-UP FILE "image\im-pcust":U
     IMAGE-INSENSITIVE FILE "image\ii-pcust":U
     LABEL "Fatura" 
     SIZE 4 BY 1.25 TOOLTIP "Faturas do Embarque"
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

DEFINE BUTTON btItem 
     IMAGE-UP FILE "image\im-item":U
     LABEL "Item" 
     SIZE 4 BY 1.25 TOOLTIP "Itens do Embarque"
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

DEFINE BUTTON btOrdem 
     IMAGE-UP FILE "image\im-forma":U
     IMAGE-INSENSITIVE FILE "image\ii-forma":U
     LABEL "Ordem" 
     SIZE 4 BY 1.25 TOOLTIP "Ordens do Embarque"
     FONT 4.

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

DEFINE BUTTON btVeiculo 
     IMAGE-UP FILE "image\im-carg":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Embarque / Ve¡culo".

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Encerrado","NÆo Encerrado" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999":U INITIAL 0 
     LABEL "Valor Embarque" 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Moeda" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.29.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-observacao 
     LABEL "Observa‡Æo" 
     SIZE 10 BY 1.

DEFINE BUTTON btn-filter-desp 
     IMAGE-UP FILE "image/filt-u95.bmp":U
     IMAGE-INSENSITIVE FILE "image/filt-i95.bmp":U
     LABEL "" 
     SIZE 4.14 BY 1.38.

DEFINE BUTTON btn-filter-decl 
     IMAGE-UP FILE "image/filt-u95.bmp":U
     IMAGE-INSENSITIVE FILE "image/filt-i95.bmp":U
     LABEL "" 
     SIZE 4.14 BY 1.38.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-historico-embarque2 SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-desp-embarque SCROLLING.

DEFINE QUERY brSon3 FOR 
      tt-decl-hist-embarq-imp SCROLLING.

DEFINE QUERY brSon4 FOR 
      tt-antecip-import SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 DISPLAY
      tt-historico-embarque2.sequencia FORMAT ">>9":U
      tt-historico-embarque2.cod-pto-contr FORMAT ">>,>>9":U
      fnDescricao(input tt-historico-embarque2.cod-estabel,
input tt-historico-embarque2.embarque,
input tt-historico-embarque2.cod-itiner,
input tt-historico-embarque2.cod-pto-contr) @ cDescricao COLUMN-LABEL "Descri‡Æo" FORMAT "x(25)":U
      tt-historico-embarque2.dt-previsao FORMAT "99/99/9999":U
      tt-historico-embarque2.dt-ult-previsao FORMAT "99/99/9999":U
      tt-historico-embarque2.dt-efetiva FORMAT "99/99/9999":U
      fnDiferenca(input tt-historico-embarque2.dt-efetiva) @ cDiferenca COLUMN-LABEL "Diferen‡a" FORMAT "->>>>>9":U
      tt-historico-embarque2.id-meio-transp FORMAT "x(20)":U
      tt-historico-embarque2.nr-dias FORMAT ">,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.04
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _FREEFORM
  QUERY brSon2 NO-LOCK DISPLAY
      tt-desp-embarque.cod-pto-contr FORMAT ">>,>>9":U
      fnDescricao(tt-desp-embarque.cod-estabel, tt-desp-embarque.embarque, tt-desp-embarque.cod-itiner, tt-desp-embarque.cod-pto-contr) @ cDescricao COLUMN-LABEL "Descri‡Æo" FORMAT "x(30)"
      tt-desp-embarque.cod-emitente-desp FORMAT ">>>>>>>>9":U
      fnEmitente(tt-desp-embarque.cod-emitente-desp) @ cNomeAbrev COLUMN-LABEL "Nome Abrev"
      tt-desp-embarque.cod-desp FORMAT ">>,>>9":U
      fnDescDesp() @ tt-desp-embarque.descricao FORMAT "x(30)":U  COLUMN-LABEL "Descri‡Æo"
      tt-desp-embarque.val-desp FORMAT ">>>>>,>>>,>>9.99999":U
      tt-desp-embarque.cod-cond-pag FORMAT ">>>9":U
      fnCondPagto(tt-desp-embarque.cod-cond-pag) @ cCondPagto COLUMN-LABEL "Descri‡Æo"
      tt-desp-embarque.mo-codigo FORMAT ">9":U
      fnMoeda(tt-desp-embarque.mo-codigo) @ cMoDesc COLUMN-LABEL "Descri‡Æo"
      fnTipoDesp(tt-desp-embarque.cod-desp) @ cTipoDesp COLUMN-LABEL "Tipo de Despesa"
      fnIncoterm() @ cIncoterm FORMAT "x(3)" COLUMN-LABEL "Incoterm de Rateio"
      fnDespComplRec() @ cDespComplRec COLUMN-LABEL "Recebida?"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 79.29 BY 9.04 FIT-LAST-COLUMN.

DEFINE BROWSE brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon3 wMasterDetail _FREEFORM
  QUERY brSon3 NO-LOCK DISPLAY
      tt-decl-hist-embarq-imp.sequencia FORMAT ">>9":U
fnPtoSeq({&ttSon3}.cod-estabel, {&ttSon3}.embarque, {&ttSon3}.cod-itiner, {&ttSon3}.sequencia) @ iPtoContr COLUMN-LABEL "Pto Contr"
fnDescricao(input {&ttSon3}.cod-estabel, input {&ttSon3}.embarque, input {&ttSon3}.cod-itiner, input 
            fnPtoSeq({&ttSon3}.cod-estabel, {&ttSon3}.embarque, {&ttSon3}.cod-itiner, {&ttSon3}.sequencia)) @ cDescricao FORMAT "x(30)" COLUMN-LABEL "Descri‡Æo Pto Contr"
tt-decl-hist-embarq-imp.de-codigo FORMAT ">>,>>9":U
fnDescDecl() @ tt-decl-hist-embarq-imp.descricao COLUMN-LABEL "Descri‡Æo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 79.29 BY 9.04 FIT-LAST-COLUMN.

DEFINE BROWSE brSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon4 wMasterDetail _STRUCTURED
  QUERY brSon4 NO-LOCK DISPLAY
      tt-antecip-import.cdd-id-antecip COLUMN-LABEL "ID" FORMAT ">>>,>>>,>>9":U
            WIDTH 12
      tt-antecip-import.cod-refer-antecip-ap COLUMN-LABEL "Referˆncia" FORMAT "x(10)":U
            WIDTH 14
      tt-antecip-import.cod-estab-ap COLUMN-LABEL "Estab" FORMAT "x(5)":U
            WIDTH 7
      tt-antecip-import.cod-espec-docto-ap COLUMN-LABEL "Esp‚cie" FORMAT "x(3)":U
            WIDTH 5
      tt-antecip-import.cod-ser-docto-ap COLUMN-LABEL "S‚rie" FORMAT "x(5)":U
            WIDTH 7
      tt-antecip-import.cod-tit-ap COLUMN-LABEL "T¡tulo" FORMAT "x(10)":U
            WIDTH 14
      tt-antecip-import.cod-parc-ap COLUMN-LABEL "Parc" FORMAT "x(2)":U
            WIDTH 3
      tt-antecip-import.cdn-emitente-ap COLUMN-LABEL "Fornecedor" FORMAT ">>>>>>>>9":U
            WIDTH 12
      tt-antecip-import.nom-abrev-ap FORMAT "x(15)":U WIDTH 18
      tt-antecip-import.cod-moed-ap COLUMN-LABEL "Moeda" FORMAT "x(8)":U
            WIDTH 10
      tt-antecip-import.val-vinc-embarq COLUMN-LABEL "Valor Vinculado" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 15
      tt-antecip-import.dat-transacao COLUMN-LABEL "Data Transa‡Æo" FORMAT "99/99/9999":U
            WIDTH 12
      tt-antecip-import.val-cotac-tit FORMAT ">>>>,>>9.9999999999":U
            WIDTH 20
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 84 BY 10.25 FIT-LAST-COLUMN.


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
     btOrdem AT ROW 1.13 COL 31 HELP
          "Ordens de Compra"
     btItem AT ROW 1.13 COL 35 HELP
          "Pedidos de Compra"
     btFatura AT ROW 1.13 COL 39 HELP
          "Faturas do Embarque"
     btVeiculo AT ROW 1.13 COL 43.14
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-historico-embarque.cod-estabel AT ROW 2.92 COL 26.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-historico-embarque.embarque AT ROW 2.92 COL 55.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     COMBO-BOX-1 AT ROW 3.92 COL 26.14 COLON-ALIGNED
     tt-historico-embarque.cod-itiner AT ROW 3.92 COL 55.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     FILL-IN-1 AT ROW 4.92 COL 26.14 COLON-ALIGNED
     FILL-IN-2 AT ROW 4.92 COL 55.14 COLON-ALIGNED
     FILL-IN-3 AT ROW 4.92 COL 60.14 COLON-ALIGNED NO-LABEL
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 17.13
         FONT 1.

DEFINE FRAME fPage4
     brSon4 AT ROW 1.25 COL 2 WIDGET-ID 600
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 7
         SIZE 86 BY 10.75 WIDGET-ID 500.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.13 COL 1.72
     bt-observacao AT ROW 10.33 COL 1.72
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.17
         SIZE 84.57 BY 10.42
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.13 COL 1.72 WIDGET-ID 300
     btn-filter-desp AT ROW 1.13 COL 81 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.17
         SIZE 84.57 BY 10.42 WIDGET-ID 100.

DEFINE FRAME fPage3
     brSon3 AT ROW 1.13 COL 1.72 WIDGET-ID 400
     btn-filter-decl AT ROW 1.13 COL 81 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.17
         SIZE 84.57 BY 10.42 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-antecip-import T "?" NO-UNDO mgcad antecip-import
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-decl-hist-embarq-imp T "?" NO-UNDO mgcex decl-hist-embarq-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-desp-embarque T "?" NO-UNDO mgcex desp-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-historico-embarque T "?" NO-UNDO mgcex historico-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-historico-embarque2 T "?" NO-UNDO mgcex historico-embarque
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
         HEIGHT             = 17.38
         WIDTH              = 90.43
         MAX-HEIGHT         = 17.67
         MAX-WIDTH          = 90.43
         VIRTUAL-HEIGHT     = 17.67
         VIRTUAL-WIDTH      = 90.43
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
       FRAME fPage3:FRAME = FRAME fPage0:HANDLE
       FRAME fPage4:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
ASSIGN 
       btVeiculo:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brSon3 1 fPage3 */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB brSon4 1 fPage4 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.tt-historico-embarque2"
     _FldNameList[1]   > Temp-Tables.tt-historico-embarque2.sequencia
"tt-historico-embarque2.sequencia" ? ">>9" "" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-historico-embarque2.cod-pto-contr
"tt-historico-embarque2.cod-pto-contr" ? ">>,>>9" "" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fnDescricao(input tt-historico-embarque2.cod-estabel,
input tt-historico-embarque2.embarque,
input tt-historico-embarque2.cod-itiner,
input tt-historico-embarque2.cod-pto-contr) @ cDescricao" "Descri‡Æo" "x(25)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-historico-embarque2.dt-previsao
"tt-historico-embarque2.dt-previsao" ? "99/99/9999" "" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-historico-embarque2.dt-ult-previsao
"tt-historico-embarque2.dt-ult-previsao" ? "99/99/9999" "" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-historico-embarque2.dt-efetiva
"tt-historico-embarque2.dt-efetiva" ? "99/99/9999" "" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fnDiferenca(input tt-historico-embarque2.dt-efetiva) @ cDiferenca" "Diferen‡a" "->>>>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-historico-embarque2.id-meio-transp
"tt-historico-embarque2.id-meio-transp" ? "x(20)" "" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-historico-embarque2.nr-dias
"tt-historico-embarque2.nr-dias" ? ">,>>9.99" "" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-desp-embarque NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon3
/* Query rebuild information for BROWSE brSon3
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-decl-hist-embarq-imp NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSon3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon4
/* Query rebuild information for BROWSE brSon4
     _TblList          = "Temp-Tables.tt-antecip-import"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-antecip-import.cdd-id-antecip
"cdd-id-antecip" "ID" ? "decimal" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-antecip-import.cod-refer-antecip-ap
"cod-refer-antecip-ap" "Referˆncia" ? "character" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-antecip-import.cod-estab-ap
"cod-estab-ap" "Estab" ? "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-antecip-import.cod-espec-docto-ap
"cod-espec-docto-ap" "Esp‚cie" ? "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-antecip-import.cod-ser-docto-ap
"cod-ser-docto-ap" "S‚rie" ? "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-antecip-import.cod-tit-ap
"cod-tit-ap" "T¡tulo" ? "character" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-antecip-import.cod-parc-ap
"cod-parc-ap" "Parc" ? "character" ? ? ? ? ? ? no ? no no "3" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-antecip-import.cdn-emitente-ap
"cdn-emitente-ap" "Fornecedor" ? "integer" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-antecip-import.nom-abrev-ap
"nom-abrev-ap" ? ? "character" ? ? ? ? ? ? no ? no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-antecip-import.cod-moed-ap
"cod-moed-ap" "Moeda" ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-antecip-import.val-vinc-embarq
"val-vinc-embarq" "Valor Vinculado" ? "decimal" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-antecip-import.dat-transacao
"dat-transacao" "Data Transa‡Æo" ? "date" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tt-antecip-import.val-cotac-tit
"val-cotac-tit" ? ? "decimal" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon4 */
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
&Scoped-define SELF-NAME bt-observacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-observacao wMasterDetail
ON CHOOSE OF bt-observacao IN FRAME fPage1 /* Observa‡Æo */
DO:
    RUN imp/im0555ob.w (input {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.r-rowid).

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


&Scoped-define SELF-NAME btFatura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFatura wMasterDetail
ON CHOOSE OF btFatura IN FRAME fPage0 /* Fatura */
DO:
    RUN imp/im0545c.w (input tt-historico-embarque.cod-estabel,input tt-historico-embarque.embarque).
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


&Scoped-define SELF-NAME btItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btItem wMasterDetail
ON CHOOSE OF btItem IN FRAME fPage0 /* Item */
DO:
  RUN imp/im0545b.w (input tt-historico-embarque.cod-estabel,input tt-historico-embarque.embarque).
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


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btn-filter-decl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-filter-decl wMasterDetail
ON CHOOSE OF btn-filter-decl IN FRAME fPage3
DO:
    RUN showFilter(INPUT 3).
    RUN openQueryDeclHistEmbarqImp IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btn-filter-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-filter-desp wMasterDetail
ON CHOOSE OF btn-filter-desp IN FRAME fPage2
DO:
    RUN showFilter(INPUT 2).
    RUN openQueryDespEmbarque IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    
    DEFINE VARIABLE cReturn AS CHARACTER NO-UNDO.
    def var ttrowid as rowid no-undo.
        
    for each RowErrors:
        delete RowErrors.
    end.
    assign ttrowid = {&ttParent}.r-rowid.
    
    RUN findNext2 IN {&hDBOParent} (OUTPUT cReturn).
    IF cReturn = "":U THEN DO:
        RUN getCurrent IN {&hDBOParent} (OUTPUT TABLE {&ttParent}).
        RUN displayFields IN THIS-PROCEDURE.
    END.
    ELSE DO:
         run utp/ut-msgs.p (input "msg",
                            input 7999,
                            input "").
         create RowErrors.
         assign RowErrors.errornumber   = 7999
                RowErrors.errordescription  = return-value.
         RUN findRowid in {&hDBOParent} (input ttrowid).
         if cReturn = "" then 
            RUN setCurrent in {&hDBOParent}.
    END.
    IF CAN-FIND(FIRST RowErrors) THEN DO:
       disable btLast btNext with frame fPage0.
       IF NOT VALID-HANDLE(hShowMsg) THEN
          RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
       ELSE
          DELETE PROCEDURE hShowMsg.
         
       RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
          
       LEAVE.
    END.
    
    enable btFirst btPrev with frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOrdem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOrdem wMasterDetail
ON CHOOSE OF btOrdem IN FRAME fPage0 /* Ordem */
DO:
    RUN imp/im0545a.w (input tt-historico-embarque.cod-estabel, input tt-historico-embarque.embarque).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    DEFINE VARIABLE cReturn AS CHARACTER NO-UNDO.
    def var ttrowid as rowid no-undo.
    
    for each RowErrors:
        delete RowErrors.
    end.
    assign ttrowid = {&ttParent}.r-rowid.
    RUN findPrev2 IN {&hDBOParent} (OUTPUT cReturn).
    IF cReturn = "":U THEN DO:
        RUN getCurrent IN {&hDBOParent} (OUTPUT TABLE {&ttParent}).
        RUN displayFields IN THIS-PROCEDURE.
    END.
    ELSE DO:
         run utp/ut-msgs.p (input "msg",
                            input 7998,
                            input "").
         create RowErrors.
         assign RowErrors.errornumber   = 7998
                RowErrors.errordescription  = return-value.
         RUN findRowid in {&hDBOParent} (input ttrowid).
         if cReturn = "" then 
            RUN setCurrent in {&hDBOParent}.
    END.
    IF CAN-FIND(FIRST RowErrors) THEN DO:
       disable btPrev btFirst with frame fPage0.
       IF NOT VALID-HANDLE(hShowMsg) THEN
          RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
       ELSE
          DELETE PROCEDURE hShowMsg.
         
       RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
          
       LEAVE.
    END.
    
    enable btLast btNext with frame fPage0.
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
    {method/zoomreposition.i &ProgramZoom="cxzoom/z10cx230.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVeiculo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVeiculo wMasterDetail
ON CHOOSE OF btVeiculo IN FRAME fPage0
DO:
    run eqp/eq1002.w persistent set h-eq1002.
    
    run recebeEstabelecimentoEmbarque in h-eq1002 (input input frame fPage0 tt-historico-embarque.cod-estabel,
                                                   input input frame fPage0 tt-historico-embarque.embarque).
    run initializeInterface in h-eq1002.
    
    {&WINDOW-NAME}:SENSITIVE = NO.

     RUN InitializeInterface IN h-eq1002 NO-ERROR.
     IF RETURN-VALUE = "NOK":U THEN DO:
        {&WINDOW-NAME}:SENSITIVE = YES.
        RETURN NO-APPLY.
     END.

     RUN beforeDisplayFields IN h-eq1002 NO-ERROR.

     WAIT-FOR CLOSE OF h-eq1002 FOCUS CURRENT-WINDOW.
     {&WINDOW-NAME}:SENSITIVE = YES.

     IF VALID-HANDLE(h-eq1002) THEN
         DELETE PROCEDURE h-eq1002.
     ASSIGN h-eq1002 = ?.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DELETE PROCEDURE h-bocx2301.
    DELETE PROCEDURE h-bocx2302.
    DELETE PROCEDURE h-bocx1102.
    DELETE PROCEDURE h-bocx220.
    DELETE PROCEDURE h-boun005.
    DELETE PROCEDURE h-bocx230.

    IF VALID-HANDLE({&hDBOSon1}) THEN DO:
        DELETE PROCEDURE {&hDBOSon2}.
        ASSIGN {&hDBOSon2} = ?.
    END.

    IF VALID-HANDLE({&hDBOSon3}) THEN DO:
        DELETE PROCEDURE {&hDBOSon3}.
        ASSIGN {&hDBOSon3} = ?.
    END.

    IF VALID-HANDLE({&hDBOSon4}) THEN DO:
        DELETE PROCEDURE {&hDBOSon4}.
        ASSIGN {&hDBOSon4} = ?.
    END.

    IF VALID-HANDLE(h-bocx2303) THEN DO:
        DELETE PROCEDURE h-bocx2303.
        ASSIGN h-bocx2303 = ?.
    END.

    IF VALID-HANDLE(h-boad098)  THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.
    IF VALID-HANDLE(h-bocx095)  THEN DO:
        DELETE PROCEDURE h-bocx095.
        ASSIGN h-bocx095 =  ?.
    END.
    IF VALID-HANDLE(h-boad039)  THEN DO:
        DELETE PROCEDURE h-boad039.
        ASSIGN h-boad039 = ?.
    END.
    IF VALID-HANDLE(h-bocx3101) THEN DO:
        DELETE PROCEDURE h-bocx3101.
        ASSIGN h-bocx3101 = ?.
    END.
    IF VALID-HANDLE(h-bocx010) THEN DO:
        DELETE PROCEDURE h-bocx010.
        ASSIGN h-bocx010 = ?.
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
    APPLY "LEAVE":U TO fill-in-2 IN FRAME fPage0.
    
    def var c-return as char no-undo.
    DEF VAR i-mo-codigo AS INT NO-UNDO.
    DEF VAR de-valor-embarque AS DECIMAL NO-UNDO.
    DEF VAR c-desc-moeda AS CHAR NO-UNDO.
    if avail tt-historico-embarque then do:

        RUN findCh_embarque in h-bocx220 (input tt-historico-embarque.cod-estabel,
                                          input tt-historico-embarque.embarque,
                                          output c-return).
        if  c-return = "" then do:
            RUN getIntField in h-bocx220 (input "situacao", output i-sit-embarque).
            run retornaMoedaValor in h-bocx220 (input tt-historico-embarque.embarque,
                                                input tt-historico-embarque.cod-estabel,
                                                output de-valor-embarque,
                                                output i-mo-codigo).
            
            assign fill-in-2:screen-value in frame fPage0 = string(i-mo-codigo).            
            assign fill-in-1:screen-value in frame fPage0 = string(de-valor-embarque).

        end.

        RUN findCodigo IN h-boun005 (INPUT i-mo-codigo, OUTPUT c-return).
        IF c-return = "" THEN DO:
        
            RUN getcharfield IN h-boun005 ("descricao", OUTPUT c-desc-moeda).
            ASSIGN fill-in-3:SCREEN-VALUE IN FRAM fPage0 = c-desc-moeda.
        END.

           assign combo-box-1 = {cxinc/i01cx220.i 04 i-sit-embarque}.
        
        disp combo-box-1 
            with frame fPage0.
             
    

        /* alterado para posicionar os mesmos registros desse programa nos
           programas Embarques (im0045) e Consulta de Embarques (im0545) */
        IF NOT gl-im0044 THEN DO:
            IF c-embarque-imp = c-embarque THEN DO:
                /*Busca os registros do programa im0045 e im0545
                  e armazena nas vari veis passadas como parƒmetro*/
                RUN trazembarque IN h-bocx220 (INPUT gr-embarque-imp,
                                               OUTPUT c-cod-estabel-imp,
                                               OUTPUT c-embarque-imp).
            END.
            
            IF c-embarque-imp <> "" AND c-embarque-imp <> c-embarque THEN DO:
                ASSIGN c-embarque            = c-embarque-imp
                       c-cod-estabelecimento = c-cod-estabel-imp.
            END.
    
            ELSE DO:
                IF c-embarque-imp = "" AND
                   c-embarque-imp <> tt-historico-embarque.embarque AND
                   c-embarque-imp <> c-embarque THEN DO:
                END.
                
                ELSE DO:
                    ASSIGN  c-cod-estabelecimento = tt-historico-embarque.cod-estabel
                            c-embarque            = tt-historico-embarque.embarque.
                END.
            END.
    
            IF c-embarque <> c-embarque-imp THEN DO:
                RUN rowidembarque IN h-bocx220 (INPUT c-cod-estabelecimento,
                                                INPUT c-embarque,
                                                OUTPUT gr-embarque-imp).
                ASSIGN c-cod-estabel-imp = c-cod-estabelecimento
                       c-embarque-imp    = c-embarque.
    
            END.
    
            IF c-embarque <> tt-historico-embarque.embarque THEN DO:
                    ASSIGN tt-historico-embarque.embarque    = c-embarque
                           tt-historico-embarque.cod-estabel = c-cod-estabelecimento.
                    RUN displayFields IN THIS-PROCEDURE.
                            
            END.
        END.

    end.        
 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: InclusÆo dessa procedure para posicionar os mesmos registros nos 
         programas Embarques (im0045) e Consulta de Embarques (im0545)
------------------------------------------------------------------------------*/
    DEF VAR r-historico-embarque AS ROWID NO-UNDO.
    DEF VAR c-return             AS CHAR  NO-UNDO.
    RUN getRowid IN {&hDBOParent} (OUTPUT r-historico-embarque).
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-historico-embarque).
    
    IF c-return = ""  THEN DO:
        RUN getCurrent IN {&hDBOParent} (OUTPUT TABLE {&ttParent}).
        RUN displayFields IN THIS-PROCEDURE.
    END.

    ASSIGN btprev:SENSITIVE IN FRAME {&FRAME-NAME} = YES
           btfirst:SENSITIVE IN FRAME {&FRAME-NAME} = YES
           btn-filter-desp:SENSITIVE IN FRAME fPage2 = YES
           btn-filter-decl:SENSITIVE IN FRAME fPage3 = YES.

    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
        find first param-global no-lock no-error.
        if avail param-global then do:
            if param-global.log-modul-eq  = yes THEN DO:
               assign btVeiculo:hidden = no.
               enable btVeiculo with frame fPage0.
            END.
        end.
    &ENDIF

    /*O folder "Antecipa‡Æo" somente ficar  dispon¡vel quando a fun‡Æo "ifric22" estiver habilitada*/
    IF NOT CAN-FIND(FIRST funcao
                    WHERE funcao.cd-funcao = "spp-ifric22":U AND funcao.ativo) THEN DO:
        RUN deleteFolder IN hFolder (INPUT 4).
        RUN setFolder    IN hFolder (INPUT 1).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyEnd wMasterDetail 
PROCEDURE applyEnd :
/*------------------------------------------------------------------------------
  Purpose:     Sobrepoe procedure referente ao applyEnd da include padrÆo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyOffEnd wMasterDetail 
PROCEDURE applyOffEnd :
/*------------------------------------------------------------------------------
  Purpose:     Sobrepoe procedure applyOffEnd da include padrÆo
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
         SIZE 35 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE cStatus AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE ccod-estabel like historico-embarque.cod-estabel NO-UNDO.
    DEFINE VARIABLE iembarque    like historico-embarque.embarque NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        ccod-estabel AT ROW 1.21 COL 15 COLON-ALIGNED
        iembarque AT ROW 2.21 COL 15 COLON-ALIGNED
        btGoToOK      AT ROW 3.63 COL 2.14
        btGoToCancel  AT ROW 3.63 COL 13
        rtGoToButton  AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE FONT 1 TITLE "V  Para Histor Embarque"
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Histor_Embarque"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN ccod-estabel iembarque.
        
        &IF DEFINED(DBOVersion) <> 0 &THEN
           RUN findEmbarque IN {&hDBOParent} (INPUT ccod-estabel, 
                                              INPUT iembarque,
                                              OUTPUT cStatus).
           IF cStatus <> "":U THEN DO:
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Hist¢rico_Embarque" *}
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
    
    assign ccod-estabel:width = 4
           iembarque:width = 16.
    
    ENABLE ccod-estabel iembarque btGoToOK btGoToCancel 
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
    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:
       RUN cxbo/bocx230a.p persistent set h-bocx230.
    END.    
    
    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOParent} (INPUT 1).
    &ELSE
        RUN openQueryStatic IN {&hDBOParent} (INPUT "ccod-estabel":U).
    &ENDIF
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) THEN DO:
       RUN cxbo/bocx230a.p persistent set h-bocx2302.
    END.

    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) THEN DO:
       RUN cxbo/bocx310.p persistent set {&hDBOSon2}.
    END.

    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon3}) THEN DO:
       RUN cxbo/bocx280.p persistent set {&hDBOSon3}.
    END.

    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon4}) THEN DO:
       RUN cxbo/bocx00451.p persistent set {&hDBOSon4}.
    END.

    IF NOT VALID-HANDLE(h-bocx2303) THEN DO:
        RUN cxbo/bocx230.p PERSISTENT SET h-bocx2303.
    END.

    IF NOT VALID-HANDLE(h-boad098) THEN
        RUN adbo/boad098.p PERSISTENT SET h-boad098.
    IF NOT VALID-HANDLE(h-bocx095) THEN
        RUN cxbo/bocx095.p PERSISTENT SET h-bocx095.
    IF NOT VALID-HANDLE(h-boad039) THEN
        RUN adbo/boad039.p PERSISTENT SET h-boad039.
    IF NOT VALID-HANDLE(h-bocx3101) THEN
        RUN cxbo/bocx310.p PERSISTENT SET h-bocx3101.
    IF NOT VALID-HANDLE(h-bocx010) THEN 
        RUN cxbo/bocx010.p PERSISTENT SET h-bocx010.

    
    RUN cxbo/bocx230.p PERSISTENT SET h-bocx2301.
    RUN cxbo/bocx110.p persistent set h-bocx1102.
    RUN cxbo/bocx220.p persistent set h-bocx220.
    RUN unbo/boun005.p persistent set h-boun005.
    
    enable btOrdem btItem btFatura with frame fPage0.    
    enable bt-observacao with frame fPage1.

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
    
   DEFINE VARIABLE cembarque    LIKE embarque-imp.embarque no-undo.
   DEFINE VARIABLE ccod-estabel as char    NO-UNDO.
   DEFINE VARIABLE icod-itiner  as integer NO-UNDO.

   IF AVAILABLE tt-historico-embarque THEN DO:
        ASSIGN ccod-estabel = tt-historico-embarque.cod-estabel
               cembarque    = tt-historico-embarque.embarque
               icod-itiner  = tt-historico-embarque.cod-itiner.
        {masterdetail/OpenQueriesSon.i
                  &Parent="tt-historico-embarque"
                  &Query="Embarque"
                  &PageNumber="1"
                  &QueryConstraint="4"
                  &ConstraintParameters="tt-historico-embarque.r-rowid, ccod-estabel, icod-itiner, cembarque"}
        
        RUN openQueryDespEmbarque IN THIS-PROCEDURE.
        RUN openQueryDeclHistEmbarqImp IN THIS-PROCEDURE.
        /* NÆo foi utilizada a procedure openqueriesson devido a incompatibilidade da versÆo da DBO.
           No programa foi definida a DBO version 1.1, por‚m a bocx00451 ‚ versÆo 2.0 */
        RUN openQueryAntecipImport IN THIS-PROCEDURE.

    END.
    ELSE
        ASSIGN ccod-estabel = ?
               cembarque = ?
               icod-itiner = 0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAntecipImport wMasterDetail 
PROCEDURE openQueryAntecipImport :
/*------------------------------------------------------------------------------
  Purpose:     Abrir a query do browser da p gina de Antecipa‡äes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN linkToEmbarque IN {&hDBOSon4} (INPUT {&hDBOParent}).

    /*--- Abre query do DBO filho ---*/
    RUN openQueryStatic IN {&hDBOSon4} (INPUT "ByEmbarque":U).

    /*--- Retorna faixa de registro do DBO Filho ---*/
    RUN getBatchRecords IN {&hDBOSon4} (INPUT IF iRepositionPageNumber = 4
                                                  THEN rRepositionSon
                                                  ELSE ?,
                                        INPUT NO,
                                        INPUT &IF defined(numRowsReturned) &then {&numRowsReturned}
                                              &ELSE 40 &endif,
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-antecip-import).

    /*--- Abre a query associada ao browse da p gina 4 ---*/
    {&OPEN-QUERY-{&page4browse}}
    APPLY "VALUE-CHANGED":U TO BROWSE {&page4browse}.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDeclHistEmbarqImp wMasterDetail 
PROCEDURE openQueryDeclHistEmbarqImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-pto AS INTEGER     NO-UNDO.
    
    /*--- Faz a liga‡Æo entre o DBO filho e o DBO pai, atrav‚s do uso de uma
          restri‡Æo (constraint) ---*/
    RUN setConstraint2 IN {&hDBOSon3} (INPUT {&ttParent}.r-rowid).
    
    /*--- Abre query do DBO filho ---*/
    RUN openQuery IN {&hDBOSon3} (INPUT 3).
    
    /*--- Posiciona DBO filho no primeiro registro, caso necess rio ---*/
    IF iRepositionPageNumber = 0 THEN
        RUN findFirst IN {&hDBOSon3}.

    /*--- Retorna faixa de registro do DBO Filho ---*/
    RUN serverSendRows IN {&hDBOSon3} (INPUT ?,
                                       INPUT IF iRepositionPageNumber = 3 THEN STRING(rRepositionSon) ELSE ?,
                                       INPUT NO,
                                       INPUT &IF defined(numRowsReturned) &then {&numRowsReturned}
                                             &ELSE 40 &endif,
                                       OUTPUT iRowsReturned,
                                       OUTPUT TABLE {&ttSon3}).
    FOR EACH {&ttSon3}:
        ASSIGN i-pto = fnPtoSeq({&ttSon3}.cod-estabel, {&ttSon3}.embarque, {&ttSon3}.cod-itiner, {&ttSon3}.sequencia).
        IF i-pto < i-pto-decl-ini THEN DELETE {&ttSon3}.
        IF i-pto > i-pto-decl-fim THEN DELETE {&ttSon3}.
    END.

    {&OPEN-QUERY-{&page3browse}}
    APPLY "VALUE-CHANGED":U TO BROWSE {&page3browse}.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDespEmbarque wMasterDetail 
PROCEDURE openQueryDespEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {masterdetail/OpenQueriesSon.i
        &Parent="{&ttParent}"
        &Query="despesa"
        &PageNumber="2"
        &QueryConstraint="6"
        &QueryNumber="6"
        &ConstraintParameters="{&ttParent}.r-rowid, i-pto-desp-ini, i-pto-desp-fim"}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRowid wMasterDetail 
PROCEDURE setRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param ccod-estabel as char no-undo.
    def input param cembarque LIKE embarque-imp.embarque no-undo.
    def input param icod-itiner as int no-undo.
    
    assign c-cod-estabel = ccod-estabel
           c-embarque = cembarque
           i-cod-itiner = icod-itiner.  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showFilter wMasterDetail 
PROCEDURE showFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM i-page AS INTEGER NO-UNDO.

    DEFINE BUTTON btCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtAbreFiltro
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 35 BY 1.42
         BGCOLOR 7.   

    DEFINE IMAGE setaFirst
         FILENAME "image/im-fir.bmp":U
         SIZE 3 BY 1.
    
    DEFINE IMAGE setaLast
         FILENAME "image/im-las.bmp":U
         SIZE 3 BY 1.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.    
    DEFINE VARIABLE i-pto-ini LIKE historico-embarque.cod-pto-contr  NO-UNDO.  
    DEFINE VARIABLE i-pto-fim LIKE historico-embarque.cod-pto-contr NO-UNDO.
    
    DEFINE FRAME fAbreFiltro
        i-pto-ini AT ROW 1.8 COL 9 COLON-ALIGNED
        setaFirst AT ROW 1.8 COL 17 COLON-ALIGNED
        setaLast  AT ROW 1.8 COL 21 COLON-ALIGNED
        i-pto-fim AT ROW 1.8 COL 25 COLON-ALIGNED NO-LABEL
        btOK        AT ROW 3.6 COL 2.14
        btCancel    AT ROW 3.6 COL 13
        rtAbreFiltro    AT ROW 3.4 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Filtrar" FONT 1 WIDTH 35
             DEFAULT-BUTTON btOK CANCEL-BUTTON btCancel.

    ASSIGN i-pto-ini:SCREEN-VALUE IN FRAME fAbreFiltro = IF i-page = 2 THEN STRING(i-pto-desp-ini) ELSE IF i-page = 3 THEN STRING(i-pto-decl-ini) ELSE "0"
           i-pto-fim:SCREEN-VALUE IN FRAME fAbreFiltro = IF i-page = 2 THEN STRING(i-pto-desp-fim) ELSE IF i-page = 3 THEN STRING(i-pto-decl-fim) ELSE "99999".

    ON "CHOOSE":U OF btOK IN FRAME fAbreFiltro DO:
        ASSIGN i-pto-ini
               i-pto-fim.
        IF i-page = 2 THEN DO:
            ASSIGN i-pto-desp-ini = i-pto-ini
                   i-pto-desp-fim = i-pto-fim.
        END.
        ELSE IF i-page = 3 THEN DO:
            ASSIGN i-pto-decl-ini = i-pto-ini
                   i-pto-decl-fim = i-pto-fim.
        END.
    END.
    
    ENABLE i-pto-ini
           i-pto-fim
           btOK btCancel 
        WITH FRAME fAbreFiltro.

    ASSIGN i-pto-ini:HEIGHT = 0.88
           i-pto-ini:WIDTH  = 7.
    {utp/ut-liter.i "Pto Contr"}
    ASSIGN i-pto-ini:LABEL     = TRIM(RETURN-VALUE).

    ASSIGN i-pto-fim:HEIGHT = 0.88
           i-pto-fim:WIDTH  = 7.
    
    WAIT-FOR "GO":U OF FRAME fAbreFiltro.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCondPagto wMasterDetail 
FUNCTION fnCondPagto RETURNS CHARACTER
  ( INPUT p-cod-cond-pag AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-cond-pagto AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-return     AS CHARACTER   NO-UNDO.

    run findCodigo in h-boad039 (input p-cod-cond-pag, output c-return).
    if c-return = "":U then
        run getCharfield in h-boad039 (input "descricao":U, output c-cond-pagto).

    RETURN c-cond-pagto.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescDecl wMasterDetail 
FUNCTION fnDescDecl RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc-decl   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-return      AS CHARACTER   NO-UNDO.

    ASSIGN c-desc-decl = {&ttSon3}.descricao.

    IF TRIM(c-desc-decl) = "":U THEN DO:
        RUN findPk_de_codigo in h-bocx010 (input {&ttSon3}.de-codigo, output c-return).
        RUN getCharField in h-bocx010 (input "descricao", output c-desc-decl).
    END.

    RETURN c-desc-decl.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescDesp wMasterDetail 
FUNCTION fnDescDesp RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desp-imp AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-return   AS CHARACTER   NO-UNDO.
    
    ASSIGN c-desp-imp = tt-desp-embarque.descricao.
    IF c-desp-imp = "" THEN DO:
        run findCodigo in h-bocx095 (input tt-desp-embarque.cod-desp, output c-return).
        if c-return = "" then
            run getCharfield in h-bocx095 (input "descricao":U,output c-desp-imp).
    END.

  RETURN c-desp-imp.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricao wMasterDetail 
FUNCTION fnDescricao RETURNS CHARACTER
  (input pcod-estabel AS CHAR,
   input pembarque AS CHAR,
   input pcod-itiner AS INT,
   input pcod-pto-contr as integer):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-descricao AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-return    AS CHARACTER NO-UNDO.

    RUN findCh-itiner IN h-bocx2303(INPUT pcod-estabel,  
                                    INPUT pembarque,  
                                    INPUT pcod-itiner,                                                 
                                    INPUT pcod-pto-contr,                                               
                                    OUTPUT c-return).
    IF TRIM(c-return) = "":U THEN
        RUN getCharField in h-bocx2303 (input "descricao":U, output c-descricao).

    IF TRIM(c-descricao) = "":U THEN DO:
        RUN findCodigo IN h-bocx1102 (INPUT pcod-pto-contr, OUTPUT c-return).
        IF TRIM(c-return) = "":U THEN
            RUN getCharField IN h-bocx1102 (INPUT "descricao":U, OUTPUT c-descricao).  
    END. 

  RETURN c-descricao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDespComplRec wMasterDetail 
FUNCTION fnDespComplRec RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desp-compl-rec AS CHARACTER   NO-UNDO.
    run piRetornaSitDespesa in h-bocx3101 (input  tt-desp-embarque.embarque,
                                           input  tt-desp-embarque.cod-estabel,
                                           input  tt-desp-embarque.cod-itiner,
                                           input  tt-desp-embarque.cod-pto-contr,
                                           input  tt-desp-embarque.cod-desp,
                                           input  tt-desp-embarque.cod-emitente-desp,
                                           output c-desp-compl-rec) no-error.
    IF c-desp-compl-rec = "?":U THEN
        ASSIGN c-desp-compl-rec = "":U.

    RETURN c-desp-compl-rec.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDiferenca wMasterDetail 
FUNCTION fnDiferenca RETURNS INTEGER
  (input dt-efetiva as date) :
  def var num-dif as integer no-undo.
  
  if dt-efetiva <> ? then 
     assign num-dif = dt-efetiva - tt-historico-embarque2.dt-previsao.
  else assign num-dif = 0.
  
  RETURN num-dif.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEmitente wMasterDetail 
FUNCTION fnEmitente RETURNS CHARACTER
  ( INPUT p-cod-emitente AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-emitente AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-return AS CHARACTER   NO-UNDO.
    
    run findCodigo in h-boad098 (input p-cod-emitente, output c-return).
    if c-return = "" then
        run getCharfield in h-boad098 (input "nome-abrev":U,output c-emitente).

  RETURN c-emitente.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnIncoterm wMasterDetail 
FUNCTION fnIncoterm RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then
        return substr(tt-desp-embarque.char-1,1,3).
    &else
        &if '{&bf_mat_versao_ems}' < '2.062' &then
            return substr(tt-desp-embarque.char-1,1,3). /* Function return value. */
        &else
            return tt-desp-embarque.cod-incoterm-rat. /* Function return value. */
        &endif
    &endif
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMoeda wMasterDetail 
FUNCTION fnMoeda RETURNS CHARACTER
  ( INPUT p-mo-codigo AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-moeda  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-return AS CHARACTER   NO-UNDO.
    
    run findCodigo in h-boun005 (input p-mo-codigo, output c-return).
    if c-return = "" then
        run getCharfield in h-boun005 (input "descricao":U, output c-moeda).

    RETURN c-moeda.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPtoSeq wMasterDetail 
FUNCTION fnPtoSeq RETURNS INTEGER ( INPUT p-cod-est AS CHAR,
    INPUT p-embarque AS CHAR,
    INPUT p-cod-itiner AS INT,
    input p-seq as int ):
/*------------------------------------------------------------------------------
  Purpose:  Retornar o c¢digo do ponto de controle de acordo com a sequencia do mesmo.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-pto AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-return    AS CHARACTER NO-UNDO.

    RUN findPto-Controle-por-sequencia IN h-bocx2303(INPUT p-cod-est,  
                                                     INPUT p-embarque,  
                                                     INPUT p-cod-itiner,                                                 
                                                     INPUT p-seq,                                               
                                                     OUTPUT c-return).

    IF TRIM(c-return) = "":U THEN
        RUN getIntField in h-bocx2303 (input "cod-pto-contr":U, output i-pto). 

    RETURN i-pto.   /* Function return value. */    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipoDesp wMasterDetail 
FUNCTION fnTipoDesp RETURNS CHARACTER
  ( INPUT p-cod-desp AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-tipo-despesa AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-return       AS CHARACTER   NO-UNDO.

    run findCodigo in h-bocx095 (input  p-cod-desp,
                                 output c-return).
    if  c-return = "" then
        run getIntField in h-bocx095 (input "tipo":U,
                                      output i-tipo-despesa).

    return {cxinc/i01cx010.i 4 i-tipo-despesa}.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

