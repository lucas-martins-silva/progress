&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cot-ordem NO-UNDO LIKE cot-ordem
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-cot-ordem2 NO-UNDO LIKE cot-ordem
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-desp-cot-ordem NO-UNDO LIKE desp-cot-ordem
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
{include/i-prgvrs.i IM0015 2.00.00.035 } /*** 010035 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0015 MIM}
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
{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar validação produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0015
&GLOBAL-DEFINE Version        2.00.00.035
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FramesHandle     STRING(FRAME fPage1:HANDLE) + ",":U + ~
                                STRING(FRAME fPage2:HANDLE)
&GLOBAL-DEFINE FolderLabels     Ordens ,Despesas

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        YES
&GLOBAL-DEFINE CopyParent       YES
&GLOBAL-DEFINE DeleteParent     YES

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE AddSon2          YES
&GLOBAL-DEFINE UpdateSon2       YES
&GLOBAL-DEFINE DeleteSon2       YES

&GLOBAL-DEFINE ttParent         tt-cot-ordem
&GLOBAL-DEFINE hDBOParent       h-bocx300
&GLOBAL-DEFINE DBOParentTable   cot-ordem

&GLOBAL-DEFINE ttSon1           tt-cot-ordem2
&GLOBAL-DEFINE hDBOSon1         h-bocx3002
&GLOBAL-DEFINE DBOSon1Table     cot-ordem

&GLOBAL-DEFINE ttSon2           tt-desp-cot-ordem
&GLOBAL-DEFINE hDBOSon2         h-bocx305
&GLOBAL-DEFINE DBOSon2Table     desp-cot-ordem

&GLOBAL-DEFINE page2Widgets     btCalculaValor

&GLOBAL-DEFINE page0Fields      tt-cot-ordem.cod-agrup ~
                                tt-cot-ordem.mapa-ordem ~
                                tt-cot-ordem.cod-itiner ~
                                tt-cot-ordem.cod-incoterm ~
                                tt-cot-ordem.mapa-aprovado

&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      brSon2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
def var cItem        as char     no-undo.
def var cDescItem    as char     no-undo.
def var cEmitente    as char     no-undo.
def var cQtde        as decimal  no-undo.
def var cQtdeFornec  as decimal  no-undo.
def var cPreco       as decimal  no-undo.
def var cPrecoFornec as decimal  no-undo.
def var imoeda       as integer  no-undo.
def var cMoeda       as char     no-undo.
def var cDescDesp    like desp-imp.descricao no-undo.
def var cTipoDesp    as char format "x(20)"  no-undo.
def var cUn          as char     no-undo.
def var cUnFornec    as char     no-undo.
def var cDescCondPag as char    no-undo.

def var h-boin274   as handle   no-undo.
def var h-boad098   as handle   no-undo.
def var h-boin172   as handle   no-undo.
def var h-boun005   as handle   no-undo.
def var h-bocx095   as handle   no-undo.
def var h-bocx115   as handle   no-undo.
def var h-boin082   as handle   no-undo.
def var h-boad039   as handle   no-undo.

def var c-return             as char                        no-undo.
def var c-nome-abrev         like emitente.nome-abrev       no-undo.
def var c-it-codigo          like item.it-codigo            no-undo.
def var c-desc-item          like item.descricao-1          no-undo.
def var d-qtde               like prazo-compra.quantidade   no-undo.
def var d-qtde-fornec        like prazo-compra.qtd-do-forn  no-undo.
def var de-preco-unit        like cotacao-item.preco-unit   no-undo.
def var de-preco-unit-fornec like cotacao-item.pre-unit-for no-undo.
def var de-total             like cotacao-item.preco-unit   no-undo.
def var de-total-aux         like cotacao-item.preco-unit   no-undo.
def var i-mo-codigo          like cotacao-item.mo-codigo    no-undo.
def var c-desc-moeda         like moeda.descricao           no-undo.
def var c-desc-desp          like desp-imp.descricao        no-undo.
def var c-tipo-desp          as char format "x(12)"         no-undo.
def var i-tipo               as integer                     no-undo.
def var c-descricao          as char                        no-undo.
def var c-un                 as char                        no-undo.
def var c-un-fornec          as char                        no-undo.
def var c-item               as char                        no-undo.
def var c-desc-cond-pag      as char                        no-undo.

{cdp/cdcfgmat.i} /* Definicao de pre-processadores */

def new global shared var is-cod-itiner as integer no-undo.

&if "{&bf_mat_versao_ems}" >= "2.05" &then
  def var h-boad259 as handle no-undo.
  def var c-desc-tp-despesa like tipo-rec-desp.descricao no-undo.
&endif

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
&Scoped-define INTERNAL-TABLES tt-cot-ordem2 tt-desp-cot-ordem

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-cot-ordem2.numero-ordem tt-cot-ordem2.cod-emitente fnEmitente(input tt-cot-ordem2.cod-emitente) @ cEmitente fnItem(input tt-cot-ordem2.numero-ordem) @ cItem fnDescItem() @ cDescItem tt-cot-ordem2.data-1 &if defined(bf-mat-comex) &then &else tt-cot-ordem2.seq-cotac &endif fnmoeda(input tt-cot-ordem2.numero-ordem, input tt-cot-ordem2.cod-emitente, input tt-cot-ordem2.data-1 &if defined(bf-mat-comex) &then &else ,input tt-cot-ordem2.seq-cotac &endif) @ iMoeda fnDescmoeda() @ cMoeda fnQtde(input tt-cot-ordem2.numero-ordem) @ cQtde fnUn() @ cUn fnQtdeFornec (input tt-cot-ordem2.numero-ordem) @ cQtdeFornec fnUnFornec(input tt-cot-ordem2.numero-ordem, input tt-cot-ordem2.cod-emitente, input tt-cot-ordem2.seq-cotac, input tt-cot-ordem2.data-1) @ cUnFornec fnPreco(input tt-cot-ordem2.numero-ordem, input tt-cot-ordem2.cod-emitente, input tt-cot-ordem2.data-1 &if defined(bf-mat-comex) &then &else ,input tt-cot-ordem2.seq-cotac &endif) @ cPreco fnPrecoFornec(input tt-cot-ordem2.numero-ordem, input tt-cot-ordem2.cod-emitente, input tt-cot-ordem2.data-1 &if defined(bf-mat-comex) &then &else ,input tt-cot-ordem2.seq-cotac &endif) @ cPrecoFornec fnTotal() @ de-total   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-cot-ordem2 NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-cot-ordem2 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-cot-ordem2
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-cot-ordem2


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-desp-cot-ordem.sequencia tt-desp-cot-ordem.cod-emitente-desp fnEmitente(input tt-desp-cot-ordem.cod-emitente-desp) @ cEmitente tt-desp-cot-ordem.cod-desp fnDespesa(tt-desp-cot-ordem.cod-desp) @ cDescdesp tt-desp-cot-ordem.val-desp tt-desp-cot-ordem.mo-codigo fnMoeda2(tt-desp-cot-ordem.mo-codigo) @ cMoeda &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN tt-desp-cot-ordem.log-recalc-val &ENDIF tt-desp-cot-ordem.nr-tab tt-desp-cot-ordem.cod-cond-pag fnDescCondPag(tt-desp-cot-ordem.cod-cond-pag) @ cDescCondPag &if "{&bf_mat_versao_ems}" >= "2.05" &then tt-desp-cot-ordem.tp-despesa fn-desc-tp-despesa(tt-desp-cot-ordem.tp-despesa) @ c-desc-tp-despesa &endif fnTipoDespesa() @ cTipoDesp &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN tt-desp-cot-ordem.cod-incoterm-rat &ELSE SUBSTRING(tt-desp-cot-ordem.char-1,1,3) &ENDIF   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2   
&Scoped-define SELF-NAME brSon2
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-desp-cot-ordem NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY {&SELF-NAME} FOR EACH tt-desp-cot-ordem NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-desp-cot-ordem
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-desp-cot-ordem


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-cot-ordem.cod-agrup ~
tt-cot-ordem.mapa-ordem tt-cot-ordem.cod-incoterm tt-cot-ordem.cod-itiner ~
tt-cot-ordem.mapa-aprovado 
&Scoped-define ENABLED-TABLES tt-cot-ordem
&Scoped-define FIRST-ENABLED-TABLE tt-cot-ordem
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btDelete btQueryJoins btReportsJoins ~
btExit btHelp c-desc-itinerario 
&Scoped-Define DISPLAYED-FIELDS tt-cot-ordem.cod-agrup ~
tt-cot-ordem.mapa-ordem tt-cot-ordem.cod-incoterm tt-cot-ordem.cod-itiner ~
tt-cot-ordem.mapa-aprovado 
&Scoped-define DISPLAYED-TABLES tt-cot-ordem
&Scoped-define FIRST-DISPLAYED-TABLE tt-cot-ordem
&Scoped-Define DISPLAYED-OBJECTS c-desc-itinerario 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-tp-despesa wMasterDetail 
FUNCTION fn-desc-tp-despesa RETURNS CHARACTER
  ( input i-tp-despesa as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescCondPag wMasterDetail 
FUNCTION fnDescCondPag RETURNS CHARACTER
  (input p-cod-cond-pag as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wMasterDetail 
FUNCTION fnDescItem RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescmoeda wMasterDetail 
FUNCTION fnDescmoeda RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDespesa wMasterDetail 
FUNCTION fnDespesa RETURNS CHARACTER
  ( input p-cod-desp as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEmitente wMasterDetail 
FUNCTION fnEmitente RETURNS CHARACTER
  (input pcod-emitente as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
  (input pnum-ordem as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMoeda wMasterDetail 
FUNCTION fnMoeda RETURNS INTEGER
   (input pnum-ordem as integer,
    input pcod-emitente as integer,
    input pda-cotacao as date
    &if defined(bf-mat-comex) &then        
    &else
        ,input pseq-cotac as integer
    &endif
    ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMoeda2 wMasterDetail 
FUNCTION fnMoeda2 RETURNS CHARACTER
  (input p-mo-codigo as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPreco wMasterDetail 
FUNCTION fnPreco RETURNS DECIMAL
   (input pnum-ordem as integer,
    input pcod-emitente as integer,
    input pda-cotacao as date
    &if defined(bf-mat-comex) &then        
    &else
        ,input pseq-cotac as integer
    &endif
    ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPrecoFornec wMasterDetail 
FUNCTION fnPrecoFornec RETURNS DECIMAL
    (input pnum-ordem as integer,
    input pcod-emitente as integer,
    input pda-cotacao as date
    &if defined(bf-mat-comex) &then        
    &else
        ,input pseq-cotac as integer
    &endif
    ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnQtde wMasterDetail 
FUNCTION fnQtde RETURNS DECIMAL
  (input pnum-ordem as integer) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnQtdeFornec wMasterDetail 
FUNCTION fnQtdeFornec RETURNS DECIMAL
  (input pnum-ordem as integer) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipoDespesa wMasterDetail 
FUNCTION fnTipoDespesa RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTotal wMasterDetail 
FUNCTION fnTotal RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUn wMasterDetail 
FUNCTION fnUn RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnFornec wMasterDetail 
FUNCTION fnUnFornec RETURNS CHARACTER
  (input p-numero-ordem as integer,
   input p-cod-emitente as integer,
   input p-seq-cotac    as integer,
   input p-data-cotac   as date)  FORWARD.

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
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image~\im-add":U
     IMAGE-INSENSITIVE FILE "image~\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btAprova 
     IMAGE-UP FILE "image~\im-chck1":U
     IMAGE-INSENSITIVE FILE "image~\ii-chck1":U
     LABEL "Aprova Grupo" 
     SIZE 4 BY 1.25 TOOLTIP "Aprova Grupo"
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image~\im-copy":U
     IMAGE-INSENSITIVE FILE "image~\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image~\im-era":U
     IMAGE-INSENSITIVE FILE "image~\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDesaprova 
     IMAGE-UP FILE "image~\im-can":U
     IMAGE-INSENSITIVE FILE "image~\ii-can":U
     LABEL "Desaprova Grupo" 
     SIZE 4 BY 1.25 TOOLTIP "Desaprova Grupo"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image~\im-fir":U
     IMAGE-INSENSITIVE FILE "image~\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image~\im-enter":U
     IMAGE-INSENSITIVE FILE "image~\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image~\im-las":U
     IMAGE-INSENSITIVE FILE "image~\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image~\im-nex":U
     IMAGE-INSENSITIVE FILE "image~\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image~\im-pre":U
     IMAGE-INSENSITIVE FILE "image~\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

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

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE c-desc-itinerario AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.13.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon2 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCalculaValor 
     LABEL "Calcula Valor" 
     SIZE 11.14 BY 1 TOOLTIP "Calcula valor despesa conforme tabela de pre‡o.".

DEFINE BUTTON btDeleteSon2 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon2 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-cot-ordem2 SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-desp-cot-ordem SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 DISPLAY
      tt-cot-ordem2.numero-ordem
      tt-cot-ordem2.cod-emitente
      fnEmitente(input tt-cot-ordem2.cod-emitente) @ cEmitente COLUMN-LABEL "Nome Abreviado" FORMAT "x(12)"
      fnItem(input tt-cot-ordem2.numero-ordem) @ cItem COLUMN-LABEL "Item" FORMAT "x(12)"
      fnDescItem() @ cDescItem COLUMN-LABEL "Descri‡Æo" FORMAT "x(30)"
      tt-cot-ordem2.data-1 COLUMN-LABEL "Data Cota‡Æo"
      &if defined(bf-mat-comex) &then      
      &else
          tt-cot-ordem2.seq-cotac
      &endif
      fnmoeda(input tt-cot-ordem2.numero-ordem, 
              input tt-cot-ordem2.cod-emitente, 
              input tt-cot-ordem2.data-1 
              &if defined(bf-mat-comex) 
              &then 
              &else 
                 ,input tt-cot-ordem2.seq-cotac 
              &endif) @ iMoeda COLUMN-LABEL "Moeda"
      fnDescmoeda() @ cMoeda COLUMN-LABEL "Descri‡Æo" FORMAT "x(12)"
      fnQtde(input tt-cot-ordem2.numero-ordem) @ cQtde COLUMN-LABEL "Nossa Qtde" FORMAT ">>>>,>>9.9999"
      fnUn() @ cUn COLUMN-LABEL "UN" FORMAT "x(3)"
      fnQtdeFornec (input tt-cot-ordem2.numero-ordem) @ cQtdeFornec column-label "Qtde Fornec" format ">>>>,>>9.9999"
      fnUnFornec(input tt-cot-ordem2.numero-ordem, 
                 input tt-cot-ordem2.cod-emitente, 
                 input tt-cot-ordem2.seq-cotac, 
                 input tt-cot-ordem2.data-1) @ cUnFornec COLUMN-LABEL "UN Fornec" FORMAT "x(3)"
      fnPreco(input tt-cot-ordem2.numero-ordem, 
              input tt-cot-ordem2.cod-emitente,
              input tt-cot-ordem2.data-1 
              &if defined(bf-mat-comex) 
              &then 
              &else 
                  ,input tt-cot-ordem2.seq-cotac 
              &endif) @ cPreco COLUMN-LABEL "Pre‡o Unit Interno" FORMAT ">>>>>>9.99999"
      fnPrecoFornec(input tt-cot-ordem2.numero-ordem, 
                    input tt-cot-ordem2.cod-emitente,
                    input tt-cot-ordem2.data-1 
                    &if defined(bf-mat-comex) 
                    &then 
                    &else 
                        ,input tt-cot-ordem2.seq-cotac 
                    &endif) @ cPrecoFornec column-label "Pre‡o Unit Fornec" format ">>>>>>9.99999"        
      fnTotal() @ de-total COLUMN-LABEL "Pre‡o Total" FORMAT ">>>>>>9.99999"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 75 BY 9
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _FREEFORM
  QUERY brSon2 DISPLAY
      tt-desp-cot-ordem.sequencia FORMAT ">>9":U
      tt-desp-cot-ordem.cod-emitente-desp FORMAT ">>>>>>>>9":U
      fnEmitente(input tt-desp-cot-ordem.cod-emitente-desp) @ cEmitente COLUMN-LABEL "Nome Abreviado" FORMAT "x(20)":U
      tt-desp-cot-ordem.cod-desp FORMAT ">>,>>9":U
      fnDespesa(tt-desp-cot-ordem.cod-desp) @ cDescdesp COLUMN-LABEL "Descri‡Æo" FORMAT "x(20)":U
      tt-desp-cot-ordem.val-desp FORMAT ">>>>>,>>>,>>9.99999":U
      tt-desp-cot-ordem.mo-codigo FORMAT "99":U
      fnMoeda2(tt-desp-cot-ordem.mo-codigo) @ cMoeda COLUMN-LABEL "Descri‡Æo" FORMAT "x(12)":U
      &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
            tt-desp-cot-ordem.log-recalc-val COLUMN-LABEL "Recalcula Valor":U
      &ENDIF
      tt-desp-cot-ordem.nr-tab FORMAT "X(10)":U
      tt-desp-cot-ordem.cod-cond-pag FORMAT &if "{&bf_mat_versao_ems}" > "2.042" &then ">>>9":U &else ">>9":U &endif
      fnDescCondPag(tt-desp-cot-ordem.cod-cond-pag) @ cDescCondPag COLUMN-LABEL "Descri‡Æo" FORMAT "x(30)":U
      &if "{&bf_mat_versao_ems}" >= "2.05" &then
        tt-desp-cot-ordem.tp-despesa COLUMN-LABEL "Tp Desp"
        fn-desc-tp-despesa(tt-desp-cot-ordem.tp-despesa) @ c-desc-tp-despesa
      &endif
      fnTipoDespesa() @ cTipoDesp COLUMN-LABEL "Tipo" FORMAT "x(20)":U
      &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
          tt-desp-cot-ordem.cod-incoterm-rat COLUMN-LABEL "Incoterm de Rateio"
      &ELSE
          SUBSTRING(tt-desp-cot-ordem.char-1,1,3) COLUMN-LABEL "Incoterm de Rateio"
      &ENDIF
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 75 BY 9
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
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 39 HELP
          "Elimina ocorrˆncia corrente"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     btAprova AT ROW 1.17 COL 48 HELP
          "Altera ocorrˆncia corrente"
     btDesaprova AT ROW 1.17 COL 52 HELP
          "Cancela altera‡äes"
     tt-cot-ordem.cod-agrup AT ROW 2.83 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.29 BY .88
     tt-cot-ordem.mapa-ordem AT ROW 2.83 COL 49 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-cot-ordem.cod-incoterm AT ROW 3.83 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-cot-ordem.cod-itiner AT ROW 3.83 COL 49 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-desc-itinerario AT ROW 3.83 COL 56.43 COLON-ALIGNED NO-LABEL
     tt-cot-ordem.mapa-aprovado AT ROW 4.83 COL 29
          VIEW-AS TOGGLE-BOX
          SIZE 9.86 BY .88
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.96
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.5 COL 5
     btAddSon2 AT ROW 10.5 COL 4.86
     btUpdateSon2 AT ROW 10.5 COL 14.86
     btDeleteSon2 AT ROW 10.5 COL 24.86
     btCalculaValor AT ROW 10.5 COL 34.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.38
         SIZE 84.43 BY 11
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.5 COL 5
     btAddSon1 AT ROW 10.5 COL 5
     btDeleteSon1 AT ROW 10.5 COL 15
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.38
         SIZE 84.43 BY 11
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-cot-ordem T "?" NO-UNDO mgcex cot-ordem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-cot-ordem2 T "?" NO-UNDO mgcex cot-ordem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-desp-cot-ordem T "?" NO-UNDO mgcex desp-cot-ordem
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
         HEIGHT             = 17.96
         WIDTH              = 90
         MAX-HEIGHT         = 27.29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.29
         VIRTUAL-WIDTH      = 146.29
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
       FRAME fPage2:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btAprova IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btDesaprova IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-cot-ordem2 NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-desp-cot-ordem NO-LOCK.
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE (INPUT "imp/im0015a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="imp/im0015m.w"
                           &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon2 wMasterDetail
ON CHOOSE OF btAddSon2 IN FRAME fPage2 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="imp/im0015ad.w"
                           &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btAprova
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAprova wMasterDetail
ON CHOOSE OF btAprova IN FRAME fPage0 /* Aprova Grupo */
DO:

  for each RowErrors:
      delete RowErrors.
  end.
  RUN aprovaGrupo in h-bocx300 (input tt-cot-ordem.r-rowid, output table RowErrors).
    IF CAN-FIND(FIRST RowErrors) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/showmessage.w PERSISTENT SET hShowMsg.
        
        RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
        
        LEAVE.
    END.
    ELSE DO:
        RUN findRowid in h-bocx300 (input tt-cot-ordem.r-rowid).
        RUN getLogField in h-bocx300 (input "mapa-aprovado", output tt-cot-ordem.mapa-aprovado).
        disp tt-cot-ordem.mapa-aprovado 
            with frame fPage0.
        RUN DisplayFields.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCalculaValor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCalculaValor wMasterDetail
ON CHOOSE OF btCalculaValor IN FRAME fPage2 /* Calcula Valor */
DO:
    
    def var d-valor-despesa as decimal no-undo.
    DEF VAR r AS ROWID NO-UNDO.
    def VAR c-cod-grupo        like cot-ordem.cod-agrup     no-undo. 
    def VAR i-mapa-ordem        like cot-ordem.mapa-ordem    no-undo. 
    def VAR i-cod-desp          like desp-imp.cod-desp       no-undo. 
    def VAR i-cod-emitente-desp like emitente.cod-emitente   no-undo. 
    DEF VAR i-sequencia         LIKE desp-cot-ordem.sequencia NO-UNDO.

    GET CURRENT brSon2.
    
    ASSIGN c-cod-grupo         = tt-desp-cot-ordem.cod-agrup
           i-mapa-ordem        = tt-desp-cot-ordem.mapa-ordem
           i-sequencia         = tt-desp-cot-ordem.sequencia
           i-cod-emitente-desp = tt-desp-cot-ordem.cod-emitente-desp
           i-cod-desp          = tt-desp-cot-ordem.cod-desp.


    RUN setttdespcotordem IN h-bocx305 (INPUT tt-desp-cot-ordem.r-rowid,
                                        INPUT-OUTPUT TABLE tt-desp-cot-ordem,
                                        INPUT YES,
                                        OUTPUT d-valor-despesa,
                                        OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/showmessage.w PERSISTENT SET hShowMsg.
        
        RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).

        RUN openQueriesSon IN THIS-PROCEDURE.

        LEAVE.
    END.
    ELSE DO:
        RUN AtualizaValDespDespCotOrdem IN h-bocx305 (input c-cod-grupo,   
                                                      input i-mapa-ordem,  
                                                      INPUT i-sequencia,   
                                                      input i-cod-emitente-desp,
                                                      input i-cod-desp,    
                                                      INPUT d-valor-despesa).

        RUN openQueriesSon IN THIS-PROCEDURE.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    run PassaRowidRegistroCopiado in h-bocx300 (input gr-cot-ordem).
    RUN copyRecord (INPUT "imp/im0015a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN verificaDeletepai in h-bocx300(input yes).
    RUN deleteRecord IN THIS-PROCEDURE.
    RUN verificaDeletepai in h-bocx300(input no).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="1"}    
    run repositionRecord in THIS-PROCEDURE (input rCurrentAux).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDeleteSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon2 wMasterDetail
ON CHOOSE OF btDeleteSon2 IN FRAME fPage2 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="2"}
    RUN openQueriesSon IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDesaprova
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesaprova wMasterDetail
ON CHOOSE OF btDesaprova IN FRAME fPage0 /* Desaprova Grupo */
DO:
    RUN desaprovaGrupo in h-bocx300 (input tt-cot-ordem.r-rowid,
                                     output table RowErrors).
    IF CAN-FIND(FIRST RowErrors) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/showmessage.w PERSISTENT SET hShowMsg.

        RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).        
        LEAVE.
    END.
    ELSE DO:
        RUN findRowid in h-bocx300 (input tt-cot-ordem.r-rowid).
        RUN getLogField in h-bocx300 (input "mapa-aprovado", output tt-cot-ordem.mapa-aprovado).
        disp tt-cot-ordem.mapa-aprovado with frame fPage0.
        RUN DisplayFields.
    END.
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
    {method/zoomreposition.i &ProgramZoom="cxzoom/z01cx300.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btUpdateSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon2 wMasterDetail
ON CHOOSE OF btUpdateSon2 IN FRAME fPage2 /* Alterar */
DO:
    def var h-prog1 as handle no-undo.
    
    if {&FIRST-TABLE-IN-QUERY-brSon2}.cod-emitente-desp = 0 then do:
        {masterdetail/updateson.i &ProgramSon="imp/im0015ad.w"
                                  &PageNumber="2"}
    end.
    else do:
        RUN imp/im0015bd.w persistent set h-prog1 (input "UPDATE":U,
                            input tt-cot-ordem.mapa-ordem,
                            input tt-cot-ordem.cod-agrup,
                            input tt-desp-cot-ordem.cod-emitente-desp,
                            input tt-desp-cot-ordem.nr-tab,
                            input tt-desp-cot-ordem.cod-desp,
                            input tt-desp-cot-ordem.mo-codigo,
                            input tt-desp-cot-ordem.r-rowid).
        /*run initializeinterface in h-prog1.*/
        wait-for close of h-prog1 focus current-window.
  
        {&WINDOW-NAME}:sensitive = yes.
        apply 'entry':U to {&WINDOW-NAME}.                              
    end.
    
    RUN openQueriesSon IN THIS-PROCEDURE.                        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
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
    if valid-handle(h-boin274) then
        DELETE PROCEDURE h-boin274.
    if valid-handle(h-boad098) then
        DELETE PROCEDURE h-boad098.
    if valid-handle(h-boin172) then
        DELETE PROCEDURE h-boin172.
    if valid-handle(h-boun005) then
        DELETE PROCEDURE h-boun005.
    if valid-handle(h-bocx095) then
        DELETE PROCEDURE h-bocx095.
    if valid-handle(h-bocx115) then
        DELETE procedure h-bocx115.
    if valid-handle(h-boin082) then
        DELETE procedure h-boin082.
    if valid-handle(h-boad039) then
        DELETE procedure h-boad039.
    if valid-handle(hShowMsg) then
        DELETE procedure hShowMsg.

    assign h-boin274 = ?
           h-boad098 = ?
           h-boin172 = ?
           h-boun005 = ?
           h-bocx095 = ?
           h-bocx115 = ?
           h-boin082 = ?
           h-boad039 = ?
           hShowMsg  = ?.
                    
    &if "{&bf_mat_versao_ems}" >= "2.05" &then
        if valid-handle(h-boad259) then
            delete procedure h-boad259.
        assign h-boad259 = ?.
    &endif

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
    if  avail tt-desp-cot-ordem then
        enable btCalculaValor with frame fPage2.
    else 
        disable btCalculaValor with frame fPage2.

    if avail tt-cot-ordem then do:
        if tt-cot-ordem.mapa-aprovado = yes then do:
            enable btDesaprova with frame fPage0.
            disable btAprova btDelete with frame fPage0.
            disable btAddSon1 btDeleteSon1 with frame fPage1.
            disable btAddSon2 btDeleteSon2 btUpdateSon2 btCalculaValor with frame fPage2.
        end.   
        else do:
            enable btAprova btDelete with frame fPage0.
            enable btAddSon1 btDeleteSon1 with frame fPage1.
            enable btAddSon2 btDeleteSon2 btUpdateSon2 btCalculaValor with frame fPage2.            
            disable btDesaprova with frame fPage0.
        end.    
      
        run findCodigo in h-bocx115(input tt-cot-ordem.cod-itiner, output c-return).
        if c-return = "" then
            run getCharfield in h-bocx115(input "descricao",output c-descricao).
        assign c-desc-itinerario:screen-value = c-descricao.    

        /* Grava Incoterm para Pesquisa do Ponto de Controle */
        assign is-cod-itiner = tt-cot-ordem.cod-itiner.
    end.
    else do:
        assign tt-cot-ordem.cod-agrup:screen-value in frame fPage0     = ""
               tt-cot-ordem.mapa-ordem:screen-value in frame fPage0    = "0"
               tt-cot-ordem.cod-itiner:screen-value in frame fPage0    = "0"
               tt-cot-ordem.cod-incoterm:screen-value in frame fPage0  = ""
               tt-cot-ordem.mapa-aprovado:screen-value in frame fPage0 = "no".
        disable btAprova 
                btDesaprova 
                with frame fPage0.                
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
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then
    &else
        &if integer(entry(1,proversion,".")) >= 9 &then
        assign brSon1:column-resizable in frame fPage1 = true
               brSon1:column-movable   in frame fPage1 = TRUE
               brSon2:column-resizable in frame fPage2 = true
               brSon2:column-movable   in frame fPage2 = true.
        &endif
    &endif    

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
    
    DEFINE VARIABLE ccod-agrup like tt-cot-ordem.cod-agrup NO-UNDO.
    DEFINE VARIABLE imapa-ordem like tt-cot-ordem.mapa-ordem NO-UNDO.
    DEFINE VARIABLE ccod-incoterm like tt-cot-ordem.cod-incoterm NO-UNDO.
    DEFINE VARIABLE ccod-itiner like tt-cot-ordem.cod-itiner NO-UNDO.

    DEFINE FRAME fGoToRecord
        ccod-agrup AT ROW 1.21 COL 15 COLON-ALIGNED
        imapa-ordem AT ROW 2.21 COL 15 COLON-ALIGNED
        ccod-incoterm AT ROW 3.21 COL 15 COLON-ALIGNED
        ccod-itiner AT ROW 4.21 COL 15 COLON-ALIGNED
        btGoToOK      AT ROW 5.63 COL 2.14
        btGoToCancel  AT ROW 5.63 COL 13
        rtGoToButton  AT ROW 5.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE FONT 1 TITLE "V  Para Cot Ordem"
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Cot_Ordem"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN ccod-agrup imapa-ordem ccod-incoterm ccod-itiner.
        
        &IF DEFINED(DBOVersion) <> 0 &THEN
           RUN findVapara IN {&hDBOParent} (INPUT ccod-agrup,
                                                INPUT imapa-ordem,
                                                INPUT ccod-incoterm,
                                                INPUT ccod-itiner,
                                                OUTPUT cStatus).
           IF cStatus <> "":U THEN DO:
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "CotacÆo_Grupo_Ordem" *}
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
    
    ENABLE ccod-agrup imapa-ordem ccod-incoterm ccod-itiner btGoToOK btGoToCancel 
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
       RUN cxbo/bocx300.p persistent set h-bocx300.
    END.

    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOParent} (INPUT 1).
    &ELSE
        RUN openQueryStatic IN {&hDBOParent} (INPUT "cit-codigo":U).
    &ENDIF

    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) THEN DO:
       RUN cxbo/bocx300.p persistent set h-bocx3002.
    END.    
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) THEN DO:
       RUN cxbo/bocx305.p persistent set h-bocx305.
    END.
    
    RUN inbo/boin274.p persistent set h-boin274.
    RUN adbo/boad098.p persistent set h-boad098.
    RUN inbo/boin172.p persistent set h-boin172.
    RUN unbo/boun005.p persistent set h-boun005.
    RUN cxbo/bocx095.p persistent set h-bocx095.
    RUN cxbo/bocx115.p persistent set h-bocx115. 
    RUN inbo/boin082.p persistent set h-boin082.
    RUN adbo/boad039.p persistent set h-boad039.
    
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
    def var ccod-agrup as char no-undo.
    def var imapa-ordem as integer no-undo.

    if avail tt-cot-ordem then
        assign ccod-agrup  = tt-cot-ordem.cod-agrup
               imapa-ordem = tt-cot-ordem.mapa-ordem.
    else
        assign ccod-agrup  = ""
               imapa-ordem = 0.
    
    {masterdetail/OpenQueriesSon.i
            &Parent="tt-cot-ordem"
            &Query="Grupo"
            &PageNumber="1"
            &QueryConstraint="2"
            &ConstraintParameters="ccod-agrup,imapa-ordem"}
    
    {masterdetail/OpenQueriesSon.i
            &Parent="tt-cot-ordem"
            &Query="Grupo"
            &PageNumber="2"
            &QueryConstraint="2"
            &ConstraintParameters="ccod-agrup,imapa-ordem"}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-tp-despesa wMasterDetail 
FUNCTION fn-desc-tp-despesa RETURNS CHARACTER
  ( input i-tp-despesa as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  &if "{&bf_mat_versao_ems}" >= "2.05" &then
      if not valid-handle(h-boad259) then
          run adbo/boad259.p persistent set h-boad259.

      run findCodigo in h-boad259 (input i-tp-despesa, output c-return).
    
      if c-return = "" then
          run getCharField in h-boad259 (input "descricao", output c-return).
      else
          assign c-return = "".
      
      return c-return.
  &endif
  
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescCondPag wMasterDetail 
FUNCTION fnDescCondPag RETURNS CHARACTER
  (input p-cod-cond-pag as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    run findCodigo in h-boad039(input p-cod-cond-pag,output c-return).
    if c-return = "" then
        run getCharfield in h-boad039(input "descricao",output c-desc-cond-pag).
        
    RETURN c-desc-cond-pag.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wMasterDetail 
FUNCTION fnDescItem RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RUN findCodigo in h-boin172 (input c-it-codigo, output c-return).
    if c-return = "" then  
        RUN getCharField in h-boin172 (input "descricao-1", output c-desc-item).

    RETURN c-desc-item.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescmoeda wMasterDetail 
FUNCTION fnDescmoeda RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    run findCodigo in h-boun005(input i-mo-codigo,output c-return).
    if c-return = "" then 
        run getCharfield in h-boun005(input "descricao",output c-desc-moeda).        

    RETURN c-desc-moeda.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDespesa wMasterDetail 
FUNCTION fnDespesa RETURNS CHARACTER
  ( input p-cod-desp as integer ) :
  
    run findCodigo in h-bocx095(input p-cod-desp,output c-return).
    assign c-desc-desp = ""
           c-tipo-desp = "".
    if c-return = "" then do:
        run getCharfield in h-bocx095(input "descricao",output c-desc-desp).
        run getIntfield in h-bocx095(input "tipo",output i-tipo).
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {cxinc/i01cx010.i 04 i-tipo}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  c-tipo-desp = RETURN-VALUE.
        &else
            ASSIGN c-tipo-desp = {cxinc/i01cx010.i 04 i-tipo}.
        &endif
    end. 

    RETURN c-desc-desp.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEmitente wMasterDetail 
FUNCTION fnEmitente RETURNS CHARACTER
  (input pcod-emitente as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/  
    RUN findCodigo in h-boad098 (input pcod-emitente, output c-return).
    if c-return = "" then  
        RUN getCharField in h-boad098 (input "nome-abrev", output c-nome-abrev).

    RETURN c-nome-abrev.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
  (input pnum-ordem as integer) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    RUN findOrdem in h-boin274 (input pnum-ordem, output c-return).
    if c-return = "" then  
        RUN getCharField in h-boin274 (input "it-codigo", output c-it-codigo).

    RETURN c-it-codigo.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMoeda wMasterDetail 
FUNCTION fnMoeda RETURNS INTEGER
   (input pnum-ordem as integer,
    input pcod-emitente as integer,
    input pda-cotacao as date
    &if defined(bf-mat-comex) &then        
    &else
        ,input pseq-cotac as integer
    &endif
    ): 
      
    run findCotacao2 in h-bocx300 (input  pnum-ordem,
                                   input  pcod-emitente,
                                   input  pda-cotacao,
                                   &if defined(bf-mat-comex) &then
                                   &else
                                       input  pseq-cotac,
                                   &endif
                                   output i-mo-codigo,
                                   output de-preco-unit,
                                   output c-return).
    RETURN i-mo-codigo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMoeda2 wMasterDetail 
FUNCTION fnMoeda2 RETURNS CHARACTER
  (input p-mo-codigo as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    run findCodigo in h-boun005(input p-mo-codigo,output c-return).
    if c-return = "" then
        run getCharfield in h-boun005(input "descricao",output c-desc-moeda).
        
    RETURN c-desc-moeda.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPreco wMasterDetail 
FUNCTION fnPreco RETURNS DECIMAL
   (input pnum-ordem as integer,
    input pcod-emitente as integer,
    input pda-cotacao as date
    &if defined(bf-mat-comex) &then        
    &else
        ,input pseq-cotac as integer
    &endif
    ): 
      
    run findCotacao2 in h-bocx300 (input  pnum-ordem,
                                   input  pcod-emitente,
                                   input  pda-cotacao,
                                   &if defined(bf-mat-comex) &then
                                   &else
                                       input  pseq-cotac,
                                   &endif
                                   output i-mo-codigo,
                                   output de-preco-unit,
                                   output c-return).
    RETURN de-preco-unit.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPrecoFornec wMasterDetail 
FUNCTION fnPrecoFornec RETURNS DECIMAL
    (input pnum-ordem as integer,
    input pcod-emitente as integer,
    input pda-cotacao as date
    &if defined(bf-mat-comex) &then        
    &else
        ,input pseq-cotac as integer
    &endif
    ): 
      
    run findCotacao3 in h-bocx300 (input  pnum-ordem,
                                   input  pcod-emitente,
                                   input  pda-cotacao,
                                   &if defined(bf-mat-comex) &then
                                   &else
                                       input  pseq-cotac,
                                   &endif
                                   output i-mo-codigo,
                                   output de-preco-unit-fornec,
                                   output c-return).
    RETURN de-preco-unit-fornec.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnQtde wMasterDetail 
FUNCTION fnQtde RETURNS DECIMAL
  (input pnum-ordem as integer):

    run findOrdemqt in h-bocx300(input pnum-ordem,
                                 output d-qtde,
                                 output c-return).

    return d-qtde. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnQtdeFornec wMasterDetail 
FUNCTION fnQtdeFornec RETURNS DECIMAL
  (input pnum-ordem as integer):

    run findOrdemQtFornec in h-bocx300(input pnum-ordem,
                                       output d-qtde-fornec,
                                       output c-return).

    return d-qtde-fornec. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipoDespesa wMasterDetail 
FUNCTION fnTipoDespesa RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN c-tipo-desp.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTotal wMasterDetail 
FUNCTION fnTotal RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    assign de-total-aux = d-qtde-fornec * de-preco-unit-fornec.
    
    return de-total-aux.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUn wMasterDetail 
FUNCTION fnUn RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    run findCodigo in h-boin172 (input c-it-codigo, output c-return).
    if c-return = "" then  
        run getCharField in h-boin172 (input "un", output c-un).

  return c-un.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnFornec wMasterDetail 
FUNCTION fnUnFornec RETURNS CHARACTER
  (input p-numero-ordem as integer,
   input p-cod-emitente as integer,
   input p-seq-cotac    as integer,
   input p-data-cotac   as date) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    run findOrdem in h-boin274 (input p-numero-ordem, output c-return).
    if c-return = "" then  
        run getCharField in h-boin274 (input "it-codigo", output c-item).

        run findCotacao in h-boin082(input p-numero-ordem,
                                     input p-cod-emitente,
                                     input c-item,
                                     &if defined(bf-mat-comex) &then
                                        input p-data-cotac,
                                     &else
                                        input p-seq-cotac,
                                     &endif
                                     output c-return).
                                   
       
        run getcharfield in h-boin082(input "un", output c-un-fornec).
            
    RETURN c-un-fornec.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

