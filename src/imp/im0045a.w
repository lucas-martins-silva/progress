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
       field r-rowid as rowid
       .


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0045A 2.00.00.082 } /*** "010082" 10/11/2025 16:51:22 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0045a MIM}
&ENDIF

/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 09/05/03 - 11:29 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
{include/i-epc200.i1}   

/* Local Variable Definitions ---                                       */
CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0045A
&GLOBAL-DEFINE Version        2.00.00.082
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FramesHandle     STRING(FRAME fPage1:HANDLE)
&GLOBAL-DEFINE FolderLabels     Ordens

&GLOBAL-DEFINE ttParent         tt-embarque-imp
&GLOBAL-DEFINE hDBOParent       h-bocx220
&GLOBAL-DEFINE DBOParentTable   embarque-imp

&GLOBAL-DEFINE ttSon1           tt-ordem-compra
&GLOBAL-DEFINE hDBOSon1         h-bocx225a
&GLOBAL-DEFINE DBOSon1Table     ordem-compra

&GLOBAL-DEFINE ttSon2           tt-ordens-embarque
&GLOBAL-DEFINE hDBOSon2         h-bocx225
&GLOBAL-DEFINE DBOSon2Table     ordens-embarque

&GLOBAL-DEFINE ttSon3           tt-prazo-compra
&GLOBAL-DEFINE hDBOSon3         h-boin356aa
&GLOBAL-DEFINE DBOSon3Table     prazo-compra

&GLOBAL-DEFINE page0Fields      tt-embarque-imp.cod-estabel ~
                                tt-embarque-imp.embarque
&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      

/* Parameters Definitions ---                                           */
def input param pcod-estabel as char no-undo.
def input param pembarque    as char no-undo.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon3}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx225del  AS HANDLE NO-UNDO.

/*{inbo/boin274.i tt-ordem-compra} /* definido em include para nao referenciar banco */*/

DEFINE TEMP-TABLE tt-ordem-compra NO-UNDO like ordem-compra
                  field d-data  as date format "99/99/9999"
                  field r-rowid   as rowid.

&IF DEFINED(DBOVersion) <> 0 &THEN
    DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
            FIELD ErrorSequence    AS INTEGER
            FIELD ErrorNumber      AS INTEGER
            FIELD ErrorDescription AS CHARACTER
            FIELD ErrorParameters  AS CHARACTER
            FIELD ErrorType        AS CHARACTER
            FIELD ErrorHelp        AS CHARACTER
            FIELD ErrorSubType     AS CHARACTER.
&ELSE
    {method/dbotterr.i}
&ENDIF

/* Local Variable Definitions ---                                       */

&IF '{&mgdis_version}' >= '2.06f' &THEN
    def var h-bofn017   as      handle                   no-undo.
&ELSE
    def var h-boun178   AS      handle                   no-undo.
&ENDIF
def var h-boin274       as      handle                   no-undo.
def var h-bocx250       as      handle                   no-undo.
def var h-bocx140       as      handle                   no-undo.
def var h-boin356       as      handle                   no-undo.
def var h-boin172       as      handle                   no-undo.
def var h-boin082       as      handle                   no-undo.
def var h-bocx00451     as      handle                   no-undo.



def var c-nr-proc-imp           like    processo-imp.nr-proc-imp no-undo.
def var cf-nr-proc-imp          like    processo-imp.nr-proc-imp no-undo.
def var v-cod-estabel           like    ordem-compra.cod-estabel no-undo.
def var v-qtde-n-emb            like    prazo-compra.quantidade  no-undo.
def var v-qtde-emb              like    prazo-compra.quantidade  no-undo.
def var de-quantidade           like    prazo-compra.quantidade  no-undo.
def var de-quantidade-forn      like    prazo-compra.qtd-do-forn no-undo.
def var de-quant-disp           like    prazo-compra.quantidade  no-undo.
def var de-quant-disp-forn      like    prazo-compra.qtd-do-forn no-undo.
def var c-descricao             like    item.descricao-1         no-undo.
def var v-nova-parcela          like    prazo-compra.parcela     no-undo.
def var c-un                    like    item.un                  no-undo.
def var c-un-fornec             like    cotacao-item.un          no-undo.
def var c-un-browse2            like    item.un                  no-undo.
def var c-un-fornec-browse2     like    cotacao-item.un          no-undo.
def var rOrdem                  as   rowid                       no-undo.
def var r-embarque-imp          as   rowid                       no-undo.
def var c-idiom-usuar           as   char format "x(12)"         no-undo.
def var cItem                   as   char                        no-undo.
def var c-return                as   char                        no-undo.
def var v-retorno               as   char                        no-undo.
def var c-data-entrega          as   char                        no-undo.
def var v-nova-entrega          as   date                        no-undo.
def var i-cont                  as   integer                     no-undo.
def var i-numero-ped            as   integer                     no-undo.
def var rowsreturn              as   integer                     no-undo.
def var l-necessita-li          as   logical                     no-undo.
def var l-li                    as   logical                     no-undo.
def var l-relaciona             as   logical                     no-undo.
def var l-via-transp            as   logical                     no-undo.
def var l-primer-ord            as   logical                     no-undo.
def var l-bt-qtde               as   logical                     no-undo.
def var i-seq-erro              as   int                         no-undo.
DEF VAR i-num-ordens-inicial    AS   INTEGER                     NO-UNDO.
DEF VAR i-num-ordens-vinculadas AS   INTEGER                     NO-UNDO.
DEF VAR i-numero-ordem          LIKE ordem-compra.numero-ordem   NO-UNDO.
DEF VAR p-mensagem              AS   CHAR   FORMAT "x(60)"       NO-UNDO.
DEF VAR l-valida-viatransp      AS   LOGICAL                     NO-UNDO.

DEFINE VARIABLE l-integra-di            AS      LOGICAL                          NO-UNDO.
DEFINE VARIABLE c-tax-siscomex          AS      CHARACTER                        NO-UNDO.
DEFINE VARIABLE v-cod-proces-imp-f      AS      CHARACTER                        NO-UNDO.
DEFINE VARIABLE v-cod-proces-imp-i      AS      CHARACTER                        NO-UNDO.
DEFINE VARIABLE v-cod-item-f            AS      CHARACTER                        NO-UNDO.
DEFINE VARIABLE v-cod-item-i            AS      CHARACTER                        NO-UNDO.
DEFINE VARIABLE v-cod-fornec-f          AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE v-cod-fornec-i          AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE v-num-ped-compra-f      AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE v-num-ped-compra-i      AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE v-num-ordem-compra-f    AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE v-num-ordem-compra-i    AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE i-num-ordens-embarque   AS      INTEGER                          NO-UNDO.
DEFINE VARIABLE v-dat-pedido-f          AS      DATE         format "99/99/9999" NO-UNDO.
DEFINE VARIABLE v-dat-pedido-i          AS      DATE         format "99/99/9999" NO-UNDO.
DEFINE VARIABLE v-passou                AS      LOGICAL      initial no          NO-UNDO.
DEFINE VARIABLE l-tax-siscomex          AS      LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-sel                   AS      LOGICAL INITIAL NO               NO-UNDO.
DEFINE VARIABLE l-cria                  AS      LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-possui-antecip        AS      LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-IFRIC22               AS      LOGICAL                          NO-UNDO.


ASSIGN l-IFRIC22 = CAN-FIND(FIRST funcao
                            WHERE funcao.cd-funcao = "SPP-IFRIC22":U
                              AND funcao.ativo).

def temp-table tt-ordem-quant no-undo
    field numero-ordem like ordem-compra.numero-ordem
    field quantidade   like prazo-compra.quantidade
    field un           like ITEM.un
    field qtd-do-forn  like prazo-compra.qtd-do-forn
    field un-fornec    like cotacao-item.un
    field r-rowid      as rowid
    index codigo is unique primary
        numero-ordem.

&IF '{&mgdis_version}' >= '2.06f' &THEN
    {fnbo/bofn017.i tt_usuar_mestre}
&ELSE
    {unbo/boun178.i tt_usuar_mestre}
&ENDIF

{inbo/boin356aa.i tt-prazo-compra}
{cxbo/bocx225.i tt-ordens-embarque-comp}

{cdp/cdcfgdis.i} /* Include uso de pre-processadores para modulo BN*/
{cdp/cdcfgmat.i} /* Include uso de pre-processadores para modulo BN*/
{cdp/cd4300.i3}
{imp/im0045ab.i50}

&IF "{&BF_DIS_VERSAO_EMS}" >= "2.062" &THEN
    {cdp~/cd2508.i} /*Funá∆o - EMS2-COMEX-MEXICO*/
&ENDIF

/* Global Variable Definitions */
def new global shared var i-num-pedido-imp as integer no-undo.

assign rOrdem = ?.

DEF VAR h-bocx404     AS HANDLE    NO-UNDO.
DEF VAR c-botao-press AS CHARACTER NO-UNDO.
DEF VAR l-rodaUmaVez  AS LOGICAL   NO-UNDO.
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
&Scoped-define INTERNAL-TABLES tt-ordem-compra tt-ordens-embarque ~
tt-prazo-compra

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-ordem-compra.numero-ordem tt-ordem-compra.it-codigo fnQtde() @ de-quantidade fnUn(tt-ordem-compra.it-codigo) @ c-un fnQtdeFornec() @ de-quantidade-forn fnUnFornec(tt-ordem-compra.numero-ordem) @ c-un-fornec fnProcesso(tt-ordem-compra.num-pedido) @ c-nr-proc-imp   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define OPEN-QUERY-brSon1 IF i-classif = 1 THEN DO:    OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra NO-LOCK        BY tt-ordem-compra.numero-ordem. END. ELSE IF i-classif = 2 THEN DO:    OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra NO-LOCK        BY tt-ordem-compra.it-codigo        BY tt-ordem-compra.numero-ordem. END.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-ordem-compra
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-ordem-compra


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-ordens-embarque.numero-ordem ~
tt-ordens-embarque.parcela ~
fnItem(input tt-ordens-embarque.numero-ordem) @ cItem ~
tt-ordens-embarque.quantidade ~
fnuniMed(fnItem(input tt-ordens-embarque.numero-ordem)) @ c-un-browse2 ~
tt-ordens-embarque.qt-do-forn ~
fnUniMedFornec(tt-ordens-embarque.numero-ordem) @ c-un-fornec-browse2 ~
tt-ordens-embarque.char-1 tt-ordens-embarque.nr-proc-imp 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-ordens-embarque NO-LOCK ~
    BY tt-ordens-embarque.numero-ordem ~
       BY tt-ordens-embarque.parcela
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH tt-ordens-embarque NO-LOCK ~
    BY tt-ordens-embarque.numero-ordem ~
       BY tt-ordens-embarque.parcela.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-ordens-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-ordens-embarque


/* Definitions for BROWSE brson3                                        */
&Scoped-define FIELDS-IN-QUERY-brson3 tt-prazo-compra.numero-ordem tt-prazo-compra.parcela tt-prazo-compra.data-entrega tt-prazo-compra.it-codigo tt-prazo-compra.quant-saldo fnUniMed(tt-prazo-compra.it-codigo) @ c-un tt-prazo-compra.qtd-sal-forn fnUniMedFornec(tt-prazo-compra.numero-ordem) @ c-un-fornec fnProcessoprazo(tt-prazo-compra.numero-ordem) @ c-nr-proc-imp   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brson3   
&Scoped-define SELF-NAME brson3
&Scoped-define OPEN-QUERY-brson3 if i-classif = 1 THEN DO:    OPEN QUERY {&SELF-NAME} FOR EACH tt-prazo-compra NO-LOCK         BY tt-prazo-compra.numero-ordem         BY tt-prazo-compra.parcela. END. ELSE IF i-classif = 2 THEN DO:    OPEN QUERY {&SELF-NAME} FOR EACH tt-prazo-compra NO-LOCK         BY tt-prazo-compra.it-codigo         BY tt-prazo-compra.numero-ordem. END. ELSE IF i-classif = 3 THEN DO:    OPEN QUERY {&SELF-NAME} FOR EACH tt-prazo-compra NO-LOCK         BY tt-prazo-compra.data-entrega         BY tt-prazo-compra.numero-ordem         BY tt-prazo-compra.it-codigo. END.
&Scoped-define TABLES-IN-QUERY-brson3 tt-prazo-compra
&Scoped-define FIRST-TABLE-IN-QUERY-brson3 tt-prazo-compra


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}~
    ~{&OPEN-QUERY-brSon2}~
    ~{&OPEN-QUERY-brson3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define ENABLED-TABLES tt-embarque-imp
&Scoped-define FIRST-ENABLED-TABLE tt-embarque-imp
&Scoped-Define ENABLED-OBJECTS btQueryJoins btReportsJoins btExit btHelp ~
rtParent rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define DISPLAYED-TABLES tt-embarque-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-embarque-imp


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
  (input pnum-ordem as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnProcesso wMasterDetail 
FUNCTION fnProcesso RETURNS CHARACTER
  ( input p-num-pedido as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnprocessoprazo wMasterDetail 
FUNCTION fnprocessoprazo RETURNS CHARACTER
  ( input p-numero-ordem as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnQtde wMasterDetail 
FUNCTION fnQtde RETURNS decimal
    () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnQtdeFornec wMasterDetail 
FUNCTION fnQtdeFornec RETURNS decimal
    () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUn wMasterDetail 
FUNCTION fnUn RETURNS CHARACTER
  (INPUT c-it-codigo AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnFornec wMasterDetail 
FUNCTION fnUnFornec RETURNS CHARACTER
  (INPUT i-numero-ordem AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUniMed wMasterDetail 
FUNCTION fnUniMed RETURNS CHARACTER
  (INPUT c-it-codigo AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUniMedFornec wMasterDetail 
FUNCTION fnUniMedFornec RETURNS CHARACTER
  (INPUT i-numero-ordem AS INT)  FORWARD.

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
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
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
     SIZE 96 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 96 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btFirst-2 
     IMAGE-UP FILE "image~\im-fir":U
     IMAGE-INSENSITIVE FILE "image~\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btLast-2 
     IMAGE-UP FILE "image~\im-las":U
     IMAGE-INSENSITIVE FILE "image~\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext-2 
     IMAGE-UP FILE "image~\im-nex":U
     IMAGE-INSENSITIVE FILE "image~\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btn_drawback 
     LABEL "Drawback" 
     SIZE 10 BY 1.

DEFINE BUTTON btPrev-2 
     IMAGE-UP FILE "image~\im-pre":U
     IMAGE-INSENSITIVE FILE "image~\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQtde 
     LABEL "Qtde" 
     SIZE 10 BY 1.

DEFINE BUTTON btselecao 
     LABEL "Seleá∆o" 
     SIZE 15 BY 1.

DEFINE BUTTON bt_li 
     LABEL "LI/Class. Fiscal" 
     SIZE 15.43 BY 1.

DEFINE VARIABLE c-class AS CHARACTER FORMAT "X(256)":U 
     LABEL "Classifica por" 
      VIEW-AS TEXT 
     SIZE 1.14 BY .67 NO-UNDO.

DEFINE VARIABLE i-classif AS INTEGER INITIAL 1 
 VIEW-AS RADIO-SET HORIZONTAL
 RADIO-BUTTONS 
      "Ordens",  1,
      "Itens",   2
 SIZE 30.14 BY .75 NO-UNDO.


/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-ordem-compra SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-ordens-embarque SCROLLING.

DEFINE QUERY brson3 FOR 
      tt-prazo-compra SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 DISPLAY
      tt-ordem-compra.numero-ordem
      tt-ordem-compra.it-codigo
      fnQtde() @ de-quantidade COLUMN-LABEL "Nossa Qtde Disp" FORMAT ">>>>>,>>9.9999"
      fnUn(tt-ordem-compra.it-codigo) @ c-un COLUMN-LABEL "Un" FORMAT "xx"
      fnQtdeFornec() @ de-quantidade-forn COLUMN-LABEL "Qtde Fornec Disp" FORMAT "->>>>>,>>9.9999"
      fnUnFornec(tt-ordem-compra.numero-ordem) @ c-un-fornec COLUMN-LABEL "Un Fornec" FORMAT "xx"
      fnProcesso(tt-ordem-compra.num-pedido) @ c-nr-proc-imp
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 41.86 BY 5.96
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 DISPLAY
      tt-ordens-embarque.numero-ordem FORMAT ">>>>>9,99":U
      tt-ordens-embarque.parcela FORMAT ">>>>9":U
      fnItem(input tt-ordens-embarque.numero-ordem) @ cItem COLUMN-LABEL "Item" FORMAT "x(16)":U
      tt-ordens-embarque.quantidade COLUMN-LABEL "Nossa Qtde Disp" FORMAT ">>>>>,>>9.9999":U
            WIDTH 15.86
      fnuniMed(fnItem(input tt-ordens-embarque.numero-ordem)) @ c-un-browse2 COLUMN-LABEL "Un" FORMAT "xx":U
      tt-ordens-embarque.qt-do-forn COLUMN-LABEL "Qtde Fornec Disp" FORMAT ">>>>>,>>9.9999":U
            WIDTH 15.86
      fnUniMedFornec(tt-ordens-embarque.numero-ordem) @ c-un-fornec-browse2 COLUMN-LABEL "Un Fornec" FORMAT "xx":U
      tt-ordens-embarque.char-1 COLUMN-LABEL "Ato Concess¢rio" FORMAT "x(20)":U
      tt-ordens-embarque.nr-proc-imp FORMAT "X(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 44 BY 5.88
         FONT 2.

DEFINE BROWSE brson3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brson3 wMasterDetail _FREEFORM
  QUERY brson3 DISPLAY
      tt-prazo-compra.numero-ordem format ">>>>>9,99"
      tt-prazo-compra.parcela
      tt-prazo-compra.data-entrega  
      tt-prazo-compra.it-codigo
      tt-prazo-compra.quant-saldo COLUMN-LABEL "Nossa Qtde Disp" FORMAT ">>>>>,>>9.9999"
      fnUniMed(tt-prazo-compra.it-codigo) @ c-un COLUMN-LABEL "Un" FORMAT "xx"
      tt-prazo-compra.qtd-sal-forn COLUMN-LABEL "Qtde Fornec Disp" FORMAT "->>>>>,>>9.9999"
      fnUniMedFornec(tt-prazo-compra.numero-ordem) @ c-un-fornec COLUMN-LABEL "Un Fornec" FORMAT "xx"
      fnProcessoprazo(tt-prazo-compra.numero-ordem) @ c-nr-proc-imp
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 41.86 BY 5.88
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btQueryJoins AT ROW 1.08 COL 80.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.08 COL 84.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.08 COL 88.57 HELP
          "Sair"
     btHelp AT ROW 1.08 COL 92.57 HELP
          "Ajuda"
     tt-embarque-imp.cod-estabel AT ROW 2.83 COL 45 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-embarque-imp.embarque AT ROW 3.83 COL 45 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.14 BY 14.21
         FONT 1.

DEFINE FRAME fPage1
     i-classif AT ROW 1.29 COL 14.29 NO-LABEL
     btNext-2 AT ROW 2.13 COL 44.57 HELP
          "Pr¢xima ocorrància"
     brSon1 AT ROW 2.21 COL 1.86
     brson3 AT ROW 2.25 COL 1.72
     brSon2 AT ROW 2.25 COL 49.57
     btLast-2 AT ROW 3.67 COL 44.57 HELP
          "Èltima ocorrància"
     btPrev-2 AT ROW 5.25 COL 44.57 HELP
          "Ocorrància anterior"
     btFirst-2 AT ROW 6.79 COL 44.57 HELP
          "Primeira ocorrància"
     btQtde AT ROW 8.17 COL 1.72
     bt_li AT ROW 8.17 COL 11.72
     btselecao AT ROW 8.17 COL 27.29
     btn_drawback AT ROW 8.17 COL 49.57
     c-class AT ROW 1.33 COL 10.86 COLON-ALIGNED
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.14 ROW 6.38
         SIZE 93.57 BY 8.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
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
         HEIGHT             = 14.46
         WIDTH              = 96.43
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
/* BROWSE-TAB brSon1 btNext-2 fPage1 */
/* BROWSE-TAB brson3 brSon1 fPage1 */
/* BROWSE-TAB brSon2 brson3 fPage1 */
ASSIGN 
       brSon1:MAX-DATA-GUESS IN FRAME fPage1         = 10.

ASSIGN 
       btn_drawback:HIDDEN IN FRAME fPage1           = TRUE.

ASSIGN 
       btselecao:HIDDEN IN FRAME fPage1           = TRUE.

ASSIGN 
       bt_li:HIDDEN IN FRAME fPage1           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
IF i-classif = 1 THEN DO:
   OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra NO-LOCK
       BY tt-ordem-compra.numero-ordem.
END.
ELSE IF i-classif = 2 THEN DO:
   OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra NO-LOCK
       BY tt-ordem-compra.it-codigo
       BY tt-ordem-compra.numero-ordem.
END.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.tt-ordens-embarque"
     _OrdList          = "Temp-Tables.tt-ordens-embarque.numero-ordem|yes,Temp-Tables.tt-ordens-embarque.parcela|yes"
     _FldNameList[1]   > Temp-Tables.tt-ordens-embarque.numero-ordem
"tt-ordens-embarque.numero-ordem" ? ">>>>>9,99" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.tt-ordens-embarque.parcela
     _FldNameList[3]   > "_<CALC>"
"fnItem(input tt-ordens-embarque.numero-ordem) @ cItem" "Item" "x(16)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-ordens-embarque.quantidade
"tt-ordens-embarque.quantidade" "Nossa Qtde Disp" ? "decimal" ? ? ? ? ? ? no ? no no "15.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fnuniMed(fnItem(input tt-ordens-embarque.numero-ordem)) @ c-un-browse2" "Un" "xx" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-ordens-embarque.qt-do-forn
"tt-ordens-embarque.qt-do-forn" "Qtde Fornec Disp" ? "decimal" ? ? ? ? ? ? no ? no no "15.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fnUniMedFornec(tt-ordens-embarque.numero-ordem) @ c-un-fornec-browse2" "Un Fornec" "xx" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-ordens-embarque.char-1
"tt-ordens-embarque.char-1" "Ato Concess¢rio" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = Temp-Tables.tt-ordens-embarque.nr-proc-imp
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brson3
/* Query rebuild information for BROWSE brson3
     _START_FREEFORM
if i-classif = 1 THEN DO:
   OPEN QUERY {&SELF-NAME} FOR EACH tt-prazo-compra NO-LOCK
        BY tt-prazo-compra.numero-ordem
        BY tt-prazo-compra.parcela.
END.
ELSE
IF i-classif = 2 THEN DO:
   OPEN QUERY {&SELF-NAME} FOR EACH tt-prazo-compra NO-LOCK
        BY tt-prazo-compra.it-codigo
        BY tt-prazo-compra.numero-ordem.
END.
ELSE
IF i-classif = 3 THEN DO:
   OPEN QUERY {&SELF-NAME} FOR EACH tt-prazo-compra NO-LOCK
        BY tt-prazo-compra.data-entrega
        BY tt-prazo-compra.numero-ordem
        BY tt-prazo-compra.it-codigo.
END.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brson3 */
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
  IF l-IFRIC22 THEN DO:
      RUN piVerificaDespachanteInformado.
  END.
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
  IF l-IFRIC22 THEN DO:
      RUN piVerificaDespachanteInformado.
  END.

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
ON MOUSE-SELECT-DBLCLICK OF brSon1 IN FRAME fPage1
DO:
    APPLY "CHOOSE":U TO btQtde IN FRAME {&frame-name}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brson3
&Scoped-define SELF-NAME brson3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brson3 wMasterDetail
ON MOUSE-SELECT-DBLCLICK OF brson3 IN FRAME fPage1
DO:
    APPLY "CHOOSE":U TO btQtde IN FRAME {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    IF l-IFRIC22 THEN DO:
        RUN piVerificaDespachanteInformado.
    END.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btFirst-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst-2 wMasterDetail
ON CHOOSE OF btFirst-2 IN FRAME fPage1 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:

    DEF VAR l-mensagem AS LOGICAL NO-UNDO.
    ASSIGN c-botao-press = "btFirst-2":U.

    /* Chamada UPC - consist-contab */ 
    &IF DEFINED(bf_dis_versao_ems) &THEN
        IF  c-nom-prog-upc-mg97 <> "" THEN DO:    
            run value(c-nom-prog-upc-mg97) (input "CONSIST-CONTAB", ~            
                                            input "tt-embarque-imp", ~           
                                            input this-procedure, ~              
                                            input frame {&FRAME-NAME}:handle, ~  
                                            input STRING(BUFFER tt-embarque-imp:HANDLE), ~           
                                            input ?) NO-ERROR.                          
            if  return-value = "adm-error" then do:
                SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                return no-apply.        
            end.                                   
        END. 
    &else    
    &endif
    /* fim chamada upc */
    if  tt-embarque-imp.contabilizado = yes then do:
        assign i-seq-erro = i-seq-erro + 1.
        create RowErrors.
        assign RowErrors.ErrorParameters = tt-embarque-imp.embarque
               RowErrors.errorsubtype = "Question".
        
        run utp/ut-msgs.p (input "show":U, input 27737, input tt-embarque-imp.embarque).
        if  return-value = "NO" then do:
            SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
            return no-apply.        
        end. /* if  return-value = "NO" then */
    end. /* if  tt-embarque-imp.contabilizado = yes then */
    
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
    IF l-IFRIC22 THEN DO:
        RUN piEmbarqPossuiAntecip IN h-bocx00451 (INPUT tt-embarque-imp.cod-estabel,
                                                  INPUT tt-embarque-imp.embarque,
                                                  OUTPUT l-possui-antecip).
        IF l-possui-antecip THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 55715, INPUT "").
            IF RETURN-VALUE = "YES":U THEN
                RUN piEliminaAntecipEmbarque IN h-bocx00451 (INPUT tt-embarque-imp.cod-estabel,
                                                             INPUT tt-embarque-imp.embarque).
            ELSE DO:
                SESSION:SET-WAIT-STATE("":U).
                RETURN NO-APPLY.
            END.
        END.
    END.
    
    IF NOT VALID-HANDLE(h-bocx225del) THEN RUN cxbo/bocx225.p PERSISTENT SET h-bocx225del.
    RUN validateEliminacaoOrdem IN h-bocx225del (INPUT tt-embarque-imp.cod-estabel, INPUT tt-embarque-imp.embarque, OUTPUT p-mensagem).
    IF  p-mensagem <> "" THEN DO:
        run utp/ut-msgs.p (input "show":U, input 28547, input string(tt-embarque-imp.embarque) + "~~" + p-mensagem).
        if return-value = "NO" then do:
             SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
             return no-apply.        
        end. /* if return-value = "NO" then */
    end. /* IF  p-mensagem <> "" THEN */
    
    DO  TRANSACTION ON ERROR UNDO, LEAVE:

        ASSIGN l-mensagem = NO.

        FOR EACH tt-ordens-embarque:
            &if '{&bf_mat_versao_ems}' = '2.062' &then
                RUN BuscaEqEmbarqPrazCompra IN h-bocx225del (INPUT tt-ordens-embarque.numero-ordem, INPUT tt-ordens-embarque.parcela).
                IF  RETURN-VALUE = "OK":U THEN DO:
                    IF  NOT l-mensagem THEN DO:
                        ASSIGN l-mensagem = YES.
                        run utp/ut-msgs.p (input "show":U, input 30879, input "").
                        if  return-value = "NO":U then do:
                            SESSION:SET-WAIT-STATE("":U). 
                            LEAVE.
                        end. /* if  return-value = "NO":U then */
                    END. /* IF  NOT l-mensagem THEN */
                END. /* IF  RETURN-VALUE = "OK":U THEN */
            &endif
            RUN validateDelete IN h-bocx225del (INPUT-OUTPUT tt-ordens-embarque.r-rowid, OUTPUT TABLE RowErrors).
            IF  CAN-FIND(FIRST RowErrors) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="yes"}
                RUN openQueriesSon IN THIS-PROCEDURE.
                UNDO, RETURN NO-APPLY.            
            END. /* IF  CAN-FIND(FIRST RowErrors) THEN */
            ELSE DO:
                /*---[ Conforme t¢pico 1.2.5.9 da DIS do projeto 0079 - Vis∆o DI ]-----------------------------------------------------------------------------------------------------*/
                ASSIGN l-integra-di = NO.
            
                RUN verificaIntegraDI IN h-bocx404 (INPUT tt-ordens-embarque.numero-ordem, INPUT tt-ordens-embarque.parcela, OUTPUT l-integra-di).
                IF  l-integra-di THEN DO:
                    IF  NOT l-rodaUmaVez THEN DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-ordem-vinculada-a-uma-declarac AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Ordem_vinculada_a_uma_Declaraá∆o_de_Importaá∆o" *}
                        ASSIGN c-lbl-liter-ordem-vinculada-a-uma-declarac = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-ordem-esta-vinculada-a-uma-dec AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Ordem_est†_vinculada_a_uma_Declaraá∆o_de_Importaá∆o,_deseja_desvincular?" *}
                        ASSIGN c-lbl-liter-ordem-esta-vinculada-a-uma-dec = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-as-adicoes-e-itens-da-di-serao AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "As_Adiá‰es_e_Itens_da_DI_ser∆o_regerados._A_funá∆o_de_rateio_e_c†lculo_dos_impostos_devem_ser_executadas_novamente" *}
                        ASSIGN c-lbl-liter-as-adicoes-e-itens-da-di-serao = TRIM(RETURN-VALUE).
                        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 27100, INPUT c-lbl-liter-ordem-vinculada-a-uma-declarac + '!' + '~~' + 
                                                                              c-lbl-liter-ordem-esta-vinculada-a-uma-dec + ' ' + CHR(10) +
                                                                              c-lbl-liter-as-adicoes-e-itens-da-di-serao + '!').
                        IF  RETURN-VALUE = "YES":U THEN DO:
                            RUN desvinculaOrdem IN h-bocx404(INPUT tt-ordens-embarque.numero-ordem, INPUT tt-ordens-embarque.parcela).
                        END. /* IF  RETURN-VALUE = "YES":U */
                        ELSE DO:
                            ASSIGN i-cont = brson2:NUM-SELECTED-ROWS IN FRAME fPage1 + 1.
                            UNDO, RETURN NO-APPLY.
                        END. /* ELSE DO: */
                    END. /* IF  NOT l-rodaUmaVez THEN DO: */
                    ELSE DO:
                        RUN desvinculaOrdem IN h-bocx404(INPUT tt-ordens-embarque.numero-ordem, INPUT tt-ordens-embarque.parcela).
                    END. /* ELSE DO: */
                END. /* IF  l-integra-di */
                /*---[ Conforme t¢pico 1.2.5.9 da DIS do projeto 0079 - Vis∆o DI ]-----------------------------------------------------------------------------------------------------*/
            
                IF  c-botao-press = "btFirst-2":U THEN ASSIGN l-rodaUmaVez = YES.
                
                IF  AVAIL tt-ordens-embarque THEN DO:

                    FIND FIRST tt-ordem-quant
                         WHERE tt-ordem-quant.numero-ordem = tt-ordens-embarque.numero-ordem NO-ERROR.

                    IF  AVAIL tt-ordem-quant THEN DO:
                        RUN pi-calculaQtdeDisponivel IN h-bocx225del (INPUT tt-ordem-quant.numero-ordem, OUTPUT de-quant-disp).
                        ASSIGN tt-ordem-quant.quantidade = de-quant-disp.
                    END. /* IF  AVAIL tt-ordem-quant THEN */

                    &IF DEFINED(bf_dis_versao_ems) &THEN
                        /* Chamada UPC  */ 
                        IF  c-nom-prog-upc-mg97 <> "" THEN DO:    
                            run value(c-nom-prog-upc-mg97) (input "FIM-BTFIRST-2", ~
                                                            input "tt-ordens-embarque", ~           
                                                            input this-procedure, ~              
                                                            input frame {&FRAME-NAME}:handle, ~  
                                                            INPUT STRING(tt-ordens-embarque.numero-ordem) + ";" + STRING(tt-ordens-embarque.parcela) + ";" + STRING(tt-ordens-embarque.cod-estabel) + ";" +  STRING(tt-ordens-embarque.embarque),
                                                            INPUT IF AVAILABLE tt-ordens-embarque THEN tt-ordens-embarque.r-rowid ELSE ?) NO-ERROR.                         
                            if  return-value = "adm-error" then do:
                                SESSION:SET-WAIT-STATE("":U). 
                                return no-apply.        
                            end.                                   
                        END. 
                        /* fim chamada upc */
                    &else   
                    &endif 

                    FOR EACH ordens-embarque-trib EXCLUSIVE-LOCK
                       WHERE ordens-embarque-trib.cod-estabel  = tt-ordens-embarque.cod-estabel
                         AND ordens-embarque-trib.embarque     = tt-ordens-embarque.embarque
                         AND ordens-embarque-trib.numero-ordem = tt-ordens-embarque.numero-ordem
                         AND ordens-embarque-trib.parcela      = tt-ordens-embarque.parcela:
                        DELETE ordens-embarque-trib.
                    END.
                    
                    DELETE tt-ordens-embarque.
                END. /* IF  AVAIL tt-ordens-embarque THEN */
            END. /* ELSE DO: */
        END. /* FOR EACH tt-ordens-embarque: */
        RUN openQueriesSon IN THIS-PROCEDURE.
    END. /* DO  TRANSACTION ON ERROR UNDO, LEAVE: */

    /* Licenciamento Importacao */
    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
        run  piNecessitaLiEmbarque in h-bocx225del (input tt-embarque-imp.cod-estabel, input tt-embarque-imp.embarque, output table rowErrors).
        IF  CAN-FIND(FIRST RowErrors) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="yes"}
        END. /* IF  CAN-FIND(FIRST RowErrors) THEN */
    &endif
    IF  VALID-HANDLE(h-bocx225del) THEN DO:
        DELETE PROCEDURE h-bocx225del.
        ASSIGN h-bocx225del = ?.
    END. /* IF  VALID-HANDLE(h-bocx225del) THEN */

    ASSIGN c-botao-press = "":U.

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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btLast-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast-2 wMasterDetail
ON CHOOSE OF btLast-2 IN FRAME fPage1 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:

    /* Chamada UPC - consist-contab */ 
    &IF DEFINED(bf_dis_versao_ems) &THEN
        IF  c-nom-prog-upc-mg97 <> "" THEN DO:    
            run value(c-nom-prog-upc-mg97) (input "CONSIST-CONTAB", ~            
                                            input "tt-embarque-imp", ~           
                                            input this-procedure, ~              
                                            input frame {&FRAME-NAME}:handle, ~  
                                            input STRING(BUFFER tt-embarque-imp:HANDLE), ~           
                                            input ?) NO-ERROR.                          
            if  return-value = "adm-error" then do:
                SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                return no-apply.        
            end.                                   
        END. 
    &else
    &endif
    /* fim chamada upc */
    run setCreatehist in h-bocx225.

    if tt-embarque-imp.contabilizado = yes then do:
        assign i-seq-erro = i-seq-erro + 1.
        create RowErrors.
        assign RowErrors.ErrorParameters = tt-embarque-imp.embarque
               RowErrors.errorsubtype = "Question".
        
        run utp/ut-msgs.p (input "show":U,
                           input 27737,
                           input tt-embarque-imp.embarque).
        
        if return-value = "NO" then do:
             SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
             return no-apply.        
        end.
    end.
    
    if not l-relaciona then do:
        FOR EACH tt-ordem-compra TRANSACTION ON ERROR UNDO, LEAVE:
            
            FIND FIRST tt-ordem-quant
                 WHERE tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem NO-ERROR.
                
            IF NOT AVAIL tt-ordem-quant THEN DO:
                CREATE tt-ordem-quant.
                ASSIGN tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem
                       tt-ordem-quant.r-rowid      = tt-ordem-compra.r-rowid.
                RUN pi-calculaQtdeDisponivel IN h-bocx225 (INPUT tt-ordem-compra.numero-ordem,
                                                           OUTPUT de-quant-disp).
                ASSIGN tt-ordem-quant.quantidade = de-quant-disp.                
            END.
                        
            /* Via de Transporte */
            RUN piValidaViaTransp (INPUT  tt-ordem-compra.numero-ordem,
                                   OUTPUT l-via-transp,
                                   OUTPUT l-primer-ord).
            IF  l-valida-viatransp THEN DO: /* Funáao spp-via-transp-dif */ 
                IF  l-via-transp THEN
                    run utp/ut-msgs.p (input "show":U,
                                       input 54556, /* alerta */
                                       input STRING(tt-ordem-compra.numero-ordem)).
            END.
            ELSE DO:
                IF  l-via-transp THEN DO: /* Via de transporte da ordem Ç diferente da via de transporte do embarque */
                    IF  l-primer-ord THEN DO: /* primeira ordem vinculada */
                        run utp/ut-msgs.p (input "show":U, input 54557, input STRING(tt-ordem-compra.numero-ordem)). /* confirma e atualiza */
                        if  return-value <> "yes" then do: 
                            SESSION:SET-WAIT-STATE("":U).
                            return no-apply.
                        end.
                        ELSE DO:
                            RUN piAtualizaViaTransp IN h-bocx225 (INPUT tt-embarque-imp.embarque,    
                                                                  INPUT tt-embarque-imp.cod-estabel).
                        END.
                    END.
                    ELSE DO:
                        run utp/ut-msgs.p (input "show":U, input 54558, input STRING(tt-ordem-compra.numero-ordem)). /* erro */  
                        SESSION:SET-WAIT-STATE("":U).
                        return no-apply.
                    END.
                END.
            END.
            
            RUN createOrdensEmbarque IN h-bocx225 (INPUT tt-embarque-imp.r-rowid,
                                                   INPUT tt-ordem-compra.numero-ordem,
                                                   INPUT tt-ordem-quant.quantidade,                                                   
                                                   OUTPUT table RowErrors).
                                                   
            IF CAN-FIND(FIRST RowErrors) THEN DO:
                RUN openQueriesSon IN THIS-PROCEDURE.
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="yes"}
                UNDO, RETURN NO-APPLY.
            END.
            ELSE DO:
                IF c-nom-prog-upc-mg97 <> "" THEN DO:    
                    RUN VALUE(c-nom-prog-upc-mg97) (INPUT "converteQuantidadeFornecedor":U,
                                                    INPUT "NumeroOrdem":U,
                                                    INPUT BUFFER tt-ordem-compra:HANDLE,
                                                    INPUT FRAME fpage0:HANDLE,
                                                    INPUT STRING(tt-ordem-compra.numero-ordem) + ";" + STRING(tt-embarque-imp.cod-estabel) + ";" +  STRING(tt-embarque-imp.embarque),
                                                    INPUT IF AVAILABLE tt-embarque-imp THEN tt-embarque-imp.r-rowid ELSE ?) NO-ERROR.
                END.
            END.           
        END.    
    end.
    else do:
        FOR EACH tt-prazo-compra TRANSACTION ON ERROR UNDO, LEAVE:            

            /* Via de Transporte */
            RUN piValidaViaTransp (INPUT  tt-prazo-compra.numero-ordem,
                                   OUTPUT l-via-transp,
                                   OUTPUT l-primer-ord).
            IF  l-valida-viatransp THEN DO: /* Funáao spp-via-transp-dif */ 
                IF  l-via-transp THEN
                    run utp/ut-msgs.p (input "show":U,
                                       input 54556, /* alerta */
                                       input STRING(tt-prazo-compra.numero-ordem)).
            END.
            ELSE DO:
                IF  l-via-transp THEN DO: /* Via de transporte da ordem Ç diferente da via de transporte do embarque */
                    IF  l-primer-ord THEN DO: /* primeira ordem vinculada */
                        run utp/ut-msgs.p (input "show":U, input 54557, input STRING(tt-prazo-compra.numero-ordem)). /* confirma e atualiza */
                        if  return-value <> "yes" then do: 
                            SESSION:SET-WAIT-STATE("":U).
                            return no-apply.
                        end.
                        ELSE DO:
                            RUN piAtualizaViaTransp IN h-bocx225 (INPUT tt-embarque-imp.embarque,    
                                                                  INPUT tt-embarque-imp.cod-estabel).
                            RUN openQueriesSon IN THIS-PROCEDURE.
                        END.
                    END.
                    ELSE DO:
                        run utp/ut-msgs.p (input "show":U, input 54558, input STRING(tt-prazo-compra.numero-ordem)). /* erro */  
                        SESSION:SET-WAIT-STATE("":U).
                        return no-apply.
                    END.
                END.
            END.

            run createOrdensEmbarquebyparcela IN h-bocx225 (input tt-embarque-imp.r-rowid,
                                                            input tt-prazo-compra.numero-ordem,
                                                            input tt-prazo-compra.parcela,
                                                            input tt-prazo-compra.quant-saldo,
                                                            output table RowErrors).
                                                   
            IF CAN-FIND(FIRST RowErrors) THEN DO:
                RUN openQueriesSon IN THIS-PROCEDURE.
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="yes"}
                UNDO, RETURN NO-APPLY.
            END.
            ELSE DO:
                IF c-nom-prog-upc-mg97 <> "" THEN DO:    
                    RUN VALUE(c-nom-prog-upc-mg97) (INPUT "converteQuantidadeFornecedor":U,
                                                    INPUT "NumeroOrdem":U,
                                                    INPUT BUFFER tt-prazo-compra:HANDLE,
                                                    INPUT FRAME fpage0:HANDLE,
                                                    INPUT STRING(tt-prazo-compra.numero-ordem) + ";" + STRING(tt-embarque-imp.cod-estabel) + ";" +  STRING(tt-embarque-imp.embarque),
                                                    INPUT IF AVAILABLE tt-embarque-imp THEN tt-embarque-imp.r-rowid ELSE ?) NO-ERROR.
                END.
            END.    
        END.    
    end.    
    /*calculo das despesas do itiner†rio*/
    IF AVAIL param-imp
    AND SUBSTRING(param-imp.char-1,168,1) = "S" THEN
        RUN piCalculaDespItiner IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                              INPUT tt-embarque-imp.embarque).
    RUN openQueriesSon IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext-2 wMasterDetail
ON CHOOSE OF btNext-2 IN FRAME fPage1 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:

    def var v-data            as date.
    def var v-parcela         as integer.
    def var v-ordem           as integer.

    &IF DEFINED(bf_dis_versao_ems) &THEN
        /* Chamada UPC - consist-contab */ 
        IF  c-nom-prog-upc-mg97 <> "" THEN DO:    
            run value(c-nom-prog-upc-mg97) (input "CONSIST-CONTAB", ~            
                                            input "tt-embarque-imp", ~           
                                            input this-procedure, ~              
                                            input frame {&FRAME-NAME}:handle, ~  
                                            input STRING(BUFFER tt-embarque-imp:HANDLE), ~           
                                            input ?) NO-ERROR.    
          
            if  return-value = "adm-error" then do:
                SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                return no-apply.        
            end.                                   
        END. 
        /* fim chamada upc */
    &else
    &endif
    run setCreatehist in h-bocx225.
   
    if tt-embarque-imp.contabilizado = yes then do:
        assign i-seq-erro = i-seq-erro + 1.
        create RowErrors.
        assign RowErrors.ErrorParameters = tt-embarque-imp.embarque
               RowErrors.errorsubtype = "Question".
        
        run utp/ut-msgs.p (input "show":U,
                           input 27737,
                           input tt-embarque-imp.embarque).
        
      
        if return-value = "NO" then do:
             SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
             return no-apply.        
        end.
    end.
    
    IF  NOT l-relaciona THEN DO:
        IF  AVAIL tt-ordem-compra THEN
            RUN validavinculacaoordens IN h-bocx225 (INPUT tt-embarque-imp.embarque,
                                                     INPUT tt-embarque-imp.cod-estabel,
                                                     INPUT tt-ordem-compra.numero-ordem,
                                                     INPUT 0, /*quando o tratamento est† por ordem-compra pois nao tem a parcela na tt-ordem-compra*/
                                                     OUTPUT TABLE RowErrors). 
    END.
    ELSE DO:
       IF AVAIL tt-prazo-compra THEN
            RUN validavinculacaoordens IN h-bocx225 (INPUT tt-embarque-imp.embarque,    
                                                     INPUT tt-embarque-imp.cod-estabel, 
                                                     INPUT tt-prazo-compra.numero-ordem,
                                                     INPUT tt-prazo-compra.parcela, 
                                                     OUTPUT TABLE RowErrors).
    END.
 
    
    IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
        ASSIGN i-numero-ordem = 0.
        IF  AVAIL tt-ordem-compra THEN DO:
            ASSIGN i-numero-ordem = tt-ordem-compra.numero-ordem.
            RUN piValidaViaTransp (INPUT tt-ordem-compra.numero-ordem,
                                   OUTPUT l-via-transp,
                                   OUTPUT l-primer-ord). 
        END.
        ELSE DO: 
            IF  AVAIL tt-prazo-compra THEN DO:
                ASSIGN i-numero-ordem = tt-prazo-compra.numero-ordem.
                RUN piValidaViaTransp (INPUT tt-prazo-compra.numero-ordem,
                                       OUTPUT l-via-transp,
                                       OUTPUT l-primer-ord). 
            END.
        END.
        IF  l-valida-viatransp THEN DO: /* Funáao spp-via-transp-dif */
            IF  l-via-transp THEN
                run utp/ut-msgs.p (input "show":U,
                                   input 54556, /* alerta */
                                   input STRING(i-numero-ordem)).
        END.
        ELSE DO:
            IF  l-via-transp THEN DO: /* Via de transporte da ordem Ç diferente da via de transporte do embarque */
                IF  l-primer-ord THEN DO: /* primeira ordem vinculada */
                    run utp/ut-msgs.p (input "show":U, input 54557, input STRING(i-numero-ordem)). /* confirma e atualiza */
                    if  return-value <> "yes" then do: 
                        SESSION:SET-WAIT-STATE("":U).
                        return no-apply.
                    end.
                    ELSE DO:
                        RUN piAtualizaViaTransp IN h-bocx225 (INPUT tt-embarque-imp.embarque,    
                                                              INPUT tt-embarque-imp.cod-estabel).
                    END.
                END.
                ELSE DO:
                    run utp/ut-msgs.p (input "show":U, input 54558, input STRING(i-numero-ordem)). /* erro */  
                    SESSION:SET-WAIT-STATE("":U).
                    return no-apply.
                END.
            END.
        END.

        if l-relaciona = no then do:
            
            if brson1:num-selected-rows = 0 then leave.
            
            do i-cont = 1 to brson1:num-selected-rows:
                brson1:fetch-selected-row(i-cont).            
                find tt-ordem-quant
                    where tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem no-error.            
                if l-bt-qtde = yes then do: 
                    assign l-bt-qtde = no.
                    run createOrdensEmbarqueNovaParcela IN h-bocx225 (input tt-embarque-imp.r-rowid,
                                                                      input tt-ordem-compra.numero-ordem,
                                                                      input tt-ordem-quant.quantidade,
                                                                      input v-qtde-emb,
                                                                      input v-nova-parcela,
                                                                      output table RowErrors).
                end.
                else do:
                    run createOrdensEmbarque IN h-bocx225 (input tt-embarque-imp.r-rowid,
                                                           input tt-ordem-compra.numero-ordem,
                                                           input tt-ordem-quant.quantidade,
                                                           output table RowErrors).
                end.                                                       
                if can-find(first RowErrors) then do:
                    assign i-cont = brson1:num-selected-rows + 1.
                    
                end.
                else do:                    
                    IF AVAIL tt-ordem-compra AND AVAIL tt-embarque-imp AND c-nom-prog-upc-mg97 <> "" THEN DO:
                        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "converteQuantidadeFornecedor":U,
                                                        INPUT "NumeroOrdem":U,
                                                        INPUT BUFFER tt-ordem-compra:HANDLE,
                                                        INPUT FRAME fpage0:HANDLE,
                                                        INPUT STRING(tt-ordem-compra.numero-ordem) + ";" + STRING(tt-embarque-imp.cod-estabel) + ";" +  STRING(tt-embarque-imp.embarque),
                                                        INPUT IF AVAILABLE tt-embarque-imp THEN tt-embarque-imp.r-rowid ELSE ?) NO-ERROR.
                    END.

                    DELETE tt-ordem-quant.
                end.                   
            end.
        end.
        else do:
            if brson3:num-selected-rows = 0 then leave.   
            
            do i-cont = 1 to brson3:num-selected-rows:
               brson3:fetch-selected-row(i-cont).
             
               run createOrdensEmbarquebyparcela IN h-bocx225 (input tt-embarque-imp.r-rowid,
                                                               input tt-prazo-compra.numero-ordem,
                                                               input tt-prazo-compra.parcela,
                                                               input tt-prazo-compra.quant-saldo,
                                                               output table RowErrors).
                if can-find(first RowErrors) then do:
                  assign i-cont = brson3:NUM-SELECTED-ROWS + 1.
               end.               
               else do:
                    
                    if avail tt-prazo-compra and avail tt-embarque-imp AND c-nom-prog-upc-mg97 <> "" then do:
                        run value(c-nom-prog-upc-mg97) (input "converteQuantidadeFornecedor":U,
                                                        input "NumeroOrdem":U,
                                                        input buffer tt-prazo-compra:handle,
                                                        input frame fpage0:handle,
                                                        input string(tt-prazo-compra.numero-ordem) + ";" + string(tt-embarque-imp.cod-estabel) + ";" +  STRING(tt-embarque-imp.embarque),
                                                        input if available tt-embarque-imp then tt-embarque-imp.r-rowid else ?) no-error.
                    end.
               end.
    
               IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
                  if (search("imp/im0045x.p") <> ? OR search("imp/im0045x.r") <> ?) then do:
                      FIND FIRST prazo-compra NO-LOCK USE-INDEX ordem
                           WHERE prazo-compra.numero-ordem = tt-prazo-compra.numero-ordem
                             AND prazo-compra.parcela = tt-prazo-compra.parcela NO-ERROR.
                      if avail prazo-compra then 
                         run imp/im0045x.p (1, rowid(prazo-compra)).
                      if return-value = "NOK":U then
                          return "ERROR".
                  end.
               END.
            end.                                                  
        end.
        /*calculo das despesas do itiner†rio*/
        IF AVAIL param-imp
        AND SUBSTRING(param-imp.char-1,168,1) = "S" THEN
            RUN piCalculaDespItiner IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                                  INPUT tt-embarque-imp.embarque).
    END.
 
    IF CAN-FIND(FIRST RowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="yes"}
        RUN openQueriesSon IN THIS-PROCEDURE.            
          UNDO, RETURN NO-APPLY.
        
    END.
    ELSE DO:
         RUN openQueriesSon IN THIS-PROCEDURE.        
    END.    
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_drawback
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_drawback wMasterDetail
ON CHOOSE OF btn_drawback IN FRAME fPage1 /* Drawback */
DO:
&if defined (bf_dis_versao_ems) &then
  &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &THEN
    if brSon2:num-selected-rows in frame fPage1 = 0 then do:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Nenhum_Registro_Foi_Selecionado" *}
       message RETURN-VALUE.
    end.
    if brSon2:num-selected-rows in frame fPage1 <> 0 then do:
        browse brSon2:fetch-selected-row(brSon2:num-selected-rows).
        if avail tt-ordens-embarque then do:
           {cdp/cd4300.i4 "yes" tt-ordens-embarque.char-1}
           {imp/im0045ab.i51 "yes"}
           Run imp/im0045ab.w (input-output c-nr-ato-concessorio,
                               input tt-ordens-embarque.numero-ordem,
                               INPUT tt-ordens-embarque.quantidade).
                  
           RUN AtualizaOrdEmbAtoConce in h-bocx225 (input tt-ordens-embarque.numero-ordem,
                                                    input tt-ordens-embarque.parcela,
                                                    input c-nr-ato-concessorio).
           RUN findFirst      in h-bocx225.
           RUN openQueriesson in this-procedure.
           RUN findFirst      in h-bocx225.
        end.                                                 
    end.       
  &endif
&endif  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev-2 wMasterDetail
ON CHOOSE OF btPrev-2 IN FRAME fPage1 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:

    DEF VAR l-mensagem AS LOGICAL NO-UNDO.
    ASSIGN c-botao-press = "btPrev-2":U.

    def var i-cont as integer no-undo.
    &IF DEFINED(bf_dis_versao_ems) &THEN
        /* Chamada UPC - consist-contab */ 
        IF  c-nom-prog-upc-mg97 <> "" THEN DO:    
            run value(c-nom-prog-upc-mg97) (input "CONSIST-CONTAB", ~            
                                            input "tt-embarque-imp", ~           
                                            input this-procedure, ~              
                                            input frame {&FRAME-NAME}:handle, ~  
                                            input STRING(BUFFER tt-embarque-imp:HANDLE), ~           
                                            input ?) NO-ERROR.                          
            if  return-value = "adm-error" then do:
                SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
                return no-apply.        
            end.                                   
        END. 
        /* fim chamada upc */
    &else   
    &endif 
    
    if  tt-embarque-imp.contabilizado = yes then do:
        assign i-seq-erro = i-seq-erro + 1.
        create RowErrors.
        assign RowErrors.ErrorParameters = tt-embarque-imp.embarque
               RowErrors.errorsubtype = "Question".
        
        run utp/ut-msgs.p (input "show":U,
                           input 27737,
                           input tt-embarque-imp.embarque).
        
        if return-value = "NO" then do:
             SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
             return no-apply.        
        end.
    end.
    
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
        END. /* IF  RETURN-VALUE <> "yes" */
    END. /* IF  l-tax-siscomex THEN */

    IF l-IFRIC22 THEN DO:
        /* Verifica quantas ordens-embarque tem, se for a ultima que esta desvinculando avisar sobre antecipacoes */
        RUN Return_numRowsReturned IN h-bocx225(INPUT tt-embarque-imp.cod-estabel,
                                                INPUT tt-embarque-imp.embarque,
                                                OUTPUT i-num-ordens-embarque).

        RUN piEmbarqPossuiAntecip IN h-bocx00451 (INPUT tt-embarque-imp.cod-estabel,
                                                  INPUT tt-embarque-imp.embarque,
                                                  OUTPUT l-possui-antecip).

        IF l-possui-antecip AND i-num-ordens-embarque = brson2:num-selected-rows THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 55715, INPUT "").
            IF RETURN-VALUE = "YES":U THEN
                RUN piEliminaAntecipEmbarque IN h-bocx00451 (INPUT tt-embarque-imp.cod-estabel,
                                                             INPUT tt-embarque-imp.embarque).
            ELSE DO:
                SESSION:SET-WAIT-STATE("":U).
                RETURN NO-APPLY.
            END.
        END.
    END.

    IF NOT VALID-HANDLE(h-bocx225del) THEN
       RUN cxbo/bocx225.p PERSISTENT SET h-bocx225del.

    RUN validateEliminacaoOrdem IN h-bocx225del (INPUT tt-embarque-imp.cod-estabel,
                                                 INPUT tt-embarque-imp.embarque,   
                                                 OUTPUT p-mensagem).

    IF  p-mensagem <> "" THEN DO:
        run utp/ut-msgs.p (input "show":U,
                           input 28547,
                           input string(tt-embarque-imp.embarque) + "~~" + p-mensagem).

        if  return-value = "NO" then do:
            SESSION:SET-WAIT-STATE("":U). /*embarque esta contabilizado*/
            return no-apply.        
        end. /* if  return-value = "NO" then */
    END. /* IF  p-mensagem <> "" THEN */
    
    if brson2:num-selected-rows = 0 then leave.
    
    ASSIGN l-mensagem = NO.
    do  i-cont = 1 to brson2:num-selected-rows:
    
        brson2:fetch-selected-row(i-cont).

        &if '{&bf_mat_versao_ems}' = '2.062' &then
            RUN BuscaEqEmbarqPrazCompra IN h-bocx225del (INPUT tt-ordens-embarque.numero-ordem, INPUT tt-ordens-embarque.parcela).
            IF  RETURN-VALUE = "OK":U THEN DO:
                IF  NOT l-mensagem THEN DO:
                    ASSIGN l-mensagem = YES.
                    run utp/ut-msgs.p (input "show":U, input 30879, input "").
                    if  return-value = "NO":U then do:
                        SESSION:SET-WAIT-STATE("":U). 
                        LEAVE.
                    end. /* if  return-value = "NO":U then */
                END. /* IF  NOT l-mensagem THEN */
            END. /* IF  RETURN-VALUE = "OK":U THEN */
        &endif        
        RUN validateDelete IN h-bocx225del (INPUT-OUTPUT tt-ordens-embarque.r-rowid, OUTPUT TABLE RowErrors).

        IF  CAN-FIND(FIRST RowErrors) THEN DO:
            assign i-cont = brson2:num-selected-rows + 1.
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="yes"}
            UNDO, RETURN NO-APPLY.
        END. /* IF  CAN-FIND(FIRST RowErrors) */
        ELSE DO:
            /*---[ Conforme t¢pico 1.2.5.9 da DIS do projeto 0079 - Vis∆o DI ]-----------------------------------------------------------------------------------------------------*/
            ASSIGN l-integra-di = NO.
        
            RUN verificaIntegraDI IN h-bocx404 (INPUT tt-ordens-embarque.numero-ordem, INPUT tt-ordens-embarque.parcela, OUTPUT l-integra-di).
            IF  l-integra-di THEN DO:
                IF  NOT l-rodaUmaVez THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-ordem-vinculada-a-uma-declarac-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Ordem_vinculada_a_uma_Declaraá∆o_de_Importaá∆o" *}
                    ASSIGN c-lbl-liter-ordem-vinculada-a-uma-declarac-2 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-ordem-esta-vinculada-a-uma-dec-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Ordem_est†_vinculada_a_uma_Declaraá∆o_de_Importaá∆o,_deseja_desvincular?" *}
                    ASSIGN c-lbl-liter-ordem-esta-vinculada-a-uma-dec-2 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-as-adicoes-e-itens-da-di-serao-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "As_Adiá‰es_e_Itens_da_DI_ser∆o_regerados._A_funá∆o_de_rateio_e_c†lculo_dos_impostos_devem_ser_executadas_novamente" *}
                    ASSIGN c-lbl-liter-as-adicoes-e-itens-da-di-serao-2 = TRIM(RETURN-VALUE).
                    RUN utp/ut-msgs.p (INPUT "show":U, INPUT 27100, INPUT c-lbl-liter-ordem-vinculada-a-uma-declarac-2 + '!' + '~~' + 
                                                                          c-lbl-liter-ordem-esta-vinculada-a-uma-dec-2 + ' ' + CHR(10) +
                                                                          c-lbl-liter-as-adicoes-e-itens-da-di-serao-2 + '!').
                    IF  RETURN-VALUE = "YES":U THEN DO:
                        RUN desvinculaOrdem IN h-bocx404(INPUT tt-ordens-embarque.numero-ordem, INPUT tt-ordens-embarque.parcela).
                    END. /* IF  RETURN-VALUE = "YES":U */
                    ELSE DO:
                        ASSIGN i-cont = brson2:NUM-SELECTED-ROWS IN FRAME fPage1 + 1.
                        UNDO, RETURN NO-APPLY.
                    END. /* ELSE DO: */
                END. /* IF  NOT l-rodaUmaVez THEN DO: */
                ELSE DO:
                    RUN desvinculaOrdem IN h-bocx404(INPUT tt-ordens-embarque.numero-ordem, INPUT tt-ordens-embarque.parcela).
                END. /* ELSE DO: */
            END. /* IF  l-integra-di */
            /*---[ Conforme t¢pico 1.2.5.9 da DIS do projeto 0079 - Vis∆o DI ]-----------------------------------------------------------------------------------------------------*/
        
            IF  c-botao-press = "btFirst-2":U THEN ASSIGN l-rodaUmaVez = YES.
                
            IF  AVAIL tt-ordens-embarque THEN DO:
                FIND FIRST tt-ordem-quant
                     WHERE tt-ordem-quant.numero-ordem = tt-ordens-embarque.numero-ordem NO-ERROR.
                IF  AVAIL tt-ordem-quant THEN DO:
                    RUN pi-calculaQtdeDisponivel IN h-bocx225del (INPUT tt-ordem-quant.numero-ordem, OUTPUT de-quant-disp).
                    ASSIGN tt-ordem-quant.quantidade = de-quant-disp.
                END. /* IF  AVAIL tt-ordem-quant THEN */

                &IF DEFINED(bf_dis_versao_ems) &THEN
                    /* Chamada UPC */ 
                    IF  c-nom-prog-upc-mg97 <> "" THEN DO:    
                        run value(c-nom-prog-upc-mg97) (input "FIM-BTPREV-2", ~
                                                        input "tt-ordens-embarque", ~           
                                                        input this-procedure, ~              
                                                        input frame {&FRAME-NAME}:handle, ~  
                                                        INPUT STRING(tt-ordens-embarque.numero-ordem) + ";" + STRING(tt-ordens-embarque.parcela) + ";" + STRING(tt-ordens-embarque.cod-estabel) + ";" +  STRING(tt-ordens-embarque.embarque),
                                                        INPUT IF AVAILABLE tt-ordens-embarque THEN tt-ordens-embarque.r-rowid ELSE ?) NO-ERROR.                         
                        if  return-value = "adm-error" then do:
                            SESSION:SET-WAIT-STATE("":U). 
                            return no-apply.        
                        end.                                   
                    END. 
                    /* fim chamada upc */
                &else   
                &endif

                FOR EACH ordens-embarque-trib EXCLUSIVE-LOCK
                   WHERE ordens-embarque-trib.cod-estabel  = tt-ordens-embarque.cod-estabel
                     AND ordens-embarque-trib.embarque     = tt-ordens-embarque.embarque
                     AND ordens-embarque-trib.numero-ordem = tt-ordens-embarque.numero-ordem
                     AND ordens-embarque-trib.parcela      = tt-ordens-embarque.parcela:
                    DELETE ordens-embarque-trib.
                END.
                
                DELETE tt-ordens-embarque.
            END. /* IF  AVAIL tt-ordens-embarque THEN */
        END. /* ELSE DO: */
    end. /* do  i-cont = 1 to brson2: */

    RUN openQueriesSon IN THIS-PROCEDURE.    

    /* Licenciamento Importacao */
    &if "{&bf_mat_versao_ems}" >= "2.062":U &then
    
        run  piNecessitaLiEmbarque in h-bocx225del (input tt-embarque-imp.cod-estabel, 
                                                    input tt-embarque-imp.embarque,    
                                                    output table rowErrors).
        IF CAN-FIND(FIRST RowErrors) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="yes"}
        END.
    &endif
    IF VALID-HANDLE(h-bocx225del) THEN DO:
        DELETE PROCEDURE h-bocx225del.
        ASSIGN h-bocx225del = ?.
    END.

    ASSIGN c-botao-press = "":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQtde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQtde wMasterDetail
ON CHOOSE OF btQtde IN FRAME fPage1 /* Qtde */
DO:
    def var de-quant-embarq like prazo-compra.quantidade   no-undo.
    def var d-entrega       as   date                      no-undo.
    def var dt-entrega      as   date                      no-undo.
    def var de-quant-parc   like prazo-compra.quantidade   no-undo.
    def var c-cod-un        like ITEM.un                   no-undo.
    def var c-cod-un-fornec like cotacao-item.un           no-undo.

    if l-relaciona = no then do:
       
       FIND tt-ordem-quant WHERE 
            tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem NO-ERROR.

       RUN validavinculacaoordens IN h-bocx225 (INPUT tt-embarque-imp.embarque,
                                                INPUT tt-embarque-imp.cod-estabel,
                                                INPUT tt-ordem-quant.numero-ordem,
                                                INPUT 0, /*quando o tratamento est† por ordem-compra pois nao tem a parcela na tt-ordem-compra*/
                                                OUTPUT TABLE RowErrors).

       IF NOT can-find(FIRST RowErrors) THEN DO:
               /* Via de Transporte */
               RUN piValidaViaTransp (INPUT  tt-ordem-quant.numero-ordem,
                                      OUTPUT l-via-transp,
                                      OUTPUT l-primer-ord).
               IF  l-valida-viatransp THEN DO: /* Funáao spp-via-transp-dif */ 
                   IF  l-via-transp THEN
                       run utp/ut-msgs.p (input "show":U,
                                          input 54556, /* alerta */
                                          input STRING(tt-ordem-quant.numero-ordem)).
               END.
               ELSE DO:
                   IF  l-via-transp THEN DO: /* Via de transporte da ordem Ç diferente da via de transporte do embarque */
                       IF  l-primer-ord THEN DO: /* primeira ordem vinculada */
                           run utp/ut-msgs.p (input "show":U, input 54557, input STRING(tt-ordem-quant.numero-ordem)). /* confirma e atualiza */
                           if  return-value <> "yes" then do: 
                               SESSION:SET-WAIT-STATE("":U).
                               return no-apply.
                           end.
                           ELSE DO:
                               RUN piAtualizaViaTransp IN h-bocx225 (INPUT tt-embarque-imp.embarque,    
                                                                     INPUT tt-embarque-imp.cod-estabel).
                           END.
                       END.
                       ELSE DO:
                           run utp/ut-msgs.p (input "show":U, input 54558, input STRING(tt-ordem-quant.numero-ordem)). /* erro */  
                           SESSION:SET-WAIT-STATE("":U).
                           return no-apply.
                       END.
                   END.
               END.
       
               RUN imp/im0045aa.w (input tt-ordem-quant.numero-ordem,
                                   input tt-ordem-compra.it-codigo,
                                   input tt-ordem-quant.quantidade,
                                   input tt-ordem-quant.un,
                                   input tt-ordem-quant.qtd-do-forn,
                                   input tt-ordem-quant.un-fornec,
                                   output de-quant-embarq).

               &IF DEFINED(bf_dis_versao_ems) &THEN
               IF ((c-nom-prog-upc-mg97 <> "":U AND c-nom-prog-upc-mg97 <> ?) AND RETURN-VALUE <> "NOK":U) OR
                   ((c-nom-prog-upc-mg97 <> "":U AND c-nom-prog-upc-mg97 <> ?) AND "{&StopOnErro}":U = "NO":U) THEN DO:
                    ASSIGN lCustomExecuted = YES.
                    
                    RUN VALUE(c-nom-prog-upc-mg97) (INPUT "After-im0045aa-OC":U,
                                                    INPUT "browse":U,
                                                    INPUT BUFFER tt-ordem-quant:HANDLE,
                                                    INPUT FRAME fPage0:HANDLE,
                                                    INPUT STRING(de-quant-embarq),
                                                    INPUT IF AVAILABLE tt-ordem-quant THEN tt-ordem-quant.r-rowid ELSE ?).

                    if  return-value = "adm-error" then do:
                        SESSION:SET-WAIT-STATE("":U).
                        return no-apply.        
                    end.
               END.
               &endif
              
               if de-quant-embarq < tt-ordem-quant.quantidade and
                  de-quant-embarq > 0 then do:

                    IF c-nom-prog-upc-mg97 <> "" THEN DO:    
                       run value(c-nom-prog-upc-mg97) (input "OnChoosebtQtde":U,
                                                       input "OnChoosebtQtde":U,
                                                       input buffer tt-embarque-imp:handle,
                                                       input frame fpage0:handle,
                                                       input string(tt-ordem-quant.numero-ordem) + ";" + string(de-quant-embarq),
                                                       input if available tt-embarque-imp then tt-embarque-imp.r-rowid else ?) no-error.
                    end.

                    if return-value = "yes" and c-nom-prog-upc-mg97 <> "" then do:
                        assign lCustomExecuted = YES.
                      	run openQueriesSon in this-procedure.                                          
                    end.
                    else do:
                      assign v-cod-estabel   = tt-embarque-imp.cod-estabel
                             v-qtde-emb      = de-quant-embarq
                             v-qtde-n-emb    = (tt-ordem-quant.quantidade - de-quant-embarq).
                  
                       run RetornaDataParcelaNaoEmbarcada in h-bocx225 (input  tt-embarque-imp.cod-estabel ,
                                                                        input  tt-embarque-imp.embarque,
                                                                        input  tt-ordem-compra.numero-ordem,
                                                                        output dt-entrega).        
                  
                      	RUN imp/im9997.p(INPUT  v-cod-estabel ,
                       		             INPUT  tt-ordem-quant.quantidade, 
                       	                 INPUT  v-qtde-n-emb  ,
                                         INPUT  dt-entrega,
                                         OUTPUT v-nova-entrega,
                                         OUTPUT v-retorno).
                    
                  if v-retorno = "NOK" or v-nova-entrega = ? then do:
                     assign de-quant-embarq = 0.
                  end.
                  else do:
                     run RetornaDataEntregaNovaParcela in h-boin356aa (input  v-cod-estabel,
                                                                       input  tt-ordem-quant.numero-ordem,
                                                                       input  v-nova-entrega,
                                                                       output d-entrega).
                     if d-entrega = ? then.
                     else assign v-nova-entrega = d-entrega.  

                  
                     assign l-bt-qtde = yes.                                                                       
                     /*apply "choose" to btnext-2 in frame {&frame-name}.*/
                     find tt-ordem-quant
                        where tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem no-error.            
			    
                     if l-bt-qtde = yes then do:
                        assign l-bt-qtde = no.
                        IF NOT VALID-HANDLE(h-bocx225) THEN 
                            RUN cxbo/bocx225.p persistent set h-bocx225.  
                
                        run setCreatehist in h-bocx225.                
                           
                        ASSIGN i-numero-ordem = tt-ordem-compra.numero-ordem.
                        RUN ValidaNovaDataEntrega.
                                                
                        if NOT can-find(first RowErrorsAux WHERE RowErrorsAux.ErrorSubType = "ERROR":U) AND 
                           NOT can-find(first RowErrors)  then do:
                           run createOrdensEmbarqueNovaParcela IN h-bocx225 (input tt-embarque-imp.r-rowid,
                                                                             input tt-ordem-compra.numero-ordem,
                                                                             input tt-ordem-quant.quantidade,
                                                                             input v-qtde-emb,
                                                                             input v-nova-entrega             ,
                                                                             output table RowErrors).
                        END.
                     end.
                     if not can-find(first RowErrors) then do:
                                               
                        run cria-nova-parcela-by-ordem-2 in h-boin356aa (input tt-embarque-imp.cod-estabel,
                                                                         input tt-ordem-quant.numero-ordem,
                                                                         input tt-ordem-quant.quantidade  ,
                                                                         input tt-embarque-imp.embarque   ,
                                                                         input v-qtde-emb                 ,
                                                                         input v-qtde-n-emb               ,
                                                                         input v-nova-entrega             ,
                                                                         output v-nova-parcela            ).
                        DELETE tt-ordem-quant.
                     end.              

                     FOR EACH RowErrorsAux
                         BY RowErrorsAux.ErrorSequence:
                         CREATE RowErrors.
                         BUFFER-COPY RowErrorsAux TO RowErrors.
                         DELETE RowErrorsAux.
                     END.

                     IF CAN-FIND(FIRST RowErrors) THEN DO:
                         {method/showmessage.i1}
                         {method/showmessage.i2 &Modal="yes"}
                        RUN openQueriesSon IN THIS-PROCEDURE.      

                        /*calculo das despesas do itiner†rio*/
                        IF AVAIL param-imp
                        AND SUBSTRING(param-imp.char-1,168,1) = "S" THEN
                            RUN piCalculaDespItiner IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                                                  INPUT tt-embarque-imp.embarque).


                        FOR EACH RowErrors:
                            DELETE RowErrors.
                        END.
                        UNDO, RETURN NO-APPLY.
                     END.
                     ELSE DO:
                        /*calculo das despesas do itiner†rio*/
                        IF AVAIL param-imp
                        AND SUBSTRING(param-imp.char-1,168,1) = "S" THEN
                            RUN piCalculaDespItiner IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                                                  INPUT tt-embarque-imp.embarque).
                        RUN openQueriesSon IN THIS-PROCEDURE.        
                     END.
                  end.                
               end.
           END.
       END.
       ELSE DO:

           IF CAN-FIND(FIRST RowErrors) THEN DO:
               {method/showmessage.i1}
               {method/showmessage.i2 &Modal="yes"}
              RUN openQueriesSon IN THIS-PROCEDURE.            

              /*calculo das despesas do itiner†rio*/
              IF AVAIL param-imp
              AND SUBSTRING(param-imp.char-1,168,1) = "S" THEN
                  RUN piCalculaDespItiner IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                                        INPUT tt-embarque-imp.embarque).

              FOR EACH RowErrors:
                  DELETE RowErrors.
              END.
              UNDO, RETURN NO-APPLY.
           END.
           ELSE DO:
              /*calculo das despesas do itiner†rio*/
              IF AVAIL param-imp
              AND SUBSTRING(param-imp.char-1,168,1) = "S" THEN
                  RUN piCalculaDespItiner IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                                        INPUT tt-embarque-imp.embarque).
              RUN openQueriesSon IN THIS-PROCEDURE.        
           END.
       END.
    end.
    else do:            
        ASSIGN c-cod-un = fnUn(input tt-prazo-compra.it-codigo).
        ASSIGN c-cod-un-fornec = fnUnFornec(input tt-prazo-compra.numero-ordem).
        
        RUN validavinculacaoordens IN h-bocx225 (INPUT tt-embarque-imp.embarque,    
                                                 INPUT tt-embarque-imp.cod-estabel, 
                                                 INPUT tt-prazo-compra.numero-ordem,
                                                 INPUT tt-prazo-compra.parcela, 
                                                 OUTPUT TABLE RowErrors).

        IF NOT can-find(FIRST RowErrors) THEN DO:
                /* Via de Transporte */
                RUN piValidaViaTransp (INPUT  tt-prazo-compra.numero-ordem,
                                       OUTPUT l-via-transp,
                                       OUTPUT l-primer-ord).
                IF  l-valida-viatransp THEN DO: /* Funáao spp-via-transp-dif */ 
                    IF  l-via-transp THEN
                        run utp/ut-msgs.p (input "show":U,
                                           input 54556, /* alerta */
                                           input STRING(tt-prazo-compra.numero-ordem)).
                END.
                ELSE DO:
                    IF  l-via-transp THEN DO: /* Via de transporte da ordem Ç diferente da via de transporte do embarque */
                        IF  l-primer-ord THEN DO: /* primeira ordem vinculada */
                            run utp/ut-msgs.p (input "show":U, input 54557, input STRING(tt-prazo-compra.numero-ordem)). /* confirma e atualiza */
                            if  return-value <> "yes" then do: 
                                SESSION:SET-WAIT-STATE("":U).
                                return no-apply.
                            end.
                            ELSE DO:
                                RUN piAtualizaViaTransp IN h-bocx225 (INPUT tt-embarque-imp.embarque,    
                                                                      INPUT tt-embarque-imp.cod-estabel).
                            END.
                        END.
                        ELSE DO:
                            run utp/ut-msgs.p (input "show":U, input 54558, input STRING(tt-prazo-compra.numero-ordem)). /* erro */  
                            SESSION:SET-WAIT-STATE("":U).
                            return no-apply.
                        END.
                    END.
                END.
                              
                RUN imp/im0045aa.w (input tt-prazo-compra.numero-ordem,
                                    input tt-prazo-compra.it-codigo,
                                    input tt-prazo-compra.quant-saldo,
                                    input c-cod-un,
                                    input tt-prazo-compra.qtd-sal-forn,
                                    input c-cod-un-fornec,
                                    output de-quant-embarq).
                &IF DEFINED(bf_dis_versao_ems) &THEN
                IF ((c-nom-prog-upc-mg97 <> "":U AND c-nom-prog-upc-mg97 <> ?) AND RETURN-VALUE <> "NOK":U) OR
                   ((c-nom-prog-upc-mg97 <> "":U AND c-nom-prog-upc-mg97 <> ?) AND "{&StopOnErro}":U = "NO":U) THEN DO:
                    ASSIGN lCustomExecuted = YES.

                    RUN VALUE(c-nom-prog-upc-mg97) (INPUT "After-im0045aa-PA":U,
                                                    INPUT "browse":U,
                                                    INPUT BUFFER tt-prazo-compra:HANDLE,
                                                    INPUT FRAME fPage0:HANDLE,
                                                    INPUT STRING(de-quant-embarq),
                                                    INPUT IF AVAILABLE tt-prazo-compra THEN tt-prazo-compra.r-rowid ELSE ?).
                

                    if  return-value = "adm-error" then do:
                        SESSION:SET-WAIT-STATE("":U).
                        return no-apply.        
                    end.
                END.
                &ENDIF
                             

                IF AVAIL  TT-PRAZO-COMPRA THEN DO:
                    if de-quant-embarq < tt-prazo-compra.quant-saldo and
                       de-quant-embarq > 0 then do:
                        
                      
                       assign  v-cod-estabel   = tt-embarque-imp.cod-estabel
                               v-qtde-emb      = de-quant-embarq
                               v-qtde-n-emb    = (tt-prazo-compra.quant-saldo - de-quant-embarq).
                      
                       RUN imp/im9997.p(INPUT  v-cod-estabel ,
                                        INPUT  tt-prazo-compra.quant-saldo, 
                                        INPUT  v-qtde-n-emb  ,
                                        INPUT  tt-prazo-compra.data-entrega,
                                        OUTPUT v-nova-entrega,
                                        OUTPUT v-retorno).
                      
                        if v-retorno = "NOK" or v-nova-entrega = ? then do:
                          assign de-quant-embarq = 0.
                       end.
                       else do:
                          if avail tt-prazo-compra then do:
                              assign tt-prazo-compra.quantidade = v-qtde-emb.
                              run RetornaDataEntregaNovaParcela in h-boin356aa (input  v-cod-estabel,
                                                                                input  tt-prazo-compra.numero-ordem,
                                                                                input  v-nova-entrega,
                                                                                output d-entrega).
                              if d-entrega = ? then.
                              else assign v-nova-entrega = d-entrega.                   
                                     
                              run setCreatehist in h-bocx225.
                       
                              ASSIGN i-numero-ordem  = tt-prazo-compra.numero-ordem.
                              RUN ValidaNovaDataEntrega.

                              if not can-find(first RowErrorsAux WHERE RowErrorsAux.ErrorSubType = "ERROR":U) and
                                 not can-find(first RowErrors) then do:
                                    run createOrdensEmbarquebyparcela IN h-bocx225 (input tt-embarque-imp.r-rowid,
                                                                                 input tt-prazo-compra.numero-ordem,
                                                                                 input tt-prazo-compra.parcela,
                                                                                 input tt-prazo-compra.quantidade,
                                                                                 output table RowErrors).
                              
                              end.
                               if not can-find(first RowErrors) AND 
                                  NOT CAN-FIND(FIRST RowErrorsAux WHERE RowErrorsAux.ErrorSubType = "ERROR":U) then do:
                                  run cria-nova-parcela in h-boin356aa (input tt-embarque-imp.cod-estabel ,
                                                                        input tt-prazo-compra.numero-ordem,
                                                                        input tt-prazo-compra.parcela     ,
                                                                        input tt-embarque-imp.embarque    ,
                                                                        input v-qtde-emb                  ,
                                                                        input v-qtde-n-emb                ,
                                                                        input v-nova-entrega              ,
                                                                        input "parcela").    
                            
                               end.
                               
                               IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
                                    if search("imp/im0045x.p") <> ? or
                                       search("imp/im0045x.r") <> ? then do:
                                       FIND FIRST prazo-compra NO-LOCK USE-INDEX ordem WHERE 
                                                  prazo-compra.numero-ordem = tt-prazo-compra.numero-ordem AND 
                                                  prazo-compra.parcela      = tt-prazo-compra.parcela  NO-ERROR.
                                       if avail prazo-compra then      
                                           run imp/im0045x.p (1, rowid(prazo-compra)).
                                       if  return-value = "NOK":U then
                                           return "ERROR".
                                    end.
                               END.
                          end.
                          FOR EACH RowErrorsAux
                             BY RowErrorsAux.ErrorSequence:
                             CREATE RowErrors.
                             BUFFER-COPY RowErrorsAux TO RowErrors.
                             DELETE RowErrorsAux.
                          END.
    
                          IF CAN-FIND(FIRST RowErrors) THEN DO:
                              {method/showmessage.i1}
                              {method/showmessage.i2 &Modal="yes"}
                              RUN openQueriesSon IN THIS-PROCEDURE.            
    
                               /*calculo das despesas do itiner†rio*/
                              IF AVAIL param-imp
                              AND SUBSTRING(param-imp.char-1,168,1) = "S" THEN
                                  RUN piCalculaDespItiner IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                                                        INPUT tt-embarque-imp.embarque).
    
                              FOR EACH RowErrors:
                                  DELETE RowErrors.
                              END.
                              UNDO, RETURN NO-APPLY.
                          END.
                          ELSE DO:
                                /*calculo das despesas do itiner†rio*/
                              IF AVAIL param-imp
                              AND SUBSTRING(param-imp.char-1,168,1) = "S" THEN
                                  RUN piCalculaDespItiner IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                                                        INPUT tt-embarque-imp.embarque).

                              RUN openQueriesSon IN THIS-PROCEDURE.        
                          END.
                       end.                
                end.
                END.      

        END.
        ELSE DO:
            IF CAN-FIND(FIRST RowErrors) THEN DO:
               {method/showmessage.i1}
               {method/showmessage.i2 &Modal="yes"}
                /*calculo das despesas do itiner†rio*/
               IF AVAIL param-imp
               AND SUBSTRING(param-imp.char-1,168,1) = "S" THEN
                   RUN piCalculaDespItiner IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                                         INPUT tt-embarque-imp.embarque).

               RUN openQueriesSon IN THIS-PROCEDURE.            

               FOR EACH RowErrors:
                   DELETE RowErrors.
               END.
               UNDO, RETURN NO-APPLY.
            END.
            ELSE DO:
                /*calculo das despesas do itiner†rio*/
               IF AVAIL param-imp
               AND SUBSTRING(param-imp.char-1,168,1) = "S" THEN
                   RUN piCalculaDespItiner IN h-bocx225 (INPUT tt-embarque-imp.cod-estabel,
                                                         INPUT tt-embarque-imp.embarque).

               RUN openQueriesSon IN THIS-PROCEDURE.        
            END.
        END.
    end.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btselecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btselecao wMasterDetail
ON CHOOSE OF btselecao IN FRAME fPage1 /* Seleá∆o */
DO:
  /*disable btexit with frame f-cad.
  assign MENU-ITEM mi-sair:SENSITIVE IN MENU mbMain = no
         l-sel                                      = yes.
  */
  SESSION:SET-WAIT-STATE("general":U).
  run pi-bt-sel in this-procedure.         
  SESSION:SET-WAIT-STATE("":U).    
  assign l-sel = no.
  /*run pi-habilita in this-procedure.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_li
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_li wMasterDetail
ON CHOOSE OF bt_li IN FRAME fPage1 /* LI/Class. Fiscal */
DO:
  &if defined (bf_dis_versao_ems)  &then
    &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &THEN
        def var c-item      as char no-undo.
        def var i-nr-ordem  as int  no-undo.
 
        if brSon1:num-selected-rows in frame fPage1 = 0 then do:
           /* Inicio -- Projeto Internacional */
           {utp/ut-liter.i "N∆o_Existem_Registros" *}
           message RETURN-VALUE.
        end.
        if brSon1:num-selected-rows in frame fPage1 <> 0 then do:
           browse brSon1:fetch-selected-row(int(brSon1:num-selected-rows)).
           assign c-item       = tt-ordem-compra.it-codigo
                  i-nr-ordem   = tt-ordem-compra.numero-ordem.
           run imp/im0045f.w (input table tt-ordem-compra).          
        end.
    &endif   
&endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-classif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-classif wMasterDetail
ON VALUE-CHANGED OF i-classif IN FRAME fPage1
DO:
  i-classif = input frame fPage1 i-classif. 
  run openQueriesSon in this-procedure. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializaá∆o do programam ---*/
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
    
    delete procedure h-bocx140.
    delete procedure h-boin274.  
    delete procedure h-boin172.  
    delete procedure h-boin082. 
    delete procedure h-bocx404. 
    if valid-handle(h-bocx00451) then
        run Destroy in h-bocx00451.

    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
        IF VALID-HANDLE(h-bocx225) THEN
           DELETE PROCEDURE h-bocx225.
         ASSIGN h-bocx225 = ?.
    &endif 
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
    
    IF NOT AVAIL param-imp THEN
        FOR FIRST param-imp NO-LOCK
            WHERE param-imp.cod-estabel = tt-embarque-imp.cod-estabel:
        END.
    enable i-classif with frame fPage1.
    &if defined (bf_dis_versao_ems) &then
        
        IF i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
            IF NOT l-ems2-imp-mexico THEN
                assign btn_drawback:hidden in frame fPage1 = no.
        END.
        ELSE DO:
            FIND FIRST param-global NO-LOCK NO-ERROR.
            IF AVAIL param-global AND param-global.log-modul-draw 
                AND AVAIL param-imp AND SUBSTRING(param-imp.char-1,249,1) <> "S" THEN
                ASSIGN btn_drawback:HIDDEN IN FRAME fPage1 = NO.            
        END.        
         
         assign btselecao:HIDDEN IN FRAME fPage1 = NO.

         apply "choose":U to btselecao in frame fpage1.  /*executa o programa de parametros.*/
    &endif 
    
    if l-relaciona = no then
    do:
       hide brson3 in frame fpage1.
       view brson1 in frame fpage1. 
       enable brson1 with frame fpage1.
    end.
    else do:
       assign i-classif:radio-buttons in frame fpage1 = 'Ordens,1,Itens,2,Entregas,3'.
       hide brson1 in frame fpage1.
       view brson3 in frame fpage1. 
       enable brson3 with frame fpage1.
    end.
    
    RUN retorna-spp-via-transp-dif (OUTPUT l-valida-viatransp). 

    ASSIGN l-rodaUmaVez = NO.
    
    IF  i-pais-impto-usuario <> 1 /* Brasil */ AND 
        tt-embarque-imp.log-embarq-transf-draw THEN 
        ASSIGN btn_drawback:SENSITIVE IN FRAME fpage1 = NO.

    IF l-IFRIC22 THEN DO:
       RUN Return_numRowsReturned IN h-bocx225(INPUT tt-embarque-imp.cod-estabel,
                                               INPUT tt-embarque-imp.embarque,
                                               OUTPUT i-num-ordens-inicial).
       
        IF CAN-FIND(FIRST {&ttSon2}) THEN
            EMPTY TEMP-TABLE tt-ordens-embarque-comp.

        FOR EACH {&ttSon2}:
            CREATE tt-ordens-embarque-comp.
            BUFFER-COPY {&ttSon2} TO tt-ordens-embarque-comp.
        END.
    END.

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

    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:
       RUN cxbo/bocx220.p persistent set h-bocx220.
    END.
    
    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOParent} (INPUT 2).
    &ELSE
        RUN openQueryStatic IN {&hDBOParent} (INPUT "cod-estabel":U).
    &ENDIF
    
    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) THEN DO:
       RUN cxbo/bocx225a.p persistent set h-bocx225a.
    END.
    
    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) THEN DO:
       RUN cxbo/bocx225.p persistent set h-bocx225.
    END.
    
    IF NOT VALID-HANDLE({&hDBOSon3}) THEN DO:
       RUN inbo/boin356aa.p persistent set h-boin356aa.
    END. 
        
    IF NOT VALID-HANDLE(h-bocx140) THEN
        RUN cxbo/bocx140.p  persistent set h-bocx140.

    
    enable brSon2 
           btNext-2 
           btLast-2 
           btPrev-2 
           btFirst-2 
           btQTde 
           with frame fPage1.
 
    &if defined (bf_dis_versao_ems) &then
        
        ASSIGN btn_drawback:SENSITIVE IN FRAME fPage1 = YES 
               btselecao:SENSITIVE IN FRAME fPage1    = YES.
     
    &endif

    /* Busca idioma do usuario */

    &IF '{&mgdis_version}' >= '2.06f' &THEN
       run fnbo/bofn017.p  persistent set h-bofn017.
       run gotokey IN h-bofn017 (input v_cod_usuar_corren).
       IF RETURN-VALUE = "OK" THEN
           RUN getCharfield IN h-bofn017 (INPUT "cod_idiom_orig":U,
                                          OUTPUT c-idiom-usuar).                               
           RUN pi-recebe-idioma IN h-bocx225 (INPUT c-idiom-usuar).
           delete procedure h-bofn017.
    &ELSE   
        run unbo/boun178.p  persistent set h-boun178.
        run findSrmstr_id IN h-boun178 (input v_cod_usuar_corren,
                                        output c-return).
        IF c-return = "" THEN
            RUN getCharfield IN h-boun178 (INPUT "cod_idiom_orig":U,
                                           OUTPUT c-idiom-usuar).                               
            RUN pi-recebe-idioma IN h-bocx225 (INPUT c-idiom-usuar).
            delete procedure h-boun178.
    &ENDIF
    

    
    /* Parametro de importaá∆o: relaciona ordens ou parcelas */ 
    RUN cxbo/bocx250.p  persistent set h-bocx250.
    RUN findCodigo IN h-bocx250 (input  pcod-estabel,
                                 output c-return).
    IF c-return = "" THEN
       RUN retornarelaciona IN h-bocx250 (outPUT l-relaciona).           
    delete procedure h-bocx250.   
    
    IF NOT VALID-HANDLE(h-boin274) THEN DO:
       RUN inbo/boin274.p persistent set h-boin274. 
    end.

    IF NOT VALID-HANDLE(h-boin172) THEN DO:
       RUN inbo/boin172.p persistent set h-boin172.
    end.

    RUN openQueryStatic IN h-boin172(INPUT "Main":U).

    IF NOT VALID-HANDLE(h-boin082) THEN DO:
       RUN inbo/boin082.p persistent set h-boin082.
    end.

    RUN openQueryStatic IN h-boin082(INPUT "Main":U).

    IF NOT VALID-HANDLE(h-bocx404) THEN DO:
       RUN cxbo/bocx404.p persistent set h-bocx404.
    end.

    RUN openQueryStatic IN h-bocx404(INPUT "Main":U).

    IF NOT VALID-HANDLE(h-bocx00451) AND l-IFRIC22 THEN
        RUN cxbo/bocx00451.p PERSISTENT SET h-bocx00451.

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
    for each tt-ordem-compra:
        delete tt-ordem-compra.
    end.
    
    for each tt-prazo-compra:
        delete tt-prazo-compra. 
    end.

    if l-relaciona = no then do:
        if i-num-pedido-imp <> ? then do:
            run setConstraint3 IN {&hDBOSon1} (input i-num-pedido-imp).
            assign i-num-pedido-imp = ?.
        end.
    end.
    else do:
        if i-num-pedido-imp <> ? then do:
            run setConstraint5 IN {&hDBOSon3} (input i-num-pedido-imp).
            assign i-num-pedido-imp = ?.
        end.    
    end.
    
    if avail tt-embarque-imp then
        assign r-embarque-imp = tt-embarque-imp.r-rowid.
    else
        assign r-embarque-imp = ?.
    
    if l-relaciona = no then do:
        if i-classif = 1 then do:
           /**************
           {masterdetail/OpenQueriesSon.i
                   &Parent="tt-embarque-imp"
                   &Query="CodEstabel"
                   &PageNumber="1"
                   &QueryConstraint="2"
                   &ConstraintParameters="r-embarque-imp"}            
    
            run setConstraint2 in {&hDBOSon1} (input tt-embarque-imp.r-rowid).
                
            run OpenQuery in {&hDBOSon1} (input 2).
            run findFirst in {&hDBOSon1}.
            
            run serverSendRows in {&hDBOSon1} (input ?,
                                             input ?,
                                             input no,
                                             input ?,
                                             output rowsreturn,
                                             output table {&ttSon1}).
            */         
                                    
            &IF DEFINED(DBOVersion) <> 0 &THEN
                 
                 RUN setConstraint2 IN {&hDBOSon1} (INPUT r-embarque-imp
                                                    &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &THEN ,
                                                        INPUT v-cod-proces-imp-f,  
                                                        INPUT v-cod-proces-imp-i,  
                                                        INPUT v-num-ped-compra-f,  
                                                        INPUT v-num-ped-compra-i,  
                                                        INPUT v-num-ordem-compra-f,
                                                        INPUT v-num-ordem-compra-i,
                                                        INPUT v-cod-item-f,        
                                                        INPUT v-cod-item-i,        
                                                        INPUT v-dat-pedido-f,      
                                                        INPUT v-dat-pedido-i
                                                    &endif ).             
                 
                 RUN openQuery IN {&hDBOSon1} (INPUT 2).                
                 
                 IF iRepositionPageNumber = 0 THEN
                    RUN findFirst IN {&hDBOSon1}.
                 
                 run retornaTTordemcompra IN {&hDBOSon1} (OUTPUT TABLE tt-ordem-compra).                                              
                 
            &ELSE
                 RUN openQueryStatic IN {&hDBOSon1} (INPUT "CodEstabel":U).
                 run retornaTTordemCompra IN {&hDBOSon1} (OUTPUT TABLE tt-ordem-compra).
            &ENDIF      
            {&OPEN-QUERY-brSon1}
            APPLY "VALUE-CHANGED":U TO BROWSE brson1.
        end.
        else if i-classif = 2 THEN do:
            /*********
            run setConstraint4 in {&hDBOSon1} (input tt-embarque-imp.r-rowid).
                
            run OpenQuery in {&hDBOSon1} (input 4).
            run findFirst in {&hDBOSon1}.
            
            run serverSendRows in {&hDBOSon1} (input ?,
                                             input ?,
                                             input no,
                                             input ?,
                                             output rowsreturn,
                                             output table {&ttSon1}).        
           
            {masterdetail/OpenQueriesSon.i
                    &Parent="tt-embarque-imp"
                    &Query="CodEstabel"
                    &PageNumber="1"
                    &QueryConstraint="4"
                    &ConstraintParameters="r-embarque-imp"}                   
            **********/
            &IF DEFINED(DBOVersion) <> 0 &THEN
                RUN setConstraint2 IN {&hDBOSon1} (INPUT r-embarque-imp
                                                    &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &THEN ,
                                                        INPUT v-cod-proces-imp-f,  
                                                        INPUT v-cod-proces-imp-i,  
                                                        INPUT v-num-ped-compra-f,  
                                                        INPUT v-num-ped-compra-i,  
                                                        INPUT v-num-ordem-compra-f,
                                                        INPUT v-num-ordem-compra-i,
                                                        INPUT v-cod-item-f,        
                                                        INPUT v-cod-item-i,        
                                                        INPUT v-dat-pedido-f,      
                                                        INPUT v-dat-pedido-i
                                                    &endif ).
                RUN openQuery IN {&hDBOSon1} (INPUT 4).
                IF iRepositionPageNumber = 0 THEN
                   RUN findFirst IN {&hDBOSon1}.
                run retornaTTordemCompra IN {&hDBOSon1} (OUTPUT TABLE tt-ordem-compra).                                                  
            &ELSE
                RUN openQueryStatic IN {&hDBOSon1} (INPUT "CodEstabel":U).
                run retornaTTordemCompra IN {&hDBOSon1} (OUTPUT TABLE tt-ordem-compra).
            &ENDIF            
            {&OPEN-QUERY-brSon1}
            APPLY "VALUE-CHANGED":U TO BROWSE brson1.
            
        end.
    end.
    else do:
        {&OPEN-QUERY-brSon1}
        APPLY "VALUE-CHANGED":U TO BROWSE brson1.
        
        run openquerybrson3 in this-procedure.
    end.

    run openQuerybrSon2 in this-procedure.
        
    if l-relaciona = no then do:
        find first tt-ordem-compra no-error.
        if avail tt-ordem-compra then
            enable btQtde 
                   with frame fPage1.
        else 
            disable btQtde 
                    with frame fPage1.
    end.                        
    else do:
        find first tt-prazo-compra no-error.
        if avail tt-prazo-compra then
            enable btQtde 
                   with frame fPage1.
        else 
            disable btQtde 
                    with frame fPage1.    
        
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybrSon2 wMasterDetail 
PROCEDURE openQuerybrSon2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    run setConstraint4 in h-bocx225 (input tt-embarque-imp.embarque,
                                     input tt-embarque-imp.cod-estabel).
        
    run OpenQuery in h-bocx225 (input 4).
    run findFirst in h-bocx225.
    
    run serverSendRows in h-bocx225 (input ?,
                                     input ?,
                                     input no,
                                     input ?,
                                     output rowsreturn,
                                     output table {&ttSon2}).
    {&OPEN-QUERY-brSon2}
    apply "VALUE-CHANGED":U to browse brSon2.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openquerybrson3 wMasterDetail 
PROCEDURE openquerybrson3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each tt-prazo-compra:
        delete tt-prazo-compra.
    end.
   if i-classif = 1 then do:
       
       IF  AVAILABLE tt-embarque-imp THEN DO:
           
           /* ***************************  Main Block  *************************** */
            &IF DEFINED(DBOVersion) <> 0 &THEN
                 
                 RUN setConstraint2 IN h-boin356aa (INPUT r-embarque-imp
                                                    &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &THEN ,
                                                        INPUT v-cod-proces-imp-f,  
                                                        INPUT v-cod-proces-imp-i,  
                                                        INPUT v-num-ped-compra-f,  
                                                        INPUT v-num-ped-compra-i,  
                                                        INPUT v-num-ordem-compra-f,
                                                        INPUT v-num-ordem-compra-i,
                                                        INPUT v-cod-item-f,        
                                                        INPUT v-cod-item-i,        
                                                        INPUT v-dat-pedido-f,      
                                                        INPUT v-dat-pedido-i
                                                    &endif 
                                                    ).
                 RUN openQuery IN h-boin356aa (INPUT 2).                
                 IF iRepositionPageNumber = 0 THEN
                    RUN findFirst IN h-boin356aa.
                 run retornaTTprazoCompra IN h-boin356aa (OUTPUT TABLE tt-prazo-compra).                                                                             
            &ELSE
                 
                 RUN openQueryStatic IN h-boin356aa (INPUT "CodEstabel":U).
                 run retornaTTprazoCompra IN h-boin356aa (OUTPUT TABLE tt-prazo-compra).
            &ENDIF
       END.
    end.
    ELSE if i-classif = 2 THEN do:
        
        IF  AVAILABLE tt-embarque-imp THEN DO:
          /* ***************************  Main Block  *************************** */
            &IF DEFINED(DBOVersion) <> 0 
            &THEN
                
                RUN setConstraint2 IN h-boin356aa (INPUT r-embarque-imp
                                                   &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &THEN ,
                                                        input v-cod-proces-imp-f,  
                                                        input v-cod-proces-imp-i,  
                                                        input v-num-ped-compra-f,  
                                                        input v-num-ped-compra-i,  
                                                        input v-num-ordem-compra-f,
                                                        input v-num-ordem-compra-i,
                                                        input v-cod-item-f,        
                                                        input v-cod-item-i,        
                                                        input v-dat-pedido-f,      
                                                        input v-dat-pedido-i
                                                   &endif).
                RUN openQuery IN h-boin356aa (INPUT 4).
                IF iRepositionPageNumber = 0 THEN
                   RUN findFirst IN h-boin356aa.
                run retornaTTprazoCompra IN h-boin356aa (OUTPUT TABLE tt-prazo-compra).                                                  
            &ELSE
                
                RUN openQueryStatic IN h-boin356aa (INPUT "CodEstabel":U).
                run retornaTTprazoCompra IN h-boin356aa (OUTPUT TABLE tt-prazo-compra).
            &ENDIF
        END.
    end.
    ELSE if i-classif = 3 THEN do:
        
        IF  AVAILABLE tt-embarque-imp THEN DO:
          /* ***************************  Main Block  *************************** */
            &IF DEFINED(DBOVersion) <> 0 
            &THEN
                
                RUN setConstraint2 IN h-boin356aa (INPUT r-embarque-imp
                                                   &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &THEN ,
                                                        input v-cod-proces-imp-f,  
                                                        input v-cod-proces-imp-i,  
                                                        input v-num-ped-compra-f,  
                                                        input v-num-ped-compra-i,  
                                                        input v-num-ordem-compra-f,
                                                        input v-num-ordem-compra-i,
                                                        input v-cod-item-f,        
                                                        input v-cod-item-i,        
                                                        input v-dat-pedido-f,      
                                                        input v-dat-pedido-i
                                                   &endif).
                RUN openQuery IN h-boin356aa (INPUT 5).
                IF iRepositionPageNumber = 0 THEN
                   RUN findFirst IN h-boin356aa.
                run retornaTTprazoCompra IN h-boin356aa (OUTPUT TABLE tt-prazo-compra).                                                  
            &ELSE
                
                RUN openQueryStatic IN h-boin356aa (INPUT "CodEstabel":U).
                run retornaTTprazoCompra IN h-boin356aa (OUTPUT TABLE tt-prazo-compra).
            &ENDIF
        END.
    end.

    
    {&OPEN-QUERY-brSon3}
    APPLY "VALUE-CHANGED":U TO BROWSE brson3.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-bt-sel wMasterDetail 
PROCEDURE pi-bt-sel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   if v-passou = no then 
        assign v-cod-proces-imp-f   = "ZZZZZZZZZZZZ"
               v-cod-proces-imp-i   = ""
               v-num-ped-compra-f   = 99999999
               v-num-ped-compra-i   = 0
               v-num-ordem-compra-f = 99999999
               v-num-ordem-compra-i = 0
               v-cod-item-f         = "ZZZZZZZZZZZZZZZZ"
               v-cod-item-i         = ""
               v-dat-pedido-f       = 12/31/9999
               v-dat-pedido-i       = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
               v-passou             = yes.

   assign l-cria = no.

   RUN imp/im0045pr.w(INPUT-OUTPUT v-cod-proces-imp-f,  
                      INPUT-OUTPUT v-cod-proces-imp-i,  
                      INPUT-OUTPUT v-num-ped-compra-f,  
                      INPUT-OUTPUT v-num-ped-compra-i,  
                      INPUT-OUTPUT v-num-ordem-compra-f,
                      INPUT-OUTPUT v-num-ordem-compra-i,
                      INPUT-OUTPUT v-cod-item-f,        
                      INPUT-OUTPUT v-cod-item-i,        
                      INPUT-OUTPUT v-dat-pedido-f,      
                      INPUT-OUTPUT v-dat-pedido-i,
                      OUTPUT       l-cria).
   IF l-cria THEN DO:
       RUN openQueriesSon IN THIS-PROCEDURE.
   END.
   ELSE DO:
       assign v-cod-proces-imp-f   = ""
              v-cod-proces-imp-i   = ""
              v-cod-fornec-f       = 0
              v-cod-fornec-i       = 0
              v-num-ped-compra-f   = 0
              v-num-ped-compra-i   = 0
              v-num-ordem-compra-f = 0
              v-num-ordem-compra-i = 0
              v-cod-item-f         = ""
              v-cod-item-i         = ""
              v-dat-pedido-f       = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
              v-dat-pedido-i       = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
              v-passou             = NO.


       IF l-relaciona THEN
           RUN openquerybrson3 IN THIS-PROCEDURE.
   END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-nova-parcela wMasterDetail 
PROCEDURE pi-valida-nova-parcela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def variable p-qtde-emb     as decimal no-undo.
    def variable p-qtde-n-emb   as decimal no-undo.
    def variable de-quant-aloc  as decimal no-undo.
    def variable de-quant-receb as decimal no-undo.
    
    if l-relaciona = no THEN do:
        IF NOT VALID-HANDLE(h-boin356) THEN 
           RUN inbo/boin356.p persistent set h-boin356.
           
        run QuantCC0509A in h-boin356 (input  tt-ordem-compra.numero-ordem,
                                       output p-qtde-emb    ,
                                       output p-qtde-n-emb  ,
                                       output de-quant-aloc ,
                                       output de-quant-receb,
                                       output c-data-entrega).                                       
        delete procedure h-boin356.                               
    end.

    RUN imp/im9997.p(INPUT  v-cod-estabel ,
                     INPUT  v-qtde-emb    , 
                     INPUT  v-qtde-n-emb  ,
                     INPUT  date(c-data-entrega),
                     OUTPUT v-nova-entrega,
                     OUTPUT v-retorno).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiValidaViaTransp wMasterDetail 
PROCEDURE PiValidaViaTransp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        DEF INPUT  PARAM p-ordem       LIKE ordem-compra.numero-ordem NO-UNDO.
        DEF OUTPUT PARAM p-via-transp  AS LOGICAL                     NO-UNDO.
        DEF OUTPUT PARAM p-primer-ord  AS LOGICAL                     NO-UNDO.

        RUN validaViaTranspPedxEmbarq IN h-bocx225  (INPUT  tt-embarque-imp.embarque,      
                                                     INPUT  tt-embarque-imp.cod-estabel,  
                                                     INPUT  1,
                                                     INPUT  p-ordem,  
                                                     OUTPUT p-via-transp,
                                                     OUTPUT p-primer-ord ).
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaDespachanteInformado wMasterDetail 
PROCEDURE piVerificaDespachanteInformado :
/*------------------------------------------------------------------------------
  Purpose:     Valida a informaá∆o do despachante que ser† utilizado na vinculaá∆o
               das antecipaá‰es via IM0055 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN Return_numRowsReturned IN h-bocx225(INPUT tt-embarque-imp.cod-estabel,
                                            INPUT tt-embarque-imp.embarque,
                                            OUTPUT i-num-ordens-vinculadas).

    IF  i-num-ordens-inicial < i-num-ordens-vinculadas THEN DO:
        /*verifica se o registro vinculado Ç diferente */
        RUN piValidaDespachanteSalvoIFRIC IN h-bocx220(INPUT tt-embarque-imp.cod-estabel,
                                                       INPUT tt-embarque-imp.embarque,
                                                       output table RowErrors).
        
    END.
    ELSE DO: /*desvinculou a mesma quantidade de registros que vinculou*/
        IF i-num-ordens-inicial = i-num-ordens-vinculadas THEN DO:
            FOR EACH tt-ordens-embarque-comp:
                IF NOT CAN-FIND(FIRST {&ttSon2} 
                                WHERE {&ttSon2}.numero-ordem = tt-ordens-embarque-comp.numero-ordem
                                  AND {&ttSon2}.parcela      = tt-ordens-embarque-comp.parcela) THEN DO:
                    RUN piValidaDespachanteSalvoIFRIC IN h-bocx220(INPUT tt-embarque-imp.cod-estabel,
                                                                   INPUT tt-embarque-imp.embarque,
                                                                   output table RowErrors).
                END.
            END.
        END.
    END.
    IF  CAN-FIND(FIRST RowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="yes"}
                
    END. 
    {method/showmessage.i1}

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-spp-via-transp-dif wMasterDetail 
PROCEDURE retorna-spp-via-transp-dif :
/*------------------------------------------------------------------------------
  Purpose: Quando esta funá∆o estiver ativada o programa ir† apresentar um alerta avisando
  que a via de transporte da ordem Ç diferente da via de transporte do embarque.
  Se a funá∆o n∆o estiver ativada, o programa ir† informar que esta diferente, permitindo 
  relacionar e atualizar o embarque. A partir da segunda ordem n∆o ser† permitido vincular
  ordens com via de transporte diferente.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER l-resultado    AS LOG NO-UNDO.
  
IF CAN-FIND (funcao 
            WHERE cd-funcao = 'spp-via-transp-dif'
            AND   ativo     = YES) THEN
    ASSIGN l-resultado =TRUE.
ELSE
    ASSIGN l-resultado =FALSE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaNovaDataEntrega wMasterDetail 
PROCEDURE ValidaNovaDataEntrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     RUN validaNovaDataEntrega IN h-bocx225 (INPUT i-numero-ordem,
                                             INPUT v-nova-entrega,
                                             OUTPUT TABLE RowErrors).

     FOR EACH RowErrors:
         CREATE RowErrorsAux.
         BUFFER-COPY RowErrors TO RowErrorsAux.
         DELETE RowErrors.
     END.

     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
  (input pnum-ordem as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
       
    RUN findOrdem IN h-boin274 (INPUT pnum-ordem, 
                                OUTPUT c-return).
  
    RUN getCharField IN h-boin274 (INPUT "it-codigo":U, 
                                   OUTPUT c-descricao).    

    RETURN c-descricao.
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnProcesso wMasterDetail 
FUNCTION fnProcesso RETURNS CHARACTER
  ( input p-num-pedido as integer ) :
  
  assign cf-nr-proc-imp = "".  
  run findPedido in h-bocx140 (input p-num-pedido,output c-return).
  if c-return = "" then
    run getCharfield in h-bocx140 (input "nr-proc-imp":U,output cf-nr-proc-imp).

  RETURN cf-nr-proc-imp.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnprocessoprazo wMasterDetail 
FUNCTION fnprocessoprazo RETURNS CHARACTER
  ( input p-numero-ordem as integer ) :
  assign cf-nr-proc-imp = "".

  run retornapedido in h-boin356aa (input  p-numero-ordem,
                                    output i-numero-ped).

  run findPedido in h-bocx140 (input i-numero-ped,output c-return).

  if c-return = "" then
    run getCharfield in h-bocx140 (input "nr-proc-imp":U,output cf-nr-proc-imp).

  RETURN cf-nr-proc-imp.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnQtde wMasterDetail 
FUNCTION fnQtde RETURNS decimal
    ():
/*------------------------------------------------------------------------------
**
** Retorna quantidade disponivel para embarque
**
------------------------------------------------------------------------------*/
    FIND tt-ordem-quant 
        WHERE tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem NO-ERROR.
        
    IF NOT AVAIL tt-ordem-quant THEN DO:    
        CREATE tt-ordem-quant.
        ASSIGN tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem
               tt-ordem-quant.r-rowid      = tt-ordem-compra.r-rowid.

        RUN pi-calculaQtdeDisponivel IN h-bocx225 (INPUT tt-ordem-compra.numero-ordem,
                                                   OUTPUT de-quant-disp).
        ASSIGN tt-ordem-quant.quantidade = de-quant-disp.
    END.

    IF c-nom-prog-upc-mg97 <> "" THEN DO:
        run value(c-nom-prog-upc-mg97) (input "CalculaQtdeDisponivel":U,
                                        input "CalculaQtdeDisponivel":U,
                                        input buffer tt-ordem-compra:handle,
                                        input frame fpage0:handle,
                                        input string(tt-ordem-compra.numero-ordem),
                                        input if available tt-ordem-compra then tt-ordem-compra.r-rowid else ?) no-error.
    
        IF RETURN-VALUE = "YES" THEN DO:
            RUN pi-calculaQtdeDisponivel IN h-bocx225 (INPUT tt-ordem-compra.numero-ordem,
                                                       OUTPUT de-quant-disp).
    
            ASSIGN tt-ordem-quant.quantidade = de-quant-disp.
        END.
    END.

    RETURN tt-ordem-quant.quantidade.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnQtdeFornec wMasterDetail 
FUNCTION fnQtdeFornec RETURNS decimal
    ():
/*------------------------------------------------------------------------------
**
** Retorna quantidade relatada pelo fornecedor
**
------------------------------------------------------------------------------*/
    FIND tt-ordem-quant WHERE tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem NO-LOCK NO-ERROR.
        
    IF NOT AVAIL tt-ordem-quant THEN DO:    
        CREATE tt-ordem-quant.
        ASSIGN tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem
               tt-ordem-quant.r-rowid      = tt-ordem-compra.r-rowid.
    END.

    RUN pi-calculaQtdeDisponivelFornec IN h-bocx225 (INPUT tt-ordem-compra.numero-ordem,
                                                     OUTPUT de-quant-disp-forn).
    ASSIGN tt-ordem-quant.qtd-do-forn = de-quant-disp-forn.

    RETURN tt-ordem-quant.qtd-do-forn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUn wMasterDetail 
FUNCTION fnUn RETURNS CHARACTER
  (INPUT c-it-codigo AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR c-codigo-un LIKE ITEM.un INIT "" NO-UNDO.

    if l-relaciona = no then do:
        FIND tt-ordem-quant WHERE tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-ordem-quant THEN DO:    
            CREATE tt-ordem-quant.
            ASSIGN tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem
                   tt-ordem-quant.r-rowid      = tt-ordem-compra.r-rowid.
        END.
        
        RUN gotokey IN h-boin172(INPUT c-it-codigo).         
        RUN getCharField IN h-boin172(INPUT "un", OUTPUT c-codigo-un). 
        ASSIGN tt-ordem-quant.un = c-codigo-un.
    
        RETURN tt-ordem-quant.un.   /* Function return value. */
    END.
    ELSE DO:
        RUN gotokey IN h-boin172(INPUT c-it-codigo).         
        RUN getCharField IN h-boin172(INPUT "un", OUTPUT c-codigo-un). 
        
        RETURN c-codigo-un.   /* Function return value. */
    END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnFornec wMasterDetail 
FUNCTION fnUnFornec RETURNS CHARACTER
  (INPUT i-numero-ordem AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR c-codigo-un-fornec LIKE cotacao-item.un INIT "" NO-UNDO.

    if l-relaciona = no then do:
        FIND tt-ordem-quant WHERE tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-ordem-quant THEN DO:    
            CREATE tt-ordem-quant.
            ASSIGN tt-ordem-quant.numero-ordem = tt-ordem-compra.numero-ordem
                   tt-ordem-quant.r-rowid      = tt-ordem-compra.r-rowid.
        END.
        
        RUN goToCotacaoAprovada IN h-boin082(INPUT i-numero-ordem).         
        RUN getCharField IN h-boin082(INPUT "un", OUTPUT c-codigo-un-fornec). 
        ASSIGN tt-ordem-quant.un-fornec = c-codigo-un-fornec.
    
        RETURN tt-ordem-quant.un-fornec.   /* Function return value. */
    END.
    ELSE DO:
        RUN goToCotacaoAprovada IN h-boin082(INPUT i-numero-ordem).         
        RUN getCharField IN h-boin082(INPUT "un", OUTPUT c-codigo-un-fornec). 
        
        RETURN c-codigo-un-fornec.   /* Function return value. */
    END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUniMed wMasterDetail 
FUNCTION fnUniMed RETURNS CHARACTER
  (INPUT c-it-codigo AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR c-codigo-un LIKE ITEM.un INIT "" NO-UNDO.

    RUN gotokey IN h-boin172(INPUT c-it-codigo).         
    RUN getCharField IN h-boin172(INPUT "un", OUTPUT c-codigo-un). 
    
    RETURN c-codigo-un.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUniMedFornec wMasterDetail 
FUNCTION fnUniMedFornec RETURNS CHARACTER
  (INPUT i-numero-ordem AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR c-codigo-un-fornec LIKE cotacao-item.un INIT "" NO-UNDO.

    RUN goToCotacaoAprovada IN h-boin082(INPUT i-numero-ordem).         
    RUN getCharField IN h-boin082(INPUT "un", OUTPUT c-codigo-un-fornec). 
    
    RETURN c-codigo-un-fornec.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

